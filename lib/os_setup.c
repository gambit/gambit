/* File: "os_setup.c" */

/* Copyright (c) 1994-2026 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * including:
 *
 *  - OS specific initialization/finalization
 *  - process termination
 *  - error handling
 *  - conversion of error codes to error messages
 *  - low-level memory allocation
 *  - program startup
 *  - time management
 *  - process times (user time, system time and real time).
 *  - heartbeat interrupt handling
 *  - user interrupt handling
 *  - access to OS environment variables
 *  - shell command
 *  - dynamic loading
 *  - dynamic C compilation
 *  - floating point environment setup
 *  - CPU count
 *  - CPU cache size
 *  - virtual memory statistics
 *  - filesystem path expansion
 *  - formatting of source code position
 *  - operations on I/O devices
 */

#define ___INCLUDED_FROM_OS_SETUP
#define ___VERSION 409007
#include "gambit.h"

#include "os_setup.h"
#include "os_thread.h"
#include "os_base.h"
#include "os_time.h"
#include "os_shell.h"
#include "os_files.h"
#include "os_dyn.h"
#include "os_tty.h"
#include "os_io.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"


/*---------------------------------------------------------------------------*/

#define NBELEMS(table)(sizeof (table) / sizeof (table[0]))

/*---------------------------------------------------------------------------*/

/* Miscellaneous POSIX utility functions. */

#ifdef USE_POSIX


/*
 * Some system calls can be interrupted by a signal and fail with
 * errno == EINTR.  The following functions are wrappers for system
 * calls which may be interrupted.  They simply ignore the EINTR and
 * retry the operation.
 *
 * TODO: add wrappers for all the system calls which can fail
 * with EINTR.
 */

pid_t ___waitpid_no_EINTR
   ___P((pid_t pid,
         int *stat_loc,
         int options),
        (pid,
         stat_loc,
         options)
pid_t pid;
int *stat_loc;
int options;)
{
  pid_t result;

  for (;;)
    {
      result = waitpid (pid, stat_loc, options);
      if (result >= 0 || errno != EINTR)
        break;
    }

#ifdef ___DEBUG_LOG
  ___printf ("___waitpid_no_EINTR(%d, %p, %d) => %d\n", pid, stat_loc, options, result);
#endif

  return result;
}


___SSIZE_T ___read_no_EINTR
   ___P((int fd,
         void *buf,
         ___SIZE_T len),
        (fd,
         buf,
         len)
int fd;
void *buf;
___SIZE_T len;)
{
  char *p = ___CAST(char*,buf);
  ___SSIZE_T result = 0;
  int n;

  while (result < len)
    {
      n = read (fd, p+result, len-result);
      if (n > 0)
        result += n;
      else if (n == 0)
        break;
      else if (errno != EINTR)
        {
          result = n; /* this forgets that some bytes were transferred */
          break;
        }
    }

#ifdef ___DEBUG_LOG
  ___printf ("___read_no_EINTR(%d, %p, %d) => %d\n", fd, buf, len, result);
#endif

  return result;
}


#ifdef USE_open

int ___open_no_EINTR
   ___P((char *path,
         int flags,
         mode_t mode),
        (path,
         flags,
         mode)
char *path;
int flags;
mode_t mode;)
{
  int result;

  for (;;)
    {
      result = open (path, flags, mode);
      if (result >= 0 || errno != EINTR)
        break;
    }

#ifdef ___DEBUG_LOG
  ___printf ("___open_no_EINTR(\"%s\", %d, %d) => %d\n", path, flags, mode, result);
#endif

  return result;
}

#endif


#ifdef USE_openat

int ___openat_no_EINTR
   ___P((int fd,
         char *path,
         int flags,
         mode_t mode),
        (fd,
         path,
         flags,
         mode)
int fd;
char *path;
int flags;
mode_t mode;)
{
  int result;

  for (;;)
    {
      result = openat (fd, path, flags, mode);
      if (result >= 0 || errno != EINTR)
        break;
    }

#ifdef ___DEBUG_LOG
  ___printf ("___openat_no_EINTR(%d, \"%s\", %d, %d) => %d\n", fd, path, flags, mode, result);
#endif

  return result;
}

#endif


int ___close_no_EINTR
   ___P((int fd),
        (fd)
int fd;)
{
  int result;

  for (;;)
    {
      result = close (fd);
      if (result >= 0 || errno != EINTR)
        break;
    }

#ifdef ___DEBUG_LOG
  ___printf ("___close_no_EINTR(%d) => %d\n", fd, result);
#endif

  return result;
}


int ___closefrom
   ___P((int start_fd),
        (start_fd)
int start_fd;)
{
#ifdef ___DEBUG_LOG
  ___printf ("___closefrom(%d)\n", start_fd);
#endif

#if defined(USE_closefrom)

  closefrom (start_fd);
  return 0;

#elif defined(USE_SYS_close_range)

  return syscall (SYS_close_range, start_fd, ~0U, 0);

#elif defined(USE_fcntl) && defined(F_CLOSEM)

  return fcntl (start_fd, F_CLOSEM, start_fd);

#else

  int max_fds;
  int fd;

#if defined(USE_sysconf)

  max_fds = sysconf (_SC_OPEN_MAX);

#elif defined(USE_getrlimit) && defined(RLIMIT_NOFILE)

  {
    struct rlimit rl;
    getrlimit (RLIMIT_NOFILE, &rl);
    max_fds = rl.rlim_cur;
  }

#elif defined(OPEN_MAX)

  max_fds = OPEN_MAX;

#else

  max_fds = 1024;

#endif

  for (fd=start_fd; fd<max_fds; fd++)
    {
      ___close_no_EINTR (fd);
    }

  return 0;

#endif
}


int ___dup_no_EINTR
   ___P((int fd),
        (fd)
int fd;)
{
  int result;

  for (;;)
    {
      result = dup (fd);
      if (result >= 0 || errno != EINTR)
        break;
    }

#ifdef ___DEBUG_LOG
  ___printf ("___dup_no_EINTR(%d) => %d\n", fd, result);
#endif

  return result;
}


int ___dup2_no_EINTR
   ___P((int fd,
         int fd2),
        (fd,
         fd2)
int fd;
int fd2;)
{
  int result;

  for (;;)
    {
      result = dup2 (fd, fd2);
      if (result >= 0 || errno != EINTR)
        break;
    }

#ifdef ___DEBUG_LOG
  ___printf ("___dup2_no_EINTR(%d, %d) => %d\n", fd, fd2, result);
#endif

  return result;
}


int ___move_fds_to_non_std
   ___P((int *fds,
         int nb_fds,
         ___BOOL close_on_error),
        (fds,
         nb_fds,
         close_on_error)
int *fds;
int nb_fds;
___BOOL close_on_error;)
{
  int fds_to_close[3];
  int to_close = 0;
  int save_errno = 0;
  int i;

  for (i=0; i<nb_fds; i++)
    {
      int initial_fd = fds[i];
      int fd = initial_fd;

      while (fd == STDIN_FILENO || fd == STDOUT_FILENO || fd == STDERR_FILENO)
        {
          int save_fd = fd;
          if (save_fd != initial_fd) fds_to_close[to_close++] = save_fd;
          fd = ___dup_no_EINTR (save_fd);
          if (fd < 0)
            {
              save_errno = errno;
              if (close_on_error) {
                ___close_no_EINTR (initial_fd); /* ignore error */
                for (i=0; i<nb_fds; i++)
                  ___close_no_EINTR (fds[i]); /* ignore error */
              }
              goto done;
            }
          fds[i] = fd;
        }

      if (fd != initial_fd) fds_to_close[to_close++] = initial_fd;
    }

 done:;

  while (to_close-- > 0) {
    ___close_no_EINTR (fds_to_close[to_close]); /* ignore error */
  }

  if (save_errno == 0)
    return 0;
  else
    {
      errno = save_errno;
      return -1;
    }
}


int ___set_fd_blocking_mode
   ___P((int fd,
         ___BOOL blocking),
        (fd,
         blocking)
int fd;
___BOOL blocking;)
{
  int fl;

#ifdef USE_fcntl

  if ((fl = fcntl (fd, F_GETFL, 0)) >= 0)
    fl = fcntl (fd,
                F_SETFL,
                blocking ? (fl & ~O_NONBLOCK) : (fl | O_NONBLOCK));

#else

  fl = 0;

#endif

#ifdef ___DEBUG_LOG
  ___printf ("___set_fd_blocking_mode(%d, %d) => %d\n", fd, blocking, fl);
#endif

  return fl;
}


#define USE_pipe


___SCMOBJ ___open_half_duplex_pipe
   ___P((___half_duplex_pipe *hdp,
         ___BOOL avoid_std),
        (hdp,
         avoid_std)
___half_duplex_pipe *hdp;
___BOOL avoid_std;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  int fds[2];

#ifdef USE_pipe
  if (pipe (fds) < 0)
    return err_code_from_errno ();
#endif

#ifdef USE_socketpair
  if (socketpair (AF_UNIX, SOCK_STREAM, 0, fds) < 0)
    return err_code_from_errno ();
#endif

  if (avoid_std) {
    if (___move_fds_to_non_std (fds, 2, 1) < 0)
      e = err_code_from_errno ();
  }

  if (e == ___FIX(___NO_ERR))
    {
      hdp->reading_fd = fds[0];
      hdp->writing_fd = fds[1];
    }
  else
    {
      ___close_half_duplex_pipe(hdp, 2);
    }

#ifdef ___DEBUG_LOG
  ___printf ("___open_half_duplex_pipe(fds) => fds[0]=%d fds[1]=%d\n", fds[0], fds[1]);
#endif

  return e;
}


void ___close_half_duplex_pipe
   ___P((___half_duplex_pipe *hdp,
         int end),
        (hdp,
         end)
___half_duplex_pipe *hdp;
int end;)
{
  if (end != 1 && hdp->reading_fd >= 0)
    {
      ___close_no_EINTR (hdp->reading_fd); /* ignore error */
      hdp->reading_fd = -1;
    }

  if (end != 0 && hdp->writing_fd >= 0)
    {
      ___close_no_EINTR (hdp->writing_fd); /* ignore error */
      hdp->writing_fd = -1;
    }
}


#endif


#ifdef USE_opendir

DIR *___opendir_no_EINTR
   ___P((char *path),
        (path)
char *path;)
{
  DIR *result;

  for (;;)
    {
      result = opendir (path);
      if (result != NULL || errno != EINTR)
        break;
    }

  return result;
}

#endif


/*---------------------------------------------------------------------------*/


void ___cleanup_all_interrupt_handling ___PVOID
{
  ___cleanup_user_interrupt_handling ();
  ___cleanup_heartbeat_interrupt_handling ();
  ___cleanup_child_interrupt_handling ();
}


___EXP_FUNC(void,___mask_all_interrupts_begin)
   ___P((___mask_all_interrupts_state *state),
        (state)
___mask_all_interrupts_state *state;)
{
  ___mask_user_interrupts_begin (state);
  ___mask_heartbeat_interrupts_begin (state);
  ___mask_child_interrupts_begin (state);
}


___EXP_FUNC(void,___mask_all_interrupts_end)
   ___P((___mask_all_interrupts_state *state),
        (state)
___mask_all_interrupts_state *state;)
{
  ___mask_child_interrupts_end (state);
  ___mask_heartbeat_interrupts_end (state);
  ___mask_user_interrupts_end (state);
}


/*---------------------------------------------------------------------------*/

/* Virtual memory statistics. */

void ___vm_stats
   ___P((___SIZE_TS *minflt,
         ___SIZE_TS *majflt),
        (minflt,
         majflt)
___SIZE_TS *minflt;
___SIZE_TS *majflt;)
{
#ifndef USE_getrusage

  *minflt = 0; /* can't get statistics... result is 0 */
  *majflt = 0;

#endif

#ifdef USE_getrusage

  struct rusage ru;

  if (getrusage (RUSAGE_SELF, &ru) == 0)
    {
      *minflt = ru.ru_minflt;
      *majflt = ru.ru_majflt;
    }
  else
    {
      *minflt = 0; /* can't get statistics... result is 0 */
      *majflt = 0;
    }

#endif
}


/*---------------------------------------------------------------------------*/

/* Formatting of source code position. */

char *___format_filepos
   ___P((char *path,
         ___SSIZE_T filepos,
         ___BOOL pinpoint),
        (path,
         filepos,
         pinpoint)
char *path;
___SSIZE_T filepos;
___BOOL pinpoint;)
{
#ifdef USE_MACOS

#ifdef USE_mac_gui

  if (pinpoint)
    mac_gui_highlight (path, filepos);

#endif

#endif

  return 0; /* Use default format for displaying location */
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Miscellaneous networking utilities. */

#ifdef USE_NETWORKING


___HIDDEN int network_family_decode
   ___P((int family),
        (family)
int family;)
{
  switch (family)
    {
#ifdef PF_INET
    case -1:
      return PF_INET;
#endif

#ifdef PF_INET6
    case -2:
      return PF_INET6;
#endif
    }

  return 0;
}


___HIDDEN ___SCMOBJ network_family_encode
   ___P((int family),
        (family)
int family;)
{
  switch (family)
    {
#ifdef PF_INET
    case PF_INET:
      return ___FIX(-1);
#endif

#ifdef PF_INET6
    case PF_INET6:
      return ___FIX(-2);
#endif
    }

  return ___FIX(family);
}


___HIDDEN int network_socktype_decode
   ___P((int socktype),
        (socktype)
int socktype;)
{
  switch (socktype)
    {
#ifdef SOCK_STREAM
    case -1:
      return SOCK_STREAM;
#endif

#ifdef SOCK_DGRAM
    case -2:
      return SOCK_DGRAM;
#endif

#ifdef SOCK_RAW
    case -3:
      return SOCK_RAW;
#endif
    }

  return 0;
}


___HIDDEN ___SCMOBJ network_socktype_encode
   ___P((int socktype),
        (socktype)
int socktype;)
{
  switch (socktype)
    {
#ifdef SOCK_STREAM
    case SOCK_STREAM:
      return ___FIX(-1);
#endif

#ifdef SOCK_DGRAM
    case SOCK_DGRAM:
      return ___FIX(-2);
#endif

#ifdef SOCK_RAW
    case SOCK_RAW:
      return ___FIX(-3);
#endif
    }

  return ___FIX(socktype);
}


___HIDDEN int network_protocol_decode
   ___P((int protocol),
        (protocol)
int protocol;)
{
  switch (protocol)
    {
#ifdef IPPROTO_UDP
    case -1:
      return IPPROTO_UDP;
#endif

#ifdef IPPROTO_TCP
    case -2:
      return IPPROTO_TCP;
#endif
    }

  return 0;
}


___HIDDEN ___SCMOBJ network_protocol_encode
   ___P((int protocol),
        (protocol)
int protocol;)
{
  switch (protocol)
    {
#ifdef IPPROTO_UDP
    case IPPROTO_UDP:
      return ___FIX(-1);
#endif

#ifdef IPPROTO_TCP
    case IPPROTO_TCP:
      return ___FIX(-2);
#endif
    }

  return ___FIX(protocol);
}


___SCMOBJ ___SCMOBJ_to_in_addr
   ___P((___SCMOBJ addr,
         struct in_addr *ia,
         int arg_num),
        (addr,
         ia,
         arg_num)
___SCMOBJ addr;
struct in_addr *ia;
int arg_num;)
{
  if (addr == ___FAL)
    ia->s_addr = htonl (INADDR_ANY); /* wildcard address */
  else
    {
      ___SCMOBJ ___temp; /* needed by the ___U8VECTORP macro */
      if ((!___U8VECTORP(addr)) || ___U8VECTORLENGTH(addr) != ___FIX(4))
        return ___FIX(___STOC_STRUCT_ERR+arg_num);
      ia->s_addr = htonl ((___INT(___U8VECTORREF(addr,___FIX(0)))<<24) +
                          (___INT(___U8VECTORREF(addr,___FIX(1)))<<16) +
                          (___INT(___U8VECTORREF(addr,___FIX(2)))<<8) +
                          ___INT(___U8VECTORREF(addr,___FIX(3))));
    }

  return ___FIX(___NO_ERR);
}


___SCMOBJ ___in_addr_to_SCMOBJ
   ___P((struct in_addr *ia,
         int arg_num),
        (ia,
         arg_num)
struct in_addr *ia;
int arg_num;)
{
  ___U32 a;
  ___SCMOBJ result;

  a = ntohl (ia->s_addr);

  if (a == INADDR_ANY)
    result = ___FAL; /* wildcard address */
  else
    {
      result = ___alloc_scmobj (___PSTATE, ___sU8VECTOR, 4);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

      ___U8VECTORSET(result,___FIX(0),___FIX((a>>24) & 0xff))
      ___U8VECTORSET(result,___FIX(1),___FIX((a>>16) & 0xff))
      ___U8VECTORSET(result,___FIX(2),___FIX((a>>8)  & 0xff))
      ___U8VECTORSET(result,___FIX(3),___FIX(a       & 0xff))
    }

  return result;
}


___BOOL ___in_addr_equal
   ___P((struct in_addr *ia1,
         struct in_addr *ia2),
        (ia1,
         ia2)
struct in_addr *ia1;
struct in_addr *ia2;)
{
  return ntohl (ia1->s_addr) == ntohl (ia2->s_addr);
}


#ifdef USE_IPV6

___SCMOBJ ___SCMOBJ_to_in6_addr
   ___P((___SCMOBJ addr,
         struct in6_addr *ia,
         int arg_num),
        (addr,
         ia,
         arg_num)
___SCMOBJ addr;
struct in6_addr *ia;
int arg_num;)
{
  int i;

  if (addr == ___FAL)
    {
      /* wildcard address */

      for (i=0; i<8; i++)
        {
          ia->s6_addr[i<<1] = 0;
          ia->s6_addr[(i<<1)+1] = 0;
        }
    }
  else
    {
      ___SCMOBJ ___temp; /* needed by the ___U16VECTORP macro */
      if ((!___U16VECTORP(addr)) || ___U16VECTORLENGTH(addr) != ___FIX(8))
        return ___FIX(___STOC_STRUCT_ERR+arg_num);
      for (i=0; i<8; i++)
        {
          ___U16 x = ___INT(___U16VECTORREF(addr,___FIX(i)));
          ia->s6_addr[i<<1] = (x>>8) & 0xff;
          ia->s6_addr[(i<<1)+1] = x & 0xff;
        }
    }

  return ___FIX(___NO_ERR);
}


___SCMOBJ ___in6_addr_to_SCMOBJ
   ___P((struct in6_addr *ia,
         int arg_num),
        (ia,
         arg_num)
struct in6_addr *ia;
int arg_num;)
{
  int i;
  ___SCMOBJ result;

  for (i=0; i<16; i++)
    if (ia->s6_addr[i] != 0)
      break;

  if (i == 16)
    result = ___FAL; /* wildcard address */
  else
    {
      result = ___alloc_scmobj (___PSTATE, ___sU16VECTOR, 8<<1);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

      for (i=0; i<8; i++)
        ___U16VECTORSET
          (result,
           ___FIX(i),
           ___FIX((___CAST(___U16,ia->s6_addr[i<<1])<<8) +
                  ia->s6_addr[(i<<1)+1]))
    }

  return result;
}


___BOOL ___in6_addr_equal
   ___P((struct in6_addr *ia1,
         struct in6_addr *ia2),
        (ia1,
         ia2)
struct in6_addr *ia1;
struct in6_addr *ia2;)
{
  int i;

  for (i=0; i<16; i++)
    if (ia1->s6_addr[i] != ia2->s6_addr[i])
      return 0;

  return 1;
}


#endif


___SCMOBJ ___SCMOBJ_to_sockaddr
   ___P((___SCMOBJ addr,
         ___SCMOBJ port_num,
         struct sockaddr *sa,
         SOCKET_LEN_TYPE *salen,
         int arg_num),
        (addr,
         port_num,
         sa,
         salen,
         arg_num)
___SCMOBJ addr;
___SCMOBJ port_num;
struct sockaddr *sa;
SOCKET_LEN_TYPE *salen;
int arg_num;)
{
  ___SCMOBJ result;
  ___SCMOBJ ___temp; /* needed by the ___U8VECTORP and ___U16VECTORP macros */
  int port = 0;

  if (port_num != ___FAL)
    port = ___INT(port_num);

  if (addr == ___FAL || ___U8VECTORP(addr))
    {
      struct sockaddr_in *sa_in = ___CAST(struct sockaddr_in*,sa);
      *salen = sizeof (*sa_in);
      memset (sa_in, 0, sizeof (*sa_in));
      sa->sa_family = AF_INET;
      sa_in->sin_port = htons (port);
      result = ___SCMOBJ_to_in_addr (addr, &sa_in->sin_addr, arg_num);
    }
#ifdef USE_IPV6
  else if (___U16VECTORP(addr))
    {
      struct sockaddr_in6 *sa_in6 = ___CAST(struct sockaddr_in6*,sa);
      *salen = sizeof (*sa_in6);
      memset (sa_in6, 0, sizeof (*sa_in6));
      sa->sa_family = AF_INET6;
      sa_in6->sin6_port = htons (port);
      result = ___SCMOBJ_to_in6_addr (addr, &sa_in6->sin6_addr, arg_num);
    }
#endif
  else
    result = ___FIX(___STOC_STRUCT_ERR+arg_num);

  return result;
}


#define ___SOCKET_INFO_SIZE 4
#define ___SOCKET_INFO_FAMILY      1
#define ___SOCKET_INFO_PORT_NUMBER 2
#define ___SOCKET_INFO_ADDRESS     3

#define ___SOCKET_INFO_FAMILY_FIELD(si) \
___FIELD(STRUCTURE,si,___SOCKET_INFO_FAMILY)

#define ___SOCKET_INFO_PORT_NUMBER_FIELD(si) \
___FIELD(STRUCTURE,si,___SOCKET_INFO_PORT_NUMBER)

#define ___SOCKET_INFO_ADDRESS_FIELD(si) \
___FIELD(STRUCTURE,si,___SOCKET_INFO_ADDRESS)


___SCMOBJ ___sockaddr_to_SCMOBJ
   ___P((struct sockaddr *sa,
         SOCKET_LEN_TYPE salen,
         int arg_num),
        (sa,
         salen,
         arg_num)
struct sockaddr *sa;
SOCKET_LEN_TYPE salen;
int arg_num;)
{
  ___SCMOBJ result;

  result = ___alloc_scmobj (___PSTATE, ___sSTRUCTURE, ___SOCKET_INFO_SIZE<<___LWS);

  if (___FIXNUMP(result))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

  /* guard against dangling references */
  ___SOCKET_INFO_FAMILY_FIELD(result) = ___FAL;
  ___SOCKET_INFO_PORT_NUMBER_FIELD(result) = ___FAL;
  ___SOCKET_INFO_ADDRESS_FIELD(result) = ___FAL;

  if (salen == sizeof (struct sockaddr_in))
    {
      struct sockaddr_in *sa_in = ___CAST(struct sockaddr_in*,sa);
      ___SCMOBJ addr = ___in_addr_to_SCMOBJ (&sa_in->sin_addr, arg_num);

      if (___FIXNUMP(addr))
        {
          ___release_scmobj (result);
          return addr;
        }

      ___SOCKET_INFO_FAMILY_FIELD(result) =
        network_family_encode (sa_in->sin_family);
      ___SOCKET_INFO_PORT_NUMBER_FIELD(result) =
        ___FIX(ntohs (sa_in->sin_port));
      ___SOCKET_INFO_ADDRESS_FIELD(result) = addr;
      ___release_scmobj (addr);
    }
#ifdef USE_IPV6
  else if (salen == sizeof (struct sockaddr_in6))
    {
      struct sockaddr_in6 *sa_in6 = ___CAST(struct sockaddr_in6*,sa);
      ___SCMOBJ addr = ___in6_addr_to_SCMOBJ (&sa_in6->sin6_addr, arg_num);

      if (___FIXNUMP(addr))
        {
          ___release_scmobj (result);
          return addr;
        }

      ___SOCKET_INFO_FAMILY_FIELD(result) =
        network_family_encode (sa_in6->sin6_family);
      ___SOCKET_INFO_PORT_NUMBER_FIELD(result) =
        ___FIX(ntohs (sa_in6->sin6_port));
      ___SOCKET_INFO_ADDRESS_FIELD(result) = addr;
      ___release_scmobj (addr);
    }
#endif
  else
    {
      ___release_scmobj (result);
      result = ___FIX(___CTOS_STRUCT_ERR+arg_num);
    }

  return result;
}


___BOOL sockaddr_equal
   ___P((struct sockaddr *sa1,
         SOCKET_LEN_TYPE salen1,
         struct sockaddr *sa2,
         SOCKET_LEN_TYPE salen2),
        (sa1,
         salen1,
         sa2,
         salen2)
struct sockaddr *sa1;
SOCKET_LEN_TYPE salen1;
struct sockaddr *sa2;
SOCKET_LEN_TYPE salen2;)
{
  if (salen1 == salen2)
    {
      if (salen1 == sizeof (struct sockaddr_in))
        {
          struct sockaddr_in *sa1_in = ___CAST(struct sockaddr_in*,sa1);
          struct sockaddr_in *sa2_in = ___CAST(struct sockaddr_in*,sa2);

          return (sa1_in->sin_family == sa2_in->sin_family) &&
                 (ntohs (sa1_in->sin_port) == ntohs (sa2_in->sin_port)) &&
                 ___in_addr_equal (&sa1_in->sin_addr, &sa2_in->sin_addr);
        }
#ifdef USE_IPV6
      else if (salen1 == sizeof (struct sockaddr_in6))
        {
          struct sockaddr_in6 *sa1_in6 = ___CAST(struct sockaddr_in6*,sa1);
          struct sockaddr_in6 *sa2_in6 = ___CAST(struct sockaddr_in6*,sa2);

          return (sa1_in6->sin6_family == sa2_in6->sin6_family) &&
                 (ntohs (sa1_in6->sin6_port) == ntohs (sa2_in6->sin6_port)) &&
                 ___in6_addr_equal (&sa1_in6->sin6_addr, &sa2_in6->sin6_addr);
        }
#endif
    }

  return 0;
}


#endif


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to host information. */

#ifdef USE_getaddrinfo

___HIDDEN int ai_flags_decode
   ___P((int flags),
        (flags)
int flags;)
{
  int ai_flags = 0;

#ifdef AI_PASSIVE
  if (flags & 1)
    ai_flags |= AI_PASSIVE;
#endif

#ifdef AI_CANONNAME
  if (flags & 2)
    ai_flags |= AI_CANONNAME;
#endif

#ifdef AI_NUMERICHOST
  if (flags & 4)
    ai_flags |= AI_NUMERICHOST;
#endif

#ifdef AI_NUMERICSERV
  if (flags & 8)
    ai_flags |= AI_NUMERICSERV;
#endif

#ifdef AI_ALL
  if (flags & 16)
    ai_flags |= AI_ALL;
#endif

#ifdef AI_ADDRCONFIG
  if (flags & 32)
    ai_flags |= AI_ADDRCONFIG;
#endif

#ifdef AI_V4MAPPED
  if (flags & 64)
    ai_flags |= AI_V4MAPPED;
#endif

  return ai_flags;
}

#endif


#define ___ADDRESS_INFO_SIZE 5
#define ___ADDRESS_INFO_FAMILY      1
#define ___ADDRESS_INFO_SOCKET_TYPE 2
#define ___ADDRESS_INFO_PROTOCOL    3
#define ___ADDRESS_INFO_SOCKET_INFO 4

#define ___ADDRESS_INFO_FAMILY_FIELD(ai) \
___FIELD(STRUCTURE,ai,___ADDRESS_INFO_FAMILY)

#define ___ADDRESS_INFO_SOCKET_TYPE_FIELD(ai) \
___FIELD(STRUCTURE,ai,___ADDRESS_INFO_SOCKET_TYPE)

#define ___ADDRESS_INFO_PROTOCOL_FIELD(ai) \
___FIELD(STRUCTURE,ai,___ADDRESS_INFO_PROTOCOL)

#define ___ADDRESS_INFO_SOCKET_INFO_FIELD(ai) \
___FIELD(STRUCTURE,ai,___ADDRESS_INFO_SOCKET_INFO)


___SCMOBJ ___os_address_infos
   ___P((___SCMOBJ host,
         ___SCMOBJ serv,
         ___SCMOBJ flags,
         ___SCMOBJ family,
         ___SCMOBJ socktype,
         ___SCMOBJ protocol),
        (host,
         serv,
         flags,
         family,
         socktype,
         protocol)
___SCMOBJ host;
___SCMOBJ serv;
___SCMOBJ flags;
___SCMOBJ family;
___SCMOBJ socktype;
___SCMOBJ protocol;)
{
#ifndef USE_getaddrinfo

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getaddrinfo

  ___SCMOBJ e;
  ___SCMOBJ info;
  ___SCMOBJ lst;
  ___SCMOBJ tail;
  ___SCMOBJ x;
  ___SCMOBJ p;
  int i;
  char *chost = 0;
  char *cserv = 0;

  struct addrinfo hints, *res, *res0;
  int code;

  if ((e = ___SCMOBJ_to_CHARSTRING (___PSA(___PSTATE) host, &chost, 1))
      != ___FIX(___NO_ERR))
    return e;

  if ((e = ___SCMOBJ_to_CHARSTRING (___PSA(___PSTATE) serv, &cserv, 2))
      != ___FIX(___NO_ERR))
    {
      ___release_string (chost);
      return e;
    }

  memset (&hints, 0, sizeof (hints));

  hints.ai_flags    = ai_flags_decode (___INT(flags));
  hints.ai_family   = network_family_decode (___INT(family));
  hints.ai_socktype = network_socktype_decode (___INT(socktype));
  hints.ai_protocol = network_protocol_decode (___INT(protocol));

  code = getaddrinfo (chost, cserv, &hints, &res0);

  if (code != 0)
    {
      e = err_code_from_gai_code (code);
      ___release_string (chost);
      ___release_string (cserv);
      return e;
    }

  lst = ___NUL;
  tail = ___FAL;

  for (res = res0; res != NULL; res = res->ai_next)
    {
      x = ___sockaddr_to_SCMOBJ (res->ai_addr,
                                 res->ai_addrlen,
                                 ___RETURN_POS);

      if (___FIXNUMP(x))
        {
          ___release_scmobj (lst);
          freeaddrinfo (res0);
          return x;
        }

      if (x != ___FAL)
        {
          info = ___alloc_scmobj (___PSTATE, ___sSTRUCTURE, ___ADDRESS_INFO_SIZE<<___LWS);

          if (___FIXNUMP(info))
            {
              ___release_scmobj (x);
              ___release_scmobj (lst);
              freeaddrinfo (res0);
              return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
            }

          ___ADDRESS_INFO_FAMILY_FIELD(info) =
            network_family_encode (res->ai_family);
          ___ADDRESS_INFO_SOCKET_TYPE_FIELD(info) =
            network_socktype_encode (res->ai_socktype);
          ___ADDRESS_INFO_PROTOCOL_FIELD(info) =
            network_protocol_encode (res->ai_protocol);
          ___ADDRESS_INFO_SOCKET_INFO_FIELD(info) = x;

          ___release_scmobj (x);

          p = ___make_pair (___PSTATE, info, ___NUL);

          ___release_scmobj (info);

          if (___FIXNUMP(p))
            {
              ___release_scmobj (lst);
              freeaddrinfo (res0);
              return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
            }

          if (lst == ___NUL)
            lst = p;
          else
            ___SETCDR(tail,p);

          tail = p;
        }
    }

  freeaddrinfo (res0);

  ___release_string (chost);
  ___release_string (cserv);

  return ___release_scmobj (lst);

#endif
}


#define ___HOST_INFO_NAME      1
#define ___HOST_INFO_ALIASES   2
#define ___HOST_INFO_ADDRESSES 3

___SCMOBJ ___os_host_info
   ___P((___SCMOBJ hi,
         ___SCMOBJ host),
        (hi,
         host)
___SCMOBJ hi;
___SCMOBJ host;)
{
#ifndef USE_gethostbyname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_gethostbyname

  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ result = ___FIX(___NO_ERR);
  ___SCMOBJ x;
  ___SCMOBJ lst;
  int i;
  struct hostent *he = 0;
  char *chost = 0;

  ___SCMOBJ ___temp; /* needed by the ___U8VECTORP and ___U16VECTORP macros */

  ___ps->saved[0] = hi;

#ifdef USE_POSIX

  errno = 0; /* in case the h_errno ends up being NETDB_SUCCESS
              * incorrectly which will be treated as NETDB_INTERNAL
              * (see err_code_from_h_errno)
              */

#ifdef USE_gethostbyaddr

  if (___U8VECTORP(host))
    {
      struct in_addr ia;

      if ((result = ___SCMOBJ_to_in_addr (host, &ia, 1)) != ___FIX(___NO_ERR))
        goto done;

      he = gethostbyaddr (___CAST(char*,&ia), 4, AF_INET);
    }
#ifdef USE_IPV6
  else if (___U16VECTORP(host))
    {
      struct in6_addr ia;

      if ((result = ___SCMOBJ_to_in6_addr (host, &ia, 1)) != ___FIX(___NO_ERR))
        goto done;

      he = gethostbyaddr (___CAST(char*,&ia), 16, AF_INET6);
    }
#endif
  else

#endif

    {
      /*
       * Convert the Scheme string to a C "char*" string.  If an
       * invalid character is seen then return an error.
       */

      if ((result = ___SCMOBJ_to_NONNULLCHARSTRING (___PSA(___ps)
                                                    host,
                                                    &chost, 1))
          != ___FIX(___NO_ERR))
        goto done;

#ifdef USE_inet_pton

      {
        struct in_addr ia;

        if (inet_pton (AF_INET, chost, &ia) == 1)
          he = gethostbyaddr (___CAST(char*,&ia), 4, AF_INET);
      }

#ifdef USE_IPV6

      if (he == 0)
        {
          struct in6_addr ia;

          if (inet_pton (AF_INET6, chost, &ia) == 1)
            he = gethostbyaddr (___CAST(char*,&ia), 16, AF_INET6);
        }

#endif

      if (he == 0)

#endif

        {
          he = gethostbyname (chost);
        }
    }

  if (he == 0)
    {
#ifdef USE_POSIX
      result = err_code_from_h_errno ();
#endif

#ifdef USE_WIN32
      result = err_code_from_WSAGetLastError ();
#endif
    }

  ___release_string (chost);

  if (result != ___FIX(___NO_ERR))
    goto done;

  /* convert h_name to string */

  if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                         ___CAST(char*,he->h_name),
                                         &x,
                                         ___RETURN_POS))
      != ___FIX(___NO_ERR))
    goto done;

  ___FIELD(STRUCTURE,___ps->saved[0],___HOST_INFO_NAME) =
    ___release_scmobj (x);

#endif

  /* convert h_aliases to strings */

  i = 0;
  while (he->h_aliases[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                             ___CAST(char*,he->h_aliases[i]),
                                             &x,
                                             ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          goto done;
        }

      result = ___make_pair (___ps, x, lst);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(result))
        {
          result = ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
          goto done;
        }

      lst = result;
    }

  ___FIELD(STRUCTURE,___ps->saved[0],___HOST_INFO_ALIASES) =
    ___release_scmobj (lst);

  /* convert h_addr_list to u8/u16vectors */

  i = 0;
  while (he->h_addr_list[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      switch (he->h_addrtype)
        {
        case AF_INET:
          {
            x = ___in_addr_to_SCMOBJ
                  (___CAST(struct in_addr*,he->h_addr_list[i]),
                   ___RETURN_POS);
            break;
          }

#ifdef USE_IPV6
        case AF_INET6:
          {
            x = ___in6_addr_to_SCMOBJ
                  (___CAST(struct in6_addr*,he->h_addr_list[i]),
                   ___RETURN_POS);
            break;
          }

#endif

        default:
          continue; /* ignore unknown address families */
        }

      if (___FIXNUMP(x))
        {
          ___release_scmobj (lst);
          result = x;
          goto done;
        }

      result = ___make_pair (___ps, x, lst);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(result))
        {
          result = ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
          goto done;
        }

      lst = result;
    }

  ___FIELD(STRUCTURE,___ps->saved[0],___HOST_INFO_ADDRESSES) =
    ___release_scmobj (lst);

  /* guarantee that at least one address is returned */

  if (lst == ___NUL)
    result = ___FIX(___H_ERRNO_ERR(NO_ADDRESS));
  else
    result = ___ps->saved[0];

 done:
  ___ps->saved[0] = ___VOID; /* prevent space leak */

  return result;

#endif
}


___SCMOBJ ___os_host_name ___PVOID
{
#ifndef USE_gethostname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_gethostname

#define HOSTNAME_MAX_LEN 1024

  ___SCMOBJ e;
  ___SCMOBJ result;
  char name[HOSTNAME_MAX_LEN];

  if (gethostname (name, HOSTNAME_MAX_LEN) < 0)
    return err_code_from_errno ();

  if ((e = ___NONNULLCHARSTRING_to_SCMOBJ (___PSTATE,
                                           name,
                                           &result,
                                           ___RETURN_POS))
      != ___FIX(___NO_ERR))
    return e;

  return ___release_scmobj (result);

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to service information. */

#define ___SERVICE_INFO_NAME        1
#define ___SERVICE_INFO_ALIASES     2
#define ___SERVICE_INFO_PORT_NUMBER 3
#define ___SERVICE_INFO_PROTOCOL    4

___SCMOBJ ___os_service_info
   ___P((___SCMOBJ si,
         ___SCMOBJ service,
         ___SCMOBJ protocol),
        (si,
         service,
         protocol)
___SCMOBJ si;
___SCMOBJ service;
___SCMOBJ protocol;)
{
#ifndef USE_getservbyname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getservbyname

  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ result = ___FIX(___NO_ERR);
  ___SCMOBJ x;
  ___SCMOBJ lst;
  int i;
  struct servent *se;
  char *cservice;
  char *cprotocol;

  ___SCMOBJ ___temp; /* needed by the ___U8VECTORP and ___U16VECTORP macros */

  ___ps->saved[0] = si;

  /*
   * Convert the Scheme string to a C "char*" string.  If an invalid
   * character is seen then return an error.
   */

  if (!___FIXNUMP(service))
    if ((result = ___SCMOBJ_to_NONNULLCHARSTRING (___PSA(___ps)
                                                  service,
                                                  &cservice,
                                                  1))
        != ___FIX(___NO_ERR))
      goto done;

  if ((result = ___SCMOBJ_to_CHARSTRING (___PSA(___ps)
                                         protocol,
                                         &cprotocol,
                                         2))
      != ___FIX(___NO_ERR))
    {
      if (!___FIXNUMP(service))
        ___release_string (cservice);
      goto done;
    }

#ifdef USE_POSIX

  errno = 0; /* in case the h_errno ends up being NETDB_SUCCESS
              * incorrectly which will be treated as NETDB_INTERNAL
              * (see err_code_from_h_errno)
              */

#endif

  if (___FIXNUMP(service))
    se = getservbyport (htons (___INT(service)), cprotocol);
  else
    se = getservbyname (cservice, cprotocol);

  if (se == 0)
    {
#ifdef USE_POSIX

      result = err_code_from_h_errno ();

#endif

#ifdef USE_WIN32

      result = err_code_from_WSAGetLastError ();

#endif
    }

  if (cprotocol != 0)
    ___release_string (cprotocol);

  if (!___FIXNUMP(service))
    ___release_string (cservice);

  if (result != ___FIX(___NO_ERR))
    goto done;

  /* convert s_name to string */

  if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                         se->s_name,
                                         &x,
                                         ___RETURN_POS))
      != ___FIX(___NO_ERR))
    goto done;

  ___FIELD(STRUCTURE,___ps->saved[0],___SERVICE_INFO_NAME) =
    ___release_scmobj (x);

  /* convert s_aliases to strings */

  i = 0;
  while (se->s_aliases[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                             se->s_aliases[i],
                                             &x,
                                             ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          goto done;
        }

      result = ___make_pair (___ps, x, lst);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(result))
        {
          result = ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
          goto done;
        }

      lst = result;
    }

  ___FIELD(STRUCTURE,___ps->saved[0],___SERVICE_INFO_ALIASES) =
    ___release_scmobj (lst);

  /* convert s_port to integer */

  ___FIELD(STRUCTURE,___ps->saved[0],___SERVICE_INFO_PORT_NUMBER) =
    ___FIX(ntohs (se->s_port));

  /* convert s_name to string */

  if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                         se->s_proto,
                                         &x,
                                         ___RETURN_POS))
      != ___FIX(___NO_ERR))
    goto done;

  ___FIELD(STRUCTURE,___ps->saved[0],___SERVICE_INFO_PROTOCOL) =
    ___release_scmobj (x);

  result = ___ps->saved[0];

 done:
  ___ps->saved[0] = ___VOID; /* prevent space leak */

  return result;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to protocol information. */

#define ___PROTOCOL_INFO_NAME    1
#define ___PROTOCOL_INFO_ALIASES 2
#define ___PROTOCOL_INFO_NUMBER  3

___SCMOBJ ___os_protocol_info
   ___P((___SCMOBJ pi,
         ___SCMOBJ protocol),
        (pi,
         protocol)
___SCMOBJ pi;
___SCMOBJ protocol;)
{
#ifndef USE_getprotobyname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getprotobyname

  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ result = ___FIX(___NO_ERR);
  ___SCMOBJ lst;
  ___SCMOBJ x;
  int i;
  struct protoent *pe;
  char *cprotocol;

  ___ps->saved[0] = pi;

  /*
   * Convert the Scheme string to a C "char*" string.  If an invalid
   * character is seen then return an error.
   */

  if (!___FIXNUMP(protocol))
    if ((result = ___SCMOBJ_to_NONNULLCHARSTRING (___PSA(___ps)
                                                  protocol,
                                                  &cprotocol,
                                                  1))
        != ___FIX(___NO_ERR))
      goto done;

#ifdef USE_POSIX

  errno = 0; /* in case the h_errno ends up being NETDB_SUCCESS
              * incorrectly which will be treated as NETDB_INTERNAL
              * (see err_code_from_h_errno)
              */

#endif

  if (___FIXNUMP(protocol))
    pe = getprotobynumber (___INT(protocol));
  else
    pe = getprotobyname (cprotocol);

  if (pe == 0)
    {
#ifdef USE_POSIX

      result = err_code_from_h_errno ();

#endif

#ifdef USE_WIN32

      result = err_code_from_WSAGetLastError ();

#endif
    }

  if (!___FIXNUMP(protocol))
    ___release_string (cprotocol);

  if (result != ___FIX(___NO_ERR))
    goto done;

  /* convert p_name to string */

  if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                         pe->p_name,
                                         &x,
                                         ___RETURN_POS))
      != ___FIX(___NO_ERR))
    goto done;

  ___FIELD(STRUCTURE,___ps->saved[0],___PROTOCOL_INFO_NAME) =
    ___release_scmobj (x);

  /* convert p_aliases to strings */

  i = 0;
  while (pe->p_aliases[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      if ((result = ___CHARSTRING_to_SCMOBJ (___ps,
                                             pe->p_aliases[i],
                                             &x,
                                             ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          goto done;
        }

      result = ___make_pair (___ps, x, lst);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(result))
        {
          result = ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
          goto done;
        }

      lst = result;
    }

  ___FIELD(STRUCTURE,___ps->saved[0],___PROTOCOL_INFO_ALIASES) =
    ___release_scmobj (lst);

  /* convert p_proto to integer */

  ___FIELD(STRUCTURE,___ps->saved[0],___PROTOCOL_INFO_NUMBER) =
    ___FIX(pe->p_proto);

  result = ___ps->saved[0];

 done:
  ___ps->saved[0] = ___VOID; /* prevent space leak */

  return result;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to network information. */

___SCMOBJ ___os_network_info
   ___P((___SCMOBJ ni,
         ___SCMOBJ network),
        (ni,
         network)
___SCMOBJ ni;
___SCMOBJ network;)
{
#ifndef USE_getnetbyname

  return ___FIX(___UNIMPL_ERR);

#else

  return ___FIX(___UNIMPL_ERR);

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Change file times. */

___SCMOBJ ___os_file_times_set
   ___P((___SCMOBJ path,
         ___SCMOBJ access_time,
         ___SCMOBJ modification_time),
        (path,
         access_time,
         modification_time)
___SCMOBJ path;
___SCMOBJ access_time;
___SCMOBJ modification_time;)
{
  ___SCMOBJ e;
  void *cpath;
  ___time atime;
  ___time mtime;

  ___time_from_seconds (&atime, ___F64UNBOX(access_time));
  ___time_from_seconds (&mtime, ___F64UNBOX(modification_time));

#ifndef USE_utimes
#ifndef USE_SetFileTime

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_utimes

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___TIMES_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      struct timeval tv[2];

      ___absolute_time_to_timeval (atime, &tv[0]);
      ___absolute_time_to_timeval (mtime, &tv[1]);

      if (utimes (___CAST(___STRING_TYPE(___TIMES_PATH_CE_SELECT),cpath), tv)
          < 0)
        {
          e = fnf_or_err_code_from_errno ();
          ___release_string (cpath);
          return e;
        }

      ___release_string (cpath);
    }

#endif

#ifdef USE_SetFileTime

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___TIMES_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      HANDLE h;
      FILETIME ft[2];

      ___time_to_FILETIME (atime, &ft[0]);
      ___time_to_FILETIME (mtime, &ft[1]);

      h = CreateFile (___CAST(___STRING_TYPE(___TIMES_PATH_CE_SELECT),cpath),
                      FILE_WRITE_ATTRIBUTES,
                      0,
                      NULL,
                      OPEN_EXISTING,
                      0,
                      NULL);

      if (h == INVALID_HANDLE_VALUE)
        {
          e = fnf_or_err_code_from_GetLastError ();
          ___release_string (cpath);
          return e;
        }

      if (!SetFileTime (h, NULL, &ft[0], &ft[1]))
        {
          e = err_code_from_GetLastError ();
          CloseHandle (h); /* ignore error */
          ___release_string (cpath);
          return e;
        }

      CloseHandle (h); /* ignore error */
      ___release_string (cpath);

    }

#endif

  return e;
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to file information. */

#define ___FILE_INFO_TYPE                   1
#define ___FILE_INFO_DEVICE                 2
#define ___FILE_INFO_INODE                  3
#define ___FILE_INFO_MODE                   4
#define ___FILE_INFO_NUMBER_OF_LINKS        5
#define ___FILE_INFO_OWNER                  6
#define ___FILE_INFO_GROUP                  7
#define ___FILE_INFO_SIZE                   8
#define ___FILE_INFO_LAST_ACCESS_TIME       9
#define ___FILE_INFO_LAST_MODIFICATION_TIME 10
#define ___FILE_INFO_LAST_CHANGE_TIME       11
#define ___FILE_INFO_ATTRIBUTES             12
#define ___FILE_INFO_CREATION_TIME          13

___SCMOBJ ___os_file_info
   ___P((___SCMOBJ fi,
         ___SCMOBJ path,
         ___SCMOBJ chase),
        (fi,
         path,
         chase)
___SCMOBJ fi;
___SCMOBJ path;
___SCMOBJ chase;)
{
  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ result;
  void *cpath;

  ___ps->saved[0] = fi;

#ifndef USE_stat
#ifndef USE_GetFileAttributesEx

  if ((result = ___SCMOBJ_to_NONNULLSTRING (___PSA(___ps)
                                            path,
                                            &cpath,
                                            1,
                                            ___CE(___INFO_PATH_CE_SELECT),
                                            0))
      == ___FIX(___NO_ERR))
    {
      ___FILE *check_exist = ___fopen (cpath, "r");

      if (check_exist == 0)
        {
          result = fnf_or_err_code_from_errno ();
          ___release_string (cpath);
          goto done;
        }

      ___fclose (check_exist);

      ___release_string (cpath);

      result = ___ps->saved[0];
    }

#endif
#endif

#ifdef USE_stat

  if ((result = ___SCMOBJ_to_NONNULLSTRING
                  (___PSA(___ps)
                   path,
                   &cpath,
                   1,
                   ___CE(___INFO_PATH_CE_SELECT),
                   0))
      == ___FIX(___NO_ERR))
    {
      ___struct_stat s;
      ___SCMOBJ x;

      if (stat_long_path (___CAST(___STRING_TYPE(___INFO_PATH_CE_SELECT),cpath),
                          &s,
                          chase != ___FAL) < 0)
        {
          result = fnf_or_err_code_from_errno ();
          ___release_string (cpath);
          goto done;
        }

      ___release_string (cpath);

      if (S_ISREG(s.st_mode))
        x = ___FIX(1);
      else if (S_ISDIR(s.st_mode))
        x = ___FIX(2);
      else if (S_ISCHR(s.st_mode))
        x = ___FIX(3);
      else if (S_ISBLK(s.st_mode))
        x = ___FIX(4);
      else if (S_ISFIFO(s.st_mode))
        x = ___FIX(5);
      else if (S_ISLNK(s.st_mode))
        x = ___FIX(6);
      else if (S_ISSOCK(s.st_mode))
        x = ___FIX(7);
      else
        x = ___FIX(0);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_TYPE) = x;

      if ((result = ___ULONGLONG_to_SCMOBJ (___ps,
                                            ___CAST(___ULONGLONG,s.st_dev),
                                            &x,
                                            ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_DEVICE) =
        ___release_scmobj (x);

      if ((result = ___LONGLONG_to_SCMOBJ (___ps,
                                           ___CAST(___LONGLONG,s.st_ino),
                                           &x,
                                           ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_INODE) =
        ___release_scmobj (x);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_MODE) =
        ___FIX(s.st_mode & (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO));

      if ((result = ___ULONGLONG_to_SCMOBJ (___ps,
                                            ___CAST(___ULONGLONG,s.st_nlink),
                                            &x,
                                            ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_NUMBER_OF_LINKS) =
        ___release_scmobj (x);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_OWNER) =
        ___FIX(s.st_uid);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_GROUP) =
        ___FIX(s.st_gid);

      if ((result = ___LONGLONG_to_SCMOBJ (___ps,
                                           ___CAST(___LONGLONG,s.st_size),
                                           &x,
                                           ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_SIZE) =
        ___release_scmobj (x);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___CAST(___F64,s.st_atime),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_LAST_ACCESS_TIME) =
        ___release_scmobj (x);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___CAST(___F64,s.st_mtime),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_LAST_MODIFICATION_TIME) =
        ___release_scmobj (x);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___CAST(___F64,s.st_ctime),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_LAST_CHANGE_TIME) =
        ___release_scmobj (x);

#ifndef FILE_ATTRIBUTE_READ_ONLY
#define FILE_ATTRIBUTE_READ_ONLY 1
#endif

#ifndef FILE_ATTRIBUTE_DIRECTORY
#define FILE_ATTRIBUTE_DIRECTORY 16
#endif

#ifndef FILE_ATTRIBUTE_NORMAL
#define FILE_ATTRIBUTE_NORMAL 128
#endif

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_ATTRIBUTES) =
        ___FIX(S_ISDIR(s.st_mode)
               ? FILE_ATTRIBUTE_DIRECTORY
               : FILE_ATTRIBUTE_NORMAL);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___CAST(___F64,NEG_INFINITY),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_CREATION_TIME) =
        ___release_scmobj (x);

      result = ___ps->saved[0];
    }

#endif

#ifdef USE_GetFileAttributesEx

  if ((result = ___SCMOBJ_to_NONNULLSTRING (___PSA(___ps)
                                            path,
                                            &cpath,
                                            1,
                                            ___CE(___INFO_PATH_CE_SELECT),
                                            0))
      == ___FIX(___NO_ERR))
    {
      WIN32_FILE_ATTRIBUTE_DATA fad;
      ___SCMOBJ x;
      ___time atime;
      ___time wtime;
      ___time ctime;

      if (!GetFileAttributesEx
             (___CAST(___STRING_TYPE(___INFO_PATH_CE_SELECT),cpath),
              GetFileExInfoStandard,
              &fad))
        {
          result = err_code_from_GetLastError ();
          ___release_string (cpath);
          goto done;
        }

      ___release_string (cpath);

      if (fad.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
        x = ___FIX(2);
      else
        x = ___FIX(1);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_TYPE) = x;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_DEVICE) = ___FIX(0);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_INODE) = ___FIX(0);

      if (fad.dwFileAttributes & FILE_ATTRIBUTE_READONLY)
        x = ___FIX(0333);
      else
        x = ___FIX(0777);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_MODE) = x;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_NUMBER_OF_LINKS) =
        ___FIX(1);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_OWNER) = ___FIX(0);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_GROUP) = ___FIX(0);

      if ((result = ___U64_to_SCMOBJ (___ps,
                                      ___U64_from_UM32_UM32(fad.nFileSizeHigh,fad.nFileSizeLow),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_SIZE) =
        ___release_scmobj (x);

      ___time_from_FILETIME (&atime, fad.ftLastAccessTime);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___time_to_seconds (atime),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_LAST_ACCESS_TIME) =
        ___release_scmobj (x);

      ___time_from_FILETIME (&wtime, fad.ftLastWriteTime);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___time_to_seconds (wtime),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_LAST_MODIFICATION_TIME) = x;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_LAST_CHANGE_TIME) =
        ___release_scmobj (x);

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_ATTRIBUTES) =
        ___FIX(fad.dwFileAttributes);

      ___time_from_FILETIME (&ctime, fad.ftCreationTime);

      if ((result = ___F64_to_SCMOBJ (___ps,
                                      ___time_to_seconds (ctime),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___FILE_INFO_CREATION_TIME) =
        ___release_scmobj (x);

      result = ___ps->saved[0];
    }

#endif

 done:
  ___ps->saved[0] = ___VOID; /* prevent space leak */

  return result;
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to user information. */

#define ___USER_INFO_NAME  1
#define ___USER_INFO_UID   2
#define ___USER_INFO_GID   3
#define ___USER_INFO_HOME  4
#define ___USER_INFO_SHELL 5

___SCMOBJ ___os_user_info
   ___P((___SCMOBJ ui,
         ___SCMOBJ user),
        (ui,
         user)
___SCMOBJ ui;
___SCMOBJ user;)
{
#ifndef USE_getpwnam

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getpwnam

  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ result;
  void *cuser = 0;
  struct passwd *p;

  ___ps->saved[0] = ui;

#define ___USER_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if (___FIXNUMP(user) ||
      (result = ___SCMOBJ_to_NONNULLSTRING (___PSA(___ps)
                                            user,
                                            &cuser,
                                            1,
                                            ___CE(___USER_CE_SELECT),
                   0))
      == ___FIX(___NO_ERR))
    {
      ___SCMOBJ x;

      if (___FIXNUMP(user))
        {
          if ((p = getpwuid (___INT(user)))
              == 0)
            {
              result = err_code_from_errno ();
              goto done;
            }
        }
      else
        {
          if ((p = getpwnam (___CAST(___STRING_TYPE(___USER_CE_SELECT),cuser)))
              == 0)
            {
              result = err_code_from_errno ();
              ___release_string (cuser);
              goto done;
            }

          ___release_string (cuser);
        }

      if ((result = ___NONNULLCHARSTRING_to_SCMOBJ (___ps,
                                                    p->pw_name,
                                                    &x,
                                                    ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___USER_INFO_NAME) =
        ___release_scmobj (x);

      ___FIELD(STRUCTURE,___ps->saved[0],___USER_INFO_UID) =
        ___FIX(p->pw_uid);

      ___FIELD(STRUCTURE,___ps->saved[0],___USER_INFO_GID) =
        ___FIX(p->pw_gid);

      if ((result = ___NONNULLCHARSTRING_to_SCMOBJ (___ps,
                                                    p->pw_dir,
                                                    &x,
                                                    ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___USER_INFO_HOME) =
        ___release_scmobj (x);

      if ((result = ___NONNULLCHARSTRING_to_SCMOBJ (___ps,
                                                    p->pw_shell,
                                                    &x,
                                                    ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],___USER_INFO_SHELL) =
        ___release_scmobj (x);

      result = ___ps->saved[0];
    }

 done:
  ___ps->saved[0] = ___VOID; /* prevent space leak */

  return result;

#endif
}


___SCMOBJ ___os_user_name ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___UCS_2STRING cstr;

#ifdef USE_WIN32

  static ___UCS_2 cvar[] =
  { 'U', 'S', 'E', 'R', 'N', 'A', 'M', 'E', '\0' };

#else

  static ___UCS_2 cvar[] =
  { 'U', 'S', 'E', 'R', '\0' };

#endif

  if ((e = ___getenv_UCS_2 (cvar, &cstr)) != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if ((e = ___UCS_2STRING_to_SCMOBJ (___PSTATE,
                                         cstr,
                                         &result,
                                         ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);

      if (cstr != 0)
        ___FREE_MEM(cstr);
    }

  return result;
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to group information. */

#define ___GROUP_INFO_NAME    1
#define ___GROUP_INFO_GID     2
#define ___GROUP_INFO_MEMBERS 3

___SCMOBJ ___os_group_info
   ___P((___SCMOBJ gi,
         ___SCMOBJ group),
        (gi,
         group)
___SCMOBJ gi;
___SCMOBJ group;)
{
#ifndef USE_getgrnam

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getgrnam

  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ result = ___FIX(___NO_ERR);
  ___SCMOBJ x;
  void *cgroup = 0;
  struct group *g;

  ___ps->saved[0] = gi;

#define ___GROUP_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if (___FIXNUMP(group) ||
      (result = ___SCMOBJ_to_NONNULLSTRING (___PSA(___ps)
                                            group,
                                            &cgroup,
                                            1,
                                            ___CE(___GROUP_CE_SELECT),
                                            0))
      == ___FIX(___NO_ERR))
    {
      if (___FIXNUMP(group))
        {
          if ((g = getgrgid (___INT(group)))
              == 0)
            {
              result = err_code_from_errno ();
              goto done;
            }
        }
      else
        {
          if ((g = getgrnam (___CAST(___STRING_TYPE(___GROUP_CE_SELECT),cgroup)))
              == 0)
            {
              result = err_code_from_errno ();
              ___release_string (cgroup);
              goto done;
            }

          ___release_string (cgroup);
        }

      if ((result = ___NONNULLCHARSTRING_to_SCMOBJ (___ps,
                                                    g->gr_name,
                                                    &x,
                                                    ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],1) = ___release_scmobj (x);

      ___FIELD(STRUCTURE,___ps->saved[0],2) = ___FIX(g->gr_gid);

      if ((result = ___NONNULLCHARSTRINGLIST_to_SCMOBJ
                      (___ps,
                       g->gr_mem,
                       &x,
                       ___RETURN_POS))
          != ___FIX(___NO_ERR))
        goto done;

      ___FIELD(STRUCTURE,___ps->saved[0],3) = ___release_scmobj (x);

      result = ___ps->saved[0];
    }

 done:
  ___ps->saved[0] = ___VOID; /* prevent space leak */

  return result;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to process information. */

___SCMOBJ ___os_getpid ___PVOID
{
#ifndef USE_getpid
#ifndef USE_GetCurrentProcessId

  return ___FIX(0);

#endif
#endif

#ifdef USE_getpid

  return ___FIX(getpid());

#endif

#ifdef USE_GetCurrentProcessId

  return ___FIX(GetCurrentProcessId());

#endif
}


___SCMOBJ ___os_getppid ___PVOID
{
#ifndef USE_getppid

  return ___FIX(0);

#endif

#ifdef USE_getppid

  return ___FIX(getppid());

#endif
}


/*---------------------------------------------------------------------------*/

/* System type information. */


#ifndef ___SYS_TYPE_CPU
#define ___SYS_TYPE_CPU "unknown"
#endif

#ifndef ___SYS_TYPE_VENDOR
#define ___SYS_TYPE_VENDOR "unknown"
#endif

#ifndef ___SYS_TYPE_OS
#define ___SYS_TYPE_OS "unknown"
#endif

#ifndef ___CONFIGURE_COMMAND
#define ___CONFIGURE_COMMAND "unknown"
#endif


___HIDDEN char *os_sys_type[] =
{ ___SYS_TYPE_CPU, ___SYS_TYPE_VENDOR, ___SYS_TYPE_OS, NULL };


___HIDDEN char *os_sys_type_string =
___SYS_TYPE_CPU "-" ___SYS_TYPE_VENDOR "-" ___SYS_TYPE_OS;


___HIDDEN char *configure_command_string = ___CONFIGURE_COMMAND;


char **___os_system_type ___PVOID
{
  return os_sys_type;
}


char *___os_system_type_string ___PVOID
{
  return os_sys_type_string;
}


char *___os_configure_command_string ___PVOID
{
  return configure_command_string;
}


/*---------------------------------------------------------------------------*/

/* C compilation environment information. */


#ifndef ___OBJ_EXTENSION
#define ___OBJ_EXTENSION ".obj"
#endif

#ifndef ___EXE_EXTENSION
#define ___EXE_EXTENSION ".exe"
#endif

#ifndef ___BAT_EXTENSION
#define ___BAT_EXTENSION ".bat"
#endif


___HIDDEN char *os_obj_extension_string = ___OBJ_EXTENSION;

___HIDDEN char *os_exe_extension_string = ___EXE_EXTENSION;

___HIDDEN char *os_bat_extension_string = ___BAT_EXTENSION;


char *___os_obj_extension_string ___PVOID
{
  return os_obj_extension_string;
}


char *___os_exe_extension_string ___PVOID
{
  return os_exe_extension_string;
}


char *___os_bat_extension_string ___PVOID
{
  return os_bat_extension_string;
}


/*---------------------------------------------------------------------------*/


___HIDDEN void heartbeat_intr ___PVOID
{
  /**** belongs elsewhere */
  ___raise_interrupt (___INTR_HEARTBEAT);
}


___HIDDEN void user_intr ___PVOID
{
  /**** belongs elsewhere */
  /* send interrupt only to processor 0 of vm 0 */
  ___virtual_machine_state ___vms = &___GSTATE->vmstate0;
  ___raise_interrupt_pstate (___PSTATE_FROM_PROCESSOR_ID(0,___vms), ___INTR_USER);
}


___HIDDEN void terminate_intr ___PVOID
{
  /**** belongs elsewhere */
  ___raise_interrupt (___INTR_TERMINATE);
}


#ifdef USE_POSIX


#ifdef ___DEBUG_CTRL_FLOW_HISTORY
#define USE_CRASH_SIGNAL_HANDLER
#else
#ifdef USE_backtrace_symbols_fd
#ifdef ___DEBUG_C_BACKTRACE
#define USE_CRASH_SIGNAL_HANDLER
#endif
#endif
#endif

#ifdef USE_CRASH_SIGNAL_HANDLER

#ifdef ___DEBUG_CTRL_FLOW_HISTORY

___HIDDEN void log_ctrl_flow_history ___PVOID
{
  ___print_ctrl_flow_history ();
}

#endif

___HIDDEN void crash_signal_handler
   ___P((int sig),
        (sig)
int sig;)
{
  static char *msgs[] = { "Process crashed with ", "unknown signal", NULL };

#ifdef ___DEBUG_C_BACKTRACE
#ifdef USE_backtrace_symbols_fd

  {
    void *ret_adrs[100];
    ___SIZE_T n = backtrace (ret_adrs, sizeof (ret_adrs) / sizeof (void*));

    backtrace_symbols_fd (ret_adrs, n, STDERR_FILENO);
  }

#endif
#endif

#ifdef ___DEBUG_CTRL_FLOW_HISTORY

  log_ctrl_flow_history ();

#endif

  switch (sig)
    {
    case SIGTERM:
      msgs[1] = "SIGTERM";
      break;

    case SIGBUS:
      msgs[1] = "SIGBUS";
      break;

    case SIGSEGV:
      msgs[1] = "SIGSEGV";
      break;

    case SIGILL:
      msgs[1] = "SIGILL";
      break;
    }

  ___fatal_error (msgs);
}

#endif

#endif


___SCMOBJ ___setup_os_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  return ___setup_io_pstate (___ps);
}


void ___cleanup_os_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___cleanup_io_pstate (___ps);
}


___SCMOBJ ___setup_os_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  return ___setup_io_vmstate (___vms);
}


void ___cleanup_os_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  ___cleanup_io_vmstate (___vms);
}


___SCMOBJ ___setup_os ___PVOID
{
  ___SCMOBJ e;

  /*
   * To perform correct cleanup when the program terminates an
   * "atexit (___cleanup)" is performed in "setup_io" in certain
   * environments.  There must not be any possibility of program
   * termination through "exit (...)" between the "atexit (...)"
   * and the entry of "___setup_mem".  This guarantees that
   * "___cleanup" does not access dangling pointers.
   */

  if ((e = ___setup_base_module ()) == ___FIX(___NO_ERR)) {
    if ((e = ___setup_thread_module ()) == ___FIX(___NO_ERR)) {
      if ((e = ___setup_time_module (heartbeat_intr)) == ___FIX(___NO_ERR)) {
        if ((e = ___setup_shell_module ()) == ___FIX(___NO_ERR)) {
          if ((e = ___setup_files_module ()) == ___FIX(___NO_ERR)) {
            if ((e = ___setup_dyn_module ()) == ___FIX(___NO_ERR)) {
              if ((e = ___setup_tty_module (user_intr, terminate_intr)) == ___FIX(___NO_ERR)) {
                if ((e = ___setup_io_module ()) == ___FIX(___NO_ERR)) {
#ifdef USE_SIGNALS
#ifdef USE_CRASH_SIGNAL_HANDLER
                  ___set_signal_handler (SIGTERM, crash_signal_handler);
                  ___set_signal_handler (SIGBUS,  crash_signal_handler);
                  ___set_signal_handler (SIGSEGV, crash_signal_handler);
                  ___set_signal_handler (SIGILL,  crash_signal_handler);
                  ___set_signal_handler (SIGABRT, crash_signal_handler);
#endif
#endif
                  return ___FIX(___NO_ERR);
                }
                ___cleanup_tty_module ();
              }
              ___cleanup_dyn_module ();
            }
            ___cleanup_files_module ();
          }
          ___cleanup_shell_module ();
        }
        ___cleanup_time_module ();
      }
      ___cleanup_thread_module ();
    }
    ___cleanup_base_module ();
  }

  return e;
}


void ___cleanup_os ___PVOID
{
  ___cleanup_io_module ();
  ___cleanup_tty_module ();
  ___cleanup_dyn_module ();
  ___cleanup_files_module ();
  ___cleanup_shell_module ();
  ___cleanup_time_module ();
  ___cleanup_thread_module ();
  ___cleanup_base_module ();
}


/*---------------------------------------------------------------------------*/
