|Linux and OS X|Windows|
|:--:|:--:|
|[![Build Status: Linux and OS X](https://travis-ci.org/gambit/gambit.svg?branch=master)](https://travis-ci.org/gambit/gambit)|[![Build Status: Windows](https://ci.appveyor.com/api/projects/status/github/gambit/gambit?branch=master&svg=true)](https://ci.appveyor.com/project/feeley/gambit/branch/master)|

[![Join the chat at https://gitter.im/gambit/gambit](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gambit/gambit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![tip for next commit](http://prime4commit.com/projects/121.svg)](http://prime4commit.com/projects/121)

The Gambit Scheme system is a complete, portable, efficient and
reliable implementation of the Scheme programming language.

The latest official release of the system and other helpful documents
related to Gambit can be obtained from the Gambit wiki at:

  http://gambitscheme.org


Quick-install instructions for a typical installation
=====================================================

    git clone https://github.com/gambit/gambit.git
    cd gambit
    ./configure
    make -j8 current-gsc-boot
    make -j8 from-scratch
    make check
    make doc
    sudo make install

Detailed installation instructions are given in the file "INSTALL.txt".
