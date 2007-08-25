/* File: "guideuicodeformat.h", Time-stamp: <2005-04-28 00:01:46 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUICODEFORMAT_H
#define ___GUIDEUICODEFORMAT_H

/*---------------------------------------------------------------------------*/

#include <qobject.h>
#include <qstring.h>
#include <qcolor.h>
#include <qfont.h>
#include <qvaluevector.h>
#include <qtextedit.h>
#include "guideuimainwindow.h"

/*---------------------------------------------------------------------------*/

class GuideUiElementFormat
  {
  private:
    QString title;
    QColor color;
    bool bold;
    bool italic;
    bool underline;

  public:
    GuideUiElementFormat (QString title);
    GuideUiElementFormat ();

    QString getTitle ();
    void setColor (QColor color);
    QColor getColor ();
    QFont getFont (QFont font);
    void setBold (bool bold);
    bool getBold ();
    void setItalic (bool italic);
    bool getItalic ();
    void setUnderline (bool underline);
    bool getUnderline ();
  };

class GuideUiCodeFormat
  {
  private:
    QValueVector<GuideUiElementFormat*> elementList;

  public:
    bool highlighterEnabled;
    bool matchParent;
    bool autoIndent;

    GuideUiCodeFormat ();
    ~GuideUiCodeFormat ();
    int getNbElements ();
    GuideUiElementFormat* getElement (int no);
    void addElement (const QColor color,
                     const QString title,
                     bool bold=FALSE,
                     bool italic=FALSE,
                     bool underline=FALSE);
    void addElement (GuideUiElementFormat* ef);
    void removeAllElements ();
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
