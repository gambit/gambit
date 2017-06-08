;;;============================================================================

;;; File: "_kernel.scm"

;;; Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(macro-case-target

 ((C)

(c-declare #<<c-declare-end

#include "os.h"
#include "os_setup.h"
#include "os_base.h"
#include "os_time.h"
#include "os_shell.h"
#include "os_files.h"
#include "os_dyn.h"
#include "os_tty.h"
#include "os_io.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"

#include "stamp.h"

c-declare-end
)

;;;----------------------------------------------------------------------------

;;; Kernel handlers.

;; The procedure "##kernel-handlers" is only a container for the kernel
;; handlers.  It must never be called.  The function "___setup" in the
;; file "setup.c" is responsible for setting up the kernel handlers.

(define-prim (##kernel-handlers)

  (##declare (not interrupts-enabled))

  (##c-code #<<end-of-code

   /*
    * ___LBL(0)
    *
    * This is the 'Scheme function' conversion error handler.  It is
    * invoked when a data representation conversion error is detected
    * by the C-interface when C is calling a Scheme function.
    */

   ___PUSH_ARGS3(___ps->temp1, /* arg 1 = error code, integer */
                 ___ps->temp2, /* arg 2 = error message, string or #f */
                 ___FIELD(___ps->temp3,0)) /* arg 3 = procedure */

   ___COVER_SFUN_CONVERSION_ERROR_HANDLER;

   ___JUMPPRM(___SET_NARGS(3),
              ___PRMCELL(___G__23__23_raise_2d_sfun_2d_conversion_2d_exception.prm))

end-of-code
)

  (##c-code #<<end-of-code

   /*
    * ___LBL(1)
    *
    * This is the 'C function' conversion error handler.  It is invoked
    * when a data representation conversion error is detected by the
    * C-interface when Scheme is calling a C function.
    */

   int na;
   int i;

   na = ___ps->na;

   /* make space for 3 new arguments (one will replace return address) */

   ___ADJFP((na+1)+2-___FRAME_SPACE(na+1))

   ___SET_R0(___STK(-2)) /* get return address */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+3))) /* shift arguments up by three */

   ___SET_STK(-(na+2),___ps->temp1) /* arg 1 = error code, integer */
   ___SET_STK(-(na+1),___ps->temp2) /* arg 2 = error message, string or #f */
   ___SET_STK(-na,___ps->temp3) /* arg 3 = procedure */

   ___POP_ARGS_IN_REGS(na+3) /* load register arguments */

   ___COVER_CFUN_CONVERSION_ERROR_HANDLER;

   ___JUMPPRM(___SET_NARGS(na+3),
              ___PRMCELL(___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary.prm))

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(2)
    *
    * This is the stack-limit handler.  It is invoked by the ___POLL(n)
    * macro when the stack limit is reached and when an interrupt is received.
    *
    * This handler checks for which reason it was invoked and dispatches
    * to one of the following procedures:
    *
    *  ##interrupt-handler
    *  ##raise-stack-overflow-exception
    */

   int fs;
   ___SCMOBJ ra;

#ifdef ___HEARTBEAT_USING_POLL_COUNTDOWN

  if (___ps->heartbeat_countdown <= 0)
  {
    ___ps->heartbeat_countdown = ___ps->heartbeat_interval;
    ___raise_interrupt (___INTR_HEARTBEAT);
  }

#endif

   /* setup internal return continuation frame */

   ra = ___ps->temp1;

   ___RETI_GET_CFS(ra,fs)

   ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

   ___PUSH_REGS /* push all GVM registers (live or not) */
   ___PUSH(ra)  /* push return address */

   ___ADJFP(-___RETI_RA)

   ___SET_R0(___GSTATE->internal_return)

   /* check why the handler was called */

   if (___FP_AFTER(___fp,___ps->stack_limit)
#ifdef ___CALL_GC_FREQUENTLY
       || --___ps->mem.gc_calls_to_punt_ < 0
#endif
      )
     {
       ___BOOL overflow;

       ___COVER_STACK_LIMIT_HANDLER_STACK_LIMIT;

       ___FRAME_STORE_RA(___R0)
       ___W_ALL
       overflow = ___stack_limit (___PSPNC) && ___garbage_collect (___PSP 0);
       ___R_ALL
       ___SET_R0(___FRAME_FETCH_RA)

       if (overflow)
         {
           ___COVER_STACK_LIMIT_HANDLER_HEAP_OVERFLOW;
           ___JUMPPRM(___SET_NARGS(0),
                      ___PRMCELL(___G__23__23_raise_2d_stack_2d_overflow_2d_exception.prm))
         }
     }

   /* handle interrupts */

   ___JUMPPRM(___SET_NARGS(0),
              ___PRMCELL(___G__23__23_interrupt_2d_handler.prm))

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(3)
    *
    * This is the heap-limit handler.  It is invoked by the ___CHECK_HEAP(n,m)
    * macro when the heap pointer reaches the end of the current msection.
    *
    * This handler simply calls ##check-heap.
    */

   int fs;
   ___SCMOBJ ra;

   /* setup internal return continuation frame */

   ra = ___ps->temp1;

   ___RETI_GET_CFS(ra,fs)

   ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

   ___PUSH_REGS /* push all GVM registers (live or not) */
   ___PUSH(ra)  /* push return address */

   ___ADJFP(-___RETI_RA)

   ___SET_R0(___GSTATE->internal_return)

   /* tail call to ##check-heap */

   ___COVER_HEAP_LIMIT_HANDLER_END;

   ___JUMPPRM(___SET_NARGS(0),
              ___PRMCELL(___G__23__23_check_2d_heap.prm))

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(4)
    *
    * This is the call to nonprocedure handler.  It is invoked when
    * there is an attempt to call an object that is not a procedure.
    *
    * This handler simply tail calls ##apply-with-procedure-check-nary
    * (i.e. the continuation will be the same as that of the faulty call).
    * The arguments are the object that was in operator position followed
    * by the arguments of the faulty call.
    */

   int na;
   int i;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   ___SET_STK(-na,___ps->temp1) /* set operator argument */

   ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

   ___COVER_NONPROC_HANDLER_END;

   ___JUMPPRM(___SET_NARGS(na+1),
              ___PRMCELL(___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary.prm))

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(5)
    *
    * This is the call to global nonprocedure handler.  It is invoked
    * when there is an attempt to call an object that is not a procedure
    * that is bound to a global variable.
    *
    * This handler simply tail calls ##apply-global-with-procedure-check-nary
    * or ##apply-with-procedure-check-nary (i.e. the continuation will
    * be the same as that of the faulty call).
    * ##apply-global-with-procedure-check-nary is called when the global
    * variable's name is known (in this case the arguments are the variable's
    * name followed by the arguments of the faulty call).  Otherwise,
    * ##apply-with-procedure-check-nary is called and the arguments are the
    * object that was in operator position followed by the arguments of the
    * faulty call.
    */

   int na;
   int i;
   ___SCMOBJ result;
   ___SCMOBJ handler;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   result = ___GLOCELL(___CAST(___glo_struct*,___ps->temp4)->val);
   handler = ___PRMCELL(___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary.prm);

#if 0

   i = ___INT(___VECTORLENGTH(___symbol_table)) - 1;

   while (i > 0)
     {
       ___SCMOBJ probe = ___FIELD(___symbol_table,i);

       while (probe != ___NUL)
         {
           if (___CAST(___glo_struct*,___ps->temp4) == ___GLOBALVARSTRUCT(probe))
             {
               ___COVER_GLOBAL_NONPROC_HANDLER_FOUND;
               result = probe;
               handler = ___PRMCELL(___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary.prm);
               break;
             }
           ___COVER_GLOBAL_NONPROC_HANDLER_NEXT;
           probe = ___FIELD(probe,___SYMKEY_NEXT);
         }
       i--;
     }

#endif

   ___SET_STK(-na,result) /* set operator argument */

   ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

   ___COVER_GLOBAL_NONPROC_HANDLER_END;

   ___JUMPPRM(___SET_NARGS(na+1),handler)

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(6)
    *
    * This is the wrong number of arguments handler.  It is invoked when
    * a procedure is called with a number of arguments that it does not
    * accept.
    *
    * This handler simply tail calls
    * ##raise-wrong-number-of-arguments-exception (i.e. the continuation
    * will be the same as that of the faulty call).  The arguments are the
    * object that was in operator position followed by the arguments of
    * the faulty call.
    */

   int na;
   int i;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   /* ___ps->temp1 points to the entry point of the procedure */

   if (___HD_TYP(___HEADER(___ps->temp1)) == ___PERM)
     {
       ___COVER_WRONG_NARGS_HANDLER_NONCLOSURE;
       ___SET_STK(-na,___ps->temp1) /*set operator argument when nonclosure*/
     }
   else
     {
       ___COVER_WRONG_NARGS_HANDLER_CLOSURE;
       ___SET_STK(-na,___SELF) /* set operator argument when closure */
     }

   ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

   ___JUMPPRM(___SET_NARGS(na+1),
              ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(7)
    *
    * This is the rest parameter handler.  It is invoked when a nonnull
    * rest parameter must be constructed.
    */

   int np;
   int na;
   int i;
   ___SCMOBJ rest_param_list;

   np = ___PRD_NBPARMS(___HEADER(___ps->temp1));
   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   if (na < np)
     {
       ___COVER_REST_PARAM_HANDLER_WRONG_NARGS;

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))
     }

   rest_param_list = ___NUL;

   i = na - np + 1;

   while (i > 0)
     {
       rest_param_list = ___CONS(___POP,rest_param_list);
       i--;

       if (___hp > ___ps->heap_limit)
         {
            ___BOOL need_to_gc;

            ___COVER_REST_PARAM_HANDLER_HEAP_LIMIT;

            ___W_ALL
            need_to_gc = ___heap_limit (___PSPNC);
            ___R_ALL

            if (need_to_gc)
              {
                /*
                 * We need to garbage collect, but before we do we have
                 * to remove all arguments from the stack so that the GC
                 * only sees complete continuation frames on the stack.
                 * The arguments are stored in a heap allocated vector.
                 */

                ___COVER_REST_PARAM_HANDLER_NEED_TO_GC;

                while (i > 0)
                  {
                    rest_param_list = ___CONS(___POP,rest_param_list);
                    i--;
                  }

                ___BEGIN_ALLOC_VECTOR(np)
                i = np - 1;
                ___ADD_VECTOR_ELEM(i,rest_param_list)
                while (i > 0)
                  {
                    i--;
                    ___ADD_VECTOR_ELEM(i,___POP)
                  }
                ___END_ALLOC_VECTOR(np)

                ___PUSH_ARGS2(___ps->temp1,___GET_VECTOR(np))

                ___JUMPPRM(___SET_NARGS(2),
                           ___PRMCELL(___G__23__23_rest_2d_param_2d_check_2d_heap.prm))
              }
          }
     }

   ___COVER_REST_PARAM_HANDLER_NO_NEED_TO_GC;

   ___PUSH(rest_param_list) /* rest parameter is last */

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___JUMPEXTPRM(___SET_NARGS(-1),___ps->temp1)

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(8)
    *
    * This is the keyword parameter handler.  It is invoked when keyword
    * parameters must be processed.
    */

   int np;
   int na;
   int nb_req_opt;
   int nb_key;
   int i;
   int j;
   int k;
   int fnk;
   ___SCMOBJ key_descr;
   ___SCMOBJ key_vals[___MAX_NB_PARMS];

   np = ___PRD_NBPARMS(___HEADER(___ps->temp1));
   na = ___ps->na;
   key_descr = ___ps->temp3;
   nb_req_opt = ___ps->temp2;
   nb_key = np - nb_req_opt;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   k = na - nb_req_opt; /* k = number of arguments that are */
                        /* non-required and non-optional */

   if (k < 0) /* not all required and optional arguments supplied? */
     {
       ___COVER_KEYWORD_PARAM_HANDLER_WRONG_NARGS1;

       wrong_nb_args1:

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))
     }

   /* find first non-keyword pair in remaining arguments */

   for (fnk=k-1; fnk>0; fnk-=2)
     if (!___KEYWORDP(___STK(-fnk)))
       break;

   fnk++;

   /* assign values to keyword parameters from last to first */

   for (j=nb_key-1; j>=0; j--)
     key_vals[j] = ___FIELD(key_descr,j*2+1);

   for (i=fnk+1; i<=k; i+=2)
     {
       ___SCMOBJ key = ___STK(-i);

       for (j=nb_key-1; j>=0; j--)
         if (key == ___FIELD(key_descr,j*2))
           {
             ___COVER_KEYWORD_PARAM_HANDLER_FOUND;
             key_vals[j] = ___STK(-i+1);
             goto continue1;
           }

       /* the keyword was not found in the keyword parameter descriptor */

       ___COVER_KEYWORD_PARAM_HANDLER_NOT_FOUND;

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary.prm))

       continue1:;
     }

   if (k & 1) /* keyword arguments must come in pairs */
     {
       ___COVER_KEYWORD_PARAM_HANDLER_WRONG_NARGS2;

       goto wrong_nb_args1;
     }

   if (fnk != 0)
     {
       ___COVER_KEYWORD_PARAM_HANDLER_KEYWORD_EXPECTED;

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary.prm))
     }

   ___ADJFP(-k) /* remove keyword arguments */

   for (i=0; i<nb_key; i++) /* push value of all keyword params */
     ___PUSH(key_vals[i])

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___COVER_KEYWORD_PARAM_HANDLER_END;

   ___JUMPEXTPRM(___SET_NARGS(-1),___ps->temp1)

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(9)
    *
    * This is the keyword and rest parameter handler.  It is invoked when
    * keyword parameters must be processed and a rest parameter must be
    * constructed.
    *
    * After ___PUSH_ARGS_IN_REGS(na) is executed the stack contains
    * all the arguments of the procedure call:
    *
    *              STACK
    *          |            |
    *          +------------+
    *  ___fp ->|   arg_na   |
    *          |    ...     |
    *          |   arg_3    |
    *          |   arg_2    |
    *          |   arg_1    |
    *          +------------+
    *          |    ...     |
    *
    * These arguments will be kept in this location during argument
    * processing.  If the argument processing does not encounter an
    * exceptional situation, the arguments will be overwritten with
    * the formal parameters and the body of the procedure will be
    * jumped to.  If a heap overflow is detected during the
    * construction of the rest parameter, then the construction of the
    * rest parameter is completed and all the parameters including the
    * keyword parameters are copied to a vector and the procedure
    * ##rest-param-check-heap will be called to trigger a garbage
    * collection.  Then the procedure will be returned to with the
    * processed arguments.
    */

   int np;          /* number of formal parameters */
   int na;          /* number of arguments of the call */
   int nb_req_opt;  /* number of required or optional parameters */
   int nb_key;      /* number of keyword parameters */
   int i;
   int j;
   int k;
   int fnk;
   ___SCMOBJ key_descr;
   ___SCMOBJ key_vals[___MAX_NB_PARMS];
   ___SCMOBJ rest_param_list;

   np = ___PRD_NBPARMS(___HEADER(___ps->temp1));
   na = ___ps->na;
   key_descr = ___ps->temp3;
   nb_req_opt = ___ps->temp2;
   nb_key = (np-1) - nb_req_opt;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   k = na - nb_req_opt; /* k = number of arguments that are */
                        /* non-required and non-optional */

   if (k < 0) /* not all required and optional arguments supplied? */
     {
       ___COVER_KEYWORD_REST_PARAM_HANDLER_WRONG_NARGS1;

       wrong_nb_args2:

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))
     }

   /* find first non-keyword pair in remaining arguments */

   for (fnk=k-1; fnk>0; fnk-=2)
     if (!___KEYWORDP(___STK(-fnk)))
       break;

   fnk++;

   /* assign values to keyword parameters from last to first */

   for (j=nb_key-1; j>=0; j--)
     key_vals[j] = ___FIELD(key_descr,j*2+1);

   for (i=fnk+1; i<=k; i+=2)
     {
       ___SCMOBJ key = ___STK(-i);

       for (j=nb_key-1; j>=0; j--)
         if (key == ___FIELD(key_descr,j*2))
           {
             ___COVER_KEYWORD_REST_PARAM_HANDLER_FOUND;
             key_vals[j] = ___STK(-i+1);
             goto continue2;
           }

       /* the keyword was not found in the keyword parameter descriptor */

       if (!___ps->temp4) /* not DSSSL style rest parameter? */
         {
           ___COVER_KEYWORD_REST_PARAM_HANDLER_NOT_FOUND;

           ___PUSH(___FIX(0)) /* make space for operator */

           for (i=0; i<na; i++)
             ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

           ___SET_STK(-na,___ps->temp1) /* set operator argument */

           ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

           ___JUMPPRM(___SET_NARGS(na+1),
                      ___PRMCELL(___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary.prm))
         }

       continue2:;
     }

   if (!___ps->temp4) /* not DSSSL style rest parameter? */
     i = fnk;
   else
     {
#ifdef ___REJECT_ILLEGAL_DSSSL_PARAMETER_LIST

       if (k & 1) /* keyword arguments must come in pairs */
         {
           ___COVER_KEYWORD_REST_PARAM_HANDLER_WRONG_NARGS2;

           goto wrong_nb_args2;
         }

       if (fnk != 0)
         {
           ___COVER_KEYWORD_REST_PARAM_HANDLER_KEYWORD_EXPECTED;

           ___PUSH(___FIX(0)) /* make space for operator */

           for (i=0; i<na; i++)
             ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

           ___SET_STK(-na,___ps->temp1) /* set operator argument */

           ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

           ___JUMPPRM(___SET_NARGS(na+1),
                      ___PRMCELL(___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary.prm))
         }

#endif

       i = k;
     }

   j = k - i;

   /*
    * here,
    *  i = number of arguments to move to the rest parameter
    *  j = number of non-required and non-optional arguments
    *      that are left after the rest parameter is created.
    */

   rest_param_list = ___NUL;

   while (i > 0)
     {
       rest_param_list = ___CONS(___POP,rest_param_list);
       i--;

       if (___hp > ___ps->heap_limit)
         {
            ___BOOL need_to_gc;

            ___COVER_KEYWORD_REST_PARAM_HANDLER_HEAP_LIMIT;

            ___W_ALL
            need_to_gc = ___heap_limit (___PSPNC);
            ___R_ALL

            if (need_to_gc)
              {
                /*
                 * We need to garbage collect, but before we do we have
                 * to remove all arguments from the stack so that the GC
                 * only sees complete continuation frames on the stack.
                 * The arguments are stored in a heap allocated vector.
                 */

                ___COVER_KEYWORD_REST_PARAM_HANDLER_NEED_TO_GC;

                /* Finish creating the rest parameter. */

                while (i > 0)
                  {
                    rest_param_list = ___CONS(___POP,rest_param_list);
                    i--;
                  }

                ___ADJFP(-j)

                for (i=0; i<nb_key; i++) /*push value of all keyword params*/
                  ___PUSH(key_vals[i])

                ___BEGIN_ALLOC_VECTOR(np)
                i = np - 1;
                ___ADD_VECTOR_ELEM(i,rest_param_list)
                while (i > 0)
                  {
                    i--;
                    ___ADD_VECTOR_ELEM(i,___POP)
                  }
                ___END_ALLOC_VECTOR(np)

                ___PUSH_ARGS2(___ps->temp1,___GET_VECTOR(np))

                ___JUMPPRM(___SET_NARGS(2),
                           ___PRMCELL(___G__23__23_rest_2d_param_2d_check_2d_heap.prm))
              }
          }
     }

   ___ADJFP(-j)

   ___COVER_KEYWORD_REST_PARAM_HANDLER_NO_NEED_TO_GC;

   for (i=0; i<nb_key; i++) /* push value of all keyword params */
     ___PUSH(key_vals[i])

   ___PUSH(rest_param_list) /* rest parameter is last */

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___JUMPEXTPRM(___SET_NARGS(-1),___ps->temp1)

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(10)
    *
    * This is the force handler.  It is invoked when a promise is forced.
    */

   ___SCMOBJ ra;
   ___SCMOBJ promise;
   ___SCMOBJ result;

   ra = ___ps->temp1;
   promise = ___ps->temp2;
   result = ___FIELD(promise,___PROMISE_RESULT);

   if (promise != result)
     {
       /* promise is determined, return cached result */

       ___COVER_FORCE_HANDLER_DETERMINED;

       ___ps->temp2 = result;
       ___JUMPEXTPRM(___NOTHING,ra)
     }
   else
     {
       /* promise is not determined */

       /* setup internal return continuation frame */

       int fs;

       ___RETI_GET_CFS(ra,fs)

       ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

       ___PUSH_REGS /* push all GVM registers (live or not) */
       ___PUSH(ra)  /* push return address */

       ___ADJFP(-___RETI_RA)

       ___SET_R0(___GSTATE->internal_return)

       /* tail call to ##force-undetermined */

       ___PUSH_ARGS2(promise,___FIELD(promise,___PROMISE_THUNK))

       ___COVER_FORCE_HANDLER_NOT_DETERMINED;

       ___JUMPPRM(___SET_NARGS(2),
                  ___PRMCELL(___G__23__23_force_2d_undetermined.prm))
     }

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (let ((stack-marker (##first-argument 0)))
    (##c-code #<<end-of-code

     /*
      * ___LBL(11)
      *
      * This is the return to C handler.  It is invoked when control
      * must return to C (i.e. back from the call to ___call).
      *
      * Note that the continuation frame is not removed from the stack (it
      * contains the stack marker which is needed by ___call).
      */

     ___SCMOBJ unwind_destination = ___STK(2-___FRAME_SPACE(2));

     if (!___FALSEP(___FIELD(unwind_destination,0))) /* first return? */
       {
         ___COVER_RETURN_TO_C_HANDLER_FIRST_RETURN;
         ___FRAME_STORE_RA(___GSTATE->handler_return_to_c)
         ___W_ALL
         ___throw_error (___PSP ___FIX(___UNWIND_C_STACK));  /* jump back inside ___call */
       }
     else
       {
         ___COVER_RETURN_TO_C_HANDLER_MULTIPLE_RETURN;
         ___SET_R0(___GSTATE->handler_return_to_c)
         ___JUMPPRM(___SET_NARGS(0),
                    ___PRMCELL(___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception.prm))
       }

end-of-code

     (let () (##declare (not warnings)) (0))) ; create a return point with a
                                              ; frame having the same format as
                                              ; the one created by ___call
    (##first-argument stack-marker))

  (##c-code #<<end-of-code

   /*
    * ___LBL(12)
    *
    * This is the break handler.  It is invoked when a procedure
    * attempts to return to its caller and the caller's stack frame
    * is not on top of the stack because it has been captured.
    *
    * At this point the callee will have cleaned up the stack so that the
    * frame pointer (___fp) points to the break frame.  The break frame
    * contains a pointer to the caller's continuation frame, which
    * contains the address in the caller where control will return (the
    * return address ret_adr1).  The caller's continuation frame can either
    * be in the stack or in the heap.  The two situations are depicted below:
    *
    *              STACK                      STACK              HEAP
    *          |            |             |            |               caller's
    *          +------------+             +------------+    +------------+frame
    *  ___fp ->| call frame ---+  ___fp ->| call frame ---->|    HEAD    |
    *          |<ALIGN PAD> |  |          |<ALIGN PAD> |    |  ret_adr1  |
    *          +------------+  |          +------------+    |  slot fs   |
    *          |     .      |  |          |     .      |    |    ...     |
    *          |     .      |  |          |     .      |    | slot link ----+
    *          |     .      |  |          |     .      |    |    ...     |  |
    *          |     .      |  |          |     .      |    |  slot 1    |  |
    *          +------------+  |          |            |    +------------+  |
    *          |  ret_adr1  |<-+          |            |                    |
    *          |  RESERVED  |             |            |                    |
    * caller's |  slot fs   |             |            |                    |
    * frame    |    ...     |             |            |                    |
    *          |  ret_adr2  |             |            |                    |
    *          |    ...     |             |            |                    |
    *          |  slot 1    |             |     .      |    +------------+  |
    *          +------------+             |     .      |    |    HEAD    |<-+
    *          |  RESERVED  |             |     .      |    |  ret_adr2  |
    *          |    ...     |             |     .      |    |    ...    ----+
    *          +------------+             +------------+    +------------+  V
    *                                                                      ...
    *
    * These cases are distinguished by the tag on the pointer to the
    * caller's frame (i.e. 'call frame').
    *
    * The break handler puts a copy of the caller's frame on the top of
    * the stack except that the slot 'link' is set to the address of the
    * break handler.  The frame pointer in the break frame is modified
    * so that it points to the frame of the caller's caller.  Finally a
    * jump to the return address in the caller's frame (ret_adr1) is
    * performed.  At that point the stack will be in the following state
    * respectively:
    *
    *              STACK                      STACK              HEAP
    *          |            |             |            |
    *          +------------+             +------------+
    *  ___fp ->|  RESERVED  |     ___fp ->|  RESERVED  | ^
    *          |  slot fs   |             |  slot fs   | |
    *          |    ...     |             |    ...     | | ADDED BY BREAK
    *          | break hdlr |             | break hdlr | | HANDLER
    *          |    ...     |             |    ...     | |
    *          |  slot 1    |             |  slot 1    | v
    *          +------------+             +------------+
    *          |new call fr.---+          |new call fr.--+  +------------+
    *          |<ALIGN PAD> |  |          |<ALIGN PAD> | |  |    HEAD    |
    *          +------------+  |          +------------+ |  |  ret_adr1  |
    *          |     .      |  |          |     .      | |  |  slot fs   |
    *          |     .      |  |          |     .      | |  |    ...     |
    *          |     .      |  |          |     .      | |  | slot link ----+
    *          |     .      |  |          |     .      | |  |    ...     |  |
    *          +------------+  |          |            | |  |  slot 1    |  |
    *          |  ret_adr1  |  |          |            | |  +------------+  |
    *          |  RESERVED  |  |          |            | |                  |
    *          |  slot fs   |  |          |            | |                  |
    *          |    ...     |  |          |            | |                  |
    *          |  ret_adr2  |  |          |            | |                  |
    *          |    ...     |  |          |            | |                  |
    *          |  slot 1    |  |          |     .      | |  +------------+  |
    *          +------------+  |          |     .      | +->|    HEAD    |<-+
    *          |  ret_adr2  |<-+          |     .      |    |  ret_adr2  |
    *          |    ...     | (see note)  |     .      |    |    ...    ----+
    *          +------------+             +------------+    +------------+  V
    *                                                                      ...
    *
    * Note that in the first case, the pointer to the caller's frame is
    * normally advanced to the frame following the caller's frame and the
    * return address ret_adr2 is saved in it.  However, if the frame
    * following the caller's frame is a break frame, then the content of
    * that break frame is copied to the topmost break frame.  This
    * ensures that break frames never contain pointers to other break
    * frames which is needed to properly implement tail-calls.
    */

   int fs;
   int link;
   int i;
   ___SCMOBJ *fp;
   ___SCMOBJ ra1;
   ___SCMOBJ ra2;
   ___SCMOBJ cf;

   cf = ___STK(-___BREAK_FRAME_NEXT); /* pointer to caller's frame */

   if (___TYP(cf) != ___tSUBTYPED)
     {
       /* caller's frame is in the stack */

       /* cf can't be equal to the end of continuation marker */

       fp = ___CAST(___SCMOBJ*,cf);

       ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

       if (ra1 == ___GSTATE->internal_return)
         {
           ___SCMOBJ actual_ra = ___FP_STK(fp,___RETI_RA);
           ___RETI_GET_FS_LINK(actual_ra,fs,link)
           ___COVER_BREAK_HANDLER_STACK_RETI;
         }
       else
         {
           ___RETN_GET_FS_LINK(ra1,fs,link)
           ___COVER_BREAK_HANDLER_STACK_RETN;
         }

       ___FP_ADJFP(fp,-___FRAME_SPACE(fs)); /* get base of frame */

       for (i=fs; i>0; i--)
         ___SET_STK(i,___FP_STK(fp,i))

       ra2 = ___STK(link+1);

       if (ra2 == ___GSTATE->handler_break)
         {
           /* first frame of that section */

           ___COVER_BREAK_HANDLER_STACK_FIRST_FRAME;
           ___SET_STK(-___BREAK_FRAME_NEXT,
                      ___FP_STK(fp,-___BREAK_FRAME_NEXT))
         }
       else
         {
           /* not the first frame of that section */

           ___COVER_BREAK_HANDLER_STACK_NOT_FIRST_FRAME;

           ___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)
           ___SET_STK(-___BREAK_FRAME_NEXT,___CAST(___SCMOBJ,fp))
           ___SET_STK(link+1,___GSTATE->handler_break)
         }
     }
   else
     {
       /* caller's frame is in the heap */

       fp = ___BODY_AS(cf,___tSUBTYPED); /* get pointer to frame's body */

       ra1 = fp[___FRAME_RA];

       if (ra1 == ___GSTATE->internal_return)
         {
           ___SCMOBJ actual_ra = fp[___FRAME_RETI_RA];
           ___RETI_GET_FS_LINK(actual_ra,fs,link)
           ___COVER_BREAK_HANDLER_HEAP_RETI;
         }
       else
         {
           ___RETN_GET_FS_LINK(ra1,fs,link)
           ___COVER_BREAK_HANDLER_HEAP_RETN;
         }

       fp += fs+1; /* get base of frame */

       for (i=fs; i>0; i--)
         ___SET_STK(i,___FP_STK(fp,i))

       ___SET_STK(-___BREAK_FRAME_NEXT,___STK(link+1))
       ___SET_STK(link+1,___GSTATE->handler_break)
     }

   ___ADJFP(___FRAME_SPACE(fs))

   ___JUMPEXTPRM(___NOTHING,ra1)

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point

  (##c-code #<<end-of-code

   /*
    * ___LBL(13)
    *
    * This is the internal return handler.  It is invoked when an
    * internal return point is returned to.
    *
    * Internal return points are used by the compiler when some routine
    * (e.g.  garbage collector) has to be called but it would be space
    * inefficient to generate the code to construct a normal continuation
    * frame (all the live GVM registers would have to be pushed on the
    * stack).  With internal return points it is not necessary for the
    * caller to save the live GVM registers before the routine is called,
    * and restore the GVM registers when the routine returns.  Instead it
    * is the called routine which saves and restores all the registers.
    *
    * The continuation frame for an internal return point has this layout:
    *
    *              STACK
    *          |            |
    *          +------------+
    *  ___fp ->|  RESERVED  | ^ <-- added to make stack and heap length equal
    *          |<ALIGN PAD> | | <-- words added for alignment of frame
    *          |  ret_adr   | | <-- internal return address (back to caller)
    *          | GVM reg N  | | ADDED BY ROUTINE
    *          |    ...     | |
    *          | GVM reg 0  | |
    *          |<ALIGN PAD> | v <-- to force known offset from ___fp to ret_adr
    *          |  slot fs   | ^
    *          |    ...     | | PUT ON STACK BY CALLER OF ROUTINE
    *          |  slot 1    | v
    *          +------------+
    *          |    ...     |
    */

   int fs;
   ___SCMOBJ ira;

   /* save result in case we are returning from ##force-undetermined */

   ___ps->temp2 = ___R1;

   /* make ___fp point to internal return address */

   ___ADJFP(___RETI_RA)

   /* pop return address and all GVM registers */

   ira = ___POP;
   ___POP_REGS

   /* get number of slots put on stack by caller */

   ___RETI_GET_CFS(ira,fs)

   /* adjust ___fp so that slot fs is on top of stack */

   ___ADJFP(fs-___ROUND_TO_MULT(fs,___FRAME_ALIGN))

   /* jump to internal return point */

   ___COVER_INTERNAL_RETURN_HANDLER_END;

   ___JUMPEXTPRM(___NOTHING,ira)

end-of-code

   (let () (##declare (not warnings)) (0))) ; create a return point
)

;;;----------------------------------------------------------------------------

(define-prim (##dynamic-env-bind denv thunk)
  (##declare (not interrupts-enabled))
  (let* ((current-thread
          (macro-current-thread))
         (old-denv
          (macro-thread-denv current-thread)))
    (macro-thread-denv-set! current-thread denv)
    (let ((x (macro-env-param-val (macro-denv-local denv))))
      (macro-thread-denv-cache1-set! current-thread x)
      (macro-thread-denv-cache2-set! current-thread x)
      (macro-thread-denv-cache3-set! current-thread x)
      (let* ((results ; may get bound to a multiple-values object
              (thunk))
             (current-thread
              (macro-current-thread)))
        (macro-thread-denv-set! current-thread old-denv)
        (let ((x (macro-env-param-val (macro-denv-local old-denv))))
          (macro-thread-denv-cache1-set! current-thread x)
          (macro-thread-denv-cache2-set! current-thread x)
          (macro-thread-denv-cache3-set! current-thread x)
          results)))))

))

;;;----------------------------------------------------------------------------

;;; List utilities.

(define-prim (##assq-cdr obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (let ((couple (##car x)))
        (if (##eq? obj (##cdr couple))
          couple
          (loop (##cdr x))))
        #f)))

(define-prim (##assq obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (let ((couple (##car x)))
        (if (##eq? obj (##car couple))
          couple
          (loop (##cdr x))))
        #f)))

;;;----------------------------------------------------------------------------

;;; Interrupt system.

(macro-case-target

 ((C)

(define-prim (##disable-interrupts!)
  (##declare (not interrupts-enabled))
  (##c-code "___EXT(___disable_interrupts_pstate) (___ps); ___RESULT = ___VOID;"))

(define-prim (##enable-interrupts!)
  (##declare (not interrupts-enabled))
  (##c-code "___EXT(___enable_interrupts_pstate) (___ps); ___RESULT = ___VOID;"))

(define-prim (##sync-op-interrupt!)

  (##declare (not interrupts-enabled))

  (##c-code #<<end-of-code

   ___FRAME_STORE_RA(___R0)
   ___W_ALL

   service_sync_op (___PSPNC);

   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

   ___RESULT = ___VOID;

end-of-code
))

(define ##interrupt-vector
  (##vector ##sync-op-interrupt! #f #f #f #f #f #f #f))

(define-prim (##interrupt-handler)

  (##declare (not interrupts-enabled))

  (let loop ()
    (let ((id
           (##c-code #<<end-of-code

            ___RESULT = ___FAL;

            ___EXT(___begin_interrupt_service_pstate) (___ps);

            if (___ps->intr_enabled != ___FIX(0))
              {
                int i;

                for (i=0; i<___NB_INTRS; i++)
                  if (___EXT(___check_interrupt_pstate) (___ps, i))
                    break;

                ___EXT(___end_interrupt_service_pstate) (___ps, i+1);

                if (i < ___NB_INTRS)
                  ___RESULT = ___FIX(i);
              }
            else
              ___EXT(___end_interrupt_service_pstate) (___ps, 0);

end-of-code
)))

      (if id
          (let ((handler
                 (or (##vector-ref ##interrupt-vector id)
                     (lambda () (##void)))))

            ;; As an optimization, tail-call the handler when there
            ;; are no other interrupts pending.

            (if (##c-code "___RESULT = ___BOOLEAN(___STACK_TRIPPED);")
                (begin
                  (handler)
                  (loop))
                (handler)))))))

(define-prim (##interrupt-vector-set! code handler)
  (##declare (not interrupts-enabled))
  (##vector-set! ##interrupt-vector code handler))

;;;----------------------------------------------------------------------------

;; (##heartbeat-interval-set! seconds) sets the heartbeat interrupt
;; interval to the time closest to "seconds" seconds (a flonum value).
;; If "seconds" is negative, the heartbeat interrupt is turned off.  If
;; "seconds" is zero, the smallest possible interval is used.  The
;; actual interval in seconds is returned.

(define-prim (##heartbeat-interval-set! seconds)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___FLONUM_VAL(___ARG2) = ___set_heartbeat_interval (___FLONUM_VAL(___ARG1));
   ___RESULT = ___ARG2;

end-of-code

   seconds
   (let ()
     (##declare (not constant-fold)) ;; force allocation of a flonum
     (##fixnum->flonum 0))))

;;;----------------------------------------------------------------------------

;; The high-level interrupt is used for interprocessor interruption
;; initiated at the Scheme level.

(define-prim (##raise-high-level-interrupt! processor-id)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   {
     ___processor_state ps =
       ___PSTATE_FROM_PROCESSOR_ID(___INT(___ARG1),
                                   ___VMSTATE_FROM_PSTATE(___ps));

     ___raise_interrupt_pstate (ps, ___INTR_HIGH_LEVEL);

     ___RESULT = ___VOID;
   }

end-of-code

   processor-id))

))

;;;----------------------------------------------------------------------------

;; Argument list transformation used when some exceptions are raised.

(define-prim (##argument-list-remove-absent! lst tail)
  (let loop ((lst1 tail)
             (lst2 #f)
             (lst3 lst))
    (if (##pair? lst3)
      (let ((val (##car lst3)))
        (if (##eq? val (macro-absent-obj))
          (loop lst1
                lst2
                (##cdr lst3))
          (loop (if lst2
                  (begin
                    (##set-cdr! lst2 lst3)
                    lst1)
                  lst3)
                lst3
                (##cdr lst3))))
      (begin
        (if lst2
          (##set-cdr! lst2 tail))
        lst1))))

(define-prim (##argument-list-remove-absent-keys! lst)
  (let loop ((lst1 #f)
             (lst2 #f)
             (lst3 lst))
    (if (and (##pair? lst3) (##keyword? (##car lst3)))
      (let ((val (##cadr lst3)))
        (if (##eq? val (macro-absent-obj))
          (loop lst1
                lst2
                (##cddr lst3))
          (loop (if lst2
                  (begin
                    (##set-cdr! lst2 lst3)
                    lst1)
                  lst3)
                (##cdr lst3)
                (##cddr lst3))))
      (let ((tail (if (##pair? lst3) (##car lst3) '())))
        (if lst2
          (begin
            (##set-cdr! lst2 tail)
            lst1)
          tail)))))

(define-prim (##argument-list-fix-rest-param! lst)
  (let loop ((curr #f) (next lst))
    (let ((tail (##cdr next)))
      (if (##pair? tail)
        (loop next tail)
        (if curr
          (begin
            (##set-cdr! curr (##car next))
            lst)
          (##car next))))))

(define-prim (##extract-procedure-and-arguments proc args val1 val2 val3 cont)
  (cond ((##null? proc)
         (cont (##car args)
               (##argument-list-remove-absent!
                (##argument-list-fix-rest-param! (##cdr args))
                '())
               val1
               val2
               val3))
        ((##pair? proc)
         (cont (##car proc)
               (##argument-list-remove-absent!
                args
                (##argument-list-remove-absent-keys! (##cdr proc)))
               val1
               val2
               val3))
        (else
         (cont proc
               (##argument-list-remove-absent! args '())
               val1
               val2
               val3))))

;;;----------------------------------------------------------------------------

;;; Implementation of exceptions.

(implement-library-type-type-exception)

(define-prim (##raise-type-exception arg-num type-id proc args)
  (##extract-procedure-and-arguments
   proc
   args
   arg-num
   type-id
   #f
   (lambda (procedure arguments arg-num type-id dummy)
     (macro-raise
      (macro-make-type-exception procedure arguments arg-num type-id)))))

(macro-case-target

 ((C)

(implement-library-type-heap-overflow-exception)

(define-prim (##raise-heap-overflow-exception)
  (##declare (not interrupts-enabled))
  (##with-no-result-expected
   (lambda ()
     (macro-raise
      (macro-make-constant-heap-overflow-exception)))))

(implement-library-type-stack-overflow-exception)

(define-prim (##raise-stack-overflow-exception)
  (##declare (not interrupts-enabled))
  (##with-no-result-expected
   (lambda ()
     (macro-raise
      (macro-make-constant-stack-overflow-exception)))))
))

(macro-case-target

 ((C js python)

(implement-library-type-nonprocedure-operator-exception)

(define-prim (##apply-global-with-procedure-check-nary gv . args)
  (##declare (not interrupts-enabled))
  (##apply-with-procedure-check (##global-var-ref gv) args))

(define-prim (##apply-with-procedure-check-nary oper . args)
  (##declare (not interrupts-enabled))
  (##apply-with-procedure-check oper args))

(define-prim (##apply-with-procedure-check oper args)
  (##declare (not interrupts-enabled))
  (macro-force-vars (oper)
    (if (##procedure? oper)
      (##apply oper args)
      (##raise-nonprocedure-operator-exception oper args #f #f))))

(define-prim (##raise-nonprocedure-operator-exception oper args code rte)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-nonprocedure-operator-exception oper args code rte)))

(implement-library-type-wrong-number-of-arguments-exception)

(define-prim (##raise-wrong-number-of-arguments-exception-nary proc . args)
  (##declare (not interrupts-enabled))
  (##raise-wrong-number-of-arguments-exception proc args))

(define-prim (##raise-wrong-number-of-arguments-exception proc args)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-wrong-number-of-arguments-exception proc args)))

(implement-library-type-keyword-expected-exception)

(define-prim (##raise-keyword-expected-exception-nary proc . args)
  (##declare (not interrupts-enabled))
  (##raise-keyword-expected-exception proc args))

(define-prim (##raise-keyword-expected-exception proc args)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-keyword-expected-exception proc args)))

(implement-library-type-unknown-keyword-argument-exception)

(define-prim (##raise-unknown-keyword-argument-exception-nary proc . args)
  (##declare (not interrupts-enabled))
  (##raise-unknown-keyword-argument-exception proc args))

(define-prim (##raise-unknown-keyword-argument-exception proc args)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-unknown-keyword-argument-exception proc args)))

(implement-library-type-os-exception)

(define-prim (##raise-os-exception message code proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   message
   code
   #f
   (lambda (procedure arguments message code dummy)
     (macro-raise
      (if (##fx= code ##err-code-ENOENT)
        (macro-make-no-such-file-or-directory-exception procedure arguments)
        (macro-make-os-exception procedure arguments message code))))))

(implement-library-type-no-such-file-or-directory-exception)

(define-prim (##raise-no-such-file-or-directory-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-no-such-file-or-directory-exception
       procedure
       arguments)))))
))

(macro-case-target

 ((C)

(implement-library-type-cfun-conversion-exception)

(define-prim (##raise-cfun-conversion-exception-nary code message proc . args)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-cfun-conversion-exception proc args code message)))

(implement-library-type-sfun-conversion-exception)

(define-prim (##raise-sfun-conversion-exception code message proc)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-sfun-conversion-exception proc '() code message)))

(implement-library-type-multiple-c-return-exception)

(define-prim (##raise-multiple-c-return-exception)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-constant-multiple-c-return-exception)))

(implement-library-type-number-of-arguments-limit-exception)

(define-prim (##raise-number-of-arguments-limit-exception proc args)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-number-of-arguments-limit-exception proc args)))

;;; Implementation of promises.

(define-prim (##make-promise thunk))
(define-prim (##promise-thunk promise))
(define-prim (##promise-thunk-set! promise thunk))
(define-prim (##promise-result promise))
(define-prim (##promise-result-set! promise result))

(define-prim (##force-undetermined promise thunk)
  (let ((result (##force (thunk))))
    (##c-code #<<end-of-code

     if (___PROMISERESULT(___ARG1) == ___ARG1)
       {
         ___PROMISERESULTSET(___ARG1,___ARG2)
         ___PROMISETHUNKSET(___ARG1,___FAL)
       }
     ___RESULT = ___PROMISERESULT(___ARG1);

end-of-code

     promise
     result)))

))

;;;----------------------------------------------------------------------------

;;; Jobs.

(define-prim (##make-jobs)
  (macro-make-fifo))

(define-prim (##add-job-at-tail! jobs job)
  (macro-fifo-insert-at-tail! jobs job))

(define-prim (##add-job! jobs job)
  (macro-fifo-insert-at-head! jobs job))

(define-prim (##execute-jobs! jobs)
  (let loop ((lst (macro-fifo->list jobs)))
    (if (##pair? lst)
      (begin
        ((##car lst))
        (loop (##cdr lst))))))

(define-prim (##execute-and-clear-jobs! jobs)
  (let loop ((lst (macro-fifo-remove-all! jobs)))
    (if (##pair? lst)
      (begin
        ((##car lst))
        (loop (##cdr lst))))))

(define-prim (##clear-jobs! jobs)
  (macro-fifo-remove-all! jobs)
  (##void))

;;;----------------------------------------------------------------------------

;;; Garbage collection.

(macro-case-target

 ((C)

(define-prim (##check-heap-limit)
  (##declare (not interrupts-enabled))
  (##check-heap-limit))

(define-prim (##check-heap)
  (##declare (not interrupts-enabled))
  (let ((result
         (##c-code #<<end-of-code

          if (___hp > ___ps->heap_limit)
            {
              ___BOOL overflow;
              ___FRAME_STORE_RA(___R0)
              ___W_ALL
              overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
              ___R_ALL
              ___SET_R0(___FRAME_FETCH_RA)
              if (overflow)
                ___RESULT = ___TRU;
              else
                ___RESULT = ___FAL;
            }
          else
            ___RESULT = ___FAL;

end-of-code
)))
    (if result
      (begin
        (##raise-heap-overflow-exception)
        (##check-heap)))))

(define-prim (##rest-param-check-heap proc args)
  (##declare (not interrupts-enabled))
  (let ((overflow (##gc-without-exceptions)))
    (if overflow
      (begin
        (##raise-heap-overflow-exception)
        (##rest-param-check-heap proc args))
      (##rest-param-resume-procedure proc args))))

(define-prim (##rest-param-heap-overflow proc args)
  (##raise-heap-overflow-exception)
  (##apply proc args))

(define-prim (##rest-param-resume-procedure proc args)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ proc;
   ___SCMOBJ args;
   int np;
   int i;

   ___POP_ARGS2(proc,args)

   np = ___INT(___VECTORLENGTH(args));

   for (i=0; i<np; i++)
     ___PUSH(___FIELD(args,i))

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___COVER_REST_PARAM_RESUME_PROCEDURE;

   ___JUMPEXTPRM(___SET_NARGS(-1),proc)

   ___RESULT = ___FAL; /* avoid a warning that ___RESULT is not set */

end-of-code
))

(define-prim (##gc-without-exceptions)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___BOOL overflow;

   ___FRAME_STORE_RA(___R0)
   ___W_ALL
   overflow = ___garbage_collect (___PSP 0);
   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

   ___RESULT = ___BOOLEAN(overflow);

   ___COVER_GC_WITHOUT_EXCEPTIONS;

end-of-code
))

(define-prim (##gc)
  (let ((result
         (##c-code #<<end-of-code

          ___BOOL overflow;
          ___FRAME_STORE_RA(___R0)
          ___W_ALL
          overflow = ___garbage_collect (___PSP 0);
          ___R_ALL
          ___SET_R0(___FRAME_FETCH_RA)
          ___RESULT = ___BOOLEAN(overflow);

end-of-code
)))
    (if result
      (begin
        (##raise-heap-overflow-exception)
        (##gc))
      (##void))))

(define ##gc-interrupt-jobs (##make-jobs))

;; (##add-gc-interrupt-job! thunk) can be called to add another job to
;; do after a GC.  (##clear-gc-interrupt-jobs!) clears the jobs.

(define-prim (##add-gc-interrupt-job! thunk)
  (##add-job! ##gc-interrupt-jobs thunk))

(define-prim (##clear-gc-interrupt-jobs!)
  (##clear-jobs! ##gc-interrupt-jobs))

(define-prim (##gc-finalize!)
  (##declare (not interrupts-enabled))
  (let ((will
         (##c-code #<<end-of-code

          ___SCMOBJ will = ___ps->mem.executable_wills_;
          if (___UNTAG(will) == 0) /* end of list? */
            ___RESULT = ___FAL;
          else
            {
              ___ps->mem.executable_wills_ = ___BODY(will)[0];
              ___RESULT = will;
            }

end-of-code
)))
    (if will
      (begin
        (macro-will-execute! will)
        (##gc-finalize!))
      (##gc-final-will-registry!))))

(define ##final-will-registry (macro-make-fifo))

(define-prim (##execute-final-wills!)
  (##declare (not interrupts-enabled))
  (let ((registry ##final-will-registry))
    (let ((lst (macro-fifo-remove-all! registry)))
      (let loop ((x lst))
        (if (##not (##null? x))
          (begin
            (macro-will-execute! (##car x))
            (loop (##cdr x))))))))

(define-prim (##gc-final-will-registry!)
  (##declare (not interrupts-enabled))
  (let ((registry ##final-will-registry))
    (let loop ((curr registry)
               (next (macro-fifo-next registry)))
      (if (##null? next)
        (macro-fifo-tail-set! registry curr)
        (let* ((will (macro-fifo-elem next))
               (action (macro-will-action will)))
          (if action
            (begin
              (macro-fifo-next-set! curr next)
              (loop next
                    (macro-fifo-next next)))
            (loop curr
                  (macro-fifo-next next))))))))

(define-prim (##make-final-will testator action)
  (let* ((registry ##final-will-registry)
         (will (##make-will testator action)))
    (macro-fifo-insert-at-head! registry will)
    will))

(##interrupt-vector-set! 4 ;; ___INTR_GC
  (lambda ()
    (##declare (not interrupts-enabled))
    (##gc-finalize!)
    (##execute-jobs! ##gc-interrupt-jobs)))

;;;----------------------------------------------------------------------------

;;; Miscellaneous settings.

(define-prim (##get-min-heap)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_min_heap ());"))

(define-prim (##set-min-heap! bytes)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_min_heap (___INT(___ARG1)); ___RESULT = ___VOID;"
   bytes))

(define-prim (##get-max-heap)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_max_heap ());"))

(define-prim (##set-max-heap! bytes)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_max_heap (___INT(___ARG1)); ___RESULT = ___VOID;"
   bytes))

(define-prim (##get-live-percent)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_live_percent ());"))

(define-prim (##set-live-percent! percent)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_live_percent (___INT(___ARG1)); ___RESULT = ___VOID;"
   percent))

(define-prim (##get-parallelism-level)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_parallelism_level ());"))

(define-prim (##set-parallelism-level! level)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_parallelism_level (___INT(___ARG1)); ___RESULT = ___VOID;"
   level))

(define-prim (##get-standard-level)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_standard_level ());"))

(define-prim (##set-standard-level! level)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_standard_level (___INT(___ARG1)); ___RESULT = ___VOID;"
   level))

(define-prim (##set-gambitdir! dir)
  (##declare (not interrupts-enabled))
  ((c-lambda (UCS-2-string) void
             "___addref_string (___arg1); ___set_gambitdir (___arg1);")
   dir))

(define-prim (##set-debug-settings! mask new-settings)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT =
      ___FIX(___set_debug_settings (___INT(___ARG1), ___INT(___ARG2)));"
   mask
   new-settings))

;;;----------------------------------------------------------------------------

;;; CPU information.

(define-prim (##cpu-count)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___FIX(___cpu_count ());"))

(define-prim (##cpu-cache-size
              #!optional
              (instruction-cache #f)
              (level 0))
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT =
       ___FIX(___cpu_cache_size (!___FALSEP(___ARG1), ___INT(___ARG2)));"
   instruction-cache
   level))

(define-prim (##core-count)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___FIX(___core_count ());"))

;;;----------------------------------------------------------------------------

;;; VM resizing.

(define ##current-vm-resize
  (c-lambda (scheme-object int)
            scheme-object
     #<<end-of-code

     ___return(___EXT(___current_vm_resize) (___PSP ___arg1, ___arg2));

end-of-code
))

(define ##current-vm-processor-count
  (c-lambda ()
            scheme-object
     #<<end-of-code

     ___return(___FIX(___VMSTATE_FROM_PSTATE(___ps)->processor_count));

end-of-code
))

;;;----------------------------------------------------------------------------

;;; Memory allocation.

(define-prim (##still-copy obj)
  (##declare (not interrupts-enabled))
  (let ((o (##c-code #<<end-of-code

___SCMOBJ result;
___WORD head = *___UNTAG(___ARG1);
___FRAME_STORE_RA(___R0)
___W_ALL
result = ___EXT(___alloc_scmobj) (___ps, ___HD_SUBTYPE(head), ___HD_BYTES(head));
___R_ALL
___SET_R0(___FRAME_FETCH_RA)
if (!___FIXNUMP(result))
  {
    ___SIZE_TS words = ___HD_WORDS(head);
    while (words > 0)
      {
        ___UNTAG(result)[words] = ___UNTAG(___ARG1)[words];
        words--;
      }
    ___still_obj_refcount_dec (result);
  }
___RESULT = result;

end-of-code

            obj)))
    (if (##fixnum? o)
      (begin
        (##raise-heap-overflow-exception)
        (##still-copy obj))
      o)))

(define-prim (##still-obj-refcount-inc! obj)
  (##declare (not interrupts-enabled))
  (##c-code "___still_obj_refcount_inc (___ARG1); ___RESULT = ___ARG1;" obj))

(define-prim (##still-obj-refcount-dec! obj)
  (##declare (not interrupts-enabled))
  (##c-code "___still_obj_refcount_dec (___ARG1); ___RESULT = ___ARG1;" obj))

(define-prim (##make-vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+___LWS)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = n + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sVECTOR, n<<___LWS);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_WORDS(n, ___sVECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result))
  {
    ___SCMOBJ fill = ___ARG2;
    if (fill == ___ABSENT)
      fill = ___FIX(0);
    for (i=0; i<n; i++)
      ___VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-vector k fill))
      v)))

(define-prim (##make-string k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((s (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+___LCS)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<___LCS)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sSTRING, n<<___LCS);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<___LCS), ___sSTRING);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___STRINGSET(result,___FIX(i),___ARG2);
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? s)
      (begin
        (##raise-heap-overflow-exception)
        (##make-string k fill))
      s)))

(define-prim (##make-s8vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>___LF))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS(n) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS8VECTOR, n);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES(n, ___sS8VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S8VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s8vector k fill))
      v)))

(define-prim (##make-u8vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>___LF))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS(n) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU8VECTOR, n);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES(n, ___sU8VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U8VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u8vector k fill))
      v)))

(define-prim (##make-s16vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+1)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<1)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS16VECTOR, n<<1);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<1), ___sS16VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S16VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s16vector k fill))
      v)))

(define-prim (##make-u16vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+1)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<1)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU16VECTOR, n<<1);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<1), ___sU16VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U16VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u16vector k fill))
      v)))

(define-prim (##make-s32vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+2)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<2)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS32VECTOR, n<<2);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<2), ___sS32VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S32VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s32vector k fill))
      v)))

(define-prim (##make-u32vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+2)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<2)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU32VECTOR, n<<2);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<2), ___sU32VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U32VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u32vector k fill))
      v)))

(define-prim (##make-s64vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
#if ___WS == 4
    ___SIZE_TS words = ___WORDS((n<<3)) + 2;
#else
    ___SIZE_TS words = ___WORDS((n<<3)) + 1;
#endif
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS64VECTOR, n<<3);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___WS == 4
            result = ___TAG(___CAST(___SCMOBJ*,___CAST(___SCMOBJ,___hp+2)&~7)-1,
                            ___tSUBTYPED);
#else
            result = ___TAG(___hp, ___tSUBTYPED);
#endif
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<3), ___sS64VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S64VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s64vector k fill))
      v)))

(define-prim (##make-u64vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
#if ___WS == 4
    ___SIZE_TS words = ___WORDS((n<<3)) + 2;
#else
    ___SIZE_TS words = ___WORDS((n<<3)) + 1;
#endif
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU64VECTOR, n<<3);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___WS == 4
            result = ___TAG(___CAST(___SCMOBJ*,___CAST(___SCMOBJ,___hp+2)&~7)-1,
                            ___tSUBTYPED);
#else
            result = ___TAG(___hp, ___tSUBTYPED);
#endif
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<3), ___sU64VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U64VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u64vector k fill))
      v)))

(define-prim (##make-f32vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+2)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<2)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sF32VECTOR, n<<2);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___TAG(___hp, ___tSUBTYPED);
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<2), ___sF32VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    ___F64 fill = ___F64UNBOX(___ARG2);
    for (i=0; i<n; i++)
      ___F32VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-f32vector k fill))
      v)))

(define-prim (##make-f64vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
#if ___WS == 4
    ___SIZE_TS words = ___WORDS((n<<3)) + 2;
#else
    ___SIZE_TS words = ___WORDS((n<<3)) + 1;
#endif
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sF64VECTOR, n<<3);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___WS == 4
            result = ___TAG(___CAST(___SCMOBJ*,___CAST(___SCMOBJ,___hp+2)&~7)-1,
                            ___tSUBTYPED);
#else
            result = ___TAG(___hp, ___tSUBTYPED);
#endif
            ___HEADER(result) = ___MAKE_HD_BYTES((n<<3), ___sF64VECTOR);
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    ___F64 fill = ___F64UNBOX(___ARG2);
    for (i=0; i<n; i++)
      ___F64VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;

end-of-code

            k
            fill)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-f64vector k fill))
      v)))
)

  (else

   (define-prim (##make-vector k #!optional (fill 0))
     (##make-vector k fill))

   (define-prim (##make-string k #!optional (fill #\nul))
     (##make-string k fill))

   (define-prim (##make-s8vector k #!optional (fill 0))
     (##make-s8vector k fill))

   (define-prim (##make-u8vector k #!optional (fill 0))
     (##make-u8vector k fill))

   (define-prim (##make-s16vector k #!optional (fill 0))
     (##make-s16vector k fill))

   (define-prim (##make-u16vector k #!optional (fill 0))
     (##make-u16vector k fill))

   (define-prim (##make-s32vector k #!optional (fill 0))
     (##make-s32vector k fill))

   (define-prim (##make-u32vector k #!optional (fill 0))
     (##make-u32vector k fill))

   (define-prim (##make-s64vector k #!optional (fill 0))
     (##make-s64vector k fill))

   (define-prim (##make-u64vector k #!optional (fill 0))
     (##make-u64vector k fill))

   (define-prim (##make-f32vector k #!optional (fill 0.0))
     (##make-f32vector k fill))

   (define-prim (##make-f64vector k #!optional (fill 0.0))
     (##make-f64vector k fill))

))

(macro-case-target

 ((C)

(define-prim (##make-machine-code-block len)
  ((c-lambda (size_t)
             (pointer void)
     #<<end-of-code

     ___return(___alloc_mem_code (___arg1));

end-of-code
)
   len))

(define-prim (##machine-code-block-ref mcb i)
  ((c-lambda ((nonnull-pointer void) int)
             unsigned-int8
     #<<end-of-code

     ___return(___CAST(___U8*,___arg1)[___arg2]);

end-of-code
)
   mcb
   i))

(define-prim (##machine-code-block-set! mcb i byte)
  ((c-lambda ((nonnull-pointer void) int unsigned-int8)
             void
     #<<end-of-code

     ___CAST(___U8*,___arg1)[___arg2] = ___arg3;

end-of-code
)
   mcb
   i
   byte))

(define-prim (##machine-code-block-exec mcb #!optional (arg1 0) (arg2 0) (arg3 0))
  ((c-lambda ((nonnull-pointer void) scheme-object scheme-object scheme-object)
             scheme-object
     #<<end-of-code

     ___return(___CAST(___SCMOBJ (*)(___SCMOBJ, ___SCMOBJ, ___SCMOBJ),___arg1)(___arg2, ___arg3, ___arg4));

end-of-code
)
   mcb
   arg1
   arg2
   arg3))

;;;----------------------------------------------------------------------------

;;; Apply.

(define-prim (##apply proc args)

  (##declare (not inline))

  (define (app proc args)
    (##declare (not interrupts-enabled))
    (##c-code #<<end-of-code

     ___SCMOBJ proc;
     ___SCMOBJ args;
     ___SCMOBJ lst;
     int na;

     ___POP_ARGS2(proc,args)

     lst = args;
     na = 0;

     while (___PAIRP(lst))
       {
         ___PUSH(___CAR(lst))
         lst = ___CDR(lst);
         na++;

         if (na > ___MAX_NB_ARGS)
           {
             ___ADJFP(-na); /* remove pushed arguments */

             ___PUSH_ARGS2(proc,args)

             ___COVER_APPLY_ARGUMENT_LIMIT;

             ___JUMPPRM(___SET_NARGS(2),
                        ___PRMCELL(___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception.prm))
           }
       }

     ___POP_ARGS_IN_REGS(na) /* load register arguments */

     ___COVER_APPLY_ARGUMENT_LIMIT_END;

     ___JUMPEXTNOTSAFE(___SET_NARGS(na),proc)

     ___RESULT = ___FAL; /* avoid a warning that ___RESULT is not set */

end-of-code
))

  (app proc args))

;;;----------------------------------------------------------------------------

;;; Values.

(define-prim (##make-values len #!optional (init 0))
  (let ((vals (##make-vector len init)))
    (##subtype-set! vals (macro-subtype-boxvalues))
    vals))

(define-prim (##values-length vals)
  (##vector-length vals))

(define-prim (##values-ref vals i)
  (##vector-ref vals i))

(define-prim (##values-set! vals i val)
  (##vector-set! vals i val))

;;;----------------------------------------------------------------------------

;;; Closures and subprocedures.

(define-prim (##closure? proc))

(define-prim (##make-closure code nb-closed)
  (let ((closure (##make-vector (##fx+ nb-closed 1))))
    (##vector-set! closure 0 code)
    (##subtype-set! closure (macro-subtype-procedure))
    closure))

(define-prim (##closure-length closure))
(define-prim (##closure-code closure))
(define-prim (##closure-ref closure index))
(define-prim (##closure-set! closure index val))

(define-prim (##subprocedure? proc))

(define-prim (##subprocedure-id proc)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,___ARG1-___tSUBTYPED);
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LS;
       ptr += ___LS;
       ___RESULT = ___FIX( (start-ptr)/___LS );
     }
   else
     ___RESULT = ___FIX(0);

end-of-code

   proc))

(define-prim (##subprocedure-parent proc)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,___ARG1-___tSUBTYPED);
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LS;
       ptr += ___LS;
      ___RESULT = ___TAG(ptr,___tSUBTYPED);
     }
   else
     ___RESULT = ___FAL;

end-of-code

   proc))

(define-prim (##subprocedure-nb-parameters proc)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___RESULT = ___FIX(___PRD_NBPARMS(___CAST(___label_struct*,___ARG1-___tSUBTYPED)->header));

end-of-code

   proc))

(define-prim (##subprocedure-nb-closed proc)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___RESULT = ___FIX(___PRD_NBCLOSED(___CAST(___label_struct*,___ARG1-___tSUBTYPED)->header));

end-of-code

   proc))

(define-prim (##make-subprocedure parent id)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   {
     ___SCMOBJ *start = ___CAST(___SCMOBJ*,___ARG1-___tSUBTYPED);
     ___SCMOBJ head = start[-___LS];
     int i = ___INT(___ARG2);
     if (___TESTHEADERTAG(head,___sVECTOR) &&
         i >= 0 &&
         i < ___CAST(int,___HD_FIELDS(head)))
       ___RESULT = ___TAG(start+___LS*i,___tSUBTYPED);
     else
       ___RESULT = ___FAL;
   }

end-of-code

   parent
   id))

(define-prim (##subprocedure-parent-info proc)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,___ARG1-___tSUBTYPED);
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LS;
       ___RESULT = ptr[1];
     }
   else
     ___RESULT = ___FAL;

end-of-code

   proc))

(define-prim (##subprocedure-parent-name proc)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,___ARG1-___tSUBTYPED);
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LS;
       ___RESULT = ptr[2];
     }
   else
     ___RESULT = ___FAL;

end-of-code

   proc))

;;;----------------------------------------------------------------------------

;;; Continuation objects.

(define-prim (##explode-continuation cont)
  (##vector (##continuation-frame cont)
            (##continuation-denv cont)))

(define-prim (##continuation-frame cont)
  (let ((frame (##vector-ref cont 0)))
    (if (or (##eq? frame (macro-end-of-cont-marker))
            (##frame? frame))
      frame
      (begin
        (##gc)
        (##continuation-frame cont)))))

(define-prim (##continuation-frame-set! cont frame)
  (macro-continuation-frame-set! cont frame))

(define-prim (##continuation-denv cont)
  (##declare (not interrupts-enabled))
  (macro-continuation-denv cont))

(define-prim (##continuation-denv-set! cont denv)
  (macro-continuation-denv-set! cont denv))

(define-prim (##explode-frame frame)
  (let ((fs (##frame-fs frame)))
    (let ((v (##make-vector (##fx+ fs 1))))
      (##vector-set! v 0 (##frame-ret frame))
      (let loop ((i fs))
        (if (##fx< 0 i)
          (begin
            (if (##frame-slot-live? frame i)
              (##vector-set!
               v
               i
               (##frame-ref frame i)))
            (loop (##fx- i 1)))
          v)))))

(define-prim (##frame-ret frame)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ ra = ___FIELD(___ARG1,0);

   if (ra == ___GSTATE->internal_return)
     ra = ___FIELD(___ARG1,___FRAME_RETI_RA);

   ___RESULT = ra;

end-of-code

   frame))

(define-prim (##continuation-ret cont)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   ___SCMOBJ ra;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ra = ___FIELD(frame,___FRAME_RETI_RA);
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ra = fp[-___RETI_RA];
     }

   ___RESULT = ra;

end-of-code

   cont))

(define-prim (##return-fs return)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ ra = ___ARG1;
   int fs;

   ___RETN_GET_FS(ra,fs)

   ___RESULT = ___FIX(fs);

end-of-code

   return))

(define-prim (##frame-fs frame)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS(___FIELD(___ARG1,___FRAME_RETI_RA),fs)
   else
     ___RETN_GET_FS(ra,fs)

   ___RESULT = ___FIX(fs);

end-of-code

   frame))

(define-prim (##continuation-fs cont)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS(___FIELD(frame,___FRAME_RETI_RA),fs)
       else
         ___RETN_GET_FS(ra,fs)
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS(fp[-___RETI_RA],fs)
       else
         ___RETN_GET_FS(ra,fs)
     }

   ___RESULT = ___FIX(fs);

end-of-code

   cont))

(define-prim (##frame-link frame)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
   else
     ___RETN_GET_FS_LINK(ra,fs,link)

   ___RESULT = ___FIX(link+1);

end-of-code

   frame))

(define-prim (##continuation-link cont)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;
   int link;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)
     }

   ___RESULT = ___FIX(link+1);

end-of-code

   cont))

(define-prim (##frame-slot-live? frame i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   int i = ___INT(___ARG2);
   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;
   ___WORD gcmap;
   ___WORD *nextgcmap = 0;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK_GCMAP(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link,gcmap,nextgcmap)
   else
     ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)

   if (i > ___WORD_WIDTH)
     gcmap = nextgcmap[(i-1) >> ___LOG_WORD_WIDTH];

   ___RESULT = ___BOOLEAN(gcmap & (1 << ((i-1) & (___WORD_WIDTH-1))));

end-of-code

   frame
   i))

(define-prim (##continuation-slot-live? cont i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   int i = ___INT(___ARG2);
   ___SCMOBJ ra;
   int fs;
   int link;
   ___WORD gcmap;
   ___WORD *nextgcmap = 0;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK_GCMAP(___FIELD(frame,___FRAME_RETI_RA),fs,link,gcmap,nextgcmap)
       else
         ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK_GCMAP(fp[-___RETI_RA],fs,link,gcmap,nextgcmap)
       else
         ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)
     }

   if (i > ___WORD_WIDTH)
     gcmap = nextgcmap[(i-1) >> ___LOG_WORD_WIDTH];

   ___RESULT = ___BOOLEAN(gcmap & (1 << ((i-1) & (___WORD_WIDTH-1))));

end-of-code

   cont
   i))

(define-prim (##frame-ref frame i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   int i = ___INT(___ARG2);
   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
   else
     ___RETN_GET_FS_LINK(ra,fs,link)

   ___RESULT = ___BODY_AS(___ARG1,___tSUBTYPED)[fs-i+1];  /* what if i==link and frame is first in section???? */
#if 0
   if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif

end-of-code

   frame
   i))

(define-prim (##frame-set! frame i val)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   int i = ___INT(___ARG2);
   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
   else
     ___RETN_GET_FS_LINK(ra,fs,link)

   ___BODY_AS(___ARG1,___tSUBTYPED)[fs-i+1] = ___ARG3;  /* what if i==link and frame is first in section???? */

   ___RESULT = ___VOID;

end-of-code

   frame
   i
   val))

(define-prim (##continuation-ref cont i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ cont = ___ARG1;
   int i = ___INT(___ARG2);
   ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;
   int link;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___RESULT = ___BODY_AS(frame,___tSUBTYPED)[fs-i+1];  /* what if i==link and frame is first in section???? */
#if 0
      if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___RESULT = ___CAST(___SCMOBJ*,frame)[___FRAME_SPACE(fs)-i];  /* what if i==link and frame is first in section???? */
#if 0
      if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif
     }

end-of-code

   cont
   i))

(define-prim (##continuation-set! cont i val)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ cont = ___ARG1;
   int i = ___INT(___ARG2);
   ___SCMOBJ val = ___ARG3;
   ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;
   int link;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___BODY_AS(frame,___tSUBTYPED)[fs-i+1] = val;  /* what if i==link and frame is first in section???? */
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___CAST(___SCMOBJ*,frame)[___FRAME_SPACE(fs)-i] = val;  /* what if i==link and frame is first in section???? */
#if 0
      if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif
     }

   ___RESULT = cont;

end-of-code

   cont
   i
   val))

(define-prim (##make-frame ret)
  (let ((fs (##return-fs ret)))
    (let ((frame (##make-vector (##fx+ fs 1) 0)))
      (##vector-set! frame 0 ret)
      (##subtype-set! frame (macro-subtype-frame))
      frame)))

(define-prim (##make-continuation frame denv)
  (##declare (not interrupts-enabled))
  (let ((cont
         (##c-code #<<end-of-code

          ___SCMOBJ frame = ___ARG1;
          ___SCMOBJ denv  = ___ARG2;

          ___hp[0]=___MAKE_HD_WORDS(___CONTINUATION_SIZE,___sCONTINUATION);
          ___ADD_VECTOR_ELEM(0,frame);
          ___ADD_VECTOR_ELEM(1,denv);
          ___hp+=___CONTINUATION_SIZE+1;
          ___RESULT = ___GET_VECTOR(___CONTINUATION_SIZE);

end-of-code

          frame
          denv)))
    (##check-heap)
    cont))

(define-prim (##continuation-copy cont)
  (##declare (not interrupts-enabled))
  (let ((cont-copy
         (##c-code #<<end-of-code

          ___SCMOBJ cont = ___ARG1;
          ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
          ___SCMOBJ denv  = ___FIELD(cont,___CONTINUATION_DENV);

          ___hp[0]=___MAKE_HD_WORDS(___CONTINUATION_SIZE,___sCONTINUATION);
          ___ADD_VECTOR_ELEM(0,frame);
          ___ADD_VECTOR_ELEM(1,denv);
          ___hp+=___CONTINUATION_SIZE+1;
          ___RESULT = ___GET_VECTOR(___CONTINUATION_SIZE);

end-of-code

          cont)))
    (##check-heap)
    cont-copy))

(define-prim (##continuation-next! cont)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

#define DYNAMIC_ENV_BIND_DENV 2

   ___SCMOBJ cont = ___ARG1;
   ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
   ___SCMOBJ denv  = ___FIELD(cont,___CONTINUATION_DENV);
   ___SCMOBJ ra;
   ___SCMOBJ *fp, frame_ra, next_frame;
   int fs;
   int link;

   if (___TYP(frame)==___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       fp = ___BODY_AS(frame,___tSUBTYPED);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(fp[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       fp += fs+1;

       if (ra == ___GSTATE->dynamic_env_bind_return)
         denv = fp[-DYNAMIC_ENV_BIND_DENV];

       next_frame = fp[-link-1];

       if (next_frame == ___END_OF_CONT_MARKER)
         ___RESULT = ___FAL;
       else
         {
           ___FIELD(cont,___CONTINUATION_FRAME) = next_frame;
           ___FIELD(cont,___CONTINUATION_DENV) = denv;
           ___RESULT = cont;
         }
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       fp = ___CAST(___SCMOBJ*,frame)+___FRAME_SPACE(fs);
       frame_ra = fp[-link-1];

       if (ra == ___GSTATE->dynamic_env_bind_return)
         denv = fp[-DYNAMIC_ENV_BIND_DENV];

       if (frame_ra == ___GSTATE->handler_break)
         {
           /* first frame of that section */

           next_frame = fp[___BREAK_FRAME_NEXT];
         }
       else
         {
           /* not the first frame of that section */

           *fp = frame_ra;
           next_frame = ___CAST(___SCMOBJ,fp);
         }

       if (next_frame == ___END_OF_CONT_MARKER)
         ___RESULT = ___FAL;
       else
         {
           ___FIELD(cont,___CONTINUATION_FRAME) = next_frame;
           ___FIELD(cont,___CONTINUATION_DENV) = denv;
           ___RESULT = cont;
         }
     }

end-of-code

   cont))

(define-prim (##continuation-next cont)
  (##declare (not interrupts-enabled))
  (##continuation-next! (##continuation-copy cont)))

;;;----------------------------------------------------------------------------

;;; Symbols and keywords.

(define-prim (##symbol-table)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___GSTATE->symbol_table;"))

(define-prim (##keyword-table)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___GSTATE->keyword_table;"))

(define-prim (##make-interned-symbol name)
  (##make-interned-symkey name #t))

(define-prim (##make-interned-keyword name)
  (##make-interned-symkey name #f))

(define-prim (##make-interned-symkey name symbol?)
  (let ((result
         ((c-lambda (scheme-object
                     scheme-object)
                    scheme-object
           #<<end-of-code

           unsigned int subtype = ___FALSEP(___arg2) ? ___sKEYWORD : ___sSYMBOL;
           ___return(___make_symkey_from_scheme_string (___arg1, subtype));

end-of-code
)
          name
          symbol?)))
    (if (##fixnum? result)
      (begin
        (##raise-heap-overflow-exception)
        (##make-interned-symkey name symbol?))
      result)))

(define-prim (##find-interned-symbol name)
  (##find-interned-symkey name #t))

(define-prim (##find-interned-keyword name)
  (##find-interned-symkey name #f))

(define-prim (##find-interned-symkey name symbol?)
  ((c-lambda (scheme-object
              scheme-object)
             scheme-object
     #<<end-of-code

     unsigned int subtype = ___FALSEP(___arg2) ? ___sKEYWORD : ___sSYMBOL;
     ___return(___find_symkey_from_scheme_string (___arg1, subtype));

end-of-code
)
   name
   symbol?))

;;;----------------------------------------------------------------------------

;;; Global variables.

(define-prim (##make-global-var id)
  (##declare (not interrupts-enabled))
  (let ((gv (##c-code "___RESULT = ___make_global_var (___ARG1);" id)))
    (if (##fixnum? gv)
      (begin
        (##raise-heap-overflow-exception)
        (##make-global-var id))
      gv)))

(define-prim (##global-var? id)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___BOOLEAN(___GLOBALVARSTRUCT(___ARG1) != 0);" id))

(define-prim (##global-var-ref gv))
(define-prim (##global-var-primitive-ref gv))
(define-prim (##global-var-set! gv val))
(define-prim (##global-var-primitive-set! gv val))

(define-prim (##object->global-var->identifier obj)
  (##global-var->identifier (##object->global-var obj #f)))

(define-prim (##object->global-var obj primitive?)
  (##c-code
   "___RESULT = ___obj_to_global_var (___ARG1, !___FALSEP(___ARG2));"
   obj
   primitive?))

(define-prim (##global-var->identifier gv)
  gv)

;;;----------------------------------------------------------------------------

;;; Foreign objects.

(implement-check-type-foreign)

(define-prim (foreign? obj)
  (##foreign? obj))

(define-prim (##foreign-tags f))

(define-prim (foreign-tags f)
  (macro-force-vars (f)
    (macro-check-foreign f 1 (foreign-tags f)
      (##foreign-tags f))))

(define-prim (##foreign-released? f)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___RESULT = ___BOOLEAN(___CAST(void*,___FIELD(___ARG1,___FOREIGN_PTR)) == 0);

end-of-code

   f))

(define-prim (foreign-released? f)
  (macro-force-vars (f)
    (macro-check-foreign f 1 (foreign-released? f)
      (##foreign-released? f))))

(define-prim (##foreign-release! f)
  (##declare (not interrupts-enabled))
  (let ((code (##c-code "___RESULT = ___release_foreign (___ARG1);" f)))
    (if (##eq? code 0)
      (##void)
      (##raise-os-exception #f code foreign-release! f))))

(define-prim (foreign-release! f)
  (macro-force-vars (f)
    (macro-check-foreign f 1 (foreign-release! f)
      (##foreign-release! f))))

(define-prim (##foreign-address f)
  ((c-lambda (scheme-object)
             size_t
    "
    ___return(___CAST(___SIZE_T,
                      ___CAST(void*,___FIELD(___arg1,___FOREIGN_PTR))));
    ")
   f))

(define-prim (foreign-address f)
  (macro-force-vars (f)
    (macro-check-foreign f 1 (foreign-address f)
      (##foreign-address f))))

;;;----------------------------------------------------------------------------

;;; C compilation environment information.

(define ##os-obj-extension-string-saved
  ((c-lambda ()
             nonnull-char-string
    "___os_obj_extension_string")))

(define ##os-exe-extension-string-saved
  ((c-lambda ()
             nonnull-char-string
    "___os_exe_extension_string")))

(define ##os-bat-extension-string-saved
  ((c-lambda ()
             nonnull-char-string
    "___os_bat_extension_string")))

;;;----------------------------------------------------------------------------

;;; Miscellaneous definitions.

(define ##err-code-EAGAIN
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(EAGAIN));"))

(define ##err-code-ENOENT
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(ENOENT));"))

(define ##err-code-EINTR
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(EINTR));"))

(define ##err-code-unimplemented
  (##c-code "___RESULT = ___FIX(___UNIMPL_ERR);"))

(define ##max-char
  (##c-code "___RESULT = ___FIX(___MAX_CHR);"))

(define ##min-fixnum
  (##c-code "___RESULT = ___FIX(___MIN_FIX);"))

(define ##max-fixnum
  (##c-code "___RESULT = ___FIX(___MAX_FIX);"))

(define ##fixnum-width
  (##c-code "___RESULT = ___FIX(___FIX_WIDTH);"))

(define ##fixnum-width-neg (##fx- ##fixnum-width))

(define ##bignum.adigit-width
  (##c-code "___RESULT = ___FIX(___BIG_ABASE_WIDTH);"))

(define ##bignum.mdigit-width
  (##c-code "___RESULT = ___FIX(___BIG_MBASE_WIDTH);"))

(define ##bignum.fdigit-width
  (##c-code "___RESULT = ___FIX(___BIG_FBASE_WIDTH);"))

;;;----------------------------------------------------------------------------

;;; Process information.

(define-prim (##process-statistics)
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

   ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
   ___F64 user, sys, real;
   ___SIZE_TS minflt, majflt;
   ___F64 n = ___bytes_allocated (___PSPNC);
   ___SCMOBJ result;

   ___FRAME_STORE_RA(___R0)
   ___W_ALL
   result = ___EXT(___alloc_scmobj) (___ps, ___sF64VECTOR, 20<<3);
   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

    if (!___FIXNUMP(result))
    {
      n = ___bytes_allocated (___PSPNC) - n;

      ___process_times (&user, &sys, &real);
      ___vm_stats (&minflt, &majflt);

      ___F64VECTORSET(result,___FIX(0),user)
      ___F64VECTORSET(result,___FIX(1),sys)
      ___F64VECTORSET(result,___FIX(2),real)
      ___F64VECTORSET(result,___FIX(3),___vms->mem.gc_user_time_)
      ___F64VECTORSET(result,___FIX(4),___vms->mem.gc_sys_time_)
      ___F64VECTORSET(result,___FIX(5),___vms->mem.gc_real_time_)
      ___F64VECTORSET(result,___FIX(6),___vms->mem.nb_gcs_)
      ___F64VECTORSET(result,___FIX(7),___bytes_allocated (___PSPNC))
      ___F64VECTORSET(result,___FIX(8),(2*(1+2)<<___LWS))
      ___F64VECTORSET(result,___FIX(9),n)
      ___F64VECTORSET(result,___FIX(10),minflt)
      ___F64VECTORSET(result,___FIX(11),majflt)
      ___F64VECTORSET(result,___FIX(12),___vms->mem.latest_gc_user_time_)
      ___F64VECTORSET(result,___FIX(13),___vms->mem.latest_gc_sys_time_)
      ___F64VECTORSET(result,___FIX(14),___vms->mem.latest_gc_real_time_)
      ___F64VECTORSET(result,___FIX(15),___vms->mem.latest_gc_heap_size_)
      ___F64VECTORSET(result,___FIX(16),___vms->mem.latest_gc_alloc_)
      ___F64VECTORSET(result,___FIX(17),___vms->mem.latest_gc_live_)
      ___F64VECTORSET(result,___FIX(18),___vms->mem.latest_gc_movable_)
      ___F64VECTORSET(result,___FIX(19),___vms->mem.latest_gc_still_)

      ___still_obj_refcount_dec (result);
   }

   ___RESULT = result;

end-of-code

     )))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##process-statistics))
      v)))

(define-prim (##process-times)
  (##declare (not interrupts-enabled))
  (let ((v
         (##f64vector (macro-inexact-+0)
                      (macro-inexact-+0)
                      (macro-inexact-+0))))
    (##c-code #<<end-of-code

     ___SCMOBJ result = ___ARG1;
     ___F64 user, sys, real;
     ___process_times (&user, &sys, &real);
     ___F64VECTORSET(result,___FIX(0),user)
     ___F64VECTORSET(result,___FIX(1),sys)
     ___F64VECTORSET(result,___FIX(2),real)
     ___RESULT = result;

end-of-code

     v)))

(define-prim (##get-current-time! floats i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___time t;

   ___time_get_current_time (&t);

   ___F64VECTORSET(___ARG1,___ARG2,___time_to_seconds (t))

   ___RESULT = ___VOID;

end-of-code

   floats
   i))

(define-prim (##get-monotonic-time! u64vect i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___STORE_U64(___BODY_AS(___ARG1,___tSUBTYPED),
                ___INT(___ARG2),
                ___time_get_monotonic_time ());

   ___RESULT = ___VOID;

end-of-code

   u64vect
   i))

(define-prim (##get-monotonic-time-frequency! u64vect i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___STORE_U64(___BODY_AS(___ARG1,___tSUBTYPED),
                ___INT(___ARG2),
                ___time_get_monotonic_time_frequency ());

   ___RESULT = ___VOID;

end-of-code

   u64vect
   i))

(define-prim (##get-bytes-allocated! floats i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___F64VECTORSET(___ARG1,___ARG2,___bytes_allocated (___PSPNC));

   ___RESULT = ___VOID;

end-of-code

   floats
   i))

;;;----------------------------------------------------------------------------

;;; Activity log operations.

(define-prim (##actlog-start)
  ((c-lambda ()
             void
    #<<end-of-code
#ifdef ___ACTIVITY_LOG
___actlog_start (___ps);
#endif
end-of-code
   )))

(define-prim (##actlog-stop)
  ((c-lambda ()
             void
    #<<end-of-code
#ifdef ___ACTIVITY_LOG
___actlog_stop (___ps);
#endif
end-of-code
   )))

(define-prim (##actlog-dump #!optional (filename #f))
  ((c-lambda (char-string)
             void
    #<<end-of-code
#ifdef ___ACTIVITY_LOG
___actlog_dump (___VMSTATE_FROM_PSTATE(___ps), ___arg1);
#endif
end-of-code
   ) filename))

;;;----------------------------------------------------------------------------

;;; Error message formatting.

(define-prim ##format-filepos
  (c-lambda (char-string
             size_t
             bool)
            char-string
   "___format_filepos"))

(define-prim ##os-err-code->string
  (c-lambda (scheme-object)
            scheme-object
   "___os_err_code_to_string"))

(define-prim (err-code->string code)
  (##os-err-code->string code))

;;;----------------------------------------------------------------------------

;;; Filesystem path manipulation.

(define-prim ##os-path-homedir
  (c-lambda ()
            scheme-object
   "___os_path_homedir"))

(define-prim ##os-path-gambitdir
  (c-lambda ()
            scheme-object
   "___os_path_gambitdir"))

(define-prim ##os-path-gambitdir-map-lookup
  (c-lambda (scheme-object)
            scheme-object
   "___os_path_gambitdir_map_lookup"))

(define-prim ##os-path-normalize-directory
  (c-lambda (scheme-object)
            scheme-object
   "___os_path_normalize_directory"))

(define-prim ##remote-dbg-addr
  (c-lambda ()
            UCS-2-string
   "___return(___GSTATE->setup_params.remote_dbg_addr);"))

(define-prim ##rpc-server-addr
  (c-lambda ()
            UCS-2-string
   "___return(___GSTATE->setup_params.rpc_server_addr);"))

;;;----------------------------------------------------------------------------

;;; Command line, environment variables, and shell command execution.

(define-prim (##command-line)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___GSTATE->command_line;"))

(define ##processed-command-line
  (##command-line))

(define-prim (##processed-command-line-set! x)
  (set! ##processed-command-line x))

(define-prim ##os-getenv
  (c-lambda (scheme-object)
            scheme-object
   "___os_getenv"))

(define-prim ##os-setenv
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_setenv"))

(define-prim ##os-environ
  (c-lambda ()
            scheme-object
   "___os_environ"))

(define-prim ##os-shell-command
  (c-lambda (scheme-object)
            scheme-object
   "___os_shell_command"))

;;;----------------------------------------------------------------------------

;;; Provide access to low-level I/O operations implemented in "os.c".

(define-prim ##os-device-kind
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; kind (fixnum)
   "___os_device_kind"))

(define-prim ##os-device-force-output
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object) ;; level (0, 1 or 2)
            scheme-object   ;; error code (fixnum)
   "___os_device_force_output"))

(define-prim ##os-device-close
  (c-lambda (scheme-object  ;; dev
             scheme-object) ;; direction
            scheme-object   ;; error code (fixnum)
   "___os_device_close"))

(define-prim ##os-device-stream-seek
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object  ;; pos
             scheme-object) ;; whence
            scheme-object   ;; error code (fixnum)
   "___os_device_stream_seek"))

(define-prim ##os-device-stream-read
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object  ;; buffer
             scheme-object  ;; lo
             scheme-object) ;; hi
            scheme-object   ;; bytes read (fixnum)
   "___os_device_stream_read"))

(define-prim ##os-device-stream-write
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object  ;; buffer
             scheme-object  ;; lo
             scheme-object) ;; hi
            scheme-object   ;; bytes written (fixnum)
   "___os_device_stream_write"))

(define-prim ##os-device-stream-width
  (c-lambda (scheme-object) ;; dev_condvar
            scheme-object   ;; width (fixnum)
   "___os_device_stream_width"))

(define-prim ##os-device-stream-default-options
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; options (fixnum)
   "___os_device_stream_default_options"))

(define-prim ##os-device-stream-options-set!
  (c-lambda (scheme-object  ;; dev
             scheme-object) ;; options
            scheme-object   ;; error code (fixnum)
   "___os_device_stream_options_set"))

(define-prim ##os-device-stream-open-predefined
  (c-lambda (scheme-object  ;; -1=stdin -2=stdout -3=stderr -4=console
             scheme-object) ;; flags
            scheme-object   ;; device
   "___os_device_stream_open_predefined"))

(define-prim ##os-device-stream-open-path
  (c-lambda (scheme-object  ;; path
             scheme-object  ;; flags
             scheme-object) ;; mode
            scheme-object   ;; device
   "___os_device_stream_open_path"))

(define-prim ##os-device-stream-open-process
  (c-lambda (scheme-object  ;; path_and_args
             scheme-object  ;; environment
             scheme-object  ;; directory
             scheme-object) ;; options
            scheme-object   ;; device
   "___os_device_stream_open_process"))

(define-prim ##os-device-open-raw
  (c-lambda (scheme-object  ;; fd
             scheme-object) ;; flags
            scheme-object   ;; device
   "___os_device_raw_open"))

(define-prim ##os-device-process-pid
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; pid (fixnum)
   "___os_device_process_pid"))

(define-prim ##os-device-process-status
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; status (fixnum or #f if no status yet)
   "___os_device_process_status"))

(define-prim ##os-make-tls-context
  (c-lambda (scheme-object  ;; min_tls_version
             scheme-object  ;; options
             scheme-object  ;; certificate_path
             scheme-object  ;; private_key_path
             scheme-object  ;; dh_params_path
             scheme-object  ;; elliptic_curve_name
             scheme-object) ;; client_ca_path
            scheme-object   ;; tls_context
            "___os_make_tls_context"))

(define-prim ##os-device-tcp-client-open
  (c-lambda (scheme-object  ;; server_addr
             scheme-object  ;; port_num
             scheme-object  ;; options
             scheme-object) ;; tls_context
            scheme-object   ;; device
   "___os_device_tcp_client_open"))

(define-prim ##os-device-tcp-client-socket-info
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object) ;; peer
            scheme-object   ;; addr
   "___os_device_tcp_client_socket_info"))

(define-prim ##os-device-tcp-server-open
  (c-lambda (scheme-object  ;; server_addr
             scheme-object  ;; port_num
             scheme-object  ;; backlog
             scheme-object  ;; options
             scheme-object) ;; tls_context
            scheme-object   ;; device
   "___os_device_tcp_server_open"))

(define-prim ##os-device-tcp-server-read
  (c-lambda (scheme-object) ;; dev_condvar
            scheme-object   ;; device
   "___os_device_tcp_server_read"))

(define-prim ##os-device-tcp-server-socket-info
  (c-lambda (scheme-object) ;; dev_condvar
            scheme-object   ;; addr
   "___os_device_tcp_server_socket_info"))

(define-prim ##os-device-directory-open-path
  (c-lambda (scheme-object  ;; path
             scheme-object) ;; ignore_hidden
            scheme-object   ;; device
   "___os_device_directory_open_path"))

(define-prim ##os-device-directory-read
  (c-lambda (scheme-object) ;; dev_condvar
            scheme-object   ;; filename
   "___os_device_directory_read"))

(define-prim ##os-device-event-queue-open
  (c-lambda (scheme-object) ;; selector
            scheme-object   ;; device
   "___os_device_event_queue_open"))

(define-prim ##os-device-event-queue-read
  (c-lambda (scheme-object) ;; dev_condvar
            scheme-object   ;; event
   "___os_device_event_queue_read"))

(define-prim ##os-device-tty-type-set!
  (c-lambda (scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_device_tty_type_set"))

(define-prim ##os-device-tty-text-attributes-set!
  (c-lambda (scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_device_tty_text_attributes_set"))

(define-prim ##os-device-tty-history
  (c-lambda (scheme-object)
            scheme-object
   "___os_device_tty_history"))

(define-prim ##os-device-tty-history-set!
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_device_tty_history_set"))

(define-prim ##os-device-tty-history-max-length-set!
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_device_tty_history_max_length_set"))

(define-prim ##os-device-tty-paren-balance-duration-set!
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_device_tty_paren_balance_duration_set"))

(define-prim ##os-device-tty-mode-set!
  (c-lambda (scheme-object
             scheme-object
             scheme-object
             scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_device_tty_mode_set"))

(define-prim (##os-condvar-select! devices timeout)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___os_condvar_select (___ARG1, ___ARG2);"
   devices
   timeout))

(define-prim ##os-port-decode-chars!
  (c-lambda (scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_port_decode_chars"))

(define-prim ##os-port-encode-chars!
  (c-lambda (scheme-object)
            scheme-object
   "___os_port_encode_chars"))

(define-prim ##os-file-times-set!
  (c-lambda (scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_file_times_set"))

(define-prim ##os-file-info
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_file_info"))

(define-prim ##os-user-info
  (c-lambda (scheme-object)
            scheme-object
   "___os_user_info"))

(define-prim ##os-user-name
  (c-lambda ()
            scheme-object
   "___os_user_name"))

(define-prim ##os-group-info
  (c-lambda (scheme-object)
            scheme-object
   "___os_group_info"))

(define-prim ##os-address-infos
  (c-lambda (scheme-object
             scheme-object
             scheme-object
             scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_address_infos"))

(define-prim ##os-host-info
  (c-lambda (scheme-object)
            scheme-object
   "___os_host_info"))

(define-prim ##os-host-name
  (c-lambda ()
            scheme-object
   "___os_host_name"))

(define-prim ##os-service-info
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_service_info"))

(define-prim ##os-protocol-info
  (c-lambda (scheme-object)
            scheme-object
   "___os_protocol_info"))

(define-prim ##os-network-info
  (c-lambda (scheme-object)
            scheme-object
   "___os_network_info"))

(define-prim ##os-getpid
  (c-lambda ()
            scheme-object
   "___os_getpid"))

(define-prim ##os-getppid
  (c-lambda ()
            scheme-object
   "___os_getppid"))

(define-prim ##os-create-directory
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_create_directory"))

(define-prim ##os-create-fifo
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_create_fifo"))

(define-prim ##os-create-link
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_create_link"))

(define-prim ##os-create-symbolic-link
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_create_symbolic_link"))

(define-prim ##os-delete-directory
  (c-lambda (scheme-object)
            scheme-object
   "___os_delete_directory"))

(define-prim ##os-set-current-directory
  (c-lambda (scheme-object)
            scheme-object
   "___os_set_current_directory"))

(define-prim ##os-rename-file
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_rename_file"))

(define-prim ##os-copy-file
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_copy_file"))

(define-prim ##os-delete-file
  (c-lambda (scheme-object)
            scheme-object
   "___os_delete_file"))

;;;----------------------------------------------------------------------------

;;; Dynamic loading.

(define-prim ##os-load-object-file
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_load_object_file"))

))

;;;----------------------------------------------------------------------------

;;; Program startup and exit.

(define ##exit-jobs (##make-jobs))

;;; (##add-exit-job! thunk) can be called to add a job to
;;; do when the program exits.  (##clear-exit-jobs!) clears the jobs.

(define-prim (##add-exit-job! thunk)
  (##add-job! ##exit-jobs thunk))

(define-prim (##clear-exit-jobs!)
  (##clear-jobs! ##exit-jobs))

(macro-case-target

 ((C)

(define-prim (##exit-with-err-code-no-cleanup err-code)
  (##c-code #<<end-of-code

   ___propagate_error (___PSP ___ARG1);
   ___RESULT = ___VOID; /* never reached */

end-of-code

   err-code))

(define-prim (##exit-cleanup)
  (##execute-and-clear-jobs! ##exit-jobs)
  (##execute-final-wills!))

(define-prim (##exit-with-err-code err-code)
  (##exit-cleanup)
  (##exit-with-err-code-no-cleanup err-code))

(define-prim (##exit #!optional (status (macro-EXIT-CODE-OK)))
  (##exit-with-err-code (##fx+ status 1)))

(define-prim (##exit-abnormally)
  (##exit (macro-EXIT-CODE-SOFTWARE)))

(define-prim (##exit-with-exception exc)
  (##exit-abnormally))

(##interrupt-vector-set! 1 ;; ___INTR_TERMINATE
  (lambda ()
    (##declare (not interrupts-enabled))
    (##exit-abnormally)))

))

;;;----------------------------------------------------------------------------

(define-prim (##first-argument arg1 #!optional arg2 arg3 #!rest others)
  arg1)

(define-prim (##with-no-result-expected thunk)
  (##declare (not interrupts-enabled))
  (##first-argument (thunk))) ;; force nontail-call to thunk

(define-prim (##with-no-result-expected-toplevel thunk)
  (##declare (not interrupts-enabled))
  (##first-argument (thunk))) ;; force nontail-call to thunk

;;;----------------------------------------------------------------------------

;;; Version information.

(define-prim (##system-version)

  (##define-macro (result)
    (c#compiler-version))

  (result))

(define-prim (system-version)
  (##system-version))

(define-prim (##system-version-string)

  (##define-macro (result)
    (c#compiler-version-string))

  (result))

(define-prim (system-version-string)
  (##system-version-string))

(macro-case-target

 ((C)

(define ##os-system-type-saved
  (let ()

    (define (str-list->sym-list lst)
      (if (##null? lst)
          '()
          (##cons (##make-interned-symbol (##car lst))
                  (str-list->sym-list (##cdr lst)))))

    (str-list->sym-list
     ((c-lambda ()
                nonnull-char-string-list
       "___os_system_type")))))

(define-prim (system-type)
  ##os-system-type-saved)

(define ##os-system-type-string-saved
  ((c-lambda ()
             nonnull-char-string
    "___os_system_type_string")))

(define-prim (system-type-string)
  ##os-system-type-string-saved)

(define ##os-configure-command-string-saved
  ((c-lambda ()
             nonnull-char-string
    "___os_configure_command_string")))

(define-prim (configure-command-string)
  ##os-configure-command-string-saved)

(define ##system-stamp-saved
  ((c-lambda ()
             unsigned-int64
    "___return(___U64_add_U64_U64
                 (___U64_mul_UM32_UM32 (___STAMP_YMD, 1000000),
                  ___U64_from_UM32 (___STAMP_HMS)));")))

(define-prim (##system-stamp)
  ##system-stamp-saved)

(define-prim (system-stamp)
  (##system-stamp))

))

;;;----------------------------------------------------------------------------

;;; Structure support.

;; For bootstraping purposes the type of type objects must be
;; explicitly constructed.  It is as though the following form had
;; been used:
;;
;;   (define-type type
;;     id: ...special-type...
;;     (id      unprintable: equality-test:)
;;     (name    unprintable: equality-skip:)
;;     (flags   unprintable: equality-skip:)
;;     (super   unprintable: equality-skip:)
;;     (fields  unprintable: equality-skip:)
;;   )

(##define-macro (macro-type-type-constant)
  (let ((type-type
         (##structure
          #f ;; this structure's type descriptor is itself! (set later)
          '##type-5
          'type
          '8
          '#f
          '#(id 1 #f name 5 #f flags 5 #f super 5 #f fields 5 #f))))
    (##structure-type-set! type-type type-type) ;; self reference
    `',type-type))

(define ##type-type (macro-type-type-constant))

(define-prim (##type-id type)
  (##unchecked-structure-ref type 1 ##type-type ##type-id))

(define-prim (##type-name type)
  (##unchecked-structure-ref type 2 ##type-type ##type-name))

(define-prim (##type-flags type)
  (##unchecked-structure-ref type 3 ##type-type ##type-flags))

(define-prim (##type-super type)
  (##unchecked-structure-ref type 4 ##type-type ##type-super))

(define-prim (##type-fields type)
  (##unchecked-structure-ref type 5 ##type-type ##type-fields))

(define-prim (##structure-direct-instance-of? obj type-id)
  (and (##structure? obj)
       (##eq? (##type-id (##structure-type obj))
              type-id)))

(define-prim (##structure-instance-of? obj type-id)
  (and (##structure? obj)
       (let loop ((c (##structure-type obj)))
         (if (##eq? (##type-id c) type-id)
           #t
           (let ((super (##type-super c)))
             (and super
                  (loop super)))))))

(define-prim (##type? obj)
  (##structure-direct-instance-of? obj (##type-id ##type-type)))

(define-prim (##structure-type obj)
  (##vector-ref obj 0))

(define-prim (##structure-type-set! obj type)
  (##vector-set! obj 0 type))

(define-prim (##make-structure type len)
  (let ((s (##make-vector len)))
    (##subtype-set! s (macro-subtype-structure))
    (##vector-set! s 0 type)
    s))

(define-prim (##structure-length obj)
  (##vector-length obj))

(define-prim (##structure type . fields)

  (define (make-struct fields i)
    (if (##pair? fields)
        (let ((s (make-struct (##cdr fields) (##fx+ i 1))))
          (##unchecked-structure-set! s (##car fields) i type #f)
          s)
        (##make-structure type i)))

  (make-struct fields 1))

(define-prim (##structure-ref obj i type proc)
  (if (##structure-instance-of? obj (##type-id type))
    (##unchecked-structure-ref obj i type proc)
    (##raise-type-exception
     1
     type
     (if proc proc ##structure-ref)
     (if proc (##list obj) (##list obj i type proc)))))

(define-prim (##structure-set! obj val i type proc)
  (if (##structure-instance-of? obj (##type-id type))
    (begin
      (##unchecked-structure-set! obj val i type proc)
      (##void))
    (##raise-type-exception
     1
     type
     (if proc proc ##structure-set!)
     (if proc (##list obj val) (##list obj val i type proc)))))

(define-prim (##structure-cas! obj val oldval i type proc)
  (if (##structure-instance-of? obj (##type-id type))
    (begin
      (##unchecked-structure-cas! obj val oldval i type proc)
      (##void))
    (##raise-type-exception
     1
     type
     (if proc proc ##structure-cas!)
     (if proc (##list obj val oldval) (##list obj val oldval i type proc)))))

(define-prim (##direct-structure-ref obj i type proc)
  (if (##structure-direct-instance-of? obj (##type-id type))
    (##unchecked-structure-ref obj i type proc)
    (##raise-type-exception
     1
     type
     (if proc proc ##direct-structure-ref)
     (if proc (##list obj) (##list obj i type proc)))))

(define-prim (##direct-structure-set! obj val i type proc)
  (if (##structure-direct-instance-of? obj (##type-id type))
    (begin
      (##unchecked-structure-set! obj val i type proc)
      (##void))
    (##raise-type-exception
     1
     type
     (if proc proc ##direct-structure-set!)
     (if proc (##list obj val) (##list obj val i type proc)))))

(define-prim (##direct-structure-cas! obj val oldval i type proc)
  (if (##structure-direct-instance-of? obj (##type-id type))
    (begin
      (##unchecked-structure-cas! obj val oldval i type proc)
      (##void))
    (##raise-type-exception
     1
     type
     (if proc proc ##direct-structure-cas!)
     (if proc (##list obj val oldval) (##list obj val oldval i type proc)))))

(define-prim (##unchecked-structure-ref obj i type proc))

(define-prim (##unchecked-structure-set! obj val i type proc))

(define-prim (##unchecked-structure-cas! obj val oldval i type proc)
  ;; TODO: remove after bootstrap
  (##vector-cas! obj i val oldval))

;;;----------------------------------------------------------------------------

;; The kernel is responsible for executing each module of the program
;; in sequence.  The vector of module execution procedures is in the
;; program descriptor.

(define ##main ;; this procedure is called after the program is loaded
  (lambda () #f))

(define-prim (##main-set! thunk)
  (set! ##main thunk))

(macro-case-target

 ((C)

  (define ##program-descr
    (##c-code "___RESULT = ___GSTATE->program_descr;"))

  (define ##vm-main-module-id
    (##c-code "___RESULT = ___VMSTATE_FROM_PSTATE(___ps)->main_module_id;"))

  (define (##module-init module-descr)
    (##c-code
     "___RESULT = ___CAST(___module_struct*,___FIELD(___ARG1,___FOREIGN_PTR))->init_mod (___PSPNC);"
     (##vector-ref module-descr 4)))

  (##main-set!
   (lambda ()
     (##exit-cleanup))))

 (else

  (define (##module-init module-descr)
    #f)))

(define-prim (##create-module name module-descr)
  (##vector #f name 0 module-descr))

(##define-macro (macro-module-name module)
  `(##vector-ref ,module 1))

(##define-macro (macro-module-state module)
  `(##vector-ref ,module 2))

(##define-macro (macro-module-state-set! module state)
  `(##vector-set! ,module 2 ,state))

(##define-macro (macro-module-descr module)
  `(##vector-ref ,module 3))

(define ##registered-modules '())

(define-prim (##register-module-descr! name module-descr)
  ;; TODO: make manipulation of ##registered-modules atomic
  (let* ((name
          (##vector-ref module-descr 0))
         (module
          (##create-module name module-descr))
         (x
          (##lookup-module name ##registered-modules)))
    (if x
        (##set-car! x module)
        (set! ##registered-modules
              (##cons module
                      ##registered-modules)))
    module))

(define-prim (##register-module-descrs! module-descrs)
  (let loop ((i (##fx- (##vector-length module-descrs) 1))
             (modules '()))
    (if (##fx>= i 0)
        (let* ((module-descr
                (##vector-ref module-descrs i))
               (name
                (##vector-ref module-descr 0)))
          (loop (##fx- i 1)
                (##cons (##register-module-descr! name module-descr)
                        modules)))
        modules)))

(define-prim (##lookup-registered-module name)
  (let ((x (##lookup-module name ##registered-modules)))
    (and x (##car x))))

(define-prim (##lookup-module name modules)
  (let loop ((lst modules))
    (if (##pair? lst)
        (let ((module (##car lst)))
          (if (##eq? name (macro-module-name module))
              lst
              (loop (##cdr lst))))
        #f)))

(define-prim (##load-required-module-structs modules force-load-last?)

  (define (init module)
    (if (##fx= (##fxand (macro-module-state module) 1) 0)
        (begin

          ;; TODO: this state change should be atomic with above test
          ;; set state to indicate module has been initialized
          (macro-module-state-set!
           module
           (##fxior (macro-module-state module) 1))

          (let ((module-descr (macro-module-descr module)))
            (if (##vector? module-descr)
                (##module-init module-descr))))))

  (define (run module)
    (if (##fx= (##fxand (macro-module-state module) 2) 0)
        (begin

          ;; TODO: this state change should be atomic with above test
          ;; set state to indicate module has been run
          (macro-module-state-set!
           module
           (##fxior (macro-module-state module) 2))

          (let ((module-descr (macro-module-descr module)))
            (if (##vector? module-descr)
                ((##vector-ref module-descr 1)))))))

  (define (for-each-module proc)
    (let loop ((modules modules))
      (if (##pair? modules)
          (let* ((module (##car modules))
                 (module-descr (macro-module-descr module))
                 (rest (##cdr modules))
                 (last? (##not (##pair? rest))))
            ;; load module if the preload flag is set or we force the loading
            (if (or (##fx= (##fxand 1 (##vector-ref module-descr 2)) 1)
                    (and force-load-last? last?))
                (if last?
                    (proc module)
                    (begin
                      (proc module)
                      (loop rest)))
                (loop rest))))))

  (for-each-module init)
  (for-each-module run))

(define-prim (##default-load-required-module module-ref)

  (define (err)
    (##raise-module-not-found-exception
     ##default-load-required-module
     module-ref))

  (cond ((##symbol? module-ref)
         (let ((module (##lookup-registered-module module-ref)))
           (if module
               (##load-required-module-structs (##list module) #t)
               (err))))
        (else
         (err))))

(define ##load-required-module
  ##default-load-required-module)

(define-prim (##load-required-module-set! x)
  (set! ##load-required-module x))

(implement-library-type-module-not-found-exception)

(define-prim (##raise-module-not-found-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-module-not-found-exception
       procedure
       arguments)))))

(define-prim (##register-module-descrs-and-load! module-descrs)
  (let ((modules (##register-module-descrs! module-descrs)))
    (##load-required-module-structs modules #f)))

(define-prim (##load-vm)
  (let ((module-descrs (##vector-ref ##program-descr 0)))
    (##module-init (##vector-ref module-descrs 0)) ;; init _kernel
    (let* ((modules (##register-module-descrs! module-descrs))
           (kernel-module (##car modules))
           (other-modules (##cdr modules)))
      (macro-module-state-set! kernel-module 3) ;; _kernel init and run done
      (##load-required-module-structs other-modules #f)
      (##load-required-module ##vm-main-module-id)
      (##main))))

(macro-case-target
 ((C)
  (##load-vm)))

;;;============================================================================
