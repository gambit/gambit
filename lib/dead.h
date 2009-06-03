/*---------------------------------------------------------------------------*/

/* Threading. */

#ifdef USE_POSIX

#define ___THREAD_TYPE pthread_t
#define ___THREAD_RESULT_TYPE void*
#define ___THREAD_CREATE(thr,proc,arg) (pthread_create (&thr, NULL, proc, arg) == 0)
#define ___THREAD_EXIT(result) pthread_exit (result)

#define ___MUTEX_TYPE pthread_mutex_t
#define ___MUTEX_INIT(mut) (pthread_mutex_init (&mut, NULL) == 0)
#define ___MUTEX_DESTROY(mut) (pthread_mutex_destroy (&mut) == 0)
#define ___MUTEX_LOCK(mut) (pthread_mutex_lock (&mut) == 0)
#define ___MUTEX_UNLOCK(mut) (pthread_mutex_unlock (&mut) == 0)

#define ___CONDVAR_TYPE pthread_cond_t
#define ___CONDVAR_INIT(cv) (pthread_cond_init (&cv, NULL) == 0)
#define ___CONDVAR_DESTROY(cv) (pthread_cond_destroy (&cv) == 0)
#define ___CONDVAR_WAIT(cv,mut) (pthread_cond_wait (&cv, &mut) == 0)
#define ___CONDVAR_SIGNAL(cv) (pthread_cond_signal (&cv) == 0)

#endif

#ifdef USE_WIN32

#define ___THREAD_TYPE HANDLE
#define ___THREAD_RESULT_TYPE DWORD
#define ___THREAD_CREATE(thr,proc,arg) ((thr = CreateThread (NULL, 0, proc, arg, 0, NULL)) != NULL)
#define ___THREAD_EXIT(result) ExitThread (result)

#define ___MUTEX_TYPE HANDLE
#define ___MUTEX_INIT(mut) ((mut = CreateMutex (NULL, FALSE, NULL)) != NULL)
#define ___MUTEX_DESTROY(mut) CloseHandle (mut)
#define ___MUTEX_LOCK(mut) (WaitForSingleObject (mut, INFINITE) != WAIT_FAILED)
#define ___MUTEX_UNLOCK(mut) ReleaseMutex (mut)

#define ___CONDVAR_TYPE HANDLE
#define ___CONDVAR_INIT(cv) ((cv = CreateEvent (NULL, FALSE, FALSE, NULL)) != NULL)
#define ___CONDVAR_DESTROY(cv) CloseHandle (cv)
#define ___CONDVAR_WAIT(cv,mut) (WaitForSingleObject (cv, INFINITE) != WAIT_FAILED)
#define ___CONDVAR_SIGNAL(cv) SetEvent (cv)

#endif

