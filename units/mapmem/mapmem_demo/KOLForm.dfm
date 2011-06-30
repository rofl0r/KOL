object Form1: TForm1
  Left = 195
  Top = 133
  AutoScroll = False
  Caption = 'KOLForm'
  ClientHeight = 223
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object ME: TKOLMemo
    Left = 0
    Top = 0
    Width = 396
    Height = 223
    TabOrder = 0
    PlaceDown = False
    PlaceRight = False
    PlaceUnder = False
    Visible = True
    Enabled = True
    DoubleBuffered = False
    Align = caClient
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
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Transparent = False
    Text.Strings = (
      '')
    TextAlign = taLeft
    TabStop = True
    Options = []
    OnChange = MEChange
  end
  object KOLProject: TKOLProject
    Locked = False
    projectName = 'KOLapp'
    projectDest = 'KOLapp'
    sourcePath = 'G:\KIN\PAS\KOLMapMem\'
    outdcuPath = 'G:\KIN\PAS\KOLMapMem\'
    dprResource = False
    protectFiles = True
    showReport = True
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    Left = 16
    Top = 8
  end
  object KOLForm: TKOLForm
    Caption = 'KOLForm'
    Visible = True
    Locked = False
    formUnit = 'KOLForm'
    formMain = True
    Enabled = True
    Tabulate = False
    TabulateEx = False
    defaultSize = False
    defaultPosition = False
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
    Color = clBtnFace
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 0
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    DoubleBuffered = False
    PreventResizeFlicks = False
    Transparent = False
    AlphaBlend = 0
    Border = 2
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    MarginBottom = 0
    MinimizeNormalAnimated = False
    zOrderChildren = False
    OnFormCreate = KOLFormFormCreate
    EraseBackground = False
    Left = 72
    Top = 8
  end
  object MM: TKOLMapMem
    MaxSize = 4096
    MapName = 'Test-MAP'
    MapStrings.Strings = (
      ''
      ''
      'To check memory mapping '
      ''
      'start another instance of this program'
      ''
      'and edit this text.'
      '')
    OnUpdate = MMUpdate
    OnAppListChange = MMAppListChange
    OpenMapWhen = omManual
    Left = 120
    Top = 8
  end
end
