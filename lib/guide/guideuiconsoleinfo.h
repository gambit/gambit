/* File: "guideuiconsoleinfo.h", Time-stamp: <2005-04-12 13:24:35 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUICONSOLEINFO_H
#define ___GUIDEUICONSOLEINFO_H

/*---------------------------------------------------------------------------*/

#include <qvaluevector.h>

/*---------------------------------------------------------------------------*/

struct LineInfo
  {
    int typedLineNb;
    int paraNb;
    int startCol;
  };

class GuideUiConsoleInfo
  {
  private:
    QValueVector<LineInfo> lines;

  public:
    int nbReadOnlyParas; // Number of whole protected paragraphs
    int nbReadOnlyChars; // Number of protected characters after the last whole protected paragraph

    GuideUiConsoleInfo ();
    void addLine (int typedLineNb, int paraNb, int startCol);
    void getParaNb (int typedLineNb, int& paraNb, int& startCol);
    int getStartCol (int paraNb);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
