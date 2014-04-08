/* File: "setup.c" */

/* Copyright (c) 1994-2013 by Marc Feeley, All Rights Reserved. */

/*
 * This module contains the routines that setup the Scheme program for
 * execution.
 */

#define ___INCLUDED_FROM_SETUP
#define ___VERSION 407002
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

___EXP_DATA(___global_state_struct,___gstate0);


/*
 * Global variables needed by this module.
 */

___NEED_GLO(___G__23__23_kernel_2d_handlers) /* from "_kernel.scm" */
___NEED_GLO(___G__23__23_dynamic_2d_env_2d_bind)


/*---------------------------------------------------------------------------*/

/*
 * Interrupt handling.
 */

/*
 * '___raise_interrupt_pstate (___ps, code)' is called when an
 * interrupt has occured.  At some later point in time, the Gambit
 * kernel will cause the Scheme procedure ##interrupt-handler to be
 * called with a single integer argument indicating which interrupt
 * has been received.  Interrupt codes are defined in "gambit.h".
 * Currently, the following codes are defined:
 *
 *   ___INTR_USER        user has interrupted the program (e.g. ctrl-C)
 *   ___INTR_HEARTBEAT   heartbeat time interval has elapsed
 *   ___INTR_GC          a garbage collection has finished
 */

___EXP_FUNC(void,___raise_interrupt_pstate)
   ___P((___processor_state ___ps,
         int code),
        (___ps,
         code)
___processor_state ___ps;
int code;)
{
  /*
   * Note: ___raise_interrupt_pstate may be called before the
   * processor state is initialized.  As a consequence, the
   * interrupt(s) received before the initialization of the processor
   * state will be ignored.
   */

#ifdef CALL_GC_FREQUENTLY
  if (code != ___INTR_USER)
    return;
#endif

  if (___INTERRUPT_REQ(___ps->intr_flag[code] = ___FIX(1)<<code,
                       ___ps->intr_mask))
    ___STACK_TRIP_ON();
}


___EXP_FUNC(void,___raise_interrupt_vmstate)
   ___P((___virtual_machine_state ___vms,
         int code),
        (___vms,
         code)
___virtual_machine_state ___vms;
int code;)
{
  /*TODO: extend to all processors in the VM*/
  ___raise_interrupt_pstate (&___vms->pstate0, code);
}


___EXP_FUNC(void,___raise_interrupt)
   ___P((int code),
        (code)
int code;)
{
  /*TODO: extend to all virtual machines*/
  ___raise_interrupt_vmstate (&___GSTATE->vmstate0, code);
}


___EXP_FUNC(void,___begin_interrupt_service_pstate)
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___STACK_TRIP_OFF();
}


___EXP_FUNC(___BOOL,___check_interrupt_pstate)
   ___P((___PSD
         int code),
        (___PSV
         code)
___PSDKR
int code;)
{
  ___PSGET
  if ((___ps->intr_flag[code] & ~___ps->intr_mask) != ___FIX(0))
    {
      ___ps->intr_flag[code] = ___FIX(0);
      return 1;
    }

  return 0;
}


___EXP_FUNC(void,___end_interrupt_service_pstate)
   ___P((___PSD
         int code),
        (___PSV
         code)
___PSDKR
int code;)
{
  ___PSGET
  if (___ps->intr_enabled != ___FIX(0))
    {
#ifdef CALL_HANDLER_AT_EVERY_POLL
      ___STACK_TRIP_ON();
#else
      while (code < ___NB_INTRS)
        {
          if ((___ps->intr_flag[code] & ~___ps->intr_mask) != ___FIX(0))
            {
              ___STACK_TRIP_ON();
              break;
            }
          code++;
        }
#endif
    }
}


___EXP_FUNC(void,___disable_interrupts_pstate)
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

  ___ps->intr_enabled = ___FIX(0);

  ___begin_interrupt_service_pstate (___PSPNC);
  ___end_interrupt_service_pstate (___PSP 0);
}


___EXP_FUNC(void,___enable_interrupts_pstate)
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

  ___ps->intr_enabled = ___FIX((1<<___NB_INTRS)-1);

  ___begin_interrupt_service_pstate (___PSPNC);
  ___end_interrupt_service_pstate (___PSP 0);
}


___HIDDEN void setup_interrupts_pstate
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  int i;

  ___disable_interrupts_pstate (___PSPNC); /* disable all interrupts */

  ___ps->intr_mask = ___FIX(0); /* None of the interrupts are ignored */

  for (i=0; i<___NB_INTRS; i++) /* None of the interrupts are requested */
    ___ps->intr_flag[i] = ___FIX(0);

  ___begin_interrupt_service_pstate (___PSPNC);
  ___end_interrupt_service_pstate (___PSP 0);
}


/*---------------------------------------------------------------------------*/

/*
 * Alignment of objects.
 */

___HIDDEN ___SCMOBJ *align
   ___P((___SCMOBJ *from,
         ___SIZE_TS words,
         int need_64bit_alignment),
        (from,
         words,
         need_64bit_alignment)
___SCMOBJ *from;
___SIZE_TS words;
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
   ___P((___mod_or_lnk (*linker) (___global_state)),
        (linker)
___mod_or_lnk (*linker) ();)
{
  ___mod_or_lnk mol = linker (___GSTATE);
  if (mol->module.kind == ___LINKFILE_KIND)
    {
      ___linkinfo *p = mol->linkfile.linkertbl;
      while (p->mol != 0)
        {
          p->mol = linker_to_mod_or_lnk
                     (___CAST(___mod_or_lnk (*) ___P((___global_state),()),p->mol));
          p++;
        }
    }
  return mol;
}


typedef struct fem_context
  {
    ___processor_state ps;
    int module_count;
    ___SCMOBJ program_descr;
    ___UTF_8STRING module_script_line;
    ___SCMOBJ flags;
  } fem_context;


___HIDDEN ___SCMOBJ for_each_module
   ___P((fem_context *ctx,
         ___mod_or_lnk mol,
         ___SCMOBJ (*proc) (fem_context*, ___module_struct*)),
        (ctx,
         mol,
         proc)
fem_context *ctx;
___mod_or_lnk mol;
___SCMOBJ (*proc) ();)
{
  if (mol->module.kind == ___LINKFILE_KIND)
    {
      ___linkinfo *p = mol->linkfile.linkertbl;

      while (p->mol != 0)
        {
          ___SCMOBJ e;
          ___SCMOBJ save = ctx->flags;

          ctx->flags = p->flags;

          e = for_each_module (ctx, p->mol, proc);

          ctx->flags = save;

          if (e != ___FIX(___NO_ERR))
            return e;

          p++;
        }

      return ___FIX(___NO_ERR);
    }
  else
    {
      return proc (ctx, ___CAST(___module_struct*,mol));
    }
}


___HIDDEN void fixref
   ___P((___module_struct *module,
         ___SCMOBJ *p),
        (module,
         p)
___module_struct *module;
___SCMOBJ *p;)
{
  ___SCMOBJ v = *p;
  switch (___TYP(v))
    {
    case ___tMEM1:
      if (___INT(v)<0)
        *p = ___CAST(___SCMOBJ*,module->keytbl)[-1-___INT(v)];
      else
        {
          int n = ___INT(v);
          if (n < module->subcount)
            *p = ___CAST(___SCMOBJ*,module->subtbl)[n];
          else
            *p = ___TAG(___CAST(___SCMOBJ*,&module->lbltbl[n-module->subcount]),___tSUBTYPED);
        }
      break;

    case ___tMEM2:
      if (___INT(v)<0)
        *p = ___CAST(___SCMOBJ*,module->symtbl)[-1-___INT(v)];
      else
        *p = ___TAG(&___CAST(___SCMOBJ*,module->cnstbl)[(___PAIR_SIZE+1)*___INT(v)], ___tPAIR);
      break;
    }
}


___HIDDEN ___SCMOBJ make_global
   ___P((___processor_state ___ps,
         ___UTF_8STRING str,
         int supply,
         ___glo_struct **glo),
        (___ps,
         str,
         supply,
         glo)
___processor_state ___ps;
___UTF_8STRING str;
int supply;
___glo_struct **glo;)
{
  ___glo_struct *g;
  ___SCMOBJ sym = ___make_symkey_from_UTF_8_string (str, ___sSYMBOL);

  if (___FIXNUMP(sym))
    return sym;

  sym = ___make_global_var (sym);

  if (___FIXNUMP(sym))
    return sym;

  g = ___GLOBALVARSTRUCT(sym);

  if (___ps != NULL)
    {
      /*
       * If the variable is supplied by the module, mark it specially
       * so that it won't be flagged as an undefined variable.
       */

      if (supply)
        ___GLOCELL(g->val) = ___UNB2;
    }

  *glo = g;

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ setup_module_fixup
   ___P((fem_context *ctx,
         ___module_struct *module),
        (ctx,
         module)
fem_context *ctx;
___module_struct *module;)
{
  int i, j;
  int flags;
  ___FAKEWORD *glotbl;
  int supcount;
  ___UTF_8STRING *glo_names;
  ___SCMOBJ *symtbl;
  int symcount;
  ___UTF_8STRING *sym_names;
  ___SCMOBJ *keytbl;
  int keycount;
  ___UTF_8STRING *key_names;
  ___SCMOBJ *lp;
  ___label_struct *lbltbl;
  int lblcount;
  ___SCMOBJ *ofdtbl;
  int ofd_length;
  ___SCMOBJ *cnstbl;
  int cnscount;
  ___SCMOBJ *subtbl;
  int subcount;

  /* TODO: make this phase atomic for when there are multiple VMs? */

  lblcount = module->lblcount;

  if (lblcount > 0)
    ctx->module_count++;

  flags = module->flags;

  if (flags & ___SETUP_FIXUP_DONE)
    return ___FIX(___NO_ERR);

  module->flags = flags | ___SETUP_FIXUP_DONE;

  glotbl     = module->glotbl;
  supcount   = module->supcount;
  glo_names  = module->glo_names;
  symtbl     = ___CAST(___SCMOBJ*,module->symtbl);
  symcount   = module->symcount;
  sym_names  = module->sym_names;
  keytbl     = ___CAST(___SCMOBJ*,module->keytbl);
  keycount   = module->keycount;
  key_names  = module->key_names;
  lp         = module->lp;
  lbltbl     = module->lbltbl;
  ofdtbl     = module->ofdtbl;
  ofd_length = module->ofd_length;
  cnstbl     = module->cnstbl;
  cnscount   = module->cnscount;
  subtbl     = ___CAST(___SCMOBJ*,module->subtbl);
  subcount   = module->subcount;

  /*
   * Check that the version of the compiler used to compile the module
   * is compatible with the compiler used to compile the runtime
   * system.
   */

  if (module->version / 10000 < ___VERSION / 10000)
    return ___FIX(___MODULE_VERSION_TOO_OLD_ERR);

  if (module->version / 10000 > ___VERSION / 10000)
    return ___FIX(___MODULE_VERSION_TOO_NEW_ERR);

  /* Align label table and pair table */

  lbltbl = ___CAST(___label_struct*,
                   align (___CAST(___SCMOBJ*,lbltbl), lblcount*___LS, 0));
  module->lbltbl = lbltbl;

  cnstbl = align (cnstbl, (___PAIR_SIZE+1)*cnscount, 0);
  module->cnstbl = cnstbl;

  /* Setup module's global variable table */

  if (glo_names != 0)
    {
      /*
       * Create global variables in reverse order so that global
       * variables bound to c-lambdas are created last.
       */

      ___processor_state ___ps = ctx->ps;

      i = 0;
      while (glo_names[i] != 0)
        i++;
      while (i-- > 0)
        {
          ___glo_struct *glo = 0;
          ___SCMOBJ e = make_global (___ps, glo_names[i], i<supcount, &glo);
          if (e != ___FIX(___NO_ERR))
            return e;
          glotbl[i] = ___CAST(___FAKEWORD,glo);
        }
    }

  /* Setup module's symbol table */

  if (sym_names != 0)
    {
      i = 0;
      while (sym_names[i] != 0)
        {
          ___SCMOBJ sym = ___make_symkey_from_UTF_8_string (sym_names[i], ___sSYMBOL);
          if (___FIXNUMP(sym))
            return sym;
          symtbl[i] = sym;
          i++;
        }
    }
  else
    {
      for (i=symcount-1; i>=0; i--)
        symtbl[i] = ___TAG(___ALIGNUP(symtbl[i], ___WS), ___tSUBTYPED);
    }

  /* Setup module's keyword table */

  if (key_names != 0)
    {
      i = 0;
      while (key_names[i] != 0)
        {
          ___SCMOBJ key = ___make_symkey_from_UTF_8_string (key_names[i], ___sKEYWORD);
          if (___FIXNUMP(key))
            return key;
          keytbl[i] = key;
          i++;
        }
    }
  else
    {
      for (i=keycount-1; i>=0; i--)
        keytbl[i] = ___TAG(___ALIGNUP(keytbl[i], ___WS), ___tSUBTYPED);
    }

  /* Setup module's subtyped object table */

  for (i=subcount-1; i>=0; i--)
    subtbl[i] = align_subtyped (___CAST(___SCMOBJ*,subtbl[i]));

  /* Fix reference in module's descriptor */

  fixref (module, &module->moddescr);

  /* Fix references in module's pair table */

  for (i=cnscount-1; i>=0; i--)
    {
      fixref (module, cnstbl+i*(___PAIR_SIZE+1)+1);
      fixref (module, cnstbl+i*(___PAIR_SIZE+1)+2);
    }

  /* Fix references in module's subtyped object table */

  for (j=subcount-1; j>=0; j--)
    {
      ___SCMOBJ *p = ___UNTAG_AS(subtbl[j],___tSUBTYPED);
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
            fixref (module, p+i);
        }
    }

  /* Align module's out-of-line frame descriptor table */

  ofdtbl = ___CAST(___SCMOBJ*,align (ofdtbl, ofd_length, 0));

  /* Align module's label table */

  if (lblcount > 0)
    {
      ___host current_host = 0;
      void **hlbl_ptr = 0;
      ___SCMOBJ *ofd_alloc;

      ofd_alloc = ofdtbl;

      for (i=0; i<lblcount; i++)
        {
          ___label_struct *lbl = &lbltbl[i];
          ___SCMOBJ head = lbl->header;

          if (___TESTHEADERTAG(head,___sVECTOR))
            {
              /*
               * Setup name returned by
               * (##subprocedure-parent-name proc)
               */

              ___UTF_8STRING name =
                ___CAST(___UTF_8STRING,
                        ___CAST_FAKEVOIDSTAR_TO_VOIDSTAR(lbl->host_label));

              if (name == 0)
                lbl->host_label = ___CAST(___FAKEVOIDSTAR,___FAL);
              else
                {
                  /* TODO: the time needed to create these symbols dynamically dominates the module setup time... optimize by using the local symbol table... this may require changes to the linker */

                  ___SCMOBJ sym =
                    ___find_symkey_from_UTF_8_string (name, ___sSYMBOL);

                  if (___FIXNUMP(sym))
                    return sym;

                  if (sym == ___FAL)
                    return ___FIX(___UNKNOWN_ERR);

                  lbl->host_label = ___CAST(___FAKEVOIDSTAR,sym);
                }

              /*
               * Setup debugging information returned by
               * (##subprocedure-parent-info proc)
               */

              fixref (module, &lbl->entry_or_descr);

              if (hlbl_ptr != 0)
                hlbl_ptr++; /* skip INTRO label */
            }
          else
            {
              if (flags & ___USES_INDIRECT_GOTO)
                {
                  /*
                   * The module uses the indirect goto statement, so
                   * we must call the current C host function to get
                   * the table of goto labels used to initialize the
                   * label structures.  This should be done once per C
                   * host function.
                   */

                  if (___CAST_FAKEHOST_TO_HOST(lbl->host) != current_host)
                    {
                      current_host = ___CAST_FAKEHOST_TO_HOST(lbl->host);
                      hlbl_ptr = ___CAST(void**,current_host (0));
                      hlbl_ptr++; /* skip INTRO label */
                    }

                  lbl->host_label = ___CAST_VOIDSTAR_TO_FAKEVOIDSTAR(*hlbl_ptr++);
                }

              /*
               * Return labels contain a GC map descriptor which has
               * to be setup if it is out-of-line (which happens when
               * the stack frame is large.
               */

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
      *lp = ___TAG(lbltbl,___tSUBTYPED);
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN char module_prefix[] = ___MODULE_PREFIX;

#define module_prefix_length (sizeof(module_prefix)-1)


___HIDDEN ___SCMOBJ setup_module_collect_undef_globals
   ___P((fem_context *ctx,
         ___module_struct *module),
        (ctx,
         module)
fem_context *ctx;
___module_struct *module;)
{
  ___processor_state ___ps = ctx->ps;
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___UTF_8STRING *glo_names = module->glo_names;

  if (glo_names != 0)
    {
      ___UTF_8STRING name = module->name;
      ___FAKEWORD *glotbl = module->glotbl;
      int glocount = module->glocount;
      int supcount = module->supcount;
      int i;

      for (i=supcount; i<glocount; i++)
        {
          /*
           * If the global variable is undefined, add it to the list
           * of undefined variables in the module descriptor.
           */

          ___glo_struct *glo = ___CAST(___glo_struct*,glotbl[i]);

          if (___GLOCELL_IN_VM(___vms,glo->val) == ___UNB1)
            {
              ___SCMOBJ err;
              ___SCMOBJ glo_name;
              ___SCMOBJ module_name;
              ___SCMOBJ pair1;
              ___SCMOBJ pair2;

              if ((err = ___NONNULLUTF_8STRING_to_SCMOBJ
                           (NULL, /* allocate as permanent object */
                            glo_names[i],
                            &glo_name,
                            -1))
                  != ___FIX(___NO_ERR))
                return err;

              if ((err = ___NONNULLUTF_8STRING_to_SCMOBJ
                           (NULL, /* allocate as permanent object */
                            name+module_prefix_length,
                            &module_name,
                            -1))
                  != ___FIX(___NO_ERR))
                return err;

              pair1 = ___make_pair (NULL, /* allocate as permanent object */
                                    glo_name,
                                    module_name);

              if (___FIXNUMP(pair1))
                return pair1;

              pair2 = ___make_pair (NULL, /* allocate as permanent object */
                                    pair1,
                                    ___FIELD(ctx->program_descr,1));

              if (___FIXNUMP(pair2))
                return pair2;

              ___FIELD(ctx->program_descr,1) = pair2;
            }
        }
    }

  return ___FIX(___NO_ERR);
}


___HIDDEN ___SCMOBJ setup_module_collect_moddescrs
   ___P((fem_context *ctx,
         ___module_struct *module),
        (ctx,
         module)
fem_context *ctx;
___module_struct *module;)
{
  if (module->lblcount > 0)
    {
      ___SCMOBJ err;
      ___SCMOBJ descr = module->moddescr;

      if (ctx->flags != ___FAL) /* override compiler flags */
        ___FIELD(descr,2) = ctx->flags;

      if ((err = ___NONNULLPOINTER_to_SCMOBJ
                   (NULL, /* allocate as permanent object */
                    ___CAST(void*,module),
                    ___FAL,
                    NULL,
                    &___FIELD(descr,4),
                    ___RETURN_POS))
          != ___FIX(___NO_ERR))
        return err;

      ___FIELD(___FIELD(ctx->program_descr,0),ctx->module_count) = descr;

      ctx->module_count++;
    }

  return module->setup_mod ();
}


___HIDDEN ___SCMOBJ get_script_line_proc
   ___P((fem_context *ctx,
         ___module_struct *module),
        (ctx,
         module)
fem_context *ctx;
___module_struct *module;)
{
  if (module->script_line != 0)
    ctx->module_script_line = module->script_line;
  return ___FIX(___NO_ERR);
}


___HIDDEN ___UTF_8STRING get_script_line
   ___P((___mod_or_lnk mol),
        (mol)
___mod_or_lnk mol;)
{
  fem_context fem_ctx;
  fem_context *ctx = &fem_ctx;

  ctx->module_script_line = 0;

  if (for_each_module (ctx, mol, get_script_line_proc) == ___FIX(___NO_ERR))
    return ctx->module_script_line;

  return 0;
}


___HIDDEN ___SCMOBJ setup_modules
   ___P((___processor_state ___ps,
         ___mod_or_lnk mol),
        (___ps,
         mol)
___processor_state ___ps;
___mod_or_lnk mol;)
{
  ___SCMOBJ result;
  ___SCMOBJ script_line;
  fem_context fem_ctx;
  fem_context *ctx = &fem_ctx;

  /* Create program descriptor */

  if (___FIXNUMP(result = ___make_vector (NULL, 3, ___NUL)))
    return result;

  ctx->ps = ___ps;
  ctx->module_count = 0;
  ctx->program_descr = result;

  /* Fixup objects and tables in all the modules and count modules */

  if ((result = for_each_module (ctx,
                                 mol,
                                 setup_module_fixup))
      != ___FIX(___NO_ERR))
    return result;

  if (___ps != NULL)
    {
      /* Collect undefined globals */

      if ((result = for_each_module (ctx,
                                     mol,
                                     setup_module_collect_undef_globals))
          != ___FIX(___NO_ERR))
        return result;
    }

  /* Create vector of module descriptors */

  if (___FIXNUMP(result = ___make_vector (NULL, ctx->module_count, ___FAL)))
    return result;

  ___FIELD(ctx->program_descr,0) = result;

  ctx->module_count = 0;
  ctx->flags = ___FAL; /* default to compiler flags */

  if ((result = for_each_module (ctx,
                                 mol,
                                 setup_module_collect_moddescrs))
      != ___FIX(___NO_ERR))
    return result;

  if ((result = ___UTF_8STRING_to_SCMOBJ
                  (NULL, /* allocate as permanent object */
                   get_script_line (mol),
                   &script_line,
                   -1))
      != ___FIX(___NO_ERR))
    return result;

  ___FIELD(ctx->program_descr,2) = script_line;

  return ctx->program_descr;
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
              (___CAST(___mod_or_lnk (*) ___P((___global_state),()),
                       linker));

      if (mol->linkfile.version < 0) /* was it already setup? */
        result = ___FIX(___MODULE_ALREADY_LOADED_ERR);
      else
        {
          result = setup_modules (___PSTATE, mol);
          mol->linkfile.version = -1; /* mark link file as 'setup' */
        }
    }

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


typedef union
  {
    ___U16 u16[4];
    ___U32 u32[2];
    ___U64 u64;
    ___F64 f64;
  } f64_parts;


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

  f64_parts y;

  y.f64 = x;

  return ((y.u16[F64_HI16] ^ 0x7ff0) & 0x7fff) >= 0x10;

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

  ___UM32 tmp;
  f64_parts y;

  y.f64 = x;

  tmp = (y.u32[F64_HI32] ^ 0x7ff00000) & 0x7fffffff;

  return tmp < 0x100000 && (tmp | y.u32[F64_LO32]) != 0;

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


#ifdef ___DEFINE_SCALBN

___EXP_FUNC(double,___scalbn)
   ___P((double x,
         int n),
        (x,
         n)
double x;
int n;)
{
#ifdef ___HAVE_GOOD_SCALBN

  return scalbn (x, n);

#else

  return ldexp (x, n);

#endif
}

#endif


#ifdef ___DEFINE_ILOGB

___EXP_FUNC(int,___ilogb)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_ILOGB

  return ilogb (x);

#else

  if (___isfinite (x))
    {
      if (x == 0.0)
        return INT_MIN;
      else
        {
          int e;
          frexp (x, &e);
          return e-1;
        }
    }
  else if (___isnan (x))
    return INT_MIN; /* x == NaN */
  else
    return INT_MAX; /* x == +inf or x == -inf */

#endif
}

#endif


#ifdef ___DEFINE_EXPM1

___EXP_FUNC(double,___expm1)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_EXPM1

  return expm1 (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return exp (x) - 1.0;

#else

  /* TODO: replace with more accurate algorithm */
  return exp (x) - 1.0;

#endif

#endif
}

#endif


#ifdef ___DEFINE_LOG1P

___EXP_FUNC(double,___log1p)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_LOG1P

  return log1p (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return log (x + 1.0);

#else

  /* TODO: replace with more accurate algorithm */
  return log (x + 1.0);

#endif

#endif
}

#endif


#ifdef ___DEFINE_SINH

___EXP_FUNC(double,___sinh)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_SINH

  return sinh (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return (exp (x) - exp (-x)) / 2.0;

#else

  /* TODO: replace with more accurate algorithm */
  return (exp (x) - exp (-x)) / 2.0;

#endif

#endif
}

#endif


#ifdef ___DEFINE_COSH

___EXP_FUNC(double,___cosh)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_COSH

  return cosh (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return (exp (x) + exp (-x)) / 2.0;

#else

  /* TODO: replace with more accurate algorithm */
  return (exp (x) + exp (-x)) / 2.0;

#endif

#endif
}

#endif


#ifdef ___DEFINE_TANH

___EXP_FUNC(double,___tanh)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_TANH

  return tanh (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  double t = exp (2.0*x);
  return (t - 1.0) / (t + 1.0);

#else

  /* TODO: replace with more accurate algorithm */
  double t = exp (2.0*x);
  return (t - 1.0) / (t + 1.0);

#endif

#endif
}

#endif


#ifdef ___DEFINE_ASINH

___EXP_FUNC(double,___asinh)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_ASINH

  return asinh (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return log (x + sqrt (x*x + 1.0));

#else

  /* TODO: replace with more accurate algorithm */
  return log (x + sqrt (x*x + 1.0));

#endif

#endif
}

#endif


#ifdef ___DEFINE_ACOSH

___EXP_FUNC(double,___acosh)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_ACOSH

  return acosh (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return log (x + sqrt (x - 1.0) * sqrt (x + 1.0));

#else

  /* TODO: replace with more accurate algorithm */
  return log (x + sqrt (x - 1.0) * sqrt (x + 1.0));

#endif

#endif
}

#endif


#ifdef ___DEFINE_ATANH

___EXP_FUNC(double,___atanh)
   ___P((double x),
        (x)
double x;)
{
#ifdef ___HAVE_GOOD_ATANH

  return atanh (x);

#else

#ifdef ___USE_NAIVE_MATH_ALGO

  return (log (1.0 + x) - log (1.0 - x)) / 2.0;

#else

  /* TODO: replace with more accurate algorithm */
  return (log (1.0 + x) - log (1.0 - x)) / 2.0;

#endif

#endif
}

#endif


#ifdef ___DEFINE_ATAN2

___EXP_FUNC(double,___atan2)
   ___P((double y,
         double x),
        (y,
         x)
double y;
double x;)
{
#ifdef ___HAVE_GOOD_ATAN2

  return atan2 (y, x);

#else

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

#endif
}

#endif


#ifdef ___DEFINE_POW

___EXP_FUNC(double,___pow)
   ___P((double x,
         double y),
        (x,
         y)
double x;
double y;)
{
#ifdef ___HAVE_GOOD_POW

  return pow (x, y);

#else

  if (y == 0.0)
    return 1.0;
  else if (___isnan (x))
    return x;
  else if (___isnan (y))
    return y;
  else
    return pow (x, y);

#endif
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
      ___linkinfo *p1 = mol->linkfile.linkertbl;
      ___FAKEWORD *p2 = mol->linkfile.sym_list;

      while (p1->mol != 0)
        {
          init_symkey_glo1 (p1->mol);
          p1++;
        }

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
      ___linkinfo *p1 = mol->linkfile.linkertbl;
      ___FAKEWORD *p2 = mol->linkfile.sym_list;
      ___FAKEWORD *p3 = mol->linkfile.key_list;

      while (p1->mol != 0)
        {
          init_symkey_glo2 (p1->mol);
          p1++;
        }

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

#ifndef ___SINGLE_VM

          glo->val = ___GSTATE->mem.nb_glo_vars++;

#endif

          glo->next = 0;
          if (___GSTATE->mem.glo_list_head == 0)
            ___GSTATE->mem.glo_list_head = glo;
          else
            ___GSTATE->mem.glo_list_tail->next = glo;
          ___GSTATE->mem.glo_list_tail = glo;

          *sym_ptr = ___MAKE_HD((___SYMBOL_SIZE<<___LWS),___sSYMBOL,___PERM);

          sym = align_subtyped (sym_ptr);

          ___FIELD(sym,___SYMKEY_NAME) = str;
          ___FIELD(sym,___SYMBOL_GLOBAL) = ___CAST(___SCMOBJ,glo);

          ___intern_symkey (sym);
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
          ___FIELD(key,___SYMKEY_HASH) = ___hash_scheme_string (str);

          ___intern_symkey (key);
        }
    }
}


/*---------------------------------------------------------------------------*/

/*
 * C to Scheme call handler.
 */


#ifdef EMSCRIPTEN

/*
 * The trampoline function must not be inlined into the ___call
 * function when using emscripten because the fact that ___call uses
 * setjmp will slow down the indirect calls.
 */

__attribute__((noinline))

#endif

___HIDDEN void trampoline
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SCMOBJ ___pc = ___ps->pc;

  for (;;)
    {
#define CALL_STEP ___pc = ___LABEL_HOST(___pc)(___ps)
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
      CALL_STEP;
    }
}


___EXP_FUNC(___SCMOBJ,___call)
   ___P((___PSD
         int nargs,
         ___SCMOBJ proc,
         ___SCMOBJ stack_marker),
        (___PSV
         nargs,
         proc,
         stack_marker)
___PSDKR
int nargs;
___SCMOBJ proc;
___SCMOBJ stack_marker;)
{
  ___PSGET
  ___SCMOBJ *___fp = ___ps->fp;
  ___SCMOBJ ___err;

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

  trampoline (___ps);

  ___END_TRY

  if (___err != ___FIX(___UNWIND_C_STACK) ||
      stack_marker != ___ps->fp[___FRAME_SPACE(2)-2]) /*need more unwinding?*/
    ___THROW(___err);

  ___ps->fp += ___FRAME_SPACE(2);
  ___PSR0 = ___ps->fp[-1];

  return ___FIX(___NO_ERR);
}


___EXP_FUNC(void,___propagate_error)
   ___P((___PSD
         ___SCMOBJ err),
        (___PSV
         err)
___PSDKR
___SCMOBJ err;)
{
  ___PSGET

  if (err != ___FIX(___NO_ERR))
    {
      ___THROW (err);
    }
}


#ifdef ___DEBUG_HOST_CHANGES

___EXP_FUNC(void,___register_host_entry)
   ___P((___PSD
         ___WORD start,
         char *module_name),
        (___PSV
         start,
         module_name)
___PSDKR
___WORD start;
char *module_name;)
{
#ifdef ___DEBUG

  ___PSGET
  ___SCMOBJ sym;

  ___printf ("*** Entering ");

  if ((sym = ___find_global_var_bound_to (___ps->pc)) != ___NUL ||
      (sym = ___find_global_var_bound_to (start)) != ___NUL)
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


___EXP_FUNC(void,___cleanup) ___PVOID
{
  /*
   * Only do cleanup once after successful setup.
   */

  if (___GSTATE->setup_state != 1)
    return;

  ___GSTATE->setup_state = 2;

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
  setup_params->argv              = setup_params->reset_argv;
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
  setup_params->gambcdir_map      = 0;
  setup_params->remote_dbg_addr   = 0;
  setup_params->rpc_server_addr   = 0;
  setup_params->linker            = 0;
  setup_params->reset_argv0[0]    = 0;
  setup_params->reset_argv[0]     = setup_params->reset_argv0;
  setup_params->reset_argv[1]     = 0;
  setup_params->dummy8            = 0;
  setup_params->dummy7            = 0;
  setup_params->dummy6            = 0;
  setup_params->dummy5            = 0;
  setup_params->dummy4            = 0;
  setup_params->dummy3            = 0;
  setup_params->dummy2            = 0;
  setup_params->dummy1            = 0;
}


___EXP_FUNC(___SIZE_T,___get_min_heap) ___PVOID
{
  return ___GSTATE->setup_params.min_heap;
}


___EXP_FUNC(void,___set_min_heap)
   ___P((___SIZE_T bytes),
        (bytes)
___SIZE_T bytes;)
{
  ___GSTATE->setup_params.min_heap = bytes;
}


___EXP_FUNC(___SIZE_T,___get_max_heap) ___PVOID
{
  return ___GSTATE->setup_params.max_heap;
}


___EXP_FUNC(void,___set_max_heap)
   ___P((___SIZE_T bytes),
        (bytes)
___SIZE_T bytes;)
{
  ___GSTATE->setup_params.max_heap = bytes;
}


___EXP_FUNC(int,___get_live_percent) ___PVOID
{
  return ___GSTATE->setup_params.live_percent;
}


___EXP_FUNC(void,___set_live_percent)
   ___P((int percent),
        (percent)
int percent;)
{
  ___GSTATE->setup_params.live_percent = percent;
}


___EXP_FUNC(int,___get_standard_level) ___PVOID
{
  return ___GSTATE->setup_params.standard_level;
}


___EXP_FUNC(void,___set_standard_level)
   ___P((int level),
        (level)
int level;)
{
  ___GSTATE->setup_params.standard_level = level;
}


___EXP_FUNC(void,___set_gambcdir)
   ___P((___UCS_2STRING gambcdir),
        (gambcdir)
___UCS_2STRING gambcdir;)
{
  ___GSTATE->setup_params.gambcdir = gambcdir;
}


___EXP_FUNC(int,___set_debug_settings)
   ___P((int mask,
         int new_settings),
        (mask,
         new_settings)
int mask;
int new_settings;)
{
  int old_settings = ___GSTATE->setup_params.debug_settings;

  ___GSTATE->setup_params.debug_settings =
    (old_settings & ~mask) | (new_settings & mask);

  return old_settings;
}


___EXP_FUNC(___program_startup_info_struct*,___get_program_startup_info)
   ___PVOID
{
  return &___program_startup_info;
}


___HIDDEN ___SCMOBJ setup_command_line_arguments ___PVOID
{
  ___UCS_2STRING *argv = ___GSTATE->setup_params.argv;

  if (argv[0] == 0) /* use dummy program name if none supplied */
    argv = ___GSTATE->setup_params.reset_argv;

#define ___COMMAND_LINE_CE_SELECT(ISO_8859_1,UTF_8,UCS_2,UCS_4,wchar,native) UCS_2

  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (NULL, /* allocate as permanent object */
            argv,
            &___GSTATE->command_line,
            -1,
            ___CE(___COMMAND_LINE_CE_SELECT));
}


___HIDDEN void setup_kernel_handlers ___PVOID
{
  ___SCMOBJ ___start;

#define ___PH_LBL0 1

  /*
   * The label numbers must match those in the procedure
   * "##kernel-handlers" in the file "_kernel.scm".
   */

  ___start = ___PRMCELL(___G__23__23_kernel_2d_handlers.prm);

  ___GSTATE->handler_sfun_conv_error = ___LBL(0);
  ___GSTATE->handler_cfun_conv_error = ___LBL(1);
  ___GSTATE->handler_stack_limit     = ___LBL(2);
  ___GSTATE->handler_heap_limit      = ___LBL(3);
  ___GSTATE->handler_not_proc        = ___LBL(4);
  ___GSTATE->handler_not_proc_glo    = ___LBL(5);
  ___GSTATE->handler_wrong_nargs     = ___LBL(6);
  ___GSTATE->handler_get_rest        = ___LBL(7);
  ___GSTATE->handler_get_key         = ___LBL(8);
  ___GSTATE->handler_get_key_rest    = ___LBL(9);
  ___GSTATE->handler_force           = ___LBL(10);
  ___GSTATE->handler_return_to_c     = ___LBL(11);
  ___GSTATE->handler_break           = ___LBL(12);
  ___GSTATE->internal_return         = ___LBL(13);

  /*
   * The label numbers must match those in the procedure
   * "##dynamic-env-bind" in the file "_kernel.scm".
   */

  ___start = ___PRMCELL(___G__23__23_dynamic_2d_env_2d_bind.prm);

  ___GSTATE->dynamic_env_bind_return = ___LBL(1);

#undef ___PH_LBL0
}


___EXP_FUNC(void,___cleanup_pstate)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
}


___EXP_FUNC(___SCMOBJ,___setup_pstate)
   ___P((___processor_state ___ps,
         ___virtual_machine_state ___vms),
        (___ps)
___processor_state ___ps;)
{
  int i;
  ___SCMOBJ ___err;
  ___SCMOBJ marker;

  /*
   * Setup current OS thread so that it can find the processor state
   * it is running.
   */

  ___SET_PSTATE(___ps);

  /*
   * Setup processor's memory management.
   */

  ___setup_mem_pstate (___ps, ___vms);

  /*
   * Setup green thread structures.
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
   * Setup interrupt system of this processor.
   */

  setup_interrupts_pstate (___PSPNC);

  /*
   * Start program execution by loading _kernel module.
   */

  ___ps->r[0] = ___GSTATE->handler_break;

  ___BEGIN_TRY

  if ((___err = ___make_sfun_stack_marker
                  (___ps,
                   &marker,
                   ___FIELD(___FIELD(___FIELD(___GSTATE->program_descr,0),0),1)))
      == ___FIX(___NO_ERR))
    {
      ___err = ___call (___PSP 0, ___FIELD(marker,0), marker);
      ___kill_sfun_stack_marker (marker);
    }

  ___END_TRY

  return ___err;
}


___EXP_FUNC(void,___cleanup_vmstate)
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
}


___EXP_FUNC(___SCMOBJ,___setup_vmstate)
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  /*
   * Setup virtual machine's memory management.
   */

  ___setup_mem_vmstate (___vms);

  /*
   * Start the main processor of the virtual machine.
   */

  return ___setup_pstate (&___vms->pstate0, ___vms);
}


___HIDDEN ___SCMOBJ setup_os_and_mem ___PVOID
{
  ___SCMOBJ err;

  /*
   * Setup the operating system module.
   */

  if ((err = ___setup_os ()) == ___FIX(___NO_ERR))
    {
      /*
       * Setup memory management.
       */

      if ((err = ___setup_mem ()) != ___FIX(___NO_ERR))
        ___cleanup_os ();
    }

  return err;
}


___HIDDEN void setup_dynamic_linking ___PVOID
{
  /*
   * Setup global state to avoid problems on systems that don't
   * support the dynamic loading of files that import functions.
   */

  ___GSTATE->dummy8 = 0;
  ___GSTATE->dummy7 = 0;
  ___GSTATE->dummy6 = 0;
  ___GSTATE->dummy5 = 0;
  ___GSTATE->dummy4 = 0;
  ___GSTATE->dummy3 = 0;
  ___GSTATE->dummy2 = 0;
  ___GSTATE->dummy1 = 0;

#ifndef ___CAN_IMPORT_CLIB_DYNAMICALLY

  ___GSTATE->fabs  = fabs;
  ___GSTATE->floor = floor;
  ___GSTATE->ceil  = ceil;
#ifdef ___HAVE_GOOD_SCALBN
  ___GSTATE->scalbn= scalbn;
#else
  ___GSTATE->scalbn= ___scalbn;
#endif
#ifdef ___HAVE_GOOD_ILOGB
  ___GSTATE->ilogb = ilogb;
#else
  ___GSTATE->ilogb = ___ilogb;
#endif
  ___GSTATE->exp   = exp;
#ifdef ___HAVE_GOOD_EXPM1
  ___GSTATE->expm1 = expm1;
#else
  ___GSTATE->expm1 = ___expm1;
#endif
  ___GSTATE->log   = log;
#ifdef ___HAVE_GOOD_LOG1P
  ___GSTATE->log1p = log1p;
#else
  ___GSTATE->log1p = ___log1p;
#endif
  ___GSTATE->sin   = sin;
  ___GSTATE->cos   = cos;
  ___GSTATE->tan   = tan;
  ___GSTATE->asin  = asin;
  ___GSTATE->acos  = acos;
  ___GSTATE->atan  = atan;
#ifdef ___HAVE_GOOD_SINH
  ___GSTATE->sinh  = sinh;
#else
  ___GSTATE->sinh  = ___sinh;
#endif
#ifdef ___HAVE_GOOD_COSH
  ___GSTATE->cosh  = cosh;
#else
  ___GSTATE->cosh  = ___cosh;
#endif
#ifdef ___HAVE_GOOD_TANH
  ___GSTATE->tanh  = tanh;
#else
  ___GSTATE->tanh  = ___tanh;
#endif
#ifdef ___HAVE_GOOD_ASINH
  ___GSTATE->asinh = asinh;
#else
  ___GSTATE->asinh = ___asinh;
#endif
#ifdef ___HAVE_GOOD_ACOSH
  ___GSTATE->acosh = acosh;
#else
  ___GSTATE->acosh = ___acosh;
#endif
#ifdef ___HAVE_GOOD_ATANH
  ___GSTATE->atanh = atanh;
#else
  ___GSTATE->atanh = ___atanh;
#endif
#ifdef ___HAVE_GOOD_ATAN2
  ___GSTATE->atan2 = atan2;
#else
  ___GSTATE->atan2 = ___atan2;
#endif
#ifdef ___HAVE_GOOD_POW
  ___GSTATE->pow = pow;
#else
  ___GSTATE->pow = ___pow;
#endif
  ___GSTATE->sqrt  = sqrt;

#endif

#ifdef ___USE_SETJMP
#ifndef ___CAN_IMPORT_SETJMP_DYNAMICALLY

  ___GSTATE->setjmp = setjmp;

#endif
#endif

#ifndef ___CAN_IMPORT_DYNAMICALLY

  ___GSTATE->___iswalpha
    = ___iswalpha;

  ___GSTATE->___iswdigit
    = ___iswdigit;

  ___GSTATE->___iswspace
    = ___iswspace;

  ___GSTATE->___iswupper
    = ___iswupper;

  ___GSTATE->___iswlower
    = ___iswlower;

  ___GSTATE->___towupper
    = ___towupper;

  ___GSTATE->___towlower
    = ___towlower;

  ___GSTATE->___string_collate
    = ___string_collate;

  ___GSTATE->___string_collate_ci
    = ___string_collate_ci;

  ___GSTATE->___copysign
    = ___copysign;

  ___GSTATE->___isfinite
    = ___isfinite;

  ___GSTATE->___isnan
    = ___isnan;

  ___GSTATE->___trunc
    = ___trunc;

  ___GSTATE->___round
    = ___round;

#ifdef ___DEFINE_SCALBN
  ___GSTATE->___scalbn
    = ___scalbn;
#endif

#ifdef ___DEFINE_ILOGB
  ___GSTATE->___ilogb
    = ___ilogb;
#endif

#ifdef ___DEFINE_EXPM1
  ___GSTATE->___expm1
    = ___expm1;
#endif

#ifdef ___DEFINE_LOG1P
  ___GSTATE->___log1p
    = ___log1p;
#endif

#ifdef ___DEFINE_SINH
  ___GSTATE->___sinh
    = ___sinh;
#endif

#ifdef ___DEFINE_COSH
  ___GSTATE->___cosh
    = ___cosh;
#endif

#ifdef ___DEFINE_TANH
  ___GSTATE->___tanh
    = ___tanh;
#endif

#ifdef ___DEFINE_ASINH
  ___GSTATE->___asinh
    = ___asinh;
#endif

#ifdef ___DEFINE_ACOSH
  ___GSTATE->___acosh
    = ___acosh;
#endif

#ifdef ___DEFINE_ATANH
  ___GSTATE->___atanh
    = ___atanh;
#endif

#ifdef ___DEFINE_ATAN2
  ___GSTATE->___atan2
    = ___atan2;
#endif

#ifdef ___DEFINE_POW
  ___GSTATE->___pow
    = ___pow;
#endif

  ___GSTATE->___S64_from_SM32_fn
    = ___S64_from_SM32_fn;

  ___GSTATE->___S64_from_SM32_UM32_fn
    = ___S64_from_SM32_UM32_fn;

  ___GSTATE->___S64_from_LONGLONG_fn
    = ___S64_from_LONGLONG_fn;

  ___GSTATE->___S64_to_LONGLONG_fn
    = ___S64_to_LONGLONG_fn;

  ___GSTATE->___S64_fits_in_width_fn
    = ___S64_fits_in_width_fn;

  ___GSTATE->___U64_from_UM32_fn
    = ___U64_from_UM32_fn;

  ___GSTATE->___U64_from_UM32_UM32_fn
    = ___U64_from_UM32_UM32_fn;

  ___GSTATE->___U64_from_ULONGLONG_fn
    = ___U64_from_ULONGLONG_fn;

  ___GSTATE->___U64_to_ULONGLONG_fn
    = ___U64_to_ULONGLONG_fn;

  ___GSTATE->___U64_fits_in_width_fn
    = ___U64_fits_in_width_fn;

  ___GSTATE->___U64_mul_UM32_UM32_fn
    = ___U64_mul_UM32_UM32_fn;

  ___GSTATE->___U64_add_U64_U64_fn
    = ___U64_add_U64_U64_fn;

  ___GSTATE->___SCMOBJ_to_S8
    = ___SCMOBJ_to_S8;

  ___GSTATE->___SCMOBJ_to_U8
    = ___SCMOBJ_to_U8;

  ___GSTATE->___SCMOBJ_to_S16
    = ___SCMOBJ_to_S16;

  ___GSTATE->___SCMOBJ_to_U16
    = ___SCMOBJ_to_U16;

  ___GSTATE->___SCMOBJ_to_S32
    = ___SCMOBJ_to_S32;

  ___GSTATE->___SCMOBJ_to_U32
    = ___SCMOBJ_to_U32;

  ___GSTATE->___SCMOBJ_to_S64
    = ___SCMOBJ_to_S64;

  ___GSTATE->___SCMOBJ_to_U64
    = ___SCMOBJ_to_U64;

  ___GSTATE->___SCMOBJ_to_F32
    = ___SCMOBJ_to_F32;

  ___GSTATE->___SCMOBJ_to_F64
    = ___SCMOBJ_to_F64;

  ___GSTATE->___SCMOBJ_to_CHAR
    = ___SCMOBJ_to_CHAR;

  ___GSTATE->___SCMOBJ_to_SCHAR
    = ___SCMOBJ_to_SCHAR;

  ___GSTATE->___SCMOBJ_to_UCHAR
    = ___SCMOBJ_to_UCHAR;

  ___GSTATE->___SCMOBJ_to_ISO_8859_1
    = ___SCMOBJ_to_ISO_8859_1;

  ___GSTATE->___SCMOBJ_to_UCS_2
    = ___SCMOBJ_to_UCS_2;

  ___GSTATE->___SCMOBJ_to_UCS_4
    = ___SCMOBJ_to_UCS_4;

  ___GSTATE->___SCMOBJ_to_WCHAR
    = ___SCMOBJ_to_WCHAR;

  ___GSTATE->___SCMOBJ_to_SIZE_T
    = ___SCMOBJ_to_SIZE_T;

  ___GSTATE->___SCMOBJ_to_SSIZE_T
    = ___SCMOBJ_to_SSIZE_T;

  ___GSTATE->___SCMOBJ_to_PTRDIFF_T
    = ___SCMOBJ_to_PTRDIFF_T;

  ___GSTATE->___SCMOBJ_to_SHORT
    = ___SCMOBJ_to_SHORT;

  ___GSTATE->___SCMOBJ_to_USHORT
    = ___SCMOBJ_to_USHORT;

  ___GSTATE->___SCMOBJ_to_INT
    = ___SCMOBJ_to_INT;

  ___GSTATE->___SCMOBJ_to_UINT
    = ___SCMOBJ_to_UINT;

  ___GSTATE->___SCMOBJ_to_LONG
    = ___SCMOBJ_to_LONG;

  ___GSTATE->___SCMOBJ_to_ULONG
    = ___SCMOBJ_to_ULONG;

  ___GSTATE->___SCMOBJ_to_LONGLONG
    = ___SCMOBJ_to_LONGLONG;

  ___GSTATE->___SCMOBJ_to_ULONGLONG
    = ___SCMOBJ_to_ULONGLONG;

  ___GSTATE->___SCMOBJ_to_FLOAT
    = ___SCMOBJ_to_FLOAT;

  ___GSTATE->___SCMOBJ_to_DOUBLE
    = ___SCMOBJ_to_DOUBLE;

  ___GSTATE->___SCMOBJ_to_STRUCT
    = ___SCMOBJ_to_STRUCT;

  ___GSTATE->___SCMOBJ_to_UNION
    = ___SCMOBJ_to_UNION;

  ___GSTATE->___SCMOBJ_to_TYPE
    = ___SCMOBJ_to_TYPE;

  ___GSTATE->___SCMOBJ_to_POINTER
    = ___SCMOBJ_to_POINTER;

  ___GSTATE->___SCMOBJ_to_NONNULLPOINTER
    = ___SCMOBJ_to_NONNULLPOINTER;

  ___GSTATE->___SCMOBJ_to_FUNCTION
    = ___SCMOBJ_to_FUNCTION;

  ___GSTATE->___SCMOBJ_to_NONNULLFUNCTION
    = ___SCMOBJ_to_NONNULLFUNCTION;

  ___GSTATE->___SCMOBJ_to_BOOL
    = ___SCMOBJ_to_BOOL;

  ___GSTATE->___SCMOBJ_to_STRING
    = ___SCMOBJ_to_STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLSTRING
    = ___SCMOBJ_to_NONNULLSTRING;

  ___GSTATE->___SCMOBJ_to_NONNULLSTRINGLIST
    = ___SCMOBJ_to_NONNULLSTRINGLIST;

  ___GSTATE->___SCMOBJ_to_CHARSTRING
    = ___SCMOBJ_to_CHARSTRING;

  ___GSTATE->___SCMOBJ_to_NONNULLCHARSTRING
    = ___SCMOBJ_to_NONNULLCHARSTRING;

  ___GSTATE->___SCMOBJ_to_NONNULLCHARSTRINGLIST
    = ___SCMOBJ_to_NONNULLCHARSTRINGLIST;

  ___GSTATE->___SCMOBJ_to_ISO_8859_1STRING
    = ___SCMOBJ_to_ISO_8859_1STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLISO_8859_1STRING
    = ___SCMOBJ_to_NONNULLISO_8859_1STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLISO_8859_1STRINGLIST
    = ___SCMOBJ_to_NONNULLISO_8859_1STRINGLIST;

  ___GSTATE->___SCMOBJ_to_UTF_8STRING
    = ___SCMOBJ_to_UTF_8STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUTF_8STRING
    = ___SCMOBJ_to_NONNULLUTF_8STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUTF_8STRINGLIST
    = ___SCMOBJ_to_NONNULLUTF_8STRINGLIST;

  ___GSTATE->___SCMOBJ_to_UTF_16STRING
    = ___SCMOBJ_to_UTF_16STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUTF_16STRING
    = ___SCMOBJ_to_NONNULLUTF_16STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUTF_16STRINGLIST
    = ___SCMOBJ_to_NONNULLUTF_16STRINGLIST;

  ___GSTATE->___SCMOBJ_to_UCS_2STRING
    = ___SCMOBJ_to_UCS_2STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUCS_2STRING
    = ___SCMOBJ_to_NONNULLUCS_2STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUCS_2STRINGLIST
    = ___SCMOBJ_to_NONNULLUCS_2STRINGLIST;

  ___GSTATE->___SCMOBJ_to_UCS_4STRING
    = ___SCMOBJ_to_UCS_4STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUCS_4STRING
    = ___SCMOBJ_to_NONNULLUCS_4STRING;

  ___GSTATE->___SCMOBJ_to_NONNULLUCS_4STRINGLIST
    = ___SCMOBJ_to_NONNULLUCS_4STRINGLIST;

  ___GSTATE->___SCMOBJ_to_WCHARSTRING
    = ___SCMOBJ_to_WCHARSTRING;

  ___GSTATE->___SCMOBJ_to_NONNULLWCHARSTRING
    = ___SCMOBJ_to_NONNULLWCHARSTRING;

  ___GSTATE->___SCMOBJ_to_NONNULLWCHARSTRINGLIST
    = ___SCMOBJ_to_NONNULLWCHARSTRINGLIST;

  ___GSTATE->___SCMOBJ_to_VARIANT
    = ___SCMOBJ_to_VARIANT;

  ___GSTATE->___release_foreign
    = ___release_foreign;

  ___GSTATE->___release_pointer
    = ___release_pointer;

  ___GSTATE->___release_function
    = ___release_function;

  ___GSTATE->___addref_function
    = ___addref_function;

  ___GSTATE->___release_string
    = ___release_string;

  ___GSTATE->___addref_string
    = ___addref_string;

  ___GSTATE->___release_string_list
    = ___release_string_list;

  ___GSTATE->___addref_string_list
    = ___addref_string_list;

  ___GSTATE->___release_variant
    = ___release_variant;

  ___GSTATE->___addref_variant
    = ___addref_variant;

  ___GSTATE->___S8_to_SCMOBJ
    = ___S8_to_SCMOBJ;

  ___GSTATE->___U8_to_SCMOBJ
    = ___U8_to_SCMOBJ;

  ___GSTATE->___S16_to_SCMOBJ
    = ___S16_to_SCMOBJ;

  ___GSTATE->___U16_to_SCMOBJ
    = ___U16_to_SCMOBJ;

  ___GSTATE->___S32_to_SCMOBJ
    = ___S32_to_SCMOBJ;

  ___GSTATE->___U32_to_SCMOBJ
    = ___U32_to_SCMOBJ;

  ___GSTATE->___S64_to_SCMOBJ
    = ___S64_to_SCMOBJ;

  ___GSTATE->___U64_to_SCMOBJ
    = ___U64_to_SCMOBJ;

  ___GSTATE->___F32_to_SCMOBJ
    = ___F32_to_SCMOBJ;

  ___GSTATE->___F64_to_SCMOBJ
    = ___F64_to_SCMOBJ;

  ___GSTATE->___CHAR_to_SCMOBJ
    = ___CHAR_to_SCMOBJ;

  ___GSTATE->___SCHAR_to_SCMOBJ
    = ___SCHAR_to_SCMOBJ;

  ___GSTATE->___UCHAR_to_SCMOBJ
    = ___UCHAR_to_SCMOBJ;

  ___GSTATE->___ISO_8859_1_to_SCMOBJ
    = ___ISO_8859_1_to_SCMOBJ;

  ___GSTATE->___UCS_2_to_SCMOBJ
    = ___UCS_2_to_SCMOBJ;

  ___GSTATE->___UCS_4_to_SCMOBJ
    = ___UCS_4_to_SCMOBJ;

  ___GSTATE->___WCHAR_to_SCMOBJ
    = ___WCHAR_to_SCMOBJ;

  ___GSTATE->___SIZE_T_to_SCMOBJ
    = ___SIZE_T_to_SCMOBJ;

  ___GSTATE->___SSIZE_T_to_SCMOBJ
    = ___SSIZE_T_to_SCMOBJ;

  ___GSTATE->___PTRDIFF_T_to_SCMOBJ
    = ___PTRDIFF_T_to_SCMOBJ;

  ___GSTATE->___SHORT_to_SCMOBJ
    = ___SHORT_to_SCMOBJ;

  ___GSTATE->___USHORT_to_SCMOBJ
    = ___USHORT_to_SCMOBJ;

  ___GSTATE->___INT_to_SCMOBJ
    = ___INT_to_SCMOBJ;

  ___GSTATE->___UINT_to_SCMOBJ
    = ___UINT_to_SCMOBJ;

  ___GSTATE->___LONG_to_SCMOBJ
    = ___LONG_to_SCMOBJ;

  ___GSTATE->___ULONG_to_SCMOBJ
    = ___ULONG_to_SCMOBJ;

  ___GSTATE->___LONGLONG_to_SCMOBJ
    = ___LONGLONG_to_SCMOBJ;

  ___GSTATE->___ULONGLONG_to_SCMOBJ
    = ___ULONGLONG_to_SCMOBJ;

  ___GSTATE->___FLOAT_to_SCMOBJ
    = ___FLOAT_to_SCMOBJ;

  ___GSTATE->___DOUBLE_to_SCMOBJ
    = ___DOUBLE_to_SCMOBJ;

  ___GSTATE->___STRUCT_to_SCMOBJ
    = ___STRUCT_to_SCMOBJ;

  ___GSTATE->___UNION_to_SCMOBJ
    = ___UNION_to_SCMOBJ;

  ___GSTATE->___TYPE_to_SCMOBJ
    = ___TYPE_to_SCMOBJ;

  ___GSTATE->___POINTER_to_SCMOBJ
    = ___POINTER_to_SCMOBJ;

  ___GSTATE->___NONNULLPOINTER_to_SCMOBJ
    = ___NONNULLPOINTER_to_SCMOBJ;

  ___GSTATE->___FUNCTION_to_SCMOBJ
    = ___FUNCTION_to_SCMOBJ;

  ___GSTATE->___NONNULLFUNCTION_to_SCMOBJ
    = ___NONNULLFUNCTION_to_SCMOBJ;

  ___GSTATE->___BOOL_to_SCMOBJ
    = ___BOOL_to_SCMOBJ;

  ___GSTATE->___STRING_to_SCMOBJ
    = ___STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLSTRING_to_SCMOBJ
    = ___NONNULLSTRING_to_SCMOBJ;

  ___GSTATE->___NONNULLSTRINGLIST_to_SCMOBJ
    = ___NONNULLSTRINGLIST_to_SCMOBJ;

  ___GSTATE->___CHARSTRING_to_SCMOBJ
    = ___CHARSTRING_to_SCMOBJ;

  ___GSTATE->___NONNULLCHARSTRING_to_SCMOBJ
    = ___NONNULLCHARSTRING_to_SCMOBJ;

  ___GSTATE->___NONNULLCHARSTRINGLIST_to_SCMOBJ
    = ___NONNULLCHARSTRINGLIST_to_SCMOBJ;

  ___GSTATE->___ISO_8859_1STRING_to_SCMOBJ
    = ___ISO_8859_1STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLISO_8859_1STRING_to_SCMOBJ
    = ___NONNULLISO_8859_1STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLISO_8859_1STRINGLIST_to_SCMOBJ
    = ___NONNULLISO_8859_1STRINGLIST_to_SCMOBJ;

  ___GSTATE->___UTF_8STRING_to_SCMOBJ
    = ___UTF_8STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUTF_8STRING_to_SCMOBJ
    = ___NONNULLUTF_8STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUTF_8STRINGLIST_to_SCMOBJ
    = ___NONNULLUTF_8STRINGLIST_to_SCMOBJ;

  ___GSTATE->___UTF_16STRING_to_SCMOBJ
    = ___UTF_16STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUTF_16STRING_to_SCMOBJ
    = ___NONNULLUTF_16STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUTF_16STRINGLIST_to_SCMOBJ
    = ___NONNULLUTF_16STRINGLIST_to_SCMOBJ;

  ___GSTATE->___UCS_2STRING_to_SCMOBJ
    = ___UCS_2STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUCS_2STRING_to_SCMOBJ
    = ___NONNULLUCS_2STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUCS_2STRINGLIST_to_SCMOBJ
    = ___NONNULLUCS_2STRINGLIST_to_SCMOBJ;

  ___GSTATE->___UCS_4STRING_to_SCMOBJ
    = ___UCS_4STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUCS_4STRING_to_SCMOBJ
    = ___NONNULLUCS_4STRING_to_SCMOBJ;

  ___GSTATE->___NONNULLUCS_4STRINGLIST_to_SCMOBJ
    = ___NONNULLUCS_4STRINGLIST_to_SCMOBJ;

  ___GSTATE->___WCHARSTRING_to_SCMOBJ
    = ___WCHARSTRING_to_SCMOBJ;

  ___GSTATE->___NONNULLWCHARSTRING_to_SCMOBJ
    = ___NONNULLWCHARSTRING_to_SCMOBJ;

  ___GSTATE->___NONNULLWCHARSTRINGLIST_to_SCMOBJ
    = ___NONNULLWCHARSTRINGLIST_to_SCMOBJ;

  ___GSTATE->___VARIANT_to_SCMOBJ
    = ___VARIANT_to_SCMOBJ;

  ___GSTATE->___CHARSTRING_to_UCS_2STRING
    = ___CHARSTRING_to_UCS_2STRING;

  ___GSTATE->___free_UCS_2STRING
    = ___free_UCS_2STRING;

  ___GSTATE->___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST
    = ___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST;

  ___GSTATE->___free_NONNULLUCS_2STRINGLIST
    = ___free_NONNULLUCS_2STRINGLIST;

  ___GSTATE->___make_sfun_stack_marker
    = ___make_sfun_stack_marker;

  ___GSTATE->___kill_sfun_stack_marker
    = ___kill_sfun_stack_marker;

  ___GSTATE->___alloc_rc
    = ___alloc_rc;

  ___GSTATE->___release_rc
    = ___release_rc;

  ___GSTATE->___addref_rc
    = ___addref_rc;

  ___GSTATE->___data_rc
    = ___data_rc;

  ___GSTATE->___set_data_rc
    = ___set_data_rc;

  ___GSTATE->___alloc_scmobj
    = ___alloc_scmobj;

  ___GSTATE->___release_scmobj
    = ___release_scmobj;

  ___GSTATE->___make_pair
    = ___make_pair;

  ___GSTATE->___make_vector
    = ___make_vector;

  ___GSTATE->___still_obj_refcount_inc
    = ___still_obj_refcount_inc;

  ___GSTATE->___still_obj_refcount_dec
    = ___still_obj_refcount_dec;

  ___GSTATE->___gc_hash_table_ref
    = ___gc_hash_table_ref;

  ___GSTATE->___gc_hash_table_set
    = ___gc_hash_table_set;

  ___GSTATE->___gc_hash_table_rehash
    = ___gc_hash_table_rehash;

  ___GSTATE->___cleanup
    = ___cleanup;

  ___GSTATE->___cleanup_and_exit_process
    = ___cleanup_and_exit_process;

  ___GSTATE->___setup_vmstate
    = ___setup_vmstate;

  ___GSTATE->___cleanup_vmstate
    = ___cleanup_vmstate;

  ___GSTATE->___setup_pstate
    = ___setup_pstate;

  ___GSTATE->___cleanup_pstate
    = ___cleanup_pstate;

  ___GSTATE->___get_min_heap
    = ___get_min_heap;

  ___GSTATE->___set_min_heap
    = ___set_min_heap;

  ___GSTATE->___get_max_heap
    = ___get_max_heap;

  ___GSTATE->___set_max_heap
    = ___set_max_heap;

  ___GSTATE->___get_live_percent
    = ___get_live_percent;

  ___GSTATE->___set_live_percent
    = ___set_live_percent;

  ___GSTATE->___get_standard_level
    = ___get_standard_level;

  ___GSTATE->___set_standard_level
    = ___set_standard_level;

  ___GSTATE->___set_debug_settings
    = ___set_debug_settings;

  ___GSTATE->___get_program_startup_info
    = ___get_program_startup_info;

  ___GSTATE->___call
    = ___call;

  ___GSTATE->___propagate_error
    = ___propagate_error;

#ifdef ___DEBUG_HOST_CHANGES
  ___GSTATE->___register_host_entry
    = ___register_host_entry;
#endif

  ___GSTATE->___raise_interrupt_pstate
    = ___raise_interrupt_pstate;

  ___GSTATE->___raise_interrupt_vmstate
    = ___raise_interrupt_vmstate;

  ___GSTATE->___raise_interrupt
    = ___raise_interrupt;

  ___GSTATE->___begin_interrupt_service_pstate
    = ___begin_interrupt_service_pstate;

  ___GSTATE->___check_interrupt_pstate
    = ___check_interrupt_pstate;

  ___GSTATE->___end_interrupt_service_pstate
    = ___end_interrupt_service_pstate;

  ___GSTATE->___disable_interrupts_pstate
    = ___disable_interrupts_pstate;

  ___GSTATE->___enable_interrupts_pstate
    = ___enable_interrupts_pstate;

  ___GSTATE->___alloc_mem
    = ___alloc_mem;

  ___GSTATE->___free_mem
    = ___free_mem;

  ___GSTATE->___alloc_mem_code
    = ___alloc_mem_code;

  ___GSTATE->___free_mem_code
    = ___free_mem_code;

#ifdef ___USE_emulated_compare_and_swap_word

  ___GSTATE->___emulated_compare_and_swap_word
    = ___emulated_compare_and_swap_word;

#endif

#ifndef ___THREAD_LOCAL_STORAGE_CLASS

  ___GSTATE->___get_tls_ptr
    = ___get_tls_ptr;

  ___GSTATE->___set_tls_ptr
    = ___set_tls_ptr;

#endif

  ___GSTATE->___disable_heartbeat_interrupts
    = ___disable_heartbeat_interrupts;

  ___GSTATE->___enable_heartbeat_interrupts
    = ___enable_heartbeat_interrupts;

#endif
}


___EXP_FUNC(___SCMOBJ,___setup)
   ___P((___setup_params_struct *setup_params),
        (setup_params)
___setup_params_struct *setup_params;)
{
  ___SCMOBJ err;
  ___mod_or_lnk mol;

  /*
   * Check for valid setup_params structure.
   */

  if (setup_params == 0 ||
      setup_params->version != ___VERSION)
    return ___FIX(___UNKNOWN_ERR);

  /*
   * Remember setup parameters.
   */

  ___GSTATE->setup_params = *setup_params;

  /*
   * Disallow cleanup, in case setup fails.
   */

  ___GSTATE->setup_state = 2;

  /*
   * Setup the operating system and memory management modules.
   */

  if ((err = setup_os_and_mem ()) != ___FIX(___NO_ERR))
    return err;

  /*
   * Allow cleanup.
   */

  ___GSTATE->setup_state = 1;

  /*
   * Setup support for dynamic linking.
   */

  setup_dynamic_linking ();

  /*
   * Setup program's linker structure.
   */

  mol = linker_to_mod_or_lnk (___GSTATE->setup_params.linker);

  /*
   * Initialize symbol table, keyword table, global variables
   * and primitives.
   */

  init_symkey_glo1 (mol);
  init_symkey_glo2 (mol);

  /*
   * Setup each module.
   */

  ___GSTATE->program_descr = setup_modules (NULL, mol);

  if (___FIXNUMP(___GSTATE->program_descr))
    {
      ___cleanup ();
      return ___GSTATE->program_descr;
    }

  /*
   * Setup kernel handlers.
   */

  setup_kernel_handlers ();

  /*
   * Create list of command line arguments (accessible through ##command-line).
   */

  if ((err = setup_command_line_arguments ()) != ___FIX(___NO_ERR))
    {
      ___cleanup;
      return err;
    }

  {
    /*
     * By convention, the main module is the last one in the module
     * descriptors.
     */

    ___virtual_machine_state ___vms = &___GSTATE->vmstate0;

    ___SCMOBJ module_descrs = ___FIELD(___GSTATE->program_descr,0);

    ___vms->main_module_id =
      ___FIELD(___FIELD(module_descrs,
                        ___INT(___VECTORLENGTH(module_descrs))-1),
               0);

    /*
     * Start the main virtual machine.
     */

    err = ___setup_vmstate (___vms);
  }

  /*
   * Cleanup if there are any errors.
   */

  if (err != ___FIX(___NO_ERR))
    ___cleanup ();

  return err;
}


/*---------------------------------------------------------------------------*/
