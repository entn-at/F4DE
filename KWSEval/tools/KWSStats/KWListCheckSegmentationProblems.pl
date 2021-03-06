#!/bin/sh
#! -*-perl-*-
eval 'exec env PERL_PERTURB_KEYS=0 PERL_HASH_SEED=0 perl -x -S $0 ${1+"$@"}'
  if 0;

#
# $Id$
#

use strict;

use Encode;
use if $^V lt 5.18.0, "encoding", 'euc-cn';
use if $^V ge 5.18.0, "Encode::CN";
use if $^V lt 5.18.0, "encoding", 'utf8';
use if $^V ge 5.18.0, "utf8";

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

  push @f4bv, ("$f4d/../../lib", "$f4d/../../../common/lib");
}
use lib (@f4bv);
#

use Getopt::Long;
use Data::Dumper;
use MMisc;
use TermList;
use TermListRecord;
use TranscriptHolder;
use AutoTable;

### Options
my $kwfile = "";
my $outkwfile = "";
my $charSplitText = 0;
my $charSplitTextNotASCII = 0;
my $charSplitTextDeleteHyphens = 0;
my @textPrefilters = ();
my $charTextRegex = "";

GetOptions
(
 'kwlist=s' => \$kwfile,
 'outputkwlist=s' => \$outkwfile,
 'xprefilterText=s@'                   => \@textPrefilters,
) or MMisc::error_quit("Unknown option(s)\n");

#Check required arguments
MMisc::error_quit("Specify an input KWList file via -k.") if ($kwfile eq "");
MMisc::error_quit("Specify an output KWList file via -o.") if ($outkwfile eq "");

foreach my $filt(@textPrefilters){
  if ($filt =~ /^charsplit$/i){
    $charSplitText = 1;
  } elsif ($filt =~ /^notascii$/i){
    $charSplitTextNotASCII = 1;
  } elsif ($filt =~ /^deletehyphens$/i){
    $charSplitTextDeleteHyphens = 1;
  } elsif ($filt =~ /^regex=(.+)$/i){
    $charTextRegex = $1
  } else {
    MMisc::error_quit("Error: -zprefilterText option /$filt/ not defined.  Aborting.");
  }
}

#Load TermList
my $kwList = new TermList($kwfile, 0, 0, 0);
my %ht = ();
my $n = 0;

print "Checking for segmentation an normalization problems in keyword texts.\n";
foreach my $termid (keys %{ $kwList->{TERMS} }) {
  my $val = $kwList->normalizeTerm($kwList->{TERMS}{$termid}->getAttrValue("TEXT"));
  if ($charSplitText){
    $val = $kwList->charSplitText($val,  $charSplitTextNotASCII, $charSplitTextDeleteHyphens);
  }
  push @{ $ht{$val} }, $termid;
  $n++;
  ### Set the the attribute of 
  $kwList->{TERMS}{$termid}->setAttrValue("SEGMENTATION_DUPS", $termid);
  $kwList->{TERMS}{$termid}->setAttrValue("UNIQUE_SEGMENTATION", "YES");
}

print "Analisys of terms\n";
print "   Num terms: ".$n."\n";
my @keys = keys %ht;
print "   Num uniq terms: ".scalar(@keys)."\n";
foreach my $key(@keys){
  if (@{ $ht{$key} } > 1){
    print "$key \n";
    my $highestNgramTerm = ""; 
    my $highestNgram = 0;
    my @public = ();
    foreach my $termid(@{ $ht{$key} }){ 
      $kwList->{TERMS}{$termid}->setAttrValue("SEGMENTATION_DUPS", join(" ",@{ $ht{$key} }));
      $kwList->{TERMS}{$termid}->setAttrValue("UNIQUE_SEGMENTATION", "NO");
      my @toks = split(/\s/, $kwList->{TERMS}{$termid}->getAttrValue("TEXT"));
      my $nGram = scalar(@toks);
      if ($highestNgram < $nGram){
        $highestNgram = $nGram;
        $highestNgramTerm = $termid;
      }        
      my $relStat = $kwList->{TERMS}{$termid}->getAttrValue("ReleaseStatus");
      my $use = $kwList->{TERMS}{$termid}->getAttrValue("KeywordUse");
      push(@public, $termid) if ((defined($relStat) && $relStat =~ /public/i) || (defined($use) && $use =~ /dryrun/i))
    }
    my $selectTerm = undef;
    if (@public > 1){
      print "   Selecting first public release term: $public[0]\n";
      $selectTerm = $public[0];
    } elsif (@public == 1){
      print "   Selecting only public release term: $public[0]\n";
      $selectTerm = $public[0];
    } else {
      if ($highestNgram != 0){
        print "   Selecting highest Ngram term: $highestNgramTerm\n";
        $selectTerm = $highestNgramTerm;
      }
    }
    die "Error: Failed to find the good term for clique ".join(" ",@{ $ht{$key} }) if (! defined($selectTerm));
    
    $kwList->{TERMS}{$selectTerm}->setAttrValue("UNIQUE_SEGMENTATION", "YES");

    foreach my $termid(@{ $ht{$key} }){ 
      print "   ".$kwList->{TERMS}{$termid}->toStringFull()."\n";
    }
  }
}

$kwList->saveFile($outkwfile);

MMisc::ok_quit();
