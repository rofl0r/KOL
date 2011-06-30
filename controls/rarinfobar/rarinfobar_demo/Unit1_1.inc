{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 192, 114 ).SetClientSize( 192, 216 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.Color := clPurple;
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontName := 'Tahoma';
    Result.Form.Border := 0;
    // Result.RarInfoBar1.TabOrder = 0
    Result.RarInfoBar1 := NewTRarInfoBar( Result.Form ).SetPosition( 61, 18 ).SetSize( 70, 180 );
    Result.RarInfoBar1.Position := 67;
    Result.RarInfoBar1.Min := 0;
    Result.RarInfoBar1.Max := 100;
    Result.RarInfoBar1.ShowPercent := True;
    Result.RarInfoBar1.LineColor := $FFE0E0;
    Result.RarInfoBar1.TopColor := $FF8080;
    Result.RarInfoBar1.SideColor1 := $E06868;
    Result.RarInfoBar1.SideColor2 := $FF8080;
    Result.RarInfoBar1.EmptyFrameColor1 := $A06868;
    Result.RarInfoBar1.EmptyFrameColor2 := $BF8080;
    Result.RarInfoBar1.EmptyColor1 := $C06868;
    Result.RarInfoBar1.EmptyColor2 := $DF8080;
    Result.RarInfoBar1.BottomFrameColor := $64408C;
    Result.RarInfoBar1.BottomColor := $7A408C;
    Result.RarInfoBar1.FilledFrameColor := $8060A0;
    Result.RarInfoBar1.FilledSideColor1 := $823C96;
    Result.RarInfoBar1.FilledSideColor2 := $8848C0;
    Result.RarInfoBar1.FilledColor := $A060A0;
    Result.Form.CenterOnParent.CanResize := False;

end;

