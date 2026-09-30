/* Check overflow-undo ownership at continuation capture and replacement. */

#include <stdio.h>
#include <string.h>
#include "gambit.h"

/* Supply registers and arguments without entering the generated-code loop. */
#undef ___R0
#undef ___R1
#undef ___POP_ARGS2
#undef ___JUMPPRM
#define ___R0 r0
#define ___R1 r1
#define ___POP_ARGS2(a,b) a = input_cont; b = ___FIX(7);
#define ___JUMPPRM(setup,dest) (void)(dest);

#define CHECK(condition) \
  do { if (!(condition)) { \
    fprintf (stderr, "line %d: %s\n", __LINE__, #condition); \
    return 1; \
  } } while (0)

static ___SCMOBJ object (___WORD *storage, int size, int subtype)
{
  memset (storage, 0, (___SUBTYPED_BODY + size) * sizeof (___WORD));
  storage[0] = ___MAKE_HD_WORDS(size,subtype);
#ifdef ___USE_HANDLES
  storage[1] = ___CAST(___WORD,storage + ___SUBTYPED_BODY);
#endif
  return ___SUBTYPED_FROM_START(storage);
}

int main (void)
{
  ___processor_state_struct state;
  ___processor_state ___ps = &state;
  ___WORD stack[128], saved[64], before[64];
  ___WORD thread_storage[___SUBTYPED_BODY + 64];
  ___WORD cont_storage[___SUBTYPED_BODY + ___CONTINUATION_SIZE];
  ___WORD denv_storage[___SUBTYPED_BODY + 64];
  ___WORD env_storage[___SUBTYPED_BODY + 8];
  ___WORD *first, *active, *___fp;
  ___SCMOBJ owner, input_cont, denv, env, r0, r1;
  int operation, nested, eligible;

  memset (&state, 0, sizeof state);
  memset (saved, 0, sizeof saved);
  memcpy (before, saved, sizeof saved);
  owner = object (thread_storage, 64, ___sSTRUCTURE);
  input_cont = object (cont_storage, ___CONTINUATION_SIZE, ___sCONTINUATION);
  denv = object (denv_storage, 64, ___sVECTOR);
  env = object (env_storage, 8, ___sVECTOR);
  object (___ALIGNUP(state.processor_scmobj,___WS),
          ___PROCESSOR_SIZE, ___sSTRUCTURE);
  ___THREAD_CONT_FIELD(owner) = input_cont;
  ___THREAD_DENV_FIELD(owner) = denv;
  ___DENV_LOCAL_FIELD(denv) = env;
  ___DENV_INTERRUPT_MASK_FIELD(denv) = ___FIX(0);
  ___ENV_PARAM_VAL_FIELD(env) = ___FIX(9);
  state.handler_break = ___FIX(11);
  state.stack_start = stack + 128;
  first = state.stack_start - ___FIRST_BREAK_FRAME_SPACE;

  for (operation = 0; operation < 5; operation++)
    for (nested = 0; nested < 2; nested++)
      for (eligible = 0; eligible < 2; eligible++)
        {
          ___SCMOBJ thread = owner, frame = 0, cont = input_cont, temp = 0;
          memset (stack, 0, sizeof stack);
          active = nested ? first - 32 : first;
          state.stack_break = active;
          ___fp = active;
          r0 = state.handler_break;
          r1 = 0;
          ___CURRENTTHREADSET(owner)
          ___CONTINUATION_FRAME_FIELD(input_cont) = ___CAST(___SCMOBJ,saved + 48);
          ___CONTINUATION_DENV_FIELD(input_cont) = denv;
          ___FP_SET_STK(first,-___FIRST_BREAK_FRAME_STACK_MSECTION,eligible ? 123 : 0)
          ___FP_SET_STK(first,-___FIRST_BREAK_FRAME_STACK_BREAK,___CAST(___WORD,saved + 32))
          ___FP_SET_STK(first,-___BREAK_FRAME_NEXT,___CAST(___WORD,saved + 24))
          ___FP_SET_STK(active,-___BREAK_FRAME_NEXT,___CAST(___WORD,saved + 24))

          switch (operation)
            {
            case 0:
              ___THREAD_SAVE
              CHECK (___CONTINUATION_FRAME_FIELD(input_cont) == ___CAST(___SCMOBJ,saved + 24));
              break;
            case 1:
              ___THREAD_RESTORE
              CHECK (___FP_STK(active,-___BREAK_FRAME_NEXT) == ___CAST(___WORD,saved + 48));
              CHECK (___CONTINUATION_FRAME_FIELD(input_cont) == ___END_OF_CONT_MARKER);
              break;
            case 2:
              ___CONTINUATION_CAPTURE
              CHECK (frame == ___CAST(___SCMOBJ,saved + 24));
              CHECK (___FP_STK(state.stack_break,-___BREAK_FRAME_NEXT) == frame);
              break;
            case 3:
              ___CONTINUATION_GRAFT_NO_WINDING
              CHECK (___FP_STK(active,-___BREAK_FRAME_NEXT) == ___CAST(___WORD,saved + 48));
              CHECK (___THREAD_DENV_CACHE1_FIELD(owner) == ___FIX(9));
              break;
            case 4:
              ___JUMP_CONTINUATION_RETURN_NO_WINDING2(unused)
              CHECK (___FP_STK(active,-___BREAK_FRAME_NEXT) == ___CAST(___WORD,saved + 48));
              CHECK (r1 == ___FIX(7));
              break;
            }

          CHECK (___FP_STK(first,-___FIRST_BREAK_FRAME_STACK_MSECTION) == 0);
          CHECK (___FP_STK(first,-___FIRST_BREAK_FRAME_STACK_BREAK) == ___CAST(___WORD,saved + 32));
          CHECK (memcmp (saved, before, sizeof saved) == 0);
        }

  puts ("PASS: overflow undo invalidated at all five continuation operations");
  return 0;
}
