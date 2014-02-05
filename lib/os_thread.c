/* File: "os_thread.c" */

/* Copyright (c) 2013 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements thread-related services.
 */

#define ___INCLUDED_FROM_OS_THREAD
#define ___VERSION 407002
#include "gambit.h"

#include "os_base.h"
#include "os_thread.h"


/*---------------------------------------------------------------------------*/


___thread_module ___thread_mod =
{
  0
};


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

#endif

  return thread_init_common (thread);
}


___SCMOBJ ___thread_join
   ___P((___thread *thread),
        (thread)
___thread *thread;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  if (pthread_join (thread->thread_id, NULL) != 0)
    return err_code_from_errno ();

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  if (WaitForSingleObject (thread->thread_handle, INFINITE) == WAIT_FAILED)
    return err_code_from_GetLastError ();

#endif

  return ___FIX(___NO_ERR);
}


#ifdef ___USE_emulated_compare_and_swap_word


___WORD ___emulated_compare_and_swap_word
   ___P((___WORD *ptr,
         ___WORD oldval,
         ___WORD newval),
        (ptr,
         oldval,
         newval)
___WORD *ptr;
___WORD oldval;
___WORD newval;)
{
  static char *msgs[] = { "Mutex lock/unlock operation failed", NULL };
  ___WORD temp;
  ___MUTEX *mut_ptr =
    &___thread_mod.cas_hash_mutex[___CAST(___SIZE_T,ptr) % CAS_HASH_MUTEX_SIZE];

  if (!___MUTEX_LOCK(*mut_ptr))
    ___fatal_error (msgs); /* should never happen, but just in case... */

  temp = *ptr;

  if (temp == oldval)
    *ptr = newval;

  if (!___MUTEX_UNLOCK(*mut_ptr))
    ___fatal_error (msgs); /* should never happen, but just in case... */

  return temp;
}


#endif


#ifdef ___THREAD_LOCAL_STORAGE_CLASS


___THREAD_LOCAL_STORAGE_CLASS void *___tls_ptr;


#else


void *___get_tls_ptr ___PVOID
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  return pthread_getspecific (___thread_mod.tls_ptr_key); /* ignore error */

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  return TlsGetValue (___thread_mod.tls_ptr_index); /* ignore error */

#endif

#ifndef ___USE_POSIX_THREAD_SYSTEM
#ifndef ___USE_WIN32_THREAD_SYSTEM

  return ___thread_mod.tls_ptr;

#endif
#endif
}

void ___set_tls_ptr
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
#ifdef ___USE_POSIX_THREAD_SYSTEM

  pthread_setspecific (___thread_mod.tls_ptr_key, ptr); /* ignore error */

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  TlsSetValue (___thread_mod.tls_ptr_index, ptr); /* ignore error */

#endif

#ifndef ___USE_POSIX_THREAD_SYSTEM
#ifndef ___USE_WIN32_THREAD_SYSTEM

  ___thread_mod.tls_ptr = ptr;

#endif
#endif
}


#endif


/*---------------------------------------------------------------------------*/


#ifdef ___USE_emulated_compare_and_swap_word


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
#ifdef ___USE_emulated_compare_and_swap_word

      err = hash_mutex_init (___thread_mod.cas_hash_mutex,
                             CAS_HASH_MUTEX_SIZE);

      if (err != ___FIX(___NO_ERR))
        return err;

#endif

#ifndef ___THREAD_LOCAL_STORAGE_CLASS

#ifdef ___USE_POSIX_THREAD_SYSTEM

      if (pthread_key_create (&___thread_mod.tls_ptr_key, NULL) != 0)
        {
          err = err_code_from_errno ();
          hash_mutex_destroy (___thread_mod.cas_hash_mutex,
                              CAS_HASH_MUTEX_SIZE);
        }

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

      if ((___thread_mod.tls_ptr_index = TlsAlloc ()) == TLS_OUT_OF_INDEXES)
        {
          err = err_code_from_GetLastError ();
          hash_mutex_destroy (___thread_mod.cas_hash_mutex,
                              CAS_HASH_MUTEX_SIZE);
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
#ifdef ___USE_emulated_compare_and_swap_word

      hash_mutex_destroy (___thread_mod.cas_hash_mutex,
                          CAS_HASH_MUTEX_SIZE);

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
