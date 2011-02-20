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

SOURCES := \
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
  trans1.sats \
  trans1.dats \
  test.dats \

OBJECTS := $(call atsobjname,$(SOURCES))

target := tester

.PHONY: all
all: ${target}

tester: $(OBJECTS)
	$(ATSCC) -D_ATS_GCATS -o $@ $^ $(LIBPARCOMB)


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
    -include $(call atsdepname,$(SOURCES))
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

###### end of [Makefile] ######



