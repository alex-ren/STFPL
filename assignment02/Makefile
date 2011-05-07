##
##
## A Makefile template for compiling ATS programs
##
##

######

#
# For using the version on csa2:
#
# ATSHOME=/tmp/ATS-0.2.4
# ATSHOMERELOC=ATS-0.2.4

######

ATSUSRQ="$(ATSHOME)"
ATSLIBQ=$(ATSUSRQ)
ifeq ($(ATSUSRQ),"")
ATSUSRQ="/usr"
endif # end of [ifeq]

######

ATSCC=$(ATSUSRQ)/bin/atscc
ATSOPT=$(ATSUSRQ)/bin/atsopt

LIBPARCOMB=$(ATSHOME)/contrib/parcomb/atsctrb_parcomb.o

######

#
# HX: Please uncomment the one you want, or skip it entirely
#
ATSCCFLAGS=
# ATSCCFLAGS=-D_ATS_GCATS
ATSCCFLAGS=-O2
#
# '-flto' enables link-time optimization such as inlining lib functions
#
#ATSCCFLAGS=-O2 -flto -D_ATS_GCATS

######

######
RMF = rm -f

# convert the file name to .o files
# $(call atsobjname,filelist)
define atsobjname
$(patsubst %.dats,%_dats.o,$(patsubst %.sats,%_sats.o,$1))
endef

define atsdepname
$(patsubst %.dats,%_dats.d,$(patsubst %.sats,%_sats.d,$1))
endef

define atshtmlname
$(patsubst %.dats,%_dats.html,$(patsubst %.sats,%_sats.html,$1))
endef

SOURCES_COMM := \
  absyn.sats \
  absyn.dats \
  symbol.sats \
  symbol.dats \
  error.sats \
  error.dats \
  fixity.sats \
  fixity.dats \
  parser.sats \
  parser.dats \
  interp0.sats \
  interp0.dats \
  interp1.sats \
  interp1.dats \
  absyn1.dats \
  trans1.sats \
  trans1.dats \
  trans_closure.sats \
  trans_closure.dats \
  libfunctions.sats \
  libfunctions.dats \
  trans2.sats \
  trans2.dats \
  trans_cpp.sats \
  trans_cpp.dats \
  ostream.sats \
  ostream.dats \
  string_opr.sats \
  string_opr.dats \
  trans_llvm.sats \
  trans_llvm.dats \

SOURCES_CPP := \
  test_cpp.dats

SOURCES_LLVM := \
  test_llvm.dats

SOURCES := $(SOURCES_CPP) $(SOURCES_CPP) $(SOURCES_LLVM)

OBJECTS_COMM := $(call atsobjname,$(SOURCES_COMM))
OBJECTS_CPP := $(call atsobjname,$(SOURCES_CPP))
OBJECTS_LLVM := $(call atsobjname,$(SOURCES_LLVM))

target := tester_cpp tester_llvm

.PHONY: all
all: ${target}

tester_cpp: $(OBJECTS_COMM) $(OBJECTS_CPP)
	$(ATSCC) -D_ATS_GCATS -o $@ $^ $(LIBPARCOMB) -lats_smlbas
	cp $@ ./TRANS_CPP

tester_llvm: $(OBJECTS_COMM) $(OBJECTS_LLVM)
	$(ATSCC) -D_ATS_GCATS -o $@ $^ $(LIBPARCOMB) -lats_smlbas
	cp $@ ./TRANS_LLVM

# #################
$(call atsobjname,%.sats): %.sats
	$(ATSCC) $(ATSCCFLAGS) -c $< -o $@
# || touch $@

$(call atsobjname,%.dats): %.dats
	$(ATSCC) $(ATSCCFLAGS) -c $< -o $@

# #################
# Generate dependency files
# SOURCESsta := $(filter %.sats, $(SOURCES))
# SOURCESdyn := $(filter %.dats, $(SOURCES))

ifneq "$(findstring clean,$(MAKECMDGOALS))" "clean"
  ifneq "$(MAKECMDGOALS)" "html"
    ifneq "$(MAKECMDGOALS)" "xref"
      -include $(call atsdepname,$(SOURCES))
    endif
  endif
endif

$(call atsdepname,%.sats): %.sats
	$(ATSOPT) -o $@.$$$$ -dep1 -s $<;    \
	sed 's/\(.*\)\.o[ :]*/\1.o $@ : /g' < $@.$$$$ > $@;    \
	rm -f $@.$$$$

$(call atsdepname,%.dats): %.dats
	$(ATSOPT) -o $@.$$$$ -dep1 -d $<;    \
	sed 's/\(.*\)\.o[ :]*/\1.o $@ : /g' < $@.$$$$ > $@;    \
	rm -f $@.$$$$
######
# Generate html files for ATS source code
source_sats := $(wildcard *.sats)
source_dats := $(wildcard *.dats)

html_file_sats := $(call atshtmlname,$(source_sats))
html_file_dats := $(call atshtmlname,$(source_dats))

.PHONE: html

html: $(html_file_sats) $(html_file_dats)

$(html_file_sats): $(call atshtmlname,%.sats): %.sats
	$(ATSOPT) --posmark_html -s $< > $@

$(html_file_dats): $(call atshtmlname,%.dats): %.dats
	$(ATSOPT) --posmark_html -d $< > $@

######

.PHONY: clean distclean

clean::
	$(RMF) *~
	$(RMF) $(call atsobjname,*.sats *.dats)
	$(RMF) $(call atsdepname,*.sats *.dats)
	$(RMF) *_?ats.c
	$(RMF) $(target)

distclean: clean
	$(RMF) $(call atshtmlname,*.sats *.dats)
	$(RMF) ./XREF/*.html

###### end of [Makefile] ######


xref::
	$(ATSOPT) -IATS PARCOMB -IATS LIB \
          --posmark_xref=XREF -d absyn.dats > xref_absyn_dats.html
	$(ATSOPT) -IATS PARCOMB -IATS LIB \
	  --posmark_xref=XREF -d fixity.dats > xref_fixity_dats.html
	$(ATSOPT) -IATS PARCOMB -IATS LIB \
	  --posmark_xref=XREF -d parser.dats > xref_parser_dats.html

	$(ATSOPT) --posmark_xref=XREF -d symbol.dats > xref_symbol_dats.html
	$(ATSOPT) --posmark_xref=XREF -d interp0.dats > xref_interp0_dats.html
	$(ATSOPT) --posmark_xref=XREF -d interp1.dats > xref_interp1_dats.html
	$(ATSOPT) --posmark_xref=XREF -d error.dats > xref_error_dats.html
	$(ATSOPT) --posmark_xref=XREF -d trans1.dats > xref_trans1_dats.html
	$(ATSOPT) --posmark_xref=XREF -d trans_closure.dats > xref_trans_closure_dats.html
	$(ATSOPT) --posmark_xref=XREF -d absyn1.dats > xref_absyn1_dats.html
	$(ATSOPT) --posmark_xref=XREF -d libfunctions.dats > xref_libfunctions_dats.html
	$(ATSOPT) --posmark_xref=XREF -d trans2.dats > xref_trans2_dats.html
	$(ATSOPT) --posmark_xref=XREF -d trans_cpp.dats > xref_trans_cpp_dats.html
	$(ATSOPT) --posmark_xref=XREF -d ostream.dats > xref_ostream_dats.html
	$(ATSOPT) --posmark_xref=XREF -d string_opr.dats > xref_string_opr_dats.html
	$(ATSOPT) --posmark_xref=XREF -d test_cpp.dats > xref_test_cpp_dats.html
	$(ATSOPT) --posmark_xref=XREF -d test_llmv.dats > xref_test_llvm_dats.html


