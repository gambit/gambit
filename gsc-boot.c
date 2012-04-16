/* File: "gsc-boot.c" */

/* Copyright (c) 2012 by Marc Feeley, All Rights Reserved. */

/*
 * Due to the meta-circular nature of the system, an executable
 * version of the Gambit compiler (gsc-boot) is necessary to compile
 * the .scm source files that are part of the Gambit runtime library
 * into .c files.  The Gambit git repository contains precompiled
 * versions of these files.  When Gambit is initially built, it is
 * necessary to avoid generating these .c files (since an executable
 * Gambit compiler is not yet available to generate them).  This
 * circular dependence is resolved by using a dummy gsc-boot program
 * which does not touch the .c files obtained from the repository.
 */

int main(int argc, char *argv[])
{
  /*
  printf("***DUMMY*** compilation (this is normal when bootstrapping)\n");
  */

  return 0;
}
