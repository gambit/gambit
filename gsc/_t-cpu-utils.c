#ifdef ___LINKER_INFO
; File: "_t-cpu-utils.c", produced by Gambit v4.9.3
(
409003
(C)
"_t-cpu-utils"
("_t-cpu-utils")
()
(("_t-cpu-utils"))
(
"_t-cpu-utils"
)
(
)
(
"_t-cpu-utils#"
)
(
"c#count"
"c#filter"
"c#flip"
"c#in-range?"
"c#index-of"
"c#safe-car"
"c#safe-cdr"
)
(
"+"
"<="
">="
"car"
"cdr"
"cons"
"equal?"
"null?"
"pair?"
)
()
)
#else
#define ___VERSION 409003
#define ___MODULE_NAME "_t-cpu-utils"
#define ___LINKER_ID ___LNK___t_2d_cpu_2d_utils
#define ___MH_PROC ___H___t_2d_cpu_2d_utils
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 1
#define ___GLOCOUNT 17
#define ___SUPCOUNT 8
#define ___SUBCOUNT 3
#define ___LBLCOUNT 56
#define ___MODDESCR ___REF_SUB(0)
#include "gambit.h"

___NEED_SYM(___S___t_2d_cpu_2d_utils)

___NEED_GLO(___G__2b_)
___NEED_GLO(___G__3c__3d_)
___NEED_GLO(___G__3e__3d_)
___NEED_GLO(___G___t_2d_cpu_2d_utils_23_)
___NEED_GLO(___G_c_23_count)
___NEED_GLO(___G_c_23_filter)
___NEED_GLO(___G_c_23_flip)
___NEED_GLO(___G_c_23_in_2d_range_3f_)
___NEED_GLO(___G_c_23_index_2d_of)
___NEED_GLO(___G_c_23_safe_2d_car)
___NEED_GLO(___G_c_23_safe_2d_cdr)
___NEED_GLO(___G_car)
___NEED_GLO(___G_cdr)
___NEED_GLO(___G_cons)
___NEED_GLO(___G_equal_3f_)
___NEED_GLO(___G_null_3f_)
___NEED_GLO(___G_pair_3f_)

___BEGIN_SYM
___DEF_SYM(0,___S___t_2d_cpu_2d_utils,"_t-cpu-utils")
___END_SYM

#define ___SYM___t_2d_cpu_2d_utils ___SYM(0,___S___t_2d_cpu_2d_utils)

___BEGIN_GLO
___DEF_GLO(0,"_t-cpu-utils#")
___DEF_GLO(1,"c#count")
___DEF_GLO(2,"c#filter")
___DEF_GLO(3,"c#flip")
___DEF_GLO(4,"c#in-range?")
___DEF_GLO(5,"c#index-of")
___DEF_GLO(6,"c#safe-car")
___DEF_GLO(7,"c#safe-cdr")
___DEF_GLO(8,"+")
___DEF_GLO(9,"<=")
___DEF_GLO(10,">=")
___DEF_GLO(11,"car")
___DEF_GLO(12,"cdr")
___DEF_GLO(13,"cons")
___DEF_GLO(14,"equal?")
___DEF_GLO(15,"null?")
___DEF_GLO(16,"pair?")
___END_GLO

#define ___GLO___t_2d_cpu_2d_utils_23_ ___GLO(0,___G___t_2d_cpu_2d_utils_23_)
#define ___PRM___t_2d_cpu_2d_utils_23_ ___PRM(0,___G___t_2d_cpu_2d_utils_23_)
#define ___GLO_c_23_count ___GLO(1,___G_c_23_count)
#define ___PRM_c_23_count ___PRM(1,___G_c_23_count)
#define ___GLO_c_23_filter ___GLO(2,___G_c_23_filter)
#define ___PRM_c_23_filter ___PRM(2,___G_c_23_filter)
#define ___GLO_c_23_flip ___GLO(3,___G_c_23_flip)
#define ___PRM_c_23_flip ___PRM(3,___G_c_23_flip)
#define ___GLO_c_23_in_2d_range_3f_ ___GLO(4,___G_c_23_in_2d_range_3f_)
#define ___PRM_c_23_in_2d_range_3f_ ___PRM(4,___G_c_23_in_2d_range_3f_)
#define ___GLO_c_23_index_2d_of ___GLO(5,___G_c_23_index_2d_of)
#define ___PRM_c_23_index_2d_of ___PRM(5,___G_c_23_index_2d_of)
#define ___GLO_c_23_safe_2d_car ___GLO(6,___G_c_23_safe_2d_car)
#define ___PRM_c_23_safe_2d_car ___PRM(6,___G_c_23_safe_2d_car)
#define ___GLO_c_23_safe_2d_cdr ___GLO(7,___G_c_23_safe_2d_cdr)
#define ___PRM_c_23_safe_2d_cdr ___PRM(7,___G_c_23_safe_2d_cdr)
#define ___GLO__2b_ ___GLO(8,___G__2b_)
#define ___PRM__2b_ ___PRM(8,___G__2b_)
#define ___GLO__3c__3d_ ___GLO(9,___G__3c__3d_)
#define ___PRM__3c__3d_ ___PRM(9,___G__3c__3d_)
#define ___GLO__3e__3d_ ___GLO(10,___G__3e__3d_)
#define ___PRM__3e__3d_ ___PRM(10,___G__3e__3d_)
#define ___GLO_car ___GLO(11,___G_car)
#define ___PRM_car ___PRM(11,___G_car)
#define ___GLO_cdr ___GLO(12,___G_cdr)
#define ___PRM_cdr ___PRM(12,___G_cdr)
#define ___GLO_cons ___GLO(13,___G_cons)
#define ___PRM_cons ___PRM(13,___G_cons)
#define ___GLO_equal_3f_ ___GLO(14,___G_equal_3f_)
#define ___PRM_equal_3f_ ___PRM(14,___G_equal_3f_)
#define ___GLO_null_3f_ ___GLO(15,___G_null_3f_)
#define ___PRM_null_3f_ ___PRM(15,___G_null_3f_)
#define ___GLO_pair_3f_ ___GLO(16,___G_pair_3f_)
#define ___PRM_pair_3f_ ___PRM(16,___G_pair_3f_)

___DEF_SUB_VEC(___X0,6UL)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SUB(2))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X1,1UL)
               ___VEC1(___REF_SYM(0,___S___t_2d_cpu_2d_utils))
               ___VEC0
___DEF_SUB_VEC(___X2,0UL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
,___DEF_SUB(___X2)
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
___DEF_M_HLBL(___L0___t_2d_cpu_2d_utils_23_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_safe_2d_car)
___DEF_M_HLBL(___L1_c_23_safe_2d_car)
___DEF_M_HLBL(___L2_c_23_safe_2d_car)
___DEF_M_HLBL(___L3_c_23_safe_2d_car)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_safe_2d_cdr)
___DEF_M_HLBL(___L1_c_23_safe_2d_cdr)
___DEF_M_HLBL(___L2_c_23_safe_2d_cdr)
___DEF_M_HLBL(___L3_c_23_safe_2d_cdr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_flip)
___DEF_M_HLBL(___L1_c_23_flip)
___DEF_M_HLBL(___L2_c_23_flip)
___DEF_M_HLBL(___L3_c_23_flip)
___DEF_M_HLBL(___L4_c_23_flip)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_in_2d_range_3f_)
___DEF_M_HLBL(___L1_c_23_in_2d_range_3f_)
___DEF_M_HLBL(___L2_c_23_in_2d_range_3f_)
___DEF_M_HLBL(___L3_c_23_in_2d_range_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_index_2d_of)
___DEF_M_HLBL(___L1_c_23_index_2d_of)
___DEF_M_HLBL(___L2_c_23_index_2d_of)
___DEF_M_HLBL(___L3_c_23_index_2d_of)
___DEF_M_HLBL(___L4_c_23_index_2d_of)
___DEF_M_HLBL(___L5_c_23_index_2d_of)
___DEF_M_HLBL(___L6_c_23_index_2d_of)
___DEF_M_HLBL(___L7_c_23_index_2d_of)
___DEF_M_HLBL(___L8_c_23_index_2d_of)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_count)
___DEF_M_HLBL(___L1_c_23_count)
___DEF_M_HLBL(___L2_c_23_count)
___DEF_M_HLBL(___L3_c_23_count)
___DEF_M_HLBL(___L4_c_23_count)
___DEF_M_HLBL(___L5_c_23_count)
___DEF_M_HLBL(___L6_c_23_count)
___DEF_M_HLBL(___L7_c_23_count)
___DEF_M_HLBL(___L8_c_23_count)
___DEF_M_HLBL(___L9_c_23_count)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_filter)
___DEF_M_HLBL(___L1_c_23_filter)
___DEF_M_HLBL(___L2_c_23_filter)
___DEF_M_HLBL(___L3_c_23_filter)
___DEF_M_HLBL(___L4_c_23_filter)
___DEF_M_HLBL(___L5_c_23_filter)
___DEF_M_HLBL(___L6_c_23_filter)
___DEF_M_HLBL(___L7_c_23_filter)
___DEF_M_HLBL(___L8_c_23_filter)
___DEF_M_HLBL(___L9_c_23_filter)
___DEF_M_HLBL(___L10_c_23_filter)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___t_2d_cpu_2d_utils_23_
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
___DEF_P_HLBL(___L0___t_2d_cpu_2d_utils_23_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___t_2d_cpu_2d_utils_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___t_2d_cpu_2d_utils_23_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_safe_2d_car
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_safe_2d_car)
___DEF_P_HLBL(___L1_c_23_safe_2d_car)
___DEF_P_HLBL(___L2_c_23_safe_2d_car)
___DEF_P_HLBL(___L3_c_23_safe_2d_car)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_safe_2d_car)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_safe_2d_car)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_safe_2d_car)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),16,___G_pair_3f_)
___DEF_SLBL(2,___L2_c_23_safe_2d_car)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4_c_23_safe_2d_car)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_safe_2d_car)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),11,___G_car)
___DEF_GLBL(___L4_c_23_safe_2d_car)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_safe_2d_cdr
#undef ___PH_LBL0
#define ___PH_LBL0 8
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_safe_2d_cdr)
___DEF_P_HLBL(___L1_c_23_safe_2d_cdr)
___DEF_P_HLBL(___L2_c_23_safe_2d_cdr)
___DEF_P_HLBL(___L3_c_23_safe_2d_cdr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_safe_2d_cdr)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_safe_2d_cdr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_safe_2d_cdr)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),16,___G_pair_3f_)
___DEF_SLBL(2,___L2_c_23_safe_2d_cdr)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4_c_23_safe_2d_cdr)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_safe_2d_cdr)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_GLBL(___L4_c_23_safe_2d_cdr)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_flip
#undef ___PH_LBL0
#define ___PH_LBL0 13
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_flip)
___DEF_P_HLBL(___L1_c_23_flip)
___DEF_P_HLBL(___L2_c_23_flip)
___DEF_P_HLBL(___L3_c_23_flip)
___DEF_P_HLBL(___L4_c_23_flip)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_flip)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_flip)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_flip)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_SLBL(2,___L2_c_23_flip)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),11,___G_car)
___DEF_SLBL(3,___L3_c_23_flip)
   ___SET_R2(___R1)
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-5))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_flip)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),13,___G_cons)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_in_2d_range_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 19
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_in_2d_range_3f_)
___DEF_P_HLBL(___L1_c_23_in_2d_range_3f_)
___DEF_P_HLBL(___L2_c_23_in_2d_range_3f_)
___DEF_P_HLBL(___L3_c_23_in_2d_range_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_in_2d_range_3f_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_in_2d_range_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_in_2d_range_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),10,___G__3e__3d_)
___DEF_SLBL(2,___L2_c_23_in_2d_range_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4_c_23_in_2d_range_3f_)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_in_2d_range_3f_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),9,___G__3c__3d_)
___DEF_GLBL(___L4_c_23_in_2d_range_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_index_2d_of
#undef ___PH_LBL0
#define ___PH_LBL0 24
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_index_2d_of)
___DEF_P_HLBL(___L1_c_23_index_2d_of)
___DEF_P_HLBL(___L2_c_23_index_2d_of)
___DEF_P_HLBL(___L3_c_23_index_2d_of)
___DEF_P_HLBL(___L4_c_23_index_2d_of)
___DEF_P_HLBL(___L5_c_23_index_2d_of)
___DEF_P_HLBL(___L6_c_23_index_2d_of)
___DEF_P_HLBL(___L7_c_23_index_2d_of)
___DEF_P_HLBL(___L8_c_23_index_2d_of)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_index_2d_of)
   ___IF_NARGS_EQ(2,___SET_R3(___ABSENT))
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,2,1,0)
___DEF_GLBL(___L_c_23_index_2d_of)
   ___IF(___NOT(___EQP(___R3,___ABSENT)))
   ___GOTO(___L9_c_23_index_2d_of)
   ___END_IF
   ___SET_R3(___GLO_equal_3f_)
___DEF_GLBL(___L9_c_23_index_2d_of)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R3)
   ___SET_R3(___R2)
   ___SET_R1(___STK(2))
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_index_2d_of)
   ___GOTO(___L10_c_23_index_2d_of)
___DEF_SLBL(2,___L2_c_23_index_2d_of)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___SET_R2(___STK(-4))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_index_2d_of)
___DEF_GLBL(___L10_c_23_index_2d_of)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___ADJFP(7)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_index_2d_of)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),15,___G_null_3f_)
___DEF_SLBL(5,___L5_c_23_index_2d_of)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L12_c_23_index_2d_of)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),11,___G_car)
___DEF_SLBL(6,___L6_c_23_index_2d_of)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(7))
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-5))
___DEF_SLBL(7,___L7_c_23_index_2d_of)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L11_c_23_index_2d_of)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),8,___G__2b_)
___DEF_SLBL(8,___L8_c_23_index_2d_of)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_GLBL(___L11_c_23_index_2d_of)
   ___SET_R1(___STK(-4))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L12_c_23_index_2d_of)
   ___SET_R1(___FAL)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_count
#undef ___PH_LBL0
#define ___PH_LBL0 34
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_count)
___DEF_P_HLBL(___L1_c_23_count)
___DEF_P_HLBL(___L2_c_23_count)
___DEF_P_HLBL(___L3_c_23_count)
___DEF_P_HLBL(___L4_c_23_count)
___DEF_P_HLBL(___L5_c_23_count)
___DEF_P_HLBL(___L6_c_23_count)
___DEF_P_HLBL(___L7_c_23_count)
___DEF_P_HLBL(___L8_c_23_count)
___DEF_P_HLBL(___L9_c_23_count)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_count)
   ___IF_NARGS_EQ(2,___SET_R3(___ABSENT))
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,2,1,0)
___DEF_GLBL(___L_c_23_count)
   ___IF(___EQP(___R3,___ABSENT))
   ___GOTO(___L10_c_23_count)
   ___END_IF
   ___GOTO(___L11_c_23_count)
___DEF_SLBL(1,___L1_c_23_count)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_count)
   ___IF(___NOT(___EQP(___R3,___ABSENT)))
   ___GOTO(___L11_c_23_count)
   ___END_IF
___DEF_GLBL(___L10_c_23_count)
   ___SET_R3(___GLO_equal_3f_)
___DEF_GLBL(___L11_c_23_count)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_count)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),15,___G_null_3f_)
___DEF_SLBL(4,___L4_c_23_count)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L13_c_23_count)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),11,___G_car)
___DEF_SLBL(5,___L5_c_23_count)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(-4))
___DEF_SLBL(6,___L6_c_23_count)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L12_c_23_count)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_SLBL(7,___L7_c_23_count)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___ADJFP(-4)
   ___IF(___EQP(___R3,___ABSENT))
   ___GOTO(___L10_c_23_count)
   ___END_IF
   ___GOTO(___L11_c_23_count)
___DEF_SLBL(8,___L8_c_23_count)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(1L))
   ___SET_R0(___STK(-3))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_count)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),8,___G__2b_)
___DEF_GLBL(___L12_c_23_count)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(1))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_GLBL(___L13_c_23_count)
   ___SET_R1(___FIX(0L))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_filter
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
___DEF_P_HLBL(___L0_c_23_filter)
___DEF_P_HLBL(___L1_c_23_filter)
___DEF_P_HLBL(___L2_c_23_filter)
___DEF_P_HLBL(___L3_c_23_filter)
___DEF_P_HLBL(___L4_c_23_filter)
___DEF_P_HLBL(___L5_c_23_filter)
___DEF_P_HLBL(___L6_c_23_filter)
___DEF_P_HLBL(___L7_c_23_filter)
___DEF_P_HLBL(___L8_c_23_filter)
___DEF_P_HLBL(___L9_c_23_filter)
___DEF_P_HLBL(___L10_c_23_filter)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_filter)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_filter)
   ___GOTO(___L11_c_23_filter)
___DEF_SLBL(1,___L1_c_23_filter)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_filter)
___DEF_GLBL(___L11_c_23_filter)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_filter)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),15,___G_null_3f_)
___DEF_SLBL(4,___L4_c_23_filter)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L13_c_23_filter)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),11,___G_car)
___DEF_SLBL(5,___L5_c_23_filter)
   ___SET_R0(___LBL(6))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-6))
___DEF_SLBL(6,___L6_c_23_filter)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L12_c_23_filter)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),11,___G_car)
___DEF_SLBL(7,___L7_c_23_filter)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_SLBL(8,___L8_c_23_filter)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___GOTO(___L11_c_23_filter)
___DEF_SLBL(9,___L9_c_23_filter)
   ___SET_R2(___R1)
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-4))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_filter)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),13,___G_cons)
___DEF_GLBL(___L12_c_23_filter)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(1))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),12,___G_cdr)
___DEF_GLBL(___L13_c_23_filter)
   ___SET_R1(___NUL)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___t_2d_cpu_2d_utils_23_,"_t-cpu-utils#",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_utils_23_,0,-1)
,___DEF_LBL_INTRO(___H_c_23_safe_2d_car,"c#safe-car",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_safe_2d_car,1,-1)
,___DEF_LBL_RET(___H_c_23_safe_2d_car,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_safe_2d_car,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_safe_2d_car,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_safe_2d_cdr,"c#safe-cdr",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_safe_2d_cdr,1,-1)
,___DEF_LBL_RET(___H_c_23_safe_2d_cdr,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_safe_2d_cdr,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_safe_2d_cdr,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_flip,"c#flip",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_flip,1,-1)
,___DEF_LBL_RET(___H_c_23_flip,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_flip,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_flip,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_flip,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_in_2d_range_3f_,"c#in-range?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_in_2d_range_3f_,3,-1)
,___DEF_LBL_RET(___H_c_23_in_2d_range_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_in_2d_range_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_in_2d_range_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_index_2d_of,"c#index-of",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23_index_2d_of,3,-1)
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETI,1,4,0x3f9L))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_index_2d_of,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_INTRO(___H_c_23_count,"c#count",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_count,3,-1)
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_filter,"c#filter",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23_filter,2,-1)
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETI,8,8,0x3f08L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___t_2d_cpu_2d_utils_23_,1)
___DEF_MOD_PRM(6,___G_c_23_safe_2d_car,3)
___DEF_MOD_PRM(7,___G_c_23_safe_2d_cdr,8)
___DEF_MOD_PRM(3,___G_c_23_flip,13)
___DEF_MOD_PRM(4,___G_c_23_in_2d_range_3f_,19)
___DEF_MOD_PRM(5,___G_c_23_index_2d_of,24)
___DEF_MOD_PRM(1,___G_c_23_count,34)
___DEF_MOD_PRM(2,___G_c_23_filter,45)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___t_2d_cpu_2d_utils_23_,1)
___DEF_MOD_GLO(6,___G_c_23_safe_2d_car,3)
___DEF_MOD_GLO(7,___G_c_23_safe_2d_cdr,8)
___DEF_MOD_GLO(3,___G_c_23_flip,13)
___DEF_MOD_GLO(4,___G_c_23_in_2d_range_3f_,19)
___DEF_MOD_GLO(5,___G_c_23_index_2d_of,24)
___DEF_MOD_GLO(1,___G_c_23_count,34)
___DEF_MOD_GLO(2,___G_c_23_filter,45)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___t_2d_cpu_2d_utils,"_t-cpu-utils")
___END_MOD_SYM_KEY

#endif
