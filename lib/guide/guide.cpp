/* File: "guide.cpp", Time-stamp: <2007-04-04 11:33:30 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guide.h"

/*---------------------------------------------------------------------------*/

___ERR_CODE SCMOBJ_to_QString (___SCMOBJ src, QString* dst, int arg_num)
{
  ___SCMOBJ ___temp; // used by ___STRINGP

  if (!___STRINGP(src))
    return ___STOC_UCS2STRING_ERR+arg_num;

  unsigned int n = ___INT(___STRINGLENGTH(src));
  QString r;

  while (n-- > 0)
    {
      ___UCS4 c = ___INT(___STRINGREF(src,___FIX(n)));
      if (c > 0xffff) // UCS-2 is 16 bits
        return ___STOC_UCS2STRING_ERR+arg_num;
      r.ref (n) = QChar (c);
    }

  *dst = r;

  return ___NO_ERR;
}

___ERR_CODE QString_to_SCMOBJ (QString src, ___SCMOBJ* dst, int arg_num)
{
  unsigned int n = src.length ();
  ___SCMOBJ r = ___alloc_scmobj (___sSTRING, n<<___LCS, ___STILL);

  if (___FIXNUMP(r))
    {
      *dst = ___FAL;
      return ___CTOS_HEAP_OVERFLOW_ERR+arg_num;
    }

  while (n-- > 0)
    {
      ___UCS4 c = src.ref (n).unicode ();
      if (c > ___MAX_CHR)
        {
          ___release_scmobj (r);
          *dst = ___FAL;
          return ___CTOS_UCS2STRING_ERR+arg_num;
        }
      ___STRINGSET(r,___FIX(n),___CHR(c))
    }

  *dst = r;

  return ___NO_ERR;
}

/*---------------------------------------------------------------------------*/

#include <qapplication.h>
#include "guideuimainwindow.h"

#include <stdio.h>
#include <strings.h>
#include "_guide.h"

QApplication *QApplication_new (char **argv)
{
  QApplication *app;
  int argc = 0;
  char **my_argv;
  int i;

  while (argv[argc] != 0)
    argc++;

  my_argv = (char**)___alloc_mem ((argc+1) * sizeof (char*));
  for (i=0; i<argc; i++)
    my_argv[i] = strcpy ((char*)___alloc_mem (strlen (argv[i]) + 1),
                         argv[i]);
  my_argv[i] = 0;

  qInstallMsgHandler( myMessageOutput );
  app = new QApplication (argc, my_argv);

  app->connect (app, SIGNAL(lastWindowClosed()), app, SLOT(quit()));

  return app;
}

void myMessageOutput (QtMsgType type, const char *msg)
{
  switch ( type )
    {
    case QtDebugMsg:
      fprintf( stderr, "Debug: %s\n", msg );
      break;
    case QtWarningMsg:
      // Don't show warning messages
      //fprintf( stderr, "Warning: %s\n", msg );
      break;
    case QtFatalMsg:
      fprintf( stderr, "Fatal: %s\n", msg );
      abort();                    // deliberately core dump
  }
}

void QApplication_processEvents (QApplication *app)
{
  app->processEvents ();
}

GuideUiMainWindow *GuideUiMainWindow_new (void)
{
  GuideUiMainWindow *w = new GuideUiMainWindow ();
  w->show();
  return w;
}

GuideUiScheme *GuideUiScheme_new (GuideUiMainWindow *main_window, QString title,
___SCMOBJ scmobj)
{
  GuideUiScheme *obj = new GuideUiScheme (main_window, title);
  obj->scmobj = scmobj;
  return obj;
}

void GuideUiScheme_print_text (GuideUiScheme *repl, QString text)
{
  repl->print_text (text);
}

void GuideUiScheme_continuation_set_highlight (GuideUiScheme *repl, int row)
{
  repl->continuation_set_highlight (row);
}

void GuideUiScheme_continuation_set_cell (GuideUiScheme *repl, int row, int col,
QString text)
{
  repl->continuation_set_cell (row, col, text);
}

void GuideUiScheme_continuation_set_length (GuideUiScheme *repl, int nb_rows)
{
  repl->continuation_set_length (nb_rows);
}

void GuideUiScheme_environment_set_cell (GuideUiScheme *repl, int row, int col,
QString text)
{
  repl->environment_set_cell (row, col, text);
}

void GuideUiScheme_environment_set_length (GuideUiScheme *repl, int nb_rows)
{
  repl->environment_set_length (nb_rows);
}

void GuideUiScheme_highlight_expr_in_console (GuideUiScheme *repl, int line, int
col)
{
  repl->highlight_expr_in_console (line, col);
}

void GuideUiScheme_highlight_expr_in_file (GuideUiScheme *repl, int line, int col,
QString filename)
{
  repl->highlight_expr_in_file (line, col, filename);
}

void guide_inspector_current_changed (___SCMOBJ scmobj, int row)
{
  //  printf ("guide_inspector_current_changed (0x%08x, %d)\n", scmobj, row);
  //  fflush (stdout);
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
