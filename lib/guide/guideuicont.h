/* File: "guideuicont.h", Time-stamp: <2005-04-12 12:04:16 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUICONT_H
#define ___GUIDEUICONT_H

/*---------------------------------------------------------------------------*/

#include "guideuiinspector.h"

/*---------------------------------------------------------------------------*/

class GuideUiCont : public GuideUiInspector
  {
  public:
    GuideUiCont (QWidget *parent = 0, const char *name = 0, WFlags f = 0);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
