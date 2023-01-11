;;;============================================================================

;;; File: "_kernel.scm"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(macro-case-target

 ((C)

(c-declare #<<c-declare-end

#include "os.h"
#include "os_setup.h"
#include "os_base.h"
#include "os_time.h"
#include "os_files.h"
#include "os_dyn.h"
#include "os_tty.h"
#include "os_io.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"

#include "stamp-release.h"
#include "stamp.h"

#ifndef ___STAMP_VERSION
#define ___STAMP_VERSION ___STAMP_RELEASE_VERSION
#endif

#ifndef ___STAMP_YMD
#define ___STAMP_YMD ___STAMP_RELEASE_YMD
#endif

#ifndef ___STAMP_HMS
#define ___STAMP_HMS ___STAMP_RELEASE_HMS
#endif

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

   ___SCMOBJ handler;

   ___PUSH_ARGS3(___ps->temp1, /* arg 1 = error code, integer */
                 ___ps->temp2, /* arg 2 = error data, #f/string/other */
                 ___FIELD(___ps->temp3,0)) /* arg 3 = procedure */

   ___COVER_SFUN_CONVERSION_ERROR_HANDLER;

   handler = ___ps->temp4;

   if (___FALSEP(handler))
     ___JUMPPRM(___SET_NARGS(3),
                ___PRMCELL(___G__23__23_raise_2d_sfun_2d_conversion_2d_exception.prm))
   else
     ___JUMPEXTNOTSAFE(___SET_NARGS(3), handler)

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

   ___WORD na;
   ___WORD i;
   ___SCMOBJ handler;

   na = ___ps->na;

   /* make space for 3 new arguments (one will replace return address) */

   ___ADJFP((na+1)+2-___FRAME_SPACE(na+1))

   ___SET_R0(___STK(-2)) /* get return address */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+3))) /* shift arguments up by three */

   ___SET_STK(-(na+2),___ps->temp1) /* arg 1 = error code, integer */
   ___SET_STK(-(na+1),___ps->temp2) /* arg 2 = error data, #f/string/other */
   ___SET_STK(-na,___ps->temp3) /* arg 3 = procedure */

   ___POP_ARGS_IN_REGS(na+3) /* load register arguments */

   ___COVER_CFUN_CONVERSION_ERROR_HANDLER;

   handler = ___ps->temp4;

   if (___FALSEP(handler))
     ___JUMPPRM(___SET_NARGS(na+3),
                ___PRMCELL(___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary.prm))
   else
     ___JUMPEXTNOTSAFE(___SET_NARGS(na+3), handler)

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

   ___SET_R0(___ps->internal_return)

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

   ___SET_R0(___ps->internal_return)

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

   ___WORD na;
   ___WORD i;

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

   ___WORD na;
   ___WORD i;
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

   ___WORD na;
   ___WORD i;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   /* ___ps->temp1 points to the entry point of the procedure */

   if (___HD_TYP(___SUBTYPED_HEADER(___ps->temp1)) == ___PERM)
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
    * This is the rest parameter handler.  It is invoked when a
    * rest parameter must be constructed.
    */

   ___WORD np;
   ___WORD na;
   ___WORD i;
   ___SCMOBJ rest_param_list;

   np = ___PRD_NBPARMS(___SUBTYPED_HEADER(___ps->temp1));
   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   if (na < np-1)
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

   ___WORD np;
   ___WORD na;
   ___WORD nb_req_opt;
   ___WORD nb_key;
   ___WORD i;
   ___WORD j;
   ___WORD k;
   ___WORD fnk;
   ___SCMOBJ key_descr;
   ___SCMOBJ key_vals[___MAX_NB_PARMS];

   np = ___PRD_NBPARMS(___SUBTYPED_HEADER(___ps->temp1));
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

   ___WORD np;          /* number of formal parameters */
   ___WORD na;          /* number of arguments of the call */
   ___WORD nb_req_opt;  /* number of required or optional parameters */
   ___WORD nb_key;      /* number of keyword parameters */
   ___WORD i;
   ___WORD j;
   ___WORD k;
   ___WORD fnk;
   ___SCMOBJ key_descr;
   ___SCMOBJ key_vals[___MAX_NB_PARMS];
   ___SCMOBJ rest_param_list;

   np = ___PRD_NBPARMS(___SUBTYPED_HEADER(___ps->temp1));
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
   int fs;

   ra = ___ps->temp1;
   promise = ___ps->temp2;

   /* setup internal return continuation frame */

   ___RETI_GET_CFS(ra,fs)

   ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

   ___PUSH_REGS /* push all GVM registers (live or not) */
   ___PUSH(ra)  /* push return address */

   ___ADJFP(-___RETI_RA)

   ___SET_R0(___ps->internal_return)

   /* tail call to ##force-out-of-line */

   ___PUSH_ARGS1(promise)

   ___JUMPPRM(___SET_NARGS(1),
              ___PRMCELL(___G__23__23_force_2d_out_2d_of_2d_line.prm))

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

#ifndef ___SINGLE_THREADED_VMS

     if (!___FIXEQ(___FIELD(unwind_destination,1),
                   ___FIX(___PROCESSOR_ID(___ps,___VMSTATE_FROM_PSTATE(___ps)))))
       {
         /* not the same processor that created frame */
         ___COVER_RETURN_TO_C_HANDLER_WRONG_PROCESSOR;
         ___SET_R0(___ps->handler_return_to_c)
         ___SET_R1(___FIELD(unwind_destination,1))
         ___JUMPPRM(___SET_NARGS(1),
                    ___PRMCELL(___G__23__23_c_2d_return_2d_on_2d_other_2d_processor.prm))
       }
     else

#endif

     if (___FALSEP(___FIELD(unwind_destination,0)))
       {
         /* not first return */
         ___COVER_RETURN_TO_C_HANDLER_MULTIPLE_RETURN;
         ___SET_R0(___ps->handler_return_to_c)
         ___JUMPPRM(___SET_NARGS(0),
                    ___PRMCELL(___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception.prm))
       }
     else
       {
         ___COVER_RETURN_TO_C_HANDLER_FIRST_RETURN;
         ___FRAME_STORE_RA(___ps->handler_return_to_c)
         ___W_ALL
         ___throw_error (___PSP ___FIX(___UNWIND_C_STACK));  /* jump back inside ___call */
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
    * is not on top of the stack because it has been captured or
    * the frame was created following a stack section overflow.
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
    *          +------------+             +------------+    +------------+  |
    *                                                                       V
    *                                                                      ...
    *
    * These cases are distinguished by the tag on the pointer to the
    * caller's frame (i.e. 'call frame').
    *
    * If the break frame was created following a stack section overflow
    * it will be the first of a new stack section.  In this case the break
    * handler simply sets the stack pointer to the caller's frame and
    * resumes execution at the return address in the caller's frame.
    *
    * Otherwise, the break handler puts a copy of the caller's frame on
    * the top of the stack except that the slot 'link' is set to the
    * address of the break handler.  The frame pointer in the break frame
    * is modified so that it points to the frame of the caller's caller.
    * Finally a jump to the return address in the caller's frame (ret_adr1)
    * is performed.  At that point the stack will be in the following state
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

       ___W_FP
       ra1 = ___stack_overflow_undo_if_possible (___PSPNC);
       ___R_FP

       if (ra1 == ___FAL)
         {
           /*
            * The caller's frame must be copied to the top of stack.
            */

           ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

           if (ra1 == ___ps->internal_return)
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

           if (ra2 == ___ps->handler_break)
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
               ___SET_STK(link+1,___ps->handler_break)
             }

           ___ADJFP(___FRAME_SPACE(fs))
         }
     }
   else
     {
       /* caller's frame is in the heap */

       fp = ___BODY_AS(cf,___tSUBTYPED); /* get pointer to frame's body */

       ra1 = fp[___FRAME_RA];

       if (ra1 == ___ps->internal_return)
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
       ___SET_STK(link+1,___ps->handler_break)

       ___ADJFP(___FRAME_SPACE(fs))
     }

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

   /* save result in case we are returning from ##force-out-of-line */

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

))

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

;;;----------------------------------------------------------------------------

;;; List and vector utilities.

(define-prim (##assq-cdr obj lst) ;; TODO: move elsewhere
  (let loop ((x lst))
    (if (##pair? x)
        (let ((couple (##car x)))
          (if (##eq? obj (##cdr couple))
              couple
              (loop (##cdr x))))
        #f)))

(define-prim (##assq obj lst) ;; TODO: move elsewhere
  (let loop ((x lst))
    (if (##pair? x)
        (let ((couple (##car x)))
          (if (##eq? obj (##car couple))
              couple
              (loop (##cdr x))))
        #f)))

(define-prim (##append-reverse! lst tail)
  (let loop ((prev tail) (curr lst))
    (if (##pair? curr)
        (let ((next (##cdr curr)))
          (##set-cdr! curr prev)
          (loop curr next))
        prev)))

(define-prim (##reverse! lst)
  (##append-reverse! lst '()))

(define-prim (##vector-last vect)
  (##vector-ref vect (##fx- (##vector-length vect) 1)))

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

(define-prim (##interrupt-handler)

  (##declare (not interrupts-enabled))

  (let loop ()
    (let ((id
           (##c-code
            "___RESULT = ___EXT(___service_interrupts_pstate) (___ps);")))
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

(define ##interrupt-vector
  (##vector ##sync-op-interrupt! #f #f #f #f #f #f))

(define-prim (##interrupt-vector-set! code handler)
  (##declare (not interrupts-enabled))
  (##vector-set! ##interrupt-vector code handler)
  (##void))

;;;----------------------------------------------------------------------------

;; The heartbeat is used to implement preemptive multithreading by
;; generating interrupts at regular intervals. The procedure
;; (##set-heartbeat-interval! seconds) sets the heartbeat
;; interrupt interval to the time closest to "seconds" seconds (a
;; flonum value). If "seconds" is negative, the heartbeat interrupt is
;; turned off.  If "seconds" is zero, the smallest possible interval
;; is used.  The procedure (##get-heartbeat-interval! u64vect i) is
;; used to retrieve the current heartbeat interval.

(define-prim (##get-heartbeat-interval! floats i)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___F64VECTORSET(___ARG1,
                   ___ARG2,
                   ___get_heartbeat_interval ());

   ___RESULT = ___VOID;

end-of-code

   floats
   i))

(define-prim (##set-heartbeat-interval! seconds)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___set_heartbeat_interval (___FLONUM_VAL(___ARG1));

   ___RESULT = ___VOID;

end-of-code

   seconds))

;;;----------------------------------------------------------------------------

;; High-level interrupts are handled by the Scheme thread scheduler on a
;; specific processor.

(define-prim (##raise-high-level-interrupt processor-id intr)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___processor_state ps =
     ___PSTATE_FROM_PROCESSOR_ID(___INT(___ARG1),
                                 ___VMSTATE_FROM_PSTATE(___ps));

   ___raise_high_level_interrupt_pstate (ps, ___ARG2);

   ___RESULT = ___VOID;

end-of-code

   processor-id
   intr))

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

(implement-library-type-wrong-number-of-values-exception)

(define-prim (##raise-wrong-number-of-values-exception vals code rte)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-wrong-number-of-values-exception vals code rte)))

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
      (cond ((##fx= code ##err-code-ENOENT)
             (macro-make-no-such-file-or-directory-exception procedure arguments))
            ((##fx= code ##err-code-EEXIST)
             (macro-make-file-exists-exception procedure arguments))
            ((##fx= code ##err-code-EACCES)
             (macro-make-permission-denied-exception procedure arguments))
            (else
             (macro-make-os-exception procedure arguments message code)))))))

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

(implement-library-type-file-exists-exception)

(define-prim (##raise-file-exists-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-file-exists-exception
       procedure
       arguments)))))

(implement-library-type-permission-denied-exception)

(define-prim (##raise-permission-denied-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-permission-denied-exception
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

(implement-library-type-wrong-processor-c-return-exception)

(define-prim (##raise-wrong-processor-c-return-exception)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-constant-wrong-processor-c-return-exception)))

(define ##c-return-on-other-processor-hook #f)

(define-prim (##c-return-on-other-processor-hook-set! x)
  (set! ##c-return-on-other-processor-hook x))

(define-prim (##c-return-on-other-processor id)
  (##declare (not interrupts-enabled))
  (let ((proc ##c-return-on-other-processor-hook))
    (if (##procedure? proc)
        (proc id)
        (##raise-wrong-processor-c-return-exception))))

(implement-library-type-number-of-arguments-limit-exception)

(define-prim (##raise-number-of-arguments-limit-exception proc args)
  (##declare (not interrupts-enabled))
  (macro-raise
   (macro-make-number-of-arguments-limit-exception proc args)))

))

;;; Implementation of promises.

(define-prim (##force-out-of-line promise)

  (declare (not interrupts-enabled))

  (define-macro (macro-reentrant-semantics? state) #t)

  (define (nonreentrant-undetermined-case promise)
    (error "Attempt to reenter nonreentrant promise" promise))

  (define (chase promise thunk)
    (let ((result1 ;; compute promise's value by calling thunk
           (let ()
             (declare (interrupts-enabled))
             (thunk))))
      (let ((state1 (##promise-state promise)))
        (cond ((and (macro-reentrant-semantics? state1)
                    (##not (##eq? state1 ;; is it determined now?
                                  (##vector-ref state1 0))))
               (##vector-ref state1 0)) ;; ignore thunk's result
              ((##not (##promise? result1))
               (##vector-set! state1 0 result1) ;; cache promise's value
               (if (macro-reentrant-semantics? state1)
                   (##vector-set! state1 1 #f))
               result1)
              (else
               ;; result1 is a promise, so we need to force it
               (let* ((state2 (##promise-state result1))
                      (result2 (##vector-ref state2 0)))
                 (cond ((##not (##eq? state2 result2)) ;; is it determined?
                        (##vector-set! state1 0 result2) ;; cache promise's value
                        (if (macro-reentrant-semantics? state1)
                            (##vector-set! state1 1 #f))
                        result2)
                       (else
                        (let ((t (##vector-ref state2 1)))
                          (##promise-state-set! result1 state1) ;; link states
                          (cond ((macro-reentrant-semantics? state2)
                                 (##vector-set! state1 1 t)
                                 (chase promise t))
                                ((##not t)
                                 (nonreentrant-undetermined-case promise))
                                (else
                                 ;; avoid space leak through thunk
                                 (if (macro-reentrant-semantics? state2)
                                     (##vector-set! state2 1 #f))
                                 (chase promise t))))))))))))

  (let ((state (##promise-state promise)))
    (if (##not (##eq? state (##vector-ref state 0))) ;; is promise determined?
        (##vector-ref state 0) ;; return cached value
        (let ((thunk (##vector-ref state 1)))
          (cond ((macro-reentrant-semantics? state)
                 (chase promise thunk))
                ((##not thunk)
                 (nonreentrant-undetermined-case promise))
                (else
                 ;; avoid space leak through thunk
                 (##vector-set! state 1 #f)
                 (chase promise thunk)))))))

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

          ___WORD exec_wills = ___ps->mem.executable_wills_;

          if (___UNTAG(exec_wills) == 0) /* end of list? */
            ___RESULT = ___FAL;
          else
            {
              ___WORD will = ___SUBTYPED_FROM_START(___UNTAG(exec_wills));
              ___ps->mem.executable_wills_ = ___FIELD(will,___WILL_NEXT);
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

(define-prim (##handle-gc-interrupt!)
  (##declare (not interrupts-enabled))
  (##gc-finalize!)
  (##execute-jobs! ##gc-interrupt-jobs))

(define-prim (##intr-gc-handler-set! handler)
  (##interrupt-vector-set! 4 handler)) ;; ___INTR_GC

(define ##feature-intr-gc
  (##intr-gc-handler-set! ##handle-gc-interrupt!))

(macro-case-target
 ((C)
  ##feature-intr-gc)
 (else))

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

(define-prim (##get-debug-settings)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_debug_settings ());"))

(define-prim (##set-debug-settings! mask new-settings)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT =
      ___FIX(___set_debug_settings (___INT(___ARG1), ___INT(___ARG2)));"
   mask
   new-settings))

(define-prim (##get-io-settings index)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___FIX(___get_io_settings (___INT(___ARG1)));"
   index))

(define-prim (##set-io-settings! index settings)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_io_settings (___INT(___ARG1), ___INT(___ARG2)); ___RESULT = ___VOID;"
   index
   settings))

(define-prim ##get-gambitdir
  (c-lambda ()
            UCS-2-string
    "___return(___get_gambitdir ());"))

(define-prim ##set-gambitdir!
  (c-lambda (UCS-2-string)
            void
    "___set_gambitdir (___arg1);"))

(define-prim ##get-gambitdir-map
  (c-lambda ()
            nonnull-UCS-2-string-list
    "___return(___get_gambitdir_map ());"))

(define-prim ##set-gambitdir-map!
  (c-lambda (nonnull-UCS-2-string-list)
            void
    "___set_gambitdir_map (___arg1);"))

(define-prim ##get-module-search-order
  (c-lambda ()
            nonnull-UCS-2-string-list
    "___return(___get_module_search_order ());"))

(define-prim ##set-module-search-order!
  (c-lambda (nonnull-UCS-2-string-list)
            void
    "___set_module_search_order (___arg1);"))

(define-prim ##get-module-whitelist
  (c-lambda ()
            nonnull-UCS-2-string-list
    "___return(___get_module_whitelist ());"))

(define-prim ##set-module-whitelist!
  (c-lambda (nonnull-UCS-2-string-list)
            void
    "___set_module_whitelist (___arg1);"))

(define-prim (##get-module-install-mode)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___FIX(___get_module_install_mode ());"))

(define-prim (##set-module-install-mode! settings)
  (##declare (not interrupts-enabled))
  (##c-code
   "___set_module_install_mode (___INT(___ARG1)); ___RESULT = ___VOID;"
   settings))

(define-prim ##get-repl-client-addr
  (c-lambda ()
            UCS-2-string
    "___return(___get_repl_client_addr ());"))

(define-prim ##set-repl-client-addr!
  (c-lambda (UCS-2-string)
            void
    "___set_repl_client_addr (___arg1);"))

(define-prim ##get-repl-server-addr
  (c-lambda ()
            UCS-2-string
    "___return(___get_repl_server_addr ());"))

(define-prim ##set-repl-server-addr!
  (c-lambda (UCS-2-string)
            void
    "___set_repl_server_addr (___arg1);"))

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

(define-prim (##cpu-cycle-count-start) 0)
(define-prim (##cpu-cycle-count-end)   0)

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
___WORD head = ___HEADER(___ARG1);
___FRAME_STORE_RA(___R0)
___W_ALL
result = ___EXT(___alloc_scmobj) (___ps, ___HD_SUBTYPE(head), ___HD_BYTES(head));
___R_ALL
___SET_R0(___FRAME_FETCH_RA)
if (!___FIXNUMP(result))
  {
    ___SIZE_TS words = ___HD_WORDS(head);
    ___WORD *body1 = ___BODY(___ARG1);
    ___WORD *body2 = ___BODY(result);
    while (words > 0)
      {
        *body2++ = *body1++;
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

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_WORDS(n, ___sVECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result))
  {
    if (fill == ___ABSENT)
      fill = ___FIX(0);
    for (i=0; i<n; i++)
      ___VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-vector k fill))
      v)))

(define-prim (##make-string k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((s (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<___LCS), ___sSTRING));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___STRINGSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? s)
      (begin
        (##raise-heap-overflow-exception)
        (##make-string k fill))
      s)))

(define-prim (##make-u8vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES(n, ___sU8VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U8VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u8vector k fill))
      v)))

(macro-if-s8vector
(define-prim (##make-s8vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES(n, ___sS8VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S8VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s8vector k fill))
      v))))

(macro-if-u16vector
(define-prim (##make-u16vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<1), ___sU16VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U16VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u16vector k fill))
      v))))

(macro-if-s16vector
(define-prim (##make-s16vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<1), ___sS16VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S16VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s16vector k fill))
      v))))

(macro-if-u32vector
(define-prim (##make-u32vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sU32VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U32VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u32vector k fill))
      v))))

(macro-if-s32vector
(define-prim (##make-s32vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sS32VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S32VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s32vector k fill))
      v))))

(macro-if-u64vector
(define-prim (##make-u64vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<3)) + ___SUBTYPED_BODY;

#if ___WS == 4
    words++;
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
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sU64VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U64VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-u64vector k fill))
      v))))

(macro-if-s64vector
(define-prim (##make-s64vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<3)) + ___SUBTYPED_BODY;

#if ___WS == 4
    words++;
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
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sS64VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S64VECTORSET(result,___FIX(i),fill);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-s64vector k fill))
      v))))

(macro-if-f32vector
(define-prim (##make-f32vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
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
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sF32VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    ___F64 fill_f64 = ___F64UNBOX(fill);
    for (i=0; i<n; i++)
      ___F32VECTORSET(result,___FIX(i),fill_f64);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-f32vector k fill))
      v))))

(define-prim (##make-f64vector k #!optional (fill (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code

___SCMOBJ k;
___SCMOBJ fill;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS2(k,fill);
___ps->saved[0] = k;
___ps->saved[1] = fill;
n = ___INT(k);
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<3)) + ___SUBTYPED_BODY;

#if ___WS == 4
    words++;
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
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sF64VECTOR));
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
fill = ___ps->saved[1];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
if (!___FIXNUMP(result) && fill != ___ABSENT)
  {
    ___F64 fill_f64 = ___F64UNBOX(fill);
    for (i=0; i<n; i++)
      ___F64VECTORSET(result,___FIX(i),fill_f64);
  }
___RESULT = result;
___PUSH_ARGS2(k,fill);

end-of-code
)))
    (if (##fixnum? v)
      (begin
        (##raise-heap-overflow-exception)
        (##make-f64vector k fill))
      v)))

  (define-prim (##make-values k #!optional (fill 0))
    ;; Note: this will create a box object when k = 1
    (let ((vals (##make-vector k fill)))
      (##subtype-set! vals (macro-subtype-boxvalues))
      vals))

)

  (else

   (define-prim (##make-vector k #!optional (fill 0))
     (##make-vector k fill))

   (define-prim (##make-string k #!optional (fill #\nul))
     (##make-string k fill))

   (define-prim (##make-u8vector k #!optional (fill 0))
     (##make-u8vector k fill))

   (macro-if-s8vector
   (define-prim (##make-s8vector k #!optional (fill 0))
     (##make-s8vector k fill)))

   (macro-if-u16vector
   (define-prim (##make-u16vector k #!optional (fill 0))
     (##make-u16vector k fill)))

   (macro-if-s16vector
   (define-prim (##make-s16vector k #!optional (fill 0))
     (##make-s16vector k fill)))

   (macro-if-u32vector
   (define-prim (##make-u32vector k #!optional (fill 0))
     (##make-u32vector k fill)))

   (macro-if-s32vector
   (define-prim (##make-s32vector k #!optional (fill 0))
     (##make-s32vector k fill)))

   (macro-if-u64vector
   (define-prim (##make-u64vector k #!optional (fill 0))
     (##make-u64vector k fill)))

   (macro-if-s64vector
   (define-prim (##make-s64vector k #!optional (fill 0))
     (##make-s64vector k fill)))

   (macro-if-f32vector
   (define-prim (##make-f32vector k #!optional (fill 0.0))
     (##make-f32vector k fill)))

   (define-prim (##make-f64vector k #!optional (fill 0.0))
     (##make-f64vector k fill))

   (define-prim (##make-values k #!optional (fill 0))
     (##make-values k fill))

))

(macro-case-target

 ((C)

(define-prim (##make-machine-code-block x)
  ((c-lambda (scheme-object)
             (pointer void)
     #<<end-of-code

     if (___FIXNUMP(___arg1))
       {
         ___return(___alloc_mem_code (___INT(___arg1)));
       }
     else
       {
         int len = ___INT(___U8VECTORLENGTH(___arg1));
         void *mcb = ___alloc_mem_code (len);
         if (mcb != 0)
           memmove (mcb, ___BODY_AS(___arg1,___tSUBTYPED), len);
         ___return(mcb);
       }

end-of-code
)
   x))

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

(define-prim (##machine-code-block-fixup mcb fixup-locs fixup-objs)
  ((c-lambda ((nonnull-pointer void) scheme-object scheme-object)
             scheme-object
     #<<end-of-code

     ___return(___machine_code_block_fixup (___ps, ___arg1, ___arg2, ___arg3));

end-of-code
)
   mcb
   fixup-locs
   fixup-objs))

(define-prim (##machine-code-fixup code fixup-locs fixup-objs)
  (##machine-code-block-fixup
   (##make-machine-code-block code)
   fixup-locs
   fixup-objs))

;;;----------------------------------------------------------------------------

;;; Apply.

(define-prim (##apply proc arg1 . rest)

  (##declare (not inline))

  (define (app proc args)
    (##declare (not interrupts-enabled))
    (##c-code #<<end-of-code

     ___SCMOBJ proc;
     ___SCMOBJ args;
     ___SCMOBJ lst;
     ___WORD na;

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

  (if (##pair? rest)

      (let loop ((prev arg1) (lst rest))
        (let ((temp (##car lst)))
          (##set-car! lst prev)
          (let ((tail (##cdr lst)))
            (if (##pair? tail)
                (loop temp tail)
                (begin
                  (##set-cdr! lst temp)
                  (app proc rest))))))

      (app proc arg1)))

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
  (##c-code
   "___RESULT = ___subprocedure_id (___ARG1);"
   proc))

(define-prim (##subprocedure-parent proc)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___subprocedure_parent (___ARG1);"
   proc))

(define-prim (##subprocedure-nb-parameters proc)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___subprocedure_nb_parameters (___ARG1);"
   proc))

(define-prim (##subprocedure-nb-closed proc)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___subprocedure_nb_closed (___ARG1);"
   proc))

(define-prim (##make-subprocedure parent id)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___make_subprocedure (___ARG1, ___ARG2);"
   parent
   id))

(define-prim (##subprocedure-parent-info proc)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___subprocedure_parent_info (___ARG1);"
   proc))

(define-prim (##subprocedure-parent-name proc)
  (##declare (not interrupts-enabled))
  (##c-code
   "___RESULT = ___subprocedure_parent_name (___ARG1);"
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

   if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
         ra = ___FIELD(frame,___FRAME_RETI_RA);
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___ps->internal_return)
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

   if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
         ___RETI_GET_FS(___FIELD(frame,___FRAME_RETI_RA),fs)
       else
         ___RETN_GET_FS(ra,fs)
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___ps->internal_return)
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

   if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___ps->internal_return)
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

   if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
         ___RETI_GET_FS_LINK_GCMAP(___FIELD(frame,___FRAME_RETI_RA),fs,link,gcmap,nextgcmap)
       else
         ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___ps->internal_return)
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

   if (ra == ___ps->internal_return)
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

   if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___BODY_AS(frame,___tSUBTYPED)[fs-i+1] = val;  /* what if i==link and frame is first in section???? */
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___ps->internal_return)
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

       if (ra == ___ps->internal_return)
         ___RETI_GET_FS_LINK(fp[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       fp += fs+1;

       if (ra == ___ps->dynamic_env_bind_return)
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

       if (ra == ___ps->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       fp = ___CAST(___SCMOBJ*,frame)+___FRAME_SPACE(fs);
       frame_ra = fp[-link-1];

       if (ra == ___ps->dynamic_env_bind_return)
         denv = fp[-DYNAMIC_ENV_BIND_DENV];

       if (frame_ra == ___ps->handler_break)
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

(define-prim (##continuation-last cont)
  (let loop ((cont cont))
    (let ((next (##continuation-next cont)))
      (if next
          (loop next)
          cont))))

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

(define-prim (##symkey-table-foldl f base symkey-table)
  (let loop1 ((i (##fx- (##vector-length symkey-table) 1)) ;; skip element 0 = count
              (result base))
    (if (##fx> i 0)
        (let loop2 ((symkey (##vector-ref symkey-table i))
                    (result result))
          (if (##subtyped? symkey)
              (loop2 (##vector-ref symkey 2) ;; next in bucket
                     (f result symkey))
              (loop1 (##fx- i 1)
                     result)))
        result)))

(define-prim (##symbol-table-foldl f base)
  (##symkey-table-foldl f base (##symbol-table)))

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
   "___RESULT = ___obj_to_global_var (___PSP ___ARG1, !___FALSEP(___ARG2));"
   obj
   primitive?))

(define-prim (##global-var->identifier gv)
  gv)

(define-prim (##global-var-table-foldl f base)
  (##symbol-table-foldl
   (lambda (lst sym)
     (if (and (##global-var? sym)
              (##not (##unbound? (##global-var-ref sym))))
         (f lst sym)
         lst))
   base))

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

(define ##default-compile-options-string
  (macro-case-target

   ((C)
    ((c-lambda () nonnull-UCS-2-string #<<end-of-code

#ifndef ___DEFAULT_COMPILE_OPTIONS
#define ___DEFAULT_COMPILE_OPTIONS {'\0'}
#endif

static ___UCS_2 default_compile_options[] = ___DEFAULT_COMPILE_OPTIONS;

___return(default_compile_options);

end-of-code
)))

   (else
    "")))

(define-prim (##default-compile-options-string-set! x)
  (set! ##default-compile-options-string x))

;;;----------------------------------------------------------------------------

;;; Miscellaneous definitions.

(define ##err-code-ENOENT
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(ENOENT));"))

(define ##err-code-EINTR
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(EINTR));"))

(define ##err-code-EACCES
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(EACCES));"))

(define ##err-code-EEXIST
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(EEXIST));"))

(define ##err-code-EAGAIN
  (##c-code "___RESULT = ___FIX(___ERRNO_ERR(EAGAIN));"))

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
      ___F64 ba = ___bytes_allocated (___PSPNC);

      n = ba - n;

      ___process_times (&user, &sys, &real);
      ___vm_stats (&minflt, &majflt);

      ___F64VECTORSET(result,___FIX(0),user)
      ___F64VECTORSET(result,___FIX(1),sys)
      ___F64VECTORSET(result,___FIX(2),real)
      ___F64VECTORSET(result,___FIX(3),___vms->mem.gc_user_time_)
      ___F64VECTORSET(result,___FIX(4),___vms->mem.gc_sys_time_)
      ___F64VECTORSET(result,___FIX(5),___vms->mem.gc_real_time_)
      ___F64VECTORSET(result,___FIX(6),___vms->mem.nb_gcs_)
      ___F64VECTORSET(result,___FIX(7),ba)
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
             ssize_t
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

(define-prim ##os-path-tempdir
  (c-lambda ()
            scheme-object
   "___os_path_tempdir"))

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

(define-prim ##os-executable-path
  (c-lambda ()
            scheme-object
   "___os_executable_path"))

(define-prim ##repl-server-addr
  (c-lambda ()
            UCS-2-string
   "___return(___GSTATE->setup_params.repl_server_addr);"))

(define-prim ##repl-client-addr
  (c-lambda ()
            UCS-2-string
   "___return(___GSTATE->setup_params.repl_client_addr);"))

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

(define-prim ##os-device-open-raw-from-fd
  (c-lambda (scheme-object  ;; fd
             scheme-object) ;; flags
            scheme-object   ;; device
   "___os_device_raw_open_from_fd"))

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
  (c-lambda (scheme-object  ;; local_addr
             scheme-object  ;; local_port_num
             scheme-object  ;; addr
             scheme-object  ;; port_num
             scheme-object  ;; options
             scheme-object  ;; tls_context
             scheme-object) ;; server_name
            scheme-object   ;; device
   "___os_device_tcp_client_open"))

(define-prim ##os-device-tcp-client-socket-info
  (c-lambda (scheme-object  ;; dev
             scheme-object) ;; peer
            scheme-object   ;; addr
   "___os_device_tcp_client_socket_info"))

(define-prim ##os-device-tcp-server-open
  (c-lambda (scheme-object  ;; local_addr
             scheme-object  ;; local_port_num
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
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; addr
   "___os_device_tcp_server_socket_info"))

(define-prim ##os-device-udp-open
  (c-lambda (scheme-object  ;; local_addr
             scheme-object  ;; local_port_num
             scheme-object) ;; options
            scheme-object   ;; device
   "___os_device_udp_open"))

(define-prim ##os-device-udp-read-subu8vector
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object  ;; buffer
             scheme-object  ;; lo
             scheme-object) ;; hi
            scheme-object   ;; u8vector or fixnum = bytes read or error code
   "___os_device_udp_read_subu8vector"))

(define-prim ##os-device-udp-write-subu8vector
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object  ;; buffer
             scheme-object  ;; lo
             scheme-object) ;; hi
            scheme-object   ;; fixnum = bytes written or error code
   "___os_device_udp_write_subu8vector"))

(define-prim ##os-device-udp-destination-set!
  (c-lambda (scheme-object  ;; dev_condvar
             scheme-object  ;; addr
             scheme-object) ;; port_num
            scheme-object   ;; fixnum error code
   "___os_device_udp_destination_set"))

(define-prim ##os-device-udp-socket-info
  (c-lambda (scheme-object  ;; dev
             scheme-object) ;; source
            scheme-object   ;; addr
   "___os_device_udp_socket_info"))

(define-prim ##os-device-udp-socket-receive-buffer-size
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; size
   "___os_device_udp_socket_receive_buffer_size"))

(define-prim ##os-device-udp-socket-send-buffer-size
  (c-lambda (scheme-object) ;; dev
            scheme-object   ;; size
   "___os_device_udp_socket_send_buffer_size"))

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

(define-prim ##os-device-tty-mode-reset
  (c-lambda ()
            scheme-object
   "___os_device_tty_mode_reset"))

(define-prim (##os-condvar-select! devices timeout)
  (##declare (not interrupts-enabled))
  (##c-code #<<end-of-code

   ___SCMOBJ result;

   ___FRAME_STORE_RA(___R0)
   ___W_ALL

   result = ___os_condvar_select (___ARG1, ___ARG2);

   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

   ___RESULT = result;

end-of-code

   devices
   timeout))

(define-prim (##device-select-abort! processor)
  (##declare (not interrupts-enabled))
  (##c-code
   "___device_select_abort (___PSTATE_FROM_PROCESSOR_ID(___INT(___ARG1),___VMSTATE_FROM_PSTATE(___ps))); ___RESULT = ___VOID;"
   processor))

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
             scheme-object
             scheme-object)
            scheme-object
   "___os_file_info"))

(define-prim ##os-user-info
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_user_info"))

(define-prim ##os-user-name
  (c-lambda ()
            scheme-object
   "___os_user_name"))

(define-prim ##os-group-info
  (c-lambda (scheme-object
             scheme-object)
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
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_host_info"))

(define-prim ##os-host-name
  (c-lambda ()
            scheme-object
   "___os_host_name"))

(define-prim ##os-service-info
  (c-lambda (scheme-object
             scheme-object
             scheme-object)
            scheme-object
   "___os_service_info"))

(define-prim ##os-protocol-info
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_protocol_info"))

(define-prim ##os-network-info
  (c-lambda (scheme-object
             scheme-object)
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
             scheme-object
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

(macro-case-target

 ((C)

(define-prim (##exit-with-err-code-no-cleanup err-code)
  (##c-code #<<end-of-code

   ___propagate_error (___PSP ___ARG1);
   ___RESULT = ___VOID; /* never reached */

end-of-code

   err-code))

))

(define ##exit-jobs (##make-jobs))

;;; (##add-exit-job! thunk) can be called to add a job to
;;; do when the program exits.  (##clear-exit-jobs!) clears the jobs.

(define-prim (##add-exit-job! thunk)
  (##add-job! ##exit-jobs thunk))

(define-prim (##clear-exit-jobs!)
  (##clear-jobs! ##exit-jobs))

(define ##cleaning-up? #f)

(define-prim (##exit-cleanup)
  (let ((is-in-cleanup? ##cleaning-up?))
    (set! ##cleaning-up? #t) ;; only do cleanup once
    (if (##not is-in-cleanup?)
        (begin
          (##execute-and-clear-jobs! ##exit-jobs)
          (##execute-final-wills!)))))

(define-prim (##exit-with-err-code err-code)
  (##exit-cleanup)
  (##exit-with-err-code-no-cleanup err-code))

(define-prim (##exit #!optional (status (macro-EXIT-CODE-OK)))
  (##exit-with-err-code (##fx+ status 1)))

(define-prim (##exit-abruptly #!optional (status (macro-EXIT-CODE-SOFTWARE)))
  (##exit-with-err-code-no-cleanup (##fx+ status 1)))

(define-prim (##exit-with-exception exc)
  (##exit (macro-EXIT-CODE-SOFTWARE)))

(define-prim (##intr-terminate-handler-set! handler)
  (##interrupt-vector-set! 1 handler)) ;; ___INTR_TERMINATE

(define ##feature-intr-terminate
  (##intr-terminate-handler-set! ##exit-abruptly))

(macro-case-target
 ((C)
  ##feature-intr-terminate)
 (else))

;;;----------------------------------------------------------------------------

(define-prim (##first-argument arg1 #!optional arg2 arg3 #!rest others)
  arg1)

(define-prim (##with-no-result-expected thunk)
  (##declare (not interrupts-enabled))
  (##first-argument (thunk))) ;; force nontail-call to thunk

(define-prim (##with-no-result-expected-toplevel thunk)
  (##declare (not interrupts-enabled))
  (##first-argument (thunk))) ;; force nontail-call to thunk

(define-prim (##dead-end)
  (##declare (interrupts-enabled))
  (##dead-end)) ;; endless loop

(define-prim (dead-end)
  (##dead-end)) ;; endless loop

(define-prim (##poll-point) ;; TODO: add a corresponding inlined primitive
  (##declare (interrupts-enabled) (not inline)) ;; make sure the poll point is generated
  (define (dummy) (##void))
  (dummy))

(define-prim (poll-point) ;; TODO: add a corresponding inlined primitive
  (##declare (interrupts-enabled) (not inline)) ;; make sure the poll point is generated
  (define (dummy) (##void))
  (dummy))

;;;----------------------------------------------------------------------------

;;; Version information.

(define-prim&proc (system-version)

  (##define-macro (comp-version)
    (c#compiler-version))

  (comp-version))

(define ##os-system-version-string-saved
  (let ()

    (##define-macro (comp-system-version-string)
      (system-version-string))

    (macro-case-target
     ((C)
      (or ((c-lambda () char-string "___return(___STAMP_VERSION);"))
          (comp-system-version-string)))
     (else
      (comp-system-version-string)))))

(define-prim&proc (system-version-string)
  ##os-system-version-string-saved)

(define ##os-system-type-saved
  (let ()

    (define (str-list->sym-list lst)
      (if (##null? lst)
          '()
          (##cons (##make-interned-symbol (##car lst))
                  (str-list->sym-list (##cdr lst)))))

    (macro-case-target
     ((C)
      (str-list->sym-list
       ((c-lambda ()
                  nonnull-char-string-list
          "___os_system_type"))))
     (else
      '(unknown system type)))))

(define-prim&proc (system-type)
  ##os-system-type-saved)

(define ##os-system-type-string-saved
  (macro-case-target
   ((C)
    ((c-lambda ()
               nonnull-char-string
      "___os_system_type_string")))
   (else
    "unknown-system-type")))

(define-prim&proc (system-type-string)
  ##os-system-type-string-saved)

(define ##os-configure-command-string-saved
  (let ()

    (##define-macro (comp-configure-command-string)
      (configure-command-string))

    (macro-case-target
     ((C)
      ((c-lambda ()
                 nonnull-char-string
        "___os_configure_command_string")))
     (else
      (comp-configure-command-string)))))

(define-prim&proc (configure-command-string)
  ##os-configure-command-string-saved)

(define ##system-stamp-saved
  (let ()

    (##define-macro (comp-system-stamp)
      (system-stamp))

    (macro-case-target
     ((C)
      ((c-lambda ()
                 unsigned-int64
        "___return(___U64_add_U64_U64
                   (___U64_mul_UM32_UM32 (___STAMP_YMD, 1000000),
                    ___U64_from_UM32 (___STAMP_HMS)));")))
     (else
      (comp-system-stamp)))))

(define-prim&proc (system-stamp)
  ##system-stamp-saved)

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

(define-prim (##structure-set obj val i type proc)
  (if (##structure-instance-of? obj (##type-id type))
    (let ((result (##structure-copy obj)))
      (##unchecked-structure-set! result val i type proc)
      result)
    (##raise-type-exception
     1
     type
     (if proc proc ##structure-set)
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

(define-prim (##direct-structure-set obj val i type proc)
  (if (##structure-direct-instance-of? obj (##type-id type))
    (let ((result (##structure-copy obj)))
      (##unchecked-structure-set! result val i type proc)
      result)
    (##raise-type-exception
     1
     type
     (if proc proc ##direct-structure-set)
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

(define-prim (##unchecked-structure-cas! obj val oldval i type proc))

(define-prim (##structure-copy obj)
  (let* ((len (##structure-length obj))
         (type (##structure-type obj))
         (result (##make-structure type len)))
    (let loop ((i (##fx- len 1)))
      (if (##fx> i 0)
          (begin
            (##unchecked-structure-set!
             result
             (##unchecked-structure-ref obj i type ##structure-copy)
             i
             type
             ##structure-copy)
            (loop (##fx- i 1)))
          result))))

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

  (define ##vm-main-module-ref
    (##c-code "___RESULT = ___VMSTATE_FROM_PSTATE(___ps)->main_module_ref;"))

  (define-prim (##init-mod module-descr)
    (let ((module-struct (macro-module-descr-module-struct module-descr)))
      (and module-struct
           (##c-code
            "___RESULT = ___CAST(___module_struct*,___FIELD(___ARG1,___FOREIGN_PTR))->init_mod (___PSPNC);"
            module-struct))))

  (##main-set!
   (lambda ()
     (##exit-cleanup))))

 (else

  (define-prim (##init-mod module-descr)
    #f)))

(define ##registered-modules '()) ;; collection of modules registered in the system

(define-prim (##lookup-registered-module module-ref)
  (let ((x (##lookup-module module-ref ##registered-modules)))
    (and x (##car x))))

(define-prim (##remove-registered-module module-ref)
  (let ((x (##lookup-module module-ref ##registered-modules)))
    (and x (##set-car! x #f))))

(define-prim (##lookup-module module-ref modules)
  (let loop ((lst modules))
    (if (##pair? lst)
        (let ((module (##car lst)))
          (if (and module (##eq? module-ref (macro-module-module-ref module)))
              lst
              (loop (##cdr lst))))
        #f)))

(define-prim (##register-module-descr! module-ref module-descr)
  ;; TODO: make manipulation of ##registered-modules atomic
  (let* ((module
          (macro-make-module module-ref module-descr))
         (x
          (##lookup-module module-ref ##registered-modules)))
    (if x
        (##set-car! x module)
        (set! ##registered-modules
              (##cons module
                      ##registered-modules)))
    module))

(define-prim (##register-module-descrs module-descrs)
  (let loop1 ((i 0)
              (preload-module-refs '()))
    (if (##fx< i (##vector-length module-descrs))
        (let* ((module-descr
                (##vector-ref module-descrs i))
               (module-refs
                (macro-module-descr-supply-modules module-descr)))
          (let loop2 ((j 0))
            (if (##fx< j (##vector-length module-refs))
                (let ((module-ref (##vector-ref module-refs j)))
                  (##register-module-descr! module-ref module-descr)
                  (loop2 (##fx+ j 1)))))
          (loop1 (##fx+ i 1)
                 (if (##fx= (##fxand 1 (macro-module-descr-flags module-descr))
                            0)
                     preload-module-refs
                     (##cons (##vector-last module-refs)
                             preload-module-refs))))
        (##reverse! preload-module-refs))))

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

(define-prim (##default-get-module module-ref)
  (or (##lookup-registered-module module-ref)
      (##raise-module-not-found-exception
       ##default-get-module
       module-ref)))

(define ##get-module
  ##default-get-module)

(define-prim (##get-module-set! x)
  (set! ##get-module x))

(define-prim (##collect-modules module-refs
                                #!optional
                                (level 999999)) ;; init up to highest level

  (define visited '()) ;; modules visited to correctly handle circular deps

  (define (visited! module-ref)
    (set! visited (##cons module-ref visited)))

  (define (visited? module-ref)
    (let loop ((lst visited))
      (if (##pair? lst)
          (or (##eq? module-ref (##car lst))
              (loop (##cdr lst)))
          #f)))

  (define (get-modules module-refs)

    (define (add-module module-ref result)
      (if (visited? module-ref)
          result
          (let ((module (##get-module module-ref)))
            (visited! module-ref)
            (if (and module
                     (##fx< (macro-module-stage module) level))
                (##cons module result)
                result))))

    (if (##vector? module-refs)

        (let loop ((i 0)
                   (result '()))
          (if (##fx< i (##vector-length module-refs))
              (loop (##fx+ i 1)
                    (add-module (##vector-ref module-refs i) result))
              result))

        (let loop ((lst module-refs)
                   (result '()))
          (if (##pair? lst)
              (loop (##cdr lst)
                    (add-module (##car lst) result))
              result))))

  (define (collect module-refs collected-modules)
    (let loop ((modules (##reverse! (get-modules module-refs)))
               (collected-modules collected-modules))
      (if (##pair? modules)
          (loop (##cdr modules)
                (let ((module (##car modules)))
                  (##cons module
                          (collect (macro-module-descr-demand-modules
                                    (macro-module-module-descr module))
                                   collected-modules))))
          collected-modules)))

  (##reverse! (collect module-refs '())))

(define-prim (##init-modules modules
                             #!optional
                             (level (macro-module-last-init-stage)))

  (let loop1 ((stage 1))

    (define (init module)
      (let* ((s (macro-module-stage module))
             (module-descr (macro-module-module-descr module)))
        (cond ((##fx>= s stage))
              ((##fx= s 0)
               (macro-module-stage-set! module 1)
               (##init-mod module-descr))
              ((##fx= s 1)
               (macro-module-stage-set! module 2)
               ((macro-module-descr-thunk module-descr))))))

    (if (##fx<= stage level)
        (let loop2 ((modules modules))
          (if (##pair? modules)
              (let ((module (##car modules)))
                (if (##fx<= (macro-module-stage module) stage)
                    (if (or (##fx< stage level) (##pair? (##cdr modules)))
                        (begin
                          (init module)
                          (loop2 (##cdr modules)))
                        (init module))
                    (loop2 (##cdr modules))))
              (loop1 (##fx+ stage 1)))))))

(define-prim (##load-modules module-refs
                             #!optional
                             (level (macro-module-last-init-stage)))
  (let ((modules (##collect-modules module-refs level)))
    (##init-modules modules level)))

(define-prim (##load-module module-ref
                            #!optional
                            (level (macro-module-last-init-stage)))
  (##load-modules (##vector module-ref) level))

(define-prim (##load-vm)
  (let* ((module-descrs
          (##vector-ref ##program-descr 0))
         (this-module-descr
          (##vector-ref module-descrs 0))
         (this-module-ref
          (##vector-last
           (macro-module-descr-supply-modules this-module-descr))))
    (##init-mod this-module-descr) ;; first stage init of this module
    (let* ((preload-module-refs (##register-module-descrs module-descrs))
           (this-module (##lookup-registered-module this-module-ref)))
      (if this-module
          (begin
            (macro-module-stage-set! this-module 2) ;; this module init done
            (##load-modules preload-module-refs)
            (##load-module ##vm-main-module-ref)
            (##main))))))

(macro-case-target
 ((C)
  (##load-vm)))

;;;============================================================================
