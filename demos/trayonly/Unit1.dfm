object Form1: TForm1
  Left = 246
  Top = 107
  Width = 399
  Height = 276
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
  object KOLProject1: TKOLProject
    Locked = False
    projectName = 'DemoTrayOnly'
    projectDest = 'DemoTrayOnly'
    sourcePath = 'E:\KOL\Demos\DemoTrayOnly\'
    outdcuPath = 'E:\KOL\Demos\DemoTrayOnly\'
    dprResource = False
    protectFiles = True
    showReport = False
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
    Left = 24
    Top = 152
  end
  object KOLForm1: TKOLForm
    Caption = 'Form1'
    Visible = False
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
    Font.FontCharset = 1
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
    EraseBackground = False
    supportMnemonics = False
    Left = 96
    Top = 152
  end
  object TrayIcon1: TKOLTrayIcon
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000700000000000000000000000000000070000000000000000000000
      0000000000000700000000700000000000000000700700700700007000000000
      0000000000700007000000700000000000007070007000070000007000000000
      0000000000700007000000700000000000000700007000070000007000000000
      0000000000700007000000700000000007000000007000070000007000000000
      0000000000700007000000700000000700000000007000070000007000000000
      0000000000700007000000700000000000000000007000070000007000000000
      0000000000700007000000700000000000000700007000070000007000000000
      0000000000700007000000700000000000007070007000070000007000000000
      0000000070070000070000700000000000000000000000700000007000000000
      0000000000000000000000700000000000000000000000070000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9C1F009F980F009F98871F9F90C31F9F91
      E31F9F11E31F9F31E31F9E31E31F9C71E31F88F1E31F81F1E31F81F1E31F91F1
      E31F98F1E31F9C71E31F9E31E31F9F31E31F9F11E31F9F90E31F9F98C71F9F9C
      0F1F9F9E0F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Active = True
    Tooltip = 'Right mouse click to close DemoTrayOnly'
    AutoRecreate = True
    OnMouse = TrayIcon1Mouse
    Left = 168
    Top = 152
  end
  object KOLApplet1: TKOLApplet
    Caption = 'DemoTrayOnly'
    Visible = False
    Left = 24
    Top = 96
  end
  object PopupMenu1: TKOLPopupMenu
    showShortcuts = True
    Left = 168
    Top = 96
    ItemCount = 2
    Item0Name = 'N2'
    Item0Caption = 'Minimize me'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioItem = False
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'PopupMenu1N2Menu'
    Item0SubItemCount = 0
    Item1Name = 'N1'
    Item1Caption = 'Close me'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioItem = False
    Item1Separator = False
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1OnMenu = 'PopupMenu1N1Menu'
    Item1SubItemCount = 0
  end
end
