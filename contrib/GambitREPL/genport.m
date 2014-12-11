#ifdef ___LINKER_INFO
; File: "genport.m", produced by Gambit-C v4.7.3
(
407003
" genport"
((" genport"))
(
"##type-3-genport-94bfbdf4-4132-40e4-9d0a-35b34c28819a"
"##type-5"
"end"
"fields"
"flags"
"genport"
"id"
"name"
"read"
"super"
"type"
"write"
)
(
)
(
" genport"
"genport#genport-close-input-port"
"genport#genport-close-output-port"
"genport#genport-end"
"genport#genport-open-input-file"
"genport#genport-open-input-subu8vector"
"genport#genport-open-output-file"
"genport#genport-read"
"genport#genport-read-u8vector"
"genport#genport-write"
"genport#genport-write-u8vector"
)
(
"genport#genport-end-set!"
"genport#genport-get-output-u8vector"
"genport#genport-input-port?"
"genport#genport-native-input-port->genport"
"genport#genport-native-output-port->genport"
"genport#genport-open-input-u8vector"
"genport#genport-open-output-u8vector"
"genport#genport-output-port?"
"genport#genport-read-file"
"genport#genport-read-set!"
"genport#genport-read-subu8vector"
"genport#genport-write-file"
"genport#genport-write-set!"
"genport#genport-write-subu8vector"
"genport#genport?"
"genport#make-genport"
)
(
"##append-u8vectors"
"close-input-port"
"close-output-port"
"delete-file"
"file-exists?"
"make-u8vector"
"open-input-file"
"open-output-file"
"read-subu8vector"
"reverse"
"subu8vector"
"subu8vector-move!"
"write-subu8vector"
)
 ()
)
#else
#define ___VERSION 407003
#define ___MODULE_NAME " genport"
#define ___LINKER_ID ____20_genport
#define ___MH_PROC ___H__20_genport
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 12
#define ___GLOCOUNT 40
#define ___SUPCOUNT 27
#define ___SUBCOUNT 5
#define ___LBLCOUNT 144
#define ___OFDCOUNT 10
#define ___MODDESCR ___REF_SUB(4)
#include "gambit.h"

___NEED_SYM(___S__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a)
___NEED_SYM(___S__23__23_type_2d_5)
___NEED_SYM(___S_end)
___NEED_SYM(___S_fields)
___NEED_SYM(___S_flags)
___NEED_SYM(___S_genport)
___NEED_SYM(___S_id)
___NEED_SYM(___S_name)
___NEED_SYM(___S_read)
___NEED_SYM(___S_super)
___NEED_SYM(___S_type)
___NEED_SYM(___S_write)

___NEED_GLO(___G__20_genport)
___NEED_GLO(___G__23__23_append_2d_u8vectors)
___NEED_GLO(___G_close_2d_input_2d_port)
___NEED_GLO(___G_close_2d_output_2d_port)
___NEED_GLO(___G_delete_2d_file)
___NEED_GLO(___G_file_2d_exists_3f_)
___NEED_GLO(___G_genport_23_genport_2d_close_2d_input_2d_port)
___NEED_GLO(___G_genport_23_genport_2d_close_2d_output_2d_port)
___NEED_GLO(___G_genport_23_genport_2d_end)
___NEED_GLO(___G_genport_23_genport_2d_end_2d_set_21_)
___NEED_GLO(___G_genport_23_genport_2d_get_2d_output_2d_u8vector)
___NEED_GLO(___G_genport_23_genport_2d_input_2d_port_3f_)
___NEED_GLO(___G_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___NEED_GLO(___G_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___NEED_GLO(___G_genport_23_genport_2d_open_2d_input_2d_file)
___NEED_GLO(___G_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___NEED_GLO(___G_genport_23_genport_2d_open_2d_input_2d_u8vector)
___NEED_GLO(___G_genport_23_genport_2d_open_2d_output_2d_file)
___NEED_GLO(___G_genport_23_genport_2d_open_2d_output_2d_u8vector)
___NEED_GLO(___G_genport_23_genport_2d_output_2d_port_3f_)
___NEED_GLO(___G_genport_23_genport_2d_read)
___NEED_GLO(___G_genport_23_genport_2d_read_2d_file)
___NEED_GLO(___G_genport_23_genport_2d_read_2d_set_21_)
___NEED_GLO(___G_genport_23_genport_2d_read_2d_subu8vector)
___NEED_GLO(___G_genport_23_genport_2d_read_2d_u8vector)
___NEED_GLO(___G_genport_23_genport_2d_write)
___NEED_GLO(___G_genport_23_genport_2d_write_2d_file)
___NEED_GLO(___G_genport_23_genport_2d_write_2d_set_21_)
___NEED_GLO(___G_genport_23_genport_2d_write_2d_subu8vector)
___NEED_GLO(___G_genport_23_genport_2d_write_2d_u8vector)
___NEED_GLO(___G_genport_23_genport_3f_)
___NEED_GLO(___G_genport_23_make_2d_genport)
___NEED_GLO(___G_make_2d_u8vector)
___NEED_GLO(___G_open_2d_input_2d_file)
___NEED_GLO(___G_open_2d_output_2d_file)
___NEED_GLO(___G_read_2d_subu8vector)
___NEED_GLO(___G_reverse)
___NEED_GLO(___G_subu8vector)
___NEED_GLO(___G_subu8vector_2d_move_21_)
___NEED_GLO(___G_write_2d_subu8vector)

___BEGIN_SYM
___DEF_SYM(0,___S__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a,"##type-3-genport-94bfbdf4-4132-40e4-9d0a-35b34c28819a")

___DEF_SYM(1,___S__23__23_type_2d_5,"##type-5")
___DEF_SYM(2,___S_end,"end")
___DEF_SYM(3,___S_fields,"fields")
___DEF_SYM(4,___S_flags,"flags")
___DEF_SYM(5,___S_genport,"genport")
___DEF_SYM(6,___S_id,"id")
___DEF_SYM(7,___S_name,"name")
___DEF_SYM(8,___S_read,"read")
___DEF_SYM(9,___S_super,"super")
___DEF_SYM(10,___S_type,"type")
___DEF_SYM(11,___S_write,"write")
___END_SYM

#define ___SYM__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a ___SYM(0,___S__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a)
#define ___SYM__23__23_type_2d_5 ___SYM(1,___S__23__23_type_2d_5)
#define ___SYM_end ___SYM(2,___S_end)
#define ___SYM_fields ___SYM(3,___S_fields)
#define ___SYM_flags ___SYM(4,___S_flags)
#define ___SYM_genport ___SYM(5,___S_genport)
#define ___SYM_id ___SYM(6,___S_id)
#define ___SYM_name ___SYM(7,___S_name)
#define ___SYM_read ___SYM(8,___S_read)
#define ___SYM_super ___SYM(9,___S_super)
#define ___SYM_type ___SYM(10,___S_type)
#define ___SYM_write ___SYM(11,___S_write)

___BEGIN_GLO
___DEF_GLO(0," genport")
___DEF_GLO(1,"genport#genport-close-input-port")
___DEF_GLO(2,"genport#genport-close-output-port")

___DEF_GLO(3,"genport#genport-end")
___DEF_GLO(4,"genport#genport-end-set!")
___DEF_GLO(5,"genport#genport-get-output-u8vector")

___DEF_GLO(6,"genport#genport-input-port?")
___DEF_GLO(7,"genport#genport-native-input-port->genport")

___DEF_GLO(8,"genport#genport-native-output-port->genport")

___DEF_GLO(9,"genport#genport-open-input-file")
___DEF_GLO(10,"genport#genport-open-input-subu8vector")

___DEF_GLO(11,"genport#genport-open-input-u8vector")

___DEF_GLO(12,"genport#genport-open-output-file")
___DEF_GLO(13,"genport#genport-open-output-u8vector")

___DEF_GLO(14,"genport#genport-output-port?")
___DEF_GLO(15,"genport#genport-read")
___DEF_GLO(16,"genport#genport-read-file")
___DEF_GLO(17,"genport#genport-read-set!")
___DEF_GLO(18,"genport#genport-read-subu8vector")
___DEF_GLO(19,"genport#genport-read-u8vector")
___DEF_GLO(20,"genport#genport-write")
___DEF_GLO(21,"genport#genport-write-file")
___DEF_GLO(22,"genport#genport-write-set!")
___DEF_GLO(23,"genport#genport-write-subu8vector")

___DEF_GLO(24,"genport#genport-write-u8vector")
___DEF_GLO(25,"genport#genport?")
___DEF_GLO(26,"genport#make-genport")
___DEF_GLO(27,"##append-u8vectors")
___DEF_GLO(28,"close-input-port")
___DEF_GLO(29,"close-output-port")
___DEF_GLO(30,"delete-file")
___DEF_GLO(31,"file-exists?")
___DEF_GLO(32,"make-u8vector")
___DEF_GLO(33,"open-input-file")
___DEF_GLO(34,"open-output-file")
___DEF_GLO(35,"read-subu8vector")
___DEF_GLO(36,"reverse")
___DEF_GLO(37,"subu8vector")
___DEF_GLO(38,"subu8vector-move!")
___DEF_GLO(39,"write-subu8vector")
___END_GLO

#define ___GLO__20_genport ___GLO(0,___G__20_genport)
#define ___PRM__20_genport ___PRM(0,___G__20_genport)
#define ___GLO_genport_23_genport_2d_close_2d_input_2d_port ___GLO(1,___G_genport_23_genport_2d_close_2d_input_2d_port)
#define ___PRM_genport_23_genport_2d_close_2d_input_2d_port ___PRM(1,___G_genport_23_genport_2d_close_2d_input_2d_port)
#define ___GLO_genport_23_genport_2d_close_2d_output_2d_port ___GLO(2,___G_genport_23_genport_2d_close_2d_output_2d_port)
#define ___PRM_genport_23_genport_2d_close_2d_output_2d_port ___PRM(2,___G_genport_23_genport_2d_close_2d_output_2d_port)
#define ___GLO_genport_23_genport_2d_end ___GLO(3,___G_genport_23_genport_2d_end)
#define ___PRM_genport_23_genport_2d_end ___PRM(3,___G_genport_23_genport_2d_end)
#define ___GLO_genport_23_genport_2d_end_2d_set_21_ ___GLO(4,___G_genport_23_genport_2d_end_2d_set_21_)
#define ___PRM_genport_23_genport_2d_end_2d_set_21_ ___PRM(4,___G_genport_23_genport_2d_end_2d_set_21_)
#define ___GLO_genport_23_genport_2d_get_2d_output_2d_u8vector ___GLO(5,___G_genport_23_genport_2d_get_2d_output_2d_u8vector)
#define ___PRM_genport_23_genport_2d_get_2d_output_2d_u8vector ___PRM(5,___G_genport_23_genport_2d_get_2d_output_2d_u8vector)
#define ___GLO_genport_23_genport_2d_input_2d_port_3f_ ___GLO(6,___G_genport_23_genport_2d_input_2d_port_3f_)
#define ___PRM_genport_23_genport_2d_input_2d_port_3f_ ___PRM(6,___G_genport_23_genport_2d_input_2d_port_3f_)
#define ___GLO_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport ___GLO(7,___G_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
#define ___PRM_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport ___PRM(7,___G_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
#define ___GLO_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport ___GLO(8,___G_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
#define ___PRM_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport ___PRM(8,___G_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
#define ___GLO_genport_23_genport_2d_open_2d_input_2d_file ___GLO(9,___G_genport_23_genport_2d_open_2d_input_2d_file)
#define ___PRM_genport_23_genport_2d_open_2d_input_2d_file ___PRM(9,___G_genport_23_genport_2d_open_2d_input_2d_file)
#define ___GLO_genport_23_genport_2d_open_2d_input_2d_subu8vector ___GLO(10,___G_genport_23_genport_2d_open_2d_input_2d_subu8vector)
#define ___PRM_genport_23_genport_2d_open_2d_input_2d_subu8vector ___PRM(10,___G_genport_23_genport_2d_open_2d_input_2d_subu8vector)
#define ___GLO_genport_23_genport_2d_open_2d_input_2d_u8vector ___GLO(11,___G_genport_23_genport_2d_open_2d_input_2d_u8vector)
#define ___PRM_genport_23_genport_2d_open_2d_input_2d_u8vector ___PRM(11,___G_genport_23_genport_2d_open_2d_input_2d_u8vector)
#define ___GLO_genport_23_genport_2d_open_2d_output_2d_file ___GLO(12,___G_genport_23_genport_2d_open_2d_output_2d_file)
#define ___PRM_genport_23_genport_2d_open_2d_output_2d_file ___PRM(12,___G_genport_23_genport_2d_open_2d_output_2d_file)
#define ___GLO_genport_23_genport_2d_open_2d_output_2d_u8vector ___GLO(13,___G_genport_23_genport_2d_open_2d_output_2d_u8vector)
#define ___PRM_genport_23_genport_2d_open_2d_output_2d_u8vector ___PRM(13,___G_genport_23_genport_2d_open_2d_output_2d_u8vector)
#define ___GLO_genport_23_genport_2d_output_2d_port_3f_ ___GLO(14,___G_genport_23_genport_2d_output_2d_port_3f_)
#define ___PRM_genport_23_genport_2d_output_2d_port_3f_ ___PRM(14,___G_genport_23_genport_2d_output_2d_port_3f_)
#define ___GLO_genport_23_genport_2d_read ___GLO(15,___G_genport_23_genport_2d_read)
#define ___PRM_genport_23_genport_2d_read ___PRM(15,___G_genport_23_genport_2d_read)
#define ___GLO_genport_23_genport_2d_read_2d_file ___GLO(16,___G_genport_23_genport_2d_read_2d_file)
#define ___PRM_genport_23_genport_2d_read_2d_file ___PRM(16,___G_genport_23_genport_2d_read_2d_file)
#define ___GLO_genport_23_genport_2d_read_2d_set_21_ ___GLO(17,___G_genport_23_genport_2d_read_2d_set_21_)
#define ___PRM_genport_23_genport_2d_read_2d_set_21_ ___PRM(17,___G_genport_23_genport_2d_read_2d_set_21_)
#define ___GLO_genport_23_genport_2d_read_2d_subu8vector ___GLO(18,___G_genport_23_genport_2d_read_2d_subu8vector)
#define ___PRM_genport_23_genport_2d_read_2d_subu8vector ___PRM(18,___G_genport_23_genport_2d_read_2d_subu8vector)
#define ___GLO_genport_23_genport_2d_read_2d_u8vector ___GLO(19,___G_genport_23_genport_2d_read_2d_u8vector)
#define ___PRM_genport_23_genport_2d_read_2d_u8vector ___PRM(19,___G_genport_23_genport_2d_read_2d_u8vector)
#define ___GLO_genport_23_genport_2d_write ___GLO(20,___G_genport_23_genport_2d_write)
#define ___PRM_genport_23_genport_2d_write ___PRM(20,___G_genport_23_genport_2d_write)
#define ___GLO_genport_23_genport_2d_write_2d_file ___GLO(21,___G_genport_23_genport_2d_write_2d_file)
#define ___PRM_genport_23_genport_2d_write_2d_file ___PRM(21,___G_genport_23_genport_2d_write_2d_file)
#define ___GLO_genport_23_genport_2d_write_2d_set_21_ ___GLO(22,___G_genport_23_genport_2d_write_2d_set_21_)
#define ___PRM_genport_23_genport_2d_write_2d_set_21_ ___PRM(22,___G_genport_23_genport_2d_write_2d_set_21_)
#define ___GLO_genport_23_genport_2d_write_2d_subu8vector ___GLO(23,___G_genport_23_genport_2d_write_2d_subu8vector)
#define ___PRM_genport_23_genport_2d_write_2d_subu8vector ___PRM(23,___G_genport_23_genport_2d_write_2d_subu8vector)
#define ___GLO_genport_23_genport_2d_write_2d_u8vector ___GLO(24,___G_genport_23_genport_2d_write_2d_u8vector)
#define ___PRM_genport_23_genport_2d_write_2d_u8vector ___PRM(24,___G_genport_23_genport_2d_write_2d_u8vector)
#define ___GLO_genport_23_genport_3f_ ___GLO(25,___G_genport_23_genport_3f_)
#define ___PRM_genport_23_genport_3f_ ___PRM(25,___G_genport_23_genport_3f_)
#define ___GLO_genport_23_make_2d_genport ___GLO(26,___G_genport_23_make_2d_genport)
#define ___PRM_genport_23_make_2d_genport ___PRM(26,___G_genport_23_make_2d_genport)
#define ___GLO__23__23_append_2d_u8vectors ___GLO(27,___G__23__23_append_2d_u8vectors)
#define ___PRM__23__23_append_2d_u8vectors ___PRM(27,___G__23__23_append_2d_u8vectors)
#define ___GLO_close_2d_input_2d_port ___GLO(28,___G_close_2d_input_2d_port)
#define ___PRM_close_2d_input_2d_port ___PRM(28,___G_close_2d_input_2d_port)
#define ___GLO_close_2d_output_2d_port ___GLO(29,___G_close_2d_output_2d_port)
#define ___PRM_close_2d_output_2d_port ___PRM(29,___G_close_2d_output_2d_port)
#define ___GLO_delete_2d_file ___GLO(30,___G_delete_2d_file)
#define ___PRM_delete_2d_file ___PRM(30,___G_delete_2d_file)
#define ___GLO_file_2d_exists_3f_ ___GLO(31,___G_file_2d_exists_3f_)
#define ___PRM_file_2d_exists_3f_ ___PRM(31,___G_file_2d_exists_3f_)
#define ___GLO_make_2d_u8vector ___GLO(32,___G_make_2d_u8vector)
#define ___PRM_make_2d_u8vector ___PRM(32,___G_make_2d_u8vector)
#define ___GLO_open_2d_input_2d_file ___GLO(33,___G_open_2d_input_2d_file)
#define ___PRM_open_2d_input_2d_file ___PRM(33,___G_open_2d_input_2d_file)
#define ___GLO_open_2d_output_2d_file ___GLO(34,___G_open_2d_output_2d_file)
#define ___PRM_open_2d_output_2d_file ___PRM(34,___G_open_2d_output_2d_file)
#define ___GLO_read_2d_subu8vector ___GLO(35,___G_read_2d_subu8vector)
#define ___PRM_read_2d_subu8vector ___PRM(35,___G_read_2d_subu8vector)
#define ___GLO_reverse ___GLO(36,___G_reverse)
#define ___PRM_reverse ___PRM(36,___G_reverse)
#define ___GLO_subu8vector ___GLO(37,___G_subu8vector)
#define ___PRM_subu8vector ___PRM(37,___G_subu8vector)
#define ___GLO_subu8vector_2d_move_21_ ___GLO(38,___G_subu8vector_2d_move_21_)
#define ___PRM_subu8vector_2d_move_21_ ___PRM(38,___G_subu8vector_2d_move_21_)
#define ___GLO_write_2d_subu8vector ___GLO(39,___G_write_2d_subu8vector)
#define ___PRM_write_2d_subu8vector ___PRM(39,___G_write_2d_subu8vector)

___DEF_SUB_STRUCTURE(___X0,6)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(0,___S__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a))
               ___VEC1(___REF_SYM(5,___S_genport))
               ___VEC1(___REF_FIX(24))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(3))
               ___VEC0
___DEF_SUB_STRUCTURE(___X1,6)
               ___VEC1(___REF_SUB(1))
               ___VEC1(___REF_SYM(1,___S__23__23_type_2d_5))
               ___VEC1(___REF_SYM(10,___S_type))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(2))
               ___VEC0
___DEF_SUB_VEC(___X2,15)
               ___VEC1(___REF_SYM(6,___S_id))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(7,___S_name))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(4,___S_flags))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(9,___S_super))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(3,___S_fields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X3,9)
               ___VEC1(___REF_SYM(2,___S_end))
               ___VEC1(___REF_FIX(0))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(8,___S_read))
               ___VEC1(___REF_FIX(0))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(11,___S_write))
               ___VEC1(___REF_FIX(0))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X4,5)
               ___VEC1(___REF_SYM(5,___S_genport))
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
___DEF_M_HLBL(___L0__20_genport)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_make_2d_genport)
___DEF_M_HLBL(___L1_genport_23_make_2d_genport)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_end)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_end_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_read)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_read_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_write)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_write_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_input_2d_port_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L1_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L2_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L3_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L4_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L5_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L6_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L7_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL(___L8_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L1_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L2_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L3_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L4_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL(___L2_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL(___L3_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL(___L4_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL(___L5_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL(___L6_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_open_2d_input_2d_u8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_open_2d_input_2d_u8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_close_2d_input_2d_port)
___DEF_M_HLBL(___L1_genport_23_genport_2d_close_2d_input_2d_port)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_read_2d_subu8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_read_2d_subu8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L2_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L3_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L4_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L5_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L6_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L7_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL(___L8_genport_23_genport_2d_read_2d_u8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_read_2d_file)
___DEF_M_HLBL(___L1_genport_23_genport_2d_read_2d_file)
___DEF_M_HLBL(___L2_genport_23_genport_2d_read_2d_file)
___DEF_M_HLBL(___L3_genport_23_genport_2d_read_2d_file)
___DEF_M_HLBL(___L4_genport_23_genport_2d_read_2d_file)
___DEF_M_HLBL(___L5_genport_23_genport_2d_read_2d_file)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_output_2d_port_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L1_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L2_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L3_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L4_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L5_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L6_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L7_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L8_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L9_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL(___L10_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L1_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L2_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L3_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_M_HLBL(___L4_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L2_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L3_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L4_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L5_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L6_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L7_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L8_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L9_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L10_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L11_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L12_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L13_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L14_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L15_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L16_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L17_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L18_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L19_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L20_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L21_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L22_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L23_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L24_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L25_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L26_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L27_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L28_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L29_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L30_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L31_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L32_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL(___L33_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_get_2d_output_2d_u8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_get_2d_output_2d_u8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_close_2d_output_2d_port)
___DEF_M_HLBL(___L1_genport_23_genport_2d_close_2d_output_2d_port)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_write_2d_subu8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_write_2d_subu8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_write_2d_u8vector)
___DEF_M_HLBL(___L1_genport_23_genport_2d_write_2d_u8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_genport_23_genport_2d_write_2d_file)
___DEF_M_HLBL(___L1_genport_23_genport_2d_write_2d_file)
___DEF_M_HLBL(___L2_genport_23_genport_2d_write_2d_file)
___DEF_M_HLBL(___L3_genport_23_genport_2d_write_2d_file)
___DEF_M_HLBL(___L4_genport_23_genport_2d_write_2d_file)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20_genport
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
___DEF_P_HLBL(___L0__20_genport)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20_genport)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20_genport)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_make_2d_genport
#undef ___PH_LBL0
#define ___PH_LBL0 3
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_make_2d_genport)
___DEF_P_HLBL(___L1_genport_23_make_2d_genport)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_make_2d_genport)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_genport_23_make_2d_genport)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___R1)
   ___ADD_STRUCTURE_ELEM(2,___R2)
   ___ADD_STRUCTURE_ELEM(3,___R3)
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_genport_23_make_2d_genport)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 6
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_end
#undef ___PH_LBL0
#define ___PH_LBL0 8
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_end)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_end)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_end)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(0),___LBL(0)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_end_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 10
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_end_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_end_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_end_2d_set_21_)
   ___UNCHECKEDSTRUCTURESET(___R1,___R2,___FIX(1L),___SUB(0),___LBL(0))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_read
#undef ___PH_LBL0
#define ___PH_LBL0 12
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_read)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_read)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_read)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(0),___LBL(0)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_read_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 14
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_read_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_read_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_read_2d_set_21_)
   ___UNCHECKEDSTRUCTURESET(___R1,___R2,___FIX(2L),___SUB(0),___LBL(0))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_write
#undef ___PH_LBL0
#define ___PH_LBL0 16
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_write)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_write)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_write)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(0),___LBL(0)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_write_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 18
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_write_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_write_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_write_2d_set_21_)
   ___UNCHECKEDSTRUCTURESET(___R1,___R2,___FIX(3L),___SUB(0),___LBL(0))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_input_2d_port_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 20
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_input_2d_port_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_input_2d_port_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_input_2d_port_3f_)
   ___SET_STK(1,___R1)
   ___SET_R2(___BOOLEAN(___STRUCTUREDIOP(___STK(1),___SYM__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a)))
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L1_genport_23_genport_2d_input_2d_port_3f_)
   ___END_IF
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_genport_23_genport_2d_input_2d_port_3f_)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(0),___FIX(2L),___SUB(0),___PRC(12)))
   ___SET_R1(___BOOLEAN(___PROCEDUREP(___R1)))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_open_2d_input_2d_file
#undef ___PH_LBL0
#define ___PH_LBL0 22
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L1_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L2_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L3_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L4_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L5_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L6_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L7_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_P_HLBL(___L8_genport_23_genport_2d_open_2d_input_2d_file)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_open_2d_input_2d_file)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_open_2d_input_2d_file)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_open_2d_input_2d_file)
   ___JUMPPRM(___SET_NARGS(1),___PRM_open_2d_input_2d_file)
___DEF_SLBL(2,___L2_genport_23_genport_2d_open_2d_input_2d_file)
   ___SET_STK(-2,___ALLOC_CLO(1))
   ___SET_STK(-1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-2),7)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_SETUP_CLO(1,___STK(-1),5)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___STK(-2))
   ___ADD_STRUCTURE_ELEM(2,___STK(-1))
   ___ADD_STRUCTURE_ELEM(3,___FAL)
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___ADJFP(-1)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_genport_23_genport_2d_open_2d_input_2d_file)
   ___POLL(4)
___DEF_SLBL(4,___L4_genport_23_genport_2d_open_2d_input_2d_file)
   ___ADJFP(-3)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(5,___L5_genport_23_genport_2d_open_2d_input_2d_file)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(5,4,0,0)
   ___SET_R3(___CLO(___R4,1))
   ___POLL(6)
___DEF_SLBL(6,___L6_genport_23_genport_2d_open_2d_input_2d_file)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),35,___G_read_2d_subu8vector)
___DEF_SLBL(7,___L7_genport_23_genport_2d_open_2d_input_2d_file)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(7,1,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(8)
___DEF_SLBL(8,___L8_genport_23_genport_2d_open_2d_input_2d_file)
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_input_2d_port)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport
#undef ___PH_LBL0
#define ___PH_LBL0 32
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L1_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L2_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L3_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L4_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
   ___SET_STK(1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),3)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___LBL(2))
   ___ADD_STRUCTURE_ELEM(2,___STK(1))
   ___ADD_STRUCTURE_ELEM(3,___FAL)
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(2,___L2_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(2,1,0,0)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(3,4,0,0)
   ___SET_R3(___CLO(___R4,1))
   ___POLL(4)
___DEF_SLBL(4,___L4_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),35,___G_read_2d_subu8vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_open_2d_input_2d_subu8vector
#undef ___PH_LBL0
#define ___PH_LBL0 38
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_P_HLBL(___L2_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_P_HLBL(___L3_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_P_HLBL(___L4_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_P_HLBL(___L5_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___DEF_P_HLBL(___L6_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___SET_R2(___BOX(___R2))
   ___SET_STK(1,___ALLOC_CLO(3))
   ___BEGIN_SETUP_CLO(3,___STK(1),3)
   ___ADD_CLO_ELEM(0,___R2)
   ___ADD_CLO_ELEM(1,___R3)
   ___ADD_CLO_ELEM(2,___R1)
   ___END_SETUP_CLO(3)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___LBL(2))
   ___ADD_STRUCTURE_ELEM(2,___STK(1))
   ___ADD_STRUCTURE_ELEM(3,___FAL)
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(2,___L2_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(2,1,0,0)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(3,4,0,0)
   ___SET_R2(___FIXSUB(___R2,___R1))
   ___SET_R3(___CLO(___R4,1))
   ___SET_R3(___UNBOX(___R3))
   ___SET_STK(1,___CLO(___R4,2))
   ___SET_R3(___FIXSUB(___STK(1),___R3))
   ___SET_R2(___FIXMIN(___R3,___R2))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R4)
   ___SET_STK(8,___CLO(___R4,3))
   ___SET_R0(___CLO(___R4,1))
   ___SET_STK(9,___UNBOX(___R0))
   ___SET_R0(___CLO(___R4,1))
   ___SET_R2(___UNBOX(___R0))
   ___SET_R2(___FIXADD(___R2,___STK(2)))
   ___SET_STK(4,___R1)
   ___SET_R1(___R2)
   ___SET_R3(___STK(4))
   ___SET_R2(___STK(0))
   ___SET_R0(___LBL(5))
   ___ADJFP(9)
   ___POLL(4)
___DEF_SLBL(4,___L4_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),38,___G_subu8vector_2d_move_21_)
___DEF_SLBL(5,___L5_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___SET_R0(___CLO(___STK(-4),1))
   ___SET_R1(___UNBOX(___R0))
   ___SET_R1(___FIXADD(___R1,___STK(-5)))
   ___SET_R0(___CLO(___STK(-4),1))
   ___SETBOX(___R0,___R1)
   ___SET_R1(___STK(-5))
   ___POLL(6)
___DEF_SLBL(6,___L6_genport_23_genport_2d_open_2d_input_2d_subu8vector)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_open_2d_input_2d_u8vector
#undef ___PH_LBL0
#define ___PH_LBL0 46
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_open_2d_input_2d_u8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_open_2d_input_2d_u8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_open_2d_input_2d_u8vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_open_2d_input_2d_u8vector)
   ___SET_R3(___U8VECTORLENGTH(___R1))
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_open_2d_input_2d_u8vector)
   ___JUMPINT(___SET_NARGS(3),___PRC(38),___L_genport_23_genport_2d_open_2d_input_2d_subu8vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_close_2d_input_2d_port
#undef ___PH_LBL0
#define ___PH_LBL0 49
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_close_2d_input_2d_port)
___DEF_P_HLBL(___L1_genport_23_genport_2d_close_2d_input_2d_port)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_close_2d_input_2d_port)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_close_2d_input_2d_port)
   ___SET_STK(1,___R1)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___STK(1),___FIX(1L),___SUB(0),___PRC(8)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_close_2d_input_2d_port)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_read_2d_subu8vector
#undef ___PH_LBL0
#define ___PH_LBL0 52
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_read_2d_subu8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_read_2d_subu8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_read_2d_subu8vector)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_read_2d_subu8vector)
   ___SET_STK(1,___R3)
   ___SET_R4(___UNCHECKEDSTRUCTUREREF(___STK(1),___FIX(2L),___SUB(0),___PRC(12)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_read_2d_subu8vector)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(4),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_read_2d_u8vector
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
___DEF_P_HLBL(___L0_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L2_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L3_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L4_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L5_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L6_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L7_genport_23_genport_2d_read_2d_u8vector)
___DEF_P_HLBL(___L8_genport_23_genport_2d_read_2d_u8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_read_2d_u8vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_read_2d_u8vector)
   ___SET_R2(___FIX(0L))
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_read_2d_u8vector)
   ___GOTO(___L9_genport_23_genport_2d_read_2d_u8vector)
___DEF_SLBL(2,___L2_genport_23_genport_2d_read_2d_u8vector)
   ___IF(___FIXLT(___R1,___FIX(65536L)))
   ___GOTO(___L10_genport_23_genport_2d_read_2d_u8vector)
   ___END_IF
   ___SET_STK(-8,___R1)
   ___SET_R2(___FIXADD(___STK(-9),___R1))
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(6))
___DEF_GLBL(___L9_genport_23_genport_2d_read_2d_u8vector)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R1(___FIX(65536L))
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_genport_23_genport_2d_read_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_u8vector)
___DEF_SLBL(4,___L4_genport_23_genport_2d_read_2d_u8vector)
   ___SET_STK(-4,___R1)
   ___SET_STK(-3,___STK(-6))
   ___SET_STK(-2,___R1)
   ___SET_STK(5,___STK(-4))
   ___SET_R3(___STK(-3))
   ___SET_R2(___FIX(65536L))
   ___SET_R1(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___SET_R4(___UNCHECKEDSTRUCTUREREF(___STK(-3),___FIX(2L),___SUB(0),___PRC(12)))
   ___ADJFP(5)
   ___JUMPGENNOTSAFE(___SET_NARGS(4),___R4)
___DEF_GLBL(___L10_genport_23_genport_2d_read_2d_u8vector)
   ___SET_STK(-10,___R1)
   ___SET_R1(___FIXADD(___STK(-9),___R1))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(1),___PRM_make_2d_u8vector)
___DEF_SLBL(5,___L5_genport_23_genport_2d_read_2d_u8vector)
   ___GOTO(___L11_genport_23_genport_2d_read_2d_u8vector)
___DEF_SLBL(6,___L6_genport_23_genport_2d_read_2d_u8vector)
   ___SET_STK(-10,___STK(-8))
___DEF_GLBL(___L11_genport_23_genport_2d_read_2d_u8vector)
   ___SET_STK(-8,___R1)
   ___SET_STK(-3,___STK(-6))
   ___SET_STK(-2,___FIX(0L))
   ___SET_R3(___STK(-9))
   ___SET_R2(___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(7))
   ___ADJFP(-2)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),38,___G_subu8vector_2d_move_21_)
___DEF_SLBL(7,___L7_genport_23_genport_2d_read_2d_u8vector)
   ___SET_R1(___STK(-4))
   ___POLL(8)
___DEF_SLBL(8,___L8_genport_23_genport_2d_read_2d_u8vector)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_read_2d_file
#undef ___PH_LBL0
#define ___PH_LBL0 65
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_read_2d_file)
___DEF_P_HLBL(___L1_genport_23_genport_2d_read_2d_file)
___DEF_P_HLBL(___L2_genport_23_genport_2d_read_2d_file)
___DEF_P_HLBL(___L3_genport_23_genport_2d_read_2d_file)
___DEF_P_HLBL(___L4_genport_23_genport_2d_read_2d_file)
___DEF_P_HLBL(___L5_genport_23_genport_2d_read_2d_file)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_read_2d_file)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_read_2d_file)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_read_2d_file)
   ___JUMPINT(___SET_NARGS(1),___PRC(22),___L_genport_23_genport_2d_open_2d_input_2d_file)
___DEF_SLBL(2,___L2_genport_23_genport_2d_read_2d_file)
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(3))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(1),___PRC(55),___L_genport_23_genport_2d_read_2d_u8vector)
___DEF_SLBL(3,___L3_genport_23_genport_2d_read_2d_file)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(1),___PRC(49),___L_genport_23_genport_2d_close_2d_input_2d_port)
___DEF_SLBL(4,___L4_genport_23_genport_2d_read_2d_file)
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5_genport_23_genport_2d_read_2d_file)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_output_2d_port_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 72
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_output_2d_port_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_output_2d_port_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_output_2d_port_3f_)
   ___SET_STK(1,___R1)
   ___SET_R2(___BOOLEAN(___STRUCTUREDIOP(___STK(1),___SYM__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a)))
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___ADJFP(1)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L1_genport_23_genport_2d_output_2d_port_3f_)
   ___END_IF
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L1_genport_23_genport_2d_output_2d_port_3f_)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(0),___FIX(3L),___SUB(0),___PRC(16)))
   ___SET_R1(___BOOLEAN(___PROCEDUREP(___R1)))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_open_2d_output_2d_file
#undef ___PH_LBL0
#define ___PH_LBL0 74
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L1_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L2_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L3_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L4_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L5_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L6_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L7_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L8_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L9_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_P_HLBL(___L10_genport_23_genport_2d_open_2d_output_2d_file)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_open_2d_output_2d_file)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_open_2d_output_2d_file)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_open_2d_output_2d_file)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),31,___G_file_2d_exists_3f_)
___DEF_SLBL(2,___L2_genport_23_genport_2d_open_2d_output_2d_file)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L11_genport_23_genport_2d_open_2d_output_2d_file)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),30,___G_delete_2d_file)
___DEF_SLBL(3,___L3_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_GLBL(___L11_genport_23_genport_2d_open_2d_output_2d_file)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(4))
   ___ADJFP(-4)
   ___JUMPPRM(___SET_NARGS(1),___PRM_open_2d_output_2d_file)
___DEF_SLBL(4,___L4_genport_23_genport_2d_open_2d_output_2d_file)
   ___SET_STK(-2,___ALLOC_CLO(1))
   ___SET_STK(-1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(-2),9)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_SETUP_CLO(1,___STK(-1),7)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___STK(-2))
   ___ADD_STRUCTURE_ELEM(2,___FAL)
   ___ADD_STRUCTURE_ELEM(3,___STK(-1))
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___ADJFP(-1)
   ___CHECK_HEAP(5,4096)
___DEF_SLBL(5,___L5_genport_23_genport_2d_open_2d_output_2d_file)
   ___POLL(6)
___DEF_SLBL(6,___L6_genport_23_genport_2d_open_2d_output_2d_file)
   ___ADJFP(-3)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(7,___L7_genport_23_genport_2d_open_2d_output_2d_file)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(7,4,0,0)
   ___SET_R3(___CLO(___R4,1))
   ___POLL(8)
___DEF_SLBL(8,___L8_genport_23_genport_2d_open_2d_output_2d_file)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),39,___G_write_2d_subu8vector)
___DEF_SLBL(9,___L9_genport_23_genport_2d_open_2d_output_2d_file)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(9,1,0,0)
   ___SET_R1(___CLO(___R4,1))
   ___POLL(10)
___DEF_SLBL(10,___L10_genport_23_genport_2d_open_2d_output_2d_file)
   ___JUMPPRM(___SET_NARGS(1),___PRM_close_2d_output_2d_port)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport
#undef ___PH_LBL0
#define ___PH_LBL0 86
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L1_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L2_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L3_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___DEF_P_HLBL(___L4_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
   ___SET_STK(1,___ALLOC_CLO(1))
   ___BEGIN_SETUP_CLO(1,___STK(1),3)
   ___ADD_CLO_ELEM(0,___R1)
   ___END_SETUP_CLO(1)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___LBL(2))
   ___ADD_STRUCTURE_ELEM(2,___FAL)
   ___ADD_STRUCTURE_ELEM(3,___STK(1))
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(2,___L2_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(2,1,0,0)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(3,___L3_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(3,4,0,0)
   ___SET_R3(___CLO(___R4,1))
   ___POLL(4)
___DEF_SLBL(4,___L4_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport)
   ___JUMPGLONOTSAFE(___SET_NARGS(4),39,___G_write_2d_subu8vector)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_open_2d_output_2d_u8vector
#undef ___PH_LBL0
#define ___PH_LBL0 92
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L2_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L3_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L4_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L5_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L6_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L7_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L8_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L9_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L10_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L11_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L12_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L13_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L14_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L15_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L16_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L17_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L18_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L19_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L20_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L21_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L22_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L23_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L24_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L25_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L26_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L27_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L28_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L29_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L30_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L31_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L32_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_P_HLBL(___L33_genport_23_genport_2d_open_2d_output_2d_u8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_STK(1,___R0)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_SLBL(2,___L2_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___BOX(___R1))
   ___SET_R2(___BOX(___FIX(0L)))
   ___SET_R3(___BOX(___NUL))
   ___SET_STK(-2,___ALLOC_CLO(3))
   ___SET_STK(-1,___ALLOC_CLO(3))
   ___BEGIN_SETUP_CLO(3,___STK(-2),27)
   ___ADD_CLO_ELEM(0,___R1)
   ___ADD_CLO_ELEM(1,___R2)
   ___ADD_CLO_ELEM(2,___R3)
   ___END_SETUP_CLO(3)
   ___BEGIN_SETUP_CLO(3,___STK(-1),5)
   ___ADD_CLO_ELEM(0,___R1)
   ___ADD_CLO_ELEM(1,___R2)
   ___ADD_CLO_ELEM(2,___R3)
   ___END_SETUP_CLO(3)
   ___BEGIN_ALLOC_STRUCTURE(4)
   ___ADD_STRUCTURE_ELEM(0,___SUB(0))
   ___ADD_STRUCTURE_ELEM(1,___STK(-2))
   ___ADD_STRUCTURE_ELEM(2,___FAL)
   ___ADD_STRUCTURE_ELEM(3,___STK(-1))
   ___END_ALLOC_STRUCTURE(4)
   ___SET_R1(___GET_STRUCTURE(4))
   ___ADJFP(-1)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___POLL(4)
___DEF_SLBL(4,___L4_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___ADJFP(-3)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_SLBL(5,___L5_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(5,4,0,0)
   ___SET_STK(1,___STK(0))
   ___SET_STK(0,___CLO(___R4,1))
   ___SET_STK(2,___STK(1))
   ___SET_STK(1,___CLO(___R4,2))
   ___SET_STK(3,___STK(2))
   ___SET_STK(2,___CLO(___R4,3))
   ___SET_STK(4,___R1)
   ___SET_R3(___FIXSUB(___R2,___R1))
   ___SET_STK(5,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(5))
   ___ADJFP(4)
   ___POLL(6)
___DEF_SLBL(6,___L6_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___GOTO(___L34_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_SLBL(7,___L7_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-11),___R1)
   ___SETBOX(___STK(-10),___FIX(0L))
   ___SET_R3(___STK(-3))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-7)
   ___POLL(8)
___DEF_SLBL(8,___L8_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_GLBL(___L34_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___IF(___NOT(___FIXGT(___R3,___FIX(0L))))
   ___GOTO(___L41_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R4(___UNBOX(___STK(-3)))
   ___IF(___NOT(___FIXEQ(___R4,___FIX(1024L))))
   ___GOTO(___L40_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R4(___UNBOX(___STK(-2)))
   ___SET_STK(1,___UNBOX(___STK(-4)))
   ___SET_R4(___CONS(___STK(1),___R4))
   ___SETBOX(___STK(-2),___R4)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(11))
   ___ADJFP(7)
   ___CHECK_HEAP(9,4096)
___DEF_SLBL(9,___L9_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___POLL(10)
___DEF_SLBL(10,___L10_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_SLBL(11,___L11_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-11),___R1)
   ___SETBOX(___STK(-10),___FIX(0L))
   ___IF(___NOT(___FIXGT(___STK(-3),___FIX(0L))))
   ___GOTO(___L36_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-10)))
   ___IF(___FIXEQ(___R1,___FIX(1024L)))
   ___GOTO(___L39_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___GOTO(___L35_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_SLBL(12,___L12_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-11),___R1)
   ___SETBOX(___STK(-10),___FIX(0L))
   ___IF(___NOT(___FIXGT(___STK(-3),___FIX(0L))))
   ___GOTO(___L36_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-10)))
   ___IF(___FIXEQ(___R1,___FIX(1024L)))
   ___GOTO(___L38_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
___DEF_GLBL(___L35_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___UNBOX(___STK(-10)))
   ___SET_R1(___FIXSUB(___FIX(1024L),___R1))
   ___SET_R1(___FIXMIN(___STK(-3),___R1))
   ___SET_R2(___FIXADD(___STK(-4),___R1))
   ___SET_R3(___UNBOX(___STK(-10)))
   ___SET_R3(___FIXADD(___R3,___R1))
   ___SET_STK(-2,___R1)
   ___SET_STK(-1,___R2)
   ___SET_STK(0,___R3)
   ___SET_STK(5,___STK(-8))
   ___SET_STK(6,___STK(-4))
   ___SET_R3(___UNBOX(___STK(-10)))
   ___SET_R2(___UNBOX(___STK(-11)))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(13))
   ___ADJFP(6)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),38,___G_subu8vector_2d_move_21_)
___DEF_SLBL(13,___L13_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-14),___STK(-4))
   ___SET_R3(___FIXSUB(___STK(-7),___STK(-6)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-10))
   ___ADJFP(-11)
   ___POLL(14)
___DEF_SLBL(14,___L14_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___GOTO(___L34_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_SLBL(15,___L15_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-11),___R1)
   ___SETBOX(___STK(-10),___FIX(0L))
   ___IF(___FIXGT(___STK(-3),___FIX(0L)))
   ___GOTO(___L37_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
___DEF_GLBL(___L36_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___FIXSUB(___STK(-5),___STK(-7)))
   ___POLL(16)
___DEF_SLBL(16,___L16_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(6))
___DEF_GLBL(___L37_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___UNBOX(___STK(-10)))
   ___IF(___NOT(___FIXEQ(___R1,___FIX(1024L))))
   ___GOTO(___L35_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-9)))
   ___SET_R2(___UNBOX(___STK(-11)))
   ___SET_R1(___CONS(___R2,___R1))
   ___SETBOX(___STK(-9),___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(12))
   ___CHECK_HEAP(17,4096)
___DEF_SLBL(17,___L17_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_GLBL(___L38_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___UNBOX(___STK(-9)))
   ___SET_R2(___UNBOX(___STK(-11)))
   ___SET_R1(___CONS(___R2,___R1))
   ___SETBOX(___STK(-9),___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(7))
   ___CHECK_HEAP(18,4096)
___DEF_SLBL(18,___L18_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_GLBL(___L39_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___UNBOX(___STK(-9)))
   ___SET_R2(___UNBOX(___STK(-11)))
   ___SET_R1(___CONS(___R2,___R1))
   ___SETBOX(___STK(-9),___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(20))
   ___CHECK_HEAP(19,4096)
___DEF_SLBL(19,___L19_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_SLBL(20,___L20_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-11),___R1)
   ___SETBOX(___STK(-10),___FIX(0L))
   ___IF(___NOT(___FIXGT(___STK(-3),___FIX(0L))))
   ___GOTO(___L36_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-10)))
   ___IF(___NOT(___FIXEQ(___R1,___FIX(1024L))))
   ___GOTO(___L35_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-9)))
   ___SET_R2(___UNBOX(___STK(-11)))
   ___SET_R1(___CONS(___R2,___R1))
   ___SETBOX(___STK(-9),___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(22))
   ___CHECK_HEAP(21,4096)
___DEF_SLBL(21,___L21_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_SLBL(22,___L22_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-11),___R1)
   ___SETBOX(___STK(-10),___FIX(0L))
   ___IF(___NOT(___FIXGT(___STK(-3),___FIX(0L))))
   ___GOTO(___L36_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-10)))
   ___IF(___NOT(___FIXEQ(___R1,___FIX(1024L))))
   ___GOTO(___L35_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_R1(___UNBOX(___STK(-9)))
   ___SET_R2(___UNBOX(___STK(-11)))
   ___SET_R1(___CONS(___R2,___R1))
   ___SETBOX(___STK(-9),___R1)
   ___SET_R2(___FIX(0L))
   ___SET_R1(___FIX(1024L))
   ___SET_R0(___LBL(15))
   ___CHECK_HEAP(23,4096)
___DEF_SLBL(23,___L23_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(2),___PRM_make_2d_u8vector)
___DEF_GLBL(___L40_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R4(___UNBOX(___STK(-3)))
   ___SET_R4(___FIXSUB(___FIX(1024L),___R4))
   ___SET_R4(___FIXMIN(___R3,___R4))
   ___SET_STK(1,___FIXADD(___R2,___R4))
   ___SET_STK(2,___UNBOX(___STK(-3)))
   ___SET_STK(2,___FIXADD(___STK(2),___R4))
   ___SET_STK(3,___R0)
   ___SET_STK(4,___R1)
   ___SET_STK(5,___R3)
   ___SET_STK(6,___R4)
   ___SET_STK(12,___STK(-1))
   ___SET_STK(13,___R2)
   ___SET_R3(___UNBOX(___STK(-3)))
   ___SET_R2(___UNBOX(___STK(-4)))
   ___SET_R1(___STK(1))
   ___SET_R0(___LBL(25))
   ___ADJFP(13)
   ___POLL(24)
___DEF_SLBL(24,___L24_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPGLONOTSAFE(___SET_NARGS(5),38,___G_subu8vector_2d_move_21_)
___DEF_SLBL(25,___L25_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SETBOX(___STK(-14),___STK(-9))
   ___SET_R3(___FIXSUB(___STK(-6),___STK(-5)))
   ___SET_R2(___STK(-10))
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-8))
   ___ADJFP(-11)
   ___POLL(26)
___DEF_SLBL(26,___L26_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___GOTO(___L34_genport_23_genport_2d_open_2d_output_2d_u8vector)
___DEF_GLBL(___L41_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___FIXSUB(___R1,___STK(0)))
   ___ADJFP(-5)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(27,___L27_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(27,1,0,0)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L42_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R4)
   ___SET_R0(___CLO(___R4,2))
   ___SET_R3(___UNBOX(___R0))
   ___SET_R0(___CLO(___R4,1))
   ___SET_R1(___UNBOX(___R0))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(29))
   ___ADJFP(8)
   ___POLL(28)
___DEF_SLBL(28,___L28_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPGLONOTSAFE(___SET_NARGS(3),37,___G_subu8vector)
___DEF_SLBL(29,___L29_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R0(___CLO(___STK(-6),3))
   ___SET_R2(___UNBOX(___R0))
   ___SET_R1(___CONS(___R1,___R2))
   ___SET_R0(___LBL(31))
   ___CHECK_HEAP(30,4096)
___DEF_SLBL(30,___L30_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___JUMPPRM(___SET_NARGS(1),___PRM_reverse)
___DEF_SLBL(31,___L31_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R0(___LBL(32))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),27,___G__23__23_append_2d_u8vectors)
___DEF_SLBL(32,___L32_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R0(___CLO(___STK(-6),2))
   ___SETBOX(___R0,___FIX(0L))
   ___SET_R0(___CLO(___STK(-6),3))
   ___SETBOX(___R0,___NUL)
   ___POLL(33)
___DEF_SLBL(33,___L33_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L42_genport_23_genport_2d_open_2d_output_2d_u8vector)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_get_2d_output_2d_u8vector
#undef ___PH_LBL0
#define ___PH_LBL0 127
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_get_2d_output_2d_u8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_get_2d_output_2d_u8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_get_2d_output_2d_u8vector)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_get_2d_output_2d_u8vector)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(0),___PRC(8)))
   ___SET_STK(1,___R1)
   ___SET_R1(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_get_2d_output_2d_u8vector)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_close_2d_output_2d_port
#undef ___PH_LBL0
#define ___PH_LBL0 130
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_close_2d_output_2d_port)
___DEF_P_HLBL(___L1_genport_23_genport_2d_close_2d_output_2d_port)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_close_2d_output_2d_port)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_close_2d_output_2d_port)
   ___SET_STK(1,___R1)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___STK(1),___FIX(1L),___SUB(0),___PRC(8)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_close_2d_output_2d_port)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_write_2d_subu8vector
#undef ___PH_LBL0
#define ___PH_LBL0 133
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_write_2d_subu8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_write_2d_subu8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_write_2d_subu8vector)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_write_2d_subu8vector)
   ___SET_STK(1,___R3)
   ___SET_R4(___UNCHECKEDSTRUCTUREREF(___STK(1),___FIX(3L),___SUB(0),___PRC(16)))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_write_2d_subu8vector)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(4),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_write_2d_u8vector
#undef ___PH_LBL0
#define ___PH_LBL0 136
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_write_2d_u8vector)
___DEF_P_HLBL(___L1_genport_23_genport_2d_write_2d_u8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_write_2d_u8vector)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_write_2d_u8vector)
   ___SET_STK(1,___R1)
   ___SET_R1(___U8VECTORLENGTH(___R1))
   ___SET_R3(___R2)
   ___SET_STK(2,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___FIX(0L))
   ___SET_R4(___UNCHECKEDSTRUCTUREREF(___STK(2),___FIX(3L),___SUB(0),___PRC(16)))
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_write_2d_u8vector)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(4),___R4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_genport_23_genport_2d_write_2d_file
#undef ___PH_LBL0
#define ___PH_LBL0 139
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_genport_23_genport_2d_write_2d_file)
___DEF_P_HLBL(___L1_genport_23_genport_2d_write_2d_file)
___DEF_P_HLBL(___L2_genport_23_genport_2d_write_2d_file)
___DEF_P_HLBL(___L3_genport_23_genport_2d_write_2d_file)
___DEF_P_HLBL(___L4_genport_23_genport_2d_write_2d_file)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_genport_23_genport_2d_write_2d_file)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L_genport_23_genport_2d_write_2d_file)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1_genport_23_genport_2d_write_2d_file)
   ___JUMPINT(___SET_NARGS(1),___PRC(74),___L_genport_23_genport_2d_open_2d_output_2d_file)
___DEF_SLBL(2,___L2_genport_23_genport_2d_write_2d_file)
   ___SET_STK(-5,___R1)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(136),___L_genport_23_genport_2d_write_2d_u8vector)
___DEF_SLBL(3,___L3_genport_23_genport_2d_write_2d_file)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(4)
___DEF_SLBL(4,___L4_genport_23_genport_2d_write_2d_file)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(130),___L_genport_23_genport_2d_close_2d_output_2d_port)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20_genport," genport",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__20_genport,0,-1)
,___DEF_LBL_INTRO(___H_genport_23_make_2d_genport,"genport#make-genport",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_make_2d_genport,3,-1)
,___DEF_LBL_RET(___H_genport_23_make_2d_genport,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_genport_23_genport_3f_,"genport#genport?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_genport_23_genport_3f_,1,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_end,"genport#genport-end",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_end,1,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_end_2d_set_21_,"genport#genport-end-set!",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H_genport_23_genport_2d_end_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_read,"genport#genport-read",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_read,1,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_read_2d_set_21_,"genport#genport-read-set!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_read_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_write,"genport#genport-write",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_write,1,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_write_2d_set_21_,"genport#genport-write-set!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_write_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_input_2d_port_3f_,"genport#genport-input-port?",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_input_2d_port_3f_,1,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_open_2d_input_2d_file,"genport#genport-open-input-file",
___REF_FAL,9,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_file,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_file,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_file,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_file,___IFD(___RETI,3,0,0x3f1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_file,___IFD(___RETI,3,0,0x3f1L))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_file,4,1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_file,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_file,1,1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_file,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,"genport#genport-native-input-port->genport",
___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,1,-1)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,4,1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,"genport#genport-open-input-subu8vector",
___REF_FAL,7,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,3,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,1,-1)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,4,3)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,___OFD(___RETI,10,1,0x3f30eL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,___IFD(___RETN,5,1,0xeL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_subu8vector,___IFD(___RETI,8,1,0x3f02L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_open_2d_input_2d_u8vector,"genport#genport-open-input-u8vector",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_input_2d_u8vector,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_input_2d_u8vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_close_2d_input_2d_port,"genport#genport-close-input-port",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_close_2d_input_2d_port,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_close_2d_input_2d_port,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_read_2d_subu8vector,"genport#genport-read-subu8vector",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_read_2d_subu8vector,4,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_subu8vector,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_read_2d_u8vector,"genport#genport-read-u8vector",___REF_FAL,
9,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_read_2d_u8vector,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETN,9,0,0x27L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETN,9,0,0x27L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETN,9,0,0x2dL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETN,5,0,0x9L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_u8vector,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_read_2d_file,"genport#genport-read-file",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_read_2d_file,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_file,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_file,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_file,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_file,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_read_2d_file,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_output_2d_port_3f_,"genport#genport-output-port?",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_output_2d_port_3f_,1,-1)
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_open_2d_output_2d_file,"genport#genport-open-output-file",
___REF_FAL,11,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_output_2d_file,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETI,3,0,0x3f1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETI,3,0,0x3f1L))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_output_2d_file,4,1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_output_2d_file,1,1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_file,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,"genport#genport-native-output-port->genport",
___REF_FAL,5,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,1,-1)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,4,1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,"genport#genport-open-output-u8vector",
___REF_FAL,34,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,0,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,3,0,0x3f1L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,3,0,0x3f1L))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,4,3)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,13,5,0xf7fL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f020L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,9,5,0x1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,12,5,0x3f1ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___OFD(___RETI,18,7,0x3f307ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,13,7,0x7ffL))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,5,8,0x3f1fL))
,___DEF_LBL_PROC(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,1,3)
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_open_2d_output_2d_u8vector,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_get_2d_output_2d_u8vector,"genport#genport-get-output-u8vector",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_get_2d_output_2d_u8vector,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_get_2d_output_2d_u8vector,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_close_2d_output_2d_port,"genport#genport-close-output-port",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_close_2d_output_2d_port,1,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_close_2d_output_2d_port,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_write_2d_subu8vector,"genport#genport-write-subu8vector",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_write_2d_subu8vector,4,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_write_2d_subu8vector,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_write_2d_u8vector,"genport#genport-write-u8vector",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_write_2d_u8vector,2,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_write_2d_u8vector,___IFD(___RETI,2,4,0x3f1L))
,___DEF_LBL_INTRO(___H_genport_23_genport_2d_write_2d_file,"genport#genport-write-file",___REF_FAL,5,
0)
,___DEF_LBL_PROC(___H_genport_23_genport_2d_write_2d_file,2,-1)
,___DEF_LBL_RET(___H_genport_23_genport_2d_write_2d_file,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_write_2d_file,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_write_2d_file,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_genport_23_genport_2d_write_2d_file,___IFD(___RETI,8,8,0x3f00L))
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,10,1)
               ___GCMAP1(0x3f30eL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f020L)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,12,5)
               ___GCMAP1(0x3f1ffL)
,___DEF_OFD(___RETI,18,7)
               ___GCMAP1(0x3f307ffL)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20_genport,1)
___DEF_MOD_PRM(26,___G_genport_23_make_2d_genport,3)
___DEF_MOD_PRM(25,___G_genport_23_genport_3f_,6)
___DEF_MOD_PRM(3,___G_genport_23_genport_2d_end,8)
___DEF_MOD_PRM(4,___G_genport_23_genport_2d_end_2d_set_21_,10)
___DEF_MOD_PRM(15,___G_genport_23_genport_2d_read,12)
___DEF_MOD_PRM(17,___G_genport_23_genport_2d_read_2d_set_21_,14)
___DEF_MOD_PRM(20,___G_genport_23_genport_2d_write,16)
___DEF_MOD_PRM(22,___G_genport_23_genport_2d_write_2d_set_21_,18)
___DEF_MOD_PRM(6,___G_genport_23_genport_2d_input_2d_port_3f_,20)
___DEF_MOD_PRM(9,___G_genport_23_genport_2d_open_2d_input_2d_file,22)
___DEF_MOD_PRM(7,___G_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,32)
___DEF_MOD_PRM(10,___G_genport_23_genport_2d_open_2d_input_2d_subu8vector,38)
___DEF_MOD_PRM(11,___G_genport_23_genport_2d_open_2d_input_2d_u8vector,46)
___DEF_MOD_PRM(1,___G_genport_23_genport_2d_close_2d_input_2d_port,49)
___DEF_MOD_PRM(18,___G_genport_23_genport_2d_read_2d_subu8vector,52)
___DEF_MOD_PRM(19,___G_genport_23_genport_2d_read_2d_u8vector,55)
___DEF_MOD_PRM(16,___G_genport_23_genport_2d_read_2d_file,65)
___DEF_MOD_PRM(14,___G_genport_23_genport_2d_output_2d_port_3f_,72)
___DEF_MOD_PRM(12,___G_genport_23_genport_2d_open_2d_output_2d_file,74)
___DEF_MOD_PRM(8,___G_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,86)
___DEF_MOD_PRM(13,___G_genport_23_genport_2d_open_2d_output_2d_u8vector,92)
___DEF_MOD_PRM(5,___G_genport_23_genport_2d_get_2d_output_2d_u8vector,127)
___DEF_MOD_PRM(2,___G_genport_23_genport_2d_close_2d_output_2d_port,130)
___DEF_MOD_PRM(23,___G_genport_23_genport_2d_write_2d_subu8vector,133)
___DEF_MOD_PRM(24,___G_genport_23_genport_2d_write_2d_u8vector,136)
___DEF_MOD_PRM(21,___G_genport_23_genport_2d_write_2d_file,139)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20_genport,1)
___DEF_MOD_GLO(26,___G_genport_23_make_2d_genport,3)
___DEF_MOD_GLO(25,___G_genport_23_genport_3f_,6)
___DEF_MOD_GLO(3,___G_genport_23_genport_2d_end,8)
___DEF_MOD_GLO(4,___G_genport_23_genport_2d_end_2d_set_21_,10)
___DEF_MOD_GLO(15,___G_genport_23_genport_2d_read,12)
___DEF_MOD_GLO(17,___G_genport_23_genport_2d_read_2d_set_21_,14)
___DEF_MOD_GLO(20,___G_genport_23_genport_2d_write,16)
___DEF_MOD_GLO(22,___G_genport_23_genport_2d_write_2d_set_21_,18)
___DEF_MOD_GLO(6,___G_genport_23_genport_2d_input_2d_port_3f_,20)
___DEF_MOD_GLO(9,___G_genport_23_genport_2d_open_2d_input_2d_file,22)
___DEF_MOD_GLO(7,___G_genport_23_genport_2d_native_2d_input_2d_port_2d__3e_genport,32)
___DEF_MOD_GLO(10,___G_genport_23_genport_2d_open_2d_input_2d_subu8vector,38)
___DEF_MOD_GLO(11,___G_genport_23_genport_2d_open_2d_input_2d_u8vector,46)
___DEF_MOD_GLO(1,___G_genport_23_genport_2d_close_2d_input_2d_port,49)
___DEF_MOD_GLO(18,___G_genport_23_genport_2d_read_2d_subu8vector,52)
___DEF_MOD_GLO(19,___G_genport_23_genport_2d_read_2d_u8vector,55)
___DEF_MOD_GLO(16,___G_genport_23_genport_2d_read_2d_file,65)
___DEF_MOD_GLO(14,___G_genport_23_genport_2d_output_2d_port_3f_,72)
___DEF_MOD_GLO(12,___G_genport_23_genport_2d_open_2d_output_2d_file,74)
___DEF_MOD_GLO(8,___G_genport_23_genport_2d_native_2d_output_2d_port_2d__3e_genport,86)
___DEF_MOD_GLO(13,___G_genport_23_genport_2d_open_2d_output_2d_u8vector,92)
___DEF_MOD_GLO(5,___G_genport_23_genport_2d_get_2d_output_2d_u8vector,127)
___DEF_MOD_GLO(2,___G_genport_23_genport_2d_close_2d_output_2d_port,130)
___DEF_MOD_GLO(23,___G_genport_23_genport_2d_write_2d_subu8vector,133)
___DEF_MOD_GLO(24,___G_genport_23_genport_2d_write_2d_u8vector,136)
___DEF_MOD_GLO(21,___G_genport_23_genport_2d_write_2d_file,139)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S__23__23_type_2d_3_2d_genport_2d_94bfbdf4_2d_4132_2d_40e4_2d_9d0a_2d_35b34c28819a,"##type-3-genport-94bfbdf4-4132-40e4-9d0a-35b34c28819a")

___DEF_MOD_SYM(1,___S__23__23_type_2d_5,"##type-5")
___DEF_MOD_SYM(2,___S_end,"end")
___DEF_MOD_SYM(3,___S_fields,"fields")
___DEF_MOD_SYM(4,___S_flags,"flags")
___DEF_MOD_SYM(5,___S_genport,"genport")
___DEF_MOD_SYM(6,___S_id,"id")
___DEF_MOD_SYM(7,___S_name,"name")
___DEF_MOD_SYM(8,___S_read,"read")
___DEF_MOD_SYM(9,___S_super,"super")
___DEF_MOD_SYM(10,___S_type,"type")
___DEF_MOD_SYM(11,___S_write,"write")
___END_MOD_SYM_KEY

#endif
