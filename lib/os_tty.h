/* File: "os_tty.h" */

/* Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_TTY_H
#define ___OS_TTY_H

#include "os.h"
#include "os_io.h"


/*---------------------------------------------------------------------------*/


#define DEFAULT_PAREN_BALANCE_DURATION_NSECS 500000000 /* 1/2 second */
#define DEFAULT_EMACS_BINDINGS 1


#ifdef USE_WIN32
#ifdef _UNICODE
#define TTY_CHAR_SELECT(cs1,cs2)cs2
#else
#define TTY_CHAR_SELECT(cs1,cs2)cs1
#endif
#else
#define TTY_CHAR_SELECT(cs1,cs2)cs1
#endif

#define TTY_CHAR TTY_CHAR_SELECT(___U8,___U16)


#define ___C_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___CS_SELECT(latin1,ucs2,ucs4)


/*---------------------------------------------------------------------------*/

/* Extensible string data structure */


typedef ___C extensible_string_char;

typedef struct extensible_string_struct
  {
    extensible_string_char *buffer;
    int length;
    int max_length;
  } extensible_string;


/*---------------------------------------------------------------------------*/

/* TTY text attributes */


typedef int tty_text_attrs;

#define TEXT_STYLE_NORMAL    0
#define TEXT_STYLE_BOLD      1
#define TEXT_STYLE_UNDERLINE 2
#define TEXT_STYLE_REVERSE   4

#define TEXT_COLOR_BLACK          0
#define TEXT_COLOR_RED            1
#define TEXT_COLOR_GREEN          2
#define TEXT_COLOR_YELLOW         3
#define TEXT_COLOR_BLUE           4
#define TEXT_COLOR_MAGENTA        5
#define TEXT_COLOR_CYAN           6
#define TEXT_COLOR_WHITE          7
#define TEXT_COLOR_BRIGHT_BLACK   8
#define TEXT_COLOR_BRIGHT_RED     9
#define TEXT_COLOR_BRIGHT_GREEN   10
#define TEXT_COLOR_BRIGHT_YELLOW  11
#define TEXT_COLOR_BRIGHT_BLUE    12
#define TEXT_COLOR_BRIGHT_MAGENTA 13
#define TEXT_COLOR_BRIGHT_CYAN    14
#define TEXT_COLOR_BRIGHT_WHITE   15
#define DEFAULT_TEXT_COLOR        256

#define GET_STYLE(x)(((x)>>18)&3)
#define GET_FOREGROUND_COLOR(x)((x)&511)
#define GET_BACKGROUND_COLOR(x)(((x)>>9)&511)

#define MAKE_TEXT_ATTRS(s,f,b)(((s)<<18)+(f)+((b)<<9))

#define INITIAL_TEXT_ATTRS \
MAKE_TEXT_ATTRS(TEXT_STYLE_NORMAL,DEFAULT_TEXT_COLOR,DEFAULT_TEXT_COLOR)

#define DEFAULT_INPUT_TEXT_ATTRS \
MAKE_TEXT_ATTRS(TEXT_STYLE_BOLD,DEFAULT_TEXT_COLOR,DEFAULT_TEXT_COLOR)

#define DEFAULT_OUTPUT_TEXT_ATTRS \
MAKE_TEXT_ATTRS(TEXT_STYLE_NORMAL,DEFAULT_TEXT_COLOR,DEFAULT_TEXT_COLOR)


/*---------------------------------------------------------------------------*/

/* Line editor data structures */


#define LINEEDITOR_EV_NONE            0
#define LINEEDITOR_EV_EOF             -1
#define LINEEDITOR_EV_KEY             1
#define LINEEDITOR_EV_RETURN          2
#define LINEEDITOR_EV_BACK            3
#define LINEEDITOR_EV_BACK_WORD       4
#define LINEEDITOR_EV_BACK_SEXPR      5
#define LINEEDITOR_EV_TAB             6
#define LINEEDITOR_EV_MARK            7
#define LINEEDITOR_EV_PASTE           8
#define LINEEDITOR_EV_CUT             9
#define LINEEDITOR_EV_CUT_RIGHT       10
#define LINEEDITOR_EV_CUT_LEFT        11
#define LINEEDITOR_EV_REFRESH         12
#define LINEEDITOR_EV_TRANSPOSE       13
#define LINEEDITOR_EV_TRANSPOSE_WORD  14
#define LINEEDITOR_EV_TRANSPOSE_SEXPR 15
#define LINEEDITOR_EV_UP              16
#define LINEEDITOR_EV_DOWN            17
#define LINEEDITOR_EV_RIGHT           18
#define LINEEDITOR_EV_RIGHT_WORD      19
#define LINEEDITOR_EV_RIGHT_SEXPR     20
#define LINEEDITOR_EV_LEFT            21
#define LINEEDITOR_EV_LEFT_WORD       22
#define LINEEDITOR_EV_LEFT_SEXPR      23
#define LINEEDITOR_EV_HOME            24
#define LINEEDITOR_EV_HOME_DOC        25
#define LINEEDITOR_EV_INSERT          26
#define LINEEDITOR_EV_DELETE          27
#define LINEEDITOR_EV_DELETE_WORD     28
#define LINEEDITOR_EV_DELETE_SEXPR    29
#define LINEEDITOR_EV_END             30
#define LINEEDITOR_EV_END_DOC         31
#define LINEEDITOR_EV_F1              32
#define LINEEDITOR_EV_META_F1         33
#define LINEEDITOR_EV_F2              34
#define LINEEDITOR_EV_META_F2         35
#define LINEEDITOR_EV_F3              36
#define LINEEDITOR_EV_META_F3         37
#define LINEEDITOR_EV_F4              38
#define LINEEDITOR_EV_META_F4         39

#ifdef LINEEDITOR_SUPPORT_F5_TO_F12
#define LINEEDITOR_EV_F5              40
#define LINEEDITOR_EV_META_F5         41
#define LINEEDITOR_EV_F6              42
#define LINEEDITOR_EV_META_F6         43
#define LINEEDITOR_EV_F7              44
#define LINEEDITOR_EV_META_F7         45
#define LINEEDITOR_EV_F8              46
#define LINEEDITOR_EV_META_F8         47
#define LINEEDITOR_EV_F9              48
#define LINEEDITOR_EV_META_F9         49
#define LINEEDITOR_EV_F10             50
#define LINEEDITOR_EV_META_F10        51
#define LINEEDITOR_EV_F11             52
#define LINEEDITOR_EV_META_F11        53
#define LINEEDITOR_EV_F12             54
#define LINEEDITOR_EV_META_F12        55
#define LINEEDITOR_EV_LAST            LINEEDITOR_EV_META_F12
#else
#define LINEEDITOR_EV_LAST            LINEEDITOR_EV_META_F4
#endif


#define LINEEDITOR_CAP_HOME  0
#define LINEEDITOR_CAP_CLEAR 1
#define LINEEDITOR_CAP_CUU1  2
#define LINEEDITOR_CAP_CUD1  3
#define LINEEDITOR_CAP_CUU   4
#define LINEEDITOR_CAP_CUD   5
#define LINEEDITOR_CAP_CUF   6
#define LINEEDITOR_CAP_CUB   7
#define LINEEDITOR_CAP_CUP   8
#define LINEEDITOR_CAP_SGR0  9
#define LINEEDITOR_CAP_BOLD  10
#define LINEEDITOR_CAP_SMUL  11
#define LINEEDITOR_CAP_REV   12
#define LINEEDITOR_CAP_SETAF 13
#define LINEEDITOR_CAP_SETAB 14
#define LINEEDITOR_CAP_ED    15
#define LINEEDITOR_CAP_EL    16
#define LINEEDITOR_CAP_EL1   17
#define LINEEDITOR_CAP_WINDOW_OP0 18
#define LINEEDITOR_CAP_WINDOW_OP1 19
#define LINEEDITOR_CAP_WINDOW_OP2 20
#define LINEEDITOR_CAP_WINDOW_OP3 21
#define LINEEDITOR_CAP_LAST  LINEEDITOR_CAP_WINDOW_OP3


typedef struct lineeditor_event_struct
  {
    int event_kind;
    ___C event_char;
  } lineeditor_event;


typedef struct lineeditor_history_struct
  {
    struct lineeditor_history_struct *prev; /* circular list links */
    struct lineeditor_history_struct *next;
    extensible_string actual; /* the nonedited version of the history line */
    extensible_string edited; /* edited.buffer != NULL when being edited */
  } lineeditor_history;


#define WITH_ESC_PREFIX ___CAST_U8(1<<7)


/*
 * LARGEST_DECODER is the size of the largest input decoder over all
 * terminals defined in the termcap database.  The largest input
 * decoder is for the "ti926-8" terminal.  Note that this value must
 * be updated when the keyboard bindings are changed.
 */

#ifdef LINEEDITOR_SUPPORT_F5_TO_F12
#define LARGEST_DECODER 177
#else
#define LARGEST_DECODER 128
#endif


/*
 * The type lineeditor_input_decoder_state must at least contain the
 * range 0 .. LINEEDITOR_EV_LAST + LARGEST_DECODER + 1.
 */

#if LINEEDITOR_EV_LAST + LARGEST_DECODER + 1 <= 255

typedef ___U8 lineeditor_input_decoder_state;
#define LINEEDITOR_INPUT_DECODER_STATE_MAX 255

#else

typedef ___U16 lineeditor_input_decoder_state;
#define LINEEDITOR_INPUT_DECODER_STATE_MAX 65535

#endif

#define LINEEDITOR_INPUT_DECODER_MAX_LENGTH \
(LINEEDITOR_INPUT_DECODER_STATE_MAX-LINEEDITOR_EV_LAST-1)


typedef struct lineeditor_input_test_struct
  {
    ___U8 trigger; /* action is performed when this 8 bit character is read */
    lineeditor_input_decoder_state action; /* event type or new state */
    lineeditor_input_decoder_state next;   /* next test when char != trigger */
  } lineeditor_input_test;


typedef struct lineeditor_input_decoder_struct
  {
    lineeditor_input_test *buffer;
    int length;
    int max_length;
  } lineeditor_input_decoder;


#define LINEEDITOR_MODE_DISABLE 0
#define LINEEDITOR_MODE_SCHEME  1


struct lineeditor_state_undo_struct
  {
    lineeditor_history *hist;
    int edit_point;        /* position in buffer where edit ops take place */
    int completion_point;  /* position in buffer where completion started */
    int mark_point;        /* position in buffer of mark */
    int line_start;        /* position in screen where edited line starts */
    ___BOOL paren_balance_trigger;
    ___BOOL paren_balance_in_progress;
    ___time paren_balance_end;
    tty_text_attrs attrs;
  };


typedef struct ___device_tty_struct
  {
    ___device_stream base;

    int stage; /* the tty's initialisation stage */

#define TTY_STAGE_NOT_OPENED     0
#define TTY_STAGE_OPENED_FRESH   1
#define TTY_STAGE_MODE_NOT_SAVED 2
#define TTY_STAGE_MODE_NOT_SET   3
#define TTY_STAGE_INIT_DONE      4

    struct ___device_tty_struct *mode_save_stack_next;

    /* current mode settings of the tty */

    ___BOOL input_allow_special;  /* handle ctrl-c, etc specially    */
    ___BOOL input_echo;           /* echo input                      */
    ___BOOL input_raw;            /* read bytes directly from device */
    ___BOOL output_raw;           /* write bytes directly to device  */
    int speed;                    /* baud rate                       */

#define TERMINAL_NB_COLS_UNLIMITED (1U<<17) /* fake unlimited width */

#ifdef USE_LINEEDITOR

    /* for terminal emulation */

    ___BOOL emulate_terminal;

    int terminal_nb_cols;  /* size of terminal (number of columns)    */
    int terminal_nb_rows;  /* size of terminal (number of rows)       */
    int terminal_size;     /* size of terminal (number of characters) */

    ___BOOL has_auto_left_margin;
    ___BOOL has_auto_right_margin;
    ___BOOL has_eat_newline_glitch;
    ___BOOL linefeed_moves_to_left_margin;
    ___BOOL size_needs_update;

    int terminal_col;  /* position of cursor */
    int terminal_row;
    int terminal_cursor;
    ___BOOL terminal_delayed_wrap;  /* cursor wrap to next line is delayed? */

    int terminal_op_type;    /* state of detection of escape sequences */
    int terminal_param_num;
    int terminal_param[10];
    ___U8 terminal_param_text[80];

    tty_text_attrs terminal_attrs;  /* attributes of text sent to terminal */

    /* input and output buffers */

    int input_byte_lo;         /* start of remaining input in "input_byte"   */
    int input_byte_hi;         /* end of remaining input in "input_byte"     */
    ___U8 input_byte[128];     /* bytes to input                             */
    int input_char_lo;         /* start of remaining input in "input_char"   */
    int input_char_hi;         /* end of remaining input in "input_char"     */
    ___C input_char[128];      /* characters available for input             */
    int input_decoding_state;  /* state of conversion from bytes to chars    */
    int input_encoding_state;  /* state of conversion from chars to bytes    */
    int input_line_lo;         /* start of remaining input in "input_line"   */
    extensible_string input_line; /* line available for input                */

    int output_byte_lo;        /* start of remaining output in "output_byte" */
    int output_byte_hi;        /* end of remaining output in "output_byte"   */
    ___U8 output_byte[128];    /* bytes to output                            */
    int output_char_incomplete; /* number of unprocessed bytes */
    int input_char_incomplete;  /* number of unprocessed bytes */
    int output_decoding_state; /* state of conversion from bytes to chars    */
    int output_encoding_state; /* state of conversion from chars to bytes    */
    int output_char_lo;        /* start of remaining output in "output_char" */
    extensible_string output_char; /* characters to output                   */

    /* line editing */

    int lineeditor_mode;

    ___BOOL editing_line;

    ___C prompt[128];
    int prompt_length;

    int lineeditor_input_byte_lo;
    int lineeditor_input_byte_hi;
    ___U8 lineeditor_input_byte[128];

    ___BOOL paste_cancel;
    int paste_index;
    ___C *paste_text;

    int history_max_length;
    int history_length; /* number of history lines, not counting last */
    lineeditor_history *hist_last;

    struct lineeditor_state_undo_struct current;

    int paren_balance_duration_nsecs;

    tty_text_attrs input_attrs;
    tty_text_attrs output_attrs;

#ifdef USE_CURSES
    char *capability[LINEEDITOR_CAP_LAST+1];
#endif

    lineeditor_input_decoder input_decoder;
    lineeditor_input_decoder_state input_decoder_state;

#ifdef LINEEDITOR_WITH_LOCAL_CLIPBOARD
    extensible_string clipboard;
#endif

#endif

#ifdef USE_POSIX
    int fd;
#endif

#ifdef USE_tcgetsetattr
    struct termios initial_termios;
#endif

#ifdef USE_fcntl
    int initial_flags;
#endif

#ifdef USE_WIN32

    HANDLE hin;
    HANDLE hout;
    DWORD hin_initial_mode;
    DWORD hout_initial_mode;
    CONSOLE_SCREEN_BUFFER_INFO hout_initial_info;
    INPUT_RECORD ir;
    char *key_seq;

#endif

  } ___device_tty;


typedef struct ___device_tty_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_tty_vtbl;


#ifdef USE_POSIX

extern ___SCMOBJ ___device_tty_setup_from_fd
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int fd,
         int direction),
        ());

#endif


#ifdef USE_WIN32

extern ___SCMOBJ ___device_tty_setup_from_console
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int direction),
        ());

#endif


extern ___SCMOBJ ___device_tty_setup_console
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int direction),
        ());


/*---------------------------------------------------------------------------*/

/* Tty device operations. */


extern ___SCMOBJ ___os_device_tty_type_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ term_type,
         ___SCMOBJ emacs_bindings),
        ());

extern ___SCMOBJ ___os_device_tty_text_attributes_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ input,
         ___SCMOBJ output),
        ());

extern ___SCMOBJ ___os_device_tty_history
   ___P((___SCMOBJ dev),
        ());

extern ___SCMOBJ ___os_device_tty_history_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ history),
        ());

extern ___SCMOBJ ___os_device_tty_history_max_length_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ max_length),
        ());

extern ___SCMOBJ ___os_device_tty_paren_balance_duration_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ duration),
        ());

extern ___SCMOBJ ___os_device_tty_mode_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ input_allow_special,
         ___SCMOBJ input_echo,
         ___SCMOBJ input_raw,
         ___SCMOBJ output_raw,
         ___SCMOBJ speed),
        ());

extern ___SCMOBJ ___os_device_tty_mode_reset ___PVOID;


/*---------------------------------------------------------------------------*/


#define TERMINAL_EMULATION_USES_CURSES


struct ___curses_struct
  {
    ___C output[16];  /* buffer for accumulating curses output */
    int output_lo;
    ___SCMOBJ last_err;
  };

typedef struct ___tty_module_struct
  {
    int refcount; /* number of threads using this structure */

    struct ___device_tty_struct *mode_save_stack; /* mode save stack */

    void (*user_interrupt_handler) ___PVOID;

    void (*terminate_interrupt_handler) ___PVOID;

    struct ___device_tty_struct *curses_tty; /* target of curses operations */

#ifdef TERMINAL_EMULATION_USES_CURSES

    struct ___curses_struct curses[2];

#define CURRENT_CURSES_STRUCT \
___tty_mod.curses[___tty_mod.curses_tty->emulate_terminal]

#else

    struct ___curses_struct curses[1];

#define CURRENT_CURSES_STRUCT ___tty_mod.curses[0]

#endif
  } ___tty_module;


extern ___tty_module ___tty_mod;


/*---------------------------------------------------------------------------*/

/* User interrupt handling. */


extern ___SCMOBJ ___setup_user_interrupt_handling ___PVOID;

extern void ___cleanup_user_interrupt_handling ___PVOID;


/*---------------------------------------------------------------------------*/

/* TTY module initialization/finalization. */


extern ___SCMOBJ ___setup_tty_module
   ___P((void (*user_interrupt_handler) ___PVOID,
         void (*terminate_interrupt_handler) ___PVOID),
        ());

extern void ___cleanup_tty_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
