@echo off
rem File: "vstudio.bat"
rem
rem This is a batch file to compile Gambit with the Microsoft Visual
rem Studio development tools.
rem
rem This batch file must be executed in the Gambit root directory.
rem It can take a command line parameter which is the root installation
rem directory.  For example:
rem
rem   misc\vstudio.bat c:\gambit

rem We can't use -D___SINGLE_HOST for all Gambit generated C files
rem because the C compiler runs out of memory while compiling _num.c
rem and _io.c .

set C_COMPILER=cl.exe
set C_PREPROC=cl.exe -E
set FLAGS_COMMON= -nologo -MT -D_WINDOWS -D_WIN32_WINNT=0x0600 -D_ATL_XP_TARGETING -D_CRT_SECURE_NO_DEPRECATE
set FLAGS_OPT= -Oityb1
set FLAGS_OPT_RTS= -Oityb2
set FLAGS_LINK= -link -subsystem:console,5.02 -entry:WinMainCRTStartup
set DEFS_LIB= -D___SYS_TYPE_CPU=\"i686\" -D___SYS_TYPE_VENDOR=\"pc\" -D___SYS_TYPE_OS=\"visualc\" 
set DEFS_SH= -D___SINGLE_HOST 
set DEFS_MH=
set DEFS_COMMON=%DEFS_SH%
set LIBS= Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib

if not "%1%" == "" (
set DEFS_LIB=%DEFS_LIB% -D___GAMBITDIR=\"%1%\"
)

set COMP_GEN=%C_COMPILER% %FLAGS_COMMON% -c -I..\include
set COMP_LIB_MH=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% -D___LIBRARY
set COMP_LIB_PR_MH=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% -D___LIBRARY -D___PRIMAL
set COMP_LIB=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% %DEFS_SH% -D___LIBRARY
set COMP_LIB_PR=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% %DEFS_SH% -D___LIBRARY -D___PRIMAL
set COMP_LIB_PR_RTS=%COMP_GEN% %FLAGS_OPT_RTS% %DEFS_LIB% %DEFS_SH% -D___LIBRARY -D___PRIMAL
set COMP_APP=%COMP_GEN% %FLAGS_OPT% %DEFS_SH%

rem We can't rely on sed being available so we generate gambit.h
rem from gambit.h.in by prefixing it with the needed declarations.

echo #ifndef ___VOIDSTAR_WIDTH                 > include\gambit.h
echo #ifdef _WIN64                            >> include\gambit.h
echo #define ___VOIDSTAR_WIDTH 64             >> include\gambit.h
echo #else                                    >> include\gambit.h
echo #define ___VOIDSTAR_WIDTH 32             >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___MAX_CHR                       >> include\gambit.h
echo #define ___MAX_CHR 0x10ffff              >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___SINGLE_VM                     >> include\gambit.h
echo #ifndef ___MULTIPLE_VMS                  >> include\gambit.h
echo #define ___SINGLE_VM                     >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___SINGLE_THREADED_VMS           >> include\gambit.h
echo #ifndef ___MULTIPLE_THREADED_VMS         >> include\gambit.h
echo #define ___SINGLE_THREADED_VMS           >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___USE_POSIX_THREAD_SYSTEM       >> include\gambit.h
echo #ifndef ___USE_WIN32_THREAD_SYSTEM       >> include\gambit.h
echo #define ___USE_NO_THREAD_SYSTEM          >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___NO_THREAD_LOCAL_STORAGE_CLASS >> include\gambit.h
echo #ifndef ___THREAD_LOCAL_STORAGE_CLASS    >> include\gambit.h
echo #define ___NO_THREAD_LOCAL_STORAGE_CLASS >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___HAVE_CONDITION_VARIABLE       >> include\gambit.h
echo #ifndef ___DONT_HAVE_CONDITION_VARIABLE  >> include\gambit.h
echo #define ___DONT_HAVE_CONDITION_VARIABLE  >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___NO_ACTIVITY_LOG               >> include\gambit.h
echo #ifndef ___ACTIVITY_LOG                  >> include\gambit.h
echo #define ___NO_ACTIVITY_LOG               >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___BOOL                          >> include\gambit.h
echo #define ___BOOL int                      >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #ifndef ___USE_SIGSET_T                  >> include\gambit.h
echo #ifndef ___USE_NO_SIGSET_T               >> include\gambit.h
echo #define ___USE_NO_SIGSET_T               >> include\gambit.h
echo #endif                                   >> include\gambit.h
echo #endif                                   >> include\gambit.h
type include\gambit.h.in                      >> include\gambit.h

cd lib

%COMP_LIB_PR_RTS% main.c
%COMP_LIB_PR_RTS% setup.c
%COMP_LIB_PR_RTS% mem.c
%COMP_LIB_PR_RTS% os_setup.c
%COMP_LIB_PR_RTS% os_base.c
%COMP_LIB_PR_RTS% os_time.c
%COMP_LIB_PR_RTS% os_shell.c
%COMP_LIB_PR_RTS% os_files.c
%COMP_LIB_PR_RTS% os_dyn.c
%COMP_LIB_PR_RTS% os_tty.c
%COMP_LIB_PR_RTS% os_io.c
%COMP_LIB_PR_RTS% os_thread.c
%COMP_LIB_PR_RTS% c_intf.c
%COMP_LIB_PR_RTS% actlog.c

%COMP_LIB_PR% _kernel.c
%COMP_LIB_PR% _system.c
%COMP_LIB_PR_MH% _num.c
%COMP_LIB_PR% _std.c
%COMP_LIB_PR% _eval.c
%COMP_LIB_PR_MH% _io.c
%COMP_LIB_PR% _nonstd.c
%COMP_LIB_PR% _thread.c
%COMP_LIB_PR% _repl.c

%COMP_LIB_PR% _gambit.c

lib -out:libgambit.lib main.obj setup.obj mem.obj os_setup.obj os_base.obj os_time.obj os_shell.obj os_files.obj os_dyn.obj os_tty.obj os_io.obj os_thread.obj c_intf.obj actlog.obj _kernel.obj _system.obj _num.obj _std.obj _eval.obj _io.obj _nonstd.obj _thread.obj _repl.obj _gambit.obj

cd ..

cd gsi

%COMP_LIB% _gsilib.c
%COMP_LIB% _gambitgsi.c
%COMP_APP% _gsi.c
%COMP_APP% _gsi_.c

%C_COMPILER% -Fegsi.exe ..\lib\libgambit.lib _gsilib.obj _gambitgsi.obj _gsi.obj _gsi_.obj %LIBS% %FLAGS_LINK%

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
%COMP_LIB% _assert.c
%COMP_LIB% _asm.c
%COMP_LIB% _x86.c
%COMP_LIB% _codegen.c
%COMP_LIB% _t-univ-1.c
%COMP_LIB% _t-univ-2.c
%COMP_LIB% _t-univ-3.c
%COMP_LIB% _t-univ-4.c
%COMP_LIB% _t-c-1.c
%COMP_LIB% _t-c-2.c
%COMP_LIB% _t-c-3.c
%COMP_LIB% _gsclib.c
%COMP_LIB% _gambitgsc.c
%COMP_APP% _gsc.c
%COMP_APP% _gsc_.c

%C_COMPILER% -Fegsc.exe ..\lib\libgambit.lib _host.obj _utils.obj _source.obj _parms.obj _env.obj _ptree1.obj _ptree2.obj _gvm.obj _back.obj _front.obj _prims.obj _assert.obj _asm.obj _x86.obj _codegen.obj _t-univ-1.obj _t-univ-2.obj _t-univ-3.obj _t-univ-4.obj _t-c-1.obj _t-c-2.obj _t-c-3.obj _gsclib.obj _gambitgsc.obj _gsc.obj _gsc_.obj %LIBS% %FLAGS_LINK%

cd ..

cd bin

set C_COMPILER_BAT=%C_COMPILER%
set C_PREPROC_BAT=%C_PREPROC%

set FLAGS_OBJ_BAT=%FLAGS_COMMON%
set FLAGS_DYN_BAT=%FLAGS_COMMON% -LD
set FLAGS_LIB_BAT=%FLAGS_COMMON%
set FLAGS_EXE_BAT=%FLAGS_COMMON%

set FLAGS_OPT_BAT=%FLAGS_OPT%
set FLAGS_OPT_RTS_BAT=%FLAGS_OPT_RTS%

set DEFS_OBJ_BAT=%DEFS_COMMON%
set DEFS_DYN_BAT=%DEFS_COMMON% -D___DYNAMIC
set DEFS_LIB_BAT=%DEFS_COMMON%
set DEFS_EXE_BAT=%DEFS_COMMON%

set BUILD_OBJ_BAT=%%%%C_COMPILER%%%% %%%%FLAGS_OPT%%%% %%%%FLAGS_OBJ%%%% %%%%DEFS_OBJ%%%% -I"%%%%GAMBITDIR_INCLUDE%%%%" -c -Fo"%%%%BUILD_OBJ_OUTPUT_FILENAME%%%%" %%%%BUILD_OBJ_CC_OPTIONS%%%% %%%%BUILD_OBJ_INPUT_FILENAMES%%%%
set BUILD_DYN_BAT=%%%%C_COMPILER%%%% %%%%FLAGS_OPT%%%% %%%%FLAGS_DYN%%%% %%%%DEFS_DYN%%%% -I"%%%%GAMBITDIR_INCLUDE%%%%" -Fe"%%%%BUILD_DYN_OUTPUT_FILENAME%%%%" %%%%BUILD_DYN_CC_OPTIONS%%%% %%%%BUILD_DYN_LD_OPTIONS_PRELUDE%%%% %%%%BUILD_DYN_INPUT_FILENAMES%%%% %%%%BUILD_DYN_LD_OPTIONS%%%%
set BUILD_LIB_BAT=echo BUILD_LIB not yet implemented
set BUILD_EXE_BAT=%%%%C_COMPILER%%%% %%%%FLAGS_EXE%%%% %%%%DEFS_EXE%%%% -I"%%%%GAMBITDIR_INCLUDE%%%%"  -Fe"%%%%BUILD_EXE_OUTPUT_FILENAME%%%%" %%%%BUILD_EXE_CC_OPTIONS%%%% %%%%BUILD_EXE_LD_OPTIONS_PRELUDE%%%% %%%%BUILD_EXE_INPUT_FILENAMES%%%% "%%%%GAMBITDIR_LIB%%%%/libgambit.lib" %%%%LIBS%%%% %%%%BUILD_EXE_LD_OPTIONS%%%% %FLAGS_LINK%

set BUILD_OBJ_ECHO_BAT=%%C_COMPILER%% %%FLAGS_OPT%% %%FLAGS_OBJ%% %%DEFS_OBJ%% -I"%%GAMBITDIR_INCLUDE%%" -c -Fo"%%BUILD_OBJ_OUTPUT_FILENAME%%" %%BUILD_OBJ_CC_OPTIONS%% %%BUILD_OBJ_INPUT_FILENAMES%%
set BUILD_DYN_ECHO_BAT=%%C_COMPILER%% %%FLAGS_OPT%% %%FLAGS_DYN%% %%DEFS_DYN%% -I"%%GAMBITDIR_INCLUDE%%" -Fe"%%BUILD_DYN_OUTPUT_FILENAME%%" %%BUILD_DYN_CC_OPTIONS%% %%BUILD_DYN_LD_OPTIONS_PRELUDE%% %%BUILD_DYN_INPUT_FILENAMES%% %%BUILD_DYN_LD_OPTIONS%%
set BUILD_LIB_ECHO_BAT=echo BUILD_LIB not yet implemented
set BUILD_EXE_ECHO_BAT=%%C_COMPILER%% %%FLAGS_EXE%% %%DEFS_EXE%% -I"%%GAMBITDIR_INCLUDE%%"  -Fe"%%BUILD_EXE_OUTPUT_FILENAME%%" %%BUILD_EXE_CC_OPTIONS%% %%BUILD_EXE_LD_OPTIONS_PRELUDE%% %%BUILD_EXE_INPUT_FILENAMES%% "%%GAMBITDIR_LIB%%/libgambit.lib" %%LIBS%% %%BUILD_EXE_LD_OPTIONS%% %%FLAGS_LINK%%

set DEFS_BAT=
set LIBS_BAT= %LIBS%
set GAMBITLIB_BAT=gambit
set GAMBITGSCLIB_BAT=gambitgsc
set GAMBITGSILIB_BAT=gambitgsi
set LIB_PREFIX_BAT=lib
set LIB_EXTENSION_BAT=.lib
set OBJ_EXTENSION_BAT=.obj
set EXE_EXTENSION_BAT=.exe
set BAT_EXTENSION_BAT=.bat

echo @echo off> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo rem The following settings are determined by the configure script.>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo set C_COMPILER=%C_COMPILER_BAT%>> gambcomp-C.bat
echo set C_PREPROC=%C_PREPROC_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo set FLAGS_OBJ=%FLAGS_OBJ_BAT%>> gambcomp-C.bat
echo set FLAGS_DYN=%FLAGS_DYN_BAT%>> gambcomp-C.bat
echo set FLAGS_LIB=%FLAGS_LIB_BAT%>> gambcomp-C.bat
echo set FLAGS_EXE=%FLAGS_EXE_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo set FLAGS_OPT=%FLAGS_OPT_BAT%>> gambcomp-C.bat
echo set FLAGS_OPT_RTS=%FLAGS_OPT_RTS_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo set DEFS_OBJ=%DEFS_OBJ_BAT%>> gambcomp-C.bat
echo set DEFS_DYN=%DEFS_DYN_BAT%>> gambcomp-C.bat
echo set DEFS_LIB=%DEFS_LIB_BAT%>> gambcomp-C.bat
echo set DEFS_EXE=%DEFS_EXE_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo set BUILD_OBJ=%BUILD_OBJ_BAT%>> gambcomp-C.bat
echo set BUILD_DYN=%BUILD_DYN_BAT%>> gambcomp-C.bat
echo set BUILD_LIB=%BUILD_LIB_BAT%>> gambcomp-C.bat
echo set BUILD_EXE=%BUILD_EXE_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo set DEFS=%DEFS_BAT%>> gambcomp-C.bat
echo set LIBS=%LIBS_BAT%>> gambcomp-C.bat
echo set GAMBITLIB=%GAMBITLIB_BAT%>> gambcomp-C.bat
echo set GAMBITGSCLIB=%GAMBITGSCLIB_BAT%>> gambcomp-C.bat
echo set GAMBITGSILIB=%GAMBITGSILIB_BAT%>> gambcomp-C.bat
echo set LIB_PREFIX=%LIB_PREFIX_BAT%>> gambcomp-C.bat
echo set LIB_EXTENSION=%LIB_EXTENSION_BAT%>> gambcomp-C.bat
echo set OBJ_EXTENSION=%OBJ_EXTENSION_BAT%>> gambcomp-C.bat
echo set EXE_EXTENSION=%EXE_EXTENSION_BAT%>> gambcomp-C.bat
echo set BAT_EXTENSION=%BAT_EXTENSION_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "obj" goto obj>> gambcomp-C.bat
echo if not "%%1" == ""obj"" goto not_obj>> gambcomp-C.bat
echo :obj>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if not "%%GAMBCOMP_VERBOSE%%" == "yes" goto not_obj_verbose>> gambcomp-C.bat
echo echo.%BUILD_OBJ_ECHO_BAT%>> gambcomp-C.bat
echo :not_obj_verbose>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo %BUILD_OBJ_ECHO_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_obj>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "dyn" goto dyn>> gambcomp-C.bat
echo if not "%%1" == ""dyn"" goto not_dyn>> gambcomp-C.bat
echo :dyn>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if not "%%GAMBCOMP_VERBOSE%%" == "yes" goto not_dyn_verbose>> gambcomp-C.bat
echo echo.%BUILD_DYN_ECHO_BAT%>> gambcomp-C.bat
echo :not_dyn_verbose>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo %BUILD_DYN_ECHO_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_dyn>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "lib" goto lib>> gambcomp-C.bat
echo if not "%%1" == ""lib"" goto not_lib>> gambcomp-C.bat
echo :lib>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if not "%%GAMBCOMP_VERBOSE%%" == "yes" goto not_lib_verbose>> gambcomp-C.bat
echo echo.%BUILD_LIB_ECHO_BAT%>> gambcomp-C.bat
echo :not_lib_verbose>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo %BUILD_LIB_ECHO_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_lib>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "exe" goto exe>> gambcomp-C.bat
echo if not "%%1" == ""exe"" goto not_exe>> gambcomp-C.bat
echo :exe>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if not "%%GAMBCOMP_VERBOSE%%" == "yes" goto not_exe_verbose>> gambcomp-C.bat
echo echo.%BUILD_EXE_ECHO_BAT%>> gambcomp-C.bat
echo :not_exe_verbose>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo %BUILD_EXE_ECHO_BAT%>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_exe>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "C_COMPILER" goto C_COMPILER>> gambcomp-C.bat
echo if not "%%1" == ""C_COMPILER"" goto not_C_COMPILER>> gambcomp-C.bat
echo :C_COMPILER>> gambcomp-C.bat
echo echo.%%C_COMPILER%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_C_COMPILER>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "C_PREPROC" goto C_PREPROC>> gambcomp-C.bat
echo if not "%%1" == ""C_PREPROC"" goto not_C_PREPROC>> gambcomp-C.bat
echo :C_PREPROC>> gambcomp-C.bat
echo echo.%%C_PREPROC%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_C_PREPROC>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "FLAGS_OBJ" goto FLAGS_OBJ>> gambcomp-C.bat
echo if not "%%1" == ""FLAGS_OBJ"" goto not_FLAGS_OBJ>> gambcomp-C.bat
echo :FLAGS_OBJ>> gambcomp-C.bat
echo echo.%%FLAGS_OBJ%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_FLAGS_OBJ>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "FLAGS_DYN" goto FLAGS_DYN>> gambcomp-C.bat
echo if not "%%1" == ""FLAGS_DYN"" goto not_FLAGS_DYN>> gambcomp-C.bat
echo :FLAGS_DYN>> gambcomp-C.bat
echo echo.%%FLAGS_DYN%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_FLAGS_DYN>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "FLAGS_LIB" goto FLAGS_LIB>> gambcomp-C.bat
echo if not "%%1" == ""FLAGS_LIB"" goto not_FLAGS_LIB>> gambcomp-C.bat
echo :FLAGS_LIB>> gambcomp-C.bat
echo echo.%%FLAGS_LIB%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_FLAGS_LIB>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "FLAGS_EXE" goto FLAGS_EXE>> gambcomp-C.bat
echo if not "%%1" == ""FLAGS_EXE"" goto not_FLAGS_EXE>> gambcomp-C.bat
echo :FLAGS_EXE>> gambcomp-C.bat
echo echo.%%FLAGS_EXE%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_FLAGS_EXE>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "FLAGS_OPT" goto FLAGS_OPT>> gambcomp-C.bat
echo if not "%%1" == ""FLAGS_OPT"" goto not_FLAGS_OPT>> gambcomp-C.bat
echo :FLAGS_OPT>> gambcomp-C.bat
echo echo.%%FLAGS_OPT%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_FLAGS_OPT>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "FLAGS_OPT_RTS" goto FLAGS_OPT_RTS>> gambcomp-C.bat
echo if not "%%1" == ""FLAGS_OPT_RTS"" goto not_FLAGS_OPT_RTS>> gambcomp-C.bat
echo :FLAGS_OPT_RTS>> gambcomp-C.bat
echo echo.%%FLAGS_OPT_RTS%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_FLAGS_OPT_RTS>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "DEFS_OBJ" goto DEFS_OBJ>> gambcomp-C.bat
echo if not "%%1" == ""DEFS_OBJ"" goto not_DEFS_OBJ>> gambcomp-C.bat
echo :DEFS_OBJ>> gambcomp-C.bat
echo echo.%%DEFS_OBJ%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_DEFS_OBJ>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "DEFS_DYN" goto DEFS_DYN>> gambcomp-C.bat
echo if not "%%1" == ""DEFS_DYN"" goto not_DEFS_DYN>> gambcomp-C.bat
echo :DEFS_DYN>> gambcomp-C.bat
echo echo.%%DEFS_DYN%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_DEFS_DYN>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "DEFS_LIB" goto DEFS_LIB>> gambcomp-C.bat
echo if not "%%1" == ""DEFS_LIB"" goto not_DEFS_LIB>> gambcomp-C.bat
echo :DEFS_LIB>> gambcomp-C.bat
echo echo.%%DEFS_LIB%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_DEFS_LIB>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "DEFS_EXE" goto DEFS_EXE>> gambcomp-C.bat
echo if not "%%1" == ""DEFS_EXE"" goto not_DEFS_EXE>> gambcomp-C.bat
echo :DEFS_EXE>> gambcomp-C.bat
echo echo.%%DEFS_EXE%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_DEFS_EXE>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "BUILD_OBJ" goto BUILD_OBJ>> gambcomp-C.bat
echo if not "%%1" == ""BUILD_OBJ"" goto not_BUILD_OBJ>> gambcomp-C.bat
echo :BUILD_OBJ>> gambcomp-C.bat
echo echo.%%BUILD_OBJ%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_BUILD_OBJ>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "BUILD_DYN" goto BUILD_DYN>> gambcomp-C.bat
echo if not "%%1" == ""BUILD_DYN"" goto not_BUILD_DYN>> gambcomp-C.bat
echo :BUILD_DYN>> gambcomp-C.bat
echo echo.%%BUILD_DYN%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_BUILD_DYN>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "BUILD_LIB" goto BUILD_LIB>> gambcomp-C.bat
echo if not "%%1" == ""BUILD_LIB"" goto not_BUILD_LIB>> gambcomp-C.bat
echo :BUILD_LIB>> gambcomp-C.bat
echo echo.%%BUILD_LIB%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_BUILD_LIB>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "BUILD_EXE" goto BUILD_EXE>> gambcomp-C.bat
echo if not "%%1" == ""BUILD_EXE"" goto not_BUILD_EXE>> gambcomp-C.bat
echo :BUILD_EXE>> gambcomp-C.bat
echo echo.%%BUILD_EXE%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_BUILD_EXE>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "DEFS" goto DEFS>> gambcomp-C.bat
echo if not "%%1" == ""DEFS"" goto not_DEFS>> gambcomp-C.bat
echo :DEFS>> gambcomp-C.bat
echo echo.%%DEFS%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_DEFS>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "LIBS" goto LIBS>> gambcomp-C.bat
echo if not "%%1" == ""LIBS"" goto not_LIBS>> gambcomp-C.bat
echo :LIBS>> gambcomp-C.bat
echo echo.%%LIBS%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_LIBS>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "GAMBITLIB_DEFS" goto GAMBITLIB_DEFS>> gambcomp-C.bat
echo if not "%%1" == ""GAMBITLIB_DEFS"" goto not_GAMBITLIB_DEFS>> gambcomp-C.bat
echo :GAMBITLIB_DEFS>> gambcomp-C.bat
echo echo.%%GAMBITLIB_DEFS%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_GAMBITLIB_DEFS>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "GAMBITLIB" goto GAMBITLIB>> gambcomp-C.bat
echo if not "%%1" == ""GAMBITLIB"" goto not_GAMBITLIB>> gambcomp-C.bat
echo :GAMBITLIB>> gambcomp-C.bat
echo echo.%%GAMBITLIB%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_GAMBITLIB>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "GAMBITGSCLIB" goto GAMBITGSCLIB>> gambcomp-C.bat
echo if not "%%1" == ""GAMBITGSCLIB"" goto not_GAMBITGSCLIB>> gambcomp-C.bat
echo :GAMBITGSCLIB>> gambcomp-C.bat
echo echo.%%GAMBITGSCLIB%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_GAMBITGSCLIB>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "GAMBITGSILIB" goto GAMBITGSILIB>> gambcomp-C.bat
echo if not "%%1" == ""GAMBITGSILIB"" goto not_GAMBITGSILIB>> gambcomp-C.bat
echo :GAMBITGSILIB>> gambcomp-C.bat
echo echo.%%GAMBITGSILIB%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_GAMBITGSILIB>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "LIB_PREFIX" goto LIB_PREFIX>> gambcomp-C.bat
echo if not "%%1" == ""LIB_PREFIX"" goto not_LIB_PREFIX>> gambcomp-C.bat
echo :LIB_PREFIX>> gambcomp-C.bat
echo echo.%%LIB_PREFIX%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_LIB_PREFIX>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "LIB_EXTENSION" goto LIB_EXTENSION>> gambcomp-C.bat
echo if not "%%1" == ""LIB_EXTENSION"" goto not_LIB_EXTENSION>> gambcomp-C.bat
echo :LIB_EXTENSION>> gambcomp-C.bat
echo echo.%%LIB_EXTENSION%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_LIB_EXTENSION>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "OBJ_EXTENSION" goto OBJ_EXTENSION>> gambcomp-C.bat
echo if not "%%1" == ""OBJ_EXTENSION"" goto not_OBJ_EXTENSION>> gambcomp-C.bat
echo :OBJ_EXTENSION>> gambcomp-C.bat
echo echo.%%OBJ_EXTENSION%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_OBJ_EXTENSION>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "EXE_EXTENSION" goto EXE_EXTENSION>> gambcomp-C.bat
echo if not "%%1" == ""EXE_EXTENSION"" goto not_EXE_EXTENSION>> gambcomp-C.bat
echo :EXE_EXTENSION>> gambcomp-C.bat
echo echo.%%EXE_EXTENSION%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_EXE_EXTENSION>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo if "%%1" == "BAT_EXTENSION" goto BAT_EXTENSION>> gambcomp-C.bat
echo if not "%%1" == ""BAT_EXTENSION"" goto not_BAT_EXTENSION>> gambcomp-C.bat
echo :BAT_EXTENSION>> gambcomp-C.bat
echo echo.%%BAT_EXTENSION%%>> gambcomp-C.bat
echo goto end>> gambcomp-C.bat
echo :not_BAT_EXTENSION>> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo echo.gambcomp-C.bat unknown operation "%%1">> gambcomp-C.bat
echo exit /b 1 >> gambcomp-C.bat
echo.>> gambcomp-C.bat
echo :end>> gambcomp-C.bat
echo exit /b 0 >> gambcomp-C.bat

cd ..
