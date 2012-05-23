#ifdef ___LINKER_INFO
; File: "_utils.c", produced by Gambit-C v4.6.6
(
406006
" _utils"
(" _utils")
(
)
(
"test"
)
(
" _utils"
"c#compiler-abort"
"c#compiler-internal-error"
"c#every?"
"c#gnode-find-depvars"
"c#gnodes-remove"
"c#keep"
"c#last-pair"
"c#list->varset"
"c#list->vect"
"c#list-length"
"c#ptset-empty-set"
"c#remove-cycle"
"c#remove-no-depvars"
"c#reverse-append!"
"c#sort-list"
"c#stretch-vector"
"c#stretchable-vector-ref"
"c#stretchable-vector-set!"
"c#throw-to-exception-handler"
"c#varset-<"
"c#varset->list"
"c#varset-difference"
"c#varset-empty"
"c#varset-empty?"
"c#varset-equal?"
"c#varset-member?"
"c#varset-reverse-append!"
"c#varset-singleton"
"c#varset-size"
"c#varset-union"
"c#varset-union-multi"
"c#vect->list"
"c#warnings-requested?"
)
(
"c#append-lists"
"c#bits-and"
"c#bits-or"
"c#bits-shl"
"c#bits-shr"
"c#compiler-error"
"c#compiler-limitation-error"
"c#compiler-user-error"
"c#compiler-user-warning"
"c#drop"
"c#for-each-index"
"c#gnode-depvars"
"c#gnode-var"
"c#list->queue"
"c#list->str"
"c#make-counter"
"c#make-gnode"
"c#make-ordered-table"
"c#make-stretchable-vector"
"c#n-ary"
"c#object-pos-in-list"
"c#ordered-table->list"
"c#ordered-table-enter"
"c#ordered-table-index"
"c#ordered-table-length"
"c#ordered-table-lookup"
"c#pair-up"
"c#pos-in-list"
"c#ptset->list"
"c#ptset-adjoin"
"c#ptset-empty"
"c#ptset-empty?"
"c#ptset-every?"
"c#ptset-member?"
"c#ptset-remove"
"c#ptset-size"
"c#queue->list"
"c#queue-empty"
"c#queue-empty?"
"c#queue-get!"
"c#queue-put!"
"c#remq"
"c#str->list"
"c#stretchable-vector-copy"
"c#stretchable-vector-for-each"
"c#stretchable-vector-length"
"c#string-pos-in-list"
"c#take"
"c#topological-sort"
"c#transitive-closure"
"c#varset-adjoin"
"c#varset-intersection"
"c#varset-intersects?"
"c#varset-remove"
"c#varset-unwrap"
"c#varset-wrap"
"c#with-exception-handling"
)
(
"##call-with-current-continuation"
"+"
"append"
"apply"
"c#fatal-err"
"c#locat-show"
"display"
"equal?"
"make-string"
"make-table"
"make-vector"
"newline"
"string=?"
"table-ref"
"table-set!"
"write"
)
 #f
)
#else
#define ___VERSION 406006
#define ___MODULE_NAME " _utils"
#define ___LINKER_ID ____20___utils
#define ___MH_PROC ___H__20___utils
#define ___SCRIPT_LINE 0
#define ___KEY_COUNT 1
#define ___GLO_COUNT 107
#define ___SUP_COUNT 91
#define ___SUB_COUNT 19
#define ___LBL_COUNT 593
#define ___OFD_COUNT 10
#include "gambit.h"

___NEED_KEY(___K_test)

___NEED_GLO(___G__20___utils)
___NEED_GLO(___G__23__23_call_2d_with_2d_current_2d_continuation)
___NEED_GLO(___G__2b_)
___NEED_GLO(___G_append)
___NEED_GLO(___G_apply)
___NEED_GLO(___G_c_23_append_2d_lists)
___NEED_GLO(___G_c_23_bits_2d_and)
___NEED_GLO(___G_c_23_bits_2d_or)
___NEED_GLO(___G_c_23_bits_2d_shl)
___NEED_GLO(___G_c_23_bits_2d_shr)
___NEED_GLO(___G_c_23_compiler_2d_abort)
___NEED_GLO(___G_c_23_compiler_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_internal_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_limitation_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_user_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_user_2d_warning)
___NEED_GLO(___G_c_23_drop)
___NEED_GLO(___G_c_23_every_3f_)
___NEED_GLO(___G_c_23_fatal_2d_err)
___NEED_GLO(___G_c_23_for_2d_each_2d_index)
___NEED_GLO(___G_c_23_gnode_2d_depvars)
___NEED_GLO(___G_c_23_gnode_2d_find_2d_depvars)
___NEED_GLO(___G_c_23_gnode_2d_var)
___NEED_GLO(___G_c_23_gnodes_2d_remove)
___NEED_GLO(___G_c_23_keep)
___NEED_GLO(___G_c_23_last_2d_pair)
___NEED_GLO(___G_c_23_list_2d__3e_queue)
___NEED_GLO(___G_c_23_list_2d__3e_str)
___NEED_GLO(___G_c_23_list_2d__3e_varset)
___NEED_GLO(___G_c_23_list_2d__3e_vect)
___NEED_GLO(___G_c_23_list_2d_length)
___NEED_GLO(___G_c_23_locat_2d_show)
___NEED_GLO(___G_c_23_make_2d_counter)
___NEED_GLO(___G_c_23_make_2d_gnode)
___NEED_GLO(___G_c_23_make_2d_ordered_2d_table)
___NEED_GLO(___G_c_23_make_2d_stretchable_2d_vector)
___NEED_GLO(___G_c_23_n_2d_ary)
___NEED_GLO(___G_c_23_object_2d_pos_2d_in_2d_list)
___NEED_GLO(___G_c_23_ordered_2d_table_2d__3e_list)
___NEED_GLO(___G_c_23_ordered_2d_table_2d_enter)
___NEED_GLO(___G_c_23_ordered_2d_table_2d_index)
___NEED_GLO(___G_c_23_ordered_2d_table_2d_length)
___NEED_GLO(___G_c_23_ordered_2d_table_2d_lookup)
___NEED_GLO(___G_c_23_pair_2d_up)
___NEED_GLO(___G_c_23_pos_2d_in_2d_list)
___NEED_GLO(___G_c_23_ptset_2d__3e_list)
___NEED_GLO(___G_c_23_ptset_2d_adjoin)
___NEED_GLO(___G_c_23_ptset_2d_empty)
___NEED_GLO(___G_c_23_ptset_2d_empty_2d_set)
___NEED_GLO(___G_c_23_ptset_2d_empty_3f_)
___NEED_GLO(___G_c_23_ptset_2d_every_3f_)
___NEED_GLO(___G_c_23_ptset_2d_member_3f_)
___NEED_GLO(___G_c_23_ptset_2d_remove)
___NEED_GLO(___G_c_23_ptset_2d_size)
___NEED_GLO(___G_c_23_queue_2d__3e_list)
___NEED_GLO(___G_c_23_queue_2d_empty)
___NEED_GLO(___G_c_23_queue_2d_empty_3f_)
___NEED_GLO(___G_c_23_queue_2d_get_21_)
___NEED_GLO(___G_c_23_queue_2d_put_21_)
___NEED_GLO(___G_c_23_remove_2d_cycle)
___NEED_GLO(___G_c_23_remove_2d_no_2d_depvars)
___NEED_GLO(___G_c_23_remq)
___NEED_GLO(___G_c_23_reverse_2d_append_21_)
___NEED_GLO(___G_c_23_sort_2d_list)
___NEED_GLO(___G_c_23_str_2d__3e_list)
___NEED_GLO(___G_c_23_stretch_2d_vector)
___NEED_GLO(___G_c_23_stretchable_2d_vector_2d_copy)
___NEED_GLO(___G_c_23_stretchable_2d_vector_2d_for_2d_each)
___NEED_GLO(___G_c_23_stretchable_2d_vector_2d_length)
___NEED_GLO(___G_c_23_stretchable_2d_vector_2d_ref)
___NEED_GLO(___G_c_23_stretchable_2d_vector_2d_set_21_)
___NEED_GLO(___G_c_23_string_2d_pos_2d_in_2d_list)
___NEED_GLO(___G_c_23_take)
___NEED_GLO(___G_c_23_throw_2d_to_2d_exception_2d_handler)
___NEED_GLO(___G_c_23_topological_2d_sort)
___NEED_GLO(___G_c_23_transitive_2d_closure)
___NEED_GLO(___G_c_23_varset_2d__3c_)
___NEED_GLO(___G_c_23_varset_2d__3e_list)
___NEED_GLO(___G_c_23_varset_2d_adjoin)
___NEED_GLO(___G_c_23_varset_2d_difference)
___NEED_GLO(___G_c_23_varset_2d_empty)
___NEED_GLO(___G_c_23_varset_2d_empty_3f_)
___NEED_GLO(___G_c_23_varset_2d_equal_3f_)
___NEED_GLO(___G_c_23_varset_2d_intersection)
___NEED_GLO(___G_c_23_varset_2d_intersects_3f_)
___NEED_GLO(___G_c_23_varset_2d_member_3f_)
___NEED_GLO(___G_c_23_varset_2d_remove)
___NEED_GLO(___G_c_23_varset_2d_reverse_2d_append_21_)
___NEED_GLO(___G_c_23_varset_2d_singleton)
___NEED_GLO(___G_c_23_varset_2d_size)
___NEED_GLO(___G_c_23_varset_2d_union)
___NEED_GLO(___G_c_23_varset_2d_union_2d_multi)
___NEED_GLO(___G_c_23_varset_2d_unwrap)
___NEED_GLO(___G_c_23_varset_2d_wrap)
___NEED_GLO(___G_c_23_vect_2d__3e_list)
___NEED_GLO(___G_c_23_warnings_2d_requested_3f_)
___NEED_GLO(___G_c_23_with_2d_exception_2d_handling)
___NEED_GLO(___G_display)
___NEED_GLO(___G_equal_3f_)
___NEED_GLO(___G_make_2d_string)
___NEED_GLO(___G_make_2d_table)
___NEED_GLO(___G_make_2d_vector)
___NEED_GLO(___G_newline)
___NEED_GLO(___G_string_3d__3f_)
___NEED_GLO(___G_table_2d_ref)
___NEED_GLO(___G_table_2d_set_21_)
___NEED_GLO(___G_write)

___BEGIN_KEY1
___DEF_KEY1(0,___K_test,"test")
___END_KEY1

___BEGIN_GLO
___DEF_GLO(0," _utils")
___DEF_GLO(1,"c#append-lists")
___DEF_GLO(2,"c#bits-and")
___DEF_GLO(3,"c#bits-or")
___DEF_GLO(4,"c#bits-shl")
___DEF_GLO(5,"c#bits-shr")
___DEF_GLO(6,"c#compiler-abort")
___DEF_GLO(7,"c#compiler-error")
___DEF_GLO(8,"c#compiler-internal-error")
___DEF_GLO(9,"c#compiler-limitation-error")
___DEF_GLO(10,"c#compiler-user-error")
___DEF_GLO(11,"c#compiler-user-warning")
___DEF_GLO(12,"c#drop")
___DEF_GLO(13,"c#every?")
___DEF_GLO(14,"c#for-each-index")
___DEF_GLO(15,"c#gnode-depvars")
___DEF_GLO(16,"c#gnode-find-depvars")
___DEF_GLO(17,"c#gnode-var")
___DEF_GLO(18,"c#gnodes-remove")
___DEF_GLO(19,"c#keep")
___DEF_GLO(20,"c#last-pair")
___DEF_GLO(21,"c#list->queue")
___DEF_GLO(22,"c#list->str")
___DEF_GLO(23,"c#list->varset")
___DEF_GLO(24,"c#list->vect")
___DEF_GLO(25,"c#list-length")
___DEF_GLO(26,"c#make-counter")
___DEF_GLO(27,"c#make-gnode")
___DEF_GLO(28,"c#make-ordered-table")
___DEF_GLO(29,"c#make-stretchable-vector")
___DEF_GLO(30,"c#n-ary")
___DEF_GLO(31,"c#object-pos-in-list")
___DEF_GLO(32,"c#ordered-table->list")
___DEF_GLO(33,"c#ordered-table-enter")
___DEF_GLO(34,"c#ordered-table-index")
___DEF_GLO(35,"c#ordered-table-length")
___DEF_GLO(36,"c#ordered-table-lookup")
___DEF_GLO(37,"c#pair-up")
___DEF_GLO(38,"c#pos-in-list")
___DEF_GLO(39,"c#ptset->list")
___DEF_GLO(40,"c#ptset-adjoin")
___DEF_GLO(41,"c#ptset-empty")
___DEF_GLO(42,"c#ptset-empty-set")
___DEF_GLO(43,"c#ptset-empty?")
___DEF_GLO(44,"c#ptset-every?")
___DEF_GLO(45,"c#ptset-member?")
___DEF_GLO(46,"c#ptset-remove")
___DEF_GLO(47,"c#ptset-size")
___DEF_GLO(48,"c#queue->list")
___DEF_GLO(49,"c#queue-empty")
___DEF_GLO(50,"c#queue-empty?")
___DEF_GLO(51,"c#queue-get!")
___DEF_GLO(52,"c#queue-put!")
___DEF_GLO(53,"c#remove-cycle")
___DEF_GLO(54,"c#remove-no-depvars")
___DEF_GLO(55,"c#remq")
___DEF_GLO(56,"c#reverse-append!")
___DEF_GLO(57,"c#sort-list")
___DEF_GLO(58,"c#str->list")
___DEF_GLO(59,"c#stretch-vector")
___DEF_GLO(60,"c#stretchable-vector-copy")
___DEF_GLO(61,"c#stretchable-vector-for-each")
___DEF_GLO(62,"c#stretchable-vector-length")
___DEF_GLO(63,"c#stretchable-vector-ref")
___DEF_GLO(64,"c#stretchable-vector-set!")
___DEF_GLO(65,"c#string-pos-in-list")
___DEF_GLO(66,"c#take")
___DEF_GLO(67,"c#throw-to-exception-handler")
___DEF_GLO(68,"c#topological-sort")
___DEF_GLO(69,"c#transitive-closure")
___DEF_GLO(70,"c#varset-<")
___DEF_GLO(71,"c#varset->list")
___DEF_GLO(72,"c#varset-adjoin")
___DEF_GLO(73,"c#varset-difference")
___DEF_GLO(74,"c#varset-empty")
___DEF_GLO(75,"c#varset-empty?")
___DEF_GLO(76,"c#varset-equal?")
___DEF_GLO(77,"c#varset-intersection")
___DEF_GLO(78,"c#varset-intersects?")
___DEF_GLO(79,"c#varset-member?")
___DEF_GLO(80,"c#varset-remove")
___DEF_GLO(81,"c#varset-reverse-append!")
___DEF_GLO(82,"c#varset-singleton")
___DEF_GLO(83,"c#varset-size")
___DEF_GLO(84,"c#varset-union")
___DEF_GLO(85,"c#varset-union-multi")
___DEF_GLO(86,"c#varset-unwrap")
___DEF_GLO(87,"c#varset-wrap")
___DEF_GLO(88,"c#vect->list")
___DEF_GLO(89,"c#warnings-requested?")
___DEF_GLO(90,"c#with-exception-handling")
___DEF_GLO(91,"##call-with-current-continuation")
___DEF_GLO(92,"+")
___DEF_GLO(93,"append")
___DEF_GLO(94,"apply")
___DEF_GLO(95,"c#fatal-err")
___DEF_GLO(96,"c#locat-show")
___DEF_GLO(97,"display")
___DEF_GLO(98,"equal?")
___DEF_GLO(99,"make-string")
___DEF_GLO(100,"make-table")
___DEF_GLO(101,"make-vector")
___DEF_GLO(102,"newline")
___DEF_GLO(103,"string=?")
___DEF_GLO(104,"table-ref")
___DEF_GLO(105,"table-set!")
___DEF_GLO(106,"write")
___END_GLO

___DEF_SUB_VEC(___X0,0)
               ___VEC0
___DEF_SUB_STR(___X1,13)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR5(82,32,45,45,32)
___DEF_SUB_STR(___X2,1)
               ___STR1(32)
___DEF_SUB_STR(___X3,9)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR1(82)
___DEF_SUB_STR(___X4,4)
               ___STR4(32,73,78,32)
___DEF_SUB_STR(___X5,4)
               ___STR4(32,45,45,32)
___DEF_SUB_STR(___X6,1)
               ___STR1(32)
___DEF_SUB_STR(___X7,11)
               ___STR8(42,42,42,32,87,65,82,78)
               ___STR3(73,78,71)
___DEF_SUB_STR(___X8,4)
               ___STR4(32,73,78,32)
___DEF_SUB_STR(___X9,4)
               ___STR4(32,45,45,32)
___DEF_SUB_STR(___X10,1)
               ___STR1(32)
___DEF_SUB_STR(___X11,45)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR8(82,32,45,45,32,67,111,109)
               ___STR8(112,105,108,101,114,32,105,110)
               ___STR8(116,101,114,110,97,108,32,101)
               ___STR8(114,114,111,114,32,100,101,116)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X12,1)
               ___STR1(32)
___DEF_SUB_STR(___X13,17)
               ___STR8(42,42,42,32,105,110,32,112)
               ___STR8(114,111,99,101,100,117,114,101)
               ___STR1(32)
___DEF_SUB_STR(___X14,35)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR8(82,32,45,45,32,67,111,109)
               ___STR8(112,105,108,101,114,32,108,105)
               ___STR8(109,105,116,32,114,101,97,99)
               ___STR3(104,101,100)
___DEF_SUB_STR(___X15,1)
               ___STR1(32)
___DEF_SUB_STR(___X16,4)
               ___STR4(42,42,42,32)
___DEF_SUB_STR(___X17,26)
               ___STR8(113,117,101,117,101,45,103,101)
               ___STR8(116,33,44,32,113,117,101,117)
               ___STR8(101,32,105,115,32,101,109,112)
               ___STR2(116,121)
___DEF_SUB_STR(___X18,50)
               ___STR8(73,110,116,101,114,110,97,108)
               ___STR8(32,101,114,114,111,114,44,32)
               ___STR8(110,111,32,101,120,99,101,112)
               ___STR8(116,105,111,110,32,104,97,110)
               ___STR8(100,108,101,114,32,97,116,32)
               ___STR8(116,104,105,115,32,112,111,105)
               ___STR2(110,116)

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
___DEF_M_HLBL(___L0__20___utils)
___DEF_M_HLBL(___L1__20___utils)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_append_2d_lists)
___DEF_M_HLBL(___L1_c_23_append_2d_lists)
___DEF_M_HLBL(___L2_c_23_append_2d_lists)
___DEF_M_HLBL(___L3_c_23_append_2d_lists)
___DEF_M_HLBL(___L4_c_23_append_2d_lists)
___DEF_M_HLBL(___L5_c_23_append_2d_lists)
___DEF_M_HLBL(___L6_c_23_append_2d_lists)
___DEF_M_HLBL(___L7_c_23_append_2d_lists)
___DEF_M_HLBL(___L8_c_23_append_2d_lists)
___DEF_M_HLBL(___L9_c_23_append_2d_lists)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_reverse_2d_append_21_)
___DEF_M_HLBL(___L1_c_23_reverse_2d_append_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_list_2d_length)
___DEF_M_HLBL(___L1_c_23_list_2d_length)
___DEF_M_HLBL(___L2_c_23_list_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_counter)
___DEF_M_HLBL(___L1_c_23_make_2d_counter)
___DEF_M_HLBL(___L2_c_23_make_2d_counter)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_for_2d_each_2d_index)
___DEF_M_HLBL(___L1_c_23_for_2d_each_2d_index)
___DEF_M_HLBL(___L2_c_23_for_2d_each_2d_index)
___DEF_M_HLBL(___L3_c_23_for_2d_each_2d_index)
___DEF_M_HLBL(___L4_c_23_for_2d_each_2d_index)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pos_2d_in_2d_list)
___DEF_M_HLBL(___L1_c_23_pos_2d_in_2d_list)
___DEF_M_HLBL(___L2_c_23_pos_2d_in_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_object_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L1_c_23_object_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L2_c_23_object_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L3_c_23_object_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L4_c_23_object_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L5_c_23_object_2d_pos_2d_in_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_string_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L1_c_23_string_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L2_c_23_string_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L3_c_23_string_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L4_c_23_string_2d_pos_2d_in_2d_list)
___DEF_M_HLBL(___L5_c_23_string_2d_pos_2d_in_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_take)
___DEF_M_HLBL(___L1_c_23_take)
___DEF_M_HLBL(___L2_c_23_take)
___DEF_M_HLBL(___L3_c_23_take)
___DEF_M_HLBL(___L4_c_23_take)
___DEF_M_HLBL(___L5_c_23_take)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_drop)
___DEF_M_HLBL(___L1_c_23_drop)
___DEF_M_HLBL(___L2_c_23_drop)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pair_2d_up)
___DEF_M_HLBL(___L1_c_23_pair_2d_up)
___DEF_M_HLBL(___L2_c_23_pair_2d_up)
___DEF_M_HLBL(___L3_c_23_pair_2d_up)
___DEF_M_HLBL(___L4_c_23_pair_2d_up)
___DEF_M_HLBL(___L5_c_23_pair_2d_up)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_last_2d_pair)
___DEF_M_HLBL(___L1_c_23_last_2d_pair)
___DEF_M_HLBL(___L2_c_23_last_2d_pair)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_keep)
___DEF_M_HLBL(___L1_c_23_keep)
___DEF_M_HLBL(___L2_c_23_keep)
___DEF_M_HLBL(___L3_c_23_keep)
___DEF_M_HLBL(___L4_c_23_keep)
___DEF_M_HLBL(___L5_c_23_keep)
___DEF_M_HLBL(___L6_c_23_keep)
___DEF_M_HLBL(___L7_c_23_keep)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_every_3f_)
___DEF_M_HLBL(___L1_c_23_every_3f_)
___DEF_M_HLBL(___L2_c_23_every_3f_)
___DEF_M_HLBL(___L3_c_23_every_3f_)
___DEF_M_HLBL(___L4_c_23_every_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_remq)
___DEF_M_HLBL(___L1_c_23_remq)
___DEF_M_HLBL(___L2_c_23_remq)
___DEF_M_HLBL(___L3_c_23_remq)
___DEF_M_HLBL(___L4_c_23_remq)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_sort_2d_list)
___DEF_M_HLBL(___L1_c_23_sort_2d_list)
___DEF_M_HLBL(___L2_c_23_sort_2d_list)
___DEF_M_HLBL(___L3_c_23_sort_2d_list)
___DEF_M_HLBL(___L4_c_23_sort_2d_list)
___DEF_M_HLBL(___L5_c_23_sort_2d_list)
___DEF_M_HLBL(___L6_c_23_sort_2d_list)
___DEF_M_HLBL(___L7_c_23_sort_2d_list)
___DEF_M_HLBL(___L8_c_23_sort_2d_list)
___DEF_M_HLBL(___L9_c_23_sort_2d_list)
___DEF_M_HLBL(___L10_c_23_sort_2d_list)
___DEF_M_HLBL(___L11_c_23_sort_2d_list)
___DEF_M_HLBL(___L12_c_23_sort_2d_list)
___DEF_M_HLBL(___L13_c_23_sort_2d_list)
___DEF_M_HLBL(___L14_c_23_sort_2d_list)
___DEF_M_HLBL(___L15_c_23_sort_2d_list)
___DEF_M_HLBL(___L16_c_23_sort_2d_list)
___DEF_M_HLBL(___L17_c_23_sort_2d_list)
___DEF_M_HLBL(___L18_c_23_sort_2d_list)
___DEF_M_HLBL(___L19_c_23_sort_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_list_2d__3e_vect)
___DEF_M_HLBL(___L1_c_23_list_2d__3e_vect)
___DEF_M_HLBL(___L2_c_23_list_2d__3e_vect)
___DEF_M_HLBL(___L3_c_23_list_2d__3e_vect)
___DEF_M_HLBL(___L4_c_23_list_2d__3e_vect)
___DEF_M_HLBL(___L5_c_23_list_2d__3e_vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_vect_2d__3e_list)
___DEF_M_HLBL(___L1_c_23_vect_2d__3e_list)
___DEF_M_HLBL(___L2_c_23_vect_2d__3e_list)
___DEF_M_HLBL(___L3_c_23_vect_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_list_2d__3e_str)
___DEF_M_HLBL(___L1_c_23_list_2d__3e_str)
___DEF_M_HLBL(___L2_c_23_list_2d__3e_str)
___DEF_M_HLBL(___L3_c_23_list_2d__3e_str)
___DEF_M_HLBL(___L4_c_23_list_2d__3e_str)
___DEF_M_HLBL(___L5_c_23_list_2d__3e_str)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_str_2d__3e_list)
___DEF_M_HLBL(___L1_c_23_str_2d__3e_list)
___DEF_M_HLBL(___L2_c_23_str_2d__3e_list)
___DEF_M_HLBL(___L3_c_23_str_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_stretchable_2d_vector)
___DEF_M_HLBL(___L1_c_23_make_2d_stretchable_2d_vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_stretchable_2d_vector_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_stretchable_2d_vector_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_M_HLBL(___L1_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_M_HLBL(___L2_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_M_HLBL(___L3_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L1_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L2_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L3_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L4_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L5_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L6_c_23_stretch_2d_vector)
___DEF_M_HLBL(___L7_c_23_stretch_2d_vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_stretchable_2d_vector_2d_copy)
___DEF_M_HLBL(___L1_c_23_stretchable_2d_vector_2d_copy)
___DEF_M_HLBL(___L2_c_23_stretchable_2d_vector_2d_copy)
___DEF_M_HLBL(___L3_c_23_stretchable_2d_vector_2d_copy)
___DEF_M_HLBL(___L4_c_23_stretchable_2d_vector_2d_copy)
___DEF_M_HLBL(___L5_c_23_stretchable_2d_vector_2d_copy)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_M_HLBL(___L1_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_M_HLBL(___L2_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_M_HLBL(___L3_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_M_HLBL(___L4_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L1_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L2_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L3_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L4_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ordered_2d_table_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ordered_2d_table_2d_index)
___DEF_M_HLBL(___L1_c_23_ordered_2d_table_2d_index)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ordered_2d_table_2d_lookup)
___DEF_M_HLBL(___L1_c_23_ordered_2d_table_2d_lookup)
___DEF_M_HLBL(___L2_c_23_ordered_2d_table_2d_lookup)
___DEF_M_HLBL(___L3_c_23_ordered_2d_table_2d_lookup)
___DEF_M_HLBL(___L4_c_23_ordered_2d_table_2d_lookup)
___DEF_M_HLBL(___L5_c_23_ordered_2d_table_2d_lookup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL(___L1_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL(___L2_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL(___L3_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL(___L4_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL(___L5_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL(___L6_c_23_ordered_2d_table_2d_enter)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ordered_2d_table_2d__3e_list)
___DEF_M_HLBL(___L1_c_23_ordered_2d_table_2d__3e_list)
___DEF_M_HLBL(___L2_c_23_ordered_2d_table_2d__3e_list)
___DEF_M_HLBL(___L3_c_23_ordered_2d_table_2d__3e_list)
___DEF_M_HLBL(___L4_c_23_ordered_2d_table_2d__3e_list)
___DEF_M_HLBL(___L5_c_23_ordered_2d_table_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bits_2d_and)
___DEF_M_HLBL(___L1_c_23_bits_2d_and)
___DEF_M_HLBL(___L2_c_23_bits_2d_and)
___DEF_M_HLBL(___L3_c_23_bits_2d_and)
___DEF_M_HLBL(___L4_c_23_bits_2d_and)
___DEF_M_HLBL(___L5_c_23_bits_2d_and)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bits_2d_or)
___DEF_M_HLBL(___L1_c_23_bits_2d_or)
___DEF_M_HLBL(___L2_c_23_bits_2d_or)
___DEF_M_HLBL(___L3_c_23_bits_2d_or)
___DEF_M_HLBL(___L4_c_23_bits_2d_or)
___DEF_M_HLBL(___L5_c_23_bits_2d_or)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bits_2d_shl)
___DEF_M_HLBL(___L1_c_23_bits_2d_shl)
___DEF_M_HLBL(___L2_c_23_bits_2d_shl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bits_2d_shr)
___DEF_M_HLBL(___L1_c_23_bits_2d_shr)
___DEF_M_HLBL(___L2_c_23_bits_2d_shr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_with_2d_exception_2d_handling)
___DEF_M_HLBL(___L1_c_23_with_2d_exception_2d_handling)
___DEF_M_HLBL(___L2_c_23_with_2d_exception_2d_handling)
___DEF_M_HLBL(___L3_c_23_with_2d_exception_2d_handling)
___DEF_M_HLBL(___L4_c_23_with_2d_exception_2d_handling)
___DEF_M_HLBL(___L5_c_23_with_2d_exception_2d_handling)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_compiler_2d_error)
___DEF_M_HLBL(___L1_c_23_compiler_2d_error)
___DEF_M_HLBL(___L2_c_23_compiler_2d_error)
___DEF_M_HLBL(___L3_c_23_compiler_2d_error)
___DEF_M_HLBL(___L4_c_23_compiler_2d_error)
___DEF_M_HLBL(___L5_c_23_compiler_2d_error)
___DEF_M_HLBL(___L6_c_23_compiler_2d_error)
___DEF_M_HLBL(___L7_c_23_compiler_2d_error)
___DEF_M_HLBL(___L8_c_23_compiler_2d_error)
___DEF_M_HLBL(___L9_c_23_compiler_2d_error)
___DEF_M_HLBL(___L10_c_23_compiler_2d_error)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L1_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L2_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L3_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L4_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L5_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L6_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L7_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L8_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L9_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L10_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L11_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL(___L12_c_23_compiler_2d_user_2d_error)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L1_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L2_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L3_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L4_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L5_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L6_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L7_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L8_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L9_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L10_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL(___L11_c_23_compiler_2d_user_2d_warning)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L1_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L2_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L3_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L4_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L5_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L6_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L7_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L8_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L9_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L10_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L11_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL(___L12_c_23_compiler_2d_internal_2d_error)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L1_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L2_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L3_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L4_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L5_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L6_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L7_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L8_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L9_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L10_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L11_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL(___L12_c_23_compiler_2d_limitation_2d_error)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_compiler_2d_abort)
___DEF_M_HLBL(___L1_c_23_compiler_2d_abort)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_gnode)
___DEF_M_HLBL(___L1_c_23_make_2d_gnode)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_gnode_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_gnode_2d_depvars)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L1_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L2_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L3_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L4_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L5_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L6_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L7_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L8_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L9_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L10_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L11_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L12_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L13_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L14_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L15_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L16_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L17_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L18_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L19_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L20_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L21_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L22_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L23_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L24_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L25_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L26_c_23_transitive_2d_closure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL(___L1_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL(___L2_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL(___L3_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL(___L4_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL(___L5_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL(___L6_c_23_gnode_2d_find_2d_depvars)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L1_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L2_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L3_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L4_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L5_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L6_c_23_gnodes_2d_remove)
___DEF_M_HLBL(___L7_c_23_gnodes_2d_remove)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_topological_2d_sort)
___DEF_M_HLBL(___L1_c_23_topological_2d_sort)
___DEF_M_HLBL(___L2_c_23_topological_2d_sort)
___DEF_M_HLBL(___L3_c_23_topological_2d_sort)
___DEF_M_HLBL(___L4_c_23_topological_2d_sort)
___DEF_M_HLBL(___L5_c_23_topological_2d_sort)
___DEF_M_HLBL(___L6_c_23_topological_2d_sort)
___DEF_M_HLBL(___L7_c_23_topological_2d_sort)
___DEF_M_HLBL(___L8_c_23_topological_2d_sort)
___DEF_M_HLBL(___L9_c_23_topological_2d_sort)
___DEF_M_HLBL(___L10_c_23_topological_2d_sort)
___DEF_M_HLBL(___L11_c_23_topological_2d_sort)
___DEF_M_HLBL(___L12_c_23_topological_2d_sort)
___DEF_M_HLBL(___L13_c_23_topological_2d_sort)
___DEF_M_HLBL(___L14_c_23_topological_2d_sort)
___DEF_M_HLBL(___L15_c_23_topological_2d_sort)
___DEF_M_HLBL(___L16_c_23_topological_2d_sort)
___DEF_M_HLBL(___L17_c_23_topological_2d_sort)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L1_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L2_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L3_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L4_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L5_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L6_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L1_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L2_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L3_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L4_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L5_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L6_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L7_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L8_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L9_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L10_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L11_c_23_remove_2d_cycle)
___DEF_M_HLBL(___L12_c_23_remove_2d_cycle)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_empty)
___DEF_M_HLBL(___L1_c_23_ptset_2d_empty)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d__3e_list)
___DEF_M_HLBL(___L1_c_23_ptset_2d__3e_list)
___DEF_M_HLBL(___L2_c_23_ptset_2d__3e_list)
___DEF_M_HLBL(___L3_c_23_ptset_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_size)
___DEF_M_HLBL(___L1_c_23_ptset_2d_size)
___DEF_M_HLBL(___L2_c_23_ptset_2d_size)
___DEF_M_HLBL(___L3_c_23_ptset_2d_size)
___DEF_M_HLBL(___L4_c_23_ptset_2d_size)
___DEF_M_HLBL(___L5_c_23_ptset_2d_size)
___DEF_M_HLBL(___L6_c_23_ptset_2d_size)
___DEF_M_HLBL(___L7_c_23_ptset_2d_size)
___DEF_M_HLBL(___L8_c_23_ptset_2d_size)
___DEF_M_HLBL(___L9_c_23_ptset_2d_size)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_empty_3f_)
___DEF_M_HLBL(___L1_c_23_ptset_2d_empty_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_member_3f_)
___DEF_M_HLBL(___L1_c_23_ptset_2d_member_3f_)
___DEF_M_HLBL(___L2_c_23_ptset_2d_member_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_adjoin)
___DEF_M_HLBL(___L1_c_23_ptset_2d_adjoin)
___DEF_M_HLBL(___L2_c_23_ptset_2d_adjoin)
___DEF_M_HLBL(___L3_c_23_ptset_2d_adjoin)
___DEF_M_HLBL(___L4_c_23_ptset_2d_adjoin)
___DEF_M_HLBL(___L5_c_23_ptset_2d_adjoin)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L1_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L2_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L3_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L4_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L5_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L6_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L7_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L8_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L9_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL(___L10_c_23_ptset_2d_every_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptset_2d_remove)
___DEF_M_HLBL(___L1_c_23_ptset_2d_remove)
___DEF_M_HLBL(___L2_c_23_ptset_2d_remove)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_reverse_2d_append_21_)
___DEF_M_HLBL(___L1_c_23_varset_2d_reverse_2d_append_21_)
___DEF_M_HLBL(___L2_c_23_varset_2d_reverse_2d_append_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_wrap)
___DEF_M_HLBL(___L1_c_23_varset_2d_wrap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_unwrap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_empty)
___DEF_M_HLBL(___L1_c_23_varset_2d_empty)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_singleton)
___DEF_M_HLBL(___L1_c_23_varset_2d_singleton)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L1_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L2_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L3_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L4_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L5_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L6_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L7_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L8_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L9_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L10_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L11_c_23_list_2d__3e_varset)
___DEF_M_HLBL(___L12_c_23_list_2d__3e_varset)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_size)
___DEF_M_HLBL(___L1_c_23_varset_2d_size)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_empty_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d__3c_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L1_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L2_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L3_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L4_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L5_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L6_c_23_varset_2d_member_3f_)
___DEF_M_HLBL(___L7_c_23_varset_2d_member_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L1_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L2_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L3_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L4_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L5_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L6_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L7_c_23_varset_2d_adjoin)
___DEF_M_HLBL(___L8_c_23_varset_2d_adjoin)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_remove)
___DEF_M_HLBL(___L1_c_23_varset_2d_remove)
___DEF_M_HLBL(___L2_c_23_varset_2d_remove)
___DEF_M_HLBL(___L3_c_23_varset_2d_remove)
___DEF_M_HLBL(___L4_c_23_varset_2d_remove)
___DEF_M_HLBL(___L5_c_23_varset_2d_remove)
___DEF_M_HLBL(___L6_c_23_varset_2d_remove)
___DEF_M_HLBL(___L7_c_23_varset_2d_remove)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_equal_3f_)
___DEF_M_HLBL(___L1_c_23_varset_2d_equal_3f_)
___DEF_M_HLBL(___L2_c_23_varset_2d_equal_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_difference)
___DEF_M_HLBL(___L1_c_23_varset_2d_difference)
___DEF_M_HLBL(___L2_c_23_varset_2d_difference)
___DEF_M_HLBL(___L3_c_23_varset_2d_difference)
___DEF_M_HLBL(___L4_c_23_varset_2d_difference)
___DEF_M_HLBL(___L5_c_23_varset_2d_difference)
___DEF_M_HLBL(___L6_c_23_varset_2d_difference)
___DEF_M_HLBL(___L7_c_23_varset_2d_difference)
___DEF_M_HLBL(___L8_c_23_varset_2d_difference)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_union)
___DEF_M_HLBL(___L1_c_23_varset_2d_union)
___DEF_M_HLBL(___L2_c_23_varset_2d_union)
___DEF_M_HLBL(___L3_c_23_varset_2d_union)
___DEF_M_HLBL(___L4_c_23_varset_2d_union)
___DEF_M_HLBL(___L5_c_23_varset_2d_union)
___DEF_M_HLBL(___L6_c_23_varset_2d_union)
___DEF_M_HLBL(___L7_c_23_varset_2d_union)
___DEF_M_HLBL(___L8_c_23_varset_2d_union)
___DEF_M_HLBL(___L9_c_23_varset_2d_union)
___DEF_M_HLBL(___L10_c_23_varset_2d_union)
___DEF_M_HLBL(___L11_c_23_varset_2d_union)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L1_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L2_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L3_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L4_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L5_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L6_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L7_c_23_varset_2d_intersection)
___DEF_M_HLBL(___L8_c_23_varset_2d_intersection)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_intersects_3f_)
___DEF_M_HLBL(___L1_c_23_varset_2d_intersects_3f_)
___DEF_M_HLBL(___L2_c_23_varset_2d_intersects_3f_)
___DEF_M_HLBL(___L3_c_23_varset_2d_intersects_3f_)
___DEF_M_HLBL(___L4_c_23_varset_2d_intersects_3f_)
___DEF_M_HLBL(___L5_c_23_varset_2d_intersects_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L1_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L2_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L3_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L4_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L5_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L6_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L7_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L8_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL(___L9_c_23_varset_2d_union_2d_multi)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_n_2d_ary)
___DEF_M_HLBL(___L1_c_23_n_2d_ary)
___DEF_M_HLBL(___L2_c_23_n_2d_ary)
___DEF_M_HLBL(___L3_c_23_n_2d_ary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_list_2d__3e_queue)
___DEF_M_HLBL(___L1_c_23_list_2d__3e_queue)
___DEF_M_HLBL(___L2_c_23_list_2d__3e_queue)
___DEF_M_HLBL(___L3_c_23_list_2d__3e_queue)
___DEF_M_HLBL(___L4_c_23_list_2d__3e_queue)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_queue_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_queue_2d_empty)
___DEF_M_HLBL(___L1_c_23_queue_2d_empty)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_queue_2d_empty_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_queue_2d_get_21_)
___DEF_M_HLBL(___L1_c_23_queue_2d_get_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_queue_2d_put_21_)
___DEF_M_HLBL(___L1_c_23_queue_2d_put_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_throw_2d_to_2d_exception_2d_handler)
___DEF_M_HLBL(___L1_c_23_throw_2d_to_2d_exception_2d_handler)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___utils
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___utils)
___DEF_P_HLBL(___L1__20___utils)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___utils)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___utils)
   ___SET_GLO(67,___G_c_23_throw_2d_to_2d_exception_2d_handler,___PRC(591))
   ___SET_GLO(89,___G_c_23_warnings_2d_requested_3f_,___FAL)
   ___SET_GLO(89,___G_c_23_warnings_2d_requested_3f_,___TRU)
   ___BEGIN_ALLOC_VECTOR(11)
   ___ADD_VECTOR_ELEM(0,___NUL)
   ___ADD_VECTOR_ELEM(1,___NUL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___NUL)
   ___ADD_VECTOR_ELEM(4,___NUL)
   ___ADD_VECTOR_ELEM(5,___NUL)
   ___ADD_VECTOR_ELEM(6,___NUL)
   ___ADD_VECTOR_ELEM(7,___NUL)
   ___ADD_VECTOR_ELEM(8,___NUL)
   ___ADD_VECTOR_ELEM(9,___NUL)
   ___ADD_VECTOR_ELEM(10,___NUL)
   ___END_ALLOC_VECTOR(11)
   ___SET_R1(___GET_VECTOR(11))
   ___SET_GLO(42,___G_c_23_ptset_2d_empty_2d_set,___R1)
   ___SET_R1(___VOID)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__20___utils)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_append_2d_lists
#undef ___PH_LBL0
#define ___PH_LBL0 4
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_append_2d_lists)
___DEF_P_HLBL(___L1_c_23_append_2d_lists)
___DEF_P_HLBL(___L2_c_23_append_2d_lists)
___DEF_P_HLBL(___L3_c_23_append_2d_lists)
___DEF_P_HLBL(___L4_c_23_append_2d_lists)
___DEF_P_HLBL(___L5_c_23_append_2d_lists)
___DEF_P_HLBL(___L6_c_23_append_2d_lists)
___DEF_P_HLBL(___L7_c_23_append_2d_lists)
___DEF_P_HLBL(___L8_c_23_append_2d_lists)
___DEF_P_HLBL(___L9_c_23_append_2d_lists)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_append_2d_lists)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_append_2d_lists)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L17_c_23_append_2d_lists)
   ___END_IF
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_append_2d_lists)
   ___GOTO(___L11_c_23_append_2d_lists)
___DEF_GLBL(___L10_c_23_append_2d_lists)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_append_2d_lists)
___DEF_GLBL(___L11_c_23_append_2d_lists)
   ___SET_R2(___CDR(___R1))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L10_c_23_append_2d_lists)
   ___END_IF
   ___SET_R1(___CAR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_append_2d_lists)
   ___IF(___NOT(___PAIRP(___STK(-6))))
   ___GOTO(___L15_c_23_append_2d_lists)
   ___END_IF
   ___SET_R2(___CAR(___STK(-6)))
   ___SET_R2(___CONS(___R2,___NUL))
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R2)
   ___SET_R2(___CDR(___STK(-6)))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(7))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_append_2d_lists)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L13_c_23_append_2d_lists)
   ___END_IF
   ___GOTO(___L14_c_23_append_2d_lists)
___DEF_GLBL(___L12_c_23_append_2d_lists)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L14_c_23_append_2d_lists)
   ___END_IF
___DEF_GLBL(___L13_c_23_append_2d_lists)
   ___SET_R3(___CAR(___R2))
   ___SET_R3(___CONS(___R3,___NUL))
   ___SETCDR(___R1,___R3)
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___R3)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_append_2d_lists)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_append_2d_lists)
   ___GOTO(___L12_c_23_append_2d_lists)
___DEF_GLBL(___L14_c_23_append_2d_lists)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(7,___L7_c_23_append_2d_lists)
   ___SETCDR(___R1,___STK(-5))
   ___SET_R1(___STK(-4))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_append_2d_lists)
   ___GOTO(___L16_c_23_append_2d_lists)
___DEF_GLBL(___L15_c_23_append_2d_lists)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_append_2d_lists)
___DEF_GLBL(___L16_c_23_append_2d_lists)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L17_c_23_append_2d_lists)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_reverse_2d_append_21_
#undef ___PH_LBL0
#define ___PH_LBL0 15
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_reverse_2d_append_21_)
___DEF_P_HLBL(___L1_c_23_reverse_2d_append_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_reverse_2d_append_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_reverse_2d_append_21_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L4_c_23_reverse_2d_append_21_)
   ___END_IF
   ___GOTO(___L3_c_23_reverse_2d_append_21_)
___DEF_GLBL(___L2_c_23_reverse_2d_append_21_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L4_c_23_reverse_2d_append_21_)
   ___END_IF
___DEF_GLBL(___L3_c_23_reverse_2d_append_21_)
   ___SET_R3(___CDR(___R1))
   ___SETCDR(___R1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_reverse_2d_append_21_)
   ___GOTO(___L2_c_23_reverse_2d_append_21_)
___DEF_GLBL(___L4_c_23_reverse_2d_append_21_)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_list_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 18
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d_length)
___DEF_P_HLBL(___L1_c_23_list_2d_length)
___DEF_P_HLBL(___L2_c_23_list_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_list_2d_length)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_list_2d_length)
   ___GOTO(___L4_c_23_list_2d_length)
___DEF_GLBL(___L3_c_23_list_2d_length)
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_list_2d_length)
___DEF_GLBL(___L4_c_23_list_2d_length)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3_c_23_list_2d_length)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_counter
#undef ___PH_LBL0
#define ___PH_LBL0 22
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_counter)
___DEF_P_HLBL(___L1_c_23_make_2d_counter)
___DEF_P_HLBL(___L2_c_23_make_2d_counter)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_counter)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_counter)
   ___SET_R1(___BOX(___R1))
   ___SET_STK(1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),2)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_R1(___STK(1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_make_2d_counter)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(2,___L2_c_23_make_2d_counter)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(2,0,0,0)
   ___SET_R3(___CLO(___R4,1))
   ___SET_R1(___UNBOX(___R3))
   ___SET_R3(___CLO(___R4,1))
   ___SET_R2(___UNBOX(___R3))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_R4(___CLO(___R4,1))
   ___SETBOX(___R4,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_for_2d_each_2d_index
#undef ___PH_LBL0
#define ___PH_LBL0 26
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_for_2d_each_2d_index)
___DEF_P_HLBL(___L1_c_23_for_2d_each_2d_index)
___DEF_P_HLBL(___L2_c_23_for_2d_each_2d_index)
___DEF_P_HLBL(___L3_c_23_for_2d_each_2d_index)
___DEF_P_HLBL(___L4_c_23_for_2d_each_2d_index)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_for_2d_each_2d_index)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_for_2d_each_2d_index)
   ___SET_R3(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_for_2d_each_2d_index)
   ___GOTO(___L5_c_23_for_2d_each_2d_index)
___DEF_SLBL(2,___L2_c_23_for_2d_each_2d_index)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_for_2d_each_2d_index)
___DEF_GLBL(___L5_c_23_for_2d_each_2d_index)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L6_c_23_for_2d_each_2d_index)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R3)
   ___SET_R1(___CAR(___STK(3)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_for_2d_each_2d_index)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-6))
___DEF_GLBL(___L6_c_23_for_2d_each_2d_index)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pos_2d_in_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 32
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pos_2d_in_2d_list)
___DEF_P_HLBL(___L1_c_23_pos_2d_in_2d_list)
___DEF_P_HLBL(___L2_c_23_pos_2d_in_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pos_2d_in_2d_list)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_pos_2d_in_2d_list)
   ___SET_R3(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pos_2d_in_2d_list)
   ___GOTO(___L4_c_23_pos_2d_in_2d_list)
___DEF_GLBL(___L3_c_23_pos_2d_in_2d_list)
   ___SET_R4(___CAR(___R2))
   ___IF(___EQP(___R4,___R1))
   ___GOTO(___L5_c_23_pos_2d_in_2d_list)
   ___END_IF
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pos_2d_in_2d_list)
___DEF_GLBL(___L4_c_23_pos_2d_in_2d_list)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3_c_23_pos_2d_in_2d_list)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5_c_23_pos_2d_in_2d_list)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_object_2d_pos_2d_in_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 36
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_object_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L1_c_23_object_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L2_c_23_object_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L3_c_23_object_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L4_c_23_object_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L5_c_23_object_2d_pos_2d_in_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_object_2d_pos_2d_in_2d_list)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_object_2d_pos_2d_in_2d_list)
   ___SET_R3(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_object_2d_pos_2d_in_2d_list)
   ___GOTO(___L7_c_23_object_2d_pos_2d_in_2d_list)
___DEF_SLBL(2,___L2_c_23_object_2d_pos_2d_in_2d_list)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L12_c_23_object_2d_pos_2d_in_2d_list)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L6_c_23_object_2d_pos_2d_in_2d_list)
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_object_2d_pos_2d_in_2d_list)
___DEF_GLBL(___L7_c_23_object_2d_pos_2d_in_2d_list)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L11_c_23_object_2d_pos_2d_in_2d_list)
   ___END_IF
   ___SET_R4(___CAR(___R2))
   ___IF(___NOT(___EQP(___R4,___R1)))
   ___GOTO(___L9_c_23_object_2d_pos_2d_in_2d_list)
   ___END_IF
___DEF_GLBL(___L8_c_23_object_2d_pos_2d_in_2d_list)
   ___SET_R1(___R3)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_object_2d_pos_2d_in_2d_list)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L9_c_23_object_2d_pos_2d_in_2d_list)
   ___IF(___NOT(___MEMALLOCATEDP(___R4)))
   ___GOTO(___L6_c_23_object_2d_pos_2d_in_2d_list)
   ___END_IF
   ___IF(___NOT(___MEMALLOCATEDP(___R1)))
   ___GOTO(___L6_c_23_object_2d_pos_2d_in_2d_list)
   ___END_IF
   ___SET_STK(1,___SUBTYPE(___R1))
   ___SET_STK(2,___SUBTYPE(___R4))
   ___ADJFP(2)
   ___IF(___NOT(___FIXEQ(___STK(0),___STK(-1))))
   ___GOTO(___L10_c_23_object_2d_pos_2d_in_2d_list)
   ___END_IF
   ___SET_STK(-1,___R0)
   ___SET_STK(0,___R1)
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(6)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_object_2d_pos_2d_in_2d_list)
   ___JUMPPRM(___SET_NARGS(2),___PRM(98,___G_equal_3f_))
___DEF_GLBL(___L10_c_23_object_2d_pos_2d_in_2d_list)
   ___ADJFP(-2)
   ___GOTO(___L6_c_23_object_2d_pos_2d_in_2d_list)
___DEF_GLBL(___L11_c_23_object_2d_pos_2d_in_2d_list)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L12_c_23_object_2d_pos_2d_in_2d_list)
   ___SET_R3(___STK(-4))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___GOTO(___L8_c_23_object_2d_pos_2d_in_2d_list)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_string_2d_pos_2d_in_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 43
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_string_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L1_c_23_string_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L2_c_23_string_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L3_c_23_string_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L4_c_23_string_2d_pos_2d_in_2d_list)
___DEF_P_HLBL(___L5_c_23_string_2d_pos_2d_in_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_string_2d_pos_2d_in_2d_list)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_string_2d_pos_2d_in_2d_list)
   ___SET_R3(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_string_2d_pos_2d_in_2d_list)
   ___GOTO(___L6_c_23_string_2d_pos_2d_in_2d_list)
___DEF_SLBL(2,___L2_c_23_string_2d_pos_2d_in_2d_list)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L8_c_23_string_2d_pos_2d_in_2d_list)
   ___END_IF
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_string_2d_pos_2d_in_2d_list)
___DEF_GLBL(___L6_c_23_string_2d_pos_2d_in_2d_list)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L7_c_23_string_2d_pos_2d_in_2d_list)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___CAR(___STK(3)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_string_2d_pos_2d_in_2d_list)
   ___JUMPPRM(___SET_NARGS(2),___PRM(103,___G_string_3d__3f_))
___DEF_GLBL(___L7_c_23_string_2d_pos_2d_in_2d_list)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23_string_2d_pos_2d_in_2d_list)
   ___SET_R1(___STK(-4))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_string_2d_pos_2d_in_2d_list)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_take
#undef ___PH_LBL0
#define ___PH_LBL0 50
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_take)
___DEF_P_HLBL(___L1_c_23_take)
___DEF_P_HLBL(___L2_c_23_take)
___DEF_P_HLBL(___L3_c_23_take)
___DEF_P_HLBL(___L4_c_23_take)
___DEF_P_HLBL(___L5_c_23_take)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_take)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_take)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_take)
   ___GOTO(___L7_c_23_take)
___DEF_GLBL(___L6_c_23_take)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_take)
___DEF_GLBL(___L7_c_23_take)
   ___IF(___FIXGT(___R2,___FIX(0L)))
   ___GOTO(___L6_c_23_take)
   ___END_IF
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_take)
   ___SET_R2(___CAR(___STK(-6)))
   ___SET_R1(___CONS(___R2,___R1))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_take)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_take)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_drop
#undef ___PH_LBL0
#define ___PH_LBL0 57
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_drop)
___DEF_P_HLBL(___L1_c_23_drop)
___DEF_P_HLBL(___L2_c_23_drop)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_drop)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_drop)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_drop)
   ___GOTO(___L4_c_23_drop)
___DEF_GLBL(___L3_c_23_drop)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___CDR(___R1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_drop)
___DEF_GLBL(___L4_c_23_drop)
   ___IF(___FIXGT(___R2,___FIX(0L)))
   ___GOTO(___L3_c_23_drop)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pair_2d_up
#undef ___PH_LBL0
#define ___PH_LBL0 61
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pair_2d_up)
___DEF_P_HLBL(___L1_c_23_pair_2d_up)
___DEF_P_HLBL(___L2_c_23_pair_2d_up)
___DEF_P_HLBL(___L3_c_23_pair_2d_up)
___DEF_P_HLBL(___L4_c_23_pair_2d_up)
___DEF_P_HLBL(___L5_c_23_pair_2d_up)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pair_2d_up)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_pair_2d_up)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pair_2d_up)
   ___GOTO(___L7_c_23_pair_2d_up)
___DEF_GLBL(___L6_c_23_pair_2d_up)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pair_2d_up)
___DEF_GLBL(___L7_c_23_pair_2d_up)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L6_c_23_pair_2d_up)
   ___END_IF
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_pair_2d_up)
   ___SET_R2(___CAR(___STK(-5)))
   ___SET_R3(___CAR(___STK(-6)))
   ___SET_R2(___CONS(___R3,___R2))
   ___SET_R1(___CONS(___R2,___R1))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_pair_2d_up)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pair_2d_up)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_last_2d_pair
#undef ___PH_LBL0
#define ___PH_LBL0 68
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_last_2d_pair)
___DEF_P_HLBL(___L1_c_23_last_2d_pair)
___DEF_P_HLBL(___L2_c_23_last_2d_pair)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_last_2d_pair)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_last_2d_pair)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_last_2d_pair)
   ___GOTO(___L4_c_23_last_2d_pair)
___DEF_GLBL(___L3_c_23_last_2d_pair)
   ___SET_R1(___CDR(___R1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_last_2d_pair)
___DEF_GLBL(___L4_c_23_last_2d_pair)
   ___SET_R2(___CDR(___R1))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3_c_23_last_2d_pair)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_keep
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_keep)
___DEF_P_HLBL(___L1_c_23_keep)
___DEF_P_HLBL(___L2_c_23_keep)
___DEF_P_HLBL(___L3_c_23_keep)
___DEF_P_HLBL(___L4_c_23_keep)
___DEF_P_HLBL(___L5_c_23_keep)
___DEF_P_HLBL(___L6_c_23_keep)
___DEF_P_HLBL(___L7_c_23_keep)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_keep)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_keep)
   ___SET_R3(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_keep)
   ___GOTO(___L8_c_23_keep)
___DEF_SLBL(2,___L2_c_23_keep)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_keep)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___CONS(___R1,___STK(-4)))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_keep)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_keep)
___DEF_GLBL(___L8_c_23_keep)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L9_c_23_keep)
   ___END_IF
   ___SET_R1(___R3)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_keep)
   ___JUMPINT(___SET_NARGS(2),___PRC(15),___L_c_23_reverse_2d_append_21_)
___DEF_GLBL(___L9_c_23_keep)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___CAR(___R2))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_keep)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-6))
___DEF_GLBL(___L10_c_23_keep)
   ___SET_R3(___STK(-4))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_keep)
   ___GOTO(___L8_c_23_keep)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_every_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 81
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_every_3f_)
___DEF_P_HLBL(___L1_c_23_every_3f_)
___DEF_P_HLBL(___L2_c_23_every_3f_)
___DEF_P_HLBL(___L3_c_23_every_3f_)
___DEF_P_HLBL(___L4_c_23_every_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_every_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_every_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L7_c_23_every_3f_)
   ___END_IF
   ___GOTO(___L5_c_23_every_3f_)
___DEF_SLBL(1,___L1_c_23_every_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L6_c_23_every_3f_)
   ___END_IF
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_every_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L7_c_23_every_3f_)
   ___END_IF
___DEF_GLBL(___L5_c_23_every_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R2))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_every_3f_)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-6))
___DEF_GLBL(___L6_c_23_every_3f_)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_every_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23_every_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_remq
#undef ___PH_LBL0
#define ___PH_LBL0 87
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_remq)
___DEF_P_HLBL(___L1_c_23_remq)
___DEF_P_HLBL(___L2_c_23_remq)
___DEF_P_HLBL(___L3_c_23_remq)
___DEF_P_HLBL(___L4_c_23_remq)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_remq)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_remq)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___STK(2))
   ___SET_R3(___NUL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_remq)
   ___GOTO(___L6_c_23_remq)
___DEF_GLBL(___L5_c_23_remq)
   ___SET_R4(___CAR(___R2))
   ___IF(___EQP(___R4,___STK(0)))
   ___GOTO(___L7_c_23_remq)
   ___END_IF
   ___SET_R4(___CAR(___R2))
   ___SET_R3(___CONS(___R4,___R3))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_remq)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_remq)
___DEF_GLBL(___L6_c_23_remq)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L5_c_23_remq)
   ___END_IF
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L7_c_23_remq)
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___R3)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_remq)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(2),___PRC(15),___L_c_23_reverse_2d_append_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_sort_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 93
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_sort_2d_list)
___DEF_P_HLBL(___L1_c_23_sort_2d_list)
___DEF_P_HLBL(___L2_c_23_sort_2d_list)
___DEF_P_HLBL(___L3_c_23_sort_2d_list)
___DEF_P_HLBL(___L4_c_23_sort_2d_list)
___DEF_P_HLBL(___L5_c_23_sort_2d_list)
___DEF_P_HLBL(___L6_c_23_sort_2d_list)
___DEF_P_HLBL(___L7_c_23_sort_2d_list)
___DEF_P_HLBL(___L8_c_23_sort_2d_list)
___DEF_P_HLBL(___L9_c_23_sort_2d_list)
___DEF_P_HLBL(___L10_c_23_sort_2d_list)
___DEF_P_HLBL(___L11_c_23_sort_2d_list)
___DEF_P_HLBL(___L12_c_23_sort_2d_list)
___DEF_P_HLBL(___L13_c_23_sort_2d_list)
___DEF_P_HLBL(___L14_c_23_sort_2d_list)
___DEF_P_HLBL(___L15_c_23_sort_2d_list)
___DEF_P_HLBL(___L16_c_23_sort_2d_list)
___DEF_P_HLBL(___L17_c_23_sort_2d_list)
___DEF_P_HLBL(___L18_c_23_sort_2d_list)
___DEF_P_HLBL(___L19_c_23_sort_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_sort_2d_list)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_sort_2d_list)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_sort_2d_list)
   ___IF(___NULLP(___R2))
   ___GOTO(___L25_c_23_sort_2d_list)
   ___END_IF
   ___GOTO(___L20_c_23_sort_2d_list)
___DEF_SLBL(2,___L2_c_23_sort_2d_list)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___IF(___NULLP(___R2))
   ___GOTO(___L25_c_23_sort_2d_list)
   ___END_IF
___DEF_GLBL(___L20_c_23_sort_2d_list)
   ___SET_R3(___CDR(___R2))
   ___IF(___NULLP(___R3))
   ___GOTO(___L25_c_23_sort_2d_list)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_sort_2d_list)
___DEF_GLBL(___L21_c_23_sort_2d_list)
   ___IF(___NULLP(___R1))
   ___GOTO(___L23_c_23_sort_2d_list)
   ___END_IF
___DEF_GLBL(___L22_c_23_sort_2d_list)
   ___SET_R2(___CDR(___R1))
   ___IF(___NULLP(___R2))
   ___GOTO(___L23_c_23_sort_2d_list)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CDDR(___R1))
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_sort_2d_list)
   ___GOTO(___L21_c_23_sort_2d_list)
___DEF_SLBL(5,___L5_c_23_sort_2d_list)
   ___SET_R2(___CAR(___STK(-6)))
   ___SET_R1(___CONS(___R2,___R1))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_sort_2d_list)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_sort_2d_list)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(8,___L8_c_23_sort_2d_list)
   ___SET_STK(-4,___R1)
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___LBL(2))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L22_c_23_sort_2d_list)
   ___END_IF
___DEF_GLBL(___L23_c_23_sort_2d_list)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(9,___L9_c_23_sort_2d_list)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___IF(___NULLP(___R2))
   ___GOTO(___L25_c_23_sort_2d_list)
   ___END_IF
   ___GOTO(___L20_c_23_sort_2d_list)
___DEF_SLBL(10,___L10_c_23_sort_2d_list)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_sort_2d_list)
   ___IF(___NULLP(___R2))
   ___GOTO(___L26_c_23_sort_2d_list)
   ___END_IF
___DEF_GLBL(___L24_c_23_sort_2d_list)
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L28_c_23_sort_2d_list)
   ___END_IF
___DEF_GLBL(___L25_c_23_sort_2d_list)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(12,___L12_c_23_sort_2d_list)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L27_c_23_sort_2d_list)
   ___END_IF
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(16))
   ___ADJFP(-4)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L24_c_23_sort_2d_list)
   ___END_IF
___DEF_GLBL(___L26_c_23_sort_2d_list)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L27_c_23_sort_2d_list)
   ___SET_R3(___STK(-7))
   ___SET_R2(___CDR(___STK(-8)))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(13))
   ___IF(___NULLP(___R2))
   ___GOTO(___L26_c_23_sort_2d_list)
   ___END_IF
   ___GOTO(___L24_c_23_sort_2d_list)
___DEF_SLBL(13,___L13_c_23_sort_2d_list)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_sort_2d_list)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_sort_2d_list)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_SLBL(16,___L16_c_23_sort_2d_list)
   ___SET_R1(___CONS(___STK(-7),___R1))
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_c_23_sort_2d_list)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_sort_2d_list)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L28_c_23_sort_2d_list)
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___CAR(___R3))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R2(___STK(1))
   ___SET_R1(___R4)
   ___SET_R0(___LBL(12))
   ___ADJFP(12)
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_sort_2d_list)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-9))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_list_2d__3e_vect
#undef ___PH_LBL0
#define ___PH_LBL0 114
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d__3e_vect)
___DEF_P_HLBL(___L1_c_23_list_2d__3e_vect)
___DEF_P_HLBL(___L2_c_23_list_2d__3e_vect)
___DEF_P_HLBL(___L3_c_23_list_2d__3e_vect)
___DEF_P_HLBL(___L4_c_23_list_2d__3e_vect)
___DEF_P_HLBL(___L5_c_23_list_2d__3e_vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d__3e_vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_list_2d__3e_vect)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_list_2d__3e_vect)
   ___JUMPINT(___SET_NARGS(1),___PRC(18),___L_c_23_list_2d_length)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_vect)
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM(101,___G_make_2d_vector))
___DEF_SLBL(3,___L3_c_23_list_2d__3e_vect)
   ___SET_R2(___STK(-6))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_list_2d__3e_vect)
   ___GOTO(___L7_c_23_list_2d__3e_vect)
___DEF_GLBL(___L6_c_23_list_2d__3e_vect)
   ___SET_R4(___CAR(___R2))
   ___VECTORSET(___R1,___R3,___R4)
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_list_2d__3e_vect)
___DEF_GLBL(___L7_c_23_list_2d__3e_vect)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L6_c_23_list_2d__3e_vect)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_vect_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 121
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_vect_2d__3e_list)
___DEF_P_HLBL(___L1_c_23_vect_2d__3e_list)
___DEF_P_HLBL(___L2_c_23_vect_2d__3e_list)
___DEF_P_HLBL(___L3_c_23_vect_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_vect_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_vect_2d__3e_list)
   ___SET_R2(___VECTORLENGTH(___R1))
   ___SET_R3(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R2(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_vect_2d__3e_list)
   ___GOTO(___L5_c_23_vect_2d__3e_list)
___DEF_GLBL(___L4_c_23_vect_2d__3e_list)
   ___SET_R4(___VECTORREF(___R1,___R3))
   ___SET_R2(___CONS(___R4,___R2))
   ___SET_R3(___FIXSUB(___R3,___FIX(1L)))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_vect_2d__3e_list)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_vect_2d__3e_list)
___DEF_GLBL(___L5_c_23_vect_2d__3e_list)
   ___IF(___NOT(___FIXLT(___R3,___FIX(0L))))
   ___GOTO(___L4_c_23_vect_2d__3e_list)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_list_2d__3e_str
#undef ___PH_LBL0
#define ___PH_LBL0 126
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d__3e_str)
___DEF_P_HLBL(___L1_c_23_list_2d__3e_str)
___DEF_P_HLBL(___L2_c_23_list_2d__3e_str)
___DEF_P_HLBL(___L3_c_23_list_2d__3e_str)
___DEF_P_HLBL(___L4_c_23_list_2d__3e_str)
___DEF_P_HLBL(___L5_c_23_list_2d__3e_str)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d__3e_str)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_list_2d__3e_str)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_list_2d__3e_str)
   ___JUMPINT(___SET_NARGS(1),___PRC(18),___L_c_23_list_2d_length)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_str)
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM(99,___G_make_2d_string))
___DEF_SLBL(3,___L3_c_23_list_2d__3e_str)
   ___SET_R2(___STK(-6))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_list_2d__3e_str)
   ___GOTO(___L7_c_23_list_2d__3e_str)
___DEF_GLBL(___L6_c_23_list_2d__3e_str)
   ___SET_R4(___CAR(___R2))
   ___STRINGSET(___R1,___R3,___R4)
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_list_2d__3e_str)
___DEF_GLBL(___L7_c_23_list_2d__3e_str)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L6_c_23_list_2d__3e_str)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_str_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 133
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_str_2d__3e_list)
___DEF_P_HLBL(___L1_c_23_str_2d__3e_list)
___DEF_P_HLBL(___L2_c_23_str_2d__3e_list)
___DEF_P_HLBL(___L3_c_23_str_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_str_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_str_2d__3e_list)
   ___SET_R2(___STRINGLENGTH(___R1))
   ___SET_R3(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R2(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_str_2d__3e_list)
   ___GOTO(___L5_c_23_str_2d__3e_list)
___DEF_GLBL(___L4_c_23_str_2d__3e_list)
   ___SET_R4(___STRINGREF(___R1,___R3))
   ___SET_R2(___CONS(___R4,___R2))
   ___SET_R3(___FIXSUB(___R3,___FIX(1L)))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_str_2d__3e_list)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_str_2d__3e_list)
___DEF_GLBL(___L5_c_23_str_2d__3e_list)
   ___IF(___NOT(___FIXLT(___R3,___FIX(0L))))
   ___GOTO(___L4_c_23_str_2d__3e_list)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_stretchable_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 138
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_stretchable_2d_vector)
___DEF_P_HLBL(___L1_c_23_make_2d_stretchable_2d_vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_stretchable_2d_vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_stretchable_2d_vector)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___SUB(0))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_make_2d_stretchable_2d_vector)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 141
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretchable_2d_vector_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretchable_2d_vector_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_stretchable_2d_vector_2d_length)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___VECTORLENGTH(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 143
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretchable_2d_vector_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretchable_2d_vector_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_stretchable_2d_vector_2d_ref)
   ___SET_R3(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R4(___VECTORLENGTH(___R3))
   ___IF(___NOT(___FIXLT(___R2,___R4)))
   ___GOTO(___L1_c_23_stretchable_2d_vector_2d_ref)
   ___END_IF
   ___SET_R1(___VECTORREF(___R3,___R2))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_c_23_stretchable_2d_vector_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 145
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_P_HLBL(___L1_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_P_HLBL(___L2_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_P_HLBL(___L3_c_23_stretchable_2d_vector_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretchable_2d_vector_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_stretchable_2d_vector_2d_set_21_)
   ___SET_R4(___VECTORREF(___R1,___FIX(0L)))
   ___SET_STK(1,___VECTORLENGTH(___R4))
   ___ADJFP(1)
   ___IF(___FIXLT(___R2,___STK(0)))
   ___GOTO(___L4_c_23_stretchable_2d_vector_2d_set_21_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIXMUL(___STK(0),___FIX(3L)))
   ___SET_R1(___FIXQUO(___R1,___FIX(2L)))
   ___SET_R1(___FIXMAX(___R2,___R1))
   ___SET_R2(___FIXADD(___R1,___FIX(1L)))
   ___SET_R3(___VECTORREF(___STK(2),___FIX(1L)))
   ___SET_R1(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretchable_2d_vector_2d_set_21_)
   ___JUMPINT(___SET_NARGS(3),___PRC(150),___L_c_23_stretch_2d_vector)
___DEF_SLBL(2,___L2_c_23_stretchable_2d_vector_2d_set_21_)
   ___VECTORSET(___STK(-5),___FIX(0L),___R1)
   ___VECTORSET(___R1,___STK(-4),___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretchable_2d_vector_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L4_c_23_stretchable_2d_vector_2d_set_21_)
   ___VECTORSET(___R4,___R2,___R3) ___SET_R1(___R4)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretch_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 150
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L1_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L2_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L3_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L4_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L5_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L6_c_23_stretch_2d_vector)
___DEF_P_HLBL(___L7_c_23_stretch_2d_vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretch_2d_vector)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_stretch_2d_vector)
   ___SET_R4(___VECTORLENGTH(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretch_2d_vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM(101,___G_make_2d_vector))
___DEF_SLBL(2,___L2_c_23_stretch_2d_vector)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-6))
   ___SET_R2(___STK(-3))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___LBL(4))
   ___ADJFP(5)
   ___IF(___FIXLT(___R3,___R2))
   ___GOTO(___L9_c_23_stretch_2d_vector)
   ___END_IF
   ___GOTO(___L11_c_23_stretch_2d_vector)
___DEF_GLBL(___L8_c_23_stretch_2d_vector)
   ___IF(___NOT(___FIXLT(___R3,___R2)))
   ___GOTO(___L11_c_23_stretch_2d_vector)
   ___END_IF
___DEF_GLBL(___L9_c_23_stretch_2d_vector)
   ___SET_R4(___VECTORREF(___STK(0),___R3))
   ___VECTORSET(___R1,___R3,___R4)
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretch_2d_vector)
   ___GOTO(___L8_c_23_stretch_2d_vector)
___DEF_SLBL(4,___L4_c_23_stretch_2d_vector)
   ___SET_STK(1,___STK(-9))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(6))
   ___ADJFP(1)
   ___IF(___NOT(___FIXLT(___R3,___STK(0))))
   ___GOTO(___L11_c_23_stretch_2d_vector)
   ___END_IF
___DEF_GLBL(___L10_c_23_stretch_2d_vector)
   ___VECTORSET(___R2,___R3,___R1)
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_stretch_2d_vector)
   ___IF(___FIXLT(___R3,___STK(0)))
   ___GOTO(___L10_c_23_stretch_2d_vector)
   ___END_IF
___DEF_GLBL(___L11_c_23_stretch_2d_vector)
   ___SET_R1(___VOID)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_stretch_2d_vector)
   ___SET_R1(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_stretch_2d_vector)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_copy
#undef ___PH_LBL0
#define ___PH_LBL0 159
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretchable_2d_vector_2d_copy)
___DEF_P_HLBL(___L1_c_23_stretchable_2d_vector_2d_copy)
___DEF_P_HLBL(___L2_c_23_stretchable_2d_vector_2d_copy)
___DEF_P_HLBL(___L3_c_23_stretchable_2d_vector_2d_copy)
___DEF_P_HLBL(___L4_c_23_stretchable_2d_vector_2d_copy)
___DEF_P_HLBL(___L5_c_23_stretchable_2d_vector_2d_copy)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretchable_2d_vector_2d_copy)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_stretchable_2d_vector_2d_copy)
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R3(___VECTORLENGTH(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretchable_2d_vector_2d_copy)
   ___JUMPPRM(___SET_NARGS(1),___PRM(101,___G_make_2d_vector))
___DEF_SLBL(2,___L2_c_23_stretchable_2d_vector_2d_copy)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R3(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-3))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretchable_2d_vector_2d_copy)
   ___GOTO(___L7_c_23_stretchable_2d_vector_2d_copy)
___DEF_GLBL(___L6_c_23_stretchable_2d_vector_2d_copy)
   ___SET_R4(___VECTORREF(___R1,___R3))
   ___VECTORSET(___R2,___R3,___R4)
   ___SET_R3(___FIXSUB(___R3,___FIX(1L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_stretchable_2d_vector_2d_copy)
___DEF_GLBL(___L7_c_23_stretchable_2d_vector_2d_copy)
   ___IF(___FIXGE(___R3,___FIX(0L)))
   ___GOTO(___L6_c_23_stretchable_2d_vector_2d_copy)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(0),___FIX(1L)))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R2)
   ___ADD_VECTOR_ELEM(1,___R1)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___ADJFP(-1)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_stretchable_2d_vector_2d_copy)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_for_2d_each
#undef ___PH_LBL0
#define ___PH_LBL0 166
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_P_HLBL(___L1_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_P_HLBL(___L2_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_P_HLBL(___L3_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_P_HLBL(___L4_c_23_stretchable_2d_vector_2d_for_2d_each)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___SET_R2(___VECTORREF(___R2,___FIX(0L)))
   ___SET_R3(___VECTORLENGTH(___R2))
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___GOTO(___L5_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_SLBL(2,___L2_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___SET_R3(___FIXADD(___STK(-3),___FIX(1L)))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretchable_2d_vector_2d_for_2d_each)
___DEF_GLBL(___L5_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___IF(___NOT(___FIXLT(___R3,___R2)))
   ___GOTO(___L6_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___VECTORREF(___R1,___R3))
   ___SET_R2(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-7))
___DEF_GLBL(___L6_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___SET_R1(___VOID)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_ordered_2d_table
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
___DEF_P_HLBL(___L0_c_23_make_2d_ordered_2d_table)
___DEF_P_HLBL(___L1_c_23_make_2d_ordered_2d_table)
___DEF_P_HLBL(___L2_c_23_make_2d_ordered_2d_table)
___DEF_P_HLBL(___L3_c_23_make_2d_ordered_2d_table)
___DEF_P_HLBL(___L4_c_23_make_2d_ordered_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_ordered_2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_ordered_2d_table)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___KEY(0,___K_test))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_ordered_2d_table)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),100,___G_make_2d_table)
___DEF_SLBL(2,___L2_c_23_make_2d_ordered_2d_table)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___SUB(0))
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___END_ALLOC_VECTOR(2)
   ___SET_R2(___GET_VECTOR(2))
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R2)
   ___ADD_VECTOR_ELEM(2,___FIX(0L))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_ordered_2d_table)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_ordered_2d_table)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 178
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ordered_2d_table_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ordered_2d_table_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ordered_2d_table_2d_length)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d_index
#undef ___PH_LBL0
#define ___PH_LBL0 180
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ordered_2d_table_2d_index)
___DEF_P_HLBL(___L1_c_23_ordered_2d_table_2d_index)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ordered_2d_table_2d_index)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ordered_2d_table_2d_index)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R3(___FAL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ordered_2d_table_2d_index)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),104,___G_table_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d_lookup
#undef ___PH_LBL0
#define ___PH_LBL0 183
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ordered_2d_table_2d_lookup)
___DEF_P_HLBL(___L1_c_23_ordered_2d_table_2d_lookup)
___DEF_P_HLBL(___L2_c_23_ordered_2d_table_2d_lookup)
___DEF_P_HLBL(___L3_c_23_ordered_2d_table_2d_lookup)
___DEF_P_HLBL(___L4_c_23_ordered_2d_table_2d_lookup)
___DEF_P_HLBL(___L5_c_23_ordered_2d_table_2d_lookup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ordered_2d_table_2d_lookup)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ordered_2d_table_2d_lookup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R3(___FAL)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ordered_2d_table_2d_lookup)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),104,___G_table_2d_ref)
___DEF_SLBL(2,___L2_c_23_ordered_2d_table_2d_lookup)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L6_c_23_ordered_2d_table_2d_lookup)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ordered_2d_table_2d_lookup)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23_ordered_2d_table_2d_lookup)
   ___SET_R2(___R1)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R0(___LBL(4))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(143),___L_c_23_stretchable_2d_vector_2d_ref)
___DEF_SLBL(4,___L4_c_23_ordered_2d_table_2d_lookup)
   ___SET_R1(___CDR(___R1))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_ordered_2d_table_2d_lookup)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d_enter
#undef ___PH_LBL0
#define ___PH_LBL0 190
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ordered_2d_table_2d_enter)
___DEF_P_HLBL(___L1_c_23_ordered_2d_table_2d_enter)
___DEF_P_HLBL(___L2_c_23_ordered_2d_table_2d_enter)
___DEF_P_HLBL(___L3_c_23_ordered_2d_table_2d_enter)
___DEF_P_HLBL(___L4_c_23_ordered_2d_table_2d_enter)
___DEF_P_HLBL(___L5_c_23_ordered_2d_table_2d_enter)
___DEF_P_HLBL(___L6_c_23_ordered_2d_table_2d_enter)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ordered_2d_table_2d_enter)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_ordered_2d_table_2d_enter)
   ___SET_R4(___VECTORREF(___R1,___FIX(2L)))
   ___SET_STK(1,___FIXADD(___R4,___FIX(1L)))
   ___VECTORSET(___R1,___FIX(2L),___STK(1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R3(___R4)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ordered_2d_table_2d_enter)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),105,___G_table_2d_set_21_)
___DEF_SLBL(2,___L2_c_23_ordered_2d_table_2d_enter)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-4))
___DEF_SLBL(3,___L3_c_23_ordered_2d_table_2d_enter)
   ___SET_STK(-4,___R1)
   ___SET_R3(___CONS(___STK(-5),___R1))
   ___SET_R2(___STK(-3))
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R0(___LBL(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_ordered_2d_table_2d_enter)
   ___JUMPINT(___SET_NARGS(3),___PRC(145),___L_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_SLBL(5,___L5_c_23_ordered_2d_table_2d_enter)
   ___SET_R1(___STK(-4))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_ordered_2d_table_2d_enter)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 198
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ordered_2d_table_2d__3e_list)
___DEF_P_HLBL(___L1_c_23_ordered_2d_table_2d__3e_list)
___DEF_P_HLBL(___L2_c_23_ordered_2d_table_2d__3e_list)
___DEF_P_HLBL(___L3_c_23_ordered_2d_table_2d__3e_list)
___DEF_P_HLBL(___L4_c_23_ordered_2d_table_2d__3e_list)
___DEF_P_HLBL(___L5_c_23_ordered_2d_table_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ordered_2d_table_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ordered_2d_table_2d__3e_list)
   ___SET_R2(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R3(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ordered_2d_table_2d__3e_list)
   ___GOTO(___L6_c_23_ordered_2d_table_2d__3e_list)
___DEF_SLBL(2,___L2_c_23_ordered_2d_table_2d__3e_list)
   ___SET_R3(___CONS(___R1,___STK(-4)))
   ___SET_R2(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_ordered_2d_table_2d__3e_list)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_ordered_2d_table_2d__3e_list)
___DEF_GLBL(___L6_c_23_ordered_2d_table_2d__3e_list)
   ___IF(___FIXLT(___R2,___FIX(0L)))
   ___GOTO(___L7_c_23_ordered_2d_table_2d__3e_list)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_ordered_2d_table_2d__3e_list)
   ___JUMPINT(___SET_NARGS(2),___PRC(143),___L_c_23_stretchable_2d_vector_2d_ref)
___DEF_GLBL(___L7_c_23_ordered_2d_table_2d__3e_list)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bits_2d_and
#undef ___PH_LBL0
#define ___PH_LBL0 205
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bits_2d_and)
___DEF_P_HLBL(___L1_c_23_bits_2d_and)
___DEF_P_HLBL(___L2_c_23_bits_2d_and)
___DEF_P_HLBL(___L3_c_23_bits_2d_and)
___DEF_P_HLBL(___L4_c_23_bits_2d_and)
___DEF_P_HLBL(___L5_c_23_bits_2d_and)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bits_2d_and)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_bits_2d_and)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bits_2d_and)
   ___GOTO(___L7_c_23_bits_2d_and)
___DEF_GLBL(___L6_c_23_bits_2d_and)
   ___IF(___FIXEQ(___R2,___FIX(0L)))
   ___GOTO(___L8_c_23_bits_2d_and)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIXQUO(___R2,___FIX(2L)))
   ___SET_R1(___FIXQUO(___R1,___FIX(2L)))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_bits_2d_and)
___DEF_GLBL(___L7_c_23_bits_2d_and)
   ___IF(___NOT(___FIXEQ(___R1,___FIX(0L))))
   ___GOTO(___L6_c_23_bits_2d_and)
   ___END_IF
___DEF_GLBL(___L8_c_23_bits_2d_and)
   ___SET_R1(___FIX(0L))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_bits_2d_and)
   ___SET_R1(___FIXMUL(___R1,___FIX(2L)))
   ___IF(___NOT(___FIXODDP(___STK(-6))))
   ___GOTO(___L9_c_23_bits_2d_and)
   ___END_IF
   ___IF(___NOT(___FIXODDP(___STK(-5))))
   ___GOTO(___L9_c_23_bits_2d_and)
   ___END_IF
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_bits_2d_and)
   ___GOTO(___L10_c_23_bits_2d_and)
___DEF_GLBL(___L9_c_23_bits_2d_and)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_bits_2d_and)
___DEF_GLBL(___L10_c_23_bits_2d_and)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bits_2d_or
#undef ___PH_LBL0
#define ___PH_LBL0 212
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bits_2d_or)
___DEF_P_HLBL(___L1_c_23_bits_2d_or)
___DEF_P_HLBL(___L2_c_23_bits_2d_or)
___DEF_P_HLBL(___L3_c_23_bits_2d_or)
___DEF_P_HLBL(___L4_c_23_bits_2d_or)
___DEF_P_HLBL(___L5_c_23_bits_2d_or)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bits_2d_or)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_bits_2d_or)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bits_2d_or)
   ___GOTO(___L7_c_23_bits_2d_or)
___DEF_GLBL(___L6_c_23_bits_2d_or)
   ___IF(___FIXEQ(___R2,___FIX(0L)))
   ___GOTO(___L8_c_23_bits_2d_or)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIXQUO(___R2,___FIX(2L)))
   ___SET_R1(___FIXQUO(___R1,___FIX(2L)))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_bits_2d_or)
___DEF_GLBL(___L7_c_23_bits_2d_or)
   ___IF(___NOT(___FIXEQ(___R1,___FIX(0L))))
   ___GOTO(___L6_c_23_bits_2d_or)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23_bits_2d_or)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_bits_2d_or)
   ___SET_R1(___FIXMUL(___R1,___FIX(2L)))
   ___IF(___FIXODDP(___STK(-6)))
   ___GOTO(___L9_c_23_bits_2d_or)
   ___END_IF
   ___IF(___NOT(___FIXODDP(___STK(-5))))
   ___GOTO(___L11_c_23_bits_2d_or)
   ___END_IF
___DEF_GLBL(___L9_c_23_bits_2d_or)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_bits_2d_or)
___DEF_GLBL(___L10_c_23_bits_2d_or)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L11_c_23_bits_2d_or)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_bits_2d_or)
   ___GOTO(___L10_c_23_bits_2d_or)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bits_2d_shl
#undef ___PH_LBL0
#define ___PH_LBL0 219
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bits_2d_shl)
___DEF_P_HLBL(___L1_c_23_bits_2d_shl)
___DEF_P_HLBL(___L2_c_23_bits_2d_shl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bits_2d_shl)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_bits_2d_shl)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bits_2d_shl)
   ___GOTO(___L4_c_23_bits_2d_shl)
___DEF_GLBL(___L3_c_23_bits_2d_shl)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___FIXMUL(___R1,___FIX(2L)))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_bits_2d_shl)
___DEF_GLBL(___L4_c_23_bits_2d_shl)
   ___IF(___FIXGT(___R2,___FIX(0L)))
   ___GOTO(___L3_c_23_bits_2d_shl)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bits_2d_shr
#undef ___PH_LBL0
#define ___PH_LBL0 223
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bits_2d_shr)
___DEF_P_HLBL(___L1_c_23_bits_2d_shr)
___DEF_P_HLBL(___L2_c_23_bits_2d_shr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bits_2d_shr)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_bits_2d_shr)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bits_2d_shr)
   ___GOTO(___L4_c_23_bits_2d_shr)
___DEF_GLBL(___L3_c_23_bits_2d_shr)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___FIXQUO(___R1,___FIX(2L)))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_bits_2d_shr)
___DEF_GLBL(___L4_c_23_bits_2d_shr)
   ___IF(___FIXGT(___R2,___FIX(0L)))
   ___GOTO(___L3_c_23_bits_2d_shr)
   ___END_IF
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_with_2d_exception_2d_handling
#undef ___PH_LBL0
#define ___PH_LBL0 227
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_with_2d_exception_2d_handling)
___DEF_P_HLBL(___L1_c_23_with_2d_exception_2d_handling)
___DEF_P_HLBL(___L2_c_23_with_2d_exception_2d_handling)
___DEF_P_HLBL(___L3_c_23_with_2d_exception_2d_handling)
___DEF_P_HLBL(___L4_c_23_with_2d_exception_2d_handling)
___DEF_P_HLBL(___L5_c_23_with_2d_exception_2d_handling)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_with_2d_exception_2d_handling)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_with_2d_exception_2d_handling)
   ___SET_STK(1,___GLO(67,___G_c_23_throw_2d_to_2d_exception_2d_handler))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___LBL(4))
   ___SET_R2(___STK(3))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_with_2d_exception_2d_handling)
   ___JUMPPRM(___SET_NARGS(2),___PRM(91,___G__23__23_call_2d_with_2d_current_2d_continuation))
___DEF_SLBL(2,___L2_c_23_with_2d_exception_2d_handling)
   ___SET_GLO(67,___G_c_23_throw_2d_to_2d_exception_2d_handler,___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_with_2d_exception_2d_handling)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_SLBL(4,___L4_c_23_with_2d_exception_2d_handling)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(4,2,0,0)
   ___SET_GLO(67,___G_c_23_throw_2d_to_2d_exception_2d_handler,___R1)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_with_2d_exception_2d_handling)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 234
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_compiler_2d_error)
___DEF_P_HLBL(___L1_c_23_compiler_2d_error)
___DEF_P_HLBL(___L2_c_23_compiler_2d_error)
___DEF_P_HLBL(___L3_c_23_compiler_2d_error)
___DEF_P_HLBL(___L4_c_23_compiler_2d_error)
___DEF_P_HLBL(___L5_c_23_compiler_2d_error)
___DEF_P_HLBL(___L6_c_23_compiler_2d_error)
___DEF_P_HLBL(___L7_c_23_compiler_2d_error)
___DEF_P_HLBL(___L8_c_23_compiler_2d_error)
___DEF_P_HLBL(___L9_c_23_compiler_2d_error)
___DEF_P_HLBL(___L10_c_23_compiler_2d_error)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_compiler_2d_error)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L_c_23_compiler_2d_error)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(1))
   ___SET_R0(___LBL(10))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_compiler_2d_error)
   ___GOTO(___L12_c_23_compiler_2d_error)
___DEF_SLBL(2,___L2_c_23_compiler_2d_error)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_compiler_2d_error)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L13_c_23_compiler_2d_error)
   ___END_IF
___DEF_GLBL(___L11_c_23_compiler_2d_error)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(2))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_compiler_2d_error)
___DEF_GLBL(___L12_c_23_compiler_2d_error)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(5,___L5_c_23_compiler_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L11_c_23_compiler_2d_error)
   ___END_IF
___DEF_GLBL(___L13_c_23_compiler_2d_error)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_compiler_2d_error)
   ___SET_R0(___LBL(7))
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___DEF_SLBL(7,___L7_c_23_compiler_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(301),___L_c_23_compiler_2d_abort)
___DEF_SLBL(9,___L9_c_23_compiler_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM(106,___G_write))
___DEF_SLBL(10,___L10_c_23_compiler_2d_error)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_user_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 246
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L1_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L2_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L3_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L4_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L5_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L6_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L7_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L8_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L9_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L10_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L11_c_23_compiler_2d_user_2d_error)
___DEF_P_HLBL(___L12_c_23_compiler_2d_user_2d_error)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_compiler_2d_user_2d_error)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L_c_23_compiler_2d_user_2d_error)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___SUB(3))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_compiler_2d_user_2d_error)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(2,___L2_c_23_compiler_2d_user_2d_error)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(4))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),96,___G_c_23_locat_2d_show)
___DEF_SLBL(3,___L3_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___SUB(5))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(4,___L4_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(5,___L5_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(10))
   ___ADJFP(-4)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L13_c_23_compiler_2d_user_2d_error)
   ___END_IF
   ___GOTO(___L14_c_23_compiler_2d_user_2d_error)
___DEF_SLBL(6,___L6_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_compiler_2d_user_2d_error)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L14_c_23_compiler_2d_user_2d_error)
   ___END_IF
___DEF_GLBL(___L13_c_23_compiler_2d_user_2d_error)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(6))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_user_2d_error)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(9,___L9_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPPRM(___SET_NARGS(1),___PRM(106,___G_write))
___DEF_GLBL(___L14_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(10,___L10_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___DEF_SLBL(11,___L11_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_compiler_2d_user_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(301),___L_c_23_compiler_2d_abort)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_user_2d_warning
#undef ___PH_LBL0
#define ___PH_LBL0 260
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L1_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L2_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L3_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L4_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L5_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L6_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L7_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L8_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L9_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L10_c_23_compiler_2d_user_2d_warning)
___DEF_P_HLBL(___L11_c_23_compiler_2d_user_2d_warning)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_compiler_2d_user_2d_warning)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L_c_23_compiler_2d_user_2d_warning)
   ___IF(___FALSEP(___GLO(89,___G_c_23_warnings_2d_requested_3f_)))
   ___GOTO(___L13_c_23_compiler_2d_user_2d_warning)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___SUB(7))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_compiler_2d_user_2d_warning)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(2,___L2_c_23_compiler_2d_user_2d_warning)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(8))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),96,___G_c_23_locat_2d_show)
___DEF_SLBL(3,___L3_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___SUB(9))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(4,___L4_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(5,___L5_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(10))
   ___ADJFP(-4)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L12_c_23_compiler_2d_user_2d_warning)
   ___END_IF
   ___GOTO(___L13_c_23_compiler_2d_user_2d_warning)
___DEF_SLBL(6,___L6_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_compiler_2d_user_2d_warning)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L13_c_23_compiler_2d_user_2d_warning)
   ___END_IF
___DEF_GLBL(___L12_c_23_compiler_2d_user_2d_warning)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(10))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_user_2d_warning)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(9,___L9_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPPRM(___SET_NARGS(1),___PRM(106,___G_write))
___DEF_GLBL(___L13_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(10,___L10_c_23_compiler_2d_user_2d_warning)
   ___SET_R0(___STK(-3))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_compiler_2d_user_2d_warning)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_internal_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 273
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L1_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L2_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L3_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L4_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L5_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L6_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L7_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L8_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L9_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L10_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L11_c_23_compiler_2d_internal_2d_error)
___DEF_P_HLBL(___L12_c_23_compiler_2d_internal_2d_error)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_compiler_2d_internal_2d_error)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L_c_23_compiler_2d_internal_2d_error)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(11))
   ___SET_R0(___LBL(10))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_compiler_2d_internal_2d_error)
   ___GOTO(___L14_c_23_compiler_2d_internal_2d_error)
___DEF_SLBL(2,___L2_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_compiler_2d_internal_2d_error)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L15_c_23_compiler_2d_internal_2d_error)
   ___END_IF
___DEF_GLBL(___L13_c_23_compiler_2d_internal_2d_error)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(12))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L14_c_23_compiler_2d_internal_2d_error)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(5,___L5_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L13_c_23_compiler_2d_internal_2d_error)
   ___END_IF
___DEF_GLBL(___L15_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_compiler_2d_internal_2d_error)
   ___SET_R0(___LBL(7))
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___DEF_SLBL(7,___L7_c_23_compiler_2d_internal_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_internal_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(301),___L_c_23_compiler_2d_abort)
___DEF_SLBL(9,___L9_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM(106,___G_write))
___DEF_SLBL(10,___L10_c_23_compiler_2d_internal_2d_error)
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___DEF_SLBL(11,___L11_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___SUB(13))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(12,___L12_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_limitation_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 287
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L1_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L2_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L3_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L4_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L5_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L6_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L7_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L8_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L9_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L10_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L11_c_23_compiler_2d_limitation_2d_error)
___DEF_P_HLBL(___L12_c_23_compiler_2d_limitation_2d_error)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_compiler_2d_limitation_2d_error)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L_c_23_compiler_2d_limitation_2d_error)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(14))
   ___SET_R0(___LBL(10))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_compiler_2d_limitation_2d_error)
   ___GOTO(___L14_c_23_compiler_2d_limitation_2d_error)
___DEF_SLBL(2,___L2_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_compiler_2d_limitation_2d_error)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L15_c_23_compiler_2d_limitation_2d_error)
   ___END_IF
___DEF_GLBL(___L13_c_23_compiler_2d_limitation_2d_error)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___SUB(15))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_compiler_2d_limitation_2d_error)
___DEF_GLBL(___L14_c_23_compiler_2d_limitation_2d_error)
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(5,___L5_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L13_c_23_compiler_2d_limitation_2d_error)
   ___END_IF
___DEF_GLBL(___L15_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_compiler_2d_limitation_2d_error)
   ___SET_R0(___LBL(7))
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___DEF_SLBL(7,___L7_c_23_compiler_2d_limitation_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_limitation_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(301),___L_c_23_compiler_2d_abort)
___DEF_SLBL(9,___L9_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM(106,___G_write))
___DEF_SLBL(10,___L10_c_23_compiler_2d_limitation_2d_error)
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(0),___PRM(102,___G_newline))
___DEF_SLBL(11,___L11_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___SUB(16))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___DEF_SLBL(12,___L12_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM(97,___G_display))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_abort
#undef ___PH_LBL0
#define ___PH_LBL0 301
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_compiler_2d_abort)
___DEF_P_HLBL(___L1_c_23_compiler_2d_abort)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_compiler_2d_abort)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_compiler_2d_abort)
   ___SET_R1(___FAL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_compiler_2d_abort)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),67,___G_c_23_throw_2d_to_2d_exception_2d_handler)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_gnode
#undef ___PH_LBL0
#define ___PH_LBL0 304
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_gnode)
___DEF_P_HLBL(___L1_c_23_make_2d_gnode)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_gnode)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_make_2d_gnode)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R2)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_make_2d_gnode)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_gnode_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 307
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_gnode_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_gnode_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_gnode_2d_var)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_gnode_2d_depvars
#undef ___PH_LBL0
#define ___PH_LBL0 309
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_gnode_2d_depvars)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_gnode_2d_depvars)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_gnode_2d_depvars)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_transitive_2d_closure
#undef ___PH_LBL0
#define ___PH_LBL0 311
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L1_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L2_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L3_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L4_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L5_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L6_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L7_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L8_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L9_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L10_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L11_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L12_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L13_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L14_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L15_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L16_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L17_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L18_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L19_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L20_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L21_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L22_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L23_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L24_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L25_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L26_c_23_transitive_2d_closure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_transitive_2d_closure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_transitive_2d_closure)
   ___SET_STK(1,___R0)
   ___SET_R2(___LBL(25))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(2),___PRC(93),___L_c_23_sort_2d_list)
___DEF_SLBL(2,___L2_c_23_transitive_2d_closure)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(114),___L_c_23_list_2d__3e_vect)
___DEF_SLBL(3,___L3_c_23_transitive_2d_closure)
   ___SET_R2(___VECTORLENGTH(___R1))
   ___SET_STK(-2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_transitive_2d_closure)
   ___GOTO(___L27_c_23_transitive_2d_closure)
___DEF_SLBL(5,___L5_c_23_transitive_2d_closure)
   ___IF(___NOT(___NOT(___FALSEP(___UNBOX(___STK(-4))))))
   ___GOTO(___L33_c_23_transitive_2d_closure)
   ___END_IF
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_transitive_2d_closure)
___DEF_GLBL(___L27_c_23_transitive_2d_closure)
   ___SET_R3(___BOX(___FAL))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_transitive_2d_closure)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_transitive_2d_closure)
   ___JUMPPRM(___SET_NARGS(1),___PRM(101,___G_make_2d_vector))
___DEF_SLBL(9,___L9_c_23_transitive_2d_closure)
   ___SET_STK(1,___STK(-6))
   ___SET_STK(2,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___LBL(5))
   ___ADJFP(2)
   ___IF(___FIXEQ(___R3,___STK(-1)))
   ___GOTO(___L32_c_23_transitive_2d_closure)
   ___END_IF
   ___GOTO(___L29_c_23_transitive_2d_closure)
___DEF_SLBL(10,___L10_c_23_transitive_2d_closure)
   ___IF(___FIXEQ(___STK(-3),___R1))
   ___GOTO(___L28_c_23_transitive_2d_closure)
   ___END_IF
   ___SETBOX(___STK(-7),___TRU)
___DEF_GLBL(___L28_c_23_transitive_2d_closure)
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___STK(-9))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___VECTORSET(___STK(-6),___STK(-5),___R1)
   ___SET_R3(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___ADJFP(-10)
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_transitive_2d_closure)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_transitive_2d_closure)
   ___IF(___FIXEQ(___R3,___STK(-1)))
   ___GOTO(___L32_c_23_transitive_2d_closure)
   ___END_IF
___DEF_GLBL(___L29_c_23_transitive_2d_closure)
   ___SET_R4(___VECTORREF(___STK(0),___R3))
   ___SET_STK(1,___R4)
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(1L)))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(14))
   ___ADJFP(10)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(1),___PRC(475),___L_c_23_varset_2d__3e_list)
___DEF_SLBL(14,___L14_c_23_transitive_2d_closure)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(20))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L30_c_23_transitive_2d_closure)
   ___END_IF
   ___GOTO(___L31_c_23_transitive_2d_closure)
___DEF_SLBL(15,___L15_c_23_transitive_2d_closure)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L31_c_23_transitive_2d_closure)
   ___END_IF
___DEF_GLBL(___L30_c_23_transitive_2d_closure)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(15))
   ___ADJFP(8)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(2),___PRC(339),___L_c_23_gnode_2d_find_2d_depvars)
___DEF_GLBL(___L31_c_23_transitive_2d_closure)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(17,___L17_c_23_transitive_2d_closure)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(18,4096)
___DEF_SLBL(18,___L18_c_23_transitive_2d_closure)
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_transitive_2d_closure)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(20,___L20_c_23_transitive_2d_closure)
   ___SET_R1(___CONS(___STK(-9),___R1))
   ___SET_R0(___LBL(22))
   ___CHECK_HEAP(21,4096)
___DEF_SLBL(21,___L21_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(1),___PRC(556),___L_c_23_varset_2d_union_2d_multi)
___DEF_SLBL(22,___L22_c_23_transitive_2d_closure)
   ___SET_STK(-9,___R1)
   ___SET_R0(___LBL(23))
   ___JUMPINT(___SET_NARGS(1),___PRC(477),___L_c_23_varset_2d_size)
___DEF_SLBL(23,___L23_c_23_transitive_2d_closure)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___STK(-4))
   ___SET_R1(___VECTORREF(___STK(-2),___FIX(1L)))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(477),___L_c_23_varset_2d_size)
___DEF_GLBL(___L32_c_23_transitive_2d_closure)
   ___SET_R1(___R2)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L33_c_23_transitive_2d_closure)
   ___SET_R0(___STK(-7))
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_transitive_2d_closure)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(121),___L_c_23_vect_2d__3e_list)
___DEF_SLBL(25,___L25_c_23_transitive_2d_closure)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(25,2,0,0)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___R2,___FIX(0L)))
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_transitive_2d_closure)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_gnode_2d_find_2d_depvars
#undef ___PH_LBL0
#define ___PH_LBL0 339
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_gnode_2d_find_2d_depvars)
___DEF_P_HLBL(___L1_c_23_gnode_2d_find_2d_depvars)
___DEF_P_HLBL(___L2_c_23_gnode_2d_find_2d_depvars)
___DEF_P_HLBL(___L3_c_23_gnode_2d_find_2d_depvars)
___DEF_P_HLBL(___L4_c_23_gnode_2d_find_2d_depvars)
___DEF_P_HLBL(___L5_c_23_gnode_2d_find_2d_depvars)
___DEF_P_HLBL(___L6_c_23_gnode_2d_find_2d_depvars)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_gnode_2d_find_2d_depvars)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_gnode_2d_find_2d_depvars)
   ___SET_STK(1,___R1)
   ___SET_R1(___VECTORLENGTH(___R2))
   ___SET_R3(___FIXSUB(___R1,___FIX(1L)))
   ___SET_R1(___R2)
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_gnode_2d_find_2d_depvars)
   ___GOTO(___L7_c_23_gnode_2d_find_2d_depvars)
___DEF_SLBL(2,___L2_c_23_gnode_2d_find_2d_depvars)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_gnode_2d_find_2d_depvars)
   ___END_IF
   ___SET_R3(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_gnode_2d_find_2d_depvars)
___DEF_GLBL(___L7_c_23_gnode_2d_find_2d_depvars)
   ___IF(___NOT(___FIXLT(___R3,___R2)))
   ___GOTO(___L8_c_23_gnode_2d_find_2d_depvars)
   ___END_IF
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_gnode_2d_find_2d_depvars)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(0),___PRC(455),___L_c_23_varset_2d_empty)
___DEF_GLBL(___L8_c_23_gnode_2d_find_2d_depvars)
   ___SET_R4(___FIXADD(___R3,___R2))
   ___SET_R4(___FIXQUO(___R4,___FIX(2L)))
   ___SET_STK(1,___VECTORREF(___R1,___R4))
   ___SET_STK(2,___STK(1))
   ___SET_STK(2,___VECTORREF(___STK(2),___FIX(0L)))
   ___ADJFP(2)
   ___IF(___EQP(___STK(0),___STK(-2)))
   ___GOTO(___L9_c_23_gnode_2d_find_2d_depvars)
   ___END_IF
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R4)
   ___SET_R2(___VECTORREF(___STK(-1),___FIX(0L)))
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_gnode_2d_find_2d_depvars)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L9_c_23_gnode_2d_find_2d_depvars)
   ___SET_R1(___VECTORREF(___STK(-1),___FIX(1L)))
   ___ADJFP(-3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L10_c_23_gnode_2d_find_2d_depvars)
   ___SET_R3(___STK(-6))
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_gnode_2d_find_2d_depvars)
   ___GOTO(___L7_c_23_gnode_2d_find_2d_depvars)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_gnodes_2d_remove
#undef ___PH_LBL0
#define ___PH_LBL0 347
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L1_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L2_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L3_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L4_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L5_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L6_c_23_gnodes_2d_remove)
___DEF_P_HLBL(___L7_c_23_gnodes_2d_remove)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_gnodes_2d_remove)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_gnodes_2d_remove)
   ___IF(___NULLP(___R1))
   ___GOTO(___L13_c_23_gnodes_2d_remove)
   ___END_IF
   ___GOTO(___L8_c_23_gnodes_2d_remove)
___DEF_SLBL(1,___L1_c_23_gnodes_2d_remove)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L12_c_23_gnodes_2d_remove)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_gnodes_2d_remove)
   ___IF(___NULLP(___R1))
   ___GOTO(___L13_c_23_gnodes_2d_remove)
   ___END_IF
___DEF_GLBL(___L8_c_23_gnodes_2d_remove)
   ___SET_R3(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_gnodes_2d_remove)
___DEF_GLBL(___L9_c_23_gnodes_2d_remove)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L11_c_23_gnodes_2d_remove)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L10_c_23_gnodes_2d_remove)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_gnodes_2d_remove)
   ___GOTO(___L9_c_23_gnodes_2d_remove)
___DEF_GLBL(___L10_c_23_gnodes_2d_remove)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L11_c_23_gnodes_2d_remove)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L12_c_23_gnodes_2d_remove)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(5))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L8_c_23_gnodes_2d_remove)
   ___END_IF
___DEF_GLBL(___L13_c_23_gnodes_2d_remove)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(5,___L5_c_23_gnodes_2d_remove)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_gnodes_2d_remove)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_gnodes_2d_remove)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_topological_2d_sort
#undef ___PH_LBL0
#define ___PH_LBL0 356
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_topological_2d_sort)
___DEF_P_HLBL(___L1_c_23_topological_2d_sort)
___DEF_P_HLBL(___L2_c_23_topological_2d_sort)
___DEF_P_HLBL(___L3_c_23_topological_2d_sort)
___DEF_P_HLBL(___L4_c_23_topological_2d_sort)
___DEF_P_HLBL(___L5_c_23_topological_2d_sort)
___DEF_P_HLBL(___L6_c_23_topological_2d_sort)
___DEF_P_HLBL(___L7_c_23_topological_2d_sort)
___DEF_P_HLBL(___L8_c_23_topological_2d_sort)
___DEF_P_HLBL(___L9_c_23_topological_2d_sort)
___DEF_P_HLBL(___L10_c_23_topological_2d_sort)
___DEF_P_HLBL(___L11_c_23_topological_2d_sort)
___DEF_P_HLBL(___L12_c_23_topological_2d_sort)
___DEF_P_HLBL(___L13_c_23_topological_2d_sort)
___DEF_P_HLBL(___L14_c_23_topological_2d_sort)
___DEF_P_HLBL(___L15_c_23_topological_2d_sort)
___DEF_P_HLBL(___L16_c_23_topological_2d_sort)
___DEF_P_HLBL(___L17_c_23_topological_2d_sort)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_topological_2d_sort)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_topological_2d_sort)
   ___IF(___NULLP(___R1))
   ___GOTO(___L21_c_23_topological_2d_sort)
   ___END_IF
   ___GOTO(___L18_c_23_topological_2d_sort)
___DEF_SLBL(1,___L1_c_23_topological_2d_sort)
   ___SET_R0(___LBL(9))
   ___IF(___NULLP(___R1))
   ___GOTO(___L21_c_23_topological_2d_sort)
   ___END_IF
___DEF_GLBL(___L18_c_23_topological_2d_sort)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_topological_2d_sort)
   ___JUMPINT(___SET_NARGS(1),___PRC(375),___L_c_23_remove_2d_no_2d_depvars)
___DEF_SLBL(3,___L3_c_23_topological_2d_sort)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L24_c_23_topological_2d_sort)
   ___END_IF
   ___GOTO(___L19_c_23_topological_2d_sort)
___DEF_SLBL(4,___L4_c_23_topological_2d_sort)
___DEF_GLBL(___L19_c_23_topological_2d_sort)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(12))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L21_c_23_topological_2d_sort)
   ___END_IF
___DEF_GLBL(___L20_c_23_topological_2d_sort)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___VECTORREF(___R2,___FIX(0L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_topological_2d_sort)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L20_c_23_topological_2d_sort)
   ___END_IF
___DEF_GLBL(___L21_c_23_topological_2d_sort)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_topological_2d_sort)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_topological_2d_sort)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_topological_2d_sort)
   ___GOTO(___L22_c_23_topological_2d_sort)
___DEF_SLBL(9,___L9_c_23_topological_2d_sort)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_topological_2d_sort)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_topological_2d_sort)
___DEF_GLBL(___L22_c_23_topological_2d_sort)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(12,___L12_c_23_topological_2d_sort)
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(1),___PRC(461),___L_c_23_list_2d__3e_varset)
___DEF_SLBL(13,___L13_c_23_topological_2d_sort)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(2),___PRC(347),___L_c_23_gnodes_2d_remove)
___DEF_SLBL(14,___L14_c_23_topological_2d_sort)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(1))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L23_c_23_topological_2d_sort)
   ___END_IF
   ___GOTO(___L21_c_23_topological_2d_sort)
___DEF_SLBL(15,___L15_c_23_topological_2d_sort)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___STK(-4))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___CHECK_HEAP(16,4096)
___DEF_SLBL(16,___L16_c_23_topological_2d_sort)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L21_c_23_topological_2d_sort)
   ___END_IF
___DEF_GLBL(___L23_c_23_topological_2d_sort)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___VECTORREF(___R3,___FIX(0L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R4)
   ___SET_R2(___R1)
   ___SET_R1(___VECTORREF(___R3,___FIX(1L)))
   ___SET_R0(___LBL(15))
   ___ADJFP(8)
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_topological_2d_sort)
   ___JUMPINT(___SET_NARGS(2),___PRC(516),___L_c_23_varset_2d_difference)
___DEF_GLBL(___L24_c_23_topological_2d_sort)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(383),___L_c_23_remove_2d_cycle)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_remove_2d_no_2d_depvars
#undef ___PH_LBL0
#define ___PH_LBL0 375
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L1_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L2_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L3_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L4_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L5_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L6_c_23_remove_2d_no_2d_depvars)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_remove_2d_no_2d_depvars)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_remove_2d_no_2d_depvars)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___LBL(5))
   ___SET_R2(___STK(2))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_remove_2d_no_2d_depvars)
   ___JUMPINT(___SET_NARGS(2),___PRC(72),___L_c_23_keep)
___DEF_SLBL(2,___L2_c_23_remove_2d_no_2d_depvars)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L7_c_23_remove_2d_no_2d_depvars)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_remove_2d_no_2d_depvars)
   ___GOTO(___L8_c_23_remove_2d_no_2d_depvars)
___DEF_GLBL(___L7_c_23_remove_2d_no_2d_depvars)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_remove_2d_no_2d_depvars)
___DEF_GLBL(___L8_c_23_remove_2d_no_2d_depvars)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(5,___L5_c_23_remove_2d_no_2d_depvars)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(5,1,0,0)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_remove_2d_no_2d_depvars)
   ___JUMPINT(___SET_NARGS(1),___PRC(480),___L_c_23_varset_2d_empty_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_remove_2d_cycle
#undef ___PH_LBL0
#define ___PH_LBL0 383
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L1_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L2_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L3_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L4_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L5_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L6_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L7_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L8_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L9_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L10_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L11_c_23_remove_2d_cycle)
___DEF_P_HLBL(___L12_c_23_remove_2d_cycle)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_remove_2d_cycle)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_remove_2d_cycle)
   ___SET_R2(___R1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_remove_2d_cycle)
   ___GOTO(___L14_c_23_remove_2d_cycle)
___DEF_SLBL(2,___L2_c_23_remove_2d_cycle)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L15_c_23_remove_2d_cycle)
   ___END_IF
___DEF_GLBL(___L13_c_23_remove_2d_cycle)
   ___SET_R2(___CDR(___STK(-3)))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-5))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_remove_2d_cycle)
___DEF_GLBL(___L14_c_23_remove_2d_cycle)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R3)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(1L)))
   ___SET_STK(1,___ALLOC_CLO(1))
   ___SET_STK(2,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),10)
   ___ADD_CLO_ELEM(0,___R4)
   ___END_SETUP_CLO(1)
   ___BEGIN_SETUP_CLO(1,___STK(2),8)
   ___ADD_CLO_ELEM(0,___R4)
   ___END_SETUP_CLO(1)
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___SET_STK(5,___R2)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_remove_2d_cycle)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_remove_2d_cycle)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-6))
___DEF_SLBL(6,___L6_c_23_remove_2d_cycle)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L13_c_23_remove_2d_cycle)
   ___END_IF
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(72),___L_c_23_keep)
___DEF_SLBL(7,___L7_c_23_remove_2d_cycle)
   ___SET_STK(-6,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(2),___PRC(81),___L_c_23_every_3f_)
___DEF_SLBL(8,___L8_c_23_remove_2d_cycle)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(8,1,0,0)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R2(___CLO(___R4,1))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_remove_2d_cycle)
   ___JUMPINT(___SET_NARGS(2),___PRC(484),___L_c_23_varset_2d_member_3f_)
___DEF_SLBL(10,___L10_c_23_remove_2d_cycle)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(10,1,0,0)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___SET_R2(___CLO(___R4,1))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_remove_2d_cycle)
   ___JUMPINT(___SET_NARGS(2),___PRC(512),___L_c_23_varset_2d_equal_3f_)
___DEF_GLBL(___L15_c_23_remove_2d_cycle)
   ___SET_R1(___STK(-6))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_remove_2d_cycle)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_empty
#undef ___PH_LBL0
#define ___PH_LBL0 397
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_empty)
___DEF_P_HLBL(___L1_c_23_ptset_2d_empty)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_empty)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_empty)
   ___BEGIN_ALLOC_VECTOR(11)
   ___ADD_VECTOR_ELEM(0,___NUL)
   ___ADD_VECTOR_ELEM(1,___NUL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___NUL)
   ___ADD_VECTOR_ELEM(4,___NUL)
   ___ADD_VECTOR_ELEM(5,___NUL)
   ___ADD_VECTOR_ELEM(6,___NUL)
   ___ADD_VECTOR_ELEM(7,___NUL)
   ___ADD_VECTOR_ELEM(8,___NUL)
   ___ADD_VECTOR_ELEM(9,___NUL)
   ___ADD_VECTOR_ELEM(10,___NUL)
   ___END_ALLOC_VECTOR(11)
   ___SET_R1(___GET_VECTOR(11))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_ptset_2d_empty)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 400
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d__3e_list)
___DEF_P_HLBL(___L1_c_23_ptset_2d__3e_list)
___DEF_P_HLBL(___L2_c_23_ptset_2d__3e_list)
___DEF_P_HLBL(___L3_c_23_ptset_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ptset_2d__3e_list)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d__3e_list)
   ___JUMPINT(___SET_NARGS(1),___PRC(121),___L_c_23_vect_2d__3e_list)
___DEF_SLBL(2,___L2_c_23_ptset_2d__3e_list)
   ___SET_R2(___R1)
   ___SET_R1(___PRM(93,___G_append))
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ptset_2d__3e_list)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(2),___PRM(94,___G_apply))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_size
#undef ___PH_LBL0
#define ___PH_LBL0 405
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_size)
___DEF_P_HLBL(___L1_c_23_ptset_2d_size)
___DEF_P_HLBL(___L2_c_23_ptset_2d_size)
___DEF_P_HLBL(___L3_c_23_ptset_2d_size)
___DEF_P_HLBL(___L4_c_23_ptset_2d_size)
___DEF_P_HLBL(___L5_c_23_ptset_2d_size)
___DEF_P_HLBL(___L6_c_23_ptset_2d_size)
___DEF_P_HLBL(___L7_c_23_ptset_2d_size)
___DEF_P_HLBL(___L8_c_23_ptset_2d_size)
___DEF_P_HLBL(___L9_c_23_ptset_2d_size)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_size)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_size)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d_size)
   ___JUMPINT(___SET_NARGS(1),___PRC(121),___L_c_23_vect_2d__3e_list)
___DEF_SLBL(2,___L2_c_23_ptset_2d_size)
   ___SET_R0(___LBL(8))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L10_c_23_ptset_2d_size)
   ___END_IF
   ___GOTO(___L11_c_23_ptset_2d_size)
___DEF_SLBL(3,___L3_c_23_ptset_2d_size)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(5))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L11_c_23_ptset_2d_size)
   ___END_IF
___DEF_GLBL(___L10_c_23_ptset_2d_size)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_ptset_2d_size)
   ___JUMPINT(___SET_NARGS(1),___PRC(18),___L_c_23_list_2d_length)
___DEF_GLBL(___L11_c_23_ptset_2d_size)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(5,___L5_c_23_ptset_2d_size)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_ptset_2d_size)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_ptset_2d_size)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(8,___L8_c_23_ptset_2d_size)
   ___SET_R2(___R1)
   ___SET_R1(___PRM(92,___G__2b_))
   ___SET_R0(___STK(-3))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_ptset_2d_size)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(2),___PRM(94,___G_apply))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_empty_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 416
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_empty_3f_)
___DEF_P_HLBL(___L1_c_23_ptset_2d_empty_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_empty_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_empty_3f_)
   ___IF(___EQP(___R1,___GLO(42,___G_c_23_ptset_2d_empty_2d_set)))
   ___GOTO(___L3_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___IF(___NOT(___MEMALLOCATEDP(___R1)))
   ___GOTO(___L2_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___IF(___NOT(___MEMALLOCATEDP(___GLO(42,___G_c_23_ptset_2d_empty_2d_set))))
   ___GOTO(___L2_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___SET_R2(___SUBTYPE(___R1))
   ___SET_R3(___SUBTYPE(___GLO(42,___G_c_23_ptset_2d_empty_2d_set)))
   ___IF(___NOT(___FIXEQ(___R2,___R3)))
   ___GOTO(___L2_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___SET_R2(___GLO(42,___G_c_23_ptset_2d_empty_2d_set))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d_empty_3f_)
   ___JUMPPRM(___SET_NARGS(2),___PRM(98,___G_equal_3f_))
___DEF_GLBL(___L2_c_23_ptset_2d_empty_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L3_c_23_ptset_2d_empty_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_member_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 419
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_member_3f_)
___DEF_P_HLBL(___L1_c_23_ptset_2d_member_3f_)
___DEF_P_HLBL(___L2_c_23_ptset_2d_member_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_member_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_member_3f_)
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(7L)))
   ___SET_R3(___FIXMOD(___R3,___FIX(11L)))
   ___SET_R2(___VECTORREF(___R2,___R3))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d_member_3f_)
   ___GOTO(___L4_c_23_ptset_2d_member_3f_)
___DEF_GLBL(___L3_c_23_ptset_2d_member_3f_)
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L5_c_23_ptset_2d_member_3f_)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_ptset_2d_member_3f_)
___DEF_GLBL(___L4_c_23_ptset_2d_member_3f_)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3_c_23_ptset_2d_member_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5_c_23_ptset_2d_member_3f_)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_adjoin
#undef ___PH_LBL0
#define ___PH_LBL0 423
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_adjoin)
___DEF_P_HLBL(___L1_c_23_ptset_2d_adjoin)
___DEF_P_HLBL(___L2_c_23_ptset_2d_adjoin)
___DEF_P_HLBL(___L3_c_23_ptset_2d_adjoin)
___DEF_P_HLBL(___L4_c_23_ptset_2d_adjoin)
___DEF_P_HLBL(___L5_c_23_ptset_2d_adjoin)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_adjoin)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_adjoin)
   ___SET_STK(1,___R2)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(7L)))
   ___SET_R3(___FIXMOD(___R3,___FIX(11L)))
   ___SET_R4(___VECTORREF(___R1,___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___R4)
   ___SET_R1(___STK(3))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d_adjoin)
   ___GOTO(___L7_c_23_ptset_2d_adjoin)
___DEF_GLBL(___L6_c_23_ptset_2d_adjoin)
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L8_c_23_ptset_2d_adjoin)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_ptset_2d_adjoin)
___DEF_GLBL(___L7_c_23_ptset_2d_adjoin)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L6_c_23_ptset_2d_adjoin)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23_ptset_2d_adjoin)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_ptset_2d_adjoin)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L9_c_23_ptset_2d_adjoin)
   ___END_IF
   ___SET_R1(___CONS(___STK(-5),___STK(-3)))
   ___VECTORSET(___STK(-6),___STK(-4),___R1)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_ptset_2d_adjoin)
___DEF_GLBL(___L9_c_23_ptset_2d_adjoin)
   ___SET_R1(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_ptset_2d_adjoin)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_every_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 430
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L1_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L2_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L3_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L4_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L5_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L6_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L7_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L8_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L9_c_23_ptset_2d_every_3f_)
___DEF_P_HLBL(___L10_c_23_ptset_2d_every_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_every_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_every_3f_)
   ___SET_STK(1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),9)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_STK(2,___R0)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_ptset_2d_every_3f_)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_ptset_2d_every_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(121),___L_c_23_vect_2d__3e_list)
___DEF_SLBL(3,___L3_c_23_ptset_2d_every_3f_)
   ___SET_R2(___R1)
   ___SET_R0(___STK(-6))
   ___SET_R1(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_ptset_2d_every_3f_)
   ___GOTO(___L11_c_23_ptset_2d_every_3f_)
___DEF_SLBL(5,___L5_c_23_ptset_2d_every_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L13_c_23_ptset_2d_every_3f_)
   ___END_IF
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_ptset_2d_every_3f_)
___DEF_GLBL(___L11_c_23_ptset_2d_every_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L12_c_23_ptset_2d_every_3f_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R2))
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_ptset_2d_every_3f_)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-6))
___DEF_GLBL(___L12_c_23_ptset_2d_every_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L13_c_23_ptset_2d_every_3f_)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_ptset_2d_every_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(9,___L9_c_23_ptset_2d_every_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(9,1,0,0)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_ptset_2d_every_3f_)
   ___GOTO(___L11_c_23_ptset_2d_every_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_remove
#undef ___PH_LBL0
#define ___PH_LBL0 442
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptset_2d_remove)
___DEF_P_HLBL(___L1_c_23_ptset_2d_remove)
___DEF_P_HLBL(___L2_c_23_ptset_2d_remove)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptset_2d_remove)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ptset_2d_remove)
   ___SET_STK(1,___R2)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(7L)))
   ___SET_R3(___FIXMOD(___R3,___FIX(11L)))
   ___SET_R4(___VECTORREF(___R1,___R3))
   ___ADJFP(1)
   ___IF(___NULLP(___R4))
   ___GOTO(___L7_c_23_ptset_2d_remove)
   ___END_IF
   ___SET_STK(0,___CAR(___R4))
   ___IF(___EQP(___R2,___STK(0)))
   ___GOTO(___L6_c_23_ptset_2d_remove)
   ___END_IF
   ___SET_STK(0,___R1)
   ___SET_R1(___R2)
   ___SET_R3(___CDR(___R4))
   ___SET_R2(___R4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d_remove)
   ___GOTO(___L4_c_23_ptset_2d_remove)
___DEF_GLBL(___L3_c_23_ptset_2d_remove)
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R4,___R1))
   ___GOTO(___L5_c_23_ptset_2d_remove)
   ___END_IF
   ___SET_R2(___CDR(___R3))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___STK(1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_ptset_2d_remove)
___DEF_GLBL(___L4_c_23_ptset_2d_remove)
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L3_c_23_ptset_2d_remove)
   ___END_IF
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5_c_23_ptset_2d_remove)
   ___SET_R1(___CDR(___R3))
   ___SETCDR(___R2,___R1)
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6_c_23_ptset_2d_remove)
   ___SET_R2(___CDR(___R4))
   ___VECTORSET(___R1,___R3,___R2)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L7_c_23_ptset_2d_remove)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_reverse_2d_append_21_
#undef ___PH_LBL0
#define ___PH_LBL0 446
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_reverse_2d_append_21_)
___DEF_P_HLBL(___L1_c_23_varset_2d_reverse_2d_append_21_)
___DEF_P_HLBL(___L2_c_23_varset_2d_reverse_2d_append_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_reverse_2d_append_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_reverse_2d_append_21_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L5_c_23_varset_2d_reverse_2d_append_21_)
   ___END_IF
   ___GOTO(___L4_c_23_varset_2d_reverse_2d_append_21_)
___DEF_GLBL(___L3_c_23_varset_2d_reverse_2d_append_21_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L5_c_23_varset_2d_reverse_2d_append_21_)
   ___END_IF
___DEF_GLBL(___L4_c_23_varset_2d_reverse_2d_append_21_)
   ___SET_R3(___CDR(___R1))
   ___SETCDR(___R1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_reverse_2d_append_21_)
   ___GOTO(___L3_c_23_varset_2d_reverse_2d_append_21_)
___DEF_GLBL(___L5_c_23_varset_2d_reverse_2d_append_21_)
   ___SET_R1(___CONS(___FAL,___R2))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_varset_2d_reverse_2d_append_21_)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_wrap
#undef ___PH_LBL0
#define ___PH_LBL0 450
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_wrap)
___DEF_P_HLBL(___L1_c_23_varset_2d_wrap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_wrap)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d_wrap)
   ___SET_R1(___CONS(___FAL,___R1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_varset_2d_wrap)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_unwrap
#undef ___PH_LBL0
#define ___PH_LBL0 453
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_unwrap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_unwrap)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d_unwrap)
   ___SET_R1(___CDR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_empty
#undef ___PH_LBL0
#define ___PH_LBL0 455
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_empty)
___DEF_P_HLBL(___L1_c_23_varset_2d_empty)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_empty)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_varset_2d_empty)
   ___SET_R1(___CONS(___FAL,___NUL))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_varset_2d_empty)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_singleton
#undef ___PH_LBL0
#define ___PH_LBL0 458
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_singleton)
___DEF_P_HLBL(___L1_c_23_varset_2d_singleton)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_singleton)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d_singleton)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R1(___CONS(___FAL,___R1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_varset_2d_singleton)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_list_2d__3e_varset
#undef ___PH_LBL0
#define ___PH_LBL0 461
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L1_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L2_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L3_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L4_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L5_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L6_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L7_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L8_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L9_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L10_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L11_c_23_list_2d__3e_varset)
___DEF_P_HLBL(___L12_c_23_list_2d__3e_varset)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d__3e_varset)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_list_2d__3e_varset)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L13_c_23_list_2d__3e_varset)
   ___END_IF
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_list_2d__3e_varset)
   ___JUMPINT(___SET_NARGS(0),___PRC(455),___L_c_23_varset_2d_empty)
___DEF_GLBL(___L13_c_23_list_2d__3e_varset)
   ___SET_R3(___CDR(___R1))
   ___SET_R2(___CAR(___R1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_varset)
   ___GOTO(___L14_c_23_list_2d__3e_varset)
___DEF_SLBL(3,___L3_c_23_list_2d__3e_varset)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L16_c_23_list_2d__3e_varset)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R3(___CDR(___STK(-5)))
   ___SET_R2(___CAR(___STK(-5)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_list_2d__3e_varset)
___DEF_GLBL(___L14_c_23_list_2d__3e_varset)
   ___IF(___NULLP(___R3))
   ___GOTO(___L15_c_23_list_2d__3e_varset)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R1(___CAR(___R3))
   ___SET_STK(4,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(4))
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_list_2d__3e_varset)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L15_c_23_list_2d__3e_varset)
   ___SET_R1(___CONS(___FAL,___R1))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_list_2d__3e_varset)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L16_c_23_list_2d__3e_varset)
   ___SET_R1(___STK(-6))
   ___SET_R2(___NUL)
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_list_2d__3e_varset)
   ___GOTO(___L17_c_23_list_2d__3e_varset)
___DEF_SLBL(8,___L8_c_23_list_2d__3e_varset)
   ___SET_R2(___CONS(___R1,___STK(-5)))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_list_2d__3e_varset)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_list_2d__3e_varset)
___DEF_GLBL(___L17_c_23_list_2d__3e_varset)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L18_c_23_list_2d__3e_varset)
   ___END_IF
   ___SET_R1(___R2)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_list_2d__3e_varset)
   ___JUMPINT(___SET_NARGS(1),___PRC(556),___L_c_23_varset_2d_union_2d_multi)
___DEF_GLBL(___L18_c_23_list_2d__3e_varset)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(8))
   ___ADJFP(8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_list_2d__3e_varset)
   ___JUMPINT(___SET_NARGS(1),___PRC(458),___L_c_23_varset_2d_singleton)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 475
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d__3e_list)
   ___SET_R1(___CDR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_size
#undef ___PH_LBL0
#define ___PH_LBL0 477
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_size)
___DEF_P_HLBL(___L1_c_23_varset_2d_size)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_size)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d_size)
   ___SET_R2(___CAR(___R1))
   ___IF(___NOT(___FALSEP(___R2)))
   ___GOTO(___L2_c_23_varset_2d_size)
   ___END_IF
   ___SET_R1(___CDR(___R1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_size)
   ___JUMPINT(___SET_NARGS(1),___PRC(18),___L_c_23_list_2d_length)
___DEF_GLBL(___L2_c_23_varset_2d_size)
   ___SET_R1(___VECTORLENGTH(___R2))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_empty_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 480
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_empty_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_empty_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d_empty_3f_)
   ___SET_R1(___CDR(___R1))
   ___SET_R1(___BOOLEAN(___NULLP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d__3c_
#undef ___PH_LBL0
#define ___PH_LBL0 482
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d__3c_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d__3c_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d__3c_)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R2(___VECTORREF(___R2,___FIX(8L)))
   ___SET_R1(___BOOLEAN(___FIXLT(___R1,___R2)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_member_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 484
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L1_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L2_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L3_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L4_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L5_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L6_c_23_varset_2d_member_3f_)
___DEF_P_HLBL(___L7_c_23_varset_2d_member_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_member_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_member_3f_)
   ___IF(___NOT(___FALSEP(___CAR(___R2))))
   ___GOTO(___L8_c_23_varset_2d_member_3f_)
   ___END_IF
   ___GOTO(___L13_c_23_varset_2d_member_3f_)
___DEF_SLBL(1,___L1_c_23_varset_2d_member_3f_)
   ___SETCAR(___STK(-5),___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L8_c_23_varset_2d_member_3f_)
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R1)
   ___SET_R1(___VECTORLENGTH(___R2))
   ___SET_R3(___FIXSUB(___R1,___FIX(1L)))
   ___SET_R1(___R2)
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_varset_2d_member_3f_)
___DEF_GLBL(___L9_c_23_varset_2d_member_3f_)
   ___IF(___NOT(___FIXLE(___R2,___R3)))
   ___GOTO(___L12_c_23_varset_2d_member_3f_)
   ___END_IF
   ___SET_R4(___FIXADD(___R2,___R3))
   ___SET_R4(___FIXQUO(___R4,___FIX(2L)))
   ___SET_STK(1,___VECTORREF(___R1,___R4))
   ___ADJFP(1)
   ___IF(___EQP(___STK(-1),___STK(0)))
   ___GOTO(___L11_c_23_varset_2d_member_3f_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___STK(0))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(4))
   ___ADJFP(10)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_varset_2d_member_3f_)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_SLBL(4,___L4_c_23_varset_2d_member_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L10_c_23_varset_2d_member_3f_)
   ___END_IF
   ___SET_R3(___STK(-6))
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_varset_2d_member_3f_)
   ___GOTO(___L9_c_23_varset_2d_member_3f_)
___DEF_GLBL(___L10_c_23_varset_2d_member_3f_)
   ___SET_R3(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_varset_2d_member_3f_)
   ___GOTO(___L9_c_23_varset_2d_member_3f_)
___DEF_GLBL(___L11_c_23_varset_2d_member_3f_)
   ___SET_R1(___TRU)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L12_c_23_varset_2d_member_3f_)
   ___SET_R1(___FAL)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L13_c_23_varset_2d_member_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CDR(___R2))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_varset_2d_member_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(114),___L_c_23_list_2d__3e_vect)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_adjoin
#undef ___PH_LBL0
#define ___PH_LBL0 493
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L1_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L2_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L3_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L4_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L5_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L6_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L7_c_23_varset_2d_adjoin)
___DEF_P_HLBL(___L8_c_23_varset_2d_adjoin)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_adjoin)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_adjoin)
   ___SET_STK(1,___R1)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(2))
   ___SET_R3(___NUL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_adjoin)
   ___GOTO(___L9_c_23_varset_2d_adjoin)
___DEF_SLBL(2,___L2_c_23_varset_2d_adjoin)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L12_c_23_varset_2d_adjoin)
   ___END_IF
   ___SET_R1(___CAR(___STK(-4)))
   ___IF(___EQP(___R1,___STK(-5)))
   ___GOTO(___L13_c_23_varset_2d_adjoin)
   ___END_IF
   ___SET_R1(___CAR(___STK(-4)))
   ___SET_R3(___CONS(___R1,___STK(-3)))
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_varset_2d_adjoin)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_varset_2d_adjoin)
___DEF_GLBL(___L9_c_23_varset_2d_adjoin)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L11_c_23_varset_2d_adjoin)
   ___END_IF
___DEF_GLBL(___L10_c_23_varset_2d_adjoin)
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R1(___R3)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_varset_2d_adjoin)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_varset_2d_adjoin)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(2),___PRC(446),___L_c_23_varset_2d_reverse_2d_append_21_)
___DEF_GLBL(___L11_c_23_varset_2d_adjoin)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___CAR(___R2))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_varset_2d_adjoin)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L12_c_23_varset_2d_adjoin)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___GOTO(___L10_c_23_varset_2d_adjoin)
___DEF_GLBL(___L13_c_23_varset_2d_adjoin)
   ___SET_R1(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_varset_2d_adjoin)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_remove
#undef ___PH_LBL0
#define ___PH_LBL0 503
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_remove)
___DEF_P_HLBL(___L1_c_23_varset_2d_remove)
___DEF_P_HLBL(___L2_c_23_varset_2d_remove)
___DEF_P_HLBL(___L3_c_23_varset_2d_remove)
___DEF_P_HLBL(___L4_c_23_varset_2d_remove)
___DEF_P_HLBL(___L5_c_23_varset_2d_remove)
___DEF_P_HLBL(___L6_c_23_varset_2d_remove)
___DEF_P_HLBL(___L7_c_23_varset_2d_remove)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_remove)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_remove)
   ___SET_STK(1,___R1)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(2))
   ___SET_R3(___NUL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_remove)
   ___GOTO(___L8_c_23_varset_2d_remove)
___DEF_SLBL(2,___L2_c_23_varset_2d_remove)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L11_c_23_varset_2d_remove)
   ___END_IF
   ___SET_R1(___CAR(___STK(-4)))
   ___IF(___EQP(___R1,___STK(-5)))
   ___GOTO(___L12_c_23_varset_2d_remove)
   ___END_IF
   ___SET_R1(___CAR(___STK(-4)))
   ___SET_R3(___CONS(___R1,___STK(-3)))
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_varset_2d_remove)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_varset_2d_remove)
___DEF_GLBL(___L8_c_23_varset_2d_remove)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L10_c_23_varset_2d_remove)
   ___END_IF
___DEF_GLBL(___L9_c_23_varset_2d_remove)
   ___SET_R1(___STK(0))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_varset_2d_remove)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L10_c_23_varset_2d_remove)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___CAR(___R2))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_varset_2d_remove)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L11_c_23_varset_2d_remove)
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___GOTO(___L9_c_23_varset_2d_remove)
___DEF_GLBL(___L12_c_23_varset_2d_remove)
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-3))
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_varset_2d_remove)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(446),___L_c_23_varset_2d_reverse_2d_append_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_equal_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 512
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_equal_3f_)
___DEF_P_HLBL(___L1_c_23_varset_2d_equal_3f_)
___DEF_P_HLBL(___L2_c_23_varset_2d_equal_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_equal_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_equal_3f_)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(1,___R1)
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_equal_3f_)
   ___GOTO(___L4_c_23_varset_2d_equal_3f_)
___DEF_GLBL(___L3_c_23_varset_2d_equal_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L5_c_23_varset_2d_equal_3f_)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R1))
   ___IF(___NOT(___EQP(___R4,___R3)))
   ___GOTO(___L5_c_23_varset_2d_equal_3f_)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_varset_2d_equal_3f_)
___DEF_GLBL(___L4_c_23_varset_2d_equal_3f_)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L3_c_23_varset_2d_equal_3f_)
   ___END_IF
   ___SET_R1(___BOOLEAN(___NULLP(___R2)))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5_c_23_varset_2d_equal_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_difference
#undef ___PH_LBL0
#define ___PH_LBL0 516
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_difference)
___DEF_P_HLBL(___L1_c_23_varset_2d_difference)
___DEF_P_HLBL(___L2_c_23_varset_2d_difference)
___DEF_P_HLBL(___L3_c_23_varset_2d_difference)
___DEF_P_HLBL(___L4_c_23_varset_2d_difference)
___DEF_P_HLBL(___L5_c_23_varset_2d_difference)
___DEF_P_HLBL(___L6_c_23_varset_2d_difference)
___DEF_P_HLBL(___L7_c_23_varset_2d_difference)
___DEF_P_HLBL(___L8_c_23_varset_2d_difference)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_difference)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_difference)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(1,___R1)
   ___SET_R2(___CDR(___R2))
   ___SET_R3(___NUL)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_difference)
   ___GOTO(___L9_c_23_varset_2d_difference)
___DEF_SLBL(2,___L2_c_23_varset_2d_difference)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L12_c_23_varset_2d_difference)
   ___END_IF
   ___IF(___EQP(___STK(-6),___STK(-11)))
   ___GOTO(___L13_c_23_varset_2d_difference)
   ___END_IF
   ___SET_R3(___STK(-7))
   ___SET_R2(___CDR(___STK(-8)))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_varset_2d_difference)
___DEF_GLBL(___L9_c_23_varset_2d_difference)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L11_c_23_varset_2d_difference)
   ___END_IF
___DEF_GLBL(___L10_c_23_varset_2d_difference)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_varset_2d_difference)
   ___JUMPINT(___SET_NARGS(2),___PRC(446),___L_c_23_varset_2d_reverse_2d_append_21_)
___DEF_GLBL(___L11_c_23_varset_2d_difference)
   ___IF(___NULLP(___R2))
   ___GOTO(___L10_c_23_varset_2d_difference)
   ___END_IF
   ___SET_R4(___CAR(___R1))
   ___SET_STK(1,___CAR(___R2))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R2(___STK(1))
   ___SET_R1(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(12)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_varset_2d_difference)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L12_c_23_varset_2d_difference)
   ___SET_R3(___CONS(___STK(-6),___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___CDR(___STK(-9)))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_varset_2d_difference)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_varset_2d_difference)
   ___GOTO(___L9_c_23_varset_2d_difference)
___DEF_GLBL(___L13_c_23_varset_2d_difference)
   ___SET_R3(___STK(-7))
   ___SET_R2(___CDR(___STK(-8)))
   ___SET_R1(___CDR(___STK(-9)))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_varset_2d_difference)
   ___GOTO(___L9_c_23_varset_2d_difference)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_union
#undef ___PH_LBL0
#define ___PH_LBL0 526
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_union)
___DEF_P_HLBL(___L1_c_23_varset_2d_union)
___DEF_P_HLBL(___L2_c_23_varset_2d_union)
___DEF_P_HLBL(___L3_c_23_varset_2d_union)
___DEF_P_HLBL(___L4_c_23_varset_2d_union)
___DEF_P_HLBL(___L5_c_23_varset_2d_union)
___DEF_P_HLBL(___L6_c_23_varset_2d_union)
___DEF_P_HLBL(___L7_c_23_varset_2d_union)
___DEF_P_HLBL(___L8_c_23_varset_2d_union)
___DEF_P_HLBL(___L9_c_23_varset_2d_union)
___DEF_P_HLBL(___L10_c_23_varset_2d_union)
___DEF_P_HLBL(___L11_c_23_varset_2d_union)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_union)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_union)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(1,___R1)
   ___SET_R2(___CDR(___R2))
   ___SET_R3(___NUL)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_union)
   ___GOTO(___L12_c_23_varset_2d_union)
___DEF_SLBL(2,___L2_c_23_varset_2d_union)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L17_c_23_varset_2d_union)
   ___END_IF
   ___SET_R3(___CONS(___STK(-6),___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___CDR(___STK(-9)))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_varset_2d_union)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_varset_2d_union)
___DEF_GLBL(___L12_c_23_varset_2d_union)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L14_c_23_varset_2d_union)
   ___END_IF
   ___SET_R1(___R3)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_varset_2d_union)
___DEF_GLBL(___L13_c_23_varset_2d_union)
   ___JUMPINT(___SET_NARGS(2),___PRC(446),___L_c_23_varset_2d_reverse_2d_append_21_)
___DEF_GLBL(___L14_c_23_varset_2d_union)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L15_c_23_varset_2d_union)
   ___END_IF
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_varset_2d_union)
   ___GOTO(___L13_c_23_varset_2d_union)
___DEF_GLBL(___L15_c_23_varset_2d_union)
   ___SET_R4(___CAR(___R1))
   ___SET_STK(1,___CAR(___R2))
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___R4,___STK(0))))
   ___GOTO(___L16_c_23_varset_2d_union)
   ___END_IF
   ___SET_R3(___CONS(___R4,___R3))
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___ADJFP(-1)
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_varset_2d_union)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_varset_2d_union)
   ___GOTO(___L12_c_23_varset_2d_union)
___DEF_GLBL(___L16_c_23_varset_2d_union)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___STK(0))
   ___SET_R1(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(11)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_varset_2d_union)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L17_c_23_varset_2d_union)
   ___SET_R3(___CONS(___STK(-11),___STK(-7)))
   ___SET_R2(___CDR(___STK(-8)))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_varset_2d_union)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_varset_2d_union)
   ___GOTO(___L12_c_23_varset_2d_union)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_intersection
#undef ___PH_LBL0
#define ___PH_LBL0 539
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L1_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L2_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L3_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L4_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L5_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L6_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L7_c_23_varset_2d_intersection)
___DEF_P_HLBL(___L8_c_23_varset_2d_intersection)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_intersection)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_intersection)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(1,___R1)
   ___SET_R2(___CDR(___R2))
   ___SET_R3(___NUL)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_intersection)
   ___GOTO(___L9_c_23_varset_2d_intersection)
___DEF_SLBL(2,___L2_c_23_varset_2d_intersection)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L13_c_23_varset_2d_intersection)
   ___END_IF
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_varset_2d_intersection)
___DEF_GLBL(___L9_c_23_varset_2d_intersection)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L11_c_23_varset_2d_intersection)
   ___END_IF
___DEF_GLBL(___L10_c_23_varset_2d_intersection)
   ___SET_R1(___R3)
   ___SET_R2(___NUL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_varset_2d_intersection)
   ___JUMPINT(___SET_NARGS(2),___PRC(446),___L_c_23_varset_2d_reverse_2d_append_21_)
___DEF_GLBL(___L11_c_23_varset_2d_intersection)
   ___IF(___NULLP(___R2))
   ___GOTO(___L10_c_23_varset_2d_intersection)
   ___END_IF
   ___SET_R4(___CAR(___R1))
   ___SET_STK(1,___CAR(___R2))
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___R4,___STK(0))))
   ___GOTO(___L12_c_23_varset_2d_intersection)
   ___END_IF
   ___SET_R3(___CONS(___R4,___R3))
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___ADJFP(-1)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_varset_2d_intersection)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_varset_2d_intersection)
   ___GOTO(___L9_c_23_varset_2d_intersection)
___DEF_GLBL(___L12_c_23_varset_2d_intersection)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___STK(0))
   ___SET_R1(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_varset_2d_intersection)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L13_c_23_varset_2d_intersection)
   ___SET_R3(___STK(-3))
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_varset_2d_intersection)
   ___GOTO(___L9_c_23_varset_2d_intersection)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_intersects_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 549
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_intersects_3f_)
___DEF_P_HLBL(___L1_c_23_varset_2d_intersects_3f_)
___DEF_P_HLBL(___L2_c_23_varset_2d_intersects_3f_)
___DEF_P_HLBL(___L3_c_23_varset_2d_intersects_3f_)
___DEF_P_HLBL(___L4_c_23_varset_2d_intersects_3f_)
___DEF_P_HLBL(___L5_c_23_varset_2d_intersects_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_intersects_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_varset_2d_intersects_3f_)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(1,___R1)
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_varset_2d_intersects_3f_)
   ___GOTO(___L6_c_23_varset_2d_intersects_3f_)
___DEF_SLBL(2,___L2_c_23_varset_2d_intersects_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L9_c_23_varset_2d_intersects_3f_)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_varset_2d_intersects_3f_)
___DEF_GLBL(___L6_c_23_varset_2d_intersects_3f_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L8_c_23_varset_2d_intersects_3f_)
   ___END_IF
   ___IF(___NULLP(___R2))
   ___GOTO(___L8_c_23_varset_2d_intersects_3f_)
   ___END_IF
   ___SET_R3(___CAR(___R1))
   ___SET_R4(___CAR(___R2))
   ___IF(___EQP(___R3,___R4))
   ___GOTO(___L7_c_23_varset_2d_intersects_3f_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R4)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_varset_2d_intersects_3f_)
   ___JUMPINT(___SET_NARGS(2),___PRC(482),___L_c_23_varset_2d__3c_)
___DEF_GLBL(___L7_c_23_varset_2d_intersects_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23_varset_2d_intersects_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L9_c_23_varset_2d_intersects_3f_)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_varset_2d_intersects_3f_)
   ___GOTO(___L6_c_23_varset_2d_intersects_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_union_2d_multi
#undef ___PH_LBL0
#define ___PH_LBL0 556
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L1_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L2_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L3_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L4_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L5_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L6_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L7_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L8_c_23_varset_2d_union_2d_multi)
___DEF_P_HLBL(___L9_c_23_varset_2d_union_2d_multi)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_varset_2d_union_2d_multi)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_varset_2d_union_2d_multi)
   ___IF(___NULLP(___R1))
   ___GOTO(___L12_c_23_varset_2d_union_2d_multi)
   ___END_IF
   ___GOTO(___L15_c_23_varset_2d_union_2d_multi)
___DEF_SLBL(1,___L1_c_23_varset_2d_union_2d_multi)
   ___SET_R2(___CONS(___R1,___STK(-5)))
   ___SET_R1(___CDDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_varset_2d_union_2d_multi)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_varset_2d_union_2d_multi)
___DEF_GLBL(___L10_c_23_varset_2d_union_2d_multi)
   ___IF(___NULLP(___R1))
   ___GOTO(___L13_c_23_varset_2d_union_2d_multi)
   ___END_IF
   ___SET_R3(___CDR(___R1))
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L14_c_23_varset_2d_union_2d_multi)
   ___END_IF
   ___SET_R1(___CAR(___R1))
   ___SET_R1(___CONS(___R1,___R2))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_varset_2d_union_2d_multi)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_varset_2d_union_2d_multi)
___DEF_GLBL(___L11_c_23_varset_2d_union_2d_multi)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L15_c_23_varset_2d_union_2d_multi)
   ___END_IF
___DEF_GLBL(___L12_c_23_varset_2d_union_2d_multi)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_varset_2d_union_2d_multi)
   ___JUMPINT(___SET_NARGS(0),___PRC(455),___L_c_23_varset_2d_empty)
___DEF_GLBL(___L13_c_23_varset_2d_union_2d_multi)
   ___SET_R1(___R2)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_varset_2d_union_2d_multi)
   ___GOTO(___L11_c_23_varset_2d_union_2d_multi)
___DEF_GLBL(___L14_c_23_varset_2d_union_2d_multi)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___CADR(___R1))
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_varset_2d_union_2d_multi)
   ___JUMPINT(___SET_NARGS(2),___PRC(526),___L_c_23_varset_2d_union)
___DEF_GLBL(___L15_c_23_varset_2d_union_2d_multi)
   ___SET_R2(___CDR(___R1))
   ___IF(___NULLP(___R2))
   ___GOTO(___L16_c_23_varset_2d_union_2d_multi)
   ___END_IF
   ___SET_R2(___NUL)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_varset_2d_union_2d_multi)
   ___GOTO(___L10_c_23_varset_2d_union_2d_multi)
___DEF_GLBL(___L16_c_23_varset_2d_union_2d_multi)
   ___SET_R1(___CAR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_n_2d_ary
#undef ___PH_LBL0
#define ___PH_LBL0 567
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_n_2d_ary)
___DEF_P_HLBL(___L1_c_23_n_2d_ary)
___DEF_P_HLBL(___L2_c_23_n_2d_ary)
___DEF_P_HLBL(___L3_c_23_n_2d_ary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_n_2d_ary)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_n_2d_ary)
   ___IF(___NULLP(___R3))
   ___GOTO(___L5_c_23_n_2d_ary)
   ___END_IF
   ___GOTO(___L4_c_23_n_2d_ary)
___DEF_SLBL(1,___L1_c_23_n_2d_ary)
   ___SET_R2(___R1)
   ___SET_R3(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_n_2d_ary)
   ___IF(___NULLP(___R3))
   ___GOTO(___L5_c_23_n_2d_ary)
   ___END_IF
___DEF_GLBL(___L4_c_23_n_2d_ary)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R1(___CAR(___R3))
   ___SET_STK(4,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(4))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_n_2d_ary)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-6))
___DEF_GLBL(___L5_c_23_n_2d_ary)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_list_2d__3e_queue
#undef ___PH_LBL0
#define ___PH_LBL0 572
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d__3e_queue)
___DEF_P_HLBL(___L1_c_23_list_2d__3e_queue)
___DEF_P_HLBL(___L2_c_23_list_2d__3e_queue)
___DEF_P_HLBL(___L3_c_23_list_2d__3e_queue)
___DEF_P_HLBL(___L4_c_23_list_2d__3e_queue)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d__3e_queue)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_list_2d__3e_queue)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L5_c_23_list_2d__3e_queue)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_list_2d__3e_queue)
   ___JUMPINT(___SET_NARGS(1),___PRC(68),___L_c_23_last_2d_pair)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_queue)
   ___SET_R0(___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___ADJFP(-7)
   ___GOTO(___L6_c_23_list_2d__3e_queue)
___DEF_GLBL(___L5_c_23_list_2d__3e_queue)
   ___SET_STK(1,___R1)
   ___SET_R1(___NUL)
   ___ADJFP(1)
___DEF_GLBL(___L6_c_23_list_2d__3e_queue)
   ___SET_R1(___CONS(___STK(0),___R1))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_list_2d__3e_queue)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_list_2d__3e_queue)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_queue_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 578
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_queue_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_queue_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_queue_2d__3e_list)
   ___SET_R1(___CAR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_queue_2d_empty
#undef ___PH_LBL0
#define ___PH_LBL0 580
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_queue_2d_empty)
___DEF_P_HLBL(___L1_c_23_queue_2d_empty)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_queue_2d_empty)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_queue_2d_empty)
   ___SET_R1(___CONS(___NUL,___NUL))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_queue_2d_empty)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_queue_2d_empty_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 583
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_queue_2d_empty_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_queue_2d_empty_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_queue_2d_empty_3f_)
   ___SET_R1(___CAR(___R1))
   ___SET_R1(___BOOLEAN(___NULLP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_queue_2d_get_21_
#undef ___PH_LBL0
#define ___PH_LBL0 585
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_queue_2d_get_21_)
___DEF_P_HLBL(___L1_c_23_queue_2d_get_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_queue_2d_get_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_queue_2d_get_21_)
   ___SET_R2(___CAR(___R1))
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L2_c_23_queue_2d_get_21_)
   ___END_IF
   ___SET_R1(___SUB(17))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_queue_2d_get_21_)
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(273),___L0_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L2_c_23_queue_2d_get_21_)
   ___SET_R2(___CAAR(___R1))
   ___SET_R3(___CDAR(___R1))
   ___SETCAR(___R1,___R3)
   ___SET_R3(___CAR(___R1))
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L3_c_23_queue_2d_get_21_)
   ___END_IF
   ___SETCDR(___R1,___NUL)
___DEF_GLBL(___L3_c_23_queue_2d_get_21_)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_queue_2d_put_21_
#undef ___PH_LBL0
#define ___PH_LBL0 588
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_queue_2d_put_21_)
___DEF_P_HLBL(___L1_c_23_queue_2d_put_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_queue_2d_put_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_queue_2d_put_21_)
   ___SET_R3(___CONS(___R2,___NUL))
   ___SET_R4(___CAR(___R1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_queue_2d_put_21_)
   ___IF(___NOT(___NULLP(___R4)))
   ___GOTO(___L2_c_23_queue_2d_put_21_)
   ___END_IF
   ___SETCAR(___R1,___R3)
   ___GOTO(___L3_c_23_queue_2d_put_21_)
___DEF_GLBL(___L2_c_23_queue_2d_put_21_)
   ___SET_R4(___CDR(___R1))
   ___SETCDR(___R4,___R3)
___DEF_GLBL(___L3_c_23_queue_2d_put_21_)
   ___SETCDR(___R1,___R3)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_throw_2d_to_2d_exception_2d_handler
#undef ___PH_LBL0
#define ___PH_LBL0 591
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_throw_2d_to_2d_exception_2d_handler)
___DEF_P_HLBL(___L1_c_23_throw_2d_to_2d_exception_2d_handler)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_throw_2d_to_2d_exception_2d_handler)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_throw_2d_to_2d_exception_2d_handler)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(18))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_throw_2d_to_2d_exception_2d_handler)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),95,___G_c_23_fatal_2d_err)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___utils," _utils",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__20___utils,0,0)
,___DEF_LBL_RET(___H__20___utils,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_append_2d_lists,"c#append-lists",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_append_2d_lists,1,0)
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,8,0,0x3f0dL))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_append_2d_lists,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_reverse_2d_append_21_,"c#reverse-append!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_reverse_2d_append_21_,2,0)
,___DEF_LBL_RET(___H_c_23_reverse_2d_append_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d_length,"c#list-length",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_list_2d_length,1,0)
,___DEF_LBL_RET(___H_c_23_list_2d_length,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d_length,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_counter,"c#make-counter",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_counter,1,0)
,___DEF_LBL_RET(___H_c_23_make_2d_counter,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_make_2d_counter,0,1)
,___DEF_LBL_INTRO(___H_c_23_for_2d_each_2d_index,"c#for-each-index",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_for_2d_each_2d_index,2,0)
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_pos_2d_in_2d_list,"c#pos-in-list",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_pos_2d_in_2d_list,2,0)
,___DEF_LBL_RET(___H_c_23_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_object_2d_pos_2d_in_2d_list,"c#object-pos-in-list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_object_2d_pos_2d_in_2d_list,2,0)
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_string_2d_pos_2d_in_2d_list,"c#string-pos-in-list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_string_2d_pos_2d_in_2d_list,2,0)
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_take,"c#take",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_take,2,0)
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_drop,"c#drop",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_drop,2,0)
,___DEF_LBL_RET(___H_c_23_drop,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_drop,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_pair_2d_up,"c#pair-up",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_pair_2d_up,2,0)
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_last_2d_pair,"c#last-pair",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_last_2d_pair,1,0)
,___DEF_LBL_RET(___H_c_23_last_2d_pair,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_last_2d_pair,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_keep,"c#keep",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_keep,2,0)
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_every_3f_,"c#every?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_every_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_remq,"c#remq",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_remq,2,0)
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_sort_2d_list,"c#sort-list",___REF_FAL,20,0)
,___DEF_LBL_PROC(___H_c_23_sort_2d_list,2,0)
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,9,1,0x22L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_sort_2d_list,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_vect,"c#list->vect",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_vect,1,0)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_vect_2d__3e_list,"c#vect->list",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_vect_2d__3e_list,1,0)
,___DEF_LBL_RET(___H_c_23_vect_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_vect_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_vect_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_str,"c#list->str",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_str,1,0)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_str_2d__3e_list,"c#str->list",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_str_2d__3e_list,1,0)
,___DEF_LBL_RET(___H_c_23_str_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_str_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_str_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_stretchable_2d_vector,"c#make-stretchable-vector",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23_make_2d_stretchable_2d_vector,1,0)
,___DEF_LBL_RET(___H_c_23_make_2d_stretchable_2d_vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_length,"c#stretchable-vector-length",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_length,1,0)
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_ref,"c#stretchable-vector-ref",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_ref,2,0)
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_set_21_,"c#stretchable-vector-set!",___REF_FAL,4,
0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_set_21_,3,0)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_set_21_,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_set_21_,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_set_21_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_stretch_2d_vector,"c#stretch-vector",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_stretch_2d_vector,3,0)
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETN,9,0,0x3dL))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETN,9,0,0x21L))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___OFD(___RETI,12,0,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_copy,"c#stretchable-vector-copy",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_copy,1,0)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_for_2d_each,"c#stretchable-vector-for-each",___REF_FAL,
5,0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_for_2d_each,2,0)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_ordered_2d_table,"c#make-ordered-table",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_ordered_2d_table,1,0)
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_length,"c#ordered-table-length",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_length,1,0)
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_index,"c#ordered-table-index",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_index,2,0)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_index,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_lookup,"c#ordered-table-lookup",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_lookup,2,0)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_enter,"c#ordered-table-enter",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_enter,3,0)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETI,8,0,0x3f09L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d__3e_list,"c#ordered-table->list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d__3e_list,1,0)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_and,"c#bits-and",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_and,2,0)
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_or,"c#bits-or",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_or,2,0)
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_shl,"c#bits-shl",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_shl,2,0)
,___DEF_LBL_RET(___H_c_23_bits_2d_shl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_shl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_shr,"c#bits-shr",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_shr,2,0)
,___DEF_LBL_RET(___H_c_23_bits_2d_shr,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_shr,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_with_2d_exception_2d_handling,"c#with-exception-handling",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H_c_23_with_2d_exception_2d_handling,1,0)
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_PROC(___H_c_23_with_2d_exception_2d_handling,2,0)
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_error,"c#compiler-error",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_compiler_2d_error,2,0)
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_user_2d_error,"c#compiler-user-error",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_compiler_2d_user_2d_error,3,0)
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_error,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_user_2d_warning,"c#compiler-user-warning",___REF_FAL,12,0)

,___DEF_LBL_PROC(___H_c_23_compiler_2d_user_2d_warning,3,0)
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_user_2d_warning,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_internal_2d_error,"c#compiler-internal-error",___REF_FAL,13,
0)
,___DEF_LBL_PROC(___H_c_23_compiler_2d_internal_2d_error,2,0)
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_internal_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_limitation_2d_error,"c#compiler-limitation-error",___REF_FAL,
13,0)
,___DEF_LBL_PROC(___H_c_23_compiler_2d_limitation_2d_error,2,0)
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_compiler_2d_limitation_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_abort,"c#compiler-abort",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_compiler_2d_abort,0,0)
,___DEF_LBL_RET(___H_c_23_compiler_2d_abort,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_gnode,"c#make-gnode",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_gnode,2,0)
,___DEF_LBL_RET(___H_c_23_make_2d_gnode,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_gnode_2d_var,"c#gnode-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_gnode_2d_var,1,0)
,___DEF_LBL_INTRO(___H_c_23_gnode_2d_depvars,"c#gnode-depvars",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_gnode_2d_depvars,1,0)
,___DEF_LBL_INTRO(___H_c_23_transitive_2d_closure,"c#transitive-closure",___REF_FAL,27,0)
,___DEF_LBL_PROC(___H_c_23_transitive_2d_closure,1,0)
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0x1ffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___OFD(___RETI,12,3,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___OFD(___RETI,12,3,0x3f0fbL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xfbL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H_c_23_transitive_2d_closure,2,0)
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_gnode_2d_find_2d_depvars,"c#gnode-find-depvars",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_gnode_2d_find_2d_depvars,2,0)
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_gnodes_2d_remove,"c#gnodes-remove",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_gnodes_2d_remove,2,0)
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_topological_2d_sort,"c#topological-sort",___REF_FAL,18,0)
,___DEF_LBL_PROC(___H_c_23_topological_2d_sort,1,0)
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f09L))
,___DEF_LBL_RET(___H_c_23_topological_2d_sort,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_remove_2d_no_2d_depvars,"c#remove-no-depvars",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_remove_2d_no_2d_depvars,1,0)
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_remove_2d_no_2d_depvars,1,0)
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_remove_2d_cycle,"c#remove-cycle",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_remove_2d_cycle,1,0)
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETN,5,2,0x1eL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,8,2,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,8,2,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETN,5,2,0x1dL))
,___DEF_LBL_PROC(___H_c_23_remove_2d_cycle,1,1)
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_remove_2d_cycle,1,1)
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_remove_2d_cycle,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_empty,"c#ptset-empty",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_empty,0,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_empty,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d__3e_list,"c#ptset->list",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d__3e_list,1,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d__3e_list,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d__3e_list,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d__3e_list,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_size,"c#ptset-size",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_size,1,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_size,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_empty_3f_,"c#ptset-empty?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_empty_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_empty_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_member_3f_,"c#ptset-member?",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_member_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_member_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_member_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_adjoin,"c#ptset-adjoin",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_adjoin,2,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_every_3f_,"c#ptset-every?",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_every_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_PROC(___H_c_23_ptset_2d_every_3f_,1,1)
,___DEF_LBL_RET(___H_c_23_ptset_2d_every_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_remove,"c#ptset-remove",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_remove,2,0)
,___DEF_LBL_RET(___H_c_23_ptset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_reverse_2d_append_21_,"c#varset-reverse-append!",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H_c_23_varset_2d_reverse_2d_append_21_,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_reverse_2d_append_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_reverse_2d_append_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_wrap,"c#varset-wrap",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_wrap,1,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_wrap,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_unwrap,"c#varset-unwrap",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_unwrap,1,0)
,___DEF_LBL_INTRO(___H_c_23_varset_2d_empty,"c#varset-empty",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_empty,0,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_empty,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_singleton,"c#varset-singleton",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_singleton,1,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_singleton,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_varset,"c#list->varset",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_varset,1,0)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_varset,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d__3e_list,"c#varset->list",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d__3e_list,1,0)
,___DEF_LBL_INTRO(___H_c_23_varset_2d_size,"c#varset-size",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_size,1,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_size,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_empty_3f_,"c#varset-empty?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_empty_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_varset_2d__3c_,"c#varset-<",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d__3c_,2,0)
,___DEF_LBL_INTRO(___H_c_23_varset_2d_member_3f_,"c#varset-member?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_member_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_adjoin,"c#varset-adjoin",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_adjoin,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_remove,"c#varset-remove",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_remove,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_equal_3f_,"c#varset-equal?",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_equal_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_equal_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_equal_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_difference,"c#varset-difference",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_difference,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_union,"c#varset-union",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_union,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_intersection,"c#varset-intersection",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_intersection,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_intersects_3f_,"c#varset-intersects?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_intersects_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_union_2d_multi,"c#varset-union-multi",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_union_2d_multi,1,0)
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_varset_2d_union_2d_multi,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_n_2d_ary,"c#n-ary",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_n_2d_ary,3,0)
,___DEF_LBL_RET(___H_c_23_n_2d_ary,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_n_2d_ary,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_n_2d_ary,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_queue,"c#list->queue",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_queue,1,0)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_queue_2d__3e_list,"c#queue->list",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d__3e_list,1,0)
,___DEF_LBL_INTRO(___H_c_23_queue_2d_empty,"c#queue-empty",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_empty,0,0)
,___DEF_LBL_RET(___H_c_23_queue_2d_empty,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_queue_2d_empty_3f_,"c#queue-empty?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_empty_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_queue_2d_get_21_,"c#queue-get!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_get_21_,1,0)
,___DEF_LBL_RET(___H_c_23_queue_2d_get_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_queue_2d_put_21_,"c#queue-put!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_put_21_,2,0)
,___DEF_LBL_RET(___H_c_23_queue_2d_put_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_throw_2d_to_2d_exception_2d_handler,0,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_throw_2d_to_2d_exception_2d_handler,1,0)
,___DEF_LBL_RET(___H_c_23_throw_2d_to_2d_exception_2d_handler,___IFD(___RETI,0,0,0x3fL))
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f0fbL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07dL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07dL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
___END_OFD

___BEGIN_MOD1
___DEF_PRM(0,___G__20___utils,1)
___DEF_PRM(1,___G_c_23_append_2d_lists,4)
___DEF_PRM(56,___G_c_23_reverse_2d_append_21_,15)
___DEF_PRM(25,___G_c_23_list_2d_length,18)
___DEF_PRM(26,___G_c_23_make_2d_counter,22)
___DEF_PRM(14,___G_c_23_for_2d_each_2d_index,26)
___DEF_PRM(38,___G_c_23_pos_2d_in_2d_list,32)
___DEF_PRM(31,___G_c_23_object_2d_pos_2d_in_2d_list,36)
___DEF_PRM(65,___G_c_23_string_2d_pos_2d_in_2d_list,43)
___DEF_PRM(66,___G_c_23_take,50)
___DEF_PRM(12,___G_c_23_drop,57)
___DEF_PRM(37,___G_c_23_pair_2d_up,61)
___DEF_PRM(20,___G_c_23_last_2d_pair,68)
___DEF_PRM(19,___G_c_23_keep,72)
___DEF_PRM(13,___G_c_23_every_3f_,81)
___DEF_PRM(55,___G_c_23_remq,87)
___DEF_PRM(57,___G_c_23_sort_2d_list,93)
___DEF_PRM(24,___G_c_23_list_2d__3e_vect,114)
___DEF_PRM(88,___G_c_23_vect_2d__3e_list,121)
___DEF_PRM(22,___G_c_23_list_2d__3e_str,126)
___DEF_PRM(58,___G_c_23_str_2d__3e_list,133)
___DEF_PRM(29,___G_c_23_make_2d_stretchable_2d_vector,138)
___DEF_PRM(62,___G_c_23_stretchable_2d_vector_2d_length,141)
___DEF_PRM(63,___G_c_23_stretchable_2d_vector_2d_ref,143)
___DEF_PRM(64,___G_c_23_stretchable_2d_vector_2d_set_21_,145)
___DEF_PRM(59,___G_c_23_stretch_2d_vector,150)
___DEF_PRM(60,___G_c_23_stretchable_2d_vector_2d_copy,159)
___DEF_PRM(61,___G_c_23_stretchable_2d_vector_2d_for_2d_each,166)
___DEF_PRM(28,___G_c_23_make_2d_ordered_2d_table,172)
___DEF_PRM(35,___G_c_23_ordered_2d_table_2d_length,178)
___DEF_PRM(34,___G_c_23_ordered_2d_table_2d_index,180)
___DEF_PRM(36,___G_c_23_ordered_2d_table_2d_lookup,183)
___DEF_PRM(33,___G_c_23_ordered_2d_table_2d_enter,190)
___DEF_PRM(32,___G_c_23_ordered_2d_table_2d__3e_list,198)
___DEF_PRM(2,___G_c_23_bits_2d_and,205)
___DEF_PRM(3,___G_c_23_bits_2d_or,212)
___DEF_PRM(4,___G_c_23_bits_2d_shl,219)
___DEF_PRM(5,___G_c_23_bits_2d_shr,223)
___DEF_PRM(90,___G_c_23_with_2d_exception_2d_handling,227)
___DEF_PRM(7,___G_c_23_compiler_2d_error,234)
___DEF_PRM(10,___G_c_23_compiler_2d_user_2d_error,246)
___DEF_PRM(11,___G_c_23_compiler_2d_user_2d_warning,260)
___DEF_PRM(8,___G_c_23_compiler_2d_internal_2d_error,273)
___DEF_PRM(9,___G_c_23_compiler_2d_limitation_2d_error,287)
___DEF_PRM(6,___G_c_23_compiler_2d_abort,301)
___DEF_PRM(27,___G_c_23_make_2d_gnode,304)
___DEF_PRM(17,___G_c_23_gnode_2d_var,307)
___DEF_PRM(15,___G_c_23_gnode_2d_depvars,309)
___DEF_PRM(69,___G_c_23_transitive_2d_closure,311)
___DEF_PRM(16,___G_c_23_gnode_2d_find_2d_depvars,339)
___DEF_PRM(18,___G_c_23_gnodes_2d_remove,347)
___DEF_PRM(68,___G_c_23_topological_2d_sort,356)
___DEF_PRM(54,___G_c_23_remove_2d_no_2d_depvars,375)
___DEF_PRM(53,___G_c_23_remove_2d_cycle,383)
___DEF_PRM(41,___G_c_23_ptset_2d_empty,397)
___DEF_PRM(39,___G_c_23_ptset_2d__3e_list,400)
___DEF_PRM(47,___G_c_23_ptset_2d_size,405)
___DEF_PRM(43,___G_c_23_ptset_2d_empty_3f_,416)
___DEF_PRM(45,___G_c_23_ptset_2d_member_3f_,419)
___DEF_PRM(40,___G_c_23_ptset_2d_adjoin,423)
___DEF_PRM(44,___G_c_23_ptset_2d_every_3f_,430)
___DEF_PRM(46,___G_c_23_ptset_2d_remove,442)
___DEF_PRM(81,___G_c_23_varset_2d_reverse_2d_append_21_,446)
___DEF_PRM(87,___G_c_23_varset_2d_wrap,450)
___DEF_PRM(86,___G_c_23_varset_2d_unwrap,453)
___DEF_PRM(74,___G_c_23_varset_2d_empty,455)
___DEF_PRM(82,___G_c_23_varset_2d_singleton,458)
___DEF_PRM(23,___G_c_23_list_2d__3e_varset,461)
___DEF_PRM(71,___G_c_23_varset_2d__3e_list,475)
___DEF_PRM(83,___G_c_23_varset_2d_size,477)
___DEF_PRM(75,___G_c_23_varset_2d_empty_3f_,480)
___DEF_PRM(70,___G_c_23_varset_2d__3c_,482)
___DEF_PRM(79,___G_c_23_varset_2d_member_3f_,484)
___DEF_PRM(72,___G_c_23_varset_2d_adjoin,493)
___DEF_PRM(80,___G_c_23_varset_2d_remove,503)
___DEF_PRM(76,___G_c_23_varset_2d_equal_3f_,512)
___DEF_PRM(73,___G_c_23_varset_2d_difference,516)
___DEF_PRM(84,___G_c_23_varset_2d_union,526)
___DEF_PRM(77,___G_c_23_varset_2d_intersection,539)
___DEF_PRM(78,___G_c_23_varset_2d_intersects_3f_,549)
___DEF_PRM(85,___G_c_23_varset_2d_union_2d_multi,556)
___DEF_PRM(30,___G_c_23_n_2d_ary,567)
___DEF_PRM(21,___G_c_23_list_2d__3e_queue,572)
___DEF_PRM(48,___G_c_23_queue_2d__3e_list,578)
___DEF_PRM(49,___G_c_23_queue_2d_empty,580)
___DEF_PRM(50,___G_c_23_queue_2d_empty_3f_,583)
___DEF_PRM(51,___G_c_23_queue_2d_get_21_,585)
___DEF_PRM(52,___G_c_23_queue_2d_put_21_,588)
___END_MOD1

___BEGIN_MOD2
___DEF_KEY2(0,___K_test,"test")
___END_MOD2

#endif
