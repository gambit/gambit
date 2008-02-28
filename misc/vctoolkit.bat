@rem File: "vctoolkit.bat"
@rem
@rem This is a batch file to compile Gambit with the Microsoft Visual C++
@rem Toolkit 2003 (this compiler can be obtained at no charge from Microsoft
@rem at this URL: http://msdn.microsoft.com/visualc/vctoolkit2003/).  You
@rem must have the Microsoft Platform SDK (also obtainable at no charge
@rem from Microsoft) and must have installed it in
@rem C:/Program Files/Microsoft Platform SDK/.
@rem
@rem TODO: turn this into a makefile

@rem Setup environment variables

@call "C:\Program Files\Microsoft Visual C++ Toolkit 2003\vcvars32.bat"
@call "C:\Program Files\Microsoft Platform SDK\SetEnv.Cmd"

@IF "%1%" == "" (
SET GAMBCDIR="C:/Gambit-C/././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././."
) ELSE (
SET GAMBCDIR="%1%"
)

@rem We can't use -D___SINGLE_HOST for all Gambit generated C files
@rem because the C compiler runs out of memory while compiling _num.c
@rem and _io.c .

set COMP_GEN=cl -nologo -Oityb1 -G5s -MT -c -I..\include -D___GAMBCDIR=\"%GAMBCDIR%\" -D___SYS_TYPE_CPU=\"i686\" -D___SYS_TYPE_VENDOR=\"pc\" -D___SYS_TYPE_OS=\"visualc\"
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

lib -out:libgambc.lib main.obj setup.obj mem.obj os.obj os_base.obj os_time.obj os_shell.obj os_files.obj os_dyn.obj os_tty.obj os_io.obj c_intf.obj _kernel.obj _system.obj _num.obj _std.obj _eval.obj _io.obj _nonstd.obj _thread.obj _repl.obj _gambc.obj

cd ..

cd gsi

%COMP_LIB% _gsilib.c
%COMP_LIB% _gambcgsi.c
%COMP_APP% _gsi.c
%COMP_APP% _gsi_.c

cl -Fegsi.exe ..\lib\libgambc.lib _gsilib.obj _gambcgsi.obj _gsi.obj _gsi_.obj Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib

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

cl -Fegsc.exe ..\lib\libgambc.lib _host.obj _utils.obj _source.obj _parms.obj _env.obj _ptree1.obj _ptree2.obj _gvm.obj _back.obj _front.obj _prims.obj _t-c-1.obj _t-c-2.obj _t-c-3.obj _gsclib.obj _gambcgsc.obj _gsc.obj _gsc_.obj Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib

cd ..

cd bin

echo @echo off> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo for %%%%f in (cl.exe gcc.exe wcl386.exe) do if not "%%%%~$PATH:f" == "" goto use_%%%%%%f>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo echo gcc.exe, wcl386.exe and cl.exe were not found in the PATH.  Make sure MinGW, OpenWatcom or Visual C++ Express is installed.>> gsc-cc-o.bat
echo exit 1 >> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_gcc.exe>> gsc-cc-o.bat
echo cd %GSC_CC_O_C_FILENAME_DIR%>> gsc-cc-o.bat
echo gcc.exe -Wall -W -Wno-unused -O1 -fno-math-errno -fschedule-insns2 -fno-trapping-math -fno-strict-aliasing -fwrapv -fno-common -mieee-fp -shared -I%%GSC_CC_O_GAMBCDIR%%include -D___DYNAMIC -D___SINGLE_HOST -o %%GSC_CC_O_OBJ_FILENAME%% %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% %%GSC_CC_O_C_FILENAME_BASE%% %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_wcl386.exe>> gsc-cc-o.bat
echo cd %GSC_CC_O_C_FILENAME_DIR%>> gsc-cc-o.bat
echo wcl386.exe -w0 -zp4 -zq -obetir -bm -3r -bt=nt -mf -bd -I%%GSC_CC_O_GAMBCDIR%%include -D___DYNAMIC -D___SINGLE_HOST -l=nt_dll -fe=%%GSC_CC_O_OBJ_FILENAME%% %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% %%GSC_CC_O_C_FILENAME_BASE%% %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_cl.exe>> gsc-cc-o.bat
echo cd %GSC_CC_O_C_FILENAME_DIR%>> gsc-cc-o.bat
echo cl.exe -nologo -Oityb1 -MT -D_CRT_SECURE_NO_DEPRECATE -LD -I%%GSC_CC_O_GAMBCDIR%%include -D___DYNAMIC -D___SINGLE_HOST -Fe%%GSC_CC_O_OBJ_FILENAME%% %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% %%GSC_CC_O_C_FILENAME_BASE%% %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :use_build_time_c_compiler>> gsc-cc-o.bat
echo cd %GSC_CC_O_C_FILENAME_DIR%>> gsc-cc-o.bat
echo gcc.exe -Wall -W -Wno-unused -O1 -fno-math-errno -fschedule-insns2 -fno-trapping-math -fno-strict-aliasing -fwrapv -fno-common -mieee-fp -shared -I%%GSC_CC_O_GAMBCDIR%%include -D___DYNAMIC -D___SINGLE_HOST -o %%GSC_CC_O_OBJ_FILENAME%% %%GSC_CC_O_CC_OPTIONS%% %%GSC_CC_O_LD_OPTIONS_PRELUDE%% %%GSC_CC_O_C_FILENAME_BASE%% %%GSC_CC_O_LD_OPTIONS%%>> gsc-cc-o.bat
echo goto end>> gsc-cc-o.bat
echo.>> gsc-cc-o.bat
echo :end>> gsc-cc-o.bat

cd ..
