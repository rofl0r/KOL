{********************************************************
 *** dBase (R) File Handling for KOL                  ***
 *** DEMO program                                     ***
 *** (C)2001, Thaddy de Koning.                       ***
 *** This implementation: Thaddy de Koning            ***
 *** email: thaddy@thaddy.com                         ***
 ********************************************************
 *** Copyrighted freeware for Commercial              ***
 *** and Non-commercial use.                          ***
 *** Use as you like, no guarantees and no warranties ***
 *** And most certainly not any liabilities!!!        ***
 ********************************************************

 This example uses a TdbReader object to read any dBase
 compliant database file. It's a pretty complete dBase browser at under 45k
 and it can be even smaller if you drop the frills.
 It's tested on dBase tables of over 10.000 records and it performs ok.
 Just the user interface, the grid, makes it slow at first.
 This can be improved, see notes, up to yourself though.
 It is by no means complete or anywhere near neat.
 (Although the dbReader control itself performs to specification,
  and that's what this is about)
 It does not as yet read General and Blobfields.
 It does not as yet Support indexfiles.
 It DOES:
 - Correctly format the fields, at least in the Grid
   (SNAG:Dutch Date lay-out, i.e:Dd-MM-YYY, look at the code,
   it's easy to change it)
 - Display dBase III+ and dBase IV type MemoFields
 - Shows some work-around for the incomplete implementation
   of the listview component.

 The source is heavily commented, use it as you like, BUT
 - I will add the missing features myself, or I will include your
   code suggestions after I've checked/tested -and probably modified ;)-them.
 - So please do not distribute modified versions without me knowing about it!

To understand the structure of this program I suggest you start reading the
comments from the main procedure 'TestdBase' and work your way up from there.

I can use some help with the ListView handling:
I can't get it to work properly.
First problem: How to get at the selected Item
_______________^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}




program tdkdbdemo;
{Version 1.01, includes memofieldsupport}
uses
  Windows,
  Messages,
  Kol      in 'Kol.pas',
  tdkDbKol in 'tdkdbKol.pas';

{$R *.RES}
const
  LVM_SETITEMCOUNT        = LVM_FIRST + 47;
  LVM_ENSUREVISIBLE       = LVM_FIRST + 19;
var
Applet,             {Application object}
Form,               {Main Form}
Panel,              {Holder for Toolbar}
Toolbar,            {Toolbar}
MemoForm,           {To display a memofield}
Memo,               {idem}
Tabs,               {Tabcontrol to hold both multirecord Grid and single record data}
Grid                {ListView Object}
      :pControl;
Labels,             {Holds Labels}
Ctrls: pList;       {Holds edit controls}
Reader:pdbReader;   {dBase file reader object}

procedure UpdateControls;
var i:integer;
begin
  for i:=0 to Reader.FieldCount-1 do
    with pDbField(Reader.Fields.Items[i])^ do
      pControl(Ctrls.Items[i]).text:=reader.CurrentRecord.Items[i];
end;

{File Open and Save Dialog combined}
procedure OpenSaveFile(Open:Boolean=true);
var
i,j:integer;
begin
  with NewOpenSaveDialog('','',[])^ do
  Try
  Filter:='dBase files|*.dbf';
  OpenDialog:=Open;
  DefExtension:='dbf';
  if execute then
      begin
        Grid.Clear;
        {Clear doesn't clear the columns???}
        for i:=Grid.LVColCount-1 downto 0 do
          Grid.LVColDelete(i);
        {Open the dBase file}
        Reader.Open(filename);
        Form.Statustext[2]:=Pchar('dBase Type: '+Int2Hex(Reader.dBaseType,2));
        {Now set the grid to number of items in the database}
        Grid.PerForm(LVM_SETITEMCOUNT,Reader.Recordcount,0);

        {Fill the Grid, ensure proper alignment}
        for i:=0 to Reader.FieldCount-1 do
          with pDbField(Reader.Fields.Items[i])^ do
            if FieldType in ['C','M'] then Grid.LVColAdd(Fieldname,taLeft, 75)
                               else Grid.LVColAdd(Fieldname,taRight,75);

        {Remove any old controls, if present}
        for i:=Labels.Count-1 downto 0 do
          pControl(Labels.Items[i]).Free;
        Labels.Clear;

        for i:=Ctrls.Count-1 downto 0 do
          pControl(Ctrls.Items[i]).Free;
        Ctrls.Clear;

        {Create Controls}
        for i:=0 to Reader.FieldCount-1 do
          with pDbField(Reader.Fields.Items[i])^ do
            begin
            Labels.Add(NewLabel(Tabs.pages[1],FieldName).SetSize(100,20));
            with pControl(Labels.Items[i])^ do
            begin
              top:=i*20+10;
              Left:=10;
              Font.FontHeight:=11;
              Text:=Fieldname;
              Width:=Font.FontHeight*Length(Trim(Fieldname));
            end;
          end;

        for i:=0 to Reader.FieldCount-1 do
          with pDbField(Reader.Fields.Items[i])^ do
            begin
            Ctrls.Add(NewEditBox(Tabs.pages[1],[]).SetSize(200,20));
            with pControl(Ctrls.Items[i])^ do
            begin
              top:=i*20+5;
              Left:=120;
              Font.FontHeight:=11;
              Width:=300;
            end;
          end;
        {Read ALL Records into the grid.
         Note: For large files, you would want to buffer between the
         Grid and the actual table, because you only need the actual
         number of records that are displayed to fill the grid.
         You can use:
            Grid.LVCount, Grid.LVTopItem and Grid.ITemsperPage
         to achieve that, i.e:
        for j:=0 to min(Grid.LVperPage,reader.recordcount-1) do...}
        {For Each record do}
        //for j:=0 to Grid.LVperPage do
        for j:=0 to reader.recordcount-1 do
        begin
          Grid.LVAdd( '', 0, [], 0, 0, 0 );
          {For Each field do}
          for i := 0 to  reader.CurrentRecord.count-1 do
              Grid.LVItems[ j,i] := reader.CurrentRecord.Items[i];
            if j=Grid.LVperPage then
            begin
              Grid.Update;
              Applet.processMessages;
            end;
            Reader.Next;
        end;
        Reader.First;
        UpdateControls;

        {Hm, with KOL, the only way to set the selected item from code?}
        Grid.LVSetItem(Reader.Cursor,0,reader.CurrentRecord.Items[0],I_SKIP,[lvIsSelect],I_SKIP,I_SKIP,0);
        {Makes shure about the visibility}
        Grid.Perform(LVM_ENSUREVISIBLE,Reader.Cursor,0);
      end;
  finally
    free;
  end;

  {This at present the ONLY way I can get the controls on page 2
   to appear immediately. Updat.invalidate and repaint won't work,
   also, do not combine the calls, because it will get optimized
   by the compiler and it will still not work!
   HELP!}
  with form^ do
    width:=width-1;
  with form^ do
    width:=(width+1);
end;


procedure DoToolBarClick(Dummy:pointer;sender:pobj);
var i:integer;
begin
    case ToolBar.CurIndex of
    0:OpenSaveFile;
    1:Reader.First;
    2:Reader.Prior;
    3:Reader.next;
    4:Reader.Last;
    5:begin
        MemoForm:=NewForm(Applet,'Memo '+Int2str(Reader.Cursor)).SetSize(300,200);
        Memo:=NewRichEdit(MemoForm,[]).SetAlign(caClient);
        {find a memo}
        for i:=0 to Reader.fields.count-1 do
         if pDbField(Reader.fields.Items[i]).FieldType='M' then
           begin
           Memo.Text:=Reader.MemoField[i];
           break;
           end;
        MemoForm.ShowModal;
        MemoForm.Free;
      end;
  end;
  {Shows Current Recordnumber}
  Form.StatusText[0]:=Pchar('Record: '+Int2str(Reader.Cursor));
  {Shows if a record is valid or deleted}
  with form^ do if Reader.Deleted=true then StatusText[1]:='Deleted' else StatusText[1]:='Valid';
  {Hm, with KOL, the only way to set the selected item from code?}
  Grid.ItemSelected[Reader.Cursor];
  Grid.LVSetItem(Reader.Cursor,0,reader.CurrentRecord.Items[0],I_SKIP,[lvIsSelect],I_SKIP,I_SKIP,0);
  {Makes shure about the visibility}
  Grid.Perform(LVM_ENSUREVISIBLE,Reader.Cursor,0);
  UpdateControls;
end;

procedure TestdBase;
begin
  {Setup Application}
  Applet:=NewApplet('TestdBase');

  {Setup Mainform}
  Form:=NewForm(Applet,'dBase reader');
  Form.width:=640;
  Form.Height:=480;
  Form.StatusText[0]:='';

  {Setup a Toolbar, use a panel to hold it,
   See KOL documentation why}
  Panel:=NewPanel(Form,esNone).setalign(caTop);
  Toolbar:=NewToolbar( Panel, caTop, [], DWORD(0),
          [ 'Open','First', 'Prior','Next','Last','Memo' ],
          [] ).SetAlign(caTop);

  {Setup Onclick event for the toolbar}
  Toolbar.Onclick:=TOnEvent(Makemethod(nil,@DoToolbarClick));

  {Size the Panel to the toolbar}
  Panel.Height:=Toolbar.height*2;


  {Setup a TabControl}
  Tabs:=NewTabcontrol(Form,['Grid','Record','Structure'],[],nil,0).SetAlign(caClient);

  {This gives us a better displayfont than the default}
  Tabs.Font.FontHeight:=11;

  {Setup a Grid}
  Grid := NewListView( Tabs.Pages[0],lvsDetail, [lvoCheckBoxes,lvoHeaderDragDrop,lvoTrackSelect,lvoRowSelect,lvoGridLines],NewImageList( Form )
                       , nil, nil ).SetAlign(caClient);

  {Create edit controls holder lists}
  Labels:=NewList;
  Ctrls:=NewList;

  {Create a dBase Reader object}
  Reader:=NewdBase;

  {Run us}
  Run(Applet);

  {Free the reader: It has no parent}
  Reader.free;
  Labels.free;
  Ctrls.free;
end;


begin
  TestdBase;
end.

