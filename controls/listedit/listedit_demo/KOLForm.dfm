object Form1: TForm1
  Left = 195
  Top = 133
  AutoScroll = False
  Caption = 'KOLForm'
  ClientHeight = 300
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object LE: TKOLListEdit
    Tag = 0
    Left = 0
    Top = 0
    Width = 447
    Height = 300
    TabOrder = 0
    PlaceDown = False
    PlaceRight = False
    PlaceUnder = False
    Visible = True
    Enabled = True
    DoubleBuffered = True
    Align = caClient
    CenterOnParent = False
    Ctl3D = True
    Color = clBtnFace
    parentColor = False
    Font.Color = clPurple
    Font.FontStyle = [fsBold, fsItalic]
    Font.FontHeight = 20
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 204
    Font.FontPitch = fpDefault
    parentFont = False
    EraseBackground = False
    Transparent = False
    Options = [lvoIconLeft, lvoGridLines, lvoCheckBoxes, lvoRowSelect, lvoOneClickActivate, lvoInfoTip, lvoUnderlineHot, lvoMultiWorkares]
    LVCount = 0
    LVTextBkColor = clNone
    LVBkColor = clNone
    Columns = <
      item
        Alignment = taCenter
        Caption = 'Col1'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Col2'
        Width = 60
      end
      item
        Alignment = taLeftJustify
        Caption = 'Col3'
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = 'Col4'
        Width = 60
      end
      item
        Alignment = taLeftJustify
        Caption = 'Col5'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Col6'
        Width = 95
      end>
    ColCount = 6
  end
  object KP: TKOLProject
    Locked = False
    projectName = 'KOLapp'
    projectDest = 'KOLapp'
    sourcePath = 'G:\KIN\PAS\KOLListEdit\'
    outdcuPath = 'G:\KIN\PAS\KOLListEdit\'
    dprResource = False
    protectFiles = True
    showReport = False
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    Left = 8
    Top = 8
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
    AlphaBlend = 255
    Border = 2
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    MarginBottom = 0
    MinimizeNormalAnimated = False
    zOrderChildren = False
    statusSizeGrip = True
    OnFormCreate = KOLFormFormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 48
    Top = 8
  end
end
