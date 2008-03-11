/* File: "os.c", Time-stamp: <2007-12-16 21:15:13 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

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
 *  - virtual memory statistics
 *  - filesystem path expansion
 *  - formatting of source code position
 *  - operations on I/O devices
 */

#define ___INCLUDED_FROM_OS
#define ___VERSION 402004
#include "gambit.h"

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

/**********************************/
#ifdef ___DEBUG
#ifdef ___DEBUG_ALLOC_MEM_TRACE
#define ___alloc_mem(bytes) ___alloc_mem_debug(bytes,__LINE__,__FILE__)
#endif
#endif


/*---------------------------------------------------------------------------*/

#define NBELEMS(table)(sizeof (table) / sizeof (table[0]))


/*---------------------------------------------------------------------------*/


void ___disable_os_interrupts ___PVOID
{
  ___disable_heartbeat_interrupt ();
  ___disable_user_interrupt ();
}

void ___enable_os_interrupts ___PVOID
{
  ___enable_user_interrupt ();
  ___enable_heartbeat_interrupt ();
}


/*---------------------------------------------------------------------------*/

/* Virtual memory statistics. */

void ___vm_stats
   ___P((long *minflt,
         long *majflt),
        (minflt,
         majflt)
long *minflt;
long *majflt;)
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
         long filepos,
         ___BOOL pinpoint),
        (path,
         filepos,
         pinpoint)
char *path;
long filepos;
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

#ifdef AF_INET6
#define USE_IPV6
#endif

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
    ia->s_addr = htonl (INADDR_ANY);
  else
    ia->s_addr = htonl ((___INT(___U8VECTORREF(addr,___FIX(0)))<<24) +
                       (___INT(___U8VECTORREF(addr,___FIX(1)))<<16) +
                       (___INT(___U8VECTORREF(addr,___FIX(2)))<<8) +
                       ___INT(___U8VECTORREF(addr,___FIX(3))));

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
  unsigned long a;
  ___SCMOBJ result = ___alloc_scmobj (___sU8VECTOR, 4, ___STILL);

  if (___FIXNUMP(result))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

  a = ntohl (ia->s_addr);

  ___U8VECTORSET(result,___FIX(0),___FIX((a>>24) & 0xff))
  ___U8VECTORSET(result,___FIX(1),___FIX((a>>16) & 0xff))
  ___U8VECTORSET(result,___FIX(2),___FIX((a>>8)  & 0xff))
  ___U8VECTORSET(result,___FIX(3),___FIX(a       & 0xff))

  return result;
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
      for (i=0; i<8; i++)
        {
          ia->s6_addr[i<<1] = 0;
          ia->s6_addr[(i<<1)+1] = 0;
        }
    }
  else
    {
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
  ___SCMOBJ result = ___alloc_scmobj (___sU16VECTOR, 8<<1, ___STILL);

  if (___FIXNUMP(result))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

  for (i=0; i<8; i++)
    ___U16VECTORSET
      (result,
       ___FIX(i),
       ___FIX((___CAST(___U16,ia->s6_addr[i<<1])<<8) + ia->s6_addr[(i<<1)+1]))

  return result;
}

#endif


___SCMOBJ ___SCMOBJ_to_sockaddr
   ___P((___SCMOBJ addr,
         ___SCMOBJ port_num,
         struct sockaddr *sa,
         int *salen,
         int arg_num),
        (addr,
         port_num,
         sa,
         salen,
         arg_num)
___SCMOBJ addr;
___SCMOBJ port_num;
struct sockaddr *sa;
int *salen;
int arg_num;)
{
  ___SCMOBJ result;
  ___SCMOBJ ___temp; /* needed by the ___U8VECTORP and ___U16VECTORP macros */

  if (addr == ___FAL || ___U8VECTORP(addr))
    {
      struct sockaddr_in *sa_in = ___CAST(struct sockaddr_in*,sa);
      *salen = sizeof (*sa_in);
      memset (sa_in, 0, sizeof (*sa_in));
      sa_in->sin_family = AF_INET;
      sa_in->sin_port = htons (___INT(port_num));
      result = ___SCMOBJ_to_in_addr (addr, &sa_in->sin_addr, arg_num);
    }
#ifdef USE_IPV6
  else if (___U16VECTORP(addr))
    {
      struct sockaddr_in6 *sa_in6 = ___CAST(struct sockaddr_in6*,sa);
      *salen = sizeof (*sa_in6);
      memset (sa_in6, 0, sizeof (*sa_in6));
      sa_in6->sin6_family = AF_INET6;
      sa_in6->sin6_port = htons (___INT(port_num));
      result = ___SCMOBJ_to_in6_addr (addr, &sa_in6->sin6_addr, arg_num);
    }
#endif
  else
    result = ___FIX(___UNKNOWN_ERR);

  return result;
}


___SCMOBJ ___sockaddr_to_SCMOBJ
   ___P((struct sockaddr *sa,
         int salen,
         int arg_num),
        (sa,
         salen,
         arg_num)
struct sockaddr *sa;
int salen;
int arg_num;)
{
  ___SCMOBJ result;

  result = ___make_vector (4, ___FAL, ___STILL);

  if (___FIXNUMP(result))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

  if (salen == sizeof (struct sockaddr_in))
    {
      struct sockaddr_in *sa_in = ___CAST(struct sockaddr_in*,sa);
      ___SCMOBJ addr = ___in_addr_to_SCMOBJ (&sa_in->sin_addr, arg_num);

      if (___FIXNUMP(addr))
        {
          ___release_scmobj (result);
          return addr;
        }

      ___FIELD(result,1) = ___FIX(sa_in->sin_family);
      ___FIELD(result,2) = ___FIX(ntohs (sa_in->sin_port));
      ___FIELD(result,3) = addr;
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

      ___FIELD(result,1) = ___FIX(sa_in6->sin6_family);
      ___FIELD(result,2) = ___FIX(ntohs (sa_in6->sin6_port));
      ___FIELD(result,3) = addr;
      ___release_scmobj (addr);
    }
#endif
  else
    result = ___FAL;

  ___release_scmobj (result);

  return result;
}


___SCMOBJ ___addr_to_SCMOBJ
   ___P((void *sa,
         int salen,
         int arg_num),
        (sa,
         salen,
         arg_num)
void *sa;
int salen;
int arg_num;)
{
  ___SCMOBJ result;

  if (salen == 4)
    {
      struct in_addr *ia = ___CAST(struct in_addr*,sa);
      ___U32 a;

      result = ___alloc_scmobj (___sU8VECTOR, 4, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

      a = ntohl (ia->s_addr);

      ___U8VECTORSET(result,___FIX(0),___FIX((a>>24)&0xff))
      ___U8VECTORSET(result,___FIX(1),___FIX((a>>16)&0xff))
      ___U8VECTORSET(result,___FIX(2),___FIX((a>>8)&0xff))
      ___U8VECTORSET(result,___FIX(3),___FIX(a&0xff))
    }
#ifdef USE_IPV6
  else if (salen == 16)
    {
      struct in6_addr *ia = ___CAST(struct in6_addr*,sa);
      int i;

      result = ___alloc_scmobj (___sU16VECTOR, 8<<1, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

      for (i=0; i<8; i++)
        ___U16VECTORSET(result,
                        ___FIX(i),
                        ___FIX((___CAST(___U16,ia->s6_addr[i<<1])<<8)
                               +ia->s6_addr[(i<<1)+1]))
    }
#endif
  else
    result = ___FAL;

  ___release_scmobj (result);

  return result;
}

#endif


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to host information. */

___SCMOBJ ___os_host_info
   ___P((___SCMOBJ host),
        (host)
___SCMOBJ host;)
{
#ifndef USE_gethostbyname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_gethostbyname

  ___SCMOBJ e;
  ___SCMOBJ vect;
  ___SCMOBJ lst;
  ___SCMOBJ x;
  ___SCMOBJ p;
  int i;
  struct hostent *he = 0;
  char *chost = 0;

  ___SCMOBJ ___temp; /* needed by the ___U8VECTORP and ___U16VECTORP macros */

#ifdef USE_POSIX

  errno = 0; /* in case the h_errno ends up being NETDB_SUCCESS
              * incorrectly which will be treated as NETDB_INTERNAL
              * (see err_code_from_h_errno)
              */

#endif

#ifdef USE_gethostbyaddr

  if (___U8VECTORP(host))
    {
      struct in_addr ia;

      if ((e = ___SCMOBJ_to_in_addr (host, &ia, 1)) != ___FIX(___NO_ERR))
        return e;

      he = gethostbyaddr (___CAST(char*,&ia), 4, AF_INET);
    }
#ifdef USE_IPV6
  else if (___U16VECTORP(host))
    {
      struct in6_addr ia;

      if ((e = ___SCMOBJ_to_in6_addr (host, &ia, 1)) != ___FIX(___NO_ERR))
        return e;

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

      if ((e = ___SCMOBJ_to_NONNULLCHARSTRING (host, &chost, 1))
          != ___FIX(___NO_ERR))
        return e;

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
      e = err_code_from_h_errno ();
#endif

#ifdef USE_WIN32
      e = err_code_from_WSAGetLastError ();
#endif
    }

  ___release_string (chost);

  if (e != ___FIX(___NO_ERR))
    return e;

  vect = ___make_vector (4, ___FAL, ___STILL);

  if (___FIXNUMP(vect))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);

  /* convert h_name to string */

  if ((e = ___CHARSTRING_to_SCMOBJ
             (___CAST(char*,he->h_name),
              &x,
              ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___release_scmobj (vect);
      return e;
    }

  ___FIELD(vect,1) = x;
  ___release_scmobj (x);

  /* convert h_aliases to strings */

  i = 0;
  while (he->h_aliases[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      if ((e = ___CHARSTRING_to_SCMOBJ
                 (___CAST(char*,he->h_aliases[i]),
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          ___release_scmobj (vect);
          return e;
        }

      p = ___make_pair (x, lst, ___STILL);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(p))
        {
          ___release_scmobj (vect);
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
        }

      lst = p;
    }

  ___FIELD(vect,2) = lst;
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
          ___release_scmobj (vect);
          return x;
        }

      p = ___make_pair (x, lst, ___STILL);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(p))
        {
          ___release_scmobj (vect);
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
        }

      lst = p;
    }

  ___FIELD(vect,3) = lst;
  ___release_scmobj (lst);
  ___release_scmobj (vect);

  /* guarantee that at least one address is returned */

  if (lst == ___NUL)
    return ___FIX(___H_ERRNO_ERR(NO_ADDRESS));

  return vect;

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

  if ((e = ___NONNULLCHARSTRING_to_SCMOBJ (name, &result, ___RETURN_POS))
      != ___FIX(___NO_ERR))
    return e;

  ___release_scmobj (result);

  return result;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to service information. */

___SCMOBJ ___os_service_info
   ___P((___SCMOBJ service,
         ___SCMOBJ protocol),
        (service,
         protocol)
___SCMOBJ service;
___SCMOBJ protocol;)
{
#ifndef USE_getservbyname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getservbyname

  ___SCMOBJ e;
  ___SCMOBJ vect;
  ___SCMOBJ lst;
  ___SCMOBJ x;
  ___SCMOBJ p;
  int i;
  struct servent *se;
  char *cservice;
  char *cprotocol;

  /*
   * Convert the Scheme string to a C "char*" string.  If an invalid
   * character is seen then return an error.
   */

  if (!___FIXNUMP(service))
    if ((e = ___SCMOBJ_to_NONNULLCHARSTRING (service, &cservice, 1))
        != ___FIX(___NO_ERR))
      return e;

  if ((e = ___SCMOBJ_to_CHARSTRING (protocol, &cprotocol, 2))
      != ___FIX(___NO_ERR))
    {
      if (!___FIXNUMP(service))
        ___release_string (cservice);
      return e;
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

      e = err_code_from_h_errno ();

#endif

#ifdef USE_WIN32

      e = err_code_from_WSAGetLastError ();

#endif
    }

  if (cprotocol != 0)
    ___release_string (cprotocol);

  if (!___FIXNUMP(service))
    ___release_string (cservice);

  if (e != ___FIX(___NO_ERR))
    return e;

  vect = ___make_vector (5, ___FAL, ___STILL);

  if (___FIXNUMP(vect))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/************/

  /* convert s_name to string */

  if ((e = ___CHARSTRING_to_SCMOBJ (se->s_name, &x, ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___release_scmobj (vect);
      return e;
    }

  ___FIELD(vect,1) = x;
  ___release_scmobj (x);

  /* convert s_aliases to strings */

  i = 0;
  while (se->s_aliases[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      if ((e = ___CHARSTRING_to_SCMOBJ (se->s_aliases[i], &x, ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          ___release_scmobj (vect);
          return e;
        }

      p = ___make_pair (x, lst, ___STILL);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(p))
        {
          ___release_scmobj (vect);
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/*******************/
        }

      lst = p;
    }

  ___FIELD(vect,2) = lst;
  ___release_scmobj (lst);

  /* convert s_port to integer */

  ___FIELD(vect,3) = ___FIX(ntohs (se->s_port));

  /* convert s_name to string */

  if ((e = ___CHARSTRING_to_SCMOBJ (se->s_proto, &x, ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___release_scmobj (vect);
      return e;
    }

  ___FIELD(vect,4) = x;
  ___release_scmobj (x);

  ___release_scmobj (vect);

  return vect;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to protocol information. */

___SCMOBJ ___os_protocol_info
   ___P((___SCMOBJ protocol),
        (protocol)
___SCMOBJ protocol;)
{
#ifndef USE_getprotobyname

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getprotobyname

  ___SCMOBJ e = ___FIX(___NO_ERR);
  ___SCMOBJ vect;
  ___SCMOBJ lst;
  ___SCMOBJ x;
  ___SCMOBJ p;
  int i;
  struct protoent *pe;
  char *cprotocol;

  /*
   * Convert the Scheme string to a C "char*" string.  If an invalid
   * character is seen then return an error.
   */

  if (!___FIXNUMP(protocol))
    if ((e = ___SCMOBJ_to_NONNULLCHARSTRING (protocol, &cprotocol, 1))
        != ___FIX(___NO_ERR))
      return e;

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

      e = err_code_from_h_errno ();

#endif

#ifdef USE_WIN32

      e = err_code_from_WSAGetLastError ();

#endif
    }

  if (!___FIXNUMP(protocol))
    ___release_string (cprotocol);

  if (e != ___FIX(___NO_ERR))
    return e;

  vect = ___make_vector (4, ___FAL, ___STILL);

  if (___FIXNUMP(vect))
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/************/

  /* convert p_name to string */

  if ((e = ___CHARSTRING_to_SCMOBJ (pe->p_name, &x, ___RETURN_POS))
      != ___FIX(___NO_ERR))
    {
      ___release_scmobj (vect);
      return e;
    }

  ___FIELD(vect,1) = x;
  ___release_scmobj (x);

  /* convert p_aliases to strings */

  i = 0;
  while (pe->p_aliases[i] != 0)
    i++;

  lst = ___NUL;
  while (i-- > 0)
    {
      if ((e = ___CHARSTRING_to_SCMOBJ (pe->p_aliases[i], &x, ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          ___release_scmobj (vect);
          return e;
        }

      p = ___make_pair (x, lst, ___STILL);

      ___release_scmobj (x);
      ___release_scmobj (lst);

      if (___FIXNUMP(p))
        {
          ___release_scmobj (vect);
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/*******************/
        }

      lst = p;
    }

  ___FIELD(vect,2) = lst;
  ___release_scmobj (lst);

  /* convert p_proto to integer */

  ___FIELD(vect,3) = ___FIX(pe->p_proto);

  ___release_scmobj (vect);

  return vect;

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to network information. */

___SCMOBJ ___os_network_info
   ___P((___SCMOBJ network),
        (network)
___SCMOBJ network;)
{
#ifndef USE_getnetbyname

  return ___FIX(___UNIMPL_ERR);

#else

  return ___FIX(___UNIMPL_ERR);

#endif
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to file information. */

___SCMOBJ ___os_file_info
   ___P((___SCMOBJ path,
         ___SCMOBJ chase),
        (path,
         chase)
___SCMOBJ path;
___SCMOBJ chase;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___SCMOBJ x;
  void *cpath;

#ifndef USE_stat
#ifndef USE_GetFileAttributesEx

  return ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_stat

#define ___INFO_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (path,
              &cpath,
              1,
              ___CE(___INFO_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      struct stat s;

      if (((chase == ___FAL)
           ? lstat (___CAST(___STRING_TYPE(___INFO_PATH_CE_SELECT),cpath), &s)
           : stat (___CAST(___STRING_TYPE(___INFO_PATH_CE_SELECT),cpath), &s))
          < 0)
        {
          e = fnf_or_err_code_from_errno ();
          ___release_string (cpath);
          return e;
        }

      ___release_string (cpath);

      result = ___make_vector (14, ___FAL, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/**********/

      if (S_ISREG(s.st_mode))
        ___FIELD(result,1) = ___FIX(1);
      else if (S_ISDIR(s.st_mode))
        ___FIELD(result,1) = ___FIX(2);
      else if (S_ISCHR(s.st_mode))
        ___FIELD(result,1) = ___FIX(3);
      else if (S_ISBLK(s.st_mode))
        ___FIELD(result,1) = ___FIX(4);
      else if (S_ISFIFO(s.st_mode))
        ___FIELD(result,1) = ___FIX(5);
      else if (S_ISLNK(s.st_mode))
        ___FIELD(result,1) = ___FIX(6);
      else if (S_ISSOCK(s.st_mode))
        ___FIELD(result,1) = ___FIX(7);
      else
        ___FIELD(result,1) = ___FIX(0);

      if ((e = ___ULONGLONG_to_SCMOBJ (___CAST(___ULONGLONG,s.st_dev),
                                       &x,
                                       ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,2) = x;
      ___release_scmobj (x);

      if ((e = ___LONGLONG_to_SCMOBJ (___CAST(___LONGLONG,s.st_ino),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,3) = x;
      ___release_scmobj (x);

      ___FIELD(result,4) =
        ___FIX(s.st_mode & (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO));

      if ((e = ___ULONGLONG_to_SCMOBJ (___CAST(___ULONGLONG,s.st_nlink),
                                       &x,
                                       ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,5) = x;
      ___release_scmobj (x);

      ___FIELD(result,6) = ___FIX(s.st_uid);

      ___FIELD(result,7) = ___FIX(s.st_gid);

      if ((e = ___LONGLONG_to_SCMOBJ (___CAST(___LONGLONG,s.st_size),
                                      &x,
                                      ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,8) = x;
      ___release_scmobj (x);

      if ((e = ___F64_to_SCMOBJ (___CAST(___F64,s.st_atime), &x, ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,9) = x;
      ___release_scmobj (x);

      if ((e = ___F64_to_SCMOBJ (___CAST(___F64,s.st_mtime), &x, ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,10) = x;
      ___release_scmobj (x);

      if ((e = ___F64_to_SCMOBJ (___CAST(___F64,s.st_ctime), &x, ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,11) = x;
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

      ___FIELD(result,12) =
        ___FIX(S_ISDIR(s.st_mode)
               ? FILE_ATTRIBUTE_DIRECTORY
               : FILE_ATTRIBUTE_NORMAL);

      if ((e = ___F64_to_SCMOBJ (___CAST(___F64,NEG_INFINITY),
                                 &x,
                                 ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,13) = x;
      ___release_scmobj (x);

      ___release_scmobj (result);

      return result;
    }

#endif

#ifdef USE_GetFileAttributesEx

#ifdef _UNICODE
#define ___INFO_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___INFO_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (path,
              &cpath,
              1,
              ___CE(___INFO_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      WIN32_FILE_ATTRIBUTE_DATA fad;

      if (!GetFileAttributesEx
             (___CAST(___STRING_TYPE(___INFO_PATH_CE_SELECT),cpath),
              GetFileExInfoStandard,
              &fad))
        {
          e = err_code_from_GetLastError ();
          ___release_string (cpath);
          return e;
        }

      ___release_string (cpath);

      result = ___make_vector (14, ___FAL, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/**********/

      if (fad.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
        ___FIELD(result,1) = ___FIX(2);
      else
        ___FIELD(result,1) = ___FIX(1);

      ___FIELD(result,2) = ___FIX(0);
      ___FIELD(result,3) = ___FIX(0);

      if (fad.dwFileAttributes & FILE_ATTRIBUTE_READONLY)
        ___FIELD(result,4) = ___FIX(0333);
      else
        ___FIELD(result,4) = ___FIX(0777);

      ___FIELD(result,5) = ___FIX(1);
      ___FIELD(result,6) = ___FIX(0);
      ___FIELD(result,7) = ___FIX(0);

      if ((e = ___U64_to_SCMOBJ
                 (___U64_from_UM32_UM32(fad.nFileSizeHigh,fad.nFileSizeLow),
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,8) = x;
      ___release_scmobj (x);

      if ((e = ___F64_to_SCMOBJ
                 (___CAST(___F64,FILETIME_TO_TIME(fad.ftLastAccessTime)),
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,9) = x;
      ___release_scmobj (x);

      if ((e = ___F64_to_SCMOBJ
                 (___CAST(___F64,FILETIME_TO_TIME(fad.ftLastWriteTime)),
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,10) = x;
      ___FIELD(result,11) = x;
      ___release_scmobj (x);

      ___FIELD(result,12) = ___FIX(fad.dwFileAttributes);

      if ((e = ___F64_to_SCMOBJ
                 (___CAST(___F64,FILETIME_TO_TIME(fad.ftCreationTime)),
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,13) = x;
      ___release_scmobj (x);

      ___release_scmobj (result);

      return result;
    }

#endif

  return e;
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to user information. */

___SCMOBJ ___os_user_info
   ___P((___SCMOBJ user),
        (user)
___SCMOBJ user;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  ___SCMOBJ result;
  ___SCMOBJ x;
  void *cuser = 0;

#ifndef USE_getpwnam

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getpwnam

  struct passwd *p;

#define ___USER_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if (___FIXNUMP(user) ||
      (e = ___SCMOBJ_to_NONNULLSTRING
             (user,
              &cuser,
              1,
              ___CE(___USER_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (___FIXNUMP(user))
        {
          if ((p = getpwuid (___INT(user)))
              == 0)
            {
              e = err_code_from_errno ();
              return e;
            }
        }
      else
        {
          if ((p = getpwnam (___CAST(___STRING_TYPE(___USER_CE_SELECT),cuser)))
              == 0)
            {
              e = err_code_from_errno ();
              ___release_string (cuser);
              return e;
            }

          ___release_string (cuser);
        }

      result = ___make_vector (6, ___FAL, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/**********/

      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (p->pw_name,
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,1) = x;
      ___release_scmobj (x);

      ___FIELD(result,2) = ___FIX(p->pw_uid);

      ___FIELD(result,3) = ___FIX(p->pw_gid);

      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (p->pw_dir,
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,4) = x;
      ___release_scmobj (x);

      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (p->pw_shell,
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,5) = x;
      ___release_scmobj (x);

      ___release_scmobj (result);

      return result;
    }

#endif

  return e;
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
      if ((e = ___UCS_2STRING_to_SCMOBJ
                 (cstr,
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);

      if (cstr != 0)
        ___free_mem (cstr);
    }

  return result;
}


/*   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   */

/* Access to group information. */

___SCMOBJ ___os_group_info
   ___P((___SCMOBJ group),
        (group)
___SCMOBJ group;)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);
  ___SCMOBJ result;
  ___SCMOBJ x;
  void *cgroup = 0;

#ifndef USE_getgrnam

  return ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_getgrnam

  struct group *g;

#define ___GROUP_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if (___FIXNUMP(group) ||
      (e = ___SCMOBJ_to_NONNULLSTRING
             (group,
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
              e = err_code_from_errno ();
              return e;
            }
        }
      else
        {
          if ((g = getgrnam (___CAST(___STRING_TYPE(___GROUP_CE_SELECT),cgroup)))
              == 0)
            {
              e = err_code_from_errno ();
              ___release_string (cgroup);
              return e;
            }

          ___release_string (cgroup);
        }

      result = ___make_vector (3, ___FAL, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);/**********/

      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (g->gr_name,
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,1) = x;
      ___release_scmobj (x);

      ___FIELD(result,2) = ___FIX(g->gr_gid);

      if ((e = ___NONNULLCHARSTRINGLIST_to_SCMOBJ
                 (g->gr_mem,
                  &x,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (result);
          return e;
        }

      ___FIELD(result,3) = x;
      ___release_scmobj (x);

      ___release_scmobj (result);

      return result;
    }

#endif

  return e;
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


___HIDDEN char *os_sys_type[] =
{ ___SYS_TYPE_CPU, ___SYS_TYPE_VENDOR, ___SYS_TYPE_OS, NULL };


___HIDDEN char *os_sys_type_string =
___SYS_TYPE_CPU "-" ___SYS_TYPE_VENDOR "-" ___SYS_TYPE_OS;


char **___os_system_type ___PVOID
{
  return os_sys_type;
}


char *___os_system_type_string ___PVOID
{
  return os_sys_type_string;
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
  ___raise_interrupt (___INTR_USER);
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

  if ((e = ___setup_base_module ()) == ___FIX(___NO_ERR))
    {
      if ((e = ___setup_time_module (heartbeat_intr)) == ___FIX(___NO_ERR))
        {
          if ((e = ___setup_shell_module ()) == ___FIX(___NO_ERR))
            {
              if ((e = ___setup_files_module ()) == ___FIX(___NO_ERR))
                {
                  if ((e = ___setup_dyn_module ()) == ___FIX(___NO_ERR))
                    {
                      if ((e = ___setup_tty_module (user_intr)) == ___FIX(___NO_ERR))
                        {
                          if ((e = ___setup_io_module ()) == ___FIX(___NO_ERR))
                            {
#ifdef USE_POSIX
                              ___set_signal_handler (SIGPIPE, SIG_IGN); /***** belongs elsewhere */
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
  ___cleanup_base_module ();
}


/*---------------------------------------------------------------------------*/
