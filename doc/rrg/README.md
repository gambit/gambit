<!-- Copyright (c) 2024 by Macon Gambill, All Rights Reserved. -->
# (doc (doc))
## Build dependencies
- Gambit
- [GNU Texinfo](https://www.gnu.org/software/texinfo)
- a Bourne-compatible shell
- core unix utilities: `mkdir`, `mktemp`, `mv`, etc.
- `make`
- `sed`
- `pax` or `tar` (needed to build `gambit-samples.tgz`)

## Making
Once you've installed Texinfo, you should be able to run `make` from this directory.  Certain output formats (e.g., PDF) require additional dependencies, as documented by Texinfo.  The default output formats are Info, single-page HTML, and plain text.

### Useful `make` targets
- `clean`
  - remove all generated files except the `compile-*` targets' outputs
- `extraclean`
  - remove all generated files
- `compile-adorn`
  - compile “adorn” library to a dynamically-loadable file
- `compile-exe`
  - compile “adorn” library as in `compile`, plus a `scm-to-html` executable
- `gambit.html`, `gambit.info`, `gambit.txt`
  - monolithic formats
- `html-modules`
  - modular HTML
- `gambit-pristine.html`
  - monolithic HTML output using Texinfo's defaults; no custom CSS
- `gambit-css.html`
  - like `gambit-pristine.html`, but using custom CSS
- `gambit.cm.html`, `html-modules-cm`
  - HTML using CodeMirror-like color theme
- `gambit-samples.tgz`
  - compressed archive containing several output formats and HTML-ified Scheme source files
- `highlight`
  - HTML-ify the Scheme source file located at ${SCM}
    - example: `make highlight SCM=../../lib/syntax-case.scm`
    - output file is created in the current working directory
    - On my computer, compilation helps `highlight` run ~10x faster.
- `highlight-cm`
  - HTML-ify Scheme source using CodeMirror-like color theme
  - example: `make highlight-cm SCM=../../lib/syntax-case.scm`

## Goals and Status
### Retain full compatibility with “stock” Texinfo.
By closely adhering to Texinfo's documented syntax and conventions, we aim to avoid [software rot](http://www.catb.org/jargon/html/S/software-rot.html).  Texinfo's maintainers work hard to avoid introducing backward-incompatible changes.  The less our version-controlled Texinfo source files diverge from the maintainers' reasonable expectations, the less likely we'll thwart their efforts.

This should also make it easier for new contributors to get started independently; the existing body of Texinfo documentation will remain applicable to our project.

#### Status
As a rule, all version-controlled Texinfo source files are written in the “stock” Texinfo language (meaning they may be directly processed by `texi2any`).

An exception to the “stock” Texinfo rule is that, with some exceptions, version-controlled `.txi` files should not include @-commands within `@lisp`/`@end lisp` blocks.  Exceptions include:
 - `@U{...}`, for Unicode insertion
 - `@ok{..}`, for specifying a “normal” returned value
 - `@exception{...}`, for describing an exception
 - `@problem{...}`, for describing something that might be a bug

Also keep in mind that `@,`, `{`, and `}` are treated specially by Texinfo.  These characters are problematic within `@lisp` blocks.  In such contexts, use one of Texinfo's built-in @-commands: `@@`, `@atchar{}`, `@{`, `@lbracechar{}`, `@}`, or `@rbracechar{}`.

### Begin HTML customization from a (relatively) “pristine” point.
The “pristine source” concept is borrowed from Edward C. Bailey's [Maximum RPM](https://ftp.osuosl.org/pub/rpm/max-rpm/ch-rpm-philosophy.html).  In a common software packaging scenario, the _packager_ is part of an organization unaffiliated with the _upstream_; the _upstream_ builds a _release tarball_, which is essentially a canonical, named version of the software.  That release tarball is the _pristine source_, and it should be available alongside the customized version of that software the packager distributes to end users.

The pristine source serves as a point of reference, making it possible to understand how the customized version might differ from the upstream's expectations.  And when the upstream's newest release breaks a customization that depends on undocumented behavior, the pristine source provides an obvious starting point for troubleshooting.

#### Status
In our scenario, the closest thing to a pristine source is more like a “pristine artifact”.  It's the output of running `texi2any` directly on `gambit-pristine.txi`.  Customizations are implemented by some combination of:
  - processing version-controlled Texinfo source files into new Texinfo source files, then running `texi2any` on the new source files
  - processing the ultimate output of the Texinfo build (e.g., running `sed` on the output of `texi2any --html`)

### Avoid manual touch-ups.
To meaningfully be described as a “reproducible build”, the published documentation can't be the product of esoteric fiddling that occurs before or after `make` is executed.

#### Status
So far, so good.
