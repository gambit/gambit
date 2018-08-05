/******************************************************************************
 *
 * This script generates an nmake compatible makefile for Microsoft Visual
 * Studio. The generated makefile can be used to build the system from a
 * release of Gambit.  To build from a clone of the github repository
 * some additional tools and steps are needed (see below).
 *
 *
 * Steps to build the system from a release of Gambit:
 *
 * STEP 1 -- Ensure that the Visual Studio tools are in the path
 *
 *   C:\gambit>"C:\Program Files\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat"
nfigure script options
 *
 * STEP 2 -- Run the script using --prefix=... to specify install destination
 *
 *   C:\gambit>cscript misc\configure-vstudio.js --prefix=C:\Gambit
 *
 * STEP 3 -- Use the makefile to build and then install Gambit
 *
 *   C:\gambit>nmake
 *   C:\gambit>nmake install
 *
 * You will now have gsi.exe and gsc.exe in the bin subdirectory of
 * the directory specified with the --prefix option.
 *
 * A Scheme file can be compiled to a standalone .exe with:
 *
 *   C:\gambit>set PATH=C:\Gambit\bin;%PATH%
 *   C:\gambit>gsc -exe hello.scm
 *   C:\gambit>hello
 *   Hello World!
 *   C:\gambit>type hello.scm
 *   (display "Hello World!\n")
 *
 * The script accepts a subset of the configure script options.
 * The supported options are:
 *
 *   --prefix=DIR       dir for default root of bindir, libdir, etc
 *
 *   --bindir=DIR       dir for executables (gsi.exe, gsc.exe, ...)
 *   --libdir=DIR       dir for libraries (libgambit.lib, syntax-case.scm, ...)
 *   --includedir=DIR   dir for C header files (gambit.h, ...)
 *   --docdir=DIR       dir for documentation (gambit.pdf, gambit.html, ...)
 *   --infodir=DIR      dir for info documentation (gambit.info, ...)
 *   --datadir=DIR      dir for arch independent files (gambit.el)
 *
 *   --enable-single-host    compile each Scheme module as a single C function
 *
 *   --enable-c-opt          compile with higher C compiler optimization level
 *
 *   --enable-cplusplus      compile using C++ compiler
 *
 *   --enable-debug          build so system is easier to debug
 *   --enable-debug-log      build so system generates a debugging log file
 *   --enable-debug-ctrl-flow-history  build so system tracks control flow
 *   --enable-debug-host-changes  build so system tracks host changes
 *   --enable-debug-alloc-mem  build so system tracks memory allocations
 *   --enable-debug-garbage-collector  build so system detects GC issues
 *   --enable-activity-log   build so system generates activity log
 *
 *   --enable-char-size=N    Scheme character size in bytes (N = 1, 2 or 4)
 *
 *   --enable-multiple-threaded-vms  support > 1 OS thread per Gambit VM
 *   --enable-max-processors=N  max number of processors per Gambit VM
 *
 *
 * Steps to build the system from a clone of the github repository:
 *
 * STEP 1 -- Install mingw and git if they are not yet installed
 *
 *   - mingw: http://mingw.org/wiki/Getting_Started
 *   - git:   https://git-for-windows.github.io/
 *
 * STEP 2 -- Start a mingw shell and bootstrap the sources with the commands
 *
 *   $ git clone https://github.com/gambit/gambit.git
 *   $ cd gambit
 *   $ ./configure --enable-single-host
 *   $ make -j4 current-gsc-boot
 *   $ make -j4 from-scratch
 *
 * STEP 3 -- Use the steps above to build with Visual Studio
 *
 *****************************************************************************/


// Utilities

function pathExpand(dir,subdir)
{
    if (dir.slice(-1) == "\\")
        return dir + subdir;
    else
        return dir + "\\" + subdir;
}

var fso = new ActiveXObject("Scripting.FileSystemObject")

var gambitRoot = GetGambitRoot(fso);


// Command line arguments processing

var config = {};

function configParamError(param)
{
    WScript.echo("Configure parameter error on \"" + param + "\"");
    WScript.Quit(1);
}

function setConfig(param, val)
{
    config[param] = val;
}

function setFlag(param, val)
{
    if (param.slice(0,9) == "--enable-")
        setConfig(param.slice(9), true);
    else if (param.slice(0,10) == "--disable-")
        setConfig(param.slice(10), false);
    else
        configParamError(param);
}

function setCharSize(param, size)
{
    if (size == "1" || size == "2" || size == "4")
        setConfig("char-size", size);
    else
        configParamError(param);
}

function setMaxProcessors(param, size)
{
    setConfig("max-processors", size);
}

function setDir(param, dir)
{
    if (param.slice(0,2) == "--" && param.slice(-1) == "=")
        setConfig(param.slice(2,-1), dir);
    else
        configParamError(param);
}

var configParamHandlers =
{
    "--prefix="                        : setDir,
    "--bindir="                        : setDir,
    "--libdir="                        : setDir,
    "--includedir="                    : setDir,
    "--docdir="                        : setDir,
    "--infodir="                       : setDir,
    "--datadir="                       : setDir,
    "--enable-single-host"             : setFlag,
    "--disable-single-host"            : setFlag,
    "--enable-c-opt"                   : setFlag,
    "--disable-c-opt"                  : setFlag,
    "--enable-cplusplus"               : setFlag,
    "--disable-cplusplus"              : setFlag,
    "--enable-debug"                   : setFlag,
    "--disable-debug"                  : setFlag,
    "--enable-debug-log"               : setFlag,
    "--disable-debug-log"              : setFlag,
    "--enable-debug-ctrl-flow-history" : setFlag,
    "--disable-debug-ctrl-flow-history": setFlag,
    "--enable-debug-host-changes"      : setFlag,
    "--disable-debug-host-changes"     : setFlag,
    "--enable-debug-alloc-mem"         : setFlag,
    "--disable-debug-alloc-mem"        : setFlag,
    "--enable-debug-garbage-collector" : setFlag,
    "--disable-debug-garbage-collector": setFlag,
    "--enable-activity-log"            : setFlag,
    "--disable-activity-log"           : setFlag,
    "--enable-char-size="              : setCharSize,
    "--enable-multiple-threaded-vms"   : setFlag,
    "--disable-multiple-threaded-vms"  : setFlag,
    "--enable-max-processors="         : setMaxProcessors
};

function ConfigArg(arg)
{
    for (var k in configParamHandlers)
    {
        if (k.slice(-1) == "=")
        {
            if (arg.slice(0, k.length) == k)
            {
                configParamHandlers[k](k, arg.slice(k.length));
                return;
            }
        }
        else
        {
            if (arg == k)
            {
                configParamHandlers[k](k, false);
                return;
            }
        }
    }
    configParamError(arg);
}

function ProcessCommandLine()
{
    var args = WScript.arguments;

    for (var i=0; i<args.length; i++)
        ConfigArg(args(i));
}

function InitConfigDefaults()
{
    // Setup defaults for configuration parameters

    ConfigArg("--prefix=" + "C:\\Program Files\\Gambit");
    ConfigArg("--disable-single-host");
    ConfigArg("--disable-c-opt");
    ConfigArg("--disable-cplusplus");
    ConfigArg("--disable-debug");
    ConfigArg("--disable-debug-log");
    ConfigArg("--disable-debug-ctrl-flow-history");
    ConfigArg("--disable-debug-host-changes");
    ConfigArg("--disable-debug-alloc-mem");
    ConfigArg("--disable-debug-garbage-collector");
    ConfigArg("--disable-activity-log");
    ConfigArg("--enable-char-size=" + "4");
    ConfigArg("--disable-multiple-threaded-vms");
    ConfigArg("--enable-max-processors=" + "64");
}

InitConfigDefaults();

ProcessCommandLine();

// Determine installation directories

var GAMBITDIRS;

function Escape(str)
{
    return "\\\"" + str.replace(/\\/g, "\\\\").replace(/ /g, "\\040") + "\\\"";
}

function AddGambitDir(key, dir, name)
{
    if (config[key])
        GAMBITDIRS += " " + "-D" + name + "=" + Escape(config[key]);
    else
        config[key] = pathExpand(config["prefix"], dir);
}

function SetGambitDirs()
{
    GAMBITDIRS = "-D___GAMBITDIR=" + Escape(config["prefix"]);

    AddGambitDir("bindir",     "bin",     "___GAMBITDIR_BIN");
    AddGambitDir("libdir",     "lib",     "___GAMBITDIR_LIB");
    AddGambitDir("includedir", "include", "___GAMBITDIR_INCLUDE");
    AddGambitDir("docdir",     "doc",     "___GAMBITDIR_DOC");
    AddGambitDir("infodir",    "info",    "___GAMBITDIR_INFO");
    AddGambitDir("datadir",    "share",   "___GAMBITDIR_SHARE");
}

SetGambitDirs();


// Determine susbtitutions for .in files

var DEFS = "";

var CONF_VOIDSTAR_WIDTH = "___LONG_WIDTH";

var CONF_MAX_CHR = "0x10ffff";
switch (config["char-size"])
{
    case "1": CONF_MAX_CHR = "0xff"; break;
    case "2": CONF_MAX_CHR = "0xffff"; break;
}

var CONF_SINGLE_MULTIPLE_VMS = "___SINGLE_VM";

var CONF_SINGLE_MULTIPLE_THREADED_VMS = "___SINGLE_THREADED_VMS";
if (config["multiple-threaded-vms"])
    CONF_SINGLE_MULTIPLE_THREADED_VMS = "___MULTIPLE_THREADED_VMS";

var CONF_THREAD_SYSTEM = "___USE_NO_THREAD_SYSTEM";
if (config["multiple-threaded-vms"])
    CONF_THREAD_SYSTEM = "___USE_WIN32_THREAD_SYSTEM";

var CONF_THREAD_LOCAL_STORAGE_CLASS = "___NO_THREAD_LOCAL_STORAGE_CLASS";
if (config["multiple-threaded-vms"])
    CONF_THREAD_LOCAL_STORAGE_CLASS = "___THREAD_LOCAL_STORAGE_CLASS __declspec(thread)";

var CONF_HAVE_CONDITION_VARIABLE = "___DONT_HAVE_CONDITION_VARIABLE";
if (config["multiple-threaded-vms"])
    CONF_HAVE_CONDITION_VARIABLE = "___HAVE_CONDITION_VARIABLE";

var CONF_MAX_PROCESSORS = "64";
if (config["multiple-threaded-vms"])
    CONF_MAX_PROCESSORS = config["max-processors"];

var CONF_ACTIVITY_LOG = "___NO_ACTIVITY_LOG";
if (config["activity-log"])
    CONF_ACTIVITY_LOG = "___ACTIVITY_LOG";

var CONF_BOOL = "int";
if (config["cplusplus"])
    CONF_BOOL = "bool";


if (config["debug"])
    DEFS += " -D___DEBUG";

if (config["debug-ctrl-flow-history"])
{
    config["debug-log"] = true;
    DEFS += " -D___DEBUG_CTRL_FLOW_HISTORY";
}

if (config["debug-host-changes"])
{
    config["debug-log"] = true;
    DEFS += " -D___DEBUG_HOST_CHANGES";
}

if (config["debug-alloc-mem"])
{
    config["debug-log"] = true;
    DEFS += " -D___DEBUG_ALLOC_MEM";
}

if (config["debug-debug-garbage-collector"])
{
    config["debug-log"] = true;
    DEFS += " -D___DEBUG_GARBAGE_COLLECT";
}

if (config["debug-log"])
    DEFS += " -D___DEBUG_LOG";


function GetCCompiler(sh)
{
    return "cl -nologo"
           + (config["c-opt"] ? " -Oityb2" : " -Oityb1")
           + (config["cplusplus"] ? " -TP" : "")
           + " -Zi -GS -RTC1 -MT -D_CRT_SECURE_NO_DEPRECATE"
           + (sh && config["single-host"] ? " -D___SINGLE_HOST" : "")
           + DEFS;
}


// Process .in files

FixupFile(
    fso,
    gambitRoot + "\\include\\gambit.h.in",
    gambitRoot + "\\include\\gambit.h",
    {
        "CONF_VOIDSTAR_WIDTH":               CONF_VOIDSTAR_WIDTH,
        "CONF_MAX_CHR":                      CONF_MAX_CHR,
        "CONF_SINGLE_MULTIPLE_VMS":          CONF_SINGLE_MULTIPLE_VMS,
        "CONF_SINGLE_MULTIPLE_THREADED_VMS": CONF_SINGLE_MULTIPLE_THREADED_VMS,
        "CONF_THREAD_SYSTEM":                CONF_THREAD_SYSTEM,
        "CONF_THREAD_LOCAL_STORAGE_CLASS":   CONF_THREAD_LOCAL_STORAGE_CLASS,
        "CONF_HAVE_CONDITION_VARIABLE":      CONF_HAVE_CONDITION_VARIABLE,
        "CONF_MAX_PROCESSORS":               CONF_MAX_PROCESSORS,
        "CONF_ACTIVITY_LOG":                 CONF_ACTIVITY_LOG,
        "CONF_BOOL":                         CONF_BOOL,
        "CONF_USE_SIGSET_T":                 "CONF_USE_SIGSET_T"
    });

FixupFile(
    fso,
    gambitRoot + "\\include\\config.h.in",
    gambitRoot + "\\include\\config.h",
    {});

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambcomp-C.bat.windows.in",
    gambitRoot + "\\bin\\gambcomp-C.bat",
    {
        "C_COMPILER_BAT": GetCCompiler(true),
        "BUILD_OBJ_ECHO_BAT": "%C_COMPILER% -I\"%GAMBITDIR_INCLUDE%\" -c -Fo%BUILD_OBJ_OUTPUT_FILENAME% %BUILD_OBJ_CC_OPTIONS% %BUILD_OBJ_INPUT_FILENAMES%",
        "BUILD_DYN_ECHO_BAT": "%C_COMPILER% -I\"%GAMBITDIR_INCLUDE%\" -D___DYNAMIC -LD -Fe%BUILD_DYN_OUTPUT_FILENAME% %BUILD_DYN_CC_OPTIONS% %BUILD_DYN_LD_OPTIONS_PRELUDE% %BUILD_DYN_INPUT_FILENAMES% %BUILD_DYN_LD_OPTIONS%",
        "BUILD_EXE_ECHO_BAT": "%C_COMPILER% -I\"%GAMBITDIR_INCLUDE%\" %GAMBITLIB_LOC% -Fe%BUILD_EXE_OUTPUT_FILENAME% %BUILD_EXE_CC_OPTIONS% %BUILD_EXE_LD_OPTIONS_PRELUDE% %BUILD_EXE_INPUT_FILENAMES% \"%GAMBITDIR_LIB%\\libgambit.lib\" Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib %GAMBITLIB_LINK% %BUILD_EXE_LD_OPTIONS%"
    });

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambcomp-js.bat.windows.in",
    gambitRoot + "\\bin\\gambcomp-js.bat",
    {});

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambcomp-python.bat.windows.in",
    gambitRoot + "\\bin\\gambcomp-python.bat",
    {});

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambcomp-ruby.bat.windows.in",
    gambitRoot + "\\bin\\gambcomp-ruby.bat",
    {});

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambcomp-php.bat.windows.in",
    gambitRoot + "\\bin\\gambcomp-php.bat",
    {});

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambcomp-java.bat.windows.in",
    gambitRoot + "\\bin\\gambcomp-java.bat",
    {});

FixupFile(
    fso,
    gambitRoot + "\\bin\\gambdoc.bat.windows.in",
    gambitRoot + "\\bin\\gambdoc.bat",
    {});


// We read in all the targets into makefile dictionary
// which is later used to write out the makefile file.
var libObjects = "libObjects";
var gsiObjects = "gsiObjects";
var gscObjects = "gscObjects";

var makefile = {
    libObjects: {},
    gsiObjects: {},
    gscObjects: {}
};

var NORMAL_C = GetValuesFromMakefile(fso, GetGambitRoot(fso) + "\\lib\\makefile.in", "NORMAL_C");
var MODULES_C = GetValuesFromMakefile(fso, GetGambitRoot(fso) + "\\lib\\makefile.in", "MODULES_C");
var LIBRARY_MODULES_C = GetValuesFromMakefile(fso, GetGambitRoot(fso) + "\\gsc\\makefile.in", "LIBRARY_MODULES_C");
AddTargets(NORMAL_C, "lib", gambitRoot, makefile[libObjects]);
AddTargets(MODULES_C, "lib", gambitRoot, makefile[libObjects]);
AddTarget("_gambit.c", "lib", gambitRoot, makefile[libObjects]);

AddTarget("_gsilib.c", "gsi", gambitRoot, makefile[gsiObjects]);
AddTarget("_gambitgsi.c", "gsi", gambitRoot, makefile[gsiObjects]);
AddTarget("_gsi.c", "gsi", gambitRoot, makefile[gsiObjects]);
AddTarget("_gsi_.c", "gsi", gambitRoot, makefile[gsiObjects]);

AddTargets(LIBRARY_MODULES_C, "gsc", gambitRoot, makefile[gscObjects]);
AddTarget("_gsclib.c", "gsc", gambitRoot, makefile[gscObjects]);
AddTarget("_gambitgsc.c", "gsc", gambitRoot, makefile[gscObjects]);
AddTarget("_gsc.c", "gsc", gambitRoot, makefile[gscObjects]);
AddTarget("_gsc_.c", "gsc", gambitRoot, makefile[gscObjects]);

var libObjectList=[];
for(var i in makefile[libObjects])
{
    libObjectList.push(makefile[libObjects][i]["object"]);
}

var gsiObjectList=[];
for(var i in makefile[gsiObjects])
{
    gsiObjectList.push(makefile[gsiObjects][i]["object"]);
}

var gscObjectList=[];
for(var i in makefile[gscObjects])
{
    gscObjectList.push(makefile[gscObjects][i]["object"]);
}

var makefileObject = fso.CreateTextFile(gambitRoot + "\\makefile", 2, true);

makefileObject.WriteLine("GAMBIT_ROOT=" + gambitRoot);

makefileObject.WriteLine("all:  $(GAMBIT_ROOT)\\gsc\\gsc.exe $(GAMBIT_ROOT)\\gsi\\gsi.exe");

makefileObject.WriteLine("$(GAMBIT_ROOT)\\gsi\\gsi.exe:  $(GAMBIT_ROOT)\\lib\\libgambit.lib " + gsiObjectList.join(" "));
makefileObject.WriteLine("\t " + GetCCompiler(true) + " -Fe$(GAMBIT_ROOT)\\gsi\\gsi.exe $(GAMBIT_ROOT)\\lib\\libgambit.lib " + gsiObjectList.join(" ") + " Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib" );

makefileObject.WriteLine("$(GAMBIT_ROOT)\\gsc\\gsc.exe:  $(GAMBIT_ROOT)\\lib\\libgambit.lib " + gscObjectList.join(" "));
makefileObject.WriteLine("\t " + GetCCompiler(true) + " -Fe$(GAMBIT_ROOT)\\gsc\\gsc.exe $(GAMBIT_ROOT)\\lib\\libgambit.lib " + gscObjectList.join(" ") + " Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib" );

makefileObject.WriteLine("$(GAMBIT_ROOT)\\lib\\libgambit.lib: " + libObjectList.join(" "));
makefileObject.WriteLine("\t lib -out:$(GAMBIT_ROOT)\\lib\\libgambit.lib " + libObjectList.join(" "));

for(var i in makefile[libObjects])
{
    makefileObject.WriteLine(makefile[libObjects][i]["object"] + ": " + i);
    makefileObject.WriteLine("\t" + makefile[libObjects][i]["commandLine"]);
}

for(var i in makefile[gsiObjects])
{
    makefileObject.WriteLine(makefile[gsiObjects][i]["object"] + ": " + i);
    makefileObject.WriteLine("\t" + makefile[gsiObjects][i]["commandLine"]);
}

for(var i in makefile[gscObjects])
{
    makefileObject.WriteLine(makefile[gscObjects][i]["object"] + ": " + i);
    makefileObject.WriteLine("\t" + makefile[gscObjects][i]["commandLine"]);
}

makefileObject.WriteLine("install:");
makefileObject.WriteLine("\t" + "if exist \"" + config["bindir"] + "\" rd /s \"" + config["bindir"] + "\"");
makefileObject.WriteLine("\t" + "if exist \"" + config["libdir"] + "\" rd /s \"" + config["libdir"] + "\"");
makefileObject.WriteLine("\t" + "if exist \"" + config["includedir"] + "\" rd /s \"" + config["includedir"] + "\"");
makefileObject.WriteLine("\t" + "if exist \"" + config["docdir"] + "\" rd /s \"" + config["docdir"] + "\"");
makefileObject.WriteLine("\t" + "if exist \"" + config["infodir"] + "\" rd /s \"" + config["infodir"] + "\"");
makefileObject.WriteLine("\t" + "if exist \"" + config["datadir"] + "\" rd /s \"" + config["datadir"] + "\"");
makefileObject.WriteLine("\t" + "mkdir \"" + config["bindir"] + "\"");
makefileObject.WriteLine("\t" + "mkdir \"" + config["libdir"] + "\"");
makefileObject.WriteLine("\t" + "mkdir \"" + config["includedir"] + "\"");
makefileObject.WriteLine("\t" + "mkdir \"" + config["docdir"] + "\"");
makefileObject.WriteLine("\t" + "mkdir \"" + config["infodir"] + "\"");
makefileObject.WriteLine("\t" + "mkdir \"" + config["datadir"] + "\"");
makefileObject.WriteLine("\t" + "copy gsi\\*.exe \"" + config["bindir"] + "\"");
makefileObject.WriteLine("\t" + "copy gsc\\*.exe \"" + config["bindir"] + "\"");
makefileObject.WriteLine("\t" + "copy bin\\*.bat \"" + config["bindir"] + "\"");
makefileObject.WriteLine("\t" + "copy lib\\_gambit.c \"" + config["libdir"] + "\"");
makefileObject.WriteLine("\t" + "copy lib\\*.lib \"" + config["libdir"] + "\"");
makefileObject.WriteLine("\t" + "copy lib\\*#.scm \"" + config["libdir"] + "\"");
makefileObject.WriteLine("\t" + "copy include\\gambit.h \"" + config["includedir"] + "\"");
makefileObject.WriteLine("\t" + "if exist doc\\gambit.pdf copy doc\\gambit.pdf \"" + config["docdir"] + "\"");
makefileObject.WriteLine("\t" + "if exist doc\\gambit.html copy doc\\gambit.html \"" + config["docdir"] + "\"");

makefileObject.WriteLine("clean:");
makefileObject.WriteLine("\t" + "del lib\\*.obj");
makefileObject.WriteLine("\t" + "del lib\\*.lib");
makefileObject.WriteLine("\t" + "del gsi\\*.obj");
makefileObject.WriteLine("\t" + "del gsc\\*.obj");
makefileObject.WriteLine("\t" + "del gsi\\*.exe");
makefileObject.WriteLine("\t" + "del gsc\\*.exe");

/////////////////
WScript.Quit() //
/////////////////

function AddTargets(cList, subdir, gambitRoot, makefileDict)
{
    for(var i in cList)
    {
        AddTarget(cList[i], subdir, gambitRoot, makefileDict);
    }
}

function AddTarget(fileName, subdir, gambitRoot, makefileDict)
{
    var fullPath = "$(GAMBIT_ROOT)\\" + subdir + "\\" + fileName;
    var objName = ReplaceExtension(fullPath, "c", "obj");
    makefileDict[fullPath] = {
        "object": objName,
        "commandLine": GetCommandLineForCompilation(fileName, gambitRoot) + " /Fo" + objName + " " + fullPath
    };
}

// Replace the pattern @ABC@ in the input file with the
// value in the fixup dictionary for the key ABC and write
// out the contents to the output file
function FixupFile(fso, inFile, outFile, fixupDictionary)
{
    var inFileObject = fso.OpenTextFile(inFile);
    var outFileObject = fso.CreateTextFile(outFile, true);
    var re = /@(\S+)@/;

    while (!inFileObject.AtEndOfStream)
    {
        var line = inFileObject.ReadLine();
        var m = line.match(re);
        if (m != null)
        {
            var replacement = fixupDictionary[m[1]];
            if (replacement != null)
            {
                line = line.replace(re, replacement);
            }
        }
        outFileObject.WriteLine(line);
    }
    inFileObject.close();
    outFileObject.close();
}

// Return the list of source files corresponding to a macro
// as specified in the makefile.in file
function GetValuesFromMakefile(fso, makefileName, macro)
{
    var makefileObject = fso.OpenTextFile(makefileName);
    var re = new RegExp("^" + macro + " *= *(.*)");

    while (!makefileObject.AtEndOfStream)
    {
        var line = makefileObject.ReadLine();
        var m = line.match(re);
        if (m != null)
        {
            line = m[1];

            var m;
            while ((m = line.match(/(.*)\\$/)) != null)
            {
                line = m[1] + makefileObject.ReadLine();
            }
            line.replace(/\s+/, " ");
            return line.split(" ");
        }
    }
}

function GetGambitRoot(fso)
{
    return fso.GetParentFolderName(fso.GetFile(WScript.ScriptFullName)) + "\\.."
}

function ReplaceExtension(fileName, fromExt, toExt)
{
    return fileName.replace(new RegExp("." + fromExt + "$"), "." + toExt);
}

function GetCommandLineForCompilation(fileName, gambitRoot)
{
    var COMP = GetCCompiler((fileName != "_num.c" && fileName != "_io.c"))
               + " -c -I$(GAMBIT_ROOT)\\include -D___SYS_TYPE_CPU=\\\"i686\\\" -D___SYS_TYPE_VENDOR=\\\"pc\\\" -D___SYS_TYPE_OS=\\\"visualc\\\" " + GAMBITDIRS;

    var COMP_LIB = COMP + " " + "-D___LIBRARY";
    var COMP_LIB_PR = COMP_LIB + " " + "-D___PRIMAL";
    var COMP_APP = COMP;

    if (fileName == "_gsi.c" || fileName == "_gsi_.c" || fileName == "_gsc.c" || fileName == "_gsc_.c")
    {
        return COMP_APP;
    }
    else
    {
        return COMP_LIB_PR;
    }
}
