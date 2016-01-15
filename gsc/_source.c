#ifdef ___LINKER_INFO
; File: "_source.c", produced by Gambit v4.8.3
(
408003
(C)
"_source"
(("_source"))
(
"##type-5"
"##type-9-edd21ef2-ee48-407f-a9a9-c1c361078e55"
"_source"
"allow-script?"
"container"
"dot"
"f32vector"
"f64vector"
"fields"
"filepos"
"flags"
"id"
"labels"
"name"
"none"
"port"
"prefix"
"quasiquote"
"quote"
"read-cont"
"readenv"
"readtable"
"super"
"type"
"u16vector"
"u32vector"
"u64vector"
"u8vector"
"unquote"
"unquote-splicing"
"unwrapper"
"upcase"
"vector"
"wrapper"
)
(
)
(
" _source"
"c#**append-strings"
"c#**build-delimited-number/keyword/symbol"
"c#**build-delimited-string"
"c#**build-delimited-symbol"
"c#**build-escaped-string-up-to"
"c#**build-list"
"c#**build-vector"
"c#**chartable-ref"
"c#**chartable-set!"
"c#**filepos-col"
"c#**filepos-line"
"c#**main-readtable"
"c#**make-chartable"
"c#**make-filepos"
"c#**make-readenv"
"c#**make-standard-readtable"
"c#**peek-next-char"
"c#**peek-next-char-or-eof"
"c#**read-assoc-string-ci=?"
"c#**read-datum"
"c#**read-datum-or-none"
"c#**read-datum-or-none-or-dot"
"c#**read-dot"
"c#**read-error-char-name"
"c#**read-error-char-range"
"c#**read-error-datum-expected"
"c#**read-error-datum-or-eof-expected"
"c#**read-error-escaped-char"
"c#**read-error-f32/f64"
"c#**read-error-hex"
"c#**read-error-illegal-char"
"c#**read-error-improperly-placed-dot"
"c#**read-error-incomplete"
"c#**read-error-incomplete-form-eof-reached"
"c#**read-error-sharp-bang-name"
"c#**read-error-sharp-token"
"c#**read-error-u16"
"c#**read-error-u32"
"c#**read-error-u64"
"c#**read-error-u8"
"c#**read-error-vector"
"c#**read-escaped-string"
"c#**read-escaped-symbol"
"c#**read-illegal"
"c#**read-list"
"c#**read-next-char"
"c#**read-next-char-expecting"
"c#**read-next-char-or-eof"
"c#**read-none"
"c#**read-number/keyword/symbol"
"c#**read-quasiquotation"
"c#**read-quotation"
"c#**read-sharp"
"c#**read-single-line-comment"
"c#**read-unquotation"
"c#**read-whitespace"
"c#**readenv-close"
"c#**readenv-current-filepos"
"c#**readenv-open"
"c#**readenv-previous-filepos"
"c#**readenv-readtable"
"c#**readenv-unwrap"
"c#**readenv-wrap"
"c#**readtable-char-class-set!"
"c#**readtable-char-delimiter?-set!"
"c#**readtable-char-handler-set!"
"c#**readtable-parse-keyword"
"c#**readtable-string-convert-case!"
"c#**skip-extended-comment"
"c#**skip-single-line-comment"
"c#**standard-escaped-char-table"
"c#**standard-named-char-table"
"c#**standard-sharp-bang-table"
"c#expr->locat"
"c#locat-filename-and-line"
"c#re->locat"
"c#read-source"
"c#source-locat"
)
(
"c#**dot-marker"
"c#**make-readtable"
"c#**none-marker"
"c#**read-datum-or-eof"
"c#**readenv-char-count"
"c#**readenv-char-count-set!"
"c#**readenv-error-proc"
"c#**readenv-filepos"
"c#**readenv-filepos-set!"
"c#**readenv-line-count"
"c#**readenv-line-count-set!"
"c#**readenv-line-start"
"c#**readenv-line-start-set!"
"c#**readenv-port"
"c#**readtable-case-conversion?"
"c#**readtable-case-conversion?-set!"
"c#**readtable-char-delimiter?"
"c#**readtable-char-delimiter?-table"
"c#**readtable-char-delimiter?-table-set!"
"c#**readtable-char-handler"
"c#**readtable-char-handler-table"
"c#**readtable-char-handler-table-set!"
"c#**readtable-convert-case"
"c#**readtable-escaped-char-table"
"c#**readtable-escaped-char-table-set!"
"c#**readtable-keywords-allowed?"
"c#**readtable-keywords-allowed?-set!"
"c#**readtable-named-char-table"
"c#**readtable-named-char-table-set!"
"c#**readtable-sharp-bang-table"
"c#**readtable-sharp-bang-table-set!"
"c#**readtable-tag"
"c#expression->source"
"c#false-obj"
"c#include-expr->source"
"c#include-expr->sourcezzzzz"
"c#locat-filename"
"c#locat-show"
"c#make-source"
"c#source->expression"
"c#source-code"
"c#string->canonical-symbol"
)
(
"##container->path"
"##current-readtable"
"##filepos->position"
"##integer?"
"##locat-container"
"##locat-position"
"##make-locat"
"##make-source"
"##path->container"
"##path-reference"
"##port-name"
"##position->filepos"
"##read-all-as-a-begin-expr-from-path"
"##read-all-as-a-begin-expr-from-port"
"##real?"
"##scheme-file-extensions"
"##source-code"
"##source-locat"
"append"
"apply"
"c#**comply-to-standard-scheme?"
"c#box-object"
"c#box-object?"
"c#character->unicode"
"c#compiler-error"
"c#compiler-user-error"
"c#end-of-file-object"
"c#f32vect-set!"
"c#f64vect-set!"
"c#false-object"
"c#format-filepos"
"c#in-char-range?"
"c#in-integer-range?"
"c#key-object"
"c#make-f32vect"
"c#make-f64vect"
"c#make-u16vect"
"c#make-u32vect"
"c#make-u64vect"
"c#make-u8vect"
"c#max-fixnum32-div-max-lines"
"c#max-lines"
"c#open-input-file*"
"c#optional-object"
"c#pt-syntax-error"
"c#quasiquote-sym"
"c#quote-sym"
"c#rest-object"
"c#scheme-file-extensions"
"c#string->keyword-object"
"c#u16vect-set!"
"c#u32vect-set!"
"c#u64vect-set!"
"c#u8vect-set!"
"c#unbox-object"
"c#unicode->character"
"c#unquote-splicing-sym"
"c#unquote-sym"
"c#vector-object?"
"close-input-port"
"display"
"equal?"
"exact?"
"make-string"
"make-vector"
"open-input-file"
"path-directory"
"path-expand"
"path-extension"
"peek-char"
"read-char"
"reverse"
"string->number"
"string->symbol"
"string-append"
"string-ci=?"
"string=?"
"substring"
"write"
)
 ()
)
#else
#define ___VERSION 408003
#define ___MODULE_NAME "_source"
#define ___LINKER_ID ____20___source
#define ___MH_PROC ___H__20___source
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 34
#define ___GLOCOUNT 200
#define ___SUPCOUNT 121
#define ___CNSCOUNT 1
#define ___SUBCOUNT 69
#define ___LBLCOUNT 890
#define ___OFDCOUNT 25
#define ___MODDESCR ___REF_SUB(68)
#include "gambit.h"

___NEED_SYM(___S__23__23_type_2d_5)
___NEED_SYM(___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55)
___NEED_SYM(___S___source)
___NEED_SYM(___S_allow_2d_script_3f_)
___NEED_SYM(___S_container)
___NEED_SYM(___S_dot)
___NEED_SYM(___S_f32vector)
___NEED_SYM(___S_f64vector)
___NEED_SYM(___S_fields)
___NEED_SYM(___S_filepos)
___NEED_SYM(___S_flags)
___NEED_SYM(___S_id)
___NEED_SYM(___S_labels)
___NEED_SYM(___S_name)
___NEED_SYM(___S_none)
___NEED_SYM(___S_port)
___NEED_SYM(___S_prefix)
___NEED_SYM(___S_quasiquote)
___NEED_SYM(___S_quote)
___NEED_SYM(___S_read_2d_cont)
___NEED_SYM(___S_readenv)
___NEED_SYM(___S_readtable)
___NEED_SYM(___S_super)
___NEED_SYM(___S_type)
___NEED_SYM(___S_u16vector)
___NEED_SYM(___S_u32vector)
___NEED_SYM(___S_u64vector)
___NEED_SYM(___S_u8vector)
___NEED_SYM(___S_unquote)
___NEED_SYM(___S_unquote_2d_splicing)
___NEED_SYM(___S_unwrapper)
___NEED_SYM(___S_upcase)
___NEED_SYM(___S_vector)
___NEED_SYM(___S_wrapper)

___NEED_GLO(___G__20___source)
___NEED_GLO(___G__23__23_container_2d__3e_path)
___NEED_GLO(___G__23__23_current_2d_readtable)
___NEED_GLO(___G__23__23_filepos_2d__3e_position)
___NEED_GLO(___G__23__23_integer_3f_)
___NEED_GLO(___G__23__23_locat_2d_container)
___NEED_GLO(___G__23__23_locat_2d_position)
___NEED_GLO(___G__23__23_make_2d_locat)
___NEED_GLO(___G__23__23_make_2d_source)
___NEED_GLO(___G__23__23_path_2d__3e_container)
___NEED_GLO(___G__23__23_path_2d_reference)
___NEED_GLO(___G__23__23_port_2d_name)
___NEED_GLO(___G__23__23_position_2d__3e_filepos)
___NEED_GLO(___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_path)
___NEED_GLO(___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
___NEED_GLO(___G__23__23_real_3f_)
___NEED_GLO(___G__23__23_scheme_2d_file_2d_extensions)
___NEED_GLO(___G__23__23_source_2d_code)
___NEED_GLO(___G__23__23_source_2d_locat)
___NEED_GLO(___G_append)
___NEED_GLO(___G_apply)
___NEED_GLO(___G_c_23__2a__2a_append_2d_strings)
___NEED_GLO(___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___NEED_GLO(___G_c_23__2a__2a_build_2d_delimited_2d_string)
___NEED_GLO(___G_c_23__2a__2a_build_2d_delimited_2d_symbol)
___NEED_GLO(___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___NEED_GLO(___G_c_23__2a__2a_build_2d_list)
___NEED_GLO(___G_c_23__2a__2a_build_2d_vector)
___NEED_GLO(___G_c_23__2a__2a_chartable_2d_ref)
___NEED_GLO(___G_c_23__2a__2a_chartable_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
___NEED_GLO(___G_c_23__2a__2a_dot_2d_marker)
___NEED_GLO(___G_c_23__2a__2a_filepos_2d_col)
___NEED_GLO(___G_c_23__2a__2a_filepos_2d_line)
___NEED_GLO(___G_c_23__2a__2a_main_2d_readtable)
___NEED_GLO(___G_c_23__2a__2a_make_2d_chartable)
___NEED_GLO(___G_c_23__2a__2a_make_2d_filepos)
___NEED_GLO(___G_c_23__2a__2a_make_2d_readenv)
___NEED_GLO(___G_c_23__2a__2a_make_2d_readtable)
___NEED_GLO(___G_c_23__2a__2a_make_2d_standard_2d_readtable)
___NEED_GLO(___G_c_23__2a__2a_none_2d_marker)
___NEED_GLO(___G_c_23__2a__2a_peek_2d_next_2d_char)
___NEED_GLO(___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___NEED_GLO(___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___NEED_GLO(___G_c_23__2a__2a_read_2d_datum)
___NEED_GLO(___G_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___NEED_GLO(___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___NEED_GLO(___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___NEED_GLO(___G_c_23__2a__2a_read_2d_dot)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_char_2d_name)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_hex)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_incomplete)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_u16)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_u32)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_u64)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_u8)
___NEED_GLO(___G_c_23__2a__2a_read_2d_error_2d_vector)
___NEED_GLO(___G_c_23__2a__2a_read_2d_escaped_2d_string)
___NEED_GLO(___G_c_23__2a__2a_read_2d_escaped_2d_symbol)
___NEED_GLO(___G_c_23__2a__2a_read_2d_illegal)
___NEED_GLO(___G_c_23__2a__2a_read_2d_list)
___NEED_GLO(___G_c_23__2a__2a_read_2d_next_2d_char)
___NEED_GLO(___G_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___NEED_GLO(___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___NEED_GLO(___G_c_23__2a__2a_read_2d_none)
___NEED_GLO(___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___NEED_GLO(___G_c_23__2a__2a_read_2d_quasiquotation)
___NEED_GLO(___G_c_23__2a__2a_read_2d_quotation)
___NEED_GLO(___G_c_23__2a__2a_read_2d_sharp)
___NEED_GLO(___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___NEED_GLO(___G_c_23__2a__2a_read_2d_unquotation)
___NEED_GLO(___G_c_23__2a__2a_read_2d_whitespace)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_char_2d_count)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_close)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_current_2d_filepos)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_error_2d_proc)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_filepos)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_line_2d_count)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_line_2d_start)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_open)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_port)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_readtable)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_unwrap)
___NEED_GLO(___G_c_23__2a__2a_readenv_2d_wrap)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_handler)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_convert_2d_case)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___NEED_GLO(___G_c_23__2a__2a_readtable_2d_tag)
___NEED_GLO(___G_c_23__2a__2a_skip_2d_extended_2d_comment)
___NEED_GLO(___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___NEED_GLO(___G_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table)
___NEED_GLO(___G_c_23__2a__2a_standard_2d_named_2d_char_2d_table)
___NEED_GLO(___G_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table)
___NEED_GLO(___G_c_23_box_2d_object)
___NEED_GLO(___G_c_23_box_2d_object_3f_)
___NEED_GLO(___G_c_23_character_2d__3e_unicode)
___NEED_GLO(___G_c_23_compiler_2d_error)
___NEED_GLO(___G_c_23_compiler_2d_user_2d_error)
___NEED_GLO(___G_c_23_end_2d_of_2d_file_2d_object)
___NEED_GLO(___G_c_23_expr_2d__3e_locat)
___NEED_GLO(___G_c_23_expression_2d__3e_source)
___NEED_GLO(___G_c_23_f32vect_2d_set_21_)
___NEED_GLO(___G_c_23_f64vect_2d_set_21_)
___NEED_GLO(___G_c_23_false_2d_obj)
___NEED_GLO(___G_c_23_false_2d_object)
___NEED_GLO(___G_c_23_format_2d_filepos)
___NEED_GLO(___G_c_23_in_2d_char_2d_range_3f_)
___NEED_GLO(___G_c_23_in_2d_integer_2d_range_3f_)
___NEED_GLO(___G_c_23_include_2d_expr_2d__3e_source)
___NEED_GLO(___G_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___NEED_GLO(___G_c_23_key_2d_object)
___NEED_GLO(___G_c_23_locat_2d_filename)
___NEED_GLO(___G_c_23_locat_2d_filename_2d_and_2d_line)
___NEED_GLO(___G_c_23_locat_2d_show)
___NEED_GLO(___G_c_23_make_2d_f32vect)
___NEED_GLO(___G_c_23_make_2d_f64vect)
___NEED_GLO(___G_c_23_make_2d_source)
___NEED_GLO(___G_c_23_make_2d_u16vect)
___NEED_GLO(___G_c_23_make_2d_u32vect)
___NEED_GLO(___G_c_23_make_2d_u64vect)
___NEED_GLO(___G_c_23_make_2d_u8vect)
___NEED_GLO(___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
___NEED_GLO(___G_c_23_max_2d_lines)
___NEED_GLO(___G_c_23_open_2d_input_2d_file_2a_)
___NEED_GLO(___G_c_23_optional_2d_object)
___NEED_GLO(___G_c_23_pt_2d_syntax_2d_error)
___NEED_GLO(___G_c_23_quasiquote_2d_sym)
___NEED_GLO(___G_c_23_quote_2d_sym)
___NEED_GLO(___G_c_23_re_2d__3e_locat)
___NEED_GLO(___G_c_23_read_2d_source)
___NEED_GLO(___G_c_23_rest_2d_object)
___NEED_GLO(___G_c_23_scheme_2d_file_2d_extensions)
___NEED_GLO(___G_c_23_source_2d__3e_expression)
___NEED_GLO(___G_c_23_source_2d_code)
___NEED_GLO(___G_c_23_source_2d_locat)
___NEED_GLO(___G_c_23_string_2d__3e_canonical_2d_symbol)
___NEED_GLO(___G_c_23_string_2d__3e_keyword_2d_object)
___NEED_GLO(___G_c_23_u16vect_2d_set_21_)
___NEED_GLO(___G_c_23_u32vect_2d_set_21_)
___NEED_GLO(___G_c_23_u64vect_2d_set_21_)
___NEED_GLO(___G_c_23_u8vect_2d_set_21_)
___NEED_GLO(___G_c_23_unbox_2d_object)
___NEED_GLO(___G_c_23_unicode_2d__3e_character)
___NEED_GLO(___G_c_23_unquote_2d_splicing_2d_sym)
___NEED_GLO(___G_c_23_unquote_2d_sym)
___NEED_GLO(___G_c_23_vector_2d_object_3f_)
___NEED_GLO(___G_close_2d_input_2d_port)
___NEED_GLO(___G_display)
___NEED_GLO(___G_equal_3f_)
___NEED_GLO(___G_exact_3f_)
___NEED_GLO(___G_make_2d_string)
___NEED_GLO(___G_make_2d_vector)
___NEED_GLO(___G_open_2d_input_2d_file)
___NEED_GLO(___G_path_2d_directory)
___NEED_GLO(___G_path_2d_expand)
___NEED_GLO(___G_path_2d_extension)
___NEED_GLO(___G_peek_2d_char)
___NEED_GLO(___G_read_2d_char)
___NEED_GLO(___G_reverse)
___NEED_GLO(___G_string_2d__3e_number)
___NEED_GLO(___G_string_2d__3e_symbol)
___NEED_GLO(___G_string_2d_append)
___NEED_GLO(___G_string_2d_ci_3d__3f_)
___NEED_GLO(___G_string_3d__3f_)
___NEED_GLO(___G_substring)
___NEED_GLO(___G_write)

___BEGIN_SYM
___DEF_SYM(0,___S__23__23_type_2d_5,"##type-5")
___DEF_SYM(1,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55,"##type-9-edd21ef2-ee48-407f-a9a9-c1c361078e55")

___DEF_SYM(2,___S___source,"_source")
___DEF_SYM(3,___S_allow_2d_script_3f_,"allow-script?")
___DEF_SYM(4,___S_container,"container")
___DEF_SYM(5,___S_dot,"dot")
___DEF_SYM(6,___S_f32vector,"f32vector")
___DEF_SYM(7,___S_f64vector,"f64vector")
___DEF_SYM(8,___S_fields,"fields")
___DEF_SYM(9,___S_filepos,"filepos")
___DEF_SYM(10,___S_flags,"flags")
___DEF_SYM(11,___S_id,"id")
___DEF_SYM(12,___S_labels,"labels")
___DEF_SYM(13,___S_name,"name")
___DEF_SYM(14,___S_none,"none")
___DEF_SYM(15,___S_port,"port")
___DEF_SYM(16,___S_prefix,"prefix")
___DEF_SYM(17,___S_quasiquote,"quasiquote")
___DEF_SYM(18,___S_quote,"quote")
___DEF_SYM(19,___S_read_2d_cont,"read-cont")
___DEF_SYM(20,___S_readenv,"readenv")
___DEF_SYM(21,___S_readtable,"readtable")
___DEF_SYM(22,___S_super,"super")
___DEF_SYM(23,___S_type,"type")
___DEF_SYM(24,___S_u16vector,"u16vector")
___DEF_SYM(25,___S_u32vector,"u32vector")
___DEF_SYM(26,___S_u64vector,"u64vector")
___DEF_SYM(27,___S_u8vector,"u8vector")
___DEF_SYM(28,___S_unquote,"unquote")
___DEF_SYM(29,___S_unquote_2d_splicing,"unquote-splicing")
___DEF_SYM(30,___S_unwrapper,"unwrapper")
___DEF_SYM(31,___S_upcase,"upcase")
___DEF_SYM(32,___S_vector,"vector")
___DEF_SYM(33,___S_wrapper,"wrapper")
___END_SYM

#define ___SYM__23__23_type_2d_5 ___SYM(0,___S__23__23_type_2d_5)
#define ___SYM__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55 ___SYM(1,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55)
#define ___SYM___source ___SYM(2,___S___source)
#define ___SYM_allow_2d_script_3f_ ___SYM(3,___S_allow_2d_script_3f_)
#define ___SYM_container ___SYM(4,___S_container)
#define ___SYM_dot ___SYM(5,___S_dot)
#define ___SYM_f32vector ___SYM(6,___S_f32vector)
#define ___SYM_f64vector ___SYM(7,___S_f64vector)
#define ___SYM_fields ___SYM(8,___S_fields)
#define ___SYM_filepos ___SYM(9,___S_filepos)
#define ___SYM_flags ___SYM(10,___S_flags)
#define ___SYM_id ___SYM(11,___S_id)
#define ___SYM_labels ___SYM(12,___S_labels)
#define ___SYM_name ___SYM(13,___S_name)
#define ___SYM_none ___SYM(14,___S_none)
#define ___SYM_port ___SYM(15,___S_port)
#define ___SYM_prefix ___SYM(16,___S_prefix)
#define ___SYM_quasiquote ___SYM(17,___S_quasiquote)
#define ___SYM_quote ___SYM(18,___S_quote)
#define ___SYM_read_2d_cont ___SYM(19,___S_read_2d_cont)
#define ___SYM_readenv ___SYM(20,___S_readenv)
#define ___SYM_readtable ___SYM(21,___S_readtable)
#define ___SYM_super ___SYM(22,___S_super)
#define ___SYM_type ___SYM(23,___S_type)
#define ___SYM_u16vector ___SYM(24,___S_u16vector)
#define ___SYM_u32vector ___SYM(25,___S_u32vector)
#define ___SYM_u64vector ___SYM(26,___S_u64vector)
#define ___SYM_u8vector ___SYM(27,___S_u8vector)
#define ___SYM_unquote ___SYM(28,___S_unquote)
#define ___SYM_unquote_2d_splicing ___SYM(29,___S_unquote_2d_splicing)
#define ___SYM_unwrapper ___SYM(30,___S_unwrapper)
#define ___SYM_upcase ___SYM(31,___S_upcase)
#define ___SYM_vector ___SYM(32,___S_vector)
#define ___SYM_wrapper ___SYM(33,___S_wrapper)

___BEGIN_GLO
___DEF_GLO(0," _source")
___DEF_GLO(1,"c#**append-strings")
___DEF_GLO(2,"c#**build-delimited-number/keyword/symbol")

___DEF_GLO(3,"c#**build-delimited-string")
___DEF_GLO(4,"c#**build-delimited-symbol")
___DEF_GLO(5,"c#**build-escaped-string-up-to")
___DEF_GLO(6,"c#**build-list")
___DEF_GLO(7,"c#**build-vector")
___DEF_GLO(8,"c#**chartable-ref")
___DEF_GLO(9,"c#**chartable-set!")
___DEF_GLO(10,"c#**dot-marker")
___DEF_GLO(11,"c#**filepos-col")
___DEF_GLO(12,"c#**filepos-line")
___DEF_GLO(13,"c#**main-readtable")
___DEF_GLO(14,"c#**make-chartable")
___DEF_GLO(15,"c#**make-filepos")
___DEF_GLO(16,"c#**make-readenv")
___DEF_GLO(17,"c#**make-readtable")
___DEF_GLO(18,"c#**make-standard-readtable")
___DEF_GLO(19,"c#**none-marker")
___DEF_GLO(20,"c#**peek-next-char")
___DEF_GLO(21,"c#**peek-next-char-or-eof")
___DEF_GLO(22,"c#**read-assoc-string-ci=?")
___DEF_GLO(23,"c#**read-datum")
___DEF_GLO(24,"c#**read-datum-or-eof")
___DEF_GLO(25,"c#**read-datum-or-none")
___DEF_GLO(26,"c#**read-datum-or-none-or-dot")
___DEF_GLO(27,"c#**read-dot")
___DEF_GLO(28,"c#**read-error-char-name")
___DEF_GLO(29,"c#**read-error-char-range")
___DEF_GLO(30,"c#**read-error-datum-expected")
___DEF_GLO(31,"c#**read-error-datum-or-eof-expected")

___DEF_GLO(32,"c#**read-error-escaped-char")
___DEF_GLO(33,"c#**read-error-f32/f64")
___DEF_GLO(34,"c#**read-error-hex")
___DEF_GLO(35,"c#**read-error-illegal-char")
___DEF_GLO(36,"c#**read-error-improperly-placed-dot")

___DEF_GLO(37,"c#**read-error-incomplete")
___DEF_GLO(38,"c#**read-error-incomplete-form-eof-reached")

___DEF_GLO(39,"c#**read-error-sharp-bang-name")
___DEF_GLO(40,"c#**read-error-sharp-token")
___DEF_GLO(41,"c#**read-error-u16")
___DEF_GLO(42,"c#**read-error-u32")
___DEF_GLO(43,"c#**read-error-u64")
___DEF_GLO(44,"c#**read-error-u8")
___DEF_GLO(45,"c#**read-error-vector")
___DEF_GLO(46,"c#**read-escaped-string")
___DEF_GLO(47,"c#**read-escaped-symbol")
___DEF_GLO(48,"c#**read-illegal")
___DEF_GLO(49,"c#**read-list")
___DEF_GLO(50,"c#**read-next-char")
___DEF_GLO(51,"c#**read-next-char-expecting")
___DEF_GLO(52,"c#**read-next-char-or-eof")
___DEF_GLO(53,"c#**read-none")
___DEF_GLO(54,"c#**read-number/keyword/symbol")
___DEF_GLO(55,"c#**read-quasiquotation")
___DEF_GLO(56,"c#**read-quotation")
___DEF_GLO(57,"c#**read-sharp")
___DEF_GLO(58,"c#**read-single-line-comment")
___DEF_GLO(59,"c#**read-unquotation")
___DEF_GLO(60,"c#**read-whitespace")
___DEF_GLO(61,"c#**readenv-char-count")
___DEF_GLO(62,"c#**readenv-char-count-set!")
___DEF_GLO(63,"c#**readenv-close")
___DEF_GLO(64,"c#**readenv-current-filepos")
___DEF_GLO(65,"c#**readenv-error-proc")
___DEF_GLO(66,"c#**readenv-filepos")
___DEF_GLO(67,"c#**readenv-filepos-set!")
___DEF_GLO(68,"c#**readenv-line-count")
___DEF_GLO(69,"c#**readenv-line-count-set!")
___DEF_GLO(70,"c#**readenv-line-start")
___DEF_GLO(71,"c#**readenv-line-start-set!")
___DEF_GLO(72,"c#**readenv-open")
___DEF_GLO(73,"c#**readenv-port")
___DEF_GLO(74,"c#**readenv-previous-filepos")
___DEF_GLO(75,"c#**readenv-readtable")
___DEF_GLO(76,"c#**readenv-unwrap")
___DEF_GLO(77,"c#**readenv-wrap")
___DEF_GLO(78,"c#**readtable-case-conversion?")
___DEF_GLO(79,"c#**readtable-case-conversion?-set!")

___DEF_GLO(80,"c#**readtable-char-class-set!")
___DEF_GLO(81,"c#**readtable-char-delimiter?")
___DEF_GLO(82,"c#**readtable-char-delimiter?-set!")

___DEF_GLO(83,"c#**readtable-char-delimiter?-table")

___DEF_GLO(84,"c#**readtable-char-delimiter?-table-set!")

___DEF_GLO(85,"c#**readtable-char-handler")
___DEF_GLO(86,"c#**readtable-char-handler-set!")
___DEF_GLO(87,"c#**readtable-char-handler-table")
___DEF_GLO(88,"c#**readtable-char-handler-table-set!")

___DEF_GLO(89,"c#**readtable-convert-case")
___DEF_GLO(90,"c#**readtable-escaped-char-table")
___DEF_GLO(91,"c#**readtable-escaped-char-table-set!")

___DEF_GLO(92,"c#**readtable-keywords-allowed?")
___DEF_GLO(93,"c#**readtable-keywords-allowed?-set!")

___DEF_GLO(94,"c#**readtable-named-char-table")
___DEF_GLO(95,"c#**readtable-named-char-table-set!")

___DEF_GLO(96,"c#**readtable-parse-keyword")
___DEF_GLO(97,"c#**readtable-sharp-bang-table")
___DEF_GLO(98,"c#**readtable-sharp-bang-table-set!")

___DEF_GLO(99,"c#**readtable-string-convert-case!")

___DEF_GLO(100,"c#**readtable-tag")
___DEF_GLO(101,"c#**skip-extended-comment")
___DEF_GLO(102,"c#**skip-single-line-comment")
___DEF_GLO(103,"c#**standard-escaped-char-table")
___DEF_GLO(104,"c#**standard-named-char-table")
___DEF_GLO(105,"c#**standard-sharp-bang-table")
___DEF_GLO(106,"c#expr->locat")
___DEF_GLO(107,"c#expression->source")
___DEF_GLO(108,"c#false-obj")
___DEF_GLO(109,"c#include-expr->source")
___DEF_GLO(110,"c#include-expr->sourcezzzzz")
___DEF_GLO(111,"c#locat-filename")
___DEF_GLO(112,"c#locat-filename-and-line")
___DEF_GLO(113,"c#locat-show")
___DEF_GLO(114,"c#make-source")
___DEF_GLO(115,"c#re->locat")
___DEF_GLO(116,"c#read-source")
___DEF_GLO(117,"c#source->expression")
___DEF_GLO(118,"c#source-code")
___DEF_GLO(119,"c#source-locat")
___DEF_GLO(120,"c#string->canonical-symbol")
___DEF_GLO(121,"##container->path")
___DEF_GLO(122,"##current-readtable")
___DEF_GLO(123,"##filepos->position")
___DEF_GLO(124,"##integer?")
___DEF_GLO(125,"##locat-container")
___DEF_GLO(126,"##locat-position")
___DEF_GLO(127,"##make-locat")
___DEF_GLO(128,"##make-source")
___DEF_GLO(129,"##path->container")
___DEF_GLO(130,"##path-reference")
___DEF_GLO(131,"##port-name")
___DEF_GLO(132,"##position->filepos")
___DEF_GLO(133,"##read-all-as-a-begin-expr-from-path")

___DEF_GLO(134,"##read-all-as-a-begin-expr-from-port")

___DEF_GLO(135,"##real?")
___DEF_GLO(136,"##scheme-file-extensions")
___DEF_GLO(137,"##source-code")
___DEF_GLO(138,"##source-locat")
___DEF_GLO(139,"append")
___DEF_GLO(140,"apply")
___DEF_GLO(141,"c#**comply-to-standard-scheme?")
___DEF_GLO(142,"c#box-object")
___DEF_GLO(143,"c#box-object?")
___DEF_GLO(144,"c#character->unicode")
___DEF_GLO(145,"c#compiler-error")
___DEF_GLO(146,"c#compiler-user-error")
___DEF_GLO(147,"c#end-of-file-object")
___DEF_GLO(148,"c#f32vect-set!")
___DEF_GLO(149,"c#f64vect-set!")
___DEF_GLO(150,"c#false-object")
___DEF_GLO(151,"c#format-filepos")
___DEF_GLO(152,"c#in-char-range?")
___DEF_GLO(153,"c#in-integer-range?")
___DEF_GLO(154,"c#key-object")
___DEF_GLO(155,"c#make-f32vect")
___DEF_GLO(156,"c#make-f64vect")
___DEF_GLO(157,"c#make-u16vect")
___DEF_GLO(158,"c#make-u32vect")
___DEF_GLO(159,"c#make-u64vect")
___DEF_GLO(160,"c#make-u8vect")
___DEF_GLO(161,"c#max-fixnum32-div-max-lines")
___DEF_GLO(162,"c#max-lines")
___DEF_GLO(163,"c#open-input-file*")
___DEF_GLO(164,"c#optional-object")
___DEF_GLO(165,"c#pt-syntax-error")
___DEF_GLO(166,"c#quasiquote-sym")
___DEF_GLO(167,"c#quote-sym")
___DEF_GLO(168,"c#rest-object")
___DEF_GLO(169,"c#scheme-file-extensions")
___DEF_GLO(170,"c#string->keyword-object")
___DEF_GLO(171,"c#u16vect-set!")
___DEF_GLO(172,"c#u32vect-set!")
___DEF_GLO(173,"c#u64vect-set!")
___DEF_GLO(174,"c#u8vect-set!")
___DEF_GLO(175,"c#unbox-object")
___DEF_GLO(176,"c#unicode->character")
___DEF_GLO(177,"c#unquote-splicing-sym")
___DEF_GLO(178,"c#unquote-sym")
___DEF_GLO(179,"c#vector-object?")
___DEF_GLO(180,"close-input-port")
___DEF_GLO(181,"display")
___DEF_GLO(182,"equal?")
___DEF_GLO(183,"exact?")
___DEF_GLO(184,"make-string")
___DEF_GLO(185,"make-vector")
___DEF_GLO(186,"open-input-file")
___DEF_GLO(187,"path-directory")
___DEF_GLO(188,"path-expand")
___DEF_GLO(189,"path-extension")
___DEF_GLO(190,"peek-char")
___DEF_GLO(191,"read-char")
___DEF_GLO(192,"reverse")
___DEF_GLO(193,"string->number")
___DEF_GLO(194,"string->symbol")
___DEF_GLO(195,"string-append")
___DEF_GLO(196,"string-ci=?")
___DEF_GLO(197,"string=?")
___DEF_GLO(198,"substring")
___DEF_GLO(199,"write")
___END_GLO

#define ___GLO__20___source ___GLO(0,___G__20___source)
#define ___PRM__20___source ___PRM(0,___G__20___source)
#define ___GLO_c_23__2a__2a_append_2d_strings ___GLO(1,___G_c_23__2a__2a_append_2d_strings)
#define ___PRM_c_23__2a__2a_append_2d_strings ___PRM(1,___G_c_23__2a__2a_append_2d_strings)
#define ___GLO_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol ___GLO(2,___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
#define ___PRM_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol ___PRM(2,___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
#define ___GLO_c_23__2a__2a_build_2d_delimited_2d_string ___GLO(3,___G_c_23__2a__2a_build_2d_delimited_2d_string)
#define ___PRM_c_23__2a__2a_build_2d_delimited_2d_string ___PRM(3,___G_c_23__2a__2a_build_2d_delimited_2d_string)
#define ___GLO_c_23__2a__2a_build_2d_delimited_2d_symbol ___GLO(4,___G_c_23__2a__2a_build_2d_delimited_2d_symbol)
#define ___PRM_c_23__2a__2a_build_2d_delimited_2d_symbol ___PRM(4,___G_c_23__2a__2a_build_2d_delimited_2d_symbol)
#define ___GLO_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to ___GLO(5,___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
#define ___PRM_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to ___PRM(5,___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
#define ___GLO_c_23__2a__2a_build_2d_list ___GLO(6,___G_c_23__2a__2a_build_2d_list)
#define ___PRM_c_23__2a__2a_build_2d_list ___PRM(6,___G_c_23__2a__2a_build_2d_list)
#define ___GLO_c_23__2a__2a_build_2d_vector ___GLO(7,___G_c_23__2a__2a_build_2d_vector)
#define ___PRM_c_23__2a__2a_build_2d_vector ___PRM(7,___G_c_23__2a__2a_build_2d_vector)
#define ___GLO_c_23__2a__2a_chartable_2d_ref ___GLO(8,___G_c_23__2a__2a_chartable_2d_ref)
#define ___PRM_c_23__2a__2a_chartable_2d_ref ___PRM(8,___G_c_23__2a__2a_chartable_2d_ref)
#define ___GLO_c_23__2a__2a_chartable_2d_set_21_ ___GLO(9,___G_c_23__2a__2a_chartable_2d_set_21_)
#define ___PRM_c_23__2a__2a_chartable_2d_set_21_ ___PRM(9,___G_c_23__2a__2a_chartable_2d_set_21_)
#define ___GLO_c_23__2a__2a_dot_2d_marker ___GLO(10,___G_c_23__2a__2a_dot_2d_marker)
#define ___PRM_c_23__2a__2a_dot_2d_marker ___PRM(10,___G_c_23__2a__2a_dot_2d_marker)
#define ___GLO_c_23__2a__2a_filepos_2d_col ___GLO(11,___G_c_23__2a__2a_filepos_2d_col)
#define ___PRM_c_23__2a__2a_filepos_2d_col ___PRM(11,___G_c_23__2a__2a_filepos_2d_col)
#define ___GLO_c_23__2a__2a_filepos_2d_line ___GLO(12,___G_c_23__2a__2a_filepos_2d_line)
#define ___PRM_c_23__2a__2a_filepos_2d_line ___PRM(12,___G_c_23__2a__2a_filepos_2d_line)
#define ___GLO_c_23__2a__2a_main_2d_readtable ___GLO(13,___G_c_23__2a__2a_main_2d_readtable)
#define ___PRM_c_23__2a__2a_main_2d_readtable ___PRM(13,___G_c_23__2a__2a_main_2d_readtable)
#define ___GLO_c_23__2a__2a_make_2d_chartable ___GLO(14,___G_c_23__2a__2a_make_2d_chartable)
#define ___PRM_c_23__2a__2a_make_2d_chartable ___PRM(14,___G_c_23__2a__2a_make_2d_chartable)
#define ___GLO_c_23__2a__2a_make_2d_filepos ___GLO(15,___G_c_23__2a__2a_make_2d_filepos)
#define ___PRM_c_23__2a__2a_make_2d_filepos ___PRM(15,___G_c_23__2a__2a_make_2d_filepos)
#define ___GLO_c_23__2a__2a_make_2d_readenv ___GLO(16,___G_c_23__2a__2a_make_2d_readenv)
#define ___PRM_c_23__2a__2a_make_2d_readenv ___PRM(16,___G_c_23__2a__2a_make_2d_readenv)
#define ___GLO_c_23__2a__2a_make_2d_readtable ___GLO(17,___G_c_23__2a__2a_make_2d_readtable)
#define ___PRM_c_23__2a__2a_make_2d_readtable ___PRM(17,___G_c_23__2a__2a_make_2d_readtable)
#define ___GLO_c_23__2a__2a_make_2d_standard_2d_readtable ___GLO(18,___G_c_23__2a__2a_make_2d_standard_2d_readtable)
#define ___PRM_c_23__2a__2a_make_2d_standard_2d_readtable ___PRM(18,___G_c_23__2a__2a_make_2d_standard_2d_readtable)
#define ___GLO_c_23__2a__2a_none_2d_marker ___GLO(19,___G_c_23__2a__2a_none_2d_marker)
#define ___PRM_c_23__2a__2a_none_2d_marker ___PRM(19,___G_c_23__2a__2a_none_2d_marker)
#define ___GLO_c_23__2a__2a_peek_2d_next_2d_char ___GLO(20,___G_c_23__2a__2a_peek_2d_next_2d_char)
#define ___PRM_c_23__2a__2a_peek_2d_next_2d_char ___PRM(20,___G_c_23__2a__2a_peek_2d_next_2d_char)
#define ___GLO_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof ___GLO(21,___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
#define ___PRM_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof ___PRM(21,___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
#define ___GLO_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_ ___GLO(22,___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
#define ___PRM_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_ ___PRM(22,___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
#define ___GLO_c_23__2a__2a_read_2d_datum ___GLO(23,___G_c_23__2a__2a_read_2d_datum)
#define ___PRM_c_23__2a__2a_read_2d_datum ___PRM(23,___G_c_23__2a__2a_read_2d_datum)
#define ___GLO_c_23__2a__2a_read_2d_datum_2d_or_2d_eof ___GLO(24,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
#define ___PRM_c_23__2a__2a_read_2d_datum_2d_or_2d_eof ___PRM(24,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
#define ___GLO_c_23__2a__2a_read_2d_datum_2d_or_2d_none ___GLO(25,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
#define ___PRM_c_23__2a__2a_read_2d_datum_2d_or_2d_none ___PRM(25,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
#define ___GLO_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot ___GLO(26,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
#define ___PRM_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot ___PRM(26,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
#define ___GLO_c_23__2a__2a_read_2d_dot ___GLO(27,___G_c_23__2a__2a_read_2d_dot)
#define ___PRM_c_23__2a__2a_read_2d_dot ___PRM(27,___G_c_23__2a__2a_read_2d_dot)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_char_2d_name ___GLO(28,___G_c_23__2a__2a_read_2d_error_2d_char_2d_name)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_char_2d_name ___PRM(28,___G_c_23__2a__2a_read_2d_error_2d_char_2d_name)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_char_2d_range ___GLO(29,___G_c_23__2a__2a_read_2d_error_2d_char_2d_range)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_char_2d_range ___PRM(29,___G_c_23__2a__2a_read_2d_error_2d_char_2d_range)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_datum_2d_expected ___GLO(30,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_datum_2d_expected ___PRM(30,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected ___GLO(31,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected ___PRM(31,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_escaped_2d_char ___GLO(32,___G_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_escaped_2d_char ___PRM(32,___G_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_f32_2f_f64 ___GLO(33,___G_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_f32_2f_f64 ___PRM(33,___G_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_hex ___GLO(34,___G_c_23__2a__2a_read_2d_error_2d_hex)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_hex ___PRM(34,___G_c_23__2a__2a_read_2d_error_2d_hex)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_illegal_2d_char ___GLO(35,___G_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_illegal_2d_char ___PRM(35,___G_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot ___GLO(36,___G_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot ___PRM(36,___G_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_incomplete ___GLO(37,___G_c_23__2a__2a_read_2d_error_2d_incomplete)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_incomplete ___PRM(37,___G_c_23__2a__2a_read_2d_error_2d_incomplete)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached ___GLO(38,___G_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached ___PRM(38,___G_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name ___GLO(39,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name ___PRM(39,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_sharp_2d_token ___GLO(40,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_sharp_2d_token ___PRM(40,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_u16 ___GLO(41,___G_c_23__2a__2a_read_2d_error_2d_u16)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_u16 ___PRM(41,___G_c_23__2a__2a_read_2d_error_2d_u16)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_u32 ___GLO(42,___G_c_23__2a__2a_read_2d_error_2d_u32)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_u32 ___PRM(42,___G_c_23__2a__2a_read_2d_error_2d_u32)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_u64 ___GLO(43,___G_c_23__2a__2a_read_2d_error_2d_u64)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_u64 ___PRM(43,___G_c_23__2a__2a_read_2d_error_2d_u64)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_u8 ___GLO(44,___G_c_23__2a__2a_read_2d_error_2d_u8)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_u8 ___PRM(44,___G_c_23__2a__2a_read_2d_error_2d_u8)
#define ___GLO_c_23__2a__2a_read_2d_error_2d_vector ___GLO(45,___G_c_23__2a__2a_read_2d_error_2d_vector)
#define ___PRM_c_23__2a__2a_read_2d_error_2d_vector ___PRM(45,___G_c_23__2a__2a_read_2d_error_2d_vector)
#define ___GLO_c_23__2a__2a_read_2d_escaped_2d_string ___GLO(46,___G_c_23__2a__2a_read_2d_escaped_2d_string)
#define ___PRM_c_23__2a__2a_read_2d_escaped_2d_string ___PRM(46,___G_c_23__2a__2a_read_2d_escaped_2d_string)
#define ___GLO_c_23__2a__2a_read_2d_escaped_2d_symbol ___GLO(47,___G_c_23__2a__2a_read_2d_escaped_2d_symbol)
#define ___PRM_c_23__2a__2a_read_2d_escaped_2d_symbol ___PRM(47,___G_c_23__2a__2a_read_2d_escaped_2d_symbol)
#define ___GLO_c_23__2a__2a_read_2d_illegal ___GLO(48,___G_c_23__2a__2a_read_2d_illegal)
#define ___PRM_c_23__2a__2a_read_2d_illegal ___PRM(48,___G_c_23__2a__2a_read_2d_illegal)
#define ___GLO_c_23__2a__2a_read_2d_list ___GLO(49,___G_c_23__2a__2a_read_2d_list)
#define ___PRM_c_23__2a__2a_read_2d_list ___PRM(49,___G_c_23__2a__2a_read_2d_list)
#define ___GLO_c_23__2a__2a_read_2d_next_2d_char ___GLO(50,___G_c_23__2a__2a_read_2d_next_2d_char)
#define ___PRM_c_23__2a__2a_read_2d_next_2d_char ___PRM(50,___G_c_23__2a__2a_read_2d_next_2d_char)
#define ___GLO_c_23__2a__2a_read_2d_next_2d_char_2d_expecting ___GLO(51,___G_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
#define ___PRM_c_23__2a__2a_read_2d_next_2d_char_2d_expecting ___PRM(51,___G_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
#define ___GLO_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof ___GLO(52,___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
#define ___PRM_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof ___PRM(52,___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
#define ___GLO_c_23__2a__2a_read_2d_none ___GLO(53,___G_c_23__2a__2a_read_2d_none)
#define ___PRM_c_23__2a__2a_read_2d_none ___PRM(53,___G_c_23__2a__2a_read_2d_none)
#define ___GLO_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol ___GLO(54,___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
#define ___PRM_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol ___PRM(54,___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
#define ___GLO_c_23__2a__2a_read_2d_quasiquotation ___GLO(55,___G_c_23__2a__2a_read_2d_quasiquotation)
#define ___PRM_c_23__2a__2a_read_2d_quasiquotation ___PRM(55,___G_c_23__2a__2a_read_2d_quasiquotation)
#define ___GLO_c_23__2a__2a_read_2d_quotation ___GLO(56,___G_c_23__2a__2a_read_2d_quotation)
#define ___PRM_c_23__2a__2a_read_2d_quotation ___PRM(56,___G_c_23__2a__2a_read_2d_quotation)
#define ___GLO_c_23__2a__2a_read_2d_sharp ___GLO(57,___G_c_23__2a__2a_read_2d_sharp)
#define ___PRM_c_23__2a__2a_read_2d_sharp ___PRM(57,___G_c_23__2a__2a_read_2d_sharp)
#define ___GLO_c_23__2a__2a_read_2d_single_2d_line_2d_comment ___GLO(58,___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
#define ___PRM_c_23__2a__2a_read_2d_single_2d_line_2d_comment ___PRM(58,___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
#define ___GLO_c_23__2a__2a_read_2d_unquotation ___GLO(59,___G_c_23__2a__2a_read_2d_unquotation)
#define ___PRM_c_23__2a__2a_read_2d_unquotation ___PRM(59,___G_c_23__2a__2a_read_2d_unquotation)
#define ___GLO_c_23__2a__2a_read_2d_whitespace ___GLO(60,___G_c_23__2a__2a_read_2d_whitespace)
#define ___PRM_c_23__2a__2a_read_2d_whitespace ___PRM(60,___G_c_23__2a__2a_read_2d_whitespace)
#define ___GLO_c_23__2a__2a_readenv_2d_char_2d_count ___GLO(61,___G_c_23__2a__2a_readenv_2d_char_2d_count)
#define ___PRM_c_23__2a__2a_readenv_2d_char_2d_count ___PRM(61,___G_c_23__2a__2a_readenv_2d_char_2d_count)
#define ___GLO_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_ ___GLO(62,___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
#define ___PRM_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_ ___PRM(62,___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
#define ___GLO_c_23__2a__2a_readenv_2d_close ___GLO(63,___G_c_23__2a__2a_readenv_2d_close)
#define ___PRM_c_23__2a__2a_readenv_2d_close ___PRM(63,___G_c_23__2a__2a_readenv_2d_close)
#define ___GLO_c_23__2a__2a_readenv_2d_current_2d_filepos ___GLO(64,___G_c_23__2a__2a_readenv_2d_current_2d_filepos)
#define ___PRM_c_23__2a__2a_readenv_2d_current_2d_filepos ___PRM(64,___G_c_23__2a__2a_readenv_2d_current_2d_filepos)
#define ___GLO_c_23__2a__2a_readenv_2d_error_2d_proc ___GLO(65,___G_c_23__2a__2a_readenv_2d_error_2d_proc)
#define ___PRM_c_23__2a__2a_readenv_2d_error_2d_proc ___PRM(65,___G_c_23__2a__2a_readenv_2d_error_2d_proc)
#define ___GLO_c_23__2a__2a_readenv_2d_filepos ___GLO(66,___G_c_23__2a__2a_readenv_2d_filepos)
#define ___PRM_c_23__2a__2a_readenv_2d_filepos ___PRM(66,___G_c_23__2a__2a_readenv_2d_filepos)
#define ___GLO_c_23__2a__2a_readenv_2d_filepos_2d_set_21_ ___GLO(67,___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
#define ___PRM_c_23__2a__2a_readenv_2d_filepos_2d_set_21_ ___PRM(67,___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
#define ___GLO_c_23__2a__2a_readenv_2d_line_2d_count ___GLO(68,___G_c_23__2a__2a_readenv_2d_line_2d_count)
#define ___PRM_c_23__2a__2a_readenv_2d_line_2d_count ___PRM(68,___G_c_23__2a__2a_readenv_2d_line_2d_count)
#define ___GLO_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_ ___GLO(69,___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
#define ___PRM_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_ ___PRM(69,___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
#define ___GLO_c_23__2a__2a_readenv_2d_line_2d_start ___GLO(70,___G_c_23__2a__2a_readenv_2d_line_2d_start)
#define ___PRM_c_23__2a__2a_readenv_2d_line_2d_start ___PRM(70,___G_c_23__2a__2a_readenv_2d_line_2d_start)
#define ___GLO_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_ ___GLO(71,___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
#define ___PRM_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_ ___PRM(71,___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
#define ___GLO_c_23__2a__2a_readenv_2d_open ___GLO(72,___G_c_23__2a__2a_readenv_2d_open)
#define ___PRM_c_23__2a__2a_readenv_2d_open ___PRM(72,___G_c_23__2a__2a_readenv_2d_open)
#define ___GLO_c_23__2a__2a_readenv_2d_port ___GLO(73,___G_c_23__2a__2a_readenv_2d_port)
#define ___PRM_c_23__2a__2a_readenv_2d_port ___PRM(73,___G_c_23__2a__2a_readenv_2d_port)
#define ___GLO_c_23__2a__2a_readenv_2d_previous_2d_filepos ___GLO(74,___G_c_23__2a__2a_readenv_2d_previous_2d_filepos)
#define ___PRM_c_23__2a__2a_readenv_2d_previous_2d_filepos ___PRM(74,___G_c_23__2a__2a_readenv_2d_previous_2d_filepos)
#define ___GLO_c_23__2a__2a_readenv_2d_readtable ___GLO(75,___G_c_23__2a__2a_readenv_2d_readtable)
#define ___PRM_c_23__2a__2a_readenv_2d_readtable ___PRM(75,___G_c_23__2a__2a_readenv_2d_readtable)
#define ___GLO_c_23__2a__2a_readenv_2d_unwrap ___GLO(76,___G_c_23__2a__2a_readenv_2d_unwrap)
#define ___PRM_c_23__2a__2a_readenv_2d_unwrap ___PRM(76,___G_c_23__2a__2a_readenv_2d_unwrap)
#define ___GLO_c_23__2a__2a_readenv_2d_wrap ___GLO(77,___G_c_23__2a__2a_readenv_2d_wrap)
#define ___PRM_c_23__2a__2a_readenv_2d_wrap ___PRM(77,___G_c_23__2a__2a_readenv_2d_wrap)
#define ___GLO_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_ ___GLO(78,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
#define ___PRM_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_ ___PRM(78,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
#define ___GLO_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_ ___GLO(79,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_ ___PRM(79,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_ ___GLO(80,___G_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_ ___PRM(80,___G_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_ ___GLO(81,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_ ___PRM(81,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_ ___GLO(82,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_ ___PRM(82,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table ___GLO(83,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table ___PRM(83,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_ ___GLO(84,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_ ___PRM(84,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_handler ___GLO(85,___G_c_23__2a__2a_readtable_2d_char_2d_handler)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_handler ___PRM(85,___G_c_23__2a__2a_readtable_2d_char_2d_handler)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_ ___GLO(86,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_ ___PRM(86,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table ___GLO(87,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table ___PRM(87,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
#define ___GLO_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_ ___GLO(88,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_ ___PRM(88,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_convert_2d_case ___GLO(89,___G_c_23__2a__2a_readtable_2d_convert_2d_case)
#define ___PRM_c_23__2a__2a_readtable_2d_convert_2d_case ___PRM(89,___G_c_23__2a__2a_readtable_2d_convert_2d_case)
#define ___GLO_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table ___GLO(90,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
#define ___PRM_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table ___PRM(90,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
#define ___GLO_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_ ___GLO(91,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_ ___PRM(91,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_ ___GLO(92,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
#define ___PRM_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_ ___PRM(92,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
#define ___GLO_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_ ___GLO(93,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_ ___PRM(93,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_named_2d_char_2d_table ___GLO(94,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
#define ___PRM_c_23__2a__2a_readtable_2d_named_2d_char_2d_table ___PRM(94,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
#define ___GLO_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_ ___GLO(95,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_ ___PRM(95,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_parse_2d_keyword ___GLO(96,___G_c_23__2a__2a_readtable_2d_parse_2d_keyword)
#define ___PRM_c_23__2a__2a_readtable_2d_parse_2d_keyword ___PRM(96,___G_c_23__2a__2a_readtable_2d_parse_2d_keyword)
#define ___GLO_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table ___GLO(97,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
#define ___PRM_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table ___PRM(97,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
#define ___GLO_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_ ___GLO(98,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_ ___PRM(98,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_ ___GLO(99,___G_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
#define ___PRM_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_ ___PRM(99,___G_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
#define ___GLO_c_23__2a__2a_readtable_2d_tag ___GLO(100,___G_c_23__2a__2a_readtable_2d_tag)
#define ___PRM_c_23__2a__2a_readtable_2d_tag ___PRM(100,___G_c_23__2a__2a_readtable_2d_tag)
#define ___GLO_c_23__2a__2a_skip_2d_extended_2d_comment ___GLO(101,___G_c_23__2a__2a_skip_2d_extended_2d_comment)
#define ___PRM_c_23__2a__2a_skip_2d_extended_2d_comment ___PRM(101,___G_c_23__2a__2a_skip_2d_extended_2d_comment)
#define ___GLO_c_23__2a__2a_skip_2d_single_2d_line_2d_comment ___GLO(102,___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
#define ___PRM_c_23__2a__2a_skip_2d_single_2d_line_2d_comment ___PRM(102,___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
#define ___GLO_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table ___GLO(103,___G_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table)
#define ___PRM_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table ___PRM(103,___G_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table)
#define ___GLO_c_23__2a__2a_standard_2d_named_2d_char_2d_table ___GLO(104,___G_c_23__2a__2a_standard_2d_named_2d_char_2d_table)
#define ___PRM_c_23__2a__2a_standard_2d_named_2d_char_2d_table ___PRM(104,___G_c_23__2a__2a_standard_2d_named_2d_char_2d_table)
#define ___GLO_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table ___GLO(105,___G_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table)
#define ___PRM_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table ___PRM(105,___G_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table)
#define ___GLO_c_23_expr_2d__3e_locat ___GLO(106,___G_c_23_expr_2d__3e_locat)
#define ___PRM_c_23_expr_2d__3e_locat ___PRM(106,___G_c_23_expr_2d__3e_locat)
#define ___GLO_c_23_expression_2d__3e_source ___GLO(107,___G_c_23_expression_2d__3e_source)
#define ___PRM_c_23_expression_2d__3e_source ___PRM(107,___G_c_23_expression_2d__3e_source)
#define ___GLO_c_23_false_2d_obj ___GLO(108,___G_c_23_false_2d_obj)
#define ___PRM_c_23_false_2d_obj ___PRM(108,___G_c_23_false_2d_obj)
#define ___GLO_c_23_include_2d_expr_2d__3e_source ___GLO(109,___G_c_23_include_2d_expr_2d__3e_source)
#define ___PRM_c_23_include_2d_expr_2d__3e_source ___PRM(109,___G_c_23_include_2d_expr_2d__3e_source)
#define ___GLO_c_23_include_2d_expr_2d__3e_sourcezzzzz ___GLO(110,___G_c_23_include_2d_expr_2d__3e_sourcezzzzz)
#define ___PRM_c_23_include_2d_expr_2d__3e_sourcezzzzz ___PRM(110,___G_c_23_include_2d_expr_2d__3e_sourcezzzzz)
#define ___GLO_c_23_locat_2d_filename ___GLO(111,___G_c_23_locat_2d_filename)
#define ___PRM_c_23_locat_2d_filename ___PRM(111,___G_c_23_locat_2d_filename)
#define ___GLO_c_23_locat_2d_filename_2d_and_2d_line ___GLO(112,___G_c_23_locat_2d_filename_2d_and_2d_line)
#define ___PRM_c_23_locat_2d_filename_2d_and_2d_line ___PRM(112,___G_c_23_locat_2d_filename_2d_and_2d_line)
#define ___GLO_c_23_locat_2d_show ___GLO(113,___G_c_23_locat_2d_show)
#define ___PRM_c_23_locat_2d_show ___PRM(113,___G_c_23_locat_2d_show)
#define ___GLO_c_23_make_2d_source ___GLO(114,___G_c_23_make_2d_source)
#define ___PRM_c_23_make_2d_source ___PRM(114,___G_c_23_make_2d_source)
#define ___GLO_c_23_re_2d__3e_locat ___GLO(115,___G_c_23_re_2d__3e_locat)
#define ___PRM_c_23_re_2d__3e_locat ___PRM(115,___G_c_23_re_2d__3e_locat)
#define ___GLO_c_23_read_2d_source ___GLO(116,___G_c_23_read_2d_source)
#define ___PRM_c_23_read_2d_source ___PRM(116,___G_c_23_read_2d_source)
#define ___GLO_c_23_source_2d__3e_expression ___GLO(117,___G_c_23_source_2d__3e_expression)
#define ___PRM_c_23_source_2d__3e_expression ___PRM(117,___G_c_23_source_2d__3e_expression)
#define ___GLO_c_23_source_2d_code ___GLO(118,___G_c_23_source_2d_code)
#define ___PRM_c_23_source_2d_code ___PRM(118,___G_c_23_source_2d_code)
#define ___GLO_c_23_source_2d_locat ___GLO(119,___G_c_23_source_2d_locat)
#define ___PRM_c_23_source_2d_locat ___PRM(119,___G_c_23_source_2d_locat)
#define ___GLO_c_23_string_2d__3e_canonical_2d_symbol ___GLO(120,___G_c_23_string_2d__3e_canonical_2d_symbol)
#define ___PRM_c_23_string_2d__3e_canonical_2d_symbol ___PRM(120,___G_c_23_string_2d__3e_canonical_2d_symbol)
#define ___GLO__23__23_container_2d__3e_path ___GLO(121,___G__23__23_container_2d__3e_path)
#define ___PRM__23__23_container_2d__3e_path ___PRM(121,___G__23__23_container_2d__3e_path)
#define ___GLO__23__23_current_2d_readtable ___GLO(122,___G__23__23_current_2d_readtable)
#define ___PRM__23__23_current_2d_readtable ___PRM(122,___G__23__23_current_2d_readtable)
#define ___GLO__23__23_filepos_2d__3e_position ___GLO(123,___G__23__23_filepos_2d__3e_position)
#define ___PRM__23__23_filepos_2d__3e_position ___PRM(123,___G__23__23_filepos_2d__3e_position)
#define ___GLO__23__23_integer_3f_ ___GLO(124,___G__23__23_integer_3f_)
#define ___PRM__23__23_integer_3f_ ___PRM(124,___G__23__23_integer_3f_)
#define ___GLO__23__23_locat_2d_container ___GLO(125,___G__23__23_locat_2d_container)
#define ___PRM__23__23_locat_2d_container ___PRM(125,___G__23__23_locat_2d_container)
#define ___GLO__23__23_locat_2d_position ___GLO(126,___G__23__23_locat_2d_position)
#define ___PRM__23__23_locat_2d_position ___PRM(126,___G__23__23_locat_2d_position)
#define ___GLO__23__23_make_2d_locat ___GLO(127,___G__23__23_make_2d_locat)
#define ___PRM__23__23_make_2d_locat ___PRM(127,___G__23__23_make_2d_locat)
#define ___GLO__23__23_make_2d_source ___GLO(128,___G__23__23_make_2d_source)
#define ___PRM__23__23_make_2d_source ___PRM(128,___G__23__23_make_2d_source)
#define ___GLO__23__23_path_2d__3e_container ___GLO(129,___G__23__23_path_2d__3e_container)
#define ___PRM__23__23_path_2d__3e_container ___PRM(129,___G__23__23_path_2d__3e_container)
#define ___GLO__23__23_path_2d_reference ___GLO(130,___G__23__23_path_2d_reference)
#define ___PRM__23__23_path_2d_reference ___PRM(130,___G__23__23_path_2d_reference)
#define ___GLO__23__23_port_2d_name ___GLO(131,___G__23__23_port_2d_name)
#define ___PRM__23__23_port_2d_name ___PRM(131,___G__23__23_port_2d_name)
#define ___GLO__23__23_position_2d__3e_filepos ___GLO(132,___G__23__23_position_2d__3e_filepos)
#define ___PRM__23__23_position_2d__3e_filepos ___PRM(132,___G__23__23_position_2d__3e_filepos)
#define ___GLO__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_path ___GLO(133,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_path)
#define ___PRM__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_path ___PRM(133,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_path)
#define ___GLO__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port ___GLO(134,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
#define ___PRM__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port ___PRM(134,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
#define ___GLO__23__23_real_3f_ ___GLO(135,___G__23__23_real_3f_)
#define ___PRM__23__23_real_3f_ ___PRM(135,___G__23__23_real_3f_)
#define ___GLO__23__23_scheme_2d_file_2d_extensions ___GLO(136,___G__23__23_scheme_2d_file_2d_extensions)
#define ___PRM__23__23_scheme_2d_file_2d_extensions ___PRM(136,___G__23__23_scheme_2d_file_2d_extensions)
#define ___GLO__23__23_source_2d_code ___GLO(137,___G__23__23_source_2d_code)
#define ___PRM__23__23_source_2d_code ___PRM(137,___G__23__23_source_2d_code)
#define ___GLO__23__23_source_2d_locat ___GLO(138,___G__23__23_source_2d_locat)
#define ___PRM__23__23_source_2d_locat ___PRM(138,___G__23__23_source_2d_locat)
#define ___GLO_append ___GLO(139,___G_append)
#define ___PRM_append ___PRM(139,___G_append)
#define ___GLO_apply ___GLO(140,___G_apply)
#define ___PRM_apply ___PRM(140,___G_apply)
#define ___GLO_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_ ___GLO(141,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
#define ___PRM_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_ ___PRM(141,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
#define ___GLO_c_23_box_2d_object ___GLO(142,___G_c_23_box_2d_object)
#define ___PRM_c_23_box_2d_object ___PRM(142,___G_c_23_box_2d_object)
#define ___GLO_c_23_box_2d_object_3f_ ___GLO(143,___G_c_23_box_2d_object_3f_)
#define ___PRM_c_23_box_2d_object_3f_ ___PRM(143,___G_c_23_box_2d_object_3f_)
#define ___GLO_c_23_character_2d__3e_unicode ___GLO(144,___G_c_23_character_2d__3e_unicode)
#define ___PRM_c_23_character_2d__3e_unicode ___PRM(144,___G_c_23_character_2d__3e_unicode)
#define ___GLO_c_23_compiler_2d_error ___GLO(145,___G_c_23_compiler_2d_error)
#define ___PRM_c_23_compiler_2d_error ___PRM(145,___G_c_23_compiler_2d_error)
#define ___GLO_c_23_compiler_2d_user_2d_error ___GLO(146,___G_c_23_compiler_2d_user_2d_error)
#define ___PRM_c_23_compiler_2d_user_2d_error ___PRM(146,___G_c_23_compiler_2d_user_2d_error)
#define ___GLO_c_23_end_2d_of_2d_file_2d_object ___GLO(147,___G_c_23_end_2d_of_2d_file_2d_object)
#define ___PRM_c_23_end_2d_of_2d_file_2d_object ___PRM(147,___G_c_23_end_2d_of_2d_file_2d_object)
#define ___GLO_c_23_f32vect_2d_set_21_ ___GLO(148,___G_c_23_f32vect_2d_set_21_)
#define ___PRM_c_23_f32vect_2d_set_21_ ___PRM(148,___G_c_23_f32vect_2d_set_21_)
#define ___GLO_c_23_f64vect_2d_set_21_ ___GLO(149,___G_c_23_f64vect_2d_set_21_)
#define ___PRM_c_23_f64vect_2d_set_21_ ___PRM(149,___G_c_23_f64vect_2d_set_21_)
#define ___GLO_c_23_false_2d_object ___GLO(150,___G_c_23_false_2d_object)
#define ___PRM_c_23_false_2d_object ___PRM(150,___G_c_23_false_2d_object)
#define ___GLO_c_23_format_2d_filepos ___GLO(151,___G_c_23_format_2d_filepos)
#define ___PRM_c_23_format_2d_filepos ___PRM(151,___G_c_23_format_2d_filepos)
#define ___GLO_c_23_in_2d_char_2d_range_3f_ ___GLO(152,___G_c_23_in_2d_char_2d_range_3f_)
#define ___PRM_c_23_in_2d_char_2d_range_3f_ ___PRM(152,___G_c_23_in_2d_char_2d_range_3f_)
#define ___GLO_c_23_in_2d_integer_2d_range_3f_ ___GLO(153,___G_c_23_in_2d_integer_2d_range_3f_)
#define ___PRM_c_23_in_2d_integer_2d_range_3f_ ___PRM(153,___G_c_23_in_2d_integer_2d_range_3f_)
#define ___GLO_c_23_key_2d_object ___GLO(154,___G_c_23_key_2d_object)
#define ___PRM_c_23_key_2d_object ___PRM(154,___G_c_23_key_2d_object)
#define ___GLO_c_23_make_2d_f32vect ___GLO(155,___G_c_23_make_2d_f32vect)
#define ___PRM_c_23_make_2d_f32vect ___PRM(155,___G_c_23_make_2d_f32vect)
#define ___GLO_c_23_make_2d_f64vect ___GLO(156,___G_c_23_make_2d_f64vect)
#define ___PRM_c_23_make_2d_f64vect ___PRM(156,___G_c_23_make_2d_f64vect)
#define ___GLO_c_23_make_2d_u16vect ___GLO(157,___G_c_23_make_2d_u16vect)
#define ___PRM_c_23_make_2d_u16vect ___PRM(157,___G_c_23_make_2d_u16vect)
#define ___GLO_c_23_make_2d_u32vect ___GLO(158,___G_c_23_make_2d_u32vect)
#define ___PRM_c_23_make_2d_u32vect ___PRM(158,___G_c_23_make_2d_u32vect)
#define ___GLO_c_23_make_2d_u64vect ___GLO(159,___G_c_23_make_2d_u64vect)
#define ___PRM_c_23_make_2d_u64vect ___PRM(159,___G_c_23_make_2d_u64vect)
#define ___GLO_c_23_make_2d_u8vect ___GLO(160,___G_c_23_make_2d_u8vect)
#define ___PRM_c_23_make_2d_u8vect ___PRM(160,___G_c_23_make_2d_u8vect)
#define ___GLO_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines ___GLO(161,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
#define ___PRM_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines ___PRM(161,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
#define ___GLO_c_23_max_2d_lines ___GLO(162,___G_c_23_max_2d_lines)
#define ___PRM_c_23_max_2d_lines ___PRM(162,___G_c_23_max_2d_lines)
#define ___GLO_c_23_open_2d_input_2d_file_2a_ ___GLO(163,___G_c_23_open_2d_input_2d_file_2a_)
#define ___PRM_c_23_open_2d_input_2d_file_2a_ ___PRM(163,___G_c_23_open_2d_input_2d_file_2a_)
#define ___GLO_c_23_optional_2d_object ___GLO(164,___G_c_23_optional_2d_object)
#define ___PRM_c_23_optional_2d_object ___PRM(164,___G_c_23_optional_2d_object)
#define ___GLO_c_23_pt_2d_syntax_2d_error ___GLO(165,___G_c_23_pt_2d_syntax_2d_error)
#define ___PRM_c_23_pt_2d_syntax_2d_error ___PRM(165,___G_c_23_pt_2d_syntax_2d_error)
#define ___GLO_c_23_quasiquote_2d_sym ___GLO(166,___G_c_23_quasiquote_2d_sym)
#define ___PRM_c_23_quasiquote_2d_sym ___PRM(166,___G_c_23_quasiquote_2d_sym)
#define ___GLO_c_23_quote_2d_sym ___GLO(167,___G_c_23_quote_2d_sym)
#define ___PRM_c_23_quote_2d_sym ___PRM(167,___G_c_23_quote_2d_sym)
#define ___GLO_c_23_rest_2d_object ___GLO(168,___G_c_23_rest_2d_object)
#define ___PRM_c_23_rest_2d_object ___PRM(168,___G_c_23_rest_2d_object)
#define ___GLO_c_23_scheme_2d_file_2d_extensions ___GLO(169,___G_c_23_scheme_2d_file_2d_extensions)
#define ___PRM_c_23_scheme_2d_file_2d_extensions ___PRM(169,___G_c_23_scheme_2d_file_2d_extensions)
#define ___GLO_c_23_string_2d__3e_keyword_2d_object ___GLO(170,___G_c_23_string_2d__3e_keyword_2d_object)
#define ___PRM_c_23_string_2d__3e_keyword_2d_object ___PRM(170,___G_c_23_string_2d__3e_keyword_2d_object)
#define ___GLO_c_23_u16vect_2d_set_21_ ___GLO(171,___G_c_23_u16vect_2d_set_21_)
#define ___PRM_c_23_u16vect_2d_set_21_ ___PRM(171,___G_c_23_u16vect_2d_set_21_)
#define ___GLO_c_23_u32vect_2d_set_21_ ___GLO(172,___G_c_23_u32vect_2d_set_21_)
#define ___PRM_c_23_u32vect_2d_set_21_ ___PRM(172,___G_c_23_u32vect_2d_set_21_)
#define ___GLO_c_23_u64vect_2d_set_21_ ___GLO(173,___G_c_23_u64vect_2d_set_21_)
#define ___PRM_c_23_u64vect_2d_set_21_ ___PRM(173,___G_c_23_u64vect_2d_set_21_)
#define ___GLO_c_23_u8vect_2d_set_21_ ___GLO(174,___G_c_23_u8vect_2d_set_21_)
#define ___PRM_c_23_u8vect_2d_set_21_ ___PRM(174,___G_c_23_u8vect_2d_set_21_)
#define ___GLO_c_23_unbox_2d_object ___GLO(175,___G_c_23_unbox_2d_object)
#define ___PRM_c_23_unbox_2d_object ___PRM(175,___G_c_23_unbox_2d_object)
#define ___GLO_c_23_unicode_2d__3e_character ___GLO(176,___G_c_23_unicode_2d__3e_character)
#define ___PRM_c_23_unicode_2d__3e_character ___PRM(176,___G_c_23_unicode_2d__3e_character)
#define ___GLO_c_23_unquote_2d_splicing_2d_sym ___GLO(177,___G_c_23_unquote_2d_splicing_2d_sym)
#define ___PRM_c_23_unquote_2d_splicing_2d_sym ___PRM(177,___G_c_23_unquote_2d_splicing_2d_sym)
#define ___GLO_c_23_unquote_2d_sym ___GLO(178,___G_c_23_unquote_2d_sym)
#define ___PRM_c_23_unquote_2d_sym ___PRM(178,___G_c_23_unquote_2d_sym)
#define ___GLO_c_23_vector_2d_object_3f_ ___GLO(179,___G_c_23_vector_2d_object_3f_)
#define ___PRM_c_23_vector_2d_object_3f_ ___PRM(179,___G_c_23_vector_2d_object_3f_)
#define ___GLO_close_2d_input_2d_port ___GLO(180,___G_close_2d_input_2d_port)
#define ___PRM_close_2d_input_2d_port ___PRM(180,___G_close_2d_input_2d_port)
#define ___GLO_display ___GLO(181,___G_display)
#define ___PRM_display ___PRM(181,___G_display)
#define ___GLO_equal_3f_ ___GLO(182,___G_equal_3f_)
#define ___PRM_equal_3f_ ___PRM(182,___G_equal_3f_)
#define ___GLO_exact_3f_ ___GLO(183,___G_exact_3f_)
#define ___PRM_exact_3f_ ___PRM(183,___G_exact_3f_)
#define ___GLO_make_2d_string ___GLO(184,___G_make_2d_string)
#define ___PRM_make_2d_string ___PRM(184,___G_make_2d_string)
#define ___GLO_make_2d_vector ___GLO(185,___G_make_2d_vector)
#define ___PRM_make_2d_vector ___PRM(185,___G_make_2d_vector)
#define ___GLO_open_2d_input_2d_file ___GLO(186,___G_open_2d_input_2d_file)
#define ___PRM_open_2d_input_2d_file ___PRM(186,___G_open_2d_input_2d_file)
#define ___GLO_path_2d_directory ___GLO(187,___G_path_2d_directory)
#define ___PRM_path_2d_directory ___PRM(187,___G_path_2d_directory)
#define ___GLO_path_2d_expand ___GLO(188,___G_path_2d_expand)
#define ___PRM_path_2d_expand ___PRM(188,___G_path_2d_expand)
#define ___GLO_path_2d_extension ___GLO(189,___G_path_2d_extension)
#define ___PRM_path_2d_extension ___PRM(189,___G_path_2d_extension)
#define ___GLO_peek_2d_char ___GLO(190,___G_peek_2d_char)
#define ___PRM_peek_2d_char ___PRM(190,___G_peek_2d_char)
#define ___GLO_read_2d_char ___GLO(191,___G_read_2d_char)
#define ___PRM_read_2d_char ___PRM(191,___G_read_2d_char)
#define ___GLO_reverse ___GLO(192,___G_reverse)
#define ___PRM_reverse ___PRM(192,___G_reverse)
#define ___GLO_string_2d__3e_number ___GLO(193,___G_string_2d__3e_number)
#define ___PRM_string_2d__3e_number ___PRM(193,___G_string_2d__3e_number)
#define ___GLO_string_2d__3e_symbol ___GLO(194,___G_string_2d__3e_symbol)
#define ___PRM_string_2d__3e_symbol ___PRM(194,___G_string_2d__3e_symbol)
#define ___GLO_string_2d_append ___GLO(195,___G_string_2d_append)
#define ___PRM_string_2d_append ___PRM(195,___G_string_2d_append)
#define ___GLO_string_2d_ci_3d__3f_ ___GLO(196,___G_string_2d_ci_3d__3f_)
#define ___PRM_string_2d_ci_3d__3f_ ___PRM(196,___G_string_2d_ci_3d__3f_)
#define ___GLO_string_3d__3f_ ___GLO(197,___G_string_3d__3f_)
#define ___PRM_string_3d__3f_ ___PRM(197,___G_string_3d__3f_)
#define ___GLO_substring ___GLO(198,___G_substring)
#define ___PRM_substring ___PRM(198,___G_substring)
#define ___GLO_write ___GLO(199,___G_write)
#define ___PRM_write ___PRM(199,___G_write)

___BEGIN_CNS
 ___DEF_CNS(___REF_SUB(35),___REF_NUL)
___END_CNS

___DEF_SUB_STR(___X0,3)
               ___STR3(110,117,108)
___DEF_SUB_STR(___X1,3)
               ___STR3(98,101,108)
___DEF_SUB_STR(___X2,9)
               ___STR8(98,97,99,107,115,112,97,99)
               ___STR1(101)
___DEF_SUB_STR(___X3,3)
               ___STR3(116,97,98)
___DEF_SUB_STR(___X4,8)
               ___STR8(108,105,110,101,102,101,101,100)
               ___STR0
___DEF_SUB_STR(___X5,2)
               ___STR2(118,116)
___DEF_SUB_STR(___X6,4)
               ___STR4(112,97,103,101)
___DEF_SUB_STR(___X7,6)
               ___STR6(114,101,116,117,114,110)
___DEF_SUB_STR(___X8,6)
               ___STR6(114,117,98,111,117,116)
___DEF_SUB_STR(___X9,5)
               ___STR5(115,112,97,99,101)
___DEF_SUB_STR(___X10,7)
               ___STR7(110,101,119,108,105,110,101)
___DEF_SUB_STR(___X11,3)
               ___STR3(101,111,102)
___DEF_SUB_STR(___X12,3)
               ___STR3(107,101,121)
___DEF_SUB_STR(___X13,4)
               ___STR4(114,101,115,116)
___DEF_SUB_STR(___X14,8)
               ___STR8(111,112,116,105,111,110,97,108)
               ___STR0
___DEF_SUB_STR(___X15,8)
               ___STR8(117,110,98,111,117,110,100,50)
               ___STR0
___DEF_SUB_STR(___X16,8)
               ___STR8(117,110,98,111,117,110,100,49)
               ___STR0
___DEF_SUB_STR(___X17,4)
               ___STR4(118,111,105,100)
___DEF_SUB_VEC(___X18,2)
               ___VEC1(___REF_SYM(21,___S_readtable))
               ___VEC1(___REF_FIX(0))
               ___VEC0
___DEF_SUB_STR(___X19,0)
               ___STR0
___DEF_SUB_STR(___X20,1)
               ___STR1(32)
___DEF_SUB_STR(___X21,16)
               ___STR8(85,78,75,78,79,87,78,32)
               ___STR8(76,79,67,65,84,73,79,78)
               ___STR0
___DEF_SUB_STR(___X22,1)
               ___STR1(64)
___DEF_SUB_STR(___X23,1)
               ___STR1(46)
___DEF_SUB_STR(___X24,11)
               ___STR8(69,88,80,82,69,83,83,73)
               ___STR3(79,78,32)
___DEF_SUB_STR(___X25,0)
               ___STR0
___DEF_SUB_STR(___X26,0)
               ___STR0
___DEF_SUB_STR(___X27,15)
               ___STR8(67,97,110,39,116,32,102,105)
               ___STR7(110,100,32,102,105,108,101)
___DEF_SUB_STR(___X28,1)
               ___STR1(41)
___DEF_SUB_STRUCTURE(___X29,6)
               ___VEC1(___REF_SUB(30))
               ___VEC1(___REF_SYM(1,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55))
               ___VEC1(___REF_SYM(20,___S_readenv))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(32))
               ___VEC0
___DEF_SUB_STRUCTURE(___X30,6)
               ___VEC1(___REF_SUB(30))
               ___VEC1(___REF_SYM(0,___S__23__23_type_2d_5))
               ___VEC1(___REF_SYM(23,___S_type))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(31))
               ___VEC0
___DEF_SUB_VEC(___X31,15)
               ___VEC1(___REF_SYM(11,___S_id))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(13,___S_name))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(10,___S_flags))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(22,___S_super))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(8,___S_fields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X32,27)
               ___VEC1(___REF_SYM(15,___S_port))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(21,___S_readtable))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(33,___S_wrapper))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(30,___S_unwrapper))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(3,___S_allow_2d_script_3f_))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(12,___S_labels))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(4,___S_container))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(9,___S_filepos))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(19,___S_read_2d_cont))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STR(___X33,9)
               ___STR8(40,114,101,97,100,105,110,103)
               ___STR1(32)
___DEF_SUB_STR(___X34,0)
               ___STR0
___DEF_SUB_STR(___X35,0)
               ___STR0
___DEF_SUB_STR(___X36,15)
               ___STR8(67,97,110,39,116,32,102,105)
               ___STR7(110,100,32,102,105,108,101)
___DEF_SUB_STR(___X37,0)
               ___STR0
___DEF_SUB_STR(___X38,21)
               ___STR8(68,97,116,117,109,32,111,114)
               ___STR8(32,69,79,70,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X39,14)
               ___STR8(68,97,116,117,109,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X40,21)
               ___STR8(73,109,112,114,111,112,101,114)
               ___STR8(108,121,32,112,108,97,99,101)
               ___STR5(100,32,100,111,116)
___DEF_SUB_STR(___X41,28)
               ___STR8(73,110,99,111,109,112,108,101)
               ___STR8(116,101,32,102,111,114,109,44)
               ___STR8(32,69,79,70,32,114,101,97)
               ___STR4(99,104,101,100)
___DEF_SUB_STR(___X42,15)
               ___STR8(73,110,99,111,109,112,108,101)
               ___STR7(116,101,32,102,111,114,109)
___DEF_SUB_STR(___X43,18)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(39,35,92,39,32,110,97,109)
               ___STR2(101,58)
___DEF_SUB_STR(___X44,18)
               ___STR8(73,108,108,101,103,97,108,32)
               ___STR8(99,104,97,114,97,99,116,101)
               ___STR2(114,58)
___DEF_SUB_STR(___X45,28)
               ___STR8(56,32,98,105,116,32,101,120)
               ___STR8(97,99,116,32,105,110,116,101)
               ___STR8(103,101,114,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X46,29)
               ___STR8(49,54,32,98,105,116,32,101)
               ___STR8(120,97,99,116,32,105,110,116)
               ___STR8(101,103,101,114,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X47,29)
               ___STR8(51,50,32,98,105,116,32,101)
               ___STR8(120,97,99,116,32,105,110,116)
               ___STR8(101,103,101,114,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X48,29)
               ___STR8(54,52,32,98,105,116,32,101)
               ___STR8(120,97,99,116,32,105,110,116)
               ___STR8(101,103,101,114,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X49,21)
               ___STR8(73,110,101,120,97,99,116,32)
               ___STR8(114,101,97,108,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X50,26)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(104,101,120,97,100,101,99,105)
               ___STR8(109,97,108,32,101,115,99,97)
               ___STR2(112,101)
___DEF_SUB_STR(___X51,26)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(101,115,99,97,112,101,100,32)
               ___STR8(99,104,97,114,97,99,116,101)
               ___STR2(114,58)
___DEF_SUB_STR(___X52,12)
               ___STR8(39,40,39,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X53,14)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR6(116,111,107,101,110,58)
___DEF_SUB_STR(___X54,18)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(39,35,33,39,32,110,97,109)
               ___STR2(101,58)
___DEF_SUB_STR(___X55,22)
               ___STR8(67,104,97,114,97,99,116,101)
               ___STR8(114,32,111,117,116,32,111,102)
               ___STR6(32,114,97,110,103,101)
___DEF_SUB_VEC(___X56,1)
               ___VEC1(___REF_SYM(14,___S_none))
               ___VEC0
___DEF_SUB_VEC(___X57,1)
               ___VEC1(___REF_SYM(5,___S_dot))
               ___VEC0
___DEF_SUB_BIG(___X58,3)
               ___BIG2(-0x1L,-0x1L)
               ___BIG1(0x0L)
___DEF_SUB_BIGFIX(___X59,2)
               ___BIGFIX2(-0x1L,0x0L)
               ___BIGFIX0
___DEF_SUB_STR(___X60,2)
               ___STR2(35,102)
___DEF_SUB_STR(___X61,2)
               ___STR2(35,116)
___DEF_SUB_STR(___X62,3)
               ___STR3(35,117,56)
___DEF_SUB_STR(___X63,4)
               ___STR4(35,117,49,54)
___DEF_SUB_STR(___X64,4)
               ___STR4(35,117,51,50)
___DEF_SUB_STR(___X65,4)
               ___STR4(35,117,54,52)
___DEF_SUB_STR(___X66,4)
               ___STR4(35,102,51,50)
___DEF_SUB_STR(___X67,4)
               ___STR4(35,102,54,52)
___DEF_SUB_VEC(___X68,5)
               ___VEC1(___REF_SYM(2,___S___source))
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
___DEF_M_HLBL(___L0__20___source)
___DEF_M_HLBL(___L1__20___source)
___DEF_M_HLBL(___L2__20___source)
___DEF_M_HLBL(___L3__20___source)
___DEF_M_HLBL(___L4__20___source)
___DEF_M_HLBL(___L5__20___source)
___DEF_M_HLBL(___L6__20___source)
___DEF_M_HLBL(___L7__20___source)
___DEF_M_HLBL(___L8__20___source)
___DEF_M_HLBL(___L9__20___source)
___DEF_M_HLBL(___L10__20___source)
___DEF_M_HLBL(___L11__20___source)
___DEF_M_HLBL(___L12__20___source)
___DEF_M_HLBL(___L13__20___source)
___DEF_M_HLBL(___L14__20___source)
___DEF_M_HLBL(___L15__20___source)
___DEF_M_HLBL(___L16__20___source)
___DEF_M_HLBL(___L17__20___source)
___DEF_M_HLBL(___L18__20___source)
___DEF_M_HLBL(___L19__20___source)
___DEF_M_HLBL(___L20__20___source)
___DEF_M_HLBL(___L21__20___source)
___DEF_M_HLBL(___L22__20___source)
___DEF_M_HLBL(___L23__20___source)
___DEF_M_HLBL(___L24__20___source)
___DEF_M_HLBL(___L25__20___source)
___DEF_M_HLBL(___L26__20___source)
___DEF_M_HLBL(___L27__20___source)
___DEF_M_HLBL(___L28__20___source)
___DEF_M_HLBL(___L29__20___source)
___DEF_M_HLBL(___L30__20___source)
___DEF_M_HLBL(___L31__20___source)
___DEF_M_HLBL(___L32__20___source)
___DEF_M_HLBL(___L33__20___source)
___DEF_M_HLBL(___L34__20___source)
___DEF_M_HLBL(___L35__20___source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_make_2d_source)
___DEF_M_HLBL(___L1_c_23_make_2d_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_source_2d_code)
___DEF_M_HLBL(___L1_c_23_source_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_source_2d_locat)
___DEF_M_HLBL(___L1_c_23_source_2d_locat)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_make_2d_readenv)
___DEF_M_HLBL(___L1_c_23__2a__2a_make_2d_readenv)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_port)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_readtable)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_error_2d_proc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_wrap)
___DEF_M_HLBL(___L1_c_23__2a__2a_readenv_2d_wrap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_unwrap)
___DEF_M_HLBL(___L1_c_23__2a__2a_readenv_2d_unwrap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_filepos)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_count)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_char_2d_count)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_start)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_M_HLBL(___L1_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___DEF_M_HLBL(___L1_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL(___L1_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL(___L1_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL(___L2_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL(___L3_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL(___L4_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL(___L5_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL(___L6_c_23__2a__2a_make_2d_filepos)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_filepos_2d_line)
___DEF_M_HLBL(___L1_c_23__2a__2a_filepos_2d_line)
___DEF_M_HLBL(___L2_c_23__2a__2a_filepos_2d_line)
___DEF_M_HLBL(___L3_c_23__2a__2a_filepos_2d_line)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_filepos_2d_col)
___DEF_M_HLBL(___L1_c_23__2a__2a_filepos_2d_col)
___DEF_M_HLBL(___L2_c_23__2a__2a_filepos_2d_col)
___DEF_M_HLBL(___L3_c_23__2a__2a_filepos_2d_col)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L1_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L2_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L3_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L4_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L5_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L6_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L7_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L8_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L9_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L10_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L11_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L12_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L13_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L14_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL(___L15_c_23__2a__2a_readenv_2d_open)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readenv_2d_close)
___DEF_M_HLBL(___L1_c_23__2a__2a_readenv_2d_close)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_false_2d_obj)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L1_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L2_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L3_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L4_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L5_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L6_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L7_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L8_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL(___L9_c_23__2a__2a_append_2d_strings)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_M_HLBL(___L1_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_M_HLBL(___L2_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_M_HLBL(___L3_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_M_HLBL(___L4_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_re_2d__3e_locat)
___DEF_M_HLBL(___L1_c_23_re_2d__3e_locat)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_expr_2d__3e_locat)
___DEF_M_HLBL(___L1_c_23_expr_2d__3e_locat)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_locat_2d_show)
___DEF_M_HLBL(___L1_c_23_locat_2d_show)
___DEF_M_HLBL(___L2_c_23_locat_2d_show)
___DEF_M_HLBL(___L3_c_23_locat_2d_show)
___DEF_M_HLBL(___L4_c_23_locat_2d_show)
___DEF_M_HLBL(___L5_c_23_locat_2d_show)
___DEF_M_HLBL(___L6_c_23_locat_2d_show)
___DEF_M_HLBL(___L7_c_23_locat_2d_show)
___DEF_M_HLBL(___L8_c_23_locat_2d_show)
___DEF_M_HLBL(___L9_c_23_locat_2d_show)
___DEF_M_HLBL(___L10_c_23_locat_2d_show)
___DEF_M_HLBL(___L11_c_23_locat_2d_show)
___DEF_M_HLBL(___L12_c_23_locat_2d_show)
___DEF_M_HLBL(___L13_c_23_locat_2d_show)
___DEF_M_HLBL(___L14_c_23_locat_2d_show)
___DEF_M_HLBL(___L15_c_23_locat_2d_show)
___DEF_M_HLBL(___L16_c_23_locat_2d_show)
___DEF_M_HLBL(___L17_c_23_locat_2d_show)
___DEF_M_HLBL(___L18_c_23_locat_2d_show)
___DEF_M_HLBL(___L19_c_23_locat_2d_show)
___DEF_M_HLBL(___L20_c_23_locat_2d_show)
___DEF_M_HLBL(___L21_c_23_locat_2d_show)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L1_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L2_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L3_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L4_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L5_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L6_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L7_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L8_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L9_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L10_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL(___L11_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_locat_2d_filename)
___DEF_M_HLBL(___L1_c_23_locat_2d_filename)
___DEF_M_HLBL(___L2_c_23_locat_2d_filename)
___DEF_M_HLBL(___L3_c_23_locat_2d_filename)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L1_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L2_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L3_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L4_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L5_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L6_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L7_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L8_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L9_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L10_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L11_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L12_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L13_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L14_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L15_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L16_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L17_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L18_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L19_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L20_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L21_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L22_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L23_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L24_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L25_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L26_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L27_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L28_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L29_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L30_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L31_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L32_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L33_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L34_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L35_c_23_expression_2d__3e_source)
___DEF_M_HLBL(___L36_c_23_expression_2d__3e_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L1_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L2_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L3_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L4_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L5_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L6_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L7_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L8_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L9_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L10_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L11_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L12_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L13_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L14_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L15_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L16_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L17_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L18_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L19_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L20_c_23_source_2d__3e_expression)
___DEF_M_HLBL(___L21_c_23_source_2d__3e_expression)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L1_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L2_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L3_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L4_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L5_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L6_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L7_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L8_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L9_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L10_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L11_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L12_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L13_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L14_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L15_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L16_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L17_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L18_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L19_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L20_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L21_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L22_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L23_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L24_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L25_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L26_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L27_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L28_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L29_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L30_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L31_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L32_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L33_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L34_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L35_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L36_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L37_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L38_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L39_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L40_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L41_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L42_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L43_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L44_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L45_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L46_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L47_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L48_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L49_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL(___L50_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_read_2d_source)
___DEF_M_HLBL(___L1_c_23_read_2d_source)
___DEF_M_HLBL(___L2_c_23_read_2d_source)
___DEF_M_HLBL(___L3_c_23_read_2d_source)
___DEF_M_HLBL(___L4_c_23_read_2d_source)
___DEF_M_HLBL(___L5_c_23_read_2d_source)
___DEF_M_HLBL(___L6_c_23_read_2d_source)
___DEF_M_HLBL(___L7_c_23_read_2d_source)
___DEF_M_HLBL(___L8_c_23_read_2d_source)
___DEF_M_HLBL(___L9_c_23_read_2d_source)
___DEF_M_HLBL(___L10_c_23_read_2d_source)
___DEF_M_HLBL(___L11_c_23_read_2d_source)
___DEF_M_HLBL(___L12_c_23_read_2d_source)
___DEF_M_HLBL(___L13_c_23_read_2d_source)
___DEF_M_HLBL(___L14_c_23_read_2d_source)
___DEF_M_HLBL(___L15_c_23_read_2d_source)
___DEF_M_HLBL(___L16_c_23_read_2d_source)
___DEF_M_HLBL(___L17_c_23_read_2d_source)
___DEF_M_HLBL(___L18_c_23_read_2d_source)
___DEF_M_HLBL(___L19_c_23_read_2d_source)
___DEF_M_HLBL(___L20_c_23_read_2d_source)
___DEF_M_HLBL(___L21_c_23_read_2d_source)
___DEF_M_HLBL(___L22_c_23_read_2d_source)
___DEF_M_HLBL(___L23_c_23_read_2d_source)
___DEF_M_HLBL(___L24_c_23_read_2d_source)
___DEF_M_HLBL(___L25_c_23_read_2d_source)
___DEF_M_HLBL(___L26_c_23_read_2d_source)
___DEF_M_HLBL(___L27_c_23_read_2d_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L1_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L2_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L3_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L4_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L5_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L6_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL(___L7_c_23_include_2d_expr_2d__3e_source)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_make_2d_chartable)
___DEF_M_HLBL(___L1_c_23__2a__2a_make_2d_chartable)
___DEF_M_HLBL(___L2_c_23__2a__2a_make_2d_chartable)
___DEF_M_HLBL(___L3_c_23__2a__2a_make_2d_chartable)
___DEF_M_HLBL(___L4_c_23__2a__2a_make_2d_chartable)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L1_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L2_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L3_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L4_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L5_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L6_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL(___L7_c_23__2a__2a_chartable_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L1_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L2_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L3_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L4_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L5_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L6_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L7_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL(___L8_c_23__2a__2a_chartable_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_make_2d_readtable)
___DEF_M_HLBL(___L1_c_23__2a__2a_make_2d_readtable)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_handler)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_M_HLBL(___L2_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_M_HLBL(___L3_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_convert_2d_case)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_M_HLBL(___L2_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_M_HLBL(___L3_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_M_HLBL(___L4_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_M_HLBL(___L1_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_M_HLBL(___L2_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_M_HLBL(___L3_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_M_HLBL(___L4_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_incomplete)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_incomplete)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_char_2d_name)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_char_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u8)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u8)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u16)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u16)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u32)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u32)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u64)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u64)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_hex)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_hex)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_vector)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_M_HLBL(___L1_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_M_HLBL(___L2_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_M_HLBL(___L3_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_M_HLBL(___L4_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_next_2d_char)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_next_2d_char)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_next_2d_char)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_next_2d_char)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_next_2d_char)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L7_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L8_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL(___L9_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_datum)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_none_2d_marker)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_dot_2d_marker)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L1_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L2_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L3_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L4_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L5_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L6_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L7_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L8_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L9_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L10_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L11_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L12_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L13_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L14_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L15_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL(___L16_c_23__2a__2a_build_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L1_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L2_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L3_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L4_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L5_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L6_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L7_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L8_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L9_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L10_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L11_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L12_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L13_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L14_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L15_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L16_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L17_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L18_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L19_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L20_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L21_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L22_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L23_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L24_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L25_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L26_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L27_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L28_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L29_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L30_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L31_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L32_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L33_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L34_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L35_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L36_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L37_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L38_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L39_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L40_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L41_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L42_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L43_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L44_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L45_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L46_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L47_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL(___L48_c_23__2a__2a_build_2d_vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L1_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L2_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L3_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L4_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L5_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L6_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L7_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L8_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL(___L9_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L1_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L2_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L3_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L4_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L5_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L6_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L7_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_M_HLBL(___L1_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_M_HLBL(___L2_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_M_HLBL(___L3_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_M_HLBL(___L4_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L1_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L2_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L3_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L4_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L5_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L6_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L7_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L8_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L9_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L10_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L11_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L12_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L13_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L14_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L15_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L16_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L17_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L18_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L19_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L20_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L21_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L22_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L23_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L24_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L25_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L26_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L27_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L28_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L29_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L30_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L31_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L32_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L33_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L34_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L35_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L36_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L37_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L38_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L39_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L40_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L41_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L42_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L43_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL(___L44_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L1_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L2_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L3_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L4_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L5_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L6_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L7_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L8_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L9_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L10_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L11_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L12_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L13_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L14_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L15_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL(___L16_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L1_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L2_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L3_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L4_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L5_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L6_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L7_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L8_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L9_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L10_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L11_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L12_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L13_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L14_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L15_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L16_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L17_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L18_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L19_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L20_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L21_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L22_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L23_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L24_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L25_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L26_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L27_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L28_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L29_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L30_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L31_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L32_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L33_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L34_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L35_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L36_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L37_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L38_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L39_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L40_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L41_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L42_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L43_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L44_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L45_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L46_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L47_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L48_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L49_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL(___L50_c_23__2a__2a_read_2d_sharp)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_whitespace)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_whitespace)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_whitespace)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_whitespace)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL(___L7_c_23__2a__2a_read_2d_quotation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL(___L7_c_23__2a__2a_read_2d_quasiquotation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L7_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L8_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L9_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL(___L10_c_23__2a__2a_read_2d_unquotation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_list)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_list)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_list)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_list)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_list)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_list)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_none)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_illegal)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_illegal)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_illegal)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_illegal)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_illegal)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L6_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L7_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L8_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL(___L9_c_23__2a__2a_read_2d_dot)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_M_HLBL(___L1_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_M_HLBL(___L2_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_M_HLBL(___L3_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_M_HLBL(___L4_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_M_HLBL(___L5_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L1_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L2_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L3_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L4_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L5_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L6_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L7_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L8_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L9_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L10_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L11_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L12_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L13_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L14_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L15_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L16_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L17_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L18_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L19_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L20_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L21_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L22_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L23_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L24_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L25_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L26_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L27_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L28_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L29_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_M_HLBL(___L30_c_23__2a__2a_make_2d_standard_2d_readtable)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20___source
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20___source)
___DEF_P_HLBL(___L1__20___source)
___DEF_P_HLBL(___L2__20___source)
___DEF_P_HLBL(___L3__20___source)
___DEF_P_HLBL(___L4__20___source)
___DEF_P_HLBL(___L5__20___source)
___DEF_P_HLBL(___L6__20___source)
___DEF_P_HLBL(___L7__20___source)
___DEF_P_HLBL(___L8__20___source)
___DEF_P_HLBL(___L9__20___source)
___DEF_P_HLBL(___L10__20___source)
___DEF_P_HLBL(___L11__20___source)
___DEF_P_HLBL(___L12__20___source)
___DEF_P_HLBL(___L13__20___source)
___DEF_P_HLBL(___L14__20___source)
___DEF_P_HLBL(___L15__20___source)
___DEF_P_HLBL(___L16__20___source)
___DEF_P_HLBL(___L17__20___source)
___DEF_P_HLBL(___L18__20___source)
___DEF_P_HLBL(___L19__20___source)
___DEF_P_HLBL(___L20__20___source)
___DEF_P_HLBL(___L21__20___source)
___DEF_P_HLBL(___L22__20___source)
___DEF_P_HLBL(___L23__20___source)
___DEF_P_HLBL(___L24__20___source)
___DEF_P_HLBL(___L25__20___source)
___DEF_P_HLBL(___L26__20___source)
___DEF_P_HLBL(___L27__20___source)
___DEF_P_HLBL(___L28__20___source)
___DEF_P_HLBL(___L29__20___source)
___DEF_P_HLBL(___L30__20___source)
___DEF_P_HLBL(___L31__20___source)
___DEF_P_HLBL(___L32__20___source)
___DEF_P_HLBL(___L33__20___source)
___DEF_P_HLBL(___L34__20___source)
___DEF_P_HLBL(___L35__20___source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20___source)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20___source)
   ___SET_STK(1,___R0)
   ___SET_R1(___FIX(7L))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(2,___L2__20___source)
   ___SET_R1(___CONS(___CHR(97),___R1))
   ___SET_STK(-2,___R1)
   ___SET_R1(___FIX(8L))
   ___SET_R0(___LBL(4))
   ___ADJFP(4)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(4,___L4__20___source)
   ___SET_R1(___CONS(___CHR(98),___R1))
   ___SET_STK(-5,___R1)
   ___SET_R1(___FIX(9L))
   ___SET_R0(___LBL(6))
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(6,___L6__20___source)
   ___SET_R1(___CONS(___CHR(116),___R1))
   ___SET_STK(-4,___R1)
   ___SET_R1(___FIX(11L))
   ___SET_R0(___LBL(8))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(8,___L8__20___source)
   ___SET_R1(___CONS(___CHR(118),___R1))
   ___SET_STK(-3,___R1)
   ___SET_R1(___FIX(12L))
   ___SET_R0(___LBL(10))
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(10,___L10__20___source)
   ___SET_R1(___CONS(___CHR(102),___R1))
   ___SET_STK(-2,___R1)
   ___SET_R1(___FIX(13L))
   ___SET_R0(___LBL(12))
   ___ADJFP(4)
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(12,___L12__20___source)
   ___SET_R1(___CONS(___CHR(114),___R1))
   ___SET_R2(___CONS(___CHR(110),___CHR(10)))
   ___SET_R3(___CONS(___CHR(92),___CHR(92)))
   ___BEGIN_ALLOC_LIST(8,___R1)
   ___ADD_LIST_ELEM(1,___STK(-6))
   ___ADD_LIST_ELEM(2,___STK(-7))
   ___ADD_LIST_ELEM(3,___R2)
   ___ADD_LIST_ELEM(4,___STK(-8))
   ___ADD_LIST_ELEM(5,___STK(-9))
   ___ADD_LIST_ELEM(6,___STK(-10))
   ___ADD_LIST_ELEM(7,___R3)
   ___END_ALLOC_LIST(8)
   ___SET_R1(___GET_LIST(8))
   ___SET_GLO(103,___G_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table,___R1)
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(14))
   ___ADJFP(-8)
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(14,___L14__20___source)
   ___SET_R1(___CONS(___SUB(0),___R1))
   ___SET_STK(-2,___R1)
   ___SET_R1(___FIX(7L))
   ___SET_R0(___LBL(16))
   ___ADJFP(4)
   ___CHECK_HEAP(15,4096)
___DEF_SLBL(15,___L15__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(16,___L16__20___source)
   ___SET_R1(___CONS(___SUB(1),___R1))
   ___SET_STK(-5,___R1)
   ___SET_R1(___FIX(8L))
   ___SET_R0(___LBL(18))
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(18,___L18__20___source)
   ___SET_R1(___CONS(___SUB(2),___R1))
   ___SET_STK(-4,___R1)
   ___SET_R1(___FIX(9L))
   ___SET_R0(___LBL(20))
   ___CHECK_HEAP(19,4096)
___DEF_SLBL(19,___L19__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(20,___L20__20___source)
   ___SET_R1(___CONS(___SUB(3),___R1))
   ___SET_STK(-3,___R1)
   ___SET_R1(___FIX(10L))
   ___SET_R0(___LBL(22))
   ___CHECK_HEAP(21,4096)
___DEF_SLBL(21,___L21__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(22,___L22__20___source)
   ___SET_R1(___CONS(___SUB(4),___R1))
   ___SET_STK(-2,___R1)
   ___SET_R1(___FIX(11L))
   ___SET_R0(___LBL(24))
   ___ADJFP(4)
   ___CHECK_HEAP(23,4096)
___DEF_SLBL(23,___L23__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(24,___L24__20___source)
   ___SET_R1(___CONS(___SUB(5),___R1))
   ___SET_STK(-5,___R1)
   ___SET_R1(___FIX(12L))
   ___SET_R0(___LBL(26))
   ___CHECK_HEAP(25,4096)
___DEF_SLBL(25,___L25__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(26,___L26__20___source)
   ___SET_R1(___CONS(___SUB(6),___R1))
   ___SET_STK(-4,___R1)
   ___SET_R1(___FIX(13L))
   ___SET_R0(___LBL(28))
   ___CHECK_HEAP(27,4096)
___DEF_SLBL(27,___L27__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(28,___L28__20___source)
   ___SET_R1(___CONS(___SUB(7),___R1))
   ___SET_STK(-3,___R1)
   ___SET_R1(___FIX(127L))
   ___SET_R0(___LBL(30))
   ___CHECK_HEAP(29,4096)
___DEF_SLBL(29,___L29__20___source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(30,___L30__20___source)
   ___SET_R1(___CONS(___SUB(8),___R1))
   ___SET_R2(___CONS(___SUB(9),___CHR(32)))
   ___SET_R3(___CONS(___SUB(10),___CHR(10)))
   ___BEGIN_ALLOC_LIST(11,___R1)
   ___ADD_LIST_ELEM(1,___STK(-3))
   ___ADD_LIST_ELEM(2,___STK(-4))
   ___ADD_LIST_ELEM(3,___STK(-5))
   ___ADD_LIST_ELEM(4,___STK(-6))
   ___ADD_LIST_ELEM(5,___STK(-7))
   ___ADD_LIST_ELEM(6,___STK(-8))
   ___ADD_LIST_ELEM(7,___STK(-9))
   ___ADD_LIST_ELEM(8,___STK(-10))
   ___ADD_LIST_ELEM(9,___R2)
   ___ADD_LIST_ELEM(10,___R3)
   ___END_ALLOC_LIST(11)
   ___SET_R1(___GET_LIST(11))
   ___SET_GLO(104,___G_c_23__2a__2a_standard_2d_named_2d_char_2d_table,___R1)
   ___SET_R1(___CONS(___SUB(11),___GLO_c_23_end_2d_of_2d_file_2d_object))
   ___SET_R2(___CONS(___SUB(12),___GLO_c_23_key_2d_object))
   ___SET_R3(___CONS(___SUB(13),___GLO_c_23_rest_2d_object))
   ___SET_R4(___CONS(___SUB(14),___GLO_c_23_optional_2d_object))
   ___BEGIN_ALLOC_LIST(4,___R1)
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___R3)
   ___ADD_LIST_ELEM(3,___R4)
   ___END_ALLOC_LIST(4)
   ___SET_R1(___GET_LIST(4))
   ___SET_GLO(105,___G_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table,___R1)
   ___SET_R2(___GLO_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table)
   ___SET_R1(___TYPECAST(___FIX(-8L),___FIX(2L)))
   ___SET_R1(___CONS(___SUB(15),___R1))
   ___SET_R3(___TYPECAST(___FIX(-7L),___FIX(2L)))
   ___SET_R3(___CONS(___SUB(16),___R3))
   ___SET_R4(___TYPECAST(___FIX(-5L),___FIX(2L)))
   ___SET_R4(___CONS(___SUB(17),___R4))
   ___BEGIN_ALLOC_LIST(3,___R1)
   ___ADD_LIST_ELEM(1,___R3)
   ___ADD_LIST_ELEM(2,___R4)
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___SET_R0(___LBL(32))
   ___ADJFP(-8)
   ___CHECK_HEAP(31,4096)
___DEF_SLBL(31,___L31__20___source)
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(32,___L32__20___source)
   ___SET_GLO(105,___G_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table,___R1)
   ___SET_GLO(100,___G_c_23__2a__2a_readtable_2d_tag,___SUB(18))
   ___IF(___FALSEP(___GLO_c_23__2a__2a_main_2d_readtable))
   ___GOTO(___L37__20___source)
   ___END_IF
   ___SET_R1(___VOID)
   ___POLL(33)
___DEF_SLBL(33,___L33__20___source)
   ___GOTO(___L36__20___source)
___DEF_SLBL(34,___L34__20___source)
   ___SET_GLO(13,___G_c_23__2a__2a_main_2d_readtable,___R1)
   ___SET_R1(___VOID)
   ___POLL(35)
___DEF_SLBL(35,___L35__20___source)
___DEF_GLBL(___L36__20___source)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L37__20___source)
   ___SET_R0(___LBL(34))
   ___JUMPINT(___SET_NARGS(0),___PRC(859),___L_c_23__2a__2a_make_2d_standard_2d_readtable)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 38
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_make_2d_source)
___DEF_P_HLBL(___L1_c_23_make_2d_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_make_2d_source)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_make_2d_source)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_make_2d_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_source_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 41
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_source_2d_code)
___DEF_P_HLBL(___L1_c_23_source_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_source_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_source_2d_code)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_source_2d_code)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_source_2d_locat
#undef ___PH_LBL0
#define ___PH_LBL0 44
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_source_2d_locat)
___DEF_P_HLBL(___L1_c_23_source_2d_locat)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_source_2d_locat)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_source_2d_locat)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_source_2d_locat)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G__23__23_source_2d_locat)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_make_2d_readenv
#undef ___PH_LBL0
#define ___PH_LBL0 47
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_make_2d_readenv)
___DEF_P_HLBL(___L1_c_23__2a__2a_make_2d_readenv)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_make_2d_readenv)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L_c_23__2a__2a_make_2d_readenv)
   ___BEGIN_ALLOC_VECTOR(9)
   ___ADD_VECTOR_ELEM(0,___STK(-1))
   ___ADD_VECTOR_ELEM(1,___STK(0))
   ___ADD_VECTOR_ELEM(2,___R1)
   ___ADD_VECTOR_ELEM(3,___R2)
   ___ADD_VECTOR_ELEM(4,___R3)
   ___ADD_VECTOR_ELEM(5,___FIX(0L))
   ___ADD_VECTOR_ELEM(6,___FIX(0L))
   ___ADD_VECTOR_ELEM(7,___FIX(0L))
   ___ADD_VECTOR_ELEM(8,___FIX(0L))
   ___END_ALLOC_VECTOR(9)
   ___SET_R1(___GET_VECTOR(9))
   ___ADJFP(-2)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23__2a__2a_make_2d_readenv)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_port
#undef ___PH_LBL0
#define ___PH_LBL0 50
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_port)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_port)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_port)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_readtable
#undef ___PH_LBL0
#define ___PH_LBL0 52
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_readtable)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_readtable)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_readtable)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_error_2d_proc
#undef ___PH_LBL0
#define ___PH_LBL0 54
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_error_2d_proc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_error_2d_proc)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_error_2d_proc)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_wrap
#undef ___PH_LBL0
#define ___PH_LBL0 56
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_wrap)
___DEF_P_HLBL(___L1_c_23__2a__2a_readenv_2d_wrap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_wrap)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_wrap)
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(3L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_wrap)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_unwrap
#undef ___PH_LBL0
#define ___PH_LBL0 59
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_unwrap)
___DEF_P_HLBL(___L1_c_23__2a__2a_readenv_2d_unwrap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_unwrap)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_unwrap)
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(4L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_unwrap)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_filepos
#undef ___PH_LBL0
#define ___PH_LBL0 62
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_filepos)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_filepos)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_filepos)
   ___SET_R1(___VECTORREF(___R1,___FIX(5L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_filepos_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 64
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_filepos_2d_set_21_)
   ___VECTORSET(___R1,___FIX(5L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_line_2d_count
#undef ___PH_LBL0
#define ___PH_LBL0 66
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_count)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_line_2d_count)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_line_2d_count)
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 68
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_)
   ___VECTORSET(___R1,___FIX(6L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_char_2d_count
#undef ___PH_LBL0
#define ___PH_LBL0 70
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_char_2d_count)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_char_2d_count)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_char_2d_count)
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_)
   ___VECTORSET(___R1,___FIX(7L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_line_2d_start
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
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_start)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_line_2d_start)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_line_2d_start)
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 76
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_)
   ___VECTORSET(___R1,___FIX(8L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_current_2d_filepos
#undef ___PH_LBL0
#define ___PH_LBL0 78
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_P_HLBL(___L1_c_23__2a__2a_readenv_2d_current_2d_filepos)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_current_2d_filepos)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
   ___SET_R2(___VECTORREF(___R1,___FIX(6L)))
   ___SET_R3(___VECTORREF(___R1,___FIX(7L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R1(___FIXSUB(___R3,___R1))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_current_2d_filepos)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(3),___PRC(93),___L_c_23__2a__2a_make_2d_filepos)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_previous_2d_filepos
#undef ___PH_LBL0
#define ___PH_LBL0 81
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___DEF_P_HLBL(___L1_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_previous_2d_filepos)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_previous_2d_filepos)
   ___SET_R3(___VECTORREF(___R1,___FIX(6L)))
   ___SET_R4(___VECTORREF(___R1,___FIX(7L)))
   ___SET_R2(___FIXSUB(___R4,___R2))
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R1(___FIXSUB(___R2,___R1))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_previous_2d_filepos)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(3),___PRC(93),___L_c_23__2a__2a_make_2d_filepos)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof
#undef ___PH_LBL0
#define ___PH_LBL0 84
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_P_HLBL(___L1_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
   ___JUMPPRM(___SET_NARGS(1),___PRM_peek_2d_char)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof
#undef ___PH_LBL0
#define ___PH_LBL0 87
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___JUMPPRM(___SET_NARGS(1),___PRM_read_2d_char)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L5_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___END_IF
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(7L)))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___VECTORSET(___STK(-6),___FIX(7L),___R2)
   ___IF(___NOT(___CHAREQP(___R1,___CHR(10))))
   ___GOTO(___L5_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___END_IF
   ___VECTORSET(___STK(-6),___FIX(8L),___R2)
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(6L)))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___VECTORSET(___STK(-6),___FIX(6L),___R2)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___GOTO(___L6_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_GLBL(___L5_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_make_2d_filepos
#undef ___PH_LBL0
#define ___PH_LBL0 93
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_make_2d_filepos)
___DEF_P_HLBL(___L1_c_23__2a__2a_make_2d_filepos)
___DEF_P_HLBL(___L2_c_23__2a__2a_make_2d_filepos)
___DEF_P_HLBL(___L3_c_23__2a__2a_make_2d_filepos)
___DEF_P_HLBL(___L4_c_23__2a__2a_make_2d_filepos)
___DEF_P_HLBL(___L5_c_23__2a__2a_make_2d_filepos)
___DEF_P_HLBL(___L6_c_23__2a__2a_make_2d_filepos)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_make_2d_filepos)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_make_2d_filepos)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_make_2d_filepos)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),162,___G_c_23_max_2d_lines)
___DEF_SLBL(2,___L2_c_23__2a__2a_make_2d_filepos)
   ___IF(___FIXLT(___STK(-6),___R1))
   ___GOTO(___L10_c_23__2a__2a_make_2d_filepos)
   ___END_IF
   ___GOTO(___L7_c_23__2a__2a_make_2d_filepos)
___DEF_SLBL(3,___L3_c_23__2a__2a_make_2d_filepos)
   ___IF(___NOT(___FIXLT(___R1,___STK(-5))))
   ___GOTO(___L9_c_23__2a__2a_make_2d_filepos)
   ___END_IF
___DEF_GLBL(___L7_c_23__2a__2a_make_2d_filepos)
   ___SET_R1(___FIXNEG(___STK(-4)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_make_2d_filepos)
___DEF_GLBL(___L8_c_23__2a__2a_make_2d_filepos)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L9_c_23__2a__2a_make_2d_filepos)
   ___SET_R0(___LBL(5))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),162,___G_c_23_max_2d_lines)
___DEF_SLBL(5,___L5_c_23__2a__2a_make_2d_filepos)
   ___SET_R1(___FIXMUL(___STK(-5),___R1))
   ___SET_R1(___FIXADD(___STK(-6),___R1))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_make_2d_filepos)
   ___GOTO(___L8_c_23__2a__2a_make_2d_filepos)
___DEF_GLBL(___L10_c_23__2a__2a_make_2d_filepos)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),161,___G_c_23_max_2d_fixnum32_2d_div_2d_max_2d_lines)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_filepos_2d_line
#undef ___PH_LBL0
#define ___PH_LBL0 101
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_filepos_2d_line)
___DEF_P_HLBL(___L1_c_23__2a__2a_filepos_2d_line)
___DEF_P_HLBL(___L2_c_23__2a__2a_filepos_2d_line)
___DEF_P_HLBL(___L3_c_23__2a__2a_filepos_2d_line)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_filepos_2d_line)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_filepos_2d_line)
   ___IF(___FIXLT(___R1,___FIX(0L)))
   ___GOTO(___L4_c_23__2a__2a_filepos_2d_line)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_filepos_2d_line)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),162,___G_c_23_max_2d_lines)
___DEF_SLBL(2,___L2_c_23__2a__2a_filepos_2d_line)
   ___SET_R1(___FIXMOD(___STK(-6),___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_filepos_2d_line)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L4_c_23__2a__2a_filepos_2d_line)
   ___SET_R1(___FIX(0L))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_filepos_2d_col
#undef ___PH_LBL0
#define ___PH_LBL0 106
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_filepos_2d_col)
___DEF_P_HLBL(___L1_c_23__2a__2a_filepos_2d_col)
___DEF_P_HLBL(___L2_c_23__2a__2a_filepos_2d_col)
___DEF_P_HLBL(___L3_c_23__2a__2a_filepos_2d_col)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_filepos_2d_col)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_filepos_2d_col)
   ___IF(___FIXLT(___R1,___FIX(0L)))
   ___GOTO(___L4_c_23__2a__2a_filepos_2d_col)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_filepos_2d_col)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),162,___G_c_23_max_2d_lines)
___DEF_SLBL(2,___L2_c_23__2a__2a_filepos_2d_col)
   ___SET_R1(___FIXQUO(___STK(-6),___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_filepos_2d_col)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L4_c_23__2a__2a_filepos_2d_col)
   ___SET_R1(___FIXNEG(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_open
#undef ___PH_LBL0
#define ___PH_LBL0 111
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L1_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L2_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L3_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L4_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L5_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L6_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L7_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L8_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L9_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L10_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L11_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L12_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L13_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L14_c_23__2a__2a_readenv_2d_open)
___DEF_P_HLBL(___L15_c_23__2a__2a_readenv_2d_open)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_open)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_open)
   ___SET_STK(1,___ALLOC_CLO(1))
   ___SET_STK(2,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),11)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_SETUP_CLO(1,___STK(2),7)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(3))
   ___ADJFP(8)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_open)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23__2a__2a_readenv_2d_open)
   ___JUMPPRM(___SET_NARGS(1),___PRM_open_2d_input_2d_file)
___DEF_SLBL(3,___L3_c_23__2a__2a_readenv_2d_open)
   ___SET_STK(-4,___STK(-7))
   ___SET_STK(-7,___R1)
   ___SET_STK(-3,___STK(-6))
   ___SET_STK(-6,___GLO_c_23__2a__2a_main_2d_readtable)
   ___SET_R3(___LBL(5))
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-5))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_readenv_2d_open)
   ___ADJFP(-6)
   ___JUMPINT(___SET_NARGS(5),___PRC(47),___L_c_23__2a__2a_make_2d_readenv)
___DEF_SLBL(5,___L5_c_23__2a__2a_readenv_2d_open)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(5,2,0,0)
   ___SET_R1(___R2)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_readenv_2d_open)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(7,___L7_c_23__2a__2a_readenv_2d_open)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(7,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R2(___CLO(___R4,1))
   ___SET_R0(___LBL(9))
   ___ADJFP(8)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_readenv_2d_open)
   ___JUMPINT(___SET_NARGS(2),___PRC(150),___L_c_23_re_2d__3e_locat)
___DEF_SLBL(9,___L9_c_23__2a__2a_readenv_2d_open)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23__2a__2a_readenv_2d_open)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_SLBL(11,___L11_c_23__2a__2a_readenv_2d_open)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(11,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_R2(___CLO(___R4,1))
   ___SET_R0(___LBL(13))
   ___ADJFP(8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23__2a__2a_readenv_2d_open)
   ___JUMPINT(___SET_NARGS(2),___PRC(150),___L_c_23_re_2d__3e_locat)
___DEF_SLBL(13,___L13_c_23__2a__2a_readenv_2d_open)
   ___SET_R2(___CONS(___STK(-6),___STK(-5)))
   ___SET_R2(___CONS(___R1,___R2))
   ___SET_R1(___GLO_c_23_compiler_2d_user_2d_error)
   ___SET_R0(___STK(-7))
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23__2a__2a_readenv_2d_open)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23__2a__2a_readenv_2d_open)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_apply)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_close
#undef ___PH_LBL0
#define ___PH_LBL0 128
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readenv_2d_close)
___DEF_P_HLBL(___L1_c_23__2a__2a_readenv_2d_close)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readenv_2d_close)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readenv_2d_close)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_close)
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_false_2d_obj
#undef ___PH_LBL0
#define ___PH_LBL0 131
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_false_2d_obj)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_false_2d_obj)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23_false_2d_obj)
   ___SET_R1(___GLO_c_23_false_2d_object)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_append_2d_strings
#undef ___PH_LBL0
#define ___PH_LBL0 133
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L1_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L2_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L3_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L4_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L5_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L6_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L7_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L8_c_23__2a__2a_append_2d_strings)
___DEF_P_HLBL(___L9_c_23__2a__2a_append_2d_strings)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_append_2d_strings)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_append_2d_strings)
   ___SET_R2(___R1)
   ___SET_R3(___NUL)
   ___SET_R1(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_append_2d_strings)
   ___GOTO(___L11_c_23__2a__2a_append_2d_strings)
___DEF_GLBL(___L10_c_23__2a__2a_append_2d_strings)
   ___SET_R4(___CAR(___R2))
   ___SET_R3(___CONS(___R4,___R3))
   ___SET_R4(___STRINGLENGTH(___R4))
   ___SET_R1(___FIXADD(___R1,___R4))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2_c_23__2a__2a_append_2d_strings)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_append_2d_strings)
___DEF_GLBL(___L11_c_23__2a__2a_append_2d_strings)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L10_c_23__2a__2a_append_2d_strings)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R2(___CHR(32))
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_append_2d_strings)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_string)
___DEF_SLBL(5,___L5_c_23__2a__2a_append_2d_strings)
   ___SET_R3(___STK(-5))
   ___SET_R2(___FIXSUB(___STK(-6),___FIX(1L)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_append_2d_strings)
   ___GOTO(___L14_c_23__2a__2a_append_2d_strings)
___DEF_GLBL(___L12_c_23__2a__2a_append_2d_strings)
   ___SET_R4(___STRINGREF(___R1,___R3))
   ___STRINGSET(___STK(-1),___R2,___R4)
   ___SET_R3(___FIXSUB(___R3,___FIX(1L)))
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_append_2d_strings)
___DEF_GLBL(___L13_c_23__2a__2a_append_2d_strings)
   ___IF(___NOT(___FIXLT(___R3,___FIX(0L))))
   ___GOTO(___L12_c_23__2a__2a_append_2d_strings)
   ___END_IF
   ___SET_R3(___CDR(___STK(0)))
   ___SET_R1(___STK(-1))
   ___ADJFP(-2)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_append_2d_strings)
___DEF_GLBL(___L14_c_23__2a__2a_append_2d_strings)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L15_c_23__2a__2a_append_2d_strings)
   ___END_IF
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R3)
   ___SET_R1(___STRINGLENGTH(___R4))
   ___SET_R3(___FIXSUB(___R1,___FIX(1L)))
   ___SET_R1(___R4)
   ___ADJFP(2)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_append_2d_strings)
   ___GOTO(___L13_c_23__2a__2a_append_2d_strings)
___DEF_GLBL(___L15_c_23__2a__2a_append_2d_strings)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_string_2d__3e_canonical_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 144
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_P_HLBL(___L1_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_P_HLBL(___L2_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_P_HLBL(___L3_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_P_HLBL(___L4_c_23_string_2d__3e_canonical_2d_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_string_2d__3e_canonical_2d_symbol)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_string_2d__3e_canonical_2d_symbol)
   ___SET_STK(1,___R0)
   ___SET_R2(___SUB(19))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_string_2d__3e_canonical_2d_symbol)
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_append)
___DEF_SLBL(2,___L2_c_23_string_2d__3e_canonical_2d_symbol)
   ___IF(___FALSEP(___GLO_c_23__2a__2a_main_2d_readtable))
   ___GOTO(___L5_c_23_string_2d__3e_canonical_2d_symbol)
   ___END_IF
   ___GOTO(___L6_c_23_string_2d__3e_canonical_2d_symbol)
___DEF_SLBL(3,___L3_c_23_string_2d__3e_canonical_2d_symbol)
   ___SET_R1(___STK(-6))
   ___ADJFP(-4)
___DEF_GLBL(___L5_c_23_string_2d__3e_canonical_2d_symbol)
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_string_2d__3e_canonical_2d_symbol)
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___DEF_GLBL(___L6_c_23_string_2d__3e_canonical_2d_symbol)
   ___SET_STK(-2,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___GLO_c_23__2a__2a_main_2d_readtable)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(2),___PRC(423),___L_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_re_2d__3e_locat
#undef ___PH_LBL0
#define ___PH_LBL0 150
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_re_2d__3e_locat)
___DEF_P_HLBL(___L1_c_23_re_2d__3e_locat)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_re_2d__3e_locat)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_re_2d__3e_locat)
   ___SET_R1(___VECTORREF(___R1,___FIX(5L)))
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R2)
   ___ADD_VECTOR_ELEM(1,___R1)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_re_2d__3e_locat)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_expr_2d__3e_locat
#undef ___PH_LBL0
#define ___PH_LBL0 153
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_expr_2d__3e_locat)
___DEF_P_HLBL(___L1_c_23_expr_2d__3e_locat)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_expr_2d__3e_locat)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_expr_2d__3e_locat)
   ___BEGIN_ALLOC_VECTOR(2)
   ___ADD_VECTOR_ELEM(0,___R2)
   ___ADD_VECTOR_ELEM(1,___R1)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23_expr_2d__3e_locat)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_locat_2d_show
#undef ___PH_LBL0
#define ___PH_LBL0 156
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_locat_2d_show)
___DEF_P_HLBL(___L1_c_23_locat_2d_show)
___DEF_P_HLBL(___L2_c_23_locat_2d_show)
___DEF_P_HLBL(___L3_c_23_locat_2d_show)
___DEF_P_HLBL(___L4_c_23_locat_2d_show)
___DEF_P_HLBL(___L5_c_23_locat_2d_show)
___DEF_P_HLBL(___L6_c_23_locat_2d_show)
___DEF_P_HLBL(___L7_c_23_locat_2d_show)
___DEF_P_HLBL(___L8_c_23_locat_2d_show)
___DEF_P_HLBL(___L9_c_23_locat_2d_show)
___DEF_P_HLBL(___L10_c_23_locat_2d_show)
___DEF_P_HLBL(___L11_c_23_locat_2d_show)
___DEF_P_HLBL(___L12_c_23_locat_2d_show)
___DEF_P_HLBL(___L13_c_23_locat_2d_show)
___DEF_P_HLBL(___L14_c_23_locat_2d_show)
___DEF_P_HLBL(___L15_c_23_locat_2d_show)
___DEF_P_HLBL(___L16_c_23_locat_2d_show)
___DEF_P_HLBL(___L17_c_23_locat_2d_show)
___DEF_P_HLBL(___L18_c_23_locat_2d_show)
___DEF_P_HLBL(___L19_c_23_locat_2d_show)
___DEF_P_HLBL(___L20_c_23_locat_2d_show)
___DEF_P_HLBL(___L21_c_23_locat_2d_show)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_locat_2d_show)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_locat_2d_show)
   ___IF(___FALSEP(___R2))
   ___GOTO(___L22_c_23_locat_2d_show)
   ___END_IF
   ___GOTO(___L23_c_23_locat_2d_show)
___DEF_SLBL(1,___L1_c_23_locat_2d_show)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(20))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_locat_2d_show)
   ___IF(___NOT(___FALSEP(___R2)))
   ___GOTO(___L23_c_23_locat_2d_show)
   ___END_IF
___DEF_GLBL(___L22_c_23_locat_2d_show)
   ___SET_R1(___SUB(21))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_locat_2d_show)
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_GLBL(___L23_c_23_locat_2d_show)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_locat_2d_show)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G__23__23_locat_2d_container)
___DEF_SLBL(5,___L5_c_23_locat_2d_show)
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),121,___G__23__23_container_2d__3e_path)
___DEF_SLBL(6,___L6_c_23_locat_2d_show)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),126,___G__23__23_locat_2d_position)
___DEF_SLBL(7,___L7_c_23_locat_2d_show)
   ___IF(___NOT(___STRINGP(___STK(-4))))
   ___GOTO(___L27_c_23_locat_2d_show)
   ___END_IF
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R3(___TRU)
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),151,___G_c_23_format_2d_filepos)
___DEF_SLBL(8,___L8_c_23_locat_2d_show)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L26_c_23_locat_2d_show)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(101),___L_c_23__2a__2a_filepos_2d_line)
___DEF_SLBL(9,___L9_c_23_locat_2d_show)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(106),___L_c_23__2a__2a_filepos_2d_col)
___DEF_SLBL(10,___L10_c_23_locat_2d_show)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___IF(___STRINGP(___STK(-4)))
   ___GOTO(___L25_c_23_locat_2d_show)
   ___END_IF
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-4))
   ___GOTO(___L24_c_23_locat_2d_show)
___DEF_SLBL(11,___L11_c_23_locat_2d_show)
___DEF_GLBL(___L24_c_23_locat_2d_show)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(12,___L12_c_23_locat_2d_show)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(13))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_SLBL(13,___L13_c_23_locat_2d_show)
   ___SET_R1(___SUB(22))
   ___SET_R0(___LBL(14))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(14,___L14_c_23_locat_2d_show)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(15,___L15_c_23_locat_2d_show)
   ___SET_R1(___SUB(23))
   ___SET_R0(___LBL(16))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(16,___L16_c_23_locat_2d_show)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_locat_2d_show)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_GLBL(___L25_c_23_locat_2d_show)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_GLBL(___L26_c_23_locat_2d_show)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_GLBL(___L27_c_23_locat_2d_show)
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(0L)))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(1L)))
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R2)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(18,___L18_c_23_locat_2d_show)
   ___SET_R1(___SUB(24))
   ___SET_R0(___LBL(19))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(19,___L19_c_23_locat_2d_show)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(20))
   ___JUMPPRM(___SET_NARGS(1),___PRM_write)
___DEF_SLBL(20,___L20_c_23_locat_2d_show)
   ___IF(___NOT(___FALSEP(___STK(-5))))
   ___GOTO(___L28_c_23_locat_2d_show)
   ___END_IF
   ___SET_R1(___VOID)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_locat_2d_show)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L28_c_23_locat_2d_show)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(1))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),138,___G__23__23_source_2d_locat)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_locat_2d_filename_2d_and_2d_line
#undef ___PH_LBL0
#define ___PH_LBL0 179
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L1_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L2_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L3_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L4_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L5_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L6_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L7_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L8_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L9_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L10_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_P_HLBL(___L11_c_23_locat_2d_filename_2d_and_2d_line)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_locat_2d_filename_2d_and_2d_line)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_locat_2d_filename_2d_and_2d_line)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L14_c_23_locat_2d_filename_2d_and_2d_line)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_locat_2d_filename_2d_and_2d_line)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),125,___G__23__23_locat_2d_container)
___DEF_SLBL(2,___L2_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),121,___G__23__23_container_2d__3e_path)
___DEF_SLBL(3,___L3_c_23_locat_2d_filename_2d_and_2d_line)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L13_c_23_locat_2d_filename_2d_and_2d_line)
   ___END_IF
   ___SET_R1(___CONS(___SUB(25),___FIX(1L)))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23_locat_2d_filename_2d_and_2d_line)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_locat_2d_filename_2d_and_2d_line)
   ___GOTO(___L12_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_SLBL(6,___L6_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(7,4096)
___DEF_SLBL(7,___L7_c_23_locat_2d_filename_2d_and_2d_line)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_GLBL(___L12_c_23_locat_2d_filename_2d_and_2d_line)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L13_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),126,___G__23__23_locat_2d_position)
___DEF_SLBL(9,___L9_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),132,___G__23__23_position_2d__3e_filepos)
___DEF_SLBL(10,___L10_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(101),___L_c_23__2a__2a_filepos_2d_line)
___DEF_GLBL(___L14_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_R1(___CONS(___SUB(26),___FIX(1L)))
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_locat_2d_filename_2d_and_2d_line)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_locat_2d_filename
#undef ___PH_LBL0
#define ___PH_LBL0 192
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_locat_2d_filename)
___DEF_P_HLBL(___L1_c_23_locat_2d_filename)
___DEF_P_HLBL(___L2_c_23_locat_2d_filename)
___DEF_P_HLBL(___L3_c_23_locat_2d_filename)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_locat_2d_filename)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_locat_2d_filename)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_locat_2d_filename)
   ___JUMPINT(___SET_NARGS(1),___PRC(179),___L_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_SLBL(2,___L2_c_23_locat_2d_filename)
   ___SET_R1(___CAR(___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_locat_2d_filename)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_expression_2d__3e_source
#undef ___PH_LBL0
#define ___PH_LBL0 197
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L1_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L2_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L3_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L4_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L5_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L6_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L7_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L8_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L9_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L10_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L11_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L12_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L13_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L14_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L15_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L16_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L17_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L18_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L19_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L20_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L21_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L22_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L23_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L24_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L25_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L26_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L27_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L28_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L29_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L30_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L31_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L32_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L33_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L34_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L35_c_23_expression_2d__3e_source)
___DEF_P_HLBL(___L36_c_23_expression_2d__3e_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_expression_2d__3e_source)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_expression_2d__3e_source)
   ___GOTO(___L39_c_23_expression_2d__3e_source)
___DEF_SLBL(2,___L2_c_23_expression_2d__3e_source)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(25))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L41_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L37_c_23_expression_2d__3e_source)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CDR(___R2))
   ___IF(___NOT(___PAIRP(___R4)))
   ___GOTO(___L54_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R4(___CDR(___R4))
   ___IF(___NOT(___NULLP(___R4)))
   ___GOTO(___L54_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___EQP(___R3,___GLO_c_23_quote_2d_sym))
   ___GOTO(___L38_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___EQP(___R3,___GLO_c_23_quasiquote_2d_sym))
   ___GOTO(___L38_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___EQP(___R3,___GLO_c_23_unquote_2d_sym))
   ___GOTO(___L38_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___NOT(___EQP(___R3,___GLO_c_23_unquote_2d_splicing_2d_sym)))
   ___GOTO(___L54_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L38_c_23_expression_2d__3e_source)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_expression_2d__3e_source)
___DEF_GLBL(___L39_c_23_expression_2d__3e_source)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L52_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L40_c_23_expression_2d__3e_source)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L44_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___CAR(___R3))
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_expression_2d__3e_source)
   ___GOTO(___L39_c_23_expression_2d__3e_source)
___DEF_SLBL(5,___L5_c_23_expression_2d__3e_source)
   ___SET_STK(-3,___R1)
   ___SET_R2(___CDR(___STK(-4)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(12))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L37_c_23_expression_2d__3e_source)
   ___END_IF
   ___GOTO(___L41_c_23_expression_2d__3e_source)
___DEF_SLBL(6,___L6_c_23_expression_2d__3e_source)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L37_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L41_c_23_expression_2d__3e_source)
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L38_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(7,___L7_c_23_expression_2d__3e_source)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23_expression_2d__3e_source)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_expression_2d__3e_source)
   ___GOTO(___L42_c_23_expression_2d__3e_source)
___DEF_SLBL(10,___L10_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-3))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_expression_2d__3e_source)
___DEF_GLBL(___L42_c_23_expression_2d__3e_source)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(12,___L12_c_23_expression_2d__3e_source)
   ___SET_R1(___CONS(___STK(-3),___R1))
   ___CHECK_HEAP(13,4096)
___DEF_SLBL(13,___L13_c_23_expression_2d__3e_source)
   ___GOTO(___L43_c_23_expression_2d__3e_source)
___DEF_SLBL(14,___L14_c_23_expression_2d__3e_source)
___DEF_GLBL(___L43_c_23_expression_2d__3e_source)
   ___SET_STK(-3,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(2),___PRC(153),___L_c_23_expr_2d__3e_locat)
___DEF_SLBL(15,___L15_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(2))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_GLBL(___L44_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(17))
   ___ADJFP(8)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_expression_2d__3e_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),143,___G_c_23_box_2d_object_3f_)
___DEF_SLBL(17,___L17_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L51_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(18))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),179,___G_c_23_vector_2d_object_3f_)
___DEF_SLBL(18,___L18_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L45_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___GOTO(___L43_c_23_expression_2d__3e_source)
___DEF_GLBL(___L45_c_23_expression_2d__3e_source)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___GOTO(___L46_c_23_expression_2d__3e_source)
___DEF_SLBL(19,___L19_c_23_expression_2d__3e_source)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L49_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(29))
___DEF_GLBL(___L46_c_23_expression_2d__3e_source)
   ___SET_R3(___VECTORLENGTH(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(21))
   ___ADJFP(8)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_expression_2d__3e_source)
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
___DEF_SLBL(21,___L21_c_23_expression_2d__3e_source)
   ___SET_STK(-3,___R1)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(10))
   ___ADJFP(1)
   ___IF(___FIXGE(___R3,___FIX(0L)))
   ___GOTO(___L47_c_23_expression_2d__3e_source)
   ___END_IF
   ___GOTO(___L48_c_23_expression_2d__3e_source)
___DEF_SLBL(22,___L22_c_23_expression_2d__3e_source)
   ___VECTORSET(___STK(-4),___STK(-3),___R1)
   ___SET_R3(___FIXSUB(___STK(-3),___FIX(1L)))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(23)
___DEF_SLBL(23,___L23_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FIXGE(___R3,___FIX(0L))))
   ___GOTO(___L48_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L47_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___VECTORREF(___R1,___R3))
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(22))
   ___ADJFP(7)
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_expression_2d__3e_source)
   ___GOTO(___L39_c_23_expression_2d__3e_source)
___DEF_GLBL(___L48_c_23_expression_2d__3e_source)
   ___SET_R1(___VOID)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L49_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-5))
   ___GOTO(___L50_c_23_expression_2d__3e_source)
___DEF_SLBL(25,___L25_c_23_expression_2d__3e_source)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(26,4096)
___DEF_SLBL(26,___L26_c_23_expression_2d__3e_source)
___DEF_GLBL(___L50_c_23_expression_2d__3e_source)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(153),___L_c_23_expr_2d__3e_locat)
___DEF_SLBL(27,___L27_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23_expression_2d__3e_source)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_SLBL(29,___L29_c_23_expression_2d__3e_source)
   ___GOTO(___L50_c_23_expression_2d__3e_source)
___DEF_GLBL(___L51_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),175,___G_c_23_unbox_2d_object)
___DEF_SLBL(30,___L30_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(35))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L40_c_23_expression_2d__3e_source)
   ___END_IF
   ___GOTO(___L52_c_23_expression_2d__3e_source)
___DEF_SLBL(31,___L31_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(34))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L40_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L52_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(33))
   ___ADJFP(8)
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_expression_2d__3e_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),143,___G_c_23_box_2d_object_3f_)
___DEF_SLBL(33,___L33_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L53_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),179,___G_c_23_vector_2d_object_3f_)
___DEF_GLBL(___L53_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),175,___G_c_23_unbox_2d_object)
___DEF_SLBL(34,___L34_c_23_expression_2d__3e_source)
   ___SET_R0(___LBL(29))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),142,___G_c_23_box_2d_object)
___DEF_SLBL(35,___L35_c_23_expression_2d__3e_source)
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),142,___G_c_23_box_2d_object)
___DEF_GLBL(___L54_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___CAR(___R2))
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23_expression_2d__3e_source)
   ___GOTO(___L39_c_23_expression_2d__3e_source)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_source_2d__3e_expression
#undef ___PH_LBL0
#define ___PH_LBL0 235
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L1_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L2_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L3_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L4_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L5_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L6_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L7_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L8_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L9_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L10_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L11_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L12_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L13_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L14_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L15_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L16_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L17_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L18_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L19_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L20_c_23_source_2d__3e_expression)
___DEF_P_HLBL(___L21_c_23_source_2d__3e_expression)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_source_2d__3e_expression)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23_source_2d__3e_expression)
   ___GOTO(___L23_c_23_source_2d__3e_expression)
___DEF_SLBL(1,___L1_c_23_source_2d__3e_expression)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L24_c_23_source_2d__3e_expression)
   ___END_IF
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_source_2d__3e_expression)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L30_c_23_source_2d__3e_expression)
   ___END_IF
___DEF_GLBL(___L22_c_23_source_2d__3e_expression)
   ___IF(___NULLP(___R1))
   ___GOTO(___L31_c_23_source_2d__3e_expression)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_source_2d__3e_expression)
___DEF_GLBL(___L23_c_23_source_2d__3e_expression)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_source_2d__3e_expression)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_GLBL(___L24_c_23_source_2d__3e_expression)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(5))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),143,___G_c_23_box_2d_object_3f_)
___DEF_SLBL(5,___L5_c_23_source_2d__3e_expression)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L29_c_23_source_2d__3e_expression)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),179,___G_c_23_vector_2d_object_3f_)
___DEF_SLBL(6,___L6_c_23_source_2d__3e_expression)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L26_c_23_source_2d__3e_expression)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_source_2d__3e_expression)
   ___GOTO(___L25_c_23_source_2d__3e_expression)
___DEF_SLBL(8,___L8_c_23_source_2d__3e_expression)
   ___SET_R1(___STK(-4))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_source_2d__3e_expression)
___DEF_GLBL(___L25_c_23_source_2d__3e_expression)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L26_c_23_source_2d__3e_expression)
   ___SET_R1(___VECTORLENGTH(___STK(-6)))
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(10))
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
___DEF_SLBL(10,___L10_c_23_source_2d__3e_expression)
   ___SET_STK(-4,___R1)
   ___SET_R3(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___IF(___FIXGE(___R3,___FIX(0L)))
   ___GOTO(___L27_c_23_source_2d__3e_expression)
   ___END_IF
   ___GOTO(___L28_c_23_source_2d__3e_expression)
___DEF_SLBL(11,___L11_c_23_source_2d__3e_expression)
   ___VECTORSET(___STK(-5),___STK(-4),___R1)
   ___SET_R3(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_source_2d__3e_expression)
   ___IF(___NOT(___FIXGE(___R3,___FIX(0L))))
   ___GOTO(___L28_c_23_source_2d__3e_expression)
   ___END_IF
___DEF_GLBL(___L27_c_23_source_2d__3e_expression)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___VECTORREF(___R1,___R3))
   ___SET_R0(___LBL(11))
   ___ADJFP(8)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_source_2d__3e_expression)
   ___GOTO(___L23_c_23_source_2d__3e_expression)
___DEF_GLBL(___L28_c_23_source_2d__3e_expression)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L29_c_23_source_2d__3e_expression)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),175,___G_c_23_unbox_2d_object)
___DEF_SLBL(14,___L14_c_23_source_2d__3e_expression)
   ___SET_R0(___LBL(15))
   ___GOTO(___L23_c_23_source_2d__3e_expression)
___DEF_SLBL(15,___L15_c_23_source_2d__3e_expression)
   ___SET_R0(___STK(-3))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_source_2d__3e_expression)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),142,___G_c_23_box_2d_object)
___DEF_SLBL(17,___L17_c_23_source_2d__3e_expression)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(19))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L22_c_23_source_2d__3e_expression)
   ___END_IF
___DEF_GLBL(___L30_c_23_source_2d__3e_expression)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(17))
   ___ADJFP(8)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_source_2d__3e_expression)
   ___GOTO(___L23_c_23_source_2d__3e_expression)
___DEF_SLBL(19,___L19_c_23_source_2d__3e_expression)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(20,4096)
___DEF_SLBL(20,___L20_c_23_source_2d__3e_expression)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_source_2d__3e_expression)
   ___GOTO(___L25_c_23_source_2d__3e_expression)
___DEF_GLBL(___L31_c_23_source_2d__3e_expression)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_include_2d_expr_2d__3e_sourcezzzzz
#undef ___PH_LBL0
#define ___PH_LBL0 258
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L1_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L2_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L3_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L4_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L5_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L6_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L7_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L8_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L9_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L10_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L11_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L12_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L13_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L14_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L15_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L16_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L17_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L18_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L19_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L20_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L21_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L22_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L23_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L24_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L25_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L26_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L27_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L28_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L29_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L30_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L31_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L32_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L33_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L34_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L35_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L36_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L37_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L38_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L39_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L40_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L41_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L42_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L43_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L44_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L45_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L46_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L47_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L48_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L49_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_P_HLBL(___L50_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___CADR(___R1))
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(44),___L_c_23_source_2d_locat)
___DEF_SLBL(4,___L4_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(179),___L_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_SLBL(5,___L5_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(6,___L6_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),187,___G_path_2d_directory)
___DEF_SLBL(7,___L7_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),188,___G_path_2d_expand)
___DEF_SLBL(8,___L8_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(9,___L9_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L51_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L61_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(10,___L10_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L60_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L51_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(14))
___DEF_GLBL(___L52_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(12))
   ___ADJFP(8)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(12,___L12_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L53_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R1(___STK(-5))
___DEF_GLBL(___L53_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(27))
   ___SET_R0(___STK(-7))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),165,___G_c_23_pt_2d_syntax_2d_error)
___DEF_SLBL(14,___L14_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___GOTO(___L54_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(15,___L15_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-5))
   ___ADJFP(-4)
___DEF_GLBL(___L54_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-6,___R1)
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(111),___L_c_23__2a__2a_readenv_2d_open)
___DEF_SLBL(16,___L16_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___FALSEP(___STK(-5)))
   ___GOTO(___L55_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L59_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(17,___L17_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-4))
___DEF_GLBL(___L55_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-6,___R1)
   ___SET_STK(1,___VECTORREF(___R1,___FIX(0L)))
   ___SET_R0(___LBL(18))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),122,___G__23__23_current_2d_readtable)
___DEF_SLBL(18,___L18_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___LBL(28))
   ___SET_R1(___LBL(26))
   ___SET_R3(___FAL)
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(19))
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(6),134,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
___DEF_SLBL(19,___L19_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___IF(___FALSEP(___STK(-5)))
   ___GOTO(___L56_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L58_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(20,___L20_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-4))
___DEF_GLBL(___L56_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(1),___PRC(128),___L_c_23__2a__2a_readenv_2d_close)
___DEF_SLBL(21,___L21_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-5))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___GOTO(___L57_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(23,___L23_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(24,4096)
___DEF_SLBL(24,___L24_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_GLBL(___L57_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L58_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(28))
   ___SET_R0(___LBL(20))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(26,___L26_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(26,2,0,0)
   ___SET_R1(___R2)
   ___POLL(27)
___DEF_SLBL(27,___L27_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(28,___L28_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(28,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R1)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(29),___FAL))
   ___SET_R0(___LBL(30))
   ___ADJFP(8)
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G__23__23_port_2d_name)
___DEF_SLBL(30,___L30_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___STK(-5),___FIX(8L),___SUB(29),___FAL))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),127,___G__23__23_make_2d_locat)
___DEF_SLBL(31,___L31_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_GLBL(___L59_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___SUB(33))
   ___SET_R0(___LBL(33))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(33,___L33_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(34))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(34,___L34_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(17))
   ___JUMPPRM(___SET_NARGS(2),___PRM_write)
___DEF_GLBL(___L60_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(35))
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___DEF_SLBL(35,___L35_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-3))
   ___GOTO(___L54_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_GLBL(___L61_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(36))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),189,___G_path_2d_extension)
___DEF_SLBL(36,___L36_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___EQP(___R1,___SUB(34)))
   ___GOTO(___L62_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L71_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(37,___L37_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L72_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L62_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-2,___GLO_c_23_scheme_2d_file_2d_extensions)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(39))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L64_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L63_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(23))
   ___ADJFP(8)
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L63_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L64_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(39,___L39_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___CNS(0))
   ___SET_R0(___LBL(40))
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(40,___L40_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L69_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R2(___CAR(___R1))
   ___SET_STK(-2,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(41))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_append)
___DEF_SLBL(41,___L41_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(42))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),163,___G_c_23_open_2d_input_2d_file_2a_)
___DEF_SLBL(42,___L42_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L68_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_STK(-3,___STK(-10))
   ___SET_R3(___CDR(___STK(-6)))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(14))
   ___ADJFP(-3)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L65_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L67_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(43,___L43_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L66_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-11)
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L67_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L65_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R4)
   ___SET_R1(___STK(3))
   ___SET_R0(___LBL(46))
   ___ADJFP(7)
   ___POLL(45)
___DEF_SLBL(45,___L45_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_append)
___DEF_SLBL(46,___L46_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(43))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),163,___G_c_23_open_2d_input_2d_file_2a_)
___DEF_GLBL(___L66_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(47))
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___DEF_SLBL(47,___L47_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-6))
   ___POLL(48)
___DEF_SLBL(48,___L48_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L67_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___POLL(49)
___DEF_SLBL(49,___L49_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___GOTO(___L52_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_GLBL(___L68_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___DEF_GLBL(___L69_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-4))
   ___SET_R0(___LBL(50))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(50,___L50_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L70_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R1(___STK(-4))
___DEF_GLBL(___L70_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SUB(27))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),165,___G_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L71_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___MEMALLOCATEDP(___R1)))
   ___GOTO(___L72_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R2(___SUBTYPE(___R1))
   ___IF(___FIXEQ(___R2,___FIX(19L)))
   ___GOTO(___L73_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L72_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),163,___G_c_23_open_2d_input_2d_file_2a_)
___DEF_GLBL(___L73_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___SUB(34))
   ___SET_R0(___LBL(37))
   ___JUMPPRM(___SET_NARGS(2),___PRM_equal_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_read_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 310
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_read_2d_source)
___DEF_P_HLBL(___L1_c_23_read_2d_source)
___DEF_P_HLBL(___L2_c_23_read_2d_source)
___DEF_P_HLBL(___L3_c_23_read_2d_source)
___DEF_P_HLBL(___L4_c_23_read_2d_source)
___DEF_P_HLBL(___L5_c_23_read_2d_source)
___DEF_P_HLBL(___L6_c_23_read_2d_source)
___DEF_P_HLBL(___L7_c_23_read_2d_source)
___DEF_P_HLBL(___L8_c_23_read_2d_source)
___DEF_P_HLBL(___L9_c_23_read_2d_source)
___DEF_P_HLBL(___L10_c_23_read_2d_source)
___DEF_P_HLBL(___L11_c_23_read_2d_source)
___DEF_P_HLBL(___L12_c_23_read_2d_source)
___DEF_P_HLBL(___L13_c_23_read_2d_source)
___DEF_P_HLBL(___L14_c_23_read_2d_source)
___DEF_P_HLBL(___L15_c_23_read_2d_source)
___DEF_P_HLBL(___L16_c_23_read_2d_source)
___DEF_P_HLBL(___L17_c_23_read_2d_source)
___DEF_P_HLBL(___L18_c_23_read_2d_source)
___DEF_P_HLBL(___L19_c_23_read_2d_source)
___DEF_P_HLBL(___L20_c_23_read_2d_source)
___DEF_P_HLBL(___L21_c_23_read_2d_source)
___DEF_P_HLBL(___L22_c_23_read_2d_source)
___DEF_P_HLBL(___L23_c_23_read_2d_source)
___DEF_P_HLBL(___L24_c_23_read_2d_source)
___DEF_P_HLBL(___L25_c_23_read_2d_source)
___DEF_P_HLBL(___L26_c_23_read_2d_source)
___DEF_P_HLBL(___L27_c_23_read_2d_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_read_2d_source)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23_read_2d_source)
   ___SET_STK(1,___R1)
   ___SET_R1(___R3)
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L37_c_23_read_2d_source)
   ___END_IF
   ___IF(___FALSEP(___R1))
   ___GOTO(___L29_c_23_read_2d_source)
   ___END_IF
   ___GOTO(___L36_c_23_read_2d_source)
___DEF_SLBL(1,___L1_c_23_read_2d_source)
___DEF_GLBL(___L28_c_23_read_2d_source)
   ___SET_R2(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L36_c_23_read_2d_source)
   ___END_IF
___DEF_GLBL(___L29_c_23_read_2d_source)
   ___SET_STK(1,___R0)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(3))
   ___ADJFP(7)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_read_2d_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),130,___G__23__23_path_2d_reference)
___DEF_SLBL(3,___L3_c_23_read_2d_source)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(22))
   ___GOTO(___L30_c_23_read_2d_source)
___DEF_SLBL(4,___L4_c_23_read_2d_source)
   ___SET_R0(___LBL(17))
___DEF_GLBL(___L30_c_23_read_2d_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23_read_2d_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),129,___G__23__23_path_2d__3e_container)
___DEF_SLBL(6,___L6_c_23_read_2d_source)
   ___SET_STK(-5,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___R1)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(0),122,___G__23__23_current_2d_readtable)
___DEF_SLBL(7,___L7_c_23_read_2d_source)
   ___SET_STK(-4,___R1)
   ___SET_STK(-3,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-3),12)
   ___ADD_CLO_ELEM(0,___STK(-6))
   ___END_SETUP_CLO(1)
   ___SET_STK(-6,___STK(-3))
   ___SET_R3(___LBL(10))
   ___SET_R0(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___ADJFP(-3)
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23_read_2d_source)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23_read_2d_source)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),133,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_path)
___DEF_SLBL(10,___L10_c_23_read_2d_source)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(10,2,0,0)
   ___SET_R1(___R2)
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23_read_2d_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(12,___L12_c_23_read_2d_source)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(12,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R4)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(8L),___SUB(29),___FAL))
   ___SET_R0(___LBL(14))
   ___ADJFP(8)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23_read_2d_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),123,___G__23__23_filepos_2d__3e_position)
___DEF_SLBL(14,___L14_c_23_read_2d_source)
   ___SET_R2(___R1)
   ___SET_R1(___CLO(___STK(-5),1))
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),127,___G__23__23_make_2d_locat)
___DEF_SLBL(15,___L15_c_23_read_2d_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23_read_2d_source)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_SLBL(17,___L17_c_23_read_2d_source)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L34_c_23_read_2d_source)
   ___END_IF
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23_read_2d_source)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L31_c_23_read_2d_source)
   ___END_IF
   ___GOTO(___L33_c_23_read_2d_source)
___DEF_SLBL(19,___L19_c_23_read_2d_source)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L32_c_23_read_2d_source)
   ___END_IF
   ___SET_R1(___STK(-7))
   ___SET_R2(___GLO__23__23_scheme_2d_file_2d_extensions)
   ___SET_R0(___LBL(1))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L33_c_23_read_2d_source)
   ___END_IF
___DEF_GLBL(___L31_c_23_read_2d_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R2(___CAAR(___R2))
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23_read_2d_source)
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_append)
___DEF_GLBL(___L32_c_23_read_2d_source)
   ___SET_R1(___FAL)
   ___GOTO(___L28_c_23_read_2d_source)
___DEF_GLBL(___L33_c_23_read_2d_source)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L34_c_23_read_2d_source)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_read_2d_source)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(22,___L22_c_23_read_2d_source)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L35_c_23_read_2d_source)
   ___END_IF
   ___SET_R2(___STK(-7))
   ___SET_R1(___SUB(36))
   ___SET_R0(___STK(-6))
   ___POLL(23)
___DEF_SLBL(23,___L23_c_23_read_2d_source)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),145,___G_c_23_compiler_2d_error)
___DEF_GLBL(___L35_c_23_read_2d_source)
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_read_2d_source)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L36_c_23_read_2d_source)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_read_2d_source)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L37_c_23_read_2d_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(27))
   ___ADJFP(7)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_read_2d_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),189,___G_path_2d_extension)
___DEF_SLBL(27,___L27_c_23_read_2d_source)
   ___SET_R2(___SUB(37))
   ___SET_R0(___LBL(19))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_3d__3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_include_2d_expr_2d__3e_source
#undef ___PH_LBL0
#define ___PH_LBL0 339
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L1_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L2_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L3_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L4_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L5_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L6_c_23_include_2d_expr_2d__3e_source)
___DEF_P_HLBL(___L7_c_23_include_2d_expr_2d__3e_source)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23_include_2d_expr_2d__3e_source)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23_include_2d_expr_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_include_2d_expr_2d__3e_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_include_2d_expr_2d__3e_source)
   ___SET_R1(___CADR(___R1))
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_include_2d_expr_2d__3e_source)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(44),___L_c_23_source_2d_locat)
___DEF_SLBL(4,___L4_c_23_include_2d_expr_2d__3e_source)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(179),___L_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_SLBL(5,___L5_c_23_include_2d_expr_2d__3e_source)
   ___SET_R2(___CAR(___R1))
   ___SET_R1(___STK(-5))
   ___SET_R3(___FAL)
   ___SET_R0(___LBL(6))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(3),___PRC(310),___L_c_23_read_2d_source)
___DEF_SLBL(6,___L6_c_23_include_2d_expr_2d__3e_source)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_include_2d_expr_2d__3e_source)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_make_2d_chartable
#undef ___PH_LBL0
#define ___PH_LBL0 348
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_make_2d_chartable)
___DEF_P_HLBL(___L1_c_23__2a__2a_make_2d_chartable)
___DEF_P_HLBL(___L2_c_23__2a__2a_make_2d_chartable)
___DEF_P_HLBL(___L3_c_23__2a__2a_make_2d_chartable)
___DEF_P_HLBL(___L4_c_23__2a__2a_make_2d_chartable)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_make_2d_chartable)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_make_2d_chartable)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(128L))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_make_2d_chartable)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_vector)
___DEF_SLBL(2,___L2_c_23__2a__2a_make_2d_chartable)
   ___BEGIN_ALLOC_VECTOR(3)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___STK(-6))
   ___ADD_VECTOR_ELEM(2,___NUL)
   ___END_ALLOC_VECTOR(3)
   ___SET_R1(___GET_VECTOR(3))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23__2a__2a_make_2d_chartable)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_make_2d_chartable)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_chartable_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 354
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L1_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L2_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L3_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L4_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L5_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L6_c_23__2a__2a_chartable_2d_ref)
___DEF_P_HLBL(___L7_c_23__2a__2a_chartable_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_chartable_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_chartable_2d_ref)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_chartable_2d_ref)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),144,___G_c_23_character_2d__3e_unicode)
___DEF_SLBL(2,___L2_c_23__2a__2a_chartable_2d_ref)
   ___IF(___NOT(___FIXLT(___R1,___FIX(128L))))
   ___GOTO(___L10_c_23__2a__2a_chartable_2d_ref)
   ___END_IF
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(0L)))
   ___SET_R1(___VECTORREF(___R2,___R1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_chartable_2d_ref)
   ___GOTO(___L8_c_23__2a__2a_chartable_2d_ref)
___DEF_SLBL(4,___L4_c_23__2a__2a_chartable_2d_ref)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L9_c_23__2a__2a_chartable_2d_ref)
   ___END_IF
   ___SET_R1(___CDR(___R1))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_chartable_2d_ref)
___DEF_GLBL(___L8_c_23__2a__2a_chartable_2d_ref)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L9_c_23__2a__2a_chartable_2d_ref)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_chartable_2d_ref)
   ___GOTO(___L8_c_23__2a__2a_chartable_2d_ref)
___DEF_GLBL(___L10_c_23__2a__2a_chartable_2d_ref)
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R0(___LBL(4))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L12_c_23__2a__2a_chartable_2d_ref)
   ___END_IF
   ___GOTO(___L13_c_23__2a__2a_chartable_2d_ref)
___DEF_GLBL(___L11_c_23__2a__2a_chartable_2d_ref)
   ___SET_R2(___CDR(___R2))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_chartable_2d_ref)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L13_c_23__2a__2a_chartable_2d_ref)
   ___END_IF
___DEF_GLBL(___L12_c_23__2a__2a_chartable_2d_ref)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___NOT(___EQP(___R1,___R4)))
   ___GOTO(___L11_c_23__2a__2a_chartable_2d_ref)
   ___END_IF
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L13_c_23__2a__2a_chartable_2d_ref)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_chartable_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 363
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L1_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L2_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L3_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L4_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L5_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L6_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L7_c_23__2a__2a_chartable_2d_set_21_)
___DEF_P_HLBL(___L8_c_23__2a__2a_chartable_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_chartable_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_chartable_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_chartable_2d_set_21_)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),144,___G_c_23_character_2d__3e_unicode)
___DEF_SLBL(2,___L2_c_23__2a__2a_chartable_2d_set_21_)
   ___IF(___NOT(___FIXLT(___R1,___FIX(128L))))
   ___GOTO(___L11_c_23__2a__2a_chartable_2d_set_21_)
   ___END_IF
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(0L)))
   ___VECTORSET(___R2,___R1,___STK(-5)) ___SET_R1(___R2)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_chartable_2d_set_21_)
   ___GOTO(___L9_c_23__2a__2a_chartable_2d_set_21_)
___DEF_SLBL(4,___L4_c_23__2a__2a_chartable_2d_set_21_)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23__2a__2a_chartable_2d_set_21_)
   ___END_IF
   ___SETCDR(___R1,___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_chartable_2d_set_21_)
___DEF_GLBL(___L9_c_23__2a__2a_chartable_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L10_c_23__2a__2a_chartable_2d_set_21_)
   ___SET_R1(___CONS(___STK(-4),___STK(-5)))
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_R1(___CONS(___R1,___R2))
   ___VECTORSET(___STK(-6),___FIX(2L),___R1) ___SET_R1(___STK(-6))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23__2a__2a_chartable_2d_set_21_)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_chartable_2d_set_21_)
   ___GOTO(___L9_c_23__2a__2a_chartable_2d_set_21_)
___DEF_GLBL(___L11_c_23__2a__2a_chartable_2d_set_21_)
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(2L)))
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(4))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L13_c_23__2a__2a_chartable_2d_set_21_)
   ___END_IF
   ___GOTO(___L14_c_23__2a__2a_chartable_2d_set_21_)
___DEF_GLBL(___L12_c_23__2a__2a_chartable_2d_set_21_)
   ___SET_R2(___CDR(___R2))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_chartable_2d_set_21_)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L14_c_23__2a__2a_chartable_2d_set_21_)
   ___END_IF
___DEF_GLBL(___L13_c_23__2a__2a_chartable_2d_set_21_)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___NOT(___EQP(___R1,___R4)))
   ___GOTO(___L12_c_23__2a__2a_chartable_2d_set_21_)
   ___END_IF
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L14_c_23__2a__2a_chartable_2d_set_21_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_make_2d_readtable
#undef ___PH_LBL0
#define ___PH_LBL0 373
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_make_2d_readtable)
___DEF_P_HLBL(___L1_c_23__2a__2a_make_2d_readtable)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_make_2d_readtable)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L_c_23__2a__2a_make_2d_readtable)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___SUB(18))
   ___ADD_VECTOR_ELEM(1,___STK(-3))
   ___ADD_VECTOR_ELEM(2,___STK(-2))
   ___ADD_VECTOR_ELEM(3,___STK(-1))
   ___ADD_VECTOR_ELEM(4,___STK(0))
   ___ADD_VECTOR_ELEM(5,___R1)
   ___ADD_VECTOR_ELEM(6,___R2)
   ___ADD_VECTOR_ELEM(7,___R3)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___ADJFP(-4)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_c_23__2a__2a_make_2d_readtable)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 376
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 378
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_)
   ___VECTORSET(___R1,___FIX(1L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 380
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 382
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_)
   ___VECTORSET(___R1,___FIX(2L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 384
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 386
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_)
   ___VECTORSET(___R1,___FIX(3L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_named_2d_char_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 388
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_named_2d_char_2d_table)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 390
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_)
   ___VECTORSET(___R1,___FIX(4L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 392
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table)
   ___SET_R1(___VECTORREF(___R1,___FIX(5L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 394
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_)
   ___VECTORSET(___R1,___FIX(5L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 396
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table)
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 398
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_)
   ___VECTORSET(___R1,___FIX(6L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 400
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table)
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 402
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_)
   ___VECTORSET(___R1,___FIX(7L),___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 404
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
   ___JUMPINT(___SET_NARGS(2),___PRC(354),___L_c_23__2a__2a_chartable_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 407
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
   ___JUMPINT(___SET_NARGS(3),___PRC(363),___L_c_23__2a__2a_chartable_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_handler
#undef ___PH_LBL0
#define ___PH_LBL0 410
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_handler)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_handler)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_handler)
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_char_2d_handler)
   ___JUMPINT(___SET_NARGS(2),___PRC(354),___L_c_23__2a__2a_chartable_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 413
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
   ___JUMPINT(___SET_NARGS(3),___PRC(363),___L_c_23__2a__2a_chartable_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 416
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_P_HLBL(___L2_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_P_HLBL(___L3_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
   ___JUMPINT(___SET_NARGS(3),___PRC(407),___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_)
___DEF_SLBL(2,___L2_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-6))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(413),___L_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_convert_2d_case
#undef ___PH_LBL0
#define ___PH_LBL0 421
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_convert_2d_case)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_convert_2d_case)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_convert_2d_case)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L2_c_23__2a__2a_readtable_2d_convert_2d_case)
   ___END_IF
   ___IF(___NOT(___EQP(___R1,___SYM_upcase)))
   ___GOTO(___L1_c_23__2a__2a_readtable_2d_convert_2d_case)
   ___END_IF
   ___SET_R1(___CHARUPCASE(___R2))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_c_23__2a__2a_readtable_2d_convert_2d_case)
   ___SET_R1(___CHARDOWNCASE(___R2))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L2_c_23__2a__2a_readtable_2d_convert_2d_case)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_
#undef ___PH_LBL0
#define ___PH_LBL0 423
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_P_HLBL(___L2_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_P_HLBL(___L3_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_P_HLBL(___L4_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___IF(___FALSEP(___R1))
   ___GOTO(___L7_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___END_IF
   ___IF(___NOT(___EQP(___R1,___SYM_upcase)))
   ___GOTO(___L8_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___END_IF
   ___SET_R1(___STRINGLENGTH(___R2))
   ___SET_R1(___FIXSUB(___R1,___FIX(1L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___GOTO(___L6_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_GLBL(___L5_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___SET_R3(___STRINGREF(___R1,___R2))
   ___SET_R3(___CHARUPCASE(___R3))
   ___STRINGSET(___R1,___R2,___R3)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_GLBL(___L6_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___IF(___NOT(___FIXLT(___R2,___FIX(0L))))
   ___GOTO(___L5_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___END_IF
___DEF_GLBL(___L7_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___SET_R1(___STRINGLENGTH(___R2))
   ___SET_R1(___FIXSUB(___R1,___FIX(1L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___GOTO(___L10_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_GLBL(___L9_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___SET_R3(___STRINGREF(___R1,___R2))
   ___SET_R3(___CHARDOWNCASE(___R3))
   ___STRINGSET(___R1,___R2,___R3)
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_GLBL(___L10_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___IF(___FIXLT(___R2,___FIX(0L)))
   ___GOTO(___L7_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
   ___END_IF
   ___GOTO(___L9_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readtable_2d_parse_2d_keyword
#undef ___PH_LBL0
#define ___PH_LBL0 429
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_P_HLBL(___L1_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_P_HLBL(___L2_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_P_HLBL(___L3_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_P_HLBL(___L4_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___SET_R1(___VECTORREF(___R1,___FIX(2L)))
   ___SET_STK(1,___R1)
   ___ADJFP(1)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L8_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___END_IF
   ___SET_R1(___STRINGLENGTH(___R2))
   ___IF(___NOT(___FIXLT(___FIX(1L),___R1)))
   ___GOTO(___L7_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___END_IF
   ___IF(___NOT(___EQP(___STK(0),___SYM_prefix)))
   ___GOTO(___L5_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___END_IF
   ___SET_R3(___STRINGREF(___R2,___FIX(0L)))
   ___IF(___NOT(___CHAREQP(___R3,___CHR(58))))
   ___GOTO(___L7_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___END_IF
   ___SET_STK(0,___R0)
   ___SET_R3(___R1)
   ___SET_R1(___R2)
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(3))
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___GOTO(___L6_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_GLBL(___L5_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___SET_R3(___FIXSUB(___R1,___FIX(1L)))
   ___SET_R3(___STRINGREF(___R2,___R3))
   ___IF(___NOT(___CHAREQP(___R3,___CHR(58))))
   ___GOTO(___L7_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___END_IF
   ___SET_STK(0,___R0)
   ___SET_R3(___FIXSUB(___R1,___FIX(1L)))
   ___SET_R1(___R2)
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(3))
   ___ADJFP(3)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___DEF_GLBL(___L6_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___JUMPPRM(___SET_NARGS(3),___PRM_substring)
___DEF_GLBL(___L7_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___SET_R1(___FAL)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___SET_R0(___STK(-3))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),170,___G_c_23_string_2d__3e_keyword_2d_object)
___DEF_GLBL(___L8_c_23__2a__2a_readtable_2d_parse_2d_keyword)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected
#undef ___PH_LBL0
#define ___PH_LBL0 435
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(38))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected
#undef ___PH_LBL0
#define ___PH_LBL0 438
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(39))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot
#undef ___PH_LBL0
#define ___PH_LBL0 441
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(40))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached
#undef ___PH_LBL0
#define ___PH_LBL0 444
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(41))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_incomplete
#undef ___PH_LBL0
#define ___PH_LBL0 447
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_incomplete)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_incomplete)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_incomplete)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_incomplete)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(42))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_incomplete)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_char_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 450
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_char_2d_name)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_char_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_char_2d_name)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_char_2d_name)
   ___SET_R3(___R2)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(43))
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_char_2d_name)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char
#undef ___PH_LBL0
#define ___PH_LBL0 453
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
   ___SET_R3(___R2)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(44))
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u8
#undef ___PH_LBL0
#define ___PH_LBL0 456
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u8)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u8)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_u8)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_u8)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(45))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u8)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u16
#undef ___PH_LBL0
#define ___PH_LBL0 459
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u16)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u16)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_u16)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_u16)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(46))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u16)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u32
#undef ___PH_LBL0
#define ___PH_LBL0 462
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u32)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u32)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_u32)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_u32)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(47))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u32)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u64
#undef ___PH_LBL0
#define ___PH_LBL0 465
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_u64)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_u64)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_u64)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_u64)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(48))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u64)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64
#undef ___PH_LBL0
#define ___PH_LBL0 468
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(49))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_hex
#undef ___PH_LBL0
#define ___PH_LBL0 471
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_hex)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_hex)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_hex)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_hex)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(50))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_hex)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char
#undef ___PH_LBL0
#define ___PH_LBL0 474
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
   ___SET_R3(___R2)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(51))
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 477
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_vector)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_vector)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(52))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_vector)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token
#undef ___PH_LBL0
#define ___PH_LBL0 480
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
   ___SET_R3(___R2)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(53))
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 483
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
   ___SET_R3(___R2)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(54))
   ___SET_R4(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_char_2d_range
#undef ___PH_LBL0
#define ___PH_LBL0 486
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_error_2d_char_2d_range)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_error_2d_char_2d_range)
   ___SET_STK(1,___R1)
   ___SET_R2(___SUB(55))
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_char_2d_range)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_peek_2d_next_2d_char
#undef ___PH_LBL0
#define ___PH_LBL0 489
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_P_HLBL(___L1_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_P_HLBL(___L2_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_P_HLBL(___L3_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_P_HLBL(___L4_c_23__2a__2a_peek_2d_next_2d_char)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_peek_2d_next_2d_char)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_peek_2d_next_2d_char)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_peek_2d_next_2d_char)
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(2,___L2_c_23__2a__2a_peek_2d_next_2d_char)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L5_c_23__2a__2a_peek_2d_next_2d_char)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_peek_2d_next_2d_char)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L5_c_23__2a__2a_peek_2d_next_2d_char)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_peek_2d_next_2d_char)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(444),___L_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_next_2d_char
#undef ___PH_LBL0
#define ___PH_LBL0 495
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_next_2d_char)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_next_2d_char)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_next_2d_char)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_next_2d_char)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_next_2d_char)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_next_2d_char)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_next_2d_char)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_next_2d_char)
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_next_2d_char)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L5_c_23__2a__2a_read_2d_next_2d_char)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_next_2d_char)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L5_c_23__2a__2a_read_2d_next_2d_char)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_next_2d_char)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(444),___L_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting
#undef ___PH_LBL0
#define ___PH_LBL0 501
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L8_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___END_IF
   ___IF(___NOT(___CHAREQP(___R1,___STK(-5))))
   ___GOTO(___L7_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___GOTO(___L6_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(447),___L_c_23__2a__2a_read_2d_error_2d_incomplete)
___DEF_GLBL(___L8_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(444),___L_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof
#undef ___PH_LBL0
#define ___PH_LBL0 508
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L7_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L8_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_P_HLBL(___L9_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___JUMPINT(___SET_NARGS(1),___PRC(527),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___IF(___EQP(___R1,___SUB(56)))
   ___GOTO(___L11_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___GOTO(___L10_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
___DEF_GLBL(___L10_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L11_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L12_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___VECTORSET(___STK(-6),___FIX(5L),___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(8,___L8_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(435),___L_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
___DEF_GLBL(___L12_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_datum
#undef ___PH_LBL0
#define ___PH_LBL0 519
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_datum)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_datum)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_datum)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_datum)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_datum)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_datum)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_datum)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_datum)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_datum)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_datum)
   ___JUMPINT(___SET_NARGS(1),___PRC(527),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_datum)
   ___IF(___EQP(___R1,___SUB(56)))
   ___GOTO(___L7_c_23__2a__2a_read_2d_datum)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23__2a__2a_read_2d_datum)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum)
   ___VECTORSET(___STK(-6),___FIX(5L),___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_datum)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_datum)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(438),___L_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none
#undef ___PH_LBL0
#define ___PH_LBL0 527
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___JUMPINT(___SET_NARGS(1),___PRC(534),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___IF(___EQP(___R1,___SUB(57)))
   ___GOTO(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(81),___L_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___VECTORSET(___STK(-6),___FIX(5L),___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(441),___L_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot
#undef ___PH_LBL0
#define ___PH_LBL0 534
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___IF(___CHARP(___R1))
   ___GOTO(___L7_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___END_IF
   ___SET_R1(___SUB(56))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(52),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___SET_R2(___STK(-5))
   ___SET_R1(___VECTORREF(___R1,___FIX(7L)))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(354),___L_c_23__2a__2a_chartable_2d_ref)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_none_2d_marker
#undef ___PH_LBL0
#define ___PH_LBL0 542
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_none_2d_marker)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_none_2d_marker)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23__2a__2a_none_2d_marker)
   ___SET_R1(___SUB(56))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_dot_2d_marker
#undef ___PH_LBL0
#define ___PH_LBL0 544
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_dot_2d_marker)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_dot_2d_marker)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23__2a__2a_dot_2d_marker)
   ___SET_R1(___SUB(57))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 546
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L1_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L2_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L3_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L4_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L5_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L6_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L7_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L8_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L9_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L10_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L11_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L12_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L13_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L14_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L15_c_23__2a__2a_build_2d_list)
___DEF_P_HLBL(___L16_c_23__2a__2a_build_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_list)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_list)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(7)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_list)
   ___JUMPINT(___SET_NARGS(1),___PRC(527),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_list)
   ___IF(___EQP(___R1,___SUB(56)))
   ___GOTO(___L22_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___SET_R1(___CONS(___R1,___NUL))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
   ___SET_STK(-2,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-4))
   ___SET_R0(___STK(-2))
   ___ADJFP(-5)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_list)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_list)
   ___GOTO(___L17_c_23__2a__2a_build_2d_list)
___DEF_SLBL(5,___L5_c_23__2a__2a_build_2d_list)
   ___IF(___EQP(___R1,___SUB(56)))
   ___GOTO(___L19_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___IF(___EQP(___R1,___SUB(57)))
   ___GOTO(___L21_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-9))
   ___SET_R1(___CONS(___R1,___NUL))
   ___SETCDR(___STK(-5),___R1)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___ADJFP(-9)
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23__2a__2a_build_2d_list)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_list)
___DEF_GLBL(___L17_c_23__2a__2a_build_2d_list)
   ___IF(___NOT(___FALSEP(___STK(-1))))
   ___GOTO(___L18_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(5))
   ___ADJFP(9)
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_build_2d_list)
   ___JUMPINT(___SET_NARGS(1),___PRC(527),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_GLBL(___L18_c_23__2a__2a_build_2d_list)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(5))
   ___ADJFP(9)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_build_2d_list)
   ___JUMPINT(___SET_NARGS(1),___PRC(534),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_SLBL(10,___L10_c_23__2a__2a_build_2d_list)
   ___IF(___NOT(___EQP(___R1,___SUB(56))))
   ___GOTO(___L20_c_23__2a__2a_build_2d_list)
   ___END_IF
___DEF_GLBL(___L19_c_23__2a__2a_build_2d_list)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(2),___PRC(501),___L_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_SLBL(11,___L11_c_23__2a__2a_build_2d_list)
   ___SET_R1(___STK(-6))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23__2a__2a_build_2d_list)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___DEF_GLBL(___L20_c_23__2a__2a_build_2d_list)
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-9))
   ___SET_R1(___STK(-11))
   ___SET_R0(___STK(-8))
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23__2a__2a_build_2d_list)
   ___ADJFP(-12)
   ___JUMPINT(___SET_NARGS(1),___PRC(447),___L_c_23__2a__2a_read_2d_error_2d_incomplete)
___DEF_GLBL(___L21_c_23__2a__2a_build_2d_list)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(14))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(14,___L14_c_23__2a__2a_build_2d_list)
   ___SETCDR(___STK(-5),___R1)
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-9))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(527),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_GLBL(___L22_c_23__2a__2a_build_2d_list)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(15))
   ___JUMPINT(___SET_NARGS(2),___PRC(501),___L_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_SLBL(15,___L15_c_23__2a__2a_build_2d_list)
   ___SET_R1(___NUL)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23__2a__2a_build_2d_list)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 564
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L1_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L2_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L3_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L4_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L5_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L6_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L7_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L8_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L9_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L10_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L11_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L12_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L13_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L14_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L15_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L16_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L17_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L18_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L19_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L20_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L21_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L22_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L23_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L24_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L25_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L26_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L27_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L28_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L29_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L30_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L31_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L32_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L33_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L34_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L35_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L36_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L37_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L38_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L39_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L40_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L41_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L42_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L43_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L44_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L45_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L46_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L47_c_23__2a__2a_build_2d_vector)
___DEF_P_HLBL(___L48_c_23__2a__2a_build_2d_vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_vector)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_vector)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___R3)
   ___SET_R1(___STK(2))
   ___SET_R3(___FIX(0L))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_vector)
   ___GOTO(___L49_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_vector)
   ___SET_R2(___VECTORREF(___STK(-11),___FIX(5L)))
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-8))
   ___IF(___EQP(___R1,___SUB(56)))
   ___GOTO(___L50_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___R2)
   ___SET_STK(1,___STK(-11))
   ___SET_STK(2,___STK(-10))
   ___SET_R3(___FIXADD(___STK(-6),___FIX(1L)))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(13))
   ___ADJFP(2)
___DEF_GLBL(___L49_c_23__2a__2a_build_2d_vector)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(2))
   ___ADJFP(10)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_vector)
   ___JUMPINT(___SET_NARGS(1),___PRC(527),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
___DEF_GLBL(___L50_c_23__2a__2a_build_2d_vector)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(501),___L_c_23__2a__2a_read_2d_next_2d_char_2d_expecting)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_vector),___L57_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_u8vector),___L56_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_u16vector),___L55_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_u32vector),___L54_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_u64vector),___L53_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_f32vector),___L52_c_23__2a__2a_build_2d_vector)
   ___IF_GOTO(___EQP(___STK(-10),___SYM_f64vector),___L51_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___VOID)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___DEF_GLBL(___L51_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-9))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),156,___G_c_23_make_2d_f64vect)
___DEF_GLBL(___L52_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-9))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),155,___G_c_23_make_2d_f32vect)
___DEF_GLBL(___L53_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-9))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),159,___G_c_23_make_2d_u64vect)
___DEF_GLBL(___L54_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-9))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),158,___G_c_23_make_2d_u32vect)
___DEF_GLBL(___L55_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-9))
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),157,___G_c_23_make_2d_u16vect)
___DEF_GLBL(___L56_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-9))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),160,___G_c_23_make_2d_u8vect)
___DEF_GLBL(___L57_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FAL)
   ___SET_R0(___STK(-9))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-12)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_vector)
___DEF_SLBL(13,___L13_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___EQP(___STK(-10),___SYM_vector)))
   ___GOTO(___L58_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___R1,___STK(-6),___STK(-5))
   ___ADJFP(-4)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23__2a__2a_build_2d_vector)
   ___GOTO(___L59_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L58_c_23__2a__2a_build_2d_vector)
   ___IF(___EQP(___STK(-10),___SYM_u8vector))
   ___GOTO(___L60_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___IF(___EQP(___STK(-10),___SYM_u16vector))
   ___GOTO(___L83_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___IF(___EQP(___STK(-10),___SYM_u32vector))
   ___GOTO(___L85_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___IF(___EQP(___STK(-10),___SYM_u64vector))
   ___GOTO(___L86_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___IF(___EQP(___STK(-10),___SYM_f32vector))
   ___GOTO(___L87_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___IF(___EQP(___STK(-10),___SYM_f64vector))
   ___GOTO(___L89_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___ADJFP(-4)
   ___POLL(15)
___DEF_SLBL(15,___L15_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L59_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___DEF_GLBL(___L60_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(2),___PRC(59),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_SLBL(16,___L16_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-8,___R1)
   ___SET_R3(___FIX(255L))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(41))
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L61_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___GOTO(___L79_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(17,___L17_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-8,___R1)
   ___SET_R3(___SUB(58))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(39))
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L79_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L61_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L64_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L62_c_23__2a__2a_build_2d_vector)
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L63_c_23__2a__2a_build_2d_vector)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),153,___G_c_23_in_2d_integer_2d_range_3f_)
___DEF_SLBL(19,___L19_c_23__2a__2a_build_2d_vector)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L69_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L62_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L64_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FLONUMP(___R1)))
   ___GOTO(___L67_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L65_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___FAL)
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L66_c_23__2a__2a_build_2d_vector)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L67_c_23__2a__2a_build_2d_vector)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(22))
   ___ADJFP(8)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23__2a__2a_build_2d_vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM_exact_3f_)
___DEF_SLBL(22,___L22_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L68_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___GOTO(___L65_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L68_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(23)
___DEF_SLBL(23,___L23_c_23__2a__2a_build_2d_vector)
   ___GOTO(___L63_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(24,___L24_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L70_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L69_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___FAL)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23__2a__2a_build_2d_vector)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L70_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L73_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___GOTO(___L77_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(26,___L26_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-8,___R1)
   ___SET_R0(___LBL(28))
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L72_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L71_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FLONUMP(___R1)))
   ___GOTO(___L76_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L72_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L77_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L73_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___TRU)
___DEF_GLBL(___L74_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___POLL(27)
___DEF_SLBL(27,___L27_c_23__2a__2a_build_2d_vector)
   ___GOTO(___L66_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(28,___L28_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L75_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(29))
   ___JUMPINT(___SET_NARGS(1),___PRC(468),___L_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___DEF_SLBL(29,___L29_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L75_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(30))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),149,___G_c_23_f64vect_2d_set_21_)
___DEF_SLBL(30,___L30_c_23__2a__2a_build_2d_vector)
   ___SET_R1(___STK(-6))
   ___POLL(31)
___DEF_SLBL(31,___L31_c_23__2a__2a_build_2d_vector)
   ___GOTO(___L59_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L76_c_23__2a__2a_build_2d_vector)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(24))
   ___ADJFP(8)
   ___POLL(32)
___DEF_SLBL(32,___L32_c_23__2a__2a_build_2d_vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_real_3f_)
___DEF_GLBL(___L77_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FLONUMP(___R1)))
   ___GOTO(___L78_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___SET_R1(___FAL)
   ___GOTO(___L74_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L78_c_23__2a__2a_build_2d_vector)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(34))
   ___ADJFP(4)
   ___POLL(33)
___DEF_SLBL(33,___L33_c_23__2a__2a_build_2d_vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM_exact_3f_)
___DEF_SLBL(34,___L34_c_23__2a__2a_build_2d_vector)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___GOTO(___L74_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(35,___L35_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-8,___R1)
   ___SET_R3(___BIGFIX(59,4294967295LL))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(37))
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L61_c_23__2a__2a_build_2d_vector)
   ___END_IF
___DEF_GLBL(___L79_c_23__2a__2a_build_2d_vector)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(19))
   ___ADJFP(8)
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23__2a__2a_build_2d_vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_integer_3f_)
___DEF_SLBL(37,___L37_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L80_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(38))
   ___JUMPINT(___SET_NARGS(1),___PRC(462),___L_c_23__2a__2a_read_2d_error_2d_u32)
___DEF_SLBL(38,___L38_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L80_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(30))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),172,___G_c_23_u32vect_2d_set_21_)
___DEF_SLBL(39,___L39_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L81_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(40))
   ___JUMPINT(___SET_NARGS(1),___PRC(465),___L_c_23__2a__2a_read_2d_error_2d_u64)
___DEF_SLBL(40,___L40_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L81_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(30))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),173,___G_c_23_u64vect_2d_set_21_)
___DEF_SLBL(41,___L41_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L82_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(42))
   ___JUMPINT(___SET_NARGS(1),___PRC(456),___L_c_23__2a__2a_read_2d_error_2d_u8)
___DEF_SLBL(42,___L42_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L82_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(30))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),174,___G_c_23_u8vect_2d_set_21_)
___DEF_GLBL(___L83_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(43))
   ___JUMPINT(___SET_NARGS(2),___PRC(59),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_SLBL(43,___L43_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-8,___R1)
   ___SET_R3(___FIX(65535L))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(44))
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L61_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___GOTO(___L79_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(44,___L44_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L84_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(45))
   ___JUMPINT(___SET_NARGS(1),___PRC(459),___L_c_23__2a__2a_read_2d_error_2d_u16)
___DEF_SLBL(45,___L45_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L84_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(30))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),171,___G_c_23_u16vect_2d_set_21_)
___DEF_GLBL(___L85_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(35))
   ___JUMPINT(___SET_NARGS(2),___PRC(59),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_GLBL(___L86_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(2),___PRC(59),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_GLBL(___L87_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(46))
   ___JUMPINT(___SET_NARGS(2),___PRC(59),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_SLBL(46,___L46_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-8,___R1)
   ___SET_R0(___LBL(47))
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L72_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___GOTO(___L71_c_23__2a__2a_build_2d_vector)
___DEF_SLBL(47,___L47_c_23__2a__2a_build_2d_vector)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L88_c_23__2a__2a_build_2d_vector)
   ___END_IF
   ___VECTORSET(___STK(-11),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(48))
   ___JUMPINT(___SET_NARGS(1),___PRC(468),___L_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
___DEF_SLBL(48,___L48_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L88_c_23__2a__2a_build_2d_vector)
   ___SET_R3(___STK(-8))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(30))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),148,___G_c_23_f32vect_2d_set_21_)
___DEF_GLBL(___L89_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(26))
   ___JUMPINT(___SET_NARGS(2),___PRC(59),___L_c_23__2a__2a_readenv_2d_unwrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_delimited_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 614
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L1_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L2_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L3_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L4_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L5_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L6_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L7_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L8_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_P_HLBL(___L9_c_23__2a__2a_build_2d_delimited_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_delimited_2d_string)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_delimited_2d_string)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_delimited_2d_string)
   ___GOTO(___L10_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
___DEF_GLBL(___L10_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_delimited_2d_string)
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_delimited_2d_string)
   ___IF(___CHARP(___R1))
   ___GOTO(___L13_c_23__2a__2a_build_2d_delimited_2d_string)
   ___END_IF
   ___GOTO(___L11_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(5,___L5_c_23__2a__2a_build_2d_delimited_2d_string)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L12_c_23__2a__2a_build_2d_delimited_2d_string)
   ___END_IF
___DEF_GLBL(___L11_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_build_2d_delimited_2d_string)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_string)
___DEF_GLBL(___L12_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_GLBL(___L13_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(52),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R2(___STK(-3))
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(354),___L_c_23__2a__2a_chartable_2d_ref)
___DEF_SLBL(8,___L8_c_23__2a__2a_build_2d_delimited_2d_string)
   ___STRINGSET(___R1,___STK(-4),___STK(-3))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_build_2d_delimited_2d_string)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 625
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L1_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L2_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L3_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L4_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L5_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L6_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L7_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R3(___FIX(1L))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___JUMPINT(___SET_NARGS(3),___PRC(614),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___SET_STK(-5,___R1)
   ___SET_R2(___FIX(10L))
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d__3e_number)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___END_IF
   ___GOTO(___L8_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L9_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___END_IF
___DEF_GLBL(___L8_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L9_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___DEF_GLBL(___L10_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___SET_R2(___STK(-5))
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(423),___L_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___SET_R2(___STK(-5))
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(429),___L_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_delimited_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 634
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_P_HLBL(___L1_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_P_HLBL(___L2_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_P_HLBL(___L3_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_P_HLBL(___L4_c_23__2a__2a_build_2d_delimited_2d_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___JUMPINT(___SET_NARGS(3),___PRC(614),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(423),___L_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to
#undef ___PH_LBL0
#define ___PH_LBL0 640
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L1_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L2_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L3_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L4_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L5_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L6_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L7_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L8_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L9_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L10_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L11_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L12_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L13_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L14_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L15_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L16_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L17_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L18_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L19_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L20_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L21_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L22_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L23_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L24_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L25_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L26_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L27_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L28_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L29_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L30_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L31_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L32_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L33_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L34_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L35_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L36_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L37_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L38_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L39_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L40_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L41_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L42_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L43_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_P_HLBL(___L44_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(41))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___GOTO(___L46_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___CONS(___R1,___STK(-4)))
   ___SET_R1(___STRINGLENGTH(___R1))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___FIXLT(___R1,___FIX(512L)))
   ___GOTO(___L75_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R3(___R2)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L45_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L46_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R3(___FIX(0L))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___FIXLT(___R3,___FIX(512L))))
   ___GOTO(___L61_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L47_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(8))
   ___ADJFP(8)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(8,___L8_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___CHAREQP(___R1,___STK(-5))))
   ___GOTO(___L66_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___SET_R2(___CHR(32))
   ___SET_R0(___STK(-7))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___GOTO(___L49_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(10,___L10_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L50_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L48_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-5))
   ___SET_R2(___CHR(32))
   ___SET_R0(___STK(-7))
   ___POLL(11)
___DEF_SLBL(11,___L11_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L49_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_string)
___DEF_GLBL(___L50_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(12,___L12_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___GOTO(___L51_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(13,___L13_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(25))
___DEF_GLBL(___L51_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(15))
   ___ADJFP(8)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L52_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(15,___L15_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L48_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(10))
   ___IF(___CHARLTP(___R1,___CHR(48)))
   ___GOTO(___L54_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___GOTO(___L53_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(16,___L16_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L60_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(17))
   ___IF(___CHARLTP(___R1,___CHR(48)))
   ___GOTO(___L54_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L53_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___CHARLTP(___CHR(57),___R1)))
   ___GOTO(___L59_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L54_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___CHARLTP(___R1,___CHR(97))))
   ___GOTO(___L58_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L55_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___CHARLTP(___R1,___CHR(65))))
   ___GOTO(___L57_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L56_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L57_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___BOOLEAN(___CHARLTP(___CHR(70),___R1)))
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L58_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___CHARLTP(___CHR(102),___R1))
   ___GOTO(___L55_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L59_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(17,___L17_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L64_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L60_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___JUMPINT(___SET_NARGS(1),___PRC(471),___L_c_23__2a__2a_read_2d_error_2d_hex)
___DEF_SLBL(18,___L18_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(-3,___R1)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___IF(___FIXLT(___R3,___FIX(512L)))
   ___GOTO(___L47_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___GOTO(___L61_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(19,___L19_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L62_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___CDR(___R1))
   ___SET_STK(-3,___R1)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___IF(___FIXLT(___R3,___FIX(512L)))
   ___GOTO(___L47_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L61_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___R3)
   ___SET_R2(___CHR(32))
   ___POLL(20)
___DEF_SLBL(20,___L20_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_string)
___DEF_GLBL(___L62_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___JUMPINT(___SET_NARGS(2),___PRC(474),___L_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
___DEF_SLBL(21,___L21_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___STRINGSET(___R1,___STK(-4),___STK(-3))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___GOTO(___L63_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(23,___L23_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___STRINGSET(___R1,___STK(-5),___STK(-4))
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L63_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L64_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(25,___L25_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___STRINGSET(___R1,___FIX(0L),___STK(-3))
   ___SET_R2(___FIX(16L))
   ___SET_R0(___LBL(26))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d__3e_number)
___DEF_SLBL(26,___L26_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(18))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(28))
   ___ADJFP(8)
   ___POLL(27)
___DEF_SLBL(27,___L27_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),152,___G_c_23_in_2d_char_2d_range_3f_)
___DEF_SLBL(28,___L28_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L65_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(486),___L_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___DEF_GLBL(___L65_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_GLBL(___L66_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___CHAREQP(___R1,___CHR(92)))
   ___GOTO(___L67_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_STK(-3,___R1)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___IF(___FIXLT(___R3,___FIX(512L)))
   ___GOTO(___L47_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___GOTO(___L61_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L67_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(31))
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(31,___L31_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(35))
   ___IF(___CHARLTP(___R1,___CHR(48)))
   ___GOTO(___L56_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___GOTO(___L68_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(32,___L32_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___FIXLT(___STK(-5),___FIX(3L))))
   ___GOTO(___L48_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L48_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(33))
   ___IF(___CHARLTP(___R1,___CHR(48)))
   ___GOTO(___L56_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L68_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___BOOLEAN(___CHARLTP(___CHR(55),___R1)))
   ___SET_R1(___BOOLEAN(___FALSEP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(33,___L33_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L48_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(34))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(34,___L34_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(23))
   ___GOTO(___L69_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(35,___L35_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L70_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(38))
___DEF_GLBL(___L69_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(32))
   ___ADJFP(8)
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___GOTO(___L52_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L70_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___CHAREQP(___STK(-3),___CHR(120)))
   ___GOTO(___L74_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___IF(___NOT(___CHAREQP(___STK(-3),___STK(-5))))
   ___GOTO(___L71_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_STK(-3,___R1)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(21))
   ___IF(___FIXLT(___R3,___FIX(512L)))
   ___GOTO(___L47_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___GOTO(___L61_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L71_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(19))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L73_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___GOTO(___L56_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L72_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___CDR(___R2))
   ___POLL(37)
___DEF_SLBL(37,___L37_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L56_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
___DEF_GLBL(___L73_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___NOT(___EQP(___R1,___R4)))
   ___GOTO(___L72_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L74_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(38,___L38_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___STRINGSET(___R1,___FIX(0L),___STK(-3))
   ___SET_R2(___FIX(8L))
   ___SET_R0(___LBL(26))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d__3e_number)
___DEF_GLBL(___L75_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(39))
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(39,___L39_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R0(___STK(-3))
   ___POLL(40)
___DEF_SLBL(40,___L40_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(133),___L_c_23__2a__2a_append_2d_strings)
___DEF_SLBL(41,___L41_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R2(___STRINGLENGTH(___R1))
   ___IF(___NOT(___FIXLT(___R2,___FIX(512L))))
   ___GOTO(___L76_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___END_IF
   ___POLL(42)
___DEF_SLBL(42,___L42_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___GOTO(___L63_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_GLBL(___L76_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___SET_R3(___CONS(___R1,___NUL))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___CHECK_HEAP(43,4096)
___DEF_SLBL(43,___L43_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
   ___GOTO(___L45_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_skip_2d_extended_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 686
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L1_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L2_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L3_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L4_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L5_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L6_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L7_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L8_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L9_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L10_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L11_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L12_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L13_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L14_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L15_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_P_HLBL(___L16_c_23__2a__2a_skip_2d_extended_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(2))
   ___ADJFP(10)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(2,___L2_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___GOTO(___L17_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_SLBL(4,___L4_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R3(___R1)
   ___SET_R2(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_GLBL(___L17_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___IF(___NOT(___CHAREQP(___R3,___STK(-2))))
   ___GOTO(___L23_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_GLBL(___L18_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(7,___L7_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___IF(___CHAREQP(___R1,___STK(-9)))
   ___GOTO(___L22_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___END_IF
   ___GOTO(___L19_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_SLBL(8,___L8_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___IF(___CHAREQP(___R1,___STK(-6)))
   ___GOTO(___L20_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___END_IF
___DEF_GLBL(___L19_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___GOTO(___L17_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_GLBL(___L20_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___IF(___FIXLT(___FIX(0L),___STK(-5)))
   ___GOTO(___L21_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___END_IF
   ___SET_R1(___FAL)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(5))
___DEF_GLBL(___L21_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_GLBL(___L22_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(11,___L11_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R3(___R1)
   ___SET_R2(___FIXADD(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___GOTO(___L17_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_GLBL(___L23_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___IF(___NOT(___CHAREQP(___R3,___STK(0))))
   ___GOTO(___L24_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(8))
   ___ADJFP(8)
   ___POLL(13)
___DEF_SLBL(13,___L13_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___GOTO(___L18_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_GLBL(___L24_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(15))
   ___ADJFP(8)
   ___POLL(14)
___DEF_SLBL(14,___L14_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___GOTO(___L18_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_SLBL(15,___L15_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___SET_R3(___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23__2a__2a_skip_2d_extended_2d_comment)
   ___GOTO(___L17_c_23__2a__2a_skip_2d_extended_2d_comment)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 704
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L1_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L2_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L3_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L4_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L5_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L6_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___GOTO(___L7_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_SLBL(2,___L2_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___IF(___CHAREQP(___STK(-5),___CHR(10)))
   ___GOTO(___L8_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_GLBL(___L7_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(5))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(5,___L5_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___IF(___CHARP(___R1))
   ___GOTO(___L9_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___END_IF
___DEF_GLBL(___L8_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___SET_R1(___VOID)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L9_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_sharp
#undef ___PH_LBL0
#define ___PH_LBL0 712
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L7_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L8_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L9_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L10_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L11_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L12_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L13_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L14_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L15_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L16_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L17_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L18_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L19_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L20_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L21_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L22_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L23_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L24_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L25_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L26_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L27_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L28_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L29_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L30_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L31_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L32_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L33_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L34_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L35_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L36_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L37_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L38_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L39_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L40_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L41_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L42_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L43_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L44_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L45_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L46_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L47_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L48_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L49_c_23__2a__2a_read_2d_sharp)
___DEF_P_HLBL(___L50_c_23__2a__2a_read_2d_sharp)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_sharp)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_sharp)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(489),___L_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_sharp)
   ___IF(___CHAREQP(___R1,___CHR(40)))
   ___GOTO(___L78_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___IF(___CHAREQP(___R1,___CHR(92)))
   ___GOTO(___L76_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___IF(___CHAREQP(___R1,___CHR(124)))
   ___GOTO(___L75_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___IF(___CHAREQP(___R1,___CHR(33)))
   ___GOTO(___L64_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___IF(___NOT(___CHAREQP(___R1,___CHR(35))))
   ___GOTO(___L53_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_sharp)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(2L))
   ___SET_R2(___CHR(35))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(3),___PRC(634),___L_c_23__2a__2a_build_2d_delimited_2d_symbol)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_sharp)
   ___GOTO(___L52_c_23__2a__2a_read_2d_sharp)
___DEF_SLBL(8,___L8_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L51_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L52_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_GLBL(___L53_c_23__2a__2a_read_2d_sharp)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(1L))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(3),___PRC(614),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(10,___L10_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R2(___FIX(10L))
   ___SET_R0(___LBL(11))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d__3e_number)
___DEF_SLBL(11,___L11_c_23__2a__2a_read_2d_sharp)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L51_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(60))
   ___SET_R0(___LBL(12))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(12,___L12_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L54_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R1(___GLO_c_23_false_2d_object)
   ___GOTO(___L51_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L54_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(61))
   ___SET_R0(___LBL(13))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(13,___L13_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L55_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R1(___TRU)
   ___GOTO(___L51_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L55_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(62))
   ___SET_R0(___LBL(14))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(14,___L14_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L59_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___SYM_u8vector)
   ___SET_R0(___LBL(8))
   ___GOTO(___L56_c_23__2a__2a_read_2d_sharp)
___DEF_SLBL(15,___L15_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L58_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___SYM_f64vector)
   ___SET_R0(___LBL(8))
___DEF_GLBL(___L56_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(17))
   ___ADJFP(8)
   ___POLL(16)
___DEF_SLBL(16,___L16_c_23__2a__2a_read_2d_sharp)
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(17,___L17_c_23__2a__2a_read_2d_sharp)
   ___IF(___NOT(___CHAREQP(___R1,___CHR(40))))
   ___GOTO(___L57_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_STK(-3,___STK(-7))
   ___SET_STK(-7,___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___CHR(41))
   ___SET_R0(___STK(-3))
   ___POLL(18)
___DEF_SLBL(18,___L18_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(564),___L_c_23__2a__2a_build_2d_vector)
___DEF_GLBL(___L57_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(19)
___DEF_SLBL(19,___L19_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(477),___L_c_23__2a__2a_read_2d_error_2d_vector)
___DEF_GLBL(___L58_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(2),___PRC(480),___L_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
___DEF_GLBL(___L59_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(63))
   ___SET_R0(___LBL(20))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(20,___L20_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L60_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___SYM_u16vector)
   ___SET_R0(___LBL(8))
   ___GOTO(___L56_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L60_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(64))
   ___SET_R0(___LBL(21))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(21,___L21_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L61_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___SYM_u32vector)
   ___SET_R0(___LBL(8))
   ___GOTO(___L56_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L61_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(65))
   ___SET_R0(___LBL(22))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(22,___L22_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L62_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___SYM_u64vector)
   ___SET_R0(___LBL(8))
   ___GOTO(___L56_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L62_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(66))
   ___SET_R0(___LBL(23))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_SLBL(23,___L23_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L63_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-4))
   ___SET_R3(___SYM_f32vector)
   ___SET_R0(___LBL(8))
   ___GOTO(___L56_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L63_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(67))
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_GLBL(___L64_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(24))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(24,___L24_c_23__2a__2a_read_2d_sharp)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(0L))
   ___SET_R2(___CHR(32))
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(3),___PRC(614),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(25,___L25_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(26))
   ___JUMPINT(___SET_NARGS(1),___PRC(52),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(26,___L26_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___VECTORREF(___R1,___FIX(5L)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(852),___L_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_SLBL(27,___L27_c_23__2a__2a_read_2d_sharp)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L65_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(28)
___DEF_SLBL(28,___L28_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(483),___L_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
___DEF_SLBL(29,___L29_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L67_c_23__2a__2a_read_2d_sharp)
   ___END_IF
___DEF_GLBL(___L65_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___CDR(___R1))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(3L)))
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L66_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___DEF_GLBL(___L67_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R2(___FIX(10L))
   ___SET_R0(___LBL(31))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d__3e_number)
___DEF_SLBL(31,___L31_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L68_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___GOTO(___L72_c_23__2a__2a_read_2d_sharp)
___DEF_SLBL(32,___L32_c_23__2a__2a_read_2d_sharp)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L69_c_23__2a__2a_read_2d_sharp)
   ___END_IF
___DEF_GLBL(___L68_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(33)
___DEF_SLBL(33,___L33_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(450),___L_c_23__2a__2a_read_2d_error_2d_char_2d_name)
___DEF_GLBL(___L69_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-4))
   ___GOTO(___L70_c_23__2a__2a_read_2d_sharp)
___DEF_SLBL(34,___L34_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L68_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R1(___STK(-4))
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L73_c_23__2a__2a_read_2d_sharp)
   ___END_IF
___DEF_GLBL(___L70_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R0(___LBL(35))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),152,___G_c_23_in_2d_char_2d_range_3f_)
___DEF_SLBL(35,___L35_c_23__2a__2a_read_2d_sharp)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L71_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(36)
___DEF_SLBL(36,___L36_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(486),___L_c_23__2a__2a_read_2d_error_2d_char_2d_range)
___DEF_GLBL(___L71_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(37))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(37,___L37_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(3L)))
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23__2a__2a_read_2d_sharp)
   ___GOTO(___L66_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L72_c_23__2a__2a_read_2d_sharp)
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L74_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L70_c_23__2a__2a_read_2d_sharp)
   ___END_IF
___DEF_GLBL(___L73_c_23__2a__2a_read_2d_sharp)
   ___IF(___FLONUMP(___R1))
   ___GOTO(___L68_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(32))
   ___JUMPPRM(___SET_NARGS(1),___PRM_exact_3f_)
___DEF_GLBL(___L74_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-4,___R1)
   ___SET_R0(___LBL(34))
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_integer_3f_)
___DEF_GLBL(___L75_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(5L)))
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(39))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(39,___L39_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(1,___STK(-6))
   ___SET_STK(2,___CHR(35))
   ___SET_R3(___CHR(35))
   ___SET_R2(___CHR(124))
   ___SET_R1(___CHR(124))
   ___SET_R0(___LBL(40))
   ___ADJFP(2)
   ___JUMPINT(___SET_NARGS(5),___PRC(686),___L_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_SLBL(40,___L40_c_23__2a__2a_read_2d_sharp)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(534),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_GLBL(___L76_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(42))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(42,___L42_c_23__2a__2a_read_2d_sharp)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(43))
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(43,___L43_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(44))
   ___JUMPINT(___SET_NARGS(1),___PRC(52),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(44,___L44_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(45))
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(45,___L45_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___R1)
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(6L)))
   ___SET_R0(___LBL(46))
   ___JUMPINT(___SET_NARGS(2),___PRC(354),___L_c_23__2a__2a_chartable_2d_ref)
___DEF_SLBL(46,___L46_c_23__2a__2a_read_2d_sharp)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L77_c_23__2a__2a_read_2d_sharp)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(47)
___DEF_SLBL(47,___L47_c_23__2a__2a_read_2d_sharp)
   ___GOTO(___L52_c_23__2a__2a_read_2d_sharp)
___DEF_GLBL(___L77_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(1L))
   ___SET_R0(___LBL(48))
   ___JUMPINT(___SET_NARGS(3),___PRC(614),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(48,___L48_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(49))
   ___JUMPINT(___SET_NARGS(1),___PRC(52),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(49,___L49_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___VECTORREF(___R1,___FIX(4L)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(29))
   ___JUMPINT(___SET_NARGS(2),___PRC(852),___L_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_GLBL(___L78_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(50))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(50,___L50_c_23__2a__2a_read_2d_sharp)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_STK(1,___STK(-6))
   ___SET_R2(___STK(-4))
   ___SET_R3(___CHR(41))
   ___SET_R1(___SYM_vector)
   ___SET_R0(___LBL(6))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(564),___L_c_23__2a__2a_build_2d_vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_whitespace
#undef ___PH_LBL0
#define ___PH_LBL0 764
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_whitespace)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_whitespace)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_whitespace)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_whitespace)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_whitespace)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_whitespace)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_whitespace)
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_whitespace)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_whitespace)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(534),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_single_2d_line_2d_comment
#undef ___PH_LBL0
#define ___PH_LBL0 769
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
   ___JUMPINT(___SET_NARGS(1),___PRC(704),___L_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_single_2d_line_2d_comment)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(534),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_escaped_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 774
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_escaped_2d_string)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_escaped_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_escaped_2d_string)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_escaped_2d_string)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_escaped_2d_string)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_escaped_2d_string)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_escaped_2d_string)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(640),___L_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_escaped_2d_string)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_escaped_2d_string)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_escaped_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 781
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_escaped_2d_symbol)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_escaped_2d_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(640),___L_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_string_2d__3e_symbol)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_quotation
#undef ___PH_LBL0
#define ___PH_LBL0 789
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_quotation)
___DEF_P_HLBL(___L7_c_23__2a__2a_read_2d_quotation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_quotation)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_quotation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_quotation)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_quotation)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_quotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_quotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_quote)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_quotation)
   ___BEGIN_ALLOC_LIST(2,___STK(-5))
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(3L)))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_quotation)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_quotation)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_quasiquotation
#undef ___PH_LBL0
#define ___PH_LBL0 798
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_quasiquotation)
___DEF_P_HLBL(___L7_c_23__2a__2a_read_2d_quasiquotation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_quasiquotation)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_quasiquotation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_quasiquotation)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_quasiquotation)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_quasiquotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_quasiquotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_quasiquote)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_quasiquotation)
   ___BEGIN_ALLOC_LIST(2,___STK(-5))
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(3L)))
   ___CHECK_HEAP(6,4096)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_quasiquotation)
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_quasiquotation)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_unquotation
#undef ___PH_LBL0
#define ___PH_LBL0 807
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L7_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L8_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L9_c_23__2a__2a_read_2d_unquotation)
___DEF_P_HLBL(___L10_c_23__2a__2a_read_2d_unquotation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_unquotation)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_unquotation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_unquotation)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_unquotation)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_unquotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(489),___L_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_unquotation)
   ___IF(___NOT(___CHAREQP(___R1,___CHR(64))))
   ___GOTO(___L11_c_23__2a__2a_read_2d_unquotation)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_unquotation)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_unquotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_unquote_2d_splicing)
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_unquotation)
   ___BEGIN_ALLOC_LIST(2,___STK(-5))
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(3L)))
   ___CHECK_HEAP(8,4096)
___DEF_SLBL(8,___L8_c_23__2a__2a_read_2d_unquotation)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_read_2d_unquotation)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___R3)
___DEF_GLBL(___L11_c_23__2a__2a_read_2d_unquotation)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(10,___L10_c_23__2a__2a_read_2d_unquotation)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_unquote)
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 819
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_list)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_list)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_list)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_list)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_list)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_list)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_list)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_list)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_list)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_list)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_list)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___IF(___NOT(___CHAREQP(___STK(-5),___CHR(91))))
   ___GOTO(___L6_c_23__2a__2a_read_2d_list)
   ___END_IF
   ___SET_R1(___CHR(93))
   ___GOTO(___L7_c_23__2a__2a_read_2d_list)
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_list)
   ___IF(___CHAREQP(___STK(-5),___CHR(123)))
   ___GOTO(___L8_c_23__2a__2a_read_2d_list)
   ___END_IF
   ___SET_R1(___CHR(41))
___DEF_GLBL(___L7_c_23__2a__2a_read_2d_list)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___TRU)
   ___SET_R0(___LBL(4))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(546),___L_c_23__2a__2a_build_2d_list)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_list)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_list)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_GLBL(___L8_c_23__2a__2a_read_2d_list)
   ___SET_R1(___CHR(125))
   ___GOTO(___L7_c_23__2a__2a_read_2d_list)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_none
#undef ___PH_LBL0
#define ___PH_LBL0 826
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_none)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_none)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_none)
   ___SET_R1(___SUB(56))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_illegal
#undef ___PH_LBL0
#define ___PH_LBL0 828
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_illegal)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_illegal)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_illegal)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_illegal)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_illegal)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_illegal)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_illegal)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_illegal)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_illegal)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_illegal)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_illegal)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(453),___L_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_dot
#undef ___PH_LBL0
#define ___PH_LBL0 834
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L6_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L7_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L8_c_23__2a__2a_read_2d_dot)
___DEF_P_HLBL(___L9_c_23__2a__2a_read_2d_dot)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_dot)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_dot)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_dot)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_dot)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_dot)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(84),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_dot)
   ___IF(___CHARP(___R1))
   ___GOTO(___L12_c_23__2a__2a_read_2d_dot)
   ___END_IF
   ___GOTO(___L10_c_23__2a__2a_read_2d_dot)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_dot)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_c_23__2a__2a_read_2d_dot)
   ___END_IF
___DEF_GLBL(___L10_c_23__2a__2a_read_2d_dot)
   ___SET_R1(___SUB(57))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_dot)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L11_c_23__2a__2a_read_2d_dot)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(625),___L_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_dot)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_read_2d_dot)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_GLBL(___L12_c_23__2a__2a_read_2d_dot)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(1),___PRC(52),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(9,___L9_c_23__2a__2a_read_2d_dot)
   ___SET_R2(___STK(-3))
   ___SET_R1(___VECTORREF(___R1,___FIX(6L)))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(354),___L_c_23__2a__2a_chartable_2d_ref)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 845
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(87),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___VECTORSET(___STK(-6),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(625),___L_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(56),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_
#undef ___PH_LBL0
#define ___PH_LBL0 852
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_P_HLBL(___L1_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_P_HLBL(___L2_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_P_HLBL(___L3_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_P_HLBL(___L4_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_P_HLBL(___L5_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___GOTO(___L6_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L8_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___END_IF
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L7_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___END_IF
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R4)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_GLBL(___L7_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___SET_R1(___STK(-4))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_make_2d_standard_2d_readtable
#undef ___PH_LBL0
#define ___PH_LBL0 859
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L1_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L2_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L3_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L4_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L5_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L6_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L7_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L8_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L9_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L10_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L11_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L12_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L13_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L14_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L15_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L16_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L17_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L18_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L19_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L20_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L21_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L22_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L23_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L24_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L25_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L26_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L27_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L28_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L29_c_23__2a__2a_make_2d_standard_2d_readtable)
___DEF_P_HLBL(___L30_c_23__2a__2a_make_2d_standard_2d_readtable)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___GLO_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table)
   ___SET_STK(2,___R0)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___JUMPINT(___SET_NARGS(1),___PRC(348),___L_c_23__2a__2a_make_2d_chartable)
___DEF_SLBL(2,___L2_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(-5,___R1)
   ___SET_R1(___PRC(845))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(348),___L_c_23__2a__2a_make_2d_chartable)
___DEF_SLBL(3,___L3_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___SUB(18))
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___TRU)
   ___ADD_VECTOR_ELEM(3,___GLO_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table)
   ___ADD_VECTOR_ELEM(4,___GLO_c_23__2a__2a_standard_2d_named_2d_char_2d_table)
   ___ADD_VECTOR_ELEM(5,___STK(-7))
   ___ADD_VECTOR_ELEM(6,___STK(-5))
   ___ADD_VECTOR_ELEM(7,___R1)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),141,___G_c_23__2a__2a_comply_2d_to_2d_standard_2d_scheme_3f_)
___DEF_SLBL(5,___L5_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L31_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___END_IF
   ___VECTORSET(___STK(-7),___FIX(1L),___TRU)
   ___VECTORSET(___STK(-7),___FIX(2L),___FAL)
___DEF_GLBL(___L31_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_R1(___STK(-7))
   ___SET_R2(___FIX(31L))
   ___SET_R0(___LBL(10))
   ___IF(___FIXLT(___R2,___FIX(0L)))
   ___GOTO(___L33_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___END_IF
___DEF_GLBL(___L32_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(9,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(7))
   ___ADJFP(12)
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),176,___G_c_23_unicode_2d__3e_character)
___DEF_SLBL(7,___L7_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_R3(___PRC(828))
   ___SET_R2(___TRU)
   ___SET_R0(___LBL(8))
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(8,___L8_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_R2(___FIXSUB(___STK(-5),___FIX(1L)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(9)
___DEF_SLBL(9,___L9_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___IF(___NOT(___FIXLT(___R2,___FIX(0L))))
   ___GOTO(___L32_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___END_IF
___DEF_GLBL(___L33_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(10,___L10_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(764))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(32))
   ___SET_R0(___LBL(11))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(11,___L11_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(764))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(10))
   ___SET_R0(___LBL(12))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(12,___L12_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(764))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(13))
   ___SET_R0(___LBL(13))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(13,___L13_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(764))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(9))
   ___SET_R0(___LBL(14))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(14,___L14_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(764))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(12))
   ___SET_R0(___LBL(15))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(15,___L15_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(769))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(59))
   ___SET_R0(___LBL(16))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(16,___L16_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(774))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(34))
   ___SET_R0(___LBL(17))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(17,___L17_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(781))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(124))
   ___SET_R0(___LBL(18))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(18,___L18_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(789))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(39))
   ___SET_R0(___LBL(19))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(19,___L19_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(798))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(96))
   ___SET_R0(___LBL(20))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(20,___L20_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(807))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(44))
   ___SET_R0(___LBL(21))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(21,___L21_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(819))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(40))
   ___SET_R0(___LBL(22))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(22,___L22_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(826))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(41))
   ___SET_R0(___LBL(23))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(23,___L23_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(819))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(91))
   ___SET_R0(___LBL(24))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(24,___L24_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(826))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(93))
   ___SET_R0(___LBL(25))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(25,___L25_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(828))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(123))
   ___SET_R0(___LBL(26))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(26,___L26_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(828))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(125))
   ___SET_R0(___LBL(27))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(27,___L27_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(712))
   ___SET_R2(___FAL)
   ___SET_R1(___CHR(35))
   ___SET_R0(___LBL(28))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(28,___L28_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(834))
   ___SET_R2(___FAL)
   ___SET_R1(___CHR(46))
   ___SET_R0(___LBL(29))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(29,___L29_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_R1(___STK(-7))
   ___POLL(30)
___DEF_SLBL(30,___L30_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___source," _source",___REF_FAL,36,0)
,___DEF_LBL_PROC(___H__20___source,0,-1)
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H__20___source,___OFD(___RETI,12,0,0x3f03fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,8,0,0x3f1fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H__20___source,___OFD(___RETI,12,0,0x3f03fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H__20___source,___OFD(___RETI,12,0,0x3f07fL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,9,0,0x7fL))
,___DEF_LBL_RET(___H__20___source,___OFD(___RETI,12,0,0x3f0ffL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,9,0,0xffL))
,___DEF_LBL_RET(___H__20___source,___OFD(___RETI,12,0,0x3f1ffL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,9,0,0x1ffL))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20___source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_make_2d_source,"c#make-source",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_make_2d_source,2,-1)
,___DEF_LBL_RET(___H_c_23_make_2d_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_source_2d_code,"c#source-code",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_source_2d_code,1,-1)
,___DEF_LBL_RET(___H_c_23_source_2d_code,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_source_2d_locat,"c#source-locat",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_source_2d_locat,1,-1)
,___DEF_LBL_RET(___H_c_23_source_2d_locat,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_make_2d_readenv,"c#**make-readenv",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_make_2d_readenv,5,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_readenv,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_port,"c#**readenv-port",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_port,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_readtable,"c#**readenv-readtable",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_readtable,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_error_2d_proc,"c#**readenv-error-proc",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_error_2d_proc,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_wrap,"c#**readenv-wrap",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_wrap,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_wrap,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_unwrap,"c#**readenv-unwrap",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_unwrap,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_unwrap,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_filepos,"c#**readenv-filepos",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_filepos,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_filepos_2d_set_21_,"c#**readenv-filepos-set!",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_filepos_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_line_2d_count,"c#**readenv-line-count",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_line_2d_count,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_,"c#**readenv-line-count-set!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_char_2d_count,"c#**readenv-char-count",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_char_2d_count,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_,"c#**readenv-char-count-set!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_line_2d_start,"c#**readenv-line-start",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_line_2d_start,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_,"c#**readenv-line-start-set!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_current_2d_filepos,"c#**readenv-current-filepos",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_current_2d_filepos,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_current_2d_filepos,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_previous_2d_filepos,"c#**readenv-previous-filepos",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_previous_2d_filepos,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_previous_2d_filepos,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,"c#**peek-next-char-or-eof",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,"c#**read-next-char-or-eof",___REF_FAL,5,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_make_2d_filepos,"c#**make-filepos",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_make_2d_filepos,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_filepos,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_filepos,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_filepos,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_filepos,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_filepos,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_filepos,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_filepos_2d_line,"c#**filepos-line",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_filepos_2d_line,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_filepos_2d_line,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_filepos_2d_line,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_filepos_2d_line,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_filepos_2d_col,"c#**filepos-col",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_filepos_2d_col,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_filepos_2d_col,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_filepos_2d_col,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_filepos_2d_col,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_open,"c#**readenv-open",___REF_FAL,16,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_open,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,2,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,2,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETN,5,2,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,8,0x3f03L))
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_open,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_open,2,1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_open,3,1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_open,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readenv_2d_close,"c#**readenv-close",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readenv_2d_close,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readenv_2d_close,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_false_2d_obj,"c#false-obj",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23_false_2d_obj,0,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_append_2d_strings,"c#**append-strings",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_append_2d_strings,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_append_2d_strings,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_INTRO(___H_c_23_string_2d__3e_canonical_2d_symbol,"c#string->canonical-symbol",___REF_FAL,5,
0)
,___DEF_LBL_PROC(___H_c_23_string_2d__3e_canonical_2d_symbol,1,-1)
,___DEF_LBL_RET(___H_c_23_string_2d__3e_canonical_2d_symbol,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_string_2d__3e_canonical_2d_symbol,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_string_2d__3e_canonical_2d_symbol,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_string_2d__3e_canonical_2d_symbol,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23_re_2d__3e_locat,"c#re->locat",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_re_2d__3e_locat,2,-1)
,___DEF_LBL_RET(___H_c_23_re_2d__3e_locat,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_expr_2d__3e_locat,"c#expr->locat",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23_expr_2d__3e_locat,2,-1)
,___DEF_LBL_RET(___H_c_23_expr_2d__3e_locat,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_locat_2d_show,"c#locat-show",___REF_FAL,22,0)
,___DEF_LBL_PROC(___H_c_23_locat_2d_show,2,-1)
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x1bL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x1dL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_locat_2d_show,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_locat_2d_filename_2d_and_2d_line,"c#locat-filename-and-line",___REF_FAL,12,
0)
,___DEF_LBL_PROC(___H_c_23_locat_2d_filename_2d_and_2d_line,1,-1)
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename_2d_and_2d_line,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23_locat_2d_filename,"c#locat-filename",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23_locat_2d_filename,1,-1)
,___DEF_LBL_RET(___H_c_23_locat_2d_filename,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_locat_2d_filename,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23_expression_2d__3e_source,"c#expression->source",___REF_FAL,37,0)
,___DEF_LBL_PROC(___H_c_23_expression_2d__3e_source,2,-1)
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x11L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_INTRO(___H_c_23_source_2d__3e_expression,"c#source->expression",___REF_FAL,22,0)
,___DEF_LBL_PROC(___H_c_23_source_2d__3e_expression,1,-1)
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_source_2d__3e_expression,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,"c#include-expr->sourcezzzzz",___REF_FAL,
51,0)
,___DEF_LBL_PROC(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,2,-1)
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x17L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,0,0x45L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,0,0x107L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_PROC(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,2,-1)
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,2,-1)
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x15L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,0,0x7fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x22L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_INTRO(___H_c_23_read_2d_source,"c#read-source",___REF_FAL,28,0)
,___DEF_LBL_PROC(___H_c_23_read_2d_source,3,-1)
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,1,0x2L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,2,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,5,8,0x3f0bL))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,5,8,0x3f0bL))
,___DEF_LBL_PROC(___H_c_23_read_2d_source,2,-1)
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_read_2d_source,2,1)
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETI,8,1,0x3f07L))
,___DEF_LBL_RET(___H_c_23_read_2d_source,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_INTRO(___H_c_23_include_2d_expr_2d__3e_source,"c#include-expr->source",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23_include_2d_expr_2d__3e_source,2,-1)
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_make_2d_chartable,"c#**make-chartable",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_make_2d_chartable,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_chartable,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_chartable,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_chartable,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_chartable,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_chartable_2d_ref,"c#**chartable-ref",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_chartable_2d_ref,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_ref,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_chartable_2d_set_21_,"c#**chartable-set!",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_chartable_2d_set_21_,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_chartable_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_make_2d_readtable,"c#**make-readtable",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_make_2d_readtable,7,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_readtable,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_,"c#**readtable-case-conversion?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_,"c#**readtable-case-conversion?-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_,"c#**readtable-keywords-allowed?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_,"c#**readtable-keywords-allowed?-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table,"c#**readtable-escaped-char-table",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_,"c#**readtable-escaped-char-table-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_named_2d_char_2d_table,"c#**readtable-named-char-table",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_named_2d_char_2d_table,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_,"c#**readtable-named-char-table-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table,"c#**readtable-sharp-bang-table",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_,"c#**readtable-sharp-bang-table-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table,"c#**readtable-char-delimiter?-table",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_,"c#**readtable-char-delimiter?-table-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table,"c#**readtable-char-handler-table",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table,1,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_,"c#**readtable-char-handler-table-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_,"c#**readtable-char-delimiter?",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_,"c#**readtable-char-delimiter?-set!",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_handler,"c#**readtable-char-handler",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_handler,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_handler,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_,"c#**readtable-char-handler-set!",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,"c#**readtable-char-class-set!",___REF_FAL,
4,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,4,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,___IFD(___RETI,8,1,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_convert_2d_case,"c#**readtable-convert-case",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_convert_2d_case,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,"c#**readtable-string-convert-case!",
___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_readtable_2d_parse_2d_keyword,"c#**readtable-parse-keyword",___REF_FAL,
5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_readtable_2d_parse_2d_keyword,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_parse_2d_keyword,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_parse_2d_keyword,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_parse_2d_keyword,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_readtable_2d_parse_2d_keyword,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected,"c#**read-error-datum-or-eof-expected",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,"c#**read-error-datum-expected",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,"c#**read-error-improperly-placed-dot",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,"c#**read-error-incomplete-form-eof-reached",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_incomplete,"c#**read-error-incomplete",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_incomplete,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_incomplete,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_char_2d_name,"c#**read-error-char-name",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_char_2d_name,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_char_2d_name,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,"c#**read-error-illegal-char",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u8,"c#**read-error-u8",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u8,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u8,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u16,"c#**read-error-u16",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u16,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u16,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u32,"c#**read-error-u32",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u32,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u32,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u64,"c#**read-error-u64",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u64,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u64,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,"c#**read-error-f32/f64",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_hex,"c#**read-error-hex",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_hex,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_hex,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,"c#**read-error-escaped-char",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_vector,"c#**read-error-vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_vector,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_vector,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,"c#**read-error-sharp-token",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,"c#**read-error-sharp-bang-name",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_char_2d_range,"c#**read-error-char-range",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_char_2d_range,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_char_2d_range,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_peek_2d_next_2d_char,"c#**peek-next-char",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_peek_2d_next_2d_char,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_peek_2d_next_2d_char,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_peek_2d_next_2d_char,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_peek_2d_next_2d_char,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_peek_2d_next_2d_char,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_next_2d_char,"c#**read-next-char",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_next_2d_char,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,"c#**read-next-char-expecting",___REF_FAL,
6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,___IFD(___RETI,8,0,0x3f05L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,"c#**read-datum-or-eof",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum,"c#**read-datum",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,"c#**read-datum-or-none",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,"c#**read-datum-or-none-or-dot",___REF_FAL,
7,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETI,8,8,0x3f04L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_none_2d_marker,"c#**none-marker",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_none_2d_marker,0,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_dot_2d_marker,"c#**dot-marker",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_dot_2d_marker,0,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_list,"c#**build-list",___REF_FAL,17,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_list,4,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___OFD(___RETI,12,3,0x3f07fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETN,9,3,0x3dL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETN,9,3,0x28L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___OFD(___RETI,12,3,0x3f008L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETN,9,3,0x7dL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETN,5,1,0x2L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_list,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_vector,"c#**build-vector",___REF_FAL,49,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_vector,4,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,2,4,0x3f3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,2,0x3f03fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x26L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,2,0x3f004L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___OFD(___RETI,12,12,0x3f000L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xe7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,2,0x3f04L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xa7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xa7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xa7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xafL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x2eL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,5,2,0x6L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,2,0x3f06L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xa7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xafL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x2eL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xafL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x2eL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xafL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x2eL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xa7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xafL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x2eL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xa7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0xafL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_vector,___IFD(___RETN,9,2,0x2eL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_delimited_2d_string,"c#**build-delimited-string",___REF_FAL,10,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_delimited_2d_string,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0x19L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,"c#**build-delimited-number/keyword/symbol",
___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_delimited_2d_symbol,"c#**build-delimited-symbol",___REF_FAL,5,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_delimited_2d_symbol,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_symbol,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_symbol,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_symbol,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_symbol,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,"c#**build-escaped-string-up-to",
___REF_FAL,45,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x19L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_skip_2d_extended_2d_comment,"c#**skip-extended-comment",___REF_FAL,17,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_skip_2d_extended_2d_comment,5,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___OFD(___RETI,12,4,0x3f03fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETN,9,4,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___OFD(___RETI,12,4,0x3f07fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___OFD(___RETI,12,4,0x3f010L))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___OFD(___RETI,12,4,0x3f07fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___OFD(___RETI,12,4,0x3f07fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETN,9,4,0x7fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_extended_2d_comment,___IFD(___RETI,4,4,0x3ffL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,"c#**skip-single-line-comment",___REF_FAL,
7,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_sharp,"c#**read-sharp",___REF_FAL,51,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_sharp,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_sharp,___IFD(___RETN,5,0,0xbL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_whitespace,"c#**read-whitespace",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_whitespace,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_whitespace,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_whitespace,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_whitespace,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_single_2d_line_2d_comment,"c#**read-single-line-comment",___REF_FAL,
4,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_single_2d_line_2d_comment,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_single_2d_line_2d_comment,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_single_2d_line_2d_comment,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_single_2d_line_2d_comment,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_escaped_2d_string,"c#**read-escaped-string",___REF_FAL,6,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_escaped_2d_string,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_string,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_string,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_string,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_string,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_string,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,"c#**read-escaped-symbol",___REF_FAL,7,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_escaped_2d_symbol,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_quotation,"c#**read-quotation",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_quotation,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_quasiquotation,"c#**read-quasiquotation",___REF_FAL,8,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_quasiquotation,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_unquotation,"c#**read-unquotation",___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_unquotation,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_list,"c#**read-list",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_list,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_list,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_list,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_list,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_list,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_list,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_none,"c#**read-none",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_none,2,-1)
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_illegal,"c#**read-illegal",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_illegal,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_illegal,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_illegal,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_illegal,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_illegal,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_dot,"c#**read-dot",___REF_FAL,10,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_dot,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,"c#**read-number/keyword/symbol",
___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,"c#**read-assoc-string-ci=?",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_make_2d_standard_2d_readtable,"c#**make-standard-readtable",___REF_FAL,
31,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_make_2d_standard_2d_readtable,0,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,8,1,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___OFD(___RETI,12,0,0x3f107L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,9,0,0x107L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,1,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,8,1,0x3f02L))
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f0ffL)
,___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,1)
               ___GCMAP1(0x3f002L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f008L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f004L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f000L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f03fL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f010L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f07fL)
,___DEF_OFD(___RETI,12,0)
               ___GCMAP1(0x3f107L)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20___source,1)
___DEF_MOD_PRM(114,___G_c_23_make_2d_source,38)
___DEF_MOD_PRM(118,___G_c_23_source_2d_code,41)
___DEF_MOD_PRM(119,___G_c_23_source_2d_locat,44)
___DEF_MOD_PRM(16,___G_c_23__2a__2a_make_2d_readenv,47)
___DEF_MOD_PRM(73,___G_c_23__2a__2a_readenv_2d_port,50)
___DEF_MOD_PRM(75,___G_c_23__2a__2a_readenv_2d_readtable,52)
___DEF_MOD_PRM(65,___G_c_23__2a__2a_readenv_2d_error_2d_proc,54)
___DEF_MOD_PRM(77,___G_c_23__2a__2a_readenv_2d_wrap,56)
___DEF_MOD_PRM(76,___G_c_23__2a__2a_readenv_2d_unwrap,59)
___DEF_MOD_PRM(66,___G_c_23__2a__2a_readenv_2d_filepos,62)
___DEF_MOD_PRM(67,___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_,64)
___DEF_MOD_PRM(68,___G_c_23__2a__2a_readenv_2d_line_2d_count,66)
___DEF_MOD_PRM(69,___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_,68)
___DEF_MOD_PRM(61,___G_c_23__2a__2a_readenv_2d_char_2d_count,70)
___DEF_MOD_PRM(62,___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_,72)
___DEF_MOD_PRM(70,___G_c_23__2a__2a_readenv_2d_line_2d_start,74)
___DEF_MOD_PRM(71,___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_,76)
___DEF_MOD_PRM(64,___G_c_23__2a__2a_readenv_2d_current_2d_filepos,78)
___DEF_MOD_PRM(74,___G_c_23__2a__2a_readenv_2d_previous_2d_filepos,81)
___DEF_MOD_PRM(21,___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,84)
___DEF_MOD_PRM(52,___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,87)
___DEF_MOD_PRM(15,___G_c_23__2a__2a_make_2d_filepos,93)
___DEF_MOD_PRM(12,___G_c_23__2a__2a_filepos_2d_line,101)
___DEF_MOD_PRM(11,___G_c_23__2a__2a_filepos_2d_col,106)
___DEF_MOD_PRM(72,___G_c_23__2a__2a_readenv_2d_open,111)
___DEF_MOD_PRM(63,___G_c_23__2a__2a_readenv_2d_close,128)
___DEF_MOD_PRM(108,___G_c_23_false_2d_obj,131)
___DEF_MOD_PRM(1,___G_c_23__2a__2a_append_2d_strings,133)
___DEF_MOD_PRM(120,___G_c_23_string_2d__3e_canonical_2d_symbol,144)
___DEF_MOD_PRM(115,___G_c_23_re_2d__3e_locat,150)
___DEF_MOD_PRM(106,___G_c_23_expr_2d__3e_locat,153)
___DEF_MOD_PRM(113,___G_c_23_locat_2d_show,156)
___DEF_MOD_PRM(112,___G_c_23_locat_2d_filename_2d_and_2d_line,179)
___DEF_MOD_PRM(111,___G_c_23_locat_2d_filename,192)
___DEF_MOD_PRM(107,___G_c_23_expression_2d__3e_source,197)
___DEF_MOD_PRM(117,___G_c_23_source_2d__3e_expression,235)
___DEF_MOD_PRM(110,___G_c_23_include_2d_expr_2d__3e_sourcezzzzz,258)
___DEF_MOD_PRM(116,___G_c_23_read_2d_source,310)
___DEF_MOD_PRM(109,___G_c_23_include_2d_expr_2d__3e_source,339)
___DEF_MOD_PRM(14,___G_c_23__2a__2a_make_2d_chartable,348)
___DEF_MOD_PRM(8,___G_c_23__2a__2a_chartable_2d_ref,354)
___DEF_MOD_PRM(9,___G_c_23__2a__2a_chartable_2d_set_21_,363)
___DEF_MOD_PRM(17,___G_c_23__2a__2a_make_2d_readtable,373)
___DEF_MOD_PRM(78,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_,376)
___DEF_MOD_PRM(79,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_,378)
___DEF_MOD_PRM(92,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_,380)
___DEF_MOD_PRM(93,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_,382)
___DEF_MOD_PRM(90,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table,384)
___DEF_MOD_PRM(91,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_,386)
___DEF_MOD_PRM(94,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table,388)
___DEF_MOD_PRM(95,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_,390)
___DEF_MOD_PRM(97,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table,392)
___DEF_MOD_PRM(98,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_,394)
___DEF_MOD_PRM(83,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table,396)
___DEF_MOD_PRM(84,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_,398)
___DEF_MOD_PRM(87,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table,400)
___DEF_MOD_PRM(88,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_,402)
___DEF_MOD_PRM(81,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_,404)
___DEF_MOD_PRM(82,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_,407)
___DEF_MOD_PRM(85,___G_c_23__2a__2a_readtable_2d_char_2d_handler,410)
___DEF_MOD_PRM(86,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_,413)
___DEF_MOD_PRM(80,___G_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,416)
___DEF_MOD_PRM(89,___G_c_23__2a__2a_readtable_2d_convert_2d_case,421)
___DEF_MOD_PRM(99,___G_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,423)
___DEF_MOD_PRM(96,___G_c_23__2a__2a_readtable_2d_parse_2d_keyword,429)
___DEF_MOD_PRM(31,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected,435)
___DEF_MOD_PRM(30,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,438)
___DEF_MOD_PRM(36,___G_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,441)
___DEF_MOD_PRM(38,___G_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,444)
___DEF_MOD_PRM(37,___G_c_23__2a__2a_read_2d_error_2d_incomplete,447)
___DEF_MOD_PRM(28,___G_c_23__2a__2a_read_2d_error_2d_char_2d_name,450)
___DEF_MOD_PRM(35,___G_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,453)
___DEF_MOD_PRM(44,___G_c_23__2a__2a_read_2d_error_2d_u8,456)
___DEF_MOD_PRM(41,___G_c_23__2a__2a_read_2d_error_2d_u16,459)
___DEF_MOD_PRM(42,___G_c_23__2a__2a_read_2d_error_2d_u32,462)
___DEF_MOD_PRM(43,___G_c_23__2a__2a_read_2d_error_2d_u64,465)
___DEF_MOD_PRM(33,___G_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,468)
___DEF_MOD_PRM(34,___G_c_23__2a__2a_read_2d_error_2d_hex,471)
___DEF_MOD_PRM(32,___G_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,474)
___DEF_MOD_PRM(45,___G_c_23__2a__2a_read_2d_error_2d_vector,477)
___DEF_MOD_PRM(40,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,480)
___DEF_MOD_PRM(39,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,483)
___DEF_MOD_PRM(29,___G_c_23__2a__2a_read_2d_error_2d_char_2d_range,486)
___DEF_MOD_PRM(20,___G_c_23__2a__2a_peek_2d_next_2d_char,489)
___DEF_MOD_PRM(50,___G_c_23__2a__2a_read_2d_next_2d_char,495)
___DEF_MOD_PRM(51,___G_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,501)
___DEF_MOD_PRM(24,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,508)
___DEF_MOD_PRM(23,___G_c_23__2a__2a_read_2d_datum,519)
___DEF_MOD_PRM(25,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none,527)
___DEF_MOD_PRM(26,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,534)
___DEF_MOD_PRM(19,___G_c_23__2a__2a_none_2d_marker,542)
___DEF_MOD_PRM(10,___G_c_23__2a__2a_dot_2d_marker,544)
___DEF_MOD_PRM(6,___G_c_23__2a__2a_build_2d_list,546)
___DEF_MOD_PRM(7,___G_c_23__2a__2a_build_2d_vector,564)
___DEF_MOD_PRM(3,___G_c_23__2a__2a_build_2d_delimited_2d_string,614)
___DEF_MOD_PRM(2,___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,625)
___DEF_MOD_PRM(4,___G_c_23__2a__2a_build_2d_delimited_2d_symbol,634)
___DEF_MOD_PRM(5,___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,640)
___DEF_MOD_PRM(101,___G_c_23__2a__2a_skip_2d_extended_2d_comment,686)
___DEF_MOD_PRM(102,___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,704)
___DEF_MOD_PRM(57,___G_c_23__2a__2a_read_2d_sharp,712)
___DEF_MOD_PRM(60,___G_c_23__2a__2a_read_2d_whitespace,764)
___DEF_MOD_PRM(58,___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment,769)
___DEF_MOD_PRM(46,___G_c_23__2a__2a_read_2d_escaped_2d_string,774)
___DEF_MOD_PRM(47,___G_c_23__2a__2a_read_2d_escaped_2d_symbol,781)
___DEF_MOD_PRM(56,___G_c_23__2a__2a_read_2d_quotation,789)
___DEF_MOD_PRM(55,___G_c_23__2a__2a_read_2d_quasiquotation,798)
___DEF_MOD_PRM(59,___G_c_23__2a__2a_read_2d_unquotation,807)
___DEF_MOD_PRM(49,___G_c_23__2a__2a_read_2d_list,819)
___DEF_MOD_PRM(53,___G_c_23__2a__2a_read_2d_none,826)
___DEF_MOD_PRM(48,___G_c_23__2a__2a_read_2d_illegal,828)
___DEF_MOD_PRM(27,___G_c_23__2a__2a_read_2d_dot,834)
___DEF_MOD_PRM(54,___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,845)
___DEF_MOD_PRM(22,___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,852)
___DEF_MOD_PRM(18,___G_c_23__2a__2a_make_2d_standard_2d_readtable,859)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___source,1)
___DEF_MOD_GLO(114,___G_c_23_make_2d_source,38)
___DEF_MOD_GLO(118,___G_c_23_source_2d_code,41)
___DEF_MOD_GLO(119,___G_c_23_source_2d_locat,44)
___DEF_MOD_GLO(16,___G_c_23__2a__2a_make_2d_readenv,47)
___DEF_MOD_GLO(73,___G_c_23__2a__2a_readenv_2d_port,50)
___DEF_MOD_GLO(75,___G_c_23__2a__2a_readenv_2d_readtable,52)
___DEF_MOD_GLO(65,___G_c_23__2a__2a_readenv_2d_error_2d_proc,54)
___DEF_MOD_GLO(77,___G_c_23__2a__2a_readenv_2d_wrap,56)
___DEF_MOD_GLO(76,___G_c_23__2a__2a_readenv_2d_unwrap,59)
___DEF_MOD_GLO(66,___G_c_23__2a__2a_readenv_2d_filepos,62)
___DEF_MOD_GLO(67,___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_,64)
___DEF_MOD_GLO(68,___G_c_23__2a__2a_readenv_2d_line_2d_count,66)
___DEF_MOD_GLO(69,___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_,68)
___DEF_MOD_GLO(61,___G_c_23__2a__2a_readenv_2d_char_2d_count,70)
___DEF_MOD_GLO(62,___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_,72)
___DEF_MOD_GLO(70,___G_c_23__2a__2a_readenv_2d_line_2d_start,74)
___DEF_MOD_GLO(71,___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_,76)
___DEF_MOD_GLO(64,___G_c_23__2a__2a_readenv_2d_current_2d_filepos,78)
___DEF_MOD_GLO(74,___G_c_23__2a__2a_readenv_2d_previous_2d_filepos,81)
___DEF_MOD_GLO(21,___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,84)
___DEF_MOD_GLO(52,___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,87)
___DEF_MOD_GLO(15,___G_c_23__2a__2a_make_2d_filepos,93)
___DEF_MOD_GLO(12,___G_c_23__2a__2a_filepos_2d_line,101)
___DEF_MOD_GLO(11,___G_c_23__2a__2a_filepos_2d_col,106)
___DEF_MOD_GLO(72,___G_c_23__2a__2a_readenv_2d_open,111)
___DEF_MOD_GLO(63,___G_c_23__2a__2a_readenv_2d_close,128)
___DEF_MOD_GLO(108,___G_c_23_false_2d_obj,131)
___DEF_MOD_GLO(1,___G_c_23__2a__2a_append_2d_strings,133)
___DEF_MOD_GLO(120,___G_c_23_string_2d__3e_canonical_2d_symbol,144)
___DEF_MOD_GLO(115,___G_c_23_re_2d__3e_locat,150)
___DEF_MOD_GLO(106,___G_c_23_expr_2d__3e_locat,153)
___DEF_MOD_GLO(113,___G_c_23_locat_2d_show,156)
___DEF_MOD_GLO(112,___G_c_23_locat_2d_filename_2d_and_2d_line,179)
___DEF_MOD_GLO(111,___G_c_23_locat_2d_filename,192)
___DEF_MOD_GLO(107,___G_c_23_expression_2d__3e_source,197)
___DEF_MOD_GLO(117,___G_c_23_source_2d__3e_expression,235)
___DEF_MOD_GLO(110,___G_c_23_include_2d_expr_2d__3e_sourcezzzzz,258)
___DEF_MOD_GLO(116,___G_c_23_read_2d_source,310)
___DEF_MOD_GLO(109,___G_c_23_include_2d_expr_2d__3e_source,339)
___DEF_MOD_GLO(14,___G_c_23__2a__2a_make_2d_chartable,348)
___DEF_MOD_GLO(8,___G_c_23__2a__2a_chartable_2d_ref,354)
___DEF_MOD_GLO(9,___G_c_23__2a__2a_chartable_2d_set_21_,363)
___DEF_MOD_GLO(17,___G_c_23__2a__2a_make_2d_readtable,373)
___DEF_MOD_GLO(78,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f_,376)
___DEF_MOD_GLO(79,___G_c_23__2a__2a_readtable_2d_case_2d_conversion_3f__2d_set_21_,378)
___DEF_MOD_GLO(92,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f_,380)
___DEF_MOD_GLO(93,___G_c_23__2a__2a_readtable_2d_keywords_2d_allowed_3f__2d_set_21_,382)
___DEF_MOD_GLO(90,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table,384)
___DEF_MOD_GLO(91,___G_c_23__2a__2a_readtable_2d_escaped_2d_char_2d_table_2d_set_21_,386)
___DEF_MOD_GLO(94,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table,388)
___DEF_MOD_GLO(95,___G_c_23__2a__2a_readtable_2d_named_2d_char_2d_table_2d_set_21_,390)
___DEF_MOD_GLO(97,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table,392)
___DEF_MOD_GLO(98,___G_c_23__2a__2a_readtable_2d_sharp_2d_bang_2d_table_2d_set_21_,394)
___DEF_MOD_GLO(83,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table,396)
___DEF_MOD_GLO(84,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_table_2d_set_21_,398)
___DEF_MOD_GLO(87,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table,400)
___DEF_MOD_GLO(88,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_table_2d_set_21_,402)
___DEF_MOD_GLO(81,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_,404)
___DEF_MOD_GLO(82,___G_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f__2d_set_21_,407)
___DEF_MOD_GLO(85,___G_c_23__2a__2a_readtable_2d_char_2d_handler,410)
___DEF_MOD_GLO(86,___G_c_23__2a__2a_readtable_2d_char_2d_handler_2d_set_21_,413)
___DEF_MOD_GLO(80,___G_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_,416)
___DEF_MOD_GLO(89,___G_c_23__2a__2a_readtable_2d_convert_2d_case,421)
___DEF_MOD_GLO(99,___G_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_,423)
___DEF_MOD_GLO(96,___G_c_23__2a__2a_readtable_2d_parse_2d_keyword,429)
___DEF_MOD_GLO(31,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected,435)
___DEF_MOD_GLO(30,___G_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,438)
___DEF_MOD_GLO(36,___G_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,441)
___DEF_MOD_GLO(38,___G_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,444)
___DEF_MOD_GLO(37,___G_c_23__2a__2a_read_2d_error_2d_incomplete,447)
___DEF_MOD_GLO(28,___G_c_23__2a__2a_read_2d_error_2d_char_2d_name,450)
___DEF_MOD_GLO(35,___G_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,453)
___DEF_MOD_GLO(44,___G_c_23__2a__2a_read_2d_error_2d_u8,456)
___DEF_MOD_GLO(41,___G_c_23__2a__2a_read_2d_error_2d_u16,459)
___DEF_MOD_GLO(42,___G_c_23__2a__2a_read_2d_error_2d_u32,462)
___DEF_MOD_GLO(43,___G_c_23__2a__2a_read_2d_error_2d_u64,465)
___DEF_MOD_GLO(33,___G_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,468)
___DEF_MOD_GLO(34,___G_c_23__2a__2a_read_2d_error_2d_hex,471)
___DEF_MOD_GLO(32,___G_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,474)
___DEF_MOD_GLO(45,___G_c_23__2a__2a_read_2d_error_2d_vector,477)
___DEF_MOD_GLO(40,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,480)
___DEF_MOD_GLO(39,___G_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,483)
___DEF_MOD_GLO(29,___G_c_23__2a__2a_read_2d_error_2d_char_2d_range,486)
___DEF_MOD_GLO(20,___G_c_23__2a__2a_peek_2d_next_2d_char,489)
___DEF_MOD_GLO(50,___G_c_23__2a__2a_read_2d_next_2d_char,495)
___DEF_MOD_GLO(51,___G_c_23__2a__2a_read_2d_next_2d_char_2d_expecting,501)
___DEF_MOD_GLO(24,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,508)
___DEF_MOD_GLO(23,___G_c_23__2a__2a_read_2d_datum,519)
___DEF_MOD_GLO(25,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none,527)
___DEF_MOD_GLO(26,___G_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,534)
___DEF_MOD_GLO(19,___G_c_23__2a__2a_none_2d_marker,542)
___DEF_MOD_GLO(10,___G_c_23__2a__2a_dot_2d_marker,544)
___DEF_MOD_GLO(6,___G_c_23__2a__2a_build_2d_list,546)
___DEF_MOD_GLO(7,___G_c_23__2a__2a_build_2d_vector,564)
___DEF_MOD_GLO(3,___G_c_23__2a__2a_build_2d_delimited_2d_string,614)
___DEF_MOD_GLO(2,___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,625)
___DEF_MOD_GLO(4,___G_c_23__2a__2a_build_2d_delimited_2d_symbol,634)
___DEF_MOD_GLO(5,___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,640)
___DEF_MOD_GLO(101,___G_c_23__2a__2a_skip_2d_extended_2d_comment,686)
___DEF_MOD_GLO(102,___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,704)
___DEF_MOD_GLO(57,___G_c_23__2a__2a_read_2d_sharp,712)
___DEF_MOD_GLO(60,___G_c_23__2a__2a_read_2d_whitespace,764)
___DEF_MOD_GLO(58,___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment,769)
___DEF_MOD_GLO(46,___G_c_23__2a__2a_read_2d_escaped_2d_string,774)
___DEF_MOD_GLO(47,___G_c_23__2a__2a_read_2d_escaped_2d_symbol,781)
___DEF_MOD_GLO(56,___G_c_23__2a__2a_read_2d_quotation,789)
___DEF_MOD_GLO(55,___G_c_23__2a__2a_read_2d_quasiquotation,798)
___DEF_MOD_GLO(59,___G_c_23__2a__2a_read_2d_unquotation,807)
___DEF_MOD_GLO(49,___G_c_23__2a__2a_read_2d_list,819)
___DEF_MOD_GLO(53,___G_c_23__2a__2a_read_2d_none,826)
___DEF_MOD_GLO(48,___G_c_23__2a__2a_read_2d_illegal,828)
___DEF_MOD_GLO(27,___G_c_23__2a__2a_read_2d_dot,834)
___DEF_MOD_GLO(54,___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,845)
___DEF_MOD_GLO(22,___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,852)
___DEF_MOD_GLO(18,___G_c_23__2a__2a_make_2d_standard_2d_readtable,859)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S__23__23_type_2d_5,"##type-5")
___DEF_MOD_SYM(1,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55,"##type-9-edd21ef2-ee48-407f-a9a9-c1c361078e55")

___DEF_MOD_SYM(2,___S___source,"_source")
___DEF_MOD_SYM(3,___S_allow_2d_script_3f_,"allow-script?")
___DEF_MOD_SYM(4,___S_container,"container")
___DEF_MOD_SYM(5,___S_dot,"dot")
___DEF_MOD_SYM(6,___S_f32vector,"f32vector")
___DEF_MOD_SYM(7,___S_f64vector,"f64vector")
___DEF_MOD_SYM(8,___S_fields,"fields")
___DEF_MOD_SYM(9,___S_filepos,"filepos")
___DEF_MOD_SYM(10,___S_flags,"flags")
___DEF_MOD_SYM(11,___S_id,"id")
___DEF_MOD_SYM(12,___S_labels,"labels")
___DEF_MOD_SYM(13,___S_name,"name")
___DEF_MOD_SYM(14,___S_none,"none")
___DEF_MOD_SYM(15,___S_port,"port")
___DEF_MOD_SYM(16,___S_prefix,"prefix")
___DEF_MOD_SYM(17,___S_quasiquote,"quasiquote")
___DEF_MOD_SYM(18,___S_quote,"quote")
___DEF_MOD_SYM(19,___S_read_2d_cont,"read-cont")
___DEF_MOD_SYM(20,___S_readenv,"readenv")
___DEF_MOD_SYM(21,___S_readtable,"readtable")
___DEF_MOD_SYM(22,___S_super,"super")
___DEF_MOD_SYM(23,___S_type,"type")
___DEF_MOD_SYM(24,___S_u16vector,"u16vector")
___DEF_MOD_SYM(25,___S_u32vector,"u32vector")
___DEF_MOD_SYM(26,___S_u64vector,"u64vector")
___DEF_MOD_SYM(27,___S_u8vector,"u8vector")
___DEF_MOD_SYM(28,___S_unquote,"unquote")
___DEF_MOD_SYM(29,___S_unquote_2d_splicing,"unquote-splicing")
___DEF_MOD_SYM(30,___S_unwrapper,"unwrapper")
___DEF_MOD_SYM(31,___S_upcase,"upcase")
___DEF_MOD_SYM(32,___S_vector,"vector")
___DEF_MOD_SYM(33,___S_wrapper,"wrapper")
___END_MOD_SYM_KEY

#endif
