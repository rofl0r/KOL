{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Demo' ).SetPosition( 60, 144 ).SetSize( 722, 300 );
  Result.Form.Add2AutoFree( Result );

    Result.PageSetupDialog1 := NewPageSetupDialog(Result.Form,[ psdMargins,psdOrientation,psdSamplePage,psdPaperControl,psdPrinterControl,psdHundredthsOfMillimeters,psdUseMargins,psdUseMinMargins]);
  Result.Form.Add2AutoFree( Result.PageSetupDialog1 );

    Result.PrintDialog1 := NewPrintDialog(Result.Form,[ pdCollate,pdPrintToFile,pdPageNums,pdSelection,pdWarning,pdHelp]);
    Result.PrintDialog1.FromPage :=1;
    Result.PrintDialog1.ToPage :=12;
    Result.PrintDialog1.MinPage :=1;
    Result.PrintDialog1.MaxPage :=5;
    Result.PrintDialog1.Copies :=10;
  Result.Form.Add2AutoFree( Result.PrintDialog1 );
    // Result.Memo1.TabOrder = 0
    Result.Memo1 := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll, eoNoVScroll, eoWantReturn ] ).SetAlign ( caClient );
    Result.Memo1.Color := clWindow;
    Result.Memo1.Font.FontHeight := -12;
    Result.Memo1.Font.FontName := 'Comic Sans MS';
    Result.Memo1.Text := ''
 + 'ActiveKOL package v1.1.106 (6-Nov-2001).'+#13+#10+'Copyright (C) by Vladimir Kladov.'+#13+#10+#13+#10+'C'
 + 'ontent:'+#13+#10+'  ActiveKOL.pas'+#13+#10+'  KOLComObj.pas'+#13+#10+'  TLB2KOL.exe (TLB unit converter)'+#13+#10+' '
 + ' Tlb2KolSrc.zip (TLB converter source)'+#13+#10+'  License.txt'+#13+#10+'  ActiveKOL_readme.txt (t'
 + 'his file)'+#13+#10+#13+#10+'This is a package to extend projects made under Delphi with KOL (Ke'
 + 'y Objects Library, (C) by Vladimir Kladov, 2001) with capability to include Acti'
 + 'veX components on KOL forms. The main purpose of KOL is creating small executabl'
 + 'es, but direct usage of ActiveX controls requires including some units (classes,'
 + ' etc.), which increase size of the application up to 360K again. To solve this, '
 + 'necessary code was extracted from OleCtrls, ComObj and other units and adaptated'
 + ' to use with KOL controls by as much natively way as possible. '+#13+#10+'  This version '
 + 'of the package is not visual. It requires at least KOL version 0.87 (to get it, '
 + 'download KOL v0.85, and apply updates to v0.86 and then to v0.87, using Updater.'
 + 'exe utility). Also, KOL_ERR package v3.0.87 or higher needed. Though, this versi'
 + 'on 1.1.106 is released together with KOL/MCK v1.06 and it is recommended to have'
 + ' the last version of KOL and MCK to work with ActiveKOL package.'+#13+#10+'  ActiveKOL al'
 + 'lows to create applications, containing ActiveX controls, with executable size i'
 + 's starting from 43,5K or less under Delphi5 (when system.dcu replacement used). '
 + 'Delphi5, Delphi4 and Delphi3 versions are supported. Delphi6 will be supported l'
 + 'ater. Delphi2 will not be supported (it has not available tools to import and us'
 + 'e ActiveX control).'+#13+#10+#13+#10+'HISTORY'+#13+#10+#13+#10+'- In v1.1.106, events handling fixed (by Alexe'
 + 'y Izyumov).'+#13+#10+#13+#10+'INSTALLATION'+#13+#10+#13+#10+'- extract files to KOL installation directory (KO'
 + 'L v0.87 should be installed already).'+#13+#10+'- it is possible to add TLB2KOL utility t'
 + 'o a list of Delphi tools (Tools|Configure Tools).'+#13+#10+#13+#10+'USAGE'+#13+#10+#13+#10+'- first, import Ac'
 + 'tiveX control as usual (Component|Import ActiveX Control).'+#13+#10+'It is not necessary '
 + 'to install ActiveX control imported to Component Palette, so click button Create'
 + ' units, not Install.'+#13+#10+'- second, run TLB2KOL utility and convert all imported xxx'
 + 'x_TLB.pas units to xxxx_TLBKOL.pas units.'+#13+#10+'- add a reference to the imported uni'
 + 't in "uses" clause of the unit.'+#13+#10+'- declare a variable (global or where You wish '
 + 'to do it available). E.g., when You import and use DHTMLEDLib_TLBKOL.pas, You ca'
 + 'n find control TDHTMLEdit there, derived from TOleCtl. So, your variable should '
 + 'be of type PDHTMLEdit.'+#13+#10+'- write a code to construct the ActiveX control. E.g.:'+#13+#10
 + ''+#13+#10+'  var DHTML: PDHTMLEdit;'+#13+#10+#13+#10+'  new( DHTML, CreateParented( Form ) );'+#13+#10+#13+#10+'- then,'
 + ' write a code to change some properties of your control. E.g.'+#13+#10+' '+#13+#10+'  var Path: Ol'
 + 'eVariant;'+#13+#10+#13+#10+'  DHTML.SetAlign( caClient );'+#13+#10+'  DHTML.BrowseMode := FALSE;'+#13+#10+'  Path'
 + ' := ''http://xcl.cjb.net''; // or, use local path, e.g. ''E:\KOL\index.html'''+#13+#10+'  DHT'
 + 'ML.LoadURL( Path );'+#13+#10+#13+#10+'This code should work in D5.'+#13+#10+#13+#10+'OTHER NOTES:'+#13+#10+#13+#10+'- there i'
 + 's a problem with Code Completion feature under D4 and D5. While trying to comple'
 + 'te names from TOleCtl descendant object, CC failed usually with AV (read 0000000'
 + '0 at 00000000). Don''t matter. See to a declaration of the object in converted TL'
 + 'B unit, and write code manually.'+#13+#10+#13+#10+'- When converting some tlb''s using convert u'
 + 'tility provided, it is possible, that a compiler detect an error ''Identifier red'
 + 'eclared'' for some events or fields, when resulting unit will be compiled. Just f'
 + 'ind identifiers, which are conflicting, and rename it. E.g. FOnClick to FOnClick'
 + '1 (everywhere in the unit).'+#13+#10+#13+#10+'- You can use ActiveX controls with MCK projects '
 + '(MCK - Mirror Classes Kit). But now, not visually. Just write constructing code '
 + 'in OnFormCreate event handler. Capability to use ActiveX controls in visual MCK '
 + 'projects visually will be added later (may be).'+#13+#10+#13+#10+'- To compile Tlb2Kol, MCK and'
 + ' Delphi5 needed. If You find what should be changed in Tlb2Kol project, or in su'
 + 'pplied sources, give me know, please.'+#13+#10+#13+#10+'---------------------------------------'
 + '---'+#13+#10+'http://xcl.cjb.net '+#13+#10+'mailt: bonanzas@xcl.cjb.net'+#13+#10+'1'+#13+#10+'2'+#13+#10
;
    // Result.Panel1.TabOrder = 1
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 45 );
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Panel1, 'Print with PageSetupDialog' ).SetPosition( 5, 13 ).AutoSize( TRUE );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
      Result.Button2 := NewButton( Result.Panel1, 'Print with default printer' ).SetPosition( 429, 13 ).AutoSize( TRUE );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.CheckBox1.TabOrder = 2
      Result.CheckBox1 := NewCheckBox( Result.Panel1, 'Print to file' ).SetPosition( 605, 13 ).AutoSize( TRUE );
    // Result.Button3.TabOrder = 3
      Result.Button3 := NewButton( Result.Panel1, 'Print with PrintDialog' ).SetPosition( 245, 13 ).SetSize( 161, 20 );
      Result.Button3.OnClick := Result.Button3Click;
    Result.KOLForm1FormCreate( Result );

end;


