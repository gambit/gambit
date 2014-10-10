[![Build Status](https://travis-ci.org/feeley/gambit.svg?branch=master)](https://travis-ci.org/feeley/gambit)
[![tip for next commit](https://tip4commit.com/projects/1015.svg)](https://tip4commit.com/github/feeley/gambit)
[![tip for next commit](http://prime4commit.com/projects/121.svg)](http://prime4commit.com/projects/121)

The Gambit Scheme system is a complete, portable, efficient and
reliable implementation of the Scheme programming language.

The latest official release of the system and other helpful documents
related to Gambit can be obtained from the Gambit wiki at:

  http://gambitscheme.org


Quick-install instructions for a typical installation
=====================================================

    git clone https://github.com/feeley/gambit.git
    cd gambit
    ./configure --enable-single-host
    make -j4 from-scratch
    make check
    sudo make install

Detailed installation instructions are given in the file "INSTALL.txt".
