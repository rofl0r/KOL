{ KOL MCK } // Do not remove this line!
const mShow = 0;
const mHide = 1;
const mExit = 3;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.CreateParented( Applet );
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'BAPTrayIcon v1.05' ).SetPosition( 207, 51 ).SetClientSize( 328, 406 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.IconLoad( hInstance, 'IC1' );
    Result.Form.Font.FontHeight := 8;
      Result.Form.OnMessage := Result.KOLForm1Message;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnHide := Result.KOLForm1Hide;
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.PopupMenu1 := NewMenu( Result.Form, 0, [ 'Показать'
      , 'Спрятать', '-' + '', 'Выход', '' ], nil );
    Result.PopupMenu1.AssignEvents( 0, [ Result.PopupMenu1mShowMenu ] );
    Result.PopupMenu1.AssignEvents( 1, [ Result.PopupMenu1mHideMenu ] );
    Result.PopupMenu1.AssignEvents( 3, [ Result.PopupMenu1mExitMenu ] );

{$R icons.res}
    Result.BAPTrayIcon1 := NewBAPTrayIcon(Applet);
    Result.BAPTrayIcon1.HideBallOnTimer := True;
    Result.BAPTrayIcon1.PopupMenu := Result.PopupMenu1.Handle;
    Result.BAPTrayIcon1.ToolTip := 'BAPTrayIcon v1.05';
    Result.BAPTrayIcon1.LoadTrayIcon('ic1');
    Result.BAPTrayIcon1.Active := True;
  Result.Form.Add2AutoFree( Result.BAPTrayIcon1 );
      Result.BAPTrayIcon1.OnMouseDown := Result.BAPTrayIcon1MouseDown;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Для Windows ME и NT5.x и выше' ).SetPosition( 64, 152 ).SetSize( 201, 17 );
    Result.Label1.Font.FontStyle := [ fsBold ];
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewWordWrapLabel( Result.Form, 'Время показа Balloon''а Timeout = 1..30 Sec.' ).SetPosition( 8, 172 ).SetSize( 121, 29 );
    // Result.bShowIcon.TabOrder = 0
    Result.bShowIcon := NewButton( Result.Form, 'Показать иконку' ).SetPosition( 8, 8 ).SetSize( 121, 0 );
    // Result.bDelIcon.TabOrder = 1
    Result.bDelIcon := NewButton( Result.Form, 'Удалить иконку' ).SetPosition( 8, 40 ).SetSize( 121, 0 );
    // Result.ebHint.TabOrder = 2
    Result.ebHint := NewEditBox( Result.Form, [  ] ).SetPosition( 136, 8 ).SetSize( 185, 0 );
    Result.ebHint.Color := clWindow;
    Result.ebHint.Text := 'Всплывающая подсказка';
    // Result.bToolTip.TabOrder = 3
    Result.bToolTip := NewButton( Result.Form, 'Изменить текст подсказки' ).SetPosition( 144, 40 ).SetSize( 169, 0 );
    // Result.CheckBox1.TabOrder = 4
    Result.CheckBox1 := NewCheckBox( Result.Form, 'При показе удалять иконку из System Tray' ).SetPosition( 8, 72 ).SetSize( 241, 0 );
    // Result.cbHideMin.TabOrder = 5
    Result.cbHideMin := NewCheckBox( Result.Form, 'Прятать окно при минимизации' ).SetPosition( 8, 96 ).SetSize( 185, 0 );
    Result.cbHideMin.Checked := TRUE;
    // Result.cbHideClose.TabOrder = 6
    Result.cbHideClose := NewCheckBox( Result.Form, 'Прятать окно при закрытии' ).SetPosition( 8, 120 ).SetSize( 161, 0 );
    Result.cbHideClose.Checked := TRUE;
    // Result.bIcon1.TabOrder = 7
    Result.bIcon1 := NewButton( Result.Form, 'Icon 1' ).SetPosition( 200, 96 ).SetSize( 57, 0 );
    // Result.bIcon2.TabOrder = 8
    Result.bIcon2 := NewButton( Result.Form, 'Icon 2' ).SetPosition( 264, 96 ).SetSize( 57, 0 );
    // Result.bIcon4.TabOrder = 9
    Result.bIcon4 := NewButton( Result.Form, 'Прежняя иконка' ).SetPosition( 200, 120 ).SetSize( 121, 0 );
    // Result.ebTimeout.TabOrder = 10
    Result.ebTimeout := NewEditBox( Result.Form, [ eoNumber ] ).SetPosition( 136, 176 ).SetSize( 57, 0 );
    Result.ebTimeout.Color := clWindow;
    Result.ebTimeout.Text := '3';
    // Result.cbHideBall.TabOrder = 11
    Result.cbHideBall := NewCheckBox( Result.Form, 'Скрывать Balloon по таймеру' ).SetPosition( 16, 208 ).SetSize( 169, 0 );
    Result.cbHideBall.Checked := TRUE;
    // Result.ebBTitle.TabOrder = 12
    Result.ebBTitle := NewEditBox( Result.Form, [  ] ).SetPosition( 8, 240 ).SetSize( 313, 0 );
    Result.ebBTitle.Color := clWindow;
    Result.ebBTitle.Text := 'Balloon Title';
    // Result.mBText.TabOrder = 13
    Result.mBText := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 8, 272 ).SetSize( 313, 57 );
    Result.mBText.Color := clWindow;
    Result.mBText.Text := 'Balloon Text'+#13+#10;
    // Result.GroupBox1.TabOrder = 14
    Result.GroupBox1 := NewGroupBox( Result.Form, 'Тип иконки для Balloon' ).SetPosition( 8, 336 ).SetSize( 313, 65 );
    Result.GroupBox1.TabStop := FALSE;
    // Result.RadioBox1.TabOrder = 0
      Result.RadioBox1 := NewRadioBox( Result.GroupBox1, 'Нет' ).SetPosition( 8, 16 ).SetSize( 41, 0 );
      Result.RadioBox1.SetRadioChecked;
    // Result.RadioBox2.TabOrder = 1
      Result.RadioBox2 := NewRadioBox( Result.GroupBox1, 'Инфо' ).SetPosition( 64, 16 ).SetSize( 49, 0 );
    // Result.RadioBox3.TabOrder = 2
      Result.RadioBox3 := NewRadioBox( Result.GroupBox1, 'Предупреждение' ).SetPosition( 128, 16 ).SetSize( 105, 0 );
    // Result.RadioBox4.TabOrder = 3
      Result.RadioBox4 := NewRadioBox( Result.GroupBox1, 'Ошибка' ).SetPosition( 240, 16 ).SetSize( 65, 0 );
    // Result.cbNoSound.TabOrder = 4
      Result.cbNoSound := NewCheckBox( Result.GroupBox1, 'NIIF_NOSOUND  - начиная с Windosw XP и выше.' ).SetPosition( 24, 40 ).SetSize( 273, 0 );
    // Result.bShowBalloon.TabOrder = 15
    Result.bShowBalloon := NewButton( Result.Form, 'Показать Balloon' ).SetPosition( 200, 176 ).SetSize( 121, 0 );
    // Result.bHideBalloon.TabOrder = 16
    Result.bHideBalloon := NewButton( Result.Form, 'Спрятать Balloon' ).SetPosition( 200, 204 ).SetSize( 121, 0 );
      Result.bShowIcon.OnClick := Result.bShowIconClick;
      Result.bDelIcon.OnClick := Result.bDelIconClick;
      Result.bToolTip.OnClick := Result.bToolTipClick;
      Result.bIcon1.OnClick := Result.bIcon1Click;
      Result.bIcon2.OnClick := Result.bIcon2Click;
      Result.bIcon4.OnClick := Result.bIcon4Click;
      Result.cbHideBall.OnClick := Result.cbHideBallClick;
      Result.bShowBalloon.OnClick := Result.bShowBalloonClick;
      Result.bHideBalloon.OnClick := Result.bHideBalloonClick;
    Result.Form.CanResize := False;
    Result.Form.SetAutoPopupMenu( Result.PopupMenu1 );

end;

