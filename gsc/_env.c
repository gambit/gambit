#ifdef ___LINKER_INFO
; File: "_env.c", produced by Gambit-C v4.7.8
(
407008
" _env"
((" _env"))
(
"_env"
"closure-env"
"ret"
"var-tag"
)
(
)
(
" _env"
"c#boolean-declarations"
"c#env-frame"
"c#env-global-env"
"c#env-lookup"
"c#env-namespace-lookup"
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
)
(
"c#boolean-decl"
"c#closure-env-var"
"c#declaration-value"
"c#define-boolean-decl"
"c#define-flag-decl"
"c#define-namable-boolean-decl"
"c#define-namable-decl"
"c#define-parameterized-decl"
"c#empty-var"
"c#env-decl-ref"
"c#env-declare"
"c#env-define-var"
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
"c#parameterized-decl"
"c#ret-var-set"
"c#temp-var?"
"c#valid-prefix?"
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
)
(
"c#compiler-internal-error"
"c#make-counter"
"c#node-parent"
"c#prc?"
"c#pt-syntax-error"
"c#ptset-empty"
"c#varset-singleton"
"string->symbol"
"string-append"
"symbol->string"
)
 ()
)
#else
#define ___VERSION 407008
#define ___MODULE_NAME " _env"
#define ___LINKER_ID ____20___env
#define ___MH_PROC ___H__20___env
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 4
#define ___GLOCOUNT 83
#define ___SUPCOUNT 73
#define ___SUBCOUNT 4
#define ___LBLCOUNT 246
#define ___OFDCOUNT 5
#define ___MODDESCR ___REF_SUB(3)
#include "gambit.h"

___NEED_SYM(___S___env)
___NEED_SYM(___S_closure_2d_env)
___NEED_SYM(___S_ret)
___NEED_SYM(___S_var_2d_tag)

___NEED_GLO(___G__20___env)
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
___NEED_GLO(___G_c_23_env_2d_declare)
___NEED_GLO(___G_c_23_env_2d_define_2d_var)
___NEED_GLO(___G_c_23_env_2d_frame)
___NEED_GLO(___G_c_23_env_2d_global_2d_env)
___NEED_GLO(___G_c_23_env_2d_global_2d_variables)
___NEED_GLO(___G_c_23_env_2d_lookup)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_global_2d_var)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_macro)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_var)
___NEED_GLO(___G_c_23_env_2d_macro)
___NEED_GLO(___G_c_23_env_2d_macros_2d_ref)
___NEED_GLO(___G_c_23_env_2d_namespace)
___NEED_GLO(___G_c_23_env_2d_namespace_2d_lookup)
___NEED_GLO(___G_c_23_env_2d_namespace_2d_ref)
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
___NEED_GLO(___G_c_23_next_2d_var_2d_stamp)
___NEED_GLO(___G_c_23_node_2d_parent)
___NEED_GLO(___G_c_23_parameterized_2d_decl)
___NEED_GLO(___G_c_23_parameterized_2d_declarations)
___NEED_GLO(___G_c_23_prc_3f_)
___NEED_GLO(___G_c_23_pt_2d_syntax_2d_error)
___NEED_GLO(___G_c_23_ptset_2d_empty)
___NEED_GLO(___G_c_23_ret_2d_var)
___NEED_GLO(___G_c_23_ret_2d_var_2d_set)
___NEED_GLO(___G_c_23_temp_2d_var_3f_)
___NEED_GLO(___G_c_23_valid_2d_prefix_3f_)
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
___NEED_GLO(___G_c_23_var_3f_)
___NEED_GLO(___G_c_23_varset_2d_singleton)
___NEED_GLO(___G_string_2d__3e_symbol)
___NEED_GLO(___G_string_2d_append)
___NEED_GLO(___G_symbol_2d__3e_string)

___BEGIN_SYM
___DEF_SYM(0,___S___env,"_env")
___DEF_SYM(1,___S_closure_2d_env,"closure-env")
___DEF_SYM(2,___S_ret,"ret")
___DEF_SYM(3,___S_var_2d_tag,"var-tag")
___END_SYM

#define ___SYM___env ___SYM(0,___S___env)
#define ___SYM_closure_2d_env ___SYM(1,___S_closure_2d_env)
#define ___SYM_ret ___SYM(2,___S_ret)
#define ___SYM_var_2d_tag ___SYM(3,___S_var_2d_tag)

___BEGIN_GLO
___DEF_GLO(0," _env")
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
___DEF_GLO(12,"c#env-declare")
___DEF_GLO(13,"c#env-define-var")
___DEF_GLO(14,"c#env-frame")
___DEF_GLO(15,"c#env-global-env")
___DEF_GLO(16,"c#env-global-variables")
___DEF_GLO(17,"c#env-lookup")
___DEF_GLO(18,"c#env-lookup-global-var")
___DEF_GLO(19,"c#env-lookup-macro")
___DEF_GLO(20,"c#env-lookup-var")
___DEF_GLO(21,"c#env-macro")
___DEF_GLO(22,"c#env-macros-ref")
___DEF_GLO(23,"c#env-namespace")
___DEF_GLO(24,"c#env-namespace-lookup")
___DEF_GLO(25,"c#env-namespace-ref")
___DEF_GLO(26,"c#env-new-var!")
___DEF_GLO(27,"c#env-parent-ref")
___DEF_GLO(28,"c#env-vars-ref")
___DEF_GLO(29,"c#env-vars-set!")
___DEF_GLO(30,"c#env.begin!")
___DEF_GLO(31,"c#env.end!")
___DEF_GLO(32,"c#flag-decl")
___DEF_GLO(33,"c#flag-declarations")
___DEF_GLO(34,"c#full-name?")
___DEF_GLO(35,"c#make-full-name")
___DEF_GLO(36,"c#make-global-environment")
___DEF_GLO(37,"c#make-temp-var")
___DEF_GLO(38,"c#make-var")
___DEF_GLO(39,"c#namable-boolean-decl")
___DEF_GLO(40,"c#namable-boolean-declarations")
___DEF_GLO(41,"c#namable-decl")
___DEF_GLO(42,"c#namable-declarations")
___DEF_GLO(43,"c#next-var-stamp")
___DEF_GLO(44,"c#parameterized-decl")
___DEF_GLO(45,"c#parameterized-declarations")
___DEF_GLO(46,"c#ret-var")
___DEF_GLO(47,"c#ret-var-set")
___DEF_GLO(48,"c#temp-var?")
___DEF_GLO(49,"c#valid-prefix?")
___DEF_GLO(50,"c#var-bound")
___DEF_GLO(51,"c#var-bound-set!")
___DEF_GLO(52,"c#var-boxed?")
___DEF_GLO(53,"c#var-boxed?-set!")
___DEF_GLO(54,"c#var-clone")
___DEF_GLO(55,"c#var-clone-set!")
___DEF_GLO(56,"c#var-constant")
___DEF_GLO(57,"c#var-constant-set!")
___DEF_GLO(58,"c#var-info")
___DEF_GLO(59,"c#var-info-set!")
___DEF_GLO(60,"c#var-lexical-level")
___DEF_GLO(61,"c#var-name")
___DEF_GLO(62,"c#var-name-set!")
___DEF_GLO(63,"c#var-refs")
___DEF_GLO(64,"c#var-refs-set!")
___DEF_GLO(65,"c#var-sets")
___DEF_GLO(66,"c#var-sets-set!")
___DEF_GLO(67,"c#var-source")
___DEF_GLO(68,"c#var-source-set!")
___DEF_GLO(69,"c#var-stamp")
___DEF_GLO(70,"c#var-stamp-set!")
___DEF_GLO(71,"c#var-tag")
___DEF_GLO(72,"c#var?")
___DEF_GLO(73,"c#compiler-internal-error")
___DEF_GLO(74,"c#make-counter")
___DEF_GLO(75,"c#node-parent")
___DEF_GLO(76,"c#prc?")
___DEF_GLO(77,"c#pt-syntax-error")
___DEF_GLO(78,"c#ptset-empty")
___DEF_GLO(79,"c#varset-singleton")
___DEF_GLO(80,"string->symbol")
___DEF_GLO(81,"string-append")
___DEF_GLO(82,"symbol->string")
___END_GLO

#define ___GLO__20___env ___GLO(0,___G__20___env)
#define ___PRM__20___env ___PRM(0,___G__20___env)
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
#define ___GLO_c_23_env_2d_declare ___GLO(12,___G_c_23_env_2d_declare)
#define ___PRM_c_23_env_2d_declare ___PRM(12,___G_c_23_env_2d_declare)
#define ___GLO_c_23_env_2d_define_2d_var ___GLO(13,___G_c_23_env_2d_define_2d_var)
#define ___PRM_c_23_env_2d_define_2d_var ___PRM(13,___G_c_23_env_2d_define_2d_var)
#define ___GLO_c_23_env_2d_frame ___GLO(14,___G_c_23_env_2d_frame)
#define ___PRM_c_23_env_2d_frame ___PRM(14,___G_c_23_env_2d_frame)
#define ___GLO_c_23_env_2d_global_2d_env ___GLO(15,___G_c_23_env_2d_global_2d_env)
#define ___PRM_c_23_env_2d_global_2d_env ___PRM(15,___G_c_23_env_2d_global_2d_env)
#define ___GLO_c_23_env_2d_global_2d_variables ___GLO(16,___G_c_23_env_2d_global_2d_variables)
#define ___PRM_c_23_env_2d_global_2d_variables ___PRM(16,___G_c_23_env_2d_global_2d_variables)
#define ___GLO_c_23_env_2d_lookup ___GLO(17,___G_c_23_env_2d_lookup)
#define ___PRM_c_23_env_2d_lookup ___PRM(17,___G_c_23_env_2d_lookup)
#define ___GLO_c_23_env_2d_lookup_2d_global_2d_var ___GLO(18,___G_c_23_env_2d_lookup_2d_global_2d_var)
#define ___PRM_c_23_env_2d_lookup_2d_global_2d_var ___PRM(18,___G_c_23_env_2d_lookup_2d_global_2d_var)
#define ___GLO_c_23_env_2d_lookup_2d_macro ___GLO(19,___G_c_23_env_2d_lookup_2d_macro)
#define ___PRM_c_23_env_2d_lookup_2d_macro ___PRM(19,___G_c_23_env_2d_lookup_2d_macro)
#define ___GLO_c_23_env_2d_lookup_2d_var ___GLO(20,___G_c_23_env_2d_lookup_2d_var)
#define ___PRM_c_23_env_2d_lookup_2d_var ___PRM(20,___G_c_23_env_2d_lookup_2d_var)
#define ___GLO_c_23_env_2d_macro ___GLO(21,___G_c_23_env_2d_macro)
#define ___PRM_c_23_env_2d_macro ___PRM(21,___G_c_23_env_2d_macro)
#define ___GLO_c_23_env_2d_macros_2d_ref ___GLO(22,___G_c_23_env_2d_macros_2d_ref)
#define ___PRM_c_23_env_2d_macros_2d_ref ___PRM(22,___G_c_23_env_2d_macros_2d_ref)
#define ___GLO_c_23_env_2d_namespace ___GLO(23,___G_c_23_env_2d_namespace)
#define ___PRM_c_23_env_2d_namespace ___PRM(23,___G_c_23_env_2d_namespace)
#define ___GLO_c_23_env_2d_namespace_2d_lookup ___GLO(24,___G_c_23_env_2d_namespace_2d_lookup)
#define ___PRM_c_23_env_2d_namespace_2d_lookup ___PRM(24,___G_c_23_env_2d_namespace_2d_lookup)
#define ___GLO_c_23_env_2d_namespace_2d_ref ___GLO(25,___G_c_23_env_2d_namespace_2d_ref)
#define ___PRM_c_23_env_2d_namespace_2d_ref ___PRM(25,___G_c_23_env_2d_namespace_2d_ref)
#define ___GLO_c_23_env_2d_new_2d_var_21_ ___GLO(26,___G_c_23_env_2d_new_2d_var_21_)
#define ___PRM_c_23_env_2d_new_2d_var_21_ ___PRM(26,___G_c_23_env_2d_new_2d_var_21_)
#define ___GLO_c_23_env_2d_parent_2d_ref ___GLO(27,___G_c_23_env_2d_parent_2d_ref)
#define ___PRM_c_23_env_2d_parent_2d_ref ___PRM(27,___G_c_23_env_2d_parent_2d_ref)
#define ___GLO_c_23_env_2d_vars_2d_ref ___GLO(28,___G_c_23_env_2d_vars_2d_ref)
#define ___PRM_c_23_env_2d_vars_2d_ref ___PRM(28,___G_c_23_env_2d_vars_2d_ref)
#define ___GLO_c_23_env_2d_vars_2d_set_21_ ___GLO(29,___G_c_23_env_2d_vars_2d_set_21_)
#define ___PRM_c_23_env_2d_vars_2d_set_21_ ___PRM(29,___G_c_23_env_2d_vars_2d_set_21_)
#define ___GLO_c_23_env_2e_begin_21_ ___GLO(30,___G_c_23_env_2e_begin_21_)
#define ___PRM_c_23_env_2e_begin_21_ ___PRM(30,___G_c_23_env_2e_begin_21_)
#define ___GLO_c_23_env_2e_end_21_ ___GLO(31,___G_c_23_env_2e_end_21_)
#define ___PRM_c_23_env_2e_end_21_ ___PRM(31,___G_c_23_env_2e_end_21_)
#define ___GLO_c_23_flag_2d_decl ___GLO(32,___G_c_23_flag_2d_decl)
#define ___PRM_c_23_flag_2d_decl ___PRM(32,___G_c_23_flag_2d_decl)
#define ___GLO_c_23_flag_2d_declarations ___GLO(33,___G_c_23_flag_2d_declarations)
#define ___PRM_c_23_flag_2d_declarations ___PRM(33,___G_c_23_flag_2d_declarations)
#define ___GLO_c_23_full_2d_name_3f_ ___GLO(34,___G_c_23_full_2d_name_3f_)
#define ___PRM_c_23_full_2d_name_3f_ ___PRM(34,___G_c_23_full_2d_name_3f_)
#define ___GLO_c_23_make_2d_full_2d_name ___GLO(35,___G_c_23_make_2d_full_2d_name)
#define ___PRM_c_23_make_2d_full_2d_name ___PRM(35,___G_c_23_make_2d_full_2d_name)
#define ___GLO_c_23_make_2d_global_2d_environment ___GLO(36,___G_c_23_make_2d_global_2d_environment)
#define ___PRM_c_23_make_2d_global_2d_environment ___PRM(36,___G_c_23_make_2d_global_2d_environment)
#define ___GLO_c_23_make_2d_temp_2d_var ___GLO(37,___G_c_23_make_2d_temp_2d_var)
#define ___PRM_c_23_make_2d_temp_2d_var ___PRM(37,___G_c_23_make_2d_temp_2d_var)
#define ___GLO_c_23_make_2d_var ___GLO(38,___G_c_23_make_2d_var)
#define ___PRM_c_23_make_2d_var ___PRM(38,___G_c_23_make_2d_var)
#define ___GLO_c_23_namable_2d_boolean_2d_decl ___GLO(39,___G_c_23_namable_2d_boolean_2d_decl)
#define ___PRM_c_23_namable_2d_boolean_2d_decl ___PRM(39,___G_c_23_namable_2d_boolean_2d_decl)
#define ___GLO_c_23_namable_2d_boolean_2d_declarations ___GLO(40,___G_c_23_namable_2d_boolean_2d_declarations)
#define ___PRM_c_23_namable_2d_boolean_2d_declarations ___PRM(40,___G_c_23_namable_2d_boolean_2d_declarations)
#define ___GLO_c_23_namable_2d_decl ___GLO(41,___G_c_23_namable_2d_decl)
#define ___PRM_c_23_namable_2d_decl ___PRM(41,___G_c_23_namable_2d_decl)
#define ___GLO_c_23_namable_2d_declarations ___GLO(42,___G_c_23_namable_2d_declarations)
#define ___PRM_c_23_namable_2d_declarations ___PRM(42,___G_c_23_namable_2d_declarations)
#define ___GLO_c_23_next_2d_var_2d_stamp ___GLO(43,___G_c_23_next_2d_var_2d_stamp)
#define ___PRM_c_23_next_2d_var_2d_stamp ___PRM(43,___G_c_23_next_2d_var_2d_stamp)
#define ___GLO_c_23_parameterized_2d_decl ___GLO(44,___G_c_23_parameterized_2d_decl)
#define ___PRM_c_23_parameterized_2d_decl ___PRM(44,___G_c_23_parameterized_2d_decl)
#define ___GLO_c_23_parameterized_2d_declarations ___GLO(45,___G_c_23_parameterized_2d_declarations)
#define ___PRM_c_23_parameterized_2d_declarations ___PRM(45,___G_c_23_parameterized_2d_declarations)
#define ___GLO_c_23_ret_2d_var ___GLO(46,___G_c_23_ret_2d_var)
#define ___PRM_c_23_ret_2d_var ___PRM(46,___G_c_23_ret_2d_var)
#define ___GLO_c_23_ret_2d_var_2d_set ___GLO(47,___G_c_23_ret_2d_var_2d_set)
#define ___PRM_c_23_ret_2d_var_2d_set ___PRM(47,___G_c_23_ret_2d_var_2d_set)
#define ___GLO_c_23_temp_2d_var_3f_ ___GLO(48,___G_c_23_temp_2d_var_3f_)
#define ___PRM_c_23_temp_2d_var_3f_ ___PRM(48,___G_c_23_temp_2d_var_3f_)
#define ___GLO_c_23_valid_2d_prefix_3f_ ___GLO(49,___G_c_23_valid_2d_prefix_3f_)
#define ___PRM_c_23_valid_2d_prefix_3f_ ___PRM(49,___G_c_23_valid_2d_prefix_3f_)
#define ___GLO_c_23_var_2d_bound ___GLO(50,___G_c_23_var_2d_bound)
#define ___PRM_c_23_var_2d_bound ___PRM(50,___G_c_23_var_2d_bound)
#define ___GLO_c_23_var_2d_bound_2d_set_21_ ___GLO(51,___G_c_23_var_2d_bound_2d_set_21_)
#define ___PRM_c_23_var_2d_bound_2d_set_21_ ___PRM(51,___G_c_23_var_2d_bound_2d_set_21_)
#define ___GLO_c_23_var_2d_boxed_3f_ ___GLO(52,___G_c_23_var_2d_boxed_3f_)
#define ___PRM_c_23_var_2d_boxed_3f_ ___PRM(52,___G_c_23_var_2d_boxed_3f_)
#define ___GLO_c_23_var_2d_boxed_3f__2d_set_21_ ___GLO(53,___G_c_23_var_2d_boxed_3f__2d_set_21_)
#define ___PRM_c_23_var_2d_boxed_3f__2d_set_21_ ___PRM(53,___G_c_23_var_2d_boxed_3f__2d_set_21_)
#define ___GLO_c_23_var_2d_clone ___GLO(54,___G_c_23_var_2d_clone)
#define ___PRM_c_23_var_2d_clone ___PRM(54,___G_c_23_var_2d_clone)
#define ___GLO_c_23_var_2d_clone_2d_set_21_ ___GLO(55,___G_c_23_var_2d_clone_2d_set_21_)
#define ___PRM_c_23_var_2d_clone_2d_set_21_ ___PRM(55,___G_c_23_var_2d_clone_2d_set_21_)
#define ___GLO_c_23_var_2d_constant ___GLO(56,___G_c_23_var_2d_constant)
#define ___PRM_c_23_var_2d_constant ___PRM(56,___G_c_23_var_2d_constant)
#define ___GLO_c_23_var_2d_constant_2d_set_21_ ___GLO(57,___G_c_23_var_2d_constant_2d_set_21_)
#define ___PRM_c_23_var_2d_constant_2d_set_21_ ___PRM(57,___G_c_23_var_2d_constant_2d_set_21_)
#define ___GLO_c_23_var_2d_info ___GLO(58,___G_c_23_var_2d_info)
#define ___PRM_c_23_var_2d_info ___PRM(58,___G_c_23_var_2d_info)
#define ___GLO_c_23_var_2d_info_2d_set_21_ ___GLO(59,___G_c_23_var_2d_info_2d_set_21_)
#define ___PRM_c_23_var_2d_info_2d_set_21_ ___PRM(59,___G_c_23_var_2d_info_2d_set_21_)
#define ___GLO_c_23_var_2d_lexical_2d_level ___GLO(60,___G_c_23_var_2d_lexical_2d_level)
#define ___PRM_c_23_var_2d_lexical_2d_level ___PRM(60,___G_c_23_var_2d_lexical_2d_level)
#define ___GLO_c_23_var_2d_name ___GLO(61,___G_c_23_var_2d_name)
#define ___PRM_c_23_var_2d_name ___PRM(61,___G_c_23_var_2d_name)
#define ___GLO_c_23_var_2d_name_2d_set_21_ ___GLO(62,___G_c_23_var_2d_name_2d_set_21_)
#define ___PRM_c_23_var_2d_name_2d_set_21_ ___PRM(62,___G_c_23_var_2d_name_2d_set_21_)
#define ___GLO_c_23_var_2d_refs ___GLO(63,___G_c_23_var_2d_refs)
#define ___PRM_c_23_var_2d_refs ___PRM(63,___G_c_23_var_2d_refs)
#define ___GLO_c_23_var_2d_refs_2d_set_21_ ___GLO(64,___G_c_23_var_2d_refs_2d_set_21_)
#define ___PRM_c_23_var_2d_refs_2d_set_21_ ___PRM(64,___G_c_23_var_2d_refs_2d_set_21_)
#define ___GLO_c_23_var_2d_sets ___GLO(65,___G_c_23_var_2d_sets)
#define ___PRM_c_23_var_2d_sets ___PRM(65,___G_c_23_var_2d_sets)
#define ___GLO_c_23_var_2d_sets_2d_set_21_ ___GLO(66,___G_c_23_var_2d_sets_2d_set_21_)
#define ___PRM_c_23_var_2d_sets_2d_set_21_ ___PRM(66,___G_c_23_var_2d_sets_2d_set_21_)
#define ___GLO_c_23_var_2d_source ___GLO(67,___G_c_23_var_2d_source)
#define ___PRM_c_23_var_2d_source ___PRM(67,___G_c_23_var_2d_source)
#define ___GLO_c_23_var_2d_source_2d_set_21_ ___GLO(68,___G_c_23_var_2d_source_2d_set_21_)
#define ___PRM_c_23_var_2d_source_2d_set_21_ ___PRM(68,___G_c_23_var_2d_source_2d_set_21_)
#define ___GLO_c_23_var_2d_stamp ___GLO(69,___G_c_23_var_2d_stamp)
#define ___PRM_c_23_var_2d_stamp ___PRM(69,___G_c_23_var_2d_stamp)
#define ___GLO_c_23_var_2d_stamp_2d_set_21_ ___GLO(70,___G_c_23_var_2d_stamp_2d_set_21_)
#define ___PRM_c_23_var_2d_stamp_2d_set_21_ ___PRM(70,___G_c_23_var_2d_stamp_2d_set_21_)
#define ___GLO_c_23_var_2d_tag ___GLO(71,___G_c_23_var_2d_tag)
#define ___PRM_c_23_var_2d_tag ___PRM(71,___G_c_23_var_2d_tag)
#define ___GLO_c_23_var_3f_ ___GLO(72,___G_c_23_var_3f_)
#define ___PRM_c_23_var_3f_ ___PRM(72,___G_c_23_var_3f_)
#define ___GLO_c_23_compiler_2d_internal_2d_error ___GLO(73,___G_c_23_compiler_2d_internal_2d_error)
#define ___PRM_c_23_compiler_2d_internal_2d_error ___PRM(73,___G_c_23_compiler_2d_internal_2d_error)
#define ___GLO_c_23_make_2d_counter ___GLO(74,___G_c_23_make_2d_counter)
#define ___PRM_c_23_make_2d_counter ___PRM(74,___G_c_23_make_2d_counter)
#define ___GLO_c_23_node_2d_parent ___GLO(75,___G_c_23_node_2d_parent)
#define ___PRM_c_23_node_2d_parent ___PRM(75,___G_c_23_node_2d_parent)
#define ___GLO_c_23_prc_3f_ ___GLO(76,___G_c_23_prc_3f_)
#define ___PRM_c_23_prc_3f_ ___PRM(76,___G_c_23_prc_3f_)
#define ___GLO_c_23_pt_2d_syntax_2d_error ___GLO(77,___G_c_23_pt_2d_syntax_2d_error)
#define ___PRM_c_23_pt_2d_syntax_2d_error ___PRM(77,___G_c_23_pt_2d_syntax_2d_error)
#define ___GLO_c_23_ptset_2d_empty ___GLO(78,___G_c_23_ptset_2d_empty)
#define ___PRM_c_23_ptset_2d_empty ___PRM(78,___G_c_23_ptset_2d_empty)
#define ___GLO_c_23_varset_2d_singleton ___GLO(79,___G_c_23_varset_2d_singleton)
#define ___PRM_c_23_varset_2d_singleton ___PRM(79,___G_c_23_varset_2d_singleton)
#define ___GLO_string_2d__3e_symbol ___GLO(80,___G_string_2d__3e_symbol)
#define ___PRM_string_2d__3e_symbol ___PRM(80,___G_string_2d__3e_symbol)
#define ___GLO_string_2d_append ___GLO(81,___G_string_2d_append)
#define ___PRM_string_2d_append ___PRM(81,___G_string_2d_append)
#define ___GLO_symbol_2d__3e_string ___GLO(82,___G_symbol_2d__3e_string)
#define ___PRM_symbol_2d__3e_string ___PRM(82,___G_symbol_2d__3e_string)

___DEF_SUB_STR(___X0,39)
               ___STR8(101,110,118,45,108,111,111,107)
               ___STR8(117,112,45,118,97,114,44,32)
               ___STR8(110,97,109,101,32,105,115,32)
               ___STR8(116,104,97,116,32,111,102,32)
               ___STR7(97,32,109,97,99,114,111)
___DEF_SUB_STR(___X1,39)
               ___STR8(101,110,118,45,100,101,102,105)
               ___STR8(110,101,45,118,97,114,44,32)
               ___STR8(110,97,109,101,32,105,115,32)
               ___STR8(116,104,97,116,32,111,102,32)
               ___STR7(97,32,109,97,99,114,111)
___DEF_SUB_STR(___X2,34)
               ___STR8(68,117,112,108,105,99,97,116)
               ___STR8(101,32,100,101,102,105,110,105)
               ___STR8(116,105,111,110,32,111,102,32)
               ___STR8(97,32,118,97,114,105,97,98)
               ___STR2(108,101)
___DEF_SUB_VEC(___X3,5)
               ___VEC1(___REF_SYM(0,___S___env))
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
___DEF_M_HLBL(___L0__20___env)
___DEF_M_HLBL(___L1__20___env)
___DEF_M_HLBL(___L2__20___env)
___DEF_M_HLBL(___L3__20___env)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_var)
___DEF_M_HLBL(___L1_c_23_make_2d_var)
___DEF_M_HLBL(___L2_c_23_make_2d_var)
___DEF_M_HLBL(___L3_c_23_make_2d_var)
___DEF_M_HLBL(___L4_c_23_make_2d_var)
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
___DEF_M_HLBL(___L0_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L1_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L2_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L3_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L4_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L5_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L6_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L7_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL(___L8_c_23_var_2d_lexical_2d_level)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L1_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L2_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L3_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL(___L4_c_23_make_2d_temp_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_temp_2d_var_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_frame)
___DEF_M_HLBL(___L1_c_23_env_2d_frame)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L1_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L2_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L3_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L4_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L5_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L6_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L7_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL(___L8_c_23_env_2d_new_2d_var_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_macro)
___DEF_M_HLBL(___L1_c_23_env_2d_macro)
___DEF_M_HLBL(___L2_c_23_env_2d_macro)
___DEF_M_HLBL(___L3_c_23_env_2d_macro)
___DEF_M_HLBL(___L4_c_23_env_2d_macro)
___DEF_M_HLBL(___L5_c_23_env_2d_macro)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_declare)
___DEF_M_HLBL(___L1_c_23_env_2d_declare)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_namespace)
___DEF_M_HLBL(___L1_c_23_env_2d_namespace)
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
___DEF_M_HLBL(___L0_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L1_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L2_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L3_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L4_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L5_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L6_c_23_env_2d_namespace_2d_lookup)
___DEF_M_HLBL(___L7_c_23_env_2d_namespace_2d_lookup)
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
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_valid_2d_prefix_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L1_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L2_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L3_c_23_full_2d_name_3f_)
___DEF_M_HLBL(___L4_c_23_full_2d_name_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L1_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L2_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L3_c_23_make_2d_full_2d_name)
___DEF_M_HLBL(___L4_c_23_make_2d_full_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L1_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L2_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L3_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L4_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L5_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L6_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L7_c_23_env_2d_lookup_2d_var)
___DEF_M_HLBL(___L8_c_23_env_2d_lookup_2d_var)
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
___DEF_M_HLBL(___L3_c_23_env_2d_global_2d_variables)
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
___DEF_M_HLBL(___L5_c_23_env_2d_lookup_2d_macro)
___DEF_M_HLBL(___L6_c_23_env_2d_lookup_2d_macro)
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
___DEF_M_HLBL(___L6_c_23_declaration_2d_value)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L1_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L2_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L3_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L4_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L5_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L6_c_23_env_2e_begin_21_)
___DEF_M_HLBL(___L7_c_23_env_2e_begin_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_env_2e_end_21_)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___env
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
___DEF_P_HLBL(___L0__20___env)
___DEF_P_HLBL(___L1__20___env)
___DEF_P_HLBL(___L2__20___env)
___DEF_P_HLBL(___L3__20___env)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___env)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___env)
   ___SET_R1(___CONS(___SYM_var_2d_tag,___NUL))
   ___SET_GLO(71,___G_c_23_var_2d_tag,___R1)
   ___SET_GLO(43,___G_c_23_next_2d_var_2d_stamp,___FAL)
   ___SET_GLO(46,___G_c_23_ret_2d_var,___NUL)
   ___SET_GLO(47,___G_c_23_ret_2d_var_2d_set,___NUL)
   ___SET_GLO(3,___G_c_23_closure_2d_env_2d_var,___NUL)
   ___SET_GLO(10,___G_c_23_empty_2d_var,___NUL)
   ___SET_GLO(36,___G_c_23_make_2d_global_2d_environment,___FAL)
   ___SET_GLO(36,___G_c_23_make_2d_global_2d_environment,___LBL(2))
   ___SET_GLO(33,___G_c_23_flag_2d_declarations,___NUL)
   ___SET_GLO(45,___G_c_23_parameterized_2d_declarations,___NUL)
   ___SET_GLO(2,___G_c_23_boolean_2d_declarations,___NUL)
   ___SET_GLO(42,___G_c_23_namable_2d_declarations,___NUL)
   ___SET_GLO(40,___G_c_23_namable_2d_boolean_2d_declarations,___NUL)
   ___SET_R1(___VOID)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__20___env)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(2,___L2__20___env)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(2,0,0,0)
   ___SET_R2(___NUL)
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3__20___env)
   ___JUMPINT(___SET_NARGS(2),___PRC(72),___L_c_23_env_2d_frame)
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
___DEF_P_HLBL(___L4_c_23_make_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_var)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L_c_23_make_2d_var)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(10)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_var)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),43,___G_c_23_next_2d_var_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_var)
   ___BEGIN_ALLOC_VECTOR(11)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_var_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-8))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___FAL)
   ___ADD_VECTOR_ELEM(7,___FAL)
   ___ADD_VECTOR_ELEM(8,___R1)
   ___ADD_VECTOR_ELEM(9,___FAL)
   ___ADD_VECTOR_ELEM(10,___FAL)
   ___END_ALLOC_VECTOR(11)
   ___SET_R1(___GET_VECTOR(11))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_var)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_var)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 12
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
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_c_23_var_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 14
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_bound
#undef ___PH_LBL0
#define ___PH_LBL0 16
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_refs
#undef ___PH_LBL0
#define ___PH_LBL0 18
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_sets
#undef ___PH_LBL0
#define ___PH_LBL0 20
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 22
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_boxed_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 24
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 26
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_stamp
#undef ___PH_LBL0
#define ___PH_LBL0 28
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_constant
#undef ___PH_LBL0
#define ___PH_LBL0 30
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_clone
#undef ___PH_LBL0
#define ___PH_LBL0 32
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_name_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 34
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_bound_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 36
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_refs_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 38
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_sets_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 40
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_source_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 42
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_boxed_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 44
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_info_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 46
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_stamp_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 48
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_constant_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 50
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_clone_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 52
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_lexical_2d_level
#undef ___PH_LBL0
#define ___PH_LBL0 54
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
___DEF_P_HLBL(___L8_c_23_var_2d_lexical_2d_level)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_lexical_2d_level)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___IF(___EQP(___R1,___FAL))
   ___GOTO(___L16_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___IF(___EQP(___R1,___TRU))
   ___GOTO(___L16_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_var_2d_lexical_2d_level)
   ___GOTO(___L10_c_23_var_2d_lexical_2d_level)
___DEF_SLBL(2,___L2_c_23_var_2d_lexical_2d_level)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L15_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_R1(___FIX(1L))
___DEF_GLBL(___L9_c_23_var_2d_lexical_2d_level)
   ___SET_R2(___FIXADD(___STK(-6),___R1))
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-5))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_var_2d_lexical_2d_level)
___DEF_GLBL(___L10_c_23_var_2d_lexical_2d_level)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L14_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_var_2d_lexical_2d_level)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),75,___G_c_23_node_2d_parent)
___DEF_SLBL(5,___L5_c_23_var_2d_lexical_2d_level)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),76,___G_c_23_prc_3f_)
___DEF_SLBL(6,___L6_c_23_var_2d_lexical_2d_level)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L11_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___SET_R1(___FIX(0L))
   ___GOTO(___L12_c_23_var_2d_lexical_2d_level)
___DEF_GLBL(___L11_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIX(1L))
___DEF_GLBL(___L12_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIXADD(___STK(-5),___R1))
   ___IF(___NOT(___FALSEP(___STK(-4))))
   ___GOTO(___L13_c_23_var_2d_lexical_2d_level)
   ___END_IF
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_var_2d_lexical_2d_level)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L13_c_23_var_2d_lexical_2d_level)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),75,___G_c_23_node_2d_parent)
___DEF_SLBL(8,___L8_c_23_var_2d_lexical_2d_level)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),76,___G_c_23_prc_3f_)
___DEF_GLBL(___L14_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L15_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIX(0L))
   ___GOTO(___L9_c_23_var_2d_lexical_2d_level)
___DEF_GLBL(___L16_c_23_var_2d_lexical_2d_level)
   ___SET_R1(___FIX(0L))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_temp_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 64
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
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
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_temp_2d_var)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),78,___G_c_23_ptset_2d_empty)
___DEF_SLBL(2,___L2_c_23_make_2d_temp_2d_var)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),78,___G_c_23_ptset_2d_empty)
___DEF_SLBL(3,___L3_c_23_make_2d_temp_2d_var)
   ___SET_R2(___R1)
   ___SET_R3(___FAL)
   ___SET_R0(___STK(-5))
   ___SET_R1(___STK(-4))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_temp_2d_var)
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(5),___PRC(6),___L_c_23_make_2d_var)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_temp_2d_var_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 70
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_temp_2d_var_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_temp_2d_var_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_temp_2d_var_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___TRU)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_frame
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_frame)
___DEF_P_HLBL(___L1_c_23_env_2d_frame)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_frame)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_frame)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L2_c_23_env_2d_frame)
   ___END_IF
   ___SET_R3(___NUL)
   ___GOTO(___L3_c_23_env_2d_frame)
___DEF_GLBL(___L2_c_23_env_2d_frame)
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
___DEF_GLBL(___L3_c_23_env_2d_frame)
   ___SET_R2(___CONS(___R2,___FAL))
   ___BEGIN_ALLOC_VECTOR(5)
   ___ADD_VECTOR_ELEM(0,___R2)
   ___ADD_VECTOR_ELEM(1,___NUL)
   ___ADD_VECTOR_ELEM(2,___R3)
   ___ADD_VECTOR_ELEM(3,___NUL)
   ___ADD_VECTOR_ELEM(4,___R1)
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_frame)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_new_2d_var_21_
#undef ___PH_LBL0
#define ___PH_LBL0 75
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
___DEF_P_HLBL(___L8_c_23_env_2d_new_2d_var_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_new_2d_var_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_env_2d_new_2d_var_21_)
   ___SET_STK(1,___R1)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(4L)))
   ___SET_R4(___BOOLEAN(___FALSEP(___R4)))
   ___SET_R4(___BOOLEAN(___FALSEP(___R4)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_new_2d_var_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),78,___G_c_23_ptset_2d_empty)
___DEF_SLBL(2,___L2_c_23_env_2d_new_2d_var_21_)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),78,___G_c_23_ptset_2d_empty)
___DEF_SLBL(3,___L3_c_23_env_2d_new_2d_var_21_)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),43,___G_c_23_next_2d_var_2d_stamp)
___DEF_SLBL(4,___L4_c_23_env_2d_new_2d_var_21_)
   ___BEGIN_ALLOC_VECTOR(11)
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
   ___END_ALLOC_VECTOR(11)
   ___SET_R1(___GET_VECTOR(11))
   ___SET_STK(-9,___STK(-10))
   ___SET_STK(-8,___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_env_2d_new_2d_var_21_)
   ___JUMPINT(___SET_NARGS(1),___PRC(98),___L_c_23_env_2d_vars_2d_ref)
___DEF_SLBL(6,___L6_c_23_env_2d_new_2d_var_21_)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(0L)))
   ___SETCAR(___R2,___R1)
   ___SET_R1(___STK(-4))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_env_2d_new_2d_var_21_)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_new_2d_var_21_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_macro
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
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_macro)
   ___JUMPINT(___SET_NARGS(1),___PRC(141),___L_c_23_full_2d_name_3f_)
___DEF_SLBL(2,___L2_c_23_env_2d_macro)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L8_c_23_env_2d_macro)
   ___END_IF
   ___SET_R1(___FAL)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L6_c_23_env_2d_macro)
   ___END_IF
   ___GOTO(___L7_c_23_env_2d_macro)
___DEF_SLBL(3,___L3_c_23_env_2d_macro)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L7_c_23_env_2d_macro)
   ___END_IF
___DEF_GLBL(___L6_c_23_env_2d_macro)
   ___SET_R1(___STK(-5))
___DEF_GLBL(___L7_c_23_env_2d_macro)
   ___SET_STK(-5,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(1L)))
   ___SET_R1(___CONS(___R1,___STK(-4)))
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_STK(-5,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(2L)))
   ___SET_STK(-5,___STK(-6))
   ___SET_R3(___VECTORREF(___STK(-5),___FIX(3L)))
   ___SET_STK(-5,___STK(-6))
   ___SET_R4(___VECTORREF(___STK(-5),___FIX(4L)))
   ___SET_R0(___VECTORREF(___STK(-6),___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(5)
   ___ADD_VECTOR_ELEM(0,___R0)
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___R2)
   ___ADD_VECTOR_ELEM(3,___R3)
   ___ADD_VECTOR_ELEM(4,___R4)
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_env_2d_macro)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_macro)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L8_c_23_env_2d_macro)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(110),___L_c_23_env_2d_namespace_2d_lookup)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_declare
#undef ___PH_LBL0
#define ___PH_LBL0 92
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_declare)
___DEF_P_HLBL(___L1_c_23_env_2d_declare)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_declare)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_declare)
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(1L)))
   ___SET_STK(1,___R1)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_R2(___CONS(___R2,___R4))
   ___SET_STK(1,___R1)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(3L)))
   ___SET_STK(1,___R1)
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(4L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(5)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R3)
   ___ADD_VECTOR_ELEM(2,___R2)
   ___ADD_VECTOR_ELEM(3,___R4)
   ___ADD_VECTOR_ELEM(4,___STK(1))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_declare)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace
#undef ___PH_LBL0
#define ___PH_LBL0 95
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_env_2d_namespace)
___DEF_P_HLBL(___L1_c_23_env_2d_namespace)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_namespace)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_env_2d_namespace)
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(1L)))
   ___SET_STK(1,___R1)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R1)
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(3L)))
   ___SET_R2(___CONS(___R2,___STK(1)))
   ___SET_STK(1,___R1)
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(4L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___BEGIN_ALLOC_VECTOR(5)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R3)
   ___ADD_VECTOR_ELEM(2,___R4)
   ___ADD_VECTOR_ELEM(3,___R2)
   ___ADD_VECTOR_ELEM(4,___STK(1))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_env_2d_namespace)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_vars_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 98
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_vars_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 100
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_macros_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 102
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_decl_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 104
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 106
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_parent_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 108
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_namespace_2d_lookup
#undef ___PH_LBL0
#define ___PH_LBL0 110
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
   ___IF(___NOT(___FALSEP(___R1)))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(147),___L_c_23_make_2d_full_2d_name)
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
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L13_c_23_env_2d_namespace_2d_lookup)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L14_c_23_env_2d_namespace_2d_lookup)
   ___SET_R2(___CDR(___R1))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_namespace_2d_lookup)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(147),___L_c_23_make_2d_full_2d_name)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup
#undef ___PH_LBL0
#define ___PH_LBL0 119
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
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_lookup)
   ___JUMPINT(___SET_NARGS(1),___PRC(141),___L_c_23_full_2d_name_3f_)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-4))
   ___ADJFP(-6)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup)
   ___GOTO(___L21_c_23_env_2d_lookup)
___DEF_GLBL(___L19_c_23_env_2d_lookup)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R4)
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(1L)))
   ___ADJFP(1)
   ___IF(___EQP(___STK(0),___R1))
   ___GOTO(___L29_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup)
___DEF_GLBL(___L20_c_23_env_2d_lookup)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L19_c_23_env_2d_lookup)
   ___END_IF
   ___SET_STK(1,___STK(0))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(4L)))
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___STK(-3))))
   ___GOTO(___L30_c_23_env_2d_lookup)
   ___END_IF
   ___IF(___FALSEP(___R3))
   ___GOTO(___L30_c_23_env_2d_lookup)
   ___END_IF
   ___SET_STK(-1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-1))
   ___ADJFP(-2)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_lookup)
___DEF_GLBL(___L21_c_23_env_2d_lookup)
   ___IF(___NOT(___FALSEP(___R3)))
   ___GOTO(___L28_c_23_env_2d_lookup)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(7))
   ___ADJFP(6)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_lookup)
   ___JUMPINT(___SET_NARGS(2),___PRC(110),___L_c_23_env_2d_namespace_2d_lookup)
___DEF_SLBL(7,___L7_c_23_env_2d_lookup)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L22_c_23_env_2d_lookup)
   ___END_IF
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R3(___FAL)
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_lookup)
   ___GOTO(___L23_c_23_env_2d_lookup)
___DEF_GLBL(___L22_c_23_env_2d_lookup)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___TRU)
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_env_2d_lookup)
___DEF_GLBL(___L23_c_23_env_2d_lookup)
   ___SET_STK(1,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___SET_STK(2,___R3)
   ___SET_R3(___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___STK(2))
   ___SET_R1(___STK(3))
   ___ADJFP(1)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_env_2d_lookup)
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
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_env_2d_lookup)
___DEF_GLBL(___L25_c_23_env_2d_lookup)
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(2))
___DEF_GLBL(___L26_c_23_env_2d_lookup)
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_env_2d_lookup)
   ___GOTO(___L24_c_23_env_2d_lookup)
___DEF_GLBL(___L27_c_23_env_2d_lookup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(14))
   ___ADJFP(9)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_env_2d_lookup)
   ___JUMPINT(___SET_NARGS(1),___PRC(98),___L_c_23_env_2d_vars_2d_ref)
___DEF_SLBL(14,___L14_c_23_env_2d_lookup)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___ADJFP(-9)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_env_2d_lookup)
   ___GOTO(___L20_c_23_env_2d_lookup)
___DEF_GLBL(___L28_c_23_env_2d_lookup)
   ___SET_R3(___TRU)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_env_2d_lookup)
   ___GOTO(___L23_c_23_env_2d_lookup)
___DEF_GLBL(___L29_c_23_env_2d_lookup)
   ___SET_R3(___R4)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-1))
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_env_2d_lookup)
   ___GOTO(___L25_c_23_env_2d_lookup)
___DEF_GLBL(___L30_c_23_env_2d_lookup)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-1))
   ___SET_R3(___FAL)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_env_2d_lookup)
   ___GOTO(___L25_c_23_env_2d_lookup)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_valid_2d_prefix_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 139
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_valid_2d_prefix_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_valid_2d_prefix_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_valid_2d_prefix_3f_)
   ___SET_R2(___STRINGLENGTH(___R1))
   ___IF(___FIXEQ(___R2,___FIX(0L)))
   ___GOTO(___L2_c_23_valid_2d_prefix_3f_)
   ___END_IF
   ___IF(___NOT(___FIXGE(___R2,___FIX(2L))))
   ___GOTO(___L1_c_23_valid_2d_prefix_3f_)
   ___END_IF
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___STRINGREF(___R1,___R2))
   ___SET_R1(___BOOLEAN(___CHAREQP(___R1,___CHR(35))))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_c_23_valid_2d_prefix_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L2_c_23_valid_2d_prefix_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_full_2d_name_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 141
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
___DEF_P_HLBL(___L4_c_23_full_2d_name_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_full_2d_name_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_full_2d_name_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_full_2d_name_3f_)
   ___JUMPPRM(___SET_NARGS(1),___PRM_symbol_2d__3e_string)
___DEF_SLBL(2,___L2_c_23_full_2d_name_3f_)
   ___SET_R2(___STRINGLENGTH(___R1))
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_full_2d_name_3f_)
   ___GOTO(___L6_c_23_full_2d_name_3f_)
___DEF_GLBL(___L5_c_23_full_2d_name_3f_)
   ___SET_R3(___STRINGREF(___R1,___R2))
   ___IF(___CHAREQP(___R3,___CHR(35)))
   ___GOTO(___L7_c_23_full_2d_name_3f_)
   ___END_IF
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_full_2d_name_3f_)
___DEF_GLBL(___L6_c_23_full_2d_name_3f_)
   ___IF(___NOT(___FIXLT(___R2,___FIX(0L))))
   ___GOTO(___L5_c_23_full_2d_name_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L7_c_23_full_2d_name_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_full_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 147
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
___DEF_P_HLBL(___L4_c_23_make_2d_full_2d_name)
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
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_full_2d_name)
   ___JUMPPRM(___SET_NARGS(1),___PRM_symbol_2d__3e_string)
___DEF_SLBL(2,___L2_c_23_make_2d_full_2d_name)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_append)
___DEF_SLBL(3,___L3_c_23_make_2d_full_2d_name)
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_full_2d_name)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___DEF_GLBL(___L5_c_23_make_2d_full_2d_name)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 153
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
___DEF_P_HLBL(___L8_c_23_env_2d_lookup_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_lookup_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_env_2d_lookup_2d_var)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___ALLOC_CLO(1))
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
   ___JUMPINT(___SET_NARGS(4),___PRC(119),___L_c_23_env_2d_lookup)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(3,3,0,0)
   ___IF(___NOT(___FALSEP(___R3)))
   ___GOTO(___L9_c_23_env_2d_lookup_2d_var)
   ___END_IF
   ___SET_R3(___CLO(___R4,1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup_2d_var)
   ___JUMPINT(___SET_NARGS(3),___PRC(75),___L_c_23_env_2d_new_2d_var_21_)
___DEF_GLBL(___L9_c_23_env_2d_lookup_2d_var)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_lookup_2d_var)
   ___JUMPINT(___SET_NARGS(1),___PRC(12),___L_c_23_var_3f_)
___DEF_SLBL(6,___L6_c_23_env_2d_lookup_2d_var)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L10_c_23_env_2d_lookup_2d_var)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_lookup_2d_var)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),73,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L10_c_23_env_2d_lookup_2d_var)
   ___SET_R1(___STK(-5))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_lookup_2d_var)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_define_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 163
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
   ___SET_STK(2,___ALLOC_CLO(1))
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
   ___JUMPINT(___SET_NARGS(4),___PRC(119),___L_c_23_env_2d_lookup)
___DEF_SLBL(3,___L3_c_23_env_2d_define_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(3,3,0,0)
   ___IF(___NOT(___FALSEP(___R3)))
   ___GOTO(___L9_c_23_env_2d_define_2d_var)
   ___END_IF
   ___SET_R3(___CLO(___R4,1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_define_2d_var)
   ___JUMPINT(___SET_NARGS(3),___PRC(75),___L_c_23_env_2d_new_2d_var_21_)
___DEF_GLBL(___L9_c_23_env_2d_define_2d_var)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R4)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_define_2d_var)
   ___JUMPINT(___SET_NARGS(1),___PRC(12),___L_c_23_var_3f_)
___DEF_SLBL(6,___L6_c_23_env_2d_define_2d_var)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L10_c_23_env_2d_define_2d_var)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(1))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2d_define_2d_var)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),73,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L10_c_23_env_2d_define_2d_var)
   ___SET_R1(___CLO(___STK(-5),1))
   ___SET_R2(___SUB(2))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_env_2d_define_2d_var)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),77,___G_c_23_pt_2d_syntax_2d_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup_2d_global_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 173
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
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_lookup_2d_global_2d_var)
   ___JUMPINT(___SET_NARGS(1),___PRC(186),___L_c_23_env_2d_global_2d_env)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(98),___L_c_23_env_2d_vars_2d_ref)
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
   ___SET_STK(1,___R4)
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(1L)))
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
   ___JUMPINT(___SET_NARGS(3),___PRC(75),___L_c_23_env_2d_new_2d_var_21_)
___DEF_GLBL(___L9_c_23_env_2d_lookup_2d_global_2d_var)
   ___SET_R1(___R4)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_global_2d_variables
#undef ___PH_LBL0
#define ___PH_LBL0 181
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
___DEF_P_HLBL(___L3_c_23_env_2d_global_2d_variables)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2d_global_2d_variables)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_env_2d_global_2d_variables)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2d_global_2d_variables)
   ___JUMPINT(___SET_NARGS(1),___PRC(186),___L_c_23_env_2d_global_2d_env)
___DEF_SLBL(2,___L2_c_23_env_2d_global_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_env_2d_global_2d_variables)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_global_2d_env
#undef ___PH_LBL0
#define ___PH_LBL0 186
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2
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
   ___ADJFP(-1)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_env_2d_global_2d_env)
___DEF_GLBL(___L4_c_23_env_2d_global_2d_env)
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___STK(1),___FIX(4L)))
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___R2)))
   ___GOTO(___L3_c_23_env_2d_global_2d_env)
   ___END_IF
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2d_lookup_2d_macro
#undef ___PH_LBL0
#define ___PH_LBL0 190
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
___DEF_P_HLBL(___L5_c_23_env_2d_lookup_2d_macro)
___DEF_P_HLBL(___L6_c_23_env_2d_lookup_2d_macro)
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
   ___JUMPINT(___SET_NARGS(4),___PRC(119),___L_c_23_env_2d_lookup)
___DEF_SLBL(2,___L2_c_23_env_2d_lookup_2d_macro)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(2,3,0,0)
   ___IF(___FALSEP(___R3))
   ___GOTO(___L7_c_23_env_2d_lookup_2d_macro)
   ___END_IF
   ___GOTO(___L9_c_23_env_2d_lookup_2d_macro)
___DEF_SLBL(3,___L3_c_23_env_2d_lookup_2d_macro)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L8_c_23_env_2d_lookup_2d_macro)
   ___END_IF
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L7_c_23_env_2d_lookup_2d_macro)
   ___SET_R1(___FAL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_env_2d_lookup_2d_macro)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23_env_2d_lookup_2d_macro)
   ___SET_R1(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_env_2d_lookup_2d_macro)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L9_c_23_env_2d_lookup_2d_macro)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_env_2d_lookup_2d_macro)
   ___JUMPINT(___SET_NARGS(1),___PRC(12),___L_c_23_var_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_flag_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 198
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
   ___SET_GLO(33,___G_c_23_flag_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_flag_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_parameterized_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 201
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
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
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_define_2d_parameterized_2d_decl)
   ___SET_R1(___CONS(___R1,___GLO_c_23_parameterized_2d_declarations))
   ___SET_GLO(45,___G_c_23_parameterized_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_parameterized_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 204
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_namable_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 207
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
   ___SET_GLO(42,___G_c_23_namable_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_namable_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_define_2d_namable_2d_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 210
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
   ___SET_GLO(40,___G_c_23_namable_2d_boolean_2d_declarations,___R1)
   ___SET_R1(___NUL)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_define_2d_namable_2d_boolean_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_flag_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 213
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
   ___BEGIN_ALLOC_LIST(2,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_flag_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parameterized_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 216
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
   ___BEGIN_ALLOC_LIST(2,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_parameterized_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 219
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
   ___BEGIN_ALLOC_LIST(2,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_boolean_2d_decl)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_namable_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 222
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_namable_2d_boolean_2d_decl
#undef ___PH_LBL0
#define ___PH_LBL0 225
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
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_declaration_2d_value
#undef ___PH_LBL0
#define ___PH_LBL0 228
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
___DEF_P_HLBL(___L6_c_23_declaration_2d_value)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_declaration_2d_value)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_declaration_2d_value)
   ___SET_R3(___VECTORREF(___R3,___FIX(2L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_declaration_2d_value)
   ___GOTO(___L8_c_23_declaration_2d_value)
___DEF_SLBL(2,___L2_c_23_declaration_2d_value)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L15_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-10)
___DEF_GLBL(___L7_c_23_declaration_2d_value)
   ___SET_R3(___CDR(___R3))
   ___ADJFP(-1)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_declaration_2d_value)
___DEF_GLBL(___L8_c_23_declaration_2d_value)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L14_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___CAR(___R4))
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___STK(0),___STK(-1))))
   ___GOTO(___L7_c_23_declaration_2d_value)
   ___END_IF
   ___SET_STK(0,___CDDR(___R4))
   ___IF(___NOT(___NULLP(___STK(0))))
   ___GOTO(___L10_c_23_declaration_2d_value)
   ___END_IF
___DEF_GLBL(___L9_c_23_declaration_2d_value)
   ___SET_R1(___CADR(___R4))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_declaration_2d_value)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L10_c_23_declaration_2d_value)
   ___SET_STK(0,___CDDR(___R4))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___STK(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(10)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_declaration_2d_value)
   ___GOTO(___L12_c_23_declaration_2d_value)
___DEF_GLBL(___L11_c_23_declaration_2d_value)
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L13_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_declaration_2d_value)
___DEF_GLBL(___L12_c_23_declaration_2d_value)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L11_c_23_declaration_2d_value)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L13_c_23_declaration_2d_value)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L14_c_23_declaration_2d_value)
   ___SET_R1(___R2)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L15_c_23_declaration_2d_value)
   ___SET_R4(___STK(-5))
   ___SET_R0(___STK(-9))
   ___ADJFP(-10)
   ___GOTO(___L9_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2e_begin_21_
#undef ___PH_LBL0
#define ___PH_LBL0 236
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
___DEF_P_HLBL(___L7_c_23_env_2e_begin_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_env_2e_begin_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_env_2e_begin_21_)
   ___SET_STK(1,___R0)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_env_2e_begin_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),74,___G_c_23_make_2d_counter)
___DEF_SLBL(2,___L2_c_23_env_2e_begin_21_)
   ___SET_GLO(43,___G_c_23_next_2d_var_2d_stamp,___R1)
   ___SET_R1(___SYM_ret)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_make_2d_temp_2d_var)
___DEF_SLBL(3,___L3_c_23_env_2e_begin_21_)
   ___SET_GLO(46,___G_c_23_ret_2d_var,___R1)
   ___SET_R1(___GLO_c_23_ret_2d_var)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),79,___G_c_23_varset_2d_singleton)
___DEF_SLBL(4,___L4_c_23_env_2e_begin_21_)
   ___SET_GLO(47,___G_c_23_ret_2d_var_2d_set,___R1)
   ___SET_R1(___SYM_closure_2d_env)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_make_2d_temp_2d_var)
___DEF_SLBL(5,___L5_c_23_env_2e_begin_21_)
   ___SET_GLO(3,___G_c_23_closure_2d_env_2d_var,___R1)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_make_2d_temp_2d_var)
___DEF_SLBL(6,___L6_c_23_env_2e_begin_21_)
   ___SET_GLO(10,___G_c_23_empty_2d_var,___R1)
   ___SET_R1(___NUL)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_env_2e_begin_21_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_env_2e_end_21_
#undef ___PH_LBL0
#define ___PH_LBL0 245
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
   ___SET_GLO(43,___G_c_23_next_2d_var_2d_stamp,___NUL)
   ___SET_GLO(46,___G_c_23_ret_2d_var,___NUL)
   ___SET_GLO(47,___G_c_23_ret_2d_var_2d_set,___NUL)
   ___SET_GLO(3,___G_c_23_closure_2d_env_2d_var,___NUL)
   ___SET_GLO(10,___G_c_23_empty_2d_var,___NUL)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___env," _env",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__20___env,0,-1)
,___DEF_LBL_RET(___H__20___env,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H__20___env,0,-1)
,___DEF_LBL_RET(___H__20___env,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_var,"c#make-var",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_var,5,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_var,___OFD(___RETI,12,2,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_make_2d_var,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_make_2d_var,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_RET(___H_c_23_make_2d_var,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_INTRO(___H_c_23_var_3f_,"c#var?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_name,"c#var-name",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_name,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_bound,"c#var-bound",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_bound,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_refs,"c#var-refs",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_refs,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_sets,"c#var-sets",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_sets,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_source,"c#var-source",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_source,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_boxed_3f_,"c#var-boxed?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_boxed_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_info,"c#var-info",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_info,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_stamp,"c#var-stamp",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_stamp,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_constant,"c#var-constant",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_constant,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_clone,"c#var-clone",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_clone,1,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_name_2d_set_21_,"c#var-name-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_name_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_bound_2d_set_21_,"c#var-bound-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_bound_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_refs_2d_set_21_,"c#var-refs-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_refs_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_sets_2d_set_21_,"c#var-sets-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_sets_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_source_2d_set_21_,"c#var-source-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_source_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_boxed_3f__2d_set_21_,"c#var-boxed?-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_boxed_3f__2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_info_2d_set_21_,"c#var-info-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_info_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_stamp_2d_set_21_,"c#var-stamp-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_stamp_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_constant_2d_set_21_,"c#var-constant-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_constant_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_clone_2d_set_21_,"c#var-clone-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_clone_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_var_2d_lexical_2d_level,"c#var-lexical-level",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_lexical_2d_level,1,-1)
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_var_2d_lexical_2d_level,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_temp_2d_var,"c#make-temp-var",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_temp_2d_var,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETI,8,2,0x3f07L))
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETN,5,2,0x7L))
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETN,5,2,0xfL))
,___DEF_LBL_RET(___H_c_23_make_2d_temp_2d_var,___IFD(___RETI,8,8,0x3f0bL))
,___DEF_LBL_INTRO(___H_c_23_temp_2d_var_3f_,"c#temp-var?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_temp_2d_var_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_frame,"c#env-frame",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_frame,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_frame,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_new_2d_var_21_,"c#env-new-var!",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_new_2d_var_21_,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,9,0,0x7fL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,8,0,0x3f0dL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_env_2d_new_2d_var_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_macro,"c#env-macro",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_macro,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_env_2d_macro,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_declare,"c#env-declare",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_declare,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_declare,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace,"c#env-namespace",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_namespace,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_vars_2d_ref,"c#env-vars-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_vars_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_vars_2d_set_21_,"c#env-vars-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_vars_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_macros_2d_ref,"c#env-macros-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_macros_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_decl_2d_ref,"c#env-decl-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_decl_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace_2d_ref,"c#env-namespace-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_parent_2d_ref,"c#env-parent-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_parent_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H_c_23_env_2d_namespace_2d_lookup,"c#env-namespace-lookup",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_namespace_2d_lookup,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_namespace_2d_lookup,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup,"c#env-lookup",___REF_FAL,19,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup,4,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,8,3,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,8,2,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,4,4,0x3f2L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___OFD(___RETI,12,3,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,4,4,0x3f2L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup,___IFD(___RETI,4,4,0x3f2L))
,___DEF_LBL_INTRO(___H_c_23_valid_2d_prefix_3f_,"c#valid-prefix?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_valid_2d_prefix_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_full_2d_name_3f_,"c#full-name?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_full_2d_name_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_full_2d_name_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_full_2d_name,"c#make-full-name",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_full_2d_name,2,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_make_2d_full_2d_name,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup_2d_var,"c#env-lookup-var",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_var,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_var,3,1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_var,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_define_2d_var,"c#env-define-var",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_define_2d_var,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_env_2d_define_2d_var,3,1)
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_env_2d_define_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup_2d_global_2d_var,"c#env-lookup-global-var",___REF_FAL,7,0)

,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_global_2d_var,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_global_2d_var,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_global_2d_variables,"c#env-global-variables",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_global_2d_variables,1,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_variables,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_variables,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_variables,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_env_2d_global_2d_env,"c#env-global-env",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_global_2d_env,1,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_env,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_global_2d_env,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2d_lookup_2d_macro,"c#env-lookup-macro",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_macro,2,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_env_2d_lookup_2d_macro,3,-1)
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_env_2d_lookup_2d_macro,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H_c_23_define_2d_flag_2d_decl,"c#define-flag-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_flag_2d_decl,2,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_flag_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_parameterized_2d_decl,"c#define-parameterized-decl",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_parameterized_2d_decl,1,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_parameterized_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_boolean_2d_decl,"c#define-boolean-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_boolean_2d_decl,1,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_namable_2d_decl,"c#define-namable-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_namable_2d_decl,2,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_namable_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_define_2d_namable_2d_boolean_2d_decl,"c#define-namable-boolean-decl",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23_define_2d_namable_2d_boolean_2d_decl,1,-1)
,___DEF_LBL_RET(___H_c_23_define_2d_namable_2d_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_flag_2d_decl,"c#flag-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_flag_2d_decl,3,-1)
,___DEF_LBL_RET(___H_c_23_flag_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_parameterized_2d_decl,"c#parameterized-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_parameterized_2d_decl,3,-1)
,___DEF_LBL_RET(___H_c_23_parameterized_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_boolean_2d_decl,"c#boolean-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_boolean_2d_decl,3,-1)
,___DEF_LBL_RET(___H_c_23_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_namable_2d_decl,"c#namable-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_namable_2d_decl,4,-1)
,___DEF_LBL_RET(___H_c_23_namable_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_namable_2d_boolean_2d_decl,"c#namable-boolean-decl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_namable_2d_boolean_2d_decl,4,-1)
,___DEF_LBL_RET(___H_c_23_namable_2d_boolean_2d_decl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_declaration_2d_value,"c#declaration-value",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_declaration_2d_value,4,-1)
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_declaration_2d_value,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_env_2e_begin_21_,"c#env.begin!",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_env_2e_begin_21_,0,-1)
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_env_2e_begin_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_env_2e_end_21_,"c#env.end!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_env_2e_end_21_,0,-1)
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07dL)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20___env,1)
___DEF_MOD_PRM(38,___G_c_23_make_2d_var,6)
___DEF_MOD_PRM(72,___G_c_23_var_3f_,12)
___DEF_MOD_PRM(61,___G_c_23_var_2d_name,14)
___DEF_MOD_PRM(50,___G_c_23_var_2d_bound,16)
___DEF_MOD_PRM(63,___G_c_23_var_2d_refs,18)
___DEF_MOD_PRM(65,___G_c_23_var_2d_sets,20)
___DEF_MOD_PRM(67,___G_c_23_var_2d_source,22)
___DEF_MOD_PRM(52,___G_c_23_var_2d_boxed_3f_,24)
___DEF_MOD_PRM(58,___G_c_23_var_2d_info,26)
___DEF_MOD_PRM(69,___G_c_23_var_2d_stamp,28)
___DEF_MOD_PRM(56,___G_c_23_var_2d_constant,30)
___DEF_MOD_PRM(54,___G_c_23_var_2d_clone,32)
___DEF_MOD_PRM(62,___G_c_23_var_2d_name_2d_set_21_,34)
___DEF_MOD_PRM(51,___G_c_23_var_2d_bound_2d_set_21_,36)
___DEF_MOD_PRM(64,___G_c_23_var_2d_refs_2d_set_21_,38)
___DEF_MOD_PRM(66,___G_c_23_var_2d_sets_2d_set_21_,40)
___DEF_MOD_PRM(68,___G_c_23_var_2d_source_2d_set_21_,42)
___DEF_MOD_PRM(53,___G_c_23_var_2d_boxed_3f__2d_set_21_,44)
___DEF_MOD_PRM(59,___G_c_23_var_2d_info_2d_set_21_,46)
___DEF_MOD_PRM(70,___G_c_23_var_2d_stamp_2d_set_21_,48)
___DEF_MOD_PRM(57,___G_c_23_var_2d_constant_2d_set_21_,50)
___DEF_MOD_PRM(55,___G_c_23_var_2d_clone_2d_set_21_,52)
___DEF_MOD_PRM(60,___G_c_23_var_2d_lexical_2d_level,54)
___DEF_MOD_PRM(37,___G_c_23_make_2d_temp_2d_var,64)
___DEF_MOD_PRM(48,___G_c_23_temp_2d_var_3f_,70)
___DEF_MOD_PRM(14,___G_c_23_env_2d_frame,72)
___DEF_MOD_PRM(26,___G_c_23_env_2d_new_2d_var_21_,75)
___DEF_MOD_PRM(21,___G_c_23_env_2d_macro,85)
___DEF_MOD_PRM(12,___G_c_23_env_2d_declare,92)
___DEF_MOD_PRM(23,___G_c_23_env_2d_namespace,95)
___DEF_MOD_PRM(28,___G_c_23_env_2d_vars_2d_ref,98)
___DEF_MOD_PRM(29,___G_c_23_env_2d_vars_2d_set_21_,100)
___DEF_MOD_PRM(22,___G_c_23_env_2d_macros_2d_ref,102)
___DEF_MOD_PRM(11,___G_c_23_env_2d_decl_2d_ref,104)
___DEF_MOD_PRM(25,___G_c_23_env_2d_namespace_2d_ref,106)
___DEF_MOD_PRM(27,___G_c_23_env_2d_parent_2d_ref,108)
___DEF_MOD_PRM(24,___G_c_23_env_2d_namespace_2d_lookup,110)
___DEF_MOD_PRM(17,___G_c_23_env_2d_lookup,119)
___DEF_MOD_PRM(49,___G_c_23_valid_2d_prefix_3f_,139)
___DEF_MOD_PRM(34,___G_c_23_full_2d_name_3f_,141)
___DEF_MOD_PRM(35,___G_c_23_make_2d_full_2d_name,147)
___DEF_MOD_PRM(20,___G_c_23_env_2d_lookup_2d_var,153)
___DEF_MOD_PRM(13,___G_c_23_env_2d_define_2d_var,163)
___DEF_MOD_PRM(18,___G_c_23_env_2d_lookup_2d_global_2d_var,173)
___DEF_MOD_PRM(16,___G_c_23_env_2d_global_2d_variables,181)
___DEF_MOD_PRM(15,___G_c_23_env_2d_global_2d_env,186)
___DEF_MOD_PRM(19,___G_c_23_env_2d_lookup_2d_macro,190)
___DEF_MOD_PRM(6,___G_c_23_define_2d_flag_2d_decl,198)
___DEF_MOD_PRM(9,___G_c_23_define_2d_parameterized_2d_decl,201)
___DEF_MOD_PRM(5,___G_c_23_define_2d_boolean_2d_decl,204)
___DEF_MOD_PRM(8,___G_c_23_define_2d_namable_2d_decl,207)
___DEF_MOD_PRM(7,___G_c_23_define_2d_namable_2d_boolean_2d_decl,210)
___DEF_MOD_PRM(32,___G_c_23_flag_2d_decl,213)
___DEF_MOD_PRM(44,___G_c_23_parameterized_2d_decl,216)
___DEF_MOD_PRM(1,___G_c_23_boolean_2d_decl,219)
___DEF_MOD_PRM(41,___G_c_23_namable_2d_decl,222)
___DEF_MOD_PRM(39,___G_c_23_namable_2d_boolean_2d_decl,225)
___DEF_MOD_PRM(4,___G_c_23_declaration_2d_value,228)
___DEF_MOD_PRM(30,___G_c_23_env_2e_begin_21_,236)
___DEF_MOD_PRM(31,___G_c_23_env_2e_end_21_,245)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___env,1)
___DEF_MOD_GLO(38,___G_c_23_make_2d_var,6)
___DEF_MOD_GLO(72,___G_c_23_var_3f_,12)
___DEF_MOD_GLO(61,___G_c_23_var_2d_name,14)
___DEF_MOD_GLO(50,___G_c_23_var_2d_bound,16)
___DEF_MOD_GLO(63,___G_c_23_var_2d_refs,18)
___DEF_MOD_GLO(65,___G_c_23_var_2d_sets,20)
___DEF_MOD_GLO(67,___G_c_23_var_2d_source,22)
___DEF_MOD_GLO(52,___G_c_23_var_2d_boxed_3f_,24)
___DEF_MOD_GLO(58,___G_c_23_var_2d_info,26)
___DEF_MOD_GLO(69,___G_c_23_var_2d_stamp,28)
___DEF_MOD_GLO(56,___G_c_23_var_2d_constant,30)
___DEF_MOD_GLO(54,___G_c_23_var_2d_clone,32)
___DEF_MOD_GLO(62,___G_c_23_var_2d_name_2d_set_21_,34)
___DEF_MOD_GLO(51,___G_c_23_var_2d_bound_2d_set_21_,36)
___DEF_MOD_GLO(64,___G_c_23_var_2d_refs_2d_set_21_,38)
___DEF_MOD_GLO(66,___G_c_23_var_2d_sets_2d_set_21_,40)
___DEF_MOD_GLO(68,___G_c_23_var_2d_source_2d_set_21_,42)
___DEF_MOD_GLO(53,___G_c_23_var_2d_boxed_3f__2d_set_21_,44)
___DEF_MOD_GLO(59,___G_c_23_var_2d_info_2d_set_21_,46)
___DEF_MOD_GLO(70,___G_c_23_var_2d_stamp_2d_set_21_,48)
___DEF_MOD_GLO(57,___G_c_23_var_2d_constant_2d_set_21_,50)
___DEF_MOD_GLO(55,___G_c_23_var_2d_clone_2d_set_21_,52)
___DEF_MOD_GLO(60,___G_c_23_var_2d_lexical_2d_level,54)
___DEF_MOD_GLO(37,___G_c_23_make_2d_temp_2d_var,64)
___DEF_MOD_GLO(48,___G_c_23_temp_2d_var_3f_,70)
___DEF_MOD_GLO(14,___G_c_23_env_2d_frame,72)
___DEF_MOD_GLO(26,___G_c_23_env_2d_new_2d_var_21_,75)
___DEF_MOD_GLO(21,___G_c_23_env_2d_macro,85)
___DEF_MOD_GLO(12,___G_c_23_env_2d_declare,92)
___DEF_MOD_GLO(23,___G_c_23_env_2d_namespace,95)
___DEF_MOD_GLO(28,___G_c_23_env_2d_vars_2d_ref,98)
___DEF_MOD_GLO(29,___G_c_23_env_2d_vars_2d_set_21_,100)
___DEF_MOD_GLO(22,___G_c_23_env_2d_macros_2d_ref,102)
___DEF_MOD_GLO(11,___G_c_23_env_2d_decl_2d_ref,104)
___DEF_MOD_GLO(25,___G_c_23_env_2d_namespace_2d_ref,106)
___DEF_MOD_GLO(27,___G_c_23_env_2d_parent_2d_ref,108)
___DEF_MOD_GLO(24,___G_c_23_env_2d_namespace_2d_lookup,110)
___DEF_MOD_GLO(17,___G_c_23_env_2d_lookup,119)
___DEF_MOD_GLO(49,___G_c_23_valid_2d_prefix_3f_,139)
___DEF_MOD_GLO(34,___G_c_23_full_2d_name_3f_,141)
___DEF_MOD_GLO(35,___G_c_23_make_2d_full_2d_name,147)
___DEF_MOD_GLO(20,___G_c_23_env_2d_lookup_2d_var,153)
___DEF_MOD_GLO(13,___G_c_23_env_2d_define_2d_var,163)
___DEF_MOD_GLO(18,___G_c_23_env_2d_lookup_2d_global_2d_var,173)
___DEF_MOD_GLO(16,___G_c_23_env_2d_global_2d_variables,181)
___DEF_MOD_GLO(15,___G_c_23_env_2d_global_2d_env,186)
___DEF_MOD_GLO(19,___G_c_23_env_2d_lookup_2d_macro,190)
___DEF_MOD_GLO(6,___G_c_23_define_2d_flag_2d_decl,198)
___DEF_MOD_GLO(9,___G_c_23_define_2d_parameterized_2d_decl,201)
___DEF_MOD_GLO(5,___G_c_23_define_2d_boolean_2d_decl,204)
___DEF_MOD_GLO(8,___G_c_23_define_2d_namable_2d_decl,207)
___DEF_MOD_GLO(7,___G_c_23_define_2d_namable_2d_boolean_2d_decl,210)
___DEF_MOD_GLO(32,___G_c_23_flag_2d_decl,213)
___DEF_MOD_GLO(44,___G_c_23_parameterized_2d_decl,216)
___DEF_MOD_GLO(1,___G_c_23_boolean_2d_decl,219)
___DEF_MOD_GLO(41,___G_c_23_namable_2d_decl,222)
___DEF_MOD_GLO(39,___G_c_23_namable_2d_boolean_2d_decl,225)
___DEF_MOD_GLO(4,___G_c_23_declaration_2d_value,228)
___DEF_MOD_GLO(30,___G_c_23_env_2e_begin_21_,236)
___DEF_MOD_GLO(31,___G_c_23_env_2e_end_21_,245)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___env,"_env")
___DEF_MOD_SYM(1,___S_closure_2d_env,"closure-env")
___DEF_MOD_SYM(2,___S_ret,"ret")
___DEF_MOD_SYM(3,___S_var_2d_tag,"var-tag")
___END_MOD_SYM_KEY

#endif
