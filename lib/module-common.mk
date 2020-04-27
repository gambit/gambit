# common makefile for gambit modules, to be included by specific makefile

# Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

# The specific makefile must contain:
#
# herefromlib = <path>/<to>/<this>/<dir>
# libfromhere = ../../../..        # as many .. as components in herefromlib
# SUBDIRS = <subdir1> <subdir2>    # as many as there are subdirs
# HEADERS_SCM = foo\#.scm
# MODULES_SCM = foo.scm foo.sld test.scm
# MAIN_MODULES = foo
# OTHER_RCFILES = makefile
# include $(libfromhere)/module-common.mk

herefromroot = lib/$(herefromlib)
rootfromhere = $(libfromhere)/..

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

BUILD_TARGETS = C

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

RCFILES = $(HEADERS_SCM) $(MODULES_SCM) $(OTHER_RCFILES)

GENDISTFILES =

DISTFILES = $(RCFILES) $(GENDISTFILES)

INSTFILES_LIB_DATA = $(HEADERS_SCM) $(MODULES_SCM)

MDEFINES = prefix=$(prefix) exec_prefix=$(exec_prefix) \
includedir=$(includedir) libdir=$(libdir) \
bindir=$(bindir) docdir=$(docdir) \
infodir=$(infodir) emacsdir=$(emacsdir)

all:

all-pre:

all-post:

bootstrap-pre:

bootstrap-post:

modules-pre:
	@here_prefix="`echo $(herefromlib) | sed -e 's,[^/]*$$,,'`"; \
	here_suffix="`echo $(herefromlib) | sed -e 's,.*/,,'`"; \
	for target in $(BUILD_TARGETS); do \
	  for main_mod in $(MAIN_MODULES); do \
	    if test "$$main_mod" = "$$here_suffix"; then \
	      modref="$(herefromlib)"; \
	    else \
	      modref="$(herefromlib)/$$main_mod"; \
	    fi; \
	    need_to_build_module=no; \
	    build_dir="$$main_mod@gambit409003@$$target"; \
	    if test ! -d "$$build_dir" \
	         -o "$(rootfromhere)/gsc/gsc" -nt "$$build_dir" \
	         -o -f "$$main_mod.sld" -a "$$main_mod.sld" -nt "$$build_dir" \
	         -o -f "$$main_mod.scm" -a "$$main_mod.scm" -nt "$$build_dir" \
	         -o -f "$$main_mod#.scm" -a "$$main_mod#.scm" -nt "$$build_dir"; then \
	      need_to_build_module=yes; \
	    fi; \
	    if test "$$need_to_build_module" = "yes"; then \
	      echo ">>>> building module $$modref for $$target"; \
	       $(rootfromhere)/gsc/gsc -:~~bin=$(srcdirpfx)$(rootfromhere)/bin,~~lib=$(srcdirpfx)$(rootfromhere)/lib,~~include=$(srcdirpfx)$(rootfromhere)/include -f -e "(let ((x (##build-module \"$$main_mod\" (quote $$target) (quote ((module-ref $$modref)))))) (if (not x) (begin (println \"*** module failed to build\") (exit 1))))"; \
	    else \
	      echo ">>>> no need to build module $$modref for $$target"; \
	    fi; \
	  done; \
	done

modules-post:

install-pre:

install-post: all
	c_libdir="$(DESTDIR)$(prefix)/$(herefromroot)"; \
	i_libdir="$(DESTDIR)$(libdir)`echo $(herefromroot)/ | sed -e s:^lib:: -e s:/\\$$::`"; \
	t_libdir="$$i_libdir"; \
	$(srcdirpfx)$(rootfromhere)/mkidirs "$$i_libdir"; \
	if test "no" = "yes"; then \
	  $(srcdirpfx)$(rootfromhere)/mkidirs "$$c_libdir"; \
	  t_libdir="$$c_libdir"; \
	fi; \
	for file in $(INSTFILES_LIB_DATA); do \
	  $(INSTALL_DATA) "$$file" "$$t_libdir/$$file"; \
	done; \
	for build_dir in *@gambit*; do \
	  if test -d "$$build_dir"; then \
	    $(srcdirpfx)$(rootfromhere)/mkidirs "$$t_libdir/$$build_dir"; \
	    for file in $$build_dir/*; do \
	      $(INSTALL_PROGRAM) "$$file" "$$t_libdir/$$file"; \
	    done; \
	  fi; \
	done; \
	if test "$$t_libdir" != "$$i_libdir"; then \
	  r_libdir=`$(rootfromhere)/relpath "$$t_libdir" "$$i_libdir" no`; \
	  for file in $(INSTFILES_LIB_DATA); do \
	    (cd "$$i_libdir" && $(LN_S) "$$r_libdir$$file" "$$file"); \
	  done; \
	  for build_dir in *@gambit*; do \
	    if test -d "$$build_dir"; then \
	      (cd "$$i_libdir" && $(LN_S) "$$r_libdir$$build_dir" "$$build_dir"); \
	    fi; \
	  done; \
	fi

uninstall-pre:

uninstall-post:
	c_libdir="$(DESTDIR)$(prefix)/$(herefromroot)"; \
	i_libdir="$(DESTDIR)$(libdir)`echo $(herefromroot)/ | sed -e s:^lib:: -e s:/\\$$::`"; \
	t_libdir="$$i_libdir"; \
	if test "no" = "yes"; then \
	  t_libdir="$$c_libdir"; \
	fi; \
	for file in $(INSTFILES_LIB_DATA); do \
	  rm -f "$$t_libdir/$$file"; \
	done; \
	for build_dir in *@gambit*; do \
	  for file in $$build_dir/*; do \
	    rm -f "$$t_libdir/$$file"; \
	  done; \
	  rmdir "$$t_libdir/$$build_dir" 2> /dev/null; \
	done; \
	if test "$$t_libdir" != "$$i_libdir"; then \
	  for file in $(INSTFILES_LIB_DATA); do \
	    rm -f "$$i_libdir/$$file"; \
	  done; \
	fi; \
	rmdir "$$t_libdir" 2> /dev/null; \
	if test "$$t_libdir" != "$$i_libdir"; then \
	  rmdir "$$i_libdir" 2> /dev/null; \
	fi

select-gen-for-commit-pre:

select-gen-for-commit-post select-gen-for-commit-post-nonrec:

deselect-gen-for-commit-pre:

deselect-gen-for-commit-post deselect-gen-for-commit-post-nonrec:

mostlyclean-pre:

mostlyclean-post mostlyclean-post-nonrec:

clean-pre: mostlyclean-pre

clean-post clean-post-nonrec: mostlyclean-post-nonrec
	rm -rf *@gambit*

distclean-pre: clean-pre

distclean-post distclean-post-nonrec: clean-post-nonrec

bootclean-pre: distclean-pre

bootclean-post bootclean-post-nonrec: distclean-post-nonrec

realclean-pre: bootclean-pre

realclean-post realclean-post-nonrec: bootclean-post-nonrec

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

all-recursive bootstrap-recursive modules-recursive install-recursive uninstall-recursive select-gen-for-commit-recursive deselect-gen-for-commit-recursive mostlyclean-recursive clean-recursive distclean-recursive bootclean-recursive realclean-recursive rc-setup-recursive dist-recursive dist-devel-recursive:
	@if test -n "$(SUBDIRS)"; then \
	  for subdir in ""$(SUBDIRS); do \
	    target=`echo $@ | sed 's/-recursive//'`; \
	    (cd $$subdir && $(MAKE) $$target) || exit 1; \
	  done \
	fi

all: all-post

all-post: all-recursive

all-recursive: all-pre

bootstrap: bootstrap-post

bootstrap-post: bootstrap-recursive

bootstrap-recursive: bootstrap-pre

modules: modules-post

modules-post: modules-recursive

modules-recursive: modules-pre

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

# Tell versions [3.59,3.63) of GNU make not to export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
