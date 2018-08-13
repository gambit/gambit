#!/bin/sh

cd ..

pwd

./configure --enable-single-host
make
make check

cd bench

rm -rf results.Gambit*

time ./bench -r 10 gambit all
