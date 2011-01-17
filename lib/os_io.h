/* File: "os_io.h", Time-stamp: <2011-01-17 13:54:53 feeley> */

/* Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_IO_H
#define ___OS_IO_H

/**********************************/
#include "os_time.h"

/*---------------------------------------------------------------------------*/


typedef struct ___device_group_struct
  {
    struct ___device_struct *list; /* list of devices in this group */
  } ___device_group;


#define ___NONE_KIND              0
#define ___OBJECT_KIND            1
#define ___CHARACTER_KIND         3
#define ___BYTE_KIND              7
#define ___DEVICE_KIND            15
#define ___FILE_DEVICE_KIND       (___DEVICE_KIND+16)
#define ___PIPE_DEVICE_KIND       (___DEVICE_KIND+32)
#define ___PROCESS_DEVICE_KIND    (___PIPE_DEVICE_KIND+65536)
#define ___TTY_DEVICE_KIND        (___DEVICE_KIND+64)
#define ___SERIAL_DEVICE_KIND     (___DEVICE_KIND+128)
#define ___TCP_CLIENT_DEVICE_KIND (___DEVICE_KIND+256)
#define ___TCP_SERVER_DEVICE_KIND (___OBJECT_KIND+512)
#define ___DIRECTORY_KIND         (___OBJECT_KIND+1024)
#define ___EVENT_QUEUE_KIND       (___OBJECT_KIND+2048)
#define ___TIMER_KIND             (___OBJECT_KIND+4096)
#define ___VECTOR_KIND            (___OBJECT_KIND+8192)
#define ___STRING_KIND            (___CHARACTER_KIND+16384)
#define ___U8VECTOR_KIND          (___BYTE_KIND+32768)

#define ___OPEN_STATE(x)      ((x)&(1<<12))
#define ___OPEN_STATE_MASK(x) ((x)&~(1<<12))
#define ___OPEN_STATE_OPEN    (0<<12)
#define ___OPEN_STATE_CLOSED  (1<<12)

#define ___DIRECTION_RD 1
#define ___DIRECTION_WR 2

#define ___STAGE_OPEN     0
#define ___STAGE_CLOSING1 1
#define ___STAGE_CLOSING2 2
#define ___STAGE_CLOSED   3

#define ___SELECT_PASS_CHECK 0
#define ___SELECT_PASS_1     1
#define ___SELECT_PASS_2     2
#define ___SELECT_PASS_3     3

#define ___STREAM_OPTIONS(icee,ice,iee,ib,ocee,oce,oee,ob)      \
(icee+ice+iee+ib)+((ocee+oce+oee+ob)<<15)
#define ___STREAM_OPTIONS_INPUT(options) ((options)&((1<<15)-1))
#define ___STREAM_OPTIONS_OUTPUT(options) (((options)>>15)&((1<<15)-1))


typedef struct ___device_struct
  {
    void *vtbl;

#ifdef USE_PUMPS
    LONG refcount;                 /* device structure is released when zero */
#else
    int refcount;                  /* device structure is released when zero */
#endif

    ___device_group *group;        /* device group this device belongs to */
    struct ___device_struct *prev; /* bidirectional list pointer to previous */
    struct ___device_struct *next; /* bidirectional list pointer to next */
    int direction;                 /* ___DIRECTION_RD and/or ___DIRECTION_WR */
    int close_direction;           /* ___DIRECTION_RD and/or ___DIRECTION_WR */
    int read_stage;                /* ___STAGE_OPEN ... ___STAGE_CLOSED */
    int write_stage;               /* ___STAGE_OPEN ... ___STAGE_CLOSED */
  } ___device;


typedef struct ___device_select_state_struct
  {
    ___device **devs; /* devices to select on */

    ___time timeout; /* absolute timeout of the select */
    ___F64 relative_timeout; /* relative timeout of the select in seconds */
    ___BOOL timeout_reached; /* did select reach the timeout? */

#define MAX_CONDVARS 8192

    int devs_next[MAX_CONDVARS];

#ifdef USE_select
    int highest_fd_plus_1;
    fd_set readfds;
    fd_set writefds;
    fd_set exceptfds;
#endif

#ifdef USE_MsgWaitForMultipleObjects
    DWORD message_queue_mask;
    int message_queue_dev_pos;
    DWORD nb_wait_objs;
    HANDLE wait_objs_buffer[MAXIMUM_WAIT_OBJECTS];
    int wait_obj_to_dev_pos[MAXIMUM_WAIT_OBJECTS];
#endif

#ifdef USE_MACOS
    /*********************/
#endif
  } ___device_select_state;


extern void ___device_select_add_relative_timeout
   ___P((___device_select_state *state,
         int i,
         ___F64 seconds),
        ());

void ___device_select_add_timeout
   ___P((___device_select_state *state,
         int i,
         ___time timeout),
        ());


#ifdef USE_select

extern void ___device_select_add_fd
   ___P((___device_select_state *state,
         int fd,
         ___BOOL for_writing),
        ());

#endif


#ifdef USE_MsgWaitForMultipleObjects

extern void ___device_select_add_wait_obj
   ___P((___device_select_state *state,
         int i,
         HANDLE wait_obj),
        ());

#endif


typedef struct ___device_vtbl_struct
  {
#define ___device_kind(self) \
___CAST(___device_vtbl*,(self)->vtbl)->kind(self)

    int (*kind) ___P((___device *self),());

#define ___device_select_virt(self,for_writing,i,pass,state) \
___CAST(___device_vtbl*,(self)->vtbl)->select_virt(self,for_writing,i,pass,state)

    ___SCMOBJ (*select_virt)
       ___P((___device *self,
             ___BOOL for_writing,
             int i,
             int pass,
             ___device_select_state *state),
            ());

#define ___device_release_virt(self) \
___CAST(___device_vtbl*,(self)->vtbl)->release_virt(self)

    ___SCMOBJ (*release_virt)
       ___P((___device *self),
            ());

#define ___device_force_output_virt(self,level) \
___CAST(___device_vtbl*,(self)->vtbl)->force_output_virt(self,level)

    ___SCMOBJ (*force_output_virt)
       ___P((___device *self,
             int level),
            ());

#define ___device_close_virt(self,direction) \
___CAST(___device_vtbl*,(self)->vtbl)->close_virt(self,direction)

    ___SCMOBJ (*close_virt)
       ___P((___device *self,
             int direction),
            ());
  } ___device_vtbl;


/*---------------------------------------------------------------------------*/


typedef struct ___io_module_struct
  {
    ___BOOL setup;

    ___device_group *dgroup;

#ifdef USE_POSIX

#define ___IO_MODULE_INIT

#endif

#ifdef USE_WIN32

    HANDLE always_signaled;  /* this event is always signaled */
    HANDLE abort_select;     /* ___device_select exits when this is signaled */

#define ___IO_MODULE_INIT , 0, 0

#endif
  } ___io_module;


extern ___io_module ___io_mod;


/*---------------------------------------------------------------------------*/

/* Device groups. */


extern ___SCMOBJ ___device_group_setup
   ___P((___device_group **dgroup),
        ());

extern void ___device_group_cleanup
   ___P((___device_group *dgroup),
        ());

extern void ___device_add_to_group
   ___P((___device_group *dgroup,
         ___device *dev),
        ());

extern void ___device_remove_from_group
   ___P((___device *dev),
        ());

extern ___device_group *___global_device_group ___PVOID;


/*---------------------------------------------------------------------------*/

typedef int ___stream_index;

/* Nonblocking pipes */

#ifdef USE_PUMPS

/*
 * A pipe is a unidirectional FIFO data structure that buffers data
 * between a "writer" that writes data to the pipe and a "reader" that
 * reads this data.  Independently from the FIFO buffer, a pipe has a
 * "reader error indicator" and a "writer error indicator".  When
 * created the error indicators are set to "no error" and the FIFO
 * contains no data.
 *
 * Typically the writer writes bytes and out-of-band messages at one
 * end with a "write" operation and the reader reads these bytes and
 * out-of-band messages in the same order at the other end with a
 * "read" operation.  Out-of-band messages are used to request some
 * special action from the reader and are expected to be infrequent.
 * When a read operation extracts an out-of-band message from the pipe
 * it reports that zero bytes can be read from the pipe and sets the
 * out-of-band structure (one of the parameters of the read
 * operation).  The writer can set the "writer error indicator" when
 * it needs to transmit an error code to the reader.  After all
 * previously written bytes and out-of-band messages are read by the
 * reader, the next read operation will return this error code and the
 * error indicator is reset to "no error".  Similarly, the reader can
 * set the "reader error indicator" when it needs to transmit an error
 * code to the writer.  The next write operation will return this
 * error code and the error indicator is reset to "no error".
 *
 * The nonblocking pipes implemented here have read and write
 * operations that don't block the calling thread.  When the data
 * transfer requested can't be performed immediately these operations
 * will return with a special error code (EAGAIN).  This allows the
 * calling thread to do other things before attempting the operation
 * again.  We say a pipe is "ready for an operation" if calling that
 * operation will not return EAGAIN (i.e. the operations will succeed
 * with no error or will fail with some error different from EAGAIN).
 *
 * Specifically,
 *
 *   a pipe is ready for reading when
 *     - the "writer error indicator" is not "no error"
 *     - or
 *       - the "reader error indicator" is "no error"
 *       - and
 *         - an out-of-band message is in the pipe
 *         - or at least one byte is in the FIFO buffer
 *
 *   a pipe is ready for writing when
 *     - the "reader error indicator" is not "no error"
 *     - or
 *       - the "writer error indicator" is "no error"
 *       - and no out-of-band message is in the pipe
 *       - and at least one byte is free in the FIFO buffer
 *       - and the previous read operation did not return an error or
 *         an out-of-band message
 *         (at creation a pipe is not ready for writing and the first
 *         "read" operation will make the pipe ready for writing, in other
 *         words, after it reports an error or out-of-band message, the
 *         writer blocks until the reader shows some interest in more data)
 *
 * This table summarizes the states of a pipe (an R means ready for
 * reading and a W means ready for writing and a w means ready for
 * writing iff the most recent read operation did not return an
 * error or out-of-band message):
 *
 *        no writer :  writer     reader      bytes in FIFO buffer
 *          error   :  error      error?      (N is size of buffer)
 *        +----+----+----+----+
 *        |  w | R  | R  | R  |     no           0 bytes
 *        +----+----+----+----+
 *        | Rw | R  | R  | R  |     no           > 0 bytes but < N
 *        +----+----+----+----+
 *        | R  | R  | R  | R  |     no           = N
 *        +----+----+----+----+
 *        |  W |  W | RW | RW |     yes          0 bytes
 *        +----+----+----+----+
 *        |  W |  W | RW | RW |     yes          > 0 bytes but < N
 *        +----+----+----+----+
 *        |  W |  W | RW | RW |     yes          = N
 *        +----+----+----+----+
 *        :!oob:oob :!oob:oob :
 *
 */

typedef struct ___nonblocking_pipe_oob_msg_struct
  {
    int op; /* operation */
    ___stream_index stream_index_param; /* parameters */
  } ___nonblocking_pipe_oob_msg;

typedef struct ___nonblocking_pipe_struct
  {
    HANDLE mutex;     /* mutex to serialize access to the pipe */
    HANDLE revent;    /* event, signaled iff ready for reading */
    HANDLE wevent;    /* event, signaled iff ready for writing */
    ___SCMOBJ rerr;   /* the reader error indicator */
    ___SCMOBJ werr;   /* the writer error indicator */
    ___BOOL oob;      /* the out-of-band indicator */
    ___nonblocking_pipe_oob_msg oob_msg; /* out-of-band message */
    DWORD rd;         /* the read pointer of the circular buffer */
    DWORD wr;         /* the write pointer of the circular buffer */
    DWORD size;       /* size of the circular buffer */
    ___U8 *buffer;    /* the circular buffer */
  } ___nonblocking_pipe;

#define OOB_EOS           0
#define OOB_SEEK_TELL     1
#define OOB_SEEK_ABS      2
#define OOB_SEEK_REL      3
#define OOB_SEEK_REL_END  4
#define OOB_FORCE_OUTPUT0 5
#define OOB_FORCE_OUTPUT1 6
#define OOB_FORCE_OUTPUT2 7
#define OOB_FORCE_OUTPUT3 8

typedef struct ___device_stream_pump_struct
  {
    HANDLE thread;
    ___nonblocking_pipe pipe;
  } ___device_stream_pump;

#define PIPE_BUFFER_SIZE 16384

/*
 * It is important that the PUMP_PRIORITY be above that of the main
 * program (which is THREAD_PRIORITY_NORMAL) so that I/O operations,
 * such as flushing output buffers, will be done as soon as the pump
 * reads it from the nonblocking pipe.  Thus the operation will appear
 * to be synchronous to the main program.
 */

#define PUMP_PRIORITY THREAD_PRIORITY_ABOVE_NORMAL

#endif


/*---------------------------------------------------------------------------*/

/* Miscellaneous utility functions. */

#ifdef USE_POSIX

extern pid_t waitpid_no_EINTR
   ___P((pid_t pid,
         int *stat_loc,
         int options),
        ());

extern ssize_t read_no_EINTR
   ___P((int fd,
         void *buf,
         size_t len),
        ());

extern int close_no_EINTR
   ___P((int fd),
        ());

extern int dup_no_EINTR
   ___P((int fd),
        ());

extern int dup2_no_EINTR
   ___P((int fd,
         int fd2),
        ());

extern int set_fd_blocking_mode
   ___P((int fd,
         ___BOOL blocking),
        ());

#endif


/*---------------------------------------------------------------------------*/

/* Devices. */


/* Timer device. */

typedef struct ___device_timer_struct
  {
    ___device base;
    ___time expiry;
  } ___device_timer;

typedef struct ___device_timer_vtbl_struct
  {
    ___device_vtbl base;
  } ___device_timer_vtbl;

extern ___SCMOBJ ___device_timer_setup
   ___P((___device_timer **dev,
         ___device_group *dgroup),
        ());

extern void ___device_timer_set_expiry
   ___P((___device_timer *dev,
         ___time expiry),
        ());

/* Byte stream device. */

typedef struct ___device_stream_struct
  {
    ___device base;

#ifdef USE_PUMPS
    ___device_stream_pump *read_pump;
    ___device_stream_pump *write_pump;
#endif
  } ___device_stream;

typedef struct ___device_stream_vtbl_struct
  {
    ___device_vtbl base;

#define ___device_stream_select_raw_virt(self,for_writing,i,pass,state) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->select_raw_virt(self,for_writing,i,pass,state)

    ___SCMOBJ (*select_raw_virt)
       ___P((___device_stream *self,
             ___BOOL for_writing,
             int i,
             int pass,
             ___device_select_state *state),
            ());

#define ___device_stream_release_raw_virt(self) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->release_raw_virt(self)

    ___SCMOBJ (*release_raw_virt)
       ___P((___device_stream *self),
            ());

#define ___device_stream_force_output_raw_virt(self,level) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->force_output_raw_virt(self,level)

    ___SCMOBJ (*force_output_raw_virt)
       ___P((___device_stream *self,
             int level),
            ());

#define ___device_stream_close_raw_virt(self,direction) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->close_raw_virt(self,direction)

    ___SCMOBJ (*close_raw_virt)
       ___P((___device_stream *self,
             int direction),
            ());

#define ___device_stream_seek_raw_virt(self,pos,whence) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->seek_raw_virt(self,pos,whence)

    ___SCMOBJ (*seek_raw_virt)
       ___P((___device_stream *self,
             ___stream_index *pos,
             int whence),
            ());

#define ___device_stream_read_raw_virt(self,buf,len,len_done) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->read_raw_virt(self,buf,len,len_done)

    ___SCMOBJ (*read_raw_virt)
       ___P((___device_stream *self,
             ___U8 *buf,
             ___stream_index len,
             ___stream_index *len_done),
            ());

#define ___device_stream_write_raw_virt(self,buf,len,len_done) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->write_raw_virt(self,buf,len,len_done)

    ___SCMOBJ (*write_raw_virt)
       ___P((___device_stream *self,
             ___U8 *buf,
             ___stream_index len,
             ___stream_index *len_done),
            ());

#define ___device_stream_width(self) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->width(self)

    ___SCMOBJ (*width)
       ___P((___device_stream *self),
            ());

#define ___device_stream_default_options(self) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->default_options(self)

    ___SCMOBJ (*default_options)
       ___P((___device_stream *self),
            ());

#define ___device_stream_options_set(self,options) \
___CAST(___device_stream_vtbl*,(self)->base.vtbl)->options_set(self,options)

    ___SCMOBJ (*options_set)
       ___P((___device_stream *self,
             ___SCMOBJ options),
            ());
  } ___device_stream_vtbl;

extern ___SCMOBJ ___device_stream_select_virt
   ___P((___device *self,
         ___BOOL for_writing,
         int i,
         int pass,
         ___device_select_state *state),
        ());

extern ___SCMOBJ ___device_stream_release_virt
   ___P((___device *self),
        ());

extern ___SCMOBJ ___device_stream_force_output_virt
   ___P((___device *self,
         int level),
        ());

extern ___SCMOBJ ___device_stream_close_virt
   ___P((___device *self,
         int direction),
        ());

extern ___SCMOBJ ___device_stream_seek
   ___P((___device_stream *self,
         ___stream_index *pos,
         int whence),
        ());

extern ___SCMOBJ ___device_stream_read
   ___P((___device_stream *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        ());

extern ___SCMOBJ ___device_stream_write
   ___P((___device_stream *self,
         ___U8 *buf,
         ___stream_index len,
         ___stream_index *len_done),
        ());

extern ___SCMOBJ ___device_stream_setup
   ___P((___device_stream *dev,
         ___device_group *dgroup,
         int direction,
         int pumps_on),
        ());


#if 0
/* Tty stream device. */

typedef struct ___device_tty_struct
  {
    ___device_stream base;
    tty t;
  } ___device_tty;

typedef struct ___device_tty_vtbl_struct
  {
    ___device_stream_vtbl base;
  } ___device_tty_vtbl;

extern ___SCMOBJ ___device_tty_open
   ___P((___device_tty **dev,
         ___device_group *dgroup,
         int fd,
         int direction),
        ());
#endif








extern ___SCMOBJ ___device_select
   ___P((___device **devs,
         int nb_read_devs,
         int nb_write_devs,
         ___time timeout),
        ());

extern ___SCMOBJ ___device_force_output
   ___P((___device *self,
         int level),
        ());

extern ___SCMOBJ ___device_close
   ___P((___device *self,
         int direction),
        ());

extern ___SCMOBJ ___device_cleanup
   ___P((___device *self),
        ());

extern ___SCMOBJ ___device_cleanup_from_ptr
   ___P((void *ptr),
        ());


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Device operations. */

extern ___SCMOBJ ___os_device_kind
   ___P((___SCMOBJ dev),
        ());

extern ___SCMOBJ ___os_device_force_output
   ___P((___SCMOBJ dev,
         ___SCMOBJ level),
        ());

extern ___SCMOBJ ___os_device_close
   ___P((___SCMOBJ dev,
         ___SCMOBJ direction),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Stream device operations. */

extern ___SCMOBJ ___os_device_stream_seek
   ___P((___SCMOBJ dev,
         ___SCMOBJ pos,
         ___SCMOBJ whence),
        ());

extern ___SCMOBJ ___os_device_stream_read
   ___P((___SCMOBJ dev,
         ___SCMOBJ buffer,
         ___SCMOBJ lo,
         ___SCMOBJ hi),
        ());

extern ___SCMOBJ ___os_device_stream_write
   ___P((___SCMOBJ dev,
         ___SCMOBJ buffer,
         ___SCMOBJ lo,
         ___SCMOBJ hi),
        ());

extern ___SCMOBJ ___os_device_stream_width
   ___P((___SCMOBJ dev),
        ());

extern ___SCMOBJ ___os_device_stream_default_options
   ___P((___SCMOBJ dev),
        ());

extern ___SCMOBJ ___os_device_stream_options_set
   ___P((___SCMOBJ dev,
         ___SCMOBJ options),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a predefined device (stdin, stdout, stderr, console, etc). */

extern ___SCMOBJ ___os_device_stream_open_predefined
   ___P((___SCMOBJ index,
         ___SCMOBJ flags),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a path. */

extern ___SCMOBJ ___os_device_stream_open_path
   ___P((___SCMOBJ path,
         ___SCMOBJ flags,
         ___SCMOBJ mode),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a process. */

extern ___SCMOBJ ___os_device_stream_open_process
   ___P((___SCMOBJ path_and_args,
         ___SCMOBJ environment,
         ___SCMOBJ directory,
         ___SCMOBJ options),
        ());

extern ___SCMOBJ ___os_device_process_pid
   ___P((___SCMOBJ dev),
        ());

extern ___SCMOBJ ___os_device_process_status
   ___P((___SCMOBJ dev),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening a TCP client. */

extern ___SCMOBJ ___os_device_tcp_client_open
   ___P((___SCMOBJ server_addr,
         ___SCMOBJ port_num,
         ___SCMOBJ options),
        ());

extern ___SCMOBJ ___os_device_tcp_client_socket_info
   ___P((___SCMOBJ dev,
         ___SCMOBJ peer),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening and reading a TCP server. */

extern ___SCMOBJ ___os_device_tcp_server_open
   ___P((___SCMOBJ server_addr,
         ___SCMOBJ port_num,
         ___SCMOBJ backlog,
         ___SCMOBJ options),
        ());

extern ___SCMOBJ ___os_device_tcp_server_read
   ___P((___SCMOBJ dev),
        ());

extern ___SCMOBJ ___os_device_tcp_server_socket_info
   ___P((___SCMOBJ dev),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening and reading a directory. */

extern ___SCMOBJ ___os_device_directory_open_path
   ___P((___SCMOBJ path,
         ___SCMOBJ ignore_hidden),
        ());

extern ___SCMOBJ ___os_device_directory_read
   ___P((___SCMOBJ dev),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Opening an event-queue. */

extern ___SCMOBJ ___os_device_event_queue_open
   ___P((___SCMOBJ index),
        ());

extern ___SCMOBJ ___os_device_event_queue_read
   ___P((___SCMOBJ dev),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Waiting for I/O to become possible on a set of devices. */

extern ___SCMOBJ ___os_condvar_select
   ___P((___SCMOBJ run_queue,
         ___SCMOBJ timeout),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/*
 * Decoding and encoding of a buffer of Scheme characters to a buffer
 * of bytes.
 */

extern ___SCMOBJ ___os_port_decode_chars
   ___P((___SCMOBJ port,
         ___SCMOBJ want,
         ___SCMOBJ eof),
        ());

extern ___SCMOBJ ___os_port_encode_chars
   ___P((___SCMOBJ port),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to file information. */

extern ___SCMOBJ ___os_file_info
   ___P((___SCMOBJ path,
         ___SCMOBJ chase),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to user information. */

extern ___SCMOBJ ___os_user_info
   ___P((___SCMOBJ user),
        ());

extern ___SCMOBJ ___os_user_name ___PVOID;

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to group information. */

extern ___SCMOBJ ___os_group_info
   ___P((___SCMOBJ group),
        ());

/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to host information. */

extern ___SCMOBJ ___os_address_infos
   ___P((___SCMOBJ host,
         ___SCMOBJ serv,
         ___SCMOBJ flags,
         ___SCMOBJ family,
         ___SCMOBJ socktype,
         ___SCMOBJ protocol),
        ());

extern ___SCMOBJ ___os_host_info
   ___P((___SCMOBJ host),
        ());

extern ___SCMOBJ ___os_host_name ___PVOID;

#ifdef USE_NETWORKING

extern ___SCMOBJ ___SCMOBJ_to_in_addr
   ___P((___SCMOBJ addr,
         struct in_addr *ia,
         int arg_num),
        ());

extern ___SCMOBJ ___in_addr_to_SCMOBJ
   ___P((struct in_addr *ia,
         int arg_num),
        ());

#ifdef USE_IPV6

extern ___SCMOBJ ___SCMOBJ_to_in6_addr
   ___P((___SCMOBJ addr,
         struct in6_addr *ia,
         int arg_num),
        ());

extern ___SCMOBJ ___in6_addr_to_SCMOBJ
   ___P((struct in6_addr *ia,
         int arg_num),
        ());

#endif

extern ___SCMOBJ ___SCMOBJ_to_sockaddr
   ___P((___SCMOBJ addr,
         ___SCMOBJ port_num,
         struct sockaddr *sa,
         int *salen,
         int arg_num),
        ());

extern ___SCMOBJ ___sockaddr_to_SCMOBJ
   ___P((struct sockaddr *sa,
         int salen,
         int arg_num),
        ());

extern ___SCMOBJ ___addr_to_SCMOBJ
   ___P((void *sa,
         int salen,
         int arg_num),
        ());

#endif


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to service information. */

extern ___SCMOBJ ___os_service_info
   ___P((___SCMOBJ service,
         ___SCMOBJ protocol),
        ());


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to protocol information. */

extern ___SCMOBJ ___os_protocol_info
   ___P((___SCMOBJ protocol),
        ());


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to network information. */

extern ___SCMOBJ ___os_network_info
   ___P((___SCMOBJ network),
        ());


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to process information. */

extern ___SCMOBJ ___os_getpid ___PVOID;
extern ___SCMOBJ ___os_getppid ___PVOID;


/*---------------------------------------------------------------------------*/

/* I/O module initialization/finalization. */


extern ___SCMOBJ ___setup_io_module ___PVOID;

extern void ___cleanup_io_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
