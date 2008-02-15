/* File: "c_intf.h", Time-stamp: <2008-02-14 11:20:52 feeley> */

/* Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved. */

#ifndef ___C_INTF_H
#define ___C_INTF_H


/*---------------------------------------------------------------------------*/

/* Utilities for UTF-8 encoding of characters. */


extern int ___UTF_8_bytes
   ___P((___UCS_4 c),
        ());

extern void ___UTF_8_put
   ___P((___UTF_8STRING *ptr,
         ___UCS_4 c),
        ());

extern ___UCS_4 ___UTF_8_get
   ___P((___UTF_8STRING *ptr),
        ());


/*---------------------------------------------------------------------------*/

/*
 * Decoding/encoding of a buffer of characters (of type ___C) to a
 * buffer of bytes (of type ___U8) in a certain encoding.
 */


#define ___CONVERSION_DONE 0
#define ___INCOMPLETE_CHAR 1
#define ___ILLEGAL_CHAR    2

#define ___DECODE_STATE(x)      ((x)&(3<<7))
#define ___DECODE_STATE_MASK(x) ((x)&~(3<<7))
#define ___DECODE_STATE_NONE    (0<<7)
#define ___DECODE_STATE_LF      (1<<7)
#define ___DECODE_STATE_CR      (2<<7)


#define char_EOL ___UNICODE_LINEFEED


extern int chars_from_bytes
   ___P((___C *char_buf,
         int *char_buf_avail,
         ___U8 *byte_buf,
         int *byte_buf_avail,
         int *decoding_state),
        ());

extern int chars_to_bytes
   ___P((___C *char_buf,
         int *char_buf_avail,
         ___U8 *byte_buf,
         int *byte_buf_avail,
         int *encoding_state),
        ());

extern ___SCMOBJ err_code_from_char_encoding
   ___P((int char_encoding,
         ___BOOL ctos,
         int type,
         int arg_num),
        ());


/*---------------------------------------------------------------------------*/

/* Unicode characters. */


#define ___UNICODE_NUL         0
#define ___UNICODE_BELL        7
#define ___UNICODE_BACKSPACE   8
#define ___UNICODE_TAB         9
#define ___UNICODE_LINEFEED    10
#define ___UNICODE_RETURN      13
#define ___UNICODE_ESCAPE      27
#define ___UNICODE_SPACE       32
#define ___UNICODE_DOUBLEQUOTE 34
#define ___UNICODE_SHARP       35
#define ___UNICODE_QUOTE       39
#define ___UNICODE_PLUS        43
#define ___UNICODE_COMMA       44
#define ___UNICODE_MINUS       45
#define ___UNICODE_0           48
#define ___UNICODE_1           49
#define ___UNICODE_2           50
#define ___UNICODE_3           51
#define ___UNICODE_4           52
#define ___UNICODE_5           53
#define ___UNICODE_6           54
#define ___UNICODE_7           55
#define ___UNICODE_8           56
#define ___UNICODE_9           57
#define ___UNICODE_SEMICOLON   59
#define ___UNICODE_AT          64
#define ___UNICODE_UPPER_A     65
#define ___UNICODE_LOWER_A     97
#define ___UNICODE_UPPER_B     66
#define ___UNICODE_LOWER_B     98
#define ___UNICODE_UPPER_C     67
#define ___UNICODE_LOWER_C     99
#define ___UNICODE_UPPER_D     68
#define ___UNICODE_LOWER_D     100
#define ___UNICODE_UPPER_E     69
#define ___UNICODE_LOWER_E     101
#define ___UNICODE_UPPER_F     70
#define ___UNICODE_LOWER_F     102
#define ___UNICODE_UPPER_G     71
#define ___UNICODE_LOWER_G     103
#define ___UNICODE_UPPER_H     72
#define ___UNICODE_LOWER_H     104
#define ___UNICODE_UPPER_I     73
#define ___UNICODE_LOWER_I     105
#define ___UNICODE_UPPER_J     74
#define ___UNICODE_LOWER_J     106
#define ___UNICODE_UPPER_K     75
#define ___UNICODE_LOWER_K     107
#define ___UNICODE_UPPER_L     76
#define ___UNICODE_LOWER_L     108
#define ___UNICODE_UPPER_M     77
#define ___UNICODE_LOWER_M     109
#define ___UNICODE_UPPER_N     78
#define ___UNICODE_LOWER_N     110
#define ___UNICODE_UPPER_O     79
#define ___UNICODE_LOWER_O     111
#define ___UNICODE_UPPER_P     80
#define ___UNICODE_LOWER_P     112
#define ___UNICODE_UPPER_Q     81
#define ___UNICODE_LOWER_Q     113
#define ___UNICODE_UPPER_R     82
#define ___UNICODE_LOWER_R     114
#define ___UNICODE_UPPER_S     83
#define ___UNICODE_LOWER_S     115
#define ___UNICODE_UPPER_T     84
#define ___UNICODE_LOWER_T     116
#define ___UNICODE_UPPER_U     85
#define ___UNICODE_LOWER_U     117
#define ___UNICODE_UPPER_V     86
#define ___UNICODE_LOWER_V     118
#define ___UNICODE_UPPER_W     87
#define ___UNICODE_LOWER_W     119
#define ___UNICODE_UPPER_X     88
#define ___UNICODE_LOWER_X     120
#define ___UNICODE_UPPER_Y     89
#define ___UNICODE_LOWER_Y     121
#define ___UNICODE_UPPER_Z     90
#define ___UNICODE_LOWER_Z     122
#define ___UNICODE_LPAREN      40
#define ___UNICODE_RPAREN      41
#define ___UNICODE_LBRACKET    91
#define ___UNICODE_BACKSLASH   92
#define ___UNICODE_RBRACKET    93
#define ___UNICODE_LBRACE      123
#define ___UNICODE_VBAR        124
#define ___UNICODE_RBRACE      125
#define ___UNICODE_RUBOUT      127
#define ___UNICODE_REPLACEMENT 0xfffd
#define ___UNICODE_BOM         0xfeff


/*---------------------------------------------------------------------------*/


#endif
