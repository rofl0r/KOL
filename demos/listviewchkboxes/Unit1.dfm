object Form1: TForm1
  Left = 507
  Top = 362
  Width = 268
  Height = 270
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TKOLListView
    Tag = 0
    Left = 8
    Top = 8
    Width = 241
    Height = 201
    TabOrder = 0
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
    Font.FontHeight = -11
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = True
    OnMouseDown = ListView1MouseDown
    EraseBackground = False
    Transparent = False
    Style = lvsDetail
    Options = [lvoGridLines, lvoRowSelect]
    ImageListSmall = ImageList1
    OnKeyDown = ListView1KeyDown
    LVCount = 0
    LVTextBkColor = clWindow
    LVBkColor = clWindow
    HasBorder = True
    TabStop = True
  end
  object Panel1: TKOLPanel
    Tag = 0
    Left = 8
    Top = 216
    Width = 241
    Height = 24
    TabOrder = 2
    PlaceDown = False
    PlaceRight = False
    PlaceUnder = False
    Visible = True
    Enabled = True
    DoubleBuffered = False
    Align = caNone
    CenterOnParent = False
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
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Transparent = False
    TextAlign = taLeft
    edgeStyle = esLowered
    VerticalAlign = vaTop
    Border = 2
    MarginTop = 0
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    object Button1: TKOLButton
      Tag = 0
      Left = 2
      Top = 1
      Width = 238
      Height = 22
      TabOrder = 0
      PlaceDown = False
      PlaceRight = False
      PlaceUnder = False
      Visible = True
      Enabled = True
      DoubleBuffered = False
      Align = caNone
      CenterOnParent = False
      Caption = 'Demonstrate'
      Ctl3D = True
      Color = clBtnFace
      parentColor = False
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = -11
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'MS Sans Serif'
      Font.FontOrientation = 0
      Font.FontCharset = 0
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = Button1Click
      EraseBackground = False
      TextAlign = taCenter
      VerticalAlign = vaCenter
      TabStop = True
      LikeSpeedButton = False
      autoSize = False
    end
  end
  object KOLProject1: TKOLProject
    Locked = False
    projectName = 'DemoListView'
    projectDest = 'DemoListView'
    sourcePath = 'E:\Delphi\Work\ListView\KolListView\'
    outdcuPath = 'E:\Delphi\Work\ListView\KolListView\'
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
    Left = 8
    Top = 256
  end
  object KOLForm1: TKOLForm
    Caption = 'Form1'
    Visible = True
    Locked = False
    formUnit = 'Unit1'
    formMain = True
    Enabled = True
    Tabulate = False
    TabulateEx = False
    defaultSize = False
    defaultPosition = False
    HasBorder = True
    HasCaption = True
    StayOnTop = False
    CanResize = False
    CenterOnScreen = False
    Ctl3D = True
    WindowState = wsNormal
    minimizeIcon = True
    maximizeIcon = False
    closeIcon = True
    Color = clBtnFace
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = -11
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
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
    OnFormCreate = KOLForm1FormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 40
    Top = 256
  end
  object ImageList1: TKOLImageList
    ImgWidth = 15
    ImgHeight = 15
    Count = 2
    bitmap.Data = {
      66010000424D660100000000000076000000280000001E0000000F0000000100
      040000000000F000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
      1111111111111111110010000000000000110000000000000100100000000000
      0011000000000000010010011111111100110011111111100100100111111111
      0011001119111110010010011111111100110011999111100100100111111111
      0011001999991110010010011111111100110019919991100100100111111111
      0011001911199910010010011111111100110011111199100100100111111111
      0011001111111910010010011111111100110011111111100100100000000000
      0011000000000000010010000000000000110000000000000100111111111111
      11111111111111111100}
    TransparentColor = clMaroon
    systemimagelist = False
    Colors = ilcColor4
    Masked = True
    BkColor = clNone
    Left = 72
    Top = 256
  end
  object Timer1: TKOLTimer
    Interval = 100
    Enabled = False
    OnTimer = Timer1Timer
    Left = 104
    Top = 256
  end
end
