object PainterEffectsForm: TPainterEffectsForm
  Left = 480
  Top = 153
  BorderStyle = bsToolWindow
  Caption = 'Painter Effects'
  ClientHeight = 303
  ClientWidth = 180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object EffectsPanel: TPanel
    Left = 0
    Top = 0
    Width = 180
    Height = 303
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 137
      Top = 267
      Width = 26
      Height = 13
      Caption = 'rot cx'
    end
    object Label2: TLabel
      Left = 137
      Top = 284
      Width = 26
      Height = 13
      Caption = 'rot cy'
    end
    object Label3: TLabel
      Left = 137
      Top = 247
      Width = 18
      Height = 13
      Caption = 'turb'
    end
    object EBar: TScrollBar
      Left = 152
      Top = 7
      Width = 16
      Height = 176
      Kind = sbVertical
      PageSize = 0
      TabOrder = 0
      OnChange = EBarChange
    end
    object ExtraBar: TScrollBar
      Left = 13
      Top = 247
      Width = 118
      Height = 12
      Max = 300
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 1
      OnChange = EBarChange
    end
    object ETree: TTreeView
      Left = 13
      Top = 7
      Width = 131
      Height = 228
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideSelection = False
      HotTrack = True
      Indent = 19
      ParentFont = False
      TabOrder = 2
      OnClick = ETreeClick
      Items.Data = {
        1D000000210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
        08436F6E7472617374230000000100000000000000FFFFFFFFFFFFFFFF000000
        00000000000A53617475726174696F6E230000000200000000000000FFFFFFFF
        FFFFFFFF00000000000000000A4272696768746E6573731D000000FFFFFFFF00
        000000FFFFFFFFFFFFFFFF000000000200000004426C75722600000003000000
        00000000FFFFFFFFFFFFFFFF00000000000000000D476175737369616E20426C
        7572230000000400000000000000FFFFFFFFFFFFFFFF00000000000000000A53
        706C697420426C75721E000000FFFFFFFF00000000FFFFFFFFFFFFFFFF000000
        0002000000054E6F6973651E0000000500000000000000FFFFFFFFFFFFFFFF00
        0000000000000005436F6C6F721D0000000600000000000000FFFFFFFFFFFFFF
        FF0000000000000000044D6F6E6F1F0000000700000000000000FFFFFFFFFFFF
        FFFF000000000000000006536D6F6F7468210000000800000000000000FFFFFF
        FFFFFFFFFF0000000000000000085365616D6C6573731F000000090000000000
        0000FFFFFFFFFFFFFFFF0000000000000000064D6F736169631E0000000A0000
        0000000000FFFFFFFFFFFFFFFF0000000000000000055477697374200000000B
        00000000000000FFFFFFFFFFFFFFFF000000000000000007466973686579651D
        000000FFFFFFFF