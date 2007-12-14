@rem File: "vcexpress.bat"
@rem
@rem This is a batch file to compile Gambit with the Microsoft Visual
@rem C++ 2005 Express Edition which can be obtained at no charge from
@rem Microsoft at this URL:
@rem http://msdn.microsoft.com/vstudio/express/downloads/default.aspx .
@rem You must also install the Microsoft Platform SDK.
@rem
@rem TODO: turn this into a makefile

@rem Setup environment variables

@call "C:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"
@call "C:\Program Files\Microsoft Platform SDK for Windows Server 2003 R2\SetEnv.Cmd"

@IF "%1%" == "" (
SET GAMBCDIR="C:/Gambit-C/././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././././."
) ELSE (
SET GAMBCDIR="%1%"
)

@rem We can't use -D___SINGLE_HOST because the C compiler runs out of memory
@rem while compiling _num.c

set COMP_GEN=cl -nologo -Oityb1 -MT -D_CRT_SECURE_NO_DEPRECATE -c -I..\include
set COMP_LIB=%COMP_GEN% -D___PRIMAL -D___LIBRARY -D___GAMBCDIR=\"%GAMBCDIR%\"
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

lib -out:libgambc.lib main.obj setup.obj mem.obj os.obj os_base.obj os_time.obj os_shell.obj os_files.obj os_dyn.obj os_tty.obj os_io.obj c_intf.obj _kernel.obj _system.obj _num.obj _std.obj _eval.obj _io.obj _nonstd.obj _thread.obj _repl.obj _gambc.obj

cd ..

cd gsi

%COMP_LIB% _gsilib.c
%COMP_APP% _gsi.c
%COMP_APP% _gsi_.c

cl -Fegsi.exe ..\lib\libgambc.lib _gsilib.obj _gsi.obj _gsi_.obj Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib

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
%COMP_APP% _gsc.c
%COMP_APP% _gsc_.c

cl -Fegsc.exe ..\lib\libgambc.lib _host.obj _utils.obj _source.obj _parms.obj _env.obj _ptree1.obj _ptree2.obj _gvm.obj _back.obj _front.obj _prims.obj _t-c-1.obj _t-c-2.obj _t-c-3.obj _gsclib.obj _gsc.obj _gsc_.obj Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib

cd ..
