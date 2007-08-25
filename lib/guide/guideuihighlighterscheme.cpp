/* File: "guideuihighlighterscheme.cpp", Time-stamp: <2005-04-28 12:02:08 feeley> */

/* Copyright (C) 1994-2005 by Marc Feeley, All Rights Reserved. */

/*---------------------------------------------------------------------------*/

#include "guide.h"
#include "guideuihighlighterscheme.h"
#include <qtextedit.h>
#include <qvaluestack.h>

/*---------------------------------------------------------------------------*/

GuideUiCodeFormat* GuideUiHighlighterScheme::schemeCodeFormat = 0;

GuideUiHighlighterScheme::GuideUiHighlighterScheme (QTextEdit *textEdit)
  : GuideUiHighlighter (textEdit)
{
  if (schemeCodeFormat == 0)
    {
      // Add the default format elements to the code format
      schemeCodeFormat = codeFormat = new GuideUiCodeFormat();
      codeFormat->addElement(QColor(0  ,0  ,0  ), "Normal");
      codeFormat->addElement(QColor(128,0  ,128), "Parenthesis");
      codeFormat->addElement(QColor(128,128,128), "Comment");
      codeFormat->addElement(QColor(0  ,0  ,255), "Number");
      codeFormat->addElement(QColor(255,0  ,0  ), "String");
      codeFormat->addElement(QColor(0  ,128,0  ), "Identifier");
      codeFormat->addElement(QColor(128,128,0  ), "Keyword");
      codeFormat->addElement(QColor(0  ,128,128), "Constant");
      codeFormat->addElement(QColor(255,128,255), "Highlight");
    }
  else
    codeFormat = schemeCodeFormat;
  highlightPara[0] = highlightPara[1] = -1;
}

// Create a syntax highlighter to apply on 'text'
void GuideUiHighlighterScheme::applyTo (QTextEdit *text)
{
  new GuideUiHighlighterScheme(text);
}

// Returns the length of the pointed token
int GuideUiHighlighterScheme::tokenLength (int para, int index)
{
  QValueVector<TokenType> *tokens;
  QString text = textEdit()->text(para);
  int endState = getEndState(para);
  tokens = getTokens(text, endState);
  TokenType t;

  // Search for the pointed token
  int tokenNb = -1;
  for (uint i=0; i<tokens->size(); i++)
    {
      t = (*tokens)[i];
      if (index >= t.start && index < t.start + t.length)
        {
          tokenNb = i;
          break;
        }
    }

  if (tokenNb == -1) return 1;
  t = (*tokens)[tokenNb];
  if (t.type != T_OPEN_PARENT)
    return t.length;

  // If there is a parenthesis
  int parent = 1;
  tokenNb++;
  while ((uint)tokenNb < tokens->size() && parent > 0)
    {
      t = (*tokens)[tokenNb];
      if (t.type == T_OPEN_PARENT)
        parent++;
      if (t.type == T_CLOSE_PARENT)
        parent--;

      tokenNb++;
    }

  if (parent == 0)
    {
      t = (*tokens)[--tokenNb];
      return t.start + t.length - index;
    }
  return text.length() - index;
}

int GuideUiHighlighterScheme::highlightParagraph (const QString &text, int endStateOfLastPara)
{
  if (!schemeCodeFormat->highlighterEnabled)
    {
      // No highlighting
      setFormat (0, text.length (), 0);
      return 0;
    }

  QString text2 = text;

  // If it is a console, alter 'text' to highlight only the typed text
  if (consoleInfo)
    {
      int startCol;
      if (currentParagraph() == textEdit()->paragraphs()-1)
        startCol = consoleInfo->nbReadOnlyChars;
      else
        startCol = consoleInfo->getStartCol(currentParagraph());
      if (startCol == -1)
        {
          text2 = "";
          setFormat(0, text.length(), 0);
        }
      else
        {
          text2 = QString().fill(' ',startCol);
          text2 += text.right(text.length()-startCol);
          setFormat(0, startCol, 0);
        }
    }

  QValueVector<TokenType> *tokens;
  tokens = getTokens(text2, endStateOfLastPara);
  TokenType t;

  // Search for the first caracter to highlight in the current paragraph
  int highlightIndex = 0;
  while (highlightIndex < 2 && currentParagraph() != highlightPara[highlightIndex])
    highlightIndex++;

  for (uint i=0; i<tokens->size(); i++)
    {
      t = (*tokens)[i];
      int colorNb;
      switch(t.type)
        {
        case T_IDENT:
          colorNb = 5; break;
        case T_KEYWORD:
          colorNb = 6; break;
        case T_OPEN_PARENT: case T_CLOSE_PARENT:
          colorNb = 1; break;
        case T_NUMBER:
          colorNb = 3; break;
        case T_STRING:
          colorNb = 4; break;
        case T_OPEN_COMMENT: case T_CLOSE_COMMENT: case T_COMMENT:
          colorNb = 2; break;
        case T_CONSTANT:
          colorNb = 7; break;
        default:
          colorNb = 0; break;
        }
      setFormat(t.start, t.length, colorNb);

      // Highlight designated characters
      if (highlightIndex < 2) {
        if (highlightColumn[highlightIndex] >= t.start && highlightColumn[highlightIndex] < t.start + t.length)
          {
            setFormat(highlightColumn[highlightIndex], 1, 8);
            highlightIndex++;
            while (highlightIndex < 2 && currentParagraph() != highlightPara[highlightIndex])
              highlightIndex++;
          }
      }
    }

  delete tokens;

  setEndState(currentParagraph(), endStateOfLastPara);
  return endStateOfLastPara;
}

// Get a list of syntaxic tokens from paragraph Text
QValueVector<GuideUiHighlighterScheme::TokenType>* GuideUiHighlighterScheme::getTokens (const QString &text, int &endStateOfLastPara)
{
  QValueVector<TokenType> *tokens = new QValueVector<TokenType>;
  TokenType t;
  int current = 0;
  int length = text.length();
  if (endStateOfLastPara == S_FIRST_PARA)
    endStateOfLastPara = S_NORMAL;

  // Find all the tokens in this paragraph
  while (current < length)
    {
      int last = current;
      t.type = T_NO_TOKEN;

      if (endStateOfLastPara == S_IN_STRING || endStateOfLastPara == S_IN_STRING_2)
        {
          while ((last < length) && (text[last] != ((endStateOfLastPara == S_IN_STRING)?'\"':'|')))
            {
              if (text[last] == '\\') last++;
              last++;
            }
          if (last >= length) // Non-terminated string
            last = length;
          else
            endStateOfLastPara = S_NORMAL;
          t.type = T_STRING;
        }
      // If it is on the comment state
      else if (endStateOfLastPara >= S_COMMENT)
        {
          int index1 = text.find("|#", current);
          int index2 = text.find("#|", current);
          if (index1 == -1 && index2 == -1)
            {
              last = length-1;
              t.type = T_COMMENT;
            }
          else if (index1 == current)
            {
              last = current+1;
              t.type = T_CLOSE_COMMENT;
              endStateOfLastPara--;
              if (endStateOfLastPara < S_COMMENT)
                endStateOfLastPara = S_NORMAL;
            }
          else if (index2 == current)
            {
              last = current+1;
              t.type = T_OPEN_COMMENT;
              endStateOfLastPara++;
            }
          else if (index1 == -1)
            {
              last = index2-1;
              t.type = T_COMMENT;
            }
          else if (index2 == -1)
            {
              last = index1-1;
              t.type = T_COMMENT;
            }
          else
            {
              last = min(index1, index2)-1;
              t.type = T_COMMENT;
            }
        }
      else
        {
          char c = getCharType(text[current]);

          // Open parenthesis
          if (text[last] == '(' ||
              text[last] == '{' ||
              text[last] == '[')
            {
              t.type = T_OPEN_PARENT;
            }
          // Close parenthesis
          else if (text[last] == ')' ||
                   text[last] == '}' ||
                   text[last] == ']')
            {
              t.type = T_CLOSE_PARENT;
            }
          // String
          else if (text[last] == '\"' ||
                   text[last] == '|')
            {
              last++;
              while (last < length && text[current] != text[last])
                {
                  if (text[last] == '\\') last++;
                  last++;
                }
              if (last >= length) // Non-terminated string
                {
                  last = length;
                  endStateOfLastPara = (text[last]=='\"')?S_IN_STRING:S_IN_STRING_2;
                }
              t.type = T_STRING;
            }
          // Line comment
          else if (text[last] == ';')
            {
              last = length;
              t.type = T_COMMENT;
            }
          // Sharp
          else if (text[last] == '#')
            {
              last++;
              if (text[last] == '|') // Block comment
                {
                  t.type = T_OPEN_COMMENT;
                  endStateOfLastPara = S_COMMENT;
                }
              // Boolean constant
              else if (toupper(text[last]) == 'T' ||
                       toupper(text[last]) == 'F')
                {
                  t.type = T_CONSTANT;
                }
              // Text constant
              else if (text[last] == '!' ||
                       text[last] == '\\' ||
                       text[last] == '#')
                {
                  last++;
                  char c2 = getCharType(text[last]);
                  while (last < length && c2 == C_LETTER) {
                    last++;
                    if (last < length)
                      {
                        c2 = getCharType(text[last]);
                        if (c2 != C_LETTER)
                          last--;
                      }
                  }
                  t.type = T_CONSTANT;
                }
              // Number
              else if (toupper(text[last]) == 'E' ||
                       toupper(text[last]) == 'I' ||
                       toupper(text[last]) == 'B' ||
                       toupper(text[last]) == 'D' ||
                       toupper(text[last]) == 'O' ||
                       toupper(text[last]) == 'X')
                {
                  last = last;
                  t.type = T_NUMBER;
                  parseNumber(last, text);
                }
              // Vector
              else if (text[last] == '(') {
                last = last;
                t.type = T_CONSTANT;
              }
            }
          // Identifier
          else if (c == C_LETTER || c == C_INIT)
            {
              c = getCharType(text[last]);
              while (last < length && (c == C_LETTER || c == C_NUMBER ||
                                       c == C_INIT || c == C_NEXT))
                {
                  last++;
                  c = getCharType(text[last]);
                }
              last--;

              if (searchKeyword(text.mid(current, last-current+1)))
                t.type = T_KEYWORD;
              else t.type = T_IDENT;
            }
          else if (c == C_NEXT)
            {
              if (text[last] != '@')
                {
                  if (last+1 == length || getCharType(text[last+1])==C_SPACE)
                    t.type = T_IDENT;
                  if (text[last] == '.' && length > last+2 &&
                      text[last+1] == '.' && text[last+2] == '.')
                    t.type = T_IDENT;
                }
            }
          // Number
          else if (c == C_NUMBER)
            {
              parseNumber(last, text);
              t.type = T_NUMBER;
            }
          // Other
          else
            {
              if (text[last] == '=')
                t.type = T_IDENT;
              if (text[last] == '\'')
                t.type = T_CONSTANT;
            }
        }

      if (t.type != T_NO_TOKEN)
        {
          // Add a token to the vector
          t.start = current;
          t.length = last-current+1;
          tokens->append(t);
        }

      current = last+1;
    }

  return tokens;
}

// DEBUG: print a vector of tokens
void GuideUiHighlighterScheme::printTokens (QValueVector<TokenType>* tokens)
{
  for (uint i=0; i<tokens->size(); i++)
    {
      TokenType t = (*tokens)[i];
      switch(t.type)
        {
        case T_NO_TOKEN: printf("NOTOK"); break;
        case T_IDENT: printf("IDENT"); break;
        case T_KEYWORD: printf("KEYWO"); break;
        case T_OPEN_PARENT: printf("OPENP"); break;
        case T_CLOSE_PARENT: printf("CLOSP"); break;
        case T_NUMBER: printf("NUMBE"); break;
        case T_STRING: printf("STRIN"); break;
        case T_CONSTANT: printf("CONST"); break;
        case T_OPEN_COMMENT: printf("OPENC"); break;
        case T_CLOSE_COMMENT: printf("CLOSC"); break;
        case T_COMMENT: printf("COMME"); break;
        default: printf("XXX%02d", t.type);
        }
      printf("%02d,%02d ",t.start,t.length);
    }
  printf("\n\n");
}

// Parse number from current position
void GuideUiHighlighterScheme::parseNumber (int& last, const QString &text)
{
  bool ok = true;
  int length = text.length();

  while (last < length && ok) {
    CharType c = getCharType(text[last]);
    if (c != C_NUMBER && c != C_LETTER)
      {
        switch (text[last])
          {
          case '#': case '.': case '/': case '@': case '+': case '-': break;
          default: ok = false; last--; return;
          }
      }
    last++;
  }
  last--;
}

// Returns the character type
GuideUiHighlighterScheme::CharType GuideUiHighlighterScheme::getCharType (char c)
{
  if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z')
    return C_LETTER;
  if (c >= '0' && c <= '9')
    return C_NUMBER;

  switch (c)
    {
    case '!': case '$': case '%': case '&': case '*': case '/':
    case ':': case '<': case '>': case '?': case '^': case '_':
    case '~':
      return C_INIT;
    case '+': case '-': case '.': case '@':
      return C_NEXT;
    case ' ': case '\t': case '\n': case '\r':
      return C_SPACE;
    default:
      return C_OTHER;
    }
}

// Search if text is a keyword
bool GuideUiHighlighterScheme::searchKeyword (QString text)
{
  for (int i=0; i<nbKeywords; i++)
    {
      if (text.compare(keywords[i]) == 0)
        return true;
    }
  return false;
}

// When cursor position changed, balance parentheses if the cursor is near of a parenthesis
void GuideUiHighlighterScheme::cursorPositionChanged (int para, int col)
{
  highlightPara[0] = -1;
  highlightColumn[0] = -1;
  highlightPara[1] = -1;
  highlightColumn[1] = -1;

  if (!schemeCodeFormat->matchParent)
    {
      rehighlight();
      return;
    }

  int tokenIndex[2];
  QString text = textEdit()->text(para);
  int endState = getEndState(para-1);
  QValueVector<TokenType> *tokens = getTokens(text, endState);

  highlightPara[0] = highlightPara[1] = -1;

  // Search for parenthesis near the cursor position
  for (uint i=0; i<tokens->size(); i++)
    {
      TokenType t = (*tokens)[i];
      if (t.type == T_OPEN_PARENT &&
          highlightPara[0] == -1 &&
          t.start <= col && t.start >= col-1)
        {
          highlightPara[0] = para;
          highlightColumn[0] = t.start;
          tokenIndex[0] = i;
        }
      if (t.type == T_CLOSE_PARENT &&
          highlightPara[1] == -1 &&
          t.start <= col && t.start >= col-1)
        {
          highlightPara[1] = para;
          highlightColumn[1] = t.start;
          tokenIndex[1] = i;
        }
    }

  if (highlightPara[0] < 0 && highlightPara[1] < 0)
    {
      rehighlight();
      return;
    }

  int paraNb = para, tokenNb;
  if (highlightPara[1] >= 0)
    tokenNb = tokenIndex[1];
  else
    tokenNb = tokenIndex[0];

  int colNb = searchOtherParenthesis(paraNb, tokenNb);

  if (colNb >= 0)
    {
      if (highlightPara[1] >= 0)
        {
          highlightPara[0] = paraNb;
          highlightColumn[0] = colNb;
        }
      else
        {
          highlightPara[1] = paraNb;
          highlightColumn[1] = colNb;
        }
    }

  rehighlight();
}

// Get the indent length of the next paragraph
int GuideUiHighlighterScheme::getIndentLength (int para)
{
  if (!schemeCodeFormat->autoIndent) return -1;
  QValueVector<TokenType> *tokens;

  // Search for the open parenthesis which belongs to this line
  int row = para-1;
  QString text = textEdit()->text(row);
  int endState = getEndState(row-1);
  tokens = getTokens(text, endState);
  int tokenNb = tokens->size()-1;
  int level = 0; // Parenthesis level
  while (level >= 0 && row >= 0)
    {
      // Check the current token
      if (tokenNb >= 0)
        {
          TokenType t = (*tokens)[tokenNb];
          if (t.type == T_OPEN_PARENT)
            level--;
          else if (t.type == T_CLOSE_PARENT)
            level++;
        }
      if (level < 0) continue;

      // Go to next token
      tokenNb--;
      if (tokenNb < 0)
        {
          delete tokens;
          row--;
          text = textEdit()->text(row);
          endState = getEndState(row-1);
          tokens = getTokens(text, endState);
          tokenNb = tokens->size()-1;
        }
    }

  if (level >= 0)
    {
      delete tokens;
      return -1;
    }

  // Calculates the indent length
  int indent;
  switch (tokens->size()-tokenNb-1)
    {
    case 0: indent = (*tokens)[tokenNb].start+1; break;
    case 1: indent = (*tokens)[tokenNb].start+2; break;
    default:
      if ((*tokens)[tokenNb+1].type == T_KEYWORD)
        indent = (*tokens)[tokenNb].start+2;
      else
        indent = (*tokens)[tokenNb+2].start;
      break;
    }
  delete tokens;
  return indent;
}

// When the user double-clicks the textEdit, selects the pointed expression
void GuideUiHighlighterScheme::doubleClicked (int para, int index)
{
  int paraStart = para, paraEnd = para,
    colStart = index, colEnd = index + 1;

  QString text = textEdit()->text(para);
  int endState = getEndState(para-1);
  QValueVector<TokenType> *tokens = getTokens(text, endState);
  TokenType t;

  // Search the double-clicked token
  for (uint i=0; i<tokens->size(); i++)
    {
      t = (*tokens)[i];
      if (index < t.start || index >= t.start + t.length)
        continue;

      // If it is a parenthesis, selects the entire expression
      if (t.type == T_OPEN_PARENT ||
          t.type == T_CLOSE_PARENT)
        {
          int paraNb = para;
          int tokenNb = i;
          int colNb = searchOtherParenthesis(paraNb, tokenNb);
          if (t.type == T_OPEN_PARENT)
            {
              paraStart = para;
              colStart = t.start;
              paraEnd = paraNb;
              colEnd = colNb + 1;
            }
          else
            {
              paraStart = paraNb;
              colStart = colNb;
              paraEnd = para;
              colEnd = t.start + 1;
            }
        }
      else
        {
          paraStart = paraEnd = para;
          colStart = t.start;
          colEnd = t.start + t.length;
        }
      break;
    }

  textEdit()->setSelection(paraStart, colStart, paraEnd, colEnd);
}

// Search for the related parenthesis of the pointed parenthesis
int GuideUiHighlighterScheme::searchOtherParenthesis (int &paraNb, int &tokenNb)
{
  int level = 0;
  QString text = textEdit()->text(paraNb);
  int endState = getEndState(paraNb-1);
  QValueVector<TokenType> *tokens = getTokens(text, endState);
  if (tokenNb > (int)tokens->size()) {
    delete tokens;
    return -1;
  }
  TokenType t = (*tokens)[tokenNb];
  int parentType = t.type;
  // Ensure this is a parenthesis
  if (parentType != T_OPEN_PARENT &&
      parentType != T_CLOSE_PARENT)
    {
      delete tokens;
      return -1;
    }

  // Search for the corresponding open parenthesis
  if (parentType == T_CLOSE_PARENT)
    {
      do
        {
          // Check the current token
          if (tokenNb >= 0)
            {
              t = (*tokens)[tokenNb];
              if (t.type == T_OPEN_PARENT)
                level--;
              if (t.type == T_CLOSE_PARENT)
                level++;
            }
          if (level == 0) continue;

          // Go to the next token
          tokenNb--;
          if (tokenNb < 0)
            {
              paraNb--;
              if (paraNb < 0)
                {
                  if (level > 0) level = -1;
                  tokenNb = 0;
                }
              else
                {
                  delete tokens;
                  text = textEdit()->text(paraNb);
                  endState = getEndState(paraNb-1);
                  tokens = getTokens(text, endState);
                  tokenNb = tokens->size()-1;
                }
            }
        } while (level > 0);

      // If the parenthesis is not found
      if (level != 0)
        paraNb = -1;
    }

  // Search for the corresponding close parenthesis
  else if (highlightPara[0] >= 0)
    {
      do
        {
          // Check the current token
          if (tokenNb < (int)tokens->size())
            {
              t = (*tokens)[tokenNb];
              if (t.type == T_OPEN_PARENT)
                level++;
              if (t.type == T_CLOSE_PARENT)
                level--;
            }
          if (level == 0) continue;

          // Go to the next token
          tokenNb++;
          if (tokenNb >= (int)tokens->size())
            {
              paraNb++;
              tokenNb = 0;
              if (paraNb >= textEdit()->paragraphs())
                {
                  if (level > 0) level = -1;
                }
              else
                {
                  delete tokens;
                  text = textEdit()->text(paraNb);
                  endState = getEndState(paraNb-1);
                  tokens = getTokens(text, endState);
                }
            }
        } while (level > 0);

      // If the parenthesis is not found
      if (level != 0)
        paraNb = -1;
    }

  delete tokens;

  if (paraNb == -1) return -1;
  return t.start;
}

// Sets the end state of the current paragraph
void GuideUiHighlighterScheme::setEndState (int para, int endState)
{
  if (para < 0) return;
  if (para >= (int)endStates.size())
    endStates.resize(para+1, 0);
  endStates[para] = endState;
}

// Returns the end state of the paragraph
int GuideUiHighlighterScheme::getEndState (int para)
{
  if (para < 0)
    return -2;
  if (para >= (int)endStates.size())
    return 0;
  return endStates[para];
}

/*---------------------------------------------------------------------------*/

/* Local Variables: */
/* mode: C++ */
/* End: */
