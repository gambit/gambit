/* File: "guideuicont.cpp", Time-stamp: <2005-04-28 23:42:49 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuicont.h"

/*---------------------------------------------------------------------------*/

GuideUiCont::GuideUiCont (QWidget *parent, const char *name, WFlags f)
  : GuideUiInspector (parent, name, f)
{
  highlight_enabled = true;
  set_column (0, "Frame", 45);
  set_column (1, "Procedure", 100);
  set_column (2, "Position", 210);
  set_column (3, "Expression");
  set_column_done ();
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
