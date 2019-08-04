#ifdef ___LINKER_INFO
; File: "_riscv.c", produced by Gambit v4.9.3
(
409003
(C)
"_riscv"
("_riscv")
()
(("_riscv"))
(
"B"
"I"
"J"
"RV64I"
"S"
"U"
"_riscv"
)
(
)
(
"_riscv#"
"_riscv#riscv-64bit-mode?"
"_riscv#riscv-addi"
"_riscv#riscv-addiw"
"_riscv#riscv-auipc"
"_riscv#riscv-data-elems"
"_riscv#riscv-imm->instr"
"_riscv#riscv-imm-int"
"_riscv#riscv-imm-int?"
"_riscv#riscv-imm-lbl?"
"_riscv#riscv-jal"
"_riscv#riscv-jalr"
"_riscv#riscv-listing"
"_riscv#riscv-lui"
"_riscv#riscv-slli"
"_riscv#riscv-sub"
"_riscv#riscv-subw"
"_riscv#riscv-type-b"
"_riscv#riscv-type-i"
"_riscv#riscv-type-j"
"_riscv#riscv-type-r"
"_riscv#riscv-type-s"
"_riscv#riscv-type-u"
"_riscv#riscv-word-width"
)
(
"_riscv#riscv-add"
"_riscv#riscv-addw"
"_riscv#riscv-and"
"_riscv#riscv-andi"
"_riscv#riscv-arch-set!"
"_riscv#riscv-beq"
"_riscv#riscv-beqz"
"_riscv#riscv-bge"
"_riscv#riscv-bgeu"
"_riscv#riscv-bgez"
"_riscv#riscv-bgt"
"_riscv#riscv-bgtu"
"_riscv#riscv-bgtz"
"_riscv#riscv-ble"
"_riscv#riscv-bleu"
"_riscv#riscv-blez"
"_riscv#riscv-blt"
"_riscv#riscv-bltu"
"_riscv#riscv-bltz"
"_riscv#riscv-bne"
"_riscv#riscv-bnez"
"_riscv#riscv-call"
"_riscv#riscv-d2b"
"_riscv#riscv-d4b"
"_riscv#riscv-d8b"
"_riscv#riscv-db"
"_riscv#riscv-dd"
"_riscv#riscv-dh"
"_riscv#riscv-dl"
"_riscv#riscv-dq"
"_riscv#riscv-ds"
"_riscv#riscv-dw"
"_riscv#riscv-ebreak"
"_riscv#riscv-ecall"
"_riscv#riscv-fence"
"_riscv#riscv-fence.i"
"_riscv#riscv-imm-int-type"
"_riscv#riscv-imm-int-value"
"_riscv#riscv-imm-lbl"
"_riscv#riscv-imm-lbl-label"
"_riscv#riscv-imm-lbl-offset"
"_riscv#riscv-imm?"
"_riscv#riscv-j"
"_riscv#riscv-jal*"
"_riscv#riscv-jalr*"
"_riscv#riscv-jr"
"_riscv#riscv-label"
"_riscv#riscv-lb"
"_riscv#riscv-lbu"
"_riscv#riscv-ld"
"_riscv#riscv-lh"
"_riscv#riscv-lhu"
"_riscv#riscv-li"
"_riscv#riscv-lw"
"_riscv#riscv-lwu"
"_riscv#riscv-mv"
"_riscv#riscv-neg"
"_riscv#riscv-negw"
"_riscv#riscv-nop"
"_riscv#riscv-not"
"_riscv#riscv-or"
"_riscv#riscv-ori"
"_riscv#riscv-register-name"
"_riscv#riscv-ret"
"_riscv#riscv-sb"
"_riscv#riscv-sd"
"_riscv#riscv-seqz"
"_riscv#riscv-sext.w"
"_riscv#riscv-sgtz"
"_riscv#riscv-sh"
"_riscv#riscv-sll"
"_riscv#riscv-slliw"
"_riscv#riscv-sllw"
"_riscv#riscv-slt"
"_riscv#riscv-slti"
"_riscv#riscv-sltiu"
"_riscv#riscv-sltu"
"_riscv#riscv-sltz"
"_riscv#riscv-snez"
"_riscv#riscv-sra"
"_riscv#riscv-srai"
"_riscv#riscv-sraiw"
"_riscv#riscv-sraw"
"_riscv#riscv-srl"
"_riscv#riscv-srli"
"_riscv#riscv-srliw"
"_riscv#riscv-srlw"
"_riscv#riscv-sw"
"_riscv#riscv-tail"
"_riscv#riscv-xor"
"_riscv#riscv-xori"
)
(
"+"
"-"
"<="
">="
"_asm#asm-32-le"
"_asm#asm-at-assembly"
"_asm#asm-int-le"
"_asm#asm-label"
"_asm#asm-label-name"
"_asm#asm-label-pos"
"_asm#asm-listing"
"_asm#asm-separated-list"
"_asm#asm-signed-lo64"
"_asm#asm-unsigned-lo64"
"_codegen#codegen-context-arch"
"_codegen#codegen-context-arch-set!"
"_codegen#codegen-context-listing-format"
"arithmetic-shift"
"bitwise-and"
"car"
"cdr"
"cons"
"eq?"
"error"
"first-bit-set"
"fixnum?"
"fx+"
"fx-"
"fx<"
"fx<="
"fx="
"fx>"
"fx>="
"fxand"
"fxarithmetic-shift"
"fxbit-set?"
"fxeven?"
"fxmin"
"fxzero?"
"list"
"list->vector"
"map"
"not"
"number->string"
"number?"
"pair?"
"reverse"
"string-append"
"symbol?"
"vector"
"vector-length"
"vector-ref"
"vector?"
"zero?"
)
()
)
#else
#define ___VERSION 409003
#define ___MODULE_NAME "_riscv"
#define ___LINKER_ID ___LNK___riscv
#define ___MH_PROC ___H___riscv
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 7
#define ___GLOCOUNT 169
#define ___SUPCOUNT 115
#define ___SUBCOUNT 150
#define ___LBLCOUNT 857
#define ___OFDCOUNT 21
#define ___MODDESCR ___REF_SUB(147)
#include "gambit.h"

___NEED_SYM(___S_B)
___NEED_SYM(___S_I)
___NEED_SYM(___S_J)
___NEED_SYM(___S_RV64I)
___NEED_SYM(___S_S)
___NEED_SYM(___S_U)
___NEED_SYM(___S___riscv)

___NEED_GLO(___G__2b_)
___NEED_GLO(___G__2d_)
___NEED_GLO(___G__3c__3d_)
___NEED_GLO(___G__3e__3d_)
___NEED_GLO(___G___asm_23_asm_2d_32_2d_le)
___NEED_GLO(___G___asm_23_asm_2d_at_2d_assembly)
___NEED_GLO(___G___asm_23_asm_2d_int_2d_le)
___NEED_GLO(___G___asm_23_asm_2d_label)
___NEED_GLO(___G___asm_23_asm_2d_label_2d_name)
___NEED_GLO(___G___asm_23_asm_2d_label_2d_pos)
___NEED_GLO(___G___asm_23_asm_2d_listing)
___NEED_GLO(___G___asm_23_asm_2d_separated_2d_list)
___NEED_GLO(___G___asm_23_asm_2d_signed_2d_lo64)
___NEED_GLO(___G___asm_23_asm_2d_unsigned_2d_lo64)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_arch)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___NEED_GLO(___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___NEED_GLO(___G___riscv_23_)
___NEED_GLO(___G___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___NEED_GLO(___G___riscv_23_riscv_2d_add)
___NEED_GLO(___G___riscv_23_riscv_2d_addi)
___NEED_GLO(___G___riscv_23_riscv_2d_addiw)
___NEED_GLO(___G___riscv_23_riscv_2d_addw)
___NEED_GLO(___G___riscv_23_riscv_2d_and)
___NEED_GLO(___G___riscv_23_riscv_2d_andi)
___NEED_GLO(___G___riscv_23_riscv_2d_arch_2d_set_21_)
___NEED_GLO(___G___riscv_23_riscv_2d_auipc)
___NEED_GLO(___G___riscv_23_riscv_2d_beq)
___NEED_GLO(___G___riscv_23_riscv_2d_beqz)
___NEED_GLO(___G___riscv_23_riscv_2d_bge)
___NEED_GLO(___G___riscv_23_riscv_2d_bgeu)
___NEED_GLO(___G___riscv_23_riscv_2d_bgez)
___NEED_GLO(___G___riscv_23_riscv_2d_bgt)
___NEED_GLO(___G___riscv_23_riscv_2d_bgtu)
___NEED_GLO(___G___riscv_23_riscv_2d_bgtz)
___NEED_GLO(___G___riscv_23_riscv_2d_ble)
___NEED_GLO(___G___riscv_23_riscv_2d_bleu)
___NEED_GLO(___G___riscv_23_riscv_2d_blez)
___NEED_GLO(___G___riscv_23_riscv_2d_blt)
___NEED_GLO(___G___riscv_23_riscv_2d_bltu)
___NEED_GLO(___G___riscv_23_riscv_2d_bltz)
___NEED_GLO(___G___riscv_23_riscv_2d_bne)
___NEED_GLO(___G___riscv_23_riscv_2d_bnez)
___NEED_GLO(___G___riscv_23_riscv_2d_call)
___NEED_GLO(___G___riscv_23_riscv_2d_d2b)
___NEED_GLO(___G___riscv_23_riscv_2d_d4b)
___NEED_GLO(___G___riscv_23_riscv_2d_d8b)
___NEED_GLO(___G___riscv_23_riscv_2d_data_2d_elems)
___NEED_GLO(___G___riscv_23_riscv_2d_db)
___NEED_GLO(___G___riscv_23_riscv_2d_dd)
___NEED_GLO(___G___riscv_23_riscv_2d_dh)
___NEED_GLO(___G___riscv_23_riscv_2d_dl)
___NEED_GLO(___G___riscv_23_riscv_2d_dq)
___NEED_GLO(___G___riscv_23_riscv_2d_ds)
___NEED_GLO(___G___riscv_23_riscv_2d_dw)
___NEED_GLO(___G___riscv_23_riscv_2d_ebreak)
___NEED_GLO(___G___riscv_23_riscv_2d_ecall)
___NEED_GLO(___G___riscv_23_riscv_2d_fence)
___NEED_GLO(___G___riscv_23_riscv_2d_fence_2e_i)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d__3e_instr)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_int)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_int_2d_type)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_int_2d_value)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_int_3f_)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_lbl)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___NEED_GLO(___G___riscv_23_riscv_2d_imm_3f_)
___NEED_GLO(___G___riscv_23_riscv_2d_j)
___NEED_GLO(___G___riscv_23_riscv_2d_jal)
___NEED_GLO(___G___riscv_23_riscv_2d_jal_2a_)
___NEED_GLO(___G___riscv_23_riscv_2d_jalr)
___NEED_GLO(___G___riscv_23_riscv_2d_jalr_2a_)
___NEED_GLO(___G___riscv_23_riscv_2d_jr)
___NEED_GLO(___G___riscv_23_riscv_2d_label)
___NEED_GLO(___G___riscv_23_riscv_2d_lb)
___NEED_GLO(___G___riscv_23_riscv_2d_lbu)
___NEED_GLO(___G___riscv_23_riscv_2d_ld)
___NEED_GLO(___G___riscv_23_riscv_2d_lh)
___NEED_GLO(___G___riscv_23_riscv_2d_lhu)
___NEED_GLO(___G___riscv_23_riscv_2d_li)
___NEED_GLO(___G___riscv_23_riscv_2d_listing)
___NEED_GLO(___G___riscv_23_riscv_2d_lui)
___NEED_GLO(___G___riscv_23_riscv_2d_lw)
___NEED_GLO(___G___riscv_23_riscv_2d_lwu)
___NEED_GLO(___G___riscv_23_riscv_2d_mv)
___NEED_GLO(___G___riscv_23_riscv_2d_neg)
___NEED_GLO(___G___riscv_23_riscv_2d_negw)
___NEED_GLO(___G___riscv_23_riscv_2d_nop)
___NEED_GLO(___G___riscv_23_riscv_2d_not)
___NEED_GLO(___G___riscv_23_riscv_2d_or)
___NEED_GLO(___G___riscv_23_riscv_2d_ori)
___NEED_GLO(___G___riscv_23_riscv_2d_register_2d_name)
___NEED_GLO(___G___riscv_23_riscv_2d_ret)
___NEED_GLO(___G___riscv_23_riscv_2d_sb)
___NEED_GLO(___G___riscv_23_riscv_2d_sd)
___NEED_GLO(___G___riscv_23_riscv_2d_seqz)
___NEED_GLO(___G___riscv_23_riscv_2d_sext_2e_w)
___NEED_GLO(___G___riscv_23_riscv_2d_sgtz)
___NEED_GLO(___G___riscv_23_riscv_2d_sh)
___NEED_GLO(___G___riscv_23_riscv_2d_sll)
___NEED_GLO(___G___riscv_23_riscv_2d_slli)
___NEED_GLO(___G___riscv_23_riscv_2d_slliw)
___NEED_GLO(___G___riscv_23_riscv_2d_sllw)
___NEED_GLO(___G___riscv_23_riscv_2d_slt)
___NEED_GLO(___G___riscv_23_riscv_2d_slti)
___NEED_GLO(___G___riscv_23_riscv_2d_sltiu)
___NEED_GLO(___G___riscv_23_riscv_2d_sltu)
___NEED_GLO(___G___riscv_23_riscv_2d_sltz)
___NEED_GLO(___G___riscv_23_riscv_2d_snez)
___NEED_GLO(___G___riscv_23_riscv_2d_sra)
___NEED_GLO(___G___riscv_23_riscv_2d_srai)
___NEED_GLO(___G___riscv_23_riscv_2d_sraiw)
___NEED_GLO(___G___riscv_23_riscv_2d_sraw)
___NEED_GLO(___G___riscv_23_riscv_2d_srl)
___NEED_GLO(___G___riscv_23_riscv_2d_srli)
___NEED_GLO(___G___riscv_23_riscv_2d_srliw)
___NEED_GLO(___G___riscv_23_riscv_2d_srlw)
___NEED_GLO(___G___riscv_23_riscv_2d_sub)
___NEED_GLO(___G___riscv_23_riscv_2d_subw)
___NEED_GLO(___G___riscv_23_riscv_2d_sw)
___NEED_GLO(___G___riscv_23_riscv_2d_tail)
___NEED_GLO(___G___riscv_23_riscv_2d_type_2d_b)
___NEED_GLO(___G___riscv_23_riscv_2d_type_2d_i)
___NEED_GLO(___G___riscv_23_riscv_2d_type_2d_j)
___NEED_GLO(___G___riscv_23_riscv_2d_type_2d_r)
___NEED_GLO(___G___riscv_23_riscv_2d_type_2d_s)
___NEED_GLO(___G___riscv_23_riscv_2d_type_2d_u)
___NEED_GLO(___G___riscv_23_riscv_2d_word_2d_width)
___NEED_GLO(___G___riscv_23_riscv_2d_xor)
___NEED_GLO(___G___riscv_23_riscv_2d_xori)
___NEED_GLO(___G_arithmetic_2d_shift)
___NEED_GLO(___G_bitwise_2d_and)
___NEED_GLO(___G_car)
___NEED_GLO(___G_cdr)
___NEED_GLO(___G_cons)
___NEED_GLO(___G_eq_3f_)
___NEED_GLO(___G_error)
___NEED_GLO(___G_first_2d_bit_2d_set)
___NEED_GLO(___G_fixnum_3f_)
___NEED_GLO(___G_fx_2b_)
___NEED_GLO(___G_fx_2d_)
___NEED_GLO(___G_fx_3c_)
___NEED_GLO(___G_fx_3c__3d_)
___NEED_GLO(___G_fx_3d_)
___NEED_GLO(___G_fx_3e_)
___NEED_GLO(___G_fx_3e__3d_)
___NEED_GLO(___G_fxand)
___NEED_GLO(___G_fxarithmetic_2d_shift)
___NEED_GLO(___G_fxbit_2d_set_3f_)
___NEED_GLO(___G_fxeven_3f_)
___NEED_GLO(___G_fxmin)
___NEED_GLO(___G_fxzero_3f_)
___NEED_GLO(___G_list)
___NEED_GLO(___G_list_2d__3e_vector)
___NEED_GLO(___G_map)
___NEED_GLO(___G_not)
___NEED_GLO(___G_number_2d__3e_string)
___NEED_GLO(___G_number_3f_)
___NEED_GLO(___G_pair_3f_)
___NEED_GLO(___G_reverse)
___NEED_GLO(___G_string_2d_append)
___NEED_GLO(___G_symbol_3f_)
___NEED_GLO(___G_vector)
___NEED_GLO(___G_vector_2d_length)
___NEED_GLO(___G_vector_2d_ref)
___NEED_GLO(___G_vector_3f_)
___NEED_GLO(___G_zero_3f_)

___BEGIN_SYM
___DEF_SYM(0,___S_B,"B")
___DEF_SYM(1,___S_I,"I")
___DEF_SYM(2,___S_J,"J")
___DEF_SYM(3,___S_RV64I,"RV64I")
___DEF_SYM(4,___S_S,"S")
___DEF_SYM(5,___S_U,"U")
___DEF_SYM(6,___S___riscv,"_riscv")
___END_SYM

#define ___SYM_B ___SYM(0,___S_B)
#define ___SYM_I ___SYM(1,___S_I)
#define ___SYM_J ___SYM(2,___S_J)
#define ___SYM_RV64I ___SYM(3,___S_RV64I)
#define ___SYM_S ___SYM(4,___S_S)
#define ___SYM_U ___SYM(5,___S_U)
#define ___SYM___riscv ___SYM(6,___S___riscv)

___BEGIN_GLO
___DEF_GLO(0,"_riscv#")
___DEF_GLO(1,"_riscv#riscv-64bit-mode?")
___DEF_GLO(2,"_riscv#riscv-add")
___DEF_GLO(3,"_riscv#riscv-addi")
___DEF_GLO(4,"_riscv#riscv-addiw")
___DEF_GLO(5,"_riscv#riscv-addw")
___DEF_GLO(6,"_riscv#riscv-and")
___DEF_GLO(7,"_riscv#riscv-andi")
___DEF_GLO(8,"_riscv#riscv-arch-set!")
___DEF_GLO(9,"_riscv#riscv-auipc")
___DEF_GLO(10,"_riscv#riscv-beq")
___DEF_GLO(11,"_riscv#riscv-beqz")
___DEF_GLO(12,"_riscv#riscv-bge")
___DEF_GLO(13,"_riscv#riscv-bgeu")
___DEF_GLO(14,"_riscv#riscv-bgez")
___DEF_GLO(15,"_riscv#riscv-bgt")
___DEF_GLO(16,"_riscv#riscv-bgtu")
___DEF_GLO(17,"_riscv#riscv-bgtz")
___DEF_GLO(18,"_riscv#riscv-ble")
___DEF_GLO(19,"_riscv#riscv-bleu")
___DEF_GLO(20,"_riscv#riscv-blez")
___DEF_GLO(21,"_riscv#riscv-blt")
___DEF_GLO(22,"_riscv#riscv-bltu")
___DEF_GLO(23,"_riscv#riscv-bltz")
___DEF_GLO(24,"_riscv#riscv-bne")
___DEF_GLO(25,"_riscv#riscv-bnez")
___DEF_GLO(26,"_riscv#riscv-call")
___DEF_GLO(27,"_riscv#riscv-d2b")
___DEF_GLO(28,"_riscv#riscv-d4b")
___DEF_GLO(29,"_riscv#riscv-d8b")
___DEF_GLO(30,"_riscv#riscv-data-elems")
___DEF_GLO(31,"_riscv#riscv-db")
___DEF_GLO(32,"_riscv#riscv-dd")
___DEF_GLO(33,"_riscv#riscv-dh")
___DEF_GLO(34,"_riscv#riscv-dl")
___DEF_GLO(35,"_riscv#riscv-dq")
___DEF_GLO(36,"_riscv#riscv-ds")
___DEF_GLO(37,"_riscv#riscv-dw")
___DEF_GLO(38,"_riscv#riscv-ebreak")
___DEF_GLO(39,"_riscv#riscv-ecall")
___DEF_GLO(40,"_riscv#riscv-fence")
___DEF_GLO(41,"_riscv#riscv-fence.i")
___DEF_GLO(42,"_riscv#riscv-imm->instr")
___DEF_GLO(43,"_riscv#riscv-imm-int")
___DEF_GLO(44,"_riscv#riscv-imm-int-type")
___DEF_GLO(45,"_riscv#riscv-imm-int-value")
___DEF_GLO(46,"_riscv#riscv-imm-int?")
___DEF_GLO(47,"_riscv#riscv-imm-lbl")
___DEF_GLO(48,"_riscv#riscv-imm-lbl-label")
___DEF_GLO(49,"_riscv#riscv-imm-lbl-offset")
___DEF_GLO(50,"_riscv#riscv-imm-lbl?")
___DEF_GLO(51,"_riscv#riscv-imm?")
___DEF_GLO(52,"_riscv#riscv-j")
___DEF_GLO(53,"_riscv#riscv-jal")
___DEF_GLO(54,"_riscv#riscv-jal*")
___DEF_GLO(55,"_riscv#riscv-jalr")
___DEF_GLO(56,"_riscv#riscv-jalr*")
___DEF_GLO(57,"_riscv#riscv-jr")
___DEF_GLO(58,"_riscv#riscv-label")
___DEF_GLO(59,"_riscv#riscv-lb")
___DEF_GLO(60,"_riscv#riscv-lbu")
___DEF_GLO(61,"_riscv#riscv-ld")
___DEF_GLO(62,"_riscv#riscv-lh")
___DEF_GLO(63,"_riscv#riscv-lhu")
___DEF_GLO(64,"_riscv#riscv-li")
___DEF_GLO(65,"_riscv#riscv-listing")
___DEF_GLO(66,"_riscv#riscv-lui")
___DEF_GLO(67,"_riscv#riscv-lw")
___DEF_GLO(68,"_riscv#riscv-lwu")
___DEF_GLO(69,"_riscv#riscv-mv")
___DEF_GLO(70,"_riscv#riscv-neg")
___DEF_GLO(71,"_riscv#riscv-negw")
___DEF_GLO(72,"_riscv#riscv-nop")
___DEF_GLO(73,"_riscv#riscv-not")
___DEF_GLO(74,"_riscv#riscv-or")
___DEF_GLO(75,"_riscv#riscv-ori")
___DEF_GLO(76,"_riscv#riscv-register-name")
___DEF_GLO(77,"_riscv#riscv-ret")
___DEF_GLO(78,"_riscv#riscv-sb")
___DEF_GLO(79,"_riscv#riscv-sd")
___DEF_GLO(80,"_riscv#riscv-seqz")
___DEF_GLO(81,"_riscv#riscv-sext.w")
___DEF_GLO(82,"_riscv#riscv-sgtz")
___DEF_GLO(83,"_riscv#riscv-sh")
___DEF_GLO(84,"_riscv#riscv-sll")
___DEF_GLO(85,"_riscv#riscv-slli")
___DEF_GLO(86,"_riscv#riscv-slliw")
___DEF_GLO(87,"_riscv#riscv-sllw")
___DEF_GLO(88,"_riscv#riscv-slt")
___DEF_GLO(89,"_riscv#riscv-slti")
___DEF_GLO(90,"_riscv#riscv-sltiu")
___DEF_GLO(91,"_riscv#riscv-sltu")
___DEF_GLO(92,"_riscv#riscv-sltz")
___DEF_GLO(93,"_riscv#riscv-snez")
___DEF_GLO(94,"_riscv#riscv-sra")
___DEF_GLO(95,"_riscv#riscv-srai")
___DEF_GLO(96,"_riscv#riscv-sraiw")
___DEF_GLO(97,"_riscv#riscv-sraw")
___DEF_GLO(98,"_riscv#riscv-srl")
___DEF_GLO(99,"_riscv#riscv-srli")
___DEF_GLO(100,"_riscv#riscv-srliw")
___DEF_GLO(101,"_riscv#riscv-srlw")
___DEF_GLO(102,"_riscv#riscv-sub")
___DEF_GLO(103,"_riscv#riscv-subw")
___DEF_GLO(104,"_riscv#riscv-sw")
___DEF_GLO(105,"_riscv#riscv-tail")
___DEF_GLO(106,"_riscv#riscv-type-b")
___DEF_GLO(107,"_riscv#riscv-type-i")
___DEF_GLO(108,"_riscv#riscv-type-j")
___DEF_GLO(109,"_riscv#riscv-type-r")
___DEF_GLO(110,"_riscv#riscv-type-s")
___DEF_GLO(111,"_riscv#riscv-type-u")
___DEF_GLO(112,"_riscv#riscv-word-width")
___DEF_GLO(113,"_riscv#riscv-xor")
___DEF_GLO(114,"_riscv#riscv-xori")
___DEF_GLO(115,"+")
___DEF_GLO(116,"-")
___DEF_GLO(117,"<=")
___DEF_GLO(118,">=")
___DEF_GLO(119,"_asm#asm-32-le")
___DEF_GLO(120,"_asm#asm-at-assembly")
___DEF_GLO(121,"_asm#asm-int-le")
___DEF_GLO(122,"_asm#asm-label")
___DEF_GLO(123,"_asm#asm-label-name")
___DEF_GLO(124,"_asm#asm-label-pos")
___DEF_GLO(125,"_asm#asm-listing")
___DEF_GLO(126,"_asm#asm-separated-list")
___DEF_GLO(127,"_asm#asm-signed-lo64")
___DEF_GLO(128,"_asm#asm-unsigned-lo64")
___DEF_GLO(129,"_codegen#codegen-context-arch")
___DEF_GLO(130,"_codegen#codegen-context-arch-set!")

___DEF_GLO(131,"_codegen#codegen-context-listing-format")

___DEF_GLO(132,"arithmetic-shift")
___DEF_GLO(133,"bitwise-and")
___DEF_GLO(134,"car")
___DEF_GLO(135,"cdr")
___DEF_GLO(136,"cons")
___DEF_GLO(137,"eq?")
___DEF_GLO(138,"error")
___DEF_GLO(139,"first-bit-set")
___DEF_GLO(140,"fixnum?")
___DEF_GLO(141,"fx+")
___DEF_GLO(142,"fx-")
___DEF_GLO(143,"fx<")
___DEF_GLO(144,"fx<=")
___DEF_GLO(145,"fx=")
___DEF_GLO(146,"fx>")
___DEF_GLO(147,"fx>=")
___DEF_GLO(148,"fxand")
___DEF_GLO(149,"fxarithmetic-shift")
___DEF_GLO(150,"fxbit-set?")
___DEF_GLO(151,"fxeven?")
___DEF_GLO(152,"fxmin")
___DEF_GLO(153,"fxzero?")
___DEF_GLO(154,"list")
___DEF_GLO(155,"list->vector")
___DEF_GLO(156,"map")
___DEF_GLO(157,"not")
___DEF_GLO(158,"number->string")
___DEF_GLO(159,"number?")
___DEF_GLO(160,"pair?")
___DEF_GLO(161,"reverse")
___DEF_GLO(162,"string-append")
___DEF_GLO(163,"symbol?")
___DEF_GLO(164,"vector")
___DEF_GLO(165,"vector-length")
___DEF_GLO(166,"vector-ref")
___DEF_GLO(167,"vector?")
___DEF_GLO(168,"zero?")
___END_GLO

#define ___GLO___riscv_23_ ___GLO(0,___G___riscv_23_)
#define ___PRM___riscv_23_ ___PRM(0,___G___riscv_23_)
#define ___GLO___riscv_23_riscv_2d_64bit_2d_mode_3f_ ___GLO(1,___G___riscv_23_riscv_2d_64bit_2d_mode_3f_)
#define ___PRM___riscv_23_riscv_2d_64bit_2d_mode_3f_ ___PRM(1,___G___riscv_23_riscv_2d_64bit_2d_mode_3f_)
#define ___GLO___riscv_23_riscv_2d_add ___GLO(2,___G___riscv_23_riscv_2d_add)
#define ___PRM___riscv_23_riscv_2d_add ___PRM(2,___G___riscv_23_riscv_2d_add)
#define ___GLO___riscv_23_riscv_2d_addi ___GLO(3,___G___riscv_23_riscv_2d_addi)
#define ___PRM___riscv_23_riscv_2d_addi ___PRM(3,___G___riscv_23_riscv_2d_addi)
#define ___GLO___riscv_23_riscv_2d_addiw ___GLO(4,___G___riscv_23_riscv_2d_addiw)
#define ___PRM___riscv_23_riscv_2d_addiw ___PRM(4,___G___riscv_23_riscv_2d_addiw)
#define ___GLO___riscv_23_riscv_2d_addw ___GLO(5,___G___riscv_23_riscv_2d_addw)
#define ___PRM___riscv_23_riscv_2d_addw ___PRM(5,___G___riscv_23_riscv_2d_addw)
#define ___GLO___riscv_23_riscv_2d_and ___GLO(6,___G___riscv_23_riscv_2d_and)
#define ___PRM___riscv_23_riscv_2d_and ___PRM(6,___G___riscv_23_riscv_2d_and)
#define ___GLO___riscv_23_riscv_2d_andi ___GLO(7,___G___riscv_23_riscv_2d_andi)
#define ___PRM___riscv_23_riscv_2d_andi ___PRM(7,___G___riscv_23_riscv_2d_andi)
#define ___GLO___riscv_23_riscv_2d_arch_2d_set_21_ ___GLO(8,___G___riscv_23_riscv_2d_arch_2d_set_21_)
#define ___PRM___riscv_23_riscv_2d_arch_2d_set_21_ ___PRM(8,___G___riscv_23_riscv_2d_arch_2d_set_21_)
#define ___GLO___riscv_23_riscv_2d_auipc ___GLO(9,___G___riscv_23_riscv_2d_auipc)
#define ___PRM___riscv_23_riscv_2d_auipc ___PRM(9,___G___riscv_23_riscv_2d_auipc)
#define ___GLO___riscv_23_riscv_2d_beq ___GLO(10,___G___riscv_23_riscv_2d_beq)
#define ___PRM___riscv_23_riscv_2d_beq ___PRM(10,___G___riscv_23_riscv_2d_beq)
#define ___GLO___riscv_23_riscv_2d_beqz ___GLO(11,___G___riscv_23_riscv_2d_beqz)
#define ___PRM___riscv_23_riscv_2d_beqz ___PRM(11,___G___riscv_23_riscv_2d_beqz)
#define ___GLO___riscv_23_riscv_2d_bge ___GLO(12,___G___riscv_23_riscv_2d_bge)
#define ___PRM___riscv_23_riscv_2d_bge ___PRM(12,___G___riscv_23_riscv_2d_bge)
#define ___GLO___riscv_23_riscv_2d_bgeu ___GLO(13,___G___riscv_23_riscv_2d_bgeu)
#define ___PRM___riscv_23_riscv_2d_bgeu ___PRM(13,___G___riscv_23_riscv_2d_bgeu)
#define ___GLO___riscv_23_riscv_2d_bgez ___GLO(14,___G___riscv_23_riscv_2d_bgez)
#define ___PRM___riscv_23_riscv_2d_bgez ___PRM(14,___G___riscv_23_riscv_2d_bgez)
#define ___GLO___riscv_23_riscv_2d_bgt ___GLO(15,___G___riscv_23_riscv_2d_bgt)
#define ___PRM___riscv_23_riscv_2d_bgt ___PRM(15,___G___riscv_23_riscv_2d_bgt)
#define ___GLO___riscv_23_riscv_2d_bgtu ___GLO(16,___G___riscv_23_riscv_2d_bgtu)
#define ___PRM___riscv_23_riscv_2d_bgtu ___PRM(16,___G___riscv_23_riscv_2d_bgtu)
#define ___GLO___riscv_23_riscv_2d_bgtz ___GLO(17,___G___riscv_23_riscv_2d_bgtz)
#define ___PRM___riscv_23_riscv_2d_bgtz ___PRM(17,___G___riscv_23_riscv_2d_bgtz)
#define ___GLO___riscv_23_riscv_2d_ble ___GLO(18,___G___riscv_23_riscv_2d_ble)
#define ___PRM___riscv_23_riscv_2d_ble ___PRM(18,___G___riscv_23_riscv_2d_ble)
#define ___GLO___riscv_23_riscv_2d_bleu ___GLO(19,___G___riscv_23_riscv_2d_bleu)
#define ___PRM___riscv_23_riscv_2d_bleu ___PRM(19,___G___riscv_23_riscv_2d_bleu)
#define ___GLO___riscv_23_riscv_2d_blez ___GLO(20,___G___riscv_23_riscv_2d_blez)
#define ___PRM___riscv_23_riscv_2d_blez ___PRM(20,___G___riscv_23_riscv_2d_blez)
#define ___GLO___riscv_23_riscv_2d_blt ___GLO(21,___G___riscv_23_riscv_2d_blt)
#define ___PRM___riscv_23_riscv_2d_blt ___PRM(21,___G___riscv_23_riscv_2d_blt)
#define ___GLO___riscv_23_riscv_2d_bltu ___GLO(22,___G___riscv_23_riscv_2d_bltu)
#define ___PRM___riscv_23_riscv_2d_bltu ___PRM(22,___G___riscv_23_riscv_2d_bltu)
#define ___GLO___riscv_23_riscv_2d_bltz ___GLO(23,___G___riscv_23_riscv_2d_bltz)
#define ___PRM___riscv_23_riscv_2d_bltz ___PRM(23,___G___riscv_23_riscv_2d_bltz)
#define ___GLO___riscv_23_riscv_2d_bne ___GLO(24,___G___riscv_23_riscv_2d_bne)
#define ___PRM___riscv_23_riscv_2d_bne ___PRM(24,___G___riscv_23_riscv_2d_bne)
#define ___GLO___riscv_23_riscv_2d_bnez ___GLO(25,___G___riscv_23_riscv_2d_bnez)
#define ___PRM___riscv_23_riscv_2d_bnez ___PRM(25,___G___riscv_23_riscv_2d_bnez)
#define ___GLO___riscv_23_riscv_2d_call ___GLO(26,___G___riscv_23_riscv_2d_call)
#define ___PRM___riscv_23_riscv_2d_call ___PRM(26,___G___riscv_23_riscv_2d_call)
#define ___GLO___riscv_23_riscv_2d_d2b ___GLO(27,___G___riscv_23_riscv_2d_d2b)
#define ___PRM___riscv_23_riscv_2d_d2b ___PRM(27,___G___riscv_23_riscv_2d_d2b)
#define ___GLO___riscv_23_riscv_2d_d4b ___GLO(28,___G___riscv_23_riscv_2d_d4b)
#define ___PRM___riscv_23_riscv_2d_d4b ___PRM(28,___G___riscv_23_riscv_2d_d4b)
#define ___GLO___riscv_23_riscv_2d_d8b ___GLO(29,___G___riscv_23_riscv_2d_d8b)
#define ___PRM___riscv_23_riscv_2d_d8b ___PRM(29,___G___riscv_23_riscv_2d_d8b)
#define ___GLO___riscv_23_riscv_2d_data_2d_elems ___GLO(30,___G___riscv_23_riscv_2d_data_2d_elems)
#define ___PRM___riscv_23_riscv_2d_data_2d_elems ___PRM(30,___G___riscv_23_riscv_2d_data_2d_elems)
#define ___GLO___riscv_23_riscv_2d_db ___GLO(31,___G___riscv_23_riscv_2d_db)
#define ___PRM___riscv_23_riscv_2d_db ___PRM(31,___G___riscv_23_riscv_2d_db)
#define ___GLO___riscv_23_riscv_2d_dd ___GLO(32,___G___riscv_23_riscv_2d_dd)
#define ___PRM___riscv_23_riscv_2d_dd ___PRM(32,___G___riscv_23_riscv_2d_dd)
#define ___GLO___riscv_23_riscv_2d_dh ___GLO(33,___G___riscv_23_riscv_2d_dh)
#define ___PRM___riscv_23_riscv_2d_dh ___PRM(33,___G___riscv_23_riscv_2d_dh)
#define ___GLO___riscv_23_riscv_2d_dl ___GLO(34,___G___riscv_23_riscv_2d_dl)
#define ___PRM___riscv_23_riscv_2d_dl ___PRM(34,___G___riscv_23_riscv_2d_dl)
#define ___GLO___riscv_23_riscv_2d_dq ___GLO(35,___G___riscv_23_riscv_2d_dq)
#define ___PRM___riscv_23_riscv_2d_dq ___PRM(35,___G___riscv_23_riscv_2d_dq)
#define ___GLO___riscv_23_riscv_2d_ds ___GLO(36,___G___riscv_23_riscv_2d_ds)
#define ___PRM___riscv_23_riscv_2d_ds ___PRM(36,___G___riscv_23_riscv_2d_ds)
#define ___GLO___riscv_23_riscv_2d_dw ___GLO(37,___G___riscv_23_riscv_2d_dw)
#define ___PRM___riscv_23_riscv_2d_dw ___PRM(37,___G___riscv_23_riscv_2d_dw)
#define ___GLO___riscv_23_riscv_2d_ebreak ___GLO(38,___G___riscv_23_riscv_2d_ebreak)
#define ___PRM___riscv_23_riscv_2d_ebreak ___PRM(38,___G___riscv_23_riscv_2d_ebreak)
#define ___GLO___riscv_23_riscv_2d_ecall ___GLO(39,___G___riscv_23_riscv_2d_ecall)
#define ___PRM___riscv_23_riscv_2d_ecall ___PRM(39,___G___riscv_23_riscv_2d_ecall)
#define ___GLO___riscv_23_riscv_2d_fence ___GLO(40,___G___riscv_23_riscv_2d_fence)
#define ___PRM___riscv_23_riscv_2d_fence ___PRM(40,___G___riscv_23_riscv_2d_fence)
#define ___GLO___riscv_23_riscv_2d_fence_2e_i ___GLO(41,___G___riscv_23_riscv_2d_fence_2e_i)
#define ___PRM___riscv_23_riscv_2d_fence_2e_i ___PRM(41,___G___riscv_23_riscv_2d_fence_2e_i)
#define ___GLO___riscv_23_riscv_2d_imm_2d__3e_instr ___GLO(42,___G___riscv_23_riscv_2d_imm_2d__3e_instr)
#define ___PRM___riscv_23_riscv_2d_imm_2d__3e_instr ___PRM(42,___G___riscv_23_riscv_2d_imm_2d__3e_instr)
#define ___GLO___riscv_23_riscv_2d_imm_2d_int ___GLO(43,___G___riscv_23_riscv_2d_imm_2d_int)
#define ___PRM___riscv_23_riscv_2d_imm_2d_int ___PRM(43,___G___riscv_23_riscv_2d_imm_2d_int)
#define ___GLO___riscv_23_riscv_2d_imm_2d_int_2d_type ___GLO(44,___G___riscv_23_riscv_2d_imm_2d_int_2d_type)
#define ___PRM___riscv_23_riscv_2d_imm_2d_int_2d_type ___PRM(44,___G___riscv_23_riscv_2d_imm_2d_int_2d_type)
#define ___GLO___riscv_23_riscv_2d_imm_2d_int_2d_value ___GLO(45,___G___riscv_23_riscv_2d_imm_2d_int_2d_value)
#define ___PRM___riscv_23_riscv_2d_imm_2d_int_2d_value ___PRM(45,___G___riscv_23_riscv_2d_imm_2d_int_2d_value)
#define ___GLO___riscv_23_riscv_2d_imm_2d_int_3f_ ___GLO(46,___G___riscv_23_riscv_2d_imm_2d_int_3f_)
#define ___PRM___riscv_23_riscv_2d_imm_2d_int_3f_ ___PRM(46,___G___riscv_23_riscv_2d_imm_2d_int_3f_)
#define ___GLO___riscv_23_riscv_2d_imm_2d_lbl ___GLO(47,___G___riscv_23_riscv_2d_imm_2d_lbl)
#define ___PRM___riscv_23_riscv_2d_imm_2d_lbl ___PRM(47,___G___riscv_23_riscv_2d_imm_2d_lbl)
#define ___GLO___riscv_23_riscv_2d_imm_2d_lbl_2d_label ___GLO(48,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
#define ___PRM___riscv_23_riscv_2d_imm_2d_lbl_2d_label ___PRM(48,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
#define ___GLO___riscv_23_riscv_2d_imm_2d_lbl_2d_offset ___GLO(49,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
#define ___PRM___riscv_23_riscv_2d_imm_2d_lbl_2d_offset ___PRM(49,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
#define ___GLO___riscv_23_riscv_2d_imm_2d_lbl_3f_ ___GLO(50,___G___riscv_23_riscv_2d_imm_2d_lbl_3f_)
#define ___PRM___riscv_23_riscv_2d_imm_2d_lbl_3f_ ___PRM(50,___G___riscv_23_riscv_2d_imm_2d_lbl_3f_)
#define ___GLO___riscv_23_riscv_2d_imm_3f_ ___GLO(51,___G___riscv_23_riscv_2d_imm_3f_)
#define ___PRM___riscv_23_riscv_2d_imm_3f_ ___PRM(51,___G___riscv_23_riscv_2d_imm_3f_)
#define ___GLO___riscv_23_riscv_2d_j ___GLO(52,___G___riscv_23_riscv_2d_j)
#define ___PRM___riscv_23_riscv_2d_j ___PRM(52,___G___riscv_23_riscv_2d_j)
#define ___GLO___riscv_23_riscv_2d_jal ___GLO(53,___G___riscv_23_riscv_2d_jal)
#define ___PRM___riscv_23_riscv_2d_jal ___PRM(53,___G___riscv_23_riscv_2d_jal)
#define ___GLO___riscv_23_riscv_2d_jal_2a_ ___GLO(54,___G___riscv_23_riscv_2d_jal_2a_)
#define ___PRM___riscv_23_riscv_2d_jal_2a_ ___PRM(54,___G___riscv_23_riscv_2d_jal_2a_)
#define ___GLO___riscv_23_riscv_2d_jalr ___GLO(55,___G___riscv_23_riscv_2d_jalr)
#define ___PRM___riscv_23_riscv_2d_jalr ___PRM(55,___G___riscv_23_riscv_2d_jalr)
#define ___GLO___riscv_23_riscv_2d_jalr_2a_ ___GLO(56,___G___riscv_23_riscv_2d_jalr_2a_)
#define ___PRM___riscv_23_riscv_2d_jalr_2a_ ___PRM(56,___G___riscv_23_riscv_2d_jalr_2a_)
#define ___GLO___riscv_23_riscv_2d_jr ___GLO(57,___G___riscv_23_riscv_2d_jr)
#define ___PRM___riscv_23_riscv_2d_jr ___PRM(57,___G___riscv_23_riscv_2d_jr)
#define ___GLO___riscv_23_riscv_2d_label ___GLO(58,___G___riscv_23_riscv_2d_label)
#define ___PRM___riscv_23_riscv_2d_label ___PRM(58,___G___riscv_23_riscv_2d_label)
#define ___GLO___riscv_23_riscv_2d_lb ___GLO(59,___G___riscv_23_riscv_2d_lb)
#define ___PRM___riscv_23_riscv_2d_lb ___PRM(59,___G___riscv_23_riscv_2d_lb)
#define ___GLO___riscv_23_riscv_2d_lbu ___GLO(60,___G___riscv_23_riscv_2d_lbu)
#define ___PRM___riscv_23_riscv_2d_lbu ___PRM(60,___G___riscv_23_riscv_2d_lbu)
#define ___GLO___riscv_23_riscv_2d_ld ___GLO(61,___G___riscv_23_riscv_2d_ld)
#define ___PRM___riscv_23_riscv_2d_ld ___PRM(61,___G___riscv_23_riscv_2d_ld)
#define ___GLO___riscv_23_riscv_2d_lh ___GLO(62,___G___riscv_23_riscv_2d_lh)
#define ___PRM___riscv_23_riscv_2d_lh ___PRM(62,___G___riscv_23_riscv_2d_lh)
#define ___GLO___riscv_23_riscv_2d_lhu ___GLO(63,___G___riscv_23_riscv_2d_lhu)
#define ___PRM___riscv_23_riscv_2d_lhu ___PRM(63,___G___riscv_23_riscv_2d_lhu)
#define ___GLO___riscv_23_riscv_2d_li ___GLO(64,___G___riscv_23_riscv_2d_li)
#define ___PRM___riscv_23_riscv_2d_li ___PRM(64,___G___riscv_23_riscv_2d_li)
#define ___GLO___riscv_23_riscv_2d_listing ___GLO(65,___G___riscv_23_riscv_2d_listing)
#define ___PRM___riscv_23_riscv_2d_listing ___PRM(65,___G___riscv_23_riscv_2d_listing)
#define ___GLO___riscv_23_riscv_2d_lui ___GLO(66,___G___riscv_23_riscv_2d_lui)
#define ___PRM___riscv_23_riscv_2d_lui ___PRM(66,___G___riscv_23_riscv_2d_lui)
#define ___GLO___riscv_23_riscv_2d_lw ___GLO(67,___G___riscv_23_riscv_2d_lw)
#define ___PRM___riscv_23_riscv_2d_lw ___PRM(67,___G___riscv_23_riscv_2d_lw)
#define ___GLO___riscv_23_riscv_2d_lwu ___GLO(68,___G___riscv_23_riscv_2d_lwu)
#define ___PRM___riscv_23_riscv_2d_lwu ___PRM(68,___G___riscv_23_riscv_2d_lwu)
#define ___GLO___riscv_23_riscv_2d_mv ___GLO(69,___G___riscv_23_riscv_2d_mv)
#define ___PRM___riscv_23_riscv_2d_mv ___PRM(69,___G___riscv_23_riscv_2d_mv)
#define ___GLO___riscv_23_riscv_2d_neg ___GLO(70,___G___riscv_23_riscv_2d_neg)
#define ___PRM___riscv_23_riscv_2d_neg ___PRM(70,___G___riscv_23_riscv_2d_neg)
#define ___GLO___riscv_23_riscv_2d_negw ___GLO(71,___G___riscv_23_riscv_2d_negw)
#define ___PRM___riscv_23_riscv_2d_negw ___PRM(71,___G___riscv_23_riscv_2d_negw)
#define ___GLO___riscv_23_riscv_2d_nop ___GLO(72,___G___riscv_23_riscv_2d_nop)
#define ___PRM___riscv_23_riscv_2d_nop ___PRM(72,___G___riscv_23_riscv_2d_nop)
#define ___GLO___riscv_23_riscv_2d_not ___GLO(73,___G___riscv_23_riscv_2d_not)
#define ___PRM___riscv_23_riscv_2d_not ___PRM(73,___G___riscv_23_riscv_2d_not)
#define ___GLO___riscv_23_riscv_2d_or ___GLO(74,___G___riscv_23_riscv_2d_or)
#define ___PRM___riscv_23_riscv_2d_or ___PRM(74,___G___riscv_23_riscv_2d_or)
#define ___GLO___riscv_23_riscv_2d_ori ___GLO(75,___G___riscv_23_riscv_2d_ori)
#define ___PRM___riscv_23_riscv_2d_ori ___PRM(75,___G___riscv_23_riscv_2d_ori)
#define ___GLO___riscv_23_riscv_2d_register_2d_name ___GLO(76,___G___riscv_23_riscv_2d_register_2d_name)
#define ___PRM___riscv_23_riscv_2d_register_2d_name ___PRM(76,___G___riscv_23_riscv_2d_register_2d_name)
#define ___GLO___riscv_23_riscv_2d_ret ___GLO(77,___G___riscv_23_riscv_2d_ret)
#define ___PRM___riscv_23_riscv_2d_ret ___PRM(77,___G___riscv_23_riscv_2d_ret)
#define ___GLO___riscv_23_riscv_2d_sb ___GLO(78,___G___riscv_23_riscv_2d_sb)
#define ___PRM___riscv_23_riscv_2d_sb ___PRM(78,___G___riscv_23_riscv_2d_sb)
#define ___GLO___riscv_23_riscv_2d_sd ___GLO(79,___G___riscv_23_riscv_2d_sd)
#define ___PRM___riscv_23_riscv_2d_sd ___PRM(79,___G___riscv_23_riscv_2d_sd)
#define ___GLO___riscv_23_riscv_2d_seqz ___GLO(80,___G___riscv_23_riscv_2d_seqz)
#define ___PRM___riscv_23_riscv_2d_seqz ___PRM(80,___G___riscv_23_riscv_2d_seqz)
#define ___GLO___riscv_23_riscv_2d_sext_2e_w ___GLO(81,___G___riscv_23_riscv_2d_sext_2e_w)
#define ___PRM___riscv_23_riscv_2d_sext_2e_w ___PRM(81,___G___riscv_23_riscv_2d_sext_2e_w)
#define ___GLO___riscv_23_riscv_2d_sgtz ___GLO(82,___G___riscv_23_riscv_2d_sgtz)
#define ___PRM___riscv_23_riscv_2d_sgtz ___PRM(82,___G___riscv_23_riscv_2d_sgtz)
#define ___GLO___riscv_23_riscv_2d_sh ___GLO(83,___G___riscv_23_riscv_2d_sh)
#define ___PRM___riscv_23_riscv_2d_sh ___PRM(83,___G___riscv_23_riscv_2d_sh)
#define ___GLO___riscv_23_riscv_2d_sll ___GLO(84,___G___riscv_23_riscv_2d_sll)
#define ___PRM___riscv_23_riscv_2d_sll ___PRM(84,___G___riscv_23_riscv_2d_sll)
#define ___GLO___riscv_23_riscv_2d_slli ___GLO(85,___G___riscv_23_riscv_2d_slli)
#define ___PRM___riscv_23_riscv_2d_slli ___PRM(85,___G___riscv_23_riscv_2d_slli)
#define ___GLO___riscv_23_riscv_2d_slliw ___GLO(86,___G___riscv_23_riscv_2d_slliw)
#define ___PRM___riscv_23_riscv_2d_slliw ___PRM(86,___G___riscv_23_riscv_2d_slliw)
#define ___GLO___riscv_23_riscv_2d_sllw ___GLO(87,___G___riscv_23_riscv_2d_sllw)
#define ___PRM___riscv_23_riscv_2d_sllw ___PRM(87,___G___riscv_23_riscv_2d_sllw)
#define ___GLO___riscv_23_riscv_2d_slt ___GLO(88,___G___riscv_23_riscv_2d_slt)
#define ___PRM___riscv_23_riscv_2d_slt ___PRM(88,___G___riscv_23_riscv_2d_slt)
#define ___GLO___riscv_23_riscv_2d_slti ___GLO(89,___G___riscv_23_riscv_2d_slti)
#define ___PRM___riscv_23_riscv_2d_slti ___PRM(89,___G___riscv_23_riscv_2d_slti)
#define ___GLO___riscv_23_riscv_2d_sltiu ___GLO(90,___G___riscv_23_riscv_2d_sltiu)
#define ___PRM___riscv_23_riscv_2d_sltiu ___PRM(90,___G___riscv_23_riscv_2d_sltiu)
#define ___GLO___riscv_23_riscv_2d_sltu ___GLO(91,___G___riscv_23_riscv_2d_sltu)
#define ___PRM___riscv_23_riscv_2d_sltu ___PRM(91,___G___riscv_23_riscv_2d_sltu)
#define ___GLO___riscv_23_riscv_2d_sltz ___GLO(92,___G___riscv_23_riscv_2d_sltz)
#define ___PRM___riscv_23_riscv_2d_sltz ___PRM(92,___G___riscv_23_riscv_2d_sltz)
#define ___GLO___riscv_23_riscv_2d_snez ___GLO(93,___G___riscv_23_riscv_2d_snez)
#define ___PRM___riscv_23_riscv_2d_snez ___PRM(93,___G___riscv_23_riscv_2d_snez)
#define ___GLO___riscv_23_riscv_2d_sra ___GLO(94,___G___riscv_23_riscv_2d_sra)
#define ___PRM___riscv_23_riscv_2d_sra ___PRM(94,___G___riscv_23_riscv_2d_sra)
#define ___GLO___riscv_23_riscv_2d_srai ___GLO(95,___G___riscv_23_riscv_2d_srai)
#define ___PRM___riscv_23_riscv_2d_srai ___PRM(95,___G___riscv_23_riscv_2d_srai)
#define ___GLO___riscv_23_riscv_2d_sraiw ___GLO(96,___G___riscv_23_riscv_2d_sraiw)
#define ___PRM___riscv_23_riscv_2d_sraiw ___PRM(96,___G___riscv_23_riscv_2d_sraiw)
#define ___GLO___riscv_23_riscv_2d_sraw ___GLO(97,___G___riscv_23_riscv_2d_sraw)
#define ___PRM___riscv_23_riscv_2d_sraw ___PRM(97,___G___riscv_23_riscv_2d_sraw)
#define ___GLO___riscv_23_riscv_2d_srl ___GLO(98,___G___riscv_23_riscv_2d_srl)
#define ___PRM___riscv_23_riscv_2d_srl ___PRM(98,___G___riscv_23_riscv_2d_srl)
#define ___GLO___riscv_23_riscv_2d_srli ___GLO(99,___G___riscv_23_riscv_2d_srli)
#define ___PRM___riscv_23_riscv_2d_srli ___PRM(99,___G___riscv_23_riscv_2d_srli)
#define ___GLO___riscv_23_riscv_2d_srliw ___GLO(100,___G___riscv_23_riscv_2d_srliw)
#define ___PRM___riscv_23_riscv_2d_srliw ___PRM(100,___G___riscv_23_riscv_2d_srliw)
#define ___GLO___riscv_23_riscv_2d_srlw ___GLO(101,___G___riscv_23_riscv_2d_srlw)
#define ___PRM___riscv_23_riscv_2d_srlw ___PRM(101,___G___riscv_23_riscv_2d_srlw)
#define ___GLO___riscv_23_riscv_2d_sub ___GLO(102,___G___riscv_23_riscv_2d_sub)
#define ___PRM___riscv_23_riscv_2d_sub ___PRM(102,___G___riscv_23_riscv_2d_sub)
#define ___GLO___riscv_23_riscv_2d_subw ___GLO(103,___G___riscv_23_riscv_2d_subw)
#define ___PRM___riscv_23_riscv_2d_subw ___PRM(103,___G___riscv_23_riscv_2d_subw)
#define ___GLO___riscv_23_riscv_2d_sw ___GLO(104,___G___riscv_23_riscv_2d_sw)
#define ___PRM___riscv_23_riscv_2d_sw ___PRM(104,___G___riscv_23_riscv_2d_sw)
#define ___GLO___riscv_23_riscv_2d_tail ___GLO(105,___G___riscv_23_riscv_2d_tail)
#define ___PRM___riscv_23_riscv_2d_tail ___PRM(105,___G___riscv_23_riscv_2d_tail)
#define ___GLO___riscv_23_riscv_2d_type_2d_b ___GLO(106,___G___riscv_23_riscv_2d_type_2d_b)
#define ___PRM___riscv_23_riscv_2d_type_2d_b ___PRM(106,___G___riscv_23_riscv_2d_type_2d_b)
#define ___GLO___riscv_23_riscv_2d_type_2d_i ___GLO(107,___G___riscv_23_riscv_2d_type_2d_i)
#define ___PRM___riscv_23_riscv_2d_type_2d_i ___PRM(107,___G___riscv_23_riscv_2d_type_2d_i)
#define ___GLO___riscv_23_riscv_2d_type_2d_j ___GLO(108,___G___riscv_23_riscv_2d_type_2d_j)
#define ___PRM___riscv_23_riscv_2d_type_2d_j ___PRM(108,___G___riscv_23_riscv_2d_type_2d_j)
#define ___GLO___riscv_23_riscv_2d_type_2d_r ___GLO(109,___G___riscv_23_riscv_2d_type_2d_r)
#define ___PRM___riscv_23_riscv_2d_type_2d_r ___PRM(109,___G___riscv_23_riscv_2d_type_2d_r)
#define ___GLO___riscv_23_riscv_2d_type_2d_s ___GLO(110,___G___riscv_23_riscv_2d_type_2d_s)
#define ___PRM___riscv_23_riscv_2d_type_2d_s ___PRM(110,___G___riscv_23_riscv_2d_type_2d_s)
#define ___GLO___riscv_23_riscv_2d_type_2d_u ___GLO(111,___G___riscv_23_riscv_2d_type_2d_u)
#define ___PRM___riscv_23_riscv_2d_type_2d_u ___PRM(111,___G___riscv_23_riscv_2d_type_2d_u)
#define ___GLO___riscv_23_riscv_2d_word_2d_width ___GLO(112,___G___riscv_23_riscv_2d_word_2d_width)
#define ___PRM___riscv_23_riscv_2d_word_2d_width ___PRM(112,___G___riscv_23_riscv_2d_word_2d_width)
#define ___GLO___riscv_23_riscv_2d_xor ___GLO(113,___G___riscv_23_riscv_2d_xor)
#define ___PRM___riscv_23_riscv_2d_xor ___PRM(113,___G___riscv_23_riscv_2d_xor)
#define ___GLO___riscv_23_riscv_2d_xori ___GLO(114,___G___riscv_23_riscv_2d_xori)
#define ___PRM___riscv_23_riscv_2d_xori ___PRM(114,___G___riscv_23_riscv_2d_xori)
#define ___GLO__2b_ ___GLO(115,___G__2b_)
#define ___PRM__2b_ ___PRM(115,___G__2b_)
#define ___GLO__2d_ ___GLO(116,___G__2d_)
#define ___PRM__2d_ ___PRM(116,___G__2d_)
#define ___GLO__3c__3d_ ___GLO(117,___G__3c__3d_)
#define ___PRM__3c__3d_ ___PRM(117,___G__3c__3d_)
#define ___GLO__3e__3d_ ___GLO(118,___G__3e__3d_)
#define ___PRM__3e__3d_ ___PRM(118,___G__3e__3d_)
#define ___GLO___asm_23_asm_2d_32_2d_le ___GLO(119,___G___asm_23_asm_2d_32_2d_le)
#define ___PRM___asm_23_asm_2d_32_2d_le ___PRM(119,___G___asm_23_asm_2d_32_2d_le)
#define ___GLO___asm_23_asm_2d_at_2d_assembly ___GLO(120,___G___asm_23_asm_2d_at_2d_assembly)
#define ___PRM___asm_23_asm_2d_at_2d_assembly ___PRM(120,___G___asm_23_asm_2d_at_2d_assembly)
#define ___GLO___asm_23_asm_2d_int_2d_le ___GLO(121,___G___asm_23_asm_2d_int_2d_le)
#define ___PRM___asm_23_asm_2d_int_2d_le ___PRM(121,___G___asm_23_asm_2d_int_2d_le)
#define ___GLO___asm_23_asm_2d_label ___GLO(122,___G___asm_23_asm_2d_label)
#define ___PRM___asm_23_asm_2d_label ___PRM(122,___G___asm_23_asm_2d_label)
#define ___GLO___asm_23_asm_2d_label_2d_name ___GLO(123,___G___asm_23_asm_2d_label_2d_name)
#define ___PRM___asm_23_asm_2d_label_2d_name ___PRM(123,___G___asm_23_asm_2d_label_2d_name)
#define ___GLO___asm_23_asm_2d_label_2d_pos ___GLO(124,___G___asm_23_asm_2d_label_2d_pos)
#define ___PRM___asm_23_asm_2d_label_2d_pos ___PRM(124,___G___asm_23_asm_2d_label_2d_pos)
#define ___GLO___asm_23_asm_2d_listing ___GLO(125,___G___asm_23_asm_2d_listing)
#define ___PRM___asm_23_asm_2d_listing ___PRM(125,___G___asm_23_asm_2d_listing)
#define ___GLO___asm_23_asm_2d_separated_2d_list ___GLO(126,___G___asm_23_asm_2d_separated_2d_list)
#define ___PRM___asm_23_asm_2d_separated_2d_list ___PRM(126,___G___asm_23_asm_2d_separated_2d_list)
#define ___GLO___asm_23_asm_2d_signed_2d_lo64 ___GLO(127,___G___asm_23_asm_2d_signed_2d_lo64)
#define ___PRM___asm_23_asm_2d_signed_2d_lo64 ___PRM(127,___G___asm_23_asm_2d_signed_2d_lo64)
#define ___GLO___asm_23_asm_2d_unsigned_2d_lo64 ___GLO(128,___G___asm_23_asm_2d_unsigned_2d_lo64)
#define ___PRM___asm_23_asm_2d_unsigned_2d_lo64 ___PRM(128,___G___asm_23_asm_2d_unsigned_2d_lo64)
#define ___GLO___codegen_23_codegen_2d_context_2d_arch ___GLO(129,___G___codegen_23_codegen_2d_context_2d_arch)
#define ___PRM___codegen_23_codegen_2d_context_2d_arch ___PRM(129,___G___codegen_23_codegen_2d_context_2d_arch)
#define ___GLO___codegen_23_codegen_2d_context_2d_arch_2d_set_21_ ___GLO(130,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
#define ___PRM___codegen_23_codegen_2d_context_2d_arch_2d_set_21_ ___PRM(130,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
#define ___GLO___codegen_23_codegen_2d_context_2d_listing_2d_format ___GLO(131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
#define ___PRM___codegen_23_codegen_2d_context_2d_listing_2d_format ___PRM(131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
#define ___GLO_arithmetic_2d_shift ___GLO(132,___G_arithmetic_2d_shift)
#define ___PRM_arithmetic_2d_shift ___PRM(132,___G_arithmetic_2d_shift)
#define ___GLO_bitwise_2d_and ___GLO(133,___G_bitwise_2d_and)
#define ___PRM_bitwise_2d_and ___PRM(133,___G_bitwise_2d_and)
#define ___GLO_car ___GLO(134,___G_car)
#define ___PRM_car ___PRM(134,___G_car)
#define ___GLO_cdr ___GLO(135,___G_cdr)
#define ___PRM_cdr ___PRM(135,___G_cdr)
#define ___GLO_cons ___GLO(136,___G_cons)
#define ___PRM_cons ___PRM(136,___G_cons)
#define ___GLO_eq_3f_ ___GLO(137,___G_eq_3f_)
#define ___PRM_eq_3f_ ___PRM(137,___G_eq_3f_)
#define ___GLO_error ___GLO(138,___G_error)
#define ___PRM_error ___PRM(138,___G_error)
#define ___GLO_first_2d_bit_2d_set ___GLO(139,___G_first_2d_bit_2d_set)
#define ___PRM_first_2d_bit_2d_set ___PRM(139,___G_first_2d_bit_2d_set)
#define ___GLO_fixnum_3f_ ___GLO(140,___G_fixnum_3f_)
#define ___PRM_fixnum_3f_ ___PRM(140,___G_fixnum_3f_)
#define ___GLO_fx_2b_ ___GLO(141,___G_fx_2b_)
#define ___PRM_fx_2b_ ___PRM(141,___G_fx_2b_)
#define ___GLO_fx_2d_ ___GLO(142,___G_fx_2d_)
#define ___PRM_fx_2d_ ___PRM(142,___G_fx_2d_)
#define ___GLO_fx_3c_ ___GLO(143,___G_fx_3c_)
#define ___PRM_fx_3c_ ___PRM(143,___G_fx_3c_)
#define ___GLO_fx_3c__3d_ ___GLO(144,___G_fx_3c__3d_)
#define ___PRM_fx_3c__3d_ ___PRM(144,___G_fx_3c__3d_)
#define ___GLO_fx_3d_ ___GLO(145,___G_fx_3d_)
#define ___PRM_fx_3d_ ___PRM(145,___G_fx_3d_)
#define ___GLO_fx_3e_ ___GLO(146,___G_fx_3e_)
#define ___PRM_fx_3e_ ___PRM(146,___G_fx_3e_)
#define ___GLO_fx_3e__3d_ ___GLO(147,___G_fx_3e__3d_)
#define ___PRM_fx_3e__3d_ ___PRM(147,___G_fx_3e__3d_)
#define ___GLO_fxand ___GLO(148,___G_fxand)
#define ___PRM_fxand ___PRM(148,___G_fxand)
#define ___GLO_fxarithmetic_2d_shift ___GLO(149,___G_fxarithmetic_2d_shift)
#define ___PRM_fxarithmetic_2d_shift ___PRM(149,___G_fxarithmetic_2d_shift)
#define ___GLO_fxbit_2d_set_3f_ ___GLO(150,___G_fxbit_2d_set_3f_)
#define ___PRM_fxbit_2d_set_3f_ ___PRM(150,___G_fxbit_2d_set_3f_)
#define ___GLO_fxeven_3f_ ___GLO(151,___G_fxeven_3f_)
#define ___PRM_fxeven_3f_ ___PRM(151,___G_fxeven_3f_)
#define ___GLO_fxmin ___GLO(152,___G_fxmin)
#define ___PRM_fxmin ___PRM(152,___G_fxmin)
#define ___GLO_fxzero_3f_ ___GLO(153,___G_fxzero_3f_)
#define ___PRM_fxzero_3f_ ___PRM(153,___G_fxzero_3f_)
#define ___GLO_list ___GLO(154,___G_list)
#define ___PRM_list ___PRM(154,___G_list)
#define ___GLO_list_2d__3e_vector ___GLO(155,___G_list_2d__3e_vector)
#define ___PRM_list_2d__3e_vector ___PRM(155,___G_list_2d__3e_vector)
#define ___GLO_map ___GLO(156,___G_map)
#define ___PRM_map ___PRM(156,___G_map)
#define ___GLO_not ___GLO(157,___G_not)
#define ___PRM_not ___PRM(157,___G_not)
#define ___GLO_number_2d__3e_string ___GLO(158,___G_number_2d__3e_string)
#define ___PRM_number_2d__3e_string ___PRM(158,___G_number_2d__3e_string)
#define ___GLO_number_3f_ ___GLO(159,___G_number_3f_)
#define ___PRM_number_3f_ ___PRM(159,___G_number_3f_)
#define ___GLO_pair_3f_ ___GLO(160,___G_pair_3f_)
#define ___PRM_pair_3f_ ___PRM(160,___G_pair_3f_)
#define ___GLO_reverse ___GLO(161,___G_reverse)
#define ___PRM_reverse ___PRM(161,___G_reverse)
#define ___GLO_string_2d_append ___GLO(162,___G_string_2d_append)
#define ___PRM_string_2d_append ___PRM(162,___G_string_2d_append)
#define ___GLO_symbol_3f_ ___GLO(163,___G_symbol_3f_)
#define ___PRM_symbol_3f_ ___PRM(163,___G_symbol_3f_)
#define ___GLO_vector ___GLO(164,___G_vector)
#define ___PRM_vector ___PRM(164,___G_vector)
#define ___GLO_vector_2d_length ___GLO(165,___G_vector_2d_length)
#define ___PRM_vector_2d_length ___PRM(165,___G_vector_2d_length)
#define ___GLO_vector_2d_ref ___GLO(166,___G_vector_2d_ref)
#define ___PRM_vector_2d_ref ___PRM(166,___G_vector_2d_ref)
#define ___GLO_vector_3f_ ___GLO(167,___G_vector_3f_)
#define ___PRM_vector_3f_ ___PRM(167,___G_vector_3f_)
#define ___GLO_zero_3f_ ___GLO(168,___G_zero_3f_)
#define ___PRM_zero_3f_ ___PRM(168,___G_zero_3f_)

___DEF_SUB_VEC(___X0,33UL)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SUB(2))
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SUB(4))
               ___VEC1(___REF_SUB(5))
               ___VEC1(___REF_SUB(6))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(8))
               ___VEC1(___REF_SUB(9))
               ___VEC1(___REF_SUB(10))
               ___VEC1(___REF_SUB(11))
               ___VEC1(___REF_SUB(12))
               ___VEC1(___REF_SUB(13))
               ___VEC1(___REF_SUB(14))
               ___VEC1(___REF_SUB(15))
               ___VEC1(___REF_SUB(16))
               ___VEC1(___REF_SUB(17))
               ___VEC1(___REF_SUB(18))
               ___VEC1(___REF_SUB(19))
               ___VEC1(___REF_SUB(20))
               ___VEC1(___REF_SUB(21))
               ___VEC1(___REF_SUB(22))
               ___VEC1(___REF_SUB(23))
               ___VEC1(___REF_SUB(24))
               ___VEC1(___REF_SUB(25))
               ___VEC1(___REF_SUB(26))
               ___VEC1(___REF_SUB(27))
               ___VEC1(___REF_SUB(28))
               ___VEC1(___REF_SUB(29))
               ___VEC1(___REF_SUB(30))
               ___VEC1(___REF_SUB(31))
               ___VEC1(___REF_SUB(32))
               ___VEC1(___REF_SUB(33))
               ___VEC0
___DEF_SUB_STR(___X1,2UL)
               ___STR2(120,48)
___DEF_SUB_STR(___X2,2UL)
               ___STR2(120,49)
___DEF_SUB_STR(___X3,2UL)
               ___STR2(120,50)
___DEF_SUB_STR(___X4,2UL)
               ___STR2(120,51)
___DEF_SUB_STR(___X5,2UL)
               ___STR2(120,52)
___DEF_SUB_STR(___X6,2UL)
               ___STR2(120,53)
___DEF_SUB_STR(___X7,2UL)
               ___STR2(120,54)
___DEF_SUB_STR(___X8,2UL)
               ___STR2(120,55)
___DEF_SUB_STR(___X9,2UL)
               ___STR2(120,56)
___DEF_SUB_STR(___X10,2UL)
               ___STR2(120,57)
___DEF_SUB_STR(___X11,3UL)
               ___STR3(120,49,48)
___DEF_SUB_STR(___X12,3UL)
               ___STR3(120,49,49)
___DEF_SUB_STR(___X13,3UL)
               ___STR3(120,49,50)
___DEF_SUB_STR(___X14,3UL)
               ___STR3(120,49,51)
___DEF_SUB_STR(___X15,3UL)
               ___STR3(120,49,52)
___DEF_SUB_STR(___X16,3UL)
               ___STR3(120,49,53)
___DEF_SUB_STR(___X17,3UL)
               ___STR3(120,49,54)
___DEF_SUB_STR(___X18,3UL)
               ___STR3(120,49,55)
___DEF_SUB_STR(___X19,3UL)
               ___STR3(120,49,56)
___DEF_SUB_STR(___X20,3UL)
               ___STR3(120,49,57)
___DEF_SUB_STR(___X21,3UL)
               ___STR3(120,50,48)
___DEF_SUB_STR(___X22,3UL)
               ___STR3(120,50,49)
___DEF_SUB_STR(___X23,3UL)
               ___STR3(120,50,50)
___DEF_SUB_STR(___X24,3UL)
               ___STR3(120,50,51)
___DEF_SUB_STR(___X25,3UL)
               ___STR3(120,50,52)
___DEF_SUB_STR(___X26,3UL)
               ___STR3(120,50,53)
___DEF_SUB_STR(___X27,3UL)
               ___STR3(120,50,54)
___DEF_SUB_STR(___X28,3UL)
               ___STR3(120,50,55)
___DEF_SUB_STR(___X29,3UL)
               ___STR3(120,50,56)
___DEF_SUB_STR(___X30,3UL)
               ___STR3(120,50,57)
___DEF_SUB_STR(___X31,3UL)
               ___STR3(120,51,48)
___DEF_SUB_STR(___X32,3UL)
               ___STR3(120,51,49)
___DEF_SUB_STR(___X33,2UL)
               ___STR2(112,99)
___DEF_SUB_STR(___X34,23UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(105,109,109,101,100,105,97,116)
               ___STR7(101,32,118,97,108,117,101)
___DEF_SUB_BIGFIX(___X35,2UL)
               ___BIGFIX2(-0x1L,0x0L)
               ___BIGFIX0
___DEF_SUB_STR(___X36,22UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(105,109,109,101,100,105,97,116)
               ___STR6(101,32,116,121,112,101)
___DEF_SUB_STR(___X37,23UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(105,109,109,101,100,105,97,116)
               ___STR7(101,32,118,97,108,117,101)
___DEF_SUB_STR(___X38,23UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(105,109,109,101,100,105,97,116)
               ___STR7(101,32,118,97,108,117,101)
___DEF_SUB_STR(___X39,2UL)
               ___STR2(44,32)
___DEF_SUB_STR(___X40,21UL)
               ___STR8(117,110,115,117,112,112,111,114)
               ___STR8(116,101,100,32,105,109,109,101)
               ___STR5(100,105,97,116,101)
___DEF_SUB_STR(___X41,1UL)
               ___STR1(58)
___DEF_SUB_STR(___X42,5UL)
               ___STR5(46,98,121,116,101)
___DEF_SUB_STR(___X43,1UL)
               ___STR1(44)
___DEF_SUB_STR(___X44,5UL)
               ___STR5(46,104,97,108,102)
___DEF_SUB_STR(___X45,5UL)
               ___STR5(46,119,111,114,100)
___DEF_SUB_STR(___X46,6UL)
               ___STR6(46,100,119,111,114,100)
___DEF_SUB_STR(___X47,18UL)
               ___STR8(117,110,107,110,111,119,110,32)
               ___STR8(100,97,116,97,32,119,105,100)
               ___STR2(116,104)
___DEF_SUB_BIGFIX(___X48,1UL)
               ___BIGFIX1(-1-0x7FFFFFFFL)
___DEF_SUB_BIGFIX(___X49,1UL)
               ___BIGFIX1(0x7fffffffL)
___DEF_SUB_STR(___X50,32UL)
               ___STR8(105,110,115,116,114,117,99,116)
               ___STR8(105,111,110,32,111,110,108,121)
               ___STR8(32,118,97,108,105,100,32,102)
               ___STR8(111,114,32,82,86,54,52,73)
               ___STR0
___DEF_SUB_BIGFIX(___X51,2UL)
               ___BIGFIX2(-0x1000L,0x0L)
               ___BIGFIX0
___DEF_SUB_BIGFIX(___X52,1UL)
               ___BIGFIX1(0x40000000L)
___DEF_SUB_VEC(___X53,8UL)
               ___VEC1(___REF_SUB(54))
               ___VEC1(___REF_SUB(55))
               ___VEC1(___REF_SUB(56))
               ___VEC1(___REF_SUB(57))
               ___VEC1(___REF_SUB(58))
               ___VEC1(___REF_SUB(59))
               ___VEC1(___REF_SUB(60))
               ___VEC1(___REF_SUB(61))
               ___VEC0
___DEF_SUB_STR(___X54,3UL)
               ___STR3(97,100,100)
___DEF_SUB_STR(___X55,3UL)
               ___STR3(115,108,108)
___DEF_SUB_STR(___X56,3UL)
               ___STR3(115,108,116)
___DEF_SUB_STR(___X57,4UL)
               ___STR4(115,108,116,117)
___DEF_SUB_STR(___X58,3UL)
               ___STR3(120,111,114)
___DEF_SUB_STR(___X59,3UL)
               ___STR3(115,114,108)
___DEF_SUB_STR(___X60,2UL)
               ___STR2(111,114)
___DEF_SUB_STR(___X61,3UL)
               ___STR3(97,110,100)
___DEF_SUB_VEC(___X62,8UL)
               ___VEC1(___REF_SUB(63))
               ___VEC1(___REF_SUB(64))
               ___VEC1(___REF_SUB(65))
               ___VEC1(___REF_SUB(66))
               ___VEC1(___REF_SUB(67))
               ___VEC1(___REF_SUB(68))
               ___VEC1(___REF_SUB(69))
               ___VEC1(___REF_SUB(70))
               ___VEC0
___DEF_SUB_STR(___X63,3UL)
               ___STR3(115,117,98)
___DEF_SUB_STR(___X64,3UL)
               ___STR3(63,63,63)
___DEF_SUB_STR(___X65,3UL)
               ___STR3(63,63,63)
___DEF_SUB_STR(___X66,4UL)
               ___STR4(63,63,63,63)
___DEF_SUB_STR(___X67,3UL)
               ___STR3(63,63,63)
___DEF_SUB_STR(___X68,3UL)
               ___STR3(115,114,97)
___DEF_SUB_STR(___X69,2UL)
               ___STR2(63,63)
___DEF_SUB_STR(___X70,3UL)
               ___STR3(63,63,63)
___DEF_SUB_STR(___X71,1UL)
               ___STR1(119)
___DEF_SUB_STR(___X72,0UL)
               ___STR0
___DEF_SUB_STR(___X73,16UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(111,112,101,114,97,110,100,115)
               ___STR0
___DEF_SUB_STR(___X74,4UL)
               ___STR4(106,97,108,114)
___DEF_SUB_STR(___X75,21UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,104,105,102,116,32,97)
               ___STR5(109,111,117,110,116)
___DEF_SUB_STR(___X76,21UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,104,105,102,116,32,97)
               ___STR5(109,111,117,110,116)
___DEF_SUB_STR(___X77,21UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,104,105,102,116,32,97)
               ___STR5(109,111,117,110,116)
___DEF_SUB_STR(___X78,21UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,104,105,102,116,32,97)
               ___STR5(109,111,117,110,116)
___DEF_SUB_STR(___X79,21UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,104,105,102,116,32,97)
               ___STR5(109,111,117,110,116)
___DEF_SUB_STR(___X80,21UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,104,105,102,116,32,97)
               ___STR5(109,111,117,110,116)
___DEF_SUB_STR(___X81,16UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(111,112,101,114,97,110,100,115)
               ___STR0
___DEF_SUB_STR(___X82,4UL)
               ___STR4(97,100,100,105)
___DEF_SUB_STR(___X83,4UL)
               ___STR4(115,108,108,105)
___DEF_SUB_STR(___X84,4UL)
               ___STR4(115,108,116,105)
___DEF_SUB_STR(___X85,5UL)
               ___STR5(115,108,116,105,117)
___DEF_SUB_STR(___X86,4UL)
               ___STR4(120,111,114,105)
___DEF_SUB_STR(___X87,4UL)
               ___STR4(115,114,97,105)
___DEF_SUB_STR(___X88,4UL)
               ___STR4(115,114,108,105)
___DEF_SUB_STR(___X89,4UL)
               ___STR4(97,110,100,105)
___DEF_SUB_STR(___X90,3UL)
               ___STR3(111,114,105)
___DEF_SUB_STR(___X91,1UL)
               ___STR1(119)
___DEF_SUB_STR(___X92,0UL)
               ___STR0
___DEF_SUB_VEC(___X93,7UL)
               ___VEC1(___REF_SUB(94))
               ___VEC1(___REF_SUB(95))
               ___VEC1(___REF_SUB(96))
               ___VEC1(___REF_SUB(97))
               ___VEC1(___REF_SUB(98))
               ___VEC1(___REF_SUB(99))
               ___VEC1(___REF_SUB(100))
               ___VEC0
___DEF_SUB_STR(___X94,2UL)
               ___STR2(108,98)
___DEF_SUB_STR(___X95,2UL)
               ___STR2(108,104)
___DEF_SUB_STR(___X96,2UL)
               ___STR2(108,119)
___DEF_SUB_STR(___X97,2UL)
               ___STR2(108,100)
___DEF_SUB_STR(___X98,3UL)
               ___STR3(108,98,117)
___DEF_SUB_STR(___X99,3UL)
               ___STR3(108,104,117)
___DEF_SUB_STR(___X100,3UL)
               ___STR3(108,119,117)
___DEF_SUB_STR(___X101,1UL)
               ___STR1(41)
___DEF_SUB_STR(___X102,1UL)
               ___STR1(40)
___DEF_SUB_STR(___X103,24UL)
               ___STR8(105,110,99,111,114,114,101,99)
               ___STR8(116,32,105,109,109,101,100,105)
               ___STR8(97,116,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_STR(___X104,16UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(111,112,101,114,97,110,100,115)
               ___STR0
___DEF_SUB_VEC(___X105,4UL)
               ___VEC1(___REF_SUB(106))
               ___VEC1(___REF_SUB(107))
               ___VEC1(___REF_SUB(108))
               ___VEC1(___REF_SUB(109))
               ___VEC0
___DEF_SUB_STR(___X106,2UL)
               ___STR2(115,98)
___DEF_SUB_STR(___X107,2UL)
               ___STR2(115,104)
___DEF_SUB_STR(___X108,2UL)
               ___STR2(115,119)
___DEF_SUB_STR(___X109,2UL)
               ___STR2(115,100)
___DEF_SUB_STR(___X110,1UL)
               ___STR1(41)
___DEF_SUB_STR(___X111,1UL)
               ___STR1(40)
___DEF_SUB_STR(___X112,24UL)
               ___STR8(105,110,99,111,114,114,101,99)
               ___STR8(116,32,105,109,109,101,100,105)
               ___STR8(97,116,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_STR(___X113,16UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(111,112,101,114,97,110,100,115)
               ___STR0
___DEF_SUB_STR(___X114,24UL)
               ___STR8(105,110,99,111,114,114,101,99)
               ___STR8(116,32,105,109,109,101,100,105)
               ___STR8(97,116,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_VEC(___X115,8UL)
               ___VEC1(___REF_SUB(116))
               ___VEC1(___REF_SUB(117))
               ___VEC1(___REF_SUB(118))
               ___VEC1(___REF_SUB(119))
               ___VEC1(___REF_SUB(120))
               ___VEC1(___REF_SUB(121))
               ___VEC1(___REF_SUB(122))
               ___VEC1(___REF_SUB(123))
               ___VEC0
___DEF_SUB_STR(___X116,3UL)
               ___STR3(98,101,113)
___DEF_SUB_STR(___X117,3UL)
               ___STR3(98,110,101)
___DEF_SUB_STR(___X118,4UL)
               ___STR4(63,63,63,63)
___DEF_SUB_STR(___X119,4UL)
               ___STR4(63,63,63,63)
___DEF_SUB_STR(___X120,3UL)
               ___STR3(98,108,116)
___DEF_SUB_STR(___X121,3UL)
               ___STR3(98,103,101)
___DEF_SUB_STR(___X122,4UL)
               ___STR4(98,108,116,117)
___DEF_SUB_STR(___X123,4UL)
               ___STR4(98,103,101,117)
___DEF_SUB_STR(___X124,20UL)
               ___STR8(98,114,97,110,99,104,32,108)
               ___STR8(97,98,101,108,32,116,111,111)
               ___STR4(32,102,97,114)
___DEF_SUB_STR(___X125,3UL)
               ___STR3(108,117,105)
___DEF_SUB_STR(___X126,5UL)
               ___STR5(97,117,105,112,99)
___DEF_SUB_STR(___X127,16UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(111,112,101,114,97,110,100,115)
               ___STR0
___DEF_SUB_STR(___X128,24UL)
               ___STR8(105,110,99,111,114,114,101,99)
               ___STR8(116,32,105,109,109,101,100,105)
               ___STR8(97,116,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_STR(___X129,3UL)
               ___STR3(106,97,108)
___DEF_SUB_STR(___X130,16UL)
               ___STR8(105,110,118,97,108,105,100,32)
               ___STR8(111,112,101,114,97,110,100,115)
               ___STR0
___DEF_SUB_STR(___X131,24UL)
               ___STR8(105,110,99,111,114,114,101,99)
               ___STR8(116,32,105,109,109,101,100,105)
               ___STR8(97,116,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_STR(___X132,20UL)
               ___STR8(98,114,97,110,99,104,32,108)
               ___STR8(97,98,101,108,32,116,111,111)
               ___STR4(32,102,97,114)
___DEF_SUB_STR(___X133,26UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,112,114,101,100,101,99,101)
               ___STR8(115,115,111,114,32,118,97,108)
               ___STR2(117,101)
___DEF_SUB_STR(___X134,24UL)
               ___STR8(105,109,112,114,111,112,101,114)
               ___STR8(32,115,117,99,99,101,115,115)
               ___STR8(111,114,32,118,97,108,117,101)
               ___STR0
___DEF_SUB_STR(___X135,1UL)
               ___STR1(105)
___DEF_SUB_STR(___X136,0UL)
               ___STR0
___DEF_SUB_STR(___X137,1UL)
               ___STR1(111)
___DEF_SUB_STR(___X138,0UL)
               ___STR0
___DEF_SUB_STR(___X139,1UL)
               ___STR1(114)
___DEF_SUB_STR(___X140,0UL)
               ___STR0
___DEF_SUB_STR(___X141,1UL)
               ___STR1(119)
___DEF_SUB_STR(___X142,0UL)
               ___STR0
___DEF_SUB_STR(___X143,5UL)
               ___STR5(102,101,110,99,101)
___DEF_SUB_STR(___X144,7UL)
               ___STR7(102,101,110,99,101,46,105)
___DEF_SUB_STR(___X145,5UL)
               ___STR5(101,99,97,108,108)
___DEF_SUB_STR(___X146,6UL)
               ___STR6(101,98,114,101,97,107)
___DEF_SUB_VEC(___X147,6UL)
               ___VEC1(___REF_SUB(148))
               ___VEC1(___REF_SUB(149))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X148,1UL)
               ___VEC1(___REF_SYM(6,___S___riscv))
               ___VEC0
___DEF_SUB_VEC(___X149,0UL)
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
,___DEF_SUB(___X98)
,___DEF_SUB(___X99)
,___DEF_SUB(___X100)
,___DEF_SUB(___X101)
,___DEF_SUB(___X102)
,___DEF_SUB(___X103)
,___DEF_SUB(___X104)
,___DEF_SUB(___X105)
,___DEF_SUB(___X106)
,___DEF_SUB(___X107)
,___DEF_SUB(___X108)
,___DEF_SUB(___X109)
,___DEF_SUB(___X110)
,___DEF_SUB(___X111)
,___DEF_SUB(___X112)
,___DEF_SUB(___X113)
,___DEF_SUB(___X114)
,___DEF_SUB(___X115)
,___DEF_SUB(___X116)
,___DEF_SUB(___X117)
,___DEF_SUB(___X118)
,___DEF_SUB(___X119)
,___DEF_SUB(___X120)
,___DEF_SUB(___X121)
,___DEF_SUB(___X122)
,___DEF_SUB(___X123)
,___DEF_SUB(___X124)
,___DEF_SUB(___X125)
,___DEF_SUB(___X126)
,___DEF_SUB(___X127)
,___DEF_SUB(___X128)
,___DEF_SUB(___X129)
,___DEF_SUB(___X130)
,___DEF_SUB(___X131)
,___DEF_SUB(___X132)
,___DEF_SUB(___X133)
,___DEF_SUB(___X134)
,___DEF_SUB(___X135)
,___DEF_SUB(___X136)
,___DEF_SUB(___X137)
,___DEF_SUB(___X138)
,___DEF_SUB(___X139)
,___DEF_SUB(___X140)
,___DEF_SUB(___X141)
,___DEF_SUB(___X142)
,___DEF_SUB(___X143)
,___DEF_SUB(___X144)
,___DEF_SUB(___X145)
,___DEF_SUB(___X146)
,___DEF_SUB(___X147)
,___DEF_SUB(___X148)
,___DEF_SUB(___X149)
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
___DEF_M_HLBL(___L0___riscv_23_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_register_2d_name)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_register_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_arch_2d_set_21_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_arch_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_word_2d_width)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_word_2d_width)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_word_2d_width)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_3f_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int_2d_type)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int_2d_type)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int_2d_value)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int_2d_value)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L25___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L26___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L27___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L28___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L29___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L30___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L31___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L32___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL(___L33___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_listing)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_listing)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_label)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_label)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_label)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_label)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_label)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_label)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_label)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_db)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_db)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_d2b)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_d2b)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_dh)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_dh)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ds)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ds)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_d4b)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_d4b)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_dw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_dw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_dl)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_dl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_d8b)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_d8b)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_dd)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_dd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_dq)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_dq)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L25___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L26___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L27___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL(___L28___riscv_23_riscv_2d_data_2d_elems)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_nop)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_nop)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_nop)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_nop)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L25___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L26___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L27___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L28___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L29___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L30___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L31___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L32___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L33___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L34___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L35___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L36___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L37___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L38___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L39___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L40___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L41___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L42___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L43___riscv_23_riscv_2d_li)
___DEF_M_HLBL(___L44___riscv_23_riscv_2d_li)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_mv)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_mv)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_mv)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_mv)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_not)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_not)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_not)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_not)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_neg)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_neg)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_negw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_negw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sext_2e_w)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sext_2e_w)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_sext_2e_w)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_sext_2e_w)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_sext_2e_w)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_sext_2e_w)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_seqz)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_seqz)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_seqz)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_seqz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_snez)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_snez)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sltz)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sltz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sgtz)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sgtz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_beqz)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_beqz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bnez)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bnez)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_blez)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_blez)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bgez)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bgez)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bltz)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bltz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bgtz)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bgtz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bgt)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bgt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ble)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ble)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bgtu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bgtu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bleu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bleu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_j)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_j)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_jal_2a_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_jal_2a_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_jr)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_jr)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_jr)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_jr)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_jr)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_jr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_jalr_2a_)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_jalr_2a_)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_jalr_2a_)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_jalr_2a_)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_jalr_2a_)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_jalr_2a_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ret)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ret)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_ret)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_ret)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_ret)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_ret)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_call)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_call)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_tail)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_tail)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_add)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_add)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sub)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sub)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sll)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sll)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_slt)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_slt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sltu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sltu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_xor)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_xor)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_srl)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_srl)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sra)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sra)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_or)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_or)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_and)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_and)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_addw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_addw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_addw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_addw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_addw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_addw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_subw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_subw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_subw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_subw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_subw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_subw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sllw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sllw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_sllw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_sllw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_sllw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_sllw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_srlw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_srlw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_srlw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_srlw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_srlw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_srlw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sraw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sraw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_sraw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_sraw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_sraw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_sraw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_type_2d_r)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_jalr)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_jalr)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_jalr)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_jalr)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_jalr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lb)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lb)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lh)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lh)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lbu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lbu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lhu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lhu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_addi)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_addi)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_slti)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_slti)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sltiu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sltiu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_xori)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_xori)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ori)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ori)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_andi)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_andi)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_slli)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_slli)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_srli)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_srli)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_srai)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_srai)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lwu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lwu)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_lwu)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_lwu)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_lwu)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_lwu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ld)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ld)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_ld)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_ld)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_ld)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_ld)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_addiw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_addiw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_addiw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_addiw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_addiw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_addiw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_slliw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_srliw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_sraiw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L25___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L26___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L27___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L28___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L29___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L30___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L31___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L32___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L33___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L34___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L35___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L36___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L37___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L38___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L39___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L40___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L41___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L42___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L43___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L44___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L45___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L46___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L47___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L48___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L49___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L50___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L51___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L52___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L53___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L54___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L55___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L56___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L57___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L58___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L59___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L60___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L61___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L62___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L63___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L64___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L65___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L66___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL(___L67___riscv_23_riscv_2d_type_2d_i)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sb)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sb)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sh)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sh)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sw)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sw)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_sd)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_sd)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_sd)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_sd)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_sd)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_sd)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_type_2d_s)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_beq)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_beq)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bne)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bne)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_blt)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_blt)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bge)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bge)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bltu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bltu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_bgeu)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_bgeu)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L25___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L26___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L27___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L28___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L29___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L30___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L31___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L32___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L33___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L34___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L35___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L36___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L37___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L38___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL(___L39___riscv_23_riscv_2d_type_2d_b)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_lui)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_lui)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_lui)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_lui)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_lui)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_auipc)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_auipc)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_auipc)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_auipc)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_auipc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_type_2d_u)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_jal)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_jal)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_jal)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_jal)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_jal)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L24___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L25___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L26___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L27___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L28___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L29___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L30___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L31___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L32___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L33___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL(___L34___riscv_23_riscv_2d_type_2d_j)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L5___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L6___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L7___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L8___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L9___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L10___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L11___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L12___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L13___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L14___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L15___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L16___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L17___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L18___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L19___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L20___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L21___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L22___riscv_23_riscv_2d_fence)
___DEF_M_HLBL(___L23___riscv_23_riscv_2d_fence)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_fence_2e_i)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_fence_2e_i)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_fence_2e_i)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_fence_2e_i)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_fence_2e_i)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ecall)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ecall)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_ecall)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_ecall)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_ecall)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___riscv_23_riscv_2d_ebreak)
___DEF_M_HLBL(___L1___riscv_23_riscv_2d_ebreak)
___DEF_M_HLBL(___L2___riscv_23_riscv_2d_ebreak)
___DEF_M_HLBL(___L3___riscv_23_riscv_2d_ebreak)
___DEF_M_HLBL(___L4___riscv_23_riscv_2d_ebreak)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_
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
___DEF_P_HLBL(___L0___riscv_23_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___riscv_23_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_register_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_register_2d_name)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_register_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_register_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_register_2d_name)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(0))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_register_2d_name)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_arch_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 6
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_arch_2d_set_21_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_arch_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_arch_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_arch_2d_set_21_)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_arch_2d_set_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),130,___G___codegen_23_codegen_2d_context_2d_arch_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_64bit_2d_mode_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 9
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_64bit_2d_mode_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_64bit_2d_mode_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),129,___G___codegen_23_codegen_2d_context_2d_arch)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_64bit_2d_mode_3f_)
   ___SET_R2(___SYM_RV64I)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_64bit_2d_mode_3f_)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_word_2d_width
#undef ___PH_LBL0
#define ___PH_LBL0 14
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_word_2d_width)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_word_2d_width)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_word_2d_width)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_word_2d_width)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_word_2d_width)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_word_2d_width)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_word_2d_width)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L3___riscv_23_riscv_2d_word_2d_width)
   ___END_IF
   ___SET_R1(___FIX(64L))
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L3___riscv_23_riscv_2d_word_2d_width)
   ___SET_R1(___FIX(32L))
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 18
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_3f_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_3f_)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_int
#undef ___PH_LBL0
#define ___PH_LBL0 21
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_int)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_int)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_int)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_int_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 24
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_imm_2d_int_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),163,___G_symbol_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(6)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),159,___G_number_3f_)
___DEF_GLBL(___L7___riscv_23_riscv_2d_imm_2d_int_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_int_2d_type
#undef ___PH_LBL0
#define ___PH_LBL0 32
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int_2d_type)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int_2d_type)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_int_2d_type)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_int_2d_type)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_int_2d_type)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_int_2d_value
#undef ___PH_LBL0
#define ___PH_LBL0 35
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_int_2d_value)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_int_2d_value)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_int_2d_value)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_int_2d_value)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_int_2d_value)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_lbl
#undef ___PH_LBL0
#define ___PH_LBL0 38
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_lbl)
   ___IF_NARGS_EQ(1,___SET_R2(___FIX(4L)))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_lbl)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_lbl)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_lbl_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 41
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(6)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),167,___G_vector_3f_)
___DEF_GLBL(___L7___riscv_23_riscv_2d_imm_2d_lbl_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_lbl_2d_offset
#undef ___PH_LBL0
#define ___PH_LBL0 49
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_lbl_2d_offset)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d_lbl_2d_label
#undef ___PH_LBL0
#define ___PH_LBL0 52
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d_lbl_2d_label)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_imm_2d__3e_instr
#undef ___PH_LBL0
#define ___PH_LBL0 55
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L25___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L26___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L27___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L28___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L29___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L30___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L31___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L32___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_P_HLBL(___L33___riscv_23_riscv_2d_imm_2d__3e_instr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___IF(___EQP(___R1,___SYM_I))
   ___GOTO(___L42___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___IF(___EQP(___R1,___SYM_S))
   ___GOTO(___L41___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___IF(___EQP(___R1,___SYM_B))
   ___GOTO(___L39___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___IF(___EQP(___R1,___SYM_U))
   ___GOTO(___L38___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___IF(___NOT(___EQP(___R1,___SYM_J)))
   ___GOTO(___L37___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),151,___G_fxeven_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L34___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___SET_R1(___SUB(34))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_GLBL(___L34___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(1044480L))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(2048L))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(9L))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(2046L))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(1048576L))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(11L))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___ADJFP(-3)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),141,___G_fx_2b_)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___GOTO(___L36___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_GLBL(___L35___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___ADJFP(-4)
___DEF_GLBL(___L36___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___R1)
   ___SET_R1(___BIGFIX(35,4294967295LL))
   ___SET_R0(___STK(-3))
   ___POLL(16)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_GLBL(___L37___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(36))
   ___SET_R0(___LBL(14))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),138,___G_error)
___DEF_GLBL(___L38___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(4095L))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),153,___G_fxzero_3f_)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L35___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___SET_R1(___SUB(37))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L39___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),151,___G_fxeven_3f_)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L40___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___END_IF
   ___SET_R1(___SUB(38))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_GLBL(___L40___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(2048L))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(-4L))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(30L))
   ___SET_R0(___LBL(25))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(25,___L25___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(7L))
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(26,___L26___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(2016L))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(27,___L27___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(28,___L28___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(4096L))
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(29,___L29___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(19L))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_GLBL(___L41___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(31L))
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(30,___L30___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(7L))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(31,___L31___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(4064L))
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(32,___L32___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(33,___L33___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_GLBL(___L42___riscv_23_riscv_2d_imm_2d__3e_instr)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(14))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_listing
#undef ___PH_LBL0
#define ___PH_LBL0 90
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_listing)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_listing)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_listing)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_listing)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___LBL(9))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_listing)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),156,___G_map)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_listing)
   ___SET_R2(___SUB(39))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),126,___G___asm_23_asm_2d_separated_2d_list)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_listing)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_listing)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L21___riscv_23_riscv_2d_listing)
   ___END_IF
   ___SET_R1(___NUL)
   ___GOTO(___L20___riscv_23_riscv_2d_listing)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L20___riscv_23_riscv_2d_listing)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_listing)
   ___SET_R2(___R1)
   ___SET_R1(___CHR(9))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_listing)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_listing)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),125,___G___asm_23_asm_2d_listing)
___DEF_GLBL(___L21___riscv_23_riscv_2d_listing)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CHR(9))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_listing)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(9,1,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(10)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_listing)
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_listing)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L22___riscv_23_riscv_2d_listing)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(12)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_listing)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_GLBL(___L22___riscv_23_riscv_2d_listing)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_listing)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L25___riscv_23_riscv_2d_listing)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_listing)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L23___riscv_23_riscv_2d_listing)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(15)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_listing)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_GLBL(___L23___riscv_23_riscv_2d_listing)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(41),___L___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_listing)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L24___riscv_23_riscv_2d_listing)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(40))
   ___SET_R0(___STK(-7))
   ___POLL(17)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_listing)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),138,___G_error)
___DEF_GLBL(___L24___riscv_23_riscv_2d_listing)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_listing)
   ___SET_R0(___STK(-3))
   ___POLL(19)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_listing)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G___asm_23_asm_2d_label_2d_name)
___DEF_GLBL(___L25___riscv_23_riscv_2d_listing)
   ___SET_R1(___STK(-6))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_label
#undef ___PH_LBL0
#define ___PH_LBL0 111
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_label)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_label)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_label)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_label)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_label)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_label)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_label)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_label)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_label)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_label)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),122,___G___asm_23_asm_2d_label)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_label)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_label)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7___riscv_23_riscv_2d_label)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G___asm_23_asm_2d_label_2d_name)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_label)
   ___SET_R2(___SUB(41))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),154,___G_list)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_label)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_label)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),125,___G___asm_23_asm_2d_listing)
___DEF_GLBL(___L7___riscv_23_riscv_2d_label)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_db
#undef ___PH_LBL0
#define ___PH_LBL0 119
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_db)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_db)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_db)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_db)
   ___SET_R3(___FIX(8L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_db)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_d2b
#undef ___PH_LBL0
#define ___PH_LBL0 122
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_d2b)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_d2b)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_d2b)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_d2b)
   ___SET_R3(___FIX(16L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_d2b)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_dh
#undef ___PH_LBL0
#define ___PH_LBL0 125
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_dh)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_dh)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_dh)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_dh)
   ___SET_R3(___FIX(16L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_dh)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ds
#undef ___PH_LBL0
#define ___PH_LBL0 128
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ds)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ds)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ds)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ds)
   ___SET_R3(___FIX(16L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ds)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_d4b
#undef ___PH_LBL0
#define ___PH_LBL0 131
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_d4b)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_d4b)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_d4b)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_d4b)
   ___SET_R3(___FIX(32L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_d4b)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_dw
#undef ___PH_LBL0
#define ___PH_LBL0 134
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_dw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_dw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_dw)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_dw)
   ___SET_R3(___FIX(32L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_dw)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_dl
#undef ___PH_LBL0
#define ___PH_LBL0 137
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_dl)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_dl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_dl)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_dl)
   ___SET_R3(___FIX(32L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_dl)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_d8b
#undef ___PH_LBL0
#define ___PH_LBL0 140
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_d8b)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_d8b)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_d8b)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_d8b)
   ___SET_R3(___FIX(64L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_d8b)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_dd
#undef ___PH_LBL0
#define ___PH_LBL0 143
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_dd)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_dd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_dd)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_dd)
   ___SET_R3(___FIX(64L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_dd)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_dq
#undef ___PH_LBL0
#define ___PH_LBL0 146
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_dq)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_dq)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_dq)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_dq)
   ___SET_R3(___FIX(64L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_dq)
   ___JUMPINT(___SET_NARGS(3),___PRC(149),___L___riscv_23_riscv_2d_data_2d_elems)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_data_2d_elems
#undef ___PH_LBL0
#define ___PH_LBL0 149
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L25___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L26___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L27___riscv_23_riscv_2d_data_2d_elems)
___DEF_P_HLBL(___L28___riscv_23_riscv_2d_data_2d_elems)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_data_2d_elems)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),155,___G_list_2d__3e_vector)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___STK(-4))
   ___ADJFP(-7)
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_data_2d_elems)
   ___GOTO(___L30___riscv_23_riscv_2d_data_2d_elems)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L29___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-4))
   ___ADJFP(-7)
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L30___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___ADJFP(7)
   ___POLL(6)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),165,___G_vector_2d_length)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L39___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(4L))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(10))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),165,___G_vector_2d_length)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(11))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),152,___G_fxmin)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R2(___STK(-3))
   ___SET_R3(___NUL)
   ___SET_R0(___STK(-2))
   ___ADJFP(-5)
   ___POLL(12)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_data_2d_elems)
   ___GOTO(___L31___riscv_23_riscv_2d_data_2d_elems)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___SET_R2(___STK(-6))
   ___ADJFP(-9)
   ___POLL(14)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L31___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R1)
   ___SET_R1(___STK(3))
   ___ADJFP(9)
   ___POLL(15)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L32___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-4,___R1)
   ___SET_R3(___STK(-10))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),121,___G___asm_23_asm_2d_int_2d_le)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-6,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_GLBL(___L32___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L33___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___ADJFP(-4)
   ___GOTO(___L29___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L33___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-3,___CHR(9))
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(8L))
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L35___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___SET_R1(___SUB(42))
   ___GOTO(___L34___riscv_23_riscv_2d_data_2d_elems)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L34___riscv_23_riscv_2d_data_2d_elems)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),161,___G_reverse)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R2(___SUB(43))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),126,___G___asm_23_asm_2d_separated_2d_list)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R3(___R1)
   ___SET_R2(___CHR(9))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
   ___ADJFP(-3)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),154,___G_list)
___DEF_SLBL(25,___L25___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),125,___G___asm_23_asm_2d_listing)
___DEF_GLBL(___L35___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(16L))
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(26,___L26___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L36___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___SET_R1(___SUB(44))
   ___GOTO(___L34___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L36___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(32L))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(27,___L27___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L37___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___SET_R1(___SUB(45))
   ___GOTO(___L34___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L37___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(64L))
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(28,___L28___riscv_23_riscv_2d_data_2d_elems)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L38___riscv_23_riscv_2d_data_2d_elems)
   ___END_IF
   ___SET_R1(___SUB(46))
   ___GOTO(___L34___riscv_23_riscv_2d_data_2d_elems)
___DEF_GLBL(___L38___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___SUB(47))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L39___riscv_23_riscv_2d_data_2d_elems)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_nop
#undef ___PH_LBL0
#define ___PH_LBL0 179
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_nop)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_nop)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_nop)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_nop)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_nop)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_nop)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_nop)
   ___SET_R0(___LBL(2))
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(21),___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_nop)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___FIX(0L))
   ___SET_R2(___R1)
   ___SET_R3(___FIX(0L))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___STK(-5))
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_nop)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_li
#undef ___PH_LBL0
#define ___PH_LBL0 184
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L25___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L26___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L27___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L28___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L29___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L30___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L31___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L32___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L33___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L34___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L35___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L36___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L37___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L38___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L39___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L40___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L41___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L42___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L43___riscv_23_riscv_2d_li)
___DEF_P_HLBL(___L44___riscv_23_riscv_2d_li)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_li)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_li)
   ___GOTO(___L45___riscv_23_riscv_2d_li)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_li)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(42))
___DEF_GLBL(___L45___riscv_23_riscv_2d_li)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R3)
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_li)
   ___SET_STK(-4,___R1)
   ___SET_R2(___FIX(2048L))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),115,___G__2b_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_li)
   ___SET_R2(___FIX(4095L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),133,___G_bitwise_2d_and)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_li)
   ___SET_R2(___FIX(2048L))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),116,___G__2d_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_li)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(2048L))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),115,___G__2b_)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_li)
   ___SET_R2(___FIX(-12L))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),132,___G_arithmetic_2d_shift)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_li)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R2(___BIGFIX(48,-2147483648LL))
   ___SET_R0(___LBL(9))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G__3e__3d_)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_li)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L46___riscv_23_riscv_2d_li)
   ___END_IF
   ___SET_R1(___STK(-8))
   ___SET_R2(___BIGFIX(49,2147483647LL))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),117,___G__3c__3d_)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_li)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L50___riscv_23_riscv_2d_li)
   ___END_IF
___DEF_GLBL(___L46___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_li)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L47___riscv_23_riscv_2d_li)
   ___END_IF
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_li)
___DEF_GLBL(___L47___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),128,___G___asm_23_asm_2d_unsigned_2d_lo64)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),139,___G_first_2d_bit_2d_set)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_li)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(12L))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),115,___G__2b_)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_li)
   ___SET_STK(-8,___R1)
   ___SET_R2(___FIX(12L))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),116,___G__2d_)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),116,___G__2d_)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_li)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),132,___G_arithmetic_2d_shift)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_li)
   ___SET_R2(___STK(-4))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),132,___G_arithmetic_2d_shift)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),127,___G___asm_23_asm_2d_signed_2d_lo64)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_li)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(22))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),116,___G__2d_)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_li)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),132,___G_arithmetic_2d_shift)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(1))
   ___SET_NARGS(1) ___GOTO(___L25___riscv_23_riscv_2d_li)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_li)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L49___riscv_23_riscv_2d_li)
   ___END_IF
   ___SET_R1(___STK(-9))
___DEF_GLBL(___L48___riscv_23_riscv_2d_li)
   ___SET_STK(-8,___STK(-11))
   ___SET_STK(-11,___STK(-10))
   ___SET_STK(-10,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(27))
   ___SET_NARGS(1) ___GOTO(___L25___riscv_23_riscv_2d_li)
___DEF_SLBL(25,___L25___riscv_23_riscv_2d_li)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(25,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(26)
___DEF_SLBL(26,___L26___riscv_23_riscv_2d_li)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_GLBL(___L49___riscv_23_riscv_2d_li)
   ___SET_R1(___FIX(0L))
   ___GOTO(___L48___riscv_23_riscv_2d_li)
___DEF_SLBL(27,___L27___riscv_23_riscv_2d_li)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-10))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-8))
   ___POLL(28)
___DEF_SLBL(28,___L28___riscv_23_riscv_2d_li)
   ___ADJFP(-11)
   ___JUMPGENNOTSAFE(___SET_NARGS(4),___STK(5))
___DEF_GLBL(___L50___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1048575L))
   ___SET_R0(___LBL(29))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),133,___G_bitwise_2d_and)
___DEF_SLBL(29,___L29___riscv_23_riscv_2d_li)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),168,___G_zero_3f_)
___DEF_SLBL(30,___L30___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(31,___L31___riscv_23_riscv_2d_li)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L51___riscv_23_riscv_2d_li)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(12L))
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),132,___G_arithmetic_2d_shift)
___DEF_SLBL(32,___L32___riscv_23_riscv_2d_li)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_U)
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(33,___L33___riscv_23_riscv_2d_li)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(34))
   ___JUMPINT(___SET_NARGS(3),___PRC(745),___L___riscv_23_riscv_2d_lui)
___DEF_SLBL(34,___L34___riscv_23_riscv_2d_li)
___DEF_GLBL(___L51___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),168,___G_zero_3f_)
___DEF_SLBL(35,___L35___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(36))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(36,___L36___riscv_23_riscv_2d_li)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L52___riscv_23_riscv_2d_li)
   ___END_IF
   ___GOTO(___L57___riscv_23_riscv_2d_li)
___DEF_SLBL(37,___L37___riscv_23_riscv_2d_li)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L55___riscv_23_riscv_2d_li)
   ___END_IF
___DEF_GLBL(___L52___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(38))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(38,___L38___riscv_23_riscv_2d_li)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L53___riscv_23_riscv_2d_li)
   ___END_IF
   ___SET_R1(___PRC(525))
   ___GOTO(___L54___riscv_23_riscv_2d_li)
___DEF_GLBL(___L53___riscv_23_riscv_2d_li)
   ___SET_R1(___PRC(456))
___DEF_GLBL(___L54___riscv_23_riscv_2d_li)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(24))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),168,___G_zero_3f_)
___DEF_SLBL(39,___L39___riscv_23_riscv_2d_li)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L56___riscv_23_riscv_2d_li)
   ___END_IF
___DEF_GLBL(___L55___riscv_23_riscv_2d_li)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L56___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(40))
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(21),___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_SLBL(40,___L40___riscv_23_riscv_2d_li)
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___STK(-4))
   ___POLL(41)
___DEF_SLBL(41,___L41___riscv_23_riscv_2d_li)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L57___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(37))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),168,___G_zero_3f_)
___DEF_SLBL(42,___L42___riscv_23_riscv_2d_li)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(43))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(474),___L___riscv_23_riscv_2d_slli)
___DEF_SLBL(43,___L43___riscv_23_riscv_2d_li)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(44))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),168,___G_zero_3f_)
___DEF_SLBL(44,___L44___riscv_23_riscv_2d_li)
   ___SET_R0(___LBL(39))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_mv
#undef ___PH_LBL0
#define ___PH_LBL0 230
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_mv)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_mv)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_mv)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_mv)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_mv)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_mv)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_mv)
   ___SET_R0(___LBL(2))
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(21),___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_mv)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___FIX(0L))
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_mv)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_not
#undef ___PH_LBL0
#define ___PH_LBL0 235
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_not)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_not)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_not)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_not)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_not)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_not)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIX(-1L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_not)
   ___SET_R0(___LBL(2))
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(21),___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_not)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___FIX(16384L))
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_not)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_neg
#undef ___PH_LBL0
#define ___PH_LBL0 240
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_neg)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_neg)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_neg)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_neg)
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_neg)
   ___JUMPINT(___SET_NARGS(4),___PRC(353),___L___riscv_23_riscv_2d_sub)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_negw
#undef ___PH_LBL0
#define ___PH_LBL0 243
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_negw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_negw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_negw)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_negw)
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___SET_R2(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_negw)
   ___JUMPINT(___SET_NARGS(4),___PRC(387),___L___riscv_23_riscv_2d_subw)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sext_2e_w
#undef ___PH_LBL0
#define ___PH_LBL0 246
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sext_2e_w)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sext_2e_w)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_sext_2e_w)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_sext_2e_w)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_sext_2e_w)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_sext_2e_w)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sext_2e_w)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sext_2e_w)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sext_2e_w)
   ___SET_R0(___LBL(4))
   ___SET_NARGS(1) ___GOTO(___L2___riscv_23_riscv_2d_sext_2e_w)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_sext_2e_w)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(2,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_sext_2e_w)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_sext_2e_w)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_sext_2e_w)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(525),___L___riscv_23_riscv_2d_addiw)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_seqz
#undef ___PH_LBL0
#define ___PH_LBL0 253
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_seqz)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_seqz)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_seqz)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_seqz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_seqz)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_seqz)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___FIX(1L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_seqz)
   ___SET_R0(___LBL(2))
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(21),___L0___riscv_23_riscv_2d_imm_2d_int)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_seqz)
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___FIX(12288L))
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_seqz)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_snez
#undef ___PH_LBL0
#define ___PH_LBL0 258
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_snez)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_snez)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_snez)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_snez)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(12288L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_snez)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sltz
#undef ___PH_LBL0
#define ___PH_LBL0 261
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sltz)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sltz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sltz)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sltz)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(8192L))
   ___SET_R2(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sltz)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sgtz
#undef ___PH_LBL0
#define ___PH_LBL0 264
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sgtz)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sgtz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sgtz)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sgtz)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(8192L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sgtz)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_beqz
#undef ___PH_LBL0
#define ___PH_LBL0 267
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_beqz)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_beqz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_beqz)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_beqz)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(0L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_beqz)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bnez
#undef ___PH_LBL0
#define ___PH_LBL0 270
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bnez)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bnez)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bnez)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bnez)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(4096L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bnez)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_blez
#undef ___PH_LBL0
#define ___PH_LBL0 273
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_blez)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_blez)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_blez)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_blez)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___FIX(0L))
   ___SET_STK(3,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(3))
   ___SET_R3(___FIX(20480L))
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_blez)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bgez
#undef ___PH_LBL0
#define ___PH_LBL0 276
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bgez)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bgez)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bgez)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bgez)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(20480L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bgez)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bltz
#undef ___PH_LBL0
#define ___PH_LBL0 279
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bltz)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bltz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bltz)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bltz)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(16384L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bltz)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bgtz
#undef ___PH_LBL0
#define ___PH_LBL0 282
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bgtz)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bgtz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bgtz)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bgtz)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___FIX(0L))
   ___SET_STK(3,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(3))
   ___SET_R3(___FIX(16384L))
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bgtz)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bgt
#undef ___PH_LBL0
#define ___PH_LBL0 285
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bgt)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bgt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bgt)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bgt)
   ___SET_STK(1,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(16384L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bgt)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ble
#undef ___PH_LBL0
#define ___PH_LBL0 288
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ble)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ble)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ble)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ble)
   ___SET_STK(1,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(20480L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ble)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bgtu
#undef ___PH_LBL0
#define ___PH_LBL0 291
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bgtu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bgtu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bgtu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bgtu)
   ___SET_STK(1,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(24576L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bgtu)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bleu
#undef ___PH_LBL0
#define ___PH_LBL0 294
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bleu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bleu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bleu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bleu)
   ___SET_STK(1,___R2)
   ___SET_R2(___R3)
   ___SET_R3(___FIX(28672L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bleu)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_j
#undef ___PH_LBL0
#define ___PH_LBL0 297
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_j)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_j)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_j)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_j)
   ___SET_R3(___R2)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_j)
   ___JUMPINT(___SET_NARGS(3),___PRC(773),___L___riscv_23_riscv_2d_jal)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_jal_2a_
#undef ___PH_LBL0
#define ___PH_LBL0 300
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_jal_2a_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_jal_2a_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_jal_2a_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_jal_2a_)
   ___SET_R3(___R2)
   ___SET_R2(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_jal_2a_)
   ___JUMPINT(___SET_NARGS(3),___PRC(773),___L___riscv_23_riscv_2d_jal)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_jr
#undef ___PH_LBL0
#define ___PH_LBL0 303
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_jr)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_jr)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_jr)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_jr)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_jr)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_jr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_jr)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_jr)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_R1(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_jr)
   ___SET_R0(___LBL(4))
   ___SET_NARGS(1) ___GOTO(___L2___riscv_23_riscv_2d_jr)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_jr)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(2,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_jr)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_jr)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_jr)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(435),___L___riscv_23_riscv_2d_jalr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_jalr_2a_
#undef ___PH_LBL0
#define ___PH_LBL0 310
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_jalr_2a_)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_jalr_2a_)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_jalr_2a_)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_jalr_2a_)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_jalr_2a_)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_jalr_2a_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_jalr_2a_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_jalr_2a_)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R2)
   ___SET_R1(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_jalr_2a_)
   ___SET_R0(___LBL(4))
   ___SET_NARGS(1) ___GOTO(___L2___riscv_23_riscv_2d_jalr_2a_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_jalr_2a_)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(2,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_jalr_2a_)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_jalr_2a_)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___FIX(1L))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_jalr_2a_)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(435),___L___riscv_23_riscv_2d_jalr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ret
#undef ___PH_LBL0
#define ___PH_LBL0 317
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ret)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ret)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_ret)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_ret)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_ret)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_ret)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ret)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ret)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R1(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ret)
   ___SET_R0(___LBL(4))
   ___SET_NARGS(1) ___GOTO(___L2___riscv_23_riscv_2d_ret)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_ret)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(2,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(3)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_ret)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_ret)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(1L))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___STK(-6))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_ret)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(435),___L___riscv_23_riscv_2d_jalr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_call
#undef ___PH_LBL0
#define ___PH_LBL0 324
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_call)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_call)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_call)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_call)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_call)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_call)
   ___SET_R2(___BIGFIX(51,4294963200LL))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_call)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_U)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_call)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(6L))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(3),___PRC(751),___L___riscv_23_riscv_2d_auipc)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_call)
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_call)
   ___SET_R2(___FIX(4095L))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_call)
   ___SET_R0(___LBL(10))
   ___SET_NARGS(1) ___GOTO(___L8___riscv_23_riscv_2d_call)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_call)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(8,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(9)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_call)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_call)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(6L))
   ___SET_R1(___FIX(1L))
   ___SET_R0(___STK(-4))
   ___POLL(11)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_call)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(435),___L___riscv_23_riscv_2d_jalr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_tail
#undef ___PH_LBL0
#define ___PH_LBL0 337
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_tail)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_tail)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_tail)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_tail)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_tail)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_tail)
   ___SET_R2(___BIGFIX(51,4294963200LL))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_tail)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_U)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_tail)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(6L))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(3),___PRC(751),___L___riscv_23_riscv_2d_auipc)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_tail)
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_tail)
   ___SET_R2(___FIX(4095L))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_tail)
   ___SET_R0(___LBL(10))
   ___SET_NARGS(1) ___GOTO(___L8___riscv_23_riscv_2d_tail)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_tail)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(8,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(9)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_tail)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_tail)
   ___SET_R3(___R1)
   ___SET_R2(___FIX(6L))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___STK(-4))
   ___POLL(11)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_tail)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(435),___L___riscv_23_riscv_2d_jalr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_add
#undef ___PH_LBL0
#define ___PH_LBL0 350
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_add)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_add)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_add)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_add)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_add)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sub
#undef ___PH_LBL0
#define ___PH_LBL0 353
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sub)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sub)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sub)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sub)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R3(___BIGFIX(52,1073741824LL))
   ___SET_R2(___FIX(51L))
   ___SET_R1(___FIX(0L))
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sub)
   ___SET_NARGS(7) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sll
#undef ___PH_LBL0
#define ___PH_LBL0 356
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sll)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sll)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sll)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sll)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(4096L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sll)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_slt
#undef ___PH_LBL0
#define ___PH_LBL0 359
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_slt)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_slt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_slt)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_slt)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(8192L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_slt)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sltu
#undef ___PH_LBL0
#define ___PH_LBL0 362
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sltu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sltu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sltu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sltu)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(12288L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sltu)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_xor
#undef ___PH_LBL0
#define ___PH_LBL0 365
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_xor)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_xor)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_xor)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_xor)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(16384L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_xor)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_srl
#undef ___PH_LBL0
#define ___PH_LBL0 368
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_srl)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_srl)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_srl)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_srl)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(20480L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_srl)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sra
#undef ___PH_LBL0
#define ___PH_LBL0 371
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sra)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sra)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sra)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sra)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R3(___BIGFIX(52,1073741824LL))
   ___SET_R2(___FIX(51L))
   ___SET_R1(___FIX(20480L))
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sra)
   ___SET_NARGS(7) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_or
#undef ___PH_LBL0
#define ___PH_LBL0 374
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_or)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_or)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_or)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_or)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(24576L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_or)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_and
#undef ___PH_LBL0
#define ___PH_LBL0 377
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_and)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_and)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_and)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_and)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(28672L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_and)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_addw
#undef ___PH_LBL0
#define ___PH_LBL0 380
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_addw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_addw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_addw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_addw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_addw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_addw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_addw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_addw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_addw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_addw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_addw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_addw)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_addw)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_addw)
___DEF_GLBL(___L6___riscv_23_riscv_2d_addw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FIX(59L))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_addw)
   ___ADJFP(-5)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L7___riscv_23_riscv_2d_addw)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_subw
#undef ___PH_LBL0
#define ___PH_LBL0 387
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_subw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_subw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_subw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_subw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_subw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_subw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_subw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_subw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_subw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_subw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_subw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_subw)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_subw)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_subw)
___DEF_GLBL(___L6___riscv_23_riscv_2d_subw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_STK(-4,___STK(-3))
   ___SET_R3(___BIGFIX(52,1073741824LL))
   ___SET_R2(___FIX(59L))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_subw)
   ___ADJFP(-4)
   ___SET_NARGS(7) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L7___riscv_23_riscv_2d_subw)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sllw
#undef ___PH_LBL0
#define ___PH_LBL0 394
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sllw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sllw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_sllw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_sllw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_sllw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_sllw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sllw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sllw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sllw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_sllw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_sllw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_sllw)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_sllw)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_sllw)
___DEF_GLBL(___L6___riscv_23_riscv_2d_sllw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FIX(59L))
   ___SET_R2(___FIX(4096L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_sllw)
   ___ADJFP(-5)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L7___riscv_23_riscv_2d_sllw)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_srlw
#undef ___PH_LBL0
#define ___PH_LBL0 401
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_srlw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_srlw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_srlw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_srlw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_srlw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_srlw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_srlw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_srlw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_srlw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_srlw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_srlw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_srlw)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_srlw)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_srlw)
___DEF_GLBL(___L6___riscv_23_riscv_2d_srlw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FIX(59L))
   ___SET_R2(___FIX(20480L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_srlw)
   ___ADJFP(-5)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L7___riscv_23_riscv_2d_srlw)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sraw
#undef ___PH_LBL0
#define ___PH_LBL0 408
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sraw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sraw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_sraw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_sraw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_sraw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_sraw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sraw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sraw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sraw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_sraw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_sraw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_sraw)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_sraw)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_sraw)
___DEF_GLBL(___L6___riscv_23_riscv_2d_sraw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_STK(-4,___STK(-3))
   ___SET_R3(___BIGFIX(52,1073741824LL))
   ___SET_R2(___FIX(59L))
   ___SET_R1(___FIX(20480L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_sraw)
   ___ADJFP(-4)
   ___SET_NARGS(7) ___JUMPINT(___NOTHING,___PRC(415),___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L7___riscv_23_riscv_2d_sraw)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_type_2d_r
#undef ___PH_LBL0
#define ___PH_LBL0 415
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_type_2d_r)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_type_2d_r)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_type_2d_r)
   ___IF_NARGS_EQ(5,___PUSH(___R1) ___PUSH(___R2) ___SET_R1(___R3) ___SET_R2(___FIX(51L)
) ___SET_R3(___FIX(0L)))
   ___IF_NARGS_EQ(6,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FIX(0L)
))
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,5,2,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_type_2d_r)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_type_2d_r)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L26___riscv_23_riscv_2d_type_2d_r)
   ___END_IF
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_type_2d_r)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L26___riscv_23_riscv_2d_type_2d_r)
   ___END_IF
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_type_2d_r)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_type_2d_r)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L25___riscv_23_riscv_2d_type_2d_r)
   ___END_IF
   ___GOTO(___L19___riscv_23_riscv_2d_type_2d_r)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L19___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(1,___STK(-5))
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(7L))
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___STK(-10))
   ___SET_R1(___STK(-13))
   ___SET_R2(___FIX(15L))
   ___SET_R0(___LBL(8))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(-11,___R1)
   ___SET_R1(___STK(-16))
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_type_2d_r)
   ___SET_R2(___R1)
   ___SET_R3(___STK(-12))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(10))
   ___ADJFP(-5)
   ___JUMPGLONOTSAFE(___SET_NARGS(6),141,___G_fx_2b_)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_type_2d_r)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_type_2d_r)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_type_2d_r)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L24___riscv_23_riscv_2d_type_2d_r)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_type_2d_r)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L20___riscv_23_riscv_2d_type_2d_r)
   ___END_IF
   ___SET_R1(___SUB(53))
   ___GOTO(___L21___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L20___riscv_23_riscv_2d_type_2d_r)
   ___SET_R1(___SUB(62))
___DEF_GLBL(___L21___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(-12L))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_type_2d_r)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(59L))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_type_2d_r)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L22___riscv_23_riscv_2d_type_2d_r)
   ___END_IF
   ___SET_R2(___SUB(71))
   ___GOTO(___L23___riscv_23_riscv_2d_type_2d_r)
___DEF_GLBL(___L22___riscv_23_riscv_2d_type_2d_r)
   ___SET_R2(___SUB(72))
___DEF_GLBL(___L23___riscv_23_riscv_2d_type_2d_r)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),154,___G_list)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_type_2d_r)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___R1)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-3))
   ___POLL(18)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_type_2d_r)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L24___riscv_23_riscv_2d_type_2d_r)
   ___SET_R1(___VOID)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___DEF_GLBL(___L25___riscv_23_riscv_2d_type_2d_r)
   ___SET_R1(___SUB(73))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L26___riscv_23_riscv_2d_type_2d_r)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_jalr
#undef ___PH_LBL0
#define ___PH_LBL0 435
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_jalr)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_jalr)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_jalr)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_jalr)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_jalr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_jalr)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_jalr)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(8,___STK(0))
   ___SET_STK(9,___R1)
   ___SET_STK(10,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(103L))
   ___SET_R2(___FIX(0L))
   ___ADJFP(10)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_jalr)
   ___SET_R0(___LBL(2))
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_jalr)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_jalr)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_jalr)
   ___END_IF
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___SUB(74))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-2))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_jalr)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_jalr)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lb
#undef ___PH_LBL0
#define ___PH_LBL0 441
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lb)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lb)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lb)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lb)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lb)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lh
#undef ___PH_LBL0
#define ___PH_LBL0 444
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lh)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lh)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lh)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lh)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(4096L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lh)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lw
#undef ___PH_LBL0
#define ___PH_LBL0 447
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lw)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(8192L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lw)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lbu
#undef ___PH_LBL0
#define ___PH_LBL0 450
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lbu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lbu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lbu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lbu)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(16384L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lbu)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lhu
#undef ___PH_LBL0
#define ___PH_LBL0 453
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lhu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lhu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lhu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lhu)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R1(___R3)
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(20480L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lhu)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_addi
#undef ___PH_LBL0
#define ___PH_LBL0 456
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_addi)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_addi)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_addi)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_addi)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_addi)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_slti
#undef ___PH_LBL0
#define ___PH_LBL0 459
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_slti)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_slti)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_slti)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_slti)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(8192L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_slti)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sltiu
#undef ___PH_LBL0
#define ___PH_LBL0 462
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sltiu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sltiu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sltiu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sltiu)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(12288L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sltiu)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_xori
#undef ___PH_LBL0
#define ___PH_LBL0 465
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_xori)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_xori)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_xori)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_xori)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(16384L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_xori)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ori
#undef ___PH_LBL0
#define ___PH_LBL0 468
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ori)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ori)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ori)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ori)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(24576L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ori)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_andi
#undef ___PH_LBL0
#define ___PH_LBL0 471
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_andi)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_andi)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_andi)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_andi)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(28672L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_andi)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_slli
#undef ___PH_LBL0
#define ___PH_LBL0 474
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_slli)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_slli)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_slli)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_slli)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_slli)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_slli)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L13___riscv_23_riscv_2d_slli)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(14),___L___riscv_23_riscv_2d_word_2d_width)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_slli)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_slli)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_slli)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L12___riscv_23_riscv_2d_slli)
   ___END_IF
   ___GOTO(___L11___riscv_23_riscv_2d_slli)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_slli)
___DEF_GLBL(___L11___riscv_23_riscv_2d_slli)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(9))
   ___ADJFP(4)
   ___SET_NARGS(1) ___GOTO(___L7___riscv_23_riscv_2d_slli)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_slli)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(7,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(8)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_slli)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_slli)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R3(___FIX(4096L))
   ___SET_R0(___STK(-6))
   ___POLL(10)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_slli)
   ___ADJFP(-10)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L12___riscv_23_riscv_2d_slli)
   ___SET_R1(___SUB(75))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L13___riscv_23_riscv_2d_slli)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_srli
#undef ___PH_LBL0
#define ___PH_LBL0 486
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_srli)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_srli)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_srli)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_srli)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_srli)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_srli)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L13___riscv_23_riscv_2d_srli)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(14),___L___riscv_23_riscv_2d_word_2d_width)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_srli)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_srli)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_srli)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L12___riscv_23_riscv_2d_srli)
   ___END_IF
   ___GOTO(___L11___riscv_23_riscv_2d_srli)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_srli)
___DEF_GLBL(___L11___riscv_23_riscv_2d_srli)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(9))
   ___ADJFP(4)
   ___SET_NARGS(1) ___GOTO(___L7___riscv_23_riscv_2d_srli)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_srli)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(7,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(8)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_srli)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_srli)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R3(___FIX(20480L))
   ___SET_R0(___STK(-6))
   ___POLL(10)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_srli)
   ___ADJFP(-10)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L12___riscv_23_riscv_2d_srli)
   ___SET_R1(___SUB(76))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L13___riscv_23_riscv_2d_srli)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_srai
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
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_srai)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_srai)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_srai)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_srai)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R2(___FIX(0L))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_srai)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_srai)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L14___riscv_23_riscv_2d_srai)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(14),___L___riscv_23_riscv_2d_word_2d_width)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_srai)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_srai)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_srai)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L13___riscv_23_riscv_2d_srai)
   ___END_IF
   ___GOTO(___L12___riscv_23_riscv_2d_srai)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_srai)
___DEF_GLBL(___L12___riscv_23_riscv_2d_srai)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___STK(-3))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(7))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_srai)
   ___SET_R0(___LBL(10))
   ___SET_NARGS(1) ___GOTO(___L8___riscv_23_riscv_2d_srai)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_srai)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(8,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(9)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_srai)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_srai)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-8))
   ___SET_R3(___FIX(20480L))
   ___SET_R0(___STK(-6))
   ___POLL(11)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_srai)
   ___ADJFP(-10)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L13___riscv_23_riscv_2d_srai)
   ___SET_R1(___SUB(77))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L14___riscv_23_riscv_2d_srai)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lwu
#undef ___PH_LBL0
#define ___PH_LBL0 511
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lwu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lwu)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_lwu)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_lwu)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_lwu)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_lwu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lwu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lwu)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lwu)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_lwu)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_lwu)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_lwu)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_lwu)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_lwu)
___DEF_GLBL(___L6___riscv_23_riscv_2d_lwu)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(24576L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_lwu)
   ___ADJFP(-5)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L7___riscv_23_riscv_2d_lwu)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ld
#undef ___PH_LBL0
#define ___PH_LBL0 518
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ld)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ld)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_ld)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_ld)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_ld)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_ld)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ld)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ld)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ld)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_ld)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_ld)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_ld)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_ld)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_ld)
___DEF_GLBL(___L6___riscv_23_riscv_2d_ld)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FIX(3L))
   ___SET_R2(___FIX(12288L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_ld)
   ___ADJFP(-5)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L7___riscv_23_riscv_2d_ld)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_addiw
#undef ___PH_LBL0
#define ___PH_LBL0 525
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_addiw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_addiw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_addiw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_addiw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_addiw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_addiw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_addiw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_addiw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_addiw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_addiw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_addiw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_addiw)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_addiw)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_addiw)
___DEF_GLBL(___L6___riscv_23_riscv_2d_addiw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R3(___FIX(27L))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_addiw)
   ___ADJFP(-5)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L7___riscv_23_riscv_2d_addiw)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_slliw
#undef ___PH_LBL0
#define ___PH_LBL0 532
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_slliw)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_slliw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_slliw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_slliw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_slliw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_slliw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_slliw)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L13___riscv_23_riscv_2d_slliw)
   ___END_IF
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_slliw)
___DEF_GLBL(___L13___riscv_23_riscv_2d_slliw)
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_slliw)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L16___riscv_23_riscv_2d_slliw)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(32L))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_slliw)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_slliw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L15___riscv_23_riscv_2d_slliw)
   ___END_IF
   ___GOTO(___L14___riscv_23_riscv_2d_slliw)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_slliw)
___DEF_GLBL(___L14___riscv_23_riscv_2d_slliw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(11))
   ___ADJFP(4)
   ___SET_NARGS(1) ___GOTO(___L9___riscv_23_riscv_2d_slliw)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_slliw)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(9,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(10)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_slliw)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_slliw)
   ___SET_R3(___FIX(27L))
   ___SET_R2(___FIX(4096L))
   ___SET_R0(___STK(-6))
   ___POLL(12)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_slliw)
   ___ADJFP(-9)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L15___riscv_23_riscv_2d_slliw)
   ___SET_R1(___SUB(78))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L16___riscv_23_riscv_2d_slliw)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_srliw
#undef ___PH_LBL0
#define ___PH_LBL0 546
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_srliw)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_srliw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_srliw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_srliw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_srliw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_srliw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_srliw)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L13___riscv_23_riscv_2d_srliw)
   ___END_IF
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_srliw)
___DEF_GLBL(___L13___riscv_23_riscv_2d_srliw)
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_srliw)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L16___riscv_23_riscv_2d_srliw)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(32L))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_srliw)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_srliw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L15___riscv_23_riscv_2d_srliw)
   ___END_IF
   ___GOTO(___L14___riscv_23_riscv_2d_srliw)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_srliw)
___DEF_GLBL(___L14___riscv_23_riscv_2d_srliw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(11))
   ___ADJFP(4)
   ___SET_NARGS(1) ___GOTO(___L9___riscv_23_riscv_2d_srliw)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_srliw)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(9,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(10)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_srliw)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_srliw)
   ___SET_R3(___FIX(27L))
   ___SET_R2(___FIX(20480L))
   ___SET_R0(___STK(-6))
   ___POLL(12)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_srliw)
   ___ADJFP(-9)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L15___riscv_23_riscv_2d_srliw)
   ___SET_R1(___SUB(79))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L16___riscv_23_riscv_2d_srliw)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sraiw
#undef ___PH_LBL0
#define ___PH_LBL0 560
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_sraiw)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_sraiw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sraiw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sraiw)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sraiw)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_sraiw)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_sraiw)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L14___riscv_23_riscv_2d_sraiw)
   ___END_IF
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_sraiw)
___DEF_GLBL(___L14___riscv_23_riscv_2d_sraiw)
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_sraiw)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L17___riscv_23_riscv_2d_sraiw)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R2(___FIX(32L))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_sraiw)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_sraiw)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L16___riscv_23_riscv_2d_sraiw)
   ___END_IF
   ___GOTO(___L15___riscv_23_riscv_2d_sraiw)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_sraiw)
___DEF_GLBL(___L15___riscv_23_riscv_2d_sraiw)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_R2(___STK(-3))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(9))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_sraiw)
   ___SET_R0(___LBL(12))
   ___SET_NARGS(1) ___GOTO(___L10___riscv_23_riscv_2d_sraiw)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_sraiw)
   ___IF_NARGS_EQ(1,___SET_R2(___SYM_I))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(10,1,1,0)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(11)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_sraiw)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_sraiw)
   ___SET_R3(___FIX(27L))
   ___SET_R2(___FIX(20480L))
   ___SET_R0(___STK(-6))
   ___POLL(13)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_sraiw)
   ___ADJFP(-9)
   ___SET_NARGS(6) ___JUMPINT(___NOTHING,___PRC(575),___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L16___riscv_23_riscv_2d_sraiw)
   ___SET_R1(___SUB(80))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L17___riscv_23_riscv_2d_sraiw)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_type_2d_i
#undef ___PH_LBL0
#define ___PH_LBL0 575
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L25___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L26___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L27___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L28___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L29___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L30___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L31___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L32___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L33___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L34___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L35___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L36___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L37___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L38___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L39___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L40___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L41___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L42___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L43___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L44___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L45___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L46___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L47___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L48___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L49___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L50___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L51___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L52___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L53___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L54___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L55___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L56___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L57___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L58___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L59___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L60___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L61___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L62___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L63___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L64___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L65___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L66___riscv_23_riscv_2d_type_2d_i)
___DEF_P_HLBL(___L67___riscv_23_riscv_2d_type_2d_i)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_type_2d_i)
   ___IF_NARGS_EQ(5,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FIX(19L)
))
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,5,1,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-1))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L94___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L94___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L68___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___SUB(81))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L68___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L93___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___SYM_I)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L92___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___GOTO(___L69___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L69___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(1,___STK(-5))
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(7L))
   ___SET_R0(___LBL(12))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-13))
   ___SET_R2(___FIX(15L))
   ___SET_R0(___LBL(13))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-12,___R1)
   ___SET_R1(___STK(-15))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(1),___PRC(55),___L___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_type_2d_i)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-14))
   ___SET_R2(___STK(-12))
   ___SET_R0(___LBL(15))
   ___ADJFP(-6)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),141,___G_fx_2b_)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L89___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(3L))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L91___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(19L))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L70___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___GOTO(___L90___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L89___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
___DEF_GLBL(___L70___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(1,___SUB(82))
   ___SET_STK(2,___SUB(83))
   ___SET_STK(3,___SUB(84))
   ___SET_STK(4,___SUB(85))
   ___SET_STK(5,___SUB(86))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(21))
   ___ADJFP(8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(30L))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),150,___G_fxbit_2d_set_3f_)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L71___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___SUB(87))
   ___GOTO(___L72___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L71___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___SUB(88))
___DEF_GLBL(___L72___riscv_23_riscv_2d_type_2d_i)
   ___SET_R3(___SUB(89))
   ___SET_R2(___SUB(90))
   ___SET_R0(___LBL(23))
   ___ADJFP(-3)
   ___JUMPGLONOTSAFE(___SET_NARGS(8),164,___G_vector)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(-12L))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(25))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(25,___L25___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(27L))
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(26,___L26___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L73___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R2(___SUB(91))
   ___GOTO(___L74___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L73___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___SUB(92))
___DEF_GLBL(___L74___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),154,___G_list)
___DEF_SLBL(27,___L27___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-4,___STK(-10))
   ___SET_STK(-10,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(4096L))
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_SLBL(28,___L28___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L75___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___GOTO(___L88___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(29,___L29___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L78___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
___DEF_GLBL(___L75___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),129,___G___codegen_23_codegen_2d_context_2d_arch)
___DEF_SLBL(30,___L30___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___SYM_RV64I)
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___DEF_SLBL(31,___L31___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L87___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___GOTO(___L76___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(32,___L32___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L86___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
___DEF_GLBL(___L76___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___FIX(31L))
___DEF_GLBL(___L77___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(33,___L33___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___FIX(-20L))
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(34,___L34___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),148,___G_fxand)
___DEF_SLBL(35,___L35___riscv_23_riscv_2d_type_2d_i)
   ___GOTO(___L79___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L78___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-7))
___DEF_GLBL(___L79___riscv_23_riscv_2d_type_2d_i)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-9))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-8))
   ___POLL(36)
___DEF_SLBL(36,___L36___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-10)
   ___SET_NARGS(5) ___GOTO(___L37___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(37,___L37___riscv_23_riscv_2d_type_2d_i)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(37,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___LBL(46))
   ___ADJFP(8)
   ___POLL(38)
___DEF_SLBL(38,___L38___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(39))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),156,___G_map)
___DEF_SLBL(39,___L39___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___SUB(39))
   ___SET_R0(___LBL(40))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),126,___G___asm_23_asm_2d_separated_2d_list)
___DEF_SLBL(40,___L40___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(41))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(41,___L41___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L81___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___NUL)
   ___GOTO(___L80___riscv_23_riscv_2d_type_2d_i)
___DEF_SLBL(42,___L42___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L80___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(43))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(43,___L43___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___CHR(9))
   ___SET_R0(___LBL(44))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(44,___L44___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(45)
___DEF_SLBL(45,___L45___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),125,___G___asm_23_asm_2d_listing)
___DEF_GLBL(___L81___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___STK(-4))
   ___SET_R1(___CHR(9))
   ___SET_R0(___LBL(42))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(46,___L46___riscv_23_riscv_2d_type_2d_i)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(46,1,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(47)
___DEF_SLBL(47,___L47___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(48))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(48,___L48___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L82___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(49)
___DEF_SLBL(49,___L49___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_GLBL(___L82___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(50))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(50,___L50___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L85___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(51))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(51,___L51___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L83___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(52))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(52,___L52___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(53))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),163,___G_symbol_3f_)
___DEF_SLBL(53,___L53___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L83___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(54))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(54,___L54___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(55))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),159,___G_number_3f_)
___DEF_SLBL(55,___L55___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L83___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(56)
___DEF_SLBL(56,___L56___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_GLBL(___L83___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(57))
   ___JUMPINT(___SET_NARGS(1),___PRC(41),___L___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_SLBL(57,___L57___riscv_23_riscv_2d_type_2d_i)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L84___riscv_23_riscv_2d_type_2d_i)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(40))
   ___SET_R0(___STK(-7))
   ___POLL(58)
___DEF_SLBL(58,___L58___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),138,___G_error)
___DEF_GLBL(___L84___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(59))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(59,___L59___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___STK(-3))
   ___POLL(60)
___DEF_SLBL(60,___L60___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G___asm_23_asm_2d_label_2d_name)
___DEF_GLBL(___L85___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-6))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L86___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___FIX(63L))
   ___GOTO(___L77___riscv_23_riscv_2d_type_2d_i)
___DEF_GLBL(___L87___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(19L))
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_GLBL(___L88___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(20480L))
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_GLBL(___L89___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___VOID)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___DEF_GLBL(___L90___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(27L))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_fx_3d_)
___DEF_GLBL(___L91___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(-12L))
   ___SET_R0(___LBL(61))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(61,___L61___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(93))
   ___SET_R0(___LBL(62))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(62,___L62___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(63))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(63,___L63___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(64))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),158,___G_number_2d__3e_string)
___DEF_SLBL(64,___L64___riscv_23_riscv_2d_type_2d_i)
   ___SET_STK(1,___R1)
   ___SET_R2(___STK(-9))
   ___SET_R1(___SUB(0))
   ___SET_R0(___LBL(65))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(65,___L65___riscv_23_riscv_2d_type_2d_i)
   ___SET_R2(___R1)
   ___SET_R3(___SUB(101))
   ___SET_R1(___SUB(102))
   ___SET_R0(___LBL(66))
   ___ADJFP(-3)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),162,___G_string_2d_append)
___DEF_SLBL(66,___L66___riscv_23_riscv_2d_type_2d_i)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-10))
   ___SET_R0(___STK(-8))
   ___SET_R1(___STK(-6))
   ___POLL(67)
___DEF_SLBL(67,___L67___riscv_23_riscv_2d_type_2d_i)
   ___ADJFP(-11)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L92___riscv_23_riscv_2d_type_2d_i)
   ___SET_R1(___SUB(103))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L93___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_GLBL(___L94___riscv_23_riscv_2d_type_2d_i)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sb
#undef ___PH_LBL0
#define ___PH_LBL0 644
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sb)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sb)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sb)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sb)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sb)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(660),___L0___riscv_23_riscv_2d_type_2d_s)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sh
#undef ___PH_LBL0
#define ___PH_LBL0 647
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sh)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sh)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sh)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sh)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(4096L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sh)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(660),___L0___riscv_23_riscv_2d_type_2d_s)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sw
#undef ___PH_LBL0
#define ___PH_LBL0 650
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sw)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sw)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sw)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sw)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(8192L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sw)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(660),___L0___riscv_23_riscv_2d_type_2d_s)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_sd
#undef ___PH_LBL0
#define ___PH_LBL0 653
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_sd)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_sd)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_sd)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_sd)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_sd)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_sd)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_sd)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_sd)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_sd)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(9),___L___riscv_23_riscv_2d_64bit_2d_mode_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_sd)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_sd)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7___riscv_23_riscv_2d_sd)
   ___END_IF
   ___GOTO(___L6___riscv_23_riscv_2d_sd)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_sd)
___DEF_GLBL(___L6___riscv_23_riscv_2d_sd)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R3(___FIX(12288L))
   ___SET_R0(___STK(-2))
   ___POLL(5)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_sd)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(660),___L0___riscv_23_riscv_2d_type_2d_s)
___DEF_GLBL(___L7___riscv_23_riscv_2d_sd)
   ___SET_R1(___SUB(50))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_type_2d_s
#undef ___PH_LBL0
#define ___PH_LBL0 660
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_type_2d_s)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_type_2d_s)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_type_2d_s)
   ___IF_NARGS_EQ(5,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FIX(35L)
))
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,5,1,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_type_2d_s)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-1))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_type_2d_s)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_type_2d_s)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L30___riscv_23_riscv_2d_type_2d_s)
   ___END_IF
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_type_2d_s)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L30___riscv_23_riscv_2d_type_2d_s)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_type_2d_s)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_type_2d_s)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L25___riscv_23_riscv_2d_type_2d_s)
   ___END_IF
   ___SET_R1(___SUB(104))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_type_2d_s)
___DEF_GLBL(___L25___riscv_23_riscv_2d_type_2d_s)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_type_2d_s)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L29___riscv_23_riscv_2d_type_2d_s)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_type_2d_s)
   ___SET_R2(___SYM_S)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_type_2d_s)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_type_2d_s)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L28___riscv_23_riscv_2d_type_2d_s)
   ___END_IF
   ___GOTO(___L26___riscv_23_riscv_2d_type_2d_s)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_type_2d_s)
___DEF_GLBL(___L26___riscv_23_riscv_2d_type_2d_s)
   ___SET_STK(1,___STK(-5))
   ___SET_STK(2,___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R2(___FIX(15L))
   ___SET_R0(___LBL(12))
   ___ADJFP(8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_type_2d_s)
   ___SET_STK(-13,___R1)
   ___SET_R1(___STK(-17))
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_type_2d_s)
   ___SET_STK(-12,___R1)
   ___SET_R1(___STK(-15))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(1),___PRC(55),___L___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_type_2d_s)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-12))
   ___SET_R1(___STK(-13))
   ___SET_R0(___LBL(15))
   ___ADJFP(-6)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),141,___G_fx_2b_)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_type_2d_s)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_type_2d_s)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_type_2d_s)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L27___riscv_23_riscv_2d_type_2d_s)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(-12L))
   ___SET_R0(___LBL(18))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_type_2d_s)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(105))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_type_2d_s)
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(20))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_type_2d_s)
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),158,___G_number_2d__3e_string)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_type_2d_s)
   ___SET_STK(1,___R1)
   ___SET_R2(___STK(-10))
   ___SET_R1(___SUB(0))
   ___SET_R0(___LBL(22))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_type_2d_s)
   ___SET_R2(___R1)
   ___SET_R3(___SUB(110))
   ___SET_R1(___SUB(111))
   ___SET_R0(___LBL(23))
   ___ADJFP(-3)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),162,___G_string_2d_append)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_type_2d_s)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-9))
   ___SET_R0(___STK(-8))
   ___SET_R1(___STK(-6))
   ___POLL(24)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_type_2d_s)
   ___ADJFP(-11)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L27___riscv_23_riscv_2d_type_2d_s)
   ___SET_R1(___VOID)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___DEF_GLBL(___L28___riscv_23_riscv_2d_type_2d_s)
   ___SET_R1(___SUB(112))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L29___riscv_23_riscv_2d_type_2d_s)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_GLBL(___L30___riscv_23_riscv_2d_type_2d_s)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_beq
#undef ___PH_LBL0
#define ___PH_LBL0 686
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_beq)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_beq)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_beq)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_beq)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(0L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_beq)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bne
#undef ___PH_LBL0
#define ___PH_LBL0 689
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bne)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bne)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bne)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bne)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(4096L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bne)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_blt
#undef ___PH_LBL0
#define ___PH_LBL0 692
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_blt)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_blt)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_blt)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_blt)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(16384L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_blt)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bge
#undef ___PH_LBL0
#define ___PH_LBL0 695
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bge)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bge)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bge)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bge)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(20480L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bge)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bltu
#undef ___PH_LBL0
#define ___PH_LBL0 698
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bltu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bltu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bltu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bltu)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(24576L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bltu)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_bgeu
#undef ___PH_LBL0
#define ___PH_LBL0 701
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_bgeu)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_bgeu)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_bgeu)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_bgeu)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(28672L))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_bgeu)
   ___ADJFP(-1)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(704),___L0___riscv_23_riscv_2d_type_2d_b)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_type_2d_b
#undef ___PH_LBL0
#define ___PH_LBL0 704
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L25___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L26___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L27___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L28___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L29___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L30___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L31___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L32___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L33___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L34___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L35___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L36___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L37___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L38___riscv_23_riscv_2d_type_2d_b)
___DEF_P_HLBL(___L39___riscv_23_riscv_2d_type_2d_b)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_type_2d_b)
   ___IF_NARGS_EQ(5,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FIX(99L)
))
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,5,1,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-1))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L50___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___STK(-9))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L50___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L40___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___SUB(113))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_type_2d_b)
___DEF_GLBL(___L40___riscv_23_riscv_2d_type_2d_b)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(41),___L___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L41___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___GOTO(___L49___riscv_23_riscv_2d_type_2d_b)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L48___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
___DEF_GLBL(___L41___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L42___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___SUB(114))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_type_2d_b)
___DEF_GLBL(___L42___riscv_23_riscv_2d_type_2d_b)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L46___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_STK(1,___STK(-11))
   ___SET_STK(2,___STK(-10))
   ___SET_STK(3,___STK(-9))
   ___SET_R3(___STK(-7))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(20))
   ___ADJFP(3)
   ___GOTO(___L44___riscv_23_riscv_2d_type_2d_b)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_type_2d_b)
___DEF_GLBL(___L43___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___CLO(___STK(-6),1))
   ___SET_STK(-3,___STK(-6))
   ___SET_STK(-6,___CLO(___STK(-6),5))
   ___SET_STK(-2,___STK(-5))
   ___SET_STK(-5,___CLO(___STK(-3),6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___CLO(___STK(-3),4))
   ___SET_R1(___CLO(___STK(-3),2))
   ___SET_R0(___STK(-2))
   ___ADJFP(-5)
   ___POLL(13)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_type_2d_b)
___DEF_GLBL(___L44___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(1,___R0)
   ___SET_STK(6,___R2)
   ___SET_STK(7,___R1)
   ___SET_STK(2,___R3)
   ___SET_R1(___STK(-1))
   ___SET_R2(___FIX(15L))
   ___ADJFP(13)
   ___POLL(14)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-14,___R1)
   ___SET_R1(___STK(-13))
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-13,___R1)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(1),___PRC(55),___L___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_type_2d_b)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-13))
   ___SET_R1(___STK(-14))
   ___SET_R0(___LBL(18))
   ___ADJFP(-6)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),141,___G_fx_2b_)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_type_2d_b)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-4))
   ___POLL(19)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_type_2d_b)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_type_2d_b)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L45___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(-12L))
   ___SET_R0(___LBL(22))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_type_2d_b)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(115))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),166,___G_vector_2d_ref)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___R1)
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-2))
   ___SET_R0(___STK(-4))
   ___POLL(24)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_type_2d_b)
   ___ADJFP(-6)
   ___SET_NARGS(5) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L45___riscv_23_riscv_2d_type_2d_b)
   ___SET_R1(___VOID)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___DEF_GLBL(___L46___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-4,___LBL(37))
   ___SET_STK(-3,___ALLOC_CLO(6UL))
   ___BEGIN_SETUP_CLO(6,___STK(-3),26)
   ___ADD_CLO_ELEM(0,___STK(-11))
   ___ADD_CLO_ELEM(1,___STK(-6))
   ___ADD_CLO_ELEM(2,___STK(-7))
   ___ADD_CLO_ELEM(3,___STK(-5))
   ___ADD_CLO_ELEM(4,___STK(-10))
   ___ADD_CLO_ELEM(5,___STK(-9))
   ___END_SETUP_CLO(6)
   ___SET_R3(___STK(-3))
   ___SET_R1(___STK(-11))
   ___SET_R2(___STK(-4))
   ___SET_R0(___LBL(20))
   ___CHECK_HEAP(25,4096)
___DEF_SLBL(25,___L25___riscv_23_riscv_2d_type_2d_b)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),120,___G___asm_23_asm_2d_at_2d_assembly)
___DEF_SLBL(26,___L26___riscv_23_riscv_2d_type_2d_b)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(26,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R4)
   ___SET_STK(3,___R2)
   ___SET_R1(___CLO(___R4,3))
   ___ADJFP(8)
   ___POLL(27)
___DEF_SLBL(27,___L27___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(28,___L28___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),124,___G___asm_23_asm_2d_label_2d_pos)
___DEF_SLBL(29,___L29___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-4,___R1)
   ___SET_R1(___CLO(___STK(-6),3))
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(30,___L30___riscv_23_riscv_2d_type_2d_b)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_SLBL(31,___L31___riscv_23_riscv_2d_type_2d_b)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),142,___G_fx_2d_)
___DEF_SLBL(32,___L32___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_B)
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(33,___L33___riscv_23_riscv_2d_type_2d_b)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(-4096L))
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(34,___L34___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L47___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(4094L))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),144,___G_fx_3c__3d_)
___DEF_SLBL(35,___L35___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(36))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(36,___L36___riscv_23_riscv_2d_type_2d_b)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L43___riscv_23_riscv_2d_type_2d_b)
   ___END_IF
   ___SET_R1(___SUB(124))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L47___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(36))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(37,___L37___riscv_23_riscv_2d_type_2d_b)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(37,2,0,0)
   ___SET_R1(___FIX(4L))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L48___riscv_23_riscv_2d_type_2d_b)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(38))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(38,___L38___riscv_23_riscv_2d_type_2d_b)
   ___SET_R2(___SYM_B)
   ___SET_R0(___LBL(39))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___DEF_SLBL(39,___L39___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_GLBL(___L49___riscv_23_riscv_2d_type_2d_b)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_GLBL(___L50___riscv_23_riscv_2d_type_2d_b)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_lui
#undef ___PH_LBL0
#define ___PH_LBL0 745
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_lui)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_lui)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_lui)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_lui)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_lui)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_lui)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_lui)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(9,___R1)
   ___SET_R2(___R3)
   ___SET_R1(___STK(3))
   ___SET_R3(___FIX(55L))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_lui)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(4),___PRC(757),___L___riscv_23_riscv_2d_type_2d_u)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_lui)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_lui)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_lui)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(125))
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_lui)
   ___ADJFP(-7)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_lui)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_auipc
#undef ___PH_LBL0
#define ___PH_LBL0 751
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_auipc)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_auipc)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_auipc)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_auipc)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_auipc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_auipc)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_auipc)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(9,___R1)
   ___SET_R2(___R3)
   ___SET_R1(___STK(3))
   ___SET_R3(___FIX(23L))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_auipc)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(4),___PRC(757),___L___riscv_23_riscv_2d_type_2d_u)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_auipc)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_auipc)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_auipc)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(126))
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_auipc)
   ___ADJFP(-7)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_auipc)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_type_2d_u
#undef ___PH_LBL0
#define ___PH_LBL0 757
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_type_2d_u)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_type_2d_u)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_type_2d_u)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_type_2d_u)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_type_2d_u)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_type_2d_u)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L18___riscv_23_riscv_2d_type_2d_u)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_type_2d_u)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_type_2d_u)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L15___riscv_23_riscv_2d_type_2d_u)
   ___END_IF
   ___SET_R1(___SUB(127))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_type_2d_u)
___DEF_GLBL(___L15___riscv_23_riscv_2d_type_2d_u)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_type_2d_u)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L17___riscv_23_riscv_2d_type_2d_u)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_type_2d_u)
   ___SET_R2(___SYM_U)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_type_2d_u)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_type_2d_u)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L16___riscv_23_riscv_2d_type_2d_u)
   ___END_IF
   ___SET_R1(___SUB(128))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_type_2d_u)
___DEF_GLBL(___L16___riscv_23_riscv_2d_type_2d_u)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(7L))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_type_2d_u)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(1),___PRC(55),___L___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_type_2d_u)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),141,___G_fx_2b_)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_type_2d_u)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-6))
   ___POLL(14)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_type_2d_u)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_GLBL(___L17___riscv_23_riscv_2d_type_2d_u)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_GLBL(___L18___riscv_23_riscv_2d_type_2d_u)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_jal
#undef ___PH_LBL0
#define ___PH_LBL0 773
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_jal)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_jal)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_jal)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_jal)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_jal)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_jal)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_jal)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_STK(9,___R1)
   ___SET_R2(___R3)
   ___SET_R1(___STK(3))
   ___SET_R3(___FIX(111L))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_jal)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(4),___PRC(779),___L___riscv_23_riscv_2d_type_2d_j)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_jal)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_jal)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_jal)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(129))
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_jal)
   ___ADJFP(-7)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_jal)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_type_2d_j
#undef ___PH_LBL0
#define ___PH_LBL0 779
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L24___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L25___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L26___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L27___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L28___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L29___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L30___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L31___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L32___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L33___riscv_23_riscv_2d_type_2d_j)
___DEF_P_HLBL(___L34___riscv_23_riscv_2d_type_2d_j)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_type_2d_j)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G_fixnum_3f_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L44___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_pair_3f_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L35___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___SET_R1(___SUB(130))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_type_2d_j)
___DEF_GLBL(___L35___riscv_23_riscv_2d_type_2d_j)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(41),___L___riscv_23_riscv_2d_imm_2d_lbl_3f_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L36___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___GOTO(___L43___riscv_23_riscv_2d_type_2d_j)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L42___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
___DEF_GLBL(___L36___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L37___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___SET_R1(___SUB(131))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_type_2d_j)
___DEF_GLBL(___L37___riscv_23_riscv_2d_type_2d_j)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L40___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(11)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_type_2d_j)
   ___GOTO(___L39___riscv_23_riscv_2d_type_2d_j)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_type_2d_j)
___DEF_GLBL(___L38___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___CLO(___STK(-6),1))
   ___SET_R3(___STK(-4))
   ___SET_R2(___CLO(___STK(-6),3))
   ___SET_R1(___CLO(___STK(-6),4))
   ___SET_R0(___STK(-5))
   ___ADJFP(-7)
   ___POLL(13)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_type_2d_j)
___DEF_GLBL(___L39___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___FIX(7L))
   ___ADJFP(7)
   ___POLL(14)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(55),___L___riscv_23_riscv_2d_imm_2d__3e_instr)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_type_2d_j)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___STK(-3))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),141,___G_fx_2b_)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_type_2d_j)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-6))
   ___POLL(18)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_type_2d_j)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_GLBL(___L40___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(-2,___LBL(32))
   ___SET_STK(-1,___ALLOC_CLO(4UL))
   ___BEGIN_SETUP_CLO(4,___STK(-1),21)
   ___ADD_CLO_ELEM(0,___STK(-7))
   ___ADD_CLO_ELEM(1,___STK(-4))
   ___ADD_CLO_ELEM(2,___STK(-3))
   ___ADD_CLO_ELEM(3,___STK(-5))
   ___END_SETUP_CLO(4)
   ___SET_R3(___STK(-1))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-6))
   ___SET_R2(___STK(-2))
   ___ADJFP(-1)
   ___CHECK_HEAP(19,4096)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_type_2d_j)
   ___POLL(20)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_type_2d_j)
   ___ADJFP(-7)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),120,___G___asm_23_asm_2d_at_2d_assembly)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_type_2d_j)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(21,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R4)
   ___SET_STK(3,___R2)
   ___SET_R1(___CLO(___R4,2))
   ___ADJFP(8)
   ___POLL(22)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_cdr)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),124,___G___asm_23_asm_2d_label_2d_pos)
___DEF_SLBL(24,___L24___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(-4,___R1)
   ___SET_R1(___CLO(___STK(-6),2))
   ___SET_R0(___LBL(25))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(25,___L25___riscv_23_riscv_2d_type_2d_j)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),141,___G_fx_2b_)
___DEF_SLBL(26,___L26___riscv_23_riscv_2d_type_2d_j)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),142,___G_fx_2d_)
___DEF_SLBL(27,___L27___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_J)
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),136,___G_cons)
___DEF_SLBL(28,___L28___riscv_23_riscv_2d_type_2d_j)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(-1048576L))
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),147,___G_fx_3e__3d_)
___DEF_SLBL(29,___L29___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L41___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(1048574L))
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),144,___G_fx_3c__3d_)
___DEF_SLBL(30,___L30___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(31,___L31___riscv_23_riscv_2d_type_2d_j)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L38___riscv_23_riscv_2d_type_2d_j)
   ___END_IF
   ___SET_R1(___SUB(132))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_GLBL(___L41___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(32,___L32___riscv_23_riscv_2d_type_2d_j)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(32,2,0,0)
   ___SET_R1(___FIX(4L))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L42___riscv_23_riscv_2d_type_2d_j)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_car)
___DEF_SLBL(33,___L33___riscv_23_riscv_2d_type_2d_j)
   ___SET_R2(___SYM_J)
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_eq_3f_)
___DEF_SLBL(34,___L34___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_GLBL(___L43___riscv_23_riscv_2d_type_2d_j)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(24),___L___riscv_23_riscv_2d_imm_2d_int_3f_)
___DEF_GLBL(___L44___riscv_23_riscv_2d_type_2d_j)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_fence
#undef ___PH_LBL0
#define ___PH_LBL0 815
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L5___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L6___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L7___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L8___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L9___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L10___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L11___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L12___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L13___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L14___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L15___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L16___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L17___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L18___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L19___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L20___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L21___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L22___riscv_23_riscv_2d_fence)
___DEF_P_HLBL(___L23___riscv_23_riscv_2d_fence)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_fence)
   ___IF_NARGS_EQ(1,___SET_R2(___FIX(15L)) ___SET_R3(___FIX(15L)))
   ___IF_NARGS_EQ(2,___SET_R3(___FIX(15L)))
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,1,2,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_fence)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___SET_R2(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_fence)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),146,___G_fx_3e_)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L37___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(16L))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_fence)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L24___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R1(___SUB(133))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(5,___L5___riscv_23_riscv_2d_fence)
___DEF_GLBL(___L24___riscv_23_riscv_2d_fence)
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),146,___G_fx_3e_)
___DEF_SLBL(6,___L6___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L36___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(16L))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),143,___G_fx_3c_)
___DEF_SLBL(7,___L7___riscv_23_riscv_2d_fence)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_SLBL(8,___L8___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L25___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R1(___SUB(134))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_error)
___DEF_SLBL(9,___L9___riscv_23_riscv_2d_fence)
___DEF_GLBL(___L25___riscv_23_riscv_2d_fence)
   ___SET_R1(___STK(-4))
   ___SET_R2(___FIX(20L))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(10,___L10___riscv_23_riscv_2d_fence)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(24L))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),149,___G_fxarithmetic_2d_shift)
___DEF_SLBL(11,___L11___riscv_23_riscv_2d_fence)
   ___SET_R3(___R1)
   ___SET_R1(___FIX(15L))
   ___SET_R2(___STK(-3))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),141,___G_fx_2b_)
___DEF_SLBL(12,___L12___riscv_23_riscv_2d_fence)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(13,___L13___riscv_23_riscv_2d_fence)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(14,___L14___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L35___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(15))
   ___GOTO(___L26___riscv_23_riscv_2d_fence)
___DEF_SLBL(15,___L15___riscv_23_riscv_2d_fence)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(22))
___DEF_GLBL(___L26___riscv_23_riscv_2d_fence)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(3L))
   ___ADJFP(8)
   ___POLL(16)
___DEF_SLBL(16,___L16___riscv_23_riscv_2d_fence)
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),150,___G_fxbit_2d_set_3f_)
___DEF_SLBL(17,___L17___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L27___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R1(___SUB(135))
   ___GOTO(___L28___riscv_23_riscv_2d_fence)
___DEF_GLBL(___L27___riscv_23_riscv_2d_fence)
   ___SET_R1(___SUB(136))
___DEF_GLBL(___L28___riscv_23_riscv_2d_fence)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___FIX(2L))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),150,___G_fxbit_2d_set_3f_)
___DEF_SLBL(18,___L18___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L29___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R1(___SUB(137))
   ___GOTO(___L30___riscv_23_riscv_2d_fence)
___DEF_GLBL(___L29___riscv_23_riscv_2d_fence)
   ___SET_R1(___SUB(138))
___DEF_GLBL(___L30___riscv_23_riscv_2d_fence)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___FIX(1L))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),150,___G_fxbit_2d_set_3f_)
___DEF_SLBL(19,___L19___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L31___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R2(___SUB(139))
   ___GOTO(___L32___riscv_23_riscv_2d_fence)
___DEF_GLBL(___L31___riscv_23_riscv_2d_fence)
   ___SET_R2(___SUB(140))
___DEF_GLBL(___L32___riscv_23_riscv_2d_fence)
   ___SET_STK(-3,___R2)
   ___SET_R2(___STK(-6))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),150,___G_fxbit_2d_set_3f_)
___DEF_SLBL(20,___L20___riscv_23_riscv_2d_fence)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L33___riscv_23_riscv_2d_fence)
   ___END_IF
   ___SET_R3(___SUB(141))
   ___GOTO(___L34___riscv_23_riscv_2d_fence)
___DEF_GLBL(___L33___riscv_23_riscv_2d_fence)
   ___SET_R3(___SUB(142))
___DEF_GLBL(___L34___riscv_23_riscv_2d_fence)
   ___SET_R0(___STK(-5))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___POLL(21)
___DEF_SLBL(21,___L21___riscv_23_riscv_2d_fence)
   ___ADJFP(-7)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),162,___G_string_2d_append)
___DEF_SLBL(22,___L22___riscv_23_riscv_2d_fence)
   ___SET_R3(___R1)
   ___SET_R1(___SUB(143))
   ___SET_R0(___STK(-3))
   ___SET_R2(___STK(-6))
   ___POLL(23)
___DEF_SLBL(23,___L23___riscv_23_riscv_2d_fence)
   ___ADJFP(-7)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L35___riscv_23_riscv_2d_fence)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L36___riscv_23_riscv_2d_fence)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___DEF_GLBL(___L37___riscv_23_riscv_2d_fence)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_not)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_fence_2e_i
#undef ___PH_LBL0
#define ___PH_LBL0 840
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_fence_2e_i)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_fence_2e_i)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_fence_2e_i)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_fence_2e_i)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_fence_2e_i)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_fence_2e_i)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_fence_2e_i)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(4111L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_fence_2e_i)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_fence_2e_i)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_fence_2e_i)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_fence_2e_i)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(144))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_fence_2e_i)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_fence_2e_i)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ecall
#undef ___PH_LBL0
#define ___PH_LBL0 846
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ecall)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ecall)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_ecall)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_ecall)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_ecall)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ecall)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ecall)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(115L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ecall)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_ecall)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_ecall)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_ecall)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(145))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_ecall)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_ecall)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___riscv_23_riscv_2d_ebreak
#undef ___PH_LBL0
#define ___PH_LBL0 852
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___riscv_23_riscv_2d_ebreak)
___DEF_P_HLBL(___L1___riscv_23_riscv_2d_ebreak)
___DEF_P_HLBL(___L2___riscv_23_riscv_2d_ebreak)
___DEF_P_HLBL(___L3___riscv_23_riscv_2d_ebreak)
___DEF_P_HLBL(___L4___riscv_23_riscv_2d_ebreak)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___riscv_23_riscv_2d_ebreak)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___riscv_23_riscv_2d_ebreak)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(1048691L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1___riscv_23_riscv_2d_ebreak)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),119,___G___asm_23_asm_2d_32_2d_le)
___DEF_SLBL(2,___L2___riscv_23_riscv_2d_ebreak)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G___codegen_23_codegen_2d_context_2d_listing_2d_format)
___DEF_SLBL(3,___L3___riscv_23_riscv_2d_ebreak)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5___riscv_23_riscv_2d_ebreak)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(146))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4___riscv_23_riscv_2d_ebreak)
   ___ADJFP(-8)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(90),___L0___riscv_23_riscv_2d_listing)
___DEF_GLBL(___L5___riscv_23_riscv_2d_ebreak)
   ___SET_R1(___VOID)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___riscv_23_,"_riscv#",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H___riscv_23_,0,-1)
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_register_2d_name,"_riscv#riscv-register-name",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_register_2d_name,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_register_2d_name,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_arch_2d_set_21_,"_riscv#riscv-arch-set!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_arch_2d_set_21_,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_arch_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_64bit_2d_mode_3f_,"_riscv#riscv-64bit-mode?",___REF_FAL,4,0)

,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_64bit_2d_mode_3f_,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_64bit_2d_mode_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_64bit_2d_mode_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_64bit_2d_mode_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_word_2d_width,"_riscv#riscv-word-width",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_word_2d_width,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_word_2d_width,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_word_2d_width,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_3f_,"_riscv#riscv-imm?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_3f_,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_int,"_riscv#riscv-imm-int",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_int,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_int_3f_,"_riscv#riscv-imm-int?",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_int_3f_,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_int_2d_type,"_riscv#riscv-imm-int-type",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_int_2d_type,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_2d_type,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_int_2d_value,"_riscv#riscv-imm-int-value",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_int_2d_value,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_int_2d_value,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_lbl,"_riscv#riscv-imm-lbl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_lbl,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,"_riscv#riscv-imm-lbl?",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_lbl_2d_offset,"_riscv#riscv-imm-lbl-offset",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_lbl_2d_offset,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_2d_offset,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d_lbl_2d_label,"_riscv#riscv-imm-lbl-label",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d_lbl_2d_label,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d_lbl_2d_label,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_imm_2d__3e_instr,"_riscv#riscv-imm->instr",___REF_FAL,34,0)

,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_imm_2d__3e_instr,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_imm_2d__3e_instr,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_listing,"_riscv#riscv-listing",___REF_FAL,20,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_listing,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_listing,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_listing,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_label,"_riscv#riscv-label",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_label,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_label,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_label,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_label,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_label,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_label,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_label,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_db,"_riscv#riscv-db",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_db,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_db,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_d2b,"_riscv#riscv-d2b",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_d2b,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_d2b,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_dh,"_riscv#riscv-dh",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_dh,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_dh,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ds,"_riscv#riscv-ds",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ds,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ds,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_d4b,"_riscv#riscv-d4b",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_d4b,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_d4b,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_dw,"_riscv#riscv-dw",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_dw,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_dw,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_dl,"_riscv#riscv-dl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_dl,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_dl,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_d8b,"_riscv#riscv-d8b",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_d8b,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_d8b,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_dd,"_riscv#riscv-dd",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_dd,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_dd,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_dq,"_riscv#riscv-dq",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_dq,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_dq,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_data_2d_elems,"_riscv#riscv-data-elems",___REF_FAL,29,0)

,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_data_2d_elems,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0xdfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x5fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x15fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x15fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x13fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x13fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x15fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x15fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_data_2d_elems,___IFD(___RETN,9,3,0x15fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_nop,"_riscv#riscv-nop",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_nop,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_nop,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_nop,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_nop,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_li,"_riscv#riscv-li",___REF_FAL,45,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_li,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,0,0x37L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_li,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,9,3,0x2fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_li,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_mv,"_riscv#riscv-mv",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_mv,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_mv,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_mv,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_mv,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_not,"_riscv#riscv-not",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_not,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_not,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_not,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_not,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_neg,"_riscv#riscv-neg",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_neg,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_neg,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_negw,"_riscv#riscv-negw",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_negw,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_negw,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sext_2e_w,"_riscv#riscv-sext.w",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sext_2e_w,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sext_2e_w,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sext_2e_w,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sext_2e_w,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sext_2e_w,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sext_2e_w,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_seqz,"_riscv#riscv-seqz",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_seqz,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_seqz,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_seqz,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_seqz,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_snez,"_riscv#riscv-snez",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_snez,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_snez,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sltz,"_riscv#riscv-sltz",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sltz,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sltz,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sgtz,"_riscv#riscv-sgtz",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sgtz,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sgtz,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_beqz,"_riscv#riscv-beqz",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_beqz,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_beqz,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bnez,"_riscv#riscv-bnez",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bnez,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bnez,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_blez,"_riscv#riscv-blez",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_blez,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_blez,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bgez,"_riscv#riscv-bgez",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bgez,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bgez,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bltz,"_riscv#riscv-bltz",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bltz,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bltz,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bgtz,"_riscv#riscv-bgtz",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bgtz,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bgtz,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bgt,"_riscv#riscv-bgt",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bgt,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bgt,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ble,"_riscv#riscv-ble",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ble,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ble,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bgtu,"_riscv#riscv-bgtu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bgtu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bgtu,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bleu,"_riscv#riscv-bleu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bleu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bleu,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_j,"_riscv#riscv-j",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_j,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_j,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_jal_2a_,"_riscv#riscv-jal*",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jal_2a_,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jal_2a_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_jr,"_riscv#riscv-jr",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jr,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jr,___IFD(___RETI,8,1,0x3f07L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jr,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jr,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jr,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jr,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_jalr_2a_,"_riscv#riscv-jalr*",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jalr_2a_,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr_2a_,___IFD(___RETI,8,1,0x3f07L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jalr_2a_,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr_2a_,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr_2a_,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr_2a_,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ret,"_riscv#riscv-ret",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ret,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ret,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ret,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ret,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ret,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ret,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_call,"_riscv#riscv-call",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_call,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_call,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_call,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_tail,"_riscv#riscv-tail",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_tail,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_tail,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_tail,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_add,"_riscv#riscv-add",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_add,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_add,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sub,"_riscv#riscv-sub",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sub,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sub,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sll,"_riscv#riscv-sll",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sll,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sll,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_slt,"_riscv#riscv-slt",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_slt,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slt,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sltu,"_riscv#riscv-sltu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sltu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sltu,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_xor,"_riscv#riscv-xor",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_xor,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_xor,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_srl,"_riscv#riscv-srl",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srl,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srl,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sra,"_riscv#riscv-sra",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sra,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sra,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_or,"_riscv#riscv-or",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_or,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_or,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_and,"_riscv#riscv-and",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_and,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_and,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_addw,"_riscv#riscv-addw",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_addw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addw,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_subw,"_riscv#riscv-subw",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_subw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_subw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_subw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_subw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_subw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_subw,___IFD(___RETI,8,8,0x3f0fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sllw,"_riscv#riscv-sllw",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sllw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sllw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sllw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sllw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sllw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sllw,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_srlw,"_riscv#riscv-srlw",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srlw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srlw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srlw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srlw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srlw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srlw,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sraw,"_riscv#riscv-sraw",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sraw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraw,___IFD(___RETI,8,8,0x3f0fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_type_2d_r,"_riscv#riscv-type-r",___REF_FAL,19,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_r,7,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___OFD(___RETI,12,4,0x3f0ffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,13,4,0x10ffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,17,4,0x70ffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,17,4,0x71ffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0xdfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0x5fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,9,4,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_r,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_jalr,"_riscv#riscv-jalr",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jalr,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr,___OFD(___RETI,11,1,0x3f71fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jalr,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lb,"_riscv#riscv-lb",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lb,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lb,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lh,"_riscv#riscv-lh",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lh,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lh,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lw,"_riscv#riscv-lw",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lw,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lbu,"_riscv#riscv-lbu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lbu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lbu,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lhu,"_riscv#riscv-lhu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lhu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lhu,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_addi,"_riscv#riscv-addi",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_addi,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addi,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_slti,"_riscv#riscv-slti",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_slti,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slti,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sltiu,"_riscv#riscv-sltiu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sltiu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sltiu,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_xori,"_riscv#riscv-xori",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_xori,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_xori,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ori,"_riscv#riscv-ori",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ori,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ori,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_andi,"_riscv#riscv-andi",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_andi,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_andi,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_slli,"_riscv#riscv-slli",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_slli,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_slli,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___IFD(___RETN,9,5,0x2bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slli,___OFD(___RETI,12,12,0x3f003L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_srli,"_riscv#riscv-srli",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srli,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srli,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___IFD(___RETN,9,5,0x2bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srli,___OFD(___RETI,12,12,0x3f003L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_srai,"_riscv#riscv-srai",___REF_FAL,12,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srai,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,9,5,0x2bL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srai,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___IFD(___RETN,9,5,0x2bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srai,___OFD(___RETI,12,12,0x3f003L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lwu,"_riscv#riscv-lwu",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lwu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lwu,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lwu,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lwu,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lwu,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lwu,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ld,"_riscv#riscv-ld",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ld,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ld,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ld,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ld,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ld,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ld,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_addiw,"_riscv#riscv-addiw",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_addiw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addiw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_addiw,___IFD(___RETI,8,8,0x3f07L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_slliw,"_riscv#riscv-slliw",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_slliw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_slliw,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___IFD(___RETN,9,5,0x27L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_slliw,___OFD(___RETI,12,12,0x3f007L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_srliw,"_riscv#riscv-srliw",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srliw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_srliw,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___IFD(___RETN,9,5,0x27L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_srliw,___OFD(___RETI,12,12,0x3f007L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sraiw,"_riscv#riscv-sraiw",___REF_FAL,14,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sraiw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,9,5,0x27L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sraiw,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___IFD(___RETN,9,5,0x27L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sraiw,___OFD(___RETI,12,12,0x3f007L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_type_2d_i,"_riscv#riscv-type-i",___REF_FAL,68,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_i,6,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,13,3,0x107fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,17,3,0x307fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,17,3,0x30ffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,17,3,0x1f07fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,17,3,0x1f07fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xdfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xdfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xdfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x9fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xafL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0xafL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x8fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___OFD(___RETI,12,12,0x3f003L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_i,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_i,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x2fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x2fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,13,3,0x102bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___IFD(___RETN,9,3,0x2bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_i,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sb,"_riscv#riscv-sb",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sb,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sb,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sh,"_riscv#riscv-sh",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sh,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sh,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sw,"_riscv#riscv-sw",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sw,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sw,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_sd,"_riscv#riscv-sd",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_sd,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sd,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sd,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sd,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sd,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_sd,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_type_2d_s,"_riscv#riscv-type-s",___REF_FAL,25,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_s,6,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,17,3,0x303fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,17,3,0x307fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,17,3,0x30ffL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x2fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x2fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,13,3,0x102dL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___IFD(___RETN,9,3,0x2dL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_s,___OFD(___RETI,12,12,0x3f021L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_beq,"_riscv#riscv-beq",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_beq,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_beq,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bne,"_riscv#riscv-bne",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bne,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bne,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_blt,"_riscv#riscv-blt",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_blt,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_blt,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bge,"_riscv#riscv-bge",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bge,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bge,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bltu,"_riscv#riscv-bltu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bltu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bltu,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_bgeu,"_riscv#riscv-bgeu",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_bgeu,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_bgeu,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_type_2d_b,"_riscv#riscv-type-b",___REF_FAL,40,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_b,6,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___OFD(___RETI,16,3,0x3f031dL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,13,3,0x31dL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,13,3,0x31bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,13,3,0x30fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x3fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___OFD(___RETI,12,3,0x3f0bfL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_b,2,6)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_b,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_b,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_lui,"_riscv#riscv-lui",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_lui,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lui,___OFD(___RETI,9,0,0x3f10fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lui,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lui,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_lui,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_auipc,"_riscv#riscv-auipc",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_auipc,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_auipc,___OFD(___RETI,9,0,0x3f10fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_auipc,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_auipc,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_auipc,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_type_2d_u,"_riscv#riscv-type-u",___REF_FAL,15,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_u,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x1bL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_u,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_jal,"_riscv#riscv-jal",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_jal,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jal,___OFD(___RETI,9,0,0x3f10fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jal,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jal,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_jal,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_type_2d_j,"_riscv#riscv-type-j",___REF_FAL,35,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_j,4,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x17L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,7,8,0x3f20L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,7,8,0x3f20L))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_j,2,4)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_type_2d_j,2,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_type_2d_j,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_fence,"_riscv#riscv-fence",___REF_FAL,24,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_fence,3,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,4,0x19L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,2,0x7L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,2,0xfL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,2,0x1dL))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETI,8,8,0x3f19L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETN,5,4,0x13L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_fence_2e_i,"_riscv#riscv-fence.i",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_fence_2e_i,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence_2e_i,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence_2e_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence_2e_i,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_fence_2e_i,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ecall,"_riscv#riscv-ecall",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ecall,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ecall,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ecall,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ecall,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ecall,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H___riscv_23_riscv_2d_ebreak,"_riscv#riscv-ebreak",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H___riscv_23_riscv_2d_ebreak,1,-1)
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ebreak,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ebreak,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ebreak,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___riscv_23_riscv_2d_ebreak,___IFD(___RETI,8,8,0x3f00L))
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,11,1)
               ___GCMAP1(0x3f71fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f003L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f003L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f003L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f007L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f007L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f007L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f003L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f021L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,16,3)
               ___GCMAP1(0x3f031dL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f0bfL)
,___DEF_OFD(___RETI,9,0)
               ___GCMAP1(0x3f10fL)
,___DEF_OFD(___RETI,9,0)
               ___GCMAP1(0x3f10fL)
,___DEF_OFD(___RETI,9,0)
               ___GCMAP1(0x3f10fL)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___riscv_23_,1)
___DEF_MOD_PRM(76,___G___riscv_23_riscv_2d_register_2d_name,3)
___DEF_MOD_PRM(8,___G___riscv_23_riscv_2d_arch_2d_set_21_,6)
___DEF_MOD_PRM(1,___G___riscv_23_riscv_2d_64bit_2d_mode_3f_,9)
___DEF_MOD_PRM(112,___G___riscv_23_riscv_2d_word_2d_width,14)
___DEF_MOD_PRM(51,___G___riscv_23_riscv_2d_imm_3f_,18)
___DEF_MOD_PRM(43,___G___riscv_23_riscv_2d_imm_2d_int,21)
___DEF_MOD_PRM(46,___G___riscv_23_riscv_2d_imm_2d_int_3f_,24)
___DEF_MOD_PRM(44,___G___riscv_23_riscv_2d_imm_2d_int_2d_type,32)
___DEF_MOD_PRM(45,___G___riscv_23_riscv_2d_imm_2d_int_2d_value,35)
___DEF_MOD_PRM(47,___G___riscv_23_riscv_2d_imm_2d_lbl,38)
___DEF_MOD_PRM(50,___G___riscv_23_riscv_2d_imm_2d_lbl_3f_,41)
___DEF_MOD_PRM(49,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_offset,49)
___DEF_MOD_PRM(48,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_label,52)
___DEF_MOD_PRM(42,___G___riscv_23_riscv_2d_imm_2d__3e_instr,55)
___DEF_MOD_PRM(65,___G___riscv_23_riscv_2d_listing,90)
___DEF_MOD_PRM(58,___G___riscv_23_riscv_2d_label,111)
___DEF_MOD_PRM(31,___G___riscv_23_riscv_2d_db,119)
___DEF_MOD_PRM(27,___G___riscv_23_riscv_2d_d2b,122)
___DEF_MOD_PRM(33,___G___riscv_23_riscv_2d_dh,125)
___DEF_MOD_PRM(36,___G___riscv_23_riscv_2d_ds,128)
___DEF_MOD_PRM(28,___G___riscv_23_riscv_2d_d4b,131)
___DEF_MOD_PRM(37,___G___riscv_23_riscv_2d_dw,134)
___DEF_MOD_PRM(34,___G___riscv_23_riscv_2d_dl,137)
___DEF_MOD_PRM(29,___G___riscv_23_riscv_2d_d8b,140)
___DEF_MOD_PRM(32,___G___riscv_23_riscv_2d_dd,143)
___DEF_MOD_PRM(35,___G___riscv_23_riscv_2d_dq,146)
___DEF_MOD_PRM(30,___G___riscv_23_riscv_2d_data_2d_elems,149)
___DEF_MOD_PRM(72,___G___riscv_23_riscv_2d_nop,179)
___DEF_MOD_PRM(64,___G___riscv_23_riscv_2d_li,184)
___DEF_MOD_PRM(69,___G___riscv_23_riscv_2d_mv,230)
___DEF_MOD_PRM(73,___G___riscv_23_riscv_2d_not,235)
___DEF_MOD_PRM(70,___G___riscv_23_riscv_2d_neg,240)
___DEF_MOD_PRM(71,___G___riscv_23_riscv_2d_negw,243)
___DEF_MOD_PRM(81,___G___riscv_23_riscv_2d_sext_2e_w,246)
___DEF_MOD_PRM(80,___G___riscv_23_riscv_2d_seqz,253)
___DEF_MOD_PRM(93,___G___riscv_23_riscv_2d_snez,258)
___DEF_MOD_PRM(92,___G___riscv_23_riscv_2d_sltz,261)
___DEF_MOD_PRM(82,___G___riscv_23_riscv_2d_sgtz,264)
___DEF_MOD_PRM(11,___G___riscv_23_riscv_2d_beqz,267)
___DEF_MOD_PRM(25,___G___riscv_23_riscv_2d_bnez,270)
___DEF_MOD_PRM(20,___G___riscv_23_riscv_2d_blez,273)
___DEF_MOD_PRM(14,___G___riscv_23_riscv_2d_bgez,276)
___DEF_MOD_PRM(23,___G___riscv_23_riscv_2d_bltz,279)
___DEF_MOD_PRM(17,___G___riscv_23_riscv_2d_bgtz,282)
___DEF_MOD_PRM(15,___G___riscv_23_riscv_2d_bgt,285)
___DEF_MOD_PRM(18,___G___riscv_23_riscv_2d_ble,288)
___DEF_MOD_PRM(16,___G___riscv_23_riscv_2d_bgtu,291)
___DEF_MOD_PRM(19,___G___riscv_23_riscv_2d_bleu,294)
___DEF_MOD_PRM(52,___G___riscv_23_riscv_2d_j,297)
___DEF_MOD_PRM(54,___G___riscv_23_riscv_2d_jal_2a_,300)
___DEF_MOD_PRM(57,___G___riscv_23_riscv_2d_jr,303)
___DEF_MOD_PRM(56,___G___riscv_23_riscv_2d_jalr_2a_,310)
___DEF_MOD_PRM(77,___G___riscv_23_riscv_2d_ret,317)
___DEF_MOD_PRM(26,___G___riscv_23_riscv_2d_call,324)
___DEF_MOD_PRM(105,___G___riscv_23_riscv_2d_tail,337)
___DEF_MOD_PRM(2,___G___riscv_23_riscv_2d_add,350)
___DEF_MOD_PRM(102,___G___riscv_23_riscv_2d_sub,353)
___DEF_MOD_PRM(84,___G___riscv_23_riscv_2d_sll,356)
___DEF_MOD_PRM(88,___G___riscv_23_riscv_2d_slt,359)
___DEF_MOD_PRM(91,___G___riscv_23_riscv_2d_sltu,362)
___DEF_MOD_PRM(113,___G___riscv_23_riscv_2d_xor,365)
___DEF_MOD_PRM(98,___G___riscv_23_riscv_2d_srl,368)
___DEF_MOD_PRM(94,___G___riscv_23_riscv_2d_sra,371)
___DEF_MOD_PRM(74,___G___riscv_23_riscv_2d_or,374)
___DEF_MOD_PRM(6,___G___riscv_23_riscv_2d_and,377)
___DEF_MOD_PRM(5,___G___riscv_23_riscv_2d_addw,380)
___DEF_MOD_PRM(103,___G___riscv_23_riscv_2d_subw,387)
___DEF_MOD_PRM(87,___G___riscv_23_riscv_2d_sllw,394)
___DEF_MOD_PRM(101,___G___riscv_23_riscv_2d_srlw,401)
___DEF_MOD_PRM(97,___G___riscv_23_riscv_2d_sraw,408)
___DEF_MOD_PRM(109,___G___riscv_23_riscv_2d_type_2d_r,415)
___DEF_MOD_PRM(55,___G___riscv_23_riscv_2d_jalr,435)
___DEF_MOD_PRM(59,___G___riscv_23_riscv_2d_lb,441)
___DEF_MOD_PRM(62,___G___riscv_23_riscv_2d_lh,444)
___DEF_MOD_PRM(67,___G___riscv_23_riscv_2d_lw,447)
___DEF_MOD_PRM(60,___G___riscv_23_riscv_2d_lbu,450)
___DEF_MOD_PRM(63,___G___riscv_23_riscv_2d_lhu,453)
___DEF_MOD_PRM(3,___G___riscv_23_riscv_2d_addi,456)
___DEF_MOD_PRM(89,___G___riscv_23_riscv_2d_slti,459)
___DEF_MOD_PRM(90,___G___riscv_23_riscv_2d_sltiu,462)
___DEF_MOD_PRM(114,___G___riscv_23_riscv_2d_xori,465)
___DEF_MOD_PRM(75,___G___riscv_23_riscv_2d_ori,468)
___DEF_MOD_PRM(7,___G___riscv_23_riscv_2d_andi,471)
___DEF_MOD_PRM(85,___G___riscv_23_riscv_2d_slli,474)
___DEF_MOD_PRM(99,___G___riscv_23_riscv_2d_srli,486)
___DEF_MOD_PRM(95,___G___riscv_23_riscv_2d_srai,498)
___DEF_MOD_PRM(68,___G___riscv_23_riscv_2d_lwu,511)
___DEF_MOD_PRM(61,___G___riscv_23_riscv_2d_ld,518)
___DEF_MOD_PRM(4,___G___riscv_23_riscv_2d_addiw,525)
___DEF_MOD_PRM(86,___G___riscv_23_riscv_2d_slliw,532)
___DEF_MOD_PRM(100,___G___riscv_23_riscv_2d_srliw,546)
___DEF_MOD_PRM(96,___G___riscv_23_riscv_2d_sraiw,560)
___DEF_MOD_PRM(107,___G___riscv_23_riscv_2d_type_2d_i,575)
___DEF_MOD_PRM(78,___G___riscv_23_riscv_2d_sb,644)
___DEF_MOD_PRM(83,___G___riscv_23_riscv_2d_sh,647)
___DEF_MOD_PRM(104,___G___riscv_23_riscv_2d_sw,650)
___DEF_MOD_PRM(79,___G___riscv_23_riscv_2d_sd,653)
___DEF_MOD_PRM(110,___G___riscv_23_riscv_2d_type_2d_s,660)
___DEF_MOD_PRM(10,___G___riscv_23_riscv_2d_beq,686)
___DEF_MOD_PRM(24,___G___riscv_23_riscv_2d_bne,689)
___DEF_MOD_PRM(21,___G___riscv_23_riscv_2d_blt,692)
___DEF_MOD_PRM(12,___G___riscv_23_riscv_2d_bge,695)
___DEF_MOD_PRM(22,___G___riscv_23_riscv_2d_bltu,698)
___DEF_MOD_PRM(13,___G___riscv_23_riscv_2d_bgeu,701)
___DEF_MOD_PRM(106,___G___riscv_23_riscv_2d_type_2d_b,704)
___DEF_MOD_PRM(66,___G___riscv_23_riscv_2d_lui,745)
___DEF_MOD_PRM(9,___G___riscv_23_riscv_2d_auipc,751)
___DEF_MOD_PRM(111,___G___riscv_23_riscv_2d_type_2d_u,757)
___DEF_MOD_PRM(53,___G___riscv_23_riscv_2d_jal,773)
___DEF_MOD_PRM(108,___G___riscv_23_riscv_2d_type_2d_j,779)
___DEF_MOD_PRM(40,___G___riscv_23_riscv_2d_fence,815)
___DEF_MOD_PRM(41,___G___riscv_23_riscv_2d_fence_2e_i,840)
___DEF_MOD_PRM(39,___G___riscv_23_riscv_2d_ecall,846)
___DEF_MOD_PRM(38,___G___riscv_23_riscv_2d_ebreak,852)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___riscv_23_,1)
___DEF_MOD_GLO(76,___G___riscv_23_riscv_2d_register_2d_name,3)
___DEF_MOD_GLO(8,___G___riscv_23_riscv_2d_arch_2d_set_21_,6)
___DEF_MOD_GLO(1,___G___riscv_23_riscv_2d_64bit_2d_mode_3f_,9)
___DEF_MOD_GLO(112,___G___riscv_23_riscv_2d_word_2d_width,14)
___DEF_MOD_GLO(51,___G___riscv_23_riscv_2d_imm_3f_,18)
___DEF_MOD_GLO(43,___G___riscv_23_riscv_2d_imm_2d_int,21)
___DEF_MOD_GLO(46,___G___riscv_23_riscv_2d_imm_2d_int_3f_,24)
___DEF_MOD_GLO(44,___G___riscv_23_riscv_2d_imm_2d_int_2d_type,32)
___DEF_MOD_GLO(45,___G___riscv_23_riscv_2d_imm_2d_int_2d_value,35)
___DEF_MOD_GLO(47,___G___riscv_23_riscv_2d_imm_2d_lbl,38)
___DEF_MOD_GLO(50,___G___riscv_23_riscv_2d_imm_2d_lbl_3f_,41)
___DEF_MOD_GLO(49,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_offset,49)
___DEF_MOD_GLO(48,___G___riscv_23_riscv_2d_imm_2d_lbl_2d_label,52)
___DEF_MOD_GLO(42,___G___riscv_23_riscv_2d_imm_2d__3e_instr,55)
___DEF_MOD_GLO(65,___G___riscv_23_riscv_2d_listing,90)
___DEF_MOD_GLO(58,___G___riscv_23_riscv_2d_label,111)
___DEF_MOD_GLO(31,___G___riscv_23_riscv_2d_db,119)
___DEF_MOD_GLO(27,___G___riscv_23_riscv_2d_d2b,122)
___DEF_MOD_GLO(33,___G___riscv_23_riscv_2d_dh,125)
___DEF_MOD_GLO(36,___G___riscv_23_riscv_2d_ds,128)
___DEF_MOD_GLO(28,___G___riscv_23_riscv_2d_d4b,131)
___DEF_MOD_GLO(37,___G___riscv_23_riscv_2d_dw,134)
___DEF_MOD_GLO(34,___G___riscv_23_riscv_2d_dl,137)
___DEF_MOD_GLO(29,___G___riscv_23_riscv_2d_d8b,140)
___DEF_MOD_GLO(32,___G___riscv_23_riscv_2d_dd,143)
___DEF_MOD_GLO(35,___G___riscv_23_riscv_2d_dq,146)
___DEF_MOD_GLO(30,___G___riscv_23_riscv_2d_data_2d_elems,149)
___DEF_MOD_GLO(72,___G___riscv_23_riscv_2d_nop,179)
___DEF_MOD_GLO(64,___G___riscv_23_riscv_2d_li,184)
___DEF_MOD_GLO(69,___G___riscv_23_riscv_2d_mv,230)
___DEF_MOD_GLO(73,___G___riscv_23_riscv_2d_not,235)
___DEF_MOD_GLO(70,___G___riscv_23_riscv_2d_neg,240)
___DEF_MOD_GLO(71,___G___riscv_23_riscv_2d_negw,243)
___DEF_MOD_GLO(81,___G___riscv_23_riscv_2d_sext_2e_w,246)
___DEF_MOD_GLO(80,___G___riscv_23_riscv_2d_seqz,253)
___DEF_MOD_GLO(93,___G___riscv_23_riscv_2d_snez,258)
___DEF_MOD_GLO(92,___G___riscv_23_riscv_2d_sltz,261)
___DEF_MOD_GLO(82,___G___riscv_23_riscv_2d_sgtz,264)
___DEF_MOD_GLO(11,___G___riscv_23_riscv_2d_beqz,267)
___DEF_MOD_GLO(25,___G___riscv_23_riscv_2d_bnez,270)
___DEF_MOD_GLO(20,___G___riscv_23_riscv_2d_blez,273)
___DEF_MOD_GLO(14,___G___riscv_23_riscv_2d_bgez,276)
___DEF_MOD_GLO(23,___G___riscv_23_riscv_2d_bltz,279)
___DEF_MOD_GLO(17,___G___riscv_23_riscv_2d_bgtz,282)
___DEF_MOD_GLO(15,___G___riscv_23_riscv_2d_bgt,285)
___DEF_MOD_GLO(18,___G___riscv_23_riscv_2d_ble,288)
___DEF_MOD_GLO(16,___G___riscv_23_riscv_2d_bgtu,291)
___DEF_MOD_GLO(19,___G___riscv_23_riscv_2d_bleu,294)
___DEF_MOD_GLO(52,___G___riscv_23_riscv_2d_j,297)
___DEF_MOD_GLO(54,___G___riscv_23_riscv_2d_jal_2a_,300)
___DEF_MOD_GLO(57,___G___riscv_23_riscv_2d_jr,303)
___DEF_MOD_GLO(56,___G___riscv_23_riscv_2d_jalr_2a_,310)
___DEF_MOD_GLO(77,___G___riscv_23_riscv_2d_ret,317)
___DEF_MOD_GLO(26,___G___riscv_23_riscv_2d_call,324)
___DEF_MOD_GLO(105,___G___riscv_23_riscv_2d_tail,337)
___DEF_MOD_GLO(2,___G___riscv_23_riscv_2d_add,350)
___DEF_MOD_GLO(102,___G___riscv_23_riscv_2d_sub,353)
___DEF_MOD_GLO(84,___G___riscv_23_riscv_2d_sll,356)
___DEF_MOD_GLO(88,___G___riscv_23_riscv_2d_slt,359)
___DEF_MOD_GLO(91,___G___riscv_23_riscv_2d_sltu,362)
___DEF_MOD_GLO(113,___G___riscv_23_riscv_2d_xor,365)
___DEF_MOD_GLO(98,___G___riscv_23_riscv_2d_srl,368)
___DEF_MOD_GLO(94,___G___riscv_23_riscv_2d_sra,371)
___DEF_MOD_GLO(74,___G___riscv_23_riscv_2d_or,374)
___DEF_MOD_GLO(6,___G___riscv_23_riscv_2d_and,377)
___DEF_MOD_GLO(5,___G___riscv_23_riscv_2d_addw,380)
___DEF_MOD_GLO(103,___G___riscv_23_riscv_2d_subw,387)
___DEF_MOD_GLO(87,___G___riscv_23_riscv_2d_sllw,394)
___DEF_MOD_GLO(101,___G___riscv_23_riscv_2d_srlw,401)
___DEF_MOD_GLO(97,___G___riscv_23_riscv_2d_sraw,408)
___DEF_MOD_GLO(109,___G___riscv_23_riscv_2d_type_2d_r,415)
___DEF_MOD_GLO(55,___G___riscv_23_riscv_2d_jalr,435)
___DEF_MOD_GLO(59,___G___riscv_23_riscv_2d_lb,441)
___DEF_MOD_GLO(62,___G___riscv_23_riscv_2d_lh,444)
___DEF_MOD_GLO(67,___G___riscv_23_riscv_2d_lw,447)
___DEF_MOD_GLO(60,___G___riscv_23_riscv_2d_lbu,450)
___DEF_MOD_GLO(63,___G___riscv_23_riscv_2d_lhu,453)
___DEF_MOD_GLO(3,___G___riscv_23_riscv_2d_addi,456)
___DEF_MOD_GLO(89,___G___riscv_23_riscv_2d_slti,459)
___DEF_MOD_GLO(90,___G___riscv_23_riscv_2d_sltiu,462)
___DEF_MOD_GLO(114,___G___riscv_23_riscv_2d_xori,465)
___DEF_MOD_GLO(75,___G___riscv_23_riscv_2d_ori,468)
___DEF_MOD_GLO(7,___G___riscv_23_riscv_2d_andi,471)
___DEF_MOD_GLO(85,___G___riscv_23_riscv_2d_slli,474)
___DEF_MOD_GLO(99,___G___riscv_23_riscv_2d_srli,486)
___DEF_MOD_GLO(95,___G___riscv_23_riscv_2d_srai,498)
___DEF_MOD_GLO(68,___G___riscv_23_riscv_2d_lwu,511)
___DEF_MOD_GLO(61,___G___riscv_23_riscv_2d_ld,518)
___DEF_MOD_GLO(4,___G___riscv_23_riscv_2d_addiw,525)
___DEF_MOD_GLO(86,___G___riscv_23_riscv_2d_slliw,532)
___DEF_MOD_GLO(100,___G___riscv_23_riscv_2d_srliw,546)
___DEF_MOD_GLO(96,___G___riscv_23_riscv_2d_sraiw,560)
___DEF_MOD_GLO(107,___G___riscv_23_riscv_2d_type_2d_i,575)
___DEF_MOD_GLO(78,___G___riscv_23_riscv_2d_sb,644)
___DEF_MOD_GLO(83,___G___riscv_23_riscv_2d_sh,647)
___DEF_MOD_GLO(104,___G___riscv_23_riscv_2d_sw,650)
___DEF_MOD_GLO(79,___G___riscv_23_riscv_2d_sd,653)
___DEF_MOD_GLO(110,___G___riscv_23_riscv_2d_type_2d_s,660)
___DEF_MOD_GLO(10,___G___riscv_23_riscv_2d_beq,686)
___DEF_MOD_GLO(24,___G___riscv_23_riscv_2d_bne,689)
___DEF_MOD_GLO(21,___G___riscv_23_riscv_2d_blt,692)
___DEF_MOD_GLO(12,___G___riscv_23_riscv_2d_bge,695)
___DEF_MOD_GLO(22,___G___riscv_23_riscv_2d_bltu,698)
___DEF_MOD_GLO(13,___G___riscv_23_riscv_2d_bgeu,701)
___DEF_MOD_GLO(106,___G___riscv_23_riscv_2d_type_2d_b,704)
___DEF_MOD_GLO(66,___G___riscv_23_riscv_2d_lui,745)
___DEF_MOD_GLO(9,___G___riscv_23_riscv_2d_auipc,751)
___DEF_MOD_GLO(111,___G___riscv_23_riscv_2d_type_2d_u,757)
___DEF_MOD_GLO(53,___G___riscv_23_riscv_2d_jal,773)
___DEF_MOD_GLO(108,___G___riscv_23_riscv_2d_type_2d_j,779)
___DEF_MOD_GLO(40,___G___riscv_23_riscv_2d_fence,815)
___DEF_MOD_GLO(41,___G___riscv_23_riscv_2d_fence_2e_i,840)
___DEF_MOD_GLO(39,___G___riscv_23_riscv_2d_ecall,846)
___DEF_MOD_GLO(38,___G___riscv_23_riscv_2d_ebreak,852)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S_B,"B")
___DEF_MOD_SYM(1,___S_I,"I")
___DEF_MOD_SYM(2,___S_J,"J")
___DEF_MOD_SYM(3,___S_RV64I,"RV64I")
___DEF_MOD_SYM(4,___S_S,"S")
___DEF_MOD_SYM(5,___S_U,"U")
___DEF_MOD_SYM(6,___S___riscv,"_riscv")
___END_MOD_SYM_KEY

#endif
