#ifdef ___LINKER_INFO
; File: "_t-cpu-object-desc.c", produced by Gambit v4.9.3
(
409003
(C)
"_t-cpu-object-desc"
("_t-cpu-object-desc")
()
(("_t-cpu-object-desc"))
(
"_t-cpu-object-desc"
"bignum"
"boxvalues"
"continuation"
"cpxnum"
"f32vector"
"f64vector"
"fixnum"
"flonum"
"foreign"
"forw"
"frame"
"imm"
"jazz"
"keyword"
"mem1"
"mem2"
"meroon"
"movable0"
"movable1"
"movable2"
"pair"
"perm"
"procedure"
"promise"
"ratnum"
"ref"
"return"
"s16vector"
"s32vector"
"s64vector"
"s8vector"
"special"
"still"
"string"
"structure"
"subtyped"
"symbol"
"u16vector"
"u32vector"
"u64vector"
"u8vector"
"vector"
"weak"
)
(
)
(
"_t-cpu-object-desc#"
"c#absent-desc"
"c#bignum-desc"
"c#boxvalues-desc"
"c#char-desc"
"c#continuation-desc"
"c#cpxnum-desc"
"c#deleted-desc"
"c#desc-encoder"
"c#desc-encoder?"
"c#desc-type"
"c#desc-type-tag"
"c#eof-desc"
"c#f32vector-desc"
"c#f64vector-desc"
"c#fal-desc"
"c#fixnum-desc"
"c#flonum-desc"
"c#foreign-desc"
"c#imm-desc?"
"c#imm-type?"
"c#keyobj-desc"
"c#keyword-desc"
"c#nul-desc"
"c#object->desc"
"c#optional-desc"
"c#pair-desc"
"c#procedure-desc"
"c#promise-desc"
"c#ratnum-desc"
"c#ref-desc?"
"c#ref-subtype"
"c#ref-type?"
"c#rest-desc"
"c#s16vector-desc"
"c#s32vector-desc"
"c#s64vector-desc"
"c#s8vector-desc"
"c#special-desc"
"c#string-desc"
"c#structure-desc"
"c#subtype-tag"
"c#symbol-desc"
"c#tagged-value"
"c#tru-desc"
"c#type-tag"
"c#u16vector-desc"
"c#u32vector-desc"
"c#u64vector-desc"
"c#u8vector-desc"
"c#unb1-desc"
"c#unb2-desc"
"c#unused-desc"
"c#vector-desc"
"c#void-desc"
)
(
"c#frame-desc"
"c#head-type-tag"
"c#head-type-tag-bits"
"c#head-type-tag-mask"
"c#head-type-tags"
"c#imm-desc"
"c#imm-encode"
"c#imm-encoder"
"c#imm-encoder?"
"c#imm-object?"
"c#imm-type"
"c#imm-type-tag"
"c#jazz-desc"
"c#length-mask"
"c#meroon-desc"
"c#pointer-header-offset"
"c#ref-desc"
"c#ref-encode"
"c#ref-encoder"
"c#ref-encoder?"
"c#ref-object?"
"c#ref-subtype-tag"
"c#ref-subtype?"
"c#ref-type"
"c#ref-type-tag"
"c#return-desc"
"c#subtype-tag-bits"
"c#subtype-tag-mask"
"c#subtype-tags"
"c#type-tag-bits"
"c#type-tag-mask"
"c#type-tags"
"c#weak-desc"
)
(
"+"
"arithmetic-shift"
"assq"
"bitwise-not"
"box?"
"c#absent-object?"
"c#compiler-internal-error"
"c#deleted-object?"
"c#end-of-file-object?"
"c#key-object?"
"c#optional-object?"
"c#rest-object?"
"c#structure-object?"
"c#unbound1-object?"
"c#unbound2-object?"
"c#unused-object?"
"c#void-object?"
"cdr"
"char->integer"
"char?"
"complex?"
"continuation?"
"eq?"
"f32vector?"
"f64vector?"
"fixnum?"
"flonum?"
"foreign?"
"fx+"
"fx-"
"fxarithmetic-shift"
"integer?"
"keyword?"
"null?"
"pair?"
"procedure?"
"promise?"
"rational?"
"s16vector?"
"s32vector?"
"s64vector?"
"s8vector?"
"string?"
"symbol?"
"u16vector?"
"u32vector?"
"u64vector?"
"u8vector?"
"vector"
"vector-ref"
"vector?"
)
()
)
#else
#define ___VERSION 409003
#define ___MODULE_NAME "_t-cpu-object-desc"
#define ___LINKER_ID ___LNK___t_2d_cpu_2d_object_2d_desc
#define ___MH_PROC ___H___t_2d_cpu_2d_object_2d_desc
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 44
#define ___GLOCOUNT 139
#define ___SUPCOUNT 88
#define ___CNSCOUNT 84
#define ___SUBCOUNT 6
#define ___LBLCOUNT 226
#define ___MODDESCR ___REF_SUB(3)
#include "gambit.h"

___NEED_SYM(___S___t_2d_cpu_2d_object_2d_desc)
___NEED_SYM(___S_bignum)
___NEED_SYM(___S_boxvalues)
___NEED_SYM(___S_continuation)
___NEED_SYM(___S_cpxnum)
___NEED_SYM(___S_f32vector)
___NEED_SYM(___S_f64vector)
___NEED_SYM(___S_fixnum)
___NEED_SYM(___S_flonum)
___NEED_SYM(___S_foreign)
___NEED_SYM(___S_forw)
___NEED_SYM(___S_frame)
___NEED_SYM(___S_imm)
___NEED_SYM(___S_jazz)
___NEED_SYM(___S_keyword)
___NEED_SYM(___S_mem1)
___NEED_SYM(___S_mem2)
___NEED_SYM(___S_meroon)
___NEED_SYM(___S_movable0)
___NEED_SYM(___S_movable1)
___NEED_SYM(___S_movable2)
___NEED_SYM(___S_pair)
___NEED_SYM(___S_perm)
___NEED_SYM(___S_procedure)
___NEED_SYM(___S_promise)
___NEED_SYM(___S_ratnum)
___NEED_SYM(___S_ref)
___NEED_SYM(___S_return)
___NEED_SYM(___S_s16vector)
___NEED_SYM(___S_s32vector)
___NEED_SYM(___S_s64vector)
___NEED_SYM(___S_s8vector)
___NEED_SYM(___S_special)
___NEED_SYM(___S_still)
___NEED_SYM(___S_string)
___NEED_SYM(___S_structure)
___NEED_SYM(___S_subtyped)
___NEED_SYM(___S_symbol)
___NEED_SYM(___S_u16vector)
___NEED_SYM(___S_u32vector)
___NEED_SYM(___S_u64vector)
___NEED_SYM(___S_u8vector)
___NEED_SYM(___S_vector)
___NEED_SYM(___S_weak)

___NEED_GLO(___G__2b_)
___NEED_GLO(___G___t_2d_cpu_2d_object_2d_desc_23_)
___NEED_GLO(___G_arithmetic_2d_shift)
___NEED_GLO(___G_assq)
___NEED_GLO(___G_bitwise_2d_not)
___NEED_GLO(___G_box_3f_)
___NEED_GLO(___G_c_23_absent_2d_desc)
___NEED_GLO(___G_c_23_absent_2d_object_3f_)
___NEED_GLO(___G_c_23_bignum_2d_desc)
___NEED_GLO(___G_c_23_boxvalues_2d_desc)
___NEED_GLO(___G_c_23_char_2d_desc)
___NEED_GLO(___G_c_23_compiler_2d_internal_2d_error)
___NEED_GLO(___G_c_23_continuation_2d_desc)
___NEED_GLO(___G_c_23_cpxnum_2d_desc)
___NEED_GLO(___G_c_23_deleted_2d_desc)
___NEED_GLO(___G_c_23_deleted_2d_object_3f_)
___NEED_GLO(___G_c_23_desc_2d_encoder)
___NEED_GLO(___G_c_23_desc_2d_encoder_3f_)
___NEED_GLO(___G_c_23_desc_2d_type)
___NEED_GLO(___G_c_23_desc_2d_type_2d_tag)
___NEED_GLO(___G_c_23_end_2d_of_2d_file_2d_object_3f_)
___NEED_GLO(___G_c_23_eof_2d_desc)
___NEED_GLO(___G_c_23_f32vector_2d_desc)
___NEED_GLO(___G_c_23_f64vector_2d_desc)
___NEED_GLO(___G_c_23_fal_2d_desc)
___NEED_GLO(___G_c_23_fixnum_2d_desc)
___NEED_GLO(___G_c_23_flonum_2d_desc)
___NEED_GLO(___G_c_23_foreign_2d_desc)
___NEED_GLO(___G_c_23_frame_2d_desc)
___NEED_GLO(___G_c_23_head_2d_type_2d_tag)
___NEED_GLO(___G_c_23_head_2d_type_2d_tag_2d_bits)
___NEED_GLO(___G_c_23_head_2d_type_2d_tag_2d_mask)
___NEED_GLO(___G_c_23_head_2d_type_2d_tags)
___NEED_GLO(___G_c_23_imm_2d_desc)
___NEED_GLO(___G_c_23_imm_2d_desc_3f_)
___NEED_GLO(___G_c_23_imm_2d_encode)
___NEED_GLO(___G_c_23_imm_2d_encoder)
___NEED_GLO(___G_c_23_imm_2d_encoder_3f_)
___NEED_GLO(___G_c_23_imm_2d_object_3f_)
___NEED_GLO(___G_c_23_imm_2d_type)
___NEED_GLO(___G_c_23_imm_2d_type_2d_tag)
___NEED_GLO(___G_c_23_imm_2d_type_3f_)
___NEED_GLO(___G_c_23_jazz_2d_desc)
___NEED_GLO(___G_c_23_key_2d_object_3f_)
___NEED_GLO(___G_c_23_keyobj_2d_desc)
___NEED_GLO(___G_c_23_keyword_2d_desc)
___NEED_GLO(___G_c_23_length_2d_mask)
___NEED_GLO(___G_c_23_meroon_2d_desc)
___NEED_GLO(___G_c_23_nul_2d_desc)
___NEED_GLO(___G_c_23_object_2d__3e_desc)
___NEED_GLO(___G_c_23_optional_2d_desc)
___NEED_GLO(___G_c_23_optional_2d_object_3f_)
___NEED_GLO(___G_c_23_pair_2d_desc)
___NEED_GLO(___G_c_23_pointer_2d_header_2d_offset)
___NEED_GLO(___G_c_23_procedure_2d_desc)
___NEED_GLO(___G_c_23_promise_2d_desc)
___NEED_GLO(___G_c_23_ratnum_2d_desc)
___NEED_GLO(___G_c_23_ref_2d_desc)
___NEED_GLO(___G_c_23_ref_2d_desc_3f_)
___NEED_GLO(___G_c_23_ref_2d_encode)
___NEED_GLO(___G_c_23_ref_2d_encoder)
___NEED_GLO(___G_c_23_ref_2d_encoder_3f_)
___NEED_GLO(___G_c_23_ref_2d_object_3f_)
___NEED_GLO(___G_c_23_ref_2d_subtype)
___NEED_GLO(___G_c_23_ref_2d_subtype_2d_tag)
___NEED_GLO(___G_c_23_ref_2d_subtype_3f_)
___NEED_GLO(___G_c_23_ref_2d_type)
___NEED_GLO(___G_c_23_ref_2d_type_2d_tag)
___NEED_GLO(___G_c_23_ref_2d_type_3f_)
___NEED_GLO(___G_c_23_rest_2d_desc)
___NEED_GLO(___G_c_23_rest_2d_object_3f_)
___NEED_GLO(___G_c_23_return_2d_desc)
___NEED_GLO(___G_c_23_s16vector_2d_desc)
___NEED_GLO(___G_c_23_s32vector_2d_desc)
___NEED_GLO(___G_c_23_s64vector_2d_desc)
___NEED_GLO(___G_c_23_s8vector_2d_desc)
___NEED_GLO(___G_c_23_special_2d_desc)
___NEED_GLO(___G_c_23_string_2d_desc)
___NEED_GLO(___G_c_23_structure_2d_desc)
___NEED_GLO(___G_c_23_structure_2d_object_3f_)
___NEED_GLO(___G_c_23_subtype_2d_tag)
___NEED_GLO(___G_c_23_subtype_2d_tag_2d_bits)
___NEED_GLO(___G_c_23_subtype_2d_tag_2d_mask)
___NEED_GLO(___G_c_23_subtype_2d_tags)
___NEED_GLO(___G_c_23_symbol_2d_desc)
___NEED_GLO(___G_c_23_tagged_2d_value)
___NEED_GLO(___G_c_23_tru_2d_desc)
___NEED_GLO(___G_c_23_type_2d_tag)
___NEED_GLO(___G_c_23_type_2d_tag_2d_bits)
___NEED_GLO(___G_c_23_type_2d_tag_2d_mask)
___NEED_GLO(___G_c_23_type_2d_tags)
___NEED_GLO(___G_c_23_u16vector_2d_desc)
___NEED_GLO(___G_c_23_u32vector_2d_desc)
___NEED_GLO(___G_c_23_u64vector_2d_desc)
___NEED_GLO(___G_c_23_u8vector_2d_desc)
___NEED_GLO(___G_c_23_unb1_2d_desc)
___NEED_GLO(___G_c_23_unb2_2d_desc)
___NEED_GLO(___G_c_23_unbound1_2d_object_3f_)
___NEED_GLO(___G_c_23_unbound2_2d_object_3f_)
___NEED_GLO(___G_c_23_unused_2d_desc)
___NEED_GLO(___G_c_23_unused_2d_object_3f_)
___NEED_GLO(___G_c_23_vector_2d_desc)
___NEED_GLO(___G_c_23_void_2d_desc)
___NEED_GLO(___G_c_23_void_2d_object_3f_)
___NEED_GLO(___G_c_23_weak_2d_desc)
___NEED_GLO(___G_cdr)
___NEED_GLO(___G_char_2d__3e_integer)
___NEED_GLO(___G_char_3f_)
___NEED_GLO(___G_complex_3f_)
___NEED_GLO(___G_continuation_3f_)
___NEED_GLO(___G_eq_3f_)
___NEED_GLO(___G_f32vector_3f_)
___NEED_GLO(___G_f64vector_3f_)
___NEED_GLO(___G_fixnum_3f_)
___NEED_GLO(___G_flonum_3f_)
___NEED_GLO(___G_foreign_3f_)
___NEED_GLO(___G_fx_2b_)
___NEED_GLO(___G_fx_2d_)
___NEED_GLO(___G_fxarithmetic_2d_shift)
___NEED_GLO(___G_integer_3f_)
___NEED_GLO(___G_keyword_3f_)
___NEED_GLO(___G_null_3f_)
___NEED_GLO(___G_pair_3f_)
___NEED_GLO(___G_procedure_3f_)
___NEED_GLO(___G_promise_3f_)
___NEED_GLO(___G_rational_3f_)
___NEED_GLO(___G_s16vector_3f_)
___NEED_GLO(___G_s32vector_3f_)
___NEED_GLO(___G_s64vector_3f_)
___NEED_GLO(___G_s8vector_3f_)
___NEED_GLO(___G_string_3f_)
___NEED_GLO(___G_symbol_3f_)
___NEED_GLO(___G_u16vector_3f_)
___NEED_GLO(___G_u32vector_3f_)
___NEED_GLO(___G_u64vector_3f_)
___NEED_GLO(___G_u8vector_3f_)
___NEED_GLO(___G_vector)
___NEED_GLO(___G_vector_2d_ref)
___NEED_GLO(___G_vector_3f_)

___BEGIN_SYM
___DEF_SYM(0,___S___t_2d_cpu_2d_object_2d_desc,"_t-cpu-object-desc")
___DEF_SYM(1,___S_bignum,"bignum")
___DEF_SYM(2,___S_boxvalues,"boxvalues")
___DEF_SYM(3,___S_continuation,"continuation")
___DEF_SYM(4,___S_cpxnum,"cpxnum")
___DEF_SYM(5,___S_f32vector,"f32vector")
___DEF_SYM(6,___S_f64vector,"f64vector")
___DEF_SYM(7,___S_fixnum,"fixnum")
___DEF_SYM(8,___S_flonum,"flonum")
___DEF_SYM(9,___S_foreign,"foreign")
___DEF_SYM(10,___S_forw,"forw")
___DEF_SYM(11,___S_frame,"frame")
___DEF_SYM(12,___S_imm,"imm")
___DEF_SYM(13,___S_jazz,"jazz")
___DEF_SYM(14,___S_keyword,"keyword")
___DEF_SYM(15,___S_mem1,"mem1")
___DEF_SYM(16,___S_mem2,"mem2")
___DEF_SYM(17,___S_meroon,"meroon")
___DEF_SYM(18,___S_movable0,"movable0")
___DEF_SYM(19,___S_movable1,"movable1")
___DEF_SYM(20,___S_movable2,"movable2")
___DEF_SYM(21,___S_pair,"pair")
___DEF_SYM(22,___S_perm,"perm")
___DEF_SYM(23,___S_procedure,"procedure")
___DEF_SYM(24,___S_promise,"promise")
___DEF_SYM(25,___S_ratnum,"ratnum")
___DEF_SYM(26,___S_ref,"ref")
___DEF_SYM(27,___S_return,"return")
___DEF_SYM(28,___S_s16vector,"s16vector")
___DEF_SYM(29,___S_s32vector,"s32vector")
___DEF_SYM(30,___S_s64vector,"s64vector")
___DEF_SYM(31,___S_s8vector,"s8vector")
___DEF_SYM(32,___S_special,"special")
___DEF_SYM(33,___S_still,"still")
___DEF_SYM(34,___S_string,"string")
___DEF_SYM(35,___S_structure,"structure")
___DEF_SYM(36,___S_subtyped,"subtyped")
___DEF_SYM(37,___S_symbol,"symbol")
___DEF_SYM(38,___S_u16vector,"u16vector")
___DEF_SYM(39,___S_u32vector,"u32vector")
___DEF_SYM(40,___S_u64vector,"u64vector")
___DEF_SYM(41,___S_u8vector,"u8vector")
___DEF_SYM(42,___S_vector,"vector")
___DEF_SYM(43,___S_weak,"weak")
___END_SYM

#define ___SYM___t_2d_cpu_2d_object_2d_desc ___SYM(0,___S___t_2d_cpu_2d_object_2d_desc)
#define ___SYM_bignum ___SYM(1,___S_bignum)
#define ___SYM_boxvalues ___SYM(2,___S_boxvalues)
#define ___SYM_continuation ___SYM(3,___S_continuation)
#define ___SYM_cpxnum ___SYM(4,___S_cpxnum)
#define ___SYM_f32vector ___SYM(5,___S_f32vector)
#define ___SYM_f64vector ___SYM(6,___S_f64vector)
#define ___SYM_fixnum ___SYM(7,___S_fixnum)
#define ___SYM_flonum ___SYM(8,___S_flonum)
#define ___SYM_foreign ___SYM(9,___S_foreign)
#define ___SYM_forw ___SYM(10,___S_forw)
#define ___SYM_frame ___SYM(11,___S_frame)
#define ___SYM_imm ___SYM(12,___S_imm)
#define ___SYM_jazz ___SYM(13,___S_jazz)
#define ___SYM_keyword ___SYM(14,___S_keyword)
#define ___SYM_mem1 ___SYM(15,___S_mem1)
#define ___SYM_mem2 ___SYM(16,___S_mem2)
#define ___SYM_meroon ___SYM(17,___S_meroon)
#define ___SYM_movable0 ___SYM(18,___S_movable0)
#define ___SYM_movable1 ___SYM(19,___S_movable1)
#define ___SYM_movable2 ___SYM(20,___S_movable2)
#define ___SYM_pair ___SYM(21,___S_pair)
#define ___SYM_perm ___SYM(22,___S_perm)
#define ___SYM_procedure ___SYM(23,___S_procedure)
#define ___SYM_promise ___SYM(24,___S_promise)
#define ___SYM_ratnum ___SYM(25,___S_ratnum)
#define ___SYM_ref ___SYM(26,___S_ref)
#define ___SYM_return ___SYM(27,___S_return)
#define ___SYM_s16vector ___SYM(28,___S_s16vector)
#define ___SYM_s32vector ___SYM(29,___S_s32vector)
#define ___SYM_s64vector ___SYM(30,___S_s64vector)
#define ___SYM_s8vector ___SYM(31,___S_s8vector)
#define ___SYM_special ___SYM(32,___S_special)
#define ___SYM_still ___SYM(33,___S_still)
#define ___SYM_string ___SYM(34,___S_string)
#define ___SYM_structure ___SYM(35,___S_structure)
#define ___SYM_subtyped ___SYM(36,___S_subtyped)
#define ___SYM_symbol ___SYM(37,___S_symbol)
#define ___SYM_u16vector ___SYM(38,___S_u16vector)
#define ___SYM_u32vector ___SYM(39,___S_u32vector)
#define ___SYM_u64vector ___SYM(40,___S_u64vector)
#define ___SYM_u8vector ___SYM(41,___S_u8vector)
#define ___SYM_vector ___SYM(42,___S_vector)
#define ___SYM_weak ___SYM(43,___S_weak)

___BEGIN_GLO
___DEF_GLO(0,"_t-cpu-object-desc#")
___DEF_GLO(1,"c#absent-desc")
___DEF_GLO(2,"c#bignum-desc")
___DEF_GLO(3,"c#boxvalues-desc")
___DEF_GLO(4,"c#char-desc")
___DEF_GLO(5,"c#continuation-desc")
___DEF_GLO(6,"c#cpxnum-desc")
___DEF_GLO(7,"c#deleted-desc")
___DEF_GLO(8,"c#desc-encoder")
___DEF_GLO(9,"c#desc-encoder?")
___DEF_GLO(10,"c#desc-type")
___DEF_GLO(11,"c#desc-type-tag")
___DEF_GLO(12,"c#eof-desc")
___DEF_GLO(13,"c#f32vector-desc")
___DEF_GLO(14,"c#f64vector-desc")
___DEF_GLO(15,"c#fal-desc")
___DEF_GLO(16,"c#fixnum-desc")
___DEF_GLO(17,"c#flonum-desc")
___DEF_GLO(18,"c#foreign-desc")
___DEF_GLO(19,"c#frame-desc")
___DEF_GLO(20,"c#head-type-tag")
___DEF_GLO(21,"c#head-type-tag-bits")
___DEF_GLO(22,"c#head-type-tag-mask")
___DEF_GLO(23,"c#head-type-tags")
___DEF_GLO(24,"c#imm-desc")
___DEF_GLO(25,"c#imm-desc?")
___DEF_GLO(26,"c#imm-encode")
___DEF_GLO(27,"c#imm-encoder")
___DEF_GLO(28,"c#imm-encoder?")
___DEF_GLO(29,"c#imm-object?")
___DEF_GLO(30,"c#imm-type")
___DEF_GLO(31,"c#imm-type-tag")
___DEF_GLO(32,"c#imm-type?")
___DEF_GLO(33,"c#jazz-desc")
___DEF_GLO(34,"c#keyobj-desc")
___DEF_GLO(35,"c#keyword-desc")
___DEF_GLO(36,"c#length-mask")
___DEF_GLO(37,"c#meroon-desc")
___DEF_GLO(38,"c#nul-desc")
___DEF_GLO(39,"c#object->desc")
___DEF_GLO(40,"c#optional-desc")
___DEF_GLO(41,"c#pair-desc")
___DEF_GLO(42,"c#pointer-header-offset")
___DEF_GLO(43,"c#procedure-desc")
___DEF_GLO(44,"c#promise-desc")
___DEF_GLO(45,"c#ratnum-desc")
___DEF_GLO(46,"c#ref-desc")
___DEF_GLO(47,"c#ref-desc?")
___DEF_GLO(48,"c#ref-encode")
___DEF_GLO(49,"c#ref-encoder")
___DEF_GLO(50,"c#ref-encoder?")
___DEF_GLO(51,"c#ref-object?")
___DEF_GLO(52,"c#ref-subtype")
___DEF_GLO(53,"c#ref-subtype-tag")
___DEF_GLO(54,"c#ref-subtype?")
___DEF_GLO(55,"c#ref-type")
___DEF_GLO(56,"c#ref-type-tag")
___DEF_GLO(57,"c#ref-type?")
___DEF_GLO(58,"c#rest-desc")
___DEF_GLO(59,"c#return-desc")
___DEF_GLO(60,"c#s16vector-desc")
___DEF_GLO(61,"c#s32vector-desc")
___DEF_GLO(62,"c#s64vector-desc")
___DEF_GLO(63,"c#s8vector-desc")
___DEF_GLO(64,"c#special-desc")
___DEF_GLO(65,"c#string-desc")
___DEF_GLO(66,"c#structure-desc")
___DEF_GLO(67,"c#subtype-tag")
___DEF_GLO(68,"c#subtype-tag-bits")
___DEF_GLO(69,"c#subtype-tag-mask")
___DEF_GLO(70,"c#subtype-tags")
___DEF_GLO(71,"c#symbol-desc")
___DEF_GLO(72,"c#tagged-value")
___DEF_GLO(73,"c#tru-desc")
___DEF_GLO(74,"c#type-tag")
___DEF_GLO(75,"c#type-tag-bits")
___DEF_GLO(76,"c#type-tag-mask")
___DEF_GLO(77,"c#type-tags")
___DEF_GLO(78,"c#u16vector-desc")
___DEF_GLO(79,"c#u32vector-desc")
___DEF_GLO(80,"c#u64vector-desc")
___DEF_GLO(81,"c#u8vector-desc")
___DEF_GLO(82,"c#unb1-desc")
___DEF_GLO(83,"c#unb2-desc")
___DEF_GLO(84,"c#unused-desc")
___DEF_GLO(85,"c#vector-desc")
___DEF_GLO(86,"c#void-desc")
___DEF_GLO(87,"c#weak-desc")
___DEF_GLO(88,"+")
___DEF_GLO(89,"arithmetic-shift")
___DEF_GLO(90,"assq")
___DEF_GLO(91,"bitwise-not")
___DEF_GLO(92,"box?")
___DEF_GLO(93,"c#absent-object?")
___DEF_GLO(94,"c#compiler-internal-error")
___DEF_GLO(95,"c#deleted-object?")
___DEF_GLO(96,"c#end-of-file-object?")
___DEF_GLO(97,"c#key-object?")
___DEF_GLO(98,"c#optional-object?")
___DEF_GLO(99,"c#rest-object?")
___DEF_GLO(100,"c#structure-object?")
___DEF_GLO(101,"c#unbound1-object?")
___DEF_GLO(102,"c#unbound2-object?")
___DEF_GLO(103,"c#unused-object?")
___DEF_GLO(104,"c#void-object?")
___DEF_GLO(105,"cdr")
___DEF_GLO(106,"char->integer")
___DEF_GLO(107,"char?")
___DEF_GLO(108,"complex?")
___DEF_GLO(109,"continuation?")
___DEF_GLO(110,"eq?")
___DEF_GLO(111,"f32vector?")
___DEF_GLO(112,"f64vector?")
___DEF_GLO(113,"fixnum?")
___DEF_GLO(114,"flonum?")
___DEF_GLO(115,"foreign?")
___DEF_GLO(116,"fx+")
___DEF_GLO(117,"fx-")
___DEF_GLO(118,"fxarithmetic-shift")
___DEF_GLO(119,"integer?")
___DEF_GLO(120,"keyword?")
___DEF_GLO(121,"null?")
___DEF_GLO(122,"pair?")
___DEF_GLO(123,"procedure?")
___DEF_GLO(124,"promise?")
___DEF_GLO(125,"rational?")
___DEF_GLO(126,"s16vector?")
___DEF_GLO(127,"s32vector?")
___DEF_GLO(128,"s64vector?")
___DEF_GLO(129,"s8vector?")
___DEF_GLO(130,"string?")
___DEF_GLO(131,"symbol?")
___DEF_GLO(132,"u16vector?")
___DEF_GLO(133,"u32vector?")
___DEF_GLO(134,"u64vector?")
___DEF_GLO(135,"u8vector?")
___DEF_GLO(136,"vector")
___DEF_GLO(137,"vector-ref")
___DEF_GLO(138,"vector?")
___END_GLO

#define ___GLO___t_2d_cpu_2d_object_2d_desc_23_ ___GLO(0,___G___t_2d_cpu_2d_object_2d_desc_23_)
#define ___PRM___t_2d_cpu_2d_object_2d_desc_23_ ___PRM(0,___G___t_2d_cpu_2d_object_2d_desc_23_)
#define ___GLO_c_23_absent_2d_desc ___GLO(1,___G_c_23_absent_2d_desc)
#define ___PRM_c_23_absent_2d_desc ___PRM(1,___G_c_23_absent_2d_desc)
#define ___GLO_c_23_bignum_2d_desc ___GLO(2,___G_c_23_bignum_2d_desc)
#define ___PRM_c_23_bignum_2d_desc ___PRM(2,___G_c_23_bignum_2d_desc)
#define ___GLO_c_23_boxvalues_2d_desc ___GLO(3,___G_c_23_boxvalues_2d_desc)
#define ___PRM_c_23_boxvalues_2d_desc ___PRM(3,___G_c_23_boxvalues_2d_desc)
#define ___GLO_c_23_char_2d_desc ___GLO(4,___G_c_23_char_2d_desc)
#define ___PRM_c_23_char_2d_desc ___PRM(4,___G_c_23_char_2d_desc)
#define ___GLO_c_23_continuation_2d_desc ___GLO(5,___G_c_23_continuation_2d_desc)
#define ___PRM_c_23_continuation_2d_desc ___PRM(5,___G_c_23_continuation_2d_desc)
#define ___GLO_c_23_cpxnum_2d_desc ___GLO(6,___G_c_23_cpxnum_2d_desc)
#define ___PRM_c_23_cpxnum_2d_desc ___PRM(6,___G_c_23_cpxnum_2d_desc)
#define ___GLO_c_23_deleted_2d_desc ___GLO(7,___G_c_23_deleted_2d_desc)
#define ___PRM_c_23_deleted_2d_desc ___PRM(7,___G_c_23_deleted_2d_desc)
#define ___GLO_c_23_desc_2d_encoder ___GLO(8,___G_c_23_desc_2d_encoder)
#define ___PRM_c_23_desc_2d_encoder ___PRM(8,___G_c_23_desc_2d_encoder)
#define ___GLO_c_23_desc_2d_encoder_3f_ ___GLO(9,___G_c_23_desc_2d_encoder_3f_)
#define ___PRM_c_23_desc_2d_encoder_3f_ ___PRM(9,___G_c_23_desc_2d_encoder_3f_)
#define ___GLO_c_23_desc_2d_type ___GLO(10,___G_c_23_desc_2d_type)
#define ___PRM_c_23_desc_2d_type ___PRM(10,___G_c_23_desc_2d_type)
#define ___GLO_c_23_desc_2d_type_2d_tag ___GLO(11,___G_c_23_desc_2d_type_2d_tag)
#define ___PRM_c_23_desc_2d_type_2d_tag ___PRM(11,___G_c_23_desc_2d_type_2d_tag)
#define ___GLO_c_23_eof_2d_desc ___GLO(12,___G_c_23_eof_2d_desc)
#define ___PRM_c_23_eof_2d_desc ___PRM(12,___G_c_23_eof_2d_desc)
#define ___GLO_c_23_f32vector_2d_desc ___GLO(13,___G_c_23_f32vector_2d_desc)
#define ___PRM_c_23_f32vector_2d_desc ___PRM(13,___G_c_23_f32vector_2d_desc)
#define ___GLO_c_23_f64vector_2d_desc ___GLO(14,___G_c_23_f64vector_2d_desc)
#define ___PRM_c_23_f64vector_2d_desc ___PRM(14,___G_c_23_f64vector_2d_desc)
#define ___GLO_c_23_fal_2d_desc ___GLO(15,___G_c_23_fal_2d_desc)
#define ___PRM_c_23_fal_2d_desc ___PRM(15,___G_c_23_fal_2d_desc)
#define ___GLO_c_23_fixnum_2d_desc ___GLO(16,___G_c_23_fixnum_2d_desc)
#define ___PRM_c_23_fixnum_2d_desc ___PRM(16,___G_c_23_fixnum_2d_desc)
#define ___GLO_c_23_flonum_2d_desc ___GLO(17,___G_c_23_flonum_2d_desc)
#define ___PRM_c_23_flonum_2d_desc ___PRM(17,___G_c_23_flonum_2d_desc)
#define ___GLO_c_23_foreign_2d_desc ___GLO(18,___G_c_23_foreign_2d_desc)
#define ___PRM_c_23_foreign_2d_desc ___PRM(18,___G_c_23_foreign_2d_desc)
#define ___GLO_c_23_frame_2d_desc ___GLO(19,___G_c_23_frame_2d_desc)
#define ___PRM_c_23_frame_2d_desc ___PRM(19,___G_c_23_frame_2d_desc)
#define ___GLO_c_23_head_2d_type_2d_tag ___GLO(20,___G_c_23_head_2d_type_2d_tag)
#define ___PRM_c_23_head_2d_type_2d_tag ___PRM(20,___G_c_23_head_2d_type_2d_tag)
#define ___GLO_c_23_head_2d_type_2d_tag_2d_bits ___GLO(21,___G_c_23_head_2d_type_2d_tag_2d_bits)
#define ___PRM_c_23_head_2d_type_2d_tag_2d_bits ___PRM(21,___G_c_23_head_2d_type_2d_tag_2d_bits)
#define ___GLO_c_23_head_2d_type_2d_tag_2d_mask ___GLO(22,___G_c_23_head_2d_type_2d_tag_2d_mask)
#define ___PRM_c_23_head_2d_type_2d_tag_2d_mask ___PRM(22,___G_c_23_head_2d_type_2d_tag_2d_mask)
#define ___GLO_c_23_head_2d_type_2d_tags ___GLO(23,___G_c_23_head_2d_type_2d_tags)
#define ___PRM_c_23_head_2d_type_2d_tags ___PRM(23,___G_c_23_head_2d_type_2d_tags)
#define ___GLO_c_23_imm_2d_desc ___GLO(24,___G_c_23_imm_2d_desc)
#define ___PRM_c_23_imm_2d_desc ___PRM(24,___G_c_23_imm_2d_desc)
#define ___GLO_c_23_imm_2d_desc_3f_ ___GLO(25,___G_c_23_imm_2d_desc_3f_)
#define ___PRM_c_23_imm_2d_desc_3f_ ___PRM(25,___G_c_23_imm_2d_desc_3f_)
#define ___GLO_c_23_imm_2d_encode ___GLO(26,___G_c_23_imm_2d_encode)
#define ___PRM_c_23_imm_2d_encode ___PRM(26,___G_c_23_imm_2d_encode)
#define ___GLO_c_23_imm_2d_encoder ___GLO(27,___G_c_23_imm_2d_encoder)
#define ___PRM_c_23_imm_2d_encoder ___PRM(27,___G_c_23_imm_2d_encoder)
#define ___GLO_c_23_imm_2d_encoder_3f_ ___GLO(28,___G_c_23_imm_2d_encoder_3f_)
#define ___PRM_c_23_imm_2d_encoder_3f_ ___PRM(28,___G_c_23_imm_2d_encoder_3f_)
#define ___GLO_c_23_imm_2d_object_3f_ ___GLO(29,___G_c_23_imm_2d_object_3f_)
#define ___PRM_c_23_imm_2d_object_3f_ ___PRM(29,___G_c_23_imm_2d_object_3f_)
#define ___GLO_c_23_imm_2d_type ___GLO(30,___G_c_23_imm_2d_type)
#define ___PRM_c_23_imm_2d_type ___PRM(30,___G_c_23_imm_2d_type)
#define ___GLO_c_23_imm_2d_type_2d_tag ___GLO(31,___G_c_23_imm_2d_type_2d_tag)
#define ___PRM_c_23_imm_2d_type_2d_tag ___PRM(31,___G_c_23_imm_2d_type_2d_tag)
#define ___GLO_c_23_imm_2d_type_3f_ ___GLO(32,___G_c_23_imm_2d_type_3f_)
#define ___PRM_c_23_imm_2d_type_3f_ ___PRM(32,___G_c_23_imm_2d_type_3f_)
#define ___GLO_c_23_jazz_2d_desc ___GLO(33,___G_c_23_jazz_2d_desc)
#define ___PRM_c_23_jazz_2d_desc ___PRM(33,___G_c_23_jazz_2d_desc)
#define ___GLO_c_23_keyobj_2d_desc ___GLO(34,___G_c_23_keyobj_2d_desc)
#define ___PRM_c_23_keyobj_2d_desc ___PRM(34,___G_c_23_keyobj_2d_desc)
#define ___GLO_c_23_keyword_2d_desc ___GLO(35,___G_c_23_keyword_2d_desc)
#define ___PRM_c_23_keyword_2d_desc ___PRM(35,___G_c_23_keyword_2d_desc)
#define ___GLO_c_23_length_2d_mask ___GLO(36,___G_c_23_length_2d_mask)
#define ___PRM_c_23_length_2d_mask ___PRM(36,___G_c_23_length_2d_mask)
#define ___GLO_c_23_meroon_2d_desc ___GLO(37,___G_c_23_meroon_2d_desc)
#define ___PRM_c_23_meroon_2d_desc ___PRM(37,___G_c_23_meroon_2d_desc)
#define ___GLO_c_23_nul_2d_desc ___GLO(38,___G_c_23_nul_2d_desc)
#define ___PRM_c_23_nul_2d_desc ___PRM(38,___G_c_23_nul_2d_desc)
#define ___GLO_c_23_object_2d__3e_desc ___GLO(39,___G_c_23_object_2d__3e_desc)
#define ___PRM_c_23_object_2d__3e_desc ___PRM(39,___G_c_23_object_2d__3e_desc)
#define ___GLO_c_23_optional_2d_desc ___GLO(40,___G_c_23_optional_2d_desc)
#define ___PRM_c_23_optional_2d_desc ___PRM(40,___G_c_23_optional_2d_desc)
#define ___GLO_c_23_pair_2d_desc ___GLO(41,___G_c_23_pair_2d_desc)
#define ___PRM_c_23_pair_2d_desc ___PRM(41,___G_c_23_pair_2d_desc)
#define ___GLO_c_23_pointer_2d_header_2d_offset ___GLO(42,___G_c_23_pointer_2d_header_2d_offset)
#define ___PRM_c_23_pointer_2d_header_2d_offset ___PRM(42,___G_c_23_pointer_2d_header_2d_offset)
#define ___GLO_c_23_procedure_2d_desc ___GLO(43,___G_c_23_procedure_2d_desc)
#define ___PRM_c_23_procedure_2d_desc ___PRM(43,___G_c_23_procedure_2d_desc)
#define ___GLO_c_23_promise_2d_desc ___GLO(44,___G_c_23_promise_2d_desc)
#define ___PRM_c_23_promise_2d_desc ___PRM(44,___G_c_23_promise_2d_desc)
#define ___GLO_c_23_ratnum_2d_desc ___GLO(45,___G_c_23_ratnum_2d_desc)
#define ___PRM_c_23_ratnum_2d_desc ___PRM(45,___G_c_23_ratnum_2d_desc)
#define ___GLO_c_23_ref_2d_desc ___GLO(46,___G_c_23_ref_2d_desc)
#define ___PRM_c_23_ref_2d_desc ___PRM(46,___G_c_23_ref_2d_desc)
#define ___GLO_c_23_ref_2d_desc_3f_ ___GLO(47,___G_c_23_ref_2d_desc_3f_)
#define ___PRM_c_23_ref_2d_desc_3f_ ___PRM(47,___G_c_23_ref_2d_desc_3f_)
#define ___GLO_c_23_ref_2d_encode ___GLO(48,___G_c_23_ref_2d_encode)
#define ___PRM_c_23_ref_2d_encode ___PRM(48,___G_c_23_ref_2d_encode)
#define ___GLO_c_23_ref_2d_encoder ___GLO(49,___G_c_23_ref_2d_encoder)
#define ___PRM_c_23_ref_2d_encoder ___PRM(49,___G_c_23_ref_2d_encoder)
#define ___GLO_c_23_ref_2d_encoder_3f_ ___GLO(50,___G_c_23_ref_2d_encoder_3f_)
#define ___PRM_c_23_ref_2d_encoder_3f_ ___PRM(50,___G_c_23_ref_2d_encoder_3f_)
#define ___GLO_c_23_ref_2d_object_3f_ ___GLO(51,___G_c_23_ref_2d_object_3f_)
#define ___PRM_c_23_ref_2d_object_3f_ ___PRM(51,___G_c_23_ref_2d_object_3f_)
#define ___GLO_c_23_ref_2d_subtype ___GLO(52,___G_c_23_ref_2d_subtype)
#define ___PRM_c_23_ref_2d_subtype ___PRM(52,___G_c_23_ref_2d_subtype)
#define ___GLO_c_23_ref_2d_subtype_2d_tag ___GLO(53,___G_c_23_ref_2d_subtype_2d_tag)
#define ___PRM_c_23_ref_2d_subtype_2d_tag ___PRM(53,___G_c_23_ref_2d_subtype_2d_tag)
#define ___GLO_c_23_ref_2d_subtype_3f_ ___GLO(54,___G_c_23_ref_2d_subtype_3f_)
#define ___PRM_c_23_ref_2d_subtype_3f_ ___PRM(54,___G_c_23_ref_2d_subtype_3f_)
#define ___GLO_c_23_ref_2d_type ___GLO(55,___G_c_23_ref_2d_type)
#define ___PRM_c_23_ref_2d_type ___PRM(55,___G_c_23_ref_2d_type)
#define ___GLO_c_23_ref_2d_type_2d_tag ___GLO(56,___G_c_23_ref_2d_type_2d_tag)
#define ___PRM_c_23_ref_2d_type_2d_tag ___PRM(56,___G_c_23_ref_2d_type_2d_tag)
#define ___GLO_c_23_ref_2d_type_3f_ ___GLO(57,___G_c_23_ref_2d_type_3f_)
#define ___PRM_c_23_ref_2d_type_3f_ ___PRM(57,___G_c_23_ref_2d_type_3f_)
#define ___GLO_c_23_rest_2d_desc ___GLO(58,___G_c_23_rest_2d_desc)
#define ___PRM_c_23_rest_2d_desc ___PRM(58,___G_c_23_rest_2d_desc)
#define ___GLO_c_23_return_2d_desc ___GLO(59,___G_c_23_return_2d_desc)
#define ___PRM_c_23_return_2d_desc ___PRM(59,___G_c_23_return_2d_desc)
#define ___GLO_c_23_s16vector_2d_desc ___GLO(60,___G_c_23_s16vector_2d_desc)
#define ___PRM_c_23_s16vector_2d_desc ___PRM(60,___G_c_23_s16vector_2d_desc)
#define ___GLO_c_23_s32vector_2d_desc ___GLO(61,___G_c_23_s32vector_2d_desc)
#define ___PRM_c_23_s32vector_2d_desc ___PRM(61,___G_c_23_s32vector_2d_desc)
#define ___GLO_c_23_s64vector_2d_desc ___GLO(62,___G_c_23_s64vector_2d_desc)
#define ___PRM_c_23_s64vector_2d_desc ___PRM(62,___G_c_23_s64vector_2d_desc)
#define ___GLO_c_23_s8vector_2d_desc ___GLO(63,___G_c_23_s8vector_2d_desc)
#define ___PRM_c_23_s8vector_2d_desc ___PRM(63,___G_c_23_s8vector_2d_desc)
#define ___GLO_c_23_special_2d_desc ___GLO(64,___G_c_23_special_2d_desc)
#define ___PRM_c_23_special_2d_desc ___PRM(64,___G_c_23_special_2d_desc)
#define ___GLO_c_23_string_2d_desc ___GLO(65,___G_c_23_string_2d_desc)
#define ___PRM_c_23_string_2d_desc ___PRM(65,___G_c_23_string_2d_desc)
#define ___GLO_c_23_structure_2d_desc ___GLO(66,___G_c_23_structure_2d_desc)
#define ___PRM_c_23_structure_2d_desc ___PRM(66,___G_c_23_structure_2d_desc)
#define ___GLO_c_23_subtype_2d_tag ___GLO(67,___G_c_23_subtype_2d_tag)
#define ___PRM_c_23_subtype_2d_tag ___PRM(67,___G_c_23_subtype_2d_tag)
#define ___GLO_c_23_subtype_2d_tag_2d_bits ___GLO(68,___G_c_23_subtype_2d_tag_2d_bits)
#define ___PRM_c_23_subtype_2d_tag_2d_bits ___PRM(68,___G_c_23_subtype_2d_tag_2d_bits)
#define ___GLO_c_23_subtype_2d_tag_2d_mask ___GLO(69,___G_c_23_subtype_2d_tag_2d_mask)
#define ___PRM_c_23_subtype_2d_tag_2d_mask ___PRM(69,___G_c_23_subtype_2d_tag_2d_mask)
#define ___GLO_c_23_subtype_2d_tags ___GLO(70,___G_c_23_subtype_2d_tags)
#define ___PRM_c_23_subtype_2d_tags ___PRM(70,___G_c_23_subtype_2d_tags)
#define ___GLO_c_23_symbol_2d_desc ___GLO(71,___G_c_23_symbol_2d_desc)
#define ___PRM_c_23_symbol_2d_desc ___PRM(71,___G_c_23_symbol_2d_desc)
#define ___GLO_c_23_tagged_2d_value ___GLO(72,___G_c_23_tagged_2d_value)
#define ___PRM_c_23_tagged_2d_value ___PRM(72,___G_c_23_tagged_2d_value)
#define ___GLO_c_23_tru_2d_desc ___GLO(73,___G_c_23_tru_2d_desc)
#define ___PRM_c_23_tru_2d_desc ___PRM(73,___G_c_23_tru_2d_desc)
#define ___GLO_c_23_type_2d_tag ___GLO(74,___G_c_23_type_2d_tag)
#define ___PRM_c_23_type_2d_tag ___PRM(74,___G_c_23_type_2d_tag)
#define ___GLO_c_23_type_2d_tag_2d_bits ___GLO(75,___G_c_23_type_2d_tag_2d_bits)
#define ___PRM_c_23_type_2d_tag_2d_bits ___PRM(75,___G_c_23_type_2d_tag_2d_bits)
#define ___GLO_c_23_type_2d_tag_2d_mask ___GLO(76,___G_c_23_type_2d_tag_2d_mask)
#define ___PRM_c_23_type_2d_tag_2d_mask ___PRM(76,___G_c_23_type_2d_tag_2d_mask)
#define ___GLO_c_23_type_2d_tags ___GLO(77,___G_c_23_type_2d_tags)
#define ___PRM_c_23_type_2d_tags ___PRM(77,___G_c_23_type_2d_tags)
#define ___GLO_c_23_u16vector_2d_desc ___GLO(78,___G_c_23_u16vector_2d_desc)
#define ___PRM_c_23_u16vector_2d_desc ___PRM(78,___G_c_23_u16vector_2d_desc)
#define ___GLO_c_23_u32vector_2d_desc ___GLO(79,___G_c_23_u32vector_2d_desc)
#define ___PRM_c_23_u32vector_2d_desc ___PRM(79,___G_c_23_u32vector_2d_desc)
#define ___GLO_c_23_u64vector_2d_desc ___GLO(80,___G_c_23_u64vector_2d_desc)
#define ___PRM_c_23_u64vector_2d_desc ___PRM(80,___G_c_23_u64vector_2d_desc)
#define ___GLO_c_23_u8vector_2d_desc ___GLO(81,___G_c_23_u8vector_2d_desc)
#define ___PRM_c_23_u8vector_2d_desc ___PRM(81,___G_c_23_u8vector_2d_desc)
#define ___GLO_c_23_unb1_2d_desc ___GLO(82,___G_c_23_unb1_2d_desc)
#define ___PRM_c_23_unb1_2d_desc ___PRM(82,___G_c_23_unb1_2d_desc)
#define ___GLO_c_23_unb2_2d_desc ___GLO(83,___G_c_23_unb2_2d_desc)
#define ___PRM_c_23_unb2_2d_desc ___PRM(83,___G_c_23_unb2_2d_desc)
#define ___GLO_c_23_unused_2d_desc ___GLO(84,___G_c_23_unused_2d_desc)
#define ___PRM_c_23_unused_2d_desc ___PRM(84,___G_c_23_unused_2d_desc)
#define ___GLO_c_23_vector_2d_desc ___GLO(85,___G_c_23_vector_2d_desc)
#define ___PRM_c_23_vector_2d_desc ___PRM(85,___G_c_23_vector_2d_desc)
#define ___GLO_c_23_void_2d_desc ___GLO(86,___G_c_23_void_2d_desc)
#define ___PRM_c_23_void_2d_desc ___PRM(86,___G_c_23_void_2d_desc)
#define ___GLO_c_23_weak_2d_desc ___GLO(87,___G_c_23_weak_2d_desc)
#define ___PRM_c_23_weak_2d_desc ___PRM(87,___G_c_23_weak_2d_desc)
#define ___GLO__2b_ ___GLO(88,___G__2b_)
#define ___PRM__2b_ ___PRM(88,___G__2b_)
#define ___GLO_arithmetic_2d_shift ___GLO(89,___G_arithmetic_2d_shift)
#define ___PRM_arithmetic_2d_shift ___PRM(89,___G_arithmetic_2d_shift)
#define ___GLO_assq ___GLO(90,___G_assq)
#define ___PRM_assq ___PRM(90,___G_assq)
#define ___GLO_bitwise_2d_not ___GLO(91,___G_bitwise_2d_not)
#define ___PRM_bitwise_2d_not ___PRM(91,___G_bitwise_2d_not)
#define ___GLO_box_3f_ ___GLO(92,___G_box_3f_)
#define ___PRM_box_3f_ ___PRM(92,___G_box_3f_)
#define ___GLO_c_23_absent_2d_object_3f_ ___GLO(93,___G_c_23_absent_2d_object_3f_)
#define ___PRM_c_23_absent_2d_object_3f_ ___PRM(93,___G_c_23_absent_2d_object_3f_)
#define ___GLO_c_23_compiler_2d_internal_2d_error ___GLO(94,___G_c_23_compiler_2d_internal_2d_error)
#define ___PRM_c_23_compiler_2d_internal_2d_error ___PRM(94,___G_c_23_compiler_2d_internal_2d_error)
#define ___GLO_c_23_deleted_2d_object_3f_ ___GLO(95,___G_c_23_deleted_2d_object_3f_)
#define ___PRM_c_23_deleted_2d_object_3f_ ___PRM(95,___G_c_23_deleted_2d_object_3f_)
#define ___GLO_c_23_end_2d_of_2d_file_2d_object_3f_ ___GLO(96,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___PRM_c_23_end_2d_of_2d_file_2d_object_3f_ ___PRM(96,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___GLO_c_23_key_2d_object_3f_ ___GLO(97,___G_c_23_key_2d_object_3f_)
#define ___PRM_c_23_key_2d_object_3f_ ___PRM(97,___G_c_23_key_2d_object_3f_)
#define ___GLO_c_23_optional_2d_object_3f_ ___GLO(98,___G_c_23_optional_2d_object_3f_)
#define ___PRM_c_23_optional_2d_object_3f_ ___PRM(98,___G_c_23_optional_2d_object_3f_)
#define ___GLO_c_23_rest_2d_object_3f_ ___GLO(99,___G_c_23_rest_2d_object_3f_)
#define ___PRM_c_23_rest_2d_object_3f_ ___PRM(99,___G_c_23_rest_2d_object_3f_)
#define ___GLO_c_23_structure_2d_object_3f_ ___GLO(100,___G_c_23_structure_2d_object_3f_)
#define ___PRM_c_23_structure_2d_object_3f_ ___PRM(100,___G_c_23_structure_2d_object_3f_)
#define ___GLO_c_23_unbound1_2d_object_3f_ ___GLO(101,___G_c_23_unbound1_2d_object_3f_)
#define ___PRM_c_23_unbound1_2d_object_3f_ ___PRM(101,___G_c_23_unbound1_2d_object_3f_)
#define ___GLO_c_23_unbound2_2d_object_3f_ ___GLO(102,___G_c_23_unbound2_2d_object_3f_)
#define ___PRM_c_23_unbound2_2d_object_3f_ ___PRM(102,___G_c_23_unbound2_2d_object_3f_)
#define ___GLO_c_23_unused_2d_object_3f_ ___GLO(103,___G_c_23_unused_2d_object_3f_)
#define ___PRM_c_23_unused_2d_object_3f_ ___PRM(103,___G_c_23_unused_2d_object_3f_)
#define ___GLO_c_23_void_2d_object_3f_ ___GLO(104,___G_c_23_void_2d_object_3f_)
#define ___PRM_c_23_void_2d_object_3f_ ___PRM(104,___G_c_23_void_2d_object_3f_)
#define ___GLO_cdr ___GLO(105,___G_cdr)
#define ___PRM_cdr ___PRM(105,___G_cdr)
#define ___GLO_char_2d__3e_integer ___GLO(106,___G_char_2d__3e_integer)
#define ___PRM_char_2d__3e_integer ___PRM(106,___G_char_2d__3e_integer)
#define ___GLO_char_3f_ ___GLO(107,___G_char_3f_)
#define ___PRM_char_3f_ ___PRM(107,___G_char_3f_)
#define ___GLO_complex_3f_ ___GLO(108,___G_complex_3f_)
#define ___PRM_complex_3f_ ___PRM(108,___G_complex_3f_)
#define ___GLO_continuation_3f_ ___GLO(109,___G_continuation_3f_)
#define ___PRM_continuation_3f_ ___PRM(109,___G_continuation_3f_)
#define ___GLO_eq_3f_ ___GLO(110,___G_eq_3f_)
#define ___PRM_eq_3f_ ___PRM(110,___G_eq_3f_)
#define ___GLO_f32vector_3f_ ___GLO(111,___G_f32vector_3f_)
#define ___PRM_f32vector_3f_ ___PRM(111,___G_f32vector_3f_)
#define ___GLO_f64vector_3f_ ___GLO(112,___G_f64vector_3f_)
#define ___PRM_f64vector_3f_ ___PRM(112,___G_f64vector_3f_)
#define ___GLO_fixnum_3f_ ___GLO(113,___G_fixnum_3f_)
#define ___PRM_fixnum_3f_ ___PRM(113,___G_fixnum_3f_)
#define ___GLO_flonum_3f_ ___GLO(114,___G_flonum_3f_)
#define ___PRM_flonum_3f_ ___PRM(114,___G_flonum_3f_)
#define ___GLO_foreign_3f_ ___GLO(115,___G_foreign_3f_)
#define ___PRM_foreign_3f_ ___PRM(115,___G_foreign_3f_)
#define ___GLO_fx_2b_ ___GLO(116,___G_fx_2b_)
#define ___PRM_fx_2b_ ___PRM(116,___G_fx_2b_)
#define ___GLO_fx_2d_ ___GLO(117,___G_fx_2d_)
#define ___PRM_fx_2d_ ___PRM(117,___G_fx_2d_)
#define ___GLO_fxarithmetic_2d_shift ___GLO(118,___G_fxarithmetic_2d_shift)
#define ___PRM_fxarithmetic_2d_shift ___PRM(118,___G_fxarithmetic_2d_shift)
#define ___GLO_integer_3f_ ___GLO(119,___G_integer_3f_)
#define ___PRM_integer_3f_ ___PRM(119,___G_integer_3f_)
#define ___GLO_keyword_3f_ ___GLO(120,___G_keyword_3f_)
#define ___PRM_keyword_3f_ ___PRM(120,___G_keyword_3f_)
#define ___GLO_null_3f_ ___GLO(121,___G_null_3f_)
#define ___PRM_null_3f_ ___PRM(121,___G_null_3f_)
#define ___GLO_pair_3f_ ___GLO(122,___G_pair_3f_)
#define ___PRM_pair_3f_ ___PRM(122,___G_pair_3f_)
#define ___GLO_procedure_3f_ ___GLO(123,___G_procedure_3f_)
#define ___PRM_procedure_3f_ ___PRM(123,___G_procedure_3f_)
#define ___GLO_promise_3f_ ___GLO(124,___G_promise_3f_)
#define ___PRM_promise_3f_ ___PRM(124,___G_promise_3f_)
#define ___GLO_rational_3f_ ___GLO(125,___G_rational_3f_)
#define ___PRM_rational_3f_ ___PRM(125,___G_rational_3f_)
#define ___GLO_s16vector_3f_ ___GLO(126,___G_s16vector_3f_)
#define ___PRM_s16vector_3f_ ___PRM(126,___G_s16vector_3f_)
#define ___GLO_s32vector_3f_ ___GLO(127,___G_s32vector_3f_)
#define ___PRM_s32vector_3f_ ___PRM(127,___G_s32vector_3f_)
#define ___GLO_s64vector_3f_ ___GLO(128,___G_s64vector_3f_)
#define ___PRM_s64vector_3f_ ___PRM(128,___G_s64vector_3f_)
#define ___GLO_s8vector_3f_ ___GLO(129,___G_s8vector_3f_)
#define ___PRM_s8vector_3f_ ___PRM(129,___G_s8vector_3f_)
#define ___GLO_string_3f_ ___GLO(130,___G_string_3f_)
#define ___PRM_string_3f_ ___PRM(130,___G_string_3f_)
#define ___GLO_symbol_3f_ ___GLO(131,___G_symbol_3f_)
#define ___PRM_symbol_3f_ ___PRM(131,___G_symbol_3f_)
#define ___GLO_u16vector_3f_ ___GLO(132,___G_u16vector_3f_)
#define ___PRM_u16vector_3f_ ___PRM(132,___G_u16vector_3f_)
#define ___GLO_u32vector_3f_ ___GLO(133,___G_u32vector_3f_)
#define ___PRM_u32vector_3f_ ___PRM(133,___G_u32vector_3f_)
#define ___GLO_u64vector_3f_ ___GLO(134,___G_u64vector_3f_)
#define ___PRM_u64vector_3f_ ___PRM(134,___G_u64vector_3f_)
#define ___GLO_u8vector_3f_ ___GLO(135,___G_u8vector_3f_)
#define ___PRM_u8vector_3f_ ___PRM(135,___G_u8vector_3f_)
#define ___GLO_vector ___GLO(136,___G_vector)
#define ___PRM_vector ___PRM(136,___G_vector)
#define ___GLO_vector_2d_ref ___GLO(137,___G_vector_2d_ref)
#define ___PRM_vector_2d_ref ___PRM(137,___G_vector_2d_ref)
#define ___GLO_vector_3f_ ___GLO(138,___G_vector_3f_)
#define ___PRM_vector_3f_ ___PRM(138,___G_vector_3f_)

___BEGIN_CNS
 ___DEF_CNS(___REF_CNS(1),___REF_CNS(2))
,___DEF_CNS(___REF_SYM(7,___S_fixnum),___REF_FIX(0))
,___DEF_CNS(___REF_CNS(3),___REF_CNS(4))
,___DEF_CNS(___REF_SYM(32,___S_special),___REF_FIX(2))
,___DEF_CNS(___REF_CNS(5),___REF_CNS(6))
,___DEF_CNS(___REF_SYM(15,___S_mem1),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(7),___REF_CNS(8))
,___DEF_CNS(___REF_SYM(16,___S_mem2),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(9),___REF_CNS(10))
,___DEF_CNS(___REF_SYM(36,___S_subtyped),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(11),___REF_NUL)
,___DEF_CNS(___REF_SYM(21,___S_pair),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(13),___REF_CNS(14))
,___DEF_CNS(___REF_SYM(18,___S_movable0),___REF_FIX(0))
,___DEF_CNS(___REF_CNS(15),___REF_CNS(16))
,___DEF_CNS(___REF_SYM(19,___S_movable1),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(17),___REF_CNS(18))
,___DEF_CNS(___REF_SYM(20,___S_movable2),___REF_FIX(2))
,___DEF_CNS(___REF_CNS(19),___REF_CNS(20))
,___DEF_CNS(___REF_SYM(10,___S_forw),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(21),___REF_CNS(22))
,___DEF_CNS(___REF_SYM(33,___S_still),___REF_FIX(5))
,___DEF_CNS(___REF_CNS(23),___REF_NUL)
,___DEF_CNS(___REF_SYM(22,___S_perm),___REF_FIX(6))
,___DEF_CNS(___REF_CNS(25),___REF_CNS(26))
,___DEF_CNS(___REF_SYM(42,___S_vector),___REF_FIX(0))
,___DEF_CNS(___REF_CNS(27),___REF_CNS(28))
,___DEF_CNS(___REF_SYM(21,___S_pair),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(29),___REF_CNS(30))
,___DEF_CNS(___REF_SYM(25,___S_ratnum),___REF_FIX(2))
,___DEF_CNS(___REF_CNS(31),___REF_CNS(32))
,___DEF_CNS(___REF_SYM(4,___S_cpxnum),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(33),___REF_CNS(34))
,___DEF_CNS(___REF_SYM(35,___S_structure),___REF_FIX(4))
,___DEF_CNS(___REF_CNS(35),___REF_CNS(36))
,___DEF_CNS(___REF_SYM(2,___S_boxvalues),___REF_FIX(5))
,___DEF_CNS(___REF_CNS(37),___REF_CNS(38))
,___DEF_CNS(___REF_SYM(17,___S_meroon),___REF_FIX(6))
,___DEF_CNS(___REF_CNS(39),___REF_CNS(40))
,___DEF_CNS(___REF_SYM(13,___S_jazz),___REF_FIX(7))
,___DEF_CNS(___REF_CNS(41),___REF_CNS(42))
,___DEF_CNS(___REF_SYM(37,___S_symbol),___REF_FIX(8))
,___DEF_CNS(___REF_CNS(43),___REF_CNS(44))
,___DEF_CNS(___REF_SYM(14,___S_keyword),___REF_FIX(9))
,___DEF_CNS(___REF_CNS(45),___REF_CNS(46))
,___DEF_CNS(___REF_SYM(11,___S_frame),___REF_FIX(10))
,___DEF_CNS(___REF_CNS(47),___REF_CNS(48))
,___DEF_CNS(___REF_SYM(3,___S_continuation),___REF_FIX(11))
,___DEF_CNS(___REF_CNS(49),___REF_CNS(50))
,___DEF_CNS(___REF_SYM(24,___S_promise),___REF_FIX(12))
,___DEF_CNS(___REF_CNS(51),___REF_CNS(52))
,___DEF_CNS(___REF_SYM(43,___S_weak),___REF_FIX(13))
,___DEF_CNS(___REF_CNS(53),___REF_CNS(54))
,___DEF_CNS(___REF_SYM(23,___S_procedure),___REF_FIX(14))
,___DEF_CNS(___REF_CNS(55),___REF_CNS(56))
,___DEF_CNS(___REF_SYM(27,___S_return),___REF_FIX(15))
,___DEF_CNS(___REF_CNS(57),___REF_CNS(58))
,___DEF_CNS(___REF_SYM(9,___S_foreign),___REF_FIX(18))
,___DEF_CNS(___REF_CNS(59),___REF_CNS(60))
,___DEF_CNS(___REF_SYM(34,___S_string),___REF_FIX(19))
,___DEF_CNS(___REF_CNS(61),___REF_CNS(62))
,___DEF_CNS(___REF_SYM(31,___S_s8vector),___REF_FIX(20))
,___DEF_CNS(___REF_CNS(63),___REF_CNS(64))
,___DEF_CNS(___REF_SYM(41,___S_u8vector),___REF_FIX(21))
,___DEF_CNS(___REF_CNS(65),___REF_CNS(66))
,___DEF_CNS(___REF_SYM(28,___S_s16vector),___REF_FIX(22))
,___DEF_CNS(___REF_CNS(67),___REF_CNS(68))
,___DEF_CNS(___REF_SYM(38,___S_u16vector),___REF_FIX(23))
,___DEF_CNS(___REF_CNS(69),___REF_CNS(70))
,___DEF_CNS(___REF_SYM(29,___S_s32vector),___REF_FIX(24))
,___DEF_CNS(___REF_CNS(71),___REF_CNS(72))
,___DEF_CNS(___REF_SYM(39,___S_u32vector),___REF_FIX(25))
,___DEF_CNS(___REF_CNS(73),___REF_CNS(74))
,___DEF_CNS(___REF_SYM(5,___S_f32vector),___REF_FIX(26))
,___DEF_CNS(___REF_CNS(75),___REF_CNS(76))
,___DEF_CNS(___REF_SYM(30,___S_s64vector),___REF_FIX(27))
,___DEF_CNS(___REF_CNS(77),___REF_CNS(78))
,___DEF_CNS(___REF_SYM(40,___S_u64vector),___REF_FIX(28))
,___DEF_CNS(___REF_CNS(79),___REF_CNS(80))
,___DEF_CNS(___REF_SYM(6,___S_f64vector),___REF_FIX(29))
,___DEF_CNS(___REF_CNS(81),___REF_CNS(82))
,___DEF_CNS(___REF_SYM(8,___S_flonum),___REF_FIX(30))
,___DEF_CNS(___REF_CNS(83),___REF_NUL)
,___DEF_CNS(___REF_SYM(1,___S_bignum),___REF_FIX(31))
___END_CNS

___DEF_SUB_STR(___X0,39UL)
               ___STR8(111,98,106,101,99,116,45,62)
               ___STR8(100,101,115,99,44,32,110,111)
               ___STR8(32,100,101,115,99,114,105,112)
               ___STR8(116,105,111,110,32,102,111,114)
               ___STR7(32,111,98,106,101,99,116)
___DEF_SUB_STR(___X1,40UL)
               ___STR8(105,109,109,45,101,110,99,111)
               ___STR8(100,101,44,32,111,98,106,101)
               ___STR8(99,116,32,110,111,116,32,111)
               ___STR8(102,32,105,109,109,101,100,105)
               ___STR8(97,116,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_STR(___X2,40UL)
               ___STR8(114,101,102,45,101,110,99,111)
               ___STR8(100,101,44,32,111,98,106,101)
               ___STR8(99,116,32,110,111,116,32,111)
               ___STR8(102,32,114,101,102,101,114,101)
               ___STR8(110,99,101,32,116,121,112,101)
               ___STR0
___DEF_SUB_VEC(___X3,6UL)
               ___VEC1(___REF_SUB(4))
               ___VEC1(___REF_SUB(5))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X4,1UL)
               ___VEC1(___REF_SYM(0,___S___t_2d_cpu_2d_object_2d_desc))
               ___VEC0
___DEF_SUB_VEC(___X5,0UL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
,___DEF_SUB(___X2)
,___DEF_SUB(___X3)
,___DEF_SUB(___X4)
,___DEF_SUB(___X5)
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
___DEF_M_HLBL(___L0___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L1___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L2___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L3___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L4___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L5___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L6___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L7___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L8___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L9___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L10___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L11___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L12___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L13___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L14___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L15___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L16___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L17___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L19___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L20___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L21___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L22___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L23___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L24___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L25___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L26___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L27___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L28___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L29___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L30___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L31___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L32___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L33___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L34___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L35___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L36___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L37___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L38___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L39___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L40___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L41___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L42___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L43___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L44___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L45___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L46___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L47___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L48___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L49___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L50___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L51___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L52___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L53___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L54___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L55___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L56___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L57___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L58___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L59___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L60___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L61___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L62___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L63___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL(___L64___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_type_2d_tag)
___DEF_M_HLBL(___L1_c_23_type_2d_tag)
___DEF_M_HLBL(___L2_c_23_type_2d_tag)
___DEF_M_HLBL(___L3_c_23_type_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_head_2d_type_2d_tag)
___DEF_M_HLBL(___L1_c_23_head_2d_type_2d_tag)
___DEF_M_HLBL(___L2_c_23_head_2d_type_2d_tag)
___DEF_M_HLBL(___L3_c_23_head_2d_type_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_subtype_2d_tag)
___DEF_M_HLBL(___L1_c_23_subtype_2d_tag)
___DEF_M_HLBL(___L2_c_23_subtype_2d_tag)
___DEF_M_HLBL(___L3_c_23_subtype_2d_tag)
___DEF_M_HLBL(___L4_c_23_subtype_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_type)
___DEF_M_HLBL(___L1_c_23_desc_2d_type)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_encoder)
___DEF_M_HLBL(___L1_c_23_desc_2d_encoder)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL(___L1_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL(___L2_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL(___L3_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL(___L4_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_encoder_3f_)
___DEF_M_HLBL(___L1_c_23_desc_2d_encoder_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_desc)
___DEF_M_HLBL(___L1_c_23_imm_2d_desc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_type_3f_)
___DEF_M_HLBL(___L1_c_23_imm_2d_type_3f_)
___DEF_M_HLBL(___L2_c_23_imm_2d_type_3f_)
___DEF_M_HLBL(___L3_c_23_imm_2d_type_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L1_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L2_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L3_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L4_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L5_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L6_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L7_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_desc)
___DEF_M_HLBL(___L1_c_23_ref_2d_desc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_subtype)
___DEF_M_HLBL(___L1_c_23_ref_2d_subtype)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_subtype_2d_tag)
___DEF_M_HLBL(___L1_c_23_ref_2d_subtype_2d_tag)
___DEF_M_HLBL(___L2_c_23_ref_2d_subtype_2d_tag)
___DEF_M_HLBL(___L3_c_23_ref_2d_subtype_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_type_3f_)
___DEF_M_HLBL(___L1_c_23_ref_2d_type_3f_)
___DEF_M_HLBL(___L2_c_23_ref_2d_type_3f_)
___DEF_M_HLBL(___L3_c_23_ref_2d_type_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_subtype_3f_)
___DEF_M_HLBL(___L1_c_23_ref_2d_subtype_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L1_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L2_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L3_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L4_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L5_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L6_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L7_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L8_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L9_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_tagged_2d_value)
___DEF_M_HLBL(___L1_c_23_tagged_2d_value)
___DEF_M_HLBL(___L2_c_23_tagged_2d_value)
___DEF_M_HLBL(___L3_c_23_tagged_2d_value)
___DEF_M_HLBL(___L4_c_23_tagged_2d_value)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_special_2d_desc)
___DEF_M_HLBL(___L1_c_23_special_2d_desc)
___DEF_M_HLBL(___L2_c_23_special_2d_desc)
___DEF_M_HLBL(___L3_c_23_special_2d_desc)
___DEF_M_HLBL(___L4_c_23_special_2d_desc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L1_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L2_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L3_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L4_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L5_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L6_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L7_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L8_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L9_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L10_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L11_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L12_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L13_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L14_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L15_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L16_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L17_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L18_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L19_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L20_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L21_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L22_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L23_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L24_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L25_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L26_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L27_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L28_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L29_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L30_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L31_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L32_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L33_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L34_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L35_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L36_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L37_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L38_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L39_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L40_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L41_c_23_object_2d__3e_desc)
___DEF_M_HLBL(___L42_c_23_object_2d__3e_desc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_object_3f_)
___DEF_M_HLBL(___L1_c_23_imm_2d_object_3f_)
___DEF_M_HLBL(___L2_c_23_imm_2d_object_3f_)
___DEF_M_HLBL(___L3_c_23_imm_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_object_3f_)
___DEF_M_HLBL(___L1_c_23_ref_2d_object_3f_)
___DEF_M_HLBL(___L2_c_23_ref_2d_object_3f_)
___DEF_M_HLBL(___L3_c_23_ref_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_encode)
___DEF_M_HLBL(___L1_c_23_imm_2d_encode)
___DEF_M_HLBL(___L2_c_23_imm_2d_encode)
___DEF_M_HLBL(___L3_c_23_imm_2d_encode)
___DEF_M_HLBL(___L4_c_23_imm_2d_encode)
___DEF_M_HLBL(___L5_c_23_imm_2d_encode)
___DEF_M_HLBL(___L6_c_23_imm_2d_encode)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_encode)
___DEF_M_HLBL(___L1_c_23_ref_2d_encode)
___DEF_M_HLBL(___L2_c_23_ref_2d_encode)
___DEF_M_HLBL(___L3_c_23_ref_2d_encode)
___DEF_M_HLBL(___L4_c_23_ref_2d_encode)
___DEF_M_HLBL(___L5_c_23_ref_2d_encode)
___DEF_M_HLBL(___L6_c_23_ref_2d_encode)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___t_2d_cpu_2d_object_2d_desc_23_
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
___DEF_P_HLBL(___L0___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L1___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L2___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L3___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L4___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L5___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L6___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L7___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L8___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L9___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L10___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L11___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L12___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L13___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L14___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L15___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L16___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L17___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L19___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L20___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L21___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L22___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L23___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L24___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L25___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L26___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L27___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L28___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L29___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L30___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L31___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L32___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L33___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L34___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L35___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L36___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L37___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L38___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L39___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L40___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L41___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L42___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L43___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L44___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L45___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L46___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L47___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L48___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L49___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L50___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L51___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L52___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L53___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L54___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L55___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L56___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L57___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L58___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L59___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L60___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L61___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L62___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L63___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_P_HLBL(___L64___t_2d_cpu_2d_object_2d_desc_23_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(77,___G_c_23_type_2d_tags,___CNS(0))
   ___SET_GLO(75,___G_c_23_type_2d_tag_2d_bits,___FIX(2L))
   ___SET_STK(1,___R0)
   ___SET_R2(___FIX(2L))
   ___SET_R1(___FIX(1L))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G_fxarithmetic_2d_shift)
___DEF_SLBL(2,___L2___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),117,___G_fx_2d_)
___DEF_SLBL(3,___L3___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(76,___G_c_23_type_2d_tag_2d_mask,___R1)
   ___SET_GLO(23,___G_c_23_head_2d_type_2d_tags,___CNS(12))
   ___SET_GLO(21,___G_c_23_head_2d_type_2d_tag_2d_bits,___FIX(3L))
   ___SET_R2(___FIX(3L))
   ___SET_R1(___FIX(1L))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G_fxarithmetic_2d_shift)
___DEF_SLBL(4,___L4___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),117,___G_fx_2d_)
___DEF_SLBL(5,___L5___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(22,___G_c_23_head_2d_type_2d_tag_2d_mask,___R1)
   ___SET_GLO(70,___G_c_23_subtype_2d_tags,___CNS(24))
   ___SET_GLO(68,___G_c_23_subtype_2d_tag_2d_bits,___FIX(5L))
   ___SET_R2(___FIX(5L))
   ___SET_R1(___FIX(1L))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G_fxarithmetic_2d_shift)
___DEF_SLBL(6,___L6___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),117,___G_fx_2d_)
___DEF_SLBL(7,___L7___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___FIX(3L))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G_fxarithmetic_2d_shift)
___DEF_SLBL(8,___L8___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(69,___G_c_23_subtype_2d_tag_2d_mask,___R1)
   ___SET_R2(___FIX(5L))
   ___SET_R1(___FIX(3L))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),116,___G_fx_2b_)
___DEF_SLBL(9,___L9___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(1L))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G_fxarithmetic_2d_shift)
___DEF_SLBL(10,___L10___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),117,___G_fx_2d_)
___DEF_SLBL(11,___L11___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),91,___G_bitwise_2d_not)
___DEF_SLBL(12,___L12___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(36,___G_c_23_length_2d_mask,___R1)
   ___SET_GLO(30,___G_c_23_imm_2d_type,___PRC(83))
   ___SET_GLO(27,___G_c_23_imm_2d_encoder,___PRC(86))
   ___SET_GLO(31,___G_c_23_imm_2d_type_2d_tag,___PRC(89))
   ___SET_GLO(28,___G_c_23_imm_2d_encoder_3f_,___PRC(95))
   ___SET_GLO(55,___G_c_23_ref_2d_type,___PRC(83))
   ___SET_GLO(49,___G_c_23_ref_2d_encoder,___PRC(86))
   ___SET_GLO(56,___G_c_23_ref_2d_type_2d_tag,___PRC(89))
   ___SET_GLO(50,___G_c_23_ref_2d_encoder_3f_,___PRC(95))
   ___SET_R3(___LBL(63))
   ___SET_R2(___SYM_fixnum)
   ___SET_R1(___SYM_imm)
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),136,___G_vector)
___DEF_SLBL(13,___L13___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(16,___G_c_23_fixnum_2d_desc,___R1)
   ___SET_R3(___LBL(59))
   ___SET_R2(___SYM_special)
   ___SET_R1(___SYM_imm)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),136,___G_vector)
___DEF_SLBL(14,___L14___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(4,___G_c_23_char_2d_desc,___R1)
   ___SET_R1(___FIX(-1L))
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(15,___L15___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(15,___G_c_23_fal_2d_desc,___R1)
   ___SET_R1(___FIX(-2L))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(16,___L16___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(73,___G_c_23_tru_2d_desc,___R1)
   ___SET_R1(___FIX(-3L))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(17,___L17___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(38,___G_c_23_nul_2d_desc,___R1)
   ___SET_R1(___FIX(-4L))
   ___SET_R0(___LBL(18))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(18,___L18___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(12,___G_c_23_eof_2d_desc,___R1)
   ___SET_R1(___FIX(-5L))
   ___SET_R0(___LBL(19))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(19,___L19___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(86,___G_c_23_void_2d_desc,___R1)
   ___SET_R1(___FIX(-6L))
   ___SET_R0(___LBL(20))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(20,___L20___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(1,___G_c_23_absent_2d_desc,___R1)
   ___SET_R1(___FIX(-7L))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(21,___L21___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(82,___G_c_23_unb1_2d_desc,___R1)
   ___SET_R1(___FIX(-8L))
   ___SET_R0(___LBL(22))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(22,___L22___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(83,___G_c_23_unb2_2d_desc,___R1)
   ___SET_R1(___FIX(-9L))
   ___SET_R0(___LBL(23))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(23,___L23___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(40,___G_c_23_optional_2d_desc,___R1)
   ___SET_R1(___FIX(-10L))
   ___SET_R0(___LBL(24))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(24,___L24___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(34,___G_c_23_keyobj_2d_desc,___R1)
   ___SET_R1(___FIX(-11L))
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(25,___L25___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(58,___G_c_23_rest_2d_desc,___R1)
   ___SET_R1(___FIX(-14L))
   ___SET_R0(___LBL(26))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(26,___L26___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(84,___G_c_23_unused_2d_desc,___R1)
   ___SET_R1(___FIX(-15L))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(1),___PRC(151),___L_c_23_special_2d_desc)
___DEF_SLBL(27,___L27___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(7,___G_c_23_deleted_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_pair)
   ___SET_R1(___SYM_pair)
   ___SET_R0(___LBL(28))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(28,___L28___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(41,___G_c_23_pair_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(29))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(29,___L29___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(85,___G_c_23_vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_ratnum)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(30))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(30,___L30___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(45,___G_c_23_ratnum_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_cpxnum)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(31))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(31,___L31___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(6,___G_c_23_cpxnum_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_structure)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(32))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(32,___L32___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(66,___G_c_23_structure_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_boxvalues)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(33))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(33,___L33___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(3,___G_c_23_boxvalues_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_meroon)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(34))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(34,___L34___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(37,___G_c_23_meroon_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_jazz)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(35))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(35,___L35___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(33,___G_c_23_jazz_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_symbol)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(36))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(36,___L36___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(71,___G_c_23_symbol_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_keyword)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(37))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(37,___L37___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(35,___G_c_23_keyword_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_frame)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(38))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(38,___L38___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(19,___G_c_23_frame_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_continuation)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(39))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(39,___L39___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(5,___G_c_23_continuation_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_promise)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(40))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(40,___L40___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(44,___G_c_23_promise_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_weak)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(41))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(41,___L41___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(87,___G_c_23_weak_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_procedure)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(42))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(42,___L42___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(43,___G_c_23_procedure_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_return)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(43))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(43,___L43___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(59,___G_c_23_return_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_foreign)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(44))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(44,___L44___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(18,___G_c_23_foreign_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_string)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(45))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(45,___L45___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(65,___G_c_23_string_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_s8vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(46))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(46,___L46___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(63,___G_c_23_s8vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_u8vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(47))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(47,___L47___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(81,___G_c_23_u8vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_s16vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(48))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(48,___L48___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(60,___G_c_23_s16vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_u16vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(49))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(49,___L49___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(78,___G_c_23_u16vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_s32vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(50))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(50,___L50___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(61,___G_c_23_s32vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_u32vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(51))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(51,___L51___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(79,___G_c_23_u32vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_f32vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(52))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(52,___L52___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(13,___G_c_23_f32vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_s64vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(53))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(53,___L53___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(62,___G_c_23_s64vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_u64vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(54))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(54,___L54___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(80,___G_c_23_u64vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_f64vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(55))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(55,___L55___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(14,___G_c_23_f64vector_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_flonum)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(56))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(56,___L56___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(17,___G_c_23_flonum_2d_desc,___R1)
   ___SET_STK(1,___SYM_ref)
   ___SET_R2(___LBL(58))
   ___SET_R3(___SYM_bignum)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(57))
   ___ADJFP(1)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___DEF_SLBL(57,___L57___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(2,___G_c_23_bignum_2d_desc,___R1)
   ___SET_GLO(42,___G_c_23_pointer_2d_header_2d_offset,___FIX(2L))
   ___SET_R1(___VOID)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(58,___L58___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(58,1,0,0)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(59,___L59___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(59,1,0,0)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(60)
___DEF_SLBL(60,___L60___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R0(___LBL(61))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),106,___G_char_2d__3e_integer)
___DEF_SLBL(61,___L61___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R2(___SYM_special)
   ___SET_R0(___STK(-3))
   ___POLL(62)
___DEF_SLBL(62,___L62___t_2d_cpu_2d_object_2d_desc_23_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(145),___L_c_23_tagged_2d_value)
___DEF_SLBL(63,___L63___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(63,1,0,0)
   ___SET_R2(___SYM_fixnum)
   ___POLL(64)
___DEF_SLBL(64,___L64___t_2d_cpu_2d_object_2d_desc_23_)
   ___JUMPINT(___SET_NARGS(2),___PRC(145),___L_c_23_tagged_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_type_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 67
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_type_2d_tag)
___DEF_P_HLBL(___L1_c_23_type_2d_tag)
___DEF_P_HLBL(___L2_c_23_type_2d_tag)
___DEF_P_HLBL(___L3_c_23_type_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_type_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_type_2d_tag)
   ___SET_STK(1,___R0)
   ___SET_R2(___CNS(0))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_type_2d_tag)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),90,___G_assq)
___DEF_SLBL(2,___L2_c_23_type_2d_tag)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_type_2d_tag)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),105,___G_cdr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_head_2d_type_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_head_2d_type_2d_tag)
___DEF_P_HLBL(___L1_c_23_head_2d_type_2d_tag)
___DEF_P_HLBL(___L2_c_23_head_2d_type_2d_tag)
___DEF_P_HLBL(___L3_c_23_head_2d_type_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_head_2d_type_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_head_2d_type_2d_tag)
   ___SET_STK(1,___R0)
   ___SET_R2(___CNS(12))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_head_2d_type_2d_tag)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),90,___G_assq)
___DEF_SLBL(2,___L2_c_23_head_2d_type_2d_tag)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_head_2d_type_2d_tag)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),105,___G_cdr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_subtype_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 77
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L1_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L2_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L3_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L4_c_23_subtype_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_subtype_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_subtype_2d_tag)
   ___SET_STK(1,___R0)
   ___SET_R2(___CNS(24))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_subtype_2d_tag)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),90,___G_assq)
___DEF_SLBL(2,___L2_c_23_subtype_2d_tag)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),105,___G_cdr)
___DEF_SLBL(3,___L3_c_23_subtype_2d_tag)
   ___SET_R2(___FIX(3L))
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_subtype_2d_tag)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),118,___G_fxarithmetic_2d_shift)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_type
#undef ___PH_LBL0
#define ___PH_LBL0 83
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_type)
___DEF_P_HLBL(___L1_c_23_desc_2d_type)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_type)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_type)
   ___SET_R2(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_desc_2d_type)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_encoder
#undef ___PH_LBL0
#define ___PH_LBL0 86
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_encoder)
___DEF_P_HLBL(___L1_c_23_desc_2d_encoder)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_encoder)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_encoder)
   ___SET_R2(___FIX(2L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_desc_2d_encoder)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_type_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 89
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_type_2d_tag)
___DEF_P_HLBL(___L1_c_23_desc_2d_type_2d_tag)
___DEF_P_HLBL(___L2_c_23_desc_2d_type_2d_tag)
___DEF_P_HLBL(___L3_c_23_desc_2d_type_2d_tag)
___DEF_P_HLBL(___L4_c_23_desc_2d_type_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_type_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_type_2d_tag)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_desc_2d_type_2d_tag)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23_desc_2d_type)
___DEF_SLBL(2,___L2_c_23_desc_2d_type_2d_tag)
   ___SET_R2(___CNS(0))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),90,___G_assq)
___DEF_SLBL(3,___L3_c_23_desc_2d_type_2d_tag)
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_desc_2d_type_2d_tag)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),105,___G_cdr)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_encoder_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 95
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_encoder_3f_)
___DEF_P_HLBL(___L1_c_23_desc_2d_encoder_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_encoder_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_encoder_3f_)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_desc_2d_encoder_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G_procedure_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_desc
#undef ___PH_LBL0
#define ___PH_LBL0 98
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_desc)
___DEF_P_HLBL(___L1_c_23_imm_2d_desc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_desc)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_imm_2d_desc)
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_imm)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_imm_2d_desc)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),136,___G_vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_type_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 101
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_type_3f_)
___DEF_P_HLBL(___L1_c_23_imm_2d_type_3f_)
___DEF_P_HLBL(___L2_c_23_imm_2d_type_3f_)
___DEF_P_HLBL(___L3_c_23_imm_2d_type_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_type_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_imm_2d_type_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___SYM_fixnum)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_imm_2d_type_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_SLBL(2,___L2_c_23_imm_2d_type_3f_)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L4_c_23_imm_2d_type_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_special)
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_imm_2d_type_3f_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_GLBL(___L4_c_23_imm_2d_type_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_desc_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 106
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L1_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L2_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L3_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L4_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L5_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L6_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L7_c_23_imm_2d_desc_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_desc_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_imm_2d_desc_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_imm_2d_desc_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(2,___L2_c_23_imm_2d_desc_3f_)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_imm)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_SLBL(3,___L3_c_23_imm_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L8_c_23_imm_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(4,___L4_c_23_imm_2d_desc_3f_)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(101),___L_c_23_imm_2d_type_3f_)
___DEF_SLBL(5,___L5_c_23_imm_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L8_c_23_imm_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23_desc_2d_encoder)
___DEF_SLBL(6,___L6_c_23_imm_2d_desc_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_imm_2d_desc_3f_)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G_procedure_3f_)
___DEF_GLBL(___L8_c_23_imm_2d_desc_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_desc
#undef ___PH_LBL0
#define ___PH_LBL0 115
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_desc)
___DEF_P_HLBL(___L1_c_23_ref_2d_desc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_desc)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_ref_2d_desc)
   ___SET_STK(1,___SYM_ref)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_desc)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),136,___G_vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_subtype
#undef ___PH_LBL0
#define ___PH_LBL0 118
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_subtype)
___DEF_P_HLBL(___L1_c_23_ref_2d_subtype)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_subtype)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_subtype)
   ___SET_R2(___FIX(3L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_subtype)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_subtype_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 121
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_subtype_2d_tag)
___DEF_P_HLBL(___L1_c_23_ref_2d_subtype_2d_tag)
___DEF_P_HLBL(___L2_c_23_ref_2d_subtype_2d_tag)
___DEF_P_HLBL(___L3_c_23_ref_2d_subtype_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_subtype_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_subtype_2d_tag)
   ___SET_STK(1,___R0)
   ___SET_R2(___FIX(1L))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_subtype_2d_tag)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(2,___L2_c_23_ref_2d_subtype_2d_tag)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ref_2d_subtype_2d_tag)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23_subtype_2d_tag)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_type_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 126
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_type_3f_)
___DEF_P_HLBL(___L1_c_23_ref_2d_type_3f_)
___DEF_P_HLBL(___L2_c_23_ref_2d_type_3f_)
___DEF_P_HLBL(___L3_c_23_ref_2d_type_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_type_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_type_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___SYM_subtyped)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_type_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_SLBL(2,___L2_c_23_ref_2d_type_3f_)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L4_c_23_ref_2d_type_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_pair)
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ref_2d_type_3f_)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_GLBL(___L4_c_23_ref_2d_type_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_subtype_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 131
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_subtype_3f_)
___DEF_P_HLBL(___L1_c_23_ref_2d_subtype_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_subtype_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_subtype_3f_)
   ___SET_R2(___CNS(24))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_subtype_3f_)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),90,___G_assq)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_desc_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 134
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L1_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L2_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L3_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L4_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L5_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L6_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L7_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L8_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L9_c_23_ref_2d_desc_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_desc_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_desc_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___FIX(0L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_desc_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(2,___L2_c_23_ref_2d_desc_3f_)
   ___SET_R2(___R1)
   ___SET_R1(___SYM_ref)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_SLBL(3,___L3_c_23_ref_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L10_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(4,___L4_c_23_ref_2d_desc_3f_)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(126),___L_c_23_ref_2d_type_3f_)
___DEF_SLBL(5,___L5_c_23_ref_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L10_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23_desc_2d_encoder)
___DEF_SLBL(6,___L6_c_23_ref_2d_desc_3f_)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G_procedure_3f_)
___DEF_SLBL(7,___L7_c_23_ref_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L10_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(118),___L_c_23_ref_2d_subtype)
___DEF_SLBL(8,___L8_c_23_ref_2d_desc_3f_)
   ___SET_R2(___CNS(24))
   ___SET_R0(___STK(-3))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_ref_2d_desc_3f_)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),90,___G_assq)
___DEF_GLBL(___L10_c_23_ref_2d_desc_3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_tagged_2d_value
#undef ___PH_LBL0
#define ___PH_LBL0 145
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_tagged_2d_value)
___DEF_P_HLBL(___L1_c_23_tagged_2d_value)
___DEF_P_HLBL(___L2_c_23_tagged_2d_value)
___DEF_P_HLBL(___L3_c_23_tagged_2d_value)
___DEF_P_HLBL(___L4_c_23_tagged_2d_value)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_tagged_2d_value)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_tagged_2d_value)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R2(___FIX(2L))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_tagged_2d_value)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),89,___G_arithmetic_2d_shift)
___DEF_SLBL(2,___L2_c_23_tagged_2d_value)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(67),___L_c_23_type_2d_tag)
___DEF_SLBL(3,___L3_c_23_tagged_2d_value)
   ___SET_R2(___R1)
   ___SET_R0(___STK(-7))
   ___SET_R1(___STK(-5))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_tagged_2d_value)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),88,___G__2b_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_special_2d_desc
#undef ___PH_LBL0
#define ___PH_LBL0 151
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_special_2d_desc)
___DEF_P_HLBL(___L1_c_23_special_2d_desc)
___DEF_P_HLBL(___L2_c_23_special_2d_desc)
___DEF_P_HLBL(___L3_c_23_special_2d_desc)
___DEF_P_HLBL(___L4_c_23_special_2d_desc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_special_2d_desc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_special_2d_desc)
   ___SET_STK(1,___ALLOC_CLO(1UL))
   ___BEGIN_SETUP_CLO(1,___STK(1),3)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_R3(___STK(1))
   ___SET_R2(___SYM_special)
   ___SET_R1(___SYM_imm)
   ___ADJFP(1)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_special_2d_desc)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_special_2d_desc)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),136,___G_vector)
___DEF_SLBL(3,___L3_c_23_special_2d_desc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(3,1,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___SET_R2(___SYM_special)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_special_2d_desc)
   ___JUMPINT(___SET_NARGS(2),___PRC(145),___L_c_23_tagged_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_object_2d__3e_desc
#undef ___PH_LBL0
#define ___PH_LBL0 157
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L1_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L2_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L3_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L4_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L5_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L6_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L7_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L8_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L9_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L10_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L11_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L12_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L13_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L14_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L15_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L16_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L17_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L18_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L19_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L20_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L21_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L22_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L23_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L24_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L25_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L26_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L27_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L28_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L29_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L30_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L31_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L32_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L33_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L34_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L35_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L36_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L37_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L38_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L39_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L40_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L41_c_23_object_2d__3e_desc)
___DEF_P_HLBL(___L42_c_23_object_2d__3e_desc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_object_2d__3e_desc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_object_2d__3e_desc)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_object_2d__3e_desc)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),113,___G_fixnum_3f_)
___DEF_SLBL(2,___L2_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L82_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),107,___G_char_3f_)
___DEF_SLBL(3,___L3_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L81_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_SLBL(4,___L4_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L80_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___TRU)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),110,___G_eq_3f_)
___DEF_SLBL(5,___L5_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L79_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),121,___G_null_3f_)
___DEF_SLBL(6,___L6_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L78_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),96,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
___DEF_SLBL(7,___L7_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L77_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),104,___G_c_23_void_2d_object_3f_)
___DEF_SLBL(8,___L8_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L76_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),93,___G_c_23_absent_2d_object_3f_)
___DEF_SLBL(9,___L9_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L75_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),101,___G_c_23_unbound1_2d_object_3f_)
___DEF_SLBL(10,___L10_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L74_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),102,___G_c_23_unbound2_2d_object_3f_)
___DEF_SLBL(11,___L11_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L73_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(12))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),98,___G_c_23_optional_2d_object_3f_)
___DEF_SLBL(12,___L12_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L72_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),97,___G_c_23_key_2d_object_3f_)
___DEF_SLBL(13,___L13_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L71_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),99,___G_c_23_rest_2d_object_3f_)
___DEF_SLBL(14,___L14_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L70_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),103,___G_c_23_unused_2d_object_3f_)
___DEF_SLBL(15,___L15_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L69_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),95,___G_c_23_deleted_2d_object_3f_)
___DEF_SLBL(16,___L16_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L68_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),122,___G_pair_3f_)
___DEF_SLBL(17,___L17_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L67_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G_vector_3f_)
___DEF_SLBL(18,___L18_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L66_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G_rational_3f_)
___DEF_SLBL(19,___L19_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L65_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_complex_3f_)
___DEF_SLBL(20,___L20_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L64_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),100,___G_c_23_structure_2d_object_3f_)
___DEF_SLBL(21,___L21_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L63_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),92,___G_box_3f_)
___DEF_SLBL(22,___L22_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L62_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G_symbol_3f_)
___DEF_SLBL(23,___L23_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L61_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),120,___G_keyword_3f_)
___DEF_SLBL(24,___L24_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L60_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),109,___G_continuation_3f_)
___DEF_SLBL(25,___L25_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L59_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(26))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),124,___G_promise_3f_)
___DEF_SLBL(26,___L26_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L58_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(27))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G_procedure_3f_)
___DEF_SLBL(27,___L27_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L57_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_foreign_3f_)
___DEF_SLBL(28,___L28_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L56_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),130,___G_string_3f_)
___DEF_SLBL(29,___L29_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L55_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),129,___G_s8vector_3f_)
___DEF_SLBL(30,___L30_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L54_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),135,___G_u8vector_3f_)
___DEF_SLBL(31,___L31_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L53_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),126,___G_s16vector_3f_)
___DEF_SLBL(32,___L32_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L52_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),132,___G_u16vector_3f_)
___DEF_SLBL(33,___L33_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L51_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),127,___G_s32vector_3f_)
___DEF_SLBL(34,___L34_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L50_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),133,___G_u32vector_3f_)
___DEF_SLBL(35,___L35_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L49_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(36))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),111,___G_f32vector_3f_)
___DEF_SLBL(36,___L36_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L48_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(37))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),128,___G_s64vector_3f_)
___DEF_SLBL(37,___L37_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L47_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(38))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),134,___G_u64vector_3f_)
___DEF_SLBL(38,___L38_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L46_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(39))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),112,___G_f64vector_3f_)
___DEF_SLBL(39,___L39_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L45_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(40))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),114,___G_flonum_3f_)
___DEF_SLBL(40,___L40_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L44_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(41))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),119,___G_integer_3f_)
___DEF_SLBL(41,___L41_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L43_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(42)
___DEF_SLBL(42,___L42_c_23_object_2d__3e_desc)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),94,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L43_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_bignum_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L44_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_flonum_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L45_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_f64vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L46_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u64vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L47_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s64vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L48_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_f32vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L49_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u32vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L50_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s32vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L51_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u16vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L52_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s16vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L53_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u8vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L54_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s8vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L55_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_string_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L56_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_foreign_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L57_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_procedure_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L58_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_promise_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L59_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_continuation_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L60_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_keyword_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L61_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_symbol_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L62_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_boxvalues_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L63_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_structure_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L64_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_cpxnum_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L65_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_ratnum_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L66_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L67_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_pair_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L68_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_deleted_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L69_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_unused_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L70_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_rest_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L71_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_keyobj_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L72_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_optional_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L73_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_unb2_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L74_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_unb1_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L75_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_absent_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L76_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_void_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L77_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_eof_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L78_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_nul_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L79_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_tru_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L80_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_fal_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L81_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_char_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L82_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_fixnum_2d_desc)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 201
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_object_3f_)
___DEF_P_HLBL(___L1_c_23_imm_2d_object_3f_)
___DEF_P_HLBL(___L2_c_23_imm_2d_object_3f_)
___DEF_P_HLBL(___L3_c_23_imm_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_imm_2d_object_3f_)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_imm_2d_object_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(157),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_imm_2d_object_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_imm_2d_object_3f_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(106),___L_c_23_imm_2d_desc_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 206
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_object_3f_)
___DEF_P_HLBL(___L1_c_23_ref_2d_object_3f_)
___DEF_P_HLBL(___L2_c_23_ref_2d_object_3f_)
___DEF_P_HLBL(___L3_c_23_ref_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_object_3f_)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_object_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(157),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_ref_2d_object_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ref_2d_object_3f_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(134),___L_c_23_ref_2d_desc_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_encode
#undef ___PH_LBL0
#define ___PH_LBL0 211
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_encode)
___DEF_P_HLBL(___L1_c_23_imm_2d_encode)
___DEF_P_HLBL(___L2_c_23_imm_2d_encode)
___DEF_P_HLBL(___L3_c_23_imm_2d_encode)
___DEF_P_HLBL(___L4_c_23_imm_2d_encode)
___DEF_P_HLBL(___L5_c_23_imm_2d_encode)
___DEF_P_HLBL(___L6_c_23_imm_2d_encode)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_encode)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_imm_2d_encode)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_imm_2d_encode)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(157),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_imm_2d_encode)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(106),___L_c_23_imm_2d_desc_3f_)
___DEF_SLBL(3,___L3_c_23_imm_2d_encode)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7_c_23_imm_2d_encode)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(1))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_imm_2d_encode)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),94,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L7_c_23_imm_2d_encode)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(2L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(5,___L5_c_23_imm_2d_encode)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_imm_2d_encode)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_encode
#undef ___PH_LBL0
#define ___PH_LBL0 219
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_encode)
___DEF_P_HLBL(___L1_c_23_ref_2d_encode)
___DEF_P_HLBL(___L2_c_23_ref_2d_encode)
___DEF_P_HLBL(___L3_c_23_ref_2d_encode)
___DEF_P_HLBL(___L4_c_23_ref_2d_encode)
___DEF_P_HLBL(___L5_c_23_ref_2d_encode)
___DEF_P_HLBL(___L6_c_23_ref_2d_encode)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_encode)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_encode)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_encode)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(157),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_ref_2d_encode)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(134),___L_c_23_ref_2d_desc_3f_)
___DEF_SLBL(3,___L3_c_23_ref_2d_encode)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L7_c_23_ref_2d_encode)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(2))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_ref_2d_encode)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),94,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L7_c_23_ref_2d_encode)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(2L))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),137,___G_vector_2d_ref)
___DEF_SLBL(5,___L5_c_23_ref_2d_encode)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_ref_2d_encode)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(3))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___t_2d_cpu_2d_object_2d_desc_23_,"_t-cpu-object-desc#",___REF_FAL,65,0)
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,0,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,1,-1)
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,1,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,1,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_type_2d_tag,"c#type-tag",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_type_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_type_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_type_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_type_2d_tag,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_head_2d_type_2d_tag,"c#head-type-tag",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_head_2d_type_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_head_2d_type_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_head_2d_type_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_head_2d_type_2d_tag,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_subtype_2d_tag,"c#subtype-tag",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_subtype_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_desc_2d_type,"c#desc-type",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_type,1,-1)
,___DEF_LBL_RET(___H_c_23_desc_2d_type,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_desc_2d_encoder,"c#desc-encoder",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_encoder,1,-1)
,___DEF_LBL_RET(___H_c_23_desc_2d_encoder,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_desc_2d_type_2d_tag,"c#desc-type-tag",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_type_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_desc_2d_type_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_desc_2d_type_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_desc_2d_type_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_desc_2d_type_2d_tag,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_desc_2d_encoder_3f_,"c#desc-encoder?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_encoder_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_desc_2d_encoder_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_desc,"c#imm-desc",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_desc,2,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_desc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_type_3f_,"c#imm-type?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_type_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_type_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_imm_2d_type_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_type_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_desc_3f_,"c#imm-desc?",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_desc_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_desc,"c#ref-desc",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_desc,3,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_desc,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_subtype,"c#ref-subtype",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_subtype,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_subtype_2d_tag,"c#ref-subtype-tag",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_subtype_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_2d_tag,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_type_3f_,"c#ref-type?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_type_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_type_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ref_2d_type_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_type_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_subtype_3f_,"c#ref-subtype?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_subtype_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_desc_3f_,"c#ref-desc?",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_desc_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_tagged_2d_value,"c#tagged-value",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_tagged_2d_value,2,-1)
,___DEF_LBL_RET(___H_c_23_tagged_2d_value,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_tagged_2d_value,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_tagged_2d_value,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_tagged_2d_value,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_special_2d_desc,"c#special-desc",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23_special_2d_desc,1,-1)
,___DEF_LBL_RET(___H_c_23_special_2d_desc,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_special_2d_desc,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_PROC(___H_c_23_special_2d_desc,1,1)
,___DEF_LBL_RET(___H_c_23_special_2d_desc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_object_2d__3e_desc,"c#object->desc",___REF_FAL,43,0)
,___DEF_LBL_PROC(___H_c_23_object_2d__3e_desc,1,-1)
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_object_3f_,"c#imm-object?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_object_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_object_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_imm_2d_object_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_imm_2d_object_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_object_3f_,"c#ref-object?",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_object_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_object_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_object_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_object_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_encode,"c#imm-encode",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_encode,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_encode,"c#ref-encode",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_encode,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETI,8,8,0x3f04L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___t_2d_cpu_2d_object_2d_desc_23_,1)
___DEF_MOD_PRM(74,___G_c_23_type_2d_tag,67)
___DEF_MOD_PRM(20,___G_c_23_head_2d_type_2d_tag,72)
___DEF_MOD_PRM(67,___G_c_23_subtype_2d_tag,77)
___DEF_MOD_PRM(10,___G_c_23_desc_2d_type,83)
___DEF_MOD_PRM(8,___G_c_23_desc_2d_encoder,86)
___DEF_MOD_PRM(11,___G_c_23_desc_2d_type_2d_tag,89)
___DEF_MOD_PRM(9,___G_c_23_desc_2d_encoder_3f_,95)
___DEF_MOD_PRM(24,___G_c_23_imm_2d_desc,98)
___DEF_MOD_PRM(32,___G_c_23_imm_2d_type_3f_,101)
___DEF_MOD_PRM(25,___G_c_23_imm_2d_desc_3f_,106)
___DEF_MOD_PRM(46,___G_c_23_ref_2d_desc,115)
___DEF_MOD_PRM(52,___G_c_23_ref_2d_subtype,118)
___DEF_MOD_PRM(53,___G_c_23_ref_2d_subtype_2d_tag,121)
___DEF_MOD_PRM(57,___G_c_23_ref_2d_type_3f_,126)
___DEF_MOD_PRM(54,___G_c_23_ref_2d_subtype_3f_,131)
___DEF_MOD_PRM(47,___G_c_23_ref_2d_desc_3f_,134)
___DEF_MOD_PRM(72,___G_c_23_tagged_2d_value,145)
___DEF_MOD_PRM(64,___G_c_23_special_2d_desc,151)
___DEF_MOD_PRM(39,___G_c_23_object_2d__3e_desc,157)
___DEF_MOD_PRM(29,___G_c_23_imm_2d_object_3f_,201)
___DEF_MOD_PRM(51,___G_c_23_ref_2d_object_3f_,206)
___DEF_MOD_PRM(26,___G_c_23_imm_2d_encode,211)
___DEF_MOD_PRM(48,___G_c_23_ref_2d_encode,219)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___t_2d_cpu_2d_object_2d_desc_23_,1)
___DEF_MOD_GLO(74,___G_c_23_type_2d_tag,67)
___DEF_MOD_GLO(20,___G_c_23_head_2d_type_2d_tag,72)
___DEF_MOD_GLO(67,___G_c_23_subtype_2d_tag,77)
___DEF_MOD_GLO(10,___G_c_23_desc_2d_type,83)
___DEF_MOD_GLO(8,___G_c_23_desc_2d_encoder,86)
___DEF_MOD_GLO(11,___G_c_23_desc_2d_type_2d_tag,89)
___DEF_MOD_GLO(9,___G_c_23_desc_2d_encoder_3f_,95)
___DEF_MOD_GLO(24,___G_c_23_imm_2d_desc,98)
___DEF_MOD_GLO(32,___G_c_23_imm_2d_type_3f_,101)
___DEF_MOD_GLO(25,___G_c_23_imm_2d_desc_3f_,106)
___DEF_MOD_GLO(46,___G_c_23_ref_2d_desc,115)
___DEF_MOD_GLO(52,___G_c_23_ref_2d_subtype,118)
___DEF_MOD_GLO(53,___G_c_23_ref_2d_subtype_2d_tag,121)
___DEF_MOD_GLO(57,___G_c_23_ref_2d_type_3f_,126)
___DEF_MOD_GLO(54,___G_c_23_ref_2d_subtype_3f_,131)
___DEF_MOD_GLO(47,___G_c_23_ref_2d_desc_3f_,134)
___DEF_MOD_GLO(72,___G_c_23_tagged_2d_value,145)
___DEF_MOD_GLO(64,___G_c_23_special_2d_desc,151)
___DEF_MOD_GLO(39,___G_c_23_object_2d__3e_desc,157)
___DEF_MOD_GLO(29,___G_c_23_imm_2d_object_3f_,201)
___DEF_MOD_GLO(51,___G_c_23_ref_2d_object_3f_,206)
___DEF_MOD_GLO(26,___G_c_23_imm_2d_encode,211)
___DEF_MOD_GLO(48,___G_c_23_ref_2d_encode,219)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___t_2d_cpu_2d_object_2d_desc,"_t-cpu-object-desc")
___DEF_MOD_SYM(1,___S_bignum,"bignum")
___DEF_MOD_SYM(2,___S_boxvalues,"boxvalues")
___DEF_MOD_SYM(3,___S_continuation,"continuation")
___DEF_MOD_SYM(4,___S_cpxnum,"cpxnum")
___DEF_MOD_SYM(5,___S_f32vector,"f32vector")
___DEF_MOD_SYM(6,___S_f64vector,"f64vector")
___DEF_MOD_SYM(7,___S_fixnum,"fixnum")
___DEF_MOD_SYM(8,___S_flonum,"flonum")
___DEF_MOD_SYM(9,___S_foreign,"foreign")
___DEF_MOD_SYM(10,___S_forw,"forw")
___DEF_MOD_SYM(11,___S_frame,"frame")
___DEF_MOD_SYM(12,___S_imm,"imm")
___DEF_MOD_SYM(13,___S_jazz,"jazz")
___DEF_MOD_SYM(14,___S_keyword,"keyword")
___DEF_MOD_SYM(15,___S_mem1,"mem1")
___DEF_MOD_SYM(16,___S_mem2,"mem2")
___DEF_MOD_SYM(17,___S_meroon,"meroon")
___DEF_MOD_SYM(18,___S_movable0,"movable0")
___DEF_MOD_SYM(19,___S_movable1,"movable1")
___DEF_MOD_SYM(20,___S_movable2,"movable2")
___DEF_MOD_SYM(21,___S_pair,"pair")
___DEF_MOD_SYM(22,___S_perm,"perm")
___DEF_MOD_SYM(23,___S_procedure,"procedure")
___DEF_MOD_SYM(24,___S_promise,"promise")
___DEF_MOD_SYM(25,___S_ratnum,"ratnum")
___DEF_MOD_SYM(26,___S_ref,"ref")
___DEF_MOD_SYM(27,___S_return,"return")
___DEF_MOD_SYM(28,___S_s16vector,"s16vector")
___DEF_MOD_SYM(29,___S_s32vector,"s32vector")
___DEF_MOD_SYM(30,___S_s64vector,"s64vector")
___DEF_MOD_SYM(31,___S_s8vector,"s8vector")
___DEF_MOD_SYM(32,___S_special,"special")
___DEF_MOD_SYM(33,___S_still,"still")
___DEF_MOD_SYM(34,___S_string,"string")
___DEF_MOD_SYM(35,___S_structure,"structure")
___DEF_MOD_SYM(36,___S_subtyped,"subtyped")
___DEF_MOD_SYM(37,___S_symbol,"symbol")
___DEF_MOD_SYM(38,___S_u16vector,"u16vector")
___DEF_MOD_SYM(39,___S_u32vector,"u32vector")
___DEF_MOD_SYM(40,___S_u64vector,"u64vector")
___DEF_MOD_SYM(41,___S_u8vector,"u8vector")
___DEF_MOD_SYM(42,___S_vector,"vector")
___DEF_MOD_SYM(43,___S_weak,"weak")
___END_MOD_SYM_KEY

#endif
