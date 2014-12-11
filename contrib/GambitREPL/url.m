#ifdef ___LINKER_INFO
; File: "url.m", produced by Gambit-C v4.7.3
(
407003
" url"
((" url"))
(
"url"
)
(
)
(
" url"
)
(
"url#url-decode"
"url#url-encode"
)
(
"##append-strings"
"bitwise-and"
"make-string"
"reverse"
)
 ()
)
#else
#define ___VERSION 407003
#define ___MODULE_NAME " url"
#define ___LINKER_ID ____20_url
#define ___MH_PROC ___H__20_url
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 1
#define ___GLOCOUNT 7
#define ___SUPCOUNT 3
#define ___SUBCOUNT 2
#define ___LBLCOUNT 49
#define ___OFDCOUNT 8
#define ___MODDESCR ___REF_SUB(1)
#include "gambit.h"

___NEED_SYM(___S_url)

___NEED_GLO(___G__20_url)
___NEED_GLO(___G__23__23_append_2d_strings)
___NEED_GLO(___G_bitwise_2d_and)
___NEED_GLO(___G_make_2d_string)
___NEED_GLO(___G_reverse)
___NEED_GLO(___G_url_23_url_2d_decode)
___NEED_GLO(___G_url_23_url_2d_encode)

___BEGIN_SYM
___DEF_SYM(0,___S_url,"url")
___END_SYM

#define ___SYM_url ___SYM(0,___S_url)

___BEGIN_GLO
___DEF_GLO(0," url")
___DEF_GLO(1,"url#url-decode")
___DEF_GLO(2,"url#url-encode")
___DEF_GLO(3,"##append-strings")
___DEF_GLO(4,"bitwise-and")
___DEF_GLO(5,"make-string")
___DEF_GLO(6,"reverse")
___END_GLO

#define ___GLO__20_url ___GLO(0,___G__20_url)
#define ___PRM__20_url ___PRM(0,___G__20_url)
#define ___GLO_url_23_url_2d_decode ___GLO(1,___G_url_23_url_2d_decode)
#define ___PRM_url_23_url_2d_decode ___PRM(1,___G_url_23_url_2d_decode)
#define ___GLO_url_23_url_2d_encode ___GLO(2,___G_url_23_url_2d_encode)
#define ___PRM_url_23_url_2d_encode ___PRM(2,___G_url_23_url_2d_encode)
#define ___GLO__23__23_append_2d_strings ___GLO(3,___G__23__23_append_2d_strings)
#define ___PRM__23__23_append_2d_strings ___PRM(3,___G__23__23_append_2d_strings)
#define ___GLO_bitwise_2d_and ___GLO(4,___G_bitwise_2d_and)
#define ___PRM_bitwise_2d_and ___PRM(4,___G_bitwise_2d_and)
#define ___GLO_make_2d_string ___GLO(5,___G_make_2d_string)
#define ___PRM_make_2d_string ___PRM(5,___G_make_2d_string)
#define ___GLO_reverse ___GLO(6,___G_reverse)
#define ___PRM_reverse ___PRM(6,___G_reverse)

___DEF_SUB_STR(___X0,16)
               ___STR8(48,49,50,51,52,53,54,55)
               ___STR8(56,57,65,66,67,68,69,70)
               ___STR0
___DEF_SUB_VEC(___X1,5)
               ___VEC1(___REF_SYM(0,___S_url))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FAL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
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
___DEF_M_HLBL(___L0__20_url)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_url_23_url_2d_encode)
___DEF_M_HLBL(___L1_url_23_url_2d_encode)
___DEF_M_HLBL(___L2_url_23_url_2d_encode)
___DEF_M_HLBL(___L3_url_23_url_2d_encode)
___DEF_M_HLBL(___L4_url_23_url_2d_encode)
___DEF_M_HLBL(___L5_url_23_url_2d_encode)
___DEF_M_HLBL(___L6_url_23_url_2d_encode)
___DEF_M_HLBL(___L7_url_23_url_2d_encode)
___DEF_M_HLBL(___L8_url_23_url_2d_encode)
___DEF_M_HLBL(___L9_url_23_url_2d_encode)
___DEF_M_HLBL(___L10_url_23_url_2d_encode)
___DEF_M_HLBL(___L11_url_23_url_2d_encode)
___DEF_M_HLBL(___L12_url_23_url_2d_encode)
___DEF_M_HLBL(___L13_url_23_url_2d_encode)
___DEF_M_HLBL(___L14_url_23_url_2d_encode)
___DEF_M_HLBL(___L15_url_23_url_2d_encode)
___DEF_M_HLBL(___L16_url_23_url_2d_encode)
___DEF_M_HLBL(___L17_url_23_url_2d_encode)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_url_23_url_2d_decode)
___DEF_M_HLBL(___L1_url_23_url_2d_decode)
___DEF_M_HLBL(___L2_url_23_url_2d_decode)
___DEF_M_HLBL(___L3_url_23_url_2d_decode)
___DEF_M_HLBL(___L4_url_23_url_2d_decode)
___DEF_M_HLBL(___L5_url_23_url_2d_decode)
___DEF_M_HLBL(___L6_url_23_url_2d_decode)
___DEF_M_HLBL(___L7_url_23_url_2d_decode)
___DEF_M_HLBL(___L8_url_23_url_2d_decode)
___DEF_M_HLBL(___L9_url_23_url_2d_decode)
___DEF_M_HLBL(___L10_url_23_url_2d_decode)
___DEF_M_HLBL(___L11_url_23_url_2d_decode)
___DEF_M_HLBL(___L12_url_23_url_2d_decode)
___DEF_M_HLBL(___L13_url_23_url_2d_decode)
___DEF_M_HLBL(___L14_url_23_url_2d_decode)
___DEF_M_HLBL(___L15_url_23_url_2d_decode)
___DEF_M_HLBL(___L16_url_23_url_2d_decode)
___DEF_M_HLBL(___L17_url_23_url_2d_decode)
___DEF_M_HLBL(___L18_url_23_url_2d_decode)
___DEF_M_HLBL(___L19_url_23_url_2d_decode)
___DEF_M_HLBL(___L20_url_23_url_2d_decode)
___DEF_M_HLBL(___L21_url_23_url_2d_decode)
___DEF_M_HLBL(___L22_url_23_url_2d_decode)
___DEF_M_HLBL(___L23_url_23_url_2d_decode)
___DEF_M_HLBL(___L24_url_23_url_2d_decode)
___DEF_M_HLBL(___L25_url_23_url_2d_decode)
___DEF_M_HLBL(___L26_url_23_url_2d_decode)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20_url
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
___DEF_P_HLBL(___L0__20_url)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20_url)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20_url)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_url_23_url_2d_encode
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_url_23_url_2d_encode)
___DEF_P_HLBL(___L1_url_23_url_2d_encode)
___DEF_P_HLBL(___L2_url_23_url_2d_encode)
___DEF_P_HLBL(___L3_url_23_url_2d_encode)
___DEF_P_HLBL(___L4_url_23_url_2d_encode)
___DEF_P_HLBL(___L5_url_23_url_2d_encode)
___DEF_P_HLBL(___L6_url_23_url_2d_encode)
___DEF_P_HLBL(___L7_url_23_url_2d_encode)
___DEF_P_HLBL(___L8_url_23_url_2d_encode)
___DEF_P_HLBL(___L9_url_23_url_2d_encode)
___DEF_P_HLBL(___L10_url_23_url_2d_encode)
___DEF_P_HLBL(___L11_url_23_url_2d_encode)
___DEF_P_HLBL(___L12_url_23_url_2d_encode)
___DEF_P_HLBL(___L13_url_23_url_2d_encode)
___DEF_P_HLBL(___L14_url_23_url_2d_encode)
___DEF_P_HLBL(___L15_url_23_url_2d_encode)
___DEF_P_HLBL(___L16_url_23_url_2d_encode)
___DEF_P_HLBL(___L17_url_23_url_2d_encode)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_url_23_url_2d_encode)
   ___IF_NARGS_EQ(1,___PUSH(___R1) ___SET_R1(___FIX(0L)) ___SET_R2(___ABSENT) ___SET_R3(___FAL)
)
   ___IF_NARGS_EQ(2,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___ABSENT) ___SET_R3(___FAL))
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FAL))
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,1,3,0)
___DEF_GLBL(___L_url_23_url_2d_encode)
   ___IF(___NOT(___EQP(___R2,___ABSENT)))
   ___GOTO(___L18_url_23_url_2d_encode)
   ___END_IF
   ___SET_R2(___STRINGLENGTH(___STK(0)))
___DEF_GLBL(___L18_url_23_url_2d_encode)
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(2))
   ___SET_R3(___NUL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_url_23_url_2d_encode)
   ___GOTO(___L19_url_23_url_2d_encode)
___DEF_SLBL(2,___L2_url_23_url_2d_encode)
   ___SET_R3(___CONS(___R1,___STK(-7)))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-8))
   ___SET_R0(___STK(-9))
   ___ADJFP(-10)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_url_23_url_2d_encode)
   ___POLL(4)
___DEF_SLBL(4,___L4_url_23_url_2d_encode)
___DEF_GLBL(___L19_url_23_url_2d_encode)
   ___SET_R4(___FIXSUB(___R1,___R2))
   ___SET_R4(___FIXMIN(___R4,___FIX(1024L)))
   ___IF(___NOT(___FIXEQ(___R4,___FIX(0L))))
   ___GOTO(___L20_url_23_url_2d_encode)
   ___END_IF
   ___SET_STK(-1,___R0)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(6))
   ___ADJFP(2)
   ___POLL(5)
___DEF_SLBL(5,___L5_url_23_url_2d_encode)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(6,___L6_url_23_url_2d_encode)
   ___SET_R0(___STK(-3))
   ___POLL(7)
___DEF_SLBL(7,___L7_url_23_url_2d_encode)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),3,___G__23__23_append_2d_strings)
___DEF_GLBL(___L20_url_23_url_2d_encode)
   ___SET_R4(___FIXADD(___R2,___R4))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R4)
   ___SET_STK(11,___STK(-1))
   ___SET_STK(12,___STK(0))
   ___SET_R3(___R4)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___ADJFP(12)
   ___POLL(8)
___DEF_SLBL(8,___L8_url_23_url_2d_encode)
   ___GOTO(___L26_url_23_url_2d_encode)
___DEF_GLBL(___L21_url_23_url_2d_encode)
   ___SET_R4(___STRINGREF(___STK(-1),___R2))
   ___IF(___NOT(___CHARGEP(___R4,___CHR(97))))
   ___GOTO(___L22_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHARLEP(___R4,___CHR(122)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
___DEF_GLBL(___L22_url_23_url_2d_encode)
   ___IF(___NOT(___CHARGEP(___R4,___CHR(65))))
   ___GOTO(___L23_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHARLEP(___R4,___CHR(90)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
___DEF_GLBL(___L23_url_23_url_2d_encode)
   ___IF(___NOT(___CHARGEP(___R4,___CHR(48))))
   ___GOTO(___L24_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHARLEP(___R4,___CHR(57)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
___DEF_GLBL(___L24_url_23_url_2d_encode)
   ___IF(___CHAREQP(___R4,___CHR(45)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(95)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(46)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(33)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(126)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(42)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(39)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(40)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(41)))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
   ___IF(___NOT(___CHAREQP(___R4,___CHR(32))))
   ___GOTO(___L25_url_23_url_2d_encode)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(0))))
   ___GOTO(___L27_url_23_url_2d_encode)
   ___END_IF
___DEF_GLBL(___L25_url_23_url_2d_encode)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R4)
   ___SET_STK(7,___STK(-1))
   ___SET_STK(8,___STK(0))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_R1(___FIXADD(___R1,___FIX(3L)))
   ___SET_R0(___LBL(14))
   ___ADJFP(8)
   ___POLL(9)
___DEF_SLBL(9,___L9_url_23_url_2d_encode)
___DEF_GLBL(___L26_url_23_url_2d_encode)
   ___IF(___FIXLT(___R2,___R3))
   ___GOTO(___L21_url_23_url_2d_encode)
   ___END_IF
   ___POLL(10)
___DEF_SLBL(10,___L10_url_23_url_2d_encode)
   ___ADJFP(-2)
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_string)
___DEF_GLBL(___L27_url_23_url_2d_encode)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R4)
   ___SET_STK(7,___STK(-1))
   ___SET_STK(8,___STK(0))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_R0(___LBL(12))
   ___ADJFP(8)
   ___POLL(11)
___DEF_SLBL(11,___L11_url_23_url_2d_encode)
   ___GOTO(___L26_url_23_url_2d_encode)
___DEF_SLBL(12,___L12_url_23_url_2d_encode)
   ___IF(___NOT(___CHAREQP(___STK(-3),___CHR(32))))
   ___GOTO(___L28_url_23_url_2d_encode)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(-6))))
   ___GOTO(___L29_url_23_url_2d_encode)
   ___END_IF
___DEF_GLBL(___L28_url_23_url_2d_encode)
   ___SET_R2(___STK(-3))
   ___GOTO(___L30_url_23_url_2d_encode)
___DEF_GLBL(___L29_url_23_url_2d_encode)
   ___SET_R2(___CHR(43))
___DEF_GLBL(___L30_url_23_url_2d_encode)
   ___STRINGSET(___R1,___STK(-4),___R2)
   ___POLL(13)
___DEF_SLBL(13,___L13_url_23_url_2d_encode)
___DEF_GLBL(___L31_url_23_url_2d_encode)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___DEF_SLBL(14,___L14_url_23_url_2d_encode)
   ___SET_R2(___FIXFROMCHR(___STK(-3)))
   ___SET_R3(___FIXADD(___STK(-4),___FIX(0L)))
   ___STRINGSET(___R1,___R3,___CHR(37))
   ___SET_R3(___FIXASH(___R2,___FIX(-4L)))
   ___SET_STK(-7,___R1)
   ___SET_STK(-6,___R2)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(15L))
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(2),___PRM_bitwise_2d_and)
___DEF_SLBL(15,___L15_url_23_url_2d_encode)
   ___SET_R1(___STRINGREF(___SUB(0),___R1))
   ___SET_R2(___FIXADD(___STK(-4),___FIX(1L)))
   ___STRINGSET(___STK(-7),___R2,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(15L))
   ___SET_R0(___LBL(16))
   ___JUMPPRM(___SET_NARGS(2),___PRM_bitwise_2d_and)
___DEF_SLBL(16,___L16_url_23_url_2d_encode)
   ___SET_R1(___STRINGREF(___SUB(0),___R1))
   ___SET_R2(___FIXADD(___STK(-4),___FIX(2L)))
   ___STRINGSET(___STK(-7),___R2,___R1)
   ___SET_R1(___STK(-7))
   ___POLL(17)
___DEF_SLBL(17,___L17_url_23_url_2d_encode)
   ___GOTO(___L31_url_23_url_2d_encode)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_url_23_url_2d_decode
#undef ___PH_LBL0
#define ___PH_LBL0 22
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_url_23_url_2d_decode)
___DEF_P_HLBL(___L1_url_23_url_2d_decode)
___DEF_P_HLBL(___L2_url_23_url_2d_decode)
___DEF_P_HLBL(___L3_url_23_url_2d_decode)
___DEF_P_HLBL(___L4_url_23_url_2d_decode)
___DEF_P_HLBL(___L5_url_23_url_2d_decode)
___DEF_P_HLBL(___L6_url_23_url_2d_decode)
___DEF_P_HLBL(___L7_url_23_url_2d_decode)
___DEF_P_HLBL(___L8_url_23_url_2d_decode)
___DEF_P_HLBL(___L9_url_23_url_2d_decode)
___DEF_P_HLBL(___L10_url_23_url_2d_decode)
___DEF_P_HLBL(___L11_url_23_url_2d_decode)
___DEF_P_HLBL(___L12_url_23_url_2d_decode)
___DEF_P_HLBL(___L13_url_23_url_2d_decode)
___DEF_P_HLBL(___L14_url_23_url_2d_decode)
___DEF_P_HLBL(___L15_url_23_url_2d_decode)
___DEF_P_HLBL(___L16_url_23_url_2d_decode)
___DEF_P_HLBL(___L17_url_23_url_2d_decode)
___DEF_P_HLBL(___L18_url_23_url_2d_decode)
___DEF_P_HLBL(___L19_url_23_url_2d_decode)
___DEF_P_HLBL(___L20_url_23_url_2d_decode)
___DEF_P_HLBL(___L21_url_23_url_2d_decode)
___DEF_P_HLBL(___L22_url_23_url_2d_decode)
___DEF_P_HLBL(___L23_url_23_url_2d_decode)
___DEF_P_HLBL(___L24_url_23_url_2d_decode)
___DEF_P_HLBL(___L25_url_23_url_2d_decode)
___DEF_P_HLBL(___L26_url_23_url_2d_decode)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_url_23_url_2d_decode)
   ___IF_NARGS_EQ(1,___PUSH(___R1) ___SET_R1(___FIX(0L)) ___SET_R2(___ABSENT) ___SET_R3(___FAL)
)
   ___IF_NARGS_EQ(2,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___ABSENT) ___SET_R3(___FAL))
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FAL))
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,1,3,0)
___DEF_GLBL(___L_url_23_url_2d_decode)
   ___IF(___NOT(___EQP(___R2,___ABSENT)))
   ___GOTO(___L27_url_23_url_2d_decode)
   ___END_IF
   ___SET_R2(___STRINGLENGTH(___STK(0)))
___DEF_GLBL(___L27_url_23_url_2d_decode)
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(2))
   ___SET_R3(___NUL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_url_23_url_2d_decode)
   ___GOTO(___L28_url_23_url_2d_decode)
___DEF_SLBL(2,___L2_url_23_url_2d_decode)
   ___SET_STK(-2,___R1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L32_url_23_url_2d_decode)
   ___END_IF
   ___SET_R1(___CDR(___STK(-2)))
   ___SET_R3(___CONS(___R1,___STK(-3)))
   ___SET_R2(___CAR(___STK(-2)))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-5))
   ___ADJFP(-6)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_url_23_url_2d_decode)
   ___POLL(4)
___DEF_SLBL(4,___L4_url_23_url_2d_decode)
___DEF_GLBL(___L28_url_23_url_2d_decode)
   ___IF(___NOT(___FIXLT(___R2,___R1)))
   ___GOTO(___L55_url_23_url_2d_decode)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_STK(7,___STK(-1))
   ___SET_STK(8,___STK(0))
   ___SET_R3(___R1)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(8))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_url_23_url_2d_decode)
___DEF_GLBL(___L29_url_23_url_2d_decode)
   ___IF(___NOT(___FIXLT(___R2,___R3)))
   ___GOTO(___L35_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L30_url_23_url_2d_decode)
   ___IF(___NOT(___FIXLT(___R1,___FIX(1024L))))
   ___GOTO(___L35_url_23_url_2d_decode)
   ___END_IF
   ___SET_R4(___STRINGREF(___STK(-1),___R2))
   ___IF(___NOT(___CHARGEP(___R4,___CHR(97))))
   ___GOTO(___L44_url_23_url_2d_decode)
   ___END_IF
   ___IF(___NOT(___CHARLEP(___R4,___CHR(122))))
   ___GOTO(___L44_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L31_url_23_url_2d_decode)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R4)
   ___SET_STK(7,___STK(-1))
   ___SET_STK(8,___STK(0))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_url_23_url_2d_decode)
   ___GOTO(___L29_url_23_url_2d_decode)
___DEF_SLBL(7,___L7_url_23_url_2d_decode)
   ___SET_STK(-7,___R1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L32_url_23_url_2d_decode)
   ___END_IF
   ___GOTO(___L40_url_23_url_2d_decode)
___DEF_SLBL(8,___L8_url_23_url_2d_decode)
   ___SET_STK(-2,___R1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L34_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L32_url_23_url_2d_decode)
   ___POLL(9)
___DEF_SLBL(9,___L9_url_23_url_2d_decode)
___DEF_GLBL(___L33_url_23_url_2d_decode)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___DEF_GLBL(___L34_url_23_url_2d_decode)
   ___SET_R1(___CAR(___STK(-2)))
   ___SET_R2(___CDR(___STK(-2)))
   ___SET_R2(___CONS(___R2,___STK(-3)))
   ___CHECK_HEAP(10,4096)
___DEF_SLBL(10,___L10_url_23_url_2d_decode)
   ___IF(___NOT(___FIXLT(___R1,___STK(-4))))
   ___GOTO(___L39_url_23_url_2d_decode)
   ___END_IF
   ___SET_STK(-3,___R2)
   ___SET_STK(1,___STK(-7))
   ___SET_STK(2,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___R1)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___ADJFP(2)
   ___IF(___FIXLT(___R2,___R3))
   ___GOTO(___L30_url_23_url_2d_decode)
   ___END_IF
   ___GOTO(___L35_url_23_url_2d_decode)
___DEF_SLBL(11,___L11_url_23_url_2d_decode)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L36_url_23_url_2d_decode)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L36_url_23_url_2d_decode)
   ___END_IF
   ___SET_STK(1,___STK(-11))
   ___SET_STK(2,___STK(-10))
   ___SET_R3(___STK(-6))
   ___SET_R2(___FIXADD(___STK(-7),___FIX(3L)))
   ___SET_R1(___FIXADD(___STK(-8),___FIX(1L)))
   ___SET_R0(___LBL(16))
   ___ADJFP(2)
   ___IF(___FIXLT(___R2,___R3))
   ___GOTO(___L30_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L35_url_23_url_2d_decode)
   ___SET_STK(-1,___R0)
   ___SET_STK(0,___R2)
   ___SET_R0(___LBL(13))
   ___ADJFP(6)
   ___POLL(12)
___DEF_SLBL(12,___L12_url_23_url_2d_decode)
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_string)
___DEF_SLBL(13,___L13_url_23_url_2d_decode)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_url_23_url_2d_decode)
   ___POLL(15)
___DEF_SLBL(15,___L15_url_23_url_2d_decode)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(16,___L16_url_23_url_2d_decode)
   ___SET_STK(-11,___R1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L38_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L36_url_23_url_2d_decode)
   ___POLL(17)
___DEF_SLBL(17,___L17_url_23_url_2d_decode)
___DEF_GLBL(___L37_url_23_url_2d_decode)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___DEF_GLBL(___L38_url_23_url_2d_decode)
   ___SET_R1(___FIXASH(___STK(-5),___FIX(4L)))
   ___SET_R1(___FIXADD(___R1,___STK(-4)))
   ___SET_R1(___FIXTOCHR(___R1))
   ___SET_R2(___CDR(___STK(-11)))
   ___STRINGSET(___R2,___STK(-8),___R1)
   ___SET_R1(___STK(-11))
   ___POLL(18)
___DEF_SLBL(18,___L18_url_23_url_2d_decode)
   ___GOTO(___L37_url_23_url_2d_decode)
___DEF_GLBL(___L39_url_23_url_2d_decode)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(19))
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(19,___L19_url_23_url_2d_decode)
   ___SET_R0(___STK(-5))
   ___POLL(20)
___DEF_SLBL(20,___L20_url_23_url_2d_decode)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),3,___G__23__23_append_2d_strings)
___DEF_GLBL(___L40_url_23_url_2d_decode)
   ___IF(___NOT(___CHAREQP(___STK(-3),___CHR(43))))
   ___GOTO(___L41_url_23_url_2d_decode)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(-6))))
   ___GOTO(___L42_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L41_url_23_url_2d_decode)
   ___SET_R1(___STK(-3))
   ___GOTO(___L43_url_23_url_2d_decode)
___DEF_GLBL(___L42_url_23_url_2d_decode)
   ___SET_R1(___CHR(32))
___DEF_GLBL(___L43_url_23_url_2d_decode)
   ___SET_R2(___CDR(___STK(-7)))
   ___STRINGSET(___R2,___STK(-4),___R1)
   ___SET_R1(___STK(-7))
   ___POLL(21)
___DEF_SLBL(21,___L21_url_23_url_2d_decode)
   ___GOTO(___L33_url_23_url_2d_decode)
___DEF_GLBL(___L44_url_23_url_2d_decode)
   ___IF(___NOT(___CHARGEP(___R4,___CHR(65))))
   ___GOTO(___L45_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHARLEP(___R4,___CHR(90)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L45_url_23_url_2d_decode)
   ___IF(___NOT(___CHARGEP(___R4,___CHR(48))))
   ___GOTO(___L46_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHARLEP(___R4,___CHR(57)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L46_url_23_url_2d_decode)
   ___IF(___CHAREQP(___R4,___CHR(45)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(95)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(46)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(33)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(126)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(42)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(39)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(40)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHAREQP(___R4,___CHR(41)))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
   ___IF(___NOT(___CHAREQP(___R4,___CHR(43))))
   ___GOTO(___L47_url_23_url_2d_decode)
   ___END_IF
   ___IF(___NOT(___FALSEP(___STK(0))))
   ___GOTO(___L31_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L47_url_23_url_2d_decode)
   ___IF(___NOT(___CHAREQP(___R4,___CHR(37))))
   ___GOTO(___L54_url_23_url_2d_decode)
   ___END_IF
   ___SET_R4(___FIXADD(___R2,___FIX(2L)))
   ___IF(___NOT(___FIXLT(___R4,___R3)))
   ___GOTO(___L54_url_23_url_2d_decode)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIXADD(___R2,___FIX(1L)))
   ___SET_R1(___STRINGREF(___STK(-1),___R1))
   ___SET_R0(___LBL(23))
   ___ADJFP(10)
   ___POLL(22)
___DEF_SLBL(22,___L22_url_23_url_2d_decode)
   ___IF(___CHARGEP(___R1,___CHR(48)))
   ___GOTO(___L48_url_23_url_2d_decode)
   ___END_IF
   ___GOTO(___L49_url_23_url_2d_decode)
___DEF_SLBL(23,___L23_url_23_url_2d_decode)
   ___SET_STK(-5,___R1)
   ___SET_R1(___FIXADD(___STK(-7),___FIX(2L)))
   ___SET_R1(___STRINGREF(___STK(-11),___R1))
   ___SET_R0(___LBL(11))
   ___IF(___NOT(___CHARGEP(___R1,___CHR(48))))
   ___GOTO(___L49_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L48_url_23_url_2d_decode)
   ___IF(___CHARLEP(___R1,___CHR(57)))
   ___GOTO(___L53_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L49_url_23_url_2d_decode)
   ___IF(___NOT(___CHARGEP(___R1,___CHR(97))))
   ___GOTO(___L50_url_23_url_2d_decode)
   ___END_IF
   ___IF(___CHARLEP(___R1,___CHR(102)))
   ___GOTO(___L52_url_23_url_2d_decode)
   ___END_IF
___DEF_GLBL(___L50_url_23_url_2d_decode)
   ___IF(___NOT(___CHARGEP(___R1,___CHR(65))))
   ___GOTO(___L51_url_23_url_2d_decode)
   ___END_IF
   ___IF(___NOT(___CHARLEP(___R1,___CHR(70))))
   ___GOTO(___L51_url_23_url_2d_decode)
   ___END_IF
   ___SET_R1(___FIXFROMCHR(___R1))
   ___SET_R2(___FIXFROMCHR(___CHR(65)))
   ___SET_R1(___FIXSUB(___R1,___R2))
   ___SET_R1(___FIXADD(___FIX(10L),___R1))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L51_url_23_url_2d_decode)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L52_url_23_url_2d_decode)
   ___SET_R1(___FIXFROMCHR(___R1))
   ___SET_R2(___FIXFROMCHR(___CHR(97)))
   ___SET_R1(___FIXSUB(___R1,___R2))
   ___SET_R1(___FIXADD(___FIX(10L),___R1))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L53_url_23_url_2d_decode)
   ___SET_R1(___FIXFROMCHR(___R1))
   ___SET_R2(___FIXFROMCHR(___CHR(48)))
   ___SET_R1(___FIXSUB(___R1,___R2))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L54_url_23_url_2d_decode)
   ___SET_R1(___FAL)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L55_url_23_url_2d_decode)
   ___SET_STK(-1,___R0)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(25))
   ___ADJFP(2)
   ___POLL(24)
___DEF_SLBL(24,___L24_url_23_url_2d_decode)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(25,___L25_url_23_url_2d_decode)
   ___SET_R0(___STK(-3))
   ___POLL(26)
___DEF_SLBL(26,___L26_url_23_url_2d_decode)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),3,___G__23__23_append_2d_strings)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20_url," url",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20_url,0,-1)
,___DEF_LBL_INTRO(___H_url_23_url_2d_encode,"url#url-encode",___REF_FAL,18,0)
,___DEF_LBL_PROC(___H_url_23_url_2d_encode,4,-1)
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___OFD(___RETI,14,2,0x3f303fL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___OFD(___RETI,10,2,0x3f31cL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___OFD(___RETI,10,2,0x3f31eL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETN,5,2,0x1eL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETN,5,2,0x1cL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETN,5,2,0xfL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETN,5,2,0xdL))
,___DEF_LBL_RET(___H_url_23_url_2d_encode,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_INTRO(___H_url_23_url_2d_decode,"url#url-decode",___REF_FAL,27,0)
,___DEF_LBL_PROC(___H_url_23_url_2d_decode,4,-1)
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___OFD(___RETI,10,2,0x3f31fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___OFD(___RETI,10,2,0x3f31eL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,5,2,0x1eL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,5,2,0x1fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,2,0x3f0fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,9,2,0x7fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,9,2,0xccL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,5,2,0x4L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___OFD(___RETI,12,2,0x3f03fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_url_23_url_2d_decode,___IFD(___RETI,4,4,0x3f0L))
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,14,2)
               ___GCMAP1(0x3f303fL)
,___DEF_OFD(___RETI,10,2)
               ___GCMAP1(0x3f31cL)
,___DEF_OFD(___RETI,10,2)
               ___GCMAP1(0x3f31eL)
,___DEF_OFD(___RETI,10,2)
               ___GCMAP1(0x3f31fL)
,___DEF_OFD(___RETI,10,2)
               ___GCMAP1(0x3f31eL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f03fL)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20_url,1)
___DEF_MOD_PRM(2,___G_url_23_url_2d_encode,3)
___DEF_MOD_PRM(1,___G_url_23_url_2d_decode,22)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20_url,1)
___DEF_MOD_GLO(2,___G_url_23_url_2d_encode,3)
___DEF_MOD_GLO(1,___G_url_23_url_2d_decode,22)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S_url,"url")
___END_MOD_SYM_KEY

#endif
