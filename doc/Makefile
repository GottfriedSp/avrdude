
AWK = gawk

info_TEXINFOS = avrdude.texi
GENERATED_TEXINFOS = \
	     	     programmers.texi \
	     	     parts.texi \
	     	     programmer_types.texi \
	     	     version.texi
INFO_DEPS = avrdude.info

DVIS = avrdude.dvi
PDFS = avrdude.pdf
HTMLS = avrdude.html
PSS = avrdude.ps


# TODO: version ermitteln
VERSION = 6.3


ifdef COMSPEC
# Windows
EXT   = .exe
else
# linux
endif


all: info html pdf ps

clean:
	rm -rf avrdude-html *.info $(GENERATED_TEXINFOS) stamp-vti $(DVIS) $(PDFS) $(HTMLS) $(PSS) *.t2d *.t2p


# avrdude executable erstellen, falls noch nicht existiert
../avrdude$(EXT):
	make -C .. avrdude


.SUFFIXES: .dvi .html .info .pdf .ps .texi

info: $(INFO_DEPS)

programmers.texi: ../avrdude$(EXT) ../avrdude.conf
	../avrdude$(EXT) -C ../avrdude.conf -c \? 2>&1 \
		| $(AWK) '$$2 ~ /^=$$/ {printf("@item @code{%s} @tab %s\n",$$1,gensub("[^=]+=[ \t]*","",1))}' \
		| sed "s# *,\? *<\?\(http://[^ \t>]*\)>\?#,@*\n@url{\1}#g" \
		>programmers.texi


programmer_types.texi: ../avrdude$(EXT) ../avrdude.conf
	../avrdude$(EXT) -C ../avrdude.conf -c \?type 2>&1 \
		| $(AWK) '$$2 ~ /^=$$/ {printf("@item @code{%s} @tab %s\n",$$1,gensub("[^=]+=[ \t]*","",1))}' \
		| sed "s#<\?\(http://[^ \t,>]*\)>\?#@url{\1}#g" \
		>programmer_types.texi

parts.texi: ../avrdude$(EXT) ../avrdude.conf parts_comments.txt
	../avrdude$(EXT) -C ../avrdude.conf -p \? 2>&1 \
		| $(AWK) '$$2 ~ /^=$$/ {printf("@item @code{%s} @tab %s\n",$$1,$$3)}' \
		| sed -e "`sed 's:\([^ \t]*\)[ \t]*\(.*\):s/\1$$/\1 \2/g:g' <parts_comments.txt`" \
		>parts.texi

avrdude.info: avrdude.texi $(GENERATED_TEXINFOS)
avrdude.dvi: avrdude.texi $(GENERATED_TEXINFOS)
avrdude.pdf: avrdude.texi $(GENERATED_TEXINFOS)
avrdude.html: avrdude.texi $(GENERATED_TEXINFOS)
version.texi:  stamp-vti
version.texi: stamp-vti

stamp-vti: avrdude.texi
	@(dir=.; test -f ./avrdude.texi || dir=.; \
	set `$(SHELL) mdate-sh $$dir/avrdude.texi`; \
	echo "@set UPDATED $$1 $$2 $$3"; \
	echo "@set UPDATED-MONTH $$2 $$3"; \
	echo "@set EDITION $(VERSION)"; \
	echo "@set VERSION $(VERSION)") > vti.tmp$$$$ && \
	(cmp -s vti.tmp$$$$ version.texi \
	  || (echo "Updating version.texi" && \
	      cp vti.tmp$$$$ version.texi.tmp$$$$ && \
	      mv version.texi.tmp$$$$ version.texi)) && \
	rm -f vti.tmp$$$$ version.texi.$$$$
	@cp version.texi $@




html: avrdude-html/avrdude.html

.texi.html:
	rm -rf $(@:.html=.htp)
	if $(MAKEINFOHTML) $(AM_MAKEINFOHTMLFLAGS) $(MAKEINFOFLAGS) -I -o $(@:.html=.htp) $<; \
	then \
	  rm -rf $@ && mv $(@:.html=.htp) $@; \
	else \
	  rm -rf $(@:.html=.htp); exit 1; \
	fi

avrdude-html/avrdude.html: $(info_TEXINFOS) $(GENERATED_TEXINFOS)
	texi2html -split_node $(info_TEXINFOS)
	if [ -e ./avrdude.html -o -e ./avrdude_1.html ]; then \
	 mkdir -p avrdude-html ; \
	 mv -f *.html avrdude-html ; \
	else \
	 mv -f avrdude avrdude-html; \
	fi;




pdf: $(PDFS)

.texi.dvi:
	texi2dvi --build-dir=$(@:.dvi=.t2d) -o $@ $<

.texi.pdf:
	texi2pdf --build-dir=$(@:.pdf=.t2p) -o $@ $<



ps: $(PSS)

.dvi.ps:
	dvips -o $@ $<

