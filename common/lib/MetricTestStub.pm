# MetricSTD.pm
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

package MetricTestStub;
@ISA = qw(MetricFuncs);

use strict;
use Data::Dumper;
 
sub new
  {
    my ($class, $parameters, $trial) = @_;

    my $self =
      {
       "PARAMS" => $parameters,
       "TRIALS" => $trial,
       "TRIALPARAMS" => $trial->getMetricParams(),
      };

    #######  customizations

    return "Error: parameter 'ValueV' not defined"     if (! exists($self->{PARAMS}->{ValueV}));
    return "Error: parameter 'ValueC' not defined"     if (! exists($self->{PARAMS}->{ValueC}));
    return "Error: parameter 'ProbOfTerm' not defined" if (! exists($self->{PARAMS}->{ProbOfTerm}));

    #    print Dumper($self->{TRIALPARAMS});
    return "Error: trials parameter 'TOTALTRIALS' does not exist" if (! exists($self->{TRIALPARAMS}->{TOTALTRIALS}));

    $self->{PARAMS}->{BETA} = $self->{PARAMS}->{ValueC} / $self->{PARAMS}->{ValueV} * 
      ((1 / $self->{PARAMS}->{ProbOfTerm}) - 1);

    bless $self;
    return $self;
  }


####################################################################################################
=pod

=item B<isoCombCoeffForDETCurve>()

Returns an array of coefficients to define what iso lines to draw on a DET Curve for the defined 
combiner metric. These are the defaults for the Metric, but can be overridden by DETUtil and the actual scoring
application.

=cut

sub isoCombCoeffForDETCurve(){ (0.1, 0.2, 0.4, 0.5, 0.7, 1.0 ) }


####################################################################################################
=pod

=item B<isoCostRatioCoeffForDETCurve>()

Returns an array of coefficients to define what iso lines to draw on a DET Curve.  For instance, if the
combined metric model is:

  Combined = C_m * Miss + C_f * FA
  
Then the coefficients represent various values of C_m / C_f.  

These are the defaults for the Metric, but can be overridden by DETUtil and the actual scoring
application.

=cut

sub isoCostRatioCoeffForDETCurve(){ (0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 40, 100, 200, 500, 1000, 2000, 3000, 5000, 10000, 20000, 50000, 100000, 200000, 400000, 600000, 800000, 900000, 950000, 980000) }


sub errMissLab(){ "PMiss"; }
sub errMissUnit(){ "Prob" };
sub errMissUnitLabel(){ "%" };
sub errMissBlockCalc(){
  my ($self, $nMiss, $block) = @_;
  my $NTarg =  $self->{TRIALS}->getNumTarg($block);
  
  ($NTarg > 0) ? $nMiss / $NTarg : undef;
}
sub errMissBlockSetCalc(){
  my ($self, $data) = @_;
  #### Data is a hass ref with the primary key being a block and for each block there t
  #### MUST be a key 'MMISS' as a secondary key 

  my ($sum, $sumsqr, $n) = (0, 0);
  foreach my $block (keys %$data) {
    my $lu = $data->{$block}{MMISS};
    die "Error: Can't calculate errMissBlockSetCalc: key 'MMISS' for block '$block' missing" if (! defined($lu));

    if ($self->{TRIALS}->getNumTarg($block) > 0) {
      my $miss = $self->errMissBlockCalc($lu, $block);
      $sum += $miss;
      $sumsqr += $miss * $miss;
      $n ++;
    }
  }
  ($sum / $n, ($n < 2 ? undef : sqrt((($n * $sumsqr) - ($sum * $sum)) / ($n * ($n - 1)))));
}

####################################################################################################
=pod

=item B<errMissPrintFormat>()

Returns a printf() format string for printing out miss error measurements. 

=cut

sub errMissPrintFormat(){ "%6.4f" };

sub errFALab() { "PFA"; }
sub errFAUnit(){ "Prob" };
sub errFAUnitLabel(){ "%" };
sub errFABlockCalc(){
  my ($self, $nFa, $block) = @_;
  my $NNonTargTrials = (defined($self->{TRIALPARAMS}->{TOTALTRIALS}) ? 
                        $self->{TRIALPARAMS}->{TOTALTRIALS} - $self->{TRIALS}->getNumTarg($block) : 
                        $self->{TRIALS}->getNumNonTarg($block));
  $nFa / $NNonTargTrials;
}
sub errFABlockSetCalc(){
  my ($self, $data) = @_;
  #### Data is a hass ref with the primary key being a block and for each block there t
  #### MUST be a key 'MFA' as a secondary key }
  my ($sum, $sumsqr, $n) = (0, 0, 0);
  foreach my $block (keys %$data) {
    my $lu = $data->{$block}{MFA};
    my $Ntarg =  $self->{TRIALS}->getNumTarg($block);
    die "Error: Can't calculate errFABlockSetCalc: key '".$self->errFALab()."' for block '$block' missing" if (! defined($lu));
            
    next if ($self->{TRIALS}->getNumTarg($block) == 0);
    my $fa = $self->errFABlockCalc($lu, $block);
    $sum += $fa;
    $sumsqr += $fa * $fa;
    $n ++;
  }
  ($sum / $n, ($n < 2 ? undef : sqrt((($n * $sumsqr) - ($sum * $sum)) / ($n * ($n - 1)))));
}

####################################################################################################
=pod

=item B<errFAPrintFormat>()

Returns a printf() format string for printing out false alarm error measurements. 

=cut

sub errFAPrintFormat(){ "%6.4f" };

### Either 'maximizable' or 'minimizable'
sub combType() { "maximizable"; }
sub combLab() { "Value"; }
sub combCalc(){
  my ($self, $missErr, $faErr) = @_;
  if (defined($missErr)) {
    1  - ($missErr + $self->{PARAMS}->{BETA} * $faErr);
  } else {
    undef;
  }
}

####################################################################################################
=pod

=item B<combPrintFormat>()

Returns a printf() format string for printing out combined performance statistic. 

=cut
  sub combPrintFormat(){ "%6.4f" };

####################################################################################################
=pod

=item B<MISSForGivenComb>(I<$comb, I<$faErr>)

Calculates the value of the Miss statistic for a given combined measure and the FA value.  This is 
a permutation of the combined formula to solve for the Miss value. This method uses the constants 
defined during object creation.  If either C<$comb> or 
C<$faErr> is undefined, then the combined calculation returns C<undef>,

=cut

sub MISSForGivenComb(){
  my ($self, $comb, $faErr) = @_;
  if (defined($comb) && defined($faErr)) {
    - ($comb - 1 + $self->{PARAMS}->{BETA} * $faErr);
  } else {
    undef;
  }
}

=pod

=item B<FAForGivenComb>(I<$comb, I<$missErr>)

Calculates the value of the Fa statistic for a given combined measure and the Miss value.  This is 
a permutation of the combined formula to solve for the Fa value. This method uses the constants 
defined during object creation.  If either C<$comb> or 
C<$missErr> is undefined, then the combined calculation returns C<undef>,

=cut

sub FAForGivenComb(){
	my ($self, $comb, $missErr) = @_;
	if (defined($comb) && defined($missErr)) {
	  (1 - $comb - $missErr)/$self->{PARAMS}->{BETA};
	} else {
	  undef;
	}
}

sub combBlockCalc(){
  my ($self, $nMiss, $nFa, $block) = @_;
  $self->combErrCalc($self->errMissCalc($nMiss, $block), $self->errFACalc($nFa, $block));
}
sub combBlockSetCalc(){
  my ($self, $data) = @_;
  #### Data is a hass ref with the primary key being a block and for each block there 
  #### MUST be a 2 secondary keys, 'MMISS' and 'MFA'
  my ($missAvg, $missSSD) = $self->errMissBlockSetCalc($data);
  my ($faAvg,   $faSSD)   = $self->errFABlockSetCalc($data);    
  #    my $combAvg = $self->combErrCalc($missAvg, $faAvg);
  #    ($combAvg, undef, $missAvg, $missSSD, $faAvg, $faSSD);

  my ($sum, $sumsqr, $n) = (0, 0, 0);
  foreach my $block (keys %$data) {
    my $luFA = $data->{$block}{MFA};
    my $luMiss = $data->{$block}{MMISS};
    die "Error: Can't calculate errCombBlockSetCalc: key 'MFA' for block '$block' missing" if (! defined($luFA));
    die "Error: Can't calculate errCombBlockSetCalc: key 'MMISS' for block '$block' missing" if (! defined($luMiss));

    next if ($self->{TRIALS}->getNumTarg($block) == 0);

    my $miss = $self->errMissBlockCalc($luMiss, $block); 
    my $fa = $self->errFABlockCalc($luFA, $block); 

    $sum += $self->combCalc($miss, $fa);
    $sumsqr += $self->combCalc($miss, $fa) * $self->combCalc($miss, $fa);
    $n ++;
  }
  die "Error: Can't calculate errFABlockSetCalc: zero blocks" if ($n == 0);
  ($sum / $n,
   ($n < 2 ? undef : sqrt((($n * $sumsqr) - ($sum * $sum)) / ($n * ($n - 1)))),
   $missAvg, $missSSD, $faAvg, $faSSD);
}

sub isCompatible(){
  1;
}

1;
