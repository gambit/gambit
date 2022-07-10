# Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

herefromlib = gambit/char
libfromhere = ../..
SUBDIRS =
HEADERS_SCM = char\#.scm
MODULES_SCM = char.scm char.sld
MAIN_MODULES = char
UNICODE_DATA_FILES = CaseFolding.txt PropList.txt SpecialCasing.txt UnicodeData.txt
DATA_FILES = $(UNICODE_DATA_FILES)
OTHER_RCFILES = makefile

include $(libfromhere)/module-common.mk

update-unicode:
	for f in $(UNICODE_DATA_FILES); do \
	  if wget https://www.unicode.org/Public/UCD/latest/ucd/$$f -O $$f.temp; then \
	    if diff $$f.temp $$f > /dev/null; then \
	      echo "**************************************** $$f unchanged"; \
	      rm -f $$f.temp; \
	    else \
	      echo "**************************************** $$f updated"; \
	      mv $$f.temp $$f; \
	    fi \
	  else \
	    rm -f $$f.temp; \
	  fi \
	done
