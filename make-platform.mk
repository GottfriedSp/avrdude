
ifdef COMSPEC
#Cygwin
PLATFORMLIBPATH := /usr/lib
##  Cygwin Pakete installieren:
##    libftdi1-devel libelf-devel libhidapi-devel libusb-devel libusb1.0-devel
##    libtool texi2html texinfo-tex

HAVE_LIBELF     := $(and $(wildcard $(PLATFORMLIBPATH)/libelf.a),1)
HAVE_LIBFTDI    := $(and $(wildcard $(PLATFORMLIBPATH)/libftdi.a),1)
HAVE_LIBFTDI1   := $(and $(wildcard $(PLATFORMLIBPATH)/libftdi1.a),1)
HAVE_LIBUSB     := $(and $(wildcard $(PLATFORMLIBPATH)/libusb.dll.a),1)
HAVE_LIBPTHREAD := $(and $(wildcard $(PLATFORMLIBPATH)/libpthread.a),1)
HAVE_LIBUSB_1_0 := $(and $(wildcard $(PLATFORMLIBPATH)/libusb-1.0.dll.a),1)

else
#Debian / raspbian
## debian
##   sudo apt-get install bison flex make gcc
##   sudo apt-get install libelf-dev libusb-dev libusb-1.0-0-dev libftdi-dev libftdi1-dev libhidapi-dev
##   sudo apt-get install texi2html texinfo texlive     # for doc
## raspbian
##   sudo apt-get install bison flex make gcc
##   sudo apt-get install libelf-dev libusb-dev libusb-1.0-0-dev libftdi-dev libhidapi-dev
##   sudo apt-get install texi2html texinfo texlive     # for doc

HAVE_LIBELF     := $(shell /sbin/ldconfig -p |grep libelf.so        | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBFTDI    := $(shell /sbin/ldconfig -p |grep libftdi.so       | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBFTDI1   := $(shell /sbin/ldconfig -p |grep libftdi1.so      | awk '{split($$1,a,"-");print a[1]}' )
# we have here libhidapi-libusb.so and libusb.a is not find with ldconfig
#HAVE_LIBUSB     := $(shell /sbin/ldconfig -p |grep libusb.so       | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBPTHREAD := $(shell /sbin/ldconfig -p |grep libpthread.so    | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBUSB_1_0 := $(shell /sbin/ldconfig -p |grep liblibusb-1.0.so | awk '{split($$1,a,"-");print a[1]}' )


endif


