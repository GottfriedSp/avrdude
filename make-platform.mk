
ifdef COMSPEC
#Cygwin
##  Cygwin Pakete installieren:
##    libftdi1-devel libelf-devel libhidapi-devel libusb-devel libusb1.0-devel libreadline-devel
##    libtool texi2html texinfo-tex

PLATFORMLIBPATH := /usr/lib
PLATFORM_CYGWINLIBROOT    := /usr/i686-pc-cygwin/sys-root/usr/lib
PLATFORM_CYGWINLIBROOTWIN := /usr/i686-pc-cygwin/sys-root/usr/lib/w32api
HAVE_LIBELF     := $(and $(wildcard $(PLATFORMLIBPATH)/libelf.a),1)
HAVE_LIBFTDI    := $(and $(wildcard $(PLATFORMLIBPATH)/libftdi.a),1)
HAVE_LIBFTDI1   := $(and $(wildcard $(PLATFORMLIBPATH)/libftdi1.a),1)
HAVE_LIBUSB     := $(and $(wildcard $(PLATFORMLIBPATH)/libusb.dll.a),1)
HAVE_LIBUSB_1_0 := $(and $(wildcard $(PLATFORMLIBPATH)/libusb-1.0.dll.a),1)
HAVE_LIBPTHREAD := $(and $(wildcard $(PLATFORMLIBPATH)/libpthread.a),1)
HAVE_LIBHID     := $(and $(wildcard $(PLATFORMLIBPATH)/libhid.dll.a),1)
HAVE_LIBHIDAPI  := $(and $(wildcard $(PLATFORMLIBPATH)/libhidapi.dll.a),1)
HAVE_LIBREADLINE:= $(and $(wildcard $(PLATFORMLIBPATH)/libreadline.a),1)

HAVE_LIBWS2_32  := $(and $(wildcard $(PLATFORM_CYGWINLIBROOTWIN)/libws2_32.a),1) 

ifdef HAVE_LIBWS2_32
PLATFORM_LIBS     += -lws2_32
PLATFORM_CXXFLAGS += -DHAVE_LIBWS2_32
endif
PLATFORM_CXXFLAGS += -DWIN32NATIVE

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
HAVE_LIBUSB_1_0 := $(shell /sbin/ldconfig -p |grep libusb-1.0.so    | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBPTHREAD := $(shell /sbin/ldconfig -p |grep libpthread.so    | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBHID     := $(shell /sbin/ldconfig -p |grep libhid.so        | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBHIDAPI  := $(shell /sbin/ldconfig -p |grep libhidapi.so     | awk '{split($$1,a,"-");print a[1]}' )
HAVE_LIBREADLINE:= $(shell /sbin/ldconfig -p |grep libreadline.so   | awk '{split($$1,a,"-");print a[1]}' )

PLATFORM_CXXFLAGS += -DHAVE_LINUXGPIO

endif



#set libraries

ifdef HAVE_LIBELF
PLATFORM_LIBS += -lelf
endif
ifdef HAVE_LIBFTDI
PLATFORM_LIBS += -lftdi -lusb
endif
ifdef HAVE_LIBFTDI1
PLATFORM_LIBS += -lftdi1
endif
ifdef HAVE_LIBUSB
PLATFORM_LIBS += -lusb
endif
ifdef HAVE_LIBUSB_1_0
PLATFORM_LIBS += -lusb-1.0
endif
ifdef HAVE_LIBHID
PLATFORM_LIBS += -lhid
endif
ifdef HAVE_LIBHIDAPI
PLATFORM_LIBS += -lhidapi
endif
ifdef HAVE_LIBPTHREAD
PLATFORM_LIBS += -lpthread
endif
ifdef HAVE_LIBREADLINE
PLATFORM_LIBS  += -lreadline
endif



#### defines can be set here ####
ifdef HAVE_LIBELF
PLATFORM_CXXFLAGS += -DHAVE_LIBELF
endif
ifdef HAVE_LIBFTDI
PLATFORM_CXXFLAGS += -DHAVE_LIBFTDI
endif
ifdef HAVE_LIBFTDI1
PLATFORM_CXXFLAGS += -DHAVE_LIBFTDI1
endif
ifdef HAVE_LIBUSB
PLATFORM_CXXFLAGS += -DHAVE_LIBUSB
endif
ifdef HAVE_LIBUSB_1_0
PLATFORM_CXXFLAGS += -DHAVE_LIBUSB_1_0
endif
ifdef HAVE_LIBHID
PLATFORM_CXXFLAGS += -DHAVE_LIBHID
endif
ifdef HAVE_LIBHIDAPI
PLATFORM_CXXFLAGS += -DHAVE_LIBHIDAPI
endif
ifdef HAVE_LIBPTHREAD
PLATFORM_CXXFLAGS += -DHAVE_LIBPTHREAD
endif
ifdef HAVE_LIBREADLINE
PLATFORM_CXXFLAGS += -DHAVE_LIBREADLINE
endif


#### additional include paths can be set here ####
#example
#PLATFORM_INCLUDES += -I.

#if HAVE_LIBUSB_1_0
PLATFORM_INCLUDES += -I/usr/include/libusb-1.0

