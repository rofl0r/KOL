object fmMainGuard: TfmMainGuard
  Left = 188
  Top = 136
  Width = 632
  Height = 433
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'File Guard'
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
  object Panel1: TKOLPanel
    Tag = 0
    Left = 2
    Top = 2
    Width = 620
    Height = 27
    HelpContext = 0
    IgnoreDefault = False
    TabOrder = 1
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
    Align = caTop
    CenterOnParent = False
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 16
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    TextAlign = taLeft
    edgeStyle = esLowered
    VerticalAlign = vaTop
    Border = 2
    MarginTop = 0
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    ShowAccelChar = False
    object lStatus: TKOLLabel
      Tag = 0
      Left = 3
      Top = 3
      Width = 563
      Height = 21
      HelpContext = 0
      IgnoreDefault = False
      TabOrder = -1
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
      Caption = 'Monitored: 0 dirs   Storage: <not set>'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TextAlign = taLeft
      VerticalAlign = vaCenter
      wordWrap = False
      autoSize = True
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
      ShowAccelChar = False
    end
    object bExit: TKOLButton
      Tag = 0
      Left = 568
      Top = 3
      Width = 49
      Height = 21
      HelpContext = 0
      IgnoreDefault = True
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
      Align = caRight
      CenterOnParent = False
      Caption = 'Exit'
      Ctl3D = True
      Color = clBtnFace
      parentColor = False
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      OnClick = bExitClick
      EraseBackground = False
      Localizy = loForm
      TextAlign = taCenter
      VerticalAlign = vaCenter
      TabStop = True
      LikeSpeedButton = False
      autoSize = False
      DefaultBtn = False
      CancelBtn = False
      image.Data = {07544269746D617000000000}
    end
  end
  object tc1: TKOLTabControl
    Tag = 0
    Left = 2
    Top = 31
    Width = 620
    Height = 366
    HelpContext = 0
    IgnoreDefault = False
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
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 16
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Options = [tcoFocusTabs]
    ImageList1stIdx = 0
    Count = 4
    edgeType = esNone
    Border = 2
    MarginTop = 0
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    generateConstants = True
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    object tc1_Tab3: TKOLPanel
      Tag = 0
      Left = 4
      Top = 26
      Width = 612
      Height = 336
      HelpContext = 0
      IgnoreDefault = False
      TabOrder = 3
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
      Align = caNone
      CenterOnParent = False
      Caption = 'About'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TextAlign = taLeft
      edgeStyle = esNone
      VerticalAlign = vaTop
      Border = 2
      MarginTop = 0
      MarginBottom = 0
      MarginLeft = 0
      MarginRight = 0
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
      ShowAccelChar = False
      object lLink: TKOLLabel
        Tag = 0
        Left = 2
        Top = 317
        Width = 608
        Height = 17
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = -1
        MinWidth = 0
        MinHeight = 0
        MaxWidth = 0
        MaxHeight = 0
        Cursor_ = 'IDC_HAND'
        PlaceDown = False
        PlaceRight = False
        PlaceUnder = False
        Visible = True
        Enabled = True
        DoubleBuffered = False
        Align = caBottom
        CenterOnParent = False
        Caption = 'http://bonanzas.rinet.ru'
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clBlue
        Font.FontStyle = [fsUnderline]
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = False
        OnClick = lLinkClick
        OnMouseEnter = lLinkMouseEnter
        OnMouseLeave = lLinkMouseLeave
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taCenter
        VerticalAlign = vaTop
        wordWrap = False
        autoSize = True
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
      end
      object Panel4: TKOLPanel
        Tag = 0
        Left = 2
        Top = 2
        Width = 608
        Height = 47
        HelpContext = 0
        IgnoreDefault = False
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
        Align = caTop
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esLowered
        VerticalAlign = vaTop
        Border = 2
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object ImageShow1: TKOLImageShow
          Tag = 0
          Left = 3
          Top = 3
          Width = 64
          Height = 41
          HelpContext = 0
          IgnoreDefault = False
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
          Align = caLeft
          CenterOnParent = False
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          ImageListNormal = ImageList2
          CurIndex = 0
          Transparent = True
          HasBorder = False
          autoSize = False
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
        end
        object Panel5: TKOLPanel
          Tag = 0
          Left = 69
          Top = 3
          Width = 536
          Height = 41
          HelpContext = 0
          IgnoreDefault = False
          TabOrder = 1
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
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          TextAlign = taLeft
          edgeStyle = esNone
          VerticalAlign = vaTop
          Border = 0
          MarginTop = 0
          MarginBottom = 0
          MarginLeft = 0
          MarginRight = 0
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          ShowAccelChar = False
          object LabelEffect1: TKOLLabelEffect
            Tag = 0
            Left = 278
            Top = 0
            Width = 285
            Height = 41
            HelpContext = 0
            IgnoreDefault = False
            TabOrder = -1
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
            Align = caLeft
            CenterOnParent = False
            Caption = '   (C) by Vladimir Kladov, 2004'
            Ctl3D = False
            Color = clBtnFace
            parentColor = True
            Font.Color = clBlue
            Font.FontStyle = [fsBold]
            Font.FontHeight = 24
            Font.FontWidth = 0
            Font.FontWeight = 0
            Font.FontName = 'Arial'
            Font.FontOrientation = 0
            Font.FontCharset = 1
            Font.FontPitch = fpDefault
            parentFont = False
            EraseBackground = False
            Localizy = loForm
            Transparent = False
            TextAlign = taLeft
            VerticalAlign = vaBottom
            wordWrap = False
            autoSize = True
            Brush.Color = clBtnFace
            Brush.BrushStyle = bsSolid
            ShowAccelChar = False
            ShadowDeep = 1
            Color2 = clBlack
          end
          object LabelEffect2: TKOLLabelEffect
            Tag = 0
            Left = 0
            Top = 0
            Width = 278
            Height = 41
            HelpContext = 0
            IgnoreDefault = False
            TabOrder = -1
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
            Align = caLeft
            CenterOnParent = False
            Caption = ' File Guard v1.0.1 Beta'
            Ctl3D = False
            Color = clBtnFace
            parentColor = True
            Font.Color = clPurple
            Font.FontStyle = [fsBold]
            Font.FontHeight = 31
            Font.FontWidth = 0
            Font.FontWeight = 0
            Font.FontName = 'Arial'
            Font.FontOrientation = 0
            Font.FontCharset = 1
            Font.FontPitch = fpDefault
            parentFont = False
            EraseBackground = False
            Localizy = loForm
            Transparent = False
            TextAlign = taLeft
            VerticalAlign = vaCenter
            wordWrap = False
            autoSize = True
            Brush.Color = clBtnFace
            Brush.BrushStyle = bsSolid
            ShowAccelChar = False
            ShadowDeep = 2
            Color2 = clBlack
          end
        end
      end
      object Panel6: TKOLPanel
        Tag = 0
        Left = 2
        Top = 51
        Width = 608
        Height = 264
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 1
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
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esNone
        VerticalAlign = vaTop
        Border = 12
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object lDescription_About: TKOLLabel
          Tag = 0
          Left = 12
          Top = 12
          Width = 584
          Height = 240
          HelpContext = 0
          IgnoreDefault = False
          TabOrder = -1
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
          Caption = 'text here'
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          TextAlign = taLeft
          VerticalAlign = vaTop
          wordWrap = True
          autoSize = False
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          ShowAccelChar = False
        end
      end
    end
    object TabControl1_Tab0: TKOLPanel
      Tag = 0
      Left = 4
      Top = 26
      Width = 612
      Height = 336
      HelpContext = 0
      IgnoreDefault = False
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
      Align = caNone
      CenterOnParent = False
      Caption = 'Monitor'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TextAlign = taLeft
      edgeStyle = esNone
      VerticalAlign = vaTop
      Border = 2
      MarginTop = 0
      MarginBottom = 0
      MarginLeft = 0
      MarginRight = 0
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
      ShowAccelChar = False
      object Panel3: TKOLPanel
        Tag = 0
        Left = 2
        Top = 2
        Width = 608
        Height = 31
        HelpContext = 0
        IgnoreDefault = False
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
        Align = caTop
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = True
        TextAlign = taLeft
        edgeStyle = esNone
        VerticalAlign = vaTop
        Border = 2
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object Toolbar1: TKOLToolbar
          Tag = 0
          Left = 2
          Top = 2
          Width = 604
          Height = 26
          HelpContext = 0
          IgnoreDefault = False
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
          Align = caTop
          CenterOnParent = False
          Ctl3D = True
          Color = clBtnFace
          parentColor = False
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = True
          Localizy = loForm
          Transparent = True
          Options = [tboFlat, tboNoDivider]
          bitmap.Data = {
            420C0000424D420C000000000000420000002800000060000000100000000100
            100003000000000C000000000000000000000000000000000000007C0000E003
            00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F001F001F001F001F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F001F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF031F001F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF03FF03FF031F001F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF03FF03FF03FF03FF031F00
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F001F001F001F00FF03FF03FF03FF031F001F001F00
            1F001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F001F001F001F00FF03FF03FF03FF031F001F001F00
            1F001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF03FF03FF03FF03FF031F00
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF03FF03FF031F001F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF031F001F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F00FF03FF03FF03FF031F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F001F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F001F001F001F001F001F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
            1F7C1F7C1F7C}
          buttons = 
            'Add directory to filter'#1'Edit filter'#1'Remove filter'#1'-'#1'Move Up'#1'Move' +
            ' Down'
          noTextLabels = True
          showTooltips = True
          mapBitmapColors = True
          Border = 2
          MarginTop = 0
          MarginBottom = 0
          MarginLeft = 0
          MarginRight = 0
          HasBorder = False
          StandardImagesLarge = False
          generateConstants = True
          TBButtonsMinWidth = 0
          TBButtonsMaxWidth = 0
          HeightAuto = True
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          FixFlatXP = True
          Buttons_Count = 6
          Btn1Name = 'TBAdd'
          Btn1caption = 'Add directory to filter'
          Btn1checked = False
          Btn1dropdown = False
          Btn1enabled = True
          Btn1separator = False
          Btn1tooltip = ''
          Btn1visible = True
          Btn1onClick = 'Toolbar1TBAddClick'
          Btn1picture = ''
          Btn1sysimg = 32
          Btn1imgIndex = 0
          Btn2Name = 'TBEdit'
          Btn2caption = 'Edit filter'
          Btn2checked = False
          Btn2dropdown = False
          Btn2enabled = True
          Btn2separator = False
          Btn2tooltip = ''
          Btn2visible = True
          Btn2onClick = 'Toolbar1TBEditClick'
          Btn2picture = ''
          Btn2sysimg = 19
          Btn2imgIndex = 1
          Btn3Name = 'TBDel'
          Btn3caption = 'Remove filter'
          Btn3checked = False
          Btn3dropdown = False
          Btn3enabled = True
          Btn3separator = False
          Btn3tooltip = ''
          Btn3visible = True
          Btn3onClick = 'Toolbar1TBDelClick'
          Btn3picture = ''
          Btn3sysimg = 6
          Btn3imgIndex = 2
          Btn4Name = 'TB1'
          Btn4caption = '-'
          Btn4checked = False
          Btn4dropdown = False
          Btn4enabled = True
          Btn4separator = True
          Btn4tooltip = ''
          Btn4visible = True
          Btn4onClick = ''
          Btn4picture = ''
          Btn4sysimg = 0
          Btn5Name = 'TBUp'
          Btn5caption = 'Move Up'
          Btn5checked = False
          Btn5dropdown = False
          Btn5enabled = True
          Btn5separator = False
          Btn5tooltip = ''
          Btn5visible = True
          Btn5onClick = 'Toolbar1TBUpClick'
          Btn5picture = 
            'BM'#1094#0#0#0#0#0#0#0'v'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0#4#0#0#0#0#0#1026#0#0#0#0#0#0#0#0#0#0#0#16#0#0#0#0#0#0#0#0#0#0#0#0#0#1026#0#0#1026 +
            #0#0#0#1026#1026#0#1026#0#0#0#1026#0#1026#0#1026#1026#0#0#1026#1026#1026#0#1040#1040#1040#0#0#0#1103#0#0#1103#0#0#0#1103#1103#0#1103#0#0#0#1103#0#1103#0#1103#1103#0#0#1103#1103#1103#0#1069#1069#1069#1069#1069#1069#1069#1069#1069#1069 +
            #1068#1052#1052#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1052 +
            #1052#1086#1086#1052#1052#1069#1069#1068#1086#1086#1086#1086#1053#1069#1069#1069#1054#1086#1086#1084#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1069#1054#1084#1069#1069#1069#1069#1069#1069#1068#1053#1069#1069#1069#1069#1069#1069#1069#1069#1069#1069#1069
          Btn5sysimg = 0
          Btn5imgIndex = 3
          Btn6Name = 'TBDn'
          Btn6caption = 'Move Down'
          Btn6checked = False
          Btn6dropdown = False
          Btn6enabled = True
          Btn6separator = False
          Btn6tooltip = ''
          Btn6visible = True
          Btn6onClick = 'Toolbar1TBDnClick'
          Btn6picture = 
            'BM'#1094#0#0#0#0#0#0#0'v'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0#4#0#0#0#0#0#1026#0#0#0#0#0#0#0#0#0#0#0#16#0#0#0#0#0#0#0#0#0#0#0#0#0#1026#0#0#1026 +
            #0#0#0#1026#1026#0#1026#0#0#0#1026#0#1026#0#1026#1026#0#0#1026#1026#1026#0#1040#1040#1040#0#0#0#1103#0#0#1103#0#0#0#1103#1103#0#1103#0#0#0#1103#0#1103#0#1103#1103#0#0#1103#1103#1103#0#1069#1069#1069#1069#1069#1069#1069#1069#1069#1069 +
            #1069#1068#1053#1069#1069#1069#1069#1069#1069#1054#1084#1069#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1054#1086#1086#1084#1069#1069#1069#1068#1086#1086#1086#1086#1053#1069#1069#1052#1052#1086#1086#1052#1052#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069 +
            #1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1086#1086#1053#1069#1069#1069#1069#1068#1052#1052#1053#1069#1069#1069#1069#1069#1069#1069#1069#1069#1069
          Btn6sysimg = 0
          Btn6imgIndex = 4
          NewVersion = True
        end
      end
      object lv1: TKOLListView
        Tag = 0
        Left = 2
        Top = 35
        Width = 608
        Height = 299
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 1
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
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        OnMouseDblClk = lv1MouseDblClk
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        Style = lvsDetail
        Options = [lvoGridLines, lvoRowSelect, lvoOwnerData]
        ImageListSmall = ImageList1
        ImageListState = ImageList1
        OnKeyDown = lv1KeyDown
        OnLVData = lv1LVData
        LVCount = 0
        LVTextBkColor = clWindow
        LVBkColor = clWindow
        OnLVStateChange = lv1LVStateChange
        HasBorder = True
        TabStop = True
        generateConstants = True
        Brush.Color = clWindow
        Brush.BrushStyle = bsSolid
        Unicode = False
        ColCount = 3
        Column0Name = 'Col1'
        Column0Caption = 'Directory'
        Column0TextAlign = 0
        Column0Width = 315
        Column0WidthType = 0
        Column0LVColImage = -1
        Column1Name = 'Col2'
        Column1Caption = 'Filter'
        Column1TextAlign = 0
        Column1Width = 150
        Column1WidthType = 0
        Column1LVColImage = -1
        Column2Name = 'Col3'
        Column2Caption = 'Time'
        Column2TextAlign = 1
        Column2Width = 50
        Column2WidthType = 0
        Column2LVColImage = -1
      end
    end
    object TabControl1_Tab1: TKOLPanel
      Tag = 0
      Left = 4
      Top = 26
      Width = 612
      Height = 336
      HelpContext = 0
      IgnoreDefault = False
      TabOrder = 1
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
      Align = caNone
      CenterOnParent = False
      Caption = 'Storage'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TextAlign = taLeft
      edgeStyle = esNone
      VerticalAlign = vaTop
      Border = 2
      MarginTop = 0
      MarginBottom = 0
      MarginLeft = 0
      MarginRight = 0
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
      ShowAccelChar = False
      object Panel2: TKOLPanel
        Tag = 0
        Left = 2
        Top = 2
        Width = 608
        Height = 26
        HelpContext = 0
        IgnoreDefault = False
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
        Align = caTop
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esNone
        VerticalAlign = vaTop
        Border = 2
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object eStoragePath: TKOLEditBox
          Tag = 0
          Left = 2
          Top = 2
          Width = 538
          Height = 22
          HelpContext = 0
          IgnoreDefault = False
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
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          Options = []
          TabStop = True
          OnChange = eStoragePathChange
          TextAlign = taLeft
          autoSize = False
          HasBorder = True
          EditTabChar = False
          Brush.Color = clWindow
          Brush.BrushStyle = bsSolid
        end
        object bBrowseStorage: TKOLButton
          Tag = 0
          Left = 542
          Top = 2
          Width = 64
          Height = 22
          HelpContext = 0
          IgnoreDefault = True
          TabOrder = 1
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
          Align = caRight
          CenterOnParent = False
          Caption = 'Browse'
          Ctl3D = True
          Color = clBtnFace
          parentColor = False
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          OnClick = bBrowseStorageClick
          EraseBackground = False
          Localizy = loForm
          TextAlign = taCenter
          VerticalAlign = vaCenter
          TabStop = True
          LikeSpeedButton = False
          autoSize = False
          DefaultBtn = False
          CancelBtn = False
          image.Data = {07544269746D617000000000}
        end
      end
      object Panel7: TKOLPanel
        Tag = 0
        Left = 2
        Top = 30
        Width = 608
        Height = 19
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 1
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
        Align = caTop
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esNone
        VerticalAlign = vaTop
        Border = 2
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object lStorageStatus: TKOLLabel
          Tag = 0
          Left = 2
          Top = 2
          Width = 604
          Height = 15
          HelpContext = 0
          IgnoreDefault = False
          TabOrder = -1
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
          Caption = '   '
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          TextAlign = taLeft
          VerticalAlign = vaTop
          wordWrap = False
          autoSize = True
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          ShowAccelChar = False
        end
      end
      object tvDirs: TKOLTreeView
        Tag = 0
        Left = 2
        Top = 51
        Width = 223
        Height = 283
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 2
        MinWidth = 100
        MinHeight = 0
        MaxWidth = 0
        MaxHeight = 0
        PlaceDown = False
        PlaceRight = False
        PlaceUnder = False
        Visible = True
        Enabled = True
        DoubleBuffered = False
        Align = caLeft
        CenterOnParent = False
        Ctl3D = True
        Color = clWindow
        parentColor = False
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        Options = [tvoLinesRoot]
        ImageListNormal = ImageList3
        CurIndex = 0
        TVRightClickSelect = True
        OnSelChange = tvDirsSelChange
        popupMenu = pm3
        TVIndent = 0
        HasBorder = True
        TabStop = True
        Brush.Color = clWindow
        Brush.BrushStyle = bsSolid
        Unicode = False
      end
      object lvFiles: TKOLListView
        Tag = 0
        Left = 235
        Top = 51
        Width = 375
        Height = 283
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 4
        MinWidth = 100
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
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        OnMouseDblClk = lvFilesMouseDblClk
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        Style = lvsDetail
        Options = [lvoMultiselect, lvoRowSelect, lvoOwnerData]
        ImageListSmall = ImageList3
        OnKeyDown = lvFilesKeyDown
        OnLVData = lvFilesLVData
        LVCount = 0
        LVTextBkColor = clWindow
        LVBkColor = clWindow
        OnLVStateChange = lvFilesLVStateChange
        popupMenu = pm2
        HasBorder = True
        TabStop = True
        generateConstants = True
        Brush.Color = clWindow
        Brush.BrushStyle = bsSolid
        Unicode = False
        ColCount = 4
        Column0Name = 'ColName'
        Column0Caption = 'Name'
        Column0TextAlign = 0
        Column0Width = 145
        Column0WidthType = 0
        Column0LVColImage = -1
        Column1Name = 'ColDate'
        Column1Caption = 'Date'
        Column1TextAlign = 0
        Column1Width = 80
        Column1WidthType = 0
        Column1LVColImage = -1
        Column2Name = 'ColSize'
        Column2Caption = 'Size'
        Column2TextAlign = 1
        Column2Width = 60
        Column2WidthType = 0
        Column2LVColImage = -1
        Column3Name = 'ColUsed'
        Column3Caption = 'Used'
        Column3TextAlign = 1
        Column3Width = 60
        Column3WidthType = 0
        Column3LVColImage = -1
      end
      object Splitter1: TKOLSplitter
        Tag = 0
        Left = 227
        Top = 51
        Width = 6
        Height = 283
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 3
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
        Align = caLeft
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        MinSizePrev = 0
        MinSizeNext = 0
        edgeStyle = esLowered
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
      end
    end
    object TabControl1_Tab2: TKOLPanel
      Tag = 0
      Left = 4
      Top = 26
      Width = 612
      Height = 336
      HelpContext = 0
      IgnoreDefault = False
      TabOrder = 2
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
      Align = caNone
      CenterOnParent = False
      Caption = 'Log'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = []
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 1
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TextAlign = taLeft
      edgeStyle = esNone
      VerticalAlign = vaTop
      Border = 2
      MarginTop = 0
      MarginBottom = 0
      MarginLeft = 0
      MarginRight = 0
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
      ShowAccelChar = False
      object Memo1: TKOLMemo
        Tag = 0
        Left = 2
        Top = 2
        Width = 608
        Height = 306
        HelpContext = 0
        IgnoreDefault = True
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
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        TabStop = True
        Options = [eo_NoHScroll, eo_Readonly]
        HasBorder = True
        EditTabChar = False
        Brush.Color = clWindow
        Brush.BrushStyle = bsSolid
      end
      object pnLogInfo: TKOLPanel
        Tag = 0
        Left = 2
        Top = 310
        Width = 608
        Height = 24
        HelpContext = 0
        IgnoreDefault = False
        TabOrder = 1
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
        Align = caBottom
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = []
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 1
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esLowered
        VerticalAlign = vaTop
        Border = 2
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object cDetailed: TKOLCheckBox
          Tag = 0
          Left = 3
          Top = 3
          Width = 67
          Height = 18
          HelpContext = 0
          IgnoreDefault = False
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
          Align = caLeft
          CenterOnParent = False
          Caption = 'Detailed'
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          Checked = False
          TabStop = True
          autoSize = True
          HasBorder = False
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          Auto3State = False
        end
        object lQueued: TKOLLabel
          Tag = 0
          Left = 596
          Top = 3
          Width = 9
          Height = 18
          HelpContext = 0
          IgnoreDefault = False
          TabOrder = -1
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
          Align = caRight
          CenterOnParent = False
          Caption = '  '
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = []
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = True
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          TextAlign = taLeft
          VerticalAlign = vaTop
          wordWrap = False
          autoSize = True
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          ShowAccelChar = False
        end
      end
    end
  end
  object KOLProject1: TKOLProject
    Locked = False
    Localizy = False
    projectName = 'MirrorKOLPackageD6'
    projectDest = 'FileGuard'
    sourcePath = 'C:\KOL\Prj\FileGuard\'
    outdcuPath = 'C:\KOL\Prj\FileGuard\'
    dprResource = True
    protectFiles = True
    showReport = False
    isKOLProject = False
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
    PaintType = ptWYSIWIG
    ShowHint = False
    Left = 208
    Top = 8
  end
  object TrayIcon1: TKOLTrayIcon
    Icon.Data = {
      0000010002002020000000000000A80C00002600000010101000000000002801
      0000CE0C00002800000020000000400000000100180000000000800C00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008482848482848482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848284848284FFFFFFFFFFFFC6C3
      C684828484828400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000848284848284FFFFFFFFFFFFC6C3C6FFFFFFC6C3
      C6C6C3C6C6C3C684828484828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000848284FFFFFFFFFFFFC6C3C6C6C3C6840000FFFFFFC6C3
      C6840000C6C3C6C6C3C6C6C3C684828484828400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848284FFFFFFC6C3C6C6C3C6840000840000FF0000FFFFFFC6C3
      C6840000840084FF0000C6C3C6C6C3C6C6C3C684828400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000848284FFFFFFC6C3C68400008400000000FFFF00000000FFFFFFFFC6C3
      C6840000FF0000840084FF0000840084C6C3C6C6C3C684828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      848284FFFFFFC6C3C6840000FF00000000FFFF00000000FFFF0000FFFFFFC6C3
      C6840000840084FF0000840084FF0000840084C6C3C6C6C3C684828400000000
      0000000000000000000000000000000000000000000000000000000000848284
      FFFFFFFFFFFF840000FF00000000FFFF00000000FFFF00000000FFFFFFFFC6C3
      C6840000FF0000840084FF0000840084FF0000840084C6C3C6C6C3C684828400
      0000000000000000000000000000000000000000000000000000000000848284
      FFFFFF840000FF00000000FFFF00000000FFFF00000000FFFF0000FFFFFFC6C3
      C6840000840084FF0000840084FF0000840084FF0000848284C6C3C684828400
      0000000000000000000000000000000000000000000000000000848284FFFFFF
      FFFFFFFF00000000FFFF00000000FFFF00000000FFFF00000000FFFFFFFFC6C3
      C6840000FF0000840084FF0000840084FF0000840084FF0000C6C3C684828484
      8284000000000000000000000000000000000000000000000000848284FFFFFF
      8400000000FFFF00000000FFFF00000000FFFF00000000FFFF0000FFFFFFC6C3
      C6840000840084FF0000840084FF0000840084FF0000840084C6C3C6C6C3C684
      8284000000000000000000000000000000000000000000000000848284FFFFFF
      840000FF00000000FFFF00000000FFFF00000000FFFF00000000FFFFFFFFC6C3
      C6840000FF0000840084FF0000840084FF0000840084FF0000848284C6C3C684
      8284000000000000000000000000000000000000000000848284FFFFFFC6C3C6
      FF00000000FFFF00000000FFFF00000000FFFF00000000FFFF0000FFFFFFC6C3
      C6840000840084FF0000840084FF0000840084FF0000840084FF0000C6C3C684
      8284848284000000000000000000000000000000000000848284FFFFFF840000
      840000840000840000840000840000840000840000840000840000FFFFFFC6C3
      C6840000840000840000840000840000840000840000840000840000C6C3C6C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6FFFFFFC6C3
      C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      840000FF0000840084FF0000840084FF0000840084FF0000840084FFFFFFC6C3
      C6840000FF00000000FFFF00000000FFFF00000000FFFF00000000FFFF0000C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      FF0000840084FF0000840084FF0000840084FF0000840084FF0000FFFFFFC6C3
      C68400000000FFFF00000000FFFF00000000FFFF00000000FFFF00000000FFC6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      840000FF0000840084FF0000840084FF0000840084FF0000840084FFFFFFC6C3
      C6840000FF00000000FFFF00000000FFFF00000000FFFF00000000FFFF0000C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      FF0000840084FF0000840084FF0000840084FF0000840084FF0000FFFFFFC6C3
      C68400000000FFFF00000000FFFF00000000FFFF00000000FFFF00000000FFC6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      840000FF0000840084FF0000840084FF0000840084FF0000840084FFFFFFC6C3
      C6840000FF00000000FFFF00000000FFFF00000000FFFF00000000FFFF0000C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      FF0000840084FF0000840084FF0000840084FF0000840084FF0000FFFFFFC6C3
      C68400000000FFFF00000000FFFF00000000FFFF00000000FFFF00000000FFC6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      840000FF0000840084FF0000840084FF0000840084FF0000840084FFFFFFC6C3
      C6840000FF00000000FFFF00000000FFFF00000000FFFF00000000FFFF0000C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      FF0000840084FF0000840084FF0000840084FF0000840084FF0000FFFFFFC6C3
      C68400000000FFFF00000000FFFF00000000FFFF00000000FFFF00000000FFC6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      840000FF0000840000FF0000840000FF0000840084FF0000840084FFFFFFC6C3
      C6840000FF00000000FFFF0000840000840000840000840000840000FF0000C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6840000FF0000840000FF0000FFFFFFC6C3
      C6840000840000840000840000C6C3C6C6C3C6C6C3C6C6C3C6C6C3C6840000C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFC6C3C6
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C6C6C3C6C6C3C6840000FFFFFFC6C3
      C6840000C6C3C6C6C3C6C6C3C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C3C6C6
      C3C6848284000000000000000000000000000000000000848284FFFFFFFFFFFF
      FFFFFF848284848284848284848284FFFFFFFFFFFFFFFFFFC6C3C6FFFFFFC6C3
      C6C6C3C6FFFFFFFFFFFFFFFFFF848284848284848284848284848284FFFFFFFF
      FFFF848284000000000000000000000000000000000000848284FFFFFF848284
      848284000000000000000000000000848284848284848284FFFFFFFFFFFFC6C3
      C6FFFFFF84828484828484828400000000000000000000000000000084828484
      8284848284000000000000000000000000000000000000848284848284000000
      000000000000000000000000000000000000000000000000848284FFFFFFFFFF
      FF84828400000000000000000000000000000000000000000000000000000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008482848482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF7FFFFFFC1FFFFFF007FFFFC001FFFF80
      00FFFF00007FFE00003FFC00001FF800000FF800000FF0000007F0000007F000
      0007E0000003E0000003E0000003E0000003E0000003E0000003E0000003E000
      0003E0000003E0000003E0000003E0000003E0000003E0000003E0000003E000
      0003E1E007C3E7FC3FF3FFFE7FFF280000001000000020000000010004000000
      0000C00000000000000000000000000000000000000000000000000080000080
      00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000007F700000000000
      7F8F48700000000784CF45580000007FCCCF4555800007FCCCCF4555870007FC
      CCCF455577000744444F4444480007FFFFFFFFFFF8000785555F4CCCC8000785
      555F4CCCC8000785555F4CCCC8000785555F4CCCC8000788844F4488880007F7
      7FFF8F777F000700000F700000000000000000000000FC1F0000F00F0000E007
      0000C00300008001000080010000800100008001000080010000800100008001
      0000800100008001000080010000BE7D0000FFFF0000}
    Active = True
    NoAutoDeactivate = False
    Tooltip = 'File Guard'
    AutoRecreate = True
    OnMouse = TrayIcon1Mouse
    Localizy = loForm
    Left = 304
    Top = 8
  end
  object KOLApplet1: TKOLApplet
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'FileGuard'
    Visible = False
    OnMinimize = KOLForm1Minimize
    AllBtnReturnClick = True
    Tabulate = False
    TabulateEx = False
    UnitSourcePath = 'C:\KOL\Prj\FileGuard\'
    Left = 272
    Top = 8
  end
  object pm1: TKOLPopupMenu
    showShortcuts = True
    generateConstants = True
    genearteSepeartorConstants = False
    Flags = []
    Localizy = loForm
    Left = 336
    Top = 8
    ItemCount = 2
    Item0Name = 'pmState'
    Item0Caption = 'Settings and State'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioGroup = 0
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'pm1pmStateMenu'
    Item0SubItemCount = 0
    Item0WindowMenu = False
    Item1Name = 'pmExit'
    Item1Caption = 'Exit'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioGroup = 0
    Item1Separator = False
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1OnMenu = 'pm1pmExitMenu'
    Item1SubItemCount = 0
    Item1WindowMenu = False
  end
  object dSelStorage: TKOLOpenDirDialog
    Title = 'Select directory for save file changes history'
    Options = [odOnlySystemDirs]
    CenterOnScreen = False
    Localizy = loForm
    Left = 368
    Top = 8
  end
  object ImageList1: TKOLImageList
    ImgWidth = 16
    ImgHeight = 16
    Count = 4
    bitmap.Data = {
      36140000424D3614000000000000360400002800000040000000100000000100
      2000000000000010000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A60033000000000033003300330033330000161616001C1C1C00222222002929
      2900555555004D4D4D004242420039393900807CFF005050FF009300D600FFEC
      CC00C6D6EF00D6E7E70090A9AD0000FF330000006600000099000000CC000033
      00000033330000336600003399000033CC000033FF0000660000006633000066
      6600006699000066CC000066FF00009900000099330000996600009999000099
      CC000099FF0000CC000000CC330000CC660000CC990000CCCC0000CCFF0000FF
      660000FF990000FFCC0033FF0000FF00330033006600330099003300CC003300
      FF00FF3300003333330033336600333399003333CC003333FF00336600003366
      330033666600336699003366CC003366FF003399000033993300339966003399
      99003399CC003399FF0033CC000033CC330033CC660033CC990033CCCC0033CC
      FF0033FF330033FF660033FF990033FFCC0033FFFF0066000000660033006600
      6600660099006600CC006600FF00663300006633330066336600663399006633
      CC006633FF00666600006666330066666600666699006666CC00669900006699
      330066996600669999006699CC006699FF0066CC000066CC330066CC990066CC
      CC0066CCFF0066FF000066FF330066FF990066FFCC00CC00FF00FF00CC009999
      000099339900990099009900CC009900000099333300990066009933CC009900
      FF00996600009966330099336600996699009966CC009933FF00999933009999
      6600999999009999CC009999FF0099CC000099CC330066CC660099CC990099CC
      CC0099CCFF0099FF000099FF330099CC660099FF990099FFCC0099FFFF00CC00
      000099003300CC006600CC009900CC00CC0099330000CC333300CC336600CC33
      9900CC33CC00CC33FF00CC660000CC66330099666600CC669900CC66CC009966
      FF00CC990000CC993300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC
      3300CCCC6600CCCC9900CCCCCC00CCCCFF00CCFF0000CCFF330099FF6600CCFF
      9900CCFFCC00CCFFFF00CC003300FF006600FF009900CC330000FF333300FF33
      6600FF339900FF33CC00FF33FF00FF660000FF663300CC666600FF669900FF66
      CC00CC66FF00FF990000FF993300FF996600FF999900FF99CC00FF99FF00FFCC
      0000FFCC3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300CCFF6600FFFF
      9900FFFFCC006666FF0066FF660066FFFF00FF666600FF66FF00FFFF66002100
      A5005F5F5F00777777008686860096969600CBCBCB00B2B2B200D7D7D700DDDD
      DD00E3E3E300EAEAEA00F1F1F100F8F8F800F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FFFF0000FFFF0000FF000000FF00000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FF000000FFFFFF00FF000000FF000000FFFF0000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FF000000FFFFFF00FF000000FF000000FFFF0000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF000086000000860000FFFFFF00FFFFFF000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF000086000000860000FFFFFF00FFFFFF000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FF000000FF000000FF000000FF000000FF000000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF000086000000860000FFFFFF00FFFFFF000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF00008600000086000000860000008600000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF00008600000086000000860000008600000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF00000000000000FF00
      0000FF000000FFFFFF00FFFFFF000086000000860000FFFFFF00FFFFFF000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000086000000860000FFFFFF00FFFFFF000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000086000000860000FFFFFF00FFFFFF000086
      000000860000FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF0000000000000000000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000}
    TransparentColor = clBlack
    systemimagelist = False
    Colors = ilcColorDDB
    Masked = True
    BkColor = clNone
    Left = 208
    Top = 40
  end
  object ImageList2: TKOLImageList
    ImgWidth = 32
    ImgHeight = 32
    Count = 1
    bitmap.Data = {
      36140000424D3614000000000000360400002800000020000000200000000100
      2000000000000010000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A60033000000000033003300330033330000161616001C1C1C00222222002929
      2900555555004D4D4D004242420039393900807CFF005050FF009300D600FFEC
      CC00C6D6EF00D6E7E70090A9AD0000FF330000006600000099000000CC000033
      00000033330000336600003399000033CC000033FF0000660000006633000066
      6600006699000066CC000066FF00009900000099330000996600009999000099
      CC000099FF0000CC000000CC330000CC660000CC990000CCCC0000CCFF0000FF
      660000FF990000FFCC0033FF0000FF00330033006600330099003300CC003300
      FF00FF3300003333330033336600333399003333CC003333FF00336600003366
      330033666600336699003366CC003366FF003399000033993300339966003399
      99003399CC003399FF0033CC000033CC330033CC660033CC990033CCCC0033CC
      FF0033FF330033FF660033FF990033FFCC0033FFFF0066000000660033006600
      6600660099006600CC006600FF00663300006633330066336600663399006633
      CC006633FF00666600006666330066666600666699006666CC00669900006699
      330066996600669999006699CC006699FF0066CC000066CC330066CC990066CC
      CC0066CCFF0066FF000066FF330066FF990066FFCC00CC00FF00FF00CC009999
      000099339900990099009900CC009900000099333300990066009933CC009900
      FF00996600009966330099336600996699009966CC009933FF00999933009999
      6600999999009999CC009999FF0099CC000099CC330066CC660099CC990099CC
      CC0099CCFF0099FF000099FF330099CC660099FF990099FFCC0099FFFF00CC00
      000099003300CC006600CC009900CC00CC0099330000CC333300CC336600CC33
      9900CC33CC00CC33FF00CC660000CC66330099666600CC669900CC66CC009966
      FF00CC990000CC993300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC
      3300CCCC6600CCCC9900CCCCCC00CCCCFF00CCFF0000CCFF330099FF6600CCFF
      9900CCFFCC00CCFFFF00CC003300FF006600FF009900CC330000FF333300FF33
      6600FF339900FF33CC00FF33FF00FF660000FF663300CC666600FF669900FF66
      CC00CC66FF00FF990000FF993300FF996600FF999900FF99CC00FF99FF00FFCC
      0000FFCC3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300CCFF6600FFFF
      9900FFFFCC006666FF0066FF660066FFFF00FF666600FF66FF00FFFF66002100
      A5005F5F5F00777777008686860096969600CBCBCB00B2B2B200D7D7D700DDDD
      DD00E3E3E300EAEAEA00F1F1F100F8F8F800F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008482840084828400FFFFFF00FFFFFF00C6C3C6008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008482840084828400FFFFFF00FFFFFF00C6C3C600FFFFFF00C6C3C600C6C3
      C600C6C3C6008482840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400FFFFFF00FFFFFF00C6C3C600C6C3C60084000000FFFFFF00C6C3C6008400
      0000C6C3C600C6C3C600C6C3C600848284008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084828400FFFF
      FF00C6C3C600C6C3C6008400000084000000FF000000FFFFFF00C6C3C6008400
      000084008400FF000000C6C3C600C6C3C600C6C3C60084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400FFFFFF00C6C3
      C60084000000840000000000FF00FF0000000000FF00FFFFFF00C6C3C6008400
      0000FF00000084008400FF00000084008400C6C3C600C6C3C600848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084828400FFFFFF00C6C3C6008400
      0000FF0000000000FF00FF0000000000FF00FF000000FFFFFF00C6C3C6008400
      000084008400FF00000084008400FF00000084008400C6C3C600C6C3C6008482
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084828400FFFFFF00FFFFFF0084000000FF00
      00000000FF00FF0000000000FF00FF0000000000FF00FFFFFF00C6C3C6008400
      0000FF00000084008400FF00000084008400FF00000084008400C6C3C600C6C3
      C600848284000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084828400FFFFFF0084000000FF0000000000
      FF00FF0000000000FF00FF0000000000FF00FF000000FFFFFF00C6C3C6008400
      000084008400FF00000084008400FF00000084008400FF00000084828400C6C3
      C600848284000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF00FF0000000000FF00FF00
      00000000FF00FF0000000000FF00FF0000000000FF00FFFFFF00C6C3C6008400
      0000FF00000084008400FF00000084008400FF00000084008400FF000000C6C3
      C600848284008482840000000000000000000000000000000000000000000000
      0000000000000000000084828400FFFFFF00840000000000FF00FF0000000000
      FF00FF0000000000FF00FF0000000000FF00FF000000FFFFFF00C6C3C6008400
      000084008400FF00000084008400FF00000084008400FF00000084008400C6C3
      C600C6C3C6008482840000000000000000000000000000000000000000000000
      0000000000000000000084828400FFFFFF0084000000FF0000000000FF00FF00
      00000000FF00FF0000000000FF00FF0000000000FF00FFFFFF00C6C3C6008400
      0000FF00000084008400FF00000084008400FF00000084008400FF0000008482
      8400C6C3C6008482840000000000000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600FF0000000000FF00FF0000000000
      FF00FF0000000000FF00FF0000000000FF00FF000000FFFFFF00C6C3C6008400
      000084008400FF00000084008400FF00000084008400FF00000084008400FF00
      0000C6C3C6008482840084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00840000008400000084000000840000008400
      00008400000084000000840000008400000084000000FFFFFF00C6C3C6008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000C6C3C600C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00C6C3C600C6C3
      C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C60084000000FF00000084008400FF00
      000084008400FF00000084008400FF00000084008400FFFFFF00C6C3C6008400
      0000FF0000000000FF00FF0000000000FF00FF0000000000FF00FF0000000000
      FF00FF000000C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600FF00000084008400FF0000008400
      8400FF00000084008400FF00000084008400FF000000FFFFFF00C6C3C6008400
      00000000FF00FF0000000000FF00FF0000000000FF00FF0000000000FF00FF00
      00000000FF00C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C60084000000FF00000084008400FF00
      000084008400FF00000084008400FF00000084008400FFFFFF00C6C3C6008400
      0000FF0000000000FF00FF0000000000FF00FF0000000000FF00FF0000000000
      FF00FF000000C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600FF00000084008400FF0000008400
      8400FF00000084008400FF00000084008400FF000000FFFFFF00C6C3C6008400
      00000000FF00FF0000000000FF00FF0000000000FF00FF0000000000FF00FF00
      00000000FF00C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C60084000000FF00000084008400FF00
      000084008400FF00000084008400FF00000084008400FFFFFF00C6C3C6008400
      0000FF0000000000FF00FF0000000000FF00FF0000000000FF00FF0000000000
      FF00FF000000C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600FF00000084008400FF0000008400
      8400FF00000084008400FF00000084008400FF000000FFFFFF00C6C3C6008400
      00000000FF00FF0000000000FF00FF0000000000FF00FF0000000000FF00FF00
      00000000FF00C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C60084000000FF00000084008400FF00
      000084008400FF00000084008400FF00000084008400FFFFFF00C6C3C6008400
      0000FF0000000000FF00FF0000000000FF00FF0000000000FF00FF0000000000
      FF00FF000000C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600FF00000084008400FF0000008400
      8400FF00000084008400FF00000084008400FF000000FFFFFF00C6C3C6008400
      00000000FF00FF0000000000FF00FF0000000000FF00FF0000000000FF00FF00
      00000000FF00C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C60084000000FF00000084000000FF00
      000084000000FF00000084008400FF00000084008400FFFFFF00C6C3C6008400
      0000FF0000000000FF00FF000000840000008400000084000000840000008400
      0000FF000000C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C60084000000FF00000084000000FF000000FFFFFF00C6C3C6008400
      0000840000008400000084000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C60084000000C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00C6C3C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C3C600C6C3C600C6C3C60084000000FFFFFF00C6C3C6008400
      0000C6C3C600C6C3C600C6C3C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C3C600C6C3C60084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00FFFFFF00FFFFFF0084828400848284008482
      840084828400FFFFFF00FFFFFF00FFFFFF00C6C3C600FFFFFF00C6C3C600C6C3
      C600FFFFFF00FFFFFF00FFFFFF00848284008482840084828400848284008482
      8400FFFFFF00FFFFFF0084828400000000000000000000000000000000000000
      00000000000084828400FFFFFF00848284008482840000000000000000000000
      000000000000848284008482840084828400FFFFFF00FFFFFF00C6C3C600FFFF
      FF00848284008482840084828400000000000000000000000000000000000000
      0000848284008482840084828400000000000000000000000000000000000000
      0000000000008482840084828400000000000000000000000000000000000000
      00000000000000000000000000000000000084828400FFFFFF00FFFFFF008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000}
    TransparentColor = clBlack
    systemimagelist = False
    Colors = ilcColorDDB
    Masked = True
    BkColor = clNone
    Left = 240
    Top = 40
  end
  object ImageList3: TKOLImageList
    ImgWidth = 16
    ImgHeight = 16
    Count = 0
    TransparentColor = clDefault
    systemimagelist = True
    Colors = ilcColor
    Masked = True
    BkColor = clNone
    Left = 272
    Top = 40
  end
  object pm2: TKOLPopupMenu
    showShortcuts = True
    generateConstants = True
    genearteSepeartorConstants = False
    Flags = []
    Localizy = loForm
    Left = 336
    Top = 40
    ItemCount = 2
    Item0Name = 'pmHistory'
    Item0Caption = '&History'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioGroup = 0
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'pm2pmHistoryMenu'
    Item0SubItemCount = 0
    Item0WindowMenu = False
    Item1Name = 'pmRestore'
    Item1Caption = '&Restore'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioGroup = 0
    Item1Separator = False
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1OnMenu = 'pm2pmRestoreMenu'
    Item1SubItemCount = 0
    Item1WindowMenu = False
  end
  object pm3: TKOLPopupMenu
    showShortcuts = True
    generateConstants = True
    genearteSepeartorConstants = False
    Flags = []
    Localizy = loForm
    Left = 304
    Top = 40
    ItemCount = 3
    Item0Name = 'pmDirRestore'
    Item0Caption = '&Restore'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioGroup = 0
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'pm3pmDirRestoreMenu'
    Item0SubItemCount = 0
    Item0WindowMenu = False
    Item1Name = 'N1'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioGroup = 0
    Item1Separator = True
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1SubItemCount = 0
    Item1WindowMenu = False
    Item2Name = 'pmDirOpen'
    Item2Caption = '&Open Directory'
    Item2Enabled = True
    Item2Visible = True
    Item2Checked = False
    Item2RadioGroup = 0
    Item2Separator = False
    Item2Accelerator = 0
    Item2Bitmap = ()
    Item2OnMenu = 'pm3pmDirOpenMenu'
    Item2SubItemCount = 0
    Item2WindowMenu = False
  end
  object KOLForm1: TKOLForm
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'File Guard'
    Visible = False
    OnDestroy = KOLForm1Destroy
    OnClose = KOLForm1Close
    OnMinimize = KOLForm1Minimize
    AllBtnReturnClick = False
    Tabulate = False
    TabulateEx = False
    UnitSourcePath = 'C:\KOL\Prj\FileGuard\'
    Locked = False
    formUnit = 'MainUnit'
    formMain = True
    Enabled = True
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
    CenterOnScreen = True
    Ctl3D = True
    WindowState = wsNormal
    minimizeIcon = True
    maximizeIcon = True
    closeIcon = True
    helpContextIcon = False
    borderStyle = fbsSingle
    HelpContext = 0
    Color = clBtnFace
    Font.Color = clWindowText
    Font.FontStyle = []
    Font.FontHeight = 16
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 1
    Font.FontPitch = fpDefault
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    DoubleBuffered = False
    PreventResizeFlicks = False
    Transparent = False
    AlphaBlend = 255
    Border = 2
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    MarginBottom = 0
    MinimizeNormalAnimated = True
    zOrderChildren = False
    statusSizeGrip = True
    Localizy = False
    ShowHint = False
    OnShow = KOLForm1Show
    OnFormCreate = KOLForm1FormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 240
    Top = 8
  end
  object TimerHide: TKOLTimer
    Interval = 100
    Enabled = False
    OnTimer = TimerHideTimer
    Multimedia = False
    Resolution = 0
    Periodic = True
    Left = 368
    Top = 40
  end
  object MHXP1: TKOLMHXP
    AppName = 'Vladimir Kladov'
    Description = 'File Guard - Automatic File Backup Utility'
    ExternalFile = True
    Left = 400
    Top = 8
  end
  object TimerCheckConnect: TKOLTimer
    Interval = 10000
    Enabled = False
    OnTimer = TimerCheckConnectTimer
    Multimedia = False
    Resolution = 0
    Periodic = True
    Left = 400
    Top = 40
  end
  object ThreadRescanStorageTree: TKOLThread
    PriorityClass = pcNormal
    ThreadPriority = tpIdle
    OnExecute = ThreadRescanStorageTreeExecute
    startSuspended = True
    AutoFree = False
    Left = 432
    Top = 40
  end
end
