/* TAK -- A vanilla version of the TAKeuchi function. */

#include <stdio.h>

static int tak (x, y, z)
int x, y, z;
{
  if (y >= x)
    return z;
  else
    return tak (tak (x-1, y, z),
                tak (y-1, z, x),
                tak (z-1, x, y));
}

int main (argc, argv)
int argc;
char *argv[];
{
  int i;
  int result;
  int x = 18, y = 12, z = 6;

  if (argc > 1)
    x = atoi (argv[1]);

  if (argc > 2)
    y = atoi (argv[2]);

  if (argc > 3)
    z = atoi (argv[3]);

  for (i=0; i<2000; i++)
    result = tak (x, y, z);

  if (result != 7)
    printf ("*** wrong result ***\n");

  return 0;
}
