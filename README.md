|**Windows, Linux, and macOS**|
|:--:|
|[![CI Build Status](https://github.com/gambit/gambit/workflows/Gambit%20-%20CI/badge.svg?branch=master)](https://github.com/gambit/gambit/actions?query=workflow%3A%22Gambit+-+CI%22)|

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
    ./configure        # --enable-single-host optional but recommended
    make               # build runtime library, gsi and gsc (add -j8 if you can)
    make modules       # compile the builtin modules (optional but recommended)
    make check         # run self tests (optional but recommended)
    make doc           # build the documentation
    sudo make install  # install

Detailed installation instructions are given in the file "INSTALL.txt".
