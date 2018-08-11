#!/bin/sh

cd ..

pwd

./configure --enable-single-host
make
make check
