/* File: "_guide.h", Time-stamp: <2007-09-12 00:15:35 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

#ifndef ____GUIDE_H
#define ____GUIDE_H

/*---------------------------------------------------------------------------*/

#define ___VERSION 400001
#include "gambit.h"

#include <qstring.h>

/*---------------------------------------------------------------------------*/

void GuideUiScheme_typed_text (___SCMOBJ repl, QString text);
void GuideUiScheme_typed_eof (___SCMOBJ repl);

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
