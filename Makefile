
include make-platform.mk

TARGET       = avrdude

PREFIX      ?= /usr/local
BINDIR       = ${PREFIX}/bin
MANDIR       = ${PREFIX}/man/man1
MANUAL       = avrdude.1
DOCDIR       = ${PREFIX}/share/doc/avrdude
CONFIGDIR    = ${PREFIX}/etc

DIRS         = ${BINDIR} ${MANDIR} ${DOCDIR} ${CONFIGDIR}

INSTALL      = /usr/bin/install -c -o root -g wheel

CXX          := g++
DEBUG_FLAGS  = -g
CFLAGS       += -c -Wall -DCONFIG_DIR=\"${CONFIGDIR}\" ${YYDEF}
CXXFLAGS     += -c -Wall -DCONFIG_DIR=\"${CONFIGDIR}\" ${YYDEF}
LINK         := g++
LDFLAGS      =  
#zusaetzliche Ausgabe Datei *.output -v
YFLAGS       = -t -v

LEXLIB = -lfl

LIBS     += $(LEXLIB) $(PLATFORM_LIBS) -lm
CFLAGS   += $(PLATFORM_CXXFLAGS) $(PLATFORM_INCLUDES)
CXXFLAGS += $(PLATFORM_CXXFLAGS) $(PLATFORM_INCLUDES)

ifdef COMSPEC
# Windows
EXT   = .exe
endif


INSTALL_PROGRAM = ${INSTALL} -m 555 -s
INSTALL_DATA    = ${INSTALL} -m 444
INSTALL_MANUAL  = ${INSTALL_DATA}


YYDEF  = -DYYSTYPE="struct token_t *"


SOURCE_FILES = $(filter-out config_gram.tab.cpp lexer.flex.cpp, $(wildcard *.cpp))

SRCS = $(SOURCE_FILES)

OBJS = $(subst .cpp,.o,$(SOURCE_FILES))

FLEX_SOURCE  = $(wildcard *.l)
FLEX_FILES   = $(subst .l,.flex.cpp,$(FLEX_SOURCE))
BISON_SOURCE = $(wildcard *.y)
BISON_FILES  = $(subst .y,.tab.cpp,$(BISON_SOURCE))
BISON_HEADERS= $(subst .y,.tab.h,$(BISON_SOURCE))
BISON_OBJ_FILES =  $(subst .y,.tab.o,$(BISON_SOURCE)) \
		   $(subst .l,.flex.o,$(FLEX_SOURCE))

OBJ_FILES = $(BISON_OBJ_FILES) $(OBJS)

LINK_OBJECTS = main.o

all: printlibs depend $(TARGET)

.PHONY: windows doc .depend

doc:
	make -C doc

windows:
	make -C windows

#compile
${OBJS}: %.o: %.cpp
	$(CXX) -o $@ $(CXXFLAGS) $<

#link
${TARGET} : main.o $(OBJ_FILES)
	${LINK} ${LDFLAGS} -o $(TARGET)$(EXT) $^ ${LIBS}

clean:
	rm -f *.o ${OBJ_FILES} $(FLEX_FILES) $(BISON_FILES) $(BISON_HEADERS) ${TARGET} *.output *.exe
	make -C doc clean
	make -C windows clean

distclean:
	make clean
	rm -rf .depend

install : dirs                             \
	  ${BINDIR}/${TARGET}              \
	  ${MANDIR}/${MANUAL}              \
	  ${DOCDIR}/avrdude.pdf            \
	  ${CONFIGDIR}/avrdude.conf.sample \
	  ${CONFIGDIR}/avrdude.conf

dirs :
	@for dir in ${DIRS}; do \
	  if [ ! -d $$dir ]; then \
	    echo "creating directory $$dir"; \
	    mkdir -p $$dir; \
	  fi \
	done

${BINDIR}/${TARGET} : ${TARGET}
	${INSTALL_PROGRAM} ${TARGET} $@

${MANDIR}/${MANUAL} : ${MANUAL}
	${INSTALL_MANUAL} ${MANUAL} $@

${DOCDIR}/avrdude.pdf : avrdude.pdf
	${INSTALL_DATA} avrdude.pdf $@

${CONFIGDIR}/avrdude.conf.sample : avrdude.conf.sample
	${INSTALL_DATA} avrdude.conf.sample $@

${CONFIGDIR}/avrdude.conf : avrdude.conf.sample
	@if [ -f ${CONFIGDIR}/avrdude.conf ]; then                       \
	  export TS=`date '+%Y%m%d%H%M%S'`;                              \
	  echo "NOTE: backing up ${CONFIGDIR}/avrdude.conf to ${CONFIGDIR}/avrdude.conf.$${TS}"; \
	  cp -p ${CONFIGDIR}/avrdude.conf ${CONFIGDIR}/avrdude.conf.$${TS}; \
	fi
	${INSTALL_DATA} avrdude.conf.sample $@

.SUFFIXES: .c .y .l

%.tab.cpp: %.y
	${YACC} ${YFLAGS} --output=$@ --defines=$(subst .cpp,.h,$@) $<

%.flex.cpp: %.l
	${LEX} --outfile=$@ $<




printlibs:
	@echo "HAVE_LIBELF     = $(HAVE_LIBELF)"
	@echo "HAVE_LIBFTDI    = $(HAVE_LIBFTDI)"
	@echo "HAVE_LIBFTDI1   = $(HAVE_LIBFTDI1)"
	@echo "HAVE_LIBUSB     = $(HAVE_LIBUSB)"
	@echo "HAVE_LIBUSB_1_0 = $(HAVE_LIBUSB_1_0)"
	@echo "HAVE_LIBPTHREAD = $(HAVE_LIBPTHREAD)"


depend: config_gram.tab.cpp config_gram.y lexer.flex.cpp lexer.l
	@if [ ! -f config_gram.tab.h ]; then touch config_gram.tab.h; fi
	${CXX} ${CXXFLAGS} -MM ${SRCS} > .depend


include .depend
