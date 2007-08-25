/* File: "guideuitextedit.cpp", Time-stamp: <2005-04-12 14:06:47 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuitextedit.h"
#include "guideuihighlighter.h"

/*---------------------------------------------------------------------------*/

GuideUiTextEdit::GuideUiTextEdit (QWidget *parent, const char *name)
  : QTextEdit (parent, name)
{
  setHScrollBarMode (AlwaysOn);
  setVScrollBarMode (AlwaysOn);
  selectStartPara = -1;
  selectEndPara = -1;
  connect (this, SIGNAL(doubleClicked(int,int)),
           this, SLOT(this_doubleClicked(int,int)));
  connect (this, SIGNAL(cursorPositionChanged(int, int)),
           this, SLOT(this_cursorPositionChanged(int, int)));
  status = 0;
}

void GuideUiTextEdit::setStatusBar (QStatusBar *status)
{
  this->status = status;
}

// Selects a portion of text by a special selection (yellow default)
void GuideUiTextEdit::specialSelect (int selectStartPara,
                                     int selectStartIndex,
                                     int selectEndPara,
                                     int selectEndIndex)
{
  this->selectStartPara = selectStartPara;
  this->selectStartIndex = selectStartIndex;
  this->selectEndPara = selectEndPara;
  this->selectEndIndex = selectEndIndex;
  reselect ();
}

// Selects the default portion of text
void GuideUiTextEdit::reselect ()
{
  if (selectStartPara >= 0)
    {
      setSelection (selectStartPara,
                    selectStartIndex,
                    selectEndPara,
                    selectEndIndex,
                    1);
      setSelectionAttributes (1, yellow, false);
    }
}

void GuideUiTextEdit::removeSpecialSelection ()
{
  selectStartPara = -1;
  selectEndPara = -1;
  removeSelection (1);
}

void GuideUiTextEdit::ensureSpecialSelectionVisible ()
{
  if (selectStartPara >= 0)
    {
      setCursorPosition (selectStartPara, selectStartIndex);
      ensureCursorVisible ();
    }
}

void GuideUiTextEdit::this_doubleClicked (int para, int col)
{
  ((GuideUiHighlighter*)syntaxHighlighter ())->doubleClicked (para, col);
}

void GuideUiTextEdit::this_cursorPositionChanged (int para, int col)
{
  if (status)
    status->message (QString("Line: %1 Col: %2").arg (para+1).arg (col+1));
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
