object Form1: TForm1
  Left = 192
  Top = 107
  AutoScroll = False
  Caption = 'Открой Пароль V'
  ClientHeight = 54
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000008080000000000
    0000000000000000808080808000000000000000000000080808080808000000
    8000008080800080808080808080000808080808080800080808080808000080
    8080808080808080808080808080080808080808080808080808080008088080
    8080808080808080808080000080080808080808080808080808080008080080
    8080808080808080808080808080000000000000000800080808080808000000
    00000000008000808000000080800000000000000000000800BBBBB008000000
    0000000000000000BBBBBBBBB0000000000000000000000BBBBBBBBBBB000000
    880008888008000BBBBBBBBBBB000000000000000000008BBBBBBB000BB000BB
    BBBBBBBBBBBBBBBBBBBBB00000B00BBBBBBBBBBBBBBBBBBBBBBBB00000B00BBB
    BBBBBBBBBBBBBBBBBBBBB08880B0000000000000000B00BBBBBBBB000BB00000
    00000000000B000BBBBBBBBBBB000000000000000000000BBBBBBBBBBB000000
    0000000000000000BBBBBBBBB0000000000000000000000000BBBBB000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFEBFFFFFF557FFFFEAABF7D5D555EAAAEAABD555
    5555AAAAAABA5555557DAAAAAABAD5555555FFFEEAABFFFDD415FFFFE003FFFF
    E003F384C001E0004001C000000080000038000000380000000080000000FFFC
    4001FFFCC001FFFFE003FFFFF007FFFFFC1FFFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PassEd: TKOLEditBox
    Tag = 0
    Left = 10
    Top = 10
    Width = 241
    Height = 21
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
    parentFont = False
    EraseBackground = False
    Transparent = False
    Options = [eoReadonly]
    TabStop = True
    TextAlign = taLeft
    autoSize = False
    HasBorder = True
    EditTabChar = False
  end
  object CopyRightL: TKOLLabel
    Tag = 0
    Left = 74
    Top = 41
    Width = 193
    Height = 13
    TabOrder = -1
    PlaceDown = False
    PlaceRight = False
    PlaceUnder = False
    Visible = True
    Enabled = True
    DoubleBuffered = False
    Align = caNone
    CenterOnParent = False
    Caption = 'CopyRight 1984-2001 MacroHard Corp.'
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clBlue
    Font.FontStyle = []
    Font.FontHeight = -11
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'MS Sans Serif'
    Font.FontOrientation = 0
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = False
    EraseBackground = False
    Transparent = False
    TextAlign = taLeft
    VerticalAlign = vaTop
    wordWrap = False
    autoSize = False
  end
  object KOLProject1: TKOLProject
    Locked = False
    projectName = 'OpenPass'
    projectDest = 'OpenPass'
    sourcePath = 'F:\MyProgram\KOL\Открой Пароль KOL\'
    outdcuPath = 'F:\MyProgram\KOL\Открой Пароль KOL\'
    dprResource = False
    protectFiles = True
    showReport = False
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
  end
  object KOLForm1: TKOLForm
    Icon = 'ZFORM1_MHABOUTDIALOG1'
    Caption = 'Открой Пароль V'
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
    OnFormCreate = KOLForm1FormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 32
  end
  object Timer1: TKOLTimer
    Interval = 1
    Enabled = True
    OnTimer = Timer1Timer
    Left = 64
  end
  object MainMenu1: TKOLMainMenu
    showShortcuts = True
    Left = 96
    ItemCount = 1
    Item0Name = 'N1'
    Item0Caption = '&Справка'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioItem = False
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'KOLForm1N1Menu'
    Item0SubItemCount = 1
    Item0SubItem0Name = 'N2'
    Item0SubItem0Caption = '&О программе...'
    Item0SubItem0Enabled = True
    Item0SubItem0Visible = True
    Item0SubItem0Checked = False
    Item0SubItem0RadioItem = False
    Item0SubItem0Separator = False
    Item0SubItem0Accelerator = 0
    Item0SubItem0Bitmap = ()
    Item0SubItem0OnMenu = 'KOLForm1N2Menu'
    Item0SubItem0SubItemCount = 0
  end
  object MHAboutDialog1: TKOLMHAboutDialog
    Title = 'О программе "Открой Пароль"'
    CopyRight = 'CopyRight 1984-2002 MacroHard Corp.'
    Text = 'Открой Пароль'
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000000020000000000000000000000000000000000000000
      0000000080000080000000808000800000008000800080800000C0C0C0008080
      80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000008080000000000
      0000000000000000808080808000000000000000000000080808080808000000
      8000008080800080808080808080000808080808080800080808080808000080
      8080808080808080808080808080080808080808080808080808080008088080
      8080808080808080808080000080080808080808080808080808080008080080
      8080808080808080808080808080000000000000000800080808080808000000
      00000000008000808000000080800000000000000000000800BBBBB008000000
      0000000000000000BBBBBBBBB0000000000000000000000BBBBBBBBBBB000000
      880008888008000BBBBBBBBBBB000000000000000000008BBBBBBB000BB000BB
      BBBBBBBBBBBBBBBBBBBBB00000B00BBBBBBBBBBBBBBBBBBBBBBBB00000B00BBB
      BBBBBBBBBBBBBBBBBBBBB08880B0000000000000000B00BBBBBBBB000BB00000
      00000000000B000BBBBBBBBBBB000000000000000000000BBBBBBBBBBB000000
      0000000000000000BBBBBBBBB0000000000000000000000000BBBBB000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFEBFFFFFF557FFFFEAABF7D5D555EAAAEAABD555
      5555AAAAAABA5555557DAAAAAABAD5555555FFFEEAABFFFDD415FFFFE003FFFF
      E003F384C001E0004001C000000080000038000000380000000080000000FFFC
      4001FFFCC001FFFFE003FFFFF007FFFFFC1FFFFFFFFFFFFFFFFFFFFFFFFF}
    IconType = itApplication
    Left = 128
  end
  object MHXP1: TKOLMHXP
    AppName = 'MacroHard Corp. OpenPass'
    Description = 'OpenPass'
    Left = 160
  end
end
