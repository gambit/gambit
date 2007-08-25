/* File: "guideuihighlighter.h", Time-stamp: <2005-04-12 13:25:34 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUIHIGHLIGHTER_H
#define ___GUIDEUIHIGHLIGHTER_H

/*---------------------------------------------------------------------------*/

#include <qsyntaxhighlighter.h>
#include "guideuicodeformat.h"
#include "guideuiconsoleinfo.h"

/*---------------------------------------------------------------------------*/

class GuideUiHighlighter : public QSyntaxHighlighter
  {
  public:
    GuideUiHighlighter (QTextEdit *textEdit);
    virtual int highlightParagraph (const QString &text, int endStateOfLastPara) = 0;
    GuideUiCodeFormat* getCodeFormat ();
    virtual void cursorPositionChanged (int para, int col) = 0;
    virtual int tokenLength (int para, int col) = 0;
    virtual int getIndentLength (int para) = 0;
    virtual void doubleClicked (int para, int col) = 0;
    virtual void applyTo (QTextEdit *textEdit) = 0;
    void setConsoleInfo (GuideUiConsoleInfo *consoleInfo);

  protected:
    GuideUiCodeFormat *codeFormat;
    GuideUiConsoleInfo *consoleInfo;
    void setFormat (int start, int length, int colorNb);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
