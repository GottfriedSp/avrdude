#! /bin/sh


# install buildsystem for avrdude
sudo apt-get install bison flex make gcc \
  libelf-dev libusb-dev libusb-1.0-0-dev libftdi-dev libreadline-dev libhidapi-dev

# uncomment next line if you need to build documentation (needs verry long time to install and needs much space on SD)
#sudo apt-get install texi2html texinfo texlive
