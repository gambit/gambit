/* File: "os_time.h" */

/* Copyright (c) 1994-2017 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_TIME_H
#define ___OS_TIME_H

#include "os.h"


/*---------------------------------------------------------------------------*/


#define TIME_REFERENCE_POINT 1970

#define DAYS_UNTIL_JAN_1_2000(year) \
(730119 - ((year)-1)*365 - ((year)-1)/4 + ((year)-1)/100 - ((year)-1)/400)

#define DAYS_UNTIL_TIME_REFERENCE_POINT(year) \
(DAYS_UNTIL_JAN_1_2000(year) - DAYS_UNTIL_JAN_1_2000(TIME_REFERENCE_POINT))

#define JAN_1(year)(DAYS_UNTIL_TIME_REFERENCE_POINT(year) * 24 * 60 * 60)


/*---------------------------------------------------------------------------*/


#define ___FLOAT_TIME_REPRESENTATION


#ifdef ___DIVISION_BY_ZERO_WORKS_PROPERLY
#define POS_INFINITY (1.0/0.0)  /* positive infinity */
#define NEG_INFINITY (-1.0/0.0) /* negative infinity */
#else
#define POS_INFINITY (1.7976931348623157e308)  /* positive infinity */
#define NEG_INFINITY (-1.7976931348623157e308) /* negative infinity */
#endif


#ifdef ___FLOAT_TIME_REPRESENTATION

typedef ___F64 ___time;

#define TIME_POS_INFINITY POS_INFINITY
#define TIME_NEG_INFINITY NEG_INFINITY

#endif


#ifdef ___INT_TIME_REPRESENTATION

typedef struct ___time_struct
  {
    ___SM32 secs;
    ___SM32 nsecs;
  } ___time;

#define TIME_POS_INFINITY { 2147483647, 999999999 }
#define TIME_NEG_INFINITY { -2147483648, 0 }

#endif


/*---------------------------------------------------------------------------*/

typedef struct ___time_module_struct
  {
    ___BOOL setup;

    ___time time_pos_infinity;
    ___time time_neg_infinity;

    ___F64 process_start_seconds;  /* process start in real time */
    ___F64 current_heartbeat_interval;

    void (*heartbeat_interrupt_handler) ___PVOID;

#ifdef USE_dos_setvect_1Ch

    ___BOOL heartbeat_enabled;
    ___SIZE_TS heartbeat_interval;
    ___SIZE_TS heartbeat_countdown;
    void (__interrupt __far *prev_vector_1Ch) ___PVOID;

#define ___TIME_MODULE_INIT , 0, 0, 0, 0

#endif

#ifdef USE_DosStartTimer

    ___BOOL heartbeat_enabled;
    ___BOOL heartbeat_hev;
    ___BOOL heartbeat_tid;
    ___BOOL heartbeat_htimer;
    HEV    hev;
    TID    tid;
    HTIMER htimer;

#define ___TIME_MODULE_INIT , 0, 0, 0, 0, 0, 0, 0

#endif

#ifdef USE_VInstall

    ___BOOL heartbeat_enabled;
    ___BOOL heartbeat_task_installed;
    short heartbeat_task_ticks;
    VBLTask heartbeat_task;

#define ___TIME_MODULE_INIT , 0, 0, 0, 0

#endif

#ifdef USE_CreateThread

    ___BOOL heartbeat_enabled;
    DWORD heartbeat_interval;
    HANDLE heartbeat_thread;
    HANDLE heartbeat_update; /* heartbeat needs updating when signaled */

#define ___TIME_MODULE_INIT , 0, 0, 0, 0

#endif
  } ___time_module;


extern ___time_module ___time_mod;


/*---------------------------------------------------------------------------*/

/* Time management. */


extern void ___time_from_nsecs
   ___P((___time *tim,
         ___SM32 secs,
         ___SM32 nsecs),
        ());

extern void ___time_add
   ___P((___time *tim1,
         ___time tim2),
        ());

extern void ___time_subtract
   ___P((___time *tim1,
         ___time tim2),
        ());

extern ___BOOL ___time_equal
   ___P((___time tim1,
         ___time tim2),
        ());

extern ___BOOL ___time_less
   ___P((___time tim1,
         ___time tim2),
        ());

extern ___BOOL ___time_positive
   ___P((___time tim),
        ());

extern void ___time_get_current_time
   ___P((___time *tim),
        ());

extern ___U64 ___time_get_monotonic_time ___PVOID;

extern ___U64 ___time_get_monotonic_time_frequency ___PVOID;

extern ___F64 ___time_to_seconds
   ___P((___time tim),
        ());

extern void ___time_from_seconds
   ___P((___time *tim,
         ___F64 seconds),
        ());

extern void ___process_times
   ___P((___F64 *user,
         ___F64 *sys,
         ___F64 *real),
        ());

extern ___F64 ___get_heartbeat_interval ___PVOID;

extern void ___set_heartbeat_interval
   ___P((___F64 seconds),
        ());

extern void ___absolute_time_to_relative_time
   ___P((___time tim,
         ___time *rtim),
        ());

#ifndef LINEEDITOR_WITH_NONBLOCKING_IO

extern void ___absolute_time_sleep
   ___P((___time tim),
        ());

#endif

#ifdef USE_timeval

extern void ___absolute_time_to_timeval
   ___P((___time tim,
         struct timeval *tv),
        ());

extern void ___absolute_time_to_nonnegative_timeval_maybe_NULL
   ___P((___time tim,
         struct timeval **tv),
        ());

#endif

#ifdef USE_MsgWaitForMultipleObjects

extern void ___absolute_time_to_nonnegative_msecs
   ___P((___time tim,
         DWORD *ms),
        ());

#endif

#ifdef USE_FILETIME

extern void ___time_to_FILETIME
   ___P((___time tim,
         FILETIME *ft),
        ());

extern void ___time_from_FILETIME
   ___P((___time *tim,
         FILETIME ft),
        ());

extern ___F64 ___FILETIME_to_seconds
   ___P((FILETIME ft),
        ());

#endif


/*---------------------------------------------------------------------------*/

/* Measurement of process times. */


extern void ___process_times
   ___P((___F64 *user,
         ___F64 *sys,
         ___F64 *real),
        ());


/*---------------------------------------------------------------------------*/

/* Heartbeat interrupt handling. */


extern ___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID;

extern void ___cleanup_heartbeat_interrupt_handling ___PVOID;


/*---------------------------------------------------------------------------*/

/* Time module initialization/finalization. */


extern ___SCMOBJ ___setup_time_module
   ___P((void (*heartbeat_interrupt_handler) ___PVOID),
        ());

extern void ___cleanup_time_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
