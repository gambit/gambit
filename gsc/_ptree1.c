#ifdef ___LINKER_INFO
; File: "_ptree1.c", produced by Gambit-C v4.6.7
(
406007
" _ptree1"
(" _ptree1")
(
"app-tag"
"begin-temp"
"case-temp"
"compilation-strategy"
"cond-temp"
"conj-tag"
"cst-tag"
"def-tag"
"dialect"
"disj-tag"
"do-temp"
"dsssl"
"extended"
"fut-tag"
"ieee"
"none"
"prc-tag"
"pred"
"r4rs"
"r5rs"
"ref-tag"
"set-tag"
"true"
"tst-tag"
)
(
)
(
" _ptree1"
"c#**and-expr?"
"c#**begin-cmd-or-expr?"
"c#**begin-expr?"
"c#**case-expr?"
"c#**cond-expr?"
"c#**declare-expr?"
"c#**delay-expr?"
"c#**do-expr?"
"c#**future-expr?"
"c#**if-expr?"
"c#**include-expr?"
"c#**let*-expr?"
"c#**let-expr?"
"c#**letrec-expr?"
"c#**namespace-expr?"
"c#**or-expr?"
"c#**quasiquote-expr?"
"c#**quote-expr?"
"c#*ptree-port*"
"c#add-declarations"
"c#add-extended-bindings"
"c#add-macro"
"c#add-namespace"
"c#app->specialized-proc"
"c#app-args"
"c#app-oper"
"c#app-tag"
"c#app?"
"c#append-form"
"c#begin-body"
"c#bindable-var?"
"c#bound-free-variables"
"c#bound?"
"c#check-multiple-global-defs"
"c#combination-expr?"
"c#conj-tag"
"c#conj?"
"c#cons-form"
"c#cst-tag"
"c#cst?"
"c#def-tag"
"c#def-val"
"c#def?"
"c#definition-name"
"c#definition-value"
"c#disj-tag"
"c#disj?"
"c#extended-binding?"
"c#extract-names"
"c#extract-parameters"
"c#free-variables"
"c#fut-tag"
"c#fut?"
"c#global-proc-obj"
"c#global-single-def"
"c#global?"
"c#ill-formed-special-form"
"c#length?"
"c#list-construction?"
"c#macro-expand"
"c#macro-expr?"
"c#match"
"c#new-call"
"c#new-call*"
"c#new-conj"
"c#new-cst"
"c#new-def"
"c#new-disj"
"c#new-disj-call"
"c#new-fut"
"c#new-prc"
"c#new-ref"
"c#new-ref-extended-bindings"
"c#new-seq"
"c#new-set"
"c#new-temp-variable"
"c#new-tst"
"c#new-variable"
"c#next-node-stamp"
"c#node-env"
"c#node-fv-invalidate!"
"c#not-macro"
"c#prc-tag"
"c#prc?"
"c#proper-bindings?"
"c#proper-case-clauses?"
"c#proper-clauses?"
"c#proper-do-bindings?"
"c#proper-do-exit?"
"c#proper-length"
"c#proper-selector-list?"
"c#pt"
"c#pt-and"
"c#pt-begin"
"c#pt-body"
"c#pt-case"
"c#pt-combination"
"c#pt-cond"
"c#pt-delay"
"c#pt-do"
"c#pt-future"
"c#pt-if"
"c#pt-lambda"
"c#pt-let"
"c#pt-let*"
"c#pt-letrec"
"c#pt-or"
"c#pt-quasiquotation"
"c#pt-quasiquotation-list"
"c#pt-quasiquote"
"c#pt-quote"
"c#pt-recursive-let"
"c#pt-self-eval"
"c#pt-sequence"
"c#pt-set!"
"c#pt-syntax-error"
"c#pt-var"
"c#quasiquote-expr?"
"c#ref-tag"
"c#ref?"
"c#scheme-dialect"
"c#self-eval-expr?"
"c#self-evaluating?"
"c#set-prc-names!"
"c#set-tag"
"c#set?"
"c#source->parms"
"c#specialize-app"
"c#specialize-proc"
"c#standard-binding?"
"c#standard-proc-obj"
"c#standard-procedure?"
"c#temp-variable-stamp"
"c#transform-declaration"
"c#tst-tag"
"c#tst?"
"c#unquote-expr?"
"c#unquote-splicing-expr?"
"c#var-expr?"
"c#vector-form"
)
(
"c#**define-expr?"
"c#**define-macro-expr?"
"c#**define-syntax-expr?"
"c#**lambda-expr?"
"c#**set!-expr?"
"c#add-not-inline-primitives"
"c#add-not-interrupts-enabled"
"c#add-not-safe"
"c#add-proper-tail-calls"
"c#block-compilation?"
"c#bound-variables"
"c#conj-alt"
"c#conj-pre"
"c#constant-fold?"
"c#core?"
"c#cst-val"
"c#cst-val-set!"
"c#debug-environments?"
"c#debug-location?"
"c#debug-source?"
"c#debug?"
"c#def-var"
"c#def-var-set!"
"c#disj-alt"
"c#disj-pre"
"c#environment-map?"
"c#fut-val"
"c#global-singly-bound?"
"c#inline-primitive?"
"c#inline?"
"c#inlining-limit"
"c#intrs-enabled?"
"c#lambda-expr?"
"c#lambda-lift?"
"c#make-app"
"c#make-conj"
"c#make-cst"
"c#make-def"
"c#make-disj"
"c#make-fut"
"c#make-prc"
"c#make-ref"
"c#make-set"
"c#make-tst"
"c#mutable?"
"c#nb-args-conforms?"
"c#new-let"
"c#new-variables"
"c#node-bfv"
"c#node-bfv-set!"
"c#node-children"
"c#node-children-set!"
"c#node-env-set!"
"c#node-fv"
"c#node-fv-set!"
"c#node-parent"
"c#node-parent-set!"
"c#node-source"
"c#node-source-set!"
"c#node-stamp"
"c#node-stamp-set!"
"c#oper-pos?"
"c#optimize-dead-local-variables?"
"c#parameter-default-source"
"c#parameter-name"
"c#parameter-source"
"c#parms->source"
"c#parse-program"
"c#prc-body"
"c#prc-c-name"
"c#prc-c-name-set!"
"c#prc-keys"
"c#prc-keys-set!"
"c#prc-name"
"c#prc-name-set!"
"c#prc-opts"
"c#prc-opts-set!"
"c#prc-parms"
"c#prc-parms-set!"
"c#prc-req-and-opt-parms-only?"
"c#prc-rest?"
"c#prc-rest?-set!"
"c#proper-tail-calls?"
"c#ptree.begin!"
"c#ptree.end!"
"c#ref-var"
"c#ref-var-set!"
"c#run-time-binding?"
"c#safe?"
"c#set-val"
"c#set-var"
"c#set-var-set!"
"c#tst-alt"
"c#tst-con"
"c#tst-pre"
"c#warnings?"
)
(
"##integer?"
"##macro-descr-def-syntax?"
"##macro-descr-expander"
"##macro-descr-size"
"##make-macro-descr"
"##make-source"
"##source-code"
"##source-locat"
"##sourcify-deep"
"append"
"apply"
"c#**and-sym"
"c#**begin-sym"
"c#**c-declare-expr?"
"c#**c-define-expr?"
"c#**c-define-type-expr?"
"c#**c-initialize-expr?"
"c#**c-lambda-expr?"
"c#**case-sym"
"c#**cond-sym"
"c#**declare-sym"
"c#**define-macro-sym"
"c#**define-sym"
"c#**define-syntax-sym"
"c#**delay-sym"
"c#**do-sym"
"c#**eq?-sym"
"c#**eqv?-sym"
"c#**future-sym"
"c#**if-sym"
"c#**include-sym"
"c#**lambda-sym"
"c#**let*-sym"
"c#**let-sym"
"c#**letrec-sym"
"c#**make-promise-sym"
"c#**namespace-sym"
"c#**or-sym"
"c#**quasi-append-sym"
"c#**quasi-cons-proc-obj"
"c#**quasi-cons-sym"
"c#**quasi-list->vector-sym"
"c#**quasi-list-proc-obj"
"c#**quasi-list-sym"
"c#**quasi-vector-sym"
"c#**quasiquote-sym"
"c#**quote-sym"
"c#**set!-sym"
"c#=>-sym"
"c#absent-object"
"c#add-c-decl"
"c#add-c-init"
"c#add-c-type"
"c#block-sym"
"c#boolean-decl"
"c#boolean-declarations"
"c#build-c-define"
"c#c-declaration-body"
"c#c-definition-name"
"c#c-definition-param-types"
"c#c-definition-proc-name"
"c#c-definition-result-type"
"c#c-definition-scope"
"c#c-definition-value"
"c#c-initialization-body"
"c#c-interface-begin"
"c#c-interface-end"
"c#c-type-definition-name"
"c#c-type-definition-type"
"c#compiler-internal-error"
"c#compiler-option-debug"
"c#compiler-option-debug-environments"
"c#compiler-option-debug-location"
"c#compiler-option-debug-source"
"c#compiler-user-error"
"c#compiler-user-warning"
"c#constant-fold-sym"
"c#core-sym"
"c#debug-environments-sym"
"c#debug-location-sym"
"c#debug-source-sym"
"c#debug-sym"
"c#declaration-value"
"c#define-boolean-decl"
"c#define-flag-decl"
"c#define-namable-boolean-decl"
"c#define-parameterized-decl"
"c#else-sym"
"c#end-of-file-object?"
"c#env-declare"
"c#env-define-var"
"c#env-frame"
"c#env-global-variables"
"c#env-lookup-global-var"
"c#env-lookup-macro"
"c#env-lookup-var"
"c#env-macro"
"c#env-namespace"
"c#environment-map-sym"
"c#expression->source"
"c#extended-bindings-sym"
"c#false-object"
"c#false-object?"
"c#flag-decl"
"c#flag-declarations"
"c#gambit-scheme-sym"
"c#ieee-scheme-sym"
"c#include-expr->source"
"c#inline-primitives-sym"
"c#inline-sym"
"c#inlining-limit-sym"
"c#interrupts-enabled-sym"
"c#keep"
"c#key-object?"
"c#keyword-object?"
"c#lambda-lift-sym"
"c#lambda-sym"
"c#list->varset"
"c#list->vect"
"c#make-counter"
"c#make-gnode"
"c#multilisp-sym"
"c#namable-boolean-decl"
"c#namable-boolean-declarations"
"c#namable-decl"
"c#namable-declarations"
"c#next-var-stamp"
"c#not-sym"
"c#optimize-dead-local-variables-sym"
"c#optional-object?"
"c#pair-up"
"c#parameterized-decl"
"c#parameterized-declarations"
"c#pattern-member?"
"c#proc-obj-call-pat"
"c#proc-obj-specialize"
"c#proc-obj-standard"
"c#proc-obj?"
"c#proper-tail-calls-sym"
"c#pt-c-lambda"
"c#ptset->list"
"c#ptset-adjoin"
"c#ptset-empty"
"c#ptset-empty?"
"c#quasiquote-sym"
"c#r4rs-scheme-sym"
"c#r5rs-scheme-sym"
"c#rest-object?"
"c#run-time-bindings-sym"
"c#safe-sym"
"c#scheme-global-eval"
"c#separate-sym"
"c#source->expression"
"c#source-code"
"c#standard-bindings-sym"
"c#string->keyword-object"
"c#symbol-object?"
"c#target.prim-info"
"c#topological-sort"
"c#transitive-closure"
"c#unbound1-object?"
"c#unbound2-object?"
"c#unquote-splicing-sym"
"c#unquote-sym"
"c#valid-prefix?"
"c#var-name"
"c#var-tag"
"c#varset->list"
"c#varset-adjoin"
"c#varset-difference"
"c#varset-intersection"
"c#varset-intersects?"
"c#varset-union-multi"
"c#vect->list"
"c#vector-object?"
"c#void-object"
"c#void-object?"
"c#warnings-sym"
"display"
"exact?"
"length"
"list-ref"
"newline"
"number->string"
"reverse"
"string->symbol"
"string-append"
"substring"
"symbol->string"
"write"
)
 #f
)
#else
#define ___VERSION 406007
#define ___MODULE_NAME " _ptree1"
#define ___LINKER_ID ____20___ptree1
#define ___MH_PROC ___H__20___ptree1
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 24
#define ___GLOCOUNT 427
#define ___SUPCOUNT 237
#define ___SUBCOUNT 98
#define ___LBLCOUNT 2028
#define ___OFDCOUNT 236
#include "gambit.h"

___NEED_SYM(___S_app_2d_tag)
___NEED_SYM(___S_begin_2d_temp)
___NEED_SYM(___S_case_2d_temp)
___NEED_SYM(___S_compilation_2d_strategy)
___NEED_SYM(___S_cond_2d_temp)
___NEED_SYM(___S_conj_2d_tag)
___NEED_SYM(___S_cst_2d_tag)
___NEED_SYM(___S_def_2d_tag)
___NEED_SYM(___S_dialect)
___NEED_SYM(___S_disj_2d_tag)
___NEED_SYM(___S_do_2d_temp)
___NEED_SYM(___S_dsssl)
___NEED_SYM(___S_extended)
___NEED_SYM(___S_fut_2d_tag)
___NEED_SYM(___S_ieee)
___NEED_SYM(___S_none)
___NEED_SYM(___S_prc_2d_tag)
___NEED_SYM(___S_pred)
___NEED_SYM(___S_r4rs)
___NEED_SYM(___S_r5rs)
___NEED_SYM(___S_ref_2d_tag)
___NEED_SYM(___S_set_2d_tag)
___NEED_SYM(___S_true)
___NEED_SYM(___S_tst_2d_tag)

___NEED_GLO(___G__20___ptree1)
___NEED_GLO(___G__23__23_integer_3f_)
___NEED_GLO(___G__23__23_macro_2d_descr_2d_def_2d_syntax_3f_)
___NEED_GLO(___G__23__23_macro_2d_descr_2d_expander)
___NEED_GLO(___G__23__23_macro_2d_descr_2d_size)
___NEED_GLO(___G__23__23_make_2d_macro_2d_descr)
___NEED_GLO(___G__23__23_make_2d_source)
___NEED_GLO(___G__23__23_source_2d_code)
___NEED_GLO(___G__23__23_source_2d_locat)
___NEED_GLO(___G__23__23_sourcify_2d_deep)
___NEED_GLO(___G_append)
___NEED_GLO(___G_apply)
___NEED_GLO(___G_c_23__2a__2a_and_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_and_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_begin_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_begin_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_c_2d_declare_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_c_2d_define_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_c_2d_initialize_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_c_2d_lambda_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_case_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_case_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_cond_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_cond_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_declare_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_declare_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_define_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_define_2d_macro_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_define_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_define_2d_syntax_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_delay_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_delay_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_do_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_do_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_eq_3f__2d_sym)
___NEED_GLO(___G_c_23__2a__2a_eqv_3f__2d_sym)
___NEED_GLO(___G_c_23__2a__2a_future_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_future_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_if_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_if_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_include_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_include_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_lambda_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_lambda_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_let_2a__2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_let_2a__2d_sym)
___NEED_GLO(___G_c_23__2a__2a_let_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_let_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_letrec_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_letrec_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_make_2d_promise_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_namespace_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_namespace_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_or_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_or_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_append_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_cons_2d_proc_2d_obj)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_cons_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_list_2d__3e_vector_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_list_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quasi_2d_vector_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quasiquote_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_quasiquote_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_quote_2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_quote_2d_sym)
___NEED_GLO(___G_c_23__2a__2a_set_21__2d_expr_3f_)
___NEED_GLO(___G_c_23__2a__2a_set_21__2d_sym)
___NEED_GLO(___G_c_23__2a_ptree_2d_port_2a_)
___NEED_GLO(___G_c_23__3d__3e__2d_sym)
___NEED_GLO(___G_c_23_absent_2d_object)
___NEED_GLO(___G_c_23_add_2d_c_2d_decl)
___NEED_GLO(___G_c_23_add_2d_c_2d_init)
___NEED_GLO(___G_c_23_add_2d_c_2d_type)
___NEED_GLO(___G_c_23_add_2d_declarations)
___NEED_GLO(___G_c_23_add_2d_extended_2d_bindings)
___NEED_GLO(___G_c_23_add_2d_macro)
___NEED_GLO(___G_c_23_add_2d_namespace)
___NEED_GLO(___G_c_23_add_2d_not_2d_inline_2d_primitives)
___NEED_GLO(___G_c_23_add_2d_not_2d_interrupts_2d_enabled)
___NEED_GLO(___G_c_23_add_2d_not_2d_safe)
___NEED_GLO(___G_c_23_add_2d_proper_2d_tail_2d_calls)
___NEED_GLO(___G_c_23_app_2d__3e_specialized_2d_proc)
___NEED_GLO(___G_c_23_app_2d_args)
___NEED_GLO(___G_c_23_app_2d_oper)
___NEED_GLO(___G_c_23_app_2d_tag)
___NEED_GLO(___G_c_23_app_3f_)
___NEED_GLO(___G_c_23_append_2d_form)
___NEED_GLO(___G_c_23_begin_2d_body)
___NEED_GLO(___G_c_23_bindable_2d_var_3f_)
___NEED_GLO(___G_c_23_block_2d_compilation_3f_)
___NEED_GLO(___G_c_23_block_2d_sym)
___NEED_GLO(___G_c_23_boolean_2d_decl)
___NEED_GLO(___G_c_23_boolean_2d_declarations)
___NEED_GLO(___G_c_23_bound_2d_free_2d_variables)
___NEED_GLO(___G_c_23_bound_2d_variables)
___NEED_GLO(___G_c_23_bound_3f_)
___NEED_GLO(___G_c_23_build_2d_c_2d_define)
___NEED_GLO(___G_c_23_c_2d_declaration_2d_body)
___NEED_GLO(___G_c_23_c_2d_definition_2d_name)
___NEED_GLO(___G_c_23_c_2d_definition_2d_param_2d_types)
___NEED_GLO(___G_c_23_c_2d_definition_2d_proc_2d_name)
___NEED_GLO(___G_c_23_c_2d_definition_2d_result_2d_type)
___NEED_GLO(___G_c_23_c_2d_definition_2d_scope)
___NEED_GLO(___G_c_23_c_2d_definition_2d_value)
___NEED_GLO(___G_c_23_c_2d_initialization_2d_body)
___NEED_GLO(___G_c_23_c_2d_interface_2d_begin)
___NEED_GLO(___G_c_23_c_2d_interface_2d_end)
___NEED_GLO(___G_c_23_c_2d_type_2d_definition_2d_name)
___NEED_GLO(___G_c_23_c_2d_type_2d_definition_2d_type)
___NEED_GLO(___G_c_23_check_2d_multiple_2d_global_2d_defs)
___NEED_GLO(___G_c_23_combination_2d_expr_3f_)
___NEED_GLO(___G_c_23_compiler_2d_internal_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_option_2d_debug)
___NEED_GLO(___G_c_23_compiler_2d_option_2d_debug_2d_environments)
___NEED_GLO(___G_c_23_compiler_2d_option_2d_debug_2d_location)
___NEED_GLO(___G_c_23_compiler_2d_option_2d_debug_2d_source)
___NEED_GLO(___G_c_23_compiler_2d_user_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_user_2d_warning)
___NEED_GLO(___G_c_23_conj_2d_alt)
___NEED_GLO(___G_c_23_conj_2d_pre)
___NEED_GLO(___G_c_23_conj_2d_tag)
___NEED_GLO(___G_c_23_conj_3f_)
___NEED_GLO(___G_c_23_cons_2d_form)
___NEED_GLO(___G_c_23_constant_2d_fold_2d_sym)
___NEED_GLO(___G_c_23_constant_2d_fold_3f_)
___NEED_GLO(___G_c_23_core_2d_sym)
___NEED_GLO(___G_c_23_core_3f_)
___NEED_GLO(___G_c_23_cst_2d_tag)
___NEED_GLO(___G_c_23_cst_2d_val)
___NEED_GLO(___G_c_23_cst_2d_val_2d_set_21_)
___NEED_GLO(___G_c_23_cst_3f_)
___NEED_GLO(___G_c_23_debug_2d_environments_2d_sym)
___NEED_GLO(___G_c_23_debug_2d_environments_3f_)
___NEED_GLO(___G_c_23_debug_2d_location_2d_sym)
___NEED_GLO(___G_c_23_debug_2d_location_3f_)
___NEED_GLO(___G_c_23_debug_2d_source_2d_sym)
___NEED_GLO(___G_c_23_debug_2d_source_3f_)
___NEED_GLO(___G_c_23_debug_2d_sym)
___NEED_GLO(___G_c_23_debug_3f_)
___NEED_GLO(___G_c_23_declaration_2d_value)
___NEED_GLO(___G_c_23_def_2d_tag)
___NEED_GLO(___G_c_23_def_2d_val)
___NEED_GLO(___G_c_23_def_2d_var)
___NEED_GLO(___G_c_23_def_2d_var_2d_set_21_)
___NEED_GLO(___G_c_23_def_3f_)
___NEED_GLO(___G_c_23_define_2d_boolean_2d_decl)
___NEED_GLO(___G_c_23_define_2d_flag_2d_decl)
___NEED_GLO(___G_c_23_define_2d_namable_2d_boolean_2d_decl)
___NEED_GLO(___G_c_23_define_2d_parameterized_2d_decl)
___NEED_GLO(___G_c_23_definition_2d_name)
___NEED_GLO(___G_c_23_definition_2d_value)
___NEED_GLO(___G_c_23_disj_2d_alt)
___NEED_GLO(___G_c_23_disj_2d_pre)
___NEED_GLO(___G_c_23_disj_2d_tag)
___NEED_GLO(___G_c_23_disj_3f_)
___NEED_GLO(___G_c_23_else_2d_sym)
___NEED_GLO(___G_c_23_end_2d_of_2d_file_2d_object_3f_)
___NEED_GLO(___G_c_23_env_2d_declare)
___NEED_GLO(___G_c_23_env_2d_define_2d_var)
___NEED_GLO(___G_c_23_env_2d_frame)
___NEED_GLO(___G_c_23_env_2d_global_2d_variables)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_global_2d_var)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_macro)
___NEED_GLO(___G_c_23_env_2d_lookup_2d_var)
___NEED_GLO(___G_c_23_env_2d_macro)
___NEED_GLO(___G_c_23_env_2d_namespace)
___NEED_GLO(___G_c_23_environment_2d_map_2d_sym)
___NEED_GLO(___G_c_23_environment_2d_map_3f_)
___NEED_GLO(___G_c_23_expression_2d__3e_source)
___NEED_GLO(___G_c_23_extended_2d_binding_3f_)
___NEED_GLO(___G_c_23_extended_2d_bindings_2d_sym)
___NEED_GLO(___G_c_23_extract_2d_names)
___NEED_GLO(___G_c_23_extract_2d_parameters)
___NEED_GLO(___G_c_23_false_2d_object)
___NEED_GLO(___G_c_23_false_2d_object_3f_)
___NEED_GLO(___G_c_23_flag_2d_decl)
___NEED_GLO(___G_c_23_flag_2d_declarations)
___NEED_GLO(___G_c_23_free_2d_variables)
___NEED_GLO(___G_c_23_fut_2d_tag)
___NEED_GLO(___G_c_23_fut_2d_val)
___NEED_GLO(___G_c_23_fut_3f_)
___NEED_GLO(___G_c_23_gambit_2d_scheme_2d_sym)
___NEED_GLO(___G_c_23_global_2d_proc_2d_obj)
___NEED_GLO(___G_c_23_global_2d_single_2d_def)
___NEED_GLO(___G_c_23_global_2d_singly_2d_bound_3f_)
___NEED_GLO(___G_c_23_global_3f_)
___NEED_GLO(___G_c_23_ieee_2d_scheme_2d_sym)
___NEED_GLO(___G_c_23_ill_2d_formed_2d_special_2d_form)
___NEED_GLO(___G_c_23_include_2d_expr_2d__3e_source)
___NEED_GLO(___G_c_23_inline_2d_primitive_3f_)
___NEED_GLO(___G_c_23_inline_2d_primitives_2d_sym)
___NEED_GLO(___G_c_23_inline_2d_sym)
___NEED_GLO(___G_c_23_inline_3f_)
___NEED_GLO(___G_c_23_inlining_2d_limit)
___NEED_GLO(___G_c_23_inlining_2d_limit_2d_sym)
___NEED_GLO(___G_c_23_interrupts_2d_enabled_2d_sym)
___NEED_GLO(___G_c_23_intrs_2d_enabled_3f_)
___NEED_GLO(___G_c_23_keep)
___NEED_GLO(___G_c_23_key_2d_object_3f_)
___NEED_GLO(___G_c_23_keyword_2d_object_3f_)
___NEED_GLO(___G_c_23_lambda_2d_expr_3f_)
___NEED_GLO(___G_c_23_lambda_2d_lift_2d_sym)
___NEED_GLO(___G_c_23_lambda_2d_lift_3f_)
___NEED_GLO(___G_c_23_lambda_2d_sym)
___NEED_GLO(___G_c_23_length_3f_)
___NEED_GLO(___G_c_23_list_2d__3e_varset)
___NEED_GLO(___G_c_23_list_2d__3e_vect)
___NEED_GLO(___G_c_23_list_2d_construction_3f_)
___NEED_GLO(___G_c_23_macro_2d_expand)
___NEED_GLO(___G_c_23_macro_2d_expr_3f_)
___NEED_GLO(___G_c_23_make_2d_app)
___NEED_GLO(___G_c_23_make_2d_conj)
___NEED_GLO(___G_c_23_make_2d_counter)
___NEED_GLO(___G_c_23_make_2d_cst)
___NEED_GLO(___G_c_23_make_2d_def)
___NEED_GLO(___G_c_23_make_2d_disj)
___NEED_GLO(___G_c_23_make_2d_fut)
___NEED_GLO(___G_c_23_make_2d_gnode)
___NEED_GLO(___G_c_23_make_2d_prc)
___NEED_GLO(___G_c_23_make_2d_ref)
___NEED_GLO(___G_c_23_make_2d_set)
___NEED_GLO(___G_c_23_make_2d_tst)
___NEED_GLO(___G_c_23_match)
___NEED_GLO(___G_c_23_multilisp_2d_sym)
___NEED_GLO(___G_c_23_mutable_3f_)
___NEED_GLO(___G_c_23_namable_2d_boolean_2d_decl)
___NEED_GLO(___G_c_23_namable_2d_boolean_2d_declarations)
___NEED_GLO(___G_c_23_namable_2d_decl)
___NEED_GLO(___G_c_23_namable_2d_declarations)
___NEED_GLO(___G_c_23_nb_2d_args_2d_conforms_3f_)
___NEED_GLO(___G_c_23_new_2d_call)
___NEED_GLO(___G_c_23_new_2d_call_2a_)
___NEED_GLO(___G_c_23_new_2d_conj)
___NEED_GLO(___G_c_23_new_2d_cst)
___NEED_GLO(___G_c_23_new_2d_def)
___NEED_GLO(___G_c_23_new_2d_disj)
___NEED_GLO(___G_c_23_new_2d_disj_2d_call)
___NEED_GLO(___G_c_23_new_2d_fut)
___NEED_GLO(___G_c_23_new_2d_let)
___NEED_GLO(___G_c_23_new_2d_prc)
___NEED_GLO(___G_c_23_new_2d_ref)
___NEED_GLO(___G_c_23_new_2d_ref_2d_extended_2d_bindings)
___NEED_GLO(___G_c_23_new_2d_seq)
___NEED_GLO(___G_c_23_new_2d_set)
___NEED_GLO(___G_c_23_new_2d_temp_2d_variable)
___NEED_GLO(___G_c_23_new_2d_tst)
___NEED_GLO(___G_c_23_new_2d_variable)
___NEED_GLO(___G_c_23_new_2d_variables)
___NEED_GLO(___G_c_23_next_2d_node_2d_stamp)
___NEED_GLO(___G_c_23_next_2d_var_2d_stamp)
___NEED_GLO(___G_c_23_node_2d_bfv)
___NEED_GLO(___G_c_23_node_2d_bfv_2d_set_21_)
___NEED_GLO(___G_c_23_node_2d_children)
___NEED_GLO(___G_c_23_node_2d_children_2d_set_21_)
___NEED_GLO(___G_c_23_node_2d_env)
___NEED_GLO(___G_c_23_node_2d_env_2d_set_21_)
___NEED_GLO(___G_c_23_node_2d_fv)
___NEED_GLO(___G_c_23_node_2d_fv_2d_invalidate_21_)
___NEED_GLO(___G_c_23_node_2d_fv_2d_set_21_)
___NEED_GLO(___G_c_23_node_2d_parent)
___NEED_GLO(___G_c_23_node_2d_parent_2d_set_21_)
___NEED_GLO(___G_c_23_node_2d_source)
___NEED_GLO(___G_c_23_node_2d_source_2d_set_21_)
___NEED_GLO(___G_c_23_node_2d_stamp)
___NEED_GLO(___G_c_23_node_2d_stamp_2d_set_21_)
___NEED_GLO(___G_c_23_not_2d_macro)
___NEED_GLO(___G_c_23_not_2d_sym)
___NEED_GLO(___G_c_23_oper_2d_pos_3f_)
___NEED_GLO(___G_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym)
___NEED_GLO(___G_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
___NEED_GLO(___G_c_23_optional_2d_object_3f_)
___NEED_GLO(___G_c_23_pair_2d_up)
___NEED_GLO(___G_c_23_parameter_2d_default_2d_source)
___NEED_GLO(___G_c_23_parameter_2d_name)
___NEED_GLO(___G_c_23_parameter_2d_source)
___NEED_GLO(___G_c_23_parameterized_2d_decl)
___NEED_GLO(___G_c_23_parameterized_2d_declarations)
___NEED_GLO(___G_c_23_parms_2d__3e_source)
___NEED_GLO(___G_c_23_parse_2d_program)
___NEED_GLO(___G_c_23_pattern_2d_member_3f_)
___NEED_GLO(___G_c_23_prc_2d_body)
___NEED_GLO(___G_c_23_prc_2d_c_2d_name)
___NEED_GLO(___G_c_23_prc_2d_c_2d_name_2d_set_21_)
___NEED_GLO(___G_c_23_prc_2d_keys)
___NEED_GLO(___G_c_23_prc_2d_keys_2d_set_21_)
___NEED_GLO(___G_c_23_prc_2d_name)
___NEED_GLO(___G_c_23_prc_2d_name_2d_set_21_)
___NEED_GLO(___G_c_23_prc_2d_opts)
___NEED_GLO(___G_c_23_prc_2d_opts_2d_set_21_)
___NEED_GLO(___G_c_23_prc_2d_parms)
___NEED_GLO(___G_c_23_prc_2d_parms_2d_set_21_)
___NEED_GLO(___G_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
___NEED_GLO(___G_c_23_prc_2d_rest_3f_)
___NEED_GLO(___G_c_23_prc_2d_rest_3f__2d_set_21_)
___NEED_GLO(___G_c_23_prc_2d_tag)
___NEED_GLO(___G_c_23_prc_3f_)
___NEED_GLO(___G_c_23_proc_2d_obj_2d_call_2d_pat)
___NEED_GLO(___G_c_23_proc_2d_obj_2d_specialize)
___NEED_GLO(___G_c_23_proc_2d_obj_2d_standard)
___NEED_GLO(___G_c_23_proc_2d_obj_3f_)
___NEED_GLO(___G_c_23_proper_2d_bindings_3f_)
___NEED_GLO(___G_c_23_proper_2d_case_2d_clauses_3f_)
___NEED_GLO(___G_c_23_proper_2d_clauses_3f_)
___NEED_GLO(___G_c_23_proper_2d_do_2d_bindings_3f_)
___NEED_GLO(___G_c_23_proper_2d_do_2d_exit_3f_)
___NEED_GLO(___G_c_23_proper_2d_length)
___NEED_GLO(___G_c_23_proper_2d_selector_2d_list_3f_)
___NEED_GLO(___G_c_23_proper_2d_tail_2d_calls_2d_sym)
___NEED_GLO(___G_c_23_proper_2d_tail_2d_calls_3f_)
___NEED_GLO(___G_c_23_pt)
___NEED_GLO(___G_c_23_pt_2d_and)
___NEED_GLO(___G_c_23_pt_2d_begin)
___NEED_GLO(___G_c_23_pt_2d_body)
___NEED_GLO(___G_c_23_pt_2d_c_2d_lambda)
___NEED_GLO(___G_c_23_pt_2d_case)
___NEED_GLO(___G_c_23_pt_2d_combination)
___NEED_GLO(___G_c_23_pt_2d_cond)
___NEED_GLO(___G_c_23_pt_2d_delay)
___NEED_GLO(___G_c_23_pt_2d_do)
___NEED_GLO(___G_c_23_pt_2d_future)
___NEED_GLO(___G_c_23_pt_2d_if)
___NEED_GLO(___G_c_23_pt_2d_lambda)
___NEED_GLO(___G_c_23_pt_2d_let)
___NEED_GLO(___G_c_23_pt_2d_let_2a_)
___NEED_GLO(___G_c_23_pt_2d_letrec)
___NEED_GLO(___G_c_23_pt_2d_or)
___NEED_GLO(___G_c_23_pt_2d_quasiquotation)
___NEED_GLO(___G_c_23_pt_2d_quasiquotation_2d_list)
___NEED_GLO(___G_c_23_pt_2d_quasiquote)
___NEED_GLO(___G_c_23_pt_2d_quote)
___NEED_GLO(___G_c_23_pt_2d_recursive_2d_let)
___NEED_GLO(___G_c_23_pt_2d_self_2d_eval)
___NEED_GLO(___G_c_23_pt_2d_sequence)
___NEED_GLO(___G_c_23_pt_2d_set_21_)
___NEED_GLO(___G_c_23_pt_2d_syntax_2d_error)
___NEED_GLO(___G_c_23_pt_2d_var)
___NEED_GLO(___G_c_23_ptree_2e_begin_21_)
___NEED_GLO(___G_c_23_ptree_2e_end_21_)
___NEED_GLO(___G_c_23_ptset_2d__3e_list)
___NEED_GLO(___G_c_23_ptset_2d_adjoin)
___NEED_GLO(___G_c_23_ptset_2d_empty)
___NEED_GLO(___G_c_23_ptset_2d_empty_3f_)
___NEED_GLO(___G_c_23_quasiquote_2d_expr_3f_)
___NEED_GLO(___G_c_23_quasiquote_2d_sym)
___NEED_GLO(___G_c_23_r4rs_2d_scheme_2d_sym)
___NEED_GLO(___G_c_23_r5rs_2d_scheme_2d_sym)
___NEED_GLO(___G_c_23_ref_2d_tag)
___NEED_GLO(___G_c_23_ref_2d_var)
___NEED_GLO(___G_c_23_ref_2d_var_2d_set_21_)
___NEED_GLO(___G_c_23_ref_3f_)
___NEED_GLO(___G_c_23_rest_2d_object_3f_)
___NEED_GLO(___G_c_23_run_2d_time_2d_binding_3f_)
___NEED_GLO(___G_c_23_run_2d_time_2d_bindings_2d_sym)
___NEED_GLO(___G_c_23_safe_2d_sym)
___NEED_GLO(___G_c_23_safe_3f_)
___NEED_GLO(___G_c_23_scheme_2d_dialect)
___NEED_GLO(___G_c_23_scheme_2d_global_2d_eval)
___NEED_GLO(___G_c_23_self_2d_eval_2d_expr_3f_)
___NEED_GLO(___G_c_23_self_2d_evaluating_3f_)
___NEED_GLO(___G_c_23_separate_2d_sym)
___NEED_GLO(___G_c_23_set_2d_prc_2d_names_21_)
___NEED_GLO(___G_c_23_set_2d_tag)
___NEED_GLO(___G_c_23_set_2d_val)
___NEED_GLO(___G_c_23_set_2d_var)
___NEED_GLO(___G_c_23_set_2d_var_2d_set_21_)
___NEED_GLO(___G_c_23_set_3f_)
___NEED_GLO(___G_c_23_source_2d__3e_expression)
___NEED_GLO(___G_c_23_source_2d__3e_parms)
___NEED_GLO(___G_c_23_source_2d_code)
___NEED_GLO(___G_c_23_specialize_2d_app)
___NEED_GLO(___G_c_23_specialize_2d_proc)
___NEED_GLO(___G_c_23_standard_2d_binding_3f_)
___NEED_GLO(___G_c_23_standard_2d_bindings_2d_sym)
___NEED_GLO(___G_c_23_standard_2d_proc_2d_obj)
___NEED_GLO(___G_c_23_standard_2d_procedure_3f_)
___NEED_GLO(___G_c_23_string_2d__3e_keyword_2d_object)
___NEED_GLO(___G_c_23_symbol_2d_object_3f_)
___NEED_GLO(___G_c_23_target_2e_prim_2d_info)
___NEED_GLO(___G_c_23_temp_2d_variable_2d_stamp)
___NEED_GLO(___G_c_23_topological_2d_sort)
___NEED_GLO(___G_c_23_transform_2d_declaration)
___NEED_GLO(___G_c_23_transitive_2d_closure)
___NEED_GLO(___G_c_23_tst_2d_alt)
___NEED_GLO(___G_c_23_tst_2d_con)
___NEED_GLO(___G_c_23_tst_2d_pre)
___NEED_GLO(___G_c_23_tst_2d_tag)
___NEED_GLO(___G_c_23_tst_3f_)
___NEED_GLO(___G_c_23_unbound1_2d_object_3f_)
___NEED_GLO(___G_c_23_unbound2_2d_object_3f_)
___NEED_GLO(___G_c_23_unquote_2d_expr_3f_)
___NEED_GLO(___G_c_23_unquote_2d_splicing_2d_expr_3f_)
___NEED_GLO(___G_c_23_unquote_2d_splicing_2d_sym)
___NEED_GLO(___G_c_23_unquote_2d_sym)
___NEED_GLO(___G_c_23_valid_2d_prefix_3f_)
___NEED_GLO(___G_c_23_var_2d_expr_3f_)
___NEED_GLO(___G_c_23_var_2d_name)
___NEED_GLO(___G_c_23_var_2d_tag)
___NEED_GLO(___G_c_23_varset_2d__3e_list)
___NEED_GLO(___G_c_23_varset_2d_adjoin)
___NEED_GLO(___G_c_23_varset_2d_difference)
___NEED_GLO(___G_c_23_varset_2d_intersection)
___NEED_GLO(___G_c_23_varset_2d_intersects_3f_)
___NEED_GLO(___G_c_23_varset_2d_union_2d_multi)
___NEED_GLO(___G_c_23_vect_2d__3e_list)
___NEED_GLO(___G_c_23_vector_2d_form)
___NEED_GLO(___G_c_23_vector_2d_object_3f_)
___NEED_GLO(___G_c_23_void_2d_object)
___NEED_GLO(___G_c_23_void_2d_object_3f_)
___NEED_GLO(___G_c_23_warnings_2d_sym)
___NEED_GLO(___G_c_23_warnings_3f_)
___NEED_GLO(___G_display)
___NEED_GLO(___G_exact_3f_)
___NEED_GLO(___G_length)
___NEED_GLO(___G_list_2d_ref)
___NEED_GLO(___G_newline)
___NEED_GLO(___G_number_2d__3e_string)
___NEED_GLO(___G_reverse)
___NEED_GLO(___G_string_2d__3e_symbol)
___NEED_GLO(___G_string_2d_append)
___NEED_GLO(___G_substring)
___NEED_GLO(___G_symbol_2d__3e_string)
___NEED_GLO(___G_write)

___BEGIN_SYM1
___DEF_SYM1(0,___S_app_2d_tag,"app-tag")
___DEF_SYM1(1,___S_begin_2d_temp,"begin-temp")
___DEF_SYM1(2,___S_case_2d_temp,"case-temp")
___DEF_SYM1(3,___S_compilation_2d_strategy,"compilation-strategy")
___DEF_SYM1(4,___S_cond_2d_temp,"cond-temp")
___DEF_SYM1(5,___S_conj_2d_tag,"conj-tag")
___DEF_SYM1(6,___S_cst_2d_tag,"cst-tag")
___DEF_SYM1(7,___S_def_2d_tag,"def-tag")
___DEF_SYM1(8,___S_dialect,"dialect")
___DEF_SYM1(9,___S_disj_2d_tag,"disj-tag")
___DEF_SYM1(10,___S_do_2d_temp,"do-temp")
___DEF_SYM1(11,___S_dsssl,"dsssl")
___DEF_SYM1(12,___S_extended,"extended")
___DEF_SYM1(13,___S_fut_2d_tag,"fut-tag")
___DEF_SYM1(14,___S_ieee,"ieee")
___DEF_SYM1(15,___S_none,"none")
___DEF_SYM1(16,___S_prc_2d_tag,"prc-tag")
___DEF_SYM1(17,___S_pred,"pred")
___DEF_SYM1(18,___S_r4rs,"r4rs")
___DEF_SYM1(19,___S_r5rs,"r5rs")
___DEF_SYM1(20,___S_ref_2d_tag,"ref-tag")
___DEF_SYM1(21,___S_set_2d_tag,"set-tag")
___DEF_SYM1(22,___S_true,"true")
___DEF_SYM1(23,___S_tst_2d_tag,"tst-tag")
___END_SYM1

#define ___SYM_app_2d_tag ___SYM(0,___S_app_2d_tag)
#define ___SYM_begin_2d_temp ___SYM(1,___S_begin_2d_temp)
#define ___SYM_case_2d_temp ___SYM(2,___S_case_2d_temp)
#define ___SYM_compilation_2d_strategy ___SYM(3,___S_compilation_2d_strategy)
#define ___SYM_cond_2d_temp ___SYM(4,___S_cond_2d_temp)
#define ___SYM_conj_2d_tag ___SYM(5,___S_conj_2d_tag)
#define ___SYM_cst_2d_tag ___SYM(6,___S_cst_2d_tag)
#define ___SYM_def_2d_tag ___SYM(7,___S_def_2d_tag)
#define ___SYM_dialect ___SYM(8,___S_dialect)
#define ___SYM_disj_2d_tag ___SYM(9,___S_disj_2d_tag)
#define ___SYM_do_2d_temp ___SYM(10,___S_do_2d_temp)
#define ___SYM_dsssl ___SYM(11,___S_dsssl)
#define ___SYM_extended ___SYM(12,___S_extended)
#define ___SYM_fut_2d_tag ___SYM(13,___S_fut_2d_tag)
#define ___SYM_ieee ___SYM(14,___S_ieee)
#define ___SYM_none ___SYM(15,___S_none)
#define ___SYM_prc_2d_tag ___SYM(16,___S_prc_2d_tag)
#define ___SYM_pred ___SYM(17,___S_pred)
#define ___SYM_r4rs ___SYM(18,___S_r4rs)
#define ___SYM_r5rs ___SYM(19,___S_r5rs)
#define ___SYM_ref_2d_tag ___SYM(20,___S_ref_2d_tag)
#define ___SYM_set_2d_tag ___SYM(21,___S_set_2d_tag)
#define ___SYM_true ___SYM(22,___S_true)
#define ___SYM_tst_2d_tag ___SYM(23,___S_tst_2d_tag)

___BEGIN_GLO
___DEF_GLO(0," _ptree1")
___DEF_GLO(1,"c#**and-expr?")
___DEF_GLO(2,"c#**begin-cmd-or-expr?")
___DEF_GLO(3,"c#**begin-expr?")
___DEF_GLO(4,"c#**case-expr?")
___DEF_GLO(5,"c#**cond-expr?")
___DEF_GLO(6,"c#**declare-expr?")
___DEF_GLO(7,"c#**define-expr?")
___DEF_GLO(8,"c#**define-macro-expr?")
___DEF_GLO(9,"c#**define-syntax-expr?")
___DEF_GLO(10,"c#**delay-expr?")
___DEF_GLO(11,"c#**do-expr?")
___DEF_GLO(12,"c#**future-expr?")
___DEF_GLO(13,"c#**if-expr?")
___DEF_GLO(14,"c#**include-expr?")
___DEF_GLO(15,"c#**lambda-expr?")
___DEF_GLO(16,"c#**let*-expr?")
___DEF_GLO(17,"c#**let-expr?")
___DEF_GLO(18,"c#**letrec-expr?")
___DEF_GLO(19,"c#**namespace-expr?")
___DEF_GLO(20,"c#**or-expr?")
___DEF_GLO(21,"c#**quasiquote-expr?")
___DEF_GLO(22,"c#**quote-expr?")
___DEF_GLO(23,"c#**set!-expr?")
___DEF_GLO(24,"c#*ptree-port*")
___DEF_GLO(25,"c#add-declarations")
___DEF_GLO(26,"c#add-extended-bindings")
___DEF_GLO(27,"c#add-macro")
___DEF_GLO(28,"c#add-namespace")
___DEF_GLO(29,"c#add-not-inline-primitives")
___DEF_GLO(30,"c#add-not-interrupts-enabled")
___DEF_GLO(31,"c#add-not-safe")
___DEF_GLO(32,"c#add-proper-tail-calls")
___DEF_GLO(33,"c#app->specialized-proc")
___DEF_GLO(34,"c#app-args")
___DEF_GLO(35,"c#app-oper")
___DEF_GLO(36,"c#app-tag")
___DEF_GLO(37,"c#app?")
___DEF_GLO(38,"c#append-form")
___DEF_GLO(39,"c#begin-body")
___DEF_GLO(40,"c#bindable-var?")
___DEF_GLO(41,"c#block-compilation?")
___DEF_GLO(42,"c#bound-free-variables")
___DEF_GLO(43,"c#bound-variables")
___DEF_GLO(44,"c#bound?")
___DEF_GLO(45,"c#check-multiple-global-defs")
___DEF_GLO(46,"c#combination-expr?")
___DEF_GLO(47,"c#conj-alt")
___DEF_GLO(48,"c#conj-pre")
___DEF_GLO(49,"c#conj-tag")
___DEF_GLO(50,"c#conj?")
___DEF_GLO(51,"c#cons-form")
___DEF_GLO(52,"c#constant-fold?")
___DEF_GLO(53,"c#core?")
___DEF_GLO(54,"c#cst-tag")
___DEF_GLO(55,"c#cst-val")
___DEF_GLO(56,"c#cst-val-set!")
___DEF_GLO(57,"c#cst?")
___DEF_GLO(58,"c#debug-environments?")
___DEF_GLO(59,"c#debug-location?")
___DEF_GLO(60,"c#debug-source?")
___DEF_GLO(61,"c#debug?")
___DEF_GLO(62,"c#def-tag")
___DEF_GLO(63,"c#def-val")
___DEF_GLO(64,"c#def-var")
___DEF_GLO(65,"c#def-var-set!")
___DEF_GLO(66,"c#def?")
___DEF_GLO(67,"c#definition-name")
___DEF_GLO(68,"c#definition-value")
___DEF_GLO(69,"c#disj-alt")
___DEF_GLO(70,"c#disj-pre")
___DEF_GLO(71,"c#disj-tag")
___DEF_GLO(72,"c#disj?")
___DEF_GLO(73,"c#environment-map?")
___DEF_GLO(74,"c#extended-binding?")
___DEF_GLO(75,"c#extract-names")
___DEF_GLO(76,"c#extract-parameters")
___DEF_GLO(77,"c#free-variables")
___DEF_GLO(78,"c#fut-tag")
___DEF_GLO(79,"c#fut-val")
___DEF_GLO(80,"c#fut?")
___DEF_GLO(81,"c#global-proc-obj")
___DEF_GLO(82,"c#global-single-def")
___DEF_GLO(83,"c#global-singly-bound?")
___DEF_GLO(84,"c#global?")
___DEF_GLO(85,"c#ill-formed-special-form")
___DEF_GLO(86,"c#inline-primitive?")
___DEF_GLO(87,"c#inline?")
___DEF_GLO(88,"c#inlining-limit")
___DEF_GLO(89,"c#intrs-enabled?")
___DEF_GLO(90,"c#lambda-expr?")
___DEF_GLO(91,"c#lambda-lift?")
___DEF_GLO(92,"c#length?")
___DEF_GLO(93,"c#list-construction?")
___DEF_GLO(94,"c#macro-expand")
___DEF_GLO(95,"c#macro-expr?")
___DEF_GLO(96,"c#make-app")
___DEF_GLO(97,"c#make-conj")
___DEF_GLO(98,"c#make-cst")
___DEF_GLO(99,"c#make-def")
___DEF_GLO(100,"c#make-disj")
___DEF_GLO(101,"c#make-fut")
___DEF_GLO(102,"c#make-prc")
___DEF_GLO(103,"c#make-ref")
___DEF_GLO(104,"c#make-set")
___DEF_GLO(105,"c#make-tst")
___DEF_GLO(106,"c#match")
___DEF_GLO(107,"c#mutable?")
___DEF_GLO(108,"c#nb-args-conforms?")
___DEF_GLO(109,"c#new-call")
___DEF_GLO(110,"c#new-call*")
___DEF_GLO(111,"c#new-conj")
___DEF_GLO(112,"c#new-cst")
___DEF_GLO(113,"c#new-def")
___DEF_GLO(114,"c#new-disj")
___DEF_GLO(115,"c#new-disj-call")
___DEF_GLO(116,"c#new-fut")
___DEF_GLO(117,"c#new-let")
___DEF_GLO(118,"c#new-prc")
___DEF_GLO(119,"c#new-ref")
___DEF_GLO(120,"c#new-ref-extended-bindings")
___DEF_GLO(121,"c#new-seq")
___DEF_GLO(122,"c#new-set")
___DEF_GLO(123,"c#new-temp-variable")
___DEF_GLO(124,"c#new-tst")
___DEF_GLO(125,"c#new-variable")
___DEF_GLO(126,"c#new-variables")
___DEF_GLO(127,"c#next-node-stamp")
___DEF_GLO(128,"c#node-bfv")
___DEF_GLO(129,"c#node-bfv-set!")
___DEF_GLO(130,"c#node-children")
___DEF_GLO(131,"c#node-children-set!")
___DEF_GLO(132,"c#node-env")
___DEF_GLO(133,"c#node-env-set!")
___DEF_GLO(134,"c#node-fv")
___DEF_GLO(135,"c#node-fv-invalidate!")
___DEF_GLO(136,"c#node-fv-set!")
___DEF_GLO(137,"c#node-parent")
___DEF_GLO(138,"c#node-parent-set!")
___DEF_GLO(139,"c#node-source")
___DEF_GLO(140,"c#node-source-set!")
___DEF_GLO(141,"c#node-stamp")
___DEF_GLO(142,"c#node-stamp-set!")
___DEF_GLO(143,"c#not-macro")
___DEF_GLO(144,"c#oper-pos?")
___DEF_GLO(145,"c#optimize-dead-local-variables?")
___DEF_GLO(146,"c#parameter-default-source")
___DEF_GLO(147,"c#parameter-name")
___DEF_GLO(148,"c#parameter-source")
___DEF_GLO(149,"c#parms->source")
___DEF_GLO(150,"c#parse-program")
___DEF_GLO(151,"c#prc-body")
___DEF_GLO(152,"c#prc-c-name")
___DEF_GLO(153,"c#prc-c-name-set!")
___DEF_GLO(154,"c#prc-keys")
___DEF_GLO(155,"c#prc-keys-set!")
___DEF_GLO(156,"c#prc-name")
___DEF_GLO(157,"c#prc-name-set!")
___DEF_GLO(158,"c#prc-opts")
___DEF_GLO(159,"c#prc-opts-set!")
___DEF_GLO(160,"c#prc-parms")
___DEF_GLO(161,"c#prc-parms-set!")
___DEF_GLO(162,"c#prc-req-and-opt-parms-only?")
___DEF_GLO(163,"c#prc-rest?")
___DEF_GLO(164,"c#prc-rest?-set!")
___DEF_GLO(165,"c#prc-tag")
___DEF_GLO(166,"c#prc?")
___DEF_GLO(167,"c#proper-bindings?")
___DEF_GLO(168,"c#proper-case-clauses?")
___DEF_GLO(169,"c#proper-clauses?")
___DEF_GLO(170,"c#proper-do-bindings?")
___DEF_GLO(171,"c#proper-do-exit?")
___DEF_GLO(172,"c#proper-length")
___DEF_GLO(173,"c#proper-selector-list?")
___DEF_GLO(174,"c#proper-tail-calls?")
___DEF_GLO(175,"c#pt")
___DEF_GLO(176,"c#pt-and")
___DEF_GLO(177,"c#pt-begin")
___DEF_GLO(178,"c#pt-body")
___DEF_GLO(179,"c#pt-case")
___DEF_GLO(180,"c#pt-combination")
___DEF_GLO(181,"c#pt-cond")
___DEF_GLO(182,"c#pt-delay")
___DEF_GLO(183,"c#pt-do")
___DEF_GLO(184,"c#pt-future")
___DEF_GLO(185,"c#pt-if")
___DEF_GLO(186,"c#pt-lambda")
___DEF_GLO(187,"c#pt-let")
___DEF_GLO(188,"c#pt-let*")
___DEF_GLO(189,"c#pt-letrec")
___DEF_GLO(190,"c#pt-or")
___DEF_GLO(191,"c#pt-quasiquotation")
___DEF_GLO(192,"c#pt-quasiquotation-list")
___DEF_GLO(193,"c#pt-quasiquote")
___DEF_GLO(194,"c#pt-quote")
___DEF_GLO(195,"c#pt-recursive-let")
___DEF_GLO(196,"c#pt-self-eval")
___DEF_GLO(197,"c#pt-sequence")
___DEF_GLO(198,"c#pt-set!")
___DEF_GLO(199,"c#pt-syntax-error")
___DEF_GLO(200,"c#pt-var")
___DEF_GLO(201,"c#ptree.begin!")
___DEF_GLO(202,"c#ptree.end!")
___DEF_GLO(203,"c#quasiquote-expr?")
___DEF_GLO(204,"c#ref-tag")
___DEF_GLO(205,"c#ref-var")
___DEF_GLO(206,"c#ref-var-set!")
___DEF_GLO(207,"c#ref?")
___DEF_GLO(208,"c#run-time-binding?")
___DEF_GLO(209,"c#safe?")
___DEF_GLO(210,"c#scheme-dialect")
___DEF_GLO(211,"c#self-eval-expr?")
___DEF_GLO(212,"c#self-evaluating?")
___DEF_GLO(213,"c#set-prc-names!")
___DEF_GLO(214,"c#set-tag")
___DEF_GLO(215,"c#set-val")
___DEF_GLO(216,"c#set-var")
___DEF_GLO(217,"c#set-var-set!")
___DEF_GLO(218,"c#set?")
___DEF_GLO(219,"c#source->parms")
___DEF_GLO(220,"c#specialize-app")
___DEF_GLO(221,"c#specialize-proc")
___DEF_GLO(222,"c#standard-binding?")
___DEF_GLO(223,"c#standard-proc-obj")
___DEF_GLO(224,"c#standard-procedure?")
___DEF_GLO(225,"c#temp-variable-stamp")
___DEF_GLO(226,"c#transform-declaration")
___DEF_GLO(227,"c#tst-alt")
___DEF_GLO(228,"c#tst-con")
___DEF_GLO(229,"c#tst-pre")
___DEF_GLO(230,"c#tst-tag")
___DEF_GLO(231,"c#tst?")
___DEF_GLO(232,"c#unquote-expr?")
___DEF_GLO(233,"c#unquote-splicing-expr?")
___DEF_GLO(234,"c#var-expr?")
___DEF_GLO(235,"c#vector-form")
___DEF_GLO(236,"c#warnings?")
___DEF_GLO(237,"##integer?")
___DEF_GLO(238,"##macro-descr-def-syntax?")
___DEF_GLO(239,"##macro-descr-expander")
___DEF_GLO(240,"##macro-descr-size")
___DEF_GLO(241,"##make-macro-descr")
___DEF_GLO(242,"##make-source")
___DEF_GLO(243,"##source-code")
___DEF_GLO(244,"##source-locat")
___DEF_GLO(245,"##sourcify-deep")
___DEF_GLO(246,"append")
___DEF_GLO(247,"apply")
___DEF_GLO(248,"c#**and-sym")
___DEF_GLO(249,"c#**begin-sym")
___DEF_GLO(250,"c#**c-declare-expr?")
___DEF_GLO(251,"c#**c-define-expr?")
___DEF_GLO(252,"c#**c-define-type-expr?")
___DEF_GLO(253,"c#**c-initialize-expr?")
___DEF_GLO(254,"c#**c-lambda-expr?")
___DEF_GLO(255,"c#**case-sym")
___DEF_GLO(256,"c#**cond-sym")
___DEF_GLO(257,"c#**declare-sym")
___DEF_GLO(258,"c#**define-macro-sym")
___DEF_GLO(259,"c#**define-sym")
___DEF_GLO(260,"c#**define-syntax-sym")
___DEF_GLO(261,"c#**delay-sym")
___DEF_GLO(262,"c#**do-sym")
___DEF_GLO(263,"c#**eq?-sym")
___DEF_GLO(264,"c#**eqv?-sym")
___DEF_GLO(265,"c#**future-sym")
___DEF_GLO(266,"c#**if-sym")
___DEF_GLO(267,"c#**include-sym")
___DEF_GLO(268,"c#**lambda-sym")
___DEF_GLO(269,"c#**let*-sym")
___DEF_GLO(270,"c#**let-sym")
___DEF_GLO(271,"c#**letrec-sym")
___DEF_GLO(272,"c#**make-promise-sym")
___DEF_GLO(273,"c#**namespace-sym")
___DEF_GLO(274,"c#**or-sym")
___DEF_GLO(275,"c#**quasi-append-sym")
___DEF_GLO(276,"c#**quasi-cons-proc-obj")
___DEF_GLO(277,"c#**quasi-cons-sym")
___DEF_GLO(278,"c#**quasi-list->vector-sym")
___DEF_GLO(279,"c#**quasi-list-proc-obj")
___DEF_GLO(280,"c#**quasi-list-sym")
___DEF_GLO(281,"c#**quasi-vector-sym")
___DEF_GLO(282,"c#**quasiquote-sym")
___DEF_GLO(283,"c#**quote-sym")
___DEF_GLO(284,"c#**set!-sym")
___DEF_GLO(285,"c#=>-sym")
___DEF_GLO(286,"c#absent-object")
___DEF_GLO(287,"c#add-c-decl")
___DEF_GLO(288,"c#add-c-init")
___DEF_GLO(289,"c#add-c-type")
___DEF_GLO(290,"c#block-sym")
___DEF_GLO(291,"c#boolean-decl")
___DEF_GLO(292,"c#boolean-declarations")
___DEF_GLO(293,"c#build-c-define")
___DEF_GLO(294,"c#c-declaration-body")
___DEF_GLO(295,"c#c-definition-name")
___DEF_GLO(296,"c#c-definition-param-types")
___DEF_GLO(297,"c#c-definition-proc-name")
___DEF_GLO(298,"c#c-definition-result-type")
___DEF_GLO(299,"c#c-definition-scope")
___DEF_GLO(300,"c#c-definition-value")
___DEF_GLO(301,"c#c-initialization-body")
___DEF_GLO(302,"c#c-interface-begin")
___DEF_GLO(303,"c#c-interface-end")
___DEF_GLO(304,"c#c-type-definition-name")
___DEF_GLO(305,"c#c-type-definition-type")
___DEF_GLO(306,"c#compiler-internal-error")
___DEF_GLO(307,"c#compiler-option-debug")
___DEF_GLO(308,"c#compiler-option-debug-environments")

___DEF_GLO(309,"c#compiler-option-debug-location")
___DEF_GLO(310,"c#compiler-option-debug-source")
___DEF_GLO(311,"c#compiler-user-error")
___DEF_GLO(312,"c#compiler-user-warning")
___DEF_GLO(313,"c#constant-fold-sym")
___DEF_GLO(314,"c#core-sym")
___DEF_GLO(315,"c#debug-environments-sym")
___DEF_GLO(316,"c#debug-location-sym")
___DEF_GLO(317,"c#debug-source-sym")
___DEF_GLO(318,"c#debug-sym")
___DEF_GLO(319,"c#declaration-value")
___DEF_GLO(320,"c#define-boolean-decl")
___DEF_GLO(321,"c#define-flag-decl")
___DEF_GLO(322,"c#define-namable-boolean-decl")
___DEF_GLO(323,"c#define-parameterized-decl")
___DEF_GLO(324,"c#else-sym")
___DEF_GLO(325,"c#end-of-file-object?")
___DEF_GLO(326,"c#env-declare")
___DEF_GLO(327,"c#env-define-var")
___DEF_GLO(328,"c#env-frame")
___DEF_GLO(329,"c#env-global-variables")
___DEF_GLO(330,"c#env-lookup-global-var")
___DEF_GLO(331,"c#env-lookup-macro")
___DEF_GLO(332,"c#env-lookup-var")
___DEF_GLO(333,"c#env-macro")
___DEF_GLO(334,"c#env-namespace")
___DEF_GLO(335,"c#environment-map-sym")
___DEF_GLO(336,"c#expression->source")
___DEF_GLO(337,"c#extended-bindings-sym")
___DEF_GLO(338,"c#false-object")
___DEF_GLO(339,"c#false-object?")
___DEF_GLO(340,"c#flag-decl")
___DEF_GLO(341,"c#flag-declarations")
___DEF_GLO(342,"c#gambit-scheme-sym")
___DEF_GLO(343,"c#ieee-scheme-sym")
___DEF_GLO(344,"c#include-expr->source")
___DEF_GLO(345,"c#inline-primitives-sym")
___DEF_GLO(346,"c#inline-sym")
___DEF_GLO(347,"c#inlining-limit-sym")
___DEF_GLO(348,"c#interrupts-enabled-sym")
___DEF_GLO(349,"c#keep")
___DEF_GLO(350,"c#key-object?")
___DEF_GLO(351,"c#keyword-object?")
___DEF_GLO(352,"c#lambda-lift-sym")
___DEF_GLO(353,"c#lambda-sym")
___DEF_GLO(354,"c#list->varset")
___DEF_GLO(355,"c#list->vect")
___DEF_GLO(356,"c#make-counter")
___DEF_GLO(357,"c#make-gnode")
___DEF_GLO(358,"c#multilisp-sym")
___DEF_GLO(359,"c#namable-boolean-decl")
___DEF_GLO(360,"c#namable-boolean-declarations")
___DEF_GLO(361,"c#namable-decl")
___DEF_GLO(362,"c#namable-declarations")
___DEF_GLO(363,"c#next-var-stamp")
___DEF_GLO(364,"c#not-sym")
___DEF_GLO(365,"c#optimize-dead-local-variables-sym")

___DEF_GLO(366,"c#optional-object?")
___DEF_GLO(367,"c#pair-up")
___DEF_GLO(368,"c#parameterized-decl")
___DEF_GLO(369,"c#parameterized-declarations")
___DEF_GLO(370,"c#pattern-member?")
___DEF_GLO(371,"c#proc-obj-call-pat")
___DEF_GLO(372,"c#proc-obj-specialize")
___DEF_GLO(373,"c#proc-obj-standard")
___DEF_GLO(374,"c#proc-obj?")
___DEF_GLO(375,"c#proper-tail-calls-sym")
___DEF_GLO(376,"c#pt-c-lambda")
___DEF_GLO(377,"c#ptset->list")
___DEF_GLO(378,"c#ptset-adjoin")
___DEF_GLO(379,"c#ptset-empty")
___DEF_GLO(380,"c#ptset-empty?")
___DEF_GLO(381,"c#quasiquote-sym")
___DEF_GLO(382,"c#r4rs-scheme-sym")
___DEF_GLO(383,"c#r5rs-scheme-sym")
___DEF_GLO(384,"c#rest-object?")
___DEF_GLO(385,"c#run-time-bindings-sym")
___DEF_GLO(386,"c#safe-sym")
___DEF_GLO(387,"c#scheme-global-eval")
___DEF_GLO(388,"c#separate-sym")
___DEF_GLO(389,"c#source->expression")
___DEF_GLO(390,"c#source-code")
___DEF_GLO(391,"c#standard-bindings-sym")
___DEF_GLO(392,"c#string->keyword-object")
___DEF_GLO(393,"c#symbol-object?")
___DEF_GLO(394,"c#target.prim-info")
___DEF_GLO(395,"c#topological-sort")
___DEF_GLO(396,"c#transitive-closure")
___DEF_GLO(397,"c#unbound1-object?")
___DEF_GLO(398,"c#unbound2-object?")
___DEF_GLO(399,"c#unquote-splicing-sym")
___DEF_GLO(400,"c#unquote-sym")
___DEF_GLO(401,"c#valid-prefix?")
___DEF_GLO(402,"c#var-name")
___DEF_GLO(403,"c#var-tag")
___DEF_GLO(404,"c#varset->list")
___DEF_GLO(405,"c#varset-adjoin")
___DEF_GLO(406,"c#varset-difference")
___DEF_GLO(407,"c#varset-intersection")
___DEF_GLO(408,"c#varset-intersects?")
___DEF_GLO(409,"c#varset-union-multi")
___DEF_GLO(410,"c#vect->list")
___DEF_GLO(411,"c#vector-object?")
___DEF_GLO(412,"c#void-object")
___DEF_GLO(413,"c#void-object?")
___DEF_GLO(414,"c#warnings-sym")
___DEF_GLO(415,"display")
___DEF_GLO(416,"exact?")
___DEF_GLO(417,"length")
___DEF_GLO(418,"list-ref")
___DEF_GLO(419,"newline")
___DEF_GLO(420,"number->string")
___DEF_GLO(421,"reverse")
___DEF_GLO(422,"string->symbol")
___DEF_GLO(423,"string-append")
___DEF_GLO(424,"substring")
___DEF_GLO(425,"symbol->string")
___DEF_GLO(426,"write")
___END_GLO

#define ___GLO__20___ptree1 ___GLO(0,___G__20___ptree1)
#define ___PRM__20___ptree1 ___PRM(0,___G__20___ptree1)
#define ___GLO_c_23__2a__2a_and_2d_expr_3f_ ___GLO(1,___G_c_23__2a__2a_and_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_and_2d_expr_3f_ ___PRM(1,___G_c_23__2a__2a_and_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_ ___GLO(2,___G_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_ ___PRM(2,___G_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_begin_2d_expr_3f_ ___GLO(3,___G_c_23__2a__2a_begin_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_begin_2d_expr_3f_ ___PRM(3,___G_c_23__2a__2a_begin_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_case_2d_expr_3f_ ___GLO(4,___G_c_23__2a__2a_case_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_case_2d_expr_3f_ ___PRM(4,___G_c_23__2a__2a_case_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_cond_2d_expr_3f_ ___GLO(5,___G_c_23__2a__2a_cond_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_cond_2d_expr_3f_ ___PRM(5,___G_c_23__2a__2a_cond_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_declare_2d_expr_3f_ ___GLO(6,___G_c_23__2a__2a_declare_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_declare_2d_expr_3f_ ___PRM(6,___G_c_23__2a__2a_declare_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_define_2d_expr_3f_ ___GLO(7,___G_c_23__2a__2a_define_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_define_2d_expr_3f_ ___PRM(7,___G_c_23__2a__2a_define_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_define_2d_macro_2d_expr_3f_ ___GLO(8,___G_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_define_2d_macro_2d_expr_3f_ ___PRM(8,___G_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_define_2d_syntax_2d_expr_3f_ ___GLO(9,___G_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_define_2d_syntax_2d_expr_3f_ ___PRM(9,___G_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_delay_2d_expr_3f_ ___GLO(10,___G_c_23__2a__2a_delay_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_delay_2d_expr_3f_ ___PRM(10,___G_c_23__2a__2a_delay_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_do_2d_expr_3f_ ___GLO(11,___G_c_23__2a__2a_do_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_do_2d_expr_3f_ ___PRM(11,___G_c_23__2a__2a_do_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_future_2d_expr_3f_ ___GLO(12,___G_c_23__2a__2a_future_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_future_2d_expr_3f_ ___PRM(12,___G_c_23__2a__2a_future_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_if_2d_expr_3f_ ___GLO(13,___G_c_23__2a__2a_if_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_if_2d_expr_3f_ ___PRM(13,___G_c_23__2a__2a_if_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_include_2d_expr_3f_ ___GLO(14,___G_c_23__2a__2a_include_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_include_2d_expr_3f_ ___PRM(14,___G_c_23__2a__2a_include_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_lambda_2d_expr_3f_ ___GLO(15,___G_c_23__2a__2a_lambda_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_lambda_2d_expr_3f_ ___PRM(15,___G_c_23__2a__2a_lambda_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_let_2a__2d_expr_3f_ ___GLO(16,___G_c_23__2a__2a_let_2a__2d_expr_3f_)
#define ___PRM_c_23__2a__2a_let_2a__2d_expr_3f_ ___PRM(16,___G_c_23__2a__2a_let_2a__2d_expr_3f_)
#define ___GLO_c_23__2a__2a_let_2d_expr_3f_ ___GLO(17,___G_c_23__2a__2a_let_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_let_2d_expr_3f_ ___PRM(17,___G_c_23__2a__2a_let_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_letrec_2d_expr_3f_ ___GLO(18,___G_c_23__2a__2a_letrec_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_letrec_2d_expr_3f_ ___PRM(18,___G_c_23__2a__2a_letrec_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_namespace_2d_expr_3f_ ___GLO(19,___G_c_23__2a__2a_namespace_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_namespace_2d_expr_3f_ ___PRM(19,___G_c_23__2a__2a_namespace_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_or_2d_expr_3f_ ___GLO(20,___G_c_23__2a__2a_or_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_or_2d_expr_3f_ ___PRM(20,___G_c_23__2a__2a_or_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_quasiquote_2d_expr_3f_ ___GLO(21,___G_c_23__2a__2a_quasiquote_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_quasiquote_2d_expr_3f_ ___PRM(21,___G_c_23__2a__2a_quasiquote_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_quote_2d_expr_3f_ ___GLO(22,___G_c_23__2a__2a_quote_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_quote_2d_expr_3f_ ___PRM(22,___G_c_23__2a__2a_quote_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_set_21__2d_expr_3f_ ___GLO(23,___G_c_23__2a__2a_set_21__2d_expr_3f_)
#define ___PRM_c_23__2a__2a_set_21__2d_expr_3f_ ___PRM(23,___G_c_23__2a__2a_set_21__2d_expr_3f_)
#define ___GLO_c_23__2a_ptree_2d_port_2a_ ___GLO(24,___G_c_23__2a_ptree_2d_port_2a_)
#define ___PRM_c_23__2a_ptree_2d_port_2a_ ___PRM(24,___G_c_23__2a_ptree_2d_port_2a_)
#define ___GLO_c_23_add_2d_declarations ___GLO(25,___G_c_23_add_2d_declarations)
#define ___PRM_c_23_add_2d_declarations ___PRM(25,___G_c_23_add_2d_declarations)
#define ___GLO_c_23_add_2d_extended_2d_bindings ___GLO(26,___G_c_23_add_2d_extended_2d_bindings)
#define ___PRM_c_23_add_2d_extended_2d_bindings ___PRM(26,___G_c_23_add_2d_extended_2d_bindings)
#define ___GLO_c_23_add_2d_macro ___GLO(27,___G_c_23_add_2d_macro)
#define ___PRM_c_23_add_2d_macro ___PRM(27,___G_c_23_add_2d_macro)
#define ___GLO_c_23_add_2d_namespace ___GLO(28,___G_c_23_add_2d_namespace)
#define ___PRM_c_23_add_2d_namespace ___PRM(28,___G_c_23_add_2d_namespace)
#define ___GLO_c_23_add_2d_not_2d_inline_2d_primitives ___GLO(29,___G_c_23_add_2d_not_2d_inline_2d_primitives)
#define ___PRM_c_23_add_2d_not_2d_inline_2d_primitives ___PRM(29,___G_c_23_add_2d_not_2d_inline_2d_primitives)
#define ___GLO_c_23_add_2d_not_2d_interrupts_2d_enabled ___GLO(30,___G_c_23_add_2d_not_2d_interrupts_2d_enabled)
#define ___PRM_c_23_add_2d_not_2d_interrupts_2d_enabled ___PRM(30,___G_c_23_add_2d_not_2d_interrupts_2d_enabled)
#define ___GLO_c_23_add_2d_not_2d_safe ___GLO(31,___G_c_23_add_2d_not_2d_safe)
#define ___PRM_c_23_add_2d_not_2d_safe ___PRM(31,___G_c_23_add_2d_not_2d_safe)
#define ___GLO_c_23_add_2d_proper_2d_tail_2d_calls ___GLO(32,___G_c_23_add_2d_proper_2d_tail_2d_calls)
#define ___PRM_c_23_add_2d_proper_2d_tail_2d_calls ___PRM(32,___G_c_23_add_2d_proper_2d_tail_2d_calls)
#define ___GLO_c_23_app_2d__3e_specialized_2d_proc ___GLO(33,___G_c_23_app_2d__3e_specialized_2d_proc)
#define ___PRM_c_23_app_2d__3e_specialized_2d_proc ___PRM(33,___G_c_23_app_2d__3e_specialized_2d_proc)
#define ___GLO_c_23_app_2d_args ___GLO(34,___G_c_23_app_2d_args)
#define ___PRM_c_23_app_2d_args ___PRM(34,___G_c_23_app_2d_args)
#define ___GLO_c_23_app_2d_oper ___GLO(35,___G_c_23_app_2d_oper)
#define ___PRM_c_23_app_2d_oper ___PRM(35,___G_c_23_app_2d_oper)
#define ___GLO_c_23_app_2d_tag ___GLO(36,___G_c_23_app_2d_tag)
#define ___PRM_c_23_app_2d_tag ___PRM(36,___G_c_23_app_2d_tag)
#define ___GLO_c_23_app_3f_ ___GLO(37,___G_c_23_app_3f_)
#define ___PRM_c_23_app_3f_ ___PRM(37,___G_c_23_app_3f_)
#define ___GLO_c_23_append_2d_form ___GLO(38,___G_c_23_append_2d_form)
#define ___PRM_c_23_append_2d_form ___PRM(38,___G_c_23_append_2d_form)
#define ___GLO_c_23_begin_2d_body ___GLO(39,___G_c_23_begin_2d_body)
#define ___PRM_c_23_begin_2d_body ___PRM(39,___G_c_23_begin_2d_body)
#define ___GLO_c_23_bindable_2d_var_3f_ ___GLO(40,___G_c_23_bindable_2d_var_3f_)
#define ___PRM_c_23_bindable_2d_var_3f_ ___PRM(40,___G_c_23_bindable_2d_var_3f_)
#define ___GLO_c_23_block_2d_compilation_3f_ ___GLO(41,___G_c_23_block_2d_compilation_3f_)
#define ___PRM_c_23_block_2d_compilation_3f_ ___PRM(41,___G_c_23_block_2d_compilation_3f_)
#define ___GLO_c_23_bound_2d_free_2d_variables ___GLO(42,___G_c_23_bound_2d_free_2d_variables)
#define ___PRM_c_23_bound_2d_free_2d_variables ___PRM(42,___G_c_23_bound_2d_free_2d_variables)
#define ___GLO_c_23_bound_2d_variables ___GLO(43,___G_c_23_bound_2d_variables)
#define ___PRM_c_23_bound_2d_variables ___PRM(43,___G_c_23_bound_2d_variables)
#define ___GLO_c_23_bound_3f_ ___GLO(44,___G_c_23_bound_3f_)
#define ___PRM_c_23_bound_3f_ ___PRM(44,___G_c_23_bound_3f_)
#define ___GLO_c_23_check_2d_multiple_2d_global_2d_defs ___GLO(45,___G_c_23_check_2d_multiple_2d_global_2d_defs)
#define ___PRM_c_23_check_2d_multiple_2d_global_2d_defs ___PRM(45,___G_c_23_check_2d_multiple_2d_global_2d_defs)
#define ___GLO_c_23_combination_2d_expr_3f_ ___GLO(46,___G_c_23_combination_2d_expr_3f_)
#define ___PRM_c_23_combination_2d_expr_3f_ ___PRM(46,___G_c_23_combination_2d_expr_3f_)
#define ___GLO_c_23_conj_2d_alt ___GLO(47,___G_c_23_conj_2d_alt)
#define ___PRM_c_23_conj_2d_alt ___PRM(47,___G_c_23_conj_2d_alt)
#define ___GLO_c_23_conj_2d_pre ___GLO(48,___G_c_23_conj_2d_pre)
#define ___PRM_c_23_conj_2d_pre ___PRM(48,___G_c_23_conj_2d_pre)
#define ___GLO_c_23_conj_2d_tag ___GLO(49,___G_c_23_conj_2d_tag)
#define ___PRM_c_23_conj_2d_tag ___PRM(49,___G_c_23_conj_2d_tag)
#define ___GLO_c_23_conj_3f_ ___GLO(50,___G_c_23_conj_3f_)
#define ___PRM_c_23_conj_3f_ ___PRM(50,___G_c_23_conj_3f_)
#define ___GLO_c_23_cons_2d_form ___GLO(51,___G_c_23_cons_2d_form)
#define ___PRM_c_23_cons_2d_form ___PRM(51,___G_c_23_cons_2d_form)
#define ___GLO_c_23_constant_2d_fold_3f_ ___GLO(52,___G_c_23_constant_2d_fold_3f_)
#define ___PRM_c_23_constant_2d_fold_3f_ ___PRM(52,___G_c_23_constant_2d_fold_3f_)
#define ___GLO_c_23_core_3f_ ___GLO(53,___G_c_23_core_3f_)
#define ___PRM_c_23_core_3f_ ___PRM(53,___G_c_23_core_3f_)
#define ___GLO_c_23_cst_2d_tag ___GLO(54,___G_c_23_cst_2d_tag)
#define ___PRM_c_23_cst_2d_tag ___PRM(54,___G_c_23_cst_2d_tag)
#define ___GLO_c_23_cst_2d_val ___GLO(55,___G_c_23_cst_2d_val)
#define ___PRM_c_23_cst_2d_val ___PRM(55,___G_c_23_cst_2d_val)
#define ___GLO_c_23_cst_2d_val_2d_set_21_ ___GLO(56,___G_c_23_cst_2d_val_2d_set_21_)
#define ___PRM_c_23_cst_2d_val_2d_set_21_ ___PRM(56,___G_c_23_cst_2d_val_2d_set_21_)
#define ___GLO_c_23_cst_3f_ ___GLO(57,___G_c_23_cst_3f_)
#define ___PRM_c_23_cst_3f_ ___PRM(57,___G_c_23_cst_3f_)
#define ___GLO_c_23_debug_2d_environments_3f_ ___GLO(58,___G_c_23_debug_2d_environments_3f_)
#define ___PRM_c_23_debug_2d_environments_3f_ ___PRM(58,___G_c_23_debug_2d_environments_3f_)
#define ___GLO_c_23_debug_2d_location_3f_ ___GLO(59,___G_c_23_debug_2d_location_3f_)
#define ___PRM_c_23_debug_2d_location_3f_ ___PRM(59,___G_c_23_debug_2d_location_3f_)
#define ___GLO_c_23_debug_2d_source_3f_ ___GLO(60,___G_c_23_debug_2d_source_3f_)
#define ___PRM_c_23_debug_2d_source_3f_ ___PRM(60,___G_c_23_debug_2d_source_3f_)
#define ___GLO_c_23_debug_3f_ ___GLO(61,___G_c_23_debug_3f_)
#define ___PRM_c_23_debug_3f_ ___PRM(61,___G_c_23_debug_3f_)
#define ___GLO_c_23_def_2d_tag ___GLO(62,___G_c_23_def_2d_tag)
#define ___PRM_c_23_def_2d_tag ___PRM(62,___G_c_23_def_2d_tag)
#define ___GLO_c_23_def_2d_val ___GLO(63,___G_c_23_def_2d_val)
#define ___PRM_c_23_def_2d_val ___PRM(63,___G_c_23_def_2d_val)
#define ___GLO_c_23_def_2d_var ___GLO(64,___G_c_23_def_2d_var)
#define ___PRM_c_23_def_2d_var ___PRM(64,___G_c_23_def_2d_var)
#define ___GLO_c_23_def_2d_var_2d_set_21_ ___GLO(65,___G_c_23_def_2d_var_2d_set_21_)
#define ___PRM_c_23_def_2d_var_2d_set_21_ ___PRM(65,___G_c_23_def_2d_var_2d_set_21_)
#define ___GLO_c_23_def_3f_ ___GLO(66,___G_c_23_def_3f_)
#define ___PRM_c_23_def_3f_ ___PRM(66,___G_c_23_def_3f_)
#define ___GLO_c_23_definition_2d_name ___GLO(67,___G_c_23_definition_2d_name)
#define ___PRM_c_23_definition_2d_name ___PRM(67,___G_c_23_definition_2d_name)
#define ___GLO_c_23_definition_2d_value ___GLO(68,___G_c_23_definition_2d_value)
#define ___PRM_c_23_definition_2d_value ___PRM(68,___G_c_23_definition_2d_value)
#define ___GLO_c_23_disj_2d_alt ___GLO(69,___G_c_23_disj_2d_alt)
#define ___PRM_c_23_disj_2d_alt ___PRM(69,___G_c_23_disj_2d_alt)
#define ___GLO_c_23_disj_2d_pre ___GLO(70,___G_c_23_disj_2d_pre)
#define ___PRM_c_23_disj_2d_pre ___PRM(70,___G_c_23_disj_2d_pre)
#define ___GLO_c_23_disj_2d_tag ___GLO(71,___G_c_23_disj_2d_tag)
#define ___PRM_c_23_disj_2d_tag ___PRM(71,___G_c_23_disj_2d_tag)
#define ___GLO_c_23_disj_3f_ ___GLO(72,___G_c_23_disj_3f_)
#define ___PRM_c_23_disj_3f_ ___PRM(72,___G_c_23_disj_3f_)
#define ___GLO_c_23_environment_2d_map_3f_ ___GLO(73,___G_c_23_environment_2d_map_3f_)
#define ___PRM_c_23_environment_2d_map_3f_ ___PRM(73,___G_c_23_environment_2d_map_3f_)
#define ___GLO_c_23_extended_2d_binding_3f_ ___GLO(74,___G_c_23_extended_2d_binding_3f_)
#define ___PRM_c_23_extended_2d_binding_3f_ ___PRM(74,___G_c_23_extended_2d_binding_3f_)
#define ___GLO_c_23_extract_2d_names ___GLO(75,___G_c_23_extract_2d_names)
#define ___PRM_c_23_extract_2d_names ___PRM(75,___G_c_23_extract_2d_names)
#define ___GLO_c_23_extract_2d_parameters ___GLO(76,___G_c_23_extract_2d_parameters)
#define ___PRM_c_23_extract_2d_parameters ___PRM(76,___G_c_23_extract_2d_parameters)
#define ___GLO_c_23_free_2d_variables ___GLO(77,___G_c_23_free_2d_variables)
#define ___PRM_c_23_free_2d_variables ___PRM(77,___G_c_23_free_2d_variables)
#define ___GLO_c_23_fut_2d_tag ___GLO(78,___G_c_23_fut_2d_tag)
#define ___PRM_c_23_fut_2d_tag ___PRM(78,___G_c_23_fut_2d_tag)
#define ___GLO_c_23_fut_2d_val ___GLO(79,___G_c_23_fut_2d_val)
#define ___PRM_c_23_fut_2d_val ___PRM(79,___G_c_23_fut_2d_val)
#define ___GLO_c_23_fut_3f_ ___GLO(80,___G_c_23_fut_3f_)
#define ___PRM_c_23_fut_3f_ ___PRM(80,___G_c_23_fut_3f_)
#define ___GLO_c_23_global_2d_proc_2d_obj ___GLO(81,___G_c_23_global_2d_proc_2d_obj)
#define ___PRM_c_23_global_2d_proc_2d_obj ___PRM(81,___G_c_23_global_2d_proc_2d_obj)
#define ___GLO_c_23_global_2d_single_2d_def ___GLO(82,___G_c_23_global_2d_single_2d_def)
#define ___PRM_c_23_global_2d_single_2d_def ___PRM(82,___G_c_23_global_2d_single_2d_def)
#define ___GLO_c_23_global_2d_singly_2d_bound_3f_ ___GLO(83,___G_c_23_global_2d_singly_2d_bound_3f_)
#define ___PRM_c_23_global_2d_singly_2d_bound_3f_ ___PRM(83,___G_c_23_global_2d_singly_2d_bound_3f_)
#define ___GLO_c_23_global_3f_ ___GLO(84,___G_c_23_global_3f_)
#define ___PRM_c_23_global_3f_ ___PRM(84,___G_c_23_global_3f_)
#define ___GLO_c_23_ill_2d_formed_2d_special_2d_form ___GLO(85,___G_c_23_ill_2d_formed_2d_special_2d_form)
#define ___PRM_c_23_ill_2d_formed_2d_special_2d_form ___PRM(85,___G_c_23_ill_2d_formed_2d_special_2d_form)
#define ___GLO_c_23_inline_2d_primitive_3f_ ___GLO(86,___G_c_23_inline_2d_primitive_3f_)
#define ___PRM_c_23_inline_2d_primitive_3f_ ___PRM(86,___G_c_23_inline_2d_primitive_3f_)
#define ___GLO_c_23_inline_3f_ ___GLO(87,___G_c_23_inline_3f_)
#define ___PRM_c_23_inline_3f_ ___PRM(87,___G_c_23_inline_3f_)
#define ___GLO_c_23_inlining_2d_limit ___GLO(88,___G_c_23_inlining_2d_limit)
#define ___PRM_c_23_inlining_2d_limit ___PRM(88,___G_c_23_inlining_2d_limit)
#define ___GLO_c_23_intrs_2d_enabled_3f_ ___GLO(89,___G_c_23_intrs_2d_enabled_3f_)
#define ___PRM_c_23_intrs_2d_enabled_3f_ ___PRM(89,___G_c_23_intrs_2d_enabled_3f_)
#define ___GLO_c_23_lambda_2d_expr_3f_ ___GLO(90,___G_c_23_lambda_2d_expr_3f_)
#define ___PRM_c_23_lambda_2d_expr_3f_ ___PRM(90,___G_c_23_lambda_2d_expr_3f_)
#define ___GLO_c_23_lambda_2d_lift_3f_ ___GLO(91,___G_c_23_lambda_2d_lift_3f_)
#define ___PRM_c_23_lambda_2d_lift_3f_ ___PRM(91,___G_c_23_lambda_2d_lift_3f_)
#define ___GLO_c_23_length_3f_ ___GLO(92,___G_c_23_length_3f_)
#define ___PRM_c_23_length_3f_ ___PRM(92,___G_c_23_length_3f_)
#define ___GLO_c_23_list_2d_construction_3f_ ___GLO(93,___G_c_23_list_2d_construction_3f_)
#define ___PRM_c_23_list_2d_construction_3f_ ___PRM(93,___G_c_23_list_2d_construction_3f_)
#define ___GLO_c_23_macro_2d_expand ___GLO(94,___G_c_23_macro_2d_expand)
#define ___PRM_c_23_macro_2d_expand ___PRM(94,___G_c_23_macro_2d_expand)
#define ___GLO_c_23_macro_2d_expr_3f_ ___GLO(95,___G_c_23_macro_2d_expr_3f_)
#define ___PRM_c_23_macro_2d_expr_3f_ ___PRM(95,___G_c_23_macro_2d_expr_3f_)
#define ___GLO_c_23_make_2d_app ___GLO(96,___G_c_23_make_2d_app)
#define ___PRM_c_23_make_2d_app ___PRM(96,___G_c_23_make_2d_app)
#define ___GLO_c_23_make_2d_conj ___GLO(97,___G_c_23_make_2d_conj)
#define ___PRM_c_23_make_2d_conj ___PRM(97,___G_c_23_make_2d_conj)
#define ___GLO_c_23_make_2d_cst ___GLO(98,___G_c_23_make_2d_cst)
#define ___PRM_c_23_make_2d_cst ___PRM(98,___G_c_23_make_2d_cst)
#define ___GLO_c_23_make_2d_def ___GLO(99,___G_c_23_make_2d_def)
#define ___PRM_c_23_make_2d_def ___PRM(99,___G_c_23_make_2d_def)
#define ___GLO_c_23_make_2d_disj ___GLO(100,___G_c_23_make_2d_disj)
#define ___PRM_c_23_make_2d_disj ___PRM(100,___G_c_23_make_2d_disj)
#define ___GLO_c_23_make_2d_fut ___GLO(101,___G_c_23_make_2d_fut)
#define ___PRM_c_23_make_2d_fut ___PRM(101,___G_c_23_make_2d_fut)
#define ___GLO_c_23_make_2d_prc ___GLO(102,___G_c_23_make_2d_prc)
#define ___PRM_c_23_make_2d_prc ___PRM(102,___G_c_23_make_2d_prc)
#define ___GLO_c_23_make_2d_ref ___GLO(103,___G_c_23_make_2d_ref)
#define ___PRM_c_23_make_2d_ref ___PRM(103,___G_c_23_make_2d_ref)
#define ___GLO_c_23_make_2d_set ___GLO(104,___G_c_23_make_2d_set)
#define ___PRM_c_23_make_2d_set ___PRM(104,___G_c_23_make_2d_set)
#define ___GLO_c_23_make_2d_tst ___GLO(105,___G_c_23_make_2d_tst)
#define ___PRM_c_23_make_2d_tst ___PRM(105,___G_c_23_make_2d_tst)
#define ___GLO_c_23_match ___GLO(106,___G_c_23_match)
#define ___PRM_c_23_match ___PRM(106,___G_c_23_match)
#define ___GLO_c_23_mutable_3f_ ___GLO(107,___G_c_23_mutable_3f_)
#define ___PRM_c_23_mutable_3f_ ___PRM(107,___G_c_23_mutable_3f_)
#define ___GLO_c_23_nb_2d_args_2d_conforms_3f_ ___GLO(108,___G_c_23_nb_2d_args_2d_conforms_3f_)
#define ___PRM_c_23_nb_2d_args_2d_conforms_3f_ ___PRM(108,___G_c_23_nb_2d_args_2d_conforms_3f_)
#define ___GLO_c_23_new_2d_call ___GLO(109,___G_c_23_new_2d_call)
#define ___PRM_c_23_new_2d_call ___PRM(109,___G_c_23_new_2d_call)
#define ___GLO_c_23_new_2d_call_2a_ ___GLO(110,___G_c_23_new_2d_call_2a_)
#define ___PRM_c_23_new_2d_call_2a_ ___PRM(110,___G_c_23_new_2d_call_2a_)
#define ___GLO_c_23_new_2d_conj ___GLO(111,___G_c_23_new_2d_conj)
#define ___PRM_c_23_new_2d_conj ___PRM(111,___G_c_23_new_2d_conj)
#define ___GLO_c_23_new_2d_cst ___GLO(112,___G_c_23_new_2d_cst)
#define ___PRM_c_23_new_2d_cst ___PRM(112,___G_c_23_new_2d_cst)
#define ___GLO_c_23_new_2d_def ___GLO(113,___G_c_23_new_2d_def)
#define ___PRM_c_23_new_2d_def ___PRM(113,___G_c_23_new_2d_def)
#define ___GLO_c_23_new_2d_disj ___GLO(114,___G_c_23_new_2d_disj)
#define ___PRM_c_23_new_2d_disj ___PRM(114,___G_c_23_new_2d_disj)
#define ___GLO_c_23_new_2d_disj_2d_call ___GLO(115,___G_c_23_new_2d_disj_2d_call)
#define ___PRM_c_23_new_2d_disj_2d_call ___PRM(115,___G_c_23_new_2d_disj_2d_call)
#define ___GLO_c_23_new_2d_fut ___GLO(116,___G_c_23_new_2d_fut)
#define ___PRM_c_23_new_2d_fut ___PRM(116,___G_c_23_new_2d_fut)
#define ___GLO_c_23_new_2d_let ___GLO(117,___G_c_23_new_2d_let)
#define ___PRM_c_23_new_2d_let ___PRM(117,___G_c_23_new_2d_let)
#define ___GLO_c_23_new_2d_prc ___GLO(118,___G_c_23_new_2d_prc)
#define ___PRM_c_23_new_2d_prc ___PRM(118,___G_c_23_new_2d_prc)
#define ___GLO_c_23_new_2d_ref ___GLO(119,___G_c_23_new_2d_ref)
#define ___PRM_c_23_new_2d_ref ___PRM(119,___G_c_23_new_2d_ref)
#define ___GLO_c_23_new_2d_ref_2d_extended_2d_bindings ___GLO(120,___G_c_23_new_2d_ref_2d_extended_2d_bindings)
#define ___PRM_c_23_new_2d_ref_2d_extended_2d_bindings ___PRM(120,___G_c_23_new_2d_ref_2d_extended_2d_bindings)
#define ___GLO_c_23_new_2d_seq ___GLO(121,___G_c_23_new_2d_seq)
#define ___PRM_c_23_new_2d_seq ___PRM(121,___G_c_23_new_2d_seq)
#define ___GLO_c_23_new_2d_set ___GLO(122,___G_c_23_new_2d_set)
#define ___PRM_c_23_new_2d_set ___PRM(122,___G_c_23_new_2d_set)
#define ___GLO_c_23_new_2d_temp_2d_variable ___GLO(123,___G_c_23_new_2d_temp_2d_variable)
#define ___PRM_c_23_new_2d_temp_2d_variable ___PRM(123,___G_c_23_new_2d_temp_2d_variable)
#define ___GLO_c_23_new_2d_tst ___GLO(124,___G_c_23_new_2d_tst)
#define ___PRM_c_23_new_2d_tst ___PRM(124,___G_c_23_new_2d_tst)
#define ___GLO_c_23_new_2d_variable ___GLO(125,___G_c_23_new_2d_variable)
#define ___PRM_c_23_new_2d_variable ___PRM(125,___G_c_23_new_2d_variable)
#define ___GLO_c_23_new_2d_variables ___GLO(126,___G_c_23_new_2d_variables)
#define ___PRM_c_23_new_2d_variables ___PRM(126,___G_c_23_new_2d_variables)
#define ___GLO_c_23_next_2d_node_2d_stamp ___GLO(127,___G_c_23_next_2d_node_2d_stamp)
#define ___PRM_c_23_next_2d_node_2d_stamp ___PRM(127,___G_c_23_next_2d_node_2d_stamp)
#define ___GLO_c_23_node_2d_bfv ___GLO(128,___G_c_23_node_2d_bfv)
#define ___PRM_c_23_node_2d_bfv ___PRM(128,___G_c_23_node_2d_bfv)
#define ___GLO_c_23_node_2d_bfv_2d_set_21_ ___GLO(129,___G_c_23_node_2d_bfv_2d_set_21_)
#define ___PRM_c_23_node_2d_bfv_2d_set_21_ ___PRM(129,___G_c_23_node_2d_bfv_2d_set_21_)
#define ___GLO_c_23_node_2d_children ___GLO(130,___G_c_23_node_2d_children)
#define ___PRM_c_23_node_2d_children ___PRM(130,___G_c_23_node_2d_children)
#define ___GLO_c_23_node_2d_children_2d_set_21_ ___GLO(131,___G_c_23_node_2d_children_2d_set_21_)
#define ___PRM_c_23_node_2d_children_2d_set_21_ ___PRM(131,___G_c_23_node_2d_children_2d_set_21_)
#define ___GLO_c_23_node_2d_env ___GLO(132,___G_c_23_node_2d_env)
#define ___PRM_c_23_node_2d_env ___PRM(132,___G_c_23_node_2d_env)
#define ___GLO_c_23_node_2d_env_2d_set_21_ ___GLO(133,___G_c_23_node_2d_env_2d_set_21_)
#define ___PRM_c_23_node_2d_env_2d_set_21_ ___PRM(133,___G_c_23_node_2d_env_2d_set_21_)
#define ___GLO_c_23_node_2d_fv ___GLO(134,___G_c_23_node_2d_fv)
#define ___PRM_c_23_node_2d_fv ___PRM(134,___G_c_23_node_2d_fv)
#define ___GLO_c_23_node_2d_fv_2d_invalidate_21_ ___GLO(135,___G_c_23_node_2d_fv_2d_invalidate_21_)
#define ___PRM_c_23_node_2d_fv_2d_invalidate_21_ ___PRM(135,___G_c_23_node_2d_fv_2d_invalidate_21_)
#define ___GLO_c_23_node_2d_fv_2d_set_21_ ___GLO(136,___G_c_23_node_2d_fv_2d_set_21_)
#define ___PRM_c_23_node_2d_fv_2d_set_21_ ___PRM(136,___G_c_23_node_2d_fv_2d_set_21_)
#define ___GLO_c_23_node_2d_parent ___GLO(137,___G_c_23_node_2d_parent)
#define ___PRM_c_23_node_2d_parent ___PRM(137,___G_c_23_node_2d_parent)
#define ___GLO_c_23_node_2d_parent_2d_set_21_ ___GLO(138,___G_c_23_node_2d_parent_2d_set_21_)
#define ___PRM_c_23_node_2d_parent_2d_set_21_ ___PRM(138,___G_c_23_node_2d_parent_2d_set_21_)
#define ___GLO_c_23_node_2d_source ___GLO(139,___G_c_23_node_2d_source)
#define ___PRM_c_23_node_2d_source ___PRM(139,___G_c_23_node_2d_source)
#define ___GLO_c_23_node_2d_source_2d_set_21_ ___GLO(140,___G_c_23_node_2d_source_2d_set_21_)
#define ___PRM_c_23_node_2d_source_2d_set_21_ ___PRM(140,___G_c_23_node_2d_source_2d_set_21_)
#define ___GLO_c_23_node_2d_stamp ___GLO(141,___G_c_23_node_2d_stamp)
#define ___PRM_c_23_node_2d_stamp ___PRM(141,___G_c_23_node_2d_stamp)
#define ___GLO_c_23_node_2d_stamp_2d_set_21_ ___GLO(142,___G_c_23_node_2d_stamp_2d_set_21_)
#define ___PRM_c_23_node_2d_stamp_2d_set_21_ ___PRM(142,___G_c_23_node_2d_stamp_2d_set_21_)
#define ___GLO_c_23_not_2d_macro ___GLO(143,___G_c_23_not_2d_macro)
#define ___PRM_c_23_not_2d_macro ___PRM(143,___G_c_23_not_2d_macro)
#define ___GLO_c_23_oper_2d_pos_3f_ ___GLO(144,___G_c_23_oper_2d_pos_3f_)
#define ___PRM_c_23_oper_2d_pos_3f_ ___PRM(144,___G_c_23_oper_2d_pos_3f_)
#define ___GLO_c_23_optimize_2d_dead_2d_local_2d_variables_3f_ ___GLO(145,___G_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
#define ___PRM_c_23_optimize_2d_dead_2d_local_2d_variables_3f_ ___PRM(145,___G_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
#define ___GLO_c_23_parameter_2d_default_2d_source ___GLO(146,___G_c_23_parameter_2d_default_2d_source)
#define ___PRM_c_23_parameter_2d_default_2d_source ___PRM(146,___G_c_23_parameter_2d_default_2d_source)
#define ___GLO_c_23_parameter_2d_name ___GLO(147,___G_c_23_parameter_2d_name)
#define ___PRM_c_23_parameter_2d_name ___PRM(147,___G_c_23_parameter_2d_name)
#define ___GLO_c_23_parameter_2d_source ___GLO(148,___G_c_23_parameter_2d_source)
#define ___PRM_c_23_parameter_2d_source ___PRM(148,___G_c_23_parameter_2d_source)
#define ___GLO_c_23_parms_2d__3e_source ___GLO(149,___G_c_23_parms_2d__3e_source)
#define ___PRM_c_23_parms_2d__3e_source ___PRM(149,___G_c_23_parms_2d__3e_source)
#define ___GLO_c_23_parse_2d_program ___GLO(150,___G_c_23_parse_2d_program)
#define ___PRM_c_23_parse_2d_program ___PRM(150,___G_c_23_parse_2d_program)
#define ___GLO_c_23_prc_2d_body ___GLO(151,___G_c_23_prc_2d_body)
#define ___PRM_c_23_prc_2d_body ___PRM(151,___G_c_23_prc_2d_body)
#define ___GLO_c_23_prc_2d_c_2d_name ___GLO(152,___G_c_23_prc_2d_c_2d_name)
#define ___PRM_c_23_prc_2d_c_2d_name ___PRM(152,___G_c_23_prc_2d_c_2d_name)
#define ___GLO_c_23_prc_2d_c_2d_name_2d_set_21_ ___GLO(153,___G_c_23_prc_2d_c_2d_name_2d_set_21_)
#define ___PRM_c_23_prc_2d_c_2d_name_2d_set_21_ ___PRM(153,___G_c_23_prc_2d_c_2d_name_2d_set_21_)
#define ___GLO_c_23_prc_2d_keys ___GLO(154,___G_c_23_prc_2d_keys)
#define ___PRM_c_23_prc_2d_keys ___PRM(154,___G_c_23_prc_2d_keys)
#define ___GLO_c_23_prc_2d_keys_2d_set_21_ ___GLO(155,___G_c_23_prc_2d_keys_2d_set_21_)
#define ___PRM_c_23_prc_2d_keys_2d_set_21_ ___PRM(155,___G_c_23_prc_2d_keys_2d_set_21_)
#define ___GLO_c_23_prc_2d_name ___GLO(156,___G_c_23_prc_2d_name)
#define ___PRM_c_23_prc_2d_name ___PRM(156,___G_c_23_prc_2d_name)
#define ___GLO_c_23_prc_2d_name_2d_set_21_ ___GLO(157,___G_c_23_prc_2d_name_2d_set_21_)
#define ___PRM_c_23_prc_2d_name_2d_set_21_ ___PRM(157,___G_c_23_prc_2d_name_2d_set_21_)
#define ___GLO_c_23_prc_2d_opts ___GLO(158,___G_c_23_prc_2d_opts)
#define ___PRM_c_23_prc_2d_opts ___PRM(158,___G_c_23_prc_2d_opts)
#define ___GLO_c_23_prc_2d_opts_2d_set_21_ ___GLO(159,___G_c_23_prc_2d_opts_2d_set_21_)
#define ___PRM_c_23_prc_2d_opts_2d_set_21_ ___PRM(159,___G_c_23_prc_2d_opts_2d_set_21_)
#define ___GLO_c_23_prc_2d_parms ___GLO(160,___G_c_23_prc_2d_parms)
#define ___PRM_c_23_prc_2d_parms ___PRM(160,___G_c_23_prc_2d_parms)
#define ___GLO_c_23_prc_2d_parms_2d_set_21_ ___GLO(161,___G_c_23_prc_2d_parms_2d_set_21_)
#define ___PRM_c_23_prc_2d_parms_2d_set_21_ ___PRM(161,___G_c_23_prc_2d_parms_2d_set_21_)
#define ___GLO_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_ ___GLO(162,___G_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
#define ___PRM_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_ ___PRM(162,___G_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
#define ___GLO_c_23_prc_2d_rest_3f_ ___GLO(163,___G_c_23_prc_2d_rest_3f_)
#define ___PRM_c_23_prc_2d_rest_3f_ ___PRM(163,___G_c_23_prc_2d_rest_3f_)
#define ___GLO_c_23_prc_2d_rest_3f__2d_set_21_ ___GLO(164,___G_c_23_prc_2d_rest_3f__2d_set_21_)
#define ___PRM_c_23_prc_2d_rest_3f__2d_set_21_ ___PRM(164,___G_c_23_prc_2d_rest_3f__2d_set_21_)
#define ___GLO_c_23_prc_2d_tag ___GLO(165,___G_c_23_prc_2d_tag)
#define ___PRM_c_23_prc_2d_tag ___PRM(165,___G_c_23_prc_2d_tag)
#define ___GLO_c_23_prc_3f_ ___GLO(166,___G_c_23_prc_3f_)
#define ___PRM_c_23_prc_3f_ ___PRM(166,___G_c_23_prc_3f_)
#define ___GLO_c_23_proper_2d_bindings_3f_ ___GLO(167,___G_c_23_proper_2d_bindings_3f_)
#define ___PRM_c_23_proper_2d_bindings_3f_ ___PRM(167,___G_c_23_proper_2d_bindings_3f_)
#define ___GLO_c_23_proper_2d_case_2d_clauses_3f_ ___GLO(168,___G_c_23_proper_2d_case_2d_clauses_3f_)
#define ___PRM_c_23_proper_2d_case_2d_clauses_3f_ ___PRM(168,___G_c_23_proper_2d_case_2d_clauses_3f_)
#define ___GLO_c_23_proper_2d_clauses_3f_ ___GLO(169,___G_c_23_proper_2d_clauses_3f_)
#define ___PRM_c_23_proper_2d_clauses_3f_ ___PRM(169,___G_c_23_proper_2d_clauses_3f_)
#define ___GLO_c_23_proper_2d_do_2d_bindings_3f_ ___GLO(170,___G_c_23_proper_2d_do_2d_bindings_3f_)
#define ___PRM_c_23_proper_2d_do_2d_bindings_3f_ ___PRM(170,___G_c_23_proper_2d_do_2d_bindings_3f_)
#define ___GLO_c_23_proper_2d_do_2d_exit_3f_ ___GLO(171,___G_c_23_proper_2d_do_2d_exit_3f_)
#define ___PRM_c_23_proper_2d_do_2d_exit_3f_ ___PRM(171,___G_c_23_proper_2d_do_2d_exit_3f_)
#define ___GLO_c_23_proper_2d_length ___GLO(172,___G_c_23_proper_2d_length)
#define ___PRM_c_23_proper_2d_length ___PRM(172,___G_c_23_proper_2d_length)
#define ___GLO_c_23_proper_2d_selector_2d_list_3f_ ___GLO(173,___G_c_23_proper_2d_selector_2d_list_3f_)
#define ___PRM_c_23_proper_2d_selector_2d_list_3f_ ___PRM(173,___G_c_23_proper_2d_selector_2d_list_3f_)
#define ___GLO_c_23_proper_2d_tail_2d_calls_3f_ ___GLO(174,___G_c_23_proper_2d_tail_2d_calls_3f_)
#define ___PRM_c_23_proper_2d_tail_2d_calls_3f_ ___PRM(174,___G_c_23_proper_2d_tail_2d_calls_3f_)
#define ___GLO_c_23_pt ___GLO(175,___G_c_23_pt)
#define ___PRM_c_23_pt ___PRM(175,___G_c_23_pt)
#define ___GLO_c_23_pt_2d_and ___GLO(176,___G_c_23_pt_2d_and)
#define ___PRM_c_23_pt_2d_and ___PRM(176,___G_c_23_pt_2d_and)
#define ___GLO_c_23_pt_2d_begin ___GLO(177,___G_c_23_pt_2d_begin)
#define ___PRM_c_23_pt_2d_begin ___PRM(177,___G_c_23_pt_2d_begin)
#define ___GLO_c_23_pt_2d_body ___GLO(178,___G_c_23_pt_2d_body)
#define ___PRM_c_23_pt_2d_body ___PRM(178,___G_c_23_pt_2d_body)
#define ___GLO_c_23_pt_2d_case ___GLO(179,___G_c_23_pt_2d_case)
#define ___PRM_c_23_pt_2d_case ___PRM(179,___G_c_23_pt_2d_case)
#define ___GLO_c_23_pt_2d_combination ___GLO(180,___G_c_23_pt_2d_combination)
#define ___PRM_c_23_pt_2d_combination ___PRM(180,___G_c_23_pt_2d_combination)
#define ___GLO_c_23_pt_2d_cond ___GLO(181,___G_c_23_pt_2d_cond)
#define ___PRM_c_23_pt_2d_cond ___PRM(181,___G_c_23_pt_2d_cond)
#define ___GLO_c_23_pt_2d_delay ___GLO(182,___G_c_23_pt_2d_delay)
#define ___PRM_c_23_pt_2d_delay ___PRM(182,___G_c_23_pt_2d_delay)
#define ___GLO_c_23_pt_2d_do ___GLO(183,___G_c_23_pt_2d_do)
#define ___PRM_c_23_pt_2d_do ___PRM(183,___G_c_23_pt_2d_do)
#define ___GLO_c_23_pt_2d_future ___GLO(184,___G_c_23_pt_2d_future)
#define ___PRM_c_23_pt_2d_future ___PRM(184,___G_c_23_pt_2d_future)
#define ___GLO_c_23_pt_2d_if ___GLO(185,___G_c_23_pt_2d_if)
#define ___PRM_c_23_pt_2d_if ___PRM(185,___G_c_23_pt_2d_if)
#define ___GLO_c_23_pt_2d_lambda ___GLO(186,___G_c_23_pt_2d_lambda)
#define ___PRM_c_23_pt_2d_lambda ___PRM(186,___G_c_23_pt_2d_lambda)
#define ___GLO_c_23_pt_2d_let ___GLO(187,___G_c_23_pt_2d_let)
#define ___PRM_c_23_pt_2d_let ___PRM(187,___G_c_23_pt_2d_let)
#define ___GLO_c_23_pt_2d_let_2a_ ___GLO(188,___G_c_23_pt_2d_let_2a_)
#define ___PRM_c_23_pt_2d_let_2a_ ___PRM(188,___G_c_23_pt_2d_let_2a_)
#define ___GLO_c_23_pt_2d_letrec ___GLO(189,___G_c_23_pt_2d_letrec)
#define ___PRM_c_23_pt_2d_letrec ___PRM(189,___G_c_23_pt_2d_letrec)
#define ___GLO_c_23_pt_2d_or ___GLO(190,___G_c_23_pt_2d_or)
#define ___PRM_c_23_pt_2d_or ___PRM(190,___G_c_23_pt_2d_or)
#define ___GLO_c_23_pt_2d_quasiquotation ___GLO(191,___G_c_23_pt_2d_quasiquotation)
#define ___PRM_c_23_pt_2d_quasiquotation ___PRM(191,___G_c_23_pt_2d_quasiquotation)
#define ___GLO_c_23_pt_2d_quasiquotation_2d_list ___GLO(192,___G_c_23_pt_2d_quasiquotation_2d_list)
#define ___PRM_c_23_pt_2d_quasiquotation_2d_list ___PRM(192,___G_c_23_pt_2d_quasiquotation_2d_list)
#define ___GLO_c_23_pt_2d_quasiquote ___GLO(193,___G_c_23_pt_2d_quasiquote)
#define ___PRM_c_23_pt_2d_quasiquote ___PRM(193,___G_c_23_pt_2d_quasiquote)
#define ___GLO_c_23_pt_2d_quote ___GLO(194,___G_c_23_pt_2d_quote)
#define ___PRM_c_23_pt_2d_quote ___PRM(194,___G_c_23_pt_2d_quote)
#define ___GLO_c_23_pt_2d_recursive_2d_let ___GLO(195,___G_c_23_pt_2d_recursive_2d_let)
#define ___PRM_c_23_pt_2d_recursive_2d_let ___PRM(195,___G_c_23_pt_2d_recursive_2d_let)
#define ___GLO_c_23_pt_2d_self_2d_eval ___GLO(196,___G_c_23_pt_2d_self_2d_eval)
#define ___PRM_c_23_pt_2d_self_2d_eval ___PRM(196,___G_c_23_pt_2d_self_2d_eval)
#define ___GLO_c_23_pt_2d_sequence ___GLO(197,___G_c_23_pt_2d_sequence)
#define ___PRM_c_23_pt_2d_sequence ___PRM(197,___G_c_23_pt_2d_sequence)
#define ___GLO_c_23_pt_2d_set_21_ ___GLO(198,___G_c_23_pt_2d_set_21_)
#define ___PRM_c_23_pt_2d_set_21_ ___PRM(198,___G_c_23_pt_2d_set_21_)
#define ___GLO_c_23_pt_2d_syntax_2d_error ___GLO(199,___G_c_23_pt_2d_syntax_2d_error)
#define ___PRM_c_23_pt_2d_syntax_2d_error ___PRM(199,___G_c_23_pt_2d_syntax_2d_error)
#define ___GLO_c_23_pt_2d_var ___GLO(200,___G_c_23_pt_2d_var)
#define ___PRM_c_23_pt_2d_var ___PRM(200,___G_c_23_pt_2d_var)
#define ___GLO_c_23_ptree_2e_begin_21_ ___GLO(201,___G_c_23_ptree_2e_begin_21_)
#define ___PRM_c_23_ptree_2e_begin_21_ ___PRM(201,___G_c_23_ptree_2e_begin_21_)
#define ___GLO_c_23_ptree_2e_end_21_ ___GLO(202,___G_c_23_ptree_2e_end_21_)
#define ___PRM_c_23_ptree_2e_end_21_ ___PRM(202,___G_c_23_ptree_2e_end_21_)
#define ___GLO_c_23_quasiquote_2d_expr_3f_ ___GLO(203,___G_c_23_quasiquote_2d_expr_3f_)
#define ___PRM_c_23_quasiquote_2d_expr_3f_ ___PRM(203,___G_c_23_quasiquote_2d_expr_3f_)
#define ___GLO_c_23_ref_2d_tag ___GLO(204,___G_c_23_ref_2d_tag)
#define ___PRM_c_23_ref_2d_tag ___PRM(204,___G_c_23_ref_2d_tag)
#define ___GLO_c_23_ref_2d_var ___GLO(205,___G_c_23_ref_2d_var)
#define ___PRM_c_23_ref_2d_var ___PRM(205,___G_c_23_ref_2d_var)
#define ___GLO_c_23_ref_2d_var_2d_set_21_ ___GLO(206,___G_c_23_ref_2d_var_2d_set_21_)
#define ___PRM_c_23_ref_2d_var_2d_set_21_ ___PRM(206,___G_c_23_ref_2d_var_2d_set_21_)
#define ___GLO_c_23_ref_3f_ ___GLO(207,___G_c_23_ref_3f_)
#define ___PRM_c_23_ref_3f_ ___PRM(207,___G_c_23_ref_3f_)
#define ___GLO_c_23_run_2d_time_2d_binding_3f_ ___GLO(208,___G_c_23_run_2d_time_2d_binding_3f_)
#define ___PRM_c_23_run_2d_time_2d_binding_3f_ ___PRM(208,___G_c_23_run_2d_time_2d_binding_3f_)
#define ___GLO_c_23_safe_3f_ ___GLO(209,___G_c_23_safe_3f_)
#define ___PRM_c_23_safe_3f_ ___PRM(209,___G_c_23_safe_3f_)
#define ___GLO_c_23_scheme_2d_dialect ___GLO(210,___G_c_23_scheme_2d_dialect)
#define ___PRM_c_23_scheme_2d_dialect ___PRM(210,___G_c_23_scheme_2d_dialect)
#define ___GLO_c_23_self_2d_eval_2d_expr_3f_ ___GLO(211,___G_c_23_self_2d_eval_2d_expr_3f_)
#define ___PRM_c_23_self_2d_eval_2d_expr_3f_ ___PRM(211,___G_c_23_self_2d_eval_2d_expr_3f_)
#define ___GLO_c_23_self_2d_evaluating_3f_ ___GLO(212,___G_c_23_self_2d_evaluating_3f_)
#define ___PRM_c_23_self_2d_evaluating_3f_ ___PRM(212,___G_c_23_self_2d_evaluating_3f_)
#define ___GLO_c_23_set_2d_prc_2d_names_21_ ___GLO(213,___G_c_23_set_2d_prc_2d_names_21_)
#define ___PRM_c_23_set_2d_prc_2d_names_21_ ___PRM(213,___G_c_23_set_2d_prc_2d_names_21_)
#define ___GLO_c_23_set_2d_tag ___GLO(214,___G_c_23_set_2d_tag)
#define ___PRM_c_23_set_2d_tag ___PRM(214,___G_c_23_set_2d_tag)
#define ___GLO_c_23_set_2d_val ___GLO(215,___G_c_23_set_2d_val)
#define ___PRM_c_23_set_2d_val ___PRM(215,___G_c_23_set_2d_val)
#define ___GLO_c_23_set_2d_var ___GLO(216,___G_c_23_set_2d_var)
#define ___PRM_c_23_set_2d_var ___PRM(216,___G_c_23_set_2d_var)
#define ___GLO_c_23_set_2d_var_2d_set_21_ ___GLO(217,___G_c_23_set_2d_var_2d_set_21_)
#define ___PRM_c_23_set_2d_var_2d_set_21_ ___PRM(217,___G_c_23_set_2d_var_2d_set_21_)
#define ___GLO_c_23_set_3f_ ___GLO(218,___G_c_23_set_3f_)
#define ___PRM_c_23_set_3f_ ___PRM(218,___G_c_23_set_3f_)
#define ___GLO_c_23_source_2d__3e_parms ___GLO(219,___G_c_23_source_2d__3e_parms)
#define ___PRM_c_23_source_2d__3e_parms ___PRM(219,___G_c_23_source_2d__3e_parms)
#define ___GLO_c_23_specialize_2d_app ___GLO(220,___G_c_23_specialize_2d_app)
#define ___PRM_c_23_specialize_2d_app ___PRM(220,___G_c_23_specialize_2d_app)
#define ___GLO_c_23_specialize_2d_proc ___GLO(221,___G_c_23_specialize_2d_proc)
#define ___PRM_c_23_specialize_2d_proc ___PRM(221,___G_c_23_specialize_2d_proc)
#define ___GLO_c_23_standard_2d_binding_3f_ ___GLO(222,___G_c_23_standard_2d_binding_3f_)
#define ___PRM_c_23_standard_2d_binding_3f_ ___PRM(222,___G_c_23_standard_2d_binding_3f_)
#define ___GLO_c_23_standard_2d_proc_2d_obj ___GLO(223,___G_c_23_standard_2d_proc_2d_obj)
#define ___PRM_c_23_standard_2d_proc_2d_obj ___PRM(223,___G_c_23_standard_2d_proc_2d_obj)
#define ___GLO_c_23_standard_2d_procedure_3f_ ___GLO(224,___G_c_23_standard_2d_procedure_3f_)
#define ___PRM_c_23_standard_2d_procedure_3f_ ___PRM(224,___G_c_23_standard_2d_procedure_3f_)
#define ___GLO_c_23_temp_2d_variable_2d_stamp ___GLO(225,___G_c_23_temp_2d_variable_2d_stamp)
#define ___PRM_c_23_temp_2d_variable_2d_stamp ___PRM(225,___G_c_23_temp_2d_variable_2d_stamp)
#define ___GLO_c_23_transform_2d_declaration ___GLO(226,___G_c_23_transform_2d_declaration)
#define ___PRM_c_23_transform_2d_declaration ___PRM(226,___G_c_23_transform_2d_declaration)
#define ___GLO_c_23_tst_2d_alt ___GLO(227,___G_c_23_tst_2d_alt)
#define ___PRM_c_23_tst_2d_alt ___PRM(227,___G_c_23_tst_2d_alt)
#define ___GLO_c_23_tst_2d_con ___GLO(228,___G_c_23_tst_2d_con)
#define ___PRM_c_23_tst_2d_con ___PRM(228,___G_c_23_tst_2d_con)
#define ___GLO_c_23_tst_2d_pre ___GLO(229,___G_c_23_tst_2d_pre)
#define ___PRM_c_23_tst_2d_pre ___PRM(229,___G_c_23_tst_2d_pre)
#define ___GLO_c_23_tst_2d_tag ___GLO(230,___G_c_23_tst_2d_tag)
#define ___PRM_c_23_tst_2d_tag ___PRM(230,___G_c_23_tst_2d_tag)
#define ___GLO_c_23_tst_3f_ ___GLO(231,___G_c_23_tst_3f_)
#define ___PRM_c_23_tst_3f_ ___PRM(231,___G_c_23_tst_3f_)
#define ___GLO_c_23_unquote_2d_expr_3f_ ___GLO(232,___G_c_23_unquote_2d_expr_3f_)
#define ___PRM_c_23_unquote_2d_expr_3f_ ___PRM(232,___G_c_23_unquote_2d_expr_3f_)
#define ___GLO_c_23_unquote_2d_splicing_2d_expr_3f_ ___GLO(233,___G_c_23_unquote_2d_splicing_2d_expr_3f_)
#define ___PRM_c_23_unquote_2d_splicing_2d_expr_3f_ ___PRM(233,___G_c_23_unquote_2d_splicing_2d_expr_3f_)
#define ___GLO_c_23_var_2d_expr_3f_ ___GLO(234,___G_c_23_var_2d_expr_3f_)
#define ___PRM_c_23_var_2d_expr_3f_ ___PRM(234,___G_c_23_var_2d_expr_3f_)
#define ___GLO_c_23_vector_2d_form ___GLO(235,___G_c_23_vector_2d_form)
#define ___PRM_c_23_vector_2d_form ___PRM(235,___G_c_23_vector_2d_form)
#define ___GLO_c_23_warnings_3f_ ___GLO(236,___G_c_23_warnings_3f_)
#define ___PRM_c_23_warnings_3f_ ___PRM(236,___G_c_23_warnings_3f_)
#define ___GLO__23__23_integer_3f_ ___GLO(237,___G__23__23_integer_3f_)
#define ___PRM__23__23_integer_3f_ ___PRM(237,___G__23__23_integer_3f_)
#define ___GLO__23__23_macro_2d_descr_2d_def_2d_syntax_3f_ ___GLO(238,___G__23__23_macro_2d_descr_2d_def_2d_syntax_3f_)
#define ___PRM__23__23_macro_2d_descr_2d_def_2d_syntax_3f_ ___PRM(238,___G__23__23_macro_2d_descr_2d_def_2d_syntax_3f_)
#define ___GLO__23__23_macro_2d_descr_2d_expander ___GLO(239,___G__23__23_macro_2d_descr_2d_expander)
#define ___PRM__23__23_macro_2d_descr_2d_expander ___PRM(239,___G__23__23_macro_2d_descr_2d_expander)
#define ___GLO__23__23_macro_2d_descr_2d_size ___GLO(240,___G__23__23_macro_2d_descr_2d_size)
#define ___PRM__23__23_macro_2d_descr_2d_size ___PRM(240,___G__23__23_macro_2d_descr_2d_size)
#define ___GLO__23__23_make_2d_macro_2d_descr ___GLO(241,___G__23__23_make_2d_macro_2d_descr)
#define ___PRM__23__23_make_2d_macro_2d_descr ___PRM(241,___G__23__23_make_2d_macro_2d_descr)
#define ___GLO__23__23_make_2d_source ___GLO(242,___G__23__23_make_2d_source)
#define ___PRM__23__23_make_2d_source ___PRM(242,___G__23__23_make_2d_source)
#define ___GLO__23__23_source_2d_code ___GLO(243,___G__23__23_source_2d_code)
#define ___PRM__23__23_source_2d_code ___PRM(243,___G__23__23_source_2d_code)
#define ___GLO__23__23_source_2d_locat ___GLO(244,___G__23__23_source_2d_locat)
#define ___PRM__23__23_source_2d_locat ___PRM(244,___G__23__23_source_2d_locat)
#define ___GLO__23__23_sourcify_2d_deep ___GLO(245,___G__23__23_sourcify_2d_deep)
#define ___PRM__23__23_sourcify_2d_deep ___PRM(245,___G__23__23_sourcify_2d_deep)
#define ___GLO_append ___GLO(246,___G_append)
#define ___PRM_append ___PRM(246,___G_append)
#define ___GLO_apply ___GLO(247,___G_apply)
#define ___PRM_apply ___PRM(247,___G_apply)
#define ___GLO_c_23__2a__2a_and_2d_sym ___GLO(248,___G_c_23__2a__2a_and_2d_sym)
#define ___PRM_c_23__2a__2a_and_2d_sym ___PRM(248,___G_c_23__2a__2a_and_2d_sym)
#define ___GLO_c_23__2a__2a_begin_2d_sym ___GLO(249,___G_c_23__2a__2a_begin_2d_sym)
#define ___PRM_c_23__2a__2a_begin_2d_sym ___PRM(249,___G_c_23__2a__2a_begin_2d_sym)
#define ___GLO_c_23__2a__2a_c_2d_declare_2d_expr_3f_ ___GLO(250,___G_c_23__2a__2a_c_2d_declare_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_c_2d_declare_2d_expr_3f_ ___PRM(250,___G_c_23__2a__2a_c_2d_declare_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_c_2d_define_2d_expr_3f_ ___GLO(251,___G_c_23__2a__2a_c_2d_define_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_c_2d_define_2d_expr_3f_ ___PRM(251,___G_c_23__2a__2a_c_2d_define_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_ ___GLO(252,___G_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_ ___PRM(252,___G_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_c_2d_initialize_2d_expr_3f_ ___GLO(253,___G_c_23__2a__2a_c_2d_initialize_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_c_2d_initialize_2d_expr_3f_ ___PRM(253,___G_c_23__2a__2a_c_2d_initialize_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_c_2d_lambda_2d_expr_3f_ ___GLO(254,___G_c_23__2a__2a_c_2d_lambda_2d_expr_3f_)
#define ___PRM_c_23__2a__2a_c_2d_lambda_2d_expr_3f_ ___PRM(254,___G_c_23__2a__2a_c_2d_lambda_2d_expr_3f_)
#define ___GLO_c_23__2a__2a_case_2d_sym ___GLO(255,___G_c_23__2a__2a_case_2d_sym)
#define ___PRM_c_23__2a__2a_case_2d_sym ___PRM(255,___G_c_23__2a__2a_case_2d_sym)
#define ___GLO_c_23__2a__2a_cond_2d_sym ___GLO(256,___G_c_23__2a__2a_cond_2d_sym)
#define ___PRM_c_23__2a__2a_cond_2d_sym ___PRM(256,___G_c_23__2a__2a_cond_2d_sym)
#define ___GLO_c_23__2a__2a_declare_2d_sym ___GLO(257,___G_c_23__2a__2a_declare_2d_sym)
#define ___PRM_c_23__2a__2a_declare_2d_sym ___PRM(257,___G_c_23__2a__2a_declare_2d_sym)
#define ___GLO_c_23__2a__2a_define_2d_macro_2d_sym ___GLO(258,___G_c_23__2a__2a_define_2d_macro_2d_sym)
#define ___PRM_c_23__2a__2a_define_2d_macro_2d_sym ___PRM(258,___G_c_23__2a__2a_define_2d_macro_2d_sym)
#define ___GLO_c_23__2a__2a_define_2d_sym ___GLO(259,___G_c_23__2a__2a_define_2d_sym)
#define ___PRM_c_23__2a__2a_define_2d_sym ___PRM(259,___G_c_23__2a__2a_define_2d_sym)
#define ___GLO_c_23__2a__2a_define_2d_syntax_2d_sym ___GLO(260,___G_c_23__2a__2a_define_2d_syntax_2d_sym)
#define ___PRM_c_23__2a__2a_define_2d_syntax_2d_sym ___PRM(260,___G_c_23__2a__2a_define_2d_syntax_2d_sym)
#define ___GLO_c_23__2a__2a_delay_2d_sym ___GLO(261,___G_c_23__2a__2a_delay_2d_sym)
#define ___PRM_c_23__2a__2a_delay_2d_sym ___PRM(261,___G_c_23__2a__2a_delay_2d_sym)
#define ___GLO_c_23__2a__2a_do_2d_sym ___GLO(262,___G_c_23__2a__2a_do_2d_sym)
#define ___PRM_c_23__2a__2a_do_2d_sym ___PRM(262,___G_c_23__2a__2a_do_2d_sym)
#define ___GLO_c_23__2a__2a_eq_3f__2d_sym ___GLO(263,___G_c_23__2a__2a_eq_3f__2d_sym)
#define ___PRM_c_23__2a__2a_eq_3f__2d_sym ___PRM(263,___G_c_23__2a__2a_eq_3f__2d_sym)
#define ___GLO_c_23__2a__2a_eqv_3f__2d_sym ___GLO(264,___G_c_23__2a__2a_eqv_3f__2d_sym)
#define ___PRM_c_23__2a__2a_eqv_3f__2d_sym ___PRM(264,___G_c_23__2a__2a_eqv_3f__2d_sym)
#define ___GLO_c_23__2a__2a_future_2d_sym ___GLO(265,___G_c_23__2a__2a_future_2d_sym)
#define ___PRM_c_23__2a__2a_future_2d_sym ___PRM(265,___G_c_23__2a__2a_future_2d_sym)
#define ___GLO_c_23__2a__2a_if_2d_sym ___GLO(266,___G_c_23__2a__2a_if_2d_sym)
#define ___PRM_c_23__2a__2a_if_2d_sym ___PRM(266,___G_c_23__2a__2a_if_2d_sym)
#define ___GLO_c_23__2a__2a_include_2d_sym ___GLO(267,___G_c_23__2a__2a_include_2d_sym)
#define ___PRM_c_23__2a__2a_include_2d_sym ___PRM(267,___G_c_23__2a__2a_include_2d_sym)
#define ___GLO_c_23__2a__2a_lambda_2d_sym ___GLO(268,___G_c_23__2a__2a_lambda_2d_sym)
#define ___PRM_c_23__2a__2a_lambda_2d_sym ___PRM(268,___G_c_23__2a__2a_lambda_2d_sym)
#define ___GLO_c_23__2a__2a_let_2a__2d_sym ___GLO(269,___G_c_23__2a__2a_let_2a__2d_sym)
#define ___PRM_c_23__2a__2a_let_2a__2d_sym ___PRM(269,___G_c_23__2a__2a_let_2a__2d_sym)
#define ___GLO_c_23__2a__2a_let_2d_sym ___GLO(270,___G_c_23__2a__2a_let_2d_sym)
#define ___PRM_c_23__2a__2a_let_2d_sym ___PRM(270,___G_c_23__2a__2a_let_2d_sym)
#define ___GLO_c_23__2a__2a_letrec_2d_sym ___GLO(271,___G_c_23__2a__2a_letrec_2d_sym)
#define ___PRM_c_23__2a__2a_letrec_2d_sym ___PRM(271,___G_c_23__2a__2a_letrec_2d_sym)
#define ___GLO_c_23__2a__2a_make_2d_promise_2d_sym ___GLO(272,___G_c_23__2a__2a_make_2d_promise_2d_sym)
#define ___PRM_c_23__2a__2a_make_2d_promise_2d_sym ___PRM(272,___G_c_23__2a__2a_make_2d_promise_2d_sym)
#define ___GLO_c_23__2a__2a_namespace_2d_sym ___GLO(273,___G_c_23__2a__2a_namespace_2d_sym)
#define ___PRM_c_23__2a__2a_namespace_2d_sym ___PRM(273,___G_c_23__2a__2a_namespace_2d_sym)
#define ___GLO_c_23__2a__2a_or_2d_sym ___GLO(274,___G_c_23__2a__2a_or_2d_sym)
#define ___PRM_c_23__2a__2a_or_2d_sym ___PRM(274,___G_c_23__2a__2a_or_2d_sym)
#define ___GLO_c_23__2a__2a_quasi_2d_append_2d_sym ___GLO(275,___G_c_23__2a__2a_quasi_2d_append_2d_sym)
#define ___PRM_c_23__2a__2a_quasi_2d_append_2d_sym ___PRM(275,___G_c_23__2a__2a_quasi_2d_append_2d_sym)
#define ___GLO_c_23__2a__2a_quasi_2d_cons_2d_proc_2d_obj ___GLO(276,___G_c_23__2a__2a_quasi_2d_cons_2d_proc_2d_obj)
#define ___PRM_c_23__2a__2a_quasi_2d_cons_2d_proc_2d_obj ___PRM(276,___G_c_23__2a__2a_quasi_2d_cons_2d_proc_2d_obj)
#define ___GLO_c_23__2a__2a_quasi_2d_cons_2d_sym ___GLO(277,___G_c_23__2a__2a_quasi_2d_cons_2d_sym)
#define ___PRM_c_23__2a__2a_quasi_2d_cons_2d_sym ___PRM(277,___G_c_23__2a__2a_quasi_2d_cons_2d_sym)
#define ___GLO_c_23__2a__2a_quasi_2d_list_2d__3e_vector_2d_sym ___GLO(278,___G_c_23__2a__2a_quasi_2d_list_2d__3e_vector_2d_sym)
#define ___PRM_c_23__2a__2a_quasi_2d_list_2d__3e_vector_2d_sym ___PRM(278,___G_c_23__2a__2a_quasi_2d_list_2d__3e_vector_2d_sym)
#define ___GLO_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj ___GLO(279,___G_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj)
#define ___PRM_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj ___PRM(279,___G_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj)
#define ___GLO_c_23__2a__2a_quasi_2d_list_2d_sym ___GLO(280,___G_c_23__2a__2a_quasi_2d_list_2d_sym)
#define ___PRM_c_23__2a__2a_quasi_2d_list_2d_sym ___PRM(280,___G_c_23__2a__2a_quasi_2d_list_2d_sym)
#define ___GLO_c_23__2a__2a_quasi_2d_vector_2d_sym ___GLO(281,___G_c_23__2a__2a_quasi_2d_vector_2d_sym)
#define ___PRM_c_23__2a__2a_quasi_2d_vector_2d_sym ___PRM(281,___G_c_23__2a__2a_quasi_2d_vector_2d_sym)
#define ___GLO_c_23__2a__2a_quasiquote_2d_sym ___GLO(282,___G_c_23__2a__2a_quasiquote_2d_sym)
#define ___PRM_c_23__2a__2a_quasiquote_2d_sym ___PRM(282,___G_c_23__2a__2a_quasiquote_2d_sym)
#define ___GLO_c_23__2a__2a_quote_2d_sym ___GLO(283,___G_c_23__2a__2a_quote_2d_sym)
#define ___PRM_c_23__2a__2a_quote_2d_sym ___PRM(283,___G_c_23__2a__2a_quote_2d_sym)
#define ___GLO_c_23__2a__2a_set_21__2d_sym ___GLO(284,___G_c_23__2a__2a_set_21__2d_sym)
#define ___PRM_c_23__2a__2a_set_21__2d_sym ___PRM(284,___G_c_23__2a__2a_set_21__2d_sym)
#define ___GLO_c_23__3d__3e__2d_sym ___GLO(285,___G_c_23__3d__3e__2d_sym)
#define ___PRM_c_23__3d__3e__2d_sym ___PRM(285,___G_c_23__3d__3e__2d_sym)
#define ___GLO_c_23_absent_2d_object ___GLO(286,___G_c_23_absent_2d_object)
#define ___PRM_c_23_absent_2d_object ___PRM(286,___G_c_23_absent_2d_object)
#define ___GLO_c_23_add_2d_c_2d_decl ___GLO(287,___G_c_23_add_2d_c_2d_decl)
#define ___PRM_c_23_add_2d_c_2d_decl ___PRM(287,___G_c_23_add_2d_c_2d_decl)
#define ___GLO_c_23_add_2d_c_2d_init ___GLO(288,___G_c_23_add_2d_c_2d_init)
#define ___PRM_c_23_add_2d_c_2d_init ___PRM(288,___G_c_23_add_2d_c_2d_init)
#define ___GLO_c_23_add_2d_c_2d_type ___GLO(289,___G_c_23_add_2d_c_2d_type)
#define ___PRM_c_23_add_2d_c_2d_type ___PRM(289,___G_c_23_add_2d_c_2d_type)
#define ___GLO_c_23_block_2d_sym ___GLO(290,___G_c_23_block_2d_sym)
#define ___PRM_c_23_block_2d_sym ___PRM(290,___G_c_23_block_2d_sym)
#define ___GLO_c_23_boolean_2d_decl ___GLO(291,___G_c_23_boolean_2d_decl)
#define ___PRM_c_23_boolean_2d_decl ___PRM(291,___G_c_23_boolean_2d_decl)
#define ___GLO_c_23_boolean_2d_declarations ___GLO(292,___G_c_23_boolean_2d_declarations)
#define ___PRM_c_23_boolean_2d_declarations ___PRM(292,___G_c_23_boolean_2d_declarations)
#define ___GLO_c_23_build_2d_c_2d_define ___GLO(293,___G_c_23_build_2d_c_2d_define)
#define ___PRM_c_23_build_2d_c_2d_define ___PRM(293,___G_c_23_build_2d_c_2d_define)
#define ___GLO_c_23_c_2d_declaration_2d_body ___GLO(294,___G_c_23_c_2d_declaration_2d_body)
#define ___PRM_c_23_c_2d_declaration_2d_body ___PRM(294,___G_c_23_c_2d_declaration_2d_body)
#define ___GLO_c_23_c_2d_definition_2d_name ___GLO(295,___G_c_23_c_2d_definition_2d_name)
#define ___PRM_c_23_c_2d_definition_2d_name ___PRM(295,___G_c_23_c_2d_definition_2d_name)
#define ___GLO_c_23_c_2d_definition_2d_param_2d_types ___GLO(296,___G_c_23_c_2d_definition_2d_param_2d_types)
#define ___PRM_c_23_c_2d_definition_2d_param_2d_types ___PRM(296,___G_c_23_c_2d_definition_2d_param_2d_types)
#define ___GLO_c_23_c_2d_definition_2d_proc_2d_name ___GLO(297,___G_c_23_c_2d_definition_2d_proc_2d_name)
#define ___PRM_c_23_c_2d_definition_2d_proc_2d_name ___PRM(297,___G_c_23_c_2d_definition_2d_proc_2d_name)
#define ___GLO_c_23_c_2d_definition_2d_result_2d_type ___GLO(298,___G_c_23_c_2d_definition_2d_result_2d_type)
#define ___PRM_c_23_c_2d_definition_2d_result_2d_type ___PRM(298,___G_c_23_c_2d_definition_2d_result_2d_type)
#define ___GLO_c_23_c_2d_definition_2d_scope ___GLO(299,___G_c_23_c_2d_definition_2d_scope)
#define ___PRM_c_23_c_2d_definition_2d_scope ___PRM(299,___G_c_23_c_2d_definition_2d_scope)
#define ___GLO_c_23_c_2d_definition_2d_value ___GLO(300,___G_c_23_c_2d_definition_2d_value)
#define ___PRM_c_23_c_2d_definition_2d_value ___PRM(300,___G_c_23_c_2d_definition_2d_value)
#define ___GLO_c_23_c_2d_initialization_2d_body ___GLO(301,___G_c_23_c_2d_initialization_2d_body)
#define ___PRM_c_23_c_2d_initialization_2d_body ___PRM(301,___G_c_23_c_2d_initialization_2d_body)
#define ___GLO_c_23_c_2d_interface_2d_begin ___GLO(302,___G_c_23_c_2d_interface_2d_begin)
#define ___PRM_c_23_c_2d_interface_2d_begin ___PRM(302,___G_c_23_c_2d_interface_2d_begin)
#define ___GLO_c_23_c_2d_interface_2d_end ___GLO(303,___G_c_23_c_2d_interface_2d_end)
#define ___PRM_c_23_c_2d_interface_2d_end ___PRM(303,___G_c_23_c_2d_interface_2d_end)
#define ___GLO_c_23_c_2d_type_2d_definition_2d_name ___GLO(304,___G_c_23_c_2d_type_2d_definition_2d_name)
#define ___PRM_c_23_c_2d_type_2d_definition_2d_name ___PRM(304,___G_c_23_c_2d_type_2d_definition_2d_name)
#define ___GLO_c_23_c_2d_type_2d_definition_2d_type ___GLO(305,___G_c_23_c_2d_type_2d_definition_2d_type)
#define ___PRM_c_23_c_2d_type_2d_definition_2d_type ___PRM(305,___G_c_23_c_2d_type_2d_definition_2d_type)
#define ___GLO_c_23_compiler_2d_internal_2d_error ___GLO(306,___G_c_23_compiler_2d_internal_2d_error)
#define ___PRM_c_23_compiler_2d_internal_2d_error ___PRM(306,___G_c_23_compiler_2d_internal_2d_error)
#define ___GLO_c_23_compiler_2d_option_2d_debug ___GLO(307,___G_c_23_compiler_2d_option_2d_debug)
#define ___PRM_c_23_compiler_2d_option_2d_debug ___PRM(307,___G_c_23_compiler_2d_option_2d_debug)
#define ___GLO_c_23_compiler_2d_option_2d_debug_2d_environments ___GLO(308,___G_c_23_compiler_2d_option_2d_debug_2d_environments)
#define ___PRM_c_23_compiler_2d_option_2d_debug_2d_environments ___PRM(308,___G_c_23_compiler_2d_option_2d_debug_2d_environments)
#define ___GLO_c_23_compiler_2d_option_2d_debug_2d_location ___GLO(309,___G_c_23_compiler_2d_option_2d_debug_2d_location)
#define ___PRM_c_23_compiler_2d_option_2d_debug_2d_location ___PRM(309,___G_c_23_compiler_2d_option_2d_debug_2d_location)
#define ___GLO_c_23_compiler_2d_option_2d_debug_2d_source ___GLO(310,___G_c_23_compiler_2d_option_2d_debug_2d_source)
#define ___PRM_c_23_compiler_2d_option_2d_debug_2d_source ___PRM(310,___G_c_23_compiler_2d_option_2d_debug_2d_source)
#define ___GLO_c_23_compiler_2d_user_2d_error ___GLO(311,___G_c_23_compiler_2d_user_2d_error)
#define ___PRM_c_23_compiler_2d_user_2d_error ___PRM(311,___G_c_23_compiler_2d_user_2d_error)
#define ___GLO_c_23_compiler_2d_user_2d_warning ___GLO(312,___G_c_23_compiler_2d_user_2d_warning)
#define ___PRM_c_23_compiler_2d_user_2d_warning ___PRM(312,___G_c_23_compiler_2d_user_2d_warning)
#define ___GLO_c_23_constant_2d_fold_2d_sym ___GLO(313,___G_c_23_constant_2d_fold_2d_sym)
#define ___PRM_c_23_constant_2d_fold_2d_sym ___PRM(313,___G_c_23_constant_2d_fold_2d_sym)
#define ___GLO_c_23_core_2d_sym ___GLO(314,___G_c_23_core_2d_sym)
#define ___PRM_c_23_core_2d_sym ___PRM(314,___G_c_23_core_2d_sym)
#define ___GLO_c_23_debug_2d_environments_2d_sym ___GLO(315,___G_c_23_debug_2d_environments_2d_sym)
#define ___PRM_c_23_debug_2d_environments_2d_sym ___PRM(315,___G_c_23_debug_2d_environments_2d_sym)
#define ___GLO_c_23_debug_2d_location_2d_sym ___GLO(316,___G_c_23_debug_2d_location_2d_sym)
#define ___PRM_c_23_debug_2d_location_2d_sym ___PRM(316,___G_c_23_debug_2d_location_2d_sym)
#define ___GLO_c_23_debug_2d_source_2d_sym ___GLO(317,___G_c_23_debug_2d_source_2d_sym)
#define ___PRM_c_23_debug_2d_source_2d_sym ___PRM(317,___G_c_23_debug_2d_source_2d_sym)
#define ___GLO_c_23_debug_2d_sym ___GLO(318,___G_c_23_debug_2d_sym)
#define ___PRM_c_23_debug_2d_sym ___PRM(318,___G_c_23_debug_2d_sym)
#define ___GLO_c_23_declaration_2d_value ___GLO(319,___G_c_23_declaration_2d_value)
#define ___PRM_c_23_declaration_2d_value ___PRM(319,___G_c_23_declaration_2d_value)
#define ___GLO_c_23_define_2d_boolean_2d_decl ___GLO(320,___G_c_23_define_2d_boolean_2d_decl)
#define ___PRM_c_23_define_2d_boolean_2d_decl ___PRM(320,___G_c_23_define_2d_boolean_2d_decl)
#define ___GLO_c_23_define_2d_flag_2d_decl ___GLO(321,___G_c_23_define_2d_flag_2d_decl)
#define ___PRM_c_23_define_2d_flag_2d_decl ___PRM(321,___G_c_23_define_2d_flag_2d_decl)
#define ___GLO_c_23_define_2d_namable_2d_boolean_2d_decl ___GLO(322,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
#define ___PRM_c_23_define_2d_namable_2d_boolean_2d_decl ___PRM(322,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
#define ___GLO_c_23_define_2d_parameterized_2d_decl ___GLO(323,___G_c_23_define_2d_parameterized_2d_decl)
#define ___PRM_c_23_define_2d_parameterized_2d_decl ___PRM(323,___G_c_23_define_2d_parameterized_2d_decl)
#define ___GLO_c_23_else_2d_sym ___GLO(324,___G_c_23_else_2d_sym)
#define ___PRM_c_23_else_2d_sym ___PRM(324,___G_c_23_else_2d_sym)
#define ___GLO_c_23_end_2d_of_2d_file_2d_object_3f_ ___GLO(325,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___PRM_c_23_end_2d_of_2d_file_2d_object_3f_ ___PRM(325,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___GLO_c_23_env_2d_declare ___GLO(326,___G_c_23_env_2d_declare)
#define ___PRM_c_23_env_2d_declare ___PRM(326,___G_c_23_env_2d_declare)
#define ___GLO_c_23_env_2d_define_2d_var ___GLO(327,___G_c_23_env_2d_define_2d_var)
#define ___PRM_c_23_env_2d_define_2d_var ___PRM(327,___G_c_23_env_2d_define_2d_var)
#define ___GLO_c_23_env_2d_frame ___GLO(328,___G_c_23_env_2d_frame)
#define ___PRM_c_23_env_2d_frame ___PRM(328,___G_c_23_env_2d_frame)
#define ___GLO_c_23_env_2d_global_2d_variables ___GLO(329,___G_c_23_env_2d_global_2d_variables)
#define ___PRM_c_23_env_2d_global_2d_variables ___PRM(329,___G_c_23_env_2d_global_2d_variables)
#define ___GLO_c_23_env_2d_lookup_2d_global_2d_var ___GLO(330,___G_c_23_env_2d_lookup_2d_global_2d_var)
#define ___PRM_c_23_env_2d_lookup_2d_global_2d_var ___PRM(330,___G_c_23_env_2d_lookup_2d_global_2d_var)
#define ___GLO_c_23_env_2d_lookup_2d_macro ___GLO(331,___G_c_23_env_2d_lookup_2d_macro)
#define ___PRM_c_23_env_2d_lookup_2d_macro ___PRM(331,___G_c_23_env_2d_lookup_2d_macro)
#define ___GLO_c_23_env_2d_lookup_2d_var ___GLO(332,___G_c_23_env_2d_lookup_2d_var)
#define ___PRM_c_23_env_2d_lookup_2d_var ___PRM(332,___G_c_23_env_2d_lookup_2d_var)
#define ___GLO_c_23_env_2d_macro ___GLO(333,___G_c_23_env_2d_macro)
#define ___PRM_c_23_env_2d_macro ___PRM(333,___G_c_23_env_2d_macro)
#define ___GLO_c_23_env_2d_namespace ___GLO(334,___G_c_23_env_2d_namespace)
#define ___PRM_c_23_env_2d_namespace ___PRM(334,___G_c_23_env_2d_namespace)
#define ___GLO_c_23_environment_2d_map_2d_sym ___GLO(335,___G_c_23_environment_2d_map_2d_sym)
#define ___PRM_c_23_environment_2d_map_2d_sym ___PRM(335,___G_c_23_environment_2d_map_2d_sym)
#define ___GLO_c_23_expression_2d__3e_source ___GLO(336,___G_c_23_expression_2d__3e_source)
#define ___PRM_c_23_expression_2d__3e_source ___PRM(336,___G_c_23_expression_2d__3e_source)
#define ___GLO_c_23_extended_2d_bindings_2d_sym ___GLO(337,___G_c_23_extended_2d_bindings_2d_sym)
#define ___PRM_c_23_extended_2d_bindings_2d_sym ___PRM(337,___G_c_23_extended_2d_bindings_2d_sym)
#define ___GLO_c_23_false_2d_object ___GLO(338,___G_c_23_false_2d_object)
#define ___PRM_c_23_false_2d_object ___PRM(338,___G_c_23_false_2d_object)
#define ___GLO_c_23_false_2d_object_3f_ ___GLO(339,___G_c_23_false_2d_object_3f_)
#define ___PRM_c_23_false_2d_object_3f_ ___PRM(339,___G_c_23_false_2d_object_3f_)
#define ___GLO_c_23_flag_2d_decl ___GLO(340,___G_c_23_flag_2d_decl)
#define ___PRM_c_23_flag_2d_decl ___PRM(340,___G_c_23_flag_2d_decl)
#define ___GLO_c_23_flag_2d_declarations ___GLO(341,___G_c_23_flag_2d_declarations)
#define ___PRM_c_23_flag_2d_declarations ___PRM(341,___G_c_23_flag_2d_declarations)
#define ___GLO_c_23_gambit_2d_scheme_2d_sym ___GLO(342,___G_c_23_gambit_2d_scheme_2d_sym)
#define ___PRM_c_23_gambit_2d_scheme_2d_sym ___PRM(342,___G_c_23_gambit_2d_scheme_2d_sym)
#define ___GLO_c_23_ieee_2d_scheme_2d_sym ___GLO(343,___G_c_23_ieee_2d_scheme_2d_sym)
#define ___PRM_c_23_ieee_2d_scheme_2d_sym ___PRM(343,___G_c_23_ieee_2d_scheme_2d_sym)
#define ___GLO_c_23_include_2d_expr_2d__3e_source ___GLO(344,___G_c_23_include_2d_expr_2d__3e_source)
#define ___PRM_c_23_include_2d_expr_2d__3e_source ___PRM(344,___G_c_23_include_2d_expr_2d__3e_source)
#define ___GLO_c_23_inline_2d_primitives_2d_sym ___GLO(345,___G_c_23_inline_2d_primitives_2d_sym)
#define ___PRM_c_23_inline_2d_primitives_2d_sym ___PRM(345,___G_c_23_inline_2d_primitives_2d_sym)
#define ___GLO_c_23_inline_2d_sym ___GLO(346,___G_c_23_inline_2d_sym)
#define ___PRM_c_23_inline_2d_sym ___PRM(346,___G_c_23_inline_2d_sym)
#define ___GLO_c_23_inlining_2d_limit_2d_sym ___GLO(347,___G_c_23_inlining_2d_limit_2d_sym)
#define ___PRM_c_23_inlining_2d_limit_2d_sym ___PRM(347,___G_c_23_inlining_2d_limit_2d_sym)
#define ___GLO_c_23_interrupts_2d_enabled_2d_sym ___GLO(348,___G_c_23_interrupts_2d_enabled_2d_sym)
#define ___PRM_c_23_interrupts_2d_enabled_2d_sym ___PRM(348,___G_c_23_interrupts_2d_enabled_2d_sym)
#define ___GLO_c_23_keep ___GLO(349,___G_c_23_keep)
#define ___PRM_c_23_keep ___PRM(349,___G_c_23_keep)
#define ___GLO_c_23_key_2d_object_3f_ ___GLO(350,___G_c_23_key_2d_object_3f_)
#define ___PRM_c_23_key_2d_object_3f_ ___PRM(350,___G_c_23_key_2d_object_3f_)
#define ___GLO_c_23_keyword_2d_object_3f_ ___GLO(351,___G_c_23_keyword_2d_object_3f_)
#define ___PRM_c_23_keyword_2d_object_3f_ ___PRM(351,___G_c_23_keyword_2d_object_3f_)
#define ___GLO_c_23_lambda_2d_lift_2d_sym ___GLO(352,___G_c_23_lambda_2d_lift_2d_sym)
#define ___PRM_c_23_lambda_2d_lift_2d_sym ___PRM(352,___G_c_23_lambda_2d_lift_2d_sym)
#define ___GLO_c_23_lambda_2d_sym ___GLO(353,___G_c_23_lambda_2d_sym)
#define ___PRM_c_23_lambda_2d_sym ___PRM(353,___G_c_23_lambda_2d_sym)
#define ___GLO_c_23_list_2d__3e_varset ___GLO(354,___G_c_23_list_2d__3e_varset)
#define ___PRM_c_23_list_2d__3e_varset ___PRM(354,___G_c_23_list_2d__3e_varset)
#define ___GLO_c_23_list_2d__3e_vect ___GLO(355,___G_c_23_list_2d__3e_vect)
#define ___PRM_c_23_list_2d__3e_vect ___PRM(355,___G_c_23_list_2d__3e_vect)
#define ___GLO_c_23_make_2d_counter ___GLO(356,___G_c_23_make_2d_counter)
#define ___PRM_c_23_make_2d_counter ___PRM(356,___G_c_23_make_2d_counter)
#define ___GLO_c_23_make_2d_gnode ___GLO(357,___G_c_23_make_2d_gnode)
#define ___PRM_c_23_make_2d_gnode ___PRM(357,___G_c_23_make_2d_gnode)
#define ___GLO_c_23_multilisp_2d_sym ___GLO(358,___G_c_23_multilisp_2d_sym)
#define ___PRM_c_23_multilisp_2d_sym ___PRM(358,___G_c_23_multilisp_2d_sym)
#define ___GLO_c_23_namable_2d_boolean_2d_decl ___GLO(359,___G_c_23_namable_2d_boolean_2d_decl)
#define ___PRM_c_23_namable_2d_boolean_2d_decl ___PRM(359,___G_c_23_namable_2d_boolean_2d_decl)
#define ___GLO_c_23_namable_2d_boolean_2d_declarations ___GLO(360,___G_c_23_namable_2d_boolean_2d_declarations)
#define ___PRM_c_23_namable_2d_boolean_2d_declarations ___PRM(360,___G_c_23_namable_2d_boolean_2d_declarations)
#define ___GLO_c_23_namable_2d_decl ___GLO(361,___G_c_23_namable_2d_decl)
#define ___PRM_c_23_namable_2d_decl ___PRM(361,___G_c_23_namable_2d_decl)
#define ___GLO_c_23_namable_2d_declarations ___GLO(362,___G_c_23_namable_2d_declarations)
#define ___PRM_c_23_namable_2d_declarations ___PRM(362,___G_c_23_namable_2d_declarations)
#define ___GLO_c_23_next_2d_var_2d_stamp ___GLO(363,___G_c_23_next_2d_var_2d_stamp)
#define ___PRM_c_23_next_2d_var_2d_stamp ___PRM(363,___G_c_23_next_2d_var_2d_stamp)
#define ___GLO_c_23_not_2d_sym ___GLO(364,___G_c_23_not_2d_sym)
#define ___PRM_c_23_not_2d_sym ___PRM(364,___G_c_23_not_2d_sym)
#define ___GLO_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym ___GLO(365,___G_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym)
#define ___PRM_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym ___PRM(365,___G_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym)
#define ___GLO_c_23_optional_2d_object_3f_ ___GLO(366,___G_c_23_optional_2d_object_3f_)
#define ___PRM_c_23_optional_2d_object_3f_ ___PRM(366,___G_c_23_optional_2d_object_3f_)
#define ___GLO_c_23_pair_2d_up ___GLO(367,___G_c_23_pair_2d_up)
#define ___PRM_c_23_pair_2d_up ___PRM(367,___G_c_23_pair_2d_up)
#define ___GLO_c_23_parameterized_2d_decl ___GLO(368,___G_c_23_parameterized_2d_decl)
#define ___PRM_c_23_parameterized_2d_decl ___PRM(368,___G_c_23_parameterized_2d_decl)
#define ___GLO_c_23_parameterized_2d_declarations ___GLO(369,___G_c_23_parameterized_2d_declarations)
#define ___PRM_c_23_parameterized_2d_declarations ___PRM(369,___G_c_23_parameterized_2d_declarations)
#define ___GLO_c_23_pattern_2d_member_3f_ ___GLO(370,___G_c_23_pattern_2d_member_3f_)
#define ___PRM_c_23_pattern_2d_member_3f_ ___PRM(370,___G_c_23_pattern_2d_member_3f_)
#define ___GLO_c_23_proc_2d_obj_2d_call_2d_pat ___GLO(371,___G_c_23_proc_2d_obj_2d_call_2d_pat)
#define ___PRM_c_23_proc_2d_obj_2d_call_2d_pat ___PRM(371,___G_c_23_proc_2d_obj_2d_call_2d_pat)
#define ___GLO_c_23_proc_2d_obj_2d_specialize ___GLO(372,___G_c_23_proc_2d_obj_2d_specialize)
#define ___PRM_c_23_proc_2d_obj_2d_specialize ___PRM(372,___G_c_23_proc_2d_obj_2d_specialize)
#define ___GLO_c_23_proc_2d_obj_2d_standard ___GLO(373,___G_c_23_proc_2d_obj_2d_standard)
#define ___PRM_c_23_proc_2d_obj_2d_standard ___PRM(373,___G_c_23_proc_2d_obj_2d_standard)
#define ___GLO_c_23_proc_2d_obj_3f_ ___GLO(374,___G_c_23_proc_2d_obj_3f_)
#define ___PRM_c_23_proc_2d_obj_3f_ ___PRM(374,___G_c_23_proc_2d_obj_3f_)
#define ___GLO_c_23_proper_2d_tail_2d_calls_2d_sym ___GLO(375,___G_c_23_proper_2d_tail_2d_calls_2d_sym)
#define ___PRM_c_23_proper_2d_tail_2d_calls_2d_sym ___PRM(375,___G_c_23_proper_2d_tail_2d_calls_2d_sym)
#define ___GLO_c_23_pt_2d_c_2d_lambda ___GLO(376,___G_c_23_pt_2d_c_2d_lambda)
#define ___PRM_c_23_pt_2d_c_2d_lambda ___PRM(376,___G_c_23_pt_2d_c_2d_lambda)
#define ___GLO_c_23_ptset_2d__3e_list ___GLO(377,___G_c_23_ptset_2d__3e_list)
#define ___PRM_c_23_ptset_2d__3e_list ___PRM(377,___G_c_23_ptset_2d__3e_list)
#define ___GLO_c_23_ptset_2d_adjoin ___GLO(378,___G_c_23_ptset_2d_adjoin)
#define ___PRM_c_23_ptset_2d_adjoin ___PRM(378,___G_c_23_ptset_2d_adjoin)
#define ___GLO_c_23_ptset_2d_empty ___GLO(379,___G_c_23_ptset_2d_empty)
#define ___PRM_c_23_ptset_2d_empty ___PRM(379,___G_c_23_ptset_2d_empty)
#define ___GLO_c_23_ptset_2d_empty_3f_ ___GLO(380,___G_c_23_ptset_2d_empty_3f_)
#define ___PRM_c_23_ptset_2d_empty_3f_ ___PRM(380,___G_c_23_ptset_2d_empty_3f_)
#define ___GLO_c_23_quasiquote_2d_sym ___GLO(381,___G_c_23_quasiquote_2d_sym)
#define ___PRM_c_23_quasiquote_2d_sym ___PRM(381,___G_c_23_quasiquote_2d_sym)
#define ___GLO_c_23_r4rs_2d_scheme_2d_sym ___GLO(382,___G_c_23_r4rs_2d_scheme_2d_sym)
#define ___PRM_c_23_r4rs_2d_scheme_2d_sym ___PRM(382,___G_c_23_r4rs_2d_scheme_2d_sym)
#define ___GLO_c_23_r5rs_2d_scheme_2d_sym ___GLO(383,___G_c_23_r5rs_2d_scheme_2d_sym)
#define ___PRM_c_23_r5rs_2d_scheme_2d_sym ___PRM(383,___G_c_23_r5rs_2d_scheme_2d_sym)
#define ___GLO_c_23_rest_2d_object_3f_ ___GLO(384,___G_c_23_rest_2d_object_3f_)
#define ___PRM_c_23_rest_2d_object_3f_ ___PRM(384,___G_c_23_rest_2d_object_3f_)
#define ___GLO_c_23_run_2d_time_2d_bindings_2d_sym ___GLO(385,___G_c_23_run_2d_time_2d_bindings_2d_sym)
#define ___PRM_c_23_run_2d_time_2d_bindings_2d_sym ___PRM(385,___G_c_23_run_2d_time_2d_bindings_2d_sym)
#define ___GLO_c_23_safe_2d_sym ___GLO(386,___G_c_23_safe_2d_sym)
#define ___PRM_c_23_safe_2d_sym ___PRM(386,___G_c_23_safe_2d_sym)
#define ___GLO_c_23_scheme_2d_global_2d_eval ___GLO(387,___G_c_23_scheme_2d_global_2d_eval)
#define ___PRM_c_23_scheme_2d_global_2d_eval ___PRM(387,___G_c_23_scheme_2d_global_2d_eval)
#define ___GLO_c_23_separate_2d_sym ___GLO(388,___G_c_23_separate_2d_sym)
#define ___PRM_c_23_separate_2d_sym ___PRM(388,___G_c_23_separate_2d_sym)
#define ___GLO_c_23_source_2d__3e_expression ___GLO(389,___G_c_23_source_2d__3e_expression)
#define ___PRM_c_23_source_2d__3e_expression ___PRM(389,___G_c_23_source_2d__3e_expression)
#define ___GLO_c_23_source_2d_code ___GLO(390,___G_c_23_source_2d_code)
#define ___PRM_c_23_source_2d_code ___PRM(390,___G_c_23_source_2d_code)
#define ___GLO_c_23_standard_2d_bindings_2d_sym ___GLO(391,___G_c_23_standard_2d_bindings_2d_sym)
#define ___PRM_c_23_standard_2d_bindings_2d_sym ___PRM(391,___G_c_23_standard_2d_bindings_2d_sym)
#define ___GLO_c_23_string_2d__3e_keyword_2d_object ___GLO(392,___G_c_23_string_2d__3e_keyword_2d_object)
#define ___PRM_c_23_string_2d__3e_keyword_2d_object ___PRM(392,___G_c_23_string_2d__3e_keyword_2d_object)
#define ___GLO_c_23_symbol_2d_object_3f_ ___GLO(393,___G_c_23_symbol_2d_object_3f_)
#define ___PRM_c_23_symbol_2d_object_3f_ ___PRM(393,___G_c_23_symbol_2d_object_3f_)
#define ___GLO_c_23_target_2e_prim_2d_info ___GLO(394,___G_c_23_target_2e_prim_2d_info)
#define ___PRM_c_23_target_2e_prim_2d_info ___PRM(394,___G_c_23_target_2e_prim_2d_info)
#define ___GLO_c_23_topological_2d_sort ___GLO(395,___G_c_23_topological_2d_sort)
#define ___PRM_c_23_topological_2d_sort ___PRM(395,___G_c_23_topological_2d_sort)
#define ___GLO_c_23_transitive_2d_closure ___GLO(396,___G_c_23_transitive_2d_closure)
#define ___PRM_c_23_transitive_2d_closure ___PRM(396,___G_c_23_transitive_2d_closure)
#define ___GLO_c_23_unbound1_2d_object_3f_ ___GLO(397,___G_c_23_unbound1_2d_object_3f_)
#define ___PRM_c_23_unbound1_2d_object_3f_ ___PRM(397,___G_c_23_unbound1_2d_object_3f_)
#define ___GLO_c_23_unbound2_2d_object_3f_ ___GLO(398,___G_c_23_unbound2_2d_object_3f_)
#define ___PRM_c_23_unbound2_2d_object_3f_ ___PRM(398,___G_c_23_unbound2_2d_object_3f_)
#define ___GLO_c_23_unquote_2d_splicing_2d_sym ___GLO(399,___G_c_23_unquote_2d_splicing_2d_sym)
#define ___PRM_c_23_unquote_2d_splicing_2d_sym ___PRM(399,___G_c_23_unquote_2d_splicing_2d_sym)
#define ___GLO_c_23_unquote_2d_sym ___GLO(400,___G_c_23_unquote_2d_sym)
#define ___PRM_c_23_unquote_2d_sym ___PRM(400,___G_c_23_unquote_2d_sym)
#define ___GLO_c_23_valid_2d_prefix_3f_ ___GLO(401,___G_c_23_valid_2d_prefix_3f_)
#define ___PRM_c_23_valid_2d_prefix_3f_ ___PRM(401,___G_c_23_valid_2d_prefix_3f_)
#define ___GLO_c_23_var_2d_name ___GLO(402,___G_c_23_var_2d_name)
#define ___PRM_c_23_var_2d_name ___PRM(402,___G_c_23_var_2d_name)
#define ___GLO_c_23_var_2d_tag ___GLO(403,___G_c_23_var_2d_tag)
#define ___PRM_c_23_var_2d_tag ___PRM(403,___G_c_23_var_2d_tag)
#define ___GLO_c_23_varset_2d__3e_list ___GLO(404,___G_c_23_varset_2d__3e_list)
#define ___PRM_c_23_varset_2d__3e_list ___PRM(404,___G_c_23_varset_2d__3e_list)
#define ___GLO_c_23_varset_2d_adjoin ___GLO(405,___G_c_23_varset_2d_adjoin)
#define ___PRM_c_23_varset_2d_adjoin ___PRM(405,___G_c_23_varset_2d_adjoin)
#define ___GLO_c_23_varset_2d_difference ___GLO(406,___G_c_23_varset_2d_difference)
#define ___PRM_c_23_varset_2d_difference ___PRM(406,___G_c_23_varset_2d_difference)
#define ___GLO_c_23_varset_2d_intersection ___GLO(407,___G_c_23_varset_2d_intersection)
#define ___PRM_c_23_varset_2d_intersection ___PRM(407,___G_c_23_varset_2d_intersection)
#define ___GLO_c_23_varset_2d_intersects_3f_ ___GLO(408,___G_c_23_varset_2d_intersects_3f_)
#define ___PRM_c_23_varset_2d_intersects_3f_ ___PRM(408,___G_c_23_varset_2d_intersects_3f_)
#define ___GLO_c_23_varset_2d_union_2d_multi ___GLO(409,___G_c_23_varset_2d_union_2d_multi)
#define ___PRM_c_23_varset_2d_union_2d_multi ___PRM(409,___G_c_23_varset_2d_union_2d_multi)
#define ___GLO_c_23_vect_2d__3e_list ___GLO(410,___G_c_23_vect_2d__3e_list)
#define ___PRM_c_23_vect_2d__3e_list ___PRM(410,___G_c_23_vect_2d__3e_list)
#define ___GLO_c_23_vector_2d_object_3f_ ___GLO(411,___G_c_23_vector_2d_object_3f_)
#define ___PRM_c_23_vector_2d_object_3f_ ___PRM(411,___G_c_23_vector_2d_object_3f_)
#define ___GLO_c_23_void_2d_object ___GLO(412,___G_c_23_void_2d_object)
#define ___PRM_c_23_void_2d_object ___PRM(412,___G_c_23_void_2d_object)
#define ___GLO_c_23_void_2d_object_3f_ ___GLO(413,___G_c_23_void_2d_object_3f_)
#define ___PRM_c_23_void_2d_object_3f_ ___PRM(413,___G_c_23_void_2d_object_3f_)
#define ___GLO_c_23_warnings_2d_sym ___GLO(414,___G_c_23_warnings_2d_sym)
#define ___PRM_c_23_warnings_2d_sym ___PRM(414,___G_c_23_warnings_2d_sym)
#define ___GLO_display ___GLO(415,___G_display)
#define ___PRM_display ___PRM(415,___G_display)
#define ___GLO_exact_3f_ ___GLO(416,___G_exact_3f_)
#define ___PRM_exact_3f_ ___PRM(416,___G_exact_3f_)
#define ___GLO_length ___GLO(417,___G_length)
#define ___PRM_length ___PRM(417,___G_length)
#define ___GLO_list_2d_ref ___GLO(418,___G_list_2d_ref)
#define ___PRM_list_2d_ref ___PRM(418,___G_list_2d_ref)
#define ___GLO_newline ___GLO(419,___G_newline)
#define ___PRM_newline ___PRM(419,___G_newline)
#define ___GLO_number_2d__3e_string ___GLO(420,___G_number_2d__3e_string)
#define ___PRM_number_2d__3e_string ___PRM(420,___G_number_2d__3e_string)
#define ___GLO_reverse ___GLO(421,___G_reverse)
#define ___PRM_reverse ___PRM(421,___G_reverse)
#define ___GLO_string_2d__3e_symbol ___GLO(422,___G_string_2d__3e_symbol)
#define ___PRM_string_2d__3e_symbol ___PRM(422,___G_string_2d__3e_symbol)
#define ___GLO_string_2d_append ___GLO(423,___G_string_2d_append)
#define ___PRM_string_2d_append ___PRM(423,___G_string_2d_append)
#define ___GLO_substring ___GLO(424,___G_substring)
#define ___PRM_substring ___PRM(424,___G_substring)
#define ___GLO_symbol_2d__3e_string ___GLO(425,___G_symbol_2d__3e_string)
#define ___PRM_symbol_2d__3e_string ___PRM(425,___G_symbol_2d__3e_string)
#define ___GLO_write ___GLO(426,___G_write)
#define ___PRM_write ___PRM(426,___G_write)

___DEF_SUB_STR(___X0,28)
               ___STR8(115,101,116,45,118,97,108,44)
               ___STR8(32,39,115,101,116,39,32,110)
               ___STR8(111,100,101,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X1,28)
               ___STR8(100,101,102,45,118,97,108,44)
               ___STR8(32,39,100,101,102,39,32,110)
               ___STR8(111,100,101,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X2,28)
               ___STR8(116,115,116,45,112,114,101,44)
               ___STR8(32,39,116,115,116,39,32,110)
               ___STR8(111,100,101,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X3,28)
               ___STR8(116,115,116,45,99,111,110,44)
               ___STR8(32,39,116,115,116,39,32,110)
               ___STR8(111,100,101,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X4,28)
               ___STR8(116,115,116,45,97,108,116,44)
               ___STR8(32,39,116,115,116,39,32,110)
               ___STR8(111,100,101,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X5,30)
               ___STR8(99,111,110,106,45,112,114,101)
               ___STR8(44,32,39,99,111,110,106,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X6,30)
               ___STR8(99,111,110,106,45,97,108,116)
               ___STR8(44,32,39,99,111,110,106,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X7,30)
               ___STR8(100,105,115,106,45,112,114,101)
               ___STR8(44,32,39,100,105,115,106,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X8,30)
               ___STR8(100,105,115,106,45,97,108,116)
               ___STR8(44,32,39,100,105,115,106,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X9,30)
               ___STR8(112,114,99,45,98,111,100,121)
               ___STR8(44,32,39,112,114,111,99,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X10,30)
               ___STR8(97,112,112,45,111,112,101,114)
               ___STR8(44,32,39,99,97,108,108,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X11,30)
               ___STR8(97,112,112,45,97,114,103,115)
               ___STR8(44,32,39,99,97,108,108,39)
               ___STR8(32,110,111,100,101,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X12,28)
               ___STR8(102,117,116,45,118,97,108,44)
               ___STR8(32,39,102,117,116,39,32,110)
               ___STR8(111,100,101,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X13,1)
               ___STR1(46)
___DEF_SUB_STR(___X14,9)
               ___STR8(32,32,34,109,97,99,114,111)
               ___STR1(34)
___DEF_SUB_STR(___X15,2)
               ___STR2(32,32)
___DEF_SUB_STR(___X16,11)
               ___STR8(32,32,34,100,101,99,108,97)
               ___STR3(114,101,34)
___DEF_SUB_STR(___X17,13)
               ___STR8(32,32,34,110,97,109,101,115)
               ___STR5(112,97,99,101,34)
___DEF_SUB_STR(___X18,8)
               ___STR8(32,32,34,101,120,112,114,34)
               ___STR0
___DEF_SUB_STR(___X19,2)
               ___STR2(32,32)
___DEF_SUB_STR(___X20,16)
               ___STR8(32,32,34,99,45,105,110,105)
               ___STR8(116,105,97,108,105,122,101,34)
               ___STR0
___DEF_SUB_STR(___X21,13)
               ___STR8(32,32,34,99,45,100,101,99)
               ___STR5(108,97,114,101,34)
___DEF_SUB_STR(___X22,17)
               ___STR8(32,32,34,99,45,100,101,102)
               ___STR8(105,110,101,45,116,121,112,101)
               ___STR1(34)
___DEF_SUB_STR(___X23,2)
               ___STR2(32,32)
___DEF_SUB_STR(___X24,8)
               ___STR8(80,97,114,115,105,110,103,58)
               ___STR0
___DEF_SUB_STR(___X25,41)
               ___STR8(77,111,114,101,32,116,104,97)
               ___STR8(110,32,111,110,101,32,39,100)
               ___STR8(101,102,105,110,101,39,32,111)
               ___STR8(102,32,103,108,111,98,97,108)
               ___STR8(32,118,97,114,105,97,98,108)
               ___STR1(101)
___DEF_SUB_STR(___X26,19)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,100,101,102,105)
               ___STR3(110,101,39)
___DEF_SUB_STR(___X27,21)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,101,120,112,114,101)
               ___STR5(115,115,105,111,110)
___DEF_SUB_STR(___X28,25)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,100,101,102,105)
               ___STR8(110,101,45,109,97,99,114,111)
               ___STR1(39)
___DEF_SUB_STR(___X29,26)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,100,101,102,105)
               ___STR8(110,101,45,115,121,110,116,97)
               ___STR2(120,39)
___DEF_SUB_STR(___X30,20)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,105,110,99,108)
               ___STR4(117,100,101,39)
___DEF_SUB_STR(___X31,20)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,100,101,99,108)
               ___STR4(97,114,101,39)
___DEF_SUB_STR(___X32,22)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,110,97,109,101)
               ___STR6(115,112,97,99,101,39)
___DEF_SUB_STR(___X33,26)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,99,45,100,101)
               ___STR8(102,105,110,101,45,116,121,112)
               ___STR2(101,39)
___DEF_SUB_STR(___X34,22)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,99,45,100,101)
               ___STR6(99,108,97,114,101,39)
___DEF_SUB_STR(___X35,25)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,99,45,105,110)
               ___STR8(105,116,105,97,108,105,122,101)
               ___STR1(39)
___DEF_SUB_STR(___X36,21)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,99,45,100,101)
               ___STR5(102,105,110,101,39)
___DEF_SUB_STR(___X37,29)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,39,117,110,113,117)
               ___STR8(111,116,101,45,115,112,108,105)
               ___STR5(99,105,110,103,39)
___DEF_SUB_STR(___X38,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X39,21)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,35,33,111,112,116)
               ___STR5(105,111,110,97,108)
___DEF_SUB_STR(___X40,38)
               ___STR8(35,33,114,101,115,116,32,109)
               ___STR8(117,115,116,32,98,101,32,102)
               ___STR8(111,108,108,111,119,101,100,32)
               ___STR8(98,121,32,97,32,112,97,114)
               ___STR6(97,109,101,116,101,114)
___DEF_SUB_STR(___X41,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X42,37)
               ___STR8(68,117,112,108,105,99,97,116)
               ___STR8(101,32,112,97,114,97,109,101)
               ___STR8(116,101,114,32,105,110,32,112)
               ___STR8(97,114,97,109,101,116,101,114)
               ___STR5(32,108,105,115,116)
___DEF_SUB_STR(___X43,42)
               ___STR8(68,117,112,108,105,99,97,116)
               ___STR8(101,32,114,101,115,116,32,112)
               ___STR8(97,114,97,109,101,116,101,114)
               ___STR8(32,105,110,32,112,97,114,97)
               ___STR8(109,101,116,101,114,32,108,105)
               ___STR2(115,116)
___DEF_SUB_STR(___X44,27)
               ___STR8(82,101,115,116,32,112,97,114)
               ___STR8(97,109,101,116,101,114,32,109)
               ___STR8(117,115,116,32,98,101,32,108)
               ___STR3(97,115,116)
___DEF_SUB_STR(___X45,35)
               ___STR8(35,33,107,101,121,32,101,120)
               ___STR8(112,101,99,116,101,100,32,97)
               ___STR8(102,116,101,114,32,114,101,115)
               ___STR8(116,32,112,97,114,97,109,101)
               ___STR3(116,101,114)
___DEF_SUB_STR(___X46,26)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,102,97,117)
               ___STR8(108,116,32,98,105,110,100,105)
               ___STR2(110,103)
___DEF_SUB_STR(___X47,26)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,100,101,102,97,117)
               ___STR8(108,116,32,98,105,110,100,105)
               ___STR2(110,103)
___DEF_SUB_STR(___X48,50)
               ___STR8(80,97,114,97,109,101,116,101)
               ___STR8(114,32,109,117,115,116,32,98)
               ___STR8(101,32,97,110,32,105,100,101)
               ___STR8(110,116,105,102,105,101,114,32)
               ___STR8(111,114,32,100,101,102,97,117)
               ___STR8(108,116,32,98,105,110,100,105)
               ___STR2(110,103)
___DEF_SUB_STR(___X49,16)
               ___STR8(73,108,108,45,112,108,97,99)
               ___STR8(101,100,32,35,33,107,101,121)
               ___STR0
___DEF_SUB_STR(___X50,41)
               ___STR8(66,111,100,121,32,109,117,115)
               ___STR8(116,32,99,111,110,116,97,105)
               ___STR8(110,32,97,116,32,108,101,97)
               ___STR8(115,116,32,111,110,101,32,101)
               ___STR8(120,112,114,101,115,115,105,111)
               ___STR1(110)
___DEF_SUB_STR(___X51,2)
               ___STR2(32,32)
___DEF_SUB_STR(___X52,39)
               ___STR8(77,97,99,114,111,32,110,97)
               ___STR8(109,101,32,99,97,110,39,116)
               ___STR8(32,98,101,32,117,115,101,100)
               ___STR8(32,97,115,32,97,32,118,97)
               ___STR7(114,105,97,98,108,101,58)
___DEF_SUB_STR(___X53,25)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,112,114,111,99,101)
               ___STR8(100,117,114,101,32,99,97,108)
               ___STR1(108)
___DEF_SUB_STR(___X54,25)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,112,114,111,99,101)
               ___STR8(100,117,114,101,32,99,97,108)
               ___STR1(108)
___DEF_SUB_STR(___X55,17)
               ___STR8(70,105,108,101,110,97,109,101)
               ___STR8(32,101,120,112,101,99,116,101)
               ___STR1(100)
___DEF_SUB_STR(___X56,24)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,115,112,101,99,105)
               ___STR8(97,108,32,102,111,114,109,58)
               ___STR0
___DEF_SUB_STR(___X57,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X58,24)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,39,99,111,110,100)
               ___STR8(39,32,99,108,97,117,115,101)
               ___STR0
___DEF_SUB_STR(___X59,44)
               ___STR8(39,61,62,39,32,109,117,115)
               ___STR8(116,32,98,101,32,102,111,108)
               ___STR8(108,111,119,101,100,32,98,121)
               ___STR8(32,97,32,115,105,110,103,108)
               ___STR8(101,32,101,120,112,114,101,115)
               ___STR4(115,105,111,110)
___DEF_SUB_STR(___X60,24)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,39,99,111,110,100)
               ___STR8(39,32,99,108,97,117,115,101)
               ___STR0
___DEF_SUB_STR(___X61,28)
               ___STR8(69,108,115,101,32,99,108,97)
               ___STR8(117,115,101,32,109,117,115,116)
               ___STR8(32,104,97,118,101,32,97,32)
               ___STR4(98,111,100,121)
___DEF_SUB_STR(___X62,24)
               ___STR8(69,108,115,101,32,99,108,97)
               ___STR8(117,115,101,32,109,117,115,116)
               ___STR8(32,98,101,32,108,97,115,116)
               ___STR0
___DEF_SUB_STR(___X63,24)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,39,99,97,115,101)
               ___STR8(39,32,99,108,97,117,115,101)
               ___STR0
___DEF_SUB_STR(___X64,24)
               ___STR8(69,108,115,101,32,99,108,97)
               ___STR8(117,115,101,32,109,117,115,116)
               ___STR8(32,98,101,32,108,97,115,116)
               ___STR0
___DEF_SUB_STR(___X65,52)
               ___STR8(65,32,39,99,97,115,101,39)
               ___STR8(32,99,108,97,117,115,101,32)
               ___STR8(109,117,115,116,32,104,97,118)
               ___STR8(101,32,97,32,115,101,108,101)
               ___STR8(99,116,111,114,32,108,105,115)
               ___STR8(116,32,97,110,100,32,97,32)
               ___STR4(98,111,100,121)
___DEF_SUB_STR(___X66,24)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,115,101,108,101,99)
               ___STR8(116,111,114,32,108,105,115,116)
               ___STR0
___DEF_SUB_STR(___X67,47)
               ___STR8(83,101,108,101,99,116,111,114)
               ___STR8(32,108,105,115,116,32,109,117)
               ___STR8(115,116,32,99,111,110,116,97)
               ___STR8(105,110,32,97,116,32,108,101)
               ___STR8(97,115,116,32,111,110,101,32)
               ___STR7(101,108,101,109,101,110,116)
___DEF_SUB_STR(___X68,18)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,98,105,110,100,105)
               ___STR2(110,103)
___DEF_SUB_STR(___X69,30)
               ___STR8(68,117,112,108,105,99,97,116)
               ___STR8(101,32,118,97,114,105,97,98)
               ___STR8(108,101,32,105,110,32,98,105)
               ___STR6(110,100,105,110,103,115)
___DEF_SUB_STR(___X70,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X71,23)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,98,105,110,100,105)
               ___STR7(110,103,32,108,105,115,116)
___DEF_SUB_STR(___X72,18)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,98,105,110,100,105)
               ___STR2(110,103)
___DEF_SUB_STR(___X73,30)
               ___STR8(68,117,112,108,105,99,97,116)
               ___STR8(101,32,118,97,114,105,97,98)
               ___STR8(108,101,32,105,110,32,98,105)
               ___STR6(110,100,105,110,103,115)
___DEF_SUB_STR(___X74,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X75,23)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,98,105,110,100,105)
               ___STR7(110,103,32,108,105,115,116)
___DEF_SUB_STR(___X76,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,101,120,105,116,32)
               ___STR6(99,108,97,117,115,101)
___DEF_SUB_STR(___X77,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,99,108,97)
               ___STR6(114,97,116,105,111,110)
___DEF_SUB_STR(___X78,22)
               ___STR8(69,120,97,99,116,32,105,110)
               ___STR8(116,101,103,101,114,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X79,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,99,108,97)
               ___STR6(114,97,116,105,111,110)
___DEF_SUB_STR(___X80,38)
               ___STR8(68,101,99,108,97,114,97,116)
               ___STR8(105,111,110,32,110,97,109,101)
               ___STR8(32,109,117,115,116,32,98,101)
               ___STR8(32,97,110,32,105,100,101,110)
               ___STR6(116,105,102,105,101,114)
___DEF_SUB_STR(___X81,19)
               ___STR8(85,110,107,110,111,119,110,32)
               ___STR8(100,101,99,108,97,114,97,116)
               ___STR3(105,111,110)
___DEF_SUB_STR(___X82,28)
               ___STR8(68,101,99,108,97,114,97,116)
               ___STR8(105,111,110,32,99,97,110,39)
               ___STR8(116,32,98,101,32,110,101,103)
               ___STR4(97,116,101,100)
___DEF_SUB_STR(___X83,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,99,108,97)
               ___STR6(114,97,116,105,111,110)
___DEF_SUB_STR(___X84,28)
               ___STR8(68,101,99,108,97,114,97,116)
               ___STR8(105,111,110,32,99,97,110,39)
               ___STR8(116,32,98,101,32,110,101,103)
               ___STR4(97,116,101,100)
___DEF_SUB_STR(___X85,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,99,108,97)
               ___STR6(114,97,116,105,111,110)
___DEF_SUB_STR(___X86,28)
               ___STR8(68,101,99,108,97,114,97,116)
               ___STR8(105,111,110,32,99,97,110,39)
               ___STR8(116,32,98,101,32,110,101,103)
               ___STR4(97,116,101,100)
___DEF_SUB_STR(___X87,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,99,108,97)
               ___STR6(114,97,116,105,111,110)
___DEF_SUB_STR(___X88,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X89,22)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,100,101,99,108,97)
               ___STR6(114,97,116,105,111,110)
___DEF_SUB_STR(___X90,20)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,110,97,109,101,115)
               ___STR4(112,97,99,101)
___DEF_SUB_STR(___X91,19)
               ___STR8(73,100,101,110,116,105,102,105)
               ___STR8(101,114,32,101,120,112,101,99)
               ___STR3(116,101,100)
___DEF_SUB_STR(___X92,17)
               ___STR8(73,108,108,101,103,97,108,32)
               ___STR8(110,97,109,101,115,112,97,99)
               ___STR1(101)
___DEF_SUB_STR(___X93,20)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,110,97,109,101,115)
               ___STR4(112,97,99,101)
___DEF_SUB_STR(___X94,20)
               ___STR8(73,108,108,45,102,111,114,109)
               ___STR8(101,100,32,110,97,109,101,115)
               ___STR4(112,97,99,101)
___DEF_SUB_STR(___X95,34)
               ___STR8(77,97,99,114,111,32,101,120)
               ___STR8(112,97,110,100,101,114,32,109)
               ___STR8(117,115,116,32,98,101,32,97)
               ___STR8(32,112,114,111,99,101,100,117)
               ___STR2(114,101)
___DEF_SUB_STR(___X96,39)
               ___STR8(77,97,99,114,111,32,118,97)
               ___STR8(108,117,101,32,109,117,115,116)
               ___STR8(32,98,101,32,97,32,108,97)
               ___STR8(109,98,100,97,32,101,120,112)
               ___STR7(114,101,115,115,105,111,110)
___DEF_SUB_STR(___X97,15)
               ___STR8(40,105,110,32,109,97,99,114)
               ___STR7(111,32,98,111,100,121,41)

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
,___DEF_SUB(___X83)
,___DEF_SUB(___X84)
,___DEF_SUB(___X85)
,___DEF_SUB(___X86)
,___DEF_SUB(___X87)
,___DEF_SUB(___X88)
,___DEF_SUB(___X89)
,___DEF_SUB(___X90)
,___DEF_SUB(___X91)
,___DEF_SUB(___X92)
,___DEF_SUB(___X93)
,___DEF_SUB(___X94)
,___DEF_SUB(___X95)
,___DEF_SUB(___X96)
,___DEF_SUB(___X97)
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
___DEF_M_HLBL(___L0__20___ptree1)
___DEF_M_HLBL(___L1__20___ptree1)
___DEF_M_HLBL(___L2__20___ptree1)
___DEF_M_HLBL(___L3__20___ptree1)
___DEF_M_HLBL(___L4__20___ptree1)
___DEF_M_HLBL(___L5__20___ptree1)
___DEF_M_HLBL(___L6__20___ptree1)
___DEF_M_HLBL(___L7__20___ptree1)
___DEF_M_HLBL(___L8__20___ptree1)
___DEF_M_HLBL(___L9__20___ptree1)
___DEF_M_HLBL(___L10__20___ptree1)
___DEF_M_HLBL(___L11__20___ptree1)
___DEF_M_HLBL(___L12__20___ptree1)
___DEF_M_HLBL(___L13__20___ptree1)
___DEF_M_HLBL(___L14__20___ptree1)
___DEF_M_HLBL(___L15__20___ptree1)
___DEF_M_HLBL(___L16__20___ptree1)
___DEF_M_HLBL(___L17__20___ptree1)
___DEF_M_HLBL(___L18__20___ptree1)
___DEF_M_HLBL(___L19__20___ptree1)
___DEF_M_HLBL(___L20__20___ptree1)
___DEF_M_HLBL(___L21__20___ptree1)
___DEF_M_HLBL(___L22__20___ptree1)
___DEF_M_HLBL(___L23__20___ptree1)
___DEF_M_HLBL(___L24__20___ptree1)
___DEF_M_HLBL(___L25__20___ptree1)
___DEF_M_HLBL(___L26__20___ptree1)
___DEF_M_HLBL(___L27__20___ptree1)
___DEF_M_HLBL(___L28__20___ptree1)
___DEF_M_HLBL(___L29__20___ptree1)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_parent)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_children)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_fv)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_bfv)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_env)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_stamp)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_parent_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_fv_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_bfv_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_env_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_source_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_stamp_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_cst)
___DEF_M_HLBL(___L1_c_23_make_2d_cst)
___DEF_M_HLBL(___L2_c_23_make_2d_cst)
___DEF_M_HLBL(___L3_c_23_make_2d_cst)
___DEF_M_HLBL(___L4_c_23_make_2d_cst)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_cst_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_cst_2d_val)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_cst_2d_val_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_ref)
___DEF_M_HLBL(___L1_c_23_make_2d_ref)
___DEF_M_HLBL(___L2_c_23_make_2d_ref)
___DEF_M_HLBL(___L3_c_23_make_2d_ref)
___DEF_M_HLBL(___L4_c_23_make_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_var_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_set)
___DEF_M_HLBL(___L1_c_23_make_2d_set)
___DEF_M_HLBL(___L2_c_23_make_2d_set)
___DEF_M_HLBL(___L3_c_23_make_2d_set)
___DEF_M_HLBL(___L4_c_23_make_2d_set)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_set_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_set_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_set_2d_var_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_def)
___DEF_M_HLBL(___L1_c_23_make_2d_def)
___DEF_M_HLBL(___L2_c_23_make_2d_def)
___DEF_M_HLBL(___L3_c_23_make_2d_def)
___DEF_M_HLBL(___L4_c_23_make_2d_def)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_def_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_def_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_def_2d_var_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_tst)
___DEF_M_HLBL(___L1_c_23_make_2d_tst)
___DEF_M_HLBL(___L2_c_23_make_2d_tst)
___DEF_M_HLBL(___L3_c_23_make_2d_tst)
___DEF_M_HLBL(___L4_c_23_make_2d_tst)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_tst_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_conj)
___DEF_M_HLBL(___L1_c_23_make_2d_conj)
___DEF_M_HLBL(___L2_c_23_make_2d_conj)
___DEF_M_HLBL(___L3_c_23_make_2d_conj)
___DEF_M_HLBL(___L4_c_23_make_2d_conj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_conj_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_disj)
___DEF_M_HLBL(___L1_c_23_make_2d_disj)
___DEF_M_HLBL(___L2_c_23_make_2d_disj)
___DEF_M_HLBL(___L3_c_23_make_2d_disj)
___DEF_M_HLBL(___L4_c_23_make_2d_disj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_disj_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_prc)
___DEF_M_HLBL(___L1_c_23_make_2d_prc)
___DEF_M_HLBL(___L2_c_23_make_2d_prc)
___DEF_M_HLBL(___L3_c_23_make_2d_prc)
___DEF_M_HLBL(___L4_c_23_make_2d_prc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_c_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_parms)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_opts)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_keys)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_rest_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_name_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_c_2d_name_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_parms_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_opts_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_keys_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_rest_3f__2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_app)
___DEF_M_HLBL(___L1_c_23_make_2d_app)
___DEF_M_HLBL(___L2_c_23_make_2d_app)
___DEF_M_HLBL(___L3_c_23_make_2d_app)
___DEF_M_HLBL(___L4_c_23_make_2d_app)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_app_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_fut)
___DEF_M_HLBL(___L1_c_23_make_2d_fut)
___DEF_M_HLBL(___L2_c_23_make_2d_fut)
___DEF_M_HLBL(___L3_c_23_make_2d_fut)
___DEF_M_HLBL(___L4_c_23_make_2d_fut)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_fut_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_children_2d_set_21_)
___DEF_M_HLBL(___L1_c_23_node_2d_children_2d_set_21_)
___DEF_M_HLBL(___L2_c_23_node_2d_children_2d_set_21_)
___DEF_M_HLBL(___L3_c_23_node_2d_children_2d_set_21_)
___DEF_M_HLBL(___L4_c_23_node_2d_children_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_M_HLBL(___L1_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_M_HLBL(___L2_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_cst)
___DEF_M_HLBL(___L1_c_23_new_2d_cst)
___DEF_M_HLBL(___L2_c_23_new_2d_cst)
___DEF_M_HLBL(___L3_c_23_new_2d_cst)
___DEF_M_HLBL(___L4_c_23_new_2d_cst)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_ref)
___DEF_M_HLBL(___L1_c_23_new_2d_ref)
___DEF_M_HLBL(___L2_c_23_new_2d_ref)
___DEF_M_HLBL(___L3_c_23_new_2d_ref)
___DEF_M_HLBL(___L4_c_23_new_2d_ref)
___DEF_M_HLBL(___L5_c_23_new_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_M_HLBL(___L1_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_M_HLBL(___L2_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_M_HLBL(___L3_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_M_HLBL(___L4_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_set)
___DEF_M_HLBL(___L1_c_23_new_2d_set)
___DEF_M_HLBL(___L2_c_23_new_2d_set)
___DEF_M_HLBL(___L3_c_23_new_2d_set)
___DEF_M_HLBL(___L4_c_23_new_2d_set)
___DEF_M_HLBL(___L5_c_23_new_2d_set)
___DEF_M_HLBL(___L6_c_23_new_2d_set)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_set_2d_val)
___DEF_M_HLBL(___L1_c_23_set_2d_val)
___DEF_M_HLBL(___L2_c_23_set_2d_val)
___DEF_M_HLBL(___L3_c_23_set_2d_val)
___DEF_M_HLBL(___L4_c_23_set_2d_val)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_def)
___DEF_M_HLBL(___L1_c_23_new_2d_def)
___DEF_M_HLBL(___L2_c_23_new_2d_def)
___DEF_M_HLBL(___L3_c_23_new_2d_def)
___DEF_M_HLBL(___L4_c_23_new_2d_def)
___DEF_M_HLBL(___L5_c_23_new_2d_def)
___DEF_M_HLBL(___L6_c_23_new_2d_def)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_def_2d_val)
___DEF_M_HLBL(___L1_c_23_def_2d_val)
___DEF_M_HLBL(___L2_c_23_def_2d_val)
___DEF_M_HLBL(___L3_c_23_def_2d_val)
___DEF_M_HLBL(___L4_c_23_def_2d_val)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_tst)
___DEF_M_HLBL(___L1_c_23_new_2d_tst)
___DEF_M_HLBL(___L2_c_23_new_2d_tst)
___DEF_M_HLBL(___L3_c_23_new_2d_tst)
___DEF_M_HLBL(___L4_c_23_new_2d_tst)
___DEF_M_HLBL(___L5_c_23_new_2d_tst)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_tst_2d_pre)
___DEF_M_HLBL(___L1_c_23_tst_2d_pre)
___DEF_M_HLBL(___L2_c_23_tst_2d_pre)
___DEF_M_HLBL(___L3_c_23_tst_2d_pre)
___DEF_M_HLBL(___L4_c_23_tst_2d_pre)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_tst_2d_con)
___DEF_M_HLBL(___L1_c_23_tst_2d_con)
___DEF_M_HLBL(___L2_c_23_tst_2d_con)
___DEF_M_HLBL(___L3_c_23_tst_2d_con)
___DEF_M_HLBL(___L4_c_23_tst_2d_con)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_tst_2d_alt)
___DEF_M_HLBL(___L1_c_23_tst_2d_alt)
___DEF_M_HLBL(___L2_c_23_tst_2d_alt)
___DEF_M_HLBL(___L3_c_23_tst_2d_alt)
___DEF_M_HLBL(___L4_c_23_tst_2d_alt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_conj)
___DEF_M_HLBL(___L1_c_23_new_2d_conj)
___DEF_M_HLBL(___L2_c_23_new_2d_conj)
___DEF_M_HLBL(___L3_c_23_new_2d_conj)
___DEF_M_HLBL(___L4_c_23_new_2d_conj)
___DEF_M_HLBL(___L5_c_23_new_2d_conj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_conj_2d_pre)
___DEF_M_HLBL(___L1_c_23_conj_2d_pre)
___DEF_M_HLBL(___L2_c_23_conj_2d_pre)
___DEF_M_HLBL(___L3_c_23_conj_2d_pre)
___DEF_M_HLBL(___L4_c_23_conj_2d_pre)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_conj_2d_alt)
___DEF_M_HLBL(___L1_c_23_conj_2d_alt)
___DEF_M_HLBL(___L2_c_23_conj_2d_alt)
___DEF_M_HLBL(___L3_c_23_conj_2d_alt)
___DEF_M_HLBL(___L4_c_23_conj_2d_alt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_disj)
___DEF_M_HLBL(___L1_c_23_new_2d_disj)
___DEF_M_HLBL(___L2_c_23_new_2d_disj)
___DEF_M_HLBL(___L3_c_23_new_2d_disj)
___DEF_M_HLBL(___L4_c_23_new_2d_disj)
___DEF_M_HLBL(___L5_c_23_new_2d_disj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_disj_2d_pre)
___DEF_M_HLBL(___L1_c_23_disj_2d_pre)
___DEF_M_HLBL(___L2_c_23_disj_2d_pre)
___DEF_M_HLBL(___L3_c_23_disj_2d_pre)
___DEF_M_HLBL(___L4_c_23_disj_2d_pre)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_disj_2d_alt)
___DEF_M_HLBL(___L1_c_23_disj_2d_alt)
___DEF_M_HLBL(___L2_c_23_disj_2d_alt)
___DEF_M_HLBL(___L3_c_23_disj_2d_alt)
___DEF_M_HLBL(___L4_c_23_disj_2d_alt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_prc)
___DEF_M_HLBL(___L1_c_23_new_2d_prc)
___DEF_M_HLBL(___L2_c_23_new_2d_prc)
___DEF_M_HLBL(___L3_c_23_new_2d_prc)
___DEF_M_HLBL(___L4_c_23_new_2d_prc)
___DEF_M_HLBL(___L5_c_23_new_2d_prc)
___DEF_M_HLBL(___L6_c_23_new_2d_prc)
___DEF_M_HLBL(___L7_c_23_new_2d_prc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_body)
___DEF_M_HLBL(___L1_c_23_prc_2d_body)
___DEF_M_HLBL(___L2_c_23_prc_2d_body)
___DEF_M_HLBL(___L3_c_23_prc_2d_body)
___DEF_M_HLBL(___L4_c_23_prc_2d_body)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_call)
___DEF_M_HLBL(___L1_c_23_new_2d_call)
___DEF_M_HLBL(___L2_c_23_new_2d_call)
___DEF_M_HLBL(___L3_c_23_new_2d_call)
___DEF_M_HLBL(___L4_c_23_new_2d_call)
___DEF_M_HLBL(___L5_c_23_new_2d_call)
___DEF_M_HLBL(___L6_c_23_new_2d_call)
___DEF_M_HLBL(___L7_c_23_new_2d_call)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_call_2a_)
___DEF_M_HLBL(___L1_c_23_new_2d_call_2a_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_app_2d_oper)
___DEF_M_HLBL(___L1_c_23_app_2d_oper)
___DEF_M_HLBL(___L2_c_23_app_2d_oper)
___DEF_M_HLBL(___L3_c_23_app_2d_oper)
___DEF_M_HLBL(___L4_c_23_app_2d_oper)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_app_2d_args)
___DEF_M_HLBL(___L1_c_23_app_2d_args)
___DEF_M_HLBL(___L2_c_23_app_2d_args)
___DEF_M_HLBL(___L3_c_23_app_2d_args)
___DEF_M_HLBL(___L4_c_23_app_2d_args)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_oper_2d_pos_3f_)
___DEF_M_HLBL(___L1_c_23_oper_2d_pos_3f_)
___DEF_M_HLBL(___L2_c_23_oper_2d_pos_3f_)
___DEF_M_HLBL(___L3_c_23_oper_2d_pos_3f_)
___DEF_M_HLBL(___L4_c_23_oper_2d_pos_3f_)
___DEF_M_HLBL(___L5_c_23_oper_2d_pos_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_fut)
___DEF_M_HLBL(___L1_c_23_new_2d_fut)
___DEF_M_HLBL(___L2_c_23_new_2d_fut)
___DEF_M_HLBL(___L3_c_23_new_2d_fut)
___DEF_M_HLBL(___L4_c_23_new_2d_fut)
___DEF_M_HLBL(___L5_c_23_new_2d_fut)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_fut_2d_val)
___DEF_M_HLBL(___L1_c_23_fut_2d_val)
___DEF_M_HLBL(___L2_c_23_fut_2d_val)
___DEF_M_HLBL(___L3_c_23_fut_2d_val)
___DEF_M_HLBL(___L4_c_23_fut_2d_val)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L1_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L2_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L3_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L4_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L5_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L6_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L7_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L8_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L9_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L10_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L11_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L12_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L13_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L14_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L15_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL(___L16_c_23_new_2d_disj_2d_call)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_seq)
___DEF_M_HLBL(___L1_c_23_new_2d_seq)
___DEF_M_HLBL(___L2_c_23_new_2d_seq)
___DEF_M_HLBL(___L3_c_23_new_2d_seq)
___DEF_M_HLBL(___L4_c_23_new_2d_seq)
___DEF_M_HLBL(___L5_c_23_new_2d_seq)
___DEF_M_HLBL(___L6_c_23_new_2d_seq)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_let)
___DEF_M_HLBL(___L1_c_23_new_2d_let)
___DEF_M_HLBL(___L2_c_23_new_2d_let)
___DEF_M_HLBL(___L3_c_23_new_2d_let)
___DEF_M_HLBL(___L4_c_23_new_2d_let)
___DEF_M_HLBL(___L5_c_23_new_2d_let)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L1_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L2_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L3_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L4_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L5_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L6_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L7_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L8_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L9_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L10_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL(___L11_c_23_new_2d_temp_2d_variable)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_variables)
___DEF_M_HLBL(___L1_c_23_new_2d_variables)
___DEF_M_HLBL(___L2_c_23_new_2d_variables)
___DEF_M_HLBL(___L3_c_23_new_2d_variables)
___DEF_M_HLBL(___L4_c_23_new_2d_variables)
___DEF_M_HLBL(___L5_c_23_new_2d_variables)
___DEF_M_HLBL(___L6_c_23_new_2d_variables)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_new_2d_variable)
___DEF_M_HLBL(___L1_c_23_new_2d_variable)
___DEF_M_HLBL(___L2_c_23_new_2d_variable)
___DEF_M_HLBL(___L3_c_23_new_2d_variable)
___DEF_M_HLBL(___L4_c_23_new_2d_variable)
___DEF_M_HLBL(___L5_c_23_new_2d_variable)
___DEF_M_HLBL(___L6_c_23_new_2d_variable)
___DEF_M_HLBL(___L7_c_23_new_2d_variable)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_set_2d_prc_2d_names_21_)
___DEF_M_HLBL(___L1_c_23_set_2d_prc_2d_names_21_)
___DEF_M_HLBL(___L2_c_23_set_2d_prc_2d_names_21_)
___DEF_M_HLBL(___L3_c_23_set_2d_prc_2d_names_21_)
___DEF_M_HLBL(___L4_c_23_set_2d_prc_2d_names_21_)
___DEF_M_HLBL(___L5_c_23_set_2d_prc_2d_names_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_free_2d_variables)
___DEF_M_HLBL(___L1_c_23_free_2d_variables)
___DEF_M_HLBL(___L2_c_23_free_2d_variables)
___DEF_M_HLBL(___L3_c_23_free_2d_variables)
___DEF_M_HLBL(___L4_c_23_free_2d_variables)
___DEF_M_HLBL(___L5_c_23_free_2d_variables)
___DEF_M_HLBL(___L6_c_23_free_2d_variables)
___DEF_M_HLBL(___L7_c_23_free_2d_variables)
___DEF_M_HLBL(___L8_c_23_free_2d_variables)
___DEF_M_HLBL(___L9_c_23_free_2d_variables)
___DEF_M_HLBL(___L10_c_23_free_2d_variables)
___DEF_M_HLBL(___L11_c_23_free_2d_variables)
___DEF_M_HLBL(___L12_c_23_free_2d_variables)
___DEF_M_HLBL(___L13_c_23_free_2d_variables)
___DEF_M_HLBL(___L14_c_23_free_2d_variables)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL(___L1_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL(___L2_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL(___L3_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL(___L4_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL(___L5_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL(___L6_c_23_bound_2d_free_2d_variables)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bound_2d_variables)
___DEF_M_HLBL(___L1_c_23_bound_2d_variables)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_mutable_3f_)
___DEF_M_HLBL(___L1_c_23_mutable_3f_)
___DEF_M_HLBL(___L2_c_23_mutable_3f_)
___DEF_M_HLBL(___L3_c_23_mutable_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bound_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_global_3f_)
___DEF_M_HLBL(___L1_c_23_global_3f_)
___DEF_M_HLBL(___L2_c_23_global_3f_)
___DEF_M_HLBL(___L3_c_23_global_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L1_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L2_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L3_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L4_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L5_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L6_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L7_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L8_c_23_global_2d_single_2d_def)
___DEF_M_HLBL(___L9_c_23_global_2d_single_2d_def)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_global_2d_proc_2d_obj)
___DEF_M_HLBL(___L1_c_23_global_2d_proc_2d_obj)
___DEF_M_HLBL(___L2_c_23_global_2d_proc_2d_obj)
___DEF_M_HLBL(___L3_c_23_global_2d_proc_2d_obj)
___DEF_M_HLBL(___L4_c_23_global_2d_proc_2d_obj)
___DEF_M_HLBL(___L5_c_23_global_2d_proc_2d_obj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_global_2d_singly_2d_bound_3f_)
___DEF_M_HLBL(___L1_c_23_global_2d_singly_2d_bound_3f_)
___DEF_M_HLBL(___L2_c_23_global_2d_singly_2d_bound_3f_)
___DEF_M_HLBL(___L3_c_23_global_2d_singly_2d_bound_3f_)
___DEF_M_HLBL(___L4_c_23_global_2d_singly_2d_bound_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_app_2d__3e_specialized_2d_proc)
___DEF_M_HLBL(___L1_c_23_app_2d__3e_specialized_2d_proc)
___DEF_M_HLBL(___L2_c_23_app_2d__3e_specialized_2d_proc)
___DEF_M_HLBL(___L3_c_23_app_2d__3e_specialized_2d_proc)
___DEF_M_HLBL(___L4_c_23_app_2d__3e_specialized_2d_proc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_specialize_2d_app)
___DEF_M_HLBL(___L1_c_23_specialize_2d_app)
___DEF_M_HLBL(___L2_c_23_specialize_2d_app)
___DEF_M_HLBL(___L3_c_23_specialize_2d_app)
___DEF_M_HLBL(___L4_c_23_specialize_2d_app)
___DEF_M_HLBL(___L5_c_23_specialize_2d_app)
___DEF_M_HLBL(___L6_c_23_specialize_2d_app)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L1_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L2_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L3_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L4_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L5_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L6_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L7_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L8_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L9_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L10_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L11_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L12_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L13_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L14_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L15_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L16_c_23_specialize_2d_proc)
___DEF_M_HLBL(___L17_c_23_specialize_2d_proc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_nb_2d_args_2d_conforms_3f_)
___DEF_M_HLBL(___L1_c_23_nb_2d_args_2d_conforms_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_scheme_2d_dialect)
___DEF_M_HLBL(___L1_c_23_scheme_2d_dialect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_constant_2d_fold_3f_)
___DEF_M_HLBL(___L1_c_23_constant_2d_fold_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_lambda_2d_lift_3f_)
___DEF_M_HLBL(___L1_c_23_lambda_2d_lift_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_inline_3f_)
___DEF_M_HLBL(___L1_c_23_inline_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_inline_2d_primitive_3f_)
___DEF_M_HLBL(___L1_c_23_inline_2d_primitive_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_not_2d_inline_2d_primitives)
___DEF_M_HLBL(___L1_c_23_add_2d_not_2d_inline_2d_primitives)
___DEF_M_HLBL(___L2_c_23_add_2d_not_2d_inline_2d_primitives)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_inlining_2d_limit)
___DEF_M_HLBL(___L1_c_23_inlining_2d_limit)
___DEF_M_HLBL(___L2_c_23_inlining_2d_limit)
___DEF_M_HLBL(___L3_c_23_inlining_2d_limit)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_block_2d_compilation_3f_)
___DEF_M_HLBL(___L1_c_23_block_2d_compilation_3f_)
___DEF_M_HLBL(___L2_c_23_block_2d_compilation_3f_)
___DEF_M_HLBL(___L3_c_23_block_2d_compilation_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_core_3f_)
___DEF_M_HLBL(___L1_c_23_core_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_standard_2d_binding_3f_)
___DEF_M_HLBL(___L1_c_23_standard_2d_binding_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_extended_2d_binding_3f_)
___DEF_M_HLBL(___L1_c_23_extended_2d_binding_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_extended_2d_bindings)
___DEF_M_HLBL(___L1_c_23_add_2d_extended_2d_bindings)
___DEF_M_HLBL(___L2_c_23_add_2d_extended_2d_bindings)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_run_2d_time_2d_binding_3f_)
___DEF_M_HLBL(___L1_c_23_run_2d_time_2d_binding_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_safe_3f_)
___DEF_M_HLBL(___L1_c_23_safe_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_not_2d_safe)
___DEF_M_HLBL(___L1_c_23_add_2d_not_2d_safe)
___DEF_M_HLBL(___L2_c_23_add_2d_not_2d_safe)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_warnings_3f_)
___DEF_M_HLBL(___L1_c_23_warnings_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_intrs_2d_enabled_3f_)
___DEF_M_HLBL(___L1_c_23_intrs_2d_enabled_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_not_2d_interrupts_2d_enabled)
___DEF_M_HLBL(___L1_c_23_add_2d_not_2d_interrupts_2d_enabled)
___DEF_M_HLBL(___L2_c_23_add_2d_not_2d_interrupts_2d_enabled)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_debug_3f_)
___DEF_M_HLBL(___L1_c_23_debug_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_debug_2d_location_3f_)
___DEF_M_HLBL(___L1_c_23_debug_2d_location_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_debug_2d_source_3f_)
___DEF_M_HLBL(___L1_c_23_debug_2d_source_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_debug_2d_environments_3f_)
___DEF_M_HLBL(___L1_c_23_debug_2d_environments_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_environment_2d_map_3f_)
___DEF_M_HLBL(___L1_c_23_environment_2d_map_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_tail_2d_calls_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_tail_2d_calls_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_proper_2d_tail_2d_calls)
___DEF_M_HLBL(___L1_c_23_add_2d_proper_2d_tail_2d_calls)
___DEF_M_HLBL(___L2_c_23_add_2d_proper_2d_tail_2d_calls)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
___DEF_M_HLBL(___L1_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L1_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L2_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L3_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L4_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L5_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L6_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL(___L7_c_23_standard_2d_proc_2d_obj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L1_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L2_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L3_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L4_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L5_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L6_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL(___L7_c_23_standard_2d_procedure_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_parse_2d_program)
___DEF_M_HLBL(___L1_c_23_parse_2d_program)
___DEF_M_HLBL(___L2_c_23_parse_2d_program)
___DEF_M_HLBL(___L3_c_23_parse_2d_program)
___DEF_M_HLBL(___L4_c_23_parse_2d_program)
___DEF_M_HLBL(___L5_c_23_parse_2d_program)
___DEF_M_HLBL(___L6_c_23_parse_2d_program)
___DEF_M_HLBL(___L7_c_23_parse_2d_program)
___DEF_M_HLBL(___L8_c_23_parse_2d_program)
___DEF_M_HLBL(___L9_c_23_parse_2d_program)
___DEF_M_HLBL(___L10_c_23_parse_2d_program)
___DEF_M_HLBL(___L11_c_23_parse_2d_program)
___DEF_M_HLBL(___L12_c_23_parse_2d_program)
___DEF_M_HLBL(___L13_c_23_parse_2d_program)
___DEF_M_HLBL(___L14_c_23_parse_2d_program)
___DEF_M_HLBL(___L15_c_23_parse_2d_program)
___DEF_M_HLBL(___L16_c_23_parse_2d_program)
___DEF_M_HLBL(___L17_c_23_parse_2d_program)
___DEF_M_HLBL(___L18_c_23_parse_2d_program)
___DEF_M_HLBL(___L19_c_23_parse_2d_program)
___DEF_M_HLBL(___L20_c_23_parse_2d_program)
___DEF_M_HLBL(___L21_c_23_parse_2d_program)
___DEF_M_HLBL(___L22_c_23_parse_2d_program)
___DEF_M_HLBL(___L23_c_23_parse_2d_program)
___DEF_M_HLBL(___L24_c_23_parse_2d_program)
___DEF_M_HLBL(___L25_c_23_parse_2d_program)
___DEF_M_HLBL(___L26_c_23_parse_2d_program)
___DEF_M_HLBL(___L27_c_23_parse_2d_program)
___DEF_M_HLBL(___L28_c_23_parse_2d_program)
___DEF_M_HLBL(___L29_c_23_parse_2d_program)
___DEF_M_HLBL(___L30_c_23_parse_2d_program)
___DEF_M_HLBL(___L31_c_23_parse_2d_program)
___DEF_M_HLBL(___L32_c_23_parse_2d_program)
___DEF_M_HLBL(___L33_c_23_parse_2d_program)
___DEF_M_HLBL(___L34_c_23_parse_2d_program)
___DEF_M_HLBL(___L35_c_23_parse_2d_program)
___DEF_M_HLBL(___L36_c_23_parse_2d_program)
___DEF_M_HLBL(___L37_c_23_parse_2d_program)
___DEF_M_HLBL(___L38_c_23_parse_2d_program)
___DEF_M_HLBL(___L39_c_23_parse_2d_program)
___DEF_M_HLBL(___L40_c_23_parse_2d_program)
___DEF_M_HLBL(___L41_c_23_parse_2d_program)
___DEF_M_HLBL(___L42_c_23_parse_2d_program)
___DEF_M_HLBL(___L43_c_23_parse_2d_program)
___DEF_M_HLBL(___L44_c_23_parse_2d_program)
___DEF_M_HLBL(___L45_c_23_parse_2d_program)
___DEF_M_HLBL(___L46_c_23_parse_2d_program)
___DEF_M_HLBL(___L47_c_23_parse_2d_program)
___DEF_M_HLBL(___L48_c_23_parse_2d_program)
___DEF_M_HLBL(___L49_c_23_parse_2d_program)
___DEF_M_HLBL(___L50_c_23_parse_2d_program)
___DEF_M_HLBL(___L51_c_23_parse_2d_program)
___DEF_M_HLBL(___L52_c_23_parse_2d_program)
___DEF_M_HLBL(___L53_c_23_parse_2d_program)
___DEF_M_HLBL(___L54_c_23_parse_2d_program)
___DEF_M_HLBL(___L55_c_23_parse_2d_program)
___DEF_M_HLBL(___L56_c_23_parse_2d_program)
___DEF_M_HLBL(___L57_c_23_parse_2d_program)
___DEF_M_HLBL(___L58_c_23_parse_2d_program)
___DEF_M_HLBL(___L59_c_23_parse_2d_program)
___DEF_M_HLBL(___L60_c_23_parse_2d_program)
___DEF_M_HLBL(___L61_c_23_parse_2d_program)
___DEF_M_HLBL(___L62_c_23_parse_2d_program)
___DEF_M_HLBL(___L63_c_23_parse_2d_program)
___DEF_M_HLBL(___L64_c_23_parse_2d_program)
___DEF_M_HLBL(___L65_c_23_parse_2d_program)
___DEF_M_HLBL(___L66_c_23_parse_2d_program)
___DEF_M_HLBL(___L67_c_23_parse_2d_program)
___DEF_M_HLBL(___L68_c_23_parse_2d_program)
___DEF_M_HLBL(___L69_c_23_parse_2d_program)
___DEF_M_HLBL(___L70_c_23_parse_2d_program)
___DEF_M_HLBL(___L71_c_23_parse_2d_program)
___DEF_M_HLBL(___L72_c_23_parse_2d_program)
___DEF_M_HLBL(___L73_c_23_parse_2d_program)
___DEF_M_HLBL(___L74_c_23_parse_2d_program)
___DEF_M_HLBL(___L75_c_23_parse_2d_program)
___DEF_M_HLBL(___L76_c_23_parse_2d_program)
___DEF_M_HLBL(___L77_c_23_parse_2d_program)
___DEF_M_HLBL(___L78_c_23_parse_2d_program)
___DEF_M_HLBL(___L79_c_23_parse_2d_program)
___DEF_M_HLBL(___L80_c_23_parse_2d_program)
___DEF_M_HLBL(___L81_c_23_parse_2d_program)
___DEF_M_HLBL(___L82_c_23_parse_2d_program)
___DEF_M_HLBL(___L83_c_23_parse_2d_program)
___DEF_M_HLBL(___L84_c_23_parse_2d_program)
___DEF_M_HLBL(___L85_c_23_parse_2d_program)
___DEF_M_HLBL(___L86_c_23_parse_2d_program)
___DEF_M_HLBL(___L87_c_23_parse_2d_program)
___DEF_M_HLBL(___L88_c_23_parse_2d_program)
___DEF_M_HLBL(___L89_c_23_parse_2d_program)
___DEF_M_HLBL(___L90_c_23_parse_2d_program)
___DEF_M_HLBL(___L91_c_23_parse_2d_program)
___DEF_M_HLBL(___L92_c_23_parse_2d_program)
___DEF_M_HLBL(___L93_c_23_parse_2d_program)
___DEF_M_HLBL(___L94_c_23_parse_2d_program)
___DEF_M_HLBL(___L95_c_23_parse_2d_program)
___DEF_M_HLBL(___L96_c_23_parse_2d_program)
___DEF_M_HLBL(___L97_c_23_parse_2d_program)
___DEF_M_HLBL(___L98_c_23_parse_2d_program)
___DEF_M_HLBL(___L99_c_23_parse_2d_program)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L1_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L2_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L3_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L4_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L5_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L6_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L7_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L8_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L9_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L10_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L11_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L12_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L13_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL(___L14_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_syntax_2d_error)
___DEF_M_HLBL(___L1_c_23_pt_2d_syntax_2d_error)
___DEF_M_HLBL(___L2_c_23_pt_2d_syntax_2d_error)
___DEF_M_HLBL(___L3_c_23_pt_2d_syntax_2d_error)
___DEF_M_HLBL(___L4_c_23_pt_2d_syntax_2d_error)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt)
___DEF_M_HLBL(___L1_c_23_pt)
___DEF_M_HLBL(___L2_c_23_pt)
___DEF_M_HLBL(___L3_c_23_pt)
___DEF_M_HLBL(___L4_c_23_pt)
___DEF_M_HLBL(___L5_c_23_pt)
___DEF_M_HLBL(___L6_c_23_pt)
___DEF_M_HLBL(___L7_c_23_pt)
___DEF_M_HLBL(___L8_c_23_pt)
___DEF_M_HLBL(___L9_c_23_pt)
___DEF_M_HLBL(___L10_c_23_pt)
___DEF_M_HLBL(___L11_c_23_pt)
___DEF_M_HLBL(___L12_c_23_pt)
___DEF_M_HLBL(___L13_c_23_pt)
___DEF_M_HLBL(___L14_c_23_pt)
___DEF_M_HLBL(___L15_c_23_pt)
___DEF_M_HLBL(___L16_c_23_pt)
___DEF_M_HLBL(___L17_c_23_pt)
___DEF_M_HLBL(___L18_c_23_pt)
___DEF_M_HLBL(___L19_c_23_pt)
___DEF_M_HLBL(___L20_c_23_pt)
___DEF_M_HLBL(___L21_c_23_pt)
___DEF_M_HLBL(___L22_c_23_pt)
___DEF_M_HLBL(___L23_c_23_pt)
___DEF_M_HLBL(___L24_c_23_pt)
___DEF_M_HLBL(___L25_c_23_pt)
___DEF_M_HLBL(___L26_c_23_pt)
___DEF_M_HLBL(___L27_c_23_pt)
___DEF_M_HLBL(___L28_c_23_pt)
___DEF_M_HLBL(___L29_c_23_pt)
___DEF_M_HLBL(___L30_c_23_pt)
___DEF_M_HLBL(___L31_c_23_pt)
___DEF_M_HLBL(___L32_c_23_pt)
___DEF_M_HLBL(___L33_c_23_pt)
___DEF_M_HLBL(___L34_c_23_pt)
___DEF_M_HLBL(___L35_c_23_pt)
___DEF_M_HLBL(___L36_c_23_pt)
___DEF_M_HLBL(___L37_c_23_pt)
___DEF_M_HLBL(___L38_c_23_pt)
___DEF_M_HLBL(___L39_c_23_pt)
___DEF_M_HLBL(___L40_c_23_pt)
___DEF_M_HLBL(___L41_c_23_pt)
___DEF_M_HLBL(___L42_c_23_pt)
___DEF_M_HLBL(___L43_c_23_pt)
___DEF_M_HLBL(___L44_c_23_pt)
___DEF_M_HLBL(___L45_c_23_pt)
___DEF_M_HLBL(___L46_c_23_pt)
___DEF_M_HLBL(___L47_c_23_pt)
___DEF_M_HLBL(___L48_c_23_pt)
___DEF_M_HLBL(___L49_c_23_pt)
___DEF_M_HLBL(___L50_c_23_pt)
___DEF_M_HLBL(___L51_c_23_pt)
___DEF_M_HLBL(___L52_c_23_pt)
___DEF_M_HLBL(___L53_c_23_pt)
___DEF_M_HLBL(___L54_c_23_pt)
___DEF_M_HLBL(___L55_c_23_pt)
___DEF_M_HLBL(___L56_c_23_pt)
___DEF_M_HLBL(___L57_c_23_pt)
___DEF_M_HLBL(___L58_c_23_pt)
___DEF_M_HLBL(___L59_c_23_pt)
___DEF_M_HLBL(___L60_c_23_pt)
___DEF_M_HLBL(___L61_c_23_pt)
___DEF_M_HLBL(___L62_c_23_pt)
___DEF_M_HLBL(___L63_c_23_pt)
___DEF_M_HLBL(___L64_c_23_pt)
___DEF_M_HLBL(___L65_c_23_pt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_macro_2d_expand)
___DEF_M_HLBL(___L1_c_23_macro_2d_expand)
___DEF_M_HLBL(___L2_c_23_macro_2d_expand)
___DEF_M_HLBL(___L3_c_23_macro_2d_expand)
___DEF_M_HLBL(___L4_c_23_macro_2d_expand)
___DEF_M_HLBL(___L5_c_23_macro_2d_expand)
___DEF_M_HLBL(___L6_c_23_macro_2d_expand)
___DEF_M_HLBL(___L7_c_23_macro_2d_expand)
___DEF_M_HLBL(___L8_c_23_macro_2d_expand)
___DEF_M_HLBL(___L9_c_23_macro_2d_expand)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_self_2d_eval)
___DEF_M_HLBL(___L1_c_23_pt_2d_self_2d_eval)
___DEF_M_HLBL(___L2_c_23_pt_2d_self_2d_eval)
___DEF_M_HLBL(___L3_c_23_pt_2d_self_2d_eval)
___DEF_M_HLBL(___L4_c_23_pt_2d_self_2d_eval)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_quote)
___DEF_M_HLBL(___L1_c_23_pt_2d_quote)
___DEF_M_HLBL(___L2_c_23_pt_2d_quote)
___DEF_M_HLBL(___L3_c_23_pt_2d_quote)
___DEF_M_HLBL(___L4_c_23_pt_2d_quote)
___DEF_M_HLBL(___L5_c_23_pt_2d_quote)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_quasiquote)
___DEF_M_HLBL(___L1_c_23_pt_2d_quasiquote)
___DEF_M_HLBL(___L2_c_23_pt_2d_quasiquote)
___DEF_M_HLBL(___L3_c_23_pt_2d_quasiquote)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L1_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L2_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L3_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L4_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L5_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L6_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L7_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L8_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L9_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L10_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L11_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L12_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L13_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L14_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L15_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L16_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L17_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L18_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L19_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L20_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L21_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L22_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL(___L23_c_23_pt_2d_quasiquotation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L1_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L2_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L3_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L4_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L5_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L6_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L7_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L8_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L9_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L10_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L11_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL(___L12_c_23_pt_2d_quasiquotation_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_append_2d_form)
___DEF_M_HLBL(___L1_c_23_append_2d_form)
___DEF_M_HLBL(___L2_c_23_append_2d_form)
___DEF_M_HLBL(___L3_c_23_append_2d_form)
___DEF_M_HLBL(___L4_c_23_append_2d_form)
___DEF_M_HLBL(___L5_c_23_append_2d_form)
___DEF_M_HLBL(___L6_c_23_append_2d_form)
___DEF_M_HLBL(___L7_c_23_append_2d_form)
___DEF_M_HLBL(___L8_c_23_append_2d_form)
___DEF_M_HLBL(___L9_c_23_append_2d_form)
___DEF_M_HLBL(___L10_c_23_append_2d_form)
___DEF_M_HLBL(___L11_c_23_append_2d_form)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_cons_2d_form)
___DEF_M_HLBL(___L1_c_23_cons_2d_form)
___DEF_M_HLBL(___L2_c_23_cons_2d_form)
___DEF_M_HLBL(___L3_c_23_cons_2d_form)
___DEF_M_HLBL(___L4_c_23_cons_2d_form)
___DEF_M_HLBL(___L5_c_23_cons_2d_form)
___DEF_M_HLBL(___L6_c_23_cons_2d_form)
___DEF_M_HLBL(___L7_c_23_cons_2d_form)
___DEF_M_HLBL(___L8_c_23_cons_2d_form)
___DEF_M_HLBL(___L9_c_23_cons_2d_form)
___DEF_M_HLBL(___L10_c_23_cons_2d_form)
___DEF_M_HLBL(___L11_c_23_cons_2d_form)
___DEF_M_HLBL(___L12_c_23_cons_2d_form)
___DEF_M_HLBL(___L13_c_23_cons_2d_form)
___DEF_M_HLBL(___L14_c_23_cons_2d_form)
___DEF_M_HLBL(___L15_c_23_cons_2d_form)
___DEF_M_HLBL(___L16_c_23_cons_2d_form)
___DEF_M_HLBL(___L17_c_23_cons_2d_form)
___DEF_M_HLBL(___L18_c_23_cons_2d_form)
___DEF_M_HLBL(___L19_c_23_cons_2d_form)
___DEF_M_HLBL(___L20_c_23_cons_2d_form)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_vector_2d_form)
___DEF_M_HLBL(___L1_c_23_vector_2d_form)
___DEF_M_HLBL(___L2_c_23_vector_2d_form)
___DEF_M_HLBL(___L3_c_23_vector_2d_form)
___DEF_M_HLBL(___L4_c_23_vector_2d_form)
___DEF_M_HLBL(___L5_c_23_vector_2d_form)
___DEF_M_HLBL(___L6_c_23_vector_2d_form)
___DEF_M_HLBL(___L7_c_23_vector_2d_form)
___DEF_M_HLBL(___L8_c_23_vector_2d_form)
___DEF_M_HLBL(___L9_c_23_vector_2d_form)
___DEF_M_HLBL(___L10_c_23_vector_2d_form)
___DEF_M_HLBL(___L11_c_23_vector_2d_form)
___DEF_M_HLBL(___L12_c_23_vector_2d_form)
___DEF_M_HLBL(___L13_c_23_vector_2d_form)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L1_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L2_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L3_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L4_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L5_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L6_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L7_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L8_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L9_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L10_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L11_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L12_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L13_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L14_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L15_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L16_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L17_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L18_c_23_list_2d_construction_3f_)
___DEF_M_HLBL(___L19_c_23_list_2d_construction_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_var)
___DEF_M_HLBL(___L1_c_23_pt_2d_var)
___DEF_M_HLBL(___L2_c_23_pt_2d_var)
___DEF_M_HLBL(___L3_c_23_pt_2d_var)
___DEF_M_HLBL(___L4_c_23_pt_2d_var)
___DEF_M_HLBL(___L5_c_23_pt_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L1_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L2_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L3_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L4_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L5_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L6_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L7_c_23_pt_2d_set_21_)
___DEF_M_HLBL(___L8_c_23_pt_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L1_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L2_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L3_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L4_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L5_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L6_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L7_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L8_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L9_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L10_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L11_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L12_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L13_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L14_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L15_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L16_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L17_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L18_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L19_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L20_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L21_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L22_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L23_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L24_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L25_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L26_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L27_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L28_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L29_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L30_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L31_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L32_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L33_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L34_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L35_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L36_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L37_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L38_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L39_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L40_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L41_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L42_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L43_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L44_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L45_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L46_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L47_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L48_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L49_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L50_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L51_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L52_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L53_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L54_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L55_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L56_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L57_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L58_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L59_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L60_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L61_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L62_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L63_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L64_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L65_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L66_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L67_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L68_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L69_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L70_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L71_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L72_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L73_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L74_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L75_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L76_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L77_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L78_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L79_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L80_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L81_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L82_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L83_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L84_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L85_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L86_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L87_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L88_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L89_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L90_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L91_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L92_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L93_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L94_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L95_c_23_pt_2d_lambda)
___DEF_M_HLBL(___L96_c_23_pt_2d_lambda)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_parameter_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_parameter_2d_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_parameter_2d_default_2d_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L1_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L2_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L3_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L4_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L5_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L6_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L7_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L8_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L9_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L10_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L11_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L12_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L13_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L14_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L15_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L16_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L17_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L18_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L19_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L20_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L21_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L22_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L23_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L24_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L25_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L26_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L27_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L28_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L29_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L30_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L31_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L32_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L33_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L34_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L35_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L36_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L37_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L38_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L39_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L40_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L41_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L42_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L43_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L44_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L45_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L46_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L47_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L48_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L49_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L50_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L51_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L52_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L53_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L54_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L55_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L56_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L57_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L58_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L59_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L60_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L61_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L62_c_23_extract_2d_parameters)
___DEF_M_HLBL(___L63_c_23_extract_2d_parameters)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_source_2d__3e_parms)
___DEF_M_HLBL(___L1_c_23_source_2d__3e_parms)
___DEF_M_HLBL(___L2_c_23_source_2d__3e_parms)
___DEF_M_HLBL(___L3_c_23_source_2d__3e_parms)
___DEF_M_HLBL(___L4_c_23_source_2d__3e_parms)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_body)
___DEF_M_HLBL(___L1_c_23_pt_2d_body)
___DEF_M_HLBL(___L2_c_23_pt_2d_body)
___DEF_M_HLBL(___L3_c_23_pt_2d_body)
___DEF_M_HLBL(___L4_c_23_pt_2d_body)
___DEF_M_HLBL(___L5_c_23_pt_2d_body)
___DEF_M_HLBL(___L6_c_23_pt_2d_body)
___DEF_M_HLBL(___L7_c_23_pt_2d_body)
___DEF_M_HLBL(___L8_c_23_pt_2d_body)
___DEF_M_HLBL(___L9_c_23_pt_2d_body)
___DEF_M_HLBL(___L10_c_23_pt_2d_body)
___DEF_M_HLBL(___L11_c_23_pt_2d_body)
___DEF_M_HLBL(___L12_c_23_pt_2d_body)
___DEF_M_HLBL(___L13_c_23_pt_2d_body)
___DEF_M_HLBL(___L14_c_23_pt_2d_body)
___DEF_M_HLBL(___L15_c_23_pt_2d_body)
___DEF_M_HLBL(___L16_c_23_pt_2d_body)
___DEF_M_HLBL(___L17_c_23_pt_2d_body)
___DEF_M_HLBL(___L18_c_23_pt_2d_body)
___DEF_M_HLBL(___L19_c_23_pt_2d_body)
___DEF_M_HLBL(___L20_c_23_pt_2d_body)
___DEF_M_HLBL(___L21_c_23_pt_2d_body)
___DEF_M_HLBL(___L22_c_23_pt_2d_body)
___DEF_M_HLBL(___L23_c_23_pt_2d_body)
___DEF_M_HLBL(___L24_c_23_pt_2d_body)
___DEF_M_HLBL(___L25_c_23_pt_2d_body)
___DEF_M_HLBL(___L26_c_23_pt_2d_body)
___DEF_M_HLBL(___L27_c_23_pt_2d_body)
___DEF_M_HLBL(___L28_c_23_pt_2d_body)
___DEF_M_HLBL(___L29_c_23_pt_2d_body)
___DEF_M_HLBL(___L30_c_23_pt_2d_body)
___DEF_M_HLBL(___L31_c_23_pt_2d_body)
___DEF_M_HLBL(___L32_c_23_pt_2d_body)
___DEF_M_HLBL(___L33_c_23_pt_2d_body)
___DEF_M_HLBL(___L34_c_23_pt_2d_body)
___DEF_M_HLBL(___L35_c_23_pt_2d_body)
___DEF_M_HLBL(___L36_c_23_pt_2d_body)
___DEF_M_HLBL(___L37_c_23_pt_2d_body)
___DEF_M_HLBL(___L38_c_23_pt_2d_body)
___DEF_M_HLBL(___L39_c_23_pt_2d_body)
___DEF_M_HLBL(___L40_c_23_pt_2d_body)
___DEF_M_HLBL(___L41_c_23_pt_2d_body)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_sequence)
___DEF_M_HLBL(___L1_c_23_pt_2d_sequence)
___DEF_M_HLBL(___L2_c_23_pt_2d_sequence)
___DEF_M_HLBL(___L3_c_23_pt_2d_sequence)
___DEF_M_HLBL(___L4_c_23_pt_2d_sequence)
___DEF_M_HLBL(___L5_c_23_pt_2d_sequence)
___DEF_M_HLBL(___L6_c_23_pt_2d_sequence)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_if)
___DEF_M_HLBL(___L1_c_23_pt_2d_if)
___DEF_M_HLBL(___L2_c_23_pt_2d_if)
___DEF_M_HLBL(___L3_c_23_pt_2d_if)
___DEF_M_HLBL(___L4_c_23_pt_2d_if)
___DEF_M_HLBL(___L5_c_23_pt_2d_if)
___DEF_M_HLBL(___L6_c_23_pt_2d_if)
___DEF_M_HLBL(___L7_c_23_pt_2d_if)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_cond)
___DEF_M_HLBL(___L1_c_23_pt_2d_cond)
___DEF_M_HLBL(___L2_c_23_pt_2d_cond)
___DEF_M_HLBL(___L3_c_23_pt_2d_cond)
___DEF_M_HLBL(___L4_c_23_pt_2d_cond)
___DEF_M_HLBL(___L5_c_23_pt_2d_cond)
___DEF_M_HLBL(___L6_c_23_pt_2d_cond)
___DEF_M_HLBL(___L7_c_23_pt_2d_cond)
___DEF_M_HLBL(___L8_c_23_pt_2d_cond)
___DEF_M_HLBL(___L9_c_23_pt_2d_cond)
___DEF_M_HLBL(___L10_c_23_pt_2d_cond)
___DEF_M_HLBL(___L11_c_23_pt_2d_cond)
___DEF_M_HLBL(___L12_c_23_pt_2d_cond)
___DEF_M_HLBL(___L13_c_23_pt_2d_cond)
___DEF_M_HLBL(___L14_c_23_pt_2d_cond)
___DEF_M_HLBL(___L15_c_23_pt_2d_cond)
___DEF_M_HLBL(___L16_c_23_pt_2d_cond)
___DEF_M_HLBL(___L17_c_23_pt_2d_cond)
___DEF_M_HLBL(___L18_c_23_pt_2d_cond)
___DEF_M_HLBL(___L19_c_23_pt_2d_cond)
___DEF_M_HLBL(___L20_c_23_pt_2d_cond)
___DEF_M_HLBL(___L21_c_23_pt_2d_cond)
___DEF_M_HLBL(___L22_c_23_pt_2d_cond)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_and)
___DEF_M_HLBL(___L1_c_23_pt_2d_and)
___DEF_M_HLBL(___L2_c_23_pt_2d_and)
___DEF_M_HLBL(___L3_c_23_pt_2d_and)
___DEF_M_HLBL(___L4_c_23_pt_2d_and)
___DEF_M_HLBL(___L5_c_23_pt_2d_and)
___DEF_M_HLBL(___L6_c_23_pt_2d_and)
___DEF_M_HLBL(___L7_c_23_pt_2d_and)
___DEF_M_HLBL(___L8_c_23_pt_2d_and)
___DEF_M_HLBL(___L9_c_23_pt_2d_and)
___DEF_M_HLBL(___L10_c_23_pt_2d_and)
___DEF_M_HLBL(___L11_c_23_pt_2d_and)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_or)
___DEF_M_HLBL(___L1_c_23_pt_2d_or)
___DEF_M_HLBL(___L2_c_23_pt_2d_or)
___DEF_M_HLBL(___L3_c_23_pt_2d_or)
___DEF_M_HLBL(___L4_c_23_pt_2d_or)
___DEF_M_HLBL(___L5_c_23_pt_2d_or)
___DEF_M_HLBL(___L6_c_23_pt_2d_or)
___DEF_M_HLBL(___L7_c_23_pt_2d_or)
___DEF_M_HLBL(___L8_c_23_pt_2d_or)
___DEF_M_HLBL(___L9_c_23_pt_2d_or)
___DEF_M_HLBL(___L10_c_23_pt_2d_or)
___DEF_M_HLBL(___L11_c_23_pt_2d_or)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_case)
___DEF_M_HLBL(___L1_c_23_pt_2d_case)
___DEF_M_HLBL(___L2_c_23_pt_2d_case)
___DEF_M_HLBL(___L3_c_23_pt_2d_case)
___DEF_M_HLBL(___L4_c_23_pt_2d_case)
___DEF_M_HLBL(___L5_c_23_pt_2d_case)
___DEF_M_HLBL(___L6_c_23_pt_2d_case)
___DEF_M_HLBL(___L7_c_23_pt_2d_case)
___DEF_M_HLBL(___L8_c_23_pt_2d_case)
___DEF_M_HLBL(___L9_c_23_pt_2d_case)
___DEF_M_HLBL(___L10_c_23_pt_2d_case)
___DEF_M_HLBL(___L11_c_23_pt_2d_case)
___DEF_M_HLBL(___L12_c_23_pt_2d_case)
___DEF_M_HLBL(___L13_c_23_pt_2d_case)
___DEF_M_HLBL(___L14_c_23_pt_2d_case)
___DEF_M_HLBL(___L15_c_23_pt_2d_case)
___DEF_M_HLBL(___L16_c_23_pt_2d_case)
___DEF_M_HLBL(___L17_c_23_pt_2d_case)
___DEF_M_HLBL(___L18_c_23_pt_2d_case)
___DEF_M_HLBL(___L19_c_23_pt_2d_case)
___DEF_M_HLBL(___L20_c_23_pt_2d_case)
___DEF_M_HLBL(___L21_c_23_pt_2d_case)
___DEF_M_HLBL(___L22_c_23_pt_2d_case)
___DEF_M_HLBL(___L23_c_23_pt_2d_case)
___DEF_M_HLBL(___L24_c_23_pt_2d_case)
___DEF_M_HLBL(___L25_c_23_pt_2d_case)
___DEF_M_HLBL(___L26_c_23_pt_2d_case)
___DEF_M_HLBL(___L27_c_23_pt_2d_case)
___DEF_M_HLBL(___L28_c_23_pt_2d_case)
___DEF_M_HLBL(___L29_c_23_pt_2d_case)
___DEF_M_HLBL(___L30_c_23_pt_2d_case)
___DEF_M_HLBL(___L31_c_23_pt_2d_case)
___DEF_M_HLBL(___L32_c_23_pt_2d_case)
___DEF_M_HLBL(___L33_c_23_pt_2d_case)
___DEF_M_HLBL(___L34_c_23_pt_2d_case)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_let)
___DEF_M_HLBL(___L1_c_23_pt_2d_let)
___DEF_M_HLBL(___L2_c_23_pt_2d_let)
___DEF_M_HLBL(___L3_c_23_pt_2d_let)
___DEF_M_HLBL(___L4_c_23_pt_2d_let)
___DEF_M_HLBL(___L5_c_23_pt_2d_let)
___DEF_M_HLBL(___L6_c_23_pt_2d_let)
___DEF_M_HLBL(___L7_c_23_pt_2d_let)
___DEF_M_HLBL(___L8_c_23_pt_2d_let)
___DEF_M_HLBL(___L9_c_23_pt_2d_let)
___DEF_M_HLBL(___L10_c_23_pt_2d_let)
___DEF_M_HLBL(___L11_c_23_pt_2d_let)
___DEF_M_HLBL(___L12_c_23_pt_2d_let)
___DEF_M_HLBL(___L13_c_23_pt_2d_let)
___DEF_M_HLBL(___L14_c_23_pt_2d_let)
___DEF_M_HLBL(___L15_c_23_pt_2d_let)
___DEF_M_HLBL(___L16_c_23_pt_2d_let)
___DEF_M_HLBL(___L17_c_23_pt_2d_let)
___DEF_M_HLBL(___L18_c_23_pt_2d_let)
___DEF_M_HLBL(___L19_c_23_pt_2d_let)
___DEF_M_HLBL(___L20_c_23_pt_2d_let)
___DEF_M_HLBL(___L21_c_23_pt_2d_let)
___DEF_M_HLBL(___L22_c_23_pt_2d_let)
___DEF_M_HLBL(___L23_c_23_pt_2d_let)
___DEF_M_HLBL(___L24_c_23_pt_2d_let)
___DEF_M_HLBL(___L25_c_23_pt_2d_let)
___DEF_M_HLBL(___L26_c_23_pt_2d_let)
___DEF_M_HLBL(___L27_c_23_pt_2d_let)
___DEF_M_HLBL(___L28_c_23_pt_2d_let)
___DEF_M_HLBL(___L29_c_23_pt_2d_let)
___DEF_M_HLBL(___L30_c_23_pt_2d_let)
___DEF_M_HLBL(___L31_c_23_pt_2d_let)
___DEF_M_HLBL(___L32_c_23_pt_2d_let)
___DEF_M_HLBL(___L33_c_23_pt_2d_let)
___DEF_M_HLBL(___L34_c_23_pt_2d_let)
___DEF_M_HLBL(___L35_c_23_pt_2d_let)
___DEF_M_HLBL(___L36_c_23_pt_2d_let)
___DEF_M_HLBL(___L37_c_23_pt_2d_let)
___DEF_M_HLBL(___L38_c_23_pt_2d_let)
___DEF_M_HLBL(___L39_c_23_pt_2d_let)
___DEF_M_HLBL(___L40_c_23_pt_2d_let)
___DEF_M_HLBL(___L41_c_23_pt_2d_let)
___DEF_M_HLBL(___L42_c_23_pt_2d_let)
___DEF_M_HLBL(___L43_c_23_pt_2d_let)
___DEF_M_HLBL(___L44_c_23_pt_2d_let)
___DEF_M_HLBL(___L45_c_23_pt_2d_let)
___DEF_M_HLBL(___L46_c_23_pt_2d_let)
___DEF_M_HLBL(___L47_c_23_pt_2d_let)
___DEF_M_HLBL(___L48_c_23_pt_2d_let)
___DEF_M_HLBL(___L49_c_23_pt_2d_let)
___DEF_M_HLBL(___L50_c_23_pt_2d_let)
___DEF_M_HLBL(___L51_c_23_pt_2d_let)
___DEF_M_HLBL(___L52_c_23_pt_2d_let)
___DEF_M_HLBL(___L53_c_23_pt_2d_let)
___DEF_M_HLBL(___L54_c_23_pt_2d_let)
___DEF_M_HLBL(___L55_c_23_pt_2d_let)
___DEF_M_HLBL(___L56_c_23_pt_2d_let)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L1_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L2_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L3_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L4_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L5_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L6_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L7_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L8_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L9_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L10_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L11_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L12_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L13_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L14_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L15_c_23_pt_2d_let_2a_)
___DEF_M_HLBL(___L16_c_23_pt_2d_let_2a_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L1_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L2_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L3_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L4_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L5_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L6_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L7_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L8_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L9_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L10_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L11_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L12_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L13_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L14_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L15_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L16_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L17_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L18_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L19_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L20_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L21_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L22_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L23_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L24_c_23_pt_2d_letrec)
___DEF_M_HLBL(___L25_c_23_pt_2d_letrec)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L1_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L2_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L3_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L4_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L5_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L6_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L7_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L8_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L9_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L10_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L11_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L12_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L13_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L14_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L15_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L16_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L17_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L18_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L19_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L20_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L21_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L22_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L23_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L24_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L25_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L26_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L27_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L28_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L29_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L30_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L31_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L32_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L33_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L34_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L35_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L36_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L37_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L38_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L39_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L40_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L41_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L42_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L43_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L44_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L45_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L46_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L47_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L48_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L49_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L50_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L51_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L52_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L53_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L54_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L55_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L56_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L57_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L58_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L59_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L60_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL(___L61_c_23_pt_2d_recursive_2d_let)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_begin)
___DEF_M_HLBL(___L1_c_23_pt_2d_begin)
___DEF_M_HLBL(___L2_c_23_pt_2d_begin)
___DEF_M_HLBL(___L3_c_23_pt_2d_begin)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_do)
___DEF_M_HLBL(___L1_c_23_pt_2d_do)
___DEF_M_HLBL(___L2_c_23_pt_2d_do)
___DEF_M_HLBL(___L3_c_23_pt_2d_do)
___DEF_M_HLBL(___L4_c_23_pt_2d_do)
___DEF_M_HLBL(___L5_c_23_pt_2d_do)
___DEF_M_HLBL(___L6_c_23_pt_2d_do)
___DEF_M_HLBL(___L7_c_23_pt_2d_do)
___DEF_M_HLBL(___L8_c_23_pt_2d_do)
___DEF_M_HLBL(___L9_c_23_pt_2d_do)
___DEF_M_HLBL(___L10_c_23_pt_2d_do)
___DEF_M_HLBL(___L11_c_23_pt_2d_do)
___DEF_M_HLBL(___L12_c_23_pt_2d_do)
___DEF_M_HLBL(___L13_c_23_pt_2d_do)
___DEF_M_HLBL(___L14_c_23_pt_2d_do)
___DEF_M_HLBL(___L15_c_23_pt_2d_do)
___DEF_M_HLBL(___L16_c_23_pt_2d_do)
___DEF_M_HLBL(___L17_c_23_pt_2d_do)
___DEF_M_HLBL(___L18_c_23_pt_2d_do)
___DEF_M_HLBL(___L19_c_23_pt_2d_do)
___DEF_M_HLBL(___L20_c_23_pt_2d_do)
___DEF_M_HLBL(___L21_c_23_pt_2d_do)
___DEF_M_HLBL(___L22_c_23_pt_2d_do)
___DEF_M_HLBL(___L23_c_23_pt_2d_do)
___DEF_M_HLBL(___L24_c_23_pt_2d_do)
___DEF_M_HLBL(___L25_c_23_pt_2d_do)
___DEF_M_HLBL(___L26_c_23_pt_2d_do)
___DEF_M_HLBL(___L27_c_23_pt_2d_do)
___DEF_M_HLBL(___L28_c_23_pt_2d_do)
___DEF_M_HLBL(___L29_c_23_pt_2d_do)
___DEF_M_HLBL(___L30_c_23_pt_2d_do)
___DEF_M_HLBL(___L31_c_23_pt_2d_do)
___DEF_M_HLBL(___L32_c_23_pt_2d_do)
___DEF_M_HLBL(___L33_c_23_pt_2d_do)
___DEF_M_HLBL(___L34_c_23_pt_2d_do)
___DEF_M_HLBL(___L35_c_23_pt_2d_do)
___DEF_M_HLBL(___L36_c_23_pt_2d_do)
___DEF_M_HLBL(___L37_c_23_pt_2d_do)
___DEF_M_HLBL(___L38_c_23_pt_2d_do)
___DEF_M_HLBL(___L39_c_23_pt_2d_do)
___DEF_M_HLBL(___L40_c_23_pt_2d_do)
___DEF_M_HLBL(___L41_c_23_pt_2d_do)
___DEF_M_HLBL(___L42_c_23_pt_2d_do)
___DEF_M_HLBL(___L43_c_23_pt_2d_do)
___DEF_M_HLBL(___L44_c_23_pt_2d_do)
___DEF_M_HLBL(___L45_c_23_pt_2d_do)
___DEF_M_HLBL(___L46_c_23_pt_2d_do)
___DEF_M_HLBL(___L47_c_23_pt_2d_do)
___DEF_M_HLBL(___L48_c_23_pt_2d_do)
___DEF_M_HLBL(___L49_c_23_pt_2d_do)
___DEF_M_HLBL(___L50_c_23_pt_2d_do)
___DEF_M_HLBL(___L51_c_23_pt_2d_do)
___DEF_M_HLBL(___L52_c_23_pt_2d_do)
___DEF_M_HLBL(___L53_c_23_pt_2d_do)
___DEF_M_HLBL(___L54_c_23_pt_2d_do)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_combination)
___DEF_M_HLBL(___L1_c_23_pt_2d_combination)
___DEF_M_HLBL(___L2_c_23_pt_2d_combination)
___DEF_M_HLBL(___L3_c_23_pt_2d_combination)
___DEF_M_HLBL(___L4_c_23_pt_2d_combination)
___DEF_M_HLBL(___L5_c_23_pt_2d_combination)
___DEF_M_HLBL(___L6_c_23_pt_2d_combination)
___DEF_M_HLBL(___L7_c_23_pt_2d_combination)
___DEF_M_HLBL(___L8_c_23_pt_2d_combination)
___DEF_M_HLBL(___L9_c_23_pt_2d_combination)
___DEF_M_HLBL(___L10_c_23_pt_2d_combination)
___DEF_M_HLBL(___L11_c_23_pt_2d_combination)
___DEF_M_HLBL(___L12_c_23_pt_2d_combination)
___DEF_M_HLBL(___L13_c_23_pt_2d_combination)
___DEF_M_HLBL(___L14_c_23_pt_2d_combination)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_delay)
___DEF_M_HLBL(___L1_c_23_pt_2d_delay)
___DEF_M_HLBL(___L2_c_23_pt_2d_delay)
___DEF_M_HLBL(___L3_c_23_pt_2d_delay)
___DEF_M_HLBL(___L4_c_23_pt_2d_delay)
___DEF_M_HLBL(___L5_c_23_pt_2d_delay)
___DEF_M_HLBL(___L6_c_23_pt_2d_delay)
___DEF_M_HLBL(___L7_c_23_pt_2d_delay)
___DEF_M_HLBL(___L8_c_23_pt_2d_delay)
___DEF_M_HLBL(___L9_c_23_pt_2d_delay)
___DEF_M_HLBL(___L10_c_23_pt_2d_delay)
___DEF_M_HLBL(___L11_c_23_pt_2d_delay)
___DEF_M_HLBL(___L12_c_23_pt_2d_delay)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pt_2d_future)
___DEF_M_HLBL(___L1_c_23_pt_2d_future)
___DEF_M_HLBL(___L2_c_23_pt_2d_future)
___DEF_M_HLBL(___L3_c_23_pt_2d_future)
___DEF_M_HLBL(___L4_c_23_pt_2d_future)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_self_2d_eval_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_self_2d_eval_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23_self_2d_eval_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23_self_2d_eval_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L1_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L2_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L3_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L4_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L5_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L6_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L7_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L8_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L9_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L10_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L11_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL(___L12_c_23_self_2d_evaluating_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_quote_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_quote_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_quasiquote_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_quasiquote_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_quasiquote_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_quasiquote_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unquote_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_unquote_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unquote_2d_splicing_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_unquote_2d_splicing_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_var_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_var_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23_var_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23_var_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23_var_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23_var_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_not_2d_macro)
___DEF_M_HLBL(___L1_c_23_not_2d_macro)
___DEF_M_HLBL(___L2_c_23_not_2d_macro)
___DEF_M_HLBL(___L3_c_23_not_2d_macro)
___DEF_M_HLBL(___L4_c_23_not_2d_macro)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_bindable_2d_var_3f_)
___DEF_M_HLBL(___L1_c_23_bindable_2d_var_3f_)
___DEF_M_HLBL(___L2_c_23_bindable_2d_var_3f_)
___DEF_M_HLBL(___L3_c_23_bindable_2d_var_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_set_21__2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_set_21__2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_lambda_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_lambda_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_lambda_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_lambda_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L6_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL(___L7_c_23__2a__2a_if_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_and_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_and_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_or_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_or_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_case_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_case_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_case_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_case_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_case_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L6_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L7_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L8_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L9_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL(___L10_c_23__2a__2a_let_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_do_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_do_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_do_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_do_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_do_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_do_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L6_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL(___L7_c_23_combination_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_future_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_future_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_future_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_future_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_future_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L6_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L7_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L8_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L9_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L10_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL(___L11_c_23_macro_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_begin_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_begin_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_define_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_define_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L6_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL(___L7_c_23__2a__2a_include_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_declare_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_declare_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_namespace_2d_expr_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_namespace_2d_expr_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_match)
___DEF_M_HLBL(___L1_c_23_match)
___DEF_M_HLBL(___L2_c_23_match)
___DEF_M_HLBL(___L3_c_23_match)
___DEF_M_HLBL(___L4_c_23_match)
___DEF_M_HLBL(___L5_c_23_match)
___DEF_M_HLBL(___L6_c_23_match)
___DEF_M_HLBL(___L7_c_23_match)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L1_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L2_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L3_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L4_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L5_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L6_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L7_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L8_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L9_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L10_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L11_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL(___L12_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_length)
___DEF_M_HLBL(___L1_c_23_proper_2d_length)
___DEF_M_HLBL(___L2_c_23_proper_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_definition_2d_name)
___DEF_M_HLBL(___L1_c_23_definition_2d_name)
___DEF_M_HLBL(___L2_c_23_definition_2d_name)
___DEF_M_HLBL(___L3_c_23_definition_2d_name)
___DEF_M_HLBL(___L4_c_23_definition_2d_name)
___DEF_M_HLBL(___L5_c_23_definition_2d_name)
___DEF_M_HLBL(___L6_c_23_definition_2d_name)
___DEF_M_HLBL(___L7_c_23_definition_2d_name)
___DEF_M_HLBL(___L8_c_23_definition_2d_name)
___DEF_M_HLBL(___L9_c_23_definition_2d_name)
___DEF_M_HLBL(___L10_c_23_definition_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_definition_2d_value)
___DEF_M_HLBL(___L1_c_23_definition_2d_value)
___DEF_M_HLBL(___L2_c_23_definition_2d_value)
___DEF_M_HLBL(___L3_c_23_definition_2d_value)
___DEF_M_HLBL(___L4_c_23_definition_2d_value)
___DEF_M_HLBL(___L5_c_23_definition_2d_value)
___DEF_M_HLBL(___L6_c_23_definition_2d_value)
___DEF_M_HLBL(___L7_c_23_definition_2d_value)
___DEF_M_HLBL(___L8_c_23_definition_2d_value)
___DEF_M_HLBL(___L9_c_23_definition_2d_value)
___DEF_M_HLBL(___L10_c_23_definition_2d_value)
___DEF_M_HLBL(___L11_c_23_definition_2d_value)
___DEF_M_HLBL(___L12_c_23_definition_2d_value)
___DEF_M_HLBL(___L13_c_23_definition_2d_value)
___DEF_M_HLBL(___L14_c_23_definition_2d_value)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_parms_2d__3e_source)
___DEF_M_HLBL(___L1_c_23_parms_2d__3e_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L2_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L3_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L4_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L5_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L6_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L7_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L8_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L9_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L10_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L11_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L12_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L13_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL(___L14_c_23_proper_2d_clauses_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L2_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L3_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L4_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L5_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L6_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L7_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L8_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L9_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L10_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L11_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L12_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL(___L13_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL(___L2_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL(___L3_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL(___L4_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL(___L5_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL(___L6_c_23_proper_2d_selector_2d_list_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L2_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L3_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L4_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L5_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L6_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L7_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L8_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L9_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L10_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L11_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L12_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L13_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L14_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L15_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L16_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL(___L17_c_23_proper_2d_bindings_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L2_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L3_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L4_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L5_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L6_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L7_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L8_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L9_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L10_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L11_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L12_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L13_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L14_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L15_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L16_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L17_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL(___L18_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL(___L1_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL(___L2_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL(___L3_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL(___L4_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL(___L5_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL(___L6_c_23_proper_2d_do_2d_exit_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_begin_2d_body)
___DEF_M_HLBL(___L1_c_23_begin_2d_body)
___DEF_M_HLBL(___L2_c_23_begin_2d_body)
___DEF_M_HLBL(___L3_c_23_begin_2d_body)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_length_3f_)
___DEF_M_HLBL(___L1_c_23_length_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L1_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L2_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L3_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L4_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L5_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L6_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L7_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L8_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L9_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L10_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L11_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L12_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L13_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L14_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L15_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L16_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L17_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L18_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L19_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L20_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L21_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L22_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L23_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L24_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L25_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L26_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L27_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L28_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L29_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L30_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L31_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L32_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L33_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L34_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L35_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L36_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L37_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L38_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L39_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L40_c_23_transform_2d_declaration)
___DEF_M_HLBL(___L41_c_23_transform_2d_declaration)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_extract_2d_names)
___DEF_M_HLBL(___L1_c_23_extract_2d_names)
___DEF_M_HLBL(___L2_c_23_extract_2d_names)
___DEF_M_HLBL(___L3_c_23_extract_2d_names)
___DEF_M_HLBL(___L4_c_23_extract_2d_names)
___DEF_M_HLBL(___L5_c_23_extract_2d_names)
___DEF_M_HLBL(___L6_c_23_extract_2d_names)
___DEF_M_HLBL(___L7_c_23_extract_2d_names)
___DEF_M_HLBL(___L8_c_23_extract_2d_names)
___DEF_M_HLBL(___L9_c_23_extract_2d_names)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_declarations)
___DEF_M_HLBL(___L1_c_23_add_2d_declarations)
___DEF_M_HLBL(___L2_c_23_add_2d_declarations)
___DEF_M_HLBL(___L3_c_23_add_2d_declarations)
___DEF_M_HLBL(___L4_c_23_add_2d_declarations)
___DEF_M_HLBL(___L5_c_23_add_2d_declarations)
___DEF_M_HLBL(___L6_c_23_add_2d_declarations)
___DEF_M_HLBL(___L7_c_23_add_2d_declarations)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_namespace)
___DEF_M_HLBL(___L1_c_23_add_2d_namespace)
___DEF_M_HLBL(___L2_c_23_add_2d_namespace)
___DEF_M_HLBL(___L3_c_23_add_2d_namespace)
___DEF_M_HLBL(___L4_c_23_add_2d_namespace)
___DEF_M_HLBL(___L5_c_23_add_2d_namespace)
___DEF_M_HLBL(___L6_c_23_add_2d_namespace)
___DEF_M_HLBL(___L7_c_23_add_2d_namespace)
___DEF_M_HLBL(___L8_c_23_add_2d_namespace)
___DEF_M_HLBL(___L9_c_23_add_2d_namespace)
___DEF_M_HLBL(___L10_c_23_add_2d_namespace)
___DEF_M_HLBL(___L11_c_23_add_2d_namespace)
___DEF_M_HLBL(___L12_c_23_add_2d_namespace)
___DEF_M_HLBL(___L13_c_23_add_2d_namespace)
___DEF_M_HLBL(___L14_c_23_add_2d_namespace)
___DEF_M_HLBL(___L15_c_23_add_2d_namespace)
___DEF_M_HLBL(___L16_c_23_add_2d_namespace)
___DEF_M_HLBL(___L17_c_23_add_2d_namespace)
___DEF_M_HLBL(___L18_c_23_add_2d_namespace)
___DEF_M_HLBL(___L19_c_23_add_2d_namespace)
___DEF_M_HLBL(___L20_c_23_add_2d_namespace)
___DEF_M_HLBL(___L21_c_23_add_2d_namespace)
___DEF_M_HLBL(___L22_c_23_add_2d_namespace)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_add_2d_macro)
___DEF_M_HLBL(___L1_c_23_add_2d_macro)
___DEF_M_HLBL(___L2_c_23_add_2d_macro)
___DEF_M_HLBL(___L3_c_23_add_2d_macro)
___DEF_M_HLBL(___L4_c_23_add_2d_macro)
___DEF_M_HLBL(___L5_c_23_add_2d_macro)
___DEF_M_HLBL(___L6_c_23_add_2d_macro)
___DEF_M_HLBL(___L7_c_23_add_2d_macro)
___DEF_M_HLBL(___L8_c_23_add_2d_macro)
___DEF_M_HLBL(___L9_c_23_add_2d_macro)
___DEF_M_HLBL(___L10_c_23_add_2d_macro)
___DEF_M_HLBL(___L11_c_23_add_2d_macro)
___DEF_M_HLBL(___L12_c_23_add_2d_macro)
___DEF_M_HLBL(___L13_c_23_add_2d_macro)
___DEF_M_HLBL(___L14_c_23_add_2d_macro)
___DEF_M_HLBL(___L15_c_23_add_2d_macro)
___DEF_M_HLBL(___L16_c_23_add_2d_macro)
___DEF_M_HLBL(___L17_c_23_add_2d_macro)
___DEF_M_HLBL(___L18_c_23_add_2d_macro)
___DEF_M_HLBL(___L19_c_23_add_2d_macro)
___DEF_M_HLBL(___L20_c_23_add_2d_macro)
___DEF_M_HLBL(___L21_c_23_add_2d_macro)
___DEF_M_HLBL(___L22_c_23_add_2d_macro)
___DEF_M_HLBL(___L23_c_23_add_2d_macro)
___DEF_M_HLBL(___L24_c_23_add_2d_macro)
___DEF_M_HLBL(___L25_c_23_add_2d_macro)
___DEF_M_HLBL(___L26_c_23_add_2d_macro)
___DEF_M_HLBL(___L27_c_23_add_2d_macro)
___DEF_M_HLBL(___L28_c_23_add_2d_macro)
___DEF_M_HLBL(___L29_c_23_add_2d_macro)
___DEF_M_HLBL(___L30_c_23_add_2d_macro)
___DEF_M_HLBL(___L31_c_23_add_2d_macro)
___DEF_M_HLBL(___L32_c_23_add_2d_macro)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptree_2e_begin_21_)
___DEF_M_HLBL(___L1_c_23_ptree_2e_begin_21_)
___DEF_M_HLBL(___L2_c_23_ptree_2e_begin_21_)
___DEF_M_HLBL(___L3_c_23_ptree_2e_begin_21_)
___DEF_M_HLBL(___L4_c_23_ptree_2e_begin_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ptree_2e_end_21_)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___ptree1
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___ptree1)
___DEF_P_HLBL(___L1__20___ptree1)
___DEF_P_HLBL(___L2__20___ptree1)
___DEF_P_HLBL(___L3__20___ptree1)
___DEF_P_HLBL(___L4__20___ptree1)
___DEF_P_HLBL(___L5__20___ptree1)
___DEF_P_HLBL(___L6__20___ptree1)
___DEF_P_HLBL(___L7__20___ptree1)
___DEF_P_HLBL(___L8__20___ptree1)
___DEF_P_HLBL(___L9__20___ptree1)
___DEF_P_HLBL(___L10__20___ptree1)
___DEF_P_HLBL(___L11__20___ptree1)
___DEF_P_HLBL(___L12__20___ptree1)
___DEF_P_HLBL(___L13__20___ptree1)
___DEF_P_HLBL(___L14__20___ptree1)
___DEF_P_HLBL(___L15__20___ptree1)
___DEF_P_HLBL(___L16__20___ptree1)
___DEF_P_HLBL(___L17__20___ptree1)
___DEF_P_HLBL(___L18__20___ptree1)
___DEF_P_HLBL(___L19__20___ptree1)
___DEF_P_HLBL(___L20__20___ptree1)
___DEF_P_HLBL(___L21__20___ptree1)
___DEF_P_HLBL(___L22__20___ptree1)
___DEF_P_HLBL(___L23__20___ptree1)
___DEF_P_HLBL(___L24__20___ptree1)
___DEF_P_HLBL(___L25__20___ptree1)
___DEF_P_HLBL(___L26__20___ptree1)
___DEF_P_HLBL(___L27__20___ptree1)
___DEF_P_HLBL(___L28__20___ptree1)
___DEF_P_HLBL(___L29__20___ptree1)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___ptree1)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___ptree1)
   ___SET_R1(___CONS(___SYM_cst_2d_tag,___NUL))
   ___SET_GLO(54,___G_c_23_cst_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_ref_2d_tag,___NUL))
   ___SET_GLO(204,___G_c_23_ref_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_set_2d_tag,___NUL))
   ___SET_GLO(214,___G_c_23_set_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_def_2d_tag,___NUL))
   ___SET_GLO(62,___G_c_23_def_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_tst_2d_tag,___NUL))
   ___SET_GLO(230,___G_c_23_tst_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_conj_2d_tag,___NUL))
   ___SET_GLO(49,___G_c_23_conj_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_disj_2d_tag,___NUL))
   ___SET_GLO(71,___G_c_23_disj_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_prc_2d_tag,___NUL))
   ___SET_GLO(165,___G_c_23_prc_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_app_2d_tag,___NUL))
   ___SET_GLO(36,___G_c_23_app_2d_tag,___R1)
   ___SET_R1(___CONS(___SYM_fut_2d_tag,___NUL))
   ___SET_GLO(78,___G_c_23_fut_2d_tag,___R1)
   ___SET_GLO(127,___G_c_23_next_2d_node_2d_stamp,___FAL)
   ___SET_GLO(225,___G_c_23_temp_2d_variable_2d_stamp,___FAL)
   ___SET_STK(1,___R0)
   ___SET_R2(___SYM_dialect)
   ___SET_R1(___GLO_c_23_ieee_2d_scheme_2d_sym)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__20___ptree1)
   ___POLL(2)
___DEF_SLBL(2,___L2__20___ptree1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(3,___L3__20___ptree1)
   ___SET_R2(___SYM_dialect)
   ___SET_R1(___GLO_c_23_r4rs_2d_scheme_2d_sym)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(4,___L4__20___ptree1)
   ___SET_R2(___SYM_dialect)
   ___SET_R1(___GLO_c_23_r5rs_2d_scheme_2d_sym)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(5,___L5__20___ptree1)
   ___SET_R2(___SYM_dialect)
   ___SET_R1(___GLO_c_23_gambit_2d_scheme_2d_sym)
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(6,___L6__20___ptree1)
   ___SET_R2(___SYM_dialect)
   ___SET_R1(___GLO_c_23_multilisp_2d_sym)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(7,___L7__20___ptree1)
   ___SET_R1(___GLO_c_23_constant_2d_fold_2d_sym)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(8,___L8__20___ptree1)
   ___SET_R1(___GLO_c_23_lambda_2d_lift_2d_sym)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(9,___L9__20___ptree1)
   ___SET_R1(___GLO_c_23_inline_2d_sym)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(10,___L10__20___ptree1)
   ___SET_R1(___GLO_c_23_inline_2d_primitives_2d_sym)
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),322,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_SLBL(11,___L11__20___ptree1)
   ___SET_R1(___GLO_c_23_inlining_2d_limit_2d_sym)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),323,___G_c_23_define_2d_parameterized_2d_decl)
___DEF_SLBL(12,___L12__20___ptree1)
   ___SET_R2(___SYM_compilation_2d_strategy)
   ___SET_R1(___GLO_c_23_block_2d_sym)
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(13,___L13__20___ptree1)
   ___SET_R2(___SYM_compilation_2d_strategy)
   ___SET_R1(___GLO_c_23_separate_2d_sym)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),321,___G_c_23_define_2d_flag_2d_decl)
___DEF_SLBL(14,___L14__20___ptree1)
   ___SET_R1(___GLO_c_23_core_2d_sym)
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(15,___L15__20___ptree1)
   ___SET_R1(___GLO_c_23_standard_2d_bindings_2d_sym)
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),322,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_SLBL(16,___L16__20___ptree1)
   ___SET_R1(___GLO_c_23_extended_2d_bindings_2d_sym)
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),322,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_SLBL(17,___L17__20___ptree1)
   ___SET_R1(___GLO_c_23_run_2d_time_2d_bindings_2d_sym)
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),322,___G_c_23_define_2d_namable_2d_boolean_2d_decl)
___DEF_SLBL(18,___L18__20___ptree1)
   ___SET_R1(___GLO_c_23_safe_2d_sym)
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(19,___L19__20___ptree1)
   ___SET_R1(___GLO_c_23_warnings_2d_sym)
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(20,___L20__20___ptree1)
   ___SET_R1(___GLO_c_23_interrupts_2d_enabled_2d_sym)
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(21,___L21__20___ptree1)
   ___SET_R1(___GLO_c_23_debug_2d_sym)
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(22,___L22__20___ptree1)
   ___SET_R1(___GLO_c_23_debug_2d_location_2d_sym)
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(23,___L23__20___ptree1)
   ___SET_R1(___GLO_c_23_debug_2d_source_2d_sym)
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(24,___L24__20___ptree1)
   ___SET_R1(___GLO_c_23_debug_2d_environments_2d_sym)
   ___SET_R0(___LBL(25))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(25,___L25__20___ptree1)
   ___SET_R1(___GLO_c_23_environment_2d_map_2d_sym)
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(26,___L26__20___ptree1)
   ___SET_R1(___GLO_c_23_proper_2d_tail_2d_calls_2d_sym)
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(27,___L27__20___ptree1)
   ___SET_R1(___GLO_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym)
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),320,___G_c_23_define_2d_boolean_2d_decl)
___DEF_SLBL(28,___L28__20___ptree1)
   ___SET_GLO(24,___G_c_23__2a_ptree_2d_port_2a_,___NUL)
   ___SET_R1(___VOID)
   ___POLL(29)
___DEF_SLBL(29,___L29__20___ptree1)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_parent
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
___DEF_P_HLBL(___L0_c_23_node_2d_parent)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_parent)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_parent)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_children
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
___DEF_P_HLBL(___L0_c_23_node_2d_children)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_children)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_children)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_fv
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
___DEF_P_HLBL(___L0_c_23_node_2d_fv)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_fv)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_fv)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_bfv
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
___DEF_P_HLBL(___L0_c_23_node_2d_bfv)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_bfv)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_bfv)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_env
#undef ___PH_LBL0
#define ___PH_LBL0 40
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_env)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_env)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_env)
   ___SET_R1(___VECTORREF(___R1,___FIX(5L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 42
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_source)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_source)
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_stamp
#undef ___PH_LBL0
#define ___PH_LBL0 44
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_stamp)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_stamp)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_stamp)
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_parent_2d_set_21_
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
___DEF_P_HLBL(___L0_c_23_node_2d_parent_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_parent_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_parent_2d_set_21_)
   ___VECTORSET(___R1,___FIX(1L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_fv_2d_set_21_
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
___DEF_P_HLBL(___L0_c_23_node_2d_fv_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_fv_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_fv_2d_set_21_)
   ___VECTORSET(___R1,___FIX(3L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_bfv_2d_set_21_
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
___DEF_P_HLBL(___L0_c_23_node_2d_bfv_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_bfv_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_bfv_2d_set_21_)
   ___VECTORSET(___R1,___FIX(4L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_env_2d_set_21_
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
___DEF_P_HLBL(___L0_c_23_node_2d_env_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_env_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_env_2d_set_21_)
   ___VECTORSET(___R1,___FIX(5L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_source_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 54
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_source_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_source_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_source_2d_set_21_)
   ___VECTORSET(___R1,___FIX(6L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_stamp_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 56
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_stamp_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_stamp_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_stamp_2d_set_21_)
   ___VECTORSET(___R1,___FIX(7L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_cst
#undef ___PH_LBL0
#define ___PH_LBL0 58
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_cst)
___DEF_P_HLBL(___L1_c_23_make_2d_cst)
___DEF_P_HLBL(___L2_c_23_make_2d_cst)
___DEF_P_HLBL(___L3_c_23_make_2d_cst)
___DEF_P_HLBL(___L4_c_23_make_2d_cst)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_cst)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L_c_23_make_2d_cst)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_cst)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_cst)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_cst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-8))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-4))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_cst)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_cst)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_cst_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 64
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_cst_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_cst_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_cst_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_cst_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_cst_2d_val
#undef ___PH_LBL0
#define ___PH_LBL0 66
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_cst_2d_val)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_cst_2d_val)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_cst_2d_val)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_cst_2d_val_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 68
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_cst_2d_val_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_cst_2d_val_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_cst_2d_val_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 70
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_ref)
___DEF_P_HLBL(___L1_c_23_make_2d_ref)
___DEF_P_HLBL(___L2_c_23_make_2d_ref)
___DEF_P_HLBL(___L3_c_23_make_2d_ref)
___DEF_P_HLBL(___L4_c_23_make_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_ref)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L_c_23_make_2d_ref)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_ref)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_ref)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_ref_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-8))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-4))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_ref)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_ref)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 76
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_ref_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 78
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_var)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_var_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 80
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_var_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_var_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_ref_2d_var_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_set
#undef ___PH_LBL0
#define ___PH_LBL0 82
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_set)
___DEF_P_HLBL(___L1_c_23_make_2d_set)
___DEF_P_HLBL(___L2_c_23_make_2d_set)
___DEF_P_HLBL(___L3_c_23_make_2d_set)
___DEF_P_HLBL(___L4_c_23_make_2d_set)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_set)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L_c_23_make_2d_set)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_set)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_set)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_set_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-8))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-4))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_set)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_set)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_set_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 88
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_set_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_set_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_set_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_set_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_set_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 90
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_set_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_set_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_set_2d_var)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_set_2d_var_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 92
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_set_2d_var_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_set_2d_var_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_set_2d_var_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_def
#undef ___PH_LBL0
#define ___PH_LBL0 94
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_def)
___DEF_P_HLBL(___L1_c_23_make_2d_def)
___DEF_P_HLBL(___L2_c_23_make_2d_def)
___DEF_P_HLBL(___L3_c_23_make_2d_def)
___DEF_P_HLBL(___L4_c_23_make_2d_def)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_def)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L_c_23_make_2d_def)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_def)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_def)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_def_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-8))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-4))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_def)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_def)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_def_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 100
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_def_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_def_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_def_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_def_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_def_2d_var
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
___DEF_P_HLBL(___L0_c_23_def_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_def_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_def_2d_var)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_def_2d_var_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 104
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_def_2d_var_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_def_2d_var_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_def_2d_var_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_tst
#undef ___PH_LBL0
#define ___PH_LBL0 106
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_tst)
___DEF_P_HLBL(___L1_c_23_make_2d_tst)
___DEF_P_HLBL(___L2_c_23_make_2d_tst)
___DEF_P_HLBL(___L3_c_23_make_2d_tst)
___DEF_P_HLBL(___L4_c_23_make_2d_tst)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_tst)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_make_2d_tst)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_tst)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_tst)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_tst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_tst)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_tst)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_tst_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 112
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_tst_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_tst_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_tst_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_tst_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_conj
#undef ___PH_LBL0
#define ___PH_LBL0 114
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_conj)
___DEF_P_HLBL(___L1_c_23_make_2d_conj)
___DEF_P_HLBL(___L2_c_23_make_2d_conj)
___DEF_P_HLBL(___L3_c_23_make_2d_conj)
___DEF_P_HLBL(___L4_c_23_make_2d_conj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_conj)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_make_2d_conj)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_conj)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_conj)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_conj_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_conj)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_conj)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_conj_3f_
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
___DEF_P_HLBL(___L0_c_23_conj_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_conj_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_conj_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_conj_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_disj
#undef ___PH_LBL0
#define ___PH_LBL0 122
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_disj)
___DEF_P_HLBL(___L1_c_23_make_2d_disj)
___DEF_P_HLBL(___L2_c_23_make_2d_disj)
___DEF_P_HLBL(___L3_c_23_make_2d_disj)
___DEF_P_HLBL(___L4_c_23_make_2d_disj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_disj)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_make_2d_disj)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_disj)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_disj)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_disj_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_disj)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_disj)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_disj_3f_
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
___DEF_P_HLBL(___L0_c_23_disj_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_disj_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_disj_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_disj_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_prc
#undef ___PH_LBL0
#define ___PH_LBL0 130
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_prc)
___DEF_P_HLBL(___L1_c_23_make_2d_prc)
___DEF_P_HLBL(___L2_c_23_make_2d_prc)
___DEF_P_HLBL(___L3_c_23_make_2d_prc)
___DEF_P_HLBL(___L4_c_23_make_2d_prc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_prc)
   ___IF_NARGS_EQ(12,___NOTHING)
   ___WRONG_NARGS(0,12,0,0)
___DEF_GLBL(___L_c_23_make_2d_prc)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_prc)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_prc)
   ___BEGIN_ALLOC_VECTOR(14)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_prc_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-15))
   ___ADD_VECTOR_ELEM(2,___STK(-14))
   ___ADD_VECTOR_ELEM(3,___STK(-13))
   ___ADD_VECTOR_ELEM(4,___STK(-12))
   ___ADD_VECTOR_ELEM(5,___STK(-11))
   ___ADD_VECTOR_ELEM(6,___STK(-10))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-9))
   ___ADD_VECTOR_ELEM(9,___STK(-8))
   ___ADD_VECTOR_ELEM(10,___STK(-7))
   ___ADD_VECTOR_ELEM(11,___STK(-5))
   ___ADD_VECTOR_ELEM(12,___STK(-4))
   ___ADD_VECTOR_ELEM(13,___STK(-3))
   ___END_ALLOC_VECTOR(14)
   ___SET_R1(___GET_VECTOR(14))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_prc)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_prc)
   ___ADJFP(-16)
   ___JUMPPRM(___NOTHING,___STK(10))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 136
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_prc_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 138
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_name)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_c_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 140
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_c_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_c_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_c_2d_name)
   ___SET_R1(___VECTORREF(___R1,___FIX(9L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_parms
#undef ___PH_LBL0
#define ___PH_LBL0 142
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_parms)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_parms)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_parms)
   ___SET_R1(___VECTORREF(___R1,___FIX(10L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_opts
#undef ___PH_LBL0
#define ___PH_LBL0 144
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_opts)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_opts)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_opts)
   ___SET_R1(___VECTORREF(___R1,___FIX(11L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_keys
#undef ___PH_LBL0
#define ___PH_LBL0 146
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_keys)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_keys)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_keys)
   ___SET_R1(___VECTORREF(___R1,___FIX(12L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_rest_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 148
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_rest_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_rest_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_rest_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(13L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_name_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 150
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_name_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_name_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_prc_2d_name_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_c_2d_name_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 152
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_c_2d_name_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_c_2d_name_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_prc_2d_c_2d_name_2d_set_21_)
   ___VECTORSET(___R1,___FIX(9L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_parms_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 154
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_parms_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_parms_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_prc_2d_parms_2d_set_21_)
   ___VECTORSET(___R1,___FIX(10L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_opts_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 156
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_opts_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_opts_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_prc_2d_opts_2d_set_21_)
   ___VECTORSET(___R1,___FIX(11L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_keys_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 158
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_keys_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_keys_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_prc_2d_keys_2d_set_21_)
   ___VECTORSET(___R1,___FIX(12L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_rest_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 160
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_rest_3f__2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_rest_3f__2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_prc_2d_rest_3f__2d_set_21_)
   ___VECTORSET(___R1,___FIX(13L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_app
#undef ___PH_LBL0
#define ___PH_LBL0 162
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_app)
___DEF_P_HLBL(___L1_c_23_make_2d_app)
___DEF_P_HLBL(___L2_c_23_make_2d_app)
___DEF_P_HLBL(___L3_c_23_make_2d_app)
___DEF_P_HLBL(___L4_c_23_make_2d_app)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_app)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_make_2d_app)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_app)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_app)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_app_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_app)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_app)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_app_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 168
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_app_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_app_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_app_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_app_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_fut
#undef ___PH_LBL0
#define ___PH_LBL0 170
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_fut)
___DEF_P_HLBL(___L1_c_23_make_2d_fut)
___DEF_P_HLBL(___L2_c_23_make_2d_fut)
___DEF_P_HLBL(___L3_c_23_make_2d_fut)
___DEF_P_HLBL(___L4_c_23_make_2d_fut)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_fut)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_make_2d_fut)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_fut)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_make_2d_fut)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_fut_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-11))
   ___ADD_VECTOR_ELEM(2,___STK(-10))
   ___ADD_VECTOR_ELEM(3,___STK(-9))
   ___ADD_VECTOR_ELEM(4,___STK(-7))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_make_2d_fut)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_make_2d_fut)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_fut_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 176
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_fut_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_fut_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_fut_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_fut_2d_tag)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_children_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 178
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_children_2d_set_21_)
___DEF_P_HLBL(___L1_c_23_node_2d_children_2d_set_21_)
___DEF_P_HLBL(___L2_c_23_node_2d_children_2d_set_21_)
___DEF_P_HLBL(___L3_c_23_node_2d_children_2d_set_21_)
___DEF_P_HLBL(___L4_c_23_node_2d_children_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_children_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_node_2d_children_2d_set_21_)
   ___VECTORSET(___R1,___FIX(2L),___R2)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_node_2d_children_2d_set_21_)
   ___GOTO(___L6_c_23_node_2d_children_2d_set_21_)
___DEF_GLBL(___L5_c_23_node_2d_children_2d_set_21_)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_node_2d_children_2d_set_21_)
___DEF_GLBL(___L6_c_23_node_2d_children_2d_set_21_)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L5_c_23_node_2d_children_2d_set_21_)
   ___END_IF
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23_node_2d_children_2d_set_21_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_node_2d_children_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(184),___L_c_23_node_2d_fv_2d_invalidate_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_node_2d_fv_2d_invalidate_21_
#undef ___PH_LBL0
#define ___PH_LBL0 184
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_P_HLBL(___L1_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_P_HLBL(___L2_c_23_node_2d_fv_2d_invalidate_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_node_2d_fv_2d_invalidate_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_node_2d_fv_2d_invalidate_21_)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_node_2d_fv_2d_invalidate_21_)
   ___GOTO(___L4_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_GLBL(___L3_c_23_node_2d_fv_2d_invalidate_21_)
   ___SET_STK(1,___R1)
   ___VECTORSET(___STK(1),___FIX(3L),___TRU)
   ___SET_STK(1,___R1)
   ___VECTORSET(___STK(1),___FIX(4L),___TRU)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_node_2d_fv_2d_invalidate_21_)
___DEF_GLBL(___L4_c_23_node_2d_fv_2d_invalidate_21_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L3_c_23_node_2d_fv_2d_invalidate_21_)
   ___END_IF
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_cst
#undef ___PH_LBL0
#define ___PH_LBL0 188
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_cst)
___DEF_P_HLBL(___L1_c_23_new_2d_cst)
___DEF_P_HLBL(___L2_c_23_new_2d_cst)
___DEF_P_HLBL(___L3_c_23_new_2d_cst)
___DEF_P_HLBL(___L4_c_23_new_2d_cst)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_cst)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_new_2d_cst)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_cst)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_new_2d_cst)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_cst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-5))
   ___ADD_VECTOR_ELEM(6,___STK(-6))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-4))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_new_2d_cst)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_new_2d_cst)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 194
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_ref)
___DEF_P_HLBL(___L1_c_23_new_2d_ref)
___DEF_P_HLBL(___L2_c_23_new_2d_ref)
___DEF_P_HLBL(___L3_c_23_new_2d_ref)
___DEF_P_HLBL(___L4_c_23_new_2d_ref)
___DEF_P_HLBL(___L5_c_23_new_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_ref)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_new_2d_ref)
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_ref)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(2,___L2_c_23_new_2d_ref)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_ref_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-4))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-7))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___SET_STK(-7,___STK(-3))
   ___SET_STK(-5,___R1)
   ___SET_R1(___VECTORREF(___STK(-3),___FIX(3L)))
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(4))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_new_2d_ref)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),378,___G_c_23_ptset_2d_adjoin)
___DEF_SLBL(4,___L4_c_23_new_2d_ref)
   ___VECTORSET(___STK(-7),___FIX(3L),___R1)
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_ref)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_ref_2d_extended_2d_bindings
#undef ___PH_LBL0
#define ___PH_LBL0 201
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_P_HLBL(___L1_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_P_HLBL(___L2_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_P_HLBL(___L3_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_P_HLBL(___L4_c_23_new_2d_ref_2d_extended_2d_bindings)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_ref_2d_extended_2d_bindings)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_new_2d_ref_2d_extended_2d_bindings)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_ref_2d_extended_2d_bindings)
   ___JUMPINT(___SET_NARGS(1),___PRC(566),___L_c_23_add_2d_extended_2d_bindings)
___DEF_SLBL(2,___L2_c_23_new_2d_ref_2d_extended_2d_bindings)
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),330,___G_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_SLBL(3,___L3_c_23_new_2d_ref_2d_extended_2d_bindings)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R2(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_new_2d_ref_2d_extended_2d_bindings)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_set
#undef ___PH_LBL0
#define ___PH_LBL0 207
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_set)
___DEF_P_HLBL(___L1_c_23_new_2d_set)
___DEF_P_HLBL(___L2_c_23_new_2d_set)
___DEF_P_HLBL(___L3_c_23_new_2d_set)
___DEF_P_HLBL(___L4_c_23_new_2d_set)
___DEF_P_HLBL(___L5_c_23_new_2d_set)
___DEF_P_HLBL(___L6_c_23_new_2d_set)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_set)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_set)
   ___SET_R4(___CONS(___R3,___NUL))
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(11)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_set)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_set)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_set)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_set_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-8))
   ___ADD_VECTOR_ELEM(6,___STK(-11))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-10))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___SET_STK(-11,___STK(-7))
   ___SET_STK(-10,___R1)
   ___SET_R1(___VECTORREF(___STK(-7),___FIX(4L)))
   ___SET_R2(___STK(-10))
   ___SET_R0(___LBL(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_set)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),378,___G_c_23_ptset_2d_adjoin)
___DEF_SLBL(5,___L5_c_23_new_2d_set)
   ___VECTORSET(___STK(-11),___FIX(4L),___R1)
   ___SET_STK(-11,___STK(-10))
   ___VECTORSET(___STK(-6),___FIX(1L),___STK(-11))
   ___SET_R1(___STK(-10))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_new_2d_set)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_set_2d_val
#undef ___PH_LBL0
#define ___PH_LBL0 215
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_set_2d_val)
___DEF_P_HLBL(___L1_c_23_set_2d_val)
___DEF_P_HLBL(___L2_c_23_set_2d_val)
___DEF_P_HLBL(___L3_c_23_set_2d_val)
___DEF_P_HLBL(___L4_c_23_set_2d_val)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_set_2d_val)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_set_2d_val)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_set_2d_val)
   ___JUMPINT(___SET_NARGS(1),___PRC(88),___L_c_23_set_3f_)
___DEF_SLBL(2,___L2_c_23_set_2d_val)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_set_2d_val)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_set_2d_val)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_set_2d_val)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_set_2d_val)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_def
#undef ___PH_LBL0
#define ___PH_LBL0 221
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_def)
___DEF_P_HLBL(___L1_c_23_new_2d_def)
___DEF_P_HLBL(___L2_c_23_new_2d_def)
___DEF_P_HLBL(___L3_c_23_new_2d_def)
___DEF_P_HLBL(___L4_c_23_new_2d_def)
___DEF_P_HLBL(___L5_c_23_new_2d_def)
___DEF_P_HLBL(___L6_c_23_new_2d_def)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_def)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_def)
   ___SET_R4(___CONS(___R3,___NUL))
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(11)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_def)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_def)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_def)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_def_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-8))
   ___ADD_VECTOR_ELEM(6,___STK(-11))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-10))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___SET_STK(-11,___STK(-7))
   ___SET_STK(-10,___R1)
   ___SET_R1(___VECTORREF(___STK(-7),___FIX(4L)))
   ___SET_R2(___STK(-10))
   ___SET_R0(___LBL(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_def)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),378,___G_c_23_ptset_2d_adjoin)
___DEF_SLBL(5,___L5_c_23_new_2d_def)
   ___VECTORSET(___STK(-11),___FIX(4L),___R1)
   ___SET_STK(-11,___STK(-10))
   ___VECTORSET(___STK(-6),___FIX(1L),___STK(-11))
   ___SET_R1(___STK(-10))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_new_2d_def)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_def_2d_val
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
___DEF_P_HLBL(___L0_c_23_def_2d_val)
___DEF_P_HLBL(___L1_c_23_def_2d_val)
___DEF_P_HLBL(___L2_c_23_def_2d_val)
___DEF_P_HLBL(___L3_c_23_def_2d_val)
___DEF_P_HLBL(___L4_c_23_def_2d_val)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_def_2d_val)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_def_2d_val)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_def_2d_val)
   ___JUMPINT(___SET_NARGS(1),___PRC(100),___L_c_23_def_3f_)
___DEF_SLBL(2,___L2_c_23_def_2d_val)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_def_2d_val)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(1))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_def_2d_val)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_def_2d_val)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_def_2d_val)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_tst
#undef ___PH_LBL0
#define ___PH_LBL0 235
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_tst)
___DEF_P_HLBL(___L1_c_23_new_2d_tst)
___DEF_P_HLBL(___L2_c_23_new_2d_tst)
___DEF_P_HLBL(___L3_c_23_new_2d_tst)
___DEF_P_HLBL(___L4_c_23_new_2d_tst)
___DEF_P_HLBL(___L5_c_23_new_2d_tst)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_tst)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L_c_23_new_2d_tst)
   ___BEGIN_ALLOC_LIST(3,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___R1)
   ___END_ALLOC_LIST(3)
   ___SET_R4(___GET_LIST(3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(10)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_tst)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_tst)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_tst)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_tst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-10))
   ___ADD_VECTOR_ELEM(6,___STK(-11))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-8),___FIX(1L),___STK(-11))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-7),___FIX(1L),___STK(-11))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-6),___FIX(1L),___STK(-11))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_tst)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_tst)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_tst_2d_pre
#undef ___PH_LBL0
#define ___PH_LBL0 242
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_tst_2d_pre)
___DEF_P_HLBL(___L1_c_23_tst_2d_pre)
___DEF_P_HLBL(___L2_c_23_tst_2d_pre)
___DEF_P_HLBL(___L3_c_23_tst_2d_pre)
___DEF_P_HLBL(___L4_c_23_tst_2d_pre)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_tst_2d_pre)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_tst_2d_pre)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_tst_2d_pre)
   ___JUMPINT(___SET_NARGS(1),___PRC(112),___L_c_23_tst_3f_)
___DEF_SLBL(2,___L2_c_23_tst_2d_pre)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_tst_2d_pre)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(2))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_tst_2d_pre)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_tst_2d_pre)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_tst_2d_pre)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_tst_2d_con
#undef ___PH_LBL0
#define ___PH_LBL0 248
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_tst_2d_con)
___DEF_P_HLBL(___L1_c_23_tst_2d_con)
___DEF_P_HLBL(___L2_c_23_tst_2d_con)
___DEF_P_HLBL(___L3_c_23_tst_2d_con)
___DEF_P_HLBL(___L4_c_23_tst_2d_con)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_tst_2d_con)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_tst_2d_con)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_tst_2d_con)
   ___JUMPINT(___SET_NARGS(1),___PRC(112),___L_c_23_tst_3f_)
___DEF_SLBL(2,___L2_c_23_tst_2d_con)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_tst_2d_con)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(3))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_tst_2d_con)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_tst_2d_con)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CADR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_tst_2d_con)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_tst_2d_alt
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
___DEF_P_HLBL(___L0_c_23_tst_2d_alt)
___DEF_P_HLBL(___L1_c_23_tst_2d_alt)
___DEF_P_HLBL(___L2_c_23_tst_2d_alt)
___DEF_P_HLBL(___L3_c_23_tst_2d_alt)
___DEF_P_HLBL(___L4_c_23_tst_2d_alt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_tst_2d_alt)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_tst_2d_alt)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_tst_2d_alt)
   ___JUMPINT(___SET_NARGS(1),___PRC(112),___L_c_23_tst_3f_)
___DEF_SLBL(2,___L2_c_23_tst_2d_alt)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_tst_2d_alt)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(4))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_tst_2d_alt)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_tst_2d_alt)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CADDR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_tst_2d_alt)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_conj
#undef ___PH_LBL0
#define ___PH_LBL0 260
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_conj)
___DEF_P_HLBL(___L1_c_23_new_2d_conj)
___DEF_P_HLBL(___L2_c_23_new_2d_conj)
___DEF_P_HLBL(___L3_c_23_new_2d_conj)
___DEF_P_HLBL(___L4_c_23_new_2d_conj)
___DEF_P_HLBL(___L5_c_23_new_2d_conj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_conj)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_conj)
   ___BEGIN_ALLOC_LIST(2,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R4(___GET_LIST(2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(11)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_conj)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_conj)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_conj)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_conj_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-6))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-9))
   ___ADD_VECTOR_ELEM(6,___STK(-11))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-8),___FIX(1L),___STK(-11))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-7),___FIX(1L),___STK(-11))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_conj)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_conj)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_conj_2d_pre
#undef ___PH_LBL0
#define ___PH_LBL0 267
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_conj_2d_pre)
___DEF_P_HLBL(___L1_c_23_conj_2d_pre)
___DEF_P_HLBL(___L2_c_23_conj_2d_pre)
___DEF_P_HLBL(___L3_c_23_conj_2d_pre)
___DEF_P_HLBL(___L4_c_23_conj_2d_pre)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_conj_2d_pre)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_conj_2d_pre)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_conj_2d_pre)
   ___JUMPINT(___SET_NARGS(1),___PRC(120),___L_c_23_conj_3f_)
___DEF_SLBL(2,___L2_c_23_conj_2d_pre)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_conj_2d_pre)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(5))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_conj_2d_pre)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_conj_2d_pre)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_conj_2d_pre)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_conj_2d_alt
#undef ___PH_LBL0
#define ___PH_LBL0 273
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_conj_2d_alt)
___DEF_P_HLBL(___L1_c_23_conj_2d_alt)
___DEF_P_HLBL(___L2_c_23_conj_2d_alt)
___DEF_P_HLBL(___L3_c_23_conj_2d_alt)
___DEF_P_HLBL(___L4_c_23_conj_2d_alt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_conj_2d_alt)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_conj_2d_alt)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_conj_2d_alt)
   ___JUMPINT(___SET_NARGS(1),___PRC(120),___L_c_23_conj_3f_)
___DEF_SLBL(2,___L2_c_23_conj_2d_alt)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_conj_2d_alt)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_conj_2d_alt)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_conj_2d_alt)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CADR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_conj_2d_alt)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_disj
#undef ___PH_LBL0
#define ___PH_LBL0 279
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_disj)
___DEF_P_HLBL(___L1_c_23_new_2d_disj)
___DEF_P_HLBL(___L2_c_23_new_2d_disj)
___DEF_P_HLBL(___L3_c_23_new_2d_disj)
___DEF_P_HLBL(___L4_c_23_new_2d_disj)
___DEF_P_HLBL(___L5_c_23_new_2d_disj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_disj)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_disj)
   ___BEGIN_ALLOC_LIST(2,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___END_ALLOC_LIST(2)
   ___SET_R4(___GET_LIST(2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(11)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_disj)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_disj)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_disj)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_disj_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-6))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-9))
   ___ADD_VECTOR_ELEM(6,___STK(-11))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-8),___FIX(1L),___STK(-11))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-7),___FIX(1L),___STK(-11))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_disj)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_disj)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_disj_2d_pre
#undef ___PH_LBL0
#define ___PH_LBL0 286
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_disj_2d_pre)
___DEF_P_HLBL(___L1_c_23_disj_2d_pre)
___DEF_P_HLBL(___L2_c_23_disj_2d_pre)
___DEF_P_HLBL(___L3_c_23_disj_2d_pre)
___DEF_P_HLBL(___L4_c_23_disj_2d_pre)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_disj_2d_pre)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_disj_2d_pre)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_disj_2d_pre)
   ___JUMPINT(___SET_NARGS(1),___PRC(128),___L_c_23_disj_3f_)
___DEF_SLBL(2,___L2_c_23_disj_2d_pre)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_disj_2d_pre)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(7))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_disj_2d_pre)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_disj_2d_pre)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_disj_2d_pre)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_disj_2d_alt
#undef ___PH_LBL0
#define ___PH_LBL0 292
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_disj_2d_alt)
___DEF_P_HLBL(___L1_c_23_disj_2d_alt)
___DEF_P_HLBL(___L2_c_23_disj_2d_alt)
___DEF_P_HLBL(___L3_c_23_disj_2d_alt)
___DEF_P_HLBL(___L4_c_23_disj_2d_alt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_disj_2d_alt)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_disj_2d_alt)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_disj_2d_alt)
   ___JUMPINT(___SET_NARGS(1),___PRC(128),___L_c_23_disj_3f_)
___DEF_SLBL(2,___L2_c_23_disj_2d_alt)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_disj_2d_alt)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(8))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_disj_2d_alt)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_disj_2d_alt)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CADR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_disj_2d_alt)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_prc
#undef ___PH_LBL0
#define ___PH_LBL0 298
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_prc)
___DEF_P_HLBL(___L1_c_23_new_2d_prc)
___DEF_P_HLBL(___L2_c_23_new_2d_prc)
___DEF_P_HLBL(___L3_c_23_new_2d_prc)
___DEF_P_HLBL(___L4_c_23_new_2d_prc)
___DEF_P_HLBL(___L5_c_23_new_2d_prc)
___DEF_P_HLBL(___L6_c_23_new_2d_prc)
___DEF_P_HLBL(___L7_c_23_new_2d_prc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_prc)
   ___IF_NARGS_EQ(9,___NOTHING)
   ___WRONG_NARGS(0,9,0,0)
___DEF_GLBL(___L_c_23_new_2d_prc)
   ___SET_R4(___CONS(___R3,___NUL))
   ___SET_STK(1,___STK(-1))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(10)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_prc)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_prc)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_prc)
   ___BEGIN_ALLOC_VECTOR(14)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_prc_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-4))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-14))
   ___ADD_VECTOR_ELEM(6,___STK(-15))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-13))
   ___ADD_VECTOR_ELEM(9,___STK(-12))
   ___ADD_VECTOR_ELEM(10,___STK(-9))
   ___ADD_VECTOR_ELEM(11,___STK(-10))
   ___ADD_VECTOR_ELEM(12,___STK(-7))
   ___ADD_VECTOR_ELEM(13,___STK(-6))
   ___END_ALLOC_VECTOR(14)
   ___SET_R1(___GET_VECTOR(14))
   ___SET_STK(-15,___R1)
   ___SET_R2(___STK(-11))
   ___SET_R0(___LBL(6))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_prc)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L9_c_23_new_2d_prc)
   ___END_IF
   ___GOTO(___L10_c_23_new_2d_prc)
___DEF_GLBL(___L8_c_23_new_2d_prc)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L10_c_23_new_2d_prc)
   ___END_IF
___DEF_GLBL(___L9_c_23_new_2d_prc)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(2L),___R1)
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_prc)
   ___GOTO(___L8_c_23_new_2d_prc)
___DEF_GLBL(___L10_c_23_new_2d_prc)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_new_2d_prc)
   ___SET_STK(-14,___STK(-15))
   ___VECTORSET(___STK(-5),___FIX(1L),___STK(-14))
   ___SET_R1(___STK(-15))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_new_2d_prc)
   ___ADJFP(-16)
   ___JUMPPRM(___NOTHING,___STK(8))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_body
#undef ___PH_LBL0
#define ___PH_LBL0 307
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_body)
___DEF_P_HLBL(___L1_c_23_prc_2d_body)
___DEF_P_HLBL(___L2_c_23_prc_2d_body)
___DEF_P_HLBL(___L3_c_23_prc_2d_body)
___DEF_P_HLBL(___L4_c_23_prc_2d_body)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_body)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_body)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_prc_2d_body)
   ___JUMPINT(___SET_NARGS(1),___PRC(136),___L_c_23_prc_3f_)
___DEF_SLBL(2,___L2_c_23_prc_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_prc_2d_body)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(9))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_prc_2d_body)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_prc_2d_body)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_prc_2d_body)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 313
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
   ___SET_STK(1,___R1)
   ___ADJFP(1)
   ___IF(___NOT(___NOT(___FALSEP(___VECTORREF(___STK(0),___FIX(12L))))))
   ___GOTO(___L1_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(13L)))
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_call
#undef ___PH_LBL0
#define ___PH_LBL0 315
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_call)
___DEF_P_HLBL(___L1_c_23_new_2d_call)
___DEF_P_HLBL(___L2_c_23_new_2d_call)
___DEF_P_HLBL(___L3_c_23_new_2d_call)
___DEF_P_HLBL(___L4_c_23_new_2d_call)
___DEF_P_HLBL(___L5_c_23_new_2d_call)
___DEF_P_HLBL(___L6_c_23_new_2d_call)
___DEF_P_HLBL(___L7_c_23_new_2d_call)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_call)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_call)
   ___SET_R4(___CONS(___R2,___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(11)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_call)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_call)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_call)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_app_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-6))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-9))
   ___ADD_VECTOR_ELEM(6,___STK(-11))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_STK(-11,___R1)
   ___VECTORSET(___STK(-8),___FIX(1L),___STK(-11))
   ___SET_STK(-11,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_call)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L9_c_23_new_2d_call)
   ___END_IF
   ___GOTO(___L10_c_23_new_2d_call)
___DEF_GLBL(___L8_c_23_new_2d_call)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L10_c_23_new_2d_call)
   ___END_IF
___DEF_GLBL(___L9_c_23_new_2d_call)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_call)
   ___GOTO(___L8_c_23_new_2d_call)
___DEF_GLBL(___L10_c_23_new_2d_call)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_c_23_new_2d_call)
   ___SET_R1(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_new_2d_call)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_call_2a_
#undef ___PH_LBL0
#define ___PH_LBL0 324
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_call_2a_)
___DEF_P_HLBL(___L1_c_23_new_2d_call_2a_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_call_2a_)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_call_2a_)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_call_2a_)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_app_2d_oper
#undef ___PH_LBL0
#define ___PH_LBL0 327
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_app_2d_oper)
___DEF_P_HLBL(___L1_c_23_app_2d_oper)
___DEF_P_HLBL(___L2_c_23_app_2d_oper)
___DEF_P_HLBL(___L3_c_23_app_2d_oper)
___DEF_P_HLBL(___L4_c_23_app_2d_oper)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_app_2d_oper)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_app_2d_oper)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_app_2d_oper)
   ___JUMPINT(___SET_NARGS(1),___PRC(168),___L_c_23_app_3f_)
___DEF_SLBL(2,___L2_c_23_app_2d_oper)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_app_2d_oper)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(10))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_app_2d_oper)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_app_2d_oper)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_app_2d_oper)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_app_2d_args
#undef ___PH_LBL0
#define ___PH_LBL0 333
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_app_2d_args)
___DEF_P_HLBL(___L1_c_23_app_2d_args)
___DEF_P_HLBL(___L2_c_23_app_2d_args)
___DEF_P_HLBL(___L3_c_23_app_2d_args)
___DEF_P_HLBL(___L4_c_23_app_2d_args)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_app_2d_args)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_app_2d_args)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_app_2d_args)
   ___JUMPINT(___SET_NARGS(1),___PRC(168),___L_c_23_app_3f_)
___DEF_SLBL(2,___L2_c_23_app_2d_args)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_app_2d_args)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(11))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_app_2d_args)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_app_2d_args)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CDR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_app_2d_args)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_oper_2d_pos_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 339
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_oper_2d_pos_3f_)
___DEF_P_HLBL(___L1_c_23_oper_2d_pos_3f_)
___DEF_P_HLBL(___L2_c_23_oper_2d_pos_3f_)
___DEF_P_HLBL(___L3_c_23_oper_2d_pos_3f_)
___DEF_P_HLBL(___L4_c_23_oper_2d_pos_3f_)
___DEF_P_HLBL(___L5_c_23_oper_2d_pos_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_oper_2d_pos_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_oper_2d_pos_3f_)
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___STK(1),___FIX(1L)))
   ___ADJFP(1)
   ___IF(___FALSEP(___R2))
   ___GOTO(___L8_c_23_oper_2d_pos_3f_)
   ___END_IF
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_oper_2d_pos_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(168),___L_c_23_app_3f_)
___DEF_SLBL(2,___L2_c_23_oper_2d_pos_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L7_c_23_oper_2d_pos_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_oper_2d_pos_3f_)
   ___GOTO(___L6_c_23_oper_2d_pos_3f_)
___DEF_SLBL(4,___L4_c_23_oper_2d_pos_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___STK(-6))))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_oper_2d_pos_3f_)
___DEF_GLBL(___L6_c_23_oper_2d_pos_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23_oper_2d_pos_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(327),___L_c_23_app_2d_oper)
___DEF_GLBL(___L8_c_23_oper_2d_pos_3f_)
   ___SET_R1(___FAL)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_fut
#undef ___PH_LBL0
#define ___PH_LBL0 346
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_fut)
___DEF_P_HLBL(___L1_c_23_new_2d_fut)
___DEF_P_HLBL(___L2_c_23_new_2d_fut)
___DEF_P_HLBL(___L3_c_23_new_2d_fut)
___DEF_P_HLBL(___L4_c_23_new_2d_fut)
___DEF_P_HLBL(___L5_c_23_new_2d_fut)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_fut)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_new_2d_fut)
   ___SET_R4(___CONS(___R3,___NUL))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_new_2d_fut)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_new_2d_fut)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_fut)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_fut_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-3))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-5))
   ___ADD_VECTOR_ELEM(6,___STK(-6))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_STK(-6,___R1)
   ___VECTORSET(___STK(-4),___FIX(1L),___STK(-6))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_new_2d_fut)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_fut)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_fut_2d_val
#undef ___PH_LBL0
#define ___PH_LBL0 353
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_fut_2d_val)
___DEF_P_HLBL(___L1_c_23_fut_2d_val)
___DEF_P_HLBL(___L2_c_23_fut_2d_val)
___DEF_P_HLBL(___L3_c_23_fut_2d_val)
___DEF_P_HLBL(___L4_c_23_fut_2d_val)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_fut_2d_val)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_fut_2d_val)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_fut_2d_val)
   ___JUMPINT(___SET_NARGS(1),___PRC(176),___L_c_23_fut_3f_)
___DEF_SLBL(2,___L2_c_23_fut_2d_val)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_fut_2d_val)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(12))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_fut_2d_val)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),306,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L5_c_23_fut_2d_val)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CAR(___R1))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_fut_2d_val)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_disj_2d_call
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
___DEF_P_HLBL(___L0_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L1_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L2_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L3_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L4_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L5_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L6_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L7_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L8_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L9_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L10_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L11_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L12_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L13_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L14_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L15_c_23_new_2d_disj_2d_call)
___DEF_P_HLBL(___L16_c_23_new_2d_disj_2d_call)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_disj_2d_call)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L_c_23_new_2d_disj_2d_call)
   ___SET_STK(1,___STK(-1))
   ___SET_STK(2,___STK(0))
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___SET_STK(5,___R2)
   ___SET_STK(6,___R3)
   ___SET_R1(___STK(-1))
   ___SET_R2(___SYM_cond_2d_temp)
   ___SET_R0(___LBL(2))
   ___ADJFP(10)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_disj_2d_call)
   ___JUMPINT(___SET_NARGS(2),___PRC(392),___L_c_23_new_2d_temp_2d_variable)
___DEF_SLBL(2,___L2_c_23_new_2d_disj_2d_call)
   ___SET_R2(___CONS(___R1,___NUL))
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___R2)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_new_2d_disj_2d_call)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(4,___L4_c_23_new_2d_disj_2d_call)
   ___SET_STK(-3,___STK(-15))
   ___SET_STK(-2,___STK(-14))
   ___SET_STK(-1,___FAL)
   ___SET_STK(0,___FAL)
   ___SET_STK(1,___STK(-6))
   ___SET_STK(2,___NUL)
   ___SET_STK(9,___STK(-15))
   ___SET_STK(10,___R1)
   ___SET_STK(-14,___R1)
   ___SET_R3(___STK(-7))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-15))
   ___SET_R0(___LBL(5))
   ___ADJFP(16)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(5,___L5_c_23_new_2d_disj_2d_call)
   ___SET_STK(-22,___R1)
   ___SET_STK(1,___STK(-31))
   ___SET_R3(___STK(-23))
   ___SET_R2(___STK(-30))
   ___SET_R1(___STK(-31))
   ___SET_R0(___LBL(6))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(6,___L6_c_23_new_2d_disj_2d_call)
   ___SET_R3(___CONS(___R1,___NUL))
   ___SET_R2(___STK(-29))
   ___SET_R1(___STK(-34))
   ___SET_R0(___LBL(8))
   ___ADJFP(-3)
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_new_2d_disj_2d_call)
   ___JUMPINT(___SET_NARGS(4),___PRC(324),___L_c_23_new_2d_call_2a_)
___DEF_SLBL(8,___L8_c_23_new_2d_disj_2d_call)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-24))
   ___SET_R0(___LBL(9))
   ___SET_R1(___STK(-22))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(5),___PRC(235),___L_c_23_new_2d_tst)
___DEF_SLBL(9,___L9_c_23_new_2d_disj_2d_call)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(10))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(10,___L10_c_23_new_2d_disj_2d_call)
   ___SET_R2(___CONS(___STK(-6),___NUL))
   ___SET_R3(___CONS(___R1,___R2))
   ___SET_STK(-11,___R1)
   ___SET_STK(-10,___R2)
   ___SET_STK(-6,___R3)
   ___SET_R0(___LBL(12))
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_new_2d_disj_2d_call)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(12,___L12_c_23_new_2d_disj_2d_call)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_app_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-6))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-8))
   ___ADD_VECTOR_ELEM(6,___STK(-9))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___VECTORSET(___STK(-11),___FIX(1L),___R1)
   ___SET_STK(-11,___R1)
   ___SET_R2(___STK(-10))
   ___SET_R0(___LBL(15))
   ___ADJFP(-4)
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_new_2d_disj_2d_call)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L18_c_23_new_2d_disj_2d_call)
   ___END_IF
   ___GOTO(___L19_c_23_new_2d_disj_2d_call)
___DEF_GLBL(___L17_c_23_new_2d_disj_2d_call)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L19_c_23_new_2d_disj_2d_call)
   ___END_IF
___DEF_GLBL(___L18_c_23_new_2d_disj_2d_call)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_new_2d_disj_2d_call)
   ___GOTO(___L17_c_23_new_2d_disj_2d_call)
___DEF_GLBL(___L19_c_23_new_2d_disj_2d_call)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(15,___L15_c_23_new_2d_disj_2d_call)
   ___SET_R1(___STK(-7))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_new_2d_disj_2d_call)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_seq
#undef ___PH_LBL0
#define ___PH_LBL0 377
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_seq)
___DEF_P_HLBL(___L1_c_23_new_2d_seq)
___DEF_P_HLBL(___L2_c_23_new_2d_seq)
___DEF_P_HLBL(___L3_c_23_new_2d_seq)
___DEF_P_HLBL(___L4_c_23_new_2d_seq)
___DEF_P_HLBL(___L5_c_23_new_2d_seq)
___DEF_P_HLBL(___L6_c_23_new_2d_seq)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_seq)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_new_2d_seq)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___SET_R2(___SYM_begin_2d_temp)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_seq)
   ___JUMPINT(___SET_NARGS(2),___PRC(392),___L_c_23_new_2d_temp_2d_variable)
___DEF_SLBL(2,___L2_c_23_new_2d_seq)
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-1,___STK(-5))
   ___SET_STK(5,___STK(-7))
   ___SET_STK(6,___STK(-5))
   ___SET_STK(7,___FAL)
   ___SET_STK(8,___FAL)
   ___SET_STK(9,___CONS(___R1,___NUL))
   ___SET_STK(10,___NUL)
   ___SET_R3(___STK(-3))
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(4))
   ___ADJFP(10)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_new_2d_seq)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(4,___L4_c_23_new_2d_seq)
   ___SET_R2(___CONS(___STK(-8),___NUL))
   ___SET_STK(-11,___STK(-6))
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-10))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_new_2d_seq)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_new_2d_seq)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_let
#undef ___PH_LBL0
#define ___PH_LBL0 385
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_let)
___DEF_P_HLBL(___L1_c_23_new_2d_let)
___DEF_P_HLBL(___L2_c_23_new_2d_let)
___DEF_P_HLBL(___L3_c_23_new_2d_let)
___DEF_P_HLBL(___L4_c_23_new_2d_let)
___DEF_P_HLBL(___L5_c_23_new_2d_let)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_let)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L_c_23_new_2d_let)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L6_c_23_new_2d_let)
   ___END_IF
   ___SET_STK(1,___STK(-1))
   ___SET_R4(___VECTORREF(___STK(1),___FIX(6L)))
   ___SET_STK(1,___STK(-1))
   ___SET_STK(-1,___R4)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(5L)))
   ___SET_STK(1,___R4)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___STK(0))
   ___SET_STK(7,___VECTORREF(___STK(4),___FIX(6L)))
   ___SET_STK(4,___STK(0))
   ___SET_STK(8,___VECTORREF(___STK(4),___FIX(5L)))
   ___SET_STK(4,___STK(0))
   ___SET_STK(9,___VECTORREF(___STK(4),___FIX(8L)))
   ___SET_STK(10,___VECTORREF(___STK(0),___FIX(9L)))
   ___SET_STK(0,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(14)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_let)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(2,___L2_c_23_new_2d_let)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___NUL)
   ___SET_R3(___STK(-14))
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(3))
   ___ADJFP(-2)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(3,___L3_c_23_new_2d_let)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(4,___L4_c_23_new_2d_let)
   ___SET_R3(___R1)
   ___SET_R0(___STK(-4))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_new_2d_let)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_GLBL(___L6_c_23_new_2d_let)
   ___SET_R1(___R3)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_temp_2d_variable
#undef ___PH_LBL0
#define ___PH_LBL0 392
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L1_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L2_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L3_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L4_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L5_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L6_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L7_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L8_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L9_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L10_c_23_new_2d_temp_2d_variable)
___DEF_P_HLBL(___L11_c_23_new_2d_temp_2d_variable)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_temp_2d_variable)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_new_2d_temp_2d_variable)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_temp_2d_variable)
   ___JUMPPRM(___SET_NARGS(1),___PRM_symbol_2d__3e_string)
___DEF_SLBL(2,___L2_c_23_new_2d_temp_2d_variable)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),225,___G_c_23_temp_2d_variable_2d_stamp)
___DEF_SLBL(3,___L3_c_23_new_2d_temp_2d_variable)
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_number_2d__3e_string)
___DEF_SLBL(4,___L4_c_23_new_2d_temp_2d_variable)
   ___SET_R3(___R1)
   ___SET_R2(___SUB(13))
   ___SET_R0(___LBL(5))
   ___SET_R1(___STK(-5))
   ___JUMPPRM(___SET_NARGS(3),___PRM_string_2d_append)
___DEF_SLBL(5,___L5_c_23_new_2d_temp_2d_variable)
   ___SET_R0(___LBL(6))
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___DEF_SLBL(6,___L6_c_23_new_2d_temp_2d_variable)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),379,___G_c_23_ptset_2d_empty)
___DEF_SLBL(7,___L7_c_23_new_2d_temp_2d_variable)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),379,___G_c_23_ptset_2d_empty)
___DEF_SLBL(8,___L8_c_23_new_2d_temp_2d_variable)
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),363,___G_c_23_next_2d_var_2d_stamp)
___DEF_SLBL(9,___L9_c_23_new_2d_temp_2d_variable)
   ___BEGIN_ALLOC_VECTOR(11)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_var_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-5))
   ___ADD_VECTOR_ELEM(2,___TRU)
   ___ADD_VECTOR_ELEM(3,___STK(-4))
   ___ADD_VECTOR_ELEM(4,___STK(-3))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___FAL)
   ___ADD_VECTOR_ELEM(7,___FAL)
   ___ADD_VECTOR_ELEM(8,___R1)
   ___ADD_VECTOR_ELEM(9,___FAL)
   ___ADD_VECTOR_ELEM(10,___FAL)
   ___END_ALLOC_VECTOR(11)
   ___SET_R1(___GET_VECTOR(11))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_new_2d_temp_2d_variable)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_new_2d_temp_2d_variable)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_variables
#undef ___PH_LBL0
#define ___PH_LBL0 405
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_variables)
___DEF_P_HLBL(___L1_c_23_new_2d_variables)
___DEF_P_HLBL(___L2_c_23_new_2d_variables)
___DEF_P_HLBL(___L3_c_23_new_2d_variables)
___DEF_P_HLBL(___L4_c_23_new_2d_variables)
___DEF_P_HLBL(___L5_c_23_new_2d_variables)
___DEF_P_HLBL(___L6_c_23_new_2d_variables)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_variables)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_new_2d_variables)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_variables)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L7_c_23_new_2d_variables)
   ___END_IF
   ___GOTO(___L8_c_23_new_2d_variables)
___DEF_SLBL(2,___L2_c_23_new_2d_variables)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(4))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L8_c_23_new_2d_variables)
   ___END_IF
___DEF_GLBL(___L7_c_23_new_2d_variables)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_new_2d_variables)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_GLBL(___L8_c_23_new_2d_variables)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(4,___L4_c_23_new_2d_variables)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_new_2d_variables)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_new_2d_variables)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_new_2d_variable
#undef ___PH_LBL0
#define ___PH_LBL0 413
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_new_2d_variable)
___DEF_P_HLBL(___L1_c_23_new_2d_variable)
___DEF_P_HLBL(___L2_c_23_new_2d_variable)
___DEF_P_HLBL(___L3_c_23_new_2d_variable)
___DEF_P_HLBL(___L4_c_23_new_2d_variable)
___DEF_P_HLBL(___L5_c_23_new_2d_variable)
___DEF_P_HLBL(___L6_c_23_new_2d_variable)
___DEF_P_HLBL(___L7_c_23_new_2d_variable)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_new_2d_variable)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_new_2d_variable)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_new_2d_variable)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),390,___G_c_23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_new_2d_variable)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),379,___G_c_23_ptset_2d_empty)
___DEF_SLBL(3,___L3_c_23_new_2d_variable)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),379,___G_c_23_ptset_2d_empty)
___DEF_SLBL(4,___L4_c_23_new_2d_variable)
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),363,___G_c_23_next_2d_var_2d_stamp)
___DEF_SLBL(5,___L5_c_23_new_2d_variable)
   ___BEGIN_ALLOC_VECTOR(11)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_var_2d_tag)
   ___ADD_VECTOR_ELEM(1,___STK(-5))
   ___ADD_VECTOR_ELEM(2,___TRU)
   ___ADD_VECTOR_ELEM(3,___STK(-4))
   ___ADD_VECTOR_ELEM(4,___STK(-3))
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___FAL)
   ___ADD_VECTOR_ELEM(7,___FAL)
   ___ADD_VECTOR_ELEM(8,___R1)
   ___ADD_VECTOR_ELEM(9,___FAL)
   ___ADD_VECTOR_ELEM(10,___FAL)
   ___END_ALLOC_VECTOR(11)
   ___SET_R1(___GET_VECTOR(11))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_new_2d_variable)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_new_2d_variable)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_set_2d_prc_2d_names_21_
#undef ___PH_LBL0
#define ___PH_LBL0 422
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_set_2d_prc_2d_names_21_)
___DEF_P_HLBL(___L1_c_23_set_2d_prc_2d_names_21_)
___DEF_P_HLBL(___L2_c_23_set_2d_prc_2d_names_21_)
___DEF_P_HLBL(___L3_c_23_set_2d_prc_2d_names_21_)
___DEF_P_HLBL(___L4_c_23_set_2d_prc_2d_names_21_)
___DEF_P_HLBL(___L5_c_23_set_2d_prc_2d_names_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_set_2d_prc_2d_names_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_set_2d_prc_2d_names_21_)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_set_2d_prc_2d_names_21_)
   ___GOTO(___L7_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(2,___L2_c_23_set_2d_prc_2d_names_21_)
   ___VECTORSET(___STK(-3),___FIX(8L),___R1)
___DEF_GLBL(___L6_c_23_set_2d_prc_2d_names_21_)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_set_2d_prc_2d_names_21_)
___DEF_GLBL(___L7_c_23_set_2d_prc_2d_names_21_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L8_c_23_set_2d_prc_2d_names_21_)
   ___END_IF
   ___SET_R3(___CAR(___R1))
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_set_2d_prc_2d_names_21_)
   ___JUMPINT(___SET_NARGS(1),___PRC(136),___L_c_23_prc_3f_)
___DEF_SLBL(5,___L5_c_23_set_2d_prc_2d_names_21_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L6_c_23_set_2d_prc_2d_names_21_)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM_symbol_2d__3e_string)
___DEF_GLBL(___L8_c_23_set_2d_prc_2d_names_21_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_free_2d_variables
#undef ___PH_LBL0
#define ___PH_LBL0 429
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_free_2d_variables)
___DEF_P_HLBL(___L1_c_23_free_2d_variables)
___DEF_P_HLBL(___L2_c_23_free_2d_variables)
___DEF_P_HLBL(___L3_c_23_free_2d_variables)
___DEF_P_HLBL(___L4_c_23_free_2d_variables)
___DEF_P_HLBL(___L5_c_23_free_2d_variables)
___DEF_P_HLBL(___L6_c_23_free_2d_variables)
___DEF_P_HLBL(___L7_c_23_free_2d_variables)
___DEF_P_HLBL(___L8_c_23_free_2d_variables)
___DEF_P_HLBL(___L9_c_23_free_2d_variables)
___DEF_P_HLBL(___L10_c_23_free_2d_variables)
___DEF_P_HLBL(___L11_c_23_free_2d_variables)
___DEF_P_HLBL(___L12_c_23_free_2d_variables)
___DEF_P_HLBL(___L13_c_23_free_2d_variables)
___DEF_P_HLBL(___L14_c_23_free_2d_variables)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_free_2d_variables)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_free_2d_variables)
   ___GOTO(___L17_c_23_free_2d_variables)
___DEF_GLBL(___L15_c_23_free_2d_variables)
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R0(___LBL(4))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_free_2d_variables)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L24_c_23_free_2d_variables)
   ___END_IF
___DEF_GLBL(___L16_c_23_free_2d_variables)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(11))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_free_2d_variables)
___DEF_GLBL(___L17_c_23_free_2d_variables)
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___STK(1),___FIX(3L)))
   ___ADJFP(1)
   ___IF(___EQP(___R2,___TRU))
   ___GOTO(___L15_c_23_free_2d_variables)
   ___END_IF
___DEF_GLBL(___L18_c_23_free_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_free_2d_variables)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(4,___L4_c_23_free_2d_variables)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),409,___G_c_23_varset_2d_union_2d_multi)
___DEF_SLBL(5,___L5_c_23_free_2d_variables)
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-4,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(0L)))
   ___IF(___EQP(___R2,___GLO_c_23_ref_2d_tag))
   ___GOTO(___L23_c_23_free_2d_variables)
   ___END_IF
   ___SET_STK(-4,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(0L)))
   ___IF(___EQP(___R2,___GLO_c_23_set_2d_tag))
   ___GOTO(___L23_c_23_free_2d_variables)
   ___END_IF
   ___SET_STK(-4,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(0L)))
   ___IF(___EQP(___R2,___GLO_c_23_prc_2d_tag))
   ___GOTO(___L22_c_23_free_2d_variables)
   ___END_IF
   ___SET_STK(-4,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(0L)))
   ___IF(___EQP(___R2,___GLO_c_23_app_2d_tag))
   ___GOTO(___L21_c_23_free_2d_variables)
   ___END_IF
   ___GOTO(___L19_c_23_free_2d_variables)
___DEF_SLBL(6,___L6_c_23_free_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___IF(___EQP(___R1,___GLO_c_23_prc_2d_tag))
   ___GOTO(___L20_c_23_free_2d_variables)
   ___END_IF
   ___SET_R1(___STK(-4))
___DEF_GLBL(___L19_c_23_free_2d_variables)
   ___VECTORSET(___STK(-5),___FIX(3L),___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-7)
   ___GOTO(___L18_c_23_free_2d_variables)
___DEF_GLBL(___L20_c_23_free_2d_variables)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(327),___L_c_23_app_2d_oper)
___DEF_SLBL(7,___L7_c_23_free_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(10L)))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),354,___G_c_23_list_2d__3e_varset)
___DEF_SLBL(8,___L8_c_23_free_2d_variables)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),406,___G_c_23_varset_2d_difference)
___DEF_SLBL(9,___L9_c_23_free_2d_variables)
   ___GOTO(___L19_c_23_free_2d_variables)
___DEF_GLBL(___L21_c_23_free_2d_variables)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(327),___L_c_23_app_2d_oper)
___DEF_GLBL(___L22_c_23_free_2d_variables)
   ___SET_STK(-4,___STK(-6))
   ___SET_STK(-3,___R1)
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(10L)))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),354,___G_c_23_list_2d__3e_varset)
___DEF_SLBL(10,___L10_c_23_free_2d_variables)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),406,___G_c_23_varset_2d_difference)
___DEF_GLBL(___L23_c_23_free_2d_variables)
   ___SET_STK(-4,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(8L)))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),405,___G_c_23_varset_2d_adjoin)
___DEF_SLBL(11,___L11_c_23_free_2d_variables)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(12))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L16_c_23_free_2d_variables)
   ___END_IF
___DEF_GLBL(___L24_c_23_free_2d_variables)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(12,___L12_c_23_free_2d_variables)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_free_2d_variables)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_free_2d_variables)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bound_2d_free_2d_variables
#undef ___PH_LBL0
#define ___PH_LBL0 445
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bound_2d_free_2d_variables)
___DEF_P_HLBL(___L1_c_23_bound_2d_free_2d_variables)
___DEF_P_HLBL(___L2_c_23_bound_2d_free_2d_variables)
___DEF_P_HLBL(___L3_c_23_bound_2d_free_2d_variables)
___DEF_P_HLBL(___L4_c_23_bound_2d_free_2d_variables)
___DEF_P_HLBL(___L5_c_23_bound_2d_free_2d_variables)
___DEF_P_HLBL(___L6_c_23_bound_2d_free_2d_variables)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bound_2d_free_2d_variables)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_bound_2d_free_2d_variables)
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___STK(1),___FIX(4L)))
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___R2,___TRU)))
   ___GOTO(___L7_c_23_bound_2d_free_2d_variables)
   ___END_IF
   ___SET_STK(0,___R1)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bound_2d_free_2d_variables)
   ___JUMPINT(___SET_NARGS(1),___PRC(429),___L_c_23_free_2d_variables)
___DEF_SLBL(2,___L2_c_23_bound_2d_free_2d_variables)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),404,___G_c_23_varset_2d__3e_list)
___DEF_SLBL(3,___L3_c_23_bound_2d_free_2d_variables)
   ___SET_R2(___R1)
   ___SET_R1(___PRC(461))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),349,___G_c_23_keep)
___DEF_SLBL(4,___L4_c_23_bound_2d_free_2d_variables)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),354,___G_c_23_list_2d__3e_varset)
___DEF_SLBL(5,___L5_c_23_bound_2d_free_2d_variables)
   ___VECTORSET(___STK(-7),___FIX(4L),___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
___DEF_GLBL(___L7_c_23_bound_2d_free_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_bound_2d_free_2d_variables)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bound_2d_variables
#undef ___PH_LBL0
#define ___PH_LBL0 453
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bound_2d_variables)
___DEF_P_HLBL(___L1_c_23_bound_2d_variables)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bound_2d_variables)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_bound_2d_variables)
   ___SET_R1(___VECTORREF(___R1,___FIX(10L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bound_2d_variables)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),354,___G_c_23_list_2d__3e_varset)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_mutable_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 456
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_mutable_3f_)
___DEF_P_HLBL(___L1_c_23_mutable_3f_)
___DEF_P_HLBL(___L2_c_23_mutable_3f_)
___DEF_P_HLBL(___L3_c_23_mutable_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_mutable_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_mutable_3f_)
   ___SET_STK(1,___R0)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_mutable_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),380,___G_c_23_ptset_2d_empty_3f_)
___DEF_SLBL(2,___L2_c_23_mutable_3f_)
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_mutable_3f_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bound_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 461
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bound_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bound_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_bound_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_global_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 463
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_global_3f_)
___DEF_P_HLBL(___L1_c_23_global_3f_)
___DEF_P_HLBL(___L2_c_23_global_3f_)
___DEF_P_HLBL(___L3_c_23_global_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_global_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_global_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_global_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(461),___L_c_23_bound_3f_)
___DEF_SLBL(2,___L2_c_23_global_3f_)
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_global_3f_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_global_2d_single_2d_def
#undef ___PH_LBL0
#define ___PH_LBL0 468
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L1_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L2_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L3_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L4_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L5_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L6_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L7_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L8_c_23_global_2d_single_2d_def)
___DEF_P_HLBL(___L9_c_23_global_2d_single_2d_def)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_global_2d_single_2d_def)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_global_2d_single_2d_def)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_global_2d_single_2d_def)
   ___JUMPINT(___SET_NARGS(1),___PRC(463),___L_c_23_global_3f_)
___DEF_SLBL(2,___L2_c_23_global_2d_single_2d_def)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_global_2d_single_2d_def)
   ___END_IF
   ___GOTO(___L12_c_23_global_2d_single_2d_def)
___DEF_SLBL(3,___L3_c_23_global_2d_single_2d_def)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_block_2d_sym)))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L11_c_23_global_2d_single_2d_def)
   ___END_IF
___DEF_GLBL(___L10_c_23_global_2d_single_2d_def)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_global_2d_single_2d_def)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L11_c_23_global_2d_single_2d_def)
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_global_2d_single_2d_def)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(229),___L_c_23_def_2d_val)
___DEF_GLBL(___L12_c_23_global_2d_single_2d_def)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(4L)))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),377,___G_c_23_ptset_2d__3e_list)
___DEF_SLBL(6,___L6_c_23_global_2d_single_2d_def)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L13_c_23_global_2d_single_2d_def)
   ___END_IF
   ___SET_R2(___CDR(___R1))
   ___IF(___NULLP(___R2))
   ___GOTO(___L14_c_23_global_2d_single_2d_def)
   ___END_IF
___DEF_GLBL(___L13_c_23_global_2d_single_2d_def)
   ___SET_R1(___FAL)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_global_2d_single_2d_def)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L14_c_23_global_2d_single_2d_def)
   ___SET_STK(-2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(8))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(1),___PRC(100),___L_c_23_def_3f_)
___DEF_SLBL(8,___L8_c_23_global_2d_single_2d_def)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_global_2d_single_2d_def)
   ___END_IF
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(40),___L_c_23_node_2d_env)
___DEF_SLBL(9,___L9_c_23_global_2d_single_2d_def)
   ___SET_STK(1,___SYM_compilation_2d_strategy)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_separate_2d_sym)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(3))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_global_2d_proc_2d_obj
#undef ___PH_LBL0
#define ___PH_LBL0 479
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_global_2d_proc_2d_obj)
___DEF_P_HLBL(___L1_c_23_global_2d_proc_2d_obj)
___DEF_P_HLBL(___L2_c_23_global_2d_proc_2d_obj)
___DEF_P_HLBL(___L3_c_23_global_2d_proc_2d_obj)
___DEF_P_HLBL(___L4_c_23_global_2d_proc_2d_obj)
___DEF_P_HLBL(___L5_c_23_global_2d_proc_2d_obj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_global_2d_proc_2d_obj)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_global_2d_proc_2d_obj)
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___STK(1),___FIX(8L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_global_2d_proc_2d_obj)
   ___JUMPINT(___SET_NARGS(1),___PRC(463),___L_c_23_global_3f_)
___DEF_SLBL(2,___L2_c_23_global_2d_proc_2d_obj)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L6_c_23_global_2d_proc_2d_obj)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_global_2d_proc_2d_obj)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23_global_2d_proc_2d_obj)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(1L)))
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),394,___G_c_23_target_2e_prim_2d_info)
___DEF_SLBL(4,___L4_c_23_global_2d_proc_2d_obj)
   ___SET_STK(-4,___R1)
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(5L)))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-4))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_global_2d_proc_2d_obj)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(615),___L_c_23_standard_2d_proc_2d_obj)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_global_2d_singly_2d_bound_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 486
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_global_2d_singly_2d_bound_3f_)
___DEF_P_HLBL(___L1_c_23_global_2d_singly_2d_bound_3f_)
___DEF_P_HLBL(___L2_c_23_global_2d_singly_2d_bound_3f_)
___DEF_P_HLBL(___L3_c_23_global_2d_singly_2d_bound_3f_)
___DEF_P_HLBL(___L4_c_23_global_2d_singly_2d_bound_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_global_2d_singly_2d_bound_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_global_2d_singly_2d_bound_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_global_2d_singly_2d_bound_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(468),___L_c_23_global_2d_single_2d_def)
___DEF_SLBL(2,___L2_c_23_global_2d_singly_2d_bound_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_global_2d_singly_2d_bound_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_global_2d_singly_2d_bound_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(479),___L_c_23_global_2d_proc_2d_obj)
___DEF_GLBL(___L5_c_23_global_2d_singly_2d_bound_3f_)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_global_2d_singly_2d_bound_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_app_2d__3e_specialized_2d_proc
#undef ___PH_LBL0
#define ___PH_LBL0 492
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_app_2d__3e_specialized_2d_proc)
___DEF_P_HLBL(___L1_c_23_app_2d__3e_specialized_2d_proc)
___DEF_P_HLBL(___L2_c_23_app_2d__3e_specialized_2d_proc)
___DEF_P_HLBL(___L3_c_23_app_2d__3e_specialized_2d_proc)
___DEF_P_HLBL(___L4_c_23_app_2d__3e_specialized_2d_proc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_app_2d__3e_specialized_2d_proc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_app_2d__3e_specialized_2d_proc)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_app_2d__3e_specialized_2d_proc)
   ___JUMPINT(___SET_NARGS(1),___PRC(327),___L_c_23_app_2d_oper)
___DEF_SLBL(2,___L2_c_23_app_2d__3e_specialized_2d_proc)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(333),___L_c_23_app_2d_args)
___DEF_SLBL(3,___L3_c_23_app_2d__3e_specialized_2d_proc)
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(5L)))
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_app_2d__3e_specialized_2d_proc)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(498),___L_c_23_specialize_2d_app)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_specialize_2d_app
#undef ___PH_LBL0
#define ___PH_LBL0 498
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_specialize_2d_app)
___DEF_P_HLBL(___L1_c_23_specialize_2d_app)
___DEF_P_HLBL(___L2_c_23_specialize_2d_app)
___DEF_P_HLBL(___L3_c_23_specialize_2d_app)
___DEF_P_HLBL(___L4_c_23_specialize_2d_app)
___DEF_P_HLBL(___L5_c_23_specialize_2d_app)
___DEF_P_HLBL(___L6_c_23_specialize_2d_app)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_specialize_2d_app)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_specialize_2d_app)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_specialize_2d_app)
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(2,___L2_c_23_specialize_2d_app)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L9_c_23_specialize_2d_app)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(76),___L_c_23_ref_3f_)
___DEF_SLBL(3,___L3_c_23_specialize_2d_app)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L8_c_23_specialize_2d_app)
   ___END_IF
   ___SET_R1(___FAL)
   ___GOTO(___L7_c_23_specialize_2d_app)
___DEF_SLBL(4,___L4_c_23_specialize_2d_app)
___DEF_GLBL(___L7_c_23_specialize_2d_app)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_specialize_2d_app)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(506),___L_c_23_specialize_2d_proc)
___DEF_GLBL(___L8_c_23_specialize_2d_app)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(479),___L_c_23_global_2d_proc_2d_obj)
___DEF_GLBL(___L9_c_23_specialize_2d_app)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(8L)))
   ___SET_STK(-6,___R1)
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),374,___G_c_23_proc_2d_obj_3f_)
___DEF_SLBL(6,___L6_c_23_specialize_2d_app)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L7_c_23_specialize_2d_app)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___GOTO(___L7_c_23_specialize_2d_app)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_specialize_2d_proc
#undef ___PH_LBL0
#define ___PH_LBL0 506
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L1_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L2_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L3_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L4_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L5_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L6_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L7_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L8_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L9_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L10_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L11_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L12_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L13_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L14_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L15_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L16_c_23_specialize_2d_proc)
___DEF_P_HLBL(___L17_c_23_specialize_2d_proc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_specialize_2d_proc)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_specialize_2d_proc)
   ___SET_STK(1,___R1)
   ___ADJFP(1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L26_c_23_specialize_2d_proc)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_specialize_2d_proc)
   ___JUMPPRM(___SET_NARGS(1),___PRM_length)
___DEF_SLBL(2,___L2_c_23_specialize_2d_proc)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),371,___G_c_23_proc_2d_obj_2d_call_2d_pat)
___DEF_SLBL(3,___L3_c_23_specialize_2d_proc)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),370,___G_c_23_pattern_2d_member_3f_)
___DEF_SLBL(4,___L4_c_23_specialize_2d_proc)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L18_c_23_specialize_2d_proc)
   ___END_IF
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_specialize_2d_proc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L18_c_23_specialize_2d_proc)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_specialize_2d_proc)
   ___GOTO(___L19_c_23_specialize_2d_proc)
___DEF_SLBL(7,___L7_c_23_specialize_2d_proc)
   ___IF(___EQP(___R1,___STK(-4)))
   ___GOTO(___L24_c_23_specialize_2d_proc)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_specialize_2d_proc)
___DEF_GLBL(___L19_c_23_specialize_2d_proc)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(10))
   ___ADJFP(8)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_specialize_2d_proc)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),372,___G_c_23_proc_2d_obj_2d_specialize)
___DEF_SLBL(10,___L10_c_23_specialize_2d_proc)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L21_c_23_specialize_2d_proc)
   ___END_IF
   ___GOTO(___L23_c_23_specialize_2d_proc)
___DEF_SLBL(11,___L11_c_23_specialize_2d_proc)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L22_c_23_specialize_2d_proc)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(8L)))
___DEF_GLBL(___L20_c_23_specialize_2d_proc)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(13))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L23_c_23_specialize_2d_proc)
   ___END_IF
___DEF_GLBL(___L21_c_23_specialize_2d_proc)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(11))
   ___ADJFP(8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_specialize_2d_proc)
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_GLBL(___L22_c_23_specialize_2d_proc)
   ___SET_R1(___GLO_c_23_void_2d_object)
   ___GOTO(___L20_c_23_specialize_2d_proc)
___DEF_GLBL(___L23_c_23_specialize_2d_proc)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(13,___L13_c_23_specialize_2d_proc)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_specialize_2d_proc)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_specialize_2d_proc)
   ___GOTO(___L25_c_23_specialize_2d_proc)
___DEF_GLBL(___L24_c_23_specialize_2d_proc)
   ___SET_R1(___STK(-4))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_specialize_2d_proc)
___DEF_GLBL(___L25_c_23_specialize_2d_proc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(17,___L17_c_23_specialize_2d_proc)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-3))
___DEF_GLBL(___L26_c_23_specialize_2d_proc)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_nb_2d_args_2d_conforms_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 525
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_nb_2d_args_2d_conforms_3f_)
___DEF_P_HLBL(___L1_c_23_nb_2d_args_2d_conforms_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_nb_2d_args_2d_conforms_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_nb_2d_args_2d_conforms_3f_)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_nb_2d_args_2d_conforms_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),370,___G_c_23_pattern_2d_member_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_scheme_2d_dialect
#undef ___PH_LBL0
#define ___PH_LBL0 528
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_scheme_2d_dialect)
___DEF_P_HLBL(___L1_c_23_scheme_2d_dialect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_scheme_2d_dialect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_scheme_2d_dialect)
   ___SET_STK(1,___SYM_dialect)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_gambit_2d_scheme_2d_sym)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_scheme_2d_dialect)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_constant_2d_fold_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 531
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_constant_2d_fold_3f_)
___DEF_P_HLBL(___L1_c_23_constant_2d_fold_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_constant_2d_fold_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_constant_2d_fold_3f_)
   ___SET_STK(1,___GLO_c_23_constant_2d_fold_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_constant_2d_fold_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_lambda_2d_lift_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 534
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_lambda_2d_lift_3f_)
___DEF_P_HLBL(___L1_c_23_lambda_2d_lift_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_lambda_2d_lift_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_lambda_2d_lift_3f_)
   ___SET_STK(1,___GLO_c_23_lambda_2d_lift_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_lambda_2d_lift_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_inline_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 537
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_inline_3f_)
___DEF_P_HLBL(___L1_c_23_inline_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_inline_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_inline_3f_)
   ___SET_STK(1,___GLO_c_23_inline_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_inline_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_inline_2d_primitive_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 540
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_inline_2d_primitive_3f_)
___DEF_P_HLBL(___L1_c_23_inline_2d_primitive_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_inline_2d_primitive_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_inline_2d_primitive_3f_)
   ___SET_STK(1,___GLO_c_23_inline_2d_primitives_2d_sym)
   ___SET_R3(___R2)
   ___SET_R2(___TRU)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_inline_2d_primitive_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_not_2d_inline_2d_primitives
#undef ___PH_LBL0
#define ___PH_LBL0 543
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_not_2d_inline_2d_primitives)
___DEF_P_HLBL(___L1_c_23_add_2d_not_2d_inline_2d_primitives)
___DEF_P_HLBL(___L2_c_23_add_2d_not_2d_inline_2d_primitives)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_not_2d_inline_2d_primitives)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_add_2d_not_2d_inline_2d_primitives)
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_inline_2d_primitives_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_add_2d_not_2d_inline_2d_primitives)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_add_2d_not_2d_inline_2d_primitives)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_inlining_2d_limit
#undef ___PH_LBL0
#define ___PH_LBL0 547
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_inlining_2d_limit)
___DEF_P_HLBL(___L1_c_23_inlining_2d_limit)
___DEF_P_HLBL(___L2_c_23_inlining_2d_limit)
___DEF_P_HLBL(___L3_c_23_inlining_2d_limit)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_inlining_2d_limit)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_inlining_2d_limit)
   ___SET_STK(1,___R0)
   ___SET_STK(5,___GLO_c_23_inlining_2d_limit_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(350L))
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(2))
   ___ADJFP(5)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_inlining_2d_limit)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___DEF_SLBL(2,___L2_c_23_inlining_2d_limit)
   ___SET_R1(___FIXMIN(___FIX(1000000L),___R1))
   ___SET_R1(___FIXMAX(___FIX(0L),___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_inlining_2d_limit)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_block_2d_compilation_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 552
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_block_2d_compilation_3f_)
___DEF_P_HLBL(___L1_c_23_block_2d_compilation_3f_)
___DEF_P_HLBL(___L2_c_23_block_2d_compilation_3f_)
___DEF_P_HLBL(___L3_c_23_block_2d_compilation_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_block_2d_compilation_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_block_2d_compilation_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(5,___SYM_compilation_2d_strategy)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_separate_2d_sym)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(2))
   ___ADJFP(5)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_block_2d_compilation_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___DEF_SLBL(2,___L2_c_23_block_2d_compilation_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_block_2d_sym)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_block_2d_compilation_3f_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_core_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 557
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_core_3f_)
___DEF_P_HLBL(___L1_c_23_core_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_core_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_core_3f_)
   ___SET_STK(1,___GLO_c_23_core_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_core_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_standard_2d_binding_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 560
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_standard_2d_binding_3f_)
___DEF_P_HLBL(___L1_c_23_standard_2d_binding_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_standard_2d_binding_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_standard_2d_binding_3f_)
   ___SET_STK(1,___GLO_c_23_standard_2d_bindings_2d_sym)
   ___SET_R3(___R2)
   ___SET_R2(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_standard_2d_binding_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_extended_2d_binding_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 563
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_extended_2d_binding_3f_)
___DEF_P_HLBL(___L1_c_23_extended_2d_binding_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_extended_2d_binding_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_extended_2d_binding_3f_)
   ___SET_STK(1,___GLO_c_23_extended_2d_bindings_2d_sym)
   ___SET_R3(___R2)
   ___SET_R2(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_extended_2d_binding_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_extended_2d_bindings
#undef ___PH_LBL0
#define ___PH_LBL0 566
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_extended_2d_bindings)
___DEF_P_HLBL(___L1_c_23_add_2d_extended_2d_bindings)
___DEF_P_HLBL(___L2_c_23_add_2d_extended_2d_bindings)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_extended_2d_bindings)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_add_2d_extended_2d_bindings)
   ___BEGIN_ALLOC_LIST(2,___TRU)
   ___ADD_LIST_ELEM(1,___GLO_c_23_extended_2d_bindings_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_add_2d_extended_2d_bindings)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_add_2d_extended_2d_bindings)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_run_2d_time_2d_binding_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 570
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_run_2d_time_2d_binding_3f_)
___DEF_P_HLBL(___L1_c_23_run_2d_time_2d_binding_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_run_2d_time_2d_binding_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_run_2d_time_2d_binding_3f_)
   ___SET_STK(1,___GLO_c_23_run_2d_time_2d_bindings_2d_sym)
   ___SET_R3(___R2)
   ___SET_R2(___TRU)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_run_2d_time_2d_binding_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_safe_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 573
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_safe_3f_)
___DEF_P_HLBL(___L1_c_23_safe_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_safe_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_safe_3f_)
   ___SET_STK(1,___GLO_c_23_safe_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_safe_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_not_2d_safe
#undef ___PH_LBL0
#define ___PH_LBL0 576
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_not_2d_safe)
___DEF_P_HLBL(___L1_c_23_add_2d_not_2d_safe)
___DEF_P_HLBL(___L2_c_23_add_2d_not_2d_safe)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_not_2d_safe)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_add_2d_not_2d_safe)
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_safe_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_add_2d_not_2d_safe)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_add_2d_not_2d_safe)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_warnings_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 580
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_warnings_3f_)
___DEF_P_HLBL(___L1_c_23_warnings_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_warnings_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_warnings_3f_)
   ___SET_STK(1,___GLO_c_23_warnings_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_warnings_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_intrs_2d_enabled_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 583
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_intrs_2d_enabled_3f_)
___DEF_P_HLBL(___L1_c_23_intrs_2d_enabled_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_intrs_2d_enabled_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_intrs_2d_enabled_3f_)
   ___SET_STK(1,___GLO_c_23_interrupts_2d_enabled_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_intrs_2d_enabled_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_not_2d_interrupts_2d_enabled
#undef ___PH_LBL0
#define ___PH_LBL0 586
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_not_2d_interrupts_2d_enabled)
___DEF_P_HLBL(___L1_c_23_add_2d_not_2d_interrupts_2d_enabled)
___DEF_P_HLBL(___L2_c_23_add_2d_not_2d_interrupts_2d_enabled)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_not_2d_interrupts_2d_enabled)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_add_2d_not_2d_interrupts_2d_enabled)
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_interrupts_2d_enabled_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_add_2d_not_2d_interrupts_2d_enabled)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_add_2d_not_2d_interrupts_2d_enabled)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_debug_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 590
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_debug_3f_)
___DEF_P_HLBL(___L1_c_23_debug_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_debug_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_debug_3f_)
   ___SET_STK(1,___GLO_c_23_debug_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_compiler_2d_option_2d_debug)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_debug_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_debug_2d_location_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 593
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_debug_2d_location_3f_)
___DEF_P_HLBL(___L1_c_23_debug_2d_location_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_debug_2d_location_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_debug_2d_location_3f_)
   ___SET_STK(1,___GLO_c_23_debug_2d_location_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_compiler_2d_option_2d_debug_2d_location)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_debug_2d_location_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_debug_2d_source_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 596
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_debug_2d_source_3f_)
___DEF_P_HLBL(___L1_c_23_debug_2d_source_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_debug_2d_source_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_debug_2d_source_3f_)
   ___SET_STK(1,___GLO_c_23_debug_2d_source_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_compiler_2d_option_2d_debug_2d_source)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_debug_2d_source_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_debug_2d_environments_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 599
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_debug_2d_environments_3f_)
___DEF_P_HLBL(___L1_c_23_debug_2d_environments_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_debug_2d_environments_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_debug_2d_environments_3f_)
   ___SET_STK(1,___GLO_c_23_debug_2d_environments_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___GLO_c_23_compiler_2d_option_2d_debug_2d_environments)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_debug_2d_environments_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_environment_2d_map_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 602
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_environment_2d_map_3f_)
___DEF_P_HLBL(___L1_c_23_environment_2d_map_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_environment_2d_map_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_environment_2d_map_3f_)
   ___SET_STK(1,___GLO_c_23_environment_2d_map_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_environment_2d_map_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_tail_2d_calls_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 605
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_tail_2d_calls_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_tail_2d_calls_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_tail_2d_calls_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_proper_2d_tail_2d_calls_3f_)
   ___SET_STK(1,___GLO_c_23_proper_2d_tail_2d_calls_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_tail_2d_calls_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_proper_2d_tail_2d_calls
#undef ___PH_LBL0
#define ___PH_LBL0 608
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_proper_2d_tail_2d_calls)
___DEF_P_HLBL(___L1_c_23_add_2d_proper_2d_tail_2d_calls)
___DEF_P_HLBL(___L2_c_23_add_2d_proper_2d_tail_2d_calls)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_proper_2d_tail_2d_calls)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_add_2d_proper_2d_tail_2d_calls)
   ___BEGIN_ALLOC_LIST(2,___TRU)
   ___ADD_LIST_ELEM(1,___GLO_c_23_proper_2d_tail_2d_calls_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_add_2d_proper_2d_tail_2d_calls)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_add_2d_proper_2d_tail_2d_calls)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_optimize_2d_dead_2d_local_2d_variables_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 612
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
___DEF_P_HLBL(___L1_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
   ___SET_STK(1,___GLO_c_23_optimize_2d_dead_2d_local_2d_variables_2d_sym)
   ___SET_R3(___R1)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_optimize_2d_dead_2d_local_2d_variables_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_standard_2d_proc_2d_obj
#undef ___PH_LBL0
#define ___PH_LBL0 615
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L1_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L2_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L3_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L4_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L5_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L6_c_23_standard_2d_proc_2d_obj)
___DEF_P_HLBL(___L7_c_23_standard_2d_proc_2d_obj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_standard_2d_proc_2d_obj)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_standard_2d_proc_2d_obj)
   ___SET_STK(1,___R1)
   ___ADJFP(1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_standard_2d_proc_2d_obj)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(8,___STK(0))
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R0(___LBL(2))
   ___ADJFP(11)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_standard_2d_proc_2d_obj)
   ___JUMPINT(___SET_NARGS(2),___PRC(560),___L_c_23_standard_2d_binding_3f_)
___DEF_SLBL(2,___L2_c_23_standard_2d_proc_2d_obj)
   ___SET_STK(-7,___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(563),___L_c_23_extended_2d_binding_3f_)
___DEF_SLBL(3,___L3_c_23_standard_2d_proc_2d_obj)
   ___SET_STK(-9,___R1)
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(528),___L_c_23_scheme_2d_dialect)
___DEF_SLBL(4,___L4_c_23_standard_2d_proc_2d_obj)
   ___SET_R3(___R1)
   ___SET_R0(___LBL(5))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-7))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(624),___L_c_23_standard_2d_procedure_3f_)
___DEF_SLBL(5,___L5_c_23_standard_2d_proc_2d_obj)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L8_c_23_standard_2d_proc_2d_obj)
   ___END_IF
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_standard_2d_proc_2d_obj)
   ___GOTO(___L9_c_23_standard_2d_proc_2d_obj)
___DEF_GLBL(___L8_c_23_standard_2d_proc_2d_obj)
   ___SET_R1(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_standard_2d_proc_2d_obj)
___DEF_GLBL(___L9_c_23_standard_2d_proc_2d_obj)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L10_c_23_standard_2d_proc_2d_obj)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_standard_2d_procedure_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 624
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L1_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L2_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L3_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L4_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L5_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L6_c_23_standard_2d_procedure_3f_)
___DEF_P_HLBL(___L7_c_23_standard_2d_procedure_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_standard_2d_procedure_3f_)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_standard_2d_procedure_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_standard_2d_procedure_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),373,___G_c_23_proc_2d_obj_2d_standard)
___DEF_SLBL(2,___L2_c_23_standard_2d_procedure_3f_)
   ___IF(___NOT(___EQP(___R1,___SYM_extended)))
   ___GOTO(___L8_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_standard_2d_procedure_3f_)
   ___GOTO(___L9_c_23_standard_2d_procedure_3f_)
___DEF_GLBL(___L8_c_23_standard_2d_procedure_3f_)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___IF(___EQP(___STK(-7),___SYM_ieee))
   ___GOTO(___L11_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___IF(___EQP(___STK(-3),___GLO_c_23_ieee_2d_scheme_2d_sym))
   ___GOTO(___L12_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___IF(___EQP(___STK(-7),___SYM_r4rs))
   ___GOTO(___L11_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___IF(___EQP(___STK(-3),___GLO_c_23_r4rs_2d_scheme_2d_sym))
   ___GOTO(___L12_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___IF(___EQP(___STK(-7),___SYM_r5rs))
   ___GOTO(___L11_c_23_standard_2d_procedure_3f_)
   ___END_IF
   ___SET_R1(___BOOLEAN(___EQP(___STK(-3),___GLO_c_23_r5rs_2d_scheme_2d_sym)))
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_standard_2d_procedure_3f_)
___DEF_GLBL(___L9_c_23_standard_2d_procedure_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L10_c_23_standard_2d_procedure_3f_)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_standard_2d_procedure_3f_)
   ___GOTO(___L9_c_23_standard_2d_procedure_3f_)
___DEF_GLBL(___L11_c_23_standard_2d_procedure_3f_)
   ___SET_R1(___TRU)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_standard_2d_procedure_3f_)
   ___GOTO(___L9_c_23_standard_2d_procedure_3f_)
___DEF_GLBL(___L12_c_23_standard_2d_procedure_3f_)
   ___SET_R1(___FAL)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_standard_2d_procedure_3f_)
   ___GOTO(___L9_c_23_standard_2d_procedure_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parse_2d_program
#undef ___PH_LBL0
#define ___PH_LBL0 633
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_parse_2d_program)
___DEF_P_HLBL(___L1_c_23_parse_2d_program)
___DEF_P_HLBL(___L2_c_23_parse_2d_program)
___DEF_P_HLBL(___L3_c_23_parse_2d_program)
___DEF_P_HLBL(___L4_c_23_parse_2d_program)
___DEF_P_HLBL(___L5_c_23_parse_2d_program)
___DEF_P_HLBL(___L6_c_23_parse_2d_program)
___DEF_P_HLBL(___L7_c_23_parse_2d_program)
___DEF_P_HLBL(___L8_c_23_parse_2d_program)
___DEF_P_HLBL(___L9_c_23_parse_2d_program)
___DEF_P_HLBL(___L10_c_23_parse_2d_program)
___DEF_P_HLBL(___L11_c_23_parse_2d_program)
___DEF_P_HLBL(___L12_c_23_parse_2d_program)
___DEF_P_HLBL(___L13_c_23_parse_2d_program)
___DEF_P_HLBL(___L14_c_23_parse_2d_program)
___DEF_P_HLBL(___L15_c_23_parse_2d_program)
___DEF_P_HLBL(___L16_c_23_parse_2d_program)
___DEF_P_HLBL(___L17_c_23_parse_2d_program)
___DEF_P_HLBL(___L18_c_23_parse_2d_program)
___DEF_P_HLBL(___L19_c_23_parse_2d_program)
___DEF_P_HLBL(___L20_c_23_parse_2d_program)
___DEF_P_HLBL(___L21_c_23_parse_2d_program)
___DEF_P_HLBL(___L22_c_23_parse_2d_program)
___DEF_P_HLBL(___L23_c_23_parse_2d_program)
___DEF_P_HLBL(___L24_c_23_parse_2d_program)
___DEF_P_HLBL(___L25_c_23_parse_2d_program)
___DEF_P_HLBL(___L26_c_23_parse_2d_program)
___DEF_P_HLBL(___L27_c_23_parse_2d_program)
___DEF_P_HLBL(___L28_c_23_parse_2d_program)
___DEF_P_HLBL(___L29_c_23_parse_2d_program)
___DEF_P_HLBL(___L30_c_23_parse_2d_program)
___DEF_P_HLBL(___L31_c_23_parse_2d_program)
___DEF_P_HLBL(___L32_c_23_parse_2d_program)
___DEF_P_HLBL(___L33_c_23_parse_2d_program)
___DEF_P_HLBL(___L34_c_23_parse_2d_program)
___DEF_P_HLBL(___L35_c_23_parse_2d_program)
___DEF_P_HLBL(___L36_c_23_parse_2d_program)
___DEF_P_HLBL(___L37_c_23_parse_2d_program)
___DEF_P_HLBL(___L38_c_23_parse_2d_program)
___DEF_P_HLBL(___L39_c_23_parse_2d_program)
___DEF_P_HLBL(___L40_c_23_parse_2d_program)
___DEF_P_HLBL(___L41_c_23_parse_2d_program)
___DEF_P_HLBL(___L42_c_23_parse_2d_program)
___DEF_P_HLBL(___L43_c_23_parse_2d_program)
___DEF_P_HLBL(___L44_c_23_parse_2d_program)
___DEF_P_HLBL(___L45_c_23_parse_2d_program)
___DEF_P_HLBL(___L46_c_23_parse_2d_program)
___DEF_P_HLBL(___L47_c_23_parse_2d_program)
___DEF_P_HLBL(___L48_c_23_parse_2d_program)
___DEF_P_HLBL(___L49_c_23_parse_2d_program)
___DEF_P_HLBL(___L50_c_23_parse_2d_program)
___DEF_P_HLBL(___L51_c_23_parse_2d_program)
___DEF_P_HLBL(___L52_c_23_parse_2d_program)
___DEF_P_HLBL(___L53_c_23_parse_2d_program)
___DEF_P_HLBL(___L54_c_23_parse_2d_program)
___DEF_P_HLBL(___L55_c_23_parse_2d_program)
___DEF_P_HLBL(___L56_c_23_parse_2d_program)
___DEF_P_HLBL(___L57_c_23_parse_2d_program)
___DEF_P_HLBL(___L58_c_23_parse_2d_program)
___DEF_P_HLBL(___L59_c_23_parse_2d_program)
___DEF_P_HLBL(___L60_c_23_parse_2d_program)
___DEF_P_HLBL(___L61_c_23_parse_2d_program)
___DEF_P_HLBL(___L62_c_23_parse_2d_program)
___DEF_P_HLBL(___L63_c_23_parse_2d_program)
___DEF_P_HLBL(___L64_c_23_parse_2d_program)
___DEF_P_HLBL(___L65_c_23_parse_2d_program)
___DEF_P_HLBL(___L66_c_23_parse_2d_program)
___DEF_P_HLBL(___L67_c_23_parse_2d_program)
___DEF_P_HLBL(___L68_c_23_parse_2d_program)
___DEF_P_HLBL(___L69_c_23_parse_2d_program)
___DEF_P_HLBL(___L70_c_23_parse_2d_program)
___DEF_P_HLBL(___L71_c_23_parse_2d_program)
___DEF_P_HLBL(___L72_c_23_parse_2d_program)
___DEF_P_HLBL(___L73_c_23_parse_2d_program)
___DEF_P_HLBL(___L74_c_23_parse_2d_program)
___DEF_P_HLBL(___L75_c_23_parse_2d_program)
___DEF_P_HLBL(___L76_c_23_parse_2d_program)
___DEF_P_HLBL(___L77_c_23_parse_2d_program)
___DEF_P_HLBL(___L78_c_23_parse_2d_program)
___DEF_P_HLBL(___L79_c_23_parse_2d_program)
___DEF_P_HLBL(___L80_c_23_parse_2d_program)
___DEF_P_HLBL(___L81_c_23_parse_2d_program)
___DEF_P_HLBL(___L82_c_23_parse_2d_program)
___DEF_P_HLBL(___L83_c_23_parse_2d_program)
___DEF_P_HLBL(___L84_c_23_parse_2d_program)
___DEF_P_HLBL(___L85_c_23_parse_2d_program)
___DEF_P_HLBL(___L86_c_23_parse_2d_program)
___DEF_P_HLBL(___L87_c_23_parse_2d_program)
___DEF_P_HLBL(___L88_c_23_parse_2d_program)
___DEF_P_HLBL(___L89_c_23_parse_2d_program)
___DEF_P_HLBL(___L90_c_23_parse_2d_program)
___DEF_P_HLBL(___L91_c_23_parse_2d_program)
___DEF_P_HLBL(___L92_c_23_parse_2d_program)
___DEF_P_HLBL(___L93_c_23_parse_2d_program)
___DEF_P_HLBL(___L94_c_23_parse_2d_program)
___DEF_P_HLBL(___L95_c_23_parse_2d_program)
___DEF_P_HLBL(___L96_c_23_parse_2d_program)
___DEF_P_HLBL(___L97_c_23_parse_2d_program)
___DEF_P_HLBL(___L98_c_23_parse_2d_program)
___DEF_P_HLBL(___L99_c_23_parse_2d_program)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_parse_2d_program)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L100_c_23_parse_2d_program)
   ___END_IF
   ___GOTO(___L134_c_23_parse_2d_program)
___DEF_SLBL(1,___L1_c_23_parse_2d_program)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
___DEF_GLBL(___L100_c_23_parse_2d_program)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___ADJFP(7)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_parse_2d_program)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),302,___G_c_23_c_2d_interface_2d_begin)
___DEF_SLBL(3,___L3_c_23_parse_2d_program)
   ___SET_STK(-7,___CONS(___STK(-7),___NUL))
   ___SET_STK(-3,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-3),88)
   ___ADD_CLO_ELEM(0,___STK(-4))
   ___END_SETUP_CLO(1)
   ___SET_R3(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R2(___NUL)
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_parse_2d_program)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_parse_2d_program)
   ___GOTO(___L101_c_23_parse_2d_program)
___DEF_SLBL(6,___L6_c_23_parse_2d_program)
   ___SET_STK(-7,___CDR(___STK(-7)))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_parse_2d_program)
___DEF_GLBL(___L101_c_23_parse_2d_program)
   ___IF(___NOT(___NULLP(___STK(0))))
   ___GOTO(___L102_c_23_parse_2d_program)
   ___END_IF
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(9))
   ___ADJFP(7)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_parse_2d_program)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(9,___L9_c_23_parse_2d_program)
   ___SET_R2(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_parse_2d_program)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___DEF_GLBL(___L102_c_23_parse_2d_program)
   ___SET_R4(___CAR(___STK(0)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R2(___R1)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(12))
   ___ADJFP(11)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_parse_2d_program)
   ___JUMPINT(___SET_NARGS(2),___PRC(1705),___L_c_23_macro_2d_expr_3f_)
___DEF_SLBL(12,___L12_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L129_c_23_parse_2d_program)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(1),___PRC(1718),___L_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
___DEF_SLBL(13,___L13_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L128_c_23_parse_2d_program)
   ___END_IF
   ___SET_STK(-5,___STK(-6))
   ___SET_R3(___STK(-5))
   ___SET_R2(___FIX(-2L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_sym)
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(14,___L14_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L125_c_23_parse_2d_program)
   ___END_IF
   ___SET_STK(-5,___STK(-6))
   ___SET_R3(___STK(-5))
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_macro_2d_sym)
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(15,___L15_c_23_parse_2d_program)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L124_c_23_parse_2d_program)
   ___END_IF
   ___GOTO(___L103_c_23_parse_2d_program)
___DEF_SLBL(16,___L16_c_23_parse_2d_program)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L105_c_23_parse_2d_program)
   ___END_IF
___DEF_GLBL(___L103_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L104_c_23_parse_2d_program)
   ___END_IF
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(14))
   ___SET_R0(___LBL(17))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(17,___L17_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(18))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(18,___L18_c_23_parse_2d_program)
___DEF_GLBL(___L104_c_23_parse_2d_program)
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(1987),___L_c_23_add_2d_macro)
___DEF_SLBL(19,___L19_c_23_parse_2d_program)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_parse_2d_program)
   ___GOTO(___L101_c_23_parse_2d_program)
___DEF_GLBL(___L105_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(1),___PRC(1733),___L_c_23__2a__2a_include_2d_expr_3f_)
___DEF_SLBL(21,___L21_c_23_parse_2d_program)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L109_c_23_parse_2d_program)
   ___END_IF
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L106_c_23_parse_2d_program)
   ___END_IF
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(15))
   ___SET_R0(___LBL(22))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(22,___L22_c_23_parse_2d_program)
___DEF_GLBL(___L106_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(23))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),344,___G_c_23_include_2d_expr_2d__3e_source)
___DEF_SLBL(23,___L23_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L107_c_23_parse_2d_program)
   ___END_IF
   ___GOTO(___L108_c_23_parse_2d_program)
___DEF_SLBL(24,___L24_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___ADJFP(-4)
___DEF_GLBL(___L107_c_23_parse_2d_program)
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_STK(-7,___CONS(___R1,___R2))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(25,4096)
___DEF_SLBL(25,___L25_c_23_parse_2d_program)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_parse_2d_program)
   ___GOTO(___L101_c_23_parse_2d_program)
___DEF_GLBL(___L108_c_23_parse_2d_program)
   ___SET_STK(-2,___R1)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(24))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_GLBL(___L109_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(1),___PRC(1742),___L_c_23__2a__2a_declare_2d_expr_3f_)
___DEF_SLBL(27,___L27_c_23_parse_2d_program)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L111_c_23_parse_2d_program)
   ___END_IF
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L110_c_23_parse_2d_program)
   ___END_IF
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(16))
   ___SET_R0(___LBL(28))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(28,___L28_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(29))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(29,___L29_c_23_parse_2d_program)
___DEF_GLBL(___L110_c_23_parse_2d_program)
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(1954),___L_c_23_add_2d_declarations)
___DEF_GLBL(___L111_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(30))
   ___JUMPINT(___SET_NARGS(1),___PRC(1745),___L_c_23__2a__2a_namespace_2d_expr_3f_)
___DEF_SLBL(30,___L30_c_23_parse_2d_program)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L113_c_23_parse_2d_program)
   ___END_IF
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L112_c_23_parse_2d_program)
   ___END_IF
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(17))
   ___SET_R0(___LBL(31))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(31,___L31_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(32))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(32,___L32_c_23_parse_2d_program)
___DEF_GLBL(___L112_c_23_parse_2d_program)
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(1963),___L_c_23_add_2d_namespace)
___DEF_GLBL(___L113_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),252,___G_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_)
___DEF_SLBL(33,___L33_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L122_c_23_parse_2d_program)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),250,___G_c_23__2a__2a_c_2d_declare_2d_expr_3f_)
___DEF_SLBL(34,___L34_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L120_c_23_parse_2d_program)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),253,___G_c_23__2a__2a_c_2d_initialize_2d_expr_3f_)
___DEF_SLBL(35,___L35_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L118_c_23_parse_2d_program)
   ___END_IF
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(36))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),251,___G_c_23__2a__2a_c_2d_define_2d_expr_3f_)
___DEF_SLBL(36,___L36_c_23_parse_2d_program)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L115_c_23_parse_2d_program)
   ___END_IF
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L114_c_23_parse_2d_program)
   ___END_IF
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(18))
   ___SET_R0(___LBL(37))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(37,___L37_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(38))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(38,___L38_c_23_parse_2d_program)
___DEF_GLBL(___L114_c_23_parse_2d_program)
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(39))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(39,___L39_c_23_parse_2d_program)
   ___SET_R2(___CONS(___R1,___STK(-4)))
   ___SET_R3(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(40,4096)
___DEF_SLBL(40,___L40_c_23_parse_2d_program)
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23_parse_2d_program)
   ___GOTO(___L101_c_23_parse_2d_program)
___DEF_GLBL(___L115_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(42))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),295,___G_c_23_c_2d_definition_2d_name)
___DEF_SLBL(42,___L42_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(43))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(43,___L43_c_23_parse_2d_program)
   ___SET_R3(___STK(-4))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(44))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),332,___G_c_23_env_2d_lookup_2d_var)
___DEF_SLBL(44,___L44_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(45))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),296,___G_c_23_c_2d_definition_2d_param_2d_types)
___DEF_SLBL(45,___L45_c_23_parse_2d_program)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(46))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),298,___G_c_23_c_2d_definition_2d_result_2d_type)
___DEF_SLBL(46,___L46_c_23_parse_2d_program)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(47))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),297,___G_c_23_c_2d_definition_2d_proc_2d_name)
___DEF_SLBL(47,___L47_c_23_parse_2d_program)
   ___SET_R0(___LBL(48))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(48,___L48_c_23_parse_2d_program)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(49))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),299,___G_c_23_c_2d_definition_2d_scope)
___DEF_SLBL(49,___L49_c_23_parse_2d_program)
   ___SET_R0(___LBL(50))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(50,___L50_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L116_c_23_parse_2d_program)
   ___END_IF
   ___GOTO(___L117_c_23_parse_2d_program)
___DEF_SLBL(51,___L51_c_23_parse_2d_program)
   ___SET_R1(___STK(-5))
___DEF_GLBL(___L116_c_23_parse_2d_program)
   ___SET_STK(1,___STK(-8))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(52))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),293,___G_c_23_build_2d_c_2d_define)
___DEF_SLBL(52,___L52_c_23_parse_2d_program)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(53))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),300,___G_c_23_c_2d_definition_2d_value)
___DEF_SLBL(53,___L53_c_23_parse_2d_program)
   ___SET_R2(___STK(-13))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(54))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(54,___L54_c_23_parse_2d_program)
   ___SET_STK(-8,___R1)
   ___SET_R2(___CONS(___R1,___NUL))
   ___SET_R1(___CONS(___STK(-9),___NUL))
   ___SET_R0(___LBL(56))
   ___CHECK_HEAP(55,4096)
___DEF_SLBL(55,___L55_c_23_parse_2d_program)
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(56,___L56_c_23_parse_2d_program)
   ___SET_STK(-7,___STK(-8))
   ___VECTORSET(___STK(-7),___FIX(9L),___STK(-6))
   ___SET_STK(-15,___CDR(___STK(-15)))
   ___SET_STK(-7,___STK(-10))
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-13))
   ___SET_R0(___LBL(39))
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(221),___L_c_23_new_2d_def)
___DEF_GLBL(___L117_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(19))
   ___SET_R0(___LBL(57))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(57,___L57_c_23_parse_2d_program)
   ___SET_STK(-4,___STK(-9))
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(58))
   ___JUMPPRM(___SET_NARGS(2),___PRM_write)
___DEF_SLBL(58,___L58_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(51))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_GLBL(___L118_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(59))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),301,___G_c_23_c_2d_initialization_2d_body)
___DEF_SLBL(59,___L59_c_23_parse_2d_program)
   ___SET_R0(___LBL(60))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(60,___L60_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L119_c_23_parse_2d_program)
   ___END_IF
   ___SET_STK(-2,___R1)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(20))
   ___SET_R0(___LBL(61))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(61,___L61_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(62))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(62,___L62_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___ADJFP(-4)
___DEF_GLBL(___L119_c_23_parse_2d_program)
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),288,___G_c_23_add_2d_c_2d_init)
___DEF_GLBL(___L120_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(63))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),294,___G_c_23_c_2d_declaration_2d_body)
___DEF_SLBL(63,___L63_c_23_parse_2d_program)
   ___SET_R0(___LBL(64))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(64,___L64_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L121_c_23_parse_2d_program)
   ___END_IF
   ___SET_STK(-2,___R1)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(21))
   ___SET_R0(___LBL(65))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(65,___L65_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(66))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(66,___L66_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___ADJFP(-4)
___DEF_GLBL(___L121_c_23_parse_2d_program)
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),287,___G_c_23_add_2d_c_2d_decl)
___DEF_GLBL(___L122_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(67))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),304,___G_c_23_c_2d_type_2d_definition_2d_name)
___DEF_SLBL(67,___L67_c_23_parse_2d_program)
   ___SET_R0(___LBL(68))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(68,___L68_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(69))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),305,___G_c_23_c_2d_type_2d_definition_2d_type)
___DEF_SLBL(69,___L69_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L123_c_23_parse_2d_program)
   ___END_IF
   ___SET_STK(-6,___R1)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(22))
   ___SET_R0(___LBL(70))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(70,___L70_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(71))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_SLBL(71,___L71_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
___DEF_GLBL(___L123_c_23_parse_2d_program)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),289,___G_c_23_add_2d_c_2d_type)
___DEF_GLBL(___L124_c_23_parse_2d_program)
   ___SET_STK(-5,___STK(-6))
   ___SET_R3(___STK(-5))
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_syntax_2d_sym)
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_GLBL(___L125_c_23_parse_2d_program)
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(72))
   ___JUMPINT(___SET_NARGS(2),___PRC(1775),___L_c_23_definition_2d_name)
___DEF_SLBL(72,___L72_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(73))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(73,___L73_c_23_parse_2d_program)
   ___SET_R3(___STK(-4))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(74))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),332,___G_c_23_env_2d_lookup_2d_var)
___DEF_SLBL(74,___L74_c_23_parse_2d_program)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L126_c_23_parse_2d_program)
   ___END_IF
   ___GOTO(___L127_c_23_parse_2d_program)
___DEF_SLBL(75,___L75_c_23_parse_2d_program)
   ___SET_R1(___STK(-5))
___DEF_GLBL(___L126_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(76))
   ___JUMPINT(___SET_NARGS(1),___PRC(1787),___L_c_23_definition_2d_value)
___DEF_SLBL(76,___L76_c_23_parse_2d_program)
   ___SET_R2(___STK(-9))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(77))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(77,___L77_c_23_parse_2d_program)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CONS(___R1,___NUL))
   ___SET_R1(___CONS(___STK(-5),___NUL))
   ___SET_R0(___LBL(79))
   ___CHECK_HEAP(78,4096)
___DEF_SLBL(78,___L78_c_23_parse_2d_program)
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(79,___L79_c_23_parse_2d_program)
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_STK(-3,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(39))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(221),___L_c_23_new_2d_def)
___DEF_GLBL(___L127_c_23_parse_2d_program)
   ___SET_STK(-5,___R1)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(23))
   ___SET_R0(___LBL(80))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(80,___L80_c_23_parse_2d_program)
   ___SET_STK(-4,___STK(-5))
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(81))
   ___JUMPPRM(___SET_NARGS(2),___PRM_write)
___DEF_SLBL(81,___L81_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(75))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_GLBL(___L128_c_23_parse_2d_program)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(82))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(1892),___L_c_23_begin_2d_body)
___DEF_SLBL(82,___L82_c_23_parse_2d_program)
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_R0(___LBL(83))
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(83,___L83_c_23_parse_2d_program)
   ___SET_STK(-7,___R1)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(84)
___DEF_SLBL(84,___L84_c_23_parse_2d_program)
   ___GOTO(___L101_c_23_parse_2d_program)
___DEF_GLBL(___L129_c_23_parse_2d_program)
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(85))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(823),___L_c_23_macro_2d_expand)
___DEF_SLBL(85,___L85_c_23_parse_2d_program)
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_STK(-7,___CONS(___R1,___R2))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(86,4096)
___DEF_SLBL(86,___L86_c_23_parse_2d_program)
   ___POLL(87)
___DEF_SLBL(87,___L87_c_23_parse_2d_program)
   ___GOTO(___L101_c_23_parse_2d_program)
___DEF_SLBL(88,___L88_c_23_parse_2d_program)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(88,2,0,0)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L130_c_23_parse_2d_program)
   ___END_IF
   ___GOTO(___L133_c_23_parse_2d_program)
___DEF_SLBL(89,___L89_c_23_parse_2d_program)
   ___SET_R4(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L130_c_23_parse_2d_program)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R4)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(91))
   ___ADJFP(8)
   ___POLL(90)
___DEF_SLBL(90,___L90_c_23_parse_2d_program)
   ___JUMPINT(___SET_NARGS(1),___PRC(734),___L_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_SLBL(91,___L91_c_23_parse_2d_program)
   ___IF(___NULLP(___STK(-6)))
   ___GOTO(___L132_c_23_parse_2d_program)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___GOTO(___L131_c_23_parse_2d_program)
___DEF_SLBL(92,___L92_c_23_parse_2d_program)
   ___SET_R1(___CONS(___R1,___NUL))
   ___CHECK_HEAP(93,4096)
___DEF_SLBL(93,___L93_c_23_parse_2d_program)
___DEF_GLBL(___L131_c_23_parse_2d_program)
   ___SET_STK(-6,___R1)
   ___SET_R0(___LBL(94))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),303,___G_c_23_c_2d_interface_2d_end)
___DEF_SLBL(94,___L94_c_23_parse_2d_program)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-6))
   ___POLL(95)
___DEF_SLBL(95,___L95_c_23_parse_2d_program)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___CLO(___STK(4),1))
___DEF_GLBL(___L132_c_23_parse_2d_program)
   ___SET_R2(___FAL)
   ___SET_R1(___GLO_c_23_false_2d_object)
   ___SET_R0(___LBL(96))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),336,___G_c_23_expression_2d__3e_source)
___DEF_SLBL(96,___L96_c_23_parse_2d_program)
   ___SET_R2(___STK(-5))
   ___SET_R3(___GLO_c_23_false_2d_object)
   ___SET_R0(___LBL(92))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L133_c_23_parse_2d_program)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R4)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(89))
   ___ADJFP(8)
   ___POLL(97)
___DEF_SLBL(97,___L97_c_23_parse_2d_program)
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_GLBL(___L134_c_23_parse_2d_program)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(24))
   ___SET_R0(___LBL(99))
   ___ADJFP(7)
   ___POLL(98)
___DEF_SLBL(98,___L98_c_23_parse_2d_program)
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(99,___L99_c_23_parse_2d_program)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(1))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_check_2d_multiple_2d_global_2d_defs
#undef ___PH_LBL0
#define ___PH_LBL0 734
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L1_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L2_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L3_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L4_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L5_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L6_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L7_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L8_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L9_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L10_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L11_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L12_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L13_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_P_HLBL(___L14_c_23_check_2d_multiple_2d_global_2d_defs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_check_2d_multiple_2d_global_2d_defs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_check_2d_multiple_2d_global_2d_defs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),329,___G_c_23_env_2d_global_2d_variables)
___DEF_SLBL(2,___L2_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_check_2d_multiple_2d_global_2d_defs)
   ___GOTO(___L16_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_SLBL(4,___L4_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_GLBL(___L15_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_GLBL(___L16_c_23_check_2d_multiple_2d_global_2d_defs)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L19_c_23_check_2d_multiple_2d_global_2d_defs)
   ___END_IF
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_check_2d_multiple_2d_global_2d_defs)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),377,___G_c_23_ptset_2d__3e_list)
___DEF_SLBL(7,___L7_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R2(___R1)
   ___SET_R1(___PRC(100))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),349,___G_c_23_keep)
___DEF_SLBL(8,___L8_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPPRM(___SET_NARGS(1),___PRM_length)
___DEF_SLBL(9,___L9_c_23_check_2d_multiple_2d_global_2d_defs)
   ___IF(___NOT(___FIXGT(___R1,___FIX(1L))))
   ___GOTO(___L15_c_23_check_2d_multiple_2d_global_2d_defs)
   ___END_IF
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L18_c_23_check_2d_multiple_2d_global_2d_defs)
   ___END_IF
   ___GOTO(___L19_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_SLBL(10,___L10_c_23_check_2d_multiple_2d_global_2d_defs)
___DEF_GLBL(___L17_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_check_2d_multiple_2d_global_2d_defs)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L19_c_23_check_2d_multiple_2d_global_2d_defs)
   ___END_IF
___DEF_GLBL(___L18_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___VECTORREF(___R3,___FIX(5L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(9,___GLO_c_23_warnings_2d_sym)
   ___SET_R3(___R4)
   ___SET_R2(___TRU)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(13))
   ___ADJFP(9)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_check_2d_multiple_2d_global_2d_defs)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),319,___G_c_23_declaration_2d_value)
___DEF_SLBL(13,___L13_c_23_check_2d_multiple_2d_global_2d_defs)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L17_c_23_check_2d_multiple_2d_global_2d_defs)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(6L)))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),244,___G__23__23_source_2d_locat)
___DEF_SLBL(14,___L14_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R2(___SUB(25))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),312,___G_c_23_compiler_2d_user_2d_warning)
___DEF_GLBL(___L19_c_23_check_2d_multiple_2d_global_2d_defs)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_syntax_2d_error
#undef ___PH_LBL0
#define ___PH_LBL0 750
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_syntax_2d_error)
___DEF_P_HLBL(___L1_c_23_pt_2d_syntax_2d_error)
___DEF_P_HLBL(___L2_c_23_pt_2d_syntax_2d_error)
___DEF_P_HLBL(___L3_c_23_pt_2d_syntax_2d_error)
___DEF_P_HLBL(___L4_c_23_pt_2d_syntax_2d_error)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_syntax_2d_error)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L_c_23_pt_2d_syntax_2d_error)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_syntax_2d_error)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),244,___G__23__23_source_2d_locat)
___DEF_SLBL(2,___L2_c_23_pt_2d_syntax_2d_error)
   ___SET_R2(___CONS(___STK(-6),___STK(-5)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R1(___GLO_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___STK(-7))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_pt_2d_syntax_2d_error)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_pt_2d_syntax_2d_error)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_apply)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt
#undef ___PH_LBL0
#define ___PH_LBL0 756
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt)
___DEF_P_HLBL(___L1_c_23_pt)
___DEF_P_HLBL(___L2_c_23_pt)
___DEF_P_HLBL(___L3_c_23_pt)
___DEF_P_HLBL(___L4_c_23_pt)
___DEF_P_HLBL(___L5_c_23_pt)
___DEF_P_HLBL(___L6_c_23_pt)
___DEF_P_HLBL(___L7_c_23_pt)
___DEF_P_HLBL(___L8_c_23_pt)
___DEF_P_HLBL(___L9_c_23_pt)
___DEF_P_HLBL(___L10_c_23_pt)
___DEF_P_HLBL(___L11_c_23_pt)
___DEF_P_HLBL(___L12_c_23_pt)
___DEF_P_HLBL(___L13_c_23_pt)
___DEF_P_HLBL(___L14_c_23_pt)
___DEF_P_HLBL(___L15_c_23_pt)
___DEF_P_HLBL(___L16_c_23_pt)
___DEF_P_HLBL(___L17_c_23_pt)
___DEF_P_HLBL(___L18_c_23_pt)
___DEF_P_HLBL(___L19_c_23_pt)
___DEF_P_HLBL(___L20_c_23_pt)
___DEF_P_HLBL(___L21_c_23_pt)
___DEF_P_HLBL(___L22_c_23_pt)
___DEF_P_HLBL(___L23_c_23_pt)
___DEF_P_HLBL(___L24_c_23_pt)
___DEF_P_HLBL(___L25_c_23_pt)
___DEF_P_HLBL(___L26_c_23_pt)
___DEF_P_HLBL(___L27_c_23_pt)
___DEF_P_HLBL(___L28_c_23_pt)
___DEF_P_HLBL(___L29_c_23_pt)
___DEF_P_HLBL(___L30_c_23_pt)
___DEF_P_HLBL(___L31_c_23_pt)
___DEF_P_HLBL(___L32_c_23_pt)
___DEF_P_HLBL(___L33_c_23_pt)
___DEF_P_HLBL(___L34_c_23_pt)
___DEF_P_HLBL(___L35_c_23_pt)
___DEF_P_HLBL(___L36_c_23_pt)
___DEF_P_HLBL(___L37_c_23_pt)
___DEF_P_HLBL(___L38_c_23_pt)
___DEF_P_HLBL(___L39_c_23_pt)
___DEF_P_HLBL(___L40_c_23_pt)
___DEF_P_HLBL(___L41_c_23_pt)
___DEF_P_HLBL(___L42_c_23_pt)
___DEF_P_HLBL(___L43_c_23_pt)
___DEF_P_HLBL(___L44_c_23_pt)
___DEF_P_HLBL(___L45_c_23_pt)
___DEF_P_HLBL(___L46_c_23_pt)
___DEF_P_HLBL(___L47_c_23_pt)
___DEF_P_HLBL(___L48_c_23_pt)
___DEF_P_HLBL(___L49_c_23_pt)
___DEF_P_HLBL(___L50_c_23_pt)
___DEF_P_HLBL(___L51_c_23_pt)
___DEF_P_HLBL(___L52_c_23_pt)
___DEF_P_HLBL(___L53_c_23_pt)
___DEF_P_HLBL(___L54_c_23_pt)
___DEF_P_HLBL(___L55_c_23_pt)
___DEF_P_HLBL(___L56_c_23_pt)
___DEF_P_HLBL(___L57_c_23_pt)
___DEF_P_HLBL(___L58_c_23_pt)
___DEF_P_HLBL(___L59_c_23_pt)
___DEF_P_HLBL(___L60_c_23_pt)
___DEF_P_HLBL(___L61_c_23_pt)
___DEF_P_HLBL(___L62_c_23_pt)
___DEF_P_HLBL(___L63_c_23_pt)
___DEF_P_HLBL(___L64_c_23_pt)
___DEF_P_HLBL(___L65_c_23_pt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt)
   ___GOTO(___L66_c_23_pt)
___DEF_SLBL(1,___L1_c_23_pt)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pt)
___DEF_GLBL(___L66_c_23_pt)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt)
   ___JUMPINT(___SET_NARGS(2),___PRC(1705),___L_c_23_macro_2d_expr_3f_)
___DEF_SLBL(4,___L4_c_23_pt)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L98_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(1563),___L_c_23_self_2d_eval_2d_expr_3f_)
___DEF_SLBL(5,___L5_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L67_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(834),___L_c_23_pt_2d_self_2d_eval)
___DEF_GLBL(___L67_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(1582),___L_c_23__2a__2a_quote_2d_expr_3f_)
___DEF_SLBL(7,___L7_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L68_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(840),___L_c_23_pt_2d_quote)
___DEF_GLBL(___L68_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(1585),___L_c_23__2a__2a_quasiquote_2d_expr_3f_)
___DEF_SLBL(9,___L9_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L69_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(847),___L_c_23_pt_2d_quasiquote)
___DEF_GLBL(___L69_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(2),___PRC(1597),___L_c_23_var_2d_expr_3f_)
___DEF_SLBL(11,___L11_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L70_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(962),___L_c_23_pt_2d_var)
___DEF_GLBL(___L70_c_23_pt)
   ___SET_STK(-3,___STK(-6))
   ___SET_R3(___STK(-3))
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_set_21__2d_sym)
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(13,___L13_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L71_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(969),___L_c_23_pt_2d_set_21_)
___DEF_GLBL(___L71_c_23_pt)
   ___SET_STK(-3,___STK(-6))
   ___SET_R3(___STK(-3))
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_lambda_2d_sym)
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(15,___L15_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L72_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(979),___L_c_23_pt_2d_lambda)
___DEF_GLBL(___L72_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(1),___PRC(1624),___L_c_23__2a__2a_if_2d_expr_3f_)
___DEF_SLBL(17,___L17_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L73_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1205),___L_c_23_pt_2d_if)
___DEF_GLBL(___L73_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___JUMPINT(___SET_NARGS(1),___PRC(1633),___L_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_SLBL(19,___L19_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L74_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1214),___L_c_23_pt_2d_cond)
___DEF_GLBL(___L74_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(1),___PRC(1639),___L_c_23__2a__2a_and_2d_expr_3f_)
___DEF_SLBL(21,___L21_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L75_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1238),___L_c_23_pt_2d_and)
___DEF_GLBL(___L75_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___JUMPINT(___SET_NARGS(1),___PRC(1642),___L_c_23__2a__2a_or_2d_expr_3f_)
___DEF_SLBL(23,___L23_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L76_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1251),___L_c_23_pt_2d_or)
___DEF_GLBL(___L76_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(1),___PRC(1645),___L_c_23__2a__2a_case_2d_expr_3f_)
___DEF_SLBL(25,___L25_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L77_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1264),___L_c_23_pt_2d_case)
___DEF_GLBL(___L77_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(1651),___L_c_23__2a__2a_let_2d_expr_3f_)
___DEF_SLBL(27,___L27_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L78_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1300),___L_c_23_pt_2d_let)
___DEF_GLBL(___L78_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(29))
   ___JUMPINT(___SET_NARGS(2),___PRC(1663),___L_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_SLBL(29,___L29_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L79_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1358),___L_c_23_pt_2d_let_2a_)
___DEF_GLBL(___L79_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(31))
   ___JUMPINT(___SET_NARGS(2),___PRC(1670),___L_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_SLBL(31,___L31_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L80_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1376),___L_c_23_pt_2d_letrec)
___DEF_GLBL(___L80_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(33))
   ___JUMPINT(___SET_NARGS(1),___PRC(1721),___L_c_23__2a__2a_begin_2d_expr_3f_)
___DEF_SLBL(33,___L33_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L81_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(34)
___DEF_SLBL(34,___L34_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1466),___L_c_23_pt_2d_begin)
___DEF_GLBL(___L81_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(35))
   ___JUMPINT(___SET_NARGS(2),___PRC(1677),___L_c_23__2a__2a_do_2d_expr_3f_)
___DEF_SLBL(35,___L35_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L82_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1471),___L_c_23_pt_2d_do)
___DEF_GLBL(___L82_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(37))
   ___JUMPINT(___SET_NARGS(2),___PRC(1693),___L_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_SLBL(37,___L37_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L83_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1543),___L_c_23_pt_2d_delay)
___DEF_GLBL(___L83_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(39))
   ___JUMPINT(___SET_NARGS(2),___PRC(1699),___L_c_23__2a__2a_future_2d_expr_3f_)
___DEF_SLBL(39,___L39_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L84_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(40)
___DEF_SLBL(40,___L40_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1557),___L_c_23_pt_2d_future)
___DEF_GLBL(___L84_c_23_pt)
   ___SET_STK(-3,___STK(-6))
   ___SET_R3(___STK(-3))
   ___SET_R2(___FIX(-2L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_sym)
   ___SET_R0(___LBL(41))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(41,___L41_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L87_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(26))
   ___SET_R0(___STK(-7))
   ___POLL(42)
___DEF_SLBL(42,___L42_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_SLBL(43,___L43_c_23_pt)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L86_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(27))
   ___SET_R0(___STK(-7))
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_pt)
___DEF_GLBL(___L85_c_23_pt)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L86_c_23_pt)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(45)
___DEF_SLBL(45,___L45_c_23_pt)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1527),___L_c_23_pt_2d_combination)
___DEF_GLBL(___L87_c_23_pt)
   ___SET_STK(-3,___STK(-6))
   ___SET_R3(___STK(-3))
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_macro_2d_sym)
   ___SET_R0(___LBL(46))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(46,___L46_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L88_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(28))
   ___SET_R0(___STK(-7))
   ___POLL(47)
___DEF_SLBL(47,___L47_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L88_c_23_pt)
   ___SET_STK(-3,___STK(-6))
   ___SET_R3(___STK(-3))
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_syntax_2d_sym)
   ___SET_R0(___LBL(48))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(48,___L48_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L89_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(29))
   ___SET_R0(___STK(-7))
   ___POLL(49)
___DEF_SLBL(49,___L49_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L89_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(50))
   ___JUMPINT(___SET_NARGS(1),___PRC(1733),___L_c_23__2a__2a_include_2d_expr_3f_)
___DEF_SLBL(50,___L50_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L90_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(30))
   ___SET_R0(___STK(-7))
   ___POLL(51)
___DEF_SLBL(51,___L51_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L90_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(52))
   ___JUMPINT(___SET_NARGS(1),___PRC(1742),___L_c_23__2a__2a_declare_2d_expr_3f_)
___DEF_SLBL(52,___L52_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L91_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(31))
   ___SET_R0(___STK(-7))
   ___POLL(53)
___DEF_SLBL(53,___L53_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L91_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(54))
   ___JUMPINT(___SET_NARGS(1),___PRC(1745),___L_c_23__2a__2a_namespace_2d_expr_3f_)
___DEF_SLBL(54,___L54_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L92_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(32))
   ___SET_R0(___STK(-7))
   ___POLL(55)
___DEF_SLBL(55,___L55_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L92_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(56))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),252,___G_c_23__2a__2a_c_2d_define_2d_type_2d_expr_3f_)
___DEF_SLBL(56,___L56_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L93_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(33))
   ___SET_R0(___STK(-7))
   ___POLL(57)
___DEF_SLBL(57,___L57_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L93_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(58))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),250,___G_c_23__2a__2a_c_2d_declare_2d_expr_3f_)
___DEF_SLBL(58,___L58_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L94_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(34))
   ___SET_R0(___STK(-7))
   ___POLL(59)
___DEF_SLBL(59,___L59_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L94_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(60))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),253,___G_c_23__2a__2a_c_2d_initialize_2d_expr_3f_)
___DEF_SLBL(60,___L60_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L95_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(35))
   ___SET_R0(___STK(-7))
   ___POLL(61)
___DEF_SLBL(61,___L61_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L95_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(62))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),254,___G_c_23__2a__2a_c_2d_lambda_2d_expr_3f_)
___DEF_SLBL(62,___L62_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L96_c_23_pt)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(63)
___DEF_SLBL(63,___L63_c_23_pt)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),376,___G_c_23_pt_2d_c_2d_lambda)
___DEF_GLBL(___L96_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(64))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),251,___G_c_23__2a__2a_c_2d_define_2d_expr_3f_)
___DEF_SLBL(64,___L64_c_23_pt)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L97_c_23_pt)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(36))
   ___SET_R0(___STK(-7))
   ___POLL(65)
___DEF_SLBL(65,___L65_c_23_pt)
   ___GOTO(___L85_c_23_pt)
___DEF_GLBL(___L97_c_23_pt)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(43))
   ___JUMPINT(___SET_NARGS(1),___PRC(1684),___L_c_23_combination_2d_expr_3f_)
___DEF_GLBL(___L98_c_23_pt)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(2),___PRC(823),___L_c_23_macro_2d_expand)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_macro_2d_expand
#undef ___PH_LBL0
#define ___PH_LBL0 823
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_macro_2d_expand)
___DEF_P_HLBL(___L1_c_23_macro_2d_expand)
___DEF_P_HLBL(___L2_c_23_macro_2d_expand)
___DEF_P_HLBL(___L3_c_23_macro_2d_expand)
___DEF_P_HLBL(___L4_c_23_macro_2d_expand)
___DEF_P_HLBL(___L5_c_23_macro_2d_expand)
___DEF_P_HLBL(___L6_c_23_macro_2d_expand)
___DEF_P_HLBL(___L7_c_23_macro_2d_expand)
___DEF_P_HLBL(___L8_c_23_macro_2d_expand)
___DEF_P_HLBL(___L9_c_23_macro_2d_expand)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_macro_2d_expand)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_macro_2d_expand)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_macro_2d_expand)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_macro_2d_expand)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_macro_2d_expand)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),331,___G_c_23_env_2d_lookup_2d_macro)
___DEF_SLBL(4,___L4_c_23_macro_2d_expand)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),239,___G__23__23_macro_2d_descr_2d_expander)
___DEF_SLBL(5,___L5_c_23_macro_2d_expand)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),238,___G__23__23_macro_2d_descr_2d_def_2d_syntax_3f_)
___DEF_SLBL(6,___L6_c_23_macro_2d_expand)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L10_c_23_macro_2d_expand)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___DEF_SLBL(7,___L7_c_23_macro_2d_expand)
   ___SET_R2(___CDR(___R1))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(8))
   ___JUMPPRM(___SET_NARGS(2),___PRM_apply)
___DEF_SLBL(8,___L8_c_23_macro_2d_expand)
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_macro_2d_expand)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),245,___G__23__23_sourcify_2d_deep)
___DEF_GLBL(___L10_c_23_macro_2d_expand)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_self_2d_eval
#undef ___PH_LBL0
#define ___PH_LBL0 834
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_self_2d_eval)
___DEF_P_HLBL(___L1_c_23_pt_2d_self_2d_eval)
___DEF_P_HLBL(___L2_c_23_pt_2d_self_2d_eval)
___DEF_P_HLBL(___L3_c_23_pt_2d_self_2d_eval)
___DEF_P_HLBL(___L4_c_23_pt_2d_self_2d_eval)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_self_2d_eval)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_self_2d_eval)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_self_2d_eval)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___DEF_SLBL(2,___L2_c_23_pt_2d_self_2d_eval)
   ___IF(___NOT(___EQP(___STK(-4),___SYM_none)))
   ___GOTO(___L5_c_23_pt_2d_self_2d_eval)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_self_2d_eval)
   ___GOTO(___L6_c_23_pt_2d_self_2d_eval)
___DEF_GLBL(___L5_c_23_pt_2d_self_2d_eval)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_pt_2d_self_2d_eval)
___DEF_GLBL(___L6_c_23_pt_2d_self_2d_eval)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_quote
#undef ___PH_LBL0
#define ___PH_LBL0 840
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_quote)
___DEF_P_HLBL(___L1_c_23_pt_2d_quote)
___DEF_P_HLBL(___L2_c_23_pt_2d_quote)
___DEF_P_HLBL(___L3_c_23_pt_2d_quote)
___DEF_P_HLBL(___L4_c_23_pt_2d_quote)
___DEF_P_HLBL(___L5_c_23_pt_2d_quote)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_quote)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_quote)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_quote)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_quote)
   ___IF(___NOT(___EQP(___STK(-3),___SYM_none)))
   ___GOTO(___L7_c_23_pt_2d_quote)
   ___END_IF
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___STK(-6))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_quote)
   ___GOTO(___L6_c_23_pt_2d_quote)
___DEF_SLBL(4,___L4_c_23_pt_2d_quote)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_quote)
___DEF_GLBL(___L6_c_23_pt_2d_quote)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L7_c_23_pt_2d_quote)
   ___SET_R1(___CADR(___R1))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_quasiquote
#undef ___PH_LBL0
#define ___PH_LBL0 847
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_quasiquote)
___DEF_P_HLBL(___L1_c_23_pt_2d_quasiquote)
___DEF_P_HLBL(___L2_c_23_pt_2d_quasiquote)
___DEF_P_HLBL(___L3_c_23_pt_2d_quasiquote)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_quasiquote)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_quasiquote)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_quasiquote)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_quasiquote)
   ___SET_R3(___STK(-6))
   ___SET_R1(___CADR(___R1))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_quasiquote)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(852),___L_c_23_pt_2d_quasiquotation)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_quasiquotation
#undef ___PH_LBL0
#define ___PH_LBL0 852
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L1_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L2_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L3_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L4_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L5_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L6_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L7_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L8_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L9_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L10_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L11_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L12_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L13_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L14_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L15_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L16_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L17_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L18_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L19_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L20_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L21_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L22_c_23_pt_2d_quasiquotation)
___DEF_P_HLBL(___L23_c_23_pt_2d_quasiquotation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_quasiquotation)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_quasiquotation)
   ___IF(___NOT(___FIXEQ(___R2,___FIX(0L))))
   ___GOTO(___L24_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___SET_R2(___R3)
   ___SET_R3(___SYM_true)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_quasiquotation)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L24_c_23_pt_2d_quasiquotation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pt_2d_quasiquotation)
   ___JUMPINT(___SET_NARGS(1),___PRC(1588),___L_c_23_quasiquote_2d_expr_3f_)
___DEF_SLBL(3,___L3_c_23_pt_2d_quasiquotation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L32_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(1591),___L_c_23_unquote_2d_expr_3f_)
___DEF_SLBL(4,___L4_c_23_pt_2d_quasiquotation)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L31_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___IF(___NOT(___FIXEQ(___STK(-5),___FIX(1L))))
   ___GOTO(___L25_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(5,___L5_c_23_pt_2d_quasiquotation)
   ___SET_R1(___CADR(___R1))
   ___SET_R2(___STK(-4))
   ___SET_R3(___SYM_true)
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_quasiquotation)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(7,___L7_c_23_pt_2d_quasiquotation)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L27_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___IF(___FIXEQ(___STK(-5),___FIX(1L)))
   ___GOTO(___L30_c_23_pt_2d_quasiquotation)
   ___END_IF
___DEF_GLBL(___L25_c_23_pt_2d_quasiquotation)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(8,___L8_c_23_pt_2d_quasiquotation)
   ___SET_R3(___STK(-4))
   ___SET_R2(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R0(___STK(-3))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_pt_2d_quasiquotation)
   ___GOTO(___L26_c_23_pt_2d_quasiquotation)
___DEF_SLBL(10,___L10_c_23_pt_2d_quasiquotation)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-3))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_quasiquotation)
___DEF_GLBL(___L26_c_23_pt_2d_quasiquotation)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(877),___L_c_23_pt_2d_quasiquotation_2d_list)
___DEF_GLBL(___L27_c_23_pt_2d_quasiquotation)
   ___SET_STK(-3,___STK(-6))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(12,___L12_c_23_pt_2d_quasiquotation)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L28_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_GLBL(___L28_c_23_pt_2d_quasiquotation)
   ___SET_STK(-3,___STK(-6))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(13,___L13_c_23_pt_2d_quasiquotation)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),411,___G_c_23_vector_2d_object_3f_)
___DEF_SLBL(14,___L14_c_23_pt_2d_quasiquotation)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L29_c_23_pt_2d_quasiquotation)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___DEF_SLBL(15,___L15_c_23_pt_2d_quasiquotation)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_pt_2d_quasiquotation)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L29_c_23_pt_2d_quasiquotation)
   ___SET_STK(-3,___STK(-6))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(17,___L17_c_23_pt_2d_quasiquotation)
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),410,___G_c_23_vect_2d__3e_list)
___DEF_SLBL(18,___L18_c_23_pt_2d_quasiquotation)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(19))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(877),___L_c_23_pt_2d_quasiquotation_2d_list)
___DEF_SLBL(19,___L19_c_23_pt_2d_quasiquotation)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_pt_2d_quasiquotation)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(926),___L_c_23_vector_2d_form)
___DEF_GLBL(___L30_c_23_pt_2d_quasiquotation)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(37))
   ___SET_R0(___STK(-7))
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_pt_2d_quasiquotation)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L31_c_23_pt_2d_quasiquotation)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(1594),___L_c_23_unquote_2d_splicing_2d_expr_3f_)
___DEF_GLBL(___L32_c_23_pt_2d_quasiquotation)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(22,___L22_c_23_pt_2d_quasiquotation)
   ___SET_R3(___STK(-4))
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R0(___STK(-3))
   ___POLL(23)
___DEF_SLBL(23,___L23_c_23_pt_2d_quasiquotation)
   ___GOTO(___L26_c_23_pt_2d_quasiquotation)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_quasiquotation_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 877
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L1_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L2_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L3_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L4_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L5_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L6_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L7_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L8_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L9_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L10_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L11_c_23_pt_2d_quasiquotation_2d_list)
___DEF_P_HLBL(___L12_c_23_pt_2d_quasiquotation_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_quasiquotation_2d_list)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_pt_2d_quasiquotation_2d_list)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L13_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
   ___GOTO(___L15_c_23_pt_2d_quasiquotation_2d_list)
___DEF_SLBL(1,___L1_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_R2(___CDR(___STK(-5)))
   ___IF(___NULLP(___R2))
   ___GOTO(___L17_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
   ___SET_R2(___CAR(___STK(-5)))
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___R2)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-4))
   ___SET_R3(___STK(-3))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(11))
   ___ADJFP(5)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L15_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
___DEF_GLBL(___L13_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_R4(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___R4)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23_unquote_2d_splicing_2d_sym)
   ___SET_R0(___LBL(3))
   ___ADJFP(7)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pt_2d_quasiquotation_2d_list)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(3,___L3_c_23_pt_2d_quasiquotation_2d_list)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L14_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
   ___IF(___NOT(___FIXEQ(___STK(-4),___FIX(1L))))
   ___GOTO(___L14_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_R1(___CADR(___R1))
   ___SET_R2(___STK(-3))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L14_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(3),___PRC(852),___L_c_23_pt_2d_quasiquotation)
___DEF_SLBL(5,___L5_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-7))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___LBL(8))
   ___ADJFP(5)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L13_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
___DEF_GLBL(___L15_c_23_pt_2d_quasiquotation_2d_list)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L16_c_23_pt_2d_quasiquotation_2d_list)
   ___END_IF
   ___SET_R2(___R3)
   ___SET_R1(___STK(0))
   ___SET_R3(___NUL)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_quasiquotation_2d_list)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L16_c_23_pt_2d_quasiquotation_2d_list)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_quasiquotation_2d_list)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(3),___PRC(852),___L_c_23_pt_2d_quasiquotation)
___DEF_SLBL(8,___L8_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-7))
   ___SET_R0(___STK(-10))
   ___SET_R1(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_pt_2d_quasiquotation_2d_list)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(904),___L_c_23_cons_2d_form)
___DEF_GLBL(___L17_c_23_pt_2d_quasiquotation_2d_list)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_pt_2d_quasiquotation_2d_list)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_SLBL(11,___L11_c_23_pt_2d_quasiquotation_2d_list)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-7))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-10))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_pt_2d_quasiquotation_2d_list)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(891),___L_c_23_append_2d_form)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_append_2d_form
#undef ___PH_LBL0
#define ___PH_LBL0 891
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_append_2d_form)
___DEF_P_HLBL(___L1_c_23_append_2d_form)
___DEF_P_HLBL(___L2_c_23_append_2d_form)
___DEF_P_HLBL(___L3_c_23_append_2d_form)
___DEF_P_HLBL(___L4_c_23_append_2d_form)
___DEF_P_HLBL(___L5_c_23_append_2d_form)
___DEF_P_HLBL(___L6_c_23_append_2d_form)
___DEF_P_HLBL(___L7_c_23_append_2d_form)
___DEF_P_HLBL(___L8_c_23_append_2d_form)
___DEF_P_HLBL(___L9_c_23_append_2d_form)
___DEF_P_HLBL(___L10_c_23_append_2d_form)
___DEF_P_HLBL(___L11_c_23_append_2d_form)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_append_2d_form)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_append_2d_form)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_append_2d_form)
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(2,___L2_c_23_append_2d_form)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L12_c_23_append_2d_form)
   ___END_IF
   ___GOTO(___L15_c_23_append_2d_form)
___DEF_SLBL(3,___L3_c_23_append_2d_form)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L14_c_23_append_2d_form)
   ___END_IF
___DEF_GLBL(___L12_c_23_append_2d_form)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(4,___L4_c_23_append_2d_form)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L13_c_23_append_2d_form)
   ___END_IF
   ___SET_STK(-2,___STK(-4))
   ___SET_R1(___VECTORREF(___STK(-2),___FIX(8L)))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L13_c_23_append_2d_form)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_append_2d_form)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L13_c_23_append_2d_form)
   ___SET_STK(-2,___GLO_c_23__2a__2a_quasi_2d_append_2d_sym)
   ___BEGIN_ALLOC_LIST(2,___STK(-4))
   ___ADD_LIST_ELEM(1,___STK(-5))
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-3))
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_safe_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_append_2d_form)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(7,___L7_c_23_append_2d_form)
   ___SET_STK(-8,___R1)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(8))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(201),___L_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_SLBL(8,___L8_c_23_append_2d_form)
   ___SET_R3(___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_append_2d_form)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_GLBL(___L14_c_23_append_2d_form)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(8L)))
   ___SET_STK(-5,___R1)
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(8L)))
   ___SET_R0(___LBL(10))
   ___SET_R1(___STK(-5))
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(10,___L10_c_23_append_2d_form)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-6))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_append_2d_form)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L15_c_23_append_2d_form)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_cons_2d_form
#undef ___PH_LBL0
#define ___PH_LBL0 904
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_cons_2d_form)
___DEF_P_HLBL(___L1_c_23_cons_2d_form)
___DEF_P_HLBL(___L2_c_23_cons_2d_form)
___DEF_P_HLBL(___L3_c_23_cons_2d_form)
___DEF_P_HLBL(___L4_c_23_cons_2d_form)
___DEF_P_HLBL(___L5_c_23_cons_2d_form)
___DEF_P_HLBL(___L6_c_23_cons_2d_form)
___DEF_P_HLBL(___L7_c_23_cons_2d_form)
___DEF_P_HLBL(___L8_c_23_cons_2d_form)
___DEF_P_HLBL(___L9_c_23_cons_2d_form)
___DEF_P_HLBL(___L10_c_23_cons_2d_form)
___DEF_P_HLBL(___L11_c_23_cons_2d_form)
___DEF_P_HLBL(___L12_c_23_cons_2d_form)
___DEF_P_HLBL(___L13_c_23_cons_2d_form)
___DEF_P_HLBL(___L14_c_23_cons_2d_form)
___DEF_P_HLBL(___L15_c_23_cons_2d_form)
___DEF_P_HLBL(___L16_c_23_cons_2d_form)
___DEF_P_HLBL(___L17_c_23_cons_2d_form)
___DEF_P_HLBL(___L18_c_23_cons_2d_form)
___DEF_P_HLBL(___L19_c_23_cons_2d_form)
___DEF_P_HLBL(___L20_c_23_cons_2d_form)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_cons_2d_form)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_cons_2d_form)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_cons_2d_form)
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(2,___L2_c_23_cons_2d_form)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L21_c_23_cons_2d_form)
   ___END_IF
   ___GOTO(___L28_c_23_cons_2d_form)
___DEF_SLBL(3,___L3_c_23_cons_2d_form)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L27_c_23_cons_2d_form)
   ___END_IF
___DEF_GLBL(___L21_c_23_cons_2d_form)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(4,___L4_c_23_cons_2d_form)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L23_c_23_cons_2d_form)
   ___END_IF
   ___SET_STK(-2,___STK(-4))
   ___SET_R1(___VECTORREF(___STK(-2),___FIX(8L)))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L23_c_23_cons_2d_form)
   ___END_IF
   ___SET_R3(___CONS(___STK(-5),___NUL))
   ___SET_R1(___STK(-3))
   ___SET_R2(___GLO_c_23__2a__2a_quasi_2d_list_2d_sym)
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_cons_2d_form)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_cons_2d_form)
   ___GOTO(___L22_c_23_cons_2d_form)
___DEF_SLBL(7,___L7_c_23_cons_2d_form)
   ___SET_R3(___CONS(___STK(-5),___R1))
   ___SET_R1(___STK(-3))
   ___SET_R2(___GLO_c_23__2a__2a_quasi_2d_list_2d_sym)
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23_cons_2d_form)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_cons_2d_form)
___DEF_GLBL(___L22_c_23_cons_2d_form)
   ___SET_STK(1,___STK(0))
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___SET_STK(5,___R2)
   ___SET_STK(6,___R3)
   ___SET_R1(___STK(2))
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_safe_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(12))
   ___ADJFP(11)
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_cons_2d_form)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_cons_2d_form)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(12,___L12_c_23_cons_2d_form)
   ___SET_STK(-9,___R1)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(3),___PRC(201),___L_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_SLBL(13,___L13_c_23_cons_2d_form)
   ___SET_STK(-11,___STK(-10))
   ___SET_R3(___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-8))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_cons_2d_form)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_GLBL(___L23_c_23_cons_2d_form)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(1),___PRC(168),___L_c_23_app_3f_)
___DEF_SLBL(15,___L15_c_23_cons_2d_form)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L26_c_23_cons_2d_form)
   ___END_IF
   ___IF(___FALSEP(___R1))
   ___GOTO(___L24_c_23_cons_2d_form)
   ___END_IF
   ___GOTO(___L25_c_23_cons_2d_form)
___DEF_SLBL(16,___L16_c_23_cons_2d_form)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L25_c_23_cons_2d_form)
   ___END_IF
___DEF_GLBL(___L24_c_23_cons_2d_form)
   ___BEGIN_ALLOC_LIST(2,___STK(-4))
   ___ADD_LIST_ELEM(1,___STK(-5))
   ___END_ALLOC_LIST(2)
   ___SET_R3(___GET_LIST(2))
   ___SET_R1(___STK(-3))
   ___SET_R2(___GLO_c_23__2a__2a_quasi_2d_cons_2d_sym)
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_c_23_cons_2d_form)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_cons_2d_form)
   ___GOTO(___L22_c_23_cons_2d_form)
___DEF_GLBL(___L25_c_23_cons_2d_form)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj)))
   ___GOTO(___L24_c_23_cons_2d_form)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(333),___L_c_23_app_2d_args)
___DEF_GLBL(___L26_c_23_cons_2d_form)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(492),___L_c_23_app_2d__3e_specialized_2d_proc)
___DEF_GLBL(___L27_c_23_cons_2d_form)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(8L)))
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(8L)))
   ___SET_R3(___CONS(___R1,___R2))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-6))
   ___CHECK_HEAP(19,4096)
___DEF_SLBL(19,___L19_c_23_cons_2d_form)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_cons_2d_form)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L28_c_23_cons_2d_form)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_vector_2d_form
#undef ___PH_LBL0
#define ___PH_LBL0 926
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_vector_2d_form)
___DEF_P_HLBL(___L1_c_23_vector_2d_form)
___DEF_P_HLBL(___L2_c_23_vector_2d_form)
___DEF_P_HLBL(___L3_c_23_vector_2d_form)
___DEF_P_HLBL(___L4_c_23_vector_2d_form)
___DEF_P_HLBL(___L5_c_23_vector_2d_form)
___DEF_P_HLBL(___L6_c_23_vector_2d_form)
___DEF_P_HLBL(___L7_c_23_vector_2d_form)
___DEF_P_HLBL(___L8_c_23_vector_2d_form)
___DEF_P_HLBL(___L9_c_23_vector_2d_form)
___DEF_P_HLBL(___L10_c_23_vector_2d_form)
___DEF_P_HLBL(___L11_c_23_vector_2d_form)
___DEF_P_HLBL(___L12_c_23_vector_2d_form)
___DEF_P_HLBL(___L13_c_23_vector_2d_form)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_vector_2d_form)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_vector_2d_form)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_vector_2d_form)
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(2,___L2_c_23_vector_2d_form)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L16_c_23_vector_2d_form)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(3),___PRC(941),___L_c_23_list_2d_construction_3f_)
___DEF_SLBL(3,___L3_c_23_vector_2d_form)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L14_c_23_vector_2d_form)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R3(___CONS(___STK(-5),___NUL))
   ___SET_R1(___STK(-4))
   ___SET_R2(___GLO_c_23__2a__2a_quasi_2d_list_2d__3e_vector_2d_sym)
   ___SET_R0(___STK(-3))
   ___ADJFP(-7)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_vector_2d_form)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_vector_2d_form)
   ___GOTO(___L15_c_23_vector_2d_form)
___DEF_GLBL(___L14_c_23_vector_2d_form)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R3(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R2(___GLO_c_23__2a__2a_quasi_2d_vector_2d_sym)
   ___SET_R0(___STK(-5))
   ___ADJFP(-7)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_vector_2d_form)
___DEF_GLBL(___L15_c_23_vector_2d_form)
   ___SET_STK(1,___STK(0))
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___SET_STK(5,___R2)
   ___SET_STK(6,___R3)
   ___SET_R1(___STK(2))
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_safe_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(9))
   ___ADJFP(11)
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_vector_2d_form)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_vector_2d_form)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(9,___L9_c_23_vector_2d_form)
   ___SET_STK(-9,___R1)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(3),___PRC(201),___L_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_SLBL(10,___L10_c_23_vector_2d_form)
   ___SET_STK(-11,___STK(-10))
   ___SET_R3(___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-8))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_vector_2d_form)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_GLBL(___L16_c_23_vector_2d_form)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(8L)))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),355,___G_c_23_list_2d__3e_vect)
___DEF_SLBL(12,___L12_c_23_vector_2d_form)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_vector_2d_form)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_list_2d_construction_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 941
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L1_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L2_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L3_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L4_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L5_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L6_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L7_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L8_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L9_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L10_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L11_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L12_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L13_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L14_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L15_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L16_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L17_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L18_c_23_list_2d_construction_3f_)
___DEF_P_HLBL(___L19_c_23_list_2d_construction_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_list_2d_construction_3f_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_list_2d_construction_3f_)
   ___GOTO(___L20_c_23_list_2d_construction_3f_)
___DEF_SLBL(1,___L1_c_23_list_2d_construction_3f_)
   ___IF(___NOT(___EQP(___FIX(2L),___R1)))
   ___GOTO(___L22_c_23_list_2d_construction_3f_)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R2(___CADR(___STK(-5)))
   ___SET_STK(-5,___R1)
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
___DEF_GLBL(___L20_c_23_list_2d_construction_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_list_2d_construction_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(3,___L3_c_23_list_2d_construction_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L27_c_23_list_2d_construction_3f_)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(168),___L_c_23_app_3f_)
___DEF_SLBL(4,___L4_c_23_list_2d_construction_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L26_c_23_list_2d_construction_3f_)
   ___END_IF
   ___IF(___FALSEP(___R1))
   ___GOTO(___L22_c_23_list_2d_construction_3f_)
   ___END_IF
   ___GOTO(___L21_c_23_list_2d_construction_3f_)
___DEF_SLBL(5,___L5_c_23_list_2d_construction_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L22_c_23_list_2d_construction_3f_)
   ___END_IF
___DEF_GLBL(___L21_c_23_list_2d_construction_3f_)
   ___IF(___EQP(___R1,___GLO_c_23__2a__2a_quasi_2d_cons_2d_proc_2d_obj))
   ___GOTO(___L24_c_23_list_2d_construction_3f_)
   ___END_IF
   ___IF(___EQP(___R1,___GLO_c_23__2a__2a_quasi_2d_list_2d_proc_2d_obj))
   ___GOTO(___L25_c_23_list_2d_construction_3f_)
   ___END_IF
___DEF_GLBL(___L22_c_23_list_2d_construction_3f_)
   ___SET_R1(___FAL)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_list_2d_construction_3f_)
___DEF_GLBL(___L23_c_23_list_2d_construction_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L24_c_23_list_2d_construction_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(333),___L_c_23_app_2d_args)
___DEF_SLBL(7,___L7_c_23_list_2d_construction_3f_)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_GLBL(___L25_c_23_list_2d_construction_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_list_2d_construction_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(333),___L_c_23_app_2d_args)
___DEF_GLBL(___L26_c_23_list_2d_construction_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(492),___L_c_23_app_2d__3e_specialized_2d_proc)
___DEF_GLBL(___L27_c_23_list_2d_construction_3f_)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(8L)))
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(9,___L9_c_23_list_2d_construction_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L22_c_23_list_2d_construction_3f_)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_list_2d_construction_3f_)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L28_c_23_list_2d_construction_3f_)
   ___END_IF
   ___GOTO(___L29_c_23_list_2d_construction_3f_)
___DEF_SLBL(11,___L11_c_23_list_2d_construction_3f_)
   ___SET_STK(-3,___R1)
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L29_c_23_list_2d_construction_3f_)
   ___END_IF
___DEF_GLBL(___L28_c_23_list_2d_construction_3f_)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___R4)
   ___SET_R0(___LBL(11))
   ___ADJFP(8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_list_2d_construction_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L29_c_23_list_2d_construction_3f_)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(13,___L13_c_23_list_2d_construction_3f_)
   ___SET_R1(___CONS(___STK(-3),___R1))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_list_2d_construction_3f_)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_list_2d_construction_3f_)
   ___GOTO(___L23_c_23_list_2d_construction_3f_)
___DEF_SLBL(16,___L16_c_23_list_2d_construction_3f_)
   ___SET_STK(-6,___R1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L30_c_23_list_2d_construction_3f_)
   ___END_IF
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_list_2d_construction_3f_)
   ___GOTO(___L23_c_23_list_2d_construction_3f_)
___DEF_GLBL(___L30_c_23_list_2d_construction_3f_)
   ___SET_R1(___CONS(___STK(-5),___STK(-6)))
   ___CHECK_HEAP(18,4096)
___DEF_SLBL(18,___L18_c_23_list_2d_construction_3f_)
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_list_2d_construction_3f_)
   ___GOTO(___L23_c_23_list_2d_construction_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 962
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_var)
___DEF_P_HLBL(___L1_c_23_pt_2d_var)
___DEF_P_HLBL(___L2_c_23_pt_2d_var)
___DEF_P_HLBL(___L3_c_23_pt_2d_var)
___DEF_P_HLBL(___L4_c_23_pt_2d_var)
___DEF_P_HLBL(___L5_c_23_pt_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_var)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_var)
   ___IF(___NOT(___EQP(___R3,___SYM_none)))
   ___GOTO(___L6_c_23_pt_2d_var)
   ___END_IF
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_var)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L6_c_23_pt_2d_var)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pt_2d_var)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_pt_2d_var)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),332,___G_c_23_env_2d_lookup_2d_var)
___DEF_SLBL(4,___L4_c_23_pt_2d_var)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_var)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 969
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L1_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L2_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L3_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L4_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L5_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L6_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L7_c_23_pt_2d_set_21_)
___DEF_P_HLBL(___L8_c_23_pt_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_set_21_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_set_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_set_21_)
   ___SET_R2(___CADR(___R1))
   ___SET_STK(-7,___R1)
   ___SET_STK(-3,___R2)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(1597),___L_c_23_var_2d_expr_3f_)
___DEF_SLBL(3,___L3_c_23_pt_2d_set_21_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23_pt_2d_set_21_)
   ___END_IF
   ___GOTO(___L9_c_23_pt_2d_set_21_)
___DEF_SLBL(4,___L4_c_23_pt_2d_set_21_)
___DEF_GLBL(___L9_c_23_pt_2d_set_21_)
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-7,___STK(-5))
   ___SET_STK(-5,___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(5,___L5_c_23_pt_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),332,___G_c_23_env_2d_lookup_2d_var)
___DEF_SLBL(6,___L6_c_23_pt_2d_set_21_)
   ___SET_STK(-9,___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___CADDR(___STK(-6)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(7))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(7,___L7_c_23_pt_2d_set_21_)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-6))
   ___SET_R2(___STK(-5))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt_2d_set_21_)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(207),___L_c_23_new_2d_set)
___DEF_GLBL(___L10_c_23_pt_2d_set_21_)
   ___SET_R1(___STK(-3))
   ___SET_R2(___SUB(38))
   ___SET_R0(___LBL(4))
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_lambda
#undef ___PH_LBL0
#define ___PH_LBL0 979
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L1_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L2_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L3_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L4_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L5_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L6_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L7_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L8_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L9_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L10_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L11_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L12_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L13_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L14_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L15_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L16_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L17_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L18_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L19_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L20_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L21_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L22_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L23_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L24_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L25_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L26_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L27_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L28_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L29_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L30_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L31_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L32_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L33_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L34_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L35_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L36_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L37_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L38_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L39_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L40_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L41_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L42_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L43_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L44_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L45_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L46_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L47_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L48_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L49_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L50_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L51_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L52_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L53_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L54_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L55_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L56_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L57_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L58_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L59_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L60_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L61_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L62_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L63_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L64_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L65_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L66_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L67_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L68_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L69_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L70_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L71_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L72_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L73_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L74_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L75_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L76_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L77_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L78_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L79_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L80_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L81_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L82_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L83_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L84_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L85_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L86_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L87_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L88_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L89_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L90_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L91_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L92_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L93_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L94_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L95_c_23_pt_2d_lambda)
___DEF_P_HLBL(___L96_c_23_pt_2d_lambda)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_lambda)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_lambda)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_lambda)
   ___SET_R1(___CADR(___R1))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(1148),___L_c_23_source_2d__3e_parms)
___DEF_SLBL(3,___L3_c_23_pt_2d_lambda)
   ___SET_R2(___STK(-4))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(1083),___L_c_23_extract_2d_parameters)
___DEF_SLBL(4,___L4_c_23_pt_2d_lambda)
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R3(___VECTORREF(___R1,___FIX(1L)))
   ___SET_R4(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R0(___VECTORREF(___R1,___FIX(3L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___SET_STK(-7,___R0)
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R3)
   ___SET_STK(0,___R4)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(49))
   ___ADJFP(4)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L98_c_23_pt_2d_lambda)
   ___END_IF
   ___GOTO(___L100_c_23_pt_2d_lambda)
___DEF_GLBL(___L97_c_23_pt_2d_lambda)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L100_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L98_c_23_pt_2d_lambda)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___VECTORREF(___R2,___FIX(1L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_lambda)
   ___GOTO(___L97_c_23_pt_2d_lambda)
___DEF_SLBL(6,___L6_c_23_pt_2d_lambda)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_pt_2d_lambda)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt_2d_lambda)
   ___GOTO(___L99_c_23_pt_2d_lambda)
___DEF_SLBL(9,___L9_c_23_pt_2d_lambda)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_pt_2d_lambda)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_lambda)
___DEF_GLBL(___L99_c_23_pt_2d_lambda)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(12,___L12_c_23_pt_2d_lambda)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(9))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_pt_2d_lambda)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L101_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L100_c_23_pt_2d_lambda)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(14,___L14_c_23_pt_2d_lambda)
   ___SET_R0(___LBL(18))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L100_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L101_c_23_pt_2d_lambda)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R2))
   ___SET_R0(___LBL(16))
   ___ADJFP(8)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),402,___G_c_23_var_2d_name)
___DEF_SLBL(16,___L16_c_23_pt_2d_lambda)
   ___SET_R0(___LBL(17))
   ___JUMPPRM(___SET_NARGS(1),___PRM_symbol_2d__3e_string)
___DEF_SLBL(17,___L17_c_23_pt_2d_lambda)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),392,___G_c_23_string_2d__3e_keyword_2d_object)
___DEF_SLBL(18,___L18_c_23_pt_2d_lambda)
   ___SET_R2(___STK(-3))
   ___SET_R0(___STK(-11))
   ___ADJFP(-4)
   ___GOTO(___L102_c_23_pt_2d_lambda)
___DEF_SLBL(19,___L19_c_23_pt_2d_lambda)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R0(___STK(-8))
   ___SET_R1(___STK(-7))
   ___ADJFP(-9)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_pt_2d_lambda)
   ___SET_STK(1,___R1)
   ___SET_R1(___STK(-6))
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L111_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L102_c_23_pt_2d_lambda)
   ___SET_STK(-7,___R0)
   ___SET_STK(0,___R1)
   ___SET_STK(1,___R2)
   ___SET_STK(5,___STK(-6))
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-1))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(22))
   ___ADJFP(5)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_pt_2d_lambda)
   ___JUMPPRM(___SET_NARGS(4),___PRM_append)
___DEF_SLBL(22,___L22_c_23_pt_2d_lambda)
   ___SET_STK(-10,___STK(-13))
   ___SET_STK(-13,___FAL)
   ___SET_STK(-9,___STK(-12))
   ___SET_STK(-12,___FAL)
   ___SET_STK(-8,___STK(-11))
   ___SET_STK(-11,___R1)
   ___SET_STK(-5,___STK(-10))
   ___SET_STK(-10,___STK(-7))
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L105_c_23_pt_2d_lambda)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(-9))))
   ___GOTO(___L103_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_R2(___TRU)
   ___GOTO(___L104_c_23_pt_2d_lambda)
___DEF_GLBL(___L103_c_23_pt_2d_lambda)
   ___SET_R2(___SYM_dsssl)
___DEF_GLBL(___L104_c_23_pt_2d_lambda)
   ___SET_R1(___R2)
___DEF_GLBL(___L105_c_23_pt_2d_lambda)
   ___SET_STK(-9,___R1)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(23,___L23_c_23_pt_2d_lambda)
   ___SET_STK(-6,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-14))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(24,___L24_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-15))
   ___SET_R0(___LBL(46))
   ___SET_R2(___STK(-6))
   ___IF(___NULLP(___R2))
   ___GOTO(___L106_c_23_pt_2d_lambda)
   ___END_IF
   ___GOTO(___L107_c_23_pt_2d_lambda)
___DEF_SLBL(25,___L25_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R2(___CDR(___STK(-14)))
   ___SET_R1(___STK(-15))
   ___SET_R0(___LBL(31))
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L107_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L106_c_23_pt_2d_lambda)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R3)
   ___SET_R0(___LBL(27))
   ___ADJFP(8)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(27,___L27_c_23_pt_2d_lambda)
   ___SET_R1(___CDDR(___R1))
   ___SET_R2(___STK(-5))
   ___SET_R3(___SYM_true)
   ___SET_R0(___STK(-6))
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_pt_2d_lambda)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(1154),___L_c_23_pt_2d_body)
___DEF_GLBL(___L107_c_23_pt_2d_lambda)
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(0L)))
   ___SET_STK(2,___VECTORREF(___R4,___FIX(1L)))
   ___SET_STK(3,___VECTORREF(___R4,___FIX(2L)))
   ___SET_R4(___VECTORREF(___R4,___FIX(3L)))
   ___SET_STK(2,___CONS(___STK(2),___NUL))
   ___SET_STK(4,___R4)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R0)
   ___SET_STK(7,___R3)
   ___SET_STK(8,___R4)
   ___SET_STK(13,___R4)
   ___SET_STK(14,___R3)
   ___SET_STK(15,___FAL)
   ___SET_STK(16,___FAL)
   ___SET_STK(17,___STK(2))
   ___SET_STK(18,___NUL)
   ___SET_STK(9,___R1)
   ___SET_STK(10,___R2)
   ___SET_R2(___STK(2))
   ___SET_R1(___R3)
   ___SET_R0(___LBL(25))
   ___ADJFP(24)
   ___CHECK_HEAP(29,4096)
___DEF_SLBL(29,___L29_c_23_pt_2d_lambda)
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(31,___L31_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(32))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(32,___L32_c_23_pt_2d_lambda)
   ___SET_STK(-10,___R1)
   ___SET_STK(1,___STK(-4))
   ___SET_STK(2,___STK(-5))
   ___SET_STK(9,___STK(-4))
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R2(___GLO_c_23__2a__2a_eq_3f__2d_sym)
   ___SET_R0(___LBL(33))
   ___ADJFP(12)
   ___JUMPINT(___SET_NARGS(3),___PRC(201),___L_c_23_new_2d_ref_2d_extended_2d_bindings)
___DEF_SLBL(33,___L33_c_23_pt_2d_lambda)
   ___SET_STK(-15,___R1)
   ___SET_R3(___STK(-23))
   ___SET_R2(___STK(-17))
   ___SET_R1(___STK(-16))
   ___SET_R0(___LBL(34))
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(34,___L34_c_23_pt_2d_lambda)
   ___SET_STK(-14,___R1)
   ___SET_R2(___STK(-17))
   ___SET_R1(___STK(-16))
   ___SET_R3(___GLO_c_23_absent_2d_object)
   ___SET_R0(___LBL(35))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_SLBL(35,___L35_c_23_pt_2d_lambda)
   ___BEGIN_ALLOC_LIST(2,___R1)
   ___ADD_LIST_ELEM(1,___STK(-14))
   ___END_ALLOC_LIST(2)
   ___SET_R3(___GET_LIST(2))
   ___SET_R1(___STK(-17))
   ___SET_R0(___LBL(37))
   ___SET_R2(___STK(-15))
   ___ADJFP(-3)
   ___CHECK_HEAP(36,4096)
___DEF_SLBL(36,___L36_c_23_pt_2d_lambda)
   ___JUMPINT(___SET_NARGS(4),___PRC(324),___L_c_23_new_2d_call_2a_)
___DEF_SLBL(37,___L37_c_23_pt_2d_lambda)
   ___SET_STK(-11,___R1)
   ___SET_R3(___STK(-19))
   ___SET_R2(___STK(-13))
   ___SET_R1(___STK(-12))
   ___SET_R0(___LBL(38))
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(38,___L38_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-17))
   ___SET_R0(___LBL(39))
   ___SET_R1(___STK(-11))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(5),___PRC(235),___L_c_23_new_2d_tst)
___DEF_SLBL(39,___L39_c_23_pt_2d_lambda)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R2(___CONS(___STK(-10),___R1))
   ___SET_STK(-11,___R1)
   ___SET_STK(-9,___R2)
   ___SET_R0(___LBL(41))
   ___CHECK_HEAP(40,4096)
___DEF_SLBL(40,___L40_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(41,___L41_c_23_pt_2d_lambda)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_app_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-9))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-7))
   ___ADD_VECTOR_ELEM(6,___STK(-8))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___VECTORSET(___STK(-10),___FIX(1L),___R1)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-11))
   ___SET_R0(___LBL(44))
   ___CHECK_HEAP(42,4096)
___DEF_SLBL(42,___L42_c_23_pt_2d_lambda)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L109_c_23_pt_2d_lambda)
   ___END_IF
   ___GOTO(___L110_c_23_pt_2d_lambda)
___DEF_GLBL(___L108_c_23_pt_2d_lambda)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L110_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L109_c_23_pt_2d_lambda)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___POLL(43)
___DEF_SLBL(43,___L43_c_23_pt_2d_lambda)
   ___GOTO(___L108_c_23_pt_2d_lambda)
___DEF_GLBL(___L110_c_23_pt_2d_lambda)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(44,___L44_c_23_pt_2d_lambda)
   ___SET_R1(___STK(-10))
   ___POLL(45)
___DEF_SLBL(45,___L45_c_23_pt_2d_lambda)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(6))
___DEF_SLBL(46,___L46_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-8))
   ___SET_R2(___STK(-9))
   ___POLL(47)
___DEF_SLBL(47,___L47_c_23_pt_2d_lambda)
   ___ADJFP(-10)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_GLBL(___L111_c_23_pt_2d_lambda)
   ___SET_STK(-7,___R0)
   ___SET_STK(1,___R2)
   ___SET_R2(___STK(0))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(14))
   ___ADJFP(4)
   ___POLL(48)
___DEF_SLBL(48,___L48_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),367,___G_c_23_pair_2d_up)
___DEF_SLBL(49,___L49_c_23_pt_2d_lambda)
   ___SET_R0(___LBL(52))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L112_c_23_pt_2d_lambda)
   ___END_IF
   ___GOTO(___L100_c_23_pt_2d_lambda)
___DEF_SLBL(50,___L50_c_23_pt_2d_lambda)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(9))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L100_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L112_c_23_pt_2d_lambda)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(50))
   ___ADJFP(8)
   ___POLL(51)
___DEF_SLBL(51,___L51_c_23_pt_2d_lambda)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(52,___L52_c_23_pt_2d_lambda)
   ___IF(___NOT(___FALSEP(___STK(-4))))
   ___GOTO(___L131_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_STK(-3,___R1)
   ___SET_R1(___NUL)
   ___GOTO(___L113_c_23_pt_2d_lambda)
___DEF_SLBL(53,___L53_c_23_pt_2d_lambda)
   ___SET_R1(___CONS(___R1,___NUL))
   ___CHECK_HEAP(54,4096)
___DEF_SLBL(54,___L54_c_23_pt_2d_lambda)
___DEF_GLBL(___L113_c_23_pt_2d_lambda)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-5))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L114_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_R1(___NUL)
___DEF_GLBL(___L114_c_23_pt_2d_lambda)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(55))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(55,___L55_c_23_pt_2d_lambda)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___STK(-13))
   ___SET_STK(-4,___STK(-6))
   ___SET_STK(-6,___STK(-12))
   ___SET_STK(-3,___STK(-5))
   ___SET_STK(-5,___STK(-8))
   ___SET_STK(-8,___STK(-4))
   ___SET_STK(-4,___STK(-15))
   ___SET_STK(-15,___STK(-3))
   ___SET_STK(-3,___STK(-10))
   ___SET_STK(-2,___STK(-15))
   ___SET_STK(-1,___STK(-8))
   ___SET_STK(0,___STK(-9))
   ___SET_STK(1,___NUL)
   ___SET_R3(___R1)
   ___SET_R2(___NUL)
   ___SET_R1(___NUL)
   ___SET_R0(___LBL(94))
   ___ADJFP(1)
   ___IF(___NULLP(___STK(-1)))
   ___GOTO(___L116_c_23_pt_2d_lambda)
   ___END_IF
   ___GOTO(___L126_c_23_pt_2d_lambda)
___DEF_SLBL(56,___L56_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___STK(-5))
   ___ADD_VECTOR_ELEM(1,___STK(-3))
   ___ADD_VECTOR_ELEM(2,___STK(-4))
   ___ADD_VECTOR_ELEM(3,___STK(-10))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___SET_R2(___CONS(___R1,___STK(-7)))
   ___SET_R1(___CONS(___GLO_c_23_absent_2d_object,___STK(-8)))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___CHECK_HEAP(57,4096)
___DEF_SLBL(57,___L57_c_23_pt_2d_lambda)
   ___POLL(58)
___DEF_SLBL(58,___L58_c_23_pt_2d_lambda)
___DEF_GLBL(___L115_c_23_pt_2d_lambda)
   ___IF(___NOT(___NULLP(___STK(-1))))
   ___GOTO(___L126_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L116_c_23_pt_2d_lambda)
   ___SET_STK(-1,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(60))
   ___ADJFP(7)
   ___POLL(59)
___DEF_SLBL(59,___L59_c_23_pt_2d_lambda)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(60,___L60_c_23_pt_2d_lambda)
   ___SET_STK(-7,___STK(-8))
   ___SET_STK(-8,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(61))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(61,___L61_c_23_pt_2d_lambda)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(62))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(62,___L62_c_23_pt_2d_lambda)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-4))
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-6))
   ___ADJFP(-8)
   ___POLL(63)
___DEF_SLBL(63,___L63_c_23_pt_2d_lambda)
   ___SET_STK(1,___R1)
   ___SET_R1(___STK(-3))
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L117_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_R1(___NUL)
   ___IF(___FALSEP(___STK(-5)))
   ___GOTO(___L118_c_23_pt_2d_lambda)
   ___END_IF
   ___GOTO(___L125_c_23_pt_2d_lambda)
___DEF_GLBL(___L117_c_23_pt_2d_lambda)
   ___IF(___NOT(___FALSEP(___STK(-5))))
   ___GOTO(___L125_c_23_pt_2d_lambda)
   ___END_IF
___DEF_GLBL(___L118_c_23_pt_2d_lambda)
   ___SET_STK(1,___R1)
   ___SET_R1(___R3)
   ___ADJFP(1)
___DEF_GLBL(___L119_c_23_pt_2d_lambda)
   ___SET_STK(1,___STK(0))
   ___SET_STK(0,___R2)
   ___SET_STK(2,___NUL)
   ___SET_R3(___R1)
   ___SET_R2(___NUL)
   ___SET_R1(___NUL)
   ___ADJFP(2)
   ___POLL(64)
___DEF_SLBL(64,___L64_c_23_pt_2d_lambda)
___DEF_GLBL(___L120_c_23_pt_2d_lambda)
   ___IF(___NOT(___NULLP(___STK(-1))))
   ___GOTO(___L121_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_STK(-1,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(66))
   ___ADJFP(8)
   ___POLL(65)
___DEF_SLBL(65,___L65_c_23_pt_2d_lambda)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(66,___L66_c_23_pt_2d_lambda)
   ___SET_STK(-8,___STK(-9))
   ___SET_STK(-9,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(67))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(67,___L67_c_23_pt_2d_lambda)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_GLBL(___L121_c_23_pt_2d_lambda)
   ___SET_R4(___CAR(___STK(-1)))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(1L)))
   ___SET_R4(___VECTORREF(___R4,___FIX(2L)))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(69))
   ___ADJFP(12)
   ___POLL(68)
___DEF_SLBL(68,___L68_c_23_pt_2d_lambda)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(69,___L69_c_23_pt_2d_lambda)
   ___IF(___NOT(___FALSEP(___STK(-6))))
   ___GOTO(___L124_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_STK(-6,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-11))
   ___SET_R3(___GLO_c_23_false_2d_object)
   ___SET_R0(___LBL(70))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_SLBL(70,___L70_c_23_pt_2d_lambda)
   ___GOTO(___L122_c_23_pt_2d_lambda)
___DEF_SLBL(71,___L71_c_23_pt_2d_lambda)
   ___SET_STK(-6,___STK(-5))
___DEF_GLBL(___L122_c_23_pt_2d_lambda)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(72))
   ___JUMPINT(___SET_NARGS(1),___PRC(64),___L_c_23_cst_3f_)
___DEF_SLBL(72,___L72_c_23_pt_2d_lambda)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L123_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(73))
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(73,___L73_c_23_pt_2d_lambda)
   ___SET_STK(-13,___CDR(___STK(-13)))
   ___SET_STK(-12,___CONS(___STK(-6),___STK(-12)))
   ___SET_STK(-4,___R1)
   ___SET_R2(___CONS(___R1,___NUL))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(75))
   ___CHECK_HEAP(74,4096)
___DEF_SLBL(74,___L74_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(75,___L75_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___BEGIN_ALLOC_VECTOR(4)
   ___ADD_VECTOR_ELEM(0,___STK(-6))
   ___ADD_VECTOR_ELEM(1,___STK(-4))
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___ADD_VECTOR_ELEM(3,___STK(-11))
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___SET_R2(___CONS(___R1,___STK(-8)))
   ___SET_R1(___CONS(___GLO_c_23_absent_2d_object,___STK(-9)))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(76,4096)
___DEF_SLBL(76,___L76_c_23_pt_2d_lambda)
   ___POLL(77)
___DEF_SLBL(77,___L77_c_23_pt_2d_lambda)
   ___GOTO(___L120_c_23_pt_2d_lambda)
___DEF_GLBL(___L123_c_23_pt_2d_lambda)
   ___SET_STK(-13,___CDR(___STK(-13)))
   ___SET_STK(-12,___CONS(___STK(-6),___STK(-12)))
   ___SET_R2(___CONS(___STK(-6),___NUL))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(79))
   ___CHECK_HEAP(78,4096)
___DEF_SLBL(78,___L78_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(79,___L79_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(8L)))
   ___SET_R1(___CONS(___R1,___STK(-9)))
   ___SET_R2(___STK(-8))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(80,4096)
___DEF_SLBL(80,___L80_c_23_pt_2d_lambda)
   ___POLL(81)
___DEF_SLBL(81,___L81_c_23_pt_2d_lambda)
   ___GOTO(___L120_c_23_pt_2d_lambda)
___DEF_GLBL(___L124_c_23_pt_2d_lambda)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-6))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(71))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L125_c_23_pt_2d_lambda)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___STK(-2))
   ___SET_R1(___R3)
   ___SET_R0(___LBL(83))
   ___ADJFP(7)
   ___POLL(82)
___DEF_SLBL(82,___L82_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(83,___L83_c_23_pt_2d_lambda)
   ___SET_R2(___STK(-4))
   ___SET_R0(___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___ADJFP(-6)
   ___GOTO(___L119_c_23_pt_2d_lambda)
___DEF_GLBL(___L126_c_23_pt_2d_lambda)
   ___SET_R4(___CAR(___STK(-1)))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(1L)))
   ___SET_R4(___VECTORREF(___R4,___FIX(2L)))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(85))
   ___ADJFP(11)
   ___POLL(84)
___DEF_SLBL(84,___L84_c_23_pt_2d_lambda)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(85,___L85_c_23_pt_2d_lambda)
   ___IF(___NOT(___FALSEP(___STK(-5))))
   ___GOTO(___L129_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R3(___GLO_c_23_false_2d_object)
   ___SET_R0(___LBL(86))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_SLBL(86,___L86_c_23_pt_2d_lambda)
   ___GOTO(___L127_c_23_pt_2d_lambda)
___DEF_SLBL(87,___L87_c_23_pt_2d_lambda)
   ___SET_STK(-5,___STK(-4))
___DEF_GLBL(___L127_c_23_pt_2d_lambda)
   ___SET_STK(-4,___R1)
   ___SET_R2(___VECTORREF(___STK(-4),___FIX(0L)))
   ___IF(___EQP(___R2,___GLO_c_23_cst_2d_tag))
   ___GOTO(___L128_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(88))
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(88,___L88_c_23_pt_2d_lambda)
   ___SET_STK(-12,___CDR(___STK(-12)))
   ___SET_STK(-11,___CONS(___STK(-5),___STK(-11)))
   ___SET_STK(-3,___R1)
   ___SET_R2(___CONS(___R1,___NUL))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(56))
   ___CHECK_HEAP(89,4096)
___DEF_SLBL(89,___L89_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_GLBL(___L128_c_23_pt_2d_lambda)
   ___SET_STK(-12,___CDR(___STK(-12)))
   ___SET_STK(-11,___CONS(___STK(-5),___STK(-11)))
   ___SET_STK(-10,___R1)
   ___SET_R2(___CONS(___STK(-5),___NUL))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(91))
   ___ADJFP(-4)
   ___CHECK_HEAP(90,4096)
___DEF_SLBL(90,___L90_c_23_pt_2d_lambda)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(91,___L91_c_23_pt_2d_lambda)
   ___SET_R3(___R1)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(8L)))
   ___SET_R1(___CONS(___R1,___STK(-4)))
   ___SET_R2(___STK(-3))
   ___SET_R0(___STK(-5))
   ___ADJFP(-7)
   ___CHECK_HEAP(92,4096)
___DEF_SLBL(92,___L92_c_23_pt_2d_lambda)
   ___POLL(93)
___DEF_SLBL(93,___L93_c_23_pt_2d_lambda)
   ___GOTO(___L115_c_23_pt_2d_lambda)
___DEF_GLBL(___L129_c_23_pt_2d_lambda)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(87))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(94,___L94_c_23_pt_2d_lambda)
   ___IF(___NOT(___EQP(___STK(-3),___SYM_none)))
   ___GOTO(___L130_c_23_pt_2d_lambda)
   ___END_IF
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___STK(-6))
   ___POLL(95)
___DEF_SLBL(95,___L95_c_23_pt_2d_lambda)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L130_c_23_pt_2d_lambda)
   ___POLL(96)
___DEF_SLBL(96,___L96_c_23_pt_2d_lambda)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L131_c_23_pt_2d_lambda)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___STK(-4))
   ___SET_R1(___VECTORREF(___STK(-2),___FIX(1L)))
   ___SET_R0(___LBL(53))
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parameter_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 1077
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_parameter_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_parameter_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_parameter_2d_name)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parameter_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 1079
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_parameter_2d_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_parameter_2d_source)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_parameter_2d_source)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parameter_2d_default_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 1081
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_parameter_2d_default_2d_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_parameter_2d_default_2d_source)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_parameter_2d_default_2d_source)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_extract_2d_parameters
#undef ___PH_LBL0
#define ___PH_LBL0 1083
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L1_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L2_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L3_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L4_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L5_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L6_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L7_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L8_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L9_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L10_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L11_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L12_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L13_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L14_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L15_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L16_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L17_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L18_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L19_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L20_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L21_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L22_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L23_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L24_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L25_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L26_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L27_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L28_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L29_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L30_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L31_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L32_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L33_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L34_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L35_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L36_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L37_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L38_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L39_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L40_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L41_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L42_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L43_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L44_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L45_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L46_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L47_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L48_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L49_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L50_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L51_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L52_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L53_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L54_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L55_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L56_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L57_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L58_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L59_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L60_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L61_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L62_c_23_extract_2d_parameters)
___DEF_P_HLBL(___L63_c_23_extract_2d_parameters)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_extract_2d_parameters)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_extract_2d_parameters)
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___NUL)
   ___SET_STK(4,___FAL)
   ___SET_R3(___FIX(1L))
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_SLBL(2,___L2_c_23_extract_2d_parameters)
   ___IF(___EQP(___STK(-7),___FIX(2L)))
   ___GOTO(___L111_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_STK(-14,___CDR(___STK(-14)))
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___SET_R2(___CONS(___R1,___STK(-8)))
   ___SET_R3(___STK(-7))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_extract_2d_parameters)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_extract_2d_parameters)
___DEF_GLBL(___L64_c_23_extract_2d_parameters)
   ___IF(___NOT(___NULLP(___STK(-2))))
   ___GOTO(___L74_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_STK(-3,___STK(-1))
   ___SET_STK(-2,___STK(0))
   ___SET_STK(-1,___R1)
   ___SET_STK(0,___R3)
   ___SET_R3(___R1)
   ___SET_STK(1,___R2)
   ___SET_R2(___STK(0))
   ___SET_R1(___STK(1))
   ___ADJFP(-1)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_extract_2d_parameters)
___DEF_GLBL(___L65_c_23_extract_2d_parameters)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(7))
   ___ADJFP(9)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_extract_2d_parameters)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(7,___L7_c_23_extract_2d_parameters)
   ___SET_STK(-11,___R1)
   ___SET_R1(___STK(-10))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L66_c_23_extract_2d_parameters)
   ___END_IF
   ___GOTO(___L73_c_23_extract_2d_parameters)
___DEF_SLBL(8,___L8_c_23_extract_2d_parameters)
___DEF_GLBL(___L66_c_23_extract_2d_parameters)
   ___SET_STK(-10,___R1)
   ___SET_R1(___STK(-9))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L70_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(-7))))
   ___GOTO(___L71_c_23_extract_2d_parameters)
   ___END_IF
___DEF_GLBL(___L67_c_23_extract_2d_parameters)
   ___SET_R2(___FAL)
___DEF_GLBL(___L68_c_23_extract_2d_parameters)
   ___BEGIN_ALLOC_VECTOR(5)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-10))
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___ADD_VECTOR_ELEM(3,___R1)
   ___ADD_VECTOR_ELEM(4,___R2)
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_extract_2d_parameters)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_extract_2d_parameters)
___DEF_GLBL(___L69_c_23_extract_2d_parameters)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___DEF_GLBL(___L70_c_23_extract_2d_parameters)
   ___SET_R1(___BOOLEAN(___FIXEQ(___STK(-6),___FIX(4L))))
   ___IF(___FALSEP(___STK(-7)))
   ___GOTO(___L67_c_23_extract_2d_parameters)
   ___END_IF
___DEF_GLBL(___L71_c_23_extract_2d_parameters)
   ___IF(___NOT(___NULLP(___STK(-7))))
   ___GOTO(___L72_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___FALSEP(___STK(-5)))
   ___GOTO(___L67_c_23_extract_2d_parameters)
   ___END_IF
___DEF_GLBL(___L72_c_23_extract_2d_parameters)
   ___SET_STK(-9,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(11,___L11_c_23_extract_2d_parameters)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-9))
   ___GOTO(___L68_c_23_extract_2d_parameters)
___DEF_GLBL(___L73_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(8))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_GLBL(___L74_c_23_extract_2d_parameters)
   ___IF(___NOT(___PAIRP(___STK(-2))))
   ___GOTO(___L110_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R4(___CAR(___STK(-2)))
   ___SET_STK(1,___R4)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(13))
   ___ADJFP(12)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_extract_2d_parameters)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(13,___L13_c_23_extract_2d_parameters)
   ___SET_STK(-11,___R1)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),366,___G_c_23_optional_2d_object_3f_)
___DEF_SLBL(14,___L14_c_23_extract_2d_parameters)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L77_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___NOT(___FIXEQ(___STK(-7),___FIX(1L))))
   ___GOTO(___L76_c_23_extract_2d_parameters)
   ___END_IF
   ___ADJFP(-4)
   ___GOTO(___L75_c_23_extract_2d_parameters)
___DEF_SLBL(15,___L15_c_23_extract_2d_parameters)
___DEF_GLBL(___L75_c_23_extract_2d_parameters)
   ___SET_STK(-10,___CDR(___STK(-10)))
   ___SET_STK(-8,___NUL)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R3(___FIX(2L))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_GLBL(___L76_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(39))
   ___SET_R0(___LBL(15))
   ___ADJFP(-4)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L77_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),384,___G_c_23_rest_2d_object_3f_)
___DEF_SLBL(17,___L17_c_23_extract_2d_parameters)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L97_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___FALSEP(___STK(-9)))
   ___GOTO(___L78_c_23_extract_2d_parameters)
   ___END_IF
   ___GOTO(___L96_c_23_extract_2d_parameters)
___DEF_SLBL(18,___L18_c_23_extract_2d_parameters)
___DEF_GLBL(___L78_c_23_extract_2d_parameters)
   ___SET_R1(___CDR(___STK(-14)))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L80_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(40))
   ___SET_R0(___STK(-10))
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_extract_2d_parameters)
___DEF_GLBL(___L79_c_23_extract_2d_parameters)
   ___ADJFP(-16)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L80_c_23_extract_2d_parameters)
   ___SET_R1(___CADR(___STK(-14)))
   ___SET_STK(-11,___R1)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(20,___L20_c_23_extract_2d_parameters)
   ___SET_STK(-11,___R1)
   ___SET_R2(___STK(-15))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_SLBL(21,___L21_c_23_extract_2d_parameters)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L81_c_23_extract_2d_parameters)
   ___END_IF
   ___GOTO(___L93_c_23_extract_2d_parameters)
___DEF_SLBL(22,___L22_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L82_c_23_extract_2d_parameters)
   ___END_IF
___DEF_GLBL(___L81_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(41))
   ___SET_R0(___STK(-10))
   ___POLL(23)
___DEF_SLBL(23,___L23_c_23_extract_2d_parameters)
   ___GOTO(___L79_c_23_extract_2d_parameters)
___DEF_GLBL(___L82_c_23_extract_2d_parameters)
   ___SET_STK(1,___STK(-13))
   ___SET_STK(2,___STK(-12))
   ___SET_STK(3,___STK(-9))
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(2))
   ___ADJFP(3)
   ___GOTO(___L84_c_23_extract_2d_parameters)
___DEF_SLBL(24,___L24_c_23_extract_2d_parameters)
___DEF_GLBL(___L83_c_23_extract_2d_parameters)
   ___SET_STK(1,___STK(-9))
   ___SET_STK(2,___STK(-8))
   ___SET_STK(3,___STK(-5))
   ___SET_R3(___STK(-10))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(34))
   ___ADJFP(3)
___DEF_GLBL(___L84_c_23_extract_2d_parameters)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___STK(-2))
   ___SET_R1(___STK(3))
   ___SET_R0(___LBL(27))
   ___ADJFP(9)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_extract_2d_parameters)
___DEF_GLBL(___L85_c_23_extract_2d_parameters)
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___ADJFP(1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L88_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___NULLP(___R2))
   ___GOTO(___L87_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___CAR(___R2))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___IF(___EQP(___STK(0),___R1))
   ___GOTO(___L86_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_extract_2d_parameters)
   ___GOTO(___L85_c_23_extract_2d_parameters)
___DEF_GLBL(___L86_c_23_extract_2d_parameters)
   ___SET_R1(___TRU)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L87_c_23_extract_2d_parameters)
   ___SET_R1(___FAL)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L88_c_23_extract_2d_parameters)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(27,___L27_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L90_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R2(___STK(-10))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(28))
   ___GOTO(___L85_c_23_extract_2d_parameters)
___DEF_SLBL(28,___L28_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L90_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___FALSEP(___STK(-9)))
   ___GOTO(___L89_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(-9),___FIX(0L)))
   ___IF(___EQP(___STK(-6),___R1))
   ___GOTO(___L90_c_23_extract_2d_parameters)
   ___END_IF
___DEF_GLBL(___L89_c_23_extract_2d_parameters)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(29))
   ___GOTO(___L85_c_23_extract_2d_parameters)
___DEF_SLBL(29,___L29_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L90_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___VOID)
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23_extract_2d_parameters)
   ___GOTO(___L69_c_23_extract_2d_parameters)
___DEF_GLBL(___L90_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(42))
   ___SET_R0(___STK(-8))
   ___POLL(31)
___DEF_SLBL(31,___L31_c_23_extract_2d_parameters)
   ___GOTO(___L91_c_23_extract_2d_parameters)
___DEF_SLBL(32,___L32_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L92_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___STK(-10))
   ___SET_R2(___SUB(41))
   ___SET_R0(___STK(-6))
   ___POLL(33)
___DEF_SLBL(33,___L33_c_23_extract_2d_parameters)
___DEF_GLBL(___L91_c_23_extract_2d_parameters)
   ___ADJFP(-12)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L92_c_23_extract_2d_parameters)
   ___IF(___FALSEP(___STK(-5)))
   ___GOTO(___L83_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_STK(-11,___STK(-10))
   ___SET_R1(___STK(-11))
   ___SET_R2(___SUB(43))
   ___SET_R0(___LBL(24))
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_SLBL(34,___L34_c_23_extract_2d_parameters)
   ___SET_STK(-11,___STK(-9))
   ___SET_STK(-9,___STK(-10))
   ___SET_STK(-10,___STK(-8))
   ___SET_STK(-8,___STK(-9))
   ___SET_STK(-9,___STK(-5))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___STK(-7))
   ___ADD_VECTOR_ELEM(1,___STK(-8))
   ___END_ALLOC_VECTOR(2)
   ___SET_R3(___GET_VECTOR(2))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-6))
   ___ADJFP(-9)
   ___CHECK_HEAP(35,4096)
___DEF_SLBL(35,___L35_c_23_extract_2d_parameters)
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_extract_2d_parameters)
   ___GOTO(___L65_c_23_extract_2d_parameters)
___DEF_GLBL(___L93_c_23_extract_2d_parameters)
   ___SET_STK(1,___STK(-13))
   ___SET_STK(2,___STK(-12))
   ___SET_STK(3,___STK(-9))
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(37))
   ___ADJFP(3)
   ___GOTO(___L84_c_23_extract_2d_parameters)
___DEF_SLBL(37,___L37_c_23_extract_2d_parameters)
   ___IF(___NOT(___FIXEQ(___STK(-7),___FIX(4L))))
   ___GOTO(___L95_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___CDDR(___STK(-14)))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L94_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_STK(-15,___STK(-13))
   ___SET_STK(-14,___STK(-12))
   ___SET_STK(-13,___STK(-9))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___END_ALLOC_VECTOR(2)
   ___SET_R3(___GET_VECTOR(2))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-10))
   ___ADJFP(-13)
   ___CHECK_HEAP(38,4096)
___DEF_SLBL(38,___L38_c_23_extract_2d_parameters)
   ___POLL(39)
___DEF_SLBL(39,___L39_c_23_extract_2d_parameters)
   ___GOTO(___L65_c_23_extract_2d_parameters)
___DEF_GLBL(___L94_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(44))
   ___SET_R0(___STK(-10))
   ___POLL(40)
___DEF_SLBL(40,___L40_c_23_extract_2d_parameters)
   ___GOTO(___L79_c_23_extract_2d_parameters)
___DEF_GLBL(___L95_c_23_extract_2d_parameters)
   ___SET_STK(-14,___CDDR(___STK(-14)))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___SET_R2(___STK(-8))
   ___SET_R3(___FIX(3L))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(41,4096)
___DEF_SLBL(41,___L41_c_23_extract_2d_parameters)
   ___POLL(42)
___DEF_SLBL(42,___L42_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_GLBL(___L96_c_23_extract_2d_parameters)
   ___SET_STK(-11,___STK(-6))
   ___SET_R1(___STK(-11))
   ___SET_R2(___SUB(43))
   ___SET_R0(___LBL(18))
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L97_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(43))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),350,___G_c_23_key_2d_object_3f_)
___DEF_SLBL(43,___L43_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L107_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___NOT(___FIXEQ(___STK(-7),___FIX(3L))))
   ___GOTO(___L98_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(45))
   ___SET_R0(___STK(-10))
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_extract_2d_parameters)
   ___GOTO(___L79_c_23_extract_2d_parameters)
___DEF_GLBL(___L98_c_23_extract_2d_parameters)
   ___SET_R2(___STK(-15))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(45))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_SLBL(45,___L45_c_23_extract_2d_parameters)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L104_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___NOT(___PAIRP(___STK(-11))))
   ___GOTO(___L103_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___FIXEQ(___STK(-7),___FIX(2L)))
   ___GOTO(___L99_c_23_extract_2d_parameters)
   ___END_IF
   ___IF(___FIXEQ(___STK(-7),___FIX(4L)))
   ___GOTO(___L99_c_23_extract_2d_parameters)
   ___END_IF
   ___GOTO(___L102_c_23_extract_2d_parameters)
___DEF_SLBL(46,___L46_c_23_extract_2d_parameters)
___DEF_GLBL(___L99_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(47))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(47,___L47_c_23_extract_2d_parameters)
   ___IF(___NOT(___EQP(___R1,___FIX(2L))))
   ___GOTO(___L101_c_23_extract_2d_parameters)
   ___END_IF
   ___ADJFP(-4)
   ___GOTO(___L100_c_23_extract_2d_parameters)
___DEF_SLBL(48,___L48_c_23_extract_2d_parameters)
___DEF_GLBL(___L100_c_23_extract_2d_parameters)
   ___SET_R1(___CAR(___STK(-7)))
   ___SET_R2(___CADR(___STK(-7)))
   ___SET_STK(-7,___R1)
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R2)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(49))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(49,___L49_c_23_extract_2d_parameters)
   ___SET_STK(-11,___R1)
   ___SET_R2(___STK(-15))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(22))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_GLBL(___L101_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(46))
   ___SET_R0(___LBL(48))
   ___ADJFP(-4)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L102_c_23_extract_2d_parameters)
   ___SET_STK(-5,___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(47))
   ___SET_R0(___LBL(46))
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L103_c_23_extract_2d_parameters)
   ___IF(___FIXEQ(___STK(-7),___FIX(1L)))
   ___GOTO(___L81_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(48))
   ___SET_R0(___STK(-10))
   ___POLL(50)
___DEF_SLBL(50,___L50_c_23_extract_2d_parameters)
   ___GOTO(___L79_c_23_extract_2d_parameters)
___DEF_GLBL(___L104_c_23_extract_2d_parameters)
   ___SET_STK(1,___STK(-13))
   ___SET_STK(2,___STK(-12))
   ___SET_STK(3,___STK(-9))
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(51))
   ___ADJFP(3)
   ___GOTO(___L84_c_23_extract_2d_parameters)
___DEF_SLBL(51,___L51_c_23_extract_2d_parameters)
   ___IF(___NOT(___EQP(___STK(-7),___FIX(1L))))
   ___GOTO(___L105_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_STK(-14,___CDR(___STK(-14)))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___SET_STK(-13,___CONS(___R1,___STK(-13)))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(52,4096)
___DEF_SLBL(52,___L52_c_23_extract_2d_parameters)
   ___POLL(53)
___DEF_SLBL(53,___L53_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_GLBL(___L105_c_23_extract_2d_parameters)
   ___IF(___NOT(___EQP(___STK(-7),___FIX(2L))))
   ___GOTO(___L106_c_23_extract_2d_parameters)
   ___END_IF
   ___SET_STK(-14,___CDR(___STK(-14)))
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___FAL)
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___SET_STK(-12,___CONS(___R1,___STK(-12)))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(54,4096)
___DEF_SLBL(54,___L54_c_23_extract_2d_parameters)
   ___POLL(55)
___DEF_SLBL(55,___L55_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_GLBL(___L106_c_23_extract_2d_parameters)
   ___SET_STK(-14,___CDR(___STK(-14)))
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___FAL)
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___SET_R2(___CONS(___R1,___STK(-8)))
   ___SET_R3(___STK(-7))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(56,4096)
___DEF_SLBL(56,___L56_c_23_extract_2d_parameters)
   ___POLL(57)
___DEF_SLBL(57,___L57_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_GLBL(___L107_c_23_extract_2d_parameters)
   ___IF(___FIXEQ(___STK(-7),___FIX(4L)))
   ___GOTO(___L109_c_23_extract_2d_parameters)
   ___END_IF
   ___ADJFP(-4)
   ___GOTO(___L108_c_23_extract_2d_parameters)
___DEF_SLBL(58,___L58_c_23_extract_2d_parameters)
___DEF_GLBL(___L108_c_23_extract_2d_parameters)
   ___SET_STK(-10,___CDR(___STK(-10)))
   ___SET_R1(___STK(-5))
   ___SET_R3(___FIX(4L))
   ___SET_R2(___NUL)
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(59)
___DEF_SLBL(59,___L59_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___DEF_GLBL(___L109_c_23_extract_2d_parameters)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(49))
   ___SET_R0(___LBL(58))
   ___ADJFP(-4)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L110_c_23_extract_2d_parameters)
   ___SET_STK(1,___STK(-2))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(61))
   ___ADJFP(8)
   ___POLL(60)
___DEF_SLBL(60,___L60_c_23_extract_2d_parameters)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(61,___L61_c_23_extract_2d_parameters)
   ___SET_STK(-7,___R1)
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(32))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_GLBL(___L111_c_23_extract_2d_parameters)
   ___SET_STK(-14,___CDR(___STK(-14)))
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___STK(-11))
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___STK(-5))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___SET_STK(-12,___CONS(___R1,___STK(-12)))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-12)
   ___CHECK_HEAP(62,4096)
___DEF_SLBL(62,___L62_c_23_extract_2d_parameters)
   ___POLL(63)
___DEF_SLBL(63,___L63_c_23_extract_2d_parameters)
   ___GOTO(___L64_c_23_extract_2d_parameters)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_source_2d__3e_parms
#undef ___PH_LBL0
#define ___PH_LBL0 1148
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_source_2d__3e_parms)
___DEF_P_HLBL(___L1_c_23_source_2d__3e_parms)
___DEF_P_HLBL(___L2_c_23_source_2d__3e_parms)
___DEF_P_HLBL(___L3_c_23_source_2d__3e_parms)
___DEF_P_HLBL(___L4_c_23_source_2d__3e_parms)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_source_2d__3e_parms)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_source_2d__3e_parms)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_source_2d__3e_parms)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_source_2d__3e_parms)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L5_c_23_source_2d__3e_parms)
   ___END_IF
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L7_c_23_source_2d__3e_parms)
   ___END_IF
___DEF_GLBL(___L5_c_23_source_2d__3e_parms)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_source_2d__3e_parms)
___DEF_GLBL(___L6_c_23_source_2d__3e_parms)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L7_c_23_source_2d__3e_parms)
   ___SET_R1(___STK(-5))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_source_2d__3e_parms)
   ___GOTO(___L6_c_23_source_2d__3e_parms)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_body
#undef ___PH_LBL0
#define ___PH_LBL0 1154
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_body)
___DEF_P_HLBL(___L1_c_23_pt_2d_body)
___DEF_P_HLBL(___L2_c_23_pt_2d_body)
___DEF_P_HLBL(___L3_c_23_pt_2d_body)
___DEF_P_HLBL(___L4_c_23_pt_2d_body)
___DEF_P_HLBL(___L5_c_23_pt_2d_body)
___DEF_P_HLBL(___L6_c_23_pt_2d_body)
___DEF_P_HLBL(___L7_c_23_pt_2d_body)
___DEF_P_HLBL(___L8_c_23_pt_2d_body)
___DEF_P_HLBL(___L9_c_23_pt_2d_body)
___DEF_P_HLBL(___L10_c_23_pt_2d_body)
___DEF_P_HLBL(___L11_c_23_pt_2d_body)
___DEF_P_HLBL(___L12_c_23_pt_2d_body)
___DEF_P_HLBL(___L13_c_23_pt_2d_body)
___DEF_P_HLBL(___L14_c_23_pt_2d_body)
___DEF_P_HLBL(___L15_c_23_pt_2d_body)
___DEF_P_HLBL(___L16_c_23_pt_2d_body)
___DEF_P_HLBL(___L17_c_23_pt_2d_body)
___DEF_P_HLBL(___L18_c_23_pt_2d_body)
___DEF_P_HLBL(___L19_c_23_pt_2d_body)
___DEF_P_HLBL(___L20_c_23_pt_2d_body)
___DEF_P_HLBL(___L21_c_23_pt_2d_body)
___DEF_P_HLBL(___L22_c_23_pt_2d_body)
___DEF_P_HLBL(___L23_c_23_pt_2d_body)
___DEF_P_HLBL(___L24_c_23_pt_2d_body)
___DEF_P_HLBL(___L25_c_23_pt_2d_body)
___DEF_P_HLBL(___L26_c_23_pt_2d_body)
___DEF_P_HLBL(___L27_c_23_pt_2d_body)
___DEF_P_HLBL(___L28_c_23_pt_2d_body)
___DEF_P_HLBL(___L29_c_23_pt_2d_body)
___DEF_P_HLBL(___L30_c_23_pt_2d_body)
___DEF_P_HLBL(___L31_c_23_pt_2d_body)
___DEF_P_HLBL(___L32_c_23_pt_2d_body)
___DEF_P_HLBL(___L33_c_23_pt_2d_body)
___DEF_P_HLBL(___L34_c_23_pt_2d_body)
___DEF_P_HLBL(___L35_c_23_pt_2d_body)
___DEF_P_HLBL(___L36_c_23_pt_2d_body)
___DEF_P_HLBL(___L37_c_23_pt_2d_body)
___DEF_P_HLBL(___L38_c_23_pt_2d_body)
___DEF_P_HLBL(___L39_c_23_pt_2d_body)
___DEF_P_HLBL(___L40_c_23_pt_2d_body)
___DEF_P_HLBL(___L41_c_23_pt_2d_body)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_body)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_pt_2d_body)
   ___SET_STK(1,___R3)
   ___SET_STK(2,___NUL)
   ___SET_STK(3,___NUL)
   ___SET_STK(4,___R0)
   ___SET_STK(5,___R1)
   ___SET_R1(___R2)
   ___SET_R2(___NUL)
   ___SET_R0(___LBL(2))
   ___ADJFP(11)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_body)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(2,___L2_c_23_pt_2d_body)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___NUL)
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_body)
   ___GOTO(___L43_c_23_pt_2d_body)
___DEF_SLBL(4,___L4_c_23_pt_2d_body)
   ___SET_R1(___STK(-3))
___DEF_GLBL(___L42_c_23_pt_2d_body)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_pt_2d_body)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_body)
___DEF_GLBL(___L43_c_23_pt_2d_body)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L44_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R2(___SUB(50))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_body)
   ___ADJFP(-4)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L44_c_23_pt_2d_body)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R3)
   ___SET_R1(___CAR(___STK(3)))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt_2d_body)
   ___JUMPINT(___SET_NARGS(2),___PRC(1705),___L_c_23_macro_2d_expr_3f_)
___DEF_SLBL(9,___L9_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L56_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_begin_2d_sym)
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(10,___L10_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L55_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-2L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_sym)
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(11,___L11_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L54_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_macro_2d_sym)
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(12,___L12_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L53_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___R1)
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_syntax_2d_sym)
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(13,___L13_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L53_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(1),___PRC(1733),___L_c_23__2a__2a_include_2d_expr_3f_)
___DEF_SLBL(14,___L14_c_23_pt_2d_body)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L47_c_23_pt_2d_body)
   ___END_IF
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L45_c_23_pt_2d_body)
   ___END_IF
   ___GOTO(___L46_c_23_pt_2d_body)
___DEF_SLBL(15,___L15_c_23_pt_2d_body)
___DEF_GLBL(___L45_c_23_pt_2d_body)
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),344,___G_c_23_include_2d_expr_2d__3e_source)
___DEF_SLBL(16,___L16_c_23_pt_2d_body)
   ___IF(___FALSEP(___GLO_c_23__2a_ptree_2d_port_2a_))
   ___GOTO(___L42_c_23_pt_2d_body)
   ___END_IF
   ___SET_STK(-3,___R1)
   ___SET_R1(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_newline)
___DEF_GLBL(___L46_c_23_pt_2d_body)
   ___SET_R2(___GLO_c_23__2a_ptree_2d_port_2a_)
   ___SET_R1(___SUB(51))
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_GLBL(___L47_c_23_pt_2d_body)
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_declare_2d_sym)
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(17,___L17_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L52_c_23_pt_2d_body)
   ___END_IF
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_namespace_2d_sym)
   ___SET_R0(___LBL(18))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(18,___L18_c_23_pt_2d_body)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L51_c_23_pt_2d_body)
   ___END_IF
   ___IF(___NOT(___NULLP(___STK(-9))))
   ___GOTO(___L48_c_23_pt_2d_body)
   ___END_IF
   ___SET_R3(___STK(-10))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_pt_2d_body)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_GLBL(___L48_c_23_pt_2d_body)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(20))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(20,___L20_c_23_pt_2d_body)
   ___SET_STK(-9,___STK(-5))
   ___SET_STK(-5,___STK(-8))
   ___SET_STK(-8,___STK(-4))
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___R1)
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-5))
   ___SET_R1(___NUL)
   ___SET_R0(___STK(-4))
   ___ADJFP(-7)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_pt_2d_body)
   ___GOTO(___L49_c_23_pt_2d_body)
___DEF_SLBL(22,___L22_c_23_pt_2d_body)
   ___SET_R1(___CONS(___R1,___STK(-5)))
   ___SET_R3(___CDR(___STK(-3)))
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___CHECK_HEAP(23,4096)
___DEF_SLBL(23,___L23_c_23_pt_2d_body)
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_pt_2d_body)
___DEF_GLBL(___L49_c_23_pt_2d_body)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L50_c_23_pt_2d_body)
   ___END_IF
   ___SET_STK(1,___STK(-3))
   ___SET_STK(-3,___STK(0))
   ___SET_STK(0,___STK(-2))
   ___SET_STK(-2,___R1)
   ___SET_R3(___STK(1))
   ___SET_R2(___STK(-1))
   ___SET_R1(___STK(0))
   ___ADJFP(1)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_pt_2d_body)
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(6),___PRC(1403),___L_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L50_c_23_pt_2d_body)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___CAR(___R3))
   ___SET_R1(___CAR(___STK(3)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(22))
   ___ADJFP(7)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_pt_2d_body)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L51_c_23_pt_2d_body)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(1963),___L_c_23_add_2d_namespace)
___DEF_SLBL(27,___L27_c_23_pt_2d_body)
   ___SET_R3(___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_pt_2d_body)
   ___GOTO(___L43_c_23_pt_2d_body)
___DEF_GLBL(___L52_c_23_pt_2d_body)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(1954),___L_c_23_add_2d_declarations)
___DEF_GLBL(___L53_c_23_pt_2d_body)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(1987),___L_c_23_add_2d_macro)
___DEF_GLBL(___L54_c_23_pt_2d_body)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(29))
   ___JUMPINT(___SET_NARGS(2),___PRC(1775),___L_c_23_definition_2d_name)
___DEF_SLBL(29,___L29_c_23_pt_2d_body)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(30))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(30,___L30_c_23_pt_2d_body)
   ___SET_R3(___STK(-6))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(31))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),327,___G_c_23_env_2d_define_2d_var)
___DEF_SLBL(31,___L31_c_23_pt_2d_body)
   ___SET_STK(-9,___CONS(___R1,___STK(-9)))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(33))
   ___CHECK_HEAP(32,4096)
___DEF_SLBL(32,___L32_c_23_pt_2d_body)
   ___JUMPINT(___SET_NARGS(1),___PRC(1787),___L_c_23_definition_2d_value)
___DEF_SLBL(33,___L33_c_23_pt_2d_body)
   ___SET_STK(-8,___CONS(___R1,___STK(-8)))
   ___SET_R1(___CONS(___STK(-4),___STK(-6)))
   ___SET_R3(___STK(-4))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(34,4096)
___DEF_SLBL(34,___L34_c_23_pt_2d_body)
   ___POLL(35)
___DEF_SLBL(35,___L35_c_23_pt_2d_body)
   ___GOTO(___L43_c_23_pt_2d_body)
___DEF_GLBL(___L55_c_23_pt_2d_body)
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(36))
   ___JUMPINT(___SET_NARGS(1),___PRC(1892),___L_c_23_begin_2d_body)
___DEF_SLBL(36,___L36_c_23_pt_2d_body)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R0(___LBL(37))
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(37,___L37_c_23_pt_2d_body)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_pt_2d_body)
   ___GOTO(___L43_c_23_pt_2d_body)
___DEF_GLBL(___L56_c_23_pt_2d_body)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(39))
   ___JUMPINT(___SET_NARGS(2),___PRC(823),___L_c_23_macro_2d_expand)
___DEF_SLBL(39,___L39_c_23_pt_2d_body)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(40,4096)
___DEF_SLBL(40,___L40_c_23_pt_2d_body)
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23_pt_2d_body)
   ___GOTO(___L43_c_23_pt_2d_body)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_sequence
#undef ___PH_LBL0
#define ___PH_LBL0 1197
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_sequence)
___DEF_P_HLBL(___L1_c_23_pt_2d_sequence)
___DEF_P_HLBL(___L2_c_23_pt_2d_sequence)
___DEF_P_HLBL(___L3_c_23_pt_2d_sequence)
___DEF_P_HLBL(___L4_c_23_pt_2d_sequence)
___DEF_P_HLBL(___L5_c_23_pt_2d_sequence)
___DEF_P_HLBL(___L6_c_23_pt_2d_sequence)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_sequence)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23_pt_2d_sequence)
   ___GOTO(___L7_c_23_pt_2d_sequence)
___DEF_SLBL(1,___L1_c_23_pt_2d_sequence)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-7))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___LBL(5))
   ___ADJFP(5)
___DEF_GLBL(___L7_c_23_pt_2d_sequence)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(3))
   ___ADJFP(7)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_pt_2d_sequence)
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(3,___L3_c_23_pt_2d_sequence)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L8_c_23_pt_2d_sequence)
   ___END_IF
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___STK(-6))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_pt_2d_sequence)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L8_c_23_pt_2d_sequence)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R3(___SYM_none)
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(5,___L5_c_23_pt_2d_sequence)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-10))
   ___SET_R2(___STK(-6))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_sequence)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(377),___L_c_23_new_2d_seq)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_if
#undef ___PH_LBL0
#define ___PH_LBL0 1205
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_if)
___DEF_P_HLBL(___L1_c_23_pt_2d_if)
___DEF_P_HLBL(___L2_c_23_pt_2d_if)
___DEF_P_HLBL(___L3_c_23_pt_2d_if)
___DEF_P_HLBL(___L4_c_23_pt_2d_if)
___DEF_P_HLBL(___L5_c_23_pt_2d_if)
___DEF_P_HLBL(___L6_c_23_pt_2d_if)
___DEF_P_HLBL(___L7_c_23_pt_2d_if)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_if)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_if)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_if)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_if)
   ___SET_STK(-7,___STK(-5))
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-4))
   ___SET_STK(-1,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CADR(___R1))
   ___SET_R3(___SYM_pred)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(3,___L3_c_23_pt_2d_if)
   ___SET_STK(-4,___R1)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-8))
   ___SET_R1(___CADDR(___STK(-5)))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(4,___L4_c_23_pt_2d_if)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(3L))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(5,___L5_c_23_pt_2d_if)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L8_c_23_pt_2d_if)
   ___END_IF
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-8))
   ___SET_R1(___CADDDR(___STK(-5)))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(6,___L6_c_23_pt_2d_if)
   ___SET_R3(___R1)
   ___SET_R0(___STK(-6))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_if)
   ___ADJFP(-10)
   ___JUMPINT(___SET_NARGS(5),___PRC(235),___L_c_23_new_2d_tst)
___DEF_GLBL(___L8_c_23_pt_2d_if)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_cond
#undef ___PH_LBL0
#define ___PH_LBL0 1214
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_cond)
___DEF_P_HLBL(___L1_c_23_pt_2d_cond)
___DEF_P_HLBL(___L2_c_23_pt_2d_cond)
___DEF_P_HLBL(___L3_c_23_pt_2d_cond)
___DEF_P_HLBL(___L4_c_23_pt_2d_cond)
___DEF_P_HLBL(___L5_c_23_pt_2d_cond)
___DEF_P_HLBL(___L6_c_23_pt_2d_cond)
___DEF_P_HLBL(___L7_c_23_pt_2d_cond)
___DEF_P_HLBL(___L8_c_23_pt_2d_cond)
___DEF_P_HLBL(___L9_c_23_pt_2d_cond)
___DEF_P_HLBL(___L10_c_23_pt_2d_cond)
___DEF_P_HLBL(___L11_c_23_pt_2d_cond)
___DEF_P_HLBL(___L12_c_23_pt_2d_cond)
___DEF_P_HLBL(___L13_c_23_pt_2d_cond)
___DEF_P_HLBL(___L14_c_23_pt_2d_cond)
___DEF_P_HLBL(___L15_c_23_pt_2d_cond)
___DEF_P_HLBL(___L16_c_23_pt_2d_cond)
___DEF_P_HLBL(___L17_c_23_pt_2d_cond)
___DEF_P_HLBL(___L18_c_23_pt_2d_cond)
___DEF_P_HLBL(___L19_c_23_pt_2d_cond)
___DEF_P_HLBL(___L20_c_23_pt_2d_cond)
___DEF_P_HLBL(___L21_c_23_pt_2d_cond)
___DEF_P_HLBL(___L22_c_23_pt_2d_cond)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_cond)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_cond)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_cond)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_cond)
   ___SET_R3(___CDR(___R1))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_cond)
   ___GOTO(___L23_c_23_pt_2d_cond)
___DEF_SLBL(4,___L4_c_23_pt_2d_cond)
   ___SET_STK(-6,___R1)
   ___SET_STK(1,___STK(-4))
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(21))
   ___ADJFP(1)
___DEF_GLBL(___L23_c_23_pt_2d_cond)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(6))
   ___ADJFP(7)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_cond)
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(6,___L6_c_23_pt_2d_cond)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L24_c_23_pt_2d_cond)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-7))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_cond)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L24_c_23_pt_2d_cond)
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R1)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(8))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(8,___L8_c_23_pt_2d_cond)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-6,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(9,___L9_c_23_pt_2d_cond)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23_else_2d_sym)))
   ___GOTO(___L25_c_23_pt_2d_cond)
   ___END_IF
   ___SET_STK(-11,___STK(-5))
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-9))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-10))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_pt_2d_cond)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_GLBL(___L25_c_23_pt_2d_cond)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(11,___L11_c_23_pt_2d_cond)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L28_c_23_pt_2d_cond)
   ___END_IF
   ___SET_STK(-4,___STK(-11))
   ___SET_STK(-11,___STK(-5))
   ___IF(___NOT(___EQP(___STK(-8),___SYM_true)))
   ___GOTO(___L26_c_23_pt_2d_cond)
   ___END_IF
   ___SET_R3(___SYM_true)
   ___GOTO(___L27_c_23_pt_2d_cond)
___DEF_GLBL(___L26_c_23_pt_2d_cond)
   ___SET_R3(___SYM_pred)
___DEF_GLBL(___L27_c_23_pt_2d_cond)
   ___SET_R2(___STK(-9))
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(12,___L12_c_23_pt_2d_cond)
   ___SET_STK(-6,___R1)
   ___SET_STK(1,___STK(-4))
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(13))
   ___ADJFP(1)
   ___GOTO(___L23_c_23_pt_2d_cond)
___DEF_SLBL(13,___L13_c_23_pt_2d_cond)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___SET_R2(___STK(-6))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_pt_2d_cond)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(279),___L_c_23_new_2d_disj)
___DEF_GLBL(___L28_c_23_pt_2d_cond)
   ___SET_R1(___CADR(___STK(-6)))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(15,___L15_c_23_pt_2d_cond)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23__3d__3e__2d_sym)))
   ___GOTO(___L29_c_23_pt_2d_cond)
   ___END_IF
   ___SET_STK(-4,___STK(-11))
   ___SET_STK(-11,___STK(-5))
   ___SET_STK(-5,___STK(-10))
   ___SET_STK(-10,___STK(-9))
   ___SET_R2(___STK(-9))
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(16,___L16_c_23_pt_2d_cond)
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-9))
   ___SET_R1(___CADDR(___STK(-6)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L29_c_23_pt_2d_cond)
   ___SET_STK(-4,___STK(-11))
   ___SET_STK(-11,___STK(-5))
   ___SET_STK(-3,___STK(-10))
   ___SET_STK(-10,___STK(-9))
   ___SET_R2(___STK(-9))
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_R3(___SYM_pred)
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(17,___L17_c_23_pt_2d_cond)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-5))
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-9))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(18))
   ___ADJFP(5)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_SLBL(18,___L18_c_23_pt_2d_cond)
   ___SET_STK(-10,___R1)
   ___SET_STK(1,___STK(-8))
   ___SET_R3(___CDR(___STK(-11)))
   ___SET_R2(___STK(-12))
   ___SET_R1(___STK(-13))
   ___SET_R0(___LBL(19))
   ___ADJFP(1)
   ___GOTO(___L23_c_23_pt_2d_cond)
___DEF_SLBL(19,___L19_c_23_pt_2d_cond)
   ___SET_R3(___R1)
   ___SET_R0(___STK(-7))
   ___SET_R2(___STK(-10))
   ___SET_R1(___STK(-6))
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_pt_2d_cond)
   ___ADJFP(-14)
   ___JUMPINT(___SET_NARGS(5),___PRC(235),___L_c_23_new_2d_tst)
___DEF_SLBL(21,___L21_c_23_pt_2d_cond)
   ___SET_R3(___R1)
   ___SET_R0(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-3))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_pt_2d_cond)
   ___ADJFP(-10)
   ___JUMPINT(___SET_NARGS(5),___PRC(359),___L_c_23_new_2d_disj_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_and
#undef ___PH_LBL0
#define ___PH_LBL0 1238
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_and)
___DEF_P_HLBL(___L1_c_23_pt_2d_and)
___DEF_P_HLBL(___L2_c_23_pt_2d_and)
___DEF_P_HLBL(___L3_c_23_pt_2d_and)
___DEF_P_HLBL(___L4_c_23_pt_2d_and)
___DEF_P_HLBL(___L5_c_23_pt_2d_and)
___DEF_P_HLBL(___L6_c_23_pt_2d_and)
___DEF_P_HLBL(___L7_c_23_pt_2d_and)
___DEF_P_HLBL(___L8_c_23_pt_2d_and)
___DEF_P_HLBL(___L9_c_23_pt_2d_and)
___DEF_P_HLBL(___L10_c_23_pt_2d_and)
___DEF_P_HLBL(___L11_c_23_pt_2d_and)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_and)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_and)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_and)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_and)
   ___SET_R3(___CDR(___R1))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_and)
   ___GOTO(___L12_c_23_pt_2d_and)
___DEF_SLBL(4,___L4_c_23_pt_2d_and)
   ___SET_STK(-5,___R1)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(10))
   ___ADJFP(1)
___DEF_GLBL(___L12_c_23_pt_2d_and)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(6))
   ___ADJFP(7)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_and)
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(6,___L6_c_23_pt_2d_and)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L13_c_23_pt_2d_and)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-7))
   ___SET_R3(___TRU)
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_and)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L13_c_23_pt_2d_and)
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(8,___L8_c_23_pt_2d_and)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L16_c_23_pt_2d_and)
   ___END_IF
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-7,___R1)
   ___IF(___NOT(___EQP(___STK(-4),___SYM_true)))
   ___GOTO(___L14_c_23_pt_2d_and)
   ___END_IF
   ___SET_R3(___SYM_true)
   ___GOTO(___L15_c_23_pt_2d_and)
___DEF_GLBL(___L14_c_23_pt_2d_and)
   ___SET_R3(___SYM_pred)
___DEF_GLBL(___L15_c_23_pt_2d_and)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L16_c_23_pt_2d_and)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_pt_2d_and)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(10,___L10_c_23_pt_2d_and)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___SET_R2(___STK(-5))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_and)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(260),___L_c_23_new_2d_conj)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_or
#undef ___PH_LBL0
#define ___PH_LBL0 1251
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_or)
___DEF_P_HLBL(___L1_c_23_pt_2d_or)
___DEF_P_HLBL(___L2_c_23_pt_2d_or)
___DEF_P_HLBL(___L3_c_23_pt_2d_or)
___DEF_P_HLBL(___L4_c_23_pt_2d_or)
___DEF_P_HLBL(___L5_c_23_pt_2d_or)
___DEF_P_HLBL(___L6_c_23_pt_2d_or)
___DEF_P_HLBL(___L7_c_23_pt_2d_or)
___DEF_P_HLBL(___L8_c_23_pt_2d_or)
___DEF_P_HLBL(___L9_c_23_pt_2d_or)
___DEF_P_HLBL(___L10_c_23_pt_2d_or)
___DEF_P_HLBL(___L11_c_23_pt_2d_or)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_or)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_or)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_or)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_or)
   ___SET_R3(___CDR(___R1))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_or)
   ___GOTO(___L12_c_23_pt_2d_or)
___DEF_SLBL(4,___L4_c_23_pt_2d_or)
   ___SET_STK(-5,___R1)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(10))
   ___ADJFP(1)
___DEF_GLBL(___L12_c_23_pt_2d_or)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(6))
   ___ADJFP(7)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_or)
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(6,___L6_c_23_pt_2d_or)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L13_c_23_pt_2d_or)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-7))
   ___SET_R3(___GLO_c_23_false_2d_object)
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_or)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L13_c_23_pt_2d_or)
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(8,___L8_c_23_pt_2d_or)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L16_c_23_pt_2d_or)
   ___END_IF
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-7,___R1)
   ___IF(___NOT(___EQP(___STK(-4),___SYM_true)))
   ___GOTO(___L14_c_23_pt_2d_or)
   ___END_IF
   ___SET_R3(___SYM_true)
   ___GOTO(___L15_c_23_pt_2d_or)
___DEF_GLBL(___L14_c_23_pt_2d_or)
   ___SET_R3(___SYM_pred)
___DEF_GLBL(___L15_c_23_pt_2d_or)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L16_c_23_pt_2d_or)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___CAR(___STK(-3)))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_pt_2d_or)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(10,___L10_c_23_pt_2d_or)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___SET_R2(___STK(-5))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_or)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(279),___L_c_23_new_2d_disj)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_case
#undef ___PH_LBL0
#define ___PH_LBL0 1264
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_case)
___DEF_P_HLBL(___L1_c_23_pt_2d_case)
___DEF_P_HLBL(___L2_c_23_pt_2d_case)
___DEF_P_HLBL(___L3_c_23_pt_2d_case)
___DEF_P_HLBL(___L4_c_23_pt_2d_case)
___DEF_P_HLBL(___L5_c_23_pt_2d_case)
___DEF_P_HLBL(___L6_c_23_pt_2d_case)
___DEF_P_HLBL(___L7_c_23_pt_2d_case)
___DEF_P_HLBL(___L8_c_23_pt_2d_case)
___DEF_P_HLBL(___L9_c_23_pt_2d_case)
___DEF_P_HLBL(___L10_c_23_pt_2d_case)
___DEF_P_HLBL(___L11_c_23_pt_2d_case)
___DEF_P_HLBL(___L12_c_23_pt_2d_case)
___DEF_P_HLBL(___L13_c_23_pt_2d_case)
___DEF_P_HLBL(___L14_c_23_pt_2d_case)
___DEF_P_HLBL(___L15_c_23_pt_2d_case)
___DEF_P_HLBL(___L16_c_23_pt_2d_case)
___DEF_P_HLBL(___L17_c_23_pt_2d_case)
___DEF_P_HLBL(___L18_c_23_pt_2d_case)
___DEF_P_HLBL(___L19_c_23_pt_2d_case)
___DEF_P_HLBL(___L20_c_23_pt_2d_case)
___DEF_P_HLBL(___L21_c_23_pt_2d_case)
___DEF_P_HLBL(___L22_c_23_pt_2d_case)
___DEF_P_HLBL(___L23_c_23_pt_2d_case)
___DEF_P_HLBL(___L24_c_23_pt_2d_case)
___DEF_P_HLBL(___L25_c_23_pt_2d_case)
___DEF_P_HLBL(___L26_c_23_pt_2d_case)
___DEF_P_HLBL(___L27_c_23_pt_2d_case)
___DEF_P_HLBL(___L28_c_23_pt_2d_case)
___DEF_P_HLBL(___L29_c_23_pt_2d_case)
___DEF_P_HLBL(___L30_c_23_pt_2d_case)
___DEF_P_HLBL(___L31_c_23_pt_2d_case)
___DEF_P_HLBL(___L32_c_23_pt_2d_case)
___DEF_P_HLBL(___L33_c_23_pt_2d_case)
___DEF_P_HLBL(___L34_c_23_pt_2d_case)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_case)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_case)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_case)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_case)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SYM_case_2d_temp)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(392),___L_c_23_new_2d_temp_2d_variable)
___DEF_SLBL(3,___L3_c_23_pt_2d_case)
   ___SET_STK(-2,___STK(-5))
   ___SET_STK(-1,___STK(-4))
   ___SET_STK(5,___STK(-5))
   ___SET_STK(6,___STK(-4))
   ___SET_STK(7,___FAL)
   ___SET_STK(8,___FAL)
   ___SET_STK(9,___CONS(___R1,___NUL))
   ___SET_STK(10,___NUL)
   ___SET_STK(17,___STK(-5))
   ___SET_STK(18,___STK(-4))
   ___SET_R3(___CDDR(___STK(-7)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(30))
   ___ADJFP(18)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_pt_2d_case)
   ___GOTO(___L35_c_23_pt_2d_case)
___DEF_SLBL(5,___L5_c_23_pt_2d_case)
   ___SET_STK(-9,___R1)
   ___SET_STK(1,___STK(-7))
   ___SET_STK(2,___STK(-14))
   ___SET_R3(___CDR(___STK(-10)))
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-12))
   ___SET_R0(___LBL(28))
   ___ADJFP(2)
___DEF_GLBL(___L35_c_23_pt_2d_case)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(7))
   ___ADJFP(10)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_case)
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(7,___L7_c_23_pt_2d_case)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L36_c_23_pt_2d_case)
   ___END_IF
   ___SET_R2(___STK(-10))
   ___SET_R1(___STK(-11))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___STK(-9))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt_2d_case)
   ___ADJFP(-12)
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_GLBL(___L36_c_23_pt_2d_case)
   ___SET_R1(___CAR(___STK(-6)))
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(9,___L9_c_23_pt_2d_case)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-5,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(10,___L10_c_23_pt_2d_case)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23_else_2d_sym)))
   ___GOTO(___L37_c_23_pt_2d_case)
   ___END_IF
   ___SET_STK(-11,___STK(-4))
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-10))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___STK(-9))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_case)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_GLBL(___L37_c_23_pt_2d_case)
   ___SET_STK(-3,___STK(-11))
   ___SET_STK(-11,___STK(-4))
   ___SET_STK(1,___STK(-10))
   ___SET_STK(2,___STK(-7))
   ___SET_R1(___CAR(___STK(-5)))
   ___SET_R0(___LBL(12))
   ___ADJFP(8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___DEF_SLBL(12,___L12_c_23_pt_2d_case)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-13))
   ___SET_R1(___STK(-12))
   ___SET_R0(___LBL(27))
   ___ADJFP(-6)
   ___GOTO(___L38_c_23_pt_2d_case)
___DEF_SLBL(13,___L13_c_23_pt_2d_case)
   ___SET_R2(___CDR(___STK(-4)))
   ___IF(___NULLP(___R2))
   ___GOTO(___L39_c_23_pt_2d_case)
   ___END_IF
   ___SET_STK(-9,___STK(-11))
   ___SET_STK(-11,___STK(-6))
   ___SET_STK(-8,___R1)
   ___SET_STK(-3,___STK(-9))
   ___SET_STK(-2,___STK(-10))
   ___SET_R3(___CDR(___STK(-4)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
   ___ADJFP(-2)
___DEF_GLBL(___L38_c_23_pt_2d_case)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___STK(-1))
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___SET_STK(5,___R2)
   ___SET_STK(6,___R3)
   ___SET_R1(___STK(2))
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_safe_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(16))
   ___ADJFP(10)
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_pt_2d_case)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_pt_2d_case)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(16,___L16_c_23_pt_2d_case)
   ___SET_STK(-8,___STK(-6))
   ___SET_STK(-3,___GLO_c_23__2a__2a_eqv_3f__2d_sym)
   ___SET_STK(-2,___STK(-11))
   ___SET_STK(-1,___R1)
   ___SET_STK(0,___STK(-2))
   ___SET_R1(___STK(0))
   ___BEGIN_ALLOC_LIST(2,___TRU)
   ___ADD_LIST_ELEM(1,___GLO_c_23_extended_2d_bindings_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(18))
   ___ADJFP(4)
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_c_23_pt_2d_case)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(18,___L18_c_23_pt_2d_case)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),330,___G_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_SLBL(19,___L19_c_23_pt_2d_case)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-12))
   ___SET_R0(___LBL(20))
   ___SET_R2(___STK(-4))
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(20,___L20_c_23_pt_2d_case)
   ___SET_STK(-12,___R1)
   ___SET_R3(___STK(-14))
   ___SET_R2(___STK(-15))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(21,___L21_c_23_pt_2d_case)
   ___SET_STK(-7,___R1)
   ___SET_R3(___CAR(___STK(-8)))
   ___SET_R2(___STK(-15))
   ___SET_R1(___CAR(___STK(-9)))
   ___SET_R0(___LBL(22))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_SLBL(22,___L22_c_23_pt_2d_case)
   ___BEGIN_ALLOC_LIST(2,___R1)
   ___ADD_LIST_ELEM(1,___STK(-7))
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_STK(-3,___STK(-13))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-12))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(13))
   ___ADJFP(-3)
   ___CHECK_HEAP(23,4096)
___DEF_SLBL(23,___L23_c_23_pt_2d_case)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_GLBL(___L39_c_23_pt_2d_case)
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_pt_2d_case)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___DEF_SLBL(25,___L25_c_23_pt_2d_case)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-3))
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_pt_2d_case)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(279),___L_c_23_new_2d_disj)
___DEF_SLBL(27,___L27_c_23_pt_2d_case)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-4))
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-10))
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___LBL(5))
   ___ADJFP(5)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_SLBL(28,___L28_c_23_pt_2d_case)
   ___SET_R3(___R1)
   ___SET_R0(___STK(-13))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-6))
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23_pt_2d_case)
   ___ADJFP(-14)
   ___JUMPINT(___SET_NARGS(5),___PRC(235),___L_c_23_new_2d_tst)
___DEF_SLBL(30,___L30_c_23_pt_2d_case)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(31))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(31,___L31_c_23_pt_2d_case)
   ___SET_STK(-9,___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___CADR(___STK(-11)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(32))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(32,___L32_c_23_pt_2d_case)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_STK(-11,___STK(-6))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-10))
   ___CHECK_HEAP(33,4096)
___DEF_SLBL(33,___L33_c_23_pt_2d_case)
   ___POLL(34)
___DEF_SLBL(34,___L34_c_23_pt_2d_case)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_let
#undef ___PH_LBL0
#define ___PH_LBL0 1300
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_let)
___DEF_P_HLBL(___L1_c_23_pt_2d_let)
___DEF_P_HLBL(___L2_c_23_pt_2d_let)
___DEF_P_HLBL(___L3_c_23_pt_2d_let)
___DEF_P_HLBL(___L4_c_23_pt_2d_let)
___DEF_P_HLBL(___L5_c_23_pt_2d_let)
___DEF_P_HLBL(___L6_c_23_pt_2d_let)
___DEF_P_HLBL(___L7_c_23_pt_2d_let)
___DEF_P_HLBL(___L8_c_23_pt_2d_let)
___DEF_P_HLBL(___L9_c_23_pt_2d_let)
___DEF_P_HLBL(___L10_c_23_pt_2d_let)
___DEF_P_HLBL(___L11_c_23_pt_2d_let)
___DEF_P_HLBL(___L12_c_23_pt_2d_let)
___DEF_P_HLBL(___L13_c_23_pt_2d_let)
___DEF_P_HLBL(___L14_c_23_pt_2d_let)
___DEF_P_HLBL(___L15_c_23_pt_2d_let)
___DEF_P_HLBL(___L16_c_23_pt_2d_let)
___DEF_P_HLBL(___L17_c_23_pt_2d_let)
___DEF_P_HLBL(___L18_c_23_pt_2d_let)
___DEF_P_HLBL(___L19_c_23_pt_2d_let)
___DEF_P_HLBL(___L20_c_23_pt_2d_let)
___DEF_P_HLBL(___L21_c_23_pt_2d_let)
___DEF_P_HLBL(___L22_c_23_pt_2d_let)
___DEF_P_HLBL(___L23_c_23_pt_2d_let)
___DEF_P_HLBL(___L24_c_23_pt_2d_let)
___DEF_P_HLBL(___L25_c_23_pt_2d_let)
___DEF_P_HLBL(___L26_c_23_pt_2d_let)
___DEF_P_HLBL(___L27_c_23_pt_2d_let)
___DEF_P_HLBL(___L28_c_23_pt_2d_let)
___DEF_P_HLBL(___L29_c_23_pt_2d_let)
___DEF_P_HLBL(___L30_c_23_pt_2d_let)
___DEF_P_HLBL(___L31_c_23_pt_2d_let)
___DEF_P_HLBL(___L32_c_23_pt_2d_let)
___DEF_P_HLBL(___L33_c_23_pt_2d_let)
___DEF_P_HLBL(___L34_c_23_pt_2d_let)
___DEF_P_HLBL(___L35_c_23_pt_2d_let)
___DEF_P_HLBL(___L36_c_23_pt_2d_let)
___DEF_P_HLBL(___L37_c_23_pt_2d_let)
___DEF_P_HLBL(___L38_c_23_pt_2d_let)
___DEF_P_HLBL(___L39_c_23_pt_2d_let)
___DEF_P_HLBL(___L40_c_23_pt_2d_let)
___DEF_P_HLBL(___L41_c_23_pt_2d_let)
___DEF_P_HLBL(___L42_c_23_pt_2d_let)
___DEF_P_HLBL(___L43_c_23_pt_2d_let)
___DEF_P_HLBL(___L44_c_23_pt_2d_let)
___DEF_P_HLBL(___L45_c_23_pt_2d_let)
___DEF_P_HLBL(___L46_c_23_pt_2d_let)
___DEF_P_HLBL(___L47_c_23_pt_2d_let)
___DEF_P_HLBL(___L48_c_23_pt_2d_let)
___DEF_P_HLBL(___L49_c_23_pt_2d_let)
___DEF_P_HLBL(___L50_c_23_pt_2d_let)
___DEF_P_HLBL(___L51_c_23_pt_2d_let)
___DEF_P_HLBL(___L52_c_23_pt_2d_let)
___DEF_P_HLBL(___L53_c_23_pt_2d_let)
___DEF_P_HLBL(___L54_c_23_pt_2d_let)
___DEF_P_HLBL(___L55_c_23_pt_2d_let)
___DEF_P_HLBL(___L56_c_23_pt_2d_let)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_let)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_let)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_let)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_let)
   ___SET_STK(-7,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CADR(___R1))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_SLBL(3,___L3_c_23_pt_2d_let)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L67_c_23_pt_2d_let)
   ___END_IF
   ___SET_R1(___CADR(___STK(-7)))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23_pt_2d_let)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L57_c_23_pt_2d_let)
   ___END_IF
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-7,___STK(-5))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CDDR(___STK(-2)))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_let)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(1154),___L_c_23_pt_2d_body)
___DEF_GLBL(___L57_c_23_pt_2d_let)
   ___SET_R1(___CADR(___STK(-7)))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(6,___L6_c_23_pt_2d_let)
   ___SET_R0(___LBL(9))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L58_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_SLBL(7,___L7_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(14))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L58_c_23_pt_2d_let)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt_2d_let)
___DEF_GLBL(___L59_c_23_pt_2d_let)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(9,___L9_c_23_pt_2d_let)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(11))
   ___ADJFP(4)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L60_c_23_pt_2d_let)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(29))
   ___ADJFP(8)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_pt_2d_let)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L60_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L61_c_23_pt_2d_let)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(11,___L11_c_23_pt_2d_let)
   ___SET_R0(___LBL(20))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L62_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_SLBL(12,___L12_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(14))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L62_c_23_pt_2d_let)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(12))
   ___ADJFP(8)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_pt_2d_let)
___DEF_GLBL(___L63_c_23_pt_2d_let)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(14,___L14_c_23_pt_2d_let)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15_c_23_pt_2d_let)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_pt_2d_let)
   ___GOTO(___L64_c_23_pt_2d_let)
___DEF_SLBL(17,___L17_c_23_pt_2d_let)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(18,4096)
___DEF_SLBL(18,___L18_c_23_pt_2d_let)
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_pt_2d_let)
___DEF_GLBL(___L64_c_23_pt_2d_let)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(20,___L20_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(23))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L65_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_SLBL(21,___L21_c_23_pt_2d_let)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L65_c_23_pt_2d_let)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___CADR(___R3))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(21))
   ___ADJFP(8)
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_pt_2d_let)
___DEF_GLBL(___L66_c_23_pt_2d_let)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(23,___L23_c_23_pt_2d_let)
   ___SET_STK(-6,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(24,___L24_c_23_pt_2d_let)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(25,___L25_c_23_pt_2d_let)
   ___SET_STK(-3,___STK(-9))
   ___SET_STK(-2,___STK(-8))
   ___SET_STK(5,___STK(-9))
   ___SET_STK(6,___STK(-8))
   ___SET_STK(7,___FAL)
   ___SET_STK(8,___FAL)
   ___SET_STK(9,___STK(-5))
   ___SET_STK(10,___NUL)
   ___SET_STK(17,___STK(-9))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-4))
   ___SET_R1(___CDDR(___STK(-11)))
   ___SET_R0(___LBL(26))
   ___ADJFP(17)
   ___JUMPINT(___SET_NARGS(4),___PRC(1154),___L_c_23_pt_2d_body)
___DEF_SLBL(26,___L26_c_23_pt_2d_let)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(27))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(27,___L27_c_23_pt_2d_let)
   ___SET_STK(-15,___STK(-7))
   ___SET_R3(___STK(-10))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-14))
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_pt_2d_let)
   ___ADJFP(-15)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_SLBL(29,___L29_c_23_pt_2d_let)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(30,4096)
___DEF_SLBL(30,___L30_c_23_pt_2d_let)
   ___POLL(31)
___DEF_SLBL(31,___L31_c_23_pt_2d_let)
   ___GOTO(___L64_c_23_pt_2d_let)
___DEF_GLBL(___L67_c_23_pt_2d_let)
   ___SET_R1(___CADR(___STK(-7)))
   ___SET_R0(___LBL(32))
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(32,___L32_c_23_pt_2d_let)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R2(___CADDR(___STK(-7)))
   ___SET_STK(-2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(34))
   ___ADJFP(4)
   ___CHECK_HEAP(33,4096)
___DEF_SLBL(33,___L33_c_23_pt_2d_let)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(34,___L34_c_23_pt_2d_let)
   ___SET_R0(___LBL(37))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L68_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_SLBL(35,___L35_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(14))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L68_c_23_pt_2d_let)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(35))
   ___ADJFP(8)
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_pt_2d_let)
   ___GOTO(___L59_c_23_pt_2d_let)
___DEF_SLBL(37,___L37_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(39))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L70_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_GLBL(___L69_c_23_pt_2d_let)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L70_c_23_pt_2d_let)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(29))
   ___ADJFP(8)
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_pt_2d_let)
   ___GOTO(___L69_c_23_pt_2d_let)
___DEF_SLBL(39,___L39_c_23_pt_2d_let)
   ___SET_R0(___LBL(42))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L71_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_SLBL(40,___L40_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(14))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L71_c_23_pt_2d_let)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(40))
   ___ADJFP(8)
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23_pt_2d_let)
   ___GOTO(___L63_c_23_pt_2d_let)
___DEF_SLBL(42,___L42_c_23_pt_2d_let)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(45))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L72_c_23_pt_2d_let)
   ___END_IF
   ___GOTO(___L61_c_23_pt_2d_let)
___DEF_SLBL(43,___L43_c_23_pt_2d_let)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L61_c_23_pt_2d_let)
   ___END_IF
___DEF_GLBL(___L72_c_23_pt_2d_let)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___CADR(___R3))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(43))
   ___ADJFP(8)
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_pt_2d_let)
   ___GOTO(___L66_c_23_pt_2d_let)
___DEF_SLBL(45,___L45_c_23_pt_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(46))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(46,___L46_c_23_pt_2d_let)
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(47))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(47,___L47_c_23_pt_2d_let)
   ___SET_STK(1,___STK(-9))
   ___SET_STK(2,___STK(-3))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___STK(-4))
   ___SET_STK(6,___NUL)
   ___SET_STK(13,___STK(-9))
   ___SET_R3(___STK(-7))
   ___SET_R2(___R1)
   ___SET_R1(___CDDDR(___STK(-11)))
   ___SET_R0(___LBL(48))
   ___ADJFP(13)
   ___JUMPINT(___SET_NARGS(4),___PRC(1154),___L_c_23_pt_2d_body)
___DEF_SLBL(48,___L48_c_23_pt_2d_let)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(49))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(49,___L49_c_23_pt_2d_let)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_STK(-11,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(51))
   ___CHECK_HEAP(50,4096)
___DEF_SLBL(50,___L50_c_23_pt_2d_let)
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(51,___L51_c_23_pt_2d_let)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(52))
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(52,___L52_c_23_pt_2d_let)
   ___SET_STK(-7,___STK(-9))
   ___SET_STK(-4,___STK(-8))
   ___SET_STK(1,___STK(-9))
   ___SET_STK(2,___STK(-8))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___STK(-6))
   ___SET_STK(6,___NUL)
   ___SET_STK(-8,___STK(-9))
   ___SET_STK(-2,___STK(-3))
   ___SET_R3(___CAR(___STK(-6)))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(53))
   ___ADJFP(12)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(53,___L53_c_23_pt_2d_let)
   ___SET_STK(1,___STK(-20))
   ___SET_R3(___STK(-17))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-14))
   ___SET_R0(___LBL(54))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_SLBL(54,___L54_c_23_pt_2d_let)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(55))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(55,___L55_c_23_pt_2d_let)
   ___SET_STK(-9,___STK(-11))
   ___SET_STK(-11,___STK(-7))
   ___SET_R3(___STK(-9))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-10))
   ___POLL(56)
___DEF_SLBL(56,___L56_c_23_pt_2d_let)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_let_2a_
#undef ___PH_LBL0
#define ___PH_LBL0 1358
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L1_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L2_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L3_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L4_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L5_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L6_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L7_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L8_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L9_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L10_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L11_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L12_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L13_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L14_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L15_c_23_pt_2d_let_2a_)
___DEF_P_HLBL(___L16_c_23_pt_2d_let_2a_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_let_2a_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_let_2a_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_let_2a_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_let_2a_)
   ___SET_STK(-7,___STK(-5))
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-6,___R1)
   ___SET_R1(___CADR(___R1))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_pt_2d_let_2a_)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_pt_2d_let_2a_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L17_c_23_pt_2d_let_2a_)
   ___END_IF
   ___GOTO(___L18_c_23_pt_2d_let_2a_)
___DEF_SLBL(5,___L5_c_23_pt_2d_let_2a_)
   ___SET_STK(-5,___STK(-8))
   ___SET_STK(-4,___STK(-10))
   ___SET_STK(1,___STK(-8))
   ___SET_STK(2,___STK(-10))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___STK(-7))
   ___SET_STK(6,___NUL)
   ___SET_STK(13,___STK(-15))
   ___SET_STK(14,___STK(-14))
   ___SET_R3(___STK(-9))
   ___SET_R2(___STK(-6))
   ___SET_R1(___CDR(___STK(-11)))
   ___SET_R0(___LBL(14))
   ___ADJFP(14)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L18_c_23_pt_2d_let_2a_)
   ___END_IF
___DEF_GLBL(___L17_c_23_pt_2d_let_2a_)
   ___SET_R1(___CDDR(___STK(0)))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_let_2a_)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(4),___PRC(1154),___L_c_23_pt_2d_body)
___DEF_GLBL(___L18_c_23_pt_2d_let_2a_)
   ___SET_R4(___CAR(___R1))
   ___SET_STK(1,___R4)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(8))
   ___ADJFP(10)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_let_2a_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(8,___L8_c_23_pt_2d_let_2a_)
   ___SET_STK(-9,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(9,___L9_c_23_pt_2d_let_2a_)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___CADR(___STK(-9)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(11))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_pt_2d_let_2a_)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(11,___L11_c_23_pt_2d_let_2a_)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_STK(-9,___R1)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___CHECK_HEAP(12,4096)
___DEF_SLBL(12,___L12_c_23_pt_2d_let_2a_)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(13,___L13_c_23_pt_2d_let_2a_)
   ___SET_STK(-2,___R1)
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(14,___L14_c_23_pt_2d_let_2a_)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(15))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(15,___L15_c_23_pt_2d_let_2a_)
   ___SET_STK(-15,___STK(-5))
   ___SET_R3(___STK(-13))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-12))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_pt_2d_let_2a_)
   ___ADJFP(-15)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_letrec
#undef ___PH_LBL0
#define ___PH_LBL0 1376
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L1_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L2_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L3_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L4_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L5_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L6_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L7_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L8_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L9_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L10_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L11_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L12_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L13_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L14_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L15_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L16_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L17_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L18_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L19_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L20_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L21_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L22_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L23_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L24_c_23_pt_2d_letrec)
___DEF_P_HLBL(___L25_c_23_pt_2d_letrec)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_letrec)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_letrec)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_letrec)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_letrec)
   ___SET_R2(___CADR(___R1))
   ___SET_STK(-7,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_pt_2d_letrec)
   ___SET_R0(___LBL(6))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L26_c_23_pt_2d_letrec)
   ___END_IF
   ___GOTO(___L28_c_23_pt_2d_letrec)
___DEF_SLBL(4,___L4_c_23_pt_2d_letrec)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(11))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L28_c_23_pt_2d_letrec)
   ___END_IF
___DEF_GLBL(___L26_c_23_pt_2d_letrec)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_letrec)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(6,___L6_c_23_pt_2d_letrec)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(8))
   ___ADJFP(4)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L28_c_23_pt_2d_letrec)
   ___END_IF
___DEF_GLBL(___L27_c_23_pt_2d_letrec)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(23))
   ___ADJFP(8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_pt_2d_letrec)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L27_c_23_pt_2d_letrec)
   ___END_IF
___DEF_GLBL(___L28_c_23_pt_2d_letrec)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(8,___L8_c_23_pt_2d_letrec)
   ___SET_R0(___LBL(17))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L29_c_23_pt_2d_letrec)
   ___END_IF
   ___GOTO(___L28_c_23_pt_2d_letrec)
___DEF_SLBL(9,___L9_c_23_pt_2d_letrec)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(11))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L28_c_23_pt_2d_letrec)
   ___END_IF
___DEF_GLBL(___L29_c_23_pt_2d_letrec)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_pt_2d_letrec)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(11,___L11_c_23_pt_2d_letrec)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(12,4096)
___DEF_SLBL(12,___L12_c_23_pt_2d_letrec)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_pt_2d_letrec)
   ___GOTO(___L30_c_23_pt_2d_letrec)
___DEF_SLBL(14,___L14_c_23_pt_2d_letrec)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15_c_23_pt_2d_letrec)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_pt_2d_letrec)
___DEF_GLBL(___L30_c_23_pt_2d_letrec)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(17,___L17_c_23_pt_2d_letrec)
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(18,___L18_c_23_pt_2d_letrec)
   ___SET_STK(-8,___STK(-11))
   ___SET_STK(-11,___STK(-9))
   ___SET_STK(-9,___STK(-10))
   ___SET_STK(-10,___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(21))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L31_c_23_pt_2d_letrec)
   ___END_IF
   ___GOTO(___L28_c_23_pt_2d_letrec)
___DEF_SLBL(19,___L19_c_23_pt_2d_letrec)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L28_c_23_pt_2d_letrec)
   ___END_IF
___DEF_GLBL(___L31_c_23_pt_2d_letrec)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___CADR(___R3))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(19))
   ___ADJFP(8)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_pt_2d_letrec)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(21,___L21_c_23_pt_2d_letrec)
   ___SET_STK(-6,___STK(-9))
   ___SET_STK(-9,___R1)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-5))
   ___SET_R1(___CDDR(___STK(-8)))
   ___SET_R0(___STK(-6))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_pt_2d_letrec)
   ___ADJFP(-9)
   ___JUMPINT(___SET_NARGS(6),___PRC(1403),___L_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(23,___L23_c_23_pt_2d_letrec)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(24,4096)
___DEF_SLBL(24,___L24_c_23_pt_2d_letrec)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_pt_2d_letrec)
   ___GOTO(___L30_c_23_pt_2d_letrec)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_recursive_2d_let
#undef ___PH_LBL0
#define ___PH_LBL0 1403
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L1_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L2_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L3_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L4_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L5_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L6_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L7_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L8_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L9_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L10_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L11_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L12_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L13_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L14_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L15_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L16_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L17_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L18_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L19_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L20_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L21_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L22_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L23_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L24_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L25_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L26_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L27_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L28_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L29_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L30_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L31_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L32_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L33_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L34_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L35_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L36_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L37_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L38_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L39_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L40_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L41_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L42_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L43_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L44_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L45_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L46_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L47_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L48_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L49_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L50_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L51_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L52_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L53_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L54_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L55_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L56_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L57_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L58_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L59_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L60_c_23_pt_2d_recursive_2d_let)
___DEF_P_HLBL(___L61_c_23_pt_2d_recursive_2d_let)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_recursive_2d_let)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___STK(0))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(2))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_recursive_2d_let)
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(2,___L2_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-4,___STK(-8))
   ___SET_STK(-8,___STK(-7))
   ___SET_STK(-7,___STK(-10))
   ___SET_STK(-3,___STK(-9))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),354,___G_c_23_list_2d__3e_varset)
___DEF_SLBL(3,___L3_c_23_pt_2d_recursive_2d_let)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-7))
   ___SET_R0(___LBL(31))
   ___IF(___NULLP(___R2))
   ___GOTO(___L63_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___GOTO(___L62_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(4,___L4_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-7,___R1)
   ___SET_R3(___CDR(___STK(-3)))
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(28))
   ___IF(___NULLP(___R2))
   ___GOTO(___L63_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L62_c_23_pt_2d_recursive_2d_let)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___CAR(___R2))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_recursive_2d_let)
   ___JUMPINT(___SET_NARGS(1),___PRC(445),___L_c_23_bound_2d_free_2d_variables)
___DEF_SLBL(6,___L6_c_23_pt_2d_recursive_2d_let)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),407,___G_c_23_varset_2d_intersection)
___DEF_SLBL(7,___L7_c_23_pt_2d_recursive_2d_let)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),357,___G_c_23_make_2d_gnode)
___DEF_SLBL(8,___L8_c_23_pt_2d_recursive_2d_let)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_cst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-8))
   ___ADD_VECTOR_ELEM(6,___STK(-9))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-11))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___SET_STK(-11,___R1)
   ___SET_R3(___CDR(___STK(-5)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(14))
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_pt_2d_recursive_2d_let)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L64_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L63_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(10,___L10_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-12,___R1)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-15))
   ___SET_R0(___LBL(21))
   ___ADJFP(-4)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L63_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L64_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(1,___GLO_c_23_void_2d_object)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R0(___LBL(12))
   ___ADJFP(8)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_recursive_2d_let)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(12,___L12_c_23_pt_2d_recursive_2d_let)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_cst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-4))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-7))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___SET_R2(___CDR(___STK(-3)))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_pt_2d_recursive_2d_let)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L68_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___SET_STK(-7,___R1)
   ___SET_R1(___NUL)
   ___GOTO(___L66_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(14,___L14_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___CONS(___STK(-11),___R1))
   ___SET_STK(-11,___STK(-6))
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L65_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___CONS(___STK(-11),___R1))
   ___SET_STK(-11,___STK(-7))
   ___ADJFP(-4)
   ___CHECK_HEAP(16,4096)
___DEF_SLBL(16,___L16_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L66_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___CONS(___STK(-7),___R1))
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_c_23_pt_2d_recursive_2d_let)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L67_c_23_pt_2d_recursive_2d_let)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L68_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-7,___GLO_c_23_void_2d_object)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___R2)
   ___SET_R0(___LBL(19))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(19,___L19_c_23_pt_2d_recursive_2d_let)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_cst_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-8))
   ___ADD_VECTOR_ELEM(6,___STK(-9))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___ADD_VECTOR_ELEM(8,___STK(-11))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___SET_R2(___CDR(___STK(-6)))
   ___CHECK_HEAP(20,4096)
___DEF_SLBL(20,___L20_c_23_pt_2d_recursive_2d_let)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L69_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___SET_STK(-11,___R1)
   ___SET_R1(___NUL)
   ___GOTO(___L65_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L69_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-11,___GLO_c_23_void_2d_object)
   ___SET_STK(-6,___R1)
   ___SET_STK(-5,___R2)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(21,___L21_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(1,___STK(-10))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(22))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_SLBL(22,___L22_c_23_pt_2d_recursive_2d_let)
   ___POLL(23)
___DEF_SLBL(23,___L23_c_23_pt_2d_recursive_2d_let)
   ___GOTO(___L71_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(24,___L24_c_23_pt_2d_recursive_2d_let)
   ___IF(___NOT(___NULLP(___STK(-5))))
   ___GOTO(___L72_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L70_c_23_pt_2d_recursive_2d_let)
   ___ADJFP(-4)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L71_c_23_pt_2d_recursive_2d_let)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(8))
___DEF_SLBL(26,___L26_c_23_pt_2d_recursive_2d_let)
   ___IF(___NOT(___NULLP(___STK(-7))))
   ___GOTO(___L73_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___IF(___NULLP(___STK(-5)))
   ___GOTO(___L70_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L72_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-14,___STK(-15))
   ___SET_STK(-13,___STK(-11))
   ___SET_STK(1,___STK(-15))
   ___SET_STK(2,___STK(-11))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___STK(-5))
   ___SET_STK(6,___NUL)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(10))
   ___ADJFP(6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_GLBL(___L73_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-14,___STK(-15))
   ___SET_STK(-13,___STK(-11))
   ___SET_STK(1,___STK(-15))
   ___SET_STK(2,___STK(-11))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___STK(-7))
   ___SET_STK(6,___NUL)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(27))
   ___ADJFP(6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(27,___L27_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(1,___STK(-14))
   ___SET_R3(___STK(-6))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-13))
   ___SET_R0(___LBL(24))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_SLBL(28,___L28_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___CONS(___STK(-7),___R1))
   ___CHECK_HEAP(29,4096)
___DEF_SLBL(29,___L29_c_23_pt_2d_recursive_2d_let)
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23_pt_2d_recursive_2d_let)
   ___GOTO(___L67_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(31,___L31_c_23_pt_2d_recursive_2d_let)
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),396,___G_c_23_transitive_2d_closure)
___DEF_SLBL(32,___L32_c_23_pt_2d_recursive_2d_let)
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),395,___G_c_23_topological_2d_sort)
___DEF_SLBL(33,___L33_c_23_pt_2d_recursive_2d_let)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-4))
   ___ADJFP(-8)
   ___POLL(34)
___DEF_SLBL(34,___L34_c_23_pt_2d_recursive_2d_let)
   ___GOTO(___L76_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(35,___L35_c_23_pt_2d_recursive_2d_let)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L78_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_R3(___CONS(___STK(-6),___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-11)
   ___CHECK_HEAP(36,4096)
___DEF_SLBL(36,___L36_c_23_pt_2d_recursive_2d_let)
   ___POLL(37)
___DEF_SLBL(37,___L37_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L74_c_23_pt_2d_recursive_2d_let)
   ___IF(___NOT(___NULLP(___STK(0))))
   ___GOTO(___L80_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___SET_STK(-1,___R0)
   ___SET_STK(0,___R1)
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R3)
   ___SET_STK(8,___STK(-8))
   ___SET_STK(9,___STK(-7))
   ___SET_STK(10,___STK(-6))
   ___SET_STK(11,___STK(-5))
   ___SET_STK(12,___STK(-4))
   ___SET_R2(___STK(-2))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(26))
   ___ADJFP(12)
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_pt_2d_recursive_2d_let)
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L81_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L75_c_23_pt_2d_recursive_2d_let)
   ___SET_R3(___CDR(___R2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___POLL(39)
___DEF_SLBL(39,___L39_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L76_c_23_pt_2d_recursive_2d_let)
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L77_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___POLL(40)
___DEF_SLBL(40,___L40_c_23_pt_2d_recursive_2d_let)
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(1154),___L_c_23_pt_2d_body)
___DEF_GLBL(___L77_c_23_pt_2d_recursive_2d_let)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(42))
   ___ADJFP(8)
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23_pt_2d_recursive_2d_let)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),404,___G_c_23_varset_2d__3e_list)
___DEF_SLBL(42,___L42_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_STK(-4,___STK(-3))
   ___SET_R0(___LBL(43))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(43,___L43_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-7,___R1)
   ___SET_R3(___NUL)
   ___SET_R2(___NUL)
   ___SET_R1(___NUL)
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_pt_2d_recursive_2d_let)
   ___GOTO(___L74_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(45,___L45_c_23_pt_2d_recursive_2d_let)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L79_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L78_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-11,___CDR(___STK(-11)))
   ___SET_R2(___CONS(___STK(-5),___STK(-8)))
   ___SET_R1(___CONS(___STK(-6),___STK(-9)))
   ___SET_R3(___STK(-7))
   ___SET_R0(___STK(-10))
   ___ADJFP(-11)
   ___CHECK_HEAP(46,4096)
___DEF_SLBL(46,___L46_c_23_pt_2d_recursive_2d_let)
   ___POLL(47)
___DEF_SLBL(47,___L47_c_23_pt_2d_recursive_2d_let)
   ___GOTO(___L74_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L79_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(48))
   ___JUMPINT(___SET_NARGS(1),___PRC(445),___L_c_23_bound_2d_free_2d_variables)
___DEF_SLBL(48,___L48_c_23_pt_2d_recursive_2d_let)
   ___SET_R2(___STK(-12))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),408,___G_c_23_varset_2d_intersects_3f_)
___DEF_GLBL(___L80_c_23_pt_2d_recursive_2d_let)
   ___SET_R4(___CAR(___STK(0)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R3(___R4)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(61))
   ___ADJFP(11)
   ___POLL(49)
___DEF_SLBL(49,___L49_c_23_pt_2d_recursive_2d_let)
   ___GOTO(___L82_c_23_pt_2d_recursive_2d_let)
___DEF_SLBL(50,___L50_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-11))
   ___SET_STK(6,___STK(-10))
   ___SET_STK(7,___STK(-9))
   ___SET_STK(8,___STK(-8))
   ___SET_STK(9,___STK(-7))
   ___SET_R3(___CDR(___STK(-3)))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(58))
   ___ADJFP(9)
   ___IF(___NULLP(___R3))
   ___GOTO(___L75_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L81_c_23_pt_2d_recursive_2d_let)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(5,___R4)
   ___SET_R3(___R4)
   ___SET_R2(___STK(-2))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(60))
   ___ADJFP(11)
   ___POLL(51)
___DEF_SLBL(51,___L51_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L82_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(53))
   ___ADJFP(8)
   ___POLL(52)
___DEF_SLBL(52,___L52_c_23_pt_2d_recursive_2d_let)
   ___JUMPPRM(___SET_NARGS(1),___PRM_length)
___DEF_SLBL(53,___L53_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(55))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L84_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___GOTO(___L85_c_23_pt_2d_recursive_2d_let)
___DEF_GLBL(___L83_c_23_pt_2d_recursive_2d_let)
   ___SET_R2(___CDR(___R2))
   ___POLL(54)
___DEF_SLBL(54,___L54_c_23_pt_2d_recursive_2d_let)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L85_c_23_pt_2d_recursive_2d_let)
   ___END_IF
___DEF_GLBL(___L84_c_23_pt_2d_recursive_2d_let)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___EQP(___R1,___R3)))
   ___GOTO(___L83_c_23_pt_2d_recursive_2d_let)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L85_c_23_pt_2d_recursive_2d_let)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(55,___L55_c_23_pt_2d_recursive_2d_let)
   ___SET_R0(___LBL(56))
   ___JUMPPRM(___SET_NARGS(1),___PRM_length)
___DEF_SLBL(56,___L56_c_23_pt_2d_recursive_2d_let)
   ___SET_R2(___FIXSUB(___STK(-3),___R1))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(57)
___DEF_SLBL(57,___L57_c_23_pt_2d_recursive_2d_let)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_list_2d_ref)
___DEF_SLBL(58,___L58_c_23_pt_2d_recursive_2d_let)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___STK(-10))
   ___SET_R2(___STK(-6))
   ___POLL(59)
___DEF_SLBL(59,___L59_c_23_pt_2d_recursive_2d_let)
   ___ADJFP(-15)
   ___JUMPINT(___SET_NARGS(4),___PRC(377),___L_c_23_new_2d_seq)
___DEF_SLBL(60,___L60_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-3,___STK(-15))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(50))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(207),___L_c_23_new_2d_set)
___DEF_SLBL(61,___L61_c_23_pt_2d_recursive_2d_let)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(45))
   ___JUMPINT(___SET_NARGS(1),___PRC(136),___L_c_23_prc_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_begin
#undef ___PH_LBL0
#define ___PH_LBL0 1466
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_begin)
___DEF_P_HLBL(___L1_c_23_pt_2d_begin)
___DEF_P_HLBL(___L2_c_23_pt_2d_begin)
___DEF_P_HLBL(___L3_c_23_pt_2d_begin)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_begin)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_begin)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_begin)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_begin)
   ___SET_R1(___CDR(___R1))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_pt_2d_begin)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_do
#undef ___PH_LBL0
#define ___PH_LBL0 1471
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_do)
___DEF_P_HLBL(___L1_c_23_pt_2d_do)
___DEF_P_HLBL(___L2_c_23_pt_2d_do)
___DEF_P_HLBL(___L3_c_23_pt_2d_do)
___DEF_P_HLBL(___L4_c_23_pt_2d_do)
___DEF_P_HLBL(___L5_c_23_pt_2d_do)
___DEF_P_HLBL(___L6_c_23_pt_2d_do)
___DEF_P_HLBL(___L7_c_23_pt_2d_do)
___DEF_P_HLBL(___L8_c_23_pt_2d_do)
___DEF_P_HLBL(___L9_c_23_pt_2d_do)
___DEF_P_HLBL(___L10_c_23_pt_2d_do)
___DEF_P_HLBL(___L11_c_23_pt_2d_do)
___DEF_P_HLBL(___L12_c_23_pt_2d_do)
___DEF_P_HLBL(___L13_c_23_pt_2d_do)
___DEF_P_HLBL(___L14_c_23_pt_2d_do)
___DEF_P_HLBL(___L15_c_23_pt_2d_do)
___DEF_P_HLBL(___L16_c_23_pt_2d_do)
___DEF_P_HLBL(___L17_c_23_pt_2d_do)
___DEF_P_HLBL(___L18_c_23_pt_2d_do)
___DEF_P_HLBL(___L19_c_23_pt_2d_do)
___DEF_P_HLBL(___L20_c_23_pt_2d_do)
___DEF_P_HLBL(___L21_c_23_pt_2d_do)
___DEF_P_HLBL(___L22_c_23_pt_2d_do)
___DEF_P_HLBL(___L23_c_23_pt_2d_do)
___DEF_P_HLBL(___L24_c_23_pt_2d_do)
___DEF_P_HLBL(___L25_c_23_pt_2d_do)
___DEF_P_HLBL(___L26_c_23_pt_2d_do)
___DEF_P_HLBL(___L27_c_23_pt_2d_do)
___DEF_P_HLBL(___L28_c_23_pt_2d_do)
___DEF_P_HLBL(___L29_c_23_pt_2d_do)
___DEF_P_HLBL(___L30_c_23_pt_2d_do)
___DEF_P_HLBL(___L31_c_23_pt_2d_do)
___DEF_P_HLBL(___L32_c_23_pt_2d_do)
___DEF_P_HLBL(___L33_c_23_pt_2d_do)
___DEF_P_HLBL(___L34_c_23_pt_2d_do)
___DEF_P_HLBL(___L35_c_23_pt_2d_do)
___DEF_P_HLBL(___L36_c_23_pt_2d_do)
___DEF_P_HLBL(___L37_c_23_pt_2d_do)
___DEF_P_HLBL(___L38_c_23_pt_2d_do)
___DEF_P_HLBL(___L39_c_23_pt_2d_do)
___DEF_P_HLBL(___L40_c_23_pt_2d_do)
___DEF_P_HLBL(___L41_c_23_pt_2d_do)
___DEF_P_HLBL(___L42_c_23_pt_2d_do)
___DEF_P_HLBL(___L43_c_23_pt_2d_do)
___DEF_P_HLBL(___L44_c_23_pt_2d_do)
___DEF_P_HLBL(___L45_c_23_pt_2d_do)
___DEF_P_HLBL(___L46_c_23_pt_2d_do)
___DEF_P_HLBL(___L47_c_23_pt_2d_do)
___DEF_P_HLBL(___L48_c_23_pt_2d_do)
___DEF_P_HLBL(___L49_c_23_pt_2d_do)
___DEF_P_HLBL(___L50_c_23_pt_2d_do)
___DEF_P_HLBL(___L51_c_23_pt_2d_do)
___DEF_P_HLBL(___L52_c_23_pt_2d_do)
___DEF_P_HLBL(___L53_c_23_pt_2d_do)
___DEF_P_HLBL(___L54_c_23_pt_2d_do)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_do)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_do)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_do)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_do)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SYM_do_2d_temp)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(392),___L_c_23_new_2d_temp_2d_variable)
___DEF_SLBL(3,___L3_c_23_pt_2d_do)
   ___SET_R2(___CADR(___STK(-7)))
   ___SET_STK(-2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23_pt_2d_do)
   ___SET_R0(___LBL(7))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L55_c_23_pt_2d_do)
   ___END_IF
   ___GOTO(___L57_c_23_pt_2d_do)
___DEF_SLBL(5,___L5_c_23_pt_2d_do)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(12))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L57_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L55_c_23_pt_2d_do)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_pt_2d_do)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(7,___L7_c_23_pt_2d_do)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(9))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L57_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L56_c_23_pt_2d_do)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(52))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_pt_2d_do)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L56_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L57_c_23_pt_2d_do)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(9,___L9_c_23_pt_2d_do)
   ___SET_R0(___LBL(18))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L58_c_23_pt_2d_do)
   ___END_IF
   ___GOTO(___L57_c_23_pt_2d_do)
___DEF_SLBL(10,___L10_c_23_pt_2d_do)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(12))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L57_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L58_c_23_pt_2d_do)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(10))
   ___ADJFP(8)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_do)
   ___JUMPINT(___SET_NARGS(1),___PRC(413),___L_c_23_new_2d_variable)
___DEF_SLBL(12,___L12_c_23_pt_2d_do)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_pt_2d_do)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_pt_2d_do)
   ___GOTO(___L59_c_23_pt_2d_do)
___DEF_SLBL(15,___L15_c_23_pt_2d_do)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(16,4096)
___DEF_SLBL(16,___L16_c_23_pt_2d_do)
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_pt_2d_do)
___DEF_GLBL(___L59_c_23_pt_2d_do)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(18,___L18_c_23_pt_2d_do)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(21))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L60_c_23_pt_2d_do)
   ___END_IF
   ___GOTO(___L57_c_23_pt_2d_do)
___DEF_SLBL(19,___L19_c_23_pt_2d_do)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(15))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L57_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L60_c_23_pt_2d_do)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___CADR(___R3))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(19))
   ___ADJFP(8)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_pt_2d_do)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(21,___L21_c_23_pt_2d_do)
   ___SET_STK(-3,___R1)
   ___SET_R2(___CONS(___STK(-6),___NUL))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(23))
   ___CHECK_HEAP(22,4096)
___DEF_SLBL(22,___L22_c_23_pt_2d_do)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(23,___L23_c_23_pt_2d_do)
   ___SET_STK(-2,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R0(___LBL(24))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),328,___G_c_23_env_2d_frame)
___DEF_SLBL(24,___L24_c_23_pt_2d_do)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-9))
   ___SET_R0(___LBL(28))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L61_c_23_pt_2d_do)
   ___END_IF
   ___GOTO(___L57_c_23_pt_2d_do)
___DEF_SLBL(25,___L25_c_23_pt_2d_do)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(15))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L57_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L61_c_23_pt_2d_do)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(2L))
   ___SET_R0(___LBL(27))
   ___ADJFP(8)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_pt_2d_do)
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(27,___L27_c_23_pt_2d_do)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L62_c_23_pt_2d_do)
   ___END_IF
   ___SET_R1(___CADDR(___STK(-4)))
   ___GOTO(___L63_c_23_pt_2d_do)
___DEF_GLBL(___L62_c_23_pt_2d_do)
   ___SET_R1(___CAR(___STK(-4)))
___DEF_GLBL(___L63_c_23_pt_2d_do)
   ___SET_R2(___STK(-6))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(28,___L28_c_23_pt_2d_do)
   ___SET_R2(___CADDR(___STK(-15)))
   ___SET_STK(-9,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(29,___L29_c_23_pt_2d_do)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(30))
   ___JUMPINT(___SET_NARGS(2),___PRC(422),___L_c_23_set_2d_prc_2d_names_21_)
___DEF_SLBL(30,___L30_c_23_pt_2d_do)
   ___SET_STK(-3,___STK(-13))
   ___SET_STK(-2,___STK(-12))
   ___SET_STK(5,___STK(-13))
   ___SET_STK(6,___STK(-12))
   ___SET_STK(7,___FAL)
   ___SET_STK(8,___FAL)
   ___SET_STK(9,___CONS(___STK(-10),___NUL))
   ___SET_STK(10,___NUL)
   ___SET_STK(-1,___STK(-13))
   ___SET_STK(0,___STK(-6))
   ___SET_R3(___STK(-10))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-13))
   ___SET_R0(___LBL(32))
   ___ADJFP(16)
   ___CHECK_HEAP(31,4096)
___DEF_SLBL(31,___L31_c_23_pt_2d_do)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(32,___L32_c_23_pt_2d_do)
   ___SET_STK(1,___STK(-17))
   ___SET_R3(___STK(-23))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-16))
   ___SET_R0(___LBL(33))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___DEF_SLBL(33,___L33_c_23_pt_2d_do)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(34))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(34,___L34_c_23_pt_2d_do)
   ___SET_STK(-11,___R1)
   ___SET_STK(1,___STK(-17))
   ___SET_STK(2,___STK(-16))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___STK(-12))
   ___SET_STK(6,___NUL)
   ___SET_STK(13,___STK(-17))
   ___SET_STK(14,___STK(-9))
   ___SET_R2(___STK(-9))
   ___SET_R1(___CAR(___STK(-8)))
   ___SET_R3(___SYM_pred)
   ___SET_R0(___LBL(35))
   ___ADJFP(20)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(35,___L35_c_23_pt_2d_do)
   ___SET_STK(-36,___R1)
   ___SET_R1(___STK(-28))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(36))
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(36,___L36_c_23_pt_2d_do)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L68_c_23_pt_2d_do)
   ___END_IF
   ___SET_STK(1,___CADDR(___STK(-39)))
   ___SET_R3(___STK(-35))
   ___SET_R2(___STK(-29))
   ___SET_R1(___CDR(___STK(-28)))
   ___SET_R0(___LBL(37))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_SLBL(37,___L37_c_23_pt_2d_do)
   ___SET_STK(-35,___R1)
   ___SET_R1(___STK(-39))
   ___SET_R2(___FIX(3L))
   ___SET_R0(___LBL(38))
   ___JUMPINT(___SET_NARGS(2),___PRC(1897),___L_c_23_length_3f_)
___DEF_SLBL(38,___L38_c_23_pt_2d_do)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L67_c_23_pt_2d_do)
   ___END_IF
   ___SET_STK(1,___STK(-37))
   ___SET_STK(5,___STK(-37))
   ___SET_R2(___STK(-29))
   ___SET_R1(___CDDDR(___STK(-39)))
   ___SET_R3(___SYM_none)
   ___SET_R0(___LBL(39))
   ___ADJFP(5)
   ___JUMPINT(___SET_NARGS(4),___PRC(1197),___L_c_23_pt_2d_sequence)
___DEF_SLBL(39,___L39_c_23_pt_2d_do)
   ___SET_STK(-43,___R1)
   ___SET_STK(1,___STK(-41))
   ___SET_R3(___STK(-38))
   ___SET_R2(___STK(-33))
   ___SET_R1(___STK(-41))
   ___SET_R0(___LBL(40))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(40,___L40_c_23_pt_2d_do)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-41))
   ___SET_R1(___STK(-37))
   ___SET_R0(___LBL(41))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(324),___L_c_23_new_2d_call_2a_)
___DEF_SLBL(41,___L41_c_23_pt_2d_do)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-33))
   ___SET_R0(___LBL(42))
   ___SET_R2(___STK(-43))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(377),___L_c_23_new_2d_seq)
___DEF_SLBL(42,___L42_c_23_pt_2d_do)
   ___SET_R3(___R1)
   ___SET_R0(___LBL(43))
   ___SET_R2(___STK(-35))
   ___SET_R1(___STK(-36))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(5),___PRC(235),___L_c_23_new_2d_tst)
___DEF_SLBL(43,___L43_c_23_pt_2d_do)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(44))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(44,___L44_c_23_pt_2d_do)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R2(___CONS(___STK(-11),___R1))
   ___SET_STK(-19,___R1)
   ___SET_STK(-17,___R2)
   ___SET_R0(___LBL(46))
   ___CHECK_HEAP(45,4096)
___DEF_SLBL(45,___L45_c_23_pt_2d_do)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),127,___G_c_23_next_2d_node_2d_stamp)
___DEF_SLBL(46,___L46_c_23_pt_2d_do)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___GLO_c_23_app_2d_tag)
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___STK(-17))
   ___ADD_VECTOR_ELEM(3,___TRU)
   ___ADD_VECTOR_ELEM(4,___TRU)
   ___ADD_VECTOR_ELEM(5,___STK(-6))
   ___ADD_VECTOR_ELEM(6,___STK(-7))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___VECTORSET(___STK(-11),___FIX(1L),___R1)
   ___SET_STK(-17,___R1)
   ___SET_R2(___STK(-19))
   ___SET_R0(___LBL(49))
   ___ADJFP(-12)
   ___CHECK_HEAP(47,4096)
___DEF_SLBL(47,___L47_c_23_pt_2d_do)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L65_c_23_pt_2d_do)
   ___END_IF
   ___GOTO(___L66_c_23_pt_2d_do)
___DEF_GLBL(___L64_c_23_pt_2d_do)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L66_c_23_pt_2d_do)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L66_c_23_pt_2d_do)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___POLL(48)
___DEF_SLBL(48,___L48_c_23_pt_2d_do)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L66_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L65_c_23_pt_2d_do)
   ___SET_R3(___CAR(___R2))
   ___VECTORSET(___R3,___FIX(1L),___R1)
   ___SET_R2(___CDR(___R2))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L64_c_23_pt_2d_do)
   ___END_IF
___DEF_GLBL(___L66_c_23_pt_2d_do)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(49,___L49_c_23_pt_2d_do)
   ___SET_R1(___STK(-5))
   ___POLL(50)
___DEF_SLBL(50,___L50_c_23_pt_2d_do)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L67_c_23_pt_2d_do)
   ___SET_STK(1,___STK(-37))
   ___SET_R3(___STK(-34))
   ___SET_R2(___STK(-29))
   ___SET_R1(___STK(-37))
   ___SET_R0(___LBL(51))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(51,___L51_c_23_pt_2d_do)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-37))
   ___SET_R1(___STK(-33))
   ___SET_R0(___LBL(42))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(324),___L_c_23_new_2d_call_2a_)
___DEF_GLBL(___L68_c_23_pt_2d_do)
   ___SET_R2(___STK(-29))
   ___SET_R1(___CADDR(___STK(-39)))
   ___SET_R3(___GLO_c_23_void_2d_object)
   ___SET_R0(___LBL(37))
   ___JUMPINT(___SET_NARGS(3),___PRC(188),___L_c_23_new_2d_cst)
___DEF_SLBL(52,___L52_c_23_pt_2d_do)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(53,4096)
___DEF_SLBL(53,___L53_c_23_pt_2d_do)
   ___POLL(54)
___DEF_SLBL(54,___L54_c_23_pt_2d_do)
   ___GOTO(___L59_c_23_pt_2d_do)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_combination
#undef ___PH_LBL0
#define ___PH_LBL0 1527
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_combination)
___DEF_P_HLBL(___L1_c_23_pt_2d_combination)
___DEF_P_HLBL(___L2_c_23_pt_2d_combination)
___DEF_P_HLBL(___L3_c_23_pt_2d_combination)
___DEF_P_HLBL(___L4_c_23_pt_2d_combination)
___DEF_P_HLBL(___L5_c_23_pt_2d_combination)
___DEF_P_HLBL(___L6_c_23_pt_2d_combination)
___DEF_P_HLBL(___L7_c_23_pt_2d_combination)
___DEF_P_HLBL(___L8_c_23_pt_2d_combination)
___DEF_P_HLBL(___L9_c_23_pt_2d_combination)
___DEF_P_HLBL(___L10_c_23_pt_2d_combination)
___DEF_P_HLBL(___L11_c_23_pt_2d_combination)
___DEF_P_HLBL(___L12_c_23_pt_2d_combination)
___DEF_P_HLBL(___L13_c_23_pt_2d_combination)
___DEF_P_HLBL(___L14_c_23_pt_2d_combination)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_combination)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_combination)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_combination)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_combination)
   ___SET_STK(-7,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CAR(___R1))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(3,___L3_c_23_pt_2d_combination)
   ___SET_STK(-3,___STK(-4))
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(13))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L15_c_23_pt_2d_combination)
   ___END_IF
   ___GOTO(___L20_c_23_pt_2d_combination)
___DEF_SLBL(4,___L4_c_23_pt_2d_combination)
   ___SET_STK(-2,___R1)
   ___SET_R2(___CDR(___STK(-3)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L20_c_23_pt_2d_combination)
   ___END_IF
___DEF_GLBL(___L15_c_23_pt_2d_combination)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_pt_2d_combination)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(6,___L6_c_23_pt_2d_combination)
   ___SET_R2(___CDR(___STK(-5)))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L18_c_23_pt_2d_combination)
   ___END_IF
   ___SET_STK(-6,___R1)
   ___SET_R1(___NUL)
   ___GOTO(___L17_c_23_pt_2d_combination)
___DEF_SLBL(7,___L7_c_23_pt_2d_combination)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___SET_STK(-10,___STK(-8))
   ___ADJFP(-4)
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23_pt_2d_combination)
___DEF_GLBL(___L16_c_23_pt_2d_combination)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___SET_STK(-6,___STK(-5))
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_pt_2d_combination)
___DEF_GLBL(___L17_c_23_pt_2d_combination)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_pt_2d_combination)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_pt_2d_combination)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L18_c_23_pt_2d_combination)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R2)
   ___SET_R2(___STK(-6))
   ___SET_R1(___R3)
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(12,___L12_c_23_pt_2d_combination)
   ___SET_R2(___CDR(___STK(-4)))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L19_c_23_pt_2d_combination)
   ___END_IF
   ___SET_STK(-6,___R1)
   ___SET_R1(___NUL)
   ___GOTO(___L16_c_23_pt_2d_combination)
___DEF_GLBL(___L19_c_23_pt_2d_combination)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(-4,___R1)
   ___SET_STK(-3,___R2)
   ___SET_R2(___STK(-6))
   ___SET_R1(___R3)
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_GLBL(___L20_c_23_pt_2d_combination)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(13,___L13_c_23_pt_2d_combination)
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___STK(-5))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R0(___STK(-6))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_pt_2d_combination)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_delay
#undef ___PH_LBL0
#define ___PH_LBL0 1543
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_delay)
___DEF_P_HLBL(___L1_c_23_pt_2d_delay)
___DEF_P_HLBL(___L2_c_23_pt_2d_delay)
___DEF_P_HLBL(___L3_c_23_pt_2d_delay)
___DEF_P_HLBL(___L4_c_23_pt_2d_delay)
___DEF_P_HLBL(___L5_c_23_pt_2d_delay)
___DEF_P_HLBL(___L6_c_23_pt_2d_delay)
___DEF_P_HLBL(___L7_c_23_pt_2d_delay)
___DEF_P_HLBL(___L8_c_23_pt_2d_delay)
___DEF_P_HLBL(___L9_c_23_pt_2d_delay)
___DEF_P_HLBL(___L10_c_23_pt_2d_delay)
___DEF_P_HLBL(___L11_c_23_pt_2d_delay)
___DEF_P_HLBL(___L12_c_23_pt_2d_delay)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_delay)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_delay)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_delay)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_delay)
   ___SET_STK(-7,___STK(-5))
   ___SET_STK(-3,___STK(-4))
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-3))
   ___BEGIN_ALLOC_LIST(2,___FAL)
   ___ADD_LIST_ELEM(1,___GLO_c_23_safe_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_pt_2d_delay)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(4,___L4_c_23_pt_2d_delay)
   ___SET_STK(-7,___STK(-9))
   ___SET_STK(-5,___GLO_c_23__2a__2a_make_2d_promise_2d_sym)
   ___SET_STK(-4,___STK(-8))
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___STK(-4))
   ___SET_R1(___STK(-2))
   ___BEGIN_ALLOC_LIST(2,___TRU)
   ___ADD_LIST_ELEM(1,___GLO_c_23_extended_2d_bindings_2d_sym)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___SET_R0(___LBL(6))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_pt_2d_delay)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_SLBL(6,___L6_c_23_pt_2d_delay)
   ___SET_STK(-2,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),330,___G_c_23_env_2d_lookup_2d_global_2d_var)
___DEF_SLBL(7,___L7_c_23_pt_2d_delay)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(8))
   ___SET_R2(___STK(-6))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(194),___L_c_23_new_2d_ref)
___DEF_SLBL(8,___L8_c_23_pt_2d_delay)
   ___SET_STK(-7,___R1)
   ___SET_STK(1,___STK(-9))
   ___SET_STK(2,___STK(-8))
   ___SET_STK(3,___FAL)
   ___SET_STK(4,___FAL)
   ___SET_STK(5,___NUL)
   ___SET_STK(6,___NUL)
   ___SET_R2(___STK(-8))
   ___SET_R1(___CADR(___STK(-6)))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(9))
   ___ADJFP(12)
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(9,___L9_c_23_pt_2d_delay)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(10))
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(9),___PRC(298),___L_c_23_new_2d_prc)
___DEF_SLBL(10,___L10_c_23_pt_2d_delay)
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-3))
   ___SET_R0(___STK(-10))
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_pt_2d_delay)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_pt_2d_delay)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(315),___L_c_23_new_2d_call)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pt_2d_future
#undef ___PH_LBL0
#define ___PH_LBL0 1557
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pt_2d_future)
___DEF_P_HLBL(___L1_c_23_pt_2d_future)
___DEF_P_HLBL(___L2_c_23_pt_2d_future)
___DEF_P_HLBL(___L3_c_23_pt_2d_future)
___DEF_P_HLBL(___L4_c_23_pt_2d_future)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pt_2d_future)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_pt_2d_future)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pt_2d_future)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_pt_2d_future)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CADR(___R1))
   ___SET_R3(___SYM_true)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(3),___PRC(756),___L_c_23_pt)
___DEF_SLBL(3,___L3_c_23_pt_2d_future)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_pt_2d_future)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(346),___L_c_23_new_2d_fut)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_self_2d_eval_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1563
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_self_2d_eval_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_self_2d_eval_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23_self_2d_eval_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23_self_2d_eval_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_self_2d_eval_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_self_2d_eval_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_self_2d_eval_2d_expr_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_self_2d_eval_2d_expr_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_self_2d_eval_2d_expr_3f_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(1568),___L_c_23_self_2d_evaluating_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_self_2d_evaluating_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1568
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L1_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L2_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L3_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L4_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L5_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L6_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L7_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L8_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L9_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L10_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L11_c_23_self_2d_evaluating_3f_)
___DEF_P_HLBL(___L12_c_23_self_2d_evaluating_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_self_2d_evaluating_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_self_2d_evaluating_3f_)
   ___IF(___NUMBERP(___R1))
   ___GOTO(___L18_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___IF(___STRINGP(___R1))
   ___GOTO(___L18_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___IF(___CHARP(___R1))
   ___GOTO(___L18_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_self_2d_evaluating_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),351,___G_c_23_keyword_2d_object_3f_)
___DEF_SLBL(2,___L2_c_23_self_2d_evaluating_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L16_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
___DEF_SLBL(3,___L3_c_23_self_2d_evaluating_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L15_c_23_self_2d_evaluating_3f_)
   ___END_IF
___DEF_GLBL(___L13_c_23_self_2d_evaluating_3f_)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_self_2d_evaluating_3f_)
___DEF_GLBL(___L14_c_23_self_2d_evaluating_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L15_c_23_self_2d_evaluating_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_self_2d_evaluating_3f_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),384,___G_c_23_rest_2d_object_3f_)
___DEF_GLBL(___L16_c_23_self_2d_evaluating_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),339,___G_c_23_false_2d_object_3f_)
___DEF_SLBL(6,___L6_c_23_self_2d_evaluating_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___IF(___NOT(___EQP(___STK(-6),___TRU)))
   ___GOTO(___L17_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_self_2d_evaluating_3f_)
   ___GOTO(___L14_c_23_self_2d_evaluating_3f_)
___DEF_GLBL(___L17_c_23_self_2d_evaluating_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),325,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
___DEF_SLBL(8,___L8_c_23_self_2d_evaluating_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),413,___G_c_23_void_2d_object_3f_)
___DEF_SLBL(9,___L9_c_23_self_2d_evaluating_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),397,___G_c_23_unbound1_2d_object_3f_)
___DEF_SLBL(10,___L10_c_23_self_2d_evaluating_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),398,___G_c_23_unbound2_2d_object_3f_)
___DEF_SLBL(11,___L11_c_23_self_2d_evaluating_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),366,___G_c_23_optional_2d_object_3f_)
___DEF_SLBL(12,___L12_c_23_self_2d_evaluating_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_self_2d_evaluating_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),350,___G_c_23_key_2d_object_3f_)
___DEF_GLBL(___L18_c_23_self_2d_evaluating_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_quote_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1582
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_quote_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_quote_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_quote_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_quote_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23__2a__2a_quote_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_quote_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_quasiquote_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1585
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_quasiquote_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_quasiquote_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_quasiquote_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_quasiquote_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23__2a__2a_quasiquote_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_quasiquote_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_quasiquote_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1588
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_quasiquote_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_quasiquote_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_quasiquote_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_quasiquote_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23_quasiquote_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_quasiquote_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unquote_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1591
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unquote_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_unquote_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unquote_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unquote_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23_unquote_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_unquote_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unquote_2d_splicing_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1594
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unquote_2d_splicing_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_unquote_2d_splicing_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unquote_2d_splicing_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unquote_2d_splicing_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23_unquote_2d_splicing_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_unquote_2d_splicing_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_var_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1597
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_var_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_var_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23_var_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23_var_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23_var_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23_var_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_var_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_var_2d_expr_3f_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_var_2d_expr_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_var_2d_expr_3f_)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___DEF_SLBL(3,___L3_c_23_var_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L6_c_23_var_2d_expr_3f_)
   ___END_IF
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_var_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L6_c_23_var_2d_expr_3f_)
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_var_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1604),___L_c_23_not_2d_macro)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_not_2d_macro
#undef ___PH_LBL0
#define ___PH_LBL0 1604
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_not_2d_macro)
___DEF_P_HLBL(___L1_c_23_not_2d_macro)
___DEF_P_HLBL(___L2_c_23_not_2d_macro)
___DEF_P_HLBL(___L3_c_23_not_2d_macro)
___DEF_P_HLBL(___L4_c_23_not_2d_macro)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_not_2d_macro)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_not_2d_macro)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(4))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_not_2d_macro)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),331,___G_c_23_env_2d_lookup_2d_macro)
___DEF_SLBL(2,___L2_c_23_not_2d_macro)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23_not_2d_macro)
   ___END_IF
   ___SET_R1(___TRU)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_not_2d_macro)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L5_c_23_not_2d_macro)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(52))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_not_2d_macro)
   ___ADJFP(-8)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_bindable_2d_var_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1610
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_bindable_2d_var_3f_)
___DEF_P_HLBL(___L1_c_23_bindable_2d_var_3f_)
___DEF_P_HLBL(___L2_c_23_bindable_2d_var_3f_)
___DEF_P_HLBL(___L3_c_23_bindable_2d_var_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_bindable_2d_var_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_bindable_2d_var_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_bindable_2d_var_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_bindable_2d_var_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_bindable_2d_var_3f_)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_set_21__2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1615
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_set_21__2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_set_21__2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_set_21__2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_set_21__2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_set_21__2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_set_21__2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_lambda_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1618
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_lambda_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_lambda_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_lambda_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_lambda_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_lambda_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_lambda_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_lambda_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1621
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_lambda_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_lambda_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_lambda_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_lambda_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23_lambda_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_lambda_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_if_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1624
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L6_c_23__2a__2a_if_2d_expr_3f_)
___DEF_P_HLBL(___L7_c_23__2a__2a_if_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_if_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_if_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_if_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_if_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_if_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L10_c_23__2a__2a_if_2d_expr_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_if_2d_expr_3f_)
   ___GOTO(___L8_c_23__2a__2a_if_2d_expr_3f_)
___DEF_SLBL(4,___L4_c_23__2a__2a_if_2d_expr_3f_)
   ___IF(___NOT(___FIXLE(___R1,___FIX(4L))))
   ___GOTO(___L9_c_23__2a__2a_if_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_if_2d_expr_3f_)
___DEF_GLBL(___L8_c_23__2a__2a_if_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L9_c_23__2a__2a_if_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_if_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1757),___L_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_GLBL(___L10_c_23__2a__2a_if_2d_expr_3f_)
   ___SET_STK(-5,___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(7,___L7_c_23__2a__2a_if_2d_expr_3f_)
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_length)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_cond_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1633
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_cond_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_cond_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_cond_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_cond_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-2L))
   ___SET_R1(___GLO_c_23__2a__2a_cond_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_cond_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_cond_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23__2a__2a_cond_2d_expr_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_cond_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L5_c_23__2a__2a_cond_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_cond_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1806),___L_c_23_proper_2d_clauses_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_and_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1639
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_and_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_and_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_and_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_and_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_and_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_and_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_or_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1642
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_or_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_or_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_or_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_or_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_or_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_or_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_case_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1645
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_case_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_case_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_case_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_case_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_case_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_case_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_case_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_case_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_case_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_case_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L5_c_23__2a__2a_case_2d_expr_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_case_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L5_c_23__2a__2a_case_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_case_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1822),___L_c_23_proper_2d_case_2d_clauses_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_let_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1651
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L6_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L7_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L8_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L9_c_23__2a__2a_let_2d_expr_3f_)
___DEF_P_HLBL(___L10_c_23__2a__2a_let_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_let_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_let_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_let_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_let_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_let_2d_expr_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_c_23__2a__2a_let_2d_expr_3f_)
   ___END_IF
   ___GOTO(___L15_c_23__2a__2a_let_2d_expr_3f_)
___DEF_SLBL(3,___L3_c_23__2a__2a_let_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23__2a__2a_let_2d_expr_3f_)
   ___END_IF
___DEF_GLBL(___L11_c_23__2a__2a_let_2d_expr_3f_)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_let_2d_expr_3f_)
___DEF_GLBL(___L12_c_23__2a__2a_let_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L13_c_23__2a__2a_let_2d_expr_3f_)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_length)
___DEF_SLBL(5,___L5_c_23__2a__2a_let_2d_expr_3f_)
   ___IF(___NOT(___FIXGT(___R1,___FIX(3L))))
   ___GOTO(___L14_c_23__2a__2a_let_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_let_2d_expr_3f_)
   ___GOTO(___L12_c_23__2a__2a_let_2d_expr_3f_)
___DEF_GLBL(___L14_c_23__2a__2a_let_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_let_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1757),___L_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_GLBL(___L15_c_23__2a__2a_let_2d_expr_3f_)
   ___SET_STK(-4,___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(8,___L8_c_23__2a__2a_let_2d_expr_3f_)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___CADR(___R1))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_SLBL(9,___L9_c_23__2a__2a_let_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L16_c_23__2a__2a_let_2d_expr_3f_)
   ___END_IF
   ___SET_R3(___STK(-5))
   ___SET_R1(___CADR(___STK(-4)))
   ___SET_R2(___TRU)
   ___SET_R0(___STK(-7))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23__2a__2a_let_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1845),___L_c_23_proper_2d_bindings_3f_)
___DEF_GLBL(___L16_c_23__2a__2a_let_2d_expr_3f_)
   ___SET_R3(___STK(-5))
   ___SET_R1(___CADDR(___STK(-4)))
   ___SET_R2(___TRU)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(3),___PRC(1845),___L_c_23_proper_2d_bindings_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_let_2a__2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1663
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_let_2a__2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_let_2a__2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_let_2a__2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L6_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___SET_R1(___CADR(___R1))
   ___SET_R3(___STK(-5))
   ___SET_R2(___FAL)
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_let_2a__2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1845),___L_c_23_proper_2d_bindings_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_letrec_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1670
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_letrec_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_letrec_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_letrec_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_letrec_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_letrec_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_letrec_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_letrec_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L6_c_23__2a__2a_letrec_2d_expr_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_letrec_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23__2a__2a_letrec_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23__2a__2a_letrec_2d_expr_3f_)
   ___SET_R1(___CADR(___R1))
   ___SET_R3(___STK(-5))
   ___SET_R2(___TRU)
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_letrec_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1845),___L_c_23_proper_2d_bindings_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_do_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1677
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_do_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_do_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_do_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_do_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_do_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_do_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_do_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_do_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_do_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_do_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_do_2d_expr_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L6_c_23__2a__2a_do_2d_expr_3f_)
   ___END_IF
   ___GOTO(___L8_c_23__2a__2a_do_2d_expr_3f_)
___DEF_SLBL(3,___L3_c_23__2a__2a_do_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L7_c_23__2a__2a_do_2d_expr_3f_)
   ___END_IF
___DEF_GLBL(___L6_c_23__2a__2a_do_2d_expr_3f_)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_do_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23__2a__2a_do_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_do_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1884),___L_c_23_proper_2d_do_2d_exit_3f_)
___DEF_GLBL(___L8_c_23__2a__2a_do_2d_expr_3f_)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(1864),___L_c_23_proper_2d_do_2d_bindings_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_combination_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1684
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L6_c_23_combination_2d_expr_3f_)
___DEF_P_HLBL(___L7_c_23_combination_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_combination_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_combination_2d_expr_3f_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_combination_2d_expr_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_combination_2d_expr_3f_)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L12_c_23_combination_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_combination_2d_expr_3f_)
   ___GOTO(___L8_c_23_combination_2d_expr_3f_)
___DEF_SLBL(4,___L4_c_23_combination_2d_expr_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L9_c_23_combination_2d_expr_3f_)
   ___END_IF
   ___IF(___NOT(___FIXGT(___R1,___FIX(0L))))
   ___GOTO(___L10_c_23_combination_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_combination_2d_expr_3f_)
___DEF_GLBL(___L8_c_23_combination_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L9_c_23_combination_2d_expr_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(53))
   ___SET_R0(___STK(-6))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_combination_2d_expr_3f_)
   ___GOTO(___L11_c_23_combination_2d_expr_3f_)
___DEF_GLBL(___L10_c_23_combination_2d_expr_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(54))
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_combination_2d_expr_3f_)
___DEF_GLBL(___L11_c_23_combination_2d_expr_3f_)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L12_c_23_combination_2d_expr_3f_)
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_delay_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1693
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_delay_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_delay_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_delay_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_delay_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_delay_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(528),___L_c_23_scheme_2d_dialect)
___DEF_SLBL(2,___L2_c_23__2a__2a_delay_2d_expr_3f_)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23_ieee_2d_scheme_2d_sym)))
   ___GOTO(___L5_c_23__2a__2a_delay_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_delay_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L5_c_23__2a__2a_delay_2d_expr_3f_)
   ___SET_R3(___STK(-6))
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23__2a__2a_delay_2d_sym)
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_delay_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_future_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1699
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_future_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_future_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_future_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_future_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_future_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_future_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_future_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_future_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(1),___PRC(528),___L_c_23_scheme_2d_dialect)
___DEF_SLBL(2,___L2_c_23__2a__2a_future_2d_expr_3f_)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23_multilisp_2d_sym)))
   ___GOTO(___L5_c_23__2a__2a_future_2d_expr_3f_)
   ___END_IF
   ___SET_R3(___STK(-6))
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23__2a__2a_future_2d_sym)
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_future_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_GLBL(___L5_c_23__2a__2a_future_2d_expr_3f_)
   ___SET_R1(___FAL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_future_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_macro_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1705
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L6_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L7_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L8_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L9_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L10_c_23_macro_2d_expr_3f_)
___DEF_P_HLBL(___L11_c_23_macro_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_macro_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_macro_2d_expr_3f_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_macro_2d_expr_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_macro_2d_expr_3f_)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L17_c_23_macro_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_macro_2d_expr_3f_)
   ___GOTO(___L13_c_23_macro_2d_expr_3f_)
___DEF_SLBL(4,___L4_c_23_macro_2d_expr_3f_)
   ___IF(___FIXGT(___R1,___FIX(0L)))
   ___GOTO(___L14_c_23_macro_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___FIXNEG(___R1))
   ___SET_R1(___BOOLEAN(___FIXGE(___STK(-7),___R1)))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L15_c_23_macro_2d_expr_3f_)
   ___END_IF
___DEF_GLBL(___L12_c_23_macro_2d_expr_3f_)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_macro_2d_expr_3f_)
___DEF_GLBL(___L13_c_23_macro_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L14_c_23_macro_2d_expr_3f_)
   ___SET_R1(___BOOLEAN(___FIXEQ(___STK(-7),___R1)))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L15_c_23_macro_2d_expr_3f_)
   ___END_IF
   ___GOTO(___L12_c_23_macro_2d_expr_3f_)
___DEF_SLBL(6,___L6_c_23_macro_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L16_c_23_macro_2d_expr_3f_)
   ___END_IF
___DEF_GLBL(___L15_c_23_macro_2d_expr_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_macro_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1757),___L_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_GLBL(___L16_c_23_macro_2d_expr_3f_)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),240,___G__23__23_macro_2d_descr_2d_size)
___DEF_GLBL(___L17_c_23_macro_2d_expr_3f_)
   ___SET_STK(-7,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(8,___L8_c_23_macro_2d_expr_3f_)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___DEF_SLBL(9,___L9_c_23_macro_2d_expr_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L12_c_23_macro_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___CAR(___STK(-7)))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(10,___L10_c_23_macro_2d_expr_3f_)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),331,___G_c_23_env_2d_lookup_2d_macro)
___DEF_SLBL(11,___L11_c_23_macro_2d_expr_3f_)
   ___SET_STK(-4,___R1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L12_c_23_macro_2d_expr_3f_)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1718
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_begin_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_begin_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1721
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_begin_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_begin_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_begin_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_begin_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-2L))
   ___SET_R1(___GLO_c_23__2a__2a_begin_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_begin_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_define_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1724
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_define_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_define_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_define_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_define_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-2L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_define_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_define_2d_macro_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1727
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_macro_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_define_2d_macro_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_define_2d_syntax_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1730
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_syntax_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_define_2d_syntax_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_include_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1733
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L6_c_23__2a__2a_include_2d_expr_3f_)
___DEF_P_HLBL(___L7_c_23__2a__2a_include_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_include_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_include_2d_expr_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___GLO_c_23__2a__2a_include_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_include_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23__2a__2a_include_2d_expr_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L8_c_23__2a__2a_include_2d_expr_3f_)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_include_2d_expr_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L8_c_23__2a__2a_include_2d_expr_3f_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23__2a__2a_include_2d_expr_3f_)
   ___SET_R1(___CADR(___R1))
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R1)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(5,___L5_c_23__2a__2a_include_2d_expr_3f_)
   ___IF(___NOT(___STRINGP(___R1)))
   ___GOTO(___L10_c_23__2a__2a_include_2d_expr_3f_)
   ___END_IF
   ___ADJFP(-4)
   ___GOTO(___L9_c_23__2a__2a_include_2d_expr_3f_)
___DEF_SLBL(6,___L6_c_23__2a__2a_include_2d_expr_3f_)
___DEF_GLBL(___L9_c_23__2a__2a_include_2d_expr_3f_)
   ___SET_R1(___TRU)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_include_2d_expr_3f_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L10_c_23__2a__2a_include_2d_expr_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(55))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_declare_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1742
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_declare_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_declare_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_declare_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_declare_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_declare_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_declare_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_namespace_2d_expr_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1745
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_namespace_2d_expr_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_namespace_2d_expr_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_namespace_2d_expr_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_namespace_2d_expr_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(-1L))
   ___SET_R1(___GLO_c_23__2a__2a_namespace_2d_sym)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_namespace_2d_expr_3f_)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_match
#undef ___PH_LBL0
#define ___PH_LBL0 1748
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_match)
___DEF_P_HLBL(___L1_c_23_match)
___DEF_P_HLBL(___L2_c_23_match)
___DEF_P_HLBL(___L3_c_23_match)
___DEF_P_HLBL(___L4_c_23_match)
___DEF_P_HLBL(___L5_c_23_match)
___DEF_P_HLBL(___L6_c_23_match)
___DEF_P_HLBL(___L7_c_23_match)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_match)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_match)
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_match)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_match)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L14_c_23_match)
   ___END_IF
   ___GOTO(___L8_c_23_match)
___DEF_SLBL(3,___L3_c_23_match)
   ___IF(___EQP(___R1,___STK(-5)))
   ___GOTO(___L10_c_23_match)
   ___END_IF
___DEF_GLBL(___L8_c_23_match)
   ___SET_R1(___FAL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_match)
___DEF_GLBL(___L9_c_23_match)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L10_c_23_match)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(5,___L5_c_23_match)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_c_23_match)
   ___END_IF
   ___IF(___FIXGT(___STK(-4),___FIX(0L)))
   ___GOTO(___L12_c_23_match)
   ___END_IF
   ___SET_R2(___FIXNEG(___STK(-4)))
   ___SET_R1(___BOOLEAN(___FIXGE(___R1,___R2)))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_match)
   ___END_IF
___DEF_GLBL(___L11_c_23_match)
   ___SET_R1(___STK(-3))
   ___SET_R0(___STK(-6))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_match)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(1757),___L_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_GLBL(___L12_c_23_match)
   ___SET_R1(___BOOLEAN(___FIXEQ(___R1,___STK(-4))))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_c_23_match)
   ___END_IF
___DEF_GLBL(___L13_c_23_match)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_match)
   ___GOTO(___L9_c_23_match)
___DEF_GLBL(___L14_c_23_match)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-7,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ill_2d_formed_2d_special_2d_form
#undef ___PH_LBL0
#define ___PH_LBL0 1757
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L1_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L2_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L3_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L4_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L5_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L6_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L7_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L8_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L9_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L10_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L11_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_P_HLBL(___L12_c_23_ill_2d_formed_2d_special_2d_form)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ill_2d_formed_2d_special_2d_form)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ill_2d_formed_2d_special_2d_form)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_symbol_2d__3e_string)
___DEF_SLBL(4,___L4_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R2(___STRINGLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___FIX(2L),___R2)))
   ___GOTO(___L13_c_23_ill_2d_formed_2d_special_2d_form)
   ___END_IF
   ___SET_R3(___STRINGREF(___R1,___FIX(0L)))
   ___IF(___NOT(___CHAREQP(___CHR(35),___R3)))
   ___GOTO(___L13_c_23_ill_2d_formed_2d_special_2d_form)
   ___END_IF
   ___SET_R3(___STRINGREF(___R1,___FIX(1L)))
   ___IF(___CHAREQP(___CHR(35),___R3))
   ___GOTO(___L15_c_23_ill_2d_formed_2d_special_2d_form)
   ___END_IF
___DEF_GLBL(___L13_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R1(___STK(-7))
   ___GOTO(___L14_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_SLBL(5,___L5_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_GLBL(___L14_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(56))
   ___SET_R0(___STK(-6))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_ill_2d_formed_2d_special_2d_form)
   ___ADJFP(-8)
   ___SET_NARGS(3) ___GOTO(___L7_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_SLBL(7,___L7_c_23_ill_2d_formed_2d_special_2d_form)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(7,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_ill_2d_formed_2d_special_2d_form)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),244,___G__23__23_source_2d_locat)
___DEF_SLBL(9,___L9_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R2(___CONS(___STK(-6),___STK(-5)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R1(___GLO_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___STK(-7))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_c_23_ill_2d_formed_2d_special_2d_form)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_ill_2d_formed_2d_special_2d_form)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_apply)
___DEF_GLBL(___L15_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R3(___R2)
   ___SET_R2(___FIX(2L))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(3),___PRM_substring)
___DEF_SLBL(12,___L12_c_23_ill_2d_formed_2d_special_2d_form)
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 1771
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_length)
___DEF_P_HLBL(___L1_c_23_proper_2d_length)
___DEF_P_HLBL(___L2_c_23_proper_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_proper_2d_length)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_length)
   ___GOTO(___L4_c_23_proper_2d_length)
___DEF_GLBL(___L3_c_23_proper_2d_length)
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_R1(___CDR(___R1))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_proper_2d_length)
___DEF_GLBL(___L4_c_23_proper_2d_length)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L3_c_23_proper_2d_length)
   ___END_IF
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L5_c_23_proper_2d_length)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5_c_23_proper_2d_length)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_definition_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 1775
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_definition_2d_name)
___DEF_P_HLBL(___L1_c_23_definition_2d_name)
___DEF_P_HLBL(___L2_c_23_definition_2d_name)
___DEF_P_HLBL(___L3_c_23_definition_2d_name)
___DEF_P_HLBL(___L4_c_23_definition_2d_name)
___DEF_P_HLBL(___L5_c_23_definition_2d_name)
___DEF_P_HLBL(___L6_c_23_definition_2d_name)
___DEF_P_HLBL(___L7_c_23_definition_2d_name)
___DEF_P_HLBL(___L8_c_23_definition_2d_name)
___DEF_P_HLBL(___L9_c_23_definition_2d_name)
___DEF_P_HLBL(___L10_c_23_definition_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_definition_2d_name)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_definition_2d_name)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_definition_2d_name)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_definition_2d_name)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-7,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_definition_2d_name)
   ___SET_R2(___CADR(___STK(-7)))
   ___SET_STK(-4,___R2)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___R2)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23_definition_2d_name)
   ___SET_STK(-8,___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(5,___L5_c_23_definition_2d_name)
   ___IF(___NOT(___EQP(___STK(-7),___GLO_c_23__2a__2a_define_2d_sym)))
   ___GOTO(___L11_c_23_definition_2d_name)
   ___END_IF
   ___IF(___NOT(___PAIRP(___STK(-8))))
   ___GOTO(___L21_c_23_definition_2d_name)
   ___END_IF
___DEF_GLBL(___L11_c_23_definition_2d_name)
   ___IF(___EQP(___STK(-7),___GLO_c_23__2a__2a_define_2d_syntax_2d_sym))
   ___GOTO(___L12_c_23_definition_2d_name)
   ___END_IF
   ___IF(___NOT(___EQP(___STK(-7),___GLO_c_23__2a__2a_define_2d_macro_2d_sym)))
   ___GOTO(___L19_c_23_definition_2d_name)
   ___END_IF
   ___IF(___PAIRP(___STK(-8)))
   ___GOTO(___L19_c_23_definition_2d_name)
   ___END_IF
___DEF_GLBL(___L12_c_23_definition_2d_name)
   ___IF(___NOT(___FIXEQ(___R1,___FIX(3L))))
   ___GOTO(___L20_c_23_definition_2d_name)
   ___END_IF
___DEF_GLBL(___L13_c_23_definition_2d_name)
   ___IF(___NOT(___EQP(___STK(-7),___GLO_c_23__2a__2a_define_2d_syntax_2d_sym)))
   ___GOTO(___L18_c_23_definition_2d_name)
   ___END_IF
___DEF_GLBL(___L14_c_23_definition_2d_name)
   ___SET_R1(___STK(-6))
___DEF_GLBL(___L15_c_23_definition_2d_name)
   ___SET_STK(-11,___R1)
   ___SET_STK(-9,___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(6,___L6_c_23_definition_2d_name)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___DEF_SLBL(7,___L7_c_23_definition_2d_name)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L17_c_23_definition_2d_name)
   ___END_IF
   ___GOTO(___L16_c_23_definition_2d_name)
___DEF_SLBL(8,___L8_c_23_definition_2d_name)
___DEF_GLBL(___L16_c_23_definition_2d_name)
   ___SET_R1(___STK(-5))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_definition_2d_name)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L17_c_23_definition_2d_name)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(57))
   ___SET_R0(___LBL(8))
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_SLBL(10,___L10_c_23_definition_2d_name)
   ___IF(___EQP(___STK(-7),___GLO_c_23__2a__2a_define_2d_syntax_2d_sym))
   ___GOTO(___L14_c_23_definition_2d_name)
   ___END_IF
___DEF_GLBL(___L18_c_23_definition_2d_name)
   ___IF(___NOT(___PAIRP(___STK(-8))))
   ___GOTO(___L14_c_23_definition_2d_name)
   ___END_IF
   ___SET_R1(___CAR(___STK(-8)))
   ___GOTO(___L15_c_23_definition_2d_name)
___DEF_GLBL(___L19_c_23_definition_2d_name)
   ___IF(___FIXGE(___R1,___FIX(3L)))
   ___GOTO(___L13_c_23_definition_2d_name)
   ___END_IF
___DEF_GLBL(___L20_c_23_definition_2d_name)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(1757),___L_c_23_ill_2d_formed_2d_special_2d_form)
___DEF_GLBL(___L21_c_23_definition_2d_name)
   ___IF(___FIXEQ(___R1,___FIX(2L)))
   ___GOTO(___L13_c_23_definition_2d_name)
   ___END_IF
   ___GOTO(___L12_c_23_definition_2d_name)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_definition_2d_value
#undef ___PH_LBL0
#define ___PH_LBL0 1787
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_definition_2d_value)
___DEF_P_HLBL(___L1_c_23_definition_2d_value)
___DEF_P_HLBL(___L2_c_23_definition_2d_value)
___DEF_P_HLBL(___L3_c_23_definition_2d_value)
___DEF_P_HLBL(___L4_c_23_definition_2d_value)
___DEF_P_HLBL(___L5_c_23_definition_2d_value)
___DEF_P_HLBL(___L6_c_23_definition_2d_value)
___DEF_P_HLBL(___L7_c_23_definition_2d_value)
___DEF_P_HLBL(___L8_c_23_definition_2d_value)
___DEF_P_HLBL(___L9_c_23_definition_2d_value)
___DEF_P_HLBL(___L10_c_23_definition_2d_value)
___DEF_P_HLBL(___L11_c_23_definition_2d_value)
___DEF_P_HLBL(___L12_c_23_definition_2d_value)
___DEF_P_HLBL(___L13_c_23_definition_2d_value)
___DEF_P_HLBL(___L14_c_23_definition_2d_value)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_definition_2d_value)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_definition_2d_value)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_definition_2d_value)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_definition_2d_value)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),244,___G__23__23_source_2d_locat)
___DEF_SLBL(3,___L3_c_23_definition_2d_value)
   ___SET_R2(___CADR(___STK(-7)))
   ___SET_STK(-5,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23_definition_2d_value)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L18_c_23_definition_2d_value)
   ___END_IF
   ___SET_R1(___CDDR(___STK(-7)))
   ___IF(___NULLP(___R1))
   ___GOTO(___L15_c_23_definition_2d_value)
   ___END_IF
   ___SET_R1(___CADDR(___STK(-7)))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_definition_2d_value)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L15_c_23_definition_2d_value)
   ___SET_STK(-7,___GLO_c_23__2a__2a_quote_2d_sym)
   ___SET_STK(-4,___STK(-5))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),242,___G__23__23_make_2d_source)
___DEF_SLBL(6,___L6_c_23_definition_2d_value)
   ___SET_STK(-7,___GLO_c_23_void_2d_object)
   ___SET_STK(-4,___STK(-5))
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),242,___G__23__23_make_2d_source)
___DEF_SLBL(7,___L7_c_23_definition_2d_value)
   ___BEGIN_ALLOC_LIST(2,___R1)
   ___ADD_LIST_ELEM(1,___STK(-3))
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-6))
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23_definition_2d_value)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_definition_2d_value)
   ___GOTO(___L17_c_23_definition_2d_value)
___DEF_SLBL(10,___L10_c_23_definition_2d_value)
___DEF_GLBL(___L16_c_23_definition_2d_value)
   ___SET_R2(___CDDR(___STK(-7)))
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-6))
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_definition_2d_value)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_definition_2d_value)
___DEF_GLBL(___L17_c_23_definition_2d_value)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),242,___G__23__23_make_2d_source)
___DEF_GLBL(___L18_c_23_definition_2d_value)
   ___SET_STK(-4,___GLO_c_23__2a__2a_lambda_2d_sym)
   ___SET_STK(-3,___STK(-5))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),242,___G__23__23_make_2d_source)
___DEF_SLBL(13,___L13_c_23_definition_2d_value)
   ___SET_R2(___CADR(___STK(-7)))
   ___SET_STK(-4,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(14,___L14_c_23_definition_2d_value)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(-3,___STK(-5))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L19_c_23_definition_2d_value)
   ___END_IF
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L16_c_23_definition_2d_value)
   ___END_IF
___DEF_GLBL(___L19_c_23_definition_2d_value)
   ___SET_R2(___STK(-3))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),242,___G__23__23_make_2d_source)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_parms_2d__3e_source
#undef ___PH_LBL0
#define ___PH_LBL0 1803
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_parms_2d__3e_source)
___DEF_P_HLBL(___L1_c_23_parms_2d__3e_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_parms_2d__3e_source)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_parms_2d__3e_source)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L2_c_23_parms_2d__3e_source)
   ___END_IF
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L3_c_23_parms_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L2_c_23_parms_2d__3e_source)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_parms_2d__3e_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),242,___G__23__23_make_2d_source)
___DEF_GLBL(___L3_c_23_parms_2d__3e_source)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_clauses_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1806
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L2_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L3_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L4_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L5_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L6_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L7_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L8_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L9_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L10_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L11_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L12_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L13_c_23_proper_2d_clauses_3f_)
___DEF_P_HLBL(___L14_c_23_proper_2d_clauses_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_clauses_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_proper_2d_clauses_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_clauses_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_proper_2d_clauses_3f_)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_proper_2d_clauses_3f_)
   ___GOTO(___L16_c_23_proper_2d_clauses_3f_)
___DEF_SLBL(4,___L4_c_23_proper_2d_clauses_3f_)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23__3d__3e__2d_sym)))
   ___GOTO(___L15_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___IF(___NOT(___FIXEQ(___STK(-3),___FIX(3L))))
   ___GOTO(___L17_c_23_proper_2d_clauses_3f_)
   ___END_IF
___DEF_GLBL(___L15_c_23_proper_2d_clauses_3f_)
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_proper_2d_clauses_3f_)
___DEF_GLBL(___L16_c_23_proper_2d_clauses_3f_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L23_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_proper_2d_clauses_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(7,___L7_c_23_proper_2d_clauses_3f_)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(8,___L8_c_23_proper_2d_clauses_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L19_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(58))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_proper_2d_clauses_3f_)
   ___GOTO(___L18_c_23_proper_2d_clauses_3f_)
___DEF_GLBL(___L17_c_23_proper_2d_clauses_3f_)
   ___SET_R1(___CADR(___STK(-7)))
   ___SET_R2(___SUB(59))
   ___SET_R0(___STK(-6))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_proper_2d_clauses_3f_)
___DEF_GLBL(___L18_c_23_proper_2d_clauses_3f_)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L19_c_23_proper_2d_clauses_3f_)
   ___IF(___FIXGE(___R1,___FIX(1L)))
   ___GOTO(___L20_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(60))
   ___SET_R0(___STK(-6))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_proper_2d_clauses_3f_)
   ___GOTO(___L18_c_23_proper_2d_clauses_3f_)
___DEF_GLBL(___L20_c_23_proper_2d_clauses_3f_)
   ___SET_R2(___CAR(___STK(-7)))
   ___SET_STK(-3,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(12,___L12_c_23_proper_2d_clauses_3f_)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23_else_2d_sym)))
   ___GOTO(___L22_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___IF(___NOT(___FIXEQ(___STK(-3),___FIX(1L))))
   ___GOTO(___L21_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(61))
   ___SET_R0(___STK(-6))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_proper_2d_clauses_3f_)
   ___GOTO(___L18_c_23_proper_2d_clauses_3f_)
___DEF_GLBL(___L21_c_23_proper_2d_clauses_3f_)
   ___SET_R1(___CDR(___STK(-5)))
   ___IF(___NULLP(___R1))
   ___GOTO(___L15_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(62))
   ___SET_R0(___STK(-6))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_proper_2d_clauses_3f_)
   ___GOTO(___L18_c_23_proper_2d_clauses_3f_)
___DEF_GLBL(___L22_c_23_proper_2d_clauses_3f_)
   ___IF(___NOT(___FIXGE(___STK(-3),___FIX(2L))))
   ___GOTO(___L15_c_23_proper_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___CADR(___STK(-7)))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_GLBL(___L23_c_23_proper_2d_clauses_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_case_2d_clauses_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1822
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L2_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L3_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L4_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L5_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L6_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L7_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L8_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L9_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L10_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L11_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L12_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_P_HLBL(___L13_c_23_proper_2d_case_2d_clauses_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_case_2d_clauses_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_case_2d_clauses_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_R1(___CDDR(___R1))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_proper_2d_case_2d_clauses_3f_)
   ___GOTO(___L14_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_SLBL(4,___L4_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_GLBL(___L14_c_23_proper_2d_case_2d_clauses_3f_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L20_c_23_proper_2d_case_2d_clauses_3f_)
   ___END_IF
   ___SET_R2(___CAR(___R1))
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_proper_2d_case_2d_clauses_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(7,___L7_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(8,___L8_c_23_proper_2d_case_2d_clauses_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L18_c_23_proper_2d_case_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(63))
   ___SET_R0(___STK(-6))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_proper_2d_case_2d_clauses_3f_)
   ___GOTO(___L15_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_SLBL(10,___L10_c_23_proper_2d_case_2d_clauses_3f_)
   ___IF(___NOT(___EQP(___R1,___GLO_c_23_else_2d_sym)))
   ___GOTO(___L16_c_23_proper_2d_case_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___CDR(___STK(-5)))
   ___IF(___NULLP(___R1))
   ___GOTO(___L17_c_23_proper_2d_case_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(64))
   ___SET_R0(___STK(-6))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_GLBL(___L15_c_23_proper_2d_case_2d_clauses_3f_)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L16_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_R1(___CAR(___STK(-7)))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(1837),___L_c_23_proper_2d_selector_2d_list_3f_)
___DEF_GLBL(___L17_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_R1(___CDR(___STK(-5)))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_proper_2d_case_2d_clauses_3f_)
   ___GOTO(___L14_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_GLBL(___L18_c_23_proper_2d_case_2d_clauses_3f_)
   ___IF(___FIXGE(___R1,___FIX(2L)))
   ___GOTO(___L19_c_23_proper_2d_case_2d_clauses_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(65))
   ___SET_R0(___STK(-6))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_proper_2d_case_2d_clauses_3f_)
   ___GOTO(___L15_c_23_proper_2d_case_2d_clauses_3f_)
___DEF_GLBL(___L19_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_R1(___CAR(___STK(-7)))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_GLBL(___L20_c_23_proper_2d_case_2d_clauses_3f_)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_selector_2d_list_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1837
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_selector_2d_list_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_selector_2d_list_3f_)
___DEF_P_HLBL(___L2_c_23_proper_2d_selector_2d_list_3f_)
___DEF_P_HLBL(___L3_c_23_proper_2d_selector_2d_list_3f_)
___DEF_P_HLBL(___L4_c_23_proper_2d_selector_2d_list_3f_)
___DEF_P_HLBL(___L5_c_23_proper_2d_selector_2d_list_3f_)
___DEF_P_HLBL(___L6_c_23_proper_2d_selector_2d_list_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_selector_2d_list_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_proper_2d_selector_2d_list_3f_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_selector_2d_list_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_proper_2d_selector_2d_list_3f_)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(3,___L3_c_23_proper_2d_selector_2d_list_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L7_c_23_proper_2d_selector_2d_list_3f_)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(66))
   ___SET_R0(___STK(-6))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_proper_2d_selector_2d_list_3f_)
   ___GOTO(___L8_c_23_proper_2d_selector_2d_list_3f_)
___DEF_GLBL(___L7_c_23_proper_2d_selector_2d_list_3f_)
   ___IF(___FIXGE(___R1,___FIX(1L)))
   ___GOTO(___L9_c_23_proper_2d_selector_2d_list_3f_)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(67))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_proper_2d_selector_2d_list_3f_)
___DEF_GLBL(___L8_c_23_proper_2d_selector_2d_list_3f_)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L9_c_23_proper_2d_selector_2d_list_3f_)
   ___SET_R1(___TRU)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_proper_2d_selector_2d_list_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_bindings_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1845
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L2_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L3_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L4_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L5_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L6_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L7_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L8_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L9_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L10_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L11_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L12_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L13_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L14_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L15_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L16_c_23_proper_2d_bindings_3f_)
___DEF_P_HLBL(___L17_c_23_proper_2d_bindings_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_bindings_3f_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_proper_2d_bindings_3f_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_bindings_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_proper_2d_bindings_3f_)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___NUL)
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_proper_2d_bindings_3f_)
   ___GOTO(___L18_c_23_proper_2d_bindings_3f_)
___DEF_SLBL(4,___L4_c_23_proper_2d_bindings_3f_)
   ___SET_R3(___CONS(___R1,___STK(-5)))
   ___SET_R2(___CDR(___STK(-6)))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___ADJFP(-10)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_proper_2d_bindings_3f_)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_proper_2d_bindings_3f_)
___DEF_GLBL(___L18_c_23_proper_2d_bindings_3f_)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L27_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___R4)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(8))
   ___ADJFP(10)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_proper_2d_bindings_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(8,___L8_c_23_proper_2d_bindings_3f_)
   ___SET_STK(-9,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(9,___L9_c_23_proper_2d_bindings_3f_)
   ___IF(___EQP(___R1,___FIX(2L)))
   ___GOTO(___L26_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___SUB(68))
   ___SET_R0(___STK(-8))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_proper_2d_bindings_3f_)
   ___GOTO(___L19_c_23_proper_2d_bindings_3f_)
___DEF_SLBL(11,___L11_c_23_proper_2d_bindings_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L20_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___STK(-9))
   ___SET_R2(___SUB(69))
   ___SET_R0(___STK(-8))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_proper_2d_bindings_3f_)
___DEF_GLBL(___L19_c_23_proper_2d_bindings_3f_)
   ___ADJFP(-12)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_SLBL(13,___L13_c_23_proper_2d_bindings_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L21_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(-10))))
   ___GOTO(___L22_c_23_proper_2d_bindings_3f_)
   ___END_IF
___DEF_GLBL(___L20_c_23_proper_2d_bindings_3f_)
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_GLBL(___L21_c_23_proper_2d_bindings_3f_)
   ___SET_R1(___STK(-9))
   ___SET_R2(___SUB(70))
   ___SET_R0(___STK(-8))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_proper_2d_bindings_3f_)
   ___GOTO(___L19_c_23_proper_2d_bindings_3f_)
___DEF_GLBL(___L22_c_23_proper_2d_bindings_3f_)
   ___SET_STK(-4,___STK(-9))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(15,___L15_c_23_proper_2d_bindings_3f_)
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(11))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L24_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___GOTO(___L25_c_23_proper_2d_bindings_3f_)
___DEF_GLBL(___L23_c_23_proper_2d_bindings_3f_)
   ___SET_R2(___CDR(___R2))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_proper_2d_bindings_3f_)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L25_c_23_proper_2d_bindings_3f_)
   ___END_IF
___DEF_GLBL(___L24_c_23_proper_2d_bindings_3f_)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___EQP(___R1,___R3)))
   ___GOTO(___L23_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L25_c_23_proper_2d_bindings_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L26_c_23_proper_2d_bindings_3f_)
   ___SET_R1(___CAR(___STK(-9)))
   ___SET_STK(-9,___R1)
   ___SET_R2(___STK(-7))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_GLBL(___L27_c_23_proper_2d_bindings_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L28_c_23_proper_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___STK(-1))
   ___SET_R2(___SUB(71))
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_proper_2d_bindings_3f_)
   ___ADJFP(-2)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L28_c_23_proper_2d_bindings_3f_)
   ___SET_R1(___TRU)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_do_2d_bindings_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1864
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L2_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L3_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L4_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L5_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L6_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L7_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L8_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L9_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L10_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L11_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L12_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L13_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L14_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L15_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L16_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L17_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_P_HLBL(___L18_c_23_proper_2d_do_2d_bindings_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_do_2d_bindings_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R1(___CADR(___R1))
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___R1)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___NUL)
   ___SET_R0(___STK(-5))
   ___ADJFP(-7)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_proper_2d_do_2d_bindings_3f_)
   ___GOTO(___L19_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_SLBL(5,___L5_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R3(___CONS(___R1,___STK(-6)))
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-11)
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23_proper_2d_do_2d_bindings_3f_)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_GLBL(___L19_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L27_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___R4)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(9))
   ___ADJFP(11)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_proper_2d_do_2d_bindings_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(9,___L9_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_STK(-10,___R1)
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(10,___L10_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF(___EQP(___R1,___FIX(2L)))
   ___GOTO(___L22_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___IF(___EQP(___R1,___FIX(3L)))
   ___GOTO(___L22_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(72))
   ___SET_R0(___STK(-9))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_proper_2d_do_2d_bindings_3f_)
   ___GOTO(___L20_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_SLBL(12,___L12_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L21_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___STK(-10))
   ___SET_R2(___SUB(73))
   ___SET_R0(___STK(-9))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_GLBL(___L20_c_23_proper_2d_do_2d_bindings_3f_)
   ___ADJFP(-12)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L21_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_GLBL(___L22_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R1(___CAR(___STK(-10)))
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-11))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(2),___PRC(1610),___L_c_23_bindable_2d_var_3f_)
___DEF_SLBL(14,___L14_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L23_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___STK(-10))
   ___SET_R2(___SUB(74))
   ___SET_R0(___STK(-9))
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_proper_2d_do_2d_bindings_3f_)
   ___GOTO(___L20_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_GLBL(___L23_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_STK(-5,___STK(-10))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(16,___L16_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(12))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L25_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___GOTO(___L26_c_23_proper_2d_do_2d_bindings_3f_)
___DEF_GLBL(___L24_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R2(___CDR(___R2))
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L26_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
___DEF_GLBL(___L25_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___EQP(___R1,___R3)))
   ___GOTO(___L24_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L26_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L27_c_23_proper_2d_do_2d_bindings_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L28_c_23_proper_2d_do_2d_bindings_3f_)
   ___END_IF
   ___SET_R2(___SUB(75))
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_proper_2d_do_2d_bindings_3f_)
   ___ADJFP(-1)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L28_c_23_proper_2d_do_2d_bindings_3f_)
   ___SET_R1(___TRU)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_proper_2d_do_2d_exit_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1884
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_proper_2d_do_2d_exit_3f_)
___DEF_P_HLBL(___L1_c_23_proper_2d_do_2d_exit_3f_)
___DEF_P_HLBL(___L2_c_23_proper_2d_do_2d_exit_3f_)
___DEF_P_HLBL(___L3_c_23_proper_2d_do_2d_exit_3f_)
___DEF_P_HLBL(___L4_c_23_proper_2d_do_2d_exit_3f_)
___DEF_P_HLBL(___L5_c_23_proper_2d_do_2d_exit_3f_)
___DEF_P_HLBL(___L6_c_23_proper_2d_do_2d_exit_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_proper_2d_do_2d_exit_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_proper_2d_do_2d_exit_3f_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_proper_2d_do_2d_exit_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_proper_2d_do_2d_exit_3f_)
   ___SET_R1(___CADDR(___R1))
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R1)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_proper_2d_do_2d_exit_3f_)
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(4,___L4_c_23_proper_2d_do_2d_exit_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L7_c_23_proper_2d_do_2d_exit_3f_)
   ___END_IF
   ___IF(___FIXGT(___R1,___FIX(0L)))
   ___GOTO(___L8_c_23_proper_2d_do_2d_exit_3f_)
   ___END_IF
___DEF_GLBL(___L7_c_23_proper_2d_do_2d_exit_3f_)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(76))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_proper_2d_do_2d_exit_3f_)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L8_c_23_proper_2d_do_2d_exit_3f_)
   ___SET_R1(___TRU)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_proper_2d_do_2d_exit_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_begin_2d_body
#undef ___PH_LBL0
#define ___PH_LBL0 1892
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_begin_2d_body)
___DEF_P_HLBL(___L1_c_23_begin_2d_body)
___DEF_P_HLBL(___L2_c_23_begin_2d_body)
___DEF_P_HLBL(___L3_c_23_begin_2d_body)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_begin_2d_body)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_begin_2d_body)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_begin_2d_body)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_begin_2d_body)
   ___SET_R1(___CDR(___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_begin_2d_body)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_length_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 1897
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_length_3f_)
___DEF_P_HLBL(___L1_c_23_length_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_length_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_length_3f_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L4_c_23_length_3f_)
   ___END_IF
   ___GOTO(___L3_c_23_length_3f_)
___DEF_GLBL(___L2_c_23_length_3f_)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R1(___CDR(___R1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_length_3f_)
   ___IF(___NULLP(___R1))
   ___GOTO(___L4_c_23_length_3f_)
   ___END_IF
___DEF_GLBL(___L3_c_23_length_3f_)
   ___IF(___FIXGT(___R2,___FIX(0L)))
   ___GOTO(___L2_c_23_length_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L4_c_23_length_3f_)
   ___SET_R1(___BOOLEAN(___FIXEQ(___R2,___FIX(0L))))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_transform_2d_declaration
#undef ___PH_LBL0
#define ___PH_LBL0 1900
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L1_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L2_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L3_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L4_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L5_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L6_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L7_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L8_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L9_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L10_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L11_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L12_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L13_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L14_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L15_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L16_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L17_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L18_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L19_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L20_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L21_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L22_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L23_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L24_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L25_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L26_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L27_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L28_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L29_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L30_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L31_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L32_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L33_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L34_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L35_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L36_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L37_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L38_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L39_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L40_c_23_transform_2d_declaration)
___DEF_P_HLBL(___L41_c_23_transform_2d_declaration)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_transform_2d_declaration)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_transform_2d_declaration)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_transform_2d_declaration)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_transform_2d_declaration)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L48_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(77))
   ___SET_R0(___STK(-6))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_transform_2d_declaration)
   ___GOTO(___L43_c_23_transform_2d_declaration)
___DEF_SLBL(4,___L4_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L44_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L42_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(78))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_transform_2d_declaration)
___DEF_GLBL(___L43_c_23_transform_2d_declaration)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L44_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-4))
   ___GOTO(___L45_c_23_transform_2d_declaration)
___DEF_SLBL(6,___L6_c_23_transform_2d_declaration)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L42_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L46_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L45_c_23_transform_2d_declaration)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_transform_2d_declaration)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),368,___G_c_23_parameterized_2d_decl)
___DEF_SLBL(8,___L8_c_23_transform_2d_declaration)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L47_c_23_transform_2d_declaration)
   ___END_IF
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L45_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L46_c_23_transform_2d_declaration)
   ___IF(___FLONUMP(___R1))
   ___GOTO(___L42_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(1),___PRM_exact_3f_)
___DEF_GLBL(___L47_c_23_transform_2d_declaration)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(6))
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_integer_3f_)
___DEF_GLBL(___L48_c_23_transform_2d_declaration)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-7,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(9,___L9_c_23_transform_2d_declaration)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___GLO_c_23_not_2d_sym)))
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L49_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R2(___CDR(___STK(-7)))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L51_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L50_c_23_transform_2d_declaration)
___DEF_GLBL(___L49_c_23_transform_2d_declaration)
   ___SET_R2(___STK(-7))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L51_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L50_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(79))
   ___SET_R0(___STK(-6))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_transform_2d_declaration)
   ___GOTO(___L43_c_23_transform_2d_declaration)
___DEF_GLBL(___L51_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(-7,___R3)
   ___SET_STK(-4,___R1)
   ___SET_STK(-3,___R2)
   ___SET_STK(-2,___R3)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(11))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(11,___L11_c_23_transform_2d_declaration)
   ___SET_STK(-11,___R1)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___DEF_SLBL(12,___L12_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L54_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(80))
   ___SET_R0(___STK(-10))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_transform_2d_declaration)
   ___GOTO(___L52_c_23_transform_2d_declaration)
___DEF_SLBL(14,___L14_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L53_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(81))
   ___SET_R0(___STK(-10))
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23_transform_2d_declaration)
___DEF_GLBL(___L52_c_23_transform_2d_declaration)
   ___ADJFP(-12)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L53_c_23_transform_2d_declaration)
   ___SET_STK(-6,___STK(-11))
   ___SET_STK(-11,___STK(-9))
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(2),___PRC(1943),___L_c_23_extract_2d_names)
___DEF_SLBL(16,___L16_c_23_transform_2d_declaration)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-10))
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_transform_2d_declaration)
   ___ADJFP(-11)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),359,___G_c_23_namable_2d_boolean_2d_decl)
___DEF_GLBL(___L54_c_23_transform_2d_declaration)
   ___SET_STK(-5,___GLO_c_23_flag_2d_declarations)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(26))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L56_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L59_c_23_transform_2d_declaration)
___DEF_GLBL(___L55_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R2))
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_transform_2d_declaration)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L56_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___NOT(___EQP(___R1,___R4)))
   ___GOTO(___L55_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L57_c_23_transform_2d_declaration)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(19,___L19_c_23_transform_2d_declaration)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L60_c_23_transform_2d_declaration)
   ___END_IF
   ___IF(___FALSEP(___STK(-8)))
   ___GOTO(___L64_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_STK(-8,___STK(-11))
   ___SET_STK(-11,___STK(-9))
   ___SET_STK(-6,___GLO_c_23_namable_2d_declarations)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(23))
   ___ADJFP(-4)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L58_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L57_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_transform_2d_declaration)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L58_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L59_c_23_transform_2d_declaration)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L60_c_23_transform_2d_declaration)
   ___SET_STK(-5,___GLO_c_23_namable_2d_boolean_2d_declarations)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(14))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L62_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L59_c_23_transform_2d_declaration)
___DEF_GLBL(___L61_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R2))
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_transform_2d_declaration)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L62_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___EQP(___R1,___R3)))
   ___GOTO(___L61_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L63_c_23_transform_2d_declaration)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L64_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(82))
   ___SET_R0(___STK(-10))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_transform_2d_declaration)
   ___GOTO(___L52_c_23_transform_2d_declaration)
___DEF_SLBL(23,___L23_c_23_transform_2d_declaration)
   ___SET_R1(___CDR(___R1))
   ___SET_STK(-2,___R1)
   ___SET_R2(___CDR(___STK(-3)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(24))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(2),___PRC(1943),___L_c_23_extract_2d_names)
___DEF_SLBL(24,___L24_c_23_transform_2d_declaration)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-8))
   ___SET_R0(___STK(-10))
   ___SET_R1(___STK(-6))
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_transform_2d_declaration)
   ___ADJFP(-11)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),361,___G_c_23_namable_2d_decl)
___DEF_SLBL(26,___L26_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L76_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_STK(-5,___GLO_c_23_parameterized_2d_declarations)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(28))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L66_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L59_c_23_transform_2d_declaration)
___DEF_GLBL(___L65_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R2))
   ___POLL(27)
___DEF_SLBL(27,___L27_c_23_transform_2d_declaration)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L66_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L63_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L65_c_23_transform_2d_declaration)
___DEF_SLBL(28,___L28_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L73_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_STK(-5,___GLO_c_23_boolean_2d_declarations)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(30))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L68_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L59_c_23_transform_2d_declaration)
___DEF_GLBL(___L67_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R2))
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23_transform_2d_declaration)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L68_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L63_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L67_c_23_transform_2d_declaration)
___DEF_SLBL(30,___L30_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L71_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_STK(-5,___GLO_c_23_namable_2d_declarations)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(19))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L70_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L59_c_23_transform_2d_declaration)
___DEF_GLBL(___L69_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R2))
   ___POLL(31)
___DEF_SLBL(31,___L31_c_23_transform_2d_declaration)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L70_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L57_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L69_c_23_transform_2d_declaration)
___DEF_GLBL(___L71_c_23_transform_2d_declaration)
   ___SET_R1(___CDR(___STK(-7)))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L72_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-11))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_transform_2d_declaration)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),291,___G_c_23_boolean_2d_decl)
___DEF_GLBL(___L72_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-9))
   ___SET_R2(___SUB(83))
   ___SET_R0(___STK(-10))
   ___POLL(33)
___DEF_SLBL(33,___L33_c_23_transform_2d_declaration)
   ___GOTO(___L52_c_23_transform_2d_declaration)
___DEF_GLBL(___L73_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___STK(-8))))
   ___GOTO(___L74_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(84))
   ___SET_R0(___STK(-10))
   ___POLL(34)
___DEF_SLBL(34,___L34_c_23_transform_2d_declaration)
   ___GOTO(___L52_c_23_transform_2d_declaration)
___DEF_GLBL(___L74_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(35))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(1771),___L_c_23_proper_2d_length)
___DEF_SLBL(35,___L35_c_23_transform_2d_declaration)
   ___IF(___EQP(___R1,___FIX(2L)))
   ___GOTO(___L75_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(85))
   ___SET_R0(___STK(-6))
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_transform_2d_declaration)
   ___GOTO(___L43_c_23_transform_2d_declaration)
___DEF_GLBL(___L75_c_23_transform_2d_declaration)
   ___SET_R1(___CADR(___STK(-3)))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___DEF_GLBL(___L76_c_23_transform_2d_declaration)
   ___IF(___NOT(___FALSEP(___STK(-8))))
   ___GOTO(___L77_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(86))
   ___SET_R0(___STK(-10))
   ___POLL(37)
___DEF_SLBL(37,___L37_c_23_transform_2d_declaration)
   ___GOTO(___L52_c_23_transform_2d_declaration)
___DEF_GLBL(___L77_c_23_transform_2d_declaration)
   ___SET_R1(___CDR(___STK(-7)))
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L80_c_23_transform_2d_declaration)
   ___END_IF
   ___SET_STK(-8,___GLO_c_23_flag_2d_declarations)
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(39))
   ___ADJFP(-4)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L79_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L59_c_23_transform_2d_declaration)
___DEF_GLBL(___L78_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R2))
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_transform_2d_declaration)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L59_c_23_transform_2d_declaration)
   ___END_IF
___DEF_GLBL(___L79_c_23_transform_2d_declaration)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L57_c_23_transform_2d_declaration)
   ___END_IF
   ___GOTO(___L78_c_23_transform_2d_declaration)
___DEF_SLBL(39,___L39_c_23_transform_2d_declaration)
   ___SET_R2(___CDR(___R1))
   ___SET_R3(___STK(-7))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(40)
___DEF_SLBL(40,___L40_c_23_transform_2d_declaration)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),340,___G_c_23_flag_2d_decl)
___DEF_GLBL(___L80_c_23_transform_2d_declaration)
   ___SET_R1(___STK(-9))
   ___SET_R2(___SUB(87))
   ___SET_R0(___STK(-10))
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23_transform_2d_declaration)
   ___GOTO(___L52_c_23_transform_2d_declaration)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_extract_2d_names
#undef ___PH_LBL0
#define ___PH_LBL0 1943
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_extract_2d_names)
___DEF_P_HLBL(___L1_c_23_extract_2d_names)
___DEF_P_HLBL(___L2_c_23_extract_2d_names)
___DEF_P_HLBL(___L3_c_23_extract_2d_names)
___DEF_P_HLBL(___L4_c_23_extract_2d_names)
___DEF_P_HLBL(___L5_c_23_extract_2d_names)
___DEF_P_HLBL(___L6_c_23_extract_2d_names)
___DEF_P_HLBL(___L7_c_23_extract_2d_names)
___DEF_P_HLBL(___L8_c_23_extract_2d_names)
___DEF_P_HLBL(___L9_c_23_extract_2d_names)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_extract_2d_names)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_extract_2d_names)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_extract_2d_names)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L10_c_23_extract_2d_names)
   ___END_IF
   ___GOTO(___L12_c_23_extract_2d_names)
___DEF_SLBL(2,___L2_c_23_extract_2d_names)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_c_23_extract_2d_names)
   ___END_IF
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L12_c_23_extract_2d_names)
   ___END_IF
___DEF_GLBL(___L10_c_23_extract_2d_names)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_extract_2d_names)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(4,___L4_c_23_extract_2d_names)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___DEF_GLBL(___L11_c_23_extract_2d_names)
   ___SET_R1(___STK(-3))
   ___SET_R2(___SUB(88))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_extract_2d_names)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L12_c_23_extract_2d_names)
   ___IF(___NULLP(___R2))
   ___GOTO(___L13_c_23_extract_2d_names)
   ___END_IF
   ___SET_R2(___SUB(89))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_extract_2d_names)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L13_c_23_extract_2d_names)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(7,___L7_c_23_extract_2d_names)
   ___SET_R1(___CONS(___STK(-7),___R1))
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23_extract_2d_names)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_extract_2d_names)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_declarations
#undef ___PH_LBL0
#define ___PH_LBL0 1954
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_declarations)
___DEF_P_HLBL(___L1_c_23_add_2d_declarations)
___DEF_P_HLBL(___L2_c_23_add_2d_declarations)
___DEF_P_HLBL(___L3_c_23_add_2d_declarations)
___DEF_P_HLBL(___L4_c_23_add_2d_declarations)
___DEF_P_HLBL(___L5_c_23_add_2d_declarations)
___DEF_P_HLBL(___L6_c_23_add_2d_declarations)
___DEF_P_HLBL(___L7_c_23_add_2d_declarations)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_declarations)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_add_2d_declarations)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_add_2d_declarations)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_add_2d_declarations)
   ___SET_R1(___CDR(___R1))
   ___SET_R2(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_add_2d_declarations)
   ___GOTO(___L8_c_23_add_2d_declarations)
___DEF_SLBL(4,___L4_c_23_add_2d_declarations)
   ___SET_R2(___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_add_2d_declarations)
___DEF_GLBL(___L8_c_23_add_2d_declarations)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L9_c_23_add_2d_declarations)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_add_2d_declarations)
   ___JUMPINT(___SET_NARGS(1),___PRC(1900),___L_c_23_transform_2d_declaration)
___DEF_SLBL(7,___L7_c_23_add_2d_declarations)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),326,___G_c_23_env_2d_declare)
___DEF_GLBL(___L9_c_23_add_2d_declarations)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_namespace
#undef ___PH_LBL0
#define ___PH_LBL0 1963
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_namespace)
___DEF_P_HLBL(___L1_c_23_add_2d_namespace)
___DEF_P_HLBL(___L2_c_23_add_2d_namespace)
___DEF_P_HLBL(___L3_c_23_add_2d_namespace)
___DEF_P_HLBL(___L4_c_23_add_2d_namespace)
___DEF_P_HLBL(___L5_c_23_add_2d_namespace)
___DEF_P_HLBL(___L6_c_23_add_2d_namespace)
___DEF_P_HLBL(___L7_c_23_add_2d_namespace)
___DEF_P_HLBL(___L8_c_23_add_2d_namespace)
___DEF_P_HLBL(___L9_c_23_add_2d_namespace)
___DEF_P_HLBL(___L10_c_23_add_2d_namespace)
___DEF_P_HLBL(___L11_c_23_add_2d_namespace)
___DEF_P_HLBL(___L12_c_23_add_2d_namespace)
___DEF_P_HLBL(___L13_c_23_add_2d_namespace)
___DEF_P_HLBL(___L14_c_23_add_2d_namespace)
___DEF_P_HLBL(___L15_c_23_add_2d_namespace)
___DEF_P_HLBL(___L16_c_23_add_2d_namespace)
___DEF_P_HLBL(___L17_c_23_add_2d_namespace)
___DEF_P_HLBL(___L18_c_23_add_2d_namespace)
___DEF_P_HLBL(___L19_c_23_add_2d_namespace)
___DEF_P_HLBL(___L20_c_23_add_2d_namespace)
___DEF_P_HLBL(___L21_c_23_add_2d_namespace)
___DEF_P_HLBL(___L22_c_23_add_2d_namespace)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_namespace)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_add_2d_namespace)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_add_2d_namespace)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_add_2d_namespace)
   ___SET_R1(___CDR(___R1))
   ___SET_R3(___STK(-4))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_add_2d_namespace)
   ___GOTO(___L23_c_23_add_2d_namespace)
___DEF_SLBL(4,___L4_c_23_add_2d_namespace)
   ___SET_R3(___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_add_2d_namespace)
___DEF_GLBL(___L23_c_23_add_2d_namespace)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L33_c_23_add_2d_namespace)
   ___END_IF
   ___SET_R4(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R4)
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_add_2d_namespace)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(7,___L7_c_23_add_2d_namespace)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L32_c_23_add_2d_namespace)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(90))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_add_2d_namespace)
   ___GOTO(___L24_c_23_add_2d_namespace)
___DEF_SLBL(9,___L9_c_23_add_2d_namespace)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L25_c_23_add_2d_namespace)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R2(___SUB(91))
   ___SET_R0(___STK(-6))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_add_2d_namespace)
___DEF_GLBL(___L24_c_23_add_2d_namespace)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L25_c_23_add_2d_namespace)
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(20))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L26_c_23_add_2d_namespace)
   ___END_IF
   ___GOTO(___L30_c_23_add_2d_namespace)
___DEF_SLBL(11,___L11_c_23_add_2d_namespace)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L27_c_23_add_2d_namespace)
   ___END_IF
   ___SET_R2(___CDR(___STK(-6)))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(18))
   ___ADJFP(-4)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L30_c_23_add_2d_namespace)
   ___END_IF
___DEF_GLBL(___L26_c_23_add_2d_namespace)
   ___SET_R3(___CAR(___R2))
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(13))
   ___ADJFP(8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_add_2d_namespace)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(13,___L13_c_23_add_2d_namespace)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),393,___G_c_23_symbol_2d_object_3f_)
___DEF_GLBL(___L27_c_23_add_2d_namespace)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(92))
   ___SET_R0(___STK(-11))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_add_2d_namespace)
   ___GOTO(___L28_c_23_add_2d_namespace)
___DEF_SLBL(15,___L15_c_23_add_2d_namespace)
   ___IF(___STRINGP(___R1))
   ___GOTO(___L29_c_23_add_2d_namespace)
   ___END_IF
   ___SET_R1(___STK(-10))
   ___SET_R2(___SUB(93))
   ___SET_R0(___STK(-11))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_add_2d_namespace)
___DEF_GLBL(___L28_c_23_add_2d_namespace)
   ___ADJFP(-12)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L29_c_23_add_2d_namespace)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),401,___G_c_23_valid_2d_prefix_3f_)
___DEF_GLBL(___L30_c_23_add_2d_namespace)
   ___IF(___NULLP(___R2))
   ___GOTO(___L31_c_23_add_2d_namespace)
   ___END_IF
   ___SET_R2(___SUB(94))
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_add_2d_namespace)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L31_c_23_add_2d_namespace)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(18,___L18_c_23_add_2d_namespace)
   ___SET_R2(___CONS(___STK(-3),___R1))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___CHECK_HEAP(19,4096)
___DEF_SLBL(19,___L19_c_23_add_2d_namespace)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),334,___G_c_23_env_2d_namespace)
___DEF_SLBL(20,___L20_c_23_add_2d_namespace)
   ___SET_R1(___CONS(___STK(-7),___R1))
   ___CHECK_HEAP(21,4096)
___DEF_SLBL(21,___L21_c_23_add_2d_namespace)
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_add_2d_namespace)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L32_c_23_add_2d_namespace)
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-3,___R2)
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R2)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(15))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_GLBL(___L33_c_23_add_2d_namespace)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_add_2d_macro
#undef ___PH_LBL0
#define ___PH_LBL0 1987
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_add_2d_macro)
___DEF_P_HLBL(___L1_c_23_add_2d_macro)
___DEF_P_HLBL(___L2_c_23_add_2d_macro)
___DEF_P_HLBL(___L3_c_23_add_2d_macro)
___DEF_P_HLBL(___L4_c_23_add_2d_macro)
___DEF_P_HLBL(___L5_c_23_add_2d_macro)
___DEF_P_HLBL(___L6_c_23_add_2d_macro)
___DEF_P_HLBL(___L7_c_23_add_2d_macro)
___DEF_P_HLBL(___L8_c_23_add_2d_macro)
___DEF_P_HLBL(___L9_c_23_add_2d_macro)
___DEF_P_HLBL(___L10_c_23_add_2d_macro)
___DEF_P_HLBL(___L11_c_23_add_2d_macro)
___DEF_P_HLBL(___L12_c_23_add_2d_macro)
___DEF_P_HLBL(___L13_c_23_add_2d_macro)
___DEF_P_HLBL(___L14_c_23_add_2d_macro)
___DEF_P_HLBL(___L15_c_23_add_2d_macro)
___DEF_P_HLBL(___L16_c_23_add_2d_macro)
___DEF_P_HLBL(___L17_c_23_add_2d_macro)
___DEF_P_HLBL(___L18_c_23_add_2d_macro)
___DEF_P_HLBL(___L19_c_23_add_2d_macro)
___DEF_P_HLBL(___L20_c_23_add_2d_macro)
___DEF_P_HLBL(___L21_c_23_add_2d_macro)
___DEF_P_HLBL(___L22_c_23_add_2d_macro)
___DEF_P_HLBL(___L23_c_23_add_2d_macro)
___DEF_P_HLBL(___L24_c_23_add_2d_macro)
___DEF_P_HLBL(___L25_c_23_add_2d_macro)
___DEF_P_HLBL(___L26_c_23_add_2d_macro)
___DEF_P_HLBL(___L27_c_23_add_2d_macro)
___DEF_P_HLBL(___L28_c_23_add_2d_macro)
___DEF_P_HLBL(___L29_c_23_add_2d_macro)
___DEF_P_HLBL(___L30_c_23_add_2d_macro)
___DEF_P_HLBL(___L31_c_23_add_2d_macro)
___DEF_P_HLBL(___L32_c_23_add_2d_macro)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_add_2d_macro)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_add_2d_macro)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R3(___STK(1))
   ___SET_R2(___FIX(3L))
   ___SET_R1(___GLO_c_23__2a__2a_define_2d_syntax_2d_sym)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_add_2d_macro)
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(2,___L2_c_23_add_2d_macro)
   ___SET_STK(-3,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-3),28)
   ___ADD_CLO_ELEM(0,___STK(-5))
   ___END_SETUP_CLO(1)
   ___SET_STK(-7,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23_add_2d_macro)
   ___JUMPINT(___SET_NARGS(2),___PRC(1775),___L_c_23_definition_2d_name)
___DEF_SLBL(4,___L4_c_23_add_2d_macro)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(1),___PRC(1787),___L_c_23_definition_2d_value)
___DEF_SLBL(5,___L5_c_23_add_2d_macro)
   ___IF(___FALSEP(___STK(-11)))
   ___GOTO(___L44_c_23_add_2d_macro)
   ___END_IF
   ___SET_STK(-9,___STK(-11))
   ___SET_STK(-11,___STK(-8))
   ___SET_STK(-8,___STK(-10))
   ___SET_STK(-10,___STK(-9))
   ___SET_STK(-9,___STK(-7))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(-1L))
   ___SET_R0(___STK(-8))
   ___ADJFP(-9)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_add_2d_macro)
   ___GOTO(___L33_c_23_add_2d_macro)
___DEF_SLBL(7,___L7_c_23_add_2d_macro)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-8))
   ___ADJFP(-9)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_add_2d_macro)
___DEF_GLBL(___L33_c_23_add_2d_macro)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(10))
   ___ADJFP(9)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_add_2d_macro)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),389,___G_c_23_source_2d__3e_expression)
___DEF_SLBL(10,___L10_c_23_add_2d_macro)
   ___SET_R2(___STK(-9))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),387,___G_c_23_scheme_2d_global_2d_eval)
___DEF_SLBL(11,___L11_c_23_add_2d_macro)
   ___IF(___PROCEDUREP(___R1))
   ___GOTO(___L43_c_23_add_2d_macro)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(95))
   ___SET_R0(___STK(-8))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_add_2d_macro)
   ___GOTO(___L34_c_23_add_2d_macro)
___DEF_SLBL(13,___L13_c_23_add_2d_macro)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L35_c_23_add_2d_macro)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(96))
   ___SET_R0(___STK(-10))
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23_add_2d_macro)
___DEF_GLBL(___L34_c_23_add_2d_macro)
   ___ADJFP(-12)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(750),___L0_c_23_pt_2d_syntax_2d_error)
___DEF_SLBL(15,___L15_c_23_add_2d_macro)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L42_c_23_add_2d_macro)
   ___END_IF
___DEF_GLBL(___L35_c_23_add_2d_macro)
   ___SET_STK(-9,___STK(-11))
   ___SET_STK(-11,___STK(-8))
   ___SET_STK(-8,___STK(-10))
   ___SET_STK(-10,___STK(-9))
   ___SET_STK(-9,___STK(-7))
   ___SET_STK(-7,___STK(-5))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(16,___L16_c_23_add_2d_macro)
   ___SET_R1(___CADR(___R1))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(1),___PRC(1148),___L_c_23_source_2d__3e_parms)
___DEF_SLBL(17,___L17_c_23_add_2d_macro)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(7))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L36_c_23_add_2d_macro)
   ___END_IF
   ___GOTO(___L40_c_23_add_2d_macro)
___DEF_SLBL(18,___L18_c_23_add_2d_macro)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L37_c_23_add_2d_macro)
   ___END_IF
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23_add_2d_macro)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L40_c_23_add_2d_macro)
   ___END_IF
___DEF_GLBL(___L36_c_23_add_2d_macro)
   ___SET_R3(___CAR(___R1))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(21))
   ___ADJFP(8)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_add_2d_macro)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(21,___L21_c_23_add_2d_macro)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),366,___G_c_23_optional_2d_object_3f_)
___DEF_SLBL(22,___L22_c_23_add_2d_macro)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L39_c_23_add_2d_macro)
   ___END_IF
   ___GOTO(___L37_c_23_add_2d_macro)
___DEF_SLBL(23,___L23_c_23_add_2d_macro)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L38_c_23_add_2d_macro)
   ___END_IF
___DEF_GLBL(___L37_c_23_add_2d_macro)
   ___SET_R1(___FIXNEG(___STK(-5)))
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_add_2d_macro)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L38_c_23_add_2d_macro)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),384,___G_c_23_rest_2d_object_3f_)
___DEF_GLBL(___L39_c_23_add_2d_macro)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),350,___G_c_23_key_2d_object_3f_)
___DEF_GLBL(___L40_c_23_add_2d_macro)
   ___IF(___NOT(___NULLP(___R1)))
   ___GOTO(___L41_c_23_add_2d_macro)
   ___END_IF
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L41_c_23_add_2d_macro)
   ___SET_R1(___FIXNEG(___R2))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L42_c_23_add_2d_macro)
   ___SET_STK(-9,___STK(-5))
   ___SET_R3(___STK(-9))
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23_lambda_2d_sym)
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_GLBL(___L43_c_23_add_2d_macro)
   ___SET_STK(-9,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(25))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),243,___G__23__23_source_2d_code)
___DEF_SLBL(25,___L25_c_23_add_2d_macro)
   ___SET_STK(-7,___R1)
   ___SET_STK(-3,___STK(-10))
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(26))
   ___ADJFP(-3)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),241,___G__23__23_make_2d_macro_2d_descr)
___DEF_SLBL(26,___L26_c_23_add_2d_macro)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-4))
   ___SET_R2(___STK(-3))
   ___POLL(27)
___DEF_SLBL(27,___L27_c_23_add_2d_macro)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),333,___G_c_23_env_2d_macro)
___DEF_GLBL(___L44_c_23_add_2d_macro)
   ___SET_STK(-9,___R1)
   ___SET_STK(-5,___R1)
   ___SET_R3(___STK(-9))
   ___SET_R2(___FIX(-3L))
   ___SET_R1(___GLO_c_23__2a__2a_lambda_2d_sym)
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(3),___PRC(1748),___L_c_23_match)
___DEF_SLBL(28,___L28_c_23_add_2d_macro)
   ___IF_NARGS_EQ(0,___SET_R1(___NUL))
   ___GET_REST(28,0,0,0)
   ___SET_STK(1,___CLO(___R4,1))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(30))
   ___ADJFP(8)
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23_add_2d_macro)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),244,___G__23__23_source_2d_locat)
___DEF_SLBL(30,___L30_c_23_add_2d_macro)
   ___SET_R2(___CONS(___SUB(97),___STK(-5)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R1(___GLO_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___STK(-6))
   ___CHECK_HEAP(31,4096)
___DEF_SLBL(31,___L31_c_23_add_2d_macro)
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_add_2d_macro)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_apply)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptree_2e_begin_21_
#undef ___PH_LBL0
#define ___PH_LBL0 2021
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptree_2e_begin_21_)
___DEF_P_HLBL(___L1_c_23_ptree_2e_begin_21_)
___DEF_P_HLBL(___L2_c_23_ptree_2e_begin_21_)
___DEF_P_HLBL(___L3_c_23_ptree_2e_begin_21_)
___DEF_P_HLBL(___L4_c_23_ptree_2e_begin_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptree_2e_begin_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ptree_2e_begin_21_)
   ___SET_GLO(24,___G_c_23__2a_ptree_2d_port_2a_,___R1)
   ___SET_STK(1,___R0)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ptree_2e_begin_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),356,___G_c_23_make_2d_counter)
___DEF_SLBL(2,___L2_c_23_ptree_2e_begin_21_)
   ___SET_GLO(127,___G_c_23_next_2d_node_2d_stamp,___R1)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),356,___G_c_23_make_2d_counter)
___DEF_SLBL(3,___L3_c_23_ptree_2e_begin_21_)
   ___SET_GLO(225,___G_c_23_temp_2d_variable_2d_stamp,___R1)
   ___SET_R1(___NUL)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_ptree_2e_begin_21_)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ptree_2e_end_21_
#undef ___PH_LBL0
#define ___PH_LBL0 2027
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ptree_2e_end_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ptree_2e_end_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_ptree_2e_end_21_)
   ___SET_GLO(127,___G_c_23_next_2d_node_2d_stamp,___FAL)
   ___SET_GLO(225,___G_c_23_temp_2d_variable_2d_stamp,___FAL)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___ptree1," _ptree1",___REF_FAL,30,0)
,___DEF_LBL_PROC(___H__20___ptree1,0,0)
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___ptree1,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_node_2d_parent,"c#node-parent",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_parent,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_children,"c#node-children",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_children,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_fv,"c#node-fv",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_fv,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_bfv,"c#node-bfv",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_bfv,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_env,"c#node-env",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_env,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_source,"c#node-source",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_source,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_stamp,"c#node-stamp",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_stamp,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_parent_2d_set_21_,"c#node-parent-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_parent_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_fv_2d_set_21_,"c#node-fv-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_fv_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_bfv_2d_set_21_,"c#node-bfv-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_bfv_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_env_2d_set_21_,"c#node-env-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_env_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_source_2d_set_21_,"c#node-source-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_source_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_stamp_2d_set_21_,"c#node-stamp-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_stamp_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_cst,"c#make-cst",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_cst,7,0)
,___DEF_LBL_RET(___H_c_23_make_2d_cst,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_make_2d_cst,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_make_2d_cst,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_RET(___H_c_23_make_2d_cst,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_INTRO(___H_c_23_cst_3f_,"c#cst?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_cst_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_cst_2d_val,"c#cst-val",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_cst_2d_val,1,0)
,___DEF_LBL_INTRO(___H_c_23_cst_2d_val_2d_set_21_,"c#cst-val-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_cst_2d_val_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_ref,"c#make-ref",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_ref,7,0)
,___DEF_LBL_RET(___H_c_23_make_2d_ref,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_make_2d_ref,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_make_2d_ref,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_RET(___H_c_23_make_2d_ref,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_INTRO(___H_c_23_ref_3f_,"c#ref?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_ref_2d_var,"c#ref-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_var,1,0)
,___DEF_LBL_INTRO(___H_c_23_ref_2d_var_2d_set_21_,"c#ref-var-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_var_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_set,"c#make-set",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_set,7,0)
,___DEF_LBL_RET(___H_c_23_make_2d_set,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_make_2d_set,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_make_2d_set,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_RET(___H_c_23_make_2d_set,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_INTRO(___H_c_23_set_3f_,"c#set?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_set_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_set_2d_var,"c#set-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_set_2d_var,1,0)
,___DEF_LBL_INTRO(___H_c_23_set_2d_var_2d_set_21_,"c#set-var-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_set_2d_var_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_def,"c#make-def",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_def,7,0)
,___DEF_LBL_RET(___H_c_23_make_2d_def,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_make_2d_def,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_make_2d_def,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_RET(___H_c_23_make_2d_def,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_INTRO(___H_c_23_def_3f_,"c#def?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_def_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_def_2d_var,"c#def-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_def_2d_var,1,0)
,___DEF_LBL_INTRO(___H_c_23_def_2d_var_2d_set_21_,"c#def-var-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_def_2d_var_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_tst,"c#make-tst",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_tst,6,0)
,___DEF_LBL_RET(___H_c_23_make_2d_tst,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_make_2d_tst,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_make_2d_tst,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_make_2d_tst,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_INTRO(___H_c_23_tst_3f_,"c#tst?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_tst_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_conj,"c#make-conj",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_conj,6,0)
,___DEF_LBL_RET(___H_c_23_make_2d_conj,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_make_2d_conj,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_make_2d_conj,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_make_2d_conj,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_INTRO(___H_c_23_conj_3f_,"c#conj?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_conj_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_disj,"c#make-disj",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_disj,6,0)
,___DEF_LBL_RET(___H_c_23_make_2d_disj,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_make_2d_disj,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_make_2d_disj,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_make_2d_disj,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_INTRO(___H_c_23_disj_3f_,"c#disj?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_disj_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_prc,"c#make-prc",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_prc,12,0)
,___DEF_LBL_RET(___H_c_23_make_2d_prc,___OFD(___RETI,16,9,0x3f1fffL))
,___DEF_LBL_RET(___H_c_23_make_2d_prc,___IFD(___RETN,13,9,0x1fffL))
,___DEF_LBL_RET(___H_c_23_make_2d_prc,___OFD(___RETI,16,9,0x3f0200L))
,___DEF_LBL_RET(___H_c_23_make_2d_prc,___OFD(___RETI,16,9,0x3f0200L))
,___DEF_LBL_INTRO(___H_c_23_prc_3f_,"c#prc?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_name,"c#prc-name",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_name,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_c_2d_name,"c#prc-c-name",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_c_2d_name,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_parms,"c#prc-parms",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_parms,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_opts,"c#prc-opts",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_opts,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_keys,"c#prc-keys",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_keys,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_rest_3f_,"c#prc-rest?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_rest_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_name_2d_set_21_,"c#prc-name-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_name_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_c_2d_name_2d_set_21_,"c#prc-c-name-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_c_2d_name_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_parms_2d_set_21_,"c#prc-parms-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_parms_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_opts_2d_set_21_,"c#prc-opts-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_opts_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_keys_2d_set_21_,"c#prc-keys-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_keys_2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_prc_2d_rest_3f__2d_set_21_,"c#prc-rest?-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_rest_3f__2d_set_21_,2,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_app,"c#make-app",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_app,6,0)
,___DEF_LBL_RET(___H_c_23_make_2d_app,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_make_2d_app,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_make_2d_app,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_make_2d_app,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_INTRO(___H_c_23_app_3f_,"c#app?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_app_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_make_2d_fut,"c#make-fut",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_fut,6,0)
,___DEF_LBL_RET(___H_c_23_make_2d_fut,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_make_2d_fut,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_make_2d_fut,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_make_2d_fut,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_INTRO(___H_c_23_fut_3f_,"c#fut?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_fut_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_node_2d_children_2d_set_21_,"c#node-children-set!",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_children_2d_set_21_,2,0)
,___DEF_LBL_RET(___H_c_23_node_2d_children_2d_set_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_node_2d_children_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_node_2d_children_2d_set_21_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_node_2d_children_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_node_2d_fv_2d_invalidate_21_,"c#node-fv-invalidate!",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_node_2d_fv_2d_invalidate_21_,1,0)
,___DEF_LBL_RET(___H_c_23_node_2d_fv_2d_invalidate_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_node_2d_fv_2d_invalidate_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_new_2d_cst,"c#new-cst",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_cst,3,0)
,___DEF_LBL_RET(___H_c_23_new_2d_cst,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_new_2d_cst,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_new_2d_cst,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_new_2d_cst,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_ref,"c#new-ref",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_ref,3,0)
,___DEF_LBL_RET(___H_c_23_new_2d_ref,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_ref,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_ref,___IFD(___RETI,8,1,0x3f07L))
,___DEF_LBL_RET(___H_c_23_new_2d_ref,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_new_2d_ref,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_ref_2d_extended_2d_bindings,"c#new-ref-extended-bindings",___REF_FAL,
5,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_ref_2d_extended_2d_bindings,3,0)
,___DEF_LBL_RET(___H_c_23_new_2d_ref_2d_extended_2d_bindings,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_new_2d_ref_2d_extended_2d_bindings,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_new_2d_ref_2d_extended_2d_bindings,___IFD(___RETN,5,0,0x13L))
,___DEF_LBL_RET(___H_c_23_new_2d_ref_2d_extended_2d_bindings,___IFD(___RETI,8,8,0x3f10L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_set,"c#new-set",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_set,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_set,___OFD(___RETI,12,2,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_new_2d_set,___OFD(___RETI,12,2,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_new_2d_set,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_new_2d_set,___OFD(___RETI,12,2,0x3f027L))
,___DEF_LBL_RET(___H_c_23_new_2d_set,___IFD(___RETN,9,2,0x27L))
,___DEF_LBL_RET(___H_c_23_new_2d_set,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_INTRO(___H_c_23_set_2d_val,"c#set-val",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_set_2d_val,1,0)
,___DEF_LBL_RET(___H_c_23_set_2d_val,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_set_2d_val,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_set_2d_val,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_set_2d_val,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_def,"c#new-def",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_def,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_def,___OFD(___RETI,12,2,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_new_2d_def,___OFD(___RETI,12,2,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_new_2d_def,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_new_2d_def,___OFD(___RETI,12,2,0x3f027L))
,___DEF_LBL_RET(___H_c_23_new_2d_def,___IFD(___RETN,9,2,0x27L))
,___DEF_LBL_RET(___H_c_23_new_2d_def,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_INTRO(___H_c_23_def_2d_val,"c#def-val",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_def_2d_val,1,0)
,___DEF_LBL_RET(___H_c_23_def_2d_val,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_def_2d_val,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_def_2d_val,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_def_2d_val,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_tst,"c#new-tst",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_tst,5,0)
,___DEF_LBL_RET(___H_c_23_new_2d_tst,___OFD(___RETI,12,2,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_new_2d_tst,___OFD(___RETI,12,2,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_new_2d_tst,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_new_2d_tst,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_RET(___H_c_23_new_2d_tst,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_INTRO(___H_c_23_tst_2d_pre,"c#tst-pre",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_tst_2d_pre,1,0)
,___DEF_LBL_RET(___H_c_23_tst_2d_pre,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_tst_2d_pre,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_tst_2d_pre,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_tst_2d_pre,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_tst_2d_con,"c#tst-con",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_tst_2d_con,1,0)
,___DEF_LBL_RET(___H_c_23_tst_2d_con,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_tst_2d_con,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_tst_2d_con,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_tst_2d_con,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_tst_2d_alt,"c#tst-alt",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_tst_2d_alt,1,0)
,___DEF_LBL_RET(___H_c_23_tst_2d_alt,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_tst_2d_alt,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_tst_2d_alt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_tst_2d_alt,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_conj,"c#new-conj",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_conj,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_conj,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_conj,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_conj,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_conj,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_RET(___H_c_23_new_2d_conj,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_INTRO(___H_c_23_conj_2d_pre,"c#conj-pre",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_conj_2d_pre,1,0)
,___DEF_LBL_RET(___H_c_23_conj_2d_pre,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_conj_2d_pre,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_conj_2d_pre,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_conj_2d_pre,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_conj_2d_alt,"c#conj-alt",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_conj_2d_alt,1,0)
,___DEF_LBL_RET(___H_c_23_conj_2d_alt,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_conj_2d_alt,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_conj_2d_alt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_conj_2d_alt,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_disj,"c#new-disj",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_disj,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_disj,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_RET(___H_c_23_new_2d_disj,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_INTRO(___H_c_23_disj_2d_pre,"c#disj-pre",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_disj_2d_pre,1,0)
,___DEF_LBL_RET(___H_c_23_disj_2d_pre,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_disj_2d_pre,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_disj_2d_pre,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_disj_2d_pre,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_disj_2d_alt,"c#disj-alt",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_disj_2d_alt,1,0)
,___DEF_LBL_RET(___H_c_23_disj_2d_alt,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_disj_2d_alt,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_disj_2d_alt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_disj_2d_alt,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_prc,"c#new-prc",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_prc,9,0)
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___OFD(___RETI,16,7,0x3f0fffL))
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___OFD(___RETI,16,7,0x3f0fffL))
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___IFD(___RETN,13,7,0xfffL))
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___OFD(___RETI,16,7,0x3f0481L))
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___IFD(___RETN,13,7,0x481L))
,___DEF_LBL_RET(___H_c_23_new_2d_prc,___OFD(___RETI,16,7,0x3f0080L))
,___DEF_LBL_INTRO(___H_c_23_prc_2d_body,"c#prc-body",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_body,1,0)
,___DEF_LBL_RET(___H_c_23_prc_2d_body,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_prc_2d_body,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_prc_2d_body,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_prc_2d_body,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_,"c#prc-req-and-opt-parms-only?",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_new_2d_call,"c#new-call",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_call,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_call,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_call,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_call,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_call,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23_new_2d_call,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_call,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_new_2d_call,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_call_2a_,"c#new-call*",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_call_2a_,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_call_2a_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_app_2d_oper,"c#app-oper",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_app_2d_oper,1,0)
,___DEF_LBL_RET(___H_c_23_app_2d_oper,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_app_2d_oper,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_app_2d_oper,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_app_2d_oper,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_app_2d_args,"c#app-args",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_app_2d_args,1,0)
,___DEF_LBL_RET(___H_c_23_app_2d_args,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_app_2d_args,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_app_2d_args,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_app_2d_args,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_oper_2d_pos_3f_,"c#oper-pos?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_oper_2d_pos_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_oper_2d_pos_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_oper_2d_pos_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_oper_2d_pos_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_oper_2d_pos_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_oper_2d_pos_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_fut,"c#new-fut",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_fut,3,0)
,___DEF_LBL_RET(___H_c_23_new_2d_fut,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_fut,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_fut,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_fut,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_new_2d_fut,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_fut_2d_val,"c#fut-val",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_fut_2d_val,1,0)
,___DEF_LBL_RET(___H_c_23_fut_2d_val,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_fut_2d_val,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_fut_2d_val,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_fut_2d_val,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_disj_2d_call,"c#new-disj-call",___REF_FAL,17,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_disj_2d_call,5,0)
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETI,16,4,0x3f03ffL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETN,13,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETN,29,4,0x303f1ffL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETN,33,4,0x10303f2feL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETI,33,4,0x3f10303f2bcL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETN,29,4,0x303f2bcL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETN,21,4,0x3f03cL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETN,9,4,0x3cL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___OFD(___RETI,12,4,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETN,9,4,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETI,8,4,0x3f11L))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETN,5,4,0x11L))
,___DEF_LBL_RET(___H_c_23_new_2d_disj_2d_call,___IFD(___RETI,8,4,0x3f10L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_seq,"c#new-seq",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_seq,4,0)
,___DEF_LBL_RET(___H_c_23_new_2d_seq,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_seq,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_seq,___OFD(___RETI,18,1,0x3f3f06aL))
,___DEF_LBL_RET(___H_c_23_new_2d_seq,___IFD(___RETN,9,1,0x6aL))
,___DEF_LBL_RET(___H_c_23_new_2d_seq,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_new_2d_seq,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_let,"c#new-let",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_let,5,0)
,___DEF_LBL_RET(___H_c_23_new_2d_let,___OFD(___RETI,16,3,0x3f0f1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_let,___IFD(___RETN,13,3,0xf1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_let,___IFD(___RETN,5,3,0x1dL))
,___DEF_LBL_RET(___H_c_23_new_2d_let,___IFD(___RETN,5,3,0xfL))
,___DEF_LBL_RET(___H_c_23_new_2d_let,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_temp_2d_variable,"c#new-temp-variable",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_temp_2d_variable,2,0)
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_new_2d_temp_2d_variable,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_variables,"c#new-variables",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_variables,1,0)
,___DEF_LBL_RET(___H_c_23_new_2d_variables,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_new_2d_variables,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_new_2d_variables,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_new_2d_variables,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_new_2d_variables,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_new_2d_variables,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_new_2d_variable,"c#new-variable",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_new_2d_variable,1,0)
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_new_2d_variable,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_set_2d_prc_2d_names_21_,"c#set-prc-names!",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_set_2d_prc_2d_names_21_,2,0)
,___DEF_LBL_RET(___H_c_23_set_2d_prc_2d_names_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_set_2d_prc_2d_names_21_,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_set_2d_prc_2d_names_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_set_2d_prc_2d_names_21_,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_set_2d_prc_2d_names_21_,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_INTRO(___H_c_23_free_2d_variables,"c#free-variables",___REF_FAL,15,0)
,___DEF_LBL_PROC(___H_c_23_free_2d_variables,1,0)
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_free_2d_variables,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_bound_2d_free_2d_variables,"c#bound-free-variables",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_bound_2d_free_2d_variables,1,0)
,___DEF_LBL_RET(___H_c_23_bound_2d_free_2d_variables,___IFD(___RETI,8,1,0x3f07L))
,___DEF_LBL_RET(___H_c_23_bound_2d_free_2d_variables,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_bound_2d_free_2d_variables,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_bound_2d_free_2d_variables,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_bound_2d_free_2d_variables,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_bound_2d_free_2d_variables,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_bound_2d_variables,"c#bound-variables",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_bound_2d_variables,1,0)
,___DEF_LBL_RET(___H_c_23_bound_2d_variables,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_mutable_3f_,"c#mutable?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_mutable_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_mutable_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_mutable_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_mutable_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_bound_3f_,"c#bound?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_bound_3f_,1,0)
,___DEF_LBL_INTRO(___H_c_23_global_3f_,"c#global?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_global_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_global_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_global_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_global_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_global_2d_single_2d_def,"c#global-single-def",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_global_2d_single_2d_def,1,0)
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_global_2d_single_2d_def,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23_global_2d_proc_2d_obj,"c#global-proc-obj",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_global_2d_proc_2d_obj,1,0)
,___DEF_LBL_RET(___H_c_23_global_2d_proc_2d_obj,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_global_2d_proc_2d_obj,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_global_2d_proc_2d_obj,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_global_2d_proc_2d_obj,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_global_2d_proc_2d_obj,___IFD(___RETI,8,8,0x3f08L))
,___DEF_LBL_INTRO(___H_c_23_global_2d_singly_2d_bound_3f_,"c#global-singly-bound?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_global_2d_singly_2d_bound_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_global_2d_singly_2d_bound_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_global_2d_singly_2d_bound_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_global_2d_singly_2d_bound_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_global_2d_singly_2d_bound_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_app_2d__3e_specialized_2d_proc,"c#app->specialized-proc",___REF_FAL,5,0)

,___DEF_LBL_PROC(___H_c_23_app_2d__3e_specialized_2d_proc,1,0)
,___DEF_LBL_RET(___H_c_23_app_2d__3e_specialized_2d_proc,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_app_2d__3e_specialized_2d_proc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_app_2d__3e_specialized_2d_proc,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_app_2d__3e_specialized_2d_proc,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_specialize_2d_app,"c#specialize-app",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_specialize_2d_app,3,0)
,___DEF_LBL_RET(___H_c_23_specialize_2d_app,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_app,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_app,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_app,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_app,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_app,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_INTRO(___H_c_23_specialize_2d_proc,"c#specialize-proc",___REF_FAL,18,0)
,___DEF_LBL_PROC(___H_c_23_specialize_2d_proc,3,0)
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_specialize_2d_proc,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_INTRO(___H_c_23_nb_2d_args_2d_conforms_3f_,"c#nb-args-conforms?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_nb_2d_args_2d_conforms_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_nb_2d_args_2d_conforms_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_scheme_2d_dialect,"c#scheme-dialect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_scheme_2d_dialect,1,0)
,___DEF_LBL_RET(___H_c_23_scheme_2d_dialect,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_constant_2d_fold_3f_,"c#constant-fold?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_constant_2d_fold_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_constant_2d_fold_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_lambda_2d_lift_3f_,"c#lambda-lift?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_lambda_2d_lift_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_lambda_2d_lift_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_inline_3f_,"c#inline?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_inline_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_inline_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_inline_2d_primitive_3f_,"c#inline-primitive?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_inline_2d_primitive_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_inline_2d_primitive_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_not_2d_inline_2d_primitives,"c#add-not-inline-primitives",___REF_FAL,
3,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_not_2d_inline_2d_primitives,1,0)
,___DEF_LBL_RET(___H_c_23_add_2d_not_2d_inline_2d_primitives,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_not_2d_inline_2d_primitives,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_inlining_2d_limit,"c#inlining-limit",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_inlining_2d_limit,1,0)
,___DEF_LBL_RET(___H_c_23_inlining_2d_limit,___IFD(___RETI,5,0,0x3f11L))
,___DEF_LBL_RET(___H_c_23_inlining_2d_limit,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_inlining_2d_limit,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_block_2d_compilation_3f_,"c#block-compilation?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_block_2d_compilation_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_block_2d_compilation_3f_,___IFD(___RETI,5,0,0x3f11L))
,___DEF_LBL_RET(___H_c_23_block_2d_compilation_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_block_2d_compilation_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_core_3f_,"c#core?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_core_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_core_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_standard_2d_binding_3f_,"c#standard-binding?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_standard_2d_binding_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_standard_2d_binding_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_extended_2d_binding_3f_,"c#extended-binding?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_extended_2d_binding_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_extended_2d_binding_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_extended_2d_bindings,"c#add-extended-bindings",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H_c_23_add_2d_extended_2d_bindings,1,0)
,___DEF_LBL_RET(___H_c_23_add_2d_extended_2d_bindings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_extended_2d_bindings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_run_2d_time_2d_binding_3f_,"c#run-time-binding?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_run_2d_time_2d_binding_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_run_2d_time_2d_binding_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_safe_3f_,"c#safe?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_safe_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_safe_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_not_2d_safe,"c#add-not-safe",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_not_2d_safe,1,0)
,___DEF_LBL_RET(___H_c_23_add_2d_not_2d_safe,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_not_2d_safe,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_warnings_3f_,"c#warnings?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_warnings_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_warnings_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_intrs_2d_enabled_3f_,"c#intrs-enabled?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_intrs_2d_enabled_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_intrs_2d_enabled_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_not_2d_interrupts_2d_enabled,"c#add-not-interrupts-enabled",___REF_FAL,
3,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_not_2d_interrupts_2d_enabled,1,0)
,___DEF_LBL_RET(___H_c_23_add_2d_not_2d_interrupts_2d_enabled,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_not_2d_interrupts_2d_enabled,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_debug_3f_,"c#debug?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_debug_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_debug_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_debug_2d_location_3f_,"c#debug-location?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_debug_2d_location_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_debug_2d_location_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_debug_2d_source_3f_,"c#debug-source?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_debug_2d_source_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_debug_2d_source_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_debug_2d_environments_3f_,"c#debug-environments?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_debug_2d_environments_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_debug_2d_environments_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_environment_2d_map_3f_,"c#environment-map?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_environment_2d_map_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_environment_2d_map_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_tail_2d_calls_3f_,"c#proper-tail-calls?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_tail_2d_calls_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_tail_2d_calls_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_proper_2d_tail_2d_calls,"c#add-proper-tail-calls",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H_c_23_add_2d_proper_2d_tail_2d_calls,1,0)
,___DEF_LBL_RET(___H_c_23_add_2d_proper_2d_tail_2d_calls,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_proper_2d_tail_2d_calls,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_optimize_2d_dead_2d_local_2d_variables_3f_,"c#optimize-dead-local-variables?",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_optimize_2d_dead_2d_local_2d_variables_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_optimize_2d_dead_2d_local_2d_variables_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_standard_2d_proc_2d_obj,"c#standard-proc-obj",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_standard_2d_proc_2d_obj,3,0)
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___OFD(___RETI,12,1,0x3f10fL))
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___IFD(___RETN,9,1,0x10fL))
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___IFD(___RETN,9,1,0x11bL))
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___IFD(___RETN,9,1,0x117L))
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_standard_2d_proc_2d_obj,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_standard_2d_procedure_3f_,"c#standard-procedure?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_standard_2d_procedure_3f_,4,0)
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_standard_2d_procedure_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_parse_2d_program,"c#parse-program",___REF_FAL,100,0)
,___DEF_LBL_PROC(___H_c_23_parse_2d_program,4,0)
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1bL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0xbfL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x1ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x1ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x3ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x3ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x7ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x27fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x27fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x27fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___OFD(___RETI,16,1,0x3f02ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x2ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x7ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,13,1,0x7ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x5fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0xbfL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___OFD(___RETI,12,1,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_PROC(___H_c_23_parse_2d_program,2,1)
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,0,0x3f0dL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,8,0x3f0aL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_parse_2d_program,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_INTRO(___H_c_23_check_2d_multiple_2d_global_2d_defs,"c#check-multiple-global-defs",___REF_FAL,
15,0)
,___DEF_LBL_PROC(___H_c_23_check_2d_multiple_2d_global_2d_defs,1,0)
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___OFD(___RETI,9,0,0x3f10fL))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_check_2d_multiple_2d_global_2d_defs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_syntax_2d_error,"c#pt-syntax-error",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_syntax_2d_error,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_syntax_2d_error,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_syntax_2d_error,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_syntax_2d_error,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_syntax_2d_error,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_pt,"c#pt",___REF_FAL,66,0)
,___DEF_LBL_PROC(___H_c_23_pt,3,0)
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_macro_2d_expand,"c#macro-expand",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_macro_2d_expand,2,0)
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expand,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_self_2d_eval,"c#pt-self-eval",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_self_2d_eval,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_self_2d_eval,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_self_2d_eval,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_self_2d_eval,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_self_2d_eval,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_quote,"c#pt-quote",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_quote,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_quote,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quote,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quote,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quote,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quote,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_quasiquote,"c#pt-quasiquote",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_quasiquote,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquote,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquote,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquote,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_quasiquotation,"c#pt-quasiquotation",___REF_FAL,24,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_quasiquotation,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,4,0x1dL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,4,0x1dL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETN,5,4,0x1dL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_quasiquotation_2d_list,"c#pt-quasiquotation-list",___REF_FAL,13,0)

,___DEF_LBL_PROC(___H_c_23_pt_2d_quasiquotation_2d_list,4,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETN,9,1,0x33L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___IFD(___RETN,9,1,0x33L))
,___DEF_LBL_RET(___H_c_23_pt_2d_quasiquotation_2d_list,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_append_2d_form,"c#append-form",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_append_2d_form,4,0)
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___OFD(___RETI,12,1,0x3f037L))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETN,9,1,0x37L))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETN,5,1,0x13L))
,___DEF_LBL_RET(___H_c_23_append_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_cons_2d_form,"c#cons-form",___REF_FAL,21,0)
,___DEF_LBL_PROC(___H_c_23_cons_2d_form,4,0)
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___OFD(___RETI,12,3,0x3f07bL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___OFD(___RETI,12,3,0x3f07bL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,9,3,0x7bL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,9,3,0x4eL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_cons_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_vector_2d_form,"c#vector-form",___REF_FAL,14,0)
,___DEF_LBL_PROC(___H_c_23_vector_2d_form,3,0)
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___OFD(___RETI,12,3,0x3f07bL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___OFD(___RETI,12,3,0x3f07bL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETN,9,3,0x7bL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETN,9,3,0x4eL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_vector_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_list_2d_construction_3f_,"c#list-construction?",___REF_FAL,20,0)
,___DEF_LBL_PROC(___H_c_23_list_2d_construction_3f_,3,0)
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0x11L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_list_2d_construction_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_var,"c#pt-var",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_var,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_var,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_var,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_var,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_var,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_set_21_,"c#pt-set!",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_set_21_,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETN,9,1,0x3bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETN,9,1,0x2bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_set_21_,___IFD(___RETI,8,8,0x3f05L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_lambda,"c#pt-lambda",___REF_FAL,97,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_lambda,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f05L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,4,0x17ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,4,0x17ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,11,0x5fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,11,12,0x3f7ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,17,4,0x3f11b1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,4,0x1b1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,7,0x9ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,7,0xaffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,5,0x3f3fdL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,1,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,24,5,0x3f03f3fdL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,24,5,0x3f03f3fdL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,5,0x3f0fdL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,5,0xfdL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,5,0x1030ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,5,0x1031ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,5,0x1033ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,21,5,0x3f1031ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,5,0x30ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,5,0x313eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,5,0x3aL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,5,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,5,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,5,0x3f022L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,5,0x22L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,5,0x3f020L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,7,0x8ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,16,16,0x3f007fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,16,4,0x3f17ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,9,1,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,1,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,1,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,10,0x1dfffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,16,7,0x3f0effL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,7,0xeffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,8,0xdffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,8,0xbffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,8,0x3fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,12,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,20,10,0x3f077ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,10,0x77ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,11,0x6fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,24,13,0x3f03ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0x5ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0x7ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0x7ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,24,13,0x3f0effffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0xeffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,12,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,12,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,24,13,0x3f04efffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETN,21,13,0x4efffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,12,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,12,12,0x3ffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,16,9,0x3f0fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,9,0xfffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,20,10,0x3f07fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,10,0x7fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,10,0x7fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,10,0xbfffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,17,10,0xffffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,20,10,0x3f1dfffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,16,10,0x3f1fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,13,10,0x1fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_lambda,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_parameter_2d_name,"c#parameter-name",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_parameter_2d_name,1,0)
,___DEF_LBL_INTRO(___H_c_23_parameter_2d_source,"c#parameter-source",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_parameter_2d_source,1,0)
,___DEF_LBL_INTRO(___H_c_23_parameter_2d_default_2d_source,"c#parameter-default-source",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_c_23_parameter_2d_default_2d_source,1,0)
,___DEF_LBL_INTRO(___H_c_23_extract_2d_parameters,"c#extract-parameters",___REF_FAL,64,0)
,___DEF_LBL_PROC(___H_c_23_extract_2d_parameters,2,0)
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x7ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,3,0x3f07eL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,3,0x7eL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,3,0x7dL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,3,0x4fL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,16,5,0x3f03efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0xe7L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,16,16,0x3f0000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x7ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,16,16,0x3f0000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0x1feL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,3,0x3f07eL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,3,0x7eL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,3,0x7cL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,3,0x48L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0x1feL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0x1feL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,16,16,0x3f0000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,16,16,0x3f0000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x7efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,16,16,0x3f0000L))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0x6fL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___OFD(___RETI,12,5,0x3f1efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETN,9,5,0x1efL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_extract_2d_parameters,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_INTRO(___H_c_23_source_2d__3e_parms,"c#source->parms",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_source_2d__3e_parms,1,0)
,___DEF_LBL_RET(___H_c_23_source_2d__3e_parms,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_parms,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_parms,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_parms,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_body,"c#pt-body",___REF_FAL,42,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_body,4,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___OFD(___RETI,12,4,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xfbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,6,8,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,13,4,0x2ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xbfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_body,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_sequence,"c#pt-sequence",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_sequence,4,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_sequence,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_sequence,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_sequence,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_sequence,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_sequence,___IFD(___RETN,9,1,0x2bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_sequence,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_if,"c#pt-if",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_if,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___IFD(___RETN,9,5,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___IFD(___RETN,9,5,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___IFD(___RETN,9,5,0x1a3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_if,___OFD(___RETI,12,12,0x3f183L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_cond,"c#pt-cond",___REF_FAL,23,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_cond,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,6,0x1dfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,1,0x5fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,1,0x9fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,1,0x27L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,6,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,8,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,13,8,0x39fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,13,8,0x323L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___OFD(___RETI,16,16,0x3f0223L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___IFD(___RETN,9,6,0x163L))
,___DEF_LBL_RET(___H_c_23_pt_2d_cond,___OFD(___RETI,12,12,0x3f123L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_and,"c#pt-and",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_and,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___IFD(___RETN,9,1,0x47L))
,___DEF_LBL_RET(___H_c_23_pt_2d_and,___OFD(___RETI,12,12,0x3f041L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_or,"c#pt-or",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_or,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___IFD(___RETN,9,1,0x47L))
,___DEF_LBL_RET(___H_c_23_pt_2d_or,___OFD(___RETI,12,12,0x3f041L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_case,"c#pt-case",___REF_FAL,35,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_case,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,26,1,0x3f303f06bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,2,0x33fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,2,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,2,0xbfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,2,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,17,2,0x31ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,4,0xf3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,4,0x3f0f7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,4,0x3f0f7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,4,0xf7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,16,4,0x3f07ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,4,0x7ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,4,0xcffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,4,0x4f7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,4,0x4ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,4,0x5ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,13,4,0x3f10f3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,5,4,0x1dL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,2,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,13,2,0x247L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,16,16,0x3f0243L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETN,21,1,0x3f06bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,1,0x6bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___IFD(___RETN,9,1,0x66L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_pt_2d_case,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_let,"c#pt-let",___REF_FAL,57,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_let,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x5fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETN,25,1,0x3f0322L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,13,1,0x322L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETI,16,16,0x3f0001L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETI,12,1,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0xbfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETN,21,1,0x3f1eeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x1eeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETI,12,1,0x3f1efL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x1efL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x16fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETN,21,1,0x3f2dbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETN,21,1,0x3f093L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___IFD(___RETN,9,1,0x93L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_let_2a_,"c#pt-let*",___REF_FAL,17,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_let_2a_,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,13,3,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___OFD(___RETI,12,3,0x3f0fbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,9,3,0xfbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___OFD(___RETI,12,3,0x3f1fbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,9,3,0x1fbL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___OFD(___RETI,12,3,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,9,3,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___OFD(___RETN,25,3,0x3f0c0cL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___IFD(___RETN,13,3,0xc0cL))
,___DEF_LBL_RET(___H_c_23_pt_2d_let_2a_,___OFD(___RETI,16,16,0x3f0001L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_letrec,"c#pt-letrec",___REF_FAL,26,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_letrec,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,9,1,0x77L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,9,2,0x5fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___OFD(___RETI,12,12,0x3f007L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_letrec,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_recursive_2d_let,"c#pt-recursive-let",___REF_FAL,62,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_recursive_2d_let,6,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,7,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,1,0x3f033L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,7,0x497L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,1,0x33L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,1,0x3f033L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f13L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,1,0x3f01eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,7,0x8eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,7,0x80L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,7,0x3f080L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,7,0x491L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,7,0x3f080L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,7,0x791L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,7,0x697L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,7,0xefL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,7,0xefL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,7,0xefL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,17,9,0x7fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,21,7,0x3f1f0791L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,4,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,12,4,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,4,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,9,0x2ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,17,9,0x7fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,9,12,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,17,9,0x7fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,20,9,0x3f03fffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,16,5,0x3f03ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,5,0x231L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___OFD(___RETI,16,16,0x3f0201L))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,13,5,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_recursive_2d_let,___IFD(___RETN,17,9,0x3fffL))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_begin,"c#pt-begin",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_begin,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_begin,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_begin,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_begin,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_do,"c#pt-do",___REF_FAL,55,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_do,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,9,1,0xffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETI,12,1,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,9,1,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,13,1,0x3ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,13,1,0x7bfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,13,1,0x7ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,13,1,0xfffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETI,32,1,0x3f03f0fdffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,29,1,0x3f0fdffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,29,1,0x3f03cffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,17,1,0x3cffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,37,1,0x303f03d77L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,37,1,0x303f03d7fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,37,1,0x303f0356fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,37,1,0x303f0357fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,41,1,0x10303f0357eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,45,1,0x110303f0355bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,41,1,0x10303f0351bL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,37,1,0x303f0311aL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,29,1,0x3f03102L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,17,1,0x3102L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETI,20,1,0x3f03107L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,17,1,0x3107L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___OFD(___RETN,41,1,0x10303f0355aL))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_do,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_combination,"c#pt-combination",___REF_FAL,15,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_combination,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,9,0,0x2dL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H_c_23_pt_2d_combination,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_delay,"c#pt-delay",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_delay,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___OFD(___RETI,12,1,0x3f02fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETN,9,1,0x2fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___OFD(___RETI,12,1,0x3f1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETN,9,1,0x1ffL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETN,13,1,0x33fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETN,9,1,0x12fL))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___OFD(___RETN,21,1,0x3f113L))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___IFD(___RETN,9,1,0x113L))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_pt_2d_delay,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_INTRO(___H_c_23_pt_2d_future,"c#pt-future",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_pt_2d_future,3,0)
,___DEF_LBL_RET(___H_c_23_pt_2d_future,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_pt_2d_future,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_future,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_pt_2d_future,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_self_2d_eval_2d_expr_3f_,"c#self-eval-expr?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_self_2d_eval_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_self_2d_eval_2d_expr_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_self_2d_eval_2d_expr_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_self_2d_eval_2d_expr_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_self_2d_evaluating_3f_,"c#self-evaluating?",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_c_23_self_2d_evaluating_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_self_2d_evaluating_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_quote_2d_expr_3f_,"c#**quote-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_quote_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_quote_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_quasiquote_2d_expr_3f_,"c#**quasiquote-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_quasiquote_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_quasiquote_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_quasiquote_2d_expr_3f_,"c#quasiquote-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_quasiquote_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_quasiquote_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_unquote_2d_expr_3f_,"c#unquote-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_unquote_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_unquote_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_unquote_2d_splicing_2d_expr_3f_,"c#unquote-splicing-expr?",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_c_23_unquote_2d_splicing_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_unquote_2d_splicing_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_var_2d_expr_3f_,"c#var-expr?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_var_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_var_2d_expr_3f_,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_var_2d_expr_3f_,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_var_2d_expr_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_var_2d_expr_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_var_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_not_2d_macro,"c#not-macro",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_not_2d_macro,3,0)
,___DEF_LBL_RET(___H_c_23_not_2d_macro,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_not_2d_macro,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_not_2d_macro,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_not_2d_macro,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_bindable_2d_var_3f_,"c#bindable-var?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_bindable_2d_var_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_bindable_2d_var_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_bindable_2d_var_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_bindable_2d_var_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_set_21__2d_expr_3f_,"c#**set!-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_set_21__2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_set_21__2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_lambda_2d_expr_3f_,"c#**lambda-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_lambda_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_lambda_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_lambda_2d_expr_3f_,"c#lambda-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_lambda_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_lambda_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_if_2d_expr_3f_,"c#**if-expr?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_if_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_if_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_cond_2d_expr_3f_,"c#**cond-expr?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_cond_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_cond_2d_expr_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_cond_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_cond_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_cond_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_and_2d_expr_3f_,"c#**and-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_and_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_and_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_or_2d_expr_3f_,"c#**or-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_or_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_or_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_case_2d_expr_3f_,"c#**case-expr?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_case_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_case_2d_expr_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_case_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_case_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_case_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_let_2d_expr_3f_,"c#**let-expr?",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_let_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_let_2a__2d_expr_3f_,"c#**let*-expr?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_let_2a__2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2a__2d_expr_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2a__2d_expr_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2a__2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2a__2d_expr_3f_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_let_2a__2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_letrec_2d_expr_3f_,"c#**letrec-expr?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_letrec_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_letrec_2d_expr_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_letrec_2d_expr_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_letrec_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_letrec_2d_expr_3f_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_letrec_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_do_2d_expr_3f_,"c#**do-expr?",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_do_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_do_2d_expr_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_do_2d_expr_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_do_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_do_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_do_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_combination_2d_expr_3f_,"c#combination-expr?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_combination_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_combination_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_delay_2d_expr_3f_,"c#**delay-expr?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_delay_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_delay_2d_expr_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_delay_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_delay_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_delay_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_future_2d_expr_3f_,"c#**future-expr?",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_future_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_future_2d_expr_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_future_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_future_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_future_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_macro_2d_expr_3f_,"c#macro-expr?",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H_c_23_macro_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_macro_2d_expr_3f_,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_,"c#**begin-cmd-or-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_begin_2d_expr_3f_,"c#**begin-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_begin_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_begin_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_define_2d_expr_3f_,"c#**define-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_define_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_define_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_define_2d_macro_2d_expr_3f_,"c#**define-macro-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_define_2d_macro_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_define_2d_macro_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_define_2d_syntax_2d_expr_3f_,"c#**define-syntax-expr?",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_define_2d_syntax_2d_expr_3f_,2,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_define_2d_syntax_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_include_2d_expr_3f_,"c#**include-expr?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_include_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_include_2d_expr_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_declare_2d_expr_3f_,"c#**declare-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_declare_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_declare_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_namespace_2d_expr_3f_,"c#**namespace-expr?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_namespace_2d_expr_3f_,1,0)
,___DEF_LBL_RET(___H_c_23__2a__2a_namespace_2d_expr_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_match,"c#match",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_match,3,0)
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETN,5,1,0x1aL))
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_match,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_ill_2d_formed_2d_special_2d_form,"c#ill-formed-special-form",___REF_FAL,13,
0)
,___DEF_LBL_PROC(___H_c_23_ill_2d_formed_2d_special_2d_form,1,0)
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H_c_23_ill_2d_formed_2d_special_2d_form,3,0)
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_ill_2d_formed_2d_special_2d_form,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_length,"c#proper-length",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_length,1,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_length,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_length,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_definition_2d_name,"c#definition-name",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_definition_2d_name,2,0)
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,9,1,0x37L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,9,1,0x3eL))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_definition_2d_name,___IFD(___RETN,9,1,0x3aL))
,___DEF_LBL_INTRO(___H_c_23_definition_2d_value,"c#definition-value",___REF_FAL,15,0)
,___DEF_LBL_PROC(___H_c_23_definition_2d_value,1,0)
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0x16L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_definition_2d_value,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_INTRO(___H_c_23_parms_2d__3e_source,"c#parms->source",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_parms_2d__3e_source,2,0)
,___DEF_LBL_RET(___H_c_23_parms_2d__3e_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_clauses_3f_,"c#proper-clauses?",___REF_FAL,15,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_clauses_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_case_2d_clauses_3f_,"c#proper-case-clauses?",___REF_FAL,14,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_case_2d_clauses_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_case_2d_clauses_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_selector_2d_list_3f_,"c#proper-selector-list?",___REF_FAL,7,0)

,___DEF_LBL_PROC(___H_c_23_proper_2d_selector_2d_list_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_selector_2d_list_3f_,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_proper_2d_selector_2d_list_3f_,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_proper_2d_selector_2d_list_3f_,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_proper_2d_selector_2d_list_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_selector_2d_list_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_selector_2d_list_3f_,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_bindings_3f_,"c#proper-bindings?",___REF_FAL,18,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_bindings_3f_,3,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETI,8,2,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,5,2,0xfL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,9,3,0x7bL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___OFD(___RETI,12,3,0x3f0fbL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,9,3,0xfbL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_bindings_3f_,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_do_2d_bindings_3f_,"c#proper-do-bindings?",___REF_FAL,19,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_do_2d_bindings_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,5,2,0xdL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,9,2,0x3dL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___OFD(___RETI,12,2,0x3f07dL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_bindings_3f_,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_proper_2d_do_2d_exit_3f_,"c#proper-do-exit?",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_proper_2d_do_2d_exit_3f_,1,0)
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_exit_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_exit_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_exit_3f_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_exit_3f_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_exit_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_proper_2d_do_2d_exit_3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_begin_2d_body,"c#begin-body",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_begin_2d_body,1,0)
,___DEF_LBL_RET(___H_c_23_begin_2d_body,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_begin_2d_body,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_begin_2d_body,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_length_3f_,"c#length?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_length_3f_,2,0)
,___DEF_LBL_RET(___H_c_23_length_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_transform_2d_declaration,"c#transform-declaration",___REF_FAL,42,0)

,___DEF_LBL_PROC(___H_c_23_transform_2d_declaration,1,0)
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3eL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x2bL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f001L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x2bL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_transform_2d_declaration,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_INTRO(___H_c_23_extract_2d_names,"c#extract-names",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_extract_2d_names,2,0)
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_extract_2d_names,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_declarations,"c#add-declarations",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_declarations,2,0)
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_add_2d_declarations,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_namespace,"c#add-namespace",___REF_FAL,23,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_namespace,2,0)
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,9,0,0x7fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,9,0,0x6fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_add_2d_namespace,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23_add_2d_macro,"c#add-macro",___REF_FAL,33,0)
,___DEF_LBL_PROC(___H_c_23_add_2d_macro,2,0)
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,1,0x3bL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,3,0x6fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,3,0x7bL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,1,0x7bL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,1,0x7bL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,3,0x6fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,3,0x6fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,9,3,0x6fL))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,3,0x19L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,8,0x3f10L))
,___DEF_LBL_PROC(___H_c_23_add_2d_macro,1,1)
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,1,0x3f06L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_add_2d_macro,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_ptree_2e_begin_21_,"c#ptree.begin!",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_ptree_2e_begin_21_,1,0)
,___DEF_LBL_RET(___H_c_23_ptree_2e_begin_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ptree_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ptree_2e_begin_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ptree_2e_begin_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_ptree_2e_end_21_,"c#ptree.end!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ptree_2e_end_21_,0,0)
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,16,9)
               ___GCMAP1(0x3f1fffL)
,___DEF_OFD(___RETI,16,9)
               ___GCMAP1(0x3f0200L)
,___DEF_OFD(___RETI,16,9)
               ___GCMAP1(0x3f0200L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f027L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f027L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,16,7)
               ___GCMAP1(0x3f0fffL)
,___DEF_OFD(___RETI,16,7)
               ___GCMAP1(0x3f0fffL)
,___DEF_OFD(___RETI,16,7)
               ___GCMAP1(0x3f0481L)
,___DEF_OFD(___RETI,16,7)
               ___GCMAP1(0x3f0080L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,16,4)
               ___GCMAP1(0x3f03ffL)
,___DEF_OFD(___RETN,29,4)
               ___GCMAP1(0x303f1ffL)
,___DEF_OFD(___RETN,33,4)
               ___GCMAP2(0x303f2feL,0x1L)
               ___GCMAP0
,___DEF_OFD(___RETI,33,4)
               ___GCMAP2(0x303f2bcL,0x3f1L)
               ___GCMAP0
,___DEF_OFD(___RETN,29,4)
               ___GCMAP1(0x303f2bcL)
,___DEF_OFD(___RETN,21,4)
               ___GCMAP1(0x3f03cL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,18,1)
               ___GCMAP1(0x3f3f06aL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,16,3)
               ___GCMAP1(0x3f0f1fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f10fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,16,1)
               ___GCMAP1(0x3f02ffL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,9,0)
               ___GCMAP1(0x3f10fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f037L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07bL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07bL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07bL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07bL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,11,12)
               ___GCMAP1(0x3f7ffL)
,___DEF_OFD(___RETI,17,4)
               ___GCMAP1(0x3f11b1fL)
,___DEF_OFD(___RETN,21,5)
               ___GCMAP1(0x3f3fdL)
,___DEF_OFD(___RETI,24,5)
               ___GCMAP2(0x3f03f3fdL,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETI,24,5)
               ___GCMAP2(0x3f03f3fdL,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETN,21,5)
               ___GCMAP1(0x3f0fdL)
,___DEF_OFD(___RETN,21,5)
               ___GCMAP1(0x1030ffL)
,___DEF_OFD(___RETN,21,5)
               ___GCMAP1(0x1031ffL)
,___DEF_OFD(___RETN,21,5)
               ___GCMAP1(0x1033ffL)
,___DEF_OFD(___RETI,21,5)
               ___GCMAP2(0x3f1031ffL,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f022L)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f020L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f007fL)
,___DEF_OFD(___RETI,16,4)
               ___GCMAP1(0x3f17ffL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,16,7)
               ___GCMAP1(0x3f0effL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETI,20,10)
               ___GCMAP1(0x3f077ffL)
,___DEF_OFD(___RETI,24,13)
               ___GCMAP2(0x3f03ffffL,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0x5ffffL)
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0x7ffffL)
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0x7ffffL)
,___DEF_OFD(___RETI,24,13)
               ___GCMAP2(0x3f0effffL,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0xeffffL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETI,24,13)
               ___GCMAP2(0x3f04efffL,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETN,21,13)
               ___GCMAP1(0x4efffL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3ffffL)
,___DEF_OFD(___RETI,16,9)
               ___GCMAP1(0x3f0fffL)
,___DEF_OFD(___RETI,20,10)
               ___GCMAP1(0x3f07fffL)
,___DEF_OFD(___RETI,20,10)
               ___GCMAP1(0x3f1dfffL)
,___DEF_OFD(___RETI,16,10)
               ___GCMAP1(0x3f1fffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07eL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,16,5)
               ___GCMAP1(0x3f03efL)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0000L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0000L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07eL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0000L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0000L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0000L)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1efL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f183L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0223L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f123L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f041L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f041L)
,___DEF_OFD(___RETI,26,1)
               ___GCMAP2(-0xcfc0f95L,0x3L)
               ___GCMAP0
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0f7L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0f7L)
,___DEF_OFD(___RETI,16,4)
               ___GCMAP1(0x3f07ffL)
,___DEF_OFD(___RETI,13,4)
               ___GCMAP1(0x3f10f3L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0243L)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x3f06bL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETN,25,1)
               ___GCMAP1(0x3f0322L)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0001L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x3f1eeL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f1efL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x3f2dbL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x3f093L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f0fbL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f1fbL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETN,25,3)
               ___GCMAP1(0x3f0c0cL)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0001L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f007L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f033L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f033L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f01eL)
,___DEF_OFD(___RETI,12,7)
               ___GCMAP1(0x3f080L)
,___DEF_OFD(___RETI,12,7)
               ___GCMAP1(0x3f080L)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,21,7)
               ___GCMAP2(0x3f1f0791L,0x0L)
               ___GCMAP0
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,9,12)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,20,9)
               ___GCMAP1(0x3f03fffL)
,___DEF_OFD(___RETI,16,5)
               ___GCMAP1(0x3f03ffL)
,___DEF_OFD(___RETI,16,16)
               ___GCMAP1(0x3f0201L)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,32,1)
               ___GCMAP2(0x3f0fdffL,0x3fL)
               ___GCMAP0
,___DEF_OFD(___RETN,29,1)
               ___GCMAP1(0x3f0fdffL)
,___DEF_OFD(___RETN,29,1)
               ___GCMAP1(0x3f03cffL)
,___DEF_OFD(___RETN,37,1)
               ___GCMAP2(0x3f03d77L,0x3L)
               ___GCMAP0
,___DEF_OFD(___RETN,37,1)
               ___GCMAP2(0x3f03d7fL,0x3L)
               ___GCMAP0
,___DEF_OFD(___RETN,37,1)
               ___GCMAP2(0x3f0356fL,0x3L)
               ___GCMAP0
,___DEF_OFD(___RETN,37,1)
               ___GCMAP2(0x3f0357fL,0x3L)
               ___GCMAP0
,___DEF_OFD(___RETN,41,1)
               ___GCMAP2(0x3f0357eL,0x103L)
               ___GCMAP0
,___DEF_OFD(___RETN,45,1)
               ___GCMAP2(0x3f0355bL,0x1103L)
               ___GCMAP0
,___DEF_OFD(___RETN,41,1)
               ___GCMAP2(0x3f0351bL,0x103L)
               ___GCMAP0
,___DEF_OFD(___RETN,37,1)
               ___GCMAP2(0x3f0311aL,0x3L)
               ___GCMAP0
,___DEF_OFD(___RETN,29,1)
               ___GCMAP1(0x3f03102L)
,___DEF_OFD(___RETI,20,1)
               ___GCMAP1(0x3f03107L)
,___DEF_OFD(___RETN,41,1)
               ___GCMAP2(0x3f0355aL,0x103L)
               ___GCMAP0
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f02fL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETN,21,1)
               ___GCMAP1(0x3f113L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f0fbL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f07dL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f001L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
___END_OFD

___BEGIN_MOD1
___DEF_PRM(0,___G__20___ptree1,1)
___DEF_PRM(137,___G_c_23_node_2d_parent,32)
___DEF_PRM(130,___G_c_23_node_2d_children,34)
___DEF_PRM(134,___G_c_23_node_2d_fv,36)
___DEF_PRM(128,___G_c_23_node_2d_bfv,38)
___DEF_PRM(132,___G_c_23_node_2d_env,40)
___DEF_PRM(139,___G_c_23_node_2d_source,42)
___DEF_PRM(141,___G_c_23_node_2d_stamp,44)
___DEF_PRM(138,___G_c_23_node_2d_parent_2d_set_21_,46)
___DEF_PRM(136,___G_c_23_node_2d_fv_2d_set_21_,48)
___DEF_PRM(129,___G_c_23_node_2d_bfv_2d_set_21_,50)
___DEF_PRM(133,___G_c_23_node_2d_env_2d_set_21_,52)
___DEF_PRM(140,___G_c_23_node_2d_source_2d_set_21_,54)
___DEF_PRM(142,___G_c_23_node_2d_stamp_2d_set_21_,56)
___DEF_PRM(98,___G_c_23_make_2d_cst,58)
___DEF_PRM(57,___G_c_23_cst_3f_,64)
___DEF_PRM(55,___G_c_23_cst_2d_val,66)
___DEF_PRM(56,___G_c_23_cst_2d_val_2d_set_21_,68)
___DEF_PRM(103,___G_c_23_make_2d_ref,70)
___DEF_PRM(207,___G_c_23_ref_3f_,76)
___DEF_PRM(205,___G_c_23_ref_2d_var,78)
___DEF_PRM(206,___G_c_23_ref_2d_var_2d_set_21_,80)
___DEF_PRM(104,___G_c_23_make_2d_set,82)
___DEF_PRM(218,___G_c_23_set_3f_,88)
___DEF_PRM(216,___G_c_23_set_2d_var,90)
___DEF_PRM(217,___G_c_23_set_2d_var_2d_set_21_,92)
___DEF_PRM(99,___G_c_23_make_2d_def,94)
___DEF_PRM(66,___G_c_23_def_3f_,100)
___DEF_PRM(64,___G_c_23_def_2d_var,102)
___DEF_PRM(65,___G_c_23_def_2d_var_2d_set_21_,104)
___DEF_PRM(105,___G_c_23_make_2d_tst,106)
___DEF_PRM(231,___G_c_23_tst_3f_,112)
___DEF_PRM(97,___G_c_23_make_2d_conj,114)
___DEF_PRM(50,___G_c_23_conj_3f_,120)
___DEF_PRM(100,___G_c_23_make_2d_disj,122)
___DEF_PRM(72,___G_c_23_disj_3f_,128)
___DEF_PRM(102,___G_c_23_make_2d_prc,130)
___DEF_PRM(166,___G_c_23_prc_3f_,136)
___DEF_PRM(156,___G_c_23_prc_2d_name,138)
___DEF_PRM(152,___G_c_23_prc_2d_c_2d_name,140)
___DEF_PRM(160,___G_c_23_prc_2d_parms,142)
___DEF_PRM(158,___G_c_23_prc_2d_opts,144)
___DEF_PRM(154,___G_c_23_prc_2d_keys,146)
___DEF_PRM(163,___G_c_23_prc_2d_rest_3f_,148)
___DEF_PRM(157,___G_c_23_prc_2d_name_2d_set_21_,150)
___DEF_PRM(153,___G_c_23_prc_2d_c_2d_name_2d_set_21_,152)
___DEF_PRM(161,___G_c_23_prc_2d_parms_2d_set_21_,154)
___DEF_PRM(159,___G_c_23_prc_2d_opts_2d_set_21_,156)
___DEF_PRM(155,___G_c_23_prc_2d_keys_2d_set_21_,158)
___DEF_PRM(164,___G_c_23_prc_2d_rest_3f__2d_set_21_,160)
___DEF_PRM(96,___G_c_23_make_2d_app,162)
___DEF_PRM(37,___G_c_23_app_3f_,168)
___DEF_PRM(101,___G_c_23_make_2d_fut,170)
___DEF_PRM(80,___G_c_23_fut_3f_,176)
___DEF_PRM(131,___G_c_23_node_2d_children_2d_set_21_,178)
___DEF_PRM(135,___G_c_23_node_2d_fv_2d_invalidate_21_,184)
___DEF_PRM(112,___G_c_23_new_2d_cst,188)
___DEF_PRM(119,___G_c_23_new_2d_ref,194)
___DEF_PRM(120,___G_c_23_new_2d_ref_2d_extended_2d_bindings,201)
___DEF_PRM(122,___G_c_23_new_2d_set,207)
___DEF_PRM(215,___G_c_23_set_2d_val,215)
___DEF_PRM(113,___G_c_23_new_2d_def,221)
___DEF_PRM(63,___G_c_23_def_2d_val,229)
___DEF_PRM(124,___G_c_23_new_2d_tst,235)
___DEF_PRM(229,___G_c_23_tst_2d_pre,242)
___DEF_PRM(228,___G_c_23_tst_2d_con,248)
___DEF_PRM(227,___G_c_23_tst_2d_alt,254)
___DEF_PRM(111,___G_c_23_new_2d_conj,260)
___DEF_PRM(48,___G_c_23_conj_2d_pre,267)
___DEF_PRM(47,___G_c_23_conj_2d_alt,273)
___DEF_PRM(114,___G_c_23_new_2d_disj,279)
___DEF_PRM(70,___G_c_23_disj_2d_pre,286)
___DEF_PRM(69,___G_c_23_disj_2d_alt,292)
___DEF_PRM(118,___G_c_23_new_2d_prc,298)
___DEF_PRM(151,___G_c_23_prc_2d_body,307)
___DEF_PRM(162,___G_c_23_prc_2d_req_2d_and_2d_opt_2d_parms_2d_only_3f_,313)
___DEF_PRM(109,___G_c_23_new_2d_call,315)
___DEF_PRM(110,___G_c_23_new_2d_call_2a_,324)
___DEF_PRM(35,___G_c_23_app_2d_oper,327)
___DEF_PRM(34,___G_c_23_app_2d_args,333)
___DEF_PRM(144,___G_c_23_oper_2d_pos_3f_,339)
___DEF_PRM(116,___G_c_23_new_2d_fut,346)
___DEF_PRM(79,___G_c_23_fut_2d_val,353)
___DEF_PRM(115,___G_c_23_new_2d_disj_2d_call,359)
___DEF_PRM(121,___G_c_23_new_2d_seq,377)
___DEF_PRM(117,___G_c_23_new_2d_let,385)
___DEF_PRM(123,___G_c_23_new_2d_temp_2d_variable,392)
___DEF_PRM(126,___G_c_23_new_2d_variables,405)
___DEF_PRM(125,___G_c_23_new_2d_variable,413)
___DEF_PRM(213,___G_c_23_set_2d_prc_2d_names_21_,422)
___DEF_PRM(77,___G_c_23_free_2d_variables,429)
___DEF_PRM(42,___G_c_23_bound_2d_free_2d_variables,445)
___DEF_PRM(43,___G_c_23_bound_2d_variables,453)
___DEF_PRM(107,___G_c_23_mutable_3f_,456)
___DEF_PRM(44,___G_c_23_bound_3f_,461)
___DEF_PRM(84,___G_c_23_global_3f_,463)
___DEF_PRM(82,___G_c_23_global_2d_single_2d_def,468)
___DEF_PRM(81,___G_c_23_global_2d_proc_2d_obj,479)
___DEF_PRM(83,___G_c_23_global_2d_singly_2d_bound_3f_,486)
___DEF_PRM(33,___G_c_23_app_2d__3e_specialized_2d_proc,492)
___DEF_PRM(220,___G_c_23_specialize_2d_app,498)
___DEF_PRM(221,___G_c_23_specialize_2d_proc,506)
___DEF_PRM(108,___G_c_23_nb_2d_args_2d_conforms_3f_,525)
___DEF_PRM(210,___G_c_23_scheme_2d_dialect,528)
___DEF_PRM(52,___G_c_23_constant_2d_fold_3f_,531)
___DEF_PRM(91,___G_c_23_lambda_2d_lift_3f_,534)
___DEF_PRM(87,___G_c_23_inline_3f_,537)
___DEF_PRM(86,___G_c_23_inline_2d_primitive_3f_,540)
___DEF_PRM(29,___G_c_23_add_2d_not_2d_inline_2d_primitives,543)
___DEF_PRM(88,___G_c_23_inlining_2d_limit,547)
___DEF_PRM(41,___G_c_23_block_2d_compilation_3f_,552)
___DEF_PRM(53,___G_c_23_core_3f_,557)
___DEF_PRM(222,___G_c_23_standard_2d_binding_3f_,560)
___DEF_PRM(74,___G_c_23_extended_2d_binding_3f_,563)
___DEF_PRM(26,___G_c_23_add_2d_extended_2d_bindings,566)
___DEF_PRM(208,___G_c_23_run_2d_time_2d_binding_3f_,570)
___DEF_PRM(209,___G_c_23_safe_3f_,573)
___DEF_PRM(31,___G_c_23_add_2d_not_2d_safe,576)
___DEF_PRM(236,___G_c_23_warnings_3f_,580)
___DEF_PRM(89,___G_c_23_intrs_2d_enabled_3f_,583)
___DEF_PRM(30,___G_c_23_add_2d_not_2d_interrupts_2d_enabled,586)
___DEF_PRM(61,___G_c_23_debug_3f_,590)
___DEF_PRM(59,___G_c_23_debug_2d_location_3f_,593)
___DEF_PRM(60,___G_c_23_debug_2d_source_3f_,596)
___DEF_PRM(58,___G_c_23_debug_2d_environments_3f_,599)
___DEF_PRM(73,___G_c_23_environment_2d_map_3f_,602)
___DEF_PRM(174,___G_c_23_proper_2d_tail_2d_calls_3f_,605)
___DEF_PRM(32,___G_c_23_add_2d_proper_2d_tail_2d_calls,608)
___DEF_PRM(145,___G_c_23_optimize_2d_dead_2d_local_2d_variables_3f_,612)
___DEF_PRM(223,___G_c_23_standard_2d_proc_2d_obj,615)
___DEF_PRM(224,___G_c_23_standard_2d_procedure_3f_,624)
___DEF_PRM(150,___G_c_23_parse_2d_program,633)
___DEF_PRM(45,___G_c_23_check_2d_multiple_2d_global_2d_defs,734)
___DEF_PRM(199,___G_c_23_pt_2d_syntax_2d_error,750)
___DEF_PRM(175,___G_c_23_pt,756)
___DEF_PRM(94,___G_c_23_macro_2d_expand,823)
___DEF_PRM(196,___G_c_23_pt_2d_self_2d_eval,834)
___DEF_PRM(194,___G_c_23_pt_2d_quote,840)
___DEF_PRM(193,___G_c_23_pt_2d_quasiquote,847)
___DEF_PRM(191,___G_c_23_pt_2d_quasiquotation,852)
___DEF_PRM(192,___G_c_23_pt_2d_quasiquotation_2d_list,877)
___DEF_PRM(38,___G_c_23_append_2d_form,891)
___DEF_PRM(51,___G_c_23_cons_2d_form,904)
___DEF_PRM(235,___G_c_23_vector_2d_form,926)
___DEF_PRM(93,___G_c_23_list_2d_construction_3f_,941)
___DEF_PRM(200,___G_c_23_pt_2d_var,962)
___DEF_PRM(198,___G_c_23_pt_2d_set_21_,969)
___DEF_PRM(186,___G_c_23_pt_2d_lambda,979)
___DEF_PRM(147,___G_c_23_parameter_2d_name,1077)
___DEF_PRM(148,___G_c_23_parameter_2d_source,1079)
___DEF_PRM(146,___G_c_23_parameter_2d_default_2d_source,1081)
___DEF_PRM(76,___G_c_23_extract_2d_parameters,1083)
___DEF_PRM(219,___G_c_23_source_2d__3e_parms,1148)
___DEF_PRM(178,___G_c_23_pt_2d_body,1154)
___DEF_PRM(197,___G_c_23_pt_2d_sequence,1197)
___DEF_PRM(185,___G_c_23_pt_2d_if,1205)
___DEF_PRM(181,___G_c_23_pt_2d_cond,1214)
___DEF_PRM(176,___G_c_23_pt_2d_and,1238)
___DEF_PRM(190,___G_c_23_pt_2d_or,1251)
___DEF_PRM(179,___G_c_23_pt_2d_case,1264)
___DEF_PRM(187,___G_c_23_pt_2d_let,1300)
___DEF_PRM(188,___G_c_23_pt_2d_let_2a_,1358)
___DEF_PRM(189,___G_c_23_pt_2d_letrec,1376)
___DEF_PRM(195,___G_c_23_pt_2d_recursive_2d_let,1403)
___DEF_PRM(177,___G_c_23_pt_2d_begin,1466)
___DEF_PRM(183,___G_c_23_pt_2d_do,1471)
___DEF_PRM(180,___G_c_23_pt_2d_combination,1527)
___DEF_PRM(182,___G_c_23_pt_2d_delay,1543)
___DEF_PRM(184,___G_c_23_pt_2d_future,1557)
___DEF_PRM(211,___G_c_23_self_2d_eval_2d_expr_3f_,1563)
___DEF_PRM(212,___G_c_23_self_2d_evaluating_3f_,1568)
___DEF_PRM(22,___G_c_23__2a__2a_quote_2d_expr_3f_,1582)
___DEF_PRM(21,___G_c_23__2a__2a_quasiquote_2d_expr_3f_,1585)
___DEF_PRM(203,___G_c_23_quasiquote_2d_expr_3f_,1588)
___DEF_PRM(232,___G_c_23_unquote_2d_expr_3f_,1591)
___DEF_PRM(233,___G_c_23_unquote_2d_splicing_2d_expr_3f_,1594)
___DEF_PRM(234,___G_c_23_var_2d_expr_3f_,1597)
___DEF_PRM(143,___G_c_23_not_2d_macro,1604)
___DEF_PRM(40,___G_c_23_bindable_2d_var_3f_,1610)
___DEF_PRM(23,___G_c_23__2a__2a_set_21__2d_expr_3f_,1615)
___DEF_PRM(15,___G_c_23__2a__2a_lambda_2d_expr_3f_,1618)
___DEF_PRM(90,___G_c_23_lambda_2d_expr_3f_,1621)
___DEF_PRM(13,___G_c_23__2a__2a_if_2d_expr_3f_,1624)
___DEF_PRM(5,___G_c_23__2a__2a_cond_2d_expr_3f_,1633)
___DEF_PRM(1,___G_c_23__2a__2a_and_2d_expr_3f_,1639)
___DEF_PRM(20,___G_c_23__2a__2a_or_2d_expr_3f_,1642)
___DEF_PRM(4,___G_c_23__2a__2a_case_2d_expr_3f_,1645)
___DEF_PRM(17,___G_c_23__2a__2a_let_2d_expr_3f_,1651)
___DEF_PRM(16,___G_c_23__2a__2a_let_2a__2d_expr_3f_,1663)
___DEF_PRM(18,___G_c_23__2a__2a_letrec_2d_expr_3f_,1670)
___DEF_PRM(11,___G_c_23__2a__2a_do_2d_expr_3f_,1677)
___DEF_PRM(46,___G_c_23_combination_2d_expr_3f_,1684)
___DEF_PRM(10,___G_c_23__2a__2a_delay_2d_expr_3f_,1693)
___DEF_PRM(12,___G_c_23__2a__2a_future_2d_expr_3f_,1699)
___DEF_PRM(95,___G_c_23_macro_2d_expr_3f_,1705)
___DEF_PRM(2,___G_c_23__2a__2a_begin_2d_cmd_2d_or_2d_expr_3f_,1718)
___DEF_PRM(3,___G_c_23__2a__2a_begin_2d_expr_3f_,1721)
___DEF_PRM(7,___G_c_23__2a__2a_define_2d_expr_3f_,1724)
___DEF_PRM(8,___G_c_23__2a__2a_define_2d_macro_2d_expr_3f_,1727)
___DEF_PRM(9,___G_c_23__2a__2a_define_2d_syntax_2d_expr_3f_,1730)
___DEF_PRM(14,___G_c_23__2a__2a_include_2d_expr_3f_,1733)
___DEF_PRM(6,___G_c_23__2a__2a_declare_2d_expr_3f_,1742)
___DEF_PRM(19,___G_c_23__2a__2a_namespace_2d_expr_3f_,1745)
___DEF_PRM(106,___G_c_23_match,1748)
___DEF_PRM(85,___G_c_23_ill_2d_formed_2d_special_2d_form,1757)
___DEF_PRM(172,___G_c_23_proper_2d_length,1771)
___DEF_PRM(67,___G_c_23_definition_2d_name,1775)
___DEF_PRM(68,___G_c_23_definition_2d_value,1787)
___DEF_PRM(149,___G_c_23_parms_2d__3e_source,1803)
___DEF_PRM(169,___G_c_23_proper_2d_clauses_3f_,1806)
___DEF_PRM(168,___G_c_23_proper_2d_case_2d_clauses_3f_,1822)
___DEF_PRM(173,___G_c_23_proper_2d_selector_2d_list_3f_,1837)
___DEF_PRM(167,___G_c_23_proper_2d_bindings_3f_,1845)
___DEF_PRM(170,___G_c_23_proper_2d_do_2d_bindings_3f_,1864)
___DEF_PRM(171,___G_c_23_proper_2d_do_2d_exit_3f_,1884)
___DEF_PRM(39,___G_c_23_begin_2d_body,1892)
___DEF_PRM(92,___G_c_23_length_3f_,1897)
___DEF_PRM(226,___G_c_23_transform_2d_declaration,1900)
___DEF_PRM(75,___G_c_23_extract_2d_names,1943)
___DEF_PRM(25,___G_c_23_add_2d_declarations,1954)
___DEF_PRM(28,___G_c_23_add_2d_namespace,1963)
___DEF_PRM(27,___G_c_23_add_2d_macro,1987)
___DEF_PRM(201,___G_c_23_ptree_2e_begin_21_,2021)
___DEF_PRM(202,___G_c_23_ptree_2e_end_21_,2027)
___END_MOD1

___BEGIN_MOD2
___DEF_SYM2(0,___S_app_2d_tag,"app-tag")
___DEF_SYM2(1,___S_begin_2d_temp,"begin-temp")
___DEF_SYM2(2,___S_case_2d_temp,"case-temp")
___DEF_SYM2(3,___S_compilation_2d_strategy,"compilation-strategy")
___DEF_SYM2(4,___S_cond_2d_temp,"cond-temp")
___DEF_SYM2(5,___S_conj_2d_tag,"conj-tag")
___DEF_SYM2(6,___S_cst_2d_tag,"cst-tag")
___DEF_SYM2(7,___S_def_2d_tag,"def-tag")
___DEF_SYM2(8,___S_dialect,"dialect")
___DEF_SYM2(9,___S_disj_2d_tag,"disj-tag")
___DEF_SYM2(10,___S_do_2d_temp,"do-temp")
___DEF_SYM2(11,___S_dsssl,"dsssl")
___DEF_SYM2(12,___S_extended,"extended")
___DEF_SYM2(13,___S_fut_2d_tag,"fut-tag")
___DEF_SYM2(14,___S_ieee,"ieee")
___DEF_SYM2(15,___S_none,"none")
___DEF_SYM2(16,___S_prc_2d_tag,"prc-tag")
___DEF_SYM2(17,___S_pred,"pred")
___DEF_SYM2(18,___S_r4rs,"r4rs")
___DEF_SYM2(19,___S_r5rs,"r5rs")
___DEF_SYM2(20,___S_ref_2d_tag,"ref-tag")
___DEF_SYM2(21,___S_set_2d_tag,"set-tag")
___DEF_SYM2(22,___S_true,"true")
___DEF_SYM2(23,___S_tst_2d_tag,"tst-tag")
___END_MOD2

#endif
