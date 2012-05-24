#ifdef ___LINKER_INFO
; File: "_t-univ.c", produced by Gambit-C v4.6.6
(
406006
" _t-univ"
(" _t-univ")
(
"##not"
"apply"
"close"
"closure-env"
"copy"
"end-comment"
"entry"
"entry-point"
"gen-apply"
"gen-clo"
"gen-close"
"gen-copy"
"gen-glo"
"gen-ifjump"
"gen-jump"
"gen-label"
"gen-nl"
"gen-obj"
"gen-reg"
"gen-stk"
"gen-string"
"gen-switch"
"ifjump"
"js"
"jump"
"label"
"open-comment"
"php"
"prim-applic"
"python"
"return"
"runtime-system"
"simple"
"sp-adjust"
"switch"
"targ"
"task-entry"
"task-return"
"translate-lbl"
"univ-switch-testable?"
)
(
"port"
)
(
" _t-univ"
"c#add-target-fun"
"c#get-target-fun"
"c#js-end-comment"
"c#js-entry-point"
"c#js-gen-apply"
"c#js-gen-clo"
"c#js-gen-close"
"c#js-gen-copy"
"c#js-gen-glo"
"c#js-gen-ifjump"
"c#js-gen-jump"
"c#js-gen-label"
"c#js-gen-nl"
"c#js-gen-obj"
"c#js-gen-reg"
"c#js-gen-stk"
"c#js-gen-string"
"c#js-gen-switch"
"c#js-open-comment"
"c#js-prim-applic"
"c#js-runtime-system"
"c#js-sp-adjust"
"c#js-translate-lbl"
"c#make-ctx"
"c#translate-gvm-instr"
"c#translate-gvm-opnd"
"c#univ-dump"
"c#univ-dump-procs"
"c#univ-end-comment"
"c#univ-gen-apply-instr"
"c#univ-gen-clo-opnd"
"c#univ-gen-close-instr"
"c#univ-gen-copy-instr"
"c#univ-gen-glo-opnd"
"c#univ-gen-ifjump-instr"
"c#univ-gen-jump-instr"
"c#univ-gen-label-instr"
"c#univ-gen-nl"
"c#univ-gen-obj-opnd"
"c#univ-gen-reg-opnd"
"c#univ-gen-stk-opnd"
"c#univ-gen-string"
"c#univ-gen-switch-instr"
"c#univ-jump-info"
"c#univ-label-info"
"c#univ-open-comment"
"c#univ-prim-proc-add!"
"c#univ-prim-proc-table"
"c#univ-setup"
"c#univ-switch-testable?"
"c#univ-to-target"
"c#univ-translate-lbl"
)
(
"c#ctx-ns"
"c#ctx-ns-set!"
"c#ctx-target"
"c#ctx-target-set!"
"c#gen"
"c#js-lbl->id"
"c#univ-entry-point"
"c#univ-frame-alignment"
"c#univ-frame-reserve"
"c#univ-nb-arg-regs"
"c#univ-nb-gvm-regs"
"c#univ-prim-applic"
"c#univ-prim-info"
"c#univ-runtime-system"
"c#univ-sp-adjust"
)
(
"apply"
"assoc"
"c#apply-loc"
"c#apply-opnds"
"c#apply-prim"
"c#bbs->code-list"
"c#bbs?"
"c#clo-base"
"c#clo-index"
"c#clo?"
"c#close-parms"
"c#closure-parms-loc"
"c#closure-parms-opnds"
"c#code-gvm-instr"
"c#compiler-internal-error"
"c#copy-loc"
"c#copy-opnd"
"c#frame-size"
"c#glo-name"
"c#glo?"
"c#gvm-instr-frame"
"c#gvm-instr-type"
"c#ifjump-false"
"c#ifjump-opnds"
"c#ifjump-test"
"c#ifjump-true"
"c#jump-nb-args"
"c#jump-opnd"
"c#jump-poll?"
"c#label-entry-closed?"
"c#label-entry-nb-parms"
"c#label-lbl-num"
"c#label-type"
"c#lbl-num"
"c#lbl?"
"c#make-frame-constraints"
"c#make-lbl"
"c#make-obj"
"c#make-pcontext"
"c#make-proc-obj"
"c#make-reg"
"c#make-stk"
"c#make-target"
"c#obj-val"
"c#obj?"
"c#prim-procs"
"c#proc-obj-code"
"c#proc-obj-name"
"c#proc-obj-primitive?"
"c#proc-obj?"
"c#queue->list"
"c#queue-empty"
"c#queue-empty?"
"c#queue-get!"
"c#queue-put!"
"c#reg-num"
"c#reg?"
"c#scheme-id->c-id"
"c#stk-num"
"c#stk?"
"c#string->canonical-symbol"
"c#switch-case-obj"
"c#switch-cases"
"c#switch-opnd"
"c#target-add"
"c#target-begin!-set!"
"c#target-dump-set!"
"c#target-end!-set!"
"c#target-file-extension-set!"
"c#target-frame-constraints-set!"
"c#target-jump-info-set!"
"c#target-label-info-set!"
"c#target-name"
"c#target-nb-regs-set!"
"c#target-prim-info-set!"
"c#target-proc-result-set!"
"c#target-switch-testable?-set!"
"c#target-task-return-set!"
"c#void-object?"
"call-with-output-file"
"list-ref"
"make-table"
"object->string"
"pretty-print"
"print"
"string->symbol"
"symbol->string"
"table-ref"
"table-set!"
"vector"
)
 #f
)
#else
#define ___VERSION 406006
#define ___MODULE_NAME " _t-univ"
#define ___LINKER_ID ____20___t_2d_univ
#define ___MH_PROC ___H__20___t_2d_univ
#define ___SCRIPT_LINE 0
#define ___SYM_COUNT 40
#define ___KEY_COUNT 1
#define ___GLO_COUNT 158
#define ___SUP_COUNT 68
#define ___SUB_COUNT 83
#define ___LBL_COUNT 556
#define ___OFD_COUNT 11
#include "gambit.h"

___NEED_SYM(___S__23__23_not)
___NEED_SYM(___S_apply)
___NEED_SYM(___S_close)
___NEED_SYM(___S_closure_2d_env)
___NEED_SYM(___S_copy)
___NEED_SYM(___S_end_2d_comment)
___NEED_SYM(___S_entry)
___NEED_SYM(___S_entry_2d_point)
___NEED_SYM(___S_gen_2d_apply)
___NEED_SYM(___S_gen_2d_clo)
___NEED_SYM(___S_gen_2d_close)
___NEED_SYM(___S_gen_2d_copy)
___NEED_SYM(___S_gen_2d_glo)
___NEED_SYM(___S_gen_2d_ifjump)
___NEED_SYM(___S_gen_2d_jump)
___NEED_SYM(___S_gen_2d_label)
___NEED_SYM(___S_gen_2d_nl)
___NEED_SYM(___S_gen_2d_obj)
___NEED_SYM(___S_gen_2d_reg)
___NEED_SYM(___S_gen_2d_stk)
___NEED_SYM(___S_gen_2d_string)
___NEED_SYM(___S_gen_2d_switch)
___NEED_SYM(___S_ifjump)
___NEED_SYM(___S_js)
___NEED_SYM(___S_jump)
___NEED_SYM(___S_label)
___NEED_SYM(___S_open_2d_comment)
___NEED_SYM(___S_php)
___NEED_SYM(___S_prim_2d_applic)
___NEED_SYM(___S_python)
___NEED_SYM(___S_return)
___NEED_SYM(___S_runtime_2d_system)
___NEED_SYM(___S_simple)
___NEED_SYM(___S_sp_2d_adjust)
___NEED_SYM(___S_switch)
___NEED_SYM(___S_targ)
___NEED_SYM(___S_task_2d_entry)
___NEED_SYM(___S_task_2d_return)
___NEED_SYM(___S_translate_2d_lbl)
___NEED_SYM(___S_univ_2d_switch_2d_testable_3f_)

___NEED_KEY(___K_port)

___NEED_GLO(___G__20___t_2d_univ)
___NEED_GLO(___G_apply)
___NEED_GLO(___G_assoc)
___NEED_GLO(___G_c_23_add_2d_target_2d_fun)
___NEED_GLO(___G_c_23_apply_2d_loc)
___NEED_GLO(___G_c_23_apply_2d_opnds)
___NEED_GLO(___G_c_23_apply_2d_prim)
___NEED_GLO(___G_c_23_bbs_2d__3e_code_2d_list)
___NEED_GLO(___G_c_23_bbs_3f_)
___NEED_GLO(___G_c_23_clo_2d_base)
___NEED_GLO(___G_c_23_clo_2d_index)
___NEED_GLO(___G_c_23_clo_3f_)
___NEED_GLO(___G_c_23_close_2d_parms)
___NEED_GLO(___G_c_23_closure_2d_parms_2d_loc)
___NEED_GLO(___G_c_23_closure_2d_parms_2d_opnds)
___NEED_GLO(___G_c_23_code_2d_gvm_2d_instr)
___NEED_GLO(___G_c_23_compiler_2d_internal_2d_error)
___NEED_GLO(___G_c_23_copy_2d_loc)
___NEED_GLO(___G_c_23_copy_2d_opnd)
___NEED_GLO(___G_c_23_ctx_2d_ns)
___NEED_GLO(___G_c_23_ctx_2d_ns_2d_set_21_)
___NEED_GLO(___G_c_23_ctx_2d_target)
___NEED_GLO(___G_c_23_ctx_2d_target_2d_set_21_)
___NEED_GLO(___G_c_23_frame_2d_size)
___NEED_GLO(___G_c_23_gen)
___NEED_GLO(___G_c_23_get_2d_target_2d_fun)
___NEED_GLO(___G_c_23_glo_2d_name)
___NEED_GLO(___G_c_23_glo_3f_)
___NEED_GLO(___G_c_23_gvm_2d_instr_2d_frame)
___NEED_GLO(___G_c_23_gvm_2d_instr_2d_type)
___NEED_GLO(___G_c_23_ifjump_2d_false)
___NEED_GLO(___G_c_23_ifjump_2d_opnds)
___NEED_GLO(___G_c_23_ifjump_2d_test)
___NEED_GLO(___G_c_23_ifjump_2d_true)
___NEED_GLO(___G_c_23_js_2d_end_2d_comment)
___NEED_GLO(___G_c_23_js_2d_entry_2d_point)
___NEED_GLO(___G_c_23_js_2d_gen_2d_apply)
___NEED_GLO(___G_c_23_js_2d_gen_2d_clo)
___NEED_GLO(___G_c_23_js_2d_gen_2d_close)
___NEED_GLO(___G_c_23_js_2d_gen_2d_copy)
___NEED_GLO(___G_c_23_js_2d_gen_2d_glo)
___NEED_GLO(___G_c_23_js_2d_gen_2d_ifjump)
___NEED_GLO(___G_c_23_js_2d_gen_2d_jump)
___NEED_GLO(___G_c_23_js_2d_gen_2d_label)
___NEED_GLO(___G_c_23_js_2d_gen_2d_nl)
___NEED_GLO(___G_c_23_js_2d_gen_2d_obj)
___NEED_GLO(___G_c_23_js_2d_gen_2d_reg)
___NEED_GLO(___G_c_23_js_2d_gen_2d_stk)
___NEED_GLO(___G_c_23_js_2d_gen_2d_string)
___NEED_GLO(___G_c_23_js_2d_gen_2d_switch)
___NEED_GLO(___G_c_23_js_2d_lbl_2d__3e_id)
___NEED_GLO(___G_c_23_js_2d_open_2d_comment)
___NEED_GLO(___G_c_23_js_2d_prim_2d_applic)
___NEED_GLO(___G_c_23_js_2d_runtime_2d_system)
___NEED_GLO(___G_c_23_js_2d_sp_2d_adjust)
___NEED_GLO(___G_c_23_js_2d_translate_2d_lbl)
___NEED_GLO(___G_c_23_jump_2d_nb_2d_args)
___NEED_GLO(___G_c_23_jump_2d_opnd)
___NEED_GLO(___G_c_23_jump_2d_poll_3f_)
___NEED_GLO(___G_c_23_label_2d_entry_2d_closed_3f_)
___NEED_GLO(___G_c_23_label_2d_entry_2d_nb_2d_parms)
___NEED_GLO(___G_c_23_label_2d_lbl_2d_num)
___NEED_GLO(___G_c_23_label_2d_type)
___NEED_GLO(___G_c_23_lbl_2d_num)
___NEED_GLO(___G_c_23_lbl_3f_)
___NEED_GLO(___G_c_23_make_2d_ctx)
___NEED_GLO(___G_c_23_make_2d_frame_2d_constraints)
___NEED_GLO(___G_c_23_make_2d_lbl)
___NEED_GLO(___G_c_23_make_2d_obj)
___NEED_GLO(___G_c_23_make_2d_pcontext)
___NEED_GLO(___G_c_23_make_2d_proc_2d_obj)
___NEED_GLO(___G_c_23_make_2d_reg)
___NEED_GLO(___G_c_23_make_2d_stk)
___NEED_GLO(___G_c_23_make_2d_target)
___NEED_GLO(___G_c_23_obj_2d_val)
___NEED_GLO(___G_c_23_obj_3f_)
___NEED_GLO(___G_c_23_prim_2d_procs)
___NEED_GLO(___G_c_23_proc_2d_obj_2d_code)
___NEED_GLO(___G_c_23_proc_2d_obj_2d_name)
___NEED_GLO(___G_c_23_proc_2d_obj_2d_primitive_3f_)
___NEED_GLO(___G_c_23_proc_2d_obj_3f_)
___NEED_GLO(___G_c_23_queue_2d__3e_list)
___NEED_GLO(___G_c_23_queue_2d_empty)
___NEED_GLO(___G_c_23_queue_2d_empty_3f_)
___NEED_GLO(___G_c_23_queue_2d_get_21_)
___NEED_GLO(___G_c_23_queue_2d_put_21_)
___NEED_GLO(___G_c_23_reg_2d_num)
___NEED_GLO(___G_c_23_reg_3f_)
___NEED_GLO(___G_c_23_scheme_2d_id_2d__3e_c_2d_id)
___NEED_GLO(___G_c_23_stk_2d_num)
___NEED_GLO(___G_c_23_stk_3f_)
___NEED_GLO(___G_c_23_string_2d__3e_canonical_2d_symbol)
___NEED_GLO(___G_c_23_switch_2d_case_2d_obj)
___NEED_GLO(___G_c_23_switch_2d_cases)
___NEED_GLO(___G_c_23_switch_2d_opnd)
___NEED_GLO(___G_c_23_target_2d_add)
___NEED_GLO(___G_c_23_target_2d_begin_21__2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_dump_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_end_21__2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_file_2d_extension_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_frame_2d_constraints_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_jump_2d_info_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_label_2d_info_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_name)
___NEED_GLO(___G_c_23_target_2d_nb_2d_regs_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_prim_2d_info_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_proc_2d_result_2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_switch_2d_testable_3f__2d_set_21_)
___NEED_GLO(___G_c_23_target_2d_task_2d_return_2d_set_21_)
___NEED_GLO(___G_c_23_translate_2d_gvm_2d_instr)
___NEED_GLO(___G_c_23_translate_2d_gvm_2d_opnd)
___NEED_GLO(___G_c_23_univ_2d_dump)
___NEED_GLO(___G_c_23_univ_2d_dump_2d_procs)
___NEED_GLO(___G_c_23_univ_2d_end_2d_comment)
___NEED_GLO(___G_c_23_univ_2d_entry_2d_point)
___NEED_GLO(___G_c_23_univ_2d_frame_2d_alignment)
___NEED_GLO(___G_c_23_univ_2d_frame_2d_reserve)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_apply_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_clo_2d_opnd)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_close_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_copy_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_glo_2d_opnd)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_jump_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_label_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_nl)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_obj_2d_opnd)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_reg_2d_opnd)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_stk_2d_opnd)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_string)
___NEED_GLO(___G_c_23_univ_2d_gen_2d_switch_2d_instr)
___NEED_GLO(___G_c_23_univ_2d_jump_2d_info)
___NEED_GLO(___G_c_23_univ_2d_label_2d_info)
___NEED_GLO(___G_c_23_univ_2d_nb_2d_arg_2d_regs)
___NEED_GLO(___G_c_23_univ_2d_nb_2d_gvm_2d_regs)
___NEED_GLO(___G_c_23_univ_2d_open_2d_comment)
___NEED_GLO(___G_c_23_univ_2d_prim_2d_applic)
___NEED_GLO(___G_c_23_univ_2d_prim_2d_info)
___NEED_GLO(___G_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___NEED_GLO(___G_c_23_univ_2d_prim_2d_proc_2d_table)
___NEED_GLO(___G_c_23_univ_2d_runtime_2d_system)
___NEED_GLO(___G_c_23_univ_2d_setup)
___NEED_GLO(___G_c_23_univ_2d_sp_2d_adjust)
___NEED_GLO(___G_c_23_univ_2d_switch_2d_testable_3f_)
___NEED_GLO(___G_c_23_univ_2d_to_2d_target)
___NEED_GLO(___G_c_23_univ_2d_translate_2d_lbl)
___NEED_GLO(___G_c_23_void_2d_object_3f_)
___NEED_GLO(___G_call_2d_with_2d_output_2d_file)
___NEED_GLO(___G_list_2d_ref)
___NEED_GLO(___G_make_2d_table)
___NEED_GLO(___G_object_2d__3e_string)
___NEED_GLO(___G_pretty_2d_print)
___NEED_GLO(___G_print)
___NEED_GLO(___G_string_2d__3e_symbol)
___NEED_GLO(___G_symbol_2d__3e_string)
___NEED_GLO(___G_table_2d_ref)
___NEED_GLO(___G_table_2d_set_21_)
___NEED_GLO(___G_vector)

___BEGIN_SYM1
___DEF_SYM1(0,___S__23__23_not,"##not")
___DEF_SYM1(1,___S_apply,"apply")
___DEF_SYM1(2,___S_close,"close")
___DEF_SYM1(3,___S_closure_2d_env,"closure-env")
___DEF_SYM1(4,___S_copy,"copy")
___DEF_SYM1(5,___S_end_2d_comment,"end-comment")
___DEF_SYM1(6,___S_entry,"entry")
___DEF_SYM1(7,___S_entry_2d_point,"entry-point")
___DEF_SYM1(8,___S_gen_2d_apply,"gen-apply")
___DEF_SYM1(9,___S_gen_2d_clo,"gen-clo")
___DEF_SYM1(10,___S_gen_2d_close,"gen-close")
___DEF_SYM1(11,___S_gen_2d_copy,"gen-copy")
___DEF_SYM1(12,___S_gen_2d_glo,"gen-glo")
___DEF_SYM1(13,___S_gen_2d_ifjump,"gen-ifjump")
___DEF_SYM1(14,___S_gen_2d_jump,"gen-jump")
___DEF_SYM1(15,___S_gen_2d_label,"gen-label")
___DEF_SYM1(16,___S_gen_2d_nl,"gen-nl")
___DEF_SYM1(17,___S_gen_2d_obj,"gen-obj")
___DEF_SYM1(18,___S_gen_2d_reg,"gen-reg")
___DEF_SYM1(19,___S_gen_2d_stk,"gen-stk")
___DEF_SYM1(20,___S_gen_2d_string,"gen-string")
___DEF_SYM1(21,___S_gen_2d_switch,"gen-switch")
___DEF_SYM1(22,___S_ifjump,"ifjump")
___DEF_SYM1(23,___S_js,"js")
___DEF_SYM1(24,___S_jump,"jump")
___DEF_SYM1(25,___S_label,"label")
___DEF_SYM1(26,___S_open_2d_comment,"open-comment")
___DEF_SYM1(27,___S_php,"php")
___DEF_SYM1(28,___S_prim_2d_applic,"prim-applic")
___DEF_SYM1(29,___S_python,"python")
___DEF_SYM1(30,___S_return,"return")
___DEF_SYM1(31,___S_runtime_2d_system,"runtime-system")
___DEF_SYM1(32,___S_simple,"simple")
___DEF_SYM1(33,___S_sp_2d_adjust,"sp-adjust")
___DEF_SYM1(34,___S_switch,"switch")
___DEF_SYM1(35,___S_targ,"targ")
___DEF_SYM1(36,___S_task_2d_entry,"task-entry")
___DEF_SYM1(37,___S_task_2d_return,"task-return")
___DEF_SYM1(38,___S_translate_2d_lbl,"translate-lbl")
___DEF_SYM1(39,___S_univ_2d_switch_2d_testable_3f_,"univ-switch-testable?")
___END_SYM1

___BEGIN_KEY1
___DEF_KEY1(0,___K_port,"port")
___END_KEY1

___BEGIN_GLO
___DEF_GLO(0," _t-univ")
___DEF_GLO(1,"c#add-target-fun")
___DEF_GLO(2,"c#ctx-ns")
___DEF_GLO(3,"c#ctx-ns-set!")
___DEF_GLO(4,"c#ctx-target")
___DEF_GLO(5,"c#ctx-target-set!")
___DEF_GLO(6,"c#gen")
___DEF_GLO(7,"c#get-target-fun")
___DEF_GLO(8,"c#js-end-comment")
___DEF_GLO(9,"c#js-entry-point")
___DEF_GLO(10,"c#js-gen-apply")
___DEF_GLO(11,"c#js-gen-clo")
___DEF_GLO(12,"c#js-gen-close")
___DEF_GLO(13,"c#js-gen-copy")
___DEF_GLO(14,"c#js-gen-glo")
___DEF_GLO(15,"c#js-gen-ifjump")
___DEF_GLO(16,"c#js-gen-jump")
___DEF_GLO(17,"c#js-gen-label")
___DEF_GLO(18,"c#js-gen-nl")
___DEF_GLO(19,"c#js-gen-obj")
___DEF_GLO(20,"c#js-gen-reg")
___DEF_GLO(21,"c#js-gen-stk")
___DEF_GLO(22,"c#js-gen-string")
___DEF_GLO(23,"c#js-gen-switch")
___DEF_GLO(24,"c#js-lbl->id")
___DEF_GLO(25,"c#js-open-comment")
___DEF_GLO(26,"c#js-prim-applic")
___DEF_GLO(27,"c#js-runtime-system")
___DEF_GLO(28,"c#js-sp-adjust")
___DEF_GLO(29,"c#js-translate-lbl")
___DEF_GLO(30,"c#make-ctx")
___DEF_GLO(31,"c#translate-gvm-instr")
___DEF_GLO(32,"c#translate-gvm-opnd")
___DEF_GLO(33,"c#univ-dump")
___DEF_GLO(34,"c#univ-dump-procs")
___DEF_GLO(35,"c#univ-end-comment")
___DEF_GLO(36,"c#univ-entry-point")
___DEF_GLO(37,"c#univ-frame-alignment")
___DEF_GLO(38,"c#univ-frame-reserve")
___DEF_GLO(39,"c#univ-gen-apply-instr")
___DEF_GLO(40,"c#univ-gen-clo-opnd")
___DEF_GLO(41,"c#univ-gen-close-instr")
___DEF_GLO(42,"c#univ-gen-copy-instr")
___DEF_GLO(43,"c#univ-gen-glo-opnd")
___DEF_GLO(44,"c#univ-gen-ifjump-instr")
___DEF_GLO(45,"c#univ-gen-jump-instr")
___DEF_GLO(46,"c#univ-gen-label-instr")
___DEF_GLO(47,"c#univ-gen-nl")
___DEF_GLO(48,"c#univ-gen-obj-opnd")
___DEF_GLO(49,"c#univ-gen-reg-opnd")
___DEF_GLO(50,"c#univ-gen-stk-opnd")
___DEF_GLO(51,"c#univ-gen-string")
___DEF_GLO(52,"c#univ-gen-switch-instr")
___DEF_GLO(53,"c#univ-jump-info")
___DEF_GLO(54,"c#univ-label-info")
___DEF_GLO(55,"c#univ-nb-arg-regs")
___DEF_GLO(56,"c#univ-nb-gvm-regs")
___DEF_GLO(57,"c#univ-open-comment")
___DEF_GLO(58,"c#univ-prim-applic")
___DEF_GLO(59,"c#univ-prim-info")
___DEF_GLO(60,"c#univ-prim-proc-add!")
___DEF_GLO(61,"c#univ-prim-proc-table")
___DEF_GLO(62,"c#univ-runtime-system")
___DEF_GLO(63,"c#univ-setup")
___DEF_GLO(64,"c#univ-sp-adjust")
___DEF_GLO(65,"c#univ-switch-testable?")
___DEF_GLO(66,"c#univ-to-target")
___DEF_GLO(67,"c#univ-translate-lbl")
___DEF_GLO(68,"apply")
___DEF_GLO(69,"assoc")
___DEF_GLO(70,"c#apply-loc")
___DEF_GLO(71,"c#apply-opnds")
___DEF_GLO(72,"c#apply-prim")
___DEF_GLO(73,"c#bbs->code-list")
___DEF_GLO(74,"c#bbs?")
___DEF_GLO(75,"c#clo-base")
___DEF_GLO(76,"c#clo-index")
___DEF_GLO(77,"c#clo?")
___DEF_GLO(78,"c#close-parms")
___DEF_GLO(79,"c#closure-parms-loc")
___DEF_GLO(80,"c#closure-parms-opnds")
___DEF_GLO(81,"c#code-gvm-instr")
___DEF_GLO(82,"c#compiler-internal-error")
___DEF_GLO(83,"c#copy-loc")
___DEF_GLO(84,"c#copy-opnd")
___DEF_GLO(85,"c#frame-size")
___DEF_GLO(86,"c#glo-name")
___DEF_GLO(87,"c#glo?")
___DEF_GLO(88,"c#gvm-instr-frame")
___DEF_GLO(89,"c#gvm-instr-type")
___DEF_GLO(90,"c#ifjump-false")
___DEF_GLO(91,"c#ifjump-opnds")
___DEF_GLO(92,"c#ifjump-test")
___DEF_GLO(93,"c#ifjump-true")
___DEF_GLO(94,"c#jump-nb-args")
___DEF_GLO(95,"c#jump-opnd")
___DEF_GLO(96,"c#jump-poll?")
___DEF_GLO(97,"c#label-entry-closed?")
___DEF_GLO(98,"c#label-entry-nb-parms")
___DEF_GLO(99,"c#label-lbl-num")
___DEF_GLO(100,"c#label-type")
___DEF_GLO(101,"c#lbl-num")
___DEF_GLO(102,"c#lbl?")
___DEF_GLO(103,"c#make-frame-constraints")
___DEF_GLO(104,"c#make-lbl")
___DEF_GLO(105,"c#make-obj")
___DEF_GLO(106,"c#make-pcontext")
___DEF_GLO(107,"c#make-proc-obj")
___DEF_GLO(108,"c#make-reg")
___DEF_GLO(109,"c#make-stk")
___DEF_GLO(110,"c#make-target")
___DEF_GLO(111,"c#obj-val")
___DEF_GLO(112,"c#obj?")
___DEF_GLO(113,"c#prim-procs")
___DEF_GLO(114,"c#proc-obj-code")
___DEF_GLO(115,"c#proc-obj-name")
___DEF_GLO(116,"c#proc-obj-primitive?")
___DEF_GLO(117,"c#proc-obj?")
___DEF_GLO(118,"c#queue->list")
___DEF_GLO(119,"c#queue-empty")
___DEF_GLO(120,"c#queue-empty?")
___DEF_GLO(121,"c#queue-get!")
___DEF_GLO(122,"c#queue-put!")
___DEF_GLO(123,"c#reg-num")
___DEF_GLO(124,"c#reg?")
___DEF_GLO(125,"c#scheme-id->c-id")
___DEF_GLO(126,"c#stk-num")
___DEF_GLO(127,"c#stk?")
___DEF_GLO(128,"c#string->canonical-symbol")
___DEF_GLO(129,"c#switch-case-obj")
___DEF_GLO(130,"c#switch-cases")
___DEF_GLO(131,"c#switch-opnd")
___DEF_GLO(132,"c#target-add")
___DEF_GLO(133,"c#target-begin!-set!")
___DEF_GLO(134,"c#target-dump-set!")
___DEF_GLO(135,"c#target-end!-set!")
___DEF_GLO(136,"c#target-file-extension-set!")
___DEF_GLO(137,"c#target-frame-constraints-set!")
___DEF_GLO(138,"c#target-jump-info-set!")
___DEF_GLO(139,"c#target-label-info-set!")
___DEF_GLO(140,"c#target-name")
___DEF_GLO(141,"c#target-nb-regs-set!")
___DEF_GLO(142,"c#target-prim-info-set!")
___DEF_GLO(143,"c#target-proc-result-set!")
___DEF_GLO(144,"c#target-switch-testable?-set!")
___DEF_GLO(145,"c#target-task-return-set!")
___DEF_GLO(146,"c#void-object?")
___DEF_GLO(147,"call-with-output-file")
___DEF_GLO(148,"list-ref")
___DEF_GLO(149,"make-table")
___DEF_GLO(150,"object->string")
___DEF_GLO(151,"pretty-print")
___DEF_GLO(152,"print")
___DEF_GLO(153,"string->symbol")
___DEF_GLO(154,"symbol->string")
___DEF_GLO(155,"table-ref")
___DEF_GLO(156,"table-set!")
___DEF_GLO(157,"vector")
___END_GLO

___DEF_SUB_STR(___X0,3)
               ___STR3(46,106,115)
___DEF_SUB_STR(___X1,3)
               ___STR3(46,112,121)
___DEF_SUB_STR(___X2,4)
               ___STR4(46,112,104,112)
___DEF_SUB_STR(___X3,1)
               ___STR1(10)
___DEF_SUB_STR(___X4,2)
               ___STR2(47,47)
___DEF_SUB_STR(___X5,0)
               ___STR0
___DEF_SUB_STR(___X6,3)
               ___STR3(108,98,108)
___DEF_SUB_STR(___X7,1)
               ___STR1(95)
___DEF_SUB_STR(___X8,0)
               ___STR0
___DEF_SUB_STR(___X9,1)
               ___STR1(10)
___DEF_SUB_STR(___X10,1)
               ___STR1(10)
___DEF_SUB_STR(___X11,9)
               ___STR8(102,117,110,99,116,105,111,110)
               ___STR1(32)
___DEF_SUB_STR(___X12,5)
               ___STR5(40,41,32,123,10)
___DEF_SUB_STR(___X13,16)
               ___STR8(47,47,32,114,101,116,117,114)
               ___STR8(110,45,112,111,105,110,116,10)
               ___STR0
___DEF_SUB_STR(___X14,20)
               ___STR8(47,47,32,116,97,115,107,45)
               ___STR8(101,110,116,114,121,45,112,111)
               ___STR4(105,110,116,10)
___DEF_SUB_STR(___X15,50)
               ___STR8(116,104,114,111,119,32,34,116)
               ___STR8(97,115,107,45,101,110,116,114)
               ___STR8(121,45,112,111,105,110,116,32)
               ___STR8(71,86,77,32,108,97,98,101)
               ___STR8(108,32,117,110,105,109,112,108)
               ___STR8(101,109,101,110,116,101,100,34)
               ___STR2(59,10)
___DEF_SUB_STR(___X16,21)
               ___STR8(47,47,32,116,97,115,107,45)
               ___STR8(114,101,116,117,114,110,45,112)
               ___STR5(111,105,110,116,10)
___DEF_SUB_STR(___X17,51)
               ___STR8(116,104,114,111,119,32,34,116)
               ___STR8(97,115,107,45,114,101,116,117)
               ___STR8(114,110,45,112,111,105,110,116)
               ___STR8(32,71,86,77,32,108,97,98)
               ___STR8(101,108,32,117,110,105,109,112)
               ___STR8(108,101,109,101,110,116,101,100)
               ___STR3(34,59,10)
___DEF_SUB_STR(___X18,39)
               ___STR8(116,114,97,110,115,108,97,116)
               ___STR8(101,45,103,118,109,45,105,110)
               ___STR8(115,116,114,44,32,117,110,107)
               ___STR8(110,111,119,110,32,108,97,98)
               ___STR7(101,108,32,116,121,112,101)
___DEF_SUB_STR(___X19,15)
               ___STR8(47,47,32,101,110,116,114,121)
               ___STR7(45,112,111,105,110,116,10)
___DEF_SUB_STR(___X20,23)
               ___STR8(47,47,32,99,108,111,115,117)
               ___STR8(114,101,45,101,110,116,114,121)
               ___STR7(45,112,111,105,110,116,10)
___DEF_SUB_STR(___X21,14)
               ___STR8(105,102,32,40,110,97,114,103)
               ___STR6(115,32,33,61,61,32)
___DEF_SUB_STR(___X22,2)
               ___STR2(41,32)
___DEF_SUB_STR(___X23,36)
               ___STR8(116,104,114,111,119,32,34,119)
               ___STR8(114,111,110,103,32,110,117,109)
               ___STR8(98,101,114,32,111,102,32,97)
               ___STR8(114,103,117,109,101,110,116,115)
               ___STR4(34,59,10,10)
___DEF_SUB_STR(___X24,3)
               ___STR3(32,61,32)
___DEF_SUB_STR(___X25,2)
               ___STR2(59,10)
___DEF_SUB_STR(___X26,0)
               ___STR0
___DEF_SUB_STR(___X27,3)
               ___STR3(32,61,32)
___DEF_SUB_STR(___X28,2)
               ___STR2(59,10)
___DEF_SUB_STR(___X29,45)
               ___STR8(116,104,114,111,119,32,34,99)
               ___STR8(108,111,115,101,32,71,86,77)
               ___STR8(32,105,110,115,116,114,117,99)
               ___STR8(116,105,111,110,32,117,110,105)
               ___STR8(109,112,108,101,109,101,110,116)
               ___STR5(101,100,34,59,10)
___DEF_SUB_STR(___X30,1)
               ___STR1(32)
___DEF_SUB_STR(___X31,4)
               ___STR4(105,102,32,40)
___DEF_SUB_STR(___X32,2)
               ___STR2(41,32)
___DEF_SUB_STR(___X33,2)
               ___STR2(123,32)
___DEF_SUB_STR(___X34,7)
               ___STR7(114,101,116,117,114,110,32)
___DEF_SUB_STR(___X35,3)
               ___STR3(59,32,125)
___DEF_SUB_STR(___X36,6)
               ___STR6(32,101,108,115,101,32)
___DEF_SUB_STR(___X37,2)
               ___STR2(123,32)
___DEF_SUB_STR(___X38,7)
               ___STR7(114,101,116,117,114,110,32)
___DEF_SUB_STR(___X39,3)
               ___STR3(59,32,125)
___DEF_SUB_STR(___X40,3)
               ___STR3(10,125,10)
___DEF_SUB_STR(___X41,46)
               ___STR8(116,104,114,111,119,32,34,115)
               ___STR8(119,105,116,99,104,32,71,86)
               ___STR8(77,32,105,110,115,116,114,117)
               ___STR8(99,116,105,111,110,32,117,110)
               ___STR8(105,109,112,108,101,109,101,110)
               ___STR6(116,101,100,34,59,10)
___DEF_SUB_STR(___X42,2)
               ___STR2(125,10)
___DEF_SUB_STR(___X43,0)
               ___STR0
___DEF_SUB_STR(___X44,8)
               ___STR8(110,97,114,103,115,32,61,32)
               ___STR0
___DEF_SUB_STR(___X45,2)
               ___STR2(59,10)
___DEF_SUB_STR(___X46,1)
               ___STR1(10)
___DEF_SUB_STR(___X47,7)
               ___STR7(114,101,116,117,114,110,32)
___DEF_SUB_STR(___X48,2)
               ___STR2(59,10)
___DEF_SUB_STR(___X49,10)
               ___STR8(115,97,118,101,95,112,99,32)
               ___STR2(61,32)
___DEF_SUB_STR(___X50,2)
               ___STR2(59,10)
___DEF_SUB_STR(___X51,13)
               ___STR8(114,101,116,117,114,110,32,110)
               ___STR5(117,108,108,59,10)
___DEF_SUB_STR(___X52,2)
               ___STR2(125,10)
___DEF_SUB_STR(___X53,4)
               ___STR4(114,101,103,91)
___DEF_SUB_STR(___X54,1)
               ___STR1(93)
___DEF_SUB_STR(___X55,0)
               ___STR0
___DEF_SUB_STR(___X56,1)
               ___STR1(43)
___DEF_SUB_STR(___X57,8)
               ___STR8(115,116,97,99,107,91,115,112)
               ___STR0
___DEF_SUB_STR(___X58,1)
               ___STR1(93)
___DEF_SUB_STR(___X59,4)
               ___STR4(103,108,111,91)
___DEF_SUB_STR(___X60,1)
               ___STR1(93)
___DEF_SUB_STR(___X61,1)
               ___STR1(91)
___DEF_SUB_STR(___X62,1)
               ___STR1(93)
___DEF_SUB_STR(___X63,9)
               ___STR8(117,110,100,101,102,105,110,101)
               ___STR1(100)
___DEF_SUB_STR(___X64,21)
               ___STR8(85,78,73,77,80,76,69,77)
               ___STR8(69,78,84,69,68,95,79,66)
               ___STR5(74,69,67,84,40)
___DEF_SUB_STR(___X65,1)
               ___STR1(41)
___DEF_SUB_STR(___X66,0)
               ___STR0
___DEF_SUB_STR(___X67,6)
               ___STR6(115,112,32,43,61,32)
___DEF_SUB_STR(___X68,1)
               ___STR1(59)
___DEF_SUB_STR(___X69,1)
               ___STR1(10)
___DEF_SUB_STR(___X70,10)
               ___STR8(115,97,118,101,95,112,99,32)
               ___STR2(61,32)
___DEF_SUB_STR(___X71,9)
               ___STR8(59,32,114,117,110,40,41,59)
               ___STR1(10)
___DEF_SUB_STR(___X72,1264)
               ___STR8(118,97,114,32,103,108,111,32)
               ___STR8(61,32,123,125,59,10,118,97)
               ___STR8(114,32,114,101,103,32,61,32)
               ___STR8(91,110,117,108,108,93,59,10)
               ___STR8(118,97,114,32,115,116,97,99)
               ___STR8(107,32,61,32,91,93,59,10)
               ___STR8(118,97,114,32,115,112,32,61)
               ___STR8(32,45,49,59,10,118,97,114)
               ___STR8(32,110,97,114,103,115,32,61)
               ___STR8(32,48,59,10,118,97,114,32)
               ___STR8(115,97,118,101,95,112,99,32)
               ___STR8(61,32,110,117,108,108,59,10)
               ___STR8(118,97,114,32,112,111,108,108)
               ___STR8(59,10,10,105,102,32,40,116)
               ___STR8(104,105,115,46,104,97,115,79)
               ___STR8(119,110,80,114,111,112,101,114)
               ___STR8(116,121,40,39,115,101,116,84)
               ___STR8(105,109,101,111,117,116,39,41)
               ___STR8(41,10,123,10,32,32,32,32)
               ___STR8(112,111,108,108,32,61,32,102)
               ___STR8(117,110,99,116,105,111,110,32)
               ___STR8(40,119,97,107,101,117,112,41)
               ___STR8(32,123,32,115,101,116,84,105)
               ___STR8(109,101,111,117,116,40,119,97)
               ___STR8(107,101,117,112,44,49,41,59)
               ___STR8(32,114,101,116,117,114,110,32)
               ___STR8(116,114,117,101,59,32,125,59)
               ___STR8(10,125,10,101,108,115,101,10)
               ___STR8(123,10,32,32,32,32,112,111)
               ___STR8(108,108,32,61,32,102,117,110)
               ___STR8(99,116,105,111,110,32,40,119)
               ___STR8(97,107,101,117,112,41,32,123)
               ___STR8(32,114,101,116,117,114,110,32)
               ___STR8(102,97,108,115,101,59,32,125)
               ___STR8(59,10,125,10,10,102,117,110)
               ___STR8(99,116,105,111,110,32,108,98)
               ___STR8(108,49,95,102,120,95,50,97)
               ___STR8(95,40,41,32,123,32,47,47)
               ___STR8(32,102,120,42,10,32,32,32)
               ___STR8(32,105,102,32,40,110,97,114)
               ___STR8(103,115,32,33,61,61,32,50)
               ___STR8(41,32,116,104,114,111,119,32)
               ___STR8(34,119,114,111,110,103,32,110)
               ___STR8(117,109,98,101,114,32,111,102)
               ___STR8(32,97,114,103,117,109,101,110)
               ___STR8(116,115,34,59,10,32,32,32)
               ___STR8(32,114,101,103,91,49,93,32)
               ___STR8(61,32,114,101,103,91,49,93)
               ___STR8(32,42,32,114,101,103,91,50)
               ___STR8(93,59,10,32,32,32,32,114)
               ___STR8(101,116,117,114,110,32,114,101)
               ___STR8(103,91,48,93,59,10,125,10)
               ___STR8(10,102,117,110,99,116,105,111)
               ___STR8(110,32,108,98,108,49,95,102)
               ___STR8(120,95,51,99,95,40,41,32)
               ___STR8(123,32,47,47,32,102,120,60)
               ___STR8(10,32,32,32,32,105,102,32)
               ___STR8(40,110,97,114,103,115,32,33)
               ___STR8(61,61,32,50,41,32,116,104)
               ___STR8(114,111,119,32,34,119,114,111)
               ___STR8(110,103,32,110,117,109,98,101)
               ___STR8(114,32,111,102,32,97,114,103)
               ___STR8(117,109,101,110,116,115,34,59)
               ___STR8(10,32,32,32,32,114,101,103)
               ___STR8(91,49,93,32,61,32,114,101)
               ___STR8(103,91,49,93,32,60,32,114)
               ___STR8(101,103,91,50,93,59,10,32)
               ___STR8(32,32,32,114,101,116,117,114)
               ___STR8(110,32,114,101,103,91,48,93)
               ___STR8(59,10,125,10,10,103,108,111)
               ___STR8(91,34,102,120,60,34,93,32)
               ___STR8(61,32,108,98,108,49,95,102)
               ___STR8(120,95,51,99,95,59,10,10)
               ___STR8(102,117,110,99,116,105,111,110)
               ___STR8(32,108,98,108,49,95,102,120)
               ___STR8(95,50,98,95,40,41,32,123)
               ___STR8(32,47,47,32,102,120,43,10)
               ___STR8(32,32,32,32,105,102,32,40)
               ___STR8(110,97,114,103,115,32,33,61)
               ___STR8(61,32,50,41,32,116,104,114)
               ___STR8(111,119,32,34,119,114,111,110)
               ___STR8(103,32,110,117,109,98,101,114)
               ___STR8(32,111,102,32,97,114,103,117)
               ___STR8(109,101,110,116,115,34,59,10)
               ___STR8(32,32,32,32,114,101,103,91)
               ___STR8(49,93,32,61,32,114,101,103)
               ___STR8(91,49,93,32,43,32,114,101)
               ___STR8(103,91,50,93,59,10,32,32)
               ___STR8(32,32,114,101,116,117,114,110)
               ___STR8(32,114,101,103,91,48,93,59)
               ___STR8(10,125,10,10,103,108,111,91)
               ___STR8(34,102,120,43,34,93,32,61)
               ___STR8(32,108,98,108,49,95,102,120)
               ___STR8(95,50,98,95,59,10,10,102)
               ___STR8(117,110,99,116,105,111,110,32)
               ___STR8(108,98,108,49,95,102,120,95)
               ___STR8(50,100,95,40,41,32,123,32)
               ___STR8(47,47,32,102,120,45,10,32)
               ___STR8(32,32,32,105,102,32,40,110)
               ___STR8(97,114,103,115,32,33,61,61)
               ___STR8(32,50,41,32,116,104,114,111)
               ___STR8(119,32,34,119,114,111,110,103)
               ___STR8(32,110,117,109,98,101,114,32)
               ___STR8(111,102,32,97,114,103,117,109)
               ___STR8(101,110,116,115,34,59,10,32)
               ___STR8(32,32,32,114,101,103,91,49)
               ___STR8(93,32,61,32,114,101,103,91)
               ___STR8(49,93,32,45,32,114,101,103)
               ___STR8(91,50,93,59,10,32,32,32)
               ___STR8(32,114,101,116,117,114,110,32)
               ___STR8(114,101,103,91,48,93,59,10)
               ___STR8(125,10,10,103,108,111,91,34)
               ___STR8(102,120,45,34,93,32,61,32)
               ___STR8(108,98,108,49,95,102,120,95)
               ___STR8(50,100,95,59,10,10,102,117)
               ___STR8(110,99,116,105,111,110,32,108)
               ___STR8(98,108,49,95,112,114,105,110)
               ___STR8(116,40,41,32,123,32,47,47)
               ___STR8(32,112,114,105,110,116,10,32)
               ___STR8(32,32,32,105,102,32,40,110)
               ___STR8(97,114,103,115,32,33,61,61)
               ___STR8(32,49,41,32,116,104,114,111)
               ___STR8(119,32,34,119,114,111,110,103)
               ___STR8(32,110,117,109,98,101,114,32)
               ___STR8(111,102,32,97,114,103,117,109)
               ___STR8(101,110,116,115,34,59,10,32)
               ___STR8(32,32,32,112,114,105,110,116)
               ___STR8(40,114,101,103,91,49,93,41)
               ___STR8(59,10,32,32,32,32,114,101)
               ___STR8(116,117,114,110,32,114,101,103)
               ___STR8(91,48,93,59,10,125,10,10)
               ___STR8(103,108,111,91,34,112,114,105)
               ___STR8(110,116,34,93,32,61,32,108)
               ___STR8(98,108,49,95,112,114,105,110)
               ___STR8(116,59,10,10,10,102,117,110)
               ___STR8(99,116,105,111,110,32,114,117)
               ___STR8(110,40,41,10,123,10,32,32)
               ___STR8(32,32,119,104,105,108,101,32)
               ___STR8(40,115,97,118,101,95,112,99)
               ___STR8(32,33,61,61,32,110,117,108)
               ___STR8(108,41,10,32,32,32,32,123)
               ___STR8(10,32,32,32,32,32,32,32)
               ___STR8(32,112,99,32,61,32,115,97)
               ___STR8(118,101,95,112,99,59,10,32)
               ___STR8(32,32,32,32,32,32,32,115)
               ___STR8(97,118,101,95,112,99,32,61)
               ___STR8(32,110,117,108,108,59,10,32)
               ___STR8(32,32,32,32,32,32,32,119)
               ___STR8(104,105,108,101,32,40,112,99)
               ___STR8(32,33,61,61,32,110,117,108)
               ___STR8(108,41,10,32,32,32,32,32)
               ___STR8(32,32,32,32,32,32,32,112)
               ___STR8(99,32,61,32,112,99,40,41)
               ___STR8(59,10,32,32,32,32,32,32)
               ___STR8(32,32,105,102,32,40,112,111)
               ___STR8(108,108,40,114,117,110,41,41)
               ___STR8(32,98,114,101,97,107,59,10)
               ___STR8(32,32,32,32,125,10,125,10)
               ___STR0
___DEF_SUB_STR(___X73,10)
               ___STR8(32,61,61,61,32,102,97,108)
               ___STR2(115,101)
___DEF_SUB_STR(___X74,37)
               ___STR8(112,114,105,109,45,97,112,112)
               ___STR8(108,105,99,44,32,117,110,105)
               ___STR8(109,112,108,101,109,101,110,116)
               ___STR8(101,100,32,112,114,105,109,105)
               ___STR5(116,105,118,101,58)
___DEF_SUB_STR(___X75,6)
               ___STR6(42,42,42,32,35,60)
___DEF_SUB_STR(___X76,9)
               ___STR8(112,114,111,99,101,100,117,114)
               ___STR1(101)
___DEF_SUB_STR(___X77,1)
               ___STR1(32)
___DEF_SUB_STR(___X78,3)
               ___STR3(62,32,61)
___DEF_SUB_STR(___X79,9)
               ___STR8(112,114,105,109,105,116,105,118)
               ___STR1(101)
___DEF_SUB_STR(___X80,41)
               ___STR8(116,114,97,110,115,108,97,116)
               ___STR8(101,45,103,118,109,45,105,110)
               ___STR8(115,116,114,44,32,117,110,107)
               ___STR8(110,111,119,110,32,39,103,118)
               ___STR8(109,45,105,110,115,116,114,39)
               ___STR1(58)
___DEF_SUB_STR(___X81,10)
               ___STR8(78,79,95,79,80,69,82,65)
               ___STR2(78,68)
___DEF_SUB_STR(___X82,39)
               ___STR8(116,114,97,110,115,108,97,116)
               ___STR8(101,45,103,118,109,45,111,112)
               ___STR8(110,100,44,32,117,110,107,110)
               ___STR8(111,119,110,32,39,103,118,109)
               ___STR7(45,111,112,110,100,39,58)

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
,___DEF_SUB(___X2)
,___DEF_SUB(___X3)
,___DEF_SUB(___X4)
,___DEF_SUB(___X5)
,___DEF_SUB(___X6)
,___DEF_SUB(___X7)
,___DEF_SUB(___X8)
,___DEF_SUB(___X9)
,___DEF_SUB(___X10)
,___DEF_SUB(___X11)
,___DEF_SUB(___X12)
,___DEF_SUB(___X13)
,___DEF_SUB(___X14)
,___DEF_SUB(___X15)
,___DEF_SUB(___X16)
,___DEF_SUB(___X17)
,___DEF_SUB(___X18)
,___DEF_SUB(___X19)
,___DEF_SUB(___X20)
,___DEF_SUB(___X21)
,___DEF_SUB(___X22)
,___DEF_SUB(___X23)
,___DEF_SUB(___X24)
,___DEF_SUB(___X25)
,___DEF_SUB(___X26)
,___DEF_SUB(___X27)
,___DEF_SUB(___X28)
,___DEF_SUB(___X29)
,___DEF_SUB(___X30)
,___DEF_SUB(___X31)
,___DEF_SUB(___X32)
,___DEF_SUB(___X33)
,___DEF_SUB(___X34)
,___DEF_SUB(___X35)
,___DEF_SUB(___X36)
,___DEF_SUB(___X37)
,___DEF_SUB(___X38)
,___DEF_SUB(___X39)
,___DEF_SUB(___X40)
,___DEF_SUB(___X41)
,___DEF_SUB(___X42)
,___DEF_SUB(___X43)
,___DEF_SUB(___X44)
,___DEF_SUB(___X45)
,___DEF_SUB(___X46)
,___DEF_SUB(___X47)
,___DEF_SUB(___X48)
,___DEF_SUB(___X49)
,___DEF_SUB(___X50)
,___DEF_SUB(___X51)
,___DEF_SUB(___X52)
,___DEF_SUB(___X53)
,___DEF_SUB(___X54)
,___DEF_SUB(___X55)
,___DEF_SUB(___X56)
,___DEF_SUB(___X57)
,___DEF_SUB(___X58)
,___DEF_SUB(___X59)
,___DEF_SUB(___X60)
,___DEF_SUB(___X61)
,___DEF_SUB(___X62)
,___DEF_SUB(___X63)
,___DEF_SUB(___X64)
,___DEF_SUB(___X65)
,___DEF_SUB(___X66)
,___DEF_SUB(___X67)
,___DEF_SUB(___X68)
,___DEF_SUB(___X69)
,___DEF_SUB(___X70)
,___DEF_SUB(___X71)
,___DEF_SUB(___X72)
,___DEF_SUB(___X73)
,___DEF_SUB(___X74)
,___DEF_SUB(___X75)
,___DEF_SUB(___X76)
,___DEF_SUB(___X77)
,___DEF_SUB(___X78)
,___DEF_SUB(___X79)
,___DEF_SUB(___X80)
,___DEF_SUB(___X81)
,___DEF_SUB(___X82)
___END_SUB



#undef ___MD_ALL
#define ___MD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___t_2d_univ)
___DEF_M_HLBL(___L1__20___t_2d_univ)
___DEF_M_HLBL(___L2__20___t_2d_univ)
___DEF_M_HLBL(___L3__20___t_2d_univ)
___DEF_M_HLBL(___L4__20___t_2d_univ)
___DEF_M_HLBL(___L5__20___t_2d_univ)
___DEF_M_HLBL(___L6__20___t_2d_univ)
___DEF_M_HLBL(___L7__20___t_2d_univ)
___DEF_M_HLBL(___L8__20___t_2d_univ)
___DEF_M_HLBL(___L9__20___t_2d_univ)
___DEF_M_HLBL(___L10__20___t_2d_univ)
___DEF_M_HLBL(___L11__20___t_2d_univ)
___DEF_M_HLBL(___L12__20___t_2d_univ)
___DEF_M_HLBL(___L13__20___t_2d_univ)
___DEF_M_HLBL(___L14__20___t_2d_univ)
___DEF_M_HLBL(___L15__20___t_2d_univ)
___DEF_M_HLBL(___L16__20___t_2d_univ)
___DEF_M_HLBL(___L17__20___t_2d_univ)
___DEF_M_HLBL(___L18__20___t_2d_univ)
___DEF_M_HLBL(___L19__20___t_2d_univ)
___DEF_M_HLBL(___L20__20___t_2d_univ)
___DEF_M_HLBL(___L21__20___t_2d_univ)
___DEF_M_HLBL(___L22__20___t_2d_univ)
___DEF_M_HLBL(___L23__20___t_2d_univ)
___DEF_M_HLBL(___L24__20___t_2d_univ)
___DEF_M_HLBL(___L25__20___t_2d_univ)
___DEF_M_HLBL(___L26__20___t_2d_univ)
___DEF_M_HLBL(___L27__20___t_2d_univ)
___DEF_M_HLBL(___L28__20___t_2d_univ)
___DEF_M_HLBL(___L29__20___t_2d_univ)
___DEF_M_HLBL(___L30__20___t_2d_univ)
___DEF_M_HLBL(___L31__20___t_2d_univ)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_nl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_open_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_end_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L7_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L8_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L9_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L10_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L11_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L12_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L13_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L14_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L15_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L16_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L17_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL(___L18_c_23_js_2d_gen_2d_label)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L7_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL(___L8_c_23_js_2d_gen_2d_apply)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L7_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L8_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL(___L9_c_23_js_2d_gen_2d_copy)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_close)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_close)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L7_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L8_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L9_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L10_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L11_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L12_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L13_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L14_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL(___L15_c_23_js_2d_gen_2d_ifjump)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_switch)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_switch)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L7_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L8_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L9_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L10_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L11_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L12_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L13_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL(___L14_c_23_js_2d_gen_2d_jump)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_reg)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_reg)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_reg)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_reg)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_reg)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_stk)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_stk)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_stk)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_stk)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_stk)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_stk)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_glo)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_clo)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L1_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L2_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L3_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L4_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L5_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L6_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L7_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L8_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L9_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L10_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L11_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L12_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L13_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L14_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL(___L15_c_23_js_2d_gen_2d_obj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_sp_2d_adjust)
___DEF_M_HLBL(___L1_c_23_js_2d_sp_2d_adjust)
___DEF_M_HLBL(___L2_c_23_js_2d_sp_2d_adjust)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_translate_2d_lbl)
___DEF_M_HLBL(___L1_c_23_js_2d_translate_2d_lbl)
___DEF_M_HLBL(___L2_c_23_js_2d_translate_2d_lbl)
___DEF_M_HLBL(___L3_c_23_js_2d_translate_2d_lbl)
___DEF_M_HLBL(___L4_c_23_js_2d_translate_2d_lbl)
___DEF_M_HLBL(___L5_c_23_js_2d_translate_2d_lbl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_lbl_2d__3e_id)
___DEF_M_HLBL(___L1_c_23_js_2d_lbl_2d__3e_id)
___DEF_M_HLBL(___L2_c_23_js_2d_lbl_2d__3e_id)
___DEF_M_HLBL(___L3_c_23_js_2d_lbl_2d__3e_id)
___DEF_M_HLBL(___L4_c_23_js_2d_lbl_2d__3e_id)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_entry_2d_point)
___DEF_M_HLBL(___L1_c_23_js_2d_entry_2d_point)
___DEF_M_HLBL(___L2_c_23_js_2d_entry_2d_point)
___DEF_M_HLBL(___L3_c_23_js_2d_entry_2d_point)
___DEF_M_HLBL(___L4_c_23_js_2d_entry_2d_point)
___DEF_M_HLBL(___L5_c_23_js_2d_entry_2d_point)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_runtime_2d_system)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L1_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L2_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L3_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L4_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L5_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L6_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L7_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L8_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL(___L9_c_23_js_2d_prim_2d_applic)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_target_2d_fun)
___DEF_M_HLBL(___L1_c_23_add_2d_target_2d_fun)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_get_2d_target_2d_fun)
___DEF_M_HLBL(___L1_c_23_get_2d_target_2d_fun)
___DEF_M_HLBL(___L2_c_23_get_2d_target_2d_fun)
___DEF_M_HLBL(___L3_c_23_get_2d_target_2d_fun)
___DEF_M_HLBL(___L4_c_23_get_2d_target_2d_fun)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_nl)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_nl)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_nl)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_nl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_open_2d_comment)
___DEF_M_HLBL(___L1_c_23_univ_2d_open_2d_comment)
___DEF_M_HLBL(___L2_c_23_univ_2d_open_2d_comment)
___DEF_M_HLBL(___L3_c_23_univ_2d_open_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_end_2d_comment)
___DEF_M_HLBL(___L1_c_23_univ_2d_end_2d_comment)
___DEF_M_HLBL(___L2_c_23_univ_2d_end_2d_comment)
___DEF_M_HLBL(___L3_c_23_univ_2d_end_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_string)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_string)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_string)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_sp_2d_adjust)
___DEF_M_HLBL(___L1_c_23_univ_2d_sp_2d_adjust)
___DEF_M_HLBL(___L2_c_23_univ_2d_sp_2d_adjust)
___DEF_M_HLBL(___L3_c_23_univ_2d_sp_2d_adjust)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_translate_2d_lbl)
___DEF_M_HLBL(___L1_c_23_univ_2d_translate_2d_lbl)
___DEF_M_HLBL(___L2_c_23_univ_2d_translate_2d_lbl)
___DEF_M_HLBL(___L3_c_23_univ_2d_translate_2d_lbl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_entry_2d_point)
___DEF_M_HLBL(___L1_c_23_univ_2d_entry_2d_point)
___DEF_M_HLBL(___L2_c_23_univ_2d_entry_2d_point)
___DEF_M_HLBL(___L3_c_23_univ_2d_entry_2d_point)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_runtime_2d_system)
___DEF_M_HLBL(___L1_c_23_univ_2d_runtime_2d_system)
___DEF_M_HLBL(___L2_c_23_univ_2d_runtime_2d_system)
___DEF_M_HLBL(___L3_c_23_univ_2d_runtime_2d_system)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_prim_2d_applic)
___DEF_M_HLBL(___L1_c_23_univ_2d_prim_2d_applic)
___DEF_M_HLBL(___L2_c_23_univ_2d_prim_2d_applic)
___DEF_M_HLBL(___L3_c_23_univ_2d_prim_2d_applic)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_M_HLBL(___L1_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_M_HLBL(___L2_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_M_HLBL(___L3_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_setup)
___DEF_M_HLBL(___L1_c_23_univ_2d_setup)
___DEF_M_HLBL(___L2_c_23_univ_2d_setup)
___DEF_M_HLBL(___L3_c_23_univ_2d_setup)
___DEF_M_HLBL(___L4_c_23_univ_2d_setup)
___DEF_M_HLBL(___L5_c_23_univ_2d_setup)
___DEF_M_HLBL(___L6_c_23_univ_2d_setup)
___DEF_M_HLBL(___L7_c_23_univ_2d_setup)
___DEF_M_HLBL(___L8_c_23_univ_2d_setup)
___DEF_M_HLBL(___L9_c_23_univ_2d_setup)
___DEF_M_HLBL(___L10_c_23_univ_2d_setup)
___DEF_M_HLBL(___L11_c_23_univ_2d_setup)
___DEF_M_HLBL(___L12_c_23_univ_2d_setup)
___DEF_M_HLBL(___L13_c_23_univ_2d_setup)
___DEF_M_HLBL(___L14_c_23_univ_2d_setup)
___DEF_M_HLBL(___L15_c_23_univ_2d_setup)
___DEF_M_HLBL(___L16_c_23_univ_2d_setup)
___DEF_M_HLBL(___L17_c_23_univ_2d_setup)
___DEF_M_HLBL(___L18_c_23_univ_2d_setup)
___DEF_M_HLBL(___L19_c_23_univ_2d_setup)
___DEF_M_HLBL(___L20_c_23_univ_2d_setup)
___DEF_M_HLBL(___L21_c_23_univ_2d_setup)
___DEF_M_HLBL(___L22_c_23_univ_2d_setup)
___DEF_M_HLBL(___L23_c_23_univ_2d_setup)
___DEF_M_HLBL(___L24_c_23_univ_2d_setup)
___DEF_M_HLBL(___L25_c_23_univ_2d_setup)
___DEF_M_HLBL(___L26_c_23_univ_2d_setup)
___DEF_M_HLBL(___L27_c_23_univ_2d_setup)
___DEF_M_HLBL(___L28_c_23_univ_2d_setup)
___DEF_M_HLBL(___L29_c_23_univ_2d_setup)
___DEF_M_HLBL(___L30_c_23_univ_2d_setup)
___DEF_M_HLBL(___L31_c_23_univ_2d_setup)
___DEF_M_HLBL(___L32_c_23_univ_2d_setup)
___DEF_M_HLBL(___L33_c_23_univ_2d_setup)
___DEF_M_HLBL(___L34_c_23_univ_2d_setup)
___DEF_M_HLBL(___L35_c_23_univ_2d_setup)
___DEF_M_HLBL(___L36_c_23_univ_2d_setup)
___DEF_M_HLBL(___L37_c_23_univ_2d_setup)
___DEF_M_HLBL(___L38_c_23_univ_2d_setup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L1_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L2_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L3_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L4_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L5_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L6_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L7_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L8_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L9_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L10_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L11_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L12_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL(___L13_c_23_univ_2d_label_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L1_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L2_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L3_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L4_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L5_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L6_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L7_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L8_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L9_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L10_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L11_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L12_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL(___L13_c_23_univ_2d_jump_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_prim_2d_info)
___DEF_M_HLBL(___L1_c_23_univ_2d_prim_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_M_HLBL(___L1_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_M_HLBL(___L2_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_M_HLBL(___L3_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_M_HLBL(___L4_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_M_HLBL(___L1_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_M_HLBL(___L2_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_M_HLBL(___L3_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_M_HLBL(___L4_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_dump)
___DEF_M_HLBL(___L1_c_23_univ_2d_dump)
___DEF_M_HLBL(___L2_c_23_univ_2d_dump)
___DEF_M_HLBL(___L3_c_23_univ_2d_dump)
___DEF_M_HLBL(___L4_c_23_univ_2d_dump)
___DEF_M_HLBL(___L5_c_23_univ_2d_dump)
___DEF_M_HLBL(___L6_c_23_univ_2d_dump)
___DEF_M_HLBL(___L7_c_23_univ_2d_dump)
___DEF_M_HLBL(___L8_c_23_univ_2d_dump)
___DEF_M_HLBL(___L9_c_23_univ_2d_dump)
___DEF_M_HLBL(___L10_c_23_univ_2d_dump)
___DEF_M_HLBL(___L11_c_23_univ_2d_dump)
___DEF_M_HLBL(___L12_c_23_univ_2d_dump)
___DEF_M_HLBL(___L13_c_23_univ_2d_dump)
___DEF_M_HLBL(___L14_c_23_univ_2d_dump)
___DEF_M_HLBL(___L15_c_23_univ_2d_dump)
___DEF_M_HLBL(___L16_c_23_univ_2d_dump)
___DEF_M_HLBL(___L17_c_23_univ_2d_dump)
___DEF_M_HLBL(___L18_c_23_univ_2d_dump)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L1_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L2_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L3_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L4_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L5_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L6_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L7_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L8_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L9_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L10_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L11_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L12_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L13_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L14_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L15_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L16_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L17_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L18_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L19_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L20_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L21_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L22_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L23_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L24_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L25_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L26_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L27_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L28_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L29_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L30_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L31_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L32_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L33_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L34_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L35_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L36_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L37_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L38_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L39_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L40_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L41_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L42_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L43_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L44_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L45_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L46_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L47_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L48_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L49_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L50_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L51_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L52_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L53_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L54_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L55_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L56_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L57_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L58_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L59_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L60_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L61_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L62_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L63_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L64_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L65_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L66_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L67_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L68_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L69_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L70_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L71_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L72_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L73_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L74_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L75_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L76_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L77_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L78_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L79_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L80_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L81_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L82_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L83_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L84_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L85_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L86_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L87_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L88_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL(___L89_c_23_univ_2d_dump_2d_procs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_ctx)
___DEF_M_HLBL(___L1_c_23_make_2d_ctx)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ctx_2d_target)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ctx_2d_target_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ctx_2d_ns)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ctx_2d_ns_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L1_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L2_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L3_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L4_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L5_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L6_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L7_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L8_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L9_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L10_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL(___L11_c_23_translate_2d_gvm_2d_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L1_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L2_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L3_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L4_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L5_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L6_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L7_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L8_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L9_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L10_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L11_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L12_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L13_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L14_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L15_c_23_translate_2d_gvm_2d_opnd)
___DEF_M_HLBL(___L16_c_23_translate_2d_gvm_2d_opnd)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___t_2d_univ
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___t_2d_univ)
___DEF_P_HLBL(___L1__20___t_2d_univ)
___DEF_P_HLBL(___L2__20___t_2d_univ)
___DEF_P_HLBL(___L3__20___t_2d_univ)
___DEF_P_HLBL(___L4__20___t_2d_univ)
___DEF_P_HLBL(___L5__20___t_2d_univ)
___DEF_P_HLBL(___L6__20___t_2d_univ)
___DEF_P_HLBL(___L7__20___t_2d_univ)
___DEF_P_HLBL(___L8__20___t_2d_univ)
___DEF_P_HLBL(___L9__20___t_2d_univ)
___DEF_P_HLBL(___L10__20___t_2d_univ)
___DEF_P_HLBL(___L11__20___t_2d_univ)
___DEF_P_HLBL(___L12__20___t_2d_univ)
___DEF_P_HLBL(___L13__20___t_2d_univ)
___DEF_P_HLBL(___L14__20___t_2d_univ)
___DEF_P_HLBL(___L15__20___t_2d_univ)
___DEF_P_HLBL(___L16__20___t_2d_univ)
___DEF_P_HLBL(___L17__20___t_2d_univ)
___DEF_P_HLBL(___L18__20___t_2d_univ)
___DEF_P_HLBL(___L19__20___t_2d_univ)
___DEF_P_HLBL(___L20__20___t_2d_univ)
___DEF_P_HLBL(___L21__20___t_2d_univ)
___DEF_P_HLBL(___L22__20___t_2d_univ)
___DEF_P_HLBL(___L23__20___t_2d_univ)
___DEF_P_HLBL(___L24__20___t_2d_univ)
___DEF_P_HLBL(___L25__20___t_2d_univ)
___DEF_P_HLBL(___L26__20___t_2d_univ)
___DEF_P_HLBL(___L27__20___t_2d_univ)
___DEF_P_HLBL(___L28__20___t_2d_univ)
___DEF_P_HLBL(___L29__20___t_2d_univ)
___DEF_P_HLBL(___L30__20___t_2d_univ)
___DEF_P_HLBL(___L31__20___t_2d_univ)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___t_2d_univ)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___t_2d_univ)
   ___SET_GLO(6,___G_c_23_gen,___PRM(157,___G_vector))
   ___SET_GLO(66,___G_c_23_univ_2d_to_2d_target,___NUL)
   ___SET_STK(1,___R0)
   ___SET_R3(___PRC(34))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(16,___S_gen_2d_nl))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__20___t_2d_univ)
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(2,___L2__20___t_2d_univ)
   ___SET_R3(___PRC(36))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(26,___S_open_2d_comment))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(3,___L3__20___t_2d_univ)
   ___SET_R3(___PRC(38))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(5,___S_end_2d_comment))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(4,___L4__20___t_2d_univ)
   ___SET_R3(___PRC(40))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(20,___S_gen_2d_string))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(5,___L5__20___t_2d_univ)
   ___SET_R3(___PRC(168))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(33,___S_sp_2d_adjust))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(6,___L6__20___t_2d_univ)
   ___SET_R3(___PRC(172))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(38,___S_translate_2d_lbl))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(7,___L7__20___t_2d_univ)
   ___SET_R3(___PRC(185))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(7,___S_entry_2d_point))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(8,___L8__20___t_2d_univ)
   ___SET_R3(___PRC(192))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(31,___S_runtime_2d_system))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(9,___L9__20___t_2d_univ)
   ___SET_R3(___PRC(194))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(28,___S_prim_2d_applic))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(10,___L10__20___t_2d_univ)
   ___SET_R3(___PRC(42))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(15,___S_gen_2d_label))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(11,___L11__20___t_2d_univ)
   ___SET_R3(___PRC(62))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(8,___S_gen_2d_apply))
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(12,___L12__20___t_2d_univ)
   ___SET_R3(___PRC(72))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(11,___S_gen_2d_copy))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(13,___L13__20___t_2d_univ)
   ___SET_R3(___PRC(83))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(10,___S_gen_2d_close))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(14,___L14__20___t_2d_univ)
   ___SET_R3(___PRC(86))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(13,___S_gen_2d_ifjump))
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(15,___L15__20___t_2d_univ)
   ___SET_R3(___PRC(103))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(21,___S_gen_2d_switch))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(16,___L16__20___t_2d_univ)
   ___SET_R3(___PRC(106))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(14,___S_gen_2d_jump))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(17,___L17__20___t_2d_univ)
   ___SET_R3(___PRC(122))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(18,___S_gen_2d_reg))
   ___SET_R0(___LBL(18))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(18,___L18__20___t_2d_univ)
   ___SET_R3(___PRC(128))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(19,___S_gen_2d_stk))
   ___SET_R0(___LBL(19))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(19,___L19__20___t_2d_univ)
   ___SET_R3(___PRC(135))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(12,___S_gen_2d_glo))
   ___SET_R0(___LBL(20))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(20,___L20__20___t_2d_univ)
   ___SET_R3(___PRC(143))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(9,___S_gen_2d_clo))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(21,___L21__20___t_2d_univ)
   ___SET_R3(___PRC(151))
   ___SET_R2(___SYM(23,___S_js))
   ___SET_R1(___SYM(17,___S_gen_2d_obj))
   ___SET_R0(___LBL(22))
   ___JUMPINT(___SET_NARGS(3),___PRC(205),___L_c_23_add_2d_target_2d_fun)
___DEF_SLBL(22,___L22__20___t_2d_univ)
   ___SET_R2(___SUB(0))
   ___SET_R1(___SYM(23,___S_js))
   ___SET_R0(___LBL(23))
   ___JUMPINT(___SET_NARGS(2),___PRC(319),___L_c_23_univ_2d_setup)
___DEF_SLBL(23,___L23__20___t_2d_univ)
   ___SET_R2(___SUB(1))
   ___SET_R1(___SYM(29,___S_python))
   ___SET_R0(___LBL(24))
   ___JUMPINT(___SET_NARGS(2),___PRC(319),___L_c_23_univ_2d_setup)
___DEF_SLBL(24,___L24__20___t_2d_univ)
   ___SET_R2(___SUB(2))
   ___SET_R1(___SYM(27,___S_php))
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(2),___PRC(319),___L_c_23_univ_2d_setup)
___DEF_SLBL(25,___L25__20___t_2d_univ)
   ___SET_GLO(56,___G_c_23_univ_2d_nb_2d_gvm_2d_regs,___FIX(5L))
   ___SET_GLO(55,___G_c_23_univ_2d_nb_2d_arg_2d_regs,___FIX(3L))
   ___SET_GLO(38,___G_c_23_univ_2d_frame_2d_reserve,___FIX(3L))
   ___SET_GLO(37,___G_c_23_univ_2d_frame_2d_alignment,___FIX(4L))
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),149,___G_make_2d_table)
___DEF_SLBL(26,___L26__20___t_2d_univ)
   ___SET_GLO(61,___G_c_23_univ_2d_prim_2d_proc_2d_table,___R1)
   ___SET_STK(-2,___GLO(113,___G_c_23_prim_2d_procs))
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(30))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L32__20___t_2d_univ)
   ___END_IF
   ___GOTO(___L33__20___t_2d_univ)
___DEF_SLBL(27,___L27__20___t_2d_univ)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(28)
___DEF_SLBL(28,___L28__20___t_2d_univ)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L33__20___t_2d_univ)
   ___END_IF
___DEF_GLBL(___L32__20___t_2d_univ)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(27))
   ___ADJFP(8)
   ___POLL(29)
___DEF_SLBL(29,___L29__20___t_2d_univ)
   ___JUMPINT(___SET_NARGS(1),___PRC(392),___L_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_GLBL(___L33__20___t_2d_univ)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(30,___L30__20___t_2d_univ)
   ___SET_R1(___VOID)
   ___POLL(31)
___DEF_SLBL(31,___L31__20___t_2d_univ)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_nl
#undef ___PH_LBL0
#define ___PH_LBL0 34
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_nl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_nl)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_nl)
   ___SET_R1(___SUB(3))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_open_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 36
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_open_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_open_2d_comment)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_js_2d_open_2d_comment)
   ___SET_R1(___SUB(4))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_end_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 38
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_end_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_end_2d_comment)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_js_2d_end_2d_comment)
   ___SET_R1(___SUB(5))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 40
#undef ___PD_ALL
#define ___PD_ALL ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_R0
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_string)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_string)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_label
#undef ___PH_LBL0
#define ___PH_LBL0 42
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L7_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L8_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L9_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L10_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L11_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L12_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L13_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L14_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L15_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L16_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L17_c_23_js_2d_gen_2d_label)
___DEF_P_HLBL(___L18_c_23_js_2d_gen_2d_label)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_label)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_label)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_label)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),99,___G_c_23_label_2d_lbl_2d_num)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_label)
   ___SET_STK(-4,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_STK(-4,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G_c_23_scheme_2d_id_2d__3e_c_2d_id)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_label)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(6))
   ___ADD_VECTOR_ELEM(1,___STK(-4))
   ___ADD_VECTOR_ELEM(2,___SUB(7))
   ___ADD_VECTOR_ELEM(3,___R1)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_label)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),100,___G_c_23_label_2d_type)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_label)
   ___IF(___NOT(___EQP(___R1,___SYM(32,___S_simple))))
   ___GOTO(___L20_c_23_js_2d_gen_2d_label)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___SUB(8))
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_label)
   ___GOTO(___L19_c_23_js_2d_gen_2d_label)
___DEF_SLBL(7,___L7_c_23_js_2d_gen_2d_label)
___DEF_GLBL(___L19_c_23_js_2d_gen_2d_label)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),88,___G_c_23_gvm_2d_instr_2d_frame)
___DEF_SLBL(8,___L8_c_23_js_2d_gen_2d_label)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),85,___G_c_23_frame_2d_size)
___DEF_SLBL(9,___L9_c_23_js_2d_gen_2d_label)
   ___SET_R2(___FIXNEG(___R1))
   ___SET_R1(___STK(-6))
   ___SET_R3(___SUB(9))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(3),___PRC(168),___L_c_23_js_2d_sp_2d_adjust)
___DEF_SLBL(10,___L10_c_23_js_2d_gen_2d_label)
   ___BEGIN_ALLOC_VECTOR(6)
   ___ADD_VECTOR_ELEM(0,___SUB(10))
   ___ADD_VECTOR_ELEM(1,___SUB(11))
   ___ADD_VECTOR_ELEM(2,___STK(-4))
   ___ADD_VECTOR_ELEM(3,___SUB(12))
   ___ADD_VECTOR_ELEM(4,___STK(-3))
   ___ADD_VECTOR_ELEM(5,___R1)
   ___END_ALLOC_VECTOR(6)
   ___SET_R1(___GET_VECTOR(6))
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_js_2d_gen_2d_label)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_js_2d_gen_2d_label)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L20_c_23_js_2d_gen_2d_label)
   ___IF(___EQP(___R1,___SYM(6,___S_entry)))
   ___GOTO(___L24_c_23_js_2d_gen_2d_label)
   ___END_IF
   ___IF(___NOT(___EQP(___R1,___SYM(30,___S_return))))
   ___GOTO(___L21_c_23_js_2d_gen_2d_label)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___SUB(13))
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_js_2d_gen_2d_label)
   ___GOTO(___L19_c_23_js_2d_gen_2d_label)
___DEF_GLBL(___L21_c_23_js_2d_gen_2d_label)
   ___IF(___NOT(___EQP(___R1,___SYM(36,___S_task_2d_entry))))
   ___GOTO(___L22_c_23_js_2d_gen_2d_label)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___SUB(14))
   ___ADD_VECTOR_ELEM(1,___SUB(15))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_js_2d_gen_2d_label)
   ___GOTO(___L19_c_23_js_2d_gen_2d_label)
___DEF_GLBL(___L22_c_23_js_2d_gen_2d_label)
   ___IF(___NOT(___EQP(___R1,___SYM(37,___S_task_2d_return))))
   ___GOTO(___L23_c_23_js_2d_gen_2d_label)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___SUB(16))
   ___ADD_VECTOR_ELEM(1,___SUB(17))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15_c_23_js_2d_gen_2d_label)
   ___GOTO(___L19_c_23_js_2d_gen_2d_label)
___DEF_GLBL(___L23_c_23_js_2d_gen_2d_label)
   ___SET_R1(___SUB(18))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),82,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L24_c_23_js_2d_gen_2d_label)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),97,___G_c_23_label_2d_entry_2d_closed_3f_)
___DEF_SLBL(16,___L16_c_23_js_2d_gen_2d_label)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L25_c_23_js_2d_gen_2d_label)
   ___END_IF
   ___SET_R1(___SUB(19))
   ___GOTO(___L26_c_23_js_2d_gen_2d_label)
___DEF_GLBL(___L25_c_23_js_2d_gen_2d_label)
   ___SET_R1(___SUB(20))
___DEF_GLBL(___L26_c_23_js_2d_gen_2d_label)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),98,___G_c_23_label_2d_entry_2d_nb_2d_parms)
___DEF_SLBL(17,___L17_c_23_js_2d_gen_2d_label)
   ___BEGIN_ALLOC_VECTOR(5)
   ___ADD_VECTOR_ELEM(0,___STK(-3))
   ___ADD_VECTOR_ELEM(1,___SUB(21))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(22))
   ___ADD_VECTOR_ELEM(4,___SUB(23))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___CHECK_HEAP(18,4096)
___DEF_SLBL(18,___L18_c_23_js_2d_gen_2d_label)
   ___GOTO(___L19_c_23_js_2d_gen_2d_label)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_apply
#undef ___PH_LBL0
#define ___PH_LBL0 62
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L7_c_23_js_2d_gen_2d_apply)
___DEF_P_HLBL(___L8_c_23_js_2d_gen_2d_apply)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_apply)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_apply)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_apply)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),70,___G_c_23_apply_2d_loc)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_apply)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),72,___G_c_23_apply_2d_prim)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_apply)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),71,___G_c_23_apply_2d_opnds)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_apply)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_apply)
   ___SET_STK(-4,___R1)
   ___SET_STK(1,___STK(-6))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FAL)
   ___SET_R0(___LBL(6))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(194),___L_c_23_js_2d_prim_2d_applic)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_apply)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___STK(-4))
   ___ADD_VECTOR_ELEM(1,___SUB(24))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(25))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_js_2d_gen_2d_apply)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_js_2d_gen_2d_apply)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_copy
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L7_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L8_c_23_js_2d_gen_2d_copy)
___DEF_P_HLBL(___L9_c_23_js_2d_gen_2d_copy)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_copy)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_copy)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_copy)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),83,___G_c_23_copy_2d_loc)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_copy)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),84,___G_c_23_copy_2d_opnd)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_copy)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L11_c_23_js_2d_gen_2d_copy)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___SUB(26))
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_copy)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_copy)
   ___GOTO(___L10_c_23_js_2d_gen_2d_copy)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_copy)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___STK(-4))
   ___ADD_VECTOR_ELEM(1,___SUB(27))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(28))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_js_2d_gen_2d_copy)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_js_2d_gen_2d_copy)
___DEF_GLBL(___L10_c_23_js_2d_gen_2d_copy)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L11_c_23_js_2d_gen_2d_copy)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(9,___L9_c_23_js_2d_gen_2d_copy)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_close
#undef ___PH_LBL0
#define ___PH_LBL0 83
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_close)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_close)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_close)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_close)
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___SUB(29))
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_close)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_ifjump
#undef ___PH_LBL0
#define ___PH_LBL0 86
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L7_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L8_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L9_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L10_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L11_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L12_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L13_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L14_c_23_js_2d_gen_2d_ifjump)
___DEF_P_HLBL(___L15_c_23_js_2d_gen_2d_ifjump)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_ifjump)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_ifjump)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),92,___G_c_23_ifjump_2d_test)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),91,___G_c_23_ifjump_2d_opnds)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),93,___G_c_23_ifjump_2d_true)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),90,___G_c_23_ifjump_2d_false)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),88,___G_c_23_gvm_2d_instr_2d_frame)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_ifjump)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),85,___G_c_23_frame_2d_size)
___DEF_SLBL(7,___L7_c_23_js_2d_gen_2d_ifjump)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-10))
   ___SET_R3(___SUB(30))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(3),___PRC(168),___L_c_23_js_2d_sp_2d_adjust)
___DEF_SLBL(8,___L8_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-9,___R1)
   ___SET_STK(1,___STK(-10))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R3(___TRU)
   ___SET_R0(___LBL(9))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(194),___L_c_23_js_2d_prim_2d_applic)
___DEF_SLBL(9,___L9_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-8,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),104,___G_c_23_make_2d_lbl)
___DEF_SLBL(10,___L10_c_23_js_2d_gen_2d_ifjump)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(11,___L11_c_23_js_2d_gen_2d_ifjump)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(12))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),104,___G_c_23_make_2d_lbl)
___DEF_SLBL(12,___L12_c_23_js_2d_gen_2d_ifjump)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(13,___L13_c_23_js_2d_gen_2d_ifjump)
   ___BEGIN_ALLOC_VECTOR(15)
   ___ADD_VECTOR_ELEM(0,___SUB(31))
   ___ADD_VECTOR_ELEM(1,___STK(-4))
   ___ADD_VECTOR_ELEM(2,___SUB(32))
   ___ADD_VECTOR_ELEM(3,___SUB(33))
   ___ADD_VECTOR_ELEM(4,___STK(-5))
   ___ADD_VECTOR_ELEM(5,___SUB(34))
   ___ADD_VECTOR_ELEM(6,___STK(-3))
   ___ADD_VECTOR_ELEM(7,___SUB(35))
   ___ADD_VECTOR_ELEM(8,___SUB(36))
   ___ADD_VECTOR_ELEM(9,___SUB(37))
   ___ADD_VECTOR_ELEM(10,___STK(-5))
   ___ADD_VECTOR_ELEM(11,___SUB(38))
   ___ADD_VECTOR_ELEM(12,___R1)
   ___ADD_VECTOR_ELEM(13,___SUB(39))
   ___ADD_VECTOR_ELEM(14,___SUB(40))
   ___END_ALLOC_VECTOR(15)
   ___SET_R1(___GET_VECTOR(15))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_js_2d_gen_2d_ifjump)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_js_2d_gen_2d_ifjump)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_switch
#undef ___PH_LBL0
#define ___PH_LBL0 103
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_switch)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_switch)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_switch)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_switch)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___SUB(41))
   ___ADD_VECTOR_ELEM(1,___SUB(42))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_switch)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_jump
#undef ___PH_LBL0
#define ___PH_LBL0 106
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L7_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L8_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L9_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L10_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L11_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L12_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L13_c_23_js_2d_gen_2d_jump)
___DEF_P_HLBL(___L14_c_23_js_2d_gen_2d_jump)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_jump)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_jump)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_jump)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),94,___G_c_23_jump_2d_nb_2d_args)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_jump)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L15_c_23_js_2d_gen_2d_jump)
   ___END_IF
   ___SET_R1(___SUB(43))
   ___GOTO(___L16_c_23_js_2d_gen_2d_jump)
___DEF_GLBL(___L15_c_23_js_2d_gen_2d_jump)
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___SUB(44))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___SUB(45))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_jump)
___DEF_GLBL(___L16_c_23_js_2d_gen_2d_jump)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),88,___G_c_23_gvm_2d_instr_2d_frame)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_jump)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),85,___G_c_23_frame_2d_size)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_jump)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R3(___SUB(46))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(3),___PRC(168),___L_c_23_js_2d_sp_2d_adjust)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_jump)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),95,___G_c_23_jump_2d_opnd)
___DEF_SLBL(7,___L7_c_23_js_2d_gen_2d_jump)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),96,___G_c_23_jump_2d_poll_3f_)
___DEF_SLBL(8,___L8_c_23_js_2d_gen_2d_jump)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L18_c_23_js_2d_gen_2d_jump)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(9))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(9,___L9_c_23_js_2d_gen_2d_jump)
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___SUB(47))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___SUB(48))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_js_2d_gen_2d_jump)
   ___GOTO(___L17_c_23_js_2d_gen_2d_jump)
___DEF_SLBL(11,___L11_c_23_js_2d_gen_2d_jump)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(49))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___SUB(50))
   ___ADD_VECTOR_ELEM(3,___SUB(51))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(12,4096)
___DEF_SLBL(12,___L12_c_23_js_2d_gen_2d_jump)
___DEF_GLBL(___L17_c_23_js_2d_gen_2d_jump)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___STK(-4))
   ___ADD_VECTOR_ELEM(1,___STK(-3))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(52))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_js_2d_gen_2d_jump)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_js_2d_gen_2d_jump)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L18_c_23_js_2d_gen_2d_jump)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(11))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_reg
#undef ___PH_LBL0
#define ___PH_LBL0 122
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_reg)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_reg)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_reg)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_reg)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_reg)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_reg)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_reg)
   ___SET_STK(1,___R0)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_reg)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G_c_23_reg_2d_num)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_reg)
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___SUB(53))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___SUB(54))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_reg)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_reg)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_stk
#undef ___PH_LBL0
#define ___PH_LBL0 128
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_stk)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_stk)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_stk)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_stk)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_stk)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_stk)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_stk)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_stk)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_stk)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),126,___G_c_23_stk_2d_num)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_stk)
   ___IF(___NOT(___FIXLT(___R1,___FIX(0L))))
   ___GOTO(___L6_c_23_js_2d_gen_2d_stk)
   ___END_IF
   ___SET_R1(___SUB(55))
   ___GOTO(___L7_c_23_js_2d_gen_2d_stk)
___DEF_GLBL(___L6_c_23_js_2d_gen_2d_stk)
   ___SET_R1(___SUB(56))
___DEF_GLBL(___L7_c_23_js_2d_gen_2d_stk)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),126,___G_c_23_stk_2d_num)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_stk)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(57))
   ___ADD_VECTOR_ELEM(1,___STK(-5))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(58))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_stk)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_stk)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_glo
#undef ___PH_LBL0
#define ___PH_LBL0 135
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_glo)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_glo)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_glo)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_glo)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_glo)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_glo)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_glo)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_glo)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_glo)
   ___SET_STK(1,___R0)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_glo)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),86,___G_c_23_glo_2d_name)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_glo)
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM(154,___G_symbol_2d__3e_string))
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_glo)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),150,___G_object_2d__3e_string)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_glo)
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___SUB(59))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___SUB(60))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_glo)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_glo)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_clo
#undef ___PH_LBL0
#define ___PH_LBL0 143
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_clo)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_clo)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_clo)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_clo)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_clo)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_clo)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_clo)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_clo)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_clo)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_clo)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),75,___G_c_23_clo_2d_base)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_clo)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_clo)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),76,___G_c_23_clo_2d_index)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_clo)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___STK(-5))
   ___ADD_VECTOR_ELEM(1,___SUB(61))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(62))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_clo)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_clo)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_gen_2d_obj
#undef ___PH_LBL0
#define ___PH_LBL0 151
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L1_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L2_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L3_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L4_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L5_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L6_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L7_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L8_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L9_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L10_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L11_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L12_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L13_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L14_c_23_js_2d_gen_2d_obj)
___DEF_P_HLBL(___L15_c_23_js_2d_gen_2d_obj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_gen_2d_obj)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_gen_2d_obj)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_gen_2d_obj)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),111,___G_c_23_obj_2d_val)
___DEF_SLBL(2,___L2_c_23_js_2d_gen_2d_obj)
   ___IF(___NOT(___NUMBERP(___R1)))
   ___GOTO(___L20_c_23_js_2d_gen_2d_obj)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_js_2d_gen_2d_obj)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_js_2d_gen_2d_obj)
   ___GOTO(___L16_c_23_js_2d_gen_2d_obj)
___DEF_SLBL(5,___L5_c_23_js_2d_gen_2d_obj)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L17_c_23_js_2d_gen_2d_obj)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___SUB(63))
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_js_2d_gen_2d_obj)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_js_2d_gen_2d_obj)
___DEF_GLBL(___L16_c_23_js_2d_gen_2d_obj)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L17_c_23_js_2d_gen_2d_obj)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),117,___G_c_23_proc_2d_obj_3f_)
___DEF_SLBL(8,___L8_c_23_js_2d_gen_2d_obj)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L19_c_23_js_2d_gen_2d_obj)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(9))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),150,___G_object_2d__3e_string)
___DEF_SLBL(9,___L9_c_23_js_2d_gen_2d_obj)
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___SUB(64))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___SUB(65))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_js_2d_gen_2d_obj)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_js_2d_gen_2d_obj)
   ___GOTO(___L18_c_23_js_2d_gen_2d_obj)
___DEF_SLBL(12,___L12_c_23_js_2d_gen_2d_obj)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(6))
   ___ADD_VECTOR_ELEM(1,___FIX(1L))
   ___ADD_VECTOR_ELEM(2,___SUB(7))
   ___ADD_VECTOR_ELEM(3,___R1)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_js_2d_gen_2d_obj)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_js_2d_gen_2d_obj)
___DEF_GLBL(___L18_c_23_js_2d_gen_2d_obj)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L19_c_23_js_2d_gen_2d_obj)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(15))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_c_23_proc_2d_obj_2d_name)
___DEF_SLBL(15,___L15_c_23_js_2d_gen_2d_obj)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G_c_23_scheme_2d_id_2d__3e_c_2d_id)
___DEF_GLBL(___L20_c_23_js_2d_gen_2d_obj)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),146,___G_c_23_void_2d_object_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_sp_2d_adjust
#undef ___PH_LBL0
#define ___PH_LBL0 168
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_sp_2d_adjust)
___DEF_P_HLBL(___L1_c_23_js_2d_sp_2d_adjust)
___DEF_P_HLBL(___L2_c_23_js_2d_sp_2d_adjust)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_sp_2d_adjust)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_js_2d_sp_2d_adjust)
   ___IF(___NOT(___FIXEQ(___R2,___FIX(0L))))
   ___GOTO(___L3_c_23_js_2d_sp_2d_adjust)
   ___END_IF
   ___BEGIN_ALLOC_VECTOR(1)
   ___ADD_VECTOR_ELEM(0,___SUB(66))
   ___END_ALLOC_VECTOR(1)
   ___SET_R1(___GET_VECTOR(1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_js_2d_sp_2d_adjust)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L3_c_23_js_2d_sp_2d_adjust)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(67))
   ___ADD_VECTOR_ELEM(1,___R2)
   ___ADD_VECTOR_ELEM(2,___SUB(68))
   ___ADD_VECTOR_ELEM(3,___R3)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_js_2d_sp_2d_adjust)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_translate_2d_lbl
#undef ___PH_LBL0
#define ___PH_LBL0 172
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_translate_2d_lbl)
___DEF_P_HLBL(___L1_c_23_js_2d_translate_2d_lbl)
___DEF_P_HLBL(___L2_c_23_js_2d_translate_2d_lbl)
___DEF_P_HLBL(___L3_c_23_js_2d_translate_2d_lbl)
___DEF_P_HLBL(___L4_c_23_js_2d_translate_2d_lbl)
___DEF_P_HLBL(___L5_c_23_js_2d_translate_2d_lbl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_translate_2d_lbl)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_translate_2d_lbl)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_translate_2d_lbl)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),101,___G_c_23_lbl_2d_num)
___DEF_SLBL(2,___L2_c_23_js_2d_translate_2d_lbl)
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_STK(-6,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G_c_23_scheme_2d_id_2d__3e_c_2d_id)
___DEF_SLBL(3,___L3_c_23_js_2d_translate_2d_lbl)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(6))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___SUB(7))
   ___ADD_VECTOR_ELEM(3,___R1)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_js_2d_translate_2d_lbl)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_js_2d_translate_2d_lbl)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_lbl_2d__3e_id
#undef ___PH_LBL0
#define ___PH_LBL0 179
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_lbl_2d__3e_id)
___DEF_P_HLBL(___L1_c_23_js_2d_lbl_2d__3e_id)
___DEF_P_HLBL(___L2_c_23_js_2d_lbl_2d__3e_id)
___DEF_P_HLBL(___L3_c_23_js_2d_lbl_2d__3e_id)
___DEF_P_HLBL(___L4_c_23_js_2d_lbl_2d__3e_id)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_lbl_2d__3e_id)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_js_2d_lbl_2d__3e_id)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_lbl_2d__3e_id)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G_c_23_scheme_2d_id_2d__3e_c_2d_id)
___DEF_SLBL(2,___L2_c_23_js_2d_lbl_2d__3e_id)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(6))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___SUB(7))
   ___ADD_VECTOR_ELEM(3,___R1)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_js_2d_lbl_2d__3e_id)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_js_2d_lbl_2d__3e_id)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_entry_2d_point
#undef ___PH_LBL0
#define ___PH_LBL0 185
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_entry_2d_point)
___DEF_P_HLBL(___L1_c_23_js_2d_entry_2d_point)
___DEF_P_HLBL(___L2_c_23_js_2d_entry_2d_point)
___DEF_P_HLBL(___L3_c_23_js_2d_entry_2d_point)
___DEF_P_HLBL(___L4_c_23_js_2d_entry_2d_point)
___DEF_P_HLBL(___L5_c_23_js_2d_entry_2d_point)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_entry_2d_point)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_js_2d_entry_2d_point)
   ___SET_STK(1,___R0)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_entry_2d_point)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_c_23_proc_2d_obj_2d_name)
___DEF_SLBL(2,___L2_c_23_js_2d_entry_2d_point)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G_c_23_scheme_2d_id_2d__3e_c_2d_id)
___DEF_SLBL(3,___L3_c_23_js_2d_entry_2d_point)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(6))
   ___ADD_VECTOR_ELEM(1,___FIX(1L))
   ___ADD_VECTOR_ELEM(2,___SUB(7))
   ___ADD_VECTOR_ELEM(3,___R1)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___SUB(69))
   ___ADD_VECTOR_ELEM(1,___SUB(70))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___SUB(71))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_js_2d_entry_2d_point)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_js_2d_entry_2d_point)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_runtime_2d_system
#undef ___PH_LBL0
#define ___PH_LBL0 192
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_runtime_2d_system)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_runtime_2d_system)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_js_2d_runtime_2d_system)
   ___SET_R1(___SUB(72))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_js_2d_prim_2d_applic
#undef ___PH_LBL0
#define ___PH_LBL0 194
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L1_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L2_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L3_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L4_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L5_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L6_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L7_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L8_c_23_js_2d_prim_2d_applic)
___DEF_P_HLBL(___L9_c_23_js_2d_prim_2d_applic)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_js_2d_prim_2d_applic)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_js_2d_prim_2d_applic)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_js_2d_prim_2d_applic)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_c_23_proc_2d_obj_2d_name)
___DEF_SLBL(2,___L2_c_23_js_2d_prim_2d_applic)
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM(153,___G_string_2d__3e_symbol))
___DEF_SLBL(3,___L3_c_23_js_2d_prim_2d_applic)
   ___IF(___NOT(___EQP(___R1,___SYM(0,___S__23__23_not))))
   ___GOTO(___L10_c_23_js_2d_prim_2d_applic)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(2),___PRM(148,___G_list_2d_ref))
___DEF_SLBL(4,___L4_c_23_js_2d_prim_2d_applic)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(539),___L_c_23_translate_2d_gvm_2d_opnd)
___DEF_SLBL(5,___L5_c_23_js_2d_prim_2d_applic)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___SUB(73))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_js_2d_prim_2d_applic)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_js_2d_prim_2d_applic)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L10_c_23_js_2d_prim_2d_applic)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_c_23_proc_2d_obj_2d_name)
___DEF_SLBL(8,___L8_c_23_js_2d_prim_2d_applic)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(74))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_js_2d_prim_2d_applic)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),82,___G_c_23_compiler_2d_internal_2d_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_target_2d_fun
#undef ___PH_LBL0
#define ___PH_LBL0 205
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_target_2d_fun)
___DEF_P_HLBL(___L1_c_23_add_2d_target_2d_fun)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_target_2d_fun)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_add_2d_target_2d_fun)
   ___BEGIN_ALLOC_LIST(2,___R2)
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R1(___CONS(___R1,___R3))
   ___SET_R1(___CONS(___R1,___GLO(66,___G_c_23_univ_2d_to_2d_target)))
   ___SET_GLO(66,___G_c_23_univ_2d_to_2d_target,___R1)
   ___SET_R1(___VOID)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_add_2d_target_2d_fun)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_get_2d_target_2d_fun
#undef ___PH_LBL0
#define ___PH_LBL0 208
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_get_2d_target_2d_fun)
___DEF_P_HLBL(___L1_c_23_get_2d_target_2d_fun)
___DEF_P_HLBL(___L2_c_23_get_2d_target_2d_fun)
___DEF_P_HLBL(___L3_c_23_get_2d_target_2d_fun)
___DEF_P_HLBL(___L4_c_23_get_2d_target_2d_fun)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_get_2d_target_2d_fun)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_get_2d_target_2d_fun)
   ___SET_STK(1,___R0)
   ___BEGIN_ALLOC_LIST(2,___R2)
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___GLO(66,___G_c_23_univ_2d_to_2d_target))
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_get_2d_target_2d_fun)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_get_2d_target_2d_fun)
   ___JUMPPRM(___SET_NARGS(2),___PRM(69,___G_assoc))
___DEF_SLBL(3,___L3_c_23_get_2d_target_2d_fun)
   ___SET_R1(___CDR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_get_2d_target_2d_fun)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_nl
#undef ___PH_LBL0
#define ___PH_LBL0 214
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_nl)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_nl)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_nl)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_nl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_nl)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_nl)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(16,___S_gen_2d_nl))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_nl)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_nl)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_nl)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_open_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 219
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_open_2d_comment)
___DEF_P_HLBL(___L1_c_23_univ_2d_open_2d_comment)
___DEF_P_HLBL(___L2_c_23_univ_2d_open_2d_comment)
___DEF_P_HLBL(___L3_c_23_univ_2d_open_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_open_2d_comment)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_univ_2d_open_2d_comment)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(26,___S_open_2d_comment))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_open_2d_comment)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_open_2d_comment)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_open_2d_comment)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_end_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 224
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_end_2d_comment)
___DEF_P_HLBL(___L1_c_23_univ_2d_end_2d_comment)
___DEF_P_HLBL(___L2_c_23_univ_2d_end_2d_comment)
___DEF_P_HLBL(___L3_c_23_univ_2d_end_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_end_2d_comment)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_univ_2d_end_2d_comment)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(5,___S_end_2d_comment))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_end_2d_comment)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_end_2d_comment)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_end_2d_comment)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 229
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_string)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_string)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_string)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_string)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_string)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(20,___S_gen_2d_string))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_string)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_string)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_string)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_sp_2d_adjust
#undef ___PH_LBL0
#define ___PH_LBL0 234
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_sp_2d_adjust)
___DEF_P_HLBL(___L1_c_23_univ_2d_sp_2d_adjust)
___DEF_P_HLBL(___L2_c_23_univ_2d_sp_2d_adjust)
___DEF_P_HLBL(___L3_c_23_univ_2d_sp_2d_adjust)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_sp_2d_adjust)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_univ_2d_sp_2d_adjust)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___STK(0))
   ___SET_R1(___SYM(33,___S_sp_2d_adjust))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_sp_2d_adjust)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_sp_2d_adjust)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_sp_2d_adjust)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_translate_2d_lbl
#undef ___PH_LBL0
#define ___PH_LBL0 239
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_translate_2d_lbl)
___DEF_P_HLBL(___L1_c_23_univ_2d_translate_2d_lbl)
___DEF_P_HLBL(___L2_c_23_univ_2d_translate_2d_lbl)
___DEF_P_HLBL(___L3_c_23_univ_2d_translate_2d_lbl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_translate_2d_lbl)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_translate_2d_lbl)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(38,___S_translate_2d_lbl))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_translate_2d_lbl)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_translate_2d_lbl)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_translate_2d_lbl)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_entry_2d_point
#undef ___PH_LBL0
#define ___PH_LBL0 244
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_entry_2d_point)
___DEF_P_HLBL(___L1_c_23_univ_2d_entry_2d_point)
___DEF_P_HLBL(___L2_c_23_univ_2d_entry_2d_point)
___DEF_P_HLBL(___L3_c_23_univ_2d_entry_2d_point)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_entry_2d_point)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_entry_2d_point)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(7,___S_entry_2d_point))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_entry_2d_point)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_entry_2d_point)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_entry_2d_point)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_runtime_2d_system
#undef ___PH_LBL0
#define ___PH_LBL0 249
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_runtime_2d_system)
___DEF_P_HLBL(___L1_c_23_univ_2d_runtime_2d_system)
___DEF_P_HLBL(___L2_c_23_univ_2d_runtime_2d_system)
___DEF_P_HLBL(___L3_c_23_univ_2d_runtime_2d_system)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_runtime_2d_system)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_univ_2d_runtime_2d_system)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(31,___S_runtime_2d_system))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_runtime_2d_system)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_runtime_2d_system)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_runtime_2d_system)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_prim_2d_applic
#undef ___PH_LBL0
#define ___PH_LBL0 254
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_prim_2d_applic)
___DEF_P_HLBL(___L1_c_23_univ_2d_prim_2d_applic)
___DEF_P_HLBL(___L2_c_23_univ_2d_prim_2d_applic)
___DEF_P_HLBL(___L3_c_23_univ_2d_prim_2d_applic)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_prim_2d_applic)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_univ_2d_prim_2d_applic)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(28,___S_prim_2d_applic))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_prim_2d_applic)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_prim_2d_applic)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_prim_2d_applic)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_label_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 259
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_label_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_label_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_label_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_label_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(15,___S_gen_2d_label))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_label_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_label_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_label_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_apply_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 264
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_apply_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_apply_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_apply_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(8,___S_gen_2d_apply))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_apply_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_apply_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_apply_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_copy_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 269
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_copy_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_copy_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_copy_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(11,___S_gen_2d_copy))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_copy_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_copy_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_copy_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_close_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 274
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_close_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_close_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_close_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(10,___S_gen_2d_close))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_close_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_close_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_close_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_ifjump_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 279
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_ifjump_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_ifjump_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(13,___S_gen_2d_ifjump))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_ifjump_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_ifjump_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_ifjump_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_switch_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 284
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_switch_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_switch_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_switch_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(21,___S_gen_2d_switch))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_switch_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_switch_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_switch_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_jump_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 289
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_jump_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_jump_2d_instr)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_jump_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(14,___S_gen_2d_jump))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_jump_2d_instr)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_jump_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_jump_2d_instr)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_reg_2d_opnd
#undef ___PH_LBL0
#define ___PH_LBL0 294
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_reg_2d_opnd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_reg_2d_opnd)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_reg_2d_opnd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(18,___S_gen_2d_reg))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_reg_2d_opnd)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_reg_2d_opnd)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_reg_2d_opnd)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_stk_2d_opnd
#undef ___PH_LBL0
#define ___PH_LBL0 299
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_stk_2d_opnd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_stk_2d_opnd)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_stk_2d_opnd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(19,___S_gen_2d_stk))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_stk_2d_opnd)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_stk_2d_opnd)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_stk_2d_opnd)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_glo_2d_opnd
#undef ___PH_LBL0
#define ___PH_LBL0 304
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_glo_2d_opnd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_glo_2d_opnd)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_glo_2d_opnd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(12,___S_gen_2d_glo))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_glo_2d_opnd)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_glo_2d_opnd)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_glo_2d_opnd)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_clo_2d_opnd
#undef ___PH_LBL0
#define ___PH_LBL0 309
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_clo_2d_opnd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_clo_2d_opnd)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_clo_2d_opnd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(9,___S_gen_2d_clo))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_clo_2d_opnd)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_clo_2d_opnd)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_clo_2d_opnd)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_gen_2d_obj_2d_opnd
#undef ___PH_LBL0
#define ___PH_LBL0 314
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_P_HLBL(___L1_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_P_HLBL(___L2_c_23_univ_2d_gen_2d_obj_2d_opnd)
___DEF_P_HLBL(___L3_c_23_univ_2d_gen_2d_obj_2d_opnd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_gen_2d_obj_2d_opnd)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_gen_2d_obj_2d_opnd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(17,___S_gen_2d_obj))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_gen_2d_obj_2d_opnd)
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(2,___L2_c_23_univ_2d_gen_2d_obj_2d_opnd)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_univ_2d_gen_2d_obj_2d_opnd)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_setup
#undef ___PH_LBL0
#define ___PH_LBL0 319
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_setup)
___DEF_P_HLBL(___L1_c_23_univ_2d_setup)
___DEF_P_HLBL(___L2_c_23_univ_2d_setup)
___DEF_P_HLBL(___L3_c_23_univ_2d_setup)
___DEF_P_HLBL(___L4_c_23_univ_2d_setup)
___DEF_P_HLBL(___L5_c_23_univ_2d_setup)
___DEF_P_HLBL(___L6_c_23_univ_2d_setup)
___DEF_P_HLBL(___L7_c_23_univ_2d_setup)
___DEF_P_HLBL(___L8_c_23_univ_2d_setup)
___DEF_P_HLBL(___L9_c_23_univ_2d_setup)
___DEF_P_HLBL(___L10_c_23_univ_2d_setup)
___DEF_P_HLBL(___L11_c_23_univ_2d_setup)
___DEF_P_HLBL(___L12_c_23_univ_2d_setup)
___DEF_P_HLBL(___L13_c_23_univ_2d_setup)
___DEF_P_HLBL(___L14_c_23_univ_2d_setup)
___DEF_P_HLBL(___L15_c_23_univ_2d_setup)
___DEF_P_HLBL(___L16_c_23_univ_2d_setup)
___DEF_P_HLBL(___L17_c_23_univ_2d_setup)
___DEF_P_HLBL(___L18_c_23_univ_2d_setup)
___DEF_P_HLBL(___L19_c_23_univ_2d_setup)
___DEF_P_HLBL(___L20_c_23_univ_2d_setup)
___DEF_P_HLBL(___L21_c_23_univ_2d_setup)
___DEF_P_HLBL(___L22_c_23_univ_2d_setup)
___DEF_P_HLBL(___L23_c_23_univ_2d_setup)
___DEF_P_HLBL(___L24_c_23_univ_2d_setup)
___DEF_P_HLBL(___L25_c_23_univ_2d_setup)
___DEF_P_HLBL(___L26_c_23_univ_2d_setup)
___DEF_P_HLBL(___L27_c_23_univ_2d_setup)
___DEF_P_HLBL(___L28_c_23_univ_2d_setup)
___DEF_P_HLBL(___L29_c_23_univ_2d_setup)
___DEF_P_HLBL(___L30_c_23_univ_2d_setup)
___DEF_P_HLBL(___L31_c_23_univ_2d_setup)
___DEF_P_HLBL(___L32_c_23_univ_2d_setup)
___DEF_P_HLBL(___L33_c_23_univ_2d_setup)
___DEF_P_HLBL(___L34_c_23_univ_2d_setup)
___DEF_P_HLBL(___L35_c_23_univ_2d_setup)
___DEF_P_HLBL(___L36_c_23_univ_2d_setup)
___DEF_P_HLBL(___L37_c_23_univ_2d_setup)
___DEF_P_HLBL(___L38_c_23_univ_2d_setup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_univ_2d_setup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(7L))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_c_23_make_2d_target)
___DEF_SLBL(2,___L2_c_23_univ_2d_setup)
   ___SET_STK(-5,___ALLOC_CLO(2))
   ___BEGIN_SETUP_CLO(2,___STK(-5),8)
   ___ADD_CLO_ELEM(0,___STK(-6))
   ___ADD_CLO_ELEM(1,___R1)
   ___END_SETUP_CLO(2)
   ___SET_STK(-6,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(4))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),133,___G_c_23_target_2d_begin_21__2d_set_21_)
___DEF_SLBL(4,___L4_c_23_univ_2d_setup)
   ___SET_R2(___LBL(7))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),135,___G_c_23_target_2d_end_21__2d_set_21_)
___DEF_SLBL(5,___L5_c_23_univ_2d_setup)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_univ_2d_setup)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),132,___G_c_23_target_2d_add)
___DEF_SLBL(7,___L7_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(7,0,0,0)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(8,___L8_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(8,1,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R4)
   ___SET_STK(3,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(3),37)
   ___ADD_CLO_ELEM(0,___CLO(___R4,2))
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(3))
   ___SET_R1(___CLO(___R4,2))
   ___SET_R0(___LBL(11))
   ___ADJFP(8)
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_univ_2d_setup)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),134,___G_c_23_target_2d_dump_2d_set_21_)
___DEF_SLBL(11,___L11_c_23_univ_2d_setup)
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R2(___FIX(5L))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_c_23_target_2d_nb_2d_regs_2d_set_21_)
___DEF_SLBL(12,___L12_c_23_univ_2d_setup)
   ___SET_STK(-5,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-5),35)
   ___ADD_CLO_ELEM(0,___CLO(___STK(-6),2))
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(14))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),142,___G_c_23_target_2d_prim_2d_info_2d_set_21_)
___DEF_SLBL(14,___L14_c_23_univ_2d_setup)
   ___SET_STK(-5,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-5),33)
   ___ADD_CLO_ELEM(0,___CLO(___STK(-6),2))
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(16))
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),139,___G_c_23_target_2d_label_2d_info_2d_set_21_)
___DEF_SLBL(16,___L16_c_23_univ_2d_setup)
   ___SET_STK(-5,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-5),31)
   ___ADD_CLO_ELEM(0,___CLO(___STK(-6),2))
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(18))
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),138,___G_c_23_target_2d_jump_2d_info_2d_set_21_)
___DEF_SLBL(18,___L18_c_23_univ_2d_setup)
   ___SET_R2(___FIX(4L))
   ___SET_R1(___FIX(3L))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),103,___G_c_23_make_2d_frame_2d_constraints)
___DEF_SLBL(19,___L19_c_23_univ_2d_setup)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_c_23_target_2d_frame_2d_constraints_2d_set_21_)
___DEF_SLBL(20,___L20_c_23_univ_2d_setup)
   ___SET_R1(___FIX(1L))
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_make_2d_reg)
___DEF_SLBL(21,___L21_c_23_univ_2d_setup)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_c_23_target_2d_proc_2d_result_2d_set_21_)
___DEF_SLBL(22,___L22_c_23_univ_2d_setup)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_make_2d_reg)
___DEF_SLBL(23,___L23_c_23_univ_2d_setup)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_c_23_target_2d_task_2d_return_2d_set_21_)
___DEF_SLBL(24,___L24_c_23_univ_2d_setup)
   ___SET_STK(-5,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-5),29)
   ___ADD_CLO_ELEM(0,___CLO(___STK(-6),2))
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(26))
   ___CHECK_HEAP(25,4096)
___DEF_SLBL(25,___L25_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),144,___G_c_23_target_2d_switch_2d_testable_3f__2d_set_21_)
___DEF_SLBL(26,___L26_c_23_univ_2d_setup)
   ___SET_R2(___CLO(___STK(-6),1))
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(27))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_c_23_target_2d_file_2d_extension_2d_set_21_)
___DEF_SLBL(27,___L27_c_23_univ_2d_setup)
   ___SET_R1(___FAL)
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_univ_2d_setup)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(29,___L29_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(29,1,0,0)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23_univ_2d_setup)
   ___JUMPINT(___SET_NARGS(2),___PRC(398),___L_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_SLBL(31,___L31_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(31,1,0,0)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_univ_2d_setup)
   ___JUMPINT(___SET_NARGS(2),___PRC(374),___L_c_23_univ_2d_jump_2d_info)
___DEF_SLBL(33,___L33_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(33,2,0,0)
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(34)
___DEF_SLBL(34,___L34_c_23_univ_2d_setup)
   ___JUMPINT(___SET_NARGS(3),___PRC(359),___L_c_23_univ_2d_label_2d_info)
___DEF_SLBL(35,___L35_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(35,1,0,0)
   ___SET_R2(___R1)
   ___SET_R3(___FAL)
   ___SET_R1(___GLO(61,___G_c_23_univ_2d_prim_2d_proc_2d_table))
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_univ_2d_setup)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),155,___G_table_2d_ref)
___DEF_SLBL(37,___L37_c_23_univ_2d_setup)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(37,5,0,0)
   ___SET_STK(1,___STK(-1))
   ___SET_STK(-1,___CLO(___R4,1))
   ___SET_STK(2,___STK(0))
   ___SET_STK(0,___STK(1))
   ___SET_STK(1,___STK(2))
   ___ADJFP(2)
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_univ_2d_setup)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(6),___PRC(404),___L_c_23_univ_2d_dump)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_label_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 359
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L1_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L2_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L3_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L4_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L5_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L6_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L7_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L8_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L9_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L10_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L11_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L12_c_23_univ_2d_label_2d_info)
___DEF_P_HLBL(___L13_c_23_univ_2d_label_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_label_2d_info)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_label_2d_info)
   ___SET_R1(___FIXSUB(___R2,___FIX(3L)))
   ___SET_R1(___FIXMAX(___FIX(0L),___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(4))
   ___SET_R3(___FIX(1L))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_label_2d_info)
   ___IF(___FIXGT(___R3,___R1))
   ___GOTO(___L16_c_23_univ_2d_label_2d_info)
   ___END_IF
   ___GOTO(___L14_c_23_univ_2d_label_2d_info)
___DEF_SLBL(2,___L2_c_23_univ_2d_label_2d_info)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___SET_STK(-3,___R1)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_univ_2d_label_2d_info)
   ___IF(___FIXGT(___R3,___R1))
   ___GOTO(___L16_c_23_univ_2d_label_2d_info)
   ___END_IF
___DEF_GLBL(___L14_c_23_univ_2d_label_2d_info)
   ___IF(___NOT(___FIXGT(___R3,___R2)))
   ___GOTO(___L15_c_23_univ_2d_label_2d_info)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIXSUB(___R3,___R2))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_univ_2d_label_2d_info)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_make_2d_reg)
___DEF_GLBL(___L15_c_23_univ_2d_label_2d_info)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_univ_2d_label_2d_info)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),109,___G_c_23_make_2d_stk)
___DEF_GLBL(___L16_c_23_univ_2d_label_2d_info)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_univ_2d_label_2d_info)
   ___SET_R1(___CONS(___STK(-3),___R1))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_univ_2d_label_2d_info)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_univ_2d_label_2d_info)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(9,___L9_c_23_univ_2d_label_2d_info)
   ___SET_R2(___CONS(___SYM(30,___S_return),___FIX(0L)))
   ___SET_R1(___CONS(___R2,___R1))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_univ_2d_label_2d_info)
   ___IF(___FALSEP(___STK(-5)))
   ___GOTO(___L17_c_23_univ_2d_label_2d_info)
   ___END_IF
   ___GOTO(___L18_c_23_univ_2d_label_2d_info)
___DEF_SLBL(11,___L11_c_23_univ_2d_label_2d_info)
   ___SET_R1(___CONS(___SYM(3,___S_closure_2d_env),___R1))
   ___SET_R1(___CONS(___R1,___STK(-5)))
   ___CHECK_HEAP(12,4096)
___DEF_SLBL(12,___L12_c_23_univ_2d_label_2d_info)
___DEF_GLBL(___L17_c_23_univ_2d_label_2d_info)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_univ_2d_label_2d_info)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),106,___G_c_23_make_2d_pcontext)
___DEF_GLBL(___L18_c_23_univ_2d_label_2d_info)
   ___SET_STK(-5,___R1)
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_make_2d_reg)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_jump_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 374
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L1_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L2_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L3_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L4_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L5_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L6_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L7_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L8_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L9_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L10_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L11_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L12_c_23_univ_2d_jump_2d_info)
___DEF_P_HLBL(___L13_c_23_univ_2d_jump_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_jump_2d_info)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_univ_2d_jump_2d_info)
   ___SET_R1(___FIXSUB(___R2,___FIX(3L)))
   ___SET_R1(___FIXMAX(___FIX(0L),___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_jump_2d_info)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_make_2d_reg)
___DEF_SLBL(2,___L2_c_23_univ_2d_jump_2d_info)
   ___SET_R1(___CONS(___SYM(30,___S_return),___R1))
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R3(___FIX(1L))
   ___SET_R0(___LBL(11))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_univ_2d_jump_2d_info)
   ___IF(___FIXGT(___R3,___R1))
   ___GOTO(___L16_c_23_univ_2d_jump_2d_info)
   ___END_IF
   ___GOTO(___L14_c_23_univ_2d_jump_2d_info)
___DEF_SLBL(4,___L4_c_23_univ_2d_jump_2d_info)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___SET_STK(-3,___R1)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_univ_2d_jump_2d_info)
   ___IF(___FIXGT(___R3,___R1))
   ___GOTO(___L16_c_23_univ_2d_jump_2d_info)
   ___END_IF
___DEF_GLBL(___L14_c_23_univ_2d_jump_2d_info)
   ___IF(___NOT(___FIXGT(___R3,___R2)))
   ___GOTO(___L15_c_23_univ_2d_jump_2d_info)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIXSUB(___R3,___R2))
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_univ_2d_jump_2d_info)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_make_2d_reg)
___DEF_GLBL(___L15_c_23_univ_2d_jump_2d_info)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_univ_2d_jump_2d_info)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),109,___G_c_23_make_2d_stk)
___DEF_GLBL(___L16_c_23_univ_2d_jump_2d_info)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(8,___L8_c_23_univ_2d_jump_2d_info)
   ___SET_R1(___CONS(___STK(-3),___R1))
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_univ_2d_jump_2d_info)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_univ_2d_jump_2d_info)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(11,___L11_c_23_univ_2d_jump_2d_info)
   ___SET_R2(___CONS(___STK(-4),___R1))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___CHECK_HEAP(12,4096)
___DEF_SLBL(12,___L12_c_23_univ_2d_jump_2d_info)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_univ_2d_jump_2d_info)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),106,___G_c_23_make_2d_pcontext)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_prim_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 389
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_prim_2d_info)
___DEF_P_HLBL(___L1_c_23_univ_2d_prim_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_prim_2d_info)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_univ_2d_prim_2d_info)
   ___SET_R3(___FAL)
   ___SET_R1(___GLO(61,___G_c_23_univ_2d_prim_2d_proc_2d_table))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_prim_2d_info)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),155,___G_table_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_prim_2d_proc_2d_add_21_
#undef ___PH_LBL0
#define ___PH_LBL0 392
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_P_HLBL(___L1_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_P_HLBL(___L2_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_P_HLBL(___L3_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___DEF_P_HLBL(___L4_c_23_univ_2d_prim_2d_proc_2d_add_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_prim_2d_proc_2d_add_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_univ_2d_prim_2d_proc_2d_add_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_prim_2d_proc_2d_add_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),128,___G_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_SLBL(2,___L2_c_23_univ_2d_prim_2d_proc_2d_add_21_)
   ___SET_STK(-5,___R1)
   ___SET_STK(1,___GLO(107,___G_c_23_make_2d_proc_2d_obj))
   ___SET_STK(2,___CAR(___STK(-6)))
   ___SET_STK(3,___FAL)
   ___SET_R3(___CDR(___STK(-6)))
   ___SET_R2(___FAL)
   ___SET_R1(___TRU)
   ___SET_R0(___LBL(3))
   ___ADJFP(3)
   ___JUMPPRM(___SET_NARGS(6),___PRM(68,___G_apply))
___DEF_SLBL(3,___L3_c_23_univ_2d_prim_2d_proc_2d_add_21_)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___GLO(61,___G_c_23_univ_2d_prim_2d_proc_2d_table))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_univ_2d_prim_2d_proc_2d_add_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),156,___G_table_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_switch_2d_testable_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 398
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_P_HLBL(___L1_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_P_HLBL(___L2_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_P_HLBL(___L3_c_23_univ_2d_switch_2d_testable_3f_)
___DEF_P_HLBL(___L4_c_23_univ_2d_switch_2d_testable_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_switch_2d_testable_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_univ_2d_switch_2d_testable_3f_)
   ___SET_STK(1,___R0)
   ___BEGIN_ALLOC_LIST(3,___R2)
   ___ADD_LIST_ELEM(1,___SYM(35,___S_targ))
   ___ADD_LIST_ELEM(2,___SYM(39,___S_univ_2d_switch_2d_testable_3f_))
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_univ_2d_switch_2d_testable_3f_)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_univ_2d_switch_2d_testable_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),151,___G_pretty_2d_print)
___DEF_SLBL(3,___L3_c_23_univ_2d_switch_2d_testable_3f_)
   ___SET_R1(___FAL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_univ_2d_switch_2d_testable_3f_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_dump
#undef ___PH_LBL0
#define ___PH_LBL0 404
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_dump)
___DEF_P_HLBL(___L1_c_23_univ_2d_dump)
___DEF_P_HLBL(___L2_c_23_univ_2d_dump)
___DEF_P_HLBL(___L3_c_23_univ_2d_dump)
___DEF_P_HLBL(___L4_c_23_univ_2d_dump)
___DEF_P_HLBL(___L5_c_23_univ_2d_dump)
___DEF_P_HLBL(___L6_c_23_univ_2d_dump)
___DEF_P_HLBL(___L7_c_23_univ_2d_dump)
___DEF_P_HLBL(___L8_c_23_univ_2d_dump)
___DEF_P_HLBL(___L9_c_23_univ_2d_dump)
___DEF_P_HLBL(___L10_c_23_univ_2d_dump)
___DEF_P_HLBL(___L11_c_23_univ_2d_dump)
___DEF_P_HLBL(___L12_c_23_univ_2d_dump)
___DEF_P_HLBL(___L13_c_23_univ_2d_dump)
___DEF_P_HLBL(___L14_c_23_univ_2d_dump)
___DEF_P_HLBL(___L15_c_23_univ_2d_dump)
___DEF_P_HLBL(___L16_c_23_univ_2d_dump)
___DEF_P_HLBL(___L17_c_23_univ_2d_dump)
___DEF_P_HLBL(___L18_c_23_univ_2d_dump)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_dump)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_univ_2d_dump)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___ALLOC_CLO(2))
   ___BEGIN_SETUP_CLO(2,___STK(2),5)
   ___ADD_CLO_ELEM(0,___STK(-1))
   ___ADD_CLO_ELEM(1,___STK(-2))
   ___END_SETUP_CLO(2)
   ___SET_R2(___STK(2))
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(3))
   ___ADJFP(5)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_univ_2d_dump)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_univ_2d_dump)
   ___JUMPPRM(___SET_NARGS(2),___PRM(147,___G_call_2d_with_2d_output_2d_file))
___DEF_SLBL(3,___L3_c_23_univ_2d_dump)
   ___SET_R1(___FAL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_univ_2d_dump)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___DEF_SLBL(5,___L5_c_23_univ_2d_dump)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(5,1,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R4)
   ___SET_R1(___CLO(___R4,2))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_univ_2d_dump)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_c_23_target_2d_name)
___DEF_SLBL(7,___L7_c_23_univ_2d_dump)
   ___SET_R2(___R1)
   ___SET_R1(___SYM(31,___S_runtime_2d_system))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(8,___L8_c_23_univ_2d_dump)
   ___SET_R0(___LBL(9))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_SLBL(9,___L9_c_23_univ_2d_dump)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___KEY(0,___K_port))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),152,___G_print)
___DEF_SLBL(10,___L10_c_23_univ_2d_dump)
   ___SET_R3(___STK(-6))
   ___SET_R2(___CLO(___STK(-5),1))
   ___SET_R1(___CLO(___STK(-5),2))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(3),___PRC(424),___L_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(11,___L11_c_23_univ_2d_dump)
   ___SET_R1(___CLO(___STK(-5),2))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_c_23_target_2d_name)
___DEF_SLBL(12,___L12_c_23_univ_2d_dump)
   ___SET_STK(-4,___R1)
   ___SET_R1(___CLO(___STK(-5),2))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(2),___PRC(515),___L_c_23_make_2d_ctx)
___DEF_SLBL(13,___L13_c_23_univ_2d_dump)
   ___SET_STK(-3,___R1)
   ___SET_R1(___CLO(___STK(-5),1))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(14))
   ___JUMPPRM(___SET_NARGS(2),___PRM(148,___G_list_2d_ref))
___DEF_SLBL(14,___L14_c_23_univ_2d_dump)
   ___SET_STK(-5,___R1)
   ___BEGIN_ALLOC_LIST(2,___STK(-4))
   ___ADD_LIST_ELEM(1,___SYM(7,___S_entry_2d_point))
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___GLO(66,___G_c_23_univ_2d_to_2d_target))
   ___SET_R0(___LBL(16))
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15_c_23_univ_2d_dump)
   ___JUMPPRM(___SET_NARGS(2),___PRM(69,___G_assoc))
___DEF_SLBL(16,___L16_c_23_univ_2d_dump)
   ___SET_R1(___CDR(___R1))
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(17))
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-5))
___DEF_SLBL(17,___L17_c_23_univ_2d_dump)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___KEY(0,___K_port))
   ___SET_R0(___STK(-7))
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_univ_2d_dump)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),152,___G_print)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_univ_2d_dump_2d_procs
#undef ___PH_LBL0
#define ___PH_LBL0 424
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L1_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L2_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L3_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L4_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L5_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L6_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L7_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L8_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L9_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L10_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L11_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L12_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L13_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L14_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L15_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L16_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L17_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L18_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L19_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L20_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L21_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L22_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L23_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L24_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L25_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L26_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L27_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L28_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L29_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L30_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L31_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L32_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L33_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L34_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L35_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L36_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L37_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L38_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L39_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L40_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L41_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L42_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L43_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L44_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L45_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L46_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L47_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L48_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L49_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L50_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L51_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L52_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L53_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L54_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L55_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L56_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L57_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L58_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L59_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L60_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L61_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L62_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L63_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L64_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L65_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L66_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L67_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L68_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L69_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L70_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L71_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L72_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L73_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L74_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L75_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L76_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L77_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L78_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L79_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L80_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L81_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L82_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L83_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L84_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L85_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L86_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L87_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L88_c_23_univ_2d_dump_2d_procs)
___DEF_P_HLBL(___L89_c_23_univ_2d_dump_2d_procs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_univ_2d_dump_2d_procs)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),119,___G_c_23_queue_2d_empty)
___DEF_SLBL(2,___L2_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),119,___G_c_23_queue_2d_empty)
___DEF_SLBL(3,___L3_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-2,___R1)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-3))
   ___SET_R0(___LBL(88))
   ___ADJFP(4)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L90_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(4,___L4_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L90_c_23_univ_2d_dump_2d_procs)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),105,___G_c_23_make_2d_obj)
___DEF_SLBL(7,___L7_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___IF(___FALSEP(___R3))
   ___GOTO(___L105_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L92_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(8,___L8_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_univ_2d_dump_2d_procs)
___DEF_GLBL(___L91_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R3))
   ___GOTO(___L105_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L92_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(11))
   ___ADJFP(8)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),112,___G_c_23_obj_3f_)
___DEF_SLBL(11,___L11_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L96_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),77,___G_c_23_clo_3f_)
___DEF_SLBL(12,___L12_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L93_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L95_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(13,___L13_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L94_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L93_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___VOID)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_univ_2d_dump_2d_procs)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L94_c_23_univ_2d_dump_2d_procs)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),122,___G_c_23_queue_2d_put_21_)
___DEF_SLBL(15,___L15_c_23_univ_2d_dump_2d_procs)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_univ_2d_dump_2d_procs)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),122,___G_c_23_queue_2d_put_21_)
___DEF_GLBL(___L95_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),75,___G_c_23_clo_2d_base)
___DEF_GLBL(___L96_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),111,___G_c_23_obj_2d_val)
___DEF_SLBL(17,___L17_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L97_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(19,___L19_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
___DEF_GLBL(___L97_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(21))
   ___ADJFP(8)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),117,___G_c_23_proc_2d_obj_3f_)
___DEF_SLBL(21,___L21_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L93_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),114,___G_c_23_proc_2d_obj_2d_code)
___DEF_SLBL(22,___L22_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L93_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),118,___G_c_23_queue_2d__3e_list)
___DEF_SLBL(23,___L23_c_23_univ_2d_dump_2d_procs)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(13))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L99_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L100_c_23_univ_2d_dump_2d_procs)
___DEF_GLBL(___L98_c_23_univ_2d_dump_2d_procs)
   ___SET_R2(___CDR(___R2))
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L100_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L99_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___EQP(___R1,___R3)))
   ___GOTO(___L98_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L100_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(25,___L25_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_univ_2d_dump_2d_procs)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L101_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(27,___L27_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(41))
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L101_c_23_univ_2d_dump_2d_procs)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(19))
   ___ADJFP(8)
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),129,___G_c_23_switch_2d_case_2d_obj)
___DEF_SLBL(29,___L29_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23_univ_2d_dump_2d_procs)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L103_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L102_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(31,___L31_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(33))
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L103_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___CAR(___R3))
   ___SET_R0(___LBL(29))
   ___ADJFP(8)
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L91_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(33,___L33_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(34)
___DEF_SLBL(34,___L34_c_23_univ_2d_dump_2d_procs)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L104_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(35,___L35_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(41))
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L104_c_23_univ_2d_dump_2d_procs)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(37))
   ___ADJFP(8)
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),79,___G_c_23_closure_2d_parms_2d_loc)
___DEF_SLBL(37,___L37_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(40))
   ___IF(___FALSEP(___R3))
   ___GOTO(___L105_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L92_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(38,___L38_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(39))
   ___IF(___NOT(___FALSEP(___R3)))
   ___GOTO(___L92_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L105_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(39,___L39_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),130,___G_c_23_switch_2d_cases)
___DEF_SLBL(40,___L40_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),80,___G_c_23_closure_2d_parms_2d_opnds)
___DEF_SLBL(41,___L41_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L106_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(42,___L42_c_23_univ_2d_dump_2d_procs)
   ___IF(___EQP(___R1,___SYM(1,___S_apply)))
   ___GOTO(___L114_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___IF(___EQP(___R1,___SYM(4,___S_copy)))
   ___GOTO(___L116_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___IF(___EQP(___R1,___SYM(2,___S_close)))
   ___GOTO(___L117_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___IF(___EQP(___R1,___SYM(22,___S_ifjump)))
   ___GOTO(___L118_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___IF(___EQP(___R1,___SYM(34,___S_switch)))
   ___GOTO(___L120_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___IF(___EQP(___R1,___SYM(24,___S_jump)))
   ___GOTO(___L121_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L106_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-6)))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-10)
   ___POLL(43)
___DEF_SLBL(43,___L43_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L108_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L107_c_23_univ_2d_dump_2d_procs)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(45))
   ___ADJFP(10)
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),81,___G_c_23_code_2d_gvm_2d_instr)
___DEF_SLBL(45,___L45_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(46))
   ___JUMPINT(___SET_NARGS(2),___PRC(526),___L_c_23_translate_2d_gvm_2d_instr)
___DEF_SLBL(46,___L46_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-11))
   ___SET_R1(___KEY(0,___K_port))
   ___SET_R0(___LBL(47))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),152,___G_print)
___DEF_SLBL(47,___L47_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(42))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),89,___G_c_23_gvm_2d_instr_2d_type)
___DEF_SLBL(48,___L48_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-10))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(49))
   ___ADJFP(-6)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L107_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L108_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___VOID)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(49,___L49_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L109_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(50,___L50_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L113_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___ADJFP(-4)
___DEF_GLBL(___L109_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(51)
___DEF_SLBL(51,___L51_c_23_univ_2d_dump_2d_procs)
___DEF_GLBL(___L110_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(53))
   ___ADJFP(7)
   ___POLL(52)
___DEF_SLBL(52,___L52_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),120,___G_c_23_queue_2d_empty_3f_)
___DEF_SLBL(53,___L53_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L111_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___VOID)
   ___POLL(54)
___DEF_SLBL(54,___L54_c_23_univ_2d_dump_2d_procs)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L111_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(55))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),121,___G_c_23_queue_2d_get_21_)
___DEF_SLBL(55,___L55_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(56))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_c_23_target_2d_name)
___DEF_SLBL(56,___L56_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___KEY(0,___K_port))
   ___SET_STK(2,___STK(-9))
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(57))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(1),___PRC(214),___L_c_23_univ_2d_gen_2d_nl)
___DEF_SLBL(57,___L57_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-13))
   ___SET_R0(___LBL(58))
   ___JUMPINT(___SET_NARGS(1),___PRC(219),___L_c_23_univ_2d_open_2d_comment)
___DEF_SLBL(58,___L58_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-13))
   ___SET_R2(___SUB(75))
   ___SET_R0(___LBL(59))
   ___JUMPINT(___SET_NARGS(2),___PRC(229),___L_c_23_univ_2d_gen_2d_string)
___DEF_SLBL(59,___L59_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-14))
   ___SET_R0(___LBL(60))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),116,___G_c_23_proc_2d_obj_2d_primitive_3f_)
___DEF_SLBL(60,___L60_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L112_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___STK(-13))
   ___SET_R2(___SUB(76))
   ___SET_R0(___LBL(61))
   ___JUMPINT(___SET_NARGS(2),___PRC(229),___L_c_23_univ_2d_gen_2d_string)
___DEF_SLBL(61,___L61_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-13))
   ___SET_R2(___SUB(77))
   ___SET_R0(___LBL(62))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(2),___PRC(229),___L_c_23_univ_2d_gen_2d_string)
___DEF_SLBL(62,___L62_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-18))
   ___SET_R0(___LBL(63))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_c_23_proc_2d_obj_2d_name)
___DEF_SLBL(63,___L63_c_23_univ_2d_dump_2d_procs)
   ___SET_R0(___LBL(64))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),128,___G_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_SLBL(64,___L64_c_23_univ_2d_dump_2d_procs)
   ___SET_R0(___LBL(65))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),150,___G_object_2d__3e_string)
___DEF_SLBL(65,___L65_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-16,___R1)
   ___SET_R2(___STK(-17))
   ___SET_R1(___SYM(20,___S_gen_2d_string))
   ___SET_R0(___LBL(66))
   ___JUMPINT(___SET_NARGS(2),___PRC(208),___L_c_23_get_2d_target_2d_fun)
___DEF_SLBL(66,___L66_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-15,___R1)
   ___SET_R1(___STK(-16))
   ___SET_R0(___LBL(67))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-15))
___DEF_SLBL(67,___L67_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-17))
   ___SET_R2(___SUB(78))
   ___SET_R0(___LBL(68))
   ___JUMPINT(___SET_NARGS(2),___PRC(229),___L_c_23_univ_2d_gen_2d_string)
___DEF_SLBL(68,___L68_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-16,___R1)
   ___SET_R1(___STK(-17))
   ___SET_R0(___LBL(69))
   ___JUMPINT(___SET_NARGS(1),___PRC(224),___L_c_23_univ_2d_end_2d_comment)
___DEF_SLBL(69,___L69_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-15,___R1)
   ___SET_R1(___STK(-17))
   ___SET_R0(___LBL(70))
   ___JUMPINT(___SET_NARGS(1),___PRC(214),___L_c_23_univ_2d_gen_2d_nl)
___DEF_SLBL(70,___L70_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R0(___LBL(71))
   ___SET_R2(___STK(-15))
   ___SET_R1(___STK(-16))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(11),152,___G_print)
___DEF_SLBL(71,___L71_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(72))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),114,___G_c_23_proc_2d_obj_2d_code)
___DEF_SLBL(72,___L72_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(50))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),74,___G_c_23_bbs_3f_)
___DEF_GLBL(___L112_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-13))
   ___SET_R2(___SUB(79))
   ___SET_R0(___LBL(61))
   ___JUMPINT(___SET_NARGS(2),___PRC(229),___L_c_23_univ_2d_gen_2d_string)
___DEF_GLBL(___L113_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(73))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_c_23_proc_2d_obj_2d_name)
___DEF_SLBL(73,___L73_c_23_univ_2d_dump_2d_procs)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___SET_STK(-3,___STK(-9))
   ___SET_STK(-2,___STK(-8))
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(48))
   ___ADJFP(4)
   ___CHECK_HEAP(74,4096)
___DEF_SLBL(74,___L74_c_23_univ_2d_dump_2d_procs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),73,___G_c_23_bbs_2d__3e_code_2d_list)
___DEF_GLBL(___L114_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(75))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),71,___G_c_23_apply_2d_opnds)
___DEF_SLBL(75,___L75_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(79))
   ___IF(___PAIRP(___R3))
   ___GOTO(___L115_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(76,___L76_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(77)
___DEF_SLBL(77,___L77_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L115_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___CAR(___R3))
   ___SET_R0(___LBL(76))
   ___ADJFP(8)
   ___POLL(78)
___DEF_SLBL(78,___L78_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L91_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(79,___L79_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(80))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),70,___G_c_23_apply_2d_loc)
___DEF_SLBL(80,___L80_c_23_univ_2d_dump_2d_procs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L106_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(81))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),70,___G_c_23_apply_2d_loc)
___DEF_SLBL(81,___L81_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(41))
   ___IF(___FALSEP(___R3))
   ___GOTO(___L105_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L92_c_23_univ_2d_dump_2d_procs)
___DEF_GLBL(___L116_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(82))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),84,___G_c_23_copy_2d_opnd)
___DEF_SLBL(82,___L82_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(83))
   ___IF(___FALSEP(___R3))
   ___GOTO(___L105_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L92_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(83,___L83_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(81))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),83,___G_c_23_copy_2d_loc)
___DEF_GLBL(___L117_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),78,___G_c_23_close_2d_parms)
___DEF_GLBL(___L118_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(84))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),91,___G_c_23_ifjump_2d_opnds)
___DEF_SLBL(84,___L84_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(41))
   ___IF(___PAIRP(___R3))
   ___GOTO(___L119_c_23_univ_2d_dump_2d_procs)
   ___END_IF
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
___DEF_SLBL(85,___L85_c_23_univ_2d_dump_2d_procs)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(86)
___DEF_SLBL(86,___L86_c_23_univ_2d_dump_2d_procs)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L102_c_23_univ_2d_dump_2d_procs)
   ___END_IF
___DEF_GLBL(___L119_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___CAR(___R3))
   ___SET_R0(___LBL(85))
   ___ADJFP(8)
   ___POLL(87)
___DEF_SLBL(87,___L87_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L91_c_23_univ_2d_dump_2d_procs)
___DEF_GLBL(___L120_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(38))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G_c_23_switch_2d_opnd)
___DEF_GLBL(___L121_c_23_univ_2d_dump_2d_procs)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(81))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),95,___G_c_23_jump_2d_opnd)
___DEF_SLBL(88,___L88_c_23_univ_2d_dump_2d_procs)
   ___SET_STK(-9,___STK(-11))
   ___SET_STK(-11,___STK(-10))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___POLL(89)
___DEF_SLBL(89,___L89_c_23_univ_2d_dump_2d_procs)
   ___GOTO(___L110_c_23_univ_2d_dump_2d_procs)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_ctx
#undef ___PH_LBL0
#define ___PH_LBL0 515
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_ctx)
___DEF_P_HLBL(___L1_c_23_make_2d_ctx)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_ctx)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_make_2d_ctx)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R2)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_make_2d_ctx)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ctx_2d_target
#undef ___PH_LBL0
#define ___PH_LBL0 518
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ctx_2d_target)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ctx_2d_target)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ctx_2d_target)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ctx_2d_target_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 520
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ctx_2d_target_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ctx_2d_target_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ctx_2d_target_2d_set_21_)
   ___VECTORSET(___R1,___FIX(0L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ctx_2d_ns
#undef ___PH_LBL0
#define ___PH_LBL0 522
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ctx_2d_ns)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ctx_2d_ns)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ctx_2d_ns)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ctx_2d_ns_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 524
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ctx_2d_ns_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ctx_2d_ns_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ctx_2d_ns_2d_set_21_)
   ___VECTORSET(___R1,___FIX(1L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_translate_2d_gvm_2d_instr
#undef ___PH_LBL0
#define ___PH_LBL0 526
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L1_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L2_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L3_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L4_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L5_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L6_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L7_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L8_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L9_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L10_c_23_translate_2d_gvm_2d_instr)
___DEF_P_HLBL(___L11_c_23_translate_2d_gvm_2d_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_translate_2d_gvm_2d_instr)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_translate_2d_gvm_2d_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_translate_2d_gvm_2d_instr)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_c_23_target_2d_name)
___DEF_SLBL(2,___L2_c_23_translate_2d_gvm_2d_instr)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),89,___G_c_23_gvm_2d_instr_2d_type)
___DEF_SLBL(3,___L3_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(25,___S_label)),___L18_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(1,___S_apply)),___L17_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(4,___S_copy)),___L16_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(2,___S_close)),___L15_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(22,___S_ifjump)),___L14_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(34,___S_switch)),___L13_c_23_translate_2d_gvm_2d_instr)
   ___IF_GOTO(___EQP(___R1,___SYM(24,___S_jump)),___L12_c_23_translate_2d_gvm_2d_instr)
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(80))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),82,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L12_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(289),___L_c_23_univ_2d_gen_2d_jump_2d_instr)
___DEF_GLBL(___L13_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(284),___L_c_23_univ_2d_gen_2d_switch_2d_instr)
___DEF_GLBL(___L14_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(279),___L_c_23_univ_2d_gen_2d_ifjump_2d_instr)
___DEF_GLBL(___L15_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(274),___L_c_23_univ_2d_gen_2d_close_2d_instr)
___DEF_GLBL(___L16_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(269),___L_c_23_univ_2d_gen_2d_copy_2d_instr)
___DEF_GLBL(___L17_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(264),___L_c_23_univ_2d_gen_2d_apply_2d_instr)
___DEF_GLBL(___L18_c_23_translate_2d_gvm_2d_instr)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_translate_2d_gvm_2d_instr)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(259),___L_c_23_univ_2d_gen_2d_label_2d_instr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_translate_2d_gvm_2d_opnd
#undef ___PH_LBL0
#define ___PH_LBL0 539
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L1_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L2_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L3_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L4_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L5_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L6_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L7_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L8_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L9_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L10_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L11_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L12_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L13_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L14_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L15_c_23_translate_2d_gvm_2d_opnd)
___DEF_P_HLBL(___L16_c_23_translate_2d_gvm_2d_opnd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_translate_2d_gvm_2d_opnd)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_translate_2d_gvm_2d_opnd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_translate_2d_gvm_2d_opnd)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_c_23_target_2d_name)
___DEF_SLBL(2,___L2_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___NOT(___FALSEP(___STK(-5))))
   ___GOTO(___L17_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R2(___SUB(81))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(229),___L_c_23_univ_2d_gen_2d_string)
___DEF_GLBL(___L17_c_23_translate_2d_gvm_2d_opnd)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),124,___G_c_23_reg_3f_)
___DEF_SLBL(4,___L4_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L18_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(294),___L_c_23_univ_2d_gen_2d_reg_2d_opnd)
___DEF_GLBL(___L18_c_23_translate_2d_gvm_2d_opnd)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),127,___G_c_23_stk_3f_)
___DEF_SLBL(6,___L6_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L19_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(299),___L_c_23_univ_2d_gen_2d_stk_2d_opnd)
___DEF_GLBL(___L19_c_23_translate_2d_gvm_2d_opnd)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),87,___G_c_23_glo_3f_)
___DEF_SLBL(8,___L8_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L20_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(304),___L_c_23_univ_2d_gen_2d_glo_2d_opnd)
___DEF_GLBL(___L20_c_23_translate_2d_gvm_2d_opnd)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),77,___G_c_23_clo_3f_)
___DEF_SLBL(10,___L10_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L21_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(309),___L_c_23_univ_2d_gen_2d_clo_2d_opnd)
___DEF_GLBL(___L21_c_23_translate_2d_gvm_2d_opnd)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),102,___G_c_23_lbl_3f_)
___DEF_SLBL(12,___L12_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L22_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(239),___L_c_23_univ_2d_translate_2d_lbl)
___DEF_GLBL(___L22_c_23_translate_2d_gvm_2d_opnd)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),112,___G_c_23_obj_3f_)
___DEF_SLBL(14,___L14_c_23_translate_2d_gvm_2d_opnd)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L23_c_23_translate_2d_gvm_2d_opnd)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(82))
   ___SET_R0(___STK(-7))
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),82,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L23_c_23_translate_2d_gvm_2d_opnd)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_translate_2d_gvm_2d_opnd)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(314),___L_c_23_univ_2d_gen_2d_obj_2d_opnd)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___t_2d_univ," _t-univ",___REF_FAL,32,0)
,___DEF_LBL_PROC(___H__20___t_2d_univ,0,0)
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___t_2d_univ,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_nl,"c#js-gen-nl",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_nl,0,0)
,___DEF_LBL_INTRO(___H_c_23_js_2d_open_2d_comment,"c#js-open-comment",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_open_2d_comment,0,0)
,___DEF_LBL_INTRO(___H_c_23_js_2d_end_2d_comment,"c#js-end-comment",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_end_2d_comment,0,0)
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_string,"c#js-gen-string",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_string,1,0)
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_label,"c#js-gen-label",___REF_FAL,19,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_label,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0x19L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_label,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_apply,"c#js-gen-apply",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_apply,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_apply,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_copy,"c#js-gen-copy",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_copy,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_copy,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_close,"c#js-gen-close",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_close,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_close,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_ifjump,"c#js-gen-ifjump",___REF_FAL,16,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_ifjump,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x7bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x7bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x7bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x67L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x4fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,9,0,0x4fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETN,5,0,0x1dL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_ifjump,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_switch,"c#js-gen-switch",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_switch,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_switch,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_jump,"c#js-gen-jump",___REF_FAL,15,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_jump,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,9,0,0x3bL))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0x19L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETI,8,0,0x3f19L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETN,5,0,0x19L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETI,8,0,0x3f19L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_jump,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_reg,"c#js-gen-reg",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_reg,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_reg,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_reg,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_reg,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_reg,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_stk,"c#js-gen-stk",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_stk,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_stk,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_stk,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_stk,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_stk,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_stk,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_glo,"c#js-gen-glo",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_glo,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_glo,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_glo,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_glo,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_glo,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_glo,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_glo,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_clo,"c#js-gen-clo",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_clo,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_clo,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_clo,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_clo,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_clo,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_clo,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_clo,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_gen_2d_obj,"c#js-gen-obj",___REF_FAL,16,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_gen_2d_obj,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_gen_2d_obj,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_sp_2d_adjust,"c#js-sp-adjust",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_sp_2d_adjust,3,0)
,___DEF_LBL_RET(___H_c_23_js_2d_sp_2d_adjust,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_js_2d_sp_2d_adjust,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_js_2d_translate_2d_lbl,"c#js-translate-lbl",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_translate_2d_lbl,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_translate_2d_lbl,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_js_2d_translate_2d_lbl,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_translate_2d_lbl,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_translate_2d_lbl,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_translate_2d_lbl,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_lbl_2d__3e_id,"c#js-lbl->id",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_lbl_2d__3e_id,3,0)
,___DEF_LBL_RET(___H_c_23_js_2d_lbl_2d__3e_id,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_js_2d_lbl_2d__3e_id,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_lbl_2d__3e_id,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_js_2d_lbl_2d__3e_id,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_entry_2d_point,"c#js-entry-point",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_entry_2d_point,2,0)
,___DEF_LBL_RET(___H_c_23_js_2d_entry_2d_point,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_entry_2d_point,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_entry_2d_point,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_js_2d_entry_2d_point,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_js_2d_entry_2d_point,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_js_2d_runtime_2d_system,"c#js-runtime-system",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_runtime_2d_system,0,0)
,___DEF_LBL_INTRO(___H_c_23_js_2d_prim_2d_applic,"c#js-prim-applic",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_js_2d_prim_2d_applic,4,0)
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETN,5,1,0x2L))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETN,5,1,0x2L))
,___DEF_LBL_RET(___H_c_23_js_2d_prim_2d_applic,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_target_2d_fun,"c#add-target-fun",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_target_2d_fun,3,0)
,___DEF_LBL_RET(___H_c_23_add_2d_target_2d_fun,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_get_2d_target_2d_fun,"c#get-target-fun",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_get_2d_target_2d_fun,2,0)
,___DEF_LBL_RET(___H_c_23_get_2d_target_2d_fun,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_get_2d_target_2d_fun,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_get_2d_target_2d_fun,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_get_2d_target_2d_fun,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_nl,"c#univ-gen-nl",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_nl,1,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_nl,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_nl,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_nl,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_open_2d_comment,"c#univ-open-comment",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_open_2d_comment,1,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_open_2d_comment,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_open_2d_comment,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_open_2d_comment,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_end_2d_comment,"c#univ-end-comment",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_end_2d_comment,1,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_end_2d_comment,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_end_2d_comment,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_end_2d_comment,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_string,"c#univ-gen-string",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_string,2,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_string,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_string,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_string,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_sp_2d_adjust,"c#univ-sp-adjust",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_sp_2d_adjust,4,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_sp_2d_adjust,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_univ_2d_sp_2d_adjust,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_univ_2d_sp_2d_adjust,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_translate_2d_lbl,"c#univ-translate-lbl",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_translate_2d_lbl,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_translate_2d_lbl,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_translate_2d_lbl,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_translate_2d_lbl,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_entry_2d_point,"c#univ-entry-point",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_entry_2d_point,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_entry_2d_point,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_entry_2d_point,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_entry_2d_point,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_runtime_2d_system,"c#univ-runtime-system",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_runtime_2d_system,1,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_runtime_2d_system,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_runtime_2d_system,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_runtime_2d_system,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_prim_2d_applic,"c#univ-prim-applic",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_prim_2d_applic,1,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_applic,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_applic,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_applic,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_label_2d_instr,"c#univ-gen-label-instr",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_label_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_label_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_label_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_label_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_apply_2d_instr,"c#univ-gen-apply-instr",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_apply_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_apply_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_apply_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_apply_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_copy_2d_instr,"c#univ-gen-copy-instr",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_copy_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_copy_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_copy_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_copy_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_close_2d_instr,"c#univ-gen-close-instr",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_close_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_close_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_close_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_close_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_ifjump_2d_instr,"c#univ-gen-ifjump-instr",___REF_FAL,4,0)

,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_ifjump_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_ifjump_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_ifjump_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_ifjump_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_switch_2d_instr,"c#univ-gen-switch-instr",___REF_FAL,4,0)

,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_switch_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_switch_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_switch_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_switch_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_jump_2d_instr,"c#univ-gen-jump-instr",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_jump_2d_instr,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_jump_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_jump_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_jump_2d_instr,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_reg_2d_opnd,"c#univ-gen-reg-opnd",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_reg_2d_opnd,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_reg_2d_opnd,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_reg_2d_opnd,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_reg_2d_opnd,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_stk_2d_opnd,"c#univ-gen-stk-opnd",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_stk_2d_opnd,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_stk_2d_opnd,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_stk_2d_opnd,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_stk_2d_opnd,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_glo_2d_opnd,"c#univ-gen-glo-opnd",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_glo_2d_opnd,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_glo_2d_opnd,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_glo_2d_opnd,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_glo_2d_opnd,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_clo_2d_opnd,"c#univ-gen-clo-opnd",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_clo_2d_opnd,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_clo_2d_opnd,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_clo_2d_opnd,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_clo_2d_opnd,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_gen_2d_obj_2d_opnd,"c#univ-gen-obj-opnd",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_gen_2d_obj_2d_opnd,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_obj_2d_opnd,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_obj_2d_opnd,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_gen_2d_obj_2d_opnd,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_setup,"c#univ-setup",___REF_FAL,39,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,2,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,0,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,1,2)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,1,1)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,1,1)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,2,1)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,1,1)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_univ_2d_setup,5,1)
,___DEF_LBL_RET(___H_c_23_univ_2d_setup,___IFD(___RETI,4,4,0x3f7L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_label_2d_info,"c#univ-label-info",___REF_FAL,14,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_label_2d_info,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f11L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETN,5,0,0x11L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_label_2d_info,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_jump_2d_info,"c#univ-jump-info",___REF_FAL,14,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_jump_2d_info,2,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f0bL))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f11L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETN,5,0,0x11L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_univ_2d_jump_2d_info,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_prim_2d_info,"c#univ-prim-info",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_prim_2d_info,2,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_info,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_prim_2d_proc_2d_add_21_,"c#univ-prim-proc-add!",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_prim_2d_proc_2d_add_21_,1,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_proc_2d_add_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_proc_2d_add_21_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_proc_2d_add_21_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_univ_2d_prim_2d_proc_2d_add_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_switch_2d_testable_3f_,"c#univ-switch-testable?",___REF_FAL,5,0)

,___DEF_LBL_PROC(___H_c_23_univ_2d_switch_2d_testable_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_switch_2d_testable_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_switch_2d_testable_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_switch_2d_testable_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_switch_2d_testable_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_dump,"c#univ-dump",___REF_FAL,19,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_dump,6,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETI,8,3,0x3f08L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETI,8,3,0x3f08L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,3,0x8L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETI,8,3,0x3f08L))
,___DEF_LBL_PROC(___H_c_23_univ_2d_dump,1,2)
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETI,8,0,0x3f17L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_univ_2d_dump_2d_procs,"c#univ-dump-procs",___REF_FAL,90,0)
,___DEF_LBL_PROC(___H_c_23_univ_2d_dump_2d_procs,3,0)
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETI,12,2,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,13,1,0x33fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,17,1,0x307fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,17,1,0x707fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,17,1,0xf07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,17,1,0x1f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,17,1,0x1f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0x7f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0x7f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0x7f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0x7f0ffL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0x7f07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0xff07fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0xff0ffL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETN,21,1,0xff1bfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,1,0x5fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___OFD(___RETI,16,1,0x3f033fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETN,9,0,0x3bL))
,___DEF_LBL_RET(___H_c_23_univ_2d_dump_2d_procs,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_make_2d_ctx,"c#make-ctx",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_ctx,2,0)
,___DEF_LBL_RET(___H_c_23_make_2d_ctx,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ctx_2d_target,"c#ctx-target",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ctx_2d_target,1,0)
,___DEF_LBL_INTRO(___H_c_23_ctx_2d_target_2d_set_21_,"c#ctx-target-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ctx_2d_target_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_ctx_2d_ns,"c#ctx-ns",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ctx_2d_ns,1,0)
,___DEF_LBL_INTRO(___H_c_23_ctx_2d_ns_2d_set_21_,"c#ctx-ns-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ctx_2d_ns_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_translate_2d_gvm_2d_instr,"c#translate-gvm-instr",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_translate_2d_gvm_2d_instr,2,0)
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_instr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_translate_2d_gvm_2d_opnd,"c#translate-gvm-opnd",___REF_FAL,17,0)
,___DEF_LBL_PROC(___H_c_23_translate_2d_gvm_2d_opnd,2,0)
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_translate_2d_gvm_2d_opnd,___IFD(___RETI,8,8,0x3f00L))
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x7f07fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x7f07fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x7f07fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x7f0ffL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x7f07fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0xff07fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0xff0ffL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0xff1bfL)
,___DEF_OFD(___RETI,16,1)
               ___GCMAP1(0x3f033fL)
___END_OFD

___BEGIN_MOD1
___DEF_PRM(0,___G__20___t_2d_univ,1)
___DEF_PRM(18,___G_c_23_js_2d_gen_2d_nl,34)
___DEF_PRM(25,___G_c_23_js_2d_open_2d_comment,36)
___DEF_PRM(8,___G_c_23_js_2d_end_2d_comment,38)
___DEF_PRM(22,___G_c_23_js_2d_gen_2d_string,40)
___DEF_PRM(17,___G_c_23_js_2d_gen_2d_label,42)
___DEF_PRM(10,___G_c_23_js_2d_gen_2d_apply,62)
___DEF_PRM(13,___G_c_23_js_2d_gen_2d_copy,72)
___DEF_PRM(12,___G_c_23_js_2d_gen_2d_close,83)
___DEF_PRM(15,___G_c_23_js_2d_gen_2d_ifjump,86)
___DEF_PRM(23,___G_c_23_js_2d_gen_2d_switch,103)
___DEF_PRM(16,___G_c_23_js_2d_gen_2d_jump,106)
___DEF_PRM(20,___G_c_23_js_2d_gen_2d_reg,122)
___DEF_PRM(21,___G_c_23_js_2d_gen_2d_stk,128)
___DEF_PRM(14,___G_c_23_js_2d_gen_2d_glo,135)
___DEF_PRM(11,___G_c_23_js_2d_gen_2d_clo,143)
___DEF_PRM(19,___G_c_23_js_2d_gen_2d_obj,151)
___DEF_PRM(28,___G_c_23_js_2d_sp_2d_adjust,168)
___DEF_PRM(29,___G_c_23_js_2d_translate_2d_lbl,172)
___DEF_PRM(24,___G_c_23_js_2d_lbl_2d__3e_id,179)
___DEF_PRM(9,___G_c_23_js_2d_entry_2d_point,185)
___DEF_PRM(27,___G_c_23_js_2d_runtime_2d_system,192)
___DEF_PRM(26,___G_c_23_js_2d_prim_2d_applic,194)
___DEF_PRM(1,___G_c_23_add_2d_target_2d_fun,205)
___DEF_PRM(7,___G_c_23_get_2d_target_2d_fun,208)
___DEF_PRM(47,___G_c_23_univ_2d_gen_2d_nl,214)
___DEF_PRM(57,___G_c_23_univ_2d_open_2d_comment,219)
___DEF_PRM(35,___G_c_23_univ_2d_end_2d_comment,224)
___DEF_PRM(51,___G_c_23_univ_2d_gen_2d_string,229)
___DEF_PRM(64,___G_c_23_univ_2d_sp_2d_adjust,234)
___DEF_PRM(67,___G_c_23_univ_2d_translate_2d_lbl,239)
___DEF_PRM(36,___G_c_23_univ_2d_entry_2d_point,244)
___DEF_PRM(62,___G_c_23_univ_2d_runtime_2d_system,249)
___DEF_PRM(58,___G_c_23_univ_2d_prim_2d_applic,254)
___DEF_PRM(46,___G_c_23_univ_2d_gen_2d_label_2d_instr,259)
___DEF_PRM(39,___G_c_23_univ_2d_gen_2d_apply_2d_instr,264)
___DEF_PRM(42,___G_c_23_univ_2d_gen_2d_copy_2d_instr,269)
___DEF_PRM(41,___G_c_23_univ_2d_gen_2d_close_2d_instr,274)
___DEF_PRM(44,___G_c_23_univ_2d_gen_2d_ifjump_2d_instr,279)
___DEF_PRM(52,___G_c_23_univ_2d_gen_2d_switch_2d_instr,284)
___DEF_PRM(45,___G_c_23_univ_2d_gen_2d_jump_2d_instr,289)
___DEF_PRM(49,___G_c_23_univ_2d_gen_2d_reg_2d_opnd,294)
___DEF_PRM(50,___G_c_23_univ_2d_gen_2d_stk_2d_opnd,299)
___DEF_PRM(43,___G_c_23_univ_2d_gen_2d_glo_2d_opnd,304)
___DEF_PRM(40,___G_c_23_univ_2d_gen_2d_clo_2d_opnd,309)
___DEF_PRM(48,___G_c_23_univ_2d_gen_2d_obj_2d_opnd,314)
___DEF_PRM(63,___G_c_23_univ_2d_setup,319)
___DEF_PRM(54,___G_c_23_univ_2d_label_2d_info,359)
___DEF_PRM(53,___G_c_23_univ_2d_jump_2d_info,374)
___DEF_PRM(59,___G_c_23_univ_2d_prim_2d_info,389)
___DEF_PRM(60,___G_c_23_univ_2d_prim_2d_proc_2d_add_21_,392)
___DEF_PRM(65,___G_c_23_univ_2d_switch_2d_testable_3f_,398)
___DEF_PRM(33,___G_c_23_univ_2d_dump,404)
___DEF_PRM(34,___G_c_23_univ_2d_dump_2d_procs,424)
___DEF_PRM(30,___G_c_23_make_2d_ctx,515)
___DEF_PRM(4,___G_c_23_ctx_2d_target,518)
___DEF_PRM(5,___G_c_23_ctx_2d_target_2d_set_21_,520)
___DEF_PRM(2,___G_c_23_ctx_2d_ns,522)
___DEF_PRM(3,___G_c_23_ctx_2d_ns_2d_set_21_,524)
___DEF_PRM(31,___G_c_23_translate_2d_gvm_2d_instr,526)
___DEF_PRM(32,___G_c_23_translate_2d_gvm_2d_opnd,539)
___END_MOD1

___BEGIN_MOD2
___DEF_SYM2(0,___S__23__23_not,"##not")
___DEF_SYM2(1,___S_apply,"apply")
___DEF_SYM2(2,___S_close,"close")
___DEF_SYM2(3,___S_closure_2d_env,"closure-env")
___DEF_SYM2(4,___S_copy,"copy")
___DEF_SYM2(5,___S_end_2d_comment,"end-comment")
___DEF_SYM2(6,___S_entry,"entry")
___DEF_SYM2(7,___S_entry_2d_point,"entry-point")
___DEF_SYM2(8,___S_gen_2d_apply,"gen-apply")
___DEF_SYM2(9,___S_gen_2d_clo,"gen-clo")
___DEF_SYM2(10,___S_gen_2d_close,"gen-close")
___DEF_SYM2(11,___S_gen_2d_copy,"gen-copy")
___DEF_SYM2(12,___S_gen_2d_glo,"gen-glo")
___DEF_SYM2(13,___S_gen_2d_ifjump,"gen-ifjump")
___DEF_SYM2(14,___S_gen_2d_jump,"gen-jump")
___DEF_SYM2(15,___S_gen_2d_label,"gen-label")
___DEF_SYM2(16,___S_gen_2d_nl,"gen-nl")
___DEF_SYM2(17,___S_gen_2d_obj,"gen-obj")
___DEF_SYM2(18,___S_gen_2d_reg,"gen-reg")
___DEF_SYM2(19,___S_gen_2d_stk,"gen-stk")
___DEF_SYM2(20,___S_gen_2d_string,"gen-string")
___DEF_SYM2(21,___S_gen_2d_switch,"gen-switch")
___DEF_SYM2(22,___S_ifjump,"ifjump")
___DEF_SYM2(23,___S_js,"js")
___DEF_SYM2(24,___S_jump,"jump")
___DEF_SYM2(25,___S_label,"label")
___DEF_SYM2(26,___S_open_2d_comment,"open-comment")
___DEF_SYM2(27,___S_php,"php")
___DEF_SYM2(28,___S_prim_2d_applic,"prim-applic")
___DEF_SYM2(29,___S_python,"python")
___DEF_SYM2(30,___S_return,"return")
___DEF_SYM2(31,___S_runtime_2d_system,"runtime-system")
___DEF_SYM2(32,___S_simple,"simple")
___DEF_SYM2(33,___S_sp_2d_adjust,"sp-adjust")
___DEF_SYM2(34,___S_switch,"switch")
___DEF_SYM2(35,___S_targ,"targ")
___DEF_SYM2(36,___S_task_2d_entry,"task-entry")
___DEF_SYM2(37,___S_task_2d_return,"task-return")
___DEF_SYM2(38,___S_translate_2d_lbl,"translate-lbl")
___DEF_SYM2(39,___S_univ_2d_switch_2d_testable_3f_,"univ-switch-testable?")
___DEF_KEY2(0,___K_port,"port")
___END_MOD2

#endif
