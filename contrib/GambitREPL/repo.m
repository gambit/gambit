#ifdef ___LINKER_INFO
; File: "repo.m", produced by Gambit-C v4.7.3
(
407003
" repo"
((" repo"))
(
"repo"
)
(
)
(
" repo"
"repo#get-login-info"
"repo#login-info"
"repo#save-login-info"
)
(
"repo#login-info-version"
"repo#predefined-login-info"
"repo#reset-login-info"
"repo#set-login-info"
)
(
"caddr"
"car"
"cdr"
"equal?"
"intf#get-pref"
"intf#set-pref"
"read"
"with-input-from-string"
"with-output-to-string"
"write"
)
 ()
)
#else
#define ___VERSION 407003
#define ___MODULE_NAME " repo"
#define ___LINKER_ID ____20_repo
#define ___MH_PROC ___H__20_repo
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 1
#define ___GLOCOUNT 18
#define ___SUPCOUNT 8
#define ___CNSCOUNT 3
#define ___SUBCOUNT 10
#define ___LBLCOUNT 29
#define ___MODDESCR ___REF_SUB(9)
#include "gambit.h"

___NEED_SYM(___S_repo)

___NEED_GLO(___G__20_repo)
___NEED_GLO(___G_caddr)
___NEED_GLO(___G_car)
___NEED_GLO(___G_cdr)
___NEED_GLO(___G_equal_3f_)
___NEED_GLO(___G_intf_23_get_2d_pref)
___NEED_GLO(___G_intf_23_set_2d_pref)
___NEED_GLO(___G_read)
___NEED_GLO(___G_repo_23_get_2d_login_2d_info)
___NEED_GLO(___G_repo_23_login_2d_info)
___NEED_GLO(___G_repo_23_login_2d_info_2d_version)
___NEED_GLO(___G_repo_23_predefined_2d_login_2d_info)
___NEED_GLO(___G_repo_23_reset_2d_login_2d_info)
___NEED_GLO(___G_repo_23_save_2d_login_2d_info)
___NEED_GLO(___G_repo_23_set_2d_login_2d_info)
___NEED_GLO(___G_with_2d_input_2d_from_2d_string)
___NEED_GLO(___G_with_2d_output_2d_to_2d_string)
___NEED_GLO(___G_write)

___BEGIN_SYM
___DEF_SYM(0,___S_repo,"repo")
___END_SYM

#define ___SYM_repo ___SYM(0,___S_repo)

___BEGIN_GLO
___DEF_GLO(0," repo")
___DEF_GLO(1,"repo#get-login-info")
___DEF_GLO(2,"repo#login-info")
___DEF_GLO(3,"repo#login-info-version")
___DEF_GLO(4,"repo#predefined-login-info")
___DEF_GLO(5,"repo#reset-login-info")
___DEF_GLO(6,"repo#save-login-info")
___DEF_GLO(7,"repo#set-login-info")
___DEF_GLO(8,"caddr")
___DEF_GLO(9,"car")
___DEF_GLO(10,"cdr")
___DEF_GLO(11,"equal?")
___DEF_GLO(12,"intf#get-pref")
___DEF_GLO(13,"intf#set-pref")
___DEF_GLO(14,"read")
___DEF_GLO(15,"with-input-from-string")
___DEF_GLO(16,"with-output-to-string")
___DEF_GLO(17,"write")
___END_GLO

#define ___GLO__20_repo ___GLO(0,___G__20_repo)
#define ___PRM__20_repo ___PRM(0,___G__20_repo)
#define ___GLO_repo_23_get_2d_login_2d_info ___GLO(1,___G_repo_23_get_2d_login_2d_info)
#define ___PRM_repo_23_get_2d_login_2d_info ___PRM(1,___G_repo_23_get_2d_login_2d_info)
#define ___GLO_repo_23_login_2d_info ___GLO(2,___G_repo_23_login_2d_info)
#define ___PRM_repo_23_login_2d_info ___PRM(2,___G_repo_23_login_2d_info)
#define ___GLO_repo_23_login_2d_info_2d_version ___GLO(3,___G_repo_23_login_2d_info_2d_version)
#define ___PRM_repo_23_login_2d_info_2d_version ___PRM(3,___G_repo_23_login_2d_info_2d_version)
#define ___GLO_repo_23_predefined_2d_login_2d_info ___GLO(4,___G_repo_23_predefined_2d_login_2d_info)
#define ___PRM_repo_23_predefined_2d_login_2d_info ___PRM(4,___G_repo_23_predefined_2d_login_2d_info)
#define ___GLO_repo_23_reset_2d_login_2d_info ___GLO(5,___G_repo_23_reset_2d_login_2d_info)
#define ___PRM_repo_23_reset_2d_login_2d_info ___PRM(5,___G_repo_23_reset_2d_login_2d_info)
#define ___GLO_repo_23_save_2d_login_2d_info ___GLO(6,___G_repo_23_save_2d_login_2d_info)
#define ___PRM_repo_23_save_2d_login_2d_info ___PRM(6,___G_repo_23_save_2d_login_2d_info)
#define ___GLO_repo_23_set_2d_login_2d_info ___GLO(7,___G_repo_23_set_2d_login_2d_info)
#define ___PRM_repo_23_set_2d_login_2d_info ___PRM(7,___G_repo_23_set_2d_login_2d_info)
#define ___GLO_caddr ___GLO(8,___G_caddr)
#define ___PRM_caddr ___PRM(8,___G_caddr)
#define ___GLO_car ___GLO(9,___G_car)
#define ___PRM_car ___PRM(9,___G_car)
#define ___GLO_cdr ___GLO(10,___G_cdr)
#define ___PRM_cdr ___PRM(10,___G_cdr)
#define ___GLO_equal_3f_ ___GLO(11,___G_equal_3f_)
#define ___PRM_equal_3f_ ___PRM(11,___G_equal_3f_)
#define ___GLO_intf_23_get_2d_pref ___GLO(12,___G_intf_23_get_2d_pref)
#define ___PRM_intf_23_get_2d_pref ___PRM(12,___G_intf_23_get_2d_pref)
#define ___GLO_intf_23_set_2d_pref ___GLO(13,___G_intf_23_set_2d_pref)
#define ___PRM_intf_23_set_2d_pref ___PRM(13,___G_intf_23_set_2d_pref)
#define ___GLO_read ___GLO(14,___G_read)
#define ___PRM_read ___PRM(14,___G_read)
#define ___GLO_with_2d_input_2d_from_2d_string ___GLO(15,___G_with_2d_input_2d_from_2d_string)
#define ___PRM_with_2d_input_2d_from_2d_string ___PRM(15,___G_with_2d_input_2d_from_2d_string)
#define ___GLO_with_2d_output_2d_to_2d_string ___GLO(16,___G_with_2d_output_2d_to_2d_string)
#define ___PRM_with_2d_output_2d_to_2d_string ___PRM(16,___G_with_2d_output_2d_to_2d_string)
#define ___GLO_write ___GLO(17,___G_write)
#define ___PRM_write ___PRM(17,___G_write)

___BEGIN_CNS
 ___DEF_CNS(___REF_SUB(0),___REF_CNS(1))
,___DEF_CNS(___REF_SUB(1),___REF_CNS(2))
,___DEF_CNS(___REF_TRU,___REF_NUL)
___END_CNS

___DEF_SUB_STR(___X0,0)
               ___STR0
___DEF_SUB_STR(___X1,0)
               ___STR0
___DEF_SUB_STR(___X2,3)
               ___STR3(49,46,48)
___DEF_SUB_STR(___X3,0)
               ___STR0
___DEF_SUB_STR(___X4,0)
               ___STR0
___DEF_SUB_STR(___X5,0)
               ___STR0
___DEF_SUB_STR(___X6,10)
               ___STR8(108,111,103,105,110,45,105,110)
               ___STR2(102,111)
___DEF_SUB_STR(___X7,0)
               ___STR0
___DEF_SUB_STR(___X8,10)
               ___STR8(108,111,103,105,110,45,105,110)
               ___STR2(102,111)
___DEF_SUB_VEC(___X9,5)
               ___VEC1(___REF_SYM(0,___S_repo))
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
,___DEF_SUB(___X4)
,___DEF_SUB(___X5)
,___DEF_SUB(___X6)
,___DEF_SUB(___X7)
,___DEF_SUB(___X8)
,___DEF_SUB(___X9)
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
___DEF_M_HLBL(___L0__20_repo)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_repo_23_reset_2d_login_2d_info)
___DEF_M_HLBL(___L1_repo_23_reset_2d_login_2d_info)
___DEF_M_HLBL(___L2_repo_23_reset_2d_login_2d_info)
___DEF_M_HLBL(___L3_repo_23_reset_2d_login_2d_info)
___DEF_M_HLBL(___L4_repo_23_reset_2d_login_2d_info)
___DEF_M_HLBL(___L5_repo_23_reset_2d_login_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_repo_23_set_2d_login_2d_info)
___DEF_M_HLBL(___L1_repo_23_set_2d_login_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L1_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L2_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L3_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L4_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L5_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L6_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL(___L7_repo_23_get_2d_login_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_repo_23_save_2d_login_2d_info)
___DEF_M_HLBL(___L1_repo_23_save_2d_login_2d_info)
___DEF_M_HLBL(___L2_repo_23_save_2d_login_2d_info)
___DEF_M_HLBL(___L3_repo_23_save_2d_login_2d_info)
___DEF_M_HLBL(___L4_repo_23_save_2d_login_2d_info)
___DEF_M_HLBL(___L5_repo_23_save_2d_login_2d_info)
___DEF_M_HLBL(___L6_repo_23_save_2d_login_2d_info)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20_repo
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
___DEF_P_HLBL(___L0__20_repo)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20_repo)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20_repo)
   ___SET_GLO(4,___G_repo_23_predefined_2d_login_2d_info,___CNS(0))
   ___SET_GLO(2,___G_repo_23_login_2d_info,___FAL)
   ___SET_GLO(3,___G_repo_23_login_2d_info_2d_version,___SUB(2))
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_repo_23_reset_2d_login_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_repo_23_reset_2d_login_2d_info)
___DEF_P_HLBL(___L1_repo_23_reset_2d_login_2d_info)
___DEF_P_HLBL(___L2_repo_23_reset_2d_login_2d_info)
___DEF_P_HLBL(___L3_repo_23_reset_2d_login_2d_info)
___DEF_P_HLBL(___L4_repo_23_reset_2d_login_2d_info)
___DEF_P_HLBL(___L5_repo_23_reset_2d_login_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_repo_23_reset_2d_login_2d_info)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_repo_23_reset_2d_login_2d_info)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_repo_23_reset_2d_login_2d_info)
   ___JUMPINT(___SET_NARGS(0),___PRC(13),___L_repo_23_get_2d_login_2d_info)
___DEF_SLBL(2,___L2_repo_23_reset_2d_login_2d_info)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L6_repo_23_reset_2d_login_2d_info)
   ___END_IF
   ___SET_R2(___CDR(___R1))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L7_repo_23_reset_2d_login_2d_info)
   ___END_IF
   ___GOTO(___L12_repo_23_reset_2d_login_2d_info)
___DEF_GLBL(___L6_repo_23_reset_2d_login_2d_info)
   ___SET_R2(___FAL)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L12_repo_23_reset_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L7_repo_23_reset_2d_login_2d_info)
   ___SET_R2(___CDR(___R2))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L13_repo_23_reset_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L8_repo_23_reset_2d_login_2d_info)
   ___SET_R1(___CAR(___R2))
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L11_repo_23_reset_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L9_repo_23_reset_2d_login_2d_info)
   ___SET_R2(___SUB(3))
___DEF_GLBL(___L10_repo_23_reset_2d_login_2d_info)
   ___BEGIN_ALLOC_LIST(3,___R1)
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___SUB(4))
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___SET_GLO(2,___G_repo_23_login_2d_info,___R1)
   ___SET_R0(___STK(-3))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_repo_23_reset_2d_login_2d_info)
   ___POLL(4)
___DEF_SLBL(4,___L4_repo_23_reset_2d_login_2d_info)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(22),___L_repo_23_save_2d_login_2d_info)
___DEF_SLBL(5,___L5_repo_23_reset_2d_login_2d_info)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L9_repo_23_reset_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L11_repo_23_reset_2d_login_2d_info)
   ___SET_R2(___SUB(5))
   ___GOTO(___L10_repo_23_reset_2d_login_2d_info)
___DEF_GLBL(___L12_repo_23_reset_2d_login_2d_info)
   ___SET_R2(___FAL)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L8_repo_23_reset_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L13_repo_23_reset_2d_login_2d_info)
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_caddr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_repo_23_set_2d_login_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 10
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_repo_23_set_2d_login_2d_info)
___DEF_P_HLBL(___L1_repo_23_set_2d_login_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_repo_23_set_2d_login_2d_info)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_repo_23_set_2d_login_2d_info)
   ___IF(___NOT(___FALSEP(___R3)))
   ___GOTO(___L2_repo_23_set_2d_login_2d_info)
   ___END_IF
   ___SET_R2(___SUB(3))
___DEF_GLBL(___L2_repo_23_set_2d_login_2d_info)
   ___BEGIN_ALLOC_LIST(3,___R3)
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___R1)
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___SET_GLO(2,___G_repo_23_login_2d_info,___R1)
   ___SET_R1(___VOID)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_repo_23_set_2d_login_2d_info)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_repo_23_get_2d_login_2d_info
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
___DEF_P_HLBL(___L0_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L1_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L2_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L3_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L4_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L5_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L6_repo_23_get_2d_login_2d_info)
___DEF_P_HLBL(___L7_repo_23_get_2d_login_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_repo_23_get_2d_login_2d_info)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_repo_23_get_2d_login_2d_info)
   ___IF(___NOT(___FALSEP(___GLO_repo_23_login_2d_info)))
   ___GOTO(___L10_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R1(___SUB(6))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_repo_23_get_2d_login_2d_info)
   ___JUMPGLOSAFE(___SET_NARGS(1),12,___G_intf_23_get_2d_pref)
___DEF_SLBL(2,___L2_repo_23_get_2d_login_2d_info)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L8_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___GOTO(___L12_repo_23_get_2d_login_2d_info)
___DEF_SLBL(3,___L3_repo_23_get_2d_login_2d_info)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L11_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___ADJFP(-4)
___DEF_GLBL(___L8_repo_23_get_2d_login_2d_info)
   ___SET_R1(___CNS(0))
___DEF_GLBL(___L9_repo_23_get_2d_login_2d_info)
   ___SET_GLO(2,___G_repo_23_login_2d_info,___R1)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L10_repo_23_get_2d_login_2d_info)
   ___SET_R1(___GLO_repo_23_login_2d_info)
   ___POLL(4)
___DEF_SLBL(4,___L4_repo_23_get_2d_login_2d_info)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L11_repo_23_get_2d_login_2d_info)
   ___SET_R1(___STK(-6))
   ___ADJFP(-4)
   ___GOTO(___L9_repo_23_get_2d_login_2d_info)
___DEF_GLBL(___L12_repo_23_get_2d_login_2d_info)
   ___SET_R2(___PRM_read)
   ___SET_R0(___LBL(5))
   ___JUMPGLOSAFE(___SET_NARGS(2),15,___G_with_2d_input_2d_from_2d_string)
___DEF_SLBL(5,___L5_repo_23_get_2d_login_2d_info)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L8_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L16_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___SET_R2(___CAR(___R1))
   ___IF(___PAIRP(___R1))
   ___GOTO(___L13_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___GOTO(___L15_repo_23_get_2d_login_2d_info)
___DEF_SLBL(6,___L6_repo_23_get_2d_login_2d_info)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___ADJFP(-4)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L15_repo_23_get_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L13_repo_23_get_2d_login_2d_info)
   ___SET_R1(___CDR(___R1))
   ___IF(___EQP(___R2,___SUB(2)))
   ___GOTO(___L9_repo_23_get_2d_login_2d_info)
   ___END_IF
___DEF_GLBL(___L14_repo_23_get_2d_login_2d_info)
   ___IF(___NOT(___MEMALLOCATEDP(___R2)))
   ___GOTO(___L8_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___SET_R3(___SUBTYPE(___R2))
   ___IF(___NOT(___FIXEQ(___R3,___FIX(19L))))
   ___GOTO(___L8_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___SET_STK(-2,___R1)
   ___SET_R1(___R2)
   ___SET_R2(___SUB(2))
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(2),___PRM_equal_3f_)
___DEF_GLBL(___L15_repo_23_get_2d_login_2d_info)
   ___SET_STK(-2,___R2)
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_cdr)
___DEF_SLBL(7,___L7_repo_23_get_2d_login_2d_info)
   ___SET_R2(___STK(-6))
   ___ADJFP(-4)
   ___IF(___EQP(___R2,___SUB(2)))
   ___GOTO(___L9_repo_23_get_2d_login_2d_info)
   ___END_IF
   ___GOTO(___L14_repo_23_get_2d_login_2d_info)
___DEF_GLBL(___L16_repo_23_get_2d_login_2d_info)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(6))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_car)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_repo_23_save_2d_login_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 22
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_repo_23_save_2d_login_2d_info)
___DEF_P_HLBL(___L1_repo_23_save_2d_login_2d_info)
___DEF_P_HLBL(___L2_repo_23_save_2d_login_2d_info)
___DEF_P_HLBL(___L3_repo_23_save_2d_login_2d_info)
___DEF_P_HLBL(___L4_repo_23_save_2d_login_2d_info)
___DEF_P_HLBL(___L5_repo_23_save_2d_login_2d_info)
___DEF_P_HLBL(___L6_repo_23_save_2d_login_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_repo_23_save_2d_login_2d_info)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_repo_23_save_2d_login_2d_info)
   ___IF(___FALSEP(___GLO_repo_23_login_2d_info))
   ___GOTO(___L7_repo_23_save_2d_login_2d_info)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R2(___LBL(4))
   ___SET_R1(___SUB(7))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_repo_23_save_2d_login_2d_info)
   ___JUMPGLOSAFE(___SET_NARGS(2),16,___G_with_2d_output_2d_to_2d_string)
___DEF_SLBL(2,___L2_repo_23_save_2d_login_2d_info)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(8))
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_repo_23_save_2d_login_2d_info)
   ___ADJFP(-4)
   ___JUMPGLOSAFE(___SET_NARGS(2),13,___G_intf_23_set_2d_pref)
___DEF_SLBL(4,___L4_repo_23_save_2d_login_2d_info)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(4,0,0,0)
   ___SET_R1(___CONS(___SUB(2),___GLO_repo_23_login_2d_info))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_repo_23_save_2d_login_2d_info)
   ___POLL(6)
___DEF_SLBL(6,___L6_repo_23_save_2d_login_2d_info)
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_GLBL(___L7_repo_23_save_2d_login_2d_info)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20_repo," repo",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20_repo,0,-1)
,___DEF_LBL_INTRO(___H_repo_23_reset_2d_login_2d_info,"repo#reset-login-info",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_repo_23_reset_2d_login_2d_info,0,-1)
,___DEF_LBL_RET(___H_repo_23_reset_2d_login_2d_info,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_repo_23_reset_2d_login_2d_info,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_repo_23_reset_2d_login_2d_info,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_repo_23_reset_2d_login_2d_info,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_repo_23_reset_2d_login_2d_info,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_repo_23_set_2d_login_2d_info,"repo#set-login-info",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_repo_23_set_2d_login_2d_info,3,-1)
,___DEF_LBL_RET(___H_repo_23_set_2d_login_2d_info,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_repo_23_get_2d_login_2d_info,"repo#get-login-info",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_repo_23_get_2d_login_2d_info,0,-1)
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_repo_23_get_2d_login_2d_info,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_repo_23_save_2d_login_2d_info,"repo#save-login-info",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_repo_23_save_2d_login_2d_info,0,-1)
,___DEF_LBL_RET(___H_repo_23_save_2d_login_2d_info,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_repo_23_save_2d_login_2d_info,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_repo_23_save_2d_login_2d_info,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_PROC(___H_repo_23_save_2d_login_2d_info,0,-1)
,___DEF_LBL_RET(___H_repo_23_save_2d_login_2d_info,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_repo_23_save_2d_login_2d_info,___IFD(___RETI,0,0,0x3fL))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20_repo,1)
___DEF_MOD_PRM(5,___G_repo_23_reset_2d_login_2d_info,3)
___DEF_MOD_PRM(7,___G_repo_23_set_2d_login_2d_info,10)
___DEF_MOD_PRM(1,___G_repo_23_get_2d_login_2d_info,13)
___DEF_MOD_PRM(6,___G_repo_23_save_2d_login_2d_info,22)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20_repo,1)
___DEF_MOD_GLO(5,___G_repo_23_reset_2d_login_2d_info,3)
___DEF_MOD_GLO(7,___G_repo_23_set_2d_login_2d_info,10)
___DEF_MOD_GLO(1,___G_repo_23_get_2d_login_2d_info,13)
___DEF_MOD_GLO(6,___G_repo_23_save_2d_login_2d_info,22)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S_repo,"repo")
___END_MOD_SYM_KEY

#endif
