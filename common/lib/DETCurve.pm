# STDEval
# DETCurve.pm
# Author: Jon Fiscus
# 
# This software was developed at the National Institute of Standards and Technology by
# employees of the Federal Government in the course of their official duties.  Pursuant to
# Title 17 Section 105 of the United States Code this software is not subject to copyright
# protection within the United States and is in the public domain. STDEval is
# an experimental system.  NIST assumes no responsibility whatsoever for its use by any party.
# 
# THIS SOFTWARE IS PROVIDED "AS IS."  With regard to this software, NIST MAKES NO EXPRESS
# OR IMPLIED WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING MERCHANTABILITY,
# OR FITNESS FOR A PARTICULAR PURPOSE.
#
# This package implements partial DET curves which means that not a TARGET trials have scores
# and not all NONTARG Trials have scores.  

package DETCurve;

use strict;
use Trials;
use MetricFuncs;
use MetricTestStub;
use Data::Dumper;
use DETCurveSet;
use PropList;
use MMisc;

my(@tics) = (0.00001, 0.0001, 0.001, 0.004, .01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 40, 60, 80, 90, 95, 98, 99, 99.5, 99.9);

sub new
  {
    my ($class, $trials, $metric, $lineTitle, $listIsolineCoef, $gzipPROG) = @_;
        
    my $self =
      { 
       TRIALS => $trials,
       METRIC => $metric,
       LINETITLE => $lineTitle,
       MINSCORE => undef,
       MAXSCORE => undef,
       MAXIMIZEBEST => undef,
       BESTCOMB => { DETECTIONSCORE => undef, COMB => undef, MFA => undef, MMISS => undef },
       SYSTEMDECISIONVALUE => undef, ### this is the value based on the system's hard decisions
       POINTS => undef, ## 2D array (score, Mmiss, Mfa, comb);  IF style is blocked, then (sampleStandardDev(Mmiss), ssd(Mfa), ssd(ssdComb), $numBlocks) 
       LAST_GNU_DETFILE_PNG => "",
       LAST_GNU_THRESHPLOT_PNG => "",
       LAST_SERIALIZED_DET => "",
       MESSAGES => "",
       ISOLINE_COEFFICIENTS => $listIsolineCoef,
       ISOLINE_COEFFICIENTS_INDEX => 0,         
       ISOPOINTS => {},
       GZIPPROG => (defined($gzipPROG) ? $gzipPROG : "gzip"),
       POINT_COMPUTATION_ATTEMPTED => 0,
      };
        
    bless $self;
        
    #   print Dumper($listIsolineCoef);
        
    die "Error: Combined metric must have the output of combType() be 'maximizable|minimizable'" 
      if ($metric->combType() !~ /^(maximizable|minimizable)$/);
    $self->{MAXIMIZEBESTC} = ($metric->combType() eq "maximizable");
                
    return $self;
  }

sub thisabs{ ($_[0] < 0) ? $_[0]*(-1) : $_[0]; }

sub unitTest
  {
    print "Test DETCurve\n";
    blockWeightedUnitTest();
    #   unitTestMultiDet();
    # bigDETUnitTest();
    return 1;
  }

sub bigDETUnitTest {
  printf("Running a series of large DET Curves\n");
  my ($doProfile) = 0;
  
 foreach my $size(10000, 100000, 1000000, 3000000, 6000000, 8000000, 10000000){
#  foreach my $size(2000000, 5000000, 10000000){
#  foreach my $size(1000003){
    system "/home/fiscus/Projects/STD/STDEval/tools/ProcGragh/ProcGraph.pl --cumul --Tree --outdir /tmp --filebase BigDet.$size -- ".
          " perl ".($doProfile ? "-d:DProf" : "")." -I . -e 'use DETCurve; DETCurve::oneBigDET(\"/tmp/BigDet.$size\", $size)'"; 
#    print "\n";
  }
}

sub oneBigDET
  {
   my ($root, $nt) = @_;

    print " Computing big DET Curve... ".($nt)." trials\n";
    my @isolinecoef = ( 5, 10, 20, 40, 80, 160 );
    
    #####################################  Without data  ###############################    
    my $emptyTrial = new Trials("Term Detection", "Term", "Occurrence", { ("TOTALTRIALS" => $nt) });

    print "   ... adding trials\n";
    for (my $i=0; $i<$nt/2; $i++){
    	my $r = (($i % 1000)  == 0 ? 0.5 : rand());
    	$emptyTrial->addTrial("he", $r, ($r < 0.5 ? "NO" : "YES"), 1);
      $r = (($i % 1000)  == 0 ? 0.5 : rand());
      $emptyTrial->addTrial("he", $r, ($r < 0.5 ? "NO" : "YES"), 0);
    	print "   Made trials < ".(2*$i)."\n" if ($i*2 % 1000000 == 0); 
    }
    
    my $met = new MetricTestStub({ ('ValueC' => 0.1, 'ValueV' => 1, 'ProbOfTerm' => 0.0001 ) }, $emptyTrial);
    if (ref($met) ne "MetricTestStub") {
      die "Error: Unable to create a MetricTestStub object with message '$met'\n";
    }
    
    my $emptydet = new DETCurve($emptyTrial, $met, "footitle", \@isolinecoef, undef);
    use DETCurveSet;
    my $ds = new DETCurveSet("title");
    $ds->addDET("Biggy", $emptydet);
#    my %ht = ("createDETfiles", 1, "noSerialize", 1);
    my %ht = ("createDETfiles", 1);
    print $ds->renderAsTxt($root, 1, 1, \%ht);
}

sub blockWeightedUnitTest()
  {
    print " Computing blocked curve without data...";
    my @isolinecoef = ( 5, 10, 20, 40, 80, 160 );
    
    #####################################  Without data  ###############################    
    my $emptyTrial = new Trials("Term Detection", "Term", "Occurrence", { ("TOTALTRIALS" => 100) });

    $emptyTrial->addTrial("he", undef, "OMITTED", 1);
    $emptyTrial->addTrial("he", undef, "OMITTED", 1);
    $emptyTrial->addTrial("he", undef, "OMITTED", 1);
    $emptyTrial->addTrial("she", undef, "OMITTED", 1);
    $emptyTrial->addTrial("she", undef, "OMITTED", 1);
    $emptyTrial->addTrial("she", undef, "OMITTED", 1);

    my $met = new MetricTestStub({ ('ValueC' => 0.1, 'ValueV' => 1, 'ProbOfTerm' => 0.0001 ) }, $emptyTrial);
    if (ref($met) ne "MetricTestStub") {
      die "Error: Unable to create a MetricTestStub object with message '$met'\n";
    }
    my $emptydet = new DETCurve($emptyTrial, $met, "footitle", \@isolinecoef, undef);
    die "Error: Empty det should be successful()" if (! $emptydet->successful());
    die "Error: Empty det have value 0" if ($emptydet->getBestCombComb() != 0);
    die "Error: Empty det have Pmiss == 1" if ($emptydet->getBestCombMMiss() <=  1 - 0.000001);
    die "Error: Empty det have PFa   == 0" if ($emptydet->getBestCombMFA() > 0 + 0.0000001);
#    $emptydet->writeGNUGraph("foo", {()});

    print "  OK\n";

    #####################################  With data  ###############################    
    print " Computing blocked curve with data...";
    my $trial = new Trials("Term Detection", "Term", "Occurrence", { ("TOTALTRIALS" => 10) });

    $trial->addTrial("she", 0.1, "NO", 0);
    $trial->addTrial("she", 0.2, "NO", 0);
    $trial->addTrial("she", 0.3, "NO", 1);
    $trial->addTrial("she", 0.4, "NO", 0);
    $trial->addTrial("she", 0.5, "NO", 0);
    $trial->addTrial("she", 0.6, "NO", 0);
    $trial->addTrial("she", 0.7, "NO", 1);
    $trial->addTrial("she", 0.8, "YES", 0);
    $trial->addTrial("she", 0.9, "YES", 1);
    $trial->addTrial("she", 1.0, "YES", 1);

    $trial->addTrial("he", 0.41, "NO", 1);
    $trial->addTrial("he", 0.51, "YES", 0);
    $trial->addTrial("he", 0.61, "YES", 0);
    $trial->addTrial("he", 0.7, "YES", 1);
    $trial->addTrial("he", undef, "OMITTED", 1);
    $trial->addTrial("he", undef, "OMITTED", 1);

    $trial->addTrial("skip", 0.41, "NO", 0);
    $trial->addTrial("skip", 0.51, "YES", 0);
    $trial->addTrial("skip", 0.61, "YES", 0);
    $trial->addTrial("skip", 0.7, "YES", 0);

    $trial->addTrial("notskip", 0.41, "NO", 0);
    $trial->addTrial("notskip", 0.51, "YES", 0);
    $trial->addTrial("notskip", 0.61, "YES", 0);
    $trial->addTrial("notskip", 0.7, "YES", 0);
    $trial->addTrial("notskip", undef, "OMITTED", 1);
    $trial->addTrial("notskip", undef, "OMITTED", 1);

    my $blockdetOrig = new DETCurve($trial, 
                                    new MetricTestStub({ ('ValueC' => 0.1, 'ValueV' => 1, 'ProbOfTerm' => 0.0001 ) }, $trial),
                                    "footitle", \@isolinecoef, "gzip");
    $blockdetOrig->computePoints();
    print "  OK\n";
    print " Serializing to a file...";
    my $sroot = "/tmp/serialize";
    $blockdetOrig->serialize($sroot);
    my $blockdetSrl = DETCurve::readFromFile("$sroot.gz", "gzip");
    print "  OK\n";
    if (unlink("$sroot.gz") != 1) {
      print "!!!!Warning: Serialization tests passed but file removal of '$sroot.gz' failed\n";
    }
    my $blockdet = $blockdetSrl;

    ## This was built from DETtesting-v2 with MissingTarg=0, MissingNonTarg=0
    #    
    #               Thr    Pmiss  Pfa    TWval     SSDPmiss, SSDPfa, SSDValue, #blocks
    my @points = [  (0.1,  0.500, 0.611, -610.550, 0.500,    0.347,  346.550,   3) ];
    push @points, [ (0.2,  0.500, 0.556, -555.000, 0.500,    0.255,  254.235,   3) ];
    push @points, [ (0.3,  0.500, 0.500, -499.450, 0.500,    0.167,  166.401,   3) ];
    push @points, [ (0.4,  0.583, 0.500, -499.533, 0.382,    0.167,  166.525,   3) ];
    push @points, [ (0.41,  0.583, 0.444, -443.983, 0.382,    0.096,   96.288,   3) ];
    push @points, [ (0.5, 0.667, 0.403, -402.404, 0.382,    0.087,   86.407,   3) ];
    push @points, [ (0.51,  0.667, 0.347, -346.854, 0.382,    0.024,   24.344,   3) ];
    push @points, [ (0.6, 0.667, 0.250, -249.642, 0.382,    0.083,   83.076,   3) ];
    push @points, [ (0.61,  0.667, 0.194, -194.092, 0.382,    0.048,   48.397,   3) ];
    push @points, [ (0.7, 0.667, 0.097,  -96.879, 0.382,    0.087,   86.568,   3) ];
    push @points, [ (0.8,  0.833, 0.056,  -55.383, 0.289,    0.096,   95.927,   3) ];
    push @points, [ (0.9,  0.833, 0.000,    0.167, 0.289,    0.000,    0.289,   3) ];
    push @points, [ (1.0,  0.917, 0.000,    0.083, 0.144,    0.000,    0.144,   3) ];
    print " Checking points...";
    for (my $i=0; $i<@points; $i++) {
      die "Error: Det point isn't correct for point $i:\n   expected '".join(",",@{$points[$i]})."'\n".
        "        got '".join(",",@{ $blockdet->{POINTS}[$i]})."'"
          if ($points[$i][0] != $blockdet->{POINTS}[$i][0] ||
              thisabs($points[$i][1] - sprintf("%.3f",$blockdet->{POINTS}[$i][1])) > 0.001 ||
              thisabs($points[$i][2] - sprintf("%.3f",$blockdet->{POINTS}[$i][2])) > 0.001 ||
              thisabs($points[$i][3] - sprintf("%.3f",$blockdet->{POINTS}[$i][3])) > 0.001 ||
              thisabs($points[$i][4] - sprintf("%.3f",$blockdet->{POINTS}[$i][4])) > 0.001 ||
              thisabs($points[$i][5] - sprintf("%.3f",$blockdet->{POINTS}[$i][5])) > 0.001 ||
              thisabs($points[$i][6] - sprintf("%.3f",$blockdet->{POINTS}[$i][6])) > 0.001 ||
              thisabs($points[$i][7] - sprintf("%.3f",$blockdet->{POINTS}[$i][7])) > 0.001);
    }
    #$blockdet->writeGNUGraph("fooblock");
    
    print "  OK\n";
  }

sub unitTestMultiDet{
  print " Checking multi...";

  my @isolinecoef = ( 5, 10, 20, 40, 80, 160 );
  my $trial = new Trials("Term Detection", "Term", "Occurrence", { ("TOTALTRIALS" => undef) });
    
  $trial->addTrial("she", 0.10, "NO", 0);
  $trial->addTrial("she", 0.15, "NO", 0);
  $trial->addTrial("she", 0.20, "NO", 0);
  $trial->addTrial("she", 0.25, "NO", 0);
  $trial->addTrial("she", 0.30, "NO", 1);
  $trial->addTrial("she", 0.35, "NO", 0);
  $trial->addTrial("she", 0.40, "NO", 0);
  $trial->addTrial("she", 0.45, "NO", 1);
  $trial->addTrial("she", 0.50, "NO", 0);
  $trial->addTrial("she", 0.55, "YES", 1);
  $trial->addTrial("she", 0.60, "YES", 1);
  $trial->addTrial("she", 0.65, "YES", 0);
  $trial->addTrial("she", 0.70, "YES", 1);
  $trial->addTrial("she", 0.75, "YES", 1);
  $trial->addTrial("she", 0.80, "YES", 1);
  $trial->addTrial("she", 0.85, "YES", 1);
  $trial->addTrial("she", 0.90, "YES", 1);
  $trial->addTrial("she", 0.95, "YES", 1);
  $trial->addTrial("she", 1.0, "YES", 1);

  my $trial2 = new Trials("Term Detection", "Term", "Occurrence", { ("TOTALTRIALS" => undef) });
    
  $trial2->addTrial("she", 0.10, "NO", 0);
  $trial2->addTrial("she", 0.15, "NO", 0);
  $trial2->addTrial("she", 0.20, "NO", 0);
  $trial2->addTrial("she", 0.25, "NO", 0);
  $trial2->addTrial("she", 0.30, "NO", 1);
  $trial2->addTrial("she", 0.35, "NO", 1);
  $trial2->addTrial("she", 0.40, "NO", 0);
  $trial2->addTrial("she", 0.45, "NO", 1);
  $trial2->addTrial("she", 0.50, "NO", 0);
  $trial2->addTrial("she", 0.55, "YES", 1);
  $trial2->addTrial("she", 0.60, "YES", 1);
  $trial2->addTrial("she", 0.65, "YES", 0);
  $trial2->addTrial("she", 0.70, "YES", 0);
  $trial2->addTrial("she", 0.75, "YES", 1);
  $trial2->addTrial("she", 0.80, "YES", 0);
  $trial2->addTrial("she", 0.85, "YES", 1);
  $trial2->addTrial("she", 0.90, "YES", 1);
  $trial2->addTrial("she", 0.95, "YES", 1);
  $trial2->addTrial("she", 1.0, "YES", 1);

  my $trial3 = new Trials("Term Detection", "Term", "Occurrence", { ("TOTALTRIALS" => undef) });
    
  $trial3->addTrial("she", 0.10, "NO", 1);
  $trial3->addTrial("she", 0.15, "NO", 1);
  $trial3->addTrial("she", 0.20, "NO", 1);
  $trial3->addTrial("she", 0.25, "NO", 1);
  $trial3->addTrial("she", 0.30, "NO", 0);
  $trial3->addTrial("she", 0.35, "NO", 0);
  $trial3->addTrial("she", 0.40, "YES", 0);
  $trial3->addTrial("she", 0.45, "YES", 1);
  $trial3->addTrial("she", 0.50, "YES", 1);
  $trial3->addTrial("she", 0.55, "YES", 1);
  $trial3->addTrial("she", 0.60, "YES", 1);
  $trial3->addTrial("she", 0.65, "YES", 0);
  $trial3->addTrial("she", 0.70, "YES", 1);
  $trial3->addTrial("she", 0.75, "YES", 1);
  $trial3->addTrial("she", 0.80, "YES", 0);
  $trial3->addTrial("she", 0.85, "YES", 1);
  $trial3->addTrial("she", 0.90, "YES", 1);
  $trial3->addTrial("she", 0.95, "YES", 1);
  $trial3->addTrial("she", 1.0, "YES", 1);

  my $det1 = new DETCurve($trial, 
                          new MetricTestStub({ ('ValueC' => 0.1, 'ValueV' => 1, 'ProbOfTerm' => 0.0001 ) }, $trial),
                          "DET1", \@isolinecoef, undef);
  my $det2 = new DETCurve($trial2, 
                          new MetricTestStub({ ('ValueC' => 0.1, 'ValueV' => 1, 'ProbOfTerm' => 0.0001 ) }, $trial2),
                          "DET2", \@isolinecoef, undef);
  my $det3 = new DETCurve($trial3, 
                          new MetricTestStub({ ('ValueC' => 0.1, 'ValueV' => 1, 'ProbOfTerm' => 0.0001 ) }, $trial2),
                          "DET3", \@isolinecoef, undef);
    
  my $ds = new DETCurveSet("title");
  die "Error: Failed to add first det" if ("success" ne $ds->addDET("Name 1", $det1));
  die "Error: Failed to add second det" if ("success" ne $ds->addDET("Name 2", $det2));
  die "Error: Failed to add second det" if ("success" ne $ds->addDET("Name 3", $det3));

  my $dir = "mdettmp";
  system "rm -rf $dir";
  system "mkdir -p $dir";
    
  my $options = { ("ColorScheme" => "grey",
                   "colorScheme" => "grey",
                   "DrawIsometriclines" => 1,
                   "Isometriclines" => [ (0.7, 0.5, 0.4, 0, -5) ],
                   "DETLineAttr" => { ("Name 1" => { label => "New DET1", lineWidth => 9, pointSize => 2, pointTypeSet => "square", color => "rgb \"#0000ff\"" }),
                                    },
                   "PointSet" => [ { MMiss => .4,  MFA => .05, pointSize => 1,  pointType => 10, color => "rgb \"#ff0000\"", label => "Point1=10", justification => "left"}, 
                                   { MMiss => .4,  MFA => .40, pointSize => 8,  pointType => 8, color => "rgb \"#ff0000\"", label => "Point2=8" }, 
                                   { MMiss => .4,  MFA => .80, pointSize => 8,  pointType => 12, color => "rgb \"#ff0000\"", label => "Point2=12" }, 
                                   { MMiss => .2,  MFA => .05, pointSize => 4,  pointType => 4, color => "rgb \"#ff0000\"", label => "Point2=4" }, 
                                   { MMiss => .2,  MFA => .40, pointSize => 4, pointType => 6, color => "rgb \"#ff0000\"" }, 
                                   ] ) };
  
  $options->{Xmin} = .00001;
  $options->{Xmax} = 99.9;
  $options->{Ymin} = .1;
  $options->{Ymax} = 99;
  $options->{xScale} = "nd";
  $options->{yScale} = "nd";
  $options->{title} = "ND vs. ND";

  DETCurve::writeMultiDetGraph("$dir/g1.nd.nd",  $ds, $options, undef);
  
  $options->{Xmin} = .0000001;
  $options->{Xmax} = 1;
  $options->{Ymin} = .001;
  $options->{Ymax} = 1;
  $options->{xScale} = "log";
  $options->{yScale} = "log";
  $options->{title} = "LOG vs. LOG";
  DETCurve::writeMultiDetGraph("$dir/g1.log.log",  $ds, $options, undef);

  $options->{xScale} = "linear";
  $options->{yScale} = "linear";
  $options->{title} = "LIN vs. LIN";
  DETCurve::writeMultiDetGraph("$dir/g1.lin.lin",  $ds, $options, undef);
  
  open (HTML, ">$dir/index.html") || die("Error making multi-det HTML file");
  print HTML "<HTML>\n";
  print HTML "<BODY>\n";
  print HTML " <TABLE border=1>\n";
  print HTML "  <TR>\n";
  print HTML "   <TD width=33%> <IMG src=\"g1.nd.nd.png\"></TD>\n";
  print HTML "   <TD width=33%> <IMG src=\"g1.log.log.png\"></TD>\n";
  print HTML "   <TD width=33%> <IMG src=\"g1.lin.lin.png\"></TD>\n";

  print HTML "  </TR>\n";
  print HTML "  <TR>\n";
  print HTML "   <TD width=33%> <IMG src=\"g1.nd.nd.Name_1.png\"></TD>\n";
  print HTML "   <TD width=33%> <IMG src=\"g1.log.log.Name_1.png\"></TD>\n";
  print HTML "   <TD width=33%> <IMG src=\"g1.lin.lin.Name_1.png\"></TD>\n";

  print HTML "  </TR>\n";
  print HTML " </TABLE>\n";
  print HTML "</BODY>\n";
  print HTML "</HTML>\n";
  
  close (HTML);
  
  print "OK\n";  
}

# Old serialize
#sub serialize2
#  {
#    my ($self, $file) = @_;
#    $self->{LAST_SERIALIZED_DET} = $file;
#    open (FILE, ">$file") || die "Error: Unable to open file '$file' to serialize STDDETSet to";
#    my $orig = $Data::Dumper::Indent; 
#    $Data::Dumper::Indent = 0;
#    
#    ### Purity controls how self referential objects are written;
#    my $origPurity = $Data::Dumper::Purity;
#    $Data::Dumper::Purity = 1;
#             
#    print FILE Dumper($self); 
#    
#    $Data::Dumper::Indent = $orig;
#    $Data::Dumper::Purity = $origPurity;
#    
#    close FILE;
#    system("$self->{GZIPPROG} -9 -f $file > /dev/null");
#  }

# Serialize avoiding creating temporary variables and arrays for POINTS 
# structure.
sub serialize
  {
    my ($self, $file) = @_;
    $self->{LAST_SERIALIZED_DET} = $file;
    open (FILE, ">$file") || die "Error: Unable to open file '$file' to serialize STDDETSet to";
    my $orig = $Data::Dumper::Indent; 
    $Data::Dumper::Indent = 0;
    
    ### Purity controls how self referential objects are written;
    my $origPurity = $Data::Dumper::Purity;
    $Data::Dumper::Purity = 1;
    
    my $p = $self->{'POINTS'};
    $self->{POINTS} = undef;
    
    my $t = $self->{'TRIALS'}{'trials'};
    $self->{'TRIALS'}{'trials'} = undef;

    print FILE Dumper($self);
    
	##	
    my $origTerse = $Data::Dumper::Terse;
    $Data::Dumper::Terse = 1;
    
    # POINTS
    print FILE "\$VAR1->{'POINTS'} = [";
    
    for(my $i=0; $i<scalar(@$p); $i++)
	{
		print FILE "," if($i>0);

		print FILE "[";
		
		for(my $j=0; $j<scalar(@{$p->[$i]}); $j++)
		{
			print FILE "," if($j>0);
			print FILE Dumper $p->[$i][$j];
			
			#if(defined($p->[$i][$j]))
			#{
			#	print FILE "'"."$p->[$i][$j]"."'";
			#}
			#else
			#{
			#	print FILE "undef";
			#}
		}
		
		print FILE "]";
	}
	
	print FILE "];";
	#
	
	# TRIALS
	print FILE "\$VAR1->{'TRIALS'}{'trials'} = {";
    my $firstkey = 1;
    
    foreach my $k (keys %$t)
    {
    	print FILE "," if(!$firstkey);
		$firstkey = 0 unless(!$firstkey);
		print FILE "'"."$k"."' => {";
		
		my $firstkeyelt = 1;
		
		foreach my $e (keys %{ $t->{$k} })
		{
			print FILE "," if(!$firstkeyelt);
			$firstkeyelt = 0 unless(!$firstkeyelt);
			
			if($e =~ /^(TARG|NONTARG)$/)
			{				
				print FILE "'"."$e"."' => [";
				
				for(my $i=0; $i<scalar(@{ $t->{$k}{$e} }); $i++)
				{
					print FILE "," if($i>0);
					print FILE Dumper $t->{$k}{$e}->[$i];
				}
				
				print FILE "]";
			}
			else
			{
				print FILE "'"."$e"."' => ";
				print FILE Dumper $t->{$k}{$e};
			}
		}
		
		print FILE "}";
    }
    
    print FILE "};";
	#
	
    $Data::Dumper::Indent = $orig;
    $Data::Dumper::Purity = $origPurity;
    $Data::Dumper::Terse = $origTerse;
        
    close FILE;
    system("$self->{GZIPPROG} -9 -f $file > /dev/null");
    
    $self->{'POINTS'} = $p;
    $self->{'TRIALS'}{'trials'} = $t;
  }

sub readFromFile
  {
    my ($file, $gzipPROG) = @_;
    my $str = "";
    my $tmpFile = undef;
    
    if ( ( $file =~ /.+\.gz$/ ) && ( -e $file ) && ( -f $file ) && ( -r $file ) ) {
      $str = MMisc::file_gunzip($file)
    } else {
      $str = MMisc::slurp_file($file, "text")
    }

    my $VAR1;
    eval $str;
    $VAR1;
  }

sub isCompatible(){
  my ($self, $DET2) = @_;

  #Make sure the metric objects are the same
  return 0 if (! $self->{METRIC}->isCompatible($DET2->{METRIC}));
  return 0 if (! $self->{TRIALS}->isCompatible($DET2->{TRIALS}));
    
  return 1;    
}

sub successful
  {
    my ($self) = @_;
    $self->computePoints();
    defined($self->{POINTS});
  }

sub getMessages{
  my ($self) = @_;
  $self->{MESSAGES};
}

sub getBestCombDetectionScore{
  my $self = shift;
  $self->computePoints();
  $self->{BESTCOMB}{DETECTIONSCORE}
}

sub getBestCombComb{
  my $self = shift;
  $self->computePoints();
  $self->{BESTCOMB}{COMB}
}

sub getBestCombMMiss{
  my $self = shift;
  $self->computePoints();
  $self->{BESTCOMB}{MMISS}
}

sub getBestCombMFA{
  my $self = shift;
  $self->computePoints();
  $self->{BESTCOMB}{MFA}
}

sub getTrials(){
  my ($self) = @_;
  $self->{TRIALS};
}

sub getMetric(){
  my ($self) = @_;
  $self->{METRIC};
}

sub getDETPng(){
  my ($self) = @_;
  $self->{LAST_GNU_DETFILE_PNG};
}

sub setDETPng(){
  my ($self, $png) = @_;
  $self->{LAST_GNU_DETFILE_PNG} = $png;
}

sub getThreshPng(){
  my ($self) = @_;
  $self->{LAST_GNU_THRESHPLOT_PNG};
}

sub setThreshPng(){
  my ($self, $png) = @_;
  $self->{LAST_GNU_THRESHPLOT_PNG} = $png;
}

sub getSerializedDET(){
  my ($self) = @_;
  $self->{LAST_SERIALIZED_DET};
}

sub getPoints(){
  my ($self) = @_;
  $self->computePoints();
  (exists($self->{POINTS}) ? $self->{POINTS} : undef); 
}

sub getMinDecisionScore(){
  my ($self) = @_;
  $self->{MINSCORE};
}

sub getMaxDecisionScore(){
  my ($self) = @_;
  $self->{MAXSCORE};
}

sub setSystemDecisionValue{
  my $self = shift;
  my $val = shift;
  $self->computePoints();
  $self->{SYSTEMDECISIONVALUE} = $val;
}

sub getSystemDecisionValue{
  my $self = shift;
  $self->computePoints();
  $self->{SYSTEMDECISIONVALUE};
}

sub getLineTitle{
  my $self = shift;
  
  $self->{LINETITLE};
}

sub setLineTitle{
  my ($self, $title) = @_;
  
  $self->{LINETITLE} = $title;
}

sub IntersectionIsolineParameter
  {
    my ($self, $x1, $y1, $x2, $y2) = @_;
    my ($t, $xt, $yt) = (undef, undef, undef);
    return (undef, undef, undef, undef) if( ( scalar( @{ $self->{ISOLINE_COEFFICIENTS} } ) == 0 ) || ( scalar( @{ $self->{ISOLINE_COEFFICIENTS} } ) == $self->{ISOLINE_COEFFICIENTS_INDEX} ) );

    for (my $i=$self->{ISOLINE_COEFFICIENTS_INDEX}; $i<@{ $self->{ISOLINE_COEFFICIENTS} }; $i++) {
      my $m = $self->{ISOLINE_COEFFICIENTS}->[$i];
      ($t, $xt, $yt) = IntersectionParameter($m, $x1, $y1, $x2, $y2);
                
      if ( defined( $t ) ) {
        if ( $t >= 0 && $t <= 1 ) {
          $self->{ISOLINE_COEFFICIENTS_INDEX} = $i+1;
          return ($t, $m, $xt, $yt);
        } elsif ( $t > 1 ) {
          $self->{ISOLINE_COEFFICIENTS_INDEX} = $i;
          return (undef, undef, undef, undef);
        }
      }
    }
        
    return (undef, undef, undef, undef);
  }

sub AllIntersectionIsolineParameter
  {
    my ($self, $x1, $y1, $x2, $y2) = @_;
    my @out = ();
    my ($t, $m, $xt, $yt) = (undef, undef, undef, undef);
        
    do
      {
        ($t, $m, $xt, $yt) = $self->IntersectionIsolineParameter($x1, $y1, $x2, $y2);
        push( @out, [($t, $m, $xt, $yt)] ) if( defined( $t ) );
      }
        while ( defined( $t ) );
        
    return( @out );
  }

sub IntersectionParameter
  {
    my ($m, $x1, $y1, $x2, $y2) = @_;
    my ($t, $xt, $yt) = (undef, undef, undef);
    return (undef, undef, undef) if( $m == 0 ); 
        
    if ( $x1 == $x2 ) {
      $t = ($m*$x1 - $y1)/($y2-$y1);
      $xt = $x1;
      $yt = $m*$xt;
    } elsif ( $y1 == $y2 ) {
      $t = (($y1/$m) - $x1)/($x2-$x1);
      $yt = $y1;
      $xt = $yt/$m;
    } else {
      my $a = ($y1-$y2)/($x1-$x2);
      return (undef, undef, undef) if($a == $m); # which should never happen
      my $b = $y1 - $a*$x1;
      $xt = $b/($m-$a);
      $t = ($xt-$x1)/($x2-$x1);
      $yt = $m*$xt;
    }
        
    return ($t, $xt, $yt);
  }

sub AddIsolineInformation
  {
    my ($self, $blocks, $paramt, $isolinecoef, $estMFa, $estMMiss) = @_;
        
    $self->{ISOPOINTS}{$isolinecoef}{INTERPOLATED_MFA} = $estMFa;
    $self->{ISOPOINTS}{$isolinecoef}{INTERPOLATED_MMISS} = $estMMiss;
    $self->{ISOPOINTS}{$isolinecoef}{INTERPOLATED_COMB} = $self->{METRIC}->combCalc($estMMiss, $estMFa);
        
    foreach my $b ( keys %{ $blocks } ) {
      # Add info of previous in the block id
      $self->{ISOPOINTS}{$isolinecoef}{BLOCKS}{$b}{MFA} = (1-$paramt)*($blocks->{$b}{PREVMFA}) + $paramt*($blocks->{$b}{MFA});
      $self->{ISOPOINTS}{$isolinecoef}{BLOCKS}{$b}{MMISS} = (1-$paramt)*($blocks->{$b}{PREVMMISS}) + $paramt*($blocks->{$b}{MMISS});
      # Value function
      $self->{ISOPOINTS}{$isolinecoef}{BLOCKS}{$b}{COMB} = $self->{METRIC}->combCalc($self->{ISOPOINTS}{$isolinecoef}{BLOCKS}{$b}{MMISS},
                                                                                     $self->{ISOPOINTS}{$isolinecoef}{BLOCKS}{$b}{MFA});
    }
  }

sub computePoints
  {
    my $self = shift;

    ### This function implements the delayed point computation which only occurs IFF the data is requested
    if ($self->{POINT_COMPUTATION_ATTEMPTED}) {
      return;
    }
    $self->{POINT_COMPUTATION_ATTEMPTED} = 1;
        
    ## For faster computation;
    $self->{TRIALS}->sortTrials();
        
    $self->{POINTS} = $self->Compute_blocked_DET_points($self->{TRIALS});

  }

sub Compute_blocked_DET_points
  {
    my ($self, $trial) = @_;
    my @Outputs = ();

    $self->{TRIALS}->sortTrials();
    my %blocks = ();
    my $block = "";
    my $minScore = undef;
    my $maxScore = undef;
    my $numBlocks = 0;
    my $previousAvgMmiss = 0;
    my $previousAvgMfa = 0;
    my $findMaxComb = ($self->{METRIC}->combType() eq "maximizable" ? 1 : 0);
    
    ### Reduce the block set to only ones with targets and setup the DS!
    foreach $block ($trial->getBlockIDs()) {
      next if ($trial->getNumTarg($block) <= 0);
        
      $numBlocks++;
      $blocks{$block} = { TARGi => 0, NONTARGi => 0, MFA => undef, MMISS => undef, COMB => undef, PREVMFA => undef, PREVMMISS => undef,
                          TARGNScr => $trial->getNumTargScr($block), NONTARGNScr =>  $trial->getNumNonTargScr($block)};
      if ($blocks{$block}{TARGNScr} > 0) {
        $minScore = $trial->getTargDecScr($block,0)
          if (!defined($minScore) || $minScore > $trial->getTargDecScr($block,0));
        $maxScore = $trial->getTargDecScr($block,$blocks{$block}{TARGNScr} - 1) 
          if (!defined($maxScore) || $maxScore < $trial->getTargDecScr($block,$blocks{$block}{TARGNScr} - 1));
      }
      if ($blocks{$block}{NONTARGNScr} > 0) {
        $minScore = $trial->getNonTargDecScr($block,0) 
          if (!defined($minScore) || $minScore > $trial->getNonTargDecScr($block,0));
        $maxScore = $trial->getNonTargDecScr($block,$blocks{$block}{NONTARGNScr} - 1)
          if (!defined($maxScore) || $maxScore < $trial->getNonTargDecScr($block,$blocks{$block}{NONTARGNScr} - 1));
      }
    }
    
    $self->{MINSCORE} = $minScore;
    $self->{MAXSCORE} = $maxScore;
    
    #    if ($numBlocks <= 1)
    #    {
    #           $self->{MESSAGES} .= "WARNING: '".$self->{TRIALS}->getBlockId()."' weighted DET curves can not be computed with $numBlocks ".$self->{TRIALS}->getBlockId()."s\n";
    #           return undef;
    #    }

    if (!defined($self->{MINSCORE}) || !defined($self->{MAXSCORE})) {
      my ($mMiss, $mFa, $TWComb, $ssdMMiss, $ssdMFa, $ssdComb) = $self->computeBlockWeighted(\%blocks, $numBlocks, $trial);
      push(@Outputs, [ ( "NaN", $mMiss, $mFa, $TWComb, $ssdMMiss, $ssdMFa, $ssdComb, $numBlocks) ] );

      $self->{BESTCOMB}{DETECTIONSCORE} = "NaN";
      $self->{BESTCOMB}{COMB} = $TWComb;
      $self->{BESTCOMB}{MFA} = $mFa;
      $self->{BESTCOMB}{MMISS} = $mMiss;

      $self->{MESSAGES} .= "WARNING: '".$self->{TRIALS}->getBlockId()."' weighted DET curves can not be computed, no detection scores exist for block\n";

      return \@Outputs;
    }

    #   print "Blocks: '".join(" ",keys %blocks)."'  minScore: $minScore\n";
    my ($mMiss, $mFa, $TWComb, $ssdMMiss, $ssdMFa, $ssdComb) = $self->computeBlockWeighted(\%blocks, $numBlocks, $trial);
    push(@Outputs, [ ( $minScore, $mMiss, $mFa, $TWComb, $ssdMMiss, $ssdMFa, $ssdComb, $numBlocks) ] );

    my $prevMin = $minScore;
    $self->{BESTCOMB}{DETECTIONSCORE} = $minScore;
    $self->{BESTCOMB}{COMB} = $TWComb;
    $self->{BESTCOMB}{MFA} = $mFa;
    $self->{BESTCOMB}{MMISS} = $mMiss;
   
    while ($self->updateMinScoreForBlockWeighted(\%blocks, \$minScore, $trial)) {
      # Add info of previous average
      $previousAvgMfa = $mFa;
      $previousAvgMmiss = $mMiss;
      ($mMiss, $mFa, $TWComb, $ssdMMiss, $ssdMFa, $ssdComb) = $self->computeBlockWeighted(\%blocks, $numBlocks, $trial);
                
      my @listparams = $self->AllIntersectionIsolineParameter($previousAvgMfa, $previousAvgMmiss, $mFa, $mMiss);

      foreach my $setelt ( @listparams ) {
        my ($paramt, $isolinecoef, $estMFa, $estMMiss) = @{ $setelt };                  
        $self->AddIsolineInformation(\%blocks, $paramt, $isolinecoef, $estMFa, $estMMiss) if( defined ( $paramt ) );
      }
                
      push(@Outputs, [ ( $minScore, $mMiss, $mFa, $TWComb, $ssdMMiss, $ssdMFa, $ssdComb, $numBlocks ) ] );

      if ($findMaxComb) {
        if ($TWComb > $self->{BESTCOMB}{COMB}) {
          $self->{BESTCOMB}{DETECTIONSCORE} = $minScore;
          $self->{BESTCOMB}{COMB} = $TWComb;
          $self->{BESTCOMB}{MFA} = $mFa;
          $self->{BESTCOMB}{MMISS} = $mMiss;
        }
      } else {
        if ($TWComb < $self->{BESTCOMB}{COMB}) {
          $self->{BESTCOMB}{DETECTIONSCORE} = $minScore;
          $self->{BESTCOMB}{COMB} = $TWComb;
          $self->{BESTCOMB}{MFA} = $mFa;
          $self->{BESTCOMB}{MMISS} = $mMiss;
        }
      } 
                
      $prevMin = $minScore;
    }
    
    \@Outputs;
  }

sub updateMinScoreForBlockWeighted
  {
    my ($self, $blocks, $minScore, $trial) = @_;
    my $change = 0;
        
    #Advance Skipping the min
    foreach $b(keys %$blocks) {
      # Add info of previous in the block id
      $blocks->{$b}{PREVMFA} = $blocks->{$b}{MFA};
      $blocks->{$b}{PREVMMISS} = $blocks->{$b}{MMISS};
        
      while ($blocks->{$b}{TARGi} < $blocks->{$b}{TARGNScr} &&
             $trial->getTargDecScr($b, $blocks->{$b}{TARGi}) <= $$minScore) {
        $blocks->{$b}{MFA} = undef;
        $blocks->{$b}{TARGi} ++;
        $change++;
      }
                
      while ($blocks->{$b}{NONTARGi} < $blocks->{$b}{NONTARGNScr} &&
             $trial->getNonTargDecScr($b,$blocks->{$b}{NONTARGi}) <= $$minScore) {
        $blocks->{$b}{MFA} = undef;
        $blocks->{$b}{NONTARGi} ++;
        $change++;
      }
    }
        
    my $newMin = undef;
    my $dataLeft = 0;
    foreach $b(keys %$blocks) {
      $newMin = $trial->getTargDecScr($b, $blocks->{$b}{TARGi})
        if (($blocks->{$b}{TARGi} < $blocks->{$b}{TARGNScr}) &&
            (!defined($newMin) || $newMin > $trial->getTargDecScr($b, $blocks->{$b}{TARGi})));
                                        
      $newMin = $trial->getNonTargDecScr($b,$blocks->{$b}{NONTARGi})
        if (($blocks->{$b}{NONTARGi} < $blocks->{$b}{NONTARGNScr}) &&
            (!defined($newMin) || $newMin > $trial->getNonTargDecScr($b, $blocks->{$b}{NONTARGi})));
                                        
      $dataLeft = 1 if (($blocks->{$b}{TARGi} < $blocks->{$b}{TARGNScr}) ||
                        ($blocks->{$b}{NONTARGi} < $blocks->{$b}{NONTARGNScr}));
                        
    }
        
    if (! $dataLeft) {
      # We stepped off the last system output.  Therefore, we need to need to signify it
      $$minScore = undef;
      0;                        ## no change
    } else {
      $$minScore = $newMin if (defined($newMin)); ## Return the prevMin if there was nothing left
      $change;
    }
  }

sub computeBlockWeighted
  {
    my ($self, $blocks, $numBlocks, $trial) = @_;
    my $b = "";
        
    foreach $b (keys %$blocks) {
      if (!defined($blocks->{$b}{MFA})) {
        my $NMiss = $blocks->{$b}{TARGi} + $trial->getNumOmittedTarg($b);
        my $NFalse = $blocks->{$b}{NONTARGNScr} - $blocks->{$b}{NONTARGi};                                                                                                                                   
        ## Caching: Calculate is not yet calculated
        $blocks->{$b}{MMISS} = $NMiss; #$self->{METRIC}->errMissBlockCalc($NMiss, $b);
        $blocks->{$b}{MFA}   = $NFalse; #$self->{METRIC}->errFABlockCalc  ($NFalse, $b);
      }
    }

    my ($combAvg, $combSSD, $missAvg, $missSSD, $faAvg, $faSSD) = $self->{METRIC}->combBlockSetCalc($blocks);
        
    ($missAvg, $faAvg, $combAvg, $missSSD, $faSSD, $combSSD);
  }

sub ppndf
  {
    my ($ival) = @_;
    ## A lot of predefined variables

    my $SPLIT=0.42;
        
    my $EPS=2.2204e-16;
    my $LL=140;
        
    my $A0=2.5066282388;
    my $A1=-18.6150006252;
    my $A2=41.3911977353;
    my $A3=-25.4410604963;
    my $B1=-8.4735109309;
    my $B2=23.0833674374;
    my $B3=-21.0622410182;
    my $B4=3.1308290983;
    my $C0=-2.7871893113;
    my $C1=-2.2979647913;
    my $C2=4.8501412713;
    my $C3=2.3212127685;
    my $D1=3.5438892476;
    my $D2=1.6370678189;
    my ($p, $q, $r, $retval) = (0, 0, 0, 0);
        
    if ($ival >= 1.0) {
      $p = 1 - $EPS;
    } elsif ($ival <= 0.0) {
      $p = $EPS;
    } else {
      $p = $ival;
    }
        
    $q = $p - 0.5;
        
    if (abs($q) <= $SPLIT ) {
      $r = $q * $q;
      $retval = $q * ((($A3 * $r + $A2) * $r + $A1) * $r + $A0) /
        (((($B4 * $r + $B3) * $r + $B2) * $r + $B1) * $r + 1.0);
    } else {
      if ( $q > 0.0 ) {
        $r = 1.0 - $p;
      } else {
        $r = $p;
      }
                
      if ($r <= 0.0) {
        printf ("Found r = %f\n", $r);
        return;
      }
                
      $r = sqrt( (-1.0 * log($r)));
                
      $retval = ((($C3 * $r + $C2) * $r + $C1) * $r + $C0) / 
        (($D2 * $r + $D1) * $r + 1.0);
                
      if ($q < 0) {
        $retval = $retval * -1.0;
      }
    }
        
    return ($retval);
  }

1;
