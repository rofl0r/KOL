{***************************************************************
 *
 * Program Name: KolPeEdit
 * Purpose  :Portable Executable File Control Demo
 *           Enum Windows Demo
 *           Small analytical tool for dependancies etc.
 * Author   :Thaddy de Koning
 *           The control itself is based on code by
 *           (Cr)Sergi /e!MiNENCE team
 * History  :Version 1.00m 31-10-2002
 * Remarks  :As usual in my case, no mck
 *           This is just a viewer, but the PE control
 *           allows write operations.
 *           This is risky, so i didn't implement it here.
 *           If you know what you're doing, you know where to look,
 *           if you don't, you don't :)
 ****************************************************************}

program kolpeedit;
{Created by KOL project Expert on:31-10-2002 11:59:09}

uses
 Windows,
 Messages,
 Kol,
 KOLPEEditor in 'KOLPEEditor.pas';

const
  App='Kol PE Viewer';

var
  PeEdit:pPEEditor;
  Refreshing:Boolean;
  TabControl,
  GroupBox3,
  GroupBox4,
  ListView1,
  ListView2,
  ListView3,
  ListView4,
  Listview5,
  ListBox1,
  tbpanel,
  Panel,
  Toolbar,
  Edit1,
  Edit2,
  Edit3:pControl;
type

  PMyEvents=^TMyEvents;
  TMyEvents=object(Tobj)
  public
  {Add your eventhandlers here, example:}
    function DoMessage(var Msg:Tmsg;var Rslt:integer):boolean;
    procedure ButtonLoadClick(Sender:pObj);
    procedure Listboxchange(sender:pObj);
    procedure ListViewSortclick(sender:pControl;Index:integer);
    procedure TabsClick(sender:pObj);
  end;


function TMyEvents.DoMessage(var Msg:TMsg;var Rslt:integer):Boolean;
begin
  Result:=false;
end;

function NewEvents:pMyEvents;
begin
  New(Result,Create);
end;

procedure TmyEvents.ButtonLoadClick(Sender:pObj);
var
    i:integer;
    Section:PSection;
    Directory:PDirectory;
    Dialog:pOpenSaveDialog;

begin
case toolbar.CurIndex of
0:
with PeEdit^ do
begin
  Dialog:=NewOpenSaveDialog('','',[]);
  Dialog.Filter:='Executable Files|*.exe;*.dll;*.ocx;*.cpl';
     if not Refreshing then begin
       if not Dialog.execute then exit;
          PEFilePath:=Dialog.FileName;
          Applet.caption:=App+' - ['+extractfilename(Dialog.Filename)+']';
       if PEFilePath='' then
       begin
         MsgOk(extractfilename(Dialog.filename)+' is not a valid PE file!');
         exit;
       end;
     end;
  Dialog.Free;
  Refreshing:=false;
  Edit1.Text:=Format('$%.8X', [EntryPoint]);
  Edit2.Text:=Format('$%.8X', [ImageBase]);
  Edit3.Text:=Format('$%.8X', [ImageSize]);

  with ListView1^ do
  begin
    BeginUpdate;
    Clear;

    For i:=0 to SectionList.Count-1 do
    begin
      LvAdd('',0,[],0,0,0);
      Section:=PSection(SectionList.Items[i]);
      LvItems[i,0]:=Section.o_name;
      LvItems[i,1]:=Format('$%.8X', [Section.o_rva]);
      LvItems[i,2]:=Format('$%.8X', [Section.o_virtual_size]);
      LvItems[i,3]:=Format('$%.8X', [Section.o_physical_offs]);
      LvItems[i,4]:=Format('$%.8X', [Section.o_physical_size]);
      LvItems[i,5]:=Format('$%.8X', [Section.o_flags]);
    end;
    EndUpdate;
  end;

  with ListView2^ do
  begin

    BeginUpdate;
    Clear;
    Directory:=PDirectory(DirectoryList.Items[0]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Export table';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[1]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Import table';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[2]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Resource';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[3]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Exception';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[4]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Security';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[5]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Relocations';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[6]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Debug datas';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[7]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Description';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[8]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Global PTR';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[9]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='TLS table';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[10]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Load config';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[11]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Bound import';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);

    Directory:=PDirectory(Directorylist.items[12]);
    LvAdd('',0,[],0,0,0);
    LvItems[lvcount-1,0]:='Import address table';
    LvItems[lvcount-1,1]:=Format('$%.8X', [Directory.RVA]);
    LvItems[lvcount-1,2]:=Format('$%.8X', [Directory.Size]);
    EndUpdate;
    Listbox1.clear;
    for i:=0 to ImportedList.count-1 do
      ListBox1.Add(PImportedLibrary(ImportedList.Items[i]).Name);
  end;

  with ListView4^ do
  begin
    beginupdate;
    clear;
    for i:=0 to ExportedList.count-2 do
    begin
      LVAdd('',0,[],0,0,0);
      LvItems[i,0]:=Format('$%.8X', [pExportedFunction(ExportedList.Items[i]).Ordinal]);
      lvItems[i,1]:=pExportedFunction(Exportedlist.Items[i]).Name;
    end;
    Endupdate;
    Listbox1.OnChange(@Self);
  end;
end;
1:msgOk('Not implemented');
end;

end;

var
  Events:pMyEvents;



procedure TMyEvents.ListboxChange(sender: pObj);
var
  I:integer;
  FuncList:pList;
  ImportedFunc:PImportedFunction;
begin
  with Listview3^, PEEdit^ do
  begin
    If Listbox1.curindex<0 then exit;
    beginupdate;
    clear;
    FuncList:=PImportedLibrary(ImportedList.Items[listbox1.curindex]).FunctionList;
    for i:=0 to FuncList.Count-1 do
    begin
      ImportedFunc:=PImportedFunction(FuncList.Items[i]);
      Lvadd('',0,[],0,0,0);
      lvItems[i,0]:=Format('$%.8X', [ImportedFunc.ordinal,4]);
      LvItems[i,1]:=ImportedFunc.Name;
    end;
    endupdate;
  end;
end;

{This is a callback function for the EnumWindows API call}
function ListWindows( hWindow: HWnd;wparam:integer): BOOL;stdcall;
  Var
    s: Array[0..255] of Char;
  Begin
    Result := True;

    With ListView5^ DO
    Begin
    Perform(WM_SETREDRAW,0,0);
    LvAdd('',0,[],0,0,0);
    {Displays handle}
    LvItems[ LvCount-1,0] := Format('$%.4X', [hWindow]);
    {Displays Instance}
    LvItems[ LvCount-1,1] := Format('$%.8X',
                             [GetWindowLong(hWindow, GWL_HINSTANCE)]);
    {Displays Task}
    LvItems[ LvCount-1,2] := Format('$%.4X',
                             [GetWindowTask(hWindow)]);
    {Displays Parent}
    LvItems[ LvCount-1,3] := Format('$%.4X',
                             [GetParent(hWindow)]);
    {Obtains and Displays Windows ClassName}
    GetClassName( HWindow, s, sizeof(s));
    s[80] := #0;
    LvItems[ LvCount-1,4] := s;

    {Obtains and Displays Window Caption, if any,
     If there's no caption contenttext is displayed}
    GetWindowText( HWindow, s, Sizeof(s));
      s[80] := #0;
      LvItems[ LvCount-1,5] := s;

    {Displays visibility}
    If IsWindowVisible( Hwindow ) Then
        LvItems[LvCount-1,6] := 'Yes'
    Else
        LvItems[LvCount-1,6] := 'No';

    {Displays Iconicity}
    If IsIconic( Hwindow ) Then
        LvItems[LvCount-1,7] := 'Yes'
    Else
        LvItems[LvCount-1,7] := 'No';
    Perform(WM_SETREDRAW,1,0);
  End;

End;

procedure TMyEvents.ListViewSortclick(sender: pControl; Index: integer);
begin
 sender.LVSortColumn(index);
end;

procedure TMyEvents.TabsClick(sender: pObj);
begin
{Update active window list}
if Tabcontrol.Curindex=4 then
  begin
    Listview5.beginupdate;
    EnumWindows( @ListWindows, Applet.handle);
    Listview5.endupdate;
  end;
end;

begin
  {var 'Applet' is already declared in KOL.pas}
  Applet:=NewForm(nil,app).SetSize(600,400).CenterOnParent;
  Applet.font.fontheight:=12;
  tbpanel:=Newpanel(Applet,esNone).SetAlign(caTop);
  Toolbar:=NewToolbar(tbpanel,caTop,[tboFlat],HBITMAP(-1),['',''],[7,8]).resizeparent;
  Toolbar.TBButtonEnabled[1]:=false;

  Panel:=NewPanel(Applet,esNone).SetAlign(caBottom);
  Panel.font.fontstyle:=[fsBold];
  NewLabel(Panel,'  PE Header Entry point:').AutoSize(True);
  Edit1:=NewEditbox(Panel,[]).Placeright.resizeparent;
  NewLabel(Panel,'  Image base:').Placeright.AutoSize(true);
  Edit2:=NewEditbox(Panel,[]).Placeright;
  NewLabel(Panel,'  Image size:').Placeright.AutoSize(True);
  Edit3:=NewEditbox(Panel,[]).Placeright;
  Events:=NewEvents;
  Toolbar.Onclick:=Events.ButtonLoadClick;
  PeEdit:=NewPeEditor;
  TabControl:=NewTabControl(Applet,['Sections','Directories','Imports','Exports', 'Active Windows'],[tcoFlat,tcoButtons],nil,0).SetAlign(caClient);
  TabControl.OnClick:=Events.tabsclick;
  ListView1:=NewListView(TabControl.pages[0],lvsDetail,[lvoGridlines,lvorowselect],nil,nil,nil).SetAlign(caClient);
  Listview1.OnColumnClick:=events.ListViewSortclick;
  with listview1^ do begin
    LVColAdd('Name',taLeft,Width div 6);
    LVColAdd('RVA',taLeft,Width div 6);
    LVColAdd('v Size',taLeft,Width div 6);
    LVColAdd('p Offset',taLeft,Width div 6);
    LVColAdd('p Size',taLeft,Width div 6);
    LvColAdd('ChaRect',taLeft,Width div 6);
  end;

  ListView2:=NewListView(TabControl.pages[1],lvsDetail,[lvoGridlines,lvorowselect],nil,nil,nil).SetAlign(caClient);
  Listview2.OnColumnClick:=events.ListViewSortclick;
  with listview2^ do begin
    LVColAdd('Directory',taLeft,Width div 3);
    LVColAdd('RVA',taLeft,Width div 3);
    LVColAdd('Size',taLeft,Width div 3);
  end;

  GroupBox3:=NewGroupBox(Tabcontrol.pages[2],'Libraries').SetAlign(caLeft);
  ListBox1:=NewListBox(GroupBox3,[]).SetAlign(caClient);
  GroupBox4:=NewGroupBox(Tabcontrol.Pages[2],'Functions').SetAlign(caClient);
  ListView3:=NewListView(GroupBox4,lvsDetail,[lvoGridlines,lvorowselect],nil,nil,nil).SetAlign(caClient);
  Listview3.OnColumnClick:=events.ListViewSortclick;
  with listview3^ do begin
    LVColAdd('Ordinal',taLeft,Width div 3);
    LVColAdd('Name',taLeft,Width - (width div 3));
  end;
  ListBox1.OnChange:=Events.Listboxchange;

  ListView4:=NewListView(TabControl.Pages[3],lvsDetail,[lvoGridlines,lvorowselect],nil,nil,nil).SetAlign(caClient);
  Listview4.OnColumnClick:=events.ListViewSortclick;
  with listview4^ do begin
    LVColAdd('Ordinal',taLeft,Width div 3);
    LVColAdd('Name',taLeft,Width - (width div 3));
  end;

  Applet.OnMessage:=Events.DoMessage;
 ListView5:=NewListView(Tabcontrol.pages[4],lvsdetail,[lvoGridLines,lvoRowSelect],nil,nil,nil).setalign(caClient);
 Listview1.OnColumnClick:=events.ListViewSortclick;
   With listview5^ do
    Begin
    LvColAdd('Handle',taRight,75);
    LvColAdd('Instance',taRight,75);
    LvColAdd('Task',taRight,75);
    LvColAdd('Parent',taright,75);
    lvColAdd('Class Name',taLeft,200);
    LvColAdd('Title',taLeft,200);
    LvColAdd('Visible',taLeft,75);
    LvColAdd('Iconic',taLeft,75);
  End;
  Listview5.OnColumnClick:=Events.ListViewSortclick;
  EnumWindows( @ListWindows, Applet.handle);
  Run(Applet);
  PeEdit.free;
  Events.free;
end.




