/* PNPOLY - Test if a point is contained in a 2D polygon. */

#include <stdio.h>

/*
  The code below is from Wm. Randolph Franklin <wrf@ecse.rpi.edu>
  with some minor modifications for speed and style.
  comp.graphics.algorithms FAQ 
  References:
    [Gems IV]  pp. 24-46
    [O'Rourke] pp. 233-238
    [Glassner:RayTracing]
*/

static int pnpoly(int npol, double *xp, double *yp, double x, double y)
{
  int i, j, c = 0;
  for (i = 0, j = npol-1; i < npol; j = i++)
    {
      if ((((yp[i]<=y) && (y<yp[j])) ||
           ((yp[j]<=y) && (y<yp[i]))) &&
          (x < (xp[j] - xp[i]) * (y - yp[i]) / (yp[j] - yp[i]) + xp[i]))
        c = !c;
    }
  return c;
}

static double xp[20] = {0.0,1.0,1.0,0.0,0.0,1.0,-.5,-1.0,-1.0,-2.0,
                        -2.5,-2.0,-1.5,-.5,1.0,1.0,0.0,-.5,-1.0,-.5};
static double yp[20] = {0.0,0.0,1.0,1.0,2.0,3.0,2.0,3.0,0.0,-.5,
                        -1.0,-1.5,-2.0,-2.0,-1.5,-1.0,-.5,-1.0,-1.0,-.5};

static int run ()
{
  int npol=20, count=0;
  if (pnpoly(npol,xp,yp,0.5,0.5)) count++;
  if (pnpoly(npol,xp,yp,0.5,1.5)) count++;
  if (pnpoly(npol,xp,yp,-.5,1.5)) count++;
  if (pnpoly(npol,xp,yp,0.75,2.25)) count++;
  if (pnpoly(npol,xp,yp,0,2.01)) count++;
  if (pnpoly(npol,xp,yp,-.5,2.5)) count++;
  if (pnpoly(npol,xp,yp,-1.0,-.5)) count++;
  if (pnpoly(npol,xp,yp,-1.5,.5)) count++;
  if (pnpoly(npol,xp,yp,-2.25,-1.0)) count++;
  if (pnpoly(npol,xp,yp,0.5,-.25)) count++;
  if (pnpoly(npol,xp,yp,0.5,-1.25)) count++;
  if (pnpoly(npol,xp,yp,-.5,-2.5)) count++;
  return count;
}

int main (int argc, char *argv[])
{
  int i;
  int result;

  for (i=0; i<100000; i++)
    result = run ();

  if (result != 6)
    printf ("*** wrong result ***\n");

  return 0;
}
