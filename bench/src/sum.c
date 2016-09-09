/* SUM -- Compute sum of integers from 0 to 10000 */

#include <stdio.h>

static int run (int n)
{
  int i = n, sum = 0;

  while (i >= 0)
    {
      sum = sum+i;
      i = i-1;
    }

  return sum;
}

int main (int argc, char *argv[])
{
  int i;
  int result;
  int n = 10000;

  if (argc > 1)
    n = atoi (argv[1]);

  for (i=0; i<20000; i++)
    result = run (n);

  if (result != 50005000)
    printf ("*** wrong result ***\n");

  return 0;
}
