#ifdef ___LINKER_INFO
; File: "_utils.c", produced by Gambit v4.8.8
(
408008
(C)
"_utils"
(("_utils"))
(
"_utils"
)
(
"test"
)
(
" _utils"
"c#append-lists"
"c#compiler-abort"
"c#compiler-internal-error"
"c#every?"
"c#gnode-depvars"
"c#gnode-find-depvars"
"c#gnode-var"
"c#gnodes-remove"
"c#keep"
"c#last-pair"
"c#list->str"
"c#list->varset"
"c#list->vect"
"c#list-length"
"c#make-stretchable-vector"
"c#ptset-adjoin"
"c#ptset-empty"
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
"c#varset-difference"
"c#varset-empty"
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
"c#list->ptset"
"c#list->queue"
"c#make-counter"
"c#make-gnode"
"c#make-ordered-table"
"c#map-index"
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
"c#read-line*"
"c#remq"
"c#str->list"
"c#stretchable-vector->list"
"c#stretchable-vector-copy"
"c#stretchable-vector-for-each"
"c#stretchable-vector-length"
"c#string-pos-in-list"
"c#take"
"c#topological-sort"
"c#transitive-closure"
"c#varset->list"
"c#varset-adjoin"
"c#varset-empty?"
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
"apply"
"c#fatal-err"
"c#locat-show"
"display"
"equal?"
"make-string"
"make-table"
"make-vector"
"newline"
"read-char"
"reverse"
"string=?"
"table-ref"
"table-set!"
"write"
)
 ()
)
#else
#define ___VERSION 408008
#define ___MODULE_NAME "_utils"
#define ___LINKER_ID ____20___utils
#define ___MH_PROC ___H__20___utils
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 1
#define ___KEYCOUNT 1
#define ___GLOCOUNT 112
#define ___SUPCOUNT 95
#define ___SUBCOUNT 20
#define ___LBLCOUNT 630
#define ___OFDCOUNT 10
#define ___MODDESCR ___REF_SUB(19)
#include "gambit.h"

___NEED_SYM(___S___utils)

___NEED_KEY(___K_test)

___NEED_GLO(___G__20___utils)
___NEED_GLO(___G__23__23_call_2d_with_2d_current_2d_continuation)
___NEED_GLO(___G__2b_)
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
___NEED_GLO(___G_c_23_list_2d__3e_ptset)
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
___NEED_GLO(___G_c_23_map_2d_index)
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
___NEED_GLO(___G_c_23_read_2d_line_2a_)
___NEED_GLO(___G_c_23_remove_2d_cycle)
___NEED_GLO(___G_c_23_remove_2d_no_2d_depvars)
___NEED_GLO(___G_c_23_remq)
___NEED_GLO(___G_c_23_reverse_2d_append_21_)
___NEED_GLO(___G_c_23_sort_2d_list)
___NEED_GLO(___G_c_23_str_2d__3e_list)
___NEED_GLO(___G_c_23_stretch_2d_vector)
___NEED_GLO(___G_c_23_stretchable_2d_vector_2d__3e_list)
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
___NEED_GLO(___G_read_2d_char)
___NEED_GLO(___G_reverse)
___NEED_GLO(___G_string_3d__3f_)
___NEED_GLO(___G_table_2d_ref)
___NEED_GLO(___G_table_2d_set_21_)
___NEED_GLO(___G_write)

___BEGIN_SYM
___DEF_SYM(0,___S___utils,"_utils")
___END_SYM

#define ___SYM___utils ___SYM(0,___S___utils)

___BEGIN_KEY
___DEF_KEY(0,___K_test,"test")
___END_KEY

#define ___KEY_test ___KEY(0,___K_test)

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
___DEF_GLO(21,"c#list->ptset")
___DEF_GLO(22,"c#list->queue")
___DEF_GLO(23,"c#list->str")
___DEF_GLO(24,"c#list->varset")
___DEF_GLO(25,"c#list->vect")
___DEF_GLO(26,"c#list-length")
___DEF_GLO(27,"c#make-counter")
___DEF_GLO(28,"c#make-gnode")
___DEF_GLO(29,"c#make-ordered-table")
___DEF_GLO(30,"c#make-stretchable-vector")
___DEF_GLO(31,"c#map-index")
___DEF_GLO(32,"c#n-ary")
___DEF_GLO(33,"c#object-pos-in-list")
___DEF_GLO(34,"c#ordered-table->list")
___DEF_GLO(35,"c#ordered-table-enter")
___DEF_GLO(36,"c#ordered-table-index")
___DEF_GLO(37,"c#ordered-table-length")
___DEF_GLO(38,"c#ordered-table-lookup")
___DEF_GLO(39,"c#pair-up")
___DEF_GLO(40,"c#pos-in-list")
___DEF_GLO(41,"c#ptset->list")
___DEF_GLO(42,"c#ptset-adjoin")
___DEF_GLO(43,"c#ptset-empty")
___DEF_GLO(44,"c#ptset-empty-set")
___DEF_GLO(45,"c#ptset-empty?")
___DEF_GLO(46,"c#ptset-every?")
___DEF_GLO(47,"c#ptset-member?")
___DEF_GLO(48,"c#ptset-remove")
___DEF_GLO(49,"c#ptset-size")
___DEF_GLO(50,"c#queue->list")
___DEF_GLO(51,"c#queue-empty")
___DEF_GLO(52,"c#queue-empty?")
___DEF_GLO(53,"c#queue-get!")
___DEF_GLO(54,"c#queue-put!")
___DEF_GLO(55,"c#read-line*")
___DEF_GLO(56,"c#remove-cycle")
___DEF_GLO(57,"c#remove-no-depvars")
___DEF_GLO(58,"c#remq")
___DEF_GLO(59,"c#reverse-append!")
___DEF_GLO(60,"c#sort-list")
___DEF_GLO(61,"c#str->list")
___DEF_GLO(62,"c#stretch-vector")
___DEF_GLO(63,"c#stretchable-vector->list")
___DEF_GLO(64,"c#stretchable-vector-copy")
___DEF_GLO(65,"c#stretchable-vector-for-each")
___DEF_GLO(66,"c#stretchable-vector-length")
___DEF_GLO(67,"c#stretchable-vector-ref")
___DEF_GLO(68,"c#stretchable-vector-set!")
___DEF_GLO(69,"c#string-pos-in-list")
___DEF_GLO(70,"c#take")
___DEF_GLO(71,"c#throw-to-exception-handler")
___DEF_GLO(72,"c#topological-sort")
___DEF_GLO(73,"c#transitive-closure")
___DEF_GLO(74,"c#varset-<")
___DEF_GLO(75,"c#varset->list")
___DEF_GLO(76,"c#varset-adjoin")
___DEF_GLO(77,"c#varset-difference")
___DEF_GLO(78,"c#varset-empty")
___DEF_GLO(79,"c#varset-empty?")
___DEF_GLO(80,"c#varset-equal?")
___DEF_GLO(81,"c#varset-intersection")
___DEF_GLO(82,"c#varset-intersects?")
___DEF_GLO(83,"c#varset-member?")
___DEF_GLO(84,"c#varset-remove")
___DEF_GLO(85,"c#varset-reverse-append!")
___DEF_GLO(86,"c#varset-singleton")
___DEF_GLO(87,"c#varset-size")
___DEF_GLO(88,"c#varset-union")
___DEF_GLO(89,"c#varset-union-multi")
___DEF_GLO(90,"c#varset-unwrap")
___DEF_GLO(91,"c#varset-wrap")
___DEF_GLO(92,"c#vect->list")
___DEF_GLO(93,"c#warnings-requested?")
___DEF_GLO(94,"c#with-exception-handling")
___DEF_GLO(95,"##call-with-current-continuation")
___DEF_GLO(96,"+")
___DEF_GLO(97,"apply")
___DEF_GLO(98,"c#fatal-err")
___DEF_GLO(99,"c#locat-show")
___DEF_GLO(100,"display")
___DEF_GLO(101,"equal?")
___DEF_GLO(102,"make-string")
___DEF_GLO(103,"make-table")
___DEF_GLO(104,"make-vector")
___DEF_GLO(105,"newline")
___DEF_GLO(106,"read-char")
___DEF_GLO(107,"reverse")
___DEF_GLO(108,"string=?")
___DEF_GLO(109,"table-ref")
___DEF_GLO(110,"table-set!")
___DEF_GLO(111,"write")
___END_GLO

#define ___GLO__20___utils ___GLO(0,___G__20___utils)
#define ___PRM__20___utils ___PRM(0,___G__20___utils)
#define ___GLO_c_23_append_2d_lists ___GLO(1,___G_c_23_append_2d_lists)
#define ___PRM_c_23_append_2d_lists ___PRM(1,___G_c_23_append_2d_lists)
#define ___GLO_c_23_bits_2d_and ___GLO(2,___G_c_23_bits_2d_and)
#define ___PRM_c_23_bits_2d_and ___PRM(2,___G_c_23_bits_2d_and)
#define ___GLO_c_23_bits_2d_or ___GLO(3,___G_c_23_bits_2d_or)
#define ___PRM_c_23_bits_2d_or ___PRM(3,___G_c_23_bits_2d_or)
#define ___GLO_c_23_bits_2d_shl ___GLO(4,___G_c_23_bits_2d_shl)
#define ___PRM_c_23_bits_2d_shl ___PRM(4,___G_c_23_bits_2d_shl)
#define ___GLO_c_23_bits_2d_shr ___GLO(5,___G_c_23_bits_2d_shr)
#define ___PRM_c_23_bits_2d_shr ___PRM(5,___G_c_23_bits_2d_shr)
#define ___GLO_c_23_compiler_2d_abort ___GLO(6,___G_c_23_compiler_2d_abort)
#define ___PRM_c_23_compiler_2d_abort ___PRM(6,___G_c_23_compiler_2d_abort)
#define ___GLO_c_23_compiler_2d_error ___GLO(7,___G_c_23_compiler_2d_error)
#define ___PRM_c_23_compiler_2d_error ___PRM(7,___G_c_23_compiler_2d_error)
#define ___GLO_c_23_compiler_2d_internal_2d_error ___GLO(8,___G_c_23_compiler_2d_internal_2d_error)
#define ___PRM_c_23_compiler_2d_internal_2d_error ___PRM(8,___G_c_23_compiler_2d_internal_2d_error)
#define ___GLO_c_23_compiler_2d_limitation_2d_error ___GLO(9,___G_c_23_compiler_2d_limitation_2d_error)
#define ___PRM_c_23_compiler_2d_limitation_2d_error ___PRM(9,___G_c_23_compiler_2d_limitation_2d_error)
#define ___GLO_c_23_compiler_2d_user_2d_error ___GLO(10,___G_c_23_compiler_2d_user_2d_error)
#define ___PRM_c_23_compiler_2d_user_2d_error ___PRM(10,___G_c_23_compiler_2d_user_2d_error)
#define ___GLO_c_23_compiler_2d_user_2d_warning ___GLO(11,___G_c_23_compiler_2d_user_2d_warning)
#define ___PRM_c_23_compiler_2d_user_2d_warning ___PRM(11,___G_c_23_compiler_2d_user_2d_warning)
#define ___GLO_c_23_drop ___GLO(12,___G_c_23_drop)
#define ___PRM_c_23_drop ___PRM(12,___G_c_23_drop)
#define ___GLO_c_23_every_3f_ ___GLO(13,___G_c_23_every_3f_)
#define ___PRM_c_23_every_3f_ ___PRM(13,___G_c_23_every_3f_)
#define ___GLO_c_23_for_2d_each_2d_index ___GLO(14,___G_c_23_for_2d_each_2d_index)
#define ___PRM_c_23_for_2d_each_2d_index ___PRM(14,___G_c_23_for_2d_each_2d_index)
#define ___GLO_c_23_gnode_2d_depvars ___GLO(15,___G_c_23_gnode_2d_depvars)
#define ___PRM_c_23_gnode_2d_depvars ___PRM(15,___G_c_23_gnode_2d_depvars)
#define ___GLO_c_23_gnode_2d_find_2d_depvars ___GLO(16,___G_c_23_gnode_2d_find_2d_depvars)
#define ___PRM_c_23_gnode_2d_find_2d_depvars ___PRM(16,___G_c_23_gnode_2d_find_2d_depvars)
#define ___GLO_c_23_gnode_2d_var ___GLO(17,___G_c_23_gnode_2d_var)
#define ___PRM_c_23_gnode_2d_var ___PRM(17,___G_c_23_gnode_2d_var)
#define ___GLO_c_23_gnodes_2d_remove ___GLO(18,___G_c_23_gnodes_2d_remove)
#define ___PRM_c_23_gnodes_2d_remove ___PRM(18,___G_c_23_gnodes_2d_remove)
#define ___GLO_c_23_keep ___GLO(19,___G_c_23_keep)
#define ___PRM_c_23_keep ___PRM(19,___G_c_23_keep)
#define ___GLO_c_23_last_2d_pair ___GLO(20,___G_c_23_last_2d_pair)
#define ___PRM_c_23_last_2d_pair ___PRM(20,___G_c_23_last_2d_pair)
#define ___GLO_c_23_list_2d__3e_ptset ___GLO(21,___G_c_23_list_2d__3e_ptset)
#define ___PRM_c_23_list_2d__3e_ptset ___PRM(21,___G_c_23_list_2d__3e_ptset)
#define ___GLO_c_23_list_2d__3e_queue ___GLO(22,___G_c_23_list_2d__3e_queue)
#define ___PRM_c_23_list_2d__3e_queue ___PRM(22,___G_c_23_list_2d__3e_queue)
#define ___GLO_c_23_list_2d__3e_str ___GLO(23,___G_c_23_list_2d__3e_str)
#define ___PRM_c_23_list_2d__3e_str ___PRM(23,___G_c_23_list_2d__3e_str)
#define ___GLO_c_23_list_2d__3e_varset ___GLO(24,___G_c_23_list_2d__3e_varset)
#define ___PRM_c_23_list_2d__3e_varset ___PRM(24,___G_c_23_list_2d__3e_varset)
#define ___GLO_c_23_list_2d__3e_vect ___GLO(25,___G_c_23_list_2d__3e_vect)
#define ___PRM_c_23_list_2d__3e_vect ___PRM(25,___G_c_23_list_2d__3e_vect)
#define ___GLO_c_23_list_2d_length ___GLO(26,___G_c_23_list_2d_length)
#define ___PRM_c_23_list_2d_length ___PRM(26,___G_c_23_list_2d_length)
#define ___GLO_c_23_make_2d_counter ___GLO(27,___G_c_23_make_2d_counter)
#define ___PRM_c_23_make_2d_counter ___PRM(27,___G_c_23_make_2d_counter)
#define ___GLO_c_23_make_2d_gnode ___GLO(28,___G_c_23_make_2d_gnode)
#define ___PRM_c_23_make_2d_gnode ___PRM(28,___G_c_23_make_2d_gnode)
#define ___GLO_c_23_make_2d_ordered_2d_table ___GLO(29,___G_c_23_make_2d_ordered_2d_table)
#define ___PRM_c_23_make_2d_ordered_2d_table ___PRM(29,___G_c_23_make_2d_ordered_2d_table)
#define ___GLO_c_23_make_2d_stretchable_2d_vector ___GLO(30,___G_c_23_make_2d_stretchable_2d_vector)
#define ___PRM_c_23_make_2d_stretchable_2d_vector ___PRM(30,___G_c_23_make_2d_stretchable_2d_vector)
#define ___GLO_c_23_map_2d_index ___GLO(31,___G_c_23_map_2d_index)
#define ___PRM_c_23_map_2d_index ___PRM(31,___G_c_23_map_2d_index)
#define ___GLO_c_23_n_2d_ary ___GLO(32,___G_c_23_n_2d_ary)
#define ___PRM_c_23_n_2d_ary ___PRM(32,___G_c_23_n_2d_ary)
#define ___GLO_c_23_object_2d_pos_2d_in_2d_list ___GLO(33,___G_c_23_object_2d_pos_2d_in_2d_list)
#define ___PRM_c_23_object_2d_pos_2d_in_2d_list ___PRM(33,___G_c_23_object_2d_pos_2d_in_2d_list)
#define ___GLO_c_23_ordered_2d_table_2d__3e_list ___GLO(34,___G_c_23_ordered_2d_table_2d__3e_list)
#define ___PRM_c_23_ordered_2d_table_2d__3e_list ___PRM(34,___G_c_23_ordered_2d_table_2d__3e_list)
#define ___GLO_c_23_ordered_2d_table_2d_enter ___GLO(35,___G_c_23_ordered_2d_table_2d_enter)
#define ___PRM_c_23_ordered_2d_table_2d_enter ___PRM(35,___G_c_23_ordered_2d_table_2d_enter)
#define ___GLO_c_23_ordered_2d_table_2d_index ___GLO(36,___G_c_23_ordered_2d_table_2d_index)
#define ___PRM_c_23_ordered_2d_table_2d_index ___PRM(36,___G_c_23_ordered_2d_table_2d_index)
#define ___GLO_c_23_ordered_2d_table_2d_length ___GLO(37,___G_c_23_ordered_2d_table_2d_length)
#define ___PRM_c_23_ordered_2d_table_2d_length ___PRM(37,___G_c_23_ordered_2d_table_2d_length)
#define ___GLO_c_23_ordered_2d_table_2d_lookup ___GLO(38,___G_c_23_ordered_2d_table_2d_lookup)
#define ___PRM_c_23_ordered_2d_table_2d_lookup ___PRM(38,___G_c_23_ordered_2d_table_2d_lookup)
#define ___GLO_c_23_pair_2d_up ___GLO(39,___G_c_23_pair_2d_up)
#define ___PRM_c_23_pair_2d_up ___PRM(39,___G_c_23_pair_2d_up)
#define ___GLO_c_23_pos_2d_in_2d_list ___GLO(40,___G_c_23_pos_2d_in_2d_list)
#define ___PRM_c_23_pos_2d_in_2d_list ___PRM(40,___G_c_23_pos_2d_in_2d_list)
#define ___GLO_c_23_ptset_2d__3e_list ___GLO(41,___G_c_23_ptset_2d__3e_list)
#define ___PRM_c_23_ptset_2d__3e_list ___PRM(41,___G_c_23_ptset_2d__3e_list)
#define ___GLO_c_23_ptset_2d_adjoin ___GLO(42,___G_c_23_ptset_2d_adjoin)
#define ___PRM_c_23_ptset_2d_adjoin ___PRM(42,___G_c_23_ptset_2d_adjoin)
#define ___GLO_c_23_ptset_2d_empty ___GLO(43,___G_c_23_ptset_2d_empty)
#define ___PRM_c_23_ptset_2d_empty ___PRM(43,___G_c_23_ptset_2d_empty)
#define ___GLO_c_23_ptset_2d_empty_2d_set ___GLO(44,___G_c_23_ptset_2d_empty_2d_set)
#define ___PRM_c_23_ptset_2d_empty_2d_set ___PRM(44,___G_c_23_ptset_2d_empty_2d_set)
#define ___GLO_c_23_ptset_2d_empty_3f_ ___GLO(45,___G_c_23_ptset_2d_empty_3f_)
#define ___PRM_c_23_ptset_2d_empty_3f_ ___PRM(45,___G_c_23_ptset_2d_empty_3f_)
#define ___GLO_c_23_ptset_2d_every_3f_ ___GLO(46,___G_c_23_ptset_2d_every_3f_)
#define ___PRM_c_23_ptset_2d_every_3f_ ___PRM(46,___G_c_23_ptset_2d_every_3f_)
#define ___GLO_c_23_ptset_2d_member_3f_ ___GLO(47,___G_c_23_ptset_2d_member_3f_)
#define ___PRM_c_23_ptset_2d_member_3f_ ___PRM(47,___G_c_23_ptset_2d_member_3f_)
#define ___GLO_c_23_ptset_2d_remove ___GLO(48,___G_c_23_ptset_2d_remove)
#define ___PRM_c_23_ptset_2d_remove ___PRM(48,___G_c_23_ptset_2d_remove)
#define ___GLO_c_23_ptset_2d_size ___GLO(49,___G_c_23_ptset_2d_size)
#define ___PRM_c_23_ptset_2d_size ___PRM(49,___G_c_23_ptset_2d_size)
#define ___GLO_c_23_queue_2d__3e_list ___GLO(50,___G_c_23_queue_2d__3e_list)
#define ___PRM_c_23_queue_2d__3e_list ___PRM(50,___G_c_23_queue_2d__3e_list)
#define ___GLO_c_23_queue_2d_empty ___GLO(51,___G_c_23_queue_2d_empty)
#define ___PRM_c_23_queue_2d_empty ___PRM(51,___G_c_23_queue_2d_empty)
#define ___GLO_c_23_queue_2d_empty_3f_ ___GLO(52,___G_c_23_queue_2d_empty_3f_)
#define ___PRM_c_23_queue_2d_empty_3f_ ___PRM(52,___G_c_23_queue_2d_empty_3f_)
#define ___GLO_c_23_queue_2d_get_21_ ___GLO(53,___G_c_23_queue_2d_get_21_)
#define ___PRM_c_23_queue_2d_get_21_ ___PRM(53,___G_c_23_queue_2d_get_21_)
#define ___GLO_c_23_queue_2d_put_21_ ___GLO(54,___G_c_23_queue_2d_put_21_)
#define ___PRM_c_23_queue_2d_put_21_ ___PRM(54,___G_c_23_queue_2d_put_21_)
#define ___GLO_c_23_read_2d_line_2a_ ___GLO(55,___G_c_23_read_2d_line_2a_)
#define ___PRM_c_23_read_2d_line_2a_ ___PRM(55,___G_c_23_read_2d_line_2a_)
#define ___GLO_c_23_remove_2d_cycle ___GLO(56,___G_c_23_remove_2d_cycle)
#define ___PRM_c_23_remove_2d_cycle ___PRM(56,___G_c_23_remove_2d_cycle)
#define ___GLO_c_23_remove_2d_no_2d_depvars ___GLO(57,___G_c_23_remove_2d_no_2d_depvars)
#define ___PRM_c_23_remove_2d_no_2d_depvars ___PRM(57,___G_c_23_remove_2d_no_2d_depvars)
#define ___GLO_c_23_remq ___GLO(58,___G_c_23_remq)
#define ___PRM_c_23_remq ___PRM(58,___G_c_23_remq)
#define ___GLO_c_23_reverse_2d_append_21_ ___GLO(59,___G_c_23_reverse_2d_append_21_)
#define ___PRM_c_23_reverse_2d_append_21_ ___PRM(59,___G_c_23_reverse_2d_append_21_)
#define ___GLO_c_23_sort_2d_list ___GLO(60,___G_c_23_sort_2d_list)
#define ___PRM_c_23_sort_2d_list ___PRM(60,___G_c_23_sort_2d_list)
#define ___GLO_c_23_str_2d__3e_list ___GLO(61,___G_c_23_str_2d__3e_list)
#define ___PRM_c_23_str_2d__3e_list ___PRM(61,___G_c_23_str_2d__3e_list)
#define ___GLO_c_23_stretch_2d_vector ___GLO(62,___G_c_23_stretch_2d_vector)
#define ___PRM_c_23_stretch_2d_vector ___PRM(62,___G_c_23_stretch_2d_vector)
#define ___GLO_c_23_stretchable_2d_vector_2d__3e_list ___GLO(63,___G_c_23_stretchable_2d_vector_2d__3e_list)
#define ___PRM_c_23_stretchable_2d_vector_2d__3e_list ___PRM(63,___G_c_23_stretchable_2d_vector_2d__3e_list)
#define ___GLO_c_23_stretchable_2d_vector_2d_copy ___GLO(64,___G_c_23_stretchable_2d_vector_2d_copy)
#define ___PRM_c_23_stretchable_2d_vector_2d_copy ___PRM(64,___G_c_23_stretchable_2d_vector_2d_copy)
#define ___GLO_c_23_stretchable_2d_vector_2d_for_2d_each ___GLO(65,___G_c_23_stretchable_2d_vector_2d_for_2d_each)
#define ___PRM_c_23_stretchable_2d_vector_2d_for_2d_each ___PRM(65,___G_c_23_stretchable_2d_vector_2d_for_2d_each)
#define ___GLO_c_23_stretchable_2d_vector_2d_length ___GLO(66,___G_c_23_stretchable_2d_vector_2d_length)
#define ___PRM_c_23_stretchable_2d_vector_2d_length ___PRM(66,___G_c_23_stretchable_2d_vector_2d_length)
#define ___GLO_c_23_stretchable_2d_vector_2d_ref ___GLO(67,___G_c_23_stretchable_2d_vector_2d_ref)
#define ___PRM_c_23_stretchable_2d_vector_2d_ref ___PRM(67,___G_c_23_stretchable_2d_vector_2d_ref)
#define ___GLO_c_23_stretchable_2d_vector_2d_set_21_ ___GLO(68,___G_c_23_stretchable_2d_vector_2d_set_21_)
#define ___PRM_c_23_stretchable_2d_vector_2d_set_21_ ___PRM(68,___G_c_23_stretchable_2d_vector_2d_set_21_)
#define ___GLO_c_23_string_2d_pos_2d_in_2d_list ___GLO(69,___G_c_23_string_2d_pos_2d_in_2d_list)
#define ___PRM_c_23_string_2d_pos_2d_in_2d_list ___PRM(69,___G_c_23_string_2d_pos_2d_in_2d_list)
#define ___GLO_c_23_take ___GLO(70,___G_c_23_take)
#define ___PRM_c_23_take ___PRM(70,___G_c_23_take)
#define ___GLO_c_23_throw_2d_to_2d_exception_2d_handler ___GLO(71,___G_c_23_throw_2d_to_2d_exception_2d_handler)
#define ___PRM_c_23_throw_2d_to_2d_exception_2d_handler ___PRM(71,___G_c_23_throw_2d_to_2d_exception_2d_handler)
#define ___GLO_c_23_topological_2d_sort ___GLO(72,___G_c_23_topological_2d_sort)
#define ___PRM_c_23_topological_2d_sort ___PRM(72,___G_c_23_topological_2d_sort)
#define ___GLO_c_23_transitive_2d_closure ___GLO(73,___G_c_23_transitive_2d_closure)
#define ___PRM_c_23_transitive_2d_closure ___PRM(73,___G_c_23_transitive_2d_closure)
#define ___GLO_c_23_varset_2d__3c_ ___GLO(74,___G_c_23_varset_2d__3c_)
#define ___PRM_c_23_varset_2d__3c_ ___PRM(74,___G_c_23_varset_2d__3c_)
#define ___GLO_c_23_varset_2d__3e_list ___GLO(75,___G_c_23_varset_2d__3e_list)
#define ___PRM_c_23_varset_2d__3e_list ___PRM(75,___G_c_23_varset_2d__3e_list)
#define ___GLO_c_23_varset_2d_adjoin ___GLO(76,___G_c_23_varset_2d_adjoin)
#define ___PRM_c_23_varset_2d_adjoin ___PRM(76,___G_c_23_varset_2d_adjoin)
#define ___GLO_c_23_varset_2d_difference ___GLO(77,___G_c_23_varset_2d_difference)
#define ___PRM_c_23_varset_2d_difference ___PRM(77,___G_c_23_varset_2d_difference)
#define ___GLO_c_23_varset_2d_empty ___GLO(78,___G_c_23_varset_2d_empty)
#define ___PRM_c_23_varset_2d_empty ___PRM(78,___G_c_23_varset_2d_empty)
#define ___GLO_c_23_varset_2d_empty_3f_ ___GLO(79,___G_c_23_varset_2d_empty_3f_)
#define ___PRM_c_23_varset_2d_empty_3f_ ___PRM(79,___G_c_23_varset_2d_empty_3f_)
#define ___GLO_c_23_varset_2d_equal_3f_ ___GLO(80,___G_c_23_varset_2d_equal_3f_)
#define ___PRM_c_23_varset_2d_equal_3f_ ___PRM(80,___G_c_23_varset_2d_equal_3f_)
#define ___GLO_c_23_varset_2d_intersection ___GLO(81,___G_c_23_varset_2d_intersection)
#define ___PRM_c_23_varset_2d_intersection ___PRM(81,___G_c_23_varset_2d_intersection)
#define ___GLO_c_23_varset_2d_intersects_3f_ ___GLO(82,___G_c_23_varset_2d_intersects_3f_)
#define ___PRM_c_23_varset_2d_intersects_3f_ ___PRM(82,___G_c_23_varset_2d_intersects_3f_)
#define ___GLO_c_23_varset_2d_member_3f_ ___GLO(83,___G_c_23_varset_2d_member_3f_)
#define ___PRM_c_23_varset_2d_member_3f_ ___PRM(83,___G_c_23_varset_2d_member_3f_)
#define ___GLO_c_23_varset_2d_remove ___GLO(84,___G_c_23_varset_2d_remove)
#define ___PRM_c_23_varset_2d_remove ___PRM(84,___G_c_23_varset_2d_remove)
#define ___GLO_c_23_varset_2d_reverse_2d_append_21_ ___GLO(85,___G_c_23_varset_2d_reverse_2d_append_21_)
#define ___PRM_c_23_varset_2d_reverse_2d_append_21_ ___PRM(85,___G_c_23_varset_2d_reverse_2d_append_21_)
#define ___GLO_c_23_varset_2d_singleton ___GLO(86,___G_c_23_varset_2d_singleton)
#define ___PRM_c_23_varset_2d_singleton ___PRM(86,___G_c_23_varset_2d_singleton)
#define ___GLO_c_23_varset_2d_size ___GLO(87,___G_c_23_varset_2d_size)
#define ___PRM_c_23_varset_2d_size ___PRM(87,___G_c_23_varset_2d_size)
#define ___GLO_c_23_varset_2d_union ___GLO(88,___G_c_23_varset_2d_union)
#define ___PRM_c_23_varset_2d_union ___PRM(88,___G_c_23_varset_2d_union)
#define ___GLO_c_23_varset_2d_union_2d_multi ___GLO(89,___G_c_23_varset_2d_union_2d_multi)
#define ___PRM_c_23_varset_2d_union_2d_multi ___PRM(89,___G_c_23_varset_2d_union_2d_multi)
#define ___GLO_c_23_varset_2d_unwrap ___GLO(90,___G_c_23_varset_2d_unwrap)
#define ___PRM_c_23_varset_2d_unwrap ___PRM(90,___G_c_23_varset_2d_unwrap)
#define ___GLO_c_23_varset_2d_wrap ___GLO(91,___G_c_23_varset_2d_wrap)
#define ___PRM_c_23_varset_2d_wrap ___PRM(91,___G_c_23_varset_2d_wrap)
#define ___GLO_c_23_vect_2d__3e_list ___GLO(92,___G_c_23_vect_2d__3e_list)
#define ___PRM_c_23_vect_2d__3e_list ___PRM(92,___G_c_23_vect_2d__3e_list)
#define ___GLO_c_23_warnings_2d_requested_3f_ ___GLO(93,___G_c_23_warnings_2d_requested_3f_)
#define ___PRM_c_23_warnings_2d_requested_3f_ ___PRM(93,___G_c_23_warnings_2d_requested_3f_)
#define ___GLO_c_23_with_2d_exception_2d_handling ___GLO(94,___G_c_23_with_2d_exception_2d_handling)
#define ___PRM_c_23_with_2d_exception_2d_handling ___PRM(94,___G_c_23_with_2d_exception_2d_handling)
#define ___GLO__23__23_call_2d_with_2d_current_2d_continuation ___GLO(95,___G__23__23_call_2d_with_2d_current_2d_continuation)
#define ___PRM__23__23_call_2d_with_2d_current_2d_continuation ___PRM(95,___G__23__23_call_2d_with_2d_current_2d_continuation)
#define ___GLO__2b_ ___GLO(96,___G__2b_)
#define ___PRM__2b_ ___PRM(96,___G__2b_)
#define ___GLO_apply ___GLO(97,___G_apply)
#define ___PRM_apply ___PRM(97,___G_apply)
#define ___GLO_c_23_fatal_2d_err ___GLO(98,___G_c_23_fatal_2d_err)
#define ___PRM_c_23_fatal_2d_err ___PRM(98,___G_c_23_fatal_2d_err)
#define ___GLO_c_23_locat_2d_show ___GLO(99,___G_c_23_locat_2d_show)
#define ___PRM_c_23_locat_2d_show ___PRM(99,___G_c_23_locat_2d_show)
#define ___GLO_display ___GLO(100,___G_display)
#define ___PRM_display ___PRM(100,___G_display)
#define ___GLO_equal_3f_ ___GLO(101,___G_equal_3f_)
#define ___PRM_equal_3f_ ___PRM(101,___G_equal_3f_)
#define ___GLO_make_2d_string ___GLO(102,___G_make_2d_string)
#define ___PRM_make_2d_string ___PRM(102,___G_make_2d_string)
#define ___GLO_make_2d_table ___GLO(103,___G_make_2d_table)
#define ___PRM_make_2d_table ___PRM(103,___G_make_2d_table)
#define ___GLO_make_2d_vector ___GLO(104,___G_make_2d_vector)
#define ___PRM_make_2d_vector ___PRM(104,___G_make_2d_vector)
#define ___GLO_newline ___GLO(105,___G_newline)
#define ___PRM_newline ___PRM(105,___G_newline)
#define ___GLO_read_2d_char ___GLO(106,___G_read_2d_char)
#define ___PRM_read_2d_char ___PRM(106,___G_read_2d_char)
#define ___GLO_reverse ___GLO(107,___G_reverse)
#define ___PRM_reverse ___PRM(107,___G_reverse)
#define ___GLO_string_3d__3f_ ___GLO(108,___G_string_3d__3f_)
#define ___PRM_string_3d__3f_ ___PRM(108,___G_string_3d__3f_)
#define ___GLO_table_2d_ref ___GLO(109,___G_table_2d_ref)
#define ___PRM_table_2d_ref ___PRM(109,___G_table_2d_ref)
#define ___GLO_table_2d_set_21_ ___GLO(110,___G_table_2d_set_21_)
#define ___PRM_table_2d_set_21_ ___PRM(110,___G_table_2d_set_21_)
#define ___GLO_write ___GLO(111,___G_write)
#define ___PRM_write ___PRM(111,___G_write)

___DEF_SUB_VEC(___X0,0UL)
               ___VEC0
___DEF_SUB_STR(___X1,13UL)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR5(82,32,45,45,32)
___DEF_SUB_STR(___X2,1UL)
               ___STR1(32)
___DEF_SUB_STR(___X3,9UL)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR1(82)
___DEF_SUB_STR(___X4,4UL)
               ___STR4(32,73,78,32)
___DEF_SUB_STR(___X5,4UL)
               ___STR4(32,45,45,32)
___DEF_SUB_STR(___X6,1UL)
               ___STR1(32)
___DEF_SUB_STR(___X7,11UL)
               ___STR8(42,42,42,32,87,65,82,78)
               ___STR3(73,78,71)
___DEF_SUB_STR(___X8,4UL)
               ___STR4(32,73,78,32)
___DEF_SUB_STR(___X9,4UL)
               ___STR4(32,45,45,32)
___DEF_SUB_STR(___X10,1UL)
               ___STR1(32)
___DEF_SUB_STR(___X11,45UL)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR8(82,32,45,45,32,67,111,109)
               ___STR8(112,105,108,101,114,32,105,110)
               ___STR8(116,101,114,110,97,108,32,101)
               ___STR8(114,114,111,114,32,100,101,116)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X12,1UL)
               ___STR1(32)
___DEF_SUB_STR(___X13,17UL)
               ___STR8(42,42,42,32,105,110,32,112)
               ___STR8(114,111,99,101,100,117,114,101)
               ___STR1(32)
___DEF_SUB_STR(___X14,35UL)
               ___STR8(42,42,42,32,69,82,82,79)
               ___STR8(82,32,45,45,32,67,111,109)
               ___STR8(112,105,108,101,114,32,108,105)
               ___STR8(109,105,116,32,114,101,97,99)
               ___STR3(104,101,100)
___DEF_SUB_STR(___X15,1UL)
               ___STR1(32)
___DEF_SUB_STR(___X16,4UL)
               ___STR4(42,42,42,32)
___DEF_SUB_STR(___X17,26UL)
               ___STR8(113,117,101,117,101,45,103,101)
               ___STR8(116,33,44,32,113,117,101,117)
               ___STR8(101,32,105,115,32,101,109,112)
               ___STR2(116,121)
___DEF_SUB_STR(___X18,50UL)
               ___STR8(73,110,116,101,114,110,97,108)
               ___STR8(32,101,114,114,111,114,44,32)
               ___STR8(110,111,32,101,120,99,101,112)
               ___STR8(116,105,111,110,32,104,97,110)
               ___STR8(100,108,101,114,32,97,116,32)
               ___STR8(116,104,105,115,32,112,111,105)
               ___STR2(110,116)
___DEF_SUB_VEC(___X19,5UL)
               ___VEC1(___REF_SYM(0,___S___utils))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FAL)
               ___VEC0

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
___DEF_M_HLBL(___L2__20___utils)
___DEF_M_HLBL(___L3__20___utils)
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
___DEF_M_HLBL(___L0_c_23_map_2d_index)
___DEF_M_HLBL(___L1_c_23_map_2d_index)
___DEF_M_HLBL(___L2_c_23_map_2d_index)
___DEF_M_HLBL(___L3_c_23_map_2d_index)
___DEF_M_HLBL(___L4_c_23_map_2d_index)
___DEF_M_HLBL(___L5_c_23_map_2d_index)
___DEF_M_HLBL(___L6_c_23_map_2d_index)
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
___DEF_M_HLBL(___L0_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L1_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L2_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L3_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L4_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L5_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L6_c_23_read_2d_line_2a_)
___DEF_M_HLBL(___L7_c_23_read_2d_line_2a_)
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
___DEF_M_HLBL(___L0_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_M_HLBL(___L1_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_M_HLBL(___L2_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_M_HLBL(___L3_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L1_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L2_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L3_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L4_c_23_make_2d_ordered_2d_table)
___DEF_M_HLBL(___L5_c_23_make_2d_ordered_2d_table)
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
___DEF_M_HLBL(___L27_c_23_transitive_2d_closure)
___DEF_M_HLBL(___L28_c_23_transitive_2d_closure)
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
___DEF_M_HLBL(___L7_c_23_remove_2d_no_2d_depvars)
___DEF_M_HLBL(___L8_c_23_remove_2d_no_2d_depvars)
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
___DEF_M_HLBL(___L0_c_23_list_2d__3e_ptset)
___DEF_M_HLBL(___L1_c_23_list_2d__3e_ptset)
___DEF_M_HLBL(___L2_c_23_list_2d__3e_ptset)
___DEF_M_HLBL(___L3_c_23_list_2d__3e_ptset)
___DEF_M_HLBL(___L4_c_23_list_2d__3e_ptset)
___DEF_M_HLBL(___L5_c_23_list_2d__3e_ptset)
___DEF_M_HLBL(___L6_c_23_list_2d__3e_ptset)
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
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___utils)
___DEF_P_HLBL(___L1__20___utils)
___DEF_P_HLBL(___L2__20___utils)
___DEF_P_HLBL(___L3__20___utils)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___utils)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___utils)
   ___SET_GLO(71,___G_c_23_throw_2d_to_2d_exception_2d_handler,___PRC(628))
   ___SET_GLO(93,___G_c_23_warnings_2d_requested_3f_,___FAL)
   ___SET_GLO(93,___G_c_23_warnings_2d_requested_3f_,___TRU)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__20___utils)
   ___JUMPINT(___SET_NARGS(0),___PRC(426),___L_c_23_ptset_2d_empty)
___DEF_SLBL(2,___L2__20___utils)
   ___SET_GLO(44,___G_c_23_ptset_2d_empty_2d_set,___R1)
   ___SET_R1(___VOID)
   ___POLL(3)
___DEF_SLBL(3,___L3__20___utils)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_append_2d_lists
#undef ___PH_LBL0
#define ___PH_LBL0 6
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
#define ___PH_LBL0 17
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
#define ___PH_LBL0 20
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
#define ___PH_LBL0 24
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
   ___SET_STK(1,___ALLOC_CLO(1UL))
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
#define ___PH_LBL0 28
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
#define ___PH_PROC ___H_c_23_map_2d_index
#undef ___PH_LBL0
#define ___PH_LBL0 34
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_map_2d_index)
___DEF_P_HLBL(___L1_c_23_map_2d_index)
___DEF_P_HLBL(___L2_c_23_map_2d_index)
___DEF_P_HLBL(___L3_c_23_map_2d_index)
___DEF_P_HLBL(___L4_c_23_map_2d_index)
___DEF_P_HLBL(___L5_c_23_map_2d_index)
___DEF_P_HLBL(___L6_c_23_map_2d_index)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_map_2d_index)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_map_2d_index)
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___SET_R3(___NUL)
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_map_2d_index)
   ___GOTO(___L7_c_23_map_2d_index)
___DEF_SLBL(2,___L2_c_23_map_2d_index)
   ___SET_R3(___CONS(___R1,___STK(-3)))
   ___SET_R2(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_map_2d_index)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_map_2d_index)
___DEF_GLBL(___L7_c_23_map_2d_index)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L8_c_23_map_2d_index)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_map_2d_index)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-7))
___DEF_GLBL(___L8_c_23_map_2d_index)
   ___SET_R1(___R3)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_map_2d_index)
   ___ADJFP(-1)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pos_2d_in_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 42
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
#define ___PH_LBL0 46
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
   ___JUMPPRM(___SET_NARGS(2),___PRM_equal_3f_)
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
#define ___PH_LBL0 53
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
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_3d__3f_)
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
#define ___PH_LBL0 60
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
#define ___PH_LBL0 67
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
#define ___PH_LBL0 71
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
#define ___PH_LBL0 78
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
#define ___PH_LBL0 82
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
   ___JUMPINT(___SET_NARGS(2),___PRC(17),___L_c_23_reverse_2d_append_21_)
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
#define ___PH_LBL0 91
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
#define ___PH_LBL0 97
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
   ___JUMPINT(___SET_NARGS(2),___PRC(17),___L_c_23_reverse_2d_append_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_sort_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 103
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
#define ___PH_LBL0 124
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
   ___JUMPINT(___SET_NARGS(1),___PRC(20),___L_c_23_list_2d_length)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_vect)
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
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
#define ___PH_LBL0 131
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
#define ___PH_LBL0 136
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
   ___JUMPINT(___SET_NARGS(1),___PRC(20),___L_c_23_list_2d_length)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_str)
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_string)
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
#define ___PH_LBL0 143
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
#define ___PH_PROC ___H_c_23_read_2d_line_2a_
#undef ___PH_LBL0
#define ___PH_LBL0 148
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L1_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L2_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L3_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L4_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L5_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L6_c_23_read_2d_line_2a_)
___DEF_P_HLBL(___L7_c_23_read_2d_line_2a_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_read_2d_line_2a_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_read_2d_line_2a_)
   ___SET_R2(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_read_2d_line_2a_)
   ___GOTO(___L8_c_23_read_2d_line_2a_)
___DEF_SLBL(2,___L2_c_23_read_2d_line_2a_)
   ___IF(___EOFP(___R1))
   ___GOTO(___L9_c_23_read_2d_line_2a_)
   ___END_IF
   ___IF(___CHAREQP(___R1,___CHR(13)))
   ___GOTO(___L9_c_23_read_2d_line_2a_)
   ___END_IF
   ___IF(___CHAREQP(___R1,___CHR(10)))
   ___GOTO(___L9_c_23_read_2d_line_2a_)
   ___END_IF
   ___SET_R2(___CONS(___R1,___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_read_2d_line_2a_)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_read_2d_line_2a_)
___DEF_GLBL(___L8_c_23_read_2d_line_2a_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_read_2d_line_2a_)
   ___JUMPPRM(___SET_NARGS(1),___PRM_read_2d_char)
___DEF_GLBL(___L9_c_23_read_2d_line_2a_)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(6,___L6_c_23_read_2d_line_2a_)
   ___SET_R0(___STK(-3))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_read_2d_line_2a_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(136),___L_c_23_list_2d__3e_str)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_stretchable_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 157
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
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___SUB(0))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___FIX(0L))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_make_2d_stretchable_2d_vector)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 160
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
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 162
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
#define ___PH_LBL0 164
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
   ___SET_STK(2,___VECTORREF(___R1,___FIX(2L)))
   ___ADJFP(2)
   ___IF(___NOT(___FIXLT(___R2,___STK(0))))
   ___GOTO(___L4_c_23_stretchable_2d_vector_2d_set_21_)
   ___END_IF
   ___IF(___FIXLT(___R2,___STK(-1)))
   ___GOTO(___L6_c_23_stretchable_2d_vector_2d_set_21_)
   ___END_IF
   ___GOTO(___L5_c_23_stretchable_2d_vector_2d_set_21_)
___DEF_GLBL(___L4_c_23_stretchable_2d_vector_2d_set_21_)
   ___SET_STK(0,___FIXADD(___R2,___FIX(1L)))
   ___VECTORSET(___R1,___FIX(2L),___STK(0))
   ___IF(___FIXLT(___R2,___STK(-1)))
   ___GOTO(___L6_c_23_stretchable_2d_vector_2d_set_21_)
   ___END_IF
___DEF_GLBL(___L5_c_23_stretchable_2d_vector_2d_set_21_)
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R1(___FIXMUL(___STK(-1),___FIX(3L)))
   ___SET_R1(___FIXQUO(___R1,___FIX(2L)))
   ___SET_R1(___FIXMAX(___R2,___R1))
   ___SET_R2(___FIXADD(___R1,___FIX(1L)))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(1L)))
   ___SET_R1(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(6)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretchable_2d_vector_2d_set_21_)
   ___JUMPINT(___SET_NARGS(3),___PRC(169),___L_c_23_stretch_2d_vector)
___DEF_SLBL(2,___L2_c_23_stretchable_2d_vector_2d_set_21_)
   ___VECTORSET(___STK(-5),___FIX(0L),___R1)
   ___VECTORSET(___R1,___STK(-4),___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretchable_2d_vector_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L6_c_23_stretchable_2d_vector_2d_set_21_)
   ___VECTORSET(___R4,___R2,___R3) ___SET_R1(___R4)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretch_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 169
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
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
#define ___PH_LBL0 178
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
   ___SET_R3(___VECTORREF(___R1,___FIX(2L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretchable_2d_vector_2d_copy)
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
___DEF_SLBL(2,___L2_c_23_stretchable_2d_vector_2d_copy)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R3(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-3))
   ___ADJFP(-6)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretchable_2d_vector_2d_copy)
   ___GOTO(___L7_c_23_stretchable_2d_vector_2d_copy)
___DEF_GLBL(___L6_c_23_stretchable_2d_vector_2d_copy)
   ___SET_R4(___VECTORREF(___STK(0),___R3))
   ___VECTORSET(___R2,___R3,___R4)
   ___SET_R3(___FIXSUB(___R3,___FIX(1L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_stretchable_2d_vector_2d_copy)
___DEF_GLBL(___L7_c_23_stretchable_2d_vector_2d_copy)
   ___IF(___FIXGE(___R3,___FIX(0L)))
   ___GOTO(___L6_c_23_stretchable_2d_vector_2d_copy)
   ___END_IF
   ___SET_R3(___VECTORREF(___STK(-1),___FIX(1L)))
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___R2)
   ___ADD_VECTOR_ELEM(1,___R3)
   ___ADD_VECTOR_ELEM(2,___R1)
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___ADJFP(-2)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_stretchable_2d_vector_2d_copy)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d_for_2d_each
#undef ___PH_LBL0
#define ___PH_LBL0 185
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
   ___SET_R3(___VECTORREF(___R2,___FIX(0L)))
   ___SET_R2(___VECTORREF(___R2,___FIX(2L)))
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
   ___IF(___NOT(___FIXLT(___R3,___R1)))
   ___GOTO(___L6_c_23_stretchable_2d_vector_2d_for_2d_each)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___VECTORREF(___R2,___R3))
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
#define ___PH_PROC ___H_c_23_stretchable_2d_vector_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 191
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_P_HLBL(___L1_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_P_HLBL(___L2_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_P_HLBL(___L3_c_23_stretchable_2d_vector_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_stretchable_2d_vector_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_stretchable_2d_vector_2d__3e_list)
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R1(___FIXSUB(___R1,___FIX(1L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___SET_R3(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_stretchable_2d_vector_2d__3e_list)
   ___GOTO(___L5_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_GLBL(___L4_c_23_stretchable_2d_vector_2d__3e_list)
   ___SET_R4(___VECTORREF(___R1,___R2))
   ___SET_R3(___CONS(___R4,___R3))
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_stretchable_2d_vector_2d__3e_list)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_stretchable_2d_vector_2d__3e_list)
___DEF_GLBL(___L5_c_23_stretchable_2d_vector_2d__3e_list)
   ___IF(___NOT(___FIXLT(___R2,___FIX(0L))))
   ___GOTO(___L4_c_23_stretchable_2d_vector_2d__3e_list)
   ___END_IF
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_ordered_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 196
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
___DEF_P_HLBL(___L5_c_23_make_2d_ordered_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_ordered_2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_ordered_2d_table)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___KEY_test)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_ordered_2d_table)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),103,___G_make_2d_table)
___DEF_SLBL(2,___L2_c_23_make_2d_ordered_2d_table)
   ___SET_STK(-2,___R1)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(1),___PRC(157),___L_c_23_make_2d_stretchable_2d_vector)
___DEF_SLBL(3,___L3_c_23_make_2d_ordered_2d_table)
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___STK(-6))
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___FIX(0L))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_make_2d_ordered_2d_table)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_make_2d_ordered_2d_table)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 203
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
#define ___PH_LBL0 205
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
   ___JUMPGLONOTSAFE(___SET_NARGS(3),109,___G_table_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ordered_2d_table_2d_lookup
#undef ___PH_LBL0
#define ___PH_LBL0 208
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
   ___JUMPGLONOTSAFE(___SET_NARGS(3),109,___G_table_2d_ref)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(162),___L_c_23_stretchable_2d_vector_2d_ref)
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
#define ___PH_LBL0 215
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
   ___JUMPGLONOTSAFE(___SET_NARGS(3),110,___G_table_2d_set_21_)
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
   ___JUMPINT(___SET_NARGS(3),___PRC(164),___L_c_23_stretchable_2d_vector_2d_set_21_)
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
#define ___PH_LBL0 223
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
   ___JUMPINT(___SET_NARGS(2),___PRC(162),___L_c_23_stretchable_2d_vector_2d_ref)
___DEF_GLBL(___L7_c_23_ordered_2d_table_2d__3e_list)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bits_2d_and
#undef ___PH_LBL0
#define ___PH_LBL0 230
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
#define ___PH_LBL0 237
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
#define ___PH_LBL0 244
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
#define ___PH_LBL0 248
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
#define ___PH_LBL0 252
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
   ___SET_STK(1,___GLO_c_23_throw_2d_to_2d_exception_2d_handler)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___LBL(4))
   ___SET_R2(___STK(3))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_with_2d_exception_2d_handling)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_call_2d_with_2d_current_2d_continuation)
___DEF_SLBL(2,___L2_c_23_with_2d_exception_2d_handling)
   ___SET_GLO(71,___G_c_23_throw_2d_to_2d_exception_2d_handler,___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_with_2d_exception_2d_handling)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_SLBL(4,___L4_c_23_with_2d_exception_2d_handling)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(4,2,0,0)
   ___SET_GLO(71,___G_c_23_throw_2d_to_2d_exception_2d_handler,___R1)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_with_2d_exception_2d_handling)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 259
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
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
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___DEF_SLBL(7,___L7_c_23_compiler_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(326),___L_c_23_compiler_2d_abort)
___DEF_SLBL(9,___L9_c_23_compiler_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_SLBL(10,___L10_c_23_compiler_2d_error)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_user_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 271
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(2,___L2_c_23_compiler_2d_user_2d_error)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(4))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),99,___G_c_23_locat_2d_show)
___DEF_SLBL(3,___L3_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___SUB(5))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(4,___L4_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(9,___L9_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_GLBL(___L14_c_23_compiler_2d_user_2d_error)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(10,___L10_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___DEF_SLBL(11,___L11_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_compiler_2d_user_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(326),___L_c_23_compiler_2d_abort)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_user_2d_warning
#undef ___PH_LBL0
#define ___PH_LBL0 285
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
   ___IF(___FALSEP(___GLO_c_23_warnings_2d_requested_3f_))
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(2,___L2_c_23_compiler_2d_user_2d_warning)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(8))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),99,___G_c_23_locat_2d_show)
___DEF_SLBL(3,___L3_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___SUB(9))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(4,___L4_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(9,___L9_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_GLBL(___L13_c_23_compiler_2d_user_2d_warning)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(10,___L10_c_23_compiler_2d_user_2d_warning)
   ___SET_R0(___STK(-3))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_compiler_2d_user_2d_warning)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_internal_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 298
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
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
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___DEF_SLBL(7,___L7_c_23_compiler_2d_internal_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_internal_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(326),___L_c_23_compiler_2d_abort)
___DEF_SLBL(9,___L9_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_SLBL(10,___L10_c_23_compiler_2d_internal_2d_error)
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___DEF_SLBL(11,___L11_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___SUB(13))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(12,___L12_c_23_compiler_2d_internal_2d_error)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_limitation_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 312
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
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
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___DEF_SLBL(7,___L7_c_23_compiler_2d_limitation_2d_error)
   ___SET_R0(___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_compiler_2d_limitation_2d_error)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(326),___L_c_23_compiler_2d_abort)
___DEF_SLBL(9,___L9_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_SLBL(10,___L10_c_23_compiler_2d_limitation_2d_error)
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(0),___PRM_newline)
___DEF_SLBL(11,___L11_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___SUB(16))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(12,___L12_c_23_compiler_2d_limitation_2d_error)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_compiler_2d_abort
#undef ___PH_LBL0
#define ___PH_LBL0 326
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
   ___JUMPGLONOTSAFE(___SET_NARGS(1),71,___G_c_23_throw_2d_to_2d_exception_2d_handler)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_gnode
#undef ___PH_LBL0
#define ___PH_LBL0 329
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
   ___BEGIN_ALLOC_VECTOR(2UL)
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
#define ___PH_LBL0 332
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
#define ___PH_LBL0 334
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
#define ___PH_LBL0 336
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
___DEF_P_HLBL(___L27_c_23_transitive_2d_closure)
___DEF_P_HLBL(___L28_c_23_transitive_2d_closure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_transitive_2d_closure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_transitive_2d_closure)
   ___SET_STK(1,___R0)
   ___SET_R2(___LBL(26))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(2),___PRC(103),___L_c_23_sort_2d_list)
___DEF_SLBL(2,___L2_c_23_transitive_2d_closure)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(124),___L_c_23_list_2d__3e_vect)
___DEF_SLBL(3,___L3_c_23_transitive_2d_closure)
   ___SET_R2(___VECTORLENGTH(___R1))
   ___SET_STK(-2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_transitive_2d_closure)
   ___GOTO(___L29_c_23_transitive_2d_closure)
___DEF_SLBL(5,___L5_c_23_transitive_2d_closure)
   ___IF(___NOT(___NOT(___FALSEP(___UNBOX(___STK(-4))))))
   ___GOTO(___L36_c_23_transitive_2d_closure)
   ___END_IF
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_transitive_2d_closure)
___DEF_GLBL(___L29_c_23_transitive_2d_closure)
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
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
___DEF_SLBL(9,___L9_c_23_transitive_2d_closure)
   ___SET_STK(1,___STK(-6))
   ___SET_STK(2,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___LBL(5))
   ___ADJFP(2)
   ___IF(___FIXEQ(___R3,___STK(-1)))
   ___GOTO(___L35_c_23_transitive_2d_closure)
   ___END_IF
   ___GOTO(___L31_c_23_transitive_2d_closure)
___DEF_SLBL(10,___L10_c_23_transitive_2d_closure)
   ___IF(___FIXEQ(___STK(-3),___R1))
   ___GOTO(___L30_c_23_transitive_2d_closure)
   ___END_IF
   ___SETBOX(___STK(-7),___TRU)
___DEF_GLBL(___L30_c_23_transitive_2d_closure)
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(2UL)
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
   ___GOTO(___L35_c_23_transitive_2d_closure)
   ___END_IF
___DEF_GLBL(___L31_c_23_transitive_2d_closure)
   ___SET_R4(___VECTORREF(___STK(0),___R3))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(1L)))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___CDR(___STK(1)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(21))
   ___ADJFP(10)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_transitive_2d_closure)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L33_c_23_transitive_2d_closure)
   ___END_IF
___DEF_GLBL(___L32_c_23_transitive_2d_closure)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(15))
   ___ADJFP(8)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(2),___PRC(366),___L_c_23_gnode_2d_find_2d_depvars)
___DEF_SLBL(15,___L15_c_23_transitive_2d_closure)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L32_c_23_transitive_2d_closure)
   ___END_IF
___DEF_GLBL(___L33_c_23_transitive_2d_closure)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(16,___L16_c_23_transitive_2d_closure)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_c_23_transitive_2d_closure)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_transitive_2d_closure)
   ___GOTO(___L34_c_23_transitive_2d_closure)
___DEF_SLBL(19,___L19_c_23_transitive_2d_closure)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(8L)))
   ___SET_R1(___BOOLEAN(___FIXLT(___R2,___R1)))
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_transitive_2d_closure)
___DEF_GLBL(___L34_c_23_transitive_2d_closure)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(21,___L21_c_23_transitive_2d_closure)
   ___SET_R1(___CONS(___STK(-9),___R1))
   ___SET_R0(___LBL(23))
   ___CHECK_HEAP(22,4096)
___DEF_SLBL(22,___L22_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(1),___PRC(593),___L_c_23_varset_2d_union_2d_multi)
___DEF_SLBL(23,___L23_c_23_transitive_2d_closure)
   ___SET_STK(-9,___R1)
   ___SET_R0(___LBL(24))
   ___JUMPINT(___SET_NARGS(1),___PRC(514),___L_c_23_varset_2d_size)
___DEF_SLBL(24,___L24_c_23_transitive_2d_closure)
   ___SET_STK(-3,___R1)
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(514),___L_c_23_varset_2d_size)
___DEF_GLBL(___L35_c_23_transitive_2d_closure)
   ___SET_R1(___R2)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L36_c_23_transitive_2d_closure)
   ___SET_R0(___STK(-7))
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_transitive_2d_closure)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(131),___L_c_23_vect_2d__3e_list)
___DEF_SLBL(26,___L26_c_23_transitive_2d_closure)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(26,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R0(___LBL(28))
   ___ADJFP(8)
   ___POLL(27)
___DEF_SLBL(27,___L27_c_23_transitive_2d_closure)
   ___JUMPINT(___SET_NARGS(1),___PRC(332),___L_c_23_gnode_2d_var)
___DEF_SLBL(28,___L28_c_23_transitive_2d_closure)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___JUMPINT(___SET_NARGS(1),___PRC(332),___L_c_23_gnode_2d_var)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_gnode_2d_find_2d_depvars
#undef ___PH_LBL0
#define ___PH_LBL0 366
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
   ___JUMPINT(___SET_NARGS(0),___PRC(492),___L_c_23_varset_2d_empty)
___DEF_GLBL(___L8_c_23_gnode_2d_find_2d_depvars)
   ___SET_R4(___FIXADD(___R3,___R2))
   ___SET_R4(___FIXQUO(___R4,___FIX(2L)))
   ___SET_STK(1,___VECTORREF(___R1,___R4))
   ___SET_STK(2,___VECTORREF(___STK(1),___FIX(0L)))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
#define ___PH_LBL0 374
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
#define ___PH_LBL0 383
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
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
   ___JUMPINT(___SET_NARGS(1),___PRC(402),___L_c_23_remove_2d_no_2d_depvars)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(498),___L_c_23_list_2d__3e_varset)
___DEF_SLBL(13,___L13_c_23_topological_2d_sort)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(2),___PRC(374),___L_c_23_gnodes_2d_remove)
___DEF_SLBL(14,___L14_c_23_topological_2d_sort)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(1))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L23_c_23_topological_2d_sort)
   ___END_IF
   ___GOTO(___L21_c_23_topological_2d_sort)
___DEF_SLBL(15,___L15_c_23_topological_2d_sort)
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(2UL)
   ___ADD_VECTOR_ELEM(0,___R2)
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
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___VECTORREF(___R3,___FIX(1L)))
   ___SET_R0(___LBL(15))
   ___ADJFP(8)
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_topological_2d_sort)
   ___JUMPINT(___SET_NARGS(2),___PRC(553),___L_c_23_varset_2d_difference)
___DEF_GLBL(___L24_c_23_topological_2d_sort)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(412),___L_c_23_remove_2d_cycle)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_remove_2d_no_2d_depvars
#undef ___PH_LBL0
#define ___PH_LBL0 402
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
___DEF_P_HLBL(___L7_c_23_remove_2d_no_2d_depvars)
___DEF_P_HLBL(___L8_c_23_remove_2d_no_2d_depvars)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(82),___L_c_23_keep)
___DEF_SLBL(2,___L2_c_23_remove_2d_no_2d_depvars)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L9_c_23_remove_2d_no_2d_depvars)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_remove_2d_no_2d_depvars)
   ___GOTO(___L10_c_23_remove_2d_no_2d_depvars)
___DEF_GLBL(___L9_c_23_remove_2d_no_2d_depvars)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_remove_2d_no_2d_depvars)
___DEF_GLBL(___L10_c_23_remove_2d_no_2d_depvars)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(5,___L5_c_23_remove_2d_no_2d_depvars)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(5,1,0,0)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_remove_2d_no_2d_depvars)
   ___JUMPINT(___SET_NARGS(1),___PRC(334),___L_c_23_gnode_2d_depvars)
___DEF_SLBL(7,___L7_c_23_remove_2d_no_2d_depvars)
   ___SET_R1(___CDR(___R1))
   ___SET_R1(___BOOLEAN(___NULLP(___R1)))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_remove_2d_no_2d_depvars)
   ___GOTO(___L10_c_23_remove_2d_no_2d_depvars)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_remove_2d_cycle
#undef ___PH_LBL0
#define ___PH_LBL0 412
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
   ___SET_R4(___VECTORREF(___R3,___FIX(1L)))
   ___SET_STK(1,___ALLOC_CLO(1UL))
   ___SET_STK(2,___ALLOC_CLO(1UL))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(82),___L_c_23_keep)
___DEF_SLBL(7,___L7_c_23_remove_2d_cycle)
   ___SET_STK(-6,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(2),___PRC(91),___L_c_23_every_3f_)
___DEF_SLBL(8,___L8_c_23_remove_2d_cycle)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(8,1,0,0)
   ___SET_R2(___CLO(___R4,1))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_remove_2d_cycle)
   ___JUMPINT(___SET_NARGS(2),___PRC(521),___L_c_23_varset_2d_member_3f_)
___DEF_SLBL(10,___L10_c_23_remove_2d_cycle)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(10,1,0,0)
   ___SET_R2(___CLO(___R4,1))
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_remove_2d_cycle)
   ___JUMPINT(___SET_NARGS(2),___PRC(549),___L_c_23_varset_2d_equal_3f_)
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
#define ___PH_LBL0 426
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
   ___BEGIN_ALLOC_VECTOR(11UL)
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
#define ___PH_PROC ___H_c_23_list_2d__3e_ptset
#undef ___PH_LBL0
#define ___PH_LBL0 429
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d__3e_ptset)
___DEF_P_HLBL(___L1_c_23_list_2d__3e_ptset)
___DEF_P_HLBL(___L2_c_23_list_2d__3e_ptset)
___DEF_P_HLBL(___L3_c_23_list_2d__3e_ptset)
___DEF_P_HLBL(___L4_c_23_list_2d__3e_ptset)
___DEF_P_HLBL(___L5_c_23_list_2d__3e_ptset)
___DEF_P_HLBL(___L6_c_23_list_2d__3e_ptset)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d__3e_ptset)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_list_2d__3e_ptset)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_list_2d__3e_ptset)
   ___JUMPINT(___SET_NARGS(0),___PRC(426),___L_c_23_ptset_2d_empty)
___DEF_SLBL(2,___L2_c_23_list_2d__3e_ptset)
   ___SET_R2(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_list_2d__3e_ptset)
   ___GOTO(___L7_c_23_list_2d__3e_ptset)
___DEF_SLBL(4,___L4_c_23_list_2d__3e_ptset)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_list_2d__3e_ptset)
___DEF_GLBL(___L7_c_23_list_2d__3e_ptset)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L8_c_23_list_2d__3e_ptset)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___CAR(___R2))
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_list_2d__3e_ptset)
   ___JUMPINT(___SET_NARGS(2),___PRC(460),___L_c_23_ptset_2d_adjoin)
___DEF_GLBL(___L8_c_23_list_2d__3e_ptset)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 437
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
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
   ___JUMPINT(___SET_NARGS(1),___PRC(131),___L_c_23_vect_2d__3e_list)
___DEF_SLBL(2,___L2_c_23_ptset_2d__3e_list)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ptset_2d__3e_list)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(6),___L_c_23_append_2d_lists)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_size
#undef ___PH_LBL0
#define ___PH_LBL0 442
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
   ___JUMPINT(___SET_NARGS(1),___PRC(131),___L_c_23_vect_2d__3e_list)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(20),___L_c_23_list_2d_length)
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
   ___SET_R1(___PRM__2b_)
   ___SET_R0(___STK(-3))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_ptset_2d_size)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(2),___PRM_apply)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptset_2d_empty_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 453
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
   ___IF(___EQP(___R1,___GLO_c_23_ptset_2d_empty_2d_set))
   ___GOTO(___L3_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___IF(___NOT(___MEMALLOCATEDP(___R1)))
   ___GOTO(___L2_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___IF(___NOT(___MEMALLOCATEDP(___GLO_c_23_ptset_2d_empty_2d_set)))
   ___GOTO(___L2_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___SET_R2(___SUBTYPE(___R1))
   ___SET_R3(___SUBTYPE(___GLO_c_23_ptset_2d_empty_2d_set))
   ___IF(___NOT(___FIXEQ(___R2,___R3)))
   ___GOTO(___L2_c_23_ptset_2d_empty_3f_)
   ___END_IF
   ___SET_R2(___GLO_c_23_ptset_2d_empty_2d_set)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptset_2d_empty_3f_)
   ___JUMPPRM(___SET_NARGS(2),___PRM_equal_3f_)
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
#define ___PH_LBL0 456
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
   ___SET_R3(___VECTORREF(___R1,___FIX(7L)))
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
#define ___PH_LBL0 460
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
   ___SET_R3(___VECTORREF(___R2,___FIX(7L)))
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
#define ___PH_LBL0 467
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
   ___SET_STK(1,___ALLOC_CLO(1UL))
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
   ___JUMPINT(___SET_NARGS(1),___PRC(131),___L_c_23_vect_2d__3e_list)
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
#define ___PH_LBL0 479
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
   ___SET_R3(___VECTORREF(___R2,___FIX(7L)))
   ___SET_R3(___FIXMOD(___R3,___FIX(11L)))
   ___SET_R4(___VECTORREF(___R1,___R3))
   ___IF(___NULLP(___R4))
   ___GOTO(___L7_c_23_ptset_2d_remove)
   ___END_IF
   ___SET_STK(1,___CAR(___R4))
   ___ADJFP(1)
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_reverse_2d_append_21_
#undef ___PH_LBL0
#define ___PH_LBL0 483
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
#define ___PH_LBL0 487
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
#define ___PH_LBL0 490
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
#define ___PH_LBL0 492
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
#define ___PH_LBL0 495
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
#define ___PH_LBL0 498
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
   ___JUMPINT(___SET_NARGS(0),___PRC(492),___L_c_23_varset_2d_empty)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(593),___L_c_23_varset_2d_union_2d_multi)
___DEF_GLBL(___L18_c_23_list_2d__3e_varset)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(8))
   ___ADJFP(8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_list_2d__3e_varset)
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23_varset_2d_singleton)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 512
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
#define ___PH_LBL0 514
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
   ___JUMPINT(___SET_NARGS(1),___PRC(20),___L_c_23_list_2d_length)
___DEF_GLBL(___L2_c_23_varset_2d_size)
   ___SET_R1(___VECTORLENGTH(___R2))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_empty_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 517
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
#define ___PH_LBL0 519
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
   ___SET_R2(___VECTORREF(___R2,___FIX(8L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R1(___BOOLEAN(___FIXLT(___R1,___R2)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_member_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 521
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(124),___L_c_23_list_2d__3e_vect)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_adjoin
#undef ___PH_LBL0
#define ___PH_LBL0 530
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
   ___JUMPINT(___SET_NARGS(2),___PRC(483),___L_c_23_varset_2d_reverse_2d_append_21_)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
#define ___PH_LBL0 540
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(483),___L_c_23_varset_2d_reverse_2d_append_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_varset_2d_equal_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 549
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
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
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
#define ___PH_LBL0 553
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
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___SET_R3(___NUL)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(483),___L_c_23_varset_2d_reverse_2d_append_21_)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
#define ___PH_LBL0 563
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
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___SET_R3(___NUL)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(483),___L_c_23_varset_2d_reverse_2d_append_21_)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
#define ___PH_LBL0 576
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
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
   ___SET_R3(___NUL)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(483),___L_c_23_varset_2d_reverse_2d_append_21_)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
#define ___PH_LBL0 586
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
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___CDR(___R1))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(519),___L_c_23_varset_2d__3c_)
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
#define ___PH_LBL0 593
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
   ___JUMPINT(___SET_NARGS(0),___PRC(492),___L_c_23_varset_2d_empty)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(563),___L_c_23_varset_2d_union)
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
#define ___PH_LBL0 604
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
#define ___PH_LBL0 609
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
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23_last_2d_pair)
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
#define ___PH_LBL0 615
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
#define ___PH_LBL0 617
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
#define ___PH_LBL0 620
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
#define ___PH_LBL0 622
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
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(298),___L0_c_23_compiler_2d_internal_2d_error)
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
#define ___PH_LBL0 625
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
#define ___PH_LBL0 628
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
   ___JUMPGLONOTSAFE(___SET_NARGS(2),98,___G_c_23_fatal_2d_err)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___utils," _utils",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__20___utils,0,-1)
,___DEF_LBL_RET(___H__20___utils,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___utils,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___utils,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_append_2d_lists,"c#append-lists",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_append_2d_lists,1,-1)
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
,___DEF_LBL_PROC(___H_c_23_reverse_2d_append_21_,2,-1)
,___DEF_LBL_RET(___H_c_23_reverse_2d_append_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d_length,"c#list-length",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_list_2d_length,1,-1)
,___DEF_LBL_RET(___H_c_23_list_2d_length,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d_length,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_counter,"c#make-counter",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_counter,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_counter,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_make_2d_counter,0,1)
,___DEF_LBL_INTRO(___H_c_23_for_2d_each_2d_index,"c#for-each-index",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_for_2d_each_2d_index,2,-1)
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_for_2d_each_2d_index,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_map_2d_index,"c#map-index",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_map_2d_index,2,-1)
,___DEF_LBL_RET(___H_c_23_map_2d_index,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_map_2d_index,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_map_2d_index,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_map_2d_index,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_map_2d_index,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_map_2d_index,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_pos_2d_in_2d_list,"c#pos-in-list",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_pos_2d_in_2d_list,2,-1)
,___DEF_LBL_RET(___H_c_23_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_object_2d_pos_2d_in_2d_list,"c#object-pos-in-list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_object_2d_pos_2d_in_2d_list,2,-1)
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_object_2d_pos_2d_in_2d_list,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_string_2d_pos_2d_in_2d_list,"c#string-pos-in-list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_string_2d_pos_2d_in_2d_list,2,-1)
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_string_2d_pos_2d_in_2d_list,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_take,"c#take",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_take,2,-1)
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_take,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_drop,"c#drop",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_drop,2,-1)
,___DEF_LBL_RET(___H_c_23_drop,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_drop,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_pair_2d_up,"c#pair-up",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_pair_2d_up,2,-1)
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pair_2d_up,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_last_2d_pair,"c#last-pair",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_last_2d_pair,1,-1)
,___DEF_LBL_RET(___H_c_23_last_2d_pair,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_last_2d_pair,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_keep,"c#keep",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_keep,2,-1)
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_keep,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_every_3f_,"c#every?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_every_3f_,2,-1)
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_every_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_remq,"c#remq",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_remq,2,-1)
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remq,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_sort_2d_list,"c#sort-list",___REF_FAL,20,0)
,___DEF_LBL_PROC(___H_c_23_sort_2d_list,2,-1)
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
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_vect,1,-1)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_vect_2d__3e_list,"c#vect->list",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_vect_2d__3e_list,1,-1)
,___DEF_LBL_RET(___H_c_23_vect_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_vect_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_vect_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_str,"c#list->str",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_str,1,-1)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_str,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_str_2d__3e_list,"c#str->list",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_str_2d__3e_list,1,-1)
,___DEF_LBL_RET(___H_c_23_str_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_str_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_str_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_read_2d_line_2a_,"c#read-line*",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_read_2d_line_2a_,1,-1)
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_read_2d_line_2a_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_make_2d_stretchable_2d_vector,"c#make-stretchable-vector",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23_make_2d_stretchable_2d_vector,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_stretchable_2d_vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_length,"c#stretchable-vector-length",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_length,1,-1)
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_ref,"c#stretchable-vector-ref",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_ref,2,-1)
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_set_21_,"c#stretchable-vector-set!",___REF_FAL,4,
0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_set_21_,3,-1)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_set_21_,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_set_21_,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_set_21_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_stretch_2d_vector,"c#stretch-vector",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_stretch_2d_vector,3,-1)
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETN,9,0,0x3dL))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___IFD(___RETN,9,0,0x21L))
,___DEF_LBL_RET(___H_c_23_stretch_2d_vector,___OFD(___RETI,12,0,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_copy,"c#stretchable-vector-copy",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_copy,1,-1)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_copy,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d_for_2d_each,"c#stretchable-vector-for-each",___REF_FAL,
5,0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d_for_2d_each,2,-1)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d_for_2d_each,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_INTRO(___H_c_23_stretchable_2d_vector_2d__3e_list,"c#stretchable-vector->list",___REF_FAL,4,
0)
,___DEF_LBL_PROC(___H_c_23_stretchable_2d_vector_2d__3e_list,1,-1)
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_stretchable_2d_vector_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_ordered_2d_table,"c#make-ordered-table",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_ordered_2d_table,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_make_2d_ordered_2d_table,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_length,"c#ordered-table-length",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_length,1,-1)
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_index,"c#ordered-table-index",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_index,2,-1)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_index,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_lookup,"c#ordered-table-lookup",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_lookup,2,-1)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_lookup,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d_enter,"c#ordered-table-enter",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d_enter,3,-1)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETI,8,0,0x3f09L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d_enter,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_ordered_2d_table_2d__3e_list,"c#ordered-table->list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ordered_2d_table_2d__3e_list,1,-1)
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ordered_2d_table_2d__3e_list,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_and,"c#bits-and",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_and,2,-1)
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_bits_2d_and,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_or,"c#bits-or",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_or,2,-1)
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_bits_2d_or,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_shl,"c#bits-shl",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_shl,2,-1)
,___DEF_LBL_RET(___H_c_23_bits_2d_shl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_shl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_bits_2d_shr,"c#bits-shr",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_bits_2d_shr,2,-1)
,___DEF_LBL_RET(___H_c_23_bits_2d_shr,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_bits_2d_shr,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_with_2d_exception_2d_handling,"c#with-exception-handling",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H_c_23_with_2d_exception_2d_handling,1,-1)
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_PROC(___H_c_23_with_2d_exception_2d_handling,2,-1)
,___DEF_LBL_RET(___H_c_23_with_2d_exception_2d_handling,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_compiler_2d_error,"c#compiler-error",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_compiler_2d_error,2,-1)
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
,___DEF_LBL_PROC(___H_c_23_compiler_2d_user_2d_error,3,-1)
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

,___DEF_LBL_PROC(___H_c_23_compiler_2d_user_2d_warning,3,-1)
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
,___DEF_LBL_PROC(___H_c_23_compiler_2d_internal_2d_error,2,-1)
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
,___DEF_LBL_PROC(___H_c_23_compiler_2d_limitation_2d_error,2,-1)
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
,___DEF_LBL_PROC(___H_c_23_compiler_2d_abort,0,-1)
,___DEF_LBL_RET(___H_c_23_compiler_2d_abort,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_gnode,"c#make-gnode",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_gnode,2,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_gnode,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_gnode_2d_var,"c#gnode-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_gnode_2d_var,1,-1)
,___DEF_LBL_INTRO(___H_c_23_gnode_2d_depvars,"c#gnode-depvars",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_gnode_2d_depvars,1,-1)
,___DEF_LBL_INTRO(___H_c_23_transitive_2d_closure,"c#transitive-closure",___REF_FAL,29,0)
,___DEF_LBL_PROC(___H_c_23_transitive_2d_closure,1,-1)
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
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___OFD(___RETI,12,3,0x3f0fbL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xfbL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H_c_23_transitive_2d_closure,2,-1)
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_transitive_2d_closure,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23_gnode_2d_find_2d_depvars,"c#gnode-find-depvars",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_gnode_2d_find_2d_depvars,2,-1)
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_gnode_2d_find_2d_depvars,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_gnodes_2d_remove,"c#gnodes-remove",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_gnodes_2d_remove,2,-1)
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_gnodes_2d_remove,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_topological_2d_sort,"c#topological-sort",___REF_FAL,18,0)
,___DEF_LBL_PROC(___H_c_23_topological_2d_sort,1,-1)
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
,___DEF_LBL_INTRO(___H_c_23_remove_2d_no_2d_depvars,"c#remove-no-depvars",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_remove_2d_no_2d_depvars,1,-1)
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_remove_2d_no_2d_depvars,1,-1)
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_remove_2d_no_2d_depvars,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_remove_2d_cycle,"c#remove-cycle",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_remove_2d_cycle,1,-1)
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
,___DEF_LBL_PROC(___H_c_23_ptset_2d_empty,0,-1)
,___DEF_LBL_RET(___H_c_23_ptset_2d_empty,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_ptset,"c#list->ptset",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_ptset,1,-1)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_ptset,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_ptset,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_ptset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_ptset,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_ptset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_ptset,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d__3e_list,"c#ptset->list",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d__3e_list,1,-1)
,___DEF_LBL_RET(___H_c_23_ptset_2d__3e_list,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d__3e_list,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d__3e_list,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_size,"c#ptset-size",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_size,1,-1)
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
,___DEF_LBL_PROC(___H_c_23_ptset_2d_empty_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ptset_2d_empty_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_member_3f_,"c#ptset-member?",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_member_3f_,2,-1)
,___DEF_LBL_RET(___H_c_23_ptset_2d_member_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_member_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_adjoin,"c#ptset-adjoin",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_adjoin,2,-1)
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_adjoin,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_ptset_2d_every_3f_,"c#ptset-every?",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_ptset_2d_every_3f_,2,-1)
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
,___DEF_LBL_PROC(___H_c_23_ptset_2d_remove,2,-1)
,___DEF_LBL_RET(___H_c_23_ptset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ptset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_reverse_2d_append_21_,"c#varset-reverse-append!",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H_c_23_varset_2d_reverse_2d_append_21_,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_reverse_2d_append_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_reverse_2d_append_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_wrap,"c#varset-wrap",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_wrap,1,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_wrap,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_unwrap,"c#varset-unwrap",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_unwrap,1,-1)
,___DEF_LBL_INTRO(___H_c_23_varset_2d_empty,"c#varset-empty",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_empty,0,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_empty,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_singleton,"c#varset-singleton",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_singleton,1,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_singleton,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_varset,"c#list->varset",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_varset,1,-1)
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
,___DEF_LBL_PROC(___H_c_23_varset_2d__3e_list,1,-1)
,___DEF_LBL_INTRO(___H_c_23_varset_2d_size,"c#varset-size",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_size,1,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_size,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_empty_3f_,"c#varset-empty?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_empty_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_varset_2d__3c_,"c#varset-<",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d__3c_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_varset_2d_member_3f_,"c#varset-member?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_member_3f_,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_member_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_adjoin,"c#varset-adjoin",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_adjoin,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_adjoin,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_remove,"c#varset-remove",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_remove,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_remove,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_equal_3f_,"c#varset-equal?",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_equal_3f_,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_equal_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_equal_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_difference,"c#varset-difference",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_difference,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_difference,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_union,"c#varset-union",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_union,2,-1)
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
,___DEF_LBL_PROC(___H_c_23_varset_2d_intersection,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersection,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_intersects_3f_,"c#varset-intersects?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_intersects_3f_,2,-1)
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_varset_2d_intersects_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_varset_2d_union_2d_multi,"c#varset-union-multi",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_varset_2d_union_2d_multi,1,-1)
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
,___DEF_LBL_PROC(___H_c_23_n_2d_ary,3,-1)
,___DEF_LBL_RET(___H_c_23_n_2d_ary,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_n_2d_ary,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_n_2d_ary,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_list_2d__3e_queue,"c#list->queue",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_list_2d__3e_queue,1,-1)
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_list_2d__3e_queue,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_queue_2d__3e_list,"c#queue->list",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d__3e_list,1,-1)
,___DEF_LBL_INTRO(___H_c_23_queue_2d_empty,"c#queue-empty",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_empty,0,-1)
,___DEF_LBL_RET(___H_c_23_queue_2d_empty,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_queue_2d_empty_3f_,"c#queue-empty?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_empty_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_queue_2d_get_21_,"c#queue-get!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_get_21_,1,-1)
,___DEF_LBL_RET(___H_c_23_queue_2d_get_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_queue_2d_put_21_,"c#queue-put!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_queue_2d_put_21_,2,-1)
,___DEF_LBL_RET(___H_c_23_queue_2d_put_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_throw_2d_to_2d_exception_2d_handler,0,___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_throw_2d_to_2d_exception_2d_handler,1,-1)
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

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20___utils,1)
___DEF_MOD_PRM(1,___G_c_23_append_2d_lists,6)
___DEF_MOD_PRM(59,___G_c_23_reverse_2d_append_21_,17)
___DEF_MOD_PRM(26,___G_c_23_list_2d_length,20)
___DEF_MOD_PRM(27,___G_c_23_make_2d_counter,24)
___DEF_MOD_PRM(14,___G_c_23_for_2d_each_2d_index,28)
___DEF_MOD_PRM(31,___G_c_23_map_2d_index,34)
___DEF_MOD_PRM(40,___G_c_23_pos_2d_in_2d_list,42)
___DEF_MOD_PRM(33,___G_c_23_object_2d_pos_2d_in_2d_list,46)
___DEF_MOD_PRM(69,___G_c_23_string_2d_pos_2d_in_2d_list,53)
___DEF_MOD_PRM(70,___G_c_23_take,60)
___DEF_MOD_PRM(12,___G_c_23_drop,67)
___DEF_MOD_PRM(39,___G_c_23_pair_2d_up,71)
___DEF_MOD_PRM(20,___G_c_23_last_2d_pair,78)
___DEF_MOD_PRM(19,___G_c_23_keep,82)
___DEF_MOD_PRM(13,___G_c_23_every_3f_,91)
___DEF_MOD_PRM(58,___G_c_23_remq,97)
___DEF_MOD_PRM(60,___G_c_23_sort_2d_list,103)
___DEF_MOD_PRM(25,___G_c_23_list_2d__3e_vect,124)
___DEF_MOD_PRM(92,___G_c_23_vect_2d__3e_list,131)
___DEF_MOD_PRM(23,___G_c_23_list_2d__3e_str,136)
___DEF_MOD_PRM(61,___G_c_23_str_2d__3e_list,143)
___DEF_MOD_PRM(55,___G_c_23_read_2d_line_2a_,148)
___DEF_MOD_PRM(30,___G_c_23_make_2d_stretchable_2d_vector,157)
___DEF_MOD_PRM(66,___G_c_23_stretchable_2d_vector_2d_length,160)
___DEF_MOD_PRM(67,___G_c_23_stretchable_2d_vector_2d_ref,162)
___DEF_MOD_PRM(68,___G_c_23_stretchable_2d_vector_2d_set_21_,164)
___DEF_MOD_PRM(62,___G_c_23_stretch_2d_vector,169)
___DEF_MOD_PRM(64,___G_c_23_stretchable_2d_vector_2d_copy,178)
___DEF_MOD_PRM(65,___G_c_23_stretchable_2d_vector_2d_for_2d_each,185)
___DEF_MOD_PRM(63,___G_c_23_stretchable_2d_vector_2d__3e_list,191)
___DEF_MOD_PRM(29,___G_c_23_make_2d_ordered_2d_table,196)
___DEF_MOD_PRM(37,___G_c_23_ordered_2d_table_2d_length,203)
___DEF_MOD_PRM(36,___G_c_23_ordered_2d_table_2d_index,205)
___DEF_MOD_PRM(38,___G_c_23_ordered_2d_table_2d_lookup,208)
___DEF_MOD_PRM(35,___G_c_23_ordered_2d_table_2d_enter,215)
___DEF_MOD_PRM(34,___G_c_23_ordered_2d_table_2d__3e_list,223)
___DEF_MOD_PRM(2,___G_c_23_bits_2d_and,230)
___DEF_MOD_PRM(3,___G_c_23_bits_2d_or,237)
___DEF_MOD_PRM(4,___G_c_23_bits_2d_shl,244)
___DEF_MOD_PRM(5,___G_c_23_bits_2d_shr,248)
___DEF_MOD_PRM(94,___G_c_23_with_2d_exception_2d_handling,252)
___DEF_MOD_PRM(7,___G_c_23_compiler_2d_error,259)
___DEF_MOD_PRM(10,___G_c_23_compiler_2d_user_2d_error,271)
___DEF_MOD_PRM(11,___G_c_23_compiler_2d_user_2d_warning,285)
___DEF_MOD_PRM(8,___G_c_23_compiler_2d_internal_2d_error,298)
___DEF_MOD_PRM(9,___G_c_23_compiler_2d_limitation_2d_error,312)
___DEF_MOD_PRM(6,___G_c_23_compiler_2d_abort,326)
___DEF_MOD_PRM(28,___G_c_23_make_2d_gnode,329)
___DEF_MOD_PRM(17,___G_c_23_gnode_2d_var,332)
___DEF_MOD_PRM(15,___G_c_23_gnode_2d_depvars,334)
___DEF_MOD_PRM(73,___G_c_23_transitive_2d_closure,336)
___DEF_MOD_PRM(16,___G_c_23_gnode_2d_find_2d_depvars,366)
___DEF_MOD_PRM(18,___G_c_23_gnodes_2d_remove,374)
___DEF_MOD_PRM(72,___G_c_23_topological_2d_sort,383)
___DEF_MOD_PRM(57,___G_c_23_remove_2d_no_2d_depvars,402)
___DEF_MOD_PRM(56,___G_c_23_remove_2d_cycle,412)
___DEF_MOD_PRM(43,___G_c_23_ptset_2d_empty,426)
___DEF_MOD_PRM(21,___G_c_23_list_2d__3e_ptset,429)
___DEF_MOD_PRM(41,___G_c_23_ptset_2d__3e_list,437)
___DEF_MOD_PRM(49,___G_c_23_ptset_2d_size,442)
___DEF_MOD_PRM(45,___G_c_23_ptset_2d_empty_3f_,453)
___DEF_MOD_PRM(47,___G_c_23_ptset_2d_member_3f_,456)
___DEF_MOD_PRM(42,___G_c_23_ptset_2d_adjoin,460)
___DEF_MOD_PRM(46,___G_c_23_ptset_2d_every_3f_,467)
___DEF_MOD_PRM(48,___G_c_23_ptset_2d_remove,479)
___DEF_MOD_PRM(85,___G_c_23_varset_2d_reverse_2d_append_21_,483)
___DEF_MOD_PRM(91,___G_c_23_varset_2d_wrap,487)
___DEF_MOD_PRM(90,___G_c_23_varset_2d_unwrap,490)
___DEF_MOD_PRM(78,___G_c_23_varset_2d_empty,492)
___DEF_MOD_PRM(86,___G_c_23_varset_2d_singleton,495)
___DEF_MOD_PRM(24,___G_c_23_list_2d__3e_varset,498)
___DEF_MOD_PRM(75,___G_c_23_varset_2d__3e_list,512)
___DEF_MOD_PRM(87,___G_c_23_varset_2d_size,514)
___DEF_MOD_PRM(79,___G_c_23_varset_2d_empty_3f_,517)
___DEF_MOD_PRM(74,___G_c_23_varset_2d__3c_,519)
___DEF_MOD_PRM(83,___G_c_23_varset_2d_member_3f_,521)
___DEF_MOD_PRM(76,___G_c_23_varset_2d_adjoin,530)
___DEF_MOD_PRM(84,___G_c_23_varset_2d_remove,540)
___DEF_MOD_PRM(80,___G_c_23_varset_2d_equal_3f_,549)
___DEF_MOD_PRM(77,___G_c_23_varset_2d_difference,553)
___DEF_MOD_PRM(88,___G_c_23_varset_2d_union,563)
___DEF_MOD_PRM(81,___G_c_23_varset_2d_intersection,576)
___DEF_MOD_PRM(82,___G_c_23_varset_2d_intersects_3f_,586)
___DEF_MOD_PRM(89,___G_c_23_varset_2d_union_2d_multi,593)
___DEF_MOD_PRM(32,___G_c_23_n_2d_ary,604)
___DEF_MOD_PRM(22,___G_c_23_list_2d__3e_queue,609)
___DEF_MOD_PRM(50,___G_c_23_queue_2d__3e_list,615)
___DEF_MOD_PRM(51,___G_c_23_queue_2d_empty,617)
___DEF_MOD_PRM(52,___G_c_23_queue_2d_empty_3f_,620)
___DEF_MOD_PRM(53,___G_c_23_queue_2d_get_21_,622)
___DEF_MOD_PRM(54,___G_c_23_queue_2d_put_21_,625)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___utils,1)
___DEF_MOD_GLO(1,___G_c_23_append_2d_lists,6)
___DEF_MOD_GLO(59,___G_c_23_reverse_2d_append_21_,17)
___DEF_MOD_GLO(26,___G_c_23_list_2d_length,20)
___DEF_MOD_GLO(27,___G_c_23_make_2d_counter,24)
___DEF_MOD_GLO(14,___G_c_23_for_2d_each_2d_index,28)
___DEF_MOD_GLO(31,___G_c_23_map_2d_index,34)
___DEF_MOD_GLO(40,___G_c_23_pos_2d_in_2d_list,42)
___DEF_MOD_GLO(33,___G_c_23_object_2d_pos_2d_in_2d_list,46)
___DEF_MOD_GLO(69,___G_c_23_string_2d_pos_2d_in_2d_list,53)
___DEF_MOD_GLO(70,___G_c_23_take,60)
___DEF_MOD_GLO(12,___G_c_23_drop,67)
___DEF_MOD_GLO(39,___G_c_23_pair_2d_up,71)
___DEF_MOD_GLO(20,___G_c_23_last_2d_pair,78)
___DEF_MOD_GLO(19,___G_c_23_keep,82)
___DEF_MOD_GLO(13,___G_c_23_every_3f_,91)
___DEF_MOD_GLO(58,___G_c_23_remq,97)
___DEF_MOD_GLO(60,___G_c_23_sort_2d_list,103)
___DEF_MOD_GLO(25,___G_c_23_list_2d__3e_vect,124)
___DEF_MOD_GLO(92,___G_c_23_vect_2d__3e_list,131)
___DEF_MOD_GLO(23,___G_c_23_list_2d__3e_str,136)
___DEF_MOD_GLO(61,___G_c_23_str_2d__3e_list,143)
___DEF_MOD_GLO(55,___G_c_23_read_2d_line_2a_,148)
___DEF_MOD_GLO(30,___G_c_23_make_2d_stretchable_2d_vector,157)
___DEF_MOD_GLO(66,___G_c_23_stretchable_2d_vector_2d_length,160)
___DEF_MOD_GLO(67,___G_c_23_stretchable_2d_vector_2d_ref,162)
___DEF_MOD_GLO(68,___G_c_23_stretchable_2d_vector_2d_set_21_,164)
___DEF_MOD_GLO(62,___G_c_23_stretch_2d_vector,169)
___DEF_MOD_GLO(64,___G_c_23_stretchable_2d_vector_2d_copy,178)
___DEF_MOD_GLO(65,___G_c_23_stretchable_2d_vector_2d_for_2d_each,185)
___DEF_MOD_GLO(63,___G_c_23_stretchable_2d_vector_2d__3e_list,191)
___DEF_MOD_GLO(29,___G_c_23_make_2d_ordered_2d_table,196)
___DEF_MOD_GLO(37,___G_c_23_ordered_2d_table_2d_length,203)
___DEF_MOD_GLO(36,___G_c_23_ordered_2d_table_2d_index,205)
___DEF_MOD_GLO(38,___G_c_23_ordered_2d_table_2d_lookup,208)
___DEF_MOD_GLO(35,___G_c_23_ordered_2d_table_2d_enter,215)
___DEF_MOD_GLO(34,___G_c_23_ordered_2d_table_2d__3e_list,223)
___DEF_MOD_GLO(2,___G_c_23_bits_2d_and,230)
___DEF_MOD_GLO(3,___G_c_23_bits_2d_or,237)
___DEF_MOD_GLO(4,___G_c_23_bits_2d_shl,244)
___DEF_MOD_GLO(5,___G_c_23_bits_2d_shr,248)
___DEF_MOD_GLO(94,___G_c_23_with_2d_exception_2d_handling,252)
___DEF_MOD_GLO(7,___G_c_23_compiler_2d_error,259)
___DEF_MOD_GLO(10,___G_c_23_compiler_2d_user_2d_error,271)
___DEF_MOD_GLO(11,___G_c_23_compiler_2d_user_2d_warning,285)
___DEF_MOD_GLO(8,___G_c_23_compiler_2d_internal_2d_error,298)
___DEF_MOD_GLO(9,___G_c_23_compiler_2d_limitation_2d_error,312)
___DEF_MOD_GLO(6,___G_c_23_compiler_2d_abort,326)
___DEF_MOD_GLO(28,___G_c_23_make_2d_gnode,329)
___DEF_MOD_GLO(17,___G_c_23_gnode_2d_var,332)
___DEF_MOD_GLO(15,___G_c_23_gnode_2d_depvars,334)
___DEF_MOD_GLO(73,___G_c_23_transitive_2d_closure,336)
___DEF_MOD_GLO(16,___G_c_23_gnode_2d_find_2d_depvars,366)
___DEF_MOD_GLO(18,___G_c_23_gnodes_2d_remove,374)
___DEF_MOD_GLO(72,___G_c_23_topological_2d_sort,383)
___DEF_MOD_GLO(57,___G_c_23_remove_2d_no_2d_depvars,402)
___DEF_MOD_GLO(56,___G_c_23_remove_2d_cycle,412)
___DEF_MOD_GLO(43,___G_c_23_ptset_2d_empty,426)
___DEF_MOD_GLO(21,___G_c_23_list_2d__3e_ptset,429)
___DEF_MOD_GLO(41,___G_c_23_ptset_2d__3e_list,437)
___DEF_MOD_GLO(49,___G_c_23_ptset_2d_size,442)
___DEF_MOD_GLO(45,___G_c_23_ptset_2d_empty_3f_,453)
___DEF_MOD_GLO(47,___G_c_23_ptset_2d_member_3f_,456)
___DEF_MOD_GLO(42,___G_c_23_ptset_2d_adjoin,460)
___DEF_MOD_GLO(46,___G_c_23_ptset_2d_every_3f_,467)
___DEF_MOD_GLO(48,___G_c_23_ptset_2d_remove,479)
___DEF_MOD_GLO(85,___G_c_23_varset_2d_reverse_2d_append_21_,483)
___DEF_MOD_GLO(91,___G_c_23_varset_2d_wrap,487)
___DEF_MOD_GLO(90,___G_c_23_varset_2d_unwrap,490)
___DEF_MOD_GLO(78,___G_c_23_varset_2d_empty,492)
___DEF_MOD_GLO(86,___G_c_23_varset_2d_singleton,495)
___DEF_MOD_GLO(24,___G_c_23_list_2d__3e_varset,498)
___DEF_MOD_GLO(75,___G_c_23_varset_2d__3e_list,512)
___DEF_MOD_GLO(87,___G_c_23_varset_2d_size,514)
___DEF_MOD_GLO(79,___G_c_23_varset_2d_empty_3f_,517)
___DEF_MOD_GLO(74,___G_c_23_varset_2d__3c_,519)
___DEF_MOD_GLO(83,___G_c_23_varset_2d_member_3f_,521)
___DEF_MOD_GLO(76,___G_c_23_varset_2d_adjoin,530)
___DEF_MOD_GLO(84,___G_c_23_varset_2d_remove,540)
___DEF_MOD_GLO(80,___G_c_23_varset_2d_equal_3f_,549)
___DEF_MOD_GLO(77,___G_c_23_varset_2d_difference,553)
___DEF_MOD_GLO(88,___G_c_23_varset_2d_union,563)
___DEF_MOD_GLO(81,___G_c_23_varset_2d_intersection,576)
___DEF_MOD_GLO(82,___G_c_23_varset_2d_intersects_3f_,586)
___DEF_MOD_GLO(89,___G_c_23_varset_2d_union_2d_multi,593)
___DEF_MOD_GLO(32,___G_c_23_n_2d_ary,604)
___DEF_MOD_GLO(22,___G_c_23_list_2d__3e_queue,609)
___DEF_MOD_GLO(50,___G_c_23_queue_2d__3e_list,615)
___DEF_MOD_GLO(51,___G_c_23_queue_2d_empty,617)
___DEF_MOD_GLO(52,___G_c_23_queue_2d_empty_3f_,620)
___DEF_MOD_GLO(53,___G_c_23_queue_2d_get_21_,622)
___DEF_MOD_GLO(54,___G_c_23_queue_2d_put_21_,625)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___utils,"_utils")
___DEF_MOD_KEY(0,___K_test,"test")
___END_MOD_SYM_KEY

#endif
