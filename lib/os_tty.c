/* File: "os_tty.c" */

/* Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to ttys.
 */

#define ___INCLUDED_FROM_OS_TTY
#define ___VERSION 409004
#include "gambit.h"

#include "os_setup.h"
#include "os_thread.h"
#include "os_base.h"
#include "os_tty.h"
#include "os_shell.h"
#include "os_io.h"
#include "os_files.h"
#include "mem.h"
#include "c_intf.h"


/*---------------------------------------------------------------------------*/

/* Extensible string routines */


___HIDDEN ___SCMOBJ extensible_string_setup
   ___P((extensible_string *str,
         int n),
        (str,
         n)
extensible_string *str;
int n;)
{
#define EXTENSIBLE_STRING_INITIAL_BUFFER_SIZE 32

  if (n < EXTENSIBLE_STRING_INITIAL_BUFFER_SIZE)
    n = EXTENSIBLE_STRING_INITIAL_BUFFER_SIZE;

  str->buffer = ___CAST(extensible_string_char*,
                        ___ALLOC_MEM(n * sizeof (extensible_string_char)));

  if (str->buffer == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  str->length = 0;
  str->max_length = n;

  return ___FIX(___NO_ERR);
}


___HIDDEN void extensible_string_cleanup
   ___P((extensible_string *str),
        (str)
extensible_string *str;)
{
  ___FREE_MEM(str->buffer);
}


___HIDDEN ___SCMOBJ extensible_string_copy
   ___P((extensible_string_char *src,
         int len,
         extensible_string *dst,
         int fudge),
        (src,
         len,
         dst,
         fudge)
extensible_string_char *src;
int len;
extensible_string *dst;
int fudge;)
{
  extensible_string_char *buf;

  buf = ___CAST(extensible_string_char*,
                ___ALLOC_MEM((len+fudge) * sizeof (extensible_string_char)));

  if (buf == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  dst->buffer = buf;
  dst->length = len;
  dst->max_length = len+fudge;

  while (len-- > 0)
    buf[len] = src[len];

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ extensible_string_set_length
   ___P((extensible_string *str,
         int len,
         int fudge),
        (str,
         len,
         fudge)
extensible_string *str;
int len;
int fudge;)
{
  if (len > str->max_length || 2*len+1 < str->max_length)
    {
      int i;
      int new_max_length = (fudge<0) ? 3*len/2+1 : len+fudge;
      extensible_string_char *old_buffer = str->buffer;
      extensible_string_char *new_buffer =
        ___CAST(extensible_string_char*,
                ___ALLOC_MEM(new_max_length *
                             sizeof (extensible_string_char)));

      if (new_buffer == NULL)
        return ___FIX(___HEAP_OVERFLOW_ERR);

      i = str->length;
      if (i > len)
        i = len;

      while (i-- > 0)
        new_buffer[i] = old_buffer[i];

      ___FREE_MEM(old_buffer);
      str->buffer = new_buffer;
      str->max_length = new_max_length;
    }

  str->length = len;

  return ___FIX(___NO_ERR);
}


___HIDDEN void extensible_string_delete
   ___P((extensible_string *str,
         int pos,
         int len),
        (str,
         pos,
         len)
extensible_string *str;
int pos;
int len;)
{
  int i;

  if (pos < 0)
    pos = 0;
  else if (pos > str->length)
    pos = str->length;

  i = str->length - pos;
  if (len < 0)
    len = 0;
  else if (len > i)
    len = i;

  for (i=pos; i<str->length-len; i++)
    str->buffer[i] = str->buffer[i+len];

  str->length -= len;
}


___HIDDEN ___SCMOBJ extensible_string_insert
   ___P((extensible_string *str,
         int pos,
         int len,
         extensible_string_char *chars),
        (str,
         pos,
         len,
         chars)
extensible_string *str;
int pos;
int len;
extensible_string_char *chars;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  int i;

  if (len > 0)
    {
      if (pos < 0)
        pos = 0;
      else if (pos > str->length)
        pos = str->length;

      if ((e = extensible_string_set_length (str, str->length+len, -1))
          == ___FIX(___NO_ERR))
        {
          for (i=str->length-len-1; i>=pos; i--)
            str->buffer[i+len] = str->buffer[i];

          for (i=len-1; i>=0; i--)
            str->buffer[i+pos] = chars[i];
        }
    }

  return e;
}


___HIDDEN ___SCMOBJ extensible_string_insert_at_end
   ___P((extensible_string *str,
         int len,
         extensible_string_char *chars),
        (str,
         len,
         chars)
extensible_string *str;
int len;
extensible_string_char *chars;)
{
  return extensible_string_insert (str, str->length, len, chars);
}


/*---------------------------------------------------------------------------*/

/* TTY mode setting */


___HIDDEN ___SCMOBJ ___device_tty_mode_get
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

#ifdef USE_POSIX

  int fd = d->fd;

  if (fd < 0)
    return ___FIX(___NO_ERR);

#else

#if defined(USE_tcgetsetattr) || defined(USE_fcntl)

  int fd = 0; /* fileno(___stdin) */

#endif

#endif

#ifdef USE_tcgetsetattr

#ifdef ___DEBUG_TTY

  ___printf ("tcgetattr  fd = %d\n", fd);

#endif

  if (tcgetattr (fd, &d->initial_termios) < 0)
    return err_code_from_errno ();

#ifdef ___DEBUG_TTY

  ___printf ("___device_tty_mode_get  fd = %d\n", fd);
  ___printf ("  d->initial_termios.c_iflag = 0x%08x\n", d->initial_termios.c_iflag);
  ___printf ("  d->initial_termios.c_oflag = 0x%08x\n", d->initial_termios.c_oflag);
  ___printf ("  d->initial_termios.c_lflag = 0x%08x\n", d->initial_termios.c_lflag);

#endif

#endif

#ifdef USE_fcntl

  if ((d->initial_flags = fcntl (fd, F_GETFL, 0)) < 0)
    return err_code_from_errno ();

#endif

#ifdef USE_WIN32

  if (!GetConsoleMode (d->hin, &d->hin_initial_mode) ||
      !GetConsoleMode (d->hout, &d->hout_initial_mode) ||
      !GetConsoleScreenBufferInfo (d->hout, &d->hout_initial_info))
    return err_code_from_GetLastError ();

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_mode_save
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;

  if ((e = ___device_tty_mode_get (d)) != ___FIX(___NO_ERR))
    return e;

  d->mode_save_stack_next = ___tty_mod.mode_save_stack;
  ___tty_mod.mode_save_stack = d;

  d->stage = TTY_STAGE_MODE_NOT_SET;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_mode_update
   ___P((___device_tty *self,
         ___BOOL undo),
        (self,
         undo)
___device_tty *self;
___BOOL undo;)
{
  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

#ifdef USE_POSIX

  int fd = d->fd;

  if (fd < 0)
    return ___FIX(___NO_ERR);

#else

#if defined(USE_tcgetsetattr) || defined(USE_fcntl)

  int fd = 0; /* fileno(___stdin) */

#endif

#endif

#ifdef USE_tcgetsetattr

  {
    struct termios new_termios = d->initial_termios;

#ifdef ___DEBUG_TTY

    ___printf ("tcsetattr  fd = %d\n", fd);
    ___printf ("  d->lineeditor_mode = %d\n", d->lineeditor_mode);
    ___printf ("  d->input_allow_special = %d\n", d->input_allow_special);
    ___printf ("  d->input_echo = %d\n", d->input_echo);
    ___printf ("  d->input_raw = %d\n", d->input_raw);
    ___printf ("  d->output_raw = %d\n", d->output_raw);
    ___printf ("  new_termios.c_iflag = 0x%08x\n", new_termios.c_iflag);
    ___printf ("  new_termios.c_oflag = 0x%08x\n", new_termios.c_oflag);
    ___printf ("  new_termios.c_lflag = 0x%08x\n", new_termios.c_lflag);

#endif

    if (!undo)
      {
        if (d->input_allow_special)
          {
            new_termios.c_iflag |= (IXON);
            new_termios.c_lflag |= (IEXTEN | ISIG);
          }
        else
          {
            new_termios.c_iflag &= ~(IXON);
            new_termios.c_lflag &= ~(IEXTEN | ISIG);
          }

        if (d->input_raw
#ifdef USE_LINEEDITOR
            || d->lineeditor_mode != LINEEDITOR_MODE_DISABLE
#endif
            )
          {
            new_termios.c_iflag &= ~(IMAXBEL
                                     | ISTRIP
                                     | ICRNL
                                     | INLCR
                                     | IGNCR
                                     | IXON
                                     | IXOFF
#ifdef IUCLC
                                     | IUCLC
#endif
                                     );
            new_termios.c_lflag &= ~(ICANON | ECHO | ECHOCTL);

#ifndef _POSIX_VDISABLE
#define _POSIX_VDISABLE 0xff
#endif

#if 0
            new_termios.c_cc[VEOF]     = _POSIX_VDISABLE;
            new_termios.c_cc[VEOL]     = _POSIX_VDISABLE;
            new_termios.c_cc[VEOL2]    = _POSIX_VDISABLE;
            new_termios.c_cc[VERASE]   = _POSIX_VDISABLE;
            new_termios.c_cc[VWERASE]  = _POSIX_VDISABLE;
            new_termios.c_cc[VKILL]    = _POSIX_VDISABLE;
            new_termios.c_cc[VREPRINT] = _POSIX_VDISABLE;
            new_termios.c_cc[VINTR]    = _POSIX_VDISABLE;
            new_termios.c_cc[VQUIT]    = _POSIX_VDISABLE;
            new_termios.c_cc[VSUSP]    = _POSIX_VDISABLE;
#endif
#ifdef VDSUSP
            new_termios.c_cc[VDSUSP]   = _POSIX_VDISABLE;
#endif
#if 0
            new_termios.c_cc[VSTART]   = _POSIX_VDISABLE;
            new_termios.c_cc[VSTOP]    = _POSIX_VDISABLE;
#endif
#ifdef VLNEXT
            new_termios.c_cc[VLNEXT]   = _POSIX_VDISABLE;
#endif
#if 0
            new_termios.c_cc[VDISCARD] = _POSIX_VDISABLE;
            new_termios.c_cc[VMIN]     = _POSIX_VDISABLE;
            new_termios.c_cc[VTIME]    = _POSIX_VDISABLE;
            new_termios.c_cc[VSTATUS]  = _POSIX_VDISABLE;
#endif

#ifdef USE_POSIX
            new_termios.c_cc[VMIN]     = 1; /* wait for first char then */
            new_termios.c_cc[VTIME]    = 0; /* return it if no other avail */
#else
            new_termios.c_cc[VMIN]     = 0; /* wait up to 1/10 of a second */
            new_termios.c_cc[VTIME]    = 1; /* for a character */
#endif
          }
        else
          {
            new_termios.c_iflag |= (ICRNL);
            new_termios.c_lflag |= (ICANON | ECHO | ECHOCTL);
          }

        if (!d->input_echo)
          new_termios.c_lflag &= ~(ECHO | ECHOCTL);

        if (d->output_raw)
          new_termios.c_oflag &= ~(OPOST | ONLCR);
        else
          new_termios.c_oflag |= (OPOST);

        new_termios.c_iflag |= (IGNBRK | IGNPAR);

        new_termios.c_cflag &= ~(CSIZE | PARENB);

        new_termios.c_cflag |= (CS8 | CLOCAL | CREAD);

        if (d->speed != 0)
          {
            int speed_code = -1;

            switch (d->speed)
              {
#ifdef B50
              case 50: speed_code = B50; break;
#endif
#ifdef B75
              case 75: speed_code = B75; break;
#endif
#ifdef B110
              case 110: speed_code = B110; break;
#endif
#ifdef B134
              case 134: speed_code = B134; break;
#endif
#ifdef B150
              case 150: speed_code = B150; break;
#endif
#ifdef B200
              case 200: speed_code = B200; break;
#endif
#ifdef B300
              case 300: speed_code = B300; break;
#endif
#ifdef B600
              case 600: speed_code = B600; break;
#endif
#ifdef B1200
              case 1200: speed_code = B1200; break;
#endif
#ifdef B1800
              case 1800: speed_code = B1800; break;
#endif
#ifdef B2400
              case 2400: speed_code = B2400; break;
#endif
#ifdef B4800
              case 4800: speed_code = B4800; break;
#endif
#ifdef B9600
              case 9600: speed_code = B9600; break;
#endif
#ifdef B19200
              case 19200: speed_code = B19200; break;
#endif
#ifdef B38400
              case 38400: speed_code = B38400; break;
#endif
#ifdef B57600
              case 57600: speed_code = B57600; break;
#endif
#ifdef B115200
              case 115200: speed_code = B115200; break;
#endif
#ifdef B230400
              case 230400: speed_code = B230400; break;
#endif
#ifdef B460800
              case 460800: speed_code = B460800; break;
#endif
#ifdef B500000
              case 500000: speed_code = B500000; break;
#endif
#ifdef B576000
              case 576000: speed_code = B576000; break;
#endif
#ifdef B921600
              case 921600: speed_code = B921600; break;
#endif
#ifdef B1000000
              case 1000000: speed_code = B1000000; break;
#endif
#ifdef B1152000
              case 1152000: speed_code = B1152000; break;
#endif
#ifdef B1500000
              case 1500000: speed_code = B1500000; break;
#endif
#ifdef B2000000
              case 2000000: speed_code = B2000000; break;
#endif
#ifdef B2500000
              case 2500000: speed_code = B2500000; break;
#endif
#ifdef B3000000
              case 3000000: speed_code = B3000000; break;
#endif
#ifdef B3500000
              case 3500000: speed_code = B3500000; break;
#endif
#ifdef B4000000
              case 4000000: speed_code = B4000000; break;
#endif
              }

            if (speed_code != -1)
              {
                cfsetispeed (&new_termios, speed_code);
                cfsetospeed (&new_termios, speed_code);
              }
          }
      }

#ifdef ___DEBUG_TTY

    ___printf ("  new_termios.c_iflag = 0x%08x\n", new_termios.c_iflag);
    ___printf ("  new_termios.c_oflag = 0x%08x\n", new_termios.c_oflag);
    ___printf ("  new_termios.c_lflag = 0x%08x\n", new_termios.c_lflag);

#endif

    if (tcsetattr (fd, TCSANOW, &new_termios) < 0)
      e = err_code_from_errno ();
  }

#endif

#ifdef USE_fcntl
  {
    int new_flags = d->initial_flags;

    if (!undo)
      {
        new_flags = new_flags | O_NONBLOCK;
      }

    if (fcntl (fd, F_SETFL, new_flags) < 0)
      e = err_code_from_errno ();
  }

#endif

#ifdef USE_WIN32

  {
    DWORD hin_mode = d->hin_initial_mode;
    DWORD hout_mode = d->hout_initial_mode;

    if (!undo)
      {
        if (d->input_allow_special)
          hin_mode |= (ENABLE_PROCESSED_INPUT);
        else
          hin_mode &= ~(ENABLE_PROCESSED_INPUT);

#ifndef USE_LINEEDITOR
        if (!d->input_raw)
          hin_mode |= (ENABLE_LINE_INPUT | ENABLE_ECHO_INPUT);
        else
#endif
          hin_mode &= ~(ENABLE_LINE_INPUT | ENABLE_ECHO_INPUT);

#if 0
#ifndef USE_LINEEDITOR
        if (!d->output_raw)
          hout_mode |= (ENABLE_PROCESSED_OUTPUT);
        else
#endif
          hout_mode &= ~(ENABLE_PROCESSED_OUTPUT);
#endif

        hout_mode |= (ENABLE_WRAP_AT_EOL_OUTPUT | ENABLE_PROCESSED_OUTPUT);

        hin_mode |= (ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT);
      }

    if (!SetConsoleMode (d->hin, hin_mode) ||
        !SetConsoleMode (d->hout, hout_mode))
      e = err_code_from_GetLastError ();
  }

#endif

  return e;
}


___HIDDEN ___SCMOBJ ___device_tty_mode_restore
   ___P((___device_tty *self,
         ___BOOL remove),
        (self,
         remove)
___device_tty *self;
___BOOL remove;)
{
  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);
  ___device_tty *curr = ___tty_mod.mode_save_stack;
  ___device_tty *prev = NULL;
  ___device_tty *next;

  while (curr != d)
    {
      if ((e = ___device_tty_mode_update (curr, 1)) != ___FIX(___NO_ERR))
        break;
      if (d == NULL)
        curr->stage = TTY_STAGE_MODE_NOT_SAVED;
      next = curr->mode_save_stack_next;
      curr->mode_save_stack_next = prev;
      prev = curr;
      curr = next;
    }

  if (e == ___FIX(___NO_ERR) &&
      d == NULL &&
      remove)
    {
      ___tty_mod.mode_save_stack = NULL; /* save stack has been emptied */
    }
  else
    {
      if (e == ___FIX(___NO_ERR) &&
          curr != NULL &&
          (e = ___device_tty_mode_update (curr, remove)) == ___FIX(___NO_ERR))
        {
          curr->stage = TTY_STAGE_MODE_NOT_SAVED;
          if (remove)
            curr = curr->mode_save_stack_next; /* remove d from mode save stack */
        }

      while (prev != NULL)
        {
          ___SCMOBJ e2;
          next = curr;
          curr = prev;
          prev = prev->mode_save_stack_next;
          curr->mode_save_stack_next = next;
          if ((e2 = ___device_tty_mode_get (curr)) != ___FIX(___NO_ERR) ||
              (e2 = ___device_tty_mode_update (curr, 0)) != ___FIX(___NO_ERR))
            {
              if (e == ___FIX(___NO_ERR))
                e = e2;
            }
        }
    }

  ___tty_mod.mode_save_stack = curr;

  return e;
}


___HIDDEN ___SCMOBJ ___device_tty_mode_set
   ___P((___device_tty *self,
         ___BOOL input_allow_special,
         ___BOOL input_echo,
         ___BOOL input_raw,
         ___BOOL output_raw,
         int speed),
        (self,
         input_allow_special,
         input_echo,
         input_raw,
         output_raw,
         speed)
___device_tty *self;
___BOOL input_allow_special;
___BOOL input_echo;
___BOOL input_raw;
___BOOL output_raw;
int speed;)
{
  ___device_tty *d = self;

  /**************** TODO: begin critical section (must block SIGCONT) */
  d->input_allow_special = input_allow_special;
  d->input_echo = input_echo;
  d->input_raw = input_raw;
  d->output_raw = output_raw;
  d->speed = speed;
  /**************** TODO: end critical section (must block SIGCONT) */

  return ___device_tty_mode_restore (d, 1);
}


___HIDDEN ___SCMOBJ ___device_tty_update_size
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  if (d->size_needs_update)
    {
      int prev_line_start_col = d->current.line_start % d->terminal_nb_cols;
      int prev_line_start_row = d->current.line_start / d->terminal_nb_cols;

#ifdef USE_POSIX

#ifdef USE_ioctl
#ifdef TIOCGWINSZ

      struct winsize size;

      if (d->fd < 0)
        {
          d->terminal_nb_cols = TERMINAL_NB_COLS_UNLIMITED;
          d->terminal_nb_rows = 24;
        }
      else
        {
          if (ioctl (d->fd, TIOCGWINSZ, &size) < 0)
            return err_code_from_errno ();

          if (size.ws_col > 0)
            d->terminal_nb_cols = size.ws_col;

          if (size.ws_row > 0)
            d->terminal_nb_rows = size.ws_row;
        }

#endif
#endif

#endif

#ifdef USE_WIN32

      CONSOLE_SCREEN_BUFFER_INFO info;

      if (!GetConsoleScreenBufferInfo (self->hout, &info))
        return err_code_from_GetLastError ();

      d->terminal_nb_cols = info.dwSize.X;
      d->terminal_nb_rows = info.dwSize.Y;

#endif

      d->terminal_size =
        d->terminal_nb_rows * d->terminal_nb_cols;

      d->terminal_cursor =
        d->terminal_row * d->terminal_nb_cols + d->terminal_col;

      d->current.line_start =
        prev_line_start_row * d->terminal_nb_cols + prev_line_start_col;

      d->terminal_delayed_wrap = 0;

      d->size_needs_update = 0;
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___BOOL env_var_defined_UCS_2
   ___P((___UCS_2 *name),
        (name)
___UCS_2 *name;)
{
  ___UCS_2STRING cvalue;

  if (___getenv_UCS_2 (name, &cvalue) == ___FIX(___NO_ERR))
    {
      if (cvalue != 0)
        {
          ___FREE_MEM(cvalue);
          return 1;
        }
    }

  return 0;
}


___HIDDEN ___BOOL lineeditor_under_emacs ___PVOID
{
#ifdef USE_OLD_INSIDE_EMACS_DETECTION
  {
    static ___UCS_2 emacs_env_name_old[] = { 'E', 'M', 'A', 'C', 'S', '\0' };
    if (env_var_defined_UCS_2 (emacs_env_name_old)) return 1;
  }
#endif

  {
    static ___UCS_2 emacs_env_name_new[] = { 'I', 'N', 'S', 'I', 'D', 'E', '_', 'E', 'M', 'A', 'C', 'S', '\0' };
    if (env_var_defined_UCS_2 (emacs_env_name_new)) return 1;
  }

  return 0;
}


#ifdef USE_WIN32

#if 0
#ifdef USE_GetConsoleWindow

___BEGIN_C_LINKAGE
HWND WINAPI GetConsoleWindow (void);
___END_C_LINKAGE

#endif
#endif

___HIDDEN BOOL WINAPI console_event_handler
   ___P((DWORD dwCtrlType),
        ());

#endif


/* forward declaration */

___HIDDEN ___SCMOBJ lineeditor_redraw
   ___P((___device_tty *self),
        ());


___HIDDEN ___SCMOBJ ___device_tty_force_open
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  switch (d->stage)
    {
    case TTY_STAGE_NOT_OPENED:
    case TTY_STAGE_OPENED_FRESH:
      {
#ifdef USE_POSIX

        int fd;

#ifndef HAVE_ctermid
        char* term_name = "/dev/tty";
#else
        char term_name[L_ctermid];
        ctermid (term_name); /* get controlling terminal's name */
#endif

        if ((fd = open_long_path (term_name,
#ifdef LINEEDITOR_WITH_NONBLOCKING_IO
                                  O_NONBLOCK |
#endif
#ifdef O_BINARY
                                  O_BINARY |
#endif
                                  O_RDWR,
                                  0))
            < 0)
          {
#ifdef ENXIO
            if (errno == ENXIO)
              {
                /*
                 * There is no controlling terminal, so console output
                 * has to be redirected.  This is done by calling
                 * ___write_console_fallback which will send the output
                 * to stderr, a log file, etc.
                 */

                static char msg[] =
                  "*** No controlling terminal (try using the -:d- runtime option)\n";

                ___write_console_fallback (msg, sizeof(msg)-1);

                fd = -1; /* redirect subsequent console output */
              }
            else
#endif
            return fnf_or_err_code_from_errno ();
          }

        d->fd = fd;

#endif

#ifdef USE_WIN32

        DWORD m;
        HANDLE in;
        HANDLE out;
        HANDLE sin = GetStdHandle (STD_INPUT_HANDLE); /* ignore error */
        HANDLE sout = GetStdHandle (STD_OUTPUT_HANDLE); /* ignore error */
        HANDLE serr = GetStdHandle (STD_ERROR_HANDLE); /* ignore error */


        if (d->stage == TTY_STAGE_NOT_OPENED) {

#ifdef USE_GetConsoleWindow

          HWND cons_wind = GetConsoleWindow ();
          if (cons_wind == NULL || !IsWindowVisible (cons_wind))
            FreeConsole ();

#endif

          if (AllocConsole ())
            {
              /* restore initial standard handles */

              SetConsoleCtrlHandler (console_event_handler, TRUE); /* ignore error */
              SetStdHandle (STD_INPUT_HANDLE, sin); /* ignore error */
              SetStdHandle (STD_OUTPUT_HANDLE, sout); /* ignore error */
              SetStdHandle (STD_ERROR_HANDLE, serr); /* ignore error */
            }

        }

        in = CreateFile
               (_T("CONIN$"),
                GENERIC_READ | GENERIC_WRITE,
                FILE_SHARE_READ | FILE_SHARE_WRITE,
                NULL,
                OPEN_EXISTING,
                0,
                NULL);

        if (in == INVALID_HANDLE_VALUE)
          return fnf_or_err_code_from_GetLastError ();

        out = CreateFile
                (_T("CONOUT$"),
                 GENERIC_READ | GENERIC_WRITE,
                 FILE_SHARE_READ | FILE_SHARE_WRITE,
                 NULL,
                 OPEN_EXISTING,
                 0,
                 NULL);

        if (out == INVALID_HANDLE_VALUE)
          {
            ___SCMOBJ e = fnf_or_err_code_from_GetLastError ();
            CloseHandle (in); /* ignore error */
            return e;
          }

        d->hin = in;
        d->hout = out;

#endif

        d->stage = TTY_STAGE_MODE_NOT_SAVED;

        /* fall through */
      }

    case TTY_STAGE_MODE_NOT_SAVED:
      {
        ___SCMOBJ e;

        if ((e = ___device_tty_mode_save (d)) != ___FIX(___NO_ERR))
          return e;

        /* fall through */
      }

    case TTY_STAGE_MODE_NOT_SET:
      {
        ___SCMOBJ e;

        if ((e = ___device_tty_mode_restore (d, 0))
            != ___FIX(___NO_ERR))
          return e;

        d->stage = TTY_STAGE_INIT_DONE;
      }
    }

  if (d->size_needs_update)
    {
      ___SCMOBJ e;
      int prev_nb_cols = d->terminal_nb_cols;

      if ((e = ___device_tty_update_size (d)) != ___FIX(___NO_ERR))
        return e;

      if (d->editing_line && prev_nb_cols != d->terminal_nb_cols)
        if ((e = lineeditor_redraw (d)) != ___FIX(___NO_ERR))
          return e;
    }

  return ___FIX(___NO_ERR);
}


#ifdef USE_WIN32

___HIDDEN void show_cursor
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;
  CONSOLE_SCREEN_BUFFER_INFO info;

  if (GetConsoleScreenBufferInfo (d->hout, &info))
    SetConsoleCursorPosition
      (d->hout,
       info.dwCursorPosition); /* ignore error */
}

#endif


___HIDDEN ___SCMOBJ ___device_tty_write
   ___P((___device_tty *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (self,
         buf,
         len,
         len_done)
___device_tty *self;
___U8 *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___device_tty *d = self;

#ifndef USE_POSIX
#ifndef USE_WIN32

  {
    int n;

    if ((n = ___fwrite (buf, 1, len, ___stdout)) != len)
      {
        ___clearerr (___stdout);
        return ___FIX(___UNKNOWN_ERR);
      }

    ___fflush (___stdout);

    *len_done = n;
  }

#endif
#endif

#ifdef USE_POSIX

  {
    int n;

    if (d->fd < 0)
      n = ___write_console_fallback (buf, len);
    else if ((n = write (d->fd, buf, len)) < 0)
      return err_code_from_errno ();

    *len_done = n;
  }

#endif

#ifdef USE_WIN32

  {
    DWORD n;
    int len_in_chars = TTY_CHAR_SELECT(len,len>>1); /* convert bytes to chars */

    if (len_in_chars < 1)
      return ___FIX(___UNKNOWN_ERR);

    if (!TTY_CHAR_SELECT(WriteConsoleA (d->hout, buf, len_in_chars, &n, NULL),
                         WriteConsoleW (d->hout, buf, len_in_chars, &n, NULL)))
      return err_code_from_GetLastError ();

    show_cursor (d);

    *len_done = TTY_CHAR_SELECT(n,n<<1); /* convert chars to bytes */
  }

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_write_raw_no_lineeditor
   ___P((___device_tty *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (self,
         buf,
         len,
         len_done)
___device_tty *self;
___U8 *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___device_tty *d = self;

  if (d->base.base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  return ___device_tty_write (d, buf, len, len_done);
}


___HIDDEN ___SCMOBJ ___device_tty_read_raw_no_lineeditor
   ___P((___device_tty *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (self,
         buf,
         len,
         len_done)
___device_tty *self;
___U8 *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___device_tty *d = self;

  if (d->base.base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

#ifndef USE_POSIX
#ifndef USE_WIN32

  {
    int n;

#ifdef ___DEBUG_TTY
    ___printf ("read len=%d\n", len);
#endif

    if ((n = ___fread (buf, 1, len, ___stdin)) == 0)
      {
        /*
         * The TTY is set with a VMIN=0 and VTIME=1 so it will
         * return n=0 when no key has been pressed, so don't
         * treat this as an end of file.
         */
        ___clearerr (___stdin);
        return ___ERR_CODE_EAGAIN;
      }

#ifdef ___DEBUG_TTY
    ___printf ("read n=%d\n", n);
#endif

    *len_done = n;
  }

#endif
#endif

#ifdef USE_POSIX

  {
    int n;

#ifdef ___DEBUG_TTY
    ___printf ("read len=%d\n", len);
#endif

    if (d->fd < 0)
      n = 0;
    else if ((n = read (d->fd, buf, len)) < 0)
      return err_code_from_errno ();

#ifdef ___DEBUG_TTY
    ___printf ("read n=%d\n", n);
#endif

    *len_done = n;
  }

#endif

#ifdef USE_WIN32

  {
    char *seq;
    int len_in_chars = TTY_CHAR_SELECT(len,len>>1); /* convert bytes to chars */

    if (len_in_chars < 1)
      return ___FIX(___UNKNOWN_ERR);

  next_chars:

    seq = d->key_seq;

    if (seq != NULL)
      {
        TTY_CHAR *tty_char_buf = ___CAST(TTY_CHAR*,buf);
        int i = 0;

        while (i < len_in_chars && *seq != '\0')
          {
            *tty_char_buf++ = *seq++;
            i++;
          }

        if (*seq == '\0')
          d->key_seq = NULL;
        else
          d->key_seq = seq;

        if (i > 0)
          {
            *len_done = TTY_CHAR_SELECT(i,i<<1); /* convert chars to bytes */
            return ___FIX(___NO_ERR);
          }
      }

    next_event:

      if (d->ir.EventType != KEY_EVENT ||
          d->ir.Event.KeyEvent.wRepeatCount <= 0)
        {
          DWORD avail;

          if (!GetNumberOfConsoleInputEvents (d->hin, &avail))
            return err_code_from_GetLastError ();

          if (avail <= 0)
            return ___ERR_CODE_EAGAIN;

          if (!TTY_CHAR_SELECT(ReadConsoleInputA (d->hin, &d->ir, 1, &avail),
                               ReadConsoleInputW (d->hin, &d->ir, 1, &avail)))
            return err_code_from_GetLastError ();

          if (avail <= 0)
            return ___ERR_CODE_EAGAIN;
        }

      switch (d->ir.EventType)
        {
        case KEY_EVENT:
          {
            DWORD ctrl_keys;
            ___BOOL ctrl;
            ___BOOL alt;
            ___BOOL shift;
            char *seq;
            TTY_CHAR c;

            if (!(d->ir.Event.KeyEvent.bKeyDown &&
                  d->ir.Event.KeyEvent.wRepeatCount > 0))
              {
                d->ir.EventType = MOUSE_EVENT; /* anything but KEY_EVENT */
                goto next_event;
              }

            ctrl_keys = d->ir.Event.KeyEvent.dwControlKeyState;
            ctrl = ctrl_keys & (LEFT_CTRL_PRESSED | RIGHT_CTRL_PRESSED);
            alt = ctrl_keys & (LEFT_ALT_PRESSED | RIGHT_ALT_PRESSED);
            shift = ctrl_keys & SHIFT_PRESSED;

            c = TTY_CHAR_SELECT(d->ir.Event.KeyEvent.uChar.AsciiChar,
                                d->ir.Event.KeyEvent.uChar.UnicodeChar);

            seq = NULL;

            if (!ctrl && alt && !shift && c>='a' && c<='z')
              {
                static char alt_seq[3];
                alt_seq[0] = ___UNICODE_ESCAPE;
                alt_seq[1] = c;
                alt_seq[2] = '\0';
                seq = alt_seq;
              }
            else if (!ctrl && !alt && !shift && c == 0)
              switch (d->ir.Event.KeyEvent.wVirtualKeyCode)
                {
                case VK_BACK:   seq = "\010";     break;
                case VK_UP:     seq = "\033[A";   break;
                case VK_DOWN:   seq = "\033[B";   break;
                case VK_RIGHT:  seq = "\033[C";   break;
                case VK_LEFT:   seq = "\033[D";   break;
                case VK_HOME:   seq = "\033[H";   break;
                case VK_INSERT: seq = "\033[2~";  break;
                case VK_DELETE: seq = "\177";     break;
                case VK_END:    seq = "\033[F";   break;
                case VK_PRIOR:  seq = "\033[5~";  break;
                case VK_NEXT:   seq = "\033[6~";  break;
                case VK_F1:     seq = "\033OP";   break;
                case VK_F2:     seq = "\033OQ";   break;
                case VK_F3:     seq = "\033OR";   break;
                case VK_F4:     seq = "\033OS";   break;
                case VK_F5:     seq = "\033[15~"; break;
                case VK_F6:     seq = "\033[17~"; break;
                case VK_F7:     seq = "\033[18~"; break;
                case VK_F8:     seq = "\033[19~"; break;
                case VK_F9:     seq = "\033[20~"; break;
                case VK_F10:    seq = "\033[21~"; break;
                case VK_F11:    seq = "\033[23~"; break;
                case VK_F12:    seq = "\033[24~"; break;
                }

            if (seq == NULL)
              {
                if (c == 0)
                  {
                    d->ir.EventType = MOUSE_EVENT; /* anything but KEY_EVENT */
                    goto next_event;
                  }

                if (ctrl && c == ' ') /* ctrl-space => NUL character */
                  c = '\0';

                TTY_CHAR_SELECT(
                                buf[0] = c & 0xff;
                                *len_done = 1;
                                ,
                                buf[0] = c & 0xff;
                                buf[1] = c >> 8;
                                *len_done = 2;
                                )

                d->ir.Event.KeyEvent.wRepeatCount--;

                return ___FIX(___NO_ERR);
              }
            else
              {
                d->key_seq = seq;
                d->ir.Event.KeyEvent.wRepeatCount--;
                goto next_chars;
              }

            break;
          }

        case MOUSE_EVENT:
          {
#if 0
            /*************************/
            COORD c = d->ir.Event.MouseEvent.dwMousePosition;
            CONSOLE_SCREEN_BUFFER_INFO info;
            COORD pos;

            printf ("m.X=%d m.Y=%d\n",c.X,c.Y);
            if (GetConsoleScreenBufferInfo (d->hout, &info))
              {
                printf ("  dwSize.X=%d dwSize.Y=%d\n",info.dwSize.X,info.dwSize.Y);
                printf ("  dwCursorPosition.X=%d dwCursorPosition.Y=%d\n",info.dwCursorPosition.X,info.dwCursorPosition.Y);
                printf ("  dwMaximumWindowSize.X=%d dwMaximumWindowSize.Y=%d\n",info.dwMaximumWindowSize.X,info.dwMaximumWindowSize.Y);
                printf ("  srWindow.Left=%d srWindow.Top=%d\n",info.srWindow.Left,info.srWindow.Top);
                printf ("  srWindow.Right=%d srWindow.Bottom=%d\n",info.srWindow.Right,info.srWindow.Bottom);
                fflush(stdout);
              }

            ___WORD e;

            if (i > 0)
              goto done; /* in case paste returns an error */

            state->input_rlo++;

            if (d->ir.Event.MouseEvent.dwEventFlags == 0 &&
                (d->ir.Event.MouseEvent.dwButtonState ==
                 (FROM_LEFT_1ST_BUTTON_PRESSED | RIGHTMOST_BUTTON_PRESSED) ||
                 d->ir.Event.MouseEvent.dwButtonState ==
                 FROM_LEFT_2ND_BUTTON_PRESSED))
              if ((e = lineeditor_paste_from_clipboard (state->les))
                  != ___FIX(___NO_ERR))
                return e;

            goto done; /* pasted text is available to be read */
#endif
            goto next_event;
          }

        case WINDOW_BUFFER_SIZE_EVENT:
          {
            d->size_needs_update = 1;
#if 0
            COORD c = d->ir.Event.WindowBufferSizeEvent.dwSize;
            printf ("c.X=%d c.Y=%d\n", c.X, c.Y);fflush(stdout);/********************/
#endif
            goto next_event;
          }

        default:
          goto next_event;
        }
    }

#endif

  return ___FIX(___NO_ERR);
}


/*****************************************************************************/

/* Line editing subsystem */


#ifdef USE_LINEEDITOR


/*---------------------------------------------------------------------------*/

/* Line editing input decoder routines */


___HIDDEN ___SCMOBJ lineeditor_input_decoder_setup
   ___P((lineeditor_input_decoder *decoder),
        (decoder)
lineeditor_input_decoder *decoder;)
{
#define LINEEDITOR_INPUT_DECODER_INITIAL_BUFFER_SIZE 150

  int n = LINEEDITOR_INPUT_DECODER_INITIAL_BUFFER_SIZE;

  decoder->buffer = ___CAST(lineeditor_input_test*,
                            ___ALLOC_MEM(n * sizeof (lineeditor_input_test)));

  if (decoder->buffer == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  decoder->length = 0;
  decoder->max_length = n;

  return ___FIX(___NO_ERR);
}


___HIDDEN void lineeditor_input_decoder_cleanup
   ___P((lineeditor_input_decoder *decoder),
        (decoder)
lineeditor_input_decoder *decoder;)
{
  ___FREE_MEM(decoder->buffer);
}


___HIDDEN ___SCMOBJ lineeditor_input_decoder_set_length
   ___P((lineeditor_input_decoder *decoder,
         int len,
         int fudge),
        (decoder,
         len,
         fudge)
lineeditor_input_decoder *decoder;
int len;
int fudge;)
{
  if (len > LINEEDITOR_INPUT_DECODER_MAX_LENGTH)
    return ___FIX(___UNKNOWN_ERR);

  if (len > decoder->max_length)
    {
      int i;
      int new_max_length = (fudge<0) ? 3*len/2+1 : len+fudge;
      lineeditor_input_test *old_buffer = decoder->buffer;
      lineeditor_input_test *new_buffer =
        ___CAST(lineeditor_input_test*,
                ___ALLOC_MEM(new_max_length *
                             sizeof (lineeditor_input_test)));

      if (new_buffer == NULL)
        return ___FIX(___HEAP_OVERFLOW_ERR);

      i = decoder->length;
      if (i > len)
        i = len;

      while (i-- > 0)
        new_buffer[i] = old_buffer[i];

      ___FREE_MEM(old_buffer);
      decoder->buffer = new_buffer;
      decoder->max_length = new_max_length;
    }

  decoder->length = len;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_input_decoder_add
   ___P((lineeditor_input_decoder *decoder,
         char *seq,
         ___U8 event),
        (decoder,
         seq,
         event)
lineeditor_input_decoder *decoder;
char *seq;
___U8 event;)
{
  ___SCMOBJ e;
  ___U8 b;
  int i = 0;
  char *p = seq;

  if (event & WITH_ESC_PREFIX)
    b = ___UNICODE_ESCAPE;
  else
    b = ___CAST_U8(*p++);

  if (decoder->length > 0)
    {
      while (b != ___CAST_U8('\0') || p == seq+1)
        {
          if (decoder->buffer[i].trigger == b)
            {
              int a = decoder->buffer[i].action;
              if (a >= decoder->length)
                return ___FIX(___NO_ERR); /* prefix of sequence exists */
              i = a;
              b = ___CAST_U8(*p++);
            }
          else
            {
              int n = decoder->buffer[i].next;
              if (n >= decoder->length)
                {
                  decoder->buffer[i].next = decoder->length;
                  break;
                }
              i = n;
            }
        }
    }

  if (b != ___CAST_U8('\0') || p == seq+1)
    {
      /* sequence is not a prefix of a preexisting sequence */

      while (b != ___CAST_U8('\0') || p == seq+1)
        {
          i = decoder->length;

          if ((e = lineeditor_input_decoder_set_length (decoder, i+1, -1))
              != ___FIX(___NO_ERR))
            return e;

          decoder->buffer[i].trigger = b;
          decoder->buffer[i].action = i+1;
          decoder->buffer[i].next = LINEEDITOR_INPUT_DECODER_STATE_MAX;

          b = ___CAST_U8(*p++);
        }
      decoder->buffer[i].action =
        LINEEDITOR_INPUT_DECODER_STATE_MAX-(event&~WITH_ESC_PREFIX);
    }

  return ___FIX(___NO_ERR);
}


typedef struct lineeditor_defseq_struct
  {
    char *seq;
    ___U8 event;
  } lineeditor_defseq;


___HIDDEN lineeditor_defseq lineeditor_defseq_common[] =
{
  /* sequences that all terminals support */

   { "\012",     LINEEDITOR_EV_RETURN                           }
  ,{ "\015",     LINEEDITOR_EV_RETURN                           }
  ,{ "\010",     LINEEDITOR_EV_BACK                             }
  ,{ "\010",     LINEEDITOR_EV_BACK_SEXPR     | WITH_ESC_PREFIX }
  ,{ "\011",     LINEEDITOR_EV_TAB                              }
};


___HIDDEN lineeditor_defseq lineeditor_defseq_map_rubout_to_backspace[] =
{
  /* sequences that map the rubout key to backspace */

   { "\177",     LINEEDITOR_EV_BACK                             }
  ,{ "\177",     LINEEDITOR_EV_BACK_WORD      | WITH_ESC_PREFIX }
};


___HIDDEN lineeditor_defseq lineeditor_defseq_emacs[] =
{
  /* sequences specific to emacs mode */

   { "\0",       LINEEDITOR_EV_MARK                              }
  ,{ "\031",     LINEEDITOR_EV_PASTE                             }
  ,{ "\027",     LINEEDITOR_EV_CUT                               }
  ,{ "\013",     LINEEDITOR_EV_CUT_RIGHT                         }
  ,{ "\025",     LINEEDITOR_EV_CUT_LEFT                          }
  ,{ "\014",     LINEEDITOR_EV_REFRESH                           }
  ,{ "\024",     LINEEDITOR_EV_TRANSPOSE                         }
  ,{ "\024",     LINEEDITOR_EV_TRANSPOSE_SEXPR | WITH_ESC_PREFIX }
  ,{ "t",        LINEEDITOR_EV_TRANSPOSE_WORD  | WITH_ESC_PREFIX }
  ,{ "T",        LINEEDITOR_EV_TRANSPOSE_WORD  | WITH_ESC_PREFIX }
  ,{ "p",        LINEEDITOR_EV_UP              | WITH_ESC_PREFIX }
  ,{ "P",        LINEEDITOR_EV_UP              | WITH_ESC_PREFIX }
  ,{ "n",        LINEEDITOR_EV_DOWN            | WITH_ESC_PREFIX }
  ,{ "N",        LINEEDITOR_EV_DOWN            | WITH_ESC_PREFIX }

  ,{ "\020",     LINEEDITOR_EV_UP                                }
  ,{ "\016",     LINEEDITOR_EV_DOWN                              }
  ,{ "\006",     LINEEDITOR_EV_RIGHT                             }
  ,{ "\002",     LINEEDITOR_EV_LEFT                              }
  ,{ "\006",     LINEEDITOR_EV_RIGHT_SEXPR     | WITH_ESC_PREFIX }
  ,{ "f",        LINEEDITOR_EV_RIGHT_WORD      | WITH_ESC_PREFIX }
  ,{ "F",        LINEEDITOR_EV_RIGHT_WORD      | WITH_ESC_PREFIX }
  ,{ "\002",     LINEEDITOR_EV_LEFT_SEXPR      | WITH_ESC_PREFIX }
  ,{ "b",        LINEEDITOR_EV_LEFT_WORD       | WITH_ESC_PREFIX }
  ,{ "B",        LINEEDITOR_EV_LEFT_WORD       | WITH_ESC_PREFIX }

  ,{ "\001",     LINEEDITOR_EV_HOME                              }
  ,{ "\004",     LINEEDITOR_EV_DELETE                            }
  ,{ "\005",     LINEEDITOR_EV_END                               }
  ,{ "\004",     LINEEDITOR_EV_DELETE_SEXPR    | WITH_ESC_PREFIX }
  ,{ "d",        LINEEDITOR_EV_DELETE_WORD     | WITH_ESC_PREFIX }
  ,{ "D",        LINEEDITOR_EV_DELETE_WORD     | WITH_ESC_PREFIX }
};


___HIDDEN lineeditor_defseq lineeditor_defseq_widespread[] =
{
  /* sequences that many types of terminals support */

   { "[A",       LINEEDITOR_EV_UP             | WITH_ESC_PREFIX }
  ,{ "[B",       LINEEDITOR_EV_DOWN           | WITH_ESC_PREFIX }
  ,{ "[C",       LINEEDITOR_EV_RIGHT          | WITH_ESC_PREFIX }
  ,{ "[D",       LINEEDITOR_EV_LEFT           | WITH_ESC_PREFIX }

  ,{ "\033[A",   LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033[B",   LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033[C",   LINEEDITOR_EV_RIGHT_SEXPR    | WITH_ESC_PREFIX }
  ,{ "\033[D",   LINEEDITOR_EV_LEFT_SEXPR     | WITH_ESC_PREFIX }

  ,{ "OA",       LINEEDITOR_EV_UP             | WITH_ESC_PREFIX }
  ,{ "OB",       LINEEDITOR_EV_DOWN           | WITH_ESC_PREFIX }
  ,{ "OC",       LINEEDITOR_EV_RIGHT          | WITH_ESC_PREFIX }
  ,{ "OD",       LINEEDITOR_EV_LEFT           | WITH_ESC_PREFIX }

  ,{ "\033OA",   LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033OB",   LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033OC",   LINEEDITOR_EV_RIGHT_SEXPR    | WITH_ESC_PREFIX }
  ,{ "\033OD",   LINEEDITOR_EV_LEFT_SEXPR     | WITH_ESC_PREFIX }

  ,{ "A",        LINEEDITOR_EV_UP             | WITH_ESC_PREFIX }
  ,{ "B",        LINEEDITOR_EV_DOWN           | WITH_ESC_PREFIX }
  ,{ "C",        LINEEDITOR_EV_RIGHT          | WITH_ESC_PREFIX }
  ,{ "D",        LINEEDITOR_EV_LEFT           | WITH_ESC_PREFIX }

  ,{ "\033A",    LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033B",    LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033C",    LINEEDITOR_EV_RIGHT_SEXPR    | WITH_ESC_PREFIX }
  ,{ "\033D",    LINEEDITOR_EV_LEFT_SEXPR     | WITH_ESC_PREFIX }

#ifdef USE_XTERM_CTRL_COMBINATIONS
  ,{ "[5A",      LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "[5B",      LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "[5C",      LINEEDITOR_EV_RIGHT_SEXPR    | WITH_ESC_PREFIX }
  ,{ "[5D",      LINEEDITOR_EV_LEFT_SEXPR     | WITH_ESC_PREFIX }
#endif

  ,{ "[1~",      LINEEDITOR_EV_HOME           | WITH_ESC_PREFIX }
  ,{ "[2~",      LINEEDITOR_EV_INSERT         | WITH_ESC_PREFIX }
  ,{ "[3~",      LINEEDITOR_EV_DELETE         | WITH_ESC_PREFIX }
  ,{ "[4~",      LINEEDITOR_EV_END            | WITH_ESC_PREFIX }
  ,{ "[5~",      LINEEDITOR_EV_HOME_DOC       | WITH_ESC_PREFIX }
  ,{ "[6~",      LINEEDITOR_EV_END_DOC        | WITH_ESC_PREFIX }

  ,{ "\033[1~",  LINEEDITOR_EV_HOME_DOC       | WITH_ESC_PREFIX }
  ,{ "\033[2~",  LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033[3~",  LINEEDITOR_EV_DELETE_SEXPR   | WITH_ESC_PREFIX }
  ,{ "\033[4~",  LINEEDITOR_EV_END_DOC        | WITH_ESC_PREFIX }
  ,{ "\033[5~",  LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "\033[6~",  LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }

  ,{ "[H",       LINEEDITOR_EV_HOME           | WITH_ESC_PREFIX }
  ,{ "[L",       LINEEDITOR_EV_INSERT         | WITH_ESC_PREFIX }
  ,{ "[F",       LINEEDITOR_EV_END            | WITH_ESC_PREFIX }
  ,{ "\177",     LINEEDITOR_EV_DELETE                           }
  ,{ "\033[H",   LINEEDITOR_EV_HOME_DOC       | WITH_ESC_PREFIX }
  ,{ "\177",     LINEEDITOR_EV_DELETE_SEXPR   | WITH_ESC_PREFIX }
  ,{ "\033[F",   LINEEDITOR_EV_END_DOC        | WITH_ESC_PREFIX }

#ifdef USE_XTERM_CTRL_COMBINATIONS
  ,{ "[1;5~",    LINEEDITOR_EV_HOME_DOC       | WITH_ESC_PREFIX }
  ,{ "[2;5~",    LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "[3;5~",    LINEEDITOR_EV_DELETE_SEXPR   | WITH_ESC_PREFIX }
  ,{ "[4;5~",    LINEEDITOR_EV_END_DOC        | WITH_ESC_PREFIX }
  ,{ "[5;5~",    LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "[6;5~",    LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }

  ,{ "[5H",      LINEEDITOR_EV_HOME_DOC       | WITH_ESC_PREFIX }
  ,{ "[5L",      LINEEDITOR_EV_NONE           | WITH_ESC_PREFIX }
  ,{ "[5F",      LINEEDITOR_EV_END_DOC        | WITH_ESC_PREFIX }
#endif

  ,{ "OP",       LINEEDITOR_EV_F1             | WITH_ESC_PREFIX }
  ,{ "OQ",       LINEEDITOR_EV_F2             | WITH_ESC_PREFIX }
  ,{ "OR",       LINEEDITOR_EV_F3             | WITH_ESC_PREFIX }
  ,{ "OS",       LINEEDITOR_EV_F4             | WITH_ESC_PREFIX }

  ,{ "\033OP",   LINEEDITOR_EV_META_F1        | WITH_ESC_PREFIX }
  ,{ "\033OQ",   LINEEDITOR_EV_META_F2        | WITH_ESC_PREFIX }
  ,{ "\033OR",   LINEEDITOR_EV_META_F3        | WITH_ESC_PREFIX }
  ,{ "\033OS",   LINEEDITOR_EV_META_F4        | WITH_ESC_PREFIX }

#ifdef USE_XTERM_CTRL_COMBINATIONS
  ,{ "O5P",      LINEEDITOR_EV_META_F1        | WITH_ESC_PREFIX }
  ,{ "O5Q",      LINEEDITOR_EV_META_F2        | WITH_ESC_PREFIX }
  ,{ "O5R",      LINEEDITOR_EV_META_F3        | WITH_ESC_PREFIX }
  ,{ "O5S",      LINEEDITOR_EV_META_F4        | WITH_ESC_PREFIX }
#endif

  ,{ "[11~",     LINEEDITOR_EV_F1             | WITH_ESC_PREFIX }
  ,{ "[12~",     LINEEDITOR_EV_F2             | WITH_ESC_PREFIX }
  ,{ "[13~",     LINEEDITOR_EV_F3             | WITH_ESC_PREFIX }
  ,{ "[14~",     LINEEDITOR_EV_F4             | WITH_ESC_PREFIX }

  ,{ "\033[11~", LINEEDITOR_EV_META_F1        | WITH_ESC_PREFIX }
  ,{ "\033[12~", LINEEDITOR_EV_META_F2        | WITH_ESC_PREFIX }
  ,{ "\033[13~", LINEEDITOR_EV_META_F3        | WITH_ESC_PREFIX }
  ,{ "\033[14~", LINEEDITOR_EV_META_F4        | WITH_ESC_PREFIX }

#ifdef USE_XTERM_CTRL_COMBINATIONS
  ,{ "[11;5~",   LINEEDITOR_EV_META_F1        | WITH_ESC_PREFIX }
  ,{ "[12;5~",   LINEEDITOR_EV_META_F2        | WITH_ESC_PREFIX }
  ,{ "[13;5~",   LINEEDITOR_EV_META_F3        | WITH_ESC_PREFIX }
  ,{ "[14;5~",   LINEEDITOR_EV_META_F4        | WITH_ESC_PREFIX }
#endif

#ifdef LINEEDITOR_SUPPORT_F5_TO_F12

  ,{ "[15~",     LINEEDITOR_EV_F5             | WITH_ESC_PREFIX }
  ,{ "[17~",     LINEEDITOR_EV_F6             | WITH_ESC_PREFIX }
  ,{ "[18~",     LINEEDITOR_EV_F7             | WITH_ESC_PREFIX }
  ,{ "[19~",     LINEEDITOR_EV_F8             | WITH_ESC_PREFIX }
  ,{ "[20~",     LINEEDITOR_EV_F9             | WITH_ESC_PREFIX }
  ,{ "[21~",     LINEEDITOR_EV_F10            | WITH_ESC_PREFIX }
  ,{ "[23~",     LINEEDITOR_EV_F11            | WITH_ESC_PREFIX }
  ,{ "[24~",     LINEEDITOR_EV_F12            | WITH_ESC_PREFIX }

  ,{ "\033[15~", LINEEDITOR_EV_META_F5        | WITH_ESC_PREFIX }
  ,{ "\033[17~", LINEEDITOR_EV_META_F6        | WITH_ESC_PREFIX }
  ,{ "\033[18~", LINEEDITOR_EV_META_F7        | WITH_ESC_PREFIX }
  ,{ "\033[19~", LINEEDITOR_EV_META_F8        | WITH_ESC_PREFIX }
  ,{ "\033[20~", LINEEDITOR_EV_META_F9        | WITH_ESC_PREFIX }
  ,{ "\033[21~", LINEEDITOR_EV_META_F10       | WITH_ESC_PREFIX }
  ,{ "\033[23~", LINEEDITOR_EV_META_F11       | WITH_ESC_PREFIX }
  ,{ "\033[24~", LINEEDITOR_EV_META_F12       | WITH_ESC_PREFIX }

#ifdef USE_XTERM_CTRL_COMBINATIONS
  ,{ "[15;5~",   LINEEDITOR_EV_META_F5        | WITH_ESC_PREFIX }
  ,{ "[17;5~",   LINEEDITOR_EV_META_F6        | WITH_ESC_PREFIX }
  ,{ "[18;5~",   LINEEDITOR_EV_META_F7        | WITH_ESC_PREFIX }
  ,{ "[19;5~",   LINEEDITOR_EV_META_F8        | WITH_ESC_PREFIX }
  ,{ "[20;5~",   LINEEDITOR_EV_META_F9        | WITH_ESC_PREFIX }
  ,{ "[21;5~",   LINEEDITOR_EV_META_F10       | WITH_ESC_PREFIX }
  ,{ "[23;5~",   LINEEDITOR_EV_META_F11       | WITH_ESC_PREFIX }
  ,{ "[24;5~",   LINEEDITOR_EV_META_F12       | WITH_ESC_PREFIX }
#endif

#endif
};


___HIDDEN ___SCMOBJ lineeditor_defseq_install_table
   ___P((lineeditor_input_decoder *decoder,
         lineeditor_defseq *table,
         int len),
        (decoder,
         table,
         len)
lineeditor_input_decoder *decoder;
lineeditor_defseq *table;
int len;)
{
  ___SCMOBJ e;
  int i;

  for (i=0; i<len; i++)
    if ((e = lineeditor_input_decoder_add
               (decoder,
                table[i].seq,
                table[i].event))
        != ___FIX(___NO_ERR))
      return e;

  return ___FIX(___NO_ERR);
}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


#ifdef USE_CURSES


typedef struct lineeditor_dkey_struct
  {
    char *cap;
    ___U8 event_no_escape;
    ___U8 event_with_escape;
  } lineeditor_dkey;


#ifdef USE_TERMCAP

#define DKEY(tcap_name,tinfo_name,xterm_def,event_no_esc,event_with_esc) \
{ tcap_name, event_no_esc, event_with_esc | WITH_ESC_PREFIX }

#else

#ifdef USE_TERMINFO

#define DKEY(tcap_name,tinfo_name,xterm_def,event_no_esc,event_with_esc) \
{ tinfo_name, event_no_esc, event_with_esc | WITH_ESC_PREFIX }

#else

#define DKEY(tcap_name,tinfo_name,xterm_def,event_no_esc,event_with_esc) \
{ xterm_def, event_no_esc, event_with_esc | WITH_ESC_PREFIX }

#endif

#endif


typedef struct lineeditor_dcap_struct
  {
    char *cap;
#ifdef USE_TERMCAP_OR_TERMINFO
    char *xterm_cap;
#endif
  } lineeditor_dcap;


#ifdef USE_TERMCAP

#define DCAP(tcap_name,tinfo_name,xterm_def) { tcap_name, xterm_def }

#else

#ifdef USE_TERMINFO

#define DCAP(tcap_name,tinfo_name,xterm_def) { tinfo_name, xterm_def }

#else

#define DCAP(tcap_name,tinfo_name,xterm_def) { xterm_def }

#endif

#endif


___HIDDEN lineeditor_dcap lineeditor_dcap_table[LINEEDITOR_CAP_LAST+1] =
{
  /* order must match LINEEDITOR_CAP_XXX */

 DCAP("ho","home", "\033[H"             ) /* home cursor                  */
,DCAP("cl","clear","\033[H\033[J"       ) /* home cursor and clear screen */
,DCAP("up","cuu1", "\033[A"             ) /* move up one line             */
,DCAP("do","cud1", "\033[B"             ) /* move down one line           */
,DCAP("UP","cuu",  "\033[%p1%dA"        ) /* move up N lines              */
,DCAP("DO","cud",  "\033[%p1%dB"        ) /* move down N lines            */
,DCAP("RI","cuf",  "\033[%p1%dC"        ) /* move right N columns         */
,DCAP("LE","cub",  "\033[%p1%dD"        ) /* move left N columns          */
,DCAP("cm","cup",  "\033[%i%p1%d;%p2%dH") /* move cursor to (ROW,COL)     */
,DCAP("me","sgr0", "\033[m"             ) /* turn off all attributes      */
,DCAP("md","bold", "\033[1m"            ) /* turn on bold attribute       */
,DCAP("us","smul", "\033[4m"            ) /* turn on underline attribute  */
,DCAP("mr","rev",  "\033[7m"            ) /* turn on reverse attribute    */
,DCAP("AF","setaf","\033[3%p1%dm"       ) /* ANSI set foreground color    */
,DCAP("AB","setab","\033[4%p1%dm"       ) /* ANSI set background color    */
,DCAP("cd","ed",   "\033[J"             ) /* erase to end of screen       */
,DCAP("ce","el",   "\033[K"             ) /* erase to end of line         */
,DCAP("cb","el1",  "\033[1K"            ) /* erase to beginning of line   */
,DCAP(" 0","  0",  "\033[%p1%dt"        ) /* window operation with no arg */
,DCAP(" 1","  1",  "\033[%p1%d;%p2%dt"  ) /* window operation with 1 arg  */
,DCAP(" 2","  2",  "\033[%p1%d;%p2%d;%p3%dt") /* window operation with 2 args */
,DCAP(" 3","  3",  "\033]%p1%d;"        ) /* window operation with text arg */
};


___HIDDEN lineeditor_dkey lineeditor_dkey_table[] =
{
 DKEY("ku","kcuu1","\033OA",  LINEEDITOR_EV_UP,      LINEEDITOR_EV_NONE        )
,DKEY("kd","kcud1","\033OB",  LINEEDITOR_EV_DOWN,    LINEEDITOR_EV_NONE        )
,DKEY("kr","kcuf1","\033OC",  LINEEDITOR_EV_RIGHT,   LINEEDITOR_EV_RIGHT_SEXPR )
,DKEY("kl","kcub1","\033OD",  LINEEDITOR_EV_LEFT,    LINEEDITOR_EV_LEFT_SEXPR  )
,DKEY("kh","khome","\033[1~", LINEEDITOR_EV_HOME,    LINEEDITOR_EV_HOME_DOC    )
,DKEY("kI","kich1","\033[2~", LINEEDITOR_EV_INSERT,  LINEEDITOR_EV_NONE        )
,DKEY("kD","kdch1","\033[3~", LINEEDITOR_EV_DELETE,  LINEEDITOR_EV_DELETE_SEXPR)
,DKEY("@7","kend", "\033[4~", LINEEDITOR_EV_END,     LINEEDITOR_EV_END_DOC     )
,DKEY("kP","kpp",  "\033[5~", LINEEDITOR_EV_HOME_DOC,LINEEDITOR_EV_NONE        )
,DKEY("kN","knp",  "\033[6~", LINEEDITOR_EV_END_DOC, LINEEDITOR_EV_NONE        )
,DKEY("k1","kf1",  "\033OP",  LINEEDITOR_EV_F1,      LINEEDITOR_EV_META_F1     )
,DKEY("k2","kf2",  "\033OQ",  LINEEDITOR_EV_F2,      LINEEDITOR_EV_META_F2     )
,DKEY("k3","kf3",  "\033OR",  LINEEDITOR_EV_F3,      LINEEDITOR_EV_META_F3     )
,DKEY("k4","kf4",  "\033OS",  LINEEDITOR_EV_F4,      LINEEDITOR_EV_META_F4     )
#ifdef LINEEDITOR_SUPPORT_ALTERNATE_ESCAPES
,DKEY("kh","khome","\033OH",  LINEEDITOR_EV_HOME,    LINEEDITOR_EV_HOME_DOC    )
,DKEY("@7","kend", "\033OF",  LINEEDITOR_EV_END,     LINEEDITOR_EV_END_DOC     )
,DKEY("k1","kf1",  "\033[11~",LINEEDITOR_EV_F1,      LINEEDITOR_EV_META_F1     )
,DKEY("k2","kf2",  "\033[12~",LINEEDITOR_EV_F2,      LINEEDITOR_EV_META_F2     )
,DKEY("k3","kf3",  "\033[13~",LINEEDITOR_EV_F3,      LINEEDITOR_EV_META_F3     )
,DKEY("k4","kf4",  "\033[14~",LINEEDITOR_EV_F4,      LINEEDITOR_EV_META_F4     )
#endif
#ifdef LINEEDITOR_SUPPORT_F5_TO_F12
,DKEY("k5","kf5",  "\033[15~",LINEEDITOR_EV_F5,      LINEEDITOR_EV_META_F5     )
,DKEY("k6","kf6",  "\033[17~",LINEEDITOR_EV_F6,      LINEEDITOR_EV_META_F6     )
,DKEY("k7","kf7",  "\033[18~",LINEEDITOR_EV_F7,      LINEEDITOR_EV_META_F7     )
,DKEY("k8","kf8",  "\033[19~",LINEEDITOR_EV_F8,      LINEEDITOR_EV_META_F8     )
,DKEY("k9","kf9",  "\033[20~",LINEEDITOR_EV_F9,      LINEEDITOR_EV_META_F9     )
,DKEY("k;","kf10", "\033[21~",LINEEDITOR_EV_F10,     LINEEDITOR_EV_META_F10    )
,DKEY("F1","kf11", "\033[23~",LINEEDITOR_EV_F11,     LINEEDITOR_EV_META_F11    )
,DKEY("F2","kf12", "\033[24~",LINEEDITOR_EV_F12,     LINEEDITOR_EV_META_F12    )
#endif
};


___HIDDEN ___SCMOBJ lineeditor_dkey_install
   ___P((lineeditor_input_decoder *decoder,
         char *cap,
         ___U8 event_no_escape,
         ___U8 event_with_escape,
         ___BOOL force_xterm),
        (decoder,
         cap,
         event_no_escape,
         event_with_escape,
         force_xterm)
lineeditor_input_decoder *decoder;
char *cap;
___U8 event_no_escape;
___U8 event_with_escape;
___BOOL force_xterm;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  char *seq;

#ifdef USE_TERMCAP_OR_TERMINFO

  if (!force_xterm)
    {
#ifdef USE_TERMCAP

      seq = tgetstr (cap, NULL);

#else

      seq = tigetstr (cap);

#endif
    }
  else

#endif

    seq = cap;

  if (seq != ___CAST(char*,-1) && seq != NULL)
    if ((e = lineeditor_input_decoder_add (decoder, seq, event_no_escape))
        != ___FIX(___NO_ERR) &&
        event_with_escape != (LINEEDITOR_EV_NONE|WITH_ESC_PREFIX))
      e = lineeditor_input_decoder_add (decoder, seq, event_with_escape);

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_dkey_install_table
   ___P((lineeditor_input_decoder *decoder,
         lineeditor_dkey *table,
         int len,
         ___BOOL force_xterm),
        (decoder,
         table,
         len,
         force_xterm)
lineeditor_input_decoder *decoder;
lineeditor_dkey *table;
int len;
___BOOL force_xterm;)
{
  ___SCMOBJ e;
  int i;

  for (i=0; i<len; i++)
    if ((e = lineeditor_dkey_install
               (decoder,
                table[i].cap,
                table[i].event_no_escape,
                table[i].event_with_escape,
                force_xterm))
        != ___FIX(___NO_ERR))
      return e;

  return ___FIX(___NO_ERR);
}


#endif


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


___HIDDEN ___SCMOBJ lineeditor_input_decoder_init
   ___P((lineeditor_input_decoder *decoder,
         ___BOOL map_rubout_to_backspace,
         ___BOOL emacs_bindings,
         ___BOOL force_xterm),
        (decoder,
         map_rubout_to_backspace,
         emacs_bindings,
         force_xterm)
lineeditor_input_decoder *decoder;
___BOOL map_rubout_to_backspace;
___BOOL emacs_bindings;
___BOOL force_xterm;)
{
  ___SCMOBJ e;

  decoder->length = 0;

  if ((e = lineeditor_defseq_install_table
             (decoder,
              lineeditor_defseq_common,
              ___NBELEMS(lineeditor_defseq_common)))
      != ___FIX(___NO_ERR))
    return e;

  if (map_rubout_to_backspace)
    if ((e = lineeditor_defseq_install_table
               (decoder,
                lineeditor_defseq_map_rubout_to_backspace,
                ___NBELEMS(lineeditor_defseq_map_rubout_to_backspace)))
        != ___FIX(___NO_ERR))
      return e;

  if (emacs_bindings)
    if ((e = lineeditor_defseq_install_table
               (decoder,
                lineeditor_defseq_emacs,
                ___NBELEMS(lineeditor_defseq_emacs)))
        != ___FIX(___NO_ERR))
      return e;

#ifdef USE_CURSES

  if ((e = lineeditor_dkey_install_table
             (decoder,
              lineeditor_dkey_table,
              ___NBELEMS(lineeditor_dkey_table),
              force_xterm))
      != ___FIX(___NO_ERR))
    return e;

#endif

  if ((e = lineeditor_defseq_install_table
             (decoder,
              lineeditor_defseq_widespread,
              ___NBELEMS(lineeditor_defseq_widespread)))
      != ___FIX(___NO_ERR))
    return e;

  return ___FIX(___NO_ERR);
}


/*---------------------------------------------------------------------------*/

/* Line editing history routines */


___HIDDEN ___SCMOBJ lineeditor_history_begin_edit
   ___P((___device_tty *self,
         lineeditor_history *h),
        (self,
         h)
___device_tty *self;
lineeditor_history *h;)
{
#define LINEEDITOR_FUDGE 80

  ___device_tty *d = self;
  ___SCMOBJ e;

  if (h->edited.buffer == NULL)
    {
      if ((e = extensible_string_copy
                 (h->actual.buffer,
                  h->actual.length,
                  &h->edited,
                  LINEEDITOR_FUDGE))
          != ___FIX(___NO_ERR))
        return e;
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN void lineeditor_history_end_edit
   ___P((___device_tty *self,
         lineeditor_history *h),
        (self,
         h)
___device_tty *self;
lineeditor_history *h;)
{
  ___device_tty *d = self;

  if (h->edited.buffer != NULL)
    {
      extensible_string_cleanup (&h->edited);
      h->edited.buffer = NULL;
    }
}


___HIDDEN ___SCMOBJ lineeditor_history_setup
   ___P((___device_tty *self,
         lineeditor_history **hist),
        (self,
         hist)
___device_tty *self;
lineeditor_history **hist;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  lineeditor_history *h;

  h = ___CAST(lineeditor_history*,
              ___ALLOC_MEM(sizeof (lineeditor_history)));

  if (h == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  if ((e = extensible_string_setup (&h->actual, 0)) != ___FIX(___NO_ERR))
    {
      ___FREE_MEM(h);
      return e;
    }

  h->edited.buffer = NULL;

  h->prev = h; /* create a circular list */
  h->next = h;

  *hist = h;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_history_cleanup
   ___P((___device_tty *self,
         lineeditor_history *h),
        (self,
         h)
___device_tty *self;
lineeditor_history *h;)
{
  ___device_tty *d = self;

  lineeditor_history_end_edit (d, h);

  extensible_string_cleanup (&h->actual);

  ___FREE_MEM(h);

  return ___FIX(___NO_ERR);
}


___HIDDEN void lineeditor_history_remove
   ___P((___device_tty *self,
         lineeditor_history *item),
        (self,
         item)
___device_tty *self;
lineeditor_history *item;)
{
  ___device_tty *d = self;

  lineeditor_history *prev = item->prev;
  lineeditor_history *next = item->next;

  if (prev == item)
    d->hist_last = NULL;
  else
    {
      next->prev = prev;
      prev->next = next;
      item->prev = item;
      item->next = item;
      if (d->hist_last == item)
        d->hist_last = prev;
    }
}


___HIDDEN void lineeditor_history_trim_to
   ___P((___device_tty *self,
         int max_length),
        (self,
         max_length)
___device_tty *self;
int max_length;)
{
  ___device_tty *d = self;

  while (d->history_length > max_length)
    {
      lineeditor_history *first = d->hist_last->next;
      lineeditor_history_remove (d, first);
      lineeditor_history_cleanup (d, first); /* ignore error */
      d->history_length--;
    }
}


___HIDDEN void lineeditor_history_trim
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  lineeditor_history_trim_to (d, d->history_max_length);
}


___HIDDEN void lineeditor_set_history_max_length
   ___P((___device_tty *self,
         int history_max_length),
        (self,
         history_max_length)
___device_tty *self;
int history_max_length;)
{
  ___device_tty *d = self;

  if (history_max_length >= 0)
    {
      d->history_max_length = history_max_length;
      lineeditor_history_trim (d);
    }
}


___HIDDEN void lineeditor_history_add_after
   ___P((___device_tty *self,
         lineeditor_history *item,
         lineeditor_history *dest),
        (self,
         item,
         dest)
___device_tty *self;
lineeditor_history *item;
lineeditor_history *dest;)
{
  ___device_tty *d = self;

  if (dest == NULL)
    {
      item->prev = item;
      item->next = item;
    }
  else
    {
      lineeditor_history *after_dest = dest->next;
      item->next = after_dest;
      item->prev = dest;
      dest->next = item;
      after_dest->prev = item;
    }

  d->history_length++;
}


___HIDDEN void lineeditor_history_add_last
   ___P((___device_tty *self,
         lineeditor_history *item),
        (self,
         item)
___device_tty *self;
lineeditor_history *item;)
{
  ___device_tty *d = self;

  lineeditor_history_add_after (d, item, d->hist_last);
  d->hist_last = item;
}


___HIDDEN ___SCMOBJ lineeditor_history_add_line_before_last
   ___P((___device_tty *self,
         int len,
         extensible_string_char *chars),
        (self,
         len,
         chars)
___device_tty *self;
int len;
extensible_string_char *chars;)
{
  ___SCMOBJ e;
  lineeditor_history *line;

  if ((e = lineeditor_history_setup (self, &line))
      == ___FIX(___NO_ERR))
    {
      if ((e = extensible_string_insert_at_end (&line->actual, len, chars))
          == ___FIX(___NO_ERR))
        lineeditor_history_add_after (self, line, self->hist_last->prev);
      else
        lineeditor_history_cleanup (self, line); /* ignore error */
    }

  return e;
}


/*---------------------------------------------------------------------------*/

/* Line editing routines */


___HIDDEN ___SCMOBJ lineeditor_output_drain
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * This routine drains the output buffers.  The return value is
   * ___FIX(___NO_ERR) if and only if the output buffers were
   * completely drained.  The return value is different from
   * ___FIX(___NO_ERR) only when ___device_tty_write
   * returned an error.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;

  for (;;)
    {
      int byte_avail;
      int len = d->output_byte_hi - d->output_byte_lo;

      while (len > 0)
        {
          ___stream_index len_done = 0;
          ___U8 *byte_buf = d->output_byte + d->output_byte_lo;

          if ((e = ___device_tty_write
                     (d,
                      byte_buf,
                      len,
                      &len_done)) != ___FIX(___NO_ERR))
            return e;

          len = d->output_byte_hi - (d->output_byte_lo += len_done);
        }

      d->output_byte_lo = 0;
      d->output_byte_hi = 0;

      len = d->output_char.length - d->output_char_lo;

      if (len <= 0)
        break;

      do
        {
          ___C *char_buf = d->output_char.buffer + d->output_char_lo;
          ___U8 *byte_buf = d->output_byte + d->output_byte_hi;

          byte_avail = ___NBELEMS(d->output_byte) - d->output_byte_hi;

          if (chars_to_bytes (char_buf,
                              &len,
                              byte_buf,
                              &byte_avail,
                              &d->output_encoding_state)
              == ___ILLEGAL_CHAR)
            len--; /* skip over the illegal character */

#ifdef ___DEBUG_TTY

          {
            int i;
            int n = (___NBELEMS(d->output_byte) - d->output_byte_hi) - byte_avail;

            ___printf ("lineeditor_output_drain  nb_bytes: %d ", n);

            for (i=0; i<n; i++)
              ___printf (" %02x", d->output_byte[i]);

            ___printf ("\n");
          }

#endif

          if (byte_avail ==  ___NBELEMS(d->output_byte) - d->output_byte_hi)
            break;  /* not enough space for a full multibyte character, first flush what we have */

          d->output_char_lo = d->output_char.length - len;

          d->output_byte_hi = ___NBELEMS(d->output_byte) - byte_avail;
        } while (byte_avail > 0 && len > 0);

      if (len <= 0)
        {
          extensible_string_set_length
            (&d->output_char, 0, 1); /* ignore error */
          d->output_char.length = 0; /* in case set_length failed */
          d->output_char_lo = 0;
        }
    }

  return ___FIX(___NO_ERR);
}


/* forward declaration needed because lineeditor_output is recursive */

___HIDDEN ___SCMOBJ lineeditor_output_terminal_emulate
   ___P((___device_tty *self,
         ___C *buf,
         int len),
        ());


___HIDDEN ___SCMOBJ lineeditor_output
   ___P((___device_tty *self,
         ___C *buf,
         int len),
        (self,
         buf,
         len)
___device_tty *self;
___C *buf;
int len;)
{
  /*
   * This routine outputs the string of characters "buf" of length
   * "len" to the terminal.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;

#ifdef ___DEBUG_TTY

  {
    int i;

    ___printf ("et:%d row:%2d col:%2d cursor:%2d dw:%d len:%3d  ",
               d->emulate_terminal,
               d->terminal_row,
               d->terminal_col,
               d->terminal_cursor,
               d->terminal_delayed_wrap,
               len);

    ___printf ("\"");

    for (i=0; i<len; i++)
      if (buf[i] < 32 || buf[i] >= 127)
        ___printf ("\\x%02x", buf[i]);
      else
        ___printf ("%c", buf[i]);

    ___printf ("\"\n");
  }

#endif

  if (d->emulate_terminal)
    {
      d->emulate_terminal = 0;
      e = lineeditor_output_terminal_emulate (d, buf, len);
      d->emulate_terminal = 1;
    }
  else
    e = extensible_string_insert
          (&d->output_char,
           d->output_char.length,
           len,
           buf);

#ifdef USE_WIN32
  e = lineeditor_output_drain (d);/******************************/
#endif

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_output_curses_drain
   ___P((int len),
        (len)
int len;)
{
  /*
   * This routine drains the curses output buffer.  The parameters it
   * uses are stored in the TTY module structure "___tty_mod" (because
   * C does not have closures...).
   */

  struct ___curses_struct *cs = &CURRENT_CURSES_STRUCT;

  return lineeditor_output (___tty_mod.curses_tty, cs->output, len);
}


___HIDDEN int lineeditor_output_curses
   ___P((int c),
        (c)
int c;)
{
  /*
   * This routine outputs a C character.  It is passed as an argument
   * to the termcap/terminfo "tputs" routine for outputing individual
   * characters.  The parameters it uses are stored in the TTY module
   * structure "___tty_mod" (because C does not have closures...).
   */

  struct ___curses_struct *cs = &CURRENT_CURSES_STRUCT;

  if (cs->last_err == ___FIX(___NO_ERR))
    {
      cs->output[cs->output_lo++] = c;

      if (cs->output_lo >= ___CAST(int,___NBELEMS(cs->output)))
        {
          cs->last_err = lineeditor_output_curses_drain
                           (___NBELEMS(cs->output));
          cs->output_lo = 0;
        }
    }

  return c;
}


___HIDDEN char *lineeditor_cap
   ___P((___device_tty *self,
         int cap),
        (self,
         cap)
___device_tty *self;
int cap;)
{
  /*
   * This routine returns the curses string for the terminal
   * capability "cap".
   */

  ___device_tty *d = self;

#ifdef TERMINAL_EMULATION_USES_CURSES

  if (!d->emulate_terminal)
    return d->capability[cap];

#endif

#ifdef USE_TERMCAP_OR_TERMINFO

  return lineeditor_dcap_table[cap].xterm_cap;

#else

  return lineeditor_dcap_table[cap].cap;

#endif
}


___HIDDEN ___SCMOBJ lineeditor_output_cap3
   ___P((___device_tty *self,
         int cap,
         int arg1,
         int arg2,
         int arg3,
         int rep),
        (self,
         cap,
         arg1,
         arg2,
         arg3,
         rep)
___device_tty *self;
int cap;
int arg1;
int arg2;
int arg3;
int rep;)
{
  /*
   * This routine outputs the character sequence for the terminal
   * capability "cap" with integer parameters "arg1", "arg2" and "arg3"
   * (-1 means no parameter).  This is repeated "rep" times.
   */

  ___device_tty *d = self;
  struct ___curses_struct *cs;
  char *str = lineeditor_cap (d, cap);

  if (str == NULL)
    return ___FIX(___NO_ERR);

  ___tty_mod.curses_tty = d;

  cs = &CURRENT_CURSES_STRUCT;
  cs->output_lo = 0;
  cs->last_err = ___FIX(___NO_ERR);

  while (rep > 0)
    {
      char *p;

      if (cap < LINEEDITOR_CAP_SGR0)  /******** TODO: this belongs elsewhere */
        d->terminal_delayed_wrap = 0; /* cursor cmds cancel delayed wrap */

#ifdef TERMINAL_EMULATION_USES_CURSES
#ifdef USE_TERMCAP_OR_TERMINFO

      if (!d->emulate_terminal)
        {
          p = str;

          if (arg1 >= 0 && arg3 < 0)
            {
#ifdef USE_TERMCAP
              p = tgoto (p, arg2, arg1);
#else
              if (arg2 >= 0)
                p = tparm (p, arg1, arg2);
              else
                p = tparm (p, arg1);
#endif
            }

          if (tputs (p, 1, lineeditor_output_curses) == ERR &&
              cs->last_err == ___FIX(___NO_ERR))
            cs->last_err = ___FIX(___UNKNOWN_ERR);
        }
      else

#endif
#endif

        {
          int params[3];
          int stack[10];
          int sp = 0;

          params[0] = arg1;
          params[1] = arg2;
          params[2] = arg3;

          p = str;

          while (*p != '\0')
            {
              ___C c = *p++;

              if (c == '%') /* start of a formatting command? */
                {
                  switch (*p++)
                    {
                    case 'i':
                      params[0]++;
                      params[1]++;
                      break;

                    case 'p':
                      if (sp < ___CAST(int,___NBELEMS(stack)))
                        stack[sp++] = params[*p++ - '1'];
                      break;

                    case 'd':
                      {
                        int d = 1;
                        int n;

                        if (sp > 0)
                          n = stack[--sp];
                        else
                          n = 0;

                        /*
                         * support 256 colors by using
                         *   "\033[38;5;%p1%dm" instead of "\033[3%p1%dm"
                         * and
                         *   "\033[48;5;%p1%dm" instead of "\033[4%p1%dm"
                         */
                        if (*p == 'm' && n >= 8)
                          {
                            lineeditor_output_curses ('8');
                            lineeditor_output_curses (';');
                            lineeditor_output_curses ('5');
                            lineeditor_output_curses (';');
                          }

                        while (d*10 <= n)
                          d *= 10;

                        while (d > 0)
                          {
                            lineeditor_output_curses ('0' + (n / d) % 10);
                            d /= 10;
                          }

                        break;
                      }
                    }
                }
              else
                lineeditor_output_curses (c);
            }
        }

      if (cs->last_err != ___FIX(___NO_ERR))
        return cs->last_err;

      rep--;
    }

  return lineeditor_output_curses_drain (cs->output_lo);
}

___HIDDEN ___SCMOBJ lineeditor_output_cap0
   ___P((___device_tty *self,
         int cap,
         int rep),
        (self,
         cap,
         rep)
___device_tty *self;
int cap;
int rep;)
{
  return lineeditor_output_cap3 (self, cap, -1, -1, -1, rep);
}

___HIDDEN ___SCMOBJ lineeditor_output_cap1
   ___P((___device_tty *self,
         int cap,
         int arg1,
         int rep),
        (self,
         cap,
         arg1,
         rep)
___device_tty *self;
int cap;
int arg1;
int rep;)
{
  return lineeditor_output_cap3 (self, cap, arg1, -1, -1, rep);
}

___HIDDEN ___SCMOBJ lineeditor_output_cap2
   ___P((___device_tty *self,
         int cap,
         int arg1,
         int arg2,
         int rep),
        (self,
         cap,
         arg1,
         arg2,
         rep)
___device_tty *self;
int cap;
int arg1;
int arg2;
int rep;)
{
  return lineeditor_output_cap3 (self, cap, arg1, arg2, -1, rep);
}

___HIDDEN ___SCMOBJ lineeditor_output_set_attrs
   ___P((___device_tty *self,
         tty_text_attrs attrs),
        (self,
         attrs)
___device_tty *self;
tty_text_attrs attrs;)
{
  /*
   * This routine outputs the character sequence that sets the text
   * attributes of the next characters sent to the terminal.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  int turn_on;
  tty_text_attrs current_attrs;

#ifdef TERMINAL_EMULATION_USES_CURSES

  if (!d->emulate_terminal)
    {
      current_attrs = d->terminal_attrs;
      d->terminal_attrs = attrs;
    }
  else

#endif

    {
      current_attrs = d->current.attrs;
      d->current.attrs = attrs;
    }

  if (current_attrs == attrs)
    return ___FIX(___NO_ERR);

  turn_on = GET_STYLE(attrs);

  if ((GET_STYLE(current_attrs) & ~turn_on) != 0 ||
      (GET_FOREGROUND_COLOR(attrs) >= DEFAULT_TEXT_COLOR &&
       GET_FOREGROUND_COLOR(current_attrs) < DEFAULT_TEXT_COLOR) ||
      (GET_BACKGROUND_COLOR(attrs) >= DEFAULT_TEXT_COLOR &&
       GET_BACKGROUND_COLOR(current_attrs) < DEFAULT_TEXT_COLOR))
    {
      if ((e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_SGR0, 1))
          != ___FIX(___NO_ERR))
        return e;
      current_attrs = MAKE_TEXT_ATTRS(0,DEFAULT_TEXT_COLOR,DEFAULT_TEXT_COLOR);
    }
  else
    turn_on = (~GET_STYLE(current_attrs) & turn_on);

  if (turn_on & TEXT_STYLE_BOLD)
    if ((e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_BOLD, 1))
        != ___FIX(___NO_ERR))
      return e;

  if (turn_on & TEXT_STYLE_UNDERLINE)
    if ((e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_SMUL, 1))
        != ___FIX(___NO_ERR))
      return e;

  if (turn_on & TEXT_STYLE_REVERSE)
    if ((e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_REV, 1))
        != ___FIX(___NO_ERR))
      return e;

  if (GET_FOREGROUND_COLOR(attrs) < DEFAULT_TEXT_COLOR &&
      GET_FOREGROUND_COLOR(attrs) != GET_FOREGROUND_COLOR(current_attrs))
    if ((e = lineeditor_output_cap1
               (d,
                LINEEDITOR_CAP_SETAF,
                GET_FOREGROUND_COLOR(attrs),
                1))
        != ___FIX(___NO_ERR))
      return e;

  if (GET_BACKGROUND_COLOR(attrs) < DEFAULT_TEXT_COLOR &&
      GET_BACKGROUND_COLOR(attrs) != GET_BACKGROUND_COLOR(current_attrs))
    if ((e = lineeditor_output_cap1
               (d,
                LINEEDITOR_CAP_SETAB,
                GET_BACKGROUND_COLOR(attrs),
                1))
        != ___FIX(___NO_ERR))
      return e;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_output_terminal_plain_chars
   ___P((___device_tty *self,
         ___C *buf,
         int len),
        (self,
         buf,
         len)
___device_tty *self;
___C *buf;
int len;)
{
  /*
   * This routine processes a string of plain characters (with no
   * control characters) that the emulated terminal received.  It also
   * tracks the movement of the emulated terminal's cursor.
   */

  ___device_tty *d = self;
  int col = d->terminal_col + d->terminal_delayed_wrap + len;

  if (col >= d->terminal_nb_cols)
    {
      if (d->has_auto_right_margin)
        {
          int row = d->terminal_row + col / d->terminal_nb_cols;

          col = col % d->terminal_nb_cols;

          if (col == 0 && d->has_eat_newline_glitch)
            {
              col = d->terminal_nb_cols - 1;
              row--;
              d->terminal_delayed_wrap = 1; /* delay wrap */
            }
          else
            d->terminal_delayed_wrap = 0;

          if (row >= d->terminal_nb_rows)
            {
              d->current.line_start -= d->terminal_nb_cols *
                                       (row - d->terminal_nb_rows + 1);
              row = d->terminal_nb_rows - 1;
            }

          d->terminal_row = row;
        }
      else
        col = d->terminal_nb_cols - 1;
    }
  else
    d->terminal_delayed_wrap = 0;

  d->terminal_col = col;

  d->terminal_cursor = d->terminal_row * d->terminal_nb_cols + col;

  return lineeditor_output (d, buf, len);
}


#ifdef USE_WIN32

___HIDDEN ___SCMOBJ lineeditor_output_terminal_op_move_abs
   ___P((___device_tty *self,
         int dest_col,
         int dest_row),
        ());

#endif


___HIDDEN ___SCMOBJ lineeditor_output_terminal_op_move_col
   ___P((___device_tty *self,
         int dist),
        (self,
         dist)
___device_tty *self;
int dist;)
{
  /*
   * This routine performs a relative cursor positioning operation
   * that changes the column of the cursor.  It also tracks the
   * movement of the emulated terminal's cursor.
   */

  ___device_tty *d = self;
  int col = d->terminal_col;
  int dest_col = col + dist;

  if (dest_col < 0)
    dest_col = 0;
  else if (dest_col >= d->terminal_nb_cols)
    dest_col = d->terminal_nb_cols - 1;

#ifdef USE_WIN32

  return lineeditor_output_terminal_op_move_abs
           (d,
            dest_col,
            d->terminal_row);

#else

  dist = dest_col - col;

  if (dist != 0)
    {
      d->terminal_col = dest_col;
      d->terminal_cursor = d->terminal_row * d->terminal_nb_cols + dest_col;
      d->terminal_delayed_wrap = 0;

      if (dist > 0)
        return lineeditor_output_cap1 (d, LINEEDITOR_CAP_CUF, dist, 1);
      else
        return lineeditor_output_cap1 (d, LINEEDITOR_CAP_CUB, -dist, 1);
    }

  return ___FIX(___NO_ERR);

#endif
}


___HIDDEN ___SCMOBJ lineeditor_output_terminal_op_move_row
   ___P((___device_tty *self,
         int dist),
        (self,
         dist)
___device_tty *self;
int dist;)
{
  /*
   * This routine performs a relative cursor positioning operation
   * that changes the row of the cursor.  It also tracks the movement
   * of the emulated terminal's cursor.
   */

  ___device_tty *d = self;
  int row = d->terminal_row;
  int dest_row = row + dist;

  if (dest_row < 0)
    dest_row = 0;
  else if (dest_row >= d->terminal_nb_rows)
    dest_row = d->terminal_nb_rows - 1;

#ifdef USE_WIN32

  return lineeditor_output_terminal_op_move_abs
           (d,
            d->terminal_col,
            dest_row);

#else

  dist = dest_row - row;

  if (dist != 0)
    {
      d->terminal_row = dest_row;
      d->terminal_cursor = dest_row * d->terminal_nb_cols + d->terminal_col;
      d->terminal_delayed_wrap = 0;

      if (dist > 0)
        {
          if ((dist == 1 || lineeditor_cap (d, LINEEDITOR_CAP_CUD) == NULL) &&
              lineeditor_cap (d, LINEEDITOR_CAP_CUD1) != NULL)
            return lineeditor_output_cap0 (d, LINEEDITOR_CAP_CUD1, dist);
          else
            return lineeditor_output_cap1 (d, LINEEDITOR_CAP_CUD, dist, 1);
        }
      else
        {
          if ((dist == -1 || lineeditor_cap (d, LINEEDITOR_CAP_CUU) == NULL) &&
              lineeditor_cap (d, LINEEDITOR_CAP_CUU1) != NULL)
            return lineeditor_output_cap0 (d, LINEEDITOR_CAP_CUU1, -dist);
          else
            return lineeditor_output_cap1 (d, LINEEDITOR_CAP_CUU, -dist, 1);
        }
    }

  return ___FIX(___NO_ERR);

#endif
}


___HIDDEN ___SCMOBJ lineeditor_output_terminal_op_move_abs
   ___P((___device_tty *self,
         int dest_col,
         int dest_row),
        (self,
         dest_col,
         dest_row)
___device_tty *self;
int dest_col;
int dest_row;)
{
  /*
   * This routine performs an absolute cursor positioning operation.
   * It also tracks the movement of the emulated terminal's cursor.
   */

  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

#ifdef USE_WIN32

 {
   CONSOLE_SCREEN_BUFFER_INFO info;

   if (!GetConsoleScreenBufferInfo (d->hout, &info))
     e = err_code_from_GetLastError ();
   else
     {
       COORD pos = info.dwCursorPosition;

       pos.X += dest_col - d->terminal_col;
       pos.Y += dest_row - d->terminal_row;

       d->terminal_col = dest_col;
       d->terminal_row = dest_row;
       d->terminal_cursor = dest_row * d->terminal_nb_cols + dest_col;
       d->terminal_delayed_wrap = 0;

       if (!SetConsoleCursorPosition (d->hout, pos))
         e = err_code_from_GetLastError ();
     }
  }

#else

  if (dest_col == 0 &&
      dest_row == 0 &&
      lineeditor_cap (d, LINEEDITOR_CAP_HOME) != NULL)
    {
      d->terminal_col = 0;
      d->terminal_row = 0;
      d->terminal_cursor = 0;
      d->terminal_delayed_wrap = 0;

      return lineeditor_output_cap0 (d, LINEEDITOR_CAP_HOME, 1);
    }

  if (lineeditor_cap (d, LINEEDITOR_CAP_CUP) != NULL)
    {
      d->terminal_col = dest_col;
      d->terminal_row = dest_row;
      d->terminal_cursor = dest_row * d->terminal_nb_cols + dest_col;
      d->terminal_delayed_wrap = 0;

      return lineeditor_output_cap2
               (d,
                LINEEDITOR_CAP_CUP,
                dest_row,
                dest_col,
                1);
    }

  if ((e = lineeditor_output_terminal_op_move_col
             (d,
              dest_col - d->terminal_col)) == ___FIX(___NO_ERR))
    e = lineeditor_output_terminal_op_move_row
          (d,
           dest_row - d->terminal_row);

#endif

  return e;
}


#define TERMINAL_MOVE_ABS   1
#define TERMINAL_MOVE_ROW   0
#define TERMINAL_MOVE_COL   -1
#define TERMINAL_ERASE_DISP -2
#define TERMINAL_ERASE_LINE -3
#define TERMINAL_SET_ATTRS  -4
#define TERMINAL_NOOP       -5
#define TERMINAL_CTRL       -6
#define TERMINAL_WINDOW_OP  -7

___HIDDEN ___SCMOBJ lineeditor_output_terminal_op
   ___P((___device_tty *self,
         int op,
         int arg,
         ___U8 *text_arg),
        (self,
         op,
         arg,
         text_arg)
___device_tty *self;
int op;
int arg;
___U8 *text_arg;)
{
  /*
   * This routine performs an operation of the emulated terminal and
   * tracks the movement of the cursor.
   */

  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

  switch (op)
    {
    case TERMINAL_NOOP:
      break;

    case TERMINAL_CTRL - ___UNICODE_BELL:
      {
#ifdef USE_WIN32

        if (!MessageBeep (MB_OK))
          e = err_code_from_GetLastError ();

#else

        {
          ___C c = ___UNICODE_BELL;
          e = lineeditor_output (d, &c, 1);
        }

#endif

        break;
      }

    case TERMINAL_CTRL - ___UNICODE_BACKSPACE:
      {
        if (d->terminal_col > 0)
          d->terminal_col--;
        else if (d->terminal_row > 0 && d->has_auto_left_margin)
          {
            d->terminal_row--;
            d->terminal_col = d->terminal_nb_cols - 1;
          }

        d->terminal_cursor = d->terminal_row * d->terminal_nb_cols +
                             d->terminal_col;

        d->terminal_delayed_wrap = 0;

#ifdef USE_WIN32

        {
          CONSOLE_SCREEN_BUFFER_INFO info;

          if (!GetConsoleScreenBufferInfo (d->hout, &info))
            e = err_code_from_GetLastError ();
          else
            {
              COORD pos = info.dwCursorPosition;

              if (pos.X > 0)
                pos.X--;
              else if (pos.Y > info.srWindow.Top && d->has_auto_left_margin)
                {
                  pos.X = info.dwSize.X - 1;
                  pos.Y--;
                }

              if (!SetConsoleCursorPosition (d->hout, pos))
                e = err_code_from_GetLastError ();
            }
        }

#else

        {
          ___C c = ___UNICODE_BACKSPACE;
          e = lineeditor_output (d, &c, 1);
        }

#endif

        break;
      }

    case TERMINAL_CTRL - ___UNICODE_TAB:
      {
        e = lineeditor_output_terminal_op_move_col
              (d,
               8 - d->terminal_col % 8);
        break;
      }

    case TERMINAL_CTRL - ___UNICODE_LINEFEED:
      {
        if (d->terminal_row < d->terminal_nb_rows-1)
          d->terminal_row++;
        else
          d->current.line_start -= d->terminal_nb_cols;

        if (d->linefeed_moves_to_left_margin || !d->output_raw)
          d->terminal_col = 0;

        d->terminal_cursor = d->terminal_row * d->terminal_nb_cols +
                             d->terminal_col;

        d->terminal_delayed_wrap = 0;

#ifdef USE_WIN32

        {
          CONSOLE_SCREEN_BUFFER_INFO info;

          if (!GetConsoleScreenBufferInfo (d->hout, &info))
            e = err_code_from_GetLastError ();
          else
            {
              COORD pos = info.dwCursorPosition;

              if (pos.Y >= info.dwSize.Y - 1)
                {
                  SMALL_RECT rect;
                  CHAR_INFO fill;
                  COORD dest;

                  rect.Top = 0;
                  rect.Bottom = info.dwSize.Y - 1;
                  rect.Left = 0;
                  rect.Right = info.dwSize.X - 1;

                  dest.X = 0;
                  dest.Y = -1;

                  fill.Attributes = info.wAttributes;
                  TTY_CHAR_SELECT(fill.Char.AsciiChar = ' ',
                                  fill.Char.UnicodeChar = ' ');

                  if (!ScrollConsoleScreenBuffer (d->hout,
                                                  &rect,
                                                  &rect,
                                                  dest,
                                                  &fill))
                    e = err_code_from_GetLastError ();

                  pos.Y = info.dwSize.Y - 1;
                }
              else
                pos.Y++;

              if (e == ___FIX(___NO_ERR))
                {
                  if (d->linefeed_moves_to_left_margin || !d->output_raw)
                    pos.X = 0;

                  if (!SetConsoleCursorPosition (d->hout, pos))
                    e = err_code_from_GetLastError ();
                }
            }
        }

#else

        {
          ___C c = ___UNICODE_LINEFEED;
          e = lineeditor_output (d, &c, 1);
        }

#endif

        break;
      }

    case TERMINAL_CTRL - ___UNICODE_RETURN:
      {
        d->terminal_col = 0;
        d->terminal_cursor = d->terminal_row * d->terminal_nb_cols;
        d->terminal_delayed_wrap = 0;

#ifdef USE_WIN32

        {
          CONSOLE_SCREEN_BUFFER_INFO info;

          if (!GetConsoleScreenBufferInfo (d->hout, &info))
            e = err_code_from_GetLastError ();
          else
            {
              COORD pos = info.dwCursorPosition;

              pos.X = 0;

              if (!SetConsoleCursorPosition (d->hout, pos))
                e = err_code_from_GetLastError ();
            }
        }

#else

        {
          ___C c = ___UNICODE_RETURN;
          e = lineeditor_output (d, &c, 1);
        }

#endif

        break;
      }

    case TERMINAL_SET_ATTRS:
      {
#ifdef USE_WIN32

        {
          int style = GET_STYLE(arg);
          int fg = GET_FOREGROUND_COLOR(arg);
          int bg = GET_BACKGROUND_COLOR(arg);
          WORD default_attr = d->hout_initial_info.wAttributes;
          WORD attr = 0;

          if (fg == DEFAULT_TEXT_COLOR)
            {
              fg = (default_attr & FOREGROUND_BLUE  ? 4 : 0) +
                   (default_attr & FOREGROUND_GREEN ? 2 : 0) +
                   (default_attr & FOREGROUND_RED   ? 1 : 0);
              if ((default_attr & FOREGROUND_INTENSITY) == 0)
                style ^= TEXT_STYLE_BOLD;
            }

          if (bg == DEFAULT_TEXT_COLOR)
            {
              bg = (default_attr & BACKGROUND_BLUE  ? 4 : 0) +
                   (default_attr & BACKGROUND_GREEN ? 2 : 0) +
                   (default_attr & BACKGROUND_RED   ? 1 : 0);
              if ((default_attr & BACKGROUND_INTENSITY) == 0)
                style ^= TEXT_STYLE_UNDERLINE;
            }

          if ((style & TEXT_STYLE_BOLD) == 0)
            attr |= FOREGROUND_INTENSITY;

          if ((style & TEXT_STYLE_UNDERLINE) == 0)
            attr |= BACKGROUND_INTENSITY;

          if (style & TEXT_STYLE_REVERSE)
            {
              int temp = fg;
              fg = bg;
              bg = temp;
            }

          if (fg & 4) attr |= FOREGROUND_BLUE;
          if (fg & 2) attr |= FOREGROUND_GREEN;
          if (fg & 1) attr |= FOREGROUND_RED;
          if (bg & 4) attr |= BACKGROUND_BLUE;
          if (bg & 2) attr |= BACKGROUND_GREEN;
          if (bg & 1) attr |= BACKGROUND_RED;

          if (!SetConsoleTextAttribute (d->hout, attr))
            e = err_code_from_GetLastError ();
        }

#else

        e = lineeditor_output_set_attrs (d, arg);

#endif

        break;
      }

#ifdef USE_WIN32

    case TERMINAL_ERASE_DISP:
    case TERMINAL_ERASE_LINE:
      {
        if (arg <= 2) /* argument valid? */
          {
            COORD pos;
            CONSOLE_SCREEN_BUFFER_INFO info;
            DWORD n;
            DWORD written;

            if (!GetConsoleScreenBufferInfo (d->hout, &info))
              return err_code_from_GetLastError ();

            if (d->terminal_col == 0 &&
                d->terminal_row == 0)
              {
                pos.X = 0;
                pos.Y = 0;

                if (!SetConsoleCursorPosition (d->hout, pos))
                  return err_code_from_GetLastError ();
              }
            else
              pos = info.dwCursorPosition;

            if (arg == 0)
              n = info.dwSize.X - pos.X;
            else
              {
                if (arg == 1)
                  n = pos.X;
                else
                  n = info.dwSize.X;
                pos.X = 0;
              }

            if (op == TERMINAL_ERASE_DISP)
              {
                if (arg == 0)
                  n += info.dwSize.X * (info.dwSize.Y - pos.Y - 1);
                else
                  {
                    if (arg == 1)
                      n += info.dwSize.X * pos.Y;
                    else
                      n = info.dwSize.X * info.dwSize.Y;
                    pos.Y = 0;
                  }
              }

            if (!FillConsoleOutputAttribute
                   (d->hout,
                    info.wAttributes,
                    n,
                    pos,
                    &written) ||
                !FillConsoleOutputCharacter
                   (d->hout,
                    ' ',
                    n,
                    pos,
                    &written))
              e = err_code_from_GetLastError ();
          }

        break;
      }

    case TERMINAL_WINDOW_OP:
      {
        int window_op = arg & ((1<<8)-1);
        int arg1 = (arg >> 8) & ((1<<12)-1);
        int arg2 = (arg >> 20) & ((1<<12)-1);
        HWND cons_wind = GetConsoleWindow ();

        if (cons_wind != NULL)
          {
            if (text_arg != NULL)
              {
                SetWindowTextA (cons_wind,
                                ___CAST(LPCSTR,text_arg)); /* ignore error */
              }
            else
              {
                switch (window_op)
                  {
                  case 1: /* De-iconify window */
                  case 2: /* Iconify window */
                    ShowWindow (cons_wind,
                                (window_op == 1) ? SW_RESTORE : SW_MINIMIZE);
                    break;

                  case 3: /* Move window to [arg1, arg2] */
                    SetWindowPos (cons_wind,
                                  cons_wind,
                                  arg1,
                                  arg2,
                                  0,
                                  0,
                                  SWP_NOZORDER | SWP_NOSIZE);
                    break;

                  case 4: /* Resize window to height=arg1 and width=arg2 in pixels */
                    SetWindowPos (cons_wind,
                                  cons_wind,
                                  0,
                                  0,
                                  arg2,
                                  arg1,
                                  SWP_NOZORDER | SWP_NOMOVE);
                    break;

                  case 5: /* Raise the window to the front of the stacking order */
                  case 6: /* Lower the window to the bottom of the stacking order */
                    SetWindowPos (cons_wind,
                                  (window_op == 5) ? HWND_TOP : HWND_BOTTOM,
                                  0,
                                  0,
                                  0,
                                  0,
                                  SWP_NOSIZE | SWP_NOMOVE);
                    break;

                  case 7: /* Refresh the window */
                    break;

                  case 8: /* Resize window to height=arg1 and width=arg2 in chars */
                    break;

                  case 9: /* Maximize or un-maximize window (arg1=0 or arg1=1) */
                    ShowWindow (cons_wind,
                                (arg1 == 0) ? SW_MAXIMIZE : SW_RESTORE);
                    break;
                  }
              }
          }

        break;
      }

#else

    case TERMINAL_ERASE_DISP:
      {
        switch (arg)
          {
          case 1: /* erase from beginning of screen */
            break;
          case 2: /* erase all screen */
            if (d->terminal_col != 0 || d->terminal_row != 0)
              break;
          case 0: /* erase to end of screen */
            e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_ED, 1);
            break;
          }
        break;
      }

    case TERMINAL_ERASE_LINE:
      {
        switch (arg)
          {
          case 1: /* erase from beginning of line */
            e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_EL1, 1);
            break;
          case 2: /* erase all line */
            if (d->terminal_col != 0)
              break;
          case 0: /* erase to end of line */
            e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_EL, 1);
            break;
          }
        break;
      }

    case TERMINAL_WINDOW_OP:
      {
        int window_op = arg & ((1<<8)-1);
        int arg1 = (arg >> 8) & ((1<<12)-1);
        int arg2 = (arg >> 20) & ((1<<12)-1);

        if (text_arg != NULL)
          {
            ___C c;

            e = lineeditor_output_cap1
                  (d,
                   LINEEDITOR_CAP_WINDOW_OP3,
                   window_op,
                   1);

            while (e == ___FIX(___NO_ERR) &&
                   *text_arg != ___UNICODE_NUL)
              {
                c = *text_arg++;
                e = lineeditor_output (d, &c, 1);
              }

            if (e == ___FIX(___NO_ERR))
              {
                c = ___UNICODE_BELL;
                e = lineeditor_output (d, &c, 1);
              }
          }
        else
          {
            switch (window_op)
              {
              case 1: /* De-iconify window */
              case 2: /* Iconify window */
              case 5: /* Raise the window to the front of the stacking order */
              case 6: /* Lower the window to the bottom of the stacking order */
              case 7: /* Refresh the window */
                e = lineeditor_output_cap1
                      (d,
                       LINEEDITOR_CAP_WINDOW_OP0,
                       window_op,
                       1);
                break;

              case 9: /* Maximize or un-maximize window (arg1=0 or arg1=1) */
                e = lineeditor_output_cap2
                      (d,
                       LINEEDITOR_CAP_WINDOW_OP1,
                       window_op,
                       arg1,
                       1);
                break;

              case 3: /* Move window to [arg1, arg2] */
              case 4: /* Resize window to height=arg1 and width=arg2 in pixels */
              case 8: /* Resize window to height=arg1 and width=arg2 in chars */
                e = lineeditor_output_cap3
                      (d,
                       LINEEDITOR_CAP_WINDOW_OP2,
                       window_op,
                       arg1,
                       arg2,
                       1);
                break;
              }
          }

        break;
      }

#endif

    case TERMINAL_MOVE_COL:
      {
        e = lineeditor_output_terminal_op_move_col (d, arg);
        break;
      }

    case TERMINAL_MOVE_ROW:
      {
        e = lineeditor_output_terminal_op_move_row (d, arg);
        break;
      }

    default:
      {
        if (op >= TERMINAL_MOVE_ABS)
          e = lineeditor_output_terminal_op_move_abs
                (d,
                 arg,
                 op - TERMINAL_MOVE_ABS);
        break;
      }
    }

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_output_terminal_emulate
   ___P((___device_tty *self,
         ___C *buf,
         int len),
        (self,
         buf,
         len)
___device_tty *self;
___C *buf;
int len;)
{
  /*
   * This routine processes a string of characters (possibly
   * containing control characters and escape sequences) that the
   * emulated terminal received.  It also tracks the movement of the
   * emulated terminal's cursor.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  int pn;
  ___C c;

#ifdef ___DEBUG_TTY

  {
    int i;

    ___printf ("lineeditor_output_terminal_emulate len: %d  ", len);

    ___printf ("\"");

    for (i=0; i<len; i++)
      if (buf[i] < 32 || buf[i] >= 127)
        ___printf ("\\x%02x", buf[i]);
      else
        ___printf ("%c", buf[i]);

    ___printf ("\"\n");
  }

#endif

  pn = d->terminal_param_num;

  while (len > 0)
    {
      ___C c = *buf++;

      len--;

      if (!d->editing_line)
        {
          /* accumulate prompt */

          int i = d->prompt_length;
          if (i < ___CAST(int,___NBELEMS(d->prompt)))
            {
              d->prompt[i] = c;
              d->prompt_length = i+1;
            }
        }

      switch (pn)
        {
        case -2:
          {
            /* outside of an escape sequence */

            if (c >= ___UNICODE_SPACE)
              {
                int n = 0;

                while (n < len && *buf >= ___UNICODE_SPACE)
                  {
                    n++;
                    buf++;
                  }

                if (!d->editing_line)
                  {
                    /* accumulate prompt */

                    ___C *p = buf - n;
                    int i = d->prompt_length;
                    while (i < ___CAST(int,___NBELEMS(d->prompt)) && p < buf)
                      d->prompt[i++] = *p++;
                    d->prompt_length = i;
                  }

                len -= n;
                n++;

                if ((e = lineeditor_output_terminal_plain_chars (d, buf-n, n))
                    != ___FIX(___NO_ERR))
                  {
                    d->terminal_param_num = pn;
                    return e;
                  }
              }
            else if (c != ___UNICODE_ESCAPE) /* non ESC control character? */
              {
                if (c == ___UNICODE_LINEFEED)
                  {
                    if (!d->editing_line)
                      d->prompt_length = 0; /* reset prompt */

                    /******** TODO: should check if cr-lf, etc is needed */

                    if ((e = lineeditor_output_terminal_op
                               (d,
                                TERMINAL_CTRL - c,
                                0,
                                NULL))
                        != ___FIX(___NO_ERR))
                      {
                        d->terminal_param_num = pn;
                        return e;
                      }
                  }
                else
                  {
                    if ((e = lineeditor_output_terminal_op
                               (d,
                                TERMINAL_CTRL - c,
                                0,
                                NULL))
                        != ___FIX(___NO_ERR))
                      {
                        d->terminal_param_num = pn;
                        return e;
                      }
                  }
              }
            else
              pn = -1; /* start of an escape sequence */

            break;
          }

        case -1:
          {
            /* after an ESC */

            if (c == '[')
              {
                d->terminal_op_type = 0;
                pn = 0;
                d->terminal_param[0] = 0;
              }
            else if (c == ']')
              {
                d->terminal_op_type = 1;
                pn = 0;
                d->terminal_param[0] = 0;
              }
            else
              pn = -2;

            break;
          }

        default:
          {
            /* accumulating parameters after an ESC '[' */

            if (d->terminal_op_type == 1 && pn == 1)
              {
                if (c == ___UNICODE_BELL)
                  {
                    pn = -2;

                    if ((e = lineeditor_output_terminal_op
                               (d,
                                TERMINAL_WINDOW_OP,
                                d->terminal_param[0],
                                d->terminal_param_text))
                        != ___FIX(___NO_ERR))
                      {
                        d->terminal_param_num = pn;
                        return e;
                      }
                  }
                else
                  {
                    if (d->terminal_param[1] <
                        ___CAST(int,___NBELEMS(d->terminal_param_text))-1)
                      d->terminal_param_text[d->terminal_param[1]++] = c;
                  }
              }
            else if (c >= '0' && c <= '9')
              {
                int x = c - '0';
                int p = d->terminal_param[pn];
                if (p < 1000)
                  d->terminal_param[pn] = p*10 + x;
              }
            else if (c == ';')
              {
                if (pn < ___CAST(int,___NBELEMS(d->terminal_param))-1)
                  pn++;
                d->terminal_param[pn] = 0;
              }
            else
              {
                int op = TERMINAL_NOOP;
                int arg = 0;

                if (c == 'A')
                  {
                    op = TERMINAL_MOVE_ROW;
                    arg = -d->terminal_param[0];
                    if (arg >= 0) arg = -1;
                  }
                else if (c == 'B')
                  {
                    op = TERMINAL_MOVE_ROW;
                    arg = d->terminal_param[0];
                    if (arg <= 0) arg = 1;
                  }
                else if (c == 'C')
                  {
                    op = TERMINAL_MOVE_COL;
                    arg = d->terminal_param[0];
                    if (arg <= 0) arg = 1;
                  }
                else if (c == 'D')
                  {
                    op = TERMINAL_MOVE_COL;
                    arg = -d->terminal_param[0];
                    if (arg >= 0) arg = -1;
                  }
                else if (c == 'H' || c == 'f')
                  {
                    op = d->terminal_param[0];
                    if (op <= 0) op = 1;
                    op += TERMINAL_MOVE_ABS - 1;
                    arg = d->terminal_param[1];
                    if (pn < 1 || arg <= 0) arg = 1;
                    arg--;
                  }
                else if (c == 'J')
                  {
                    op = TERMINAL_ERASE_DISP;
                    arg = d->terminal_param[0];
                    if (arg <= 0) arg = 0;
                  }
                else if (c == 'K')
                  {
                    op = TERMINAL_ERASE_LINE;
                    arg = d->terminal_param[0];
                    if (arg <= 0) arg = 0;
                  }
                else if (c == 'm')
                  {
                    int j;
                    int style;
                    int fg;
                    int bg;

                    op = TERMINAL_SET_ATTRS;
                    arg = d->current.attrs;
                    style = GET_STYLE(arg);
                    fg = GET_FOREGROUND_COLOR(arg);
                    bg = GET_BACKGROUND_COLOR(arg);

                    for (j=0; j<=pn; j++)
                      {
                        int x = d->terminal_param[j];
                        if (x <= 0)
                          {
                            style = TEXT_STYLE_NORMAL;
                            fg = DEFAULT_TEXT_COLOR;
                            bg = DEFAULT_TEXT_COLOR;
                          }
                        else if (x == 1)
                          style |= TEXT_STYLE_BOLD;
                        else if (x == 4)
                          style |= TEXT_STYLE_UNDERLINE;
                        else if (x == 7)
                          style |= TEXT_STYLE_REVERSE;
                        else if (x >= 30 && x <= 37)
                          fg = x-30;
                        else if (x >= 40 && x <= 47)
                          bg = x-40;
                        else if (x >= 90 && x <= 97)
                          fg = (x-90)+8;
                        else if (x >= 100 && x <= 107)
                          bg = (x-100)+8;
                        else if (x == 38 || x == 48)
                          {
                            if (j+2 <= pn && d->terminal_param[j+1] == 5)
                              {
                                int n = d->terminal_param[j+2];
                                if (n >= 0 && n <= 255)
                                  {
                                    if (x == 38)
                                      fg = n;
                                    else
                                      bg = n;
                                  }
                              }
                            j += 2;
                          }
                      }
                    arg = MAKE_TEXT_ATTRS(style,fg,bg);
                  }
                else if (c == 't')
                  {
                    switch (d->terminal_param[0])
                      {
                      case 3:
                      case 4:
                      case 8:
                        if (pn == 2 &&
                            d->terminal_param[1] <= 4095 &&
                            d->terminal_param[2] <= 4095)
                          {
                            arg = (d->terminal_param[2] << 20) +
                                  (d->terminal_param[1] << 8) +
                                  d->terminal_param[0];
                            op = TERMINAL_WINDOW_OP;
                          }
                        break;

                      case 9:
                        if (pn == 1 &&
                            d->terminal_param[1] <= 4095)
                          {
                            arg = (d->terminal_param[1] << 8) +
                                  d->terminal_param[0];
                            op = TERMINAL_WINDOW_OP;
                          }
                        break;

                      default:
                        if (pn == 0 &&
                            d->terminal_param[0] >= 1 &&
                            d->terminal_param[0] <= 9)
                          {
                            arg = d->terminal_param[0];
                            op = TERMINAL_WINDOW_OP;
                          }
                        break;
                      }
                  }

                pn = -2;

                if ((e = lineeditor_output_terminal_op (d, op, arg, NULL))
                    != ___FIX(___NO_ERR))
                  {
                    d->terminal_param_num = pn;
                    return e;
                  }
              }

            break;
          }
        }
    }

  d->terminal_param_num = pn;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_output_chars
   ___P((___device_tty *self,
         ___C *buf,
         ___stream_index len,
         tty_text_attrs attrs),
        (self,
         buf,
         len,
         attrs)
___device_tty *self;
___C *buf;
___stream_index len;
tty_text_attrs attrs;)
{
  /*
   * This routine outputs "len" characters from the buffer "buf" using
   * the text attributes "attrs".
   */

  ___device_tty *d = self;
  ___SCMOBJ e;

  if ((e = lineeditor_output_set_attrs (d, attrs))
      == ___FIX(___NO_ERR))
    e = lineeditor_output (d, buf, len);

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_output_char_repetition
   ___P((___device_tty *self,
         ___C c,
         int rep,
         tty_text_attrs attrs),
        (self,
         c,
         rep,
         attrs)
___device_tty *self;
___C c;
int rep;
tty_text_attrs attrs;)
{
  /*
   * This routine outputs the character "c" a total of "rep" times
   * using the text attributes "attrs".
   */

#define CHAR_BUFFER_SIZE (80*50)

  ___device_tty *d = self;
  ___SCMOBJ e;
  ___C char_buffer[CHAR_BUFFER_SIZE];
  int n;

  n = rep;
  if (n > CHAR_BUFFER_SIZE)
    n = CHAR_BUFFER_SIZE;

  while (n > 0)
    char_buffer[--n] = c;

  while (rep > 0)
    {
      n = rep;
      if (n > CHAR_BUFFER_SIZE)
        n = CHAR_BUFFER_SIZE;
      if ((e = lineeditor_output_chars (d, char_buffer, n, attrs))
          != ___FIX(___NO_ERR))
        return e;
      rep -= n;
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN tty_text_attrs lineeditor_erase_attrs
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * This routine returns the text attributes that should be used to
   * erase portions of the screen.
   */

  ___device_tty *d = self;

  return d->output_attrs;
}


___HIDDEN ___SCMOBJ lineeditor_output_current_hist
   ___P((___device_tty *self,
         int start,
         int len),
        (self,
         start,
         len)
___device_tty *self;
int start;
int len;)
{
  /*
   * This routine sends to the terminal "len" characters of the line
   * being edited starting at position "start".  The line is logically
   * padded with spaces at both ends (so that a negative "start"
   * outputs spaces first and if "start+len" is beyond the end of the
   * line some spaces will be output at the end).
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int spaces_at_head;
  int chars_from_line;

  spaces_at_head = -start;

  if (spaces_at_head < 0)
    spaces_at_head = 0;
  else
    {
      if (spaces_at_head > len)
        spaces_at_head = len;
      start += spaces_at_head;
      len -= spaces_at_head;
    }

  chars_from_line = edited->length - start;

  if (chars_from_line < 0)
    chars_from_line = 0;
  else
    {
      if (chars_from_line > len)
        chars_from_line = len;
      len -= chars_from_line;
    }

  if (spaces_at_head > 0)
    if ((e = lineeditor_output_char_repetition
               (d,
                ___UNICODE_SPACE,
                spaces_at_head,
                lineeditor_erase_attrs (d)))
        != ___FIX(___NO_ERR))
      return e;

  if (chars_from_line > 0)
    if ((e = lineeditor_output_chars
               (d,
                &edited->buffer[start],
                chars_from_line,
                d->input_attrs))
        != ___FIX(___NO_ERR))
      return e;

  if (len > 0)
    if ((e = lineeditor_output_char_repetition
               (d,
                ___UNICODE_SPACE,
                len,
                lineeditor_erase_attrs (d)))
        != ___FIX(___NO_ERR))
      return e;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_output_force_delayed_wrap
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * This routine forces the cursor to wrap to the next line if the
   * wrap was delayed.
   */

  ___device_tty *d = self;

  if (d->terminal_delayed_wrap)
    return lineeditor_output_current_hist
             (d,
              d->terminal_cursor + 1 - d->current.line_start,
              1);

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_move_cursor_plain
   ___P((___device_tty *self,
         int dist),
        (self,
         dist)
___device_tty *self;
int dist;)
{
  /*
   * This routine sends the appropriate commands to the terminal to
   * move the cursor "dist" positions forward/backward by writing
   * plain characters or backspace characters.  We assume that the
   * terminal has auto left/right margins if the cursor needs to
   * change row.
   */

  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

  if (dist != 0)
    {
      if (dist < 0)
        e = lineeditor_output_char_repetition
              (d,
               ___UNICODE_BACKSPACE,
               -dist,
               d->current.attrs);
      else
        {
          ___BOOL need_backspace = ((d->terminal_cursor + dist
                                     % d->terminal_nb_cols == 0)
                                    && d->has_eat_newline_glitch);

          if ((e = lineeditor_output_current_hist
                     (d,
                      d->terminal_cursor + d->terminal_delayed_wrap
                      - d->current.line_start,
                      dist - d->terminal_delayed_wrap + need_backspace))
              == ___FIX(___NO_ERR))
            {
              if (need_backspace)
                e = lineeditor_output_char_repetition
                      (d,
                       ___UNICODE_BACKSPACE,
                       1,
                       d->current.attrs);
            }
        }
    }

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_move_cursor
   ___P((___device_tty *self,
         int screen_pos),
        (self,
         screen_pos)
___device_tty *self;
int screen_pos;)
{
  /*
   * This routine sends the appropriate commands to the terminal to
   * move the cursor to position "screen_pos".
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  int cursor = d->terminal_cursor;

#ifdef USE_CURSES

  int col = screen_pos % d->terminal_nb_cols;
  int col_dist = col - d->terminal_col;
  int row_dist = screen_pos / d->terminal_nb_cols - d->terminal_row;

  if (screen_pos <= cursor)
    {
      /*
       * Check if the cursor can be moved backward by writing no more
       * than 4 backspace characters (if on the same row or column) or
       * 8 backspace characters (otherwise).  This is probably no more
       * than is required by cursor movement commands.
       */

      if ((row_dist == 0 || d->has_auto_left_margin) &&
          cursor - screen_pos <= ((row_dist == 0 || col_dist == 0) ? 4 : 8))
        return lineeditor_move_cursor_plain (self, screen_pos - cursor);
    }
  else
    {
      /*
       * Check if the cursor can be moved forward by writing no more
       * than 4 plain characters (if on the same row or column) or 8
       * plain characters (otherwise).  This is probably no more than
       * is required by cursor movement commands.
       */

      if ((row_dist == 0 || d->has_auto_right_margin) &&
          screen_pos - (cursor + d->terminal_delayed_wrap)
          + ((col == 0 && d->has_eat_newline_glitch) ? 2 : 0)
          <= ((row_dist == 0 || col_dist == 0) ? 4 : 8))
        return lineeditor_move_cursor_plain (self, screen_pos - cursor);
    }

  /*
   * Move the cursor to the target column.
   */

  if ((col_dist >= -4) && (col_dist <= 4))
    {
      /* Use plain characters if not too far. */

      if ((e = lineeditor_move_cursor_plain (self, col_dist))
          != ___FIX(___NO_ERR))
        return e;

      cursor += col_dist;
      col_dist = 0;
    }
  else
    {
      /* Use cursor commands if the terminal supports this. */

      if (lineeditor_cap (d,
                          (col_dist > 0)
                          ? LINEEDITOR_CAP_CUF
                          : LINEEDITOR_CAP_CUB)
          != NULL)
        {
          if ((e = lineeditor_output_cap1
                     (d,
                      (col_dist > 0) ? LINEEDITOR_CAP_CUF : LINEEDITOR_CAP_CUB,
                      (col_dist > 0) ? col_dist : -col_dist,
                      1))
              != ___FIX(___NO_ERR))
            return e;

          cursor += col_dist;
          col_dist = 0;
        }
    }

  /*
   * Move the cursor to the target row using cursor movement commands,
   * if the terminal supports this.
   */

  if (row_dist != 0 &&
      ((row_dist > 0)
       ? (lineeditor_cap (d, LINEEDITOR_CAP_CUD) != NULL ||
          lineeditor_cap (d, LINEEDITOR_CAP_CUD1) != NULL)
       : (lineeditor_cap (d, LINEEDITOR_CAP_CUU) != NULL ||
          lineeditor_cap (d, LINEEDITOR_CAP_CUU1) != NULL)))
    {
      if ((row_dist > 0)
          ? (lineeditor_cap (d, LINEEDITOR_CAP_CUD) == NULL ||
             (lineeditor_cap (d, LINEEDITOR_CAP_CUD1) != NULL &&
              row_dist == 1))
          : (lineeditor_cap (d, LINEEDITOR_CAP_CUU) == NULL ||
             (lineeditor_cap (d, LINEEDITOR_CAP_CUU1) != NULL &&
              row_dist == -1)))
        e = lineeditor_output_cap0
              (d,
               (row_dist > 0) ? LINEEDITOR_CAP_CUD1 : LINEEDITOR_CAP_CUU1,
               (row_dist > 0) ? row_dist : -row_dist);
      else
        e = lineeditor_output_cap1
              (d,
               (row_dist > 0) ? LINEEDITOR_CAP_CUD : LINEEDITOR_CAP_CUU,
               (row_dist > 0) ? row_dist : -row_dist,
               1);

      if (e != ___FIX(___NO_ERR))
        return e;

      /* Cursor commands to change row were successful. */

      cursor += row_dist * d->terminal_nb_cols;
    }

#endif

  /*
   * If the cursor is still not at the target position, move the
   * cursor by writing plain characters or backspace characters.
   */

  return lineeditor_move_cursor_plain (self, screen_pos - cursor);
}


___HIDDEN ___SCMOBJ lineeditor_left_margin_of_next_row
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;

  if (!(d->linefeed_moves_to_left_margin || !d->output_raw))
    if ((e = lineeditor_output_char_repetition
               (d,
                ___UNICODE_RETURN,
                1,
                d->output_attrs))
        != ___FIX(___NO_ERR))
      return e;

  return lineeditor_output_char_repetition
           (d,
            ___UNICODE_LINEFEED,
            1,
            d->output_attrs);
}


___HIDDEN ___SCMOBJ lineeditor_prepare_to_write_at
   ___P((___device_tty *self,
         int screen_pos),
        (self,
         screen_pos)
___device_tty *self;
int screen_pos;)
{
  /*
   * This routine sends commands to the terminal such that the next
   * character sent to the terminal will show up at screen position
   * "screen_pos".  The position can be equal to the size of the
   * screen, in which case either the screen is scrolled right away or
   * the next character sent to the terminal will cause the screen to
   * scroll.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  int screen_size = d->terminal_size;
  int cursor = d->terminal_cursor;

  if (screen_pos > screen_size)
    screen_pos = screen_size;

  if (cursor + d->terminal_delayed_wrap == screen_pos)
    e = ___FIX(___NO_ERR); /* next character will be at the right place */
  else if (screen_pos == screen_size)
    {
      if ((e = lineeditor_move_cursor (d, screen_pos-1))
          == ___FIX(___NO_ERR))
        e = lineeditor_output_current_hist
              (d,
               screen_pos - 1 - d->current.line_start,
               1);
    }
  else
    {
      if ((e = lineeditor_move_cursor (d, screen_pos))
          == ___FIX(___NO_ERR))
        {
          if (d->terminal_delayed_wrap)
            {
              /*
               * Output a backspace and a character.  Note that this
               * assumes the screen is at least 2 columns wide.
               */

              if ((e = lineeditor_output_char_repetition
                         (d,
                          ___UNICODE_BACKSPACE,
                          1,
                          d->current.attrs))
                  == ___FIX(___NO_ERR))
                e = lineeditor_output_current_hist
                      (d,
                       screen_pos - 1 - d->current.line_start,
                       1);
            }
        }
    }

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_newline
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * This routine moves the cursor to the left margin of the row
   * following the last visible part of the line being edited.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int screen_size = d->terminal_size;
  int screen_end_of_line = d->current.line_start + edited->length;

  if (screen_end_of_line < 0)
    screen_end_of_line = 0;
  else if (screen_end_of_line >= screen_size)
    screen_end_of_line = screen_size - 1;

  if ((e = lineeditor_prepare_to_write_at (d, screen_end_of_line))
      != ___FIX(___NO_ERR))
    return e;

  return lineeditor_left_margin_of_next_row (d);
}


___HIDDEN ___SCMOBJ lineeditor_copy_to_clipboard
   ___P((___device_tty *self,
         ___C *buf,
         int len),
        (self,
         buf,
         len)
___device_tty *self;
___C *buf;
int len;)
{
  /*
   * Copies "len" characters from the buffer "buf" to the clipboard.
   */

  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

#ifdef LINEEDITOR_WITH_LOCAL_CLIPBOARD

  extensible_string str;

  if ((e = extensible_string_copy (buf, len, &str, 0)) == ___FIX(___NO_ERR))
    {
      extensible_string_cleanup (&d->clipboard);
      d->clipboard = str;
    }

#else

#ifdef USE_WIN32

  HWND cons_wind = GetConsoleWindow ();

  if (cons_wind != NULL)
    {
      if (OpenClipboard (cons_wind))
        {
          HGLOBAL global_copy = GlobalAlloc (GMEM_MOVEABLE,
                                             (len+1) * sizeof(___U16));

          if (global_copy != NULL)
            {
              ___U16 *locked_copy = ___CAST(___U16*,GlobalLock (global_copy));

              if (locked_copy == NULL)
                GlobalFree (global_copy);
              else
                {
                  int i;

                  for (i=0; i<len; i++)
                    locked_copy[i] = buf[i];
                  locked_copy[len] = 0;

                  GlobalUnlock (global_copy);

                  EmptyClipboard ();

                  if (!SetClipboardData (CF_UNICODETEXT, global_copy))
                    GlobalFree (global_copy);
                }
            }

          CloseClipboard ();
        }
    }

#endif

#endif

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_paste_from_clipboard
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * Paste the content of the clipboard to the input stream (the next
   * characters read from the terminal will in fact come from the
   * pasted text).
   */

  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

#ifdef LINEEDITOR_WITH_LOCAL_CLIPBOARD

  int len = d->clipboard.length;
  ___C *str;

  str = ___CAST(___C*,
                ___ALLOC_MEM((len+1) * sizeof (___C)));

  if (str == NULL)
    e = ___FIX(___HEAP_OVERFLOW_ERR);
  else
    {
      str[len] = 0;
      while (len-- > 0)
        str[len] = d->clipboard.buffer[len];

      if (d->paste_text != NULL)
        ___FREE_MEM(d->paste_text);

      d->paste_index = 0;
      d->paste_text = str;
    }

#else

#ifdef USE_WIN32

  HWND cons_wind = GetConsoleWindow ();

  if (cons_wind != NULL)
    {
      if (IsClipboardFormatAvailable (CF_UNICODETEXT) &&
          OpenClipboard (cons_wind))
        {
          HGLOBAL global_copy = GetClipboardData (CF_UNICODETEXT);

          if (global_copy != NULL)
            {
              ___U16 *locked_copy = ___CAST(___U16*,GlobalLock (global_copy));

              if (locked_copy != NULL)
                {
                  int i;
                  ___C *str;
                  int len = 0;

                  while (locked_copy[len] != 0)
                    len++;

                  str = ___CAST(___C*,
                                ___ALLOC_MEM((len+1) * sizeof (___C)));

                  if (str == NULL)
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                  else
                    {
                      str[len] = 0;
                      while (len-- > 0)
                        str[len] = locked_copy[len];

                      if (d->paste_text != NULL)
                        ___FREE_MEM(d->paste_text);

                      d->paste_index = 0;
                      d->paste_text = str;
                    }

                  GlobalUnlock (locked_copy);
                }
            }

          CloseClipboard ();
        }
    }

#endif

#endif

  return e;
}


___HIDDEN ___BOOL lineeditor_read_ready
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  return (d->input_char_hi - d->input_char_lo > 0)
         || (d->paste_text != NULL);
}


___HIDDEN ___SCMOBJ lineeditor_input_read
   ___P((___device_tty *self,
         ___C *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (self,
         buf,
         len,
         len_done)
___device_tty *self;
___C *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___device_tty *d = self;
  int char_avail = d->input_char_hi - d->input_char_lo;

  if (char_avail <= 0)
    {
      /*
       * There are no characters in the character input buffer so we
       * must fill the buffer by reading the device.  If possible,
       * characters will be extracted from the byte input buffer
       * without reading new bytes from the device, otherwise the
       * device will be read.  If a read error occurs (including
       * EAGAIN) an error code is returned, otherwise ___NO_ERR is
       * returned.  ___NO_ERR is returned if and only if at least one
       * character was added to the character buffer, or no character
       * was added because EOF was reached.
       */

      ___SCMOBJ e;
      ___stream_index len;
      ___stream_index done = 0;
      ___U8 *byte_buf;
      int byte_buf_avail;
      int char_buf_avail;
      int lo;
      int code;

      /*
       * Make space at end of byte buffer by shifting remaining bytes to
       * the head of the buffer.
       */

      lo = d->input_byte_lo;

      if (lo > 0)
        {
          int hi = d->input_byte_hi;
          int i = 0;

          while (lo < hi)
            d->input_byte[i++] = d->input_byte[lo++];

          d->input_byte_lo = 0;
          d->input_byte_hi = i;
        }

      do
        {
          /*
           * Read as many bytes as possible into the byte buffer.
           */

          if ((e = ___device_tty_read_raw_no_lineeditor
                     (d,
                      d->input_byte + d->input_byte_hi,
                      ___NBELEMS(d->input_byte) - d->input_byte_hi,
                      &done))
              != ___FIX(___NO_ERR))
            return e;

          if (done == 0)
            {
              if (d->input_byte_hi > d->input_byte_lo)
                {
                  d->input_byte_lo = 0;
                  d->input_byte_hi = 0;
                  return ___FIX(___UNKNOWN_ERR);
                }
              else
                {
                  *len_done = 0;
                  return ___FIX(___NO_ERR);
                }
            }

          byte_buf_avail = (d->input_byte_hi += done) - d->input_byte_lo;

          /*
           * Extract as many characters as possible from byte buffer to
           * character buffer.
           */

          if (byte_buf_avail > 0)
            {
              char_buf_avail = ___NBELEMS(d->input_char);

              code = chars_from_bytes (d->input_char,
                                       &char_buf_avail,
                                       d->input_byte + d->input_byte_lo,
                                       &byte_buf_avail,
                                       &d->input_decoding_state);

              d->input_char_lo = 0;
              d->input_char_hi = ___NBELEMS(d->input_char) - char_buf_avail;

              if (byte_buf_avail <= 0)
                {
                  d->input_byte_lo = 0;
                  d->input_byte_hi = 0;
                }
              else
                d->input_byte_lo = d->input_byte_hi - byte_buf_avail;

              if (code == ___ILLEGAL_CHAR)
                return ___FIX(___UNKNOWN_ERR);
            }
          else
            code = ___INCOMPLETE_CHAR;

        } while (code != ___CONVERSION_DONE);

      /*
       * This point is reached if and only if there is at least one
       * character in the character buffer.
       */

      char_avail = d->input_char_hi - d->input_char_lo;
    }

  if (char_avail > len)
    char_avail = len;

  *len_done = char_avail;

  while (char_avail > 0)
    {
      *buf++ = d->input_char[d->input_char_lo++];
      char_avail--;
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_get_event
   ___P((___device_tty *self,
         lineeditor_event *ev),
        (self,
         ev)
___device_tty *self;
lineeditor_event *ev;)
{
  /*
   * This routine obtains the next line editing event from the
   * terminal.  An event can be a key press or some editing operation
   * (like "delete next word").
   */

  ___device_tty *d = self;
  lineeditor_input_decoder_state s = d->input_decoder_state;
  ___C c;
  ___BOOL first_char;
  ___stream_index len_done;
  ___SCMOBJ e;

  first_char = (s == 0);

  if (d->paste_text != NULL)
    {
      if (d->paste_cancel ||
          (c = d->paste_text[d->paste_index++]) == 0)
        {
          ___FREE_MEM(d->paste_text);
          d->paste_text = NULL;
        }
      else
        {
          ev->event_kind = LINEEDITOR_EV_KEY;
          ev->event_char = c;
          return ___FIX(___NO_ERR);
        }
    }

  next_char:

  if ((e = lineeditor_input_read (d, &c, 1, &len_done)) == ___FIX(___NO_ERR))
    {
      if (len_done == 1)
        {
          while (s < d->input_decoder.length)
            {
              if (d->input_decoder.buffer[s].trigger == c)
                {
                  int a = d->input_decoder.buffer[s].action;
                  if (a < LINEEDITOR_INPUT_DECODER_MAX_LENGTH)
                    {
                      s = a;
                      first_char = 0;
                      goto next_char;
                    }
                  d->input_decoder_state = 0;
                  ev->event_kind = LINEEDITOR_INPUT_DECODER_STATE_MAX-a;
                  return ___FIX(___NO_ERR);
                }
              else
                s = d->input_decoder.buffer[s].next;
            }
          if (first_char)
            {
              ev->event_kind = LINEEDITOR_EV_KEY;
              ev->event_char = c;
              return ___FIX(___NO_ERR);
            }
          s = 0; /* ignore the sequence including last character read */
        }
      else
        {
          /*
           * EOF was reached.
           */

          d->input_decoder_state = 0;
          ev->event_kind = LINEEDITOR_EV_EOF;
          return ___FIX(___NO_ERR);
        }
    }

  d->input_decoder_state = s;
  ev->event_kind = LINEEDITOR_EV_NONE;

  if (e != ___FIX(___NO_ERR) && e != ___ERR_CODE_EAGAIN)
    return e;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_set_terminal_type
   ___P((___device_tty *self,
         char *terminal_type,
         ___BOOL emacs_bindings),
        (self,
         terminal_type,
         emacs_bindings)
___device_tty *self;
char *terminal_type;
___BOOL emacs_bindings;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;

  /* default values appropriate for "xterm": */

  int rows = 24;
  int cols = TERMINAL_NB_COLS_UNLIMITED;
  ___BOOL has_auto_left_margin = 0;
  ___BOOL has_auto_right_margin = 1;
  ___BOOL has_eat_newline_glitch = 1;

#ifdef USE_CURSES

  int i;

#ifdef USE_TERMCAP_OR_TERMINFO

  if (terminal_type != NULL)
    {
#ifdef USE_TERMCAP

      char termcap_buffer[4080]; /* the value 4080 is used by GNU's readline */

      if (tgetent (termcap_buffer, terminal_type) != 1)
        return ___FIX(___UNKNOWN_ERR);

      rows = tgetnum ("li");
      cols = tgetnum ("co");
      has_auto_left_margin = (tgetflag ("bw") != 0);
      has_auto_right_margin = (tgetflag ("am") != 0);
      has_eat_newline_glitch = (tgetflag ("xn") != 0);

#else

      int errret;

      if (setupterm (terminal_type, 1, &errret) == ERR)
        return ___FIX(___UNKNOWN_ERR);

      rows = tigetnum ("lines");
      cols = tigetnum ("cols");
      has_auto_left_margin = (tigetflag ("bw") != 0);
      has_auto_right_margin = (tigetflag ("am") != 0);
      has_eat_newline_glitch = (tigetflag ("xenl") != 0);

#endif
    }

#endif

  /*
   * Setup the capability table.
   */

  for (i=0; i<LINEEDITOR_CAP_LAST+1; i++)
    {
      char *seq = d->capability[i];

      if (seq != NULL)
        {
          ___FREE_MEM(seq);
          d->capability[i] = NULL;
        }
    }

  for (i=0; i<LINEEDITOR_CAP_LAST+1; i++)
    {
      char *seq;

#ifdef USE_TERMCAP_OR_TERMINFO

      if (terminal_type != NULL)
        {
#ifdef USE_TERMCAP

          seq = tgetstr (lineeditor_dcap_table[i].cap, NULL);

#else

          seq = tigetstr (lineeditor_dcap_table[i].cap);

#endif
        }
      else
        seq = lineeditor_dcap_table[i].xterm_cap;

#else

      seq = lineeditor_dcap_table[i].cap;

#endif

      if (seq != (char*)-1 && seq != NULL)
        {
#ifdef ___DEBUG_TTY

          int j = -1;

          ___printf ("cap %d = ", i);

          while (seq[++j] != '\0')
            if (seq[j] < ' ')
              ___printf ("\\%03o", seq[j]);
            else
              ___printf ("%c", seq[j]);

          ___printf ("\n");

#endif

          /*
           * Reject any sequence that includes a linefeed if the
           * terminal driver automatically adds a carriage return.
           */

          if (d->linefeed_moves_to_left_margin)
            {
              char *p = seq;
              while (*p != '\0')
                if (*p != ___UNICODE_LINEFEED)
                  p++;
                else
                  break;
              if (*p != '\0')
                seq = NULL;
            }

          /*
           * Keep a copy of the sequence.
           */

          if (seq != NULL)
            {
              char *p;
              int len = 0;
              while (seq[len] != '\0')
                len++;
              p = ___CAST(char*,___ALLOC_MEM(len+1));
              if (p != NULL)
                {
                  p[len] = '\0';
                  while (len-- > 0)
                    p[len] = seq[len];
                }
              d->capability[i] = p;
            }
          else
            d->capability[i] = NULL;
        }
      else
        d->capability[i] = NULL;
    }

#endif

  /*
   * Initialize input decoder so that it recognizes special keys.  Map
   * rubout key to backspace if not on WIN32.
   */

  d->input_decoder_state = 0;

  if ((e = lineeditor_input_decoder_init
             (&d->input_decoder,
#ifdef USE_WIN32
              0,
#else
              1,
#endif
              emacs_bindings,
              terminal_type == NULL))
      != ___FIX(___NO_ERR))
    return e;

  if (rows <= 0)
    rows = 24;
  if (cols <= 0)
    cols = TERMINAL_NB_COLS_UNLIMITED;

  d->terminal_nb_cols = cols;
  d->terminal_nb_rows = rows;
  d->terminal_size = rows * cols;
  d->has_auto_left_margin = has_auto_left_margin;
  d->has_auto_right_margin = has_auto_right_margin;
  d->has_eat_newline_glitch = has_eat_newline_glitch;
  d->size_needs_update = 1;

#ifdef ___DEBUG_TTY

  ___printf ("terminal_type=%s rows=%d cols=%d alm=%d arm=%d eng=%d\n",
             terminal_type,
             rows,
             cols,
             has_auto_left_margin,
             has_auto_right_margin,
             has_eat_newline_glitch);

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_default_options_virt
   ___P((___device_stream *self),
        ());


___HIDDEN ___SCMOBJ lineeditor_setup
   ___P((___device_tty *self,
         int plain),
        (self,
         plain)
___device_tty *self;
int plain;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  lineeditor_history *h;
  ___SCMOBJ default_options =
    ___INT(___device_tty_default_options_virt (&d->base));

  if (plain || d->stage == TTY_STAGE_NOT_OPENED)
    {
      /* Console */

      d->input_allow_special = 1;
      d->input_echo = 1;
      d->input_raw = 0;
      d->output_raw = 0;
      d->speed = 0;
    }
  else
    {
      /* TTY other than console */

      d->input_allow_special = 0;
      d->input_echo = 0;
      d->input_raw = 1;
      d->output_raw = 1;
      d->speed = 0;
    }

  d->lineeditor_mode = LINEEDITOR_MODE_DISABLE;

  if (lineeditor_under_emacs ())
    d->input_echo = 0;
#if defined(USE_POSIX) || defined(USE_WIN32) || defined(USE_tcgetsetattr)
  else
    {
      if (___TERMINAL_LINE_EDITING(___GSTATE->setup_params.io_settings[___IO_SETTINGS_TERMINAL]) !=
          ___TERMINAL_LINE_EDITING_OFF)
        d->lineeditor_mode = LINEEDITOR_MODE_SCHEME;
    }
#endif

  /* for terminal emulation */

  d->emulate_terminal = 1;

  d->terminal_nb_cols = TERMINAL_NB_COLS_UNLIMITED;
  d->terminal_nb_rows = 24;
  d->terminal_size = d->terminal_nb_rows * d->terminal_nb_cols;
  d->has_auto_left_margin = 0;
  d->has_auto_right_margin = 1;
  d->has_eat_newline_glitch = 1;
  d->linefeed_moves_to_left_margin = 0;

  d->terminal_col = 0;
  d->terminal_row = 0;
  d->terminal_cursor = 0;
  d->terminal_delayed_wrap = 0;

  d->terminal_param_num = -2;

  d->terminal_attrs = MAKE_TEXT_ATTRS(TEXT_STYLE_NORMAL,
                                      DEFAULT_TEXT_COLOR,
                                      DEFAULT_TEXT_COLOR);

  /* input and output buffers */

  d->input_byte_lo = 0;
  d->input_byte_hi = 0;
  d->input_char_lo = 0;
  d->input_char_hi = 0;

  d->input_decoding_state = ___STREAM_OPTIONS_INPUT(default_options);
  d->input_encoding_state = ___STREAM_OPTIONS_INPUT(default_options);

  d->input_line_lo = 0;
  d->input_line.buffer = NULL;
  d->input_line.length = 0;

  d->output_byte_lo = 0;
  d->output_byte_hi = 0;

  d->output_char_incomplete = 0;
  d->input_char_incomplete  = 0;

  d->output_decoding_state = ___STREAM_OPTIONS_OUTPUT(default_options);
  d->output_encoding_state = ___STREAM_OPTIONS_OUTPUT(default_options);

  d->output_char_lo = 0;

  /* line editing */

  d->editing_line = 0;

  d->prompt_length = 0;

  d->lineeditor_input_byte_lo = 0;
  d->lineeditor_input_byte_hi = 0;

  d->paste_cancel = 0;
  d->paste_index = 0;
  d->paste_text = NULL;

  d->history_max_length = 1000000000; /* set a very high limit */
  d->history_length = -1;
  d->hist_last = NULL;

  d->current.edit_point = 0;
  d->current.completion_point = 0;
  d->current.mark_point = 0;
  d->current.line_start = 0;
  d->current.paren_balance_trigger = 0;
  d->current.paren_balance_in_progress = 0;
  d->current.attrs = INITIAL_TEXT_ATTRS;

  d->paren_balance_duration_nsecs = DEFAULT_PAREN_BALANCE_DURATION_NSECS;

  d->input_attrs = DEFAULT_INPUT_TEXT_ATTRS;
  d->output_attrs = DEFAULT_OUTPUT_TEXT_ATTRS;

#ifdef USE_CURSES

  {
    int i;
    for (i=0; i<LINEEDITOR_CAP_LAST+1; i++)
      d->capability[i] = NULL;
  }

#endif

#ifdef USE_WIN32

  d->key_seq = NULL;

#endif

#ifdef LINEEDITOR_WITH_LOCAL_CLIPBOARD
  if ((e = extensible_string_setup (&d->clipboard, 0))
      == ___FIX(___NO_ERR))
    {
#endif
      if ((e = extensible_string_setup (&d->output_char, 0))
          == ___FIX(___NO_ERR))
        {
          if ((e = lineeditor_input_decoder_setup (&d->input_decoder))
              == ___FIX(___NO_ERR))
            {
              if ((e = lineeditor_history_setup (d, &h))
                  == ___FIX(___NO_ERR))
                {
                  lineeditor_history_add_last (d, h);
                  d->current.hist = h;
                  if ((e = lineeditor_history_begin_edit (d, h))
                      == ___FIX(___NO_ERR))
                    {
                      if ((e = lineeditor_set_terminal_type
                                 (d,
                                  NULL,
                                  DEFAULT_EMACS_BINDINGS))
                          == ___FIX(___NO_ERR))
                        {
                          return ___FIX(___NO_ERR);
                        }
                    }
                  d->history_max_length = -1;
                  lineeditor_history_trim (d);
                }
              lineeditor_input_decoder_cleanup (&d->input_decoder);
            }
          extensible_string_cleanup (&d->output_char);
        }
#ifdef LINEEDITOR_WITH_LOCAL_CLIPBOARD
      extensible_string_cleanup (&d->clipboard);
    }
#endif

  return e;
}


___HIDDEN void lineeditor_cleanup
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  lineeditor_output_set_attrs
    (d,
     INITIAL_TEXT_ATTRS); /* ignore error */

  lineeditor_output_drain (d); /* ignore error */

#ifdef USE_CURSES
  {
    int i;

    for (i=0; i<LINEEDITOR_CAP_LAST+1; i++)
      {
        char *seq = d->capability[i];
        if (seq != NULL)
          ___FREE_MEM(seq);
      }
  }
#endif

  d->history_max_length = -1;
  lineeditor_history_trim (d);

  lineeditor_input_decoder_cleanup (&d->input_decoder);

  extensible_string_cleanup (&d->output_char);

#ifdef LINEEDITOR_WITH_LOCAL_CLIPBOARD
  extensible_string_cleanup (&d->clipboard);
#endif

  if (d->input_line.buffer != NULL)
    extensible_string_cleanup (&d->input_line);

  if (d->paste_text != NULL)
    ___FREE_MEM(d->paste_text); /* discard paste text */

#if 0
  /******************** device should be freed elsewhere */
  ___FREE_MEM(d);
#endif
}


/*
 * Each character position of the screen is identified by an integer
 * from 0 to nb_rows * nb_cols - 1.  Screen position 0 is at the top
 * left.  This numbering is logically extended beyond the actual
 * screen limits.  If we assume that the screen is 10 columns by 4
 * rows we have this layout:
 *
 *
 *           ...  -8  -7  -6  -5  -4  -3  -2  -1
 *                                                 OFF SCREEN
 *       +---+---+---+---+---+---+---+---+---+---+^^^^^^^^^^^^
 *       | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | \
 *       +---+---+---+---+---+---+---+---+---+---+  |
 *       |10 |11 |12 |13 |14 |15 |16 |17 |18 |19 |  |
 *       +---+---+---+---+---+---+---+---+---+---+   >  SCREEN
 *       |20 |21 |22 |23 |24 |25 |26 |27 |28 |29 |  |
 *       +---+---+---+---+---+---+---+---+---+---+  |
 *       |30 |31 |32 |33 |34 |35 |36 |37 |38 |39 | /
 *       +---+---+---+---+---+---+---+---+---+---+vvvvvvvvvvvv
 *                                                 OFF SCREEN
 *        40  41  42  43  44  45  46  47  ...
 *
 * The "cursor" position is the screen position where the cursor is
 * currently located.  The field terminal_cursor contains this
 * screen position (the fields terminal_col and terminal_row
 * indicate the column and row of the cursor).
 *
 * The line that is being edited usually fits completely on the screen
 * but if the line is very long some parts may not be visible.  When
 * an editing operation causes the cursor to move the edited line is
 * redisplayed so that the cursor stays visible.
 *
 * The editing "point" is the character position in the line being
 * edited where editing operations occur (inserting characters, etc).
 * The cursor is usually over the character at the editing point.
 * Some operations, notably parenthesis balancing and program output,
 * move the cursor over some other character than the editing point.
 *
 * The field "line_start" contains the (logical) screen position where
 * the edited line starts. Here is an example where the edited line
 * starts at screen position 18 and is 15 characters long.
 *
 *       +---+---+---+---+---+---+---+---+---+---+
 *       | H | e | l | l | o | . |   |   |   |   |
 *       +---+---+---+---+---+---+---+---+---+---+
 *       | P | R | O | M | P | T | > |   | 0 | 1 |
 *       +---+---+---+---+---+---+---+---+---+---+
 *       | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |
 *       +---+---+---+---+---+---+---+---+---+---+
 *       |12 |13 |14 |   |   |   |   |   |   |   |
 *       +---+---+---+---+---+---+---+---+---+---+
 *
 * Here is an example where the edited line is larger than the
 * screen (the edited line starts at screen position -22 and
 * it contains 65 characters).
 *
 *
 *         P   R   O   M   P   T   >       0   1
 *
 *         2   3   4   5   6   7   8   9  10  11
 *
 *        12  13  14  15  16  17  18  19  20  21
 *                                                 OFF SCREEN
 *       +---+---+---+---+---+---+---+---+---+---+^^^^^^^^^^^^
 *       |22 |23 |24 |25 |26 |27 |28 |29 |30 |31 | \
 *       +---+---+---+---+---+---+---+---+---+---+  |
 *       |32 | . | . | . | . | . | . | . | . |41 |  |
 *       +---+---+---+---+---+---+---+---+---+---+   >  SCREEN
 *       |42 | . | . | . | . | . | . | . | . |51 |  |
 *       +---+---+---+---+---+---+---+---+---+---+  |
 *       |52 |53 |54 |55 |56 |57 |58 |59 |60 |61 | /
 *       +---+---+---+---+---+---+---+---+---+---+vvvvvvvvvvvv
 *                                                 OFF SCREEN
 *        62  63  64
 */


___HIDDEN ___SCMOBJ lineeditor_update_region
   ___P((___device_tty *self,
         int start,
         int end),
        (self,
         start,
         end)
___device_tty *self;
int start;
int end;)
{
  /*
   * This routine is called when a change in the line being edited
   * must be shown on the screen.  Characters between positions
   * "start" (inclusive) and "end" (exclusive) have changed.  Only the
   * changes that are visible cause the screen to be updated.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  int screen_size = d->terminal_size;
  int screen_start = d->current.line_start + start;
  int screen_end = d->current.line_start + end;

  if (!d->has_eat_newline_glitch)
    screen_size--; /* the last character on the screen can't be shown! */

  if (screen_start >= screen_size ||
      screen_end <= 0)
    e = ___FIX(___NO_ERR); /* the change is not visible */
  else
    {
      if (screen_start < 0)
        screen_start = 0;

      if (screen_end > screen_size)
        screen_end = screen_size;

      if ((e = lineeditor_prepare_to_write_at (d, screen_start))
          == ___FIX(___NO_ERR))
        e = lineeditor_output_current_hist
              (d,
               screen_start - d->current.line_start,
               screen_end - screen_start);
    }

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_output_prompt
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * This routine outputs the prompt that was output by the program
   * before line editing started.
   */

  ___device_tty *d = self;

  if (d->prompt_length < ___CAST(int,___NBELEMS(d->prompt)))
    return lineeditor_output (d, d->prompt, d->prompt_length);

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_move_edit_point
   ___P((___device_tty *self,
         int pos),
        (self,
         pos)
___device_tty *self;
int pos;)
{
  /*
   * Moves the editing point of the line being edited.  The screen
   * may get scrolled in order to keep the editing point visible.
   */

  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int cursor;
  int screen_nb_cols;
  int screen_nb_rows;
  int screen_size;
  int cursor_row;
  int first_row;
  int last_row;
  int scroll_rows;
  int all_fits;
  int n;
  int start;

  if (pos < 0 ||
      pos > edited->length)
    return ___FIX(___INVALID_OP_ERR);

  screen_nb_cols = d->terminal_nb_cols;
  screen_nb_rows = d->terminal_nb_rows;
  screen_size = d->terminal_size;
  cursor = d->current.line_start + pos; /* new cursor position in screen */

  cursor_row = cursor;
  if (cursor_row < 0)
    cursor_row -= screen_nb_cols - 1;
  cursor_row /= screen_nb_cols;

  first_row = d->current.line_start;
  if (first_row < 0)
    first_row -= screen_nb_cols - 1;
  first_row /= screen_nb_cols;

  last_row = d->current.line_start + edited->length;
  if (last_row < 0)
    last_row -= screen_nb_cols - 1;
  last_row /= screen_nb_cols;

  /*
   * Here is an example where the edited line contains 25 characters,
   * the edited line starts at position 18, and pos = 11:
   *
   *       +---+---+---+---+---+---+---+---+---+---+
   *       | H | e | l | l | o | . |   |   |   |   |
   *       +---+---+---+---+---+---+---+---+---+---+
   *       | P | R | O | M | P | T | > |   | 0 | 1 |   first_row = 1
   *       +---+---+---+---+---+---+---+---+---+---+
   *       | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |   cursor_row = 2
   *       +---+---+---+---+---+---+---+---+---+---+
   *       |12 |13 |14 |15 |16 |17 |18 |19 |20 |21 |
   *       +---+---+---+---+---+---+---+---+---+---+
   *
   *        22  23  24                                 last_row = 4
   */

  /*
   * Check if the text from the cursor to the position just after end
   * of the edited line can all fit on the screen (while maintaining
   * column alignment).
   */

  all_fits = (last_row - cursor_row < screen_nb_rows);

  /*
   * Determine how many rows to scroll and in which direction
   * (scroll_rows is positive when scrolling forward and negative when
   * scrolling backward).
   */

  if (all_fits)
    {
      /*
       * The region of the edited line between the cursor and end can
       * fit on the screen at the same time.
       */

      if (cursor_row >= 0 &&
          last_row < screen_nb_rows)
        /* Don't scroll if text from cursor to end is visible right now. */
        scroll_rows = 0;
      else
        /* Scroll so that last row of edited line is at bottom of screen. */
        scroll_rows = last_row - (screen_nb_rows - 1);
    }
  else
    {
      /*
       * The region of the edited line between the cursor and end cannot
       * fit on the screen at the same time.
       */

      if (cursor_row >= 0 &&
          cursor_row < screen_nb_rows)
        /* Don't scroll if cursor is visible right now. */
        scroll_rows = 0;
      else
        {
          /*
           * Scroll cursor row to bottom of screen unless this would
           * make a line before the line start visible, in which case
           * align the line start to the top of the screen.
           */

          scroll_rows = cursor_row - (screen_nb_rows - 1);

          if (scroll_rows < first_row)
            scroll_rows = first_row;
        }
    }

  /*
   * Perform scrolling of screen.
   */

  if (scroll_rows != 0)
    {
      cursor -= screen_nb_cols * scroll_rows;

      if (scroll_rows < 0)
        {
          /* scroll screen backward by whole rows */

          start = pos - cursor;

          n = screen_size; /* write to the whole screen */

          if ((e = lineeditor_prepare_to_write_at (d, 0))
              != ___FIX(___NO_ERR))
            return e;

          if ((e = lineeditor_output_prompt (d)) != ___FIX(___NO_ERR))
            return e;
        }
      else
        {
          /* scroll screen forward by whole rows */

          start = screen_size - d->current.line_start;

          n = screen_nb_cols * scroll_rows; /* write characters that scroll in */

          if ((e = lineeditor_prepare_to_write_at (d, screen_size))
              != ___FIX(___NO_ERR))
            return e;
        }

      if (!d->has_eat_newline_glitch)
        n--; /* to avoid wraparound at end of screen */

      if (n > edited->length - start)
        n = edited->length - start;

      if ((e = lineeditor_output_current_hist (d, start, n))
          != ___FIX(___NO_ERR))
        return e;
    }

  if (all_fits)
    if ((e = lineeditor_output_force_delayed_wrap (d))
        != ___FIX(___NO_ERR))
      return e;

  if ((e = lineeditor_move_cursor (d, cursor))
      != ___FIX(___NO_ERR))
    return e;

  d->current.edit_point = pos;
  d->current.completion_point = pos;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_refresh
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;

  if ((e = lineeditor_output_set_attrs
             (d,
              lineeditor_erase_attrs (d)))
      == ___FIX(___NO_ERR))
    {
#ifdef USE_CURSES

      if (lineeditor_cap (d, LINEEDITOR_CAP_CLEAR) != NULL)
        e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_CLEAR, 1);
      else

#endif

        e = lineeditor_left_margin_of_next_row (d);

      if (e == ___FIX(___NO_ERR))
        {
          lineeditor_output_prompt (d); /* ignore error */

          d->current.line_start = d->terminal_cursor;

          if ((e = lineeditor_update_region (d, 0, edited->length))
              == ___FIX(___NO_ERR))
            e = lineeditor_move_edit_point (d, d->current.edit_point);
        }
    }

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_redraw
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int prompt_start = d->current.line_start - d->prompt_length;

  if (prompt_start < 0)
    prompt_start = 0;

  if ((e = lineeditor_output_set_attrs
             (d,
              lineeditor_erase_attrs (d)))
      == ___FIX(___NO_ERR))
    {
      if ((e = lineeditor_move_cursor (d, prompt_start)) != ___FIX(___NO_ERR))
        return e;

#ifdef USE_CURSES

      if (lineeditor_cap (d, LINEEDITOR_CAP_ED) != NULL)
        e = lineeditor_output_cap0 (d, LINEEDITOR_CAP_ED, 1);

#endif

      if ((e = lineeditor_output_prompt (d)) != ___FIX(___NO_ERR))
        return e;

      d->current.line_start = d->terminal_cursor;

      if ((e = lineeditor_update_region (d, 0, edited->length))
          == ___FIX(___NO_ERR))
        e = lineeditor_move_edit_point (d, d->current.edit_point);
    }

  return e;
}


#define FORW_WORD        0
#define BACK_WORD        1
#define FORW_SEXPR       2
#define BACK_SEXPR       3
#define BACK_SEXPR_PAREN 4

___HIDDEN ___BOOL lineeditor_word_boundary
   ___P((___device_tty *self,
         int dir,
         int pos,
         int *final_pos),
        (self,
         dir,
         pos,
         final_pos)
___device_tty *self;
int dir;
int pos;
int *final_pos;)
{
  ___device_tty *d = self;
  extensible_string *edited = &d->current.hist->edited;
  ___C *buf = edited->buffer;
  int len = edited->length;
  int depth = 0;
  ___C in_string = ___UNICODE_NUL; /* assume not inside a string */
  ___C c;

#define WORD_CHAR(x) \
((((x) >= ___UNICODE_0) && ((x) <= ___UNICODE_9)) || \
 (((x) >= ___UNICODE_LOWER_A) && ((x) <= ___UNICODE_LOWER_Z)) || \
 (((x) >= ___UNICODE_UPPER_A) && ((x) <= ___UNICODE_UPPER_Z)) || \
 ((x) > ___UNICODE_RUBOUT))

#define OPEN_PAREN(x) \
((x) == ___UNICODE_LPAREN || \
 (x) == ___UNICODE_LBRACKET || \
 (x) == ___UNICODE_LBRACE)

#define CLOSE_PAREN(x) \
((x) == ___UNICODE_RPAREN || \
 (x) == ___UNICODE_RBRACKET || \
 (x) == ___UNICODE_RBRACE)

#define STRING_DELIM(x) \
((x) == ___UNICODE_DOUBLEQUOTE || (x) == ___UNICODE_VBAR)

#define INT_VECTOR(x) \
((x) == ___UNICODE_LOWER_S || (x) == ___UNICODE_UPPER_S || \
 (x) == ___UNICODE_LOWER_U || (x) == ___UNICODE_UPPER_U)

#define FLOAT_VECTOR(x) \
((x) == ___UNICODE_LOWER_F || (x) == ___UNICODE_UPPER_F)

  if (dir == FORW_WORD)
    {
      while (pos < len)
        {
          c = buf[pos];
          if (!WORD_CHAR(c))
            pos++;
          else
            break;
        }

      while (pos < len)
        {
          c = buf[pos];
          if (WORD_CHAR(c))
            pos++;
          else
            break;
        }
    }
  else if (dir == BACK_WORD)
    {
      while (pos > 0)
        {
          c = buf[pos-1];
          if (!WORD_CHAR(c))
            pos--;
          else
            break;
        }

      while (pos > 0)
        {
          c = buf[pos-1];
          if (WORD_CHAR(c))
            pos--;
          else
            break;
        }
    }
  else if (dir == FORW_SEXPR)
    {
      /* skip whitespace */

      while (pos < len)
        {
          c = buf[pos];
          if (c <= ___UNICODE_SPACE)
            pos++;
          else
            break;
        }

      /* skip standard read-macros */

      while (pos < len)
        {
          c = buf[pos];
          if (c == ___UNICODE_QUOTE)
            pos++;
          else if (c == ___UNICODE_COMMA)
            {
              pos++;
              if (pos < len && buf[pos] == ___UNICODE_AT)
                pos++;
            }
          else
            break;
        }

      if (pos == len)
        {
          depth = -1; /* force error */
          goto done_forward;
        }

      /* handle head specially */

      c = buf[pos++];

      if (pos < len && c == ___UNICODE_SHARP)
        {
          /* handle #\xxx, #(...), #f32(...), etc */

          c = buf[pos++];
          if (c == ___UNICODE_BACKSLASH)
            {
              if (pos < len)
                pos++;
            }
          else if (OPEN_PAREN(c))
            depth++;
          else
            {
              ___BOOL f = FLOAT_VECTOR(c);
              if (pos < len && (f || INT_VECTOR(c)))
                {
                  c = buf[pos++];
                  if ((!f && pos < len && c == ___UNICODE_8) ||
                      (pos+1 < len &&
                       ((!f && c == ___UNICODE_1 && buf[pos] == ___UNICODE_6) ||
                        (c == ___UNICODE_3 && buf[pos] == ___UNICODE_2) ||
                        (c == ___UNICODE_6 && buf[pos] == ___UNICODE_4)) &&
                       (pos++, 1)))
                    {
                      c = buf[pos++];
                      if (OPEN_PAREN(c))
                        depth++;
                      else
                        pos--;
                    }
                }
            }
        }
      else if (OPEN_PAREN(c))
        depth++;
      else if (CLOSE_PAREN(c))
        {
          depth = -1; /* force error */
          goto done_forward;
        }
      else if (STRING_DELIM(c))
        in_string = c;

      while (pos < len)
        if (in_string == ___UNICODE_NUL)
          {
            c = buf[pos];

            if (c == ___UNICODE_SHARP)
              {
                if (pos+2 < len && buf[pos+1] == ___UNICODE_BACKSLASH)
                  pos += 2;
              }
            else if (c <= ___UNICODE_SPACE ||
                     c == ___UNICODE_SEMICOLON ||
                     c == ___UNICODE_QUOTE ||
                     c == ___UNICODE_COMMA)
              {
                if (depth == 0)
                  break;
              }
            else if (OPEN_PAREN(c))
              {
                if (depth == 0)
                  break;
                depth++;
              }
            else if (CLOSE_PAREN(c))
              {
                if (depth == 0)
                  break;
                depth--;
                if (depth == 0)
                  {
                    pos++;
                    break;
                  }
              }
            else if (STRING_DELIM(c))
              {
                if (depth == 0)
                  break;
                in_string = c;
              }

            pos++;
          }
        else
          {
            c = buf[pos++];

            if (c == ___UNICODE_BACKSLASH) /* character is escaped */
              {
                if (pos < len)
                  pos++;
              }
            else if (c == in_string) /* end of string reached */
              {
                if (depth == 0)
                  break;
                in_string = ___UNICODE_NUL;
              }
          }

      done_forward:;
    }
  else
    {
      /* skip whitespace */

      while (pos > 0)
        {
          c = buf[pos-1];
          if (c <= ___UNICODE_SPACE)
            pos--;
          else
            break;
        }

      if (pos == 0)
        {
          depth = -1; /* force error */
          goto done_backward;
        }

      /* handle tail specially */

      c = buf[--pos];

      if (pos >= 2 &&
          buf[pos-2] == ___UNICODE_SHARP &&
          buf[pos-1] == ___UNICODE_BACKSLASH)
        pos -= 2;
      else if (OPEN_PAREN(c))
        {
          depth = -1; /* force error */
          goto done_backward;
        }
      else if (CLOSE_PAREN(c))
        depth++;
      else if (STRING_DELIM(c))
        in_string = c;
      else if (c == ___UNICODE_QUOTE ||
               c == ___UNICODE_COMMA ||
               (pos >= 1 && c == ___UNICODE_AT && buf[pos-1] == ___UNICODE_COMMA))
        {
          pos++;
          goto skip_read_macros;
        }

      while (pos > 0)
        if (in_string == ___UNICODE_NUL)
          {
            c = buf[pos-1];

            if (pos >= 3 &&
                buf[pos-3] == ___UNICODE_SHARP &&
                buf[pos-2] == ___UNICODE_BACKSLASH)
              pos -= 2;
            else if (c <= ___UNICODE_SPACE ||
                     c == ___UNICODE_SEMICOLON ||
                     c == ___UNICODE_QUOTE ||
                     c == ___UNICODE_COMMA)
              {
                if (depth == 0)
                  break;
              }
            else if (pos >= 2 &&
                     c == ___UNICODE_AT &&
                     buf[pos-2] == ___UNICODE_COMMA)
              {
                if (depth == 0)
                  break;
                pos--;
              }
            else if (OPEN_PAREN(c))
              {
                if (depth == 0)
                  break;
                depth--;
                if (depth == 0)
                  {
                    pos--;
                    break;
                  }
              }
            else if (CLOSE_PAREN(c))
              {
                if (depth == 0)
                  break;
                depth++;
              }
            else if (STRING_DELIM(c))
              {
                if (depth == 0)
                  break;
                in_string = c;
              }

            pos--;
          }
        else
          {
            int i;

            i = --pos;

            while (i > 0 &&
                   buf[i-1] == ___UNICODE_BACKSLASH) /* find nb of backslashes */
              i--;

            if ((pos-i) & 1) /* character is escaped */
              pos = i;
            else if (buf[pos] == in_string) /* beginning of string reached */
              {
                if (depth == 0)
                  break;
                in_string = ___UNICODE_NUL;
              }
          }

      done_backward:;

      if (dir == BACK_SEXPR)
        {
          /* handle #(...), #f32(...), etc */

          if (pos < len)
            {
              c = buf[pos];
              if (OPEN_PAREN(c))
                {
                  if (pos >= 1 && buf[pos-1] == ___UNICODE_SHARP)
                    pos--;
                  else if (pos >= 3 && buf[pos-3] == ___UNICODE_SHARP)
                    {
                      c = buf[pos-2];
                      if (INT_VECTOR(c) && buf[pos-1] == ___UNICODE_8)
                        pos -= 3;
                    }
                  else if (pos >= 4 && buf[pos-4] == ___UNICODE_SHARP)
                    {
                      ___BOOL f;
                      c = buf[pos-3];
                      f = FLOAT_VECTOR(c);
                      if (f || INT_VECTOR(c))
                        {
                          c = buf[pos-2];
                          if ((!f &&
                               c == ___UNICODE_1 &&
                               buf[pos-1] == ___UNICODE_6) ||
                              (c == ___UNICODE_3 && buf[pos-1] == ___UNICODE_2) ||
                              (c == ___UNICODE_6 && buf[pos-1] == ___UNICODE_4))
                            pos -= 4;
                        }
                    }
                }
            }

          /* skip standard read-macros */

          skip_read_macros:

          while (pos > 0)
            {
              c = buf[pos-1];
              if (c == ___UNICODE_QUOTE || c == ___UNICODE_COMMA)
                pos--;
              else if (pos >= 2 &&
                       c == ___UNICODE_AT &&
                       buf[pos-2] == ___UNICODE_COMMA)
                pos -= 2;
              else
                break;
            }
        }
    }

  *final_pos = pos;

  return (depth == 0 && in_string == ___UNICODE_NUL);
}


___HIDDEN ___SCMOBJ lineeditor_delete_then_insert_chars
   ___P((___device_tty *self,
         int pos,
         ___BOOL copy_to_clipboard,
         ___C *buf,
         int len),
        (self,
         pos,
         copy_to_clipboard,
         buf,
         len)
___device_tty *self;
int pos;
___BOOL copy_to_clipboard;
___C *buf;
int len;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int edit_point;
  int end;
  int n;
  int open_paren_point;
  ___C c;

  if (pos < 0 ||
      pos > edited->length ||
      len < 0)
    return ___FIX(___INVALID_OP_ERR);

  if (pos < d->current.edit_point)
    {
      edit_point = pos;
      end = d->current.edit_point;
    }
  else
    {
      edit_point = d->current.edit_point;
      end = pos;
    }

  n = end - edit_point; /* number of characters to delete */

  if (n > 0)
    {
      if (copy_to_clipboard &&
          ((e = lineeditor_copy_to_clipboard
                  (d,
                   &edited->buffer[edit_point],
                   n))
           != ___FIX(___NO_ERR)))
        return e;

      extensible_string_delete (edited, edit_point, n);
    }

  if ((e = extensible_string_insert (edited, edit_point, len, buf))
      != ___FIX(___NO_ERR))
    return e;

  if (d->current.mark_point >= end)
    d->current.mark_point += len - n;
  else if (d->current.mark_point >= edit_point+len)
    d->current.mark_point = edit_point+len;

  if ((e = lineeditor_update_region
             (d,
              edit_point,
              (len > n) ? edited->length : edited->length - len + n))
      != ___FIX(___NO_ERR))
    return e;

  edit_point += len;

  if (len > 0 &&
      d->paren_balance_duration_nsecs > 0 &&
      !lineeditor_read_ready (d) &&
      (c = buf[len-1], CLOSE_PAREN(c)) &&
      lineeditor_word_boundary (d, BACK_SEXPR_PAREN, edit_point, &open_paren_point) &&
      (c = edited->buffer[open_paren_point], OPEN_PAREN(c)))
    {
      if ((e = lineeditor_move_edit_point (d, open_paren_point))
          == ___FIX(___NO_ERR))
        {
          lineeditor_output_drain (d); /* ignore error */

          d->current.edit_point = edit_point;
          d->current.completion_point = edit_point;
          d->current.paren_balance_trigger = 1;
        }
    }
  else
    e = lineeditor_move_edit_point (d, edit_point);

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_insert_chars
   ___P((___device_tty *self,
         ___C *buf,
         int len),
        (self,
         buf,
         len)
___device_tty *self;
___C *buf;
int len;)
{
  ___device_tty *d = self;

#if 1

  if (len > 0)
    return lineeditor_delete_then_insert_chars
             (d,
              d->current.edit_point,
              0,
              buf,
              len);

  return ___FIX(___NO_ERR);

#else

  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int edit_point = d->current.edit_point;
  int open_paren_point;
  ___C c;

  if (len <= 0)
    return ___FIX(___NO_ERR);

  if ((e = extensible_string_insert (edited, edit_point, len, buf))
      != ___FIX(___NO_ERR))
    return e;

  if (d->current.mark_point > edit_point)
    d->current.mark_point += len;

  if ((e = lineeditor_update_region (d, edit_point, edited->length))
      != ___FIX(___NO_ERR))
    return e;

  edit_point += len;

  if (d->paren_balance_duration_nsecs > 0 &&
      !lineeditor_read_ready (d) &&
      (c = buf[len-1], CLOSE_PAREN(c)) &&
      lineeditor_word_boundary (d, BACK_SEXPR_PAREN, edit_point, &open_paren_point) &&
      (c = edited->buffer[open_paren_point], OPEN_PAREN(c)))
    {
      if ((e = lineeditor_move_edit_point (d, open_paren_point))
          != ___FIX(___NO_ERR))
        return e;

      lineeditor_output_drain (d); /* ignore error */

      d->current.edit_point = edit_point;
      d->current.completion_point = edit_point;
      d->current.paren_balance_trigger = 1;

      return ___FIX(___NO_ERR);
    }

  return lineeditor_move_edit_point (d, edit_point);
#endif
}


___HIDDEN ___SCMOBJ lineeditor_delete_chars
   ___P((___device_tty *self,
         int pos,
         ___BOOL copy_to_clipboard),
        (self,
         pos,
         copy_to_clipboard)
___device_tty *self;
int pos;
___BOOL copy_to_clipboard;)
{
  ___device_tty *d = self;

#if 1

  return lineeditor_delete_then_insert_chars
           (d,
            pos,
            copy_to_clipboard,
            NULL,
            0);

#else

  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  int start;
  int end;
  int n;

  if (pos < 0 ||
      pos > edited->length)
    return ___FIX(___INVALID_OP_ERR);

  if (pos < d->current.edit_point)
    {
      start = pos;
      end = d->current.edit_point;
    }
  else
    {
      start = d->current.edit_point;
      end = pos;
    }

  n = end - start;

  if (n == 0)
    return ___FIX(___NO_ERR);

  if (copy_to_clipboard &&
      ((e = lineeditor_copy_to_clipboard (d, &edited->buffer[start], n))
       != ___FIX(___NO_ERR)))
    return e;

  extensible_string_delete (edited, start, n);

  if (d->current.mark_point >= start)
    {
      if (d->current.mark_point >= end)
        d->current.mark_point -= n;
      else
        d->current.mark_point = start;
    }

  if ((e = lineeditor_update_region (d, start, edited->length + n))
      != ___FIX(___NO_ERR))
    return e;

  return lineeditor_move_edit_point (d, start);
#endif
}


___HIDDEN void lineeditor_rotate_left_chars
   ___P((___device_tty *self,
         int start,
         int end,
         int n),
        (self,
         start,
         end,
         n)
___device_tty *self;
int start;
int end;
int n;)
{
  ___device_tty *d = self;
  extensible_string *edited = &d->current.hist->edited;
  ___C *p = &edited->buffer[start];
  ___C temp;
  int len = end-start;
  int left = len;
  int i;
  int j;
  int k;

  i = 0;
  while (left > 0)
    {
      temp = p[i];
      j = i;
      k = (j+n) % len;
      left--;
      while (k != i)
        {
          p[j] = p[k];
          j = k;
          k = (j+n) % len;
          left--;
        }
      p[j] = temp;
      i++;
    }
}


___HIDDEN ___SCMOBJ lineeditor_transpose_chars
   ___P((___device_tty *self,
         int start1,
         int end1,
         int start2,
         int end2),
        (self,
         start1,
         end1,
         start2,
         end2)
___device_tty *self;
int start1;
int end1;
int start2;
int end2;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;

  if (start1 > end1 ||
      end1 > start2 ||
      start2 > end2)
    return ___FIX(___INVALID_OP_ERR);

  lineeditor_rotate_left_chars
    (d,
     start1,
     end2,
     end1-start1);

  lineeditor_rotate_left_chars
    (d,
     start1,
     end2-(end1-start1),
     start2-end1);

  if ((e = lineeditor_update_region (d, start1, end2))
      != ___FIX(___NO_ERR))
    return e;

  return lineeditor_move_edit_point (d, end2);
}


typedef struct
  {
    extensible_string *buf;
    int word_start;
    int completion_point;
    int word_end;
    ___SCMOBJ next;
    int common_length;
  } visit_symbol_data;


___HIDDEN void visit_symbol
   ___P((___SCMOBJ sym,
         void *data),
        (sym,
         data)
___SCMOBJ sym;
void *data;)
{
  visit_symbol_data *dat = ___CAST(visit_symbol_data*,data);
  ___SCMOBJ name = ___FIELD(sym,___SYMKEY_NAME);
  int n = ___INT(___STRINGLENGTH(name));
  int word_start = dat->word_start;
  int prefix = dat->completion_point - word_start;
  int len = dat->word_end - word_start;
  int i = 0;

  if (n <= prefix)
    return;

  for (i=0; i<prefix; i++)
    {
      ___C c1 = ___INT(___STRINGREF(name,___FIX(i)));
      ___C c2 = dat->buf->buffer[word_start+i];
      if (c1 != c2)
        return;
    }

  while (i < n)
    {
      if (i < len)
        {
          ___C c1 = ___INT(___STRINGREF(name,___FIX(i)));
          ___C c2 = dat->buf->buffer[word_start+i];
          if (c1 < c2)
            return;
          if (c1 > c2)
            goto found;
        }
      else
        goto found;
      i++;
    }

  return;

 found:

  if (dat->next == ___FAL)
    {
      dat->next = sym;
      dat->common_length = n;
    }
  else
    {
      ___SCMOBJ name2 = ___FIELD(dat->next,___SYMKEY_NAME);
      int n2 = ___INT(___STRINGLENGTH(name2));
      i = 0;
      while (i < n)
        {
          if (i < n2)
            {
              ___C c1 = ___INT(___STRINGREF(name,___FIX(i)));
              ___C c2 = ___INT(___STRINGREF(name2,___FIX(i)));
              if (c1 < c2)
                goto found2;
              if (c1 > c2)
                goto done;
            }
          else
            goto done;
          i++;
        }
    found2:
      dat->next = sym;
    done:
      dat->common_length = i;
    }
}


___HIDDEN int complete_word
   ___P((extensible_string *buf,
         int word_start,
         int completion_point,
         int word_end,
         extensible_string *completion),
        (buf,
         word_start,
         completion_point,
         word_end,
         completion)
extensible_string *buf;
int word_start;
int completion_point;
int word_end;
extensible_string *completion;)
{
#define FOUND_COMPLETION 0
#define NO_COMPLETION    1
#define CANNOT_COMPLETE  2

  visit_symbol_data dat;

  if (completion_point <= word_start)
    return NO_COMPLETION;

  dat.buf = buf;
  dat.word_start = word_start;
  dat.completion_point = completion_point;
  dat.word_end = word_end;
  dat.next = ___FAL;
  dat.common_length = 0;

  ___for_each_symkey (___sSYMBOL, visit_symbol, ___CAST(void*,&dat));

  if (dat.next != ___FAL)
    {
      ___SCMOBJ name = ___FIELD(dat.next,___SYMKEY_NAME);
      int n = ___INT(___STRINGLENGTH(name));
      int i;

#define USE_EMACS_COMPLETION

#ifdef USE_EMACS_COMPLETION
      if (dat.common_length > word_end - word_start)
        n = dat.common_length;
#endif

      if (extensible_string_setup (completion, n) != ___FIX(___NO_ERR))
        return CANNOT_COMPLETE;

      for (i=0; i<n; i++)
        {
          ___C c = ___INT(___STRINGREF(name,___FIX(i)));
          if (extensible_string_insert_at_end (completion, 1, &c)
              != ___FIX(___NO_ERR))
            {
              extensible_string_cleanup (completion);
              return CANNOT_COMPLETE;
            }
        }
      return FOUND_COMPLETION;
    }

  return NO_COMPLETION;
}


___HIDDEN ___SCMOBJ lineeditor_word_completion
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  /*
   * Complete current word.
   */

  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);
  int word_start;
  int completion_point;
  extensible_string completion;

  completion_point = d->current.completion_point;

  if (!lineeditor_word_boundary (d, BACK_SEXPR_PAREN, completion_point, &word_start))
    word_start = completion_point;

  switch (complete_word (&d->current.hist->edited,
                         word_start,
                         completion_point,
                         d->current.edit_point,
                         &completion))
    {
    case FOUND_COMPLETION:
      e = lineeditor_delete_then_insert_chars
            (d,
             word_start,
             0,
             completion.buffer,
             completion.length);
      extensible_string_cleanup (&completion);
      break;

    case NO_COMPLETION:
      if ((e = lineeditor_delete_then_insert_chars
                 (d,
                  completion_point,
                  0,
                  NULL,
                  0))
          == ___FIX(___NO_ERR))
        e = lineeditor_output_char_repetition
              (d,
               ___UNICODE_BELL,
               1,
               d->output_attrs);
      break;

    case CANNOT_COMPLETE:
    default:
      return ___FIX(___INVALID_OP_ERR);
    }

  d->current.completion_point = completion_point;

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_move_history
   ___P((___device_tty *self,
         lineeditor_history *h),
        (self,
         h)
___device_tty *self;
lineeditor_history *h;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  int old_length;
  int new_length;

  if ((e = lineeditor_history_begin_edit (d, h))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = lineeditor_move_edit_point (d, 0))
      != ___FIX(___NO_ERR))
    return e;

  old_length = d->current.hist->edited.length;
  new_length = h->edited.length;

  d->current.mark_point = 0;
  d->current.hist = h;

  if ((e = lineeditor_update_region
             (d,
              0,
              (new_length > old_length) ? new_length : old_length))
      != ___FIX(___NO_ERR))
    return e;

  return lineeditor_move_edit_point (d, new_length);
}


___HIDDEN ___SCMOBJ lineeditor_move_history_relative
   ___P((___device_tty *self,
         ___BOOL back),
        (self,
         back)
___device_tty *self;
___BOOL back;)
{
  ___device_tty *d = self;
  lineeditor_history *h;
  lineeditor_history *limit;

  if (back)
    {
      h = d->current.hist->prev;
      limit = d->hist_last;
    }
  else
    {
      h = d->current.hist->next;
      limit = d->hist_last->next;
    }

  if (h == limit)
    return ___FIX(___INVALID_OP_ERR);

  return lineeditor_move_history (d, h);
}


___HIDDEN ___SCMOBJ lineeditor_line_done
   ___P((___device_tty *self,
         ___BOOL end_of_file),
        (self,
         end_of_file)
___device_tty *self;
___BOOL end_of_file;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;
  extensible_string *edited = &d->current.hist->edited;
  extensible_string *input_line = &d->input_line;

  /*
   * Transfer the current edited line to the input.
   */

  if (input_line->buffer == NULL)
    {
      d->input_line_lo = 0;

      if ((e = extensible_string_copy
                 (edited->buffer,
                  edited->length,
                  input_line,
                  1))
          != ___FIX(___NO_ERR))
        return e;

      if (!end_of_file)
        {
          int old_length = input_line->length;
          if ((e = extensible_string_set_length (input_line, old_length+1, 0))
              != ___FIX(___NO_ERR))
            {
              extensible_string_cleanup (input_line);
              d->input_line.buffer = NULL;
              return e;
            }
          input_line->buffer[old_length] = char_EOL;
        }
    }

  /*
   * Update history (empty lines are not added).
   */

  if (edited->length == 0)
    {
      if ((e = lineeditor_move_edit_point (d, edited->length))
          == ___FIX(___NO_ERR) &&
          (end_of_file ||
           (e = lineeditor_newline (d))
           == ___FIX(___NO_ERR)))
        extensible_string_set_length
          (&d->hist_last->edited,
           0,
           1); /* ignore error */
    }
  else
    {
      /*
       * Make a copy of the current edited line for the history.
       */

      extensible_string actual;

      if ((e = extensible_string_copy
                 (edited->buffer,
                  edited->length,
                  &actual,
                  0))
          == ___FIX(___NO_ERR))
        {
          /*
           * Add the current edited line to the history.
           */

          lineeditor_history *next_line;

          if ((e = lineeditor_history_setup (d, &next_line))
              == ___FIX(___NO_ERR))
            {
              if ((e = lineeditor_history_begin_edit (d, next_line))
                  == ___FIX(___NO_ERR) &&
                  (e = lineeditor_move_edit_point (d, edited->length))
                  == ___FIX(___NO_ERR) &&
                  (e = lineeditor_newline (d))
                  == ___FIX(___NO_ERR))
                {
                  extensible_string_cleanup (&d->hist_last->actual);
                  d->hist_last->actual = actual;
                  lineeditor_history_add_last (d, next_line);
                  lineeditor_history_trim (d);
                }
              else
                lineeditor_history_cleanup (d, next_line); /* ignore error */
            }

          if (e != ___FIX(___NO_ERR))
            extensible_string_cleanup (&actual);
        }
    }

  if (e == ___FIX(___NO_ERR))
    {
      /*
       * Revert history lines to their nonedited state.
       */

      lineeditor_history *h = d->hist_last;

      for (;;)
        {
          h = h->prev;
          if (h == d->hist_last)
            break;
          lineeditor_history_end_edit (d, h);
        }

      /*
       * Prepare editing of next line.
       */

      d->editing_line = 0;
      d->prompt_length = 0;
    }

  return e;
}


___HIDDEN ___SCMOBJ lineeditor_end_paren_balance
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  if (d->current.paren_balance_in_progress)
    {
      d->current.paren_balance_in_progress = 0;
      if (d->editing_line)
        return lineeditor_move_edit_point
                 (d,
                  d->current.edit_point);
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_process_single_event
   ___P((___device_tty *self,
         lineeditor_event *ev),
        (self,
         ev)
___device_tty *self;
lineeditor_event *ev;)
{
  ___device_tty *d = self;
  extensible_string *edited = &d->current.hist->edited;

  switch (ev->event_kind)
    {
    case LINEEDITOR_EV_NONE:
      return ___FIX(___NO_ERR);

    case LINEEDITOR_EV_EOF:
      return lineeditor_line_done (d, 1);

    case LINEEDITOR_EV_KEY:
      if (ev->event_char < ___UNICODE_SPACE || /* discard control characters */
          ev->event_char == ___UNICODE_RUBOUT)
        return ___FIX(___INVALID_OP_ERR);
      return lineeditor_insert_chars (d, &ev->event_char, 1);

    case LINEEDITOR_EV_RETURN:
      return lineeditor_line_done (d, 0);

    case LINEEDITOR_EV_BACK:
      return lineeditor_delete_chars (d, d->current.edit_point-1, 0);

    case LINEEDITOR_EV_BACK_WORD:
    case LINEEDITOR_EV_BACK_SEXPR:
      {
        int i;
        int dir = (ev->event_kind == LINEEDITOR_EV_BACK_WORD)
                  ? BACK_WORD
                  : BACK_SEXPR;
        if (!lineeditor_word_boundary (d, dir, d->current.edit_point, &i))
          return ___FIX(___INVALID_OP_ERR);
        return lineeditor_delete_chars (d, i, 1);
      }

    case LINEEDITOR_EV_TAB:
      return lineeditor_word_completion (d);

    case LINEEDITOR_EV_MARK:
      d->current.mark_point = d->current.edit_point;
      return ___FIX(___NO_ERR);

    case LINEEDITOR_EV_PASTE:
      return lineeditor_paste_from_clipboard (d);

    case LINEEDITOR_EV_CUT:
      return lineeditor_delete_chars (d, d->current.mark_point, 1);

    case LINEEDITOR_EV_CUT_RIGHT:
      return lineeditor_delete_chars (d, edited->length, 1);

    case LINEEDITOR_EV_CUT_LEFT:
      return lineeditor_delete_chars (d, 0, 1);

    case LINEEDITOR_EV_REFRESH:
      return lineeditor_refresh (d);

    case LINEEDITOR_EV_TRANSPOSE:
      {
        int i = d->current.edit_point;
        if (i <= 0 ||
            edited->length < 2)
          return ___FIX(___INVALID_OP_ERR);
        if (i == edited->length)
          return lineeditor_transpose_chars (d, i-2, i-1, i-1, i);
        else
          return lineeditor_transpose_chars (d, i-1, i, i, i+1);
      }

    case LINEEDITOR_EV_TRANSPOSE_WORD:
    case LINEEDITOR_EV_TRANSPOSE_SEXPR:
      {
        int start1;
        int end1;
        int start2;
        int end2;
        int dir = (ev->event_kind == LINEEDITOR_EV_TRANSPOSE_WORD)
                  ? FORW_WORD
                  : FORW_SEXPR;
        if (!lineeditor_word_boundary (d, dir, d->current.edit_point, &end2) ||
            !lineeditor_word_boundary (d, dir+1, end2, &start2) ||
            !lineeditor_word_boundary (d, dir+1, start2, &start1) ||
            !lineeditor_word_boundary (d, dir, start1, &end1))
          return ___FIX(___INVALID_OP_ERR);
        return lineeditor_transpose_chars (d, start1, end1, start2, end2);
      }

    case LINEEDITOR_EV_UP:
      return lineeditor_move_history_relative (d, 1);

    case LINEEDITOR_EV_DOWN:
      return lineeditor_move_history_relative (d, 0);

    case LINEEDITOR_EV_RIGHT:
      return lineeditor_move_edit_point (d, d->current.edit_point+1);

    case LINEEDITOR_EV_RIGHT_WORD:
    case LINEEDITOR_EV_RIGHT_SEXPR:
      {
        int i;
        int dir = (ev->event_kind == LINEEDITOR_EV_RIGHT_WORD)
                  ? FORW_WORD
                  : FORW_SEXPR;
        lineeditor_word_boundary (d, dir, d->current.edit_point, &i);
        return lineeditor_move_edit_point (d, i);
      }

    case LINEEDITOR_EV_LEFT:
      return lineeditor_move_edit_point (d, d->current.edit_point-1);

    case LINEEDITOR_EV_LEFT_WORD:
    case LINEEDITOR_EV_LEFT_SEXPR:
      {
        int i;
        int dir = (ev->event_kind == LINEEDITOR_EV_LEFT_WORD)
                  ? BACK_WORD
                  : BACK_SEXPR;
        lineeditor_word_boundary (d, dir, d->current.edit_point, &i);
        return lineeditor_move_edit_point (d, i);
      }

    case LINEEDITOR_EV_HOME:
      return lineeditor_move_edit_point (d, 0);

    case LINEEDITOR_EV_HOME_DOC:
      return lineeditor_move_history (d, d->hist_last->next);

    case LINEEDITOR_EV_INSERT:
      return ___FIX(___INVALID_OP_ERR);

    case LINEEDITOR_EV_DELETE:
      if (edited->length == 0)
        return lineeditor_line_done (d, 1);
      else
        return lineeditor_delete_chars (d, d->current.edit_point+1, 0);

    case LINEEDITOR_EV_DELETE_WORD:
    case LINEEDITOR_EV_DELETE_SEXPR:
      {
        int i;
        int dir = (ev->event_kind == LINEEDITOR_EV_DELETE_WORD)
                  ? FORW_WORD
                  : FORW_SEXPR;
        if (!lineeditor_word_boundary (d, dir, d->current.edit_point, &i))
          return ___FIX(___INVALID_OP_ERR);
        return lineeditor_delete_chars (d, i, 1);
      }

    case LINEEDITOR_EV_END:
      return lineeditor_move_edit_point (d, edited->length);

    case LINEEDITOR_EV_END_DOC:
      return lineeditor_move_history (d, d->hist_last);

    case LINEEDITOR_EV_F1:
    case LINEEDITOR_EV_META_F1:
    case LINEEDITOR_EV_F2:
    case LINEEDITOR_EV_META_F2:
    case LINEEDITOR_EV_F3:
    case LINEEDITOR_EV_META_F3:
    case LINEEDITOR_EV_F4:
    case LINEEDITOR_EV_META_F4:
#ifdef LINEEDITOR_SUPPORT_F5_TO_F12
    case LINEEDITOR_EV_F5:
    case LINEEDITOR_EV_META_F5:
    case LINEEDITOR_EV_F6:
    case LINEEDITOR_EV_META_F6:
    case LINEEDITOR_EV_F7:
    case LINEEDITOR_EV_META_F7:
    case LINEEDITOR_EV_F8:
    case LINEEDITOR_EV_META_F8:
    case LINEEDITOR_EV_F9:
    case LINEEDITOR_EV_META_F9:
    case LINEEDITOR_EV_F10:
    case LINEEDITOR_EV_META_F10:
    case LINEEDITOR_EV_F11:
    case LINEEDITOR_EV_META_F11:
    case LINEEDITOR_EV_F12:
    case LINEEDITOR_EV_META_F12:
#endif
      {
        ___C command[7];
        command[0] = ___UNICODE_SHARP;
        command[1] = ___UNICODE_VBAR;
        command[2] = ___UNICODE_VBAR;
        command[3] = ___UNICODE_SHARP;
        command[4] = ___UNICODE_COMMA;
        switch (ev->event_kind)
          {
#ifdef LINEEDITOR_SUPPORT_F5_TO_F12
          case LINEEDITOR_EV_F8:
            command[5] = ___UNICODE_LOWER_C;
            break;
          case LINEEDITOR_EV_F9:
            command[5] = ___UNICODE_MINUS;
            break;
          case LINEEDITOR_EV_F10:
            command[5] = ___UNICODE_PLUS;
            break;
          case LINEEDITOR_EV_F11:
            command[5] = ___UNICODE_LOWER_S;
            break;
          case LINEEDITOR_EV_F12:
            command[5] = ___UNICODE_LOWER_L;
            break;
#endif
          default:
            command[5] = ___UNICODE_LOWER_T;
            break;
          }
        command[6] = ___UNICODE_SEMICOLON;
        if (lineeditor_move_edit_point (d, 0)
            == ___FIX(___NO_ERR) &&
            lineeditor_delete_chars (d, edited->length, 0)
            == ___FIX(___NO_ERR) &&
            lineeditor_insert_chars (d, command, 7)
            == ___FIX(___NO_ERR))
          return lineeditor_line_done (d, 0);
        break;
      }
    }

  return ___FIX(___INVALID_OP_ERR);
}


___HIDDEN ___SCMOBJ lineeditor_process_events
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
#define AGGREGATION_BUFFER_SIZE (80*50)

  ___device_tty *d = self;
  ___SCMOBJ e1;
  ___SCMOBJ e2;
  ___C aggregation_buffer[AGGREGATION_BUFFER_SIZE];
  lineeditor_event ev;
  int i;
  struct lineeditor_state_undo_struct previous;

  /*
   * Process events only if no input line is currently available.
   */

  if (d->input_line.buffer != NULL)
    return ___FIX(0);

  /*
   * Process events only if no line editing output is pending.
   */

  if ((e1 = lineeditor_output_drain (d)) != ___FIX(___NO_ERR))
    return e1;

  /*
   * Save state so that we can undo if there is an error.
   */

  d->current.paren_balance_trigger = 0;

  previous = d->current;

  i = 0;

  ev.event_kind = LINEEDITOR_EV_NONE;

  for (;;)
    {
      if ((e1 = lineeditor_get_event (d, &ev)) != ___FIX(___NO_ERR) ||
          ev.event_kind == LINEEDITOR_EV_NONE)
        break;

      if (ev.event_kind != LINEEDITOR_EV_KEY ||
          ev.event_char < ___UNICODE_SPACE ||
          ev.event_char == ___UNICODE_RUBOUT)
        break;

      aggregation_buffer[i++] = ev.event_char;

      ev.event_kind = LINEEDITOR_EV_NONE;

      if (i == AGGREGATION_BUFFER_SIZE)
        break;
    }

  e2 = lineeditor_insert_chars (d, aggregation_buffer, i);
  if (e1 == ___FIX(___NO_ERR))
    e1 = e2;

  e2 = lineeditor_process_single_event (d, &ev);
  if (e1 == ___FIX(___NO_ERR))
    {
      if (ev.event_kind == LINEEDITOR_EV_NONE)
        e1 = ___FIX(i);
      else
        e1 = ___FIX(i+1);
    }

  if (e1 == ___FIX(___INVALID_OP_ERR))
    {
      /*
       * Undo line editing operation.
       */

      ___C c = ___UNICODE_BELL;

      extensible_string_set_length
        (&d->output_char,
         0,
         1); /* ignore error */

      d->output_char.length = 0; /* in case set_length failed */
      d->output_char_lo = 0;

      d->current = previous;

      e1 = lineeditor_output (d, &c, 1);
    }

  if (d->current.paren_balance_trigger)
    {
      /*
       * Parenthesis balancing started in this round of event
       * processing.
       */

      ___time duration;

      ___time_get_current_time (&d->current.paren_balance_end);
      ___time_from_nsecs (&duration, 0, d->paren_balance_duration_nsecs);
      ___time_add (&d->current.paren_balance_end, duration);

      d->current.paren_balance_in_progress = 1;
    }
  else if (d->current.paren_balance_in_progress)
    {
      /*
       * Parenthesis balancing did not start in this round of event
       * processing and parenthesis balancing is in progress, check if
       * parenthesis balancing should end.
       */

      if (i > 0 || ev.event_kind != LINEEDITOR_EV_NONE)
        lineeditor_end_paren_balance (d); /* ignore error */
      else
        {
          ___time now;
          ___time_get_current_time (&now);
          if (!___time_less (now, d->current.paren_balance_end))
            lineeditor_end_paren_balance (d); /* ignore error */
        }
    }

  e2 = lineeditor_output_drain (d);
  if (e2 != ___FIX(___NO_ERR))
    e1 = e2;

  return e1;
}


___HIDDEN ___SCMOBJ lineeditor_read_line
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;

  if (!d->editing_line)
    {
      d->editing_line = 1;
      d->current.edit_point = 0;
      d->current.completion_point = 0;
      d->current.mark_point = 0;
      d->current.hist = d->hist_last;
      d->current.line_start = d->terminal_row * d->terminal_nb_cols + d->terminal_col;
      if (lineeditor_process_events (d) <= ___FIX(0))
        d->editing_line = 0;
    }
  else
    lineeditor_process_events (d); /* ignore error */

  if (d->input_line.buffer == NULL)
    return ___ERR_CODE_EAGAIN;

  return ___FIX(___NO_ERR);
}


#endif


/*****************************************************************************/


___HIDDEN int ___device_tty_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___TTY_DEVICE_KIND;
}


___HIDDEN ___SCMOBJ  ___device_tty_cleanup
   ___P((___device_tty *self),
        ());


___HIDDEN ___SCMOBJ ___device_tty_close_raw_virt
   ___P((___device_stream *self,
         int direction),
        (self,
         direction)
___device_stream *self;
int direction;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);
  int is_not_closed = 0;

  if (d->base.base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

  if ((is_not_closed & ~direction) == 0)
    {
      /* Close tty when both sides are closed. */

      ___SCMOBJ e;

      d->base.base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */
      d->base.base.write_stage = ___STAGE_CLOSED;

      if ((e = ___device_tty_cleanup (d)) != ___FIX(___NO_ERR))
        return e;
    }
  else if (direction & ___DIRECTION_RD)
    d->base.base.read_stage = ___STAGE_CLOSED;
  else if (direction & ___DIRECTION_WR)
    d->base.base.write_stage = ___STAGE_CLOSED;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_select_raw_virt
   ___P((___device_stream *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device_stream *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);
  ___SCMOBJ e;

  if ((e = ___device_tty_force_open (d)) != ___FIX(___NO_ERR))
    return e;

  if ((for_op == FOR_READING
       ? d->base.base.read_stage
       : d->base.base.write_stage)
      != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if (pass == ___SELECT_PASS_1)
    {
#ifdef USE_POSIX

      if (d->fd < 0)
        {
          ___device_select_add_timeout
            (state,
             i,
             ___time_mod.time_neg_infinity);
        }
      else
        ___device_select_add_fd (state, d->fd, for_op);

#endif

#ifdef USE_WIN32

      HANDLE wait_obj;

      if (for_op == FOR_READING)
        wait_obj = d->hout;
      else
        wait_obj = d->hin;

      ___device_select_add_wait_obj (state, i, wait_obj);

#endif

#ifdef USE_LINEEDITOR

      if (for_op == FOR_READING)
        {
          if (lineeditor_read_ready (d))
            ___device_select_add_timeout
              (state,
               i,
               ___time_mod.time_neg_infinity);
          else if (d->current.paren_balance_in_progress)
            ___device_select_add_timeout
              (state,
               i,
               d->current.paren_balance_end);
        }

#endif

      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (for_op == FOR_READING)
    {
#ifndef USE_POSIX
#ifndef USE_WIN32

      state->devs[i] = NULL;

#endif
#endif

#ifdef USE_POSIX

      if (d->fd < 0 || ___FD_ISSET(d->fd, state->readfds))
        state->devs[i] = NULL;

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif

#ifdef USE_LINEEDITOR

      if (lineeditor_read_ready (d) ||
          (d->current.paren_balance_in_progress &&
           state->timeout_reached &&
           !___time_less (state->timeout, d->current.paren_balance_end)))
        state->devs[i] = NULL;

#endif
    }
  else
    {
#ifndef USE_POSIX
#ifndef USE_WIN32

      state->devs[i] = NULL;

#endif
#endif

#ifdef USE_POSIX

      if (d->fd < 0 || ___FD_ISSET(d->fd, state->writefds))
        state->devs[i] = NULL;

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_release_raw_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_force_output_raw_virt
   ___P((___device_stream *self,
         int level),
        (self,
         level)
___device_stream *self;
int level;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);

#ifdef USE_LINEEDITOR

  if (d->stage >= TTY_STAGE_INIT_DONE)
    return lineeditor_output_drain (d);

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_seek_raw_virt
   ___P((___device_stream *self,
         ___stream_index *pos,
         int whence),
        (self,
         pos,
         whence)
___device_stream *self;
___stream_index *pos;
int whence;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);

  return ___FIX(___UNKNOWN_ERR);
}


___HIDDEN ___SCMOBJ ___device_tty_read_raw_virt
   ___P((___device_stream *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (self,
         buf,
         len,
         len_done)
___device_stream *self;
___U8 *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);
  ___SCMOBJ e;

  if ((e = ___device_tty_force_open (d)) != ___FIX(___NO_ERR))
    return e;

  len = TTY_CHAR_SELECT(1,2);

#ifdef USE_LINEEDITOR

  {
    int lo = d->lineeditor_input_byte_lo;
    int hi = d->lineeditor_input_byte_hi;
    int n = hi - lo;
    int limit;

    if (n > len)
      n = len;

    if (n <= 0)
      {
        int char_avail;
        ___C *char_buf_end;
        int byte_avail;
        ___U8 *byte_buf_end;

        char_avail = d->input_line.length - d->input_line_lo;

        if (char_avail <= 0)
          {
            if (d->lineeditor_mode == LINEEDITOR_MODE_DISABLE || d->input_raw)
              goto read_raw;

            if ((e = lineeditor_read_line (d)) != ___FIX(___NO_ERR))
              return e;

            char_avail = d->input_line.length - d->input_line_lo;

            /*
             * It is possible that char_avail == 0.  This happens when
             * the end-of-file character is typed (e.g. ctrl-d).
             */
          }

        char_buf_end = d->input_line.buffer + d->input_line.length;

        byte_avail = ___NBELEMS(d->lineeditor_input_byte);
        byte_buf_end = d->lineeditor_input_byte + byte_avail;

        while (chars_to_bytes (char_buf_end - char_avail,
                               &char_avail,
                               byte_buf_end - byte_avail,
                               &byte_avail,
                               &d->input_encoding_state)
               == ___ILLEGAL_CHAR)
          char_avail--; /* skip over the illegal characters */

        d->input_line_lo = d->input_line.length - char_avail;

        if (char_avail <= 0)
          {
            extensible_string_cleanup (&d->input_line);
            d->input_line.buffer = NULL;
          }

        n = ___NBELEMS(d->lineeditor_input_byte) - byte_avail;
        lo = 0;
        hi = n;
        d->lineeditor_input_byte_hi = hi;
      }

    limit = lo + n;

    while (lo < limit)
      *buf++ = d->lineeditor_input_byte[lo++];

    if (lo < hi)
      d->lineeditor_input_byte_lo = lo;
    else
      {
        d->lineeditor_input_byte_lo = 0;
        d->lineeditor_input_byte_hi = 0;
      }

    *len_done = n;

#ifdef ___DEBUG_TTY

    {
      int i;

      ___printf ("___device_tty_read_raw_virt  nb_bytes: %d ", *len_done);

      for (i=0; i<*len_done; i++)
        ___printf (" %02x", buf[i]);

      ___printf ("\n");
    }

#endif

    return ___FIX(___NO_ERR);
  }

 read_raw:;

#endif

  return ___device_tty_read_raw_no_lineeditor
           (d,
            buf,
            len,
            len_done);
}


___HIDDEN ___SCMOBJ ___device_tty_write_raw_virt
   ___P((___device_stream *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (self,
         buf,
         len,
         len_done)
___device_stream *self;
___U8 *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);
  ___SCMOBJ e;

  if ((e = ___device_tty_force_open (d)) != ___FIX(___NO_ERR))
    return e;

#ifdef USE_LINEEDITOR

  if (d->lineeditor_mode != LINEEDITOR_MODE_DISABLE)
    {
      if (!d->output_raw)
        {
          ___SCMOBJ e;
          ___U8 *byte_buf_end;
          int byte_buf_avail;

          if ((e = lineeditor_end_paren_balance (d))
               != ___FIX(___NO_ERR) ||
              (e = lineeditor_output_set_attrs (d, d->output_attrs))
              != ___FIX(___NO_ERR) ||
              (e = lineeditor_output_drain (d))
              != ___FIX(___NO_ERR))
            return e;

          byte_buf_end = buf + len;
          byte_buf_avail = len + d->output_char_incomplete;

          /* convert the bytes to characters */

          while (byte_buf_avail > 0)
            {
              ___C char_buf[128];
              int char_buf_avail = ___NBELEMS(char_buf);
              int orig_byte_buf_avail = byte_buf_avail;
              int code;

              code = chars_from_bytes (char_buf,
                                       &char_buf_avail,
                                       byte_buf_end - byte_buf_avail,
                                       &byte_buf_avail,
                                       &d->output_decoding_state);

              switch (code)
                {
                case ___CONVERSION_DONE:
                  if ((e = lineeditor_output
                             (d,
                              char_buf,
                              ___NBELEMS(char_buf) - char_buf_avail))
                      != ___FIX(___NO_ERR))
                    {
                      /*******************************/
                      return e;
                    }
                  lineeditor_output_drain (d); /* ignore error */
                  break;

                case ___INCOMPLETE_CHAR:
                  *len_done = byte_buf_avail - d->output_char_incomplete;
                  d->output_char_incomplete = byte_buf_avail;
                  return ___FIX(___NO_ERR);

                case ___ILLEGAL_CHAR:
                  /* ignore illegal characters */
                  break;
                }
            }

          *len_done = len;
          d->output_char_incomplete = 0;
          return ___FIX(___NO_ERR);
        }
    }

#endif

  return ___device_tty_write_raw_no_lineeditor (d, buf, len, len_done);
}


___HIDDEN ___SCMOBJ ___device_tty_width_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);
  ___SCMOBJ e;

  if ((e = ___device_tty_force_open (d)) != ___FIX(___NO_ERR))
    return e;

  if ((e = ___device_tty_update_size (d)) == ___FIX(___NO_ERR))
    {
      if (d->terminal_nb_cols == TERMINAL_NB_COLS_UNLIMITED)
        return ___FIX(80); /* reasonable for pretty-printing */
      else
        return ___FIX(d->terminal_nb_cols);
    }

  return e;
}


___HIDDEN ___SCMOBJ ___device_tty_default_options_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  int settings = ___io_settings_finalize
                   (self->io_settings,
                    ___BUFFERING_MASK(___IO_SETTINGS_DEFAULT)|___NO_BUFFERING);
  int char_encoding_errors = ___CHAR_ENCODING_ERRORS(settings);
  int char_encoding = ___CHAR_ENCODING(settings);
  int eol_encoding = ___EOL_ENCODING(settings);
  int buffering = ___BUFFERING(settings);

#ifdef USE_WIN32

  /* force character and EOL encoding when using Win32 console */

  char_encoding =
    TTY_CHAR_SELECT(___CHAR_ENCODING_ASCII,___CHAR_ENCODING_UCS_2LE);

  eol_encoding = ___EOL_ENCODING_CRLF;

#endif

#ifdef ___DEBUG_TTY

  ___printf ("terminal char_encoding=%d   eol_encoding=%d   buffering=%d\n",
             char_encoding,
             eol_encoding,
             buffering);

#endif

  return ___FIX(___STREAM_OPTIONS(char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering,
                                  char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering));
}


___HIDDEN ___SCMOBJ ___device_tty_options_set_virt
   ___P((___device_stream *self,
         ___SCMOBJ options),
        (self,
         options)
___device_stream *self;
___SCMOBJ options;)
{
  ___device_tty *d = ___CAST(___device_tty*,self);
  int opts = ___INT(options);
  int input_opts = ___STREAM_OPTIONS_INPUT(opts);
  int output_opts = ___STREAM_OPTIONS_OUTPUT(opts);

  d->input_decoding_state  = input_opts;
  d->input_encoding_state  = input_opts;
  d->output_decoding_state = output_opts;
  d->output_encoding_state = output_opts;

#ifdef ___DEBUG_TTY
  ___printf ("input_opts=%d  output_opts=%d\n", input_opts, output_opts);
#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___device_tty_vtbl ___device_tty_table =
{
  {
    {
      ___device_tty_kind,
      ___device_stream_select_virt,
      ___device_stream_release_virt,
      ___device_stream_force_output_virt,
      ___device_stream_close_virt
    },
    ___device_tty_select_raw_virt,
    ___device_tty_release_raw_virt,
    ___device_tty_force_output_raw_virt,
    ___device_tty_close_raw_virt,
    ___device_tty_seek_raw_virt,
    ___device_tty_read_raw_virt,
    ___device_tty_write_raw_virt,
    ___device_tty_width_virt,
    ___device_tty_default_options_virt,
    ___device_tty_options_set_virt
  }
};


___HIDDEN ___SCMOBJ ___device_tty_setup
   ___P((___device_tty *self,
         int plain),
        (self,
         plain)
___device_tty *self;
int plain;)
{
  ___device_tty *d = self;
  ___SCMOBJ e = ___FIX(___NO_ERR);

#ifdef USE_LINEEDITOR

  e = lineeditor_setup (d, plain);

#endif

  return e;
}


___HIDDEN ___SCMOBJ  ___device_tty_cleanup
   ___P((___device_tty *self),
        (self)
___device_tty *self;)
{
  ___device_tty *d = self;
  ___SCMOBJ e;

#ifdef USE_LINEEDITOR

  lineeditor_cleanup (d);

#endif

  if (d->stage >= TTY_STAGE_MODE_NOT_SAVED)
    {
      if (d->stage >= TTY_STAGE_MODE_NOT_SET)
        {
          if ((e = ___device_tty_mode_restore (d, 1)) != ___FIX(___NO_ERR))
            return e;
        }

      if ((d->base.base.close_direction & d->base.base.direction)
          == d->base.base.direction)
        {
#ifdef USE_POSIX
          if (d->fd >= 0 && ___close_no_EINTR (d->fd) < 0)
            return err_code_from_errno ();
#endif

#ifdef USE_WIN32
          if (!CloseHandle (d->hin))
            return err_code_from_GetLastError ();
          if (!CloseHandle (d->hout))
            return err_code_from_GetLastError ();
#endif
        }
    }

  return ___FIX(___NO_ERR);
}


#ifndef USE_POSIX
#ifndef USE_WIN32


___SCMOBJ ___device_tty_setup_from_stdio
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int direction),
        (dev,
         dgroup,
         direction)
___device_tty **dev;
___device_group *dgroup;
int direction;)
{
  ___device_tty *d;
  ___SCMOBJ e;

  d = ___CAST(___device_tty*,
              ___ALLOC_MEM(sizeof (___device_tty)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_tty_table;

  d->stage = TTY_STAGE_NOT_OPENED;

  *dev = d;

  if ((e = ___device_tty_setup (d, 1)) != ___FIX(___NO_ERR))
    {
      ___FREE_MEM(d);
      return e;
    }

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            ___GSTATE->setup_params.io_settings[___IO_SETTINGS_TERMINAL],
            0);
}


#endif
#endif


#ifdef USE_POSIX


___SCMOBJ ___device_tty_setup_from_fd
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int fd,
         int direction),
        (dev,
         dgroup,
         fd,
         direction)
___device_tty **dev;
___device_group *dgroup;
int fd;
int direction;)
{
  ___device_tty *d;
  ___SCMOBJ e;
  int plain = (fd == STDIN_FILENO) ||
              (fd == STDOUT_FILENO) ||
              (fd == STDERR_FILENO);

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (fd, fd))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_tty*,
              ___ALLOC_MEM(sizeof (___device_tty)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_tty_table;

  d->stage = (fd < 0) ? TTY_STAGE_NOT_OPENED : TTY_STAGE_MODE_NOT_SAVED;
  d->fd = fd;

  *dev = d;

  if ((e = ___device_tty_setup (d, plain)) != ___FIX(___NO_ERR))
    {
      ___FREE_MEM(d);
      return e;
    }

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            ___GSTATE->setup_params.io_settings[___IO_SETTINGS_TERMINAL],
            0);
}


#endif


#ifdef USE_WIN32


___SCMOBJ ___device_tty_setup_from_console
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int direction),
        (dev,
         dgroup,
         direction)
___device_tty **dev;
___device_group *dgroup;
int direction;)
{
  ___device_tty *d;
  ___SCMOBJ e;

  d = ___CAST(___device_tty*,
              ___ALLOC_MEM(sizeof (___device_tty)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_tty_table;

  d->stage = TTY_STAGE_NOT_OPENED;

  *dev = d;

  if ((e = ___device_tty_setup (d, 0)) != ___FIX(___NO_ERR))
    {
      ___FREE_MEM(d);
      return e;
    }

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            ___GSTATE->setup_params.io_settings[___IO_SETTINGS_TERMINAL],
            0);
}


#endif


___SCMOBJ ___device_tty_setup_console
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int direction),
        (dev,
         dgroup,
         direction)
___device_tty **dev;
___device_group *dgroup;
int direction;)
{
#ifndef USE_POSIX
#ifndef USE_WIN32

  ___setbuf (___stdin, NULL);
  ___setbuf (___stdout, NULL);

  return ___device_tty_setup_from_stdio
           (dev,
            dgroup,
            direction);

#endif
#endif

#ifdef USE_POSIX

  return ___device_tty_setup_from_fd
           (dev,
            dgroup,
            -1,
            direction);

#endif

#ifdef USE_WIN32

  return ___device_tty_setup_from_console
           (dev,
            dgroup,
            direction);

#endif
}


___tty_module ___tty_mod =
{
  0,
  NULL,
  NULL,
  NULL,
  NULL,
  {
#ifdef TERMINAL_EMULATION_USES_CURSES
    {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      0,
      ___FIX(___NO_ERR)
    },
#endif
    {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      0,
      ___FIX(___NO_ERR)
    }
  }

#ifdef IO_MODULE_INIT
  ___TTY_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

/* Tty device operations. */


___SCMOBJ ___os_device_tty_type_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ term_type,
         ___SCMOBJ emacs_bindings),
        (dev,
         term_type,
         emacs_bindings)
___SCMOBJ dev;
___SCMOBJ term_type;
___SCMOBJ emacs_bindings;)
{
  return ___FIX(___UNIMPL_ERR);
}


___SCMOBJ ___os_device_tty_text_attributes_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ input,
         ___SCMOBJ output),
        (dev,
         input,
         output)
___SCMOBJ dev;
___SCMOBJ input;
___SCMOBJ output;)
{
  ___device_tty *d =
    ___CAST(___device_tty*,___FIELD(dev,___FOREIGN_PTR));

  d->input_attrs = ___INT(input);
  d->output_attrs = ___INT(output);

  return ___VOID;
}


___SCMOBJ ___os_device_tty_history
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
  ___device_tty *d =
    ___CAST(___device_tty*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  ___SCMOBJ result;
  extensible_string hist;

  if ((e = extensible_string_setup (&hist, 0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      ___C nul = ___UNICODE_NUL;
      ___C lf = ___UNICODE_LINEFEED;
      lineeditor_history *probe = d->hist_last->next;

      while (probe != d->hist_last)
        {
          if ((e = extensible_string_insert_at_end
                     (&hist,
                      probe->actual.length,
                      probe->actual.buffer))
              != ___FIX(___NO_ERR) ||
              (e = extensible_string_insert_at_end
                     (&hist,
                      1,
                      &lf))
              != ___FIX(___NO_ERR))
            break;

          probe = probe->next;
        }

      if (e != ___FIX(___NO_ERR) ||
          (e = extensible_string_insert_at_end
                 (&hist,
                  1,
                  &nul))
          != ___FIX(___NO_ERR) ||
          (e = ___NONNULLSTRING_to_SCMOBJ
                 (___PSTATE,
                  hist.buffer,
                  &result,
                  ___RETURN_POS,
                  ___CE(___C_CE_SELECT)))
          != ___FIX(___NO_ERR))
        result = e;

      extensible_string_cleanup (&hist);
    }

  return result;
}


___SCMOBJ ___os_device_tty_history_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ history),
        (dev,
         history)
___SCMOBJ dev;
___SCMOBJ history;)
{
  ___device_tty *d =
    ___CAST(___device_tty*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  void *hist;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              history,
              &hist,
              1,
              ___CE(___C_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      ___C *h = ___CAST(___C*,hist);

      lineeditor_history_trim_to (d, 0);

      while (*h != ___UNICODE_NUL)
        {
          ___C *start = h;

          while (*h != ___UNICODE_NUL && *h != ___UNICODE_LINEFEED)
            h++;

          if (h != start)
            if ((e = lineeditor_history_add_line_before_last
                       (d,
                        h-start,
                        start))
                != ___FIX(___NO_ERR))
              break;

          if (*h == ___UNICODE_LINEFEED)
            h++;
        }

      lineeditor_history_trim (d);

      ___release_string (hist);
    }

  return e;
}


___SCMOBJ ___os_device_tty_history_max_length_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ max_length),
        (dev,
         max_length)
___SCMOBJ dev;
___SCMOBJ max_length;)
{
  ___device_tty *d =
    ___CAST(___device_tty*,___FIELD(dev,___FOREIGN_PTR));

  lineeditor_set_history_max_length (d, ___INT(max_length));

  return ___VOID;
}


___SCMOBJ ___os_device_tty_paren_balance_duration_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ duration),
        (dev,
         duration)
___SCMOBJ dev;
___SCMOBJ duration;)
{
  ___device_tty *d =
    ___CAST(___device_tty*,___FIELD(dev,___FOREIGN_PTR));
  int duration_nsecs = ___CAST(int,___FLONUM_VAL(duration) * 1e9);

  if (duration_nsecs < 0)
    duration_nsecs = 0;

  d->paren_balance_duration_nsecs = duration_nsecs;

  return ___VOID;
}


___SCMOBJ ___os_device_tty_mode_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ input_allow_special,
         ___SCMOBJ input_echo,
         ___SCMOBJ input_raw,
         ___SCMOBJ output_raw,
         ___SCMOBJ speed),
        (dev,
         input_allow_special,
         input_echo,
         input_raw,
         output_raw,
         speed)
___SCMOBJ dev;
___SCMOBJ input_allow_special;
___SCMOBJ input_echo;
___SCMOBJ input_raw;
___SCMOBJ output_raw;
___SCMOBJ speed;)
{
  ___device_tty *d =
    ___CAST(___device_tty*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;

  if ((e = ___device_tty_force_open (d)) == ___FIX(___NO_ERR))
    e = ___device_tty_mode_set
          (d,
           !___FALSEP(input_allow_special),
           !___FALSEP(input_echo),
           !___FALSEP(input_raw),
           !___FALSEP(output_raw),
           ___INT(speed));

  return e;
}


___SCMOBJ ___os_device_tty_mode_reset ___PVOID
{
  return ___device_tty_mode_restore (NULL, 1);
}


#ifdef USE_SIGNALS


void tty_signal_handler (int sig)
{
#ifdef USE_signal
  ___set_signal_handler (sig, tty_signal_handler);
#endif

  switch (sig)
    {
    case SIGINT:
      ___tty_mod.user_interrupt_handler ();
      break;

    case SIGTERM:
      ___tty_mod.terminate_interrupt_handler ();
      break;

    case SIGWINCH:
      {
        ___device_tty *probe = ___tty_mod.mode_save_stack;

        if (probe != NULL)
          do
            {
              probe->size_needs_update = 1;
              probe = probe->mode_save_stack_next;
            }
          while (probe != NULL && probe != ___tty_mod.mode_save_stack);

        break;
      }

    case SIGCONT:
      ___device_tty_mode_restore (NULL, 0); /***************/
      break;
    }
}


#endif


#ifdef USE_WIN32


___HIDDEN BOOL WINAPI console_event_handler
   ___P((DWORD dwCtrlType),
        (dwCtrlType)
DWORD dwCtrlType;)
{
  switch (dwCtrlType)
    {
    case CTRL_CLOSE_EVENT:
    case CTRL_LOGOFF_EVENT:
    case CTRL_SHUTDOWN_EVENT:
      ___tty_mod.terminate_interrupt_handler ();
      break;
    case CTRL_C_EVENT:
    case CTRL_BREAK_EVENT:
      ___tty_mod.user_interrupt_handler ();
      break;
    }

  return TRUE;
}


#endif


___SCMOBJ ___setup_user_interrupt_handling ___PVOID
{
#ifdef USE_SIGNALS

  ___set_signal_handler (SIGINT, tty_signal_handler);
  ___set_signal_handler (SIGTERM, tty_signal_handler);
  ___set_signal_handler (SIGWINCH, tty_signal_handler);
  ___set_signal_handler (SIGCONT, tty_signal_handler);
  ___set_signal_handler (SIGTTOU, SIG_IGN);
  ___set_signal_handler (SIGTTIN, SIG_IGN);

  {
    ___sigset_type sigs;

    sigemptyset (&sigs);
    sigaddset (&sigs, SIGINT);
    sigaddset (&sigs, SIGTERM);
    sigaddset (&sigs, SIGWINCH);
    sigaddset (&sigs, SIGCONT);

    ___thread_sigmask (SIG_UNBLOCK, &sigs, NULL);
  }

#endif

#ifdef USE_WIN32

  SetConsoleCtrlHandler (console_event_handler, TRUE); /* ignore error */

#endif

  return ___FIX(___NO_ERR);
}


void ___cleanup_user_interrupt_handling ___PVOID
{
#ifdef USE_SIGNALS

  ___set_signal_handler (SIGINT, SIG_DFL);
  ___set_signal_handler (SIGTERM, SIG_DFL);
  ___set_signal_handler (SIGWINCH, SIG_DFL);
  ___set_signal_handler (SIGCONT, SIG_DFL);
  ___set_signal_handler (SIGTTOU, SIG_DFL);
  ___set_signal_handler (SIGTTIN, SIG_DFL);

  {
    ___sigset_type sigs;

    sigemptyset (&sigs);
    sigaddset (&sigs, SIGINT);
    sigaddset (&sigs, SIGTERM);
    sigaddset (&sigs, SIGWINCH);
    sigaddset (&sigs, SIGCONT);

    ___thread_sigmask (SIG_UNBLOCK, &sigs, NULL);
  }

#endif

#ifdef USE_WIN32

  SetConsoleCtrlHandler (console_event_handler, FALSE); /* ignore error */

#endif
}


___EXP_FUNC(void,___mask_user_interrupts_begin)
   ___P((___mask_user_interrupts_state *state),
        (state)
___mask_user_interrupts_state *state;)
{
#ifdef USE_SIGNALS

  ___sigset_type sigs;

  sigemptyset (&sigs);
  sigaddset (&sigs, SIGINT);
  sigaddset (&sigs, SIGTERM);
  sigaddset (&sigs, SIGWINCH);
  sigaddset (&sigs, SIGCONT);

  ___thread_sigmask (SIG_BLOCK, &sigs, state->sigset+1);

#endif
}


___EXP_FUNC(void,___mask_user_interrupts_end)
   ___P((___mask_user_interrupts_state *state),
        (state)
___mask_user_interrupts_state *state;)
{
#ifdef USE_SIGNALS

  ___thread_sigmask (SIG_SETMASK, state->sigset+1, NULL);

#endif
}


___SCMOBJ ___setup_tty_module
   ___P((void (*user_interrupt_handler) ___PVOID,
         void (*terminate_interrupt_handler) ___PVOID),
        (user_interrupt_handler,
         terminate_interrupt_handler)
void (*user_interrupt_handler) ___PVOID;
void (*terminate_interrupt_handler) ___PVOID;)
{
  if (___tty_mod.refcount == 0)
    {
      ___SCMOBJ e;

      ___tty_mod.mode_save_stack = NULL;

      ___tty_mod.user_interrupt_handler = user_interrupt_handler;

      ___tty_mod.terminate_interrupt_handler = terminate_interrupt_handler;

      if ((e = ___setup_user_interrupt_handling ()) != ___FIX(___NO_ERR))
        return e;
    }

  ___tty_mod.refcount++;

  return ___FIX(___NO_ERR);
}


void ___cleanup_tty_module ___PVOID
{
  /********************* on Win32 this should be an InterlockedDecrement */
  if (--___tty_mod.refcount == 0)
    {
      ___cleanup_user_interrupt_handling ();
    }
}
