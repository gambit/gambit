/* File: "guideuihighlighter.cpp", Time-stamp: <2005-04-12 14:25:52 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuihighlighter.h"
#include <qtextedit.h>

/*---------------------------------------------------------------------------*/

GuideUiHighlighter::GuideUiHighlighter (QTextEdit *textEdit)
  : QSyntaxHighlighter (textEdit)
{
  consoleInfo = 0;
}

// Set format of current paragraph with the specified color
void GuideUiHighlighter::setFormat (int start, int length, int colorNb)
{
  GuideUiElementFormat *ef = codeFormat->getElement(colorNb);
  QSyntaxHighlighter::setFormat(start, length, ef->getFont(textEdit()->font()), ef->getColor());
}

// Return the related code format
GuideUiCodeFormat* GuideUiHighlighter::getCodeFormat ()
{
  return codeFormat;
}

// Links the console infos at this highlighter
void GuideUiHighlighter::setConsoleInfo (GuideUiConsoleInfo *consoleInfo)
{
  this->consoleInfo = consoleInfo;
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
