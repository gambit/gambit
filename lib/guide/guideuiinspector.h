/* File: "guideuiinspector.h", Time-stamp: <2005-04-28 15:00:34 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUIINSPECTOR_H
#define ___GUIDEUIINSPECTOR_H

/*---------------------------------------------------------------------------*/

#include "guide.h"
#include <qlistview.h>

/*---------------------------------------------------------------------------*/

class GuideUiInspectorItem : public QListViewItem
  {
  public:
    GuideUiInspectorItem (QListView *parent)
      : QListViewItem (parent)
      { }

    GuideUiInspectorItem (QListViewItem *parent)
      : QListViewItem (parent)
      { }

    GuideUiInspectorItem (QListView *parent, QListViewItem *after)
      : QListViewItem (parent, after)
      { }

    GuideUiInspectorItem (QListViewItem *parent, QListViewItem *after)
      : QListViewItem (parent, after)
      { }

    virtual void paintCell (QPainter *p,
                            const QColorGroup &cg,
                            int column,
                            int width,
                            int align);

    int row;
  };

class GuideUiInspector : public QListView
  {
    Q_OBJECT

  public:
    GuideUiInspector (QWidget * parent = 0, const char *name = 0, WFlags f = 0);
    virtual void clearSelection ();

    void set_nb_cols (int nb_cols);
    void set_column (int col, QString text, int width=0);
    void set_column_done ();
    void set_nb_rows (int nb_rows);
    void set_cell (int row, int col, QString text, bool read_only);
    void set_current (int row, bool highlight_enable);

    ___SCMOBJ scmobj;

  public slots:
    virtual void item_clicked (QListViewItem *item);

  signals:
    void rowChanged (int i);

  protected:
    GuideUiInspectorItem *at (int i);
    bool highlight_enabled;
    int selectedRow;

    friend class GuideUiInspectorItem;
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
