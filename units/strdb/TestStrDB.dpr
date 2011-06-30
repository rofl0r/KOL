
program TestStrDB;

uses
  windows,
  messages,
  kol,
  StrDB in 'StrDB.pas';

const
  LVM_ENSUREVISIBLE       = LVM_FIRST + 19;
  LVM_SCROLL              = LVM_FIRST + 20;
  TestTableFileName       = 'TempTabl.asc';

var
  W, E1, E2, E3, P1, B0, B1, B2, B3, B4, B5, L1, L2, L3, L4, LV,
   BFirst, BPrior, BNext, BLast : PControl;
  TestStrTable: PStrTable;

procedure SetUpTestTable;
begin
  TestStrTable := NewStrTable;
  with TestStrTable^ do
  begin
//set up field definitions: Field Name, Field Width
    AddFldDef('Name', 32);
    AddFldDef('EMail', 32);
    AddFldDef('URL', 32);
//load table records - if any
    if fileexists(TestTableFileName) then
      RecList.LoadFromFile(TestTableFileName);
  end;
end;

procedure LoadRec;
begin
  with TestStrTable^ do
  begin
    SetFld('Name',E1.Text);
    SetFld('EMail',E2.Text);
    SetFld('URL',E3.Text);
  end;
end;

procedure RetrieveRec;
begin
  with TestStrTable^ do
  begin
    E1.Text := trimright(GetFld('Name'));
    E2.Text := trimright(GetFld('EMail'));
    E3.Text := trimright(GetFld('URL'));
    LV.LVSetItem(CurrRecNum,0,LV.LVItems[CurrRecNum,0],0,[lvisSelect],0,0,0);
    LV.Perform( LVM_ENSUREVISIBLE, CurrRecNum, 0);
    L4.Caption := int2str(CurrRecNum + 1) + ' of ' +
     int2str(RecList.Count);
  end;
end;

procedure ClrFlds;
begin
    E1.Text := '';
    E2.Text := '';
    E3.Text := '';
    E1.DoSetFocus;
end;

procedure AddRec;
begin
  LoadRec;
  TestStrTable.AddRec;
  TestStrTable.Last;
  FillListGrid( LV, TestStrTable );
  RetrieveRec;
end;

procedure InsertRec;
begin
  LoadRec;
  TestStrTable.InsertRec;
  FillListGrid( LV, TestStrTable );
  RetrieveRec;
end;

procedure PostRec;
begin
  LoadRec;
  TestStrTable.PostRec;
  FillListGrid( LV, TestStrTable );
  RetrieveRec;
end;

procedure DelRec;
begin
  LoadRec;
  TestStrTable.DeleteRec;
  FillListGrid( LV, TestStrTable );
  RetrieveRec;
end;

procedure Save;
begin
  TestStrTable.RecList.SaveToFile(TestTableFileName);
end;

procedure First;
begin
  TestStrTable.First;
  RetrieveRec;
end;

procedure Prior;
begin
  TestStrTable.Prior;
  RetrieveRec;
end;

procedure Next;
begin
  TestStrTable.Next;
  RetrieveRec;
end;

procedure Last;
begin
  TestStrTable.Last;
  RetrieveRec;
end;

procedure LVMouseDown( Dummy : Pointer; Sender: PControl; var MouseData: TMouseEventData);
begin
  with TestStrTable^ do
  begin
    CurrRecNum :=  LV.LVItemAtPos(MouseData.x, MouseData.y);
    E1.Text := trimright(GetFld('Name'));
    E2.Text := trimright(GetFld('EMail'));
    E3.Text := trimright(GetFld('URL'));
    L4.Caption := int2str(CurrRecNum + 1) + ' of ' +
     int2str(RecList.Count);
  end;
end;

procedure TestObjs;
begin

  W := NewForm( Applet, 'Test String DataBase' );
  W.Tabulate;
  L1 := NewLabel( W, 'Name' );
  E1 := NewEditbox( W, [ ] ).PlaceDown;
  E1.Width := 128;
  E2 := NewEditbox( W, [ ] ).PlaceRight;
  E2.Width := 128;
  E3 := NewEditbox( W, [ ] ).PlaceRight.ResizeParent;
  E3.Width := 128;

  LV := NewListView( W,
                        //lvsIcon, [lvoGridLines, lvoButton, lvoHideSel],
                        //lvsDetail, [lvoGridLines,lvoEditLabel],
                        //lvsDetail, [lvoRowSelect,lvoTrackSelect],
                        //lvsDetail, [lvoMultiselect],
                        //lvsDetail, [lvoCheckBoxes,lvoFlatsb],
                        lvsDetail, [lvoRowSelect,lvoGridLines],
                        NewImageList( W ), nil, nil ).PlaceDown.SetSize( 0,100);

  SetUpTestTable;

  FillListView( LV, TestStrTable );

  LV.OnMouseDown := TOnMouse( MakeMethod( nil, @LVMouseDown ) );
  
  LV.ResizeParent;

  L4 := NewLabel (W, int2str(TestStrTable.RecList.Count) + ' Recs').PlaceDown;
  L4.Left := 4;
  L4.Width := 75;

  BFirst := NewButton (W, '<< First').PlaceRight;
  BFirst.OnClick := TOnEvent( MakeMethod( nil, @First ) );

  BPrior := NewButton (W, '< Prior').PlaceRight;
  BPrior.OnClick := TOnEvent( MakeMethod( nil, @Prior ) );

  BNext := NewButton (W, 'Next >').PlaceRight;
  BNext.OnClick := TOnEvent( MakeMethod( nil, @Next ) );

  BLast := NewButton (W, 'Last >>').PlaceRight;
  BLast.OnClick := TOnEvent( MakeMethod( nil, @Last ) );

  BLast.ResizeParent;

  P1 := NewPanel( W, esRaised );
  P1.Left := LV.Width + 4;
  L1 := NewLabel( P1, 'Action:' );

  B0 := NewButton( P1, 'Clr Flds' ).PlaceDown;
  B0.Width := 80;
  B0.OnClick := TOnEvent( MakeMethod( nil, @ClrFlds ) );

  B1 := NewButton( P1, 'Add Rec' ).PlaceDown;
  B1.Width := 80;
  B1.OnClick := TOnEvent( MakeMethod( nil, @AddRec ) );

  B2 := NewButton( P1, 'Insert Rec' ).PlaceDown;
  B2.Width := 80;
  B2.OnClick := TOnEvent( MakeMethod( nil, @InsertRec ) );

  B3 := NewButton( P1, 'Post Rec' ).PlaceDown;
  B3.Width := 80;
  B3.OnClick := TOnEvent( MakeMethod( nil, @PostRec ) );

  B4 := NewButton( P1, 'Del Rec' ).PlaceDown;
  B4.Width := 80;
  B4.OnClick := TOnEvent( MakeMethod( nil, @DelRec ) );

  B5 := NewButton( P1, 'Save' ).PlaceDown;
  B5.Width := 80;
  B5.OnClick := TOnEvent( MakeMethod( nil, @Save ) );

  B5.ResizeParent;

  P1.ResizeParent;

  L2 := NewLabel( W, 'EMail' ).AlignTop(L1).AlignLeft( E2 );
  L3 := NewLabel( W, 'URL' ).AlignLeft( E3 );

//  First;

  Run( W );

end;

begin

  TestObjs;

end.

