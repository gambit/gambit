/* FFT - Fast Fourier Transform */

#include <stdio.h>
#include <math.h>

#define FLOAT double

#define pi2 6.28318530717959

#define SWAP(a,b) { FLOAT temp = a; a = b; b = temp; }

static void four1 (FLOAT *data, int n)
{
  int i, j, m, mmax;

  i = 0;
  j = 0;
  while (i < n)
    {
      if (i < j)
        {
          SWAP(data[i], data[j]);
          SWAP(data[i+1], data[j+1]);
        }
      m = n/2;
      while (m >= 2 && j >= m)
        {
          j = j-m;
          m = m/2;
        }
      i += 2;
      j += m;
    }

  mmax = 2;
  while (mmax < n)
    {
      FLOAT theta = pi2/mmax;
      FLOAT x = sin (0.5*theta);
      FLOAT wpr = -2.0*x*x;
      FLOAT wpi= sin (theta);
      FLOAT wr = 1.0;
      FLOAT wi = 0.0;
      FLOAT temp, tempr, tempi;

      m = 0;
      while (m < mmax)
        {
          i = m;
          while (i < n)
            {
              j = i+mmax;
              tempr = wr*data[j]-wi*data[j+1];
              tempi = wi*data[j]+wr*data[j+1];
              data[j]   = data[i]-tempr;
              data[j+1] = data[i+1]-tempi;
              data[i]   = data[i]+tempr;
              data[i+1] = data[i+1]+tempi;
              i = j+mmax;
            }
          temp = wr;
          wr = temp*wpr-wi*wpi+wr;
          wi = wi*wpr+temp*wpi+wi;
          m += 2;
        }
      mmax *= 2;
    }
}

#define N 1024

FLOAT data[N];

static FLOAT test ()
{
  four1 (data, N);
  return data[0];
}

int main (int argc, char *argv[])
{
  int i;
  FLOAT result;

  for (i=0; i<N; i++)
    data[i] = 0.0;

  for (i=0; i<2000; i++)
    result = test ();

  if (result != 0.)
    printf ("*** wrong result ***\n");

  return 0;
}
