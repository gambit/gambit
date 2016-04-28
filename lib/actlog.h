/* File: "actlog.h" */

/* Copyright (c) 2016 by Marc Feeley, All Rights Reserved. */

#ifndef ___ACTLOG_H
#define ___ACTLOG_H


/*---------------------------------------------------------------------------*/

extern ___SCMOBJ ___setup_actlog_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___cleanup_actlog_pstate
   ___P((___processor_state ___ps),
        ());

extern ___SCMOBJ ___setup_actlog_vmstate
   ___P((___virtual_machine_state ___vms),
        ());

extern void ___cleanup_actlog_vmstate
   ___P((___virtual_machine_state ___vms),
        ());

extern void ___actlog_add_pstate
   ___P((___processor_state ___ps,
         ___U16 *type,
         char *name,
         ___U32 color),
        ());

extern void ___actlog_begin_pstate
   ___P((___processor_state ___ps,
         ___U16 *type,
         char *name,
         ___U32 color),
        ());

extern void ___actlog_end_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___actlog_start_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___actlog_stop_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___actlog_dump
   ___P((___virtual_machine_state ___vms,
         char *filename),
        ());

/*---------------------------------------------------------------------------*/


#endif
