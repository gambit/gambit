/* File: "guideuiinspector.cpp", Time-stamp: <2005-04-28 23:41:22 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guide.h"
#include "guideuiinspector.h"

#include <qapplication.h>
#include <qmainwindow.h>
#include <qstyle.h>
#include <qheader.h>

/*---------------------------------------------------------------------------*/

GuideUiInspector::GuideUiInspector (QWidget * parent, const char *name, WFlags f)
  : QListView (parent, name, f)
{
  QHeader *h = header ();
  h->setMovingEnabled (false);

  setFont (QFont ("courier", 12));
  setSelectionMode (Single);
  setAllColumnsShowFocus (true);
  setSorting (-1);

  highlight_enabled = false;
  selectedRow = -1;

  scmobj = ___FAL;

  connect (this, SIGNAL(clicked(QListViewItem*)),
           this, SLOT(item_clicked(QListViewItem*)));
}

void GuideUiInspector::clearSelection ()
{
}

void GuideUiInspector::item_clicked (QListViewItem *item)
{
  if (item == 0)
    return;

  int row = ((GuideUiInspectorItem*)item)->row;
  if (row != selectedRow)
    {
      guide_inspector_current_changed (scmobj, selectedRow);
      selectedRow = row;
    }
  rowChanged (row);
}

void GuideUiInspector::set_nb_cols (int nb_cols)
{
  int n = columns ();

  if (n > nb_cols)
    {
      while (n > nb_cols)
        {
          n--;
          removeColumn (n);
        }
    }
  else if (n < nb_cols)
    {
      while (n < nb_cols)
        {
          addColumn (QString::null, 0);
          header ()->setClickEnabled (false, n);
          n++;
        }
    }

  setResizeMode (LastColumn);
}

void GuideUiInspector::set_column (int col, QString text, int width)
{
  while (col >= columns ())
    addColumn ("");
  setColumnText (col, text);
  if (width > 0)
    setColumnWidth (col, width);
  setColumnWidthMode (col, Manual);
}

void GuideUiInspector::set_column_done ()
{
  setResizeMode (LastColumn);
}

void GuideUiInspector::set_nb_rows (int nb_rows)
{
  int n = childCount ();

  if (n > nb_rows)
    {
      while (n > nb_rows)
        {
          n--;
          delete at (n);
        }
    }
  else if (n < nb_rows)
    {
      while (n < nb_rows)
        {
          GuideUiInspectorItem *i;
          if (n > 0)
            {
              i = new GuideUiInspectorItem (this, at (n-1));
              i->row = n;
            }
          else
            {
              i = new GuideUiInspectorItem (this);
              i->row = n;
            }
          n++;
        }
    }
  if (selectedRow >= nb_rows)
    selectedRow = -1;
}

GuideUiInspectorItem *GuideUiInspector::at (int i)
{
  QListViewItem *p = firstChild ();

  while (i > 0 && p != 0)
    {
      p = p->nextSibling ();
      i--;
    }

  return (GuideUiInspectorItem*)p;
}

void GuideUiInspector::set_cell (int row, int col, QString text, bool read_only)
{
  if (row >= childCount ())
    set_nb_rows(3 * childCount () + 3);
	
  GuideUiInspectorItem *i = at (row);
  if (text == i->text (col)) return;
  i->setText (col, text);
  i->setRenameEnabled (col, !read_only);
}

void GuideUiInspector::set_current (int row, bool highlight_enable)
{
  GuideUiInspectorItem *i = at (row);

  if (i == 0)
    return;
  
  if (selectedRow != row)
    {
      selectedRow = row;
      setSelected (i, true);
    }

  if (!highlight_enable)
    QListView::clearSelection ();

  highlight_enabled = highlight_enable;
}

void GuideUiInspectorItem::paintCell (QPainter *p, const QColorGroup &cg, int column, int width, int align)
{
  bool highlight_enabled = ((GuideUiInspector*)listView ())->highlight_enabled;
  bool change_base = (row % 2 == 1);
  bool change_highlight = isSelected () || !highlight_enabled;

  if (change_base || change_highlight)
    {
      QColorGroup _cg (cg);
      QColor cb = _cg.base ();
      QColor ch = _cg.highlight ();
      QColor cht = _cg.highlightedText ();

      if (change_base)
        _cg.setColor (QColorGroup::Base, QColor(220, 255, 255));

      if (change_highlight)
        {
          if (highlight_enabled)
            _cg.setColor (QColorGroup::Highlight, QColor(255, 255, 24));
          else
            _cg.setColor (QColorGroup::Highlight, _cg.base ());
          _cg.setColor (QColorGroup::HighlightedText, QColor(0, 0, 0));
        }

      QListViewItem::paintCell (p, _cg, column, width, align);

      if (change_base)
        _cg.setColor (QColorGroup::Base, cb);

      if (change_highlight)
        {
          _cg.setColor (QColorGroup::Highlight, ch);
          _cg.setColor (QColorGroup::HighlightedText, cht);
        }
    }
  else
    QListViewItem::paintCell (p, cg, column, width, align);
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
