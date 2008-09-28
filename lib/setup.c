/* File: "setup.c", Time-stamp: <2008-02-13 00:17:13 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

/* 
 * This module contains the routines that setup the Scheme program for
 * execution.
 */

#define ___INCLUDED_FROM_SETUP
#define ___VERSION 402009
#include "gambit.h"

#include "os_base.h"
#include "os_dyn.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"


/*---------------------------------------------------------------------------*/

/* 
 * Global state structure.
 */

___EXP_DATA(___global_state_struct,___gstate);


/*
 * Global variables needed by this module.
 */

___NEED_GLO(___G__23__23_kernel_2d_handlers) /* from "_kernel.scm" */
___NEED_GLO(___G__23__23_dynamic_2d_env_2d_bind)


/*
 * Parameters passed to ___setup.
 */

___HIDDEN ___UCS_2 reset_argv0[] = { 0 };
___HIDDEN ___UCS_2STRING reset_argv[] = { reset_argv0, 0 };

___setup_params_struct ___setup_params =
{ 0, reset_argv, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };


/* 
 * Initial length of symbol table and keyword table.
 */

#define INIT_SYMKEY_TBL_LENGTH 128


/*---------------------------------------------------------------------------*/

/* 
 * Interrupt handling.
 */

/*
 * '___raise_interrupt (code)' is called when an interrupt has
 * occured.  At some later point in time, the Gambit kernel will cause
 * the Scheme procedure ##interrupt-handler to be called with a single
 * integer argument indicating which interrupt has been received.
 * Interrupt codes are defined in "gambit.h".  Currently, the
 * following codes are defined:
 *
 *   ___INTR_USER        user has interrupted the program (e.g. ctrl-C)
 *   ___INTR_HEARTBEAT   heartbeat time interval has elapsed
 *   ___INTR_GC          a garbage collection has finished
 */

___EXP_FUNC(void,___raise_interrupt)
   ___P((int code),
        (code)
int code;)
{
  ___processor_state ___ps = ___PSTATE;

  /* 
   * Note: ___raise_interrupt may be called before the processor state
   * is initialized.  As a consequence, the interrupt(s) received
   * before the initialization of the processor state will be ignored.
   */

#ifdef CALL_GC_FREQUENTLY
  if (code != ___INTR_USER)
    return;
#endif

  ___ps->intr_flag[code] = 1;
  if (___ps->intr_enabled)
    ___ps->stack_trip = ___ps->stack_start;
}


___EXP_FUNC(void,___begin_interrupt_service) ___PVOID
{
  ___processor_state ___ps = ___PSTATE;

  ___ps->stack_trip = ___ps->stack_limit;
}


___EXP_FUNC(___BOOL,___check_interrupt)
   ___P((int code),
        (code)
int code;)
{
  ___processor_state ___ps = ___PSTATE;

  if (___ps->intr_flag[code])
    {
      ___ps->intr_flag[code] = 0;
      return 1;
    }

  return 0;
}


___EXP_FUNC(void,___end_interrupt_service)
   ___P((int code),
        (code)
int code;)
{
  ___processor_state ___ps = ___PSTATE;

  if (___ps->intr_enabled)
    {
#ifdef CALL_HANDLER_AT_EVERY_POLL
      ___ps->stack_trip = ___ps->stack_start;
#else
      while (code < ___NB_INTRS)
        {
          if (___ps->intr_flag[code]) /* don't ignore other interrupts */
            {
              ___ps->stack_trip = ___ps->stack_start;
              break;
            }
          code++;
        }
#endif
    }
}


___EXP_FUNC(void,___disable_interrupts) ___PVOID
{
  ___processor_state ___ps = ___PSTATE;

  ___ps->intr_enabled = 0;

  ___begin_interrupt_service ();
  ___end_interrupt_service (0);
}


___EXP_FUNC(void,___enable_interrupts) ___PVOID
{
  ___processor_state ___ps = ___PSTATE;

  ___ps->intr_enabled = 1;

  ___begin_interrupt_service ();
  ___end_interrupt_service (0);
}


/*---------------------------------------------------------------------------*/

/* 
 * Routines to setup symbol table, keyword table and global variable
 * table.
 */

/* 
 * The hashing functions 'hash_UTF_8_string (str)' and
 * 'hash_scheme_string (str)' must compute the same value as the
 * function 'targ-hash' in the file "gsc/_t-c-3.scm".
 * A fixnum error code is returned when there is an error.
 */

#define HASH_STEP(h,c) ((((h)>>8) + (c)) * 331804471) & ___MAX_FIX32

___HIDDEN ___SCMOBJ hash_UTF_8_string
   ___P((___UTF_8STRING str),
        (str)
___UTF_8STRING str;)
{
  ___UM32 h = 0;
  ___UTF_8STRING p = str;
  ___UCS_4 c;

  for (;;)
    {
      ___UTF_8STRING start = p;
      c = ___UTF_8_get (&p);
      if (p == start || c > ___MAX_CHR)
        return ___FIX(___CTOS_UTF_8STRING_ERR);
      if (c == 0)
        break;
      h = HASH_STEP(h,c);
    }

  return ___FIX(h);
}


___HIDDEN ___SCMOBJ hash_scheme_string
   ___P((___SCMOBJ str),
        (str)
___SCMOBJ str;)
{
  unsigned long i, n = ___INT(___STRINGLENGTH(str));
  ___UM32 h = 0;

  for (i=0; i<n; i++)
    h = HASH_STEP(h,___INT(___STRINGREF(str,___FIX(i))));

  return ___FIX(h);
}


___HIDDEN ___SCMOBJ symkey_table
   ___P((unsigned int subtype),
        (subtype)
unsigned int subtype;)
{
  switch (subtype)
    {
    case ___sKEYWORD:
      return ___GSTATE->keyword_table;
    default: /* assume ___sSYMBOL */
      return ___GSTATE->symbol_table;
    }
}


___HIDDEN void symkey_table_set
   ___P((unsigned int subtype,
         ___SCMOBJ new_table),
        (subtype,
         new_table)
unsigned int subtype;
___SCMOBJ new_table;)
{
  switch (subtype)
    {
    case ___sKEYWORD:
      ___GSTATE->keyword_table = new_table;
      break;
    default: /* assume ___sSYMBOL */
      ___GSTATE->symbol_table = new_table;
      break;
    }
}


___HIDDEN ___SCMOBJ symkey_table_alloc
   ___P((unsigned int subtype,
         long length),
        (subtype,
         length)
unsigned int subtype;
long length;)
{
  ___SCMOBJ tbl = ___make_vector (length+1, ___NUL, ___STILL);

  if (!___FIXNUMP(tbl))
    ___FIELD(tbl,0) = ___FIX(0);

  return tbl;
}


___HIDDEN void symkey_add
   ___P((___SCMOBJ symkey),
        (symkey)
___SCMOBJ symkey;)
{
  unsigned int subtype = ___INT(___SUBTYPE(symkey));
  ___SCMOBJ tbl = symkey_table (subtype);
  int i = ___INT(___FIELD(symkey,___SYMKEY_HASH))
          % (___INT(___VECTORLENGTH(tbl)) - 1)
          + 1;

  ___FIELD(symkey,___SYMKEY_NEXT) = ___FIELD(tbl,i);
  ___FIELD(tbl,i) = symkey;

  ___FIELD(tbl,0) = ___FIXADD(___FIELD(tbl,0),___FIX(1));

  if (___INT(___FIELD(tbl,0)) > ___INT(___VECTORLENGTH(tbl)) * 4)
    {
      int new_len = (___INT(___VECTORLENGTH(tbl))-1) * 2;
      ___SCMOBJ new_tbl = symkey_table_alloc (subtype, new_len);

      if (!___FIXNUMP(new_tbl))
        {
          for (i=___INT(___VECTORLENGTH(tbl))-1; i>0; i--)
            {
              ___SCMOBJ probe = ___FIELD(tbl,i);

              while (probe != ___NUL)
                {
                  ___SCMOBJ symkey = probe;
                  int j = ___INT(___FIELD(symkey,___SYMKEY_HASH))%new_len + 1;

                  probe = ___FIELD(symkey,___SYMKEY_NEXT);
                  ___FIELD(symkey,___SYMKEY_NEXT) = ___FIELD(new_tbl,j);
                  ___FIELD(new_tbl,j) = symkey;
                }
            }

          ___FIELD(new_tbl,0) = ___FIELD(tbl,0);

          symkey_table_set (subtype, new_tbl);
        }
    }
}


___HIDDEN ___SCMOBJ find_symkey_from_UTF_8_string
   ___P((char *str,
         unsigned int subtype),
        (str,
         subtype)
char *str;
unsigned int subtype;)
{
  ___SCMOBJ tbl;
  ___SCMOBJ probe;
  ___SCMOBJ h = hash_UTF_8_string (str);

  if (h < ___FIX(0))
    return h;

  tbl = symkey_table (subtype);
  probe = ___FIELD(tbl, ___INT(h) % (___INT(___VECTORLENGTH(tbl))-1) + 1);

  while (probe != ___NUL)
    {
      ___SCMOBJ name = ___FIELD(probe,___SYMKEY_NAME);
      unsigned long i;
      unsigned long n = ___INT(___STRINGLENGTH(name));
      ___UTF_8STRING p = str;
      for (i=0; i<n; i++)
        if (___UTF_8_get (&p) !=
            ___CAST(___UCS_4,___INT(___STRINGREF(name,___FIX(i)))))
          goto next;
      if (___UTF_8_get (&p) == 0)
        return probe;
    next:
      probe = ___FIELD(probe,___SYMKEY_NEXT);
    }

  return ___FAL;
}


___SCMOBJ ___find_symkey_from_scheme_string
   ___P((___SCMOBJ str,
         unsigned int subtype),
        (str,
         subtype)
___SCMOBJ str;
unsigned int subtype;)
{
  ___SCMOBJ tbl;
  ___SCMOBJ probe;
  ___SCMOBJ h = hash_scheme_string (str);

  tbl = symkey_table (subtype);
  probe = ___FIELD(tbl, ___INT(h) % (___INT(___VECTORLENGTH(tbl))-1) + 1);

  while (probe != ___NUL)
    {
      ___SCMOBJ name = ___FIELD(probe,___SYMKEY_NAME);
      long i = 0;
      long n = ___INT(___STRINGLENGTH(name));
      if (___INT(___STRINGLENGTH(str)) == n)
        {
          for (i=0; i<n; i++)
            if (___STRINGREF(str,___FIX(i)) != ___STRINGREF(name,___FIX(i)))
              goto next;
          return probe;
        }
    next:
      probe = ___FIELD(probe,___SYMKEY_NEXT);
    }

  return ___FAL;
}


___SCMOBJ ___new_symkey
   ___P((___SCMOBJ name, /* name must be a permanent object */
         unsigned int subtype),
        (name,
         subtype)
___SCMOBJ name;
unsigned int subtype;)
{
  ___SCMOBJ obj;
  ___SCMOBJ tbl;

  switch (subtype)
    {
    case ___sKEYWORD:
      obj = ___alloc_scmobj (___sKEYWORD, ___KEYWORD_SIZE<<___LWS, ___PERM);
      break;
    default: /* assume ___sSYMBOL */
      obj = ___alloc_scmobj (___sSYMBOL, ___SYMBOL_SIZE<<___LWS, ___PERM);
      break;
    }

  if (___FIXNUMP(obj))
    return obj;

  tbl = symkey_table (subtype);

  /* object layout is same for ___sSYMBOL and ___sKEYWORD */

  ___FIELD(obj,___SYMKEY_NAME) = name;
  ___FIELD(obj,___SYMKEY_HASH) = hash_scheme_string (name);

  if (subtype == ___sSYMBOL)
    ___FIELD(obj,___SYMBOL_GLOBAL) = 0;

  symkey_add (obj);

  return obj;
}


___HIDDEN ___SCMOBJ make_symkey
   ___P((___UTF_8STRING str,
         unsigned int subtype),
        (str,
         subtype)
___UTF_8STRING str;
unsigned int subtype;)
{
  ___SCMOBJ obj = find_symkey_from_UTF_8_string (str, subtype);

  if (___FIXNUMP(obj))
    return obj;

  if (obj == ___FAL)
    {
      ___SCMOBJ name;
      ___SCMOBJ err;

      if ((err = ___NONNULLUTF_8STRING_to_SCMOBJ (str, &name, 0))
          != ___FIX(___NO_ERR))
        return err;

      obj = ___new_symkey (name, subtype);
    }

  return obj;
}


___HIDDEN ___SCMOBJ make_global
   ___P((___UTF_8STRING str,
         int supply,
         ___glo_struct **glo),
        (str,
         supply,
         glo)
___UTF_8STRING str;
int supply;
___glo_struct **glo;)
{
  ___SCMOBJ sym;
  ___SCMOBJ g;
  ___glo_struct *p;

  sym = make_symkey (str, ___sSYMBOL);

  if (___FIXNUMP(sym))
    return sym;

  g = ___FIELD(sym,___SYMBOL_GLOBAL);

  if (g == ___FIX(0))
    {
      ___processor_state ___ps = ___PSTATE;
      ___SCMOBJ e;
      if ((e = ___alloc_global_var (&p)) != ___FIX(___NO_ERR))
        return e;
      p->val = supply?___UNB2:___UNB1;
      p->prm = ___FAL;
      p->next = 0;
      if (___ps->glo_list_head == 0)
        ___ps->glo_list_head = ___CAST(___SCMOBJ,p);
      else
        ___CAST(___glo_struct*,___ps->glo_list_tail)->next =
          ___CAST(___SCMOBJ,p);
      ___ps->glo_list_tail = ___CAST(___SCMOBJ,p);
      ___FIELD(sym,___SYMBOL_GLOBAL) = ___CAST(___SCMOBJ,p);
    }
  else
    {
      p = ___CAST(___glo_struct*,g);
      if (supply && p->val == ___UNB1)
        p->val = ___UNB2;
    }

  *glo = p;

  return ___FIX(___NO_ERR);
}


void ___for_each_symkey
   ___P((unsigned int subtype,
         void (*visit) (___SCMOBJ symkey, void *data),
         void *data),
        (subtype,
         visit,
         data)
unsigned int subtype;
void (*visit) ();
void *data;)
{
  ___SCMOBJ tbl = symkey_table (subtype);
  int i;

  for (i=___INT(___VECTORLENGTH(tbl))-1; i>0; i--)
    {
      ___SCMOBJ probe = ___FIELD(tbl, i);
      
      while (probe != ___NUL)
        {
          visit (probe, data);
          probe = ___FIELD(probe,___SYMKEY_NEXT);
        }
    }
}


/*---------------------------------------------------------------------------*/

/*
 * Alignment of objects.
 */

___HIDDEN ___SCMOBJ *align
   ___P((___SCMOBJ *from,
         long words,
         int need_64bit_alignment),
        (from,
         words,
         need_64bit_alignment)
___SCMOBJ *from;
long words;
int need_64bit_alignment;)
{
  ___SCMOBJ *to;

#if ___WS == 4
  if (need_64bit_alignment)
    to = ___ALIGNUP((from+1), 8) - 1;
  else
#endif
    to = ___ALIGNUP(from, ___WS);

  if (from != to)
    {
      /* move object up */
      int i;
      for (i=words-1; i>=0; i--)
        to[i] = from[i];
    }

  return to;
}


___HIDDEN ___SCMOBJ align_subtyped
   ___P((___SCMOBJ *ptr),
        (ptr)
___SCMOBJ *ptr;)
{
  ___SCMOBJ head = ptr[0];
  int subtype = ___HD_SUBTYPE(head);
  int words = ___HD_WORDS(head);
  return ___TAG(align (ptr, words+1, subtype>=___sS64VECTOR), ___tSUBTYPED);
}


/*---------------------------------------------------------------------------*/

/*
 * Routines to setup a module for execution.
 */

___HIDDEN ___mod_or_lnk linker_to_mod_or_lnk
   ___P((___mod_or_lnk (*linker) (___global_state_struct*)),
        (linker)
___mod_or_lnk (*linker) ();)
{
  ___mod_or_lnk mol = linker (&___gstate);
  if (mol->module.kind == ___LINKFILE_KIND)
    {
      void **p = mol->linkfile.linker_tbl;
      while (*p != 0)
        {
          *p = linker_to_mod_or_lnk
                 (*___CAST(___mod_or_lnk (**) ___P((___global_state_struct*),()),p));
          p++;
        }
    }
  return mol;
}


___HIDDEN ___SCMOBJ for_each_module
   ___P((___mod_or_lnk mol,
         ___SCMOBJ (*proc) (___module_struct*)),
        (mol,
         proc)
___mod_or_lnk mol;
___SCMOBJ (*proc) ();)
{
  if (mol->module.kind == ___LINKFILE_KIND)
    {
      void **p = mol->linkfile.linker_tbl;
      while (*p != 0)
        {
          ___SCMOBJ e = for_each_module (___CAST(___mod_or_lnk,*p++), proc);
          if (e != ___FIX(___NO_ERR))
            return e;
        }
      return ___FIX(___NO_ERR);
    }
  else
    return proc (___CAST(___module_struct*,mol));
}


___HIDDEN void fixref
   ___P((___SCMOBJ *p,
         ___SCMOBJ *sym_tbl,
         ___SCMOBJ *key_tbl,
         ___SCMOBJ *cns_tbl,
         ___SCMOBJ *sub_tbl),
        (p,
         sym_tbl,
         key_tbl,
         cns_tbl,
         sub_tbl)
___SCMOBJ *p;
___SCMOBJ *sym_tbl;
___SCMOBJ *key_tbl;
___SCMOBJ *cns_tbl;
___SCMOBJ *sub_tbl;)
{
  ___SCMOBJ v = *p;
  switch (___TYP(v))
    {
    case ___tPAIR:
      if (___INT(v)<0)
        *p = sym_tbl[-1-___INT(v)];
      else
        *p = ___TAG(___ALIGNUP(&cns_tbl[(___PAIR_SIZE+1)*___INT(v)],___WS),
                    ___tPAIR);
      break;

    case ___tSUBTYPED:
      if (___INT(v)<0)
        *p = key_tbl[-1-___INT(v)];
      else
        *p = sub_tbl[___INT(v)];
      break;
    }
}


___HIDDEN int module_count;
___HIDDEN ___SCMOBJ module_descr;


___HIDDEN ___SCMOBJ setup_module_phase1
   ___P((___module_struct *module),
        (module)
___module_struct *module;)
{
  int i, j;
  ___SCMOBJ *cns = 0;

  int flags                 = module->flags;
  ___FAKEWORD *glo_tbl      = module->glo_tbl;
  int sup_count             = module->sup_count;
  ___UTF_8STRING *glo_names = module->glo_names;
  ___SCMOBJ *sym_tbl        = ___CAST(___SCMOBJ*,module->sym_tbl);
  int sym_count             = module->sym_count;
  ___UTF_8STRING *sym_names = module->sym_names;
  ___SCMOBJ *key_tbl        = ___CAST(___SCMOBJ*,module->key_tbl);
  int key_count             = module->key_count;
  ___UTF_8STRING *key_names = module->key_names;
  ___SCMOBJ *lp             = module->lp;
  ___SCMOBJ *lbl_tbl        = ___CAST(___SCMOBJ*,module->lbl_tbl);
  int lbl_count             = module->lbl_count;
  ___SCMOBJ *ofd_tbl        = module->ofd_tbl;
  int ofd_length            = module->ofd_length;
  ___SCMOBJ *cns_tbl        = module->cns_tbl;
  int cns_count             = module->cns_count;
  ___SCMOBJ *sub_tbl        = ___CAST(___SCMOBJ*,module->sub_tbl);
  int sub_count             = module->sub_count;

  /* 
   * Check that the version of the compiler used to compile the module
   * is compatible with the compiler used to compile the runtime
   * system.
   */

  if (module->version / 10000 < ___VERSION / 10000)
    return ___FIX(___MODULE_VERSION_TOO_OLD_ERR);

  if (module->version / 10000 > ___VERSION / 10000)
    return ___FIX(___MODULE_VERSION_TOO_NEW_ERR);

  /* Align module's pair table */

  if (cns_tbl != 0)
    cns = align (cns_tbl, (___PAIR_SIZE+1)*cns_count, 0);

  /* Setup module's global variable table */

  if (glo_names != 0)
    {
      /* 
       * Create global variables in reverse order so that global
       * variables bound to c-lambdas are created last.
       */
      i = 0;
      while (glo_names[i] != 0)
        i++;
      while (i-- > 0)
        {
          ___glo_struct *glo = 0;
          ___SCMOBJ e = make_global (glo_names[i], i<sup_count, &glo);
          if (e != ___FIX(___NO_ERR))
            return e;
          glo_tbl[i] = ___CAST(___FAKEWORD,glo);
        }
    }

  /* Setup module's symbol table */

  if (sym_names != 0)
    {
      i = 0;
      while (sym_names[i] != 0)
        {
          ___SCMOBJ sym = make_symkey (sym_names[i], ___sSYMBOL);
          if (___FIXNUMP(sym))
            return sym;
          sym_tbl[i] = sym;
          i++;
        }
    }
  else
    for (i=sym_count-1; i>=0; i--)
      sym_tbl[i] = ___TAG(___ALIGNUP(sym_tbl[i], ___WS), ___tSUBTYPED);

  /* Setup module's keyword table */

  if (key_names != 0)
    {
      i = 0;
      while (key_names[i] != 0)
        {
          ___SCMOBJ key = make_symkey (key_names[i], ___sKEYWORD);
          if (___FIXNUMP(key))
            return key;
          key_tbl[i] = key;
          i++;
        }
    }
  else
    for (i=key_count-1; i>=0; i--)
      key_tbl[i] = ___TAG(___ALIGNUP(key_tbl[i], ___WS), ___tSUBTYPED);

  /* Setup module's subtyped object table */

  for (i=sub_count-1; i>=0; i--)
    sub_tbl[i] = align_subtyped (___CAST(___SCMOBJ*,sub_tbl[i]));

  /* Fix references in module's pair table */

  for (i=cns_count-1; i>=0; i--)
  {
    fixref (cns+i*(___PAIR_SIZE+1)+1, sym_tbl, key_tbl, cns_tbl, sub_tbl);
    fixref (cns+i*(___PAIR_SIZE+1)+2, sym_tbl, key_tbl, cns_tbl, sub_tbl);
  }

  /* Fix references in module's subtyped object table */

  for (j=sub_count-1; j>=0; j--)
    {
      ___SCMOBJ *p = ___UNTAG_AS(sub_tbl[j],___tSUBTYPED);
      ___SCMOBJ head = p[0];
      int subtype = ___HD_SUBTYPE(head);
      int words = ___HD_WORDS(head);
      switch (subtype)
        {
        case ___sSYMBOL:
        case ___sKEYWORD:
        case ___sVECTOR:
        case ___sSTRUCTURE:
        case ___sRATNUM:
        case ___sCPXNUM:
          for (i=1; i<=words; i++)
            fixref (p+i, sym_tbl, key_tbl, cns_tbl, sub_tbl);
        }
    }

  /* Align module's out-of-line frame descriptor table */

  if (ofd_tbl != 0)
    ofd_tbl = ___CAST(___SCMOBJ*,align (ofd_tbl, ofd_length, 0));

  /* Align module's label table */

  if (lbl_count > 0)
    {
      ___host current_host = 0;
      void **hlbl_ptr = 0;
      ___label_struct *new_lt;
      ___SCMOBJ *ofd_alloc;

      module_count++;

      new_lt = ___CAST(___label_struct*,align (lbl_tbl, lbl_count*___LS, 0));
      ofd_alloc = ofd_tbl;

      for (i=0; i<lbl_count; i++)
        {
          ___label_struct *lbl = &new_lt[i];
          ___SCMOBJ head = lbl->header;

          if (___TESTHEADERTAG(head,___sVECTOR))
            {
              ___UTF_8STRING name =
                ___CAST(___UTF_8STRING,
                        ___CAST_FAKEVOIDSTAR_TO_VOIDSTAR(lbl->host_label));

              if (name == 0)
                lbl->host_label = ___CAST(___FAKEVOIDSTAR,___FAL);
              else
                {
                  ___SCMOBJ sym =
                    find_symkey_from_UTF_8_string (name, ___sSYMBOL);

                  if (___FIXNUMP(sym))
                    return sym;

                  if (sym == ___FAL)
                    return ___FIX(___UNKNOWN_ERR);

                  lbl->host_label = ___CAST(___FAKEVOIDSTAR,sym);
                }

              fixref (&lbl->entry_or_descr, sym_tbl, key_tbl, cns_tbl, sub_tbl);

              if (hlbl_ptr != 0)
                hlbl_ptr++; /* skip INTRO label */
            }
          else
            {
              if (flags & 1) /* module uses gcc's computed goto? */
                {
                  if (___CAST_FAKEHOST_TO_HOST(lbl->host) != current_host)
                    {
                      current_host = ___CAST_FAKEHOST_TO_HOST(lbl->host);
                      hlbl_ptr = ___CAST(void**,current_host (0));
                      hlbl_ptr++; /* skip INTRO label */
                    }
                  lbl->host_label = ___CAST_VOIDSTAR_TO_FAKEVOIDSTAR(*hlbl_ptr++);
                }
              if (head == ___MAKE_HD((3<<___LWS),___sRETURN,___PERM))
                {
                  ___SCMOBJ descr;
                  descr = lbl->entry_or_descr;
                  if (___IFD_GCMAP(descr) == 0) /* out-of-line descriptor? */
                    {
                      int fs;
                      lbl->entry_or_descr = ___CAST(___SCMOBJ,ofd_alloc);
                      fs = ___OFD_FS(*ofd_alloc);
                      if (___IFD_KIND(descr) == ___RETI)
                        fs = ___RETI_CFS_TO_FS(fs);
                      ofd_alloc += 1 + ___CEILING_DIV(fs,___WORD_WIDTH);
                    }
                }
              else
                lbl->entry_or_descr = ___TAG(&lbl->header,___tSUBTYPED);
            }
        }
      *lp = ___TAG(new_lt,___tSUBTYPED);
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN char module_prefix[] = ___MODULE_PREFIX;

#define module_prefix_length (sizeof(module_prefix)-1)


___HIDDEN ___SCMOBJ setup_module_phase2
   ___P((___module_struct *module),
        (module)
___module_struct *module;)
{
  ___UTF_8STRING *glo_names = module->glo_names;

  if (glo_names != 0)
    {
      ___UTF_8STRING name = module->name;
      ___FAKEWORD *glo_tbl = module->glo_tbl;
      int glo_count = module->glo_count;
      int sup_count = module->sup_count;
      int i;
      for (i=sup_count; i<glo_count; i++)
        {
          /* 
           * If the global variable is undefined, add it to the list
           * of undefined variables in the module descriptor.
           */

          ___glo_struct *glo = ___CAST(___glo_struct*,glo_tbl[i]);

          if (glo->val == ___UNB1)
            {
              ___SCMOBJ err;
              ___SCMOBJ glo_name;
              ___SCMOBJ module_name;
              ___SCMOBJ pair1;
              ___SCMOBJ pair2;

              if ((err = ___NONNULLUTF_8STRING_to_SCMOBJ
                           (glo_names[i],
                            &glo_name,
                            0))
                  != ___FIX(___NO_ERR))
                return err;

              if ((err = ___NONNULLUTF_8STRING_to_SCMOBJ
                           (name+module_prefix_length,
                            &module_name,
                            0))
                  != ___FIX(___NO_ERR))
                {
                  ___release_scmobj (glo_name);
                  return ___FIX(err);
                }

              pair1 = ___make_pair (glo_name, module_name, ___STILL);

              ___release_scmobj (glo_name);
              ___release_scmobj (module_name);

              if (___FIXNUMP(pair1))
                return pair1;

              pair2 = ___make_pair (pair1, ___FIELD(module_descr,1), ___STILL);

              ___release_scmobj (pair1);

              if (___FIXNUMP(pair2))
                return pair2;

              ___FIELD(module_descr,1) = pair2;

              ___release_scmobj (pair2);
            }
        }
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ setup_module_phase3
   ___P((___module_struct *module),
        (module)
___module_struct *module;)
{
  if (module->lbl_count > 0)
    {
      ___FIELD(___FIELD(module_descr,0),module_count) =
        *module->lp+___LS*___WS;
      module_count++;
    }
  return module->init_proc ();
}


___HIDDEN ___UTF_8STRING module_script_line;


___HIDDEN ___SCMOBJ get_script_line_proc
   ___P((___module_struct *module),
        (module)
___module_struct *module;)
{
  if (module->script_line != 0)
    module_script_line = module->script_line;
  return ___FIX(___NO_ERR);
}


___HIDDEN ___UTF_8STRING get_script_line
   ___P((___mod_or_lnk mol),
        (mol)
___mod_or_lnk mol;)
{
  module_script_line = 0;

  if (for_each_module (mol, get_script_line_proc) == ___FIX(___NO_ERR))
    return module_script_line;

  return 0;
}


___HIDDEN ___SCMOBJ setup_modules
   ___P((___mod_or_lnk mol),
        (mol)
___mod_or_lnk mol;)
{
  ___SCMOBJ result;

  result = ___make_vector (3, ___NUL, ___STILL);

  if (!___FIXNUMP(result))
    {
      module_count = 0;
      module_descr = result;

      if ((result = for_each_module (mol, setup_module_phase1))
          == ___FIX(___NO_ERR))
        {
          if ((result = for_each_module (mol, setup_module_phase2))
              == ___FIX(___NO_ERR))
            {
              result = ___make_vector (module_count, ___FAL, ___STILL);

              if (!___FIXNUMP(result))
                {
                  ___FIELD(module_descr,0) = result;
                  ___release_scmobj (result);

                  module_count = 0;

                  if ((result = for_each_module (mol, setup_module_phase3))
                      == ___FIX(___NO_ERR))
                    {
                      ___SCMOBJ script_line;

                      if ((result = ___UTF_8STRING_to_SCMOBJ
                                      (get_script_line (mol),
                                       &script_line,
                                       0))
                          == ___FIX(___NO_ERR))
                        {
                          ___FIELD(module_descr,2) = script_line;
                          ___release_scmobj (script_line);
                          result = module_descr;
                        }
                    }
                }
            }
        }

      if (___FIXNUMP(result))
        ___release_scmobj (module_descr);
    }

  return result;
}


___SCMOBJ ___os_load_object_file
   ___P((___SCMOBJ path,
         ___SCMOBJ modname),
        (path,
         modname)
___SCMOBJ path;
___SCMOBJ modname;)
{
  ___SCMOBJ result;
  void *linker;
  ___mod_or_lnk mol;

  if ((result = ___dynamic_load (path, modname, &linker)) == ___FIX(___NO_ERR))
    {
      mol = linker_to_mod_or_lnk
              (___CAST(___mod_or_lnk (*) ___P((___global_state_struct*),()),
                       linker));

      if (mol->linkfile.version < 0) /* was it already setup? */
        result = ___FIX(___MODULE_ALREADY_LOADED_ERR);
      else
        {
          result = setup_modules (mol);
          mol->linkfile.version = -1; /* mark link file as 'setup' */
        }
    }

  ___release_scmobj (result);

  return result;
}


/*---------------------------------------------------------------------------*/

/*
 * Character operations.
 */


___EXP_FUNC(___BOOL,___iswalpha)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return iswalpha (x);

#else

  return (x >= 97 && x <= 122) || (x >= 65 && x <= 90);

#endif
}


___EXP_FUNC(___BOOL,___iswdigit)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return iswdigit (x);

#else

  return x>= 48 && x <= 57;

#endif
}


___EXP_FUNC(___BOOL,___iswspace)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return iswspace (x);

#else

  return (x >= 9 && x <= 13) || (x == 32);

#endif
}


___EXP_FUNC(___BOOL,___iswupper)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return iswupper (x);

#else

  return x >= 65 && x <= 90;

#endif
}


___EXP_FUNC(___BOOL,___iswlower)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return iswlower (x);

#else

  return x >= 97 && x <= 122;

#endif
}


___EXP_FUNC(___UCS_4,___towupper)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return towupper (x);

#else

  return (x >= 97 && x <= 122) ? x-32 : x;

#endif
}


___EXP_FUNC(___UCS_4,___towlower)
   ___P((___UCS_4 x),
        (x)
___UCS_4 x;)
{
#ifdef USE_wctype

  return towlower (x);

#else

  return (x >= 65 && x <= 90) ? x+32 : x;

#endif
}


#define STRING_COLLATE_BUF_LENGTH 1000


___EXP_FUNC(___SCMOBJ,___string_collate)
   ___P((___SCMOBJ str1,
         ___SCMOBJ str2),
        (str1,
         str2)
___SCMOBJ str1;
___SCMOBJ str2;)
{
  int len1 = ___INT(___STRINGLENGTH(str1));
  int len2 = ___INT(___STRINGLENGTH(str2));

#ifdef USE_wchar

  wchar_t buf[STRING_COLLATE_BUF_LENGTH];
  wchar_t *b1;
  wchar_t *b2;
  wchar_t *s1;
  wchar_t *s2;
  wchar_t *p;
  int i;
  int result;

  if (len1 + len2 + 2 > STRING_COLLATE_BUF_LENGTH)
    {
      b1 = ___CAST(wchar_t*,___alloc_mem (len1 + 1));

      if (b1 == 0)
        return ___FIX(___HEAP_OVERFLOW_ERR);

      p = b1;

      for (i=0; i<len1; i++)
        *p++ = ___INT(___STRINGREF(str1,___FIX(i)));

      *p = '\0';

      b2 = ___CAST(wchar_t*,___alloc_mem (len1 + 1));

      if (b2 == 0)
        {
          ___free_mem (b1);
          return ___FIX(___HEAP_OVERFLOW_ERR);
        }

      p = b2;

      for (i=0; i<len2; i++)
        *p++ = ___INT(___STRINGREF(str2,___FIX(i)));

      *p = '\0';
    }
  else
    {
      p = buf;

      b1 = p;

      for (i=0; i<len1; i++)
        *p++ = ___INT(___STRINGREF(str1,___FIX(i)));

      *p++ = '\0';

      b2 = p;

      for (i=0; i<len2; i++)
        *p++ = ___INT(___STRINGREF(str2,___FIX(i)));

      *p++ = '\0';
    }

  result = 0;
  s1 = b1;
  s2 = b2;

  while (len1 > 0 && len2 > 0 && result == 0)
    {
      int l1;
      int l2;

      result = wcscoll (s1, s2);

      l1 = wcslen (s1) + 1;
      l2 = wcslen (s2) + 1;

      s1 += l1;
      s2 += l2;

      len1 -= l1;
      len2 -= l2;
    }

  if (len1 + len2 + 2 > STRING_COLLATE_BUF_LENGTH)
    {
      ___free_mem (b1);
      ___free_mem (b2);
    }

  if (result < 0)
    return ___FIX(0);

  if (result > 0)
    return ___FIX(2);

  if (len1 < len2)
    return ___FIX(0);

  if (len1 > len2)
    return ___FIX(2);

  return ___FIX(1);

#else

  int n;
  int i;

  n = len1;
  if (len2 < n)
    n = len2;

  for (i=0; i<n; i++)
    {
      ___SCMOBJ c1 = ___STRINGREF(str1,___FIX(i));
      ___SCMOBJ c2 = ___STRINGREF(str2,___FIX(i));

      if (___CHARLTP(c1,c2))
        return ___FIX(0);

      if (___CHARGTP(c1,c2))
        return ___FIX(2);
    }

  if (len1 < len2)
    return ___FIX(0);

  if (len1 > len2)
    return ___FIX(2);

  return ___FIX(1);

#endif
}


___EXP_FUNC(___SCMOBJ,___string_collate_ci)
   ___P((___SCMOBJ str1,
         ___SCMOBJ str2),
        (str1,
         str2)
___SCMOBJ str1;
___SCMOBJ str2;)
{
  int len1 = ___INT(___STRINGLENGTH(str1));
  int len2 = ___INT(___STRINGLENGTH(str2));

#ifdef USE_wchar

  return ___FIX(0);

#else

  int n;
  int i;

  n = len1;
  if (len2 < n)
    n = len2;

  for (i=0; i<n; i++)
    {
      ___UCS_4 c1 = ___INT(___STRINGREF(str1,___FIX(i)));
      ___UCS_4 c2 = ___INT(___STRINGREF(str2,___FIX(i)));

      if (c1 >= 65 && c1 <= 90)
        c1 += 32;

      if (c2 >= 65 && c2 <= 90)
        c2 += 32;

      if (c1 < c2)
        return ___FIX(0);

      if (c1 > c2)
        return ___FIX(2);
    }

  if (len1 < len2)
    return ___FIX(0);

  if (len1 > len2)
    return ___FIX(2);

  return ___FIX(1);

#endif
}


/*---------------------------------------------------------------------------*/

/*
 * Numerical library routines.
 */

#ifdef ___BIG_ENDIAN
#define F64_HI8 0
#define F64_HI16 0
#define F64_HI32 0
#define F64_LO32 1
#else
#define F64_HI8 7
#define F64_HI16 3
#define F64_HI32 1
#define F64_LO32 0
#endif


___EXP_FUNC(double,___copysign)
   ___P((double x,
         double y),
        (x,
         y)
double x;
double y;)
{
  ___STORE_U8(&x,
              F64_HI8,
              (___FETCH_U8(&x,F64_HI8)&0x7f)|(___FETCH_U8(&y,F64_HI8)&0x80));

  return x;
}


___EXP_FUNC(___BOOL,___isfinite)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___CRAY_FP_FORMAT

  return 1;

#else

  return ((___FETCH_U16(&x,F64_HI16) ^ 0x7ff0) & 0x7fff) >= 0x10;

#endif
}


___EXP_FUNC(___BOOL,___isnan)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___CRAY_FP_FORMAT

  return 0;

#else

  ___UM32 tmp = (___FETCH_U32(&x,F64_HI32) ^ 0x7ff00000) & 0x7fffffff;

  return tmp < 0x100000 && (tmp | ___FETCH_U32(&x,F64_LO32)) != 0;

#endif
}


___EXP_FUNC(double,___trunc)
   ___P((double x),
        (x)
double x;)
{
  double f = floor (x);
  if (x < 0.0 && x != f)
    return f + 1.0;
  else
    return f;
}


___EXP_FUNC(double,___round)
   ___P((double x),
        (x)
double x;)
{
  double f, i, t;
  if (x < 0.0)
    {
      f = modf (-x, &i);
      if (f > 0.5 || (f == 0.5 && modf (i*0.5, &t) != 0.0))
        return -(i+1.0);
      else
        return -i;
    }
  else if (x == 0.0) /* so that round (-0.0) = -0.0 */
    return x;
  else
    {
      f = modf (x, &i);
      if (f > 0.5 || (f == 0.5 && modf (i*0.5, &t) != 0.0))
        return i+1.0;
      else
        return i;
    }
}


#ifndef ___GOOD_ATAN2

___EXP_FUNC(double,___atan2)
   ___P((double y,
         double x),
        (y,
         x)
double y;
double x;)
{
  if (___isnan (x))
    return x;
  else if (___isnan (y))
    return y;
  else if (y == 0.0)
    {
      if (___copysign (1.0, y) > 0.0)
        {
          if (___copysign (1.0, x) > 0.0)
            return 0.0;
          else
            return 3.141592653589793; /* from "header.scm" */
        }
      else
        {
          if (___copysign (1.0, x) > 0.0)
            return -0.0;
          else
            return -3.141592653589793; /* from "header.scm" */
        }
    }
  else if (___isfinite (x) || ___isfinite (y))
    return atan2 (y, x);
  else
    return ___copysign (x/y, x*y); /* returns NAN with appropriate sign */
}

#endif


#ifndef ___GOOD_POW

___EXP_FUNC(double,___pow)
   ___P((double x,
         double y),
        (x,
         y)
double x;
double y;)
{
  if (y == 0.0)
    return 1.0;
  else if (___isnan (x))
    return x;
  else if (___isnan (y))
    return y;
  else
    return pow (x, y);
}

#endif


/*---------------------------------------------------------------------------*/

/* 
 * Initialization of symbol and keyword tables, and global variables.
 */

___HIDDEN void init_symkey_glo1
   ___P((___mod_or_lnk mol),
        (mol)
___mod_or_lnk mol;)
{
  if (mol->module.kind == ___LINKFILE_KIND)
    {
      void **p1 = mol->linkfile.linker_tbl;
      ___FAKEWORD *p2 = mol->linkfile.sym_list;

      while (*p1 != 0)
        init_symkey_glo1 (___CAST(___mod_or_lnk,*p1++));

      while (p2 != 0)
        {
          ___SCMOBJ *sym_ptr;
          ___glo_struct *glo;

          sym_ptr = ___CAST(___SCMOBJ*,p2);

          p2 = ___CAST(___FAKEWORD*,sym_ptr[0]);
          glo = ___CAST(___glo_struct*,sym_ptr[1+___SYMBOL_GLOBAL]);

          sym_ptr[1+___SYMKEY_HASH] = glo->prm; /* move symbol's hash value */
        }
    }
}


___HIDDEN void init_symkey_glo2
   ___P((___mod_or_lnk mol),
        (mol)
___mod_or_lnk mol;)
{
  if (mol->module.kind == ___LINKFILE_KIND)
    {
      void **p1 = mol->linkfile.linker_tbl;
      ___FAKEWORD *p2 = mol->linkfile.sym_list;
      ___FAKEWORD *p3 = mol->linkfile.key_list;
      ___processor_state ___ps = ___PSTATE;

      while (*p1 != 0)
        init_symkey_glo2 (___CAST(___mod_or_lnk,*p1++));

      while (p2 != 0)
        {
          ___SCMOBJ sym;
          ___SCMOBJ str;
          ___SCMOBJ *sym_ptr;
          ___glo_struct *glo;

          sym_ptr = ___CAST(___SCMOBJ*,p2);

          p2 = ___CAST(___FAKEWORD*,sym_ptr[0]);
          str = align_subtyped (___CAST(___SCMOBJ*,sym_ptr[1+___SYMKEY_NAME]));
          glo = ___CAST(___glo_struct*,sym_ptr[1+___SYMBOL_GLOBAL]);

          glo->next = 0;
          if (___ps->glo_list_head == 0)
            ___ps->glo_list_head = ___CAST(___SCMOBJ,glo);
          else
            ___CAST(___glo_struct*,___ps->glo_list_tail)->next =
              ___CAST(___SCMOBJ,glo);
          ___ps->glo_list_tail = ___CAST(___SCMOBJ,glo);

          *sym_ptr = ___MAKE_HD((___SYMBOL_SIZE<<___LWS),___sSYMBOL,___PERM);

          sym = align_subtyped (sym_ptr);

          ___FIELD(sym,___SYMKEY_NAME) = str;
          ___FIELD(sym,___SYMBOL_GLOBAL) = ___CAST(___SCMOBJ,glo);

          symkey_add (sym);
        }

      while (p3 != 0)
        {
          ___SCMOBJ key, str;
          ___SCMOBJ *key_ptr;

          key_ptr = ___CAST(___SCMOBJ*,p3);

          p3 = ___CAST(___FAKEWORD*,key_ptr[0]);
          str = align_subtyped (___CAST(___SCMOBJ*,key_ptr[1+___SYMKEY_NAME]));

          *key_ptr = ___MAKE_HD((___KEYWORD_SIZE<<___LWS),___sKEYWORD,___PERM);

          key = align_subtyped (key_ptr);

          ___FIELD(key,___SYMKEY_NAME) = str;
          ___FIELD(key,___SYMKEY_HASH) = hash_scheme_string (str);

          symkey_add (key);
        }
    }
}


/*---------------------------------------------------------------------------*/

/*
 * C to Scheme call handler.
 */

___EXP_FUNC(___SCMOBJ,___call)
   ___P((int nargs,
         ___SCMOBJ proc,
         ___SCMOBJ stack_marker),
        (nargs,
         proc,
         stack_marker)
int nargs;
___SCMOBJ proc;
___SCMOBJ stack_marker;)
{
  ___SCMOBJ ___err;
  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ *___fp = ___ps->fp;

  /* 
   * The C function which has called ___call() has put the arguments
   * of the Scheme procedure on the stack above ___fp as shown in the
   * 'on entry' picture below.  The free space under arg1 is for a
   * continuation frame that performs the return of control from
   * Scheme to C.  This frame is set up by ___call() before the
   * destination Scheme procedure is invoked.  The frame is accessed
   * by the return_to_c handler (in "_kernel.scm") which is invoked
   * when the called procedure returns.  The frame contains a heap
   * allocated 'stack marker', allocated by the caller, which
   * indicates the destination Scheme procedure and if it is still possible
   * to return to the caller (i.e. its activation frame is still on
   * the C stack).  The caller will store #f in the stack marker so
   * that any subsequent attempt to return to that invocation of the
   * caller will be detected and trigger an error.
   *
   *
   *            ON ENTRY:          JUST BEFORE JUMPING TO THE SCHEME PROCEDURE:
   *
   *              STACK                         STACK             HEAP
   *          |     ^      |                |     ^      |
   *          |     |      |                |     |      |
   *          |            |                |            |
   *          |            |                |            |
   *          |   arg N    |                |   arg N    |
   *          |    ...     |       ___fp -->|    ...     |
   *          |   arg 1    |                |   arg 1    |
   *          +------------+                +------------+
   *          |  RESERVED  |                |  RESERVED  |    stack marker
   *          | <PADDING>  |                | <PADDING>  |   +------------+
   *          | undefined  |                |     ---------->|    HEAD    |
   *          | undefined  |                | return adr |   | procedure  |
   *          +------------+                +------------+   +------------+
   * ___fp -->|  RESERVED  |                |  RESERVED  |
   *          |    ...     |                |    ...     |
   *          +------------+                +------------+
   *          |            |                |            |
   */

  ___LD_ARG_REGS /* declare and load GVM argument registers from ___ps */

  ___fp[-1] = ___PSR0;      /* create a frame with the same format as the */
  ___fp[-2] = stack_marker; /* one created for the return to C handler    */
                            /* in "_kernel.scm"                           */

  ___fp -= ___FRAME_SPACE(2) + nargs; /* move ___fp to point to last arg */

  ___POP_ARGS_IN_REGS(nargs) /* load arguments into appropriate registers */

  ___ST_ARG_REGS /* write back GVM argument registers to ___ps */

  ___PSR0 = ___GSTATE->handler_return_to_c;

  ___ps->fp = ___fp;
  ___ps->na = nargs;
  ___ps->pc = ___CAST(___label_struct*,proc-___tSUBTYPED)->entry_or_descr;
  ___PSSELF = proc;

  ___BEGIN_TRY

  ___SCMOBJ ___pc = ___ps->pc;

  for (;;)
    {
#define CALL_STEP \
___pc = ___CAST_FAKEHOST_TO_HOST(___CAST(___label_struct*,___pc-___tSUBTYPED) \
                                 ->host)(___ps)
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
    }

  ___END_TRY

  if (___err != ___FIX(___UNWIND_C_STACK) ||
      stack_marker != ___ps->fp[___FRAME_SPACE(2)-2]) /*need more unwinding?*/
    ___THROW(___err);

  ___ps->fp += ___FRAME_SPACE(2);
  ___PSR0 = ___ps->fp[-1];

  return ___FIX(___NO_ERR);
}


___EXP_FUNC(void,___propagate_error)
   ___P((___SCMOBJ err),
        (err)
___SCMOBJ err;)
{
  if (err != ___FIX(___NO_ERR))
    {
      ___processor_state ___ps = ___PSTATE;
      ___THROW (err);
    }
}


#ifdef ___DEBUG

___SCMOBJ find_global_var_bound_to
   ___P((___SCMOBJ val),
        (val)
___SCMOBJ val;)
{
  ___SCMOBJ sym = ___NUL;
  int i;

  for (i = ___INT(___VECTORLENGTH(___GSTATE->symbol_table)) - 1; i>0; i--)
    {
      sym = ___FIELD(___GSTATE->symbol_table,i);

      while (sym != ___NUL)
       {
          ___SCMOBJ g = ___FIELD(sym,___SYMBOL_GLOBAL);

          if (g != ___FIX(0))
            {
              ___glo_struct *p = ___CAST(___glo_struct*,g);

              if (p->prm == val || p->val == val)
                {
                  i = 0;
                  break;
                }
            }

          sym = ___FIELD(sym,___SYMKEY_NEXT);
        }
    }

  return sym;
}

#endif


#ifdef ___DEBUG_HOST_CHANGES

___EXP_FUNC(void,___register_host_entry)
   ___P((___WORD start,
         char *module_name),
        (start,
         module_name)
___WORD start;
char *module_name;)
{
#ifdef ___DEBUG

  ___processor_state ___ps = ___PSTATE;
  ___SCMOBJ sym;

  ___printf ("*** Entering ");

  if ((sym = find_global_var_bound_to (___ps->pc)) != ___NUL ||
      (sym = find_global_var_bound_to (start)) != ___NUL)
    {
      ___SCMOBJ name = ___FIELD(sym,___SYMKEY_NAME);
      int i;
      for (i=0; i<___INT(___STRINGLENGTH(name)); i++)
        ___printf ("%c", ___INT(___STRINGREF(name,___FIX(i))));
    }
  else
    {
      ___printf ("|%s| host=0x%08x", module_name, start);
    }

  if (start == ___ps->pc)
    ___printf ("\n");
  else
    ___printf (" (subprocedure %d)\n",
               ___CAST(___label_struct*,___ps->pc) -
               ___CAST(___label_struct*,start));

#endif
}

#endif


/*---------------------------------------------------------------------------*/

/*
 * Setup program and execute it.
 */

___HIDDEN int setup_state = 0; /* 0=pre-setup, 1=post-setup, 2=post-cleanup */


___EXP_FUNC(void,___cleanup) ___PVOID
{
  /*
   * Only do cleanup once after successful setup.
   */

  if (setup_state != 1)
    return;

  setup_state = 2;

  ___cleanup_mem ();
  ___cleanup_os ();
}


___EXP_FUNC(void,___cleanup_and_exit_process)
   ___P((int status),
        (status)
int status;)
{
  ___cleanup ();
  ___exit_process (status);
}


___EXP_FUNC(void,___setup_params_reset)
   ___P((___setup_params_struct *setup_params),
        (setup_params)
___setup_params_struct *setup_params;)
{
  setup_params->version           = 0;
  setup_params->argv              = reset_argv;
  setup_params->min_heap          = 0;
  setup_params->max_heap          = 0;
  setup_params->live_percent      = 0;
  setup_params->gc_hook           = 0;
  setup_params->display_error     = 0;
  setup_params->fatal_error       = 0;
  setup_params->standard_level    = 0;
  setup_params->debug_settings    = 0;
  setup_params->file_settings     = 0;
  setup_params->terminal_settings = 0;
  setup_params->stdio_settings    = 0;
  setup_params->gambcdir          = 0;
  setup_params->linker            = 0;
  setup_params->dummy8            = 0;
  setup_params->dummy7            = 0;
  setup_params->dummy6            = 0;
  setup_params->dummy5            = 0;
  setup_params->dummy4            = 0;
  setup_params->dummy3            = 0;
  setup_params->dummy2            = 0;
  setup_params->dummy1            = 0;
}


___EXP_FUNC(unsigned long,___get_min_heap) ___PVOID
{
  return ___setup_params.min_heap;
}


___EXP_FUNC(void,___set_min_heap)
   ___P((unsigned long bytes),
        (bytes)
unsigned long bytes;)
{
  ___setup_params.min_heap = bytes;
}


___EXP_FUNC(unsigned long,___get_max_heap) ___PVOID
{
  return ___setup_params.max_heap;
}


___EXP_FUNC(void,___set_max_heap)
   ___P((unsigned long bytes),
        (bytes)
unsigned long bytes;)
{
  ___setup_params.max_heap = bytes;
}


___EXP_FUNC(int,___get_live_percent) ___PVOID
{
  return ___setup_params.live_percent;
}


___EXP_FUNC(void,___set_live_percent)
   ___P((int percent),
        (percent)
int percent;)
{
  ___setup_params.live_percent = percent;
}


___EXP_FUNC(int,___get_standard_level) ___PVOID
{
  return ___setup_params.standard_level;
}


___EXP_FUNC(void,___set_standard_level)
   ___P((int level),
        (level)
int level;)
{
  ___setup_params.standard_level = level;
}


___EXP_FUNC(int,___set_debug_settings)
   ___P((int mask,
         int new_settings),
        (mask,
         new_settings)
int mask;
int new_settings;)
{
  int old_settings = ___setup_params.debug_settings;

  ___setup_params.debug_settings =
    (old_settings & ~mask) | (new_settings & mask);

  return old_settings;
}


___EXP_FUNC(___program_startup_info_struct*,___get_program_startup_info)
   ___PVOID
{
  return &___program_startup_info;
}


___EXP_FUNC(___SCMOBJ,___setup)
   ___P((___setup_params_struct *setup_params),
        (setup_params)
___setup_params_struct *setup_params;)
{
  ___SCMOBJ ___err;
  ___processor_state ___ps;
  ___mod_or_lnk mol;
  ___SCMOBJ ___start;
  ___SCMOBJ marker;
  int i;

  /*
   * Check for valid setup_params structure.
   */

  if (setup_params == 0 ||
      setup_params->version != ___VERSION)
    return ___FIX(___UNKNOWN_ERR);

  /*
   * Only do setup once.
   */

  if (setup_state != 0)
    return ___FIX(___UNKNOWN_ERR);

  setup_state = 2; /* disallow cleanup, in case setup fails */

  /*
   * Remember setup parameters.
   */

  ___setup_params = *setup_params;

  /* 
   * Setup the operating system module.
   */

  if ((___err = ___setup_os ()) != ___FIX(___NO_ERR))
    return ___err;

  /* 
   * Setup stack and heap.
   */

  if ((___err = ___setup_mem ()) != ___FIX(___NO_ERR))
    {
      ___cleanup_os ();
      return ___err;
    }

  setup_state = 1; /* allow cleanup */

  /* 
   * Setup global state to avoid problems on systems that don't
   * support the dynamic loading of files that import functions.
   */

  ___gstate.dummy8 = 0;
  ___gstate.dummy7 = 0;
  ___gstate.dummy6 = 0;
  ___gstate.dummy5 = 0;
  ___gstate.dummy4 = 0;
  ___gstate.dummy3 = 0;
  ___gstate.dummy2 = 0;
  ___gstate.dummy1 = 0;

#ifndef ___CAN_IMPORT_CLIB_DYNAMICALLY

  ___gstate.fabs  = fabs;
  ___gstate.floor = floor;
  ___gstate.ceil  = ceil;
  ___gstate.exp   = exp;
  ___gstate.log   = log;
  ___gstate.sin   = sin;
  ___gstate.cos   = cos;
  ___gstate.tan   = tan;
  ___gstate.asin  = asin;
  ___gstate.acos  = acos;
  ___gstate.atan  = atan;
#ifdef ___GOOD_ATAN2
  ___gstate.atan2 = atan2;
#endif
#ifdef ___GOOD_POW
  ___gstate.pow = pow;
#endif
  ___gstate.sqrt  = sqrt;

#endif

#ifdef ___USE_SETJMP
#ifndef ___CAN_IMPORT_SETJMP_DYNAMICALLY

  ___gstate.setjmp = setjmp;

#endif
#endif

#ifndef ___CAN_IMPORT_DYNAMICALLY

  ___gstate.___iswalpha
    = ___iswalpha;

  ___gstate.___iswdigit
    = ___iswdigit;

  ___gstate.___iswspace
    = ___iswspace;

  ___gstate.___iswupper
    = ___iswupper;

  ___gstate.___iswlower
    = ___iswlower;

  ___gstate.___towupper
    = ___towupper;

  ___gstate.___towlower
    = ___towlower;

  ___gstate.___string_collate
    = ___string_collate;

  ___gstate.___string_collate_ci
    = ___string_collate_ci;

  ___gstate.___copysign
    = ___copysign;

  ___gstate.___isfinite
    = ___isfinite;

  ___gstate.___isnan
    = ___isnan;

  ___gstate.___trunc
    = ___trunc;

  ___gstate.___round
    = ___round;

#ifndef ___GOOD_ATAN2
  ___gstate.___atan2
    = ___atan2;
#endif

#ifndef ___GOOD_POW
  ___gstate.___pow
    = ___pow;
#endif

  ___gstate.___S64_from_SM32_fn
    = ___S64_from_SM32_fn;

  ___gstate.___S64_from_SM32_UM32_fn
    = ___S64_from_SM32_UM32_fn;

  ___gstate.___S64_from_LONGLONG_fn
    = ___S64_from_LONGLONG_fn;

  ___gstate.___S64_to_LONGLONG_fn
    = ___S64_to_LONGLONG_fn;

  ___gstate.___S64_fits_in_width_fn
    = ___S64_fits_in_width_fn;

  ___gstate.___U64_from_UM32_fn
    = ___U64_from_UM32_fn;

  ___gstate.___U64_from_UM32_UM32_fn
    = ___U64_from_UM32_UM32_fn;

  ___gstate.___U64_from_ULONGLONG_fn
    = ___U64_from_ULONGLONG_fn;

  ___gstate.___U64_to_ULONGLONG_fn
    = ___U64_to_ULONGLONG_fn;

  ___gstate.___U64_fits_in_width_fn
    = ___U64_fits_in_width_fn;

  ___gstate.___SCMOBJ_to_S8
    = ___SCMOBJ_to_S8;

  ___gstate.___SCMOBJ_to_U8
    = ___SCMOBJ_to_U8;

  ___gstate.___SCMOBJ_to_S16
    = ___SCMOBJ_to_S16;

  ___gstate.___SCMOBJ_to_U16
    = ___SCMOBJ_to_U16;

  ___gstate.___SCMOBJ_to_S32
    = ___SCMOBJ_to_S32;

  ___gstate.___SCMOBJ_to_U32
    = ___SCMOBJ_to_U32;

  ___gstate.___SCMOBJ_to_S64
    = ___SCMOBJ_to_S64;

  ___gstate.___SCMOBJ_to_U64
    = ___SCMOBJ_to_U64;

  ___gstate.___SCMOBJ_to_F32
    = ___SCMOBJ_to_F32;

  ___gstate.___SCMOBJ_to_F64
    = ___SCMOBJ_to_F64;

  ___gstate.___SCMOBJ_to_CHAR
    = ___SCMOBJ_to_CHAR;

  ___gstate.___SCMOBJ_to_SCHAR
    = ___SCMOBJ_to_SCHAR;

  ___gstate.___SCMOBJ_to_UCHAR
    = ___SCMOBJ_to_UCHAR;

  ___gstate.___SCMOBJ_to_ISO_8859_1
    = ___SCMOBJ_to_ISO_8859_1;

  ___gstate.___SCMOBJ_to_UCS_2
    = ___SCMOBJ_to_UCS_2;

  ___gstate.___SCMOBJ_to_UCS_4
    = ___SCMOBJ_to_UCS_4;

  ___gstate.___SCMOBJ_to_WCHAR
    = ___SCMOBJ_to_WCHAR;

  ___gstate.___SCMOBJ_to_SHORT
    = ___SCMOBJ_to_SHORT;

  ___gstate.___SCMOBJ_to_USHORT
    = ___SCMOBJ_to_USHORT;

  ___gstate.___SCMOBJ_to_INT
    = ___SCMOBJ_to_INT;

  ___gstate.___SCMOBJ_to_UINT
    = ___SCMOBJ_to_UINT;

  ___gstate.___SCMOBJ_to_LONG
    = ___SCMOBJ_to_LONG;

  ___gstate.___SCMOBJ_to_ULONG
    = ___SCMOBJ_to_ULONG;

  ___gstate.___SCMOBJ_to_LONGLONG
    = ___SCMOBJ_to_LONGLONG;

  ___gstate.___SCMOBJ_to_ULONGLONG
    = ___SCMOBJ_to_ULONGLONG;

  ___gstate.___SCMOBJ_to_FLOAT
    = ___SCMOBJ_to_FLOAT;

  ___gstate.___SCMOBJ_to_DOUBLE
    = ___SCMOBJ_to_DOUBLE;

  ___gstate.___SCMOBJ_to_STRUCT
    = ___SCMOBJ_to_STRUCT;

  ___gstate.___SCMOBJ_to_UNION
    = ___SCMOBJ_to_UNION;

  ___gstate.___SCMOBJ_to_TYPE
    = ___SCMOBJ_to_TYPE;

  ___gstate.___SCMOBJ_to_POINTER
    = ___SCMOBJ_to_POINTER;

  ___gstate.___SCMOBJ_to_NONNULLPOINTER
    = ___SCMOBJ_to_NONNULLPOINTER;

  ___gstate.___SCMOBJ_to_FUNCTION
    = ___SCMOBJ_to_FUNCTION;

  ___gstate.___SCMOBJ_to_NONNULLFUNCTION
    = ___SCMOBJ_to_NONNULLFUNCTION;

  ___gstate.___SCMOBJ_to_BOOL
    = ___SCMOBJ_to_BOOL;

  ___gstate.___SCMOBJ_to_STRING
    = ___SCMOBJ_to_STRING;

  ___gstate.___SCMOBJ_to_NONNULLSTRING
    = ___SCMOBJ_to_NONNULLSTRING;

  ___gstate.___SCMOBJ_to_NONNULLSTRINGLIST
    = ___SCMOBJ_to_NONNULLSTRINGLIST;

  ___gstate.___SCMOBJ_to_CHARSTRING
    = ___SCMOBJ_to_CHARSTRING;

  ___gstate.___SCMOBJ_to_NONNULLCHARSTRING
    = ___SCMOBJ_to_NONNULLCHARSTRING;

  ___gstate.___SCMOBJ_to_NONNULLCHARSTRINGLIST
    = ___SCMOBJ_to_NONNULLCHARSTRINGLIST;

  ___gstate.___SCMOBJ_to_ISO_8859_1STRING
    = ___SCMOBJ_to_ISO_8859_1STRING;

  ___gstate.___SCMOBJ_to_NONNULLISO_8859_1STRING
    = ___SCMOBJ_to_NONNULLISO_8859_1STRING;

  ___gstate.___SCMOBJ_to_NONNULLISO_8859_1STRINGLIST
    = ___SCMOBJ_to_NONNULLISO_8859_1STRINGLIST;

  ___gstate.___SCMOBJ_to_UTF_8STRING
    = ___SCMOBJ_to_UTF_8STRING;

  ___gstate.___SCMOBJ_to_NONNULLUTF_8STRING
    = ___SCMOBJ_to_NONNULLUTF_8STRING;

  ___gstate.___SCMOBJ_to_NONNULLUTF_8STRINGLIST
    = ___SCMOBJ_to_NONNULLUTF_8STRINGLIST;

  ___gstate.___SCMOBJ_to_UTF_16STRING
    = ___SCMOBJ_to_UTF_16STRING;

  ___gstate.___SCMOBJ_to_NONNULLUTF_16STRING
    = ___SCMOBJ_to_NONNULLUTF_16STRING;

  ___gstate.___SCMOBJ_to_NONNULLUTF_16STRINGLIST
    = ___SCMOBJ_to_NONNULLUTF_16STRINGLIST;

  ___gstate.___SCMOBJ_to_UCS_2STRING
    = ___SCMOBJ_to_UCS_2STRING;

  ___gstate.___SCMOBJ_to_NONNULLUCS_2STRING
    = ___SCMOBJ_to_NONNULLUCS_2STRING;

  ___gstate.___SCMOBJ_to_NONNULLUCS_2STRINGLIST
    = ___SCMOBJ_to_NONNULLUCS_2STRINGLIST;

  ___gstate.___SCMOBJ_to_UCS_4STRING
    = ___SCMOBJ_to_UCS_4STRING;

  ___gstate.___SCMOBJ_to_NONNULLUCS_4STRING
    = ___SCMOBJ_to_NONNULLUCS_4STRING;

  ___gstate.___SCMOBJ_to_NONNULLUCS_4STRINGLIST
    = ___SCMOBJ_to_NONNULLUCS_4STRINGLIST;

  ___gstate.___SCMOBJ_to_WCHARSTRING
    = ___SCMOBJ_to_WCHARSTRING;

  ___gstate.___SCMOBJ_to_NONNULLWCHARSTRING
    = ___SCMOBJ_to_NONNULLWCHARSTRING;

  ___gstate.___SCMOBJ_to_NONNULLWCHARSTRINGLIST
    = ___SCMOBJ_to_NONNULLWCHARSTRINGLIST;

  ___gstate.___SCMOBJ_to_VARIANT
    = ___SCMOBJ_to_VARIANT;

  ___gstate.___release_foreign
    = ___release_foreign;

  ___gstate.___release_pointer
    = ___release_pointer;

  ___gstate.___release_function
    = ___release_function;

  ___gstate.___addref_function
    = ___addref_function;

  ___gstate.___release_string
    = ___release_string;

  ___gstate.___addref_string
    = ___addref_string;

  ___gstate.___release_string_list
    = ___release_string_list;

  ___gstate.___addref_string_list
    = ___addref_string_list;

  ___gstate.___release_variant
    = ___release_variant;

  ___gstate.___addref_variant
    = ___addref_variant;

  ___gstate.___S8_to_SCMOBJ
    = ___S8_to_SCMOBJ;

  ___gstate.___U8_to_SCMOBJ
    = ___U8_to_SCMOBJ;

  ___gstate.___S16_to_SCMOBJ
    = ___S16_to_SCMOBJ;

  ___gstate.___U16_to_SCMOBJ
    = ___U16_to_SCMOBJ;

  ___gstate.___S32_to_SCMOBJ
    = ___S32_to_SCMOBJ;

  ___gstate.___U32_to_SCMOBJ
    = ___U32_to_SCMOBJ;

  ___gstate.___S64_to_SCMOBJ
    = ___S64_to_SCMOBJ;

  ___gstate.___U64_to_SCMOBJ
    = ___U64_to_SCMOBJ;

  ___gstate.___F32_to_SCMOBJ
    = ___F32_to_SCMOBJ;

  ___gstate.___F64_to_SCMOBJ
    = ___F64_to_SCMOBJ;

  ___gstate.___CHAR_to_SCMOBJ
    = ___CHAR_to_SCMOBJ;

  ___gstate.___SCHAR_to_SCMOBJ
    = ___SCHAR_to_SCMOBJ;

  ___gstate.___UCHAR_to_SCMOBJ
    = ___UCHAR_to_SCMOBJ;

  ___gstate.___ISO_8859_1_to_SCMOBJ
    = ___ISO_8859_1_to_SCMOBJ;

  ___gstate.___UCS_2_to_SCMOBJ
    = ___UCS_2_to_SCMOBJ;

  ___gstate.___UCS_4_to_SCMOBJ
    = ___UCS_4_to_SCMOBJ;

  ___gstate.___WCHAR_to_SCMOBJ
    = ___WCHAR_to_SCMOBJ;

  ___gstate.___SHORT_to_SCMOBJ
    = ___SHORT_to_SCMOBJ;

  ___gstate.___USHORT_to_SCMOBJ
    = ___USHORT_to_SCMOBJ;

  ___gstate.___INT_to_SCMOBJ
    = ___INT_to_SCMOBJ;

  ___gstate.___UINT_to_SCMOBJ
    = ___UINT_to_SCMOBJ;

  ___gstate.___LONG_to_SCMOBJ
    = ___LONG_to_SCMOBJ;

  ___gstate.___ULONG_to_SCMOBJ
    = ___ULONG_to_SCMOBJ;

  ___gstate.___LONGLONG_to_SCMOBJ
    = ___LONGLONG_to_SCMOBJ;

  ___gstate.___ULONGLONG_to_SCMOBJ
    = ___ULONGLONG_to_SCMOBJ;

  ___gstate.___FLOAT_to_SCMOBJ
    = ___FLOAT_to_SCMOBJ;

  ___gstate.___DOUBLE_to_SCMOBJ
    = ___DOUBLE_to_SCMOBJ;

  ___gstate.___STRUCT_to_SCMOBJ
    = ___STRUCT_to_SCMOBJ;

  ___gstate.___UNION_to_SCMOBJ
    = ___UNION_to_SCMOBJ;

  ___gstate.___TYPE_to_SCMOBJ
    = ___TYPE_to_SCMOBJ;

  ___gstate.___POINTER_to_SCMOBJ
    = ___POINTER_to_SCMOBJ;

  ___gstate.___NONNULLPOINTER_to_SCMOBJ
    = ___NONNULLPOINTER_to_SCMOBJ;

  ___gstate.___FUNCTION_to_SCMOBJ
    = ___FUNCTION_to_SCMOBJ;

  ___gstate.___NONNULLFUNCTION_to_SCMOBJ
    = ___NONNULLFUNCTION_to_SCMOBJ;

  ___gstate.___BOOL_to_SCMOBJ
    = ___BOOL_to_SCMOBJ;

  ___gstate.___STRING_to_SCMOBJ
    = ___STRING_to_SCMOBJ;

  ___gstate.___NONNULLSTRING_to_SCMOBJ
    = ___NONNULLSTRING_to_SCMOBJ;

  ___gstate.___NONNULLSTRINGLIST_to_SCMOBJ
    = ___NONNULLSTRINGLIST_to_SCMOBJ;

  ___gstate.___CHARSTRING_to_SCMOBJ
    = ___CHARSTRING_to_SCMOBJ;

  ___gstate.___NONNULLCHARSTRING_to_SCMOBJ
    = ___NONNULLCHARSTRING_to_SCMOBJ;

  ___gstate.___NONNULLCHARSTRINGLIST_to_SCMOBJ
    = ___NONNULLCHARSTRINGLIST_to_SCMOBJ;

  ___gstate.___ISO_8859_1STRING_to_SCMOBJ
    = ___ISO_8859_1STRING_to_SCMOBJ;

  ___gstate.___NONNULLISO_8859_1STRING_to_SCMOBJ
    = ___NONNULLISO_8859_1STRING_to_SCMOBJ;

  ___gstate.___NONNULLISO_8859_1STRINGLIST_to_SCMOBJ
    = ___NONNULLISO_8859_1STRINGLIST_to_SCMOBJ;

  ___gstate.___UTF_8STRING_to_SCMOBJ
    = ___UTF_8STRING_to_SCMOBJ;

  ___gstate.___NONNULLUTF_8STRING_to_SCMOBJ
    = ___NONNULLUTF_8STRING_to_SCMOBJ;

  ___gstate.___NONNULLUTF_8STRINGLIST_to_SCMOBJ
    = ___NONNULLUTF_8STRINGLIST_to_SCMOBJ;

  ___gstate.___UTF_16STRING_to_SCMOBJ
    = ___UTF_16STRING_to_SCMOBJ;

  ___gstate.___NONNULLUTF_16STRING_to_SCMOBJ
    = ___NONNULLUTF_16STRING_to_SCMOBJ;

  ___gstate.___NONNULLUTF_16STRINGLIST_to_SCMOBJ
    = ___NONNULLUTF_16STRINGLIST_to_SCMOBJ;

  ___gstate.___UCS_2STRING_to_SCMOBJ
    = ___UCS_2STRING_to_SCMOBJ;

  ___gstate.___NONNULLUCS_2STRING_to_SCMOBJ
    = ___NONNULLUCS_2STRING_to_SCMOBJ;

  ___gstate.___NONNULLUCS_2STRINGLIST_to_SCMOBJ
    = ___NONNULLUCS_2STRINGLIST_to_SCMOBJ;

  ___gstate.___UCS_4STRING_to_SCMOBJ
    = ___UCS_4STRING_to_SCMOBJ;

  ___gstate.___NONNULLUCS_4STRING_to_SCMOBJ
    = ___NONNULLUCS_4STRING_to_SCMOBJ;

  ___gstate.___NONNULLUCS_4STRINGLIST_to_SCMOBJ
    = ___NONNULLUCS_4STRINGLIST_to_SCMOBJ;

  ___gstate.___WCHARSTRING_to_SCMOBJ
    = ___WCHARSTRING_to_SCMOBJ;

  ___gstate.___NONNULLWCHARSTRING_to_SCMOBJ
    = ___NONNULLWCHARSTRING_to_SCMOBJ;

  ___gstate.___NONNULLWCHARSTRINGLIST_to_SCMOBJ
    = ___NONNULLWCHARSTRINGLIST_to_SCMOBJ;

  ___gstate.___VARIANT_to_SCMOBJ
    = ___VARIANT_to_SCMOBJ;

  ___gstate.___CHARSTRING_to_UCS_2STRING
    = ___CHARSTRING_to_UCS_2STRING;

  ___gstate.___free_UCS_2STRING
    = ___free_UCS_2STRING;

  ___gstate.___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST
    = ___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST;

  ___gstate.___free_NONNULLUCS_2STRINGLIST
    = ___free_NONNULLUCS_2STRINGLIST;

  ___gstate.___make_sfun_stack_marker
    = ___make_sfun_stack_marker;

  ___gstate.___kill_sfun_stack_marker
    = ___kill_sfun_stack_marker;

  ___gstate.___alloc_rc
    = ___alloc_rc;

  ___gstate.___release_rc
    = ___release_rc;

  ___gstate.___addref_rc
    = ___addref_rc;

  ___gstate.___data_rc
    = ___data_rc;

  ___gstate.___set_data_rc
    = ___set_data_rc;

  ___gstate.___alloc_scmobj
    = ___alloc_scmobj;

  ___gstate.___release_scmobj
    = ___release_scmobj;

  ___gstate.___make_pair
    = ___make_pair;

  ___gstate.___make_vector
    = ___make_vector;

  ___gstate.___still_obj_refcount_inc
    = ___still_obj_refcount_inc;

  ___gstate.___still_obj_refcount_dec
    = ___still_obj_refcount_dec;

  ___gstate.___gc_hash_table_ref
    = ___gc_hash_table_ref;

  ___gstate.___gc_hash_table_set
    = ___gc_hash_table_set;

  ___gstate.___gc_hash_table_rehash
    = ___gc_hash_table_rehash;

  ___gstate.___get_min_heap
    = ___get_min_heap;

  ___gstate.___set_min_heap
    = ___set_min_heap;

  ___gstate.___get_max_heap
    = ___get_max_heap;

  ___gstate.___set_max_heap
    = ___set_max_heap;

  ___gstate.___get_live_percent
    = ___get_live_percent;

  ___gstate.___set_live_percent
    = ___set_live_percent;

  ___gstate.___get_standard_level
    = ___get_standard_level;

  ___gstate.___set_standard_level
    = ___set_standard_level;

  ___gstate.___set_debug_settings
    = ___set_debug_settings;

  ___gstate.___get_program_startup_info
    = ___get_program_startup_info;

  ___gstate.___cleanup
    = ___cleanup;

  ___gstate.___cleanup_and_exit_process
    = ___cleanup_and_exit_process;

  ___gstate.___call
    = ___call;

  ___gstate.___propagate_error
    = ___propagate_error;

#ifdef ___DEBUG_HOST_CHANGES
  ___gstate.___register_host_entry
    = ___register_host_entry;
#endif

  ___gstate.___raise_interrupt
    = ___raise_interrupt;

  ___gstate.___begin_interrupt_service
    = ___begin_interrupt_service;

  ___gstate.___check_interrupt
    = ___check_interrupt;

  ___gstate.___end_interrupt_service
    = ___end_interrupt_service;

  ___gstate.___disable_interrupts
    = ___disable_interrupts;

  ___gstate.___enable_interrupts
    = ___enable_interrupts;

  ___gstate.___alloc_mem
    = ___alloc_mem;

  ___gstate.___free_mem
    = ___free_mem;

#endif

  /* 
   * Get processor state.
   */

  ___ps = ___PSTATE;

  /*
   * Setup multithreading structures.
   */

  ___ps->current_thread = ___FAL;
  ___ps->run_queue = ___FAL;

  /*
   * Setup registers.
   */

  for (i=0; i<___NB_GVM_REGS; i++)
    ___ps->r[i] = ___VOID;

  /* 
   * Setup exception handling.
   */

#ifdef ___USE_SETJMP

  ___ps->catcher = 0;

#endif

  /* 
   * Setup interrupt system.
   */

  ___disable_interrupts ();

  for (i=0; i<___NB_INTRS; i++)
    ___ps->intr_flag[i] = 0;

  ___begin_interrupt_service ();
  ___end_interrupt_service (0);

  /* 
   * Create empty global variable list, symbol table and keyword
   * table.
   */

  ___ps->glo_list_head = 0;
  ___ps->glo_list_tail = 0;

  ___GSTATE->symbol_table =
    symkey_table_alloc (___sSYMBOL, INIT_SYMKEY_TBL_LENGTH);

  if (___FIXNUMP(___GSTATE->symbol_table))
    {
      ___cleanup ();
      return ___GSTATE->symbol_table;
    }

  ___GSTATE->keyword_table =
    symkey_table_alloc (___sKEYWORD, INIT_SYMKEY_TBL_LENGTH);

  if (___FIXNUMP(___GSTATE->keyword_table))
    {
      ___cleanup ();
      return ___GSTATE->keyword_table;
    }

  /*
   * Setup program's linker structure.
   */

  mol = linker_to_mod_or_lnk (___setup_params.linker);

  /* 
   * Initialize symbol table, keyword table, global variables
   * and primitives.
   */

  init_symkey_glo1 (mol);
  init_symkey_glo2 (mol);

  /* 
   * Setup each module.
   */

  ___GSTATE->program_descr = setup_modules (mol);

  if (___FIXNUMP(___GSTATE->program_descr))
    {
      ___cleanup ();
      return ___GSTATE->program_descr;
    }

  /* 
   * Create list of command line arguments (accessible through ##command-line).
   */

  {
    ___UCS_2STRING *argv = ___setup_params.argv;

    if (argv[0] == 0) /* use dummy program name if none supplied */
      argv = reset_argv;

#define ___COMMAND_LINE_CE_SELECT(ISO_8859_1,UTF_8,UCS_2,UCS_4,wchar,native) UCS_2

    if ((___err = ___NONNULLSTRINGLIST_to_SCMOBJ
                    (argv,
                     &___GSTATE->command_line,
                     0,
                     ___CE(___COMMAND_LINE_CE_SELECT)))
        != ___FIX(___NO_ERR))
      {
        ___cleanup ();
        return ___err;
      }
  }

  /* 
   * Setup kernel handlers.
   */

#define ___PH_LBL0 1

  /* 
   * The label numbers must match those in the procedure
   * "##kernel-handlers" in the file "_kernel.scm".
   */

  ___start = ___G__23__23_kernel_2d_handlers.prm;

  ___gstate.handler_sfun_conv_error = ___LBL(0);
  ___gstate.handler_cfun_conv_error = ___LBL(1);
  ___gstate.handler_stack_limit     = ___LBL(2);
  ___gstate.handler_heap_limit      = ___LBL(3);
  ___gstate.handler_not_proc        = ___LBL(4);
  ___gstate.handler_not_proc_glo    = ___LBL(5);
  ___gstate.handler_wrong_nargs     = ___LBL(6);
  ___gstate.handler_get_rest        = ___LBL(7);
  ___gstate.handler_get_key         = ___LBL(8);
  ___gstate.handler_get_key_rest    = ___LBL(9);
  ___gstate.handler_force           = ___LBL(10);
  ___gstate.handler_return_to_c     = ___LBL(11);
  ___gstate.handler_break           = ___LBL(12);
  ___gstate.internal_return         = ___LBL(13);

  /* 
   * The label numbers must match those in the procedure
   * "##dynamic-env-bind" in the file "_kernel.scm".
   */

  ___start = ___G__23__23_dynamic_2d_env_2d_bind.prm;

  ___gstate.dynamic_env_bind_return = ___LBL(1);

#undef ___PH_LBL0

  /*
   * Call kernel to start executing program.
   */

  ___ps->r[0] = ___gstate.handler_break;

  ___BEGIN_TRY

  if ((___err = ___make_sfun_stack_marker
                  (&marker,
                   ___FIELD(___FIELD(___GSTATE->program_descr,0),0)))
      == ___FIX(___NO_ERR))
    {
      ___err = ___call (0, ___FIELD(marker,0), marker);
      ___kill_sfun_stack_marker (marker);
    }

  ___END_TRY

  if (___err != ___FIX(___NO_ERR))
    ___cleanup ();

  return ___err;
}


/*---------------------------------------------------------------------------*/
