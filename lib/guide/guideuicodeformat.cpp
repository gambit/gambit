/* File: "guideuicodeformat.cpp", Time-stamp: <2005-04-12 14:32:53 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuicodeformat.h"

/*---------------------------------------------------------------------------*/

GuideUiElementFormat::GuideUiElementFormat (QString title)
  : title (title)
{
}

GuideUiElementFormat::GuideUiElementFormat ()
  : title ("None")
{
}

QString GuideUiElementFormat::getTitle ()
{
  return title;
}

void GuideUiElementFormat::setColor (QColor color)
{
  this->color = color;
}

QColor GuideUiElementFormat::getColor ()
{
  return color;
}

QFont GuideUiElementFormat::getFont (QFont font)
{
  font.setBold(bold);
  font.setItalic(italic);
  font.setUnderline(underline);
  return font;
}

void GuideUiElementFormat::setBold (bool bold)
{
  this->bold = bold;
}

bool GuideUiElementFormat::getBold ()
{
  return bold;
}

void GuideUiElementFormat::setItalic (bool italic)
{
  this->italic = italic;
}

bool GuideUiElementFormat::getItalic ()
{
  return italic;
}

void GuideUiElementFormat::setUnderline (bool underline)
{
  this->underline = underline;
}

bool GuideUiElementFormat::getUnderline ()
{
  return underline;
}

GuideUiCodeFormat::GuideUiCodeFormat ()
{
}

GuideUiCodeFormat::~GuideUiCodeFormat ()
{
  removeAllElements ();
}

void GuideUiCodeFormat::addElement (const QColor color,
                                    const QString title,
                                    bool bold,
                                    bool italic,
                                    bool underline)
{
  GuideUiElementFormat *ef = new GuideUiElementFormat (title);
  ef->setColor (color);
  ef->setBold (bold);
  ef->setItalic (italic);
  ef->setUnderline (underline);
  addElement (ef);
}

void GuideUiCodeFormat::addElement (GuideUiElementFormat *ef)
{
  elementList.append (ef);
}

void GuideUiCodeFormat::removeAllElements ()
{
  for (uint i=0; i<elementList.size (); i++)
    delete elementList[i];
  elementList.clear();
}

int GuideUiCodeFormat::getNbElements ()
{
  return elementList.size ();
}

GuideUiElementFormat* GuideUiCodeFormat::getElement (int no)
{
  if (no >= 0 && no < (int)elementList.size ())
    return elementList[no];
  return 0;
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
