/* File: "os_thread.c" */

/* Copyright (c) 2013-2023 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements thread-related services.
 */

#define ___INCLUDED_FROM_OS_THREAD
#define ___VERSION 409007
#include "gambit.h"

#include "os_setup.h"
#include "os_base.h"
#include "os_thread.h"


/*---------------------------------------------------------------------------*/


___thread_module ___thread_mod =
{
  0,
  -1,   /* cpu id of main OS thread */
  1, 0, /* cpu count for: performant and efficient cpus */
  1     /* core count */
};


/*---------------------------------------------------------------------------*/

/* CPU information. */

void ___get_cpu_count ___PVOID
{
  /* determine cpu counts for performant and efficiency cpus */

#ifdef USE_sysctl

#ifdef USE_sysctlbyname

  ___S32 n;
  size_t s = sizeof (n);

  if (sysctlbyname ("hw.perflevel0.logicalcpu", &n, &s, NULL, 0) == 0) {
    ___thread_mod.cpu_count[0] = n;
    if (sysctlbyname ("hw.perflevel1.logicalcpu", &n, &s, NULL, 0) == 0) {
      ___thread_mod.cpu_count[1] = n;
    }
  } else {

#endif

#ifdef CTL_HW
#ifdef HW_AVAILCPU
#define OP_NB_CPU HW_AVAILCPU
#else
#ifdef HW_NCPU
#define OP_NB_CPU HW_NCPU
#endif
#endif
#endif

#ifdef OP_NB_CPU

  size_t n = 0;
  size_t sizeof_n = sizeof(n);
  int mib[2];

  mib[0] = CTL_HW;
  mib[1] = OP_NB_CPU;

  if (sysctl (mib, 2, &n, &sizeof_n, NULL, 0) == 0) {
    ___thread_mod.cpu_count[0] = n;
  }

#endif

#ifdef USE_sysctlbyname
  }
#endif

#else

#ifdef USE_sysconf

#ifdef _SC_NPROCESSORS_ONLN
#define OP_SC_NPROCESSORS _SC_NPROCESSORS_ONLN
#else
#ifdef _SC_NPROCESSORS_CONF
#define OP_SC_NPROCESSORS _SC_NPROCESSORS_CONF
#endif
#endif

#endif

#ifdef OP_SC_NPROCESSORS

  ___thread_mod.cpu_count[0] = sysconf (OP_SC_NPROCESSORS);

#endif

#endif

#ifdef USE_GetSystemInfo

  {
    SYSTEM_INFO si;

    GetSystemInfo (&si);

    ___thread_mod.cpu_count[0] = si.dwNumberOfProcessors;
  }

#endif
}

void ___get_core_count ___PVOID
{
  /* determine core count */

  /* default to the cpu count if there's no way to get the core count */

  ___thread_mod.core_count = ___thread_mod.cpu_count[0] +
                             ___thread_mod.cpu_count[1];

#ifdef USE_sysctlbyname

  {
    ___S32 n;
    size_t s = sizeof (n);

    if (sysctlbyname ("machdep.cpu.core_count", &n, &s, NULL, 0) == 0)
      ___thread_mod.core_count = n;
  }

#endif
}


int ___get_processor0_cpu_id ___PVOID
{
  /* determine cpu id of processor 0 */

  int cpu_id = -1;

#ifdef USE_sched_getcpu

  cpu_id = sched_getcpu ();

#else

#ifdef ___CPU_x86
#ifdef __GNUC__

  {
    ___U32 a, b, c, d;

    __asm__ __volatile__ ("cpuid\n\t"
                          : "=a" (a), "=b" (b), "=c" (c), "=d" (d)
                          : "0" (1), "2" (0));

    if ((d & (1 << 9)) != 0) { /* have APIC on chip? */
      cpu_id = b >> 24;
    }
  }

#endif
#endif

#endif

  if (cpu_id < 0) {
    /*
     * When the cpu id can't be determined, the process id is used to
     * generate a somewhat random fake cpu id that has the virtue of
     * being different from recently created other Gambit processes
     * (to avoid having the thread affinity map the main OS thread of
     * these processes to the same cpu).
     */
    cpu_id = ___INT(___os_getpid ());
  }

  /* make sure the cpu id is within bounds */

  cpu_id = cpu_id % (___thread_mod.cpu_count[0] + ___thread_mod.cpu_count[1]);

  return cpu_id;
}


void ___get_cpu_info ___PVOID
{
  if (___thread_mod.processor0_cpu_id >= 0) return;

  ___get_cpu_count ();

  ___get_core_count ();

  ___thread_mod.processor0_cpu_id = ___get_processor0_cpu_id ();
}


int ___cpu_count
   ___P((int level),
        (level)
int level;)
{
  int cpu_count;

  ___get_cpu_info ();

  if (level >= 0 && level <= 1) {
    cpu_count = ___thread_mod.cpu_count[level];
  } else {
    cpu_count = ___thread_mod.cpu_count[0] + ___thread_mod.cpu_count[1];
  }

  return cpu_count;
}


int ___cpu_cache_size
   ___P((___BOOL instruction_cache,
         int level),
        (instruction_cache,
         level)
___BOOL instruction_cache;
int level;)
{
  int cache_size = 0;

#ifdef USE_sysconf

  {

  static struct { int name; int level; int kind; } sysconf_info[] = {

#ifdef _SC_LEVEL1_DCACHE_SIZE
    { _SC_LEVEL1_DCACHE_SIZE, 1, 1 },
#endif
#ifdef _SC_LEVEL1_ICACHE_SIZE
    { _SC_LEVEL1_ICACHE_SIZE, 1, 2 },
#endif
#ifdef _SC_LEVEL1_CACHE_SIZE
    { _SC_LEVEL1_CACHE_SIZE,  1, 3 },
#endif

#ifdef _SC_LEVEL2_DCACHE_SIZE
    { _SC_LEVEL2_DCACHE_SIZE, 2, 1 },
#endif
#ifdef _SC_LEVEL2_ICACHE_SIZE
    { _SC_LEVEL2_ICACHE_SIZE, 2, 2 },
#endif
#ifdef _SC_LEVEL2_CACHE_SIZE
    { _SC_LEVEL2_CACHE_SIZE,  2, 3 },
#endif

#ifdef _SC_LEVEL3_DCACHE_SIZE
    { _SC_LEVEL3_DCACHE_SIZE, 3, 1 },
#endif
#ifdef _SC_LEVEL3_ICACHE_SIZE
    { _SC_LEVEL3_ICACHE_SIZE, 3, 2 },
#endif
#ifdef _SC_LEVEL3_CACHE_SIZE
    { _SC_LEVEL3_CACHE_SIZE,  3, 3 },
#endif

#ifdef _SC_LEVEL4_DCACHE_SIZE
    { _SC_LEVEL4_DCACHE_SIZE, 4, 1 },
#endif
#ifdef _SC_LEVEL4_ICACHE_SIZE
    { _SC_LEVEL4_ICACHE_SIZE, 4, 2 },
#endif
#ifdef _SC_LEVEL4_CACHE_SIZE
    { _SC_LEVEL4_CACHE_SIZE,  4, 3 },
#endif

      { 0, 0, 0 }
  };

  int i = 0;

  while (sysconf_info[i].kind != 0) {

    if ((level == 0 || level == sysconf_info[i].level) &&
        (sysconf_info[i].kind & (1<<instruction_cache))) {

      int size = sysconf (sysconf_info[i].name);

      if (level != 0) {
        cache_size = size;
        break;
      }

      if (size > cache_size) {
        cache_size = size;
      }
    }

    i++;
  }

  if (cache_size != 0) {
    return cache_size;
  }

  }

#endif

#ifdef USE_sysctl

#ifdef CTL_HW

  {

  static struct { int name; int level; int kind; } sysctl_info[] = {

#ifdef HW_L1DCACHESIZE
    { HW_L1DCACHESIZE, 1, 1 },
#endif
#ifdef HW_L1ICACHESIZE
    { HW_L1ICACHESIZE, 1, 2 },
#endif
#ifdef HW_L1CACHESIZE
    { HW_L1CACHESIZE,  1, 3 },
#endif

#ifdef HW_L2DCACHESIZE
    { HW_L2DCACHESIZE, 2, 1 },
#endif
#ifdef HW_L2ICACHESIZE
    { HW_L2ICACHESIZE, 2, 2 },
#endif
#ifdef HW_L2CACHESIZE
    { HW_L2CACHESIZE,  2, 3 },
#endif

#ifdef HW_L3DCACHESIZE
    { HW_L3DCACHESIZE, 3, 1 },
#endif
#ifdef HW_L3ICACHESIZE
    { HW_L3ICACHESIZE, 3, 2 },
#endif
#ifdef HW_L3CACHESIZE
    { HW_L3CACHESIZE,  3, 3 },
#endif

#ifdef HW_L4DCACHESIZE
    { HW_L4DCACHESIZE, 4, 1 },
#endif
#ifdef HW_L4ICACHESIZE
    { HW_L4ICACHESIZE, 4, 2 },
#endif
#ifdef HW_L4CACHESIZE
    { HW_L4CACHESIZE,  4, 3 },
#endif

      { 0, 0, 0 }
  };

  int i = 0;

  while (sysctl_info[i].kind != 0) {

    if ((level == 0 || level == sysctl_info[i].level) &&
        (sysctl_info[i].kind & (1<<instruction_cache))) {

      size_t size = 0;
      size_t sizeof_size = sizeof(size);
      int mib[2];

      mib[0] = CTL_HW;
      mib[1] = sysctl_info[i].name;

      if (sysctl (mib, 2, &size, &sizeof_size, NULL, 0) == 0) {

        if (level != 0) {
          cache_size = size;
          break;
        }

        if (size > cache_size) {
          cache_size = size;
        }
      }
    }

    i++;
  }

  if (cache_size != 0) {
    return cache_size;
  }

  }

#endif

#endif

#ifdef USE_WIN32

  /* TODO: use GetLogicalProcessorInformation */

#endif

  return cache_size;
}


int ___core_count ___PVOID
{
  ___get_cpu_info ();

  return ___thread_mod.core_count;
}


/*---------------------------------------------------------------------------*/


#ifdef ___USE_POSIX_THREAD_SYSTEM


___HIDDEN void *start_pthread_thread
   ___P((void *param),
        (param)
void *param;)
{
  ___thread *thread = ___CAST(___thread*,param);

  thread->start_fn (thread);

  return 0;
}


#endif


#ifdef ___USE_WIN32_THREAD_SYSTEM


___HIDDEN DWORD WINAPI start_win32_thread
   ___P((LPVOID param),
        (param)
LPVOID param;)
{
  ___thread *thread = ___CAST(___thread*,param);

  thread->start_fn (thread);

  return 0;
}


#endif


___HIDDEN ___SCMOBJ thread_init_common
   ___P((___thread *thread),
        (thread)
___thread *thread;)
{
  return ___FIX(___NO_ERR);
}


___SCMOBJ ___thread_init_from_self
   ___P((___thread *thread),
        (thread)
___thread *thread;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  thread->thread_id = pthread_self ();

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  thread->thread_handle = GetCurrentThread ();
  thread->thread_id = GetCurrentThreadId ();

#endif

  return thread_init_common (thread);
}


___SCMOBJ ___thread_create
   ___P((___thread *thread),
        (thread)
___thread *thread;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  pthread_t thread_id;

  if (pthread_create (&thread_id,
                      NULL,
                      start_pthread_thread,
                      ___CAST(void*,thread)) != 0)
    return err_code_from_errno ();

  thread->thread_id = thread_id;

  return thread_init_common (thread);

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  DWORD committed_stack_size = 65536;
  HANDLE thread_handle;
  DWORD thread_id;

  if ((thread_handle =
       CreateThread (NULL,                   /* no security attributes       */
                     committed_stack_size,   /* committed stack size         */
                     start_win32_thread,     /* thread procedure             */
                     ___CAST(LPVOID,thread), /* argument to thread procedure */
                     0,                      /* use default creation flags   */
                     &thread_id)) == NULL)
    return err_code_from_GetLastError ();

  thread->thread_handle = thread_handle;
  thread->thread_id = thread_id;

  return thread_init_common (thread);

#endif

#ifndef ___USE_POSIX_THREAD_SYSTEM
#ifndef ___USE_WIN32_THREAD_SYSTEM

  return ___FIX(___UNIMPL_ERR);

#endif
#endif
}


___SCMOBJ ___thread_join
   ___P((___thread *thread),
        (thread)
___thread *thread;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  if (pthread_join (thread->thread_id, NULL) != 0)
    return err_code_from_errno ();

  return ___FIX(___NO_ERR);

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  if (WaitForSingleObject (thread->thread_handle, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

  return ___FIX(___NO_ERR);

#endif

#ifndef ___USE_POSIX_THREAD_SYSTEM
#ifndef ___USE_WIN32_THREAD_SYSTEM

  return ___FIX(___UNIMPL_ERR);

#endif
#endif
}


void ___thread_exit ___PVOID
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  pthread_exit (NULL);

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  ExitThread (0);

#endif
}


void ___thread_affinity_set
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  int id = ___PROCESSOR_ID(___ps, ___VMSTATE_FROM_PSTATE(___ps));
  int cpu_count = ___cpu_count (-1);
  int cpu_id = (id + ___thread_mod.processor0_cpu_id) % cpu_count;

#ifdef ___USE_POSIX_THREAD_SYSTEM

#ifdef USE_thread_policy_set

  {
    mach_port_t mach_thread = pthread_mach_thread_np (pthread_self ());
    int affinity[1];

    affinity[0] = 1 << cpu_id;

    thread_policy_set (mach_thread, THREAD_AFFINITY_POLICY, (thread_policy_t)&affinity, 1);
  }

#else

#ifdef HAVE_PTHREAD_SETAFFINITY_NP

  {
    cpu_set_t cpuset;

    CPU_ZERO(&cpuset);
    CPU_SET(cpu_id, &cpuset);

    pthread_setaffinity_np (pthread_self (),
                            sizeof (cpu_set_t),
                            &cpuset); /* ignore error */
  }

#endif

#endif

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  SetThreadAffinityMask (GetCurrentThread (), ___CAST(DWORD,1)<<id);

#endif
}


void ___thread_affinity_reset
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

#ifdef USE_thread_policy_set

  {
    mach_port_t mach_thread = pthread_mach_thread_np (pthread_self ());
    int affinity[1];

    affinity[0] = -1;

    thread_policy_set (mach_thread, THREAD_AFFINITY_POLICY, (thread_policy_t)&affinity, 1);
  }

#else

#ifdef HAVE_PTHREAD_SETAFFINITY_NP

  {
    cpu_set_t cpuset;
    int cpu_id;

    CPU_ZERO(&cpuset);

    for (cpu_id=0; cpu_id<CPU_SETSIZE; cpu_id++) {
      CPU_SET(cpu_id, &cpuset);
    }

    pthread_setaffinity_np (pthread_self (),
                            sizeof (cpu_set_t),
                            &cpuset); /* ignore error */
  }

#endif

#endif

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  SetThreadAffinityMask (GetCurrentThread (), ___CAST(DWORD,-1));

#endif
}


void ___thread_set_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___SUPPORT_PSTATE_BIND
  ___ps->pstate_binding = ___ps;
#endif

  ___SET_REAL_PSTATE(___ps);

  ___thread_affinity_set (___ps);
}


#ifdef ___USE_emulated_sync


___WORD ___emulated_compare_and_swap_word
   ___P((___VOLATILE ___WORD *ptr,
         ___WORD oldval,
         ___WORD newval),
        (ptr,
         oldval,
         newval)
___VOLATILE ___WORD *ptr;
___WORD oldval;
___WORD newval;)
{
  ___WORD temp;
  ___MUTEX *mut_ptr =
    &___thread_mod.hash_mutex[___CAST(___SIZE_T,ptr) % HASH_MUTEX_SIZE];

  ___MUTEX_LOCK(*mut_ptr);

  temp = *ptr;

  if (temp == oldval)
    *ptr = newval;

  ___MUTEX_UNLOCK(*mut_ptr);

  return temp;
}


___WORD ___emulated_fetch_and_add_word
   ___P((___VOLATILE ___WORD *ptr,
         ___WORD val),
        (ptr,
         val)
___VOLATILE ___WORD *ptr;
___WORD val;)
{
  ___WORD temp;
  ___MUTEX *mut_ptr =
    &___thread_mod.hash_mutex[___CAST(___SIZE_T,ptr) % HASH_MUTEX_SIZE];

  ___MUTEX_LOCK(*mut_ptr);

  temp = *ptr;

  *ptr += val;

  ___MUTEX_UNLOCK(*mut_ptr);

  return temp;
}


___WORD ___emulated_fetch_and_clear_word
   ___P((___VOLATILE ___WORD *ptr),
        (ptr)
___VOLATILE ___WORD *ptr;)
{
  ___WORD temp;
  ___MUTEX *mut_ptr =
    &___thread_mod.hash_mutex[___CAST(___SIZE_T,ptr) % HASH_MUTEX_SIZE];

  ___MUTEX_LOCK(*mut_ptr);

  temp = *ptr;

  *ptr = 0;

  ___MUTEX_UNLOCK(*mut_ptr);

  return temp;
}


void ___emulated_shared_memory_barrier ___PVOID
{
  /*
   * It is impossible to emulate a memory barrier portably, so just
   * hope for the best...
   */
}


#endif


#ifdef ___THREAD_LOCAL_STORAGE_CLASS

___THREAD_LOCAL_STORAGE_CLASS void *___tls_ptr;

#endif


#ifdef ___DEFINE_THREAD_LOCAL_STORAGE_GETTER_SETTER


void *___get_tls_ptr ___PVOID
{
#ifdef ___THREAD_LOCAL_STORAGE_CLASS

  return ___tls_ptr;

#else

#ifdef ___USE_POSIX_THREAD_SYSTEM

  return pthread_getspecific (___thread_mod.tls_ptr_key); /* ignore error */

#else

#ifdef ___USE_WIN32_THREAD_SYSTEM

  return TlsGetValue (___thread_mod.tls_ptr_index); /* ignore error */

#else

  return ___thread_mod.tls_ptr;

#endif
#endif
#endif
}


void ___set_tls_ptr
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
#ifdef ___THREAD_LOCAL_STORAGE_CLASS

  ___tls_ptr = ptr;

#else

#ifdef ___USE_POSIX_THREAD_SYSTEM

  pthread_setspecific (___thread_mod.tls_ptr_key, ptr); /* ignore error */

#else

#ifdef ___USE_WIN32_THREAD_SYSTEM

  TlsSetValue (___thread_mod.tls_ptr_index, ptr); /* ignore error */

#else

  ___thread_mod.tls_ptr = ptr;

#endif
#endif
#endif
}


#endif


#ifdef USE_SIGNALS

int ___thread_sigmask
   ___P((int how,
         ___sigset_type *set,
         ___sigset_type *oldset),
        (how,
         set,
         oldset)
int how;
___sigset_type *set;
___sigset_type *oldset;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  return pthread_sigmask (how, set, oldset);

#else

#ifdef HAVE_SIGPROCMASK
  return sigprocmask (how, set, oldset);
#endif

#endif
}

int ___thread_sigmask1
   ___P((int how,
         int sig,
         ___sigset_type *oldset),
        (how,
         sig,
         oldset)
int how;
int sig;
___sigset_type *oldset;)
{
  ___sigset_type sigs;

  sigemptyset (&sigs);
  sigaddset (&sigs, sig);

  return ___thread_sigmask (how, &sigs, oldset);
}

#endif


/*---------------------------------------------------------------------------*/


#ifdef ___USE_emulated_sync


___HIDDEN void hash_mutex_destroy
   ___P((___MUTEX *hash_mutex,
         int size),
        (hash_mutex,
         size)
___MUTEX *hash_mutex;
int size;)
{
  while (size-- > 0)
    ___MUTEX_DESTROY(hash_mutex[size]); /* ignore error */
}


___HIDDEN ___SCMOBJ hash_mutex_init
   ___P((___MUTEX *hash_mutex,
         int size),
        (hash_mutex,
         size)
___MUTEX *hash_mutex;
int size;)
{
  int n = 0;

  while (n < size)
    {
      if (!___MUTEX_INIT(hash_mutex[n]))
        {
          hash_mutex_destroy (hash_mutex, n);
          return ___FIX(___UNKNOWN_ERR);
        }

      n++;
    }

  return ___FIX(___NO_ERR);
}


#endif


___SCMOBJ ___setup_thread_module ___PVOID
{
  ___SCMOBJ err = ___FIX(___NO_ERR);

  if (___thread_mod.refcount == 0)
    {
      ___get_cpu_info ();

#ifdef ___USE_emulated_sync

      err = hash_mutex_init (___thread_mod.hash_mutex,
                             HASH_MUTEX_SIZE);

      if (err != ___FIX(___NO_ERR))
        return err;

#endif

#ifndef ___THREAD_LOCAL_STORAGE_CLASS

#ifdef ___USE_POSIX_THREAD_SYSTEM

      if (pthread_key_create (&___thread_mod.tls_ptr_key, NULL) != 0)
        {
          err = err_code_from_errno ();
          hash_mutex_destroy (___thread_mod.hash_mutex,
                              HASH_MUTEX_SIZE);
        }

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

      if ((___thread_mod.tls_ptr_index = TlsAlloc ()) == TLS_OUT_OF_INDEXES)
        {
          err = err_code_from_GetLastError ();
          hash_mutex_destroy (___thread_mod.hash_mutex,
                              HASH_MUTEX_SIZE);
        }

#endif

#endif
    }

  ___thread_mod.refcount++;

  return err;
}


void ___cleanup_thread_module ___PVOID
{
  if (--___thread_mod.refcount == 0)
    {
#ifdef ___USE_emulated_sync

      hash_mutex_destroy (___thread_mod.hash_mutex,
                          HASH_MUTEX_SIZE);

#endif

#ifndef ___THREAD_LOCAL_STORAGE_CLASS

#ifdef ___USE_POSIX_THREAD_SYSTEM

      pthread_key_delete (___thread_mod.tls_ptr_key); /* ignore error */

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

      TlsFree(___thread_mod.tls_ptr_index); /* ignore error */

#endif

#endif
    }
}


/*---------------------------------------------------------------------------*/
