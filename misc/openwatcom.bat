@rem File: "openwatcom.bat"
@rem
@rem This is a batch file to compile Gambit with the Open Watcom compiler
@rem (this compiler can be obtained at no charge from
@rem http://openwatcom.mirrors.pair.com/).  It is assumed a full installation
@rem of the Open Watcom compiler has been done and that the system is
@rem installed in C:\WATCOM.
@rem
@rem TODO: turn this into a makefile

@SET WATCOM=C:\WATCOM
@SET PATH=%WATCOM%\BINNT;%WATCOM%\BINW;%PATH%
@SET EDPATH=%WATCOM%\EDDAT
@SET INCLUDE=%WATCOM%\H;%WATCOM%\H\NT

@IF "%1%" == "" (
SET GAMBCDIR="C:/Gambit-C/././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././."
) ELSE (
SET GAMBCDIR="%1%"
)

@rem We can't use -D___SINGLE_HOST because the C compiler runs out of memory
@rem while compiling _num.c

set COMP_GEN=wcc386 -w0 -zp4 -zq -obetir -bm -3r -bt=nt -mf -I..\include
set COMP_LIB=%COMP_GEN% -D___PRIMAL -D___LIBRARY -D___GAMBCDIR=%GAMBCDIR%
set COMP_APP=%COMP_GEN%

cd lib

%COMP_LIB% main.c
%COMP_LIB% setup.c
%COMP_LIB% mem.c
%COMP_LIB% os.c
%COMP_LIB% os_base.c
%COMP_LIB% os_time.c
%COMP_LIB% os_shell.c
%COMP_LIB% os_files.c
%COMP_LIB% os_dyn.c
%COMP_LIB% os_tty.c
%COMP_LIB% os_io.c
%COMP_LIB% c_intf.c

%COMP_LIB% _kernel.c
%COMP_LIB% _system.c
%COMP_LIB% _num.c
%COMP_LIB% _std.c
%COMP_LIB% _eval.c
%COMP_LIB% _io.c
%COMP_LIB% _nonstd.c
%COMP_LIB% _thread.c
%COMP_LIB% _repl.c

%COMP_LIB% _gambc.c

cd ..

cd gsi

%COMP_APP% _gsi.c
%COMP_APP% _gsi_.c

wlink option quiet option stack=16384 system nt file ..\lib\main.obj,..\lib\setup.obj,..\lib\mem.obj,..\lib\c_intf.obj,..\lib\os.obj,..\lib\os_base.obj,..\lib\os_time.obj,..\lib\os_shell.obj,..\lib\os_files.obj,..\lib\os_dyn.obj,..\lib\os_tty.obj,..\lib\os_io.obj,..\lib\_kernel.obj,..\lib\_system.obj,..\lib\_num.obj,..\lib\_std.obj,..\lib\_eval.obj,..\lib\_io.obj,..\lib\_nonstd.obj,..\lib\_thread.obj,..\lib\_repl.obj,..\lib\_gambc.obj,_gsi.obj,_gsi_.obj library kernel32,user32,gdi32,ws2_32 name gsi.exe

cd ..

cd gsc

%COMP_APP% _host.c
%COMP_APP% _utils.c
%COMP_APP% _source.c
%COMP_APP% _parms.c
%COMP_APP% _env.c
%COMP_APP% _ptree1.c
%COMP_APP% _ptree2.c
%COMP_APP% _gvm.c
%COMP_APP% _back.c
%COMP_APP% _front.c
%COMP_APP% _prims.c
%COMP_APP% _t-c-1.c
%COMP_APP% _t-c-2.c
%COMP_APP% _t-c-3.c
%COMP_APP% _gsc.c
%COMP_APP% _gsc_.c

wlink option quiet option stack=16384 system nt file ..\lib\main.obj,..\lib\setup.obj,..\lib\mem.obj,..\lib\c_intf.obj,..\lib\os.obj,..\lib\os_base.obj,..\lib\os_time.obj,..\lib\os_shell.obj,..\lib\os_files.obj,..\lib\os_dyn.obj,..\lib\os_tty.obj,..\lib\os_io.obj,..\lib\_kernel.obj,..\lib\_system.obj,..\lib\_num.obj,..\lib\_std.obj,..\lib\_eval.obj,..\lib\_io.obj,..\lib\_nonstd.obj,..\lib\_thread.obj,..\lib\_repl.obj,..\lib\_gambc.obj,_host.obj,_utils.obj,_source.obj,_parms.obj,_env.obj,_ptree1.obj,_ptree2.obj,_gvm.obj,_back.obj,_front.obj,_prims.obj,_t-c-1.obj,_t-c-2.obj,_t-c-3.obj,_gsc.obj,_gsc_.obj library kernel32,user32,gdi32,ws2_32 name gsc.exe

cd ..
