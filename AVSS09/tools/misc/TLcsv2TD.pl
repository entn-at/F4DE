#!/bin/sh
#! -*-perl-*-
eval 'exec env PERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl -x -S $0 ${1+"$@"}'
    if 0;

# -*- mode: Perl; tab-width: 2; indent-tabs-mode: nil -*- # For Emacs
#
# $Id$
#
# Tracking Log CSV to Tracking Details
#
# Author(s): Martial Michel
#
# This software was developed at the National Institute of Standards and Technology by
# employees and/or contractors of the Federal Government in the course of their official duties.
# Pursuant to Title 17 Section 105 of the United States Code this software is not subject to 
# copyright protection within the United States and is in the public domain.
#
# "TLcsv2TD" is an experimental system.
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

  push @f4bv, ("$f4d/../../../common/lib");
}
use lib (@f4bv);

sub eo2pe {
  my $oe = join(" ", @_);
  return( ($oe !~ m%^Can\'t\s+locate%) ? "\n----- Original Error:\n $oe\n-----" : "");
}

## Then try to load everything
my $have_everything = 1;
my $partofthistool = "It should have been part of this tools' files.";
my $warn_msg = "";
sub _warn_add { $warn_msg .= "[Warning] " . join(" ", @_) ."\n"; }

# Part of this tool
foreach my $pn ("MMisc", "CSVHelper") {
  unless (eval "use $pn; 1") {
    my $pe = &eo2pe($@);
    &_warn_add("\"$pn\" is not available in your Perl installation. ", $partofthistool, $pe);
    $have_everything = 0;
  }
}
my $versionkey = MMisc::slurp_file(dirname(abs_path($0)) . "/../../../.f4de_version");
my $versionid = "Tracking Log CSV to Tracking Details ($versionkey)";

# usualy part of the Perl Core
foreach my $pn ("Getopt::Long") {
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
# Options processing

my $usage = &set_usage();

my $mddrop = 0;
my $outfile = "";
my $dostdout = 0;
my $stdoutheaders = 0;
my %opt = ();
GetOptions
  (
   \%opt,
   'help',
   'MDthreshold=i' => \$mddrop,
   'outfile=s'     => \$outfile,
   'stdout'        => \$dostdout,
   'HeadersOnly'   => \$stdoutheaders,
  ) or MMisc::error_quit("Wrong option(s) on the command line, aborting\n\n$usage\n");
MMisc::ok_quit("\n$usage\n") if ($opt{'help'});

MMisc::error_quit("\'headersOnly\' requested but \'stdout\' not requested\n$usage")
  if (($stdoutheaders) && (! $dostdout));

if (($stdoutheaders) && ($dostdout)) {
  &prep_file_header();
  MMisc::ok_quit("");
}

MMisc::error_quit("$usage") if (scalar @ARGV < 1);

MMisc::error_quit("Problem with \'mddrop\' must be at least 1")
  if ($mddrop <= 1);

if ($dostdout) {
  MMisc::error_quit("When using \'stdout\' mode only one file is authorized")
    if (scalar @ARGV > 1);
} else {
  MMisc::error_quit("\'outfile\' not set")
    if (MMisc::is_blank($outfile));

  open OFILE, ">$outfile"
    or MMisc::error_quit("Problem with \'outfile\' ($outfile) : $!");
}
my %all = ();
foreach my $if (@ARGV) {
  &process_file($if);
}

my $csvh = &prep_file_header();
foreach my $if (@ARGV) {
  &write_file_details($csvh, $if);
}
if (! $dostdout) {
  close OFILE;
  print "[*****] Wrote \'$outfile\'\n";
}

MMisc::ok_quit($dostdout ? "" : "Done");

##########

sub vprint {
  return if ($dostdout);

  print @_;
}

#####

sub csverr {
  MMisc::error_quit("No CSV handler ?") if (! defined $_[0]);
  MMisc::error_quit("CSV handler problem: " . $_[0]->get_errormsg())
      if ($_[0]->error());
}

#####

sub process_file {
  my ($file) = @_;

  &vprint("[*] Loading \'$file\'\n");
  
  open FILE, "<$file"
    or MMisc::error_quit("Problem opening file ($file) : $!");
  
  my $csvh = new CSVHelper(); &csverr($csvh);
  my $line = <FILE>; chomp $line;
  my @header = $csvh->csvline2array($line); &csverr($csvh);

  &vprint("  ");

  my $c_mp = '@';
  my $c_md = '-';
  my $c_fa = '|';
  my $c_mdfa = '+';
  my $c_none = '.';
  my $c_dco = ':';


  my $frc = 0;
  my $mdc = 0;
  my $max = 0;
  my $fmx = 0;
  my $beg = 0;
  my $kbeg = 0;
  my $fbeg = 0;
  my $end = 0;
  my $kend = 0;
  my $fend = 0;
  my $ftbeg = 0;
  my $ftend = 0;
  my $ftl = 0;
  my $ftt = -1;
  my $track = "";
  my $str = 0;
  my $frd = 0;
  my $pfr = 0;
  while ($line = <FILE>) {
    chomp $line;
    my ($fr, $mp, $md, $fa, $dco) = $csvh->csvline2array($line);
    &csverr($csvh);

    $frd = $fr - $pfr;
    $pfr = $fr;

    if ( (MMisc::is_blank($fa))
        && (MMisc::is_blank($md)) 
        && (MMisc::is_blank($mp))
         && (MMisc::is_blank($dco)) ) {
      $track .= ($str) ? $c_none : "";
      &vprint($c_none);
      next;
    }

    if (! MMisc::is_blank($mp)) {
      &vprint($c_mp);
      $track .= $c_mp;
      $str++;
      $beg = ($beg == 0) ? $fr : $beg;
      $end = $fr;
      $ftbeg = ($ftbeg == 0) ? $fr : $ftbeg;
      $ftend = $fr;
      $mdc = 0;
      $ftt = ($ftt == -1) ? 1 : $ftt;
      next; 
    }

    if (! MMisc::is_blank($md)) {
      $ftbeg = ($ftbeg == 0) ? $fr : $ftbeg;
      $ftend = $fr;

      if (MMisc::is_blank($fa)) {
        &vprint($c_md);
        $track .= $c_md;
      } else {
        &vprint($c_mdfa);
        $track .= $c_mdfa;
      }
      $str++;
      $mdc++;
      if ($mdc >= $mddrop) {
        $frc = $end - $beg;
        $frc = ($frc == 0) ? (($beg == 0) ? 0 : 1) : 1 + $frc;
        if ($frc > $max) {
          $max = $frc;
          $kbeg = $beg;
          $kend = $end;
          if ($fmx == 0) {
            $fmx = $frc;
            $fbeg = $beg;
            $fend = $end;
          }
        }
        if ($beg != 0) {
          $track .= "![$frc/$max]";
          $ftt = 0;
        }
        $frc = 0;
        $mdc = 0;
        $beg = 0;
        $end = 0;
      }
      next;
    }

    if (! MMisc::is_blank($fa)) {
      &vprint($c_fa);
      $track .= $c_fa;
      $str++;
      next;
    }

    if (! MMisc::is_blank($dco)) {
      $track .= ($str) ? $c_dco : "";
      &vprint($c_dco);
      next;
    }

    MMisc::error_quit("We should not be here");
  }
  close FILE;
  $frc = $end - $beg;
  $frc = ($frc == 0) ? (($beg == 0) ? 0 : 1) : 1 + $frc;
  if ($frc > $max) {
    $max = $frc;
    $kbeg = $beg;
    $kend = $end;
    if ($fmx == 0) {
      $fmx = $frc;
      $fbeg = $beg;
      $fend = $end;
    }
  }
  $track .= "\$[$frc/$max]";

  $ftt = ($ftt == -1) ? 0: $ftt;
  $ftl = $ftend - $ftbeg;
  $ftl = ($ftl == 0) ? (($ftbeg == 0) ? 0 : 1) : 1 + $ftl;


  $all{$file} = [$max, $track, $kbeg, $kend, $mddrop,
                 $fmx, $fbeg, $fend, 
                 $ftt, $ftl, $ftbeg, $ftend];

  &vprint("\n   (max: $max)\n");
}

##########

sub prep_file_header {
  my $csvh = new CSVHelper(); &csverr($csvh);
  return($csvh) if (($dostdout) && (! $stdoutheaders));

  my @h = ();
  push (@h, "FileName") if (! $stdoutheaders);
  push @h, (
    "FirstTrackedLife", "FirstBegFr", "FirstEndFr",
    "MaxTrackedLife", "MaxBegFr", "MaxEndFr",
    "TrackedToEnd",
    "CompleteTrackLife", "CompleteBegFr", "CompleteEndFr",
    "MDThresold", 
    "TrackDetail"
  );
  $csvh->set_number_of_columns(scalar @h); &csverr($csvh);
  my $txt = $csvh->array2csvline(@h);
  if ($stdoutheaders) {
    print "$txt\n";
  } else {
    print OFILE "$txt\n"; &csverr($csvh);
  }
  
  return($csvh);
}

#####

sub write_file_details {
  my ($csvh, $file) = @_;

  my ($max, $track, $beg, $end, $mt, $fmx, $fbeg, $fend, $ctt, $ctl, $ctbeg, $ctend) 
    = @{$all{$file}};

  my @a = ();
  push(@a, $file) if (! $dostdout);
  push @a, ($fmx, $fbeg, $fend, $max, $beg, $end, $ctt, $ctl, $ctbeg, $ctend, $mt, $track);
  
  my $str = $csvh->array2csvline(@a); &csverr($csvh);
  if ($dostdout) {
    print "$str\n";
  } else {
    print OFILE  "$str\n"; 
  }
}

####################

sub set_usage {
  my $tmp=<<EOF
$versionid

$0 [--help] --MDthreshold value [--outfile file | --stdout [--HeadersOnly]] trackinglogfile [trackinglogfile [...]]

Will generate a Tracking Details CSV from a Tracking Log CSV.

Where:
  --help     This help message
  --MDthreshold  The value when a track is considered lost (in processed entries from the tracking log, ie if it was annotated every 5 frames at 25 fps a value of 10 means 10 * (5/25) = 2 seconds)
  --outfile  Specify the output file
  --stdout   Print the CSV line to stdout. In this mode, only one trackinglogfile can be specified, and the line will not contain the FileName field (1st field in the normal CSV file)
  --HeadersOnly  Print the CSV headers only to stdout (does not need a trackinglogfile)

A Track is started at the first Mapping of the REF to the SYS and is extended for each Mapped entry seen, until either the MDthreshold is triggered (a new mapped resets the threshold counter) or we reach the end of file.

The Complete Track is from the first Mapped to the last Mapped or Miss Detect (not taking into account the MDthreshold trigger)

A TrackLife is the framespan of a given Track.

Information made available in the CSV file are:
  FileName      The filename as given on the command line (omitted when using --stdout)
  FirstTrackedLife   The first seen Track Life (framespan)
   FirstBegFr        The beginning frame of the First Track Life
   FirstEndFr        The end frame of the First Track Life
  MaxTrackedLife     The longest seen Track Life
   MaxBegFr          The beginning frame of the Max Track Life
   MaxEndFr          The end frame of the Max Track Life
  TrackedToEnd       A boolean that specify if the MDthreshold was never triggered (1 = true / 0 = false)
  CompleteTrackLife  The framespan of the Complete Track
   CompleteBegFr     The beginning frame of the Complete Track
   CompleteEndFr     The end frame of the Complete Track
  MDThresold         The Missed Detect Thresold as given on the command line
  TrackDetail        A text based tracking information from the first non DCO or no Objects in Frame (detailed below)

TrackingDetails code are:
  .    No Objects
  :    Don't Care REF
  -    Missed Detect
  |    False Alarm
  +    Missed Detect and False Alarm
  @    Mapped REF to SYS
  !    Max Miss Detect rule was triggered

EOF
;

  return($tmp);
}
