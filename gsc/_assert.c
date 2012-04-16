#ifdef ___LINKER_INFO
; File: "_assert.c", produced by Gambit-C v4.6.5
(
406005
" _assert"
(" _assert")
(
)
(
)
(
" _assert"
)
(
)
(
)
 #f
)
#else
#define ___VERSION 406005
#define ___MODULE_NAME " _assert"
#define ___LINKER_ID ____20___assert
#define ___MH_PROC ___H__20___assert
#define ___SCRIPT_LINE 0
#define ___GLO_COUNT 1
#define ___SUP_COUNT 1
#define ___LBL_COUNT 2
#include "gambit.h"

___NEED_GLO(___G__20___assert)

___BEGIN_GLO
___DEF_GLO(0," _assert")
___END_GLO


#undef ___MD_ALL
#define ___MD_ALL ___D_R0 ___D_R1
#undef ___MR_ALL
#define ___MR_ALL ___R_R0 ___R_R1
#undef ___MW_ALL
#define ___MW_ALL ___W_R1
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___assert)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___assert
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
___DEF_P_HLBL(___L0__20___assert)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___assert)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___assert)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___assert," _assert",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20___assert,0,0)
___END_LBL

___BEGIN_MOD1
___DEF_PRM(0,___G__20___assert,1)
___END_MOD1

___BEGIN_MOD2
___END_MOD2

#endif
