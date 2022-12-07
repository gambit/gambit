|**Windows, Linux, and macOS**|
|:--:|
|[![CI Build Status](https://github.com/gambit/gambit/workflows/Gambit/badge.svg?branch=master)](https://github.com/gambit/gambit/actions?query=workflow%3A%22Gambit%22)|

[![Join the chat at https://gitter.im/gambit/gambit](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gambit/gambit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The Gambit Scheme system is a complete, portable, efficient and
reliable implementation of the Scheme programming language.

The latest official release of the system and other helpful documents
can be obtained from the Gambit web page at:

  https://gambitscheme.org

<hr>

### Quick-install instructions for a typical installation

    git clone https://github.com/gambit/gambit.git
    cd gambit
    ./configure
    make               # build runtime library, gsi and gsc (add -j8 if you can)
    make check         # run self tests (optional but recommended)
    make doc           # build the documentation
    sudo make install  # install

    # Note: this configuration is recommended for best performance:
    ./configure --enable-single-host --enable-march=native --enable-dynamic-clib

If some error or ctrl-C interrupts the first invocation of `make` it
is best to start again from the `git clone` step to avoid possible
corruption of the files generated during the bootstrap process.

Detailed installation instructions are given in the file [INSTALL.txt](https://github.com/gambit/gambit/blob/master/INSTALL.txt).

<hr>

### Contributing

We welcome contributions in the form of issues, bug reports, and pull-requests for enhancements, bug fixes, and entire modules
of code (SRFIs, new modules or ports from other environments, etc).  Thanks to Gambit's module system, individuals can
also contribute modules and R7RS libraries on their own by simply creating a public git repository (on github.com, gitlab.com,
etc) that hosts the module's source code (see https://github.com/gambit/hello and
https://github.com/feeley/bonjour for simple public modules, which can be run with
`gsi github.com/gambit/hello/demo` and `gsi -:whitelist=github.com/feeley github.com/feeley/bonjour` respectively).

For some issues a reward is offered for fixing the issue (enter the word "bounty" in the "Issues" tab search bar).
Individuals may offer a bounty for fixing an issue by adding the word "bounty" in the description of the issue and
giving details on the amount and payment method.

Please click the following button if you want to donate funds that will allow the Gambit maintainers to offer bug bounties
and rewards to people who contribute to Gambit's development.  As an example, a typical bug bounty is on the order of
$100 CAD (about $80 USD and 75 euros at time of writing).

[<img src="https://pics.paypal.com/00/s/OWJhNjZlNTEtMTJmZS00YTUyLThjYzQtMzk5YTczYzA4NWMy/file.PNG" width="150px">](https://www.paypal.com/donate/?business=TNP6XBKEPF8NA&no_recurring=0&item_name=Gambit+Scheme+development+%28contribution+and+bug+bounties%2C+etc%29.+For+example+a+%24500+CAD+donation+typically+funds+5+bug+bounties.&currency_code=CAD)

<hr>

### SRFIs provided

0: [Feature-based conditional expansion construct](https://srfi.schemers.org/srfi-0/srfi-0.html) (builtin)

1: [List Library](https://srfi.schemers.org/srfi-1/srfi-1.html)

2: [AND-LET*: an AND with local bindings, a guarded LET* special form](https://srfi.schemers.org/srfi-2/srfi-2.html)

4: [Homogeneous numeric vector datatypes](https://srfi.schemers.org/srfi-4/srfi-4.html) (builtin)

5: [A compatible let form with signatures and rest arguments](https://srfi.schemers.org/srfi-5/srfi-5.html)

6: [Basic String Ports](https://srfi.schemers.org/srfi-6/srfi-6.html) (builtin)

8: [receive: Binding to multiple values](https://srfi.schemers.org/srfi-8/srfi-8.html) (builtin)

9: [Defining Record Types](https://srfi.schemers.org/srfi-9/srfi-9.html) (builtin)

13: [String Libraries](https://srfi.schemers.org/srfi-13/srfi-13.html)

14: [Character-set Library](https://srfi.schemers.org/srfi-14/srfi-14.html)

16: [Syntax for procedures of variable arity](https://srfi.schemers.org/srfi-16/srfi-16.html) (builtin)

18: [Multithreading support](https://srfi.schemers.org/srfi-18/srfi-18.html) (builtin)

21: [Real-time multithreading support](https://srfi.schemers.org/srfi-21/srfi-21.html) (builtin)

22: [Running Scheme Scripts on Unix](https://srfi.schemers.org/srfi-22/srfi-22.html) (builtin)

23: [Error reporting mechanism](https://srfi.schemers.org/srfi-23/srfi-23.html) (builtin)

26: [Notation for Specializing Parameters without Currying](https://srfi.schemers.org/srfi-26/srfi-26.html)

27: [Sources of Random Bits](https://srfi.schemers.org/srfi-27/srfi-27.html) (builtin)

28: [Basic Format Strings](https://srfi.schemers.org/srfi-28/srfi-28.html)

30: [Nested Multi-line Comments](https://srfi.schemers.org/srfi-30/srfi-30.html) (builtin)

31: [A special form rec for recursive evaluation](https://srfi.schemers.org/srfi-31/srfi-31.html)

33: [Integer Bitwise-operation Library](https://srfi.schemers.org/srfi-33/srfi-33.html)

39: [Parameter objects](https://srfi.schemers.org/srfi-39/srfi-39.html) (builtin)

41: [Streams](https://srfi.schemers.org/srfi-41/srfi-41.html)

42: [Eager Comprehensions](https://srfi.schemers.org/srfi-42/srfi-42.html)

45: [Primitives for Expressing Iterative Lazy Algorithms](https://srfi.schemers.org/srfi-45/srfi-45.html)

48: [Intermediate Format Strings](https://srfi.schemers.org/srfi-48/srfi-48.html)

62: [S-expression comments](https://srfi.schemers.org/srfi-62/srfi-62.html) (builtin)

64: [A Scheme API for test suites](https://srfi.schemers.org/srfi-64/srfi-64.html) (incomplete implementation)

69: [Basic hash tables](https://srfi.schemers.org/srfi-69/srfi-69.html)

88: [Keyword objects](https://srfi.schemers.org/srfi-88/srfi-88.html) (builtin)

111: [Boxes](https://srfi.schemers.org/srfi-111/srfi-111.html) (builtin)

124: [Ephemerons](https://srfi.schemers.org/srfi-124/srfi-124.html)

132: [Sort Libraries](https://srfi.schemers.org/srfi-132/srfi-132.html)

141: [Integer Division](https://srfi.schemers.org/srfi-141/srfi-141.html) (builtin)

151: [Bitwise Operations](https://srfi.schemers.org/srfi-151/srfi-151.html)

158: [Generators and Accumulators](https://srfi.schemers.org/srfi-158/srfi-158.html)

179: [Nonempty Intervals and Generalized Arrays (Updated)](https://srfi.schemers.org/srfi-179/srfi-179.html)

193: [Command line](https://srfi.schemers.org/srfi-193/srfi-193.html) (builtin)

219: [Define higher-order lambda](https://srfi.schemers.org/srfi-219/srfi-219.html)

231: [Intervals and Generalized Arrays](https://srfi.schemers.org/srfi-231/srfi-231.html)
