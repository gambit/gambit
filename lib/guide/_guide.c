#ifdef ___LINKER_INFO
; File: "_guide.c", produced by Gambit-C 4.0 beta 13
(
40063
" _guide"
(" _guide")
(
"##type-12-6bf088a7-814f-4139-860a-69a757570569"
"##type-14-e188675f-7d4e-4e1f-8eb0-01a25aae640b"
"##type-17-2babe060-9af6-456f-a26e-40b592f690ec"
"##type-6"
"##type-7-cd5f5bad-f96f-438d-8d63-ff887b7b39de"
"GuideUiMainWindow*"
"GuideUiScheme"
"GuideUiScheme*"
"QApplication*"
"cfields"
"channel"
"close"
"cont"
"depth"
"display-continuation"
"display-monoline-message"
"display-multiline-message"
"far-port"
"fields"
"flags"
"force-output"
"id"
"initial-cont"
"input-port"
"interaction"
"last-owner"
"level"
"mutex"
"name"
"newline"
"output-port"
"owner-mutex"
"pinpoint-continuation"
"port"
"prev-depth"
"prev-level"
"read-command"
"read-datum"
"really-exit?"
"repl-channel"
"repl-channel-guide"
"repl-context"
"rkind"
"roptions"
"rtimeout"
"rtimeout-thunk"
"set-rtimeout"
"set-wtimeout"
"super"
"type"
"wkind"
"woptions"
"write-datum"
"write-results"
"wtimeout"
"wtimeout-thunk"
)
(
"buffering"
"permanent-close"
)
(
" _guide"
" _guide#0"
" _guide#1"
" _guide#10"
" _guide#11"
" _guide#2"
" _guide#3"
" _guide#4"
" _guide#5"
" _guide#6"
" _guide#7"
" _guide#8"
" _guide#9"
"##guide-main-window"
"##main-window"
"##make-repl-channel-guide"
"##repl-channel-guide-display-continuation"
"##repl-channel-guide-pinpoint-continuation"
)
(
"##GuideUiMainWindow-new"
"##GuideUiScheme-continuation-set-cell"
"##GuideUiScheme-continuation-set-highlight"
"##GuideUiScheme-continuation-set-length"
"##GuideUiScheme-environment-set-cell"
"##GuideUiScheme-environment-set-length"
"##GuideUiScheme-highlight-expr-in-console"
"##GuideUiScheme-highlight-expr-in-file"
"##GuideUiScheme-new"
"##GuideUiScheme-print-text"
"##GuideUiScheme-typed-eof"
"##GuideUiScheme-typed-text"
"##QApplication-new"
"##QApplication-processEvents"
"##thread-make-repl-channel"
)
(
"##call-with-values"
"##close-output-port"
"##command-line"
"##container->file"
"##continuation-creator"
"##continuation-locals"
"##continuation-locat"
"##continuation-next-interesting"
"##continuation-ret"
"##cte-frame-vars"
"##cte-frame?"
"##cte-parent-cte"
"##cte-top?"
"##decomp"
"##decompile"
"##display-locat"
"##dynamic-env->list"
"##filepos-col"
"##filepos-line"
"##for-each"
"##force-output"
"##get-output-string"
"##hidden-local-var?"
"##hidden-parameter?"
"##input-port-timeout-set!"
"##interaction-cte"
"##interp-continuation-code"
"##interp-continuation-rte"
"##interp-continuation?"
"##interp-procedure-wrapper"
"##inverse-eval-in-env"
"##locat-container"
"##locat-position"
"##make-mutex"
"##newline"
"##object->string"
"##open-output-string"
"##open-string-pipe"
"##output-port-column-set!"
"##peek-char"
"##position->filepos"
"##pretty-print"
"##procedure-name"
"##read-expr-from-port"
"##read-line"
"##still-copy"
"##thread-sleep!"
"##thread-start!"
"##vector->list"
"##write"
"##write-string"
"make-thread"
)
 #f
)
#else
#define ___VERSION 40063
#define ___MODULE_NAME " _guide"
#define ___LINKER_ID ____20___guide
#define ___MH_PROC ___H__20___guide
#define ___SCRIPT_LINE 0
#define ___SYM_COUNT 56
#define ___KEY_COUNT 2
#define ___GLO_COUNT 85
#define ___SUP_COUNT 33
#define ___CNS_COUNT 5
#define ___SUB_COUNT 21
#define ___LBL_COUNT 218
#include "gambit.h"

___NEED_SYM(___S__23__23_type_2d_12_2d_6bf088a7_2d_814f_2d_4139_2d_860a_2d_69a757570569)
___NEED_SYM(___S__23__23_type_2d_14_2d_e188675f_2d_7d4e_2d_4e1f_2d_8eb0_2d_01a25aae640b)
___NEED_SYM(___S__23__23_type_2d_17_2d_2babe060_2d_9af6_2d_456f_2d_a26e_2d_40b592f690ec)
___NEED_SYM(___S__23__23_type_2d_6)
___NEED_SYM(___S__23__23_type_2d_7_2d_cd5f5bad_2d_f96f_2d_438d_2d_8d63_2d_ff887b7b39de)
___NEED_SYM(___S_GuideUiMainWindow_2a_)
___NEED_SYM(___S_GuideUiScheme)
___NEED_SYM(___S_GuideUiScheme_2a_)
___NEED_SYM(___S_QApplication_2a_)
___NEED_SYM(___S_cfields)
___NEED_SYM(___S_channel)
___NEED_SYM(___S_close)
___NEED_SYM(___S_cont)
___NEED_SYM(___S_depth)
___NEED_SYM(___S_display_2d_continuation)
___NEED_SYM(___S_display_2d_monoline_2d_message)
___NEED_SYM(___S_display_2d_multiline_2d_message)
___NEED_SYM(___S_far_2d_port)
___NEED_SYM(___S_fields)
___NEED_SYM(___S_flags)
___NEED_SYM(___S_force_2d_output)
___NEED_SYM(___S_id)
___NEED_SYM(___S_initial_2d_cont)
___NEED_SYM(___S_input_2d_port)
___NEED_SYM(___S_interaction)
___NEED_SYM(___S_last_2d_owner)
___NEED_SYM(___S_level)
___NEED_SYM(___S_mutex)
___NEED_SYM(___S_name)
___NEED_SYM(___S_newline)
___NEED_SYM(___S_output_2d_port)
___NEED_SYM(___S_owner_2d_mutex)
___NEED_SYM(___S_pinpoint_2d_continuation)
___NEED_SYM(___S_port)
___NEED_SYM(___S_prev_2d_depth)
___NEED_SYM(___S_prev_2d_level)
___NEED_SYM(___S_read_2d_command)
___NEED_SYM(___S_read_2d_datum)
___NEED_SYM(___S_really_2d_exit_3f_)
___NEED_SYM(___S_repl_2d_channel)
___NEED_SYM(___S_repl_2d_channel_2d_guide)
___NEED_SYM(___S_repl_2d_context)
___NEED_SYM(___S_rkind)
___NEED_SYM(___S_roptions)
___NEED_SYM(___S_rtimeout)
___NEED_SYM(___S_rtimeout_2d_thunk)
___NEED_SYM(___S_set_2d_rtimeout)
___NEED_SYM(___S_set_2d_wtimeout)
___NEED_SYM(___S_super)
___NEED_SYM(___S_type)
___NEED_SYM(___S_wkind)
___NEED_SYM(___S_woptions)
___NEED_SYM(___S_write_2d_datum)
___NEED_SYM(___S_write_2d_results)
___NEED_SYM(___S_wtimeout)
___NEED_SYM(___S_wtimeout_2d_thunk)

___NEED_KEY(___K_buffering)
___NEED_KEY(___K_permanent_2d_close)

___NEED_GLO(___G__20___guide)
___NEED_GLO(___G__20___guide_23_0)
___NEED_GLO(___G__20___guide_23_1)
___NEED_GLO(___G__20___guide_23_10)
___NEED_GLO(___G__20___guide_23_11)
___NEED_GLO(___G__20___guide_23_2)
___NEED_GLO(___G__20___guide_23_3)
___NEED_GLO(___G__20___guide_23_4)
___NEED_GLO(___G__20___guide_23_5)
___NEED_GLO(___G__20___guide_23_6)
___NEED_GLO(___G__20___guide_23_7)
___NEED_GLO(___G__20___guide_23_8)
___NEED_GLO(___G__20___guide_23_9)
___NEED_GLO(___G__23__23_GuideUiMainWindow_2d_new)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_continuation_2d_set_2d_cell)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_continuation_2d_set_2d_highlight)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_continuation_2d_set_2d_length)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_environment_2d_set_2d_cell)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_environment_2d_set_2d_length)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_highlight_2d_expr_2d_in_2d_console)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_highlight_2d_expr_2d_in_2d_file)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_new)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_print_2d_text)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_typed_2d_eof)
___NEED_GLO(___G__23__23_GuideUiScheme_2d_typed_2d_text)
___NEED_GLO(___G__23__23_QApplication_2d_new)
___NEED_GLO(___G__23__23_QApplication_2d_processEvents)
___NEED_GLO(___G__23__23_call_2d_with_2d_values)
___NEED_GLO(___G__23__23_close_2d_output_2d_port)
___NEED_GLO(___G__23__23_command_2d_line)
___NEED_GLO(___G__23__23_container_2d__3e_file)
___NEED_GLO(___G__23__23_continuation_2d_creator)
___NEED_GLO(___G__23__23_continuation_2d_locals)
___NEED_GLO(___G__23__23_continuation_2d_locat)
___NEED_GLO(___G__23__23_continuation_2d_next_2d_interesting)
___NEED_GLO(___G__23__23_continuation_2d_ret)
___NEED_GLO(___G__23__23_cte_2d_frame_2d_vars)
___NEED_GLO(___G__23__23_cte_2d_frame_3f_)
___NEED_GLO(___G__23__23_cte_2d_parent_2d_cte)
___NEED_GLO(___G__23__23_cte_2d_top_3f_)
___NEED_GLO(___G__23__23_decomp)
___NEED_GLO(___G__23__23_decompile)
___NEED_GLO(___G__23__23_display_2d_locat)
___NEED_GLO(___G__23__23_dynamic_2d_env_2d__3e_list)
___NEED_GLO(___G__23__23_filepos_2d_col)
___NEED_GLO(___G__23__23_filepos_2d_line)
___NEED_GLO(___G__23__23_for_2d_each)
___NEED_GLO(___G__23__23_force_2d_output)
___NEED_GLO(___G__23__23_get_2d_output_2d_string)
___NEED_GLO(___G__23__23_guide_2d_main_2d_window)
___NEED_GLO(___G__23__23_hidden_2d_local_2d_var_3f_)
___NEED_GLO(___G__23__23_hidden_2d_parameter_3f_)
___NEED_GLO(___G__23__23_input_2d_port_2d_timeout_2d_set_21_)
___NEED_GLO(___G__23__23_interaction_2d_cte)
___NEED_GLO(___G__23__23_interp_2d_continuation_2d_code)
___NEED_GLO(___G__23__23_interp_2d_continuation_2d_rte)
___NEED_GLO(___G__23__23_interp_2d_continuation_3f_)
___NEED_GLO(___G__23__23_interp_2d_procedure_2d_wrapper)
___NEED_GLO(___G__23__23_inverse_2d_eval_2d_in_2d_env)
___NEED_GLO(___G__23__23_locat_2d_container)
___NEED_GLO(___G__23__23_locat_2d_position)
___NEED_GLO(___G__23__23_main_2d_window)
___NEED_GLO(___G__23__23_make_2d_mutex)
___NEED_GLO(___G__23__23_make_2d_repl_2d_channel_2d_guide)
___NEED_GLO(___G__23__23_newline)
___NEED_GLO(___G__23__23_object_2d__3e_string)
___NEED_GLO(___G__23__23_open_2d_output_2d_string)
___NEED_GLO(___G__23__23_open_2d_string_2d_pipe)
___NEED_GLO(___G__23__23_output_2d_port_2d_column_2d_set_21_)
___NEED_GLO(___G__23__23_peek_2d_char)
___NEED_GLO(___G__23__23_position_2d__3e_filepos)
___NEED_GLO(___G__23__23_pretty_2d_print)
___NEED_GLO(___G__23__23_procedure_2d_name)
___NEED_GLO(___G__23__23_read_2d_expr_2d_from_2d_port)
___NEED_GLO(___G__23__23_read_2d_line)
___NEED_GLO(___G__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___NEED_GLO(___G__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___NEED_GLO(___G__23__23_still_2d_copy)
___NEED_GLO(___G__23__23_thread_2d_make_2d_repl_2d_channel)
___NEED_GLO(___G__23__23_thread_2d_sleep_21_)
___NEED_GLO(___G__23__23_thread_2d_start_21_)
___NEED_GLO(___G__23__23_vector_2d__3e_list)
___NEED_GLO(___G__23__23_write)
___NEED_GLO(___G__23__23_write_2d_string)
___NEED_GLO(___G_make_2d_thread)

___BEGIN_SYM1
___DEF_SYM1(0,___S__23__23_type_2d_12_2d_6bf088a7_2d_814f_2d_4139_2d_860a_2d_69a757570569,"##type-12-6bf088a7-814f-4139-860a-69a757570569")

___DEF_SYM1(1,___S__23__23_type_2d_14_2d_e188675f_2d_7d4e_2d_4e1f_2d_8eb0_2d_01a25aae640b,"##type-14-e188675f-7d4e-4e1f-8eb0-01a25aae640b")

___DEF_SYM1(2,___S__23__23_type_2d_17_2d_2babe060_2d_9af6_2d_456f_2d_a26e_2d_40b592f690ec,"##type-17-2babe060-9af6-456f-a26e-40b592f690ec")

___DEF_SYM1(3,___S__23__23_type_2d_6,"##type-6")
___DEF_SYM1(4,___S__23__23_type_2d_7_2d_cd5f5bad_2d_f96f_2d_438d_2d_8d63_2d_ff887b7b39de,"##type-7-cd5f5bad-f96f-438d-8d63-ff887b7b39de")

___DEF_SYM1(5,___S_GuideUiMainWindow_2a_,"GuideUiMainWindow*")
___DEF_SYM1(6,___S_GuideUiScheme,"GuideUiScheme")
___DEF_SYM1(7,___S_GuideUiScheme_2a_,"GuideUiScheme*")
___DEF_SYM1(8,___S_QApplication_2a_,"QApplication*")
___DEF_SYM1(9,___S_cfields,"cfields")
___DEF_SYM1(10,___S_channel,"channel")
___DEF_SYM1(11,___S_close,"close")
___DEF_SYM1(12,___S_cont,"cont")
___DEF_SYM1(13,___S_depth,"depth")
___DEF_SYM1(14,___S_display_2d_continuation,"display-continuation")
___DEF_SYM1(15,___S_display_2d_monoline_2d_message,"display-monoline-message")
___DEF_SYM1(16,___S_display_2d_multiline_2d_message,"display-multiline-message")
___DEF_SYM1(17,___S_far_2d_port,"far-port")
___DEF_SYM1(18,___S_fields,"fields")
___DEF_SYM1(19,___S_flags,"flags")
___DEF_SYM1(20,___S_force_2d_output,"force-output")
___DEF_SYM1(21,___S_id,"id")
___DEF_SYM1(22,___S_initial_2d_cont,"initial-cont")
___DEF_SYM1(23,___S_input_2d_port,"input-port")
___DEF_SYM1(24,___S_interaction,"interaction")
___DEF_SYM1(25,___S_last_2d_owner,"last-owner")
___DEF_SYM1(26,___S_level,"level")
___DEF_SYM1(27,___S_mutex,"mutex")
___DEF_SYM1(28,___S_name,"name")
___DEF_SYM1(29,___S_newline,"newline")
___DEF_SYM1(30,___S_output_2d_port,"output-port")
___DEF_SYM1(31,___S_owner_2d_mutex,"owner-mutex")
___DEF_SYM1(32,___S_pinpoint_2d_continuation,"pinpoint-continuation")
___DEF_SYM1(33,___S_port,"port")
___DEF_SYM1(34,___S_prev_2d_depth,"prev-depth")
___DEF_SYM1(35,___S_prev_2d_level,"prev-level")
___DEF_SYM1(36,___S_read_2d_command,"read-command")
___DEF_SYM1(37,___S_read_2d_datum,"read-datum")
___DEF_SYM1(38,___S_really_2d_exit_3f_,"really-exit?")
___DEF_SYM1(39,___S_repl_2d_channel,"repl-channel")
___DEF_SYM1(40,___S_repl_2d_channel_2d_guide,"repl-channel-guide")
___DEF_SYM1(41,___S_repl_2d_context,"repl-context")
___DEF_SYM1(42,___S_rkind,"rkind")
___DEF_SYM1(43,___S_roptions,"roptions")
___DEF_SYM1(44,___S_rtimeout,"rtimeout")
___DEF_SYM1(45,___S_rtimeout_2d_thunk,"rtimeout-thunk")
___DEF_SYM1(46,___S_set_2d_rtimeout,"set-rtimeout")
___DEF_SYM1(47,___S_set_2d_wtimeout,"set-wtimeout")
___DEF_SYM1(48,___S_super,"super")
___DEF_SYM1(49,___S_type,"type")
___DEF_SYM1(50,___S_wkind,"wkind")
___DEF_SYM1(51,___S_woptions,"woptions")
___DEF_SYM1(52,___S_write_2d_datum,"write-datum")
___DEF_SYM1(53,___S_write_2d_results,"write-results")
___DEF_SYM1(54,___S_wtimeout,"wtimeout")
___DEF_SYM1(55,___S_wtimeout_2d_thunk,"wtimeout-thunk")
___END_SYM1

___BEGIN_KEY1
___DEF_KEY1(0,___K_buffering,"buffering")
___DEF_KEY1(1,___K_permanent_2d_close,"permanent-close")
___END_KEY1

___BEGIN_GLO
___DEF_GLO(0," _guide")
___DEF_GLO(1," _guide#0")
___DEF_GLO(2," _guide#1")
___DEF_GLO(3," _guide#10")
___DEF_GLO(4," _guide#11")
___DEF_GLO(5," _guide#2")
___DEF_GLO(6," _guide#3")
___DEF_GLO(7," _guide#4")
___DEF_GLO(8," _guide#5")
___DEF_GLO(9," _guide#6")
___DEF_GLO(10," _guide#7")
___DEF_GLO(11," _guide#8")
___DEF_GLO(12," _guide#9")
___DEF_GLO(13,"##GuideUiMainWindow-new")
___DEF_GLO(14,"##GuideUiScheme-continuation-set-cell")

___DEF_GLO(15,"##GuideUiScheme-continuation-set-highlight")

___DEF_GLO(16,"##GuideUiScheme-continuation-set-length")

___DEF_GLO(17,"##GuideUiScheme-environment-set-cell")

___DEF_GLO(18,"##GuideUiScheme-environment-set-length")

___DEF_GLO(19,"##GuideUiScheme-highlight-expr-in-console")

___DEF_GLO(20,"##GuideUiScheme-highlight-expr-in-file")

___DEF_GLO(21,"##GuideUiScheme-new")
___DEF_GLO(22,"##GuideUiScheme-print-text")
___DEF_GLO(23,"##GuideUiScheme-typed-eof")
___DEF_GLO(24,"##GuideUiScheme-typed-text")
___DEF_GLO(25,"##QApplication-new")
___DEF_GLO(26,"##QApplication-processEvents")
___DEF_GLO(27,"##guide-main-window")
___DEF_GLO(28,"##main-window")
___DEF_GLO(29,"##make-repl-channel-guide")
___DEF_GLO(30,"##repl-channel-guide-display-continuation")

___DEF_GLO(31,"##repl-channel-guide-pinpoint-continuation")

___DEF_GLO(32,"##thread-make-repl-channel")
___DEF_GLO(33,"##call-with-values")
___DEF_GLO(34,"##close-output-port")
___DEF_GLO(35,"##command-line")
___DEF_GLO(36,"##container->file")
___DEF_GLO(37,"##continuation-creator")
___DEF_GLO(38,"##continuation-locals")
___DEF_GLO(39,"##continuation-locat")
___DEF_GLO(40,"##continuation-next-interesting")
___DEF_GLO(41,"##continuation-ret")
___DEF_GLO(42,"##cte-frame-vars")
___DEF_GLO(43,"##cte-frame?")
___DEF_GLO(44,"##cte-parent-cte")
___DEF_GLO(45,"##cte-top?")
___DEF_GLO(46,"##decomp")
___DEF_GLO(47,"##decompile")
___DEF_GLO(48,"##display-locat")
___DEF_GLO(49,"##dynamic-env->list")
___DEF_GLO(50,"##filepos-col")
___DEF_GLO(51,"##filepos-line")
___DEF_GLO(52,"##for-each")
___DEF_GLO(53,"##force-output")
___DEF_GLO(54,"##get-output-string")
___DEF_GLO(55,"##hidden-local-var?")
___DEF_GLO(56,"##hidden-parameter?")
___DEF_GLO(57,"##input-port-timeout-set!")
___DEF_GLO(58,"##interaction-cte")
___DEF_GLO(59,"##interp-continuation-code")
___DEF_GLO(60,"##interp-continuation-rte")
___DEF_GLO(61,"##interp-continuation?")
___DEF_GLO(62,"##interp-procedure-wrapper")
___DEF_GLO(63,"##inverse-eval-in-env")
___DEF_GLO(64,"##locat-container")
___DEF_GLO(65,"##locat-position")
___DEF_GLO(66,"##make-mutex")
___DEF_GLO(67,"##newline")
___DEF_GLO(68,"##object->string")
___DEF_GLO(69,"##open-output-string")
___DEF_GLO(70,"##open-string-pipe")
___DEF_GLO(71,"##output-port-column-set!")
___DEF_GLO(72,"##peek-char")
___DEF_GLO(73,"##position->filepos")
___DEF_GLO(74,"##pretty-print")
___DEF_GLO(75,"##procedure-name")
___DEF_GLO(76,"##read-expr-from-port")
___DEF_GLO(77,"##read-line")
___DEF_GLO(78,"##still-copy")
___DEF_GLO(79,"##thread-sleep!")
___DEF_GLO(80,"##thread-start!")
___DEF_GLO(81,"##vector->list")
___DEF_GLO(82,"##write")
___DEF_GLO(83,"##write-string")
___DEF_GLO(84,"make-thread")
___END_GLO

___BEGIN_CNS
 ___DEF_CNS(___REF_KEY(0,___K_buffering),___REF_CNS(1))
,___DEF_CNS(___REF_FAL,___REF_CNS(2))
,___DEF_CNS(___REF_KEY(1,___K_permanent_2d_close),___REF_CNS(3))
,___DEF_CNS(___REF_FAL,___REF_NUL)
,___DEF_CNS(___REF_SYM(24,___S_interaction),___REF_NUL)
___END_CNS

___DEF_SUB_STRUCTURE(___X0,7)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(1,___S__23__23_type_2d_14_2d_e188675f_2d_7d4e_2d_4e1f_2d_8eb0_2d_01a25aae640b))
               ___VEC1(___REF_SYM(40,___S_repl_2d_channel_2d_guide))
               ___VEC1(___REF_FIX(15))
               ___VEC1(___REF_SUB(4))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(8))
               ___VEC0
___DEF_SUB_STRUCTURE(___X1,7)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(3,___S__23__23_type_2d_6))
               ___VEC1(___REF_SYM(49,___S_type))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(2))
               ___VEC1(___REF_SUB(3))
               ___VEC0
___DEF_SUB_VEC(___X2,18)
               ___VEC1(___REF_SYM(21,___S_id))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(28,___S_name))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(19,___S_flags))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(48,___S_super))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(18,___S_fields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(9,___S_cfields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X3,6)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FIX(2))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FIX(4))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FIX(6))
               ___VEC0
___DEF_SUB_STRUCTURE(___X4,7)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(0,___S__23__23_type_2d_12_2d_6bf088a7_2d_814f_2d_4139_2d_860a_2d_69a757570569))
               ___VEC1(___REF_SYM(39,___S_repl_2d_channel))
               ___VEC1(___REF_FIX(15))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(5))
               ___VEC1(___REF_SUB(6))
               ___VEC0
___DEF_SUB_VEC(___X5,36)
               ___VEC1(___REF_SYM(31,___S_owner_2d_mutex))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(25,___S_last_2d_owner))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(23,___S_input_2d_port))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(30,___S_output_2d_port))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(36,___S_read_2d_command))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(53,___S_write_2d_results))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(15,___S_display_2d_monoline_2d_message))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(16,___S_display_2d_multiline_2d_message))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(14,___S_display_2d_continuation))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(32,___S_pinpoint_2d_continuation))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(38,___S_really_2d_exit_3f_))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(29,___S_newline))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X6,12)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FIX(2))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FIX(4))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FIX(6))
               ___VEC1(___REF_FIX(7))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FIX(10))
               ___VEC1(___REF_FIX(11))
               ___VEC1(___REF_FIX(12))
               ___VEC0
___DEF_SUB_VEC(___X7,6)
               ___VEC1(___REF_SYM(17,___S_far_2d_port))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(6,___S_GuideUiScheme))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X8,2)
               ___VEC1(___REF_FIX(13))
               ___VEC1(___REF_FIX(14))
               ___VEC0
___DEF_SUB_STRUCTURE(___X9,7)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(2,___S__23__23_type_2d_17_2d_2babe060_2d_9af6_2d_456f_2d_a26e_2d_40b592f690ec))
               ___VEC1(___REF_SYM(33,___S_port))
               ___VEC1(___REF_FIX(15))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(10))
               ___VEC1(___REF_SUB(11))
               ___VEC0
___DEF_SUB_VEC(___X10,51)
               ___VEC1(___REF_SYM(27,___S_mutex))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(42,___S_rkind))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(50,___S_wkind))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(28,___S_name))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(37,___S_read_2d_datum))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(52,___S_write_2d_datum))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(29,___S_newline))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_force_2d_output))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(11,___S_close))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(43,___S_roptions))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(44,___S_rtimeout))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(45,___S_rtimeout_2d_thunk))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(46,___S_set_2d_rtimeout))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(51,___S_woptions))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(54,___S_wtimeout))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(55,___S_wtimeout_2d_thunk))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(47,___S_set_2d_wtimeout))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X11,17)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FIX(2))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FIX(4))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FIX(6))
               ___VEC1(___REF_FIX(7))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FIX(10))
               ___VEC1(___REF_FIX(11))
               ___VEC1(___REF_FIX(12))
               ___VEC1(___REF_FIX(13))
               ___VEC1(___REF_FIX(14))
               ___VEC1(___REF_FIX(15))
               ___VEC1(___REF_FIX(16))
               ___VEC1(___REF_FIX(17))
               ___VEC0
___DEF_SUB_FLO(___X12,-0x100000L,0x0L)
___DEF_SUB_STR(___X13,21)
               ___STR8(42,42,42,32,69,79,70,32)
               ___STR8(97,103,97,105,110,32,116,111)
               ___STR5(32,101,120,105,116)
___DEF_SUB_STR(___X14,1)
               ___STR1(92)
___DEF_SUB_STR(___X15,2)
               ___STR2(62,32)
___DEF_SUB_STRUCTURE(___X16,7)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(4,___S__23__23_type_2d_7_2d_cd5f5bad_2d_f96f_2d_438d_2d_8d63_2d_ff887b7b39de))
               ___VEC1(___REF_SYM(41,___S_repl_2d_context))
               ___VEC1(___REF_FIX(13))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(17))
               ___VEC1(___REF_SUB(18))
               ___VEC0
___DEF_SUB_VEC(___X17,21)
               ___VEC1(___REF_SYM(26,___S_level))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(13,___S_depth))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(10,___S_channel))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(12,___S_cont))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(22,___S_initial_2d_cont))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(35,___S_prev_2d_level))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(34,___S_prev_2d_depth))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X18,7)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FIX(2))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FIX(4))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FIX(6))
               ___VEC1(___REF_FIX(7))
               ___VEC0
___DEF_SUB_STR(___X19,0)
               ___STR0
___DEF_SUB_FLO(___X20,0x3F947AE1L,0x47AE147BL)

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
___END_SUB


#define ___C_LBL_GuideUiScheme_typed_text 5
#define ___C_LBL_GuideUiScheme_typed_eof 8

#define ___C_OBJ_0 ___SYM(8,___S_QApplication_2a_)
#define ___C_OBJ_1 ___SYM(5,___S_GuideUiMainWindow_2a_)
#define ___C_OBJ_2 ___SYM(7,___S_GuideUiScheme_2a_)


#include "_guide.h"
#include "guide.h"

 void GuideUiScheme_typed_text ___P((___SCMOBJ ___arg1,QString ___arg2),(___arg1,___arg2)
___SCMOBJ ___arg1;
QString ___arg2;)
{
#define ___NARGS 2
___BEGIN_SFUN_VOID(___MLBL(___C_LBL_GuideUiScheme_typed_text))
___BEGIN_SFUN_ARG_SCMOBJ(1)
#define ___ARG1 ___arg1
___BEGIN_SFUN_ARG(2,___ARG2)
___BEGIN_SFUN_QString_to_SCMOBJ(___arg2,___ARG2,2)
___BEGIN_SFUN_BODY
___SFUN_ARG(1,___ARG1)
___SFUN_ARG(2,___ARG2)
___SFUN_CALL_VOID
___SFUN_SET_RESULT_VOID
___END_SFUN_BODY
___END_SFUN_QString_to_SCMOBJ(___arg2,___ARG2,2)
___END_SFUN_ARG(2)
#undef ___ARG1
___END_SFUN_ARG_SCMOBJ(1)
___SFUN_ERROR_VOID
___SFUN_SET_RESULT_VOID
___END_SFUN_VOID
#undef ___NARGS
}

 void GuideUiScheme_typed_eof ___P((___SCMOBJ ___arg1),(___arg1)
___SCMOBJ ___arg1;)
{
#define ___NARGS 1
___BEGIN_SFUN_VOID(___MLBL(___C_LBL_GuideUiScheme_typed_eof))
___BEGIN_SFUN_ARG_SCMOBJ(1)
#define ___ARG1 ___arg1
___BEGIN_SFUN_BODY
___SFUN_ARG(1,___ARG1)
___SFUN_CALL_VOID
___SFUN_SET_RESULT_VOID
___END_SFUN_BODY
#undef ___ARG1
___END_SFUN_ARG_SCMOBJ(1)
___SFUN_ERROR_VOID
___SFUN_SET_RESULT_VOID
___END_SFUN_VOID
#undef ___NARGS
}


#undef ___MD_ALL
#define ___MD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide)
___DEF_M_HLBL(___L1__20___guide)
___DEF_M_HLBL(___L2__20___guide)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_GuideUiScheme_2d_typed_2d_text)
___DEF_M_HLBL(___L1__23__23_GuideUiScheme_2d_typed_2d_text)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_GuideUiScheme_2d_typed_2d_eof)
___DEF_M_HLBL(___L1__23__23_GuideUiScheme_2d_typed_2d_eof)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L1__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L2__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L3__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L4__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L5__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L6__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L7__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L8__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L9__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L10__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L11__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L12__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L13__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L14__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L15__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L16__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L17__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L18__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L19__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L20__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L21__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L22__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L23__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L24__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L25__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L26__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L27__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L28__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L29__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L30__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L31__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L32__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L33__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L34__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L35__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L36__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L37__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L38__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L39__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L40__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L41__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L42__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L43__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L44__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L45__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L46__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L47__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L48__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L49__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L50__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L51__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L52__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L53__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L54__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L55__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L56__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L57__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL(___L58__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L1__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L2__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L3__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L4__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L5__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L6__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L7__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L8__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L9__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L10__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L11__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL(___L12__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L1__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L2__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L3__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L4__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L5__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L6__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L7__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L8__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L9__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L10__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L11__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L12__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L13__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L14__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L15__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L16__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L17__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L18__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L19__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L20__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L21__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L22__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L23__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L24__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L25__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L26__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L27__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L28__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L29__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L30__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L31__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L32__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L33__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L34__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L35__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L36__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L37__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L38__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L39__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L40__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L41__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L42__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L43__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L44__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L45__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L46__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L47__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L48__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L49__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L50__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L51__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L52__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L53__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L54__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L55__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L56__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L57__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L58__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L59__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L60__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L61__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L62__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L63__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L64__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L65__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L66__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L67__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L68__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L69__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L70__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L71__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L72__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L73__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L74__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L75__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L76__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L77__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L78__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL(___L79__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L1__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L2__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L3__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L4__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L5__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L6__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L7__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L8__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L9__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L10__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L11__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L12__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L13__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L14__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL(___L15__23__23_guide_2d_main_2d_window)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_0)
___DEF_M_HLBL(___L1__20___guide_23_0)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_1)
___DEF_M_HLBL(___L1__20___guide_23_1)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_2)
___DEF_M_HLBL(___L1__20___guide_23_2)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_3)
___DEF_M_HLBL(___L1__20___guide_23_3)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_4)
___DEF_M_HLBL(___L1__20___guide_23_4)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_5)
___DEF_M_HLBL(___L1__20___guide_23_5)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_6)
___DEF_M_HLBL(___L1__20___guide_23_6)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_7)
___DEF_M_HLBL(___L1__20___guide_23_7)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_8)
___DEF_M_HLBL(___L1__20___guide_23_8)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_9)
___DEF_M_HLBL(___L1__20___guide_23_9)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_10)
___DEF_M_HLBL(___L1__20___guide_23_10)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___guide_23_11)
___DEF_M_HLBL(___L1__20___guide_23_11)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide)
___DEF_P_HLBL(___L1__20___guide)
___DEF_P_HLBL(___L2__20___guide)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___guide)
   ___SET_GLO(25,___G__23__23_QApplication_2d_new,___PRC(183))
   ___SET_GLO(26,___G__23__23_QApplication_2d_processEvents,___PRC(186))
   ___SET_GLO(13,___G__23__23_GuideUiMainWindow_2d_new,___PRC(189))
   ___SET_GLO(21,___G__23__23_GuideUiScheme_2d_new,___PRC(192))
   ___SET_GLO(22,___G__23__23_GuideUiScheme_2d_print_2d_text,___PRC(195))
   ___SET_GLO(15,___G__23__23_GuideUiScheme_2d_continuation_2d_set_2d_highlight,___PRC(198))
   ___SET_GLO(14,___G__23__23_GuideUiScheme_2d_continuation_2d_set_2d_cell,___PRC(201))
   ___SET_GLO(16,___G__23__23_GuideUiScheme_2d_continuation_2d_set_2d_length,___PRC(204))
   ___SET_GLO(17,___G__23__23_GuideUiScheme_2d_environment_2d_set_2d_cell,___PRC(207))
   ___SET_GLO(18,___G__23__23_GuideUiScheme_2d_environment_2d_set_2d_length,___PRC(210))
   ___SET_GLO(19,___G__23__23_GuideUiScheme_2d_highlight_2d_expr_2d_in_2d_console,___PRC(213))
   ___SET_GLO(20,___G__23__23_GuideUiScheme_2d_highlight_2d_expr_2d_in_2d_file,___PRC(216))
   ___SET_GLO(32,___G__23__23_thread_2d_make_2d_repl_2d_channel,___LBL(1))
   ___SET_GLO(28,___G__23__23_main_2d_window,___FAL)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(1,0,0,0)
   ___POLL(2)
___DEF_SLBL(2,___L2__20___guide)
   ___JUMPINT(___SET_NARGS(0),___PRC(11),___L__23__23_make_2d_repl_2d_channel_2d_guide)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_GuideUiScheme_2d_typed_2d_text
#undef ___PH_LBL0
#define ___PH_LBL0 5
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_GuideUiScheme_2d_typed_2d_text)
___DEF_P_HLBL(___L1__23__23_GuideUiScheme_2d_typed_2d_text)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_GuideUiScheme_2d_typed_2d_text)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_GuideUiScheme_2d_typed_2d_text)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(13L),___SUB(0),___FAL))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_GuideUiScheme_2d_typed_2d_text)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),83,___G__23__23_write_2d_string)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_GuideUiScheme_2d_typed_2d_eof
#undef ___PH_LBL0
#define ___PH_LBL0 8
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_GuideUiScheme_2d_typed_2d_eof)
___DEF_P_HLBL(___L1__23__23_GuideUiScheme_2d_typed_2d_eof)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_GuideUiScheme_2d_typed_2d_eof)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_GuideUiScheme_2d_typed_2d_eof)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(13L),___SUB(0),___FAL))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_GuideUiScheme_2d_typed_2d_eof)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),34,___G__23__23_close_2d_output_2d_port)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_repl_2d_channel_2d_guide
#undef ___PH_LBL0
#define ___PH_LBL0 11
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L1__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L2__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L3__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L4__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L5__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L6__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L7__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L8__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L9__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L10__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L11__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L12__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L13__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L14__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L15__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L16__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L17__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L18__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L19__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L20__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L21__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L22__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L23__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L24__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L25__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L26__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L27__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L28__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L29__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L30__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L31__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L32__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L33__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L34__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L35__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L36__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L37__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L38__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L39__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L40__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L41__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L42__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L43__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L44__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L45__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L46__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L47__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L48__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L49__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L50__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L51__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L52__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L53__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L54__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L55__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L56__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L57__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_P_HLBL(___L58__23__23_make_2d_repl_2d_channel_2d_guide)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___CURRENTTHREAD)
   ___SET_STK(1,___LBL(57))
   ___SET_STK(2,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(2),3)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(2))
   ___SET_R1(___STK(1))
   ___ADJFP(2)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_make_2d_repl_2d_channel_2d_guide)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_make_2d_repl_2d_channel_2d_guide)
   ___ADJFP(-2)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),33,___G__23__23_call_2d_with_2d_values)
___DEF_SLBL(3,___L3__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(3,2,0,0)
   ___SET_STK(1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),56)
   ___ADD_CLO_ELEM(0,___CLO(___R4,1))
   ___END_SETUP_CLO(1)
   ___UNCHECKEDSTRUCTURESET(___R1,___STK(1),___FIX(4L),___SUB(9),___FAL)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R4)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4__23__23_make_2d_repl_2d_channel_2d_guide)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),66,___G__23__23_make_2d_mutex)
___DEF_SLBL(6,___L6__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R2(___CURRENTTHREAD)
   ___BEGIN_ALLOC_STRUCTURE(15)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___R1)
   ___ADD_STRUCTURE_ELEM(2,___R2)
   ___ADD_STRUCTURE_ELEM(3,___STK(-5))
   ___ADD_STRUCTURE_ELEM(4,___STK(-5))
   ___ADD_STRUCTURE_ELEM(5,___LBL(46))
   ___ADD_STRUCTURE_ELEM(6,___LBL(41))
   ___ADD_STRUCTURE_ELEM(7,___LBL(37))
   ___ADD_STRUCTURE_ELEM(8,___LBL(35))
   ___ADD_STRUCTURE_ELEM(9,___PRC(85))
   ___ADD_STRUCTURE_ELEM(10,___PRC(71))
   ___ADD_STRUCTURE_ELEM(11,___LBL(31))
   ___ADD_STRUCTURE_ELEM(12,___LBL(29))
   ___ADD_STRUCTURE_ELEM(13,___STK(-4))
   ___ADD_STRUCTURE_ELEM(14,___FAL)
   ___END_ALLOC_STRUCTURE(15)
   ___SET_R1(___GET_STRUCTURE(15))
   ___SET_R0(___LBL(8))
   ___ADJFP(-4)
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),78,___G__23__23_still_2d_copy)
___DEF_SLBL(8,___L8__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(-1,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(0),___PRC(166),___L__23__23_guide_2d_main_2d_window)
___DEF_SLBL(9,___L9__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(0,___R1)
   ___SET_R1(___CLO(___STK(-2),1))
   ___SET_R0(___LBL(10))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),68,___G__23__23_object_2d__3e_string)
___DEF_SLBL(10,___L10__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R0(___LBL(11))
   ___SET_R1(___STK(-4))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(192),___L__20___guide_23_3)
___DEF_SLBL(11,___L11__23__23_make_2d_repl_2d_channel_2d_guide)
   ___UNCHECKEDSTRUCTURESET(___STK(-1),___R1,___FIX(14L),___SUB(0),___FAL)
   ___SET_STK(0,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(0),18)
   ___ADD_CLO_ELEM(0,___STK(-1))
   ___END_SETUP_CLO(1)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(13))
   ___CHECK_HEAP(12,4096)
___DEF_SLBL(12,___L12__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),84,___G_make_2d_thread)
___DEF_SLBL(13,___L13__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),80,___G__23__23_thread_2d_start_21_)
___DEF_SLBL(14,___L14__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___STK(-1))
   ___POLL(15)
___DEF_SLBL(15,___L15__23__23_make_2d_repl_2d_channel_2d_guide)
   ___GOTO(___L59__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_SLBL(16,___L16__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___BOOLEAN(___CHARP(___R1)))
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___POLL(17)
___DEF_SLBL(17,___L17__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_GLBL(___L59__23__23_make_2d_repl_2d_channel_2d_guide)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(18,___L18__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(18,0,0,0)
   ___SET_R3(___CLO(___R4,1))
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R3,___FIX(13L),___SUB(0),___FAL))
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(19)
___DEF_SLBL(19,___L19__23__23_make_2d_repl_2d_channel_2d_guide)
   ___GOTO(___L60__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_SLBL(20,___L20__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R2(___STK(-1))
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(21)
___DEF_SLBL(21,___L21__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_GLBL(___L60__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(23))
   ___ADJFP(4)
   ___POLL(22)
___DEF_SLBL(22,___L22__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),72,___G__23__23_peek_2d_char)
___DEF_SLBL(23,___L23__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___STK(-1))
   ___SET_R2(___SUB(12))
   ___SET_R0(___LBL(28))
   ___GOTO(___L61__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_SLBL(24,___L24__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(0,___R1)
   ___SET_R1(___STK(-1))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(27))
   ___ADJFP(4)
___DEF_GLBL(___L61__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R3(___LBL(26))
   ___POLL(25)
___DEF_SLBL(25,___L25__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),57,___G__23__23_input_2d_port_2d_timeout_2d_set_21_)
___DEF_SLBL(26,___L26__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(26,0,0,0)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(27,___L27__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R2(___STK(-4))
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-6),___FIX(14L),___SUB(0),___FAL))
   ___SET_R0(___LBL(20))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(195),___L__20___guide_23_4)
___DEF_SLBL(28,___L28__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(1,___STK(-1))
   ___SET_R3(___FAL)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(24))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),77,___G__23__23_read_2d_line)
___DEF_SLBL(29,___L29__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(29,1,0,0)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(4),___FAL))
   ___POLL(30)
___DEF_SLBL(30,___L30__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),67,___G__23__23_newline)
___DEF_SLBL(31,___L31__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(31,1,0,0)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(4),___FAL))
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(4),___FAL))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(13))
   ___SET_R0(___LBL(33))
   ___ADJFP(4)
   ___POLL(32)
___DEF_SLBL(32,___L32__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),83,___G__23__23_write_2d_string)
___DEF_SLBL(33,___L33__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),67,___G__23__23_newline)
___DEF_SLBL(34,___L34__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),72,___G__23__23_peek_2d_char)
___DEF_SLBL(35,___L35__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(35,2,0,0)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(4),___FAL))
   ___POLL(36)
___DEF_SLBL(36,___L36__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___DEF_SLBL(37,___L37__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(37,2,0,0)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(4),___FAL))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(39))
   ___ADJFP(4)
   ___POLL(38)
___DEF_SLBL(38,___L38__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___DEF_SLBL(39,___L39__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-3))
   ___POLL(40)
___DEF_SLBL(40,___L40__23__23_make_2d_repl_2d_channel_2d_guide)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),67,___G__23__23_newline)
___DEF_SLBL(41,___L41__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(41,2,0,0)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(4),___FAL))
   ___SET_STK(1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),44)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___CHECK_HEAP(42,4096)
___DEF_SLBL(42,___L42__23__23_make_2d_repl_2d_channel_2d_guide)
   ___POLL(43)
___DEF_SLBL(43,___L43__23__23_make_2d_repl_2d_channel_2d_guide)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),52,___G__23__23_for_2d_each)
___DEF_SLBL(44,___L44__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(44,1,0,0)
   ___IF(___EQP(___R1,___VOID))
   ___GOTO(___L62__23__23_make_2d_repl_2d_channel_2d_guide)
   ___END_IF
   ___SET_R2(___CLO(___R4,1))
   ___POLL(45)
___DEF_SLBL(45,___L45__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),74,___G__23__23_pretty_2d_print)
___DEF_GLBL(___L62__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(46,___L46__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(46,3,0,0)
   ___SET_R4(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(4),___FAL))
   ___IF(___NOT(___FIXLT(___FIX(0L),___R2)))
   ___GOTO(___L63__23__23_make_2d_repl_2d_channel_2d_guide)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R4)
   ___SET_STK(5,___R2)
   ___SET_R2(___R4)
   ___SET_R1(___STK(5))
   ___SET_R0(___LBL(48))
   ___ADJFP(8)
   ___POLL(47)
___DEF_SLBL(47,___L47__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),82,___G__23__23_write)
___DEF_SLBL(48,___L48__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R4(___STK(-4))
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___FIXLT(___FIX(0L),___R3))
   ___GOTO(___L64__23__23_make_2d_repl_2d_channel_2d_guide)
   ___END_IF
   ___GOTO(___L65__23__23_make_2d_repl_2d_channel_2d_guide)
___DEF_GLBL(___L63__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF(___NOT(___FIXLT(___FIX(0L),___R3)))
   ___GOTO(___L65__23__23_make_2d_repl_2d_channel_2d_guide)
   ___END_IF
___DEF_GLBL(___L64__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R4)
   ___SET_R2(___R4)
   ___SET_R1(___SUB(14))
   ___SET_R0(___LBL(50))
   ___ADJFP(8)
   ___POLL(49)
___DEF_SLBL(49,___L49__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),83,___G__23__23_write_2d_string)
___DEF_SLBL(50,___L50__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(51))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),82,___G__23__23_write)
___DEF_SLBL(51,___L51__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R4(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L65__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R4)
   ___SET_R2(___R4)
   ___SET_R1(___SUB(15))
   ___SET_R0(___LBL(53))
   ___ADJFP(4)
   ___POLL(52)
___DEF_SLBL(52,___L52__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),83,___G__23__23_write_2d_string)
___DEF_SLBL(53,___L53__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(54))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),53,___G__23__23_force_2d_output)
___DEF_SLBL(54,___L54__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-2),___FIX(3L),___SUB(4),___FAL))
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___STK(-2),___FIX(4L),___SUB(4),___FAL))
   ___SET_STK(-2,___R2)
   ___SET_R0(___LBL(55))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),76,___G__23__23_read_2d_expr_2d_from_2d_port)
___DEF_SLBL(55,___L55__23__23_make_2d_repl_2d_channel_2d_guide)
   ___SET_STK(-1,___R1)
   ___SET_R1(___STK(-2))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),71,___G__23__23_output_2d_port_2d_column_2d_set_21_)
___DEF_SLBL(56,___L56__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(56,1,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(57,___L57__23__23_make_2d_repl_2d_channel_2d_guide)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(57,0,0,0)
   ___SET_R1(___CNS(0))
   ___POLL(58)
___DEF_SLBL(58,___L58__23__23_make_2d_repl_2d_channel_2d_guide)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),70,___G__23__23_open_2d_string_2d_pipe)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation
#undef ___PH_LBL0
#define ___PH_LBL0 71
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L1__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L2__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L3__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L4__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L5__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L6__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L7__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L8__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L9__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L10__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L11__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_P_HLBL(___L12__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___ADJFP(1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L17__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),39,___G__23__23_continuation_2d_locat)
___DEF_SLBL(2,___L2__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_STK(-1,___R1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L14__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___GOTO(___L13__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_SLBL(4,___L4__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R1(___TRU)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
___DEF_GLBL(___L13__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L14__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),65,___G__23__23_locat_2d_position)
___DEF_SLBL(6,___L6__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),73,___G__23__23_position_2d__3e_filepos)
___DEF_SLBL(7,___L7__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_STK(0,___R1)
   ___SET_R0(___LBL(8))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),51,___G__23__23_filepos_2d_line)
___DEF_SLBL(8,___L8__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),50,___G__23__23_filepos_2d_col)
___DEF_SLBL(9,___L9__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),64,___G__23__23_locat_2d_container)
___DEF_SLBL(10,___L10__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),36,___G__23__23_container_2d__3e_file)
___DEF_SLBL(11,___L11__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L16__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___END_IF
   ___IF(___THREADP(___STK(-5)))
   ___GOTO(___L15__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(12)
___DEF_SLBL(12,___L12__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L15__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(20L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___SET_R1(___CDR(___R1))
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(16),___FAL))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-3))
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(14L),___SUB(0),___FAL))
   ___SET_R0(___LBL(4))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(213),___L__20___guide_23_10)
___DEF_GLBL(___L16__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___STK(-7),___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(-7,___STK(-3))
   ___SET_STK(-3,___R2)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(4))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(216),___L__20___guide_23_11)
___DEF_GLBL(___L17__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation
#undef ___PH_LBL0
#define ___PH_LBL0 85
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L1__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L2__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L3__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L4__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L5__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L6__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L7__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L8__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L9__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L10__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L11__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L12__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L13__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L14__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L15__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L16__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L17__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L18__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L19__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L20__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L21__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L22__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L23__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L24__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L25__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L26__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L27__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L28__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L29__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L30__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L31__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L32__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L33__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L34__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L35__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L36__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L37__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L38__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L39__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L40__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L41__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L42__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L43__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L44__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L45__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L46__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L47__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L48__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L49__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L50__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L51__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L52__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L53__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L54__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L55__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L56__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L57__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L58__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L59__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L60__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L61__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L62__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L63__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L64__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L65__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L66__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L67__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L68__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L69__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L70__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L71__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L72__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L73__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L74__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L75__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L76__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L77__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L78__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_P_HLBL(___L79__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R3)
   ___SET_R3(___R2)
   ___SET_R1(___STK(2))
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L80__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(3,___L3__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L80__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R3)))
   ___GOTO(___L81__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(0),___FIX(14L),___SUB(0),___FAL))
   ___SET_R0(___LBL(6))
   ___ADJFP(3)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPINT(___SET_NARGS(2),___PRC(204),___L__20___guide_23_7)
___DEF_SLBL(6,___L6__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___STK(-1))
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-3),___FIX(14L),___SUB(0),___FAL))
   ___SET_R0(___STK(-2))
   ___POLL(7)
___DEF_SLBL(7,___L7__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(198),___L__20___guide_23_5)
___DEF_GLBL(___L81__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___STK(4))
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(28))
   ___ADJFP(7)
   ___POLL(8)
___DEF_SLBL(8,___L8__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(9,___R1)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(10))
   ___ADJFP(12)
   ___POLL(9)
___DEF_SLBL(9,___L9__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),68,___G__23__23_object_2d__3e_string)
___DEF_SLBL(10,___L10__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(11))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(201),___L__20___guide_23_6)
___DEF_SLBL(11,___L11__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-6),___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(1,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(12))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),37,___G__23__23_continuation_2d_creator)
___DEF_SLBL(12,___L12__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L90__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R1(___CNS(4))
   ___GOTO(___L82__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(13,___L13__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L82__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),68,___G__23__23_object_2d__3e_string)
___DEF_SLBL(14,___L14__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(15))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(201),___L__20___guide_23_6)
___DEF_SLBL(15,___L15__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-6),___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(1,___R1)
   ___SET_R0(___LBL(16))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),69,___G__23__23_open_2d_output_2d_string)
___DEF_SLBL(16,___L16__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),39,___G__23__23_continuation_2d_locat)
___DEF_SLBL(17,___L17__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___STK(-7))
   ___SET_R2(___TRU)
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),48,___G__23__23_display_2d_locat)
___DEF_SLBL(18,___L18__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),54,___G__23__23_get_2d_output_2d_string)
___DEF_SLBL(19,___L19__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R2(___FIX(2L))
   ___SET_R0(___LBL(20))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(201),___L__20___guide_23_6)
___DEF_SLBL(20,___L20__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-6),___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(-6,___STK(-7))
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),61,___G__23__23_interp_2d_continuation_3f_)
___DEF_SLBL(21,___L21__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L89__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),41,___G__23__23_continuation_2d_ret)
___DEF_SLBL(22,___L22__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),47,___G__23__23_decompile)
___DEF_SLBL(23,___L23__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___EQP(___R1,___STK(-5)))
   ___GOTO(___L83__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___GOTO(___L88__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(24,___L24__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___VECTORREF(___R1,___FIX(1L)))
   ___IF(___NOT(___EQP(___R2,___GLO(62,___G__23__23_interp_2d_procedure_2d_wrapper))))
   ___GOTO(___L87__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
___DEF_GLBL(___L83__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___FAL)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L86__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
___DEF_GLBL(___L84__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___SUB(19))
___DEF_GLBL(___L85__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(3L))
   ___SET_R0(___STK(-6))
   ___POLL(25)
___DEF_SLBL(25,___L25__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(201),___L__20___guide_23_6)
___DEF_SLBL(26,___L26__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L84__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
___DEF_GLBL(___L86__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___FIX(100L))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),68,___G__23__23_object_2d__3e_string)
___DEF_SLBL(27,___L27__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L85__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L87__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),46,___G__23__23_decomp)
___DEF_GLBL(___L88__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L84__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___GOTO(___L86__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L89__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),59,___G__23__23_interp_2d_continuation_2d_code)
___DEF_GLBL(___L90__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),75,___G__23__23_procedure_2d_name)
___DEF_SLBL(28,___L28__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FIXEQ(___STK(-4),___STK(-5))))
   ___GOTO(___L110__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(79))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(30))
   ___ADJFP(4)
   ___POLL(29)
___DEF_SLBL(29,___L29__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),61,___G__23__23_interp_2d_continuation_3f_)
___DEF_SLBL(30,___L30__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L102__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_STK(1,___STK(-2))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(31))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),38,___G__23__23_continuation_2d_locals)
___DEF_SLBL(31,___L31__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___FIX(0L))
   ___SET_R2(___GLO(58,___G__23__23_interaction_2d_cte))
   ___SET_R0(___LBL(52))
   ___ADJFP(-3)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L96__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___POLL(32)
___DEF_SLBL(32,___L32__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(33)
___DEF_SLBL(33,___L33__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L91__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(34,___L34__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___FIXADD(___STK(-2),___FIX(1L)))
   ___SET_R3(___R1)
   ___SET_R1(___CDR(___STK(-3)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-5))
   ___ADJFP(-7)
   ___POLL(35)
___DEF_SLBL(35,___L35__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L91__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L96__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___CAR(___R4))
   ___SET_R4(___CDR(___R4))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(8,___STK(0))
   ___SET_STK(9,___STK(1))
   ___SET_R2(___R1)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(34))
   ___ADJFP(9)
   ___POLL(36)
___DEF_SLBL(36,___L36__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L92__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(38))
   ___ADJFP(6)
   ___POLL(37)
___DEF_SLBL(37,___L37__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),68,___G__23__23_object_2d__3e_string)
___DEF_SLBL(38,___L38__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(39))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),45,___G__23__23_cte_2d_top_3f_)
___DEF_SLBL(39,___L39__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L93__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(40))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),44,___G__23__23_cte_2d_parent_2d_cte)
___DEF_SLBL(40,___L40__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(41))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),63,___G__23__23_inverse_2d_eval_2d_in_2d_env)
___DEF_SLBL(41,___L41__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___FIX(100L))
   ___SET_R0(___LBL(42))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),68,___G__23__23_object_2d__3e_string)
___DEF_SLBL(42,___L42__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(-4,___R1)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-7),___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(1,___R1)
   ___SET_R3(___STK(-6))
   ___SET_R1(___STK(-2))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(43))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(207),___L__20___guide_23_8)
___DEF_SLBL(43,___L43__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-7),___FIX(14L),___SUB(0),___FAL))
   ___SET_STK(1,___R1)
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-2))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(44))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(207),___L__20___guide_23_8)
___DEF_SLBL(44,___L44__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___FIXADD(___STK(-2),___FIX(1L)))
   ___POLL(45)
___DEF_SLBL(45,___L45__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___DEF_GLBL(___L93__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(41))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),63,___G__23__23_inverse_2d_eval_2d_in_2d_env)
___DEF_SLBL(46,___L46__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L94__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___CDR(___STK(-3)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-5))
   ___ADJFP(-7)
   ___POLL(47)
___DEF_SLBL(47,___L47__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L95__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L97__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
___DEF_GLBL(___L96__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___R3)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L97__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___CAR(___R4))
   ___SET_R4(___CDR(___R4))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(49))
   ___ADJFP(7)
   ___POLL(48)
___DEF_SLBL(48,___L48__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),56,___G__23__23_hidden_2d_parameter_3f_)
___DEF_SLBL(49,___L49__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L98__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R1(___STK(-2))
   ___GOTO(___L94__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L98__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(50))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),63,___G__23__23_inverse_2d_eval_2d_in_2d_env)
___DEF_SLBL(50,___L50__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___STK(-7))
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_STK(2,___R1)
   ___SET_R3(___STK(-2))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(46))
   ___ADJFP(2)
   ___CHECK_HEAP(51,4096)
___DEF_SLBL(51,___L51__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L92__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(52,___L52__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___CONS(___R1,___GLO(58,___G__23__23_interaction_2d_cte)))
   ___CHECK_HEAP(53,4096)
___DEF_SLBL(53,___L53__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___FALSEP(___STK(-1)))
   ___GOTO(___L99__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___GOTO(___L101__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(54,___L54__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(2L)))
   ___SET_R1(___CONS(___R1,___R2))
   ___ADJFP(-4)
   ___CHECK_HEAP(55,4096)
___DEF_SLBL(55,___L55__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___STK(-1))))
   ___GOTO(___L101__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
___DEF_GLBL(___L99__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___CAR(___R1))
___DEF_GLBL(___L100__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___R1)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-2),___FIX(14L),___SUB(0),___FAL))
   ___SET_R0(___STK(-3))
   ___POLL(56)
___DEF_SLBL(56,___L56__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(210),___L__20___guide_23_9)
___DEF_GLBL(___L101__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___STK(-2))
   ___SET_STK(0,___R1)
   ___SET_R1(___VECTORREF(___STK(-1),___FIX(1L)))
   ___SET_R0(___LBL(57))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),49,___G__23__23_dynamic_2d_env_2d__3e_list)
___DEF_SLBL(57,___L57__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R2(___CAR(___STK(-4)))
   ___SET_R3(___R2)
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R0(___LBL(59))
   ___ADJFP(-3)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(58)
___DEF_SLBL(58,___L58__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L95__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(59,___L59__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L100__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L102__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(60))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),59,___G__23__23_interp_2d_continuation_2d_code)
___DEF_SLBL(60,___L60__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(0,___R1)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(61))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),60,___G__23__23_interp_2d_continuation_2d_rte)
___DEF_SLBL(61,___L61__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___STK(-6))
   ___SET_R2(___R1)
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(2L)))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___LBL(54))
   ___ADJFP(1)
   ___POLL(62)
___DEF_SLBL(62,___L62__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L103__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(63,___L63__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___STK(-3))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(0L)))
   ___SET_R0(___STK(-4))
   ___ADJFP(-7)
   ___POLL(64)
___DEF_SLBL(64,___L64__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L103__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(66))
   ___ADJFP(7)
   ___POLL(65)
___DEF_SLBL(65,___L65__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),45,___G__23__23_cte_2d_top_3f_)
___DEF_SLBL(66,___L66__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L104__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___POLL(67)
___DEF_SLBL(67,___L67__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L104__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(68))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),43,___G__23__23_cte_2d_frame_3f_)
___DEF_SLBL(68,___L68__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L105__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(69))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),44,___G__23__23_cte_2d_parent_2d_cte)
___DEF_SLBL(69,___L69__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(70)
___DEF_SLBL(70,___L70__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L103__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L105__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-1,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(71))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),42,___G__23__23_cte_2d_frame_2d_vars)
___DEF_SLBL(71,___L71__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(-1,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(72))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),81,___G__23__23_vector_2d__3e_list)
___DEF_SLBL(72,___L72__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___CDR(___R1))
   ___SET_R2(___R1)
   ___SET_R3(___STK(-3))
   ___SET_R0(___STK(-2))
   ___SET_R1(___STK(-1))
   ___ADJFP(-5)
   ___POLL(73)
___DEF_SLBL(73,___L73__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___GOTO(___L107__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_SLBL(74,___L74__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L106__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R3(___R1)
   ___SET_R1(___CDR(___STK(-2)))
   ___SET_R2(___R1)
   ___SET_R1(___CDR(___STK(-3)))
   ___SET_R0(___STK(-4))
   ___ADJFP(-5)
   ___POLL(75)
___DEF_SLBL(75,___L75__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L107__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L109__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_R4(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(77))
   ___ADJFP(9)
   ___POLL(76)
___DEF_SLBL(76,___L76__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),55,___G__23__23_hidden_2d_local_2d_var_3f_)
___DEF_SLBL(77,___L77__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L108__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___END_IF
   ___SET_STK(-3,___STK(-11))
   ___SET_STK(-2,___STK(-4))
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-10))
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_R0(___LBL(74))
   ___ADJFP(-2)
   ___GOTO(___L92__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L108__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___STK(-5))
   ___ADJFP(-4)
   ___GOTO(___L106__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L109__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R3)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(63))
   ___ADJFP(5)
   ___POLL(78)
___DEF_SLBL(78,___L78__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),44,___G__23__23_cte_2d_parent_2d_cte)
___DEF_SLBL(79,___L79__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
___DEF_GLBL(___L110__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),40,___G__23__23_continuation_2d_next_2d_interesting)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_guide_2d_main_2d_window
#undef ___PH_LBL0
#define ___PH_LBL0 166
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L1__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L2__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L3__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L4__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L5__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L6__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L7__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L8__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L9__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L10__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L11__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L12__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L13__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L14__23__23_guide_2d_main_2d_window)
___DEF_P_HLBL(___L15__23__23_guide_2d_main_2d_window)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_guide_2d_main_2d_window)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_guide_2d_main_2d_window)
   ___SET_R1(___GLO(28,___G__23__23_main_2d_window))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L17__23__23_guide_2d_main_2d_window)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_guide_2d_main_2d_window)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),35,___G__23__23_command_2d_line)
___DEF_SLBL(2,___L2__23__23_guide_2d_main_2d_window)
   ___SET_R1(___CAR(___R1))
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R0(___LBL(4))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_guide_2d_main_2d_window)
   ___JUMPINT(___SET_NARGS(1),___PRC(183),___L__20___guide_23_0)
___DEF_SLBL(4,___L4__23__23_guide_2d_main_2d_window)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(0),___PRC(189),___L__20___guide_23_2)
___DEF_SLBL(5,___L5__23__23_guide_2d_main_2d_window)
   ___SET_STK(-1,___R1)
   ___SET_STK(0,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(0),10)
   ___ADD_CLO_ELEM(0,___STK(-2))
   ___END_SETUP_CLO(1)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(7))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6__23__23_guide_2d_main_2d_window)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),84,___G_make_2d_thread)
___DEF_SLBL(7,___L7__23__23_guide_2d_main_2d_window)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),80,___G__23__23_thread_2d_start_21_)
___DEF_SLBL(8,___L8__23__23_guide_2d_main_2d_window)
   ___SET_GLO(28,___G__23__23_main_2d_window,___STK(-1))
   ___SET_R1(___STK(-1))
   ___POLL(9)
___DEF_SLBL(9,___L9__23__23_guide_2d_main_2d_window)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(10,___L10__23__23_guide_2d_main_2d_window)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(10,0,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(11)
___DEF_SLBL(11,___L11__23__23_guide_2d_main_2d_window)
   ___GOTO(___L16__23__23_guide_2d_main_2d_window)
___DEF_SLBL(12,___L12__23__23_guide_2d_main_2d_window)
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(13)
___DEF_SLBL(13,___L13__23__23_guide_2d_main_2d_window)
___DEF_GLBL(___L16__23__23_guide_2d_main_2d_window)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___SUB(20))
   ___SET_R0(___LBL(15))
   ___ADJFP(4)
   ___POLL(14)
___DEF_SLBL(14,___L14__23__23_guide_2d_main_2d_window)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),79,___G__23__23_thread_2d_sleep_21_)
___DEF_SLBL(15,___L15__23__23_guide_2d_main_2d_window)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(1),___PRC(186),___L__20___guide_23_1)
___DEF_GLBL(___L17__23__23_guide_2d_main_2d_window)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_0
#undef ___PH_LBL0
#define ___PH_LBL0 183
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_0)
___DEF_P_HLBL(___L1__20___guide_23_0)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_0)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__20___guide_23_0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 1
#define ___result ___CFUN_CAST(QApplication*,___result_voidstar)
___BEGIN_CFUN(void* ___result_voidstar)
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,char** ___arg1)
___BEGIN_CFUN_SCMOBJ_TO_NONNULLCHARSTRINGLIST(___ARG1,___arg1,1)
___BEGIN_CFUN_BODY_CLEANUP
#undef ___AT_END
___CFUN_CALL_POINTER(___result_voidstar,QApplication_new(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_0,___RELEASE_POINTER,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_0,___RELEASE_POINTER,___CFUN_RESULT)
___END_CFUN_BODY_CLEANUP
___END_CFUN_SCMOBJ_TO_NONNULLCHARSTRINGLIST(___ARG1,___arg1,1)
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_CLEANUP
___END_CFUN
#undef ___result
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_0)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_1
#undef ___PH_LBL0
#define ___PH_LBL0 186
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_1)
___DEF_P_HLBL(___L1__20___guide_23_1)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_1)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__20___guide_23_1)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 1
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(QApplication*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(QApplication_processEvents(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_1)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_2
#undef ___PH_LBL0
#define ___PH_LBL0 189
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_2)
___DEF_P_HLBL(___L1__20___guide_23_2)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_2)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___guide_23_2)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
#define ___result ___CFUN_CAST(GuideUiMainWindow*,___result_voidstar)
___BEGIN_CFUN(void* ___result_voidstar)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_POINTER(___result_voidstar,GuideUiMainWindow_new())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_1,___RELEASE_POINTER,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_1,___RELEASE_POINTER,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___result
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_2)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_3
#undef ___PH_LBL0
#define ___PH_LBL0 192
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_3)
___DEF_P_HLBL(___L1__20___guide_23_3)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_3)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__20___guide_23_3)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
#define ___result ___CFUN_CAST(GuideUiScheme*,___result_voidstar)
___BEGIN_CFUN(void* ___result_voidstar)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiMainWindow*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_1,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,QString ___arg2)
___BEGIN_CFUN_SCMOBJ_to_QString(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_POINTER(___result_voidstar,GuideUiScheme_new(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_2,___RELEASE_POINTER,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_2,___RELEASE_POINTER,___CFUN_RESULT)
___END_CFUN_BODY
___END_CFUN_SCMOBJ_to_QString(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_1,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
___CFUN_ERROR
___END_CFUN
#undef ___result
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_3)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_4
#undef ___PH_LBL0
#define ___PH_LBL0 195
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_4)
___DEF_P_HLBL(___L1__20___guide_23_4)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_4)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__20___guide_23_4)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 2
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,QString ___arg2)
___BEGIN_CFUN_SCMOBJ_to_QString(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_print_text(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_to_QString(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_4)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_5
#undef ___PH_LBL0
#define ___PH_LBL0 198
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_5)
___DEF_P_HLBL(___L1__20___guide_23_5)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_5)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__20___guide_23_5)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 2
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_continuation_set_highlight(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_5)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_6
#undef ___PH_LBL0
#define ___PH_LBL0 201
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_6)
___DEF_P_HLBL(___L1__20___guide_23_6)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_6)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__20___guide_23_6)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG(3,int ___arg3)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG(4,QString ___arg4)
___BEGIN_CFUN_SCMOBJ_to_QString(___ARG4,___arg4,4)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_continuation_set_cell(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_to_QString(___ARG4,___arg4,4)
___END_CFUN_ARG(4)
#undef ___ARG4
___END_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
___END_CFUN_ARG(3)
#undef ___ARG3
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_6)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_7
#undef ___PH_LBL0
#define ___PH_LBL0 204
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_7)
___DEF_P_HLBL(___L1__20___guide_23_7)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_7)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__20___guide_23_7)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 2
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_continuation_set_length(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_7)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_8
#undef ___PH_LBL0
#define ___PH_LBL0 207
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_8)
___DEF_P_HLBL(___L1__20___guide_23_8)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_8)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__20___guide_23_8)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG(3,int ___arg3)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG(4,QString ___arg4)
___BEGIN_CFUN_SCMOBJ_to_QString(___ARG4,___arg4,4)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_environment_set_cell(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_to_QString(___ARG4,___arg4,4)
___END_CFUN_ARG(4)
#undef ___ARG4
___END_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
___END_CFUN_ARG(3)
#undef ___ARG3
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_8)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_9
#undef ___PH_LBL0
#define ___PH_LBL0 210
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_9)
___DEF_P_HLBL(___L1__20___guide_23_9)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_9)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__20___guide_23_9)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 2
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_environment_set_length(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_9)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_10
#undef ___PH_LBL0
#define ___PH_LBL0 213
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_10)
___DEF_P_HLBL(___L1__20___guide_23_10)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_10)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__20___guide_23_10)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG(3,int ___arg3)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_highlight_expr_in_console(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
___END_CFUN_ARG(3)
#undef ___ARG3
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_10)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__20___guide_23_11
#undef ___PH_LBL0
#define ___PH_LBL0 216
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___guide_23_11)
___DEF_P_HLBL(___L1__20___guide_23_11)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___guide_23_11)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__20___guide_23_11)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(GuideUiScheme*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG(3,int ___arg3)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG(4,QString ___arg4)
___BEGIN_CFUN_SCMOBJ_to_QString(___ARG4,___arg4,4)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_CALL_VOID(GuideUiScheme_highlight_expr_in_file(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_to_QString(___ARG4,___arg4,4)
___END_CFUN_ARG(4)
#undef ___ARG4
___END_CFUN_SCMOBJ_TO_INT(___ARG3,___arg3,3)
___END_CFUN_ARG(3)
#undef ___ARG3
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_POINTER(___ARG1,___arg1_voidstar,___C_OBJ_2,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1__20___guide_23_11)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___guide,___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__20___guide,0,0)
,___DEF_LBL_PROC(___H__20___guide,0,0)
,___DEF_LBL_RET(___H__20___guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_INTRO(___H__23__23_GuideUiScheme_2d_typed_2d_text,___REF_FAL,2,GuideUiScheme_typed_text)
,___DEF_LBL_PROC(___H__23__23_GuideUiScheme_2d_typed_2d_text,2,0)
,___DEF_LBL_RET(___H__23__23_GuideUiScheme_2d_typed_2d_text,___IFD(___RETI,1,4,0x3F0L))
,___DEF_LBL_INTRO(___H__23__23_GuideUiScheme_2d_typed_2d_eof,___REF_FAL,2,GuideUiScheme_typed_eof)
,___DEF_LBL_PROC(___H__23__23_GuideUiScheme_2d_typed_2d_eof,1,0)
,___DEF_LBL_RET(___H__23__23_GuideUiScheme_2d_typed_2d_eof,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_INTRO(___H__23__23_make_2d_repl_2d_channel_2d_guide,___REF_FAL,59,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,0,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,2,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,2,4,0x3F1L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,2,1)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,8,0,0x3F0FL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,8,0,0x3F0FL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F3L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,7,0,0xDL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x5L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F5L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x5L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x5L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F1L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x1L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F1L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,0,1)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,0,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,1,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,1,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x5L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,2,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,2,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F3L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,4,0x3F0L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,2,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,1,4,0x3F0L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,1,4,0x3F0L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,1,1)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,3,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,8,0,0x3F0FL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,8,0,0x3F0FL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,7,0,0xBL))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,4,0,0x3F7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,1,1)
,___DEF_LBL_PROC(___H__23__23_make_2d_repl_2d_channel_2d_guide,0,0)
,___DEF_LBL_RET(___H__23__23_make_2d_repl_2d_channel_2d_guide,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_INTRO(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___REF_FAL,13,0)
,___DEF_LBL_PROC(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,2,0)
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETI,4,1,0x3F3L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,3,1,0x3L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETI,4,1,0x3F2L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,3,1,0x2L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETI,4,1,0x3F2L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,3,1,0x7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,3,1,0x7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,7,1,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,7,1,0x17L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,7,1,0x1BL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETN,7,1,0x1FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,___IFD(___RETI,8,1,0x3F02L))
,___DEF_LBL_INTRO(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___REF_FAL,80,0)
,___DEF_LBL_PROC(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,3,0)
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,4,1,0x3F7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,3,1,0x7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,4,4,0x3F0L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,1,0x3F1FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,12,0,0x3F10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x11FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x11FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,0,0x10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xBL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xBL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,8,0x3F01L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xBL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0xBL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0x1FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,4,0,0x3F7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0x17L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x3DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,10,2,0x3F33DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,2,0x3F3DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x3DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x3FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x2FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x27L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x27L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x2DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x24L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,2,0x3F04L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x1DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,2,0x3F7FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x7FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,2,0x7DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,10,2,0x3F31DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,4,0,0x3F7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,4,0,0x3F7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,4,4,0x3F0L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0x1BL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,3,0,0x7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,0,0xFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,9,0,0x3F10FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,3,0x1DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,1,0x3F1FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0x1FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,1,0x3F02L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0x1FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0x1BL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,1,4,0x3F1L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,5,0x3FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,5,0x77L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,3,4,0x3F7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,3,0x3FL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,3,4,0x3F7L))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,12,3,0x3F0FFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,11,3,0xFFL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETI,8,3,0x3F1DL))
,___DEF_LBL_RET(___H__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,___IFD(___RETN,7,1,0x1FL))
,___DEF_LBL_INTRO(___H__23__23_guide_2d_main_2d_window,___REF_FAL,16,0)
,___DEF_LBL_PROC(___H__23__23_guide_2d_main_2d_window,0,0)
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,4,0,0x3F1L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x1L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,4,0,0x3F1L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x1L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,4,0,0x3F5L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x5L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x5L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,4,0,0x3F1L))
,___DEF_LBL_PROC(___H__23__23_guide_2d_main_2d_window,0,1)
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,0,0,0x3FL))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETI,4,0,0x3F3L))
,___DEF_LBL_RET(___H__23__23_guide_2d_main_2d_window,___IFD(___RETN,3,0,0x3L))
,___DEF_LBL_INTRO(___H__20___guide_23_0,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_0,1,0)
,___DEF_LBL_RET(___H__20___guide_23_0,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H__20___guide_23_1,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_1,1,0)
,___DEF_LBL_RET(___H__20___guide_23_1,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H__20___guide_23_2,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_2,0,0)
,___DEF_LBL_RET(___H__20___guide_23_2,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__20___guide_23_3,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_3,3,0)
,___DEF_LBL_RET(___H__20___guide_23_3,___IFD(___RETN,4,3,0xFL))
,___DEF_LBL_INTRO(___H__20___guide_23_4,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_4,2,0)
,___DEF_LBL_RET(___H__20___guide_23_4,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H__20___guide_23_5,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_5,2,0)
,___DEF_LBL_RET(___H__20___guide_23_5,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H__20___guide_23_6,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_6,4,0)
,___DEF_LBL_RET(___H__20___guide_23_6,___IFD(___RETN,5,4,0x1FL))
,___DEF_LBL_INTRO(___H__20___guide_23_7,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_7,2,0)
,___DEF_LBL_RET(___H__20___guide_23_7,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H__20___guide_23_8,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_8,4,0)
,___DEF_LBL_RET(___H__20___guide_23_8,___IFD(___RETN,5,4,0x1FL))
,___DEF_LBL_INTRO(___H__20___guide_23_9,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_9,2,0)
,___DEF_LBL_RET(___H__20___guide_23_9,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H__20___guide_23_10,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_10,3,0)
,___DEF_LBL_RET(___H__20___guide_23_10,___IFD(___RETN,4,3,0xFL))
,___DEF_LBL_INTRO(___H__20___guide_23_11,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___guide_23_11,4,0)
,___DEF_LBL_RET(___H__20___guide_23_11,___IFD(___RETN,5,4,0x1FL))
___END_LBL

___BEGIN_MOD1
___DEF_PRM(0,___G__20___guide,1)
___DEF_PRM(24,___G__23__23_GuideUiScheme_2d_typed_2d_text,5)
___DEF_PRM(23,___G__23__23_GuideUiScheme_2d_typed_2d_eof,8)
___DEF_PRM(29,___G__23__23_make_2d_repl_2d_channel_2d_guide,11)
___DEF_PRM(31,___G__23__23_repl_2d_channel_2d_guide_2d_pinpoint_2d_continuation,71)
___DEF_PRM(30,___G__23__23_repl_2d_channel_2d_guide_2d_display_2d_continuation,85)
___DEF_PRM(27,___G__23__23_guide_2d_main_2d_window,166)
___DEF_PRM(1,___G__20___guide_23_0,183)
___DEF_PRM(2,___G__20___guide_23_1,186)
___DEF_PRM(5,___G__20___guide_23_2,189)
___DEF_PRM(6,___G__20___guide_23_3,192)
___DEF_PRM(7,___G__20___guide_23_4,195)
___DEF_PRM(8,___G__20___guide_23_5,198)
___DEF_PRM(9,___G__20___guide_23_6,201)
___DEF_PRM(10,___G__20___guide_23_7,204)
___DEF_PRM(11,___G__20___guide_23_8,207)
___DEF_PRM(12,___G__20___guide_23_9,210)
___DEF_PRM(3,___G__20___guide_23_10,213)
___DEF_PRM(4,___G__20___guide_23_11,216)
___END_MOD1

___BEGIN_MOD2
___DEF_SYM2(0,___S__23__23_type_2d_12_2d_6bf088a7_2d_814f_2d_4139_2d_860a_2d_69a757570569,"##type-12-6bf088a7-814f-4139-860a-69a757570569")

___DEF_SYM2(1,___S__23__23_type_2d_14_2d_e188675f_2d_7d4e_2d_4e1f_2d_8eb0_2d_01a25aae640b,"##type-14-e188675f-7d4e-4e1f-8eb0-01a25aae640b")

___DEF_SYM2(2,___S__23__23_type_2d_17_2d_2babe060_2d_9af6_2d_456f_2d_a26e_2d_40b592f690ec,"##type-17-2babe060-9af6-456f-a26e-40b592f690ec")

___DEF_SYM2(3,___S__23__23_type_2d_6,"##type-6")
___DEF_SYM2(4,___S__23__23_type_2d_7_2d_cd5f5bad_2d_f96f_2d_438d_2d_8d63_2d_ff887b7b39de,"##type-7-cd5f5bad-f96f-438d-8d63-ff887b7b39de")

___DEF_SYM2(5,___S_GuideUiMainWindow_2a_,"GuideUiMainWindow*")
___DEF_SYM2(6,___S_GuideUiScheme,"GuideUiScheme")
___DEF_SYM2(7,___S_GuideUiScheme_2a_,"GuideUiScheme*")
___DEF_SYM2(8,___S_QApplication_2a_,"QApplication*")
___DEF_SYM2(9,___S_cfields,"cfields")
___DEF_SYM2(10,___S_channel,"channel")
___DEF_SYM2(11,___S_close,"close")
___DEF_SYM2(12,___S_cont,"cont")
___DEF_SYM2(13,___S_depth,"depth")
___DEF_SYM2(14,___S_display_2d_continuation,"display-continuation")
___DEF_SYM2(15,___S_display_2d_monoline_2d_message,"display-monoline-message")
___DEF_SYM2(16,___S_display_2d_multiline_2d_message,"display-multiline-message")
___DEF_SYM2(17,___S_far_2d_port,"far-port")
___DEF_SYM2(18,___S_fields,"fields")
___DEF_SYM2(19,___S_flags,"flags")
___DEF_SYM2(20,___S_force_2d_output,"force-output")
___DEF_SYM2(21,___S_id,"id")
___DEF_SYM2(22,___S_initial_2d_cont,"initial-cont")
___DEF_SYM2(23,___S_input_2d_port,"input-port")
___DEF_SYM2(24,___S_interaction,"interaction")
___DEF_SYM2(25,___S_last_2d_owner,"last-owner")
___DEF_SYM2(26,___S_level,"level")
___DEF_SYM2(27,___S_mutex,"mutex")
___DEF_SYM2(28,___S_name,"name")
___DEF_SYM2(29,___S_newline,"newline")
___DEF_SYM2(30,___S_output_2d_port,"output-port")
___DEF_SYM2(31,___S_owner_2d_mutex,"owner-mutex")
___DEF_SYM2(32,___S_pinpoint_2d_continuation,"pinpoint-continuation")
___DEF_SYM2(33,___S_port,"port")
___DEF_SYM2(34,___S_prev_2d_depth,"prev-depth")
___DEF_SYM2(35,___S_prev_2d_level,"prev-level")
___DEF_SYM2(36,___S_read_2d_command,"read-command")
___DEF_SYM2(37,___S_read_2d_datum,"read-datum")
___DEF_SYM2(38,___S_really_2d_exit_3f_,"really-exit?")
___DEF_SYM2(39,___S_repl_2d_channel,"repl-channel")
___DEF_SYM2(40,___S_repl_2d_channel_2d_guide,"repl-channel-guide")
___DEF_SYM2(41,___S_repl_2d_context,"repl-context")
___DEF_SYM2(42,___S_rkind,"rkind")
___DEF_SYM2(43,___S_roptions,"roptions")
___DEF_SYM2(44,___S_rtimeout,"rtimeout")
___DEF_SYM2(45,___S_rtimeout_2d_thunk,"rtimeout-thunk")
___DEF_SYM2(46,___S_set_2d_rtimeout,"set-rtimeout")
___DEF_SYM2(47,___S_set_2d_wtimeout,"set-wtimeout")
___DEF_SYM2(48,___S_super,"super")
___DEF_SYM2(49,___S_type,"type")
___DEF_SYM2(50,___S_wkind,"wkind")
___DEF_SYM2(51,___S_woptions,"woptions")
___DEF_SYM2(52,___S_write_2d_datum,"write-datum")
___DEF_SYM2(53,___S_write_2d_results,"write-results")
___DEF_SYM2(54,___S_wtimeout,"wtimeout")
___DEF_SYM2(55,___S_wtimeout_2d_thunk,"wtimeout-thunk")
___DEF_KEY2(0,___K_buffering,"buffering")
___DEF_KEY2(1,___K_permanent_2d_close,"permanent-close")
___END_MOD2

#endif
