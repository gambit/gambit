#ifdef ___LINKER_INFO
; File: "_t-cpu-utils.c", produced by Gambit v4.9.5
(
409005
(C)
"_t-cpu-utils"
("_t-cpu-utils")
()
(("_t-cpu-utils"))
( #|*/"*/"symbols|#
"_t-cpu-utils"
"_t-cpu-utils#"
"c#count"
"c#filter"
"c#flip"
"c#in-range?"
"c#safe-car"
"c#safe-cdr"
) #|*/"*/"symbols|#
( #|*/"*/"keywords|#
) #|*/"*/"keywords|#
( #|*/"*/"globals-s-d|#
"_t-cpu-utils#"
) #|*/"*/"globals-s-d|#
( #|*/"*/"globals-s-nd|#
"c#count"
"c#filter"
"c#flip"
"c#in-range?"
"c#safe-car"
"c#safe-cdr"
) #|*/"*/"globals-s-nd|#
( #|*/"*/"globals-ns|#
"equal?"
) #|*/"*/"globals-ns|#
( #|*/"*/"meta-info|#
) #|*/"*/"meta-info|#
)
#else
#define ___VERSION 409005
#define ___MODULE_NAME "_t-cpu-utils"
#define ___LINKER_ID ___LNK___t_2d_cpu_2d_utils
#define ___MH_PROC ___H___t_2d_cpu_2d_utils
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 8
#define ___GLOCOUNT 8
#define ___SUPCOUNT 7
#define ___SUBCOUNT 3
#define ___LBLCOUNT 24
#define ___MODDESCR ___REF_SUB(0)
#include "gambit.h"

___NEED_SYM(___S___t_2d_cpu_2d_utils)
___NEED_SYM(___S___t_2d_cpu_2d_utils_23_)
___NEED_SYM(___S_c_23_count)
___NEED_SYM(___S_c_23_filter)
___NEED_SYM(___S_c_23_flip)
___NEED_SYM(___S_c_23_in_2d_range_3f_)
___NEED_SYM(___S_c_23_safe_2d_car)
___NEED_SYM(___S_c_23_safe_2d_cdr)

___NEED_GLO(___G___t_2d_cpu_2d_utils_23_)
___NEED_GLO(___G_c_23_count)
___NEED_GLO(___G_c_23_filter)
___NEED_GLO(___G_c_23_flip)
___NEED_GLO(___G_c_23_in_2d_range_3f_)
___NEED_GLO(___G_c_23_safe_2d_car)
___NEED_GLO(___G_c_23_safe_2d_cdr)
___NEED_GLO(___G_equal_3f_)

___BEGIN_SYM
___DEF_SYM(0,___S___t_2d_cpu_2d_utils,"_t-cpu-utils")
___DEF_SYM(1,___S___t_2d_cpu_2d_utils_23_,"_t-cpu-utils#")
___DEF_SYM(2,___S_c_23_count,"c#count")
___DEF_SYM(3,___S_c_23_filter,"c#filter")
___DEF_SYM(4,___S_c_23_flip,"c#flip")
___DEF_SYM(5,___S_c_23_in_2d_range_3f_,"c#in-range?")
___DEF_SYM(6,___S_c_23_safe_2d_car,"c#safe-car")
___DEF_SYM(7,___S_c_23_safe_2d_cdr,"c#safe-cdr")
___END_SYM

#define ___SYM___t_2d_cpu_2d_utils ___SYM(0,___S___t_2d_cpu_2d_utils)
#define ___SYM___t_2d_cpu_2d_utils_23_ ___SYM(1,___S___t_2d_cpu_2d_utils_23_)
#define ___SYM_c_23_count ___SYM(2,___S_c_23_count)
#define ___SYM_c_23_filter ___SYM(3,___S_c_23_filter)
#define ___SYM_c_23_flip ___SYM(4,___S_c_23_flip)
#define ___SYM_c_23_in_2d_range_3f_ ___SYM(5,___S_c_23_in_2d_range_3f_)
#define ___SYM_c_23_safe_2d_car ___SYM(6,___S_c_23_safe_2d_car)
#define ___SYM_c_23_safe_2d_cdr ___SYM(7,___S_c_23_safe_2d_cdr)

___BEGIN_GLO
___DEF_GLO(0,"_t-cpu-utils#")
___DEF_GLO(1,"c#count")
___DEF_GLO(2,"c#filter")
___DEF_GLO(3,"c#flip")
___DEF_GLO(4,"c#in-range?")
___DEF_GLO(5,"c#safe-car")
___DEF_GLO(6,"c#safe-cdr")
___DEF_GLO(7,"equal?")
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
#define ___GLO_c_23_safe_2d_car ___GLO(5,___G_c_23_safe_2d_car)
#define ___PRM_c_23_safe_2d_car ___PRM(5,___G_c_23_safe_2d_car)
#define ___GLO_c_23_safe_2d_cdr ___GLO(6,___G_c_23_safe_2d_cdr)
#define ___PRM_c_23_safe_2d_cdr ___PRM(6,___G_c_23_safe_2d_cdr)
#define ___GLO_equal_3f_ ___GLO(7,___G_equal_3f_)
#define ___PRM_equal_3f_ ___PRM(7,___G_equal_3f_)

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
#define ___MD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___t_2d_cpu_2d_utils_23_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_safe_2d_car)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_safe_2d_cdr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_flip)
___DEF_M_HLBL(___L1_c_23_flip)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_in_2d_range_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_count)
___DEF_M_HLBL(___L1_c_23_count)
___DEF_M_HLBL(___L2_c_23_count)
___DEF_M_HLBL(___L3_c_23_count)
___DEF_M_HLBL(___L4_c_23_count)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_filter)
___DEF_M_HLBL(___L1_c_23_filter)
___DEF_M_HLBL(___L2_c_23_filter)
___DEF_M_HLBL(___L3_c_23_filter)
___DEF_M_HLBL(___L4_c_23_filter)
___DEF_M_HLBL(___L5_c_23_filter)
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
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_safe_2d_car
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_safe_2d_car)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_safe_2d_car)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_safe_2d_car)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L1_c_23_safe_2d_car)
   ___END_IF
   ___SET_R1(___CAR(___R1))
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_safe_2d_car)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_safe_2d_cdr
#undef ___PH_LBL0
#define ___PH_LBL0 5
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_safe_2d_cdr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_safe_2d_cdr)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_safe_2d_cdr)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L1_c_23_safe_2d_cdr)
   ___END_IF
   ___SET_R1(___CDR(___R1))
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_safe_2d_cdr)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_flip
#undef ___PH_LBL0
#define ___PH_LBL0 7
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_flip)
___DEF_P_HLBL(___L1_c_23_flip)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_flip)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_flip)
   ___SET_R2(___CAR(___R1))
   ___SET_R1(___CDR(___R1))
   ___SET_R1(___CONS(___R1,___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_flip)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_in_2d_range_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 10
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_in_2d_range_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_in_2d_range_3f_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_in_2d_range_3f_)
   ___IF(___NOT(___FIXGE(___R3,___R1)))
   ___GOTO(___L1_c_23_in_2d_range_3f_)
   ___END_IF
   ___SET_R1(___BOOLEAN(___FIXLE(___R3,___R2)))
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_in_2d_range_3f_)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_count
#undef ___PH_LBL0
#define ___PH_LBL0 12
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_count)
   ___IF_NARGS_EQ(2,___SET_R3(___ABSENT))
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,2,1,0)
___DEF_GLBL(___L_c_23_count)
   ___IF(___EQP(___R3,___ABSENT))
   ___GOTO(___L5_c_23_count)
   ___END_IF
   ___GOTO(___L8_c_23_count)
___DEF_SLBL(1,___L1_c_23_count)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7_c_23_count)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_count)
   ___IF(___NOT(___EQP(___R3,___ABSENT)))
   ___GOTO(___L8_c_23_count)
   ___END_IF
___DEF_GLBL(___L5_c_23_count)
   ___SET_R3(___PRM_equal_3f_)
   ___IF(___NULLP(___R2))
   ___GOTO(___L9_c_23_count)
   ___END_IF
___DEF_GLBL(___L6_c_23_count)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___CAR(___R2))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_count)
   ___SET_R0(___LBL(1))
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___DEF_GLBL(___L7_c_23_count)
   ___SET_R3(___STK(-4))
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___ADJFP(-4)
   ___IF(___EQP(___R3,___ABSENT))
   ___GOTO(___L5_c_23_count)
   ___END_IF
___DEF_GLBL(___L8_c_23_count)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L6_c_23_count)
   ___END_IF
___DEF_GLBL(___L9_c_23_count)
   ___SET_R1(___FIX(0L))
   ___JUMPRET(___R0)
___DEF_SLBL(4,___L4_c_23_count)
   ___SET_R1(___FIXADD(___FIX(1L),___R1))
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_filter
#undef ___PH_LBL0
#define ___PH_LBL0 18
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_filter)
___DEF_P_HLBL(___L1_c_23_filter)
___DEF_P_HLBL(___L2_c_23_filter)
___DEF_P_HLBL(___L3_c_23_filter)
___DEF_P_HLBL(___L4_c_23_filter)
___DEF_P_HLBL(___L5_c_23_filter)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_filter)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_filter)
   ___IF(___NULLP(___R2))
   ___GOTO(___L8_c_23_filter)
   ___END_IF
   ___GOTO(___L6_c_23_filter)
___DEF_SLBL(1,___L1_c_23_filter)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7_c_23_filter)
   ___END_IF
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_filter)
   ___IF(___NULLP(___R2))
   ___GOTO(___L8_c_23_filter)
   ___END_IF
___DEF_GLBL(___L6_c_23_filter)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___CAR(___R2))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_filter)
   ___SET_R0(___LBL(1))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(-6))
___DEF_GLBL(___L7_c_23_filter)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L6_c_23_filter)
   ___END_IF
___DEF_GLBL(___L8_c_23_filter)
   ___SET_R1(___NUL)
   ___JUMPRET(___R0)
___DEF_SLBL(4,___L4_c_23_filter)
   ___SET_R2(___CAR(___STK(-5)))
   ___SET_R1(___CONS(___R2,___R1))
   ___ADJFP(-7)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_c_23_filter)
   ___ADJFP(-1)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___t_2d_cpu_2d_utils_23_,___REF_SYM(1,___S___t_2d_cpu_2d_utils_23_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_utils_23_,0,-1)
,___DEF_LBL_INTRO(___H_c_23_safe_2d_car,___REF_SYM(6,___S_c_23_safe_2d_car),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_safe_2d_car,1,-1)
,___DEF_LBL_INTRO(___H_c_23_safe_2d_cdr,___REF_SYM(7,___S_c_23_safe_2d_cdr),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_safe_2d_cdr,1,-1)
,___DEF_LBL_INTRO(___H_c_23_flip,___REF_SYM(4,___S_c_23_flip),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_flip,1,-1)
,___DEF_LBL_RET(___H_c_23_flip,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_in_2d_range_3f_,___REF_SYM(5,___S_c_23_in_2d_range_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_in_2d_range_3f_,3,-1)
,___DEF_LBL_INTRO(___H_c_23_count,___REF_SYM(2,___S_c_23_count),___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_count,3,-1)
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_count,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_filter,___REF_SYM(3,___S_c_23_filter),___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_filter,2,-1)
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_filter,___IFD(___RETI,1,0,0x3f1L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___t_2d_cpu_2d_utils_23_,1)
___DEF_MOD_PRM(5,___G_c_23_safe_2d_car,3)
___DEF_MOD_PRM(6,___G_c_23_safe_2d_cdr,5)
___DEF_MOD_PRM(3,___G_c_23_flip,7)
___DEF_MOD_PRM(4,___G_c_23_in_2d_range_3f_,10)
___DEF_MOD_PRM(1,___G_c_23_count,12)
___DEF_MOD_PRM(2,___G_c_23_filter,18)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___t_2d_cpu_2d_utils_23_,1)
___DEF_MOD_GLO(5,___G_c_23_safe_2d_car,3)
___DEF_MOD_GLO(6,___G_c_23_safe_2d_cdr,5)
___DEF_MOD_GLO(3,___G_c_23_flip,7)
___DEF_MOD_GLO(4,___G_c_23_in_2d_range_3f_,10)
___DEF_MOD_GLO(1,___G_c_23_count,12)
___DEF_MOD_GLO(2,___G_c_23_filter,18)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___t_2d_cpu_2d_utils,"_t-cpu-utils")
___DEF_MOD_SYM(1,___S___t_2d_cpu_2d_utils_23_,"_t-cpu-utils#")
___DEF_MOD_SYM(2,___S_c_23_count,"c#count")
___DEF_MOD_SYM(3,___S_c_23_filter,"c#filter")
___DEF_MOD_SYM(4,___S_c_23_flip,"c#flip")
___DEF_MOD_SYM(5,___S_c_23_in_2d_range_3f_,"c#in-range?")
___DEF_MOD_SYM(6,___S_c_23_safe_2d_car,"c#safe-car")
___DEF_MOD_SYM(7,___S_c_23_safe_2d_cdr,"c#safe-cdr")
___END_MOD_SYM_KEY

#endif
