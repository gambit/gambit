#!/bin/sh

rm -rf gsc-boot boot
./configure --enable-single-host CC="gcc-8"
make -j
make check
