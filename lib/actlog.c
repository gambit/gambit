/* File: "actlog.c" */

/* Copyright (c) 2016-2018 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the creation of activity logs.
 */

#define ___INCLUDED_FROM_ACTLOG
#define ___VERSION 409002
#include "gambit.h"

#include "os_base.h"
#include "os_time.h"
#include "actlog.h"


/*---------------------------------------------------------------------------*/

#define ___MAX_NB_ACTLOG_ACTIVITIES  256
#define ___MAX_NB_ACTLOG_TRANSITIONS 1000000
#define ___ACTLOG_STACK_SIZE         1024


___SCMOBJ ___setup_actlog_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  ___actlog_transition *t;
  ___U16 *s;

  t = ___CAST(___actlog_transition*,
              ___ALLOC_MEM(sizeof (___actlog_transition) *
                           ___MAX_NB_ACTLOG_TRANSITIONS));

  if (t == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  s = ___CAST(___U16*,
              ___ALLOC_MEM(sizeof (___U16) * ___ACTLOG_STACK_SIZE));

  if (s == NULL)
    {
      ___FREE_MEM(t);
      return ___FIX(___HEAP_OVERFLOW_ERR);
    }

  ___ps->actlog.transitions = t;
  ___ps->actlog.stack = s;

  ___actlog_start_pstate (___ps);

#endif

  return ___FIX(___NO_ERR);
}


void ___cleanup_actlog_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  if (___ps->actlog.transitions != NULL)
    {
      ___FREE_MEM(___ps->actlog.transitions);
      ___ps->actlog.transitions = NULL;
    }

  if (___ps->actlog.stack != NULL)
    {
      ___FREE_MEM(___ps->actlog.stack);
      ___ps->actlog.stack = NULL;
    }

  ___ps->actlog.last = NULL;

#endif
}


___SCMOBJ ___setup_actlog_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#ifdef ___ACTIVITY_LOG

  ___actlog_activity *ptr =
    ___CAST(___actlog_activity*,
            ___ALLOC_MEM(sizeof (___actlog_activity) *
                         ___MAX_NB_ACTLOG_ACTIVITIES));

  if (ptr == NULL)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  ___MUTEX_INIT(___vms->actlog.mut);
  ___vms->actlog.activities = ptr;
  ___vms->actlog.nb_activities = 0;
  ___vms->actlog.auto_dump = 1;
  ___vms->actlog.max_processor_count = ___vms->processor_count;

#endif

  return ___FIX(___NO_ERR);
}


void ___cleanup_actlog_vmstate
   ___P((___virtual_machine_state ___vms),
        (___vms)
___virtual_machine_state ___vms;)
{
#ifdef ___ACTIVITY_LOG

  if (___vms->actlog.auto_dump)
    {
      ___actlog_stop_pstate (___PSTATE_FROM_PROCESSOR_ID(0,___vms));
      ___actlog_dump (___vms, NULL);
    }

  if (___vms->actlog.activities != NULL)
    {
      ___FREE_MEM(___vms->actlog.activities);
      ___vms->actlog.activities = NULL;
    }

  ___MUTEX_DESTROY(___vms->actlog.mut);
  ___vms->actlog.nb_activities = 0;

#endif
}


#ifdef ___ACTIVITY_LOG


___U16 ___actlog_register_activity
   ___P((___virtual_machine_state ___vms,
         char *name,
         ___U32 color),
        (___vms,
         name,
         color)
___virtual_machine_state ___vms;
char *name;
___U32 color;)
{
  ___U16 type;

  ___MUTEX_LOCK(___vms->actlog.mut);

  type = ___vms->actlog.nb_activities;

  while (type > 0)
    {
      type--;
      if (strcmp (name, ___vms->actlog.activities[type].name) == 0)
        break;
    }

  if (type == 0)
    {
      type = ___vms->actlog.nb_activities++;
      if (type < ___MAX_NB_ACTLOG_ACTIVITIES)
        {
          ___vms->actlog.activities[type].name = name;
          ___vms->actlog.activities[type].color = color;
        }
    }

  ___MUTEX_UNLOCK(___vms->actlog.mut);

  return type;
}


#endif


void ___actlog_add_pstate
   ___P((___processor_state ___ps,
         ___U16 *type,
         char *name,
         ___U32 color),
        (___ps,
         type,
         name,
         color)
___processor_state ___ps;
___U16 *type;
char *name;
___U32 color;)
{
#ifdef ___ACTIVITY_LOG

  ___actlog_transition *last = ___ps->actlog.last;

  if (last != ___ps->actlog.transitions)
    {
      ___U16 t = *type;

      if (t == ___ACTIVITY_START_STOP && name != NULL)
        {
          t = ___actlog_register_activity (___VMSTATE_FROM_PSTATE(___ps),
                                           name,
                                           color);
          *type = t;
        }

      ___ps->actlog.last = --last;

      last->type = t;
      last->stamp = ___time_get_monotonic_time ();
    }

#endif
}


void ___actlog_begin_pstate
   ___P((___processor_state ___ps,
         ___U16 *type,
         char *name,
         ___U32 color),
        (___ps,
         type,
         name,
         color)
___processor_state ___ps;
___U16 *type;
char *name;
___U32 color;)
{
#ifdef ___ACTIVITY_LOG

  ___actlog_transition *last = ___ps->actlog.last;

  if (last != ___ps->actlog.transitions)
    {
      ___U16 t = *type;

      if (t == ___ACTIVITY_START_STOP && name != NULL)
        {
          t = ___actlog_register_activity (___VMSTATE_FROM_PSTATE(___ps),
                                           name,
                                           color);
          *type = t;
        }

      if (___ps->actlog.sp < ___ACTLOG_STACK_SIZE)
        ___ps->actlog.stack[___ps->actlog.sp++] = last->type;

      ___ps->actlog.last = --last;

      last->type = t;
      last->stamp = ___time_get_monotonic_time ();
    }

#endif
}


void ___actlog_end_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  ___actlog_transition *last = ___ps->actlog.last;

  if (last != ___ps->actlog.transitions)
    {
      ___ps->actlog.last = --last;

      if (___ps->actlog.sp > 0)
        last->type = ___ps->actlog.stack[--___ps->actlog.sp];
      last->stamp = ___time_get_monotonic_time ();
    }

#endif
}


void ___actlog_start_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  ___U16 type =___ACTIVITY_START_STOP;

  ___ps->actlog.last = ___ps->actlog.transitions + ___MAX_NB_ACTLOG_TRANSITIONS;
  ___ps->actlog.sp = 0;

  ___actlog_add_pstate (___ps, &type, NULL, 0);

  ___ACTLOG_PS(idle,black);

#endif
}


void ___actlog_stop_pstate
   ___P((___processor_state ___ps),
        (___ps)
___processor_state ___ps;)
{
#ifdef ___ACTIVITY_LOG

  ___U16 type =___ACTIVITY_START_STOP;

  ___actlog_add_pstate (___ps, &type, NULL, 0);

#endif
}


/* Dumping of activity log files. */


#ifdef ___ACTIVITY_LOG


___HIDDEN void write_U8
   ___P((___FILE *out,
         ___U8 n),
        (out,
         n)
___FILE *out;
___U8 n;)
{
  ___fwrite (&n, 1, 1, out);
}


___HIDDEN void write_U16
   ___P((___FILE *out,
         ___U16 n),
        (out,
         n)
___FILE *out;
___U16 n;)
{
  write_U8 (out, ___CAST_U8(n>>8));
  write_U8 (out, ___CAST_U8(n));
}


___HIDDEN void write_U32
   ___P((___FILE *out,
         ___U32 n),
        (out,
         n)
___FILE *out;
___U32 n;)
{
  write_U8 (out, ___CAST_U8(n>>24));
  write_U8 (out, ___CAST_U8(n>>16));
  write_U8 (out, ___CAST_U8(n>>8));
  write_U8 (out, ___CAST_U8(n));
}


___HIDDEN void write_U64
   ___P((___FILE *out,
         ___U64 n),
        (out,
         n)
___FILE *out;
___U64 n;)
{
  write_U32 (out, ___U64_hi32(n));
  write_U32 (out, ___U64_lo32(n));
}


___HIDDEN void write_string
   ___P((___FILE *out,
         char *str),
        (out,
         str)
___FILE *out;
char *str;)
{
  while (*str != '\0')
    write_U8 (out, *str++);
  write_U8 (out, '\n');
}


___HIDDEN ___U32 distinct_colors[] = {
0x1CE6FF, 0xFF34FF, 0x008941, 0xFF4A46,
0x006FA6, 0xA30059, 0xFFDBE5, 0x7A4900,
0x0000A6, 0x63FFAC, 0xB79762, 0x004D43,
0x8FB0FF, 0x997D87, 0x5A0007, 0x809693,
0xFEFFE6, 0x1B4400, 0x4FC601, 0x3B5DFF,
0x4A3B53, 0xFF2F80, 0x61615A, 0xBA0900,
0x6B7900, 0x00C2A0, 0xFFAA92, 0xFF90C9,
0xB903AA, 0xD16100, 0xDDEFFF, 0x000035,
0x7B4F4B, 0xA1C299, 0x300018, 0x0AA6D8,
0x013349, 0x00846F, 0x372101, 0xFFB500,
0xC2FFED, 0xA079BF, 0xCC0744, 0xC0B9B2,
0xC2FF99, 0x001E09, 0x00489C, 0x6F0062,
0x0CBD66, 0xEEC3FF, 0x456D75, 0xB77B68,
0x7A87A1, 0x788D66, 0x885578, 0xFAD09F,
0xFF8A9A, 0xD157A0, 0xBEC459, 0x456648,
0x0086ED, 0x886F4C, 0x34362D, 0xB4A8BD,
0x00A6AA, 0x452C2C, 0x636375, 0xA3C8C9,
0xFF913F, 0x938A81, 0x575329, 0x00FECF,
0xB05B6F, 0x8CD0FF, 0x3B9700, 0x04F757,
0xC8A1A1, 0x1E6E00, 0x7900D7, 0xA77500,
0x6367A9, 0xA05837, 0x6B002C, 0x772600,
0xD790FF, 0x9B9700, 0x549E79, 0xFFF69F,
0x201625, 0x72418F, 0xBC23FF, 0x99ADC0,
0x3A2465, 0x922329, 0x5B4534, 0xFDE8DC,
0x404E55, 0x0089A3, 0xCB7E98, 0xA4E804,
0x324E72, 0x6A3A4C
};


#endif


void ___actlog_dump
   ___P((___virtual_machine_state ___vms,
         char *filename),
        (___vms,
         filename)
___virtual_machine_state ___vms;
char *filename;)
{
#ifdef ___ACTIVITY_LOG

  int i;
  int c = 0;
  ___FILE *out = ___fopen (filename == NULL ? "gambit.actlog" : filename, "w");

  if (out == NULL)
    return;

  ___vms->actlog.auto_dump = 0;

  write_U64 (out, ___time_get_monotonic_time_frequency ());

  write_U32 (out, ___vms->actlog.nb_activities);

  for (i=0; i<___vms->actlog.nb_activities; i++)
    {
      ___actlog_activity *act = &___vms->actlog.activities[i];
      //write_U8 (out, act->group);
      if (act->color == ___ACTLOG_COLOR__)
        {
          act->color = distinct_colors[c++];
          c = c % (sizeof(distinct_colors) / sizeof(*distinct_colors));
        }
      write_U32 (out, act->color);
      write_string (out, act->name);
    }

  write_U32 (out, ___vms->actlog.max_processor_count);

  for (i=0; i<___vms->actlog.max_processor_count; i++)
    {
      ___processor_state ___ps = ___PSTATE_FROM_PROCESSOR_ID(i,___vms);
      ___actlog_transition *ptr = ___ps->actlog.transitions + ___MAX_NB_ACTLOG_TRANSITIONS;
      ___actlog_transition *last = ___ps->actlog.last;

      write_U32 (out, ptr - last);

      while (last < ptr)
        {
          ptr--;
          write_U16 (out, ptr->type);
          write_U64 (out, ptr->stamp);
        }
    }

  ___fclose (out);

#endif
}


/*---------------------------------------------------------------------------*/
