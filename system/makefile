
# *******************************************************
# *                                                     *
# *     Delphi Runtime Library                          *
# *     MAKE script                                     *
# *                                                     *
# *     Copyright (C) 1988,98 Inprise Corporation       *
# *                                                     *
# *******************************************************

# This MAKE script requires Borland MAKE Version 3.7 or later (MAKE.EXE),
# Turbo Assembler Version 4.0 or later (TASM32.EXE), and Borland Resource
# Compiler Version 4.0 or later (BRCC32.EXE).

# The script assumes that DCC32.EXE, TASM32.EXE, and BRCC32.EXE are present
# on the current search path--if this is not the case, modify the DCC, TASM,
# and BRCC macros below to reflect the location of these executables.

# To build the runtime library without debug information (the default),
# simply run MAKE.EXE from the directory containing this MAKEFILE. To
# build a debug version of the runtime library, specify a -DDEBUG command
# line parameter when running MAKE.EXE.

# The BIN and LIB macros define the output directories for binaries and
# compiled units.

# DCC = dcc32 -q
# TASM = tasm32
# BRCC = brcc32

DCC = c:\delphi5\bin\dcc32 -q
TASM = c:\tasm5\bin\tasm32
BRCC = c:\delphi5\bin\brcc32

BIN = bin
LIB = lib

!if $d(DEBUG)
RTLDEBUG = -$$D+
ASMDEBUG = -zi
!else
RTLDEBUG = -$$D-
ASMDEBUG = -zn
!endif

SYSTEMOBJ = \
sys\assign.obj   \
sys\blockrea.obj \
sys\blockwri.obj \
sys\close.obj    \
sys\eoffile.obj  \
sys\eoftext.obj  \
sys\eoln.obj     \
sys\erase.obj    \
sys\ext2real.obj \
sys\fdiv.obj     \
sys\filepos.obj  \
sys\filesize.obj \
sys\halt.obj     \
sys\openfile.obj \
sys\opentext.obj \
sys\pow10.obj    \
sys\readchar.obj \
sys\readext.obj  \
sys\readint64.obj \
sys\readln.obj   \
sys\readlong.obj \
sys\readrec.obj  \
sys\readstri.obj \
sys\real2ext.obj \
sys\rename.obj   \
sys\seek.obj     \
sys\seekeof.obj  \
sys\seekeoln.obj \
sys\settextb.obj \
sys\strext.obj   \
sys\truncate.obj \
sys\valext.obj   \
sys\writerec.obj \
sys\writestr.obj \
sys\_ll.obj

SYSUTILSOBJ = \
sys\ffmt.obj

.asm.obj:
 $(TASM) -zn -m3 -t -w- $(ASMDEBUG) -isys $*,$*.obj

default: \
$(LIB)\system.dcu   \
$(LIB)\sysvarnt.dcu \
$(LIB)\syssfini.dcu \
$(LIB)\syswstr.dcu  \
$(LIB)\sharemem.dcu \
$(LIB)\comobj.dcu   \
$(LIB)\comserv.dcu  \
$(LIB)\windows.dcu  \
$(LIB)\sysutils.dcu \
$(LIB)\messages.dcu \
$(LIB)\shellapi.dcu \
$(LIB)\shlobj.dcu   \
$(LIB)\dlgs.dcu     \
$(LIB)\commdlg.dcu  \
$(LIB)\commctrl.dcu \
$(LIB)\ddeml.dcu    \
$(LIB)\flatsb.dcu   \
$(LIB)\mmsystem.dcu \
$(LIB)\nsapi.dcu    \
$(LIB)\isapi.dcu    \
$(LIB)\isapi2.dcu   \
$(LIB)\wininet.dcu  \
$(LIB)\winspool.dcu \
$(LIB)\winsock.dcu  \
$(LIB)\winsvc.dcu   \
$(LIB)\mapi.dcu     \
$(LIB)\multimon.dcu \
$(LIB)\lzexpand.dcu \
$(LIB)\nb30.dcu     \
$(LIB)\ole2.dcu     \
$(LIB)\olectl.dcu   \
$(LIB)\oledlg.dcu   \
$(LIB)\richedit.dcu \
$(LIB)\tlhelp32.dcu \
$(LIB)\math.dcu     \
$(LIB)\imm.dcu      \
$(LIB)\activex.dcu  \
$(LIB)\cpl.dcu      \
$(LIB)\imagehlp.dcu \
$(LIB)\opengl.dcu   \
$(LIB)\penwin.dcu   \
$(LIB)\regstr.dcu   \
$(LIB)\urlmon.dcu


$(LIB)\system.dcu: sys\system.pas sys\sysinit.pas sys\getmem.inc $(SYSTEMOBJ)
 $(DCC) sys\system -m -y -z $(RTLDEBUG) -n$(LIB)

# follow lines are added to compile additional units (sysvarnt, syswstr):

$(LIB)\sysvarnt.dcu: sys\sysvarnt.pas $(LIB)\system.dcu
 $(DCC) sys\sysvarnt -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\syswstr.dcu: sys\syswstr.pas $(LIB)\system.dcu
 $(DCC) sys\syswstr -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\syssfini.dcu: sys\syssfini.pas $(LIB)\system.dcu
 $(DCC) sys\syssfini -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\comobj.dcu: sys\comobj.pas $(LIB)\system.dcu \
$(LIB)\sysutils.dcu $(LIB)\windows.dcu $(LIB)\activex.dcu
 $(DCC) sys\comobj -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\comserv.dcu: sys\comserv.pas $(LIB)\system.dcu \
$(LIB)\comobj.dcu $(LIB)\sysutils.dcu $(LIB)\windows.dcu
 $(DCC) sys\comserv -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\sharemem.dcu: sys\sharemem.pas $(LIB)\system.dcu
 $(DCC) sys\sharemem -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\windows.dcu: win\windows.pas $(LIB)\system.dcu
 $(DCC) win\windows -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\sysutils.dcu: sys\sysutils.pas $(SYSUTILSOBJ) \
$(LIB)\system.dcu $(LIB)\windows.dcu
 $(DCC) sys\sysutils -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\messages.dcu: win\messages.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\messages -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\shellapi.dcu: win\shellapi.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\shellapi -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\regstr.dcu: win\regstr.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\regstr -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\shlobj.dcu: win\shlobj.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu $(LIB)\ole2.dcu $(LIB)\commctrl.dcu \
$(LIB)\shellapi.dcu $(LIB)\regstr.dcu
 $(DCC) win\shlobj -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\dlgs.dcu: win\dlgs.pas $(LIB)\system.dcu
 $(DCC) win\dlgs -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\commdlg.dcu: win\commdlg.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu $(LIB)\messages.dcu
 $(DCC) win\commdlg -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\commctrl.dcu: win\commctrl.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\commctrl -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\ddeml.dcu: win\ddeml.pas $(LIB)\system.dcu $(LIB)\windows.dcu
 $(DCC) win\ddeml -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\mmsystem.dcu: win\mmsystem.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\mmsystem -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\winspool.dcu: win\winspool.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\winspool -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\isapi.dcu: win\isapi.pas $(LIB)\system.dcu $(LIB)\windows.dcu
 $(DCC) win\isapi -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\isapi2.dcu: win\isapi2.pas $(LIB)\system.dcu $(LIB)\windows.dcu
 $(DCC) win\isapi2 -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\nsapi.dcu: win\nsapi.pas $(LIB)\system.dcu $(LIB)\windows.dcu
 $(DCC) win\nsapi -z $(RTLDEBUG) -u$(LIB);win -n$(LIB)

$(LIB)\wininet.dcu: win\wininet.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\wininet -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\winsock.dcu: win\winsock.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\winsock -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\winsvc.dcu: win\winsvc.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\winsvc -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\mapi.dcu: win\mapi.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\mapi -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\lzexpand.dcu: win\lzexpand.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\lzexpand -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\nb30.dcu: win\nb30.pas $(LIB)\system.dcu $(LIB)\windows.dcu
 $(DCC) win\nb30 -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\ole2.dcu: win\ole2.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\ole2 -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\olectl.dcu: win\olectl.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu $(LIB)\messages.dcu $(LIB)\ole2.dcu
 $(DCC) win\olectl -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\oledlg.dcu: win\oledlg.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu $(LIB)\commctrl.dcu $(LIB)\ole2.dcu
 $(DCC) win\oledlg -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\richedit.dcu: win\richedit.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\richedit -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\tlhelp32.dcu: win\tlhelp32.pas $(LIB)\system.dcu \
$(LIB)\windows.dcu
 $(DCC) win\tlhelp32 -z $(RTLDEBUG) -u$(LIB) -n$(LIB)

$(LIB)\math.dcu: sys\math.pas $(LIB)\system.dcu
 $(DCC) sys\math -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\imm.dcu: win\imm.pas $(LIB)\windows.dcu
 $(DCC) win\imm -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\activex.dcu: win\activex.pas $(LIB)\windows.dcu $(LIB)\messages.dcu
 $(DCC) win\activex -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\cpl.dcu: win\cpl.pas $(LIB)\windows.dcu $(LIB)\messages.dcu
 $(DCC) win\cpl -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\imagehlp.dcu: win\imagehlp.pas $(LIB)\windows.dcu
 $(DCC) win\imagehlp -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\opengl.dcu: win\opengl.pas $(LIB)\windows.dcu
 $(DCC) win\opengl -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\penwin.dcu: win\penwin.pas $(LIB)\windows.dcu $(LIB)\messages.dcu \
$(LIB)\mmsystem.dcu
 $(DCC) win\penwin -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\urlmon.dcu: win\urlmon.pas $(LIB)\windows.dcu $(LIB)\activex.dcu
 $(DCC) win\urlmon -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\flatsb.dcu: win\flatsb.pas $(LIB)\windows.dcu
 $(DCC) win\flatsb -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)

$(LIB)\multimon.dcu: win\multimon.pas $(LIB)\windows.dcu
 $(DCC) win\multimon -z $(RTLDEBUG) -u$(LIB) -r$(LIB) -n$(LIB)
