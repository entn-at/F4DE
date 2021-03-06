#!/bin/sh
#! -*-perl-*-
eval 'exec env PERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl -x -S $0 ${1+"$@"}'
    if 0;

# -*- mode: Perl; tab-width: 2; indent-tabs-mode: nil -*- # For Emacs
#
# $Id$
#
# TrecVid08 Stat Generator
#
# Author(s): Jonathan Fiscus, Martial Michel
#
# This software was developed at the National Institute of Standards and Technology by
# employees and/or contractors of the Federal Government in the course of their official duties.
# Pursuant to Title 17 Section 105 of the United States Code this software is not subject to 
# copyright protection within the United States and is in the public domain.
#
# "TrecVid08 Stat Generator" is an experimental system.
# NIST assumes no responsibility whatsoever for its use by any party, and makes no guarantees,
# expressed or implied, about its quality, reliability, or any other characteristic.
#
# We would appreciate acknowledgement if the software is used.  This software can be
# redistributed and/or modified freely provided that any derivative works bear some notice
# that they are derived from it, and any modified versions bear some notice that they
# have been modified.
#
# THIS SOFTWARE IS PROVIDED "AS IS."  With regard to this software, NIST MAKES NO EXPRESS
# OR IMPLIED WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING MERCHANTABILITY,
# OR FITNESS FOR A PARTICULAR PURPOSE.

use strict;

# Note: Designed for UNIX style environments (ie use cygwin under Windows).

##########
# Check we have every module (perl wise)

## First insure that we add the proper values to @INC
my (@f4bv, $f4d);
BEGIN {
  if ( ($^V ge 5.18.0)
       && ( (! exists $ENV{PERL_HASH_SEED})
	    || ($ENV{PERL_HASH_SEED} != 0)
	    || (! exists $ENV{PERL_PERTURB_KEYS} )
	    || ($ENV{PERL_PERTURB_KEYS} != 0) )
     ) {
    print "You are using a version of perl above 5.16 ($^V); you need to run perl as:\nPERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl\n";
    exit 1;
  }

  use Cwd 'abs_path';
  use File::Basename 'dirname';
  $f4d = dirname(abs_path($0));

  push @f4bv, ("$f4d/../../lib", "$f4d/../../../common/lib");
}
use lib (@f4bv);

sub eo2pe {
  my @a = @_;
  my $oe = join(" ", @a);
  my $pe = ($oe !~ m%^Can\'t\s+locate%) ? "\n----- Original Error:\n $oe\n-----" : "";
  return($pe);
}

## Then try to load everything
my $have_everything = 1;
my $partofthistool = "It should have been part of this tools' files.";
my $warn_msg = "";

# Part of this tool
foreach my $pn ("MMisc", "TrecVid08ViperFile", "TrecVid08Observation", "ViperFramespan", "ViperFramespan", "SimpleAutoTable", "TrecVid08HelperFunctions") {
  unless (eval "use $pn; 1") {
    my $pe = &eo2pe($@);
    &_warn_add("\"$pn\" is not available in your Perl installation. ", $partofthistool, $pe);
    $have_everything = 0;
  }
}
my $versionkey = MMisc::slurp_file(dirname(abs_path($0)) . "/../../../.f4de_version");
my $versionid = "TrecVid08 Stat Generator ($versionkey)";

# usualy part of the Perl Core
foreach my $pn ("Getopt::Long", "Statistics::Descriptive::Discrete") {
  unless (eval "use $pn; 1") {
    &_warn_add("\"$pn\" is not available on your Perl installation. ", "Please look it up on CPAN [http://search.cpan.org/]\n");
    $have_everything = 0;
  }
}

# Something missing ? Abort
if (! $have_everything) {
  print "\n$warn_msg\nERROR: Some Perl Modules are missing, aborting\n";
  exit(1);
}

# Use the long mode of Getopt
Getopt::Long::Configure(qw(auto_abbrev no_ignore_case));

########################################
# Get some values from TrecVid08ViperFile
my $dummy = new TrecVid08ViperFile();
my @ok_events = $dummy->get_full_events_list();
my @xsdfilesl = $dummy->get_required_xsd_files_list();
# We will use the '$dummy' to do checks before processing files

########################################
# Options processing

my $xmllint_env = "F4DE_XMLLINT";
my $usage = &set_usage();

# Default values for variables
my $show = 0;
my $xmllint = MMisc::get_env_val($xmllint_env, "");
my $xsdpath = "$f4d/../../data";
my $fps = -1;
my $isgtf = 0;
my $docsv = -1;
my $discardErr = 0;

# Av  : ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
# USed:                    T        cd fgh             v x  

my %opt = ();
my $dbgftmp = "";
my @leftover = ();
GetOptions
  (
   \%opt,
   'help',
   'version',
   'xmllint=s'       => \$xmllint,
   'TrecVid08xsd=s'  => \$xsdpath,
   'gtf'             => \$isgtf,
   'fps=s'           => \$fps,
   'csv:s'           => \$docsv,
   'discardErrors'   => \$discardErr,
  ) or MMisc::error_quit("Wrong option(s) on the command line, aborting\n\n$usage\n");

MMisc::ok_quit("\n$usage\n") if ($opt{'help'});
MMisc::ok_quit("$versionid\n") if ($opt{'version'});

MMisc::ok_quit("\n$usage\n") if (scalar @ARGV == 0);

MMisc::error_quit("ERROR: \'fps\' must set in order to do any scoring work") if ($fps == -1);

if ($xmllint ne "") {
  MMisc::error_quit("While trying to set \'xmllint\' (" . $dummy->get_errormsg() . ")")
    if (! $dummy->set_xmllint($xmllint));
}

if ($xsdpath ne "") {
  MMisc::error_quit("While trying to set \'TrecVid08xsd\' (" . $dummy->get_errormsg() . ")")
    if (! $dummy->set_xsdpath($xsdpath));
}

##########
# Main processing
my $tmp = "";
my %all = ();
my $ntodo = scalar @ARGV;
my $ndone = 0;
my @all_observations = ();
my %fileStatsDB = ();
my %camDurStatsDB = ();
while ($tmp = shift @ARGV) {
  my ($ok, $object) = &load_file($isgtf, $tmp);
  next if (! $ok);

  my $fname = $object->get_sourcefile_filename();
  $fileStatsDB{$fname} = $object->_get_framespan_max_object();    
  MMisc::error_quit("Unable to set the FPS for the file framespan") if (!$fileStatsDB{$fname}->set_fps($fps));
  my $cam = $fname;
  $cam =~ s/.*(CAM.).*$/$1/;
  $cam =~ s/.*MCTT[RT]..(..).*$/$1/;
  my $day = $fname;
  $day =~ s/_CAM.*//;
  if (! exists($camDurStatsDB{$cam}{$day})) {
    $camDurStatsDB{$cam}{$day} = Statistics::Descriptive::Discrete->new();
  }
  $camDurStatsDB{$cam}{$day}->add_data($fileStatsDB{$fname}->duration_ts());
  
  
  my @ao = $object->get_all_events_observations();
  MMisc::error_quit("Problem obtaining all Observations from $tmp ViperFile (" . $object->get_errormsg() . ")")
    if ($object->error());

  push @all_observations, @ao;

  $all{$tmp} = $object;
  $ndone++;
}
print "All files loaded (ok: $ndone / $ntodo)\n";
MMisc::error_quit("Can not continue, not all files passed the loading/validation step, aborting\n")
  if (! ($discardErr) && ($ndone != $ntodo));
MMisc::error_quit("No files ok, can not continue, aborting\n")
  if ($ndone == 0);

# Re-represent all observations into a flat format
my %ohash = ();
my %statsDB = ();
my %overallStatsDB = ();
my %camStatsDB = ();

foreach my $obs (@all_observations) {
  my $uid  = $obs->get_unique_id();
  my $et   = $obs->get_eventtype();
  my $id   = $obs->get_id();
  my $gtfs = $obs->get_isgtf();
  my $fn   = $obs->get_filename();
  my $xfn  = $obs->get_xmlfilename();
  my $ds   = (! $gtfs) ? $obs->get_DetectionScore() : undef;
  my $dd   = (! $gtfs) ? $obs->get_DetectionDecision() : undef;
  my $fs_fs = $obs->get_framespan();
  my $fs   = $fs_fs->get_value();
  my $file_fs = $obs->get_fs_file();
  my $dur  = $obs->Dur();
  my $beg  = $obs->Beg();
  my $end  = $obs->End();
  my $mid  = $obs->Mid();

  my $cam = $fn;
  $cam =~ s/.*(CAM.).*$/$1/;
  $cam =~ s/.*MCTT[RT]..(..).*$/$1/;

  MMisc::error_quit("Problem obtaining Observation information (" . $obs->get_errormsg() . ")")
    if ($obs->error());
  MMisc::error_quit("Problem obtaining Observation's framespan information (" . $fs_fs->get_errormsg() . ")")
    if ($fs_fs->error());

  if (! exists($statsDB{$fn}{$et})) {
    $statsDB{$fn}{$et}{dur} = Statistics::Descriptive::Discrete->new();
  }
  $statsDB{$fn}{$et}{dur}->add_data($dur);

  if (! exists($overallStatsDB{$et})) {
    $overallStatsDB{$et}{dur} = Statistics::Descriptive::Discrete->new();
  }
  $overallStatsDB{$et}{dur}->add_data($dur);

  if (! exists($camStatsDB{$cam}{$et}{dur})) {
    $camStatsDB{$cam}{$et}{dur} = Statistics::Descriptive::Discrete->new();
  }
  $camStatsDB{$cam}{$et}{dur}->add_data($dur);

  %{$ohash{$uid}} =
    (
     UID        =>  $uid,
     EventType  => $et,
     ID         => $id,
     isGTF      => $gtfs,
     Filename   => $fn,
     XMLFile    => $xfn,
     DetectionScore => $ds,
     DetectionDecision => $dd,
     Framespan  => $fs,
     Duration   => $dur,
     Beginning  => $beg,
     End        => $end,
     MiddlePoint => $mid,
    );
}

if ($docsv != -1) {
  my @csv_header = 
    ("EventType", "ID", "isGTF", "Framespan", "Duration", "Beginning", "End", "MiddlePoint",
     "DetectionScore", "DetectionDecision", "Filename", "XMLFile");
  my $txt = &do_csv(\@csv_header, %ohash);

  MMisc::writeTo($docsv, "", 1, 0, $txt);
}

print "\n\n\n                               Event observation duration statsitics by file\n\n";
my $sat = new SimpleAutoTable();
my $sumDur = 0;
foreach my $fn (keys %fileStatsDB) {
  my $dur = $fileStatsDB{$fn}->duration_ts();
  $sumDur += $dur;
  foreach my $ev (sort keys %{ $statsDB{$fn} }) {
    $sat->addData($statsDB{$fn}{$ev}{dur}->count(),                               "Obs|count",  sprintf("%20s %s",$ev, $fn));
    $sat->addData(sprintf("%.2f",$statsDB{$fn}{$ev}{dur}->count() / $dur * 3600), "Obs|Obs/hr", sprintf("%20s %s",$ev, $fn));
    $sat->addData("|",                                                            "",           sprintf("%20s %s",$ev, $fn));
    $sat->addData(sprintf("%.2f",$statsDB{$fn}{$ev}{dur}->min()),                 "Dur|min",    sprintf("%20s %s",$ev, $fn));
    $sat->addData(sprintf("%.2f",$statsDB{$fn}{$ev}{dur}->mean()),                "Dur|mean",   sprintf("%20s %s",$ev, $fn));
    $sat->addData(sprintf("%.2f",$statsDB{$fn}{$ev}{dur}->max()),                 "Dur|max",    sprintf("%20s %s",$ev, $fn));
  }
}
print $sat->renderTxtTable(2);

print "\n\n\n       Event observation duration statsitics over all files\n\n";
$sat = new SimpleAutoTable();
my $sumStat = Statistics::Descriptive::Discrete->new();
foreach my $ev (sort keys %overallStatsDB) {
    $sat->addData($overallStatsDB{$ev}{dur}->count(),                                  "Obs|count",  $ev);
    $sat->addData(sprintf("%.2f",$overallStatsDB{$ev}{dur}->count() / $sumDur * 3600), "Obs|Obs/hr", $ev);
    $sat->addData("|",                                                                 "",           $ev);
    $sat->addData(sprintf("%.2f",$overallStatsDB{$ev}{dur}->min()),                    "Dur|min",    $ev);
    $sat->addData(sprintf("%.2f",$overallStatsDB{$ev}{dur}->mean()),                   "Dur|mean",   $ev);
    $sat->addData(sprintf("%.2f",$overallStatsDB{$ev}{dur}->max()),                    "Dur|max",    $ev);
    $sat->addData(sprintf("%.2f",$overallStatsDB{$ev}{dur}->standard_deviation()),     "Dur|stddev", $ev);
    $sumStat->add_data($overallStatsDB{$ev}{dur}->get_data());
}
if (scalar($sumStat->get_data()) != 0){
    $sat->addData($sumStat->count(),                                  "Obs|count",  "All Events");
    $sat->addData("",                                                 "Obs|Obs/hr", "All Events");
    $sat->addData("|",                                                "",           "All Events");
    $sat->addData(sprintf("%.2f",$sumStat->min()),                    "Dur|min",    "All Events");
    $sat->addData(sprintf("%.2f",$sumStat->mean()),                   "Dur|mean",   "All Events");
    $sat->addData(sprintf("%.2f",$sumStat->max()),                    "Dur|max",    "All Events");
    $sat->addData(sprintf("%.2f",$sumStat->standard_deviation()),     "Dur|stddev", "All Events");
}
print $sat->renderTxtTable(2);

print "\n\n\nEvent occurrences as a function of camera\n\n";
$sat = new SimpleAutoTable();
foreach my $cam (sort keys %camStatsDB) {
  foreach my $ev (sort keys %{ $camStatsDB{$cam} }) {
    $sat->addData($camStatsDB{$cam}{$ev}{dur}->count(),                               $cam,  $ev);
  }
}
print $sat->renderTxtTable(2);

print "\n\n\n                 Durations of annotated files in seconds\n\n";
$sat = new SimpleAutoTable();
foreach my $cam (sort keys %camDurStatsDB) {
  foreach my $da (sort keys %{ $camDurStatsDB{$cam} }) {
    $sat->addData($camDurStatsDB{$cam}{$da}->sum(),                               $cam,  $da);
  }
}
print $sat->renderTxtTable(2);

MMisc::ok_quit(" ********** Done **********\n");

########## END

sub _warn_add {
  $warn_msg .= "[Warning] " . join(" ", @_) . "\n";
}

########################################

sub valok {
  my ($fname, $txt) = @_;

  print "$fname: $txt\n";
}

#####

sub valerr {
  my ($fname, $txt) = @_;

  &valok($fname, "[ERROR] $txt");
}

##########

sub load_file {
  my ($isgtf, $tmp) = @_;

  my ($retstatus, $object, $msg) =
    TrecVid08HelperFunctions::load_ViperFile($isgtf, $tmp, 
					     $fps, $xmllint, $xsdpath);
  
  if ($retstatus) { # OK return
    &valok($tmp, "Loaded");
  } else {
    &valerr($tmp, $msg);
  }

  return($retstatus, $object);
}

########################################

sub quc {                       # Quote clean
  my $in = shift @_;

  $in =~ s%\"%\'%g;

  return($in);
}

#####

sub qua {                       # Quote Array
  my @todo = @_;

  my @out = ();
  foreach my $in (@todo) {
    $in = &quc($in);
    push @out, "\"$in\"";
  }

  return(@out);
}

#####

sub generate_csvline {
  my @in = @_;

  @in = &qua(@in);
  my $txt = join(",", @in), "\n";

  return($txt);
}

#####

sub get_csvline {
  my ($rord, $uid, %ohash) = @_;

  my @keys = @{$rord};

  my @todo = ();
  foreach my $key (@keys) {
    MMisc::error_quit("Problem accessing key ($key) from observation hash")
      if (! exists $ohash{$uid}{$key});
    push @todo, $ohash{$uid}{$key};
  }

  return(&generate_csvline(@todo));
}

#####

sub do_csv {
  my ($rord, %ohash) = @_;

  my @header = @{$rord};
  my $txt = "";

  $txt .= &generate_csvline(@header);
  $txt .= "\n";

  foreach my $uid (sort keys %ohash) {
    $txt .= &get_csvline($rord, $uid, %ohash);
    $txt .= "\n";
  }

  return($txt);
}

############################################################

sub set_usage {
  my $ro = join(" ", @ok_events);
  my $xsdfiles = join(" ", @xsdfilesl);
  my $tmp=<<EOF
$versionid

Usage: $0 --fps fps [--help] [--version] [--xmllint location] [--TrecVid08xsd location] [--discardErrors] [-csv [file.csv]] file.xml [file.xml [...]]

Will Score the XML file(s) provided (Truth vs System)

 Where:
  --gtf           Specify that the files are gtf
  --xmllint       Full location of the \'xmllint\' executable (can be set using the $xmllint_env variable)
  --TrecVid08xsd  Path where the XSD files can be found
  --fps           Set the number of frames per seconds (float value) (also recognined: PAL, NTSC)
  --csv           Generate output representation as CSV (to file if given)
  --discardErrors Continue processing even if not all xml files can be properly loaded
  --version       Print version number and exit
  --help          Print this usage information and exit

Note:
- This prerequisite that the file has already been validated against the 'TrecVid08.xsd' file (using xmllint)
- Program will ignore the <config> section of the XML file.
- List of recognized events: $ro
- 'TrecVid08xsd' files are: $xsdfiles
EOF
    ;

    return $tmp;
}
