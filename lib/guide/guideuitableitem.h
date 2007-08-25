/* File: "guideuitableitem.h", Time-stamp: <2005-04-12 13:27:57 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUITABLEITEM_H
#define ___GUIDEUITABLEITEM_H

/*---------------------------------------------------------------------------*/

#include <qtable.h>

/*---------------------------------------------------------------------------*/

class GuideUiTableItem:public QTableItem
  {
  public:

    GuideUiTableItem (QTable *table, const QString &text=0)
      : QTableItem (table, OnTyping, text)
      { }

    virtual int alignment() const
      { return AlignLeft|AlignVCenter; }
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
