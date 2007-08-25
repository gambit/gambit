/* File: "guide.h", Time-stamp: <2007-04-04 11:33:39 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDE_H
#define ___GUIDE_H

/*---------------------------------------------------------------------------*/

#define ___VERSION 40063
#include "gambit.h"

#include <qstring.h>
#include <qapplication.h>
#include "guideuischeme.h"
#include "guideuiinspector.h"

/*---------------------------------------------------------------------------*/

#define min(x,y) (((x)<(y))?(x):(y))
#define max(x,y) (((x)>(y))?(x):(y))

/*---------------------------------------------------------------------------*/

/* For conversion between Scheme strings and QStrings. */

___ERR_CODE SCMOBJ_to_QString (___SCMOBJ src, QString* dst, int arg_num);
___ERR_CODE QString_to_SCMOBJ (QString src, ___SCMOBJ* dst, int arg_num);

#define ___BEGIN_CFUN_SCMOBJ_to_QString(src,dst,i) \
if ((___err = SCMOBJ_to_QString (src, &dst, i)) == ___NO_ERR) {
#define ___END_CFUN_SCMOBJ_to_QString(src,dst,i) }

#define ___BEGIN_CFUN_QString_to_SCMOBJ(src,dst) \
if ((___err = QString_to_SCMOBJ (src, &dst, ___RETURN_POS)) == ___NO_ERR) {
#define ___END_CFUN_QString_to_SCMOBJ(src,dst) \
___EXT(___release_scmobj) (dst); }

#define ___BEGIN_SFUN_QString_to_SCMOBJ(src,dst,i) \
if ((___err = QString_to_SCMOBJ (src, &dst, i)) == ___NO_ERR) {
#define ___END_SFUN_QString_to_SCMOBJ(src,dst,i) \
___EXT(___release_scmobj) (dst); }

#define ___BEGIN_SFUN_SCMOBJ_to_QString(src,dst) \
{ ___err = SCMOBJ_to_QString (src, &dst, ___RETURN_POS);
#define ___END_SFUN_SCMOBJ_to_QString(src,dst) }

/*---------------------------------------------------------------------------*/

QApplication *QApplication_new (char **argv);
void myMessageOutput (QtMsgType type, const char *msg);
void QApplication_processEvents (QApplication *app);

GuideUiMainWindow *GuideUiMainWindow_new (void);

GuideUiScheme *GuideUiScheme_new (GuideUiMainWindow *main_window,
                                  QString title, ___SCMOBJ scmobj);

void GuideUiScheme_print_text (GuideUiScheme *repl, QString text);

void GuideUiScheme_continuation_set_highlight (GuideUiScheme *repl, int row);
void GuideUiScheme_continuation_set_cell (GuideUiScheme *repl, int row, int col, QString text);
void GuideUiScheme_continuation_set_length (GuideUiScheme *repl, int nb_rows);

void GuideUiScheme_environment_set_cell (GuideUiScheme *repl, int row, int col,
QString text);
void GuideUiScheme_environment_set_length (GuideUiScheme *repl, int nb_rows);

void GuideUiScheme_highlight_expr_in_console (GuideUiScheme *repl, int line, int col);
void GuideUiScheme_highlight_expr_in_file (GuideUiScheme *repl, int line, int col, QString filename);

void guide_inspector_current_changed (___SCMOBJ scmobj, int row);

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
