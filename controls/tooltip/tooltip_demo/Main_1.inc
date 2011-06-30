{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PMainForm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'MainForm' ).SetPosition( 457, 98 ).SetClientSize( 528, 457 );
  Result.Form.Add2AutoFree( Result );

    Result.ColorDialog := NewColorDialog( ccoShortOpen );
  Result.Form.Add2AutoFree( Result.ColorDialog );

    InitCommonControls;
    {$R MainForm_MHXP1.RES}

    Result.mdvToolTipTrack := NewmdvToolTip(Result.Form, 2, hmTracking, [], [], 0);
  Result.Form.Add2AutoFree( Result.mdvToolTipTrack );

    Result.mdvToolTip := NewmdvToolTip(Result.Form, 2, hmDefault, [
      @Result.Button1, @Result.Memo1, @Result.Button7, @Result.GroupBox1, @Result.Label1, @Result.edDelayAutomatic, @Result.Label2, @Result.edDelayInit, @Result.Label3, @Result.edDelayTime, @Result.Label4, @Result.edDelayReshow, @Result.pnlColor, @Result.lblFontColor, @Result.cbBalloon, @Result.cbAlwaysTip, @Result.GroupBox2, @Result.Label5, @Result.edLeft, @Result.Label6, @Result.edRight, @Result.Label7, @Result.edTop, @Result.Label8, @Result.edBottom, @Result.edMaxWidth, @Result.Label9, @Result.Label10, @Result.edTitleText, @Result.Label11, @Result.cbTitleIcon], ['Изменить текст подсказкидля сфокусированного элемента', 'Поле ввода текста подсказки', 'Добавить текст подсказкидля сфокусированного элемента', 'Задержки при показе подсказки', 'Авто вычисление значений DelayInit, DelayTime, DelayReshow', 'Авто вычисление значений DelayInit, DelayTime, DelayReshow', 'Задержка появления подсказки', 'Задержка появления подсказки', 
      'Время показа подсказки', 'Время показа подсказки', 'Время перепоказа подсказки', 'Время перепоказа подсказки', 'Цвет фона подсказки', 'Цвет текста подсказки', 'Стиль подсказки в виде "шара".Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98', 'Подсказка показывается всегда, независимо от того, активно ли сейчас окно', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Отступы при выводе текста', 'Максимальная ширина подсказки.При значении <>-1 появляется возможность использовать #13#10для переноса строк', 'Максимальная ширина подсказки.При значении <>-1 появляется возможность использовать #13#10для переноса строк', 'Устанавливает заголовок подсказки.Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98', 
      'Устанавливает заголовок подсказки.Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98', 'Устанавливает иконку подсказки.Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98', 'Устанавливает иконку подсказки.Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98'], 31);
    Result.mdvToolTip.Color:= 16776960;
    Result.mdvToolTip.FontColor:= 16711680;
    Result.mdvToolTip.MaxWidth:= 1000;
    Result.mdvToolTip.AlwaysTip:= True;
    Result.mdvToolTip.SetTitle(' ', itInfoIcon);
  Result.Form.Add2AutoFree( Result.mdvToolTip );
    // Result.Label12.TabOrder = -1
    Result.Label12 := NewLabel( Result.Form, '' ).SetPosition( 12, 284 ).AutoSize( TRUE );
    // Result.Button7.TabOrder = 0
    Result.Button7 := NewButton( Result.Form, 'Add Hint Text' ).SetPosition( 188, 52 ).SetSize( 109, 0 ).LikeSpeedButton;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Set Hint Text' ).SetPosition( 188, 24 ).SetSize( 109, 0 ).LikeSpeedButton;
    // Result.GroupBox4.TabOrder = 1
    Result.GroupBox4 := NewGroupBox( Result.Form, ' Tracking ' ).SetPosition( 16, 160 ).SetSize( 281, 281 );
    Result.GroupBox4.TabStop := FALSE;
    // Result.TrackingPanel.TabOrder = 0
      Result.TrackingPanel := NewPanel( Result.GroupBox4, esRaised ).SetPosition( 16, 24 ).SetSize( 249, 65 );
    Result.TrackingPanel.TextAlign := taCenter;
    Result.TrackingPanel.VerticalAlign := vaCenter;
      Result.TrackingPanel.Caption := 'Tracking Panel';
    // Result.TrackingTreeView.TabOrder = 1
      Result.TrackingTreeView := NewTreeView( Result.GroupBox4, [  ], nil, nil ).SetPosition( 16, 104 ).SetSize( 249, 169 );
    Result.TrackingTreeView.Color := clWindow;
    // Result.Memo1.TabOrder = 3
    Result.Memo1 := NewEditBox( Result.Form, [ eoMultiline, eoWantReturn ] ).SetPosition( 16, 24 ).SetSize( 161, 125 );
    Result.Memo1.Color := clWindow;
    // Result.GroupBox1.TabOrder = 4
    Result.GroupBox1 := NewGroupBox( Result.Form, ' Delay ' ).SetPosition( 312, 16 ).SetSize( 201, 129 );
    Result.GroupBox1.TabStop := FALSE;
    // Result.Label3.TabOrder = -1
      Result.Label3 := NewLabel( Result.GroupBox1, 'DelayTime' ).SetPosition( 8, 75 ).SetSize( 81, 17 );
    // Result.Label4.TabOrder = -1
      Result.Label4 := NewLabel( Result.GroupBox1, 'DelayReshow' ).SetPosition( 8, 99 ).SetSize( 97, 17 );
    // Result.Label2.TabOrder = -1
      Result.Label2 := NewLabel( Result.GroupBox1, 'DelayInit' ).SetPosition( 8, 51 ).SetSize( 81, 17 );
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.GroupBox1, 'DelayAutomatic' ).SetPosition( 8, 27 ).SetSize( 113, 17 );
    // Result.edDelayReshow.TabOrder = 0
      Result.edDelayReshow := NewEditBox( Result.GroupBox1, [ eoNumber ] ).SetPosition( 128, 96 ).SetSize( 57, 0 );
    Result.edDelayReshow.Color := clWindow;
    // Result.edDelayTime.TabOrder = 0
      Result.edDelayTime := NewEditBox( Result.GroupBox1, [ eoNumber ] ).SetPosition( 128, 72 ).SetSize( 57, 0 );
    Result.edDelayTime.Color := clWindow;
    // Result.edDelayInit.TabOrder = 0
      Result.edDelayInit := NewEditBox( Result.GroupBox1, [ eoNumber ] ).SetPosition( 128, 48 ).SetSize( 57, 0 );
    Result.edDelayInit.Color := clWindow;
    // Result.edDelayAutomatic.TabOrder = 0
      Result.edDelayAutomatic := NewEditBox( Result.GroupBox1, [ eoNumber ] ).SetPosition( 128, 24 ).SetSize( 57, 0 );
    Result.edDelayAutomatic.Color := clWindow;
    // Result.cbAlwaysTip.TabOrder = 6
    Result.cbAlwaysTip := NewCheckBox( Result.Form, 'AlwaysTip' ).SetPosition( 424, 200 ).SetSize( 89, 0 );
    // Result.cbBalloon.TabOrder = 6
    Result.cbBalloon := NewCheckBox( Result.Form, 'Balloon' ).SetPosition( 312, 200 ).SetSize( 97, 0 );
    // Result.pnlColor.TabOrder = 7
    Result.pnlColor := NewPanel( Result.Form, esRaised ).SetPosition( 312, 152 ).SetSize( 201, 33 );
    Result.pnlColor.Cursor := LoadCursor( 0, IDC_HAND );
    // Result.lblFontColor.TabOrder = -1
      Result.lblFontColor := NewLabel( Result.pnlColor, 'FontColor' ).SetPosition( 66, 5 ).SetSize( 63, 17 );
      Result.lblFontColor.Transparent := True;
    // Result.GroupBox2.TabOrder = 8
    Result.GroupBox2 := NewGroupBox( Result.Form, 'Margin && Width' ).SetPosition( 312, 232 ).SetSize( 201, 113 );
    Result.GroupBox2.TabStop := FALSE;
    // Result.Label9.TabOrder = -1
      Result.Label9 := NewLabel( Result.GroupBox2, 'MaxWidth' ).SetPosition( 8, 83 ).SetSize( 70, 17 );
    // Result.Label8.TabOrder = -1
      Result.Label8 := NewLabel( Result.GroupBox2, 'Bottom' ).SetPosition( 104, 51 ).SetSize( 49, 17 );
    // Result.Label6.TabOrder = -1
      Result.Label6 := NewLabel( Result.GroupBox2, 'Right' ).SetPosition( 104, 27 ).SetSize( 41, 17 );
    // Result.Label5.TabOrder = -1
      Result.Label5 := NewLabel( Result.GroupBox2, 'Left' ).SetPosition( 8, 27 ).SetSize( 41, 17 );
    // Result.Label7.TabOrder = -1
      Result.Label7 := NewLabel( Result.GroupBox2, 'Top' ).SetPosition( 8, 51 ).SetSize( 41, 17 );
    // Result.edTop.TabOrder = 0
      Result.edTop := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 48, 48 ).SetSize( 33, 0 );
    Result.edTop.Color := clWindow;
    // Result.edLeft.TabOrder = 0
      Result.edLeft := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 48, 24 ).SetSize( 33, 0 );
    Result.edLeft.Color := clWindow;
    // Result.edRight.TabOrder = 0
      Result.edRight := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 152, 24 ).SetSize( 33, 0 );
    Result.edRight.Color := clWindow;
    // Result.edMaxWidth.TabOrder = 0
      Result.edMaxWidth := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 80, 80 ).SetSize( 105, 0 );
    Result.edMaxWidth.Color := clWindow;
    // Result.edBottom.TabOrder = 0
      Result.edBottom := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 152, 48 ).SetSize( 33, 0 );
    Result.edBottom.Color := clWindow;
    // Result.GroupBox3.TabOrder = 9
    Result.GroupBox3 := NewGroupBox( Result.Form, ' Title ' ).SetPosition( 312, 352 ).SetSize( 201, 89 );
    Result.GroupBox3.TabStop := FALSE;
    // Result.Label11.TabOrder = -1
      Result.Label11 := NewLabel( Result.GroupBox3, 'TitleIcon' ).SetPosition( 8, 59 ).SetSize( 65, 17 );
    // Result.Label10.TabOrder = -1
      Result.Label10 := NewLabel( Result.GroupBox3, 'Title' ).SetPosition( 8, 27 ).SetSize( 41, 17 );
    // Result.edTitleText.TabOrder = 0
      Result.edTitleText := NewEditBox( Result.GroupBox3, [  ] ).SetPosition( 48, 24 ).SetSize( 137, 0 );
    Result.edTitleText.Color := clWindow;
    // Result.cbTitleIcon.TabOrder = 1
      Result.cbTitleIcon := NewComboBox( Result.GroupBox3, [ coNoIntegralHeight ] ).SetPosition( 72, 56 ).SetSize( 113, 0 );
    Result.cbTitleIcon.Color := clWindow;
      Result.cbTitleIcon.Items[ 0 ] := 'itNoIcon';
      Result.cbTitleIcon.Items[ 1 ] := 'itInfoIcon';
      Result.cbTitleIcon.Items[ 2 ] := 'itWarningIcon';
      Result.cbTitleIcon.Items[ 3 ] := 'itErrorIcon';
      Result.cbTitleIcon.CurIndex := 1;
      Result.lblFontColor.OnClick := Result.lblFontColorClick;
      Result.edMaxWidth.OnChange := Result.edMaxWidthChange;
      Result.edBottom.OnChange := Result.edMarginChange;
      Result.edTop.OnChange := Result.edMarginChange;
      Result.edRight.OnChange := Result.edMarginChange;
      Result.edLeft.OnChange := Result.edMarginChange;
      Result.edTitleText.OnChange := Result.edTitleTextChange;
      Result.edDelayReshow.OnChange := Result.edDelayReshowChange;
      Result.edDelayTime.OnChange := Result.edDelayTimeChange;
      Result.edDelayInit.OnChange := Result.edDelayInitChange;
      Result.edDelayAutomatic.OnChange := Result.edDelayAutomaticChange;
      Result.Button7.OnClick := Result.Button7Click;
      Result.TrackingPanel.OnMouseMove := Result.TrackingPanelMouseMove;
      Result.TrackingPanel.OnMouseEnter := Result.TrackingPanelMouseEnter;
      Result.TrackingPanel.OnMouseLeave := Result.MouseLeave;
      Result.Button1.OnClick := Result.Button1Click;
      Result.cbTitleIcon.OnChange := Result.edTitleTextChange;
      Result.TrackingTreeView.OnMouseMove := Result.TrackingListBoxMouseMove;
      Result.TrackingTreeView.OnMouseEnter := Result.TrackingTreeViewMouseEnter;
      Result.TrackingTreeView.OnMouseLeave := Result.MouseLeave;
      Result.cbAlwaysTip.OnClick := Result.cbAlwaysTipClick;
      Result.cbBalloon.OnClick := Result.cbBalloonClick;
      Result.pnlColor.OnClick := Result.pnlColorClick;
    Result.KOLFormFormCreate( Result );

end;


