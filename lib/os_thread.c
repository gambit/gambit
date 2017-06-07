/* File: "os_thread.c" */

/* Copyright (c) 2013-2016 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements thread-related services.
 */

#include "config.h"

#ifdef HAVE_PTHREAD_SETAFFINITY_NP
/* Needed to get pthread.h to define CPU_ZERO and CPU_SET */
#define _GNU_SOURCE
#endif

#define ___INCLUDED_FROM_OS_THREAD
#define ___VERSION 408008
#include "gambit.h"

#include "os_base.h"
#include "os_thread.h"


/*---------------------------------------------------------------------------*/


___thread_module ___thread_mod =
{
  0
};


#ifndef ___SINGLE_THREADED_VMS
void ___setup_thread_local_state ___PVOID
{
  ___setup_io_thread_local_state ();
}
#endif

/*---------------------------------------------------------------------------*/


#ifdef ___USE_POSIX_THREAD_SYSTEM

___HIDDEN void *start_pthread_thread
   ___P((void *param),
        (param)
void *param;)
{
  ___thread *thread = ___CAST(___thread*,param);

  ___setup_thread_local_state ();

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

  ___setup_thread_local_state ();

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


#ifdef ___USE_THREAD_POLICY_SET

#include <mach/thread_act.h>

kern_return_t thread_policy_set(thread_t thread,
                                thread_policy_flavor_t flavor,
                                thread_policy_t policy_info,
                                mach_msg_type_number_t count);

#endif


void ___thread_set_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SET_PSTATE(___ps);

#ifdef ___USE_POSIX_THREAD_SYSTEM

#ifdef ___USE_THREAD_POLICY_SET

  {
    int id = ___PROCESSOR_ID(___ps, ___VMSTATE_FROM_PSTATE(___ps));
    mach_port_t mach_thread = pthread_mach_thread_np (pthread_self ());
    int affinity[1];

    affinity[0] = id;

    thread_policy_set (mach_thread, THREAD_AFFINITY_POLICY, (thread_policy_t)&affinity, 1);
  }

#else

#ifdef HAVE_PTHREAD_SETAFFINITY_NP

  {
    int id = ___PROCESSOR_ID(___ps, ___VMSTATE_FROM_PSTATE(___ps));
    cpu_set_t cpuset;

    CPU_ZERO(&cpuset);
    CPU_SET(id, &cpuset);

    pthread_setaffinity_np (pthread_self (),
                            sizeof (cpu_set_t),
                            &cpuset); /* ignore error */
  }

#endif

#endif

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  {
    int id = ___PROCESSOR_ID(___ps, ___VMSTATE_FROM_PSTATE(___ps));

    SetThreadAffinityMask (GetCurrentThread (), ___CAST(DWORD,1)<<id);
  }

#endif
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


#ifdef USE_POSIX

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
