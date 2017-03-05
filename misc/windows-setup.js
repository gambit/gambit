var fso = new ActiveXObject("Scripting.FileSystemObject")

var gambitRoot = GetGambitRoot(fso);

FixupFile(
    fso,
    gambitRoot + "\\include\\gambit.h.in",
    gambitRoot + "\\include\\gambit.h",
    {
        "CONF_VOIDSTAR_WIDTH":                 "___LONG_WIDTH",
        "CONF_MAX_CHR":                        "0x10ffff",
        "CONF_SINGLE_MULTIPLE_VMS":            "___SINGLE_VM",
        "CONF_SINGLE_MULTIPLE_THREADED_VMS":   "___SINGLE_THREADED_VMS",
        "CONF_THREAD_SYSTEM":                  "___USE_NO_THREAD_SYSTEM",
        "CONF_THREAD_LOCAL_STORAGE_CLASS":     "___NO_THREAD_LOCAL_STORAGE_CLASS",
        "CONF_ACTIVITY_LOG":                   "___NO_ACTIVITY_LOG",
        "CONF_BOOL":                           "int"
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
        "C_COMPILER_BAT": "cl.exe",
        "BUILD_OBJ_BAT": "cl.exe",
        "BUILD_OBJ_ECHO_BAT": "%C_COMPILER% -I%GAMBITDIR_INCLUDE% -c -Fo%BUILD_OBJ_OUTPUT_FILENAME% %BUILD_OBJ_CC_OPTIONS% %BUILD_OBJ_INPUT_FILENAMES%",
        "BUILD_EXE_ECHO_BAT": "%C_COMPILER%  -I%GAMBITDIR_INCLUDE% %GAMBITLIB_LOC% -Fe%BUILD_EXE_OUTPUT_FILENAME% %BUILD_EXE_CC_OPTIONS% %BUILD_EXE_LD_OPTIONS_PRELUDE% %BUILD_EXE_INPUT_FILENAMES% %GAMBITDIR_LIB%\\libgambc.lib Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib %GAMBITLIB_LINK% %BUILD_EXE_LD_OPTIONS%"
    });


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

var makefileObject = fso.CreateTextFile(gambitRoot + "\\misc\\makefile.windows", 2, true);

makefileObject.WriteLine("GAMBIT_ROOT=" + gambitRoot);

makefileObject.WriteLine("all:  $(GAMBIT_ROOT)\\bin\\gsc.exe $(GAMBIT_ROOT)\\bin\\gsi.exe");

makefileObject.WriteLine("$(GAMBIT_ROOT)\\bin\\gsi.exe:  $(GAMBIT_ROOT)\\lib\\libgambc.lib " + gsiObjectList.join(" "));
makefileObject.WriteLine("\t cl -Fe$(GAMBIT_ROOT)\\bin\\gsi.exe $(GAMBIT_ROOT)\\lib\\libgambc.lib " + gsiObjectList.join(" ") + " Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib" );

makefileObject.WriteLine("$(GAMBIT_ROOT)\\bin\\gsc.exe:  $(GAMBIT_ROOT)\\lib\\libgambc.lib " + gscObjectList.join(" "));
makefileObject.WriteLine("\t cl -Fe$(GAMBIT_ROOT)\\bin\\gsc.exe $(GAMBIT_ROOT)\\lib\\libgambc.lib " + gscObjectList.join(" ") + " Kernel32.Lib User32.Lib Gdi32.Lib WS2_32.Lib" );

makefileObject.WriteLine("$(GAMBIT_ROOT)\\lib\\libgambc.lib: " + libObjectList.join(" "));
makefileObject.WriteLine("\t lib -out:$(GAMBIT_ROOT)\\lib\\libgambc.lib " + libObjectList.join(" "));

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

makefileObject.WriteLine("clean:");
makefileObject.WriteLine("\t" + "del lib\\*.obj");
makefileObject.WriteLine("\t" + "del lib\\*.lib");
makefileObject.WriteLine("\t" + "del gsi\\*.obj");
makefileObject.WriteLine("\t" + "del gsc\\*.obj");

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
        "commandLine": GetCommandLineForCompileation(fileName, gambitRoot) + " /Fo" + objName + " " + fullPath
    };
}

// Replace the pattern @ABC@ in the input file with the
// value in the fixup dicionary for the key ABC and write
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

function GetCommandLineForCompileation(fileName, gambitRoot)
{
    var COMP_GEN = "cl -nologo -Oityb1 -Zi -GS -RTC1 -MT -D_CRT_SECURE_NO_DEPRECATE -c -I$(GAMBIT_ROOT)\\include -D___SYS_TYPE_CPU=\\\"i686\\\" -D___SYS_TYPE_VENDOR=\\\"pc\\\" -D___SYS_TYPE_OS=\\\"visualc\\\" -DGAMBITDIR=\"" + gambitRoot + "\"";
    
    var COMP_LIB_MH = COMP_GEN + " " + "-D___LIBRARY";
    var COMP_LIB_PR_MH = COMP_LIB_MH + " " + "-D___PRIMAL";
    var COMP_LIB = COMP_LIB_MH + " " + "-D___SINGLE_HOST";
    var COMP_LIB_PR = COMP_LIB_PR_MH + " " +  "-D___SINGLE_HOST";
    var COMP_APP = COMP_GEN + " " + "-D___SINGLE_HOST";

    if (fileName == "_num.c" || fileName == "_io.c")
    {
        return COMP_LIB_PR_MH;
    }
    else if (fileName == "_gsi.c" || fileName == "_gsi_.c" || fileName == "_gsc.c" || fileName == "_gsc_.c")
    {
        return COMP_APP;
    }
    else
    {
        return COMP_LIB_PR;
    }
}
