#!/bin/sh
#! -*-perl-*-
eval 'exec env PERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl -x -S $0 ${1+"$@"}'
  if 0;

#
# $Id$
#
# CLEAR Detection and Tracking Viper XML Validator
#
# Author:    Vasant Manohar
# Additions: Martial Michel
#
# This software was developed at the National Institute of Standards and Technology by
# employees and/or contractors of the Federal Government in the course of their official duties.
# Pursuant to Title 17 Section 105 of the United States Code this software is not subject to 
# copyright protection within the United States and is in the public domain.
#
# "CLEAR Detection and Tracking Viper XML Validator" is an experimental system.
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
foreach my $pn ("MMisc", "CLEARDTViperFile", "CLEARDTHelperFunctions", "CLEARSequence") {
  unless (eval "use $pn; 1") {
    my $pe = &eo2pe($@);
    &_warn_add("\"$pn\" is not available in your Perl installation. ", $partofthistool, $pe);
    $have_everything = 0;
  }
}
my $versionkey = MMisc::slurp_file(dirname(abs_path($0)) . "/../../../.f4de_version");
my $versionid = "CLEAR Detection and Tracking Viper XML Validator ($versionkey)";

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
# Get some values from CLEARDTViperFile
my $dummy = new CLEARDTViperFile();
my @ok_objects = $dummy->get_full_objects_list();
my @xsdfilesl = $dummy->get_required_xsd_files_list();
# We will use the '$dummy' to do checks before processing files

########################################
# Options processing

my $xmllint_env = "F4DE_XMLLINT";
my @ok_md = ("gzip", "text"); # Default is gzip / order is important
my $frameTol = 0;
my $usage = &set_usage();

# Default values for variables
my $isgtf = 0;
my $xmllint = MMisc::get_env_val($xmllint_env, "");
my $xsdpath = "$f4d/../../data";
my $writeback = -1;
my $xmlbasefile = -1;
my $evaldomain = undef;
my $MemDump = undef;
my $xtracheck = 0;

# Av  : ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz  #
# Used:   CD                  WX      efgh             vwx    # 

my %opt;
my $dbgftmp = "";

GetOptions
  (
   \%opt,
   'help',
   'version',
   "XMLbase:s"       => \$xmlbasefile,
   'xmllint=s'       => \$xmllint,
   'CLEARxsd=s'      => \$xsdpath,
   'gtf'             => \$isgtf,
   'Domain=s'        => \$evaldomain,
   'frameTol=i'      => \$frameTol,
   'write:s'         => \$writeback,
   'WriteMemDump:s'  => \$MemDump,
   'extrachecks'     => \$xtracheck,
  ) or MMisc::error_quit("Wrong option(s) on the command line, aborting\n\n$usage\n");

MMisc::ok_quit("\n$usage\n") if ($opt{'help'});
MMisc::ok_quit("$versionid\n") if ($opt{'version'});

if (defined $evaldomain) { 
  $evaldomain = uc($evaldomain);
  MMisc::error_quit("Unknown 'Domain'. Has to be (BN, MR, SV, UV)\n\n$usage") if ( ($evaldomain ne "BN") && ($evaldomain ne "MR") && ($evaldomain ne "SV") && ($evaldomain ne "UV") );
  $dummy->set_required_hashes($evaldomain); 
} else {
  MMisc::error_quit("'Domain' is a required argument (BN, MR, SV, UV)\n\n$usage");
}

if ($xmlbasefile != -1) {
  my $txt = $dummy->get_base_xml($isgtf, @ok_objects);
  MMisc::error_quit("While trying to obtain the base XML file (" . $dummy->get_errormsg() . ")")
    if ($dummy->error());

  MMisc::writeTo($xmlbasefile, "", 0, 0, $txt);  

  MMisc::ok_quit($txt);
}

MMisc::ok_quit("\n$usage\n") if (scalar @ARGV == 0);

if ($xmllint ne "") {
  MMisc::error_quit("While trying to set \'xmllint\' (" . $dummy->get_errormsg() . ")")
    if (! $dummy->set_xmllint($xmllint));
}

if ($xsdpath ne "") {
  MMisc::error_quit("While trying to set \'CLEARxsd\' (" . $dummy->get_errormsg() . ")")
    if (! $dummy->set_xsdpath($xsdpath));
}

if (($writeback != -1) && ($writeback ne "")) {
  # Check the directory
  MMisc::error_quit("Provided \'write\' option directory ($writeback) does not exist")
    if (! -e $writeback);
  MMisc::error_quit("Provided \'write\' option ($writeback) is not a directory")
    if (! -d $writeback);
  MMisc::error_quit("Provided \'write\' option directory ($writeback) is not writable")
    if (! -w $writeback);
  $writeback .= "/" if ($writeback !~ m%\/$%); # Add a trailing slash
}

if (defined $MemDump) {
  MMisc::error_quit("\'WriteMemDump\' can only be used in conjunction with \'write\'")
    if ($writeback == -1);
  $MemDump = $ok_md[0]
    if (MMisc::is_blank($MemDump));
  MMisc::error_quit("Unknown \'WriteMemDump\' mode ($MemDump), authorized: " . join(" ", @ok_md))
    if (! grep(m%^$MemDump$%, @ok_md));
}

##########
# Main processing
my $tmp;
my %all = ();
my $ntodo = scalar @ARGV;
my $ndone = 0;
for (my $fi = 0; $fi < $ntodo; $fi++) {
 $tmp = $ARGV[$fi];
  my ($ok, $object) = &load_file($isgtf, $tmp);
  next if (! $ok);

  if ($writeback != -1) {
    my $fname = "";
    
    if ($writeback ne "") {
      my ($err, $td, $tf, $te) = MMisc::split_dir_file_ext($tmp);
      $fname = MMisc::concat_dir_file_ext($writeback, $tf, $te);
    }

    (my $err, $fname) = CLEARDTHelperFunctions::save_ViperFile_XML($fname, $object, 1, "** XML re-Representation:\n", @ok_objects);
    MMisc::error_quit($err) if (! MMisc::is_blank($err));

    if (defined $MemDump) {
      MMisc::error_quit("Problem writing the \'Memory Dump\' representation of the ViperFile object")
	if (! CLEARDTHelperFunctions::save_ViperFile_MemDump($fname, $object, $MemDump));    
   
      my $eval_sequence = CLEARSequence->new($fname);
      MMisc::error_quit("Failed scoring 'CLEARSequence' instance creation. $eval_sequence")
        if (ref($eval_sequence) ne "CLEARSequence");

      $object->reformat_ds($eval_sequence, $isgtf, @ok_objects);
      MMisc::error_quit("Could not reformat Viper File: $fname. " . $object->get_errormsg())
          if ($object->error());

      MMisc::error_quit("Problem writing the 'Memory Dump' representation of the Scoring Sequence object")
	if (! CLEARDTHelperFunctions::save_ScoringSequence_MemDump($fname, $eval_sequence, $MemDump));    
    }
  }

  $all{$tmp} = $object;
  $ndone++;
}

print "All files processed (Validated: $ndone | Total: $ntodo)\n\n";
MMisc::error_exit()
  if ($ndone != $ntodo);

MMisc::ok_exit();

########## END

sub valok {
  my ($fname, $txt) = @_;

  print "$fname: $txt\n";
}

#####

sub valerr {
  my ($fname, $txt) = @_;
  foreach (split(/\n/, $txt)){ 
    &valok($fname, "[ERROR] $_");
  }
}

##########

sub load_file {
  my ($isgtf, $tmp) = @_;

  my ($retstatus, $object, $msg) = 
    CLEARDTHelperFunctions::load_ViperFile($isgtf, $tmp, $evaldomain, $frameTol, $xmllint, $xsdpath, undef, $xtracheck);

  if ($retstatus) { # OK return
    &valok($tmp, "validates");
  } else {
    &valerr($tmp, $msg);
  }

  return($retstatus, $object);
}

########################################

sub set_usage {
  my $wmd = join(" ", @ok_md);
  my $ro = join(" ", @ok_objects);
  my $xsdfiles = join(" ", @xsdfilesl);

  my $tmp=<<EOF
$versionid

Usage: $0 [--help] [--version] [--XMLbase [file]] [--xmllint location] [--CLEARxsd location] --Domain domain [--frameTol framenbr] [--extrachecks] [--gtf] [--write [directory]] [--WriteMemDump [mode]] viper_source_file.xml [viper_source_file.xml [...]]

Will perform a semantic validation of the Viper XML file(s) provided.

 Where:
  --help          Print this usage information and exit
  --version       Print version number and exit
  --XMLbase       Print a Viper file with an empty <data> section and a populated <config> section, and exit (to a file if one provided on the command line)
  --xmllint       Full location of the \'xmllint\' executable (can be set using the $xmllint_env variable)
  --CLEARxsd  Path where the XSD files can be found
  --Domain        Specify the domain of the source file. Possible values are: BN, MR, SV, UV (for "Broadcast News", "Meeting Room", "Surveillance", and "UAV")
  --frameTol      The frame tolerance allowed for attributes to be outside of the object framespan (default value: $frameTol)
  --extrachecks   Will perform more complete check on the framespan contained within each object definition (only usable when reading XML files)
  --gtf           Specify that the file to validate is a Ground Truth File
  --write         Once processed in memory, print a new XML dump of file read (or to the same filename within the command line provided directory if given)
  --WriteMemDump  Write a memory representation of validated ViPER Files that can be used by CLEAR tools. Also write a sequence MemDump. Two modes possible: $wmd (1st default)

Note:
- This prerequisite that the file can be been validated using 'xmllint' against the 'CLEAR.xsd' file
- Program will ignore the <config> section of the XML file.
- Program will disard any xml comment(s).
- List of recognized objects: $ro
- 'CLEARxsd' files are: $xsdfiles
EOF
;

  return $tmp;
}

####################

sub _warn_add {
  $warn_msg .= "[Warning] " . join(" ", @_) . "\n";
}
