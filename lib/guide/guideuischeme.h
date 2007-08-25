/****************************************************************************
** Form interface generated from reading ui file 'guideuischeme.ui'
**
** Created: lun avr 19 20:53:44 2004
**      by: The User Interface Compiler ($Id: qt/main.cpp   3.3.0b1   edited Nov 24 13:47 $)
**
** WARNING! All changes made in this file will be lost!
****************************************************************************/

#ifndef GUIDEUISCHEME_H
#define GUIDEUISCHEME_H

#include <qvariant.h>
#include <qpixmap.h>
#include <qwidget.h>

#define ___VERSION 40063
#include "gambit.h"

class QVBoxLayout;
class QHBoxLayout;
class QGridLayout;
class QSpacerItem;
class GuideUiRepl;
class GuideUiCont;
class GuideUiEnv;
class GuideUiMainWindow;
class QSplitter;
class GuidePi;
class GuideUiHighlighter;

#include "qpushbutton.h"

class GuideUiScheme : public QWidget
{
    Q_OBJECT

public:
	GuideUiScheme(GuideUiMainWindow* main_window, QString title);
    ~GuideUiScheme();

    QSplitter* splitter9;
    GuideUiRepl* repl;
    QPushButton* btnStep;
    QPushButton* btnLeap;
    QPushButton* btnCont;
    QSplitter* splitter7;
	QWidget* contenv;
    GuideUiCont* cont;
    GuideUiEnv* env;
	___SCMOBJ scmobj;
	GuideUiMainWindow* mainWindow;
	
	int get_nb_typed_lines();
	void setWordWrap(int wordWrap);
	GuideUiHighlighter* getHighlighter();
	
public slots:
    virtual void rehighlight();
    virtual void print_text( QString text );
    virtual void typed_text( QString text );
    virtual void typed_eof();
    virtual void continuation_set_highlight( int row );
    virtual void continuation_set_cell( int row, int col, QString text );
    virtual void continuation_set_length( int nb_rows );
	virtual void continuation_row_changed( int row );
    virtual void environment_set_cell( int row, int col, QString text );
    virtual void environment_set_length( int nb_rows );
    virtual void btnStep_clicked();
    virtual void btnLeap_clicked();
    virtual void btnCont_clicked();
    virtual void highlight_expr_in_console( int line, int col );
    virtual void highlight_expr_in_file( int line, int col, QString filename );
	
protected:
    QGridLayout* GuideUiSchemeLayout;
    QHBoxLayout* layout3;
    QVBoxLayout* layout2;
    QSpacerItem* spacer1;

protected slots:
    virtual void languageChange();

private:
    int lines_typed;
};

#endif // GUIDEUISCHEME_H
