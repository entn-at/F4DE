# TrecVid08/test/TV08ViperValidator
include ../../../Makefile_common

TV08ViperValidator_tester=TV08ViperValidator_tester.pl

ifdef F4DE_TEST_INSTALLDIR
TV08ViperValidator=../../../bin/TV08ViperValidator
else
TV08ViperValidator_exec=TV08ViperValidator.pl
TV08ViperValidator_reldir=../../tools/TV08ViperValidator
TV08ViperValidator=${TV08ViperValidator_reldir}/${TV08ViperValidator_exec}
endif

TV08TC_lib=../lib
F4DEC_lib=../../../common/lib
PERL=${F4DEPERL} -I${TV08TC_lib} -I${F4DEC_lib}

all:
	@echo "Nothing to do"

install:
	@echo "Nothing to do for install"

check: ${TV08ViperValidator_tester_exec} ${TV08ViperValidator}
	@(${PERL} ${TV08ViperValidator_tester} ${TV08ViperValidator} $@)

makecheckfiles: ${TV08ViperValidator_tester_exec} ${TV08ViperValidator}
	@(${PERL} ${TV08ViperValidator_tester} ${TV08ViperValidator} $@)

makecompcheckfiles: ${TV08ViperValidator_tester_exec} ${TV08ViperValidator}
	@(${PERL} ${TV08ViperValidator_tester} ${TV08ViperValidator} $@)

cleanresfiles:
	@rm -f res_*.txt
