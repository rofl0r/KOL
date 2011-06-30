ActiveKOL package v2.0.160 (12-Jan-2003).
Copyright (C) by Vladimir Kladov.

Content:
  ActiveKOL.pas
  KOLComObj.pas
  TLB2KOL.exe (TLB unit converter)
  Tlb2KolSrc.zip (TLB converter source)
  License.txt
  ActiveKOL_readme.txt (this file)

This is a package to extend projects made under Delphi with KOL (Key Objects Library, (C) by Vladimir Kladov, 2001) with capability to include ActiveX components on KOL forms. The main purpose of KOL is creating small executables, but direct usage of ActiveX controls requires including some units (classes, etc.), which increase size of the application up to 360K again. To solve this, necessary code was extracted from OleCtrls, ComObj and other units and adaptated to use with KOL controls by as much natively way as possible. 
  This version of the package is not visual. It requires at least KOL version 0.87 (to get it, download KOL v0.85, and apply updates to v0.86 and then to v0.87, using Updater.exe utility). Also, KOL_ERR package v3.0.87 or higher needed. Though, this version 1.1.106 is released together with KOL/MCK v1.06 and it is recommended to have the last version of KOL and MCK to work with ActiveKOL package.
  ActiveKOL allows to create applications, containing ActiveX controls, with executable size is starting from 43,5K or less under Delphi5 (when system.dcu replacement used). Delphi7, Delphi6, Delphi5, Delphi4 and Delphi3 versions are supported.Delphi2 will not be supported (it has not available tools to import and use ActiveX control).

HISTORY

- In v1.1.106, events handling fixed (by Alexey Izyumov).
- In v2.0.160, Variants used for case of Delphi6 and higher.

INSTALLATION

- extract files to KOL installation directory (KOL v0.87 should be installed already).
- it is possible to add TLB2KOL utility to a list of Delphi tools (Tools|Configure Tools).

USAGE

- first, import ActiveX control as usual (Component|Import ActiveX Control).
It is not necessary to install ActiveX control imported to Component Palette, so click button Create units, not Install.
- second, run TLB2KOL utility and convert all imported xxxx_TLB.pas units to xxxx_TLBKOL.pas units.
- add a reference to the imported unit in "uses" clause of the unit.
- declare a variable (global or where You wish to do it available). E.g., when You import and use DHTMLEDLib_TLBKOL.pas, You can find control TDHTMLEdit there, derived from TOleCtl. So, your variable should be of type PDHTMLEdit.
- write a code to construct the ActiveX control. E.g.:

  var DHTML: PDHTMLEdit;

  new( DHTML, CreateParented( Form ) );

- then, write a code to change some properties of your control. E.g.
 
  var Path: OleVariant;

  DHTML.SetAlign( caClient );
  DHTML.BrowseMode := FALSE;
  Path := 'http://xcl.cjb.net'; // or, use local path, e.g. 'E:\KOL\index.html'
  DHTML.LoadURL( Path );

This code should work in D5.

OTHER NOTES:

- there is a problem with Code Completion feature under D4 and D5. While trying to complete names from TOleCtl descendant object, CC failed usually with AV (read 00000000 at 00000000). Don't matter. See to a declaration of the object in converted TLB unit, and write code manually.

- When converting some tlb's using convert utility provided, it is possible, that a compiler detect an error 'Identifier redeclared' for some events or fields, when resulting unit will be compiled. Just find identifiers, which are conflicting, and rename it. E.g. FOnClick to FOnClick1 (everywhere in the unit).

- You can use ActiveX controls with MCK projects (MCK - Mirror Classes Kit). But now, not visually. Just write constructing code in OnFormCreate event handler. Capability to use ActiveX controls in visual MCK projects visually will be added later (may be).

- To compile Tlb2Kol, MCK and Delphi5 needed. If You find what should be changed in Tlb2Kol project, or in supplied sources, give me know, please.

------------------------------------------
http://xcl.cjb.net 
mailt: bonanzas@xcl.cjb.net


