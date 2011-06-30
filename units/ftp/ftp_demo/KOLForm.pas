{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLFtp, KOLMHXP {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckObjs, mckFTP, commctrl,  MCKMHXP {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KP: TKOLProject;
    KF: TKOLForm;
    KA: TKOLApplet;
    PL: TKOLPopupMenu;
    P1: TKOLPanel;
    S2: TKOLSplitter;
    P2: TKOLPanel;
    LV: TKOLListView;
    S1: TKOLSplitter;
    RV: TKOLListView;
    TV: TKOLListView;
    PT: TKOLPopupMenu;
    TM: TKOLTimer;
    FC: TKOLFTP;
    P3: TKOLPanel;
    P5: TKOLPanel;
    DB: TKOLComboBox;
    TB: TKOLToolbar;
    TC: TKOLTabControl;
    T0: TKOLPanel;
    TI: TKOLTrayIcon;
    PM: TKOLPopupMenu;
    XP: TKOLMHXP;
    procedure LocalUpdateListing;
    procedure Connect;
    procedure FTPGet;
    procedure FTPPut;
    procedure FTPDel;
    procedure FTPMDir;
    procedure KFFormCreate(Sender: PObj);
    procedure FTPLogger(Sender: PObj; Msg: string);
    procedure FTPConnect(Sender: PObj);
    procedure FTPLogin(Sender: PObj);
    procedure FTPExist(Sender: PObj; Name: string; Size: integer; var append, cancel: boolean);
    procedure FTPData(Sender: PObj);
    procedure FTPError(Sender: PObj);
    procedure FTPProgress(Sender: PObj);
    procedure FTPFileDone(Sender: PObj);
    procedure FTPClose(Sender: PObj);
    procedure SetToolBar(s: string; m: boolean);
    procedure TBClick(Sender: PObj);
    procedure LVMouseDblClk(Sender: PControl; var Mouse: TMouseEventData);
    procedure RVMouseDblClk(Sender: PControl; var Mouse: TMouseEventData);
    procedure WriteIni(w: boolean);
    procedure KFClose(Sender: PObj; var Accept: Boolean);
    procedure KFResize(Sender: PObj);
    procedure TBMouseDblClk(Sender: PControl; var Mouse: TMouseEventData);
    procedure PLN1Menu(Sender: PMenu; Item: Integer);
    procedure PLN2Menu(Sender: PMenu; Item: Integer);
    procedure PLN4Menu(Sender: PMenu; Item: Integer);
    procedure PTN5Menu(Sender: PMenu; Item: Integer);
    procedure PTN6Menu(Sender: PMenu; Item: Integer);
    procedure PTN8Menu(Sender: PMenu; Item: Integer);
    procedure TMTimer(Sender: PObj);
    procedure PLN9Menu(Sender: PMenu; Item: Integer);
    procedure DBChange(Sender: PObj);
    procedure FCFTPStatus(Sender: PObj);
    procedure StartTasks;
    procedure TCSelChange(Sender: PObj);
    procedure RestStat;
    function KFMessage(var Msg: tagMSG; var Rslt: Integer): Boolean;
    procedure TIMouse(Sender: TObject; Message: Word);
    procedure PMN10Menu(Sender: PMenu; Item: Integer);
    procedure PMN12Menu(Sender: PMenu; Item: Integer);
  private
    fLPath: string;
    MVSort: PControl;
    fSaveB: string;
        SS: array[0..4] of string;
    function  GetSS(Idx: integer): string;
    procedure SetSS(Idx: integer; Value: string);
    { Private declarations }
  public
    { Public declarations }
    FN: string;
    SZ: integer;
    property StS[Idx: integer]: string read GetSS write SetSS;
  end;
var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses UWrd, UStr, Select, Logger, AskBox, DirBox, TaskN, TaskEd, KOLRoundWindow;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}

const faDirectory = $00000010;

function GetFileTypeDescription(const Name: string; UseAttr: Boolean): string;
var
  Info: TSHFileInfo;
  Flags: Cardinal;
begin
  FillChar(Info, SizeOf(Info), 0);
  Flags := SHGFI_TYPENAME;
  if UseAttr then Flags := Flags or SHGFI_USEFILEATTRIBUTES;
  SHGetFileInfo(PChar(Name), 0, Info, SizeOf(Info), Flags);
  if Info.hIcon <> 0 then begin
     DestroyIcon(Info.hIcon);
  end;
  Result := Info.szTypeName;
end;

function SortFunc(Item1,Item2,Column:integer):integer stdCall;
var
  Info:TLVFindInfo;
  ListView:pControl;
begin
{  applet.ProcessMessage;}
  ListView := Form1.MVSort;
  info.lParam:=Item1;
  info.flags:=LVFI_PARAM;
  Item1:=ListView.Perform(LVM_FINDITEM, -1, integer(@Info));
  info.lParam:=Item2;
  info.flags:=LVFI_PARAM;
  Item2:=ListView.Perform(LVM_FINDITEM, -1, integer(@Info));
  with ListView^ do begin
    result:=AnsiCompareStr(lVitems[Item1,0],lvitems[Item2,0]);
    if (lVitems[Item1, 1]  = '') and
       (lVitems[Item2, 1] <> '') then result := -1;
    if (lVitems[Item1, 1] <> '') and
       (lVitems[Item2, 1]  = '') then result :=  1;
  end;
end;

procedure TForm1.LocalUpdateListing;
var
  F: TWin32FindData;
  Enum: Hwnd;
  R: Bool;
  FileName: string;
  FileSize: Integer;
  Magic:integer;
begin
  Pointer(Enum) := nil;
  with LV^ do
  try
    BeginUpdate;
    Clear;
    perform(WM_SETREDRAW,0,0);
    Enum := FindFirstFile(PChar(fLPath + '*.*'), F);
    R := Pointer(Enum) <> nil;
    Magic:=0;
    while R do
    begin
      FileName := F.cFileName;
      if filename <> '.' then
      begin
        LvAdd(Filename, 0, [], 0, 0, Magic);
        LvItems[LvCount - 1, 0] := Filename;
        FileSize := (F.nFileSizeHigh shl 32) or (F.nFileSizeLow);
        if F.dwFileAttributes and faDirectory = faDirectory then
        begin
          LvItems[lvcount - 1, 1] := '';
          LvItems[LvCount - 1, 2] := 'File Folder';
          LvItemImageIndex[lvcount - 1] := 0;
        end
        else
        begin
          LvItems[lvcount - 1, 1] := int2str(FileSize);
          LvItems[LvCount - 1, 2] := GetFileTypeDescription(fLPath + FileName, True);
        end;
       end;
       inc(Magic);
       R := FindNextFile(Enum, F);
    end;
  finally
    Findclose(Enum);
    MVSort := LV;
    perform(LVM_SORTITEMS,1,longint(@Sortfunc));
    perform(WM_SETREDRAW,1,0);
    endUpdate;
  end;
    Form.Update;
end;

procedure TForm1.FTPLogger;
var i: integer;
    s: string;
begin
   if FC.ftpStatus <> ftpReady then SetToolBar('010000100', True);
   Form3.LM.Add(Msg + #13#10);
   Form3.LM.SelStart := Form3.LM.TextSize;
   Form3.LM.Perform( EM_LINESCROLL, 0, 32767 );
   if copy(Msg, 1, 3) = '250' then begin
      s := TV.LVItems[0, 0];
      if (pos(s, Msg) > 0) or
         (pos('RMD', Msg) > 0) or
         (pos('DELE', Msg) > 0)then begin
         if TV.LVItems[0, 2] = 'processing delete' then begin
            TV.LVDelete(0);
            i := RV.LVIndexOf(s);
            if i > -1 then begin
               RV.LVDelete(i);
            end;
         end;
      end;
   end;
end;

procedure TForm1.FTPConnect;
begin
   StS[0] := '  Connected';
   applet.Caption     := '  Connected';
   TB.TBButtonEnabled[100] := False;
end;

procedure TForm1.FTPLogin;
begin
   StS[0] := '  Reading folder';
   FC.List;
end;

procedure TForm1.FTPExist;
begin
   if TV.Count > 0 then exit;
{   NewForm4(Form4, Form1.Form);}
   Form4.Form.Left  := Form.Left +  40;
   Form4.Form.Top   := Form.Top  + 160;
   Form4.LE.Caption := ' File with name ' + JustFileName(Name) + ' already exists. What should we do ? ';
   Form4.KFResize(@self);
   Form4.Form.ShowModal;
   append := Form4.append;
   cancel := Form4.cancel;
{   Form4.Form.Close;}
end;

procedure TForm1.FTPData;
var i: integer;
    n: integer;
    s: string;
    r: string;
    f: string;
begin
   applet.ProcessMessages;
   RV.BeginUpdate;
   for i := 0 to FC.Listing.Count - 1 do begin
      s := FC.Listing.Items[i];
      if Form3.Form.Visible then begin
         Form3.LM.Add(s + #13#10);
         Form3.LM.Perform( EM_LINESCROLL, 0, 32767 );
      end;   
      if words(s, ' ') < 9 then continue;
      r := s;
      for n := 1 to 8 do r := wordd(r, ' ', 1);
      f := Trim(wordn(r, #13, 1));
      if (f <> '') and (f <> '..') then begin
         n := RV.LVIndexOf(f);
         if n = -1 then begin
            RV.LVAdd(f, 0, [], 0, 0, i);
            n := RV.lvcount - 1;
         end else begin
            RV.LVItemData[n] := i;
         end;
         RV.LvItems[n, 1] := wordn(s, ' ', 5);
         if s[1] = 'd' then begin
            RV.LvItems[n, 1] := '';
            RV.LvItems[n, 2] := 'File Folder';
         end else begin
            RV.LVItems[n, 2] := GetFileTypeDescription(RV.lvItems[n, 0], True);
         end;
      end;
   end;
   MVSort := RV;
{   RV.perform(LVM_SORTITEMS, 1, longint(@Sortfunc));}
{   RV.perform(WM_SETREDRAW, 1, 0);}
   RV.EndUpdate;
end;

procedure TForm1.FTPError;
begin
   beep(500, 500);
   if FC.ftpStatus = ftpNone then StS[0] := '  Disconnected'
                             else StS[0] := '  Error';
   applet.Caption := StS[0];
end;

procedure TForm1.FTPProgress;
var l: integer;
    c: integer;
    n: integer;
{    p: integer;}
    s: string;
begin
   SZ := Form.StatusPanelRightX[1] - Form.StatusPanelRightX[0] - 10;
   l := SZ;
   c := Form.Canvas.TextWidth('|');
   if FC.ftpStatus = KOLFtp.ftpGet then begin
      n :=   l * FC.TotalRece div FC.fFileSize;
{      p := 100 * FC.TotalRece div FC.fFileSize;}
      s := int2str(FC.TotalRece);
      if FC.TotalRece = 0 then begin
         s := s + ' ';
      end;
   end else begin
      n :=   l * FC.TotalSent div FC.fFileSize;
{      p := 100 * FC.TotalSent div FC.fFileSize;}
      s := int2str(FC.TotalSent);
   end;
   n := n div c;
   StS[1] := PChar(replicate('|', n));
   StS[2] := PChar('  ' + s + '/' + int2str(FC.fFileSize));
{   StS[4] := int2str(p) + ' %';}
end;

procedure LVSortAll(LV: PControl);
begin
   Form1.MVSort := LV;
   LV.BeginUpdate;
   LV.perform(LVM_SORTITEMS,1,longint(@Sortfunc));
   LV.perform(WM_SETREDRAW,1,0);
   LV.EndUpdate;
end;

procedure TForm1.FTPFileDone;
var s: string;
    n: integer;
begin
   SetToolBar('011111111', True);
   StS[0] := '  Ready';
   StS[1] := '';
   StS[2] := '';
   applet.Caption     := '  Ready';
   if FC.MovedFile <> '' then begin
      s := JustFileName(FC.MovedFile);
      if TV.Count > 0 then begin
         if FC.ftpStatus = ftpReady then begin
            TV.LVDelete(TV.LVIndexOf(s));
         end else
         if FC.ftpStatus = ftpPutEr then begin
            TV.LVItems[TV.LVIndexOf(s), 2] := 'aborted      upload';
         end else
         if FC.ftpStatus = ftpGetEr then begin
            TV.LVItems[TV.LVIndexOf(s), 2] := 'aborted      download';
         end;
      end;
   end;
   if FC.oldStatus = KOLFtp.ftpList then begin
      RV.perform(LVM_SORTITEMS, 1, longint(@Sortfunc));
   end else
   if FC.oldStatus = KOLFtp.ftpGet then begin
      LocalUpdateListing;
   end else
   if (FC.MovedFile <> '') then
   if (FC.oldStatus = KOLFtp.ftpPut) then begin
      if FC.ftpStatus = ftpReady then begin
         n := RV.LVIndexOf(s);
         if n = -1 then begin
            RV.LVAdd(s, 0, [], 0, 0, 0);
            RV.LVItems[RV.LVCount - 1, 1] := int2str(FC.MovedSize);
            for n := 0 to RV.Count - 1 do RV.LVItemData[n] := n;
            LVSortAll(RV);
         end else begin
            RV.LVItems[n             , 1] := int2str(FC.MovedSize);
         end;
      end;
   end;
end;

procedure TForm1.FTPClose;
var s: string;
begin
   StS[0] := '  Disconnected';
   StS[1] := '';
   StS[2] := '';
   StS[3] := '';
   if applet <> nil then applet.Caption := '  Disconnected';
   RV.Clear;
   SetToolBar('100010010', True);
   if TV.Count > 0 then begin
      s := TV.LVItems[0, 2];
      TV.LVItems[0, 2] := 'waiting for ' + wordd(s, ' ', 1);
   end;
end;

procedure TForm1.KFFormCreate(Sender: PObj);
var d,
    n: dword;
    i: integer;
    c: string;
begin
   NewRoundForm(Form, 15);
   TI.Active := False;
   {$I-}
   MkDir('Data');
   {$I+}
   if ioresult = 0 then;
   FN := JustPathName(ParamStr(0)) + '\' + JustName(ParamStr(0)) + '.ini';
   WriteIni(False);

   d := GetLogicalDrives;
   n := 1;
   for i := 1 to 32 do begin
      if (d AND n) = n then begin
         c := Char(64 + i) + ':';
         DB.Add(c);
      end;
      n := (n shl 1);
   end;

   if fLPath <> '' then begin
      for i := 0 to DB.Count - 1 do
         if DB.Items[i][1] = fLPath[1] then DB.CurIndex := i;
   end;

   LV.LVColAdd('Filename', taLeft, 140);
   LV.LvColAdd('FileSize', taRight, 70);
   LV.LvColAdd('Filetype', taLeft, 140);
   RV.LVColAdd('FileName', taLeft, 140);
   RV.LvColAdd('FileSize', taRight, 70);
   RV.LvColAdd('Filetype', taLeft, 140);
   TV.LvColAdd('Filename', taLeft, 140);
   TV.LvColAdd('Filesize', taRight, 70);
   TV.LvColAdd('Filestatus', taLeft, 140);
   TV.LvColAdd('FilePath', taLeft, 390);
   LocalUpdateListing;
   StS[0] := '  Disconnected';
   applet.Caption     := '  Disconnected';
   SetToolBar('100010010', True);
end;

procedure TForm1.Connect;
begin
   Form2.Form.Show;
end;

procedure TForm1.FTPGet;
var s: string;
begin
   if Form.ActiveControl = RV then begin
      s := RV.LVItems[RV.LVCurItem, 0];
      s := wordn(s, #13, 1);
      FC.SavePath := fLPath;
      FC.Get(s);
   end;
end;

procedure TForm1.FTPPut;
var s: string;
begin
   if Form.ActiveControl = LV then begin
      s := LV.LVItems[LV.LVCurItem, 0];
      FC.Put(fLPath + s);
   end;
end;

procedure TForm1.FTPDel;
var s: string;
    n: integer;
begin
   if Form.ActiveControl = RV then begin
      for n := 0 to RV.Count - 1 do begin
         if lvisSelect in RV.LVItemState[n] then begin
            if RV.LVItems[n, 1] <> '.' then begin
               s := RV.LVItems[n, 0];
               TV.LVAdd(s, 0, [], 0, 0, 0);
               TV.LVItems[TV.LVCount - 1, 1] := RV.LVItems[n, 1];
               TV.LVItems[TV.LVCount - 1, 2] := 'waiting for delete';
            end;
         end;
      end;
   end else
   if Form.ActiveControl = LV then begin
      for n := 0 to LV.Count - 1 do begin
         if lvisSelect in LV.LVItemState[n] then begin
            if LV.LVItems[n, 0][1] <> '.' then begin
               s := fLPath + LV.LVItems[n, 0];
               if LV.LVItems[n, 1] <> '' then begin
                  DeleteFile2Recycle(s);
               end else begin
                  {$I-}
                  RMDir(s);
                  if ioresult <> 0 then;
               end;
            end;
         end;
      end;
      LocalUpdateListing;
   end;
end;

procedure TForm1.FTPMDir;
begin
   if form5 <> nil then begin
      Form5.EB.Text := '';
      Form5.Form.ShowModal;
      if Form5.EB.Text <> '' then begin
         if Form.ActiveControl = LV then begin
            mkDir(fLPath + Form5.EB.Text);
            LocalUpdateListing;
         end else
         if Form.ActiveControl = RV then begin
            FC.MDir(Form5.EB.Text);
            StS[0] := '  Reading folder';
            FC.List;
         end;
      end;
   end;
end;

procedure TForm1.SetToolBar;
var i: integer;
begin
   if m then fSaveB := s;
   for i := 1 to length(s) do TB.TBButtonEnabled[99 + i] := s[i] = '1';
end;

procedure TForm1.TBClick(Sender: PObj);
var i: integer;
begin
if TC.CurIndex = 0 then begin
   case PControl(Sender).CurItem of
   100: Connect;
   101: FC.Close;
   102: FTPGet;
   103: FTPPut;
   104: PLN9Menu(@self, 4);
   105: begin RV.Clear; FC.Cdup; end;
   106: FC.Abort;
   107: FTPMDir;
   108: begin StS[0] := '  Reading folder'; FC.List; end;
   109: Form7.Form.Show;
   end;
end else begin
   i := Form7.CB.IndexOf(TC.TC_Items[TC.CurIndex]);
   if i < 0 then exit;
   Form6 := pointer(Form7.CB.ItemData[i]);
   case PControl(Sender).CurItem of
   100: begin Form6.Abor := False; Form6.Connect;  end;
   101: begin Form6.Abor := True;  Form6.FC.Close; end;
   109: Form7.Form.Show;
   end;
end;
end;

procedure TForm1.LVMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var s: string;
begin
   s := LV.LVItems[LV.LVCurItem, 0];
   if LV.LVItems[LV.LVCurItem, 1] = '' then begin
      if s <> '..' then fLPath := fLPath + s + '\'
                   else fLPath := wordd(fLPath, '\', words(fLPath, '\'));
      LocalUpdateListing;
   end;
end;

procedure TForm1.RVMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var s: string;
begin
   s := RV.LVItems[RV.LVCurItem, 0];
   if RV.LVItems[RV.LVCurItem, 1] = '' then begin
      s := wordn(s, #13, 1);
      RV.Clear;
      FC.cwd(s);
   end;
end;

procedure TForm1.WriteIni;
var FI: PIniFile;
  Path: array[0..255] of char;
begin
   FI := OpenIniFile(FN);
   if w then FI.Mode := ifmWrite;
   FI.Section  := 'Form1';
   Form.Left   := FI.ValueInteger('Left',   Form.Left);
   Form.Top    := FI.ValueInteger('Top',    Form.Top);
   Form.Width  := FI.ValueInteger('Width',  Form.Width);
   Form.Height := FI.ValueInteger('Height', Form.Height) -
                  GetSystemMetrics(SM_CYCAPTION) -
                  GetSystemMetrics(SM_CYSIZEFRAME) + 1;
   P1.Height   := FI.ValueInteger('P1Bot',  P1.Height);
   fLPath      := FI.ValueString ('Path',   fLPath);
   if fLPath = '' then begin
      GetCurrentDirectory(255, @Path);
      fLPath := Path;
      fLPath := fLPath + '\';
   end;
   FI.Free;
end;

procedure TForm1.KFClose(Sender: PObj; var Accept: Boolean);
begin
   WriteIni(True);
end;

procedure TForm1.KFResize(Sender: PObj);
begin
   LV.Width := P1.ClientWidth div 2 - S1.Width div 2 - P1.Border * 2;
   TV.Width := P2.Width - P2.Border * 2;
end;

procedure TForm1.TBMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
begin
   Form3.Form.Show;
end;

procedure TForm1.PLN1Menu(Sender: PMenu; Item: Integer);
var WV: PControl;
     i: integer;
begin
   WV := Form.ActiveControl;
   WV.LVSelectAll;
   for i := 0 to WV.Count - 1 do begin
      if WV.LVItems[i, 1] = '' then begin
         WV.LVItemState[i] := [lvisBlend];
      end;
   end;
end;

procedure TForm1.PLN2Menu(Sender: PMenu; Item: Integer);
begin
   if Form.ActiveControl = LV then LV.LVItemState[-1] := [lvisBlend] else
   if Form.ActiveControl = RV then RV.LVItemState[-1] := [lvisBlend];
   { lvisFocus, lvisSelect, lvisBlend, lvisHighlight}
end;

procedure TForm1.PLN4Menu(Sender: PMenu; Item: Integer);
var i: integer;
    s: string;
    l: TKOLListView;
begin
   if Form.ActiveControl = LV then l := LV else l := RV;
   for i := 0 to l.Count - 1 do begin
      if lvisSelect in l.LVItemState[i] then begin
        s := l.LVItems[i, 0];
        if l.LVItems[i, 1] <> '' then begin
           if TV.LVIndexOf(s) = -1 then begin
              TV.LvAdd(s, 0, [], 0, 0, 0);
              TV.LvItems[TV.Lvcount - 1, 1] := l.LVItems[i, 1];
              if l = LV then TV.LvItems[TV.LvCount - 1, 2]:= 'waiting for upload' else
              if l = RV then TV.LvItems[TV.LvCount - 1, 2]:= 'waiting for download';
              TV.LvItems[TV.Lvcount - 1, 3] := fLPath;
           end;
        end;
      end;
   end;
end;

procedure TForm1.PTN5Menu(Sender: PMenu; Item: Integer);
begin
   TV.LVSelectAll;
end;

procedure TForm1.PTN6Menu(Sender: PMenu; Item: Integer);
begin
   TV.LVItemState[-1] := [lvisBlend];
end;

procedure TForm1.PTN8Menu(Sender: PMenu; Item: Integer);
var i: integer;
begin
   for i := TV.Count - 1 downto 0 do begin
      if lvisSelect in TV.LVItemState[i] then begin
         if (wordn(TV.LVItems[i, 2], ' ', 1) = 'waiting') or
            (wordn(TV.LVItems[i, 2], ' ', 1) = 'aborted') or
            (FC.ftpStatus = ftpNone) then begin
            TV.LVDelete(i);
         end;
      end;
   end;
end;

procedure TForm1.TMTimer(Sender: PObj);
var s: string;
    i: integer;
begin
   if FC.ftpStatus = ftpReady then begin
      if TV.Count > 0 then begin
         s := TV.LVItems[0, 2];
         if wordn(s, ' ', 3)  = 'upload'   then begin
            TV.LVItems[0, 2] := 'processing upload';
            TV.Update;
            FC.Put(TV.LVItems[0, 3] + TV.LVItems[0, 0]);
         end else
         if wordn(s, ' ', 3)  = 'download' then begin
            TV.LVItems[0, 2] := 'processing download';
            FC.SavePath := TV.LVItems[0, 3];
            FC.Get(TV.LVItems[0, 0]);
         end else
         if wordn(s, ' ', 3) = 'delete'   then begin
            TV.LVItems[0, 2] := 'processing delete';
            i := RV.LVIndexOf(TV.LVItems[0, 0]);
            if RV.LVItems[i, 1] <> '' then begin
               FC.Delete(TV.LVItems[0, 0]);
            end else begin
               FC.RMD(TV.LVItems[0, 0]);
            end;
         end;
      end;
   end;
{   if IsInet then} StartTasks;
end;

procedure TForm1.PLN9Menu(Sender: PMenu; Item: Integer);
var LL: PControl;
     i: integer;
     s: string;
begin
   LL := Form.ActiveControl;
   for i := 0 to LL.Count - 1 do begin
      if lvisSelect in LL.LVItemState[i] then begin
         if LL = LV then begin
            s := fLPath + LV.LVItems[i, 0];
            DeleteFile2Recycle(s);
         end else
         if LL = RV then begin
            s := RV.LVItems[i, 0];
            if RV.LVItems[i, 1] <> '' then begin
               TV.LVAdd(s, 0, [], 0, 0, 0);
               TV.LVItems[TV.LVCount - 1, 1] := RV.LVItems[i, 1];
               TV.LVItems[TV.LVCount - 1, 2] := 'waiting for delete';
            end;
         end;
      end;
   end;
   if LL = LV then LocalUpdateListing;
end;

procedure TForm1.DBChange(Sender: PObj);
var b: byte;
begin
   b := ord(DB.Text[1]) - 64;
   Getdir(b, fLPath);
   if fLPath[Length(fLPath)] <> '\' then fLPath := fLPath + '\';
   LocalUpdateListing;
end;

procedure TForm1.FCFTPStatus(Sender: PObj);
var s: string;
begin
   if FC.ftpStatus = ftpReady then SetToolBar('011111111', True);
   s := '';
   if FC.ftpStatus = KOLftp.ftpReady then s := '  Ready' else
   if FC.ftpStatus = KOLftp.ftpGet   then s := '  Downloading' else
   if FC.ftpStatus = KOLftp.ftpPut   then s := '  Uploading' else
   if FC.ftpStatus = KOLftp.ftpNone  then s := '  Disconnected' else
   if FC.ftpStatus = KOLftp.ftpError then s := '  Error' else
   if FC.ftpStatus = KOLftp.ftpList  then s := '  Reading folder';
   if (s <> '') and
      (StS[0] <> s) then begin
       StS[0] := PChar(s);
       if applet <> nil then applet.Caption := s;
   end;
end;

procedure TForm1.StartTasks;
var i,
    n: integer;
    f: boolean;
   FI: PIniFile;
begin
   FI := OpenIniFile(FN);
   for i := 0 to Form7.CB.Count - 1 do begin
      f := false;
      n := 0;
      while n < TC.Count do begin
         if TC.TC_Items[n] = Form7.CB.Items[i] then begin
            f := true;
            if Form7.Change then begin
               FI.Section := TC.TC_Items[n];
               if FI.ValueBoolean('Acti', True) then begin
                  Form6 := Pointer(Form7.CB.ItemData[i]);
                  Form6.Link := FI.ValueString('Link', '');
                  Form6.RemP := FI.ValueString('RemP', '');
                  Form6.LocP := FI.ValueString('LocP', '');
                  Form6.Mask := FI.ValueString('Mask', '');
                  Form6.Excl := Fi.ValueString('Excl', '');
                  Form6.Jupl := FI.ValueBoolean('Jupl', True);
                  Form6.Jdnl := FI.ValueBoolean('Jdnl', True);
                  Form6.Conn := FI.ValueBoolean('Wait', True);
                  Form6.LocalUpdateListing;
               end else begin
                  TC.TC_Delete(n);
                  TC.CurIndex := TC.CurIndex - 1;
                  continue;
               end;
            end;
         end;
         inc(n);
      end;
      if not f then begin
         FI.Section := Form7.CB.Items[i];
         if FI.ValueBoolean('Acti', True) then begin
            TC.TC_Insert(TC.Count, Form7.CB.Items[i], 0);
            TC.Invalidate;
            NewForm6(Form6, TC.Pages[TC.Count - 1]);
            Form6.Numb := TC.Count - 1;
            Form6.Entr := Form7.CB.Items[i];
            Form6.Link := FI.ValueString ('Link', '');
            Form6.RemP := FI.ValueString ('RemP', '');
            Form6.LocP := FI.ValueString ('LocP', '');
            Form6.Mask := FI.ValueString ('Mask', '');
            Form6.Excl := FI.ValueString ('Excl', '');
            Form6.Jupl := FI.ValueBoolean('Jupl', True);
            Form6.Jdnl := FI.ValueBoolean('Jdnl', True);
            Form6.Conn := FI.ValueBoolean('Wait', True);
            Form6.LocalUpdateListing;
            Form7.CB.ItemData[i] := Cardinal(Form6);
            TC.ItemData[TC.Count - 1] := Cardinal(Form6);
            TC.CurIndex := TC.Count - 1;
         end;
      end;
   end;
   FI.Free;
   Form7.Change := False;
end;

function  TForm1.GetSS;
begin
   if Idx in [0..3] then Result := SS[Idx];
end;

procedure TForm1.SetSS;
begin
   if Idx in [0..3] then begin
      if SS[Idx] <> Value then begin
         SS[Idx] := Value;
      end;
      if TC.CurIndex = 0 then begin
         if Idx = 4 then begin
            applet.Caption := Value;
         end;   
         if Form.StatusText[Idx] <> Value then begin
            Form.StatusText[Idx] := PChar(Value);
         end;
      end;
   end;
end;

procedure TForm1.RestStat;
begin
   Form.StatusText[0] := PChar(SS[0]);
   Form.StatusText[1] := PChar(SS[1]);
   Form.StatusText[2] := PChar(SS[2]);
   Form.StatusText[3] := PChar(SS[3]);
end;

procedure TForm1.TCSelChange(Sender: PObj);
var i: integer;
begin
   beep(30,30);
   if TC.CurIndex = 0 then begin
      SetToolBar(fSaveB, False);
      RestStat;
   end                else begin
      SetToolBar('000000000', False);
      for i := 0 to Form7.CB.Count - 1 do begin
         if TC.TC_Items[TC.CurIndex] = Form7.CB.Items[i] then begin
            Form6 := pointer(Form7.CB.ItemData[i]);
            Form6.KFShow(@self);
         end;
      end;
   end;
end;

function TForm1.KFMessage(var Msg: tagMSG; var Rslt: Integer): Boolean;
begin
   Result := False;
   if (Msg.message = WM_SYSCOMMAND) and
      (Msg.wParam = SC_MINIMIZE) then begin
      TI.Active := True;
      Applet.Visible := False;
      Form.Visible := False;
      Result := True;
   end else
   if (Msg.message = WM_SYSCOMMAND) and
      (Msg.wParam = SC_RESTORE) then begin
      TI.Active := False;
      Applet.Visible := True;
      Form.Visible := True;
   end;
end;

procedure TForm1.TIMouse(Sender: TObject; Message: Word);
var P: TPoint;
begin
   if message = 512 then exit;
   if message = 513 then begin
      PostMessage(Form.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
   end;
   if message = 516 then begin
      GetCursorPos(P);
      PM.PopupEx(P.X,P.Y);
   end;
end;

procedure TForm1.PMN10Menu(Sender: PMenu; Item: Integer);
begin
   PostMessage(Form.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
end;

procedure TForm1.PMN12Menu(Sender: PMenu; Item: Integer);
begin
   Form.Close;
end;

end.
































