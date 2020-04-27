# makefile for Gambit build on Windows.

# Copyright (c) 1994-2018 by Marc Feeley, All Rights Reserved.

herefromroot = prebuilt/windows
rootfromhere = ../..
SUBDIRS =

PACKAGE_SHORTNAME = gambit
PACKAGE_NAME = Gambit
PACKAGE_VERSION = v4.9.3
PACKAGE_STRING = Gambit v4.9.3
PACKAGE_BUGREPORT = gambit@iro.umontreal.ca
PACKAGE_TARNAME = gambit-v4_9_3



srcdir = .

srcdirpfx = 

C_COMPILER = gcc
C_PREPROC = gcc -E
FLAGS_OBJ =    -Wno-unused -Wno-write-strings -Wdisabled-optimization -fwrapv -fno-strict-aliasing -fno-trapping-math -fno-math-errno -fschedule-insns2 -fomit-frame-pointer -fPIC -fno-common -mpc64 
FLAGS_DYN =     -Wno-unused -Wno-write-strings -Wdisabled-optimization -fwrapv -fno-strict-aliasing -fno-trapping-math -fno-math-errno -fschedule-insns2 -fomit-frame-pointer -fPIC -fno-common -mpc64   -rdynamic -shared
FLAGS_LIB =      -rdynamic -shared
FLAGS_EXE =     -Wno-unused -Wno-write-strings -Wdisabled-optimization -fwrapv -fno-strict-aliasing -fno-trapping-math -fno-math-errno -fschedule-insns2 -fomit-frame-pointer -fPIC -fno-common -mpc64   -rdynamic
FLAGS_OPT =  -O1
FLAGS_OPT_RTS =  -O3
DEFS = -DHAVE_CONFIG_H
LIBS = -lutil -ldl -lm 

GAMBITLIB_DEFS =  -D___GAMBITDIR="\"/usr/local/Gambit\"" -D___GAMBITDIR_USERLIB="\"~/.gambit_userlib\"" -D___GAMBITDIR_INSTLIB="\"~~userlib\"" -D___SYS_TYPE_CPU="\"x86_64\"" -D___SYS_TYPE_VENDOR="\"pc\"" -D___SYS_TYPE_OS="\"linux-gnu\"" -D___CONFIGURE_COMMAND="\"./configure"\" -D___OBJ_EXTENSION="\".o\"" -D___EXE_EXTENSION="\"\"" -D___BAT_EXTENSION="\"\""
LIB_PREFIX = lib
LIB_VERSION_SUFFIX = 
LIB_MAJOR_VERSION_SUFFIX = 

LIB_EXTENSION = .a
GAMBITLIB = gambit
GAMBITGSCLIB = gambitgsc
GAMBITGSILIB = gambitgsi
INSTALL = $(rootfromhere)/install-sh -c
INSTALL_DATA = $(rootfromhere)/install-sh -c -m 644
INSTALL_LIB = $(rootfromhere)/install-sh -c -m 644
INSTALL_PROGRAM = $(rootfromhere)/install-sh -c -m 755
LN_S = ln -s
RANLIB = ranlib
AR = ar
RC = git
GIT = git
HG = hg

prefix = /usr/local/Gambit
exec_prefix = ${prefix}
includedir = ${prefix}/include
libdir = ${prefix}/lib
bindir = ${prefix}/bin
docdir = ${prefix}/doc
infodir = ${prefix}/info
emacsdir = ${datadir}/emacs/site-lisp
libexecdir = ${exec_prefix}/libexec
datarootdir = ${prefix}/share
datadir = ${prefix}/share
htmldir = ${docdir}
dvidir = ${docdir}
pdfdir = ${docdir}
psdir = ${docdir}
localedir = ${datarootdir}/locale
mandir = ${datarootdir}/man

.SUFFIXES:

RCFILES = makefile.in build build-phase2.in remote-shell blank-floppy.fdd \
binpatch.c binpatch.exe gambit.ai gambit.ico gambit.nsi.in \
AddToPath.nsh

GENDISTFILES =

DISTFILES = $(RCFILES) $(GENDISTFILES)

all:

all-pre:

all-post:

prebuilt:
	PATH="$(rootfromhere)/gsi:$$PATH" ../remote-connect windows "" "(define tmpdir \"gambtmp1\")(define gambit-dist \"$(PACKAGE_TARNAME)\")(define timeout 2000)(ssh timeout (string-append \"rm -rf \" tmpdir \";mkdir \" tmpdir \";\"))(scp-to timeout (string-append \"$(rootfromhere)/\" gambit-dist \".tgz\") (string-append tmpdir \"/.\"))(ssh timeout (string-append \"sh --login -c \\\"cd \" tmpdir \";tar zxf \" gambit-dist \".tgz;cd \" gambit-dist \";$(herefromroot)/build\\\"\"))(scp-from timeout (string-append tmpdir \"/\" gambit-dist \"/$(PACKAGE_TARNAME)-*\") \"$(rootfromhere)\")"

bootstrap-pre:

bootstrap-post:

install-pre:

install-post: all

uninstall-pre:

uninstall-post:

select-gen-for-commit-pre:

select-gen-for-commit-post select-gen-for-commit-post-nonrec:

deselect-gen-for-commit-pre:

deselect-gen-for-commit-post deselect-gen-for-commit-post-nonrec:

mostlyclean-pre:

mostlyclean-post mostlyclean-post-nonrec:

clean-pre: mostlyclean-pre

clean-post clean-post-nonrec: mostlyclean-post-nonrec

distclean-pre: clean-pre

distclean-post distclean-post-nonrec: clean-post-nonrec

bootclean-pre: distclean-pre

bootclean-post bootclean-post-nonrec: distclean-post-nonrec

realclean-pre: bootclean-pre

realclean-post realclean-post-nonrec: bootclean-post-nonrec
	rm -f build-phase2 build-phase2.out makefile

rc-setup-pre:
	$(RC) add $(RCFILES)

rc-setup-post:

dist-pre dist-devel-pre:
	mkdir $(rootfromhere)/$(PACKAGE_TARNAME)/$(herefromroot)
	chmod 777 $(rootfromhere)/$(PACKAGE_TARNAME)/$(herefromroot)
	@echo "  Copying distribution files:"
	@for file in $(DISTFILES); do \
	  echo "    $(herefromroot)/$$file"; \
	  ln $(srcdirpfx)$$file $(rootfromhere)/$(PACKAGE_TARNAME)/$(herefromroot) 2> /dev/null \
	    || cp -p $(srcdirpfx)$$file $(rootfromhere)/$(PACKAGE_TARNAME)/$(herefromroot); \
	done

dist-post dist-devel-post:

all-recursive bootstrap-recursive install-recursive uninstall-recursive select-gen-for-commit-recursive deselect-gen-for-commit-recursive mostlyclean-recursive clean-recursive distclean-recursive bootclean-recursive realclean-recursive rc-setup-recursive dist-recursive dist-devel-recursive:
	@if test -n "$(SUBDIRS)"; then \
	  for subdir in ""$(SUBDIRS); do \
	    target=`echo $@ | sed 's/-recursive//'`; \
	    echo making $$target in $$subdir; \
	    (cd $$subdir && $(MAKE) $$target) || exit 1; \
	  done \
	fi

all: all-post

all-post: all-recursive

all-recursive: all-pre

bootstrap: bootstrap-post

bootstrap-post: bootstrap-recursive

bootstrap-recursive: bootstrap-pre

install: install-post

install-post: install-recursive

install-recursive: install-pre

uninstall: uninstall-post

uninstall-post: uninstall-recursive

uninstall-recursive: uninstall-pre

select-gen-for-commit: select-gen-for-commit-post

select-gen-for-commit-post: select-gen-for-commit-recursive

select-gen-for-commit-post-nonrec select-gen-for-commit-recursive: select-gen-for-commit-pre

deselect-gen-for-commit: deselect-gen-for-commit-post

deselect-gen-for-commit-post: deselect-gen-for-commit-recursive

deselect-gen-for-commit-post-nonrec deselect-gen-for-commit-recursive: deselect-gen-for-commit-pre

mostlyclean: mostlyclean-post

mostlyclean-post: mostlyclean-recursive

mostlyclean-post-nonrec mostlyclean-recursive: mostlyclean-pre

clean: clean-post

clean-post: clean-recursive

clean-post-nonrec clean-recursive: clean-pre

distclean: distclean-post

distclean-post: distclean-recursive

distclean-post-nonrec distclean-recursive: distclean-pre

bootclean: bootclean-post

bootclean-post: bootclean-recursive

bootclean-post-nonrec bootclean-recursive: bootclean-pre

realclean: realclean-post

realclean-post: realclean-recursive

realclean-post-nonrec realclean-recursive: realclean-pre

rc-setup: rc-setup-post

rc-setup-post: rc-setup-recursive

rc-setup-recursive: rc-setup-pre

dist: dist-post

dist-post: dist-recursive

dist-recursive: dist-pre

dist-devel: dist-devel-post

dist-devel-post: dist-devel-recursive

dist-devel-recursive: dist-devel-pre

makefile: makefile.in $(rootfromhere)/config.status
	cd $(rootfromhere) && CONFIG_FILES=$(herefromroot)/$@ CONFIG_HEADERS= ./config.status

# Tell versions [3.59,3.63) of GNU make not to export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
