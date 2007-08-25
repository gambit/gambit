/* File: "guideuirepl.h", Time-stamp: <2005-04-12 13:26:55 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUIREPL_H
#define ___GUIDEUIREPL_H

/*---------------------------------------------------------------------------*/

#include <qvaluevector.h>
#include <qpopupmenu.h>
#include "guideuitextedit.h"
#include "guideuischeme.h"
#include "guideuiconsoleinfo.h"

/*---------------------------------------------------------------------------*/

class GuideUiRepl : public GuideUiTextEdit
  {
    Q_OBJECT

  private:
    enum RecentEvent {R_TOP, R_UP, R_DOWN, R_BOTTOM};

    GuideUiScheme *scheme;
    GuideUiConsoleInfo *consoleInfo;

    // List of recent commands
    QValueVector<QString> recent;
    QValueVector<const QString*> userRecent;
    uint commandNb;

  private:
    void updateCursor ();
    void updateSelection ();
    void recentEvent (RecentEvent e);
    void addRecent (QString s);

  public:
    GuideUiRepl (GuideUiScheme *sch, QWidget *parent, const char *name);
    virtual void keyPressEvent (QKeyEvent *e);
    virtual void contentsDropEvent (QDropEvent *e);
    virtual void saveAs ();
    virtual void find ();
    void highlightToken (int typedLineNb, int index);
    QString getUserLine ();
    void setUserLine (QString text);
    void simulateReturn ();

  public slots:
    virtual void paste ();
    virtual void cut ();
    virtual void clear ();
    void receiveLine (QString line);
    void repl_cursorPositionChanged (int, int);

  protected:
    virtual QPopupMenu* createPopupMenu (const QPoint &pos);
    virtual void contentsContextMenuEvent (QContextMenuEvent *e);

  signals:
    void sendLine (QString line);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
