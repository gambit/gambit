/* File: "os_time.c" */

/* Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to time.
 */

#define ___INCLUDED_FROM_OS_TIME
#define ___VERSION 408006
#include "gambit.h"

#include "os_thread.h"
#include "os_base.h"
#include "os_time.h"


/*---------------------------------------------------------------------------*/


___time_module ___time_mod =
{
  0,
  TIME_POS_INFINITY,
  TIME_NEG_INFINITY,
  0.0,
  -1.0,
  NULL

#ifdef ___TIME_MODULE_INIT
  ___TIME_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

/* Time management. */


void ___time_from_nsecs
   ___P((___time *tim,
         ___SM32 secs,
         ___SM32 nsecs),
        (tim,
         secs,
         nsecs)
___time *tim;
___SM32 secs;
___SM32 nsecs;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  *tim = secs + nsecs / 1000000000.0;
#endif

#ifdef ___INT_TIME_REPRESENTATION
  tim->secs = secs + nsecs / 1000000000;
  tim->nsecs = nsecs % 1000000000;
#endif
}


void ___time_add
   ___P((___time *tim1,
         ___time tim2),
        (tim1,
         tim2)
___time *tim1;
___time tim2;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  *tim1 += tim2;
#endif

#ifdef ___INT_TIME_REPRESENTATION
  ___SM32 total_secs = tim1->secs + tim2.secs;
  ___SM32 total_nsecs = tim1->nsecs + tim2.nsecs;
  tim1->secs += tim2.secs + total_nsecs / 1000000000;
  tim1->nsecs = total_nsecs % 1000000000;
#endif
}


void ___time_subtract
   ___P((___time *tim1,
         ___time tim2),
        (tim1,
         tim2)
___time *tim1;
___time tim2;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  *tim1 -= tim2;
#endif

#ifdef ___INT_TIME_REPRESENTATION
  ___SM32 total_nsecs;

  if (tim2.nsecs > tim1->nsecs)
    {
      tim1->secs -= tim2.secs + 1;
      tim1->nsecs += 1000000000 - tim2.nsecs;
    }
  else
    {
      tim1->secs -= tim2.secs;
      tim1->nsecs -= tim2.nsecs;
    }
#endif
}


___BOOL ___time_equal
   ___P((___time tim1,
         ___time tim2),
        (tim1,
         tim2)
___time tim1;
___time tim2;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  return (tim1 == tim2);
#endif

#ifdef ___INT_TIME_REPRESENTATION
  return (tim1.secs == tim2.secs && tim1.nsecs == tim2.nsecs);
#endif
}


___BOOL ___time_less
   ___P((___time tim1,
         ___time tim2),
        (tim1,
         tim2)
___time tim1;
___time tim2;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  return (tim1 < tim2);
#endif

#ifdef ___INT_TIME_REPRESENTATION
  return (tim1.secs < tim2.secs ||
          (tim1.secs == tim2.secs && tim1.nsecs < tim2.nsecs));
#endif
}


___BOOL ___time_positive
   ___P((___time tim),
        (tim)
___time tim;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  return (tim > 0.0);
#endif

#ifdef ___INT_TIME_REPRESENTATION
  return (tim.secs > 0 ||
          (tim.secs == 0 && tim.nsecs > 0));
#endif
}


void ___time_get_current_time
   ___P((___time *tim),
        (tim)
___time *tim;)
{
#ifndef USE_clock_gettime_realtime
#ifndef USE_getclock
#ifndef USE_GetSystemTimeAsFileTime
#ifndef USE_gettimeofday
#ifndef USE_ftime
#ifndef USE_time
#ifndef USE_CLASSIC_MACOS

  *tim = ___time_mod.time_neg_infinity;

#endif
#endif
#endif
#endif
#endif
#endif
#endif

#ifdef USE_clock_gettime_realtime

  /* The clock_gettime function is in POSIX.1b (realtime programming). */

  struct timespec ts;
  if (clock_gettime (CLOCK_REALTIME, &ts) == 0)
    ___time_from_nsecs (tim, ts.tv_sec-JAN_1(1970), ts.tv_nsec);
  else
    *tim = ___time_mod.time_neg_infinity;

#endif

#ifdef USE_getclock

  /* The getclock function is in the Tru64 UNIX standard C library. */

  struct timespec ts;
  if (getclock (TIMEOFDAY, &ts) == 0)
    ___time_from_nsecs (tim, ts.tv_sec-JAN_1(1970), ts.tv_nsec);
  else
    *tim = ___time_mod.time_neg_infinity;

#endif

#ifdef USE_GetSystemTimeAsFileTime

  FILETIME ft;
  GetSystemTimeAsFileTime (&ft);
  ___time_from_FILETIME (tim, ft);

#endif

#ifdef USE_gettimeofday

  struct timeval tv;
  if (gettimeofday (&tv, NULL) == 0)
    ___time_from_nsecs (tim, tv.tv_sec-JAN_1(1970), tv.tv_usec*1000);
  else
    *tim = ___time_mod.time_neg_infinity;

#endif

#ifdef USE_ftime

  struct timeb tb;
  ftime (&tb);
  ___time_from_nsecs (tim, tb.time-JAN_1(1970), tb.millitm*1000000);

#endif

#ifdef USE_time

  time_t t;
  time (&t);
  ___time_from_nsecs (tim, t-JAN_1(1970), 0);

#endif

#ifdef USE_CLASSIC_MACOS

  if (has_GetUTCDateTime)
    {
      UTCDateTime dt;

      if (GetUTCDateTime (&dt, kUTCDefaultOptions) == noErr)
        ___time_from_nsecs (tim,
                            dt.lowSeconds-JAN_1(1904),
                            ___CAST(___SM32,dt.fraction)*15258 +
                            ((___CAST(___SM32,dt.fraction)*101)>>7));
      else
        *tim = ___time_mod.time_neg_infinity;
    }
  else if (has_GetDateTime)
    {
      unsigned long t;

      GetDateTime (&t);  /* Get seconds since 01-01-1904 in local time. */

      if (has_ReadLocation)
        {
          /* Adjust to UTC based on machine location. */

          MachineLocation here;
          long offset;

          ReadLocation (&here);
          offset = here.u.gmtDelta & 0x00ffffff;
          if (offset & 0x00800000)
            offset |= 0xff000000;
          t -= offset;
        }

      ___time_from_nsecs (tim, t-JAN_1(1904), 0);
    }
  else
    *tim = ___time_mod.time_neg_infinity;

#endif
}


___U64 ___time_get_monotonic_time ___PVOID
{
#ifndef USE_mach_absolute_time
#ifndef USE_QueryPerformanceCounter
#ifndef USE_clock_gettime_monotonic

  ___time tim;

  ___time_get_current_time (&tim);

#ifdef ___FLOAT_TIME_REPRESENTATION

  return ___U64_from_ULONGLONG(tim*1e9);

#endif

#ifdef ___INT_TIME_REPRESENTATION

  return ___U64_add_U64_U64(___U64_mul_UM32_UM32(tim.secs, 1000000000),
                            ___U64_from_UM32(tim.nsecs));

#endif

#endif
#endif
#endif

#ifdef USE_mach_absolute_time

  return mach_absolute_time ();

#endif

#ifdef USE_QueryPerformanceCounter

  LARGE_INTEGER count;

  if (QueryPerformanceCounter (&count))
    return ___U64_from_ULONGLONG(count.QuadPart);
  else
    return ___U64_from_UM32(0);

#endif

#ifdef USE_clock_gettime_monotonic

  /* The clock_gettime function is in POSIX.1b (realtime programming). */

  struct timespec ts;

  if (clock_gettime (CLOCK_MONOTONIC, &ts) == 0)
    return ___U64_add_U64_U64(___U64_mul_UM32_UM32(ts.tv_sec, 1000000000),
                              ___U64_from_UM32(ts.tv_nsec));
  else
    return ___U64_from_UM32(0);

#endif
}


___U64 ___time_get_monotonic_time_frequency ___PVOID
{
#ifndef USE_mach_absolute_time
#ifndef USE_QueryPerformanceCounter
#ifndef USE_clock_gettime_monotonic

  return ___U64_from_UM32(1000000000);

#endif
#endif
#endif

#ifdef USE_mach_absolute_time

  mach_timebase_info_data_t info;

  mach_timebase_info (&info);

  return ___U64_from_ULONGLONG(1000000000ULL * info.denom / info.numer);

#endif

#ifdef USE_QueryPerformanceCounter

  LARGE_INTEGER freq;

  if (QueryPerformanceFrequency (&freq))
    return ___U64_from_ULONGLONG(freq.QuadPart);
  else
    return ___U64_from_UM32(1);

#endif

#ifdef USE_clock_gettime_monotonic

  /* The clock_getres function is in POSIX.1b (realtime programming). */

  struct timespec ts;

  if (clock_getres (CLOCK_MONOTONIC, &ts) == 0)
    return ___U64_from_ULONGLONG(1000000000ULL / (1000000000ULL * ts.tv_sec + ts.tv_nsec));
  else
    return ___U64_from_UM32(1);

#endif
}


___F64 ___time_to_seconds
   ___P((___time tim),
        (tim)
___time tim;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  return tim;
#endif

#ifdef ___INT_TIME_REPRESENTATION
  return tim.secs + tim.nsecs / 1000000000.0;
#endif
}


void ___time_from_seconds
   ___P((___time *tim,
         ___F64 seconds),
        (tim,
         seconds)
___time *tim;
___F64 seconds;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION
  *tim = seconds;
#endif

#ifdef ___INT_TIME_REPRESENTATION
  if (seconds >= 2147483648.0) /* more than 68 years is pos infinity! */
    *tim = ___time_mod.time_pos_infinity;
  else if (seconds < -2147483648.0) /* less than -68 years is neg infinity! */
    *tim = ___time_mod.time_neg_infinity;
  else
    {
      ___SM32 secs = seconds;
      ___SM32 nsecs = (seconds - secs) * 1000000000.0;
      if (nsecs < 0)
        {
          secs--;
          nsecs += 1000000000;
        }
      tim->secs = secs;
      tim->nsecs = nsecs;
    }
#endif
}


void ___absolute_time_to_relative_time
   ___P((___time tim,
         ___time *rtim),
        (tim,
         rtim)
___time tim;
___time *rtim;)
{
  if (___time_less (tim, ___time_mod.time_pos_infinity))
    {
      ___time now;
      *rtim = tim;
      ___time_get_current_time (&now);
      ___time_subtract (rtim, now);
    }
  else
    *rtim = ___time_mod.time_pos_infinity;
}


#ifndef LINEEDITOR_WITH_NONBLOCKING_IO


void ___absolute_time_sleep
   ___P((___time tim),
        (tim)
___time tim;)
{
  ___absolute_time_to_relative_time (tim, &tim);

  if (___time_positive (tim))
    {
      ___SM32 nsecs;

#ifdef ___FLOAT_TIME_REPRESENTATION
      if (tim > 2.0)
        nsecs = 2000000000;
      else
        nsecs = ___CAST(___SM32,tim * 1000000000.0);
#endif

#ifdef ___INT_TIME_REPRESENTATION
      if (tim.secs > 2)
        nsecs = 2000000000;
      else
        nsecs = tim.secs * 1000000000 + tim.nsecs;
#endif

#ifndef USE_nanosleep
#ifndef USE_Sleep
#ifndef USE_sleep
#ifndef USE_CLASSIC_MACOS
      /* Can't sleep... so stay awake! */
#endif
#endif
#endif
#endif

#ifdef USE_nanosleep
      {
        /* The nanosleep function is in POSIX.1b (realtime programming). */
        struct timespec ts;
        ts.tv_sec = nsecs / 1000000000;
        ts.tv_nsec = nsecs;
        nanosleep (&ts, NULL);
      }
#endif

#ifdef USE_Sleep
      Sleep (nsecs / 1000000);
#endif

#ifdef USE_sleep
      sleep (nsecs / 1000000000);
#endif

#ifdef USE_CLASSIC_MACOS
      {
        ___U32 ticks = nsecs / 16666666;
        if (has_IdleUpdate)
          IdleUpdate ();
        if (has_WaitNextEvent)
          {
            EventRecord er;
            WaitNextEvent (0, &er, ticks, NULL);
          }
        else if (has_Delay)
          Delay (ticks, &ticks);
      }
#endif
    }
}


#endif


#ifdef USE_timeval


void ___absolute_time_to_timeval
   ___P((___time tim,
         struct timeval *tv),
        (tim,
         tv)
___time tim;
struct timeval *tv;)
{
#ifdef ___FLOAT_TIME_REPRESENTATION

  if (tim < -2147483648.0)
    tim = -2147483648.0;
  else if (tim > 2147483647.999999)
    tim = 2147483647.999999;

  tv->tv_sec = ___CAST(int,tim);
  tv->tv_usec = ___CAST(int,(tim - tv->tv_sec) * 1000000.0);

#endif

#ifdef ___INT_TIME_REPRESENTATION

  tv->tv_sec = tim.secs;
  tv->tv_usec = tim.nsecs / 1000;

#endif
}


void ___absolute_time_to_nonnegative_timeval_maybe_NULL
   ___P((___time tim,
         struct timeval **tv),
        (tim,
         tv)
___time tim;
struct timeval **tv;)
{
  if (___time_less (tim, ___time_mod.time_pos_infinity))
    {
      struct timeval *t = *tv;

      if (___time_positive (tim))
        {
          ___absolute_time_to_timeval (tim, t);

#ifndef ___TIMEVAL_NOT_LIMITED

/* Mac OS X gives an error when the seconds > 100000000 (3.2 years) */
/* We'll be conservative in case other systems have limits */

#define ___TIMEVAL_SEC_LIMIT 9999999 /* in seconds = 118 days */

          if (t->tv_sec > ___TIMEVAL_SEC_LIMIT)
            {
              t->tv_sec = ___TIMEVAL_SEC_LIMIT;
              t->tv_usec = 999999;
            }

#endif
        }
      else
        {
          /* prevent negative timeval */
          t->tv_sec = 0;
          t->tv_usec = 0;
        }
    }
  else
    *tv = NULL;
}


#endif


#ifdef USE_MsgWaitForMultipleObjects


void ___absolute_time_to_nonnegative_msecs
   ___P((___time tim,
         DWORD *ms),
        (tim,
         ms)
___time tim;
DWORD *ms;)
{
  if (___time_less (tim, ___time_mod.time_pos_infinity))
    {
      if (___time_positive (tim))
        {
#ifdef ___FLOAT_TIME_REPRESENTATION

          ___F64 msecs = tim * 1000.0;

          if (msecs >= 4294967294.0) /* upper bound is 49.6 days! */
            *ms = 4294967294UL; /* note that INFINITE = 4294967295 */
          else
            *ms = ___CAST(DWORD,msecs);

#endif

#ifdef ___INT_TIME_REPRESENTATION

          if (tim.secs > 4294968 || /* upper bound is 49.6 days! */
              (tim.secs == 4294967 && tim.nsecs >= 294000000))
            *ms = 4294967294UL; /* note that INFINITE = 4294967295 */
          else
            *ms = tim.secs * 1000 + tim.nsecs / 1000000;

#endif
        }
      else
        *ms = 0; /* prevent negative msecs */
    }
  else
    *ms = INFINITE;
}


#endif


#ifdef USE_FILETIME


void ___time_to_FILETIME
   ___P((___time tim,
         FILETIME *ft),
        (tim,
         ft)
___time tim;
FILETIME *ft;)
{
  *___CAST(LONGLONG*,ft) = (___time_to_seconds (tim) + JAN_1(1601LL)) * 1.0e7;
}


void ___time_from_FILETIME
   ___P((___time *tim,
         FILETIME ft),
        (tim,
         ft)
___time *tim;
FILETIME ft;)
{
  LONGLONG x = *___CAST(LONGLONG*,&ft);
  ___time_from_nsecs (tim,
                      x / 10000000 - JAN_1(1601LL),
                      x % 10000000 * 100);
}


___F64 ___FILETIME_to_seconds
   ___P((FILETIME ft),
        (ft)
FILETIME ft;)
{
  return *___CAST(LONGLONG*,&ft) / 1.0e7;
}


#endif



___HIDDEN void setup_time_management ___PVOID
{
#ifdef USE_HIGH_RES_TIMING
#ifdef HAVE_TIMEBEGINPERIOD

  /*
   * On Windows, timers have a resolution that depends on the version
   * of the OS.  A test program gives a resolution of 10 ms on Windows
   * XP, 16 ms on Windows 7, and 1 ms on Windows 8.  Calling
   * timeBeginPeriod (1) will set the resolution to 1 ms (at least
   * according to the Windows documentation and documents found on the
   * web).  However this seems to improve the resolution by very
   * little, or not at all, in some environments.  So YMMV.
   */

  timeBeginPeriod (1); /* ignore error */

#endif
#endif
}


___HIDDEN void cleanup_time_management ___PVOID
{
#ifdef USE_HIGH_RES_TIMING
#ifdef HAVE_TIMEBEGINPERIOD
  timeEndPeriod (1); /* ignore error */
#endif
#endif
}


/*---------------------------------------------------------------------------*/

/* Measurement of process times. */


void ___process_times
   ___P((___F64 *user,
         ___F64 *sys,
         ___F64 *real),
        (user,
         sys,
         real)
___F64 *user;
___F64 *sys;
___F64 *real;)
{
#ifndef USE_GetProcessTimes
#ifndef USE_getrusage
#ifndef USE_times
#ifndef USE_clock
#ifndef USE_DosQuerySysInfo
#ifndef USE_CLASSIC_MACOS

  *user = 0.0; /* can't get time... result is 0 */
  *sys = 0.0;

#endif
#endif
#endif
#endif
#endif
#endif

#ifdef USE_GetProcessTimes

  HANDLE p;
  FILETIME creation_time, exit_time, sys_time, user_time;

  p = GetCurrentProcess ();

  if (GetProcessTimes (p, &creation_time, &exit_time, &sys_time, &user_time))
    {
      *user = ___FILETIME_to_seconds (user_time);
      *sys = ___FILETIME_to_seconds (sys_time);
    }
  else
    {
      *user = 0.0; /* can't get time... result is 0 */
      *sys = 0.0;
    }

#endif

#ifdef USE_getrusage

  struct rusage ru;

  if (getrusage (RUSAGE_SELF, &ru) == 0)
    {
      *user = ru.ru_utime.tv_sec + ___CAST(___F64,ru.ru_utime.tv_usec) / 1.0e6;
      *sys = ru.ru_stime.tv_sec + ___CAST(___F64,ru.ru_stime.tv_usec) / 1.0e6;
    }
  else
    {
      *user = 0.0; /* can't get time... result is 0 */
      *sys = 0.0;
    }

#endif

#ifdef USE_times

#ifdef CLK_TCK
#define CLOCK_TICKS_PER_SEC CLK_TCK
#else
#ifdef USE_sysconf
#ifdef _SC_CLK_TCK
#define CLOCK_TICKS_PER_SEC sysconf (_SC_CLK_TCK)
#else
#ifdef _SC_CLOCKS_PER_SEC
#define CLOCK_TICKS_PER_SEC sysconf (_SC_CLOCKS_PER_SEC)
#endif
#endif
#endif
#endif

#ifndef CLOCK_TICKS_PER_SEC
@error Cannot find a definition for CLOCK_TICKS_PER_SEC
#endif

  struct tms t;

  static long clock_ticks_per_sec = 0;

  if (clock_ticks_per_sec == 0)
    clock_ticks_per_sec = CLOCK_TICKS_PER_SEC;

  times (&t);

  *user = ___CAST(___F64,t.tms_utime) / clock_ticks_per_sec;
  *sys = ___CAST(___F64,t.tms_stime) / clock_ticks_per_sec;

#endif

#ifdef USE_clock

  *user = ___CAST(___F64,clock ()) / CLOCKS_PER_SEC;
  *sys = 0.0; /* fake system time */

#endif

#ifdef USE_DosQuerySysInfo

  static ___U32 origin = 0;
  ___U32 now;

  while (origin == 0)
    DosQuerySysInfo (QSV_MS_COUNT, QSV_MS_COUNT, &origin, sizeof (origin));

  DosQuerySysInfo (QSV_MS_COUNT, QSV_MS_COUNT, &now, sizeof (now));

  *user = ___CAST(___F64,(now-origin)) / 1.0e3; /* are the units right? */
  *sys = 0.0; /* fake system time */

#endif

#ifdef USE_CLASSIC_MACOS

  static ___U32 origin = 0;
  ___U32 now;

  while (origin == 0)
    origin = TickCount ();

  now = TickCount ();

  *user = ___CAST(___F64,(now-origin)) / 60;
  *sys = 0.0; /* fake system time */

#endif

  {
    ___time now;

    ___time_get_current_time (&now);

    *real = ___time_to_seconds (now) - ___time_mod.process_start_seconds;
  }
}


___HIDDEN void setup_process_times ___PVOID
{
  ___F64 user, sys;

  ___time_mod.process_start_seconds = 0.0;
  ___process_times (&user, &sys, &___time_mod.process_start_seconds);

}


___HIDDEN void cleanup_process_times ___PVOID
{
}


/*---------------------------------------------------------------------------*/

/* Heartbeat interrupt handling. */


#ifndef USE_setitimer
#ifndef USE_dos_setvect_1Ch
#ifndef USE_DosStartTimer
#ifndef USE_VInstall
#ifndef USE_CreateThread


___F64 ___set_heartbeat_interval
   ___P((___F64 seconds),
        (seconds)
___F64 seconds;)
{
  ___time_mod.current_heartbeat_interval = seconds;
  return 0.0;
}


void ___mask_heartbeat_interrupts_begin
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
}


void ___mask_heartbeat_interrupts_end
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
}


___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID
{
  return ___FIX(___NO_ERR);
}


void ___cleanup_heartbeat_interrupt_handling ___PVOID
{
}


#endif
#endif
#endif
#endif
#endif


#ifdef USE_setitimer


___HIDDEN void heartbeat_interrupt_handler
   ___P((int sig),
        (sig)
int sig;)
{
#ifdef USE_signal
  ___set_signal_handler (HEARTBEAT_SIG, heartbeat_interrupt_handler);
#endif

  ___time_mod.heartbeat_interrupt_handler ();
}


___F64 ___set_heartbeat_interval
   ___P((___F64 seconds),
        (seconds)
___F64 seconds;)
{
  struct itimerval tv;

  ___time_mod.current_heartbeat_interval = seconds;

  if (seconds < 0.0) /* turn heartbeat off */
    {
      tv.it_interval.tv_sec  = 0;
      tv.it_interval.tv_usec = 0;
      tv.it_value.tv_sec     = 0;
      tv.it_value.tv_usec    = 0;
      setitimer (HEARTBEAT_ITIMER, &tv, 0);
      return 0.0;
    }
  else
    {
      int secs;
      int usecs;

      if (seconds >= 2147483648.0) /* upper bound is 68 years! */
        {
          secs = 2147483647;
          usecs = 999999;
        }
      else
        {
          secs = ___CAST(int,seconds);
          usecs = ___CAST(int,(seconds - secs) * 1000000.0);
          if (secs <= 0 && usecs < 1) /* use smallest interval */
            {
              secs = 0;
              usecs = 1;
            }
        }

      tv.it_interval.tv_sec  = secs;
      tv.it_interval.tv_usec = usecs;
      tv.it_value.tv_sec     = secs;
      tv.it_value.tv_usec    = usecs;
      setitimer (HEARTBEAT_ITIMER, &tv, 0);
      getitimer (HEARTBEAT_ITIMER, &tv);
      return tv.it_interval.tv_sec + tv.it_interval.tv_usec / 1000000.0;
    }
}


void ___mask_heartbeat_interrupts_begin
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
#ifdef USE_POSIX

  ___sigset_type toblock;

  sigemptyset (&toblock);
  sigaddset (&toblock, HEARTBEAT_SIG);

  ___thread_sigmask (SIG_BLOCK, &toblock, &state->oldmask);

#endif
}


void ___mask_heartbeat_interrupts_end
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
#ifdef USE_POSIX

  ___thread_sigmask (SIG_SETMASK, &state->oldmask, 0);

#endif
}


___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID
{
  ___set_heartbeat_interval (___time_mod.current_heartbeat_interval);

#ifdef USE_POSIX
  ___set_signal_handler (HEARTBEAT_SIG, heartbeat_interrupt_handler);
#endif

  return ___FIX(___NO_ERR);
}


void ___cleanup_heartbeat_interrupt_handling ___PVOID
{
  ___F64 save_heartbeat_interval = ___time_mod.current_heartbeat_interval;

  ___set_heartbeat_interval (-1.0);

  ___time_mod.current_heartbeat_interval = save_heartbeat_interval;

#ifdef USE_POSIX
  ___set_signal_handler (HEARTBEAT_SIG, SIG_IGN);
#endif

}


#endif


#ifdef USE_dos_setvect_1Ch


/* 1Ch = timer tick vector */


___HIDDEN void __interrupt __far heartbeat_interrupt_handler ___PVOID
{
  if (___time_mod.heartbeat_countdown > 1)
    ___time_mod.heartbeat_countdown--;
  else if (___time_mod.heartbeat_countdown == 1
           && ___time_mod.heartbeat_enabled)
    {
      ___time_mod.heartbeat_countdown = ___time_mod.heartbeat_interval;
      ___time_mod.heartbeat_interrupt_handler ();
    }
  _chain_intr (prev_vector_1Ch);
}


___F64 ___set_heartbeat_interval
   ___P((___F64 seconds),
        (seconds)
___F64 seconds;)
{
  ___time_mod.current_heartbeat_interval = seconds;

  if (seconds < 0.0) /* turn heartbeat off */
    {
      _dos_setvect (0x1C, prev_vector_1Ch);
      return 0.0;
    }
  else
    {
      ___F64 ticks = seconds * 18.2; /* 18.2 ticks/sec */
      int t;

      if (ticks >= 2147483648.0) /* upper bound is 3.7 years! */
        t = 2147483647;
      else
        {
          t = ticks;
          if (t <= 0) /* use smallest interval */
            t = 1;
        }

      ___time_mod.heartbeat_interval = t;
      ___time_mod.heartbeat_countdown = ___time_mod.heartbeat_interval;
      _dos_setvect (0x1C, ___time_mod.heartbeat_interrupt_handler);
      return t / 18.2;
    }
}


void ___mask_heartbeat_interrupts_begin
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 0;
}


void ___mask_heartbeat_interrupts_end
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 1;
}


___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID
{
  prev_vector_1Ch = _dos_getvect (0x1C);
  ___time_mod.heartbeat_enabled = 1;
  ___set_heartbeat_interval (-1.0);
  return ___FIX(___NO_ERR);
}


void ___cleanup_heartbeat_interrupt_handling ___PVOID
{
  ___set_heartbeat_interval (-1.0);
  ___time_mod.heartbeat_enabled = 0;
}


#endif


#ifdef USE_DosStartTimer


___HIDDEN void APIENTRY heartbeat_thread_code
   ___P((ULONG param),
        (param)
ULONG param;)
{
  ULONG pc = 0;
  for (;;)
    {
      DosWaitEventSem (___time_mod.hev, SEM_INDEFINITE_WAIT);
      DosResetEventSem (___time_mod.hev, &pc);
      if (___time_mod.heartbeat_enabled)
        {
          DosEnterCritSec ();
          ___time_mod.heartbeat_interrupt_handler ();
          DosExitCritSec ();
        }
    }
}


___F64 ___set_heartbeat_interval
   ___P((___F64 seconds),
        (seconds)
___F64 seconds;)
{
  ___time_mod.current_heartbeat_interval = seconds;

  if (!___time_mod.heartbeat_hev || !___time_mod.heartbeat_tid)
    return 0.0;
  if (___time_mod.heartbeat_htimer)
    {
      DosStopTimer (___time_mod.htimer);
      ___time_mod.heartbeat_htimer = 0;
    }
  if (seconds < 0.0) /* turn heartbeat off */
    return 0.0;
  else
    {
      ___F64 msecs = seconds * 1000.0;
      ULONG m;

      if (msecs >= 4294967295.0) /* upper bound is 49.7 days! */
        m = 4294967295;
      else
        {
          m = msecs;
          if (m == 0) /* use smallest interval */
            m = 1;
        }

      if (DosStartTimer (m, ___CAST(HSEM,___time_mod.hev), &___time_mod.htimer)
          == NO_ERROR)
        {
          ___time_mod.heartbeat_htimer = 1;
          return m / 1000.0;
        }
      else
        return 0.0;
    }
}


void ___mask_heartbeat_interrupts_begin
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 0;
}


void ___mask_heartbeat_interrupts_end
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 1;
}


___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID
{
  ___time_mod.heartbeat_enabled = 0;
  ___time_mod.heartbeat_hev     = 0;
  ___time_mod.heartbeat_tid     = 0;
  ___time_mod.heartbeat_htimer  = 0;
  if (DosCreateEventSem (0, &___time_mod.hev, DC_SEM_SHARED, FALSE) != NO_ERROR)
    return ___FIX(___UNKNOWN_ERR);
  ___time_mod.heartbeat_hev = 1;
  if (DosCreateThread (&___time_mod.tid,
                       heartbeat_thread_code,
                       0,
                       CREATE_READY|STACK_COMMITTED,
                       4096)
      != NO_ERROR)
    return ___FIX(___UNKNOWN_ERR);
  ___time_mod.heartbeat_tid = 1;
  DosSetPriority (PRTYS_THREAD, PRTYC_NOCHANGE, PRTYD_MAXIMUM, ___time_mod.tid);
  ___time_mod.heartbeat_enabled = 1;

  return ___FIX(___NO_ERR);
}


void ___cleanup_heartbeat_interrupt_handling ___PVOID
{
  ___time_mod.heartbeat_enabled = 0;
  if (___time_mod.heartbeat_htimer)
    {
      DosStopTimer (___time_mod.htimer);
      ___time_mod.heartbeat_htimer = 0;
    }
  if (___time_mod.heartbeat_tid)
    {
      DosKillThread (___time_mod.tid);
      ___time_mod.heartbeat_tid = 0;
    }
  if (___time_mod.heartbeat_hev)
    {
      DosCloseEventSem (___time_mod.hev);
      ___time_mod.heartbeat_hev = 0;
    }
}


#endif


#ifdef USE_VInstall


___HIDDEN ___BOOL heartbeat_task_installed;
___HIDDEN short heartbeat_task_ticks;
___HIDDEN VBLTask heartbeat_task;
___HIDDEN ___BOOL heartbeat_enabled;


___HIDDEN void heartbeat_task_code ___PVOID
{
  if (___time_mod.heartbeat_enabled)
    ___time_mod.heartbeat_interrupt_handler ();
  ___time_mod.heartbeat_task.vblCount = ___time_mod.heartbeat_task_ticks;
}


#ifdef __POWERPC__

#define heartbeat_task_proc heartbeat_task_code

#else

___HIDDEN asm void heartbeat_task_proc ___PVOID
{
    move.l a5,-(sp)
    move.l 0x904,a5
    jsr    heartbeat_task_code
    move.l (sp)+,a5
    rts
}

#endif


___F64 ___set_heartbeat_interval
   ___P((___F64 seconds),
        (seconds)
___F64 seconds;)
{
  ___time_mod.current_heartbeat_interval = seconds;

  if (___time_mod.heartbeat_task_installed)
    if (VRemove (___CAST(QElemPtr,&___time_mod.heartbeat_task)) != noErr)
      {
        ___time_mod.heartbeat_task_installed = 0;
        return 0.0;
      }

  if (seconds < 0.0) /* turn heartbeat off */
    return 0.0;
  else
    {
      ___F64 ticks = seconds * 60.0; /* 60 ticks/sec */
      short t;

      if (ticks >= 32767.0) /* upper bound is 9 minutes! */
        t = 32767;
      else
        {
          t = ticks;
          if (t <= 0) /* use smallest interval */
            t = 1;
        }

      ___time_mod.heartbeat_task_ticks    = t;
      ___time_mod.heartbeat_task.qType    = vType;
      ___time_mod.heartbeat_task.vblAddr  = NewVBLProc (heartbeat_task_proc);
      ___time_mod.heartbeat_task.vblCount = t;
      ___time_mod.heartbeat_task.vblPhase = 0;
      if (VInstall (___CAST(QElemPtr,&___time_mod.heartbeat_task)) == noErr)
        {
          ___time_mod.heartbeat_task_installed = 1;
          return t / 60.0;
        }
      else
        return 0.0;
    }
}


void ___mask_heartbeat_interrupts_begin
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 0;
}


void ___mask_heartbeat_interrupts_end
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 1;
}


___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID
{
  ___time_mod.heartbeat_enabled = 1;
  ___time_mod.heartbeat_task_installed = 0;
  return ___FIX(___NO_ERR);
}


void ___cleanup_heartbeat_interrupt_handling ___PVOID
{
  ___set_heartbeat_interval (-1.0);
  ___time_mod.heartbeat_enabled = 0;
}


#endif


#ifdef USE_CreateThread


/*
 * The HEARTBEAT_PRIORITY should be high so that heartbeats will occur
 * as close as possible to the correct time.
 */

#define HEARTBEAT_PRIORITY THREAD_PRIORITY_HIGHEST


___HIDDEN DWORD WINAPI heartbeat_thread_proc
   ___P((LPVOID param),
        (param)
LPVOID param;)
{
  DWORD interval = ___time_mod.heartbeat_interval;

  for (;;)
    {
      DWORD n = WaitForSingleObject (___time_mod.heartbeat_update, interval);

      interval = ___time_mod.heartbeat_interval;

      if (interval == 0)
        return 0;

      switch (n)
        {
        case WAIT_ABANDONED:
        case WAIT_OBJECT_0:
          break;

        case WAIT_TIMEOUT:
          if (___time_mod.heartbeat_enabled)
            ___time_mod.heartbeat_interrupt_handler ();
          break;

        default: /* WAIT_FAILED */
          return 0;
        }
    }

  return 0;
}


___F64 ___set_heartbeat_interval
   ___P((___F64 seconds),
        (seconds)
___F64 seconds;)
{
  /*
   * By default Windows will use a 64 Hz timer to implement thread
   * scheduling and this limits the resolution of the heartbeat.  For
   * higher resolution heartbeats, USE_HIGH_RES_TIMING must be defined
   * so that timeBeginPeriod(1) is called in the setup_time_management
   * function above.
   */

  ___time_mod.current_heartbeat_interval = seconds;

  if (seconds < 0.0) /* turn heartbeat off */
    {
      ___time_mod.heartbeat_interval = INFINITE;
      SetEvent (___time_mod.heartbeat_update); /* ignore error */
      return 0.0;
    }
  else
    {
      ___F64 msecs = seconds * 1000.0;
      DWORD m;

      if (msecs >= 4294967294.0) /* upper bound is 49.6 days! */
        m = 4294967294UL; /* note that INFINITE = 4294967295 */
      else
        {
          m = ___CAST(DWORD,msecs);
          if (m == 0) /* use smallest interval */
            m = 1;
        }

      ___time_mod.heartbeat_interval = m;
      SetEvent (___time_mod.heartbeat_update); /* ignore error */
      return m / 1000.0;
    }
}


void ___mask_heartbeat_interrupts_begin
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 0;
}


void ___mask_heartbeat_interrupts_end
   ___P((___mask_heartbeat_interrupts_state *state),
        (state)
___mask_heartbeat_interrupts_state *state;)
{
  ___time_mod.heartbeat_enabled = 1;
}


___SCMOBJ ___setup_heartbeat_interrupt_handling ___PVOID
{
  ___SCMOBJ e;
  DWORD thread_id;
  HANDLE thread;
  HANDLE update;

  ___time_mod.heartbeat_enabled = 1;
  ___time_mod.heartbeat_interval = INFINITE;

  if ((update = CreateEvent (NULL,  /* can't inherit */
                             FALSE, /* auto reset */
                             FALSE, /* not signaled */
                             NULL)) /* no name */
      == NULL)
    e = err_code_from_GetLastError ();
  else
    {
      ___time_mod.heartbeat_update = update;

      if ((thread = CreateThread (NULL,  /* no security attributes        */
                                  65536, /* committed stack size          */
                                  heartbeat_thread_proc,
                                  0,     /* argument to thread function   */
                                  0,     /* use default creation flags    */
                                  &thread_id))
          == NULL)
        e = err_code_from_GetLastError ();
      else
        {
          ___time_mod.heartbeat_thread = thread;

          if (!SetThreadPriority (thread, HEARTBEAT_PRIORITY))
            e = err_code_from_GetLastError ();
          else
            return ___FIX(___NO_ERR);

          ___time_mod.heartbeat_interval = 0;
          SetEvent (update); /* ignore error */
          WaitForSingleObject (thread, INFINITE); /* ignore error */
          CloseHandle (thread); /* ignore error */
        }

      CloseHandle (update); /* ignore error */
    }

  return e;
}


void ___cleanup_heartbeat_interrupt_handling ___PVOID
{
  if (___time_mod.heartbeat_thread != NULL)
    {
      ___time_mod.heartbeat_enabled = 0;
      ___time_mod.heartbeat_interval = 0;
      SetEvent (___time_mod.heartbeat_update); /* ignore error */
      WaitForSingleObject (___time_mod.heartbeat_thread, INFINITE); /* ignore error */
      CloseHandle (___time_mod.heartbeat_thread); /* ignore error */
      CloseHandle (___time_mod.heartbeat_update); /* ignore error */
      ___time_mod.heartbeat_update = NULL;
      ___time_mod.heartbeat_thread = NULL;
    }
}


#endif


/*---------------------------------------------------------------------------*/

/* Time module initialization/finalization. */


___SCMOBJ ___setup_time_module
   ___P((void (*heartbeat_interrupt_handler) ___PVOID),
        (heartbeat_interrupt_handler)
void (*heartbeat_interrupt_handler) ___PVOID;)
{
  ___SCMOBJ e;
  if (!___time_mod.setup)
    {
      ___time_mod.heartbeat_interrupt_handler = heartbeat_interrupt_handler;
      setup_time_management ();
      setup_process_times ();
      if ((e = ___setup_heartbeat_interrupt_handling ()) != ___FIX(___NO_ERR))
        return e;
      ___time_mod.setup = 1;
      return ___FIX(___NO_ERR);
    }

  return ___FIX(___UNKNOWN_ERR);
}


void ___cleanup_time_module ___PVOID
{
  if (___time_mod.setup)
    {
      ___cleanup_heartbeat_interrupt_handling ();
      cleanup_process_times ();
      cleanup_time_management ();
      ___time_mod.setup = 0;
    }
}


/*---------------------------------------------------------------------------*/
