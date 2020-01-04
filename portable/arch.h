#pragma once

#include "../ac_cfg.h"

#if defined(_MSC_VER)
// build with microsoft compiler
#include "msvc/config.h"

#elif defined(__CYGWIN__) || defined(__MINGW32__)
// build with cygwin or mingw for windows
#include "windows/config.h"

#elif defined(__ARMEL__)
// build with raspberry pi or other arm based machine
#include "linux-arm/config.h"

#else
// build for linux
#include "linux/config.h"

#endif
