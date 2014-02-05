#ifdef ___LINKER_INFO
; File: "_source.c", produced by Gambit-C v4.7.2
(
407002
" _source"
((" _source"))
(
"##current-readtable"
"##filepos-line"
"##read-all-as-a-begin-expr-from-port"
"##readenv->locat"
"##readtable-string-convert-case!"
"##type-5"
"##type-9-edd21ef2-ee48-407f-a9a9-c1c361078e55"
"##vector-ref"
"**filepos-col"
"**filepos-line"
"**read-datum-or-eof"
"**readenv-close"
"**readenv-open"
"**readenv-port"
"+"
"-"
">="
"_source"
"allow-script?"
"and"
"append"
"begin"
"box-object"
"box-object?"
"cadr"
"car"
"cdr"
"close-input-port"
"code"
"col"
"cond"
"cons"
"container"
"current-readtable"
"define"
"display"
"dot"
"else"
"eq?"
"equal?"
"expanded-filename"
"expr"
"expr->locat"
"expr->source"
"expression->source"
"ext"
"exts"
"f32vector"
"f64vector"
"fields"
"filename"
"filename*"
"filename-src"
"filepos"
"final-filename"
"find-source-file"
"first"
"flags"
"format-filepos"
"full-name"
"i"
"id"
"if"
"include"
"include-adt"
"include-expr->source"
"info-port"
"l"
"labels"
"lambda"
"len"
"let"
"let*"
"line"
"list->expression"
"list-convert"
"list-tail-convert"
"loc"
"locat-filename"
"locat-filename-and-line"
"locat-show"
"loop"
"make-source"
"make-vector"
"map"
"name"
"new-str"
"none"
"null?"
"open-error"
"open-input-file*"
"or"
"pair?"
"path-directory"
"path-expand"
"path-extension"
"port"
"prefix"
"pt-syntax-error"
"quasiquote"
"quasiquote-sym"
"quote"
"quote-sym"
"quoting-form?"
"re"
"read-cont"
"read-datum-or-eof"
"read-sources"
"readenv"
"readtable"
"rerooted-filename"
"rest"
"scheme-file-extensions"
"source"
"source->expression"
"source-code"
"source-locat"
"sources"
"str"
"string->canonical-symbol"
"string-append"
"string?"
"super"
"type"
"u16vector"
"u32vector"
"u64vector"
"u8vector"
"unbox-object"
"unquote"
"unquote-splicing"
"unquote-splicing-sym"
"unquote-sym"
"unwrapper"
"upcase"
"v"
"vector"
"vector->expression"
"vector-convert"
"vector-length"
"vector-object?"
"vector-ref"
"vector-set!"
"wrapper"
"write"
"x"
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
"c#**readtable-char-delimiter?"
"c#**readtable-char-delimiter?-set!"
"c#**readtable-char-handler"
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
"c#**readtable-char-delimiter?-table"
"c#**readtable-char-delimiter?-table-set!"
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
 1
)
#else
#define ___VERSION 407002
#define ___MODULE_NAME " _source"
#define ___LINKER_ID ____20___source
#define ___MH_PROC ___H__20___source
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 146
#define ___GLOCOUNT 200
#define ___SUPCOUNT 121
#define ___CNSCOUNT 869
#define ___SUBCOUNT 88
#define ___LBLCOUNT 887
#define ___OFDCOUNT 26
#define ___MODDESCR ___REF_SUB(87)
#include "gambit.h"

___NEED_SYM(___S__23__23_current_2d_readtable)
___NEED_SYM(___S__23__23_filepos_2d_line)
___NEED_SYM(___S__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
___NEED_SYM(___S__23__23_readenv_2d__3e_locat)
___NEED_SYM(___S__23__23_readtable_2d_string_2d_convert_2d_case_21_)
___NEED_SYM(___S__23__23_type_2d_5)
___NEED_SYM(___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55)
___NEED_SYM(___S__23__23_vector_2d_ref)
___NEED_SYM(___S__2a__2a_filepos_2d_col)
___NEED_SYM(___S__2a__2a_filepos_2d_line)
___NEED_SYM(___S__2a__2a_read_2d_datum_2d_or_2d_eof)
___NEED_SYM(___S__2a__2a_readenv_2d_close)
___NEED_SYM(___S__2a__2a_readenv_2d_open)
___NEED_SYM(___S__2a__2a_readenv_2d_port)
___NEED_SYM(___S__2b_)
___NEED_SYM(___S__2d_)
___NEED_SYM(___S__3e__3d_)
___NEED_SYM(___S___source)
___NEED_SYM(___S_allow_2d_script_3f_)
___NEED_SYM(___S_and)
___NEED_SYM(___S_append)
___NEED_SYM(___S_begin)
___NEED_SYM(___S_box_2d_object)
___NEED_SYM(___S_box_2d_object_3f_)
___NEED_SYM(___S_cadr)
___NEED_SYM(___S_car)
___NEED_SYM(___S_cdr)
___NEED_SYM(___S_close_2d_input_2d_port)
___NEED_SYM(___S_code)
___NEED_SYM(___S_col)
___NEED_SYM(___S_cond)
___NEED_SYM(___S_cons)
___NEED_SYM(___S_container)
___NEED_SYM(___S_current_2d_readtable)
___NEED_SYM(___S_define)
___NEED_SYM(___S_display)
___NEED_SYM(___S_dot)
___NEED_SYM(___S_else)
___NEED_SYM(___S_eq_3f_)
___NEED_SYM(___S_equal_3f_)
___NEED_SYM(___S_expanded_2d_filename)
___NEED_SYM(___S_expr)
___NEED_SYM(___S_expr_2d__3e_locat)
___NEED_SYM(___S_expr_2d__3e_source)
___NEED_SYM(___S_expression_2d__3e_source)
___NEED_SYM(___S_ext)
___NEED_SYM(___S_exts)
___NEED_SYM(___S_f32vector)
___NEED_SYM(___S_f64vector)
___NEED_SYM(___S_fields)
___NEED_SYM(___S_filename)
___NEED_SYM(___S_filename_2a_)
___NEED_SYM(___S_filename_2d_src)
___NEED_SYM(___S_filepos)
___NEED_SYM(___S_final_2d_filename)
___NEED_SYM(___S_find_2d_source_2d_file)
___NEED_SYM(___S_first)
___NEED_SYM(___S_flags)
___NEED_SYM(___S_format_2d_filepos)
___NEED_SYM(___S_full_2d_name)
___NEED_SYM(___S_i)
___NEED_SYM(___S_id)
___NEED_SYM(___S_if)
___NEED_SYM(___S_include)
___NEED_SYM(___S_include_2d_adt)
___NEED_SYM(___S_include_2d_expr_2d__3e_source)
___NEED_SYM(___S_info_2d_port)
___NEED_SYM(___S_l)
___NEED_SYM(___S_labels)
___NEED_SYM(___S_lambda)
___NEED_SYM(___S_len)
___NEED_SYM(___S_let)
___NEED_SYM(___S_let_2a_)
___NEED_SYM(___S_line)
___NEED_SYM(___S_list_2d__3e_expression)
___NEED_SYM(___S_list_2d_convert)
___NEED_SYM(___S_list_2d_tail_2d_convert)
___NEED_SYM(___S_loc)
___NEED_SYM(___S_locat_2d_filename)
___NEED_SYM(___S_locat_2d_filename_2d_and_2d_line)
___NEED_SYM(___S_locat_2d_show)
___NEED_SYM(___S_loop)
___NEED_SYM(___S_make_2d_source)
___NEED_SYM(___S_make_2d_vector)
___NEED_SYM(___S_map)
___NEED_SYM(___S_name)
___NEED_SYM(___S_new_2d_str)
___NEED_SYM(___S_none)
___NEED_SYM(___S_null_3f_)
___NEED_SYM(___S_open_2d_error)
___NEED_SYM(___S_open_2d_input_2d_file_2a_)
___NEED_SYM(___S_or)
___NEED_SYM(___S_pair_3f_)
___NEED_SYM(___S_path_2d_directory)
___NEED_SYM(___S_path_2d_expand)
___NEED_SYM(___S_path_2d_extension)
___NEED_SYM(___S_port)
___NEED_SYM(___S_prefix)
___NEED_SYM(___S_pt_2d_syntax_2d_error)
___NEED_SYM(___S_quasiquote)
___NEED_SYM(___S_quasiquote_2d_sym)
___NEED_SYM(___S_quote)
___NEED_SYM(___S_quote_2d_sym)
___NEED_SYM(___S_quoting_2d_form_3f_)
___NEED_SYM(___S_re)
___NEED_SYM(___S_read_2d_cont)
___NEED_SYM(___S_read_2d_datum_2d_or_2d_eof)
___NEED_SYM(___S_read_2d_sources)
___NEED_SYM(___S_readenv)
___NEED_SYM(___S_readtable)
___NEED_SYM(___S_rerooted_2d_filename)
___NEED_SYM(___S_rest)
___NEED_SYM(___S_scheme_2d_file_2d_extensions)
___NEED_SYM(___S_source)
___NEED_SYM(___S_source_2d__3e_expression)
___NEED_SYM(___S_source_2d_code)
___NEED_SYM(___S_source_2d_locat)
___NEED_SYM(___S_sources)
___NEED_SYM(___S_str)
___NEED_SYM(___S_string_2d__3e_canonical_2d_symbol)
___NEED_SYM(___S_string_2d_append)
___NEED_SYM(___S_string_3f_)
___NEED_SYM(___S_super)
___NEED_SYM(___S_type)
___NEED_SYM(___S_u16vector)
___NEED_SYM(___S_u32vector)
___NEED_SYM(___S_u64vector)
___NEED_SYM(___S_u8vector)
___NEED_SYM(___S_unbox_2d_object)
___NEED_SYM(___S_unquote)
___NEED_SYM(___S_unquote_2d_splicing)
___NEED_SYM(___S_unquote_2d_splicing_2d_sym)
___NEED_SYM(___S_unquote_2d_sym)
___NEED_SYM(___S_unwrapper)
___NEED_SYM(___S_upcase)
___NEED_SYM(___S_v)
___NEED_SYM(___S_vector)
___NEED_SYM(___S_vector_2d__3e_expression)
___NEED_SYM(___S_vector_2d_convert)
___NEED_SYM(___S_vector_2d_length)
___NEED_SYM(___S_vector_2d_object_3f_)
___NEED_SYM(___S_vector_2d_ref)
___NEED_SYM(___S_vector_2d_set_21_)
___NEED_SYM(___S_wrapper)
___NEED_SYM(___S_write)
___NEED_SYM(___S_x)

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
___DEF_SYM(0,___S__23__23_current_2d_readtable,"##current-readtable")
___DEF_SYM(1,___S__23__23_filepos_2d_line,"##filepos-line")
___DEF_SYM(2,___S__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port,"##read-all-as-a-begin-expr-from-port")

___DEF_SYM(3,___S__23__23_readenv_2d__3e_locat,"##readenv->locat")
___DEF_SYM(4,___S__23__23_readtable_2d_string_2d_convert_2d_case_21_,"##readtable-string-convert-case!")

___DEF_SYM(5,___S__23__23_type_2d_5,"##type-5")
___DEF_SYM(6,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55,"##type-9-edd21ef2-ee48-407f-a9a9-c1c361078e55")

___DEF_SYM(7,___S__23__23_vector_2d_ref,"##vector-ref")
___DEF_SYM(8,___S__2a__2a_filepos_2d_col,"**filepos-col")
___DEF_SYM(9,___S__2a__2a_filepos_2d_line,"**filepos-line")
___DEF_SYM(10,___S__2a__2a_read_2d_datum_2d_or_2d_eof,"**read-datum-or-eof")
___DEF_SYM(11,___S__2a__2a_readenv_2d_close,"**readenv-close")
___DEF_SYM(12,___S__2a__2a_readenv_2d_open,"**readenv-open")
___DEF_SYM(13,___S__2a__2a_readenv_2d_port,"**readenv-port")
___DEF_SYM(14,___S__2b_,"+")
___DEF_SYM(15,___S__2d_,"-")
___DEF_SYM(16,___S__3e__3d_,">=")
___DEF_SYM(17,___S___source,"_source")
___DEF_SYM(18,___S_allow_2d_script_3f_,"allow-script?")
___DEF_SYM(19,___S_and,"and")
___DEF_SYM(20,___S_append,"append")
___DEF_SYM(21,___S_begin,"begin")
___DEF_SYM(22,___S_box_2d_object,"box-object")
___DEF_SYM(23,___S_box_2d_object_3f_,"box-object?")
___DEF_SYM(24,___S_cadr,"cadr")
___DEF_SYM(25,___S_car,"car")
___DEF_SYM(26,___S_cdr,"cdr")
___DEF_SYM(27,___S_close_2d_input_2d_port,"close-input-port")
___DEF_SYM(28,___S_code,"code")
___DEF_SYM(29,___S_col,"col")
___DEF_SYM(30,___S_cond,"cond")
___DEF_SYM(31,___S_cons,"cons")
___DEF_SYM(32,___S_container,"container")
___DEF_SYM(33,___S_current_2d_readtable,"current-readtable")
___DEF_SYM(34,___S_define,"define")
___DEF_SYM(35,___S_display,"display")
___DEF_SYM(36,___S_dot,"dot")
___DEF_SYM(37,___S_else,"else")
___DEF_SYM(38,___S_eq_3f_,"eq?")
___DEF_SYM(39,___S_equal_3f_,"equal?")
___DEF_SYM(40,___S_expanded_2d_filename,"expanded-filename")
___DEF_SYM(41,___S_expr,"expr")
___DEF_SYM(42,___S_expr_2d__3e_locat,"expr->locat")
___DEF_SYM(43,___S_expr_2d__3e_source,"expr->source")
___DEF_SYM(44,___S_expression_2d__3e_source,"expression->source")
___DEF_SYM(45,___S_ext,"ext")
___DEF_SYM(46,___S_exts,"exts")
___DEF_SYM(47,___S_f32vector,"f32vector")
___DEF_SYM(48,___S_f64vector,"f64vector")
___DEF_SYM(49,___S_fields,"fields")
___DEF_SYM(50,___S_filename,"filename")
___DEF_SYM(51,___S_filename_2a_,"filename*")
___DEF_SYM(52,___S_filename_2d_src,"filename-src")
___DEF_SYM(53,___S_filepos,"filepos")
___DEF_SYM(54,___S_final_2d_filename,"final-filename")
___DEF_SYM(55,___S_find_2d_source_2d_file,"find-source-file")
___DEF_SYM(56,___S_first,"first")
___DEF_SYM(57,___S_flags,"flags")
___DEF_SYM(58,___S_format_2d_filepos,"format-filepos")
___DEF_SYM(59,___S_full_2d_name,"full-name")
___DEF_SYM(60,___S_i,"i")
___DEF_SYM(61,___S_id,"id")
___DEF_SYM(62,___S_if,"if")
___DEF_SYM(63,___S_include,"include")
___DEF_SYM(64,___S_include_2d_adt,"include-adt")
___DEF_SYM(65,___S_include_2d_expr_2d__3e_source,"include-expr->source")
___DEF_SYM(66,___S_info_2d_port,"info-port")
___DEF_SYM(67,___S_l,"l")
___DEF_SYM(68,___S_labels,"labels")
___DEF_SYM(69,___S_lambda,"lambda")
___DEF_SYM(70,___S_len,"len")
___DEF_SYM(71,___S_let,"let")
___DEF_SYM(72,___S_let_2a_,"let*")
___DEF_SYM(73,___S_line,"line")
___DEF_SYM(74,___S_list_2d__3e_expression,"list->expression")
___DEF_SYM(75,___S_list_2d_convert,"list-convert")
___DEF_SYM(76,___S_list_2d_tail_2d_convert,"list-tail-convert")
___DEF_SYM(77,___S_loc,"loc")
___DEF_SYM(78,___S_locat_2d_filename,"locat-filename")
___DEF_SYM(79,___S_locat_2d_filename_2d_and_2d_line,"locat-filename-and-line")
___DEF_SYM(80,___S_locat_2d_show,"locat-show")
___DEF_SYM(81,___S_loop,"loop")
___DEF_SYM(82,___S_make_2d_source,"make-source")
___DEF_SYM(83,___S_make_2d_vector,"make-vector")
___DEF_SYM(84,___S_map,"map")
___DEF_SYM(85,___S_name,"name")
___DEF_SYM(86,___S_new_2d_str,"new-str")
___DEF_SYM(87,___S_none,"none")
___DEF_SYM(88,___S_null_3f_,"null?")
___DEF_SYM(89,___S_open_2d_error,"open-error")
___DEF_SYM(90,___S_open_2d_input_2d_file_2a_,"open-input-file*")
___DEF_SYM(91,___S_or,"or")
___DEF_SYM(92,___S_pair_3f_,"pair?")
___DEF_SYM(93,___S_path_2d_directory,"path-directory")
___DEF_SYM(94,___S_path_2d_expand,"path-expand")
___DEF_SYM(95,___S_path_2d_extension,"path-extension")
___DEF_SYM(96,___S_port,"port")
___DEF_SYM(97,___S_prefix,"prefix")
___DEF_SYM(98,___S_pt_2d_syntax_2d_error,"pt-syntax-error")
___DEF_SYM(99,___S_quasiquote,"quasiquote")
___DEF_SYM(100,___S_quasiquote_2d_sym,"quasiquote-sym")
___DEF_SYM(101,___S_quote,"quote")
___DEF_SYM(102,___S_quote_2d_sym,"quote-sym")
___DEF_SYM(103,___S_quoting_2d_form_3f_,"quoting-form?")
___DEF_SYM(104,___S_re,"re")
___DEF_SYM(105,___S_read_2d_cont,"read-cont")
___DEF_SYM(106,___S_read_2d_datum_2d_or_2d_eof,"read-datum-or-eof")
___DEF_SYM(107,___S_read_2d_sources,"read-sources")
___DEF_SYM(108,___S_readenv,"readenv")
___DEF_SYM(109,___S_readtable,"readtable")
___DEF_SYM(110,___S_rerooted_2d_filename,"rerooted-filename")
___DEF_SYM(111,___S_rest,"rest")
___DEF_SYM(112,___S_scheme_2d_file_2d_extensions,"scheme-file-extensions")
___DEF_SYM(113,___S_source,"source")
___DEF_SYM(114,___S_source_2d__3e_expression,"source->expression")
___DEF_SYM(115,___S_source_2d_code,"source-code")
___DEF_SYM(116,___S_source_2d_locat,"source-locat")
___DEF_SYM(117,___S_sources,"sources")
___DEF_SYM(118,___S_str,"str")
___DEF_SYM(119,___S_string_2d__3e_canonical_2d_symbol,"string->canonical-symbol")
___DEF_SYM(120,___S_string_2d_append,"string-append")
___DEF_SYM(121,___S_string_3f_,"string?")
___DEF_SYM(122,___S_super,"super")
___DEF_SYM(123,___S_type,"type")
___DEF_SYM(124,___S_u16vector,"u16vector")
___DEF_SYM(125,___S_u32vector,"u32vector")
___DEF_SYM(126,___S_u64vector,"u64vector")
___DEF_SYM(127,___S_u8vector,"u8vector")
___DEF_SYM(128,___S_unbox_2d_object,"unbox-object")
___DEF_SYM(129,___S_unquote,"unquote")
___DEF_SYM(130,___S_unquote_2d_splicing,"unquote-splicing")
___DEF_SYM(131,___S_unquote_2d_splicing_2d_sym,"unquote-splicing-sym")
___DEF_SYM(132,___S_unquote_2d_sym,"unquote-sym")
___DEF_SYM(133,___S_unwrapper,"unwrapper")
___DEF_SYM(134,___S_upcase,"upcase")
___DEF_SYM(135,___S_v,"v")
___DEF_SYM(136,___S_vector,"vector")
___DEF_SYM(137,___S_vector_2d__3e_expression,"vector->expression")
___DEF_SYM(138,___S_vector_2d_convert,"vector-convert")
___DEF_SYM(139,___S_vector_2d_length,"vector-length")
___DEF_SYM(140,___S_vector_2d_object_3f_,"vector-object?")
___DEF_SYM(141,___S_vector_2d_ref,"vector-ref")
___DEF_SYM(142,___S_vector_2d_set_21_,"vector-set!")
___DEF_SYM(143,___S_wrapper,"wrapper")
___DEF_SYM(144,___S_write,"write")
___DEF_SYM(145,___S_x,"x")
___END_SYM

#define ___SYM__23__23_current_2d_readtable ___SYM(0,___S__23__23_current_2d_readtable)
#define ___SYM__23__23_filepos_2d_line ___SYM(1,___S__23__23_filepos_2d_line)
#define ___SYM__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port ___SYM(2,___S__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
#define ___SYM__23__23_readenv_2d__3e_locat ___SYM(3,___S__23__23_readenv_2d__3e_locat)
#define ___SYM__23__23_readtable_2d_string_2d_convert_2d_case_21_ ___SYM(4,___S__23__23_readtable_2d_string_2d_convert_2d_case_21_)
#define ___SYM__23__23_type_2d_5 ___SYM(5,___S__23__23_type_2d_5)
#define ___SYM__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55 ___SYM(6,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55)
#define ___SYM__23__23_vector_2d_ref ___SYM(7,___S__23__23_vector_2d_ref)
#define ___SYM__2a__2a_filepos_2d_col ___SYM(8,___S__2a__2a_filepos_2d_col)
#define ___SYM__2a__2a_filepos_2d_line ___SYM(9,___S__2a__2a_filepos_2d_line)
#define ___SYM__2a__2a_read_2d_datum_2d_or_2d_eof ___SYM(10,___S__2a__2a_read_2d_datum_2d_or_2d_eof)
#define ___SYM__2a__2a_readenv_2d_close ___SYM(11,___S__2a__2a_readenv_2d_close)
#define ___SYM__2a__2a_readenv_2d_open ___SYM(12,___S__2a__2a_readenv_2d_open)
#define ___SYM__2a__2a_readenv_2d_port ___SYM(13,___S__2a__2a_readenv_2d_port)
#define ___SYM__2b_ ___SYM(14,___S__2b_)
#define ___SYM__2d_ ___SYM(15,___S__2d_)
#define ___SYM__3e__3d_ ___SYM(16,___S__3e__3d_)
#define ___SYM___source ___SYM(17,___S___source)
#define ___SYM_allow_2d_script_3f_ ___SYM(18,___S_allow_2d_script_3f_)
#define ___SYM_and ___SYM(19,___S_and)
#define ___SYM_append ___SYM(20,___S_append)
#define ___SYM_begin ___SYM(21,___S_begin)
#define ___SYM_box_2d_object ___SYM(22,___S_box_2d_object)
#define ___SYM_box_2d_object_3f_ ___SYM(23,___S_box_2d_object_3f_)
#define ___SYM_cadr ___SYM(24,___S_cadr)
#define ___SYM_car ___SYM(25,___S_car)
#define ___SYM_cdr ___SYM(26,___S_cdr)
#define ___SYM_close_2d_input_2d_port ___SYM(27,___S_close_2d_input_2d_port)
#define ___SYM_code ___SYM(28,___S_code)
#define ___SYM_col ___SYM(29,___S_col)
#define ___SYM_cond ___SYM(30,___S_cond)
#define ___SYM_cons ___SYM(31,___S_cons)
#define ___SYM_container ___SYM(32,___S_container)
#define ___SYM_current_2d_readtable ___SYM(33,___S_current_2d_readtable)
#define ___SYM_define ___SYM(34,___S_define)
#define ___SYM_display ___SYM(35,___S_display)
#define ___SYM_dot ___SYM(36,___S_dot)
#define ___SYM_else ___SYM(37,___S_else)
#define ___SYM_eq_3f_ ___SYM(38,___S_eq_3f_)
#define ___SYM_equal_3f_ ___SYM(39,___S_equal_3f_)
#define ___SYM_expanded_2d_filename ___SYM(40,___S_expanded_2d_filename)
#define ___SYM_expr ___SYM(41,___S_expr)
#define ___SYM_expr_2d__3e_locat ___SYM(42,___S_expr_2d__3e_locat)
#define ___SYM_expr_2d__3e_source ___SYM(43,___S_expr_2d__3e_source)
#define ___SYM_expression_2d__3e_source ___SYM(44,___S_expression_2d__3e_source)
#define ___SYM_ext ___SYM(45,___S_ext)
#define ___SYM_exts ___SYM(46,___S_exts)
#define ___SYM_f32vector ___SYM(47,___S_f32vector)
#define ___SYM_f64vector ___SYM(48,___S_f64vector)
#define ___SYM_fields ___SYM(49,___S_fields)
#define ___SYM_filename ___SYM(50,___S_filename)
#define ___SYM_filename_2a_ ___SYM(51,___S_filename_2a_)
#define ___SYM_filename_2d_src ___SYM(52,___S_filename_2d_src)
#define ___SYM_filepos ___SYM(53,___S_filepos)
#define ___SYM_final_2d_filename ___SYM(54,___S_final_2d_filename)
#define ___SYM_find_2d_source_2d_file ___SYM(55,___S_find_2d_source_2d_file)
#define ___SYM_first ___SYM(56,___S_first)
#define ___SYM_flags ___SYM(57,___S_flags)
#define ___SYM_format_2d_filepos ___SYM(58,___S_format_2d_filepos)
#define ___SYM_full_2d_name ___SYM(59,___S_full_2d_name)
#define ___SYM_i ___SYM(60,___S_i)
#define ___SYM_id ___SYM(61,___S_id)
#define ___SYM_if ___SYM(62,___S_if)
#define ___SYM_include ___SYM(63,___S_include)
#define ___SYM_include_2d_adt ___SYM(64,___S_include_2d_adt)
#define ___SYM_include_2d_expr_2d__3e_source ___SYM(65,___S_include_2d_expr_2d__3e_source)
#define ___SYM_info_2d_port ___SYM(66,___S_info_2d_port)
#define ___SYM_l ___SYM(67,___S_l)
#define ___SYM_labels ___SYM(68,___S_labels)
#define ___SYM_lambda ___SYM(69,___S_lambda)
#define ___SYM_len ___SYM(70,___S_len)
#define ___SYM_let ___SYM(71,___S_let)
#define ___SYM_let_2a_ ___SYM(72,___S_let_2a_)
#define ___SYM_line ___SYM(73,___S_line)
#define ___SYM_list_2d__3e_expression ___SYM(74,___S_list_2d__3e_expression)
#define ___SYM_list_2d_convert ___SYM(75,___S_list_2d_convert)
#define ___SYM_list_2d_tail_2d_convert ___SYM(76,___S_list_2d_tail_2d_convert)
#define ___SYM_loc ___SYM(77,___S_loc)
#define ___SYM_locat_2d_filename ___SYM(78,___S_locat_2d_filename)
#define ___SYM_locat_2d_filename_2d_and_2d_line ___SYM(79,___S_locat_2d_filename_2d_and_2d_line)
#define ___SYM_locat_2d_show ___SYM(80,___S_locat_2d_show)
#define ___SYM_loop ___SYM(81,___S_loop)
#define ___SYM_make_2d_source ___SYM(82,___S_make_2d_source)
#define ___SYM_make_2d_vector ___SYM(83,___S_make_2d_vector)
#define ___SYM_map ___SYM(84,___S_map)
#define ___SYM_name ___SYM(85,___S_name)
#define ___SYM_new_2d_str ___SYM(86,___S_new_2d_str)
#define ___SYM_none ___SYM(87,___S_none)
#define ___SYM_null_3f_ ___SYM(88,___S_null_3f_)
#define ___SYM_open_2d_error ___SYM(89,___S_open_2d_error)
#define ___SYM_open_2d_input_2d_file_2a_ ___SYM(90,___S_open_2d_input_2d_file_2a_)
#define ___SYM_or ___SYM(91,___S_or)
#define ___SYM_pair_3f_ ___SYM(92,___S_pair_3f_)
#define ___SYM_path_2d_directory ___SYM(93,___S_path_2d_directory)
#define ___SYM_path_2d_expand ___SYM(94,___S_path_2d_expand)
#define ___SYM_path_2d_extension ___SYM(95,___S_path_2d_extension)
#define ___SYM_port ___SYM(96,___S_port)
#define ___SYM_prefix ___SYM(97,___S_prefix)
#define ___SYM_pt_2d_syntax_2d_error ___SYM(98,___S_pt_2d_syntax_2d_error)
#define ___SYM_quasiquote ___SYM(99,___S_quasiquote)
#define ___SYM_quasiquote_2d_sym ___SYM(100,___S_quasiquote_2d_sym)
#define ___SYM_quote ___SYM(101,___S_quote)
#define ___SYM_quote_2d_sym ___SYM(102,___S_quote_2d_sym)
#define ___SYM_quoting_2d_form_3f_ ___SYM(103,___S_quoting_2d_form_3f_)
#define ___SYM_re ___SYM(104,___S_re)
#define ___SYM_read_2d_cont ___SYM(105,___S_read_2d_cont)
#define ___SYM_read_2d_datum_2d_or_2d_eof ___SYM(106,___S_read_2d_datum_2d_or_2d_eof)
#define ___SYM_read_2d_sources ___SYM(107,___S_read_2d_sources)
#define ___SYM_readenv ___SYM(108,___S_readenv)
#define ___SYM_readtable ___SYM(109,___S_readtable)
#define ___SYM_rerooted_2d_filename ___SYM(110,___S_rerooted_2d_filename)
#define ___SYM_rest ___SYM(111,___S_rest)
#define ___SYM_scheme_2d_file_2d_extensions ___SYM(112,___S_scheme_2d_file_2d_extensions)
#define ___SYM_source ___SYM(113,___S_source)
#define ___SYM_source_2d__3e_expression ___SYM(114,___S_source_2d__3e_expression)
#define ___SYM_source_2d_code ___SYM(115,___S_source_2d_code)
#define ___SYM_source_2d_locat ___SYM(116,___S_source_2d_locat)
#define ___SYM_sources ___SYM(117,___S_sources)
#define ___SYM_str ___SYM(118,___S_str)
#define ___SYM_string_2d__3e_canonical_2d_symbol ___SYM(119,___S_string_2d__3e_canonical_2d_symbol)
#define ___SYM_string_2d_append ___SYM(120,___S_string_2d_append)
#define ___SYM_string_3f_ ___SYM(121,___S_string_3f_)
#define ___SYM_super ___SYM(122,___S_super)
#define ___SYM_type ___SYM(123,___S_type)
#define ___SYM_u16vector ___SYM(124,___S_u16vector)
#define ___SYM_u32vector ___SYM(125,___S_u32vector)
#define ___SYM_u64vector ___SYM(126,___S_u64vector)
#define ___SYM_u8vector ___SYM(127,___S_u8vector)
#define ___SYM_unbox_2d_object ___SYM(128,___S_unbox_2d_object)
#define ___SYM_unquote ___SYM(129,___S_unquote)
#define ___SYM_unquote_2d_splicing ___SYM(130,___S_unquote_2d_splicing)
#define ___SYM_unquote_2d_splicing_2d_sym ___SYM(131,___S_unquote_2d_splicing_2d_sym)
#define ___SYM_unquote_2d_sym ___SYM(132,___S_unquote_2d_sym)
#define ___SYM_unwrapper ___SYM(133,___S_unwrapper)
#define ___SYM_upcase ___SYM(134,___S_upcase)
#define ___SYM_v ___SYM(135,___S_v)
#define ___SYM_vector ___SYM(136,___S_vector)
#define ___SYM_vector_2d__3e_expression ___SYM(137,___S_vector_2d__3e_expression)
#define ___SYM_vector_2d_convert ___SYM(138,___S_vector_2d_convert)
#define ___SYM_vector_2d_length ___SYM(139,___S_vector_2d_length)
#define ___SYM_vector_2d_object_3f_ ___SYM(140,___S_vector_2d_object_3f_)
#define ___SYM_vector_2d_ref ___SYM(141,___S_vector_2d_ref)
#define ___SYM_vector_2d_set_21_ ___SYM(142,___S_vector_2d_set_21_)
#define ___SYM_wrapper ___SYM(143,___S_wrapper)
#define ___SYM_write ___SYM(144,___S_write)
#define ___SYM_x ___SYM(145,___S_x)

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
 ___DEF_CNS(___REF_CNS(1),___REF_CNS(3))
,___DEF_CNS(___REF_SYM(63,___S_include),___REF_CNS(2))
,___DEF_CNS(___REF_SUB(19),___REF_NUL)
,___DEF_CNS(___REF_CNS(4),___REF_CNS(6))
,___DEF_CNS(___REF_SYM(64,___S_include_2d_adt),___REF_CNS(5))
,___DEF_CNS(___REF_SUB(20),___REF_NUL)
,___DEF_CNS(___REF_CNS(7),___REF_CNS(9))
,___DEF_CNS(___REF_SYM(64,___S_include_2d_adt),___REF_CNS(8))
,___DEF_CNS(___REF_SUB(21),___REF_NUL)
,___DEF_CNS(___REF_CNS(10),___REF_CNS(12))
,___DEF_CNS(___REF_SYM(64,___S_include_2d_adt),___REF_CNS(11))
,___DEF_CNS(___REF_SUB(22),___REF_NUL)
,___DEF_CNS(___REF_CNS(13),___REF_CNS(15))
,___DEF_CNS(___REF_SYM(63,___S_include),___REF_CNS(14))
,___DEF_CNS(___REF_SUB(23),___REF_NUL)
,___DEF_CNS(___REF_CNS(16),___REF_CNS(23))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(17))
,___DEF_CNS(___REF_CNS(18),___REF_CNS(20))
,___DEF_CNS(___REF_SYM(9,___S__2a__2a_filepos_2d_line),___REF_CNS(19))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_NUL)
,___DEF_CNS(___REF_CNS(21),___REF_NUL)
,___DEF_CNS(___REF_SYM(1,___S__23__23_filepos_2d_line),___REF_CNS(22))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_NUL)
,___DEF_CNS(___REF_CNS(24),___REF_CNS(43))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(25))
,___DEF_CNS(___REF_CNS(26),___REF_CNS(28))
,___DEF_CNS(___REF_SYM(119,___S_string_2d__3e_canonical_2d_symbol),___REF_CNS(27))
,___DEF_CNS(___REF_SYM(118,___S_str),___REF_NUL)
,___DEF_CNS(___REF_CNS(29),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(30))
,___DEF_CNS(___REF_CNS(31),___REF_CNS(37))
,___DEF_CNS(___REF_CNS(32),___REF_NUL)
,___DEF_CNS(___REF_SYM(86,___S_new_2d_str),___REF_CNS(33))
,___DEF_CNS(___REF_CNS(34),___REF_NUL)
,___DEF_CNS(___REF_SYM(120,___S_string_2d_append),___REF_CNS(35))
,___DEF_CNS(___REF_SYM(118,___S_str),___REF_CNS(36))
,___DEF_CNS(___REF_SUB(24),___REF_NUL)
,___DEF_CNS(___REF_CNS(38),___REF_CNS(42))
,___DEF_CNS(___REF_SYM(4,___S__23__23_readtable_2d_string_2d_convert_2d_case_21_),___REF_CNS(39))
,___DEF_CNS(___REF_CNS(40),___REF_CNS(41))
,___DEF_CNS(___REF_SYM(33,___S_current_2d_readtable),___REF_NUL)
,___DEF_CNS(___REF_SYM(86,___S_new_2d_str),___REF_NUL)
,___DEF_CNS(___REF_SYM(86,___S_new_2d_str),___REF_NUL)
,___DEF_CNS(___REF_CNS(44),___REF_CNS(53))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(45))
,___DEF_CNS(___REF_CNS(46),___REF_CNS(49))
,___DEF_CNS(___REF_SYM(42,___S_expr_2d__3e_locat),___REF_CNS(47))
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_CNS(48))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(50),___REF_NUL)
,___DEF_CNS(___REF_SYM(136,___S_vector),___REF_CNS(51))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(52))
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_NUL)
,___DEF_CNS(___REF_CNS(54),___REF_CNS(187))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(55))
,___DEF_CNS(___REF_CNS(56),___REF_CNS(59))
,___DEF_CNS(___REF_SYM(80,___S_locat_2d_show),___REF_CNS(57))
,___DEF_CNS(___REF_SYM(97,___S_prefix),___REF_CNS(58))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_NUL)
,___DEF_CNS(___REF_CNS(60),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(61))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(62))
,___DEF_CNS(___REF_CNS(63),___REF_CNS(184))
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(64))
,___DEF_CNS(___REF_CNS(65),___REF_CNS(70))
,___DEF_CNS(___REF_SYM(121,___S_string_3f_),___REF_CNS(66))
,___DEF_CNS(___REF_CNS(67),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(68))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(69))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(71),___REF_CNS(151))
,___DEF_CNS(___REF_SYM(72,___S_let_2a_),___REF_CNS(72))
,___DEF_CNS(___REF_CNS(73),___REF_CNS(92))
,___DEF_CNS(___REF_CNS(74),___REF_CNS(79))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_CNS(75))
,___DEF_CNS(___REF_CNS(76),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(77))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(78))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(80),___REF_CNS(85))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_CNS(81))
,___DEF_CNS(___REF_CNS(82),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(83))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(84))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(86),___REF_NUL)
,___DEF_CNS(___REF_SYM(118,___S_str),___REF_CNS(87))
,___DEF_CNS(___REF_CNS(88),___REF_NUL)
,___DEF_CNS(___REF_SYM(58,___S_format_2d_filepos),___REF_CNS(89))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_CNS(90))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_CNS(91))
,___DEF_CNS(___REF_TRU,___REF_NUL)
,___DEF_CNS(___REF_CNS(93),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(94))
,___DEF_CNS(___REF_SYM(118,___S_str),___REF_CNS(95))
,___DEF_CNS(___REF_CNS(96),___REF_CNS(103))
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(97))
,___DEF_CNS(___REF_CNS(98),___REF_CNS(100))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(99))
,___DEF_CNS(___REF_SYM(97,___S_prefix),___REF_NUL)
,___DEF_CNS(___REF_CNS(101),___REF_NUL)
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(102))
,___DEF_CNS(___REF_SYM(118,___S_str),___REF_NUL)
,___DEF_CNS(___REF_CNS(104),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(105))
,___DEF_CNS(___REF_CNS(106),___REF_CNS(133))
,___DEF_CNS(___REF_CNS(107),___REF_CNS(114))
,___DEF_CNS(___REF_SYM(73,___S_line),___REF_CNS(108))
,___DEF_CNS(___REF_CNS(109),___REF_NUL)
,___DEF_CNS(___REF_SYM(14,___S__2b_),___REF_CNS(110))
,___DEF_CNS(___REF_CNS(111),___REF_CNS(113))
,___DEF_CNS(___REF_SYM(9,___S__2a__2a_filepos_2d_line),___REF_CNS(112))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_NUL)
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(115),___REF_CNS(122))
,___DEF_CNS(___REF_SYM(29,___S_col),___REF_CNS(116))
,___DEF_CNS(___REF_CNS(117),___REF_NUL)
,___DEF_CNS(___REF_SYM(14,___S__2b_),___REF_CNS(118))
,___DEF_CNS(___REF_CNS(119),___REF_CNS(121))
,___DEF_CNS(___REF_SYM(8,___S__2a__2a_filepos_2d_col),___REF_CNS(120))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_NUL)
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(123),___REF_NUL)
,___DEF_CNS(___REF_SYM(51,___S_filename_2a_),___REF_CNS(124))
,___DEF_CNS(___REF_CNS(125),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(126))
,___DEF_CNS(___REF_CNS(127),___REF_CNS(129))
,___DEF_CNS(___REF_SYM(121,___S_string_3f_),___REF_CNS(128))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(130),___REF_CNS(132))
,___DEF_CNS(___REF_SYM(94,___S_path_2d_expand),___REF_CNS(131))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(134),___REF_CNS(136))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(135))
,___DEF_CNS(___REF_SYM(97,___S_prefix),___REF_NUL)
,___DEF_CNS(___REF_CNS(137),___REF_CNS(139))
,___DEF_CNS(___REF_SYM(144,___S_write),___REF_CNS(138))
,___DEF_CNS(___REF_SYM(51,___S_filename_2a_),___REF_NUL)
,___DEF_CNS(___REF_CNS(140),___REF_CNS(142))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(141))
,___DEF_CNS(___REF_SUB(25),___REF_NUL)
,___DEF_CNS(___REF_CNS(143),___REF_CNS(145))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(144))
,___DEF_CNS(___REF_SYM(73,___S_line),___REF_NUL)
,___DEF_CNS(___REF_CNS(146),___REF_CNS(148))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(147))
,___DEF_CNS(___REF_SUB(26),___REF_NUL)
,___DEF_CNS(___REF_CNS(149),___REF_NUL)
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(150))
,___DEF_CNS(___REF_SYM(29,___S_col),___REF_NUL)
,___DEF_CNS(___REF_CNS(152),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(153))
,___DEF_CNS(___REF_CNS(154),___REF_CNS(166))
,___DEF_CNS(___REF_CNS(155),___REF_CNS(160))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(156))
,___DEF_CNS(___REF_CNS(157),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(158))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(159))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(161),___REF_NUL)
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_CNS(162))
,___DEF_CNS(___REF_CNS(163),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(164))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(165))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(167),___REF_CNS(169))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(168))
,___DEF_CNS(___REF_SYM(97,___S_prefix),___REF_NUL)
,___DEF_CNS(___REF_CNS(170),___REF_CNS(172))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(171))
,___DEF_CNS(___REF_SUB(27),___REF_NUL)
,___DEF_CNS(___REF_CNS(173),___REF_CNS(175))
,___DEF_CNS(___REF_SYM(144,___S_write),___REF_CNS(174))
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_NUL)
,___DEF_CNS(___REF_CNS(176),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(177))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(178))
,___DEF_CNS(___REF_CNS(179),___REF_NUL)
,___DEF_CNS(___REF_SYM(80,___S_locat_2d_show),___REF_CNS(180))
,___DEF_CNS(___REF_SUB(28),___REF_CNS(181))
,___DEF_CNS(___REF_CNS(182),___REF_NUL)
,___DEF_CNS(___REF_SYM(116,___S_source_2d_locat),___REF_CNS(183))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(185),___REF_NUL)
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(186))
,___DEF_CNS(___REF_SUB(29),___REF_NUL)
,___DEF_CNS(___REF_CNS(188),___REF_CNS(261))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(189))
,___DEF_CNS(___REF_CNS(190),___REF_CNS(192))
,___DEF_CNS(___REF_SYM(79,___S_locat_2d_filename_2d_and_2d_line),___REF_CNS(191))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_NUL)
,___DEF_CNS(___REF_CNS(193),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(194))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(195))
,___DEF_CNS(___REF_CNS(196),___REF_CNS(257))
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(197))
,___DEF_CNS(___REF_CNS(198),___REF_CNS(203))
,___DEF_CNS(___REF_SYM(121,___S_string_3f_),___REF_CNS(199))
,___DEF_CNS(___REF_CNS(200),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(201))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(202))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(204),___REF_CNS(230))
,___DEF_CNS(___REF_SYM(72,___S_let_2a_),___REF_CNS(205))
,___DEF_CNS(___REF_CNS(206),___REF_CNS(226))
,___DEF_CNS(___REF_CNS(207),___REF_CNS(212))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_CNS(208))
,___DEF_CNS(___REF_CNS(209),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(210))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(211))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(213),___REF_CNS(218))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_CNS(214))
,___DEF_CNS(___REF_CNS(215),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(216))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(217))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(219),___REF_NUL)
,___DEF_CNS(___REF_SYM(73,___S_line),___REF_CNS(220))
,___DEF_CNS(___REF_CNS(221),___REF_NUL)
,___DEF_CNS(___REF_SYM(14,___S__2b_),___REF_CNS(222))
,___DEF_CNS(___REF_CNS(223),___REF_CNS(225))
,___DEF_CNS(___REF_SYM(9,___S__2a__2a_filepos_2d_line),___REF_CNS(224))
,___DEF_CNS(___REF_SYM(53,___S_filepos),___REF_NUL)
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(227),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(228))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_CNS(229))
,___DEF_CNS(___REF_SYM(73,___S_line),___REF_NUL)
,___DEF_CNS(___REF_CNS(231),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(232))
,___DEF_CNS(___REF_CNS(233),___REF_CNS(245))
,___DEF_CNS(___REF_CNS(234),___REF_CNS(239))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(235))
,___DEF_CNS(___REF_CNS(236),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(237))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(238))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(240),___REF_NUL)
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_CNS(241))
,___DEF_CNS(___REF_CNS(242),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(243))
,___DEF_CNS(___REF_SYM(77,___S_loc),___REF_CNS(244))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(246),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(247))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(248))
,___DEF_CNS(___REF_CNS(249),___REF_CNS(253))
,___DEF_CNS(___REF_SYM(79,___S_locat_2d_filename_2d_and_2d_line),___REF_CNS(250))
,___DEF_CNS(___REF_CNS(251),___REF_NUL)
,___DEF_CNS(___REF_SYM(116,___S_source_2d_locat),___REF_CNS(252))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(254),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(255))
,___DEF_CNS(___REF_SUB(30),___REF_CNS(256))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(258),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(259))
,___DEF_CNS(___REF_SUB(31),___REF_CNS(260))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(262),___REF_CNS(470))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(263))
,___DEF_CNS(___REF_CNS(264),___REF_CNS(267))
,___DEF_CNS(___REF_SYM(44,___S_expression_2d__3e_source),___REF_CNS(265))
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_CNS(266))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(268),___REF_CNS(308))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(269))
,___DEF_CNS(___REF_CNS(270),___REF_CNS(272))
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(271))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(273),___REF_NUL)
,___DEF_CNS(___REF_SYM(82,___S_make_2d_source),___REF_CNS(274))
,___DEF_CNS(___REF_CNS(275),___REF_CNS(304))
,___DEF_CNS(___REF_SYM(30,___S_cond),___REF_CNS(276))
,___DEF_CNS(___REF_CNS(277),___REF_CNS(283))
,___DEF_CNS(___REF_CNS(278),___REF_CNS(280))
,___DEF_CNS(___REF_SYM(92,___S_pair_3f_),___REF_CNS(279))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(281),___REF_NUL)
,___DEF_CNS(___REF_SYM(75,___S_list_2d_convert),___REF_CNS(282))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(284),___REF_CNS(294))
,___DEF_CNS(___REF_CNS(285),___REF_CNS(287))
,___DEF_CNS(___REF_SYM(23,___S_box_2d_object_3f_),___REF_CNS(286))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(288),___REF_NUL)
,___DEF_CNS(___REF_SYM(22,___S_box_2d_object),___REF_CNS(289))
,___DEF_CNS(___REF_CNS(290),___REF_NUL)
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(291))
,___DEF_CNS(___REF_CNS(292),___REF_NUL)
,___DEF_CNS(___REF_SYM(128,___S_unbox_2d_object),___REF_CNS(293))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(295),___REF_CNS(301))
,___DEF_CNS(___REF_CNS(296),___REF_CNS(298))
,___DEF_CNS(___REF_SYM(140,___S_vector_2d_object_3f_),___REF_CNS(297))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(299),___REF_NUL)
,___DEF_CNS(___REF_SYM(138,___S_vector_2d_convert),___REF_CNS(300))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(302),___REF_NUL)
,___DEF_CNS(___REF_SYM(37,___S_else),___REF_CNS(303))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(305),___REF_NUL)
,___DEF_CNS(___REF_SYM(42,___S_expr_2d__3e_locat),___REF_CNS(306))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_CNS(307))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(309),___REF_CNS(325))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(310))
,___DEF_CNS(___REF_CNS(311),___REF_CNS(313))
,___DEF_CNS(___REF_SYM(75,___S_list_2d_convert),___REF_CNS(312))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(314),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(315))
,___DEF_CNS(___REF_CNS(316),___REF_CNS(320))
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(317))
,___DEF_CNS(___REF_CNS(318),___REF_NUL)
,___DEF_CNS(___REF_SYM(25,___S_car),___REF_CNS(319))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(321),___REF_NUL)
,___DEF_CNS(___REF_SYM(76,___S_list_2d_tail_2d_convert),___REF_CNS(322))
,___DEF_CNS(___REF_CNS(323),___REF_NUL)
,___DEF_CNS(___REF_SYM(26,___S_cdr),___REF_CNS(324))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(326),___REF_CNS(368))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(327))
,___DEF_CNS(___REF_CNS(328),___REF_CNS(330))
,___DEF_CNS(___REF_SYM(76,___S_list_2d_tail_2d_convert),___REF_CNS(329))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(331),___REF_NUL)
,___DEF_CNS(___REF_SYM(30,___S_cond),___REF_CNS(332))
,___DEF_CNS(___REF_CNS(333),___REF_CNS(356))
,___DEF_CNS(___REF_CNS(334),___REF_CNS(336))
,___DEF_CNS(___REF_SYM(92,___S_pair_3f_),___REF_CNS(335))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(337),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(338))
,___DEF_CNS(___REF_CNS(339),___REF_CNS(341))
,___DEF_CNS(___REF_SYM(103,___S_quoting_2d_form_3f_),___REF_CNS(340))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(342),___REF_CNS(344))
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(343))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(345),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(346))
,___DEF_CNS(___REF_CNS(347),___REF_CNS(351))
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(348))
,___DEF_CNS(___REF_CNS(349),___REF_NUL)
,___DEF_CNS(___REF_SYM(25,___S_car),___REF_CNS(350))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(352),___REF_NUL)
,___DEF_CNS(___REF_SYM(76,___S_list_2d_tail_2d_convert),___REF_CNS(353))
,___DEF_CNS(___REF_CNS(354),___REF_NUL)
,___DEF_CNS(___REF_SYM(26,___S_cdr),___REF_CNS(355))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(357),___REF_CNS(363))
,___DEF_CNS(___REF_CNS(358),___REF_CNS(360))
,___DEF_CNS(___REF_SYM(88,___S_null_3f_),___REF_CNS(359))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(361),___REF_NUL)
,___DEF_CNS(___REF_SYM(101,___S_quote),___REF_CNS(362))
,___DEF_CNS(___REF_NUL,___REF_NUL)
,___DEF_CNS(___REF_CNS(364),___REF_NUL)
,___DEF_CNS(___REF_SYM(37,___S_else),___REF_CNS(365))
,___DEF_CNS(___REF_CNS(366),___REF_NUL)
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(367))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(369),___REF_CNS(414))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(370))
,___DEF_CNS(___REF_CNS(371),___REF_CNS(373))
,___DEF_CNS(___REF_SYM(103,___S_quoting_2d_form_3f_),___REF_CNS(372))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(374),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(375))
,___DEF_CNS(___REF_CNS(376),___REF_CNS(386))
,___DEF_CNS(___REF_CNS(377),___REF_CNS(381))
,___DEF_CNS(___REF_SYM(56,___S_first),___REF_CNS(378))
,___DEF_CNS(___REF_CNS(379),___REF_NUL)
,___DEF_CNS(___REF_SYM(25,___S_car),___REF_CNS(380))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(382),___REF_NUL)
,___DEF_CNS(___REF_SYM(111,___S_rest),___REF_CNS(383))
,___DEF_CNS(___REF_CNS(384),___REF_NUL)
,___DEF_CNS(___REF_SYM(26,___S_cdr),___REF_CNS(385))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(387),___REF_NUL)
,___DEF_CNS(___REF_SYM(19,___S_and),___REF_CNS(388))
,___DEF_CNS(___REF_CNS(389),___REF_CNS(391))
,___DEF_CNS(___REF_SYM(92,___S_pair_3f_),___REF_CNS(390))
,___DEF_CNS(___REF_SYM(111,___S_rest),___REF_NUL)
,___DEF_CNS(___REF_CNS(392),___REF_CNS(396))
,___DEF_CNS(___REF_SYM(88,___S_null_3f_),___REF_CNS(393))
,___DEF_CNS(___REF_CNS(394),___REF_NUL)
,___DEF_CNS(___REF_SYM(26,___S_cdr),___REF_CNS(395))
,___DEF_CNS(___REF_SYM(111,___S_rest),___REF_NUL)
,___DEF_CNS(___REF_CNS(397),___REF_NUL)
,___DEF_CNS(___REF_SYM(91,___S_or),___REF_CNS(398))
,___DEF_CNS(___REF_CNS(399),___REF_CNS(402))
,___DEF_CNS(___REF_SYM(38,___S_eq_3f_),___REF_CNS(400))
,___DEF_CNS(___REF_SYM(56,___S_first),___REF_CNS(401))
,___DEF_CNS(___REF_SYM(102,___S_quote_2d_sym),___REF_NUL)
,___DEF_CNS(___REF_CNS(403),___REF_CNS(406))
,___DEF_CNS(___REF_SYM(38,___S_eq_3f_),___REF_CNS(404))
,___DEF_CNS(___REF_SYM(56,___S_first),___REF_CNS(405))
,___DEF_CNS(___REF_SYM(100,___S_quasiquote_2d_sym),___REF_NUL)
,___DEF_CNS(___REF_CNS(407),___REF_CNS(410))
,___DEF_CNS(___REF_SYM(38,___S_eq_3f_),___REF_CNS(408))
,___DEF_CNS(___REF_SYM(56,___S_first),___REF_CNS(409))
,___DEF_CNS(___REF_SYM(132,___S_unquote_2d_sym),___REF_NUL)
,___DEF_CNS(___REF_CNS(411),___REF_NUL)
,___DEF_CNS(___REF_SYM(38,___S_eq_3f_),___REF_CNS(412))
,___DEF_CNS(___REF_SYM(56,___S_first),___REF_CNS(413))
,___DEF_CNS(___REF_SYM(131,___S_unquote_2d_splicing_2d_sym),___REF_NUL)
,___DEF_CNS(___REF_CNS(415),___REF_CNS(467))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(416))
,___DEF_CNS(___REF_CNS(417),___REF_CNS(419))
,___DEF_CNS(___REF_SYM(138,___S_vector_2d_convert),___REF_CNS(418))
,___DEF_CNS(___REF_SYM(135,___S_v),___REF_NUL)
,___DEF_CNS(___REF_CNS(420),___REF_NUL)
,___DEF_CNS(___REF_SYM(72,___S_let_2a_),___REF_CNS(421))
,___DEF_CNS(___REF_CNS(422),___REF_CNS(432))
,___DEF_CNS(___REF_CNS(423),___REF_CNS(427))
,___DEF_CNS(___REF_SYM(70,___S_len),___REF_CNS(424))
,___DEF_CNS(___REF_CNS(425),___REF_NUL)
,___DEF_CNS(___REF_SYM(139,___S_vector_2d_length),___REF_CNS(426))
,___DEF_CNS(___REF_SYM(135,___S_v),___REF_NUL)
,___DEF_CNS(___REF_CNS(428),___REF_NUL)
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_CNS(429))
,___DEF_CNS(___REF_CNS(430),___REF_NUL)
,___DEF_CNS(___REF_SYM(83,___S_make_2d_vector),___REF_CNS(431))
,___DEF_CNS(___REF_SYM(70,___S_len),___REF_NUL)
,___DEF_CNS(___REF_CNS(433),___REF_CNS(466))
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(434))
,___DEF_CNS(___REF_SYM(81,___S_loop),___REF_CNS(435))
,___DEF_CNS(___REF_CNS(436),___REF_CNS(442))
,___DEF_CNS(___REF_CNS(437),___REF_NUL)
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(438))
,___DEF_CNS(___REF_CNS(439),___REF_NUL)
,___DEF_CNS(___REF_SYM(15,___S__2d_),___REF_CNS(440))
,___DEF_CNS(___REF_SYM(70,___S_len),___REF_CNS(441))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(443),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(444))
,___DEF_CNS(___REF_CNS(445),___REF_CNS(448))
,___DEF_CNS(___REF_SYM(16,___S__3e__3d_),___REF_CNS(446))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(447))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(449),___REF_NUL)
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(450))
,___DEF_CNS(___REF_CNS(451),___REF_CNS(460))
,___DEF_CNS(___REF_SYM(142,___S_vector_2d_set_21_),___REF_CNS(452))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_CNS(453))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(454))
,___DEF_CNS(___REF_CNS(455),___REF_NUL)
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(456))
,___DEF_CNS(___REF_CNS(457),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(458))
,___DEF_CNS(___REF_SYM(135,___S_v),___REF_CNS(459))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_NUL)
,___DEF_CNS(___REF_CNS(461),___REF_NUL)
,___DEF_CNS(___REF_SYM(81,___S_loop),___REF_CNS(462))
,___DEF_CNS(___REF_CNS(463),___REF_NUL)
,___DEF_CNS(___REF_SYM(15,___S__2d_),___REF_CNS(464))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(465))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(468),___REF_NUL)
,___DEF_CNS(___REF_SYM(43,___S_expr_2d__3e_source),___REF_CNS(469))
,___DEF_CNS(___REF_SYM(41,___S_expr),___REF_NUL)
,___DEF_CNS(___REF_CNS(471),___REF_CNS(601))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(472))
,___DEF_CNS(___REF_CNS(473),___REF_CNS(475))
,___DEF_CNS(___REF_SYM(114,___S_source_2d__3e_expression),___REF_CNS(474))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(476),___REF_CNS(510))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(477))
,___DEF_CNS(___REF_CNS(478),___REF_CNS(480))
,___DEF_CNS(___REF_SYM(74,___S_list_2d__3e_expression),___REF_CNS(479))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(481),___REF_NUL)
,___DEF_CNS(___REF_SYM(30,___S_cond),___REF_CNS(482))
,___DEF_CNS(___REF_CNS(483),___REF_CNS(498))
,___DEF_CNS(___REF_CNS(484),___REF_CNS(486))
,___DEF_CNS(___REF_SYM(92,___S_pair_3f_),___REF_CNS(485))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(487),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(488))
,___DEF_CNS(___REF_CNS(489),___REF_CNS(493))
,___DEF_CNS(___REF_SYM(114,___S_source_2d__3e_expression),___REF_CNS(490))
,___DEF_CNS(___REF_CNS(491),___REF_NUL)
,___DEF_CNS(___REF_SYM(25,___S_car),___REF_CNS(492))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(494),___REF_NUL)
,___DEF_CNS(___REF_SYM(74,___S_list_2d__3e_expression),___REF_CNS(495))
,___DEF_CNS(___REF_CNS(496),___REF_NUL)
,___DEF_CNS(___REF_SYM(26,___S_cdr),___REF_CNS(497))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(499),___REF_CNS(505))
,___DEF_CNS(___REF_CNS(500),___REF_CNS(502))
,___DEF_CNS(___REF_SYM(88,___S_null_3f_),___REF_CNS(501))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(503),___REF_NUL)
,___DEF_CNS(___REF_SYM(101,___S_quote),___REF_CNS(504))
,___DEF_CNS(___REF_NUL,___REF_NUL)
,___DEF_CNS(___REF_CNS(506),___REF_NUL)
,___DEF_CNS(___REF_SYM(37,___S_else),___REF_CNS(507))
,___DEF_CNS(___REF_CNS(508),___REF_NUL)
,___DEF_CNS(___REF_SYM(114,___S_source_2d__3e_expression),___REF_CNS(509))
,___DEF_CNS(___REF_SYM(67,___S_l),___REF_NUL)
,___DEF_CNS(___REF_CNS(511),___REF_CNS(563))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(512))
,___DEF_CNS(___REF_CNS(513),___REF_CNS(515))
,___DEF_CNS(___REF_SYM(137,___S_vector_2d__3e_expression),___REF_CNS(514))
,___DEF_CNS(___REF_SYM(135,___S_v),___REF_NUL)
,___DEF_CNS(___REF_CNS(516),___REF_NUL)
,___DEF_CNS(___REF_SYM(72,___S_let_2a_),___REF_CNS(517))
,___DEF_CNS(___REF_CNS(518),___REF_CNS(528))
,___DEF_CNS(___REF_CNS(519),___REF_CNS(523))
,___DEF_CNS(___REF_SYM(70,___S_len),___REF_CNS(520))
,___DEF_CNS(___REF_CNS(521),___REF_NUL)
,___DEF_CNS(___REF_SYM(139,___S_vector_2d_length),___REF_CNS(522))
,___DEF_CNS(___REF_SYM(135,___S_v),___REF_NUL)
,___DEF_CNS(___REF_CNS(524),___REF_NUL)
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_CNS(525))
,___DEF_CNS(___REF_CNS(526),___REF_NUL)
,___DEF_CNS(___REF_SYM(83,___S_make_2d_vector),___REF_CNS(527))
,___DEF_CNS(___REF_SYM(70,___S_len),___REF_NUL)
,___DEF_CNS(___REF_CNS(529),___REF_CNS(562))
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(530))
,___DEF_CNS(___REF_SYM(81,___S_loop),___REF_CNS(531))
,___DEF_CNS(___REF_CNS(532),___REF_CNS(538))
,___DEF_CNS(___REF_CNS(533),___REF_NUL)
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(534))
,___DEF_CNS(___REF_CNS(535),___REF_NUL)
,___DEF_CNS(___REF_SYM(15,___S__2d_),___REF_CNS(536))
,___DEF_CNS(___REF_SYM(70,___S_len),___REF_CNS(537))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(539),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(540))
,___DEF_CNS(___REF_CNS(541),___REF_CNS(544))
,___DEF_CNS(___REF_SYM(16,___S__3e__3d_),___REF_CNS(542))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(543))
,___DEF_CNS(___REF_FIX(0),___REF_NUL)
,___DEF_CNS(___REF_CNS(545),___REF_NUL)
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(546))
,___DEF_CNS(___REF_CNS(547),___REF_CNS(556))
,___DEF_CNS(___REF_SYM(142,___S_vector_2d_set_21_),___REF_CNS(548))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_CNS(549))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(550))
,___DEF_CNS(___REF_CNS(551),___REF_NUL)
,___DEF_CNS(___REF_SYM(114,___S_source_2d__3e_expression),___REF_CNS(552))
,___DEF_CNS(___REF_CNS(553),___REF_NUL)
,___DEF_CNS(___REF_SYM(141,___S_vector_2d_ref),___REF_CNS(554))
,___DEF_CNS(___REF_SYM(135,___S_v),___REF_CNS(555))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_NUL)
,___DEF_CNS(___REF_CNS(557),___REF_NUL)
,___DEF_CNS(___REF_SYM(81,___S_loop),___REF_CNS(558))
,___DEF_CNS(___REF_CNS(559),___REF_NUL)
,___DEF_CNS(___REF_SYM(15,___S__2d_),___REF_CNS(560))
,___DEF_CNS(___REF_SYM(60,___S_i),___REF_CNS(561))
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(564),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(565))
,___DEF_CNS(___REF_CNS(566),___REF_CNS(571))
,___DEF_CNS(___REF_CNS(567),___REF_NUL)
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_CNS(568))
,___DEF_CNS(___REF_CNS(569),___REF_NUL)
,___DEF_CNS(___REF_SYM(115,___S_source_2d_code),___REF_CNS(570))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(572),___REF_NUL)
,___DEF_CNS(___REF_SYM(30,___S_cond),___REF_CNS(573))
,___DEF_CNS(___REF_CNS(574),___REF_CNS(580))
,___DEF_CNS(___REF_CNS(575),___REF_CNS(577))
,___DEF_CNS(___REF_SYM(92,___S_pair_3f_),___REF_CNS(576))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(578),___REF_NUL)
,___DEF_CNS(___REF_SYM(74,___S_list_2d__3e_expression),___REF_CNS(579))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(581),___REF_CNS(591))
,___DEF_CNS(___REF_CNS(582),___REF_CNS(584))
,___DEF_CNS(___REF_SYM(23,___S_box_2d_object_3f_),___REF_CNS(583))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(585),___REF_NUL)
,___DEF_CNS(___REF_SYM(22,___S_box_2d_object),___REF_CNS(586))
,___DEF_CNS(___REF_CNS(587),___REF_NUL)
,___DEF_CNS(___REF_SYM(114,___S_source_2d__3e_expression),___REF_CNS(588))
,___DEF_CNS(___REF_CNS(589),___REF_NUL)
,___DEF_CNS(___REF_SYM(128,___S_unbox_2d_object),___REF_CNS(590))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(592),___REF_CNS(598))
,___DEF_CNS(___REF_CNS(593),___REF_CNS(595))
,___DEF_CNS(___REF_SYM(140,___S_vector_2d_object_3f_),___REF_CNS(594))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(596),___REF_NUL)
,___DEF_CNS(___REF_SYM(137,___S_vector_2d__3e_expression),___REF_CNS(597))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(599),___REF_NUL)
,___DEF_CNS(___REF_SYM(37,___S_else),___REF_CNS(600))
,___DEF_CNS(___REF_SYM(28,___S_code),___REF_NUL)
,___DEF_CNS(___REF_CNS(602),___REF_NUL)
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(603))
,___DEF_CNS(___REF_CNS(604),___REF_CNS(607))
,___DEF_CNS(___REF_SYM(65,___S_include_2d_expr_2d__3e_source),___REF_CNS(605))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(606))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_NUL)
,___DEF_CNS(___REF_CNS(608),___REF_CNS(726))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(609))
,___DEF_CNS(___REF_CNS(610),___REF_CNS(612))
,___DEF_CNS(___REF_SYM(55,___S_find_2d_source_2d_file),___REF_CNS(611))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(613),___REF_CNS(627))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(614))
,___DEF_CNS(___REF_CNS(615),___REF_CNS(617))
,___DEF_CNS(___REF_SYM(89,___S_open_2d_error),___REF_CNS(616))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(618),___REF_NUL)
,___DEF_CNS(___REF_SYM(98,___S_pt_2d_syntax_2d_error),___REF_CNS(619))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(620))
,___DEF_CNS(___REF_SUB(32),___REF_CNS(621))
,___DEF_CNS(___REF_CNS(622),___REF_NUL)
,___DEF_CNS(___REF_SYM(91,___S_or),___REF_CNS(623))
,___DEF_CNS(___REF_CNS(624),___REF_CNS(626))
,___DEF_CNS(___REF_SYM(94,___S_path_2d_expand),___REF_CNS(625))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(628),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(629))
,___DEF_CNS(___REF_CNS(630),___REF_CNS(635))
,___DEF_CNS(___REF_CNS(631),___REF_NUL)
,___DEF_CNS(___REF_SYM(40,___S_expanded_2d_filename),___REF_CNS(632))
,___DEF_CNS(___REF_CNS(633),___REF_NUL)
,___DEF_CNS(___REF_SYM(94,___S_path_2d_expand),___REF_CNS(634))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(636),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(637))
,___DEF_CNS(___REF_SYM(40,___S_expanded_2d_filename),___REF_CNS(638))
,___DEF_CNS(___REF_CNS(639),___REF_CNS(723))
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(640))
,___DEF_CNS(___REF_CNS(641),___REF_CNS(646))
,___DEF_CNS(___REF_SYM(39,___S_equal_3f_),___REF_CNS(642))
,___DEF_CNS(___REF_CNS(643),___REF_CNS(645))
,___DEF_CNS(___REF_SYM(95,___S_path_2d_extension),___REF_CNS(644))
,___DEF_CNS(___REF_SYM(40,___S_expanded_2d_filename),___REF_NUL)
,___DEF_CNS(___REF_SUB(33),___REF_NUL)
,___DEF_CNS(___REF_CNS(647),___REF_CNS(703))
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(648))
,___DEF_CNS(___REF_SYM(81,___S_loop),___REF_CNS(649))
,___DEF_CNS(___REF_CNS(650),___REF_CNS(662))
,___DEF_CNS(___REF_CNS(651),___REF_NUL)
,___DEF_CNS(___REF_SYM(46,___S_exts),___REF_CNS(652))
,___DEF_CNS(___REF_CNS(653),___REF_NUL)
,___DEF_CNS(___REF_SYM(20,___S_append),___REF_CNS(654))
,___DEF_CNS(___REF_CNS(655),___REF_CNS(658))
,___DEF_CNS(___REF_SYM(84,___S_map),___REF_CNS(656))
,___DEF_CNS(___REF_SYM(25,___S_car),___REF_CNS(657))
,___DEF_CNS(___REF_SYM(112,___S_scheme_2d_file_2d_extensions),___REF_NUL)
,___DEF_CNS(___REF_CNS(659),___REF_NUL)
,___DEF_CNS(___REF_SYM(101,___S_quote),___REF_CNS(660))
,___DEF_CNS(___REF_CNS(661),___REF_NUL)
,___DEF_CNS(___REF_SUB(34),___REF_NUL)
,___DEF_CNS(___REF_CNS(663),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(664))
,___DEF_CNS(___REF_CNS(665),___REF_CNS(667))
,___DEF_CNS(___REF_SYM(92,___S_pair_3f_),___REF_CNS(666))
,___DEF_CNS(___REF_SYM(46,___S_exts),___REF_NUL)
,___DEF_CNS(___REF_CNS(668),___REF_CNS(700))
,___DEF_CNS(___REF_SYM(72,___S_let_2a_),___REF_CNS(669))
,___DEF_CNS(___REF_CNS(670),___REF_CNS(686))
,___DEF_CNS(___REF_CNS(671),___REF_CNS(675))
,___DEF_CNS(___REF_SYM(45,___S_ext),___REF_CNS(672))
,___DEF_CNS(___REF_CNS(673),___REF_NUL)
,___DEF_CNS(___REF_SYM(25,___S_car),___REF_CNS(674))
,___DEF_CNS(___REF_SYM(46,___S_exts),___REF_NUL)
,___DEF_CNS(___REF_CNS(676),___REF_CNS(681))
,___DEF_CNS(___REF_SYM(59,___S_full_2d_name),___REF_CNS(677))
,___DEF_CNS(___REF_CNS(678),___REF_NUL)
,___DEF_CNS(___REF_SYM(120,___S_string_2d_append),___REF_CNS(679))
,___DEF_CNS(___REF_SYM(40,___S_expanded_2d_filename),___REF_CNS(680))
,___DEF_CNS(___REF_SYM(45,___S_ext),___REF_NUL)
,___DEF_CNS(___REF_CNS(682),___REF_NUL)
,___DEF_CNS(___REF_SYM(96,___S_port),___REF_CNS(683))
,___DEF_CNS(___REF_CNS(684),___REF_NUL)
,___DEF_CNS(___REF_SYM(90,___S_open_2d_input_2d_file_2a_),___REF_CNS(685))
,___DEF_CNS(___REF_SYM(59,___S_full_2d_name),___REF_NUL)
,___DEF_CNS(___REF_CNS(687),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(688))
,___DEF_CNS(___REF_SYM(96,___S_port),___REF_CNS(689))
,___DEF_CNS(___REF_CNS(690),___REF_CNS(695))
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(691))
,___DEF_CNS(___REF_CNS(692),___REF_CNS(694))
,___DEF_CNS(___REF_SYM(27,___S_close_2d_input_2d_port),___REF_CNS(693))
,___DEF_CNS(___REF_SYM(96,___S_port),___REF_NUL)
,___DEF_CNS(___REF_SYM(59,___S_full_2d_name),___REF_NUL)
,___DEF_CNS(___REF_CNS(696),___REF_NUL)
,___DEF_CNS(___REF_SYM(81,___S_loop),___REF_CNS(697))
,___DEF_CNS(___REF_CNS(698),___REF_NUL)
,___DEF_CNS(___REF_SYM(26,___S_cdr),___REF_CNS(699))
,___DEF_CNS(___REF_SYM(46,___S_exts),___REF_NUL)
,___DEF_CNS(___REF_CNS(701),___REF_NUL)
,___DEF_CNS(___REF_SYM(89,___S_open_2d_error),___REF_CNS(702))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(704),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(705))
,___DEF_CNS(___REF_CNS(706),___REF_CNS(711))
,___DEF_CNS(___REF_CNS(707),___REF_NUL)
,___DEF_CNS(___REF_SYM(96,___S_port),___REF_CNS(708))
,___DEF_CNS(___REF_CNS(709),___REF_NUL)
,___DEF_CNS(___REF_SYM(90,___S_open_2d_input_2d_file_2a_),___REF_CNS(710))
,___DEF_CNS(___REF_SYM(40,___S_expanded_2d_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(712),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(713))
,___DEF_CNS(___REF_SYM(96,___S_port),___REF_CNS(714))
,___DEF_CNS(___REF_CNS(715),___REF_CNS(720))
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(716))
,___DEF_CNS(___REF_CNS(717),___REF_CNS(719))
,___DEF_CNS(___REF_SYM(27,___S_close_2d_input_2d_port),___REF_CNS(718))
,___DEF_CNS(___REF_SYM(96,___S_port),___REF_NUL)
,___DEF_CNS(___REF_SYM(40,___S_expanded_2d_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(721),___REF_NUL)
,___DEF_CNS(___REF_SYM(89,___S_open_2d_error),___REF_CNS(722))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(724),___REF_NUL)
,___DEF_CNS(___REF_SYM(89,___S_open_2d_error),___REF_CNS(725))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(727),___REF_NUL)
,___DEF_CNS(___REF_SYM(72,___S_let_2a_),___REF_CNS(728))
,___DEF_CNS(___REF_CNS(729),___REF_CNS(765))
,___DEF_CNS(___REF_CNS(730),___REF_CNS(736))
,___DEF_CNS(___REF_SYM(52,___S_filename_2d_src),___REF_CNS(731))
,___DEF_CNS(___REF_CNS(732),___REF_NUL)
,___DEF_CNS(___REF_SYM(24,___S_cadr),___REF_CNS(733))
,___DEF_CNS(___REF_CNS(734),___REF_NUL)
,___DEF_CNS(___REF_SYM(115,___S_source_2d_code),___REF_CNS(735))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(737),___REF_CNS(741))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_CNS(738))
,___DEF_CNS(___REF_CNS(739),___REF_NUL)
,___DEF_CNS(___REF_SYM(115,___S_source_2d_code),___REF_CNS(740))
,___DEF_CNS(___REF_SYM(52,___S_filename_2d_src),___REF_NUL)
,___DEF_CNS(___REF_CNS(742),___REF_CNS(755))
,___DEF_CNS(___REF_SYM(110,___S_rerooted_2d_filename),___REF_CNS(743))
,___DEF_CNS(___REF_CNS(744),___REF_NUL)
,___DEF_CNS(___REF_SYM(94,___S_path_2d_expand),___REF_CNS(745))
,___DEF_CNS(___REF_SYM(50,___S_filename),___REF_CNS(746))
,___DEF_CNS(___REF_CNS(747),___REF_NUL)
,___DEF_CNS(___REF_SYM(93,___S_path_2d_directory),___REF_CNS(748))
,___DEF_CNS(___REF_CNS(749),___REF_NUL)
,___DEF_CNS(___REF_SYM(94,___S_path_2d_expand),___REF_CNS(750))
,___DEF_CNS(___REF_CNS(751),___REF_NUL)
,___DEF_CNS(___REF_SYM(78,___S_locat_2d_filename),___REF_CNS(752))
,___DEF_CNS(___REF_CNS(753),___REF_NUL)
,___DEF_CNS(___REF_SYM(116,___S_source_2d_locat),___REF_CNS(754))
,___DEF_CNS(___REF_SYM(52,___S_filename_2d_src),___REF_NUL)
,___DEF_CNS(___REF_CNS(756),___REF_CNS(760))
,___DEF_CNS(___REF_SYM(54,___S_final_2d_filename),___REF_CNS(757))
,___DEF_CNS(___REF_CNS(758),___REF_NUL)
,___DEF_CNS(___REF_SYM(55,___S_find_2d_source_2d_file),___REF_CNS(759))
,___DEF_CNS(___REF_SYM(110,___S_rerooted_2d_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(761),___REF_NUL)
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_CNS(762))
,___DEF_CNS(___REF_CNS(763),___REF_NUL)
,___DEF_CNS(___REF_SYM(12,___S__2a__2a_readenv_2d_open),___REF_CNS(764))
,___DEF_CNS(___REF_SYM(54,___S_final_2d_filename),___REF_NUL)
,___DEF_CNS(___REF_CNS(766),___REF_CNS(835))
,___DEF_CNS(___REF_SYM(34,___S_define),___REF_CNS(767))
,___DEF_CNS(___REF_CNS(768),___REF_CNS(769))
,___DEF_CNS(___REF_SYM(107,___S_read_2d_sources),___REF_NUL)
,___DEF_CNS(___REF_CNS(770),___REF_CNS(804))
,___DEF_CNS(___REF_SYM(101,___S_quote),___REF_CNS(771))
,___DEF_CNS(___REF_CNS(772),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(773))
,___DEF_CNS(___REF_CNS(774),___REF_CNS(782))
,___DEF_CNS(___REF_CNS(775),___REF_NUL)
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(776))
,___DEF_CNS(___REF_CNS(777),___REF_NUL)
,___DEF_CNS(___REF_CNS(778),___REF_CNS(781))
,___DEF_CNS(___REF_SYM(91,___S_or),___REF_CNS(779))
,___DEF_CNS(___REF_SYM(106,___S_read_2d_datum_2d_or_2d_eof),___REF_CNS(780))
,___DEF_CNS(___REF_SYM(10,___S__2a__2a_read_2d_datum_2d_or_2d_eof),___REF_NUL)
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_NUL)
,___DEF_CNS(___REF_CNS(783),___REF_NUL)
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(784))
,___DEF_CNS(___REF_CNS(785),___REF_CNS(787))
,___DEF_CNS(___REF_SYM(140,___S_vector_2d_object_3f_),___REF_CNS(786))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_NUL)
,___DEF_CNS(___REF_CNS(788),___REF_CNS(801))
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(789))
,___DEF_CNS(___REF_CNS(790),___REF_CNS(796))
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(791))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_CNS(792))
,___DEF_CNS(___REF_CNS(793),___REF_NUL)
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(794))
,___DEF_CNS(___REF_SUB(35),___REF_CNS(795))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_NUL)
,___DEF_CNS(___REF_CNS(797),___REF_NUL)
,___DEF_CNS(___REF_SYM(31,___S_cons),___REF_CNS(798))
,___DEF_CNS(___REF_SYM(113,___S_source),___REF_CNS(799))
,___DEF_CNS(___REF_CNS(800),___REF_NUL)
,___DEF_CNS(___REF_SYM(107,___S_read_2d_sources),___REF_NUL)
,___DEF_CNS(___REF_CNS(802),___REF_NUL)
,___DEF_CNS(___REF_SYM(101,___S_quote),___REF_CNS(803))
,___DEF_CNS(___REF_NUL,___REF_NUL)
,___DEF_CNS(___REF_CNS(805),___REF_NUL)
,___DEF_CNS(___REF_SYM(7,___S__23__23_vector_2d_ref),___REF_CNS(806))
,___DEF_CNS(___REF_CNS(807),___REF_CNS(834))
,___DEF_CNS(___REF_SYM(2,___S__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port),___REF_CNS(808))
,___DEF_CNS(___REF_CNS(809),___REF_CNS(811))
,___DEF_CNS(___REF_SYM(13,___S__2a__2a_readenv_2d_port),___REF_CNS(810))
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_NUL)
,___DEF_CNS(___REF_CNS(812),___REF_CNS(813))
,___DEF_CNS(___REF_SYM(0,___S__23__23_current_2d_readtable),___REF_NUL)
,___DEF_CNS(___REF_CNS(814),___REF_CNS(824))
,___DEF_CNS(___REF_SYM(69,___S_lambda),___REF_CNS(815))
,___DEF_CNS(___REF_CNS(816),___REF_CNS(818))
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_CNS(817))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(819),___REF_NUL)
,___DEF_CNS(___REF_SYM(82,___S_make_2d_source),___REF_CNS(820))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_CNS(821))
,___DEF_CNS(___REF_CNS(822),___REF_NUL)
,___DEF_CNS(___REF_SYM(3,___S__23__23_readenv_2d__3e_locat),___REF_CNS(823))
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_NUL)
,___DEF_CNS(___REF_CNS(825),___REF_CNS(832))
,___DEF_CNS(___REF_SYM(69,___S_lambda),___REF_CNS(826))
,___DEF_CNS(___REF_CNS(827),___REF_CNS(829))
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_CNS(828))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_CNS(830),___REF_NUL)
,___DEF_CNS(___REF_SYM(115,___S_source_2d_code),___REF_CNS(831))
,___DEF_CNS(___REF_SYM(145,___S_x),___REF_NUL)
,___DEF_CNS(___REF_FAL,___REF_CNS(833))
,___DEF_CNS(___REF_FAL,___REF_NUL)
,___DEF_CNS(___REF_FIX(1),___REF_NUL)
,___DEF_CNS(___REF_CNS(836),___REF_CNS(850))
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(837))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_CNS(838))
,___DEF_CNS(___REF_CNS(839),___REF_NUL)
,___DEF_CNS(___REF_SYM(21,___S_begin),___REF_CNS(840))
,___DEF_CNS(___REF_CNS(841),___REF_CNS(844))
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(842))
,___DEF_CNS(___REF_SUB(36),___REF_CNS(843))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_NUL)
,___DEF_CNS(___REF_CNS(845),___REF_NUL)
,___DEF_CNS(___REF_SYM(144,___S_write),___REF_CNS(846))
,___DEF_CNS(___REF_CNS(847),___REF_CNS(849))
,___DEF_CNS(___REF_SYM(94,___S_path_2d_expand),___REF_CNS(848))
,___DEF_CNS(___REF_SYM(54,___S_final_2d_filename),___REF_NUL)
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_NUL)
,___DEF_CNS(___REF_CNS(851),___REF_NUL)
,___DEF_CNS(___REF_SYM(71,___S_let),___REF_CNS(852))
,___DEF_CNS(___REF_CNS(853),___REF_CNS(857))
,___DEF_CNS(___REF_CNS(854),___REF_NUL)
,___DEF_CNS(___REF_SYM(117,___S_sources),___REF_CNS(855))
,___DEF_CNS(___REF_CNS(856),___REF_NUL)
,___DEF_CNS(___REF_SYM(107,___S_read_2d_sources),___REF_NUL)
,___DEF_CNS(___REF_CNS(858),___REF_CNS(864))
,___DEF_CNS(___REF_SYM(62,___S_if),___REF_CNS(859))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_CNS(860))
,___DEF_CNS(___REF_CNS(861),___REF_NUL)
,___DEF_CNS(___REF_SYM(35,___S_display),___REF_CNS(862))
,___DEF_CNS(___REF_SUB(37),___REF_CNS(863))
,___DEF_CNS(___REF_SYM(66,___S_info_2d_port),___REF_NUL)
,___DEF_CNS(___REF_CNS(865),___REF_CNS(867))
,___DEF_CNS(___REF_SYM(11,___S__2a__2a_readenv_2d_close),___REF_CNS(866))
,___DEF_CNS(___REF_SYM(104,___S_re),___REF_NUL)
,___DEF_CNS(___REF_SYM(117,___S_sources),___REF_NUL)
,___DEF_CNS(___REF_SUB(54),___REF_NUL)
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
               ___VEC1(___REF_SYM(109,___S_readtable))
               ___VEC1(___REF_FIX(0))
               ___VEC0
___DEF_SUB_STR(___X19,10)
               ___STR8(102,105,120,110,117,109,46,115)
               ___STR2(99,109)
___DEF_SUB_STR(___X20,11)
               ___STR8(95,101,110,118,97,100,116,46)
               ___STR3(115,99,109)
___DEF_SUB_STR(___X21,11)
               ___STR8(95,103,118,109,97,100,116,46)
               ___STR3(115,99,109)
___DEF_SUB_STR(___X22,13)
               ___STR8(95,112,116,114,101,101,97,100)
               ___STR5(116,46,115,99,109)
___DEF_SUB_STR(___X23,14)
               ___STR8(95,115,111,117,114,99,101,97)
               ___STR6(100,116,46,115,99,109)
___DEF_SUB_STR(___X24,0)
               ___STR0
___DEF_SUB_STR(___X25,1)
               ___STR1(64)
___DEF_SUB_STR(___X26,1)
               ___STR1(46)
___DEF_SUB_STR(___X27,11)
               ___STR8(69,88,80,82,69,83,83,73)
               ___STR3(79,78,32)
___DEF_SUB_STR(___X28,1)
               ___STR1(32)
___DEF_SUB_STR(___X29,16)
               ___STR8(85,78,75,78,79,87,78,32)
               ___STR8(76,79,67,65,84,73,79,78)
               ___STR0
___DEF_SUB_STR(___X30,0)
               ___STR0
___DEF_SUB_STR(___X31,0)
               ___STR0
___DEF_SUB_STR(___X32,15)
               ___STR8(67,97,110,39,116,32,102,105)
               ___STR7(110,100,32,102,105,108,101)
___DEF_SUB_STR(___X33,0)
               ___STR0
___DEF_SUB_STR(___X34,0)
               ___STR0
___DEF_SUB_STR(___X35,1)
               ___STR1(46)
___DEF_SUB_STR(___X36,9)
               ___STR8(40,114,101,97,100,105,110,103)
               ___STR1(32)
___DEF_SUB_STR(___X37,1)
               ___STR1(41)
___DEF_SUB_STR(___X38,0)
               ___STR0
___DEF_SUB_STR(___X39,1)
               ___STR1(32)
___DEF_SUB_STR(___X40,16)
               ___STR8(85,78,75,78,79,87,78,32)
               ___STR8(76,79,67,65,84,73,79,78)
               ___STR0
___DEF_SUB_STR(___X41,1)
               ___STR1(64)
___DEF_SUB_STR(___X42,1)
               ___STR1(46)
___DEF_SUB_STR(___X43,11)
               ___STR8(69,88,80,82,69,83,83,73)
               ___STR3(79,78,32)
___DEF_SUB_STR(___X44,0)
               ___STR0
___DEF_SUB_STR(___X45,0)
               ___STR0
___DEF_SUB_STR(___X46,15)
               ___STR8(67,97,110,39,116,32,102,105)
               ___STR7(110,100,32,102,105,108,101)
___DEF_SUB_STR(___X47,1)
               ___STR1(41)
___DEF_SUB_STRUCTURE(___X48,6)
               ___VEC1(___REF_SUB(49))
               ___VEC1(___REF_SYM(6,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55))
               ___VEC1(___REF_SYM(108,___S_readenv))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(51))
               ___VEC0
___DEF_SUB_STRUCTURE(___X49,6)
               ___VEC1(___REF_SUB(49))
               ___VEC1(___REF_SYM(5,___S__23__23_type_2d_5))
               ___VEC1(___REF_SYM(123,___S_type))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(50))
               ___VEC0
___DEF_SUB_VEC(___X50,15)
               ___VEC1(___REF_SYM(61,___S_id))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(85,___S_name))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(57,___S_flags))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(122,___S_super))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(49,___S_fields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X51,27)
               ___VEC1(___REF_SYM(96,___S_port))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(109,___S_readtable))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(143,___S_wrapper))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(133,___S_unwrapper))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(18,___S_allow_2d_script_3f_))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(68,___S_labels))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(32,___S_container))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(53,___S_filepos))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(105,___S_read_2d_cont))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STR(___X52,9)
               ___STR8(40,114,101,97,100,105,110,103)
               ___STR1(32)
___DEF_SUB_STR(___X53,0)
               ___STR0
___DEF_SUB_STR(___X54,0)
               ___STR0
___DEF_SUB_STR(___X55,15)
               ___STR8(67,97,110,39,116,32,102,105)
               ___STR7(110,100,32,102,105,108,101)
___DEF_SUB_STR(___X56,0)
               ___STR0
___DEF_SUB_STR(___X57,21)
               ___STR8(68,97,116,117,109,32,111,114)
               ___STR8(32,69,79,70,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X58,14)
               ___STR8(68,97,116,117,109,32,101,120)
               ___STR6(112,101,99,116,101,100)
___DEF_SUB_STR(___X59,21)
               ___STR8(73,109,112,114,111,112,101,114)
               ___STR8(108,121,32,112,108,97,99,101)
               ___STR5(100,32,100,111,116)
___DEF_SUB_STR(___X60,28)
               ___STR8(73,110,99,111,109,112,108,101)
               ___STR8(116,101,32,102,111,114,109,44)
               ___STR8(32,69,79,70,32,114,101,97)
               ___STR4(99,104,101,100)
___DEF_SUB_STR(___X61,15)
               ___STR8(73,110,99,111,109,112,108,101)
               ___STR7(116,101,32,102,111,114,109)
___DEF_SUB_STR(___X62,18)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(39,35,92,39,32,110,97,109)
               ___STR2(101,58)
___DEF_SUB_STR(___X63,18)
               ___STR8(73,108,108,101,103,97,108,32)
               ___STR8(99,104,97,114,97,99,116,101)
               ___STR2(114,58)
___DEF_SUB_STR(___X64,28)
               ___STR8(56,32,98,105,116,32,101,120)
               ___STR8(97,99,116,32,105,110,116,101)
               ___STR8(103,101,114,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X65,29)
               ___STR8(49,54,32,98,105,116,32,101)
               ___STR8(120,97,99,116,32,105,110,116)
               ___STR8(101,103,101,114,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X66,29)
               ___STR8(51,50,32,98,105,116,32,101)
               ___STR8(120,97,99,116,32,105,110,116)
               ___STR8(101,103,101,114,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X67,29)
               ___STR8(54,52,32,98,105,116,32,101)
               ___STR8(120,97,99,116,32,105,110,116)
               ___STR8(101,103,101,114,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X68,21)
               ___STR8(73,110,101,120,97,99,116,32)
               ___STR8(114,101,97,108,32,101,120,112)
               ___STR5(101,99,116,101,100)
___DEF_SUB_STR(___X69,26)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(104,101,120,97,100,101,99,105)
               ___STR8(109,97,108,32,101,115,99,97)
               ___STR2(112,101)
___DEF_SUB_STR(___X70,26)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(101,115,99,97,112,101,100,32)
               ___STR8(99,104,97,114,97,99,116,101)
               ___STR2(114,58)
___DEF_SUB_STR(___X71,12)
               ___STR8(39,40,39,32,101,120,112,101)
               ___STR4(99,116,101,100)
___DEF_SUB_STR(___X72,14)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR6(116,111,107,101,110,58)
___DEF_SUB_STR(___X73,18)
               ___STR8(73,110,118,97,108,105,100,32)
               ___STR8(39,35,33,39,32,110,97,109)
               ___STR2(101,58)
___DEF_SUB_STR(___X74,22)
               ___STR8(67,104,97,114,97,99,116,101)
               ___STR8(114,32,111,117,116,32,111,102)
               ___STR6(32,114,97,110,103,101)
___DEF_SUB_VEC(___X75,1)
               ___VEC1(___REF_SYM(87,___S_none))
               ___VEC0
___DEF_SUB_VEC(___X76,1)
               ___VEC1(___REF_SYM(36,___S_dot))
               ___VEC0
___DEF_SUB_BIG(___X77,3)
               ___BIG2(-0x1L,-0x1L)
               ___BIG1(0x0L)
___DEF_SUB_BIGFIX(___X78,2)
               ___BIGFIX2(-0x1L,0x0L)
               ___BIGFIX0
___DEF_SUB_STR(___X79,2)
               ___STR2(35,102)
___DEF_SUB_STR(___X80,2)
               ___STR2(35,116)
___DEF_SUB_STR(___X81,3)
               ___STR3(35,117,56)
___DEF_SUB_STR(___X82,4)
               ___STR4(35,117,49,54)
___DEF_SUB_STR(___X83,4)
               ___STR4(35,117,51,50)
___DEF_SUB_STR(___X84,4)
               ___STR4(35,117,54,52)
___DEF_SUB_STR(___X85,4)
               ___STR4(35,102,51,50)
___DEF_SUB_STR(___X86,4)
               ___STR4(35,102,54,52)
___DEF_SUB_VEC(___X87,5)
               ___VEC1(___REF_SYM(17,___S___source))
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
___DEF_M_HLBL(___L37_c_23_expression_2d__3e_source)
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
   ___GOTO(___L36__20___source)
   ___END_IF
   ___GOTO(___L35__20___source)
___DEF_SLBL(33,___L33__20___source)
   ___SET_GLO(13,___G_c_23__2a__2a_main_2d_readtable,___R1)
___DEF_GLBL(___L35__20___source)
   ___SET_R1(___CNS(0))
   ___POLL(34)
___DEF_SLBL(34,___L34__20___source)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L36__20___source)
   ___SET_R0(___LBL(33))
   ___JUMPINT(___SET_NARGS(0),___PRC(856),___L_c_23__2a__2a_make_2d_standard_2d_readtable)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_make_2d_source
#undef ___PH_LBL0
#define ___PH_LBL0 37
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
#define ___PH_LBL0 40
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
#define ___PH_LBL0 43
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
#define ___PH_LBL0 46
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
#define ___PH_LBL0 49
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
#define ___PH_LBL0 51
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
#define ___PH_LBL0 53
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
#define ___PH_LBL0 55
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
#define ___PH_LBL0 58
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
#define ___PH_LBL0 61
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
#define ___PH_LBL0 63
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
#define ___PH_LBL0 65
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
#define ___PH_LBL0 67
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
#define ___PH_LBL0 69
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
#define ___PH_LBL0 71
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
#define ___PH_LBL0 73
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
#define ___PH_LBL0 75
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
#define ___PH_LBL0 77
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
   ___SET_STK(1,___R1)
   ___SET_R2(___VECTORREF(___STK(1),___FIX(6L)))
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(7L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(8L)))
   ___SET_R1(___FIXSUB(___R3,___R1))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_readenv_2d_current_2d_filepos)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(3),___PRC(92),___L_c_23__2a__2a_make_2d_filepos)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_readenv_2d_previous_2d_filepos
#undef ___PH_LBL0
#define ___PH_LBL0 80
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
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(6L)))
   ___SET_STK(1,___R1)
   ___SET_R4(___VECTORREF(___STK(1),___FIX(7L)))
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
   ___JUMPINT(___SET_NARGS(3),___PRC(92),___L_c_23__2a__2a_make_2d_filepos)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof
#undef ___PH_LBL0
#define ___PH_LBL0 83
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
#define ___PH_LBL0 86
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
   ___SET_STK(-5,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(7L)))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-4,___R2)
   ___VECTORSET(___STK(-5),___FIX(7L),___STK(-4))
   ___IF(___NOT(___CHAREQP(___R1,___CHR(10))))
   ___GOTO(___L5_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
   ___END_IF
   ___SET_STK(-5,___STK(-6))
   ___VECTORSET(___STK(-5),___FIX(8L),___R2)
   ___SET_STK(-5,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-6),___FIX(6L)))
   ___SET_R2(___FIXADD(___R2,___FIX(1L)))
   ___VECTORSET(___STK(-5),___FIX(6L),___R2)
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
#define ___PH_LBL0 92
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
#define ___PH_LBL0 100
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
#define ___PH_LBL0 105
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
#define ___PH_LBL0 110
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
   ___JUMPINT(___SET_NARGS(5),___PRC(46),___L_c_23__2a__2a_make_2d_readenv)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(149),___L_c_23_re_2d__3e_locat)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(149),___L_c_23_re_2d__3e_locat)
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
#define ___PH_LBL0 127
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
#define ___PH_LBL0 130
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
#define ___PH_LBL0 132
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
#define ___PH_LBL0 143
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
   ___SET_R2(___SUB(38))
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
#define ___PH_LBL0 149
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
#define ___PH_LBL0 152
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
#define ___PH_LBL0 155
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
   ___SET_R1(___SUB(39))
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(2)
___DEF_SLBL(2,___L2_c_23_locat_2d_show)
   ___IF(___NOT(___FALSEP(___R2)))
   ___GOTO(___L23_c_23_locat_2d_show)
   ___END_IF
___DEF_GLBL(___L22_c_23_locat_2d_show)
   ___SET_R1(___SUB(40))
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
   ___JUMPINT(___SET_NARGS(1),___PRC(100),___L_c_23__2a__2a_filepos_2d_line)
___DEF_SLBL(9,___L9_c_23_locat_2d_show)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(1),___PRC(105),___L_c_23__2a__2a_filepos_2d_col)
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
   ___SET_R1(___SUB(41))
   ___SET_R0(___LBL(14))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(14,___L14_c_23_locat_2d_show)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(1),___PRM_display)
___DEF_SLBL(15,___L15_c_23_locat_2d_show)
   ___SET_R1(___SUB(42))
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
   ___SET_R1(___SUB(43))
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
#define ___PH_LBL0 178
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
   ___SET_R1(___CONS(___SUB(44),___FIX(1L)))
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
   ___JUMPINT(___SET_NARGS(1),___PRC(100),___L_c_23__2a__2a_filepos_2d_line)
___DEF_GLBL(___L14_c_23_locat_2d_filename_2d_and_2d_line)
   ___SET_R1(___CONS(___SUB(45),___FIX(1L)))
   ___CHECK_HEAP(11,4096)
___DEF_SLBL(11,___L11_c_23_locat_2d_filename_2d_and_2d_line)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23_locat_2d_filename
#undef ___PH_LBL0
#define ___PH_LBL0 191
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
   ___JUMPINT(___SET_NARGS(1),___PRC(178),___L_c_23_locat_2d_filename_2d_and_2d_line)
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
#define ___PH_LBL0 196
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
___DEF_P_HLBL(___L37_c_23_expression_2d__3e_source)
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
   ___GOTO(___L40_c_23_expression_2d__3e_source)
___DEF_SLBL(2,___L2_c_23_expression_2d__3e_source)
   ___SET_STK(-3,___R1)
   ___SET_R2(___CDR(___STK(-7)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(26))
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L42_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L38_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R2)
   ___SET_R3(___CDR(___STK(1)))
   ___SET_R4(___CAR(___STK(1)))
   ___ADJFP(1)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L56_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R3(___CDR(___R3))
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L56_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___EQP(___R4,___GLO_c_23_quote_2d_sym))
   ___GOTO(___L39_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___EQP(___R4,___GLO_c_23_quasiquote_2d_sym))
   ___GOTO(___L39_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___EQP(___R4,___GLO_c_23_unquote_2d_sym))
   ___GOTO(___L39_c_23_expression_2d__3e_source)
   ___END_IF
   ___IF(___NOT(___EQP(___R4,___GLO_c_23_unquote_2d_splicing_2d_sym)))
   ___GOTO(___L56_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L39_c_23_expression_2d__3e_source)
   ___ADJFP(-1)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23_expression_2d__3e_source)
___DEF_GLBL(___L40_c_23_expression_2d__3e_source)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L54_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L41_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R2)
   ___SET_R3(___CAR(___STK(1)))
   ___ADJFP(1)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L46_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_STK(1,___R3)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R2(___CAR(___STK(1)))
   ___SET_R0(___LBL(5))
   ___ADJFP(11)
   ___POLL(4)
___DEF_SLBL(4,___L4_c_23_expression_2d__3e_source)
   ___GOTO(___L40_c_23_expression_2d__3e_source)
___DEF_SLBL(5,___L5_c_23_expression_2d__3e_source)
   ___SET_STK(-5,___R1)
   ___SET_R2(___CDR(___STK(-10)))
   ___SET_R1(___STK(-8))
   ___SET_R0(___LBL(13))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L38_c_23_expression_2d__3e_source)
   ___END_IF
   ___GOTO(___L42_c_23_expression_2d__3e_source)
___DEF_SLBL(6,___L6_c_23_expression_2d__3e_source)
   ___SET_STK(-4,___R1)
   ___SET_R2(___CDR(___STK(-5)))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L38_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L42_c_23_expression_2d__3e_source)
   ___IF(___NULLP(___R2))
   ___GOTO(___L43_c_23_expression_2d__3e_source)
   ___END_IF
   ___POLL(7)
___DEF_SLBL(7,___L7_c_23_expression_2d__3e_source)
   ___GOTO(___L40_c_23_expression_2d__3e_source)
___DEF_GLBL(___L43_c_23_expression_2d__3e_source)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(8,___L8_c_23_expression_2d__3e_source)
   ___SET_R1(___CONS(___STK(-4),___R1))
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_c_23_expression_2d__3e_source)
   ___POLL(10)
___DEF_SLBL(10,___L10_c_23_expression_2d__3e_source)
   ___GOTO(___L44_c_23_expression_2d__3e_source)
___DEF_SLBL(11,___L11_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-3))
   ___POLL(12)
___DEF_SLBL(12,___L12_c_23_expression_2d__3e_source)
___DEF_GLBL(___L44_c_23_expression_2d__3e_source)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(13,___L13_c_23_expression_2d__3e_source)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___SET_STK(-10,___STK(-9))
   ___SET_STK(-9,___STK(-8))
   ___SET_STK(-8,___STK(-7))
   ___SET_STK(-7,___STK(-6))
   ___ADJFP(-4)
   ___CHECK_HEAP(14,4096)
___DEF_SLBL(14,___L14_c_23_expression_2d__3e_source)
   ___GOTO(___L45_c_23_expression_2d__3e_source)
___DEF_SLBL(15,___L15_c_23_expression_2d__3e_source)
___DEF_GLBL(___L45_c_23_expression_2d__3e_source)
   ___SET_STK(-2,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(16))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(2),___PRC(152),___L_c_23_expr_2d__3e_locat)
___DEF_SLBL(16,___L16_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(2))
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_GLBL(___L46_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(18))
   ___ADJFP(7)
   ___POLL(17)
___DEF_SLBL(17,___L17_c_23_expression_2d__3e_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),143,___G_c_23_box_2d_object_3f_)
___DEF_SLBL(18,___L18_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L53_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(19))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),179,___G_c_23_vector_2d_object_3f_)
___DEF_SLBL(19,___L19_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L47_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___STK(-3))
   ___GOTO(___L45_c_23_expression_2d__3e_source)
___DEF_GLBL(___L47_c_23_expression_2d__3e_source)
   ___SET_R2(___STK(-3))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(15))
   ___GOTO(___L48_c_23_expression_2d__3e_source)
___DEF_SLBL(20,___L20_c_23_expression_2d__3e_source)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L51_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(30))
___DEF_GLBL(___L48_c_23_expression_2d__3e_source)
   ___SET_R3(___VECTORLENGTH(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___R3)
   ___SET_R0(___LBL(22))
   ___ADJFP(8)
   ___POLL(21)
___DEF_SLBL(21,___L21_c_23_expression_2d__3e_source)
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_vector)
___DEF_SLBL(22,___L22_c_23_expression_2d__3e_source)
   ___SET_STK(-3,___R1)
   ___SET_STK(1,___STK(-6))
   ___SET_R3(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(11))
   ___ADJFP(1)
   ___IF(___FIXGE(___R3,___FIX(0L)))
   ___GOTO(___L49_c_23_expression_2d__3e_source)
   ___END_IF
   ___GOTO(___L50_c_23_expression_2d__3e_source)
___DEF_SLBL(23,___L23_c_23_expression_2d__3e_source)
   ___VECTORSET(___STK(-4),___STK(-3),___R1)
   ___SET_R3(___FIXSUB(___STK(-3),___FIX(1L)))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FIXGE(___R3,___FIX(0L))))
   ___GOTO(___L50_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L49_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___VECTORREF(___R1,___R3))
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(23))
   ___ADJFP(7)
   ___POLL(25)
___DEF_SLBL(25,___L25_c_23_expression_2d__3e_source)
   ___GOTO(___L40_c_23_expression_2d__3e_source)
___DEF_GLBL(___L50_c_23_expression_2d__3e_source)
   ___SET_R1(___VOID)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L51_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-5))
   ___GOTO(___L52_c_23_expression_2d__3e_source)
___DEF_SLBL(26,___L26_c_23_expression_2d__3e_source)
   ___SET_R1(___CONS(___STK(-3),___R1))
   ___SET_STK(-7,___STK(-6))
   ___SET_STK(-6,___STK(-5))
   ___SET_STK(-5,___STK(-4))
   ___CHECK_HEAP(27,4096)
___DEF_SLBL(27,___L27_c_23_expression_2d__3e_source)
___DEF_GLBL(___L52_c_23_expression_2d__3e_source)
   ___SET_STK(-4,___R1)
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(28))
   ___JUMPINT(___SET_NARGS(2),___PRC(152),___L_c_23_expr_2d__3e_locat)
___DEF_SLBL(28,___L28_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23_expression_2d__3e_source)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_SLBL(30,___L30_c_23_expression_2d__3e_source)
   ___GOTO(___L52_c_23_expression_2d__3e_source)
___DEF_GLBL(___L53_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),175,___G_c_23_unbox_2d_object)
___DEF_SLBL(31,___L31_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(36))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L41_c_23_expression_2d__3e_source)
   ___END_IF
   ___GOTO(___L54_c_23_expression_2d__3e_source)
___DEF_SLBL(32,___L32_c_23_expression_2d__3e_source)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(35))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L41_c_23_expression_2d__3e_source)
   ___END_IF
___DEF_GLBL(___L54_c_23_expression_2d__3e_source)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(34))
   ___ADJFP(8)
   ___POLL(33)
___DEF_SLBL(33,___L33_c_23_expression_2d__3e_source)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),143,___G_c_23_box_2d_object_3f_)
___DEF_SLBL(34,___L34_c_23_expression_2d__3e_source)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L55_c_23_expression_2d__3e_source)
   ___END_IF
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(20))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),179,___G_c_23_vector_2d_object_3f_)
___DEF_GLBL(___L55_c_23_expression_2d__3e_source)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),175,___G_c_23_unbox_2d_object)
___DEF_SLBL(35,___L35_c_23_expression_2d__3e_source)
   ___SET_R0(___LBL(30))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),142,___G_c_23_box_2d_object)
___DEF_SLBL(36,___L36_c_23_expression_2d__3e_source)
   ___SET_R0(___LBL(15))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),142,___G_c_23_box_2d_object)
___DEF_GLBL(___L56_c_23_expression_2d__3e_source)
   ___SET_STK(0,___R0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___CAR(___R2))
   ___SET_R0(___LBL(6))
   ___ADJFP(7)
   ___POLL(37)
___DEF_SLBL(37,___L37_c_23_expression_2d__3e_source)
   ___GOTO(___L40_c_23_expression_2d__3e_source)
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
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(2,___L2_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___CADR(___R1))
   ___SET_STK(-7,___R1)
   ___SET_STK(-3,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-7,___R1)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(43),___L_c_23_source_2d_locat)
___DEF_SLBL(4,___L4_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(178),___L_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_SLBL(5,___L5_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___CAR(___R1))
   ___SET_R0(___LBL(6))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(6,___L6_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(7))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),187,___G_path_2d_directory)
___DEF_SLBL(7,___L7_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(8))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),188,___G_path_2d_expand)
___DEF_SLBL(8,___L8_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(9,___L9_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L51_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L60_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(10,___L10_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L59_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L51_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-5))
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
   ___SET_R2(___SUB(46))
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
   ___SET_STK(-7,___R1)
   ___SET_R0(___LBL(16))
   ___JUMPINT(___SET_NARGS(1),___PRC(110),___L_c_23__2a__2a_readenv_2d_open)
___DEF_SLBL(16,___L16_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___FALSEP(___STK(-4)))
   ___GOTO(___L55_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L58_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(17,___L17_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-5))
___DEF_GLBL(___L55_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-7,___R1)
   ___SET_STK(1,___VECTORREF(___R1,___FIX(0L)))
   ___SET_R0(___LBL(18))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),122,___G__23__23_current_2d_readtable)
___DEF_SLBL(18,___L18_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___LBL(25))
   ___SET_R1(___LBL(23))
   ___SET_R3(___FAL)
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(19))
   ___ADJFP(-1)
   ___JUMPGLONOTSAFE(___SET_NARGS(6),134,___G__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port)
___DEF_SLBL(19,___L19_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___IF(___FALSEP(___STK(-4)))
   ___GOTO(___L56_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L57_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(20,___L20_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-5))
___DEF_GLBL(___L56_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(1),___PRC(127),___L_c_23__2a__2a_readenv_2d_close)
___DEF_SLBL(21,___L21_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-5))
   ___POLL(22)
___DEF_SLBL(22,___L22_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L57_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___SUB(47))
   ___SET_R0(___LBL(20))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(23,___L23_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(23,2,0,0)
   ___SET_R1(___R2)
   ___POLL(24)
___DEF_SLBL(24,___L24_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(25,___L25_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(25,2,0,0)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R1)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(48),___FAL))
   ___SET_R0(___LBL(27))
   ___ADJFP(8)
   ___POLL(26)
___DEF_SLBL(26,___L26_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),131,___G__23__23_port_2d_name)
___DEF_SLBL(27,___L27_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___STK(-5),___FIX(8L),___SUB(48),___FAL))
   ___SET_R0(___LBL(28))
   ___JUMPGLONOTSAFE(___SET_NARGS(2),127,___G__23__23_make_2d_locat)
___DEF_SLBL(28,___L28_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(29)
___DEF_SLBL(29,___L29_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),128,___G__23__23_make_2d_source)
___DEF_GLBL(___L58_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-5,___R1)
   ___SET_R2(___STK(-4))
   ___SET_R1(___SUB(52))
   ___SET_R0(___LBL(30))
   ___JUMPPRM(___SET_NARGS(2),___PRM_display)
___DEF_SLBL(30,___L30_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(31))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(31,___L31_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___STK(-4))
   ___SET_R0(___LBL(17))
   ___JUMPPRM(___SET_NARGS(2),___PRM_write)
___DEF_GLBL(___L59_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(32))
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___DEF_SLBL(32,___L32_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-3))
   ___GOTO(___L54_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_GLBL(___L60_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-3,___R1)
   ___SET_R0(___LBL(33))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),189,___G_path_2d_extension)
___DEF_SLBL(33,___L33_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___EQP(___R1,___SUB(53)))
   ___GOTO(___L61_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L70_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(34,___L34_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L71_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L61_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_STK(-2,___GLO_c_23_scheme_2d_file_2d_extensions)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(39))
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L63_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L62_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___CAR(___R1))
   ___SET_R2(___CAR(___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CDR(___R1))
   ___SET_R0(___LBL(36))
   ___ADJFP(8)
   ___POLL(35)
___DEF_SLBL(35,___L35_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___PAIRP(___R1))
   ___GOTO(___L62_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L63_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(36,___L36_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___CONS(___STK(-6),___R1))
   ___CHECK_HEAP(37,4096)
___DEF_SLBL(37,___L37_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___POLL(38)
___DEF_SLBL(38,___L38_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(39,___L39_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___CNS(868))
   ___SET_R0(___LBL(40))
   ___JUMPPRM(___SET_NARGS(2),___PRM_append)
___DEF_SLBL(40,___L40_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L68_c_23_include_2d_expr_2d__3e_sourcezzzzz)
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
   ___GOTO(___L67_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_STK(-3,___STK(-9))
   ___SET_R3(___CDR(___STK(-6)))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(14))
   ___ADJFP(-3)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L64_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___GOTO(___L66_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_SLBL(43,___L43_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L65_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R3(___CDR(___STK(-7)))
   ___SET_R2(___STK(-8))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-11)
   ___POLL(44)
___DEF_SLBL(44,___L44_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L66_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L64_c_23_include_2d_expr_2d__3e_sourcezzzzz)
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
___DEF_GLBL(___L65_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(47))
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___DEF_SLBL(47,___L47_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-6))
   ___POLL(48)
___DEF_SLBL(48,___L48_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(2))
___DEF_GLBL(___L66_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___R1)
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___POLL(49)
___DEF_SLBL(49,___L49_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___GOTO(___L52_c_23_include_2d_expr_2d__3e_sourcezzzzz)
___DEF_GLBL(___L67_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___DEF_GLBL(___L68_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-7))
   ___SET_R0(___LBL(50))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),188,___G_path_2d_expand)
___DEF_SLBL(50,___L50_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L69_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R1(___STK(-7))
___DEF_GLBL(___L69_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R2(___SUB(46))
   ___SET_R0(___LBL(14))
   ___JUMPGLONOTSAFE(___SET_NARGS(3),165,___G_c_23_pt_2d_syntax_2d_error)
___DEF_GLBL(___L70_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___IF(___NOT(___MEMALLOCATEDP(___R1)))
   ___GOTO(___L71_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
   ___SET_R2(___SUBTYPE(___R1))
   ___IF(___FIXEQ(___R2,___FIX(19L)))
   ___GOTO(___L72_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___END_IF
___DEF_GLBL(___L71_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R1(___STK(-3))
   ___SET_R0(___LBL(10))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),163,___G_c_23_open_2d_input_2d_file_2a_)
___DEF_GLBL(___L72_c_23_include_2d_expr_2d__3e_sourcezzzzz)
   ___SET_R2(___SUB(53))
   ___SET_R0(___LBL(34))
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
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(8L),___SUB(48),___FAL))
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
   ___SET_R1(___SUB(55))
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
   ___SET_R2(___SUB(56))
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
   ___SET_STK(-1,___R1)
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),137,___G__23__23_source_2d_code)
___DEF_SLBL(3,___L3_c_23_include_2d_expr_2d__3e_source)
   ___SET_STK(-6,___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(43),___L_c_23_source_2d_locat)
___DEF_SLBL(4,___L4_c_23_include_2d_expr_2d__3e_source)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(178),___L_c_23_locat_2d_filename_2d_and_2d_line)
___DEF_SLBL(5,___L5_c_23_include_2d_expr_2d__3e_source)
   ___SET_R2(___CAR(___R1))
   ___SET_R1(___STK(-6))
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
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(57))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected
#undef ___PH_LBL0
#define ___PH_LBL0 438
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(58))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_datum_2d_expected)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot
#undef ___PH_LBL0
#define ___PH_LBL0 441
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(59))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached
#undef ___PH_LBL0
#define ___PH_LBL0 444
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(60))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_incomplete
#undef ___PH_LBL0
#define ___PH_LBL0 447
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(61))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_incomplete)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
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
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___SUB(62))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_char_2d_name)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(1))
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
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___SUB(63))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_illegal_2d_char)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u8
#undef ___PH_LBL0
#define ___PH_LBL0 456
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(64))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u8)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u16
#undef ___PH_LBL0
#define ___PH_LBL0 459
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(65))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u16)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u32
#undef ___PH_LBL0
#define ___PH_LBL0 462
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(66))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u32)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_u64
#undef ___PH_LBL0
#define ___PH_LBL0 465
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(67))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_u64)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64
#undef ___PH_LBL0
#define ___PH_LBL0 468
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(68))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_f32_2f_f64)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_hex
#undef ___PH_LBL0
#define ___PH_LBL0 471
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(69))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_hex)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
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
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___SUB(70))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_escaped_2d_char)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 477
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(71))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_vector)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
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
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___SUB(72))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_token)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(1))
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
   ___SET_STK(1,___R1)
   ___SET_R3(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___SUB(73))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(3),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_error_2d_char_2d_range
#undef ___PH_LBL0
#define ___PH_LBL0 486
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
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
   ___SET_R2(___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___R2)
   ___SET_R2(___SUB(74))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_read_2d_error_2d_char_2d_range)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(1))
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
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___IF(___EQP(___R1,___SUB(75)))
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
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___IF(___NOT(___CHARP(___R1)))
   ___GOTO(___L12_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___END_IF
   ___SET_STK(-5,___STK(-6))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_datum_2d_or_2d_eof)
   ___VECTORSET(___STK(-5),___FIX(5L),___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___IF(___EQP(___R1,___SUB(75)))
   ___GOTO(___L7_c_23__2a__2a_read_2d_datum)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7_c_23__2a__2a_read_2d_datum)
   ___SET_STK(-5,___STK(-6))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum)
   ___VECTORSET(___STK(-5),___FIX(5L),___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___IF(___EQP(___R1,___SUB(76)))
   ___GOTO(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___END_IF
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___SET_STK(-5,___STK(-6))
   ___SET_R1(___STK(-6))
   ___SET_R2(___FIX(1L))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(80),___L_c_23__2a__2a_readenv_2d_previous_2d_filepos)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none)
   ___VECTORSET(___STK(-5),___FIX(5L),___R1)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___IF(___CHARP(___R1))
   ___GOTO(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___END_IF
   ___SET_R1(___SUB(75))
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L6_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___SET_STK(-5,___R1)
   ___SET_STK(-4,___STK(-6))
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(410),___L_c_23__2a__2a_readtable_2d_char_2d_handler)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___SET_R2(___STK(-5))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
   ___ADJFP(-8)
   ___JUMPGENNOTSAFE(___SET_NARGS(2),___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_none_2d_marker
#undef ___PH_LBL0
#define ___PH_LBL0 541
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
   ___SET_R1(___SUB(75))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_dot_2d_marker
#undef ___PH_LBL0
#define ___PH_LBL0 543
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
   ___SET_R1(___SUB(76))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 545
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
   ___IF(___EQP(___R1,___SUB(75)))
   ___GOTO(___L22_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-1,___STK(-4))
   ___VECTORSET(___STK(-2),___FIX(5L),___STK(-1))
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
   ___IF(___EQP(___R1,___SUB(75)))
   ___GOTO(___L19_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___IF(___EQP(___R1,___SUB(76)))
   ___GOTO(___L21_c_23__2a__2a_build_2d_list)
   ___END_IF
   ___SET_STK(-4,___STK(-11))
   ___SET_STK(-3,___STK(-9))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-3))
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
   ___IF(___NOT(___EQP(___R1,___SUB(75))))
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
   ___SET_STK(-10,___STK(-11))
   ___VECTORSET(___STK(-10),___FIX(5L),___STK(-9))
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
   ___SET_STK(-10,___STK(-11))
   ___SET_STK(-5,___STK(-9))
   ___VECTORSET(___STK(-10),___FIX(5L),___STK(-5))
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
#define ___PH_LBL0 563
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
   ___SET_STK(-5,___STK(-11))
   ___SET_R2(___VECTORREF(___STK(-5),___FIX(5L)))
   ___SET_STK(-5,___STK(-11))
   ___SET_STK(-4,___STK(-8))
   ___VECTORSET(___STK(-5),___FIX(5L),___STK(-4))
   ___IF(___EQP(___R1,___SUB(75)))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(58),___L_c_23__2a__2a_readenv_2d_unwrap)
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
   ___SET_R3(___SUB(77))
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
   ___SET_STK(-7,___STK(-11))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
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
   ___SET_R3(___BIGFIX(78,4294967295LL))
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
   ___SET_STK(-7,___STK(-11))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
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
   ___SET_STK(-7,___STK(-11))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
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
   ___SET_STK(-7,___STK(-11))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(58),___L_c_23__2a__2a_readenv_2d_unwrap)
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
   ___SET_STK(-7,___STK(-11))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(58),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_GLBL(___L86_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(17))
   ___JUMPINT(___SET_NARGS(2),___PRC(58),___L_c_23__2a__2a_readenv_2d_unwrap)
___DEF_GLBL(___L87_c_23__2a__2a_build_2d_vector)
   ___SET_STK(-10,___R1)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-11))
   ___SET_R0(___LBL(46))
   ___JUMPINT(___SET_NARGS(2),___PRC(58),___L_c_23__2a__2a_readenv_2d_unwrap)
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
   ___SET_STK(-7,___STK(-11))
   ___VECTORSET(___STK(-7),___FIX(5L),___STK(-4))
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
   ___JUMPINT(___SET_NARGS(2),___PRC(58),___L_c_23__2a__2a_readenv_2d_unwrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_delimited_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 613
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
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_c_23__2a__2a_build_2d_delimited_2d_string)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_c_23__2a__2a_build_2d_delimited_2d_string)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_build_2d_delimited_2d_string)
   ___GOTO(___L9_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R3(___FIXADD(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
___DEF_GLBL(___L9_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_c_23__2a__2a_build_2d_delimited_2d_string)
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(4,___L4_c_23__2a__2a_build_2d_delimited_2d_string)
   ___IF(___CHARP(___R1))
   ___GOTO(___L12_c_23__2a__2a_build_2d_delimited_2d_string)
   ___END_IF
   ___GOTO(___L10_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(5,___L5_c_23__2a__2a_build_2d_delimited_2d_string)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_c_23__2a__2a_build_2d_delimited_2d_string)
   ___END_IF
___DEF_GLBL(___L10_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-7))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_build_2d_delimited_2d_string)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_string)
___DEF_GLBL(___L11_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_GLBL(___L12_c_23__2a__2a_build_2d_delimited_2d_string)
   ___SET_STK(-3,___R1)
   ___SET_STK(-2,___STK(-6))
   ___SET_R1(___VECTORREF(___STK(-2),___FIX(1L)))
   ___SET_R2(___STK(-3))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(404),___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_delimited_2d_string)
   ___STRINGSET(___R1,___STK(-4),___STK(-3))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_build_2d_delimited_2d_string)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 623
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
   ___JUMPINT(___SET_NARGS(3),___PRC(613),___L_c_23__2a__2a_build_2d_delimited_2d_string)
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
   ___SET_STK(-4,___STK(-6))
   ___SET_R1(___VECTORREF(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(423),___L_c_23__2a__2a_readtable_2d_string_2d_convert_2d_case_21_)
___DEF_SLBL(7,___L7_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(429),___L_c_23__2a__2a_readtable_2d_parse_2d_keyword)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_build_2d_delimited_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 632
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
   ___JUMPINT(___SET_NARGS(3),___PRC(613),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(2,___L2_c_23__2a__2a_build_2d_delimited_2d_symbol)
   ___SET_STK(-5,___R1)
   ___SET_R1(___VECTORREF(___STK(-6),___FIX(1L)))
   ___SET_R2(___STK(-5))
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
#define ___PH_LBL0 638
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___SET_STK(-2,___STK(-6))
   ___SET_R1(___VECTORREF(___STK(-2),___FIX(1L)))
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
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(132),___L_c_23__2a__2a_append_2d_strings)
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
#define ___PH_LBL0 684
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
#define ___PH_LBL0 702
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
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_sharp
#undef ___PH_LBL0
#define ___PH_LBL0 710
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___STK(-6))
   ___VECTORSET(___STK(-5),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(2L))
   ___SET_R2(___CHR(35))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(3),___PRC(632),___L_c_23__2a__2a_build_2d_delimited_2d_symbol)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_GLBL(___L53_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-3,___STK(-6))
   ___SET_STK(-2,___STK(-4))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-2))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(1L))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(3),___PRC(613),___L_c_23__2a__2a_build_2d_delimited_2d_string)
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
   ___SET_R2(___SUB(79))
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
   ___SET_R2(___SUB(80))
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
   ___SET_R2(___SUB(81))
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
   ___JUMPINT(___SET_NARGS(4),___PRC(563),___L_c_23__2a__2a_build_2d_vector)
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
   ___SET_R2(___SUB(82))
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
   ___SET_R2(___SUB(83))
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
   ___SET_R2(___SUB(84))
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
   ___SET_R2(___SUB(85))
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
   ___SET_R2(___SUB(86))
   ___SET_R0(___LBL(15))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_ci_3d__3f_)
___DEF_GLBL(___L64_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(24))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(24,___L24_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___STK(-6))
   ___VECTORSET(___STK(-5),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R3(___FIX(0L))
   ___SET_R2(___CHR(32))
   ___SET_R0(___LBL(25))
   ___JUMPINT(___SET_NARGS(3),___PRC(613),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(25,___L25_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(26))
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(26,___L26_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___VECTORREF(___R1,___FIX(5L)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(27))
   ___JUMPINT(___SET_NARGS(2),___PRC(849),___L_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
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
   ___SET_STK(-5,___STK(-6))
   ___SET_R1(___VECTORREF(___STK(-5),___FIX(5L)))
   ___SET_STK(-5,___STK(-6))
   ___VECTORSET(___STK(-5),___FIX(5L),___STK(-4))
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(39))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(39,___L39_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(1,___STK(-6))
   ___SET_STK(2,___CHR(35))
   ___SET_R3(___CHR(35))
   ___SET_R2(___CHR(124))
   ___SET_R1(___CHR(124))
   ___SET_R0(___LBL(40))
   ___ADJFP(2)
   ___JUMPINT(___SET_NARGS(5),___PRC(684),___L_c_23__2a__2a_skip_2d_extended_2d_comment)
___DEF_SLBL(40,___L40_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-4,___STK(-6))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(41)
___DEF_SLBL(41,___L41_c_23__2a__2a_read_2d_sharp)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(534),___L_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot)
___DEF_GLBL(___L76_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(42))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(42,___L42_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___STK(-6))
   ___VECTORSET(___STK(-5),___FIX(5L),___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(43))
   ___JUMPINT(___SET_NARGS(1),___PRC(495),___L_c_23__2a__2a_read_2d_next_2d_char)
___DEF_SLBL(43,___L43_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(44))
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(44,___L44_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(45))
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
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
   ___JUMPINT(___SET_NARGS(3),___PRC(613),___L_c_23__2a__2a_build_2d_delimited_2d_string)
___DEF_SLBL(48,___L48_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(49))
   ___JUMPINT(___SET_NARGS(1),___PRC(51),___L_c_23__2a__2a_readenv_2d_readtable)
___DEF_SLBL(49,___L49_c_23__2a__2a_read_2d_sharp)
   ___SET_R2(___VECTORREF(___R1,___FIX(4L)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___LBL(29))
   ___JUMPINT(___SET_NARGS(2),___PRC(849),___L_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_)
___DEF_GLBL(___L78_c_23__2a__2a_read_2d_sharp)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(50))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(50,___L50_c_23__2a__2a_read_2d_sharp)
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-3,___STK(-4))
   ___VECTORSET(___STK(-5),___FIX(5L),___STK(-3))
   ___SET_STK(1,___STK(-6))
   ___SET_R2(___STK(-4))
   ___SET_R3(___CHR(41))
   ___SET_R1(___SYM_vector)
   ___SET_R0(___LBL(6))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(563),___L_c_23__2a__2a_build_2d_vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_whitespace
#undef ___PH_LBL0
#define ___PH_LBL0 762
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
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
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
#define ___PH_LBL0 767
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
   ___JUMPINT(___SET_NARGS(1),___PRC(702),___L_c_23__2a__2a_skip_2d_single_2d_line_2d_comment)
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
#define ___PH_LBL0 772
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_escaped_2d_string)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_escaped_2d_string)
   ___SET_STK(-3,___STK(-6))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(638),___L_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_escaped_2d_string)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_escaped_2d_string)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_escaped_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 779
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_escaped_2d_symbol)
   ___SET_STK(-3,___STK(-6))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(638),___L_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to)
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
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_quotation
#undef ___PH_LBL0
#define ___PH_LBL0 787
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_quotation)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_quotation)
   ___SET_STK(-4,___STK(-6))
   ___SET_STK(-3,___STK(-5))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-3))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_quotation)
   ___SET_STK(-4,___STK(-6))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_quote)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_quotation)
   ___BEGIN_ALLOC_LIST(2,___STK(-4))
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-5),___FIX(3L)))
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
#define ___PH_LBL0 796
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_quasiquotation)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_quasiquotation)
   ___SET_STK(-4,___STK(-6))
   ___SET_STK(-3,___STK(-5))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-3))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_quasiquotation)
   ___SET_STK(-4,___STK(-6))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_quasiquote)
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_quasiquotation)
   ___BEGIN_ALLOC_LIST(2,___STK(-4))
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-5),___FIX(3L)))
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
#define ___PH_LBL0 805
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_unquotation)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_unquotation)
   ___SET_STK(-4,___STK(-6))
   ___SET_STK(-3,___STK(-5))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-3))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(489),___L_c_23__2a__2a_peek_2d_next_2d_char)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_unquotation)
   ___IF(___NOT(___CHAREQP(___R1,___CHR(64))))
   ___GOTO(___L11_c_23__2a__2a_read_2d_unquotation)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_unquotation)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(519),___L_c_23__2a__2a_read_2d_datum)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_unquotation)
   ___SET_STK(-4,___STK(-6))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_unquote_2d_splicing)
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_unquotation)
   ___BEGIN_ALLOC_LIST(2,___STK(-4))
   ___ADD_LIST_ELEM(1,___R1)
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___SET_R3(___VECTORREF(___STK(-5),___FIX(3L)))
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
   ___SET_STK(-4,___STK(-6))
   ___VECTORSET(___STK(-4),___FIX(5L),___STK(-5))
   ___SET_STK(-5,___STK(-6))
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___SYM_unquote)
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_list
#undef ___PH_LBL0
#define ___PH_LBL0 817
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_list)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_list)
   ___SET_STK(-3,___STK(-6))
   ___SET_STK(-2,___STK(-4))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-2))
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
   ___JUMPINT(___SET_NARGS(4),___PRC(545),___L_c_23__2a__2a_build_2d_list)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_list)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_list)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_GLBL(___L8_c_23__2a__2a_read_2d_list)
   ___SET_R1(___CHR(125))
   ___GOTO(___L7_c_23__2a__2a_read_2d_list)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_none
#undef ___PH_LBL0
#define ___PH_LBL0 824
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
   ___SET_R1(___SUB(75))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_illegal
#undef ___PH_LBL0
#define ___PH_LBL0 826
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_illegal)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_illegal)
   ___SET_STK(-3,___STK(-6))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-4))
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
#define ___PH_LBL0 832
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_dot)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_dot)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_dot)
   ___IF(___CHARP(___R1))
   ___GOTO(___L11_c_23__2a__2a_read_2d_dot)
   ___END_IF
   ___GOTO(___L9_c_23__2a__2a_read_2d_dot)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_dot)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L10_c_23__2a__2a_read_2d_dot)
   ___END_IF
___DEF_GLBL(___L9_c_23__2a__2a_read_2d_dot)
   ___SET_R1(___SUB(76))
   ___POLL(6)
___DEF_SLBL(6,___L6_c_23__2a__2a_read_2d_dot)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L10_c_23__2a__2a_read_2d_dot)
   ___SET_STK(-3,___STK(-6))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(623),___L_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_SLBL(7,___L7_c_23__2a__2a_read_2d_dot)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_c_23__2a__2a_read_2d_dot)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___DEF_GLBL(___L11_c_23__2a__2a_read_2d_dot)
   ___SET_STK(-3,___STK(-6))
   ___SET_R2(___VECTORREF(___STK(-3),___FIX(1L)))
   ___SET_STK(-3,___R1)
   ___SET_R1(___R2)
   ___SET_R2(___STK(-3))
   ___SET_R0(___LBL(5))
   ___JUMPINT(___SET_NARGS(2),___PRC(404),___L_c_23__2a__2a_readtable_2d_char_2d_delimiter_3f_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 842
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
   ___JUMPINT(___SET_NARGS(1),___PRC(77),___L_c_23__2a__2a_readenv_2d_current_2d_filepos)
___DEF_SLBL(2,___L2_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(86),___L_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof)
___DEF_SLBL(3,___L3_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___SET_STK(-3,___STK(-6))
   ___VECTORSET(___STK(-3),___FIX(5L),___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(623),___L_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol)
___DEF_SLBL(4,___L4_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(5)
___DEF_SLBL(5,___L5_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(55),___L_c_23__2a__2a_readenv_2d_wrap)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_
#undef ___PH_LBL0
#define ___PH_LBL0 849
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
#define ___PH_LBL0 856
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
   ___SET_STK(1,___GLO_c_23__2a__2a_standard_2d_escaped_2d_char_2d_table)
   ___SET_STK(2,___GLO_c_23__2a__2a_standard_2d_named_2d_char_2d_table)
   ___SET_STK(3,___GLO_c_23__2a__2a_standard_2d_sharp_2d_bang_2d_table)
   ___SET_STK(4,___R0)
   ___SET_R1(___FAL)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___JUMPINT(___SET_NARGS(1),___PRC(348),___L_c_23__2a__2a_make_2d_chartable)
___DEF_SLBL(2,___L2_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(-3,___R1)
   ___SET_R1(___PRC(842))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(1),___PRC(348),___L_c_23__2a__2a_make_2d_chartable)
___DEF_SLBL(3,___L3_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___BEGIN_ALLOC_VECTOR(8)
   ___ADD_VECTOR_ELEM(0,___SUB(18))
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___TRU)
   ___ADD_VECTOR_ELEM(3,___STK(-7))
   ___ADD_VECTOR_ELEM(4,___STK(-6))
   ___ADD_VECTOR_ELEM(5,___STK(-5))
   ___ADD_VECTOR_ELEM(6,___STK(-3))
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
   ___SET_STK(-6,___STK(-7))
   ___VECTORSET(___STK(-6),___FIX(1L),___TRU)
   ___SET_STK(-6,___STK(-7))
   ___VECTORSET(___STK(-6),___FIX(2L),___FAL)
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
   ___SET_R3(___PRC(826))
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
   ___SET_R3(___PRC(762))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(32))
   ___SET_R0(___LBL(11))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(11,___L11_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(762))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(10))
   ___SET_R0(___LBL(12))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(12,___L12_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(762))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(13))
   ___SET_R0(___LBL(13))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(13,___L13_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(762))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(9))
   ___SET_R0(___LBL(14))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(14,___L14_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(762))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(12))
   ___SET_R0(___LBL(15))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(15,___L15_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(767))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(59))
   ___SET_R0(___LBL(16))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(16,___L16_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(772))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(34))
   ___SET_R0(___LBL(17))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(17,___L17_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(779))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(124))
   ___SET_R0(___LBL(18))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(18,___L18_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(787))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(39))
   ___SET_R0(___LBL(19))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(19,___L19_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(796))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(96))
   ___SET_R0(___LBL(20))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(20,___L20_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(805))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(44))
   ___SET_R0(___LBL(21))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(21,___L21_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(817))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(40))
   ___SET_R0(___LBL(22))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(22,___L22_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(824))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(41))
   ___SET_R0(___LBL(23))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(23,___L23_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(817))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(91))
   ___SET_R0(___LBL(24))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(24,___L24_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(824))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(93))
   ___SET_R0(___LBL(25))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(25,___L25_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(826))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(123))
   ___SET_R0(___LBL(26))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(26,___L26_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(826))
   ___SET_R2(___TRU)
   ___SET_R1(___CHR(125))
   ___SET_R0(___LBL(27))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(27,___L27_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(710))
   ___SET_R2(___FAL)
   ___SET_R1(___CHR(35))
   ___SET_R0(___LBL(28))
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(416),___L_c_23__2a__2a_readtable_2d_char_2d_class_2d_set_21_)
___DEF_SLBL(28,___L28_c_23__2a__2a_make_2d_standard_2d_readtable)
   ___SET_STK(1,___STK(-7))
   ___SET_R3(___PRC(832))
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
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20___source," _source",___REF_FAL,35,0)
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
,___DEF_LBL_INTRO(___H_c_23_expression_2d__3e_source,"c#expression->source",___REF_FAL,38,0)
,___DEF_LBL_PROC(___H_c_23_expression_2d__3e_source,2,-1)
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___OFD(___RETI,12,2,0x3f03fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x11L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,9,2,0x7dL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,1,0x3f3fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,9,1,0x2fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_expression_2d__3e_source,___IFD(___RETN,5,1,0x1fL))
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
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,1,0x3f0eL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xaL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x4aL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xbL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x10bL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xbL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x6L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_PROC(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,2,-1)
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,2,-1)
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1aL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x7fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x3fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,8,1,0x3f1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,9,1,0x22L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___OFD(___RETI,12,1,0x3f002L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_sourcezzzzz,___IFD(___RETN,5,1,0xfL))
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
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23_include_2d_expr_2d__3e_source,___IFD(___RETN,5,0,0x3L))
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
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_or_2d_eof_2d_expected,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,"c#**read-error-datum-expected",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_datum_2d_expected,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,"c#**read-error-improperly-placed-dot",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_improperly_2d_placed_2d_dot,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,"c#**read-error-incomplete-form-eof-reached",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_incomplete_2d_form_2d_eof_2d_reached,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_incomplete,"c#**read-error-incomplete",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_incomplete,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_incomplete,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_char_2d_name,"c#**read-error-char-name",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_char_2d_name,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_char_2d_name,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,"c#**read-error-illegal-char",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_illegal_2d_char,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u8,"c#**read-error-u8",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u8,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u8,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u16,"c#**read-error-u16",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u16,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u16,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u32,"c#**read-error-u32",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u32,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u32,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_u64,"c#**read-error-u64",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_u64,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_u64,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,"c#**read-error-f32/f64",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_f32_2f_f64,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_hex,"c#**read-error-hex",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_hex,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_hex,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,"c#**read-error-escaped-char",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_escaped_2d_char,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_vector,"c#**read-error-vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_vector,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_vector,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,"c#**read-error-sharp-token",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_token,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,"c#**read-error-sharp-bang-name",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_sharp_2d_bang_2d_name,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_error_2d_char_2d_range,"c#**read-error-char-range",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_error_2d_char_2d_range,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_error_2d_char_2d_range,___IFD(___RETI,1,4,0x3f1L))
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
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_eof,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum,"c#**read-datum",___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,"c#**read-datum-or-none",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,"c#**read-datum-or-none-or-dot",___REF_FAL,
6,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,1,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_datum_2d_or_2d_none_2d_or_2d_dot,___IFD(___RETI,8,0,0x3f01L))
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
,___DEF_LBL_INTRO(___H_c_23__2a__2a_build_2d_delimited_2d_string,"c#**build-delimited-string",___REF_FAL,9,
0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_build_2d_delimited_2d_string,3,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETN,5,0,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_build_2d_delimited_2d_string,___IFD(___RETI,8,8,0x3f00L))
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
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETN,5,0,0xdL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quotation,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_quasiquotation,"c#**read-quasiquotation",___REF_FAL,8,0)

,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_quasiquotation,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_quasiquotation,___IFD(___RETN,5,0,0xdL))
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
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_unquotation,___IFD(___RETN,5,0,0xdL))
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
,___DEF_LBL_INTRO(___H_c_23__2a__2a_read_2d_dot,"c#**read-dot",___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_c_23__2a__2a_read_2d_dot,2,-1)
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_c_23__2a__2a_read_2d_dot,___IFD(___RETI,8,8,0x3f00L))
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
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,8,3,0x3f0fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0xfL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x1fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,8,3,0x3f09L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___OFD(___RETI,12,0,0x3f107L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,9,0,0x107L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETN,5,3,0x9L))
,___DEF_LBL_RET(___H_c_23__2a__2a_make_2d_standard_2d_readtable,___IFD(___RETI,8,3,0x3f08L))
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
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f03fL)
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
___DEF_MOD_PRM(114,___G_c_23_make_2d_source,37)
___DEF_MOD_PRM(118,___G_c_23_source_2d_code,40)
___DEF_MOD_PRM(119,___G_c_23_source_2d_locat,43)
___DEF_MOD_PRM(16,___G_c_23__2a__2a_make_2d_readenv,46)
___DEF_MOD_PRM(73,___G_c_23__2a__2a_readenv_2d_port,49)
___DEF_MOD_PRM(75,___G_c_23__2a__2a_readenv_2d_readtable,51)
___DEF_MOD_PRM(65,___G_c_23__2a__2a_readenv_2d_error_2d_proc,53)
___DEF_MOD_PRM(77,___G_c_23__2a__2a_readenv_2d_wrap,55)
___DEF_MOD_PRM(76,___G_c_23__2a__2a_readenv_2d_unwrap,58)
___DEF_MOD_PRM(66,___G_c_23__2a__2a_readenv_2d_filepos,61)
___DEF_MOD_PRM(67,___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_,63)
___DEF_MOD_PRM(68,___G_c_23__2a__2a_readenv_2d_line_2d_count,65)
___DEF_MOD_PRM(69,___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_,67)
___DEF_MOD_PRM(61,___G_c_23__2a__2a_readenv_2d_char_2d_count,69)
___DEF_MOD_PRM(62,___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_,71)
___DEF_MOD_PRM(70,___G_c_23__2a__2a_readenv_2d_line_2d_start,73)
___DEF_MOD_PRM(71,___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_,75)
___DEF_MOD_PRM(64,___G_c_23__2a__2a_readenv_2d_current_2d_filepos,77)
___DEF_MOD_PRM(74,___G_c_23__2a__2a_readenv_2d_previous_2d_filepos,80)
___DEF_MOD_PRM(21,___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,83)
___DEF_MOD_PRM(52,___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,86)
___DEF_MOD_PRM(15,___G_c_23__2a__2a_make_2d_filepos,92)
___DEF_MOD_PRM(12,___G_c_23__2a__2a_filepos_2d_line,100)
___DEF_MOD_PRM(11,___G_c_23__2a__2a_filepos_2d_col,105)
___DEF_MOD_PRM(72,___G_c_23__2a__2a_readenv_2d_open,110)
___DEF_MOD_PRM(63,___G_c_23__2a__2a_readenv_2d_close,127)
___DEF_MOD_PRM(108,___G_c_23_false_2d_obj,130)
___DEF_MOD_PRM(1,___G_c_23__2a__2a_append_2d_strings,132)
___DEF_MOD_PRM(120,___G_c_23_string_2d__3e_canonical_2d_symbol,143)
___DEF_MOD_PRM(115,___G_c_23_re_2d__3e_locat,149)
___DEF_MOD_PRM(106,___G_c_23_expr_2d__3e_locat,152)
___DEF_MOD_PRM(113,___G_c_23_locat_2d_show,155)
___DEF_MOD_PRM(112,___G_c_23_locat_2d_filename_2d_and_2d_line,178)
___DEF_MOD_PRM(111,___G_c_23_locat_2d_filename,191)
___DEF_MOD_PRM(107,___G_c_23_expression_2d__3e_source,196)
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
___DEF_MOD_PRM(19,___G_c_23__2a__2a_none_2d_marker,541)
___DEF_MOD_PRM(10,___G_c_23__2a__2a_dot_2d_marker,543)
___DEF_MOD_PRM(6,___G_c_23__2a__2a_build_2d_list,545)
___DEF_MOD_PRM(7,___G_c_23__2a__2a_build_2d_vector,563)
___DEF_MOD_PRM(3,___G_c_23__2a__2a_build_2d_delimited_2d_string,613)
___DEF_MOD_PRM(2,___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,623)
___DEF_MOD_PRM(4,___G_c_23__2a__2a_build_2d_delimited_2d_symbol,632)
___DEF_MOD_PRM(5,___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,638)
___DEF_MOD_PRM(101,___G_c_23__2a__2a_skip_2d_extended_2d_comment,684)
___DEF_MOD_PRM(102,___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,702)
___DEF_MOD_PRM(57,___G_c_23__2a__2a_read_2d_sharp,710)
___DEF_MOD_PRM(60,___G_c_23__2a__2a_read_2d_whitespace,762)
___DEF_MOD_PRM(58,___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment,767)
___DEF_MOD_PRM(46,___G_c_23__2a__2a_read_2d_escaped_2d_string,772)
___DEF_MOD_PRM(47,___G_c_23__2a__2a_read_2d_escaped_2d_symbol,779)
___DEF_MOD_PRM(56,___G_c_23__2a__2a_read_2d_quotation,787)
___DEF_MOD_PRM(55,___G_c_23__2a__2a_read_2d_quasiquotation,796)
___DEF_MOD_PRM(59,___G_c_23__2a__2a_read_2d_unquotation,805)
___DEF_MOD_PRM(49,___G_c_23__2a__2a_read_2d_list,817)
___DEF_MOD_PRM(53,___G_c_23__2a__2a_read_2d_none,824)
___DEF_MOD_PRM(48,___G_c_23__2a__2a_read_2d_illegal,826)
___DEF_MOD_PRM(27,___G_c_23__2a__2a_read_2d_dot,832)
___DEF_MOD_PRM(54,___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,842)
___DEF_MOD_PRM(22,___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,849)
___DEF_MOD_PRM(18,___G_c_23__2a__2a_make_2d_standard_2d_readtable,856)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20___source,1)
___DEF_MOD_GLO(114,___G_c_23_make_2d_source,37)
___DEF_MOD_GLO(118,___G_c_23_source_2d_code,40)
___DEF_MOD_GLO(119,___G_c_23_source_2d_locat,43)
___DEF_MOD_GLO(16,___G_c_23__2a__2a_make_2d_readenv,46)
___DEF_MOD_GLO(73,___G_c_23__2a__2a_readenv_2d_port,49)
___DEF_MOD_GLO(75,___G_c_23__2a__2a_readenv_2d_readtable,51)
___DEF_MOD_GLO(65,___G_c_23__2a__2a_readenv_2d_error_2d_proc,53)
___DEF_MOD_GLO(77,___G_c_23__2a__2a_readenv_2d_wrap,55)
___DEF_MOD_GLO(76,___G_c_23__2a__2a_readenv_2d_unwrap,58)
___DEF_MOD_GLO(66,___G_c_23__2a__2a_readenv_2d_filepos,61)
___DEF_MOD_GLO(67,___G_c_23__2a__2a_readenv_2d_filepos_2d_set_21_,63)
___DEF_MOD_GLO(68,___G_c_23__2a__2a_readenv_2d_line_2d_count,65)
___DEF_MOD_GLO(69,___G_c_23__2a__2a_readenv_2d_line_2d_count_2d_set_21_,67)
___DEF_MOD_GLO(61,___G_c_23__2a__2a_readenv_2d_char_2d_count,69)
___DEF_MOD_GLO(62,___G_c_23__2a__2a_readenv_2d_char_2d_count_2d_set_21_,71)
___DEF_MOD_GLO(70,___G_c_23__2a__2a_readenv_2d_line_2d_start,73)
___DEF_MOD_GLO(71,___G_c_23__2a__2a_readenv_2d_line_2d_start_2d_set_21_,75)
___DEF_MOD_GLO(64,___G_c_23__2a__2a_readenv_2d_current_2d_filepos,77)
___DEF_MOD_GLO(74,___G_c_23__2a__2a_readenv_2d_previous_2d_filepos,80)
___DEF_MOD_GLO(21,___G_c_23__2a__2a_peek_2d_next_2d_char_2d_or_2d_eof,83)
___DEF_MOD_GLO(52,___G_c_23__2a__2a_read_2d_next_2d_char_2d_or_2d_eof,86)
___DEF_MOD_GLO(15,___G_c_23__2a__2a_make_2d_filepos,92)
___DEF_MOD_GLO(12,___G_c_23__2a__2a_filepos_2d_line,100)
___DEF_MOD_GLO(11,___G_c_23__2a__2a_filepos_2d_col,105)
___DEF_MOD_GLO(72,___G_c_23__2a__2a_readenv_2d_open,110)
___DEF_MOD_GLO(63,___G_c_23__2a__2a_readenv_2d_close,127)
___DEF_MOD_GLO(108,___G_c_23_false_2d_obj,130)
___DEF_MOD_GLO(1,___G_c_23__2a__2a_append_2d_strings,132)
___DEF_MOD_GLO(120,___G_c_23_string_2d__3e_canonical_2d_symbol,143)
___DEF_MOD_GLO(115,___G_c_23_re_2d__3e_locat,149)
___DEF_MOD_GLO(106,___G_c_23_expr_2d__3e_locat,152)
___DEF_MOD_GLO(113,___G_c_23_locat_2d_show,155)
___DEF_MOD_GLO(112,___G_c_23_locat_2d_filename_2d_and_2d_line,178)
___DEF_MOD_GLO(111,___G_c_23_locat_2d_filename,191)
___DEF_MOD_GLO(107,___G_c_23_expression_2d__3e_source,196)
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
___DEF_MOD_GLO(19,___G_c_23__2a__2a_none_2d_marker,541)
___DEF_MOD_GLO(10,___G_c_23__2a__2a_dot_2d_marker,543)
___DEF_MOD_GLO(6,___G_c_23__2a__2a_build_2d_list,545)
___DEF_MOD_GLO(7,___G_c_23__2a__2a_build_2d_vector,563)
___DEF_MOD_GLO(3,___G_c_23__2a__2a_build_2d_delimited_2d_string,613)
___DEF_MOD_GLO(2,___G_c_23__2a__2a_build_2d_delimited_2d_number_2f_keyword_2f_symbol,623)
___DEF_MOD_GLO(4,___G_c_23__2a__2a_build_2d_delimited_2d_symbol,632)
___DEF_MOD_GLO(5,___G_c_23__2a__2a_build_2d_escaped_2d_string_2d_up_2d_to,638)
___DEF_MOD_GLO(101,___G_c_23__2a__2a_skip_2d_extended_2d_comment,684)
___DEF_MOD_GLO(102,___G_c_23__2a__2a_skip_2d_single_2d_line_2d_comment,702)
___DEF_MOD_GLO(57,___G_c_23__2a__2a_read_2d_sharp,710)
___DEF_MOD_GLO(60,___G_c_23__2a__2a_read_2d_whitespace,762)
___DEF_MOD_GLO(58,___G_c_23__2a__2a_read_2d_single_2d_line_2d_comment,767)
___DEF_MOD_GLO(46,___G_c_23__2a__2a_read_2d_escaped_2d_string,772)
___DEF_MOD_GLO(47,___G_c_23__2a__2a_read_2d_escaped_2d_symbol,779)
___DEF_MOD_GLO(56,___G_c_23__2a__2a_read_2d_quotation,787)
___DEF_MOD_GLO(55,___G_c_23__2a__2a_read_2d_quasiquotation,796)
___DEF_MOD_GLO(59,___G_c_23__2a__2a_read_2d_unquotation,805)
___DEF_MOD_GLO(49,___G_c_23__2a__2a_read_2d_list,817)
___DEF_MOD_GLO(53,___G_c_23__2a__2a_read_2d_none,824)
___DEF_MOD_GLO(48,___G_c_23__2a__2a_read_2d_illegal,826)
___DEF_MOD_GLO(27,___G_c_23__2a__2a_read_2d_dot,832)
___DEF_MOD_GLO(54,___G_c_23__2a__2a_read_2d_number_2f_keyword_2f_symbol,842)
___DEF_MOD_GLO(22,___G_c_23__2a__2a_read_2d_assoc_2d_string_2d_ci_3d__3f_,849)
___DEF_MOD_GLO(18,___G_c_23__2a__2a_make_2d_standard_2d_readtable,856)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S__23__23_current_2d_readtable,"##current-readtable")
___DEF_MOD_SYM(1,___S__23__23_filepos_2d_line,"##filepos-line")
___DEF_MOD_SYM(2,___S__23__23_read_2d_all_2d_as_2d_a_2d_begin_2d_expr_2d_from_2d_port,"##read-all-as-a-begin-expr-from-port")

___DEF_MOD_SYM(3,___S__23__23_readenv_2d__3e_locat,"##readenv->locat")
___DEF_MOD_SYM(4,___S__23__23_readtable_2d_string_2d_convert_2d_case_21_,"##readtable-string-convert-case!")

___DEF_MOD_SYM(5,___S__23__23_type_2d_5,"##type-5")
___DEF_MOD_SYM(6,___S__23__23_type_2d_9_2d_edd21ef2_2d_ee48_2d_407f_2d_a9a9_2d_c1c361078e55,"##type-9-edd21ef2-ee48-407f-a9a9-c1c361078e55")

___DEF_MOD_SYM(7,___S__23__23_vector_2d_ref,"##vector-ref")
___DEF_MOD_SYM(8,___S__2a__2a_filepos_2d_col,"**filepos-col")
___DEF_MOD_SYM(9,___S__2a__2a_filepos_2d_line,"**filepos-line")
___DEF_MOD_SYM(10,___S__2a__2a_read_2d_datum_2d_or_2d_eof,"**read-datum-or-eof")
___DEF_MOD_SYM(11,___S__2a__2a_readenv_2d_close,"**readenv-close")
___DEF_MOD_SYM(12,___S__2a__2a_readenv_2d_open,"**readenv-open")
___DEF_MOD_SYM(13,___S__2a__2a_readenv_2d_port,"**readenv-port")
___DEF_MOD_SYM(14,___S__2b_,"+")
___DEF_MOD_SYM(15,___S__2d_,"-")
___DEF_MOD_SYM(16,___S__3e__3d_,">=")
___DEF_MOD_SYM(17,___S___source,"_source")
___DEF_MOD_SYM(18,___S_allow_2d_script_3f_,"allow-script?")
___DEF_MOD_SYM(19,___S_and,"and")
___DEF_MOD_SYM(20,___S_append,"append")
___DEF_MOD_SYM(21,___S_begin,"begin")
___DEF_MOD_SYM(22,___S_box_2d_object,"box-object")
___DEF_MOD_SYM(23,___S_box_2d_object_3f_,"box-object?")
___DEF_MOD_SYM(24,___S_cadr,"cadr")
___DEF_MOD_SYM(25,___S_car,"car")
___DEF_MOD_SYM(26,___S_cdr,"cdr")
___DEF_MOD_SYM(27,___S_close_2d_input_2d_port,"close-input-port")
___DEF_MOD_SYM(28,___S_code,"code")
___DEF_MOD_SYM(29,___S_col,"col")
___DEF_MOD_SYM(30,___S_cond,"cond")
___DEF_MOD_SYM(31,___S_cons,"cons")
___DEF_MOD_SYM(32,___S_container,"container")
___DEF_MOD_SYM(33,___S_current_2d_readtable,"current-readtable")
___DEF_MOD_SYM(34,___S_define,"define")
___DEF_MOD_SYM(35,___S_display,"display")
___DEF_MOD_SYM(36,___S_dot,"dot")
___DEF_MOD_SYM(37,___S_else,"else")
___DEF_MOD_SYM(38,___S_eq_3f_,"eq?")
___DEF_MOD_SYM(39,___S_equal_3f_,"equal?")
___DEF_MOD_SYM(40,___S_expanded_2d_filename,"expanded-filename")
___DEF_MOD_SYM(41,___S_expr,"expr")
___DEF_MOD_SYM(42,___S_expr_2d__3e_locat,"expr->locat")
___DEF_MOD_SYM(43,___S_expr_2d__3e_source,"expr->source")
___DEF_MOD_SYM(44,___S_expression_2d__3e_source,"expression->source")
___DEF_MOD_SYM(45,___S_ext,"ext")
___DEF_MOD_SYM(46,___S_exts,"exts")
___DEF_MOD_SYM(47,___S_f32vector,"f32vector")
___DEF_MOD_SYM(48,___S_f64vector,"f64vector")
___DEF_MOD_SYM(49,___S_fields,"fields")
___DEF_MOD_SYM(50,___S_filename,"filename")
___DEF_MOD_SYM(51,___S_filename_2a_,"filename*")
___DEF_MOD_SYM(52,___S_filename_2d_src,"filename-src")
___DEF_MOD_SYM(53,___S_filepos,"filepos")
___DEF_MOD_SYM(54,___S_final_2d_filename,"final-filename")
___DEF_MOD_SYM(55,___S_find_2d_source_2d_file,"find-source-file")
___DEF_MOD_SYM(56,___S_first,"first")
___DEF_MOD_SYM(57,___S_flags,"flags")
___DEF_MOD_SYM(58,___S_format_2d_filepos,"format-filepos")
___DEF_MOD_SYM(59,___S_full_2d_name,"full-name")
___DEF_MOD_SYM(60,___S_i,"i")
___DEF_MOD_SYM(61,___S_id,"id")
___DEF_MOD_SYM(62,___S_if,"if")
___DEF_MOD_SYM(63,___S_include,"include")
___DEF_MOD_SYM(64,___S_include_2d_adt,"include-adt")
___DEF_MOD_SYM(65,___S_include_2d_expr_2d__3e_source,"include-expr->source")
___DEF_MOD_SYM(66,___S_info_2d_port,"info-port")
___DEF_MOD_SYM(67,___S_l,"l")
___DEF_MOD_SYM(68,___S_labels,"labels")
___DEF_MOD_SYM(69,___S_lambda,"lambda")
___DEF_MOD_SYM(70,___S_len,"len")
___DEF_MOD_SYM(71,___S_let,"let")
___DEF_MOD_SYM(72,___S_let_2a_,"let*")
___DEF_MOD_SYM(73,___S_line,"line")
___DEF_MOD_SYM(74,___S_list_2d__3e_expression,"list->expression")
___DEF_MOD_SYM(75,___S_list_2d_convert,"list-convert")
___DEF_MOD_SYM(76,___S_list_2d_tail_2d_convert,"list-tail-convert")
___DEF_MOD_SYM(77,___S_loc,"loc")
___DEF_MOD_SYM(78,___S_locat_2d_filename,"locat-filename")
___DEF_MOD_SYM(79,___S_locat_2d_filename_2d_and_2d_line,"locat-filename-and-line")
___DEF_MOD_SYM(80,___S_locat_2d_show,"locat-show")
___DEF_MOD_SYM(81,___S_loop,"loop")
___DEF_MOD_SYM(82,___S_make_2d_source,"make-source")
___DEF_MOD_SYM(83,___S_make_2d_vector,"make-vector")
___DEF_MOD_SYM(84,___S_map,"map")
___DEF_MOD_SYM(85,___S_name,"name")
___DEF_MOD_SYM(86,___S_new_2d_str,"new-str")
___DEF_MOD_SYM(87,___S_none,"none")
___DEF_MOD_SYM(88,___S_null_3f_,"null?")
___DEF_MOD_SYM(89,___S_open_2d_error,"open-error")
___DEF_MOD_SYM(90,___S_open_2d_input_2d_file_2a_,"open-input-file*")
___DEF_MOD_SYM(91,___S_or,"or")
___DEF_MOD_SYM(92,___S_pair_3f_,"pair?")
___DEF_MOD_SYM(93,___S_path_2d_directory,"path-directory")
___DEF_MOD_SYM(94,___S_path_2d_expand,"path-expand")
___DEF_MOD_SYM(95,___S_path_2d_extension,"path-extension")
___DEF_MOD_SYM(96,___S_port,"port")
___DEF_MOD_SYM(97,___S_prefix,"prefix")
___DEF_MOD_SYM(98,___S_pt_2d_syntax_2d_error,"pt-syntax-error")
___DEF_MOD_SYM(99,___S_quasiquote,"quasiquote")
___DEF_MOD_SYM(100,___S_quasiquote_2d_sym,"quasiquote-sym")
___DEF_MOD_SYM(101,___S_quote,"quote")
___DEF_MOD_SYM(102,___S_quote_2d_sym,"quote-sym")
___DEF_MOD_SYM(103,___S_quoting_2d_form_3f_,"quoting-form?")
___DEF_MOD_SYM(104,___S_re,"re")
___DEF_MOD_SYM(105,___S_read_2d_cont,"read-cont")
___DEF_MOD_SYM(106,___S_read_2d_datum_2d_or_2d_eof,"read-datum-or-eof")
___DEF_MOD_SYM(107,___S_read_2d_sources,"read-sources")
___DEF_MOD_SYM(108,___S_readenv,"readenv")
___DEF_MOD_SYM(109,___S_readtable,"readtable")
___DEF_MOD_SYM(110,___S_rerooted_2d_filename,"rerooted-filename")
___DEF_MOD_SYM(111,___S_rest,"rest")
___DEF_MOD_SYM(112,___S_scheme_2d_file_2d_extensions,"scheme-file-extensions")
___DEF_MOD_SYM(113,___S_source,"source")
___DEF_MOD_SYM(114,___S_source_2d__3e_expression,"source->expression")
___DEF_MOD_SYM(115,___S_source_2d_code,"source-code")
___DEF_MOD_SYM(116,___S_source_2d_locat,"source-locat")
___DEF_MOD_SYM(117,___S_sources,"sources")
___DEF_MOD_SYM(118,___S_str,"str")
___DEF_MOD_SYM(119,___S_string_2d__3e_canonical_2d_symbol,"string->canonical-symbol")
___DEF_MOD_SYM(120,___S_string_2d_append,"string-append")
___DEF_MOD_SYM(121,___S_string_3f_,"string?")
___DEF_MOD_SYM(122,___S_super,"super")
___DEF_MOD_SYM(123,___S_type,"type")
___DEF_MOD_SYM(124,___S_u16vector,"u16vector")
___DEF_MOD_SYM(125,___S_u32vector,"u32vector")
___DEF_MOD_SYM(126,___S_u64vector,"u64vector")
___DEF_MOD_SYM(127,___S_u8vector,"u8vector")
___DEF_MOD_SYM(128,___S_unbox_2d_object,"unbox-object")
___DEF_MOD_SYM(129,___S_unquote,"unquote")
___DEF_MOD_SYM(130,___S_unquote_2d_splicing,"unquote-splicing")
___DEF_MOD_SYM(131,___S_unquote_2d_splicing_2d_sym,"unquote-splicing-sym")
___DEF_MOD_SYM(132,___S_unquote_2d_sym,"unquote-sym")
___DEF_MOD_SYM(133,___S_unwrapper,"unwrapper")
___DEF_MOD_SYM(134,___S_upcase,"upcase")
___DEF_MOD_SYM(135,___S_v,"v")
___DEF_MOD_SYM(136,___S_vector,"vector")
___DEF_MOD_SYM(137,___S_vector_2d__3e_expression,"vector->expression")
___DEF_MOD_SYM(138,___S_vector_2d_convert,"vector-convert")
___DEF_MOD_SYM(139,___S_vector_2d_length,"vector-length")
___DEF_MOD_SYM(140,___S_vector_2d_object_3f_,"vector-object?")
___DEF_MOD_SYM(141,___S_vector_2d_ref,"vector-ref")
___DEF_MOD_SYM(142,___S_vector_2d_set_21_,"vector-set!")
___DEF_MOD_SYM(143,___S_wrapper,"wrapper")
___DEF_MOD_SYM(144,___S_write,"write")
___DEF_MOD_SYM(145,___S_x,"x")
___END_MOD_SYM_KEY

#endif
