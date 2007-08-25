/* File: "guideuienv.h", Time-stamp: <2005-04-12 12:03:23 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUIENV_H
#define ___GUIDEUIENV_H

/*---------------------------------------------------------------------------*/

#include "guideuiinspector.h"

/*---------------------------------------------------------------------------*/

class GuideUiEnv : public GuideUiInspector
  {
  public:
    GuideUiEnv (QWidget *parent = 0, const char *name = 0, WFlags f = 0);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
