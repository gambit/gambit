/* File: "guideuienv.cpp", Time-stamp: <2005-04-28 23:43:08 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuienv.h"

/*---------------------------------------------------------------------------*/

GuideUiEnv::GuideUiEnv (QWidget *parent, const char *name, WFlags f)
  : GuideUiInspector (parent, name, f)
{
  highlight_enabled = false;
  set_column (0, "Variable", 200);
  set_column (1, "Value");
  set_column_done ();
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
