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

@rem We can't use -D___SINGLE_HOST for all Gambit generated C files
@rem because the C compiler runs out of memory while compiling _num.c
@rem and _io.c .

set COMP_GEN=wcc386 -w0 -zp4 -zq -obetir -bm -3r -bt=nt -mf -I..\include -D___GAMBCDIR=%GAMBCDIR% -D___SYS_TYPE_CPU="i686" -D___SYS_TYPE_VENDOR="pc" -D___SYS_TYPE_OS="openwatcom" -D___IMPORTED_ID_SUFFIX="_"
set COMP_LIB_MH=%COMP_GEN% -D___LIBRARY
set COMP_LIB_PR_MH=%COMP_LIB_MH% -D___PRIMAL
set COMP_LIB=%COMP_LIB_MH% -D___SINGLE_HOST
set COMP_LIB_PR=%COMP_LIB_PR_MH% -D___SINGLE_HOST
set COMP_APP=%COMP_GEN% -D___SINGLE_HOST

@rem We can't rely on sed being available so we generate gambit.h
@rem from gambit.h.in by prefixing it with the needed declarations.

echo #ifndef ___VOIDSTAR_WIDTH                > include\gambit.h
echo #define ___VOIDSTAR_WIDTH ___LONG_WIDTH >> include\gambit.h
echo #endif                                  >> include\gambit.h
echo #ifndef ___MAX_CHR                      >> include\gambit.h
echo #define ___MAX_CHR 0x10ffff             >> include\gambit.h
echo #endif                                  >> include\gambit.h
type include\gambit.h.in                     >> include\gambit.h

cd lib

%COMP_LIB_PR% main.c
%COMP_LIB_PR% setup.c
%COMP_LIB_PR% mem.c
%COMP_LIB_PR% os.c
%COMP_LIB_PR% os_base.c
%COMP_LIB_PR% os_time.c
%COMP_LIB_PR% os_shell.c
%COMP_LIB_PR% os_files.c
%COMP_LIB_PR% os_dyn.c
%COMP_LIB_PR% os_tty.c
%COMP_LIB_PR% os_io.c
%COMP_LIB_PR% c_intf.c

%COMP_LIB_PR% _kernel.c
%COMP_LIB_PR% _system.c
%COMP_LIB_PR_MH% _num.c
%COMP_LIB_PR% _std.c
%COMP_LIB_PR% _eval.c
%COMP_LIB_PR_MH% _io.c
%COMP_LIB_PR% _nonstd.c
%COMP_LIB_PR% _thread.c
%COMP_LIB_PR% _repl.c

%COMP_LIB_PR% _gambc.c

cd ..

cd gsi

%COMP_LIB% _gsilib.c
%COMP_LIB% _gambcgsi.c
%COMP_APP% _gsi.c
%COMP_APP% _gsi_.c

wlink option quiet option stack=16384 system nt file ..\lib\main.obj,..\lib\setup.obj,..\lib\mem.obj,..\lib\c_intf.obj,..\lib\os.obj,..\lib\os_base.obj,..\lib\os_time.obj,..\lib\os_shell.obj,..\lib\os_files.obj,..\lib\os_dyn.obj,..\lib\os_tty.obj,..\lib\os_io.obj,..\lib\_kernel.obj,..\lib\_system.obj,..\lib\_num.obj,..\lib\_std.obj,..\lib\_eval.obj,..\lib\_io.obj,..\lib\_nonstd.obj,..\lib\_thread.obj,..\lib\_repl.obj,..\lib\_gambc.obj,_gsilib.obj,_gambcgsi.obj,_gsi.obj,_gsi_.obj library kernel32,user32,gdi32,ws2_32 name gsi.exe

cd ..

cd gsc

%COMP_LIB% _host.c
%COMP_LIB% _utils.c
%COMP_LIB% _source.c
%COMP_LIB% _parms.c
%COMP_LIB% _env.c
%COMP_LIB% _ptree1.c
%COMP_LIB% _ptree2.c
%COMP_LIB% _gvm.c
%COMP_LIB% _back.c
%COMP_LIB% _front.c
%COMP_LIB% _prims.c
%COMP_LIB% _t-c-1.c
%COMP_LIB% _t-c-2.c
%COMP_LIB% _t-c-3.c
%COMP_LIB% _gsclib.c
%COMP_LIB% _gambcgsc.c
%COMP_APP% _gsc.c
%COMP_APP% _gsc_.c

wlink option quiet option stack=16384 system nt file ..\lib\main.obj,..\lib\setup.obj,..\lib\mem.obj,..\lib\c_intf.obj,..\lib\os.obj,..\lib\os_base.obj,..\lib\os_time.obj,..\lib\os_shell.obj,..\lib\os_files.obj,..\lib\os_dyn.obj,..\lib\os_tty.obj,..\lib\os_io.obj,..\lib\_kernel.obj,..\lib\_system.obj,..\lib\_num.obj,..\lib\_std.obj,..\lib\_eval.obj,..\lib\_io.obj,..\lib\_nonstd.obj,..\lib\_thread.obj,..\lib\_repl.obj,..\lib\_gambc.obj,_host.obj,_utils.obj,_source.obj,_parms.obj,_env.obj,_ptree1.obj,_ptree2.obj,_gvm.obj,_back.obj,_front.obj,_prims.obj,_t-c-1.obj,_t-c-2.obj,_t-c-3.obj,_gsclib.obj,_gambcgsc.obj,_gsclib.obj,_gsc.obj,_gsc_.obj library kernel32,user32,gdi32,ws2_32 name gsc.exe

cd ..

cd bin

echo @echo off> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo rem Script parameters are passed in the following environment variables:>> gsc-cc-o.bat
echo rem   GSC_CC_O_GAMBCDIR>> gsc-cc-o.bat
echo rem   GSC_CC_O_OBJ_FILENAME>> gsc-cc-o.bat
echo rem   GSC_CC_O_C_FILENAME_DIR>> gsc-cc-o.bat
echo rem   GSC_CC_O_C_FILENAME_BASE>> gsc-cc-o.bat
echo rem   GSC_CC_O_CC_OPTIONS>> gsc-cc-o.bat
echo rem   GSC_CC_O_LD_OPTIONS_PRELUDE>> gsc-cc-o.bat
echo rem   GSC_CC_O_LD_OPTIONS>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo rem echo GSC_CC_O_GAMBCDIR = %%GSC_CC_O_GAMBCDIR%%>> gsc-cc-o.bat
echo rem echo GSC_CC_O_OBJ_FILENAME = %%GSC_CC_O_OBJ_FILENAME%%>> gsc-cc-o.bat
echo rem echo GSC_CC_O_C_FILENAME_DIR = %%GSC_CC_O_C_FILENAME_DIR%%>> gsc-cc-o.bat
echo rem echo GSC_CC_O_C_FILENAME_BASE = %%GSC_CC_O_C_FILENAME_BASE%%>> gsc-cc-o.bat
echo rem echo GSC_CC_O_CC_OPTIONS = %%GSC_CC_O_CC_OPTIONS%%>> gsc-cc-o.bat
echo rem echo GSC_CC_O_LD_OPTIONS_PRELUDE = %%GSC_CC_O_LD_OPTIONS_PRELUDE%%>> gsc-cc-o.bat
echo rem echo GSC_CC_O_LD_OPTIONS = %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo for %%%%f in (wcl386.exe cl.exe gcc.exe) do if not "%%%%~$PATH:f" == "" goto use_%%%%%%f>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo echo gcc.exe, wcl386.exe and cl.exe were not found in the PATH.  Make sure MinGW, OpenWatcom or Visual C++ Express is installed.>> gsc-cc-o.bat
echo exit 1 >> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_gcc.exe>> gsc-cc-o.bat
echo cd "%GSC_CC_O_C_FILENAME_DIR%">> gsc-cc-o.bat
echo gcc.exe -mno-cygwin -Wall -W -Wno-unused -O1 -fno-math-errno -fschedule-insns2 -fno-trapping-math -fno-strict-aliasing -fwrapv -fno-common -mieee-fp -shared -I"%%GSC_CC_O_GAMBCDIR%%include" -D___DYNAMIC -D___SINGLE_HOST -o "%%GSC_CC_O_OBJ_FILENAME%%" %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% "%%GSC_CC_O_C_FILENAME_BASE%%" %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_wcl386.exe>> gsc-cc-o.bat
echo cd "%GSC_CC_O_C_FILENAME_DIR%">> gsc-cc-o.bat
echo wcl386.exe -w0 -zp4 -zq -obetir -bm -3r -bt=nt -mf -bd -I"%%GSC_CC_O_GAMBCDIR%%include" -D___DYNAMIC -D___SINGLE_HOST -l=nt_dll -fe="%%GSC_CC_O_OBJ_FILENAME%%" %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% "%%GSC_CC_O_C_FILENAME_BASE%%" %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_cl.exe>> gsc-cc-o.bat
echo cd "%GSC_CC_O_C_FILENAME_DIR%">> gsc-cc-o.bat
echo cl.exe -nologo -Oityb1 -MT -D_CRT_SECURE_NO_DEPRECATE -LD -I"%%GSC_CC_O_GAMBCDIR%%include" -D___DYNAMIC -D___SINGLE_HOST -Fe"%%GSC_CC_O_OBJ_FILENAME%%" %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% "%%GSC_CC_O_C_FILENAME_BASE%%" %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_build_time_c_compiler>> gsc-cc-o.bat
echo cd "%GSC_CC_O_C_FILENAME_DIR%">> gsc-cc-o.bat
echo gcc.exe -mno-cygwin -Wall -W -Wno-unused -O1 -fno-math-errno -fschedule-insns2 -fno-trapping-math -fno-strict-aliasing -fwrapv -fno-common -mieee-fp -shared -I"%%GSC_CC_O_GAMBCDIR%%include" -D___DYNAMIC -D___SINGLE_HOST -o "%%GSC_CC_O_OBJ_FILENAME%%" %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% "%%GSC_CC_O_C_FILENAME_BASE%%" %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo exit>> gsc-cc-o.bat

cd ..
