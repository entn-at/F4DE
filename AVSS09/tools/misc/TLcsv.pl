#!/bin/sh
#! -*-perl-*-
eval 'exec env PERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl -x -S $0 ${1+"$@"}'
    if 0;

# -*- mode: Perl; tab-width: 2; indent-tabs-mode: nil -*- # For Emacs
#
# $Id$
#
# Tracking Logs to CSV
#
# Author(s): Martial Michel
#
# This software was developed at the National Institute of Standards and Technology by
# employees and/or contractors of the Federal Government in the course of their official duties.
# Pursuant to Title 17 Section 105 of the United States Code this software is not subject to 
# copyright protection within the United States and is in the public domain.
#
# "TLcsv" is an experimental system.
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
foreach my $pn ("MMisc") {
  unless (eval "use $pn; 1") {
    my $pe = &eo2pe($@);
    &_warn_add("\"$pn\" is not available in your Perl installation. ", $partofthistool, $pe);
    $have_everything = 0;
  }
}
my $versionkey = MMisc::slurp_file(dirname(abs_path($0)) . "/../../../.f4de_version");
my $versionid = "Tracking Logs to CSV ($versionkey)";

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

my %opt = ();
GetOptions
  (
   \%opt,
   'help',
  ) or MMisc::error_quit("Wrong option(s) on the command line, aborting\n\n$usage\n");
MMisc::ok_quit("\n$usage\n") if ($opt{'help'});

MMisc::error_quit("$usage") if (scalar @ARGV != 2);

my ($if, $of) = @ARGV;
 
my $err = MMisc::check_file_r($if);
MMisc::error_quit("Problem with input file ($if) : $err")
  if (! MMisc::is_blank($err));

open IFILE, "<$if"
  or MMisc::error_quit("Problem reading input file ($if) : $!");

open OFILE, ">$of"
  or MMisc::error_quit("Problem with output file ($of) : $!");

my $fr = 0;
my @md = ();
my @fa = ();
my @map = ();
my @dco = ();
while (my $line = <IFILE>) {
  chomp $line;

  if ($line =~ m%^\*\*\*\*\* Evaluated Frame: (\d+)%) {
    &print_line($fr, &spjoin(@map), &spjoin(@md), &spjoin(@fa), &spjoin(@dco));
    $fr = $1;
    @md = ();
    @fa = ();
    @map = ();
    @dco = ();
    next;
  }

  if ($line =~ m%^\+\+ (REF \d+) .+ DCO$%) {
    push @dco, $1;
    next;
  }

  if ($line =~ m%^\=\= MD \: (.+)$%) {
    push @md, $1;
    next;
  }

  if ($line =~ m%^\=\= FA \: (.+)$%) {
    push @fa, $1;
    next;
  }

  if ($line =~ m%^\=\= Mapped \: (.+)$%) {
    push @map, $1;
    next;
  }

}
close IFILE;
close OFILE;

MMisc::ok_quit("Done");

##########

sub spjoin { return(join(" | ", @_)); }

sub print2ofile { print OFILE "\"" . join("\",\"", @_) . "\"\n"; }

###

sub print_line {
  my @txt = @_;
  
  if ($txt[0] == 0) {
    @txt = ("Frame", "Matched", "MD", "FA", "DCO");
  }
  
  &print2ofile(@txt);
}

####################

sub set_usage {
  my $tmp=<<EOF
$versionid

$0 [--help] trackinglogfile outfile

Will generate a CSV file from a given Tracking Log.

Where:
  --help     This help message

EOF
;

  return($tmp);
}
