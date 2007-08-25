/* File: "guideuirepl.cpp", Time-stamp: <2005-04-29 09:36:14 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guideuirepl.h"
#include "guideuihighlighterscheme.h"
#include "guideuisearchdialog.h"
#include "guideuischeme.h"
#include <qfile.h>
#include <qfiledialog.h>

/*---------------------------------------------------------------------------*/

GuideUiRepl::GuideUiRepl (GuideUiScheme *sch, QWidget *parent=0, const char *name=0)
  : GuideUiTextEdit (parent, name)
{
  setUndoRedoEnabled (FALSE);
  setWordWrap (NoWrap);
  connect (this, SIGNAL (cursorPositionChanged (int, int)),
           this, SLOT (repl_cursorPositionChanged (int, int)));
  userRecent.resize (1);
  scheme = sch;
  consoleInfo = new GuideUiConsoleInfo;
  GuideUiHighlighter *highlighter = new GuideUiHighlighterScheme (this);
  highlighter->setConsoleInfo (consoleInfo);
}

// Receive all key press events
void GuideUiRepl::keyPressEvent (QKeyEvent *e)
{
  updateCursor ();

  if (e->key () == Key_Shift || e->key () == Key_Control ||
      e->key () == Key_Meta  || e->key () == Key_Alt) return;

  if (e->state () & ControlButton ||
      e->state () & MetaButton ||
      e->state () & AltButton)
    {
      switch (e->key ())
        {
        case Key_Space:
        case Key_Backspace:
        case Key_Delete:
        case Key_Enter:
        case Key_Return: break;
        default:
          // Special control keys
          if (e->key () == Key_A && e->state () & ControlButton)
            {
              setCursorPosition (consoleInfo->nbReadOnlyParas,
                                 consoleInfo->nbReadOnlyChars);
              return;
            }
          if (e->key () == Key_K && e->state () & ControlButton) {
            moveCursor (MoveLineEnd, true);
            cut ();
            return;
          }
          if (e->key () == Key_Y && e->state () & ControlButton) {
            paste ();
            return;
          }
          QTextEdit::keyPressEvent (e);
        }
      return;
    }

  // Remove selection from the protected lines
  updateSelection ();

  // If key is backspace and cursor between
  // protected and editable lines, do nothing
  if (e->key () == Key_Backspace)
    {
      int para, index;

      getCursorPosition(&para, &index);

      if (para == consoleInfo->nbReadOnlyParas &&
          index == consoleInfo->nbReadOnlyChars)
        return;
    }

  // Send editable line to receiver
  if (e->key () == Key_Return)
    {
      QString userLine = getUserLine ();
      addRecent (userLine);
      int para = consoleInfo->nbReadOnlyParas;
      setCursorPosition (para,
                         paragraphLength (para));
      consoleInfo->addLine (scheme->get_nb_typed_lines ()+1,
                            paragraphs ()-1,
                            consoleInfo->nbReadOnlyChars);
      consoleInfo->nbReadOnlyParas = paragraphs ();
      consoleInfo->nbReadOnlyChars = 0;
      sendLine (userLine);
    }

  // Emits recent events
  if (e->key () == Key_Up)
    {
      recentEvent (R_UP);
      return;
    }
  if (e->key () == Key_Down)
    {
      recentEvent (R_DOWN);
      return;
    }
  if (e->key () == Key_Prior)
    {
      recentEvent (R_TOP);
      return;
    }
  if (e->key () == Key_Next)
    {
      recentEvent (R_BOTTOM);
      return;
    }

  QTextEdit::keyPressEvent (e);
  updateCursor ();
}

// Update selection and cursor before pasting
void GuideUiRepl::paste ()
{
  updateSelection ();
  updateCursor ();
  QTextEdit::paste ();
}

// Update selection and cursor before cutting
void GuideUiRepl::cut ()
{
  updateSelection ();
  updateCursor ();
  QTextEdit::cut ();
}

// Clear the user text
void GuideUiRepl::clear ()
{
  setSelection (consoleInfo->nbReadOnlyParas,
                consoleInfo->nbReadOnlyChars,
                paragraphs ()-1,
                paragraphLength (paragraphs ()-1));
  removeSelectedText ();
}

// Receive recent events
void GuideUiRepl::recentEvent (RecentEvent e)
{
  if (recent.size () == 0)
    return;

  // Save current line
  QString userLine = getUserLine ();
  QString recentLine = (commandNb >= recent.size ())?"":recent[commandNb];
  if (userLine.compare (recentLine) == 0) {
    if (userRecent[commandNb] != 0)
      delete userRecent[commandNb];
    userRecent[commandNb] = 0;
  } else {
    if (userRecent[commandNb] != 0)
      delete userRecent[commandNb];
    userRecent[commandNb] = new QString (userLine);
  }

  // Change the current line
  switch (e)
    {
    case R_TOP: commandNb = 0; break;
    case R_BOTTOM: commandNb = recent.size (); break;
    case R_UP: if (commandNb > 0) commandNb--; break;
    case R_DOWN: if (commandNb < recent.size ()) commandNb++; break;
    }

  // Replace the editable line
  setSelection (consoleInfo->nbReadOnlyParas,
                consoleInfo->nbReadOnlyChars,
                paragraphs ()-1,
                paragraphLength (paragraphs ()-1));

  if (userRecent[commandNb] != 0)
    userLine = *userRecent[commandNb];
  else userLine = (commandNb >= recent.size ())?"":recent[commandNb];
  insert (userLine);
  int para, index;
  getCursorPosition (&para, &index);
  cursorPositionChanged (para, index);
}

// Add a recent line
void GuideUiRepl::addRecent (QString s)
{
  recent.append (s);
  userRecent.resize (recent.size ()+1, 0);
  for (uint i=0; i<userRecent.size (); i++) {
    if (userRecent[i] != 0) {
      delete userRecent[i];
      userRecent[i] = 0;
    }
  }
  commandNb = recent.size ();
}

// Returns the user typed text
QString GuideUiRepl::getUserLine ()
{
  QString line (text (consoleInfo->nbReadOnlyParas));
  return line.mid (consoleInfo->nbReadOnlyChars,
                   line.length ()-consoleInfo->nbReadOnlyChars-1);
}

// Replaces the user typed text by 'line'
void GuideUiRepl::setUserLine (QString line)
{
  setSelection (consoleInfo->nbReadOnlyParas,
                consoleInfo->nbReadOnlyChars,
                paragraphs ()-1,
                paragraphLength (paragraphs ()-1));
  removeSelectedText ();
  insert (line);
  reselect ();
}

// Send the user line and simulate the return key
void GuideUiRepl::simulateReturn ()
{
  QString userLine = getUserLine ();
  consoleInfo->nbReadOnlyParas = paragraphs ();
  consoleInfo->nbReadOnlyChars = 0;
  sendLine (userLine);
  insertParagraph ("", -1);
  reselect ();
}

// Put the cursor out of the protected lines
void GuideUiRepl::updateCursor ()
{
  int para;  
  int index; 

  getCursorPosition (&para, &index);
  if (para < consoleInfo->nbReadOnlyParas)
    {
      para = consoleInfo->nbReadOnlyParas;
      index = 0;
    }
  if (para == consoleInfo->nbReadOnlyParas)
    if (index < consoleInfo->nbReadOnlyChars)
      index = consoleInfo->nbReadOnlyChars;
  setCursorPosition (para, index);
}

// Put the selection out of the protected lines
void GuideUiRepl::updateSelection ()
{
  if (hasSelectedText ())
    {
      int paraFrom, indexFrom, paraTo, indexTo;
      getSelection (&paraFrom, &indexFrom, &paraTo, &indexTo);
      if (paraFrom < consoleInfo->nbReadOnlyParas)
        {
          paraFrom = consoleInfo->nbReadOnlyParas;
          indexFrom = 0;
        }
      if (paraFrom == consoleInfo->nbReadOnlyParas &&
          indexFrom < consoleInfo->nbReadOnlyChars)
        indexFrom = consoleInfo->nbReadOnlyChars;
      if (paraTo < consoleInfo->nbReadOnlyParas)
        {
          paraTo = consoleInfo->nbReadOnlyParas;
          indexTo = 0;
        }
      if (paraTo == consoleInfo->nbReadOnlyParas &&
          indexTo < consoleInfo->nbReadOnlyChars)
        indexTo = consoleInfo->nbReadOnlyChars;
      setSelection (paraFrom, indexFrom, paraTo, indexTo);
    }
}

// Called when the console receives a line of text
void GuideUiRepl::receiveLine (QString line)
{
  if (paragraphLength (paragraphs ()-1) == 0)
    removeParagraph (paragraphs ()-1);
  consoleInfo->nbReadOnlyParas = paragraphs ();
  append (line);
  consoleInfo->nbReadOnlyParas = paragraphs ()-1;
  // Ensure to see the leftmost character
  consoleInfo->nbReadOnlyChars = 0;
  updateCursor ();
  consoleInfo->nbReadOnlyChars = paragraphLength (consoleInfo->nbReadOnlyParas);
  updateCursor ();
  reselect ();
}

// Overload the drop event handler
void GuideUiRepl::contentsDropEvent (QDropEvent *e)
{
  int para;
  int index; 

  getCursorPosition (&para, &index);

  // Receive drop only if in the editable line
  if (para >= consoleInfo->nbReadOnlyParas &&
      index >= consoleInfo->nbReadOnlyChars)
    QTextEdit::contentsDropEvent (e);
}

// When the cursor position is changed, balance highlighted parentheses
void GuideUiRepl::repl_cursorPositionChanged (int para, int col)
{
  QSyntaxHighlighter *sh = syntaxHighlighter ();
  if (sh == 0) return;
  ((GuideUiHighlighter*)sh)->cursorPositionChanged (para, col);
}

// Create the popup menu of the repl
QPopupMenu* GuideUiRepl::createPopupMenu (const QPoint &)
{
  QPopupMenu *popup = new QPopupMenu (); // = QTextEdit::createPopupMenu (pos);
  popup->insertItem ("Cut");
  popup->insertItem ("Copy");
  popup->insertItem ("Paste");	
  popup->insertItem ("Clear");
  popup->insertSeparator ();
  popup->insertItem ("Select all");
  popup->insertSeparator ();
  popup->insertItem ("Save as...");
  popup->insertItem ("Find...");
  return popup;
}

// Called when the right click button is pressed
void GuideUiRepl::contentsContextMenuEvent (QContextMenuEvent *e)
{
  e->accept ();
  QPopupMenu *popup = createPopupMenu (e->globalPos ());
  int id = popup->exec (e->globalPos ());
  int index = popup->indexOf (id);
  delete popup;
  switch (index)
    {
    case 0: cut (); break;
    case 1: copy (); break;
    case 2: paste (); break;
    case 3: clear (); break;
    case 5: selectAll (); break;
    case 7: saveAs (); break;
    case 8: find (); break;
    }
}

// Save the content of the REPL
void GuideUiRepl::saveAs ()
{
  QString fileName = QFileDialog::getSaveFileName ();
  if (fileName.isNull ())
    return;

  QFile file (fileName);
  if (!file.open (IO_WriteOnly))
    {
      printf ("\nWrite Error : '%s'\n", fileName.ascii ());
      return;
    }

  QString txt = text ();
  QByteArray data;
  data.assign (txt.ascii (), txt.length ());
  file.writeBlock (data);
  file.close ();
}

// Find a word in the REPL
void GuideUiRepl::find ()
{
  GuideUiSearchDialog sd;
  sd.setEditor (this);
  sd.exec ();
}

// Highlight the token situated at paragraph para and character index
void GuideUiRepl::highlightToken (int typedLineNb, int col)
{
  int para, startCol;
  consoleInfo->getParaNb (typedLineNb, para, startCol);
  if (para < 0) return;
  GuideUiHighlighter *highlighter = (GuideUiHighlighter *)syntaxHighlighter ();
  int length = highlighter->tokenLength (para, startCol+col-1);
  specialSelect (para, startCol+col-1, para, startCol+col+length-1);
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
