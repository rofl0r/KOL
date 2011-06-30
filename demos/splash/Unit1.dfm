object Form1: TForm1
  Left = 208
  Top = 124
  Width = 362
  Height = 309
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
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TKOLMemo
    Tag = 0
    Left = 6
    Top = 6
    Width = 342
    Height = 270
    HelpContext = 0
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
    Text.Strings = (
      'To create splash form:'
      
        '1. Add new form to a project (File|New Form, save it and drop TK' +
        'OLForm component on it).'
      
        '2. Remove this form from auto-create sequence ( Project|Options|' +
        'Forms...|[>] ).'
      
        '3. Add a code, which creates and shows splash form, in OnFormCre' +
        'ate of the main form.'
      
        '4. It is a good idea to make main form initially ivisible, and m' +
        'ake it visible after the finishing initialization process.')
    TextAlign = taLeft
    TabStop = True
    Options = [eo_NoHScroll]
    HasBorder = True
    EditTabChar = False
  end
  object KOLProject1: TKOLProject
    Locked = False
    Localizy = False
    projectName = 'DemoSplash'
    projectDest = 'DemoSplash'
    sourcePath = 'C:\KOL\Demos\DemoSplash\'
    outdcuPath = 'C:\KOL\Demos\DemoSplash\'
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
    Left = 44
    Top = 32
  end
  object KOLForm1: TKOLForm
    Caption = 'Form1'
    Visible = False
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
    DoubleBuffered = False
    PreventResizeFlicks = False
    Transparent = False
    AlphaBlend = 255
    Border = 6
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
    Left = 92
    Top = 32
  end
end
