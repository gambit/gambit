/* File: "setup.c" */

/* Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved. */

/*
 * This module contains the routines that setup the Scheme program for
 * execution.
 */

#define ___INCLUDED_FROM_SETUP
#define ___VERSION 409004
#include "gambit.h"

#include "os_setup.h"
#include "os_base.h"
#include "os_files.h"
#include "os_dyn.h"
#include "os_thread.h"
#include "os_io.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"
#include "actlog.h"


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
 *   ___INTR_SYNC_OP     a synchronous op. over all processors is requested
 *   ___INTR_TERMINATE   a termination of the process is requested
 *   ___INTR_HEARTBEAT   heartbeat time interval has elapsed
 *   ___INTR_USER        user has interrupted the program (e.g. ctrl-C)
 *   ___INTR_GC          a garbage collection has finished
 *   ___INTR_OTHER       some other interrupt is requested
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

  if (___INTERRUPT_REQ(___ps->intr_flag[code] = ___FIX(1)<<code))
    {
      ___STACK_TRIP_ON();
      ___SHARED_MEMORY_BARRIER(); /* make sure write happens promptly */
      ___device_select_abort (___ps); /* abort ___device_select if waiting */
    }
}


___EXP_FUNC(void,___raise_interrupt_vmstate)
   ___P((___virtual_machine_state ___vms,
         int code),
        (___vms,
         code)
___virtual_machine_state ___vms;
int code;)
{
  int i;

  for (i=___vms->processor_count-1; i>=0; i--)
    ___raise_interrupt_pstate (___PSTATE_FROM_PROCESSOR_ID(i,___vms), code);
}


___EXP_FUNC(void,___raise_interrupt)
   ___P((int code),
        (code)
int code;)
{
  ___virtual_machine_state ___vms = &___GSTATE->vmstate0;

#ifdef ___SINGLE_VM

  ___raise_interrupt_vmstate (___vms, code);

#else

#if 0
  /* TODO: investigate why this deadlocks the process... probably recursive locking of mutex */
  ___MUTEX_LOCK(___GSTATE->vm_list_mut);
#endif

  do
    {
      ___vms = ___vms->prev;
      ___raise_interrupt_vmstate (___vms, code);
    }
  while (___vms != &___GSTATE->vmstate0);

#if 0
  ___MUTEX_UNLOCK(___GSTATE->vm_list_mut);
#endif

#endif
}


___EXP_FUNC(void,___init_procedural_interrupt)
   ___P((void *intr,
         ___SCMOBJ (*execute_fn) ___P((void *self, ___SCMOBJ op),())),
        (intr,
         execute_fn)
void *intr;
___SCMOBJ (*execute_fn) ();)
{
  ___procedural_interrupt_header *h =
    ___CAST(___procedural_interrupt_header*, intr);

  h->execute_fn = execute_fn;
}


___HIDDEN ___SCMOBJ release_procedural_interrupt
   ___P((void *intr),
        (intr)
void *intr;)
{
  ___procedural_interrupt_header *h =
    ___CAST(___procedural_interrupt_header*, intr);

  return h->execute_fn (intr, ___FAL);
}


___HIDDEN ___SCMOBJ service_procedural_interrupts_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SCMOBJ err = ___FIX(___NO_ERR);
  ___procedural_interrupt_header *probe;

  ___MUTEX_LOCK(___ps->procedural_interrupts_mut);

  while ((probe = ___ps->procedural_interrupts_head) != NULL)
    {
      ___procedural_interrupt_header *next = probe->next;

      ___ps->procedural_interrupts_head = next;

      if (next == NULL)
        ___ps->procedural_interrupts_tail = NULL;

      ___MUTEX_UNLOCK(___ps->procedural_interrupts_mut);

      if ((err = probe->execute_fn (___CAST(void*, probe), ___TRU))
          != ___FIX(___NO_ERR))
        break;

      ___MUTEX_LOCK(___ps->procedural_interrupts_mut);
    }

  ___MUTEX_UNLOCK(___ps->procedural_interrupts_mut);

  return err;
}


___EXP_FUNC(___SCMOBJ,___service_interrupts_pstate)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SCMOBJ result = ___FAL;
  ___WORD ___temp;

  ___STACK_TRIP_OFF();

  ___temp = ___INT(___INTERRUPT_AFTER_MASKING(___INTERRUPT_FLAGS()));

  if (___temp != 0)
    {
      /* choose the lowest interrupt (first bit set of ___temp) */
      int code = ___FFS_WORD_TEMP()-1;

      if (code < ___INTR_OTHER ||
          service_procedural_interrupts_pstate (___ps) == ___FIX(___NO_ERR))
        {
          ___ps->intr_flag[code] = ___FIX(0);

          result = ___FIX(code);

          /* check if there are other unserviced interrupts */
          if ((___temp & ~(1<<code)) != ___FIX(0))
            ___STACK_TRIP_ON();
        }
      else
        {
          /* call service_procedural_interrupts_pstate again soon */
          ___STACK_TRIP_ON();
        }
    }

  return result;
}


___EXP_FUNC(void,___refresh_interrupts_pstate)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___STACK_TRIP_OFF();
  ___STACK_TRIP_ON_IF_INTERRUPT_REQ();
}


___EXP_FUNC(void,___raise_high_level_interrupt_pstate)
   ___P((___processor_state ___ps,
         ___SCMOBJ intr),
        (___ps,
         intr)
___processor_state ___ps;
___SCMOBJ intr;)
{
  ___SCMOBJ ps = ___PROCESSOR_SCMOBJ(___ps);
  ___SCMOBJ tail;

  ___PRIMITIVELOCK(ps,___FIX(___OBJ_LOCK1),___FIX(___OBJ_LOCK2))

  tail = ___FIELD(ps,___PROCESSOR_INTERRUPTS_TAIL);

  ___FIELD(ps,___PROCESSOR_INTERRUPTS_TAIL) = intr;

  if (tail == ___NUL)
    ___FIELD(ps,___PROCESSOR_INTERRUPTS_HEAD) = intr;
  else
    ___FIELD(tail,0) = intr;

  ___PRIMITIVEUNLOCK(ps,___FIX(___OBJ_LOCK1),___FIX(___OBJ_LOCK2))

  ___raise_interrupt_pstate (___ps, ___INTR_OTHER);
}


___EXP_FUNC(void,___disable_interrupts_pstate)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  /* Disable all interrupts except ___INTR_SYNC_OP */
  ___ps->intr_enabled = ___FIX(1<<___INTR_SYNC_OP);

  ___refresh_interrupts_pstate (___ps);
}


___EXP_FUNC(void,___enable_interrupts_pstate)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  /* Enable all interrupts */
  ___ps->intr_enabled = ___FIX((1<<___NB_INTRS)-1);

  ___refresh_interrupts_pstate (___ps);
}


___HIDDEN void setup_interrupts_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  int i;

  /* Disable all interrupts except ___INTR_SYNC_OP */
  ___ps->intr_enabled = ___FIX(1<<___INTR_SYNC_OP);

  /* Mask no interrupts */
  ___ps->intr_mask = ___FIX(0);

  /* None of the interrupts are requested */
  for (i=0; i<___NB_INTRS; i++)
    ___ps->intr_flag[i] = ___FIX(0);

  /* Initialize empty queue of procedural interrupts */
  ___ps->procedural_interrupts_head = NULL;
  ___ps->procedural_interrupts_tail = NULL;
  ___MUTEX_INIT(___ps->procedural_interrupts_mut);
}


___EXP_FUNC(void,___raise_procedural_interrupt_pstate)
   ___P((___processor_state ___ps,
         void *intr),
        (___ps,
         intr)
___processor_state ___ps;
void *intr;)
{
  ___procedural_interrupt_header *h =
    ___CAST(___procedural_interrupt_header*, intr);
  ___procedural_interrupt_header *tail;

  h->next = NULL;

  ___MUTEX_LOCK(___ps->procedural_interrupts_mut);

  tail = ___ps->procedural_interrupts_tail;

  ___ps->procedural_interrupts_tail = h;

  if (tail == NULL)
    ___ps->procedural_interrupts_head = h;
  else
    tail->next = h;

  ___MUTEX_UNLOCK(___ps->procedural_interrupts_mut);

  ___raise_interrupt_pstate (___ps, ___INTR_OTHER);
}


___HIDDEN void cleanup_interrupts_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___procedural_interrupt_header *probe;

  ___MUTEX_LOCK(___ps->procedural_interrupts_mut);

  probe = ___ps->procedural_interrupts_head;

  while (probe != NULL)
    {
      ___procedural_interrupt_header *next = probe->next;
      release_procedural_interrupt (___CAST(void*,probe));
      probe = next;
    }

  ___ps->procedural_interrupts_head = NULL;
  ___ps->procedural_interrupts_tail = NULL;

  ___MUTEX_UNLOCK(___ps->procedural_interrupts_mut);
}


___HIDDEN void setup_processor_scmobj_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  int i;
  ___SCMOBJ p = ___PROCESSOR_SCMOBJ(___ps);

  ___SUBTYPED_HEADER_SET(p, ___MAKE_HD((___PROCESSOR_SIZE<<___LWS),___sSTRUCTURE,___PERM));

  for (i=0; i<___PROCESSOR_SIZE; i++)
    ___VECTORSET(p,___FIX(i),___FAL)

  /*
   * Setup primitive lock in locked state (the processor will be
   * unlocked in _thread.scm).
   */

  ___VECTORSET(p,___FIX(___OBJ_LOCK1),___FIX(0))
  ___VECTORSET(p,___FIX(___OBJ_LOCK2),___FIX(0))

  ___PRIMITIVELOCK(p,___FIX(___OBJ_LOCK1),___FIX(___OBJ_LOCK2))
}


___HIDDEN void setup_vm_scmobj_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  int i;
  ___SCMOBJ vm = ___VM_SCMOBJ(___vms);

  ___SUBTYPED_HEADER_SET(vm, ___MAKE_HD((___VM_SIZE<<___LWS),___sSTRUCTURE,___PERM));

  for (i=0; i<___VM_SIZE; i++)
    ___VECTORSET(vm,___FIX(i),___FAL)

  /*
   * Setup primitive lock in locked state (the VM will be
   * unlocked in _thread.scm).
   */

  ___VECTORSET(vm,___FIX(___OBJ_LOCK1),___FIX(0))
  ___VECTORSET(vm,___FIX(___OBJ_LOCK2),___FIX(0))

  ___PRIMITIVELOCK(vm,___FIX(___OBJ_LOCK1),___FIX(___OBJ_LOCK2))
}


/*---------------------------------------------------------------------------*/

/*
 * Synchronous operations.
 */

#define WASTE_TIME() ___CPU_RELAX()

#define COMBINING_OP(op) ((op)&3)
#define COMBINING_AND 1
#define COMBINING_ADD 2
#define COMBINING_MAX 3
#define OP_MAKE(priority,combining) (((priority)<<2)+(combining))

#define OP_PROCESSOR_0_THROW_ERROR OP_MAKE( 0,0)
#define OP_SET_PROCESSOR_COUNT     OP_MAKE( 1,0)
#define OP_VM_RESIZE               OP_MAKE( 2,0)
#define OP_GARBAGE_COLLECT         OP_MAKE( 3,COMBINING_ADD)
#define OP_FDSET_RESIZE            OP_MAKE(10,COMBINING_MAX)
#define OP_ACTLOG_START            OP_MAKE(61,0)
#define OP_ACTLOG_STOP             OP_MAKE(62,0)
#define OP_NOOP                    OP_MAKE(63,0)

#define SYNC_WAITING -1

#define SYNC_INIT_MSG(var) var = SYNC_WAITING

#define SYNC_GET_MSG_SPIN_TIMEOUT 2000

#define SYNC_GET_MSG(expr) \
do { \
     int loops_left = SYNC_GET_MSG_SPIN_TIMEOUT; \
     while ((expr) == SYNC_WAITING) \
       { \
         WASTE_TIME(); \
         if (--loops_left == 0) \
           { \
             loops_left = SYNC_GET_MSG_SPIN_TIMEOUT; \
             ___MUTEX_LOCK(___ps->sync_mut); \
             if ((expr) == SYNC_WAITING) \
               ___sync_wait (___ps); \
             ___MUTEX_UNLOCK(___ps->sync_mut); \
           } \
       } \
   } while (0)

#define SYNC_SEND_MSG(ps,field,val) \
do { \
     ___MUTEX_LOCK(ps->sync_mut); \
     ps->field = val; \
     ___SHARED_MEMORY_BARRIER(); /* make sure write happens promptly */  \
     ___MUTEX_UNLOCK(ps->sync_mut); \
     ___CONDVAR_SIGNAL(ps->sync_cv); \
   } while (0)


___HIDDEN void ___sync_wait
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifndef ___SINGLE_THREADED_VMS

  ___ACTLOG_BEGIN_PS(sync_wait,gray);
  ___CONDVAR_WAIT(___ps->sync_cv, ___ps->sync_mut);
  ___ACTLOG_END_PS();

#endif
}


___HIDDEN int barrier_sync_op
   ___P((___PSD
         ___sync_op_struct *sop_ptr),
        (___PSV
         sop_ptr)
___PSDKR
___sync_op_struct *sop_ptr;)
{
#ifdef ___SINGLE_THREADED_VMS

  return 0;

#else

  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  int id = ___PROCESSOR_ID(___ps, ___vms); /* id of this processor */
  int child_id1 = id*2+1;          /* id of child 1 */
  int child_id2 = id*2+2;          /* id of child 2 */
  int n = ___vms->processor_count; /* processor count */
  ___sync_op_struct sop = *sop_ptr;
  int sid = id;

  /*
   * This function performs a barrier synchronization by imposing a
   * tree structure on the set of processors in this Gambit VM.
   */

  /*
   * Check operations from children processors and self to
   * determine the highest priority operation.
   */

  if (child_id1 < n)
    {
      int sid1;
      ___sync_op_struct sop1;

      SYNC_GET_MSG(sid1 = ___ps->sync_id1);
      SYNC_INIT_MSG(___ps->sync_id1);

      sop1 = ___ps->sync_op1;

      if (sop1.op < sop.op)
        {
          sop = sop1;
          sid = sid1;
        }
      else if (sop1.op == sop.op && COMBINING_OP(sop1.op))
        {
          switch (COMBINING_OP(sop1.op))
            {
            case COMBINING_AND:
              sop1.arg[0] &= sop.arg[0];
              break;
            case COMBINING_ADD:
              sop1.arg[0] += sop.arg[0];
              break;
            case COMBINING_MAX:
              if (sop1.arg[0] < sop.arg[0]) sop1.arg[0] = sop.arg[0];
              break;
            }

          sop = sop1;
          sid = sid1;
        }

      if (child_id2 < n)
        {
          int sid2;
          ___sync_op_struct sop2;

          SYNC_GET_MSG(sid2 = ___ps->sync_id2);
          SYNC_INIT_MSG(___ps->sync_id2);

          sop2 = ___ps->sync_op2;

          if (sop2.op < sop.op)
            {
              sop = sop2;
              sid = sid2;
            }
          else if (sop2.op == sop.op && COMBINING_OP(sop2.op))
            {
              switch (COMBINING_OP(sop2.op))
                {
                case COMBINING_AND:
                  sop2.arg[0] &= sop.arg[0];
                  break;
                case COMBINING_ADD:
                  sop2.arg[0] += sop.arg[0];
                  break;
                case COMBINING_MAX:
                  if (sop2.arg[0] < sop.arg[0]) sop2.arg[0] = sop.arg[0];
                  break;
                }

              sop = sop2;
              sid = sid2;
            }
        }
    }

  /*
   * Propagate highest priority operation to parent processor.
   */

  if (id == 0)
    {
      /*
       * Special case operation that sets processor_count because this
       * information is used by the barrier_sync algorithm itself.
       */
      if (sop.op == OP_SET_PROCESSOR_COUNT)
        ___vms->processor_count = sop.arg[0];
    }
  else
    {
      ___processor_state parent = ___PSTATE_FROM_PROCESSOR_ID((id-1)>>1,___vms);

      if (id & 1)
        {
          parent->sync_op1 = sop;
          SYNC_SEND_MSG(parent, sync_id1, sid);
        }
      else
        {
          parent->sync_op2 = sop;
          SYNC_SEND_MSG(parent, sync_id2, sid);
        }

      /*
       * Wait for parent to reply with winning operation.
       */

      SYNC_GET_MSG(sid = ___ps->sync_id0);
      SYNC_INIT_MSG(___ps->sync_id0);

      sop = ___ps->sync_op0;
    }

  /*
   * Propagate winning operation to children processors.
   */

  if (child_id1 < n)
    {
      ___processor_state child1 = ___PSTATE_FROM_PROCESSOR_ID(child_id1,___vms);

      child1->sync_op0 = sop;
      SYNC_SEND_MSG(child1, sync_id0, sid);

      if (child_id2 < n)
        {
          ___processor_state child2 = ___PSTATE_FROM_PROCESSOR_ID(child_id2,___vms);

          child2->sync_op0 = sop;
          SYNC_SEND_MSG(child2, sync_id0, sid);
        }
    }

  /*
   * Return winning operation and id of originating processor.
   */

  *sop_ptr = sop;

  return sid;

#endif
}


void barrier_sync_noop
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
#ifndef ___SINGLE_THREADED_VMS

  ___PSGET

  ___sync_op_struct sop;

  sop.op = OP_NOOP;
  barrier_sync_op (___PSP &sop);

#endif
}


___SCMOBJ ___setup_pstate
   ___P((___processor_state ___ps,
         ___virtual_machine_state ___vms),
        ());


void ___cleanup_pstate
   ___P((___processor_state ___ps),
        ());


___SCMOBJ ___run
   ___P((___PSD
         ___SCMOBJ thunk),
        ());


void execute_sync_op_loop
   ___P((___PSD
         ___sync_op_struct *sop_ptr,
         ___BOOL first_iter),
        ());


void on_all_processors
   ___P((___PSD
         ___sync_op_struct *sop_ptr),
        ());


void ___run_and_throw_error_on_processor_0
   ___P((___PSD
         ___SCMOBJ thunk),
        (___PSV
         thunk)
___PSDKR
___SCMOBJ thunk;)
{
  ___PSGET
  ___SCMOBJ ___err;
  ___sync_op_struct sop;

  /*
   * Start the processor's execution by a call to thunk.  This call
   * will return when the processor's execution terminates, typically
   * when the Gambit VM terminates normally or with an error.
   */

  ___err = ___run (___PSP thunk);

  /*
   * The error code must be sent to processor 0 because it is the one
   * that must handle this error code (terminate the VM) and it has
   * started the VM.
   */

  sop.op = OP_PROCESSOR_0_THROW_ERROR;
  sop.arg[0] = ___err;

  on_all_processors (___PSP &sop);

  /*
   * Participate in future synchronous operations (this is needed
   * because the cleanup and termination of a processor is done using
   * a synchronous operation).
   */

  for (;;)
    service_sync_op (___PSPNC);
}


___HIDDEN void start_processor_execution
   ___P((___thread *self),
        (self)
___thread *self;)
{
  ___processor_state ___ps = ___CAST(___processor_state,self->data_ptr);
  ___SCMOBJ thunk = self->data_scmobj;
  ___sync_op_struct sop;

  /*
   * Setup current OS thread so that it can find the processor state
   * it is running.
   */

  ___thread_set_pstate (___ps);

  /*
   * Participate in the synchronous operation that initiated the
   * resizing of the VM.
   */

  sop.op = OP_NOOP;
  execute_sync_op_loop (___PSP &sop, 0);

  /*
   * Start processor's execution by a call to thunk.  The processor's
   * termination code will be propagated to processor 0 which will
   * call ___throw_error with this code, normally terminating the VM.
   */

  ___run_and_throw_error_on_processor_0 (___PSP thunk);
}


___EXP_FUNC(void,___throw_error)
   ___P((___PSD
         ___SCMOBJ err),
        (___PSV
         err)
___PSDKR
___SCMOBJ err;)
{
  ___PSGET

  ___THROW (err);
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
      ___throw_error (___PSP err);
    }
}


___SCMOBJ ___vm_resize_pstate
   ___P((___processor_state ___ps,
         ___SCMOBJ thunk,
         ___WORD target_processor_count),
        (___ps,
         thunk,
         target_processor_count)
___processor_state ___ps;
___SCMOBJ thunk;
___WORD target_processor_count;)
{
  ___SCMOBJ err = ___FIX(___NO_ERR);

#ifndef ___SINGLE_THREADED_VMS

  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  int id = ___PROCESSOR_ID(___ps, ___vms); /* id of this processor */
  ___sync_op_struct sop;
  int initial = ___vms->processor_count;

  if (id == 0)
    {
      ___vms->mem.target_processor_count_ = target_processor_count;

#ifdef ___ACTIVITY_LOG
      if (target_processor_count > ___vms->actlog.max_processor_count)
        ___vms->actlog.max_processor_count = target_processor_count;
#endif
    }

  if (___vms->mem.the_msections_->nb_sections - ___vms->mem.nb_msections_assigned_ <
      ___MIN_NB_MSECTIONS_PER_PROCESSOR * (target_processor_count - initial))
    {
      if (___garbage_collect_pstate (___ps, 0))
        {
          /*
           * A heap overflow occurred, indicating the VM has
           * insufficient space to accomodate the target number of
           * processors.
           */

          if (id == 0)
            ___vms->mem.target_processor_count_ = initial;

          return ___FIX(___HEAP_OVERFLOW_ERR);
        }
    }

  if (id != 0)
    {
      /*
       * Wait for processor 0 to set ___vms->processor_count.
       */

      BARRIER();

      /*
       * Terminate current processor if it is no longer needed.
       */

      if (id >= target_processor_count)
        {
          ___cleanup_pstate (___ps);
          ___thread_exit (); /* this call does not return */
        }
    }
  else
    {
      int i;

      /* Setup processor state of each additional processor */

      for (i=initial; i<target_processor_count; i++)
        {
          ___processor_state ps = ___PSTATE_FROM_PROCESSOR_ID(i,___vms);

          if ((err = ___setup_pstate (ps, ___vms))
              != ___FIX(___NO_ERR))
            {
              while (--i >= initial)
                ___cleanup_pstate (ps);

              BARRIER();

              return err;
            }
        }

      /*
       * Set processor_count synchronously.
       */

      sop.op = OP_SET_PROCESSOR_COUNT;
      sop.arg[0] = target_processor_count;
      barrier_sync_op (___PSP &sop);

      if (target_processor_count < initial)
        {
          /*
           * Join processors that are reclaimed when number of
           * processors shrinks.
           */

          for (i=initial-1; i>=target_processor_count; i--)
            {
              ___processor_state ps = ___PSTATE_FROM_PROCESSOR_ID(i,___vms);
              ___thread *t = &ps->os_thread;

              ___thread_join (t); /* ignore error */
            }
        }
      else
        {
          /*
           * Create new processors when number of processors grows.
           */

          for (i=initial; i<target_processor_count; i++)
            {
              ___processor_state ps = ___PSTATE_FROM_PROCESSOR_ID(i,___vms);
              ___thread *t = &ps->os_thread;

              t->start_fn = start_processor_execution;
              t->data_ptr = ___CAST(void*,ps);
              t->data_scmobj = thunk;

              if ((err = ___thread_create (t)) != ___FIX(___NO_ERR))
                {
                  /* TODO: improve error handling */
                  static char *msgs[] = { "Could not create OS thread", NULL };
                  ___fatal_error (msgs);
                }
            }
        }
    }

#endif

  return err;
}


void execute_sync_op
   ___P((___PSD
         ___sync_op_struct *sop_ptr),
        (___PSV
         sop_ptr)
___PSDKR
___sync_op_struct *sop_ptr;)
{
  ___PSGET

  switch (sop_ptr->op)
    {
    case OP_VM_RESIZE:
      sop_ptr->arg[0] = ___vm_resize_pstate (___ps, sop_ptr->arg[0], sop_ptr->arg[1]);
      break;

    case OP_GARBAGE_COLLECT:
      sop_ptr->arg[0] = ___garbage_collect_pstate (___ps, sop_ptr->arg[0]);
      break;

#ifdef USE_FDSET_RESIZING
    case OP_FDSET_RESIZE:
      ___fdset_resize_pstate (___ps, sop_ptr->arg[0]);
      break;
#endif

    case OP_ACTLOG_START:
      ___actlog_start_pstate (___ps);
      break;

    case OP_ACTLOG_STOP:
      ___actlog_stop_pstate (___ps);
      break;
    }
}


void execute_sync_op_loop
   ___P((___PSD
         ___sync_op_struct *sop_ptr,
         ___BOOL first_iter),
        (___PSV
         sop_ptr,
         first_iter)
___PSDKR
___sync_op_struct *sop_ptr;
___BOOL first_iter;)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  int id = ___PROCESSOR_ID(___ps,___vms); /* id of this processor */
  ___SCMOBJ ___err = ___FIX(___NO_ERR);

  for (;;)
    {
      ___sync_op_struct sop = *sop_ptr;
      int winner_id = barrier_sync_op (___PSP &sop);

      if (first_iter)
        {
          /*
           * Reset ___INTR_SYNC_OP interrupt flag synchronously so that
           * no interrupt is ignored (this would cause the barrier
           * synchronization to get out of sync).
           */

          ___ps->intr_flag[___INTR_SYNC_OP] = ___FIX(0);
        }

      if (sop.op == OP_NOOP)
        {
          /*
           * Stop looping when all operations performed, but
           * must loop at least twice to reset ___INTR_SYNC_OP flag.
           */

          if (!first_iter)
            break;
        }
      else
        {
          if (sop.op == OP_PROCESSOR_0_THROW_ERROR)
            {
              if (___err == ___FIX(___NO_ERR))
                ___err = sop.arg[0];
            }
          else
            execute_sync_op (___PSP &sop);

          if (sop.op == sop_ptr->op &&
              (winner_id == id || COMBINING_OP(sop.op)))
            {
              *sop_ptr = sop; /* return result */
              sop_ptr->op = OP_NOOP; /* mark operation as executed */
            }
        }

      first_iter = 0;
    }

  if (id == 0 && ___err != ___FIX(___NO_ERR))
    ___throw_error (___PSP ___err);
}


void service_sync_op
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET
  ___sync_op_struct sop;

  sop.op = OP_NOOP;
  ___ACTLOG_BEGIN(service_sync_op,_);
  execute_sync_op_loop (___PSP &sop, 1);
  ___ACTLOG_END();
}


void on_all_processors
   ___P((___PSD
         ___sync_op_struct *sop_ptr),
        (___PSV
         sop_ptr)
___PSDKR
___sync_op_struct *sop_ptr;)
{
  ___PSGET
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);

  /* force processors to call service_sync_op */

  ___ACTLOG_BEGIN(on_all,_);

  ___raise_interrupt_vmstate (___vms, ___INTR_SYNC_OP);

  execute_sync_op_loop (___PSP sop_ptr, 1);

  ___ACTLOG_END();
}


___EXP_FUNC(___SCMOBJ,___current_vm_resize)
   ___P((___PSD
         ___SCMOBJ thunk,
         int target_processor_count),
        (___PSV
         thunk,
         target_processor_count)
___PSDKR
___SCMOBJ thunk;
int target_processor_count;)
{
  ___PSGET
  ___sync_op_struct sop;

  if (target_processor_count > ___MAX_PROCESSORS)
    target_processor_count = ___MAX_PROCESSORS;

  sop.op = OP_VM_RESIZE;
  sop.arg[0] = thunk;
  sop.arg[1] = target_processor_count;

  on_all_processors (___PSP &sop);

  return sop.arg[0];
}


___EXP_FUNC(___BOOL,___garbage_collect)
   ___P((___PSD
         ___SIZE_TS requested_words_still),
        (___PSV
         requested_words_still)
___PSDKR
___SIZE_TS requested_words_still;)
{
  ___PSGET
  ___sync_op_struct sop;

  sop.op = OP_GARBAGE_COLLECT;
  sop.arg[0] = requested_words_still;

  on_all_processors (___PSP &sop);

  return sop.arg[0] != 0;
}


#ifdef USE_FDSET_RESIZING

___EXP_FUNC(___BOOL, ___fdset_resize)
   ___P((int fd1,
         int fd2),
        (fd1,
         fd2)
int fd1;
int fd2;)
{
  ___processor_state ___ps = ___PSTATE;
  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___sync_op_struct sop;

  int newsize;
  int maxfd = (fd2 > fd1) ? fd2 : fd1;

  if (maxfd < ___vms->os.fdset.size)
    return 1;

  sop.op = OP_FDSET_RESIZE;
  sop.arg[0] = maxfd;

  on_all_processors (___PSP &sop);

  return !___vms->os.fdset.overflow;
}

#endif

___EXP_FUNC(void,___actlog_start)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___sync_op_struct sop;

  sop.op = OP_ACTLOG_START;

  on_all_processors (___PSP &sop);

  ___vms->actlog.auto_dump = 0;

#endif
}


___EXP_FUNC(void,___actlog_stop)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
  ___sync_op_struct sop;

  sop.op = OP_ACTLOG_STOP;

  on_all_processors (___PSP &sop);

  ___vms->actlog.auto_dump = 0;

#endif
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
  if (need_64bit_alignment) /* body must be aligned at 8 byte multiple */
    to = ___ALIGNUP((from+___SUBTYPED_BODY), 8) - ___SUBTYPED_BODY;
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
  return ___SUBTYPED_FROM_START(align (ptr,
                                       words+___SUBTYPED_BODY,
                                       subtype>=___sS64VECTOR));
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
  if (mol->module.version != -1 && mol->module.kind == ___LINKFILE_KIND)
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
    ___BOOL collect_undef_glo;
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


___HIDDEN void fixrefs
   ___P((___module_struct *module,
         ___SCMOBJ *p,
         int n),
        (module,
         p,
         n)
___module_struct *module;
___SCMOBJ *p;
int n;)
{
  while (n > 0)
    {
      ___SCMOBJ v = *p;
      int x = ___INT(v);
      switch (___TYP(v))
        {

        case ___tMEM1:
          if (x < 0)
            *p = ___CAST(___SCMOBJ*,module->keytbl)[-1-x];
          else if (x < module->subcount)
            *p = ___CAST(___SCMOBJ*,module->subtbl)[x];
          else
            *p = ___SUBTYPED_FROM_BODY(&module->lbltbl[x-module->subcount].entry_or_descr);
          break;

        case ___tMEM2:
          if (x < 0)
            *p = ___CAST(___SCMOBJ*,module->symtbl)[-1-x];
          else
            *p = ___PAIR_FROM_START(&___CAST(___SCMOBJ*,module->cnstbl)[
                                     x*(___PAIR_BODY+___PAIR_SIZE)]);
          break;
        }

      p++;
      n--;
    }
}


___HIDDEN ___SCMOBJ make_global
   ___P((___BOOL collect_undef_glo,
         ___UTF_8STRING str,
         int supply,
         ___glo_struct **glo),
        (collect_undef_glo,
         str,
         supply,
         glo)
___BOOL collect_undef_glo;
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

  if (collect_undef_glo)
    {
      /*
       * If the variable is supplied by the module, mark it specially
       * so that it won't be flagged as an undefined variable.
       */

      if (supply && ___GLOCELL(g->val) == ___UNB1)
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
  ___processor_state ___ps = ctx->ps;
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
  ___label_struct *new_lbltbl = 0;
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

  if (module->version < ___VERSION)
    return ___FIX(___MODULE_VERSION_TOO_OLD_ERR);

  if (module->version > ___VERSION)
    return ___FIX(___MODULE_VERSION_TOO_NEW_ERR);

  /*
   * Check that the module was compiled with a C compiler and options that
   * give the same size structures for ___GSTATE, ___VMSTATE and ___PSTATE.
   * This is a simple check that catches most mismatches that would cause
   * problems later.
   */

  if (module->sizeof_module_struct != sizeof(___module_struct) ||
      module->sizeof_global_state_struct != sizeof(___global_state_struct) ||
      module->sizeof_virtual_machine_state_struct != sizeof(___virtual_machine_state_struct) ||
      module->sizeof_processor_state_struct != sizeof(___processor_state_struct))
    return ___FIX(___MODULE_INCOMPATIBILITY_ERR);

  /* Align label table */

  if (lblcount > 0)
    {
#ifdef ___SUPPORT_LOWLEVEL_EXEC

      new_lbltbl = ___alloc_mem_code (lblcount*___LABEL_SIZE*___WS);
      memmove (new_lbltbl, lbltbl, lblcount*___LABEL_SIZE*___WS);

#else

      new_lbltbl = ___CAST(___label_struct*,
                           align (___CAST(___SCMOBJ*,lbltbl),
                                  lblcount*___LABEL_SIZE,
                                  0));

#endif

      module->lbltbl = new_lbltbl;
    }

  /* Align pair table */

  cnstbl = align (cnstbl, (___PAIR_BODY+___PAIR_SIZE)*cnscount, 0);
  module->cnstbl = cnstbl;

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
          ___SCMOBJ e = make_global (ctx->collect_undef_glo,
                                     glo_names[i],
                                     i<supcount,
                                     &glo);
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
        symtbl[i] = ___SUBTYPED_FROM_START(___ALIGNUP(symtbl[i], ___WS));
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
        keytbl[i] = ___SUBTYPED_FROM_START(___ALIGNUP(keytbl[i], ___WS));
    }

  /* Setup module's subtyped object table */

  for (i=subcount-1; i>=0; i--)
    subtbl[i] = align_subtyped (___CAST(___SCMOBJ*,subtbl[i]));

  /* Fix reference in module's descriptor */

  fixrefs (module, &module->moddescr, 1);

  /* Fix references in module's pair table */

  for (i=cnscount-1; i>=0; i--)
    fixrefs (module,
             cnstbl + i*(___PAIR_BODY+___PAIR_SIZE) + ___PAIR_BODY,
             ___PAIR_SIZE);

  /* Fix references in module's subtyped object table */

  for (j=subcount-1; j>=0; j--)
    {
      ___SCMOBJ *p = ___SUBTYPED_TO_START(subtbl[j]);
      ___SCMOBJ head = p[0];
      if (___HD_SUBTYPE(head) <= ___sKEYWORD)
        fixrefs (module, p+___SUBTYPED_BODY, ___HD_WORDS(head));
    }

  /* Align module's out-of-line frame descriptor table */

  ofdtbl = ___CAST(___SCMOBJ*,align (ofdtbl, ofd_length, 0));

  /* Align module's label table */

  if (lblcount > 0)
    {
#ifdef ___SUPPORT_LABEL_VALUES
      void **hlbl_ptr = 0;
#endif
      ___host current_host = 0;
      ___SCMOBJ *ofd_alloc;

      ofd_alloc = ofdtbl;

      for (i=0; i<lblcount; i++)
        {
          ___SCMOBJ lbl = ___SUBTYPED_FROM_BODY(&new_lbltbl[i].entry_or_descr);
          ___SCMOBJ head = ___SUBTYPED_HEADER(lbl);

          if (___TESTHEADERTAG(head,___sVECTOR))
            {
              /*
               * Setup name returned by
               * (##subprocedure-parent-name proc)
               */

              fixrefs (module, ___SUBTYPED_TO(lbl, ___LABEL_NAME), 1);

              /*
               * Setup debugging information returned by
               * (##subprocedure-parent-info proc)
               */

              fixrefs (module, ___SUBTYPED_TO(lbl, ___LABEL_INFO), 1);

#ifdef ___SUPPORT_LABEL_VALUES
              if (hlbl_ptr != 0)
                hlbl_ptr++; /* skip INTRO label */
#endif
            }
          else
            {
#ifdef ___SUPPORT_LABEL_VALUES
              if (flags & ___USES_INDIRECT_GOTO)
                {
                  /*
                   * The module uses the indirect goto statement, so
                   * we must call the current C host function to get
                   * the table of goto labels used to initialize the
                   * label structures.  This should be done once per C
                   * host function.
                   */

                  if (___LABEL_HOST_GET(lbl) != current_host)
                    {
                      ___ps->pc = ___FIX(0); /* special marker indicating that */
                                             /* we want the goto labels */

                      current_host = ___LABEL_HOST_GET(lbl);
                      current_host (___ps);
                      hlbl_ptr = ___CAST(void**,___ps->pc);
                      hlbl_ptr++; /* skip INTRO label */
                    }

                  ___LABEL_HOST_LABEL_SET(lbl,
                                          ___CAST_VOIDSTAR_TO_FAKEVOIDSTAR(*hlbl_ptr++));
                }
#endif

              /*
               * Return labels contain a GC map descriptor which has
               * to be setup if it is out-of-line (which happens when
               * the stack frame is large.
               */

              if (head == ___MAKE_HD(0,___sRETURN,___PERM))
                {
                  ___SCMOBJ descr = ___LABEL_DESCR_GET(lbl);
                  if (___IFD_GCMAP(descr) == 0) /* out-of-line descriptor? */
                    {
                      int fs;
                      ___LABEL_DESCR_SET(lbl, ___CAST(___SCMOBJ,ofd_alloc));
                      fs = ___OFD_FS(*ofd_alloc);
                      if (___IFD_KIND(descr) == ___RETI)
                        fs = ___RETI_CFS_TO_FS(fs);
                      ofd_alloc += 1 + ___CEILING_DIV(fs,___WORD_WIDTH);
                    }
                }
              else
                ___LABEL_ENTRY_SET(lbl, lbl);

#ifdef ___SUPPORT_LOWLEVEL_EXEC

              ___LABEL_LOWLEVEL_TRAMPOLINE_SETUP(___SUBTYPED_TO_BODY(lbl));

#endif
            }
        }

      *lp = ___SUBTYPED_FROM_BODY(&new_lbltbl[0].entry_or_descr);
    }

  return ___FIX(___NO_ERR);
}


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
                            name,
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
        ___FIELD(descr,___MODULE_DESCR_FLAGS) = ctx->flags;

      if ((err = ___NONNULLPOINTER_to_SCMOBJ
                   (NULL, /* allocate as permanent object */
                    ___CAST(void*,module),
                    ___FAL,
                    NULL,
                    &___FIELD(descr,___MODULE_DESCR_MODULE_STRUCT),
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
         ___mod_or_lnk mol,
         ___BOOL collect_undef_glo),
        (___ps,
         mol,
         collect_undef_glo)
___processor_state ___ps;
___mod_or_lnk mol;
___BOOL collect_undef_glo;)
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
  ctx->collect_undef_glo = collect_undef_glo;

  /* Fixup objects and tables in all the modules and count modules */

  if ((result = for_each_module (ctx,
                                 mol,
                                 setup_module_fixup))
      != ___FIX(___NO_ERR))
    return result;

  if (collect_undef_glo)
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
         ___SCMOBJ linkername),
        (path,
         linkername)
___SCMOBJ path;
___SCMOBJ linkername;)
{
  ___SCMOBJ result;
  void *linker;
  ___mod_or_lnk mol;

  if ((result = ___dynamic_load (path, linkername, &linker)) == ___FIX(___NO_ERR))
    {
      mol = linker_to_mod_or_lnk
              (___CAST(___mod_or_lnk (*) ___P((___global_state),()),
                       linker));

      if (mol->linkfile.version == -1) /* was it already setup? */
        result = ___FIX(___MODULE_ALREADY_LOADED_ERR);
      else
        {
          result = setup_modules (___PSTATE, mol, 1);
          mol->linkfile.version = -1; /* mark link file as 'setup' */
        }
    }

  return result;
}


/*---------------------------------------------------------------------------*/

/*
 * Character operations.
 */


#ifdef ___USE_C_RTS_CHAR_OPERATIONS


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
      b1 = ___CAST(wchar_t*,___ALLOC_MEM(len1 + 1));

      if (b1 == 0)
        return ___FIX(___HEAP_OVERFLOW_ERR);

      p = b1;

      for (i=0; i<len1; i++)
        *p++ = ___INT(___STRINGREF(str1,___FIX(i)));

      *p = '\0';

      b2 = ___CAST(wchar_t*,___ALLOC_MEM(len1 + 1));

      if (b2 == 0)
        {
          ___FREE_MEM(b1);
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
      ___FREE_MEM(b1);
      ___FREE_MEM(b2);
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


#endif


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


___EXP_FUNC(___BOOL,___isinf)
   ___P((double x),
        (x)
double x;)
{
  return x != 0.0 && x == 2.0*x;
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

  /* Some code in _num.scm expects that log1p() is more accurate than
     the naive algorithm.
     This is somewhat  more accurate, see
     https://stat.ethz.ch/pipermail/r-devel/2003-August/027396.html
     https://books.google.com/books?id=OjUyDwAAQBAJ&pg=PA290&lpg=PA290&dq=beebe+log1p&source=bl&ots=VLxmiSk1fA&sig=ACfU3U0_8tqKemomSjKW73iJ0zUO1u3p3Q&hl=en&sa=X&ved=2ahUKEwjfxZbE8LvhAhVNm-AKHWScB7w4ChDoATAAegQICRAB#v=onepage&q=beebe%20log1p&f=false
  */

  double u;

  u = 1.0 + x;
  if (u == 1.0)
    /* x near 0. */
    return x;
  if (u == x)
    /* large arguments and infinities */
    return log (u);
  else
    /* NaNs and other arguments */
    return log (u) * (x / (u - 1.0));

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
  else if (x > 0.)  /* +inf.0 */
    /* return pi/4 with appropriate sign */
    return ___copysign (.7853981633974483, y);
  else
    /* return 3pi/4 with appropriate sign */
    return ___copysign (2.356194490192345, y);

#endif
}

#endif


#ifdef ___DEFINE_HYPOT

___EXP_FUNC(double,___hypot)
   ___P((double x,
         double y),
        (x,
         y)
double x;
double y;)
{
#ifdef ___HAVE_GOOD_HYPOT

  return hypot (x, y);

#else

  /* From:
     Branch Cuts for Complex Elementary Functions
     or
     Much Ado About Nothing's Sign Bit
     by
     W. KAHAN
  */
  double
    r2   = 1.4142135623730951,
    r2p1 = 2.414213562373095,
    t2p1 = 1.2537167179050217e-16;
  double t, s;

  x = fabs (x);
  y = fabs (y);

  if (x < y) {
    t = x; x = y; y = t;
  }
  if (___isinf (y))
    x = y;
  t = x - y;
  if (!___isinf (x) && !(t == x)) {
    if (t > y) {
      s = x / y;
      s += sqrt (1.0 + s*s);
      return x + y/s;
    } else {
      s = t/y;
      t = s * (2.0 + s);
      s = r2p1 + (s + (t2p1 + t/(r2 + sqrt (2.0 + t))));
      return x + y/s;
    }
  }
  else
    return x;

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
  else if (x == 1.0)
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


___EXP_FUNC(___SCMOBJ,___F64_to_STRING)
   ___P((___PSD
         double x),
        (___PSV
         x)
___PSDKR
double x;)
{
  ___PSGET

#ifdef USE_snprintf

#ifdef DBL_DECIMAL_DIG
#define NDIG DBL_DECIMAL_DIG
#else
#ifdef __DBL_DECIMAL_DIG__
#define NDIG __DBL_DECIMAL_DIG__
#else
#define NDIG (DBL_DIG + 2)
#endif
#endif

  char buf[NDIG+8]; /* +8 to account for sign, period, e, +/-, 3 digit exponent and nul char */
  ___WORD len = 0;
  ___WORD i;
  ___D_HEAP

  snprintf (buf, NDIG+8, "%.*g", NDIG, x);

  while (buf[len] != '\0') len++;

  ___R_HEAP

  ___BEGIN_ALLOC_STRING(len)

  for (i=0; i<len; i++)
    ___ADD_STRING_ELEM(i,___CHR(buf[i]))

  ___END_ALLOC_STRING(len)

  ___W_HEAP

  return ___GET_STRING(len);

#else

  ___D_HEAP

  ___R_HEAP

  ___BEGIN_ALLOC_STRING(0)
  ___END_ALLOC_STRING(0)

  ___W_HEAP

  return ___GET_STRING(0);

#endif
}


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
          glo = ___CAST(___glo_struct*,sym_ptr[___SUBTYPED_BODY+___SYMBOL_GLOBAL]);

          sym_ptr[___SUBTYPED_BODY+___SYMKEY_HASH] = glo->prm; /* move symbol's hash value */
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
          str = align_subtyped (___CAST(___SCMOBJ*,sym_ptr[___SUBTYPED_BODY+___SYMKEY_NAME]));
          glo = ___CAST(___glo_struct*,sym_ptr[___SUBTYPED_BODY+___SYMBOL_GLOBAL]);

#ifndef ___SINGLE_VM

          glo->val = ___GSTATE->mem.glo_list.count;

#endif

          ___glo_list_add (glo);

          sym_ptr[0] = ___MAKE_HD((___SYMBOL_SIZE<<___LWS),___sSYMBOL,___PERM);

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
          str = align_subtyped (___CAST(___SCMOBJ*,key_ptr[___SUBTYPED_BODY+___SYMKEY_NAME]));

          key_ptr[0] = ___MAKE_HD((___KEYWORD_SIZE<<___LWS),___sKEYWORD,___PERM);

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


#ifndef ___USE_PROPER_TAIL_CALL_EXCLUSIVELY_TO_EXIT_HOST

#ifdef EMSCRIPTEN

/*
 * The trampoline function must not be inlined into the ___call
 * function when using emscripten because the fact that ___call uses
 * setjmp will slow down the indirect calls.
 */

__attribute__((noinline))

#endif

void ___trampoline
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  for (;;)
    {

#ifdef ___DEBUG_TRAMPOLINE

#define CALL_STEP_DEBUG \
do { \
  ___SCMOBJ ___pc = ___ps->pc; \
  ___SCMOBJ sym = ___subprocedure_parent_name (___pc); \
  printf ("___pc = "); \
  if (sym == ___FAL) { \
    printf ("???\n"); \
  } else { \
    ___SCMOBJ name = ___FIELD(sym,___SYMKEY_NAME); \
    int i; \
    for (i=0; i<___INT(___STRINGLENGTH(name)); i++) \
      printf ("%c", ___INT(___STRINGREF(name,___FIX(i)))); \
    printf ("\n"); \
  } \
  fflush (stdout); \
} while (0)

#else

#define CALL_STEP_DEBUG

#endif

#define CALL_STEP \
do { \
  CALL_STEP_DEBUG; \
  ___CALL_LABEL_HOST(___ps->pc,___ps); \
} while (0)

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

#endif


___EXP_FUNC(___SCMOBJ,___call)
   ___P((___PSD
         ___WORD nargs,
         ___SCMOBJ proc,
         ___SCMOBJ stack_marker),
        (___PSV
         nargs,
         proc,
         stack_marker)
___PSDKR
___WORD nargs;
___SCMOBJ proc;
___SCMOBJ stack_marker;)
{
  ___PSGET
  ___SCMOBJ ___err;

  ___D_FP

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

  ___SET_FP(___PSFP)

  ___fp[-1] = ___PSR0;      /* create a frame with the same format as the */
  ___fp[-2] = stack_marker; /* one created for the return to C handler    */
                            /* in "_kernel.scm"                           */

  ___fp -= ___FRAME_SPACE(2) + nargs; /* move ___fp to point to last arg */

  ___POP_ARGS_IN_REGS(nargs) /* load arguments into appropriate registers */

  ___ST_ARG_REGS /* write back GVM argument registers to ___ps */

  ___PSR0 = ___GSTATE->handler_return_to_c;

  ___ps->fp = ___fp;
  ___ps->na = nargs;
  ___ps->pc = ___LABEL_ENTRY_GET(proc);
  ___PSSELF = proc;

#ifdef ___USE_PROPER_TAIL_CALL_EXCLUSIVELY_TO_EXIT_HOST

  ___BEGIN_TRY

  ___CALL_LABEL_HOST(___ps->pc,___ps);

  ___END_TRY

#else

#ifdef ___USE_UNWIND_C_STACK_TO_TRAMPOLINE
  do
    {
      ___SETUP_C_STACK_TRIP(___c_stack_ptr);
#endif

      ___BEGIN_TRY

      ___trampoline (___ps);

      ___END_TRY

#ifdef ___USE_UNWIND_C_STACK_TO_TRAMPOLINE
    } while (___err == ___FIX(___UNWIND_C_STACK_TO_TRAMPOLINE));
#endif

#endif

  if (___err != ___FIX(___UNWIND_C_STACK) ||
      stack_marker != ___ps->fp[___FRAME_SPACE(2)-2]) /*need more unwinding?*/
    ___throw_error (___PSP ___err);

  ___ps->fp += ___FRAME_SPACE(2);
  ___PSR0 = ___ps->fp[-1];

  return ___FIX(___NO_ERR);
}


___EXP_FUNC(___SCMOBJ,___run)
   ___P((___PSD
         ___SCMOBJ thunk),
        (___PSV
         thunk)
___PSDKR
___SCMOBJ thunk;)
{
  ___PSGET
  ___SCMOBJ ___err;
  ___SCMOBJ marker;

  ___ps->r[0] = ___GSTATE->handler_break;

  ___BEGIN_TRY

  if ((___err = ___make_sfun_stack_marker (___ps, &marker, thunk))
      == ___FIX(___NO_ERR))
    {
      ___err = ___call (___PSP 0, ___FIELD(marker,0), marker);
      ___kill_sfun_stack_marker (marker);
    }

  ___END_TRY

  return ___err;
}


#ifdef ___USE_UNWIND_C_STACK_TO_TRAMPOLINE


___EXP_FUNC(void,___unwind_c_stack_to_trampoline)
   ___P((___PSDNC),
        (___PSVNC)
___PSDKR)
{
  ___PSGET

  ___THROW (___FIX(___UNWIND_C_STACK_TO_TRAMPOLINE));
}


#endif


#ifdef ___SUPPORT_LOWLEVEL_EXEC


___EXP_FUNC(void,___lowlevel_exec)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  {

#ifdef __GNUC__

#define PS_FP   PS_FIELD("2")
#define PS_HP   PS_FIELD("6")
#define PS_R(n) PS_FIELD("(" n "+7)")
#define PS_PC   PS_FIELD("(0+5+7)")
#define PS_NA   PS_FIELD("(1+5+7)")

#if ___tSUBTYPED == 1
#define CONTROL_POINT_TAG "1"
#else
#define CONTROL_POINT_TAG "2"
#endif

#ifdef ___CPU_x86

#ifdef ___CPU_x86_32

#define reg_R0 "edi"
#define reg_R1 "eax"
#define reg_R2 "ebx"
#define reg_R3 "edx"
#define reg_R4 "esi"
#define reg_PS "ecx"
#define reg_FP "esp"
#define reg_HP "ebp"
#define reg_TMP reg_R1
#define reg_SP "esp"
#define PS_FIELD(field) field "*4(%%" reg_PS ")"

  /*
    GVM       ___________________C_ABI___________________
    r1   eax      return value
    r2   ebx  CS
    ps   ecx
    r3   edx
    sp   esp  CS  stack pointer
    hp   ebp  CS  optionally used as frame pointer
    r4   esi  CS
    r0   edi  CS
  */

#endif

#ifdef ___CPU_x86_64

#define reg_R0 "rdi"
#define reg_R1 "rax"
#define reg_R2 "rbx"
#define reg_R3 "rdx"
#define reg_R4 "rsi"
#define reg_PS "rcx"
#define reg_FP "rsp"
#define reg_HP "rbp"
#define reg_TMP reg_R1
#define reg_SP "rsp"
#define PS_FIELD(field) field "*8(%%" reg_PS ")"

  /*
    GVM       ___________________C_ABI___________________
    r1   rax      return value 1
    r2   rbx  CS
    ps   rcx      argument 4 to functions
    r3   rdx      argument 3 to functions; return value 2
    sp   rsp  CS  stack pointer
    hp   rbp  CS  optionally used as frame pointer
    r4   rsi      argument 2 to functions
    r0   rdi      argument 1 to functions
         r8       argument 5 to functions
         r9       argument 6 to functions
         r10      static chain pointer of function
         r11      temporary register
         r12  CS
         r13  CS
         r14  CS
         r15  CS  optionally used as GOT base pointer
  */

#endif

  __asm__ __volatile__ (

    "mov  %0, %%" reg_PS "\n\t"

#ifdef ___CPU_x86_64

    /* account for red zone */

    // "add  $-128, %%" reg_SP "\n\t"

#endif

    /* save callee-save registers */

    // "push %%" reg_R0 "\n\t"
    // "push %%" reg_R1 "\n\t"
    // "push %%" reg_R2 "\n\t"
    // "push %%" reg_R3 "\n\t"
    // "push %%" reg_R4 "\n\t"
    // "push %%" reg_HP "\n\t"
    /* "push %%" reg_PS "\n\t" */
    /* "push %%" reg_FP "\n\t" */

    /* setup handler for returning from lowlevel code */

#ifdef ___CPU_x86_32
    "mov  $return_from_lowlevel, %%" reg_TMP "\n\t"
#endif
#ifdef ___CPU_x86_64
    "lea  return_from_lowlevel(%%rip), %%" reg_TMP "\n\t"
#endif
    "mov  %%" reg_TMP ", " PS_FIELD("-1") "\n\t"
    "mov  %%" reg_SP ", " PS_FIELD("-2") "\n\t"

    /* setup frame pointer and heap pointer registers */

    "mov  " PS_FP ", %%" reg_FP "\n\t"
    "mov  " PS_HP ", %%" reg_HP "\n\t"

    /* setup self register */

    "mov  " PS_R("4") ", %%" reg_R4 "\n\t"

    "mov  " PS_PC ", %%" reg_TMP "\n\t"
#ifdef ___CPU_x86_32
    "cmpl $0x100000,-" CONTROL_POINT_TAG "-2*4(%%" reg_TMP ")\n\t"
    "jl   setup_other_registers\n\t"
    "add  $5, %%" reg_R4 "\n\t"
    "push %%" reg_R4 "\n\t"
    "add  $-5, %%" reg_R4 "\n\t"
#endif
#ifdef ___CPU_x86_64
    "cmpl $0x100000,-" CONTROL_POINT_TAG "-2*8(%%" reg_TMP ")\n\t"
    "jl   setup_other_registers\n\t"
    "add  $3, %%" reg_R4 "\n\t"
    "push %%" reg_R4 "\n\t"
    "add  $-3, %%" reg_R4 "\n\t"
#endif

    "\n"
    "setup_other_registers:\n\t"

    /* setup lowlevel registers from ___ps->r[...] */

    "mov  " PS_R("0") ", %%" reg_R0 "\n\t"
    "mov  " PS_R("1") ", %%" reg_R1 "\n\t"
    "mov  " PS_R("2") ", %%" reg_R2 "\n\t"
    "mov  " PS_R("3") ", %%" reg_R3 "\n\t"

    /*
     * set flags according to ___ps->na and jump to lowlevel code at
     * ___ps->pc
     */

    "jmp  *" PS_PC "\n\t"

    // "cmpl $0, " PS_NA "\n\t"
    // "je   nargs_0\n\t"
    // "cmpl $1, " PS_NA "\n\t"
    // "je   nargs_1\n\t"
    // "cmpl $2, " PS_NA "\n\t"
    // "je   nargs_2\n\t"
    // "cmpl $3, " PS_NA "\n\t"
    // "je   nargs_3\n\t"
    // "cmpl $4, " PS_NA "\n\t"
    // "je   nargs_4\n\t"

    // "\n"
    // "nargs_in_ps_na:\n\t"
    // /* set flags so these jumps succeed: jae jne jle jno jp  ja  jl  js */
    // "cmp  $0, %%cl\n\t"
    // "jmp  *" PS_PC "\n\t"

    // "\n"
    // "nargs_0:\n\t"
    // /* set flags so these jumps succeed: jb  jne jle jno jp  jbe jl  js */
    // "cmp  $-3, %%cl\n\t"
    // "jmp  *" PS_PC "\n\t"

    // "\n"
    // "nargs_1:\n\t"
    // /* set flags so these jumps succeed: jae je  jle jno jp  jbe jge jns */
    // "cmp  %%cl, %%cl\n\t"
    // "jmp  *" PS_PC "\n\t"

    // "\n"
    // "nargs_2:\n\t"
    // /* set flags so these jumps succeed: jae jne jg  jno jp  ja  jge jns */
    // "cmp  $-123, %%cl\n\t"
    // "jmp  *" PS_PC "\n\t"

    // "\n"
    // "nargs_3:\n\t"
    // /* set flags so these jumps succeed: jae jne jle jo  jp  ja  jl  jns */
    // "cmp  $10, %%cl\n\t"
    // "jmp  *" PS_PC "\n\t"

    // "\n"
    // "nargs_4:\n\t"
    // /* set flags so these jumps succeed: jae jne jle jno jnp ja  jl  js */
    // "cmp  $2, %%cl\n\t"
    // "jmp  *" PS_PC "\n\t"

    "\n"
    "return_from_lowlevel:"
    "\n\t"

    /* recover ___ps->na from flags */

    // "jae  nargs_not_0\n\t"
    // "movl $0, " PS_NA "\n\t"
    // "jmp  nargs_done\n"
    // "nargs_not_0:\n\t"

    // "jne  nargs_not_0_or_1\n\t"
    // "movl $1, " PS_NA "\n\t"
    // "jmp  nargs_done\n"
    // "nargs_not_0_or_1:\n\t"

    // "jle  nargs_not_0_or_1_or_2\n\t"
    // "movl $2, " PS_NA "\n\t"
    // "jmp  nargs_done\n"
    // "nargs_not_0_or_1_or_2:\n\t"

    // "jno  nargs_not_0_or_1_or_2_or_3\n\t"
    // "movl $3, " PS_NA "\n\t"
    // "jmp  nargs_done\n"
    // "nargs_not_0_or_1_or_2_or_3:\n\t"

    // "jp   nargs_done\n\t"
    // "movl $4, " PS_NA "\n\t"

    // "\n"
    // "nargs_done:\n\t"

    /* save lowlevel registers to ___ps->r[...] */

    "mov  %%" reg_R0 ", " PS_R("0") "\n\t"
    "mov  %%" reg_R1 ", " PS_R("1") "\n\t"
    "mov  %%" reg_R2 ", " PS_R("2") "\n\t"
    "mov  %%" reg_R3 ", " PS_R("3") "\n\t"

    /* recover the destination control point in ___ps->pc */

    "pop  %%" reg_TMP "\n\t"
    "add  $-3, %%" reg_TMP "\n\t"
    "mov  %%" reg_TMP ", " PS_PC "\n\t"

#ifdef ___CPU_x86_32
    "cmpl $0x100000,-" CONTROL_POINT_TAG "-2*4(%%" reg_TMP ")\n\t"
    "jl   store_self_register\n\t"
    "pop  %%" reg_R4 "\n\t"
    "add  $-3, %%" reg_R4 "\n\t"
#endif
#ifdef ___CPU_x86_64
    "cmpl $0x100000,-" CONTROL_POINT_TAG "-2*8(%%" reg_TMP ")\n\t"
    "jl   store_self_register\n\t"
    "pop  %%" reg_R4 "\n\t"
    "add  $-6, %%" reg_R4 "\n\t"
#endif

    "\n"
    "store_self_register:\n\t"
    "mov  %%" reg_R4 ", " PS_R("4") "\n\t"

    /* save frame pointer and heap pointer registers */

    "mov  %%" reg_FP ", " PS_FP "\n\t"
    "mov  %%" reg_HP ", " PS_HP "\n\t"

    /* restore callee-save registers */

    "mov  " PS_FIELD("-2") ", %%" reg_SP "\n\t"
    /* "pop  %%" reg_FP "\n\t" */
    /* "pop  %%" reg_PS "\n\t" */
    // "pop  %%" reg_HP "\n\t"
    // "pop  %%" reg_R4 "\n\t"
    // "pop  %%" reg_R3 "\n\t"
    // "pop  %%" reg_R2 "\n\t"
    // "pop  %%" reg_R1 "\n\t"
    // "pop  %%" reg_R0 "\n\t"

#ifdef ___CPU_x86_64

    /* account for red zone */

    // "add  $128, %%" reg_SP "\n\t"

#endif

    : /* no outputs */
    : /* inputs */
      "m" (___ps)
    : /* clobbers */
      "%" reg_PS,
      "%" reg_TMP,
      "%" reg_R0,
      "%" reg_R1,
      "%" reg_R2,
      "%" reg_R3,
      "%" reg_R4,
      "%" reg_HP
  );

#endif

#ifdef ___CPU_arm

#define reg_R0 "r0"
#define reg_R1 "r1"
#define reg_R2 "r2"
#define reg_R3 "r3"
#define reg_R4 "r4"
#define reg_PS "r5"
#define reg_FP "sp"
#define reg_HP "r6"
#define reg_TMP "r7"
#define reg_SP "sp"
#define reg_LR "lr"
#define PS_FIELD(field) "[" reg_PS ",#" PS_OFFSET "+(" field "*4)]"
#define PS_OFFSET "4"

  /*
    GVM       ___________________C_ABI___________________
    r0   r0       parameter 1 and return value
    r1   r1       parameter 2
    r2   r2       parameter 3
    r3   r3       parameter 4
    r4   r4  CS
    ps   r5  CS
    hp   r6  CS
         r7  CS
         r8  CS
         r9  CS
         r10 CS
         r11 CS  frame pointer
         r12     intra-procedure-call scratch register
    sp   r13 CS  stack pointer (sp)
         r14 CS  link register (lr)
         r15 CS  program counter (pc)
  */

  __asm__ __volatile__ (

    "mov  " reg_PS ", %0\n\t"
    "sub  " reg_PS ", #" PS_OFFSET "\n\t"

    /* setup handler for returning from lowlevel code */

    "adr  " reg_TMP ", return_from_lowlevel\n\t"
    "str  " reg_TMP ", " PS_FIELD("-1") "\n\t"
    "str  " reg_SP ", " PS_FIELD("-2") "\n\t"

    /* setup frame pointer and heap pointer registers */

    "ldr  " reg_FP ", " PS_FP "\n\t"
    "ldr  " reg_HP ", " PS_HP "\n\t"

    /* setup self register */

    "ldr  " reg_R4 ", " PS_R("4") "\n\t"

    "\n"
    "setup_other_registers:\n\t"

    /* setup lowlevel registers from ___ps->r[...] */

    "ldr  " reg_R0 ", " PS_R("0") "\n\t"
    "ldr  " reg_R1 ", " PS_R("1") "\n\t"
    "ldr  " reg_R2 ", " PS_R("2") "\n\t"
    "ldr  " reg_R3 ", " PS_R("3") "\n\t"

    /*
     * set flags according to ___ps->na and jump to lowlevel code at
     * ___ps->pc
     */

    "ldr  pc, " PS_PC "\n\t"

    "\n"
    "return_from_lowlevel:"
    "\n\t"

    /* save lowlevel registers to ___ps->r[...] */

    "str  " reg_R0 ", " PS_R("0") "\n\t"
    "str  " reg_R1 ", " PS_R("1") "\n\t"
    "str  " reg_R2 ", " PS_R("2") "\n\t"
    "str  " reg_R3 ", " PS_R("3") "\n\t"

    /* recover the destination control point in ___ps->pc */

    "sub  " reg_LR ", #4\n\t"
    "str  " reg_LR ", " PS_PC "\n\t"

    "ldr  " reg_TMP ", [" reg_LR ", #-" CONTROL_POINT_TAG "-2*4]\n\t"
    "cmp  " reg_TMP ", #0x100000\n\t"
    "blt  store_self_register\n\t"
    "sub  " reg_R4 ", #(4-" CONTROL_POINT_TAG ")\n\t"

    "\n"
    "store_self_register:\n\t"
    "str  " reg_R4 ", " PS_R("4") "\n\t"

    /* save frame pointer and heap pointer registers */

    "str  " reg_FP ", " PS_FP "\n\t"
    "str  " reg_HP ", " PS_HP "\n\t"

    /* restore callee-save registers */

    "ldr  " reg_SP ", " PS_FIELD("-2") "\n\t"

    : /* no outputs */
    : /* inputs */
      "r" (___ps)
    : /* clobbers */
      reg_PS,
      reg_TMP,
      reg_R0,
      reg_R1,
      reg_R2,
      reg_R3,
      reg_R4,
      reg_HP,
      reg_LR
  );

#endif

#ifdef ___CPU_riscv

#define reg_R0 "s2"
#define reg_R1 "s3"
#define reg_R2 "s4"
#define reg_R3 "s5"
#define reg_R4 "s6"
#define reg_PS "s10"
#define reg_FP "sp"
#define reg_HP "s11"
#define reg_TMP0 "s7"
#define reg_TMP1 "s8"
#define reg_SP "sp"
#define reg_RA "ra" /* XXX */

/* XXX */
#if __riscv_xlen == 64
#define PS_OFFSET "8"
#define PS_FIELD(field) PS_OFFSET "+(" field "*8)(" reg_PS ")"
#else
#define PS_OFFSET "4"
#define PS_FIELD(field) PS_OFFSET "+(" field "*4)(" reg_PS ")"
#endif

  /*
     TODO
  */

  __asm__ __volatile__ (

    "mv " reg_PS ", %0\n\t"
    "addi " reg_PS ", " reg_PS ", -" PS_OFFSET "\n\t"

    /* setup handler for returning from lowlevel code */

    "la " reg_TMP0 ", return_from_lowlevel\n\t" // XXX
#if __riscv_xlen == 64
    "sd " reg_TMP0 ", " PS_FIELD("-1") "\n\t"
    "sd " reg_SP ", " PS_FIELD("-2") "\n\t"
#else
    "sw " reg_TMP0 ", " PS_FIELD("-1") "\n\t"
    "sw " reg_SP ", " PS_FIELD("-2") "\n\t"
#endif

    /* setup frame pointer and heap pointer registers */

#if __riscv_xlen == 64
    "ld " reg_FP ", " PS_FP "\n\t"
    "ld " reg_HP ", " PS_HP "\n\t"
#else
    "lw " reg_FP ", " PS_FP "\n\t"
    "lw " reg_HP ", " PS_HP "\n\t"
#endif

    /* setup self register */

#if __riscv_xlen == 64
    "ld " reg_R4 ", " PS_R("4") "\n\t"
#else
    "lw " reg_R4 ", " PS_R("4") "\n\t"
#endif

    "\n"
    "setup_other_registers:\n\t"

    /* setup lowlevel registers from ___ps->r[...] */

#if __riscv_xlen == 64
    "ld " reg_R0 ", " PS_R("0") "\n\t"
    "ld " reg_R1 ", " PS_R("1") "\n\t"
    "ld " reg_R2 ", " PS_R("2") "\n\t"
    "ld " reg_R3 ", " PS_R("3") "\n\t"
#else
    "lw " reg_R0 ", " PS_R("0") "\n\t"
    "lw " reg_R1 ", " PS_R("1") "\n\t"
    "lw " reg_R2 ", " PS_R("2") "\n\t"
    "lw " reg_R3 ", " PS_R("3") "\n\t"
#endif

    /*
     * set flags according to ___ps->na and jump to lowlevel code at
     * ___ps->pc
     */

#if __riscv_xlen == 64
    "ld " reg_TMP0 ", " PS_PC "\n\t"
#else
    "lw " reg_TMP0 ", " PS_PC "\n\t"
#endif
    "jr " reg_TMP0 "\n\t"

    "\n"
    "return_from_lowlevel:"
    "\n\t"

    /* save lowlevel registers to ___ps->r[...] */

#if __riscv_xlen == 64
    "sd " reg_R0 ", " PS_R("0") "\n\t"
    "sd " reg_R1 ", " PS_R("1") "\n\t"
    "sd " reg_R2 ", " PS_R("2") "\n\t"
    "sd " reg_R3 ", " PS_R("3") "\n\t"
#else
    "sw " reg_R0 ", " PS_R("0") "\n\t"
    "sw " reg_R1 ", " PS_R("1") "\n\t"
    "sw " reg_R2 ", " PS_R("2") "\n\t"
    "sw " reg_R3 ", " PS_R("3") "\n\t"
#endif

    /* recover the destination control point in ___ps->pc */

    "addi " reg_RA ", " reg_RA ", -" PS_OFFSET "+" CONTROL_POINT_TAG "\n\t" /* XXX */
#if __riscv_xlen == 64
    "sd " reg_RA ", " PS_PC "\n\t"
#else
    "sw " reg_RA ", " PS_PC "\n\t"
#endif

    /* XXX */
#if __riscv_xlen == 64
    "ld " reg_TMP0 ", -" CONTROL_POINT_TAG "-(2*8)(" reg_RA ")\n\t"
#else
    "lw " reg_TMP0 ", -" CONTROL_POINT_TAG "-(2*4)(" reg_RA ")\n\t"
#endif
    "li " reg_TMP1 ", 0x100000\n\t"
    "blt " reg_TMP0 ", " reg_TMP1 ", store_self_register\n\t"
    "addi " reg_R4 ", " reg_R4 ", -" PS_OFFSET "+" CONTROL_POINT_TAG "\n\t" /* XXX */

    "\n"
    "store_self_register:\n\t"
#if __riscv_xlen == 64
    "sd " reg_R4 ", " PS_R("4") "\n\t"
#else
    "sw " reg_R4 ", " PS_R("4") "\n\t"
#endif

    /* save frame pointer and heap pointer registers */

#if __riscv_xlen == 64
    "sd " reg_FP ", " PS_FP "\n\t"
    "sd " reg_HP ", " PS_HP "\n\t"
#else
    "sw " reg_FP ", " PS_FP "\n\t"
    "sw " reg_HP ", " PS_HP "\n\t"
#endif

    /* restore callee-save registers */

#if __riscv_xlen == 64
    "ld " reg_SP ", " PS_FIELD("-2") "\n\t"
#else
    "lw " reg_SP ", " PS_FIELD("-2") "\n\t"
#endif

    : /* no outputs */
    : /* inputs */
      "r" (___ps)
    : /* clobbers */
      reg_PS,
      reg_TMP0,
      reg_TMP1,
      reg_R0,
      reg_R1,
      reg_R2,
      reg_R3,
      reg_R4,
      reg_HP,
      reg_RA
  );

#endif

#endif

  }

  {
    ___WORD ___pc = ___ps->pc;
    ___EXIT_HOST();
  }
}


#endif


___SCMOBJ ___machine_code_block_fixup
   ___P((___processor_state ___ps,
         void *mcb,
         ___SCMOBJ fixup_locs,
         ___SCMOBJ fixup_objs),
        (___ps,
         mcb,
         fixup_locs,
         fixup_objs)
___processor_state ___ps;
void *mcb;
___SCMOBJ fixup_locs;
___SCMOBJ fixup_objs;)
{
#ifdef ___SUPPORT_LOWLEVEL_EXEC

  ___WORD code = ___CAST(___WORD,mcb);
  ___U8 *ptr = ___CAST(___U8*,___BODY_AS(fixup_locs,___tSUBTYPED));
  ___WORD pos = 0;
  ___U8 loc;
  ___WORD val = ___FAL;

  while ((loc = *ptr++) != 0)
    {
      if (loc < 2)
        pos += 127;
      else
        {
          ___WORD fixup_pos = pos + (loc>>1) - 1;
          ___WORD x;
          int op;
          ___WORD arg;

          switch (loc & 1)
            {
            case 0:
              x = *___CAST(___S32*,code+fixup_pos);
              break;

            case 1:
              x = *___CAST(___WORD*,code+fixup_pos);
              break;
            }

          op = x & 0xff;
          arg = x >> 8;

          switch (op & 0x0f)
            {
            case 0:
              val = arg;
              break;

            case 1:
              val = code + fixup_pos + arg;
              break;

            case 2:
              val = ___VECTORREF(fixup_objs, ___FIX(arg));
              break;

            case 3:
              val = ___VECTORREF(fixup_objs, ___FIX(arg));
              val = ___make_global_var (val);
              val = ___CAST(___WORD, &___GLOBALVARREF(val));
              break;

            case 4:
              val = ___VECTORREF(fixup_objs, ___FIX(arg));
              val = ___make_global_var (val);
              val = ___CAST(___WORD, &___GLOBALVARPRIMREF(val));
              break;

            case 5:
              switch (arg)
                {
                case 0:
                  val = ___CAST(___WORD, ___lowlevel_exec);
                  break;
                }
              break;
            }

          switch (loc & 1)
            {
            case 0:
              switch (op >> 4)
                {
                case 0:
                  *___CAST(___S32*,code+fixup_pos) = val;
                  pos = fixup_pos + sizeof(___S32);
                  break;

                case 1:
                  {
                    /* fixup movw/movt THUMB2 pair on ARM */

                    ___S16 *ptr = ___CAST(___S16*,code+fixup_pos-4);
                    ___S16 movw0 = ptr[0];
                    ___S16 movw1 = ptr[1];

                    /* generate the movw instruction */
                    ptr[0] = movw0
                             + ((val >> 12) & 0x000f)  /* bits 12 to 15 */
                             + ((val >> 1) & 0x0400);  /* bit 11 */
                    ptr[1] = movw1
                             + (val & 0x00ff)  /* bits 0 to 7 */
                             + ((val << 4) & 0x7000);  /* bits 8 to 10 */

                    /* generate the movt instruction */
                    val = val >> 16;
                    ptr[2] = movw0 + 0x0080
                             + ((val >> 12) & 0x000f)  /* bits 12 to 15 */
                             + ((val >> 1) & 0x0400);  /* bit 11 */
                    ptr[3] = movw1
                             + (val & 0x00ff)  /* bits 0 to 7 */
                             + ((val << 4) & 0x7000);  /* bits 8 to 10 */

                    pos = fixup_pos + sizeof(___S32);
                    break;
                  }

                case 2:
                  {
                    /* fixup lui/addi pair on 32-bit RISC-V */

                    ___S32 *ptr = ___CAST(___S32*,code+fixup_pos-4);
                    ___S32 opcode = ptr[0] & 0x7f; /* opcode for lui */
                    ___S32 rd = ptr[0] & 0xf80;

                    ptr[0] = opcode + rd + (val & 0xfffff000); /* lui */
                    ptr[1] = (opcode - 0x24) + rd + (rd << 8) + (val << 20); /* XXX addi */

                    pos = fixup_pos + sizeof(___S32);
                    break;
                  }
                }
              break;

            case 1:
              switch (op >> 4)
                {
                case 0:
                  *___CAST(___WORD*,code+fixup_pos) = val;
                  pos = fixup_pos + sizeof(___WORD);
                  break;

                case 2:
                  {
                    /* fixup jal/ld pair on 64-bit RISC-V */

                    ___S32 *ptr = ___CAST(___S32*,code+fixup_pos-8);

                    ptr[3] = ptr[1]; /* ld */
                    ptr[2] = val >> 32;
                    ptr[1] = val;

                    pos = fixup_pos + sizeof(___WORD);
                    break;
                  }
                }
              break;
            }
        }
    }

  return val;

#else

  return ___FAL;

#endif
}


/*
 * In the following functions, proc points to a label structure
 * (___label_struct) that was either created by the C backend or the
 * CPU backend.  If the host field of the label structure is equal to
 * ___lowlevel_exec then it was created by the CPU backend and the
 * word just before the host field is a pointer to the parent intro
 * structure.
 */

#define ___LOWLEVEL_LABEL(lbl) \
(___LABEL_HOST_GET(lbl) == ___lowlevel_exec)

#define ___LOWLEVEL_LABEL_PARENT_GET(lbl) *___SUBTYPED_TO(lbl,___LABEL_HOST-1)
#define ___LOWLEVEL_LABEL_NEXT_GET(lbl) *___SUBTYPED_TO(lbl,___LABEL_HOST-2)
#define ___LOWLEVEL_LABEL_NBLBLS_GET(lbl) *___SUBTYPED_TO(lbl,___LABEL_HOST-3)
#define ___LOWLEVEL_LABEL_INFO_GET(lbl) *___SUBTYPED_TO(lbl,___LABEL_HOST-4)
#define ___LOWLEVEL_LABEL_NAME_GET(lbl) *___SUBTYPED_TO(lbl,___LABEL_HOST-5)


___HIDDEN ___SCMOBJ ___subprocedure_parent_intro
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
  ___SCMOBJ probe = proc;

  do
    {
      probe -= ___LABEL_SIZE * ___WS;
    } while (!___TESTSUBTYPETAG(probe, ___sVECTOR));

  return probe;
}


___SCMOBJ ___make_subprocedure
   ___P((___SCMOBJ proc,
         ___SCMOBJ id),
        (proc,
         id)
___SCMOBJ proc;
___SCMOBJ id;)
{
#ifdef ___SUPPORT_LOWLEVEL_EXEC

  if (___LOWLEVEL_LABEL(proc))
    {
      ___SCMOBJ probe = ___LOWLEVEL_LABEL_PARENT_GET(proc);

      if (___FIXLT(id, ___FIX(0)) ||
          ___FIXGE(id, ___LOWLEVEL_LABEL_NBLBLS_GET(probe)))
        return ___FAL;

      while (___FIXGT(id, ___FIX(0)))
        {
          probe = ___LOWLEVEL_LABEL_NEXT_GET(probe);
          id = ___FIXSUB(id, ___FIX(1));
        }

      return probe;
    }

#endif

  {
    ___SCMOBJ intro = ___subprocedure_parent_intro (proc);

    if (___FIXLT(id, ___FIX(0)) ||
        ___FIXGE(id, ___FIX(___HD_FIELDS(___SUBTYPED_HEADER(intro)))))
      return ___FAL;

    return intro + (___INT(id)+1) * ___LABEL_SIZE * ___WS;
  }
}


___SCMOBJ ___subprocedure_id
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
#ifdef ___SUPPORT_LOWLEVEL_EXEC

  if (___LOWLEVEL_LABEL(proc))
    {
      ___SCMOBJ probe = ___LOWLEVEL_LABEL_PARENT_GET(proc);
      ___SCMOBJ id = ___FIX(0);

      while (!___EQP(proc, probe))
        {
          probe = ___LOWLEVEL_LABEL_NEXT_GET(probe);
          id = ___FIXADD(id, ___FIX(1));
        }

      return id;
    }

#endif

  return ___FIX((proc - ___subprocedure_parent_intro (proc)) / (___LABEL_SIZE * ___WS) - 1);
}


___SCMOBJ ___subprocedure_parent
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
  return ___make_subprocedure (proc, ___FIX(0));
}


___SCMOBJ ___subprocedure_parent_info
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
#ifdef ___SUPPORT_LOWLEVEL_EXEC

  if (___LOWLEVEL_LABEL(proc))
    return ___LOWLEVEL_LABEL_INFO_GET(___LOWLEVEL_LABEL_PARENT_GET(proc));

#endif

  return ___LABEL_INFO_GET(___subprocedure_parent_intro (proc));
}


___SCMOBJ ___subprocedure_parent_name
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
#ifdef ___SUPPORT_LOWLEVEL_EXEC

  if (___LOWLEVEL_LABEL(proc))
    return ___LOWLEVEL_LABEL_NAME_GET(___LOWLEVEL_LABEL_PARENT_GET(proc));

#endif

  return ___LABEL_NAME_GET(___subprocedure_parent_intro (proc));
}


___SCMOBJ ___subprocedure_nb_parameters
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
   return ___FIX(___PRD_NBPARMS(___SUBTYPED_HEADER(proc)));
}


___SCMOBJ ___subprocedure_nb_closed
   ___P((___SCMOBJ proc),
        (proc)
___SCMOBJ proc;)
{
  return ___FIX(___PRD_NBCLOSED(___SUBTYPED_HEADER(proc)));
}


#ifdef ___USE_print_source_location


void ___print_source_location
   ___P((___source_location *loc),
        (loc)
___source_location *loc;)
{
  ___printf ("%s:%d:", loc->file, loc->line);
}


#endif


#ifdef ___DEBUG_CTRL_FLOW_HISTORY


void ___print_ctrl_flow_history_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  int i;

  for (i=0; i<___CTRL_FLOW_HISTORY_LENGTH; i++)
    {
      ___source_location *loc =
        &___ps->ctrl_flow_history[(___ps->ctrl_flow_history_index+i) %
                                  ___CTRL_FLOW_HISTORY_LENGTH];
      if (loc->line > 0)
        {
          ___print_source_location (loc);
          ___printf ("\n");
        }
    }
}


void ___print_ctrl_flow_history_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  int i;

  ___printf ("Most recent control-flow history:\n");

  for (i=0; i<___vms->processor_count; i++)
    {
      ___printf ("\nP%d:\n", i);
      ___print_ctrl_flow_history_pstate (___PSTATE_FROM_PROCESSOR_ID(i,___vms));
    }
}


void ___print_ctrl_flow_history ___PVOID
{
  ___print_ctrl_flow_history_vmstate (___VMSTATE);
}


void ___print_ctrl_flow_last_seen_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___source_location *loc =
    &___ps->ctrl_flow_history[(___ps->ctrl_flow_history_index+___CTRL_FLOW_HISTORY_LENGTH-1) %
                              ___CTRL_FLOW_HISTORY_LENGTH];

  if (loc->line > 0)
    ___print_source_location (loc);
  else
      ___printf ("unknown");

  ___printf ("\n");
}


void ___print_ctrl_flow_last_seen_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  int i;

  ___printf ("Control-flow last seen:\n");

  for (i=0; i<___vms->processor_count; i++)
    {
      ___printf ("P%d: ", i);
      ___print_ctrl_flow_last_seen_pstate (___PSTATE_FROM_PROCESSOR_ID(i,___vms));
    }
}


void ___print_ctrl_flow_last_seen ___PVOID
{
  ___print_ctrl_flow_last_seen_vmstate (___VMSTATE);
}


#endif


#ifdef ___DEBUG_HOST_CHANGES

___EXP_FUNC(void,___register_host_entry)
   ___P((___PSD
         ___WORD start,
         char *module_name,
         char *file,
         int line),
        (___PSV
         start,
         module_name,
         file,
         line)
___PSDKR
___WORD start;
char *module_name;
char *file;
int line;)
{
  ___PSGET
  ___SCMOBJ sym;
  ___source_location loc;

  loc.file = file;
  loc.line = line;

  ___print_source_location (&loc);

  ___printf (" ");

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

}

#endif


/*---------------------------------------------------------------------------*/

/*
 * Setup program and execute it.
 */


___HIDDEN void cleanup_os_and_mem_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___cleanup_mem_pstate (___ps);
  ___cleanup_os_pstate (___ps);
}


___HIDDEN ___SCMOBJ setup_os_and_mem_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  ___SCMOBJ err;

  if ((err = ___setup_os_pstate (___ps)) == ___FIX(___NO_ERR))
    {
      if ((err = ___setup_mem_pstate (___ps)) != ___FIX(___NO_ERR))
        ___cleanup_os_pstate (___ps);
    }

  return err;
}


___HIDDEN void cleanup_os_and_mem_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  ___cleanup_mem_vmstate (___vms);
  ___cleanup_os_vmstate (___vms);
}


___HIDDEN ___SCMOBJ setup_os_and_mem_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  ___SCMOBJ err;

  if ((err = ___setup_os_vmstate (___vms)) == ___FIX(___NO_ERR))
    {
      if ((err = ___setup_mem_vmstate (___vms)) != ___FIX(___NO_ERR))
        ___cleanup_os_vmstate (___vms);
    }

  return err;
}


___HIDDEN void cleanup_os_and_mem ___PVOID
{
  ___cleanup_mem ();
  ___cleanup_os ();
}


___HIDDEN ___SCMOBJ setup_os_and_mem ___PVOID
{
  ___SCMOBJ err;

  if ((err = ___setup_os ()) == ___FIX(___NO_ERR))
    {
      if ((err = ___setup_mem ()) != ___FIX(___NO_ERR))
        ___cleanup_os ();
    }

  return err;
}


#ifndef ___SINGLE_THREADED_VMS

___HIDDEN void setup_sync_op_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  SYNC_INIT_MSG(___ps->sync_id0);
  SYNC_INIT_MSG(___ps->sync_id1);
  SYNC_INIT_MSG(___ps->sync_id2);

  ___MUTEX_INIT(___ps->sync_mut);
  ___CONDVAR_INIT(___ps->sync_cv);
}

#endif


___EXP_FUNC(void,___cleanup_pstate)
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
  cleanup_interrupts_pstate (___ps);
  cleanup_os_and_mem_pstate (___ps);
}


___EXP_FUNC(___SCMOBJ,___setup_pstate)
   ___P((___processor_state ___ps,
         ___virtual_machine_state ___vms),
        (___ps,
         ___vms)
___processor_state ___ps;
___virtual_machine_state ___vms;)
{
  ___SCMOBJ err;
  int i;

  /*
   * Processors need to know in which VM they are.
   */

#ifndef ___SINGLE_THREADED_VMS
  ___ps->vmstate = ___vms;
#endif

  /*
   * Setup interrupt system of this processor.
   */

  if (!(___vms == &___GSTATE->vmstate0 && ___PROCESSOR_ID(___ps, ___vms) == 0))
    setup_interrupts_pstate (___ps);  /* processor 0 of vm 0 has early init */

  /*
   * Setup processor's OS specific structures and memory management.
   */

  if ((err = setup_os_and_mem_pstate (___ps)) != ___FIX(___NO_ERR))
    return err;

  ___ACTLOG_PS(run,green);

  /*
   * Setup Scheme processor object of this processor.
   */

  setup_processor_scmobj_pstate (___ps);

  /*
   * Setup registers.
   */

  for (i=0; i<sizeof(___ps->r)/sizeof(*___ps->r); i++)
    ___ps->r[i] = ___VOID;

  for (i=0; i<sizeof(___ps->saved)/sizeof(*___ps->saved); i++)
    ___ps->saved[i] = ___VOID;

  for (i=0; i<sizeof(___ps->type_cache)/sizeof(*___ps->type_cache); i++)
    ___ps->type_cache[i] = ___VOID;

  /*
   * Copy handlers from global state to processor state.
   */

  ___ps->handler_sfun_conv_error = ___GSTATE->handler_sfun_conv_error;
  ___ps->handler_cfun_conv_error = ___GSTATE->handler_cfun_conv_error;
  ___ps->handler_stack_limit     = ___GSTATE->handler_stack_limit;
  ___ps->handler_heap_limit      = ___GSTATE->handler_heap_limit;
  ___ps->handler_not_proc        = ___GSTATE->handler_not_proc;
  ___ps->handler_not_proc_glo    = ___GSTATE->handler_not_proc_glo;
  ___ps->handler_wrong_nargs     = ___GSTATE->handler_wrong_nargs;
  ___ps->handler_get_rest        = ___GSTATE->handler_get_rest;
  ___ps->handler_get_key         = ___GSTATE->handler_get_key;
  ___ps->handler_get_key_rest    = ___GSTATE->handler_get_key_rest;
  ___ps->handler_force           = ___GSTATE->handler_force;
  ___ps->handler_return_to_c     = ___GSTATE->handler_return_to_c;
  ___ps->handler_break           = ___GSTATE->handler_break;
  ___ps->internal_return         = ___GSTATE->internal_return;
  ___ps->dynamic_env_bind_return = ___GSTATE->dynamic_env_bind_return;

  /*
   * Setup exception handling.
   */

#ifdef ___USE_SETJMP

  ___ps->catcher = 0;

#endif

  /*
   * Setup synchronous operation system.
   */

#ifndef ___SINGLE_THREADED_VMS

  setup_sync_op_pstate (___ps);

#endif

  return ___FIX(___NO_ERR);
}


___EXP_FUNC(void,___cleanup_vmstate)
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  cleanup_os_and_mem_vmstate (___vms);
  ___cleanup_actlog_vmstate (___vms);
}


___EXP_FUNC(___SCMOBJ,___setup_vmstate)
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
  ___SCMOBJ err;

  /*
   * Virtual machine starts off with a single processor.
   */

  ___vms->processor_count = 1;
  ___vms->mem.target_processor_count_ = 1;

  /*
   * Setup ticket lock debugging.
   */

#ifdef ___DEBUG_TICKETLOCK

  ___vms->ticketlock_history_index = 0;

#endif

  /*
   * Setup Scheme VM object.
   */

  setup_vm_scmobj_vmstate (___vms);

  /*
   * Setup virtual machine's activity log.
   */

  if ((err = ___setup_actlog_vmstate (___vms)) != ___FIX(___NO_ERR))
    return err;

  /*
   * Setup virtual machine's OS specific structures and memory management.
   */

  setup_os_and_mem_vmstate (___vms);

  /*
   * Setup the main processor of the virtual machine.
   */

  return ___setup_pstate (___PSTATE_FROM_PROCESSOR_ID(0,___vms), ___vms);
}


___EXP_FUNC(void,___cleanup) ___PVOID
{
  ___processor_state ___ps = ___PSTATE;
  ___virtual_machine_state ___vms = &___GSTATE->vmstate0;

  /*
   * Only do cleanup once after successful setup.
   */

  if (___GSTATE->setup_state != 1)
    return;

  ___GSTATE->setup_state = 2;

  ___cleanup_all_interrupt_handling ();

  if (___vms->processor_count == 0)
    return;

#ifndef ___SINGLE_THREADED_VMS

  /*
   * Shutdown processors of this VM except for processor 0.
   */

  ___current_vm_resize (___PSP ___FAL, 1);

#endif

  ___cleanup_pstate (___ps);

#ifdef ___SINGLE_VM

  ___cleanup_vmstate (&___GSTATE->vmstate0);

#else

  ___MUTEX_LOCK(___GSTATE->vm_list_mut);

  do
    {
      ___vms = ___vms->prev;
      ___cleanup_vmstate (___vms);
    }
  while (___vms != &___GSTATE->vmstate0);

  ___MUTEX_DESTROY(___GSTATE->vm_list_mut);

#endif

  cleanup_os_and_mem ();
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
  int index;
  setup_params->version             = 0;
  setup_params->argv                = setup_params->reset_argv;
  setup_params->min_heap            = 0;
  setup_params->max_heap            = 0;
  setup_params->live_percent        = 0;
#ifdef ___SINGLE_THREADED_VMS
  setup_params->parallelism_level   = 1;
#else
  setup_params->parallelism_level   = 0;
#endif
  setup_params->adjust_heap_hook    = 0;
  setup_params->display_error       = 0;
  setup_params->fatal_error         = 0;
  setup_params->standard_level      = 0;
  setup_params->debug_settings      = 0;
  for (index=0; index<=___IO_SETTINGS_LAST; index++)
    setup_params->io_settings[index] = 0;
  setup_params->gambitdir           = 0;
  setup_params->gambitdir_map       = 0;
  setup_params->module_search_order = 0;
  setup_params->module_whitelist    = 0;
  setup_params->repl_client_addr    = 0;
  setup_params->repl_server_addr    = 0;
  setup_params->linker              = 0;
  setup_params->reset_argv0[0]      = '\0'; /* empty string */
  setup_params->reset_argv[0]       = setup_params->reset_argv0;
  setup_params->reset_argv[1]       = 0;
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


___EXP_FUNC(int,___get_parallelism_level) ___PVOID
{
  return ___GSTATE->setup_params.parallelism_level;
}


___EXP_FUNC(void,___set_parallelism_level)
   ___P((int level),
        (level)
int level;)
{
  ___GSTATE->setup_params.parallelism_level = level;
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


___EXP_FUNC(int,___get_debug_settings) ___PVOID
{
  return ___GSTATE->setup_params.debug_settings;
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


___EXP_FUNC(int,___get_io_settings)
   ___P((int index),
        (index)
int index;)
{
  return ___GSTATE->setup_params.io_settings[index];
}


___EXP_FUNC(void,___set_io_settings)
   ___P((int index,
         int settings),
        (index,
         settings)
int index;
int settings;)
{
  ___GSTATE->setup_params.io_settings[index] = settings;
}


___EXP_FUNC(___UCS_2STRING,___get_gambitdir) ___PVOID
{
  return ___GSTATE->setup_params.gambitdir;
}


___EXP_FUNC(void,___set_gambitdir)
   ___P((___UCS_2STRING gambitdir),
        (gambitdir)
___UCS_2STRING gambitdir;)
{
  ___addref_string (gambitdir);
#if 0
  /* can't release old setting because it is initially not an RC object */
  ___release_string (___GSTATE->setup_params.gambitdir);
#endif
  ___GSTATE->setup_params.gambitdir = gambitdir;
}


___EXP_FUNC(___UCS_2STRING*,___get_gambitdir_map) ___PVOID
{
  return ___GSTATE->setup_params.gambitdir_map;
}


___EXP_FUNC(void,___set_gambitdir_map)
   ___P((___UCS_2STRING *gambitdir_map),
        (gambitdir_map)
___UCS_2STRING *gambitdir_map;)
{
  ___addref_string_list (gambitdir_map);
#if 0
  /* can't release old setting because it is initially not an RC object */
  ___release_string_list (___GSTATE->setup_params.gambitdir_map);
#endif
  ___GSTATE->setup_params.gambitdir_map = gambitdir_map;
}


___EXP_FUNC(___UCS_2STRING*,___get_module_search_order) ___PVOID
{
  return ___GSTATE->setup_params.module_search_order;
}


___EXP_FUNC(void,___set_module_search_order)
   ___P((___UCS_2STRING *module_search_order),
        (module_search_order)
___UCS_2STRING *module_search_order;)
{
  ___addref_string_list (module_search_order);
#if 0
  /* can't release old setting because it is initially not an RC object */
  ___release_string_list (___GSTATE->setup_params.module_search_order);
#endif
  ___GSTATE->setup_params.module_search_order = module_search_order;
}


___EXP_FUNC(___UCS_2STRING*,___get_module_whitelist) ___PVOID
{
  return ___GSTATE->setup_params.module_whitelist;
}


___EXP_FUNC(void,___set_module_whitelist)
   ___P((___UCS_2STRING *module_whitelist),
        (module_whitelist)
___UCS_2STRING *module_whitelist;)
{
  ___addref_string_list (module_whitelist);
#if 0
  /* can't release old setting because it is initially not an RC object */
  ___release_string_list (___GSTATE->setup_params.module_whitelist);
#endif
  ___GSTATE->setup_params.module_whitelist = module_whitelist;
}


___EXP_FUNC(int,___get_module_install_mode) ___PVOID
{
  return ___GSTATE->setup_params.module_install_mode;
}


___EXP_FUNC(void,___set_module_install_mode)
   ___P((int module_install_mode),
        (module_install_mode)
int module_install_mode;)
{
  ___GSTATE->setup_params.module_install_mode = module_install_mode;
}


___EXP_FUNC(___UCS_2STRING,___get_repl_client_addr) ___PVOID
{
  return ___GSTATE->setup_params.repl_client_addr;
}


___EXP_FUNC(void,___set_repl_client_addr)
   ___P((___UCS_2STRING repl_client_addr),
        (repl_client_addr)
___UCS_2STRING repl_client_addr;)
{
  ___addref_string (repl_client_addr);
#if 0
  /* can't release old setting because it is initially not an RC object */
  ___release_string (___GSTATE->setup_params.repl_client_addr);
#endif
  ___GSTATE->setup_params.repl_client_addr = repl_client_addr;
}


___EXP_FUNC(___UCS_2STRING,___get_repl_server_addr) ___PVOID
{
  return ___GSTATE->setup_params.repl_server_addr;
}


___EXP_FUNC(void,___set_repl_server_addr)
   ___P((___UCS_2STRING repl_server_addr),
        (repl_server_addr)
___UCS_2STRING repl_server_addr;)
{
  ___addref_string (repl_server_addr);
#if 0
  /* can't release old setting because it is initially not an RC object */
  ___release_string (___GSTATE->setup_params.repl_server_addr);
#endif
  ___GSTATE->setup_params.repl_server_addr = repl_server_addr;
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

  CANONICALIZE_PATH(___UCS_2STRING, argv[0]);

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


___HIDDEN void setup_dynamic_linking ___PVOID
{
  /*
   * Setup global state to avoid problems on systems that don't
   * support the dynamic loading of files that import functions.
   */

#ifndef ___CAN_IMPORT_CLIB_DYNAMICALLY

  ___GSTATE->fabs  = fabs;
  ___GSTATE->floor = floor;
  ___GSTATE->ceil  = ceil;
#ifndef ___DEFINE_SCALBN
  ___GSTATE->scalbn= scalbn;
#endif
#ifndef ___DEFINE_ILOGB
  ___GSTATE->ilogb = ilogb;
#endif
  ___GSTATE->exp   = exp;
#ifndef ___DEFINE_EXPM1
  ___GSTATE->expm1 = expm1;
#endif
  ___GSTATE->log   = log;
#ifndef ___DEFINE_LOG1P
  ___GSTATE->log1p = log1p;
#endif
  ___GSTATE->sin   = sin;
  ___GSTATE->cos   = cos;
  ___GSTATE->tan   = tan;
  ___GSTATE->asin  = asin;
  ___GSTATE->acos  = acos;
  ___GSTATE->atan  = atan;
#ifndef ___DEFINE_SINH
  ___GSTATE->sinh  = sinh;
#endif
#ifndef ___DEFINE_COSH
  ___GSTATE->cosh  = cosh;
#endif
#ifndef ___DEFINE_TANH
  ___GSTATE->tanh  = tanh;
#endif
#ifndef ___DEFINE_ASINH
  ___GSTATE->asinh = asinh;
#endif
#ifndef ___DEFINE_ACOSH
  ___GSTATE->acosh = acosh;
#endif
#ifndef ___DEFINE_ATANH
  ___GSTATE->atanh = atanh;
#endif
#ifndef ___DEFINE_ATAN2
  ___GSTATE->atan2 = atan2;
#endif
#ifndef ___DEFINE_POW
  ___GSTATE->pow   = pow;
#endif
  ___GSTATE->sqrt  = sqrt;

#endif

#ifdef ___USE_SETJMP
#ifndef ___CAN_IMPORT_SETJMP_DYNAMICALLY

  ___GSTATE->setjmp = setjmp;

#endif
#endif

#ifndef ___CAN_IMPORT_DYNAMICALLY

#ifdef ___USE_C_RTS_CHAR_OPERATIONS

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

#endif

  ___GSTATE->___copysign
    = ___copysign;

  ___GSTATE->___isfinite
    = ___isfinite;

  ___GSTATE->___isinf
    = ___isinf;

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

  ___GSTATE->___F64_to_STRING
    = ___F64_to_STRING;

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

  ___GSTATE->___STRING_to_UCS_2STRING
    = ___STRING_to_UCS_2STRING;

  ___GSTATE->___free_UCS_2STRING
    = ___free_UCS_2STRING;

  ___GSTATE->___NONNULLSTRINGLIST_to_NONNULLUCS_2STRINGLIST
    = ___NONNULLSTRINGLIST_to_NONNULLUCS_2STRINGLIST;

  ___GSTATE->___free_NONNULLUCS_2STRINGLIST
    = ___free_NONNULLUCS_2STRINGLIST;

  ___GSTATE->___make_sfun_stack_marker
    = ___make_sfun_stack_marker;

  ___GSTATE->___kill_sfun_stack_marker
    = ___kill_sfun_stack_marker;

  ___GSTATE->___alloc_rc_no_register
    = ___alloc_rc_no_register;

  ___GSTATE->___register_rc
    = ___register_rc;

  ___GSTATE->___alloc_rc
    = ___alloc_rc;

  ___GSTATE->___release_rc
    = ___release_rc;

  ___GSTATE->___addref_rc
    = ___addref_rc;

  ___GSTATE->___refcount_rc
    = ___refcount_rc;

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

  ___GSTATE->___still_obj_refcount
    = ___still_obj_refcount;

  ___GSTATE->___gc_hash_table_ref
    = ___gc_hash_table_ref;

  ___GSTATE->___gc_hash_table_set
    = ___gc_hash_table_set;

  ___GSTATE->___gc_hash_table_union_find
    = ___gc_hash_table_union_find;

  ___GSTATE->___gc_hash_table_rehash
    = ___gc_hash_table_rehash;

  ___GSTATE->___cleanup
    = ___cleanup;

  ___GSTATE->___cleanup_and_exit_process
    = ___cleanup_and_exit_process;

  ___GSTATE->___current_vm_resize
    = ___current_vm_resize;

  ___GSTATE->___garbage_collect
    = ___garbage_collect;

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

  ___GSTATE->___get_parallelism_level
    = ___get_parallelism_level;

  ___GSTATE->___set_parallelism_level
    = ___set_parallelism_level;

  ___GSTATE->___get_standard_level
    = ___get_standard_level;

  ___GSTATE->___set_standard_level
    = ___set_standard_level;

  ___GSTATE->___get_debug_settings
    = ___get_debug_settings;

  ___GSTATE->___set_debug_settings
    = ___set_debug_settings;

  ___GSTATE->___get_io_settings
    = ___get_io_settings;

  ___GSTATE->___set_io_settings
    = ___set_io_settings;

  ___GSTATE->___get_gambitdir
    = ___get_gambitdir;

  ___GSTATE->___set_gambitdir
    = ___set_gambitdir;

  ___GSTATE->___get_gambitdir_map
    = ___get_gambitdir_map;

  ___GSTATE->___set_gambitdir_map
    = ___set_gambitdir_map;

  ___GSTATE->___get_module_search_order
    = ___get_module_search_order;

  ___GSTATE->___set_module_search_order
    = ___set_module_search_order;

  ___GSTATE->___get_module_whitelist
    = ___get_module_whitelist;

  ___GSTATE->___set_module_whitelist
    = ___set_module_whitelist;

  ___GSTATE->___get_module_install_mode
    = ___get_module_install_mode;

  ___GSTATE->___set_module_install_mode
    = ___set_module_install_mode;

  ___GSTATE->___get_repl_client_addr
    = ___get_repl_client_addr;

  ___GSTATE->___set_repl_client_addr
    = ___set_repl_client_addr;

  ___GSTATE->___get_repl_server_addr
    = ___get_repl_server_addr;

  ___GSTATE->___set_repl_server_addr
    = ___set_repl_server_addr;

  ___GSTATE->___get_program_startup_info
    = ___get_program_startup_info;

  ___GSTATE->___call
    = ___call;

  ___GSTATE->___run
    = ___run;

#ifdef ___USE_UNWIND_C_STACK_TO_TRAMPOLINE

  ___GSTATE->___unwind_c_stack_to_trampoline
    = ___unwind_c_stack_to_trampoline;

#endif

#ifdef ___SUPPORT_LOWLEVEL_EXEC

  ___GSTATE->___lowlevel_exec
    = ___lowlevel_exec;

#endif

  ___GSTATE->___machine_code_block_fixup
    = ___machine_code_block_fixup;

  ___GSTATE->___throw_error
    = ___throw_error;

  ___GSTATE->___propagate_error
    = ___propagate_error;

#ifdef ___DEBUG_HOST_CHANGES

  ___GSTATE->___register_host_entry
    = ___register_host_entry;

#endif

#ifdef ___ACTIVITY_LOG

  ___GSTATE->___actlog_add_pstate
    = ___actlog_add_pstate;

  ___GSTATE->___actlog_begin_pstate
    = ___actlog_begin_pstate;

  ___GSTATE->___actlog_end_pstate
    = ___actlog_end_pstate;

  ___GSTATE->___actlog_start
    = ___actlog_start;

  ___GSTATE->___actlog_stop
    = ___actlog_stop;

  ___GSTATE->___actlog_dump
    = ___actlog_dump;

#endif

  ___GSTATE->___raise_high_level_interrupt_pstate
    = ___raise_high_level_interrupt_pstate;

  ___GSTATE->___init_procedural_interrupt
    = ___init_procedural_interrupt;

  ___GSTATE->___raise_procedural_interrupt_pstate
    = ___raise_procedural_interrupt_pstate;

  ___GSTATE->___raise_interrupt_vmstate
    = ___raise_interrupt_vmstate;

  ___GSTATE->___raise_interrupt
    = ___raise_interrupt;

  ___GSTATE->___service_interrupts_pstate
    = ___service_interrupts_pstate;

  ___GSTATE->___refresh_interrupts_pstate
    = ___refresh_interrupts_pstate;

  ___GSTATE->___disable_interrupts_pstate
    = ___disable_interrupts_pstate;

  ___GSTATE->___enable_interrupts_pstate
    = ___enable_interrupts_pstate;

  ___GSTATE->___mask_all_interrupts_begin
    = ___mask_all_interrupts_begin;

  ___GSTATE->___mask_all_interrupts_end
    = ___mask_all_interrupts_end;

  ___GSTATE->___mask_user_interrupts_begin
    = ___mask_user_interrupts_begin;

  ___GSTATE->___mask_user_interrupts_end
    = ___mask_user_interrupts_end;

  ___GSTATE->___mask_heartbeat_interrupts_begin
    = ___mask_heartbeat_interrupts_begin;

  ___GSTATE->___mask_heartbeat_interrupts_end
    = ___mask_heartbeat_interrupts_end;

  ___GSTATE->___mask_child_interrupts_begin
    = ___mask_child_interrupts_begin;

  ___GSTATE->___mask_child_interrupts_end
    = ___mask_child_interrupts_end;

  ___GSTATE->___alloc_mem
    = ___alloc_mem;

  ___GSTATE->___free_mem
    = ___free_mem;

  ___GSTATE->___alloc_mem_code
    = ___alloc_mem_code;

  ___GSTATE->___free_mem_code
    = ___free_mem_code;

  ___GSTATE->___thread_init_from_self
    = ___thread_init_from_self;

  ___GSTATE->___thread_create
    = ___thread_create;

  ___GSTATE->___thread_join
    = ___thread_join;

  ___GSTATE->___thread_exit
    = ___thread_exit;

#ifdef ___USE_emulated_sync

  ___GSTATE->___emulated_compare_and_swap_word
    = ___emulated_compare_and_swap_word;

  ___GSTATE->___emulated_fetch_and_add_word
    = ___emulated_fetch_and_add_word;

  ___GSTATE->___emulated_fetch_and_clear_word
    = ___emulated_fetch_and_clear_word;

#endif

#ifdef ___DEFINE_THREAD_LOCAL_STORAGE_GETTER_SETTER

  ___GSTATE->___get_tls_ptr
    = ___get_tls_ptr;

  ___GSTATE->___set_tls_ptr
    = ___set_tls_ptr;

#endif

#endif
}


___EXP_FUNC(___SCMOBJ,___setup)
   ___P((___setup_params_struct *setup_params),
        (setup_params)
___setup_params_struct *setup_params;)
{
  ___SCMOBJ err;
  ___virtual_machine_state ___vms = &___GSTATE->vmstate0;
  ___processor_state ___ps = ___PSTATE_FROM_PROCESSOR_ID(0,___vms);
  ___SCMOBJ module_descrs;
  ___SCMOBJ supply_modules;
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
   * Set virtual machine to clean state.
   */

  ___vms->processor_count = 0;

#ifndef ___SINGLE_VM

  ___MUTEX_INIT(___GSTATE->vm_list_mut);

  ___vms->prev = ___vms;
  ___vms->next = ___vms;

#endif

#ifdef ___DEBUG

  /*
   * Check that the endianness is correct.
   */

  ___U16 endianness_test = 0x0102;

  if (*___CAST(___U8*,&endianness_test) !=
#ifdef ___LITTLE_ENDIAN
      0x02
#else
      0x01
#endif
      )
    {
      static char *msgs[] = { "Endianness is incorrectly set!", NULL };
      ___fatal_error (msgs);
    }

#endif

  /*
   * Setup interrupt system of processor 0 of vm 0.
   */

  {
    ___virtual_machine_state ___vms = &___GSTATE->vmstate0;
    setup_interrupts_pstate (___PSTATE_FROM_PROCESSOR_ID(0,___vms));
  }

  /*
   * Setup support for dynamic linking.
   */

  setup_dynamic_linking ();

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
   * Setup program's linker structure.
   */

  mol = linker_to_mod_or_lnk (___GSTATE->setup_params.linker);

  /*
   * Initialize symbol table, keyword table, global variables
   * and primitives.
   */

  init_symkey_glo1 (mol);
  init_symkey_glo2 (mol);

  do
    {

      /*
       * Setup each module.
       */

      err = setup_modules (___ps, mol, 0);

      if (___FIXNUMP(err))
        break;

      ___GSTATE->program_descr = err;

      /*
       * Setup kernel handlers.
       */

      setup_kernel_handlers ();

      /*
       * Create list of command line arguments (for ##command-line).
       */

      if ((err = setup_command_line_arguments ())
          != ___FIX(___NO_ERR))
        break;

      /*
       * Setup the main virtual machine.
       */

      if ((err = ___setup_vmstate (___vms))
          != ___FIX(___NO_ERR))
        break;

#ifndef ___SINGLE_THREADED_VMS

      /*
       * Associate the current OS thread with the processor state
       * it is running.
       */

      if ((err = ___thread_init_from_self (&___ps->os_thread))
          != ___FIX(___NO_ERR))
        break;

#endif

      /*
       * Setup current OS thread so that it can find the processor state
       * it is running.
       */

      ___thread_set_pstate (___ps);

      /*
       * By convention, the main module is the last one in the module
       * descriptors.
       */

      module_descrs = ___FIELD(___GSTATE->program_descr,0);

      supply_modules = ___FIELD(___FIELD(module_descrs,
                                         ___INT(___VECTORLENGTH(module_descrs))-1),
                                ___MODULE_DESCR_SUPPLY_MODS);

      ___vms->main_module_ref = ___FIELD(supply_modules,
                                         ___INT(___VECTORLENGTH(supply_modules))-1);

      /*
       * Start virtual machine execution by loading _kernel module.
       */

      err = ___run (___PSP
                    ___FIELD(___FIELD(___FIELD(___GSTATE->program_descr,0),0),
                             ___MODULE_DESCR_THUNK));
    } while (0);

  /*
   * Cleanup if there are any errors.
   */

  if (err != ___FIX(___NO_ERR))
    ___cleanup ();

  return err;
}


/*---------------------------------------------------------------------------*/
