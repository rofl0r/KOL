XCL - eXtream Class Library - FREEWARE OPEN SOURCE project.
Idea: by Kladov Vladimir (C) 1999, 2000.

KOL - Key Objects Library - FREEWARE OPEN SOURCE project.
Idea: by Kladov Vladimir (C) 2000

DELPHI SYSTEM.DCU REPLACEMENT (C) 2000 by Kladov Vladimir
VERSION 1.1

Part of KOL / XCL technology: 
system.dcu, sysinit.dcu and some other sysxxxxx.dcu (with sources)
to replace Delphi standard ones and make all XCL (and other Delphi
non-VCL based) projects even smaller (difference is 6-20K depending
on project). Dcu's are provided for Delphi5 only, but with sources,
and You can adjust it for earlier Delphi versions too. 

What is done here (briefly, see also sources - all changes are
marked with '{X' characters):

***  references to console input/output routines (AssignFile, Read, 
Write, etc) removed (it is possible to call UseInputOutput to provide 
it therefore);

***  floating point initialization removed (if You want, call manually 
one of FpuInit or FpuInitConsiderNECWindows procedures);

***  references to both WriteLn and MessageBox are removed in error 
handling routine. You have to call manually one of UseErrorMessageBox 
or UseErrorMessageWrite procedure to provide it again.

***  Variables CmdShow and CmdLine are replaced with same-named 
functions - to allow smart-linking.

***  Embedded support of Wide strings, Wide String arrays and Variants 
removed. (It is yet possible to use wide strings/wide string arrays and 
(or) variants by placing reference(s) to units SysWStr and (or) SysVarnt 
units into uses clause of dpr, but with some small restrictions, e.g. it 
is not possible to initialize such variables in dpr itself). And with 
this change, well-know "feature" of linking every Delphi program with 
oleaut.dll is gone.

***  Overblotted Delphi memory manager is replaced by very simple one, 
which just calls LocalAlloc, LocalFree, LocalReAlloc. (It is yet possible 
to call UseDelphiMemoryManager to restore it, or to call SetMemoryManager 
to setup your own memory manager).

***  Try-except-finally & raise handling support routines removed, 
including steps of units initializations / finalization. (But therefore 
it can be turned on again by adding a reference to SysSfIni unit in uses 
clause of project's dpr file).

***  Safe-thread string reference count (and dynamic arrays too) handling 
feature removed (all LOCK prefixes are commented, and there is no way to 
enable this again - except uncommenting it again and recompiling system.pas).

In result, size of empty project is only 4,5K after compiling. And if some 
ansi string operations are added, size is about 5,5K. For dynamic array of 
strings, size of executable is about 6,5K. And so on.

*** In version 1.1 (15-Jun-2000):
[-] System.Move fixed. There are now three versions there for lovers:
    1. Borland's; 2. Small; 3. Fast (the last is turned on).

[-] SysSfIni.pas usage fixed (changes made in SetExceptionHandler).

[+] Some declarations moved from SysInit.pas to System.pas to avoid of
    creating second import section from kernel32.dll (thanks to Alexey
    Torgashin).

[+] ErrorAddr now is not set to nil in _Halt0 (by advice of Alexey 
    Torgashin - to allow check ErrorAddr in the rest of finalization
    sections).


INSTALLATION:

- DO NOT REPLACE EXISTING FILES with new ones. Place it in any other directory
where You wish, and add path to it in your project AS FIRST path.
Provided DCU's are only for DELPHI5 and compiled with -DDEBUG key (so, it
is possible to step into system.pas, sysinit.pas, getmem.inc and others
while debugging. If You want to turn debug info off, recompile it as it is said
below).


RECOMPILING:

- If You want to make some changes and recompile units provided, do following:

1. Backup files in your existing Delphi5\Lib directory (with Delphi5\Lib\Debug
subdirectory) and make copy of existing system.pas, sysinit.pas, getmem.inc
(and other which You want to change) - in Delphi5\Source\Rtl\Sys directory.

2. Place new versions of source files (system.pas, sysinit.pas, getmem.inc,
syssfini.pas, syswstr.pas, sysvarnt.pas) to your Delphi5\Source\Rtl\Sys
directory, replacing existing ones.
   Copy existing sysconst.dcu from Delphi5\Lib to Source\Rtl\Lib (this last
directory must not contain other files before recompiling).

3. Place provided file named 'makefile' to Delphi5\Source\Rtl directory,
replacing existing one (You can also rename existing makefile to save it too).

4. Copy make.exe from Delphi5\Bin to Delphi5\Source\Rtl directory. You can
open also makefile to read recompiling instructions there.

5. Open your lovely DOS Shell program (NC, DN, Far, VC, WC, etc.) or command
line prompt and go to the Delphi5\Source\Rtl directory. Run there make.exe
with desired parameters, e.g.:

> make -DDEBUG >1.txt

or

> make >2.txt

6. Go to Delphi5\Source\Rtl\Lib and watch resulting dcu's there. Cut them and
paste to Delphi5\Lib or Delphi5\Lib\Debug, replacing existing ones.

7. If Delphi IDE is yet open, close it. (It is better to close it before
compiling, but it seems no matter - it is just have to be restarted).

8. Open Delphi again and enjoy.

TIP: if You plan to make some changes and to test it in standard programming
cycle - writing-compiling-debugging, make bat-file to perform steps 5-6 more
easy. Do not forget, that Source\Rtl\Lib must be empty before recompiling,
but sysconst.dcu.

=============================================================================
If You adjust changed files to earlier versions of Delphi, or have found
some bugs, or could suggest some useful changes, and even if You have
(unique) opinion about the work, please e-mail me:

mailto: bonanzas@xcl.cjb.net?subject=system

Web page: http://xcl.cjb.net

LET US MAKE OUR DELPHI PROGRAMS SMALL ! (C) me