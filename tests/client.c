/* File: "client.c" */

/* Copyright (c) 1996-2014 by Marc Feeley, All Rights Reserved. */

#include <stdio.h>
#include <stdlib.h>

/*
 * Include the Gambit header file.
 */

#include "gambit.h"

/*
 * Include declarations exported by server.
 */

#include "server.h"

/*
 * Define SCHEME_LIBRARY_LINKER as the name of the Scheme library
 * prefixed with "____20_" and suffixed with "__".  This is the
 * function that initializes the Scheme library.
 */

#define SCHEME_LIBRARY_LINKER ____20_server__

___BEGIN_C_LINKAGE
extern ___mod_or_lnk SCHEME_LIBRARY_LINKER (___global_state);
___END_C_LINKAGE

int common_main ()
{
  char *temp;

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

  /* Main part of program: call Scheme functions */

  temp = eval_string ("(define x 200)");
  if (temp != 0)
    {
      printf ("result = %s\n", temp);
      ___release_string (temp); /* don't forget to reclaim string */
    }

  temp = eval_string ("(expt 2 x)");
  if (temp != 0)
    {
      printf ("result = %s\n", temp);
      ___release_string (temp);
    }

  temp = eval_string ("(+ 1 2"); /* note: missing closing parenthesis */
  if (temp != 0)
    {
      printf ("result = %s\n", temp);
      ___release_string (temp);
    }

  temp = eval_string ("(+ x y)"); /* note: y is unbound */
  if (temp != 0)
    {
      printf ("result = %s\n", temp);
      ___release_string (temp);
    }

  fflush (stdout);

  /* Cleanup the Scheme library */

  ___cleanup ();

  return 0;
}

#ifdef ___OS_WIN32
#ifdef _WINDOWS

#define DEFINED_WinMain

int WINAPI WinMain (HINSTANCE hInstance,
                    HINSTANCE hPrevInstance,
                    LPSTR lpCmdLine,
                    int nCmdShow)
{
  return common_main ();
}

#endif
#endif

#ifndef DEFINED_WinMain

int main (int argc, char **argv)
{
  return common_main ();
}

#endif
