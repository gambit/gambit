/* File: "guideuischeme.cpp", Time-stamp: <2005-04-29 00:04:28 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuischeme.h"

#include <qvariant.h>
#include <qsplitter.h>
#include <qlayout.h>
#include <qtooltip.h>
#include <qwhatsthis.h>
#include <qimage.h>
#include <qpixmap.h>
#include <qtabwidget.h>
#include <qsyntaxhighlighter.h>

#include "_guide.h"
#include "guideuirepl.h"
#include "guideuicont.h"
#include "guideuienv.h"
#include "guideuimainwindow.h"

/*---------------------------------------------------------------------------*/

/*
 *  Constructs a GuideUiScheme as a child of 'parent', with the
 *  name 'name' and widget flags set to 'f'.
 */

GuideUiScheme::GuideUiScheme (GuideUiMainWindow* main_window, QString title)
  : QWidget (0, title, 0)
{
  this->mainWindow = main_window;
  setName ("GuideUiScheme");
  GuideUiSchemeLayout = new QGridLayout (this, 1, 1, 0, 6, "GuideUiSchemeLayout");

  splitter9 = new QSplitter (this, "splitter9");
  splitter9->setOrientation (QSplitter::Vertical);

  //repl was there

  contenv = new QWidget (splitter9, "layout3");
  layout3 = new QHBoxLayout (contenv, 5, 6, "layout3");

  layout2 = new QVBoxLayout (0, 0, 6, "layout2");

  btnStep = new QPushButton (contenv, "btnStep");
  btnStep->setSizePolicy (QSizePolicy ((QSizePolicy::SizeType)0, (QSizePolicy::SizeType)0, 0, 0, btnStep->sizePolicy ().hasHeightForWidth ()));
  btnStep->setMinimumSize (QSize (24, 24));
  btnStep->setMaximumSize (QSize (24, 24));
  btnStep->setPixmap (QPixmap::fromMimeSource ("step.png"));
  layout2->addWidget (btnStep);

  btnLeap = new QPushButton (contenv, "btnLeap");
  btnLeap->setSizePolicy (QSizePolicy ((QSizePolicy::SizeType)0, (QSizePolicy::SizeType)0, 0, 0, btnLeap->sizePolicy ().hasHeightForWidth ()));
  btnLeap->setMinimumSize (QSize (24, 24));
  btnLeap->setMaximumSize (QSize (24, 24));
  btnLeap->setPixmap (QPixmap::fromMimeSource ("leap.png"));
  layout2->addWidget (btnLeap);

  btnCont = new QPushButton (contenv, "btnCont");
  btnCont->setMinimumSize (QSize (24, 24));
  btnCont->setMaximumSize (QSize (24, 24));
  btnCont->setPixmap (QPixmap::fromMimeSource ("cont.png"));
  layout2->addWidget (btnCont);
  spacer1 = new QSpacerItem (20, 120, QSizePolicy::Minimum, QSizePolicy::Expanding);
  layout2->addItem (spacer1);
  layout3->addLayout (layout2);

  splitter7 = new QSplitter (contenv, "splitter7");
  splitter7->setOrientation (QSplitter::Horizontal);

  cont = new GuideUiCont (splitter7, "cont");

  env = new GuideUiEnv (splitter7, "env");

  QValueList<int> sizes = splitter7->sizes ();
  if (sizes.size() >= 2)
    {
      sizes[0] = 600;
      sizes[1] = 400;
      splitter7->setSizes(sizes);
    }

  layout3->addWidget( splitter7 );

  GuideUiSchemeLayout->addWidget (splitter9, 0, 0);

  repl = new GuideUiRepl (this, splitter9, "repl");
  repl->setWrapPolicy (QTextEdit::Anywhere);

  languageChange ();
  resize (QSize (800, 600).expandedTo (minimumSizeHint ()));
  clearWState (WState_Polished);

  // signals and slots connections
  connect (btnStep, SIGNAL(clicked()), this, SLOT(btnStep_clicked()));
  connect (btnLeap, SIGNAL(clicked()), this, SLOT(btnLeap_clicked()));
  connect (btnCont, SIGNAL(clicked()), this, SLOT(btnCont_clicked()));
  connect (cont, SIGNAL(rowChanged(int)), this, SLOT(continuation_row_changed(int)));
  connect (repl, SIGNAL(sendLine(QString)), this, SLOT(typed_text(QString)));

  // Add this widget to the TabWidget of GuideUiMainWindow
  mainWindow->addConsole (this, title);

  sizes = splitter9->sizes ();
  if (sizes.size () >= 2)
    contenv->hide ();

  lines_typed = 0;

  repl->setFocus ();
}

/*
 *  Destroys the object and frees any allocated resources.
 */

GuideUiScheme::~GuideUiScheme()
{
    mainWindow->consoles->removePage (this);
}

/*
 *  Sets the strings of the subwidgets using the current
 *  language.
 */

void GuideUiScheme::languageChange ()
{
  setCaption (tr("Scheme"));
  btnStep->setText (QString::null);
  QToolTip::add (btnStep, tr("Step"));
  btnLeap->setText (QString::null);
  QToolTip::add (btnLeap, tr("Leap"));
  btnCont->setText (QString::null);
  QToolTip::add (btnCont, tr("Continue"));
}

void GuideUiScheme::rehighlight ()
{
  repl->syntaxHighlighter ()->rehighlight ();
}

GuideUiHighlighter* GuideUiScheme::getHighlighter ()
{
  return (GuideUiHighlighter*)(repl->syntaxHighlighter ());
}

int GuideUiScheme::get_nb_typed_lines ()
{
  return lines_typed;
}

void GuideUiScheme::print_text (QString text)
{
  repl->receiveLine(text);
}

void GuideUiScheme::typed_text (QString text)
{
  GuideUiScheme_typed_text (scmobj, text);
  GuideUiScheme_typed_text (scmobj, QString("\n"));
  lines_typed++;
}

void GuideUiScheme::typed_eof ()
{
  GuideUiScheme_typed_eof (scmobj);
}

void GuideUiScheme::continuation_set_highlight (int row)
{
  cont->set_current (row, true);
}

void GuideUiScheme::continuation_set_cell (int row, int col, QString text)
{
  cont->set_cell (row, col, text, true);
}

void GuideUiScheme::continuation_set_length (int nb_rows)
{
  cont->set_nb_rows (nb_rows);
  if (nb_rows == 0)
    {
      env->set_nb_rows (0);
      mainWindow->removeSpecialSelectionInFiles ();
      repl->removeSpecialSelection ();
    }

  // Open or close the debug frame (continuation & environment)
  QValueList<int> sizes = splitter9->sizes ();

  //  printf ("sizes[0] = %d\n", sizes[0]);
  //  if (sizes.size () >= 2)
  //    printf ("sizes[1] = %d\n", sizes[1]);
  //  fflush (stdout);

  if (nb_rows > 0)
    {
      contenv->show ();
      if (sizes.size () >= 2 && sizes[1] > 10 * sizes[0])
        {
          //          contenv->show ();
          sizes[0] = 600;
          sizes[1] = 400;
          splitter9->setSizes (sizes);
        }
    }
  else
    {
      contenv->hide ();
      //      if (sizes.size () >= 2 && sizes[1] < 10 * sizes[0])
      //        {
      //          contenv->hide ();
      //        }
    }
}

void GuideUiScheme::continuation_row_changed (int row)
{
  QString text = QString (",%1").arg (row);
  repl->setUserLine (text);
  repl->simulateReturn ();
}

void GuideUiScheme::environment_set_cell (int row, int col, QString text)
{
  env->set_cell(row, col, text, true);
}

void GuideUiScheme::environment_set_length (int nb_rows)
{
  env->set_nb_rows(nb_rows);
}

void GuideUiScheme::highlight_expr_in_console (int line, int col)
{
  if (contenv->isShown ())
    {
      mainWindow->removeSpecialSelectionInFiles ();
      repl->highlightToken (line, col);
    }
}

void GuideUiScheme::highlight_expr_in_file (int line, int col, QString filename)
{
  if (contenv->isShown ())
    {
      repl->removeSpecialSelection ();
      mainWindow->removeSpecialSelectionInFiles ();
      mainWindow->highlightToken (line-1, col-1, filename);
    }
}

void GuideUiScheme::btnStep_clicked ()
{
  QString text = ",s";
  repl->setUserLine (text);
  repl->simulateReturn ();
}

void GuideUiScheme::btnLeap_clicked ()
{
  QString text = ",l";
  repl->setUserLine (text);
  repl->simulateReturn ();
}

void GuideUiScheme::btnCont_clicked ()
{
  QString text = ",c";
  repl->setUserLine (text);
  repl->simulateReturn ();
}

void GuideUiScheme::setWordWrap (int wordWrap)
{
  repl->setWordWrap ((QTextEdit::WordWrap)wordWrap);
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
