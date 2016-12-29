/* File: "pthread.c" */

/* Copyright (c) 2006-2013 by Marc Feeley, All Rights Reserved. */

#include <stdio.h>
#include <pthread.h>

/*
 * ___VERSION must match the version number of the Gambit header file.
 */

#define ___VERSION 408007
#include "gambit.h"

/*
 * Include declarations exported by mylib.scm.
 */

#include "mylib.h"

/*
 * Define SCHEME_LIBRARY_LINKER as the name of the Scheme library
 * prefixed with "____20_" and suffixed with "__".  This is the
 * function that initializes the Scheme library.
 */

#define SCHEME_LIBRARY_LINKER ____20_mylib__

___BEGIN_C_LINKAGE
extern ___mod_or_lnk SCHEME_LIBRARY_LINKER (___global_state);
___END_C_LINKAGE

#define N 5 /* number of threads */

___SCMOBJ counter; /* the Scheme counter record to increment */

pthread_mutex_t mut; /* to implement critical section for incrementation */

void increment (void)
{
  int got_throw = 0;

  /*
   * At most one thread at a time can execute Scheme code.
   * So call Scheme in a critical section.
   */

  pthread_mutex_lock (&mut);

  /* call Scheme to increment counter */

  ___ON_THROW(increment_counter (counter), got_throw=1);

  pthread_mutex_unlock (&mut);

  if (got_throw)
    {
      printf ("thread %p is terminating\n", pthread_self ());
      pthread_exit (NULL); /* exit if Scheme threw an exception */
    }
}

void increment_loop (void)
{
  int i;
  for (i = 0; i<20000; i++)
    increment ();
}

void* thread_main (void* param)
{
  increment_loop ();
  return NULL;
}

int main (int argc, char **argv)
{
  /*
   * Setup the Scheme library by calling "___setup" with appropriate
   * parameters.  The call to "___setup_params_reset" sets all parameters
   * to their default setting.
   */

  ___setup_params_struct setup_params;

  ___setup_params_reset (&setup_params);

  setup_params.version = ___VERSION;
  setup_params.linker  = SCHEME_LIBRARY_LINKER;

  ___setup (&setup_params);

  /* Main part of program: start N threads that increment a counter */

  counter = new_counter (); /* create a new counter */

  pthread_mutex_init (&mut, NULL); /* initialize mutex */

  {
    int i;
    pthread_t tid[N];
    void* results[N];

    for (i = 0; i<N; i++)
      pthread_create (&tid[i], NULL, thread_main, NULL);

    for (i = 0; i<N; i++)
      pthread_join (tid[i], &results[i]);
  }

  {
    int got_throw = 0;
    int count = 0;

    ___ON_THROW(count = get_counter (counter), got_throw=1);

    if (got_throw)
      printf ("Scheme threw an exception\n");
    else
      printf ("final count = %d\n", count);
  }

  /* we don't need the counter anymore */

  ___ON_THROW(release_counter (counter),);

  /* Cleanup the Scheme library */

  ___cleanup ();

  return 0;
}
