#ifdef ___LINKER_INFO
; File: "_syntax-lib.c", produced by Gambit v4.9.5
(
409005
(C)
"_syntax-lib"
("_syntax-lib")
()
(("_syntax-lib"))
( #|*/"*/"symbols|#
"##begin"
"##define-macro"
"##define-top-level-syntax"
"##lambda"
"##plain-datum->core-syntax"
"##source-code"
"##syntax"
"##syntax-case"
"##syntax-rules"
"##with-syntax"
"..."
"_"
"_syntax-lib"
"_syntax-lib#"
"apply"
"args"
"b"
"body2"
"car"
"e"
"error"
"expander"
"k"
"list"
"name"
"p"
"params"
"patterns"
"qwe"
"s"
"stx"
"syntax->plain-datum"
"template"
) #|*/"*/"symbols|#
( #|*/"*/"keywords|#
) #|*/"*/"keywords|#
( #|*/"*/"globals-s-d|#
"_syntax-lib#"
) #|*/"*/"globals-s-d|#
( #|*/"*/"globals-s-nd|#
) #|*/"*/"globals-s-nd|#
( #|*/"*/"globals-ns|#
"##eval-for-syntax-binding"
"##make-syntax-source"
"##syntax-interaction-cte"
"add-scope"
"core-scope"
"plain-datum->core-syntax"
"top-hcte-add-macro-cte!"
) #|*/"*/"globals-ns|#
( #|*/"*/"meta-info|#
) #|*/"*/"meta-info|#
)
#else
#define ___VERSION 409005
#define ___MODULE_NAME "_syntax-lib"
#define ___LINKER_ID ___LNK___syntax_2d_lib
#define ___MH_PROC ___H___syntax_2d_lib
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 33
#define ___GLOCOUNT 8
#define ___SUPCOUNT 1
#define ___CNSCOUNT 143
#define ___SUBCOUNT 5
#define ___LBLCOUNT 18
#define ___MODDESCR ___REF_SUB(2)
#include "gambit.h"

___NEED_SYM(___S__23__23_begin)
___NEED_SYM(___S__23__23_define_2d_macro)
___NEED_SYM(___S__23__23_define_2d_top_2d_level_2d_syntax)
___NEED_SYM(___S__23__23_lambda)
___NEED_SYM(___S__23__23_plain_2d_datum_2d__3e_core_2d_syntax)
___NEED_SYM(___S__23__23_source_2d_code)
___NEED_SYM(___S__23__23_syntax)
___NEED_SYM(___S__23__23_syntax_2d_case)
___NEED_SYM(___S__23__23_syntax_2d_rules)
___NEED_SYM(___S__23__23_with_2d_syntax)
___NEED_SYM(___S__2e__2e__2e_)
___NEED_SYM(___S___)
___NEED_SYM(___S___syntax_2d_lib)
___NEED_SYM(___S___syntax_2d_lib_23_)
___NEED_SYM(___S_apply)
___NEED_SYM(___S_args)
___NEED_SYM(___S_b)
___NEED_SYM(___S_body2)
___NEED_SYM(___S_car)
___NEED_SYM(___S_e)
___NEED_SYM(___S_error)
___NEED_SYM(___S_expander)
___NEED_SYM(___S_k)
___NEED_SYM(___S_list)
___NEED_SYM(___S_name)
___NEED_SYM(___S_p)
___NEED_SYM(___S_params)
___NEED_SYM(___S_patterns)
___NEED_SYM(___S_qwe)
___NEED_SYM(___S_s)
___NEED_SYM(___S_stx)
___NEED_SYM(___S_syntax_2d__3e_plain_2d_datum)
___NEED_SYM(___S_template)

___NEED_GLO(___G__23__23_eval_2d_for_2d_syntax_2d_binding)
___NEED_GLO(___G__23__23_make_2d_syntax_2d_source)
___NEED_GLO(___G__23__23_syntax_2d_interaction_2d_cte)
___NEED_GLO(___G___syntax_2d_lib_23_)
___NEED_GLO(___G_add_2d_scope)
___NEED_GLO(___G_core_2d_scope)
___NEED_GLO(___G_plain_2d_datum_2d__3e_core_2d_syntax)
___NEED_GLO(___G_top_2d_hcte_2d_add_2d_macro_2d_cte_21_)

___BEGIN_SYM
___DEF_SYM(0,___S__23__23_begin,"##begin")
___DEF_SYM(1,___S__23__23_define_2d_macro,"##define-macro")
___DEF_SYM(2,___S__23__23_define_2d_top_2d_level_2d_syntax,"##define-top-level-syntax")
___DEF_SYM(3,___S__23__23_lambda,"##lambda")
___DEF_SYM(4,___S__23__23_plain_2d_datum_2d__3e_core_2d_syntax,"##plain-datum->core-syntax")
___DEF_SYM(5,___S__23__23_source_2d_code,"##source-code")
___DEF_SYM(6,___S__23__23_syntax,"##syntax")
___DEF_SYM(7,___S__23__23_syntax_2d_case,"##syntax-case")
___DEF_SYM(8,___S__23__23_syntax_2d_rules,"##syntax-rules")
___DEF_SYM(9,___S__23__23_with_2d_syntax,"##with-syntax")
___DEF_SYM(10,___S__2e__2e__2e_,"...")
___DEF_SYM(11,___S___,"_")
___DEF_SYM(12,___S___syntax_2d_lib,"_syntax-lib")
___DEF_SYM(13,___S___syntax_2d_lib_23_,"_syntax-lib#")
___DEF_SYM(14,___S_apply,"apply")
___DEF_SYM(15,___S_args,"args")
___DEF_SYM(16,___S_b,"b")
___DEF_SYM(17,___S_body2,"body2")
___DEF_SYM(18,___S_car,"car")
___DEF_SYM(19,___S_e,"e")
___DEF_SYM(20,___S_error,"error")
___DEF_SYM(21,___S_expander,"expander")
___DEF_SYM(22,___S_k,"k")
___DEF_SYM(23,___S_list,"list")
___DEF_SYM(24,___S_name,"name")
___DEF_SYM(25,___S_p,"p")
___DEF_SYM(26,___S_params,"params")
___DEF_SYM(27,___S_patterns,"patterns")
___DEF_SYM(28,___S_qwe,"qwe")
___DEF_SYM(29,___S_s,"s")
___DEF_SYM(30,___S_stx,"stx")
___DEF_SYM(31,___S_syntax_2d__3e_plain_2d_datum,"syntax->plain-datum")
___DEF_SYM(32,___S_template,"template")
___END_SYM

#define ___SYM__23__23_begin ___SYM(0,___S__23__23_begin)
#define ___SYM__23__23_define_2d_macro ___SYM(1,___S__23__23_define_2d_macro)
#define ___SYM__23__23_define_2d_top_2d_level_2d_syntax ___SYM(2,___S__23__23_define_2d_top_2d_level_2d_syntax)
#define ___SYM__23__23_lambda ___SYM(3,___S__23__23_lambda)
#define ___SYM__23__23_plain_2d_datum_2d__3e_core_2d_syntax ___SYM(4,___S__23__23_plain_2d_datum_2d__3e_core_2d_syntax)
#define ___SYM__23__23_source_2d_code ___SYM(5,___S__23__23_source_2d_code)
#define ___SYM__23__23_syntax ___SYM(6,___S__23__23_syntax)
#define ___SYM__23__23_syntax_2d_case ___SYM(7,___S__23__23_syntax_2d_case)
#define ___SYM__23__23_syntax_2d_rules ___SYM(8,___S__23__23_syntax_2d_rules)
#define ___SYM__23__23_with_2d_syntax ___SYM(9,___S__23__23_with_2d_syntax)
#define ___SYM__2e__2e__2e_ ___SYM(10,___S__2e__2e__2e_)
#define ___SYM___ ___SYM(11,___S___)
#define ___SYM___syntax_2d_lib ___SYM(12,___S___syntax_2d_lib)
#define ___SYM___syntax_2d_lib_23_ ___SYM(13,___S___syntax_2d_lib_23_)
#define ___SYM_apply ___SYM(14,___S_apply)
#define ___SYM_args ___SYM(15,___S_args)
#define ___SYM_b ___SYM(16,___S_b)
#define ___SYM_body2 ___SYM(17,___S_body2)
#define ___SYM_car ___SYM(18,___S_car)
#define ___SYM_e ___SYM(19,___S_e)
#define ___SYM_error ___SYM(20,___S_error)
#define ___SYM_expander ___SYM(21,___S_expander)
#define ___SYM_k ___SYM(22,___S_k)
#define ___SYM_list ___SYM(23,___S_list)
#define ___SYM_name ___SYM(24,___S_name)
#define ___SYM_p ___SYM(25,___S_p)
#define ___SYM_params ___SYM(26,___S_params)
#define ___SYM_patterns ___SYM(27,___S_patterns)
#define ___SYM_qwe ___SYM(28,___S_qwe)
#define ___SYM_s ___SYM(29,___S_s)
#define ___SYM_stx ___SYM(30,___S_stx)
#define ___SYM_syntax_2d__3e_plain_2d_datum ___SYM(31,___S_syntax_2d__3e_plain_2d_datum)
#define ___SYM_template ___SYM(32,___S_template)

___BEGIN_GLO
___DEF_GLO(0,"_syntax-lib#")
___DEF_GLO(1,"##eval-for-syntax-binding")
___DEF_GLO(2,"##make-syntax-source")
___DEF_GLO(3,"##syntax-interaction-cte")
___DEF_GLO(4,"add-scope")
___DEF_GLO(5,"core-scope")
___DEF_GLO(6,"plain-datum->core-syntax")
___DEF_GLO(7,"top-hcte-add-macro-cte!")
___END_GLO

#define ___GLO___syntax_2d_lib_23_ ___GLO(0,___G___syntax_2d_lib_23_)
#define ___PRM___syntax_2d_lib_23_ ___PRM(0,___G___syntax_2d_lib_23_)
#define ___GLO__23__23_eval_2d_for_2d_syntax_2d_binding ___GLO(1,___G__23__23_eval_2d_for_2d_syntax_2d_binding)
#define ___PRM__23__23_eval_2d_for_2d_syntax_2d_binding ___PRM(1,___G__23__23_eval_2d_for_2d_syntax_2d_binding)
#define ___GLO__23__23_make_2d_syntax_2d_source ___GLO(2,___G__23__23_make_2d_syntax_2d_source)
#define ___PRM__23__23_make_2d_syntax_2d_source ___PRM(2,___G__23__23_make_2d_syntax_2d_source)
#define ___GLO__23__23_syntax_2d_interaction_2d_cte ___GLO(3,___G__23__23_syntax_2d_interaction_2d_cte)
#define ___PRM__23__23_syntax_2d_interaction_2d_cte ___PRM(3,___G__23__23_syntax_2d_interaction_2d_cte)
#define ___GLO_add_2d_scope ___GLO(4,___G_add_2d_scope)
#define ___PRM_add_2d_scope ___PRM(4,___G_add_2d_scope)
#define ___GLO_core_2d_scope ___GLO(5,___G_core_2d_scope)
#define ___PRM_core_2d_scope ___PRM(5,___G_core_2d_scope)
#define ___GLO_plain_2d_datum_2d__3e_core_2d_syntax ___GLO(6,___G_plain_2d_datum_2d__3e_core_2d_syntax)
#define ___PRM_plain_2d_datum_2d__3e_core_2d_syntax ___PRM(6,___G_plain_2d_datum_2d__3e_core_2d_syntax)
#define ___GLO_top_2d_hcte_2d_add_2d_macro_2d_cte_21_ ___GLO(7,___G_top_2d_hcte_2d_add_2d_macro_2d_cte_21_)
#define ___PRM_top_2d_hcte_2d_add_2d_macro_2d_cte_21_ ___PRM(7,___G_top_2d_hcte_2d_add_2d_macro_2d_cte_21_)

___BEGIN_CNS
 ___DEF_CNS(___REF_SYM(3,___S__23__23_lambda),___REF_CNS(1))
,___DEF_CNS(___REF_CNS(2),___REF_CNS(3))
,___DEF_CNS(___REF_SYM(30,___S_stx),___REF_NUL)
,___DEF_CNS(___REF_CNS(4),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_syntax_2d_case),___REF_CNS(5))
,___DEF_CNS(___REF_SYM(30,___S_stx),___REF_CNS(6))
,___DEF_CNS(___REF_NUL,___REF_CNS(7))
,___DEF_CNS(___REF_CNS(8),___REF_NUL)
,___DEF_CNS(___REF_CNS(9),___REF_CNS(17))
,___DEF_CNS(___REF_SYM(11,___S___),___REF_CNS(10))
,___DEF_CNS(___REF_CNS(11),___REF_CNS(13))
,___DEF_CNS(___REF_SYM(22,___S_k),___REF_CNS(12))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(14),___REF_CNS(16))
,___DEF_CNS(___REF_SYM(27,___S_patterns),___REF_CNS(15))
,___DEF_CNS(___REF_SYM(32,___S_template),___REF_NUL)
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(18),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(19))
,___DEF_CNS(___REF_CNS(20),___REF_NUL)
,___DEF_CNS(___REF_SYM(3,___S__23__23_lambda),___REF_CNS(21))
,___DEF_CNS(___REF_CNS(22),___REF_CNS(23))
,___DEF_CNS(___REF_SYM(30,___S_stx),___REF_NUL)
,___DEF_CNS(___REF_CNS(24),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_syntax_2d_case),___REF_CNS(25))
,___DEF_CNS(___REF_SYM(30,___S_stx),___REF_CNS(26))
,___DEF_CNS(___REF_CNS(27),___REF_CNS(29))
,___DEF_CNS(___REF_SYM(22,___S_k),___REF_CNS(28))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(30),___REF_CNS(34))
,___DEF_CNS(___REF_SYM(27,___S_patterns),___REF_CNS(31))
,___DEF_CNS(___REF_CNS(32),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(33))
,___DEF_CNS(___REF_SYM(32,___S_template),___REF_NUL)
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_SYM(3,___S__23__23_lambda),___REF_CNS(36))
,___DEF_CNS(___REF_CNS(37),___REF_CNS(38))
,___DEF_CNS(___REF_SYM(30,___S_stx),___REF_NUL)
,___DEF_CNS(___REF_CNS(39),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_syntax_2d_case),___REF_CNS(40))
,___DEF_CNS(___REF_SYM(30,___S_stx),___REF_CNS(41))
,___DEF_CNS(___REF_NUL,___REF_CNS(42))
,___DEF_CNS(___REF_CNS(43),___REF_NUL)
,___DEF_CNS(___REF_CNS(44),___REF_CNS(52))
,___DEF_CNS(___REF_SYM(11,___S___),___REF_CNS(45))
,___DEF_CNS(___REF_CNS(46),___REF_CNS(50))
,___DEF_CNS(___REF_CNS(47),___REF_CNS(49))
,___DEF_CNS(___REF_SYM(25,___S_p),___REF_CNS(48))
,___DEF_CNS(___REF_SYM(19,___S_e),___REF_NUL)
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_SYM(16,___S_b),___REF_CNS(51))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(53),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(54))
,___DEF_CNS(___REF_CNS(55),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_syntax_2d_case),___REF_CNS(56))
,___DEF_CNS(___REF_CNS(57),___REF_CNS(60))
,___DEF_CNS(___REF_SYM(23,___S_list),___REF_CNS(58))
,___DEF_CNS(___REF_SYM(19,___S_e),___REF_CNS(59))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_NUL,___REF_CNS(61))
,___DEF_CNS(___REF_CNS(62),___REF_NUL)
,___DEF_CNS(___REF_CNS(63),___REF_CNS(65))
,___DEF_CNS(___REF_SYM(25,___S_p),___REF_CNS(64))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(66),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(67))
,___DEF_CNS(___REF_CNS(68),___REF_NUL)
,___DEF_CNS(___REF_SYM(0,___S__23__23_begin),___REF_CNS(69))
,___DEF_CNS(___REF_SYM(16,___S_b),___REF_CNS(70))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_SYM(3,___S__23__23_lambda),___REF_CNS(72))
,___DEF_CNS(___REF_CNS(73),___REF_CNS(74))
,___DEF_CNS(___REF_SYM(29,___S_s),___REF_NUL)
,___DEF_CNS(___REF_CNS(75),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_syntax_2d_case),___REF_CNS(76))
,___DEF_CNS(___REF_SYM(29,___S_s),___REF_CNS(77))
,___DEF_CNS(___REF_NUL,___REF_CNS(78))
,___DEF_CNS(___REF_CNS(79),___REF_CNS(95))
,___DEF_CNS(___REF_CNS(80),___REF_CNS(85))
,___DEF_CNS(___REF_SYM(1,___S__23__23_define_2d_macro),___REF_CNS(81))
,___DEF_CNS(___REF_CNS(82),___REF_CNS(83))
,___DEF_CNS(___REF_SYM(24,___S_name),___REF_SYM(26,___S_params))
,___DEF_CNS(___REF_SYM(17,___S_body2),___REF_CNS(84))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(86),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(87))
,___DEF_CNS(___REF_CNS(88),___REF_NUL)
,___DEF_CNS(___REF_SYM(1,___S__23__23_define_2d_macro),___REF_CNS(89))
,___DEF_CNS(___REF_SYM(24,___S_name),___REF_CNS(90))
,___DEF_CNS(___REF_CNS(91),___REF_NUL)
,___DEF_CNS(___REF_SYM(3,___S__23__23_lambda),___REF_CNS(92))
,___DEF_CNS(___REF_SYM(26,___S_params),___REF_CNS(93))
,___DEF_CNS(___REF_SYM(17,___S_body2),___REF_CNS(94))
,___DEF_CNS(___REF_SYM(10,___S__2e__2e__2e_),___REF_NUL)
,___DEF_CNS(___REF_CNS(96),___REF_CNS(138))
,___DEF_CNS(___REF_CNS(97),___REF_CNS(100))
,___DEF_CNS(___REF_SYM(11,___S___),___REF_CNS(98))
,___DEF_CNS(___REF_SYM(24,___S_name),___REF_CNS(99))
,___DEF_CNS(___REF_SYM(21,___S_expander),___REF_NUL)
,___DEF_CNS(___REF_CNS(101),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(102))
,___DEF_CNS(___REF_CNS(103),___REF_NUL)
,___DEF_CNS(___REF_SYM(2,___S__23__23_define_2d_top_2d_level_2d_syntax),___REF_CNS(104))
,___DEF_CNS(___REF_SYM(24,___S_name),___REF_CNS(105))
,___DEF_CNS(___REF_CNS(106),___REF_NUL)
,___DEF_CNS(___REF_SYM(3,___S__23__23_lambda),___REF_CNS(107))
,___DEF_CNS(___REF_CNS(108),___REF_CNS(109))
,___DEF_CNS(___REF_SYM(29,___S_s),___REF_NUL)
,___DEF_CNS(___REF_CNS(110),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_syntax_2d_case),___REF_CNS(111))
,___DEF_CNS(___REF_SYM(29,___S_s),___REF_CNS(112))
,___DEF_CNS(___REF_CNS(113),___REF_CNS(114))
,___DEF_CNS(___REF_SYM(28,___S_qwe),___REF_NUL)
,___DEF_CNS(___REF_CNS(115),___REF_CNS(132))
,___DEF_CNS(___REF_CNS(116),___REF_CNS(117))
,___DEF_CNS(___REF_SYM(11,___S___),___REF_SYM(15,___S_args))
,___DEF_CNS(___REF_CNS(118),___REF_NUL)
,___DEF_CNS(___REF_SYM(4,___S__23__23_plain_2d_datum_2d__3e_core_2d_syntax),___REF_CNS(119))
,___DEF_CNS(___REF_CNS(120),___REF_CNS(127))
,___DEF_CNS(___REF_SYM(14,___S_apply),___REF_CNS(121))
,___DEF_CNS(___REF_SYM(21,___S_expander),___REF_CNS(122))
,___DEF_CNS(___REF_CNS(123),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_syntax_2d__3e_plain_2d_datum),___REF_CNS(124))
,___DEF_CNS(___REF_CNS(125),___REF_NUL)
,___DEF_CNS(___REF_SYM(6,___S__23__23_syntax),___REF_CNS(126))
,___DEF_CNS(___REF_SYM(15,___S_args),___REF_NUL)
,___DEF_CNS(___REF_CNS(128),___REF_NUL)
,___DEF_CNS(___REF_SYM(18,___S_car),___REF_CNS(129))
,___DEF_CNS(___REF_CNS(130),___REF_NUL)
,___DEF_CNS(___REF_SYM(5,___S__23__23_source_2d_code),___REF_CNS(131))
,___DEF_CNS(___REF_SYM(29,___S_s),___REF_NUL)
,___DEF_CNS(___REF_CNS(133),___REF_NUL)
,___DEF_CNS(___REF_SYM(11,___S___),___REF_CNS(134))
,___DEF_CNS(___REF_CNS(135),___REF_NUL)
,___DEF_CNS(___REF_SYM(20,___S_error),___REF_CNS(136))
,___DEF_CNS(___REF_SUB(0),___REF_CNS(137))
,___DEF_CNS(___REF_SYM(29,___S_s),___REF_NUL)
,___DEF_CNS(___REF_CNS(139),___REF_NUL)
,___DEF_CNS(___REF_SYM(11,___S___),___REF_CNS(140))
,___DEF_CNS(___REF_CNS(141),___REF_NUL)
,___DEF_CNS(___REF_SYM(20,___S_error),___REF_CNS(142))
,___DEF_CNS(___REF_SUB(1),___REF_NUL)
___END_CNS

___DEF_SUB_STR(___X0,35UL)
               ___STR8(100,101,102,105,110,101,45,109)
               ___STR8(97,99,114,111,58,32,105,108)
               ___STR8(108,32,102,111,114,109,101,100)
               ___STR8(32,109,97,99,114,111,32,99)
               ___STR3(97,108,108)
___DEF_SUB_STR(___X1,30UL)
               ___STR8(105,108,108,45,102,111,114,109)
               ___STR8(101,100,32,102,111,114,109,32)
               ___STR8(58,32,100,101,102,105,110,101)
               ___STR6(45,109,97,99,114,111)
___DEF_SUB_VEC(___X2,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SUB(4))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X3,1UL)
               ___VEC1(___REF_SYM(12,___S___syntax_2d_lib))
               ___VEC0
___DEF_SUB_VEC(___X4,0UL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
,___DEF_SUB(___X2)
,___DEF_SUB(___X3)
,___DEF_SUB(___X4)
___END_SUB



#undef ___MD_ALL
#define ___MD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___syntax_2d_lib_23_)
___DEF_M_HLBL(___L1___syntax_2d_lib_23_)
___DEF_M_HLBL(___L2___syntax_2d_lib_23_)
___DEF_M_HLBL(___L3___syntax_2d_lib_23_)
___DEF_M_HLBL(___L4___syntax_2d_lib_23_)
___DEF_M_HLBL(___L5___syntax_2d_lib_23_)
___DEF_M_HLBL(___L6___syntax_2d_lib_23_)
___DEF_M_HLBL(___L7___syntax_2d_lib_23_)
___DEF_M_HLBL(___L8___syntax_2d_lib_23_)
___DEF_M_HLBL(___L9___syntax_2d_lib_23_)
___DEF_M_HLBL(___L10___syntax_2d_lib_23_)
___DEF_M_HLBL(___L11___syntax_2d_lib_23_)
___DEF_M_HLBL(___L12___syntax_2d_lib_23_)
___DEF_M_HLBL(___L13___syntax_2d_lib_23_)
___DEF_M_HLBL(___L14___syntax_2d_lib_23_)
___DEF_M_HLBL(___L15___syntax_2d_lib_23_)
___DEF_M_HLBL(___L16___syntax_2d_lib_23_)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___syntax_2d_lib_23_
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
___DEF_P_HLBL(___L0___syntax_2d_lib_23_)
___DEF_P_HLBL(___L1___syntax_2d_lib_23_)
___DEF_P_HLBL(___L2___syntax_2d_lib_23_)
___DEF_P_HLBL(___L3___syntax_2d_lib_23_)
___DEF_P_HLBL(___L4___syntax_2d_lib_23_)
___DEF_P_HLBL(___L5___syntax_2d_lib_23_)
___DEF_P_HLBL(___L6___syntax_2d_lib_23_)
___DEF_P_HLBL(___L7___syntax_2d_lib_23_)
___DEF_P_HLBL(___L8___syntax_2d_lib_23_)
___DEF_P_HLBL(___L9___syntax_2d_lib_23_)
___DEF_P_HLBL(___L10___syntax_2d_lib_23_)
___DEF_P_HLBL(___L11___syntax_2d_lib_23_)
___DEF_P_HLBL(___L12___syntax_2d_lib_23_)
___DEF_P_HLBL(___L13___syntax_2d_lib_23_)
___DEF_P_HLBL(___L14___syntax_2d_lib_23_)
___DEF_P_HLBL(___L15___syntax_2d_lib_23_)
___DEF_P_HLBL(___L16___syntax_2d_lib_23_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___syntax_2d_lib_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___syntax_2d_lib_23_)
   ___SET_STK(1,___R0)
   ___SET_R2(___FAL)
   ___SET_R1(___SYM__23__23_syntax_2d_rules)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1___syntax_2d_lib_23_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),2,___G__23__23_make_2d_syntax_2d_source)
___DEF_SLBL(2,___L2___syntax_2d_lib_23_)
   ___SET_R2(___GLO_core_2d_scope)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),4,___G_add_2d_scope)
___DEF_SLBL(3,___L3___syntax_2d_lib_23_)
   ___SET_STK(-2,___R1)
   ___SET_R1(___CNS(0))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),6,___G_plain_2d_datum_2d__3e_core_2d_syntax)
___DEF_SLBL(4,___L4___syntax_2d_lib_23_)
   ___SET_R2(___GLO__23__23_syntax_2d_interaction_2d_cte)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),1,___G__23__23_eval_2d_for_2d_syntax_2d_binding)
___DEF_SLBL(5,___L5___syntax_2d_lib_23_)
   ___SET_R3(___R1)
   ___SET_R1(___GLO__23__23_syntax_2d_interaction_2d_cte)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),7,___G_top_2d_hcte_2d_add_2d_macro_2d_cte_21_)
___DEF_SLBL(6,___L6___syntax_2d_lib_23_)
   ___SET_R2(___FAL)
   ___SET_R1(___SYM__23__23_with_2d_syntax)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),2,___G__23__23_make_2d_syntax_2d_source)
___DEF_SLBL(7,___L7___syntax_2d_lib_23_)
   ___SET_R2(___GLO_core_2d_scope)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),4,___G_add_2d_scope)
___DEF_SLBL(8,___L8___syntax_2d_lib_23_)
   ___SET_STK(-2,___R1)
   ___SET_R1(___CNS(35))
   ___SET_R0(___LBL(9))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),6,___G_plain_2d_datum_2d__3e_core_2d_syntax)
___DEF_SLBL(9,___L9___syntax_2d_lib_23_)
   ___SET_R2(___GLO__23__23_syntax_2d_interaction_2d_cte)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),1,___G__23__23_eval_2d_for_2d_syntax_2d_binding)
___DEF_SLBL(10,___L10___syntax_2d_lib_23_)
   ___SET_R3(___R1)
   ___SET_R1(___GLO__23__23_syntax_2d_interaction_2d_cte)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(11))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),7,___G_top_2d_hcte_2d_add_2d_macro_2d_cte_21_)
___DEF_SLBL(11,___L11___syntax_2d_lib_23_)
   ___SET_R2(___FAL)
   ___SET_R1(___SYM__23__23_define_2d_macro)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),2,___G__23__23_make_2d_syntax_2d_source)
___DEF_SLBL(12,___L12___syntax_2d_lib_23_)
   ___SET_R2(___GLO_core_2d_scope)
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),4,___G_add_2d_scope)
___DEF_SLBL(13,___L13___syntax_2d_lib_23_)
   ___SET_STK(-2,___R1)
   ___SET_R1(___CNS(71))
   ___SET_R0(___LBL(14))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),6,___G_plain_2d_datum_2d__3e_core_2d_syntax)
___DEF_SLBL(14,___L14___syntax_2d_lib_23_)
   ___SET_R2(___GLO__23__23_syntax_2d_interaction_2d_cte)
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),1,___G__23__23_eval_2d_for_2d_syntax_2d_binding)
___DEF_SLBL(15,___L15___syntax_2d_lib_23_)
   ___SET_R3(___R1)
   ___SET_R1(___GLO__23__23_syntax_2d_interaction_2d_cte)
   ___SET_R0(___STK(-7))
   ___SET_R2(___STK(-6))
   ___POLL(16)
___DEF_SLBL(16,___L16___syntax_2d_lib_23_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),7,___G_top_2d_hcte_2d_add_2d_macro_2d_cte_21_)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___syntax_2d_lib_23_,___REF_SYM(13,___S___syntax_2d_lib_23_),___REF_FAL,17,0)
,___DEF_LBL_PROC(___H___syntax_2d_lib_23_,0,-1)
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___syntax_2d_lib_23_,___IFD(___RETI,8,8,0x3f02L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___syntax_2d_lib_23_,1)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___syntax_2d_lib_23_,1)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S__23__23_begin,"##begin")
___DEF_MOD_SYM(1,___S__23__23_define_2d_macro,"##define-macro")
___DEF_MOD_SYM(2,___S__23__23_define_2d_top_2d_level_2d_syntax,"##define-top-level-syntax")
___DEF_MOD_SYM(3,___S__23__23_lambda,"##lambda")
___DEF_MOD_SYM(4,___S__23__23_plain_2d_datum_2d__3e_core_2d_syntax,"##plain-datum->core-syntax")
___DEF_MOD_SYM(5,___S__23__23_source_2d_code,"##source-code")
___DEF_MOD_SYM(6,___S__23__23_syntax,"##syntax")
___DEF_MOD_SYM(7,___S__23__23_syntax_2d_case,"##syntax-case")
___DEF_MOD_SYM(8,___S__23__23_syntax_2d_rules,"##syntax-rules")
___DEF_MOD_SYM(9,___S__23__23_with_2d_syntax,"##with-syntax")
___DEF_MOD_SYM(10,___S__2e__2e__2e_,"...")
___DEF_MOD_SYM(11,___S___,"_")
___DEF_MOD_SYM(12,___S___syntax_2d_lib,"_syntax-lib")
___DEF_MOD_SYM(13,___S___syntax_2d_lib_23_,"_syntax-lib#")
___DEF_MOD_SYM(14,___S_apply,"apply")
___DEF_MOD_SYM(15,___S_args,"args")
___DEF_MOD_SYM(16,___S_b,"b")
___DEF_MOD_SYM(17,___S_body2,"body2")
___DEF_MOD_SYM(18,___S_car,"car")
___DEF_MOD_SYM(19,___S_e,"e")
___DEF_MOD_SYM(20,___S_error,"error")
___DEF_MOD_SYM(21,___S_expander,"expander")
___DEF_MOD_SYM(22,___S_k,"k")
___DEF_MOD_SYM(23,___S_list,"list")
___DEF_MOD_SYM(24,___S_name,"name")
___DEF_MOD_SYM(25,___S_p,"p")
___DEF_MOD_SYM(26,___S_params,"params")
___DEF_MOD_SYM(27,___S_patterns,"patterns")
___DEF_MOD_SYM(28,___S_qwe,"qwe")
___DEF_MOD_SYM(29,___S_s,"s")
___DEF_MOD_SYM(30,___S_stx,"stx")
___DEF_MOD_SYM(31,___S_syntax_2d__3e_plain_2d_datum,"syntax->plain-datum")
___DEF_MOD_SYM(32,___S_template,"template")
___END_MOD_SYM_KEY

#endif
