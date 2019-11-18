@echo off
rem File: "vswsl.bat"
rem
rem This is a batch file that configures the Microsoft Visual Studio
rem development tools on Windows 10 and starts a shell in the
rem Windows Subsystem for Linux.  This makes it easier to build Gambit
rem for those accustomed to the unix development tools.
rem
rem You should start a Windows Command Prompt window by clicking on the
rem start menu en entering "cmd" and <return>, then:
rem
rem    cd gambit
rem    misc\vswsl
rem    ./configure
rem    make

echo.
echo.Preparing Microsoft Visual Studio with Windows Subsystem for Linux shell...
echo.

rem You may have to change the variables _VSVERSION and _VSOFFERING:

rem set "_VSVERSION=2017"
set "_VSVERSION=2019"
rem set "_VSOFFERING=Community"
set "_VSOFFERING=Enterprise"

rem Configure Microsoft Visual Studio development tools:

set "_VSDIR=C:\Program Files (x86)\Microsoft Visual Studio\%_VSVERSION%\%_VSOFFERING%"
set "_VSDEVCMDDIR=%_VSDIR%\Common7\Tools"
set "_VSDEVCMD=VsDevCmd.bat"

call "%_VSDEVCMDDIR%\%_VSDEVCMD%" -arch=amd64

rem Start a Linux shell

wsl
