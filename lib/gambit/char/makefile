# Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

herefromlib = gambit/char
libfromhere = ../..
SUBDIRS =
HEADERS_SCM = char\#.scm
MODULES_SCM = char.scm char.sld
MAIN_MODULES = char
DATA_FILES = CaseFolding.txt PropList.txt UnicodeData.txt
OTHER_RCFILES = makefile

include $(libfromhere)/module-common.mk

update-unicode:
	wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt -O UnicodeData.txt
	wget https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt -O PropList.txt
	wget https://www.unicode.org/Public/UCD/latest/ucd/CaseFolding.txt -O CaseFolding.txt
