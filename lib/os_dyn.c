/* File: "os_dyn.c", Time-stamp: <2009-06-07 10:55:37 feeley> */

/* Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to dynamic code (loading, C closures).
 */

#define ___INCLUDED_FROM_OS_DYN
#define ___VERSION 404003
#include "gambit.h"

#include "os_base.h"
#include "os_dyn.h"
#include "os_shell.h"


/*---------------------------------------------------------------------------*/


___dyn_module ___dyn_mod =
{
  0

#ifdef ___DYN_MODULE_INIT
  ___DYN_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

/* Dynamic code loading. */


___HIDDEN void setup_dynamic_load ___PVOID
{
#ifdef ___DL_DESCR

  ___dyn_mod.dl_list = 0;

#endif
}


___HIDDEN ___SCMOBJ dynamic_load_module
   ___P((___STRING_TYPE(___DL_PATH_CE_SELECT) cpath,
         ___STRING_TYPE(___DL_MODNAME_CE_SELECT) cmodname,
         void **linker),
        (cpath,
         cmodname,
         linker)
___STRING_TYPE(___DL_PATH_CE_SELECT) cpath;
___STRING_TYPE(___DL_MODNAME_CE_SELECT) cmodname;
void **linker;)
{
  ___SCMOBJ e;
  ___SCMOBJ result = ___FIX(___UNIMPL_ERR);

#ifndef ___DL_DESCR

  result = ___FIX(___DYNAMIC_LOADING_NOT_AVAILABLE_ERR);

#else

  ___dl_entry *p;

  p = ___CAST(___dl_entry*,
              ___alloc_mem (sizeof (___dl_entry)));

  if (p == 0)
    return ___FIX(___HEAP_OVERFLOW_ERR);

#ifdef USE_shl_load

  p->descr = shl_load (cpath, BIND_IMMEDIATE, 0);

  if (p->descr == 0)
    result = err_code_from_errno ();
  else if (!shl_findsym (&p->descr, cmodname, TYPE_PROCEDURE, linker) &&
           *linker != 0)
    result = ___FIX(___NO_ERR);
  else
    {
      result = ___FIX(___DYNAMIC_LOADING_LOOKUP_ERR);
      shl_unload (p->descr);
    }

#endif

#ifdef USE_LoadLibrary

  p->descr = LoadLibrary (cpath);

  if (p->descr != 0 &&
      (*linker = ___CAST(void*,GetProcAddress (p->descr, cmodname))) != 0)
    result = ___FIX(___NO_ERR);
  else
    {
      result = err_code_from_GetLastError ();

      if (p->descr != 0)
        FreeLibrary (p->descr);
    }

#endif

#ifdef USE_DosLoadModule

  {
    HMODULE hmodule;
    APIRET rc;
    char real_path[280];
    int i;

    e = ___FIX(___NO_ERR);

    i = 0;
    while (cpath[i] != '\0')
      i++;

    if (i <= 4 ||
        cpath[i-1] != 'l' && cpath[i-1] != 'L' ||
        cpath[i-2] != 'l' && cpath[i-2] != 'L' ||
        cpath[i-3] != 'd' && cpath[i-3] != 'D' ||
        cpath[i-4] != '.')
      {
        /* if path doesn't end in ".dll" we must find the real ".dll" path */

        FILE *f = fopen (cpath, "r");

        if (f == 0 || !fgets (real_path, 280, f))
          e = err_code_from_errno ();
        else
          cpath = real_path;

        if (f != 0)
          fclose (f);
      }

    if (e != ___FIX(___NO_ERR))
      result = e;
    else
      {
        char *errmsg = 0;
        char errbuf[256];

        if (DosLoadModule (errbuf, 256, cpath, &hmodule) != NO_ERROR)
          errmsg = errbuf;
        else
          {
            p->descr = hmodule;

            rc = DosQueryProcAddr (hmodule, 0L, cmodname, linker);

            if (rc != NO_ERROR || *linker == 0)
              {
                switch (rc)
                  {
                  case ERROR_INVALID_HANDLE:
                    errmsg = "Invalid handle";
                    break;
                  case ERROR_INVALID_NAME:
                    errmsg = "Invalid name";
                    break;
                  case ERROR_INVALID_ORDINAL:
                    errmsg = "Invalid ordinal";
                    break;
                  case ERROR_ENTRY_IS_CALLGATE:
                    errmsg = "Entry is callgate";
                    break;
                  default:
                    errmsg = "Unknown error";
                    break;
                  }

                DosFreeModule (hmodule);
              }
          }

        if (errmsg != 0)
          {
            if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                       (errmsg,
                        &result,
                        ___RETURN_POS))
                != ___FIX(___NO_ERR))
              result = e;
          }
      }
  }

#endif

#ifdef USE_dxe_load

  p->descr = _dxe_load (cpath);

  if ((*linker = p->descr) != 0)
    result = ___FIX(___NO_ERR);
  else
    result = ___FIX(___DYNAMIC_LOADING_LOOKUP_ERR);

#endif

#ifdef USE_GetDiskFragment

  {
    OSErr err;
    Ptr mainadr, procadr;
    Str63 ppath;
    Str255 pmodname;
    Str255 pmsg;
    char msg[256];
    FSSpec spec;

    if (!c2pascal (cpath, ppath, sizeof(ppath)-1))
      *errmsg = "Path is too long";
    else if (!c2pascal (cmodname, pmodname, sizeof(pmodname)-1))
      *errmsg = "Module name is too long";
    else if (make_ResolvedFSSpec (0, 0, ppath, &spec) != noErr)
      *errmsg = "Invalid path";
    else
      {
        err = GetDiskFragment (&spec, 0, kCFragGoesToEOF, ppath,
                               kPrivateCFragCopy, &p->descr, &mainadr, pmsg);
        if (err != noErr)
          {
            pascal2c (pmsg, msg, 255);
            sprintf (dl_error_buffer,
                     "GetDiskFragment failed with error code %d on \"%s\"",
                     err,
                     msg);
            *errmsg = dl_error_buffer;
          }
        else
          {
            if (FindSymbol (p->descr, pmodname, &procadr, kCodeCFragSymbol)
                != noErr)
              {
                *errmsg = "FindSymbol failed";
                CloseConnection (&p->descr);
              }
            else
              *linker = ___CAST(void*,procadr);
          }
      }
  }

#endif

#ifdef USE_dlopen

#ifdef RTLD_NOW
  p->descr = dlopen (cpath, RTLD_NOW);
#else
  p->descr = dlopen (cpath, 1);
#endif

  if (p->descr != 0 &&
      (*linker = dlsym (p->descr, cmodname)) != 0)
    result = ___FIX(___NO_ERR);
  else
    {
      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (___CAST(char*,dlerror ()),
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;

      if (p->descr != 0)
        dlclose (p->descr);
    }

#endif

#ifdef USE_NSLinkModule

  {
    NSSymbol sym;

    if (NSIsSymbolNameDefined (cmodname))
      {
        sym = NSLookupAndBindSymbol (cmodname);

        if ((*linker = NSAddressOfSymbol (sym)) != 0)
          result = ___FIX(___NO_ERR);
        else
          result = ___FIX(___DYNAMIC_LOADING_LOOKUP_ERR);
      }
    else
      {
        NSObjectFileImage img;
        NSObjectFileImageReturnCode code;

        if ((code = NSCreateObjectFileImageFromFile (cpath, &img))
            == NSObjectFileImageSuccess)
          {
            p->descr = NSLinkModule (img, cpath, NSLINKMODULE_OPTION_BINDNOW);

            if (p->descr != 0 &&
                (sym = NSLookupSymbolInModule (p->descr, cmodname)) != 0 &&
                (*linker = NSAddressOfSymbol (sym)) != 0)
              result = ___FIX(___NO_ERR);
            else
              {
                result = ___FIX(___DYNAMIC_LOADING_LOOKUP_ERR);

                if (p->descr != 0)
                  NSUnLinkModule (p->descr, NSUNLINKMODULE_OPTION_NONE);
              }

            NSDestroyObjectFileImage (img);
          }
        else
          {
            char *errmsg = 0;

            switch (code)
              {
              case NSObjectFileImageFailure:
                errmsg = "(NSObjectFileImageFailure) The operation was not successfully completed";
                break;

              case NSObjectFileImageInappropriateFile:
                errmsg = "(NSObjectFileImageInappropriateFile) The specified Mach-O file is not of a type this function can operate upon";
                break;

              case NSObjectFileImageArch:
                errmsg = "(NSObjectFileImageArch) The specified Mach-O file is for a different CPU architecture";
                break;

              case NSObjectFileImageFormat:
                errmsg = "(NSObjectFileImageFormat) The specified file does not appear to be a Mach-O file";
                break;

              case NSObjectFileImageAccess:
                errmsg = "(NSObjectFileImageAccess) The access permissions for the specified file do not permit the creation of the image";
                break;

              default:
                errmsg = "unknown error returned from NSCreateObjectFileImageFromFile";
                break;
              }

            if (errmsg != 0)
              {
                if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                           (errmsg,
                            &result,
                            ___RETURN_POS))
                    != ___FIX(___NO_ERR))
                  result = e;
              }
          }
      }
  }

#endif

  if (result != ___FIX(___NO_ERR))
    ___free_mem (p);
  else
    {
      p->next = ___dyn_mod.dl_list;
      ___dyn_mod.dl_list = p;
    }

#endif

  if (result != ___FIX(___NO_ERR))
    {
      ___SCMOBJ r = ___make_vector (2, ___FAL, ___STILL);

      if (!___FIXNUMP(r))
        {
          ___SCMOBJ modname;

          if ((e = ___NONNULLSTRING_to_SCMOBJ
                     (cmodname,
                      &modname,
                      ___RETURN_POS,
                      ___CE(___DL_MODNAME_CE_SELECT)))
              != ___FIX(___NO_ERR))
            ___release_scmobj (r);
          else
            {
              ___VECTORSET(r,___FIX(0),result)
              ___VECTORSET(r,___FIX(1),modname)
              ___release_scmobj (result);
              ___release_scmobj (modname);
              result = r;
            }
        }
    }

  return result;
}


___HIDDEN void cleanup_dynamic_load ___PVOID
{
#ifndef ___DONT_UNLOAD_DYN_CODE

/*
 * When the --fprofile-arcs option of gcc is used, shared libraries
 * must not be unloaded, otherwise a segmentation fault occurs on
 * program exit (specifically when gcov_exit is called).
 */

#ifdef ___DL_DESCR

  ___dl_entry *p = ___dyn_mod.dl_list;
  while (p != 0)
    {
      ___dl_entry *next = p->next;

#ifdef USE_shl_load
      shl_unload (p->descr);
#endif

#ifdef USE_LoadLibrary
      FreeLibrary (p->descr);
#endif

#ifdef USE_DosLoadModule
      DosFreeModule (p->descr);
#endif

#ifdef USE_dxe_load
#endif

#ifdef USE_GetDiskFragment
      CloseConnection (&p->descr);
#endif

#ifdef USE_dlopen
      dlclose (p->descr);
#endif

#ifdef USE_NSLinkModule
      NSUnLinkModule (p->descr, NSUNLINKMODULE_OPTION_NONE);
#endif

      ___free_mem (p);
      p = next;
    }

  ___dyn_mod.dl_list = 0;

#endif

#endif
}


___HIDDEN char c_id_prefix[] =
#ifdef ___IMPORTED_ID_PREFIX
___IMPORTED_ID_PREFIX
#endif
___C_ID_PREFIX;

#define c_id_prefix_length (sizeof (c_id_prefix) - 1)

___HIDDEN char c_id_suffix[] =
#ifdef ___IMPORTED_ID_SUFFIX
___IMPORTED_ID_SUFFIX
#endif
"";

#define c_id_suffix_length (sizeof (c_id_suffix) - 1)

___HIDDEN char hex_digits[] = "0123456789abcdef";

#define c_id_subsequent(c) \
(((c)>='A'&&(c)<='Z') || \
 ((c)>='a'&&(c)<='z') || \
 ((c)>='0'&&(c)<='9') || \
 ((c)=='_'))


___HIDDEN ___SCMOBJ ___SCMOBJ_to_MODNAMESTRING
   ___P((___SCMOBJ obj,
         void **x,
         int arg_num),
        (obj,
         x,
         arg_num)
___SCMOBJ obj;
void **x;
int arg_num;)
{
  ___STRING_TYPE(___DL_MODNAME_CE_SELECT) r;
  int len;
  int i;
  int j;
  ___SCMOBJ ___temp; /* used by ___STRINGP */

  if (!___STRINGP(obj))
    return ___FIX(___DL_MODNAME_CE_SELECT(___STOC_NONNULLISO_8859_1STRING_ERR,
                                          ___STOC_NONNULLUTF_8STRING_ERR,
                                          ___STOC_NONNULLUCS_2STRING_ERR,
                                          ___STOC_NONNULLUCS_4STRING_ERR,
                                          ___STOC_NONNULLWCHARSTRING_ERR,
                                          ___STOC_NONNULLCHARSTRING_ERR)
                  + arg_num);

  len = ___INT(___STRINGLENGTH(obj));
  i = len - 1;
  j = c_id_prefix_length + c_id_suffix_length;

  for (i=len-1; i>=0; i--)
    {
      ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
      if (c == '_')
        j += 2;
      else if (c_id_subsequent(c))
        j++;
      else
        {
          j += 3;
          while (c > 15)
            {
              c >>= 4;
              j++;
            }
        }
    }

  r = ___CAST(___STRING_TYPE(___DL_MODNAME_CE_SELECT),
              ___alloc_mem ((j+1) *
                            sizeof (___CHAR_TYPE(___DL_MODNAME_CE_SELECT))));

  if (r == 0)
    return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

  r[j--] = '\0';

  i = c_id_suffix_length;

  while (i > 0)
    r[j--] = c_id_suffix[--i];

  for (i=len-1; i>=0; i--)
    {
      ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
      if (c == '_')
        {
          r[j--] = '_';
          r[j--] = '_';
        }
      else if (c_id_subsequent(c))
        r[j--] = c;
      else
        {
          r[j--] = '_';
          do
            {
              r[j--] = hex_digits[c & 15];
              c >>= 4;
            } while (c != 0);
          r[j--] = '_';
        }
    }

  for (i=c_id_prefix_length-1; i>=0; i--)
    r[j--] = c_id_prefix[i];

  *x = r;

  return ___FIX(___NO_ERR);
}


___SCMOBJ ___dynamic_load
   ___P((___SCMOBJ path,
         ___SCMOBJ modname,
         void **linker),
        (path,
         modname,
         linker)
___SCMOBJ path;
___SCMOBJ modname;
void **linker;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  void *cpath;
  void *cmodname;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (path,
              &cpath,
              1,
              ___CE(___DL_PATH_CE_SELECT),
              0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if ((e = ___SCMOBJ_to_MODNAMESTRING
                 (modname,
                  &cmodname,
                  2))
          != ___FIX(___NO_ERR))
        result = e;
      else
        {
          result = dynamic_load_module
                     (___CAST(___STRING_TYPE(___DL_PATH_CE_SELECT),cpath),
                      ___CAST(___STRING_TYPE(___DL_MODNAME_CE_SELECT),cmodname),
                      linker);

          ___free_mem (cmodname);
        }

      ___release_string (cpath);
    }

  return result;
}


/*---------------------------------------------------------------------------*/

/* Allocation of C closures. */


#ifdef USE_dynamic_code_gen

#ifdef ___CPU_x86
#if ___WORD_SIZE == 32
#define C_CLOSURE_CODE_SIZE 16
#endif
#endif

#ifdef ___CPU_ppc
#if ___WORD_SIZE == 32
#define C_CLOSURE_CODE_SIZE (9*4)
#endif
#ifndef __GNUC__
#undef C_CLOSURE_CODE_SIZE
#endif
#ifndef __GNUC__
#ifndef USE_CLASSIC_MACOS
#undef C_CLOSURE_CODE_SIZE
#endif
#endif
#endif

#ifdef ___CPU_sparc
#if ___WORD_SIZE == 32
#define C_CLOSURE_CODE_SIZE (7*4)
#else
#define C_CLOSURE_CODE_SIZE (19*4)
#endif
#ifndef __GNUC__
#undef C_CLOSURE_CODE_SIZE
#endif
#endif

#endif


#ifdef C_CLOSURE_CODE_SIZE

___LOCAL void sync_icache_and_dcache (void *start, int length)
{
#ifdef ___CPU_x86

  /*
   * The x86 processor automatically keeps the icache and dcache in
   * sync, as long as there's a jump instruction between the code
   * modification and the use of the modified code.
   */

#endif

#ifdef ___CPU_ppc

#ifdef __GNUC__

#define CACHE_BLOCK_SIZE 4 /* we are conservative! */

  ___U8 *s = ___CAST(___U8*,___CAST(long,start) & -CACHE_BLOCK_SIZE);

  do
    {
      __asm__ __volatile__ ("dcbf 0,%0" : : "r" (s) : "memory");
      __asm__ __volatile__ ("sync" : : : "memory");
      __asm__ __volatile__ ("icbi 0,%0" : : "r" (s) : "memory");
      s += CACHE_BLOCK_SIZE;
      length -= CACHE_BLOCK_SIZE;
    } while (length > 0);

  __asm__ __volatile__ ("sync" : : : "memory");
  __asm__ __volatile__ ("isync" : : : "memory");

#else

#ifdef USE_CLASSIC_MACOS

  MakeDataExecutable (start, length);

#endif

#endif

#ifdef ___CPU_sparc

#ifdef __GNUC__

#define MACHINE_WORD_SIZE 4

  ___U8 *s = ___CAST(___U8*,___CAST(long,start) & -MACHINE_WORD_SIZE);

  do
    {
      __asm__ __volatile__ ("flush %0" : : "g" (s) : "memory");
      s += MACHINE_WORD_SIZE;
      length -= MACHINE_WORD_SIZE;
    } while (length > 0);

#endif

#endif

#endif
}

#endif


___LOCAL void *c_closure_self; /* set by the C closure trampoline code */


void *___make_c_closure
   ___P((___SCMOBJ proc,
         void *converter),
        (proc,
         converter)
___SCMOBJ proc;
void *converter;)
{
  void *c_closure;

#ifndef C_CLOSURE_CODE_SIZE

  c_closure = 0;

#else

  if ((c_closure = ___alloc_rc (C_CLOSURE_CODE_SIZE)) == 0)
    return 0;

  ___set_data_rc (c_closure, proc);

  /* Generate the trampoline code of the C closure. */

  /*
   * A "C closure" is a short piece of machine code that does the following:
   *
   *   1) stores its own address in the global variable "c_closure_self"
   *   2) jumps to the "converter" function (which is a C function generated
   *      by the Gambit-C compiler's C-interface)
   *
   * The code must not change any processor register or stack location
   * that is used in the C calling convention.  In this way, the
   * converter function will think that it received the parameters
   * directly from the caller.  The only side-effect of the C closure
   * code is that the global variable "c_closure_self" will point to
   * the C closure, allowing the converter function to access other
   * data stored with the C closure (namely a reference to the Scheme
   * procedure that the converter function needs to call).
   *
   * After generating the trampoline code of the C closure, it is
   * important to synchronize the instruction and data caches so that
   * the processor does not execute stale instructions in the instruction
   * cache.
   */

#ifdef ___CPU_x86

  {
    ___U8 *p = ___CAST(___U8*,c_closure);

                                     /* x86 machine code                     */

    p[ 0] = 0x68;                    /* pushl $p                             */
    p[ 1] = ___CAST_U8(___CAST_U32(p));
    p[ 2] = ___CAST_U8(___CAST_U32(p)>>8);
    p[ 3] = ___CAST_U8(___CAST_U32(p)>>16);
    p[ 4] = ___CAST_U8(___CAST_U32(p)>>24);
    p[ 5] = 0x8f;                    /* popl  c_closure_self                 */
    p[ 6] = 0x05;
    p[ 7] = ___CAST_U8(___CAST_U32(&c_closure_self));
    p[ 8] = ___CAST_U8(___CAST_U32(&c_closure_self)>>8);
    p[ 9] = ___CAST_U8(___CAST_U32(&c_closure_self)>>16);
    p[10] = ___CAST_U8(___CAST_U32(&c_closure_self)>>24);
    p[11] = 0xe9;                    /* jmp   converter                      */
    p[12] = ___CAST_U8(___CAST_U32(___CAST(___U8*,converter)-(p+16)));
    p[13] = ___CAST_U8(___CAST_U32(___CAST(___U8*,converter)-(p+16))>>8);
    p[14] = ___CAST_U8(___CAST_U32(___CAST(___U8*,converter)-(p+16))>>16);
    p[15] = ___CAST_U8(___CAST_U32(___CAST(___U8*,converter)-(p+16))>>24);
  }

#endif

#ifdef ___CPU_ppc

  {
    ___U32 *p = ___CAST(___U32*,c_closure);

                                     /* PowerPC machine code                 */

    p[0] = 0x39600000                /* li    r11,LO16(converter)            */
           + ___CAST_U32(___CAST_U16(___CAST_U32(converter)));
    p[1] = 0x3d6b0000                /* addis r11,r11,HI16(converter)        */
           + (___CAST_U32(converter) >> 16)
           + ((___CAST_U32(converter) & 0x8000) ? 1 : 0);
    p[2] = 0x7d6903a6;               /* mtspr ctr,r11                        */
    p[3] = 0x39600000                /* li    r11,LO16(p)                    */
           + ___CAST_U32(___CAST_U16(___CAST_U32(p)));
    p[4] = 0x3d6b0000                /* addis r11,r11,HI16(p)                */
           + (___CAST_U32(p) >> 16)
           + ((___CAST_U32(p) & 0x8000) ? 1 : 0);
    p[5] = 0x380b0000;               /* addi  r0,r11,0                       */
    p[6] = 0x3d600000                /* lis   r11,HI16(c_closure_self)       */
           + (___CAST_U32(&c_closure_self) >> 16)
           + ((___CAST_U32(&c_closure_self) & 0x8000) ? 1 : 0);
    p[7] = 0x900b0000                /* stw   r0,LO16(c_closure_self)(r11)   */
           + ___CAST_U32(___CAST_U16(___CAST_U32(&c_closure_self)));
    p[8] = 0x4e800420;               /* bctr                                 */
  }

#endif

#ifdef ___CPU_sparc

  {
    ___U32 *p = ___CAST(___U32*,c_closure);

                                    /* SPARC machine code                   */

#if ___WORD_WIDTH == 32

    p[0] = 0x07000000                /* sethi HI22(p),%g3                    */
           + (___CAST_U32(p) >> 10);
    p[1] = 0x8610E000                /* or    %g3,LO10(p),%g3                */
           + (___CAST_U32(p) & 0x3ff);
    p[2] = 0x05000000                /* sethi HI22(c_closure_self),%g2       */
           + (___CAST_U32(&c_closure_self) >> 10);
    p[3] = 0xC620A000                /* st    %g3,[%g2+LO10(c_closure_self)] */
           + (___CAST_U32(&c_closure_self) & 0x3ff);
    p[4] = 0x05000000                /* sethi HI22(converter),%g2            */
           + (___CAST_U32(converter) >> 10);
    p[5] = 0x81C0A000                /* jmp   %g2+LO10(converter)            */
           + (___CAST_U32(converter) & 0x3ff);
    p[6] = 0x01000000;               /* nop                                  */

#else

    p[ 0] = 0x07000000               /* sethi HHI22(p),%g3                   */
           + (___CAST_U64(p) >> (10+32));
    p[ 1] = 0x8610E000               /* or    %g3,HLO10(p),%g3               */
           + ((___CAST_U64(p) >> 32) & 0x3ff);
    p[ 2] = 0x8728F020;              /* sllx  %g3,32,%g3                     */
    p[ 3] = 0x03000000               /* sethi LHI22(p),%g1                   */
           + ((___CAST_U64(p) >> 10) & 0x3fffff);
    p[ 4] = 0x82106000               /* or    %g1,LLO10(p),%g1               */
           + (___CAST_U64(p) & 0x3ff);
    p[ 5] = 0x8600C001;              /* add   %g3,%g1,%g3                    */
    p[ 6] = 0x05000000               /* sethi HHI22(c_closure_self),%g2      */
           + (___CAST_U64(&c_closure_self) >> (10+32));
    p[ 7] = 0x8410A000               /* or    %g2,HLO10(c_closure_self),%g2  */
           + ((___CAST_U64(&c_closure_self) >> 32) & 0x3ff);
    p[ 8] = 0x8528B020;              /* sllx  %g2,32,%g2                     */
    p[ 9] = 0x03000000               /* sethi LHI22(c_closure_self),%g1      */
           + ((___CAST_U64(&c_closure_self) >> 10) & 0x3fffff);
    p[10] = 0x84008001;              /* add   %g2,%g1,%g2                    */
    p[11] = 0xC670A000               /* stx   %g3,[%g2+LLO10(c_closure_self)]*/
           + (___CAST_U64(&c_closure_self) & 0x3ff);
    p[12] = 0x05000000               /* sethi HHI22(converter),%g2           */
           + (___CAST_U64(converter) >> (10+32));
    p[13] = 0x8410A000               /* or    %g2,HLO10(converter),%g2       */
           + ((___CAST_U64(converter) >> 32) & 0x3ff);
    p[14] = 0x8528B020;              /* sllx  %g2,32,%g2                     */
    p[15] = 0x03000000               /* sethi LHI22(converter),%g1           */
           + ((___CAST_U64(converter) >> 10) & 0x3fffff);
    p[16] = 0x84008001;              /* add   %g2,%g1,%g2                    */
    p[17] = 0x81C0A000               /* jmp   %g2+LLO10(converter)           */
           + (___CAST_U64(converter) & 0x3ff);
    p[18] = 0x01000000;              /* nop                                  */

#endif
  }

#endif

    sync_icache_and_dcache (c_closure, C_CLOSURE_CODE_SIZE);

#endif

  return c_closure;
}


___BOOL ___is_a_c_closure
   ___P((void *fn),
        (fn)
void *fn;)
{
#ifndef C_CLOSURE_CODE_SIZE

  return 0;

#else

  /*
   * We check that the function's code contains the same sequence that
   * is generated by ___make_c_closure.  If there is a match, we are
   * sure that the function was generated by ___make_c_closure because
   * it is impossible for the C compiler to have generated this code
   * for a valid C function.
   */

#ifdef ___CPU_x86

  {
    ___U8 *p = ___CAST(___U8*,fn);

    return p != 0 &&
           p[ 0] == 0x68 &&
           p[ 1] == ___CAST_U8(___CAST_U32(p)) &&
           p[ 2] == ___CAST_U8(___CAST_U32(p)>>8) &&
           p[ 3] == ___CAST_U8(___CAST_U32(p)>>16) &&
           p[ 4] == ___CAST_U8(___CAST_U32(p)>>24) &&
           p[ 5] == 0x8f &&
           p[ 6] == 0x05 &&
           p[ 7] == ___CAST_U8(___CAST_U32(&c_closure_self)) &&
           p[ 8] == ___CAST_U8(___CAST_U32(&c_closure_self)>>8) &&
           p[ 9] == ___CAST_U8(___CAST_U32(&c_closure_self)>>16) &&
           p[10] == ___CAST_U8(___CAST_U32(&c_closure_self)>>24) &&
           p[12] == 0xe9;
  }

#endif

#ifdef ___CPU_ppc

  {
    ___U32 *p = ___CAST(___U32*,fn);

    return p != 0 &&
           (p[0] >> 16) == 0x3d6b &&
           p[1] == 0x7d6903a6 &&
           (p[2] >> 16) == 0x3960 &&
           p[3] == 0x39600000
                   + ___CAST_U32(___CAST_U16(___CAST_U32(p))) &&
           p[4] == 0x3d6b0000
                   + (___CAST_U32(p) >> 16)
                   + ((___CAST_U32(p) & 0x8000) ? 1 : 0) &&
           p[5] == 0x380b0000 &&
           p[6] == 0x3d600000
                   + (___CAST_U32(&c_closure_self) >> 16)
                   + ((___CAST_U32(&c_closure_self) & 0x8000) ? 1 : 0) &&
           p[7] == 0x900b0000
                   + ___CAST_U32(___CAST_U16(___CAST_U32(&c_closure_self))) &&
           p[8] == 0x4e800420;
  }

#endif

#ifdef ___CPU_sparc

  {
    ___U32 *p = ___CAST(___U32*,fn);

#if ___WORD_WIDTH == 32

    return p != 0 &&
           p[0] == 0x07000000
                   + (___CAST_U32(p) >> 10) &&
           p[1] == 0x8610E000
                   + (___CAST_U32(p) & 0x3ff) &&
           p[2] == 0x05000000
                   + (___CAST_U32(&c_closure_self) >> 10) &&
           p[3] == 0xC620A000
                   + (___CAST_U32(&c_closure_self) & 0x3ff) &&
           (p[4] >> 22) == (0x05000000 >> 22) &&
           (p[5] >> 10) == (0x81C0A000 >> 10) &&
           p[6] == 0x01000000;

#else

    return p != 0 &&
           p[ 0] == 0x07000000
                   + (___CAST_U64(p) >> (10+32)) &&
           p[ 1] == 0x8610E000
                   + ((___CAST_U64(p) >> 32) & 0x3ff) &&
           p[ 2] == 0x8728F020 &&
           p[ 3] == 0x03000000
                   + ((___CAST_U64(p) >> 10) & 0x3fffff) &&
           p[ 4] == 0x82106000
                   + (___CAST_U64(p) & 0x3ff) &&
           p[ 5] == 0x8600C001 &&
           p[ 6] == 0x05000000
                   + (___CAST_U64(&c_closure_self) >> (10+32)) &&
           p[ 7] == 0x8410A000
                   + ((___CAST_U64(&c_closure_self) >> 32) & 0x3ff) &&
           p[ 8] == 0x8528B020 &&
           p[ 9] == 0x03000000
                   + ((___CAST_U64(&c_closure_self) >> 10) & 0x3fffff) &&
           p[10] == 0x84008001 &&
           p[11] == 0xC670A000
                   + (___CAST_U64(&c_closure_self) & 0x3ff) &&
           (p[12] >> 22) == (0x05000000 >> 22) &&
           (p[13] >> 10) == (0x8410A000 >> 10) &&
           p[14] == 0x8528B020 &&
           (p[15] >> 22) == (0x03000000 >> 22) &&
           p[16] == 0x84008001 &&
           (p[17] >> 10) == (0x81C0A000 >> 10) &&
           p[18] == 0x01000000;

#endif
  }

#endif

#endif
}


void ___c_closure_release
   ___P((void *c_closure),
        (c_closure)
void *c_closure;)
{
  ___release_rc (c_closure);
}


void *___c_closure_self ___PVOID
{
  return c_closure_self;
}


/*---------------------------------------------------------------------------*/

/* Dynamic code module initialization/finalization. */


___SCMOBJ ___setup_dyn_module ___PVOID
{
  if (!___dyn_mod.setup)
    {
      setup_dynamic_load ();
      ___dyn_mod.setup = 1;
      return ___FIX(___NO_ERR);
    }

  return ___FIX(___UNKNOWN_ERR);
}


void ___cleanup_dyn_module ___PVOID
{
  if (___dyn_mod.setup)
    {
      cleanup_dynamic_load ();
      ___dyn_mod.setup = 0;
    }
}


/*---------------------------------------------------------------------------*/
