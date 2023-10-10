#ifdef ___LINKER_INFO
; File: "_env.c", produced by Gambit v4.9.5
(
409005
(C)
"_env"
("_env")
()
(("_env"))
( #|*/"*/"symbols|#
"_env"
"_env#"
"c#boolean-decl"
"c#declaration-value"
"c#define-boolean-decl"
"c#define-flag-decl"
"c#define-namable-boolean-decl"
"c#define-namable-decl"
"c#define-parameterized-decl"
"c#env-decl-ref"
"c#env-decl-set"
"c#env-declare"
"c#env-define-var"
"c#env-externals-ref"
"c#env-frame"
"c#env-global-env"
"c#env-global-variables"
"c#env-lookup"
"c#env-lookup-global-var"
"c#env-lookup-macro"
"c#env-lookup-var"
"c#env-macro"
"c#env-macros-ref"
"c#env-macros-set"
"c#env-namespace"
"c#env-namespace-lookup"
"c#env-namespace-lookup-both"
"c#env-namespace-ref"
"c#env-namespace-set"
"c#env-new-var!"
"c#env-parent-ref"
"c#env-vars-ref"
"c#env-vars-set!"
"c#env.begin!"
"c#env.end!"
"c#flag-decl"
"c#full-name?"
"c#make-full-name"
"c#make-temp-var"
"c#make-var"
"c#namable-boolean-decl"
"c#namable-decl"
"c#namespace-valid?"
"c#parameterized-decl"
"c#resize-var-list"
"c#var-bound"
"c#var-bound-set!"
"c#var-boxed?"
"c#var-boxed?-set!"
"c#var-clone"
"c#var-clone-set!"
"c#var-constant"
"c#var-constant-set!"
"c#var-info"
"c#var-info-set!"
"c#var-lexical-level"
"c#var-name"
"c#var-name-set!"
"c#var-refs"
"c#var-refs-set!"
"c#var-sets"
"c#var-sets-set!"
"c#var-source"
"c#var-source-set!"
"c#var-stamp"
"c#var-stamp-set!"
"c#var-temp?"
"c#var-temp?-set!"
"c#var?"
"closure-env"
"ret"
"var-tag"
) #|*/"*/"symbols|#
( #|*/"*/"keywords|#
) #|*/"*/"keywords|#
( #|*/"*/"globals-s-d|#
"_env#"
"c#boolean-declarations"
"c#empty-var"
"c#env-decl-set"
"c#env-frame"
"c#env-global-env"
"c#env-lookup"
"c#env-macros-set"
"c#env-namespace-lookup"
"c#env-namespace-lookup-both"
"c#env-namespace-set"
"c#env-new-var!"
"c#env-vars-ref"
"c#flag-declarations"
"c#full-name?"
"c#make-full-name"
"c#make-temp-var"
"c#make-var"
"c#namable-boolean-declarations"
"c#namable-declarations"
"c#next-var-stamp"
"c#parameterized-declarations"
"c#ret-var"
"c#var-tag"
"c#var?"
) #|*/"*/"globals-s-d|#
( #|*/"*/"globals-s-nd|#
"c#boolean-decl"
"c#closure-env-var"
"c#declaration-value"
"c#define-boolean-decl"
"c#define-flag-decl"
"c#define-namable-boolean-decl"
"c#define-namable-decl"
"c#define-parameterized-decl"
"c#env-decl-ref"
"c#env-declare"
"c#env-define-var"
"c#env-externals-ref"
"c#env-global-variables"
"c#env-lookup-global-var"
"c#env-lookup-macro"
"c#env-lookup-var"
"c#env-macro"
"c#env-macros-ref"
"c#env-namespace"
"c#env-namespace-ref"
"c#env-parent-ref"
"c#env-vars-set!"
"c#env.begin!"
"c#env.end!"
"c#flag-decl"
"c#make-global-environment"
"c#namable-boolean-decl"
"c#namable-decl"
"c#namespace-valid?"
"c#parameterized-decl"
"c#resize-var-list"
"c#ret-var-set"
"c#var-bound"
"c#var-bound-set!"
"c#var-boxed?"
"c#var-boxed?-set!"
"c#var-clone"
"c#var-clone-set!"
"c#var-constant"
"c#var-constant-set!"
"c#var-info"
"c#var-info-set!"
"c#var-lexical-level"
"c#var-name"
"c#var-name-set!"
"c#var-refs"
"c#var-refs-set!"
"c#var-sets"
"c#var-sets-set!"
"c#var-source"
"c#var-source-set!"
"c#var-stamp"
"c#var-stamp-set!"
"c#var-temp?"
"c#var-temp?-set!"
) #|*/"*/"globals-s-nd|#
( #|*/"*/"globals-ns|#
"##string->symbol"
"##string-append"
"##symbol->string"
"c#compiler-internal-error"
"c#make-counter"
"c#node-parent"
"c#prc?"
"c#pt-syntax-error"
"c#ptset-empty"
"c#varset-singleton"
"make-table"
"table-set!"
) #|*/"*/"globals-ns|#
( #|*/"*/"meta-info|#
) #|*/"*/"meta-info|#
)
#else
#define ___VERSION 409005
#define ___MODULE_NAME "_env"
#define ___LINKER_ID ___LNK___env
#define ___MH_PROC ___H___env
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 72
#define ___GLOCOUNT 92
#define ___SUPCOUNT 80
#define ___SUBCOUNT 6
#define ___LBLCOUNT 271
#define ___OFDCOUNT 4
#define ___MODDESCR ___REF_SUB(3)
#include "gambit.h"

___NEED_SYM(___S___env)
___NEED_SYM(___S___env_23_)
___NEED_SYM(___S_c_23_boolean_2d_decl)
___NEED_SYM(___S_c_23_declaration_2d_value)
___NEED_SYM(___S_c_23_define_2d_boolean_2d_decl)
___NEED_SYM(___S_c_23_define_2d_flag_2d_decl)
___NEED_SYM(___S_c_23_define_2d_namable_2d_boolean_2d_decl)
___NEED_SYM(___S_c_23_define_2d_namable_2d_decl)
___NEED_SYM(___S_c_23_define_2d_parameterized_2d_decl)
___NEED_SYM(___S_c_23_env_2d_decl_2d_ref)
___NEED_SYM(___S_c_23_env_2d_decl_2d_set)
___NEED_SYM(___S_c_23_env_2d_declare)
___NEED_SYM(___S_c_23_env_2d_define_2d_var)
___NEED_SYM(___S_c_23_env_2d_externals_2d_ref)
___NEED_SYM(___S_c_23_env_2d_frame)
___NEED_SYM(___S_c_23_env_2d_global_2d_env)
___NEED_SYM(___S_c_23_env_2d_global_2d_variables)
___NEED_SYM(___S_c_23_env_2d_lookup)
___NEED_SYM(___S_c_23_env_2d_lookup_2d_global_2d_var)
___NEED_SYM(___S_c_23_env_2d_lookup_2d_macro)
___NEED_SYM(___S_c_23_env_2d_lookup_2d_var)
___NEED_SYM(___S_c_23_env_2d_macro)
___NEED_SYM(___S_c_23_env_2d_macros_2d_ref)
___NEED_SYM(___S_c_23_env_2d_macros_2d_set)
___NEED_SYM(___S_c_23_env_2d_namespace)
___NEED_SYM(___S_c_23_env_2d_namespace_2d_lookup)
___NEED_SYM(___S_c_23_env_2d_namespace_2d_lookup_2d_both)
___NEED_SYM(___S_c_23_env_2d_namespace_2d_ref)
___NEED_SYM(___S_c_23_env_2d_namespace_2d_set)
___NEED_SYM(___S_c_23_env_2d_new_2d_var_21_)
___NEED_SYM(___S_c_23_env_2d_parent_2d_ref)
___NEED_SYM(___S_c_23_env_2d_vars_2d_ref)
___NEED_SYM(___S_c_23_env_2d_vars_2d_set_21_)
___NEED_SYM(___S_c_23_env_2e_begin_21_)
___NEED_SYM(___S_c_23_env_2e_end_21_)
___NEED_SYM(___S_c_23_flag_2d_decl)
___NEED_SYM(___S_c_23_full_2d_name_3f_)
___NEED_SYM(___S_c_23_make_2d_full_2d_name)
___NEED_SYM(___S_c_23_make_2d_temp_2d_var)
___NEED_SYM(___S_c_23_make_2d_var)
___NEED_SYM(___S_c_23_namable_2d_boolean_2d_decl)
___NEED_SYM(___S_c_23_namable_2d_decl)
___NEED_SYM(___S_c_23_namespace_2d_valid_3f_)
___NEED_SYM(___S_c_23_parameterized_2d_decl)
___NEED_SYM(___S_c_23_resize_2d_var_2d_list)
___NEED_SYM(___S_c_23_var_2d_bound)
___NEED_SYM(___S_c_23_var_2d_bound_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_boxed_3f_)
___NEED_SYM(___S_c_23_var_2d_boxed_3f__2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_clone)
___NEED_SYM(___S_c_23_var_2d_clone_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_constant)
___NEED_SYM(___S_c_23_var_2d_constant_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_info)
___NEED_SYM(___S_c_23_var_2d_info_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_lexical_2d_level)
___NEED_SYM(___S_c_23_var_2d_name)
___NEED_SYM(___S_c_23_var_2d_name_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_refs)
___NEED_SYM(___S_c_23_var_2d_refs_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_sets)
___NEED_SYM(___S_c_23_var_2d_sets_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_source)
___NEED_SYM(___S_c_23_var_2d_source_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_stamp)
___NEED_SYM(___S_c_23_var_2d_stamp_2d_set_21_)
___NEED_SYM(___S_c_23_var_2d_temp_3f_)
___NEED_SYM(___S_c_23_var_2d_temp_3f__2d_set_21_)
___NEED_SYM(___S_c_23_var_3f_)
___NEED_SYM(___S_closure_2d_env)
___NEED_SYM(___S_ret)
___NEED_SYM(___S_var_2d_tag)

___NEED_GLO(___G__23__23_string_2d__3e_symbol)
___NEED_GLO(___G__23__23_string_2d_append)
___NEED_GLO(___G__23__23_symbol_2d__3e_string)
___NEED_GLO(___G___env_23_)
___NEED_GLO(___G_c_23_boolean_2d_decl)
___NEED_GLO(___G_c_23_boolean_2d_declarations)
___NEED_GLO(___G_c_23_closure_2d_env_2d_var)
___NEED_GLO(___G_c_23_compiler_2d_internal_2d_error)
___NEED_GLO(___G_c_23_declaration_2d_value)
___NEED_GLO(___G_c_23_define_2d_boolean_2d_decl)
___NEED_GLO(___G_c_23_define_2d_flag_2d_decl)
___NEED_GLO(___G_c_23_define_2d_namable_2d_boolean_2d_decl)
___NEED_GLO(___G_c_23_define_2d_namable_2d_decl)
___NEED_GLO(___G_c_23_define_2d_parameterized_2d_decl)
___NEED_GLO(___G_c_23_empty_2d_var)
___NEED_GLO(___G_c_23_env_2d_decl_2d_ref)
___NEED_GLO(___G_c_23_env_2d_decl_2d_set)
___NEED_GLO(___G_c_23_env_2d_declare)
___NEED_GLO(___G_c_23_env_2d_define_2d_var)
___NEED_GLO(___G_c_23_env_2d_externals_2d_ref)
___NEED_GLO(___G_c_23_env_2d_frame)
___NEED_GLO(___G_c_23_env_2d_global_2d_env)
___NEED_GLO(___G_c_23_env_2d_global_2d_variables)
___NEED_GLO(___G_c_23_env_2d_lookup)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_global_2d_var)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_macro)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_var)
___NEED_GLO(___G_c_23_env_2d_macro)
___NEED_GLO(___G_c_23_env_2d_macros_2d_ref)
___NEED_GLO(___G_c_23_env_2d_macros_2d_set)
___NEED_GLO(___G_c_23_env_2d_namespace)
___NEED_GLO(___G_c_23_env_2d_namespace_2d_lookup)
___NEED_GLO(___G_c_23_env_2d_namespace_2d_lookup_2d_both)
___NEED_GLO(___G_c_23_env_2d_namespace_2d_ref)
___NEED_GLO(___G_c_23_env_2d_namespace_2d_set)
___NEED_GLO(___G_c_23_env_2d_new_2d_var_21_)
___NEED_GLO(___G_c_23_env_2d_parent_2d_ref)
___NEED_GLO(___G_c_23_env_2d_vars_2d_ref)
___NEED_GLO(___G_c_23_env_2d_vars_2d_set_21_)
___NEED_GLO(___G_c_23_env_2e_begin_21_)
___NEED_GLO(___G_c_23_env_2e_end_21_)
___NEED_GLO(___G_c_23_flag_2d_decl)
___NEED_GLO(___G_c_23_flag_2d_declarations)
___NEED_GLO(___G_c_23_full_2d_name_3f_)
___NEED_GLO(___G_c_23_make_2d_counter)
___NEED_GLO(___G_c_23_make_2d_full_2d_name)
___NEED_GLO(___G_c_23_make_2d_global_2d_environment)
___NEED_GLO(___G_c_23_make_2d_temp_2d_var)
___NEED_GLO(___G_c_23_make_2d_var)
___NEED_GLO(___G_c_23_namable_2d_boolean_2d_decl)
___NEED_GLO(___G_c_23_namable_2d_boolean_2d_declarations)
___NEED_GLO(___G_c_23_namable_2d_decl)
___NEED_GLO(___G_c_23_namable_2d_declarations)
___NEED_GLO(___G_c_23_namespace_2d_valid_3f_)
___NEED_GLO(___G_c_23_next_2d_var_2d_stamp)
___NEED_GLO(___G_c_23_node_2d_parent)
___NEED_GLO(___G_c_23_parameterized_2d_decl)
___NEED_GLO(___G_c_23_parameterized_2d_declarations)
___NEED_GLO(___G_c_23_prc_3f_)
___NEED_GLO(___G_c_23_pt_2d_syntax_2d_error)
___NEED_GLO(___G_c_23_ptset_2d_empty)
___NEED_GLO(___G_c_23_resize_2d_var_2d_list)
___NEED_GLO(___G_c_23_ret_2d_var)
___NEED_GLO(___G_c_23_ret_2d_var_2d_set)
___NEED_GLO(___G_c_23_var_2d_bound)
___NEED_GLO(___G_c_23_var_2d_bound_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_boxed_3f_)
___NEED_GLO(___G_c_23_var_2d_boxed_3f__2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_clone)
___NEED_GLO(___G_c_23_var_2d_clone_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_constant)
___NEED_GLO(___G_c_23_var_2d_constant_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_info)
___NEED_GLO(___G_c_23_var_2d_info_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_lexical_2d_level)
___NEED_GLO(___G_c_23_var_2d_name)
___NEED_GLO(___G_c_23_var_2d_name_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_refs)
___NEED_GLO(___G_c_23_var_2d_refs_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_sets)
___NEED_GLO(___G_c_23_var_2d_sets_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_source)
___NEED_GLO(___G_c_23_var_2d_source_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_stamp)
___NEED_GLO(___G_c_23_var_2d_stamp_2d_set_21_)
___NEED_GLO(___G_c_23_var_2d_tag)
___NEED_GLO(___G_c_23_var_2d_temp_3f_)
___NEED_GLO(___G_c_23_var_2d_temp_3f__2d_set_21_)
___NEED_GLO(___G_c_23_var_3f_)
___NEED_GLO(___G_c_23_varset_2d_singleton)
___NEED_GLO(___G_make_2d_table)
___NEED_GLO(___G_table_2d_set_21_)

___BEGIN_SYM
___DEF_SYM(0,___S___env,"_env")
___DEF_SYM(1,___S___env_23_,"_env#")
___DEF_SYM(2,___S_c_23_boolean_2d_decl,"c#boolean-decl")
___DEF_SYM(3,___S_c_23_declaration_2d_value,"c#declaration-value")
___DEF_SYM(4,___S_c_23_define_2d_boolean_2d_decl,"c#define-boolean-decl")
___DEF_SYM(5,___S_c_23_define_2d_flag_2d_decl,"c#define-flag-decl")
___DEF_SYM(6,___S_c_23_define_2d_namable_2d_boolean_2d_decl,"c#define-namable-boolean-decl")

___DEF_SYM(7,___S_c_23_define_2d_namable_2d_decl,"c#define-namable-decl")
___DEF_SYM(8,___S_c_23_define_2d_parameterized_2d_decl,"c#define-parameterized-decl")
___DEF_SYM(9,___S_c_23_env_2d_decl_2d_ref,"c#env-decl-ref")
___DEF_SYM(10,___S_c_23_env_2d_decl_2d_set,"c#env-decl-set")
___DEF_SYM(11,___S_c_23_env_2d_declare,"c#env-declare")
___DEF_SYM(12,___S_c_23_env_2d_define_2d_var,"c#env-define-var")
___DEF_SYM(13,___S_c_23_env_2d_externals_2d_ref,"c#env-externals-ref")
___DEF_SYM(14,___S_c_23_env_2d_frame,"c#env-frame")
___DEF_SYM(15,___S_c_23_env_2d_global_2d_env,"c#env-global-env")
___DEF_SYM(16,___S_c_23_env_2d_global_2d_variables,"c#env-global-variables")
___DEF_SYM(17,___S_c_23_env_2d_lookup,"c#env-lookup")
___DEF_SYM(18,___S_c_23_env_2d_lookup_2d_global_2d_var,"c#env-lookup-global-var")
___DEF_SYM(19,___S_c_23_env_2d_lookup_2d_macro,"c#env-lookup-macro")
___DEF_SYM(20,___S_c_23_env_2d_lookup_2d_var,"c#env-lookup-var")
___DEF_SYM(21,___S_c_23_env_2d_macro,"c#env-macro")
___DEF_SYM(22,___S_c_23_env_2d_macros_2d_ref,"c#env-macros-ref")
___DEF_SYM(23,___S_c_23_env_2d_macros_2d_set,"c#env-macros-set")
___DEF_SYM(24,___S_c_23_env_2d_namespace,"c#env-namespace")
___DEF_SYM(25,___S_c_23_env_2d_namespace_2d_lookup,"c#env-namespace-lookup")
___DEF_SYM(26,___S_c_23_env_2d_namespace_2d_lookup_2d_both,"c#env-namespace-lookup-both")
___DEF_SYM(27,___S_c_23_env_2d_namespace_2d_ref,"c#env-namespace-ref")
___DEF_SYM(28,___S_c_23_env_2d_namespace_2d_set,"c#env-namespace-set")
___DEF_SYM(29,___S_c_23_env_2d_new_2d_var_21_,"c#env-new-var!")
___DEF_SYM(30,___S_c_23_env_2d_parent_2d_ref,"c#env-parent-ref")
___DEF_SYM(31,___S_c_23_env_2d_vars_2d_ref,"c#env-vars-ref")
___DEF_SYM(32,___S_c_23_env_2d_vars_2d_set_21_,"c#env-vars-set!")
___DEF_SYM(33,___S_c_23_env_2e_begin_21_,"c#env.begin!")
___DEF_SYM(34,___S_c_23_env_2e_end_21_,"c#env.end!")
___DEF_SYM(35,___S_c_23_flag_2d_decl,"c#flag-decl")
___DEF_SYM(36,___S_c_23_full_2d_name_3f_,"c#full-name?")
___DEF_SYM(37,___S_c_23_make_2d_full_2d_name,"c#make-full-name")
___DEF_SYM(38,___S_c_23_make_2d_temp_2d_var,"c#make-temp-var")
___DEF_SYM(39,___S_c_23_make_2d_var,"c#make-var")
___DEF_SYM(40,___S_c_23_namable_2d_boolean_2d_decl,"c#namable-boolean-decl")
___DEF_SYM(41,___S_c_23_namable_2d_decl,"c#namable-decl")
___DEF_SYM(42,___S_c_23_namespace_2d_valid_3f_,"c#namespace-valid?")
___DEF_SYM(43,___S_c_23_parameterized_2d_decl,"c#parameterized-decl")
___DEF_SYM(44,___S_c_23_resize_2d_var_2d_list,"c#resize-var-list")
___DEF_SYM(45,___S_c_23_var_2d_bound,"c#var-bound")
___DEF_SYM(46,___S_c_23_var_2d_bound_2d_set_21_,"c#var-bound-set!")
___DEF_SYM(47,___S_c_23_var_2d_boxed_3f_,"c#var-boxed?")
___DEF_SYM(48,___S_c_23_var_2d_boxed_3f__2d_set_21_,"c#var-boxed?-set!")
___DEF_SYM(49,___S_c_23_var_2d_clone,"c#var-clone")
___DEF_SYM(50,___S_c_23_var_2d_clone_2d_set_21_,"c#var-clone-set!")
___DEF_SYM(51,___S_c_23_var_2d_constant,"c#var-constant")
___DEF_SYM(52,___S_c_23_var_2d_constant_2d_set_21_,"c#var-constant-set!")
___DEF_SYM(53,___S_c_23_var_2d_info,"c#var-info")
___DEF_SYM(54,___S_c_23_var_2d_info_2d_set_21_,"c#var-info-set!")
___DEF_SYM(55,___S_c_23_var_2d_lexical_2d_level,"c#var-lexical-level")
___DEF_SYM(56,___S_c_23_var_2d_name,"c#var-name")
___DEF_SYM(57,___S_c_23_var_2d_name_2d_set_21_,"c#var-name-set!")
___DEF_SYM(58,___S_c_23_var_2d_refs,"c#var-refs")
___DEF_SYM(59,___S_c_23_var_2d_refs_2d_set_21_,"c#var-refs-set!")
___DEF_SYM(60,___S_c_23_var_2d_sets,"c#var-sets")
___DEF_SYM(61,___S_c_23_var_2d_sets_2d_set_21_,"c#var-sets-set!")
___DEF_SYM(62,___S_c_23_var_2d_source,"c#var-source")
___DEF_SYM(63,___S_c_23_var_2d_source_2d_set_21_,"c#var-source-set!")
___DEF_SYM(64,___S_c_23_var_2d_stamp,"c#var-stamp")
___DEF_SYM(65,___S_c_23_var_2d_stamp_2d_set_21_,"c#var-stamp-set!")
___DEF_SYM(66,___S_c_23_var_2d_temp_3f_,"c#var-temp?")
___DEF_SYM(67,___S_c_23_var_2d_temp_3f__2d_set_21_,"c#var-temp?-set!")
___DEF_SYM(68,___S_c_23_var_3f_,"c#var?")
___DEF_SYM(69,___S_closure_2d_env,"closure-env")
___DEF_SYM(70,___S_ret,"ret")
___DEF_SYM(71,___S_var_2d_tag,"var-tag")
___END_SYM

#define ___SYM___env ___SYM(0,___S___env)
#define ___SYM___env_23_ ___SYM(1,___S___env_23_)
#define ___SYM_c_23_boolean_2d_decl ___SYM(2,___S_c_23_boolean_2d_decl)
#define ___SYM_c_23_declaration_2d_value ___SYM(3,___S_c_23_declaration_2d_value)
#define ___SYM_c_23_define_2d_boolean_2d_decl ___SYM(4,___S_c_23_define_2d_boolean_2d_decl)
#define ___SYM_c_23_define_2d_flag_2d_decl ___SYM(5,___S_c_23_define_2d_flag_2d_decl)
#define ___SYM_c_23_define_2d_namable_2d_boolean_2d_decl ___SYM(6,___S_c_23_define_2d_namable_2d_boolean_2d_decl)
#define ___SYM_c_23_define_2d_namable_2d_decl ___SYM(7,___S_c_23_define_2d_namable_2d_decl)
#define ___SYM_c_23_define_2d_parameterized_2d_decl ___SYM(8,___S_c_23_define_2d_parameterized_2d_decl)
#define ___SYM_c_23_env_2d_decl_2d_ref ___SYM(9,___S_c_23_env_2d_decl_2d_ref)
#define ___SYM_c_23_env_2d_decl_2d_set ___SYM(10,___S_c_23_env_2d_decl_2d_set)
#define ___SYM_c_23_env_2d_declare ___SYM(11,___S_c_23_env_2d_declare)
#define ___SYM_c_23_env_2d_define_2d_var ___SYM(12,___S_c_23_env_2d_define_2d_var)
#define ___SYM_c_23_env_2d_externals_2d_ref ___SYM(13,___S_c_23_env_2d_externals_2d_ref)
#define ___SYM_c_23_env_2d_frame ___SYM(14,___S_c_23_env_2d_frame)
#define ___SYM_c_23_env_2d_global_2d_env ___SYM(15,___S_c_23_env_2d_global_2d_env)
#define ___SYM_c_23_env_2d_global_2d_variables ___SYM(16,___S_c_23_env_2d_global_2d_variables)
#define ___SYM_c_23_env_2d_lookup ___SYM(17,___S_c_23_env_2d_lookup)
#define ___SYM_c_23_env_2d_lookup_2d_global_2d_var ___SYM(18,___S_c_23_env_2d_lookup_2d_global_2d_var)
#define ___SYM_c_23_env_2d_lookup_2d_macro ___SYM(19,___S_c_23_env_2d_lookup_2d_macro)
#define ___SYM_c_23_env_2d_lookup_2d_var ___SYM(20,___S_c_23_env_2d_lookup_2d_var)
#define ___SYM_c_23_env_2d_macro ___SYM(21,___S_c_23_env_2d_macro)
#define ___SYM_c_23_env_2d_macros_2d_ref ___SYM(22,___S_c_23_env_2d_macros_2d_ref)
#define ___SYM_c_23_env_2d_macros_2d_set ___SYM(23,___S_c_23_env_2d_macros_2d_set)
#define ___SYM_c_23_env_2d_namespace ___SYM(24,___S_c_23_env_2d_namespace)
#define ___SYM_c_23_env_2d_namespace_2d_lookup ___SYM(25,___S_c_23_env_2d_namespace_2d_lookup)
#define ___SYM_c_23_env_2d_namespace_2d_lookup_2d_both ___SYM(26,___S_c_23_env_2d_namespace_2d_lookup_2d_both)
#define ___SYM_c_23_env_2d_namespace_2d_ref ___SYM(27,___S_c_23_env_2d_namespace_2d_ref)
#define ___SYM_c_23_env_2d_namespace_2d_set ___SYM(28,___S_c_23_env_2d_namespace_2d_set)
#define ___SYM_c_23_env_2d_new_2d_var_21_ ___SYM(29,___S_c_23_env_2d_new_2d_var_21_)
#define ___SYM_c_23_env_2d_parent_2d_ref ___SYM(30,___S_c_23_env_2d_parent_2d_ref)
#define ___SYM_c_23_env_2d_vars_2d_ref ___SYM(31,___S_c_23_env_2d_vars_2d_ref)
#define ___SYM_c_23_env_2d_vars_2d_set_21_ ___SYM(32,___S_c_23_env_2d_vars_2d_set_21_)
#define ___SYM_c_23_env_2e_begin_21_ ___SYM(33,___S_c_23_env_2e_begin_21_)
#define ___SYM_c_23_env_2e_end_21_ ___SYM(34,___S_c_23_env_2e_end_21_)
#define ___SYM_c_23_flag_2d_decl ___SYM(35,___S_c_23_flag_2d_decl)
#define ___SYM_c_23_full_2d_name_3f_ ___SYM(36,___S_c_23_full_2d_name_3f_)
#define ___SYM_c_23_make_2d_full_2d_name ___SYM(37,___S_c_23_make_2d_full_2d_name)
#define ___SYM_c_23_make_2d_temp_2d_var ___SYM(38,___S_c_23_make_2d_temp_2d_var)
#define ___SYM_c_23_make_2d_var ___SYM(39,___S_c_23_make_2d_var)
#define ___SYM_c_23_namable_2d_boolean_2d_decl ___SYM(40,___S_c_23_namable_2d_boolean_2d_decl)
#define ___SYM_c_23_namable_2d_decl ___SYM(41,___S_c_23_namable_2d_decl)
#define ___SYM_c_23_namespace_2d_valid_3f_ ___SYM(42,___S_c_23_namespace_2d_valid_3f_)
#define ___SYM_c_23_parameterized_2d_decl ___SYM(43,___S_c_23_parameterized_2d_decl)
#define ___SYM_c_23_resize_2d_var_2d_list ___SYM(44,___S_c_23_resize_2d_var_2d_list)
#define ___SYM_c_23_var_2d_bound ___SYM(45,___S_c_23_var_2d_bound)
#define ___SYM_c_23_var_2d_bound_2d_set_21_ ___SYM(46,___S_c_23_var_2d_bound_2d_set_21_)
#define ___SYM_c_23_var_2d_boxed_3f_ ___SYM(47,___S_c_23_var_2d_boxed_3f_)
#define ___SYM_c_23_var_2d_boxed_3f__2d_set_21_ ___SYM(48,___S_c_23_var_2d_boxed_3f__2d_set_21_)
#define ___SYM_c_23_var_2d_clone ___SYM(49,___S_c_23_var_2d_clone)
#define ___SYM_c_23_var_2d_clone_2d_set_21_ ___SYM(50,___S_c_23_var_2d_clone_2d_set_21_)
#define ___SYM_c_23_var_2d_constant ___SYM(51,___S_c_23_var_2d_constant)
#define ___SYM_c_23_var_2d_constant_2d_set_21_ ___SYM(52,___S_c_23_var_2d_constant_2d_set_21_)
#define ___SYM_c_23_var_2d_info ___SYM(53,___S_c_23_var_2d_info)
#define ___SYM_c_23_var_2d_info_2d_set_21_ ___SYM(54,___S_c_23_var_2d_info_2d_set_21_)
#define ___SYM_c_23_var_2d_lexical_2d_level ___SYM(55,___S_c_23_var_2d_lexical_2d_level)
#define ___SYM_c_23_var_2d_name ___SYM(56,___S_c_23_var_2d_name)
#define ___SYM_c_23_var_2d_name_2d_set_21_ ___SYM(57,___S_c_23_var_2d_name_2d_set_21_)
#define ___SYM_c_23_var_2d_refs ___SYM(58,___S_c_23_var_2d_refs)
#define ___SYM_c_23_var_2d_refs_2d_set_21_ ___SYM(59,___S_c_23_var_2d_refs_2d_set_21_)
#define ___SYM_c_23_var_2d_sets ___SYM(60,___S_c_23_var_2d_sets)
#define ___SYM_c_23_var_2d_sets_2d_set_21_ ___SYM(61,___S_c_23_var_2d_sets_2d_set_21_)
#define ___SYM_c_23_var_2d_source ___SYM(62,___S_c_23_var_2d_source)
#define ___SYM_c_23_var_2d_source_2d_set_21_ ___SYM(63,___S_c_23_var_2d_source_2d_set_21_)
#define ___SYM_c_23_var_2d_stamp ___SYM(64,___S_c_23_var_2d_stamp)
#define ___SYM_c_23_var_2d_stamp_2d_set_21_ ___SYM(65,___S_c_23_var_2d_stamp_2d_set_21_)
#define ___SYM_c_23_var_2d_temp_3f_ ___SYM(66,___S_c_23_var_2d_temp_3f_)
#define ___SYM_c_23_var_2d_temp_3f__2d_set_21_ ___SYM(67,___S_c_23_var_2d_temp_3f__2d_set_21_)
#define ___SYM_c_23_var_3f_ ___SYM(68,___S_c_23_var_3f_)
#define ___SYM_closure_2d_env ___SYM(69,___S_closure_2d_env)
#define ___SYM_ret ___SYM(70,___S_ret)
#define ___SYM_var_2d_tag ___SYM(71,___S_var_2d_tag)

___BEGIN_GLO
___DEF_GLO(0,"_env#")
___DEF_GLO(1,"c#boolean-decl")
___DEF_GLO(2,"c#boolean-declarations")
___DEF_GLO(3,"c#closure-env-var")
___DEF_GLO(4,"c#declaration-value")
___DEF_GLO(5,"c#define-boolean-decl")
___DEF_GLO(6,"c#define-flag-decl")
___DEF_GLO(7,"c#define-namable-boolean-decl")
___DEF_GLO(8,"c#define-namable-decl")
___DEF_GLO(9,"c#define-parameterized-decl")
___DEF_GLO(10,"c#empty-var")
___DEF_GLO(11,"c#env-decl-ref")
___DEF_GLO(12,"c#env-decl-set")
___DEF_GLO(13,"c#env-declare")
___DEF_GLO(14,"c#env-define-var")
___DEF_GLO(15,"c#env-externals-ref")
___DEF_GLO(16,"c#env-frame")
___DEF_GLO(17,"c#env-global-env")
___DEF_GLO(18,"c#env-global-variables")
___DEF_GLO(19,"c#env-lookup")
___DEF_GLO(20,"c#env-lookup-global-var")
___DEF_GLO(21,"c#env-lookup-macro")
___DEF_GLO(22,"c#env-lookup-var")
___DEF_GLO(23,"c#env-macro")
___DEF_GLO(24,"c#env-macros-ref")
___DEF_GLO(25,"c#env-macros-set")
___DEF_GLO(26,"c#env-namespace")
___DEF_GLO(27,"c#env-namespace-lookup")
___DEF_GLO(28,"c#env-namespace-lookup-both")
___DEF_GLO(29,"c#env-namespace-ref")
___DEF_GLO(30,"c#env-namespace-set")
___DEF_GLO(31,"c#env-new-var!")
___DEF_GLO(32,"c#env-parent-ref")
___DEF_GLO(33,"c#env-vars-ref")
___DEF_GLO(34,"c#env-vars-set!")
___DEF_GLO(35,"c#env.begin!")
___DEF_GLO(36,"c#env.end!")
___DEF_GLO(37,"c#flag-decl")
___DEF_GLO(38,"c#flag-declarations")
___DEF_GLO(39,"c#full-name?")
___DEF_GLO(40,"c#make-full-name")
___DEF_GLO(41,"c#make-global-environment")
___DEF_GLO(42,"c#make-temp-var")
___DEF_GLO(43,"c#make-var")
___DEF_GLO(44,"c#namable-boolean-decl")
___DEF_GLO(45,"c#namable-boolean-declarations")
___DEF_GLO(46,"c#namable-decl")
___DEF_GLO(47,"c#namable-declarations")
___DEF_GLO(48,"c#namespace-valid?")
___DEF_GLO(49,"c#next-var-stamp")
___DEF_GLO(50,"c#parameterized-decl")
___DEF_GLO(51,"c#parameterized-declarations")
___DEF_GLO(52,"c#resize-var-list")
___DEF_GLO(53,"c#ret-var")
___DEF_GLO(54,"c#ret-var-set")
___DEF_GLO(55,"c#var-bound")
___DEF_GLO(56,"c#var-bound-set!")
___DEF_GLO(57,"c#var-boxed?")
___DEF_GLO(58,"c#var-boxed?-set!")
___DEF_GLO(59,"c#var-clone")
___DEF_GLO(60,"c#var-clone-set!")
___DEF_GLO(61,"c#var-constant")
___DEF_GLO(62,"c#var-constant-set!")
___DEF_GLO(63,"c#var-info")
___DEF_GLO(64,"c#var-info-set!")
___DEF_GLO(65,"c#var-lexical-level")
___DEF_GLO(66,"c#var-name")
___DEF_GLO(67,"c#var-name-set!")
___DEF_GLO(68,"c#var-refs")
___DEF_GLO(69,"c#var-refs-set!")
___DEF_GLO(70,"c#var-sets")
___DEF_GLO(71,"c#var-sets-set!")
___DEF_GLO(72,"c#var-source")
___DEF_GLO(73,"c#var-source-set!")
___DEF_GLO(74,"c#var-stamp")
___DEF_GLO(75,"c#var-stamp-set!")
___DEF_GLO(76,"c#var-tag")
___DEF_GLO(77,"c#var-temp?")
___DEF_GLO(78,"c#var-temp?-set!")
___DEF_GLO(79,"c#var?")
___DEF_GLO(80,"##string->symbol")
___DEF_GLO(81,"##string-append")
___DEF_GLO(82,"##symbol->string")
___DEF_GLO(83,"c#compiler-internal-error")
___DEF_GLO(84,"c#make-counter")
___DEF_GLO(85,"c#node-parent")
___DEF_GLO(86,"c#prc?")
___DEF_GLO(87,"c#pt-syntax-error")
___DEF_GLO(88,"c#ptset-empty")
___DEF_GLO(89,"c#varset-singleton")
___DEF_GLO(90,"make-table")
___DEF_GLO(91,"table-set!")
___END_GLO

#define ___GLO___env_23_ ___GLO(0,___G___env_23_)
#define ___PRM___env_23_ ___PRM(0,___G___env_23_)
#define ___GLO_c_23_boolean_2d_decl ___GLO(1,___G_c_23_boolean_2d_decl)
#define ___PRM_c_23_boolean_2d_decl ___PRM(1,___G_c_23_boolean_2d_decl)
#define ___GLO_c_23_boolean_2d_declarations ___GLO(2,___G_c_23_boolean_2d_declarations)
#define ___PRM_c_23_boolean_2d_declarations ___PRM(2,___G_c_23_boolean_2d_declarations)
#define ___GLO_c_23_closure_2d_env_2d_var ___GLO(3,___G_c_23_closure_2d_env_2d_var)
#define ___PRM_c_23_closure_2d_env_2d_var ___PRM(3,___G_c_23_closure_2d_env_2d_var)
#define ___GLO_c_23_declaration_2d_value ___GLO(4,___G_c_23_declaration_2d_value)
#define ___PRM_c_23_declaration_2d_value ___PRM(4,___G_c_23_declaration_2d_value)
#define ___GLO_c_23_define_2d_boolean_2d_decl ___GLO(5,___G_c_23_define_2d_boolean_2d_decl)
#define ___PRM_c_23_define_2d_boolean_2d_decl ___PRM(5,___G_c_23_define_2d_boolean_2d_decl)
#define ___GLO_c_23_define_2d_flag_2d_decl ___GLO(6,___G_c_23_define_2d_flag_2d_decl)
#define ___PRM_c_23_define_2d_flag_2d_decl ___PRM(6,___G_c_23_define_2d_flag_2d_decl)
#define ___GLO_c_23_define_2d_namable_2d_boolean_2d_decl ___GLO(7,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
#define ___PRM_c_23_define_2d_namable_2d_boolean_2d_decl ___PRM(7,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
#define ___GLO_c_23_define_2d_namable_2d_decl ___GLO(8,___G_c_23_define_2d_namable_2d_decl)
#define ___PRM_c_23_define_2d_namable_2d_decl ___PRM(8,___G_c_23_define_2d_namable_2d_decl)
#define ___GLO_c_23_define_2d_parameterized_2d_decl ___GLO(9,___G_c_23_define_2d_parameterized_2d_decl)
#define ___PRM_c_23_define_2d_parameterized_2d_decl ___PRM(9,___G_c_23_define_2d_parameterized_2d_decl)
#define ___GLO_c_23_empty_2d_var ___GLO(10,___G_c_23_empty_2d_var)
#define ___PRM_c_23_empty_2d_var ___PRM(10,___G_c_23_empty_2d_var)
#define ___GLO_c_23_env_2d_decl_2d_ref ___GLO(11,___G_c_23_env_2d_decl_2d_ref)
#define ___PRM_c_23_env_2d_decl_2d_ref ___PRM(11,___G_c_23_env_2d_decl_2d_ref)
#define ___GLO_c_23_env_2d_decl_2d_set ___GLO(12,___G_c_23_env_2d_decl_2d_set)
#define ___PRM_c_23_env_2d_decl_2d_set ___PRM(12,___G_c_23_env_2d_decl_2d_set)
#define ___GLO_c_23_env_2d_declare ___GLO(13,___G_c_23_env_2d_declare)
#define ___PRM_c_23_env_2d_declare ___PRM(13,___G_c_23_env_2d_declare)
#define ___GLO_c_23_env_2d_define_2d_var ___GLO(14,___G_c_23_env_2d_define_2d_var)
#define ___PRM_c_23_env_2d_define_2d_var ___PRM(14,___G_c_23_env_2d_define_2d_var)
#define ___GLO_c_23_env_2d_externals_2d_ref ___GLO(15,___G_c_23_env_2d_externals_2d_ref)
#define ___PRM_c_23_env_2d_externals_2d_ref ___PRM(15,___G_c_23_env_2d_externals_2d_ref)
#define ___GLO_c_23_env_2d_frame ___GLO(16,___G_c_23_env_2d_frame)
#define ___PRM_c_23_env_2d_frame ___PRM(16,___G_c_23_env_2d_frame)
#define ___GLO_c_23_env_2d_global_2d_env ___GLO(17,___G_c_23_env_2d_global_2d_env)
#define ___PRM_c_23_env_2d_global_2d_env ___PRM(17,___G_c_23_env_2d_global_2d_env)
#define ___GLO_c_23_env_2d_global_2d_variables ___GLO(18,___G_c_23_env_2d_global_2d_variables)
#define ___PRM_c_23_env_2d_global_2d_variables ___PRM(18,___G_c_23_env_2d_global_2d_variables)
#define ___GLO_c_23_env_2d_lookup ___GLO(19,___G_c_23_env_2d_lookup)
#define ___PRM_c_23_env_2d_lookup ___PRM(19,___G_c_23_env_2d_lookup)
#define ___GLO_c_23_env_2d_lookup_2d_global_2d_var ___GLO(20,___G_c_23_env_2d_lookup_2d_global_2d_var)
#define ___PRM_c_23_env_2d_lookup_2d_global_2d_var ___PRM(20,___G_c_23_env_2d_lookup_2d_global_2d_var)
#define ___GLO_c_23_env_2d_lookup_2d_macro ___GLO(21,___G_c_23_env_2d_lookup_2d_macro)
#define ___PRM_c_23_env_2d_lookup_2d_macro ___PRM(21,___G_c_23_env_2d_lookup_2d_macro)
#define ___GLO_c_23_env_2d_lookup_2d_var ___GLO(22,___G_c_23_env_2d_lookup_2d_var)
#define ___PRM_c_23_env_2d_lookup_2d_var ___PRM(22,___G_c_23_env_2d_lookup_2d_var)
#define ___GLO_c_23_env_2d_macro ___GLO(23,___G_c_23_env_2d_macro)
#define ___PRM_c_23_env_2d_macro ___PRM(23,___G_c_23_env_2d_macro)
#define ___GLO_c_23_env_2d_macros_2d_ref ___GLO(24,___G_c_23_env_2d_macros_2d_ref)
#define ___PRM_c_23_env_2d_macros_2d_ref ___PRM(24,___G_c_23_env_2d_macros_2d_ref)
#define ___GLO_c_23_env_2d_macros_2d_set ___GLO(25,___G_c_23_env_2d_macros_2d_set)
#define ___PRM_c_23_env_2d_macros_2d_set ___PRM(25,___G_c_23_env_2d_macros_2d_set)
#define ___GLO_c_23_env_2d_namespace ___GLO(26,___G_c_23_env_2d_namespace)
#define ___PRM_c_23_env_2d_namespace ___PRM(26,___G_c_23_env_2d_namespace)
#define ___GLO_c_23_env_2d_namespace_2d_lookup ___GLO(27,___G_c_23_env_2d_namespace_2d_lookup)
#define ___PRM_c_23_env_2d_namespace_2d_lookup ___PRM(27,___G_c_23_env_2d_namespace_2d_lookup)
#define ___GLO_c_23_env_2d_namespace_2d_lookup_2d_both ___GLO(28,___G_c_23_env_2d_namespace_2d_lookup_2d_both)
#define ___PRM_c_23_env_2d_namespace_2d_lookup_2d_both ___PRM(28,___G_c_23_env_2d_namespace_2d_lookup_2d_both)
#define ___GLO_c_23_env_2d_namespace_2d_ref ___GLO(29,___G_c_23_env_2d_namespace_2d_ref)
#define ___PRM_c_23_env_2d_namespace_2d_ref ___PRM(29,___G_c_23_env_2d_namespace_2d_ref)
#define ___GLO_c_23_env_2d_namespace_2d_set ___GLO(30,___G_c_23_env_2d_namespace_2d_set)
#define ___PRM_c_23_env_2d_namespace_2d_set ___PRM(30,___G_c_23_env_2d_namespace_2d_set)
#define ___GLO_c_23_env_2d_new_2d_var_21_ ___GLO(31,___G_c_23_env_2d_new_2d_var_21_)
#define ___PRM_c_23_env_2d_new_2d_var_21_ ___PRM(31,___G_c_23_env_2d_new_2d_var_21_)
#define ___GLO_c_23_env_2d_parent_2d_ref ___GLO(32,___G_c_23_env_2d_parent_2d_ref)
#define ___PRM_c_23_env_2d_parent_2d_ref ___PRM(32,___G_c_23_env_2d_parent_2d_ref)
#define ___GLO_c_23_env_2d_vars_2d_ref ___GLO(33,___G_c_23_env_2d_vars_2d_ref)
#define ___PRM_c_23_env_2d_vars_2d_ref ___PRM(33,___G_c_23_env_2d_vars_2d_ref)
#define ___GLO_c_23_env_2d_vars_2d_set_21_ ___GLO(34,___G_c_23_env_2d_vars_2d_set_21_)
#define ___PRM_c_23_env_2d_vars_2d_set_21_ ___PRM(34,___G_c_23_env_2d_vars_2d_set_21_)
#define ___GLO_c_23_env_2e_begin_21_ ___GLO(35,___G_c_23_env_2e_begin_21_)
#define ___PRM_c_23_env_2e_begin_21_ ___PRM(35,___G_c_23_env_2e_begin_21_)
#define ___GLO_c_23_env_2e_end_21_ ___GLO(36,___G_c_23_env_2e_end_21_)
#define ___PRM_c_23_env_2e_end_21_ ___PRM(36,___G_c_23_env_2e_end_21_)
#define ___GLO_c_23_flag_2d_decl ___GLO(37,___G_c_23_flag_2d_decl)
#define ___PRM_c_23_flag_2d_decl ___PRM(37,___G_c_23_flag_2d_decl)
#define ___GLO_c_23_flag_2d_declarations ___GLO(38,___G_c_23_flag_2d_declarations)
#define ___PRM_c_23_flag_2d_declarations ___PRM(38,___G_c_23_flag_2d_declarations)
#define ___GLO_c_23_full_2d_name_3f_ ___GLO(39,___G_c_23_full_2d_name_3f_)
#define ___PRM_c_23_full_2d_name_3f_ ___PRM(39,___G_c_23_full_2d_name_3f_)
#define ___GLO_c_23_make_2d_full_2d_name ___GLO(40,___G_c_23_make_2d_full_2d_name)
#define ___PRM_c_23_make_2d_full_2d_name ___PRM(40,___G_c_23_make_2d_full_2d_name)
#define ___GLO_c_23_make_2d_global_2d_environment ___GLO(41,___G_c_23_make_2d_global_2d_environment)
#define ___PRM_c_23_make_2d_global_2d_environment ___PRM(41,___G_c_23_make_2d_global_2d_environment)
#define ___GLO_c_23_make_2d_temp_2d_var ___GLO(42,___G_c_23_make_2d_temp_2d_var)
#define ___PRM_c_23_make_2d_temp_2d_var ___PRM(42,___G_c_23_make_2d_temp_2d_var)
#define ___GLO_c_23_make_2d_var ___GLO(43,___G_c_23_make_2d_var)
#define ___PRM_c_23_make_2d_var ___PRM(43,___G_c_23_make_2d_var)
#define ___GLO_c_23_namable_2d_boolean_2d_decl ___GLO(44,___G_c_23_namable_2d_boolean_2d_decl)
#define ___PRM_c_23_namable_2d_boolean_2d_decl ___PRM(44,___G_c_23_namable_2d_boolean_2d_decl)
#define ___GLO_c_23_namable_2d_boolean_2d_declarations ___GLO(45,___G_c_23_namable_2d_boolean_2d_declarations)
#define ___PRM_c_23_namable_2d_boolean_2d_declarations ___PRM(45,___G_c_23_namable_2d_boolean_2d_declarations)
#define ___GLO_c_23_namable_2d_decl ___GLO(46,___G_c_23_namable_2d_decl)
#define ___PRM_c_23_namable_2d_decl ___PRM(46,___G_c_23_namable_2d_decl)
#define ___GLO_c_23_namable_2d_declarations ___GLO(47,___G_c_23_namable_2d_declarations)
#define ___PRM_c_23_namable_2d_declarations ___PRM(47,___G_c_23_namable_2d_declarations)
#define ___GLO_c_23_namespace_2d_valid_3f_ ___GLO(48,___G_c_23_namespace_2d_valid_3f_)
#define ___PRM_c_23_namespace_2d_valid_3f_ ___PRM(48,___G_c_23_namespace_2d_valid_3f_)
#define ___GLO_c_23_next_2d_var_2d_stamp ___GLO(49,___G_c_23_next_2d_var_2d_stamp)
#define ___PRM_c_23_next_2d_var_2d_stamp ___PRM(49,___G_c_23_next_2d_var_2d_stamp)
#define ___GLO_c_23_parameterized_2d_decl ___GLO(50,___G_c_23_parameterized_2d_decl)
#define ___PRM_c_23_parameterized_2d_decl ___PRM(50,___G_c_23_parameterized_2d_decl)
#define ___GLO_c_23_parameterized_2d_declarations ___GLO(51,___G_c_23_parameterized_2d_declarations)
#define ___PRM_c_23_parameterized_2d_declarations ___PRM(51,___G_c_23_parameterized_2d_declarations)
#define ___GLO_c_23_resize_2d_var_2d_list ___GLO(52,___G_c_23_resize_2d_var_2d_list)
#define ___PRM_c_23_resize_2d_var_2d_list ___PRM(52,___G_c_23_resize_2d_var_2d_list)
#define ___GLO_c_23_ret_2d_var ___GLO(53,___G_c_23_ret_2d_var)
#define ___PRM_c_23_ret_2d_var ___PRM(53,___G_c_23_ret_2d_var)
#define ___GLO_c_23_ret_2d_var_2d_set ___GLO(54,___G_c_23_ret_2d_var_2d_set)
#define ___PRM_c_23_ret_2d_var_2d_set ___PRM(54,___G_c_23_ret_2d_var_2d_set)
#define ___GLO_c_23_var_2d_bound ___GLO(55,___G_c_23_var_2d_bound)
#define ___PRM_c_23_var_2d_bound ___PRM(55,___G_c_23_var_2d_bound)
#define ___GLO_c_23_var_2d_bound_2d_set_21_ ___GLO(56,___G_c_23_var_2d_bound_2d_set_21_)
#define ___PRM_c_23_var_2d_bound_2d_set_21_ ___PRM(56,___G_c_23_var_2d_bound_2d_set_21_)
#define ___GLO_c_23_var_2d_boxed_3f_ ___GLO(57,___G_c_23_var_2d_boxed_3f_)
#define ___PRM_c_23_var_2d_boxed_3f_ ___PRM(57,___G_c_23_var_2d_boxed_3f_)
#define ___GLO_c_23_var_2d_boxed_3f__2d_set_21_ ___GLO(58,___G_c_23_var_2d_boxed_3f__2d_set_21_)
#define ___PRM_c_23_var_2d_boxed_3f__2d_set_21_ ___PRM(58,___G_c_23_var_2d_boxed_3f__2d_set_21_)
#define ___GLO_c_23_var_2d_clone ___GLO(59,___G_c_23_var_2d_clone)
#define ___PRM_c_23_var_2d_clone ___PRM(59,___G_c_23_var_2d_clone)
#define ___GLO_c_23_var_2d_clone_2d_set_21_ ___GLO(60,___G_c_23_var_2d_clone_2d_set_21_)
#define ___PRM_c_23_var_2d_clone_2d_set_21_ ___PRM(60,___G_c_23_var_2d_clone_2d_set_21_)
#define ___GLO_c_23_var_2d_constant ___GLO(61,___G_c_23_var_2d_constant)
#define ___PRM_c_23_var_2d_constant ___PRM(61,___G_c_23_var_2d_constant)
#define ___GLO_c_23_var_2d_constant_2d_set_21_ ___GLO(62,___G_c_23_var_2d_constant_2d_set_21_)
#define ___PRM_c_23_var_2d_constant_2d_set_21_ ___PRM(62,___G_c_23_var_2d_constant_2d_set_21_)
#define ___GLO_c_23_var_2d_info ___GLO(63,___G_c_23_var_2d_info)
#define ___PRM_c_23_var_2d_info ___PRM(63,___G_c_23_var_2d_info)
#define ___GLO_c_23_var_2d_info_2d_set_21_ ___GLO(64,___G_c_23_var_2d_info_2d_set_21_)
#define ___PRM_c_23_var_2d_info_2d_set_21_ ___PRM(64,___G_c_23_var_2d_info_2d_set_21_)
#define ___GLO_c_23_var_2d_lexical_2d_level ___GLO(65,___G_c_23_var_2d_lexical_2d_level)
#define ___PRM_c_23_var_2d_lexical_2d_level ___PRM(65,___G_c_23_var_2d_lexical_2d_level)
#define ___GLO_c_23_var_2d_name ___GLO(66,___G_c_23_var_2d_name)
#define ___PRM_c_23_var_2d_name ___PRM(66,___G_c_23_var_2d_name)
#define ___GLO_c_23_var_2d_name_2d_set_21_ ___GLO(67,___G_c_23_var_2d_name_2d_set_21_)
#define ___PRM_c_23_var_2d_name_2d_set_21_ ___PRM(67,___G_c_23_var_2d_name_2d_set_21_)
#define ___GLO_c_23_var_2d_refs ___GLO(68,___G_c_23_var_2d_refs)
#define ___PRM_c_23_var_2d_refs ___PRM(68,___G_c_23_var_2d_refs)
#define ___GLO_c_23_var_2d_refs_2d_set_21_ ___GLO(69,___G_c_23_var_2d_refs_2d_set_21_)
#define ___PRM_c_23_var_2d_refs_2d_set_21_ ___PRM(69,___G_c_23_var_2d_refs_2d_set_21_)
#define ___GLO_c_23_var_2d_sets ___GLO(70,___G_c_23_var_2d_sets)
#define ___PRM_c_23_var_2d_sets ___PRM(70,___G_c_23_var_2d_sets)
#define ___GLO_c_23_var_2d_sets_2d_set_21_ ___GLO(71,___G_c_23_var_2d_sets_2d_set_21_)
#define ___PRM_c_23_var_2d_sets_2d_set_21_ ___PRM(71,___G_c_23_var_2d_sets_2d_set_21_)
#define ___GLO_c_23_var_2d_source ___GLO(72,___G_c_23_var_2d_source)
#define ___PRM_c_23_var_2d_source ___PRM(72,___G_c_23_var_2d_source)
#define ___GLO_c_23_var_2d_source_2d_set_21_ ___GLO(73,___G_c_23_var_2d_source_2d_set_21_)
#define ___PRM_c_23_var_2d_source_2d_set_21_ ___PRM(73,___G_c_23_var_2d_source_2d_set_21_)
#define ___GLO_c_23_var_2d_stamp ___GLO(74,___G_c_23_var_2d_stamp)
#define ___PRM_c_23_var_2d_stamp ___PRM(74,___G_c_23_var_2d_stamp)
#define ___GLO_c_23_var_2d_stamp_2d_set_21_ ___GLO(75,___G_c_23_var_2d_stamp_2d_set_21_)
#define ___PRM_c_23_var_2d_stamp_2d_set_21_ ___PRM(75,___G_c_23_var_2d_stamp_2d_set_21_)
#define ___GLO_c_23_var_2d_tag ___GLO(76,___G_c_23_var_2d_tag)
#define ___PRM_c_23_var_2d_tag ___PRM(76,___G_c_23_var_2d_tag)
#define ___GLO_c_23_var_2d_temp_3f_ ___GLO(77,___G_c_23_var_2d_temp_3f_)
#define ___PRM_c_23_var_2d_temp_3f_ ___PRM(77,___G_c_23_var_2d_temp_3f_)
#define ___GLO_c_23_var_2d_temp_3f__2d_set_21_ ___GLO(78,___G_c_23_var_2d_temp_3f__2d_set_21_)
#define ___PRM_c_23_var_2d_temp_3f__2d_set_21_ ___PRM(78,___G_c_23_var_2d_temp_3f__2d_set_21_)
#define ___GLO_c_23_var_3f_ ___GLO(79,___G_c_23_var_3f_)
#define ___PRM_c_23_var_3f_ ___PRM(79,___G_c_23_var_3f_)
#define ___GLO__23__23_string_2d__3e_symbol ___GLO(80,___G__23__23_string_2d__3e_symbol)
#define ___PRM__23__23_string_2d__3e_symbol ___PRM(80,___G__23__23_string_2d__3e_symbol)
#define ___GLO__23__23_string_2d_append ___GLO(81,___G__23__23_string_2d_append)
#define ___PRM__23__23_string_2d_append ___PRM(81,___G__23__23_string_2d_append)
#define ___GLO__23__23_symbol_2d__3e_string ___GLO(82,___G__23__23_symbol_2d__3e_string)
#define ___PRM__23__23_symbol_2d__3e_string ___PRM(82,___G__23__23_symbol_2d__3e_string)
#define ___GLO_c_23_compiler_2d_internal_2d_error ___GLO(83,___G_c_23_compiler_2d_internal_2d_error)
#define ___PRM_c_23_compiler_2d_internal_2d_error ___PRM(83,___G_c_23_compiler_2d_internal_2d_error)
#define ___GLO_c_23_make_2d_counter ___GLO(84,___G_c_23_make_2d_counter)
#define ___PRM_c_23_make_2d_counter ___PRM(84,___G_c_23_make_2d_counter)
#define ___GLO_c_23_node_2d_parent ___GLO(85,___G_c_23_node_2d_parent)
#define ___PRM_c_23_node_2d_parent ___PRM(85,___G_c_23_node_2d_parent)
#define ___GLO_c_23_prc_3f_ ___GLO(86,___G_c_23_prc_3f_)
#define ___PRM_c_23_prc_3f_ ___PRM(86,___G_c_23_prc_3f_)
#define ___GLO_c_23_pt_2d_syntax_2d_error ___GLO(87,___G_c_23_pt_2d_syntax_2d_error)
#define ___PRM_c_23_pt_2d_syntax_2d_error ___PRM(87,___G_c_23_pt_2d_syntax_2d_error)
#define ___GLO_c_23_ptset_2d_empty ___GLO(88,___G_c_23_ptset_2d_empty)
#define ___PRM_c_23_ptset_2d_empty ___PRM(88,___G_c_23_ptset_2d_empty)
#define ___GLO_c_23_varset_2d_singleton ___GLO(89,___G_c_23_varset_2d_singleton)
#define ___PRM_c_23_varset_2d_singleton ___PRM(89,___G_c_23_varset_2d_singleton)
#define ___GLO_make_2d_table ___GLO(90,___G_make_2d_table)
#define ___PRM_make_2d_table ___PRM(90,___G_make_2d_table)
#define ___GLO_table_2d_set_21_ ___GLO(91,___G_table_2d_set_21_)
#define ___PRM_table_2d_set_21_ ___PRM(91,___G_table_2d_set_21_)

___DEF_SUB_STR(___X0,39UL)
               ___STR8(101,110,118,45,108,111,111,107)
               ___STR8(117,112,45,118,97,114,44,32)
               ___STR8(110,97,109,101,32,105,115,32)
               ___STR8(116,104,97,116,32,111,102,32)
               ___STR7(97,32,109,97,99,114,111)
___DEF_SUB_STR(___X1,34UL)
               ___STR8(68,117,112,108,105,99,97,116)
               ___STR8(101,32,100,101,102,105,110,105)
               ___STR8(116,105,111,110,32,111,102,32)
               ___STR8(97,32,118,97,114,105,97,98)
               ___STR2(108,101)
___DEF_SUB_STR(___X2,39UL)
               ___STR8(101,110,118,45,100,101,102,105)
               ___STR8(110,101,45,118,97,114,44,32)
               ___STR8(110,97,109,101,32,105,115,32)
               ___STR8(116,104,97,116,32,111,102,32)
               ___STR7(97,32,109,97,99,114,111)
___DEF_SUB_VEC(___X3,6UL)
               ___VEC1(___REF_SUB(4))
               ___VEC1(___REF_SUB(5))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X4,1UL)
               ___VEC1(___REF_SYM(0,___S___env))
               ___VEC0
___DEF_SUB_VEC(___X5,0UL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
,___DEF_SUB(___X2)
,___DEF_SUB(___X3)
,___DEF_SUB(___X4)
,___DEF_SUB(___X5)
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
___DEF_M_HLBL(___L0___env_23_)
___DEF_M_HLBL(___L1___env_23_)
___DEF_M_HLBL(___L2___env_23_)
___DEF_M_HLBL(___L3___env_23_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_var)
___DEF_M_HLBL(___L1_c_23_make_2d_var)
___DEF_M_HLBL(___L2_c_23_make_2d_var)
___DEF_M_HLBL(___L3_c_23_make_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_bound)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_refs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_sets)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_boxed_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_stamp)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_constant)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_clone)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_temp_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_name_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_bound_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_refs_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_sets_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_source_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_boxed_3f__2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_info_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_stamp_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_constant_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_clone_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_temp_3f__2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L1_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L2_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L3_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L4_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L5_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L6_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L7_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L1_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L2_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L3_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L4_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_resize_2d_var_2d_list)
___DEF_M_HLBL(___L1_c_23_resize_2d_var_2d_list)
___DEF_M_HLBL(___L2_c_23_resize_2d_var_2d_list)
___DEF_M_HLBL(___L3_c_23_resize_2d_var_2d_list)
___DEF_M_HLBL(___L4_c_23_resize_2d_var_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_frame)
___DEF_M_HLBL(___L1_c_23_env_2d_frame)
___DEF_M_HLBL(___L2_c_23_env_2d_frame)
___DEF_M_HLBL(___L3_c_23_env_2d_frame)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L1_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L2_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L3_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L4_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L5_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L6_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L7_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_macro)
___DEF_M_HLBL(___L1_c_23_env_2d_macro)
___DEF_M_HLBL(___L2_c_23_env_2d_macro)
___DEF_M_HLBL(___L3_c_23_env_2d_macro)
___DEF_M_HLBL(___L4_c_23_env_2d_macro)
___DEF_M_HLBL(___L5_c_23_env_2d_macro)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_macros_2d_set)
___DEF_M_HLBL(___L1_c_23_env_2d_macros_2d_set)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_declare)
___DEF_M_HLBL(___L1_c_23_env_2d_declare)
___DEF_M_HLBL(___L2_c_23_env_2d_declare)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_decl_2d_set)
___DEF_M_HLBL(___L1_c_23_env_2d_decl_2d_set)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_namespace)
___DEF_M_HLBL(___L1_c_23_env_2d_namespace)
___DEF_M_HLBL(___L2_c_23_env_2d_namespace)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_namespace_2d_set)
___DEF_M_HLBL(___L1_c_23_env_2d_namespace_2d_set)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_vars_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_vars_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_macros_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_decl_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_namespace_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_parent_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_externals_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L1_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L2_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L3_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L4_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L5_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L6_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L7_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L1_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L2_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L3_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L4_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L5_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L6_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L7_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L8_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L9_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL(___L10_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_lookup)
___DEF_M_HLBL(___L1_c_23_env_2d_lookup)
___DEF_M_HLBL(___L2_c_23_env_2d_lookup)
___DEF_M_HLBL(___L3_c_23_env_2d_lookup)
___DEF_M_HLBL(___L4_c_23_env_2d_lookup)
___DEF_M_HLBL(___L5_c_23_env_2d_lookup)
___DEF_M_HLBL(___L6_c_23_env_2d_lookup)
___DEF_M_HLBL(___L7_c_23_env_2d_lookup)
___DEF_M_HLBL(___L8_c_23_env_2d_lookup)
___DEF_M_HLBL(___L9_c_23_env_2d_lookup)
___DEF_M_HLBL(___L10_c_23_env_2d_lookup)
___DEF_M_HLBL(___L11_c_23_env_2d_lookup)
___DEF_M_HLBL(___L12_c_23_env_2d_lookup)
___DEF_M_HLBL(___L13_c_23_env_2d_lookup)
___DEF_M_HLBL(___L14_c_23_env_2d_lookup)
___DEF_M_HLBL(___L15_c_23_env_2d_lookup)
___DEF_M_HLBL(___L16_c_23_env_2d_lookup)
___DEF_M_HLBL(___L17_c_23_env_2d_lookup)
___DEF_M_HLBL(___L18_c_23_env_2d_lookup)
___DEF_M_HLBL(___L19_c_23_env_2d_lookup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_namespace_2d_valid_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L1_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L2_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L3_c_23_full_2d_name_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L1_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L2_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L3_c_23_make_2d_full_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L1_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L2_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L3_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L4_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L5_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L6_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L7_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L1_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L2_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L3_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L4_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L5_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L6_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L7_c_23_env_2d_define_2d_var)
___DEF_M_HLBL(___L8_c_23_env_2d_define_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL(___L1_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL(___L2_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL(___L3_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL(___L4_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL(___L5_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL(___L6_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_global_2d_variables)
___DEF_M_HLBL(___L1_c_23_env_2d_global_2d_variables)
___DEF_M_HLBL(___L2_c_23_env_2d_global_2d_variables)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_global_2d_env)
___DEF_M_HLBL(___L1_c_23_env_2d_global_2d_env)
___DEF_M_HLBL(___L2_c_23_env_2d_global_2d_env)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_lookup_2d_macro)
___DEF_M_HLBL(___L1_c_23_env_2d_lookup_2d_macro)
___DEF_M_HLBL(___L2_c_23_env_2d_lookup_2d_macro)
___DEF_M_HLBL(___L3_c_23_env_2d_lookup_2d_macro)
___DEF_M_HLBL(___L4_c_23_env_2d_lookup_2d_macro)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_define_2d_flag_2d_decl)
___DEF_M_HLBL(___L1_c_23_define_2d_flag_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_define_2d_parameterized_2d_decl)
___DEF_M_HLBL(___L1_c_23_define_2d_parameterized_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_define_2d_boolean_2d_decl)
___DEF_M_HLBL(___L1_c_23_define_2d_boolean_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_define_2d_namable_2d_decl)
___DEF_M_HLBL(___L1_c_23_define_2d_namable_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_M_HLBL(___L1_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_flag_2d_decl)
___DEF_M_HLBL(___L1_c_23_flag_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_parameterized_2d_decl)
___DEF_M_HLBL(___L1_c_23_parameterized_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_boolean_2d_decl)
___DEF_M_HLBL(___L1_c_23_boolean_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_namable_2d_decl)
___DEF_M_HLBL(___L1_c_23_namable_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_namable_2d_boolean_2d_decl)
___DEF_M_HLBL(___L1_c_23_namable_2d_boolean_2d_decl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_declaration_2d_value)
___DEF_M_HLBL(___L1_c_23_declaration_2d_value)
___DEF_M_HLBL(___L2_c_23_declaration_2d_value)
___DEF_M_HLBL(___L3_c_23_declaration_2d_value)
___DEF_M_HLBL(___L4_c_23_declaration_2d_value)
___DEF_M_HLBL(___L5_c_23_declaration_2d_value)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L1_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L2_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L3_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L4_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L5_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L6_c_23_env_2e_begin_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2e_end_21_)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___env_23_
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___env_23_)
___DEF_P_HLBL(___L1___env_23_)
___DEF_P_HLBL(___L2___env_23_)
___DEF_P_HLBL(___L3___env_23_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___env_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___env_23_)
   ___SET_R1(___CONS(___SYM_var_2d_tag,___NUL))
   ___SET_GLO(76,___G_c_23_var_2d_tag,___R1)
   ___SET_GLO(49,___G_c_23_next_2d_var_2d_stamp,___FAL)
   ___SET_GLO(53,___G_c_23_ret_2d_var,___NUL)
   ___SET_GLO(54,___G_c_23_ret_2d_var_2d_set,___NUL)
   ___SET_GLO(3,___G_c_23_closure_2d_env_2d_var,___NUL)
   ___SET_GLO(10,___G_c_23_empty_2d_var,___NUL)
   ___SET_GLO(41,___G_c_23_make_2d_global_2d_environment,___FAL)
   ___SET_GLO(41,___G_c_23_make_2d_global_2d_environment,___LBL(2))
   ___SET_GLO(38,___G_c_23_flag_2d_declarations,___NUL)
   ___SET_GLO(51,___G_c_23_parameterized_2d_declarations,___NUL)
   ___SET_GLO(2,___G_c_23_boolean_2d_declarations,___NUL)
   ___SET_GLO(47,___G_c_23_namable_2d_declarations,___NUL)
   ___SET_GLO(45,___G_c_23_namable_2d_boolean_2d_declarations,___NUL)
   ___SET_R1(___VOID)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1___env_23_)
   ___JUMPRET(___R0)
___DEF_SLBL(2,___L2___env_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(2,0,0,0)
   ___SET_R2(___NUL)
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3___env_23_)
   ___JUMPINT(___SET_NARGS(2),___PRC(78),___L_c_23_env_2d_frame)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 6
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_var)
___DEF_P_HLBL(___L1_c_23_make_2d_var)
___DEF_P_HLBL(___L2_c_23_make_2d_var)
___DEF_P_HLBL(___L3_c_23_make_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_var)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_make_2d_var)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_var)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),49,___G_c_23_next_2d_var_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_var)
   ___BEGIN_ALLOC_VECTOR(12UL)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_var_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___FAL)
   ___ADD_VECTOR_ELEM(7,___FAL)
   ___ADD_VECTOR_ELEM(8,___R1)
   ___ADD_VECTOR_ELEM(9,___FAL)
   ___ADD_VECTOR_ELEM(10,___FAL)
   ___ADD_VECTOR_ELEM(11,___STK(-5))
   ___END_ALLOC_VECTOR(12)
   ___SET_R1(___GET_VECTOR(12))
   ___ADJFP(-8)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_var)
   ___ADJFP(-4)
   ___JUMPRET(___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 11
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_3f_)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L1_c_23_var_3f_)
   ___END_IF
   ___SET_R2(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXGT(___R2,___FIX(0L))))
   ___GOTO(___L1_c_23_var_3f_)
   ___END_IF
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_var_2d_tag)))
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_var_3f_)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 13
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_name)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_bound
#undef ___PH_LBL0
#define ___PH_LBL0 15
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_bound)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_bound)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_bound)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_refs
#undef ___PH_LBL0
#define ___PH_LBL0 17
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_refs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_refs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_refs)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_sets
#undef ___PH_LBL0
#define ___PH_LBL0 19
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_sets)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_sets)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_sets)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 21
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_source)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_source)
   ___SET_R1(___VECTORREF(___R1,___FIX(5L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_boxed_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 23
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_boxed_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_boxed_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_boxed_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 25
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_info)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_info)
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_stamp
#undef ___PH_LBL0
#define ___PH_LBL0 27
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_stamp)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_stamp)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_stamp)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_constant
#undef ___PH_LBL0
#define ___PH_LBL0 29
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_constant)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_constant)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_constant)
   ___SET_R1(___VECTORREF(___R1,___FIX(9L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_clone
#undef ___PH_LBL0
#define ___PH_LBL0 31
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_clone)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_clone)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_clone)
   ___SET_R1(___VECTORREF(___R1,___FIX(10L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_temp_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 33
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_temp_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_temp_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_temp_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(11L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_name_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 35
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_name_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_name_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_name_2d_set_21_)
   ___VECTORSET(___R1,___FIX(1L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_bound_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 37
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_bound_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_bound_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_bound_2d_set_21_)
   ___VECTORSET(___R1,___FIX(2L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_refs_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 39
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_refs_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_refs_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_refs_2d_set_21_)
   ___VECTORSET(___R1,___FIX(3L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_sets_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 41
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_sets_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_sets_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_sets_2d_set_21_)
   ___VECTORSET(___R1,___FIX(4L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_source_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 43
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_source_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_source_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_source_2d_set_21_)
   ___VECTORSET(___R1,___FIX(5L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_boxed_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 45
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_boxed_3f__2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_boxed_3f__2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_boxed_3f__2d_set_21_)
   ___VECTORSET(___R1,___FIX(6L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_info_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 47
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_info_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_info_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_info_2d_set_21_)
   ___VECTORSET(___R1,___FIX(7L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_stamp_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 49
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_stamp_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_stamp_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_stamp_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_constant_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 51
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_constant_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_constant_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_constant_2d_set_21_)
   ___VECTORSET(___R1,___FIX(9L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_clone_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 53
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_clone_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_clone_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_clone_2d_set_21_)
   ___VECTORSET(___R1,___FIX(10L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_temp_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 55
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_temp_3f__2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_temp_3f__2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_temp_3f__2d_set_21_)
   ___VECTORSET(___R1,___FIX(11L),___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_lexical_2d_level
#undef ___PH_LBL0
#define ___PH_LBL0 57
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L1_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L2_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L3_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L4_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L5_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L6_c_23_var_2d_lexical_2d_level)
___DEF_P_HLBL(___L7_c_23_var_2d_lexical_2d_level)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_lexical_2d_level)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___IF(___EQP(___R1,___FAL))
   ___GOTO(___L15_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___IF(___EQP(___R1,___TRU))
   ___GOTO(___L15_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_var_2d_lexical_2d_level)
   ___GOTO(___L9_c_23_var_2d_lexical_2d_level)
___DEF_SLBL(2,___L2_c_23_var_2d_lexical_2d_level)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L14_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_R1(___FIX(0L))
___DEF_GLBL(___L8_c_23_var_2d_lexical_2d_level)
   ___SET_R2(___FIXADD(___STK(-6),___R1))
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-5))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_var_2d_lexical_2d_level)
___DEF_GLBL(___L9_c_23_var_2d_lexical_2d_level)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L13_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_var_2d_lexical_2d_level)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),85,___G_c_23_node_2d_parent)
___DEF_SLBL(5,___L5_c_23_var_2d_lexical_2d_level)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),86,___G_c_23_prc_3f_)
___DEF_SLBL(6,___L6_c_23_var_2d_lexical_2d_level)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L10_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_R1(___FIX(1L))
   ___GOTO(___L11_c_23_var_2d_lexical_2d_level)
___DEF_GLBL(___L10_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIX(0L))
___DEF_GLBL(___L11_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIXADD(___STK(-5),___R1))
   ___IF(___NOT(___NOTFALSEP(___STK(-4))))
   ___GOTO(___L12_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),85,___G_c_23_node_2d_parent)
___DEF_SLBL(7,___L7_c_23_var_2d_lexical_2d_level)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),86,___G_c_23_prc_3f_)
___DEF_GLBL(___L12_c_23_var_2d_lexical_2d_level)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L13_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___R2)
   ___JUMPRET(___R0)
___DEF_GLBL(___L14_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIX(1L))
   ___GOTO(___L8_c_23_var_2d_lexical_2d_level)
___DEF_GLBL(___L15_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIX(0L))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_temp_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 66
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_temp_2d_var)
___DEF_P_HLBL(___L1_c_23_make_2d_temp_2d_var)
___DEF_P_HLBL(___L2_c_23_make_2d_temp_2d_var)
___DEF_P_HLBL(___L3_c_23_make_2d_temp_2d_var)
___DEF_P_HLBL(___L4_c_23_make_2d_temp_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_temp_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_temp_2d_var)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___TRU)
   ___SET_STK(3,___R0)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_temp_2d_var)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),88,___G_c_23_ptset_2d_empty)
___DEF_SLBL(2,___L2_c_23_make_2d_temp_2d_var)
   ___SET_STK(-4,___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),88,___G_c_23_ptset_2d_empty)
___DEF_SLBL(3,___L3_c_23_make_2d_temp_2d_var)
   ___SET_R3(___TRU)
   ___SET_R2(___FAL)
   ___SET_R0(___STK(-4))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_temp_2d_var)
   ___ADJFP(-5)
   ___JUMPINT(___SET_NARGS(6),___PRC(6),___L_c_23_make_2d_var)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_resize_2d_var_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_resize_2d_var_2d_list)
___DEF_P_HLBL(___L1_c_23_resize_2d_var_2d_list)
___DEF_P_HLBL(___L2_c_23_resize_2d_var_2d_list)
___DEF_P_HLBL(___L3_c_23_resize_2d_var_2d_list)
___DEF_P_HLBL(___L4_c_23_resize_2d_var_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_resize_2d_var_2d_list)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_resize_2d_var_2d_list)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_resize_2d_var_2d_list)
   ___GOTO(___L6_c_23_resize_2d_var_2d_list)
___DEF_GLBL(___L5_c_23_resize_2d_var_2d_list)
   ___IF(___FIXLT(___R2,___FIX(0L)))
   ___GOTO(___L7_c_23_resize_2d_var_2d_list)
   ___END_IF
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___CONS(___GLO_c_23_empty_2d_var,___R1))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23_resize_2d_var_2d_list)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_resize_2d_var_2d_list)
___DEF_GLBL(___L6_c_23_resize_2d_var_2d_list)
   ___IF(___NOT(___FIXEQ(___R2,___FIX(0L))))
   ___GOTO(___L5_c_23_resize_2d_var_2d_list)
   ___END_IF
   ___JUMPRET(___R0)
___DEF_GLBL(___L7_c_23_resize_2d_var_2d_list)
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_R1(___CDR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_resize_2d_var_2d_list)
   ___GOTO(___L6_c_23_resize_2d_var_2d_list)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_frame
#undef ___PH_LBL0
#define ___PH_LBL0 78
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_frame)
___DEF_P_HLBL(___L1_c_23_env_2d_frame)
___DEF_P_HLBL(___L2_c_23_env_2d_frame)
___DEF_P_HLBL(___L3_c_23_env_2d_frame)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_frame)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_frame)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4_c_23_env_2d_frame)
   ___END_IF
   ___SET_R3(___VECTORREF(___R1,___FIX(2L)))
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L5_c_23_env_2d_frame)
   ___END_IF
   ___GOTO(___L7_c_23_env_2d_frame)
___DEF_GLBL(___L4_c_23_env_2d_frame)
   ___SET_R3(___NUL)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7_c_23_env_2d_frame)
   ___END_IF
___DEF_GLBL(___L5_c_23_env_2d_frame)
   ___SET_R4(___VECTORREF(___R1,___FIX(5L)))
___DEF_GLBL(___L6_c_23_env_2d_frame)
   ___SET_R2(___CONS(___R2,___FAL))
   ___BEGIN_ALLOC_VECTOR(6UL)
   ___ADD_VECTOR_ELEM(0,___R2)
   ___ADD_VECTOR_ELEM(1,___NUL)
   ___ADD_VECTOR_ELEM(2,___R3)
   ___ADD_VECTOR_ELEM(3,___NUL)
   ___ADD_VECTOR_ELEM(4,___R1)
   ___ADD_VECTOR_ELEM(5,___R4)
   ___END_ALLOC_VECTOR(6)
   ___SET_R1(___GET_VECTOR(6))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_frame)
   ___JUMPRET(___R0)
___DEF_GLBL(___L7_c_23_env_2d_frame)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_frame)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),90,___G_make_2d_table)
___DEF_SLBL(3,___L3_c_23_env_2d_frame)
   ___SET_R4(___R1)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___GOTO(___L6_c_23_env_2d_frame)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_new_2d_var_21_
#undef ___PH_LBL0
#define ___PH_LBL0 83
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L1_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L2_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L3_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L4_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L5_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L6_c_23_env_2d_new_2d_var_21_)
___DEF_P_HLBL(___L7_c_23_env_2d_new_2d_var_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_new_2d_var_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_env_2d_new_2d_var_21_)
   ___SET_R4(___VECTORREF(___R1,___FIX(4L)))
   ___SET_R4(___BOOLEAN(___FALSEP(___R4)))
   ___SET_R4(___BOOLEAN(___FALSEP(___R4)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_new_2d_var_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),88,___G_c_23_ptset_2d_empty)
___DEF_SLBL(2,___L2_c_23_env_2d_new_2d_var_21_)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),88,___G_c_23_ptset_2d_empty)
___DEF_SLBL(3,___L3_c_23_env_2d_new_2d_var_21_)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),49,___G_c_23_next_2d_var_2d_stamp)
___DEF_SLBL(4,___L4_c_23_env_2d_new_2d_var_21_)
   ___BEGIN_ALLOC_VECTOR(12UL)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_var_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-9))
   ___ADD_VECTOR_ELEM(2,___STK(-7))
   ___ADD_VECTOR_ELEM(3,___STK(-6))
   ___ADD_VECTOR_ELEM(4,___STK(-5))
   ___ADD_VECTOR_ELEM(5,___STK(-8))
   ___ADD_VECTOR_ELEM(6,___FAL)
   ___ADD_VECTOR_ELEM(7,___FAL)
   ___ADD_VECTOR_ELEM(8,___R1)
   ___ADD_VECTOR_ELEM(9,___FAL)
   ___ADD_VECTOR_ELEM(10,___FAL)
   ___ADD_VECTOR_ELEM(11,___FAL)
   ___END_ALLOC_VECTOR(12)
   ___SET_R1(___GET_VECTOR(12))
   ___SET_STK(-9,___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_env_2d_new_2d_var_21_)
   ___JUMPINT(___SET_NARGS(1),___PRC(116),___L_c_23_env_2d_vars_2d_ref)
___DEF_SLBL(6,___L6_c_23_env_2d_new_2d_var_21_)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(0L)))
   ___SETCAR(___R2,___R1)
   ___SET_R1(___STK(-5))
   ___ADJFP(-7)
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_env_2d_new_2d_var_21_)
   ___ADJFP(-1)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_macro
#undef ___PH_LBL0
#define ___PH_LBL0 92
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_macro)
___DEF_P_HLBL(___L1_c_23_env_2d_macro)
___DEF_P_HLBL(___L2_c_23_env_2d_macro)
___DEF_P_HLBL(___L3_c_23_env_2d_macro)
___DEF_P_HLBL(___L4_c_23_env_2d_macro)
___DEF_P_HLBL(___L5_c_23_env_2d_macro)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_macro)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_env_2d_macro)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_macro)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(174),___L_c_23_full_2d_name_3f_)
___DEF_SLBL(2,___L2_c_23_env_2d_macro)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L8_c_23_env_2d_macro)
   ___END_IF
   ___SET_R1(___FAL)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L6_c_23_env_2d_macro)
   ___END_IF
   ___GOTO(___L7_c_23_env_2d_macro)
___DEF_SLBL(3,___L3_c_23_env_2d_macro)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7_c_23_env_2d_macro)
   ___END_IF
___DEF_GLBL(___L6_c_23_env_2d_macro)
   ___SET_R1(___CONS(___R1,___STK(-4)))
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_env_2d_macro)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_macro)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(99),___L_c_23_env_2d_macros_2d_set)
___DEF_GLBL(___L7_c_23_env_2d_macro)
   ___SET_R1(___STK(-5))
   ___GOTO(___L6_c_23_env_2d_macro)
___DEF_GLBL(___L8_c_23_env_2d_macro)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(130),___L_c_23_env_2d_namespace_2d_lookup)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_macros_2d_set
#undef ___PH_LBL0
#define ___PH_LBL0 99
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_macros_2d_set)
___DEF_P_HLBL(___L1_c_23_env_2d_macros_2d_set)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_macros_2d_set)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_macros_2d_set)
   ___SET_R3(___VECTORREF(___R1,___FIX(5L)))
   ___SET_R4(___VECTORREF(___R1,___FIX(4L)))
   ___SET_STK(1,___VECTORREF(___R1,___FIX(3L)))
   ___SET_STK(2,___VECTORREF(___R1,___FIX(2L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(6UL)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R2)
   ___ADD_VECTOR_ELEM(2,___STK(2))
   ___ADD_VECTOR_ELEM(3,___STK(1))
   ___ADD_VECTOR_ELEM(4,___R4)
   ___ADD_VECTOR_ELEM(5,___R3)
   ___END_ALLOC_VECTOR(6)
   ___SET_R1(___GET_VECTOR(6))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_macros_2d_set)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_declare
#undef ___PH_LBL0
#define ___PH_LBL0 102
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_declare)
___DEF_P_HLBL(___L1_c_23_env_2d_declare)
___DEF_P_HLBL(___L2_c_23_env_2d_declare)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_declare)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_declare)
   ___SET_R3(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R2(___CONS(___R2,___R3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_declare)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_declare)
   ___JUMPINT(___SET_NARGS(2),___PRC(106),___L_c_23_env_2d_decl_2d_set)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_decl_2d_set
#undef ___PH_LBL0
#define ___PH_LBL0 106
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_decl_2d_set)
___DEF_P_HLBL(___L1_c_23_env_2d_decl_2d_set)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_decl_2d_set)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_decl_2d_set)
   ___SET_R3(___VECTORREF(___R1,___FIX(5L)))
   ___SET_R4(___VECTORREF(___R1,___FIX(4L)))
   ___SET_STK(1,___VECTORREF(___R1,___FIX(3L)))
   ___SET_STK(2,___VECTORREF(___R1,___FIX(1L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(6UL)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___STK(2))
   ___ADD_VECTOR_ELEM(2,___R2)
   ___ADD_VECTOR_ELEM(3,___STK(1))
   ___ADD_VECTOR_ELEM(4,___R4)
   ___ADD_VECTOR_ELEM(5,___R3)
   ___END_ALLOC_VECTOR(6)
   ___SET_R1(___GET_VECTOR(6))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_decl_2d_set)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace
#undef ___PH_LBL0
#define ___PH_LBL0 109
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_namespace)
___DEF_P_HLBL(___L1_c_23_env_2d_namespace)
___DEF_P_HLBL(___L2_c_23_env_2d_namespace)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_namespace)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_namespace)
   ___SET_R3(___VECTORREF(___R1,___FIX(3L)))
   ___SET_R2(___CONS(___R2,___R3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_namespace)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_namespace)
   ___JUMPINT(___SET_NARGS(2),___PRC(113),___L_c_23_env_2d_namespace_2d_set)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace_2d_set
#undef ___PH_LBL0
#define ___PH_LBL0 113
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_namespace_2d_set)
___DEF_P_HLBL(___L1_c_23_env_2d_namespace_2d_set)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_namespace_2d_set)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_namespace_2d_set)
   ___SET_R3(___VECTORREF(___R1,___FIX(5L)))
   ___SET_R4(___VECTORREF(___R1,___FIX(4L)))
   ___SET_STK(1,___VECTORREF(___R1,___FIX(2L)))
   ___SET_STK(2,___VECTORREF(___R1,___FIX(1L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(6UL)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___STK(2))
   ___ADD_VECTOR_ELEM(2,___STK(1))
   ___ADD_VECTOR_ELEM(3,___R2)
   ___ADD_VECTOR_ELEM(4,___R4)
   ___ADD_VECTOR_ELEM(5,___R3)
   ___END_ALLOC_VECTOR(6)
   ___SET_R1(___GET_VECTOR(6))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_namespace_2d_set)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_vars_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 116
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_vars_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_vars_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_vars_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___CAR(___R1))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_vars_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 118
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_vars_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_vars_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_vars_2d_set_21_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SETCAR(___R1,___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_macros_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 120
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_macros_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_macros_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_macros_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_decl_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 122
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_decl_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_decl_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_decl_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 124
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_namespace_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_namespace_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_namespace_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_parent_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 126
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_parent_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_parent_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_parent_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_externals_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 128
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_externals_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_externals_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_externals_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___FIX(5L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace_2d_lookup
#undef ___PH_LBL0
#define ___PH_LBL0 130
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L1_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L2_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L3_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L4_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L5_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L6_c_23_env_2d_namespace_2d_lookup)
___DEF_P_HLBL(___L7_c_23_env_2d_namespace_2d_lookup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_namespace_2d_lookup)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_namespace_2d_lookup)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_namespace_2d_lookup)
   ___GOTO(___L8_c_23_env_2d_namespace_2d_lookup)
___DEF_SLBL(2,___L2_c_23_env_2d_namespace_2d_lookup)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L14_c_23_env_2d_namespace_2d_lookup)
   ___END_IF
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_env_2d_namespace_2d_lookup)
___DEF_GLBL(___L8_c_23_env_2d_namespace_2d_lookup)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L12_c_23_env_2d_namespace_2d_lookup)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___SET_R3(___CDR(___R3))
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L9_c_23_env_2d_namespace_2d_lookup)
   ___END_IF
   ___SET_R2(___R1)
   ___SET_R1(___R4)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_namespace_2d_lookup)
   ___JUMPINT(___SET_NARGS(2),___PRC(179),___L_c_23_make_2d_full_2d_name)
___DEF_GLBL(___L9_c_23_env_2d_namespace_2d_lookup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R4)
   ___SET_R2(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_namespace_2d_lookup)
   ___GOTO(___L11_c_23_env_2d_namespace_2d_lookup)
___DEF_GLBL(___L10_c_23_env_2d_namespace_2d_lookup)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L13_c_23_env_2d_namespace_2d_lookup)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_namespace_2d_lookup)
___DEF_GLBL(___L11_c_23_env_2d_namespace_2d_lookup)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L10_c_23_env_2d_namespace_2d_lookup)
   ___END_IF
___DEF_GLBL(___L12_c_23_env_2d_namespace_2d_lookup)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L13_c_23_env_2d_namespace_2d_lookup)
   ___SET_R1(___R3)
   ___JUMPRET(___R0)
___DEF_GLBL(___L14_c_23_env_2d_namespace_2d_lookup)
   ___SET_R2(___CDR(___R1))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_namespace_2d_lookup)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(179),___L_c_23_make_2d_full_2d_name)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace_2d_lookup_2d_both
#undef ___PH_LBL0
#define ___PH_LBL0 139
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L1_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L2_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L3_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L4_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L5_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L6_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L7_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L8_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L9_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_P_HLBL(___L10_c_23_env_2d_namespace_2d_lookup_2d_both)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___GOTO(___L11_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_SLBL(2,___L2_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L17_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___END_IF
   ___SET_R2(___CDR(___STK(-8)))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_GLBL(___L11_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L15_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___CDR(___R3))
   ___ADJFP(1)
   ___IF(___NOT(___NULLP(___STK(0))))
   ___GOTO(___L12_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___END_IF
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___R4)
   ___ADJFP(7)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(179),___L_c_23_make_2d_full_2d_name)
___DEF_SLBL(5,___L5_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R1(___CONS(___R1,___STK(-6)))
   ___ADJFP(-7)
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___ADJFP(-1)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L12_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___STK(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(11)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___GOTO(___L14_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_GLBL(___L13_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L16_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_GLBL(___L14_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L13_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___END_IF
___DEF_GLBL(___L15_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L16_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R1(___R3)
   ___JUMPRET(___R0)
___DEF_GLBL(___L17_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R2(___CDR(___R1))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(179),___L_c_23_make_2d_full_2d_name)
___DEF_SLBL(9,___L9_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___SET_R1(___CONS(___R1,___STK(-3)))
   ___ADJFP(-6)
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_env_2d_namespace_2d_lookup_2d_both)
   ___ADJFP(-2)
   ___JUMPRET(___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup
#undef ___PH_LBL0
#define ___PH_LBL0 151
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_lookup)
___DEF_P_HLBL(___L1_c_23_env_2d_lookup)
___DEF_P_HLBL(___L2_c_23_env_2d_lookup)
___DEF_P_HLBL(___L3_c_23_env_2d_lookup)
___DEF_P_HLBL(___L4_c_23_env_2d_lookup)
___DEF_P_HLBL(___L5_c_23_env_2d_lookup)
___DEF_P_HLBL(___L6_c_23_env_2d_lookup)
___DEF_P_HLBL(___L7_c_23_env_2d_lookup)
___DEF_P_HLBL(___L8_c_23_env_2d_lookup)
___DEF_P_HLBL(___L9_c_23_env_2d_lookup)
___DEF_P_HLBL(___L10_c_23_env_2d_lookup)
___DEF_P_HLBL(___L11_c_23_env_2d_lookup)
___DEF_P_HLBL(___L12_c_23_env_2d_lookup)
___DEF_P_HLBL(___L13_c_23_env_2d_lookup)
___DEF_P_HLBL(___L14_c_23_env_2d_lookup)
___DEF_P_HLBL(___L15_c_23_env_2d_lookup)
___DEF_P_HLBL(___L16_c_23_env_2d_lookup)
___DEF_P_HLBL(___L17_c_23_env_2d_lookup)
___DEF_P_HLBL(___L18_c_23_env_2d_lookup)
___DEF_P_HLBL(___L19_c_23_env_2d_lookup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_lookup)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_env_2d_lookup)
   ___SET_STK(1,___STK(0))
   ___SET_STK(0,___R2)
   ___SET_STK(2,___STK(1))
   ___SET_STK(1,___R3)
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_lookup)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(174),___L_c_23_full_2d_name_3f_)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-4))
   ___ADJFP(-6)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup)
   ___GOTO(___L22_c_23_env_2d_lookup)
___DEF_GLBL(___L20_c_23_env_2d_lookup)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(1L)))
   ___ADJFP(1)
   ___IF(___EQP(___STK(0),___R1))
   ___GOTO(___L30_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup)
___DEF_GLBL(___L21_c_23_env_2d_lookup)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L20_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R3(___VECTORREF(___STK(0),___FIX(4L)))
   ___IF(___NOTFALSEP(___STK(-2)))
   ___GOTO(___L31_c_23_env_2d_lookup)
   ___END_IF
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L31_c_23_env_2d_lookup)
   ___END_IF
   ___SET_STK(0,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_lookup)
___DEF_GLBL(___L22_c_23_env_2d_lookup)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L28_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R3(___TRU)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_lookup)
___DEF_GLBL(___L23_c_23_env_2d_lookup)
   ___SET_STK(1,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___SET_STK(2,___R3)
   ___SET_R3(___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___STK(2))
   ___SET_R1(___STK(3))
   ___ADJFP(1)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_lookup)
___DEF_GLBL(___L24_c_23_env_2d_lookup)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L27_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___CAR(___R4))
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___STK(0),___R1)))
   ___GOTO(___L26_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R3(___CDR(___R4))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-1))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_lookup)
___DEF_GLBL(___L25_c_23_env_2d_lookup)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(2))
___DEF_GLBL(___L26_c_23_env_2d_lookup)
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_env_2d_lookup)
   ___GOTO(___L24_c_23_env_2d_lookup)
___DEF_GLBL(___L27_c_23_env_2d_lookup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___STK(0))
   ___ADJFP(9)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_env_2d_lookup)
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(1),___PRC(116),___L_c_23_env_2d_vars_2d_ref)
___DEF_SLBL(11,___L11_c_23_env_2d_lookup)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___ADJFP(-9)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_env_2d_lookup)
   ___GOTO(___L21_c_23_env_2d_lookup)
___DEF_GLBL(___L28_c_23_env_2d_lookup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___ADJFP(6)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_env_2d_lookup)
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(2),___PRC(139),___L_c_23_env_2d_namespace_2d_lookup_2d_both)
___DEF_SLBL(14,___L14_c_23_env_2d_lookup)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L29_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R3(___FAL)
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_env_2d_lookup)
   ___GOTO(___L23_c_23_env_2d_lookup)
___DEF_GLBL(___L29_c_23_env_2d_lookup)
   ___SET_R2(___CAR(___R1))
   ___SET_R3(___CDR(___R1))
   ___SET_R4(___VECTORREF(___STK(-4),___FIX(5L)))
   ___SET_STK(-3,___R1)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),91,___G_table_2d_set_21_)
___DEF_SLBL(16,___L16_c_23_env_2d_lookup)
   ___SET_R2(___CAR(___STK(-3)))
   ___SET_R1(___STK(-4))
   ___SET_R3(___TRU)
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_env_2d_lookup)
   ___GOTO(___L23_c_23_env_2d_lookup)
___DEF_GLBL(___L30_c_23_env_2d_lookup)
   ___SET_R3(___R4)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-1))
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_env_2d_lookup)
   ___GOTO(___L25_c_23_env_2d_lookup)
___DEF_GLBL(___L31_c_23_env_2d_lookup)
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___SET_R3(___FAL)
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_env_2d_lookup)
   ___ADJFP(-3)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_namespace_2d_valid_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 172
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_namespace_2d_valid_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_namespace_2d_valid_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_namespace_2d_valid_3f_)
   ___SET_R2(___STRINGLENGTH(___R1))
   ___IF(___FIXEQ(___R2,___FIX(0L)))
   ___GOTO(___L2_c_23_namespace_2d_valid_3f_)
   ___END_IF
   ___IF(___NOT(___FIXGE(___R2,___FIX(2L))))
   ___GOTO(___L1_c_23_namespace_2d_valid_3f_)
   ___END_IF
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___STRINGREF(___R1,___R2))
   ___SET_R1(___BOOLEAN(___CHAREQP(___R1,___CHR(35))))
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_namespace_2d_valid_3f_)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L2_c_23_namespace_2d_valid_3f_)
   ___SET_R1(___TRU)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_full_2d_name_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 174
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_full_2d_name_3f_)
___DEF_P_HLBL(___L1_c_23_full_2d_name_3f_)
___DEF_P_HLBL(___L2_c_23_full_2d_name_3f_)
___DEF_P_HLBL(___L3_c_23_full_2d_name_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_full_2d_name_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_full_2d_name_3f_)
   ___IF(___SYMBOL2STRINGP_NOTFALSEP(___R2,___R1))
   ___GOTO(___L4_c_23_full_2d_name_3f_)
   ___END_IF
   ___SET_R2(___FAL)
   ___GOTO(___L8_c_23_full_2d_name_3f_)
___DEF_SLBL(1,___L1_c_23_full_2d_name_3f_)
   ___SET_R2(___R1)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L4_c_23_full_2d_name_3f_)
   ___SET_R1(___STRINGLENGTH(___R2))
   ___SET_R1(___FIXSUB(___R1,___FIX(1L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_full_2d_name_3f_)
___DEF_GLBL(___L5_c_23_full_2d_name_3f_)
   ___IF(___FIXLT(___R2,___FIX(0L)))
   ___GOTO(___L7_c_23_full_2d_name_3f_)
   ___END_IF
   ___SET_R3(___STRINGREF(___R1,___R2))
   ___IF(___CHAREQP(___R3,___CHR(35)))
   ___GOTO(___L6_c_23_full_2d_name_3f_)
   ___END_IF
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_full_2d_name_3f_)
   ___GOTO(___L5_c_23_full_2d_name_3f_)
___DEF_GLBL(___L6_c_23_full_2d_name_3f_)
   ___SET_R1(___TRU)
   ___JUMPRET(___R0)
___DEF_GLBL(___L7_c_23_full_2d_name_3f_)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L8_c_23_full_2d_name_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_symbol_2d__3e_string)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_full_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 179
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_full_2d_name)
___DEF_P_HLBL(___L1_c_23_make_2d_full_2d_name)
___DEF_P_HLBL(___L2_c_23_make_2d_full_2d_name)
___DEF_P_HLBL(___L3_c_23_make_2d_full_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_full_2d_name)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_make_2d_full_2d_name)
   ___SET_R3(___STRINGLENGTH(___R1))
   ___IF(___FIXEQ(___R3,___FIX(0L)))
   ___GOTO(___L5_c_23_make_2d_full_2d_name)
   ___END_IF
   ___SET_STK(1,___R0)
   ___ADJFP(1)
   ___IF(___SYMBOL2STRINGP_NOTFALSEP(___R3,___R2))
   ___GOTO(___L4_c_23_make_2d_full_2d_name)
   ___END_IF
   ___SET_R3(___FAL)
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_symbol_2d__3e_string)
___DEF_SLBL(1,___L1_c_23_make_2d_full_2d_name)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___ADJFP(-7)
___DEF_GLBL(___L4_c_23_make_2d_full_2d_name)
   ___SET_R2(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(3)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_string_2d_append)
___DEF_SLBL(2,___L2_c_23_make_2d_full_2d_name)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_make_2d_full_2d_name)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_string_2d__3e_symbol)
___DEF_GLBL(___L5_c_23_make_2d_full_2d_name)
   ___SET_R1(___R2)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 184
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L1_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L2_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L3_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L4_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L5_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L6_c_23_env_2d_lookup_2d_var)
___DEF_P_HLBL(___L7_c_23_env_2d_lookup_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_lookup_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_env_2d_lookup_2d_var)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___ALLOC_CLO(1UL))
   ___BEGIN_SETUP_CLO(1,___STK(2),3)
   ___ADD_CLO_ELEM(0,___R3)
   ___END_SETUP_CLO(1)
   ___SET_R3(___STK(2))
   ___SET_R1(___R2)
   ___SET_R2(___FAL)
   ___ADJFP(2)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_lookup_2d_var)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup_2d_var)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(4),___PRC(151),___L_c_23_env_2d_lookup)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(3,3,0,0)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L9_c_23_env_2d_lookup_2d_var)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R1(___R3)
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup_2d_var)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(11),___L_c_23_var_3f_)
___DEF_SLBL(5,___L5_c_23_env_2d_lookup_2d_var)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L8_c_23_env_2d_lookup_2d_var)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_lookup_2d_var)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),83,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L8_c_23_env_2d_lookup_2d_var)
   ___SET_R1(___STK(-5))
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L9_c_23_env_2d_lookup_2d_var)
   ___SET_R3(___CLO(___R4,1))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_lookup_2d_var)
   ___JUMPINT(___SET_NARGS(3),___PRC(83),___L_c_23_env_2d_new_2d_var_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_define_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 193
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L1_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L2_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L3_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L4_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L5_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L6_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L7_c_23_env_2d_define_2d_var)
___DEF_P_HLBL(___L8_c_23_env_2d_define_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_define_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_env_2d_define_2d_var)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___ALLOC_CLO(1UL))
   ___BEGIN_SETUP_CLO(1,___STK(2),3)
   ___ADD_CLO_ELEM(0,___R3)
   ___END_SETUP_CLO(1)
   ___SET_R3(___STK(2))
   ___SET_R1(___R2)
   ___SET_R2(___TRU)
   ___ADJFP(2)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_define_2d_var)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_define_2d_var)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(4),___PRC(151),___L_c_23_env_2d_lookup)
___DEF_SLBL(3,___L3_c_23_env_2d_define_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(3,3,0,0)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L10_c_23_env_2d_define_2d_var)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R4)
   ___SET_R1(___R3)
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_define_2d_var)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(11),___L_c_23_var_3f_)
___DEF_SLBL(5,___L5_c_23_env_2d_define_2d_var)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L9_c_23_env_2d_define_2d_var)
   ___END_IF
   ___SET_R1(___CLO(___STK(-5),1))
   ___SET_R2(___SUB(1))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_define_2d_var)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),87,___G_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L9_c_23_env_2d_define_2d_var)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(2))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_define_2d_var)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),83,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L10_c_23_env_2d_define_2d_var)
   ___SET_R3(___CLO(___R4,1))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_define_2d_var)
   ___JUMPINT(___SET_NARGS(3),___PRC(83),___L_c_23_env_2d_new_2d_var_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup_2d_global_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 203
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_P_HLBL(___L1_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_P_HLBL(___L2_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_P_HLBL(___L3_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_P_HLBL(___L4_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_P_HLBL(___L5_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_P_HLBL(___L6_c_23_env_2d_lookup_2d_global_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_lookup_2d_global_2d_var)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(215),___L_c_23_env_2d_global_2d_env)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(116),___L_c_23_env_2d_vars_2d_ref)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup_2d_global_2d_var)
   ___GOTO(___L8_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_GLBL(___L7_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(1L)))
   ___ADJFP(1)
   ___IF(___EQP(___STK(0),___R1))
   ___GOTO(___L9_c_23_env_2d_lookup_2d_global_2d_var)
   ___END_IF
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_GLBL(___L8_c_23_env_2d_lookup_2d_global_2d_var)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L7_c_23_env_2d_lookup_2d_global_2d_var)
   ___END_IF
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___SET_R3(___FAL)
   ___ADJFP(1)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_lookup_2d_global_2d_var)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(3),___PRC(83),___L_c_23_env_2d_new_2d_var_21_)
___DEF_GLBL(___L9_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_R1(___R4)
   ___ADJFP(-1)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_global_2d_variables
#undef ___PH_LBL0
#define ___PH_LBL0 211
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_global_2d_variables)
___DEF_P_HLBL(___L1_c_23_env_2d_global_2d_variables)
___DEF_P_HLBL(___L2_c_23_env_2d_global_2d_variables)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_global_2d_variables)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_global_2d_variables)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_global_2d_variables)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(215),___L_c_23_env_2d_global_2d_env)
___DEF_SLBL(2,___L2_c_23_env_2d_global_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___CAR(___R1))
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_global_2d_env
#undef ___PH_LBL0
#define ___PH_LBL0 215
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_global_2d_env)
___DEF_P_HLBL(___L1_c_23_env_2d_global_2d_env)
___DEF_P_HLBL(___L2_c_23_env_2d_global_2d_env)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_global_2d_env)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_global_2d_env)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_global_2d_env)
   ___GOTO(___L4_c_23_env_2d_global_2d_env)
___DEF_GLBL(___L3_c_23_env_2d_global_2d_env)
   ___SET_R1(___R2)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_global_2d_env)
___DEF_GLBL(___L4_c_23_env_2d_global_2d_env)
   ___SET_R2(___VECTORREF(___R1,___FIX(4L)))
   ___IF(___NOTFALSEP(___R2))
   ___GOTO(___L3_c_23_env_2d_global_2d_env)
   ___END_IF
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup_2d_macro
#undef ___PH_LBL0
#define ___PH_LBL0 219
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_lookup_2d_macro)
___DEF_P_HLBL(___L1_c_23_env_2d_lookup_2d_macro)
___DEF_P_HLBL(___L2_c_23_env_2d_lookup_2d_macro)
___DEF_P_HLBL(___L3_c_23_env_2d_lookup_2d_macro)
___DEF_P_HLBL(___L4_c_23_env_2d_lookup_2d_macro)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_lookup_2d_macro)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_lookup_2d_macro)
   ___SET_STK(1,___R1)
   ___SET_R3(___LBL(2))
   ___SET_R1(___R2)
   ___SET_R2(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_lookup_2d_macro)
   ___JUMPINT(___SET_NARGS(4),___PRC(151),___L_c_23_env_2d_lookup)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup_2d_macro)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(2,3,0,0)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L5_c_23_env_2d_lookup_2d_macro)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R3)
   ___SET_R1(___R3)
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup_2d_macro)
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(11),___L_c_23_var_3f_)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup_2d_macro)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6_c_23_env_2d_lookup_2d_macro)
   ___END_IF
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L5_c_23_env_2d_lookup_2d_macro)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L6_c_23_env_2d_lookup_2d_macro)
   ___SET_R1(___STK(-6))
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_flag_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 225
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_define_2d_flag_2d_decl)
___DEF_P_HLBL(___L1_c_23_define_2d_flag_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_define_2d_flag_2d_decl)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_define_2d_flag_2d_decl)
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_R1(___CONS(___R1,___GLO_c_23_flag_2d_declarations))
   ___SET_GLO(38,___G_c_23_flag_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_flag_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_parameterized_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 228
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_define_2d_parameterized_2d_decl)
___DEF_P_HLBL(___L1_c_23_define_2d_parameterized_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_define_2d_parameterized_2d_decl)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_define_2d_parameterized_2d_decl)
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_R1(___CONS(___R1,___GLO_c_23_parameterized_2d_declarations))
   ___SET_GLO(51,___G_c_23_parameterized_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_parameterized_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 231
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_define_2d_boolean_2d_decl)
___DEF_P_HLBL(___L1_c_23_define_2d_boolean_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_define_2d_boolean_2d_decl)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_define_2d_boolean_2d_decl)
   ___SET_R1(___CONS(___R1,___GLO_c_23_boolean_2d_declarations))
   ___SET_GLO(2,___G_c_23_boolean_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_boolean_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_namable_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 234
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_define_2d_namable_2d_decl)
___DEF_P_HLBL(___L1_c_23_define_2d_namable_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_define_2d_namable_2d_decl)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_define_2d_namable_2d_decl)
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_R1(___CONS(___R1,___GLO_c_23_namable_2d_declarations))
   ___SET_GLO(47,___G_c_23_namable_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_namable_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_namable_2d_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 237
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_P_HLBL(___L1_c_23_define_2d_namable_2d_boolean_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_define_2d_namable_2d_boolean_2d_decl)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_define_2d_namable_2d_boolean_2d_decl)
   ___SET_R1(___CONS(___R1,___GLO_c_23_namable_2d_boolean_2d_declarations))
   ___SET_GLO(45,___G_c_23_namable_2d_boolean_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_namable_2d_boolean_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_flag_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 240
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_flag_2d_decl)
___DEF_P_HLBL(___L1_c_23_flag_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_flag_2d_decl)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_flag_2d_decl)
   ___BEGIN_ALLOC_LIST(2UL,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_flag_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parameterized_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 243
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_parameterized_2d_decl)
___DEF_P_HLBL(___L1_c_23_parameterized_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_parameterized_2d_decl)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_parameterized_2d_decl)
   ___BEGIN_ALLOC_LIST(2UL,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_parameterized_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 246
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_boolean_2d_decl)
___DEF_P_HLBL(___L1_c_23_boolean_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_boolean_2d_decl)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_boolean_2d_decl)
   ___BEGIN_ALLOC_LIST(2UL,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_boolean_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_namable_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 249
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_namable_2d_decl)
___DEF_P_HLBL(___L1_c_23_namable_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_namable_2d_decl)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_namable_2d_decl)
   ___SET_R2(___CONS(___R2,___R3))
   ___SET_R1(___CONS(___R1,___R2))
   ___ADJFP(-1)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_namable_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_namable_2d_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 252
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_namable_2d_boolean_2d_decl)
___DEF_P_HLBL(___L1_c_23_namable_2d_boolean_2d_decl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_namable_2d_boolean_2d_decl)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_namable_2d_boolean_2d_decl)
   ___SET_R2(___CONS(___R2,___R3))
   ___SET_R1(___CONS(___R1,___R2))
   ___ADJFP(-1)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_namable_2d_boolean_2d_decl)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_declaration_2d_value
#undef ___PH_LBL0
#define ___PH_LBL0 255
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_declaration_2d_value)
___DEF_P_HLBL(___L1_c_23_declaration_2d_value)
___DEF_P_HLBL(___L2_c_23_declaration_2d_value)
___DEF_P_HLBL(___L3_c_23_declaration_2d_value)
___DEF_P_HLBL(___L4_c_23_declaration_2d_value)
___DEF_P_HLBL(___L5_c_23_declaration_2d_value)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_declaration_2d_value)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_declaration_2d_value)
   ___SET_R3(___VECTORREF(___R3,___FIX(2L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_declaration_2d_value)
   ___GOTO(___L7_c_23_declaration_2d_value)
___DEF_SLBL(2,___L2_c_23_declaration_2d_value)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L11_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-10)
___DEF_GLBL(___L6_c_23_declaration_2d_value)
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_declaration_2d_value)
___DEF_GLBL(___L7_c_23_declaration_2d_value)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L13_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___CAR(___R4))
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___STK(0),___STK(-1))))
   ___GOTO(___L6_c_23_declaration_2d_value)
   ___END_IF
   ___SET_STK(0,___CDDR(___R4))
   ___IF(___NULLP(___STK(0)))
   ___GOTO(___L12_c_23_declaration_2d_value)
   ___END_IF
   ___SET_STK(0,___CDDR(___R4))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___STK(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(10)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_declaration_2d_value)
___DEF_GLBL(___L8_c_23_declaration_2d_value)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L10_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L9_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_declaration_2d_value)
   ___GOTO(___L8_c_23_declaration_2d_value)
___DEF_GLBL(___L9_c_23_declaration_2d_value)
   ___SET_R1(___R2)
   ___JUMPRET(___R0)
___DEF_GLBL(___L10_c_23_declaration_2d_value)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L11_c_23_declaration_2d_value)
   ___SET_R4(___STK(-5))
   ___SET_R0(___STK(-9))
   ___ADJFP(-10)
___DEF_GLBL(___L12_c_23_declaration_2d_value)
   ___SET_R1(___CADR(___R4))
   ___ADJFP(-2)
   ___JUMPRET(___R0)
___DEF_GLBL(___L13_c_23_declaration_2d_value)
   ___SET_R1(___R2)
   ___ADJFP(-1)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2e_begin_21_
#undef ___PH_LBL0
#define ___PH_LBL0 262
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2e_begin_21_)
___DEF_P_HLBL(___L1_c_23_env_2e_begin_21_)
___DEF_P_HLBL(___L2_c_23_env_2e_begin_21_)
___DEF_P_HLBL(___L3_c_23_env_2e_begin_21_)
___DEF_P_HLBL(___L4_c_23_env_2e_begin_21_)
___DEF_P_HLBL(___L5_c_23_env_2e_begin_21_)
___DEF_P_HLBL(___L6_c_23_env_2e_begin_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2e_begin_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_env_2e_begin_21_)
   ___SET_STK(1,___R0)
   ___SET_R1(___FIX(0L))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2e_begin_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),84,___G_c_23_make_2d_counter)
___DEF_SLBL(2,___L2_c_23_env_2e_begin_21_)
   ___SET_GLO(49,___G_c_23_next_2d_var_2d_stamp,___R1)
   ___SET_R1(___SYM_ret)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(66),___L_c_23_make_2d_temp_2d_var)
___DEF_SLBL(3,___L3_c_23_env_2e_begin_21_)
   ___SET_GLO(53,___G_c_23_ret_2d_var,___R1)
   ___SET_R1(___GLO_c_23_ret_2d_var)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),89,___G_c_23_varset_2d_singleton)
___DEF_SLBL(4,___L4_c_23_env_2e_begin_21_)
   ___SET_GLO(54,___G_c_23_ret_2d_var_2d_set,___R1)
   ___SET_R1(___SYM_closure_2d_env)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(66),___L_c_23_make_2d_temp_2d_var)
___DEF_SLBL(5,___L5_c_23_env_2e_begin_21_)
   ___SET_GLO(3,___G_c_23_closure_2d_env_2d_var,___R1)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(66),___L_c_23_make_2d_temp_2d_var)
___DEF_SLBL(6,___L6_c_23_env_2e_begin_21_)
   ___SET_GLO(10,___G_c_23_empty_2d_var,___R1)
   ___SET_R1(___NUL)
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2e_end_21_
#undef ___PH_LBL0
#define ___PH_LBL0 270
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2e_end_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2e_end_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_env_2e_end_21_)
   ___SET_GLO(49,___G_c_23_next_2d_var_2d_stamp,___NUL)
   ___SET_GLO(53,___G_c_23_ret_2d_var,___NUL)
   ___SET_GLO(54,___G_c_23_ret_2d_var_2d_set,___NUL)
   ___SET_GLO(3,___G_c_23_closure_2d_env_2d_var,___NUL)
   ___SET_GLO(10,___G_c_23_empty_2d_var,___NUL)
   ___SET_R1(___NUL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___env_23_,___REF_SYM(1,___S___env_23_),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___env_23_,0,-1)
,___DEF_LBL_RET(___H___env_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H___env_23_,0,-1)
,___DEF_LBL_RET(___H___env_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_var,___REF_SYM(39,___S_c_23_make_2d_var),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_var,6,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_var,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_make_2d_var,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_make_2d_var,___IFD(___RETI,4,3,0x3f8L))
,___DEF_LBL_INTRO(___H_c_23_var_3f_,___REF_SYM(68,___S_c_23_var_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_name,___REF_SYM(56,___S_c_23_var_2d_name),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_name,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_bound,___REF_SYM(45,___S_c_23_var_2d_bound),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_bound,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_refs,___REF_SYM(58,___S_c_23_var_2d_refs),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_refs,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_sets,___REF_SYM(60,___S_c_23_var_2d_sets),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_sets,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_source,___REF_SYM(62,___S_c_23_var_2d_source),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_source,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_boxed_3f_,___REF_SYM(47,___S_c_23_var_2d_boxed_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_boxed_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_info,___REF_SYM(53,___S_c_23_var_2d_info),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_info,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_stamp,___REF_SYM(64,___S_c_23_var_2d_stamp),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_stamp,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_constant,___REF_SYM(51,___S_c_23_var_2d_constant),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_constant,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_clone,___REF_SYM(49,___S_c_23_var_2d_clone),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_clone,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_temp_3f_,___REF_SYM(66,___S_c_23_var_2d_temp_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_temp_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_name_2d_set_21_,___REF_SYM(57,___S_c_23_var_2d_name_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_name_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_bound_2d_set_21_,___REF_SYM(46,___S_c_23_var_2d_bound_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_bound_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_refs_2d_set_21_,___REF_SYM(59,___S_c_23_var_2d_refs_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_refs_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_sets_2d_set_21_,___REF_SYM(61,___S_c_23_var_2d_sets_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_sets_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_source_2d_set_21_,___REF_SYM(63,___S_c_23_var_2d_source_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_source_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_boxed_3f__2d_set_21_,___REF_SYM(48,___S_c_23_var_2d_boxed_3f__2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_boxed_3f__2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_info_2d_set_21_,___REF_SYM(54,___S_c_23_var_2d_info_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_info_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_stamp_2d_set_21_,___REF_SYM(65,___S_c_23_var_2d_stamp_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_stamp_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_constant_2d_set_21_,___REF_SYM(52,___S_c_23_var_2d_constant_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_constant_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_clone_2d_set_21_,___REF_SYM(50,___S_c_23_var_2d_clone_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_clone_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_temp_3f__2d_set_21_,___REF_SYM(67,___S_c_23_var_2d_temp_3f__2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_temp_3f__2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_lexical_2d_level,___REF_SYM(55,___S_c_23_var_2d_lexical_2d_level),___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_lexical_2d_level,1,-1)
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_temp_2d_var,___REF_SYM(38,___S_c_23_make_2d_temp_2d_var),___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_temp_2d_var,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETI,8,2,0x3f07L))
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETN,5,2,0x7L))
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETN,5,3,0xfL))
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_resize_2d_var_2d_list,___REF_SYM(44,___S_c_23_resize_2d_var_2d_list),___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_resize_2d_var_2d_list,2,-1)
,___DEF_LBL_RET(___H_c_23_resize_2d_var_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_resize_2d_var_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_resize_2d_var_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_resize_2d_var_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_frame,___REF_SYM(14,___S_c_23_env_2d_frame),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_frame,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_frame,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_frame,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_env_2d_frame,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_new_2d_var_21_,___REF_SYM(29,___S_c_23_env_2d_new_2d_var_21_),___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_new_2d_var_21_,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,9,0,0x7fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,1,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_macro,___REF_SYM(21,___S_c_23_env_2d_macro),___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_macro,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_macros_2d_set,___REF_SYM(23,___S_c_23_env_2d_macros_2d_set),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_macros_2d_set,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_macros_2d_set,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_declare,___REF_SYM(11,___S_c_23_env_2d_declare),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_declare,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_declare,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_declare,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_decl_2d_set,___REF_SYM(10,___S_c_23_env_2d_decl_2d_set),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_decl_2d_set,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_decl_2d_set,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace,___REF_SYM(24,___S_c_23_env_2d_namespace),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_namespace,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace_2d_set,___REF_SYM(28,___S_c_23_env_2d_namespace_2d_set),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace_2d_set,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_set,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_vars_2d_ref,___REF_SYM(31,___S_c_23_env_2d_vars_2d_ref),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_vars_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_vars_2d_set_21_,___REF_SYM(32,___S_c_23_env_2d_vars_2d_set_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_vars_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_macros_2d_ref,___REF_SYM(22,___S_c_23_env_2d_macros_2d_ref),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_macros_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_decl_2d_ref,___REF_SYM(9,___S_c_23_env_2d_decl_2d_ref),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_decl_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace_2d_ref,___REF_SYM(27,___S_c_23_env_2d_namespace_2d_ref),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_parent_2d_ref,___REF_SYM(30,___S_c_23_env_2d_parent_2d_ref),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_parent_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_externals_2d_ref,___REF_SYM(13,___S_c_23_env_2d_externals_2d_ref),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_externals_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace_2d_lookup,___REF_SYM(25,___S_c_23_env_2d_namespace_2d_lookup),___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace_2d_lookup,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___REF_SYM(26,___S_c_23_env_2d_namespace_2d_lookup_2d_both),___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace_2d_lookup_2d_both,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETN,9,1,0x3eL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETI,1,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___OFD(___RETI,12,1,0x3f03eL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETN,5,1,0x12L))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup_2d_both,___IFD(___RETI,2,1,0x3f2L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup,___REF_SYM(17,___S_c_23_env_2d_lookup),___REF_FAL,20,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup,4,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,8,3,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,4,4,0x3f2L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___OFD(___RETI,12,3,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,8,2,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,4,4,0x3f2L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f2L))
,___DEF_LBL_INTRO(___H_c_23_namespace_2d_valid_3f_,___REF_SYM(42,___S_c_23_namespace_2d_valid_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_namespace_2d_valid_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_full_2d_name_3f_,___REF_SYM(36,___S_c_23_full_2d_name_3f_),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_full_2d_name_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_full_2d_name,___REF_SYM(37,___S_c_23_make_2d_full_2d_name),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_full_2d_name,2,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup_2d_var,___REF_SYM(20,___S_c_23_env_2d_lookup_2d_var),___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_var,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_var,3,1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_define_2d_var,___REF_SYM(12,___S_c_23_env_2d_define_2d_var),___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_define_2d_var,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_env_2d_define_2d_var,3,1)
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup_2d_global_2d_var,___REF_SYM(18,___S_c_23_env_2d_lookup_2d_global_2d_var),___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_global_2d_var,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_global_2d_variables,___REF_SYM(16,___S_c_23_env_2d_global_2d_variables),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_global_2d_variables,1,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_variables,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_variables,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_global_2d_env,___REF_SYM(15,___S_c_23_env_2d_global_2d_env),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_global_2d_env,1,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_env,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_env,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup_2d_macro,___REF_SYM(19,___S_c_23_env_2d_lookup_2d_macro),___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_macro,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_macro,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23_define_2d_flag_2d_decl,___REF_SYM(5,___S_c_23_define_2d_flag_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_flag_2d_decl,2,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_flag_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_parameterized_2d_decl,___REF_SYM(8,___S_c_23_define_2d_parameterized_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_parameterized_2d_decl,2,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_parameterized_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_boolean_2d_decl,___REF_SYM(4,___S_c_23_define_2d_boolean_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_boolean_2d_decl,1,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_namable_2d_decl,___REF_SYM(7,___S_c_23_define_2d_namable_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_namable_2d_decl,2,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_namable_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_namable_2d_boolean_2d_decl,___REF_SYM(6,___S_c_23_define_2d_namable_2d_boolean_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_namable_2d_boolean_2d_decl,1,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_namable_2d_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_flag_2d_decl,___REF_SYM(35,___S_c_23_flag_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_flag_2d_decl,3,-1)
,___DEF_LBL_RET(___H_c_23_flag_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_parameterized_2d_decl,___REF_SYM(43,___S_c_23_parameterized_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_parameterized_2d_decl,3,-1)
,___DEF_LBL_RET(___H_c_23_parameterized_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_boolean_2d_decl,___REF_SYM(2,___S_c_23_boolean_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_boolean_2d_decl,3,-1)
,___DEF_LBL_RET(___H_c_23_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_namable_2d_decl,___REF_SYM(41,___S_c_23_namable_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_namable_2d_decl,4,-1)
,___DEF_LBL_RET(___H_c_23_namable_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_namable_2d_boolean_2d_decl,___REF_SYM(40,___S_c_23_namable_2d_boolean_2d_decl),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_namable_2d_boolean_2d_decl,4,-1)
,___DEF_LBL_RET(___H_c_23_namable_2d_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_declaration_2d_value,___REF_SYM(3,___S_c_23_declaration_2d_value),___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_declaration_2d_value,4,-1)
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2e_begin_21_,___REF_SYM(33,___S_c_23_env_2e_begin_21_),___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_env_2e_begin_21_,0,-1)
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_env_2e_end_21_,___REF_SYM(34,___S_c_23_env_2e_end_21_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2e_end_21_,0,-1)
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03eL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07dL)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___env_23_,1)
___DEF_MOD_PRM(43,___G_c_23_make_2d_var,6)
___DEF_MOD_PRM(79,___G_c_23_var_3f_,11)
___DEF_MOD_PRM(66,___G_c_23_var_2d_name,13)
___DEF_MOD_PRM(55,___G_c_23_var_2d_bound,15)
___DEF_MOD_PRM(68,___G_c_23_var_2d_refs,17)
___DEF_MOD_PRM(70,___G_c_23_var_2d_sets,19)
___DEF_MOD_PRM(72,___G_c_23_var_2d_source,21)
___DEF_MOD_PRM(57,___G_c_23_var_2d_boxed_3f_,23)
___DEF_MOD_PRM(63,___G_c_23_var_2d_info,25)
___DEF_MOD_PRM(74,___G_c_23_var_2d_stamp,27)
___DEF_MOD_PRM(61,___G_c_23_var_2d_constant,29)
___DEF_MOD_PRM(59,___G_c_23_var_2d_clone,31)
___DEF_MOD_PRM(77,___G_c_23_var_2d_temp_3f_,33)
___DEF_MOD_PRM(67,___G_c_23_var_2d_name_2d_set_21_,35)
___DEF_MOD_PRM(56,___G_c_23_var_2d_bound_2d_set_21_,37)
___DEF_MOD_PRM(69,___G_c_23_var_2d_refs_2d_set_21_,39)
___DEF_MOD_PRM(71,___G_c_23_var_2d_sets_2d_set_21_,41)
___DEF_MOD_PRM(73,___G_c_23_var_2d_source_2d_set_21_,43)
___DEF_MOD_PRM(58,___G_c_23_var_2d_boxed_3f__2d_set_21_,45)
___DEF_MOD_PRM(64,___G_c_23_var_2d_info_2d_set_21_,47)
___DEF_MOD_PRM(75,___G_c_23_var_2d_stamp_2d_set_21_,49)
___DEF_MOD_PRM(62,___G_c_23_var_2d_constant_2d_set_21_,51)
___DEF_MOD_PRM(60,___G_c_23_var_2d_clone_2d_set_21_,53)
___DEF_MOD_PRM(78,___G_c_23_var_2d_temp_3f__2d_set_21_,55)
___DEF_MOD_PRM(65,___G_c_23_var_2d_lexical_2d_level,57)
___DEF_MOD_PRM(42,___G_c_23_make_2d_temp_2d_var,66)
___DEF_MOD_PRM(52,___G_c_23_resize_2d_var_2d_list,72)
___DEF_MOD_PRM(16,___G_c_23_env_2d_frame,78)
___DEF_MOD_PRM(31,___G_c_23_env_2d_new_2d_var_21_,83)
___DEF_MOD_PRM(23,___G_c_23_env_2d_macro,92)
___DEF_MOD_PRM(25,___G_c_23_env_2d_macros_2d_set,99)
___DEF_MOD_PRM(13,___G_c_23_env_2d_declare,102)
___DEF_MOD_PRM(12,___G_c_23_env_2d_decl_2d_set,106)
___DEF_MOD_PRM(26,___G_c_23_env_2d_namespace,109)
___DEF_MOD_PRM(30,___G_c_23_env_2d_namespace_2d_set,113)
___DEF_MOD_PRM(33,___G_c_23_env_2d_vars_2d_ref,116)
___DEF_MOD_PRM(34,___G_c_23_env_2d_vars_2d_set_21_,118)
___DEF_MOD_PRM(24,___G_c_23_env_2d_macros_2d_ref,120)
___DEF_MOD_PRM(11,___G_c_23_env_2d_decl_2d_ref,122)
___DEF_MOD_PRM(29,___G_c_23_env_2d_namespace_2d_ref,124)
___DEF_MOD_PRM(32,___G_c_23_env_2d_parent_2d_ref,126)
___DEF_MOD_PRM(15,___G_c_23_env_2d_externals_2d_ref,128)
___DEF_MOD_PRM(27,___G_c_23_env_2d_namespace_2d_lookup,130)
___DEF_MOD_PRM(28,___G_c_23_env_2d_namespace_2d_lookup_2d_both,139)
___DEF_MOD_PRM(19,___G_c_23_env_2d_lookup,151)
___DEF_MOD_PRM(48,___G_c_23_namespace_2d_valid_3f_,172)
___DEF_MOD_PRM(39,___G_c_23_full_2d_name_3f_,174)
___DEF_MOD_PRM(40,___G_c_23_make_2d_full_2d_name,179)
___DEF_MOD_PRM(22,___G_c_23_env_2d_lookup_2d_var,184)
___DEF_MOD_PRM(14,___G_c_23_env_2d_define_2d_var,193)
___DEF_MOD_PRM(20,___G_c_23_env_2d_lookup_2d_global_2d_var,203)
___DEF_MOD_PRM(18,___G_c_23_env_2d_global_2d_variables,211)
___DEF_MOD_PRM(17,___G_c_23_env_2d_global_2d_env,215)
___DEF_MOD_PRM(21,___G_c_23_env_2d_lookup_2d_macro,219)
___DEF_MOD_PRM(6,___G_c_23_define_2d_flag_2d_decl,225)
___DEF_MOD_PRM(9,___G_c_23_define_2d_parameterized_2d_decl,228)
___DEF_MOD_PRM(5,___G_c_23_define_2d_boolean_2d_decl,231)
___DEF_MOD_PRM(8,___G_c_23_define_2d_namable_2d_decl,234)
___DEF_MOD_PRM(7,___G_c_23_define_2d_namable_2d_boolean_2d_decl,237)
___DEF_MOD_PRM(37,___G_c_23_flag_2d_decl,240)
___DEF_MOD_PRM(50,___G_c_23_parameterized_2d_decl,243)
___DEF_MOD_PRM(1,___G_c_23_boolean_2d_decl,246)
___DEF_MOD_PRM(46,___G_c_23_namable_2d_decl,249)
___DEF_MOD_PRM(44,___G_c_23_namable_2d_boolean_2d_decl,252)
___DEF_MOD_PRM(4,___G_c_23_declaration_2d_value,255)
___DEF_MOD_PRM(35,___G_c_23_env_2e_begin_21_,262)
___DEF_MOD_PRM(36,___G_c_23_env_2e_end_21_,270)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___env_23_,1)
___DEF_MOD_GLO(43,___G_c_23_make_2d_var,6)
___DEF_MOD_GLO(79,___G_c_23_var_3f_,11)
___DEF_MOD_GLO(66,___G_c_23_var_2d_name,13)
___DEF_MOD_GLO(55,___G_c_23_var_2d_bound,15)
___DEF_MOD_GLO(68,___G_c_23_var_2d_refs,17)
___DEF_MOD_GLO(70,___G_c_23_var_2d_sets,19)
___DEF_MOD_GLO(72,___G_c_23_var_2d_source,21)
___DEF_MOD_GLO(57,___G_c_23_var_2d_boxed_3f_,23)
___DEF_MOD_GLO(63,___G_c_23_var_2d_info,25)
___DEF_MOD_GLO(74,___G_c_23_var_2d_stamp,27)
___DEF_MOD_GLO(61,___G_c_23_var_2d_constant,29)
___DEF_MOD_GLO(59,___G_c_23_var_2d_clone,31)
___DEF_MOD_GLO(77,___G_c_23_var_2d_temp_3f_,33)
___DEF_MOD_GLO(67,___G_c_23_var_2d_name_2d_set_21_,35)
___DEF_MOD_GLO(56,___G_c_23_var_2d_bound_2d_set_21_,37)
___DEF_MOD_GLO(69,___G_c_23_var_2d_refs_2d_set_21_,39)
___DEF_MOD_GLO(71,___G_c_23_var_2d_sets_2d_set_21_,41)
___DEF_MOD_GLO(73,___G_c_23_var_2d_source_2d_set_21_,43)
___DEF_MOD_GLO(58,___G_c_23_var_2d_boxed_3f__2d_set_21_,45)
___DEF_MOD_GLO(64,___G_c_23_var_2d_info_2d_set_21_,47)
___DEF_MOD_GLO(75,___G_c_23_var_2d_stamp_2d_set_21_,49)
___DEF_MOD_GLO(62,___G_c_23_var_2d_constant_2d_set_21_,51)
___DEF_MOD_GLO(60,___G_c_23_var_2d_clone_2d_set_21_,53)
___DEF_MOD_GLO(78,___G_c_23_var_2d_temp_3f__2d_set_21_,55)
___DEF_MOD_GLO(65,___G_c_23_var_2d_lexical_2d_level,57)
___DEF_MOD_GLO(42,___G_c_23_make_2d_temp_2d_var,66)
___DEF_MOD_GLO(52,___G_c_23_resize_2d_var_2d_list,72)
___DEF_MOD_GLO(16,___G_c_23_env_2d_frame,78)
___DEF_MOD_GLO(31,___G_c_23_env_2d_new_2d_var_21_,83)
___DEF_MOD_GLO(23,___G_c_23_env_2d_macro,92)
___DEF_MOD_GLO(25,___G_c_23_env_2d_macros_2d_set,99)
___DEF_MOD_GLO(13,___G_c_23_env_2d_declare,102)
___DEF_MOD_GLO(12,___G_c_23_env_2d_decl_2d_set,106)
___DEF_MOD_GLO(26,___G_c_23_env_2d_namespace,109)
___DEF_MOD_GLO(30,___G_c_23_env_2d_namespace_2d_set,113)
___DEF_MOD_GLO(33,___G_c_23_env_2d_vars_2d_ref,116)
___DEF_MOD_GLO(34,___G_c_23_env_2d_vars_2d_set_21_,118)
___DEF_MOD_GLO(24,___G_c_23_env_2d_macros_2d_ref,120)
___DEF_MOD_GLO(11,___G_c_23_env_2d_decl_2d_ref,122)
___DEF_MOD_GLO(29,___G_c_23_env_2d_namespace_2d_ref,124)
___DEF_MOD_GLO(32,___G_c_23_env_2d_parent_2d_ref,126)
___DEF_MOD_GLO(15,___G_c_23_env_2d_externals_2d_ref,128)
___DEF_MOD_GLO(27,___G_c_23_env_2d_namespace_2d_lookup,130)
___DEF_MOD_GLO(28,___G_c_23_env_2d_namespace_2d_lookup_2d_both,139)
___DEF_MOD_GLO(19,___G_c_23_env_2d_lookup,151)
___DEF_MOD_GLO(48,___G_c_23_namespace_2d_valid_3f_,172)
___DEF_MOD_GLO(39,___G_c_23_full_2d_name_3f_,174)
___DEF_MOD_GLO(40,___G_c_23_make_2d_full_2d_name,179)
___DEF_MOD_GLO(22,___G_c_23_env_2d_lookup_2d_var,184)
___DEF_MOD_GLO(14,___G_c_23_env_2d_define_2d_var,193)
___DEF_MOD_GLO(20,___G_c_23_env_2d_lookup_2d_global_2d_var,203)
___DEF_MOD_GLO(18,___G_c_23_env_2d_global_2d_variables,211)
___DEF_MOD_GLO(17,___G_c_23_env_2d_global_2d_env,215)
___DEF_MOD_GLO(21,___G_c_23_env_2d_lookup_2d_macro,219)
___DEF_MOD_GLO(6,___G_c_23_define_2d_flag_2d_decl,225)
___DEF_MOD_GLO(9,___G_c_23_define_2d_parameterized_2d_decl,228)
___DEF_MOD_GLO(5,___G_c_23_define_2d_boolean_2d_decl,231)
___DEF_MOD_GLO(8,___G_c_23_define_2d_namable_2d_decl,234)
___DEF_MOD_GLO(7,___G_c_23_define_2d_namable_2d_boolean_2d_decl,237)
___DEF_MOD_GLO(37,___G_c_23_flag_2d_decl,240)
___DEF_MOD_GLO(50,___G_c_23_parameterized_2d_decl,243)
___DEF_MOD_GLO(1,___G_c_23_boolean_2d_decl,246)
___DEF_MOD_GLO(46,___G_c_23_namable_2d_decl,249)
___DEF_MOD_GLO(44,___G_c_23_namable_2d_boolean_2d_decl,252)
___DEF_MOD_GLO(4,___G_c_23_declaration_2d_value,255)
___DEF_MOD_GLO(35,___G_c_23_env_2e_begin_21_,262)
___DEF_MOD_GLO(36,___G_c_23_env_2e_end_21_,270)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___env,"_env")
___DEF_MOD_SYM(1,___S___env_23_,"_env#")
___DEF_MOD_SYM(2,___S_c_23_boolean_2d_decl,"c#boolean-decl")
___DEF_MOD_SYM(3,___S_c_23_declaration_2d_value,"c#declaration-value")
___DEF_MOD_SYM(4,___S_c_23_define_2d_boolean_2d_decl,"c#define-boolean-decl")
___DEF_MOD_SYM(5,___S_c_23_define_2d_flag_2d_decl,"c#define-flag-decl")
___DEF_MOD_SYM(6,___S_c_23_define_2d_namable_2d_boolean_2d_decl,"c#define-namable-boolean-decl")

___DEF_MOD_SYM(7,___S_c_23_define_2d_namable_2d_decl,"c#define-namable-decl")
___DEF_MOD_SYM(8,___S_c_23_define_2d_parameterized_2d_decl,"c#define-parameterized-decl")
___DEF_MOD_SYM(9,___S_c_23_env_2d_decl_2d_ref,"c#env-decl-ref")
___DEF_MOD_SYM(10,___S_c_23_env_2d_decl_2d_set,"c#env-decl-set")
___DEF_MOD_SYM(11,___S_c_23_env_2d_declare,"c#env-declare")
___DEF_MOD_SYM(12,___S_c_23_env_2d_define_2d_var,"c#env-define-var")
___DEF_MOD_SYM(13,___S_c_23_env_2d_externals_2d_ref,"c#env-externals-ref")
___DEF_MOD_SYM(14,___S_c_23_env_2d_frame,"c#env-frame")
___DEF_MOD_SYM(15,___S_c_23_env_2d_global_2d_env,"c#env-global-env")
___DEF_MOD_SYM(16,___S_c_23_env_2d_global_2d_variables,"c#env-global-variables")
___DEF_MOD_SYM(17,___S_c_23_env_2d_lookup,"c#env-lookup")
___DEF_MOD_SYM(18,___S_c_23_env_2d_lookup_2d_global_2d_var,"c#env-lookup-global-var")
___DEF_MOD_SYM(19,___S_c_23_env_2d_lookup_2d_macro,"c#env-lookup-macro")
___DEF_MOD_SYM(20,___S_c_23_env_2d_lookup_2d_var,"c#env-lookup-var")
___DEF_MOD_SYM(21,___S_c_23_env_2d_macro,"c#env-macro")
___DEF_MOD_SYM(22,___S_c_23_env_2d_macros_2d_ref,"c#env-macros-ref")
___DEF_MOD_SYM(23,___S_c_23_env_2d_macros_2d_set,"c#env-macros-set")
___DEF_MOD_SYM(24,___S_c_23_env_2d_namespace,"c#env-namespace")
___DEF_MOD_SYM(25,___S_c_23_env_2d_namespace_2d_lookup,"c#env-namespace-lookup")
___DEF_MOD_SYM(26,___S_c_23_env_2d_namespace_2d_lookup_2d_both,"c#env-namespace-lookup-both")
___DEF_MOD_SYM(27,___S_c_23_env_2d_namespace_2d_ref,"c#env-namespace-ref")
___DEF_MOD_SYM(28,___S_c_23_env_2d_namespace_2d_set,"c#env-namespace-set")
___DEF_MOD_SYM(29,___S_c_23_env_2d_new_2d_var_21_,"c#env-new-var!")
___DEF_MOD_SYM(30,___S_c_23_env_2d_parent_2d_ref,"c#env-parent-ref")
___DEF_MOD_SYM(31,___S_c_23_env_2d_vars_2d_ref,"c#env-vars-ref")
___DEF_MOD_SYM(32,___S_c_23_env_2d_vars_2d_set_21_,"c#env-vars-set!")
___DEF_MOD_SYM(33,___S_c_23_env_2e_begin_21_,"c#env.begin!")
___DEF_MOD_SYM(34,___S_c_23_env_2e_end_21_,"c#env.end!")
___DEF_MOD_SYM(35,___S_c_23_flag_2d_decl,"c#flag-decl")
___DEF_MOD_SYM(36,___S_c_23_full_2d_name_3f_,"c#full-name?")
___DEF_MOD_SYM(37,___S_c_23_make_2d_full_2d_name,"c#make-full-name")
___DEF_MOD_SYM(38,___S_c_23_make_2d_temp_2d_var,"c#make-temp-var")
___DEF_MOD_SYM(39,___S_c_23_make_2d_var,"c#make-var")
___DEF_MOD_SYM(40,___S_c_23_namable_2d_boolean_2d_decl,"c#namable-boolean-decl")
___DEF_MOD_SYM(41,___S_c_23_namable_2d_decl,"c#namable-decl")
___DEF_MOD_SYM(42,___S_c_23_namespace_2d_valid_3f_,"c#namespace-valid?")
___DEF_MOD_SYM(43,___S_c_23_parameterized_2d_decl,"c#parameterized-decl")
___DEF_MOD_SYM(44,___S_c_23_resize_2d_var_2d_list,"c#resize-var-list")
___DEF_MOD_SYM(45,___S_c_23_var_2d_bound,"c#var-bound")
___DEF_MOD_SYM(46,___S_c_23_var_2d_bound_2d_set_21_,"c#var-bound-set!")
___DEF_MOD_SYM(47,___S_c_23_var_2d_boxed_3f_,"c#var-boxed?")
___DEF_MOD_SYM(48,___S_c_23_var_2d_boxed_3f__2d_set_21_,"c#var-boxed?-set!")
___DEF_MOD_SYM(49,___S_c_23_var_2d_clone,"c#var-clone")
___DEF_MOD_SYM(50,___S_c_23_var_2d_clone_2d_set_21_,"c#var-clone-set!")
___DEF_MOD_SYM(51,___S_c_23_var_2d_constant,"c#var-constant")
___DEF_MOD_SYM(52,___S_c_23_var_2d_constant_2d_set_21_,"c#var-constant-set!")
___DEF_MOD_SYM(53,___S_c_23_var_2d_info,"c#var-info")
___DEF_MOD_SYM(54,___S_c_23_var_2d_info_2d_set_21_,"c#var-info-set!")
___DEF_MOD_SYM(55,___S_c_23_var_2d_lexical_2d_level,"c#var-lexical-level")
___DEF_MOD_SYM(56,___S_c_23_var_2d_name,"c#var-name")
___DEF_MOD_SYM(57,___S_c_23_var_2d_name_2d_set_21_,"c#var-name-set!")
___DEF_MOD_SYM(58,___S_c_23_var_2d_refs,"c#var-refs")
___DEF_MOD_SYM(59,___S_c_23_var_2d_refs_2d_set_21_,"c#var-refs-set!")
___DEF_MOD_SYM(60,___S_c_23_var_2d_sets,"c#var-sets")
___DEF_MOD_SYM(61,___S_c_23_var_2d_sets_2d_set_21_,"c#var-sets-set!")
___DEF_MOD_SYM(62,___S_c_23_var_2d_source,"c#var-source")
___DEF_MOD_SYM(63,___S_c_23_var_2d_source_2d_set_21_,"c#var-source-set!")
___DEF_MOD_SYM(64,___S_c_23_var_2d_stamp,"c#var-stamp")
___DEF_MOD_SYM(65,___S_c_23_var_2d_stamp_2d_set_21_,"c#var-stamp-set!")
___DEF_MOD_SYM(66,___S_c_23_var_2d_temp_3f_,"c#var-temp?")
___DEF_MOD_SYM(67,___S_c_23_var_2d_temp_3f__2d_set_21_,"c#var-temp?-set!")
___DEF_MOD_SYM(68,___S_c_23_var_3f_,"c#var?")
___DEF_MOD_SYM(69,___S_closure_2d_env,"closure-env")
___DEF_MOD_SYM(70,___S_ret,"ret")
___DEF_MOD_SYM(71,___S_var_2d_tag,"var-tag")
___END_MOD_SYM_KEY

#endif
