#pragma once

// configuration for vc compiler

#ifndef WIN32NATIVE
#define WIN32NATIVE
#endif

#define HAVE_LIBWS2_32

// This we don't have for msvc
#undef HAVE_NETINET_IN_H

//#define HAVE_LIBELF
//#define HAVE_LIBFTDI
//#define HAVE_LIBFTDI1
//#define HAVE_LIBUSB
//#define HAVE_LIBUSB_1_0
//#define HAVE_LIBHID
//#define HAVE_LIBHIDAPI
//#define HAVE_LIBPTHREAD
//#define HAVE_LIBREADLINE
