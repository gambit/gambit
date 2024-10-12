<!-- Copyright (c) 2024 by Macon Gambill, All Rights Reserved. -->
# (doc (doc))
## Making
Once you've installed Texinfo, you should be able to run `make` from this directory.  Certain output formats (e.g., `epub`, `pdf`) require additional dependencies, as documented by Texinfo.  The default output formats are Info, single-page HTML, and plain text.

Running `make clean` should remove all generated files.  Running `make clean-intermediate` removes intermediate files only.

## Some goals
### Retain full compatibility with “stock” Texinfo.
By closely adhering to the documented language and conventions, we will
avoid bit rot in the long term.  Texinfo's maintainers work hard to avoid introducing backward-incompatible changes.  The less our `.txi` source files diverge from their reasonable expectations, the less likely we'll thwart their efforts.

This should also make it easier for new contributors to get started independently.  Texinfo is a mature, popular, and well-documented tool.  Anyone capable of writing well is also capable of reading enough of the Texinfo manual to document a new Gambit procedure; you may even find it's possible to code _Stack Overflow-style_, copying an existing definition and replacing the portions that seem to need changing.  The sources contain some ugly parts, but most people will never need to read or modify them.  And someone who _does_ want to delve into those parts can use the existing body of Texinfo documentation for guidance.

The standard storage format also makes it much more likely our work could be adapted for another Scheme implementation.  Gambit's license should facilitate such sharing.

### Begin HTML customization from a (relatively) “pristine” point.
The “pristine source” concept is borrowed from Edward C. Bailey's [Maximum RPM](https://ftp.osuosl.org/pub/rpm/max-rpm/ch-rpm-philosophy.html).  In a common software packaging scenario, the _packager_ is part of an organization unaffiliated with the _upstream_; the _upstream_ builds a _release tarball_, which is essentially a canonical, named version of the software.  That release tarball is the _pristine source_, and it should be available alongside the customized version of that software the packager distributes to end users.

The pristine source serves as a point of reference, making it possible to understand how the customized version might differ from the upstream's expectations.  And when the upstream's newest release breaks a customization that depends on undocumented behavior, the pristine source provides an obvious starting point for troubleshooting.

In our scenario, the closest thing to a pristine source is more like a “pristine artifact”.  It's the output of running `texi2any` directly on `gambit.txi`, produced by `make gambit-pristine.html`.  Significant customizations are applied as discrete steps and have standalone `make` targets:
  - `gambit-parens.html`: parenthesized procedure signatures
  - `gambit-css.html`: custom CSS
  - `gambit-css-parens`: CSS + parenthesization
  - `gambit-css-color.html`: CSS + extra colors
  - `gambit-css-color-parens.html`: CSS + extra colors + parenthesization
  - `gambit.html`: another name for `gambit-css-color-parens.html`

The introspectible build process should make it easier to eventually replace the shell scripts that generate sed scripts that generate Texinfo files.

### Avoid manual touch-ups.
To meaningfully be described as a “reproducible build”, the published documentation can't be the product of esoteric fiddling that occurs before or after `make` is executed.
