/* File: "guideuiconsoleinfo.cpp", Time-stamp: <2005-04-12 14:29:32 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuiconsoleinfo.h"

/*---------------------------------------------------------------------------*/

GuideUiConsoleInfo::GuideUiConsoleInfo ()
{
  nbReadOnlyParas = 0;
  nbReadOnlyChars = 0;
}

// Add a line relation between repl and console
void GuideUiConsoleInfo::addLine (int typedLineNb, int paraNb, int startCol)
{
  struct LineInfo info;
  info.typedLineNb = typedLineNb;
  info.paraNb = paraNb;
  info.startCol = startCol;
  lines.append(info);
}

// Get the paragraph number related to the typed line number
void GuideUiConsoleInfo::getParaNb (int typedLineNb, int &paraNb, int &startCol)
{
  for (uint i=0; i<lines.size(); i++)
    {
      struct LineInfo info = lines[i];
      if (typedLineNb == info.typedLineNb)
        {
          paraNb = info.paraNb;
          startCol = info.startCol;
          return;
        }
    }
  paraNb = -1;
  return;
}

// Get the starting column related to the paragraph number
int GuideUiConsoleInfo::getStartCol (int paraNb)
{
  for (uint i=0; i<lines.size(); i++)
    {
      struct LineInfo info = lines[i];
      if (paraNb == info.paraNb)
        return info.startCol;
    }
  return -1;
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
