# makefile for Gambit REPL app.

# Copyright (c) 1994-2018 by Marc Feeley, All Rights Reserved.

herefromroot = contrib/GambitREPL
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

.SUFFIXES: .scm .m .o

MODULES_M = digest.m genport.m zlib.m tar.m json.m url.m html.m \
wiki.m repl-server.m intf.m script.m repo.m help.m emacs.m \
program.m program_.m

RCFILES = makefile.in README GambitREPL.xcodeproj.tgz emacs.tgz \
GambitREPL-icon-unscaled.key NotEmacs-icon-unscaled.key \
digest.scm "digest\#.scm" genport.scm "genport\#.scm" \
zlib.scm "zlib\#.scm" tar.scm "tar\#.scm" \
json.scm "json\#.scm" url.scm "url\#.scm" html.scm "html\#.scm" \
wiki.scm "wiki\#.scm" repl-server.scm "repl-server\#.scm" \
intf.scm "intf\#.scm" intf.h script.scm "script\#.scm" \
repo.scm "repo\#.scm" help.scm "help\#.scm" emacs.scm "emacs\#.scm" program.scm \
main.m grd.scm Prefix.pch \
AppDelegate.m AppDelegate.h ViewController.m ViewController.h \
KOCreateButton.h KOCreateButton.m KOKeyboardRow.h KOKeyboardRow.m \
KOProtocol.h KOSwipeButton.h KOSwipeButton.m \
TView.h TView.m WView.h WView.m IView.h IView.m ITView.h ITView.m \
GambitREPL.entitlements GambitREPL.plist GambitREPL.storyboard \
GambitREPL-29.png GambitREPL-40.png GambitREPL-57.png GambitREPL-72.png \
GambitREPL-76.png GambitREPL-87.png GambitREPL-120.png GambitREPL-152.png \
GambitREPL-180.png GambitREPL-512.png GambitREPL-1024.png \
NotEmacs.entitlements NotEmacs.plist NotEmacs.storyboard \
NotEmacs-29.png NotEmacs-40.png NotEmacs-57.png NotEmacs-72.png \
NotEmacs-76.png NotEmacs-87.png NotEmacs-120.png NotEmacs-152.png \
NotEmacs-180.png NotEmacs-512.png NotEmacs-1024.png \
Default-568h@2x.png \
edit.png f1.png f10.png f11.png f12.png f2.png f3.png \
f4.png f5.png f6.png f7.png f8.png f9.png note.png rocket.png \
stop.png user.png \
button-abc.png button-cancel.png button-compass.png button-empty.png \
button-left-left.png button-left.png button-question.png button-right-right.png \
button-right.png button-up.png button-up-arrow.png \
make-appstore-screenshots make-keys make-scaled-icons \
help.html r5rs.html r5rs.pdf gambit.html

GENDISTFILES =

DISTFILES = $(RCFILES) $(GENDISTFILES)

PRELUDE_OPT = -prelude "(define-cond-expand-feature|enable-type-checking|)(define-cond-expand-feature|disable-auto-forcing|)(define-cond-expand-feature|enable-sharp-dot|)(define-cond-expand-feature|enable-bignum|)(define-cond-expand-feature|enable-ratnum|)(define-cond-expand-feature|enable-cpxnum|)(define-cond-expand-feature|disable-smp|)(\#\#include\"$(srcdirpfx)../../lib/header.scm\")"

all:

all-pre:

all-post:

ios: grd prepare-for-xcode

gambit-iOS:
	@echo "*************************************************************"
	@echo "*                                                           *"
	@echo "* Building Gambit for iOS                                   *"
	@echo "*                                                           *"
	@echo "*   This builds the Gambit runtime library for              *"
	@echo "*   the iPhone/iPad/iPod Touch devices and simulators       *"
	@echo "*                                                           *"
	@echo "*************************************************************"
	$(rootfromhere)/misc/build-gambit-iOS

prepare-for-xcode: $(MODULES_M) GambitREPL.xcodeproj gambit-iOS
	rm -rf lib
	mkdir lib
	cp gambit-iOS/current/lib/*.scm lib
	cp gambit-iOS/current/doc/gambit.pdf .
	if test ! -e "emacs"; then \
	  tar zxf emacs.tgz; \
	fi
	@echo "*************************************************************"
	@echo "*                                                           *"
	@echo "* To complete the iOS example the following steps must be   *"
	@echo "* completed manually:                                       *"
	@echo "*                                                           *"
	@echo "*  1) open GambitREPL.xcodeproj in XCode 4.0 (or later)     *"
	@echo "*                                                           *"
	@echo "*  2) select the appropriate target (simulator or device)   *"
	@echo "*                                                           *"
	@echo "*  3) select menu Product -> Run                            *"
	@echo "*                                                           *"
	@echo "*************************************************************"

.scm.m:
	 $(rootfromhere)/gsc/gsc -:~~bin=$(srcdirpfx)$(rootfromhere)/bin,~~lib=$(srcdirpfx)$(rootfromhere)/lib,~~include=$(srcdirpfx)$(rootfromhere)/include -f -warnings -c $(PRELUDE_OPT) -o $*.m $(srcdirpfx)$*.scm

program_.m: digest.m genport.m zlib.m tar.m json.m url.m html.m wiki.m repl-server.m intf.m script.m repo.m help.m emacs.m program.m
	 $(rootfromhere)/gsc/gsc -:~~bin=$(srcdirpfx)$(rootfromhere)/bin,~~lib=$(srcdirpfx)$(rootfromhere)/lib,~~include=$(srcdirpfx)$(rootfromhere)/include -f -warnings -link $(PRELUDE_OPT) -o $@ $^

GambitREPL.xcodeproj: GambitREPL.xcodeproj.tgz
	rm -rf GambitREPL.xcodeproj
	tar zxf GambitREPL.xcodeproj.tgz

tgz-for-GambitREPL.xcodeproj: GambitREPL.xcodeproj/project.pbxproj
	COPYFILE_DISABLE=1 tar cf GambitREPL.xcodeproj.tar GambitREPL.xcodeproj
	gzip -9 GambitREPL.xcodeproj.tar
	mv GambitREPL.xcodeproj.tar.gz GambitREPL.xcodeproj.tgz

tgz-for-emacs: emacs/GambitREPL.html emacs/GambitREPL.js emacs/GambitREPL.css emacs/common.js emacs/v1
	COPYFILE_DISABLE=1 tar cf emacs.tar emacs/GambitREPL.css emacs/GambitREPL.html emacs/GambitREPL.js emacs/common.js emacs/v1 emacs/icon.png emacs/ymacs/*
	gzip -9 emacs.tar
	mv emacs.tar.gz emacs.tgz

tgz-files: tgz-for-GambitREPL.xcodeproj tgz-for-emacs

grd: grd.scm
	 $(rootfromhere)/gsc/gsc -:~~bin=$(srcdirpfx)$(rootfromhere)/bin,~~lib=$(srcdirpfx)$(rootfromhere)/lib,~~include=$(srcdirpfx)$(rootfromhere)/include -f -warnings $(PRELUDE_OPT) -o grd -exe grd.scm

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
	rm -f $(MODULES_M) grd

clean-pre: mostlyclean-pre

clean-post clean-post-nonrec: mostlyclean-post-nonrec
	rm -f *.gcov *.gcno *.gcda

distclean-pre: clean-pre

distclean-post distclean-post-nonrec: clean-post-nonrec

bootclean-pre: distclean-pre

bootclean-post bootclean-post-nonrec: distclean-post-nonrec

realclean-pre: bootclean-pre

realclean-post realclean-post-nonrec: bootclean-post-nonrec
	rm -f makefile

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
