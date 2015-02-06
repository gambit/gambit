/* File: "os.h" */

/* Copyright (c) 1994-2014 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_H
#define ___OS_H


/*---------------------------------------------------------------------------*/

/* Determine subsystems to debug.  */

#define ___DEBUG_not
#define ___DEBUG_TTY_not
#define ___DEBUG_ALLOC_MEM_TRACE_not


/*---------------------------------------------------------------------------*/

/* Determine which line editing features to enable.  */

#define USE_LINEEDITOR
#define LINEEDITOR_WITH_NONBLOCKING_IO
#define LINEEDITOR_SUPPORT_F5_TO_F12
#define LINEEDITOR_SUPPORT_ALTERNATE_ESCAPES
#define LINEEDITOR_WITH_LOCAL_CLIPBOARD
#define LINEEDITOR_REPORT_CHAR_ENCODING_ERRORS


/*---------------------------------------------------------------------------*/

/* Determine if we are using POSIX or WIN32.  */

#ifdef ___OS_WIN32
#define USE_WIN32
#endif

#ifdef HAVE_WAITPID

/*
 * Heuristic: if waitpid is available then this is probably a POSIX system.
 */

#define USE_POSIX

#endif

#ifndef USE_WIN32
#ifndef USE_POSIX

/*
 * If this is not a WIN32 or POSIX system, the OS is generic.
 */

#define USE_GENERIC_OS

#endif
#endif

/*---------------------------------------------------------------------------*/

/*
 * We assume that the following basic features are available
 * regardless of the operating-system... otherwise we are in real
 * trouble!
 */

#define USE_errno
#define USE_malloc
#define USE_memmove


/*
 * The following basic features are used if they are available.
 */

#ifdef HAVE_GETENV
#define USE_getenv
#endif

#ifdef HAVE_SETENV
#define USE_setenv
#endif

#ifdef HAVE_UNSETENV
#define USE_unsetenv
#endif


/* Operating-system specific features we require */

#ifdef USE_POSIX

#define USE_open

/* Select features based on availability */

#ifdef HAVE_ENVIRON
#define USE_environ
#else
#ifdef HAVE__NSGETENVIRON
#define USE_environ
#endif
#endif

#ifdef HAVE_PIPE
#define USE_pipe
#else
#ifdef HAVE_SOCKETPAIR
#define USE_socketpair
#endif
#endif

#ifdef HAVE_CHDIR
#define USE_chdir
#endif

#ifdef HAVE_EXECVP
#define USE_execvp
#endif

#ifdef HAVE_GETGRNAM
#define USE_getgrnam
#endif

#ifdef HAVE_GETPID
#define USE_getpid
#endif

#ifdef HAVE_GETPPID
#define USE_getppid
#endif

#ifdef HAVE_GETPWNAM
#define USE_getpwnam
#endif

#ifdef HAVE_IOCTL
#define USE_ioctl
#endif

#ifdef HAVE_LINK
#define USE_link
#endif

#ifdef HAVE_MKDIR
#define USE_mkdir
#endif

#ifdef HAVE_MKFIFO
#define USE_mkfifo
#endif

#ifdef HAVE_OPENDIR
#define USE_opendir
#endif

#ifdef HAVE_RENAME
#define USE_rename
#endif

#ifdef HAVE_RMDIR
#define USE_rmdir
#endif

#ifdef HAVE_SOCKET
#define USE_socket
#define USE_NETWORKING
#endif

#if defined(HAVE_STAT64) && defined(HAVE_STRUCT_STAT64) && !(defined(__MACOSX__) || (defined(__APPLE__) && defined(__MACH__)))
#define USE_stat
#define ___struct_stat struct stat64
#define ___stat stat64
#define ___lstat lstat64
#define ___fstat fstat64
#else
#ifdef HAVE_STAT
#define USE_stat
#define ___struct_stat struct stat
#define ___stat stat
#define ___lstat lstat
#define ___fstat fstat
#endif
#endif

#define USE_NONBLOCKING_FILE_IO

#ifdef HAVE_TARGETCONDITIONALS_H
#include <TargetConditionals.h>
#ifdef TARGET_OS_IPHONE
#if TARGET_OS_IPHONE == 1
#undef USE_NONBLOCKING_FILE_IO
#endif
#endif
#endif

#ifdef HAVE_STRERROR
#define USE_strerror
#endif

#ifdef HAVE_SYMLINK
#define USE_symlink
#endif

#ifdef HAVE_SYSCONF
#define USE_sysconf
#endif

#ifdef HAVE_SYSCTL
#define USE_sysctl
#endif

#ifdef HAVE_TCGETSETATTR
#define USE_tcgetsetattr
#endif

#ifdef HAVE_UNLINK
#define USE_unlink
#endif

#ifdef HAVE_WAITPID
#define USE_waitpid
#endif

#ifdef HAVE_MMAP
#define USE_mmap
#endif

#ifdef HAVE_FCNTL
#define USE_fcntl
#endif

#if 0

/*
 * This code is now commented out as it seems to be causing trouble on
 * CYGWIN and the problem it was trying to solve no longer seems to
 * exist (perhaps the bug in CYGWIN has since been repaired).
 */

#ifdef __CYGWIN__
/* 
 * Cygwin's timer implementation does not support ITIMER_VIRTUAL and
 * ITIMER_REAL causes dynamic loading to fail.  Why?  I don't know!
 * Use WIN32's CreateThread instead.
 */
#undef HAVE_SETITIMER
#define HAVE_CREATETHREAD 1
#define USE_GetLastError
#define HAVE_WINDOWS_H 1
#define INCLUDE_windows_h
#endif

#endif

#endif


#ifdef USE_WIN32

/* 
 * WIN32 does not support "Unix style" nonblocking I/O.  This can be
 * simulated using pumps.
 */

#define USE_PUMPS

#undef LINEEDITOR_WITH_LOCAL_CLIPBOARD

#define USE_ioctl
#define USE_CopyFile
#define USE_CreateDirectory
#define USE_CreateProcess
#define USE_DeleteFile
#define USE_FindFirstFile
#define USE_FormatMessage
#define USE_GetCurrentProcessId
#define USE_GetEnvironmentStrings
#define USE_GetEnvironmentVariable
#define USE_GetFileAttributesEx
#define USE_GetLastError
#define USE_MoveFile
#define USE_RemoveDirectory
#define USE_SetCurrentDirectory
#define USE_SetEnvironmentVariable
#define USE_WSAGetLastError
#define USE_GetConsoleWindow
#define USE_GetModuleFileName
#define USE_VirtualAlloc
#define USE_GetSystemInfo

#define HAVE_CLOCK 1
#define HAVE_CREATETHREAD 1
#define HAVE_GETPROCESSTIMES 1
#define HAVE_GETSYSTEMTIMEASFILETIME 1
#define HAVE_TIMEBEGINPERIOD 1
#define HAVE_GETSYSTEMINFO 1
#define HAVE_LOADLIBRARY 1
#define HAVE_MSGWAITFORMULTIPLEOBJECTS 1
#define HAVE_Sleep 1

#define HAVE_GETHOSTNAME 1
#define HAVE_GETPEERNAME 1
#define HAVE_GETSOCKNAME 1
#undef HAVE_INET_PTON
#define HAVE_GETADDRINFO 1
#define HAVE_GETHOSTBYNAME 1
#define HAVE_GETHOSTBYADDR 1
#define HAVE_GETSERVBYNAME 1
#define HAVE_GETSERVBYPORT 1
#define HAVE_GETPROTOBYNAME 1
#define HAVE_GETPROTOBYNUMBER 1
#define HAVE_GETNETBYNAME 1

#define HAVE_WINDOWS_H 1
#define INCLUDE_windows_h
#define HAVE_WINSOCK2_H 1
#define INCLUDE_winsock2_h
#define HAVE_WS2TCPIP_H 1
#define INCLUDE_ws2tcpip_h
#define USE_NETWORKING

#define HAVE_IO_H 1
#define INCLUDE_io_h

#define HAVE_TCHAR_H 1
#define INCLUDE_tchar_h

#define HAVE_ERRNO_H 1

#ifdef __WATCOMC__
#define HAVE_STDINT_H 1
#define INCLUDE_stdint_h
#endif

#endif


/*---------------------------------------------------------------------------*/

/* Determine which function for getting real time is most precise.  */

#ifdef HAVE_CLOCK_GETTIME
#define USE_clock_gettime
#else
#ifdef HAVE_GETCLOCK
#define USE_getclock
#else
#ifdef HAVE_GETSYSTEMTIMEASFILETIME
#define USE_GetSystemTimeAsFileTime
#else
#ifdef HAVE_GETTIMEOFDAY
#define USE_gettimeofday
#else
#ifdef HAVE_FTIME
#define USE_ftime
#else
#ifdef HAVE_TIME
#define USE_time
#endif
#endif
#endif
#endif
#endif
#endif


/* Determine which function for sleeping is most precise.  */

#ifdef HAVE_NANOSLEEP
#define USE_nanosleep
#else
#ifdef HAVE_Sleep
#define USE_Sleep
#else
#ifdef HAVE_SLEEP
#define USE_sleep
#endif
#endif
#endif


/* Determine which function for getting process time is most precise.  */

#ifdef HAVE_GETPROCESSTIMES
#define USE_GetProcessTimes
#else
#ifdef HAVE_GETRUSAGE
#define USE_getrusage
#else
#ifdef HAVE_TIMES
#define USE_times
#else
#ifdef HAVE_CLOCK
#define USE_clock
#else
#ifdef HAVE_DOSQUERYSYSINFO
#define USE_DosQuerySysInfo
#endif
#endif
#endif
#endif
#endif


/* Determine which heartbeat timer interface to use.  */

#ifdef HAVE_SETITIMER
#define USE_setitimer
#else
#ifdef HAVE_DOS_SETVECT
#define USE_dos_setvect
#else
#ifdef HAVE_DOSSTARTTIMER
#define USE_DosStartTimer
#else
#ifdef HAVE_VINSTALL
#define USE_VInstall
#else
#ifdef HAVE_CREATETHREAD
#define USE_CreateThread
#endif
#endif
#endif
#endif
#endif


/* Determine which signal interface to use.  */

#ifdef HAVE_SIGACTION
#define USE_sigaction
#ifndef HAVE_SIGEMPTYSET
#undef USE_sigaction
#endif
#ifndef HAVE_SIGADDSET
#undef USE_sigaction
#endif
#ifndef HAVE_SIGPROCMASK
#undef USE_sigaction
#endif
#endif

#ifndef USE_sigaction
#ifdef HAVE_SIGNAL
#define USE_signal
#endif
#endif


/* Determine which dynamic loading interface to use.  */

#ifdef HAVE_SHL_LOAD
#define USE_shl_load
#else
#ifdef HAVE_LOADLIBRARY
#define USE_LoadLibrary
#else
#ifdef HAVE_DOSLOADMODULE
#define USE_DosLoadModule
#else
#ifdef HAVE_DXE_LOAD
#define USE_dxe_load
#else
#ifdef HAVE_GETDISKFRAGMENT
#define USE_GetDiskFragment
#else
#ifdef HAVE_DLOPEN
#define USE_dlopen
#else
#ifdef HAVE_NSLINKMODULE
#define USE_NSLinkModule
#endif
#endif
#endif
#endif
#endif
#endif
#endif


/* Determine which function to use for miscellaneous networking features.  */

#ifdef HAVE_GETHOSTNAME
#define USE_gethostname
#endif

#ifdef HAVE_GETPEERNAME
#define USE_getpeername
#endif

#ifdef HAVE_GETSOCKNAME
#define USE_getsockname
#endif

#ifdef HAVE_INET_PTON
#define USE_inet_pton
#endif

#ifdef HAVE_GETADDRINFO
#define USE_getaddrinfo
#endif

#ifdef HAVE_GETHOSTBYNAME
#define USE_gethostbyname
#endif

#ifdef HAVE_GETHOSTBYADDR
#define USE_gethostbyaddr
#endif

#ifdef HAVE_GETSERVBYNAME
#define USE_getservbyname
#endif

#ifdef HAVE_GETSERVBYPORT
#define USE_getservbyport
#endif

#ifdef HAVE_GETPROTOBYNAME
#define USE_getprotobyname
#endif

#ifdef HAVE_GETPROTOBYNUMBER
#define USE_getprotobynumber
#endif

#ifdef HAVE_GETNETBYNAME
#define USE_getnetbyname
#endif


/* Determine which select interface should be used.  */

#ifndef USE_POLL_FOR_SELECT
#undef HAVE_POLL
#endif

#ifdef HAVE_MSGWAITFORMULTIPLEOBJECTS
#define USE_MsgWaitForMultipleObjects
#else
#ifdef HAVE_POLL
#define USE_poll
#ifdef HAVE_PPOLL
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#define USE_ppoll
#endif
#else
#ifdef HAVE_SELECT
#define USE_select
#endif
#endif
#endif


/* Determine which curses interface should be used.  */

#if 1

/* 
 * We use our own curses implementation to avoid depending on the OS's
 * curses library, which is difficult to link to on some systems.
 */

#define USE_CURSES

#else

#ifdef HAVE_TGETSTR
#define USE_TERMCAP
#define USE_CURSES
#else
#ifdef HAVE_TIGETSTR
#define USE_TERMINFO
#define USE_CURSES
#endif
#endif

#endif


/* Determine which pty interface should be used.  */

#ifdef HAVE_OPENPTY
#define USE_openpty
#else
#ifdef HAVE_GETPT
#define USE_getpt
#endif
#ifdef HAVE_PTSNAME
#define USE_ptsname
#endif
#endif


/* Determine which error interface should be used.  */

#ifdef HAVE_HSTRERROR
#define USE_hstrerror
#endif


/* Determine which floating point configuration interface should be used.  */

#ifdef HAVE_GET_FPC_CSR
#define USE_get_fpc_csr
#endif


/*---------------------------------------------------------------------------*/

/* Determine which header files to include. */

#ifdef USE_malloc
#undef INCLUDE_stdlib_h
#define INCLUDE_stdlib_h
#endif

#ifdef USE_environ
#ifdef HAVE_ENVIRON
___BEGIN_C_LINKAGE
extern char **environ;
___END_C_LINKAGE
#else
#ifdef HAVE__NSGETENVIRON
#define environ (*_NSGetEnviron())
#undef INCLUDE_crt_externs_h
#define INCLUDE_crt_externs_h
#endif
#endif
#endif

#ifdef USE_getenv
#undef INCLUDE_stdlib_h
#define INCLUDE_stdlib_h
#endif

#ifdef USE_setenv
#undef INCLUDE_stdlib_h
#define INCLUDE_stdlib_h
#endif

#ifdef USE_unsetenv
#undef INCLUDE_stdlib_h
#define INCLUDE_stdlib_h
#endif

#ifdef USE_open
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_stat_h
#define INCLUDE_sys_stat_h
#undef INCLUDE_fcntl_h
#define INCLUDE_fcntl_h
#endif

#ifdef USE_opendir
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_dirent_h
#define INCLUDE_dirent_h
#endif

#ifdef USE_stat
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_stat_h
#define INCLUDE_sys_stat_h
#undef INCLUDE_unistd_h
#define INCLUDE_unistd_h
#endif

#ifdef USE_ioctl
#undef INCLUDE_sys_ioctl_h
#define INCLUDE_sys_ioctl_h
#endif

#ifdef USE_getpwnam
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_pwd_h
#define INCLUDE_pwd_h
#endif

#ifdef USE_getgrnam
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_grp_h
#define INCLUDE_grp_h
#endif

#ifdef USE_errno
#undef INCLUDE_errno_h
#define INCLUDE_errno_h
#endif

#ifdef USE_strerror
#undef INCLUDE_string_h
#define INCLUDE_string_h
#endif

#ifdef USE_memmove
#undef INCLUDE_string_h
#define INCLUDE_string_h
#endif

#ifdef USE_hstrerror
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_time
#undef INCLUDE_time_h
#define INCLUDE_time_h
#endif

#ifdef USE_ftime
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_timeb_h
#define INCLUDE_sys_timeb_h
#endif

#ifdef USE_gettimeofday
#undef INCLUDE_sys_time_h
#define INCLUDE_sys_time_h
#endif

#ifdef USE_setitimer
#undef INCLUDE_sys_time_h
#define INCLUDE_sys_time_h
#endif

#ifdef USE_nanosleep
#undef INCLUDE_time_h
#define INCLUDE_time_h
#endif

#ifdef USE_sleep
#undef INCLUDE_unistd_h
#define INCLUDE_unistd_h
#endif

#ifdef USE_times
#undef INCLUDE_sys_times_h
#define INCLUDE_sys_times_h
#endif

#ifdef USE_clock_gettime
#undef INCLUDE_time_h
#define INCLUDE_time_h
#endif

#ifdef USE_getclock
#undef INCLUDE_sys_timers_h
#define INCLUDE_sys_timers_h
#endif

#ifdef USE_getrusage
#undef INCLUDE_sys_time_h
#define INCLUDE_sys_time_h
#undef INCLUDE_sys_resource_h
#define INCLUDE_sys_resource_h
#undef INCLUDE_unistd_h
#define INCLUDE_unistd_h
#endif

#ifdef USE_dlopen
#undef INCLUDE_dlfcn_h
#define INCLUDE_dlfcn_h
#endif

#ifdef USE_shl_load
#undef INCLUDE_dl_h
#define INCLUDE_dl_h
#endif

#ifdef USE_dxe_load
#undef INCLUDE_sys_dxe_h
#define INCLUDE_sys_dxe_h
#endif

#ifdef USE_NSLinkModule
#undef INCLUDE_mach_o_dyld_h
#define INCLUDE_mach_o_dyld_h
#endif

#ifdef USE_signal
#undef INCLUDE_signal_h
#define INCLUDE_signal_h
#endif

#ifdef USE_sigaction
#undef INCLUDE_signal_h
#define INCLUDE_signal_h
#endif

#ifdef USE_socket
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#endif

#ifdef USE_execvp
#undef INCLUDE_unistd_h
#define INCLUDE_unistd_h
#endif

#ifdef USE_waitpid
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_wait_h
#define INCLUDE_sys_wait_h
#endif

#ifdef USE_mmap
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_mman_h
#define INCLUDE_sys_mman_h
#endif

#ifdef USE_gethostname
#undef INCLUDE_unistd_h
#define INCLUDE_unistd_h
#endif

#ifdef USE_getpeername
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#endif

#ifdef USE_getsockname
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#endif

#ifdef HAVE_INET_PTON
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_arpa_inet_h
#define INCLUDE_arpa_inet_h
#endif

#ifdef USE_getaddrinfo
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_gethostbyname
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_gethostbyaddr
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_getservbyname
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_getservbyport
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_getprotobyname
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_getprotobynumber
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_OPENSSL
#undef INCLUDE_openssl_ssl_h
#define INCLUDE_openssl_ssl_h
#undef INCLUDE_openssl_dh_h
#define INCLUDE_openssl_dh_h
#undef INCLUDE_openssl_ecdh_h
#define INCLUDE_openssl_ecdh_h
#undef INCLUDE_openssl_rand_h
#define INCLUDE_openssl_rand_h
#undef INCLUDE_openssl_err_h
#define INCLUDE_openssl_err_h
#endif

#ifdef USE_getnetbyname
#undef INCLUDE_sys_socket_h
#define INCLUDE_sys_socket_h
#undef INCLUDE_netinet_in_h
#define INCLUDE_netinet_in_h
#undef INCLUDE_netdb_h
#define INCLUDE_netdb_h
#endif

#ifdef USE_getgrnam
#undef INCLUDE_grp_h
#define INCLUDE_grp_h
#endif

#ifdef USE_fullpath
#undef INCLUDE_sys_stat_h
#define INCLUDE_sys_stat_h
#endif

#ifdef USE_control87
#undef INCLUDE_float_h
#define INCLUDE_float_h
#endif

#ifdef USE__FPU_SETCW
#undef INCLUDE_fpu_control_h
#define INCLUDE_fpu_control_h
#endif

#ifdef USE_get_fpc_csr
#undef INCLUDE_sys_fpu_h
#define INCLUDE_sys_fpu_h
#endif

#ifdef USE_t_fork
#undef INCLUDE_tfork_h
#define INCLUDE_tfork_h
#undef INCLUDE_sys_wait_h
#define INCLUDE_sys_wait_h
#endif

#ifdef USE_openpty
#undef INCLUDE_pty_h
#define INCLUDE_pty_h
#undef INCLUDE_util_h
#define INCLUDE_util_h
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_ioctl_h
#define INCLUDE_sys_ioctl_h
#undef INCLUDE_termios_h
#define INCLUDE_termios_h
#undef INCLUDE_libutil_h
#define INCLUDE_libutil_h
#endif

#ifdef USE_getpt
#undef INCLUDE_stdlib_h
#define INCLUDE_stdlib_h
#undef INCLUDE_stropts_h
#define INCLUDE_stropts_h
#endif

#ifdef USE_ptsname
#undef INCLUDE_stdlib_h
#define INCLUDE_stdlib_h
#undef INCLUDE_stropts_h
#define INCLUDE_stropts_h
#endif

#ifdef USE_sysctl
#undef INCLUDE_sys_types_h
#define INCLUDE_sys_types_h
#undef INCLUDE_sys_sysctl_h
#define INCLUDE_sys_sysctl_h
#endif

#ifdef USE_tcgetsetattr
#undef INCLUDE_termios_h
#define INCLUDE_termios_h
#undef INCLUDE_unistd_h
#define INCLUDE_unistd_h
#endif

#ifdef USE_TERMCAP
#undef INCLUDE_curses_h
#define INCLUDE_curses_h
#endif

#ifdef USE_TERMINFO
#undef INCLUDE_curses_h
#define INCLUDE_curses_h
#endif

#ifdef USE_poll
#undef INCLUDE_poll_h
#define INCLUDE_poll_h
#endif

#ifdef USE_fcntl
#undef INCLUDE_fcntl_h
#define INCLUDE_fcntl_h
#endif


/*---------------------------------------------------------------------------*/

/* Inclusion of header files. */

#ifdef INCLUDE_errno_h
#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif
#endif

#ifdef INCLUDE_unistd_h
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#endif

#ifdef INCLUDE_pwd_h
#ifdef HAVE_PWD_H
#include <pwd.h>
#endif
#endif

#ifdef INCLUDE_dirent_h
#ifdef HAVE_DIRENT_H
#include <dirent.h>
#endif
#endif

#ifdef INCLUDE_dlfcn_h
#ifdef HAVE_DLFCN_H
#include <dlfcn.h>
#endif
#endif

#ifdef INCLUDE_dl_h
#ifdef HAVE_DL_H
#include <dl.h>
#endif
#endif

#ifdef INCLUDE_sys_dxe_h
#ifdef HAVE_SYS_DXE_H
#include <sys/dxe.h>
#endif
#endif

#ifdef INCLUDE_mach_o_dyld_h
#ifdef HAVE_MACH_O_DYLD_H
#include <mach-o/dyld.h>
#endif
#endif

#ifdef INCLUDE_sys_types_h
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#endif

#ifdef INCLUDE_sys_time_h
#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif
#endif

#ifdef INCLUDE_sys_times_h
#ifdef HAVE_SYS_TIMES_H
#include <sys/times.h>
#endif
#endif

#ifdef INCLUDE_sys_timeb_h
#ifdef HAVE_SYS_TIMEB_H
#include <sys/timeb.h>
#endif
#endif

#ifdef INCLUDE_sys_timers_h
#ifdef HAVE_SYS_TIMERS_H
#include <sys/timers.h>
#endif
#endif

#ifdef INCLUDE_time_h
#ifdef HAVE_TIME_H
#include <time.h>
#endif
#endif

#ifdef INCLUDE_sys_resource_h
#ifdef HAVE_SYS_RESOURCE_H
#include <sys/resource.h>
#endif
#endif

#ifdef INCLUDE_sys_stat_h
#ifdef HAVE_SYS_STAT_H
/* the following defines are useful on Linux to map stat to stat64 */
#define __USE_LARGEFILE64
#define __USE_FILE_OFFSET64
#include <sys/stat.h>
#endif
#endif

#ifdef INCLUDE_sys_wait_h
#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif
#endif

#ifdef INCLUDE_sys_mman_h
#ifdef HAVE_SYS_MMAN_H
#include <sys/mman.h>
#endif
#endif

#ifdef INCLUDE_stat_h
#ifdef HAVE_STAT_H
#include <stat.h>
#endif
#endif

#ifdef INCLUDE_signal_h
#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif
#endif

#ifdef INCLUDE_netdb_h
#ifdef HAVE_NETDB_H
#ifdef _AIX
/* AIX weirdness */
#define _USE_IRS
#endif
#include <netdb.h>
#define USE_h_errno
#ifdef __hpux
/* HP-UX weirdness */
extern int h_errno;
#ifndef NETDB_SUCCESS
#define NETDB_SUCCESS 0
#endif
#ifndef NETDB_INTERNAL
#ifdef NO_RECOVERY
#define NETDB_INTERNAL NO_RECOVERY
#endif
#endif
#endif
#endif
#endif

#ifdef INCLUDE_grp_h
#ifdef HAVE_GRP_H
#include <grp.h>
#endif
#endif

#ifdef INCLUDE_windows_h
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif
#endif

#ifdef INCLUDE_winsock2_h
#ifdef HAVE_WINSOCK2_H
#include <winsock2.h>
#endif
#endif

#ifdef INCLUDE_ws2tcpip_h
#ifdef HAVE_WS2TCPIP_H
#include <ws2tcpip.h>
#endif
#endif

#ifdef INCLUDE_io_h
#ifdef HAVE_IO_H
#include <io.h>
#endif
#endif

#ifdef INCLUDE_tchar_h
#ifdef HAVE_TCHAR_H
#include <tchar.h>
#endif
#endif

#ifdef INCLUDE_float_h
#ifdef HAVE_FLOAT_H
#include <float.h>
#endif
#endif

#ifdef INCLUDE_fpu_control_h
#ifdef HAVE_FPU_CONTROL_H
#include <fpu_control.h>
#else
/*
 * Some Linux distributions don't have the file "fpu_control.h".
 * Instead of including that file we explicitly define the macros we
 * need.
 */
#ifndef _FPU_CONTROL_H
#define _FPU_CONTROL_H
#define _FPU_MASK_IM  0x01
#define _FPU_MASK_DM  0x02
#define _FPU_MASK_ZM  0x04
#define _FPU_MASK_OM  0x08
#define _FPU_MASK_UM  0x10
#define _FPU_MASK_PM  0x20
#define _FPU_DOUBLE   0x200
#define _FPU_RC_NEAREST 0x0
typedef unsigned int fpu_control_t __attribute__ ((__mode__ (__HI__)));
#define _FPU_SETCW(cw) __asm__ ("fldcw %0" : : "m" (*&cw))
#endif
#endif
#endif

#ifdef INCLUDE_os2_h
#ifdef HAVE_OS2_H
#include <os2.h>
#endif
#endif

#ifdef INCLUDE_dos_h
#ifdef HAVE_DOS_H
#include <dos.h>
#endif
#endif

#ifdef INCLUDE_direct_h
#ifdef HAVE_DIRECT_H
#include <direct.h>
#endif
#endif

#ifdef INCLUDE_Retrace_h
#ifdef HAVE_RETRACE_H
#include <Retrace.h>
#endif
#endif

#ifdef INCLUDE_Files_h
#ifdef HAVE_FILES_H
#include <Files.h>
#endif
#endif

#ifdef INCLUDE_Finder_h
#ifdef HAVE_FINDER_H
#include <Finder.h>
#endif
#endif

#ifdef INCLUDE_Errors_h
#ifdef HAVE_ERRORS_H
#include <Errors.h>
#endif
#endif

#ifdef INCLUDE_Folders_h
#ifdef HAVE_FOLDERS_H
#include <Folders.h>
#endif
#endif

#ifdef INCLUDE_OSUtils_h
#ifdef HAVE_OSUTILS_H
#include <OSUtils.h>
#endif
#endif

#ifdef INCLUDE_Power_h
#ifdef HAVE_POWER_H
#include <Power.h>
#endif
#endif

#ifdef INCLUDE_CodeFragments_h
#ifdef HAVE_CODEFRAGMENTS_H
#include <CodeFragments.h>
#endif
#endif

#ifdef INCLUDE_SIOUX_h
#ifdef HAVE_SIOUX_H
#include <SIOUX.h>
#endif
#endif

#ifdef INCLUDE_mac_gui_h
#ifdef HAVE_MAC_GUI_H
#include "mac_gui.h"
#endif
#endif

#ifdef INCLUDE_unix_h
#ifdef HAVE_UNIX_H
#include <unix.h>
#endif
#endif

#ifdef INCLUDE_wdefwin_h
#ifdef HAVE_WDEFWIN_H
#include <wdefwin.h>
#endif
#endif

#ifdef INCLUDE_tfork_h
#ifdef HAVE_TFORK_H
#include <tfork.h>
#endif
#endif

#ifdef INCLUDE_curses_h
#ifdef HAVE_CURSES_H
#include <curses.h>
#endif
#endif

#ifdef INCLUDE_ncurses_h
#ifdef HAVE_NCURSES_H
#include <ncurses.h>
#endif
#endif

#ifdef INCLUDE_netinet_in_h
#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif
#endif

#ifdef INCLUDE_arpa_inet_h
#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif
#endif

#ifdef INCLUDE_sys_sysctl_h
#ifdef HAVE_SYS_SYSCTL_H
#include <sys/sysctl.h>
#endif
#endif

#ifdef INCLUDE_termios_h
#ifdef HAVE_TERMIOS_H
#include <termios.h>
#endif
#endif

#ifdef INCLUDE_term_h
#ifdef HAVE_TERM_H
#include <term.h>
#endif
#endif

#ifdef INCLUDE_pty_h
#ifdef HAVE_PTY_H
#include <pty.h>
#endif
#endif

#ifdef INCLUDE_stropts_h
#ifdef HAVE_STROPTS_H
#include <stropts.h>
#endif
#endif

#ifdef INCLUDE_libutil_h
#ifdef HAVE_LIBUTIL_H
#include <libutil.h>
#endif
#endif

#ifdef INCLUDE_util_h
#ifdef HAVE_UTIL_H
#include <util.h>
#endif
#endif

#ifdef INCLUDE_sys_fpu_h
#ifdef HAVE_SYS_FPU_H
#include <sys/fpu.h>
#endif
#endif

#ifdef INCLUDE_fenv_h
#ifdef HAVE_FENV_H
#include <fenv.h>
#endif
#endif

#ifdef INCLUDE_fcntl_h
#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif
#endif

#ifdef INCLUDE_sys_ioctl_h
#ifdef HAVE_SYS_IOCTL_H
#include <sys/ioctl.h>
#endif
#endif

#ifdef INCLUDE_sys_socket_h
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#endif

#ifdef INCLUDE_stdint_h
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#endif

#ifdef INCLUDE_stdlib_h
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#endif

#ifdef INCLUDE_string_h
#ifdef HAVE_STRING_H
#include <string.h>
#endif
#endif

#ifdef INCLUDE_strings_h
#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif
#endif

#ifdef INCLUDE_memory_h
#ifdef HAVE_MEMORY_H
#include <memory.h>
#endif
#endif

#ifdef INCLUDE_crt_externs_h
#ifdef HAVE_CRT_EXTERNS_H
#include <crt_externs.h>
#endif
#endif

#ifdef INCLUDE_poll_h
#ifdef HAVE_POLL_H
#include <poll.h>
#endif
#endif

#ifdef INCLUDE_openssl_ssl_h
#include <openssl/ssl.h>
#endif

#ifdef INCLUDE_openssl_dh_h
#ifndef OPENSSL_NO_DH
#include <openssl/dh.h>
#endif
#endif

#ifdef INCLUDE_openssl_ecdh_h
#if OPENSSL_VERSION_NUMBER >= 0x0090800fL
#ifndef OPENSSL_NO_ECDH
#include <openssl/ecdh.h>
#endif
#endif
#endif

#ifdef INCLUDE_openssl_rand_h
#include <openssl/rand.h>
#endif

#ifdef INCLUDE_openssl_err_h
#include <openssl/err.h>
#endif

/*
 * Use the process-time timer unless only the real-time timer is
 * available (e.g. DJGPP).  Note that on some systems (e.g. MkLinux)
 * ITIMER_VIRTUAL is an enum type, not a macro.
 */

#if defined(__CYGWIN__) || defined(__MACOSX__) || (defined(__APPLE__) && defined(__MACH__))
/* ITIMER_VIRTUAL is broken under CYGWIN and MacOS X... use ITIMER_REAL */
#undef ITIMER_VIRTUAL
#endif

#ifdef ITIMER_VIRTUAL
#define HEARTBEAT_ITIMER ITIMER_VIRTUAL
#define HEARTBEAT_SIG SIGVTALRM
#else
#ifdef ITIMER_REAL
#define HEARTBEAT_ITIMER ITIMER_REAL
#define HEARTBEAT_SIG SIGALRM
#else
#define HEARTBEAT_ITIMER ITIMER_VIRTUAL
#define HEARTBEAT_SIG SIGVTALRM
#endif
#endif


/*---------------------------------------------------------------------------*/

#define ___CHAR_TYPE(ce) \
ce(___ISO_8859_1,char,___UCS_2,___UCS_4,___WCHAR,char)

#define ___STRING_TYPE(ce) \
ce(___ISO_8859_1STRING,___UTF_8STRING,___UCS_2STRING,___UCS_4STRING,___WCHARSTRING,char*)

#define ___CE(ce) \
ce(___CHAR_ENCODING_ISO_8859_1, \
   ___CHAR_ENCODING_UTF_8, \
   ___CHAR_ENCODING_UCS_2, \
   ___CHAR_ENCODING_UCS_4, \
   ___CHAR_ENCODING_WCHAR, \
   ___CHAR_ENCODING_NATIVE)


extern ___SCMOBJ ___setup_os_interrupt_handling ___PVOID;

extern void ___cleanup_os_interrupt_handling ___PVOID;

extern void ___disable_os_interrupts ___PVOID;

extern void ___enable_os_interrupts ___PVOID;


/*---------------------------------------------------------------------------*/

/* Processor information. */

extern int ___processor_count ___PVOID;

extern int ___processor_cache_size
   ___P((___BOOL instruction_cache,
         int level),
        ());


/* Virtual memory statistics. */

extern void ___vm_stats
   ___P((___SIZE_TS *minflt,
         ___SIZE_TS *majflt),
        ());


/* Formatting of source code position. */

extern char *___format_filepos
   ___P((char *path,
         ___SIZE_TS filepos,
         ___BOOL pinpoint),
        ());


/* System type information. */

extern char **___os_system_type ___PVOID;
extern char *___os_system_type_string ___PVOID;
extern char *___os_configure_command_string ___PVOID;


/* C compilation environment information. */

extern char *___os_obj_extension_string ___PVOID;
extern char *___os_exe_extension_string ___PVOID;
extern char *___os_bat_extension_string ___PVOID;


/* OS initialization/finalization. */

extern ___SCMOBJ ___setup_os ___PVOID;
extern void ___cleanup_os ___PVOID;


/* Utilities for machine encoding of characters. */

/*
 * For now an ISO-8859-1 encoding of characters is assumed for
 * 'unsigned char'.  This means that the mapping to and from the
 * Unicode character set is the identity function.  To support other
 * machine representations, e.g. EBCDIC, these macros would have to
 * actually translate the characters.
 */

#define UCS_4_to_uchar(u)u
#define uchar_to_UCS_4(c)c


/*---------------------------------------------------------------------------*/

#endif
