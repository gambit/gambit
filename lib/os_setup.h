/* File: "os_setup.h" */

/* Copyright (c) 1994-2018 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_SETUP_H
#define ___OS_SETUP_H

#include "os.h"
#include "os_tty.h"
#include "os_time.h"
#include "os_io.h"


/*---------------------------------------------------------------------------*/

/* Miscellaneous POSIX utility functions. */

#ifdef USE_POSIX

extern pid_t ___waitpid_no_EINTR
   ___P((pid_t pid,
         int *stat_loc,
         int options),
        ());

extern ___SSIZE_T ___read_no_EINTR
   ___P((int fd,
         void *buf,
         ___SIZE_T len),
        ());

extern int ___close_no_EINTR
   ___P((int fd),
        ());

extern int ___dup_no_EINTR
   ___P((int fd),
        ());

extern int ___dup2_no_EINTR
   ___P((int fd,
         int fd2),
        ());

extern int ___set_fd_blocking_mode
   ___P((int fd,
         ___BOOL blocking),
        ());

extern int ___open_half_duplex_pipe
   ___P((___half_duplex_pipe *hdp),
        ());

extern void ___close_half_duplex_pipe
   ___P((___half_duplex_pipe *hdp,
         int end),
        ());

#endif


/* Interrupt handling. */

extern void ___cleanup_all_interrupt_handling ___PVOID;


/* CPU information. */

extern int ___cpu_count ___PVOID;

extern int ___cpu_cache_size
   ___P((___BOOL instruction_cache,
         int level),
        ());

extern int ___core_count ___PVOID;


/* Virtual memory statistics. */

extern void ___vm_stats
   ___P((___SIZE_TS *minflt,
         ___SIZE_TS *majflt),
        ());


/* Formatting of source code position. */

extern char *___format_filepos
   ___P((char *path,
         ___SSIZE_T filepos,
         ___BOOL pinpoint),
        ());


/* Change file times. */

extern ___SCMOBJ ___os_file_times_set
   ___P((___SCMOBJ path,
         ___SCMOBJ modification_time,
         ___SCMOBJ access_time),
        ());


/* Access to file information. */

extern ___SCMOBJ ___os_file_info
   ___P((___SCMOBJ fi,
         ___SCMOBJ path,
         ___SCMOBJ chase),
        ());


/* Access to user information. */

extern ___SCMOBJ ___os_user_info
   ___P((___SCMOBJ ui,
         ___SCMOBJ user),
        ());

extern ___SCMOBJ ___os_user_name ___PVOID;


/* Access to group information. */

extern ___SCMOBJ ___os_group_info
   ___P((___SCMOBJ gi,
         ___SCMOBJ group),
        ());


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
   ___P((___SCMOBJ hi,
         ___SCMOBJ host),
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
         SOCKET_LEN_TYPE *salen,
         int arg_num),
        ());

extern ___SCMOBJ ___sockaddr_to_SCMOBJ
   ___P((struct sockaddr *sa,
         SOCKET_LEN_TYPE salen,
         int arg_num),
        ());

extern ___BOOL sockaddr_equal
   ___P((struct sockaddr *sa1,
         SOCKET_LEN_TYPE salen1,
         struct sockaddr *sa2,
         SOCKET_LEN_TYPE salen2),
        ());

#endif


/* Access to service information. */

extern ___SCMOBJ ___os_service_info
   ___P((___SCMOBJ si,
         ___SCMOBJ service,
         ___SCMOBJ protocol),
        ());


/* Access to protocol information. */

extern ___SCMOBJ ___os_protocol_info
   ___P((___SCMOBJ pi,
         ___SCMOBJ protocol),
        ());


/* Access to network information. */

extern ___SCMOBJ ___os_network_info
   ___P((___SCMOBJ ni,
         ___SCMOBJ network),
        ());


/* Access to process information. */

extern ___SCMOBJ ___os_getpid ___PVOID;
extern ___SCMOBJ ___os_getppid ___PVOID;


/* System type information. */

extern char **___os_system_type ___PVOID;
extern char *___os_system_type_string ___PVOID;
extern char *___os_configure_command_string ___PVOID;


/* C compilation environment information. */

extern char *___os_obj_extension_string ___PVOID;
extern char *___os_exe_extension_string ___PVOID;
extern char *___os_bat_extension_string ___PVOID;


/* OS initialization/finalization. */

extern ___SCMOBJ ___setup_os_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___cleanup_os_pstate
   ___P((___processor_state ___ps),
        ());

extern ___SCMOBJ ___setup_os_vmstate
   ___P((___virtual_machine_state ___vms),
        ());

extern void ___cleanup_os_vmstate
   ___P((___virtual_machine_state ___vms),
        ());

extern ___SCMOBJ ___setup_os ___PVOID;

extern void ___cleanup_os ___PVOID;


/*---------------------------------------------------------------------------*/

#endif
