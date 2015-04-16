[![Build Status](https://travis-ci.org/feeley/gambit.svg?branch=master)](https://travis-ci.org/feeley/gambit)
[![tip for next commit](http://prime4commit.com/projects/121.svg)](http://prime4commit.com/projects/121)

The Gambit Scheme system is a complete, portable, efficient and
reliable implementation of the Scheme programming language.

The latest official release of the system and other helpful documents
related to Gambit can be obtained from the Gambit wiki at:

  http://gambitscheme.org


Quick-install instructions for a typical installation
=====================================================

[![Join the chat at https://gitter.im/feeley/gambit](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/feeley/gambit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

    git clone https://github.com/feeley/gambit.git
    cd gambit
    ./configure --enable-single-host
    make -j4 from-scratch
    make check
    sudo make install

Detailed installation instructions are given in the file "INSTALL.txt".
