object fmTBEditor: TfmTBEditor
  Left = 162
  Top = 156
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'fmTBEditor'
  ClientHeight = 280
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvButtons: TListView
    Left = 6
    Top = 8
    Width = 165
    Height = 265
    Columns = <
      item
        Caption = 'Button'
      end>
    ShowColumnHeaders = False
    SmallImages = ilImages
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnClose: TButton
    Left = 182
    Top = 8
    Width = 85
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object chkStayOnTop: TCheckBox
    Left = 182
    Top = 40
    Width = 85
    Height = 17
    Caption = 'Stay on top'
    TabOrder = 2
    OnClick = chkStayOnTopClick
  end
  object btnAdd: TButton
    Left = 182
    Top = 72
    Width = 85
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 182
    Top = 104
    Width = 85
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
  end
  object btnUp: TButton
    Left = 182
    Top = 144
    Width = 37
    Height = 25
    Caption = 'Up'
    TabOrder = 5
  end
  object btnDown: TButton
    Left = 230
    Top = 144
    Width = 37
    Height = 25
    Caption = 'Down'
    TabOrder = 6
  end
  object btnPicture: TButton
    Left = 182
    Top = 184
    Width = 85
    Height = 25
    Caption = 'Picture'
    TabOrder = 7
    OnClick = btnPictureClick
  end
  object chkSeparator: TCheckBox
    Left = 182
    Top = 224
    Width = 85
    Height = 17
    Caption = 'Separator'
    TabOrder = 8
  end
  object chkDropDown: TCheckBox
    Left = 182
    Top = 248
    Width = 85
    Height = 17
    Caption = 'Drop down'
    TabOrder = 9
  end
  object ilImages: TImageList
    Left = 92
    Top = 8
  end
  object opDialog1: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 
      'All image files|*.bmp;*.ico;*.wmf;*.gif;*.jpg;*.jpeg|Bitmaps (*.' +
      'bmp)|*.bmp|Icons (*.ico)|*.ico|Metafiles|*.wmf|GIFs (*.gif)|*.gi' +
      'f|JPEGs (*.jpg; *.jpeg)|*.jpg;*.jpeg'
    FilterIndex = 0
    Title = 'Open image'
    Left = 128
    Top = 8
  end
end
