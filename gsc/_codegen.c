#ifdef ___LINKER_INFO
; File: "_codegen.c", produced by Gambit v4.8.9
(
408009
(C)
"_codegen"
(("_codegen"))
(
"_codegen"
"codegen-context"
)
(
)
(
" _codegen"
"_codegen#codegen-context-arch-set!"
"_codegen#codegen-context-fixup-list-set!"
"_codegen#codegen-context-frame-size-set!"
"_codegen#codegen-context-listing-format-set!"
"_codegen#codegen-context-nargs-set!"
"_codegen#codegen-context-target-set!"
)
(
"_codegen#codegen-context-arch"
"_codegen#codegen-context-fixup-list"
"_codegen#codegen-context-frame-size"
"_codegen#codegen-context-listing-format"
"_codegen#codegen-context-nargs"
"_codegen#codegen-context-target"
"_codegen#make-codegen-context"
)
(
"+"
"make-vector"
"vector-ref"
"vector-set!"
)
 ()
)
#else
#define ___VERSION 408009
#define ___MODULE_NAME "_codegen"
#define ___LINKER_ID ____20___codegen
#define ___MH_PROC ___H__20___codegen
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 2
#define ___GLOCOUNT 18
#define ___SUPCOUNT 14
#define ___SUBCOUNT 1
#define ___LBLCOUNT 74
#define ___MODDESCR ___REF_SUB(0)
#include "gambit.h"

___NEED_SYM(___S___codegen)
___NEED_SYM(___S_codegen_2d_context)

___NEED_GLO(___G__20___codegen)
___NEED_GLO(___G__2b_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_arch)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_frame_2d_size)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_nargs)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_target)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___NEED_GLO(___G___codegen_23_make_2d_codegen_2d_context)
___NEED_GLO(___G_make_2d_vector)
___NEED_GLO(___G_vector_2d_ref)
___NEED_GLO(___G_vector_2d_set_21_)

___BEGIN_SYM
___DEF_SYM(0,___S___codegen,"_codegen")
___DEF_SYM(1,___S_codegen_2d_context,"codegen-context")
___END_SYM

#define ___SYM___codegen ___SYM(0,___S___codegen)
#define ___SYM_codegen_2d_context ___SYM(1,___S_codegen_2d_context)

___BEGIN_GLO
___DEF_GLO(0," _codegen")
___DEF_GLO(1,"_codegen#codegen-context-arch")
___DEF_GLO(2,"_codegen#codegen-context-arch-set!")

___DEF_GLO(3,"_codegen#codegen-context-fixup-list")

___DEF_GLO(4,"_codegen#codegen-context-fixup-list-set!")

___DEF_GLO(5,"_codegen#codegen-context-frame-size")

___DEF_GLO(6,"_codegen#codegen-context-frame-size-set!")

___DEF_GLO(7,"_codegen#codegen-context-listing-format")

___DEF_GLO(8,"_codegen#codegen-context-listing-format-set!")

___DEF_GLO(9,"_codegen#codegen-context-nargs")
___DEF_GLO(10,"_codegen#codegen-context-nargs-set!")

___DEF_GLO(11,"_codegen#codegen-context-target")
___DEF_GLO(12,"_codegen#codegen-context-target-set!")

___DEF_GLO(13,"_codegen#make-codegen-context")
___DEF_GLO(14,"+")
___DEF_GLO(15,"make-vector")
___DEF_GLO(16,"vector-ref")
___DEF_GLO(17,"vector-set!")
___END_GLO

#define ___GLO__20___codegen ___GLO(0,___G__20___codegen)
#define ___PRM__20___codegen ___PRM(0,___G__20___codegen)
#define ___GLO___codegen_23_codegen_2d_context_2d_arch ___GLO(1,___G___codegen_23_codegen_2d_context_2d_arch)
#define ___PRM___codegen_23_codegen_2d_context_2d_arch ___PRM(1,___G___codegen_23_codegen_2d_context_2d_arch)
#define ___GLO___codegen_23_codegen_2d_context_2d_arch_2d_set_21_ ___GLO(2,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_arch_2d_set_21_ ___PRM(2,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
#define ___GLO___codegen_23_codegen_2d_context_2d_fixup_2d_list ___GLO(3,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list)
#define ___PRM___codegen_23_codegen_2d_context_2d_fixup_2d_list ___PRM(3,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list)
#define ___GLO___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_ ___GLO(4,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_ ___PRM(4,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
#define ___GLO___codegen_23_codegen_2d_context_2d_frame_2d_size ___GLO(5,___G___codegen_23_codegen_2d_context_2d_frame_2d_size)
#define ___PRM___codegen_23_codegen_2d_context_2d_frame_2d_size ___PRM(5,___G___codegen_23_codegen_2d_context_2d_frame_2d_size)
#define ___GLO___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_ ___GLO(6,___G___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_ ___PRM(6,___G___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
#define ___GLO___codegen_23_codegen_2d_context_2d_listing_2d_format ___GLO(7,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
#define ___PRM___codegen_23_codegen_2d_context_2d_listing_2d_format ___PRM(7,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
#define ___GLO___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_ ___GLO(8,___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_ ___PRM(8,___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
#define ___GLO___codegen_23_codegen_2d_context_2d_nargs ___GLO(9,___G___codegen_23_codegen_2d_context_2d_nargs)
#define ___PRM___codegen_23_codegen_2d_context_2d_nargs ___PRM(9,___G___codegen_23_codegen_2d_context_2d_nargs)
#define ___GLO___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_ ___GLO(10,___G___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_ ___PRM(10,___G___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
#define ___GLO___codegen_23_codegen_2d_context_2d_target ___GLO(11,___G___codegen_23_codegen_2d_context_2d_target)
#define ___PRM___codegen_23_codegen_2d_context_2d_target ___PRM(11,___G___codegen_23_codegen_2d_context_2d_target)
#define ___GLO___codegen_23_codegen_2d_context_2d_target_2d_set_21_ ___GLO(12,___G___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_target_2d_set_21_ ___PRM(12,___G___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
#define ___GLO___codegen_23_make_2d_codegen_2d_context ___GLO(13,___G___codegen_23_make_2d_codegen_2d_context)
#define ___PRM___codegen_23_make_2d_codegen_2d_context ___PRM(13,___G___codegen_23_make_2d_codegen_2d_context)
#define ___GLO__2b_ ___GLO(14,___G__2b_)
#define ___PRM__2b_ ___PRM(14,___G__2b_)
#define ___GLO_make_2d_vector ___GLO(15,___G_make_2d_vector)
#define ___PRM_make_2d_vector ___PRM(15,___G_make_2d_vector)
#define ___GLO_vector_2d_ref ___GLO(16,___G_vector_2d_ref)
#define ___PRM_vector_2d_ref ___PRM(16,___G_vector_2d_ref)
#define ___GLO_vector_2d_set_21_ ___GLO(17,___G_vector_2d_set_21_)
#define ___PRM_vector_2d_set_21_ ___PRM(17,___G_vector_2d_set_21_)

___DEF_SUB_VEC(___X0,5UL)
               ___VEC1(___REF_SYM(0,___S___codegen))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FAL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
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
___DEF_M_HLBL(___L9___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL(___L10___codegen_23_make_2d_codegen_2d_context)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_target)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_target)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_target)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_target)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_nargs)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_nargs)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_nargs)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_nargs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_M_HLBL(___L1___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_M_HLBL(___L2___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_M_HLBL(___L3___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
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
___DEF_P_HLBL(___L9___codegen_23_make_2d_codegen_2d_context)
___DEF_P_HLBL(___L10___codegen_23_make_2d_codegen_2d_context)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_make_2d_codegen_2d_context)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___codegen_23_make_2d_codegen_2d_context)
   ___SET_STK(1,___R0)
   ___SET_R2(___FIX(6L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_make_2d_codegen_2d_context)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_make_2d_codegen_2d_context)
   ___SET_R2(___SYM_codegen_2d_context)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),15,___G_make_2d_vector)
___DEF_SLBL(3,___L3___codegen_23_make_2d_codegen_2d_context)
   ___SET_STK(-2,___R1)
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(2),___PRC(20),___L___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
___DEF_SLBL(4,___L4___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(30),___L___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___DEF_SLBL(5,___L5___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(2),___PRC(50),___L___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_SLBL(6,___L6___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(60),___L___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_SLBL(7,___L7___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___NUL)
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(2),___PRC(40),___L___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
___DEF_SLBL(8,___L8___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(2),___PRC(70),___L___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_SLBL(9,___L9___codegen_23_make_2d_codegen_2d_context)
   ___SET_R1(___STK(-6))
   ___POLL(10)
___DEF_SLBL(10,___L10___codegen_23_make_2d_codegen_2d_context)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_listing_2d_format
#undef ___PH_LBL0
#define ___PH_LBL0 15
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_listing_2d_format)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_listing_2d_format)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),16,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 20
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),17,___G_vector_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_arch
#undef ___PH_LBL0
#define ___PH_LBL0 25
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_arch)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_arch)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_arch)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_arch)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(1L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_arch)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_arch)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_arch)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),16,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 30
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(1L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),17,___G_vector_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_fixup_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 35
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),16,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 40
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),17,___G_vector_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_target
#undef ___PH_LBL0
#define ___PH_LBL0 45
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_target)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_target)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_target)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_target)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_target)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_target)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(3L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_target)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_target)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_target)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),16,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_target_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 50
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(3L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_target_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),17,___G_vector_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_frame_2d_size
#undef ___PH_LBL0
#define ___PH_LBL0 55
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_frame_2d_size)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_frame_2d_size)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_frame_2d_size)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_frame_2d_size)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(4L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_frame_2d_size)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_frame_2d_size)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_frame_2d_size)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),16,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 60
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(4L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),17,___G_vector_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_nargs
#undef ___PH_LBL0
#define ___PH_LBL0 65
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_nargs)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_nargs)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_nargs)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_nargs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_nargs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_nargs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(5L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_nargs)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_nargs)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_nargs)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),16,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 70
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_P_HLBL(___L1___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_P_HLBL(___L2___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___DEF_P_HLBL(___L3___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___FIX(5L))
   ___SET_R1(___FIX(4L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),14,___G__2b_)
___DEF_SLBL(2,___L2___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),17,___G_vector_2d_set_21_)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___codegen," _codegen",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20___codegen,0,-1)
,___DEF_LBL_INTRO(___H___codegen_23_make_2d_codegen_2d_context,"_codegen#make-codegen-context",___REF_FAL,
11,0)
,___DEF_LBL_PROC(___H___codegen_23_make_2d_codegen_2d_context,0,-1)
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_make_2d_codegen_2d_context,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,"_codegen#codegen-context-listing-format",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,1,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,"_codegen#codegen-context-listing-format-set!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_arch,"_codegen#codegen-context-arch",___REF_FAL,
4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_arch,1,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,"_codegen#codegen-context-arch-set!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,"_codegen#codegen-context-fixup-list",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,1,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,"_codegen#codegen-context-fixup-list-set!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_target,"_codegen#codegen-context-target",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_target,1,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_target,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_target,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_target,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_target_2d_set_21_,"_codegen#codegen-context-target-set!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_target_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_target_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_target_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_target_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_frame_2d_size,"_codegen#codegen-context-frame-size",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_frame_2d_size,1,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_frame_2d_size,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_frame_2d_size,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_frame_2d_size,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,"_codegen#codegen-context-frame-size-set!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_nargs,"_codegen#codegen-context-nargs",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_nargs,1,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_nargs,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_nargs,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_nargs,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,"_codegen#codegen-context-nargs-set!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20___codegen,1)
___DEF_MOD_PRM(13,___G___codegen_23_make_2d_codegen_2d_context,3)
___DEF_MOD_PRM(7,___G___codegen_23_codegen_2d_context_2d_listing_2d_format,15)
___DEF_MOD_PRM(8,___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,20)
___DEF_MOD_PRM(1,___G___codegen_23_codegen_2d_context_2d_arch,25)
___DEF_MOD_PRM(2,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,30)
___DEF_MOD_PRM(3,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list,35)
___DEF_MOD_PRM(4,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,40)
___DEF_MOD_PRM(11,___G___codegen_23_codegen_2d_context_2d_target,45)
___DEF_MOD_PRM(12,___G___codegen_23_codegen_2d_context_2d_target_2d_set_21_,50)
___DEF_MOD_PRM(5,___G___codegen_23_codegen_2d_context_2d_frame_2d_size,55)
___DEF_MOD_PRM(6,___G___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,60)
___DEF_MOD_PRM(9,___G___codegen_23_codegen_2d_context_2d_nargs,65)
___DEF_MOD_PRM(10,___G___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,70)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___codegen,1)
___DEF_MOD_GLO(13,___G___codegen_23_make_2d_codegen_2d_context,3)
___DEF_MOD_GLO(7,___G___codegen_23_codegen_2d_context_2d_listing_2d_format,15)
___DEF_MOD_GLO(8,___G___codegen_23_codegen_2d_context_2d_listing_2d_format_2d_set_21_,20)
___DEF_MOD_GLO(1,___G___codegen_23_codegen_2d_context_2d_arch,25)
___DEF_MOD_GLO(2,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_,30)
___DEF_MOD_GLO(3,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list,35)
___DEF_MOD_GLO(4,___G___codegen_23_codegen_2d_context_2d_fixup_2d_list_2d_set_21_,40)
___DEF_MOD_GLO(11,___G___codegen_23_codegen_2d_context_2d_target,45)
___DEF_MOD_GLO(12,___G___codegen_23_codegen_2d_context_2d_target_2d_set_21_,50)
___DEF_MOD_GLO(5,___G___codegen_23_codegen_2d_context_2d_frame_2d_size,55)
___DEF_MOD_GLO(6,___G___codegen_23_codegen_2d_context_2d_frame_2d_size_2d_set_21_,60)
___DEF_MOD_GLO(9,___G___codegen_23_codegen_2d_context_2d_nargs,65)
___DEF_MOD_GLO(10,___G___codegen_23_codegen_2d_context_2d_nargs_2d_set_21_,70)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___codegen,"_codegen")
___DEF_MOD_SYM(1,___S_codegen_2d_context,"codegen-context")
___END_MOD_SYM_KEY

#endif
