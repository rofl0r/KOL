object Form1: TForm1
  Left = 201
  Top = 226
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoScroll = False
  Caption = 'KOL FTP client'
  ClientHeight = 423
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 16
  object TC: TKOLTabControl
    Tag = 0
    Left = 2
    Top = 50
    Width = 788
    Height = 371
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
    Align = caClient
    CenterOnParent = False
    Ctl3D = True
    Color = clBtnFace
    parentColor = True
    Font.Color = clWindowText
    Font.FontStyle = [fsBold]
    Font.FontHeight = 16
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    Options = [tcoButtons, tcoFixedWidth]
    ImageList1stIdx = 0
    Count = 1
    OnSelChange = TCSelChange
    edgeType = esNone
    Border = 2
    MarginTop = 0
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    generateConstants = True
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    object T0: TKOLPanel
      Tag = 0
      Left = 4
      Top = 26
      Width = 780
      Height = 341
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
      Caption = 'FTP'
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = [fsBold]
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 0
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
      object P1: TKOLPanel
        Tag = 0
        Left = 2
        Top = 2
        Width = 776
        Height = 229
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
        Font.FontStyle = [fsBold]
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 0
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esRaised
        VerticalAlign = vaCenter
        Border = 4
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object LV: TKOLListView
          Tag = 0
          Left = 7
          Top = 7
          Width = 369
          Height = 215
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
          Color = clWindow
          parentColor = False
          Font.Color = clWindowText
          Font.FontStyle = [fsBold]
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = False
          OnMouseDblClk = LVMouseDblClk
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          Style = lvsDetail
          Options = [lvoAutoArrange, lvoMultiselect, lvoRowSelect]
          LVCount = 0
          LVTextBkColor = clNone
          LVBkColor = clWindow
          popupMenu = PL
          HasBorder = True
          TabStop = True
          generateConstants = True
          Brush.Color = clWindow
          Brush.BrushStyle = bsSolid
          Unicode = False
          ColCount = 0
        end
        object S1: TKOLSplitter
          Tag = 0
          Left = 380
          Top = 7
          Width = 0
          Height = 215
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
          Align = caLeft
          CenterOnParent = False
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = [fsBold]
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 0
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
        object RV: TKOLListView
          Tag = 0
          Left = 384
          Top = 7
          Width = 385
          Height = 215
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
          Align = caClient
          CenterOnParent = False
          Ctl3D = True
          Color = clBtnFace
          parentColor = True
          Font.Color = clWindowText
          Font.FontStyle = [fsBold]
          Font.FontHeight = 16
          Font.FontWidth = 0
          Font.FontWeight = 0
          Font.FontName = 'Arial'
          Font.FontOrientation = 0
          Font.FontCharset = 1
          Font.FontPitch = fpDefault
          parentFont = False
          OnMouseDblClk = RVMouseDblClk
          EraseBackground = False
          Localizy = loForm
          Transparent = False
          Style = lvsDetail
          Options = [lvoMultiselect, lvoRowSelect, lvoRegional]
          LVCount = 0
          LVTextBkColor = clNone
          LVBkColor = clBtnFace
          popupMenu = PL
          HasBorder = True
          TabStop = True
          generateConstants = True
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          Unicode = False
          ColCount = 0
        end
      end
      object S2: TKOLSplitter
        Tag = 0
        Left = 2
        Top = 233
        Width = 776
        Height = 0
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
        Align = caTop
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = [fsBold]
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 0
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
      object P2: TKOLPanel
        Tag = 0
        Left = 2
        Top = 235
        Width = 776
        Height = 104
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
        Align = caClient
        CenterOnParent = False
        Ctl3D = True
        Color = clBtnFace
        parentColor = True
        Font.Color = clWindowText
        Font.FontStyle = [fsBold]
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 0
        Font.FontPitch = fpDefault
        parentFont = True
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        TextAlign = taLeft
        edgeStyle = esRaised
        VerticalAlign = vaTop
        Border = 4
        MarginTop = 0
        MarginBottom = 0
        MarginLeft = 0
        MarginRight = 0
        Brush.Color = clBtnFace
        Brush.BrushStyle = bsSolid
        ShowAccelChar = False
        object TV: TKOLListView
          Tag = 0
          Left = 7
          Top = 7
          Width = 762
          Height = 90
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
          Font.FontStyle = [fsBold]
          Font.FontHeight = 16
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
          Style = lvsDetail
          Options = [lvoMultiselect, lvoRowSelect, lvoRegional]
          LVCount = 0
          LVTextBkColor = clNone
          LVBkColor = clBtnFace
          popupMenu = PT
          HasBorder = True
          TabStop = True
          generateConstants = True
          Brush.Color = clBtnFace
          Brush.BrushStyle = bsSolid
          Unicode = False
          ColCount = 0
        end
      end
    end
  end
  object P3: TKOLPanel
    Tag = 0
    Left = 2
    Top = 2
    Width = 788
    Height = 46
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
    Font.FontStyle = [fsBold]
    Font.FontHeight = 16
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 0
    Font.FontPitch = fpDefault
    parentFont = True
    EraseBackground = False
    Localizy = loForm
    Transparent = False
    TextAlign = taLeft
    edgeStyle = esRaised
    VerticalAlign = vaTop
    Border = 4
    MarginTop = 0
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    Brush.Color = clBtnFace
    Brush.BrushStyle = bsSolid
    ShowAccelChar = False
    object P5: TKOLPanel
      Tag = 0
      Left = 68
      Top = 7
      Width = 713
      Height = 32
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
      Align = caClient
      CenterOnParent = False
      Ctl3D = True
      Color = clBtnFace
      parentColor = True
      Font.Color = clWindowText
      Font.FontStyle = [fsBold]
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 0
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TextAlign = taLeft
      edgeStyle = esLowered
      VerticalAlign = vaTop
      Border = 0
      MarginTop = 0
      MarginBottom = 0
      MarginLeft = 0
      MarginRight = 0
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
      ShowAccelChar = False
      object TB: TKOLToolbar
        Tag = 0
        Left = 1
        Top = 1
        Width = 711
        Height = 30
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
        Font.FontStyle = [fsBold]
        Font.FontHeight = 16
        Font.FontWidth = 0
        Font.FontWeight = 0
        Font.FontName = 'Arial'
        Font.FontOrientation = 0
        Font.FontCharset = 0
        Font.FontPitch = fpDefault
        parentFont = True
        OnClick = TBClick
        OnMouseDblClk = TBMouseDblClk
        EraseBackground = False
        Localizy = loForm
        Transparent = False
        Options = []
        bitmap.Data = {
          76060000424D76060000000000007600000028000000C0000000100000000100
          04000000000000060000120B0000120B00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDD99DDD99DDDDDDDDDDDDDDD70DDDD7777770DDDDDDDDDDDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00000000000000DDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
          DDDDDDDDD99999DDDDDDDDDDDDDDD7CC0DDD7FFFFF0DDDDDDDDDDDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDD000000DDDDDD777777777777770DDDDDDDFD7DD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD0000DD
          DDDDDDDDDD979DDDDDDDDDDDDDDD7CCCC0DD7FCFCF0DDDDDDDDDDDD9DDDDDDDD
          DD9DDDDDDDDDDDDDDDDDDDDD09999990DDDDD7FBDBDBDBDBDB70DDDDDDDFD7DD
          DDDDDDDD70DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD0000000F3000
          00000000099999000000DDDDDDD7CCCCCC0D7FFFFF0DD7000DDDDD999DDDDDDD
          DDDDDDD00000DD00DD00DDD0999999990DDDD7FDBDBDBDBDBD70DDDDDDDFD7DD
          DDDDDDD7CC0DD7000DDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFDDDDDDDDD0330DD
          DDDDDDDD997D799DDDDDDDDDDD7CCCCCCCC07FCFCF0DD7CC0DDDDD9999DDDDDD
          D9DDDD0E6660D0E0D0E0DD099999999990DDD7FBDBDBDBDBDB70DDD44444D7DD
          DDDDDD7CCCC0D7CC0DDDDDFF666666FDDDDDDDDF6FFFFDDFFDDDDDDDDD0D0DDD
          DDDDDDDDDD0D0DDDDDDDDDDDDD7777CC00007FF7770DD7CC0DDDDDD999DDDDDD
          9DDDDD0E000DD00DD00DD0999F9999F9990DD7FDBDBDBDBDBD70DDD4444FD7D7
          7DDDD7CCCCCC07CC0DDDDDF06666666FDDDDDDDF6FFFFDDFFDDDDDDDDD000DDD
          DDDDDDDDDD0D0DDDDDDD7777770DD7CC0DDD7FF7F0DDD7CC0DDDDDDD999DDDD9
          9DDDDD0E0DDDDDDDDDDDD0999FF99FF9990DD7FBDBDBDBDBDB70D74444DFD7DD
          447D7CCCCCCCC0CC0DDDDDF2F6666666DDDDDDDF6FFFFFFFFDDD777777000000
          00DDD0000000000000DD7FFFFF0DD7CC0DDD7FF70DDDD7CC0DDDDDDDD999DD99
          DDDDDD0E0DDDDDDDDDDDD09999FFFF99990DD7F3DDBDBDBDBD70747D4DDFD7DD
          DD477777CC0000CC0DDDDDF220FFFFFFFDDDDDDF6FFFFFF6FDDD7DFFFFFFFFFF
          D70D7DFFFFFFFFFFD70D7FCFCF0DD7CC0DDD7770DDDDD7CC0DDDDDDDDD99999D
          DDDD000E000DDDDDDDDDD099999FF999990D3DD3BBDBDBDBDB7047DDDDDFD7DD
          DD74DDD7CC0DD7CC0DDDDDF002002FDDDDDDDDDFFDDDDDDFFDDD7D7777777777
          D7707D7777777777D7707FFFFF0DD7CC0DDDDDDDDD7777CC0000DDDDDDD999DD
          DDDD0E66660DDDDDDDDDD09999FFFF99990DD3D3DDFFFFFFFF7047DDDDDFD7DD
          DD74DDD7CC0777CC0000DDF00FFFFFDDDDDDDDDFFDDDDDDFFDDD7DDDDDDDDDDD
          D7707DDDDDDDDDDD77707FCFCF0DD7CC0DDDDDDDDD7CCCCCCCC0DDDDDD99999D
          DDDDD0E660DDDDDDDDDDD0999FF99FF9990D373DBBBDB777777D74DDDDDFD7DD
          DD47DDD7CC0CCCCCCCC0DDDFFDDDDDDFFDDDDDDFFDDDDDDFFDDD7DDDDDDDDDA2
          D7707DDDDDDDDDA2D7707FF7770DD7777DDDDDDDDDD7CCCCCC0DDDDDD999DD99
          DDDDDD0E0DDDDDDDDDDDDD099F9999F990DDDB3BB3333DDDDDDDD744DDDFD7DD
          447DDDD7CC07CCCCCC0DDDDDDDDDDDDDFDDDDDDFFDDDDDDFFDDD7FFFFFFFFFFF
          F7707FFFFFFFFFFFF7707FF7F0DDDDDDDDDDDDDDDDDD7CCCC0DDDDD9999DDDD9
          9DDDDDD0DDDDDDDDDDDDDDD0999999990DDDD3B3B3B7DDDDDDDDDDD7444FD744
          7DDDDDD7CC0D7CCCC0DDDDDDDDDDDFFDDDDDDDDFFFFFFFFFFDDDD7DDDDDDDDDD
          DD70D7DDDDDDDDDDDDD07FF70DDDDDDDDDDDDDDDDDDDD7CC0DDDDD9999DDDDDD
          99DDDDDDDDDDDDDDDDDDDDDD09999990DDDD3BD3BD3BDDDDDDDDDDDDD77FD77D
          DDDDDDD7777DD7CC0DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD7777777777
          777DDD7777777777777D7770DDDDDDDDDDDDDDDDDDDDDD70DDDDDD999DDDDDDD
          DD9DDDDDDDDDDDDDDDDDDDDDD000000DDDDDBDD3BDD3BDDDDDDDDDDDDDDFD7DD
          DDDDDDDDDDDDDD70DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFD7DD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
        buttons = ' '#1' '#1' '#1' '#1' '#1' '#1' '#1' '#1' '#1' '
        noTextLabels = False
        tooltips.Strings = (
          'Connect'
          'Disconnect'
          'Download'
          'Upload'
          'Delete'
          'Up one level'
          'Stop'
          'Make folder'
          'Refresh'
          'Edit Updater')
        showTooltips = False
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
        Buttons_Count = 10
        Btn1Name = 'TB1'
        Btn1caption = ' '
        Btn1checked = False
        Btn1dropdown = False
        Btn1enabled = True
        Btn1separator = False
        Btn1tooltip = ''
        Btn1visible = True
        Btn1onClick = ''
        Btn1picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0 +
          #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#1103#1103#0#0#1026#1026#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#1026#1026#0#0#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1026#1026#1026#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1026#1026#1026#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#1103#0#0#0#1026#0#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn1sysimg = 0
        Btn2Name = 'TB2'
        Btn2caption = ' '
        Btn2checked = False
        Btn2dropdown = False
        Btn2enabled = True
        Btn2separator = False
        Btn2tooltip = ''
        Btn2visible = True
        Btn2onClick = ''
        Btn2picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#1026#1026#1026#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0 +
          #0#0#0#0#0#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1026#1026#1026#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1026#1026#1026#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1026#1026#1026#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#1103#0#0#0#1026#0#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn2sysimg = 0
        Btn3Name = 'TB3'
        Btn3caption = ' '
        Btn3checked = False
        Btn3dropdown = False
        Btn3enabled = True
        Btn3separator = False
        Btn3tooltip = ''
        Btn3visible = True
        Btn3onClick = ''
        Btn3picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#0 +
          #0#0#1103#1103#1103#0#1103#0#0#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#0 +
          #0#0#1103#1103#1103#0#1103#0#0#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1026#1026#1026#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026 +
          #1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn3sysimg = 0
        Btn4Name = 'TB4'
        Btn4caption = ' '
        Btn4checked = False
        Btn4dropdown = False
        Btn4enabled = True
        Btn4separator = False
        Btn4tooltip = ''
        Btn4visible = True
        Btn4onClick = ''
        Btn4picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#0 +
          #0#0#1103#1103#1103#0#1103#0#0#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#0 +
          #0#0#1103#1103#1103#0#1103#0#0#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1026#1026#1026#0#1103#1103#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#1103#1103#0#1103#1103 +
          #1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026 +
          #1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn4sysimg = 0
        Btn5Name = 'TB5'
        Btn5caption = ' '
        Btn5checked = False
        Btn5dropdown = False
        Btn5enabled = True
        Btn5separator = False
        Btn5tooltip = ''
        Btn5visible = True
        Btn5onClick = ''
        Btn5picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn5sysimg = 0
        Btn6Name = 'TB6'
        Btn6caption = ' '
        Btn6checked = False
        Btn6dropdown = False
        Btn6enabled = True
        Btn6separator = False
        Btn6tooltip = ''
        Btn6visible = True
        Btn6onClick = ''
        Btn6picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#1103#1103#0#0#1026#1026#0#0#1026#1026#0#0#1026#1026#0#0#0#0#0#0#1103#0#1103#0#0#0#0#0#1103#1103#0#0#0#0#0#0#1103#0#1103#0#0#0#0#0#1103#1103#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#1103#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#1103#1103#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#1103#1103#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0 +
          #0#0#1103#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#1103#1103#0#0#1026#1026 +
          #0#0#1026#1026#0#0#1026#1026#0#0#1026#1026#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#1103#1103 +
          #0#0#1026#1026#0#0#1026#1026#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#1103#1103#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn6sysimg = 0
        Btn7Name = 'TB7'
        Btn7caption = ' '
        Btn7checked = False
        Btn7dropdown = False
        Btn7enabled = True
        Btn7separator = False
        Btn7tooltip = ''
        Btn7visible = True
        Btn7onClick = ''
        Btn7picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0 +
          #1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#1103#1103#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn7sysimg = 0
        Btn8Name = 'TB8'
        Btn8caption = ' '
        Btn8checked = False
        Btn8dropdown = False
        Btn8enabled = True
        Btn8separator = False
        Btn8tooltip = ''
        Btn8visible = True
        Btn8onClick = ''
        Btn8picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#0#0 +
          #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#1103 +
          #1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#1103 +
          #1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#1103 +
          #1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#1103 +
          #1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#1103 +
          #1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#1103 +
          #1103#0#0#1026#1026#0#1103#0#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#0#1026#1026#0#1103#0#1103#0#1103#0 +
          #1103#0#0#1026#1026#0#0#1103#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#0#1026#1026#0#1103#0 +
          #1103#0#0#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1103#1103#1103#0#1026#1026#1026#0#0#0#0#0#0#1026#1026#0#1026#1026#1026#0#0#1026 +
          #1026#0#1103#0#1103#0#0#1103#1103#0#0#1103#1103#0#0#1103#1103#0#1103#0#1103#0#0#1103#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#0#1103#1103#0#0#1026 +
          #1026#0#0#1103#1103#0#0#1103#1103#0#0#1026#1026#0#0#1026#1026#0#0#1026#1026#0#0#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#1026#1026#0#0#1103 +
          #1103#0#0#1026#1026#0#0#1103#1103#0#0#1026#1026#0#0#1103#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#1026#1026#0#0#1103#1103#0#1103#0 +
          #1103#0#0#1026#1026#0#0#1103#1103#0#1103#0#1103#0#0#1026#1026#0#0#1103#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#0#1103#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#0#1026#1026#0#0#1103#1103#0#1103#0#1103#0#1103#0#1103#0#0#1026#1026#0#0#1103#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn8sysimg = 0
        Btn9Name = 'TB9'
        Btn9caption = ' '
        Btn9checked = False
        Btn9dropdown = False
        Btn9enabled = True
        Btn9separator = False
        Btn9tooltip = ''
        Btn9visible = True
        Btn9onClick = ''
        Btn9picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#0 +
          #0#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1026#0#0#0#1026#0#0#0#1026#1026#1026#0#1103#0#1103#0#1026#1026#1026#0#1026#0#0#0#1026#1026 +
          #1026#0#1103#0#1103#0#1026#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#0#0#0#1026#1026#1026#0#1026#0#0#0#1026#1026#1026#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#0#0#0#1026#0#0#0#1026#1026#1026#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#0#0#0#1026#1026#1026#0#1026#0#0#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#0#0#0#1026#1026#1026#0#1103#0#1103#0#1026#1026#1026#0#1026#0 +
          #0#0#1026#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1026#0#0#0#1026#0#0#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1026#0#0#0#1026#0#0#0#1026#0#0#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#0#0#0#1026#0#0#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#1103#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn9sysimg = 0
        Btn10Name = 'TB10'
        Btn10caption = ' '
        Btn10checked = False
        Btn10dropdown = False
        Btn10enabled = True
        Btn10separator = False
        Btn10tooltip = ''
        Btn10visible = True
        Btn10onClick = ''
        Btn10picture = 
          'BM6'#4#0#0#0#0#0#0'6'#0#0#0'('#0#0#0#16#0#0#0#16#0#0#0#1#0' '#0#0#0#0#0#0#4#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026 +
          #1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0 +
          #0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0 +
          #0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026 +
          #1026#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1026#1026#1026#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#1103#0#0#0#1103#0#0#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1026#1026#1026#0#0#0#0#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0 +
          #1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0#1103#0
        Btn10sysimg = 0
        NewVersion = True
      end
    end
    object DB: TKOLComboBox
      Tag = 0
      Left = 7
      Top = 7
      Width = 57
      Height = 32
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
      Font.FontStyle = [fsBold]
      Font.FontHeight = 16
      Font.FontWidth = 0
      Font.FontWeight = 0
      Font.FontName = 'Arial'
      Font.FontOrientation = 0
      Font.FontCharset = 0
      Font.FontPitch = fpDefault
      parentFont = True
      EraseBackground = False
      Localizy = loForm
      Transparent = False
      TabStop = True
      Options = [coReadOnly, coNoIntegralHeight]
      OnChange = DBChange
      CurIndex = 0
      DroppedWidth = 0
      autoSize = False
      Brush.Color = clBtnFace
      Brush.BrushStyle = bsSolid
    end
  end
  object KP: TKOLProject
    Locked = False
    Localizy = False
    projectName = 'KOLFtpClient'
    projectDest = 'KOLFtpClient'
    sourcePath = 'G:\KIN\PAS\KOLFtp\'
    outdcuPath = 'G:\KIN\PAS\KOLFtp\'
    dprResource = True
    protectFiles = True
    showReport = True
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
    PaintType = ptWYSIWIG
    ShowHint = False
    Left = 72
    Top = 8
  end
  object KF: TKOLForm
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'KOL FTP client'
    Visible = True
    OnMessage = KFMessage
    OnClose = KFClose
    AllBtnReturnClick = False
    Locked = False
    formUnit = 'KOLForm'
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
    borderStyle = fbsSingle
    HelpContext = 0
    Color = clBtnFace
    Font.Color = clWindowText
    Font.FontStyle = [fsBold]
    Font.FontHeight = 16
    Font.FontWidth = 0
    Font.FontWeight = 0
    Font.FontName = 'Arial'
    Font.FontOrientation = 0
    Font.FontCharset = 0
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
    MinimizeNormalAnimated = False
    zOrderChildren = False
    statusSizeGrip = True
    Localizy = False
    ShowHint = False
    OnResize = KFResize
    OnFormCreate = KFFormCreate
    EraseBackground = False
    supportMnemonics = False
    Left = 181
    Top = 8
  end
  object KA: TKOLApplet
    Tag = 0
    ForceIcon16x16 = False
    Caption = 'KOLFtpClient'
    Visible = True
    AllBtnReturnClick = False
    Left = 128
    Top = 8
  end
  object PL: TKOLPopupMenu
    Tag = 0
    showShortcuts = True
    generateConstants = True
    genearteSepeartorConstants = False
    Flags = []
    Localizy = loForm
    Left = 72
    Top = 56
    ItemCount = 5
    Item0Name = 'N1'
    Item0Caption = 'Select All'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioGroup = 0
    Item0Separator = False
    Item0Accelerator = 545
    Item0Bitmap = ()
    Item0OnMenu = 'PLN1Menu'
    Item0SubItemCount = 0
    Item0WindowMenu = False
    Item1Name = 'N2'
    Item1Caption = 'Deselect All'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioGroup = 0
    Item1Separator = False
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1OnMenu = 'PLN2Menu'
    Item1SubItemCount = 0
    Item1WindowMenu = False
    Item2Name = 'N3'
    Item2Enabled = True
    Item2Visible = True
    Item2Checked = False
    Item2RadioGroup = 0
    Item2Separator = True
    Item2Accelerator = 0
    Item2Bitmap = ()
    Item2SubItemCount = 0
    Item2WindowMenu = False
    Item3Name = 'N4'
    Item3Caption = 'Add to transfer list'
    Item3Enabled = True
    Item3Visible = True
    Item3Checked = False
    Item3RadioGroup = 0
    Item3Separator = False
    Item3Accelerator = 0
    Item3Bitmap = ()
    Item3OnMenu = 'PLN4Menu'
    Item3SubItemCount = 0
    Item3WindowMenu = False
    Item4Name = 'N9'
    Item4Caption = 'Delete selected'
    Item4Enabled = True
    Item4Visible = True
    Item4Checked = False
    Item4RadioGroup = 0
    Item4Separator = False
    Item4Accelerator = 0
    Item4Bitmap = ()
    Item4OnMenu = 'PLN9Menu'
    Item4SubItemCount = 0
    Item4WindowMenu = False
  end
  object PT: TKOLPopupMenu
    Tag = 0
    showShortcuts = True
    generateConstants = True
    genearteSepeartorConstants = False
    Flags = []
    Localizy = loForm
    Left = 72
    Top = 100
    ItemCount = 4
    Item0Name = 'N5'
    Item0Caption = 'Select All'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioGroup = 0
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'PTN5Menu'
    Item0SubItemCount = 0
    Item0WindowMenu = False
    Item1Name = 'N6'
    Item1Caption = 'Deselect All'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioGroup = 0
    Item1Separator = False
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1OnMenu = 'PTN6Menu'
    Item1SubItemCount = 0
    Item1WindowMenu = False
    Item2Name = 'N7'
    Item2Enabled = True
    Item2Visible = True
    Item2Checked = False
    Item2RadioGroup = 0
    Item2Separator = True
    Item2Accelerator = 0
    Item2Bitmap = ()
    Item2SubItemCount = 0
    Item2WindowMenu = False
    Item3Name = 'N8'
    Item3Caption = 'Delete from list'
    Item3Enabled = True
    Item3Visible = True
    Item3Checked = False
    Item3RadioGroup = 0
    Item3Separator = False
    Item3Accelerator = 0
    Item3Bitmap = ()
    Item3OnMenu = 'PTN8Menu'
    Item3SubItemCount = 0
    Item3WindowMenu = False
  end
  object TM: TKOLTimer
    Tag = 0
    Interval = 1000
    Enabled = True
    OnTimer = TMTimer
    Multimedia = False
    Resolution = 0
    Periodic = True
    Left = 128
    Top = 57
  end
  object FC: TKOLFTP
    Tag = 0
    HostPort = '21'
    Passive = False
    OnFTPStatus = FCFTPStatus
    OnFTPLogger = FTPLogger
    OnFTPConnect = FTPConnect
    OnFTPLogin = FTPLogin
    OnFTPError = FTPError
    OnFTPData = FTPData
    OnProgress = FTPProgress
    OnGetExist = FTPExist
    OnPutExist = FTPExist
    OnFileDone = FTPFileDone
    OnFTPClose = FTPClose
    Left = 128
    Top = 100
  end
  object TI: TKOLTrayIcon
    Tag = 0
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0000000000000066000000000000000000000000000008777800000000000000
      0000000000008F87777777888000000000000000000008F88777777778000000
      0000000000000088888888887700000000000000000000000888888887600000
      000000066677888000888F888760000000006677666667778877787F87000000
      00067666777766667887778F88000000006666677667777788888FF880000000
      0666664664666678888888778000000066644446644667888888887780000000
      66444666226668888FFF888780000006646666662266478888FFFF8800000006
      466666662226478F888887700000006666666662222244888888767000000066
      6666666222266004677766760000006666666666266666000006667600000066
      6666666666E66622222266760000006666622666EEEE66622222267600000066
      66622226EEEEE6622266267600000066662223377EEEEE662222267000000066
      66233333788EEEE62222266000000006663337777888EEE26222676000000006
      623378888F88EEE66222660000000000723778888F87E6666626760000000000
      6737888F8F833666666660000000000006778888888336E66666000000000000
      00077888887332666E60000000000000000067787733326E6000000000000000
      0000006887E7776600000000000000000000000006660000000000000000FFFF
      CFFFFFFF83FFFFFF0007FFFF8003FFFFC003FFFFF801FFE01C01FF000003FE00
      0003FC000007F8000007F0000007F0000007E000000FE000001FC000001FC000
      000FC000000FC000000FC000000FC000000FC000001FC000001FE000001FE000
      003FF000003FF000007FF80000FFFE0001FFFF0007FFFFC00FFFFFF8FFFF}
    Active = False
    NoAutoDeactivate = False
    Tooltip = 'KOLFtpClient'
    AutoRecreate = False
    OnMouse = TIMouse
    Localizy = loForm
    Left = 182
    Top = 57
  end
  object PM: TKOLPopupMenu
    Tag = 0
    showShortcuts = True
    generateConstants = True
    genearteSepeartorConstants = False
    Flags = []
    Localizy = loForm
    Left = 182
    Top = 101
    ItemCount = 3
    Item0Name = 'N10'
    Item0Caption = 'Restore'
    Item0Enabled = True
    Item0Visible = True
    Item0Checked = False
    Item0RadioGroup = 0
    Item0Separator = False
    Item0Accelerator = 0
    Item0Bitmap = ()
    Item0OnMenu = 'PMN10Menu'
    Item0SubItemCount = 0
    Item0WindowMenu = False
    Item1Name = 'N11'
    Item1Enabled = True
    Item1Visible = True
    Item1Checked = False
    Item1RadioGroup = 0
    Item1Separator = True
    Item1Accelerator = 0
    Item1Bitmap = ()
    Item1SubItemCount = 0
    Item1WindowMenu = False
    Item2Name = 'N12'
    Item2Caption = 'Exit'
    Item2Enabled = True
    Item2Visible = True
    Item2Checked = False
    Item2RadioGroup = 0
    Item2Separator = False
    Item2Accelerator = 0
    Item2Bitmap = ()
    Item2OnMenu = 'PMN12Menu'
    Item2SubItemCount = 0
    Item2WindowMenu = False
  end
  object XP: TKOLMHXP
    Tag = 0
    AppName = 'Hidden.Hole.LTD'
    Description = 'KOL FTP Client'
    Left = 76
    Top = 152
  end
end
