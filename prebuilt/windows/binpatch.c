/* File: "binpatch.c" */

/* Copyright (c) 2007-2016 by Marc Feeley, All Rights Reserved. */

/* This is a tool for patching binary files */

/*---------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void binpatch (char *oldstr, char *newstr, char *filename)
{
  int oldlen = strlen (oldstr) + 1;
  int newlen = strlen (newstr) + 1;
  int step = 65536;
  int buflen = step + oldlen - 1;
  int pos;
  int len;
  char *buf;
  FILE *f;

  buf = malloc (buflen);
  if (buf == NULL)
    {
      printf ("Could not allocate buffer\n");
      exit (1);
    }

  f = fopen (filename, "r+b");

  if (f == NULL)
    {
      printf ("Could not open file \"%s\"\n", filename);
      exit (1);
    }

  fseek (f, 0, SEEK_END);
  len = ftell (f);
  if (len < 0)
    {
      fclose (f);
      printf ("Could not seek\n");
      exit (1);
    }

  pos = 0;

  while (pos < len)
    {
      int i;
      int n = len-pos;
      if (n > buflen)
	n = buflen;
      int x = fseek (f, pos, SEEK_SET);
      if (x < 0)
	{
	  fclose (f);
	  printf ("Could not seek\n");
	  exit (1);
	}
      if (fread (buf, 1, n, f) != n)
	{
	  fclose (f);
	  printf ("Could not read\n");
	  exit (1);
	}
      n = n - oldlen + 1;
      for (i=0; i<n; i++)
	if (buf[i] == oldstr[0])
	  {
	    int j;
	    for (j=1; j<oldlen; j++)
	      if (buf[i+j] != oldstr[j])
		goto fail;
	    pos = pos + i;
	    x = fseek (f, pos, SEEK_SET);
	    if (x < 0)
	      {
		fclose (f);
		printf ("Could not seek\n");
		exit (1);
	      }
	    if (fwrite (newstr, 1, newlen, f) != newlen)
	      {
		fclose (f);
		printf ("Could not write\n");
		exit (1);
	      }
	    fclose (f);
	    return;
	  fail: ;
	  }
      pos += step;
    }

  fclose (f);
  printf ("Did not find string in file \"%s\"\n", filename);
  exit (1);
}

int main (int argc, char *argv[])
{
  int i;

  if (argc < 3)
    {
      printf ("Usage: binpatch <old-string> <new-string> <filename>...\n");
      exit (1);
    }

  for (i=3; i<argc; i++)
    binpatch (argv[1], argv[2], argv[i]);

  return 0;
}

/*---------------------------------------------------------------------------*/
