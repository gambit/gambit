#ifdef ___LINKER_INFO
; File: "_t-cpu-object-desc.c", produced by Gambit v4.9.6
(
409006
(C)
"_t-cpu-object-desc"
("_t-cpu-object-desc")
()
(("_t-cpu-object-desc"))
( #|*/"*/"symbols|#
"_t-cpu-object-desc"
"_t-cpu-object-desc#"
"bignum"
"boxvalues"
"c#body-offset"
"c#desc-encoder"
"c#desc-encoder?"
"c#desc-type"
"c#desc-type-tag"
"c#head-type-tag"
"c#header-offset"
"c#imm-desc"
"c#imm-desc?"
"c#imm-encode"
"c#imm-object?"
"c#imm-type?"
"c#object->desc"
"c#ref-desc"
"c#ref-desc?"
"c#ref-encode"
"c#ref-object?"
"c#ref-size"
"c#ref-size?"
"c#ref-subtype"
"c#ref-subtype-tag"
"c#ref-subtype?"
"c#ref-type?"
"c#special-desc"
"c#subtype-tag"
"c#tagged-value"
"c#type-tag"
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
) #|*/"*/"symbols|#
( #|*/"*/"keywords|#
) #|*/"*/"keywords|#
( #|*/"*/"globals-s-d|#
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
"c#frame-desc"
"c#imm-desc?"
"c#imm-type?"
"c#jazz-desc"
"c#keyobj-desc"
"c#keyword-desc"
"c#meroon-desc"
"c#nul-desc"
"c#object->desc"
"c#optional-desc"
"c#pair-desc"
"c#procedure-desc"
"c#promise-desc"
"c#ratnum-desc"
"c#ref-desc?"
"c#ref-size?"
"c#ref-subtype?"
"c#ref-type?"
"c#rest-desc"
"c#return-desc"
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
) #|*/"*/"globals-s-d|#
( #|*/"*/"globals-s-nd|#
"c#body-offset"
"c#head-type-tag"
"c#head-type-tag-bits"
"c#head-type-tag-mask"
"c#head-type-tags"
"c#header-offset"
"c#imm-desc"
"c#imm-encode"
"c#imm-encoder"
"c#imm-encoder?"
"c#imm-object?"
"c#imm-type"
"c#imm-type-tag"
"c#length-mask"
"c#ref-desc"
"c#ref-encode"
"c#ref-encoder"
"c#ref-encoder?"
"c#ref-object?"
"c#ref-size"
"c#ref-subtype"
"c#ref-subtype-tag"
"c#ref-type"
"c#ref-type-tag"
"c#subtype-tag-bits"
"c#subtype-tag-mask"
"c#subtype-tags"
"c#type-tag-bits"
"c#type-tag-mask"
"c#type-tags"
"c#weak-desc"
) #|*/"*/"globals-s-nd|#
( #|*/"*/"globals-ns|#
"##integer?"
"##rational?"
"c#absent-object?"
"c#compiler-internal-error"
"c#deleted-object?"
"c#end-of-file-object?"
"c#f32vect?"
"c#f64vect?"
"c#key-object?"
"c#optional-object?"
"c#rest-object?"
"c#s16vect?"
"c#s32vect?"
"c#s64vect?"
"c#s8vect?"
"c#structure-object?"
"c#u16vect?"
"c#u32vect?"
"c#u64vect?"
"c#u8vect?"
"c#unbound1-object?"
"c#unbound2-object?"
"c#unused-object?"
"c#void-object?"
"foreign?"
) #|*/"*/"globals-ns|#
( #|*/"*/"meta-info|#
) #|*/"*/"meta-info|#
)
#else
#define ___VERSION 409006
#define ___MODULE_NAME "_t-cpu-object-desc"
#define ___LINKER_ID ___LNK___t_2d_cpu_2d_object_2d_desc
#define ___MH_PROC ___H___t_2d_cpu_2d_object_2d_desc
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 72
#define ___GLOCOUNT 116
#define ___SUPCOUNT 91
#define ___CNSCOUNT 84
#define ___SUBCOUNT 6
#define ___LBLCOUNT 178
#define ___MODDESCR ___REF_SUB(3)
#include "gambit.h"

___NEED_SYM(___S___t_2d_cpu_2d_object_2d_desc)
___NEED_SYM(___S___t_2d_cpu_2d_object_2d_desc_23_)
___NEED_SYM(___S_bignum)
___NEED_SYM(___S_boxvalues)
___NEED_SYM(___S_c_23_body_2d_offset)
___NEED_SYM(___S_c_23_desc_2d_encoder)
___NEED_SYM(___S_c_23_desc_2d_encoder_3f_)
___NEED_SYM(___S_c_23_desc_2d_type)
___NEED_SYM(___S_c_23_desc_2d_type_2d_tag)
___NEED_SYM(___S_c_23_head_2d_type_2d_tag)
___NEED_SYM(___S_c_23_header_2d_offset)
___NEED_SYM(___S_c_23_imm_2d_desc)
___NEED_SYM(___S_c_23_imm_2d_desc_3f_)
___NEED_SYM(___S_c_23_imm_2d_encode)
___NEED_SYM(___S_c_23_imm_2d_object_3f_)
___NEED_SYM(___S_c_23_imm_2d_type_3f_)
___NEED_SYM(___S_c_23_object_2d__3e_desc)
___NEED_SYM(___S_c_23_ref_2d_desc)
___NEED_SYM(___S_c_23_ref_2d_desc_3f_)
___NEED_SYM(___S_c_23_ref_2d_encode)
___NEED_SYM(___S_c_23_ref_2d_object_3f_)
___NEED_SYM(___S_c_23_ref_2d_size)
___NEED_SYM(___S_c_23_ref_2d_size_3f_)
___NEED_SYM(___S_c_23_ref_2d_subtype)
___NEED_SYM(___S_c_23_ref_2d_subtype_2d_tag)
___NEED_SYM(___S_c_23_ref_2d_subtype_3f_)
___NEED_SYM(___S_c_23_ref_2d_type_3f_)
___NEED_SYM(___S_c_23_special_2d_desc)
___NEED_SYM(___S_c_23_subtype_2d_tag)
___NEED_SYM(___S_c_23_tagged_2d_value)
___NEED_SYM(___S_c_23_type_2d_tag)
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

___NEED_GLO(___G__23__23_integer_3f_)
___NEED_GLO(___G__23__23_rational_3f_)
___NEED_GLO(___G___t_2d_cpu_2d_object_2d_desc_23_)
___NEED_GLO(___G_c_23_absent_2d_desc)
___NEED_GLO(___G_c_23_absent_2d_object_3f_)
___NEED_GLO(___G_c_23_bignum_2d_desc)
___NEED_GLO(___G_c_23_body_2d_offset)
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
___NEED_GLO(___G_c_23_f32vect_3f_)
___NEED_GLO(___G_c_23_f32vector_2d_desc)
___NEED_GLO(___G_c_23_f64vect_3f_)
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
___NEED_GLO(___G_c_23_header_2d_offset)
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
___NEED_GLO(___G_c_23_procedure_2d_desc)
___NEED_GLO(___G_c_23_promise_2d_desc)
___NEED_GLO(___G_c_23_ratnum_2d_desc)
___NEED_GLO(___G_c_23_ref_2d_desc)
___NEED_GLO(___G_c_23_ref_2d_desc_3f_)
___NEED_GLO(___G_c_23_ref_2d_encode)
___NEED_GLO(___G_c_23_ref_2d_encoder)
___NEED_GLO(___G_c_23_ref_2d_encoder_3f_)
___NEED_GLO(___G_c_23_ref_2d_object_3f_)
___NEED_GLO(___G_c_23_ref_2d_size)
___NEED_GLO(___G_c_23_ref_2d_size_3f_)
___NEED_GLO(___G_c_23_ref_2d_subtype)
___NEED_GLO(___G_c_23_ref_2d_subtype_2d_tag)
___NEED_GLO(___G_c_23_ref_2d_subtype_3f_)
___NEED_GLO(___G_c_23_ref_2d_type)
___NEED_GLO(___G_c_23_ref_2d_type_2d_tag)
___NEED_GLO(___G_c_23_ref_2d_type_3f_)
___NEED_GLO(___G_c_23_rest_2d_desc)
___NEED_GLO(___G_c_23_rest_2d_object_3f_)
___NEED_GLO(___G_c_23_return_2d_desc)
___NEED_GLO(___G_c_23_s16vect_3f_)
___NEED_GLO(___G_c_23_s16vector_2d_desc)
___NEED_GLO(___G_c_23_s32vect_3f_)
___NEED_GLO(___G_c_23_s32vector_2d_desc)
___NEED_GLO(___G_c_23_s64vect_3f_)
___NEED_GLO(___G_c_23_s64vector_2d_desc)
___NEED_GLO(___G_c_23_s8vect_3f_)
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
___NEED_GLO(___G_c_23_u16vect_3f_)
___NEED_GLO(___G_c_23_u16vector_2d_desc)
___NEED_GLO(___G_c_23_u32vect_3f_)
___NEED_GLO(___G_c_23_u32vector_2d_desc)
___NEED_GLO(___G_c_23_u64vect_3f_)
___NEED_GLO(___G_c_23_u64vector_2d_desc)
___NEED_GLO(___G_c_23_u8vect_3f_)
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
___NEED_GLO(___G_foreign_3f_)

___BEGIN_SYM
___DEF_SYM(0,___S___t_2d_cpu_2d_object_2d_desc,"_t-cpu-object-desc")
___DEF_SYM(1,___S___t_2d_cpu_2d_object_2d_desc_23_,"_t-cpu-object-desc#")
___DEF_SYM(2,___S_bignum,"bignum")
___DEF_SYM(3,___S_boxvalues,"boxvalues")
___DEF_SYM(4,___S_c_23_body_2d_offset,"c#body-offset")
___DEF_SYM(5,___S_c_23_desc_2d_encoder,"c#desc-encoder")
___DEF_SYM(6,___S_c_23_desc_2d_encoder_3f_,"c#desc-encoder?")
___DEF_SYM(7,___S_c_23_desc_2d_type,"c#desc-type")
___DEF_SYM(8,___S_c_23_desc_2d_type_2d_tag,"c#desc-type-tag")
___DEF_SYM(9,___S_c_23_head_2d_type_2d_tag,"c#head-type-tag")
___DEF_SYM(10,___S_c_23_header_2d_offset,"c#header-offset")
___DEF_SYM(11,___S_c_23_imm_2d_desc,"c#imm-desc")
___DEF_SYM(12,___S_c_23_imm_2d_desc_3f_,"c#imm-desc?")
___DEF_SYM(13,___S_c_23_imm_2d_encode,"c#imm-encode")
___DEF_SYM(14,___S_c_23_imm_2d_object_3f_,"c#imm-object?")
___DEF_SYM(15,___S_c_23_imm_2d_type_3f_,"c#imm-type?")
___DEF_SYM(16,___S_c_23_object_2d__3e_desc,"c#object->desc")
___DEF_SYM(17,___S_c_23_ref_2d_desc,"c#ref-desc")
___DEF_SYM(18,___S_c_23_ref_2d_desc_3f_,"c#ref-desc?")
___DEF_SYM(19,___S_c_23_ref_2d_encode,"c#ref-encode")
___DEF_SYM(20,___S_c_23_ref_2d_object_3f_,"c#ref-object?")
___DEF_SYM(21,___S_c_23_ref_2d_size,"c#ref-size")
___DEF_SYM(22,___S_c_23_ref_2d_size_3f_,"c#ref-size?")
___DEF_SYM(23,___S_c_23_ref_2d_subtype,"c#ref-subtype")
___DEF_SYM(24,___S_c_23_ref_2d_subtype_2d_tag,"c#ref-subtype-tag")
___DEF_SYM(25,___S_c_23_ref_2d_subtype_3f_,"c#ref-subtype?")
___DEF_SYM(26,___S_c_23_ref_2d_type_3f_,"c#ref-type?")
___DEF_SYM(27,___S_c_23_special_2d_desc,"c#special-desc")
___DEF_SYM(28,___S_c_23_subtype_2d_tag,"c#subtype-tag")
___DEF_SYM(29,___S_c_23_tagged_2d_value,"c#tagged-value")
___DEF_SYM(30,___S_c_23_type_2d_tag,"c#type-tag")
___DEF_SYM(31,___S_continuation,"continuation")
___DEF_SYM(32,___S_cpxnum,"cpxnum")
___DEF_SYM(33,___S_f32vector,"f32vector")
___DEF_SYM(34,___S_f64vector,"f64vector")
___DEF_SYM(35,___S_fixnum,"fixnum")
___DEF_SYM(36,___S_flonum,"flonum")
___DEF_SYM(37,___S_foreign,"foreign")
___DEF_SYM(38,___S_forw,"forw")
___DEF_SYM(39,___S_frame,"frame")
___DEF_SYM(40,___S_imm,"imm")
___DEF_SYM(41,___S_jazz,"jazz")
___DEF_SYM(42,___S_keyword,"keyword")
___DEF_SYM(43,___S_mem1,"mem1")
___DEF_SYM(44,___S_mem2,"mem2")
___DEF_SYM(45,___S_meroon,"meroon")
___DEF_SYM(46,___S_movable0,"movable0")
___DEF_SYM(47,___S_movable1,"movable1")
___DEF_SYM(48,___S_movable2,"movable2")
___DEF_SYM(49,___S_pair,"pair")
___DEF_SYM(50,___S_perm,"perm")
___DEF_SYM(51,___S_procedure,"procedure")
___DEF_SYM(52,___S_promise,"promise")
___DEF_SYM(53,___S_ratnum,"ratnum")
___DEF_SYM(54,___S_ref,"ref")
___DEF_SYM(55,___S_return,"return")
___DEF_SYM(56,___S_s16vector,"s16vector")
___DEF_SYM(57,___S_s32vector,"s32vector")
___DEF_SYM(58,___S_s64vector,"s64vector")
___DEF_SYM(59,___S_s8vector,"s8vector")
___DEF_SYM(60,___S_special,"special")
___DEF_SYM(61,___S_still,"still")
___DEF_SYM(62,___S_string,"string")
___DEF_SYM(63,___S_structure,"structure")
___DEF_SYM(64,___S_subtyped,"subtyped")
___DEF_SYM(65,___S_symbol,"symbol")
___DEF_SYM(66,___S_u16vector,"u16vector")
___DEF_SYM(67,___S_u32vector,"u32vector")
___DEF_SYM(68,___S_u64vector,"u64vector")
___DEF_SYM(69,___S_u8vector,"u8vector")
___DEF_SYM(70,___S_vector,"vector")
___DEF_SYM(71,___S_weak,"weak")
___END_SYM

#define ___SYM___t_2d_cpu_2d_object_2d_desc ___SYM(0,___S___t_2d_cpu_2d_object_2d_desc)
#define ___SYM___t_2d_cpu_2d_object_2d_desc_23_ ___SYM(1,___S___t_2d_cpu_2d_object_2d_desc_23_)
#define ___SYM_bignum ___SYM(2,___S_bignum)
#define ___SYM_boxvalues ___SYM(3,___S_boxvalues)
#define ___SYM_c_23_body_2d_offset ___SYM(4,___S_c_23_body_2d_offset)
#define ___SYM_c_23_desc_2d_encoder ___SYM(5,___S_c_23_desc_2d_encoder)
#define ___SYM_c_23_desc_2d_encoder_3f_ ___SYM(6,___S_c_23_desc_2d_encoder_3f_)
#define ___SYM_c_23_desc_2d_type ___SYM(7,___S_c_23_desc_2d_type)
#define ___SYM_c_23_desc_2d_type_2d_tag ___SYM(8,___S_c_23_desc_2d_type_2d_tag)
#define ___SYM_c_23_head_2d_type_2d_tag ___SYM(9,___S_c_23_head_2d_type_2d_tag)
#define ___SYM_c_23_header_2d_offset ___SYM(10,___S_c_23_header_2d_offset)
#define ___SYM_c_23_imm_2d_desc ___SYM(11,___S_c_23_imm_2d_desc)
#define ___SYM_c_23_imm_2d_desc_3f_ ___SYM(12,___S_c_23_imm_2d_desc_3f_)
#define ___SYM_c_23_imm_2d_encode ___SYM(13,___S_c_23_imm_2d_encode)
#define ___SYM_c_23_imm_2d_object_3f_ ___SYM(14,___S_c_23_imm_2d_object_3f_)
#define ___SYM_c_23_imm_2d_type_3f_ ___SYM(15,___S_c_23_imm_2d_type_3f_)
#define ___SYM_c_23_object_2d__3e_desc ___SYM(16,___S_c_23_object_2d__3e_desc)
#define ___SYM_c_23_ref_2d_desc ___SYM(17,___S_c_23_ref_2d_desc)
#define ___SYM_c_23_ref_2d_desc_3f_ ___SYM(18,___S_c_23_ref_2d_desc_3f_)
#define ___SYM_c_23_ref_2d_encode ___SYM(19,___S_c_23_ref_2d_encode)
#define ___SYM_c_23_ref_2d_object_3f_ ___SYM(20,___S_c_23_ref_2d_object_3f_)
#define ___SYM_c_23_ref_2d_size ___SYM(21,___S_c_23_ref_2d_size)
#define ___SYM_c_23_ref_2d_size_3f_ ___SYM(22,___S_c_23_ref_2d_size_3f_)
#define ___SYM_c_23_ref_2d_subtype ___SYM(23,___S_c_23_ref_2d_subtype)
#define ___SYM_c_23_ref_2d_subtype_2d_tag ___SYM(24,___S_c_23_ref_2d_subtype_2d_tag)
#define ___SYM_c_23_ref_2d_subtype_3f_ ___SYM(25,___S_c_23_ref_2d_subtype_3f_)
#define ___SYM_c_23_ref_2d_type_3f_ ___SYM(26,___S_c_23_ref_2d_type_3f_)
#define ___SYM_c_23_special_2d_desc ___SYM(27,___S_c_23_special_2d_desc)
#define ___SYM_c_23_subtype_2d_tag ___SYM(28,___S_c_23_subtype_2d_tag)
#define ___SYM_c_23_tagged_2d_value ___SYM(29,___S_c_23_tagged_2d_value)
#define ___SYM_c_23_type_2d_tag ___SYM(30,___S_c_23_type_2d_tag)
#define ___SYM_continuation ___SYM(31,___S_continuation)
#define ___SYM_cpxnum ___SYM(32,___S_cpxnum)
#define ___SYM_f32vector ___SYM(33,___S_f32vector)
#define ___SYM_f64vector ___SYM(34,___S_f64vector)
#define ___SYM_fixnum ___SYM(35,___S_fixnum)
#define ___SYM_flonum ___SYM(36,___S_flonum)
#define ___SYM_foreign ___SYM(37,___S_foreign)
#define ___SYM_forw ___SYM(38,___S_forw)
#define ___SYM_frame ___SYM(39,___S_frame)
#define ___SYM_imm ___SYM(40,___S_imm)
#define ___SYM_jazz ___SYM(41,___S_jazz)
#define ___SYM_keyword ___SYM(42,___S_keyword)
#define ___SYM_mem1 ___SYM(43,___S_mem1)
#define ___SYM_mem2 ___SYM(44,___S_mem2)
#define ___SYM_meroon ___SYM(45,___S_meroon)
#define ___SYM_movable0 ___SYM(46,___S_movable0)
#define ___SYM_movable1 ___SYM(47,___S_movable1)
#define ___SYM_movable2 ___SYM(48,___S_movable2)
#define ___SYM_pair ___SYM(49,___S_pair)
#define ___SYM_perm ___SYM(50,___S_perm)
#define ___SYM_procedure ___SYM(51,___S_procedure)
#define ___SYM_promise ___SYM(52,___S_promise)
#define ___SYM_ratnum ___SYM(53,___S_ratnum)
#define ___SYM_ref ___SYM(54,___S_ref)
#define ___SYM_return ___SYM(55,___S_return)
#define ___SYM_s16vector ___SYM(56,___S_s16vector)
#define ___SYM_s32vector ___SYM(57,___S_s32vector)
#define ___SYM_s64vector ___SYM(58,___S_s64vector)
#define ___SYM_s8vector ___SYM(59,___S_s8vector)
#define ___SYM_special ___SYM(60,___S_special)
#define ___SYM_still ___SYM(61,___S_still)
#define ___SYM_string ___SYM(62,___S_string)
#define ___SYM_structure ___SYM(63,___S_structure)
#define ___SYM_subtyped ___SYM(64,___S_subtyped)
#define ___SYM_symbol ___SYM(65,___S_symbol)
#define ___SYM_u16vector ___SYM(66,___S_u16vector)
#define ___SYM_u32vector ___SYM(67,___S_u32vector)
#define ___SYM_u64vector ___SYM(68,___S_u64vector)
#define ___SYM_u8vector ___SYM(69,___S_u8vector)
#define ___SYM_vector ___SYM(70,___S_vector)
#define ___SYM_weak ___SYM(71,___S_weak)

___BEGIN_GLO
___DEF_GLO(0,"_t-cpu-object-desc#")
___DEF_GLO(1,"c#absent-desc")
___DEF_GLO(2,"c#bignum-desc")
___DEF_GLO(3,"c#body-offset")
___DEF_GLO(4,"c#boxvalues-desc")
___DEF_GLO(5,"c#char-desc")
___DEF_GLO(6,"c#continuation-desc")
___DEF_GLO(7,"c#cpxnum-desc")
___DEF_GLO(8,"c#deleted-desc")
___DEF_GLO(9,"c#desc-encoder")
___DEF_GLO(10,"c#desc-encoder?")
___DEF_GLO(11,"c#desc-type")
___DEF_GLO(12,"c#desc-type-tag")
___DEF_GLO(13,"c#eof-desc")
___DEF_GLO(14,"c#f32vector-desc")
___DEF_GLO(15,"c#f64vector-desc")
___DEF_GLO(16,"c#fal-desc")
___DEF_GLO(17,"c#fixnum-desc")
___DEF_GLO(18,"c#flonum-desc")
___DEF_GLO(19,"c#foreign-desc")
___DEF_GLO(20,"c#frame-desc")
___DEF_GLO(21,"c#head-type-tag")
___DEF_GLO(22,"c#head-type-tag-bits")
___DEF_GLO(23,"c#head-type-tag-mask")
___DEF_GLO(24,"c#head-type-tags")
___DEF_GLO(25,"c#header-offset")
___DEF_GLO(26,"c#imm-desc")
___DEF_GLO(27,"c#imm-desc?")
___DEF_GLO(28,"c#imm-encode")
___DEF_GLO(29,"c#imm-encoder")
___DEF_GLO(30,"c#imm-encoder?")
___DEF_GLO(31,"c#imm-object?")
___DEF_GLO(32,"c#imm-type")
___DEF_GLO(33,"c#imm-type-tag")
___DEF_GLO(34,"c#imm-type?")
___DEF_GLO(35,"c#jazz-desc")
___DEF_GLO(36,"c#keyobj-desc")
___DEF_GLO(37,"c#keyword-desc")
___DEF_GLO(38,"c#length-mask")
___DEF_GLO(39,"c#meroon-desc")
___DEF_GLO(40,"c#nul-desc")
___DEF_GLO(41,"c#object->desc")
___DEF_GLO(42,"c#optional-desc")
___DEF_GLO(43,"c#pair-desc")
___DEF_GLO(44,"c#procedure-desc")
___DEF_GLO(45,"c#promise-desc")
___DEF_GLO(46,"c#ratnum-desc")
___DEF_GLO(47,"c#ref-desc")
___DEF_GLO(48,"c#ref-desc?")
___DEF_GLO(49,"c#ref-encode")
___DEF_GLO(50,"c#ref-encoder")
___DEF_GLO(51,"c#ref-encoder?")
___DEF_GLO(52,"c#ref-object?")
___DEF_GLO(53,"c#ref-size")
___DEF_GLO(54,"c#ref-size?")
___DEF_GLO(55,"c#ref-subtype")
___DEF_GLO(56,"c#ref-subtype-tag")
___DEF_GLO(57,"c#ref-subtype?")
___DEF_GLO(58,"c#ref-type")
___DEF_GLO(59,"c#ref-type-tag")
___DEF_GLO(60,"c#ref-type?")
___DEF_GLO(61,"c#rest-desc")
___DEF_GLO(62,"c#return-desc")
___DEF_GLO(63,"c#s16vector-desc")
___DEF_GLO(64,"c#s32vector-desc")
___DEF_GLO(65,"c#s64vector-desc")
___DEF_GLO(66,"c#s8vector-desc")
___DEF_GLO(67,"c#special-desc")
___DEF_GLO(68,"c#string-desc")
___DEF_GLO(69,"c#structure-desc")
___DEF_GLO(70,"c#subtype-tag")
___DEF_GLO(71,"c#subtype-tag-bits")
___DEF_GLO(72,"c#subtype-tag-mask")
___DEF_GLO(73,"c#subtype-tags")
___DEF_GLO(74,"c#symbol-desc")
___DEF_GLO(75,"c#tagged-value")
___DEF_GLO(76,"c#tru-desc")
___DEF_GLO(77,"c#type-tag")
___DEF_GLO(78,"c#type-tag-bits")
___DEF_GLO(79,"c#type-tag-mask")
___DEF_GLO(80,"c#type-tags")
___DEF_GLO(81,"c#u16vector-desc")
___DEF_GLO(82,"c#u32vector-desc")
___DEF_GLO(83,"c#u64vector-desc")
___DEF_GLO(84,"c#u8vector-desc")
___DEF_GLO(85,"c#unb1-desc")
___DEF_GLO(86,"c#unb2-desc")
___DEF_GLO(87,"c#unused-desc")
___DEF_GLO(88,"c#vector-desc")
___DEF_GLO(89,"c#void-desc")
___DEF_GLO(90,"c#weak-desc")
___DEF_GLO(91,"##integer?")
___DEF_GLO(92,"##rational?")
___DEF_GLO(93,"c#absent-object?")
___DEF_GLO(94,"c#compiler-internal-error")
___DEF_GLO(95,"c#deleted-object?")
___DEF_GLO(96,"c#end-of-file-object?")
___DEF_GLO(97,"c#f32vect?")
___DEF_GLO(98,"c#f64vect?")
___DEF_GLO(99,"c#key-object?")
___DEF_GLO(100,"c#optional-object?")
___DEF_GLO(101,"c#rest-object?")
___DEF_GLO(102,"c#s16vect?")
___DEF_GLO(103,"c#s32vect?")
___DEF_GLO(104,"c#s64vect?")
___DEF_GLO(105,"c#s8vect?")
___DEF_GLO(106,"c#structure-object?")
___DEF_GLO(107,"c#u16vect?")
___DEF_GLO(108,"c#u32vect?")
___DEF_GLO(109,"c#u64vect?")
___DEF_GLO(110,"c#u8vect?")
___DEF_GLO(111,"c#unbound1-object?")
___DEF_GLO(112,"c#unbound2-object?")
___DEF_GLO(113,"c#unused-object?")
___DEF_GLO(114,"c#void-object?")
___DEF_GLO(115,"foreign?")
___END_GLO

#define ___GLO___t_2d_cpu_2d_object_2d_desc_23_ ___GLO(0,___G___t_2d_cpu_2d_object_2d_desc_23_)
#define ___PRM___t_2d_cpu_2d_object_2d_desc_23_ ___PRM(0,___G___t_2d_cpu_2d_object_2d_desc_23_)
#define ___GLO_c_23_absent_2d_desc ___GLO(1,___G_c_23_absent_2d_desc)
#define ___PRM_c_23_absent_2d_desc ___PRM(1,___G_c_23_absent_2d_desc)
#define ___GLO_c_23_bignum_2d_desc ___GLO(2,___G_c_23_bignum_2d_desc)
#define ___PRM_c_23_bignum_2d_desc ___PRM(2,___G_c_23_bignum_2d_desc)
#define ___GLO_c_23_body_2d_offset ___GLO(3,___G_c_23_body_2d_offset)
#define ___PRM_c_23_body_2d_offset ___PRM(3,___G_c_23_body_2d_offset)
#define ___GLO_c_23_boxvalues_2d_desc ___GLO(4,___G_c_23_boxvalues_2d_desc)
#define ___PRM_c_23_boxvalues_2d_desc ___PRM(4,___G_c_23_boxvalues_2d_desc)
#define ___GLO_c_23_char_2d_desc ___GLO(5,___G_c_23_char_2d_desc)
#define ___PRM_c_23_char_2d_desc ___PRM(5,___G_c_23_char_2d_desc)
#define ___GLO_c_23_continuation_2d_desc ___GLO(6,___G_c_23_continuation_2d_desc)
#define ___PRM_c_23_continuation_2d_desc ___PRM(6,___G_c_23_continuation_2d_desc)
#define ___GLO_c_23_cpxnum_2d_desc ___GLO(7,___G_c_23_cpxnum_2d_desc)
#define ___PRM_c_23_cpxnum_2d_desc ___PRM(7,___G_c_23_cpxnum_2d_desc)
#define ___GLO_c_23_deleted_2d_desc ___GLO(8,___G_c_23_deleted_2d_desc)
#define ___PRM_c_23_deleted_2d_desc ___PRM(8,___G_c_23_deleted_2d_desc)
#define ___GLO_c_23_desc_2d_encoder ___GLO(9,___G_c_23_desc_2d_encoder)
#define ___PRM_c_23_desc_2d_encoder ___PRM(9,___G_c_23_desc_2d_encoder)
#define ___GLO_c_23_desc_2d_encoder_3f_ ___GLO(10,___G_c_23_desc_2d_encoder_3f_)
#define ___PRM_c_23_desc_2d_encoder_3f_ ___PRM(10,___G_c_23_desc_2d_encoder_3f_)
#define ___GLO_c_23_desc_2d_type ___GLO(11,___G_c_23_desc_2d_type)
#define ___PRM_c_23_desc_2d_type ___PRM(11,___G_c_23_desc_2d_type)
#define ___GLO_c_23_desc_2d_type_2d_tag ___GLO(12,___G_c_23_desc_2d_type_2d_tag)
#define ___PRM_c_23_desc_2d_type_2d_tag ___PRM(12,___G_c_23_desc_2d_type_2d_tag)
#define ___GLO_c_23_eof_2d_desc ___GLO(13,___G_c_23_eof_2d_desc)
#define ___PRM_c_23_eof_2d_desc ___PRM(13,___G_c_23_eof_2d_desc)
#define ___GLO_c_23_f32vector_2d_desc ___GLO(14,___G_c_23_f32vector_2d_desc)
#define ___PRM_c_23_f32vector_2d_desc ___PRM(14,___G_c_23_f32vector_2d_desc)
#define ___GLO_c_23_f64vector_2d_desc ___GLO(15,___G_c_23_f64vector_2d_desc)
#define ___PRM_c_23_f64vector_2d_desc ___PRM(15,___G_c_23_f64vector_2d_desc)
#define ___GLO_c_23_fal_2d_desc ___GLO(16,___G_c_23_fal_2d_desc)
#define ___PRM_c_23_fal_2d_desc ___PRM(16,___G_c_23_fal_2d_desc)
#define ___GLO_c_23_fixnum_2d_desc ___GLO(17,___G_c_23_fixnum_2d_desc)
#define ___PRM_c_23_fixnum_2d_desc ___PRM(17,___G_c_23_fixnum_2d_desc)
#define ___GLO_c_23_flonum_2d_desc ___GLO(18,___G_c_23_flonum_2d_desc)
#define ___PRM_c_23_flonum_2d_desc ___PRM(18,___G_c_23_flonum_2d_desc)
#define ___GLO_c_23_foreign_2d_desc ___GLO(19,___G_c_23_foreign_2d_desc)
#define ___PRM_c_23_foreign_2d_desc ___PRM(19,___G_c_23_foreign_2d_desc)
#define ___GLO_c_23_frame_2d_desc ___GLO(20,___G_c_23_frame_2d_desc)
#define ___PRM_c_23_frame_2d_desc ___PRM(20,___G_c_23_frame_2d_desc)
#define ___GLO_c_23_head_2d_type_2d_tag ___GLO(21,___G_c_23_head_2d_type_2d_tag)
#define ___PRM_c_23_head_2d_type_2d_tag ___PRM(21,___G_c_23_head_2d_type_2d_tag)
#define ___GLO_c_23_head_2d_type_2d_tag_2d_bits ___GLO(22,___G_c_23_head_2d_type_2d_tag_2d_bits)
#define ___PRM_c_23_head_2d_type_2d_tag_2d_bits ___PRM(22,___G_c_23_head_2d_type_2d_tag_2d_bits)
#define ___GLO_c_23_head_2d_type_2d_tag_2d_mask ___GLO(23,___G_c_23_head_2d_type_2d_tag_2d_mask)
#define ___PRM_c_23_head_2d_type_2d_tag_2d_mask ___PRM(23,___G_c_23_head_2d_type_2d_tag_2d_mask)
#define ___GLO_c_23_head_2d_type_2d_tags ___GLO(24,___G_c_23_head_2d_type_2d_tags)
#define ___PRM_c_23_head_2d_type_2d_tags ___PRM(24,___G_c_23_head_2d_type_2d_tags)
#define ___GLO_c_23_header_2d_offset ___GLO(25,___G_c_23_header_2d_offset)
#define ___PRM_c_23_header_2d_offset ___PRM(25,___G_c_23_header_2d_offset)
#define ___GLO_c_23_imm_2d_desc ___GLO(26,___G_c_23_imm_2d_desc)
#define ___PRM_c_23_imm_2d_desc ___PRM(26,___G_c_23_imm_2d_desc)
#define ___GLO_c_23_imm_2d_desc_3f_ ___GLO(27,___G_c_23_imm_2d_desc_3f_)
#define ___PRM_c_23_imm_2d_desc_3f_ ___PRM(27,___G_c_23_imm_2d_desc_3f_)
#define ___GLO_c_23_imm_2d_encode ___GLO(28,___G_c_23_imm_2d_encode)
#define ___PRM_c_23_imm_2d_encode ___PRM(28,___G_c_23_imm_2d_encode)
#define ___GLO_c_23_imm_2d_encoder ___GLO(29,___G_c_23_imm_2d_encoder)
#define ___PRM_c_23_imm_2d_encoder ___PRM(29,___G_c_23_imm_2d_encoder)
#define ___GLO_c_23_imm_2d_encoder_3f_ ___GLO(30,___G_c_23_imm_2d_encoder_3f_)
#define ___PRM_c_23_imm_2d_encoder_3f_ ___PRM(30,___G_c_23_imm_2d_encoder_3f_)
#define ___GLO_c_23_imm_2d_object_3f_ ___GLO(31,___G_c_23_imm_2d_object_3f_)
#define ___PRM_c_23_imm_2d_object_3f_ ___PRM(31,___G_c_23_imm_2d_object_3f_)
#define ___GLO_c_23_imm_2d_type ___GLO(32,___G_c_23_imm_2d_type)
#define ___PRM_c_23_imm_2d_type ___PRM(32,___G_c_23_imm_2d_type)
#define ___GLO_c_23_imm_2d_type_2d_tag ___GLO(33,___G_c_23_imm_2d_type_2d_tag)
#define ___PRM_c_23_imm_2d_type_2d_tag ___PRM(33,___G_c_23_imm_2d_type_2d_tag)
#define ___GLO_c_23_imm_2d_type_3f_ ___GLO(34,___G_c_23_imm_2d_type_3f_)
#define ___PRM_c_23_imm_2d_type_3f_ ___PRM(34,___G_c_23_imm_2d_type_3f_)
#define ___GLO_c_23_jazz_2d_desc ___GLO(35,___G_c_23_jazz_2d_desc)
#define ___PRM_c_23_jazz_2d_desc ___PRM(35,___G_c_23_jazz_2d_desc)
#define ___GLO_c_23_keyobj_2d_desc ___GLO(36,___G_c_23_keyobj_2d_desc)
#define ___PRM_c_23_keyobj_2d_desc ___PRM(36,___G_c_23_keyobj_2d_desc)
#define ___GLO_c_23_keyword_2d_desc ___GLO(37,___G_c_23_keyword_2d_desc)
#define ___PRM_c_23_keyword_2d_desc ___PRM(37,___G_c_23_keyword_2d_desc)
#define ___GLO_c_23_length_2d_mask ___GLO(38,___G_c_23_length_2d_mask)
#define ___PRM_c_23_length_2d_mask ___PRM(38,___G_c_23_length_2d_mask)
#define ___GLO_c_23_meroon_2d_desc ___GLO(39,___G_c_23_meroon_2d_desc)
#define ___PRM_c_23_meroon_2d_desc ___PRM(39,___G_c_23_meroon_2d_desc)
#define ___GLO_c_23_nul_2d_desc ___GLO(40,___G_c_23_nul_2d_desc)
#define ___PRM_c_23_nul_2d_desc ___PRM(40,___G_c_23_nul_2d_desc)
#define ___GLO_c_23_object_2d__3e_desc ___GLO(41,___G_c_23_object_2d__3e_desc)
#define ___PRM_c_23_object_2d__3e_desc ___PRM(41,___G_c_23_object_2d__3e_desc)
#define ___GLO_c_23_optional_2d_desc ___GLO(42,___G_c_23_optional_2d_desc)
#define ___PRM_c_23_optional_2d_desc ___PRM(42,___G_c_23_optional_2d_desc)
#define ___GLO_c_23_pair_2d_desc ___GLO(43,___G_c_23_pair_2d_desc)
#define ___PRM_c_23_pair_2d_desc ___PRM(43,___G_c_23_pair_2d_desc)
#define ___GLO_c_23_procedure_2d_desc ___GLO(44,___G_c_23_procedure_2d_desc)
#define ___PRM_c_23_procedure_2d_desc ___PRM(44,___G_c_23_procedure_2d_desc)
#define ___GLO_c_23_promise_2d_desc ___GLO(45,___G_c_23_promise_2d_desc)
#define ___PRM_c_23_promise_2d_desc ___PRM(45,___G_c_23_promise_2d_desc)
#define ___GLO_c_23_ratnum_2d_desc ___GLO(46,___G_c_23_ratnum_2d_desc)
#define ___PRM_c_23_ratnum_2d_desc ___PRM(46,___G_c_23_ratnum_2d_desc)
#define ___GLO_c_23_ref_2d_desc ___GLO(47,___G_c_23_ref_2d_desc)
#define ___PRM_c_23_ref_2d_desc ___PRM(47,___G_c_23_ref_2d_desc)
#define ___GLO_c_23_ref_2d_desc_3f_ ___GLO(48,___G_c_23_ref_2d_desc_3f_)
#define ___PRM_c_23_ref_2d_desc_3f_ ___PRM(48,___G_c_23_ref_2d_desc_3f_)
#define ___GLO_c_23_ref_2d_encode ___GLO(49,___G_c_23_ref_2d_encode)
#define ___PRM_c_23_ref_2d_encode ___PRM(49,___G_c_23_ref_2d_encode)
#define ___GLO_c_23_ref_2d_encoder ___GLO(50,___G_c_23_ref_2d_encoder)
#define ___PRM_c_23_ref_2d_encoder ___PRM(50,___G_c_23_ref_2d_encoder)
#define ___GLO_c_23_ref_2d_encoder_3f_ ___GLO(51,___G_c_23_ref_2d_encoder_3f_)
#define ___PRM_c_23_ref_2d_encoder_3f_ ___PRM(51,___G_c_23_ref_2d_encoder_3f_)
#define ___GLO_c_23_ref_2d_object_3f_ ___GLO(52,___G_c_23_ref_2d_object_3f_)
#define ___PRM_c_23_ref_2d_object_3f_ ___PRM(52,___G_c_23_ref_2d_object_3f_)
#define ___GLO_c_23_ref_2d_size ___GLO(53,___G_c_23_ref_2d_size)
#define ___PRM_c_23_ref_2d_size ___PRM(53,___G_c_23_ref_2d_size)
#define ___GLO_c_23_ref_2d_size_3f_ ___GLO(54,___G_c_23_ref_2d_size_3f_)
#define ___PRM_c_23_ref_2d_size_3f_ ___PRM(54,___G_c_23_ref_2d_size_3f_)
#define ___GLO_c_23_ref_2d_subtype ___GLO(55,___G_c_23_ref_2d_subtype)
#define ___PRM_c_23_ref_2d_subtype ___PRM(55,___G_c_23_ref_2d_subtype)
#define ___GLO_c_23_ref_2d_subtype_2d_tag ___GLO(56,___G_c_23_ref_2d_subtype_2d_tag)
#define ___PRM_c_23_ref_2d_subtype_2d_tag ___PRM(56,___G_c_23_ref_2d_subtype_2d_tag)
#define ___GLO_c_23_ref_2d_subtype_3f_ ___GLO(57,___G_c_23_ref_2d_subtype_3f_)
#define ___PRM_c_23_ref_2d_subtype_3f_ ___PRM(57,___G_c_23_ref_2d_subtype_3f_)
#define ___GLO_c_23_ref_2d_type ___GLO(58,___G_c_23_ref_2d_type)
#define ___PRM_c_23_ref_2d_type ___PRM(58,___G_c_23_ref_2d_type)
#define ___GLO_c_23_ref_2d_type_2d_tag ___GLO(59,___G_c_23_ref_2d_type_2d_tag)
#define ___PRM_c_23_ref_2d_type_2d_tag ___PRM(59,___G_c_23_ref_2d_type_2d_tag)
#define ___GLO_c_23_ref_2d_type_3f_ ___GLO(60,___G_c_23_ref_2d_type_3f_)
#define ___PRM_c_23_ref_2d_type_3f_ ___PRM(60,___G_c_23_ref_2d_type_3f_)
#define ___GLO_c_23_rest_2d_desc ___GLO(61,___G_c_23_rest_2d_desc)
#define ___PRM_c_23_rest_2d_desc ___PRM(61,___G_c_23_rest_2d_desc)
#define ___GLO_c_23_return_2d_desc ___GLO(62,___G_c_23_return_2d_desc)
#define ___PRM_c_23_return_2d_desc ___PRM(62,___G_c_23_return_2d_desc)
#define ___GLO_c_23_s16vector_2d_desc ___GLO(63,___G_c_23_s16vector_2d_desc)
#define ___PRM_c_23_s16vector_2d_desc ___PRM(63,___G_c_23_s16vector_2d_desc)
#define ___GLO_c_23_s32vector_2d_desc ___GLO(64,___G_c_23_s32vector_2d_desc)
#define ___PRM_c_23_s32vector_2d_desc ___PRM(64,___G_c_23_s32vector_2d_desc)
#define ___GLO_c_23_s64vector_2d_desc ___GLO(65,___G_c_23_s64vector_2d_desc)
#define ___PRM_c_23_s64vector_2d_desc ___PRM(65,___G_c_23_s64vector_2d_desc)
#define ___GLO_c_23_s8vector_2d_desc ___GLO(66,___G_c_23_s8vector_2d_desc)
#define ___PRM_c_23_s8vector_2d_desc ___PRM(66,___G_c_23_s8vector_2d_desc)
#define ___GLO_c_23_special_2d_desc ___GLO(67,___G_c_23_special_2d_desc)
#define ___PRM_c_23_special_2d_desc ___PRM(67,___G_c_23_special_2d_desc)
#define ___GLO_c_23_string_2d_desc ___GLO(68,___G_c_23_string_2d_desc)
#define ___PRM_c_23_string_2d_desc ___PRM(68,___G_c_23_string_2d_desc)
#define ___GLO_c_23_structure_2d_desc ___GLO(69,___G_c_23_structure_2d_desc)
#define ___PRM_c_23_structure_2d_desc ___PRM(69,___G_c_23_structure_2d_desc)
#define ___GLO_c_23_subtype_2d_tag ___GLO(70,___G_c_23_subtype_2d_tag)
#define ___PRM_c_23_subtype_2d_tag ___PRM(70,___G_c_23_subtype_2d_tag)
#define ___GLO_c_23_subtype_2d_tag_2d_bits ___GLO(71,___G_c_23_subtype_2d_tag_2d_bits)
#define ___PRM_c_23_subtype_2d_tag_2d_bits ___PRM(71,___G_c_23_subtype_2d_tag_2d_bits)
#define ___GLO_c_23_subtype_2d_tag_2d_mask ___GLO(72,___G_c_23_subtype_2d_tag_2d_mask)
#define ___PRM_c_23_subtype_2d_tag_2d_mask ___PRM(72,___G_c_23_subtype_2d_tag_2d_mask)
#define ___GLO_c_23_subtype_2d_tags ___GLO(73,___G_c_23_subtype_2d_tags)
#define ___PRM_c_23_subtype_2d_tags ___PRM(73,___G_c_23_subtype_2d_tags)
#define ___GLO_c_23_symbol_2d_desc ___GLO(74,___G_c_23_symbol_2d_desc)
#define ___PRM_c_23_symbol_2d_desc ___PRM(74,___G_c_23_symbol_2d_desc)
#define ___GLO_c_23_tagged_2d_value ___GLO(75,___G_c_23_tagged_2d_value)
#define ___PRM_c_23_tagged_2d_value ___PRM(75,___G_c_23_tagged_2d_value)
#define ___GLO_c_23_tru_2d_desc ___GLO(76,___G_c_23_tru_2d_desc)
#define ___PRM_c_23_tru_2d_desc ___PRM(76,___G_c_23_tru_2d_desc)
#define ___GLO_c_23_type_2d_tag ___GLO(77,___G_c_23_type_2d_tag)
#define ___PRM_c_23_type_2d_tag ___PRM(77,___G_c_23_type_2d_tag)
#define ___GLO_c_23_type_2d_tag_2d_bits ___GLO(78,___G_c_23_type_2d_tag_2d_bits)
#define ___PRM_c_23_type_2d_tag_2d_bits ___PRM(78,___G_c_23_type_2d_tag_2d_bits)
#define ___GLO_c_23_type_2d_tag_2d_mask ___GLO(79,___G_c_23_type_2d_tag_2d_mask)
#define ___PRM_c_23_type_2d_tag_2d_mask ___PRM(79,___G_c_23_type_2d_tag_2d_mask)
#define ___GLO_c_23_type_2d_tags ___GLO(80,___G_c_23_type_2d_tags)
#define ___PRM_c_23_type_2d_tags ___PRM(80,___G_c_23_type_2d_tags)
#define ___GLO_c_23_u16vector_2d_desc ___GLO(81,___G_c_23_u16vector_2d_desc)
#define ___PRM_c_23_u16vector_2d_desc ___PRM(81,___G_c_23_u16vector_2d_desc)
#define ___GLO_c_23_u32vector_2d_desc ___GLO(82,___G_c_23_u32vector_2d_desc)
#define ___PRM_c_23_u32vector_2d_desc ___PRM(82,___G_c_23_u32vector_2d_desc)
#define ___GLO_c_23_u64vector_2d_desc ___GLO(83,___G_c_23_u64vector_2d_desc)
#define ___PRM_c_23_u64vector_2d_desc ___PRM(83,___G_c_23_u64vector_2d_desc)
#define ___GLO_c_23_u8vector_2d_desc ___GLO(84,___G_c_23_u8vector_2d_desc)
#define ___PRM_c_23_u8vector_2d_desc ___PRM(84,___G_c_23_u8vector_2d_desc)
#define ___GLO_c_23_unb1_2d_desc ___GLO(85,___G_c_23_unb1_2d_desc)
#define ___PRM_c_23_unb1_2d_desc ___PRM(85,___G_c_23_unb1_2d_desc)
#define ___GLO_c_23_unb2_2d_desc ___GLO(86,___G_c_23_unb2_2d_desc)
#define ___PRM_c_23_unb2_2d_desc ___PRM(86,___G_c_23_unb2_2d_desc)
#define ___GLO_c_23_unused_2d_desc ___GLO(87,___G_c_23_unused_2d_desc)
#define ___PRM_c_23_unused_2d_desc ___PRM(87,___G_c_23_unused_2d_desc)
#define ___GLO_c_23_vector_2d_desc ___GLO(88,___G_c_23_vector_2d_desc)
#define ___PRM_c_23_vector_2d_desc ___PRM(88,___G_c_23_vector_2d_desc)
#define ___GLO_c_23_void_2d_desc ___GLO(89,___G_c_23_void_2d_desc)
#define ___PRM_c_23_void_2d_desc ___PRM(89,___G_c_23_void_2d_desc)
#define ___GLO_c_23_weak_2d_desc ___GLO(90,___G_c_23_weak_2d_desc)
#define ___PRM_c_23_weak_2d_desc ___PRM(90,___G_c_23_weak_2d_desc)
#define ___GLO__23__23_integer_3f_ ___GLO(91,___G__23__23_integer_3f_)
#define ___PRM__23__23_integer_3f_ ___PRM(91,___G__23__23_integer_3f_)
#define ___GLO__23__23_rational_3f_ ___GLO(92,___G__23__23_rational_3f_)
#define ___PRM__23__23_rational_3f_ ___PRM(92,___G__23__23_rational_3f_)
#define ___GLO_c_23_absent_2d_object_3f_ ___GLO(93,___G_c_23_absent_2d_object_3f_)
#define ___PRM_c_23_absent_2d_object_3f_ ___PRM(93,___G_c_23_absent_2d_object_3f_)
#define ___GLO_c_23_compiler_2d_internal_2d_error ___GLO(94,___G_c_23_compiler_2d_internal_2d_error)
#define ___PRM_c_23_compiler_2d_internal_2d_error ___PRM(94,___G_c_23_compiler_2d_internal_2d_error)
#define ___GLO_c_23_deleted_2d_object_3f_ ___GLO(95,___G_c_23_deleted_2d_object_3f_)
#define ___PRM_c_23_deleted_2d_object_3f_ ___PRM(95,___G_c_23_deleted_2d_object_3f_)
#define ___GLO_c_23_end_2d_of_2d_file_2d_object_3f_ ___GLO(96,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___PRM_c_23_end_2d_of_2d_file_2d_object_3f_ ___PRM(96,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___GLO_c_23_f32vect_3f_ ___GLO(97,___G_c_23_f32vect_3f_)
#define ___PRM_c_23_f32vect_3f_ ___PRM(97,___G_c_23_f32vect_3f_)
#define ___GLO_c_23_f64vect_3f_ ___GLO(98,___G_c_23_f64vect_3f_)
#define ___PRM_c_23_f64vect_3f_ ___PRM(98,___G_c_23_f64vect_3f_)
#define ___GLO_c_23_key_2d_object_3f_ ___GLO(99,___G_c_23_key_2d_object_3f_)
#define ___PRM_c_23_key_2d_object_3f_ ___PRM(99,___G_c_23_key_2d_object_3f_)
#define ___GLO_c_23_optional_2d_object_3f_ ___GLO(100,___G_c_23_optional_2d_object_3f_)
#define ___PRM_c_23_optional_2d_object_3f_ ___PRM(100,___G_c_23_optional_2d_object_3f_)
#define ___GLO_c_23_rest_2d_object_3f_ ___GLO(101,___G_c_23_rest_2d_object_3f_)
#define ___PRM_c_23_rest_2d_object_3f_ ___PRM(101,___G_c_23_rest_2d_object_3f_)
#define ___GLO_c_23_s16vect_3f_ ___GLO(102,___G_c_23_s16vect_3f_)
#define ___PRM_c_23_s16vect_3f_ ___PRM(102,___G_c_23_s16vect_3f_)
#define ___GLO_c_23_s32vect_3f_ ___GLO(103,___G_c_23_s32vect_3f_)
#define ___PRM_c_23_s32vect_3f_ ___PRM(103,___G_c_23_s32vect_3f_)
#define ___GLO_c_23_s64vect_3f_ ___GLO(104,___G_c_23_s64vect_3f_)
#define ___PRM_c_23_s64vect_3f_ ___PRM(104,___G_c_23_s64vect_3f_)
#define ___GLO_c_23_s8vect_3f_ ___GLO(105,___G_c_23_s8vect_3f_)
#define ___PRM_c_23_s8vect_3f_ ___PRM(105,___G_c_23_s8vect_3f_)
#define ___GLO_c_23_structure_2d_object_3f_ ___GLO(106,___G_c_23_structure_2d_object_3f_)
#define ___PRM_c_23_structure_2d_object_3f_ ___PRM(106,___G_c_23_structure_2d_object_3f_)
#define ___GLO_c_23_u16vect_3f_ ___GLO(107,___G_c_23_u16vect_3f_)
#define ___PRM_c_23_u16vect_3f_ ___PRM(107,___G_c_23_u16vect_3f_)
#define ___GLO_c_23_u32vect_3f_ ___GLO(108,___G_c_23_u32vect_3f_)
#define ___PRM_c_23_u32vect_3f_ ___PRM(108,___G_c_23_u32vect_3f_)
#define ___GLO_c_23_u64vect_3f_ ___GLO(109,___G_c_23_u64vect_3f_)
#define ___PRM_c_23_u64vect_3f_ ___PRM(109,___G_c_23_u64vect_3f_)
#define ___GLO_c_23_u8vect_3f_ ___GLO(110,___G_c_23_u8vect_3f_)
#define ___PRM_c_23_u8vect_3f_ ___PRM(110,___G_c_23_u8vect_3f_)
#define ___GLO_c_23_unbound1_2d_object_3f_ ___GLO(111,___G_c_23_unbound1_2d_object_3f_)
#define ___PRM_c_23_unbound1_2d_object_3f_ ___PRM(111,___G_c_23_unbound1_2d_object_3f_)
#define ___GLO_c_23_unbound2_2d_object_3f_ ___GLO(112,___G_c_23_unbound2_2d_object_3f_)
#define ___PRM_c_23_unbound2_2d_object_3f_ ___PRM(112,___G_c_23_unbound2_2d_object_3f_)
#define ___GLO_c_23_unused_2d_object_3f_ ___GLO(113,___G_c_23_unused_2d_object_3f_)
#define ___PRM_c_23_unused_2d_object_3f_ ___PRM(113,___G_c_23_unused_2d_object_3f_)
#define ___GLO_c_23_void_2d_object_3f_ ___GLO(114,___G_c_23_void_2d_object_3f_)
#define ___PRM_c_23_void_2d_object_3f_ ___PRM(114,___G_c_23_void_2d_object_3f_)
#define ___GLO_foreign_3f_ ___GLO(115,___G_foreign_3f_)
#define ___PRM_foreign_3f_ ___PRM(115,___G_foreign_3f_)

___BEGIN_CNS
 ___DEF_CNS(___REF_CNS(1),___REF_CNS(2))
,___DEF_CNS(___REF_SYM(35,___S_fixnum),___REF_FIX(0))
,___DEF_CNS(___REF_CNS(3),___REF_CNS(4))
,___DEF_CNS(___REF_SYM(60,___S_special),___REF_FIX(2))
,___DEF_CNS(___REF_CNS(5),___REF_CNS(6))
,___DEF_CNS(___REF_SYM(43,___S_mem1),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(7),___REF_CNS(8))
,___DEF_CNS(___REF_SYM(44,___S_mem2),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(9),___REF_CNS(10))
,___DEF_CNS(___REF_SYM(64,___S_subtyped),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(11),___REF_NUL)
,___DEF_CNS(___REF_SYM(49,___S_pair),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(13),___REF_CNS(14))
,___DEF_CNS(___REF_SYM(46,___S_movable0),___REF_FIX(0))
,___DEF_CNS(___REF_CNS(15),___REF_CNS(16))
,___DEF_CNS(___REF_SYM(47,___S_movable1),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(17),___REF_CNS(18))
,___DEF_CNS(___REF_SYM(48,___S_movable2),___REF_FIX(2))
,___DEF_CNS(___REF_CNS(19),___REF_CNS(20))
,___DEF_CNS(___REF_SYM(38,___S_forw),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(21),___REF_CNS(22))
,___DEF_CNS(___REF_SYM(61,___S_still),___REF_FIX(5))
,___DEF_CNS(___REF_CNS(23),___REF_NUL)
,___DEF_CNS(___REF_SYM(50,___S_perm),___REF_FIX(6))
,___DEF_CNS(___REF_CNS(25),___REF_CNS(26))
,___DEF_CNS(___REF_SYM(70,___S_vector),___REF_FIX(0))
,___DEF_CNS(___REF_CNS(27),___REF_CNS(28))
,___DEF_CNS(___REF_SYM(49,___S_pair),___REF_FIX(1))
,___DEF_CNS(___REF_CNS(29),___REF_CNS(30))
,___DEF_CNS(___REF_SYM(53,___S_ratnum),___REF_FIX(2))
,___DEF_CNS(___REF_CNS(31),___REF_CNS(32))
,___DEF_CNS(___REF_SYM(32,___S_cpxnum),___REF_FIX(3))
,___DEF_CNS(___REF_CNS(33),___REF_CNS(34))
,___DEF_CNS(___REF_SYM(63,___S_structure),___REF_FIX(4))
,___DEF_CNS(___REF_CNS(35),___REF_CNS(36))
,___DEF_CNS(___REF_SYM(3,___S_boxvalues),___REF_FIX(5))
,___DEF_CNS(___REF_CNS(37),___REF_CNS(38))
,___DEF_CNS(___REF_SYM(45,___S_meroon),___REF_FIX(6))
,___DEF_CNS(___REF_CNS(39),___REF_CNS(40))
,___DEF_CNS(___REF_SYM(41,___S_jazz),___REF_FIX(7))
,___DEF_CNS(___REF_CNS(41),___REF_CNS(42))
,___DEF_CNS(___REF_SYM(65,___S_symbol),___REF_FIX(8))
,___DEF_CNS(___REF_CNS(43),___REF_CNS(44))
,___DEF_CNS(___REF_SYM(42,___S_keyword),___REF_FIX(9))
,___DEF_CNS(___REF_CNS(45),___REF_CNS(46))
,___DEF_CNS(___REF_SYM(39,___S_frame),___REF_FIX(10))
,___DEF_CNS(___REF_CNS(47),___REF_CNS(48))
,___DEF_CNS(___REF_SYM(31,___S_continuation),___REF_FIX(11))
,___DEF_CNS(___REF_CNS(49),___REF_CNS(50))
,___DEF_CNS(___REF_SYM(52,___S_promise),___REF_FIX(12))
,___DEF_CNS(___REF_CNS(51),___REF_CNS(52))
,___DEF_CNS(___REF_SYM(71,___S_weak),___REF_FIX(13))
,___DEF_CNS(___REF_CNS(53),___REF_CNS(54))
,___DEF_CNS(___REF_SYM(51,___S_procedure),___REF_FIX(14))
,___DEF_CNS(___REF_CNS(55),___REF_CNS(56))
,___DEF_CNS(___REF_SYM(55,___S_return),___REF_FIX(15))
,___DEF_CNS(___REF_CNS(57),___REF_CNS(58))
,___DEF_CNS(___REF_SYM(37,___S_foreign),___REF_FIX(18))
,___DEF_CNS(___REF_CNS(59),___REF_CNS(60))
,___DEF_CNS(___REF_SYM(62,___S_string),___REF_FIX(19))
,___DEF_CNS(___REF_CNS(61),___REF_CNS(62))
,___DEF_CNS(___REF_SYM(59,___S_s8vector),___REF_FIX(20))
,___DEF_CNS(___REF_CNS(63),___REF_CNS(64))
,___DEF_CNS(___REF_SYM(69,___S_u8vector),___REF_FIX(21))
,___DEF_CNS(___REF_CNS(65),___REF_CNS(66))
,___DEF_CNS(___REF_SYM(56,___S_s16vector),___REF_FIX(22))
,___DEF_CNS(___REF_CNS(67),___REF_CNS(68))
,___DEF_CNS(___REF_SYM(66,___S_u16vector),___REF_FIX(23))
,___DEF_CNS(___REF_CNS(69),___REF_CNS(70))
,___DEF_CNS(___REF_SYM(57,___S_s32vector),___REF_FIX(24))
,___DEF_CNS(___REF_CNS(71),___REF_CNS(72))
,___DEF_CNS(___REF_SYM(67,___S_u32vector),___REF_FIX(25))
,___DEF_CNS(___REF_CNS(73),___REF_CNS(74))
,___DEF_CNS(___REF_SYM(33,___S_f32vector),___REF_FIX(26))
,___DEF_CNS(___REF_CNS(75),___REF_CNS(76))
,___DEF_CNS(___REF_SYM(58,___S_s64vector),___REF_FIX(27))
,___DEF_CNS(___REF_CNS(77),___REF_CNS(78))
,___DEF_CNS(___REF_SYM(68,___S_u64vector),___REF_FIX(28))
,___DEF_CNS(___REF_CNS(79),___REF_CNS(80))
,___DEF_CNS(___REF_SYM(34,___S_f64vector),___REF_FIX(29))
,___DEF_CNS(___REF_CNS(81),___REF_CNS(82))
,___DEF_CNS(___REF_SYM(36,___S_flonum),___REF_FIX(30))
,___DEF_CNS(___REF_CNS(83),___REF_NUL)
,___DEF_CNS(___REF_SYM(2,___S_bignum),___REF_FIX(31))
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
#define ___MD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4 ___D_F64(___F64V1)
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
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_body_2d_offset)
___DEF_M_HLBL(___L1_c_23_body_2d_offset)
___DEF_M_HLBL(___L2_c_23_body_2d_offset)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_header_2d_offset)
___DEF_M_HLBL(___L1_c_23_header_2d_offset)
___DEF_M_HLBL(___L2_c_23_header_2d_offset)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_type)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_encoder)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL(___L1_c_23_desc_2d_type_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_desc_2d_encoder_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_desc)
___DEF_M_HLBL(___L1_c_23_imm_2d_desc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_type_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L1_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L2_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL(___L3_c_23_imm_2d_desc_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_desc)
___DEF_M_HLBL(___L1_c_23_ref_2d_desc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_subtype)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_size)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_subtype_2d_tag)
___DEF_M_HLBL(___L1_c_23_ref_2d_subtype_2d_tag)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_type_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_subtype_3f_)
___DEF_M_HLBL(___L1_c_23_ref_2d_subtype_3f_)
___DEF_M_HLBL(___L2_c_23_ref_2d_subtype_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_size_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L1_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L2_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L3_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L4_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL(___L5_c_23_ref_2d_desc_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_tagged_2d_value)
___DEF_M_HLBL(___L1_c_23_tagged_2d_value)
___DEF_M_HLBL(___L2_c_23_tagged_2d_value)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_special_2d_desc)
___DEF_M_HLBL(___L1_c_23_special_2d_desc)
___DEF_M_HLBL(___L2_c_23_special_2d_desc)
___DEF_M_HLBL(___L3_c_23_special_2d_desc)
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
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_ref_2d_encode)
___DEF_M_HLBL(___L1_c_23_ref_2d_encode)
___DEF_M_HLBL(___L2_c_23_ref_2d_encode)
___DEF_M_HLBL(___L3_c_23_ref_2d_encode)
___DEF_M_HLBL(___L4_c_23_ref_2d_encode)
___DEF_M_HLBL(___L5_c_23_ref_2d_encode)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___t_2d_cpu_2d_object_2d_desc_23_
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(80,___G_c_23_type_2d_tags,___CNS(0))
   ___SET_GLO(78,___G_c_23_type_2d_tag_2d_bits,___FIX(2L))
   ___SET_GLO(79,___G_c_23_type_2d_tag_2d_mask,___FIX(3L))
   ___SET_GLO(24,___G_c_23_head_2d_type_2d_tags,___CNS(12))
   ___SET_GLO(22,___G_c_23_head_2d_type_2d_tag_2d_bits,___FIX(3L))
   ___SET_GLO(23,___G_c_23_head_2d_type_2d_tag_2d_mask,___FIX(7L))
   ___SET_GLO(73,___G_c_23_subtype_2d_tags,___CNS(24))
   ___SET_GLO(71,___G_c_23_subtype_2d_tag_2d_bits,___FIX(5L))
   ___SET_GLO(72,___G_c_23_subtype_2d_tag_2d_mask,___FIX(248L))
   ___SET_GLO(38,___G_c_23_length_2d_mask,___FIX(-256L))
   ___SET_GLO(32,___G_c_23_imm_2d_type,___PRC(74))
   ___SET_GLO(29,___G_c_23_imm_2d_encoder,___PRC(76))
   ___SET_GLO(33,___G_c_23_imm_2d_type_2d_tag,___PRC(78))
   ___SET_GLO(30,___G_c_23_imm_2d_encoder_3f_,___PRC(81))
   ___SET_GLO(58,___G_c_23_ref_2d_type,___PRC(74))
   ___SET_GLO(50,___G_c_23_ref_2d_encoder,___PRC(76))
   ___SET_GLO(59,___G_c_23_ref_2d_type_2d_tag,___PRC(78))
   ___SET_GLO(51,___G_c_23_ref_2d_encoder_3f_,___PRC(81))
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___SYM_imm)
   ___ADD_VECTOR_ELEM(1,___SYM_fixnum)
   ___ADD_VECTOR_ELEM(2,___LBL(47))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___SET_GLO(17,___G_c_23_fixnum_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___SYM_imm)
   ___ADD_VECTOR_ELEM(1,___SYM_special)
   ___ADD_VECTOR_ELEM(2,___LBL(45))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___SET_GLO(5,___G_c_23_char_2d_desc,___R1)
   ___SET_STK(1,___R0)
   ___SET_R1(___FIX(-1L))
   ___ADJFP(4)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1___t_2d_cpu_2d_object_2d_desc_23_)
   ___POLL(2)
___DEF_SLBL(2,___L2___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(3,___L3___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(16,___G_c_23_fal_2d_desc,___R1)
   ___SET_R1(___FIX(-2L))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(4,___L4___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(76,___G_c_23_tru_2d_desc,___R1)
   ___SET_R1(___FIX(-3L))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(5,___L5___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(40,___G_c_23_nul_2d_desc,___R1)
   ___SET_R1(___FIX(-4L))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(6,___L6___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(13,___G_c_23_eof_2d_desc,___R1)
   ___SET_R1(___FIX(-5L))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(7,___L7___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(89,___G_c_23_void_2d_desc,___R1)
   ___SET_R1(___FIX(-6L))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(8,___L8___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(1,___G_c_23_absent_2d_desc,___R1)
   ___SET_R1(___FIX(-7L))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(9,___L9___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(85,___G_c_23_unb1_2d_desc,___R1)
   ___SET_R1(___FIX(-8L))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(10,___L10___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(86,___G_c_23_unb2_2d_desc,___R1)
   ___SET_R1(___FIX(-9L))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(11,___L11___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(42,___G_c_23_optional_2d_desc,___R1)
   ___SET_R1(___FIX(-10L))
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(12,___L12___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(36,___G_c_23_keyobj_2d_desc,___R1)
   ___SET_R1(___FIX(-11L))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(13,___L13___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(61,___G_c_23_rest_2d_desc,___R1)
   ___SET_R1(___FIX(-14L))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(14,___L14___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(87,___G_c_23_unused_2d_desc,___R1)
   ___SET_R1(___FIX(-15L))
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(1),___PRC(122),___L_c_23_special_2d_desc)
___DEF_SLBL(15,___L15___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(8,___G_c_23_deleted_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_pair)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_pair)
   ___ADD_VECTOR_ELEM(4,___FIX(2L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(43,___G_c_23_pair_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(22))
   ___CHECK_HEAP(16,4096)
___DEF_SLBL(16,___L16___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(17,___L17___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(18,___G_c_23_flonum_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_bignum)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(20))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(18,___L18___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FAL))
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(18,3,1,0)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___STK(0))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___R2)
   ___ADD_VECTOR_ELEM(4,___R3)
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___ADJFP(-1)
   ___CHECK_HEAP(19,4096)
___DEF_SLBL(19,___L19___t_2d_cpu_2d_object_2d_desc_23_)
   ___JUMPRET(___R0)
___DEF_SLBL(20,___L20___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(2,___G_c_23_bignum_2d_desc,___R1)
   ___SET_R1(___VOID)
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___DEF_SLBL(21,___L21___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(21,1,0,0)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_SLBL(22,___L22___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(88,___G_c_23_vector_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_ratnum)
   ___ADD_VECTOR_ELEM(4,___FIX(2L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(46,___G_c_23_ratnum_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_cpxnum)
   ___ADD_VECTOR_ELEM(4,___FIX(2L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(7,___G_c_23_cpxnum_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_structure)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(24))
   ___CHECK_HEAP(23,4096)
___DEF_SLBL(23,___L23___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(24,___L24___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(69,___G_c_23_structure_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_boxvalues)
   ___ADD_VECTOR_ELEM(4,___FIX(1L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(4,___G_c_23_boxvalues_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_meroon)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(26))
   ___CHECK_HEAP(25,4096)
___DEF_SLBL(25,___L25___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(26,___L26___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(39,___G_c_23_meroon_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_jazz)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(27))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(27,___L27___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(35,___G_c_23_jazz_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_symbol)
   ___ADD_VECTOR_ELEM(4,___FIX(4L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(74,___G_c_23_symbol_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_keyword)
   ___ADD_VECTOR_ELEM(4,___FIX(3L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(37,___G_c_23_keyword_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_frame)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(29))
   ___CHECK_HEAP(28,4096)
___DEF_SLBL(28,___L28___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(29,___L29___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(20,___G_c_23_frame_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_continuation)
   ___ADD_VECTOR_ELEM(4,___FIX(2L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(6,___G_c_23_continuation_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_promise)
   ___ADD_VECTOR_ELEM(4,___FIX(1L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(45,___G_c_23_promise_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_weak)
   ___ADD_VECTOR_ELEM(4,___FIX(3L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(90,___G_c_23_weak_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_procedure)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(31))
   ___CHECK_HEAP(30,4096)
___DEF_SLBL(30,___L30___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(31,___L31___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(44,___G_c_23_procedure_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_return)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(32))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(32,___L32___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(62,___G_c_23_return_2d_desc,___R1)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___SYM_subtyped)
   ___ADD_VECTOR_ELEM(2,___LBL(21))
   ___ADD_VECTOR_ELEM(3,___SYM_foreign)
   ___ADD_VECTOR_ELEM(4,___FIX(3L))
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___SET_GLO(19,___G_c_23_foreign_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_string)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(34))
   ___CHECK_HEAP(33,4096)
___DEF_SLBL(33,___L33___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(34,___L34___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(68,___G_c_23_string_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_s8vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(35))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(35,___L35___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(66,___G_c_23_s8vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_u8vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(36))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(36,___L36___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(84,___G_c_23_u8vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_s16vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(37))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(37,___L37___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(63,___G_c_23_s16vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_u16vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(38))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(38,___L38___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(81,___G_c_23_u16vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_s32vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(39))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(39,___L39___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(64,___G_c_23_s32vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_u32vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(40))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(40,___L40___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(82,___G_c_23_u32vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_f32vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(41))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(41,___L41___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(14,___G_c_23_f32vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_s64vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(42))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(42,___L42___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(65,___G_c_23_s64vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_u64vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(43))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(43,___L43___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(83,___G_c_23_u64vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_f64vector)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(44))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(44,___L44___t_2d_cpu_2d_object_2d_desc_23_)
   ___SET_GLO(15,___G_c_23_f64vector_2d_desc,___R1)
   ___SET_R2(___LBL(21))
   ___SET_R3(___SYM_flonum)
   ___SET_R1(___SYM_subtyped)
   ___SET_R0(___LBL(17))
   ___SET_NARGS(3) ___GOTO(___L18___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(45,___L45___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(45,1,0,0)
   ___SET_R1(___FIXFROMCHR(___R1))
   ___SET_R2(___SYM_special)
   ___POLL(46)
___DEF_SLBL(46,___L46___t_2d_cpu_2d_object_2d_desc_23_)
   ___GOTO(___L49___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_SLBL(47,___L47___t_2d_cpu_2d_object_2d_desc_23_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(47,1,0,0)
   ___SET_R2(___SYM_fixnum)
   ___POLL(48)
___DEF_SLBL(48,___L48___t_2d_cpu_2d_object_2d_desc_23_)
___DEF_GLBL(___L49___t_2d_cpu_2d_object_2d_desc_23_)
   ___JUMPINT(___SET_NARGS(2),___PRC(118),___L_c_23_tagged_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_type_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 51
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
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
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_type_2d_tag)
   ___GOTO(___L5_c_23_type_2d_tag)
___DEF_GLBL(___L4_c_23_type_2d_tag)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L6_c_23_type_2d_tag)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_type_2d_tag)
___DEF_GLBL(___L5_c_23_type_2d_tag)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L4_c_23_type_2d_tag)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L6_c_23_type_2d_tag)
   ___SET_R1(___R3)
   ___JUMPRET(___R0)
___DEF_SLBL(3,___L3_c_23_type_2d_tag)
   ___SET_R1(___CDR(___R1))
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_head_2d_type_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 56
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
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
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_head_2d_type_2d_tag)
   ___GOTO(___L5_c_23_head_2d_type_2d_tag)
___DEF_GLBL(___L4_c_23_head_2d_type_2d_tag)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L6_c_23_head_2d_type_2d_tag)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_head_2d_type_2d_tag)
___DEF_GLBL(___L5_c_23_head_2d_type_2d_tag)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L4_c_23_head_2d_type_2d_tag)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L6_c_23_head_2d_type_2d_tag)
   ___SET_R1(___R3)
   ___JUMPRET(___R0)
___DEF_SLBL(3,___L3_c_23_head_2d_type_2d_tag)
   ___SET_R1(___CDR(___R1))
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_subtype_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 61
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L1_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L2_c_23_subtype_2d_tag)
___DEF_P_HLBL(___L3_c_23_subtype_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_subtype_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_subtype_2d_tag)
   ___SET_STK(1,___R0)
   ___SET_R2(___CNS(24))
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_subtype_2d_tag)
   ___GOTO(___L5_c_23_subtype_2d_tag)
___DEF_GLBL(___L4_c_23_subtype_2d_tag)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L6_c_23_subtype_2d_tag)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_subtype_2d_tag)
___DEF_GLBL(___L5_c_23_subtype_2d_tag)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L4_c_23_subtype_2d_tag)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L6_c_23_subtype_2d_tag)
   ___SET_R1(___R3)
   ___JUMPRET(___R0)
___DEF_SLBL(3,___L3_c_23_subtype_2d_tag)
   ___SET_R1(___CDR(___R1))
   ___SET_R1(___FIXASH(___R1,___FIX(3L)))
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_body_2d_offset
#undef ___PH_LBL0
#define ___PH_LBL0 66
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_body_2d_offset)
___DEF_P_HLBL(___L1_c_23_body_2d_offset)
___DEF_P_HLBL(___L2_c_23_body_2d_offset)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_body_2d_offset)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_body_2d_offset)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_body_2d_offset)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23_type_2d_tag)
___DEF_SLBL(2,___L2_c_23_body_2d_offset)
   ___SET_R1(___FIXSUB(___FIXSUB(___FIX(0L),___R1),___STK(-6)))
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_header_2d_offset
#undef ___PH_LBL0
#define ___PH_LBL0 70
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_header_2d_offset)
___DEF_P_HLBL(___L1_c_23_header_2d_offset)
___DEF_P_HLBL(___L2_c_23_header_2d_offset)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_header_2d_offset)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_header_2d_offset)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_header_2d_offset)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23_type_2d_tag)
___DEF_SLBL(2,___L2_c_23_header_2d_offset)
   ___SET_R1(___FIXSUB(___FIXSUB(___FIXSUB(___FIX(0L),___R1),___STK(-6)),___STK(-6)))
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_type
#undef ___PH_LBL0
#define ___PH_LBL0 74
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_type)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_type)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_type)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_encoder
#undef ___PH_LBL0
#define ___PH_LBL0 76
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_encoder)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_encoder)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_encoder)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_type_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 78
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_type_2d_tag)
___DEF_P_HLBL(___L1_c_23_desc_2d_type_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_type_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_type_2d_tag)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_desc_2d_type_2d_tag)
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23_type_2d_tag)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_desc_2d_encoder_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 81
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_desc_2d_encoder_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_desc_2d_encoder_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_desc_2d_encoder_3f_)
   ___SET_R1(___BOOLEAN(___PROCEDUREP(___R1)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_desc
#undef ___PH_LBL0
#define ___PH_LBL0 83
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
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
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___SYM_imm)
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___R2)
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_imm_2d_desc)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_type_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 86
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_type_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_type_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_imm_2d_type_3f_)
   ___IF(___NOT(___EQP(___R1,___SYM_fixnum)))
   ___GOTO(___L1_c_23_imm_2d_type_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_imm_2d_type_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___SYM_special)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_desc_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 88
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L1_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L2_c_23_imm_2d_desc_3f_)
___DEF_P_HLBL(___L3_c_23_imm_2d_desc_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_imm_2d_desc_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_imm_2d_desc_3f_)
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___IF(___NOT(___EQP(___SYM_imm,___R2)))
   ___GOTO(___L5_c_23_imm_2d_desc_3f_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_imm_2d_desc_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23_imm_2d_type_3f_)
___DEF_SLBL(2,___L2_c_23_imm_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4_c_23_imm_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(76),___L_c_23_desc_2d_encoder)
___DEF_SLBL(3,___L3_c_23_imm_2d_desc_3f_)
   ___SET_R1(___BOOLEAN(___PROCEDUREP(___R1)))
   ___ADJFP(-4)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L4_c_23_imm_2d_desc_3f_)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L5_c_23_imm_2d_desc_3f_)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_desc
#undef ___PH_LBL0
#define ___PH_LBL0 93
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_desc)
___DEF_P_HLBL(___L1_c_23_ref_2d_desc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_desc)
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FAL))
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,3,1,0)
___DEF_GLBL(___L_c_23_ref_2d_desc)
   ___BEGIN_ALLOC_VECTOR(5UL)
   ___ADD_VECTOR_ELEM(0,___SYM_ref)
   ___ADD_VECTOR_ELEM(1,___STK(0))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___R2)
   ___ADD_VECTOR_ELEM(4,___R3)
   ___END_ALLOC_VECTOR(5)
   ___SET_R1(___GET_VECTOR(5))
   ___ADJFP(-1)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_ref_2d_desc)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_subtype
#undef ___PH_LBL0
#define ___PH_LBL0 96
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_subtype)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_subtype)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_subtype)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_size
#undef ___PH_LBL0
#define ___PH_LBL0 98
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_size)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_size)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_size)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_subtype_2d_tag
#undef ___PH_LBL0
#define ___PH_LBL0 100
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_subtype_2d_tag)
___DEF_P_HLBL(___L1_c_23_ref_2d_subtype_2d_tag)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_subtype_2d_tag)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_subtype_2d_tag)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_subtype_2d_tag)
   ___JUMPINT(___SET_NARGS(1),___PRC(61),___L_c_23_subtype_2d_tag)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_type_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 103
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_type_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_type_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_type_3f_)
   ___IF(___NOT(___EQP(___R1,___SYM_subtyped)))
   ___GOTO(___L1_c_23_ref_2d_type_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_ref_2d_type_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___SYM_pair)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_subtype_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 105
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_subtype_3f_)
___DEF_P_HLBL(___L1_c_23_ref_2d_subtype_3f_)
___DEF_P_HLBL(___L2_c_23_ref_2d_subtype_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_subtype_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_subtype_3f_)
   ___SET_R2(___CNS(24))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_subtype_3f_)
   ___GOTO(___L4_c_23_ref_2d_subtype_3f_)
___DEF_GLBL(___L3_c_23_ref_2d_subtype_3f_)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L5_c_23_ref_2d_subtype_3f_)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_ref_2d_subtype_3f_)
___DEF_GLBL(___L4_c_23_ref_2d_subtype_3f_)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3_c_23_ref_2d_subtype_3f_)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___DEF_GLBL(___L5_c_23_ref_2d_subtype_3f_)
   ___SET_R1(___R3)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_size_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 109
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_size_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_size_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_size_3f_)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L1_c_23_ref_2d_size_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___JUMPRET(___R0)
___DEF_GLBL(___L1_c_23_ref_2d_size_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___FAL)))
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_desc_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 111
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L1_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L2_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L3_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L4_c_23_ref_2d_desc_3f_)
___DEF_P_HLBL(___L5_c_23_ref_2d_desc_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_ref_2d_desc_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_ref_2d_desc_3f_)
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___IF(___NOT(___EQP(___SYM_ref,___R2)))
   ___GOTO(___L7_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_ref_2d_desc_3f_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(103),___L_c_23_ref_2d_type_3f_)
___DEF_SLBL(2,___L2_c_23_ref_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(76),___L_c_23_desc_2d_encoder)
___DEF_SLBL(3,___L3_c_23_ref_2d_desc_3f_)
   ___SET_R1(___BOOLEAN(___PROCEDUREP(___R1)))
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(3L)))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(105),___L_c_23_ref_2d_subtype_3f_)
___DEF_SLBL(4,___L4_c_23_ref_2d_desc_3f_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6_c_23_ref_2d_desc_3f_)
   ___END_IF
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(4L)))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_ref_2d_desc_3f_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(109),___L_c_23_ref_2d_size_3f_)
___DEF_GLBL(___L6_c_23_ref_2d_desc_3f_)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L7_c_23_ref_2d_desc_3f_)
   ___SET_R1(___FAL)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_tagged_2d_value
#undef ___PH_LBL0
#define ___PH_LBL0 118
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_tagged_2d_value)
___DEF_P_HLBL(___L1_c_23_tagged_2d_value)
___DEF_P_HLBL(___L2_c_23_tagged_2d_value)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_tagged_2d_value)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_tagged_2d_value)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_tagged_2d_value)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23_type_2d_tag)
___DEF_SLBL(2,___L2_c_23_tagged_2d_value)
   ___SET_R2(___FIXASH(___STK(-6),___FIX(2L)))
   ___SET_R1(___FIXADD(___R2,___R1))
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_special_2d_desc
#undef ___PH_LBL0
#define ___PH_LBL0 122
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_special_2d_desc)
___DEF_P_HLBL(___L1_c_23_special_2d_desc)
___DEF_P_HLBL(___L2_c_23_special_2d_desc)
___DEF_P_HLBL(___L3_c_23_special_2d_desc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_special_2d_desc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_special_2d_desc)
   ___SET_STK(1,___ALLOC_CLO(1UL))
   ___BEGIN_SETUP_CLO(1,___STK(1),2)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_ALLOC_VECTOR(3UL)
   ___ADD_VECTOR_ELEM(0,___SYM_imm)
   ___ADD_VECTOR_ELEM(1,___SYM_special)
   ___ADD_VECTOR_ELEM(2,___STK(1))
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_special_2d_desc)
   ___JUMPRET(___R0)
___DEF_SLBL(2,___L2_c_23_special_2d_desc)
   ___IF_NARGS_EQ(0,___SET_R1(___FAL))
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(2,0,1,0)
   ___SET_R1(___CLO(___R4,1))
   ___SET_R2(___SYM_special)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_special_2d_desc)
   ___JUMPINT(___SET_NARGS(2),___PRC(118),___L_c_23_tagged_2d_value)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_object_2d__3e_desc
#undef ___PH_LBL0
#define ___PH_LBL0 127
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4 ___D_F64(___F64V1)
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_object_2d__3e_desc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_object_2d__3e_desc)
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L72_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___CHARP(___R1))
   ___GOTO(___L71_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___EQP(___R1,___FAL))
   ___GOTO(___L70_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___EQP(___R1,___TRU))
   ___GOTO(___L69_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___NULLP(___R1))
   ___GOTO(___L68_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_object_2d__3e_desc)
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),96,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
___DEF_SLBL(2,___L2_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L67_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),114,___G_c_23_void_2d_object_3f_)
___DEF_SLBL(3,___L3_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L66_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),93,___G_c_23_absent_2d_object_3f_)
___DEF_SLBL(4,___L4_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L65_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),111,___G_c_23_unbound1_2d_object_3f_)
___DEF_SLBL(5,___L5_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L64_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),112,___G_c_23_unbound2_2d_object_3f_)
___DEF_SLBL(6,___L6_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L63_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),100,___G_c_23_optional_2d_object_3f_)
___DEF_SLBL(7,___L7_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L62_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),99,___G_c_23_key_2d_object_3f_)
___DEF_SLBL(8,___L8_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L61_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),101,___G_c_23_rest_2d_object_3f_)
___DEF_SLBL(9,___L9_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L60_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),113,___G_c_23_unused_2d_object_3f_)
___DEF_SLBL(10,___L10_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L59_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),95,___G_c_23_deleted_2d_object_3f_)
___DEF_SLBL(11,___L11_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L58_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___PAIRP(___STK(-6)))
   ___GOTO(___L57_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___VECTORP(___STK(-6)))
   ___GOTO(___L56_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___FIXNUMP(___STK(-6)))
   ___GOTO(___L54_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___NOT(___FLONUMP(___STK(-6))))
   ___GOTO(___L55_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_F64(___F64V1,___F64UNBOX(___STK(-6)))
   ___IF(___F64FINITEP(___F64V1))
   ___GOTO(___L54_c_23_object_2d__3e_desc)
   ___END_IF
   ___GOTO(___L27_c_23_object_2d__3e_desc)
___DEF_SLBL(12,___L12_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L54_c_23_object_2d__3e_desc)
   ___END_IF
___DEF_GLBL(___L27_c_23_object_2d__3e_desc)
   ___IF(___COMPLEXP(___STK(-6)))
   ___GOTO(___L53_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),106,___G_c_23_structure_2d_object_3f_)
___DEF_SLBL(13,___L13_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L52_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___BOXP(___STK(-6)))
   ___GOTO(___L51_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___MEROONP(___STK(-6)))
   ___GOTO(___L50_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___JAZZP(___STK(-6)))
   ___GOTO(___L49_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___SYMBOLP(___STK(-6)))
   ___GOTO(___L48_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___KEYWORDP(___STK(-6)))
   ___GOTO(___L47_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___FRAMEP(___STK(-6)))
   ___GOTO(___L46_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___CONTINUATIONP(___STK(-6)))
   ___GOTO(___L45_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___PROMISEP(___STK(-6)))
   ___GOTO(___L44_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___PROCEDUREP(___STK(-6)))
   ___GOTO(___L43_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___RETURNP(___STK(-6)))
   ___GOTO(___L42_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),115,___G_foreign_3f_)
___DEF_SLBL(14,___L14_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L41_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___STRINGP(___STK(-6)))
   ___GOTO(___L40_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),105,___G_c_23_s8vect_3f_)
___DEF_SLBL(15,___L15_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L39_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),110,___G_c_23_u8vect_3f_)
___DEF_SLBL(16,___L16_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L38_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(17))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),102,___G_c_23_s16vect_3f_)
___DEF_SLBL(17,___L17_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L37_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),107,___G_c_23_u16vect_3f_)
___DEF_SLBL(18,___L18_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L36_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),103,___G_c_23_s32vect_3f_)
___DEF_SLBL(19,___L19_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L35_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),108,___G_c_23_u32vect_3f_)
___DEF_SLBL(20,___L20_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L34_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),97,___G_c_23_f32vect_3f_)
___DEF_SLBL(21,___L21_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L33_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(22))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),104,___G_c_23_s64vect_3f_)
___DEF_SLBL(22,___L22_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L32_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),109,___G_c_23_u64vect_3f_)
___DEF_SLBL(23,___L23_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L31_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(24))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),98,___G_c_23_f64vect_3f_)
___DEF_SLBL(24,___L24_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L30_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___FLONUMP(___STK(-6)))
   ___GOTO(___L29_c_23_object_2d__3e_desc)
   ___END_IF
   ___IF(___FIXNUMP(___STK(-6)))
   ___GOTO(___L28_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_integer_3f_)
___DEF_SLBL(25,___L25_c_23_object_2d__3e_desc)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L28_c_23_object_2d__3e_desc)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(0))
   ___SET_R0(___STK(-7))
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_object_2d__3e_desc)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),94,___G_c_23_compiler_2d_internal_2d_error)
___DEF_GLBL(___L28_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_bignum_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L29_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_flonum_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L30_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_f64vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L31_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u64vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L32_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s64vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L33_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_f32vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L34_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u32vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L35_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s32vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L36_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u16vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L37_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s16vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L38_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_u8vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L39_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_s8vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L40_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_string_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L41_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_foreign_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L42_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_return_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L43_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_procedure_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L44_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_promise_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L45_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_continuation_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L46_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_frame_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L47_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_keyword_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L48_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_symbol_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L49_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_jazz_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L50_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_meroon_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L51_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_boxvalues_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L52_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_structure_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L53_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_cpxnum_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L54_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_ratnum_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L55_c_23_object_2d__3e_desc)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_rational_3f_)
___DEF_GLBL(___L56_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_vector_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L57_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_pair_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L58_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_deleted_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L59_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_unused_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L60_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_rest_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L61_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_keyobj_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L62_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_optional_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L63_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_unb2_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L64_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_unb1_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L65_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_absent_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L66_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_void_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L67_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_eof_2d_desc)
   ___ADJFP(-8)
   ___JUMPRET(___STK(1))
___DEF_GLBL(___L68_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_nul_2d_desc)
   ___JUMPRET(___R0)
___DEF_GLBL(___L69_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_tru_2d_desc)
   ___JUMPRET(___R0)
___DEF_GLBL(___L70_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_fal_2d_desc)
   ___JUMPRET(___R0)
___DEF_GLBL(___L71_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_char_2d_desc)
   ___JUMPRET(___R0)
___DEF_GLBL(___L72_c_23_object_2d__3e_desc)
   ___SET_R1(___GLO_c_23_fixnum_2d_desc)
   ___JUMPRET(___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 155
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
   ___JUMPINT(___SET_NARGS(1),___PRC(127),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_imm_2d_object_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_imm_2d_object_3f_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(88),___L_c_23_imm_2d_desc_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 160
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
   ___JUMPINT(___SET_NARGS(1),___PRC(127),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_ref_2d_object_3f_)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_ref_2d_object_3f_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(111),___L_c_23_ref_2d_desc_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_imm_2d_encode
#undef ___PH_LBL0
#define ___PH_LBL0 165
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
   ___JUMPINT(___SET_NARGS(1),___PRC(127),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_imm_2d_encode)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(88),___L_c_23_imm_2d_desc_3f_)
___DEF_SLBL(3,___L3_c_23_imm_2d_encode)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6_c_23_imm_2d_encode)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(2L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_imm_2d_encode)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___DEF_GLBL(___L6_c_23_imm_2d_encode)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(1))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_imm_2d_encode)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),94,___G_c_23_compiler_2d_internal_2d_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_ref_2d_encode
#undef ___PH_LBL0
#define ___PH_LBL0 172
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4 ___D_F64(___F64V1)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(127),___L_c_23_object_2d__3e_desc)
___DEF_SLBL(2,___L2_c_23_ref_2d_encode)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(111),___L_c_23_ref_2d_desc_3f_)
___DEF_SLBL(3,___L3_c_23_ref_2d_encode)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6_c_23_ref_2d_encode)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(2L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_ref_2d_encode)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___DEF_GLBL(___L6_c_23_ref_2d_encode)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(2))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_ref_2d_encode)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),94,___G_c_23_compiler_2d_internal_2d_error)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___t_2d_cpu_2d_object_2d_desc_23_,___REF_SYM(1,___S___t_2d_cpu_2d_object_2d_desc_23_),___REF_FAL,49,0)
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,0,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
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
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,4,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,1,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETN,1,0,0x1L))
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
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,1,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H___t_2d_cpu_2d_object_2d_desc_23_,1,-1)
,___DEF_LBL_RET(___H___t_2d_cpu_2d_object_2d_desc_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_type_2d_tag,___REF_SYM(30,___S_c_23_type_2d_tag),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_type_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_type_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_type_2d_tag,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_type_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_head_2d_type_2d_tag,___REF_SYM(9,___S_c_23_head_2d_type_2d_tag),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_head_2d_type_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_head_2d_type_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_head_2d_type_2d_tag,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_head_2d_type_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_subtype_2d_tag,___REF_SYM(28,___S_c_23_subtype_2d_tag),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_subtype_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_subtype_2d_tag,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_body_2d_offset,___REF_SYM(4,___S_c_23_body_2d_offset),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_body_2d_offset,2,-1)
,___DEF_LBL_RET(___H_c_23_body_2d_offset,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_body_2d_offset,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23_header_2d_offset,___REF_SYM(10,___S_c_23_header_2d_offset),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_header_2d_offset,2,-1)
,___DEF_LBL_RET(___H_c_23_header_2d_offset,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_header_2d_offset,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23_desc_2d_type,___REF_SYM(7,___S_c_23_desc_2d_type),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_type,1,-1)
,___DEF_LBL_INTRO(___H_c_23_desc_2d_encoder,___REF_SYM(5,___S_c_23_desc_2d_encoder),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_encoder,1,-1)
,___DEF_LBL_INTRO(___H_c_23_desc_2d_type_2d_tag,___REF_SYM(8,___S_c_23_desc_2d_type_2d_tag),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_type_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_desc_2d_type_2d_tag,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_desc_2d_encoder_3f_,___REF_SYM(6,___S_c_23_desc_2d_encoder_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_desc_2d_encoder_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_imm_2d_desc,___REF_SYM(11,___S_c_23_imm_2d_desc),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_desc,2,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_desc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_type_3f_,___REF_SYM(15,___S_c_23_imm_2d_type_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_type_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_imm_2d_desc_3f_,___REF_SYM(12,___S_c_23_imm_2d_desc_3f_),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_desc_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_desc_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_desc,___REF_SYM(17,___S_c_23_ref_2d_desc),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_desc,4,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_desc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_subtype,___REF_SYM(23,___S_c_23_ref_2d_subtype),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_subtype,1,-1)
,___DEF_LBL_INTRO(___H_c_23_ref_2d_size,___REF_SYM(21,___S_c_23_ref_2d_size),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_size,1,-1)
,___DEF_LBL_INTRO(___H_c_23_ref_2d_subtype_2d_tag,___REF_SYM(24,___S_c_23_ref_2d_subtype_2d_tag),___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_subtype_2d_tag,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_2d_tag,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_type_3f_,___REF_SYM(26,___S_c_23_ref_2d_type_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_type_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_ref_2d_subtype_3f_,___REF_SYM(25,___S_c_23_ref_2d_subtype_3f_),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_subtype_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_ref_2d_subtype_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_size_3f_,___REF_SYM(22,___S_c_23_ref_2d_size_3f_),___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_size_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_ref_2d_desc_3f_,___REF_SYM(18,___S_c_23_ref_2d_desc_3f_),___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_desc_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_desc_3f_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_tagged_2d_value,___REF_SYM(29,___S_c_23_tagged_2d_value),___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_c_23_tagged_2d_value,2,-1)
,___DEF_LBL_RET(___H_c_23_tagged_2d_value,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_tagged_2d_value,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H_c_23_special_2d_desc,___REF_SYM(27,___S_c_23_special_2d_desc),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_special_2d_desc,1,-1)
,___DEF_LBL_RET(___H_c_23_special_2d_desc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_special_2d_desc,1,1)
,___DEF_LBL_RET(___H_c_23_special_2d_desc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_object_2d__3e_desc,___REF_SYM(16,___S_c_23_object_2d__3e_desc),___REF_FAL,27,0)
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
,___DEF_LBL_RET(___H_c_23_object_2d__3e_desc,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_object_3f_,___REF_SYM(14,___S_c_23_imm_2d_object_3f_),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_object_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_object_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_imm_2d_object_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_imm_2d_object_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_object_3f_,___REF_SYM(20,___S_c_23_ref_2d_object_3f_),___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_object_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_object_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_object_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_ref_2d_object_3f_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_imm_2d_encode,___REF_SYM(13,___S_c_23_imm_2d_encode),___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_imm_2d_encode,1,-1)
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_imm_2d_encode,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_ref_2d_encode,___REF_SYM(19,___S_c_23_ref_2d_encode),___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23_ref_2d_encode,1,-1)
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_ref_2d_encode,___IFD(___RETI,8,8,0x3f00L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G___t_2d_cpu_2d_object_2d_desc_23_,1)
___DEF_MOD_PRM(77,___G_c_23_type_2d_tag,51)
___DEF_MOD_PRM(21,___G_c_23_head_2d_type_2d_tag,56)
___DEF_MOD_PRM(70,___G_c_23_subtype_2d_tag,61)
___DEF_MOD_PRM(3,___G_c_23_body_2d_offset,66)
___DEF_MOD_PRM(25,___G_c_23_header_2d_offset,70)
___DEF_MOD_PRM(11,___G_c_23_desc_2d_type,74)
___DEF_MOD_PRM(9,___G_c_23_desc_2d_encoder,76)
___DEF_MOD_PRM(12,___G_c_23_desc_2d_type_2d_tag,78)
___DEF_MOD_PRM(10,___G_c_23_desc_2d_encoder_3f_,81)
___DEF_MOD_PRM(26,___G_c_23_imm_2d_desc,83)
___DEF_MOD_PRM(34,___G_c_23_imm_2d_type_3f_,86)
___DEF_MOD_PRM(27,___G_c_23_imm_2d_desc_3f_,88)
___DEF_MOD_PRM(47,___G_c_23_ref_2d_desc,93)
___DEF_MOD_PRM(55,___G_c_23_ref_2d_subtype,96)
___DEF_MOD_PRM(53,___G_c_23_ref_2d_size,98)
___DEF_MOD_PRM(56,___G_c_23_ref_2d_subtype_2d_tag,100)
___DEF_MOD_PRM(60,___G_c_23_ref_2d_type_3f_,103)
___DEF_MOD_PRM(57,___G_c_23_ref_2d_subtype_3f_,105)
___DEF_MOD_PRM(54,___G_c_23_ref_2d_size_3f_,109)
___DEF_MOD_PRM(48,___G_c_23_ref_2d_desc_3f_,111)
___DEF_MOD_PRM(75,___G_c_23_tagged_2d_value,118)
___DEF_MOD_PRM(67,___G_c_23_special_2d_desc,122)
___DEF_MOD_PRM(41,___G_c_23_object_2d__3e_desc,127)
___DEF_MOD_PRM(31,___G_c_23_imm_2d_object_3f_,155)
___DEF_MOD_PRM(52,___G_c_23_ref_2d_object_3f_,160)
___DEF_MOD_PRM(28,___G_c_23_imm_2d_encode,165)
___DEF_MOD_PRM(49,___G_c_23_ref_2d_encode,172)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G___t_2d_cpu_2d_object_2d_desc_23_,1)
___DEF_MOD_GLO(77,___G_c_23_type_2d_tag,51)
___DEF_MOD_GLO(21,___G_c_23_head_2d_type_2d_tag,56)
___DEF_MOD_GLO(70,___G_c_23_subtype_2d_tag,61)
___DEF_MOD_GLO(3,___G_c_23_body_2d_offset,66)
___DEF_MOD_GLO(25,___G_c_23_header_2d_offset,70)
___DEF_MOD_GLO(11,___G_c_23_desc_2d_type,74)
___DEF_MOD_GLO(9,___G_c_23_desc_2d_encoder,76)
___DEF_MOD_GLO(12,___G_c_23_desc_2d_type_2d_tag,78)
___DEF_MOD_GLO(10,___G_c_23_desc_2d_encoder_3f_,81)
___DEF_MOD_GLO(26,___G_c_23_imm_2d_desc,83)
___DEF_MOD_GLO(34,___G_c_23_imm_2d_type_3f_,86)
___DEF_MOD_GLO(27,___G_c_23_imm_2d_desc_3f_,88)
___DEF_MOD_GLO(47,___G_c_23_ref_2d_desc,93)
___DEF_MOD_GLO(55,___G_c_23_ref_2d_subtype,96)
___DEF_MOD_GLO(53,___G_c_23_ref_2d_size,98)
___DEF_MOD_GLO(56,___G_c_23_ref_2d_subtype_2d_tag,100)
___DEF_MOD_GLO(60,___G_c_23_ref_2d_type_3f_,103)
___DEF_MOD_GLO(57,___G_c_23_ref_2d_subtype_3f_,105)
___DEF_MOD_GLO(54,___G_c_23_ref_2d_size_3f_,109)
___DEF_MOD_GLO(48,___G_c_23_ref_2d_desc_3f_,111)
___DEF_MOD_GLO(75,___G_c_23_tagged_2d_value,118)
___DEF_MOD_GLO(67,___G_c_23_special_2d_desc,122)
___DEF_MOD_GLO(41,___G_c_23_object_2d__3e_desc,127)
___DEF_MOD_GLO(31,___G_c_23_imm_2d_object_3f_,155)
___DEF_MOD_GLO(52,___G_c_23_ref_2d_object_3f_,160)
___DEF_MOD_GLO(28,___G_c_23_imm_2d_encode,165)
___DEF_MOD_GLO(49,___G_c_23_ref_2d_encode,172)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___t_2d_cpu_2d_object_2d_desc,"_t-cpu-object-desc")
___DEF_MOD_SYM(1,___S___t_2d_cpu_2d_object_2d_desc_23_,"_t-cpu-object-desc#")
___DEF_MOD_SYM(2,___S_bignum,"bignum")
___DEF_MOD_SYM(3,___S_boxvalues,"boxvalues")
___DEF_MOD_SYM(4,___S_c_23_body_2d_offset,"c#body-offset")
___DEF_MOD_SYM(5,___S_c_23_desc_2d_encoder,"c#desc-encoder")
___DEF_MOD_SYM(6,___S_c_23_desc_2d_encoder_3f_,"c#desc-encoder?")
___DEF_MOD_SYM(7,___S_c_23_desc_2d_type,"c#desc-type")
___DEF_MOD_SYM(8,___S_c_23_desc_2d_type_2d_tag,"c#desc-type-tag")
___DEF_MOD_SYM(9,___S_c_23_head_2d_type_2d_tag,"c#head-type-tag")
___DEF_MOD_SYM(10,___S_c_23_header_2d_offset,"c#header-offset")
___DEF_MOD_SYM(11,___S_c_23_imm_2d_desc,"c#imm-desc")
___DEF_MOD_SYM(12,___S_c_23_imm_2d_desc_3f_,"c#imm-desc?")
___DEF_MOD_SYM(13,___S_c_23_imm_2d_encode,"c#imm-encode")
___DEF_MOD_SYM(14,___S_c_23_imm_2d_object_3f_,"c#imm-object?")
___DEF_MOD_SYM(15,___S_c_23_imm_2d_type_3f_,"c#imm-type?")
___DEF_MOD_SYM(16,___S_c_23_object_2d__3e_desc,"c#object->desc")
___DEF_MOD_SYM(17,___S_c_23_ref_2d_desc,"c#ref-desc")
___DEF_MOD_SYM(18,___S_c_23_ref_2d_desc_3f_,"c#ref-desc?")
___DEF_MOD_SYM(19,___S_c_23_ref_2d_encode,"c#ref-encode")
___DEF_MOD_SYM(20,___S_c_23_ref_2d_object_3f_,"c#ref-object?")
___DEF_MOD_SYM(21,___S_c_23_ref_2d_size,"c#ref-size")
___DEF_MOD_SYM(22,___S_c_23_ref_2d_size_3f_,"c#ref-size?")
___DEF_MOD_SYM(23,___S_c_23_ref_2d_subtype,"c#ref-subtype")
___DEF_MOD_SYM(24,___S_c_23_ref_2d_subtype_2d_tag,"c#ref-subtype-tag")
___DEF_MOD_SYM(25,___S_c_23_ref_2d_subtype_3f_,"c#ref-subtype?")
___DEF_MOD_SYM(26,___S_c_23_ref_2d_type_3f_,"c#ref-type?")
___DEF_MOD_SYM(27,___S_c_23_special_2d_desc,"c#special-desc")
___DEF_MOD_SYM(28,___S_c_23_subtype_2d_tag,"c#subtype-tag")
___DEF_MOD_SYM(29,___S_c_23_tagged_2d_value,"c#tagged-value")
___DEF_MOD_SYM(30,___S_c_23_type_2d_tag,"c#type-tag")
___DEF_MOD_SYM(31,___S_continuation,"continuation")
___DEF_MOD_SYM(32,___S_cpxnum,"cpxnum")
___DEF_MOD_SYM(33,___S_f32vector,"f32vector")
___DEF_MOD_SYM(34,___S_f64vector,"f64vector")
___DEF_MOD_SYM(35,___S_fixnum,"fixnum")
___DEF_MOD_SYM(36,___S_flonum,"flonum")
___DEF_MOD_SYM(37,___S_foreign,"foreign")
___DEF_MOD_SYM(38,___S_forw,"forw")
___DEF_MOD_SYM(39,___S_frame,"frame")
___DEF_MOD_SYM(40,___S_imm,"imm")
___DEF_MOD_SYM(41,___S_jazz,"jazz")
___DEF_MOD_SYM(42,___S_keyword,"keyword")
___DEF_MOD_SYM(43,___S_mem1,"mem1")
___DEF_MOD_SYM(44,___S_mem2,"mem2")
___DEF_MOD_SYM(45,___S_meroon,"meroon")
___DEF_MOD_SYM(46,___S_movable0,"movable0")
___DEF_MOD_SYM(47,___S_movable1,"movable1")
___DEF_MOD_SYM(48,___S_movable2,"movable2")
___DEF_MOD_SYM(49,___S_pair,"pair")
___DEF_MOD_SYM(50,___S_perm,"perm")
___DEF_MOD_SYM(51,___S_procedure,"procedure")
___DEF_MOD_SYM(52,___S_promise,"promise")
___DEF_MOD_SYM(53,___S_ratnum,"ratnum")
___DEF_MOD_SYM(54,___S_ref,"ref")
___DEF_MOD_SYM(55,___S_return,"return")
___DEF_MOD_SYM(56,___S_s16vector,"s16vector")
___DEF_MOD_SYM(57,___S_s32vector,"s32vector")
___DEF_MOD_SYM(58,___S_s64vector,"s64vector")
___DEF_MOD_SYM(59,___S_s8vector,"s8vector")
___DEF_MOD_SYM(60,___S_special,"special")
___DEF_MOD_SYM(61,___S_still,"still")
___DEF_MOD_SYM(62,___S_string,"string")
___DEF_MOD_SYM(63,___S_structure,"structure")
___DEF_MOD_SYM(64,___S_subtyped,"subtyped")
___DEF_MOD_SYM(65,___S_symbol,"symbol")
___DEF_MOD_SYM(66,___S_u16vector,"u16vector")
___DEF_MOD_SYM(67,___S_u32vector,"u32vector")
___DEF_MOD_SYM(68,___S_u64vector,"u64vector")
___DEF_MOD_SYM(69,___S_u8vector,"u8vector")
___DEF_MOD_SYM(70,___S_vector,"vector")
___DEF_MOD_SYM(71,___S_weak,"weak")
___END_MOD_SYM_KEY

#endif
