/* File: "guideuihighlighterscheme.h", Time-stamp: <2005-04-12 13:25:49 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

#ifndef ___GUIDEUIHIGHLIGHTERSCHEME_H
#define ___GUIDEUIHIGHLIGHTERSCHEME_H

/*---------------------------------------------------------------------------*/

#include <qvaluevector.h>
#include "guideuihighlighter.h"
#include "guideuicodeformat.h"
#include "guideuimainwindow.h"

/*---------------------------------------------------------------------------*/

static const QString keywords[] =
  {
    "lambda", "if", "cond", "case", "else", "let", "let*",
    "letrec", "let-syntax", "letrec-syntax", "begin",
    "do", "set!", "define"
  };

static const int nbKeywords = sizeof(keywords) / sizeof(QString);

class GuideUiHighlighterScheme : public GuideUiHighlighter
  {
  public:
    GuideUiHighlighterScheme(QTextEdit *textEdit);
    virtual int highlightParagraph(const QString &text, int endStateOfLastPara);
    virtual void applyTo(QTextEdit *textEdit);
    virtual int tokenLength(int para, int index);
    static GuideUiCodeFormat* schemeCodeFormat;

  private:
    enum Token {T_NO_TOKEN, T_IDENT, T_KEYWORD, T_OPEN_PARENT, T_CLOSE_PARENT,
                T_NUMBER, T_STRING, T_CONSTANT,
                T_OPEN_COMMENT, T_CLOSE_COMMENT, T_COMMENT};
    enum CharType {C_LETTER, C_NUMBER, C_INIT, C_NEXT, C_SPACE, C_OTHER};
    enum StateOfPara {S_FIRST_PARA=-2, S_NORMAL=0, S_IN_STRING,
                      S_IN_STRING_2, S_COMMENT};

    typedef struct TokenType
      {
        Token type;
        int start;
        int length;
      };

    int highlightPara[2];  // Highlighted character positions
    int highlightColumn[2];

    QValueVector<int> endStates;
    void setEndState (int para, int endState);
    int getEndState (int para);
	
    static QValueVector<TokenType>* getTokens (const QString &text, int &endStateOfLastPara);
    static void printTokens (QValueVector<TokenType>* tokens);
    static void parseNumber (int& last, const QString &text);
    static CharType getCharType (char c); 
    static bool searchKeyword (QString text);
    virtual void cursorPositionChanged (int para, int col);
    virtual int getIndentLength (int para);
    virtual void doubleClicked (int para, int col);
    int searchOtherParenthesis (int &paraNb, int &tokenNb);
  };

/*---------------------------------------------------------------------------*/

#endif

/* Local Variables: */
/* mode: C++ */
/* End: */
