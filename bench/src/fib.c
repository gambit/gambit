/* FIB -- A classic benchmark, computes fib(35) inefficiently. */

#include <stdio.h>

static int fib (n)
int n;
{
  if (n < 2)
    return n;
  else
    return fib (n-1) + fib (n-2);
}

int main (int argc, char *argv[])
{
  int i;
  int result;
  int n = 35;

  if (argc > 1)
    n = atoi (argv[1]);

  for (i=0; i<5; i++)
    result = fib (n);

  if (result != 9227465)
    printf ("*** wrong result ***\n");

  return 0;
}
