object MainForm: TMainForm
  Left = 322
  Top = 100
  Width = 422
  Height = 490
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'GliphLabel Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object EditBox: TKOLEditBox
    Tag = 0
    Left = 52
    Top = 288
    Width = 309
    Height = 22
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
    Ctl3D = True
    Color = clWindow
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
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Text = '091272'
    Options = [eoNumber]
    TabStop = True
    OnChange = EditBoxChange
    TextAlign = taLeft
    autoSize = False
    HasBorder = True
    EditTabChar = False
    Brush.Color = clWindow
    Brush.BrushStyle = bsSolid
  end
  object TextAlign: TKOLGroupBox
    Tag = 0
    Left = 52
    Top = 316
    Width = 89
    Height = 97
    HelpContext = 0
    IgnoreDefault = False
    TabOrder = 8
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
    Caption = 'TextAlign'
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 10
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = False
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Border = 2
    MarginTop = 22
    MarginBottom = 2
    MarginLeft = 2
    MarginRight = 2
    TextAlign = taLeft
    HasBorder = False
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    object otaLeft: TKOLRadioBox
      Tag = 0
      Left = 8
      Top = 16
      Width = 72
      Height = 22
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
      Caption = 'taLeft'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 10
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = otaClick
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = True
      TabStop = True
      autoSize = False
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
    object otaRight: TKOLRadioBox
      Tag = 1
      Left = 8
      Top = 64
      Width = 71
      Height = 22
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
      Align = caNone
      CenterOnParent = False
      Caption = 'taRight'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 10
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = otaClick
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = False
      TabStop = True
      autoSize = False
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
    object otaCenter: TKOLRadioBox
      Tag = 2
      Left = 8
      Top = 40
      Width = 74
      Height = 22
      HelpContext = 0
      IgnoreDefault = False
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
      Caption = 'taCenter'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 10
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = otaClick
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = False
      TabStop = True
      autoSize = False
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
  end
  object VerticalAlign: TKOLGroupBox
    Tag = 0
    Left = 156
    Top = 316
    Width = 89
    Height = 97
    HelpContext = 0
    IgnoreDefault = False
    TabOrder = 8
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
    Caption = 'VerticalAlign'
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 10
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = False
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Border = 2
    MarginTop = 22
    MarginBottom = 2
    MarginLeft = 2
    MarginRight = 2
    TextAlign = taLeft
    HasBorder = False
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    object ovaTop: TKOLRadioBox
      Tag = 0
      Left = 8
      Top = 16
      Width = 72
      Height = 22
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
      Caption = 'vaTop'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 10
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = ovaClick
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = True
      TabStop = True
      autoSize = False
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
    object ovaCenter: TKOLRadioBox
      Tag = 1
      Left = 8
      Top = 40
      Width = 77
      Height = 22
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
      Align = caNone
      CenterOnParent = False
      Caption = 'vaCenter'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 10
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = ovaClick
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = False
      TabStop = True
      autoSize = False
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
    object ovaBottom: TKOLRadioBox
      Tag = 2
      Left = 8
      Top = 64
      Width = 78
      Height = 22
      HelpContext = 0
      IgnoreDefault = False
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
      Caption = 'vaBottom'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 10
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = ovaClick
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      Checked = False
      TabStop = True
      autoSize = False
      HasBorder = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
  end
  object mdvGliphLabel_Date: TKOLmdvGliphLabel
    Tag = 0
    Left = 122
    Top = 60
    Width = 181
    Height = 29
    HelpContext = 0
    IgnoreDefault = False
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
    DoubleBuffered = True
    Align = caNone
    CenterOnParent = False
    Ctl3D = True
    Color = clBlack
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
    EraseBackground = False
    Localizy = loForm
    Alphabet = '0123456789:-'
    TransparentLabel = True
    TransparentColor = clBlack
    Transparent = False
    VerticalAlign = vaCenter
    TextAlign = taCenter
  end
  object mdvGliphLabel_Time: TKOLmdvGliphLabel
    Tag = 0
    Left = 122
    Top = 31
    Width = 181
    Height = 29
    HelpContext = 0
    IgnoreDefault = False
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
    DoubleBuffered = True
    Align = caNone
    CenterOnParent = False
    Ctl3D = True
    Color = clBlack
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
    EraseBackground = False
    Localizy = loForm
    GlyphBitmap.Data = {
      EA0A0000424DEA0A0000000000003604000028000000840000000D0000000100
      080000000000B4060000C30E0000C30E0000000100000000000000000000FFFF
      FF0000D50000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000202020202
      0202000000000000000000000002000000020202020202020000000002020202
      0202020000000000000000000000020000000202020202020200000000020202
      0202020200000000000000000000000200000002020202020202000000000202
      0202020202000000000000000000000000000000000000000000000000000200
      0000000000000200000000000000000000020000020000000000000000000000
      0000000000000002000000000000000000000200000000000000000000020000
      0200000000000000020000000000000000000002000002000000000000000200
      0000000000000000000200000000000000000000000000000000000000000000
      0000020000000000000002000000000000000000000200000200000000000000
      0000000000000000000000020000000000000000000002000000000000000000
      0002000002000000000000000200000000000000000000020000020000000000
      0000020000000000000000000002000000000000000000000000000000000000
      0000000000000200000000000000020000000000000000000002000002000000
      0000000000000000000000000000000200000000000000000000020000000000
      0000000000020000020000000000000002000000000000000000000200000200
      0000000000000200000000000000000000020000000000000000000000000000
      0000000000000000000002000000000000000200000000000000000000020000
      0200000000000000000000000000000000000002000000000000000000000200
      0000000000000000000200000200000000000000020000000000000000000002
      0000020000000000000002000000000000000000000200000000000000000000
      0000000000000000000000000000020000000000000002000000000000000000
      0002000002000000000000000000000000000000000000020000000000000000
      0000020000000000000000000002000002000000000000000200000000000000
      0000000200000200000000000000020000000000000000000002000000000002
      0202000000000000000000000000000000000200000000000000020000000000
      0000000000020000000202020202020200000000020202020202020000000002
      0202020202020200000002020202020202000000000202020202020202000000
      0000000000000002000000020202020202020000000002020202020202020000
      0000000000000000000000000000000000000000000002000000000000000200
      0000000000000000000200000000000000000000020000000000000000000002
      0000020000000000000002000002000000000000000000000200000000000000
      0000000000000000000000020000020000000000000002000002000000000000
      0002000000000000000000000000000000020202020200000000020000000000
      0000020000000000000000000002000000000000000000000200000000000000
      0000000200000200000000000000020000020000000000000000000002000000
      0000000000000000000000000000000200000200000000000000020000020000
      0000000000020000000000020202000000000000000000000000000000000200
      0000000000000200000000000000000000020000000000000000000002000000
      0000000000000002000002000000000000000200000200000000000000000000
      0200000000000000000000000000000000000002000002000000000000000200
      0002000000000000000200000000000000000000000000000000000000000000
      0000020000000000000002000000000000000000000200000000000000000000
      0200000000000000000000020000020000000000000002000002000000000000
      0000000002000000000000000000000000000000000000020000020000000000
      0000020000020000000000000002000000000000000000000000000000000000
      0000000000000200000000000000020000000000000000000002000000000000
      0000000002000000000000000000000200000200000000000000020000020000
      0000000000000000020000000000000000000000000000000000000200000200
      0000000000000200000200000000000000020000000000000000000000000000
      0000000000000000000000020202020202020000000000000000000000020000
      0002020202020202000000000202020202020200000002000000000000000200
      0000020202020202020000000002020202020202000000020202020202020200
      0000000202020202020200000000020202020202020000000000000000000000
      0000000000000000000000000000}
    Alphabet = '0123456789:-'
    TransparentLabel = True
    TransparentColor = clBlack
    Transparent = False
    VerticalAlign = vaCenter
    TextAlign = taCenter
  end
  object mdvGliphLabel: TKOLmdvGliphLabel
    Tag = 0
    Left = 52
    Top = 160
    Width = 309
    Height = 121
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
    Caption = '091272'
    Ctl3D = True
    Color = clNavy
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
    EraseBackground = False
    Localizy = loForm
    Alphabet = '0123456789:-'
    TransparentLabel = True
    TransparentColor = clBlack
    Transparent = False
    VerticalAlign = vaTop
    TextAlign = taLeft
  end
  object cbTransparent: TKOLCheckBox
    Tag = 0
    Left = 260
    Top = 324
    Width = 101
    Height = 22
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
    Align = caNone
    CenterOnParent = False
    Caption = 'Transparent'
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = -11
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = False
    OnClick = cbTransparentClick
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Checked = False
    TabStop = True
    autoSize = False
    HasBorder = False
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    Auto3State = False
  end
  object cbTransparentLabel: TKOLCheckBox
    Tag = 0
    Left = 260
    Top = 352
    Width = 137
    Height = 22
    HelpContext = 0
    IgnoreDefault = False
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
    Caption = 'TransparentLabel'
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = -11
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = False
    OnClick = cbTransparentLabelClick
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Checked = True
    TabStop = True
    autoSize = False
    HasBorder = False
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    Auto3State = False
  end
  object KOLProject: TKOLProject
    Locked = False
    Localizy = False
    projectName = 'GliphLabelDemo'
    projectDest = 'GliphLabelDemo'
    sourcePath = 
      'C:\LANGUAGE\Delphi6\KOL\mdvLib\KOLmdvGliphLabel\KOLmdvGliphLabel' +
      'Demo\'
    outdcuPath = 
      'C:\LANGUAGE\Delphi6\KOL\mdvLib\KOLmdvGliphLabel\KOLmdvGliphLabel' +
      'Demo\'
    dprResource = False
    protectFiles = True
    showReport = False
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
    PaintType = ptWYSIWIG
    ShowHint = False
    Left = 28
    Top = 28
  end
  object KOLForm: TKOLForm
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'GliphLabel Demo'
    Visible = True
    AllBtnReturnClick = False
    Locked = False
    formUnit = 'Main'
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
    borderStyle = fbsSingle
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
    ShowHint = False
    OnFormCreate = KOLFormFormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 28
    Top = 76
  end
  object Timer: TKOLTimer
    Interval = 500
    Enabled = True
    OnTimer = TimerTimer
    Multimedia = False
    Resolution = 0
    Periodic = True
    Left = 344
    Top = 16
  end
end
