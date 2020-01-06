#pragma once

// configuration for amd linux
// Raspberry Pi

#define HAVE_LINUX_SPI_SPIDEV_H
#define HAVE_SPIDEV

#undef HAVE_GETADDRINFO
#undef HAVE_NETINET_IN_H
// we have linux/parport.h but raspberry pi have no native parallel port
#undef HAVE_PARPORT

