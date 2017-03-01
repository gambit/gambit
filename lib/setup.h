/* File: "setup.h" */

/* Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved. */

#ifndef ___SETUP_H
#define ___SETUP_H


/*---------------------------------------------------------------------------*/


extern ___SCMOBJ ___os_load_object_file
   ___P((___SCMOBJ path,
         ___SCMOBJ modname),
        ());


extern void barrier_sync_noop
   ___P((___PSDNC),
        ());


extern void service_sync_op
   ___P((___PSDNC),
        ());


#ifdef ___DEBUG_CTRL_FLOW_HISTORY
#define ___USE_print_source_location
#else
#ifdef ___DEBUG_HOST_CHANGES
#define ___USE_print_source_location
#endif
#endif

#ifdef ___USE_print_source_location

extern void ___print_source_location
   ___P((___source_location *loc),
        ());
#endif


#ifdef ___DEBUG_CTRL_FLOW_HISTORY

extern void ___print_ctrl_flow_history_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___print_ctrl_flow_history_vmstate
   ___P((___virtual_machine_state ___vms),
        ());

extern void ___print_ctrl_flow_history ___PVOID;

extern void ___print_ctrl_flow_last_seen_pstate
   ___P((___processor_state ___ps),
        ());

extern void ___print_ctrl_flow_last_seen_vmstate
   ___P((___virtual_machine_state ___vms),
        ());

extern void ___print_ctrl_flow_last_seen ___PVOID;

#endif


#define ___COVER(n)
#define ___COVER_SFUN_CONVERSION_ERROR_HANDLER               ___COVER(0)
#define ___COVER_CFUN_CONVERSION_ERROR_HANDLER               ___COVER(1)
#define ___COVER_STACK_LIMIT_HANDLER_STACK_LIMIT             ___COVER(2)
#define ___COVER_STACK_LIMIT_HANDLER_HEAP_OVERFLOW           ___COVER(3)
#define ___COVER_STACK_LIMIT_HANDLER_INTR_ENABLED            ___COVER(4)
#define ___COVER_STACK_LIMIT_HANDLER_INTERRUPT               ___COVER(5)
#define ___COVER_STACK_LIMIT_HANDLER_END                     ___COVER(6)
#define ___COVER_HEAP_LIMIT_HANDLER_END                      ___COVER(7)
#define ___COVER_NONPROC_HANDLER_END                         ___COVER(8)
#define ___COVER_GLOBAL_NONPROC_HANDLER_FOUND                ___COVER(9)
#define ___COVER_GLOBAL_NONPROC_HANDLER_NEXT                 ___COVER(10)
#define ___COVER_GLOBAL_NONPROC_HANDLER_END                  ___COVER(11)
#define ___COVER_WRONG_NARGS_HANDLER_NONCLOSURE              ___COVER(12)
#define ___COVER_WRONG_NARGS_HANDLER_CLOSURE                 ___COVER(13)
#define ___COVER_REST_PARAM_HANDLER_WRONG_NARGS              ___COVER(14)
#define ___COVER_REST_PARAM_HANDLER_HEAP_LIMIT               ___COVER(15)
#define ___COVER_REST_PARAM_HANDLER_NEED_TO_GC               ___COVER(16)
#define ___COVER_REST_PARAM_HANDLER_NO_NEED_TO_GC            ___COVER(17)
#define ___COVER_KEYWORD_PARAM_HANDLER_WRONG_NARGS1          ___COVER(18)
#define ___COVER_KEYWORD_PARAM_HANDLER_FOUND                 ___COVER(19)
#define ___COVER_KEYWORD_PARAM_HANDLER_NOT_FOUND             ___COVER(20)
#define ___COVER_KEYWORD_PARAM_HANDLER_WRONG_NARGS2          ___COVER(21)
#define ___COVER_KEYWORD_PARAM_HANDLER_KEYWORD_EXPECTED      ___COVER(22)
#define ___COVER_KEYWORD_PARAM_HANDLER_END                   ___COVER(23)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_WRONG_NARGS1     ___COVER(24)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_FOUND            ___COVER(25)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_NOT_FOUND        ___COVER(26)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_WRONG_NARGS2     ___COVER(27)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_KEYWORD_EXPECTED ___COVER(28)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_HEAP_LIMIT       ___COVER(29)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_NEED_TO_GC       ___COVER(30)
#define ___COVER_KEYWORD_REST_PARAM_HANDLER_NO_NEED_TO_GC    ___COVER(31)
#define ___COVER_FORCE_HANDLER_DETERMINED                    ___COVER(32)
#define ___COVER_FORCE_HANDLER_NOT_DETERMINED                ___COVER(33)
#define ___COVER_RETURN_TO_C_HANDLER_FIRST_RETURN            ___COVER(34)
#define ___COVER_RETURN_TO_C_HANDLER_MULTIPLE_RETURN         ___COVER(35)
#define ___COVER_RETURN_TO_C_HANDLER_WRONG_PROCESSOR         ___COVER(36)
#define ___COVER_BREAK_HANDLER_STACK_RETI                    ___COVER(37)
#define ___COVER_BREAK_HANDLER_STACK_RETN                    ___COVER(38)
#define ___COVER_BREAK_HANDLER_STACK_FIRST_FRAME             ___COVER(39)
#define ___COVER_BREAK_HANDLER_STACK_NOT_FIRST_FRAME         ___COVER(40)
#define ___COVER_BREAK_HANDLER_HEAP_RETI                     ___COVER(41)
#define ___COVER_BREAK_HANDLER_HEAP_RETN                     ___COVER(42)
#define ___COVER_INTERNAL_RETURN_HANDLER_END                 ___COVER(43)
#define ___COVER_REST_PARAM_RESUME_PROCEDURE                 ___COVER(44)
#define ___COVER_GC_WITHOUT_EXCEPTIONS                       ___COVER(45)
#define ___COVER_APPLY_ARGUMENT_LIMIT                        ___COVER(46)
#define ___COVER_APPLY_ARGUMENT_LIMIT_END                    ___COVER(47)
#define ___COVER_MARK_CAPTURED_CONTINUATION_RETI             ___COVER(48)
#define ___COVER_MARK_CAPTURED_CONTINUATION_RETN             ___COVER(49)
#define ___COVER_MARK_CAPTURED_CONTINUATION_ALREADY_COPIED   ___COVER(50)
#define ___COVER_MARK_CAPTURED_CONTINUATION_COPY             ___COVER(51)
#define ___COVER_MARK_CAPTURED_CONTINUATION_FIRST_FRAME      ___COVER(52)
#define ___COVER_MARK_CAPTURED_CONTINUATION_NOT_FIRST_FRAME  ___COVER(53)
#define ___COVER_MARK_CONTINUATION_RETI                      ___COVER(54)
#define ___COVER_MARK_CONTINUATION_RETN                      ___COVER(55)
#define ___COVER_SCAN_FRAME_RETI                             ___COVER(56)
#define ___COVER_SCAN_FRAME_RETN                             ___COVER(57)

/*---------------------------------------------------------------------------*/


#endif
