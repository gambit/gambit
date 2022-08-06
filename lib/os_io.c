/* File: "os_io.c" */

/* Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to I/O.
 */

#define ___INCLUDED_FROM_OS_IO
#define ___VERSION 409004
#include "gambit.h"

#include "os_setup.h"
#include "os_thread.h"
#include "os_base.h"
#include "os_io.h"
#include "os_tty.h"
#include "os_shell.h"
#include "os_files.h"
#include "setup.h"
#include "c_intf.h"

/*---------------------------------------------------------------------------*/


___io_module ___io_mod =
{
  0,
  0

#ifdef ___IO_MODULE_INIT
  ___IO_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

#ifdef USE_POSIX

___HIDDEN int ___fdset_realloc
   ___P((___processor_state ___ps,
         int newsize),
        (___ps,
         newsize)
____processor_state ___ps;
int newsize;)
{
  void *readfds = NULL;
  void *writefds = NULL;
  void *exceptfds = NULL;

  if (newsize > 0)
    {
      int newbytes = ___CEILING_DIV(newsize,8);

      readfds  = ___ALLOC_MEM(newbytes);
      if (readfds == NULL)
        goto error;

      writefds = ___ALLOC_MEM(newbytes);
      if (writefds == NULL)
        goto error;

#ifdef USE_exceptfds
      exceptfds = ___ALLOC_MEM(newbytes);
      if (exceptfds == NULL)
        goto error;
#endif
    }

  if (___ps->os.fdset.readfds != NULL)
    ___FREE_MEM(___ps->os.fdset.readfds);

  if (___ps->os.fdset.writefds != NULL)
    ___FREE_MEM(___ps->os.fdset.writefds);

#ifdef USE_exceptfds
  if (___ps->os.fdset.exceptfds != NULL)
    ___FREE_MEM(___ps->os.fdset.exceptfds);
#endif

  ___ps->os.fdset.readfds = readfds;
  ___ps->os.fdset.writefds = writefds;
  ___ps->os.fdset.exceptfds = exceptfds;
  ___ps->os.fdset.size = newsize;

  return 1;

 error:
  if (readfds != NULL)
    ___FREE_MEM(readfds);
  if (writefds != NULL)
    ___FREE_MEM(writefds);
  if (exceptfds != NULL)
    ___FREE_MEM(exceptfds);

  return 0;
}

___HIDDEN int ___fdset_init
   ___P((___processor_state ___ps),
        (ps)
___processor_state ___ps;)
{
  int size = ___VMSTATE_FROM_PSTATE(___ps)->os.fdset.size;

  ___ps->os.fdset.readfds = NULL;
  ___ps->os.fdset.writefds = NULL;
  ___ps->os.fdset.exceptfds = NULL;
  ___ps->os.fdset.size = 0;

  return ___fdset_realloc (___ps, size);
}

#endif

#ifdef USE_FDSET_RESIZING

void ___fdset_resize_pstate
   ___P((___processor_state ___ps,
         int maxfd),
        (___ps,
         maxfd)
___processor_state ___ps;
int maxfd;)
{
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  int newsize;

  newsize = ___vms->os.fdset.size;
  while (maxfd >= newsize)
    newsize = ___CEILING_DIV(3 * newsize, 2);
  /* align newsize to ___fdbits word boundaries */
  newsize = (newsize + ___FDBITS - 1) & ~(___FDBITS - 1);

  if (___PROCESSOR_ID(___ps, ___vms) == 0)
    ___vms->os.fdset.overflow = 0;

  BARRIER();

  if (newsize > ___ps->os.fdset.size && !___fdset_realloc (___ps, newsize))
    ___vms->os.fdset.overflow = 1;

  BARRIER();

  if (!___vms->os.fdset.overflow && ___PROCESSOR_ID(___ps, ___vms) == 0)
    ___vms->os.fdset.size = newsize;

}

#endif


/*---------------------------------------------------------------------------*/

/* Device groups. */


___SCMOBJ ___device_group_setup
   ___P((___device_group **dgroup),
        (dgroup)
___device_group **dgroup;)
{
  ___SCMOBJ e;
  ___device_group *g;

  g = ___CAST(___device_group*,
              ___ALLOC_MEM(sizeof (___device_group)));

  if (g == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  g->list = NULL;

  *dgroup = g;

  return ___FIX(___NO_ERR);
}


void ___device_group_cleanup
   ___P((___device_group *dgroup),
        (dgroup)
___device_group *dgroup;)
{
  while (dgroup->list != NULL)
    if (___device_cleanup (dgroup->list) != ___FIX(___NO_ERR))
      break;

  ___FREE_MEM(dgroup);
}


void ___device_add_to_group
   ___P((___device_group *dgroup,
         ___device *dev),
        (dgroup,
         dev)
___device_group *dgroup;
___device *dev;)
{
  ___device *head = dgroup->list;

  dev->group = dgroup;

  if (head == NULL)
    {
      dev->next = dev;
      dev->prev = dev;
      dgroup->list = dev;
    }
  else
    {
      ___device *tail = head->prev;
      dev->next = head;
      dev->prev = tail;
      tail->next = dev;
      head->prev = dev;
    }
}

void ___device_remove_from_group
   ___P((___device *dev),
        (dev)
___device *dev;)
{
  ___device_group *dgroup = dev->group;
  ___device *prev = dev->prev;
  ___device *next = dev->next;

  if (prev == dev)
    dgroup->list = NULL;
  else
    {
      if (dgroup->list == dev)
        dgroup->list = next;
      prev->next = next;
      next->prev = prev;
      dev->next = dev;
      dev->prev = dev;
    }

  dev->group = NULL;
}

___device_group *___global_device_group ___PVOID
{
  return ___io_mod.dgroup;
}


/*---------------------------------------------------------------------------*/

/* Nonblocking pipes */

#ifdef USE_PUMPS

___HIDDEN ___SCMOBJ ___nonblocking_pipe_setup
   ___P((___nonblocking_pipe *pipe,
         int size),
        (pipe,
         size)
___nonblocking_pipe *pipe;
int size;)
{
  ___U8 *buffer;
  HANDLE mutex;
  HANDLE revent;
  HANDLE wevent;

  buffer = ___CAST(___U8*,
                   ___ALLOC_MEM(size));

  if (buffer == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  mutex = CreateMutex (NULL,  /* can't inherit */
                       FALSE, /* unlocked */
                       NULL); /* no name */

  if (mutex == NULL)
    {
      ___SCMOBJ e = err_code_from_GetLastError ();
      ___FREE_MEM(buffer);
      return e;
    }

  revent = CreateEvent (NULL,  /* can't inherit */
                        TRUE,  /* manual reset */
                        FALSE, /* not signaled */
                        NULL); /* no name */

  if (revent == NULL)
    {
      ___SCMOBJ e = err_code_from_GetLastError ();
      CloseHandle (mutex); /* ignore error */
      ___FREE_MEM(buffer);
      return e;
    }

  wevent = CreateEvent (NULL,  /* can't inherit */
                        TRUE,  /* manual reset */
                        FALSE, /* not signaled */
                        NULL); /* no name */

  if (wevent == NULL)
    {
      ___SCMOBJ e = err_code_from_GetLastError ();
      CloseHandle (revent); /* ignore error */
      CloseHandle (mutex); /* ignore error */
      ___FREE_MEM(buffer);
      return e;
    }

  pipe->mutex = mutex;
  pipe->revent = revent;
  pipe->wevent = wevent;
  pipe->rerr = ___FIX(___NO_ERR);
  pipe->werr = ___FIX(___NO_ERR);
  pipe->oob = 0;
  pipe->rd = 0;
  pipe->wr = 0;
  pipe->size = size;
  pipe->buffer = buffer;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_cleanup
   ___P((___nonblocking_pipe *pipe),
        (pipe)
___nonblocking_pipe *pipe;)
{
  CloseHandle (pipe->wevent); /* ignore error */
  CloseHandle (pipe->revent); /* ignore error */
  CloseHandle (pipe->mutex); /* ignore error */
  ___FREE_MEM(pipe->buffer);

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_set_reader_err
   ___P((___nonblocking_pipe *pipe,
         ___SCMOBJ err),
        (pipe,
         err)
___nonblocking_pipe *pipe;
___SCMOBJ err;)
{
  if (WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  /* note: the reader error indicator may get overwritten */

  pipe->rerr = err;

  SetEvent (pipe->wevent); /* ignore error */

  if (pipe->werr == ___FIX(___NO_ERR))
    ResetEvent (pipe->revent); /* ignore error */

  ReleaseMutex (pipe->mutex); /* ignore error */

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_set_writer_err
   ___P((___nonblocking_pipe *pipe,
         ___SCMOBJ err),
        (pipe,
         err)
___nonblocking_pipe *pipe;
___SCMOBJ err;)
{
  if (WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  /* note: the writer error indicator may get overwritten */

  pipe->werr = err;

  SetEvent (pipe->revent); /* ignore error */

  if (pipe->rerr == ___FIX(___NO_ERR))
    ResetEvent (pipe->wevent); /* ignore error */

  ReleaseMutex (pipe->mutex); /* ignore error */

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_write_oob
   ___P((___nonblocking_pipe *pipe,
         ___nonblocking_pipe_oob_msg *oob_msg),
        (pipe,
         oob_msg)
___nonblocking_pipe *pipe;
___nonblocking_pipe_oob_msg *oob_msg;)
{
  if (WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  if (pipe->werr != ___FIX(___NO_ERR) || pipe->oob)
    {
      ReleaseMutex (pipe->mutex); /* ignore error */
      return ___ERR_CODE_EAGAIN;
    }

  pipe->oob = 1;
  pipe->oob_msg = *oob_msg;

  if (pipe->rerr == ___FIX(___NO_ERR))
    {
      SetEvent (pipe->revent); /* ignore error */
      ResetEvent (pipe->wevent); /* ignore error */
    }

  ReleaseMutex (pipe->mutex); /* ignore error */

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_read_ready_wait
   ___P((___nonblocking_pipe *pipe),
        (pipe)
___nonblocking_pipe *pipe;)
{
  ___SCMOBJ werr;

  if (WaitForSingleObject (pipe->revent, INFINITE) == WAIT_FAILED ||
      WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  werr = pipe->werr;

  if (werr != ___FIX(___NO_ERR))
    {
      pipe->werr = ___FIX(___NO_ERR);

      if (pipe->rerr != ___FIX(___NO_ERR) ||
          (pipe->rd == pipe->wr && !pipe->oob))
        ResetEvent (pipe->revent); /* ignore error */
    }

  ReleaseMutex (pipe->mutex); /* ignore error */

  return werr;
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_write_ready_wait
   ___P((___nonblocking_pipe *pipe),
        (pipe)
___nonblocking_pipe *pipe;)
{
  ___SCMOBJ rerr;

  if (WaitForSingleObject (pipe->wevent, INFINITE) == WAIT_FAILED ||
      WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  rerr = pipe->rerr;

  if (rerr != ___FIX(___NO_ERR))
    {
      pipe->rerr = ___FIX(___NO_ERR);

      ResetEvent (pipe->wevent); /* ignore error */
    }

  ReleaseMutex (pipe->mutex); /* ignore error */

  return rerr;
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_read
   ___P((___nonblocking_pipe *pipe,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done,
         ___nonblocking_pipe_oob_msg *oob_msg),
        (pipe,
         buf,
         len,
         len_done,
         oob_msg)
___nonblocking_pipe *pipe;
___U8 *buf;
___stream_index len;
___stream_index *len_done;
___nonblocking_pipe_oob_msg *oob_msg;)
{
  ___SCMOBJ rerr;
  ___SCMOBJ werr;
  DWORD rd;
  DWORD wr;
  ___U8 *p;
  DWORD end;
  DWORD n;
  DWORD i;

  if (len <= 0)
    return ___FIX(___UNKNOWN_ERR);

  if (WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  rerr = pipe->rerr;
  werr = pipe->werr;
  rd = pipe->rd;
  wr = pipe->wr;

  if (rerr != ___FIX(___NO_ERR))
    {
      /* there is a reader error */

      if (werr == ___FIX(___NO_ERR))
        werr = ___ERR_CODE_EAGAIN;
      else
        {
          pipe->werr = ___FIX(___NO_ERR);
          ResetEvent (pipe->revent); /* ignore error */
        }
      ReleaseMutex (pipe->mutex); /* ignore error */
      return werr;
    }

  /* there is no reader error */

  if (rd == wr)
    {
      /* no bytes in FIFO buffer */

      if (pipe->oob)
        {
          /* out-of-band present */

          *oob_msg = pipe->oob_msg;
          pipe->oob = 0;
          if (werr == ___FIX(___NO_ERR))
            {
              ResetEvent (pipe->revent); /* ignore error */
#if 0
              /******************zzzzzzzzzzzzzz****/
              SetEvent (pipe->wevent); /* ignore error */
#endif
            }
          ReleaseMutex (pipe->mutex); /* ignore error */
          *len_done = 0;
          return ___FIX(___NO_ERR);
        }

      /* out-of-band not present */

      if (werr != ___FIX(___NO_ERR))
        {
          /* there is a writer error */

          pipe->werr = ___FIX(___NO_ERR);

          ResetEvent (pipe->revent); /* ignore error */
          ReleaseMutex (pipe->mutex); /* ignore error */
          return werr;
        }

      /* there is no writer error */

      SetEvent (pipe->wevent); /* ignore error */
      ReleaseMutex (pipe->mutex); /* ignore error */
      return ___ERR_CODE_EAGAIN;
    }

  /* at least one byte in FIFO buffer */

  end = pipe->size - rd; /* number of bytes from rd to end */

  n = wr + end; /* number of bytes available */
  if (n >= pipe->size)
    n -= pipe->size;

  if (n > ___CAST(DWORD,len)) /* don't transfer more than len */
    n = len;

  *len_done = n;

  p = pipe->buffer + rd; /* prepare transfer source */

  rd = rd + n;
  if (rd >= pipe->size)
    rd -= pipe->size;

  pipe->rd = rd;

  if (werr == ___FIX(___NO_ERR) && !pipe->oob)
    {
      /* there is no writer error and out-of-band not present */

      if (rd == wr) /* the FIFO will be empty? */
        ResetEvent (pipe->revent); /* ignore error */

      /* the FIFO will not be full */

      SetEvent (pipe->wevent); /* ignore error */
    }

  if (n <= end)
    {
      /* only need to transfer n bytes starting from original rd */

      for (i=n; i>0; i--)
        *buf++ = *p++;
    }
  else
    {
      /* need to transfer end bytes starting from original rd */

      for (i=end; i>0; i--)
        *buf++ = *p++;

      /* and to transfer n-end bytes starting from 0 */

      p = pipe->buffer;

      for (i=n-end; i>0; i--)
        *buf++ = *p++;
    }

  ReleaseMutex (pipe->mutex); /* ignore error */

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___nonblocking_pipe_write
   ___P((___nonblocking_pipe *pipe,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        (pipe,
         buf,
         len,
         len_done)
___nonblocking_pipe *pipe;
___U8 *buf;
___stream_index len;
___stream_index *len_done;)
{
  ___SCMOBJ rerr;
  ___SCMOBJ werr;
  DWORD rd;
  DWORD wr;
  ___U8 *p;
  DWORD end;
  DWORD n;
  DWORD i;

  if (len <= 0)
    return ___FIX(___UNKNOWN_ERR);

  if (WaitForSingleObject (pipe->mutex, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  rerr = pipe->rerr;
  werr = pipe->werr;
  rd = pipe->rd;
  wr = pipe->wr;

  if (werr != ___FIX(___NO_ERR))
    {
      /* there is a writer error */

      if (rerr == ___FIX(___NO_ERR))
        rerr = ___ERR_CODE_EAGAIN;
      else
        {
          pipe->rerr = ___FIX(___NO_ERR);
          ResetEvent (pipe->wevent); /* ignore error */
        }
      ReleaseMutex (pipe->mutex); /* ignore error */
      return rerr;
    }

  /* there is no writer error */

  if (rerr != ___FIX(___NO_ERR))
    {
      /* there is a reader error */

      pipe->rerr = ___FIX(___NO_ERR);

      if (rd != wr || pipe->oob) /* FIFO is not empty */
        SetEvent (pipe->revent); /* ignore error */

      ResetEvent (pipe->wevent); /* ignore error */
      ReleaseMutex (pipe->mutex); /* ignore error */
      return rerr;
    }

  /* there is no reader error */

  if (wr + 1 - rd == 0 || wr + 1 - rd == pipe->size || pipe->oob)
    {
      /* FIFO buffer is full or out-of-band present */

      ReleaseMutex (pipe->mutex); /* ignore error */
      return ___ERR_CODE_EAGAIN;
    }

  /* FIFO buffer is not full and out-of-band not present */

  end = pipe->size - wr; /* number of bytes from wr to end */

  n = rd + end - 1; /* number of bytes available */
  if (n >= pipe->size)
    n -= pipe->size;

  if (n > ___CAST(DWORD,len)) /* don't transfer more than len */
    n = len;

  *len_done = n;

  p = pipe->buffer + wr; /* prepare transfer source */

  wr = wr + n;
  if (wr >= pipe->size)
    wr -= pipe->size;

  pipe->wr = wr;

  if (wr + 1 - rd == 0 || wr + 1 - rd == pipe->size) /* FIFO will be full? */
    ResetEvent (pipe->wevent); /* ignore error */

  /* FIFO will not be empty */

  SetEvent (pipe->revent); /* ignore error */

  if (n <= end)
    {
      /* only need to transfer n bytes starting from original wr */

      for (i=n; i>0; i--)
        *p++ = *buf++;
    }
  else
    {
      /* need to transfer end bytes starting from original wr */

      for (i=end; i>0; i--)
        *p++ = *buf++;

      /* and to transfer n-end bytes starting from 0 */

      p = pipe->buffer;

      for (i=n-end; i>0; i--)
        *p++ = *buf++;
    }

  ReleaseMutex (pipe->mutex); /* ignore error */

  return ___FIX(___NO_ERR);
}

#endif


/*---------------------------------------------------------------------------*/

/* I/O settings. */


int ___io_settings_merge
   ___P((int io_settings,
         int io_settings_to_fill_default),
        (io_settings,
         io_settings_to_fill_default)
int io_settings;
int io_settings_to_fill_default;)
{
  if (___CHAR_ENCODING_ERRORS(io_settings) == 0)
    io_settings |= ___CHAR_ENCODING_ERRORS(io_settings_to_fill_default);

  if (___CHAR_ENCODING(io_settings) == 0)
    io_settings |= ___CHAR_ENCODING(io_settings_to_fill_default);

  if (___EOL_ENCODING(io_settings) == 0)
    io_settings |= ___EOL_ENCODING(io_settings_to_fill_default);

  if (___BUFFERING(io_settings) == 0)
    io_settings |= ___BUFFERING(io_settings_to_fill_default);

  return io_settings;
}


int ___io_settings_finalize
   ___P((int io_settings,
         int io_settings_to_fill_default),
        (io_settings,
         io_settings_to_fill_default)
int io_settings;
int io_settings_to_fill_default;)
{
  io_settings = ___io_settings_merge
                  (io_settings,
                   ___GSTATE->setup_params.io_settings[___IO_SETTINGS_GENERAL]);

  io_settings = ___io_settings_merge
                  (io_settings,
                   io_settings_to_fill_default);

  return io_settings;
}


/*---------------------------------------------------------------------------*/

/* Operations on I/O devices. */

/* Generic device operations. */

void ___device_select_add_relative_timeout
   ___P((___device_select_state *state,
         int i,
         ___F64 seconds),
        (state,
         i,
         seconds)
___device_select_state *state;
int i;
___F64 seconds;)
{
  if (seconds < state->relative_timeout)
    state->relative_timeout = seconds;
}


void ___device_select_add_timeout
   ___P((___device_select_state *state,
         int i,
         ___time timeout),
        (state,
         i,
         timeout)
___device_select_state *state;
int i;
___time timeout;)
{
  if (___time_less (timeout, state->timeout))
    state->timeout = timeout;
}


#ifdef USE_select

void ___device_select_add_fd
   ___P((___device_select_state *state,
         int fd,
         int for_op),
        (state,
         fd,
         for_op)
___device_select_state *state;
int fd;
int for_op;)
{
  if (for_op == FOR_READING)
    ___FD_SET(fd, state->readfds);
  else
    ___FD_SET(fd, state->writefds);

  if (fd >= state->highest_fd_plus_1)
    state->highest_fd_plus_1 = fd+1;
}

#endif

#ifdef USE_poll

void ___device_select_add_fd
   ___P((___device_select_state *state,
         int fd,
         int for_op),
        (state,
         fd,
         for_op)
___device_select_state *state;
int fd;
int for_op;)
{
  state->pollfds[state->pollfd_count].fd = fd;

  if (for_op == FOR_READING)
    state->pollfds[state->pollfd_count].events = POLLIN;
  else
    state->pollfds[state->pollfd_count].events = POLLOUT;

  ++state->pollfd_count;
}

#endif


#ifdef USE_MsgWaitForMultipleObjects

void ___device_select_add_wait_obj
   ___P((___device_select_state *state,
         int i,
         HANDLE wait_obj),
        (state,
         i,
         wait_obj)
___device_select_state *state;
int i;
HANDLE wait_obj;)
{
  DWORD j = state->nb_wait_objs;

  if (j < MAXIMUM_WAIT_OBJECTS)
    {
      state->wait_objs_buffer[j] = wait_obj;
      state->wait_obj_to_dev_pos[j] = i;
      state->nb_wait_objs = j+1;
    }
}

#endif


___SCMOBJ ___device_select
   ___P((___device **devs,
         int nb_read_devs,
         int nb_write_devs,
         int nb_event_devs,
         ___time timeout),
        (devs,
         nb_read_devs,
         nb_write_devs,
         nb_event_devs,
         timeout)
___device **devs;
int nb_read_devs;
int nb_write_devs;
int nb_event_devs;
___time timeout;)
{
  ___SCMOBJ e;
  int event_pos = nb_event_devs;
  int write_pos = event_pos + nb_write_devs;
  int read_pos = write_pos + nb_read_devs;
  ___device_select_state state;
  int pass;
  int dev_list;
  int i;
  int prev;
  ___time delta;

#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

  ___BOOL aborted = 0;

#endif

  state.devs = devs;

  state.timeout = timeout;
  state.relative_timeout = POS_INFINITY;

#ifdef USE_select_or_poll

#ifdef USE_select
  {
    ___processor_state ___ps = ___PSTATE;

    state.highest_fd_plus_1 = 0;
    state.readfds = ___CAST(___fdbits*, ___ps->os.fdset.readfds);
    state.writefds = ___CAST(___fdbits*, ___ps->os.fdset.writefds);
    state.exceptfds = ___CAST(___fdbits*, ___ps->os.fdset.exceptfds);
    ___FD_ZERO(state.readfds, ___ps->os.fdset.size);
    ___FD_ZERO(state.writefds, ___ps->os.fdset.size);
    if (state.exceptfds != NULL)
      ___FD_ZERO(state.exceptfds, ___ps->os.fdset.size);
  }
#endif

#ifdef USE_poll
  {
    ___processor_state ___ps = ___PSTATE;

    state.pollfd_count = 0;
    state.readfds = ___CAST(___fdbits*, ___ps->os.fdset.readfds);
    state.writefds = ___CAST(___fdbits*, ___ps->os.fdset.writefds);
    ___FD_ZERO(state.readfds, ___ps->os.fdset.size);
    ___FD_ZERO(state.writefds, ___ps->os.fdset.size);
  }
#endif

#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

  /* monitor self-pipe for available data to read */

  ___device_select_add_fd (&state,
                           ___PSTATE->os.select_abort.reading_fd,
                           FOR_READING);

#endif

#endif

#ifdef USE_MsgWaitForMultipleObjects

  state.message_queue_mask = 0;
  state.message_queue_dev_pos = -1;

  state.nb_wait_objs = 0;

  state.wait_objs_buffer[state.nb_wait_objs++] = ___time_mod.heartbeat_thread;

#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

  state.wait_objs_buffer[state.nb_wait_objs++] = ___PSTATE->os.select_abort;

#endif

#endif

  if (read_pos > 0)
    {
      state.devs_next[read_pos-1] = -1;

      for (i=read_pos-2; i>=0; i--)
        state.devs_next[i] = i+1;

      dev_list = 0;
    }
  else
    dev_list = -1;

  pass = ___SELECT_PASS_1;

  while (dev_list != -1)
    {
      i = dev_list;
      prev = -1;

      while (i != -1)
        {
          ___device *d = devs[i];
          if ((e = ___device_select_virt
                     (d,
                      i>=write_pos ? FOR_READING
                                   : i>=event_pos ? FOR_WRITING
                                                  : FOR_EVENT,
                      i,
                      pass,
                      &state))
              == ___FIX(___NO_ERR))
            {
              prev = i;
              i = state.devs_next[i];
            }
          else
            {
              int j;
              if (e != ___FIX(___SELECT_SETUP_DONE))
                return e;
              j = state.devs_next[i];
              if (prev == -1)
                dev_list = j;
              else
                state.devs_next[prev] = j;
#ifdef USE_MsgWaitForMultipleObjects
              state.devs_next[i] = -1;
#endif
              i = j;
            }
        }

      pass++;
    }

  ___absolute_time_to_relative_time (state.timeout, &delta);

  if (state.relative_timeout < ___time_to_seconds (delta))
    {
      ___time_from_seconds (&delta, state.relative_timeout);
      state.timeout = ___time_mod.time_neg_infinity;
    }
  else
    state.relative_timeout = NEG_INFINITY;

  e = ___FIX(___NO_ERR);

  ___ACTLOG_BEGIN(io_wait,darkgray);

#ifdef USE_select_or_poll

#ifdef USE_select

  /*
   * Heartbeat interrupts must be disabled in case they are based on the
   * real-time timer.  This is needed to bypass issues in two buggy
   * operating systems:
   *
   * - On MacOS X, the virtual-time timer does not fire at the correct
   *   rate (apparently this happens only on machines with more than
   *   one core).
   *
   * - On CYGWIN, the select system call can be interrupted by the
   *   timer and in some cases the error "No child processes" will
   *   be returned by select.
   */

  {
    ___mask_heartbeat_interrupts_state heartbeat_interrupts;
    struct timeval delta_tv_struct;
    struct timeval *delta_tv = &delta_tv_struct;
    int result;

    ___absolute_time_to_nonnegative_timeval_maybe_NULL (delta, &delta_tv);

    if (delta_tv != NULL &&
        state.highest_fd_plus_1 == 0)
      {
        /*
         * ___device_select is only being called for sleeping until a
         * certain timeout or interrupt occurs.  This is a case that
         * can be optimized.
         */

        if (delta_tv->tv_sec < 0 ||
            (delta_tv->tv_sec == 0 &&
             delta_tv->tv_usec == 0))
          {
            /*
             * The timeout has already passed, so we don't need to
             * sleep.  This simple optimization avoids doing a system
             * call to the select or nanosleep functions (which can be
             * expensive on some operating systems).
             */

            result = 0;

            goto select_done;
          }
#ifndef USE_ASYNC_DEVICE_SELECT_ABORT
#ifdef USE_nanosleep
        else
          {
            /*
             * For better timeout resolution, the nanosleep function
             * is used instead of the select function.  On some
             * operating systems (e.g. OpenBSD 4.5) the nanosleep
             * function can be more expensive than a call to select,
             * but the better timeout resolution outweighs the run
             * time cost.
             *
             * This optimization is not used when it is necessary to
             * abort ___device_select asynchronously.
             */

            struct timespec delta_ts_struct;
            delta_ts_struct.tv_sec = delta_tv->tv_sec;
            delta_ts_struct.tv_nsec = delta_tv->tv_usec * 1000;

            ___mask_heartbeat_interrupts_begin (&heartbeat_interrupts);

            result = nanosleep (&delta_ts_struct, NULL);

            if (result < 0)
              e = err_code_from_errno ();

            ___mask_heartbeat_interrupts_end (&heartbeat_interrupts);

            goto select_done;
          }
#endif
#endif
      }

    ___mask_heartbeat_interrupts_begin (&heartbeat_interrupts);

    result =
      select (state.highest_fd_plus_1,
              ___CAST(fd_set*, state.readfds),
              ___CAST(fd_set*, state.writefds),
              ___CAST(fd_set*, state.exceptfds),
              delta_tv);

    if (result < 0)
      e = err_code_from_errno ();

    ___mask_heartbeat_interrupts_end (&heartbeat_interrupts);

  select_done:

    state.timeout_reached = (result == 0);
  }

#endif

#ifdef USE_poll
  {
    ___mask_heartbeat_interrupts_state heartbeat_interrupts;
    struct timeval delta_tv_struct;
    struct timeval *delta_tv = &delta_tv_struct;

#ifdef USE_ppoll
    struct timespec delta_ts_struct;
    struct timespec *delta_ts;
#else
    int delta_msecs;
#endif
    int result;

    ___absolute_time_to_nonnegative_timeval_maybe_NULL (delta, &delta_tv);

    /* pure sleep optimizations */
    if (delta_tv != NULL &&
        state.pollfd_count == 0)
      {
        if (delta_tv->tv_sec < 0 ||
            (delta_tv->tv_sec == 0 &&
             delta_tv->tv_usec == 0))
          {
            result = 0;
            goto poll_done;
          }
#ifndef USE_ASYNC_DEVICE_SELECT_ABORT
#ifdef USE_nanosleep
        else
          {
            struct timespec delta_ts_struct;
            delta_ts_struct.tv_sec = delta_tv->tv_sec;
            delta_ts_struct.tv_nsec = delta_tv->tv_usec * 1000;

            ___mask_heartbeat_interrupts_begin (&heartbeat_interrupts);

            result = nanosleep (&delta_ts_struct, NULL);

            if (result < 0)
              e = err_code_from_errno ();

            ___mask_heartbeat_interrupts_end (&heartbeat_interrupts);

            goto poll_done;
          }
#endif
#endif
      }

    /* setup timeout */
#ifdef USE_ppoll

    if (delta_tv != NULL)
      {
        /* ppoll doesn't like negative times */
        if (delta_tv->tv_sec < 0)
          {
            delta_ts_struct.tv_sec = 0;
            delta_ts_struct.tv_nsec = 0;
          }
        else
          {
            delta_ts_struct.tv_sec = delta_tv->tv_sec;
            delta_ts_struct.tv_nsec = delta_tv->tv_usec * 1000;
          }

        delta_ts = &delta_ts_struct;
      }
    else
      delta_ts = NULL;

#else

    if (delta_tv != NULL)
      {
        if (delta_tv->tv_sec < 0)
          delta_msecs = 0;
        else if (delta_tv->tv_sec < (INT_MAX / 1000))
          delta_msecs = delta_tv->tv_sec * 1000 + delta_tv->tv_usec / 1000;
        else
          delta_msecs = INT_MAX;
      }
    else
      delta_msecs = -1;

#endif

    /* see comments on select above regarding heartbeat interrupts */
    ___mask_heartbeat_interrupts_begin (&heartbeat_interrupts);

#ifdef USE_ppoll
    result = ppoll (state.pollfds, state.pollfd_count, delta_ts, NULL);
#else
    result = poll (state.pollfds, state.pollfd_count, delta_msecs);
#endif

    if (result < 0)
      e = err_code_from_errno ();

    ___mask_heartbeat_interrupts_end (&heartbeat_interrupts);

    /* Set the active bitmaps */
    if (result > 0)
      {
        int errmask = (POLLERR | POLLHUP | POLLNVAL);
        int active = result;
        int x;

        for (x = 0; active > 0; ++x)
          {
            if (state.pollfds[x].revents)
              {
                if (state.pollfds[x].events & POLLIN)
                  {
                    if (state.pollfds[x].revents & (POLLIN | errmask))
                      ___FD_SET(state.pollfds[x].fd, state.readfds);
                  }

                if (state.pollfds[x].events & POLLOUT)
                  {
                    if (state.pollfds[x].revents & (POLLOUT | errmask))
                      ___FD_SET(state.pollfds[x].fd, state.writefds);
                  }

                --active;
              }
          }
      }

  poll_done:

    state.timeout_reached = (result == 0);
  }
#endif

#endif

#ifdef USE_MsgWaitForMultipleObjects

  {
    DWORD delta_msecs;
    int first_iteration = TRUE;

    ___absolute_time_to_nonnegative_msecs (delta, &delta_msecs);

    state.timeout_reached = 0;

    while (state.nb_wait_objs > 0 || state.message_queue_mask != 0)
      {
        DWORD n;

        n = MsgWaitForMultipleObjects
              (state.nb_wait_objs,
               state.wait_objs_buffer,
               FALSE,
               delta_msecs,
               state.message_queue_mask);

        if (n == WAIT_FAILED)
          {
            e = err_code_from_GetLastError ();
            break;
          }

        if ((n - WAIT_OBJECT_0) <= WAIT_OBJECT_0 + state.nb_wait_objs)
          n -= WAIT_OBJECT_0;
        else if (n >= WAIT_ABANDONED_0 &&
                 n <= WAIT_ABANDONED_0+state.nb_wait_objs-1)
          n -= WAIT_ABANDONED_0;
        else
          {
            /* n == WAIT_TIMEOUT */

            /*
             * The call to MsgWaitForMultipleObjects timed out.  Mark
             * the appropriate device "ready".
             */

            if (first_iteration)
              {
                /* first call to MsgWaitForMultipleObjects */

                state.timeout_reached = 1;
              }

            break;
          }

        if (n == state.nb_wait_objs)
          {
            /*
             * The message queue contains a message that is of interest.
             * Mark the appropriate device "ready".
             */

            i = state.message_queue_dev_pos;
            if (i >= 0)
              state.devs_next[i] = 0;

            /*
             * Don't check if other devices are ready because this might
             * cause an infinite loop.
             */

            break;
          }
        else if (n == 0)
          {
            /*
             * The heartbeat thread has died.  This is normally due to
             * the program being terminated abruptly by the user (for
             * example by using the thread manager or the "shutdown"
             * item in the start menu).  When this happens we must
             * initiate a clean termination of the program.
             */

            e = ___FIX(___UNKNOWN_ERR);

            break;
          }
#ifdef USE_ASYNC_DEVICE_SELECT_ABORT
        else if (n == 1)
          {
            /*
             * The call to ___device_select must be aborted because the
             * select_abort event is set.  This occurs when an interrupt
             * (such as a CTRL-C user interrupt) needs to be serviced
             * promptly by the main program. However, it is important
             * to check if other devices are ready, to ensure
             * that IO events are not ignored.
             */

            ResetEvent (___PSTATE->os.select_abort); /* ignore error */

            aborted = 1;
          }
#endif
        else
          {
            /* Mark the appropriate device "ready". */

            i = state.wait_obj_to_dev_pos[n];
            if (i >= 0)
              state.devs_next[i] = 0;

            /* Prepare to check remaining devices. */

            state.nb_wait_objs--;

            state.wait_objs_buffer[n] =
              state.wait_objs_buffer[state.nb_wait_objs];

            state.wait_obj_to_dev_pos[n] =
              state.wait_obj_to_dev_pos[state.nb_wait_objs];
          }

        first_iteration = FALSE;
        delta_msecs = 0; /* next MsgWaitForMultipleObjects will only poll */
      }
  }

#endif

  ___ACTLOG_END();

#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

#ifdef USE_select_or_poll

  if (___FD_ISSET(___PSTATE->os.select_abort.reading_fd, state.readfds))
    {
      /* self-pipe has available data to read, discard all of it */

      aborted = 1;

      for (;;)
        {
          char buf[256];
          int n = read (___PSTATE->os.select_abort.reading_fd, buf, sizeof(buf));

          if (n < 0)
            {
              if (errno == EAGAIN)
                break;
              if (errno != EINTR)
                {
                  e = err_code_from_errno ();
                  break;
                }
            }
          else if (n < sizeof(buf))
            break;
        }
    }

#endif

#endif

  if (e == ___FIX(___NO_ERR))
    {
      for (i=read_pos-1; i>=0; i--)
        {
          ___device *d = devs[i];
          if (d != NULL)
            if ((e = ___device_select_virt
                       (d,
                        i>=write_pos ? FOR_READING
                                     : i>=event_pos ? FOR_WRITING
                                                    : FOR_EVENT,
                        i,
                        ___SELECT_PASS_CHECK,
                        &state))
                != ___FIX(___NO_ERR))
              break;
        }
    }

#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

  if (aborted && e == ___FIX(___NO_ERR))
    e = ___FIX(___ERRNO_ERR(EINTR));

#endif

  return e;
}


void ___device_select_abort
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

#ifdef USE_POSIX

  static char buf[] = { 0 };

  write (___ps->os.select_abort.writing_fd, buf, 1); /* ignore error */

#endif

#ifdef USE_WIN32

  SetEvent (___ps->os.select_abort); /* ignore error */

#endif

#endif
}


___SCMOBJ ___device_force_output
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___device_force_output_virt (self, level);
}

___SCMOBJ ___device_close
   ___P((___device *self,
         int direction),
        (self,
         direction)
___device *self;
int direction;)
{
  return ___device_close_virt (self, direction);
}

___HIDDEN void device_transfer_close_responsibility
   ___P((___device *self),
        (self)
___device *self;)
{
  /*
   * Transfer responsibility for closing device to the runtime system.
   */

  self->close_direction = self->direction;
}

___HIDDEN void device_add_ref
   ___P((___device *self),
        (self)
___device *self;)
{
#ifdef USE_PUMPS
  InterlockedIncrement (&self->refcount);
#else
  self->refcount++;
#endif
}

___SCMOBJ ___device_release
   ___P((___device *self),
        (self)
___device *self;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);

  if (
#ifdef USE_PUMPS
      InterlockedDecrement (&self->refcount) == 0
#else
      --self->refcount == 0
#endif
      )
    {
      e = ___device_release_virt (self);
      ___FREE_MEM(self);
    }

  return e;
}

___SCMOBJ ___device_cleanup
   ___P((___device *self),
        (self)
___device *self;)
{
  ___SCMOBJ e;
  ___device *devs[1];

  if (self->group == NULL)
    return ___FIX(___UNKNOWN_ERR);

  ___device_remove_from_group (self);

  for (;;)
    {
      e = ___device_close (self, ___DIRECTION_RD);
      if (e == ___FIX(___NO_ERR))
        break;
      if (e != ___ERR_CODE_EAGAIN)
        return e;

      devs[0] = self;
      e = ___device_select (devs, 1, 0, 0, ___time_mod.time_pos_infinity);
      if (e != ___FIX(___NO_ERR))
        return e;
    }

  for (;;)
    {
      e = ___device_close (self, ___DIRECTION_WR);
      if (e == ___FIX(___NO_ERR))
        break;
      if (e != ___ERR_CODE_EAGAIN)
        return e;

      devs[0] = self;
      e = ___device_select (devs, 0, 1, 0, ___time_mod.time_pos_infinity);
      if (e != ___FIX(___NO_ERR))
        return e;
    }

  return ___device_release (self);
}


/*
 * Procedure called by the Scheme runtime when a device is no longer
 * reachable.
 */

___SCMOBJ ___device_cleanup_from_ptr
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
  return ___device_cleanup (___CAST(___device*,ptr));
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Timer device. */

/*
 * Timer devices are not particularly useful, given that the scheduler
 * implements timeouts.  Use this as an example.
 */

___HIDDEN int device_timer_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___TIMER_KIND;
}

___HIDDEN ___SCMOBJ device_timer_select_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_timer *d = ___CAST(___device_timer*,self);

  if (pass == ___SELECT_PASS_1)
    {
      if (___time_less (d->expiry, state->timeout))
        state->timeout = d->expiry;
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (state->timeout_reached)
    {
      if (___time_equal (d->expiry, state->timeout))
        state->devs[i] = NULL;
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ device_timer_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ device_timer_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ device_timer_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
___device *self;
int direction;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___device_timer_vtbl ___device_timer_table =
{
  {
    device_timer_kind,
    device_timer_select_virt,
    device_timer_release_virt,
    device_timer_force_output_virt,
    device_timer_close_virt
  }
};

___SCMOBJ ___device_timer_setup
   ___P((___device_timer **dev,
         ___device_group *dgroup),
        (dev,
         dgroup)
___device_timer **dev;
___device_group *dgroup;)
{
  ___device_timer *d;

  d = ___CAST(___device_timer*,
              ___ALLOC_MEM(sizeof (___device_timer)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.vtbl = &___device_timer_table;
  d->base.refcount = 1;
  d->base.direction = ___DIRECTION_RD | ___DIRECTION_WR;
  d->base.close_direction = 0; /* prevent closing on errors */
  d->base.read_stage = ___STAGE_OPEN;
  d->base.write_stage = ___STAGE_OPEN;

  d->expiry = ___time_mod.time_pos_infinity;

  *dev = d;

  ___device_add_to_group (dgroup, &d->base);

  return ___FIX(___NO_ERR);
}

void ___device_timer_set_expiry
   ___P((___device_timer *dev,
         ___time expiry),
        (dev,
         expiry)
___device_timer *dev;
___time expiry;)
{
  dev->expiry = expiry;
}

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Byte stream devices. */

#ifdef USE_PUMPS

___HIDDEN ___SCMOBJ ___device_stream_pump_setup
   ___P((___device_stream_pump **pump,
         DWORD committed_stack_size,
         LPTHREAD_START_ROUTINE proc,
         LPVOID arg),
        (pump,
         committed_stack_size,
         proc,
         arg)
___device_stream_pump **pump;
DWORD committed_stack_size;
LPTHREAD_START_ROUTINE proc;
LPVOID arg;)
{
  ___SCMOBJ e;
  ___device_stream_pump *p;
  HANDLE thread_handle;
  DWORD thread_id;

  p = ___CAST(___device_stream_pump*,
              ___ALLOC_MEM(sizeof (___device_stream_pump)));

  if (p == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  e = ___nonblocking_pipe_setup (&p->pipe, PIPE_BUFFER_SIZE+1);

  if (e != ___FIX(___NO_ERR))
    {
      ___FREE_MEM(p);
      return e;
    }

  *pump = p; /* set before thread created to avoid race condition */

  thread_handle =
    CreateThread (NULL,                 /* no security attributes       */
                  committed_stack_size, /* committed stack size         */
                  proc,                 /* thread procedure             */
                  arg,                  /* argument to thread procedure */
                  0,                    /* use default creation flags   */
                  &thread_id);

  if (thread_handle == NULL ||
      !SetThreadPriority (thread_handle, PUMP_PRIORITY))
    {
      e = err_code_from_GetLastError ();
      ___nonblocking_pipe_cleanup (&p->pipe);
      ___FREE_MEM(p);
      *pump = NULL; /* make sure caller does not think a pump was created */
      return e;
    }

  p->thread = thread_handle;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_stream_pump_reader_kill
   ___P((___device_stream_pump *pump),
        (pump)
___device_stream_pump *pump;)
{
  return ___nonblocking_pipe_set_reader_err
           (&pump->pipe,
            ___FIX(___KILL_PUMP));
}

___HIDDEN ___SCMOBJ ___device_stream_pump_writer_kill
   ___P((___device_stream_pump *pump),
        (pump)
___device_stream_pump *pump;)
{
  return ___nonblocking_pipe_set_writer_err
           (&pump->pipe,
            ___FIX(___KILL_PUMP));
}

___HIDDEN ___SCMOBJ ___device_stream_pump_wait
   ___P((___device_stream_pump *pump),
        (pump)
___device_stream_pump *pump;)
{
  DWORD code;

  code = WaitForSingleObject (pump->thread, 0);

  if (code == WAIT_FAILED)
    return err_code_from_GetLastError ();

  if (code == WAIT_TIMEOUT)
    return ___ERR_CODE_EAGAIN;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_stream_pump_cleanup
   ___P((___device_stream_pump *pump),
        (pump)
___device_stream_pump *pump;)
{
  CloseHandle (pump->thread); /* ignore error */
  ___nonblocking_pipe_cleanup (&pump->pipe); /* ignore error */
  ___FREE_MEM(pump);

  return ___FIX(___NO_ERR);
}

#endif

___SCMOBJ ___device_stream_select_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_stream *d = ___CAST(___device_stream*,self);

#ifdef USE_PUMPS

  int stage = (for_op == FOR_READING
               ? d->base.read_stage
               : d->base.write_stage);
  ___device_stream_pump *p = (for_op == FOR_READING
                              ? d->read_pump
                              : d->write_pump);

  if (p != NULL)
    {
      if (pass == ___SELECT_PASS_1)
        {
          HANDLE wait_obj;

          if (stage != ___STAGE_OPEN)
            wait_obj = p->thread;
          else
            {
              if (for_op == FOR_READING)
                wait_obj = p->pipe.revent;
              else
                wait_obj = p->pipe.wevent;
            }

          ___device_select_add_wait_obj (state, i, wait_obj);

          return ___FIX(___SELECT_SETUP_DONE);
        }

      /* pass == ___SELECT_PASS_CHECK */

      if (stage != ___STAGE_OPEN)
        state->devs[i] = NULL;
      else
        {
          if (state->devs_next[i] != -1)
            state->devs[i] = NULL;
        }

      return ___FIX(___NO_ERR);
    }

#endif

  return ___device_stream_select_raw_virt
           (d,
            for_op,
            i,
            pass,
            state);
}


___SCMOBJ ___device_stream_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  ___SCMOBJ e;
  ___device_stream *d = ___CAST(___device_stream*,self);

  e = ___device_stream_release_raw_virt (d);

#ifdef USE_PUMPS

  {
    ___device_stream_pump *p;

    p = d->read_pump;
    if (p != NULL)
      ___device_stream_pump_cleanup (p); /* ignore error */

    p = d->write_pump;
    if (p != NULL)
      ___device_stream_pump_cleanup (p); /* ignore error */
  }

#endif

  return e;
}


___SCMOBJ ___device_stream_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  ___device_stream *d = ___CAST(___device_stream*,self);

#ifdef USE_PUMPS

  {
    ___device_stream_pump *p = d->write_pump;

    if (p != NULL)
      {
        ___nonblocking_pipe_oob_msg oob_msg;

        oob_msg.op = OOB_FORCE_OUTPUT0 + level;

        return ___nonblocking_pipe_write_oob (&p->pipe, &oob_msg);
      }
  }

#endif

  return ___device_stream_force_output_raw_virt (d, level);
}


___SCMOBJ ___device_stream_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
___device *self;
int direction;)
{
  ___device_stream *d = ___CAST(___device_stream*,self);

#ifdef USE_PUMPS

  if (direction & ___DIRECTION_RD)
    {
      ___device_stream_pump *p = d->read_pump;

      if (p != NULL)
        ___device_stream_pump_reader_kill (p);
    }

  if (direction & ___DIRECTION_WR)
    {
      ___device_stream_pump *p = d->write_pump;

      if (p != NULL)
        ___device_stream_pump_writer_kill (p);
    }

#endif

  return ___device_stream_close_raw_virt (d, direction);
}


___SCMOBJ ___device_stream_seek
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
#ifdef USE_PUMPS

  {
    ___device_stream_pump *p = self->write_pump;

    if (p != NULL)
      {
        ___nonblocking_pipe_oob_msg oob_msg;

        oob_msg.op = OOB_SEEK_ABS + whence;
        oob_msg.stream_index_param = *pos;

        return ___nonblocking_pipe_write_oob (&p->pipe, &oob_msg);
      }
  }

#endif

  return ___device_stream_seek_raw_virt (self, pos, whence);
}

___SCMOBJ ___device_stream_read
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
#ifdef USE_PUMPS

  {
    ___device_stream_pump *p = self->read_pump;

    if (p != NULL)
      {
        ___nonblocking_pipe_oob_msg oob_msg;
        return ___nonblocking_pipe_read
                 (&p->pipe,
                  buf,
                  len,
                  len_done,
                  &oob_msg);
      }
  }

#endif

  return ___device_stream_read_raw_virt (self, buf, len, len_done);
}

___SCMOBJ ___device_stream_write
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
#ifdef USE_PUMPS

  {
    ___device_stream_pump *p = self->write_pump;

    if (p != NULL)
      return ___nonblocking_pipe_write (&p->pipe, buf, len, len_done);
  }

#endif

  return ___device_stream_write_raw_virt (self, buf, len, len_done);
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#ifdef USE_PUMPS

___HIDDEN DWORD WINAPI ___device_stream_read_pump_proc
   ___P((LPVOID param),
        (param)
LPVOID param;)
{
  ___device_stream *dev = ___CAST(___device_stream*,param);
  ___nonblocking_pipe *p = &dev->read_pump->pipe;
  ___SCMOBJ e;
  ___stream_index len;
  ___stream_index n;
  ___stream_index i;
  ___U8 buf[PIPE_BUFFER_SIZE];
  ___nonblocking_pipe_oob_msg oob_msg;

  for (;;)
    {
      /* wait until the reader needs some data */

      e = ___nonblocking_pipe_write_ready_wait (p);

      /* read some characters from device */

      if (e == ___FIX(___NO_ERR))
        e = ___device_stream_read_raw_virt (dev, buf, PIPE_BUFFER_SIZE, &len);

      if (e == ___FIX(___NO_ERR))
        {
          if (len == 0)
            {
              /* we reached the end-of-stream */

              oob_msg.op = OOB_EOS;

              while ((e = ___nonblocking_pipe_write_oob (p, &oob_msg))
                     == ___ERR_CODE_EAGAIN)
                {
                  /* suspend thread until operation can be performed */

                  e = ___nonblocking_pipe_write_ready_wait (p);
                  if (e != ___FIX(___NO_ERR))
                    break;
                }
              if (e != ___FIX(___NO_ERR))
                break;
            }
          else
            {
              /* write to the pipe the bytes that were read */

              i = 0;

              while (i < len)
                {
                  while ((e = ___nonblocking_pipe_write (p, buf+i, len-i, &n))
                         == ___ERR_CODE_EAGAIN)
                    {
                      /* suspend thread until operation can be performed */

                      e = ___nonblocking_pipe_write_ready_wait (p);
                      if (e != ___FIX(___NO_ERR))
                        break;
                    }
                  if (e != ___FIX(___NO_ERR))
                    break;
                  i += n;
                }
            }
        }

      if (e != ___FIX(___NO_ERR))
        {
          if (e == ___FIX(___KILL_PUMP)) /* terminate? */
            break;

          if (e == ___ERR_CODE_EAGAIN)
            continue;

          /* report the failure back through the pipe */

          e = ___nonblocking_pipe_set_writer_err (p, e);

          if (e != ___FIX(___NO_ERR))
            {
              /*
               * The failure could not be reported. To avoid an
               * infinite loop the thread is terminated.
               */

              ExitThread (0);
            }
        }
    }

  ___device_release (&dev->base); /* ignore error */

  return 0;
}

___HIDDEN DWORD WINAPI ___device_stream_write_pump_proc
   ___P((LPVOID param),
        (param)
LPVOID param;)
{
  ___device_stream *dev = ___CAST(___device_stream*,param);
  ___nonblocking_pipe *p = &dev->write_pump->pipe;
  ___SCMOBJ e;
  ___stream_index len;
  ___stream_index n;
  ___stream_index i;
  ___U8 buf[PIPE_BUFFER_SIZE];
  ___nonblocking_pipe_oob_msg oob_msg;

  for (;;)
    {
      /* get from the pipe some bytes to write to the device */

      while ((e = ___nonblocking_pipe_read
                    (p,
                     buf,
                     PIPE_BUFFER_SIZE,
                     &len,
                     &oob_msg))
             == ___ERR_CODE_EAGAIN)
        {
          /* suspend thread until operation can be performed */

          e = ___nonblocking_pipe_read_ready_wait (p);
          if (e != ___FIX(___NO_ERR))
            break;
        }

      if (e == ___FIX(___NO_ERR))
        {
          if (len > 0)
            {
              /* write to the device the bytes that were read from the pipe */

              i = 0;

              while (i < len)
                {
                  e = ___device_stream_write_raw_virt (dev, buf+i, len-i, &n);
                  if (e != ___FIX(___NO_ERR))
                    break;
                  i += n;
                }
            }
          else
            {
              switch (oob_msg.op)
                {
                case OOB_FORCE_OUTPUT0:
                case OOB_FORCE_OUTPUT1:
                case OOB_FORCE_OUTPUT2:
                case OOB_FORCE_OUTPUT3:
#ifdef ___DEBUG_LOG
                  ___printf ("***** got OOB_FORCE_OUTPUT%d\n",
                             oob_msg.op - OOB_FORCE_OUTPUT0);
#endif
                  e = ___device_stream_force_output_raw_virt (dev, oob_msg.op - OOB_FORCE_OUTPUT0);
                  break;
                case OOB_SEEK_ABS:
                case OOB_SEEK_REL:
                case OOB_SEEK_REL_END:
#ifdef ___DEBUG_LOG
                  ___printf ("***** got OOB_SEEK %d %d\n",
                             oob_msg.stream_index_param,
                             oob_msg.op - OOB_SEEK_ABS);
#endif
                  e = ___device_stream_seek_raw_virt
                        (dev,
                         &oob_msg.stream_index_param,
                         oob_msg.op - OOB_SEEK_ABS);
                  break;
                case OOB_EOS:
#ifdef ___DEBUG_LOG
                  ___printf ("***** got OOB_EOS\n");
#endif
                  break;
                }
            }
        }

      if (e != ___FIX(___NO_ERR))
        {
          if (e == ___FIX(___KILL_PUMP)) /* terminate? */
            break;

          /* report the failure back through the pipe */

          e = ___nonblocking_pipe_set_reader_err (p, e);

          if (e != ___FIX(___NO_ERR))
            {
              /*
               * The failure could not be reported. To avoid an
               * infinite loop the thread is terminated.
               */

              ExitThread (0);
            }
        }
    }

  ___device_release (&dev->base); /* ignore error */

  return 0;
}

#endif

___SCMOBJ ___device_stream_setup
   ___P((___device_stream *dev,
         ___device_group *dgroup,
         int direction,
         int io_settings,
         int pumps_on),
        (dev,
         dgroup,
         direction,
         io_settings,
         pumps_on)/*********************/
___device_stream *dev;
___device_group *dgroup;
int direction;
int io_settings;
int pumps_on;)
{
  dev->base.refcount = 1;
  dev->base.direction = direction;
  dev->base.close_direction = 0; /* prevent closing on errors */
  dev->base.read_stage = ___STAGE_CLOSED;
  dev->base.write_stage = ___STAGE_CLOSED;

  dev->io_settings = io_settings;

#ifdef USE_PUMPS
  dev->read_pump = NULL;
  dev->write_pump = NULL;
#endif

  ___device_add_to_group (dgroup, &dev->base);

  if (direction & ___DIRECTION_RD)
    {
      dev->base.read_stage = ___STAGE_OPEN;

#ifdef USE_PUMPS

      if (pumps_on & ___DIRECTION_RD)
        {
          ___SCMOBJ e;

          device_add_ref (&dev->base);

          if ((e = ___device_stream_pump_setup
                     (&dev->read_pump,
                      65536,
                      ___device_stream_read_pump_proc,
                      dev))
              != ___FIX(___NO_ERR))
            {
              ___device_release (&dev->base); /* ignore error */
              ___device_cleanup (&dev->base); /* ignore error */
              return e;
            }
        }

#endif
    }

  if (direction & ___DIRECTION_WR)
    {
      dev->base.write_stage = ___STAGE_OPEN;

#ifdef USE_PUMPS

      if (pumps_on & ___DIRECTION_WR)
        {
          ___SCMOBJ e;

          device_add_ref (&dev->base);

          if ((e = ___device_stream_pump_setup
                     (&dev->write_pump,
                      65536,
                      ___device_stream_write_pump_proc,
                      dev))
              != ___FIX(___NO_ERR))
            {
              ___device_release (&dev->base); /* ignore error */
              ___device_cleanup (&dev->base); /* ignore error */
              return e;
            }
        }

#endif
    }

  return ___FIX(___NO_ERR);
}


/*---------------------------------------------------------------------------*/

/* Serial stream device */

#ifdef USE_WIN32

typedef struct ___device_serial_struct
  {
    ___device_stream base;
    HANDLE h;
  } ___device_serial;

typedef struct ___device_serial_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_serial_vtbl;

___HIDDEN int ___device_serial_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___SERIAL_DEVICE_KIND;
}

___HIDDEN ___SCMOBJ ___device_serial_close_raw_virt
   ___P((___device_stream *self,
         int direction),
        (self,
         direction)
___device_stream *self;
int direction;)
{
  ___device_serial *d = ___CAST(___device_serial*,self);
  int is_not_closed = 0;

  if (d->base.base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

  if (is_not_closed == (___DIRECTION_RD|___DIRECTION_WR))
    {
      d->base.base.read_stage = ___STAGE_CLOSED;
      d->base.base.write_stage = ___STAGE_CLOSED;

      if ((d->base.base.close_direction & (___DIRECTION_RD|___DIRECTION_WR))
          == (___DIRECTION_RD|___DIRECTION_WR))
        {
          if (!CloseHandle (d->h))
            return err_code_from_GetLastError ();
        }
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_select_raw_virt
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
  ___device_serial *d = ___CAST(___device_serial*,self);
  int stage = (for_op == FOR_READING
               ? d->base.base.read_stage
               : d->base.base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        state->timeout = ___time_mod.time_neg_infinity;
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_release_raw_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_force_output_raw_virt
   ___P((___device_stream *self,
         int level),
        (self,
         level)
___device_stream *self;
int level;)
{
  ___device_serial *d = ___CAST(___device_serial*,self);

  if (d->base.base.write_stage == ___STAGE_OPEN)
    {
      if (level > 0)
        {
          if (!FlushFileBuffers (d->h))
            return err_code_from_GetLastError ();
        }
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_seek_raw_virt
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
  return ___FIX(___INVALID_OP_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_read_raw_virt
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
  ___device_serial *d = ___CAST(___device_serial*,self);

  if (d->base.base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  {
    DWORD n;

    if (!ReadFile (d->h, buf, len, &n, NULL))
      return err_code_from_GetLastError ();

    if (n == 0)
      return ___ERR_CODE_EAGAIN;

    *len_done = n;
  }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_write_raw_virt
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
  ___device_serial *d = ___CAST(___device_serial*,self);

  if (d->base.base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  {
    DWORD n;

    if (!WriteFile (d->h, buf, len, &n, NULL))
      {
        /*
         * Even though WriteFile has reported a failure, the operation
         * was executed correctly (i.e. len_done contains the number
         * of bytes written) if GetLastError returns ERROR_SUCCESS.
         */

        if (GetLastError () != ERROR_SUCCESS)
          return err_code_from_GetLastError ();
      }

    *len_done = n;
  }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_serial_width_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(80);
}

___HIDDEN ___SCMOBJ ___device_serial_default_options_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  int settings = ___io_settings_finalize
                   (self->io_settings,
                    ___IO_SETTINGS_DEFAULT);
  int char_encoding_errors = ___CHAR_ENCODING_ERRORS(settings);
  int char_encoding = ___CHAR_ENCODING(settings);
  int eol_encoding = ___EOL_ENCODING(settings);
  int buffering = ___BUFFERING(settings);

  return ___FIX(___STREAM_OPTIONS(char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering,
                                  char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering));
}


___HIDDEN ___SCMOBJ ___device_serial_options_set_virt
   ___P((___device_stream *self,
         ___SCMOBJ options),
        (self,
         options)
___device_stream *self;
___SCMOBJ options;)
{
  return ___FIX(___NO_ERR);
}


___HIDDEN ___device_serial_vtbl ___device_serial_table =
{
  {
    {
      ___device_serial_kind,
      ___device_stream_select_virt,
      ___device_stream_release_virt,
      ___device_stream_force_output_virt,
      ___device_stream_close_virt
    },
    ___device_serial_select_raw_virt,
    ___device_serial_release_raw_virt,
    ___device_serial_force_output_raw_virt,
    ___device_serial_close_raw_virt,
    ___device_serial_seek_raw_virt,
    ___device_serial_read_raw_virt,
    ___device_serial_write_raw_virt,
    ___device_serial_width_virt,
    ___device_serial_default_options_virt,
    ___device_serial_options_set_virt
  }
};


___HIDDEN ___SCMOBJ ___device_serial_set_comm_state
   ___P((___device_serial *dev,
         LPCTSTR def),
        (dev,
         def)
___device_serial *dev;
LPCTSTR def;)
{
  DCB dcb;

  FillMemory (&dcb, sizeof (dcb), 0);

  if (!GetCommState (dev->h, &dcb) ||
      !BuildCommDCB (def, &dcb) ||
      !SetCommState (dev->h, &dcb))
    return err_code_from_GetLastError ();

  return ___FIX(___NO_ERR);
}

___SCMOBJ ___device_serial_setup_from_handle
   ___P((___device_serial **dev,
         ___device_group *dgroup,
         HANDLE h,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         h,
         direction,
         io_settings)
___device_serial **dev;
___device_group *dgroup;
HANDLE h;
int direction;
int io_settings;)
{
  ___device_serial *d;
  ___SCMOBJ e;
  COMMTIMEOUTS cto;

  d = ___CAST(___device_serial*,
              ___ALLOC_MEM(sizeof (___device_serial)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_serial_table;
  d->h = h;

  *dev = d;

  e = ___device_serial_set_comm_state (d, _T("baud=38400 parity=N data=8 stop=1"));

  if (e != ___FIX(___NO_ERR))
    {
      ___FREE_MEM(d);
      return e;
    }

  /*
   * Setup serial device so that ReadFile will return as soon as a
   * character is available.
   */

  cto.ReadIntervalTimeout         = MAXDWORD;
  cto.ReadTotalTimeoutMultiplier  = MAXDWORD;
  cto.ReadTotalTimeoutConstant    = 1; /* wait no more than 1 ms */
  cto.WriteTotalTimeoutMultiplier = 0;
  cto.WriteTotalTimeoutConstant   = 0;

  if (!SetCommTimeouts (h, &cto)
#ifdef USE_BIG_SERIAL_BUFFERS
      || !SetupComm (h, 65536, 65536))
#endif
     )
    {
      e = err_code_from_GetLastError ();
      ___FREE_MEM(d);
      return e;
    }

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            ___DIRECTION_RD|___DIRECTION_WR);
}

#endif


/*---------------------------------------------------------------------------*/

/* Pipe stream device */

/*
 * Pipes may be unidirectional or bidirectional.  Bidirectional pipes
 * are implemented with 2 OS pipes: a "write" pipe and a "read" pipe.
 */

typedef struct ___device_pipe_struct
  {
    ___device_stream base;

#ifdef USE_POSIX
    int fd_wr;  /* file descriptor for "write" pipe (-1 if none) */
    int fd_rd;  /* file descriptor for "read" pipe (-1 if none) */
    int poll_interval_nsecs;  /* interval between read attempts */
#endif

#ifdef USE_WIN32
    HANDLE h_wr;  /* handle for "write" pipe (NULL if none) */
    HANDLE h_rd;  /* handle for "read" pipe (NULL if none) */
    int poll_interval_nsecs;  /* interval between read attempts */
#endif
  } ___device_pipe;


typedef struct ___device_pipe_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_pipe_vtbl;

___HIDDEN int ___device_pipe_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___PIPE_DEVICE_KIND;
}

___SCMOBJ ___device_pipe_cleanup
   ___P((___device_pipe *dev),
        (dev)
___device_pipe *dev;)
{
  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_pipe_close_raw_virt
   ___P((___device_stream *self,
         int direction),
        (self,
         direction)
___device_stream *self;
int direction;)
{
  ___device_pipe *d = ___CAST(___device_pipe*,self);
  int is_not_closed = 0;

  if (d->base.base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

  if (is_not_closed & direction & ___DIRECTION_RD)
    {
      /* Close "read" pipe */

      d->base.base.read_stage = ___STAGE_CLOSED;

      if ((d->base.base.close_direction & ___DIRECTION_RD)
          == ___DIRECTION_RD)
        {
#ifdef USE_POSIX
          if (d->fd_rd >= 0 &&
              d->fd_rd != d->fd_wr &&
              ___close_no_EINTR (d->fd_rd) < 0)
            return err_code_from_errno ();
#endif

#ifdef USE_WIN32
          if (d->h_rd != NULL &&
              d->h_rd != d->h_wr)
            CloseHandle (d->h_rd); /* ignore error */
#endif
        }
    }

  if (is_not_closed & direction & ___DIRECTION_WR)
    {
      /* Close "write" pipe */

      d->base.base.write_stage = ___STAGE_CLOSED;

      if ((d->base.base.close_direction & ___DIRECTION_WR)
          == ___DIRECTION_WR)
        {
#ifdef USE_POSIX
          if (d->fd_wr >= 0 &&
              ___close_no_EINTR (d->fd_wr) < 0)
            return err_code_from_errno ();
#endif

#ifdef USE_WIN32
          if (d->h_wr != NULL)
            CloseHandle (d->h_wr); /* ignore error */
#endif
        }
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_pipe_select_raw_virt
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
  ___device_pipe *d = ___CAST(___device_pipe*,self);
  int stage = (for_op == FOR_READING
               ? d->base.base.read_stage
               : d->base.base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        state->timeout = ___time_mod.time_neg_infinity;
      else
        {
#ifdef USE_POSIX
          if (for_op == FOR_READING)
            {
              if (d->fd_rd >= 0)
                ___device_select_add_fd (state, d->fd_rd, for_op);
              if (d->poll_interval_nsecs > 0)
                {
                  int interval = d->poll_interval_nsecs * 6 / 5;
                  if (interval < 1000000)
                    interval = 1000000; /* min interval = 0.001 secs */
                  else if (interval > 200000000)
                    interval = 200000000; /* max interval = 0.2 sec */
                  d->poll_interval_nsecs = interval;
                  ___device_select_add_relative_timeout (state, i, interval * 1e-9);
                }
            }
          else
            {
              if (d->fd_wr >= 0)
                ___device_select_add_fd (state, d->fd_wr, for_op);
            }
#endif

#ifdef USE_WIN32
          if (for_op == FOR_READING)
            {
              if (d->h_rd != NULL)
                {
                  int interval = d->poll_interval_nsecs * 6 / 5;
                  if (interval < 1000000)
                    interval = 1000000; /* min interval = 0.001 secs */
                  else if (interval > 200000000)
                    interval = 200000000; /* max interval = 0.2 sec */
                  d->poll_interval_nsecs = interval;
                  ___device_select_add_relative_timeout (state, i, interval * 1e-9);
                }
            }
          else
            {
              if (d->h_wr != NULL)
                ___device_select_add_wait_obj (state, i, d->h_wr);
            }
#endif
        }
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifdef USE_POSIX

      if (for_op == FOR_READING)
        {
          if (d->fd_rd < 0 ||
              d->poll_interval_nsecs > 0 ||
              ___FD_ISSET(d->fd_rd, state->readfds))
            state->devs[i] = NULL;
        }
      else
        {
          if (d->fd_wr < 0 || ___FD_ISSET(d->fd_wr, state->writefds))
            state->devs[i] = NULL;
        }

#endif

#ifdef USE_WIN32

      if (for_op == FOR_READING)
        {
          if (d->h_rd != NULL)
            state->devs[i] = NULL;
        }
      else
        {
          if (d->h_wr != NULL && state->devs_next[i] != -1)
            state->devs[i] = NULL;
        }

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_pipe_release_raw_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_pipe_force_output_raw_virt
   ___P((___device_stream *self,
         int level),
        (self,
         level)
___device_stream *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_pipe_seek_raw_virt
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
  return ___FIX(___INVALID_OP_ERR);
}

___HIDDEN ___SCMOBJ ___device_pipe_read_raw_virt
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
  ___device_pipe *d = ___CAST(___device_pipe*,self);
  ___SCMOBJ e = ___FIX(___NO_ERR);

  if (d->base.base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

#ifdef USE_POSIX

  if (d->fd_rd < 0)
    *len_done = 0;
  else
    {
      int n = 0;

      if ((n = read (d->fd_rd, buf, len)) == 0)
        {
          if (d->poll_interval_nsecs > 0)
            {
              errno = EAGAIN;
              e = err_code_from_errno ();
            }

        }
      else
        {
          d->poll_interval_nsecs = 0;
          if (n < 0)
            {
#if 0
              if (errno == EIO) errno = EAGAIN;
#else
              if (errno == EIO) /* on linux, treating EIO as EAGAIN gives an infinite loop */
                n = 0;
              else
#endif
                e = err_code_from_errno ();
            }
        }

      *len_done = n;
    }

#endif

#ifdef USE_WIN32

  if (d->h_rd == NULL)
    *len_done = 0;
  else
    {
      DWORD n = 0;

      if (!PeekNamedPipe (d->h_rd, NULL, 0, NULL, &n, NULL))
        e = err_code_from_GetLastError ();
      else if (n == 0)
        e = ___ERR_CODE_EAGAIN;
      else
        {
          if (len > n)
            len = n;

          if (!ReadFile (d->h_rd, buf, len, &n, NULL))
            e = err_code_from_GetLastError ();
          else
            d->poll_interval_nsecs = 0;
        }

      if (e == ___FIX(___WIN32_ERR(ERROR_BROKEN_PIPE)))
        e = ___FIX(___NO_ERR); /* generate end-of-file on broken pipe */

      *len_done = n;
    }

#endif

  return e;
}

___HIDDEN ___SCMOBJ ___device_pipe_write_raw_virt
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
  ___device_pipe *d = ___CAST(___device_pipe*,self);

  if (d->base.base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

#ifdef USE_POSIX

  if (d->fd_wr < 0)
    *len_done = len;
  else
    {
      int n;

      if ((n = write (d->fd_wr, buf, len)) < 0)
        return err_code_from_errno ();

      *len_done = n;
    }

#endif

#ifdef USE_WIN32

  if (d->h_wr == NULL)
    *len_done = len;
  else
    {
      DWORD n;

      if (!WriteFile (d->h_wr, buf, len, &n, NULL))
        return err_code_from_GetLastError ();

      *len_done = n;
    }

#endif

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_pipe_width_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(80);
}

___HIDDEN ___SCMOBJ ___device_pipe_default_options_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  int settings = ___io_settings_finalize
                   (self->io_settings,
#ifdef USE_WIN32
                    ___BUFFERING_MASK(___IO_SETTINGS_DEFAULT)|___NO_BUFFERING
#else
                    ___IO_SETTINGS_DEFAULT
#endif
                   );
  int char_encoding_errors = ___CHAR_ENCODING_ERRORS(settings);
  int char_encoding = ___CHAR_ENCODING(settings);
  int eol_encoding = ___EOL_ENCODING(settings);
  int buffering = ___BUFFERING(settings);

  return ___FIX(___STREAM_OPTIONS(char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering,
                                  char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering));
}


___HIDDEN ___SCMOBJ ___device_pipe_options_set_virt
   ___P((___device_stream *self,
         ___SCMOBJ options),
        (self,
         options)
___device_stream *self;
___SCMOBJ options;)
{
  return ___FIX(___NO_ERR);
}


___HIDDEN ___device_pipe_vtbl ___device_pipe_table =
{
  {
    {
      ___device_pipe_kind,
      ___device_stream_select_virt,
      ___device_stream_release_virt,
      ___device_stream_force_output_virt,
      ___device_stream_close_virt
    },
    ___device_pipe_select_raw_virt,
    ___device_pipe_release_raw_virt,
    ___device_pipe_force_output_raw_virt,
    ___device_pipe_close_raw_virt,
    ___device_pipe_seek_raw_virt,
    ___device_pipe_read_raw_virt,
    ___device_pipe_write_raw_virt,
    ___device_pipe_width_virt,
    ___device_pipe_default_options_virt,
    ___device_pipe_options_set_virt
  }
};


#ifdef USE_POSIX

___HIDDEN ___SCMOBJ ___device_pipe_setup_from_fd
   ___P((___device_pipe **dev,
         ___device_group *dgroup,
         int fd_rd,
         int fd_wr,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         fd_rd,
         fd_wr,
         direction,
         io_settings)
___device_pipe **dev;
___device_group *dgroup;
int fd_rd;
int fd_wr;
int direction;
int io_settings;)
{
  ___device_pipe *d;

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (fd_rd, fd_wr))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_pipe*,
              ___ALLOC_MEM(sizeof (___device_pipe)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_pipe_table;
  d->fd_rd = (direction & ___DIRECTION_RD) ? fd_rd : -1;
  d->fd_wr = (direction & ___DIRECTION_WR) ? fd_wr : -1;
  d->poll_interval_nsecs = 1; /* wait until writing end is opened */

  *dev = d;

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            0);
}

#endif


#ifdef USE_WIN32

___HIDDEN ___SCMOBJ ___device_pipe_setup_from_handle
   ___P((___device_pipe **dev,
         ___device_group *dgroup,
         HANDLE h_rd,
         HANDLE h_wr,
         int direction,
         int io_settings,
         int pumps_on),
        (dev,
         dgroup,
         h_rd,
         h_wr,
         direction,
         io_settings,
         pumps_on)
___device_pipe **dev;
___device_group *dgroup;
HANDLE h_rd;
HANDLE h_wr;
int direction;
int io_settings;
int pumps_on;)
{
  ___device_pipe *d;

  d = ___CAST(___device_pipe*,
              ___ALLOC_MEM(sizeof (___device_pipe)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_pipe_table;
  d->h_rd = h_rd;
  d->h_wr = h_wr;
  d->poll_interval_nsecs = 0;

  *dev = d;

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            pumps_on);
}

#endif


/*---------------------------------------------------------------------------*/

/* Process stream device */

typedef struct ___device_process_struct
  {
    ___device_pipe base;

#ifdef USE_POSIX
    pid_t pid;  /* pid of the process */
#endif

#ifdef USE_WIN32
    PROCESS_INFORMATION pi;  /* process information */
#endif

    int status;          /* process status */
    ___BOOL got_status;  /* was the status retrieved? */
    ___BOOL cleanuped;   /* has process been cleaned-up? */
    int event_check_interval_nsecs;  /* interval between event checks */
  } ___device_process;

typedef struct ___device_process_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_process_vtbl;

___HIDDEN int ___device_process_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___PROCESS_DEVICE_KIND;
}

___SCMOBJ ___device_process_cleanup
   ___P((___device_process *dev),
        (dev)
___device_process *dev;)
{
  if (!dev->cleanuped)
    {
      dev->cleanuped = 1;

#ifdef USE_POSIX
#endif

#ifdef USE_WIN32

      CloseHandle (dev->pi.hProcess); /* ignore error */
      CloseHandle (dev->pi.hThread); /* ignore error */

#endif
    }

  return ___FIX(___NO_ERR);
}


___SCMOBJ ___device_process_status_set
   ___P((___device_process *dev,
         int status),
        (dev,
         status)
___device_process *dev;
int status;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);

  if (!dev->got_status)
    {
      dev->status = status;
      dev->got_status = 1;
      e = ___device_process_cleanup (dev); /* ignore error */
    }

  return e;
}


___SCMOBJ ___device_process_status_poll
   ___P((___device_process *dev),
        (dev)
___device_process *dev;)
{
  if (!dev->got_status)
    {
#ifdef USE_POSIX

      /*
       * The process status is updated asynchronously by
       * sigchld_signal_handler.
       */

#endif

#ifdef USE_WIN32

      DWORD status;

      if (!GetExitCodeProcess (dev->pi.hProcess, &status))
        return err_code_from_GetLastError ();

      if (status != STILL_ACTIVE)
        ___device_process_status_set (dev, status << 8); /* ignore error */

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_process_close_raw_virt
   ___P((___device_stream *self,
         int direction),
        (self,
         direction)
___device_stream *self;
int direction;)
{
  ___device_process *d = ___CAST(___device_process*,self);
  ___SCMOBJ e = ___device_pipe_close_raw_virt (self, direction);

  if (e == ___FIX(___NO_ERR))
    {
      if (d->base.base.base.read_stage == ___STAGE_CLOSED &&
          d->base.base.base.write_stage == ___STAGE_CLOSED)
        ___device_process_status_poll (d); /* ignore error */
    }

  return e;
}

___HIDDEN ___SCMOBJ ___device_process_select_raw_virt
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
  ___device_process *d = ___CAST(___device_process*,self);

  if (for_op != FOR_EVENT)
    return ___device_pipe_select_raw_virt (self, for_op, i, pass, state);

  if (pass == ___SELECT_PASS_1)
    {
      if (d->got_status)
        state->timeout = ___time_mod.time_neg_infinity;
      else
        {
          int interval = d->event_check_interval_nsecs * 6 / 5;
          if (interval < 1000000)
            interval = 1000000; /* min interval = 0.001 secs */
          else if (interval > 200000000)
            interval = 200000000; /* max interval = 0.2 sec */
          d->event_check_interval_nsecs = interval;
          ___device_select_add_relative_timeout (state, i, interval * 1e-9);
        }
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (d->got_status)
    state->devs[i] = NULL;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_process_release_raw_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  ___device_process *d = ___CAST(___device_process*,self);
  ___SCMOBJ e1 = ___device_pipe_release_raw_virt (self);
  ___SCMOBJ e2 = ___device_process_cleanup (d);
  if (e1 == ___FIX(___NO_ERR))
    e1 = e2;
  return e1;
}

___HIDDEN ___SCMOBJ ___device_process_force_output_raw_virt
   ___P((___device_stream *self,
         int level),
        (self,
         level)
___device_stream *self;
int level;)
{
  return ___device_pipe_force_output_raw_virt (self, level);
}

___HIDDEN ___SCMOBJ ___device_process_seek_raw_virt
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
  return ___device_pipe_seek_raw_virt (self, pos, whence);
}

___HIDDEN ___SCMOBJ ___device_process_read_raw_virt
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
  return ___device_pipe_read_raw_virt (self, buf, len, len_done);
}

___HIDDEN ___SCMOBJ ___device_process_write_raw_virt
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
  return ___device_pipe_write_raw_virt (self, buf, len, len_done);
}

___HIDDEN ___SCMOBJ ___device_process_width_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(80);
}

___HIDDEN ___SCMOBJ ___device_process_default_options_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___device_pipe_default_options_virt (self);
}


___HIDDEN ___SCMOBJ ___device_process_options_set_virt
   ___P((___device_stream *self,
         ___SCMOBJ options),
        (self,
         options)
___device_stream *self;
___SCMOBJ options;)
{
  return ___device_pipe_options_set_virt (self, options);
}


___HIDDEN ___device_process_vtbl ___device_process_table =
{
  {
    {
      ___device_process_kind,
      ___device_stream_select_virt,
      ___device_stream_release_virt,
      ___device_stream_force_output_virt,
      ___device_stream_close_virt
    },
    ___device_process_select_raw_virt,
    ___device_process_release_raw_virt,
    ___device_process_force_output_raw_virt,
    ___device_process_close_raw_virt,
    ___device_process_seek_raw_virt,
    ___device_process_read_raw_virt,
    ___device_process_write_raw_virt,
    ___device_process_width_virt,
    ___device_process_default_options_virt,
    ___device_process_options_set_virt
  }
};

#ifdef USE_POSIX

___SCMOBJ ___device_process_setup_from_pid
   ___P((___device_process **dev,
         ___device_group *dgroup,
         pid_t pid,
         int fd_stdin,
         int fd_stdout,
         int direction),
        (dev,
         dgroup,
         pid,
         fd_stdin,
         fd_stdout,
         direction)
___device_process **dev;
___device_group *dgroup;
pid_t pid;
int fd_stdin;
int fd_stdout;
int direction;)
{
  ___device_process *d;

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (fd_stdin, fd_stdout))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_process*,
              ___ALLOC_MEM(sizeof (___device_process)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  /*
   * Setup file descriptors to perform nonblocking I/O.
   */

  if ((fd_stdout >= 0 &&
       (direction & ___DIRECTION_RD) &&
       (___set_fd_blocking_mode (fd_stdout, 0) < 0)) ||
      (fd_stdin >= 0 &&
       (direction & ___DIRECTION_WR) &&
       (___set_fd_blocking_mode (fd_stdin, 0) < 0)))
    {
      ___SCMOBJ e = err_code_from_errno ();
      ___FREE_MEM(d);
      return e;
    }

  d->base.base.base.vtbl = &___device_process_table;
  d->base.fd_rd = fd_stdout;
  d->base.fd_wr = fd_stdin;
  d->base.poll_interval_nsecs = 0; /* writing end already opened */
  d->pid = pid;
  d->status = -1;
  d->got_status = 0;
  d->cleanuped = 0;
  d->event_check_interval_nsecs = 0;

  *dev = d;

  return ___device_stream_setup
           (&d->base.base,
            dgroup,
            direction,
            0, /* no specific io_settings */
            0);
}

#endif

#ifdef USE_WIN32

___SCMOBJ ___device_process_setup_from_process
   ___P((___device_process **dev,
         ___device_group *dgroup,
         PROCESS_INFORMATION pi,
         HANDLE hstdin,
         HANDLE hstdout,
         int direction),
        (dev,
         dgroup,
         pi,
         hstdin,
         hstdout,
         direction)
___device_process **dev;
___device_group *dgroup;
PROCESS_INFORMATION pi;
HANDLE hstdin;
HANDLE hstdout;
int direction;)
{
  ___device_process *d;

  d = ___CAST(___device_process*,
              ___ALLOC_MEM(sizeof (___device_process)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.base.vtbl = &___device_process_table;
  d->base.h_rd = hstdout;
  d->base.h_wr = hstdin;
  d->base.poll_interval_nsecs = 0; /* writing end already opened */
  d->pi = pi;
  d->status = -1;
  d->got_status = 0;
  d->cleanuped = 0;
  d->event_check_interval_nsecs = 0;

  *dev = d;

  return ___device_stream_setup
           (&d->base.base,
            dgroup,
            direction,
            0, /* no specific io_settings */
            0);
}

#endif


/*---------------------------------------------------------------------------*/

#ifdef USE_NETWORKING

/* TLS support */

#ifdef USE_OPENSSL

___HIDDEN int openssl_initialized = 0;


/* TLS context */

typedef struct ___tls_context_t
{
  /* TLS protocol options */
  ___U16 min_tls_version;
  ___U16 options;

  /* Client and Server options */
  char *certificate_path;
  char *private_key_path;

  /* Server-only options */
  char *dh_params_path;
  char *elliptic_curve_name;
  char *client_ca_path;

  /* OpenSSL context */
  SSL_CTX *tls_ctx;
} ___tls_context;

___SCMOBJ ___release_rc_tls_context
   ___P((void *x),
        (x)
void *x;)
{
  ___tls_context *c = ___CAST(___tls_context*, x);

  if (c->certificate_path != NULL)
    ___release_string (c->certificate_path);
  if (c->private_key_path != NULL)
    ___release_string (c->private_key_path);
  if (c->dh_params_path != NULL)
    ___release_string (c->dh_params_path);
  if (c->elliptic_curve_name != NULL)
    ___release_string (c->elliptic_curve_name);
  if (c->client_ca_path != NULL)
    ___release_string (c->client_ca_path);

  if (c->tls_ctx != NULL)
    SSL_CTX_free (c->tls_ctx);

  ___release_rc(c);

  return ___FIX(___NO_ERR);
}

/* Fix for vulnerability http://www.cvedetails.com/cve/CVE-2009-3555/ */
#if OPENSSL_VERSION_NUMBER < 0x009080cfL

___HIDDEN void server_tls_info_callback
   ___P((const SSL *tls, int where, int ret),
        (tls, where, ret)
const SSL *tls;
int where;
int ret;)
{
  if (0 != (where & SSL_CB_HANDSHAKE_START))
    {
      ___device_tcp_client *dev = SSL_get_app_data(tls);
      ++dev->renegotiations;
    }
}

#endif

#ifndef OPENSSL_NO_DH

/* 1024-bit MODP Group with 160-bit prime order subgroup (RFC5114)
 * -----BEGIN DH PARAMETERS-----
 * MIIBDAKBgQCxC4+WoIDgHd6S3l6uXVTsUsmfvPsGo8aaap3KUtI7YWBz4oZ1oj0Y
 * mDjvHi7mUsAT7LSuqQYRIySXXDzUm4O/rMvdfZDEvXCYSI6cIZpzck7/1vrlZEc4
 * +qMaT/VbzMChUa9fDci0vUW/N982XBpl5oz9p21NpwjfH7K8LkpDcQKBgQCk0cvV
 * w/00EmdlpELvuZkF+BBN0lisUH/WQGz/FCZtMSZv6h5cQVZLd35pD1UE8hMWAhe0
 * sBuIal6RVH+eJ0n01/vX07mpLuGQnQ0iY/gKdqaiTAh6CR9THb8KAWm2oorWYqTR
 * jnOvoy13nVkY0IvIhY9Nzvl8KiSFXm7rIrOy5QICAKA=
 * -----END DH PARAMETERS-----
 */
___HIDDEN const unsigned char dh1024_p[]={
  0xB1,0x0B,0x8F,0x96,0xA0,0x80,0xE0,0x1D,0xDE,0x92,0xDE,0x5E,
  0xAE,0x5D,0x54,0xEC,0x52,0xC9,0x9F,0xBC,0xFB,0x06,0xA3,0xC6,
  0x9A,0x6A,0x9D,0xCA,0x52,0xD2,0x3B,0x61,0x60,0x73,0xE2,0x86,
  0x75,0xA2,0x3D,0x18,0x98,0x38,0xEF,0x1E,0x2E,0xE6,0x52,0xC0,
  0x13,0xEC,0xB4,0xAE,0xA9,0x06,0x11,0x23,0x24,0x97,0x5C,0x3C,
  0xD4,0x9B,0x83,0xBF,0xAC,0xCB,0xDD,0x7D,0x90,0xC4,0xBD,0x70,
  0x98,0x48,0x8E,0x9C,0x21,0x9A,0x73,0x72,0x4E,0xFF,0xD6,0xFA,
  0xE5,0x64,0x47,0x38,0xFA,0xA3,0x1A,0x4F,0xF5,0x5B,0xCC,0xC0,
  0xA1,0x51,0xAF,0x5F,0x0D,0xC8,0xB4,0xBD,0x45,0xBF,0x37,0xDF,
  0x36,0x5C,0x1A,0x65,0xE6,0x8C,0xFD,0xA7,0x6D,0x4D,0xA7,0x08,
  0xDF,0x1F,0xB2,0xBC,0x2E,0x4A,0x43,0x71,
};

___HIDDEN const unsigned char dh1024_g[]={
  0xA4,0xD1,0xCB,0xD5,0xC3,0xFD,0x34,0x12,0x67,0x65,0xA4,0x42,
  0xEF,0xB9,0x99,0x05,0xF8,0x10,0x4D,0xD2,0x58,0xAC,0x50,0x7F,
  0xD6,0x40,0x6C,0xFF,0x14,0x26,0x6D,0x31,0x26,0x6F,0xEA,0x1E,
  0x5C,0x41,0x56,0x4B,0x77,0x7E,0x69,0x0F,0x55,0x04,0xF2,0x13,
  0x16,0x02,0x17,0xB4,0xB0,0x1B,0x88,0x6A,0x5E,0x91,0x54,0x7F,
  0x9E,0x27,0x49,0xF4,0xD7,0xFB,0xD7,0xD3,0xB9,0xA9,0x2E,0xE1,
  0x90,0x9D,0x0D,0x22,0x63,0xF8,0x0A,0x76,0xA6,0xA2,0x4C,0x08,
  0x7A,0x09,0x1F,0x53,0x1D,0xBF,0x0A,0x01,0x69,0xB6,0xA2,0x8A,
  0xD6,0x62,0xA4,0xD1,0x8E,0x73,0xAF,0xA3,0x2D,0x77,0x9D,0x59,
  0x18,0xD0,0x8B,0xC8,0x85,0x8F,0x4D,0xCE,0xF9,0x7C,0x2A,0x24,
  0x85,0x5E,0x6E,0xEB,0x22,0xB3,0xB2,0xE5,
};

#endif

/* This option was introduced in OpenSSL v0.9.9 */
#if OPENSSL_VERSION_NUMBER >= 0x00909000L && !defined SSL_OP_NO_COMPRESSION
#define SSL_OP_NO_COMPRESSION 0
#endif


#ifdef USE_WIN32

#define ___OPENSSL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) utf8

#else

#define ___OPENSSL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#endif


___SCMOBJ ___os_make_tls_context
   ___P((___SCMOBJ min_tls_version,
         ___SCMOBJ options,
         ___SCMOBJ certificate_path,
         ___SCMOBJ private_key_path,
         ___SCMOBJ dh_params_path,
         ___SCMOBJ elliptic_curve_name,
         ___SCMOBJ client_ca_path),
        (min_tls_version,
         options,
         certificate_path,
         private_key_path,
         dh_params_path,
         elliptic_curve_name,
         client_ca_path)
___SCMOBJ min_tls_version;
___SCMOBJ options;
___SCMOBJ certificate_path;
___SCMOBJ private_key_path;
___SCMOBJ dh_params_path;
___SCMOBJ elliptic_curve_name;
___SCMOBJ client_ca_path;)
{
  ___SCMOBJ scm_e;
  ___SCMOBJ scm_ctx;
  int err;
  long tls_options;
  long openssl_version = 0;

  /* Server mode parameters */
#ifndef OPENSSL_NO_DH

  DH *dh;
  BIGNUM *bp, *bg;

#endif

#if OPENSSL_VERSION_NUMBER >= 0x0090800fL && !defined OPENSSL_NO_ECDH

  EC_KEY *ecdh;
  int nid;

#endif

  STACK_OF(X509_NAME) *client_ca_list = NULL;

#define OPENSSL_CHECK_ERROR(ret) \
  do {                                  \
    if ((ret) == 0)                     \
      {                                 \
        return ___FIX(___TLS_ERR(ret)); \
      }                                 \
  } while (0)

  /* TLS library Initialization */
  /* Reference for TLS initialization:
     https://github.com/lighttpd/lighttpd1.4/blob/master/src/network.c */
  if (openssl_initialized == 0)
    {
#if OPENSSL_VERSION_NUMBER >= 0x10100000L
      if (!OPENSSL_init_ssl(0, NULL))
        return ___FIX(___TLS_LIBRARY_INIT_ERR);
#else
      if (!SSL_library_init())
        return ___FIX(___TLS_LIBRARY_INIT_ERR);

      SSL_load_error_strings();
      OpenSSL_add_all_algorithms();
#endif


      /* OpenSSL version format after 0.9.3:
         MMNNFFPPS: major minor fix patch status
         The status nibble has one of the values 0 for development, 1 to e for
         betas; 1 to 14, and f for release.
         The loaded OpenSSL library must be equal or newer than the one used
         during compilation. Also, it needs to have the same Major, Minor and
         Fix parts. */
      openssl_version = SSLeay();
      if (openssl_version < OPENSSL_VERSION_NUMBER ||
          (openssl_version>>12) != (OPENSSL_VERSION_NUMBER>>12) )
        return ___FIX(___TLS_LIBRARY_VERSION_ERR);

      openssl_initialized = 1;
    }
  /* Check Entropy */
  if (RAND_status() == 0)
    return ___FIX(___TLS_NOT_ENOUGH_ENTROPY_ERR);

  /* Context initialization */
  ___tls_context *c = ___CAST(___tls_context*,
                              ___alloc_rc ( ___PSA(___PSTATE)
                                           sizeof (___tls_context)));

  if (c == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  c->min_tls_version = ___INT(min_tls_version);
  c->options = ___INT(options);

  c->certificate_path = NULL;
  c->private_key_path = NULL;
  c->dh_params_path = NULL;
  c->elliptic_curve_name = NULL;
  c->client_ca_path = NULL;
  c->tls_ctx = NULL;

  if ((scm_e = ___SCMOBJ_to_STRING
                 (___PSA(___PSTATE)
                  certificate_path,
                  ___CAST(void**,&c->certificate_path),
                  3,
                  ___CE(___OPENSSL_PATH_CE_SELECT),
                  0)
       != ___FIX(___NO_ERR)) ||
      (scm_e = ___SCMOBJ_to_STRING
                 (___PSA(___PSTATE)
                  private_key_path,
                  ___CAST(void**,&c->private_key_path),
                  4,
                  ___CE(___OPENSSL_PATH_CE_SELECT),
                  0)
       != ___FIX(___NO_ERR)) ||
      (scm_e = ___SCMOBJ_to_STRING
                 (___PSA(___PSTATE)
                  dh_params_path,
                  ___CAST(void**,&c->dh_params_path),
                  5,
                  ___CE(___OPENSSL_PATH_CE_SELECT),
                  0)
       != ___FIX(___NO_ERR)) ||
      (scm_e = ___SCMOBJ_to_CHARSTRING
                 (___PSA(___PSTATE)
                  elliptic_curve_name,
                  &c->elliptic_curve_name,
                  6)
       != ___FIX(___NO_ERR)) ||
      (scm_e = ___SCMOBJ_to_STRING
                 (___PSA(___PSTATE)
                  client_ca_path,
                  ___CAST(void**,&c->client_ca_path),
                  7,
                  ___CE(___OPENSSL_PATH_CE_SELECT),
                  0)
       != ___FIX(___NO_ERR)))
    {
      ___release_rc_tls_context (c);
      return scm_e;
    }

  /* TLS Context */

  /* Server mode */
  if (c->options & ___TLS_OPTION_SERVER_MODE)
    {
      /* References for server setup:
         https://github.com/lighttpd/lighttpd1.4/blob/master/src/network.c
         https://github.com/git-mirror/nginx/commit/10e9cec1feca191ea0b00ca729be534e372bdd66#diff-0584d16332cf0d6dd9adb990a3c76a0cR566 */

      /* TLS protocol bugs: workaround options
         Ref: https://www.openssl.org/docs/ssl/SSL_CTX_set_options.html */
      tls_options =
        SSL_OP_ALL
        /* Fix for http://www.cvedetails.com/cve/CVE-2009-3555/ (use in all versions) */
        | SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION
        /* Fix against CRIME attack */
        | SSL_OP_NO_COMPRESSION;

      c->tls_ctx = SSL_CTX_new (SSLv23_server_method());
      OPENSSL_CHECK_ERROR (___CAST(___UWORD,c->tls_ctx));

      /* Required identifier for client certificate verification to work with sessions */
      OPENSSL_CHECK_ERROR (SSL_CTX_set_session_id_context
                           (c->tls_ctx,
                            ___CAST(const unsigned char*,"gambit"),
                            6));

      /* OPTION: re-activate empty fragments countermeasure against BEAST attack.
         The countermeasure breaks some TLS implementations, so it is deactivated by
         default by SSL_OP_ALL */
      if (c->options & ___TLS_OPTION_INSERT_EMPTY_FRAGMENTS)
        {
#ifdef SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS

        tls_options &= ~SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS;

#else

        ___release_rc_tls_context (c);
        return ___FIX(___TLS_UNSUPPORTED_EMPTY_FRAGS_ERR);

#endif
        }

      OPENSSL_CHECK_ERROR (tls_options &
                           SSL_CTX_set_options (c->tls_ctx, tls_options));

      switch (c->min_tls_version)
        {
        case 0x0303:
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_TLSv1_1 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_TLSv1_1)));
        case 0x302:
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_TLSv1 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_TLSv1)));
        case 0x301:
#ifndef OPENSSL_NO_SSL3
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_SSLv3 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_SSLv3)));
        case 0x300:
#ifndef OPENSSL_NO_SSL2
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_SSLv2 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_SSLv2)));
        case 0x200:
#endif
#endif
          break;
        default:
          return ___FIX(___TLS_WRONG_TLS_VERSION_ERR);
        }

      /* OPTION: Diffie-Hellman key exchange algorithm support */
      if (c->options & ___TLS_OPTION_USE_DIFFIE_HELLMAN)
        {
#ifndef OPENSSL_NO_DH
          /* OPTION: Provided DH parameters file */
          if (c->dh_params_path != NULL)
            {
              /* DH parameters from file */
              FILE *dh_fp;
              int err;
              dh_fp = fopen (c->dh_params_path, "r");
              if (dh_fp == NULL)
                {
                  ___release_rc_tls_context (c);
                  return ___FIX(___TLS_READ_DH_PARAMS_ERR);
                }
              dh = PEM_read_DHparams (dh_fp, NULL, NULL, NULL);
              fclose (dh_fp);
              if (dh == NULL)
                {
                  ___release_rc_tls_context (c);
                  return ___FIX(___TLS_READ_DH_PARAMS_ERR);
                }
              DH_check (dh, &err);
              if (err != 0)
                {
                  ___release_rc_tls_context (c);
                  return ___FIX(___TLS_READ_DH_PARAMS_ERR);
                }
            }
          else
            {
              /* Default DH parameters from RFC5114 */
              dh = DH_new();
              if (dh == NULL)
                {
                  ___release_rc_tls_context (c);
                  return ___FIX(___TLS_DH_PARAMS_ERR);
                }
              bp = BN_bin2bn (dh1024_p, sizeof(dh1024_p), NULL);
              bg = BN_bin2bn (dh1024_g, sizeof(dh1024_g), NULL);
              if (bp == NULL || bg == NULL)
                {
                  BN_free(bp);
                  BN_free(bg);
                  DH_free (dh);
                  ___release_rc_tls_context (c);
                  return ___FIX(___TLS_DH_PARAMS_ERR);
                }
            }
#if OPENSSL_VERSION_NUMBER >= 0x10100000L
          DH_set0_pqg(dh,bp,NULL,bg);
#else
          dh->p=bp;
          dh->g=bg;
#endif
          SSL_CTX_set_tmp_dh (c->tls_ctx, dh);
          OPENSSL_CHECK_ERROR (SSL_OP_SINGLE_DH_USE &
                               SSL_CTX_set_options (c->tls_ctx,
                                                    SSL_OP_SINGLE_DH_USE));
          if (dh != NULL)
            DH_free (dh);
#else

          ___release_rc_tls_context (c);
          return ___FIX(___TLS_UNSUPPORTED_DH_ERR);

#endif
        }

      /* OPTION: Use Elliptic-Curve Diffie-Hellman key exchange */
      if ((c->options & ___TLS_OPTION_USE_ELLIPTIC_CURVES) &&
          (c->options & ___TLS_OPTION_USE_DIFFIE_HELLMAN))
        {
#if OPENSSL_VERSION_NUMBER >= 0x0090800fL && !defined OPENSSL_NO_ECDH

          if (c->elliptic_curve_name != NULL)
            {
              /* OpenSSL only supports the "named curves" from RFC 4492,
                 section 5.1.1. */
              nid = OBJ_sn2nid (c->elliptic_curve_name);
              if (nid == 0)
                {
                  ___release_rc_tls_context (c);
                  return ___FIX(___TLS_UNKNOWN_ELLIPTIC_CURVE_ERR);
                }
            }
          else
            {
              nid = OBJ_sn2nid("prime256v1");
            }
          ecdh = EC_KEY_new_by_curve_name(nid);
          if (ecdh == NULL)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_ELLIPTIC_CURVE_ERR);
            }
          SSL_CTX_set_tmp_ecdh (c->tls_ctx,ecdh);
          OPENSSL_CHECK_ERROR (SSL_OP_SINGLE_ECDH_USE &
                               SSL_CTX_set_options (c->tls_ctx,
                                                    SSL_OP_SINGLE_ECDH_USE));
          EC_KEY_free (ecdh);

#else

          ___release_rc_tls_context (c);
          return ___FIX(___TLS_UNSUPPORTED_ELLIPTIC_CURVES_ERR);

#endif
        }

      /* OPTION: Authenticate client. This requires a PEM file with accepted CAs */
      if ((c->options & ___TLS_OPTION_REQUEST_CLIENT_AUTHENTICATION) &&
          (c->client_ca_path != NULL))
        {
          client_ca_list = SSL_load_client_CA_file (c->client_ca_path);
          if (client_ca_list == NULL)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_READ_CA_FILE_ERR);
            }
          SSL_CTX_set_client_CA_list(c->tls_ctx, client_ca_list);
          SSL_CTX_set_verify (c->tls_ctx,
                              SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT,
                              NULL);
        }

      /* OPTION: Public certificate and private key files and verification */
      if ((c->certificate_path != NULL) &&
          (c->private_key_path != NULL))
        {
          if (SSL_CTX_use_certificate_file (c->tls_ctx,
                                            c->certificate_path,
                                            SSL_FILETYPE_PEM) <= 0)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_CERTIFICATE_FILE_ERR);
            }
          if (SSL_CTX_use_PrivateKey_file
              (c->tls_ctx, c->private_key_path, SSL_FILETYPE_PEM) <= 0)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_PRIVATE_KEY_FILE_ERR);
            }
          if (SSL_CTX_check_private_key (c->tls_ctx) <= 0)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_PRIVATE_KEY_CERT_MISMATCH_ERR);
            }
        }

      SSL_CTX_set_mode (c->tls_ctx,
                        SSL_MODE_ENABLE_PARTIAL_WRITE
                        | SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER
#ifdef SSL_MODE_RELEASE_BUFFERS
                        | SSL_MODE_RELEASE_BUFFERS
#endif
                        );

#if OPENSSL_VERSION_NUMBER < 0x009080cfL

      /* Link back device state to TLS state (used in info callback)
         Fix for vulnerability http://www.cvedetails.com/cve/CVE-2009-3555/ */
      SSL_set_app_data (c->tls, dev);
      SSL_CTX_set_info_callback (c->tls_ctx, server_tls_info_callback);

#endif
    }
  /* Client mode */
  else
    {
      /* TLS protocol bugs: workaround options
         Ref: https://www.openssl.org/docs/ssl/SSL_CTX_set_options.html */
      tls_options =
        SSL_OP_ALL |
        SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION |
        SSL_OP_NO_COMPRESSION;

      c->tls_ctx = SSL_CTX_new (SSLv23_client_method());
      OPENSSL_CHECK_ERROR (___CAST(___UWORD,c->tls_ctx));

      /* Required identifier for client certificate verification to work with
         sessions. */
      /* TODO: should this ID be unique per Gambit instance? */
      OPENSSL_CHECK_ERROR (SSL_CTX_set_session_id_context
                           (c->tls_ctx,
                            ___CAST(const unsigned char*,"gambit"),
                            6));

      /* OPTION: re-activate empty fragments (countermeasure against BEAST
         attack). The countermeasure breaks some TLS implementations, so it is
         deactivated by default by the SSL_OP_ALL flag */
      if (c->options & ___TLS_OPTION_INSERT_EMPTY_FRAGMENTS)
        {
#ifdef SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS

          tls_options &= ~SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS;

#else

          ___release_rc_tls_context (c);
          return ___FIX(___TLS_UNSUPPORTED_EMPTY_FRAGS_ERR);

#endif
        }

      OPENSSL_CHECK_ERROR (tls_options &
                           SSL_CTX_set_options (c->tls_ctx, tls_options));

      switch (c->min_tls_version)
        {
        case 0x0303:
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_TLSv1_1 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_TLSv1_1)));
        case 0x302:
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_TLSv1 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_TLSv1)));
        case 0x301:
#ifndef OPENSSL_NO_SSL3
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_SSLv3 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_SSLv3)));
        case 0x300:
#ifndef OPENSSL_NO_SSL2
          OPENSSL_CHECK_ERROR ((SSL_OP_NO_SSLv2 &
                                SSL_CTX_set_options (c->tls_ctx,
                                                     SSL_OP_NO_SSLv2)));
        case 0x200:
#endif
#endif
          break;
        default:
          ___release_rc_tls_context (c);
          return ___FIX(___TLS_WRONG_TLS_VERSION_ERR);
        }

      /* OPTION: Public certificate and private key files and verification */
      if ((c->certificate_path != NULL) &&
          (c->private_key_path != NULL))
        {
          if (SSL_CTX_use_certificate_file (c->tls_ctx,
                                            c->certificate_path,
                                            SSL_FILETYPE_PEM) <= 0)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_CERTIFICATE_FILE_ERR);
            }
          if (SSL_CTX_use_PrivateKey_file (c->tls_ctx,
                                           c->private_key_path,
                                           SSL_FILETYPE_PEM) <= 0)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_PRIVATE_KEY_FILE_ERR);
            }
          if (SSL_CTX_check_private_key (c->tls_ctx) <= 0)
            {
              ___release_rc_tls_context (c);
              return ___FIX(___TLS_PRIVATE_KEY_CERT_MISMATCH_ERR);
            }
        }

      SSL_CTX_set_mode (c->tls_ctx,
                        SSL_MODE_ENABLE_PARTIAL_WRITE |
                        SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER);

      /* always verify server certificate */
      SSL_CTX_set_default_verify_paths (c->tls_ctx);
      SSL_CTX_set_verify (c->tls_ctx, SSL_VERIFY_PEER, NULL);
  }

  if ((scm_e =___NONNULLPOINTER_to_SCMOBJ
               (___PSTATE,
                ___CAST(void*,c),
                ___FAL,
                ___release_rc_tls_context,
                &scm_ctx,
                ___RETURN_POS)) != ___FIX(___NO_ERR))
    {
      ___release_rc_tls_context (c);
      return scm_e;
    }

  return ___release_scmobj (scm_ctx);
}

/* TLS support functions */

___HIDDEN void clear_tls_error_queue
   ___PVOID
{
  ERR_clear_error();
}

/* TLS multithreading support */

#ifdef ___MULTIPLE_THREADED_VMS

___HIDDEN ___MUTEX *tls_mutex_buf = NULL;

___HIDDEN void tls_locking_function
   ___P((int mode, int n, const char * file, int line),
        (mode, n, file, line)
int mode;
int n;
const char *file;
int line;)
{
  if (mode & CRYPTO_LOCK)
    ___MUTEX_LOCK (tls_mutex_buf[n]);
  else
    ___MUTEX_UNLOCK (tls_mutex_buf[n]);
}

___HIDDEN  unsigned long tls_id_function
   ___PVOID
{
  return ((unsigned long)___THREAD_ID);
}

struct CRYPTO_dynlock_value
{
  ___MUTEX mutex;
};

___HIDDEN struct CRYPTO_dynlock_value *tls_dyn_create_function
   ___P((const char *file, int line),
        (file, line)
const char *file;
int line;)
{
  struct CRYPTO_dynlock_value *value;
  value = (struct CRYPTO_dynlock_value*)
    ___ALLOC_MEM(sizeof(struct CRYPTO_dynlock_value));

  if (!value)
    return NULL;

  ___MUTEX_INIT (value->mutex);
  return value;
}

___HIDDEN void tls_dyn_lock_function
   ___P((int mode,
         struct CRYPTO_dynlock_value *l,
         const char *file,
         int line),
        (mode, l, file, line)
int mode;
struct CRYPTO_dynlock_value *l;
const char *file;
int line;)
{
  if (mode & CRYPTO_LOCK)
    ___MUTEX_LOCK (l->mutex);
  else
    ___MUTEX_UNLOCK (l->mutex);
}

___HIDDEN void tls_dyn_destroy_function
   ___P((struct CRYPTO_dynlock_value *l,
         const char *file,
         int line),
        (l, file, line)
struct CRYPTO_dynlock_value *l;
const char *file;
int line;)
{
  ___MUTEX_DESTROY (l->mutex);
  ___FREE_MEM(l);
}

___HIDDEN int tls_threading_setup
   ___PVOID
{
  int i;
  tls_mutex_buf = (___MUTEX*)___ALLOC_MEM(CRYPTO_num_locks() * sizeof(___MUTEX));

  if (!tls_mutex_buf)
    return 0;

  for (i = 0;  i < CRYPTO_num_locks();  i++)
    ___MUTEX_INIT (tls_mutex_buf[i]);

#if OPENSSL_VERSION_NUMBER < 0x10001000L
  CRYPTO_set_id_callback (tls_id_function);
#elseif
  CRYPTO_THREADID_set_callback (tls_id_function);
#endif
  CRYPTO_set_locking_callback (tls_locking_function);

  CRYPTO_set_dynlock_create_callback (tls_dyn_create_function);
  CRYPTO_set_dynlock_lock_callback (tls_dyn_lock_function);
  CRYPTO_set_dynlock_destroy_callback (tls_dyn_destroy_function);

  return 1;
}

___HIDDEN int tls_threading_cleanup
   ___PVOID
{
  int i;

  if (!tls_mutex_buf)
    return 0;

#if OPENSSL_VERSION_NUMBER < 0x10001000L
  CRYPTO_set_id_callback (NULL);
#elseif
  CRYPTO_THREADID_set_callback (NULL);
#endif
  CRYPTO_set_locking_callback (NULL);

  CRYPTO_set_dynlock_create_callback (NULL);
  CRYPTO_set_dynlock_lock_callback (NULL);
  CRYPTO_set_dynlock_destroy_callback (NULL);

  for (i = 0; i < CRYPTO_num_locks(); i++)
    ___MUTEX_DESTROY (tls_mutex_buf[i]);

  ___FREE_MEM(tls_mutex_buf);
  tls_mutex_buf = NULL;

  return 1;
}

#endif
#endif
#endif


#if !defined (USE_OPENSSL) || !defined (USE_NETWORKING)

typedef void ___tls_context;

___SCMOBJ ___os_make_tls_context
   ___P((___SCMOBJ min_tls_version,
         ___SCMOBJ options,
         ___SCMOBJ certificate_path,
         ___SCMOBJ private_key_path,
         ___SCMOBJ dh_params_path,
         ___SCMOBJ elliptic_curve_name,
         ___SCMOBJ client_ca_path),
        (min_tls_version,
         options,
         certificate_path,
         private_key_path,
         dh_params_path,
         elliptic_curve_name,
         client_ca_path)
___SCMOBJ min_tls_version;
___SCMOBJ options;
___SCMOBJ certificate_path;
___SCMOBJ private_key_path;
___SCMOBJ dh_params_path;
___SCMOBJ elliptic_curve_name;
___SCMOBJ client_ca_path;)
{
  return ___FIX(___UNIMPL_ERR);
}

#endif


/*---------------------------------------------------------------------------*/

#ifdef USE_NETWORKING

/* TCP client stream device */

typedef struct ___device_tcp_client_struct
  {
    ___device_stream base;
    SOCKET_TYPE s;
    struct sockaddr addr;
    SOCKET_LEN_TYPE addrlen;
    int try_connect_again;
    int connect_done;

#ifdef USE_POSIX

    int try_connect_interval_nsecs;

#endif

#ifdef USE_WIN32

    long io_events;   /* used by ___device_tcp_client_select_raw_virt */
    HANDLE io_event;  /* used by ___device_tcp_client_select_raw_virt */

#endif

#ifdef USE_OPENSSL

    SSL *tls;

    /* Handle WANT_WRITE/WANT_READ error codes by OpenSSL: want_op[for_op] */
    int want_op[2];

#if OPENSSL_VERSION_NUMBER < 0x009080cfL

    /* Fix for vulnerability http://www.cvedetails.com/cve/CVE-2009-3555/ */
    int renegotiations = 0;

#endif
#endif
  } ___device_tcp_client;

typedef struct ___device_tcp_client_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_tcp_client_vtbl;


___HIDDEN int try_connect
   ___P((___device_tcp_client *dev),
        (dev)
___device_tcp_client *dev;)
{
  if (!SOCKET_CALL_ERROR(connect (dev->s,
                                  &dev->addr,
                                  dev->addrlen)) ||
      CONNECT_IN_PROGRESS || /* establishing connection in background */
      dev->try_connect_again == 2) /* last connect attempt? */
    {
      dev->try_connect_again = 0; /* we're done waiting */

#ifdef USE_OPENSSL

      if (dev->tls != NULL)
        SSL_connect (dev->tls);

#endif

      return 0;
    }

  if (CONNECT_WOULD_BLOCK) /* connect can't be performed now */
    return 0;

  return -1;
}

___HIDDEN int ___device_tcp_client_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___TCP_CLIENT_DEVICE_KIND;
}


___HIDDEN ___SCMOBJ ___device_tcp_client_close_raw_virt
   ___P((___device_stream *self,
         int direction),
        (self,
         direction)
___device_stream *self;
int direction;)
{
  ___device_tcp_client *d = ___CAST(___device_tcp_client*,self);
  int is_not_closed = 0;

#ifdef USE_OPENSSL

  int err;

#endif

  if (d->base.base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

#ifdef USE_OPENSSL

  if (d->tls != NULL)
    {
      if (SSL_is_init_finished(d->tls))
        {
          /*
           * Make for_op in select have the natural meaning (read for
           * read, write for write). Note that this is not strictly
           * necessary, since we are resetting to this state after
           * each ___device_select_add_fd call on TLS-enabled sockets.
           */
          d->want_op[FOR_READING] = FOR_READING;
          d->want_op[FOR_WRITING] = FOR_WRITING;

          clear_tls_error_queue();
          err = SSL_shutdown (d->tls);

          if (err == 1)
            {
            }
          else if (err > 0)
            return ___ERR_CODE_EAGAIN;
          else if (err < 0)
            {
              switch (SSL_get_error(d->tls,err))
                {
                case SSL_ERROR_WANT_READ:
                case SSL_ERROR_WANT_WRITE:
                  return ___ERR_CODE_EAGAIN;
                default:
                  /* Discard any other error in TLS shutdown: once the shutdown
                     notification has been sent, TLS allows the other part to
                     avoid responding, so we can assume the connection is closed */
                  break;
                }
            }
        }

      SSL_free (d->tls);
      d->tls = NULL;
    }

#endif

  if ((is_not_closed & ~direction) == 0)
    {
      /* Close socket when both sides are closed. */

      d->base.base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */
      d->base.base.write_stage = ___STAGE_CLOSED;

#ifdef USE_WIN32

      if (d->io_event != NULL)
        CloseHandle (d->io_event); /* ignore error */

#endif

      if ((d->base.base.close_direction & (___DIRECTION_RD|___DIRECTION_WR))
          == (___DIRECTION_RD|___DIRECTION_WR))
        {
          if (CLOSE_SOCKET(d->s) != 0)
            return ERR_CODE_FROM_SOCKET_CALL;
        }
    }
  else if (is_not_closed & direction & ___DIRECTION_RD)
    {
      /* Shutdown receiving side. */

      if ((d->base.base.close_direction & ___DIRECTION_RD)
          == ___DIRECTION_RD)
        {
          if (shutdown (d->s, SHUTDOWN_RD) != 0)
            {
              ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
              if (!NOT_CONNECTED(e))
                return e;
            }
        }

      d->base.base.read_stage = ___STAGE_CLOSED;
    }
  else if (is_not_closed & direction & ___DIRECTION_WR)
    {
      /* Shutdown sending side. */

      if ((d->base.base.close_direction & ___DIRECTION_WR)
          == ___DIRECTION_WR)
        {
          if (shutdown (d->s, SHUTDOWN_WR) != 0)
            {
              ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
              if (!NOT_CONNECTED(e))
                return e;
            }
        }

      d->base.base.write_stage = ___STAGE_CLOSED;
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_client_select_raw_virt
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
  ___device_tcp_client *d = ___CAST(___device_tcp_client*,self);
  int stage = (for_op == FOR_READING
               ? d->base.base.read_stage
               : d->base.base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        {
          state->timeout = ___time_mod.time_neg_infinity;
          return ___FIX(___SELECT_SETUP_DONE);
        }
      else
        {
#ifdef USE_POSIX

          if (d->try_connect_again != 0)
            {
              int interval = d->try_connect_interval_nsecs * 6 / 5;
              if (interval > 200000000) /* max interval = 0.2 sec */
                interval = 200000000;
              d->try_connect_interval_nsecs = interval;
              ___device_select_add_relative_timeout (state, i, interval * 1e-9);
            }
          else
            {
#ifdef USE_OPENSSL
              if (d->tls != NULL)
                {
                  /* If the connection uses TLS, choose the direction of add_fd
                     according to previous WANT_WRITE/WANT_READ. This will, in
                     some cases (during TLS handshake), invert the naturally
                     expected operation (a write requiring a select for read,
                     and viceversa). */
                  ___device_select_add_fd (state, d->s, d->want_op[for_op]);
                  /* Once the select is done, return the for_op to
                     its regular meaning (read for read, write for write) */
                  d->want_op[for_op] = for_op;
                }
              else
                ___device_select_add_fd (state, d->s, for_op);
#else
              ___device_select_add_fd (state, d->s, for_op);
#endif
            }

          return ___FIX(___SELECT_SETUP_DONE);

#endif

#ifdef USE_WIN32

          d->io_events = 0;

          return ___FIX(___NO_ERR);

#endif
        }
    }

#ifdef USE_WIN32

  else if (pass == ___SELECT_PASS_2)
    {
      if (d->try_connect_again != 0)
        d->io_events = (FD_CONNECT | FD_CLOSE);

#ifdef USE_OPENSSL

      else if (d->tls != NULL)
        {
          /* If the connection uses TLS, choose the direction of add_fd
             according to previous WANT_WRITE/WANT_READ. This will, in
             some cases (during TLS handshake), invert the naturally
             expected operation (a write requiring a select for read,
             and viceversa). */
          if (d->want_op[for_op] == FOR_READING)
            d->io_events |= (FD_READ | FD_CLOSE);
          else
            d->io_events |= (FD_WRITE | FD_CLOSE);
          /* Once the select is done, return for_op to
             its regular meaning (read for read, write for write) */
          d->want_op[for_op] = for_op;
        }

#endif

      else if (for_op == FOR_READING)
        d->io_events |= (FD_READ | FD_CLOSE);
      else
        d->io_events |= (FD_WRITE | FD_CLOSE);

      return ___FIX(___NO_ERR);
    }
  else if (pass == ___SELECT_PASS_3)
    {
      HANDLE wait_obj = d->io_event;

      ResetEvent (wait_obj); /* ignore error */

      WSAEventSelect (d->s, wait_obj, d->io_events);

      ___device_select_add_wait_obj (state, i, wait_obj);

      return ___FIX(___SELECT_SETUP_DONE);
    }

#endif

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifdef USE_POSIX

      if (d->try_connect_again != 0 ||
          (for_op == FOR_READING
           ? ___FD_ISSET(d->s, state->readfds)
           : ___FD_ISSET(d->s, state->writefds)))
        {
          d->connect_done = 1;
          state->devs[i] = NULL;
        }

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        {
          state->devs[i] = NULL;
          if (d->try_connect_again != 0)
            {
              d->connect_done = 1;
              d->try_connect_again = 2;
            }
        }

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_client_release_raw_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  ___device_tcp_client *d = ___CAST(___device_tcp_client*,self);

#ifdef USE_OPENSSL
  if (d->tls != NULL)
    SSL_free (d->tls);

#endif
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_client_force_output_raw_virt
   ___P((___device_stream *self,
         int level),
        (self,
         level)
___device_stream *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_client_seek_raw_virt
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
  return ___FIX(___INVALID_OP_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_client_read_raw_virt
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
  ___device_tcp_client *d = ___CAST(___device_tcp_client*,self);
  int n;

  if (d->base.base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if (d->try_connect_again != 0)
    {
      if (try_connect (d) == 0)
        {
          if (d->try_connect_again != 0)
            return ___ERR_CODE_EAGAIN;
        }
      else
        return ERR_CODE_FROM_SOCKET_CALL;
    }

#ifdef USE_OPENSSL

#if OPENSSL_VERSION_NUMBER < 0x009080cfL

  /* Fix for vulnerability http://www.cvedetails.com/cve/CVE-2009-3555/ */
  if (d->renegotiations > 0)
    return ___FIX(___TLS_ALERT_ERR);

#endif

  /* The current thread's error queue must be empty before the TLS I/O
     operation is attempted, or SSL_get_error() will not work reliably. */
  clear_tls_error_queue();
  if (d->tls)
    {
      n = SSL_read (d->tls, ___CAST(char*,buf), len);

      if (n > 0)
        *len_done = n;
      else if (n == 0)
        {
          /* Check if the other part initiated a shutdown and we didn't reply */
          int shut = SSL_get_shutdown (d->tls);
          if ((shut & SSL_RECEIVED_SHUTDOWN) && !(shut & SSL_SENT_SHUTDOWN))
            {
              clear_tls_error_queue();
              SSL_shutdown (d->tls);
            }

          int err = SSL_get_error(d->tls,n);
          switch (err)
            {
            /* The SSL connection is closed: nothing to do */
            case SSL_ERROR_ZERO_RETURN:
              *len_done = 0;
              return ___FIX(___NO_ERR);
              /* Internal/protocol error */
            case SSL_ERROR_SYSCALL:
            case SSL_ERROR_SSL:
            default:
              return ___FIX(___TLS_ERR(err));
            }
        }
      else
        {
          int err = SSL_get_error(d->tls,n);
          switch (err)
            {
            case SSL_ERROR_WANT_READ:
              /* want read, FOR_READING */
              d->want_op[FOR_READING] = FOR_READING;
              return ___ERR_CODE_EAGAIN;
            case SSL_ERROR_WANT_WRITE:
              /* want write, FOR_READING */
              d->want_op[FOR_READING] = FOR_WRITING;
              return ___ERR_CODE_EAGAIN;
            /* These errors require straight repetition */
            case SSL_ERROR_WANT_ACCEPT:
            case SSL_ERROR_WANT_CONNECT:
            case SSL_ERROR_WANT_X509_LOOKUP:
              return ___ERR_CODE_EAGAIN;
            /* Internal/protocol error */
            case SSL_ERROR_SYSCALL:
            case SSL_ERROR_SSL:
            default:
              return ___FIX(___TLS_ERR(err));
            }
        }
    }
  else
    {
      if (SOCKET_CALL_ERROR(n = recv (d->s, ___CAST(char*,buf), len, 0)))
        {
          ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
          if (NOT_CONNECTED(e) && !d->connect_done)
            e = ___ERR_CODE_EAGAIN;
          return e;
        }
      *len_done = n;
    }

#else

  if (SOCKET_CALL_ERROR(n = recv (d->s, ___CAST(char*,buf), len, 0)))
    {
      ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
      if (NOT_CONNECTED(e) && !d->connect_done)
        e = ___ERR_CODE_EAGAIN;
      return e;
    }

  *len_done = n;

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tcp_client_write_raw_virt
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
  ___device_tcp_client *d = ___CAST(___device_tcp_client*,self);
  int n;

  if (d->base.base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if (d->try_connect_again != 0)
    {
      if (try_connect (d) == 0)
        {
          if (d->try_connect_again != 0)
            return ___ERR_CODE_EAGAIN;
        }
      else
        return ERR_CODE_FROM_SOCKET_CALL;
    }

#ifdef USE_OPENSSL

#if OPENSSL_VERSION_NUMBER < 0x009080cfL

  /* Fix for vulnerability http://www.cvedetails.com/cve/CVE-2009-3555/ */
  if (d->renegotiations > 0)
    return ___FIX(___TLS_ALERT_ERR);

#endif

  /* The current thread's error queue must be empty before the TLS I/O
     operation is attempted, or SSL_get_error() will not work reliably. */
  clear_tls_error_queue();

  if (d->tls)
    {
      n = SSL_write (d->tls, ___CAST(char*,buf), len);

      if (n > 0)
        *len_done = n;
      else if (n == 0)
        {
          /* Check if the other part initiated a shutdown and we didn't reply */
          int shut = SSL_get_shutdown (d->tls);
          if ((shut & SSL_RECEIVED_SHUTDOWN) && !(shut & SSL_SENT_SHUTDOWN))
            {
              clear_tls_error_queue();
              SSL_shutdown (d->tls);
            }

          /* Then look into what actually happened */
          int err = SSL_get_error(d->tls,n);
          switch (err)
            {
            /* The SSL connection is closed: nothing to do */
            case SSL_ERROR_ZERO_RETURN:
              return ___FIX(___NO_ERR);
            /* Internal/protocol error */
            case SSL_ERROR_SYSCALL:
            case SSL_ERROR_SSL:
            default:
              return ___FIX(___TLS_ERR(err));
            }
        }
      else
        {
          int err = SSL_get_error(d->tls,n);
          switch (err)
            {
            case SSL_ERROR_WANT_READ:
              /* want read, FOR_WRITING */
              d->want_op[FOR_WRITING] = FOR_READING;
              return ___ERR_CODE_EAGAIN;
            case SSL_ERROR_WANT_WRITE:
              /* want write, FOR_WRITING */
              d->want_op[FOR_WRITING] = FOR_WRITING;
              return ___ERR_CODE_EAGAIN;
            /* These errors require straight repetition */
            case SSL_ERROR_WANT_ACCEPT:
            case SSL_ERROR_WANT_CONNECT:
            case SSL_ERROR_WANT_X509_LOOKUP:
              return ___ERR_CODE_EAGAIN;
            /* Internal/protocol error */
            case SSL_ERROR_SYSCALL:
            case SSL_ERROR_SSL:
            default:
              return ___FIX(___TLS_ERR(err));
            }
        }
    }
  else
    {
      if (SOCKET_CALL_ERROR(n = send (d->s, ___CAST(char*,buf), len, 0)))
        {
          ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
          if (NOT_CONNECTED(e) && !d->connect_done)
            e = ___ERR_CODE_EAGAIN;
          return e;
        }
      *len_done = n;
    }

#else

  if (SOCKET_CALL_ERROR(n = send (d->s, ___CAST(char*,buf), len, 0)))
    {
      ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
      if (NOT_CONNECTED(e) && !d->connect_done)
        e = ___ERR_CODE_EAGAIN;
      return e;
    }

  *len_done = n;

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_tcp_client_width_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(80);
}


___HIDDEN ___SCMOBJ ___device_tcp_client_default_options_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  int settings = ___io_settings_finalize
                   (self->io_settings,
                    ___IO_SETTINGS_DEFAULT);
  int char_encoding_errors = ___CHAR_ENCODING_ERRORS(settings);
  int char_encoding = ___CHAR_ENCODING(settings);
  int eol_encoding = ___EOL_ENCODING(settings);
  int buffering = ___BUFFERING(settings);

  return ___FIX(___STREAM_OPTIONS(char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering,
                                  char_encoding_errors,
                                  char_encoding,
                                  eol_encoding,
                                  buffering));
}


___HIDDEN ___SCMOBJ ___device_tcp_client_options_set_virt
   ___P((___device_stream *self,
         ___SCMOBJ options),
        (self,
         options)
___device_stream *self;
___SCMOBJ options;)
{
  return ___FIX(___NO_ERR);
}


___HIDDEN ___device_tcp_client_vtbl ___device_tcp_client_table =
{
  {
    {
      ___device_tcp_client_kind,
      ___device_stream_select_virt,
      ___device_stream_release_virt,
      ___device_stream_force_output_virt,
      ___device_stream_close_virt
    },
    ___device_tcp_client_select_raw_virt,
    ___device_tcp_client_release_raw_virt,
    ___device_tcp_client_force_output_raw_virt,
    ___device_tcp_client_close_raw_virt,
    ___device_tcp_client_seek_raw_virt,
    ___device_tcp_client_read_raw_virt,
    ___device_tcp_client_write_raw_virt,
    ___device_tcp_client_width_virt,
    ___device_tcp_client_default_options_virt,
    ___device_tcp_client_options_set_virt
  }
};


#define ___SOCK_KEEPALIVE_FLAG(options) (((options) & 1) != 0)
#define ___SOCK_NO_COALESCE_FLAG(options) (((options) & 2) != 0)
#define ___SOCK_REUSE_ADDRESS_FLAG(options) (((options) & 2048) != 0)
#define ___SOCK_UDP_FLAG(options) (((options) & ___SOCK_UDP) != 0)
#define ___SOCK_UDP 4096


___HIDDEN ___SCMOBJ create_socket
   ___P((SOCKET_TYPE *sock,
         struct sockaddr *local_addr,
         SOCKET_LEN_TYPE local_addrlen,
         int options),
        (sock,
         local_addr,
         local_addrlen,
         options)
SOCKET_TYPE *sock;
struct sockaddr *local_addr;
SOCKET_LEN_TYPE local_addrlen;
int options;)
{
  int keepalive_flag = ___SOCK_KEEPALIVE_FLAG(options);
  int no_coalesce_flag = ___SOCK_NO_COALESCE_FLAG(options);
  int reuse_address_flag = ___SOCK_REUSE_ADDRESS_FLAG(options);
  int udp_flag = ___SOCK_UDP_FLAG(options);
  SOCKET_TYPE s;

  if (SOCKET_CALL_ERROR2(s = socket (local_addr->sa_family,
                                     udp_flag ? SOCK_DGRAM : SOCK_STREAM,
                                     0)))
    return ERR_CODE_FROM_SOCKET_CALL;

#ifndef TCP_NODELAY
#define TCP_NODELAY 1
#endif

  if ((keepalive_flag != 0 &&
       setsockopt (s, /* keep connection alive or not */
                   SOL_SOCKET,
                   SO_KEEPALIVE,
                   ___CAST(char*,&keepalive_flag),
                   sizeof (keepalive_flag)) != 0) ||
      (reuse_address_flag != 0 &&
       setsockopt (s, /* allow reusing the same address */
                   SOL_SOCKET,
                   SO_REUSEADDR,
                   ___CAST(char*,&reuse_address_flag),
                   sizeof (reuse_address_flag)) != 0) ||
      (no_coalesce_flag != 0 &&
       setsockopt (s, /* enable or disable packet coalescing algorithm */
                   IPPROTO_TCP,
                   TCP_NODELAY,
                   ___CAST(char*,&no_coalesce_flag),
                   sizeof (no_coalesce_flag)) != 0) ||
      (bind (s, local_addr, local_addrlen) != 0))
    {
      ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
      CLOSE_SOCKET(s); /* ignore error */
      return e;
    }

  *sock = s;

  return ___FIX(___NO_ERR);
}


___HIDDEN int set_socket_blocking_mode
   ___P((SOCKET_TYPE s,
         ___BOOL blocking),
        (s,
         blocking)
SOCKET_TYPE s;
___BOOL blocking;)
{
#ifndef USE_ioctl
#undef FIONBIO
#endif

#ifdef FIONBIO

#ifdef USE_WIN32
  unsigned long param = !blocking;
#else
  int param = !blocking;
#endif

  return SOCKET_CALL_ERROR(IOCTL_SOCKET(s, FIONBIO, &param));

#else

  return ___set_fd_blocking_mode (s, blocking);

#endif
}


___SCMOBJ ___device_tcp_client_setup_from_socket
   ___P((___device_tcp_client **dev,
         ___device_group *dgroup,
         SOCKET_TYPE s,
         struct sockaddr *addr,
         SOCKET_LEN_TYPE addrlen,
         int try_connect_again,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         s,
         addr,
         addrlen,
         try_connect_again,
         direction,
         io_settings)
___device_tcp_client **dev;
___device_group *dgroup;
SOCKET_TYPE s;
struct sockaddr *addr;
SOCKET_LEN_TYPE addrlen;
int try_connect_again;
int direction;
int io_settings)
{
  ___SCMOBJ e;
  ___device_tcp_client *d;

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (s, s))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_tcp_client*,
              ___ALLOC_MEM(sizeof (___device_tcp_client)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  /*
   * Setup socket to perform nonblocking I/O.
   */

  if (set_socket_blocking_mode (s, 0) != 0) /* set nonblocking mode */
    {
      e = ERR_CODE_FROM_SOCKET_CALL;
      ___FREE_MEM(d);
      return e;
    }

  d->base.base.vtbl = &___device_tcp_client_table;
  d->s = s;
  d->addr = *addr;
  d->addrlen = addrlen;
  d->try_connect_again = try_connect_again;
  d->connect_done = 0;

#ifdef USE_OPENSSL

  d->tls = NULL;

#if OPENSSL_VERSION_NUMBER < 0x009080cfL

  /* Fix for vulnerability http://www.cvedetails.com/cve/CVE-2009-3555/ */
  d->renegotiations = 0;

#endif
#endif

#ifdef USE_POSIX

  d->try_connect_interval_nsecs = 1000000; /* 0.001 secs */

#endif

#ifdef USE_WIN32

  d->io_event =
    CreateEvent (NULL,  /* can't inherit */
                 TRUE,  /* manual reset */
                 FALSE, /* not signaled */
                 NULL); /* no name */

  if (d->io_event == NULL)
    {
      e = err_code_from_GetLastError ();
      ___FREE_MEM(d);
      return e;
    }

#endif

  *dev = d;

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            0);
}

___SCMOBJ ___device_tcp_client_setup_from_sockaddr
   ___P((___device_tcp_client **dev,
         ___device_group *dgroup,
         struct sockaddr *addr,
         SOCKET_LEN_TYPE addrlen,
         struct sockaddr *local_addr,
         SOCKET_LEN_TYPE local_addrlen,
         int options,
         int direction,
         ___tls_context *tls_context,
         char *server_name),
        (dev,
         dgroup,
         addr,
         addrlen,
         local_addr,
         local_addrlen,
         options,
         direction,
         tls_context,
         server_name)
___device_tcp_client **dev;
___device_group *dgroup;
struct sockaddr *addr;
SOCKET_LEN_TYPE addrlen;
struct sockaddr *local_addr;
SOCKET_LEN_TYPE local_addrlen;
int options;
int direction;
___tls_context *tls_context;
char *server_name)
{
  ___SCMOBJ e;
  SOCKET_TYPE s = 0;
  ___device_tcp_client *d;

#ifndef USE_OPENSSL

  if (tls_context != NULL)
    return ___FIX(___UNIMPL_ERR);

#endif

  if ((e = create_socket (&s, local_addr, local_addrlen, options))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = ___device_tcp_client_setup_from_socket
             (&d,
              dgroup,
              s,
              addr,
              addrlen,
              1,
              direction,
              0)) /* no specific io_settings */
      != ___FIX(___NO_ERR))
    {
      CLOSE_SOCKET(s); /* ignore error */
      return e;
    }

  device_transfer_close_responsibility (___CAST(___device*,d));

  *dev = d;

#ifdef USE_OPENSSL

  if (tls_context != NULL)
    {
      d->tls = SSL_new (tls_context->tls_ctx);
      SSL_set_fd (d->tls, d->s);

#ifdef SSL_CTRL_SET_TLSEXT_HOSTNAME
      if (server_name != NULL)
        {
          SSL_set_tlsext_host_name (d->tls, server_name);
        }
#endif
    }

#endif

  if (try_connect (d) != 0)
    {
      e = ERR_CODE_FROM_SOCKET_CALL;
      ___device_cleanup (&d->base.base); /* ignore error */
      return e;
    }

  return ___FIX(___NO_ERR);
}

#endif


/*---------------------------------------------------------------------------*/

#ifdef USE_NETWORKING

/* TCP server device. */

typedef struct ___device_tcp_server_struct
  {
    ___device base;
    SOCKET_TYPE s;

#ifdef USE_WIN32

    HANDLE io_event;  /* used by ___device_tcp_server_select_raw_virt */

#endif

#ifdef USE_OPENSSL

    ___tls_context *tls_context_p;

#endif
  } ___device_tcp_server;

typedef struct ___device_tcp_server_vtbl_struct
  {
    ___device_vtbl base;
  } ___device_tcp_server_vtbl;

___HIDDEN int ___device_tcp_server_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___TCP_SERVER_DEVICE_KIND;
}

___HIDDEN ___SCMOBJ ___device_tcp_server_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
___device *self;
int direction;)
{
  ___device_tcp_server *d = ___CAST(___device_tcp_server*,self);

  if (d->base.read_stage == ___STAGE_CLOSED)
    return ___FIX(___NO_ERR);

  if (direction & ___DIRECTION_RD)
    {
      d->base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */

#ifdef USE_WIN32

      if (d->io_event != NULL)
        CloseHandle (d->io_event); /* ignore error */

#endif

      if ((d->base.close_direction & ___DIRECTION_RD)
          == ___DIRECTION_RD)
        {
          if (CLOSE_SOCKET(d->s) != 0)
            return ERR_CODE_FROM_SOCKET_CALL;
        }
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_server_select_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_tcp_server *d = ___CAST(___device_tcp_server*,self);
  int stage = (for_op == FOR_READING
               ? d->base.read_stage
               : d->base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        state->timeout = ___time_mod.time_neg_infinity;
      else
        {
#ifdef USE_POSIX
          ___device_select_add_fd (state, d->s, for_op);
#endif

#ifdef USE_WIN32

          HANDLE wait_obj = d->io_event;

          ResetEvent (wait_obj); /* ignore error */

          WSAEventSelect (d->s, wait_obj, FD_ACCEPT);

          ___device_select_add_wait_obj (state, i, wait_obj);

#endif
        }

      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifdef USE_POSIX

      if (___FD_ISSET(d->s, state->readfds))
        state->devs[i] = NULL;

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_server_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_tcp_server_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___device_tcp_server_vtbl ___device_tcp_server_table =
{
  {
    ___device_tcp_server_kind,
    ___device_tcp_server_select_virt,
    ___device_tcp_server_release_virt,
    ___device_tcp_server_force_output_virt,
    ___device_tcp_server_close_virt
  }
};

___SCMOBJ ___device_tcp_server_setup
   ___P((___device_tcp_server **dev,
         ___device_group *dgroup,
         struct sockaddr *local_addr,
         SOCKET_LEN_TYPE local_addrlen,
         int backlog,
         int options,
         ___tls_context *tls_context),
        (dev,
         dgroup,
         local_addr,
         local_addrlen,
         backlog,
         options,
         tls_context)
___device_tcp_server **dev;
___device_group *dgroup;
struct sockaddr *local_addr;
SOCKET_LEN_TYPE local_addrlen;
int backlog;
int options;
___tls_context *tls_context;)
{
  ___SCMOBJ e;
  SOCKET_TYPE s;
  ___device_tcp_server *d;

  if ((e = create_socket (&s, local_addr, local_addrlen, options))
      != ___FIX(___NO_ERR))
    return e;

  if (set_socket_blocking_mode (s, 0) != 0 || /* set nonblocking mode */
      listen (s, backlog) != 0)
    {
      e = ERR_CODE_FROM_SOCKET_CALL;
      CLOSE_SOCKET(s); /* ignore error */
      return e;
    }

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (s, s))
    {
      CLOSE_SOCKET(s);
      return ___FIX(___HEAP_OVERFLOW_ERR);
    }

#endif

  d = ___CAST(___device_tcp_server*,
              ___ALLOC_MEM(sizeof (___device_tcp_server)));

  if (d == NULL)
    {
      CLOSE_SOCKET(s); /* ignore error */
      return ___FIX(___HEAP_OVERFLOW_ERR);
    }

  d->base.vtbl = &___device_tcp_server_table;
  d->base.refcount = 1;
  d->base.direction = ___DIRECTION_RD;
  d->base.close_direction = 0; /* prevent closing on errors */
  d->base.read_stage = ___STAGE_OPEN;
  d->base.write_stage = ___STAGE_CLOSED;

#ifdef USE_WIN32

  d->io_event =
    CreateEvent (NULL,  /* can't inherit */
                 TRUE,  /* manual reset */
                 FALSE, /* not signaled */
                 NULL); /* no name */

  if (d->io_event == NULL)
    {
      ___SCMOBJ e = err_code_from_GetLastError ();
      CLOSE_SOCKET(s); /* ignore error */
      ___FREE_MEM(d);
      return e;
    }

#endif

  d->s = s;

  device_transfer_close_responsibility (___CAST(___device*,d));

#ifdef USE_OPENSSL

  d->tls_context_p = tls_context;

#endif

  *dev = d;

  ___device_add_to_group (dgroup, &d->base);

  return ___FIX(___NO_ERR);
}


___SCMOBJ ___device_tcp_server_read
   ___P((___device_tcp_server *dev,
         ___device_group *dgroup,
         ___device_tcp_client **client),
        (dev,
         dgroup,
         client)
___device_tcp_server *dev;
___device_group *dgroup;
___device_tcp_client **client;)
{
  ___SCMOBJ e;
  struct sockaddr_in addr;
  SOCKET_LEN_TYPE addrlen;
  SOCKET_TYPE s;

  if (dev->base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  addrlen = sizeof (addr);

  if (SOCKET_CALL_ERROR2(s = accept (dev->s,
                                     ___CAST(struct sockaddr*,&addr),
                                     &addrlen)))
    return ERR_CODE_FROM_SOCKET_CALL;

  if ((e = ___device_tcp_client_setup_from_socket
             (client,
              dgroup,
              s,
              ___CAST(struct sockaddr*,&addr),
              addrlen,
              0,
              ___DIRECTION_RD|___DIRECTION_WR,
              0)) /* no specific io_settings */
      != ___FIX(___NO_ERR))
    {
      CLOSE_SOCKET(s); /* ignore error */
      return e;
    }

#ifdef USE_OPENSSL

  if (dev->tls_context_p != NULL)
    {
      /* TLS Connection Initialization */
      (*client)->tls  = SSL_new (dev->tls_context_p->tls_ctx);
      SSL_set_fd ((*client)->tls, (*client)->s);
      /* Non-blocking. We don't need to loop over its status, since OpenSSL
         handles the handshake automatically in SSL_read/write */
      SSL_accept ((*client)->tls);
    }

#endif

  device_transfer_close_responsibility (___CAST(___device*,*client));

  return ___FIX(___NO_ERR);
}

#endif


/*---------------------------------------------------------------------------*/

#ifdef USE_NETWORKING

/* UDP device. */

typedef struct ___device_udp_struct
  {
    ___device base;
    SOCKET_TYPE s;

    struct sockaddr dest_sa;
    SOCKET_LEN_TYPE dest_salen; /* 0 when no destination yet set */

    struct sockaddr source_sa;
    SOCKET_LEN_TYPE source_salen; /* 0 when no message yet received */
    ___BOOL source_same_as_previous; /* true when source_sa contains latest address read by ___os_device_udp_socket_info */

#ifdef USE_WIN32

    long io_events;   /* used by ___device_udp_select_raw_virt */
    HANDLE io_event;  /* used by ___device_udp_select_raw_virt */

#endif
  } ___device_udp;

typedef struct ___device_udp_vtbl_struct
  {
    ___device_vtbl base;
  } ___device_udp_vtbl;


___HIDDEN int ___device_udp_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___UDP_DEVICE_KIND;
}

___HIDDEN ___SCMOBJ ___device_udp_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
        ___device *self;
        int direction;)
{
  ___device_udp *d = ___CAST(___device_udp*,self);
  int is_not_closed = 0;

  if (d->base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

  if ((is_not_closed & ~direction) == 0)
    {
      /* Close socket when both sides are closed. */

      d->base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */
      d->base.write_stage = ___STAGE_CLOSED;

#ifdef USE_WIN32

      if (d->io_event != NULL)
        CloseHandle (d->io_event); /* ignore error */

#endif

      if ((d->base.close_direction & (___DIRECTION_RD|___DIRECTION_WR))
          == (___DIRECTION_RD|___DIRECTION_WR))
        {
          if (CLOSE_SOCKET(d->s) != 0)
            return ERR_CODE_FROM_SOCKET_CALL;
        }
    }
  else if (is_not_closed & direction & ___DIRECTION_RD)
    d->base.read_stage = ___STAGE_CLOSED;
  else if (is_not_closed & direction & ___DIRECTION_WR)
    d->base.write_stage = ___STAGE_CLOSED;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_udp_select_raw_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_udp *d = ___CAST(___device_udp*,self);
  int stage = (for_op == FOR_READING
               ? d->base.read_stage
               : d->base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        {
          state->timeout = ___time_mod.time_neg_infinity;
          return ___FIX(___SELECT_SETUP_DONE);
        }
      else
        {
#ifdef USE_POSIX

          ___device_select_add_fd (state, d->s, for_op);

          return ___FIX(___SELECT_SETUP_DONE);

#endif

#ifdef USE_WIN32

          d->io_events = 0;

          return ___FIX(___NO_ERR);

#endif
        }
    }

#ifdef USE_WIN32

  else if (pass == ___SELECT_PASS_2)
    {
      if (for_op == FOR_READING)
        d->io_events |= (FD_READ | FD_CLOSE);
      else
        d->io_events |= (FD_WRITE | FD_CLOSE);

      return ___FIX(___NO_ERR);
    }
  else if (pass == ___SELECT_PASS_3)
    {
      HANDLE wait_obj = d->io_event;

      ResetEvent (wait_obj); /* ignore error */

      WSAEventSelect (d->s, wait_obj, d->io_events);

      ___device_select_add_wait_obj (state, i, wait_obj);

      return ___FIX(___SELECT_SETUP_DONE);
    }

#endif

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifdef USE_POSIX

      if (for_op == FOR_READING
          ? ___FD_ISSET(d->s, state->readfds)
          : ___FD_ISSET(d->s, state->writefds))
        state->devs[i] = NULL;

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_udp_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_udp_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___device_udp_vtbl ___device_udp_table =
{
  {
    ___device_udp_kind,
    ___device_udp_select_raw_virt,
    ___device_udp_release_virt,
    ___device_udp_force_output_virt,
    ___device_udp_close_virt
  }
};

___SCMOBJ ___device_udp_setup_from_socket
   ___P((___device_udp **dev,
         ___device_group *dgroup,
         SOCKET_TYPE s,
         struct sockaddr *local_addr,
         SOCKET_LEN_TYPE local_addrlen,
         int direction),
        (dev,
         dgroup,
         s,
         local_addr,
         local_addrlen,
         direction)
___device_udp **dev;
___device_group *dgroup;
SOCKET_TYPE s;
struct sockaddr *local_addr;
SOCKET_LEN_TYPE local_addrlen;
int direction;)
{
  ___SCMOBJ e;
  ___device_udp *d;

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (s, s))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_udp*,
              ___ALLOC_MEM(sizeof (___device_udp)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  /*
   * Setup socket to perform nonblocking I/O.
   */

  if (set_socket_blocking_mode (s, 0) != 0) /* set nonblocking mode */
    {
      e = ERR_CODE_FROM_SOCKET_CALL;
      ___FREE_MEM(d);
      return e;
    }

  d->base.vtbl = &___device_udp_table;
  d->base.refcount = 1;
  d->base.direction = direction;
  d->base.close_direction = 0; /* prevent closing on errors */

  if (direction & ___DIRECTION_RD)
    d->base.read_stage = ___STAGE_OPEN;
  else
    d->base.read_stage = ___STAGE_CLOSED;

  if (direction & ___DIRECTION_WR)
    d->base.write_stage = ___STAGE_OPEN;
  else
    d->base.write_stage = ___STAGE_CLOSED;

  d->s = s;
  d->dest_salen = 0; /* no destination yet set */
  d->source_salen = 0; /* no message yet received */
  d->source_same_as_previous = 0;

#ifdef USE_WIN32

  d->io_event =
    CreateEvent (NULL,  /* can't inherit */
                 TRUE,  /* manual reset */
                 FALSE, /* not signaled */
                 NULL); /* no name */

  if (d->io_event == NULL)
    {
      e = err_code_from_GetLastError ();
      ___FREE_MEM(d);
      return e;
    }

#endif

  device_transfer_close_responsibility (___CAST(___device*,d));

  *dev = d;

  ___device_add_to_group (dgroup, &d->base);

  return ___FIX(___NO_ERR);
}

___SCMOBJ ___device_udp_setup_from_sockaddr
   ___P((___device_udp **dev,
         ___device_group *dgroup,
         struct sockaddr *local_addr,
         SOCKET_LEN_TYPE local_addrlen,
         int options,
         int direction),
        (dev,
         dgroup,
         local_addr,
         local_addrlen,
         options,
         direction)
___device_tcp_client **dev;
___device_group *dgroup;
struct sockaddr *local_addr;
SOCKET_LEN_TYPE local_addrlen;
int options;
int direction;)
{
  ___SCMOBJ e;
  SOCKET_TYPE s = 0;
  ___device_udp *d;

  if ((e = create_socket (&s, local_addr, local_addrlen, ___SOCK_UDP))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = ___device_udp_setup_from_socket
             (&d,
              dgroup,
              s,
              local_addr,
              local_addrlen,
              direction))
      != ___FIX(___NO_ERR))
    {
      CLOSE_SOCKET(s); /* ignore error */
      return e;
    }

  device_transfer_close_responsibility (___CAST(___device*,d));

  *dev = d;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_udp_read_raw
   ___P((___device_udp *self,
         ___U8 *buf,
         ___SSIZE_T len,
         ___SSIZE_T *len_done),
        (self,
         buf,
         len,
         len_done)
___device_udp *self;
___U8 *buf;
___SSIZE_T len;
___SSIZE_T *len_done;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SSIZE_T n;
  struct sockaddr sa;
  SOCKET_LEN_TYPE salen = sizeof (sa);

  if (self->base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  n = recvfrom (self->s, buf, len, 0, &sa, &salen);

  if (n < 0)
    return ERR_CODE_FROM_SOCKET_CALL;

  if (!self->source_same_as_previous ||
      !sockaddr_equal (&sa, salen, &self->source_sa, self->source_salen))
    {
      self->source_sa = sa;
      self->source_salen = salen;
      self->source_same_as_previous = 0;
    }

  *len_done = n;

  return ___FIX(___NO_ERR);

#endif
}


___HIDDEN ___SCMOBJ ___device_udp_write_raw
   ___P((___device_udp *self,
         ___U8 *buf,
         ___SSIZE_T len,
         ___SSIZE_T *len_done),
        (self,
         buf,
         len,
         len_done)
___device_udp *self;
___U8 *buf;
___SSIZE_T len;
___SSIZE_T *len_done;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SSIZE_T n;

  if (self->base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  n = sendto (self->s, buf, len, 0, &self->dest_sa, self->dest_salen);

  /*
   * Note that some operating systems limit the size of datagrams sent.
   * For example, by default MacOS doesn't allow sending datagrams longer
   * than 9216 bytes and this can be changed with:
   *
   * sudo sysctl -w net.inet.udp.maxdgram=65535
   */

  if (n < 0)
    return ERR_CODE_FROM_SOCKET_CALL;

  *len_done = n;

  return ___FIX(___NO_ERR);

#endif
}


#endif


/*---------------------------------------------------------------------------*/

/* Directory device. */

typedef struct ___device_directory_struct
  {
    ___device base;

    int ignore_hidden;

#ifdef USE_opendir
    DIR *dir;
#endif

#ifdef USE_FindFirstFile
    HANDLE h;
    WIN32_FIND_DATA fdata;
    ___BOOL first_file;
#endif
  } ___device_directory;

typedef struct ___device_directory_vtbl_struct
  {
    ___device_vtbl base;
  } ___device_directory_vtbl;

___HIDDEN int ___device_directory_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___DIRECTORY_KIND;
}

___HIDDEN ___SCMOBJ ___device_directory_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
___device *self;
int direction;)
{
  ___device_directory *d = ___CAST(___device_directory*,self);

  if (d->base.read_stage == ___STAGE_CLOSED)
    return ___FIX(___NO_ERR);

  if (direction & ___DIRECTION_RD)
    {
      d->base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */

      if ((d->base.close_direction & ___DIRECTION_RD)
          == ___DIRECTION_RD)
        {

#ifdef USE_opendir
          if (closedir (d->dir) < 0)
            return err_code_from_errno ();
#endif

#ifdef USE_FindFirstFile
          if (!FindClose (d->h))
            return err_code_from_GetLastError ();
#endif
        }
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_directory_select_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  if (pass == ___SELECT_PASS_1)
    {
      state->timeout = ___time_mod.time_neg_infinity;
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  state->devs[i] = NULL;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_directory_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_directory_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___device_directory_vtbl ___device_directory_table =
{
  {
    ___device_directory_kind,
    ___device_directory_select_virt,
    ___device_directory_release_virt,
    ___device_directory_force_output_virt,
    ___device_directory_close_virt
  }
};


#ifdef USE_opendir
#define ___DIR_OPEN_PATH_SUPPORTED
#else
#ifdef USE_FindFirstFile
#define ___DIR_OPEN_PATH_SUPPORTED
#endif
#endif


#ifdef ___DIR_OPEN_PATH_SUPPORTED

___SCMOBJ ___device_directory_setup
   ___P((___device_directory **dev,
         ___device_group *dgroup,
         ___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) path,
         int ignore_hidden),
        (dev,
         dgroup,
         path,
         ignore_hidden)
___device_directory **dev;
___device_group *dgroup;
___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) path;
int ignore_hidden;)
{
  ___device_directory *d;

  d = ___CAST(___device_directory*,
              ___ALLOC_MEM(sizeof (___device_directory)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.vtbl = &___device_directory_table;
  d->base.refcount = 1;
  d->base.direction = ___DIRECTION_RD;
  d->base.close_direction = 0; /* prevent closing on errors */
  d->base.read_stage = ___STAGE_OPEN;
  d->base.write_stage = ___STAGE_CLOSED;

#ifdef USE_opendir

  d->ignore_hidden = ignore_hidden;

  d->dir = opendir_long_path (path);

  if (d->dir == NULL)
    {
      ___SCMOBJ e = fnf_or_err_code_from_errno ();
      ___FREE_MEM(d);
      return e;
    }

#endif

#ifdef USE_FindFirstFile

  {
    ___CHAR_TYPE(___DIR_OPEN_PATH_CE_SELECT) dir[___PATH_MAX_LENGTH+2+1];
    int i = 0;

    while (path[i] != '\0' && i < ___PATH_MAX_LENGTH)
      {
        dir[i] = path[i];
        i++;
      }

    if (i == 0 || (dir[i-1] != '\\' && dir[i-1] != '/'))
      dir[i++] = '\\';

    dir[i++] = '*';
    dir[i++] = '\0';

    d->ignore_hidden = ignore_hidden;
    d->first_file = 1;

    d->h = FindFirstFile (dir, &d->fdata);

    if (d->h == INVALID_HANDLE_VALUE)
      {
        ___SCMOBJ e = fnf_or_err_code_from_GetLastError ();
        ___FREE_MEM(d);
        return e;
      }
  }

#endif

  device_transfer_close_responsibility (___CAST(___device*,d));

  *dev = d;

  ___device_add_to_group (dgroup, &d->base);

  return ___FIX(___NO_ERR);
}

___SCMOBJ ___device_directory_read
   ___P((___device_directory *dev,
         ___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) *name),
        (dev,
         name)
___device_directory *dev;
___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) *name;)
{
  ___SCMOBJ e;

  if (dev->base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  for (;;)
    {
      ___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) temp;

#ifdef USE_opendir

      struct dirent *de = readdir (dev->dir);

      if (de == NULL)
        {
#if 0
          /* this seems to be broken, at least under Linux */
          if (errno != 0)
            return err_code_from_errno ();
#endif
          *name = NULL;
          e = ___FIX(___NO_ERR);
          break;
        }

      temp = de->d_name;

      switch (dev->ignore_hidden)
        {
        default:
        case 2:
          if (temp[0] == '.')
            break;

        case 1:
          if (temp[0] == '.' &&
              (temp[1] == '\0' ||
               (temp[1] == '.' && (temp[2] == '\0'))))
            break;

        case 0:
          *name = temp;
          return ___FIX(___NO_ERR);
        }

#endif

#ifdef USE_FindFirstFile

      if (dev->first_file)
        dev->first_file = 0;
      else if (!FindNextFile (dev->h, &dev->fdata))
        {
          e = err_code_from_GetLastError ();
          *name = NULL;
          if (e == ___FIX(___WIN32_ERR(ERROR_NO_MORE_FILES)))
            e = ___FIX(___NO_ERR);
          break;
        }

      temp = dev->fdata.cFileName;

      if (temp[0] == '\0')
        temp = dev->fdata.cAlternateFileName; /* use 8.3 name */

      switch (dev->ignore_hidden)
        {
        default:
        case 2:
          if (dev->fdata.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN)
            break;

        case 1:
          if (temp[0] == '.' &&
              (temp[1] == '\0' ||
               (temp[1] == '.' && (temp[2] == '\0'))))
            break;

        case 0:
          *name = temp;
          return ___FIX(___NO_ERR);
        }

#endif
    }

  return e;
}

#endif


/*---------------------------------------------------------------------------*/

/* Event-queue device. */

typedef struct ___device_event_queue_struct
  {
    ___device base;

    int selector;

#ifdef USE_WIN32

    DWORD event_mask;

#endif
  } ___device_event_queue;

typedef struct ___device_event_queue_vtbl_struct
  {
    ___device_vtbl base;
  } ___device_event_queue_vtbl;


___HIDDEN int ___device_event_queue_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___EVENT_QUEUE_KIND;
}


___HIDDEN ___SCMOBJ ___device_event_queue_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
___device *self;
int direction;)
{
  ___device_event_queue *d = ___CAST(___device_event_queue*,self);

  if (d->base.read_stage == ___STAGE_CLOSED)
    return ___FIX(___NO_ERR);

  if (direction & ___DIRECTION_RD)
    {
      d->base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_event_queue_select_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_event_queue *d = ___CAST(___device_event_queue*,self);
  int stage = (for_op == FOR_READING
               ? d->base.read_stage
               : d->base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        state->timeout = ___time_mod.time_neg_infinity;
      else
        {
#ifdef USE_WIN32

          state->message_queue_mask = d->event_mask;
          state->message_queue_dev_pos = i;

#endif
        }

      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_event_queue_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_event_queue_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___device_event_queue_vtbl ___device_event_queue_table =
{
  {
    ___device_event_queue_kind,
    ___device_event_queue_select_virt,
    ___device_event_queue_release_virt,
    ___device_event_queue_force_output_virt,
    ___device_event_queue_close_virt
  }
};


___SCMOBJ ___device_event_queue_setup
   ___P((___device_event_queue **dev,
         ___device_group *dgroup,
         ___SCMOBJ selector),
        (dev,
         dgroup,
         selector)
___device_event_queue **dev;
___device_group *dgroup;
___SCMOBJ selector;)
{
  ___device_event_queue *d;

  d = ___CAST(___device_event_queue*,
              ___ALLOC_MEM(sizeof (___device_event_queue)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.vtbl = &___device_event_queue_table;
  d->base.refcount = 1;
  d->base.direction = ___DIRECTION_RD;
  d->base.close_direction = 0; /* prevent closing on errors */
  d->base.read_stage = ___STAGE_OPEN;
  d->base.write_stage = ___STAGE_CLOSED;

  d->selector = ___INT(selector);

#ifdef USE_WIN32

  d->event_mask = ___INT(selector & QS_ALLINPUT);

#endif

  *dev = d;

  ___device_add_to_group (dgroup, &d->base);

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___release_event
   ___P((void *x),
        (x)
void *x;)
{
  ___release_rc (x);
  return ___FIX(___NO_ERR);
}


___SCMOBJ ___device_event_queue_read
   ___P((___device_event_queue *dev,
         ___SCMOBJ *event),
        (dev,
         event)
___device_event_queue *dev;
___SCMOBJ *event;)
{
  if (dev->base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

#ifdef USE_WIN32

  if (GetQueueStatus (dev->event_mask) != 0)
    {
      void *ev = ___alloc_rc (___PSA(___PSTATE) sizeof (MSG));

      if (ev == 0)
        return ___FIX(___STOC_HEAP_OVERFLOW_ERR+___RETURN_POS);

      if (PeekMessage (___CAST(MSG*, ev),
                       NULL,      /* retrieve messages for window and thread */
                       0,         /* no constraint on the message type */
                       0,
                       PM_REMOVE))/* remove message */
        /* TODO: check if ___release_scmobj (...); needed to avoid memory leak */
        return ___NONNULLPOINTER_to_SCMOBJ
                  (___PSTATE,
                   ev,
                   ___FAL,
                   ___release_event,
                   event,
                   ___RETURN_POS);

      ___release_event (ev);
    }

#endif

  return ___ERR_CODE_EAGAIN;
}


/*---------------------------------------------------------------------------*/

/* File stream device */

typedef struct ___device_file_struct
  {
    ___device_stream base;

#ifndef USE_POSIX
#ifndef USE_WIN32

    ___FILE *stream;

#endif
#endif

#ifdef USE_POSIX
    int fd;
#endif

#ifdef USE_WIN32
    HANDLE h;
    int flags;
#endif
  } ___device_file;

typedef struct ___device_file_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_file_vtbl;

___HIDDEN int ___device_file_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FILE_DEVICE_KIND;
}

#if 0

___HIDDEN void ___device_file_restore_initial_mode
   ___P((___device_file *d),
        (d)
___device_file *d;)
{
#ifdef USE_POSIX

  /* set blocking mode */

  ___set_fd_blocking_mode (d->fd, 1); /* ignore error */

#endif
}

#endif

___HIDDEN ___SCMOBJ ___device_file_close_raw_virt
   ___P((___device_stream *self,
         int direction),
        (self,
         direction)
___device_stream *self;
int direction;)
{
  ___device_file *d = ___CAST(___device_file*,self);
  int is_not_closed = 0;

  if (d->base.base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

  if ((is_not_closed & ~direction) == 0)
    {
      /* Close file when both sides are closed. */

      d->base.base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */
      d->base.base.write_stage = ___STAGE_CLOSED;

      if ((d->base.base.close_direction & d->base.base.direction)
          == d->base.base.direction)
        {
#if 0
          ___device_file_restore_initial_mode (d);
#endif

#ifndef USE_POSIX
#ifndef USE_WIN32

          if (d->stream != 0)
            if (___fclose (d->stream) != 0)
              return err_code_from_errno ();

#endif
#endif

#ifdef USE_POSIX
          if (___close_no_EINTR (d->fd) < 0)
            return err_code_from_errno ();
#endif

#ifdef USE_WIN32
          if (!CloseHandle (d->h))
            return err_code_from_GetLastError ();
#endif
        }
    }
  else if (is_not_closed & direction & ___DIRECTION_RD)
    d->base.base.read_stage = ___STAGE_CLOSED;
  else if (is_not_closed & direction & ___DIRECTION_WR)
    d->base.base.write_stage = ___STAGE_CLOSED;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_file_select_raw_virt
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
  ___device_file *d = ___CAST(___device_file*,self);
  int stage = (for_op == FOR_READING
               ? d->base.base.read_stage
               : d->base.base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        state->timeout = ___time_mod.time_neg_infinity;
      else
        {
#ifndef USE_POSIX
#ifndef USE_WIN32

        state->timeout = ___time_mod.time_neg_infinity;

#endif
#endif

#ifdef USE_POSIX
          ___device_select_add_fd (state, d->fd, for_op);
#endif
        }
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifndef USE_POSIX
#ifndef USE_WIN32

      state->devs[i] = NULL;

#endif
#endif

#ifdef USE_POSIX

      if (for_op == FOR_READING
           ? ___FD_ISSET(d->fd, state->readfds)
           : ___FD_ISSET(d->fd, state->writefds))
        state->devs[i] = NULL;

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_file_release_raw_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
#if 0

  ___device_file *d = ___CAST(___device_file*,self);

  if (d->base.base.read_stage != ___STAGE_CLOSED ||
      d->base.base.write_stage != ___STAGE_CLOSED)
    ___device_file_restore_initial_mode (d);

#endif

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_file_force_output_raw_virt
   ___P((___device_stream *self,
         int level),
        (self,
         level)
___device_stream *self;
int level;)
{
  ___device_file *d = ___CAST(___device_file*,self);

  if (d->base.base.write_stage == ___STAGE_OPEN)
    {
#ifndef USE_POSIX
#ifndef USE_WIN32

      if (level > 0)
        {
          ___FILE *stream = d->stream;

          if (stream == 0)
            stream = ___stdout;

          ___fflush (stream); /* ignore error */
        }

#endif
#endif

#ifdef USE_POSIX

      switch (level)
        {
        case 2:
        case 3:

#ifdef USE_fcntl
#ifdef F_FULLFSYNC

          if (fcntl (d->fd, F_FULLFSYNC, 0) < 0)
            return err_code_from_errno ();
          break;

#endif
#endif

        case 1:

          if (fsync (d->fd) < 0)
            return err_code_from_errno ();
          break;

        }

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_file_seek_raw_virt
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
  ___device_file *d = ___CAST(___device_file*,self);

  if (d->base.base.read_stage == ___STAGE_OPEN ||
      d->base.base.write_stage == ___STAGE_OPEN)
    {
#ifndef USE_POSIX
#ifndef USE_WIN32

      ___stream_index new_pos;
      ___FILE *stream = d->stream;

      if (stream == 0)
        stream = ___stdout;

      if (fseek (stream, *pos, whence) < 0 ||
          (new_pos = ftell (stream)) < 0)
        return err_code_from_errno ();

      *pos = new_pos;

#endif
#endif

#ifdef USE_POSIX

      ___stream_index new_pos;

      if ((new_pos = lseek (d->fd, *pos, whence)) < 0)
        return err_code_from_errno ();

      *pos = new_pos;

#endif

#ifdef USE_WIN32

      LARGE_INTEGER new_pos;

      new_pos.QuadPart = *pos;

      new_pos.LowPart = SetFilePointer (d->h,
                                        new_pos.LowPart,
                                        &new_pos.HighPart,
                                        whence);

      if (new_pos.LowPart == 0xFFFFFFFF
          && GetLastError () != NO_ERROR)
        return err_code_from_GetLastError ();

      *pos = new_pos.LowPart;  /************* incomplete... support large offsets */

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_file_read_raw_virt
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
  ___device_file *d = ___CAST(___device_file*,self);

  if (d->base.base.read_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

#ifndef USE_POSIX
#ifndef USE_WIN32

  {
    int n;
    ___FILE *stream = d->stream;

    if (stream == 0)
      stream = ___stdin;

    if (stream == ___stdin)
      len = 1; /* only read 1 byte at a time to prevent blocking on tty */

    if ((n = ___fread (buf, 1, len, stream)) == 0)
      {
        if (___ferror (stream))
          {
            ___clearerr (stream);
            return ___FIX(___UNKNOWN_ERR);
          }
        ___clearerr (stream);
      }

    *len_done = n;
  }

#endif
#endif

#ifdef USE_POSIX

  {
    int n;

    if ((n = read (d->fd, buf, len)) < 0)
      return err_code_from_errno ();

    *len_done = n;
  }

#endif

#ifdef USE_WIN32

  {
    DWORD n;

    if (!ReadFile (d->h, buf, len, &n, NULL))
      return err_code_from_GetLastError ();

    *len_done = n;
  }

#endif

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_file_write_raw_virt
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
  ___device_file *d = ___CAST(___device_file*,self);

  if (d->base.base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

#ifndef USE_POSIX
#ifndef USE_WIN32

  {
    int n;
    ___FILE *stream = d->stream;

    if (stream == 0)
      stream = ___stdout;

    if ((n = ___fwrite (buf, 1, len, stream)) == 0)
      {
        if (___ferror (stream))
          {
            ___clearerr (stream);
            return ___FIX(___UNKNOWN_ERR);
          }
      }

    *len_done = n;
  }

#endif
#endif

#ifdef USE_POSIX

  {
    int n;

    if ((n = write (d->fd, buf, len)) < 0)
      return err_code_from_errno ();

    *len_done = n;
  }

#endif

#ifdef USE_WIN32

  {
    DWORD n;

    if (d->flags & (1 << 3))
      {
        ___stream_index pos = 0; /* end of file */
        ___SCMOBJ e = ___device_file_seek_raw_virt (self, &pos, FILE_END);
        if (e != ___FIX(___NO_ERR))
          return e;
      }

    if (!WriteFile (d->h, buf, len, &n, NULL))
      return err_code_from_GetLastError ();

    *len_done = n;
  }

#endif

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ ___device_file_width_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  return ___FIX(80);
}


___HIDDEN ___SCMOBJ ___device_file_default_options_virt
   ___P((___device_stream *self),
        (self)
___device_stream *self;)
{
  int settings = ___io_settings_finalize
                   (self->io_settings,
#ifdef USE_WIN32
                    (GetFileType (___CAST(___device_file*,self)->h)
                     == FILE_TYPE_PIPE)
                    ? ___BUFFERING_MASK(___IO_SETTINGS_DEFAULT)|___NO_BUFFERING
                    : ___IO_SETTINGS_DEFAULT
#else
                    ___IO_SETTINGS_DEFAULT
#endif
                   );
  int char_encoding_errors = ___CHAR_ENCODING_ERRORS(settings);
  int char_encoding = ___CHAR_ENCODING(settings);
  int eol_encoding = ___EOL_ENCODING(settings);
  int buffering = ___BUFFERING(settings);

#ifdef ___DEBUG_LOG

  ___printf ("file char_encoding_errors=%d   char_encoding=%d   eol_encoding=%d   buffering=%d\n",
             char_encoding_errors,
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


___HIDDEN ___SCMOBJ ___device_file_options_set_virt
   ___P((___device_stream *self,
         ___SCMOBJ options),
        (self,
         options)
___device_stream *self;
___SCMOBJ options;)
{
  return ___FIX(___NO_ERR);
}


___HIDDEN ___device_file_vtbl ___device_file_table =
{
  {
    {
      ___device_file_kind,
      ___device_stream_select_virt,
      ___device_stream_release_virt,
      ___device_stream_force_output_virt,
      ___device_stream_close_virt
    },
    ___device_file_select_raw_virt,
    ___device_file_release_raw_virt,
    ___device_file_force_output_raw_virt,
    ___device_file_close_raw_virt,
    ___device_file_seek_raw_virt,
    ___device_file_read_raw_virt,
    ___device_file_write_raw_virt,
    ___device_file_width_virt,
    ___device_file_default_options_virt,
    ___device_file_options_set_virt
  }
};


#ifndef USE_POSIX
#ifndef USE_WIN32

___HIDDEN ___SCMOBJ ___device_file_setup_from_stream
   ___P((___device_file **dev,
         ___device_group *dgroup,
         ___FILE *stream,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         stream,
         direction,
         io_settings)
___device_file **dev;
___device_group *dgroup;
___FILE *stream;
int direction;
int io_settings;)
{
  ___device_file *d;

  d = ___CAST(___device_file*,
              ___ALLOC_MEM(sizeof (___device_file)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_file_table;
  d->stream = stream;

  *dev = d;

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            0);
}

#endif
#endif


#ifdef USE_POSIX

___HIDDEN ___SCMOBJ ___device_file_setup_from_fd
   ___P((___device_file **dev,
         ___device_group *dgroup,
         int fd,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         fd,
         direction,
         io_settings)
___device_file **dev;
___device_group *dgroup;
int fd;
int direction;
int io_settings;)
{
  ___device_file *d;

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (fd, fd))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_file*,
              ___ALLOC_MEM(sizeof (___device_file)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_file_table;
  d->fd = fd;

  *dev = d;

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            0);
}

#endif


#ifdef USE_WIN32

___HIDDEN ___SCMOBJ ___device_file_setup_from_handle
   ___P((___device_file **dev,
         ___device_group *dgroup,
         HANDLE h,
         int flags,
         int direction,
         int io_settings,
         int pumps_on),
        (dev,
         dgroup,
         h,
         flags,
         direction,
         io_settings,
         pumps_on)
___device_file **dev;
___device_group *dgroup;
HANDLE h;
int flags;
int direction;
int io_settings;
int pumps_on;)
{
  ___device_file *d;

  d = ___CAST(___device_file*,
              ___ALLOC_MEM(sizeof (___device_file)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  d->base.base.vtbl = &___device_file_table;
  d->h = h;
  d->flags = flags;

  *dev = d;

  return ___device_stream_setup
           (&d->base,
            dgroup,
            direction,
            io_settings,
            pumps_on);
}

#endif


/*---------------------------------------------------------------------------*/

#ifndef USE_POSIX
#ifndef USE_WIN32

___SCMOBJ ___device_stream_setup_from_stream
   ___P((___device_stream **dev,
         ___device_group *dgroup,
         ___FILE *stream,
         int kind,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         ___FILE *stream,
         kind,
         direction,
         io_settings)
___device_stream **dev;
___device_group *dgroup;
___FILE *stream;
int kind;
int direction;
int io_settings;)
{
  ___SCMOBJ e;
  ___device_file *d;

  if ((e = ___device_file_setup_from_stream
             (&d,
              dgroup,
              stream,
              direction,
              io_settings))
      == ___FIX(___NO_ERR))
    *dev = ___CAST(___device_stream*,d);

  return e;
}


___HIDDEN void device_translate_flags
   ___P((int flags,
         char **mode,
         int *direction),
        (flags,
         mode,
         direction)
int flags;
char **mode;
int *direction;)
{
  switch ((flags >> 4) & 3)
    {
    default:
    case 1:
      *mode = "rb";
      *direction = ___DIRECTION_RD;
      break;
    case 2:
      *mode = "wb";
      *direction = ___DIRECTION_WR;
      break;
    case 3:
      *mode = "w+b";
      *direction = ___DIRECTION_RD|___DIRECTION_WR;
      break;
    }
}

#endif
#endif

#ifdef USE_POSIX

___HIDDEN int ___device_stream_kind_from_fd
   ___P((int fd),
        (fd)
int fd;)
{
  /*
   * Determine what kind of device is attached to the file descriptor
   * (tty, socket, pipe, or regular file).
   */

  if (isatty (fd))
    return ___TTY_DEVICE_KIND;

#ifdef USE_stat

  {
    ___struct_stat s;

    if (___fstat (fd, &s) < 0)
      return ___NONE_KIND;

    if (S_ISREG(s.st_mode) ||
        S_ISCHR(s.st_mode) ||
        S_ISBLK(s.st_mode))
      return ___FILE_DEVICE_KIND;

    if (S_ISFIFO(s.st_mode))
      return ___PIPE_DEVICE_KIND;

#ifdef USE_NETWORKING
    if (S_ISSOCK(s.st_mode))
      return ___TCP_CLIENT_DEVICE_KIND;
#endif
  }

  return ___NONE_KIND;

#else

  return ___FILE_DEVICE_KIND;

#endif
}


___HIDDEN int ___device_stream_direction_from_fd
   ___P((int fd),
        (fd)
int fd;)
{
  int direction = ___DIRECTION_RD|___DIRECTION_WR;
  char buf[1];

  /*
   * A "read" and "write" of 0 bytes is attempted to tell which
   * directions the file descriptor supports.
   */

  if (read (fd, buf, 0) < 0)
    direction &= ~___DIRECTION_RD;

  if (write (fd, buf, 0) < 0)
    direction &= ~___DIRECTION_WR;

  /*
   * It is likely that on some systems a zero length "read" and
   * "write" will return an error, regardless of the possible
   * operations.  In this case assume that both operations are
   * possible.
   */

  if (direction == 0)
    direction = ___DIRECTION_RD|___DIRECTION_WR;

  return direction;
}


___SCMOBJ ___device_stream_setup_from_fd
   ___P((___device_stream **dev,
         ___device_group *dgroup,
         int fd,
         int kind,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         fd,
         kind,
         direction,
         io_settings)
___device_stream **dev;
___device_group *dgroup;
int fd;
int kind;
int direction;
int io_settings;)
{
  ___SCMOBJ e = ___FIX(___UNKNOWN_ERR);

  if (kind == ___NONE_KIND)
    kind = ___device_stream_kind_from_fd (fd);

  if (direction == 0)
    direction = ___device_stream_direction_from_fd (fd);

#ifdef ___DEBUG_LOG
  ___printf ("fd=%d kind=%d direction=%d\n", fd, kind, direction);
#endif

  if (kind == ___TTY_DEVICE_KIND)
    {
      /*
       * No need to setup the file descriptor to perform nonblocking
       * I/O because that is done by os_tty.c in a way that restores
       * the blocking mode to its original mode when the process
       * exits.  Restoring the original mode avoids some issues when
       * running under a shell in emacs (which gives a "Process
       * shell finished" error when the program terminates).
       */

      ___device_tty *d;

      if ((e = ___device_tty_setup_from_fd
                 (&d,
                  dgroup,
                  fd,
                  direction))
          == ___FIX(___NO_ERR))
        *dev = ___CAST(___device_stream*,d);
    }
  else
    {
      switch (kind)
        {

#ifdef USE_NETWORKING

        case ___TCP_CLIENT_DEVICE_KIND:
          {
            ___device_tcp_client *d;
            struct sockaddr addr;

            if ((e = ___device_tcp_client_setup_from_socket
                       (&d,
                        dgroup,
                        fd,
                        &addr,
                        0,
                        0,
                        direction,
                        io_settings))
                == ___FIX(___NO_ERR))
              *dev = ___CAST(___device_stream*,d);

            break;
          }

#endif

        case ___FILE_DEVICE_KIND:
          {
            ___device_file *d;

#ifdef USE_NONBLOCKING_FILE_IO

            /*
             * Setup file descriptor to perform nonblocking I/O.
             */

            if (___set_fd_blocking_mode (fd, 0) != 0) /* set nonblocking mode */
              return err_code_from_errno ();

#endif

            if ((e = ___device_file_setup_from_fd
                       (&d,
                        dgroup,
                        fd,
                        direction,
                        io_settings))
                == ___FIX(___NO_ERR))
              *dev = ___CAST(___device_stream*,d);

            break;
          }

        case ___PIPE_DEVICE_KIND:
          {
            ___device_pipe *d;

#ifdef USE_NONBLOCKING_FILE_IO

            /*
             * Setup file descriptor to perform nonblocking I/O.
             */

            if (___set_fd_blocking_mode (fd, 0) != 0) /* set nonblocking mode */
              return err_code_from_errno ();

#endif

            if ((e = ___device_pipe_setup_from_fd
                       (&d,
                        dgroup,
                        fd,
                        fd,
                        direction,
                        io_settings))
                == ___FIX(___NO_ERR))
              *dev = ___CAST(___device_stream*,d);

            break;
          }

        default:
          {
            e = ___FIX(___UNKNOWN_ERR);
            break;
          }
        }
    }

  return e;
}


___HIDDEN void device_translate_flags
   ___P((int flags,
         int *fl,
         int *direction),
        (flags,
         fl,
         direction)
int flags;
int *fl;
int *direction;)
{
  int f;

  switch ((flags >> 4) & 3)
    {
    default:
    case 1:
      f = O_RDONLY;
      *direction = ___DIRECTION_RD;
      break;
    case 2:
      f = O_WRONLY;
      *direction = ___DIRECTION_WR;
      break;
    case 3:
      f = O_RDWR;
      *direction = ___DIRECTION_RD|___DIRECTION_WR;
      break;
    }

  if (flags & (1 << 3))
    f |= O_APPEND;

  switch ((flags >> 1) & 3)
    {
    default:
    case 0: break;
    case 1: f |= O_CREAT; break;
    case 2: f |= O_CREAT|O_EXCL; break;
    }

  if (flags & 1)
    f |= O_TRUNC;

  /*
   * The O_NONBLOCK flag is not needed here because the file
   * descriptor will be set to nonblocking mode later on.  But we do
   * it anyway so there is no moment in time when it is in blocking
   * mode.
   */

  f |= O_NONBLOCK;

  *fl = f;
}

#endif


#ifdef USE_WIN32

___HIDDEN int ___device_stream_kind_from_handle
   ___P((HANDLE h),
        (h)
HANDLE h;)
{
  DWORD n;
  CONSOLE_CURSOR_INFO cinfo;
  DCB dcb;
  BY_HANDLE_FILE_INFORMATION finfo;

#ifdef ___DEBUG_LOG
  ___printf ("GetFileType -> %d\n", ___CAST(int,GetFileType (h)));
#endif

  if (GetNumberOfConsoleInputEvents (h, &n) ||
      GetConsoleCursorInfo (h, &cinfo))
    return ___TTY_DEVICE_KIND;

  if (GetCommState (h, &dcb))
    return ___SERIAL_DEVICE_KIND;

  if (GetFileType (h) == FILE_TYPE_PIPE)
    return ___PIPE_DEVICE_KIND;

  if (GetFileType (h) == FILE_TYPE_CHAR ||
      GetFileType (h) == FILE_TYPE_DISK ||
      GetFileInformationByHandle (h, &finfo))
    return ___FILE_DEVICE_KIND;

  return ___NONE_KIND;
}


___HIDDEN int ___device_stream_direction_from_handle
   ___P((HANDLE h),
        (h)
HANDLE h;)
{
  DWORD n;
  int direction = ___DIRECTION_RD|___DIRECTION_WR;

  /*
   * A "ReadFile" and "WriteFile" of 0 bytes is attempted to tell which
   * directions the file handle supports.
   */

  if (!ReadFile (h, NULL, 0, &n, NULL))
    direction &= ~___DIRECTION_RD;

  if (!WriteFile (h, NULL, 0, &n, NULL))
    direction &= ~___DIRECTION_WR;

  /*
   * It is likely that on some systems a zero length "ReadFile" and
   * "WriteFile" will return an error, regardless of the possible
   * operations.  In this case assume that both operations are
   * possible.
   */

  if (direction == 0)
    direction = ___DIRECTION_RD|___DIRECTION_WR;

  return direction;
}


___SCMOBJ ___device_stream_setup_from_handle
   ___P((___device_stream **dev,
         ___device_group *dgroup,
         HANDLE h,
         int flags,
         int kind,
         int direction,
         int io_settings),
        (dev,
         dgroup,
         h,
         flags,
         kind,
         direction,
         io_settings)
___device_stream **dev;
___device_group *dgroup;
HANDLE h;
int flags;
int kind;
int direction;
int io_settings)
{
  ___SCMOBJ e = ___FIX(___UNKNOWN_ERR);

  if (kind == ___NONE_KIND)
    kind = ___device_stream_kind_from_handle (h);

  if (direction == 0)
    direction = ___device_stream_direction_from_handle (h);

#ifdef ___DEBUG_LOG
  ___printf ("kind=%d direction=%d\n", kind, direction);
#endif

  switch (kind)
    {
    case ___TTY_DEVICE_KIND:
      {
        ___device_tty *d;
        if ((e = ___device_tty_setup_from_console
                   (&d,
                    dgroup,
                    direction))
            == ___FIX(___NO_ERR))
          {
            d->stage = TTY_STAGE_OPENED_FRESH;
            *dev = ___CAST(___device_stream*,d);
          }
        break;
      }

    case ___SERIAL_DEVICE_KIND:
      {
        ___device_serial *d;
        if ((e = ___device_serial_setup_from_handle
                   (&d,
                    dgroup,
                    h,
                    direction,
                    io_settings))
            == ___FIX(___NO_ERR))
          *dev = ___CAST(___device_stream*,d);
        break;
      }

    case ___FILE_DEVICE_KIND:
      {
        ___device_file *d;
        if ((e = ___device_file_setup_from_handle
                   (&d,
                    dgroup,
                    h,
                    flags,
                    direction,
                    io_settings,
                    0))
            == ___FIX(___NO_ERR))
          *dev = ___CAST(___device_stream*,d);
        break;
      }

    case ___PIPE_DEVICE_KIND:
      {
        ___device_pipe *d;
        if ((e = ___device_pipe_setup_from_handle
                   (&d,
                    dgroup,
                    h,
                    h,
                    direction,
                    io_settings,
                    0))
            == ___FIX(___NO_ERR))
          *dev = ___CAST(___device_stream*,d);
        break;
      }

    default:
      {
        e = ___FIX(___UNKNOWN_ERR);
        break;
      }
    }

  if (e == ___FIX(___NO_ERR))
    device_transfer_close_responsibility (___CAST(___device*,*dev));

  return e;
}


___HIDDEN void device_translate_flags
   ___P((int flags,
         DWORD *access_mode,
         DWORD *share_mode,
         DWORD *creation_mode,
         DWORD *attributes,
         int *direction),
        (flags,
         access_mode,
         share_mode,
         creation_mode,
         attributes,
         direction)
int flags;
DWORD *access_mode;
DWORD *share_mode;
DWORD *creation_mode;
DWORD *attributes;
int *direction;)
{
  DWORD am;
  DWORD cm;

  switch ((flags >> 4) & 3)
    {
    default:
    case 1:
      am = GENERIC_READ;
      *direction = ___DIRECTION_RD;
      break;
    case 2:
      am = GENERIC_WRITE;
      *direction = ___DIRECTION_WR;
      break;
    case 3:
      am = GENERIC_READ|GENERIC_WRITE;
      *direction = ___DIRECTION_RD|___DIRECTION_WR;
      break;
    }

  switch ((flags >> 1) & 3)
    {
    default:
    case 0:
      if (flags & 1)
        cm = TRUNCATE_EXISTING;
      else
        cm = OPEN_EXISTING;
      break;

    case 1:
      if (flags & 1)
        cm = CREATE_ALWAYS;
      else
        cm = OPEN_ALWAYS;
      break;

    case 2:
      cm = CREATE_NEW;
      break;
    }

  *access_mode = am;
  *share_mode = FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE;
  *creation_mode = cm;
  *attributes = FILE_ATTRIBUTE_NORMAL;
}

#endif


/*---------------------------------------------------------------------------*/

/* Child process interrupts. */

#ifdef USE_SIGNALS

___HIDDEN void sigchld_signal_handler
   ___P((int sig),
        (sig)
int sig;)
{
#ifdef USE_POSIX
  int save_errno = errno;
#ifdef USE_signal
  ___set_signal_handler (SIGCHLD, sigchld_signal_handler);
#endif

  /*
   * A SIGCHLD signal indicates that at least one child has changed
   * status.  There may be more than one because signals are not
   * queued.  For example during a period when the SIGCHLD signal is
   * blocked several child processes can terminate and only one call
   * to the SIGCHLD handler will occur when the SIGCHLD signal is
   * unblocked.  For this reason we must call waitpid in a loop, until
   * the last call indicates that no other child process is available.
   */

  for (;;)
    {
      int status;
      ___device *head;
      pid_t pid = ___waitpid_no_EINTR (-1, &status, WNOHANG);

      if (pid <= 0 ||
          !(WIFEXITED(status) || WIFSIGNALED(status)))
        break;

      /*
       * Find the process device structure for the process which
       * terminated, and save the exit status with the process device.
       */

      head = ___global_device_group ()->list;

      if (head != NULL)
        {
          ___device *d = head->prev;

          do
            {
              if (___device_kind (d) == ___PROCESS_DEVICE_KIND)
                {
                  ___device_process *dev = ___CAST(___device_process*,d);

                  if (dev->pid == pid)
                    {
                      ___device_process_status_set (dev, status); /* ignore error */
                      break;
                    }
                }
              d = d->prev;
            } while  (d != head);
        }
    }
  errno = save_errno;
#endif
}

#endif


___SCMOBJ ___setup_child_interrupt_handling ___PVOID
{
#ifdef USE_SIGNALS

  ___set_signal_handler (SIGPIPE, SIG_IGN);
  ___set_signal_handler (SIGCHLD, sigchld_signal_handler);

  ___thread_sigmask1 (SIG_UNBLOCK, SIGCHLD, NULL);

#endif

  return ___FIX(___NO_ERR);
}


void ___cleanup_child_interrupt_handling ___PVOID
{
#ifdef USE_SIGNALS

  ___set_signal_handler (SIGPIPE, SIG_DFL);
  ___set_signal_handler (SIGCHLD, SIG_DFL);

  ___thread_sigmask1 (SIG_UNBLOCK, SIGCHLD, NULL);

#endif
}


___EXP_FUNC(void,___mask_child_interrupts_begin)
   ___P((___mask_child_interrupts_state *state),
        (state)
___mask_child_interrupts_state *state;)
{
#ifdef USE_SIGNALS

  ___thread_sigmask1 (SIG_BLOCK, SIGCHLD, state->sigset+2);

#endif
}


___EXP_FUNC(void,___mask_child_interrupts_end)
   ___P((___mask_child_interrupts_state *state),
        (state)
___mask_child_interrupts_state *state;)
{
#ifdef USE_SIGNALS

  ___thread_sigmask (SIG_SETMASK, state->sigset+2, NULL);

#endif
}


/*---------------------------------------------------------------------------*/

#ifndef ___STREAM_OPEN_PROCESS_CE_SELECT

#ifdef USE_execvp
#define ___STREAM_OPEN_PROCESS_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#ifndef USE_openpty
#ifndef USE_ptsname
#undef ___STREAM_OPEN_PROCESS_CE_SELECT
#endif
#endif
#endif

#ifdef USE_CreateProcess
#ifdef _UNICODE
#define ___STREAM_OPEN_PROCESS_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#define CP_ENV_FLAGS CREATE_UNICODE_ENVIRONMENT
#else
#define ___STREAM_OPEN_PROCESS_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define CP_ENV_FLAGS 0
#endif
#endif

#endif


#ifdef ___STREAM_OPEN_PROCESS_CE_SELECT

#ifdef USE_execvp

___HIDDEN int open_pseudo_terminal_master
   ___P((int *master_fd_ptr,
         int *slave_fd_ptr),
        (master_fd_ptr,
         slave_fd_ptr)
int *master_fd_ptr;
int *slave_fd_ptr;)
{
#ifdef USE_openpty

  return openpty (master_fd_ptr, slave_fd_ptr, NULL, NULL, NULL);

#else
#ifdef USE_getpt

  *slave_fd_ptr = -1;
  return *master_fd_ptr = getpt ();

#else

  *slave_fd_ptr = -1;
  return *master_fd_ptr = open_long_path ("/dev/ptmx", O_RDWR | O_NOCTTY, 0);

#endif
#endif
}


#if 0
#ifndef USE_openpty
/***************************/
#define __USE_XOPEN
#define __USE_GNU
#include <stdlib.h>
#include <stropts.h>
extern char *ptsname (int __fd);
#endif
#endif

___HIDDEN int setup_terminal_slave
   ___P((int slave_fd),
        (slave_fd)
int slave_fd;)
{
  struct termios tios;

  if (tcgetattr (slave_fd, &tios) >= 0)
    {
      tios.c_lflag &= ~(ECHO | ECHOCTL | ICANON | IEXTEN | ISIG);
      tios.c_iflag &= ~(BRKINT | INLCR | ICRNL | INPCK | ISTRIP | IXON | IXOFF);
      tios.c_cflag &= ~(CSIZE | PARENB | CLOCAL);
      tios.c_cflag |= (CS8 | HUPCL);
#ifndef OCRNL
#define OCRNL 0
#endif
      tios.c_oflag &= ~(OPOST | ONLCR | OCRNL);

      if (tcsetattr (slave_fd, TCSANOW, &tios) >= 0)
        return 0;
    }

  return -1;
}


___HIDDEN int open_pseudo_terminal_slave
   ___P((int master_fd,
         int *slave_fd),
        (master_fd,
         slave_fd)
int master_fd;
int *slave_fd;)
{
#ifndef USE_openpty
#ifndef USE_ptsname

  errno = xxx;/********************/
  return -1;

#endif
#endif

#ifdef USE_openpty

  return 0;

#endif

#ifdef USE_ptsname

  int fd;
  char *name;

  if (grantpt (master_fd) >= 0 &&
      unlockpt (master_fd) >= 0 &&
      (name = ptsname (master_fd)) != NULL &&
      (fd = open_long_path (name, O_RDWR, 0)) >= 0)
    {
      int tmp;

      if (
#ifndef HAVE_isastream
          1
#else
          !isastream (fd)
#ifdef I_PUSH
          || (ioctl (fd, I_PUSH, "ptem") >= 0 &&
              ioctl (fd, I_PUSH, "ldterm") >= 0)
#endif
#endif
         )
        {
          *slave_fd = fd;
          return 0;
        }

      tmp = errno;
      ___close_no_EINTR (fd); /* ignore error */
      errno = tmp;
    }

  return -1;

#endif
}


___HIDDEN int open_full_duplex_pipe1
   ___P((___full_duplex_pipe *fdp,
         ___BOOL use_pty),
        (fdp,
         use_pty)
___full_duplex_pipe *fdp;
___BOOL use_pty;)
{
  fdp->input.reading_fd = -1;
  fdp->input.writing_fd = -1;
  fdp->output.reading_fd = -1;
  fdp->output.writing_fd = -1;

  if (use_pty)
    {
      int master_fd;
      int slave_fd;
      if (open_pseudo_terminal_master (&master_fd, &slave_fd) >= 0)
        {
          int master_fd_dup;
          int tmp;
          if ((master_fd_dup = ___dup_no_EINTR (master_fd)) >= 0)
            {
              fdp->input.writing_fd = master_fd;
              fdp->output.reading_fd = master_fd_dup;
              fdp->input.reading_fd = slave_fd;
              return 0;
            }
          tmp = errno;
          ___close_no_EINTR (master_fd); /* ignore error */
          if (slave_fd >= 0)
            ___close_no_EINTR (slave_fd); /* ignore error */
          errno = tmp;
        }
    }
  else
    {
      if (___open_half_duplex_pipe (&fdp->input) >= 0)
        {
          if (___open_half_duplex_pipe (&fdp->output) >= 0)
            return 0;
          ___close_half_duplex_pipe (&fdp->input, 2);
        }
    }

  return -1;
}


___HIDDEN int open_full_duplex_pipe2
   ___P((___full_duplex_pipe *fdp,
         ___BOOL use_pty),
        (fdp,
         use_pty)
___full_duplex_pipe *fdp;
___BOOL use_pty;)
{
  if (use_pty)
    {
      if (setsid () >= 0 &&
#ifdef TIOCSCTTY
          ioctl (fdp->input.reading_fd, TIOCSCTTY, 0) >= 0 &&
#endif
          open_pseudo_terminal_slave (fdp->input.writing_fd,
                                      &fdp->input.reading_fd) >= 0)
        {
          int tmp;
          if (setup_terminal_slave (fdp->input.reading_fd) >= 0 &&
              (fdp->output.writing_fd = ___dup_no_EINTR (fdp->input.reading_fd)) >= 0)
            return 0;
          tmp = errno;
          ___close_no_EINTR (fdp->input.reading_fd); /* ignore error */
          errno = tmp;
        }
    }
  else
    return 0;

  return -1;
}

#endif


#ifdef USE_CreateProcess

#define ___ESCAPE_PROCESS_ARGS

int arg_encoding
   ___P((___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) arg,
         int *len_increase,
         ___BOOL *need_quotes),
        (arg,
         len_increase,
         need_quotes)
___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) arg;
int *len_increase;
___BOOL *need_quotes;)
{
  int len = 0;

  while (arg[len] != ___UNICODE_NUL)
    len++;

#ifdef ___ESCAPE_PROCESS_ARGS

  {
    int j = len;
    int increase = 0;
    ___BOOL quotes = FALSE;
    ___BOOL double_backslash = TRUE;

    while (--j >= 0)
      {
        ___CHAR_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) c = arg[j];
        if (c == ___UNICODE_DOUBLEQUOTE ||
            (double_backslash && c == ___UNICODE_BACKSLASH))
          {
            double_backslash = TRUE;
            increase++; /* space for backslash */
          }
        else
          {
            double_backslash = FALSE;
            if (c == ___UNICODE_SPACE)
              quotes = TRUE;
          }
      }

    if (increase > 0)
      quotes = TRUE;

    if (quotes)
      increase += 2; /* space for quotes */

    *len_increase = increase;
    *need_quotes = quotes;
  }

#else

  *len_increase = 0;
  *need_quotes = FALSE;

#endif

  return len;
}

___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) argv_to_ccmd
   ___P((___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) *argv),
        (argv)
___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) *argv;)
{
  ___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) ccmd;
  int ccmd_len = 0;
  int i = 0;
  int len_increase;
  ___BOOL need_quotes;
  ___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) arg;

  while ((arg = argv[i]) != NULL)
    {
      ccmd_len += arg_encoding (arg, &len_increase, &need_quotes);
      ccmd_len += len_increase + 1;
      i++;
    }

  ccmd = ___CAST(___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT),
                 ___ALLOC_MEM(ccmd_len * sizeof (*ccmd)));

  if (ccmd != NULL)
    {
      ccmd[--ccmd_len] = ___UNICODE_NUL;

      while (--i >= 0)
        {
          int j;

          arg = argv[i];

          j = arg_encoding (arg, &len_increase, &need_quotes);

#ifdef ___ESCAPE_PROCESS_ARGS

          {
            ___BOOL double_backslash = TRUE;

            if (need_quotes)
              ccmd[--ccmd_len] = ___UNICODE_DOUBLEQUOTE;

            while (--j >= 0)
              {
                ___CHAR_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) c = arg[j];
                ccmd[--ccmd_len] = c;
                if (c == ___UNICODE_DOUBLEQUOTE ||
                    (double_backslash && c == ___UNICODE_BACKSLASH))
                  {
                    ccmd[--ccmd_len] = ___UNICODE_BACKSLASH;
                    double_backslash = TRUE;
                  }
                else
                  double_backslash = FALSE;
              }

            if (need_quotes)
              ccmd[--ccmd_len] = ___UNICODE_DOUBLEQUOTE;
          }

#else

          while (--j >= 0)
            {
              ___CHAR_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) c = arg[j];
              ccmd[--ccmd_len] = c;
            }

#endif

          if (i > 0)
            ccmd[--ccmd_len] = ___UNICODE_SPACE;
        }
    }

  return ccmd;
}

___STRING_TYPE(___ENVIRON_CE_SELECT) env_to_cenv
   ___P((___STRING_TYPE(___ENVIRON_CE_SELECT) *env),
        (env)
___STRING_TYPE(___ENVIRON_CE_SELECT) *env;)
{
  ___STRING_TYPE(___ENVIRON_CE_SELECT) cenv;
  int cenv_len = 0;
  int i = 0;
  ___STRING_TYPE(___ENVIRON_CE_SELECT) varval;

  while ((varval = env[i++]) != NULL)
    {
      int j = 0;
      while (varval[j++] != ___UNICODE_NUL)
        ;
      cenv_len += j;
    }

  cenv_len++;

  cenv = ___CAST(___STRING_TYPE(___ENVIRON_CE_SELECT),
                 ___ALLOC_MEM(cenv_len * sizeof (*cenv)));

  if (cenv != NULL)
    {
      ___STRING_TYPE(___ENVIRON_CE_SELECT) p = cenv;
      i = 0;

      while ((varval = env[i++]) != NULL)
        {
          int j = 0;
          while ((*p++ = varval[j++]) != ___UNICODE_NUL)
            ;
        }

      *p++ = ___UNICODE_NUL;
    }

  return cenv;
}

#endif


___SCMOBJ ___device_stream_setup_from_process
   ___P((___device_stream **dev,
         ___device_group *dgroup,
         ___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) *argv,
         ___STRING_TYPE(___ENVIRON_CE_SELECT) *env,
         ___STRING_TYPE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT) dir,
         int options),
        (dev,
         dgroup,
         argv,
         env,
         dir,
         options)
___device_stream **dev;
___device_group *dgroup;
___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) *argv;
___STRING_TYPE(___ENVIRON_CE_SELECT) *env;
___STRING_TYPE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT) dir;
int options;)
{
#define STDIN_REDIR  1
#define STDOUT_REDIR 2
#define STDERR_REDIR 4
#define PSEUDO_TERM  8
#define SHOW_CONSOLE 16

#ifdef USE_execvp

  ___SCMOBJ e = ___FIX(___NO_ERR);
  int direction;
  ___device_process *d;
  pid_t pid = 0;
  ___half_duplex_pipe hdp_errno;
  ___full_duplex_pipe fdp;
  int execvp_errno;
  int n;

  /*
   * Block SIGCHLD so that if the process is created the
   * sigchld_signal_handler will find it in the device group.
   */

  ___mask_all_interrupts_state all_interrupts;

  ___mask_all_interrupts_begin (&all_interrupts);

  fdp.input.writing_fd = -1;
  fdp.output.reading_fd = -1;

  if (___open_half_duplex_pipe (&hdp_errno) < 0)
    e = err_code_from_errno ();
  else
    {
      if ((options & (STDIN_REDIR | STDOUT_REDIR | STDERR_REDIR)) &&
          open_full_duplex_pipe1 (&fdp, options & PSEUDO_TERM) < 0)
        e = err_code_from_errno ();
      else
        {
          if ((pid = fork ()) < 0)
            {
              e = err_code_from_errno ();
              if (options & (STDIN_REDIR | STDOUT_REDIR | STDERR_REDIR))
                {
                  ___close_half_duplex_pipe (&fdp.input, 2);
                  ___close_half_duplex_pipe (&fdp.output, 2);
                }
            }
        }

      if (e != ___FIX(___NO_ERR))
        ___close_half_duplex_pipe (&hdp_errno, 2);
    }

  if (e == ___FIX(___NO_ERR))
    {
      if (pid == 0)
        {
          /* child process */

          ___cleanup_all_interrupt_handling ();

          if (options & (STDIN_REDIR | STDOUT_REDIR | STDERR_REDIR))
            {
              if (open_full_duplex_pipe2 (&fdp, options & PSEUDO_TERM) < 0 ||
                  ((options & STDIN_REDIR) &&
                   ___dup2_no_EINTR (fdp.input.reading_fd, STDIN_FILENO) < 0) ||
                  ((options & STDOUT_REDIR) &&
                   ___dup2_no_EINTR (fdp.output.writing_fd, STDOUT_FILENO) < 0) ||
                  ((options & (STDERR_REDIR | PSEUDO_TERM)) &&
                   ___dup2_no_EINTR (fdp.output.writing_fd, STDERR_FILENO) < 0))
                goto return_errno;
            }

#ifdef USE_fcntl
#ifdef FD_CLOEXEC

          if (fcntl (hdp_errno.writing_fd, F_SETFD, FD_CLOEXEC) < 0)
            goto return_errno;

#endif
#endif

          ___close_half_duplex_pipe (&fdp.input, 1);
          ___close_half_duplex_pipe (&fdp.output, 0);
          ___close_half_duplex_pipe (&hdp_errno, 0);

          {
            /* Close all file descriptors that aren't used. */

            int fd = sysconf (_SC_OPEN_MAX) - 1;

            while (fd >= 0)
              {
                if (fd != STDIN_FILENO &&
                    fd != STDOUT_FILENO &&
                    fd != STDERR_FILENO &&
                    fd != hdp_errno.writing_fd)
                  ___close_no_EINTR (fd); /* ignore error */
                fd--;
              }
          }

          if (dir == NULL || chdir_long_path (dir) == 0)
            {
#ifdef USE_environ
              if (env != NULL)
                environ = env;
#endif
              execvp (argv[0], argv);
              /* the exec failed, errno will be returned to parent */
            }
          else
            errno = 0; /* special code indicating chdir failed */

        return_errno:

          /* return the errno to the parent process */

          execvp_errno = errno;

          if (write (hdp_errno.writing_fd, &execvp_errno, sizeof (execvp_errno)) < 0)
            execvp_errno = 0; /* dummy op to avoid compiler warning */

          ___close_half_duplex_pipe (&fdp.input, 0);
          ___close_half_duplex_pipe (&fdp.output, 1);
          ___close_half_duplex_pipe (&hdp_errno, 1);

          _exit (1);
        }

      /* parent process */

      if (options & (STDIN_REDIR | STDOUT_REDIR | STDERR_REDIR))
        {
          ___close_half_duplex_pipe (&fdp.input, 0);
          ___close_half_duplex_pipe (&fdp.output, 1);
        }

      ___close_half_duplex_pipe (&hdp_errno, 1);

      /*
       * The following call to read has been known to fail with EINTR,
       * in particular on OpenBSD 4.5.  This is probably because the
       * child process that is started terminates before the parent
       * process doing the read has time to wakeup.  So the parent
       * process receives a SIGCHLD signal which interrupts the read.
       */

      n = ___read_no_EINTR (hdp_errno.reading_fd,
                            &execvp_errno,
                            sizeof (execvp_errno));

      if (n < 0)
        e = err_code_from_errno ();
      else if (n == sizeof (execvp_errno))
        {
          if (execvp_errno == 0) /* chdir failed? */
            e = ___FIX(1); /* indicate current directory couldn't be set */
          else
            {
              errno = execvp_errno;
              e = err_code_from_errno ();
            }
        }
      else if (n != 0)
        e = ___FIX(___UNKNOWN_ERR);
      else
        {
          direction = ___DIRECTION_RD|___DIRECTION_WR;

          e = ___device_process_setup_from_pid
                (&d,
                 dgroup,
                 pid,
                 fdp.input.writing_fd,
                 fdp.output.reading_fd,
                 direction);

          *dev = ___CAST(___device_stream*,d);

          if (e == ___FIX(___NO_ERR))
            device_transfer_close_responsibility (___CAST(___device*,d));
        }

      if (e != ___FIX(___NO_ERR))
        if (options & (STDIN_REDIR | STDOUT_REDIR | STDERR_REDIR))
          {
            ___close_half_duplex_pipe (&fdp.input, 1);
            ___close_half_duplex_pipe (&fdp.output, 0);
          }

      ___close_half_duplex_pipe (&hdp_errno, 0);
    }

  ___mask_all_interrupts_end (&all_interrupts);

  return e;

#endif

#ifdef USE_CreateProcess

  ___SCMOBJ e;
  int direction;
  ___device_process *d;

  ___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT) ccmd;
  ___STRING_TYPE(___ENVIRON_CE_SELECT) cenv = NULL;

  HANDLE hstdin_rd = NULL;
  HANDLE hstdin_wr = NULL;
  HANDLE hstdout_rd = NULL;
  HANDLE hstdout_wr = NULL;

  SECURITY_ATTRIBUTES sa;
  PROCESS_INFORMATION pi;
  STARTUPINFO si;

  sa.nLength = sizeof (SECURITY_ATTRIBUTES);
  sa.bInheritHandle = TRUE;
  sa.lpSecurityDescriptor = NULL;

  if ((ccmd = argv_to_ccmd (argv)) == NULL ||
      (env != NULL && (cenv = env_to_cenv (env)) == NULL))
    e = ___FIX(___HEAP_OVERFLOW_ERR);
  else
    {
      ZeroMemory (&pi, sizeof (pi));

      ZeroMemory (&si, sizeof (si));
      si.cb = sizeof (si);

      si.hStdInput  = GetStdHandle (STD_INPUT_HANDLE);
      si.hStdOutput = GetStdHandle (STD_OUTPUT_HANDLE);
      si.hStdError  = GetStdHandle (STD_ERROR_HANDLE);

      if (options & STDIN_REDIR)
        {
          if (!CreatePipe (&hstdin_rd, &hstdin_wr, &sa, 0))
            e = err_code_from_GetLastError ();
          else
            {
              SetHandleInformation (hstdin_wr, HANDLE_FLAG_INHERIT, 0);
              si.hStdInput = hstdin_rd;
            }
        }

      if (options & (STDOUT_REDIR | STDERR_REDIR))
        {
          if (!CreatePipe (&hstdout_rd, &hstdout_wr, &sa, 0))
            e = err_code_from_GetLastError ();
          else
            {
              SetHandleInformation (hstdout_rd, HANDLE_FLAG_INHERIT, 0);
              if (options & STDOUT_REDIR)
                si.hStdOutput = hstdout_wr;
              if (options & STDERR_REDIR)
                si.hStdError = hstdout_wr;
            }
        }

      si.dwFlags |= STARTF_USESTDHANDLES;

#if 0
      if (hstdin_wr != NULL)
        {
          HANDLE h_wr;
          if (DuplicateHandle (GetCurrentProcess (),
                               hstdin_wr,
                               GetCurrentProcess (),
                               &h_wr,
                               0,
                               FALSE,
                               DUPLICATE_SAME_ACCESS))
            {
              CloseHandle (hstdin_wr);
              hstdin_wr = h_wr;
            }
        }

      if (hstdout_rd != NULL)
        {
          HANDLE h_rd;
          if (DuplicateHandle (GetCurrentProcess (),
                               hstdout_rd,
                               GetCurrentProcess (),
                               &h_rd,
                               0,
                               FALSE,
                               DUPLICATE_SAME_ACCESS))
            {
              CloseHandle (hstdout_rd);
              hstdout_rd = h_rd;
            }
        }
#endif

      if (si.hStdError == INVALID_HANDLE_VALUE)
        e = err_code_from_GetLastError ();
      else
        {
          if (!CreateProcess
                 (NULL, /* module name                              */
                  ccmd, /* command line                             */
                  NULL, /* process handle not inheritable           */
                  NULL, /* thread handle not inheritable            */
                  TRUE, /* set handle inheritance to TRUE           */
                  (CP_ENV_FLAGS | ((options & SHOW_CONSOLE) ? 0 : CREATE_NO_WINDOW)), /* creation flags */
                  cenv, /* child's environment                      */
                  dir,  /* child's starting directory               */
                  &si,  /* pointer to STARTUPINFO structure         */
                  &pi)) /* pointer to PROCESS_INFORMATION structure */
            {
              if (GetLastError () == ERROR_DIRECTORY)
                e = ___FIX(1); /* indicate setting starting directory failed */
              else
                e = err_code_from_GetLastError ();
            }
          else
            {
              direction = ___DIRECTION_RD|___DIRECTION_WR;

              e = ___device_process_setup_from_process
                    (&d,
                     dgroup,
                     pi,
                     hstdin_wr,
                     hstdout_rd,
                     direction);

              *dev = ___CAST(___device_stream*,d);

              if (e == ___FIX(___NO_ERR))
                device_transfer_close_responsibility (___CAST(___device*,d));
            }
        }
    }

  if (hstdout_rd != NULL)
    CloseHandle (hstdout_wr); /* ignore error */

  if (hstdin_rd != NULL)
    CloseHandle (hstdin_rd); /* ignore error */

  if (e != ___FIX(___NO_ERR))
    {
      if (hstdout_rd != NULL)
        CloseHandle (hstdout_rd); /* ignore error */

      if (hstdin_rd != NULL)
        CloseHandle (hstdin_wr); /* ignore error */
    }

  if (cenv != NULL)
    ___FREE_MEM(cenv);

  if (ccmd != NULL)
    ___FREE_MEM(ccmd);

  return e;

#endif
}

#endif


___SCMOBJ ___os_device_process_pid
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
  ___device_process *d =
    ___CAST(___device_process*,___FIELD(dev,___FOREIGN_PTR));

#ifndef USE_POSIX
#ifndef USE_WIN32

  return ___FIX(0);

#endif
#endif

#ifdef USE_POSIX

  return ___FIX(d->pid);

#endif

#ifdef USE_WIN32

  return ___FIX(d->pi.dwProcessId);

#endif
}


___SCMOBJ ___os_device_process_status
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
  ___device_process *d =
    ___CAST(___device_process*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;

  if ((e = ___device_process_status_poll (d)) != ___FIX(___NO_ERR))
    return e;

  if (!d->got_status)
    return ___FAL;

  return ___FIX(d->status);
}


/*---------------------------------------------------------------------------*/

#define ___STREAM_OPEN_PATH_SUPPORTED

#ifdef ___STREAM_OPEN_PATH_SUPPORTED

___SCMOBJ ___device_stream_setup_from_path
   ___P((___device_stream **dev,
         ___device_group *dgroup,
         ___STRING_TYPE(___STREAM_OPEN_PATH_CE_SELECT) path,
         int flags,
         int mode),
        (dev,
         dgroup,
         path,
         flags,
         mode)
___device_stream **dev;
___device_group *dgroup;
___STRING_TYPE(___STREAM_OPEN_PATH_CE_SELECT) path;
int flags;
int mode;)
{
  ___SCMOBJ e;

#ifndef USE_POSIX
#ifndef USE_WIN32

  char *mod;
  int direction;
  ___FILE *stream;

  device_translate_flags (flags,
                          &mod,
                          &direction);

#ifdef ___DEBUG_LOG
  ___printf ("path=\"%s\" mode=%s\n", path, mod);
#endif

  if ((stream = ___fopen (path, mod)) == 0)
    return fnf_or_err_code_from_errno ();

  if ((e = ___device_stream_setup_from_stream
             (dev,
              dgroup,
              stream,
              ___NONE_KIND,
              direction,
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_FILE]))
      != ___FIX(___NO_ERR))
    ___fclose (stream); /* ignore error */

#endif
#endif

#ifdef USE_POSIX

  int fl;
  int direction;
  int fd;

  device_translate_flags (flags,
                          &fl,
                          &direction);

#ifdef ___DEBUG_LOG
  ___printf ("path=\"%s\" fl=%d\n", path, fl);
#endif

  if ((fd = open_long_path (path,
                            fl,
#ifdef O_BINARY
                            O_BINARY|
#endif
                            mode))
      < 0)
    return fnf_or_err_code_from_errno ();

  if ((e = ___device_stream_setup_from_fd
             (dev,
              dgroup,
              fd,
              ___NONE_KIND,
              direction,
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_FILE]))
      != ___FIX(___NO_ERR))
    ___close_no_EINTR (fd); /* ignore error */

#endif

#ifdef USE_WIN32

  DWORD access_mode;
  DWORD share_mode;
  DWORD creation_mode;
  DWORD attributes;
  int direction;
  HANDLE h;

  device_translate_flags (flags,
                          &access_mode,
                          &share_mode,
                          &creation_mode,
                          &attributes,
                          &direction);

  h = CreateFile (path,
                  access_mode,
                  share_mode,
                  NULL,
                  creation_mode,
                  attributes,
                  NULL);

  if (h == INVALID_HANDLE_VALUE)
    return fnf_or_err_code_from_GetLastError ();

  if ((e = ___device_stream_setup_from_handle
             (dev,
              dgroup,
              h,
              flags,
              ___NONE_KIND,
              direction,
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_FILE]))
      != ___FIX(___NO_ERR))
    CloseHandle (h); /* ignore error */

#endif

  if (e == ___FIX(___NO_ERR))
    device_transfer_close_responsibility (___CAST(___device*,*dev));

  return e;
}

#endif


/*---------------------------------------------------------------------------*/

/* Device operations. */

___SCMOBJ ___os_device_kind
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
  ___device *d = ___CAST(___device*,___FIELD(dev,___FOREIGN_PTR));

  return ___FIX(___device_kind (d));
}


___SCMOBJ ___os_device_force_output
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ level),
        (dev_condvar,
         level)
___SCMOBJ dev_condvar;
___SCMOBJ level;)
{
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device *d = ___CAST(___device*,___FIELD(dev,___FOREIGN_PTR));

  return ___device_force_output (d, ___INT(level));
}


___SCMOBJ ___os_device_close
   ___P((___SCMOBJ dev,
         ___SCMOBJ direction),
        (dev,
         direction)
___SCMOBJ dev;
___SCMOBJ direction;)
{
  ___device *d = ___CAST(___device*,___FIELD(dev,___FOREIGN_PTR));

  return ___device_close (d, ___INT(direction));
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Stream device operations. */

___SCMOBJ ___os_device_stream_seek
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ pos,
         ___SCMOBJ whence),
        (dev_condvar,
         pos,
         whence)
___SCMOBJ dev_condvar;
___SCMOBJ pos;
___SCMOBJ whence;)
{
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_stream *d =
    ___CAST(___device_stream*,___FIELD(dev,___FOREIGN_PTR));
  ___SSIZE_T p;
  ___SCMOBJ e;
  ___SCMOBJ result;

  if ((e = ___SCMOBJ_to_SSIZE_T (___PSA(___PSTATE) pos, &p, 2)) == ___FIX(___NO_ERR))
    e = ___device_stream_seek (d, &p, ___INT(whence));

  if (e != ___FIX(___NO_ERR) ||
      (e = ___SSIZE_T_to_SCMOBJ (___PSTATE, p, &result, ___RETURN_POS)) != ___FIX(___NO_ERR))
    result = e;
  /* TODO: check if ___release_scmobj (...); needed to avoid memory leak */

  return result;
}


___SCMOBJ ___os_device_stream_read
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ buffer,
         ___SCMOBJ lo,
         ___SCMOBJ hi),
        (dev_condvar,
         buffer,
         lo,
         hi)
___SCMOBJ dev_condvar;
___SCMOBJ buffer;
___SCMOBJ lo;
___SCMOBJ hi;)
{
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_stream *d =
    ___CAST(___device_stream*,___FIELD(dev,___FOREIGN_PTR));
  ___stream_index len_done;
  ___SCMOBJ e;

  if ((e = ___device_stream_read
             (d,
              ___CAST(___U8*,___BODY_AS(buffer,___tSUBTYPED)) + ___INT(lo),
              ___INT(hi) - ___INT(lo),
              &len_done))
      == ___FIX(___NO_ERR))
    return ___FIX(len_done);

  return e;
}


___SCMOBJ ___os_device_stream_write
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ buffer,
         ___SCMOBJ lo,
         ___SCMOBJ hi),
        (dev_condvar,
         buffer,
         lo,
         hi)
___SCMOBJ dev_condvar;
___SCMOBJ buffer;
___SCMOBJ lo;
___SCMOBJ hi;)
{
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_stream *d =
    ___CAST(___device_stream*,___FIELD(dev,___FOREIGN_PTR));
  ___stream_index len_done;
  ___SCMOBJ e;

  if ((e = ___device_stream_write
             (d,
              ___CAST(___U8*,___BODY_AS(buffer,___tSUBTYPED)) + ___INT(lo),
              ___INT(hi) - ___INT(lo),
              &len_done))
      == ___FIX(___NO_ERR))
    return ___FIX(len_done);

  return e;
}


___SCMOBJ ___os_device_stream_width
   ___P((___SCMOBJ dev_condvar),
        (dev_condvar)
___SCMOBJ dev_condvar;)
{
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_stream *d =
    ___CAST(___device_stream*,___FIELD(dev,___FOREIGN_PTR));

  return ___device_stream_width (d);
}


___SCMOBJ ___os_device_stream_default_options
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
  ___device_stream *d =
    ___CAST(___device_stream*,___FIELD(dev,___FOREIGN_PTR));

  return ___device_stream_default_options (d);
}


___SCMOBJ ___os_device_stream_options_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ options),
        (dev,
         options)
___SCMOBJ dev;
___SCMOBJ options;)
{
  ___device_stream *d =
    ___CAST(___device_stream*,___FIELD(dev,___FOREIGN_PTR));

  return ___device_stream_options_set (d, options);
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Raw device file descriptors */

typedef struct ___device_raw_struct
  {
    ___device base;

#ifdef USE_POSIX
    int fd;
#endif

#ifdef USE_WIN32
    HANDLE h;
#endif

  } ___device_raw;

typedef struct ___device_raw_vtbl_struct
  {
    ___device_vtbl base;
  } ___device_raw_vtbl;


___HIDDEN int ___device_raw_kind
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___RAW_DEVICE_KIND;
}

___HIDDEN ___SCMOBJ ___device_raw_close_virt
   ___P((___device *self,
         int direction),
        (self,
         direction)
        ___device *self;
        int direction;)
{
  ___device_raw *d = ___CAST(___device_raw*,self);
  int is_not_closed = 0;

  if (d->base.read_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_RD;

  if (d->base.write_stage != ___STAGE_CLOSED)
    is_not_closed |= ___DIRECTION_WR;

  if (is_not_closed == 0)
    return ___FIX(___NO_ERR);

  if ((is_not_closed & ~direction) == 0)
    {
      d->base.read_stage = ___STAGE_CLOSED; /* avoid multiple closes */
      d->base.write_stage = ___STAGE_CLOSED;

#ifdef USE_POSIX
      if (___close_no_EINTR (d->fd) < 0)
        return err_code_from_errno ();
#endif

#ifdef USE_WIN32
      if (!CloseHandle (d->h))
        return err_code_from_GetLastError ();
#endif

    }
  else if (is_not_closed & direction & ___DIRECTION_RD)
    d->base.read_stage = ___STAGE_CLOSED;
  else if (is_not_closed & direction & ___DIRECTION_WR)
    d->base.write_stage = ___STAGE_CLOSED;

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_raw_select_raw_virt
   ___P((___device *self,
         int for_op,
         int i,
         int pass,
         ___device_select_state *state),
        (self,
         for_op,
         i,
         pass,
         state)
___device *self;
int for_op;
int i;
int pass;
___device_select_state *state;)
{
  ___device_raw *d = ___CAST(___device_raw*,self);
  int stage = (for_op == FOR_READING
               ? d->base.read_stage
               : d->base.write_stage);

  if (pass == ___SELECT_PASS_1)
    {
      if (stage != ___STAGE_OPEN)
        state->timeout = ___time_mod.time_neg_infinity;
      else
        {
#ifndef USE_POSIX
#ifndef USE_WIN32

        state->timeout = ___time_mod.time_neg_infinity;

#endif
#endif

#ifdef USE_POSIX
          ___device_select_add_fd (state, d->fd, for_op);
#endif
        }
      return ___FIX(___SELECT_SETUP_DONE);
    }

  /* pass == ___SELECT_PASS_CHECK */

  if (stage != ___STAGE_OPEN)
    state->devs[i] = NULL;
  else
    {
#ifndef USE_POSIX
#ifndef USE_WIN32

      state->devs[i] = NULL;

#endif
#endif

#ifdef USE_POSIX

      if (for_op == FOR_READING
           ? ___FD_ISSET(d->fd, state->readfds)
           : ___FD_ISSET(d->fd, state->writefds))
        state->devs[i] = NULL;

#endif

#ifdef USE_WIN32

      if (state->devs_next[i] != -1)
        state->devs[i] = NULL;

#endif
    }

  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_raw_release_virt
   ___P((___device *self),
        (self)
___device *self;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___SCMOBJ ___device_raw_force_output_virt
   ___P((___device *self,
         int level),
        (self,
         level)
___device *self;
int level;)
{
  return ___FIX(___NO_ERR);
}

___HIDDEN ___device_raw_vtbl ___device_raw_table =
{
  {
    ___device_raw_kind,
    ___device_raw_select_raw_virt,
    ___device_raw_release_virt,
    ___device_raw_force_output_virt,
    ___device_raw_close_virt
  }
};

#ifdef USE_POSIX

___SCMOBJ ___device_raw_setup_from_fd
   ___P((___device_raw **dev,
         ___device_group *dgroup,
         int fd,
         int direction),
        (dev,
         dgroup,
         fd,
         direction)
___device_raw **dev;
___device_group *dgroup;
int fd;
int direction;)
{
  ___device_raw *d;

#ifdef USE_FDSET_RESIZING

  if (!___fdset_resize (fd, fd))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

  d = ___CAST(___device_raw*,
              ___ALLOC_MEM(sizeof (___device_raw)));

  if (d == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);


  d->base.vtbl = &___device_raw_table;
  d->base.refcount = 1;
  d->base.direction = direction;
  d->base.close_direction = 0; /* prevent closing on errors */

  if (direction & ___DIRECTION_RD)
    d->base.read_stage = ___STAGE_OPEN;
  else
    d->base.read_stage = ___STAGE_CLOSED;

  if (direction & ___DIRECTION_WR)
    d->base.write_stage = ___STAGE_OPEN;
  else
    d->base.write_stage = ___STAGE_CLOSED;

  d->fd = fd;

  device_transfer_close_responsibility (___CAST(___device*,d));

  *dev = d;

  ___device_add_to_group (dgroup, &d->base);

  return ___FIX(___NO_ERR);
}
#endif

___SCMOBJ ___os_device_raw_open_from_fd
   ___P((___SCMOBJ fd,
         ___SCMOBJ flags),
        (fd,
         flags)
___SCMOBJ fd;
___SCMOBJ flags;)
{

#ifdef USE_POSIX
  ___SCMOBJ e;
  ___device_raw *dev;
  ___SCMOBJ result;

  int ifd;
  int fl;
  int direction;

  device_translate_flags (___INT(flags),
                          &fl,
                          &direction);

  ifd = ___INT(fd);

  if ((e = ___device_raw_setup_from_fd
             (&dev,
              ___global_device_group (),
              ifd,
              direction))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = ___NONNULLPOINTER_to_SCMOBJ
             (___PSTATE,
              dev,
              ___FAL,
              ___device_cleanup_from_ptr,
              &result,
              ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
      return e;
    }

  return ___release_scmobj (result);

#else

  return ___FIX(___UNIMPL_ERR);

#endif
}

/* Opening a predefined device (stdin, stdout, stderr, console, etc). */

___SCMOBJ ___os_device_stream_open_predefined
   ___P((___SCMOBJ index,
         ___SCMOBJ flags),
        (index,
         flags)
___SCMOBJ index;
___SCMOBJ flags;)
{
  /*
   * The parameter "index" identifies the stream which is to be
   * associated with the returned device.  The stream must be
   * currently open.  The responsibility for closing the stream is not
   * transferred to the runtime system because the client may have to
   * do I/O on the stream after the runtime system terminates (for
   * example output on stdout).
   */

  ___SCMOBJ e;
  ___device_stream *dev;
  ___SCMOBJ result;

#ifndef USE_POSIX
#ifndef USE_WIN32

  char *mode;
  int direction;
  int io_settings = 0; /* no specific io_settings */
  ___FILE *stream;

  device_translate_flags (___INT(flags),
                          &mode,
                          &direction);

  switch (___INT(index))
    {
    case -4:
      {
        ___device_tty *d;

        if ((e = ___device_tty_setup_console
                   (&d,
                    ___global_device_group (),
                    direction))
            != ___FIX(___NO_ERR))
          return e;

        dev = ___CAST(___device_stream*,d);

        break;
      }

    default:
      {
        int stdio_settings =
          ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIO];

        switch (___INT(index))
          {
          case -1:
            stream = ___stdin;
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIN];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          case -2:
            stream = ___stdout;
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDOUT];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          case -3:
            stream = ___stderr;
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDERR];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          default:
            if (___INT(index) >= 0 && ___INT(index) <= 2)
              {
                io_settings =
                  ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIN+___INT(index)];
                io_settings = ___io_settings_merge (io_settings, stdio_settings);
              }
            stream = fdopen (___INT(index), mode);
            break;
          }

        if ((e = ___device_stream_setup_from_stream
                   (&dev,
                    ___global_device_group (),
                    stream,
                    ___NONE_KIND,
                    direction,
                    io_settings))
            != ___FIX(___NO_ERR))
          return e;

        break;
      }
    }

#endif
#endif

#ifdef USE_POSIX

  int fl;
  int direction;
  int io_settings = 0; /* no specific io_settings */
  int fd;

  device_translate_flags (___INT(flags),
                          &fl,
                          &direction);

  switch (___INT(index))
    {
    case -4:
      {
        ___device_tty *d;

        if ((e = ___device_tty_setup_console
                   (&d,
                    ___global_device_group (),
                    direction))
            != ___FIX(___NO_ERR))
          return e;

        dev = ___CAST(___device_stream*,d);

        break;
      }

    default:
      {
        int stdio_settings =
          ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIO];

        switch (___INT(index))
          {
          case -1:
            fd = STDIN_FILENO;
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIN];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          case -2:
            fd = STDOUT_FILENO;
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDOUT];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          case -3:
            fd = STDERR_FILENO;
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDERR];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          default:
            fd = ___INT(index);
            if (fd >= 0 && fd <= 2)
              {
                io_settings =
                  ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIN+fd];
                io_settings = ___io_settings_merge (io_settings, stdio_settings);
              }
            break;
          }

        if ((e = ___device_stream_setup_from_fd
                   (&dev,
                    ___global_device_group (),
                    fd,
                    ___NONE_KIND,
                    direction,
                    io_settings))
            != ___FIX(___NO_ERR))
          return e;

        break;
      }
    }

#endif

#ifdef USE_WIN32

  DWORD access_mode;
  DWORD share_mode;
  DWORD creation_mode;
  DWORD attributes;
  int direction;
  int io_settings = 0; /* no specific io_settings */
  HANDLE h;

  device_translate_flags (___INT(flags),
                          &access_mode,
                          &share_mode,
                          &creation_mode,
                          &attributes,
                          &direction);

  switch (___INT(index))
    {
    case -4:
    open_console:
      {
        ___device_tty *d;

        if ((e = ___device_tty_setup_console
                   (&d,
                    ___global_device_group (),
                    direction))
            != ___FIX(___NO_ERR))
          return e;

        dev = ___CAST(___device_stream*,d);

        break;
      }

    default:
      {
        int stdio_settings =
          ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIO];

        switch (___INT(index))
          {
          default:
          case -1:
            h = GetStdHandle (STD_INPUT_HANDLE);
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDIN];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          case -2:
            h = GetStdHandle (STD_OUTPUT_HANDLE);
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDOUT];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          case -3:
            h = GetStdHandle (STD_ERROR_HANDLE);
            io_settings =
              ___GSTATE->setup_params.io_settings[___IO_SETTINGS_STDERR];
            io_settings = ___io_settings_merge (io_settings, stdio_settings);
            break;
          }

        if (h == INVALID_HANDLE_VALUE)
          return err_code_from_GetLastError ();

        if (GetFileType (h) == FILE_TYPE_UNKNOWN)
          goto open_console;

        if ((e = ___device_stream_setup_from_handle
                   (&dev,
                    ___global_device_group (),
                    h,
                    0,
                    ___NONE_KIND,
                    direction,
                    io_settings))
            != ___FIX(___NO_ERR))
          return e;

        break;
      }
    }

#endif

  e = ___NONNULLPOINTER_to_SCMOBJ
        (___PSTATE,
         dev,
         ___FAL,
         ___device_cleanup_from_ptr,
         &result,
         ___RETURN_POS);

  if (e != ___FIX(___NO_ERR))
    {
      ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
      return e;
    }

  return ___release_scmobj (result);
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a path. */

___SCMOBJ ___os_device_stream_open_path
   ___P((___SCMOBJ path,
         ___SCMOBJ flags,
         ___SCMOBJ mode),
        (path,
         flags,
         mode)
___SCMOBJ path;
___SCMOBJ flags;
___SCMOBJ mode;)
{
#ifndef ___STREAM_OPEN_PATH_SUPPORTED

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___SCMOBJ result;
  ___device_stream *dev;
  void *cpath;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___STREAM_OPEN_PATH_CE_SELECT),
              0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      ___STRING_TYPE(___STREAM_OPEN_PATH_CE_SELECT) p =
        ___CAST(___STRING_TYPE(___STREAM_OPEN_PATH_CE_SELECT),cpath);

      if ((e = ___device_stream_setup_from_path
                 (&dev,
                  ___global_device_group (),
                  p,
                  ___INT(flags),
                  ___INT(mode)))
          != ___FIX(___NO_ERR))
        result = e;
      else
        {
          if ((e = ___NONNULLPOINTER_to_SCMOBJ
                     (___PSTATE,
                      dev,
                      ___FAL,
                      ___device_cleanup_from_ptr,
                      &result,
                      ___RETURN_POS))
              != ___FIX(___NO_ERR))
            {
              ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
              result = e;
            }
        }

      ___release_string (cpath);
    }

  return ___release_scmobj (result);

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a process. */

___SCMOBJ ___os_device_stream_open_process
   ___P((___SCMOBJ path_and_args,
         ___SCMOBJ environment,
         ___SCMOBJ directory,
         ___SCMOBJ options),
        (path_and_args,
         environment,
         directory,
         options)
___SCMOBJ path_and_args;
___SCMOBJ environment;
___SCMOBJ directory;
___SCMOBJ options;)
{
#ifndef ___STREAM_OPEN_PROCESS_CE_SELECT

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___device_stream *dev;
  ___SCMOBJ result;
  void *argv = NULL;
  void *env = NULL;
  void *dir = NULL;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSA(___PSTATE)
              path_and_args,
              &argv,
              1,
              ___CE(___STREAM_OPEN_PROCESS_CE_SELECT)))
      != ___FIX(___NO_ERR) ||
      (environment != ___FAL &&
       (e = ___SCMOBJ_to_NONNULLSTRINGLIST
              (___PSA(___PSTATE)
               environment,
               &env,
               2,
               ___CE(___ENVIRON_CE_SELECT)))
       != ___FIX(___NO_ERR)) ||
      (directory != ___FAL &&
       (e = ___SCMOBJ_to_NONNULLSTRING
              (___PSA(___PSTATE)
               directory,
               &dir,
               3,
               ___CE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT),
               0))
       != ___FIX(___NO_ERR)) ||
      (e = ___device_stream_setup_from_process
             (&dev,
              ___global_device_group (),
              ___CAST(___STRING_TYPE(___STREAM_OPEN_PROCESS_CE_SELECT)*,argv),
              ___CAST(___STRING_TYPE(___ENVIRON_CE_SELECT)*,env),
              ___CAST(___STRING_TYPE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT),dir),
              ___INT(options)))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if ((e = ___NONNULLPOINTER_to_SCMOBJ
                 (___PSTATE,
                  dev,
                  ___FAL,
                  ___device_cleanup_from_ptr,
                  &result,
                  ___RETURN_POS))
          == ___FIX(___NO_ERR))
        ___release_scmobj (result);
    }

  if (argv != NULL)
    ___release_string_list (argv);

  if (env != NULL)
    ___release_string_list (env);

  if (dir != NULL)
    ___release_string (dir);

  return result;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a TCP client. */

___SCMOBJ ___os_device_tcp_client_open
   ___P((___SCMOBJ local_addr,
         ___SCMOBJ local_port_num,
         ___SCMOBJ addr,
         ___SCMOBJ port_num,
         ___SCMOBJ options,
         ___SCMOBJ tls_context,
         ___SCMOBJ server_name),
        (local_addr,
         local_port_num,
         addr,
         port_num,
         options,
         tls_context,
         server_name)
___SCMOBJ local_addr;
___SCMOBJ local_port_num;
___SCMOBJ addr;
___SCMOBJ port_num;
___SCMOBJ options;
___SCMOBJ tls_context;
___SCMOBJ server_name;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___device_tcp_client *dev;
  ___SCMOBJ result;
  struct sockaddr local_sa;
  SOCKET_LEN_TYPE local_salen;
  struct sockaddr sa;
  SOCKET_LEN_TYPE salen;
  ___tls_context *tls_context_p;
  char *server_name_p;

  if ((e = ___SCMOBJ_to_sockaddr (local_addr,
                                  local_port_num,
                                  &local_sa,
                                  &local_salen,
                                  1))
      != ___FIX(___NO_ERR) ||
      (e = ___SCMOBJ_to_sockaddr (addr,
                                  port_num,
                                  &sa,
                                  &salen,
                                  2))
      != ___FIX(___NO_ERR))
    return e;

#ifdef USE_OPENSSL

  if (tls_context == ___FAL)
    {
      tls_context_p = NULL;
      server_name_p = NULL;
    }
  else
    {
      if ((e = ___SCMOBJ_to_NONNULLPOINTER
           (___PSA(___PSTATE) tls_context,
            ___CAST(void**,&tls_context_p),
            ___FAL,
            7))
          != ___FIX(___NO_ERR))
        return e;

#ifdef SSL_CTRL_SET_TLSEXT_HOSTNAME
      if (___FALSEP (server_name))
        server_name_p = NULL;
      else if ((e = ___SCMOBJ_to_CHARSTRING
                (___PSA(___PSTATE) server_name,
                 &server_name_p,
                 8))
               != ___FIX(___NO_ERR))
        return e;
#else
      server_name_p = NULL;
#endif

    }

#else

  if (tls_context != ___FAL)
    return ___FIX(___UNIMPL_ERR);

  tls_context_p = NULL;
  server_name_p = NULL;

#endif

  e = ___device_tcp_client_setup_from_sockaddr
        (&dev,
         ___global_device_group (),
         &sa,
         salen,
         &local_sa,
         local_salen,
         ___INT(options),
         ___DIRECTION_RD|___DIRECTION_WR,
         tls_context_p,
         server_name_p);

  if (server_name_p != NULL)
    ___release_string (server_name_p);

  if (e != ___FIX(___NO_ERR))
    return e;

  if ((e = ___NONNULLPOINTER_to_SCMOBJ
             (___PSTATE,
              dev,
              ___FAL,
              ___device_cleanup_from_ptr,
              &result,
              ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
      return e;
    }

  return ___release_scmobj (result);

#endif
}


___SCMOBJ ___os_device_tcp_client_socket_info
   ___P((___SCMOBJ dev,
         ___SCMOBJ peer),
        (dev,
         peer)
___SCMOBJ dev;
___SCMOBJ peer;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___device_tcp_client *d =
    ___CAST(___device_tcp_client*,___FIELD(dev,___FOREIGN_PTR));
  struct sockaddr sa;
  SOCKET_LEN_TYPE salen;

  if (d->base.base.read_stage != ___STAGE_OPEN &&
      d->base.base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if (d->try_connect_again != 0)
    {
      if (try_connect (d) == 0)
        {
          if (d->try_connect_again != 0)
            return ___ERR_CODE_EAGAIN;
        }
      else
        return ERR_CODE_FROM_SOCKET_CALL;
    }

  salen = sizeof (sa);

  if (((peer == ___FAL)
       ? getsockname (d->s, &sa, &salen)
       : getpeername (d->s, &sa, &salen)) < 0)
    {
      ___SCMOBJ e = ERR_CODE_FROM_SOCKET_CALL;
      if (NOT_CONNECTED(e) && !d->connect_done)
        e = ___ERR_CODE_EAGAIN;
      return e;
    }

  return ___release_scmobj (___sockaddr_to_SCMOBJ (&sa, salen, ___RETURN_POS));

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening and reading a TCP server. */

___SCMOBJ ___os_device_tcp_server_open
   ___P((___SCMOBJ local_addr,
         ___SCMOBJ local_port_num,
         ___SCMOBJ backlog,
         ___SCMOBJ options,
         ___SCMOBJ tls_context),
        (local_addr,
         local_port_num,
         backlog,
         options,
         tls_context)
___SCMOBJ local_addr;
___SCMOBJ local_port_num;
___SCMOBJ backlog;
___SCMOBJ options;
___SCMOBJ tls_context;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___device_tcp_server *dev = 0;
  ___SCMOBJ result;
  struct sockaddr local_sa;
  SOCKET_LEN_TYPE local_salen;
  ___tls_context *tls_context_p;

  if ((e = ___SCMOBJ_to_sockaddr (local_addr,
                                  local_port_num,
                                  &local_sa,
                                  &local_salen,
                                  1))
      != ___FIX(___NO_ERR))
    return e;

#ifdef USE_OPENSSL

  if (tls_context == ___FAL)
    tls_context_p = NULL;
  else
    {
      if ((e = ___SCMOBJ_to_NONNULLPOINTER
           (___PSA(___PSTATE) tls_context,
            ___CAST(void**,&tls_context_p),
            ___FAL,
            7))
          != ___FIX(___NO_ERR))
        return e;

      if ((tls_context_p->options & ___TLS_OPTION_SERVER_MODE) == 0)
        return ___FIX(___TLS_SERVER_CONTEXT_EXPECTED_ERR);
    }

#else

  if (tls_context != ___FAL)
    return ___FIX(___UNIMPL_ERR);

  tls_context_p = NULL;

#endif

  e = ___device_tcp_server_setup
        (&dev,
         ___global_device_group (),
         &local_sa,
         local_salen,
         ___INT(backlog),
         ___INT(options),
         tls_context_p);

  if (e != ___FIX(___NO_ERR))
    return e;

  e = ___NONNULLPOINTER_to_SCMOBJ
        (___PSTATE,
         dev,
         ___FAL,
         ___device_cleanup_from_ptr,
         &result,
         ___RETURN_POS);

  if (e != ___FIX(___NO_ERR))
    {
      ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
      return e;
    }

  return ___release_scmobj (result);

#endif
}


___SCMOBJ ___os_device_tcp_server_read
   ___P((___SCMOBJ dev_condvar),
        (dev_condvar)
___SCMOBJ dev_condvar;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_tcp_server *d =
    ___CAST(___device_tcp_server*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  ___device_tcp_client *client = 0;
  ___SCMOBJ result;

  if ((e = ___device_tcp_server_read (d, ___global_device_group (), &client))
      != ___FIX(___NO_ERR))
    return e;

  e = ___NONNULLPOINTER_to_SCMOBJ
        (___PSTATE,
         client,
         ___FAL,
         ___device_cleanup_from_ptr,
         &result,
         ___RETURN_POS);

  if (e != ___FIX(___NO_ERR))
    {
      ___device_cleanup (___CAST(___device*,d)); /* ignore error */
      return e;
    }

  return ___release_scmobj (result);

#endif
}


___SCMOBJ ___os_device_tcp_server_socket_info
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___device_tcp_server *d =
    ___CAST(___device_tcp_server*,___FIELD(dev,___FOREIGN_PTR));
  struct sockaddr sa;
  SOCKET_LEN_TYPE salen = sizeof (sa);

  if (d->base.read_stage != ___STAGE_OPEN &&
      d->base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if (getsockname (d->s, &sa, &salen) < 0)
    return ERR_CODE_FROM_SOCKET_CALL;

  return ___release_scmobj (___sockaddr_to_SCMOBJ (&sa, salen, ___RETURN_POS));

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a UDP socket. */

___SCMOBJ ___os_device_udp_open
   ___P((___SCMOBJ local_addr,
         ___SCMOBJ local_port_num,
         ___SCMOBJ options),
        (local_addr,
         local_port_num,
         options)
___SCMOBJ local_addr;
___SCMOBJ local_port_num;
___SCMOBJ options;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___device_udp *dev;
  ___SCMOBJ result;
  struct sockaddr local_sa;
  SOCKET_LEN_TYPE local_salen;

  if ((e = ___SCMOBJ_to_sockaddr (local_addr,
                                  local_port_num,
                                  &local_sa,
                                  &local_salen,
                                  1))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = ___device_udp_setup_from_sockaddr
             (&dev,
              ___global_device_group (),
              &local_sa,
              local_salen,
              ___INT(options),
              ___DIRECTION_RD|___DIRECTION_WR))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = ___NONNULLPOINTER_to_SCMOBJ
             (___PSTATE,
              dev,
              ___FAL,
              ___device_cleanup_from_ptr,
              &result,
              ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
      return e;
    }

  return ___release_scmobj (result);

#endif
}


___SCMOBJ ___os_device_udp_read_subu8vector
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ buffer,
         ___SCMOBJ lo,
         ___SCMOBJ hi),
        (dev_condvar,
         buffer,
         lo,
         hi)
___SCMOBJ dev_condvar;
___SCMOBJ buffer;
___SCMOBJ lo;
___SCMOBJ hi;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

#define MAX_DATAGRAM_LENGTH 65536

  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_udp *d =
    ___CAST(___device_udp*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  ___SSIZE_T n = 0;
  ___SCMOBJ result;

  if (buffer == ___FAL)
    {
      ___U8 buf[MAX_DATAGRAM_LENGTH];

      if ((e = ___device_udp_read_raw
                  (d,
                   buf,
                   MAX_DATAGRAM_LENGTH,
                   &n))
          != ___FIX(___NO_ERR))
        return e;

      result = ___alloc_scmobj (___PSTATE, ___sU8VECTOR, n);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);

      memmove (___BODY_AS(result,___tSUBTYPED),
               buf,
               n);

      ___release_scmobj (result);
    }
  else
    {
      if ((e = ___device_udp_read_raw
                  (d,
                   ___CAST(___U8*,___BODY_AS(buffer,___tSUBTYPED)) + ___INT(lo),
                   ___INT(hi)-___INT(lo),
                   &n))
          != ___FIX(___NO_ERR))
        return e;

      result = ___FIX(n);
    }

  return result;

#endif
}


___SCMOBJ ___os_device_udp_write_subu8vector
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ buffer,
         ___SCMOBJ lo,
         ___SCMOBJ hi),
        (dev_condvar,
         buffer,
         lo,
         hi)
___SCMOBJ dev_condvar;
___SCMOBJ buffer;
___SCMOBJ lo;
___SCMOBJ hi;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_udp *d =
    ___CAST(___device_udp*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  ___SSIZE_T n = 0;
  ___U8 *buf = ___CAST(___U8*,___BODY_AS(buffer,___tSUBTYPED));
  ___SSIZE_T len;

  if (lo == ___FAL)
    len = ___INT(___U8VECTORLENGTH(buffer));
  else
    {
      buf += ___INT(lo);
      len = ___INT(hi)-___INT(lo);
    }

  if ((e = ___device_udp_write_raw (d, buf, len, &n))
      != ___FIX(___NO_ERR))
    return e;

  if (n != len)
    return ___FIX(___UNKNOWN_ERR);

  return ___VOID;

#endif
}


___SCMOBJ ___os_device_udp_socket_info
   ___P((___SCMOBJ dev,
         ___SCMOBJ source),
        (dev,
         source)
___SCMOBJ dev;
___SCMOBJ source;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___device_udp *d =
    ___CAST(___device_udp*,___FIELD(dev,___FOREIGN_PTR));

  if (d->base.read_stage != ___STAGE_OPEN &&
      d->base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if (source == ___FAL)
    {
      struct sockaddr sa;
      SOCKET_LEN_TYPE salen = sizeof (sa);

      if (getsockname (d->s, &sa, &salen) < 0)
        return ERR_CODE_FROM_SOCKET_CALL;

      return ___release_scmobj (___sockaddr_to_SCMOBJ (&sa,
                                                       salen,
                                                       ___RETURN_POS));
    }
  else
    {
      if (d->source_salen == 0) /* no message received yet? */
        return ___FAL;

      if (d->source_same_as_previous) /* last source address same as previously read? */
        return ___TRU;

      d->source_same_as_previous = 1;

      return ___release_scmobj (___sockaddr_to_SCMOBJ (&d->source_sa,
                                                       d->source_salen,
                                                       ___RETURN_POS));
    }

#endif
}


___SCMOBJ ___os_device_udp_destination_set
   ___P((___SCMOBJ dev_condvar,
         ___SCMOBJ addr,
         ___SCMOBJ port_num),
        (dev_condvar,
         addr,
         port_num)
___SCMOBJ dev_condvar;
___SCMOBJ addr;
___SCMOBJ port_num;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_udp *d =
    ___CAST(___device_udp*,___FIELD(dev,___FOREIGN_PTR));

  if (d->base.read_stage != ___STAGE_OPEN &&
      d->base.write_stage != ___STAGE_OPEN)
    return ___FIX(___CLOSED_DEVICE_ERR);

  if ((e = ___SCMOBJ_to_sockaddr (addr,
                                  port_num,
                                  &d->dest_sa,
                                  &d->dest_salen,
                                  1)) /* argument 1 of udp-destination-set! */
      != ___FIX(___NO_ERR))
    return e;

  return ___FIX(___NO_ERR);

#endif
}


___SCMOBJ ___os_device_udp_socket_receive_buffer_size
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___device_udp *d =
    ___CAST(___device_udp*,___FIELD(dev,___FOREIGN_PTR));

  int optVal;
  SOCKET_LEN_TYPE optLen = sizeof(optVal);

  optLen = sizeof(optVal);
  getsockopt(d->s, SOL_SOCKET, SO_RCVBUF, (char*) &optVal, &optLen);

  return ___FIX(optVal);

#endif
}


___SCMOBJ ___os_device_udp_socket_send_buffer_size
   ___P((___SCMOBJ dev),
        (dev)
___SCMOBJ dev;)
{
#ifndef USE_NETWORKING

  return ___FIX(___UNIMPL_ERR);

#else

  ___device_udp *d =
    ___CAST(___device_udp*,___FIELD(dev,___FOREIGN_PTR));

  int optVal;
  SOCKET_LEN_TYPE optLen = sizeof(optVal);

  optLen = sizeof(optVal);
  getsockopt(d->s, SOL_SOCKET, SO_SNDBUF, (char*) &optVal, &optLen);

  return ___FIX(optVal);

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening and reading a directory. */

___SCMOBJ ___os_device_directory_open_path
   ___P((___SCMOBJ path,
         ___SCMOBJ ignore_hidden),
        (path,
         ignore_hidden)
___SCMOBJ path;
___SCMOBJ ignore_hidden;)
{
#ifndef ___DIR_OPEN_PATH_SUPPORTED

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ e;
  ___SCMOBJ result;
  ___device_directory *dev;
  void *cpath;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DIR_OPEN_PATH_CE_SELECT),
              0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      ___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) p =
        ___CAST(___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT),cpath);

      if ((e = ___device_directory_setup
                 (&dev,
                  ___global_device_group (),
                  p,
                  ___INT(ignore_hidden)))
          != ___FIX(___NO_ERR))
        result = e;
      else
        {
          if ((e = ___NONNULLPOINTER_to_SCMOBJ
                     (___PSTATE,
                      dev,
                      ___FAL,
                      ___device_cleanup_from_ptr,
                      &result,
                      ___RETURN_POS))
              != ___FIX(___NO_ERR))
            {
              ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
              result = e;
            }
        }

      ___release_string (cpath);
    }

  return ___release_scmobj (result);

#endif
}


___SCMOBJ ___os_device_directory_read
   ___P((___SCMOBJ dev_condvar),
        (dev_condvar)
___SCMOBJ dev_condvar;)
{
#ifndef ___DIR_OPEN_PATH_SUPPORTED

  return ___FIX(___UNIMPL_ERR);

#else

  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_directory *d =
    ___CAST(___device_directory*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  ___STRING_TYPE(___DIR_OPEN_PATH_CE_SELECT) name;
  ___SCMOBJ result;

  if ((e = ___device_directory_read (d, &name)) != ___FIX(___NO_ERR))
    return e;

  if (name == NULL)
    return ___EOF;

  if ((e = ___STRING_to_SCMOBJ (___PSTATE, name, &result, ___RETURN_POS, ___CE(___DIR_OPEN_PATH_CE_SELECT) ))
      != ___FIX(___NO_ERR))
    return e;

  return ___release_scmobj (result);

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening an event-queue. */

___SCMOBJ ___os_device_event_queue_open
   ___P((___SCMOBJ selector),
        (selector)
___SCMOBJ selector;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___device_event_queue *dev;

  if ((e = ___device_event_queue_setup
             (&dev,
              ___global_device_group (),
              selector))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if ((e = ___NONNULLPOINTER_to_SCMOBJ
                 (___PSTATE,
                  dev,
                  ___FAL,
                  ___device_cleanup_from_ptr,
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___device_cleanup (___CAST(___device*,dev)); /* ignore error */
          result = e;
        }
    }

  return ___release_scmobj (result);
}


___SCMOBJ ___os_device_event_queue_read
   ___P((___SCMOBJ dev_condvar),
        (dev_condvar)
___SCMOBJ dev_condvar;)
{
  ___SCMOBJ dev = ___FIELD(dev_condvar,___CONDVAR_NAME);
  ___device_event_queue *d =
    ___CAST(___device_event_queue*,___FIELD(dev,___FOREIGN_PTR));
  ___SCMOBJ e;
  ___SCMOBJ result;

  if ((e = ___device_event_queue_read (d, &result)) != ___FIX(___NO_ERR))
    return e;

  return ___release_scmobj (result);
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Waiting for I/O to become possible on a set of devices. */

___SCMOBJ ___os_condvar_select
   ___P((___SCMOBJ devices,
         ___SCMOBJ timeout),
        (devices,
         timeout)
___SCMOBJ devices;
___SCMOBJ timeout;)
{
  ___SCMOBJ e;
  ___time to;

  if (timeout == ___FAL)
    to = ___time_mod.time_neg_infinity;
  else if (timeout == ___TRU)
    to = ___time_mod.time_pos_infinity;
  else
    ___time_from_seconds (&to, ___F64VECTORREF(timeout,___FIX(0)));

  if (___FALSEP(devices))
    {
      e = ___device_select (NULL, 0, 0, 0, to);
    }
  else
    {
      ___device *devs[MAX_CONDVARS];
      ___SCMOBJ condvars[MAX_CONDVARS];
      ___SCMOBJ condvar;
      int event_pos = 0;
      int write_pos = 0;
      int read_pos = 0;
      int i;
      int j;

      condvar = ___FIELD(devices,___BTQ_DEQ_NEXT);

      while (condvar != devices)
        {
          ___SCMOBJ owner = ___FIELD(condvar,___BTQ_OWNER);
          if (read_pos < MAX_CONDVARS-1)
            {
              ___FIELD(condvar,___BTQ_OWNER) = owner & ~___FIX(1);
              switch (___INT(owner)>>1)
                {
                case FOR_READING:
                  condvars[read_pos++] = condvar;
                  break;
                case FOR_WRITING:
                  condvars[read_pos++] = condvars[write_pos];
                  condvars[write_pos++] = condvar;
                  break;
                case FOR_EVENT:
                  condvars[read_pos++] = condvars[write_pos];
                  condvars[write_pos++] = condvars[event_pos];
                  condvars[event_pos++] = condvar;
                  break;
                }
            }
          else
            {
              ___FIELD(condvar,___BTQ_OWNER) = owner | ___FIX(1);
              to = ___time_mod.time_neg_infinity;
            }
          condvar = ___FIELD(condvar,___BTQ_DEQ_NEXT);
        }

      for (i=0; i<read_pos; i++)
        {
          devs[i] = ___CAST(___device*,
                            ___FIELD(___FIELD(condvars[i],___CONDVAR_NAME),
                                     ___FOREIGN_PTR));
        }

      ___PRIMITIVEUNLOCK(devices,___FIX(___OBJ_LOCK1),___FIX(___OBJ_LOCK2))

      e = ___device_select (devs,
                            read_pos - write_pos,
                            write_pos - event_pos,
                            event_pos,
                            to);

      ___PRIMITIVELOCK(devices,___FIX(___OBJ_LOCK1),___FIX(___OBJ_LOCK2))

      for (i=0; i<read_pos; i++)
        {
          if (devs[i] == NULL)
            {
              condvar = condvars[i];
              ___FIELD(condvar,___BTQ_OWNER) |= ___FIX(1);
            }
        }
    }

  return e;
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/*
 * Decoding and encoding of a buffer of Scheme characters to a buffer
 * of bytes.
 */

#define ___C ___CS_SELECT(___U8,___U16,___U32)

___SCMOBJ ___os_port_decode_chars
   ___P((___SCMOBJ port,
         ___SCMOBJ want,
         ___SCMOBJ eof),
        (port,
         want,
         eof)
___SCMOBJ port;
___SCMOBJ want;
___SCMOBJ eof;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  ___SCMOBJ cbuf = ___FIELD(port,___PORT_CHAR_RBUF);
  int chi = ___INT(___FIELD(port,___PORT_CHAR_RHI));
  int cend = ___INT(___STRINGLENGTH(cbuf));
  ___SCMOBJ bbuf = ___FIELD(port,___PORT_BYTE_RBUF);
  int blo = ___INT(___FIELD(port,___PORT_BYTE_RLO));
  int bhi = ___INT(___FIELD(port,___PORT_BYTE_RHI));
  int options = ___INT(___FIELD(port,___PORT_ROPTIONS));
  ___C *cbuf_ptr = ___CAST(___C*,___BODY_AS(cbuf,___tSUBTYPED));
  ___U8 *bbuf_ptr = ___CAST(___U8*,___BODY_AS(bbuf,___tSUBTYPED));
  int cbuf_avail;
  int bbuf_avail;
  int code;

  if (want != ___FAL)
    {
      int w = ___INT(want);
      if (chi+w < cend)
        cend = chi+w;
    }

  cbuf_avail = cend - chi;
  bbuf_avail = bhi - blo;

  code = chars_from_bytes (cbuf_ptr + chi,
                           &cbuf_avail,
                           bbuf_ptr + blo,
                           &bbuf_avail,
                           &options);

  /*
   * either the character buffer is full (cbuf_avail == 0) or no more
   * characters can be extracted from the byte buffer either because
   * the remaining bytes are not long enough to form a character or
   * don't form a valid character.
   */

  if (cbuf_avail == cend - chi)
    {
      if (code == ___INCOMPLETE_CHAR && eof != ___FAL)
        {
          bbuf_avail = 0; /* skip bytes up to end-of-file */
          code = ___ILLEGAL_CHAR;
        }

      if (code == ___ILLEGAL_CHAR)
        {
          if (___CHAR_ENCODING_ERRORS(options) != ___CHAR_ENCODING_ERRORS_OFF)
            e = err_code_from_char_encoding (___CHAR_ENCODING(options), 1, 0, 0);
          else
            {
#if ___UNICODE_REPLACEMENT <= ___MAX_CHR
              if (___CHAR_ENCODING_SUPPORTS_BMP(___CHAR_ENCODING(options)))
                cbuf_ptr[chi] = ___UNICODE_REPLACEMENT;
              else
#endif
                cbuf_ptr[chi] = ___UNICODE_QUESTION;

              cbuf_avail--;
            }
        }
    }

  ___FIELD(port,___PORT_CHAR_RHI) = ___FIX(cend - cbuf_avail);
  ___FIELD(port,___PORT_BYTE_RLO) = ___FIX(bhi - bbuf_avail);
  ___FIELD(port,___PORT_ROPTIONS) = ___FIX(options);

  return e;
}


___SCMOBJ ___os_port_encode_chars
   ___P((___SCMOBJ port),
        (port)
___SCMOBJ port;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  ___SCMOBJ cbuf = ___FIELD(port,___PORT_CHAR_WBUF);
  int clo = ___INT(___FIELD(port,___PORT_CHAR_WLO));
  int chi = ___INT(___FIELD(port,___PORT_CHAR_WHI));
  ___SCMOBJ bbuf = ___FIELD(port,___PORT_BYTE_WBUF);
  int bhi = ___INT(___FIELD(port,___PORT_BYTE_WHI));
  int bend = ___INT(___U8VECTORLENGTH(bbuf));
  int options = ___INT(___FIELD(port,___PORT_WOPTIONS));
  ___C *cbuf_ptr = ___CAST(___C*,___BODY_AS(cbuf,___tSUBTYPED));
  ___U8 *bbuf_ptr = ___CAST(___U8*,___BODY_AS(bbuf,___tSUBTYPED));
  int cbuf_avail;
  int bbuf_avail;
  int code;

  cbuf_avail = chi - clo;
  bbuf_avail = bend - bhi;

  code = chars_to_bytes (cbuf_ptr + clo,
                         &cbuf_avail,
                         bbuf_ptr + bhi,
                         &bbuf_avail,
                         &options);

  /*
   * either the character buffer is empty (cbuf_avail == 0) or there
   * is not enough space left in the byte buffer for encoding the next
   * character, or the next character is illegal for the given
   * encoding.
   */

  if (cbuf_avail == chi - clo)
    if (code == ___ILLEGAL_CHAR)
      {
        if (___CHAR_ENCODING_ERRORS(options) != ___CHAR_ENCODING_ERRORS_OFF)
          {
            cbuf_avail--; /* skip illegal char */
            e = err_code_from_char_encoding (___CHAR_ENCODING(options), 0, 0, 0);
          }
        else
          {
            ___C replacement_cbuf[1];
            int replacement_cbuf_avail = 1;

#if ___UNICODE_REPLACEMENT <= ___MAX_CHR
            if (___CHAR_ENCODING_SUPPORTS_BMP(___CHAR_ENCODING(options)))
              replacement_cbuf[0] = ___UNICODE_REPLACEMENT;
            else
#endif
              replacement_cbuf[0] = ___UNICODE_QUESTION;

            code = chars_to_bytes (replacement_cbuf,
                                   &replacement_cbuf_avail,
                                   bbuf_ptr + bend - bbuf_avail,
                                   &bbuf_avail,
                                   &options);

            /*
             * skip over the illegal character if the replacement
             * character was encoded
             */

            cbuf_avail = cbuf_avail - 1 + replacement_cbuf_avail;
          }
      }

  ___FIELD(port,___PORT_CHAR_WLO) = ___FIX(chi - cbuf_avail);
  ___FIELD(port,___PORT_BYTE_WHI) = ___FIX(bend - bbuf_avail);
  ___FIELD(port,___PORT_WOPTIONS) = ___FIX(options);

  return e;
}


/*---------------------------------------------------------------------------*/

/* I/O module initialization/finalization. */


___SCMOBJ ___setup_io_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);

#ifdef USE_POSIX

  if (!___fdset_init (___ps))
    return ___FIX(___HEAP_OVERFLOW_ERR);

#endif

#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

#ifdef USE_POSIX

  if (___open_half_duplex_pipe (&___ps->os.select_abort) < 0 ||
      ___set_fd_blocking_mode (___ps->os.select_abort.writing_fd, 0) < 0 ||
      ___set_fd_blocking_mode (___ps->os.select_abort.reading_fd, 0) < 0)
    e = err_code_from_errno ();

#endif

#ifdef USE_WIN32

  ___ps->os.select_abort =
    CreateEvent (NULL,  /* can't inherit */
                 TRUE,  /* manual reset */
                 FALSE, /* not signaled */
                 NULL); /* no name */

  if (___ps->os.select_abort == NULL)
    e = err_code_from_GetLastError ();

#endif

#endif

  return e;
}


void ___cleanup_io_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef USE_ASYNC_DEVICE_SELECT_ABORT

#ifdef USE_POSIX

  ___close_half_duplex_pipe (&___ps->os.select_abort, 2);

#endif

#ifdef USE_WIN32

  CloseHandle (___ps->os.select_abort); /* ignore error */

#endif

#endif
}


___SCMOBJ ___setup_io_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#ifdef USE_POSIX
  {
    int size = 8 * sizeof (fd_set);
    if (size < MAX_CONDVARS)
      size = MAX_CONDVARS;

    ___vms->os.fdset.size = size;
    ___vms->os.fdset.overflow = 0;
  }
#endif

  return ___FIX(___NO_ERR);
}


void ___cleanup_io_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
}


___HIDDEN ___SCMOBJ io_module_setup ___PVOID
{
  ___SCMOBJ e;

  if ((e = ___device_group_setup (&___io_mod.dgroup)) == ___FIX(___NO_ERR))
    {
      ___setup_child_interrupt_handling (); /* ignore error */

#ifdef USE_WIN32

#define WINSOCK_MAJOR 1
#define WINSOCK_MINOR 1

      {
        WSADATA winsock_data;

        if (!WSAStartup (MAKEWORD(WINSOCK_MAJOR, WINSOCK_MINOR), &winsock_data))
          {
            if (LOBYTE(winsock_data.wVersion) == WINSOCK_MINOR &&
                HIBYTE(winsock_data.wVersion) == WINSOCK_MAJOR)
              return ___FIX(___NO_ERR);
            WSACleanup (); /* ignore error */
          }

        e = ___FIX(___UNKNOWN_ERR);

        ___device_group_cleanup (___io_mod.dgroup);
      }

#endif
    }

  return e;
}


___HIDDEN void io_module_cleanup ___PVOID
{
  ___cleanup_child_interrupt_handling ();

#ifdef USE_WIN32

  WSACleanup (); /* ignore error */

#endif

  ___device_group_cleanup (___io_mod.dgroup);
}



___SCMOBJ ___setup_io_module ___PVOID
{
  if (!___io_mod.setup)
    {
#ifdef USE_WIN32

      ___io_mod.always_signaled =
        CreateEvent (NULL,  /* can't inherit */
                     TRUE,  /* manual reset */
                     TRUE,  /* signaled */
                     NULL); /* no name */

      if (___io_mod.always_signaled == NULL)
        return err_code_from_GetLastError ();

#endif

      io_module_setup ();/*****************************/
      ___io_mod.setup = 1;
      return ___FIX(___NO_ERR);
    }

  return ___FIX(___UNKNOWN_ERR);
}


void ___cleanup_io_module ___PVOID
{
  if (___io_mod.setup)
    {
      io_module_cleanup ();/*****************************/

#ifdef USE_WIN32
      CloseHandle (___io_mod.always_signaled); /* ignore error */
#endif

#ifdef USE_OPENSSL
      ERR_free_strings();
      EVP_cleanup();
      CRYPTO_cleanup_all_ex_data();
#endif

      ___io_mod.setup = 0;
    }
}


/*---------------------------------------------------------------------------*/
