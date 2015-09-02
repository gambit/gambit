#ifdef ___LINKER_INFO
; File: "_host.c", produced by Gambit-C v4.7.9
(
407009
(C)
" _host"
((" _host"))
(
"_host"
"define"
"quote"
)
(
)
(
" _host"
)
(
"c#**comply-to-standard-scheme?"
"c#**main-readtable"
"c#**subtype-set!"
"c#absent-object"
"c#absent-object?"
"c#box-object"
"c#box-object?"
"c#character->unicode"
"c#deleted-object"
"c#deleted-object?"
"c#display-returning-len"
"c#end-of-file-object"
"c#end-of-file-object?"
"c#f32vect->list"
"c#f32vect-length"
"c#f32vect-ref"
"c#f32vect-set!"
"c#f32vect?"
"c#f64vect->list"
"c#f64vect-length"
"c#f64vect-ref"
"c#f64vect-set!"
"c#f64vect?"
"c#false-object"
"c#false-object?"
"c#fatal-err"
"c#float-copysign"
"c#format-filepos"
"c#in-char-range?"
"c#in-integer-range?"
"c#key-object"
"c#key-object?"
"c#keyword-object->string"
"c#keyword-object?"
"c#make-f32vect"
"c#make-f64vect"
"c#make-s16vect"
"c#make-s32vect"
"c#make-s64vect"
"c#make-s8vect"
"c#make-u16vect"
"c#make-u32vect"
"c#make-u64vect"
"c#make-u8vect"
"c#max-fixnum32-div-max-lines"
"c#max-lines"
"c#open-input-file*"
"c#optional-object"
"c#optional-object?"
"c#pp-expression"
"c#read-datum-or-eof"
"c#rest-object"
"c#rest-object?"
"c#s16vect->list"
"c#s16vect-length"
"c#s16vect-ref"
"c#s16vect-set!"
"c#s16vect?"
"c#s32vect->list"
"c#s32vect-length"
"c#s32vect-ref"
"c#s32vect-set!"
"c#s32vect?"
"c#s64vect->list"
"c#s64vect-length"
"c#s64vect-ref"
"c#s64vect-set!"
"c#s64vect?"
"c#s8vect->list"
"c#s8vect-length"
"c#s8vect-ref"
"c#s8vect-set!"
"c#s8vect?"
"c#scheme-file-extensions"
"c#scheme-global-eval"
"c#scheme-global-var"
"c#scheme-global-var-define!"
"c#scheme-global-var-ref"
"c#set-box-object!"
"c#string->keyword-object"
"c#structure->list"
"c#structure-object?"
"c#subtype-structure"
"c#symbol-object?"
"c#u16vect->list"
"c#u16vect-length"
"c#u16vect-ref"
"c#u16vect-set!"
"c#u16vect?"
"c#u32vect->list"
"c#u32vect-length"
"c#u32vect-ref"
"c#u32vect-set!"
"c#u32vect?"
"c#u64vect->list"
"c#u64vect-length"
"c#u64vect-ref"
"c#u64vect-set!"
"c#u64vect?"
"c#u8vect->list"
"c#u8vect-length"
"c#u8vect-ref"
"c#u8vect-set!"
"c#u8vect?"
"c#unbound1-object?"
"c#unbound2-object?"
"c#unbox-object"
"c#unicode->character"
"c#unused-object"
"c#unused-object?"
"c#vector-object?"
"c#void-object"
"c#void-object?"
"c#write-returning-len"
"c#write-word"
"open-output-file"
"symbol-hash"
)
(
"##f32vector->list"
"##f32vector-length"
"##f32vector-ref"
"##f32vector-set!"
"##f32vector?"
"##f64vector->list"
"##f64vector-length"
"##f64vector-ref"
"##f64vector-set!"
"##f64vector?"
"##flcopysign"
"##format-filepos"
"##keyword->string"
"##make-f32vector"
"##make-f64vector"
"##make-s16vector"
"##make-s32vector"
"##make-s64vector"
"##make-s8vector"
"##make-u16vector"
"##make-u32vector"
"##make-u64vector"
"##make-u8vector"
"##max-char"
"##open-file-generic"
"##open-output-file"
"##s16vector->list"
"##s16vector-length"
"##s16vector-ref"
"##s16vector-set!"
"##s16vector?"
"##s32vector->list"
"##s32vector-length"
"##s32vector-ref"
"##s32vector-set!"
"##s32vector?"
"##s64vector->list"
"##s64vector-length"
"##s64vector-ref"
"##s64vector-set!"
"##s64vector?"
"##s8vector->list"
"##s8vector-length"
"##s8vector-ref"
"##s8vector-set!"
"##s8vector?"
"##scheme-file-extensions"
"##string->keyword"
"##u16vector->list"
"##u16vector-length"
"##u16vector-ref"
"##u16vector-set!"
"##u16vector?"
"##u32vector->list"
"##u32vector-length"
"##u32vector-ref"
"##u32vector-set!"
"##u32vector?"
"##u64vector->list"
"##u64vector-length"
"##u64vector-ref"
"##u64vector-set!"
"##u64vector?"
"##u8vector->list"
"##u8vector-length"
"##u8vector-ref"
"##u8vector-set!"
"##u8vector?"
"##vector->list"
"<"
"<="
"display"
"error"
"eval"
"input-port?"
"open-input-file"
"pp"
"with-output-to-string"
"write"
"write-char"
)
 ()
)
#else
#define ___VERSION 407009
#define ___MODULE_NAME " _host"
#define ___LINKER_ID ____20___host
#define ___MH_PROC ___H__20___host
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 3
#define ___GLOCOUNT 198
#define ___SUPCOUNT 118
#define ___SUBCOUNT 2
#define ___LBLCOUNT 161
#define ___MODDESCR ___REF_SUB(1)
#include "gambit.h"

___NEED_SYM(___S___host)
___NEED_SYM(___S_define)
___NEED_SYM(___S_quote)

___NEED_GLO(___G__20___host)
___NEED_GLO(___G__23__23_f32vector_2d__3e_list)
___NEED_GLO(___G__23__23_f32vector_2d_length)
___NEED_GLO(___G__23__23_f32vector_2d_ref)
___NEED_GLO(___G__23__23_f32vector_2d_set_21_)
___NEED_GLO(___G__23__23_f32vector_3f_)
___NEED_GLO(___G__23__23_f64vector_2d__3e_list)
___NEED_GLO(___G__23__23_f64vector_2d_length)
___NEED_GLO(___G__23__23_f64vector_2d_ref)
___NEED_GLO(___G__23__23_f64vector_2d_set_21_)
___NEED_GLO(___G__23__23_f64vector_3f_)
___NEED_GLO(___G__23__23_flcopysign)
___NEED_GLO(___G__23__23_format_2d_filepos)
___NEED_GLO(___G__23__23_keyword_2d__3e_string)
___NEED_GLO(___G__23__23_make_2d_f32vector)
___NEED_GLO(___G__23__23_make_2d_f64vector)
___NEED_GLO(___G__23__23_make_2d_s16vector)
___NEED_GLO(___G__23__23_make_2d_s32vector)
___NEED_GLO(___G__23__23_make_2d_s64vector)
___NEED_GLO(___G__23__23_make_2d_s8vector)
___NEED_GLO(___G__23__23_make_2d_u16vector)
___NEED_GLO(___G__23__23_make_2d_u32vector)
___NEED_GLO(___G__23__23_make_2d_u64vector)
___NEED_GLO(___G__23__23_make_2d_u8vector)
___NEED_GLO(___G__23__23_max_2d_char)
___NEED_GLO(___G__23__23_open_2d_file_2d_generic)
___NEED_GLO(___G__23__23_open_2d_output_2d_file)
___NEED_GLO(___G__23__23_s16vector_2d__3e_list)
___NEED_GLO(___G__23__23_s16vector_2d_length)
___NEED_GLO(___G__23__23_s16vector_2d_ref)
___NEED_GLO(___G__23__23_s16vector_2d_set_21_)
___NEED_GLO(___G__23__23_s16vector_3f_)
___NEED_GLO(___G__23__23_s32vector_2d__3e_list)
___NEED_GLO(___G__23__23_s32vector_2d_length)
___NEED_GLO(___G__23__23_s32vector_2d_ref)
___NEED_GLO(___G__23__23_s32vector_2d_set_21_)
___NEED_GLO(___G__23__23_s32vector_3f_)
___NEED_GLO(___G__23__23_s64vector_2d__3e_list)
___NEED_GLO(___G__23__23_s64vector_2d_length)
___NEED_GLO(___G__23__23_s64vector_2d_ref)
___NEED_GLO(___G__23__23_s64vector_2d_set_21_)
___NEED_GLO(___G__23__23_s64vector_3f_)
___NEED_GLO(___G__23__23_s8vector_2d__3e_list)
___NEED_GLO(___G__23__23_s8vector_2d_length)
___NEED_GLO(___G__23__23_s8vector_2d_ref)
___NEED_GLO(___G__23__23_s8vector_2d_set_21_)
___NEED_GLO(___G__23__23_s8vector_3f_)
___NEED_GLO(___G__23__23_scheme_2d_file_2d_extensions)
___NEED_GLO(___G__23__23_string_2d__3e_keyword)
___NEED_GLO(___G__23__23_u16vector_2d__3e_list)
___NEED_GLO(___G__23__23_u16vector_2d_length)
___NEED_GLO(___G__23__23_u16vector_2d_ref)
___NEED_GLO(___G__23__23_u16vector_2d_set_21_)
___NEED_GLO(___G__23__23_u16vector_3f_)
___NEED_GLO(___G__23__23_u32vector_2d__3e_list)
___NEED_GLO(___G__23__23_u32vector_2d_length)
___NEED_GLO(___G__23__23_u32vector_2d_ref)
___NEED_GLO(___G__23__23_u32vector_2d_set_21_)
___NEED_GLO(___G__23__23_u32vector_3f_)
___NEED_GLO(___G__23__23_u64vector_2d__3e_list)
___NEED_GLO(___G__23__23_u64vector_2d_length)
___NEED_GLO(___G__23__23_u64vector_2d_ref)
___NEED_GLO(___G__23__23_u64vector_2d_set_21_)
___NEED_GLO(___G__23__23_u64vector_3f_)
___NEED_GLO(___G__23__23_u8vector_2d__3e_list)
___NEED_GLO(___G__23__23_u8vector_2d_length)
___NEED_GLO(___G__23__23_u8vector_2d_ref)
___NEED_GLO(___G__23__23_u8vector_2d_set_21_)
___NEED_GLO(___G__23__23_u8vector_3f_)
___NEED_GLO(___G__23__23_vector_2d__3e_list)
___NEED_GLO(___G__3c_)
___NEED_GLO(___G__3c__3d_)
___NEED_GLO(___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
___NEED_GLO(___G_c_23__2a__2a_main_2d_readtable)
___NEED_GLO(___G_c_23__2a__2a_subtype_2d_set_21_)
___NEED_GLO(___G_c_23_absent_2d_object)
___NEED_GLO(___G_c_23_absent_2d_object_3f_)
___NEED_GLO(___G_c_23_box_2d_object)
___NEED_GLO(___G_c_23_box_2d_object_3f_)
___NEED_GLO(___G_c_23_character_2d__3e_unicode)
___NEED_GLO(___G_c_23_deleted_2d_object)
___NEED_GLO(___G_c_23_deleted_2d_object_3f_)
___NEED_GLO(___G_c_23_display_2d_returning_2d_len)
___NEED_GLO(___G_c_23_end_2d_of_2d_file_2d_object)
___NEED_GLO(___G_c_23_end_2d_of_2d_file_2d_object_3f_)
___NEED_GLO(___G_c_23_f32vect_2d__3e_list)
___NEED_GLO(___G_c_23_f32vect_2d_length)
___NEED_GLO(___G_c_23_f32vect_2d_ref)
___NEED_GLO(___G_c_23_f32vect_2d_set_21_)
___NEED_GLO(___G_c_23_f32vect_3f_)
___NEED_GLO(___G_c_23_f64vect_2d__3e_list)
___NEED_GLO(___G_c_23_f64vect_2d_length)
___NEED_GLO(___G_c_23_f64vect_2d_ref)
___NEED_GLO(___G_c_23_f64vect_2d_set_21_)
___NEED_GLO(___G_c_23_f64vect_3f_)
___NEED_GLO(___G_c_23_false_2d_object)
___NEED_GLO(___G_c_23_false_2d_object_3f_)
___NEED_GLO(___G_c_23_fatal_2d_err)
___NEED_GLO(___G_c_23_float_2d_copysign)
___NEED_GLO(___G_c_23_format_2d_filepos)
___NEED_GLO(___G_c_23_in_2d_char_2d_range_3f_)
___NEED_GLO(___G_c_23_in_2d_integer_2d_range_3f_)
___NEED_GLO(___G_c_23_key_2d_object)
___NEED_GLO(___G_c_23_key_2d_object_3f_)
___NEED_GLO(___G_c_23_keyword_2d_object_2d__3e_string)
___NEED_GLO(___G_c_23_keyword_2d_object_3f_)
___NEED_GLO(___G_c_23_make_2d_f32vect)
___NEED_GLO(___G_c_23_make_2d_f64vect)
___NEED_GLO(___G_c_23_make_2d_s16vect)
___NEED_GLO(___G_c_23_make_2d_s32vect)
___NEED_GLO(___G_c_23_make_2d_s64vect)
___NEED_GLO(___G_c_23_make_2d_s8vect)
___NEED_GLO(___G_c_23_make_2d_u16vect)
___NEED_GLO(___G_c_23_make_2d_u32vect)
___NEED_GLO(___G_c_23_make_2d_u64vect)
___NEED_GLO(___G_c_23_make_2d_u8vect)
___NEED_GLO(___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
___NEED_GLO(___G_c_23_max_2d_lines)
___NEED_GLO(___G_c_23_open_2d_input_2d_file_2a_)
___NEED_GLO(___G_c_23_optional_2d_object)
___NEED_GLO(___G_c_23_optional_2d_object_3f_)
___NEED_GLO(___G_c_23_pp_2d_expression)
___NEED_GLO(___G_c_23_read_2d_datum_2d_or_2d_eof)
___NEED_GLO(___G_c_23_rest_2d_object)
___NEED_GLO(___G_c_23_rest_2d_object_3f_)
___NEED_GLO(___G_c_23_s16vect_2d__3e_list)
___NEED_GLO(___G_c_23_s16vect_2d_length)
___NEED_GLO(___G_c_23_s16vect_2d_ref)
___NEED_GLO(___G_c_23_s16vect_2d_set_21_)
___NEED_GLO(___G_c_23_s16vect_3f_)
___NEED_GLO(___G_c_23_s32vect_2d__3e_list)
___NEED_GLO(___G_c_23_s32vect_2d_length)
___NEED_GLO(___G_c_23_s32vect_2d_ref)
___NEED_GLO(___G_c_23_s32vect_2d_set_21_)
___NEED_GLO(___G_c_23_s32vect_3f_)
___NEED_GLO(___G_c_23_s64vect_2d__3e_list)
___NEED_GLO(___G_c_23_s64vect_2d_length)
___NEED_GLO(___G_c_23_s64vect_2d_ref)
___NEED_GLO(___G_c_23_s64vect_2d_set_21_)
___NEED_GLO(___G_c_23_s64vect_3f_)
___NEED_GLO(___G_c_23_s8vect_2d__3e_list)
___NEED_GLO(___G_c_23_s8vect_2d_length)
___NEED_GLO(___G_c_23_s8vect_2d_ref)
___NEED_GLO(___G_c_23_s8vect_2d_set_21_)
___NEED_GLO(___G_c_23_s8vect_3f_)
___NEED_GLO(___G_c_23_scheme_2d_file_2d_extensions)
___NEED_GLO(___G_c_23_scheme_2d_global_2d_eval)
___NEED_GLO(___G_c_23_scheme_2d_global_2d_var)
___NEED_GLO(___G_c_23_scheme_2d_global_2d_var_2d_define_21_)
___NEED_GLO(___G_c_23_scheme_2d_global_2d_var_2d_ref)
___NEED_GLO(___G_c_23_set_2d_box_2d_object_21_)
___NEED_GLO(___G_c_23_string_2d__3e_keyword_2d_object)
___NEED_GLO(___G_c_23_structure_2d__3e_list)
___NEED_GLO(___G_c_23_structure_2d_object_3f_)
___NEED_GLO(___G_c_23_subtype_2d_structure)
___NEED_GLO(___G_c_23_symbol_2d_object_3f_)
___NEED_GLO(___G_c_23_u16vect_2d__3e_list)
___NEED_GLO(___G_c_23_u16vect_2d_length)
___NEED_GLO(___G_c_23_u16vect_2d_ref)
___NEED_GLO(___G_c_23_u16vect_2d_set_21_)
___NEED_GLO(___G_c_23_u16vect_3f_)
___NEED_GLO(___G_c_23_u32vect_2d__3e_list)
___NEED_GLO(___G_c_23_u32vect_2d_length)
___NEED_GLO(___G_c_23_u32vect_2d_ref)
___NEED_GLO(___G_c_23_u32vect_2d_set_21_)
___NEED_GLO(___G_c_23_u32vect_3f_)
___NEED_GLO(___G_c_23_u64vect_2d__3e_list)
___NEED_GLO(___G_c_23_u64vect_2d_length)
___NEED_GLO(___G_c_23_u64vect_2d_ref)
___NEED_GLO(___G_c_23_u64vect_2d_set_21_)
___NEED_GLO(___G_c_23_u64vect_3f_)
___NEED_GLO(___G_c_23_u8vect_2d__3e_list)
___NEED_GLO(___G_c_23_u8vect_2d_length)
___NEED_GLO(___G_c_23_u8vect_2d_ref)
___NEED_GLO(___G_c_23_u8vect_2d_set_21_)
___NEED_GLO(___G_c_23_u8vect_3f_)
___NEED_GLO(___G_c_23_unbound1_2d_object_3f_)
___NEED_GLO(___G_c_23_unbound2_2d_object_3f_)
___NEED_GLO(___G_c_23_unbox_2d_object)
___NEED_GLO(___G_c_23_unicode_2d__3e_character)
___NEED_GLO(___G_c_23_unused_2d_object)
___NEED_GLO(___G_c_23_unused_2d_object_3f_)
___NEED_GLO(___G_c_23_vector_2d_object_3f_)
___NEED_GLO(___G_c_23_void_2d_object)
___NEED_GLO(___G_c_23_void_2d_object_3f_)
___NEED_GLO(___G_c_23_write_2d_returning_2d_len)
___NEED_GLO(___G_c_23_write_2d_word)
___NEED_GLO(___G_display)
___NEED_GLO(___G_error)
___NEED_GLO(___G_eval)
___NEED_GLO(___G_input_2d_port_3f_)
___NEED_GLO(___G_open_2d_input_2d_file)
___NEED_GLO(___G_open_2d_output_2d_file)
___NEED_GLO(___G_pp)
___NEED_GLO(___G_symbol_2d_hash)
___NEED_GLO(___G_with_2d_output_2d_to_2d_string)
___NEED_GLO(___G_write)
___NEED_GLO(___G_write_2d_char)

___BEGIN_SYM
___DEF_SYM(0,___S___host,"_host")
___DEF_SYM(1,___S_define,"define")
___DEF_SYM(2,___S_quote,"quote")
___END_SYM

#define ___SYM___host ___SYM(0,___S___host)
#define ___SYM_define ___SYM(1,___S_define)
#define ___SYM_quote ___SYM(2,___S_quote)

___BEGIN_GLO
___DEF_GLO(0," _host")
___DEF_GLO(1,"c#**comply-to-standard-scheme?")
___DEF_GLO(2,"c#**main-readtable")
___DEF_GLO(3,"c#**subtype-set!")
___DEF_GLO(4,"c#absent-object")
___DEF_GLO(5,"c#absent-object?")
___DEF_GLO(6,"c#box-object")
___DEF_GLO(7,"c#box-object?")
___DEF_GLO(8,"c#character->unicode")
___DEF_GLO(9,"c#deleted-object")
___DEF_GLO(10,"c#deleted-object?")
___DEF_GLO(11,"c#display-returning-len")
___DEF_GLO(12,"c#end-of-file-object")
___DEF_GLO(13,"c#end-of-file-object?")
___DEF_GLO(14,"c#f32vect->list")
___DEF_GLO(15,"c#f32vect-length")
___DEF_GLO(16,"c#f32vect-ref")
___DEF_GLO(17,"c#f32vect-set!")
___DEF_GLO(18,"c#f32vect?")
___DEF_GLO(19,"c#f64vect->list")
___DEF_GLO(20,"c#f64vect-length")
___DEF_GLO(21,"c#f64vect-ref")
___DEF_GLO(22,"c#f64vect-set!")
___DEF_GLO(23,"c#f64vect?")
___DEF_GLO(24,"c#false-object")
___DEF_GLO(25,"c#false-object?")
___DEF_GLO(26,"c#fatal-err")
___DEF_GLO(27,"c#float-copysign")
___DEF_GLO(28,"c#format-filepos")
___DEF_GLO(29,"c#in-char-range?")
___DEF_GLO(30,"c#in-integer-range?")
___DEF_GLO(31,"c#key-object")
___DEF_GLO(32,"c#key-object?")
___DEF_GLO(33,"c#keyword-object->string")
___DEF_GLO(34,"c#keyword-object?")
___DEF_GLO(35,"c#make-f32vect")
___DEF_GLO(36,"c#make-f64vect")
___DEF_GLO(37,"c#make-s16vect")
___DEF_GLO(38,"c#make-s32vect")
___DEF_GLO(39,"c#make-s64vect")
___DEF_GLO(40,"c#make-s8vect")
___DEF_GLO(41,"c#make-u16vect")
___DEF_GLO(42,"c#make-u32vect")
___DEF_GLO(43,"c#make-u64vect")
___DEF_GLO(44,"c#make-u8vect")
___DEF_GLO(45,"c#max-fixnum32-div-max-lines")
___DEF_GLO(46,"c#max-lines")
___DEF_GLO(47,"c#open-input-file*")
___DEF_GLO(48,"c#optional-object")
___DEF_GLO(49,"c#optional-object?")
___DEF_GLO(50,"c#pp-expression")
___DEF_GLO(51,"c#read-datum-or-eof")
___DEF_GLO(52,"c#rest-object")
___DEF_GLO(53,"c#rest-object?")
___DEF_GLO(54,"c#s16vect->list")
___DEF_GLO(55,"c#s16vect-length")
___DEF_GLO(56,"c#s16vect-ref")
___DEF_GLO(57,"c#s16vect-set!")
___DEF_GLO(58,"c#s16vect?")
___DEF_GLO(59,"c#s32vect->list")
___DEF_GLO(60,"c#s32vect-length")
___DEF_GLO(61,"c#s32vect-ref")
___DEF_GLO(62,"c#s32vect-set!")
___DEF_GLO(63,"c#s32vect?")
___DEF_GLO(64,"c#s64vect->list")
___DEF_GLO(65,"c#s64vect-length")
___DEF_GLO(66,"c#s64vect-ref")
___DEF_GLO(67,"c#s64vect-set!")
___DEF_GLO(68,"c#s64vect?")
___DEF_GLO(69,"c#s8vect->list")
___DEF_GLO(70,"c#s8vect-length")
___DEF_GLO(71,"c#s8vect-ref")
___DEF_GLO(72,"c#s8vect-set!")
___DEF_GLO(73,"c#s8vect?")
___DEF_GLO(74,"c#scheme-file-extensions")
___DEF_GLO(75,"c#scheme-global-eval")
___DEF_GLO(76,"c#scheme-global-var")
___DEF_GLO(77,"c#scheme-global-var-define!")
___DEF_GLO(78,"c#scheme-global-var-ref")
___DEF_GLO(79,"c#set-box-object!")
___DEF_GLO(80,"c#string->keyword-object")
___DEF_GLO(81,"c#structure->list")
___DEF_GLO(82,"c#structure-object?")
___DEF_GLO(83,"c#subtype-structure")
___DEF_GLO(84,"c#symbol-object?")
___DEF_GLO(85,"c#u16vect->list")
___DEF_GLO(86,"c#u16vect-length")
___DEF_GLO(87,"c#u16vect-ref")
___DEF_GLO(88,"c#u16vect-set!")
___DEF_GLO(89,"c#u16vect?")
___DEF_GLO(90,"c#u32vect->list")
___DEF_GLO(91,"c#u32vect-length")
___DEF_GLO(92,"c#u32vect-ref")
___DEF_GLO(93,"c#u32vect-set!")
___DEF_GLO(94,"c#u32vect?")
___DEF_GLO(95,"c#u64vect->list")
___DEF_GLO(96,"c#u64vect-length")
___DEF_GLO(97,"c#u64vect-ref")
___DEF_GLO(98,"c#u64vect-set!")
___DEF_GLO(99,"c#u64vect?")
___DEF_GLO(100,"c#u8vect->list")
___DEF_GLO(101,"c#u8vect-length")
___DEF_GLO(102,"c#u8vect-ref")
___DEF_GLO(103,"c#u8vect-set!")
___DEF_GLO(104,"c#u8vect?")
___DEF_GLO(105,"c#unbound1-object?")
___DEF_GLO(106,"c#unbound2-object?")
___DEF_GLO(107,"c#unbox-object")
___DEF_GLO(108,"c#unicode->character")
___DEF_GLO(109,"c#unused-object")
___DEF_GLO(110,"c#unused-object?")
___DEF_GLO(111,"c#vector-object?")
___DEF_GLO(112,"c#void-object")
___DEF_GLO(113,"c#void-object?")
___DEF_GLO(114,"c#write-returning-len")
___DEF_GLO(115,"c#write-word")
___DEF_GLO(116,"open-output-file")
___DEF_GLO(117,"symbol-hash")
___DEF_GLO(118,"##f32vector->list")
___DEF_GLO(119,"##f32vector-length")
___DEF_GLO(120,"##f32vector-ref")
___DEF_GLO(121,"##f32vector-set!")
___DEF_GLO(122,"##f32vector?")
___DEF_GLO(123,"##f64vector->list")
___DEF_GLO(124,"##f64vector-length")
___DEF_GLO(125,"##f64vector-ref")
___DEF_GLO(126,"##f64vector-set!")
___DEF_GLO(127,"##f64vector?")
___DEF_GLO(128,"##flcopysign")
___DEF_GLO(129,"##format-filepos")
___DEF_GLO(130,"##keyword->string")
___DEF_GLO(131,"##make-f32vector")
___DEF_GLO(132,"##make-f64vector")
___DEF_GLO(133,"##make-s16vector")
___DEF_GLO(134,"##make-s32vector")
___DEF_GLO(135,"##make-s64vector")
___DEF_GLO(136,"##make-s8vector")
___DEF_GLO(137,"##make-u16vector")
___DEF_GLO(138,"##make-u32vector")
___DEF_GLO(139,"##make-u64vector")
___DEF_GLO(140,"##make-u8vector")
___DEF_GLO(141,"##max-char")
___DEF_GLO(142,"##open-file-generic")
___DEF_GLO(143,"##open-output-file")
___DEF_GLO(144,"##s16vector->list")
___DEF_GLO(145,"##s16vector-length")
___DEF_GLO(146,"##s16vector-ref")
___DEF_GLO(147,"##s16vector-set!")
___DEF_GLO(148,"##s16vector?")
___DEF_GLO(149,"##s32vector->list")
___DEF_GLO(150,"##s32vector-length")
___DEF_GLO(151,"##s32vector-ref")
___DEF_GLO(152,"##s32vector-set!")
___DEF_GLO(153,"##s32vector?")
___DEF_GLO(154,"##s64vector->list")
___DEF_GLO(155,"##s64vector-length")
___DEF_GLO(156,"##s64vector-ref")
___DEF_GLO(157,"##s64vector-set!")
___DEF_GLO(158,"##s64vector?")
___DEF_GLO(159,"##s8vector->list")
___DEF_GLO(160,"##s8vector-length")
___DEF_GLO(161,"##s8vector-ref")
___DEF_GLO(162,"##s8vector-set!")
___DEF_GLO(163,"##s8vector?")
___DEF_GLO(164,"##scheme-file-extensions")
___DEF_GLO(165,"##string->keyword")
___DEF_GLO(166,"##u16vector->list")
___DEF_GLO(167,"##u16vector-length")
___DEF_GLO(168,"##u16vector-ref")
___DEF_GLO(169,"##u16vector-set!")
___DEF_GLO(170,"##u16vector?")
___DEF_GLO(171,"##u32vector->list")
___DEF_GLO(172,"##u32vector-length")
___DEF_GLO(173,"##u32vector-ref")
___DEF_GLO(174,"##u32vector-set!")
___DEF_GLO(175,"##u32vector?")
___DEF_GLO(176,"##u64vector->list")
___DEF_GLO(177,"##u64vector-length")
___DEF_GLO(178,"##u64vector-ref")
___DEF_GLO(179,"##u64vector-set!")
___DEF_GLO(180,"##u64vector?")
___DEF_GLO(181,"##u8vector->list")
___DEF_GLO(182,"##u8vector-length")
___DEF_GLO(183,"##u8vector-ref")
___DEF_GLO(184,"##u8vector-set!")
___DEF_GLO(185,"##u8vector?")
___DEF_GLO(186,"##vector->list")
___DEF_GLO(187,"<")
___DEF_GLO(188,"<=")
___DEF_GLO(189,"display")
___DEF_GLO(190,"error")
___DEF_GLO(191,"eval")
___DEF_GLO(192,"input-port?")
___DEF_GLO(193,"open-input-file")
___DEF_GLO(194,"pp")
___DEF_GLO(195,"with-output-to-string")
___DEF_GLO(196,"write")
___DEF_GLO(197,"write-char")
___END_GLO

#define ___GLO__20___host ___GLO(0,___G__20___host)
#define ___PRM__20___host ___PRM(0,___G__20___host)
#define ___GLO_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_ ___GLO(1,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
#define ___PRM_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_ ___PRM(1,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
#define ___GLO_c_23__2a__2a_main_2d_readtable ___GLO(2,___G_c_23__2a__2a_main_2d_readtable)
#define ___PRM_c_23__2a__2a_main_2d_readtable ___PRM(2,___G_c_23__2a__2a_main_2d_readtable)
#define ___GLO_c_23__2a__2a_subtype_2d_set_21_ ___GLO(3,___G_c_23__2a__2a_subtype_2d_set_21_)
#define ___PRM_c_23__2a__2a_subtype_2d_set_21_ ___PRM(3,___G_c_23__2a__2a_subtype_2d_set_21_)
#define ___GLO_c_23_absent_2d_object ___GLO(4,___G_c_23_absent_2d_object)
#define ___PRM_c_23_absent_2d_object ___PRM(4,___G_c_23_absent_2d_object)
#define ___GLO_c_23_absent_2d_object_3f_ ___GLO(5,___G_c_23_absent_2d_object_3f_)
#define ___PRM_c_23_absent_2d_object_3f_ ___PRM(5,___G_c_23_absent_2d_object_3f_)
#define ___GLO_c_23_box_2d_object ___GLO(6,___G_c_23_box_2d_object)
#define ___PRM_c_23_box_2d_object ___PRM(6,___G_c_23_box_2d_object)
#define ___GLO_c_23_box_2d_object_3f_ ___GLO(7,___G_c_23_box_2d_object_3f_)
#define ___PRM_c_23_box_2d_object_3f_ ___PRM(7,___G_c_23_box_2d_object_3f_)
#define ___GLO_c_23_character_2d__3e_unicode ___GLO(8,___G_c_23_character_2d__3e_unicode)
#define ___PRM_c_23_character_2d__3e_unicode ___PRM(8,___G_c_23_character_2d__3e_unicode)
#define ___GLO_c_23_deleted_2d_object ___GLO(9,___G_c_23_deleted_2d_object)
#define ___PRM_c_23_deleted_2d_object ___PRM(9,___G_c_23_deleted_2d_object)
#define ___GLO_c_23_deleted_2d_object_3f_ ___GLO(10,___G_c_23_deleted_2d_object_3f_)
#define ___PRM_c_23_deleted_2d_object_3f_ ___PRM(10,___G_c_23_deleted_2d_object_3f_)
#define ___GLO_c_23_display_2d_returning_2d_len ___GLO(11,___G_c_23_display_2d_returning_2d_len)
#define ___PRM_c_23_display_2d_returning_2d_len ___PRM(11,___G_c_23_display_2d_returning_2d_len)
#define ___GLO_c_23_end_2d_of_2d_file_2d_object ___GLO(12,___G_c_23_end_2d_of_2d_file_2d_object)
#define ___PRM_c_23_end_2d_of_2d_file_2d_object ___PRM(12,___G_c_23_end_2d_of_2d_file_2d_object)
#define ___GLO_c_23_end_2d_of_2d_file_2d_object_3f_ ___GLO(13,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___PRM_c_23_end_2d_of_2d_file_2d_object_3f_ ___PRM(13,___G_c_23_end_2d_of_2d_file_2d_object_3f_)
#define ___GLO_c_23_f32vect_2d__3e_list ___GLO(14,___G_c_23_f32vect_2d__3e_list)
#define ___PRM_c_23_f32vect_2d__3e_list ___PRM(14,___G_c_23_f32vect_2d__3e_list)
#define ___GLO_c_23_f32vect_2d_length ___GLO(15,___G_c_23_f32vect_2d_length)
#define ___PRM_c_23_f32vect_2d_length ___PRM(15,___G_c_23_f32vect_2d_length)
#define ___GLO_c_23_f32vect_2d_ref ___GLO(16,___G_c_23_f32vect_2d_ref)
#define ___PRM_c_23_f32vect_2d_ref ___PRM(16,___G_c_23_f32vect_2d_ref)
#define ___GLO_c_23_f32vect_2d_set_21_ ___GLO(17,___G_c_23_f32vect_2d_set_21_)
#define ___PRM_c_23_f32vect_2d_set_21_ ___PRM(17,___G_c_23_f32vect_2d_set_21_)
#define ___GLO_c_23_f32vect_3f_ ___GLO(18,___G_c_23_f32vect_3f_)
#define ___PRM_c_23_f32vect_3f_ ___PRM(18,___G_c_23_f32vect_3f_)
#define ___GLO_c_23_f64vect_2d__3e_list ___GLO(19,___G_c_23_f64vect_2d__3e_list)
#define ___PRM_c_23_f64vect_2d__3e_list ___PRM(19,___G_c_23_f64vect_2d__3e_list)
#define ___GLO_c_23_f64vect_2d_length ___GLO(20,___G_c_23_f64vect_2d_length)
#define ___PRM_c_23_f64vect_2d_length ___PRM(20,___G_c_23_f64vect_2d_length)
#define ___GLO_c_23_f64vect_2d_ref ___GLO(21,___G_c_23_f64vect_2d_ref)
#define ___PRM_c_23_f64vect_2d_ref ___PRM(21,___G_c_23_f64vect_2d_ref)
#define ___GLO_c_23_f64vect_2d_set_21_ ___GLO(22,___G_c_23_f64vect_2d_set_21_)
#define ___PRM_c_23_f64vect_2d_set_21_ ___PRM(22,___G_c_23_f64vect_2d_set_21_)
#define ___GLO_c_23_f64vect_3f_ ___GLO(23,___G_c_23_f64vect_3f_)
#define ___PRM_c_23_f64vect_3f_ ___PRM(23,___G_c_23_f64vect_3f_)
#define ___GLO_c_23_false_2d_object ___GLO(24,___G_c_23_false_2d_object)
#define ___PRM_c_23_false_2d_object ___PRM(24,___G_c_23_false_2d_object)
#define ___GLO_c_23_false_2d_object_3f_ ___GLO(25,___G_c_23_false_2d_object_3f_)
#define ___PRM_c_23_false_2d_object_3f_ ___PRM(25,___G_c_23_false_2d_object_3f_)
#define ___GLO_c_23_fatal_2d_err ___GLO(26,___G_c_23_fatal_2d_err)
#define ___PRM_c_23_fatal_2d_err ___PRM(26,___G_c_23_fatal_2d_err)
#define ___GLO_c_23_float_2d_copysign ___GLO(27,___G_c_23_float_2d_copysign)
#define ___PRM_c_23_float_2d_copysign ___PRM(27,___G_c_23_float_2d_copysign)
#define ___GLO_c_23_format_2d_filepos ___GLO(28,___G_c_23_format_2d_filepos)
#define ___PRM_c_23_format_2d_filepos ___PRM(28,___G_c_23_format_2d_filepos)
#define ___GLO_c_23_in_2d_char_2d_range_3f_ ___GLO(29,___G_c_23_in_2d_char_2d_range_3f_)
#define ___PRM_c_23_in_2d_char_2d_range_3f_ ___PRM(29,___G_c_23_in_2d_char_2d_range_3f_)
#define ___GLO_c_23_in_2d_integer_2d_range_3f_ ___GLO(30,___G_c_23_in_2d_integer_2d_range_3f_)
#define ___PRM_c_23_in_2d_integer_2d_range_3f_ ___PRM(30,___G_c_23_in_2d_integer_2d_range_3f_)
#define ___GLO_c_23_key_2d_object ___GLO(31,___G_c_23_key_2d_object)
#define ___PRM_c_23_key_2d_object ___PRM(31,___G_c_23_key_2d_object)
#define ___GLO_c_23_key_2d_object_3f_ ___GLO(32,___G_c_23_key_2d_object_3f_)
#define ___PRM_c_23_key_2d_object_3f_ ___PRM(32,___G_c_23_key_2d_object_3f_)
#define ___GLO_c_23_keyword_2d_object_2d__3e_string ___GLO(33,___G_c_23_keyword_2d_object_2d__3e_string)
#define ___PRM_c_23_keyword_2d_object_2d__3e_string ___PRM(33,___G_c_23_keyword_2d_object_2d__3e_string)
#define ___GLO_c_23_keyword_2d_object_3f_ ___GLO(34,___G_c_23_keyword_2d_object_3f_)
#define ___PRM_c_23_keyword_2d_object_3f_ ___PRM(34,___G_c_23_keyword_2d_object_3f_)
#define ___GLO_c_23_make_2d_f32vect ___GLO(35,___G_c_23_make_2d_f32vect)
#define ___PRM_c_23_make_2d_f32vect ___PRM(35,___G_c_23_make_2d_f32vect)
#define ___GLO_c_23_make_2d_f64vect ___GLO(36,___G_c_23_make_2d_f64vect)
#define ___PRM_c_23_make_2d_f64vect ___PRM(36,___G_c_23_make_2d_f64vect)
#define ___GLO_c_23_make_2d_s16vect ___GLO(37,___G_c_23_make_2d_s16vect)
#define ___PRM_c_23_make_2d_s16vect ___PRM(37,___G_c_23_make_2d_s16vect)
#define ___GLO_c_23_make_2d_s32vect ___GLO(38,___G_c_23_make_2d_s32vect)
#define ___PRM_c_23_make_2d_s32vect ___PRM(38,___G_c_23_make_2d_s32vect)
#define ___GLO_c_23_make_2d_s64vect ___GLO(39,___G_c_23_make_2d_s64vect)
#define ___PRM_c_23_make_2d_s64vect ___PRM(39,___G_c_23_make_2d_s64vect)
#define ___GLO_c_23_make_2d_s8vect ___GLO(40,___G_c_23_make_2d_s8vect)
#define ___PRM_c_23_make_2d_s8vect ___PRM(40,___G_c_23_make_2d_s8vect)
#define ___GLO_c_23_make_2d_u16vect ___GLO(41,___G_c_23_make_2d_u16vect)
#define ___PRM_c_23_make_2d_u16vect ___PRM(41,___G_c_23_make_2d_u16vect)
#define ___GLO_c_23_make_2d_u32vect ___GLO(42,___G_c_23_make_2d_u32vect)
#define ___PRM_c_23_make_2d_u32vect ___PRM(42,___G_c_23_make_2d_u32vect)
#define ___GLO_c_23_make_2d_u64vect ___GLO(43,___G_c_23_make_2d_u64vect)
#define ___PRM_c_23_make_2d_u64vect ___PRM(43,___G_c_23_make_2d_u64vect)
#define ___GLO_c_23_make_2d_u8vect ___GLO(44,___G_c_23_make_2d_u8vect)
#define ___PRM_c_23_make_2d_u8vect ___PRM(44,___G_c_23_make_2d_u8vect)
#define ___GLO_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines ___GLO(45,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
#define ___PRM_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines ___PRM(45,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
#define ___GLO_c_23_max_2d_lines ___GLO(46,___G_c_23_max_2d_lines)
#define ___PRM_c_23_max_2d_lines ___PRM(46,___G_c_23_max_2d_lines)
#define ___GLO_c_23_open_2d_input_2d_file_2a_ ___GLO(47,___G_c_23_open_2d_input_2d_file_2a_)
#define ___PRM_c_23_open_2d_input_2d_file_2a_ ___PRM(47,___G_c_23_open_2d_input_2d_file_2a_)
#define ___GLO_c_23_optional_2d_object ___GLO(48,___G_c_23_optional_2d_object)
#define ___PRM_c_23_optional_2d_object ___PRM(48,___G_c_23_optional_2d_object)
#define ___GLO_c_23_optional_2d_object_3f_ ___GLO(49,___G_c_23_optional_2d_object_3f_)
#define ___PRM_c_23_optional_2d_object_3f_ ___PRM(49,___G_c_23_optional_2d_object_3f_)
#define ___GLO_c_23_pp_2d_expression ___GLO(50,___G_c_23_pp_2d_expression)
#define ___PRM_c_23_pp_2d_expression ___PRM(50,___G_c_23_pp_2d_expression)
#define ___GLO_c_23_read_2d_datum_2d_or_2d_eof ___GLO(51,___G_c_23_read_2d_datum_2d_or_2d_eof)
#define ___PRM_c_23_read_2d_datum_2d_or_2d_eof ___PRM(51,___G_c_23_read_2d_datum_2d_or_2d_eof)
#define ___GLO_c_23_rest_2d_object ___GLO(52,___G_c_23_rest_2d_object)
#define ___PRM_c_23_rest_2d_object ___PRM(52,___G_c_23_rest_2d_object)
#define ___GLO_c_23_rest_2d_object_3f_ ___GLO(53,___G_c_23_rest_2d_object_3f_)
#define ___PRM_c_23_rest_2d_object_3f_ ___PRM(53,___G_c_23_rest_2d_object_3f_)
#define ___GLO_c_23_s16vect_2d__3e_list ___GLO(54,___G_c_23_s16vect_2d__3e_list)
#define ___PRM_c_23_s16vect_2d__3e_list ___PRM(54,___G_c_23_s16vect_2d__3e_list)
#define ___GLO_c_23_s16vect_2d_length ___GLO(55,___G_c_23_s16vect_2d_length)
#define ___PRM_c_23_s16vect_2d_length ___PRM(55,___G_c_23_s16vect_2d_length)
#define ___GLO_c_23_s16vect_2d_ref ___GLO(56,___G_c_23_s16vect_2d_ref)
#define ___PRM_c_23_s16vect_2d_ref ___PRM(56,___G_c_23_s16vect_2d_ref)
#define ___GLO_c_23_s16vect_2d_set_21_ ___GLO(57,___G_c_23_s16vect_2d_set_21_)
#define ___PRM_c_23_s16vect_2d_set_21_ ___PRM(57,___G_c_23_s16vect_2d_set_21_)
#define ___GLO_c_23_s16vect_3f_ ___GLO(58,___G_c_23_s16vect_3f_)
#define ___PRM_c_23_s16vect_3f_ ___PRM(58,___G_c_23_s16vect_3f_)
#define ___GLO_c_23_s32vect_2d__3e_list ___GLO(59,___G_c_23_s32vect_2d__3e_list)
#define ___PRM_c_23_s32vect_2d__3e_list ___PRM(59,___G_c_23_s32vect_2d__3e_list)
#define ___GLO_c_23_s32vect_2d_length ___GLO(60,___G_c_23_s32vect_2d_length)
#define ___PRM_c_23_s32vect_2d_length ___PRM(60,___G_c_23_s32vect_2d_length)
#define ___GLO_c_23_s32vect_2d_ref ___GLO(61,___G_c_23_s32vect_2d_ref)
#define ___PRM_c_23_s32vect_2d_ref ___PRM(61,___G_c_23_s32vect_2d_ref)
#define ___GLO_c_23_s32vect_2d_set_21_ ___GLO(62,___G_c_23_s32vect_2d_set_21_)
#define ___PRM_c_23_s32vect_2d_set_21_ ___PRM(62,___G_c_23_s32vect_2d_set_21_)
#define ___GLO_c_23_s32vect_3f_ ___GLO(63,___G_c_23_s32vect_3f_)
#define ___PRM_c_23_s32vect_3f_ ___PRM(63,___G_c_23_s32vect_3f_)
#define ___GLO_c_23_s64vect_2d__3e_list ___GLO(64,___G_c_23_s64vect_2d__3e_list)
#define ___PRM_c_23_s64vect_2d__3e_list ___PRM(64,___G_c_23_s64vect_2d__3e_list)
#define ___GLO_c_23_s64vect_2d_length ___GLO(65,___G_c_23_s64vect_2d_length)
#define ___PRM_c_23_s64vect_2d_length ___PRM(65,___G_c_23_s64vect_2d_length)
#define ___GLO_c_23_s64vect_2d_ref ___GLO(66,___G_c_23_s64vect_2d_ref)
#define ___PRM_c_23_s64vect_2d_ref ___PRM(66,___G_c_23_s64vect_2d_ref)
#define ___GLO_c_23_s64vect_2d_set_21_ ___GLO(67,___G_c_23_s64vect_2d_set_21_)
#define ___PRM_c_23_s64vect_2d_set_21_ ___PRM(67,___G_c_23_s64vect_2d_set_21_)
#define ___GLO_c_23_s64vect_3f_ ___GLO(68,___G_c_23_s64vect_3f_)
#define ___PRM_c_23_s64vect_3f_ ___PRM(68,___G_c_23_s64vect_3f_)
#define ___GLO_c_23_s8vect_2d__3e_list ___GLO(69,___G_c_23_s8vect_2d__3e_list)
#define ___PRM_c_23_s8vect_2d__3e_list ___PRM(69,___G_c_23_s8vect_2d__3e_list)
#define ___GLO_c_23_s8vect_2d_length ___GLO(70,___G_c_23_s8vect_2d_length)
#define ___PRM_c_23_s8vect_2d_length ___PRM(70,___G_c_23_s8vect_2d_length)
#define ___GLO_c_23_s8vect_2d_ref ___GLO(71,___G_c_23_s8vect_2d_ref)
#define ___PRM_c_23_s8vect_2d_ref ___PRM(71,___G_c_23_s8vect_2d_ref)
#define ___GLO_c_23_s8vect_2d_set_21_ ___GLO(72,___G_c_23_s8vect_2d_set_21_)
#define ___PRM_c_23_s8vect_2d_set_21_ ___PRM(72,___G_c_23_s8vect_2d_set_21_)
#define ___GLO_c_23_s8vect_3f_ ___GLO(73,___G_c_23_s8vect_3f_)
#define ___PRM_c_23_s8vect_3f_ ___PRM(73,___G_c_23_s8vect_3f_)
#define ___GLO_c_23_scheme_2d_file_2d_extensions ___GLO(74,___G_c_23_scheme_2d_file_2d_extensions)
#define ___PRM_c_23_scheme_2d_file_2d_extensions ___PRM(74,___G_c_23_scheme_2d_file_2d_extensions)
#define ___GLO_c_23_scheme_2d_global_2d_eval ___GLO(75,___G_c_23_scheme_2d_global_2d_eval)
#define ___PRM_c_23_scheme_2d_global_2d_eval ___PRM(75,___G_c_23_scheme_2d_global_2d_eval)
#define ___GLO_c_23_scheme_2d_global_2d_var ___GLO(76,___G_c_23_scheme_2d_global_2d_var)
#define ___PRM_c_23_scheme_2d_global_2d_var ___PRM(76,___G_c_23_scheme_2d_global_2d_var)
#define ___GLO_c_23_scheme_2d_global_2d_var_2d_define_21_ ___GLO(77,___G_c_23_scheme_2d_global_2d_var_2d_define_21_)
#define ___PRM_c_23_scheme_2d_global_2d_var_2d_define_21_ ___PRM(77,___G_c_23_scheme_2d_global_2d_var_2d_define_21_)
#define ___GLO_c_23_scheme_2d_global_2d_var_2d_ref ___GLO(78,___G_c_23_scheme_2d_global_2d_var_2d_ref)
#define ___PRM_c_23_scheme_2d_global_2d_var_2d_ref ___PRM(78,___G_c_23_scheme_2d_global_2d_var_2d_ref)
#define ___GLO_c_23_set_2d_box_2d_object_21_ ___GLO(79,___G_c_23_set_2d_box_2d_object_21_)
#define ___PRM_c_23_set_2d_box_2d_object_21_ ___PRM(79,___G_c_23_set_2d_box_2d_object_21_)
#define ___GLO_c_23_string_2d__3e_keyword_2d_object ___GLO(80,___G_c_23_string_2d__3e_keyword_2d_object)
#define ___PRM_c_23_string_2d__3e_keyword_2d_object ___PRM(80,___G_c_23_string_2d__3e_keyword_2d_object)
#define ___GLO_c_23_structure_2d__3e_list ___GLO(81,___G_c_23_structure_2d__3e_list)
#define ___PRM_c_23_structure_2d__3e_list ___PRM(81,___G_c_23_structure_2d__3e_list)
#define ___GLO_c_23_structure_2d_object_3f_ ___GLO(82,___G_c_23_structure_2d_object_3f_)
#define ___PRM_c_23_structure_2d_object_3f_ ___PRM(82,___G_c_23_structure_2d_object_3f_)
#define ___GLO_c_23_subtype_2d_structure ___GLO(83,___G_c_23_subtype_2d_structure)
#define ___PRM_c_23_subtype_2d_structure ___PRM(83,___G_c_23_subtype_2d_structure)
#define ___GLO_c_23_symbol_2d_object_3f_ ___GLO(84,___G_c_23_symbol_2d_object_3f_)
#define ___PRM_c_23_symbol_2d_object_3f_ ___PRM(84,___G_c_23_symbol_2d_object_3f_)
#define ___GLO_c_23_u16vect_2d__3e_list ___GLO(85,___G_c_23_u16vect_2d__3e_list)
#define ___PRM_c_23_u16vect_2d__3e_list ___PRM(85,___G_c_23_u16vect_2d__3e_list)
#define ___GLO_c_23_u16vect_2d_length ___GLO(86,___G_c_23_u16vect_2d_length)
#define ___PRM_c_23_u16vect_2d_length ___PRM(86,___G_c_23_u16vect_2d_length)
#define ___GLO_c_23_u16vect_2d_ref ___GLO(87,___G_c_23_u16vect_2d_ref)
#define ___PRM_c_23_u16vect_2d_ref ___PRM(87,___G_c_23_u16vect_2d_ref)
#define ___GLO_c_23_u16vect_2d_set_21_ ___GLO(88,___G_c_23_u16vect_2d_set_21_)
#define ___PRM_c_23_u16vect_2d_set_21_ ___PRM(88,___G_c_23_u16vect_2d_set_21_)
#define ___GLO_c_23_u16vect_3f_ ___GLO(89,___G_c_23_u16vect_3f_)
#define ___PRM_c_23_u16vect_3f_ ___PRM(89,___G_c_23_u16vect_3f_)
#define ___GLO_c_23_u32vect_2d__3e_list ___GLO(90,___G_c_23_u32vect_2d__3e_list)
#define ___PRM_c_23_u32vect_2d__3e_list ___PRM(90,___G_c_23_u32vect_2d__3e_list)
#define ___GLO_c_23_u32vect_2d_length ___GLO(91,___G_c_23_u32vect_2d_length)
#define ___PRM_c_23_u32vect_2d_length ___PRM(91,___G_c_23_u32vect_2d_length)
#define ___GLO_c_23_u32vect_2d_ref ___GLO(92,___G_c_23_u32vect_2d_ref)
#define ___PRM_c_23_u32vect_2d_ref ___PRM(92,___G_c_23_u32vect_2d_ref)
#define ___GLO_c_23_u32vect_2d_set_21_ ___GLO(93,___G_c_23_u32vect_2d_set_21_)
#define ___PRM_c_23_u32vect_2d_set_21_ ___PRM(93,___G_c_23_u32vect_2d_set_21_)
#define ___GLO_c_23_u32vect_3f_ ___GLO(94,___G_c_23_u32vect_3f_)
#define ___PRM_c_23_u32vect_3f_ ___PRM(94,___G_c_23_u32vect_3f_)
#define ___GLO_c_23_u64vect_2d__3e_list ___GLO(95,___G_c_23_u64vect_2d__3e_list)
#define ___PRM_c_23_u64vect_2d__3e_list ___PRM(95,___G_c_23_u64vect_2d__3e_list)
#define ___GLO_c_23_u64vect_2d_length ___GLO(96,___G_c_23_u64vect_2d_length)
#define ___PRM_c_23_u64vect_2d_length ___PRM(96,___G_c_23_u64vect_2d_length)
#define ___GLO_c_23_u64vect_2d_ref ___GLO(97,___G_c_23_u64vect_2d_ref)
#define ___PRM_c_23_u64vect_2d_ref ___PRM(97,___G_c_23_u64vect_2d_ref)
#define ___GLO_c_23_u64vect_2d_set_21_ ___GLO(98,___G_c_23_u64vect_2d_set_21_)
#define ___PRM_c_23_u64vect_2d_set_21_ ___PRM(98,___G_c_23_u64vect_2d_set_21_)
#define ___GLO_c_23_u64vect_3f_ ___GLO(99,___G_c_23_u64vect_3f_)
#define ___PRM_c_23_u64vect_3f_ ___PRM(99,___G_c_23_u64vect_3f_)
#define ___GLO_c_23_u8vect_2d__3e_list ___GLO(100,___G_c_23_u8vect_2d__3e_list)
#define ___PRM_c_23_u8vect_2d__3e_list ___PRM(100,___G_c_23_u8vect_2d__3e_list)
#define ___GLO_c_23_u8vect_2d_length ___GLO(101,___G_c_23_u8vect_2d_length)
#define ___PRM_c_23_u8vect_2d_length ___PRM(101,___G_c_23_u8vect_2d_length)
#define ___GLO_c_23_u8vect_2d_ref ___GLO(102,___G_c_23_u8vect_2d_ref)
#define ___PRM_c_23_u8vect_2d_ref ___PRM(102,___G_c_23_u8vect_2d_ref)
#define ___GLO_c_23_u8vect_2d_set_21_ ___GLO(103,___G_c_23_u8vect_2d_set_21_)
#define ___PRM_c_23_u8vect_2d_set_21_ ___PRM(103,___G_c_23_u8vect_2d_set_21_)
#define ___GLO_c_23_u8vect_3f_ ___GLO(104,___G_c_23_u8vect_3f_)
#define ___PRM_c_23_u8vect_3f_ ___PRM(104,___G_c_23_u8vect_3f_)
#define ___GLO_c_23_unbound1_2d_object_3f_ ___GLO(105,___G_c_23_unbound1_2d_object_3f_)
#define ___PRM_c_23_unbound1_2d_object_3f_ ___PRM(105,___G_c_23_unbound1_2d_object_3f_)
#define ___GLO_c_23_unbound2_2d_object_3f_ ___GLO(106,___G_c_23_unbound2_2d_object_3f_)
#define ___PRM_c_23_unbound2_2d_object_3f_ ___PRM(106,___G_c_23_unbound2_2d_object_3f_)
#define ___GLO_c_23_unbox_2d_object ___GLO(107,___G_c_23_unbox_2d_object)
#define ___PRM_c_23_unbox_2d_object ___PRM(107,___G_c_23_unbox_2d_object)
#define ___GLO_c_23_unicode_2d__3e_character ___GLO(108,___G_c_23_unicode_2d__3e_character)
#define ___PRM_c_23_unicode_2d__3e_character ___PRM(108,___G_c_23_unicode_2d__3e_character)
#define ___GLO_c_23_unused_2d_object ___GLO(109,___G_c_23_unused_2d_object)
#define ___PRM_c_23_unused_2d_object ___PRM(109,___G_c_23_unused_2d_object)
#define ___GLO_c_23_unused_2d_object_3f_ ___GLO(110,___G_c_23_unused_2d_object_3f_)
#define ___PRM_c_23_unused_2d_object_3f_ ___PRM(110,___G_c_23_unused_2d_object_3f_)
#define ___GLO_c_23_vector_2d_object_3f_ ___GLO(111,___G_c_23_vector_2d_object_3f_)
#define ___PRM_c_23_vector_2d_object_3f_ ___PRM(111,___G_c_23_vector_2d_object_3f_)
#define ___GLO_c_23_void_2d_object ___GLO(112,___G_c_23_void_2d_object)
#define ___PRM_c_23_void_2d_object ___PRM(112,___G_c_23_void_2d_object)
#define ___GLO_c_23_void_2d_object_3f_ ___GLO(113,___G_c_23_void_2d_object_3f_)
#define ___PRM_c_23_void_2d_object_3f_ ___PRM(113,___G_c_23_void_2d_object_3f_)
#define ___GLO_c_23_write_2d_returning_2d_len ___GLO(114,___G_c_23_write_2d_returning_2d_len)
#define ___PRM_c_23_write_2d_returning_2d_len ___PRM(114,___G_c_23_write_2d_returning_2d_len)
#define ___GLO_c_23_write_2d_word ___GLO(115,___G_c_23_write_2d_word)
#define ___PRM_c_23_write_2d_word ___PRM(115,___G_c_23_write_2d_word)
#define ___GLO_open_2d_output_2d_file ___GLO(116,___G_open_2d_output_2d_file)
#define ___PRM_open_2d_output_2d_file ___PRM(116,___G_open_2d_output_2d_file)
#define ___GLO_symbol_2d_hash ___GLO(117,___G_symbol_2d_hash)
#define ___PRM_symbol_2d_hash ___PRM(117,___G_symbol_2d_hash)
#define ___GLO__23__23_f32vector_2d__3e_list ___GLO(118,___G__23__23_f32vector_2d__3e_list)
#define ___PRM__23__23_f32vector_2d__3e_list ___PRM(118,___G__23__23_f32vector_2d__3e_list)
#define ___GLO__23__23_f32vector_2d_length ___GLO(119,___G__23__23_f32vector_2d_length)
#define ___PRM__23__23_f32vector_2d_length ___PRM(119,___G__23__23_f32vector_2d_length)
#define ___GLO__23__23_f32vector_2d_ref ___GLO(120,___G__23__23_f32vector_2d_ref)
#define ___PRM__23__23_f32vector_2d_ref ___PRM(120,___G__23__23_f32vector_2d_ref)
#define ___GLO__23__23_f32vector_2d_set_21_ ___GLO(121,___G__23__23_f32vector_2d_set_21_)
#define ___PRM__23__23_f32vector_2d_set_21_ ___PRM(121,___G__23__23_f32vector_2d_set_21_)
#define ___GLO__23__23_f32vector_3f_ ___GLO(122,___G__23__23_f32vector_3f_)
#define ___PRM__23__23_f32vector_3f_ ___PRM(122,___G__23__23_f32vector_3f_)
#define ___GLO__23__23_f64vector_2d__3e_list ___GLO(123,___G__23__23_f64vector_2d__3e_list)
#define ___PRM__23__23_f64vector_2d__3e_list ___PRM(123,___G__23__23_f64vector_2d__3e_list)
#define ___GLO__23__23_f64vector_2d_length ___GLO(124,___G__23__23_f64vector_2d_length)
#define ___PRM__23__23_f64vector_2d_length ___PRM(124,___G__23__23_f64vector_2d_length)
#define ___GLO__23__23_f64vector_2d_ref ___GLO(125,___G__23__23_f64vector_2d_ref)
#define ___PRM__23__23_f64vector_2d_ref ___PRM(125,___G__23__23_f64vector_2d_ref)
#define ___GLO__23__23_f64vector_2d_set_21_ ___GLO(126,___G__23__23_f64vector_2d_set_21_)
#define ___PRM__23__23_f64vector_2d_set_21_ ___PRM(126,___G__23__23_f64vector_2d_set_21_)
#define ___GLO__23__23_f64vector_3f_ ___GLO(127,___G__23__23_f64vector_3f_)
#define ___PRM__23__23_f64vector_3f_ ___PRM(127,___G__23__23_f64vector_3f_)
#define ___GLO__23__23_flcopysign ___GLO(128,___G__23__23_flcopysign)
#define ___PRM__23__23_flcopysign ___PRM(128,___G__23__23_flcopysign)
#define ___GLO__23__23_format_2d_filepos ___GLO(129,___G__23__23_format_2d_filepos)
#define ___PRM__23__23_format_2d_filepos ___PRM(129,___G__23__23_format_2d_filepos)
#define ___GLO__23__23_keyword_2d__3e_string ___GLO(130,___G__23__23_keyword_2d__3e_string)
#define ___PRM__23__23_keyword_2d__3e_string ___PRM(130,___G__23__23_keyword_2d__3e_string)
#define ___GLO__23__23_make_2d_f32vector ___GLO(131,___G__23__23_make_2d_f32vector)
#define ___PRM__23__23_make_2d_f32vector ___PRM(131,___G__23__23_make_2d_f32vector)
#define ___GLO__23__23_make_2d_f64vector ___GLO(132,___G__23__23_make_2d_f64vector)
#define ___PRM__23__23_make_2d_f64vector ___PRM(132,___G__23__23_make_2d_f64vector)
#define ___GLO__23__23_make_2d_s16vector ___GLO(133,___G__23__23_make_2d_s16vector)
#define ___PRM__23__23_make_2d_s16vector ___PRM(133,___G__23__23_make_2d_s16vector)
#define ___GLO__23__23_make_2d_s32vector ___GLO(134,___G__23__23_make_2d_s32vector)
#define ___PRM__23__23_make_2d_s32vector ___PRM(134,___G__23__23_make_2d_s32vector)
#define ___GLO__23__23_make_2d_s64vector ___GLO(135,___G__23__23_make_2d_s64vector)
#define ___PRM__23__23_make_2d_s64vector ___PRM(135,___G__23__23_make_2d_s64vector)
#define ___GLO__23__23_make_2d_s8vector ___GLO(136,___G__23__23_make_2d_s8vector)
#define ___PRM__23__23_make_2d_s8vector ___PRM(136,___G__23__23_make_2d_s8vector)
#define ___GLO__23__23_make_2d_u16vector ___GLO(137,___G__23__23_make_2d_u16vector)
#define ___PRM__23__23_make_2d_u16vector ___PRM(137,___G__23__23_make_2d_u16vector)
#define ___GLO__23__23_make_2d_u32vector ___GLO(138,___G__23__23_make_2d_u32vector)
#define ___PRM__23__23_make_2d_u32vector ___PRM(138,___G__23__23_make_2d_u32vector)
#define ___GLO__23__23_make_2d_u64vector ___GLO(139,___G__23__23_make_2d_u64vector)
#define ___PRM__23__23_make_2d_u64vector ___PRM(139,___G__23__23_make_2d_u64vector)
#define ___GLO__23__23_make_2d_u8vector ___GLO(140,___G__23__23_make_2d_u8vector)
#define ___PRM__23__23_make_2d_u8vector ___PRM(140,___G__23__23_make_2d_u8vector)
#define ___GLO__23__23_max_2d_char ___GLO(141,___G__23__23_max_2d_char)
#define ___PRM__23__23_max_2d_char ___PRM(141,___G__23__23_max_2d_char)
#define ___GLO__23__23_open_2d_file_2d_generic ___GLO(142,___G__23__23_open_2d_file_2d_generic)
#define ___PRM__23__23_open_2d_file_2d_generic ___PRM(142,___G__23__23_open_2d_file_2d_generic)
#define ___GLO__23__23_open_2d_output_2d_file ___GLO(143,___G__23__23_open_2d_output_2d_file)
#define ___PRM__23__23_open_2d_output_2d_file ___PRM(143,___G__23__23_open_2d_output_2d_file)
#define ___GLO__23__23_s16vector_2d__3e_list ___GLO(144,___G__23__23_s16vector_2d__3e_list)
#define ___PRM__23__23_s16vector_2d__3e_list ___PRM(144,___G__23__23_s16vector_2d__3e_list)
#define ___GLO__23__23_s16vector_2d_length ___GLO(145,___G__23__23_s16vector_2d_length)
#define ___PRM__23__23_s16vector_2d_length ___PRM(145,___G__23__23_s16vector_2d_length)
#define ___GLO__23__23_s16vector_2d_ref ___GLO(146,___G__23__23_s16vector_2d_ref)
#define ___PRM__23__23_s16vector_2d_ref ___PRM(146,___G__23__23_s16vector_2d_ref)
#define ___GLO__23__23_s16vector_2d_set_21_ ___GLO(147,___G__23__23_s16vector_2d_set_21_)
#define ___PRM__23__23_s16vector_2d_set_21_ ___PRM(147,___G__23__23_s16vector_2d_set_21_)
#define ___GLO__23__23_s16vector_3f_ ___GLO(148,___G__23__23_s16vector_3f_)
#define ___PRM__23__23_s16vector_3f_ ___PRM(148,___G__23__23_s16vector_3f_)
#define ___GLO__23__23_s32vector_2d__3e_list ___GLO(149,___G__23__23_s32vector_2d__3e_list)
#define ___PRM__23__23_s32vector_2d__3e_list ___PRM(149,___G__23__23_s32vector_2d__3e_list)
#define ___GLO__23__23_s32vector_2d_length ___GLO(150,___G__23__23_s32vector_2d_length)
#define ___PRM__23__23_s32vector_2d_length ___PRM(150,___G__23__23_s32vector_2d_length)
#define ___GLO__23__23_s32vector_2d_ref ___GLO(151,___G__23__23_s32vector_2d_ref)
#define ___PRM__23__23_s32vector_2d_ref ___PRM(151,___G__23__23_s32vector_2d_ref)
#define ___GLO__23__23_s32vector_2d_set_21_ ___GLO(152,___G__23__23_s32vector_2d_set_21_)
#define ___PRM__23__23_s32vector_2d_set_21_ ___PRM(152,___G__23__23_s32vector_2d_set_21_)
#define ___GLO__23__23_s32vector_3f_ ___GLO(153,___G__23__23_s32vector_3f_)
#define ___PRM__23__23_s32vector_3f_ ___PRM(153,___G__23__23_s32vector_3f_)
#define ___GLO__23__23_s64vector_2d__3e_list ___GLO(154,___G__23__23_s64vector_2d__3e_list)
#define ___PRM__23__23_s64vector_2d__3e_list ___PRM(154,___G__23__23_s64vector_2d__3e_list)
#define ___GLO__23__23_s64vector_2d_length ___GLO(155,___G__23__23_s64vector_2d_length)
#define ___PRM__23__23_s64vector_2d_length ___PRM(155,___G__23__23_s64vector_2d_length)
#define ___GLO__23__23_s64vector_2d_ref ___GLO(156,___G__23__23_s64vector_2d_ref)
#define ___PRM__23__23_s64vector_2d_ref ___PRM(156,___G__23__23_s64vector_2d_ref)
#define ___GLO__23__23_s64vector_2d_set_21_ ___GLO(157,___G__23__23_s64vector_2d_set_21_)
#define ___PRM__23__23_s64vector_2d_set_21_ ___PRM(157,___G__23__23_s64vector_2d_set_21_)
#define ___GLO__23__23_s64vector_3f_ ___GLO(158,___G__23__23_s64vector_3f_)
#define ___PRM__23__23_s64vector_3f_ ___PRM(158,___G__23__23_s64vector_3f_)
#define ___GLO__23__23_s8vector_2d__3e_list ___GLO(159,___G__23__23_s8vector_2d__3e_list)
#define ___PRM__23__23_s8vector_2d__3e_list ___PRM(159,___G__23__23_s8vector_2d__3e_list)
#define ___GLO__23__23_s8vector_2d_length ___GLO(160,___G__23__23_s8vector_2d_length)
#define ___PRM__23__23_s8vector_2d_length ___PRM(160,___G__23__23_s8vector_2d_length)
#define ___GLO__23__23_s8vector_2d_ref ___GLO(161,___G__23__23_s8vector_2d_ref)
#define ___PRM__23__23_s8vector_2d_ref ___PRM(161,___G__23__23_s8vector_2d_ref)
#define ___GLO__23__23_s8vector_2d_set_21_ ___GLO(162,___G__23__23_s8vector_2d_set_21_)
#define ___PRM__23__23_s8vector_2d_set_21_ ___PRM(162,___G__23__23_s8vector_2d_set_21_)
#define ___GLO__23__23_s8vector_3f_ ___GLO(163,___G__23__23_s8vector_3f_)
#define ___PRM__23__23_s8vector_3f_ ___PRM(163,___G__23__23_s8vector_3f_)
#define ___GLO__23__23_scheme_2d_file_2d_extensions ___GLO(164,___G__23__23_scheme_2d_file_2d_extensions)
#define ___PRM__23__23_scheme_2d_file_2d_extensions ___PRM(164,___G__23__23_scheme_2d_file_2d_extensions)
#define ___GLO__23__23_string_2d__3e_keyword ___GLO(165,___G__23__23_string_2d__3e_keyword)
#define ___PRM__23__23_string_2d__3e_keyword ___PRM(165,___G__23__23_string_2d__3e_keyword)
#define ___GLO__23__23_u16vector_2d__3e_list ___GLO(166,___G__23__23_u16vector_2d__3e_list)
#define ___PRM__23__23_u16vector_2d__3e_list ___PRM(166,___G__23__23_u16vector_2d__3e_list)
#define ___GLO__23__23_u16vector_2d_length ___GLO(167,___G__23__23_u16vector_2d_length)
#define ___PRM__23__23_u16vector_2d_length ___PRM(167,___G__23__23_u16vector_2d_length)
#define ___GLO__23__23_u16vector_2d_ref ___GLO(168,___G__23__23_u16vector_2d_ref)
#define ___PRM__23__23_u16vector_2d_ref ___PRM(168,___G__23__23_u16vector_2d_ref)
#define ___GLO__23__23_u16vector_2d_set_21_ ___GLO(169,___G__23__23_u16vector_2d_set_21_)
#define ___PRM__23__23_u16vector_2d_set_21_ ___PRM(169,___G__23__23_u16vector_2d_set_21_)
#define ___GLO__23__23_u16vector_3f_ ___GLO(170,___G__23__23_u16vector_3f_)
#define ___PRM__23__23_u16vector_3f_ ___PRM(170,___G__23__23_u16vector_3f_)
#define ___GLO__23__23_u32vector_2d__3e_list ___GLO(171,___G__23__23_u32vector_2d__3e_list)
#define ___PRM__23__23_u32vector_2d__3e_list ___PRM(171,___G__23__23_u32vector_2d__3e_list)
#define ___GLO__23__23_u32vector_2d_length ___GLO(172,___G__23__23_u32vector_2d_length)
#define ___PRM__23__23_u32vector_2d_length ___PRM(172,___G__23__23_u32vector_2d_length)
#define ___GLO__23__23_u32vector_2d_ref ___GLO(173,___G__23__23_u32vector_2d_ref)
#define ___PRM__23__23_u32vector_2d_ref ___PRM(173,___G__23__23_u32vector_2d_ref)
#define ___GLO__23__23_u32vector_2d_set_21_ ___GLO(174,___G__23__23_u32vector_2d_set_21_)
#define ___PRM__23__23_u32vector_2d_set_21_ ___PRM(174,___G__23__23_u32vector_2d_set_21_)
#define ___GLO__23__23_u32vector_3f_ ___GLO(175,___G__23__23_u32vector_3f_)
#define ___PRM__23__23_u32vector_3f_ ___PRM(175,___G__23__23_u32vector_3f_)
#define ___GLO__23__23_u64vector_2d__3e_list ___GLO(176,___G__23__23_u64vector_2d__3e_list)
#define ___PRM__23__23_u64vector_2d__3e_list ___PRM(176,___G__23__23_u64vector_2d__3e_list)
#define ___GLO__23__23_u64vector_2d_length ___GLO(177,___G__23__23_u64vector_2d_length)
#define ___PRM__23__23_u64vector_2d_length ___PRM(177,___G__23__23_u64vector_2d_length)
#define ___GLO__23__23_u64vector_2d_ref ___GLO(178,___G__23__23_u64vector_2d_ref)
#define ___PRM__23__23_u64vector_2d_ref ___PRM(178,___G__23__23_u64vector_2d_ref)
#define ___GLO__23__23_u64vector_2d_set_21_ ___GLO(179,___G__23__23_u64vector_2d_set_21_)
#define ___PRM__23__23_u64vector_2d_set_21_ ___PRM(179,___G__23__23_u64vector_2d_set_21_)
#define ___GLO__23__23_u64vector_3f_ ___GLO(180,___G__23__23_u64vector_3f_)
#define ___PRM__23__23_u64vector_3f_ ___PRM(180,___G__23__23_u64vector_3f_)
#define ___GLO__23__23_u8vector_2d__3e_list ___GLO(181,___G__23__23_u8vector_2d__3e_list)
#define ___PRM__23__23_u8vector_2d__3e_list ___PRM(181,___G__23__23_u8vector_2d__3e_list)
#define ___GLO__23__23_u8vector_2d_length ___GLO(182,___G__23__23_u8vector_2d_length)
#define ___PRM__23__23_u8vector_2d_length ___PRM(182,___G__23__23_u8vector_2d_length)
#define ___GLO__23__23_u8vector_2d_ref ___GLO(183,___G__23__23_u8vector_2d_ref)
#define ___PRM__23__23_u8vector_2d_ref ___PRM(183,___G__23__23_u8vector_2d_ref)
#define ___GLO__23__23_u8vector_2d_set_21_ ___GLO(184,___G__23__23_u8vector_2d_set_21_)
#define ___PRM__23__23_u8vector_2d_set_21_ ___PRM(184,___G__23__23_u8vector_2d_set_21_)
#define ___GLO__23__23_u8vector_3f_ ___GLO(185,___G__23__23_u8vector_3f_)
#define ___PRM__23__23_u8vector_3f_ ___PRM(185,___G__23__23_u8vector_3f_)
#define ___GLO__23__23_vector_2d__3e_list ___GLO(186,___G__23__23_vector_2d__3e_list)
#define ___PRM__23__23_vector_2d__3e_list ___PRM(186,___G__23__23_vector_2d__3e_list)
#define ___GLO__3c_ ___GLO(187,___G__3c_)
#define ___PRM__3c_ ___PRM(187,___G__3c_)
#define ___GLO__3c__3d_ ___GLO(188,___G__3c__3d_)
#define ___PRM__3c__3d_ ___PRM(188,___G__3c__3d_)
#define ___GLO_display ___GLO(189,___G_display)
#define ___PRM_display ___PRM(189,___G_display)
#define ___GLO_error ___GLO(190,___G_error)
#define ___PRM_error ___PRM(190,___G_error)
#define ___GLO_eval ___GLO(191,___G_eval)
#define ___PRM_eval ___PRM(191,___G_eval)
#define ___GLO_input_2d_port_3f_ ___GLO(192,___G_input_2d_port_3f_)
#define ___PRM_input_2d_port_3f_ ___PRM(192,___G_input_2d_port_3f_)
#define ___GLO_open_2d_input_2d_file ___GLO(193,___G_open_2d_input_2d_file)
#define ___PRM_open_2d_input_2d_file ___PRM(193,___G_open_2d_input_2d_file)
#define ___GLO_pp ___GLO(194,___G_pp)
#define ___PRM_pp ___PRM(194,___G_pp)
#define ___GLO_with_2d_output_2d_to_2d_string ___GLO(195,___G_with_2d_output_2d_to_2d_string)
#define ___PRM_with_2d_output_2d_to_2d_string ___PRM(195,___G_with_2d_output_2d_to_2d_string)
#define ___GLO_write ___GLO(196,___G_write)
#define ___PRM_write ___PRM(196,___G_write)
#define ___GLO_write_2d_char ___GLO(197,___G_write_2d_char)
#define ___PRM_write_2d_char ___PRM(197,___G_write_2d_char)

___DEF_SUB_FLO(___X0,0x0L,0x0L)
___DEF_SUB_VEC(___X1,5)
               ___VEC1(___REF_SYM(0,___S___host))
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
#define ___MD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4 ___D_F64(___F64V1) ___D_F64( \
___F64V2)
#undef ___MR_ALL
#define ___MR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20___host)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_string_2d__3e_keyword_2d_object)
___DEF_M_HLBL(___L1_c_23_string_2d__3e_keyword_2d_object)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_keyword_2d_object_2d__3e_string)
___DEF_M_HLBL(___L1_c_23_keyword_2d_object_2d__3e_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_keyword_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_false_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_absent_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unused_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_deleted_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_void_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unbound1_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unbound2_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_end_2d_of_2d_file_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_optional_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_key_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_rest_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_symbol_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_box_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_box_2d_object)
___DEF_M_HLBL(___L1_c_23_box_2d_object)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unbox_2d_object)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_set_2d_box_2d_object_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_structure_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_structure_2d__3e_list)
___DEF_M_HLBL(___L1_c_23_structure_2d__3e_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL(___L1_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL(___L2_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL(___L3_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL(___L4_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL(___L5_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL(___L6_c_23_open_2d_input_2d_file_2a_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_pp_2d_expression)
___DEF_M_HLBL(___L1_c_23_pp_2d_expression)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L1_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L2_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L3_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L4_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L5_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L6_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL(___L7_c_23_write_2d_returning_2d_len)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L1_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L2_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L3_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L4_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L5_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L6_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL(___L7_c_23_display_2d_returning_2d_len)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_write_2d_word)
___DEF_M_HLBL(___L1_c_23_write_2d_word)
___DEF_M_HLBL(___L2_c_23_write_2d_word)
___DEF_M_HLBL(___L3_c_23_write_2d_word)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_character_2d__3e_unicode)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_unicode_2d__3e_character)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_in_2d_char_2d_range_3f_)
___DEF_M_HLBL(___L1_c_23_in_2d_char_2d_range_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL(___L1_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL(___L2_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL(___L3_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL(___L4_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL(___L5_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL(___L6_c_23_in_2d_integer_2d_range_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_fatal_2d_err)
___DEF_M_HLBL(___L1_c_23_fatal_2d_err)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_scheme_2d_global_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_M_HLBL(___L1_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_M_HLBL(___L2_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_M_HLBL(___L3_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_scheme_2d_global_2d_var_2d_define_21_)
___DEF_M_HLBL(___L1_c_23_scheme_2d_global_2d_var_2d_define_21_)
___DEF_M_HLBL(___L2_c_23_scheme_2d_global_2d_var_2d_define_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_scheme_2d_global_2d_eval)
___DEF_M_HLBL(___L1_c_23_scheme_2d_global_2d_eval)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_format_2d_filepos)
___DEF_M_HLBL(___L1_c_23_format_2d_filepos)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_s8vect)
___DEF_M_HLBL(___L1_c_23_make_2d_s8vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_u8vect)
___DEF_M_HLBL(___L1_c_23_make_2d_u8vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_s16vect)
___DEF_M_HLBL(___L1_c_23_make_2d_s16vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_u16vect)
___DEF_M_HLBL(___L1_c_23_make_2d_u16vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_s32vect)
___DEF_M_HLBL(___L1_c_23_make_2d_s32vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_u32vect)
___DEF_M_HLBL(___L1_c_23_make_2d_u32vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_s64vect)
___DEF_M_HLBL(___L1_c_23_make_2d_s64vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_u64vect)
___DEF_M_HLBL(___L1_c_23_make_2d_u64vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_f32vect)
___DEF_M_HLBL(___L1_c_23_make_2d_f32vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_f64vect)
___DEF_M_HLBL(___L1_c_23_make_2d_f64vect)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_vector_2d_object_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_subtype_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_max_2d_lines)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_subtype_2d_structure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_symbol_2d_hash)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___host
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
___DEF_P_HLBL(___L0__20___host)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___host)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___host)
   ___SET_GLO(24,___G_c_23_false_2d_object,___FAL)
   ___SET_GLO(4,___G_c_23_absent_2d_object,___ABSENT)
   ___SET_GLO(109,___G_c_23_unused_2d_object,___UNUSED)
   ___SET_GLO(9,___G_c_23_deleted_2d_object,___DELETED)
   ___SET_GLO(112,___G_c_23_void_2d_object,___VOID)
   ___SET_GLO(12,___G_c_23_end_2d_of_2d_file_2d_object,___EOF)
   ___SET_GLO(48,___G_c_23_optional_2d_object,___OPTIONAL)
   ___SET_GLO(31,___G_c_23_key_2d_object,___KEYOBJ)
   ___SET_GLO(52,___G_c_23_rest_2d_object,___REST)
   ___SET_GLO(116,___G_open_2d_output_2d_file,___GLO__23__23_open_2d_output_2d_file)
   ___SET_GLO(74,___G_c_23_scheme_2d_file_2d_extensions,___GLO__23__23_scheme_2d_file_2d_extensions)
   ___SET_GLO(73,___G_c_23_s8vect_3f_,___PRM__23__23_s8vector_3f_)
   ___SET_GLO(69,___G_c_23_s8vect_2d__3e_list,___GLO__23__23_s8vector_2d__3e_list)
   ___SET_GLO(70,___G_c_23_s8vect_2d_length,___PRM__23__23_s8vector_2d_length)
   ___SET_GLO(71,___G_c_23_s8vect_2d_ref,___PRM__23__23_s8vector_2d_ref)
   ___SET_GLO(72,___G_c_23_s8vect_2d_set_21_,___PRM__23__23_s8vector_2d_set_21_)
   ___SET_GLO(104,___G_c_23_u8vect_3f_,___PRM__23__23_u8vector_3f_)
   ___SET_GLO(100,___G_c_23_u8vect_2d__3e_list,___GLO__23__23_u8vector_2d__3e_list)
   ___SET_GLO(101,___G_c_23_u8vect_2d_length,___PRM__23__23_u8vector_2d_length)
   ___SET_GLO(102,___G_c_23_u8vect_2d_ref,___PRM__23__23_u8vector_2d_ref)
   ___SET_GLO(103,___G_c_23_u8vect_2d_set_21_,___PRM__23__23_u8vector_2d_set_21_)
   ___SET_GLO(58,___G_c_23_s16vect_3f_,___PRM__23__23_s16vector_3f_)
   ___SET_GLO(54,___G_c_23_s16vect_2d__3e_list,___GLO__23__23_s16vector_2d__3e_list)
   ___SET_GLO(55,___G_c_23_s16vect_2d_length,___PRM__23__23_s16vector_2d_length)
   ___SET_GLO(56,___G_c_23_s16vect_2d_ref,___PRM__23__23_s16vector_2d_ref)
   ___SET_GLO(57,___G_c_23_s16vect_2d_set_21_,___PRM__23__23_s16vector_2d_set_21_)
   ___SET_GLO(89,___G_c_23_u16vect_3f_,___PRM__23__23_u16vector_3f_)
   ___SET_GLO(85,___G_c_23_u16vect_2d__3e_list,___GLO__23__23_u16vector_2d__3e_list)
   ___SET_GLO(86,___G_c_23_u16vect_2d_length,___PRM__23__23_u16vector_2d_length)
   ___SET_GLO(87,___G_c_23_u16vect_2d_ref,___PRM__23__23_u16vector_2d_ref)
   ___SET_GLO(88,___G_c_23_u16vect_2d_set_21_,___PRM__23__23_u16vector_2d_set_21_)
   ___SET_GLO(63,___G_c_23_s32vect_3f_,___PRM__23__23_s32vector_3f_)
   ___SET_GLO(59,___G_c_23_s32vect_2d__3e_list,___GLO__23__23_s32vector_2d__3e_list)
   ___SET_GLO(60,___G_c_23_s32vect_2d_length,___PRM__23__23_s32vector_2d_length)
   ___SET_GLO(61,___G_c_23_s32vect_2d_ref,___PRM__23__23_s32vector_2d_ref)
   ___SET_GLO(62,___G_c_23_s32vect_2d_set_21_,___PRM__23__23_s32vector_2d_set_21_)
   ___SET_GLO(94,___G_c_23_u32vect_3f_,___PRM__23__23_u32vector_3f_)
   ___SET_GLO(90,___G_c_23_u32vect_2d__3e_list,___GLO__23__23_u32vector_2d__3e_list)
   ___SET_GLO(91,___G_c_23_u32vect_2d_length,___PRM__23__23_u32vector_2d_length)
   ___SET_GLO(92,___G_c_23_u32vect_2d_ref,___PRM__23__23_u32vector_2d_ref)
   ___SET_GLO(93,___G_c_23_u32vect_2d_set_21_,___PRM__23__23_u32vector_2d_set_21_)
   ___SET_GLO(68,___G_c_23_s64vect_3f_,___PRM__23__23_s64vector_3f_)
   ___SET_GLO(64,___G_c_23_s64vect_2d__3e_list,___GLO__23__23_s64vector_2d__3e_list)
   ___SET_GLO(65,___G_c_23_s64vect_2d_length,___PRM__23__23_s64vector_2d_length)
   ___SET_GLO(66,___G_c_23_s64vect_2d_ref,___PRM__23__23_s64vector_2d_ref)
   ___SET_GLO(67,___G_c_23_s64vect_2d_set_21_,___PRM__23__23_s64vector_2d_set_21_)
   ___SET_GLO(99,___G_c_23_u64vect_3f_,___PRM__23__23_u64vector_3f_)
   ___SET_GLO(95,___G_c_23_u64vect_2d__3e_list,___GLO__23__23_u64vector_2d__3e_list)
   ___SET_GLO(96,___G_c_23_u64vect_2d_length,___PRM__23__23_u64vector_2d_length)
   ___SET_GLO(97,___G_c_23_u64vect_2d_ref,___PRM__23__23_u64vector_2d_ref)
   ___SET_GLO(98,___G_c_23_u64vect_2d_set_21_,___PRM__23__23_u64vector_2d_set_21_)
   ___SET_GLO(18,___G_c_23_f32vect_3f_,___PRM__23__23_f32vector_3f_)
   ___SET_GLO(14,___G_c_23_f32vect_2d__3e_list,___GLO__23__23_f32vector_2d__3e_list)
   ___SET_GLO(15,___G_c_23_f32vect_2d_length,___PRM__23__23_f32vector_2d_length)
   ___SET_GLO(16,___G_c_23_f32vect_2d_ref,___PRM__23__23_f32vector_2d_ref)
   ___SET_GLO(17,___G_c_23_f32vect_2d_set_21_,___PRM__23__23_f32vector_2d_set_21_)
   ___SET_GLO(23,___G_c_23_f64vect_3f_,___PRM__23__23_f64vector_3f_)
   ___SET_GLO(19,___G_c_23_f64vect_2d__3e_list,___GLO__23__23_f64vector_2d__3e_list)
   ___SET_GLO(20,___G_c_23_f64vect_2d_length,___PRM__23__23_f64vector_2d_length)
   ___SET_GLO(21,___G_c_23_f64vect_2d_ref,___PRM__23__23_f64vector_2d_ref)
   ___SET_GLO(22,___G_c_23_f64vect_2d_set_21_,___PRM__23__23_f64vector_2d_set_21_)
   ___SET_GLO(27,___G_c_23_float_2d_copysign,___PRM__23__23_flcopysign)
   ___SET_GLO(2,___G_c_23__2a__2a_main_2d_readtable,___FAL)
   ___SET_GLO(51,___G_c_23_read_2d_datum_2d_or_2d_eof,___FAL)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_string_2d__3e_keyword_2d_object
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_string_2d__3e_keyword_2d_object)
___DEF_P_HLBL(___L1_c_23_string_2d__3e_keyword_2d_object)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_string_2d__3e_keyword_2d_object)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_string_2d__3e_keyword_2d_object)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_string_2d__3e_keyword_2d_object)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_string_2d__3e_keyword)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_keyword_2d_object_2d__3e_string
#undef ___PH_LBL0
#define ___PH_LBL0 6
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_keyword_2d_object_2d__3e_string)
___DEF_P_HLBL(___L1_c_23_keyword_2d_object_2d__3e_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_keyword_2d_object_2d__3e_string)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_keyword_2d_object_2d__3e_string)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_keyword_2d_object_2d__3e_string)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_keyword_2d__3e_string)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_keyword_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 9
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_keyword_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_keyword_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_keyword_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___KEYWORDP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_false_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 11
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_false_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_false_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_false_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___FAL)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_absent_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 13
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_absent_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_absent_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_absent_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___ABSENT)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unused_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 15
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unused_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unused_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unused_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___UNUSED)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_deleted_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 17
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_deleted_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_deleted_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_deleted_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___DELETED)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_void_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 19
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_void_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_void_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_void_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___VOID)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unbound1_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 21
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unbound1_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unbound1_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unbound1_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___UNB1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unbound2_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 23
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unbound2_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unbound2_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unbound2_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___UNB2)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_end_2d_of_2d_file_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 25
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_end_2d_of_2d_file_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_end_2d_of_2d_file_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_end_2d_of_2d_file_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___EOF)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_optional_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 27
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_optional_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_optional_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_optional_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___OPTIONAL)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_key_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 29
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_key_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_key_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_key_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___KEYOBJ)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_rest_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 31
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_rest_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_rest_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_rest_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___EQP(___R1,___REST)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_symbol_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 33
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_symbol_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_symbol_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_symbol_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___SYMBOLP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_box_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 35
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_box_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_box_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_box_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___BOXP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_box_2d_object
#undef ___PH_LBL0
#define ___PH_LBL0 37
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_box_2d_object)
___DEF_P_HLBL(___L1_c_23_box_2d_object)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_box_2d_object)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_box_2d_object)
   ___SET_R1(___BOX(___R1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_box_2d_object)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unbox_2d_object
#undef ___PH_LBL0
#define ___PH_LBL0 40
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unbox_2d_object)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unbox_2d_object)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unbox_2d_object)
   ___SET_R1(___UNBOX(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_set_2d_box_2d_object_21_
#undef ___PH_LBL0
#define ___PH_LBL0 42
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_set_2d_box_2d_object_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_set_2d_box_2d_object_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_set_2d_box_2d_object_21_)
   ___SETBOX(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_structure_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 44
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_structure_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_structure_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_structure_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_structure_2d__3e_list
#undef ___PH_LBL0
#define ___PH_LBL0 46
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_structure_2d__3e_list)
___DEF_P_HLBL(___L1_c_23_structure_2d__3e_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_structure_2d__3e_list)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_structure_2d__3e_list)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_structure_2d__3e_list)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),186,___G__23__23_vector_2d__3e_list)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_open_2d_input_2d_file_2a_
#undef ___PH_LBL0
#define ___PH_LBL0 49
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_open_2d_input_2d_file_2a_)
___DEF_P_HLBL(___L1_c_23_open_2d_input_2d_file_2a_)
___DEF_P_HLBL(___L2_c_23_open_2d_input_2d_file_2a_)
___DEF_P_HLBL(___L3_c_23_open_2d_input_2d_file_2a_)
___DEF_P_HLBL(___L4_c_23_open_2d_input_2d_file_2a_)
___DEF_P_HLBL(___L5_c_23_open_2d_input_2d_file_2a_)
___DEF_P_HLBL(___L6_c_23_open_2d_input_2d_file_2a_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_open_2d_input_2d_file_2a_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_open_2d_input_2d_file_2a_)
   ___SET_STK(1,___FIX(1L))
   ___SET_STK(2,___FAL)
   ___SET_STK(3,___R1)
   ___SET_R1(___LBL(2))
   ___SET_R3(___STK(3))
   ___SET_R2(___PRM_open_2d_input_2d_file)
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_open_2d_input_2d_file_2a_)
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),142,___G__23__23_open_2d_file_2d_generic)
___DEF_SLBL(2,___L2_c_23_open_2d_input_2d_file_2a_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(2,1,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_open_2d_input_2d_file_2a_)
   ___JUMPPRM(___SET_NARGS(1),___PRM_input_2d_port_3f_)
___DEF_SLBL(4,___L4_c_23_open_2d_input_2d_file_2a_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L7_c_23_open_2d_input_2d_file_2a_)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_open_2d_input_2d_file_2a_)
   ___GOTO(___L8_c_23_open_2d_input_2d_file_2a_)
___DEF_GLBL(___L7_c_23_open_2d_input_2d_file_2a_)
   ___SET_R1(___STK(-6))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_open_2d_input_2d_file_2a_)
___DEF_GLBL(___L8_c_23_open_2d_input_2d_file_2a_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_pp_2d_expression
#undef ___PH_LBL0
#define ___PH_LBL0 57
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_pp_2d_expression)
___DEF_P_HLBL(___L1_c_23_pp_2d_expression)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_pp_2d_expression)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_pp_2d_expression)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_pp_2d_expression)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),194,___G_pp)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_write_2d_returning_2d_len
#undef ___PH_LBL0
#define ___PH_LBL0 60
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L1_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L2_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L3_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L4_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L5_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L6_c_23_write_2d_returning_2d_len)
___DEF_P_HLBL(___L7_c_23_write_2d_returning_2d_len)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_write_2d_returning_2d_len)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_write_2d_returning_2d_len)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(3),6)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(3))
   ___SET_R1(___NUL)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_write_2d_returning_2d_len)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_write_2d_returning_2d_len)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),195,___G_with_2d_output_2d_to_2d_string)
___DEF_SLBL(3,___L3_c_23_write_2d_returning_2d_len)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(4,___L4_c_23_write_2d_returning_2d_len)
   ___SET_R1(___STRINGLENGTH(___STK(-5)))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_write_2d_returning_2d_len)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(6,___L6_c_23_write_2d_returning_2d_len)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(6,0,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_write_2d_returning_2d_len)
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_display_2d_returning_2d_len
#undef ___PH_LBL0
#define ___PH_LBL0 69
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L1_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L2_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L3_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L4_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L5_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L6_c_23_display_2d_returning_2d_len)
___DEF_P_HLBL(___L7_c_23_display_2d_returning_2d_len)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_display_2d_returning_2d_len)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_display_2d_returning_2d_len)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(3),6)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_R2(___STK(3))
   ___SET_R1(___NUL)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_display_2d_returning_2d_len)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_display_2d_returning_2d_len)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),195,___G_with_2d_output_2d_to_2d_string)
___DEF_SLBL(3,___L3_c_23_display_2d_returning_2d_len)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(4,___L4_c_23_display_2d_returning_2d_len)
   ___SET_R1(___STRINGLENGTH(___STK(-5)))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_display_2d_returning_2d_len)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(6,___L6_c_23_display_2d_returning_2d_len)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(6,0,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_display_2d_returning_2d_len)
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_write_2d_word
#undef ___PH_LBL0
#define ___PH_LBL0 78
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_write_2d_word)
___DEF_P_HLBL(___L1_c_23_write_2d_word)
___DEF_P_HLBL(___L2_c_23_write_2d_word)
___DEF_P_HLBL(___L3_c_23_write_2d_word)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_write_2d_word)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_write_2d_word)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___FIXQUO(___R1,___FIX(256L)))
   ___SET_R1(___FIXTOCHR(___R1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_write_2d_word)
   ___JUMPPRM(___SET_NARGS(2),___PRM_write_2d_char)
___DEF_SLBL(2,___L2_c_23_write_2d_word)
   ___SET_R2(___STK(-5))
   ___SET_R1(___FIXMOD(___STK(-6),___FIX(256L)))
   ___SET_R1(___FIXTOCHR(___R1))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_write_2d_word)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_write_2d_char)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_character_2d__3e_unicode
#undef ___PH_LBL0
#define ___PH_LBL0 83
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_character_2d__3e_unicode)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_character_2d__3e_unicode)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_character_2d__3e_unicode)
   ___SET_R1(___FIXFROMCHR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_unicode_2d__3e_character
#undef ___PH_LBL0
#define ___PH_LBL0 85
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_unicode_2d__3e_character)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_unicode_2d__3e_character)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_unicode_2d__3e_character)
   ___SET_R1(___FIXTOCHR(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_in_2d_char_2d_range_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 87
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_F64(___F64V1) ___D_F64(___F64V2)
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_in_2d_char_2d_range_3f_)
___DEF_P_HLBL(___L1_c_23_in_2d_char_2d_range_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_in_2d_char_2d_range_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_in_2d_char_2d_range_3f_)
   ___SET_STK(1,___GLO__23__23_max_2d_char)
   ___ADJFP(1)
   ___IF(___NOT(___FIXNUMP(___STK(0))))
   ___GOTO(___L2_c_23_in_2d_char_2d_range_3f_)
   ___END_IF
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L5_c_23_in_2d_char_2d_range_3f_)
   ___END_IF
___DEF_GLBL(___L2_c_23_in_2d_char_2d_range_3f_)
   ___IF(___NOT(___FLONUMP(___STK(0))))
   ___GOTO(___L3_c_23_in_2d_char_2d_range_3f_)
   ___END_IF
   ___IF(___FLONUMP(___R1))
   ___GOTO(___L4_c_23_in_2d_char_2d_range_3f_)
   ___END_IF
___DEF_GLBL(___L3_c_23_in_2d_char_2d_range_3f_)
   ___SET_R2(___STK(0))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_in_2d_char_2d_range_3f_)
   ___ADJFP(-1)
   ___JUMPPRM(___SET_NARGS(2),___PRM__3c__3d_)
___DEF_GLBL(___L4_c_23_in_2d_char_2d_range_3f_)
   ___SET_F64(___F64V1,___F64UNBOX(___R1))
   ___SET_F64(___F64V2,___F64UNBOX(___STK(0)))
   ___SET_R1(___BOOLEAN(___F64LE(___F64V1,___F64V2)))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5_c_23_in_2d_char_2d_range_3f_)
   ___SET_R1(___BOOLEAN(___FIXLE(___R1,___STK(0))))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_in_2d_integer_2d_range_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 90
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_F64(___F64V1) ___D_F64(___F64V2)
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_in_2d_integer_2d_range_3f_)
___DEF_P_HLBL(___L1_c_23_in_2d_integer_2d_range_3f_)
___DEF_P_HLBL(___L2_c_23_in_2d_integer_2d_range_3f_)
___DEF_P_HLBL(___L3_c_23_in_2d_integer_2d_range_3f_)
___DEF_P_HLBL(___L4_c_23_in_2d_integer_2d_range_3f_)
___DEF_P_HLBL(___L5_c_23_in_2d_integer_2d_range_3f_)
___DEF_P_HLBL(___L6_c_23_in_2d_integer_2d_range_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_in_2d_integer_2d_range_3f_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_in_2d_integer_2d_range_3f_)
   ___IF(___NOT(___FIXNUMP(___R2)))
   ___GOTO(___L10_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L10_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___IF(___FIXLT(___R1,___R2))
   ___GOTO(___L7_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___GOTO(___L11_c_23_in_2d_integer_2d_range_3f_)
___DEF_SLBL(1,___L1_c_23_in_2d_integer_2d_range_3f_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L9_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L7_c_23_in_2d_integer_2d_range_3f_)
   ___SET_R1(___FAL)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_in_2d_integer_2d_range_3f_)
___DEF_GLBL(___L8_c_23_in_2d_integer_2d_range_3f_)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L9_c_23_in_2d_integer_2d_range_3f_)
   ___SET_R3(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L12_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___GOTO(___L14_c_23_in_2d_integer_2d_range_3f_)
___DEF_GLBL(___L10_c_23_in_2d_integer_2d_range_3f_)
   ___IF(___NOT(___FLONUMP(___R2)))
   ___GOTO(___L16_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___IF(___NOT(___FLONUMP(___R1)))
   ___GOTO(___L16_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___SET_F64(___F64V1,___F64UNBOX(___R1))
   ___SET_F64(___F64V2,___F64UNBOX(___R2))
   ___IF(___F64LT(___F64V1,___F64V2))
   ___GOTO(___L7_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
___DEF_GLBL(___L11_c_23_in_2d_integer_2d_range_3f_)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L14_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
___DEF_GLBL(___L12_c_23_in_2d_integer_2d_range_3f_)
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L14_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___SET_R1(___BOOLEAN(___FIXLT(___R3,___R1)))
___DEF_GLBL(___L13_c_23_in_2d_integer_2d_range_3f_)
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_in_2d_integer_2d_range_3f_)
   ___GOTO(___L8_c_23_in_2d_integer_2d_range_3f_)
___DEF_GLBL(___L14_c_23_in_2d_integer_2d_range_3f_)
   ___IF(___NOT(___FLONUMP(___R1)))
   ___GOTO(___L15_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___IF(___NOT(___FLONUMP(___R3)))
   ___GOTO(___L15_c_23_in_2d_integer_2d_range_3f_)
   ___END_IF
   ___SET_F64(___F64V1,___F64UNBOX(___R3))
   ___SET_F64(___F64V2,___F64UNBOX(___R1))
   ___SET_R1(___BOOLEAN(___F64LT(___F64V1,___F64V2)))
   ___GOTO(___L13_c_23_in_2d_integer_2d_range_3f_)
___DEF_GLBL(___L15_c_23_in_2d_integer_2d_range_3f_)
   ___SET_STK(1,___R0)
   ___SET_R2(___R1)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_in_2d_integer_2d_range_3f_)
   ___JUMPPRM(___SET_NARGS(2),___PRM__3c_)
___DEF_SLBL(5,___L5_c_23_in_2d_integer_2d_range_3f_)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___GOTO(___L13_c_23_in_2d_integer_2d_range_3f_)
___DEF_GLBL(___L16_c_23_in_2d_integer_2d_range_3f_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23_in_2d_integer_2d_range_3f_)
   ___JUMPPRM(___SET_NARGS(2),___PRM__3c_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_fatal_2d_err
#undef ___PH_LBL0
#define ___PH_LBL0 98
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_fatal_2d_err)
___DEF_P_HLBL(___L1_c_23_fatal_2d_err)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_fatal_2d_err)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_fatal_2d_err)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_fatal_2d_err)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),190,___G_error)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_scheme_2d_global_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 101
#undef ___PD_ALL
#define ___PD_ALL ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_R0
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_scheme_2d_global_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_scheme_2d_global_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_scheme_2d_global_2d_var)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_scheme_2d_global_2d_var_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 103
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_P_HLBL(___L1_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_P_HLBL(___L2_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_P_HLBL(___L3_c_23_scheme_2d_global_2d_var_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_scheme_2d_global_2d_var_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_scheme_2d_global_2d_var_2d_ref)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_scheme_2d_global_2d_var_2d_ref)
   ___SET_NARGS(1) ___GOTO(___L2_c_23_scheme_2d_global_2d_var_2d_ref)
___DEF_SLBL(2,___L2_c_23_scheme_2d_global_2d_var_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(2,2,0,0)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_scheme_2d_global_2d_var_2d_ref)
   ___JUMPPRM(___SET_NARGS(1),___PRM_eval)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_scheme_2d_global_2d_var_2d_define_21_
#undef ___PH_LBL0
#define ___PH_LBL0 108
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_scheme_2d_global_2d_var_2d_define_21_)
___DEF_P_HLBL(___L1_c_23_scheme_2d_global_2d_var_2d_define_21_)
___DEF_P_HLBL(___L2_c_23_scheme_2d_global_2d_var_2d_define_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_scheme_2d_global_2d_var_2d_define_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_scheme_2d_global_2d_var_2d_define_21_)
   ___BEGIN_ALLOC_LIST(2,___R2)
   ___ADD_LIST_ELEM(1,___SYM_quote)
   ___END_ALLOC_LIST(2)
   ___SET_R2(___GET_LIST(2))
   ___BEGIN_ALLOC_LIST(3,___R2)
   ___ADD_LIST_ELEM(1,___R1)
   ___ADD_LIST_ELEM(2,___SYM_define)
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_scheme_2d_global_2d_var_2d_define_21_)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_scheme_2d_global_2d_var_2d_define_21_)
   ___JUMPPRM(___SET_NARGS(1),___PRM_eval)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_scheme_2d_global_2d_eval
#undef ___PH_LBL0
#define ___PH_LBL0 112
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_scheme_2d_global_2d_eval)
___DEF_P_HLBL(___L1_c_23_scheme_2d_global_2d_eval)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_scheme_2d_global_2d_eval)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_scheme_2d_global_2d_eval)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_scheme_2d_global_2d_eval)
   ___JUMPPRM(___SET_NARGS(1),___PRM_eval)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_format_2d_filepos
#undef ___PH_LBL0
#define ___PH_LBL0 115
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_format_2d_filepos)
___DEF_P_HLBL(___L1_c_23_format_2d_filepos)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_format_2d_filepos)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_format_2d_filepos)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_format_2d_filepos)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),129,___G__23__23_format_2d_filepos)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_s8vect
#undef ___PH_LBL0
#define ___PH_LBL0 118
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_s8vect)
___DEF_P_HLBL(___L1_c_23_make_2d_s8vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_s8vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_s8vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_s8vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s8vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_u8vect
#undef ___PH_LBL0
#define ___PH_LBL0 121
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_u8vect)
___DEF_P_HLBL(___L1_c_23_make_2d_u8vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_u8vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_u8vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_u8vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u8vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_s16vect
#undef ___PH_LBL0
#define ___PH_LBL0 124
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_s16vect)
___DEF_P_HLBL(___L1_c_23_make_2d_s16vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_s16vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_s16vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_s16vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s16vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_u16vect
#undef ___PH_LBL0
#define ___PH_LBL0 127
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_u16vect)
___DEF_P_HLBL(___L1_c_23_make_2d_u16vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_u16vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_u16vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_u16vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u16vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_s32vect
#undef ___PH_LBL0
#define ___PH_LBL0 130
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_s32vect)
___DEF_P_HLBL(___L1_c_23_make_2d_s32vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_s32vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_s32vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_s32vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s32vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_u32vect
#undef ___PH_LBL0
#define ___PH_LBL0 133
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_u32vect)
___DEF_P_HLBL(___L1_c_23_make_2d_u32vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_u32vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_u32vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_u32vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u32vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_s64vect
#undef ___PH_LBL0
#define ___PH_LBL0 136
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_s64vect)
___DEF_P_HLBL(___L1_c_23_make_2d_s64vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_s64vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_s64vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_s64vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s64vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_u64vect
#undef ___PH_LBL0
#define ___PH_LBL0 139
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_u64vect)
___DEF_P_HLBL(___L1_c_23_make_2d_u64vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_u64vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_u64vect)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_u64vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u64vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_f32vect
#undef ___PH_LBL0
#define ___PH_LBL0 142
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_f32vect)
___DEF_P_HLBL(___L1_c_23_make_2d_f32vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_f32vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_f32vect)
   ___SET_R2(___SUB(0))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_f32vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_f32vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_f64vect
#undef ___PH_LBL0
#define ___PH_LBL0 145
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_f64vect)
___DEF_P_HLBL(___L1_c_23_make_2d_f64vect)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_f64vect)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_make_2d_f64vect)
   ___SET_R2(___SUB(0))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_f64vect)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_f64vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_vector_2d_object_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 148
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_vector_2d_object_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_vector_2d_object_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_vector_2d_object_3f_)
   ___SET_R1(___BOOLEAN(___VECTORP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 150
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_subtype_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 152
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_subtype_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_subtype_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_subtype_2d_set_21_)
   ___SUBTYPESET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_max_2d_lines
#undef ___PH_LBL0
#define ___PH_LBL0 154
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_max_2d_lines)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_max_2d_lines)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_max_2d_lines)
   ___SET_R1(___FIX(65536L))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines
#undef ___PH_LBL0
#define ___PH_LBL0 156
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
   ___SET_R1(___FIX(8191L))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_subtype_2d_structure
#undef ___PH_LBL0
#define ___PH_LBL0 158
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_subtype_2d_structure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_subtype_2d_structure)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_subtype_2d_structure)
   ___SET_R1(___FIX(4L))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_symbol_2d_hash
#undef ___PH_LBL0
#define ___PH_LBL0 160
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_F64(___F64V1) ___D_F64(___F64V2)
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_symbol_2d_hash)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_symbol_2d_hash)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_symbol_2d_hash)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___host," _host",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20___host,0,-1)
,___DEF_LBL_INTRO(___H_c_23_string_2d__3e_keyword_2d_object,"c#string->keyword-object",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_c_23_string_2d__3e_keyword_2d_object,1,-1)
,___DEF_LBL_RET(___H_c_23_string_2d__3e_keyword_2d_object,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_keyword_2d_object_2d__3e_string,"c#keyword-object->string",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_c_23_keyword_2d_object_2d__3e_string,1,-1)
,___DEF_LBL_RET(___H_c_23_keyword_2d_object_2d__3e_string,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_keyword_2d_object_3f_,"c#keyword-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_keyword_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_false_2d_object_3f_,"c#false-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_false_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_absent_2d_object_3f_,"c#absent-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_absent_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_unused_2d_object_3f_,"c#unused-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_unused_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_deleted_2d_object_3f_,"c#deleted-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_deleted_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_void_2d_object_3f_,"c#void-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_void_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_unbound1_2d_object_3f_,"c#unbound1-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_unbound1_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_unbound2_2d_object_3f_,"c#unbound2-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_unbound2_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_end_2d_of_2d_file_2d_object_3f_,"c#end-of-file-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_end_2d_of_2d_file_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_optional_2d_object_3f_,"c#optional-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_optional_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_key_2d_object_3f_,"c#key-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_key_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_rest_2d_object_3f_,"c#rest-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_rest_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_symbol_2d_object_3f_,"c#symbol-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_symbol_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_box_2d_object_3f_,"c#box-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_box_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_box_2d_object,"c#box-object",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_box_2d_object,1,-1)
,___DEF_LBL_RET(___H_c_23_box_2d_object,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_unbox_2d_object,"c#unbox-object",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_unbox_2d_object,1,-1)
,___DEF_LBL_INTRO(___H_c_23_set_2d_box_2d_object_21_,"c#set-box-object!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_set_2d_box_2d_object_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_structure_2d_object_3f_,"c#structure-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_structure_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23_structure_2d__3e_list,"c#structure->list",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_structure_2d__3e_list,1,-1)
,___DEF_LBL_RET(___H_c_23_structure_2d__3e_list,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_open_2d_input_2d_file_2a_,"c#open-input-file*",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_open_2d_input_2d_file_2a_,1,-1)
,___DEF_LBL_RET(___H_c_23_open_2d_input_2d_file_2a_,___IFD(___RETI,3,4,0x3f3L))
,___DEF_LBL_PROC(___H_c_23_open_2d_input_2d_file_2a_,1,-1)
,___DEF_LBL_RET(___H_c_23_open_2d_input_2d_file_2a_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_open_2d_input_2d_file_2a_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_open_2d_input_2d_file_2a_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_open_2d_input_2d_file_2a_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_pp_2d_expression,"c#pp-expression",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_pp_2d_expression,2,-1)
,___DEF_LBL_RET(___H_c_23_pp_2d_expression,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_write_2d_returning_2d_len,"c#write-returning-len",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_write_2d_returning_2d_len,2,-1)
,___DEF_LBL_RET(___H_c_23_write_2d_returning_2d_len,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_write_2d_returning_2d_len,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_write_2d_returning_2d_len,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_write_2d_returning_2d_len,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_write_2d_returning_2d_len,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_PROC(___H_c_23_write_2d_returning_2d_len,0,1)
,___DEF_LBL_RET(___H_c_23_write_2d_returning_2d_len,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_display_2d_returning_2d_len,"c#display-returning-len",___REF_FAL,8,0)

,___DEF_LBL_PROC(___H_c_23_display_2d_returning_2d_len,2,-1)
,___DEF_LBL_RET(___H_c_23_display_2d_returning_2d_len,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_display_2d_returning_2d_len,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_display_2d_returning_2d_len,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_display_2d_returning_2d_len,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_display_2d_returning_2d_len,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_PROC(___H_c_23_display_2d_returning_2d_len,0,1)
,___DEF_LBL_RET(___H_c_23_display_2d_returning_2d_len,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_write_2d_word,"c#write-word",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_write_2d_word,2,-1)
,___DEF_LBL_RET(___H_c_23_write_2d_word,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_write_2d_word,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_write_2d_word,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23_character_2d__3e_unicode,"c#character->unicode",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_character_2d__3e_unicode,1,-1)
,___DEF_LBL_INTRO(___H_c_23_unicode_2d__3e_character,"c#unicode->character",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_unicode_2d__3e_character,1,-1)
,___DEF_LBL_INTRO(___H_c_23_in_2d_char_2d_range_3f_,"c#in-char-range?",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_in_2d_char_2d_range_3f_,1,-1)
,___DEF_LBL_RET(___H_c_23_in_2d_char_2d_range_3f_,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_in_2d_integer_2d_range_3f_,"c#in-integer-range?",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23_in_2d_integer_2d_range_3f_,3,-1)
,___DEF_LBL_RET(___H_c_23_in_2d_integer_2d_range_3f_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_in_2d_integer_2d_range_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_in_2d_integer_2d_range_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_in_2d_integer_2d_range_3f_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_in_2d_integer_2d_range_3f_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_in_2d_integer_2d_range_3f_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_fatal_2d_err,"c#fatal-err",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_fatal_2d_err,2,-1)
,___DEF_LBL_RET(___H_c_23_fatal_2d_err,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_scheme_2d_global_2d_var,"c#scheme-global-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_scheme_2d_global_2d_var,1,-1)
,___DEF_LBL_INTRO(___H_c_23_scheme_2d_global_2d_var_2d_ref,"c#scheme-global-var-ref",___REF_FAL,4,0)

,___DEF_LBL_PROC(___H_c_23_scheme_2d_global_2d_var_2d_ref,1,-1)
,___DEF_LBL_RET(___H_c_23_scheme_2d_global_2d_var_2d_ref,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_scheme_2d_global_2d_var_2d_ref,2,-1)
,___DEF_LBL_RET(___H_c_23_scheme_2d_global_2d_var_2d_ref,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_scheme_2d_global_2d_var_2d_define_21_,"c#scheme-global-var-define!",___REF_FAL,
3,0)
,___DEF_LBL_PROC(___H_c_23_scheme_2d_global_2d_var_2d_define_21_,2,-1)
,___DEF_LBL_RET(___H_c_23_scheme_2d_global_2d_var_2d_define_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_scheme_2d_global_2d_var_2d_define_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_scheme_2d_global_2d_eval,"c#scheme-global-eval",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_scheme_2d_global_2d_eval,2,-1)
,___DEF_LBL_RET(___H_c_23_scheme_2d_global_2d_eval,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_format_2d_filepos,"c#format-filepos",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_format_2d_filepos,3,-1)
,___DEF_LBL_RET(___H_c_23_format_2d_filepos,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_s8vect,"c#make-s8vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_s8vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_s8vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_u8vect,"c#make-u8vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_u8vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_u8vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_s16vect,"c#make-s16vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_s16vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_s16vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_u16vect,"c#make-u16vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_u16vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_u16vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_s32vect,"c#make-s32vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_s32vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_s32vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_u32vect,"c#make-u32vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_u32vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_u32vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_s64vect,"c#make-s64vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_s64vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_s64vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_u64vect,"c#make-u64vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_u64vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_u64vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_f32vect,"c#make-f32vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_f32vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_f32vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_make_2d_f64vect,"c#make-f64vect",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_f64vect,1,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_f64vect,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_vector_2d_object_3f_,"c#vector-object?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_vector_2d_object_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_,"c#**comply-to-standard-scheme?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_,0,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_subtype_2d_set_21_,"c#**subtype-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_subtype_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23_max_2d_lines,"c#max-lines",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_max_2d_lines,0,-1)
,___DEF_LBL_INTRO(___H_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines,"c#max-fixnum32-div-max-lines",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines,0,-1)
,___DEF_LBL_INTRO(___H_c_23_subtype_2d_structure,"c#subtype-structure",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_subtype_2d_structure,0,-1)
,___DEF_LBL_INTRO(___H_symbol_2d_hash,"symbol-hash",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_symbol_2d_hash,1,-1)
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20___host,1)
___DEF_MOD_PRM(80,___G_c_23_string_2d__3e_keyword_2d_object,3)
___DEF_MOD_PRM(33,___G_c_23_keyword_2d_object_2d__3e_string,6)
___DEF_MOD_PRM(34,___G_c_23_keyword_2d_object_3f_,9)
___DEF_MOD_PRM(25,___G_c_23_false_2d_object_3f_,11)
___DEF_MOD_PRM(5,___G_c_23_absent_2d_object_3f_,13)
___DEF_MOD_PRM(110,___G_c_23_unused_2d_object_3f_,15)
___DEF_MOD_PRM(10,___G_c_23_deleted_2d_object_3f_,17)
___DEF_MOD_PRM(113,___G_c_23_void_2d_object_3f_,19)
___DEF_MOD_PRM(105,___G_c_23_unbound1_2d_object_3f_,21)
___DEF_MOD_PRM(106,___G_c_23_unbound2_2d_object_3f_,23)
___DEF_MOD_PRM(13,___G_c_23_end_2d_of_2d_file_2d_object_3f_,25)
___DEF_MOD_PRM(49,___G_c_23_optional_2d_object_3f_,27)
___DEF_MOD_PRM(32,___G_c_23_key_2d_object_3f_,29)
___DEF_MOD_PRM(53,___G_c_23_rest_2d_object_3f_,31)
___DEF_MOD_PRM(84,___G_c_23_symbol_2d_object_3f_,33)
___DEF_MOD_PRM(7,___G_c_23_box_2d_object_3f_,35)
___DEF_MOD_PRM(6,___G_c_23_box_2d_object,37)
___DEF_MOD_PRM(107,___G_c_23_unbox_2d_object,40)
___DEF_MOD_PRM(79,___G_c_23_set_2d_box_2d_object_21_,42)
___DEF_MOD_PRM(82,___G_c_23_structure_2d_object_3f_,44)
___DEF_MOD_PRM(81,___G_c_23_structure_2d__3e_list,46)
___DEF_MOD_PRM(47,___G_c_23_open_2d_input_2d_file_2a_,49)
___DEF_MOD_PRM(50,___G_c_23_pp_2d_expression,57)
___DEF_MOD_PRM(114,___G_c_23_write_2d_returning_2d_len,60)
___DEF_MOD_PRM(11,___G_c_23_display_2d_returning_2d_len,69)
___DEF_MOD_PRM(115,___G_c_23_write_2d_word,78)
___DEF_MOD_PRM(8,___G_c_23_character_2d__3e_unicode,83)
___DEF_MOD_PRM(108,___G_c_23_unicode_2d__3e_character,85)
___DEF_MOD_PRM(29,___G_c_23_in_2d_char_2d_range_3f_,87)
___DEF_MOD_PRM(30,___G_c_23_in_2d_integer_2d_range_3f_,90)
___DEF_MOD_PRM(26,___G_c_23_fatal_2d_err,98)
___DEF_MOD_PRM(76,___G_c_23_scheme_2d_global_2d_var,101)
___DEF_MOD_PRM(78,___G_c_23_scheme_2d_global_2d_var_2d_ref,103)
___DEF_MOD_PRM(77,___G_c_23_scheme_2d_global_2d_var_2d_define_21_,108)
___DEF_MOD_PRM(75,___G_c_23_scheme_2d_global_2d_eval,112)
___DEF_MOD_PRM(28,___G_c_23_format_2d_filepos,115)
___DEF_MOD_PRM(40,___G_c_23_make_2d_s8vect,118)
___DEF_MOD_PRM(44,___G_c_23_make_2d_u8vect,121)
___DEF_MOD_PRM(37,___G_c_23_make_2d_s16vect,124)
___DEF_MOD_PRM(41,___G_c_23_make_2d_u16vect,127)
___DEF_MOD_PRM(38,___G_c_23_make_2d_s32vect,130)
___DEF_MOD_PRM(42,___G_c_23_make_2d_u32vect,133)
___DEF_MOD_PRM(39,___G_c_23_make_2d_s64vect,136)
___DEF_MOD_PRM(43,___G_c_23_make_2d_u64vect,139)
___DEF_MOD_PRM(35,___G_c_23_make_2d_f32vect,142)
___DEF_MOD_PRM(36,___G_c_23_make_2d_f64vect,145)
___DEF_MOD_PRM(111,___G_c_23_vector_2d_object_3f_,148)
___DEF_MOD_PRM(1,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_,150)
___DEF_MOD_PRM(3,___G_c_23__2a__2a_subtype_2d_set_21_,152)
___DEF_MOD_PRM(46,___G_c_23_max_2d_lines,154)
___DEF_MOD_PRM(45,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines,156)
___DEF_MOD_PRM(83,___G_c_23_subtype_2d_structure,158)
___DEF_MOD_PRM(117,___G_symbol_2d_hash,160)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___host,1)
___DEF_MOD_GLO(80,___G_c_23_string_2d__3e_keyword_2d_object,3)
___DEF_MOD_GLO(33,___G_c_23_keyword_2d_object_2d__3e_string,6)
___DEF_MOD_GLO(34,___G_c_23_keyword_2d_object_3f_,9)
___DEF_MOD_GLO(25,___G_c_23_false_2d_object_3f_,11)
___DEF_MOD_GLO(5,___G_c_23_absent_2d_object_3f_,13)
___DEF_MOD_GLO(110,___G_c_23_unused_2d_object_3f_,15)
___DEF_MOD_GLO(10,___G_c_23_deleted_2d_object_3f_,17)
___DEF_MOD_GLO(113,___G_c_23_void_2d_object_3f_,19)
___DEF_MOD_GLO(105,___G_c_23_unbound1_2d_object_3f_,21)
___DEF_MOD_GLO(106,___G_c_23_unbound2_2d_object_3f_,23)
___DEF_MOD_GLO(13,___G_c_23_end_2d_of_2d_file_2d_object_3f_,25)
___DEF_MOD_GLO(49,___G_c_23_optional_2d_object_3f_,27)
___DEF_MOD_GLO(32,___G_c_23_key_2d_object_3f_,29)
___DEF_MOD_GLO(53,___G_c_23_rest_2d_object_3f_,31)
___DEF_MOD_GLO(84,___G_c_23_symbol_2d_object_3f_,33)
___DEF_MOD_GLO(7,___G_c_23_box_2d_object_3f_,35)
___DEF_MOD_GLO(6,___G_c_23_box_2d_object,37)
___DEF_MOD_GLO(107,___G_c_23_unbox_2d_object,40)
___DEF_MOD_GLO(79,___G_c_23_set_2d_box_2d_object_21_,42)
___DEF_MOD_GLO(82,___G_c_23_structure_2d_object_3f_,44)
___DEF_MOD_GLO(81,___G_c_23_structure_2d__3e_list,46)
___DEF_MOD_GLO(47,___G_c_23_open_2d_input_2d_file_2a_,49)
___DEF_MOD_GLO(50,___G_c_23_pp_2d_expression,57)
___DEF_MOD_GLO(114,___G_c_23_write_2d_returning_2d_len,60)
___DEF_MOD_GLO(11,___G_c_23_display_2d_returning_2d_len,69)
___DEF_MOD_GLO(115,___G_c_23_write_2d_word,78)
___DEF_MOD_GLO(8,___G_c_23_character_2d__3e_unicode,83)
___DEF_MOD_GLO(108,___G_c_23_unicode_2d__3e_character,85)
___DEF_MOD_GLO(29,___G_c_23_in_2d_char_2d_range_3f_,87)
___DEF_MOD_GLO(30,___G_c_23_in_2d_integer_2d_range_3f_,90)
___DEF_MOD_GLO(26,___G_c_23_fatal_2d_err,98)
___DEF_MOD_GLO(76,___G_c_23_scheme_2d_global_2d_var,101)
___DEF_MOD_GLO(78,___G_c_23_scheme_2d_global_2d_var_2d_ref,103)
___DEF_MOD_GLO(77,___G_c_23_scheme_2d_global_2d_var_2d_define_21_,108)
___DEF_MOD_GLO(75,___G_c_23_scheme_2d_global_2d_eval,112)
___DEF_MOD_GLO(28,___G_c_23_format_2d_filepos,115)
___DEF_MOD_GLO(40,___G_c_23_make_2d_s8vect,118)
___DEF_MOD_GLO(44,___G_c_23_make_2d_u8vect,121)
___DEF_MOD_GLO(37,___G_c_23_make_2d_s16vect,124)
___DEF_MOD_GLO(41,___G_c_23_make_2d_u16vect,127)
___DEF_MOD_GLO(38,___G_c_23_make_2d_s32vect,130)
___DEF_MOD_GLO(42,___G_c_23_make_2d_u32vect,133)
___DEF_MOD_GLO(39,___G_c_23_make_2d_s64vect,136)
___DEF_MOD_GLO(43,___G_c_23_make_2d_u64vect,139)
___DEF_MOD_GLO(35,___G_c_23_make_2d_f32vect,142)
___DEF_MOD_GLO(36,___G_c_23_make_2d_f64vect,145)
___DEF_MOD_GLO(111,___G_c_23_vector_2d_object_3f_,148)
___DEF_MOD_GLO(1,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_,150)
___DEF_MOD_GLO(3,___G_c_23__2a__2a_subtype_2d_set_21_,152)
___DEF_MOD_GLO(46,___G_c_23_max_2d_lines,154)
___DEF_MOD_GLO(45,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines,156)
___DEF_MOD_GLO(83,___G_c_23_subtype_2d_structure,158)
___DEF_MOD_GLO(117,___G_symbol_2d_hash,160)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S___host,"_host")
___DEF_MOD_SYM(1,___S_define,"define")
___DEF_MOD_SYM(2,___S_quote,"quote")
___END_MOD_SYM_KEY

#endif
