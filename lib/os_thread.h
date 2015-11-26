/* File: "os_thread.h" */

/* Copyright (c) 2013-2015 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_THREAD_H
#define ___OS_THREAD_H

#include "os.h"


/*---------------------------------------------------------------------------*/

#define DECLARE_HASH_MUTEX(name,size) ___MUTEX name[size]

#define CAS_HASH_MUTEX_SIZE 67


typedef struct ___thread_module_struct
  {
    int refcount;

#ifdef ___USE_emulated_compare_and_swap_word
    DECLARE_HASH_MUTEX(cas_hash_mutex,CAS_HASH_MUTEX_SIZE);
#endif

#ifndef ___THREAD_LOCAL_STORAGE_CLASS

#ifdef ___USE_POSIX_THREAD_SYSTEM

  pthread_key_t tls_ptr_key;

#endif

#ifdef ___USE_WIN32_THREAD_SYSTEM

  DWORD tls_ptr_index;

#endif

#ifndef ___USE_POSIX_THREAD_SYSTEM
#ifndef ___USE_WIN32_THREAD_SYSTEM

  /*
   * This fallback only works when there is a single thread.
   * However, this should be the case if none of the supported thread
   * systems is being used.
   */

  void *tls_ptr;

#endif
#endif

#endif
  } ___thread_module;


extern ___thread_module ___thread_mod;


/*---------------------------------------------------------------------------*/


extern ___SCMOBJ ___thread_init_from_self
   ___P((___thread *thread),
        ());

extern ___SCMOBJ ___thread_create
   ___P((___thread *thread),
        ());

extern ___SCMOBJ ___thread_join
   ___P((___thread *thread),
        ());

extern void ___thread_exit ___PVOID;


extern ___SCMOBJ ___setup_thread_module ___PVOID;

extern void ___cleanup_thread_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
