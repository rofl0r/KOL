{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Проверка СОМ-порта' ).SetPosition( 417, 209 ).SetSize( 237, 163 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnMessage := Result.KOLForm1Message;
      Result.Form.OnClose := Result.KOLForm1Close;


    Result.Com2:=NewKOLCom(Result.Form);
    Result.Com2.NumPort:=2;
    Result.Com2.BaudRate:=9600;
    Result.Com2.StopBits:=Two;
    Result.Com2.EventMask:=[evRxChar, evTxEmpty, evCTS, evDSR];
    Result.Com2.CtrDTR:=True;
    Result.Com2.CtrRTS:=True;
    Result.Com2.DTR:=False;
    Result.Com2.RTS:=False;
    Result.Com2.OnModem := Result.Com2Modem;
    Result.Com2.OnRxByte := Result.Com2RxByte;
  Result.Form.Add2AutoFree( Result.Com2 );


    Result.Com1:=NewKOLCom(Result.Form);
    Result.Com1.NumPort:=1;
    Result.Com1.BaudRate:=9600;
    Result.Com1.StopBits:=Two;
    Result.Com1.EventMask:=[evRxChar, evTxEmpty, evCTS, evDSR];
    Result.Com1.CtrDTR:=True;
    Result.Com1.CtrRTS:=True;
    Result.Com1.DTR:=False;
    Result.Com1.RTS:=False;
    Result.Com1.OnModem := Result.Com1Modem;
    Result.Com1.OnRxByte := Result.Com1RxByte;
  Result.Form.Add2AutoFree( Result.Com1 );
    // Result.btStart.TabOrder = 0
    Result.btStart := NewButton( Result.Form, 'Пуск' ).SetPosition( 20, 112 ).SetSize( 83, 0 );
      Result.btStart.OnClick := Result.btStartClick;
    // Result.btStop.TabOrder = 0
    Result.btStop := NewButton( Result.Form, 'Стоп' ).SetPosition( 123, 112 ).SetSize( 83, 0 );
    Result.btStop.Enabled := False;
      Result.btStop.OnClick := Result.btStopClick;
    // Result.cbDTR1.TabOrder = 1
    Result.cbDTR1 := NewCheckBox( Result.Form, 'DTR' ).SetPosition( 3, 28 ).SetSize( 53, 0 );
    Result.cbDTR1.Font.FontStyle := [ fsBold ];
    Result.cbDTR1.Font.FontHeight := 8;
      Result.cbDTR1.OnClick := Result.cbDTR1Click;
    // Result.cbRTS1.TabOrder = 1
    Result.cbRTS1 := NewCheckBox( Result.Form, 'RTS' ).SetPosition( 56, 28 ).SetSize( 53, 0 );
    Result.cbRTS1.Font.FontStyle := [ fsBold ];
    Result.cbRTS1.Font.FontHeight := 8;
      Result.cbRTS1.OnClick := Result.cbRTS1Click;
    // Result.cbDTR2.TabOrder = 1
    Result.cbDTR2 := NewCheckBox( Result.Form, 'DTR' ).SetPosition( 118, 28 ).SetSize( 53, 0 );
    Result.cbDTR2.Font.FontStyle := [ fsBold ];
    Result.cbDTR2.Font.FontHeight := 8;
      Result.cbDTR2.OnClick := Result.cbDTR2Click;
    // Result.cbRTS2.TabOrder = 1
    Result.cbRTS2 := NewCheckBox( Result.Form, 'RTS' ).SetPosition( 174, 28 ).SetSize( 53, 0 );
    Result.cbRTS2.Font.FontStyle := [ fsBold ];
    Result.cbRTS2.Font.FontHeight := 8;
      Result.cbRTS2.OnClick := Result.cbRTS2Click;
    // Result.cbDSR1.TabOrder = 1
    Result.cbDSR1 := NewCheckBox( Result.Form, 'DSR' ).SetPosition( 3, 48 ).SetSize( 53, 0 );
    Result.cbDSR1.Font.FontStyle := [ fsBold ];
    Result.cbDSR1.Font.FontHeight := 8;
    Result.cbDSR1.Enabled := False;
    // Result.cbCTS1.TabOrder = 1
    Result.cbCTS1 := NewCheckBox( Result.Form, 'CTS' ).SetPosition( 56, 48 ).SetSize( 53, 0 );
    Result.cbCTS1.Font.FontStyle := [ fsBold ];
    Result.cbCTS1.Font.FontHeight := 8;
    Result.cbCTS1.Enabled := False;
    // Result.cbCTS2.TabOrder = 1
    Result.cbCTS2 := NewCheckBox( Result.Form, 'CTS' ).SetPosition( 174, 48 ).SetSize( 53, 0 );
    Result.cbCTS2.Font.FontStyle := [ fsBold ];
    Result.cbCTS2.Font.FontHeight := 8;
    Result.cbCTS2.Enabled := False;
    // Result.cbDSR2.TabOrder = 1
    Result.cbDSR2 := NewCheckBox( Result.Form, 'DSR' ).SetPosition( 118, 48 ).SetSize( 53, 0 );
    Result.cbDSR2.Font.FontStyle := [ fsBold ];
    Result.cbDSR2.Font.FontHeight := 8;
    Result.cbDSR2.Enabled := False;
    // Result.cbCom1.TabOrder = 2
    Result.cbCom1 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 4, 0 ).SetSize( 78, 0 );
    Result.cbCom1.Color := clWindow;
      Result.cbCom1.OnChange := Result.cbCom1Change;
    Result.cbCom1.CurIndex := 0;
    // Result.cbCom2.TabOrder = 2
    Result.cbCom2 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 118, 0 ).SetSize( 78, 0 );
    Result.cbCom2.Color := clWindow;
    Result.cbCom2.CurIndex := 0;
    // Result.Led1.TabOrder = 3

    Result.Led1:=NewKOLLed(Result.Form,True);
    Result.Led1.SetPosition(88,3).SetSize(20,16);
    Result.Led1.Blick:=True;
    Result.Led1.ColorOn:=255;
    Result.Led1.ColorOff:=128;
    Result.Led1.ColorBlick:=16711935;
    Result.Led1.Shape:=lsCircle;
    // Result.RadioBox3.TabOrder = 4
    Result.RadioBox3 := NewRadioBox( Result.Form, '19200' ).SetPosition( 158, 76 ).SetSize( 70, 16 );
      Result.RadioBox3.OnClick := Result.RadioBox1Click;
    // Result.RadioBox5.TabOrder = 4
    Result.RadioBox5 := NewRadioBox( Result.Form, '57600' ).SetPosition( 83, 92 ).SetSize( 70, 16 );
      Result.RadioBox5.OnClick := Result.RadioBox1Click;
    // Result.RadioBox6.TabOrder = 4
    Result.RadioBox6 := NewRadioBox( Result.Form, '115200' ).SetPosition( 158, 92 ).SetSize( 70, 16 );
      Result.RadioBox6.OnClick := Result.RadioBox1Click;
    // Result.RadioBox2.TabOrder = 4
    Result.RadioBox2 := NewRadioBox( Result.Form, '9600' ).SetPosition( 83, 76 ).SetSize( 70, 16 );
      Result.RadioBox2.OnClick := Result.RadioBox1Click;
    Result.RadioBox2.SetRadioChecked;
    // Result.RadioBox1.TabOrder = 4
    Result.RadioBox1 := NewRadioBox( Result.Form, '4800' ).SetPosition( 8, 76 ).SetSize( 70, 16 );
      Result.RadioBox1.OnClick := Result.RadioBox1Click;
    // Result.RadioBox4.TabOrder = 4
    Result.RadioBox4 := NewRadioBox( Result.Form, '38400' ).SetPosition( 8, 92 ).SetSize( 70, 16 );
      Result.RadioBox4.OnClick := Result.RadioBox1Click;
    // Result.Led2.TabOrder = 5

    Result.Led2:=NewKOLLed(Result.Form,True);
    Result.Led2.SetPosition(204,4).SetSize(20,16);
    Result.Led2.Blick:=True;
    Result.Led2.ColorOn:=255;
    Result.Led2.ColorOff:=128;
    Result.Led2.ColorBlick:=16711935;
    Result.Led2.Shape:=lsCircle;
    Result.KOLForm1FormCreate( Result );

end;


