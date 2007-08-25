/* File: "guideuitextedit.h", Time-stamp: <2005-04-12 13:28:10 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUITEXTEDIT_H
#define ___GUIDEUITEXTEDIT_H

/*---------------------------------------------------------------------------*/

#include <qtextedit.h>
#include <qstatusbar.h>

/*---------------------------------------------------------------------------*/

class GuideUiTextEdit : public QTextEdit
  {
    Q_OBJECT

  private:
    // Special selection
    int selectStartPara;
    int selectStartIndex;
    int selectEndPara;
    int selectEndIndex;

    QStatusBar *status;

  public:
    GuideUiTextEdit (QWidget *parent=0, const char *name=0);
    void specialSelect (int selectStartPara,
                        int selectStartIndex,
                        int selectEndPara,
                        int selectEndIndex);
    void setStatusBar (QStatusBar *status);
    void reselect ();
    void removeSpecialSelection ();
    void ensureSpecialSelectionVisible ();

  public slots:
    void this_doubleClicked (int para, int col);
    void this_cursorPositionChanged (int para, int col);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
