/* file: "tfib.c" */

#define USE_PTHREADS

#ifdef USE_PTHREADS

#include <stdio.h>
#include <pthread.h>

void *tfib (void *n)
{
  if ((int)n < 2)
    return (void*)1;
  else
    {
      pthread_t x;
      void *y;
      void *z;
      if (pthread_create (&x, NULL, tfib, (void*)((int)n - 2)) != 0) exit (1);
      y = tfib ((void*)((int)n - 1));
      if (pthread_join (x, &z) != 0) exit (1);
      return (void*)((int)y + (int)z);
    }
}

int main (int argc, char *argv[])
{
  int n = 14; /* atoi (argv[1]); */
  int repeat = 100; /* atoi (argv[2]); */
  void *result;
  do
    {
      pthread_t x;
      if (pthread_create (&x, NULL, tfib, (void*)((int)n)) != 0) exit (1);
      if (pthread_join (x, &result) != 0) exit (1);
      repeat--;
    } while (repeat > 0);
  printf ("%d\n", (int)result);
  return 0;
}

#else

#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int tfib (int n)
{
  if (n < 2)
    return 1;
  else
    {
      pid_t x;
      int y;
      int z;
      x = fork ();
      if (x < 0) exit (1);
      if (x == 0) exit (tfib (n - 2));
      y = tfib (n - 1);
      if (waitpid (x, &z, 0) < 0) exit (1);
      return y + WEXITSTATUS(z);
    }
}

int main (int argc, char *argv[])
{
  int n = 14; /* atoi (argv[1]); */
  int repeat = 20; /* atoi (argv[2]); */
  int result;
  do
    {
      pid_t x;
      x = fork ();
      if (x < 0) exit (1);
      if (x == 0) exit (tfib (n));
      if (waitpid (x, &result, 0) < 0) exit (1);
      repeat--;
    } while (repeat > 0);
  printf ("fib(%d) mod 256 = %d\n", n, WEXITSTATUS(result));
  return 0;
}

#endif
