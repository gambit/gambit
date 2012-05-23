#ifdef ___LINKER_INFO
; File: "_codegen.c", produced by Gambit-C v4.6.6
(
406006
" _codegen"
(" _codegen")
(
"codegen-context"
)
(
)
(
" _codegen"
"_codegen#codegen-context-arch-set!"
"_codegen#codegen-context-fixup-list-set!"
"_codegen#codegen-context-listing-format-set!"
)
(
"_codegen#codegen-context-arch"
"_codegen#codegen-context-fixup-list"
"_codegen#codegen-context-listing-format"
"_codegen#make-codegen-context"
)
(
"+"
"make-vector"
"vector-ref"
"vector-set!"
)
 #f
)
#else
#define ___VERSION 406006
#define ___MODULE_NAME " _codegen"
#define ___LINKER_ID ____20___codegen
#define ___MH_PROC ___H__20___codegen
#define ___SCRIPT_LINE 0
#define ___SYM_COUNT 1
#define ___GLO_COUNT 12
#define ___SUP_COUNT 8
#define ___LBL_COUNT 48
#include "gambit.h"

___NEED_SYM(___S_codegen_2d_context)

___NEED_GLO(___G__20___codegen)
___NEED_GLO(___G__2b_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_arch)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___NEED_GLO(___G___codegen_23_make_2d_codegen_2d_context)
___NEED_GLO(___G_make_2d_vector)
___NEED_GLO(___G_vector_2d_ref)
___NEED_GLO(___G_vector_2d_set_21_)

___BEGIN_SYM1
___DEF_SYM1(0,___S_codegen_2d_context,"codegen-context")
___END_SYM1

___BEGIN_GLO
___DEF_GLO(0," _codegen")
___DEF_GLO(1,"_codegen#codegen-context-arch")
___DEF_GLO(2,"_codegen#codegen-context-arch-set!")

___DEF_GLO(3,"_codegen#codegen-context-fixup-list")

___DEF_GLO(4,"_codegen#codegen-context-fixup-list-set!")

___DEF_GLO(5,"_codegen#codegen-context-listing-format")

___DEF_GLO(6,"_codegen#codegen-context-listing-format-set!")

___DEF_GLO(7,"_codegen#make-codegen-context")
___DEF_GLO(8,"+")
___DEF_GLO(9,"make-vector")
___DEF_GLO(10,"vector-ref")
___DEF_GLO(11,"vector-set!")
___END_GLO


#undef ___MD_ALL
#define ___MD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___codegen)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L1___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L2___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L3___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L4___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L5___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L6___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L7___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L8___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L4___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L4___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L4___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L4___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L4___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L4___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___codegen
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___codegen)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___codegen)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___codegen)
   ___SET_GLO(7,___G___codegen_23_make_2d_codegen_2d_context,___PRC(3))
   ___SET_GLO(5,___G___codegen_23_codegen_2d_context_2d_listing_2d_format,___PRC(13))
   ___SET_GLO(6,___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___PRC(19))
   ___SET_GLO(1,___G___codegen_23_codegen_2d_context_2d_arch,___PRC(25))
   ___SET_GLO(2,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___PRC(31))
   ___SET_GLO(3,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list,___PRC(37))
   ___SET_GLO(4,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___PRC(43))
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_make_2d_codegen_2d_context
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L1___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L2___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L3___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L4___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L5___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L6___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L7___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L8___codegen_23_make_2d_codegen_2d_context)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_make_2d_codegen_2d_context)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___codegen_23_make_2d_codegen_2d_context)
   ___SET_STK(1,___R0)
   ___ADJFP(1)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L10___codegen_23_make_2d_codegen_2d_context)
   ___END_IF
   ___SET_R1(___FIX(7L))
   ___GOTO(___L9___codegen_23_make_2d_codegen_2d_context)
___DEF_SLBL(1,___L1___codegen_23_make_2d_codegen_2d_context)
   ___ADJFP(-3)
___DEF_GLBL(___L9___codegen_23_make_2d_codegen_2d_context)
   ___SET_R2(___SYM(0,___S_codegen_2d_context))
   ___SET_R0(___LBL(3))
   ___ADJFP(3)
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_make_2d_codegen_2d_context)
   ___JUMPGLOSAFE(___SET_NARGS(2),9,___G_make_2d_vector)
___DEF_SLBL(3,___L3___codegen_23_make_2d_codegen_2d_context)
   ___SET_STK(-2,___R1)
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPGLOSAFE(___SET_NARGS(2),6,___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_SLBL(4,___L4___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(5))
   ___JUMPGLOSAFE(___SET_NARGS(2),2,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_SLBL(5,___L5___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___NUL)
   ___SET_R0(___LBL(6))
   ___JUMPGLOSAFE(___SET_NARGS(2),4,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_SLBL(6,___L6___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7___codegen_23_make_2d_codegen_2d_context)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L10___codegen_23_make_2d_codegen_2d_context)
   ___SET_R2(___FIX(3L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(3)
   ___POLL(8)
___DEF_SLBL(8,___L8___codegen_23_make_2d_codegen_2d_context)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_listing_2d_format
#undef ___PH_LBL0
#define ___PH_LBL0 13
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L4___codegen_23_codegen_2d_context_2d_listing_2d_format)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L7___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
   ___SET_R2(___FIX(4L))
   ___IF(___EQP(___GLO(10,___G_vector_2d_ref),___PRM(10,___G_vector_2d_ref)))
   ___GOTO(___L5___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___NOT(___EQP(___GLO(10,___G_vector_2d_ref),___PRM(10,___G_vector_2d_ref))))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
___DEF_GLBL(___L5___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R2)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
   ___IF(___NOT(___FIXLE(___FIX(0L),___R2)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
   ___SET_R3(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R2,___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___END_IF
   ___SET_R1(___VECTORREF(___R1,___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___JUMPGLOSAFE(___SET_NARGS(2),10,___G_vector_2d_ref)
___DEF_GLBL(___L7___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 19
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_P_HLBL(___L4___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L7___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___SET_R3(___FIX(4L))
   ___IF(___EQP(___GLO(11,___G_vector_2d_set_21_),___PRM(11,___G_vector_2d_set_21_)))
   ___GOTO(___L5___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___NOT(___EQP(___GLO(11,___G_vector_2d_set_21_),___PRM(11,___G_vector_2d_set_21_))))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
___DEF_GLBL(___L5___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___SUBTYPEDMUTABLEP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___FIXLE(___FIX(0L),___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___SET_R4(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R3,___R4)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___END_IF
   ___VECTORSET(___R1,___R3,___R2)
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___ADJFP(-1)
   ___JUMPGLOSAFE(___SET_NARGS(3),11,___G_vector_2d_set_21_)
___DEF_GLBL(___L7___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_arch
#undef ___PH_LBL0
#define ___PH_LBL0 25
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L4___codegen_23_codegen_2d_context_2d_arch)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_arch)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_arch)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L7___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
   ___SET_R2(___FIX(5L))
   ___IF(___EQP(___GLO(10,___G_vector_2d_ref),___PRM(10,___G_vector_2d_ref)))
   ___GOTO(___L5___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_arch)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___NOT(___EQP(___GLO(10,___G_vector_2d_ref),___PRM(10,___G_vector_2d_ref))))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
___DEF_GLBL(___L5___codegen_23_codegen_2d_context_2d_arch)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R2)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
   ___IF(___NOT(___FIXLE(___FIX(0L),___R2)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
   ___SET_R3(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R2,___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch)
   ___END_IF
   ___SET_R1(___VECTORREF(___R1,___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_arch)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6___codegen_23_codegen_2d_context_2d_arch)
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_arch)
   ___JUMPGLOSAFE(___SET_NARGS(2),10,___G_vector_2d_ref)
___DEF_GLBL(___L7___codegen_23_codegen_2d_context_2d_arch)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(1L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4___codegen_23_codegen_2d_context_2d_arch)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 31
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_P_HLBL(___L4___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L7___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___SET_R3(___FIX(5L))
   ___IF(___EQP(___GLO(11,___G_vector_2d_set_21_),___PRM(11,___G_vector_2d_set_21_)))
   ___GOTO(___L5___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___NOT(___EQP(___GLO(11,___G_vector_2d_set_21_),___PRM(11,___G_vector_2d_set_21_))))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
___DEF_GLBL(___L5___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___SUBTYPEDMUTABLEP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___FIXLE(___FIX(0L),___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___SET_R4(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R3,___R4)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___END_IF
   ___VECTORSET(___R1,___R3,___R2)
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___ADJFP(-1)
   ___JUMPGLOSAFE(___SET_NARGS(3),11,___G_vector_2d_set_21_)
___DEF_GLBL(___L7___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(1L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_fixup_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 37
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L4___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L7___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
   ___SET_R2(___FIX(6L))
   ___IF(___EQP(___GLO(10,___G_vector_2d_ref),___PRM(10,___G_vector_2d_ref)))
   ___GOTO(___L5___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___NOT(___EQP(___GLO(10,___G_vector_2d_ref),___PRM(10,___G_vector_2d_ref))))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
___DEF_GLBL(___L5___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R2)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
   ___IF(___NOT(___FIXLE(___FIX(0L),___R2)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
   ___SET_R3(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R2,___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___END_IF
   ___SET_R1(___VECTORREF(___R1,___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___JUMPGLOSAFE(___SET_NARGS(2),10,___G_vector_2d_ref)
___DEF_GLBL(___L7___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 43
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_P_HLBL(___L4___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___IF(___NOT(___EQP(___GLO(8,___G__2b_),___PRM(8,___G__2b_))))
   ___GOTO(___L7___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___SET_R3(___FIX(6L))
   ___IF(___EQP(___GLO(11,___G_vector_2d_set_21_),___PRM(11,___G_vector_2d_set_21_)))
   ___GOTO(___L5___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___NOT(___EQP(___GLO(11,___G_vector_2d_set_21_),___PRM(11,___G_vector_2d_set_21_))))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
___DEF_GLBL(___L5___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___SUBTYPEDMUTABLEP(___R1)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___IF(___NOT(___FIXLE(___FIX(0L),___R3)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___SET_R4(___VECTORLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R3,___R4)))
   ___GOTO(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___END_IF
   ___VECTORSET(___R1,___R3,___R2)
   ___POLL(2)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___ADJFP(-1)
   ___JUMPGLOSAFE(___SET_NARGS(3),11,___G_vector_2d_set_21_)
___DEF_GLBL(___L7___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___JUMPGLOSAFE(___SET_NARGS(2),8,___G__2b_)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___codegen," _codegen",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20___codegen,0,0)
,___DEF_LBL_INTRO(___H___codegen_23_make_2d_codegen_2d_context,0,___REF_FAL,9,0)
,___DEF_LBL_PROC(___H___codegen_23_make_2d_codegen_2d_context,0,0)
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,0,___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,1,0)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,0,___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,2,0)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_arch,0,___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_arch,1,0)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,0,___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,2,0)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,0,___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,1,0)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,0,___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,2,0)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
___END_LBL

___BEGIN_MOD1
___DEF_PRM(0,___G__20___codegen,1)
___END_MOD1

___BEGIN_MOD2
___DEF_SYM2(0,___S_codegen_2d_context,"codegen-context")
___END_MOD2

#endif
