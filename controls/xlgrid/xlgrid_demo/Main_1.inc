{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PMainForm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'XLGrid Demo' ).SetPosition( 296, 89 ).SetClientSize( 775, 548 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.ColorDialog := NewColorDialog( ccoFullOpen );
  Result.Form.Add2AutoFree( Result.ColorDialog );


    Result.MHFontDialog:=NewMHFontDialog(Result.Form);
    Result.MHFontDialog.MinFontSize:=0;
    Result.MHFontDialog.MaxFontSize:=0;
    Result.MHFontDialog.Device:=fdBoth;
    Result.MHFontDialog.Options:= [];
  Result.Form.Add2AutoFree( Result.MHFontDialog );
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caLeft ).SetSize( 203, 0 );
    Result.Panel1.Color := clBtnFace;
    Result.Panel1.Font.FontHeight := 10;
    // Result.Button3.TabOrder = 0
      Result.Button3 := NewButton( Result.Panel1, 'Button3' ).SetPosition( 149, 505 );
    // Result.gbStyle.TabOrder = 1
      Result.gbStyle := NewGroupBox( Result.Panel1, 'GridStyle' ).SetPosition( 5, 5 ).SetSize( 185, 49 );
    Result.gbStyle.TabStop := FALSE;
      Result.gbStyle.EraseBackground := TRUE;
    // Result.rbXL.TabOrder = 0
        Result.rbXL := NewRadioBox( Result.gbStyle, 'gsXL' ).SetPosition( 120, 20 ).SetSize( 53, 0 );
    // Result.rbStandard.TabOrder = 1
        Result.rbStandard := NewRadioBox( Result.gbStyle, 'gsStandard' ).SetPosition( 12, 20 ).SetSize( 101, 0 );
        Result.rbStandard.SetRadioChecked;
    // Result.gbOptions.TabOrder = 2
      Result.gbOptions := NewGroupBox( Result.Panel1, 'Options' ).SetPosition( 5, 57 ).SetSize( 185, 213 );
    Result.gbOptions.TabStop := FALSE;
      Result.gbOptions.EraseBackground := TRUE;
    // Result.Label2.TabOrder = -1
        Result.Label2 := NewLabel( Result.gbOptions, '(+Alt for Moving)' ).SetPosition( 16, 140 ).SetSize( 161, 0 );
        Result.Label2.EraseBackground := TRUE;
    // Result.Label1.TabOrder = -1
        Result.Label1 := NewLabel( Result.gbOptions, '(+Ctrl for Multi Select)' ).SetPosition( 16, 80 ).SetSize( 161, 0 );
        Result.Label1.EraseBackground := TRUE;
    // Result.cbxlgRangeSelect.TabOrder = 1
        Result.cbxlgRangeSelect := NewCheckBox( Result.gbOptions, 'xlgRangeSelect' ).SetPosition( 16, 20 ).SetSize( 153, 0 );
        Result.cbxlgRangeSelect.EraseBackground := TRUE;
        Result.cbxlgRangeSelect.Checked := TRUE;
    // Result.cbxlgColsSelect.TabOrder = 2
        Result.cbxlgColsSelect := NewCheckBox( Result.gbOptions, 'xlgColsSelect' ).SetPosition( 16, 40 ).SetSize( 125, 0 );
        Result.cbxlgColsSelect.EraseBackground := TRUE;
    // Result.cbxlgRowsSelect.TabOrder = 3
        Result.cbxlgRowsSelect := NewCheckBox( Result.gbOptions, 'xlgRowsSelect' ).SetPosition( 16, 60 ).SetSize( 149, 0 );
        Result.cbxlgRowsSelect.EraseBackground := TRUE;
    // Result.cbxlgColSizing.TabOrder = 4
        Result.cbxlgColSizing := NewCheckBox( Result.gbOptions, 'xlgColSizing' ).SetPosition( 16, 164 ).SetSize( 145, 0 );
        Result.cbxlgColSizing.EraseBackground := TRUE;
    // Result.cbxlgRowSizing.TabOrder = 5
        Result.cbxlgRowSizing := NewCheckBox( Result.gbOptions, 'xlgRowSizing' ).SetPosition( 16, 184 ).SetSize( 141, 0 );
        Result.cbxlgRowSizing.EraseBackground := TRUE;
    // Result.cbxlgColMoving.TabOrder = 6
        Result.cbxlgColMoving := NewCheckBox( Result.gbOptions, 'xlgColMoving' ).SetPosition( 16, 100 ).SetSize( 137, 0 );
        Result.cbxlgColMoving.EraseBackground := TRUE;
    // Result.cbxlgRowMoving.TabOrder = 7
        Result.cbxlgRowMoving := NewCheckBox( Result.gbOptions, 'xlgRowMoving' ).SetPosition( 16, 120 ).SetSize( 137, 0 );
        Result.cbxlgRowMoving.EraseBackground := TRUE;
    // Result.gbLines.TabOrder = 3
      Result.gbLines := NewGroupBox( Result.Panel1, 'Lines' ).SetPosition( 5, 273 ).SetSize( 185, 101 );
    Result.gbLines.TabStop := FALSE;
      Result.gbLines.EraseBackground := TRUE;
    // Result.Label4.TabOrder = -1
        Result.Label4 := NewLabel( Result.gbLines, 'Right' ).SetPosition( 52, 20 ).SetSize( 37, 17 );
        Result.Label4.Transparent := True;
        Result.Label4.EraseBackground := TRUE;
    // Result.Label3.TabOrder = -1
        Result.Label3 := NewLabel( Result.gbLines, 'Left' ).SetPosition( 8, 20 ).SetSize( 26, 17 );
        Result.Label3.Transparent := True;
        Result.Label3.EraseBackground := TRUE;
    // Result.Label6.TabOrder = -1
        Result.Label6 := NewLabel( Result.gbLines, 'Bottom' ).SetPosition( 140, 20 ).SetSize( 36, 17 );
        Result.Label6.Transparent := True;
        Result.Label6.EraseBackground := TRUE;
    // Result.Label5.TabOrder = -1
        Result.Label5 := NewLabel( Result.gbLines, 'Top' ).SetPosition( 96, 20 ).SetSize( 29, 17 );
        Result.Label5.Transparent := True;
        Result.Label5.EraseBackground := TRUE;
    // Result.UpDownRight.TabOrder = 0
        Result.UpDownRight := PMHUpDown( NewMHUpDown( Result.gbLines, udVertical, False, False, False, False, False,True,udRight ));
        Result.UpDownRight.EraseBackground := TRUE;
        Result.UpDownRight.Max:=10;
        Result.UpDownRight.Min:=0;
        Result.UpDownRight.Position:=1;
        Result.UpDownRight.Increment:=1;
    // Result.UpDownLeft.TabOrder = 0
        Result.UpDownLeft := PMHUpDown( NewMHUpDown( Result.gbLines, udVertical, False, False, False, False, False,True,udRight ));
        Result.UpDownLeft.EraseBackground := TRUE;
        Result.UpDownLeft.Max:=10;
        Result.UpDownLeft.Min:=0;
        Result.UpDownLeft.Position:=1;
        Result.UpDownLeft.Increment:=1;
    // Result.UpDownTop.TabOrder = 0
        Result.UpDownTop := PMHUpDown( NewMHUpDown( Result.gbLines, udVertical, False, False, False, False, False,True,udRight ));
        Result.UpDownTop.EraseBackground := TRUE;
        Result.UpDownTop.Max:=10;
        Result.UpDownTop.Min:=0;
        Result.UpDownTop.Position:=1;
        Result.UpDownTop.Increment:=1;
    // Result.UpDownBottom.TabOrder = 0
        Result.UpDownBottom := PMHUpDown( NewMHUpDown( Result.gbLines, udVertical, False, False, False, False, False,True,udRight ));
        Result.UpDownBottom.EraseBackground := TRUE;
        Result.UpDownBottom.Max:=10;
        Result.UpDownBottom.Min:=0;
        Result.UpDownBottom.Position:=1;
        Result.UpDownBottom.Increment:=1;
    // Result.EditBox2.TabOrder = 1
        Result.EditBox2 := NewEditBox( Result.gbLines, [ eoReadonly ] ).SetPosition( 52, 36 ).SetSize( 20, 0 );
    Result.EditBox2.Color := clWindow;
        Result.EditBox2.EraseBackground := TRUE;
        Result.EditBox2.Text := '1';
    // Result.EditBox3.TabOrder = 2
        Result.EditBox3 := NewEditBox( Result.gbLines, [ eoReadonly ] ).SetPosition( 96, 36 ).SetSize( 20, 0 );
    Result.EditBox3.Color := clWindow;
        Result.EditBox3.EraseBackground := TRUE;
        Result.EditBox3.Text := '1';
    // Result.EditBox1.TabOrder = 2
        Result.EditBox1 := NewEditBox( Result.gbLines, [ eoReadonly ] ).SetPosition( 8, 36 ).SetSize( 20, 0 );
    Result.EditBox1.Color := clWindow;
        Result.EditBox1.EraseBackground := TRUE;
        Result.EditBox1.Text := '1';
    // Result.EditBox4.TabOrder = 2
        Result.EditBox4 := NewEditBox( Result.gbLines, [ eoReadonly ] ).SetPosition( 140, 36 ).SetSize( 20, 0 );
    Result.EditBox4.Color := clWindow;
        Result.EditBox4.EraseBackground := TRUE;
        Result.EditBox4.Text := '1';
    // Result.Button2.TabOrder = 3
        Result.Button2 := NewButton( Result.gbLines, 'Color' ).SetPosition( 8, 68 );
        Result.Button2.EraseBackground := TRUE;
    // Result.gbTitle.TabOrder = 4
      Result.gbTitle := NewGroupBox( Result.Panel1, 'Title' ).SetPosition( 5, 377 ).SetSize( 185, 85 );
    Result.gbTitle.TabStop := FALSE;
      Result.gbTitle.EraseBackground := TRUE;
    // Result.btnColor.TabOrder = 0
        Result.btnColor := NewButton( Result.gbTitle, 'Color' ).SetPosition( 12, 24 ).SetSize( 65, 0 );
        Result.btnColor.EraseBackground := TRUE;
    // Result.btnFont.TabOrder = 1
        Result.btnFont := NewButton( Result.gbTitle, 'Font' ).SetPosition( 12, 52 );
        Result.btnFont.EraseBackground := TRUE;
    // Result.btnSelectColor.TabOrder = 2
        Result.btnSelectColor := NewButton( Result.gbTitle, 'Select Color' ).SetPosition( 84, 24 ).SetSize( 89, 0 );
        Result.btnSelectColor.EraseBackground := TRUE;
    // Result.btnSelectFont.TabOrder = 2
        Result.btnSelectFont := NewButton( Result.gbTitle, 'Select Font' ).SetPosition( 84, 52 ).SetSize( 89, 0 );
        Result.btnSelectFont.EraseBackground := TRUE;
    // Result.cbTitleRowButton.TabOrder = 5
      Result.cbTitleRowButton := NewCheckBox( Result.Panel1, 'TitleRowButton' ).SetPosition( 5, 473 ).SetSize( 93, 0 );
      Result.cbTitleRowButton.EraseBackground := TRUE;
    // Result.cbTitleColButton.TabOrder = 6
      Result.cbTitleColButton := NewCheckBox( Result.Panel1, 'TitleColButton' ).SetPosition( 109, 473 ).SetSize( 89, 0 );
      Result.cbTitleColButton.EraseBackground := TRUE;
    // Result.btnSplit.TabOrder = 7
      Result.btnSplit := NewButton( Result.Panel1, 'Split' ).SetPosition( 77, 505 );
    Result.btnSplit.TabStop := FALSE;
      Result.btnSplit.Enabled := False;
      Result.btnSplit.EraseBackground := TRUE;
    // Result.btnMerge.TabOrder = 8
      Result.btnMerge := NewButton( Result.Panel1, 'Merge' ).SetPosition( 9, 505 );
    Result.btnMerge.TabStop := FALSE;
      Result.btnMerge.Enabled := False;
      Result.btnMerge.EraseBackground := TRUE;
    // Result.Editor_1.TabOrder = 1
    Result.Editor_1 := NewEditBox( Result.Form, [  ] ).SetPosition( 223, 288 );
    Result.Editor_1.HasBorder := FALSE;
    Result.Editor_1.Color := clWindow;
    Result.Editor_1.Visible := False;
    // Result.Editor_2.TabOrder = 2
    Result.Editor_2 := NewPanel( Result.Form, esNone ).SetPosition( 336, 272 ).SetSize( 153, 24 );
    Result.Editor_2.Color := $C0DCC0;
    Result.Editor_2.Border := 0;
    Result.Editor_2.Visible := False;
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Editor_2, '...' ).SetAlign ( caRight ).SetSize( 25, 0 );
    Result.Button1.TabStop := FALSE;
    // Result.CheckBox1.TabOrder = 3
    Result.CheckBox1 := NewCheckBox( Result.Form, 'CheckBox1' ).SetPosition( 487, 184 ).SetSize( 0, 23 );
    Result.CheckBox1.TabStop := FALSE;
    Result.CheckBox1.Visible := False;
    // Result.ComboBox1.TabOrder = 4
    Result.ComboBox1 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 564, 256 );
    Result.ComboBox1.Color := clWindow;
    Result.ComboBox1.Visible := False;
    Result.ComboBox1.Items[ 0 ] := 'ComboBox1';
    Result.ComboBox1.Items[ 1 ] := 'qwqqqq';
    Result.ComboBox1.Items[ 2 ] := 'wqqqq';
    Result.ComboBox1.Items[ 3 ] := 'qqqqqqqqqqqqqqqq';
    Result.ComboBox1.Items[ 4 ] := 'w';
    Result.ComboBox1.Items[ 5 ] := 'qdsxcsqdq';
    Result.ComboBox1.Items[ 6 ] := 'www';
    Result.ComboBox1.CurIndex := 0;
    // Result.XLGrid.TabOrder = 5
    Result.XLGrid := PmdvXLGrid( NewmdvXLGrid( Result.Form, 10, 10, gsStandard, [ xlgRangeSelect ] ).SetAlign ( caClient )).SetTitleRow([ 
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10' ]).SetTitleCol([ 
      'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X' ]);
    Result.XLGrid.TitleColor:= -16777201;
    Result.XLGrid.TitleSelectedColor:= -16777195;
    Result.XLGrid.TitleSelectedFontColor:= -16777196;
    Result.XLGrid.SelectedColor:= -16777203;
    Result.XLGrid.SelectedColorLine:= -16777202;
    Result.XLGrid.SelectedFontColor:= -16777202;
    Result.XLGrid.LineColor:= -16777200;
    Result.XLGrid.DefEditorEvents:= False;
    Result.XLGrid.Color := clWindow;
      Result.UpDownLeft.OnChangingEx := Result.UpDownLeftChangingEx;
    Result.UpDownLeft.Buddy:=Result.EditBox1.GetWindowHandle;
    Result.UpDownLeft.SetPosition( 28, 36 );
    Result.UpDownLeft.Height := 22;
    Result.EditBox1.Width := 20;
    Result.UpDownLeft.Width := 15;
      Result.UpDownRight.OnChangingEx := Result.UpDownRightChangingEx;
    Result.UpDownRight.Buddy:=Result.EditBox2.GetWindowHandle;
    Result.UpDownRight.SetPosition( 72, 36 );
    Result.UpDownRight.Height := 22;
    Result.EditBox2.Width := 20;
    Result.UpDownRight.Width := 15;
      Result.UpDownTop.OnChangingEx := Result.UpDownTopChangingEx;
    Result.UpDownTop.Buddy:=Result.EditBox3.GetWindowHandle;
    Result.UpDownTop.SetPosition( 116, 36 );
    Result.UpDownTop.Height := 22;
    Result.EditBox3.Width := 20;
    Result.UpDownTop.Width := 15;
      Result.rbXL.OnClick := Result.rbStyleClick;
      Result.UpDownBottom.OnChangingEx := Result.UpDownBottomChangingEx;
    Result.UpDownBottom.Buddy:=Result.EditBox4.GetWindowHandle;
    Result.UpDownBottom.SetPosition( 160, 36 );
    Result.UpDownBottom.Height := 22;
    Result.EditBox4.Width := 20;
    Result.UpDownBottom.Width := 15;
      Result.btnColor.OnClick := Result.btnColorClick;
      Result.cbxlgRangeSelect.OnClick := Result.cbxlgOptionsClick;
      Result.rbStandard.OnClick := Result.rbStyleClick;
      Result.btnFont.OnClick := Result.btnFontClick;
      Result.cbxlgColsSelect.OnClick := Result.cbxlgOptionsClick;
      Result.btnSelectColor.OnClick := Result.btnSelectColorClick;
      Result.btnSelectFont.OnClick := Result.btnSelectFontClick;
      Result.cbxlgRowsSelect.OnClick := Result.cbxlgOptionsClick;
      Result.Button2.OnClick := Result.Button2Click;
      Result.cbxlgColSizing.OnClick := Result.cbxlgOptionsClick;
      Result.cbTitleRowButton.OnClick := Result.cbTitleRowButtonClick;
      Result.cbxlgRowSizing.OnClick := Result.cbxlgOptionsClick;
      Result.XLGrid.OnFocusChange := Result.XLGridFocusChange;
      Result.XLGrid.OnBeginEdit := Result.XLGridBeginEdit;
      Result.XLGrid.OnEndEdit := Result.XLGridEndEdit;
      Result.XLGrid.OnSelectedChange := Result.XLGridSelectedChange;
      Result.XLGrid.OnDrawCell := Result.XLGridDrawCell;
      Result.XLGrid.OnDrawTitle := Result.XLGridDrawTitle;
      Result.cbxlgColMoving.OnClick := Result.cbxlgOptionsClick;
      Result.cbTitleColButton.OnClick := Result.cbTitleColButtonClick;
      Result.cbxlgRowMoving.OnClick := Result.cbxlgOptionsClick;
      Result.btnSplit.OnClick := Result.btnSplitClick;
      Result.btnMerge.OnClick := Result.btnMergeClick;
    Result.KOLFormFormCreate( Result );

end;


