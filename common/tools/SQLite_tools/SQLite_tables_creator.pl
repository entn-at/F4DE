#!/bin/sh
#! -*-perl-*-
eval 'exec env PERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl -x -S $0 ${1+"$@"}'
    if 0;

# -*- mode: Perl; tab-width: 2; indent-tabs-mode: nil -*- # For Emacs
#
# $Id$
#
# SQLite Tables Creator
#
# Author(s): Martial Michel
#
# This software was developed at the National Institute of Standards and Technology by
# employees and/or contractors of the Federal Government in the course of their official duties.
# Pursuant to Title 17 Section 105 of the United States Code this software is not subject to 
# copyright protection within the United States and is in the public domain.
#
# "SQLite Tables Creator" is an experimental system.
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
foreach my $pn ("MMisc", "MtSQLite") {
  unless (eval "use $pn; 1") {
    my $pe = &eo2pe($@);
    &_warn_add("\"$pn\" is not available in your Perl installation. ", $partofthistool, $pe);
    $have_everything = 0;
  }
}
my $versionkey = MMisc::slurp_file(dirname(abs_path($0)) . "/../../../.f4de_version");
my $versionid = "SQLite Tables Creator ($versionkey)";

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
my $toolb = "SQLite_load_csv";
my $tool = "$f4d/${toolb}.pl";
$tool = MMisc::cmd_which($toolb) 
  if (! MMisc::is_file_x($tool));
my $loadcsv = 0;
my $nullmode = 0;

# Av  : ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz  #
# Used:            L N                   h   l         v      #

my %opt = ();
GetOptions
  (
   \%opt,
   'help',
   'version',
   'loadCSV'    => \$loadcsv,
   'LoadCSV=s'  => \$tool,
   'NULLfields' => \$nullmode,
  ) or MMisc::error_quit("Wrong option(s) on the command line, aborting\n\n$usage\n");
MMisc::ok_quit("\n$usage\n") if ($opt{'help'});
MMisc::ok_quit("$versionid\n") if ($opt{'version'});
MMisc::ok_quit("\n$usage\n") if (scalar @ARGV == 0);

my $sodbk = '-';

my ($dbfile, $conffile) = @ARGV;

if ($loadcsv) {
  MMisc::error_quit("Requested command print instead of DB creation, can not use \'loadCSV\' with it")
    if ($dbfile eq $sodbk);
  MMisc::error_quit("No location found for tool ($toolb)")
    if (MMisc::is_blank($tool));
  my $err = MMisc::check_file_x($tool);
  MMisc::error_quit("Problem with tool ($tool): $err")
    if (! MMisc::is_blank($err));
}

my $err = MMisc::check_file_r($conffile);
MMisc::error_quit("Problem with configfile ($conffile): $err")
  if (! MMisc::is_blank($err));

my $dbh = undef;

my %colinfo = ();
my @ok_keys = ("newtable", "csvfile", "column"); # order is important
my ($rtablenames, $rcsvfiles) = &load_info($conffile);
MMisc::error_quit("Mismatch in tablename/csvfile lists")
  if (scalar @$rtablenames != scalar @$rcsvfiles);

MMisc::ok_quit() if ($dbfile eq $sodbk);

MMisc::error_quit("No DB/table created, aborting")
  if (! defined $dbh);

MtSQLite::release_dbh($dbh);

if ($loadcsv) {
  for (my $i = 0; $i < scalar @$rtablenames; $i++) {
    my $tablename = $$rtablenames[$i];
    my $csvfile   = $$rcsvfiles[$i];
    my @cinfo = @{$colinfo{$tablename}};
    my $cmd = "$tool $dbfile $csvfile $tablename";
    $cmd .= " --NULLfields" if ($nullmode);
    if (scalar @cinfo > 0) {
      $cmd .= " --columnsname " . join(",", @cinfo);
    }
    my ($retcode, $stdout, $stderr) = MMisc::do_system_call($cmd);
    MMisc::error_quit("[CMD: $cmd]\n** STDOUT:\n$stdout\n\n\n** STDERR:\n$stderr\n")
      if ($retcode != 0);

#    print "[CMD: $cmd]\n** STDOUT:\n$stdout\n\n\n** STDERR:\n$stderr\n";
  }
}

MMisc::ok_quit("Done");

####################

sub load_info {
  my ($file) = @_;

  open FILE, "<$file"
    or MMisc::error_quit("Problem loading file ($file): $!");

  my $tcc = ""; # Table creation command
  my ($tn, $ccf) = ("", "");
  my @tnl = ();
  my %tnh = ();
  my $hmk = 0;
  while (my $line = <FILE>) {
    next if (MMisc::is_blank($line));
    next if ($line =~ m%^\#%);
    
    my ($err, $key, $val) = &split_line($line);
    MMisc::error_quit($err) if (! MMisc::is_blank($err));

    if ($key eq $ok_keys[0]) { # newtable
      # first, process the previous entry if possible
      &create_table($tcc, $tn, $hmk);
      # Empty previous values
      ($tn, $tcc) = ("", "");

      my $ctn = MMisc::clean_begend_spaces($val);
      ($tn) = MtSQLite::fix_entries($ctn);
#      print "[TN: $tn]\n";
      next;
    }

    if ($key eq $ok_keys[1]) { # csvfile
      my $ccf = MMisc::clean_begend_spaces($val);
      if ($loadcsv) {
        my $err = MMisc::check_file_r($ccf);
        MMisc::error_quit("Problem with \'" . $ok_keys[1] . "\' ($ccf): $err")
          if (! MMisc::is_blank($err));
      }
      push @tnl, $tn;
      $tnh{$tn} = $ccf;
#      print "[CSV: $ccf]\n";
      next;
    }

    if ($key =~ m%$ok_keys[2](\*?)%) { # columns
      my $mk = ($1 eq "*") ? 1 : 0;

      my ($cn, $ucn, $type, $cstr) = ("", "", "", "");
 
      $cstr = MMisc::clean_begend_spaces($1)
        if ($val =~ s%\:(.+)$%%);

     if ($val =~ s%\;(\w+)$%%) {
        $type = MMisc::clean_begend_spaces($1);
      } else {
        $type = "BLOB";
      }

      $ucn = MMisc::clean_begend_spaces($1)
        if ($val =~ s%\=(.+)$%%);

      my $cn = MMisc::clean_begend_spaces($val);
      $ucn = $cn if (MMisc::is_blank($ucn));

      my $tccadd = "$ucn $type" 
        . (($mk) ? " PRIMARY KEY" : "") 
        . ((! MMisc::is_blank($cstr)) ? " $cstr" : "");
      $tcc .= ((MMisc::is_blank($tcc)) ? "" : ", ") . $tccadd;

      push @{$colinfo{$tn}}, $ucn;
#      print "[TCC: $tccadd]\n";
      $hmk += $mk;
      next;
    }

    MMisc::error_quit("Unknown command [$line]");
  }
  &create_table($tcc, $tn, $hmk);

  my @cfl = ();
  for (my $i = 0; $i < scalar @tnl; $i++) { push @cfl, $tnh{$tnl[$i]}; }

  return(\@tnl, \@cfl);
}

#####

sub split_line {
  my $line = $_[0];

  return("", $1, $2)
    if ($line =~ m%^([^\:]+)\:(.+)$%);

  return("Problem extracting line content [$line]");
}

##########

sub _get_dbh {
  return() if ($dbfile eq $sodbk);

  if (! defined $dbh) {
    (my $err, $dbh) = MtSQLite::get_dbh($dbfile);
    MMisc::error_quit("Problem with DB ($dbfile): $err")
      if (! MMisc::is_blank($err));
  }
}

##

sub _doOneCommand {
  my ($cmd) = @_;

  if ($dbfile eq $sodbk) {
    my $tcmd = MtSQLite::_fixcmd($cmd);
    print "$tcmd\n";
    return();
  }

  my $err = MtSQLite::doOneCommand($dbh, $cmd);
  MMisc::error_quit("Problem with command [$cmd]: $err")
    if (! MMisc::is_blank($err));
}  

#####

sub create_table {
  my ($tcc, $tn, $hmk) = @_;

  return() if (MMisc::is_blank($tn));

  &_get_dbh();

  my $cmd = "DROP TABLE IF EXISTS $tn";
  &_doOneCommand($cmd);

  $cmd = "CREATE TABLE $tn (";
  $cmd .= " __autoinckey INTEGER PRIMARY KEY, " if ($hmk == 0);
  $cmd .= $tcc;
  $cmd .= ")";
  
  &_doOneCommand($cmd);
}

####################

sub set_usage {  
  my $tmp=<<EOF
$versionid

$0 [--help | --version] [--loadCSV [--NULLfields] [--LoadCSV toollocation]] dbfile configfile

Will create SQLite tables within dbfile based on the information provided in configfile (generated by SQLite_cfg_helper).

NOTE: using '-' as the dbfile will print the SQLite commands to stdout.

WARNING: if a table listed in the configuration file already exists, it will be destroyed from dbfile

Where:
  --help     This help message
  --version  Version information
  --loadCSV  In addition to creating the table, insert the entire CSV file (specified in configfile (into the table)
  --NULLfields   When inserting the entire CSV file, empty fields will be inserted as the NULL value (the default is to insert them as the empty value of the defined type, ie '' for TEXTs)
  --LoadCSV  Location of the 'SQLite_load_csv' tool

EOF
;

  return($tmp);
}
