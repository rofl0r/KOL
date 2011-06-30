object Form1: TForm1
  Left = 60
  Top = 144
  Width = 722
  Height = 300
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TKOLPanel
    Tag = 0
    Left = 2
    Top = 2
    Width = 710
    Height = 45
    HelpContext = 0
    IgnoreDefault = False
    TabOrder = 1
    MinWidth = 0
    MinHeight = 0
    MaxWidth = 0
    MaxHeight = 0
    PlaceDown = False
    PlaceRight = False
    PlaceUnder = False
    Visible = True
    Enabled = True
    DoubleBuffered = False
    Align = caTop
    CenterOnParent = False
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 0
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    TextAlign = taLeft
    edgeStyle = esRaised
    VerticalAlign = vaTop
    Border = 2
    MarginTop = 0
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    object Button1: TKOLButton
      Tag = 0
      Left = 8
      Top = 16
      Width = 203
      Height = 20
      HelpContext = 0
      IgnoreDefault = True
      TabOrder = 0
      MinWidth = 0
      MinHeight = 0
      MaxWidth = 0
      MaxHeight = 0
      PlaceDown = False
      PlaceRight = False
      PlaceUnder = False
      Visible = True
      Enabled = True
      DoubleBuffered = False
      Align = caNone
      CenterOnParent = False
      Caption = 'Print with PageSetupDialog'
      Ctl3D = True
      Color = clBtnFace
      parentColor = False
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 0
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = Button1Click
      EraseBackground = False
      Localizy = loForm
      TextAlign = taCenter
      VerticalAlign = vaCenter
      TabStop = True
      LikeSpeedButton = False
      autoSize = True
      DefaultBtn = False
      CancelBtn = False
    end
    object Button2: TKOLButton
      Tag = 0
      Left = 432
      Top = 16
      Width = 175
      Height = 20
      HelpContext = 0
      IgnoreDefault = True
      TabOrder = 1
      MinWidth = 0
      MinHeight = 0
      MaxWidth = 0
      MaxHeight = 0
      PlaceDown = False
      PlaceRight = False
      PlaceUnder = False
      Visible = True
      Enabled = True
      DoubleBuffered = False
      Align = caNone
      CenterOnParent = False
      Caption = 'Print with default printer'
      Ctl3D = True
      Color = clBtnFace
      parentColor = False
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 0
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = Button2Click
      EraseBackground = False
      Localizy = loForm
      TextAlign = taCenter
      VerticalAlign = vaCenter
      TabStop = True
      LikeSpeedButton = False
      autoSize = True
      DefaultBtn = False
      CancelBtn = False
    end
    object CheckBox1: TKOLCheckBox
      Tag = 0
      Left = 608
      Top = 16
      Width = 94
      Height = 20
      HelpContext = 0
      IgnoreDefault = False
      TabOrder = 2
      MinWidth = 0
      MinHeight = 0
      MaxWidth = 0
      MaxHeight = 0
      PlaceDown = False
      PlaceRight = False
      PlaceUnder = False
      Visible = True
      Enabled = True
      DoubleBuffered = False
      Align = caNone
      CenterOnParent = False
      Caption = 'Print to file'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 0
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = False
      TabStop = True
      autoSize = True
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
    object Button3: TKOLButton
      Tag = 0
      Left = 248
      Top = 16
      Width = 161
      Height = 20
      HelpContext = 0
      IgnoreDefault = True
      TabOrder = 3
      MinWidth = 0
      MinHeight = 0
      MaxWidth = 0
      MaxHeight = 0
      PlaceDown = False
      PlaceRight = False
      PlaceUnder = False
      Visible = True
      Enabled = True
      DoubleBuffered = False
      Align = caNone
      CenterOnParent = False
      Caption = 'Print with PrintDialog'
      Ctl3D = True
      Color = clBtnFace
      parentColor = False
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 0
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = Button3Click
      EraseBackground = False
      Localizy = loForm
      TextAlign = taCenter
      VerticalAlign = vaCenter
      TabStop = True
      LikeSpeedButton = False
      autoSize = False
      DefaultBtn = False
      CancelBtn = False
    end
  end
  object Memo1: TKOLMemo
    Tag = 0
    Left = 2
    Top = 49
    Width = 710
    Height = 222
    HelpContext = 0
    IgnoreDefault = True
    TabOrder = 0
    MinWidth = 0
    MinHeight = 0
    MaxWidth = 0
    MaxHeight = 0
    PlaceDown = False
    PlaceRight = False
    PlaceUnder = False
    Visible = True
    Enabled = True
    DoubleBuffered = False
    Align = caClient
    CenterOnParent = False
    Ctl3D = True
    Color = clWindow
    parentColor = False
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = -12
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Comic Sans MS'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = False
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Text.Strings = (
      'ActiveKOL package v1.1.106 (6-Nov-2001).'
      'Copyright (C) by Vladimir Kladov.'
      ''
      'Content:'
      '  ActiveKOL.pas'
      '  KOLComObj.pas'
      '  TLB2KOL.exe (TLB unit converter)'
      '  Tlb2KolSrc.zip (TLB converter source)'
      '  License.txt'
      '  ActiveKOL_readme.txt (this file)'
      ''
      
        'This is a package to extend projects made under Delphi with KOL ' +
        '(Key Objects Library, (C) by Vladimir Kladov, 2001) with capabil' +
        'ity to include ActiveX components on KOL forms. The main purpose' +
        ' of KOL is creating small executables, but direct usage of Activ' +
        'eX controls requires including some units (classes, etc.), which' +
        ' increase size of the application up to 360K again. To solve thi' +
        's, necessary code was extracted from OleCtrls, ComObj and other ' +
        'units and adaptated to use with KOL controls by as much natively' +
        ' way as possible. '
      
        '  This version of the package is not visual. It requires at leas' +
        't KOL version 0.87 (to get it, download KOL v0.85, and apply upd' +
        'ates to v0.86 and then to v0.87, using Updater.exe utility). Als' +
        'o, KOL_ERR package v3.0.87 or higher needed. Though, this versio' +
        'n 1.1.106 is released together with KOL/MCK v1.06 and it is reco' +
        'mmended to have the last version of KOL and MCK to work with Act' +
        'iveKOL package.'
      
        '  ActiveKOL allows to create applications, containing ActiveX co' +
        'ntrols, with executable size is starting from 43,5K or less unde' +
        'r Delphi5 (when system.dcu replacement used). Delphi5, Delphi4 a' +
        'nd Delphi3 versions are supported. Delphi6 will be supported lat' +
        'er. Delphi2 will not be supported (it has not available tools to' +
        ' import and use ActiveX control).'
      ''
      'HISTORY'
      ''
      '- In v1.1.106, events handling fixed (by Alexey Izyumov).'
      ''
      'INSTALLATION'
      ''
      
        '- extract files to KOL installation directory (KOL v0.87 should ' +
        'be installed already).'
      
        '- it is possible to add TLB2KOL utility to a list of Delphi tool' +
        's (Tools|Configure Tools).'
      ''
      'USAGE'
      ''
      
        '- first, import ActiveX control as usual (Component|Import Activ' +
        'eX Control).'
      
        'It is not necessary to install ActiveX control imported to Compo' +
        'nent Palette, so click button Create units, not Install.'
      
        '- second, run TLB2KOL utility and convert all imported xxxx_TLB.' +
        'pas units to xxxx_TLBKOL.pas units.'
      
        '- add a reference to the imported unit in "uses" clause of the u' +
        'nit.'
      
        '- declare a variable (global or where You wish to do it availabl' +
        'e). E.g., when You import and use DHTMLEDLib_TLBKOL.pas, You can' +
        ' find control TDHTMLEdit there, derived from TOleCtl. So, your v' +
        'ariable should be of type PDHTMLEdit.'
      '- write a code to construct the ActiveX control. E.g.:'
      ''
      '  var DHTML: PDHTMLEdit;'
      ''
      '  new( DHTML, CreateParented( Form ) );'
      ''
      
        '- then, write a code to change some properties of your control. ' +
        'E.g.'
      ' '
      '  var Path: OleVariant;'
      ''
      '  DHTML.SetAlign( caClient );'
      '  DHTML.BrowseMode := FALSE;'
      
        '  Path := '#39'http://xcl.cjb.net'#39'; // or, use local path, e.g. '#39'E:\' +
        'KOL\index.html'#39
      '  DHTML.LoadURL( Path );'
      ''
      'This code should work in D5.'
      ''
      'OTHER NOTES:'
      ''
      
        '- there is a problem with Code Completion feature under D4 and D' +
        '5. While trying to complete names from TOleCtl descendant object' +
        ', CC failed usually with AV (read 00000000 at 00000000). Don'#39't m' +
        'atter. See to a declaration of the object in converted TLB unit,' +
        ' and write code manually.'
      ''
      
        '- When converting some tlb'#39's using convert utility provided, it ' +
        'is possible, that a compiler detect an error '#39'Identifier redecla' +
        'red'#39' for some events or fields, when resulting unit will be comp' +
        'iled. Just find identifiers, which are conflicting, and rename i' +
        't. E.g. FOnClick to FOnClick1 (everywhere in the unit).'
      ''
      
        '- You can use ActiveX controls with MCK projects (MCK - Mirror C' +
        'lasses Kit). But now, not visually. Just write constructing code' +
        ' in OnFormCreate event handler. Capability to use ActiveX contro' +
        'ls in visual MCK projects visually will be added later (may be).'
      ''
      
        '- To compile Tlb2Kol, MCK and Delphi5 needed. If You find what s' +
        'hould be changed in Tlb2Kol project, or in supplied sources, giv' +
        'e me know, please.'
      ''
      '------------------------------------------'
      'http://xcl.cjb.net '
      'mailt: bonanzas@xcl.cjb.net'
      '1'
      '2')
    TextAlign = taLeft
    TabStop = True
    Options = [eo_NoHScroll, eo_NoVScroll, eo_WantReturn]
    HasBorder = True
    EditTabChar = False
    Brush.Color = clWindow
    Brush.BrushStyle = bsSolid
  end
  object KOLProject1: TKOLProject
    Locked = False
    Localizy = False
    projectName = 'Demo'
    projectDest = 'Demo'
    sourcePath = 'C:\KOL\KOLPrintDialogs\Demo\'
    outdcuPath = 'C:\KOL\KOLPrintDialogs\Demo\'
    dprResource = True
    protectFiles = True
    showReport = False
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
    PaintType = ptSchematic
    Left = 280
    Top = 184
  end
  object KOLApplet1: TKOLApplet
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'Demo'
    Visible = True
    AllBtnReturnClick = False
    Left = 344
    Top = 184
  end
  object KOLForm1: TKOLForm
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'Demo'
    Visible = True
    AllBtnReturnClick = False
    Locked = False
    formUnit = 'Unit1'
    formMain = True
    Enabled = True
    Tabulate = False
    TabulateEx = False
    defaultSize = False
    defaultPosition = False
    MinWidth = 0
    MinHeight = 0
    MaxWidth = 0
    MaxHeight = 0
    HasBorder = True
    HasCaption = True
    StayOnTop = False
    CanResize = True
    CenterOnScreen = False
    Ctl3D = True
    WindowState = wsNormal
    minimizeIcon = True
    maximizeIcon = True
    closeIcon = True
    helpContextIcon = False
    HelpContext = 0
    Color = clBtnFace
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 0
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    DoubleBuffered = False
    PreventResizeFlicks = False
    Transparent = False
    AlphaBlend = 255
    Border = 2
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    MarginBottom = 0
    MinimizeNormalAnimated = False
    zOrderChildren = False
    statusSizeGrip = True
    Localizy = False
    OnFormCreate = KOLForm1FormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 312
    Top = 184
  end
  object PageSetupDialog1: TKOLPageSetupDialog
    Tag = 0
    Options = [psdMargins, psdOrientation, psdSamplePage, psdPaperControl, psdPrinterControl, psdHundredthsOfMillimeters, psdUseMargins, psdUseMinMargins]
    AlwaysReset = False
    Left = 376
    Top = 184
  end
  object PrintDialog1: TKOLPrintDialog
    Tag = 0
    FromPage = 1
    ToPage = 12
    MinPage = 1
    MaxPage = 5
    Copies = 10
    Options = [pdCollate, pdPrintToFile, pdPageNums, pdSelection, pdWarning, pdHelp]
    AlwaysReset = False
    Left = 408
    Top = 184
  end
end
