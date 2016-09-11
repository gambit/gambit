/* SUMFP -- Compute sum of integers from 0 to 10000 using floating point */

#include <stdio.h>

#define FLOAT double

static FLOAT run (FLOAT n)
{
  FLOAT i = n, sum = 0.;

  while (i >= 0.)
    {
      sum = sum+i;
      i = i-1.;
    }

  return sum;
}

int main (int argc, char *argv[])
{
  int i;
  FLOAT result;
  int n = 10000;

  if (argc > 1)
    n = atoi (argv[1]);

  for (i=0; i<5000; i++)
    result = run (n);

  if (result != 50005000.)
    printf ("*** wrong result ***\n");

  return 0;
}
