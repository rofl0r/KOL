object fmFileFilterEditor: TfmFileFilterEditor
  Left = 228
  Top = 107
  Width = 452
  Height = 193
  Caption = 'fmFileFilterEditor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object StringGrid1: TStringGrid
    Left = 6
    Top = 8
    Width = 429
    Height = 120
    ColCount = 2
    DefaultColWidth = 204
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 50
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowMoving, goEditing, goAlwaysShowEditor, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 0
    Visible = False
  end
  object Button1: TButton
    Left = 272
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 360
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    Visible = False
    OnClick = Button2Click
  end
end
