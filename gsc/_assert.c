#ifdef ___LINKER_INFO
; File: "_assert.c", produced by Gambit v4.8.2
(
408002
(C)
"_assert"
(("_assert"))
(
"_assert"
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
 ()
)
#else
#define ___VERSION 408002
#define ___MODULE_NAME "_assert"
#define ___LINKER_ID ____20___assert
#define ___MH_PROC ___H__20___assert
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 1
#define ___GLOCOUNT 1
#define ___SUPCOUNT 1
#define ___SUBCOUNT 1
#define ___LBLCOUNT 2
#define ___MODDESCR ___REF_SUB(0)
#include "gambit.h"

___NEED_SYM(___S___assert)

___NEED_GLO(___G__20___assert)

___BEGIN_SYM
___DEF_SYM(0,___S___assert,"_assert")
___END_SYM

#define ___SYM___assert ___SYM(0,___S___assert)

___BEGIN_GLO
___DEF_GLO(0," _assert")
___END_GLO

#define ___GLO__20___assert ___GLO(0,___G__20___assert)
#define ___PRM__20___assert ___PRM(0,___G__20___assert)

___DEF_SUB_VEC(___X0,5)
               ___VEC1(___REF_SYM(0,___S___assert))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FAL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
___END_SUB



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
,___DEF_LBL_PROC(___H__20___assert,0,-1)
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20___assert,1)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___assert,1)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___assert,"_assert")
___END_MOD_SYM_KEY

#endif
