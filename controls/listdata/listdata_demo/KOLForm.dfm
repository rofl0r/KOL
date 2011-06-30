object Form1: TForm1
  Left = 209
  Top = 135
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoScroll = False
  Caption = 'KOLForm'
  ClientHeight = 357
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  Visible = True
  PixelsPerInch = 120
  TextHeight = 16
  object LD: TKOLListData
    Tag = 0
    Left = 2
    Top = 2
    Width = 615
    Height = 353
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
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Transparent = False
    Options = [lvoRowSelect]
    LVCount = 0
    LVTextBkColor = clWindow
    LVBkColor = clWindow
    HasBorder = True
    TabStop = True
    Columns = <
      item
        Alignment = taLeftJustify
        Caption = 'name'
        Width = 50
        FieldName = 'code'
        ReadOnly = False
      end
      item
        Alignment = taRightJustify
        Caption = 'proc'
        Width = 100
        FieldName = 'proc'
        ReadOnly = False
      end
      item
        Alignment = taRightJustify
        Caption = 'term'
        Width = 100
        FieldName = 'term'
        ReadOnly = False
      end
      item
        Alignment = taRightJustify
        Caption = 'debe'
        Width = 150
        FieldName = 'debe'
        ReadOnly = False
      end
      item
        Alignment = taRightJustify
        Caption = 'cred'
        Width = 150
        FieldName = 'cred'
        ReadOnly = False
      end>
    generateConstants = True
    ColCount = 5
    AutoOpen = True
    Query = QR
    ColCount = 0
  end
  object KF: TKOLForm
    Caption = 'KOLForm'
    Visible = True
    Locked = False
    formUnit = 'KOLForm'
    formMain = True
    Enabled = True
    Tabulate = True
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
    statusSizeGrip = True
    EraseBackground = False
    supportMnemonics = False
    Left = 72
    Top = 8
  end
  object KP: TKOLProject
    Locked = False
    projectName = 'KOLapp'
    projectDest = 'KOLapp'
    sourcePath = 'G:\KIN\PAS\KOLTable\'
    outdcuPath = 'G:\KIN\PAS\KOLTable\'
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
    Left = 16
    Top = 8
  end
  object DS: TKOLDataSource
    Tag = 0
    Connection = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=kn.mdb;Persist Secu' +
      'rity Info=False'
    Left = 120
    Top = 8
  end
  object SS: TKOLSession
    Tag = 0
    DataSource = DS
    Left = 168
    Top = 8
  end
  object QR: TKOLQuery
    Tag = 0
    Session = SS
    SQL = 'Select [code],[proc],[term],[debe],[cred] from kb'
    TableName = 'kb'
    Left = 16
    Top = 64
  end
end
