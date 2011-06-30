Mirror Classes Kit for Key Objects Library, v2.00 [15-Nov-2004]
Copyright (C) 1999, 2000-2003 by Vladimir Kladov
-------------------------------------------------
Delphi 2, 3, 4, 5, 6, 7 are supported.
Compatible with Free Pascal 1.0.5 / 1.0.6 and higher
Partially compatible with Kylix (to compile projects for Linux/Qt)

PLEASE, READ CAREFULLY THE *WARNINGS* AT THE END OF THIS FILE !

	CONTENTS

   I. INTRODUCTION
  II. INSTALLATION INSTRUCTIONS
 III. STARTING NEW KOL MIRROR PROJECT
  IV. ADDING A FORM
   V. REMOVING A FORM
  VI. RENAMING A FORM 
 VII. WRITING MIRROR CODE
VIII. ADDING REFERENCES TO A UNIT
  IX. USING TComponent DESCENDANT FROM VCL
   X. FILES CREATED AUTOMATICALLY
  XI. MAINTAINANCE
 XII. W A R N I N I N G S
XIII. RESOLVING PROBLEMS

	I. INTRODUCTION

MCK is a kit of mirror classes for the VISUAL project development in Delphi environment using KOL library. (I will not explain here what is the KOL - refer on http://xcl.cjb.net). Though from the beginning nor KOL, nor its predecessor XCL were not fit and intended for the visual development, therefore offers, ideas, questions and thoughts from many people on this cause enterred with the enviable regularity. Finally, after some thoughts, I come to a conclusion that it is possible for KOL to make it visual. And, in spite of the collapse of preceding attempt (project XCL Wizard, if who in the course - it has deprived more than half a year beside me), I decided to start the new project on. And though I myself repeatedly convinced my opponents that it's impossible... For four evenings to me, it seems to jerk it.

Essence of idea of "mirror classes" is concluded in following. For each visually isolated object of KOL library Delphi VCL component is created, which is registerred by usual way for Delphi components and it is placed on the palette of components. I use the term "visually isolated object" because the same (from formal standpoints) object type in KOL can implement of different visual elements. For instance, TControl can be either form, or button, or label, or any other dialogue element.

Designing of project in "mirror" classes consists in following two steps:
- Placing two components TKOLProject and TKOLForm on the form, and running project first time to convert it into KOL-compliant. - When working with it at the design time as with usual VCL project, and when it is compiled, KOL objects are substituting corresponent mirror VCL objects, and application is very small.

+++++++++++++++++++++++++++++++++++++++++++++++++++
++++++ The main difference of designing project for KOL using MCK from VCL are follows:

- You should not change properties of the form itself, excluding changing its size and position at design time. Change properties of TKOLForm component on it instead. Also, do not create events for a form itself, create events for TKOLForm component on it instead.

- You should not drop any non-MCK components and controls onto the form. Use only special MCK components designed for working with KOL project.

- Some of properties of MCK components are for design time only and such properties are not available at run-time. The most of such properties are named with small letters.

- To resolve a conflict between "Self" in VCL and "@Self" in KOL (which means the same), special word "Form" is introduced. It is implemented as a property, which returns at run-time pointer to a form (of type PControl), and is understanded at design time by Delphi compiler as a synonim of Self.
   Always use this word in event handlers, created at design time, as a substitute of pointer to a form. Do not write 
	Caption := 'Hello!';
Write instead:
	Form.Caption := 'Hello!';
Therefore, controls and objects, placed onto form at design time, are available by the same way like in VCL. If You write 
	Button1.Click;
this will be interpreted as usual.

- painting of "mirror" controls at design-time now implemented schematic, but later it is possible to detailizy painiting, overriding Paint method of TKOLControl descendants. (Moreover, it is possible to switch between two painting methods by checking special property of TKOLProject component and to get other advantages - now not implemented yet).

+++++++++++++++++++++++++++++++++++++++++++++++++++
++++++ All other notes are the same as for programming with KOL non-visually.

- Do not inherit your own descendants from TControl. If You want to change message processing for certain control (or form, or Applet object), use events (and the most power is OnMessage, which allows to filter all messages, passed to a control), or attach external handler (using AttachProc method).

- If You want to create quit different (new) object, not presented in KOL, inherit it from TObj object.

- it is offerred to solve possible conflicts between the alike name of types, procedures, functions, constants and variable in KOL and VCL on the following rule: 1. if name has same that on the sense a type, conflict does not appear. 2. if only names coincide, the accompaniment prefix <KOL.> will resolve a conflict completely (reference to KOL must be added in the uses clause FIRST that KOL declarations have a smaller priority in contrast with VCL declarations  while code development at design time).

-------------------------------------------------------------------
See also Instructions below.

	II. INSTALLATION INSTRUCTIONS

______________________
DELPHI7 - INSTALLATION

1. Unpack files to the same folder, where You have KOL installed.
2. Open MirrorKOLPackageD7.dpk in Delphi IDE and click 'Install'.

DELPHI7 - UPGRADING

1. Close all files in IDE: File|Close All
2. Unpack files to the same folder, where You have KOL installed.
3. Open MirrorKOLPackageD7.dpk in Delphi IDE and click 'Compile' (Button 'Install' is not available, since package is installed).
______________________
DELPHI6 - INSTALLATION

1. Unpack files to the same folder, where You have KOL installed.
2. Open MirrorKOLPackageD6.dpk in Delphi IDE and click 'Install'.

DELPHI6 - UPGRADING

1. Close all files in IDE: File|Close All
2. Unpack files to the same folder, where You have KOL installed.
3. Open MirrorKOLPackageD6.dpk in Delphi IDE and click 'Compile' (Button 'Install' is not available, since package is installed).
______________________
DELPHI5 - INSTALLATION

1. Unpack files to the same folder, where You have KOL installed.
2. Open MirrorKOLPackage.dpk in Delphi IDE and click 'Install'.

DELPHI5 - UPGRADING

1. Close all files in IDE: File|Close All
2. Unpack files to the same folder, where You have KOL installed.
3. Open MirrorKOLPackage.dpk in Delphi IDE and click 'Compile' (Button 'Install' is not available, since package is installed).
______________________
DELPHI4 - INSTALLATION

1. Unpack files to the same folder, where You have KOL installed.
2. Open MirrorKOLPackageD4.dpk in Delphi IDE and click 'Install'.

DELPHI4 - UPGRADING

1. Close all files in IDE: File|Close All
2. Unpack files to the same folder, where You have KOL installed.
3. Open MirrorKOLPackageD4.dpk in Delphi IDE and click 'Compile' (Button 'Install' is not available, since package is installed).

______________________
DELPHI3 - INSTALLATION

1. Unpack files to the same folder, where You have KOL installed.
2. Open MirrorKOLPackageD3.dpk in Delphi IDE and click 'Install'.

DELPHI3 - UPGRADING

1. Close all files in IDE: File|Close All
2. Unpack files to the same folder, where You have KOL installed.
3. Open MirrorKOLPackageD3.dpk in Delphi IDE and click 'Compile' (Button 'Install' is not available, since package is installed).

______________________
DELPHI2 - INSTALLATION

1. Unpack files to the same folder, where You have KOL installed.
2. Component|Install...|Add|Browse|mirror.pas|OK
3. Component|Install...|Add|Browse|mckObjs.pas|OK
4. Component|Install...|Add|Browse|mckCtrls.pas|OK

DELPHI2 - UPGRADING

1. Close all files in IDE: File|Close All
2. Unpack files to the same folder, where You have KOL installed.
3. Component|Install...|OK (earlier installed units mirror, mckObjs, mckCtrls should be seen already in a list)


				       *
				***************	
			*******************************

		     III. STARTING NEW KOL MIRROR PROJECT

			*******************************
				***************
				       *

1. Start Delphi and choose File|New Application.

2. DO NOT place any components on the form at this stage. Choose File|Save All and select the destination folder for your project. Note that ALL FILES of your project ALWAYS HAVE TO BE PLACED IN THE SAME DIRECTORY!
You may change the name of the .PAS file, but you MUST NOT change the name of the .DPR file.

3. Place the TKOLProject component onto the form.

4. The name of the output MCK file can be set by changing the ProjectDest property (path MUST NOT be included). If you type MySuperKOLProj, for instance, then the output MCK project will be named MySuperKOLProj.DPR. The EXE file's name will be (as you might have guessed already) MySuperKOLProj.EXE.

5. Drop the TKOLForm component onto the form.

6. In DELPHI5 only: Project | Options | Directories/Conditionals | Search path, add:
   $(Delphi)\Source\ToolsApi
   (this only seems to be necessary when working with Delphi 5 - the compiler needs to know the path to toolintf.pas, dsgnintf.pas, editintf.pas and exptintf)

7. If TKOLForm component was dropped (5.) AFTER changing ProjectDest property of TKOLProject component (4.), this step is not necessary, and destination project is ready. Otherwise:
   change any property of the TKOLForm (or change the form's size or position). Even though no exe-file is created, you can open the resulting project immediately. This way allows you to convert a dll-project to a mck-compatible one as well.

8. Open the resulting project (it should be found in the same directory). Now it is high time you removed Project1.* - these files are no longer necessary.

9. Play with your new KOL/MCK Project (adjust Parameters, drop TKOL... components, compile, run, debug, etc.) Enjoy!


	IV. ADDING A FORM
1. File|New form
2. Save it IN THE SAME directory where project is located.
3. Drop TKOLForm object onto it.
4. Be sure that You have TKOLApplet component dropped on the main form.
5. If AutoBuild is turned off: select TKOLProject component in main form and double click its property Build. (Otherwise, all should be done already, isn't it?)
Answer Yes to all questions about reload changed files (if any).

	V. REMOVING A FORM
1. Project|Remove from project... as usual.
2. Select TKOLProject, double click Build property. (Than OK, ... - if any).

	VI. RENAMING A FORM

Do not rename form itself, instead change FormName property of TKOLForm component on a form. Remember, that main form (with TKOLProject component on it also must be opened in the designer).

	VII. WRITING MIRROR CODE
  
  Do not use names from VCL, especially from SysUtils, Classes, Forms, etc. All what You need, You should find in KOL.pas, Windows.pas, Messages.pas, ShellAPI.pas. And may be, write by yourself (or copy from another sources).
  When You write code in mirror project - usually place it in event handlers.
  You also can add any code where You wish but avoid changing first section of your mirror VCL form class declaration. And do not change auto-generated inc-files (marked as read-only by default).
  Always remember, that code, that You write in mirror project, must be accepted both by VCL and KOL. By VCL - at the stage of compiling mirror project (and this is necessary, because otherwise converting mirror project to reflected KOL project will not be possible). And by KOL - at the stage of compiling written code in KOL namespace.

  THIS IS IMPORTANT:
  To resolve conflict between words VCL.Self and KOL.@Self, which are interpreted differently in KOL and VCL, special field is introduced - Form. In VCL, Form property of TKOLForm component "returns" Self, i.e. form object itself. And in KOL, Form:PControl is a field of object, containing resulting form object. Since this, it is correctly to change form's properties in following way: 
	Form.Caption := 'Hello!'; 
  (Though old-style operator Caption := 'Hello!'; is compiled normally while converting mirror project to KOL, it will be wrong in KOL environment).
  But discussed above word Form is only to access form's properties - not its child controls. You access child controls and form event handlers by usual way. e.g.: 
	Button1.Caption := 'OK';
	Button1Click( Form );
  END OF IMPORTANT PARAGRAPH.

  It is possible to create several instances of the same form at run-time. And at least, it is possible to make form not AutoCreate, and create it programmatically when needed. Use global function NewForm1 (replacing Form1 with your mirror form name), for instance:
  TempForm1 := NewForm1( Applet );
  To make this possible, NEVER access global variable created in the unit during conversation, unless You know why You are doing so. Refer to Form variable instead.

	VIII. ADDING REFERENCES TO A UNIT

  If You want to add a reference to another psacal unit in uses clause of your form unit, insert it as follows:

====== CUT FROM TYPICAL UNIT WITH KOL FORM: ========
{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF}, <-- list of your unit names here -->;
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}
====== END OF CUT HERE ======

	IX. USING TComponent DESCENDANT FROM VCL

  Starting from MCK v0.71, it is possible to drop usual VCL-based components onto MCK form, and a code will be generated for proper creation and destructing these components. Please note, that therefore, using VCL-based components in KOL-MCK projects is not a good practice, because a lot of code which is not actually needed will be added to the executable.
  However, using of visual VCL components in MCK projects is not possible at all. Moreover, TKOLProject and TKOLForm components are immediately locked, when any such VCL control is found on form. This prevents its from functioning, but avoids any damage due erroneous dropping MCK components onto forms of normal VCL project.
  If VCL component is used in your MCK project, please note:
- automatic code generation is not occur even if Autobuild is set to True in TKOLProject. Double click TKOLProject component (e.g.) to force code generation after You change some properties / assign events to the component.
- when You drop the component onto MCK form at design time, Delphi adds a reference to its unit in uses clause of the form unit, but it is placed (usually) between {$IFNDEF KOL_MCK}...{$ENDIF} brackets, so the project can not be compiled. To correct this, go to the beginning of the unit, and move the reference to newly added unit as follows:
   ..., SomeUnit {$ENDIF};      ->    ... {$ENDIF} , SomeUnit;


	X. FILES CREATED AUTOMATICALLY

1. In addition to <YourProject>.dpr, following files are generated:
   - <YourProject>_0.inc - contains alternative application initialization code.
				Such code is running at run time instead of those generated
				by standard auto-completion between 'begin' and 'end'
				statements in dpr-file of the project. Structure is follows:

				Applet := NewApplet( ... ); // if TKOLApplet is used only
				[ Applet.Visible := False; ] // optional
				[ Applet.OnMessage := ...; ] // optional

				{$I <YourProject>_1.inc
				{$I <YourProject>_2.inc // automatic, form creation
				{$I <YourProject>_3.inc

				Run( ... );

				{$I <YourProject>_4.inc

   - <YourProject>_1.inc - generated empty, if does not exist. You can alter it,
				placing here code, which executed at run time after Applet
				initialization. For instance, You can write here conditional
				operator 'if' to prevent further running of application
				in some cases.

   - <YourProject>_2.inc - generated automatically, contains code to initializy
				auto-created forms. You should never alter it.

   - <YourProject>_3.inc and <YourProject>_4.inc - like for <YourProject>_1.inc, it is generated empty only if it does not exist. Place here your code You wish.


2. For every unit with form, additional file <UnitName>_1.inc is generated automatically. You should never change it manually.

3. File uses.inc also is generated automatically and You should not alter it manually. It contains word 'uses' only, included to final code via directive {$I uses.inc}. 

	XI. MAINTAINANCE
  For backup / copy purposes, following files are necessary to be stored to restore your project later or in another directory (on another PC):
  <YourProject>.dpr
  <YourProject>_1.dpr - if You altered it
  <YourProject>_3.dpr - if You altered it
  <YourProject>_4.dpr - if You altered it
  <YourProject>.res   - if You use app icon and altered it
  <YourUnit>.pas      - for every unit
  <YourUnit>.dfm      - for every unit with form
  <YourProject>.cfg
  <YourProject>.dof
  other files, created specially for a project (*.rc;*.res;*.bmp;*.ico; etc.)

Files could be recreated, but desired for backup / copy:
  <YourProject>_0.inc
  <YourProject>_2.inc
  <YourUnit>_1.inc    - for every unit
  <YourProject>.dsk
  <YourProject>.drc

And following files You are free to remove any time You wish:
  *.dcu; *.~*; *.$$$; *.exe [ :) ]

	##############################
	#                            #
#########  XII. W A R N I N I N G S  ###########
	#                            #
	##############################

1. Never drop TKOLProject (and other KOL mirror components) on a form of normal VCL project. Never drop VCL controls onto MCK forms (though non-visual components are allowed). In both cases TKOLForm / TKOLProject components become locked and not functioning. To unlock these, You should first remove all VCL controls from the form, and then change Locked property to False for locked component(s).
2. Do not touch in converted project units all between automatically generated {$IF[N]DEF}...{$ENDIF}.
3. Don't edit automatically generated inc-files.
4. If You turned on console (property TKOLProject.ConsoleOut), NEVER CLOSE it. Instead, assign False to this property again.
5. Store mirror KOL projects at least in other folder(s), than usual VCL projects.
6. If anything will be damaged on Your computer, remember, that author of this software IS NOT RESPONSIBLE for such loss IN ANY WAY.

	XIII. RESOLVING PROBLEMS

1. If you had no success installing MCK, read INSATALLATION INSTRUCTIONS carefully. E.g., take in attention, what package you install: may be, you have another Delphi version.
2. There are no problem with installing MCK in Delphi, no matter, what Delphi edition you use (e.g., Enterprise or Personal). You still have problems? Read instruction, please.
3. If you receive a message what ToolsApi or DsgnIntf not found, some syntax errors are found (though you did not yet write any code) or something similar occur: please read section "STARTING NEW KOL MIRROR PROJECT" carefully once again. May be, the reason is that you try to compile and run source project, though destination one should be opened instead, obtained in result of executing items 1 to 7.
4. Something more is not OK? May be, you missed something reading instructions, sorry.
5. Yes, certainly, any thing can have place. Try to do an experiment in ideal circumstances: install Delpi again (or on another PC), and try to do all exactly as it is said in instructions, step by step. Sure, all must be OK.
6. Just in case: system.dcu replacement package files must not be installed together with other files of KOL and MCK. Place it in another directory, please.



-----------------------------------------------------------------
http://bonanzas.rinet.ru OR http://xcl.cjb.net
bonanzas@online.sinor.ru OR bonanzas@xcl.cjb.net

-----------------------------------------------------------------
(C) 2000-2002, Vladimir Kladov. All rights reserved.