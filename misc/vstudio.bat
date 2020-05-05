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
set PKG_CONFIG=pkg-config

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
set DEFS_LIB=%DEFS_LIB% -D___GAMBITDIR_USERLIB=\"~\\.gambit_userlib\"

set COMP_GEN=%C_COMPILER% %FLAGS_COMMON% -c -I..\include
set COMP_LIB_MH=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% -D___LIBRARY
set COMP_LIB_PR_MH=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% -D___LIBRARY -D___PRIMAL
set COMP_LIB=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% %DEFS_SH% -D___LIBRARY
set COMP_LIB_PR=%COMP_GEN% %FLAGS_OPT% %DEFS_LIB% %DEFS_SH% -D___LIBRARY -D___PRIMAL
set COMP_LIB_PR_RTS=%COMP_GEN% %FLAGS_OPT_RTS% %DEFS_LIB% %DEFS_SH% -D___LIBRARY -D___PRIMAL
set COMP_APP=%COMP_GEN% %FLAGS_OPT% %DEFS_SH%

rem We can't rely on sed being available so we generate gambit.h
rem from gambit.h.in by prefixing it with the needed declarations.

echo #define ___DEFAULT_RUNTIME_OPTIONS {'s', 'e', 'a', 'r', 'c', 'h', '=', '~', '~', 'u', 's', 'e', 'r', 'l', 'i', 'b', ',', 's', 'e', 'a', 'r', 'c', 'h', '=', '~', '~', 'l', 'i', 'b', ',', 'w', 'h', 'i', 't', 'e', 'l', 'i', 's', 't', '=', 'g', 'i', 't', 'h', 'u', 'b', '.', 'c', 'o', 'm', '/', 'g', 'a', 'm', 'b', 'i', 't', '\0'} > include/gambit.h
echo #ifndef ___VOIDSTAR_WIDTH                >> include\gambit.h
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
%COMP_LIB_PR% _module.c

%COMP_LIB_PR% _gambit.c

lib -out:libgambit.lib main.obj setup.obj mem.obj os_setup.obj os_base.obj os_time.obj os_shell.obj os_files.obj os_dyn.obj os_tty.obj os_io.obj os_thread.obj c_intf.obj actlog.obj _kernel.obj _system.obj _num.obj _std.obj _eval.obj _io.obj _module.obj _nonstd.obj _thread.obj _repl.obj _gambit.obj

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
%COMP_LIB% _arm.c
%COMP_LIB% _riscv.c
%COMP_LIB% _x86.c
%COMP_LIB% _codegen.c
%COMP_LIB% _t-univ-1.c
%COMP_LIB% _t-univ-2.c
%COMP_LIB% _t-univ-3.c
%COMP_LIB% _t-univ-4.c
%COMP_LIB% _t-c-1.c
%COMP_LIB% _t-c-2.c
%COMP_LIB% _t-c-3.c
%COMP_LIB% _t-cpu-abstract-machine.c
%COMP_LIB% _t-cpu-backend-arm.c
%COMP_LIB% _t-cpu-backend-riscv.c
%COMP_LIB% _t-cpu-backend-x86.c
%COMP_LIB% _t-cpu-object-desc.c
%COMP_LIB% _t-cpu-primitives.c
%COMP_LIB% _t-cpu-utils.c
%COMP_LIB% _t-cpu.c
%COMP_LIB% _gsclib.c
%COMP_LIB% _gambitgsc.c
%COMP_APP% _gsc.c
%COMP_APP% _gsc_.c

%C_COMPILER% -Fegsc.exe ..\lib\libgambit.lib _host.obj _utils.obj _source.obj _parms.obj _env.obj _ptree1.obj _ptree2.obj _gvm.obj _back.obj _front.obj _prims.obj _assert.obj _asm.obj _arm.obj _riscv.obj _x86.obj _codegen.obj _t-univ-1.obj _t-univ-2.obj _t-univ-3.obj _t-univ-4.obj _t-c-1.obj _t-c-2.obj _t-c-3.obj _t-cpu-abstract-machine.obj _t-cpu-backend-arm.obj _t-cpu-backend-riscv.obj _t-cpu-backend-x86.obj _t-cpu-object-desc.obj _t-cpu-primitives.obj _t-cpu-utils.obj _t-cpu.obj _gsclib.obj _gambitgsc.obj _gsc.obj _gsc_.obj %LIBS% %FLAGS_LINK%

cd ..

cd bin

set C_COMPILER_BAT=%C_COMPILER%
set C_PREPROC_BAT=%C_PREPROC%
set PKG_CONFIG_BAT=%PKG_CONFIG%

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

set BUILD_OBJ_BAT=%%%%C_COMPILER%%%% %%%%FLAGS_OPT%%%% %%%%FLAGS_OBJ%%%% %%%%DEFS_OBJ%%%% -I"%%%%GAMBITDIR_INCLUDE%%%%" -c -Fo"%%%%BUILD_OBJ_OUTPUT_FILENAME_PARAM%%%%" %%%%BUILD_OBJ_CC_OPTIONS_PARAM%%%% %%%%BUILD_OBJ_INPUT_FILENAMES_PARAM%%%%
set BUILD_DYN_BAT=%%%%C_COMPILER%%%% %%%%FLAGS_OPT%%%% %%%%FLAGS_DYN%%%% %%%%DEFS_DYN%%%% -I"%%%%GAMBITDIR_INCLUDE%%%%" -Fe"%%%%BUILD_DYN_OUTPUT_FILENAME_PARAM%%%%" %%%%BUILD_DYN_CC_OPTIONS_PARAM%%%% %%%%BUILD_DYN_LD_OPTIONS_PRELUDE_PARAM%%%% %%%%BUILD_DYN_INPUT_FILENAMES_PARAM%%%% %%%%BUILD_DYN_LD_OPTIONS_PARAM%%%%
set BUILD_LIB_BAT=echo BUILD_LIB not yet implemented
set BUILD_EXE_BAT=%%%%C_COMPILER%%%% %%%%FLAGS_EXE%%%% %%%%DEFS_EXE%%%% -I"%%%%GAMBITDIR_INCLUDE%%%%"  -Fe"%%%%BUILD_EXE_OUTPUT_FILENAME_PARAM%%%%" %%%%BUILD_EXE_CC_OPTIONS_PARAM%%%% %%%%BUILD_EXE_LD_OPTIONS_PRELUDE_PARAM%%%% %%%%BUILD_EXE_INPUT_FILENAMES_PARAM%%%% "%%%%GAMBITDIR_LIB%%%%/libgambit.lib" %%%%LIBS%%%% %%%%BUILD_EXE_LD_OPTIONS_PARAM%%%% %FLAGS_LINK%

set BUILD_OBJ_ECHO_BAT=%%C_COMPILER%% %%FLAGS_OPT%% %%FLAGS_OBJ%% %%DEFS_OBJ%% -I"%%GAMBITDIR_INCLUDE%%" -c -Fo"%%BUILD_OBJ_OUTPUT_FILENAME_PARAM%%" %%BUILD_OBJ_CC_OPTIONS_PARAM%% %%BUILD_OBJ_INPUT_FILENAMES_PARAM%%
set BUILD_DYN_ECHO_BAT=%%C_COMPILER%% %%FLAGS_OPT%% %%FLAGS_DYN%% %%DEFS_DYN%% -I"%%GAMBITDIR_INCLUDE%%" -Fe"%%BUILD_DYN_OUTPUT_FILENAME_PARAM%%" %%BUILD_DYN_CC_OPTIONS_PARAM%% %%BUILD_DYN_LD_OPTIONS_PRELUDE_PARAM%% %%BUILD_DYN_INPUT_FILENAMES_PARAM%% %%BUILD_DYN_LD_OPTIONS_PARAM%%
set BUILD_LIB_ECHO_BAT=echo BUILD_LIB not yet implemented
set BUILD_EXE_ECHO_BAT=%%C_COMPILER%% %%FLAGS_EXE%% %%DEFS_EXE%% -I"%%GAMBITDIR_INCLUDE%%"  -Fe"%%BUILD_EXE_OUTPUT_FILENAME_PARAM%%" %%BUILD_EXE_CC_OPTIONS_PARAM%% %%BUILD_EXE_LD_OPTIONS_PRELUDE_PARAM%% %%BUILD_EXE_INPUT_FILENAMES_PARAM%% "%%GAMBITDIR_LIB%%/libgambit.lib" %%LIBS%% %%BUILD_EXE_LD_OPTIONS_PARAM%% %%FLAGS_LINK%%

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

set ALL_BUILD_FEATURES_BAT=visualc
set BUILD_FEATURE_C_COMP_BAT=visualc

echo @echo off > gambuild-C.bat
echo. >> gambuild-C.bat
echo setlocal EnableDelayedExpansion >> gambuild-C.bat
echo set "_errorlevel=0" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem The following settings are determined by the configure script. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set C_COMPILER^=%C_COMPILER_BAT% >> gambuild-C.bat
echo set C_PREPROC^=%C_PREPROC_BAT% >> gambuild-C.bat
echo set PKG_CONFIG^=%PKG_CONFIG_BAT% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set FLAGS_OBJ^=%FLAGS_OBJ_BAT% >> gambuild-C.bat
echo set FLAGS_DYN^=%FLAGS_DYN_BAT% >> gambuild-C.bat
echo set FLAGS_LIB^=%FLAGS_LIB_BAT% >> gambuild-C.bat
echo set FLAGS_EXE^=%FLAGS_EXE_BAT% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set FLAGS_OPT^=%FLAGS_OPT_BAT% >> gambuild-C.bat
echo set FLAGS_OPT_RTS^=%FLAGS_OPT_RTS_BAT% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set DEFS_OBJ^=%DEFS_OBJ_BAT% >> gambuild-C.bat
echo set DEFS_DYN^=%DEFS_DYN_BAT% >> gambuild-C.bat
echo set DEFS_LIB^=%DEFS_LIB_BAT% >> gambuild-C.bat
echo set DEFS_EXE^=%DEFS_EXE_BAT% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set BUILD_OBJ^=%BUILD_OBJ_BAT% >> gambuild-C.bat
echo set BUILD_DYN^=%BUILD_DYN_BAT% >> gambuild-C.bat
echo set BUILD_LIB^=%BUILD_LIB_BAT% >> gambuild-C.bat
echo set BUILD_EXE^=%BUILD_EXE_BAT% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set DEFS^=%DEFS_BAT% >> gambuild-C.bat
echo set LIBS^=%LIBS_BAT% >> gambuild-C.bat
echo set GAMBITLIB^=%GAMBITLIB_BAT% >> gambuild-C.bat
echo set GAMBITGSCLIB^=%GAMBITGSCLIB_BAT% >> gambuild-C.bat
echo set GAMBITGSILIB^=%GAMBITGSILIB_BAT% >> gambuild-C.bat
echo set LIB_PREFIX^=%LIB_PREFIX_BAT% >> gambuild-C.bat
echo set LIB_EXTENSION^=%LIB_EXTENSION_BAT% >> gambuild-C.bat
echo set OBJ_EXTENSION^=%OBJ_EXTENSION_BAT% >> gambuild-C.bat
echo set EXE_EXTENSION^=%EXE_EXTENSION_BAT% >> gambuild-C.bat
echo set BAT_EXTENSION^=%BAT_EXTENSION_BAT% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set ALL_BUILD_FEATURES^=%ALL_BUILD_FEATURES_BAT% >> gambuild-C.bat
echo set BUILD_FEATURE_C_COMP^=%BUILD_FEATURE_C_COMP_BAT% >> gambuild-C.bat
echo set BUILD_FEATURE_OS^=windows >> gambuild-C.bat
echo. >> gambuild-C.bat
echo goto :select_operation >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Creation of a fresh temporary directory >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :create_temp_dir >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set /a _temp_dir_seqnum^=0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :create_temp_dir_loop >> gambuild-C.bat
echo set /a _temp_dir_seqnum+^=1 >> gambuild-C.bat
echo set "_temp_dir=!temp!\!_temp_dir_basename!_dir!_temp_dir_seqnum!" >> gambuild-C.bat
echo mkdir "!_temp_dir!" 2^> nul >> gambuild-C.bat
echo if ERRORLEVEL 1 goto :create_temp_dir_loop >> gambuild-C.bat
echo. >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Creation of a temporary batch file >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :create_temp_batch_file >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :create_temp_dir >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_temp_batch_file=!_temp_dir!\gambuild-C-cmd.bat" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo echo.^!_temp_batch_file_line1^! ^> "!_temp_batch_file!" >> gambuild-C.bat
echo echo.^!_temp_batch_file_line2^! ^>^> "!_temp_batch_file!" >> gambuild-C.bat
echo echo.^!_temp_batch_file_line3^! ^>^> "!_temp_batch_file!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Evaluation of a shell command >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_shell_command >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if not "!GAMBUILD_VERBOSE!" == "yes" goto not_verbose >> gambuild-C.bat
echo echo.^!_shell_command^! >> gambuild-C.bat
echo :not_verbose >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_temp_batch_file_line1=@echo off" >> gambuild-C.bat
echo set "_temp_batch_file_line2=!_shell_command!" >> gambuild-C.bat
echo set "_temp_batch_file_line3=exit /b %%%%ERRORLEVEL%%%%" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :create_temp_batch_file >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call "!_temp_batch_file!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_errorlevel=%%ERRORLEVEL%%" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rmdir /s /q "!_temp_dir!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Encoding of strings and paths using shell syntax >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :shell_string_encode >> gambuild-C.bat
echo if defined _arg ^( >> gambuild-C.bat
echo.  set "_arg=!_arg:=""!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=\!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=^!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=&!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=|!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=>!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=<!" >> gambuild-C.bat
echo.  set "_arg=!_arg:= !" >> gambuild-C.bat
echo.  set "_arg="!_arg!"" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.  set "_arg=" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :simple_string_encode >> gambuild-C.bat
echo if defined _arg ^( >> gambuild-C.bat
echo.  set ^"_arg^=!_arg:^="!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=\!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=^!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=&!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=|!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=>!" >> gambuild-C.bat
echo.  set "_arg=!_arg:=<!" >> gambuild-C.bat
echo.  set "_arg=!_arg:= !" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.  set "_arg=" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem S-expression string syntax decoding >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :sexpr_string_decode >> gambuild-C.bat
echo set "_arg=!_arg: =!" >> gambuild-C.bat
echo set "_arg=!_arg:<=!" >> gambuild-C.bat
echo set "_arg=!_arg:>=!" >> gambuild-C.bat
echo set "_arg=!_arg:|=!" >> gambuild-C.bat
echo set "_arg=!_arg:&=!" >> gambuild-C.bat
echo set "_arg=!_arg:^=!" >> gambuild-C.bat
echo set "_arg=!_arg:\\=!" >> gambuild-C.bat
echo set ^"_arg^=!_arg:\"=!" >> gambuild-C.bat
echo set "_arg=!_arg:\\a=!" >> gambuild-C.bat
echo set "_arg=!_arg:\\t=!" >> gambuild-C.bat
echo set "_arg=!_arg:\\v=!" >> gambuild-C.bat
echo set "_arg=!_arg:\\f=!" >> gambuild-C.bat
echo set "_arg=!_arg:\=!" >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Plain string decoding >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :plain_string_decode >> gambuild-C.bat
echo set "_arg=!_arg: =!" >> gambuild-C.bat
echo set "_arg=!_arg:<=!" >> gambuild-C.bat
echo set "_arg=!_arg:>=!" >> gambuild-C.bat
echo set "_arg=!_arg:|=!" >> gambuild-C.bat
echo set "_arg=!_arg:&=!" >> gambuild-C.bat
echo set "_arg=!_arg:^=!" >> gambuild-C.bat
echo set "_arg=!_arg:\=!" >> gambuild-C.bat
echo set ^"_arg^=!_arg:"=!" >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Guard expression evaluation >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_sexpr >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set ^"_sexpr_string1^=!_sexpr:*"=!" >> gambuild-C.bat
echo set ^"_sexpr_string2^=!_sexpr_string1:*"=!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "!_sexpr_string2!" ^=^= "" goto :eval_sexpr_done >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if not "!_sexpr_string2!" ^=^= ^"^)^" goto :eval_sexpr_unsupported_expr >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set ^"_sexpr^=^)^( !_sexpr:)= )!^" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo for %%%%i in ^(%%ALL_BUILD_FEATURES%%^) do ^( >> gambuild-C.bat
echo.  set "_val=#f" >> gambuild-C.bat
echo.  if "%%%%i" ^=^= "%%BUILD_FEATURE_C_COMP%%"  set "_val=#t" >> gambuild-C.bat
echo.  if "%%%%i" ^=^= "%%BUILD_FEATURE_OS%%" set "_val=#t" >> gambuild-C.bat
echo.  call :eval_sexpr_substitute_var %%%%i ^!_val! >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_sexpr_loop >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_prev=!_sexpr!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(and #t =(and !" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(and #f #t =(and #f !" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(and #f #f =(and #f !" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(and #f )=#f!" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(and )=#t!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(or #f =(or !" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(or #t #t =(or #t !" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(or #t #f =(or #t !" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(or #t )=#t!" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(or )=#f!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(not #t )=#f!" >> gambuild-C.bat
echo set "_sexpr=!_sexpr:(not #f )=#t!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if not "!_sexpr!" ^=^= "!_prev!" goto :eval_sexpr_loop >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if not "!_sexpr!" ^=^= "!_sexpr:)( (when #t =!" goto :eval_sexpr_when_true >> gambuild-C.bat
echo if not "!_sexpr!" ^=^= ^"!_sexpr:^)^( ^(when #f ^=!^" set ^"_sexpr=^)^( !^" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_sexpr_unsupported_expr >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_sexpr=unsupported expression" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_sexpr_when_true >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set ^"_sexpr^="!_sexpr_string1:")=!"" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_sexpr_done >> gambuild-C.bat
echo. >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :eval_sexpr_substitute_var >> gambuild-C.bat
echo set "_sexpr=!_sexpr: %%1 = %%2 !" >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :for_each_line_of_var >> gambuild-C.bat
echo for /f "tokens=1* delims==" %%%%i in ^('set %%for_each_line_of_var_var%%'^) do ^( >> gambuild-C.bat
echo.  if not "%%%%j" == "" ^( >> gambuild-C.bat
echo.    set "_arg=%%%%j" >> gambuild-C.bat
echo.    call %%for_each_line_of_var_handle%% >> gambuild-C.bat
echo.    goto :for_each_line_of_var_continue >> gambuild-C.bat
echo.  ^) >> gambuild-C.bat
echo.  goto :for_each_line_of_var_done >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo :for_each_line_of_var_done >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo :for_each_line_of_var_continue >> gambuild-C.bat
echo for /f "delims= skip=1" %%%%i in ^('set %%for_each_line_of_var_var%%'^) do ^( >> gambuild-C.bat
echo.  set "_arg=%%%%i" >> gambuild-C.bat
echo.  call %%for_each_line_of_var_handle%% >> gambuild-C.bat
echo.  if not "!_errorlevel!" ^=^= "0" goto :for_each_line_of_var_done2 >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo :for_each_line_of_var_done2 >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :for_each_meta_info_of_file >> gambuild-C.bat
echo for /f "delims=# tokens=2*" %%%%i in ^('findstr /r /c:^^"^^^ ^#^|^\^*^/^\^"^^\^^*^^/^^\^^"%%for_each_meta_info_of_file_key%%^|^#^" "%%for_each_meta_info_of_file_file%%"'^) do ^( >> gambuild-C.bat
echo.   set "_arg=%%%%j" >> gambuild-C.bat
echo.   call :for_each_meta_info_of_file_filter >> gambuild-C.bat
echo.   if not "!_errorlevel!" ^=^= "0" goto :for_each_meta_info_of_file_done >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo :for_each_meta_info_of_file_done >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :for_each_meta_info_of_file_filter >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_meta_info=!_arg!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :sexpr_string_decode >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_sexpr=!_arg:= !" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :eval_sexpr >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "!_sexpr!" ^=^= "" goto :for_each_meta_info_of_file_done >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "!_sexpr!" ^=^= "unsupported expression" ^( >> gambuild-C.bat
echo.  echo.*** WARNING -- unsupported meta-info is being ignored: !_meta_info! >> gambuild-C.bat
echo.  goto :for_each_meta_info_of_file_done >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_arg=!_sexpr: =!" >> gambuild-C.bat
echo set ^"_arg^=!_sexpr:"=!" >> gambuild-C.bat
echo call %%for_each_meta_info_of_file_handle%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :for_each_meta_info_of_file_done >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :augment_pkg_config_path_from_files >> gambuild-C.bat
echo set "for_each_meta_info_of_file_file=%%_arg%%" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_key=pkg-config-path" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_handle=:accumulate_pkg_config_path" >> gambuild-C.bat
echo call :for_each_meta_info_of_file >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :augment_pkg_config_path_from_var >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :accumulate_pkg_config_path >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_pkg_config_from_files >> gambuild-C.bat
echo set "for_each_meta_info_of_file_file=%%_arg%%" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_key=pkg-config" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_handle=:process_pkg_config" >> gambuild-C.bat
echo call :for_each_meta_info_of_file >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_pkg_config_from_var >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :process_pkg_config >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_pkg_config >> gambuild-C.bat
echo set "pc_args=%%_arg%%" >> gambuild-C.bat
echo if defined PKG_CONFIG goto pkg_config_defined >> gambuild-C.bat
echo echo.*** WARNING -- the pkg-config program is unavailable but is needed to get C compiler options using 'pkg-config --cflags %%pc_args%%' and 'pkg-config --libs %%pc_args%%' >> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat
echo :pkg_config_defined >> gambuild-C.bat
echo %%PKG_CONFIG%% --cflags %%pc_args%% ^> nul >> gambuild-C.bat
echo set "_errorlevel=%%ERRORLEVEL%%" >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :process_pkg_config_done >> gambuild-C.bat
echo for /f "delims=" %%%%i in ^('%%PKG_CONFIG%% --cflags %%pc_args%%'^) do ^( >> gambuild-C.bat
echo.   set "_arg=%%%%i" >> gambuild-C.bat
echo.   call :plain_string_decode >> gambuild-C.bat
echo.   call :accumulate_cc_options >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :process_pkg_config_done >> gambuild-C.bat
echo %%PKG_CONFIG%% --libs %%pc_args%% ^> nul >> gambuild-C.bat
echo set "_errorlevel=%%ERRORLEVEL%%" >> gambuild-C.bat
echo for /f "delims=" %%%%i in ^('%%PKG_CONFIG%% --libs %%pc_args%%'^) do ^( >> gambuild-C.bat
echo.   set "_arg=%%%%i" >> gambuild-C.bat
echo.   call :plain_string_decode >> gambuild-C.bat
echo.   call :accumulate_ld_options >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo :process_pkg_config_done >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_cc_ld_options_from_files >> gambuild-C.bat
echo set "for_each_meta_info_of_file_file=%%_arg%%" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_key=cc-options" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_handle=:process_cc_options" >> gambuild-C.bat
echo call :for_each_meta_info_of_file >> gambuild-C.bat
echo set "for_each_meta_info_of_file_key=ld-options-prelude" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_handle=:process_ld_options_prelude" >> gambuild-C.bat
echo call :for_each_meta_info_of_file >> gambuild-C.bat
echo set "for_each_meta_info_of_file_key=ld-options" >> gambuild-C.bat
echo set "for_each_meta_info_of_file_handle=:process_ld_options" >> gambuild-C.bat
echo call :for_each_meta_info_of_file >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_cc_options >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :accumulate_cc_options >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_ld_options_prelude >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :accumulate_ld_options_prelude >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :process_ld_options >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :accumulate_ld_options >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :accumulate_pkg_config_path >> gambuild-C.bat
echo if defined GAMBUILD_PKG_CONFIG_PATH ^( >> gambuild-C.bat
echo.   rem prepend path so that last path added has priority >> gambuild-C.bat
echo.   set "GAMBUILD_PKG_CONFIG_PATH=!_arg!;!GAMBUILD_PKG_CONFIG_PATH!" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.   set "GAMBUILD_PKG_CONFIG_PATH=!_arg!" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :accumulate_cc_options >> gambuild-C.bat
echo if defined GAMBUILD_CC_OPTIONS ^( >> gambuild-C.bat
echo.   set "GAMBUILD_CC_OPTIONS=!GAMBUILD_CC_OPTIONS! !_arg!" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.   set "GAMBUILD_CC_OPTIONS=!_arg!" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :accumulate_ld_options_prelude >> gambuild-C.bat
echo if defined GAMBUILD_LD_OPTIONS_PRELUDE ^( >> gambuild-C.bat
echo.   set "GAMBUILD_LD_OPTIONS_PRELUDE=!GAMBUILD_LD_OPTIONS_PRELUDE! !_arg!" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.   set "GAMBUILD_LD_OPTIONS_PRELUDE=!_arg!" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :accumulate_ld_options >> gambuild-C.bat
echo if defined GAMBUILD_LD_OPTIONS ^( >> gambuild-C.bat
echo.   set "GAMBUILD_LD_OPTIONS=!GAMBUILD_LD_OPTIONS! !_arg!" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.   set "GAMBUILD_LD_OPTIONS=!_arg!" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :accumulate_input_filenames >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :simple_string_encode >> gambuild-C.bat
echo if defined GAMBUILD_INPUT_FILENAMES ^( >> gambuild-C.bat
echo.   set "GAMBUILD_INPUT_FILENAMES=!GAMBUILD_INPUT_FILENAMES! "!_arg!"" >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.   set "GAMBUILD_INPUT_FILENAMES="!_arg!"" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :accumulate_output_filename >> gambuild-C.bat
echo call :plain_string_decode >> gambuild-C.bat
echo call :simple_string_encode >> gambuild-C.bat
echo set "GAMBUILD_OUTPUT_FILENAME=!_arg!" >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :prepare_params >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem ---------------------------------------------------------------------- >> gambuild-C.bat
echo rem Augment PKG_CONFIG_PATH with the meta information from files in >> gambuild-C.bat
echo rem META_INFO_FILE_PARAM and the paths in PKG_CONFIG_PATH_PARAM. >> gambuild-C.bat
echo rem ---------------------------------------------------------------------- >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "GAMBUILD_CC_OPTIONS=" >> gambuild-C.bat
echo set "GAMBUILD_LD_OPTIONS_PRELUDE=" >> gambuild-C.bat
echo set "GAMBUILD_LD_OPTIONS=" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if defined PKG_CONFIG_PATH ^( >> gambuild-C.bat
echo.   set "_arg=!PKG_CONFIG_PATH!" >> gambuild-C.bat
echo.   call :plain_string_decode >> gambuild-C.bat
echo ^) else ^( >> gambuild-C.bat
echo.   set "_arg=" >> gambuild-C.bat
echo ^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "GAMBUILD_PKG_CONFIG_PATH=!_arg!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process META_INFO_FILE_PARAM ^(actual variable name in %%1^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%1" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:augment_pkg_config_path_from_files" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process PKG_CONFIG_PATH_PARAM ^(actual variable name in %%3^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%3" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:augment_pkg_config_path_from_var" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if not defined GAMBUILD_PKG_CONFIG_PATH goto :done_pkg_config_path >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set _arg=!GAMBUILD_PKG_CONFIG_PATH! >> gambuild-C.bat
echo call :simple_string_encode >> gambuild-C.bat
echo set "PKG_CONFIG_PATH=!_arg!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :done_pkg_config_path >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem ---------------------------------------------------------------------- >> gambuild-C.bat
echo rem Use the meta information from files in META_INFO_FILE_PARAM and >> gambuild-C.bat
echo rem the package names in PKG_CONFIG_PATH to call pkg-config to >> gambuild-C.bat
echo rem accumulate C compiler and linker options. >> gambuild-C.bat
echo rem ---------------------------------------------------------------------- >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process META_INFO_FILE_PARAM ^(actual variable name in %%1^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%1" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:process_pkg_config_from_files" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :prepare_params_done >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process PKG_CONFIG_PARAM ^(actual variable name in %%2^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%2" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:process_pkg_config_from_var" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :prepare_params_done >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem ---------------------------------------------------------------------- >> gambuild-C.bat
echo rem Use the meta information from files in META_INFO_FILE_PARAM to >> gambuild-C.bat
echo rem accumulate C compiler and linker options from cc-options, >> gambuild-C.bat
echo rem ld-options-prelude and ld-options. >> gambuild-C.bat
echo rem ---------------------------------------------------------------------- >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process META_INFO_FILE_PARAM ^(actual variable name in %%1^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%1" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:process_cc_ld_options_from_files" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%4" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:process_cc_options" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%5" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:process_ld_options_prelude" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%6" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:process_ld_options" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_arg=!GAMBUILD_CC_OPTIONS!" >> gambuild-C.bat
echo call :simple_string_encode >> gambuild-C.bat
echo set "GAMBUILD_CC_OPTIONS=!_arg!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_arg=!GAMBUILD_LD_OPTIONS_PRELUDE!" >> gambuild-C.bat
echo call :simple_string_encode >> gambuild-C.bat
echo set "GAMBUILD_LD_OPTIONS_PRELUDE=!_arg!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_arg=!GAMBUILD_LD_OPTIONS!" >> gambuild-C.bat
echo call :simple_string_encode >> gambuild-C.bat
echo set "GAMBUILD_LD_OPTIONS=!_arg!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process INPUT_FILENAMES_PARAM ^(actual variable name in %%4^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "GAMBUILD_INPUT_FILENAMES=" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%7" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:accumulate_input_filenames" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo rem Process OUTPUT_FILENAME_PARAM ^(actual variable name in %%5^) >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "GAMBUILD_OUTPUT_FILENAME=" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "for_each_line_of_var_var=%%8" >> gambuild-C.bat
echo set "for_each_line_of_var_handle=:accumulate_output_filename" >> gambuild-C.bat
echo call :for_each_line_of_var >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :prepare_params_done >> gambuild-C.bat
echo. >> gambuild-C.bat
echo exit /b %%_errorlevel%% >> gambuild-C.bat
echo. >> gambuild-C.bat
echo. >> gambuild-C.bat
echo :select_operation >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "obj" goto obj >> gambuild-C.bat
echo if not "%%1" ^=^= ""obj"" goto not_obj >> gambuild-C.bat
echo :obj >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "BUILD_OBJ_LD_OPTIONS_PRELUDE_PARAM= " >> gambuild-C.bat
echo set "BUILD_OBJ_LD_OPTIONS_PARAM= " >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :prepare_params BUILD_OBJ_META_INFO_FILE_PARAM BUILD_OBJ_PKG_CONFIG_PARAM BUILD_OBJ_PKG_CONFIG_PATH_PARAM BUILD_OBJ_CC_OPTIONS_PARAM BUILD_OBJ_LD_OPTIONS_PRELUDE_PARAM BUILD_OBJ_LD_OPTIONS_PARAM BUILD_OBJ_INPUT_FILENAMES_PARAM BUILD_OBJ_OUTPUT_FILENAME_PARAM >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :end >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "BUILD_OBJ_CC_OPTIONS_PARAM=!GAMBUILD_CC_OPTIONS!" >> gambuild-C.bat
echo set "BUILD_OBJ_INPUT_FILENAMES_PARAM=!GAMBUILD_INPUT_FILENAMES!" >> gambuild-C.bat
echo set "BUILD_OBJ_OUTPUT_FILENAME_PARAM=!GAMBUILD_OUTPUT_FILENAME!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_shell_command=%BUILD_OBJ_ECHO_BAT%" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :eval_shell_command >> gambuild-C.bat
echo. >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_obj >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "dyn" goto dyn >> gambuild-C.bat
echo if not "%%1" ^=^= ""dyn"" goto not_dyn >> gambuild-C.bat
echo :dyn >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :prepare_params BUILD_DYN_META_INFO_FILE_PARAM BUILD_DYN_PKG_CONFIG_PARAM BUILD_DYN_PKG_CONFIG_PATH_PARAM BUILD_DYN_CC_OPTIONS_PARAM BUILD_DYN_LD_OPTIONS_PRELUDE_PARAM BUILD_DYN_LD_OPTIONS_PARAM BUILD_DYN_INPUT_FILENAMES_PARAM BUILD_DYN_OUTPUT_FILENAME_PARAM >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :end >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "BUILD_DYN_CC_OPTIONS_PARAM=!GAMBUILD_CC_OPTIONS!" >> gambuild-C.bat
echo set "BUILD_DYN_LD_OPTIONS_PRELUDE_PARAM=!GAMBUILD_LD_OPTIONS_PRELUDE!" >> gambuild-C.bat
echo set "BUILD_DYN_LD_OPTIONS_PARAM=!GAMBUILD_LD_OPTIONS!" >> gambuild-C.bat
echo set "BUILD_DYN_INPUT_FILENAMES_PARAM=!GAMBUILD_INPUT_FILENAMES!" >> gambuild-C.bat
echo set "BUILD_DYN_OUTPUT_FILENAME_PARAM=!GAMBUILD_OUTPUT_FILENAME!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_shell_command=%BUILD_DYN_ECHO_BAT%" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :eval_shell_command >> gambuild-C.bat
echo. >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_dyn >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "lib" goto lib >> gambuild-C.bat
echo if not "%%1" ^=^= ""lib"" goto not_lib >> gambuild-C.bat
echo :lib >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_shell_command^=%BUILD_LIB_ECHO_BAT%" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :eval_shell_command >> gambuild-C.bat
echo. >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_lib >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "exe" goto exe >> gambuild-C.bat
echo if not "%%1" ^=^= ""exe"" goto not_exe >> gambuild-C.bat
echo :exe >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :prepare_params BUILD_EXE_META_INFO_FILE_PARAM BUILD_EXE_PKG_CONFIG_PARAM BUILD_EXE_PKG_CONFIG_PATH_PARAM BUILD_EXE_CC_OPTIONS_PARAM BUILD_EXE_LD_OPTIONS_PRELUDE_PARAM BUILD_EXE_LD_OPTIONS_PARAM BUILD_EXE_INPUT_FILENAMES_PARAM BUILD_EXE_OUTPUT_FILENAME_PARAM >> gambuild-C.bat
echo if not "%%_errorlevel%%" ^=^= "0" goto :end >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "BUILD_EXE_CC_OPTIONS_PARAM=!GAMBUILD_CC_OPTIONS!" >> gambuild-C.bat
echo set "BUILD_EXE_LD_OPTIONS_PRELUDE_PARAM=!GAMBUILD_LD_OPTIONS_PRELUDE!" >> gambuild-C.bat
echo set "BUILD_EXE_LD_OPTIONS_PARAM=!GAMBUILD_LD_OPTIONS!" >> gambuild-C.bat
echo set "BUILD_EXE_INPUT_FILENAMES_PARAM=!GAMBUILD_INPUT_FILENAMES!" >> gambuild-C.bat
echo set "BUILD_EXE_OUTPUT_FILENAME_PARAM=!GAMBUILD_OUTPUT_FILENAME!" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo set "_shell_command=%BUILD_EXE_ECHO_BAT%" >> gambuild-C.bat
echo. >> gambuild-C.bat
echo call :eval_shell_command >> gambuild-C.bat
echo. >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_exe >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "C_COMPILER" goto C_COMPILER >> gambuild-C.bat
echo if not "%%1" ^=^= ""C_COMPILER"" goto not_C_COMPILER >> gambuild-C.bat
echo :C_COMPILER >> gambuild-C.bat
echo echo.%%C_COMPILER%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_C_COMPILER >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "C_PREPROC" goto C_PREPROC >> gambuild-C.bat
echo if not "%%1" ^=^= ""C_PREPROC"" goto not_C_PREPROC >> gambuild-C.bat
echo :C_PREPROC >> gambuild-C.bat
echo echo.%%C_PREPROC%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_C_PREPROC >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "PKG_CONFIG" goto PKG_CONFIG >> gambuild-C.bat
echo if not "%%1" ^=^= ""PKG_CONFIG"" goto not_PKG_CONFIG >> gambuild-C.bat
echo :PKG_CONFIG >> gambuild-C.bat
echo echo.%%PKG_CONFIG%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_PKG_CONFIG >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "FLAGS_OBJ" goto FLAGS_OBJ >> gambuild-C.bat
echo if not "%%1" ^=^= ""FLAGS_OBJ"" goto not_FLAGS_OBJ >> gambuild-C.bat
echo :FLAGS_OBJ >> gambuild-C.bat
echo echo.%%FLAGS_OBJ%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_FLAGS_OBJ >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "FLAGS_DYN" goto FLAGS_DYN >> gambuild-C.bat
echo if not "%%1" ^=^= ""FLAGS_DYN"" goto not_FLAGS_DYN >> gambuild-C.bat
echo :FLAGS_DYN >> gambuild-C.bat
echo echo.%%FLAGS_DYN%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_FLAGS_DYN >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "FLAGS_LIB" goto FLAGS_LIB >> gambuild-C.bat
echo if not "%%1" ^=^= ""FLAGS_LIB"" goto not_FLAGS_LIB >> gambuild-C.bat
echo :FLAGS_LIB >> gambuild-C.bat
echo echo.%%FLAGS_LIB%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_FLAGS_LIB >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "FLAGS_EXE" goto FLAGS_EXE >> gambuild-C.bat
echo if not "%%1" ^=^= ""FLAGS_EXE"" goto not_FLAGS_EXE >> gambuild-C.bat
echo :FLAGS_EXE >> gambuild-C.bat
echo echo.%%FLAGS_EXE%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_FLAGS_EXE >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "FLAGS_OPT" goto FLAGS_OPT >> gambuild-C.bat
echo if not "%%1" ^=^= ""FLAGS_OPT"" goto not_FLAGS_OPT >> gambuild-C.bat
echo :FLAGS_OPT >> gambuild-C.bat
echo echo.%%FLAGS_OPT%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_FLAGS_OPT >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "FLAGS_OPT_RTS" goto FLAGS_OPT_RTS >> gambuild-C.bat
echo if not "%%1" ^=^= ""FLAGS_OPT_RTS"" goto not_FLAGS_OPT_RTS >> gambuild-C.bat
echo :FLAGS_OPT_RTS >> gambuild-C.bat
echo echo.%%FLAGS_OPT_RTS%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_FLAGS_OPT_RTS >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "DEFS_OBJ" goto DEFS_OBJ >> gambuild-C.bat
echo if not "%%1" ^=^= ""DEFS_OBJ"" goto not_DEFS_OBJ >> gambuild-C.bat
echo :DEFS_OBJ >> gambuild-C.bat
echo echo.%%DEFS_OBJ%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_DEFS_OBJ >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "DEFS_DYN" goto DEFS_DYN >> gambuild-C.bat
echo if not "%%1" ^=^= ""DEFS_DYN"" goto not_DEFS_DYN >> gambuild-C.bat
echo :DEFS_DYN >> gambuild-C.bat
echo echo.%%DEFS_DYN%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_DEFS_DYN >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "DEFS_LIB" goto DEFS_LIB >> gambuild-C.bat
echo if not "%%1" ^=^= ""DEFS_LIB"" goto not_DEFS_LIB >> gambuild-C.bat
echo :DEFS_LIB >> gambuild-C.bat
echo echo.%%DEFS_LIB%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_DEFS_LIB >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "DEFS_EXE" goto DEFS_EXE >> gambuild-C.bat
echo if not "%%1" ^=^= ""DEFS_EXE"" goto not_DEFS_EXE >> gambuild-C.bat
echo :DEFS_EXE >> gambuild-C.bat
echo echo.%%DEFS_EXE%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_DEFS_EXE >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "BUILD_OBJ" goto BUILD_OBJ >> gambuild-C.bat
echo if not "%%1" ^=^= ""BUILD_OBJ"" goto not_BUILD_OBJ >> gambuild-C.bat
echo :BUILD_OBJ >> gambuild-C.bat
echo echo.%%BUILD_OBJ%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_BUILD_OBJ >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "BUILD_DYN" goto BUILD_DYN >> gambuild-C.bat
echo if not "%%1" ^=^= ""BUILD_DYN"" goto not_BUILD_DYN >> gambuild-C.bat
echo :BUILD_DYN >> gambuild-C.bat
echo echo.%%BUILD_DYN%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_BUILD_DYN >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "BUILD_LIB" goto BUILD_LIB >> gambuild-C.bat
echo if not "%%1" ^=^= ""BUILD_LIB"" goto not_BUILD_LIB >> gambuild-C.bat
echo :BUILD_LIB >> gambuild-C.bat
echo echo.%%BUILD_LIB%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_BUILD_LIB >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "BUILD_EXE" goto BUILD_EXE >> gambuild-C.bat
echo if not "%%1" ^=^= ""BUILD_EXE"" goto not_BUILD_EXE >> gambuild-C.bat
echo :BUILD_EXE >> gambuild-C.bat
echo echo.%%BUILD_EXE%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_BUILD_EXE >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "DEFS" goto DEFS >> gambuild-C.bat
echo if not "%%1" ^=^= ""DEFS"" goto not_DEFS >> gambuild-C.bat
echo :DEFS >> gambuild-C.bat
echo echo.%%DEFS%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_DEFS >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "LIBS" goto LIBS >> gambuild-C.bat
echo if not "%%1" ^=^= ""LIBS"" goto not_LIBS >> gambuild-C.bat
echo :LIBS >> gambuild-C.bat
echo echo.%%LIBS%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_LIBS >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "GAMBITLIB_DEFS" goto GAMBITLIB_DEFS >> gambuild-C.bat
echo if not "%%1" ^=^= ""GAMBITLIB_DEFS"" goto not_GAMBITLIB_DEFS >> gambuild-C.bat
echo :GAMBITLIB_DEFS >> gambuild-C.bat
echo echo.%%GAMBITLIB_DEFS%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_GAMBITLIB_DEFS >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "GAMBITLIB" goto GAMBITLIB >> gambuild-C.bat
echo if not "%%1" ^=^= ""GAMBITLIB"" goto not_GAMBITLIB >> gambuild-C.bat
echo :GAMBITLIB >> gambuild-C.bat
echo echo.%%GAMBITLIB%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_GAMBITLIB >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "GAMBITGSCLIB" goto GAMBITGSCLIB >> gambuild-C.bat
echo if not "%%1" ^=^= ""GAMBITGSCLIB"" goto not_GAMBITGSCLIB >> gambuild-C.bat
echo :GAMBITGSCLIB >> gambuild-C.bat
echo echo.%%GAMBITGSCLIB%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_GAMBITGSCLIB >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "GAMBITGSILIB" goto GAMBITGSILIB >> gambuild-C.bat
echo if not "%%1" ^=^= ""GAMBITGSILIB"" goto not_GAMBITGSILIB >> gambuild-C.bat
echo :GAMBITGSILIB >> gambuild-C.bat
echo echo.%%GAMBITGSILIB%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_GAMBITGSILIB >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "LIB_PREFIX" goto LIB_PREFIX >> gambuild-C.bat
echo if not "%%1" ^=^= ""LIB_PREFIX"" goto not_LIB_PREFIX >> gambuild-C.bat
echo :LIB_PREFIX >> gambuild-C.bat
echo echo.%%LIB_PREFIX%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_LIB_PREFIX >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "LIB_EXTENSION" goto LIB_EXTENSION >> gambuild-C.bat
echo if not "%%1" ^=^= ""LIB_EXTENSION"" goto not_LIB_EXTENSION >> gambuild-C.bat
echo :LIB_EXTENSION >> gambuild-C.bat
echo echo.%%LIB_EXTENSION%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_LIB_EXTENSION >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "OBJ_EXTENSION" goto OBJ_EXTENSION >> gambuild-C.bat
echo if not "%%1" ^=^= ""OBJ_EXTENSION"" goto not_OBJ_EXTENSION >> gambuild-C.bat
echo :OBJ_EXTENSION >> gambuild-C.bat
echo echo.%%OBJ_EXTENSION%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_OBJ_EXTENSION >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "EXE_EXTENSION" goto EXE_EXTENSION >> gambuild-C.bat
echo if not "%%1" ^=^= ""EXE_EXTENSION"" goto not_EXE_EXTENSION >> gambuild-C.bat
echo :EXE_EXTENSION >> gambuild-C.bat
echo echo.%%EXE_EXTENSION%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_EXE_EXTENSION >> gambuild-C.bat
echo. >> gambuild-C.bat
echo if "%%1" ^=^= "BAT_EXTENSION" goto BAT_EXTENSION >> gambuild-C.bat
echo if not "%%1" ^=^= ""BAT_EXTENSION"" goto not_BAT_EXTENSION >> gambuild-C.bat
echo :BAT_EXTENSION >> gambuild-C.bat
echo echo.%%BAT_EXTENSION%% >> gambuild-C.bat
echo goto end >> gambuild-C.bat
echo :not_BAT_EXTENSION >> gambuild-C.bat
echo. >> gambuild-C.bat
echo echo.gambuild-C.bat unknown operation "%%1" >> gambuild-C.bat
echo exit /b 1 >> gambuild-C.bat
echo.>> gambuild-C.bat
echo :end>> gambuild-C.bat
echo exit /b 0 >> gambuild-C.bat

cd ..
