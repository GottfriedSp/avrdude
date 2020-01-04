

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
LIBELF = -lelf
LIBFTDI =
LIBFTDI1 = -lftdi1
LIBHID =
LIBHIDAPI =
LIBPTHREAD = -lpthread
LIBUSB = -lusb
LIBUSB_1_0 = -lusb-1.0
LIPO =

LIBS = -lhidapi -lncurses
LIBS += $(LEXLIB) $(LIBUSB_1_0) $(LIBUSB) $(LIBFTDI) $(LIBFTDI1) $(LIBHID) $(LIBELF) $(LIBPTHREAD) -lm

ifdef COMSPEC
# Windows
CFLAGS   += -DWIN32NATIVE
CXXFLAGS += -DWIN32NATIVE
EXT   = .exe
LIBS  += -lws2_32
MAKE_WINDOWS_LOADDRV = windows
else
# linux
#LIBS  += -lreadline
endif


INSTALL_PROGRAM = ${INSTALL} -m 555 -s
INSTALL_DATA    = ${INSTALL} -m 444
INSTALL_MANUAL  = ${INSTALL_DATA}


YYDEF  = -DYYSTYPE="struct token_t *"


SOURCE_FILES = $(filter-out config_gram.tab.cpp lexer.flex.cpp, $(wildcard *.cpp))

SRCS = $(SOURCE_FILES)

OBJS = $(subst .cpp,.o,$(SOURCE_FILES))

FLEX_SOURCE  = $(wildcard *.l)
FLEX_FILES   = $(subst l,flex.cpp,$(FLEX_SOURCE))
BISON_SOURCE = $(wildcard *.y)
BISON_FILES  = $(subst y,tab.cpp,$(BISON_SOURCE))
BISON_HEADERS= $(subst y,tab.h,$(BISON_SOURCE))
BISON_OBJ_FILES =  $(subst .y,.tab.o,$(BISON_SOURCE)) \
		   $(subst .l,.flex.o,$(FLEX_SOURCE))

OBJ_FILES = $(BISON_OBJ_FILES) $(OBJS)

LINK_OBJECTS = main.o

all : depend ${TARGET} doc $(MAKE_WINDOWS_LOADDRV)

.PHONY: windows doc

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
	rm -f *.o ${OBJ_FILES} $(FLEX_FILES) $(BISON_FILES) $(BISON_HEADERS) ${TARGET} *.output  *.exe
	make -C doc clean
	make -C windows clean

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
	${YACC} ${YFLAGS} --output=$@ --defines=$(subst .y,.tab.h,$^) $<

%.flex.cpp: %.l
	${LEX} --outfile=$@ $<

depend:
	@if [ ! -f y.tab.h ]; then touch y.tab.h; fi
	@${MAKE} config_gram.tab.cpp lexer.flex.cpp
	@${CC} ${CFLAGS} -MM ${SRCS} > .depend


include .depend
