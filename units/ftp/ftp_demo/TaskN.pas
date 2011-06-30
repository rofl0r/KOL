{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit TaskN;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLFtp {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckObjs, mckFTP {$ENDIF}, commctrl;
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm6 = class; PForm6 = TForm6; {$ELSE OBJECTS} PForm6 = ^TForm6; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm6.inc}{$ELSE} TForm6 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm6 = class(TForm)
  {$ENDIF KOL_MCK}
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
    KF: TKOLFrame;
    procedure LocalUpdateListing;
    procedure MakeTask(VL: PControl; name, action, path: string);
    function  NeedUpload(name: string): boolean;
    procedure UpdateFile(f: string; s: boolean);
    procedure Connect;
    procedure FTPGet;
    procedure FTPPut;
    procedure FTPDel;
    procedure KFFormCreate(Sender: PObj);
    procedure FTPConnect(Sender: PObj);
    procedure FTPLogin(Sender: PObj);
    procedure FTPData(Sender: PObj);
    procedure FTPError(Sender: PObj);
    procedure FTPProgress(Sender: PObj);
    procedure FTPFileDone(Sender: PObj);
    procedure FTPClose(Sender: PObj);
    procedure SetToolBar(s: string);
    procedure KFResize(Sender: PObj);
    procedure PLN1Menu(Sender: PMenu; Item: Integer);
    procedure PLN2Menu(Sender: PMenu; Item: Integer);
    procedure PLN4Menu(Sender: PMenu; Item: Integer);
    procedure PTN5Menu(Sender: PMenu; Item: Integer);
    procedure PTN6Menu(Sender: PMenu; Item: Integer);
    procedure PTN8Menu(Sender: PMenu; Item: Integer);
    procedure TMTimer(Sender: PObj);
    procedure PLN9Menu(Sender: PMenu; Item: Integer);
    procedure FCFTPStatus(Sender: PObj);
    procedure KFShow(Sender: PObj);
    procedure KFDestroy(Sender: PObj);
    procedure FCGetExist(Sender: PObj; Name: String; Size: Integer;
      var append, cancel: Boolean);
    procedure FCPutExist(Sender: PObj; Name: String; Size: Integer;
      var append, cancel: Boolean);
    procedure FCFTPLogger(Sender: PObj; Msg: String);
  private
    fLPath: string;
    MVSort: PControl;
        FN: string;
        SS: array[0..4] of string;
      LSav,
      LCur,
      RSav,
      RCur: PStrList;
      FNam: string;
      dExi: string;
      uExi: string;
      Save: boolean;
      SavB: string;
    function  GetSS(Idx: integer): string;
    procedure SetSS(Idx: integer; Value: string);
    { Private declarations }
  public
    { Public declarations }
      Numb: integer;
      Link,
      RemP,
      LocP,
      Mask,
      Excl: string;
      Jupl,
      Jdnl,
      Conn: boolean;
      Entr: string;
      Wait: boolean;
      Abor: boolean;
      DPos: integer;
      property StS[Idx: integer]: string read GetSS write SetSS;
  end;
var
  Form6 {$IFDEF KOL_MCK} : PForm6 {$ELSE} : TForm6 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm6( var Result: PForm6; AParent: PControl );
{$ENDIF}

implementation

uses UWrd, UStr, UDig, Reader, Select, KOLForm;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I TaskN_1.inc}
{$ENDIF}

function  Seek(p: PStrList; s: string; var i: integer): boolean;
var n: integer;
    m: integer;
    t: string;
    l: string;
begin
   result := false;
   i := -1;
   t := UpSt(s);
   for n := 0 to p.Count - 1 do begin
      l := UpSt(p.Items[n]);
      if l = '' then exit;
      m := 1;
      while (m < length(t)) and (m < length(l)) and (t[m] = l[m]) do inc(m);
      if (m = length(t)) and (t[m] = l[m]) then begin
         result := true;
         i := n;
         exit;
      end;
   end;
end;

function  TForm6.GetSS;
begin
   if Idx in [0..4] then Result := SS[Idx] else Result := '';
end;

procedure TForm6.SetSS;
begin
   if applet = nil then exit;
   if Idx in [0..4] then begin
      if SS[Idx] <> Value then begin
         SS[Idx] := Value;
      end;
      if Form1.TC.CurIndex = Numb then begin
         if Idx = 4 then begin
            applet.Caption := Value;
         end;
         if Form1.Form.StatusText[Idx] <> Value then begin
            Form1.Form.StatusText[Idx] := PChar(Value);
         end;
      end;
   end;
end;

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
  if Info.hIcon > 0 then begin
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
  ListView := Form6.MVSort;
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

procedure TForm6.LocalUpdateListing;
var
  F: TWin32FindData;
  Enum: Hwnd;
  R,
  E: Bool;
  FileName: string;
  FileSize: Integer;
  Magic:integer;
  i, j: integer;
  systime: TSystemTime;
begin
  Pointer(Enum) := nil;
  with LV^ do
  try
    BeginUpdate;
    Clear;
    LCur.Clear;
    perform(WM_SETREDRAW,0,0);
    Enum := 0;
 for i := 1 to words(Mask, ';') do begin
    Enum := FindFirstFile(PChar(LocP + wordn(Mask, ';', i)), F);
    R := Enum <> INVALID_HANDLE_VALUE;
    Magic := 0;
    while R do
    begin
      FileName := F.cFileName;
      if filename <> '.' then
      begin
        E := True;
        for j := 1 to words(Excl, ';') do begin
           if compare(UpSt(wordn(Excl, ';', j)), UpSt(FileName)) then begin
              E := False;
           end;
        end;
        if E then begin
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
          FileTimeToSystemTime(f.ftLastWriteTime, SysTime);
          LCur.Add(FileName + ' ' + int2str(FileSize) + ' ' + SystemTime2Str(SysTime, 0, [], 'hh:mm:ss'));
        end;
        inc(Magic);
        end;
       end;
       R := FindNextFile(Enum, F);
    end;
    FindClose(Enum);
    Enum := 0;
 end;
  finally
    if Enum <> 0 then Findclose(Enum);
    MVSort := LV;
    perform(LVM_SORTITEMS,1,longint(@Sortfunc));
    perform(WM_SETREDRAW,1,0);
    endUpdate;
  end;
    Form.Update;
end;

procedure TForm6.FTPConnect;
begin
   StS[0] := '  Connected';
   Sts[3] := Entr;
   SetToolBar('010000000');
end;

procedure TForm6.FTPLogin;
begin
   StS[0] := '  Reading folder';
   FC.Cwd(RemP);
   FNam := 'Data\' + StrHl(CRC16(Link + RemP), 4);
   LSav.LoadFromFile(FNam + '.loc');
   RSav.LoadFromFile(FNam + '.rem');
   LocalUpdateListing;
end;

procedure TForm6.FTPData;
Label
    Skip;
var i: integer;
    n: integer;
    m: integer;
    c: integer;
    s: string;
    r: string;
    f: string;
begin
   RV.BeginUpdate;
   for i := DPos to FC.Listing.Count - 1 do begin
      s := FC.Listing.Items[i];
      if words(s, ' ') < 9 then continue;
      r := s;
      for n := 1 to 8 do r := wordd(r, ' ', 1);
      f := Trim(wordn(r, #13, 1));
      if (f <> '') and (f <> '..') then begin
      for c := 1 to words(Excl, ';') do
      if Compare(UpSt(wordn(Excl, ';', c)), UpSt(f)) then begin
         goto skip;
      end;
      for c := 1 to words(Mask, ';') do
      if Compare(UpSt(wordn(Mask, ';', c)), UpSt(f)) then begin
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
         if not seek(RCur, f, n) then begin
            n := RCur.Add(f);
         end;
         r := '';
         for m := 5 to 8 do r := r + ' ' + wordn(s, ' ', m);
         RCur.Items[n] := f + ' ' + r;
      end;
      end;
      if seek(RSav, f, n) then begin
         if seek(RCur, RSav.Items[n], m) then begin
            RSav.Items[n] := RCur.Items[m];
         end;
      end;
 Skip:
   end;
   DPos := FC.Listing.Count - 1;
   MVSort := RV;
{   RV.perform(LVM_SORTITEMS, 1, longint(@Sortfunc));}
   RV.perform(WM_SETREDRAW, 1, 0);
   RV.EndUpdate;
end;

procedure TForm6.FTPError;
begin
   if FC.ftpStatus = ftpNone then StS[0] := '  Disconnected'
                             else StS[0] := '  Error';
end;

procedure TForm6.FTPProgress;
var l: integer;
    c: integer;
    n: integer;
{    p: integer;}
    s: string;
begin
sleep(500);
   l := Form1.Form.StatusPanelRightX[1] -
        Form1.Form.StatusPanelRightX[0] - 10;
   c := Form1.Form.Canvas.TextWidth('|');
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
   StS[2] := '  ' + s + '/' + int2str(FC.fFileSize);
{   StS[4] := int2str(p) + ' %';}
end;

procedure LVSortAll(LV: PControl);
begin
   Form6.MVSort := LV;
   LV.BeginUpdate;
   LV.perform(LVM_SORTITEMS,1,longint(@Sortfunc));
   LV.perform(WM_SETREDRAW,1,0);
   LV.EndUpdate;
end;

procedure TForm6.MakeTask;
begin
   TV.LVAdd(name, 0, [], 0, 0, 0);
   TV.LVItems[TV.LVCount - 1, 1] := VL.LVItems[VL.LVIndexOf(name), 1];
   TV.LVItems[TV.LVCount - 1, 2] := 'waiting for ' + action;
   TV.LVItems[TV.LVCount - 1, 3] := Path;
end;

function  TForm6.NeedUpload;
var i: integer;
    n: integer;
begin
   Result := False;
   if not Jupl then exit;
   Result := True;
   if not seek(RCur, name, i) then exit;
   Result := False;
   if not seek(LCur, name, i) then exit;
   if not seek(LSav, name, n) then exit;
   Result := True;
   if UpSt(LCur.Items[i]) <> UpSt(LSav.Items[n]) then exit;
   Result := False;
end;

procedure TForm6.UpdateFile;
var i,
    n: integer;
    r: string;
begin
    seek(LCur, f, i);
    seek(LSav, f, n);
    if n < 0 then n := LSav.Add('');
    LSav.Items[n] := LCur.Items[i];
    LSav.SaveToFile(FNam + '.loc');
    seek(RCur, f, i);
    seek(RSav, f, n);
    if n < 0 then n := RSav.Add('');
    if s then RSav.Items[n] := RCur.Items[i]
         else begin
       if seek(LCur, f, i) then begin
          r := LCur.Items[i];
          r := wordn(r, ' ', words(r, ' ') - 1);
       end;
       RSav.Items[n] := f + '  ' + r;
    end;
    RSav.SaveToFile(FNam + '.rem');
end;

procedure TForm6.FTPFileDone;
var s: string;
    n: integer;
    i: integer;
    l: PStrList;
    e: string;
    u: boolean;
    a: array[0..3] of string;
begin
   StS[0] := '  Ready';
   StS[1] := '';
   StS[2] := '';
   if FC.MovedFile <> '' then begin
      s := JustFileName(FC.MovedFile);
      if TV.Count > 0 then begin
         if FC.ftpStatus = ftpReady then begin
            TV.LVDelete(TV.LVIndexOf(s));
         end else
         if FC.ftpStatus = ftpPutEr then begin
            TV.LVItems[TV.LVIndexOf(s), 2] := 'aborted      upload';
            StS[1] := FC.LastText;
         end else
         if FC.ftpStatus = ftpGetEr then begin
            TV.LVItems[TV.LVIndexOf(s), 2] := 'aborted      download';
            StS[1] := FC.LastText;
         end;
      end;
   end;
   if FC.oldStatus = KOLFtp.ftpGet then begin
      LocalUpdateListing;
      if FC.MovedFile <> '' then begin
         UpdateFile(s, true);
      end;
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
            RCur.Add(s + ' ' + int2str(FC.MovedSize));
         end else begin
            RV.LVItems[n             , 1] := int2str(FC.MovedSize);
         end;
         UpdateFile(s, false);
      end;
   end;
   if (FC.oldStatus = ftpList) and not wait then begin
      RV.perform(LVM_SORTITEMS, 1, longint(@Sortfunc));
      l := NewStrList;
      l.LoadFromFile(FNam + '.sav');
      e := '';
      u := True;
      if l.Count > 0 then begin
         e := wordn(l.Items[0], '*', 1);
         u := pos('upload', wordn(l.Items[0], '*', 2)) > 0;
      end;
      if Jdnl then
      i := 0;
      while i < RSav.Count do begin
         s := wordn(RSav.Items[i], ' ', 1);
         if not seek(RCur, s, n) then begin
            try
               DeleteFile2Recycle(LocP + s);
            except
            end;
            RSav.Delete(i);
            if u and (s = e) then begin
               e := '';
            end;
            if seek(LCur, s, n) then begin
               LCur.Delete(n);
            end;
            if seek(LSav, s, n) then begin
               LSav.Delete(n);
            end;
            continue;
         end;
         inc(i);
      end;
      for i := 0 to RCur.Count - 1 do begin
         s := wordn(RCur.Items[i], ' ', 1);
         if (UpSt(s) <> UpSt(e)) or not u then begin
            if not seek(RSav, s, n) then MakeTask(RV, s, 'download', LocP) else
            if UpSt(RCur.Items[i]) <> UpSt(RSav.Items[n]) then
            if NeedUpload(s) then MakeTask(RV, s, 'download', LocP + 'Save\')
                             else MakeTask(RV, s, 'download', LocP) else
            if not seek(LCur, s, n) then MakeTask(RV, s, 'download', LocP);
         end;
      end;
      if Jupl then
      i := 0;
      while i < LSav.Count do begin
         s := wordn(LSav.Items[i], ' ', 1);
         if not seek(LCur, s, n) then begin
            MakeTask(RV, s, 'delete', '');
            LSav.Delete(i);
            if u and (s = e) then begin
               e := '';
            end;
            if seek(RCur, s, n) then begin
               RCur.Delete(n);
            end;
            if seek(RSav, s, n) then begin
               RSav.Delete(n);
            end;
            n := TV.LVIndexOf(s);
            if n > -1 then begin
               TV.LVDelete(n);
            end;
            continue;
         end;
         inc(i);
      end;
      for i := 0 to LCur.Count - 1 do begin
         s := wordn(LCur.Items[i], ' ', 1);
         if (UpSt(s) <> UpSt(e)) or u then begin
            if NeedUpload(s) then MakeTask(LV, s, 'upload', LocP);
         end;
      end;
      if l.Count > 0 then begin
         if u then begin
            if seek(LCur, e, i) then begin
               if UpSt(LCur.Items[i]) = UpSt(l.Items[1]) then begin
                  uExi := e;
                  i := TV.LVIndexOf(e);
                  if i = -1 then begin
                     MakeTask(LV, e, 'upload', LocP);
                  end;
               end;
            end;
         end else begin
            if seek(RCur, e, i) then begin
               if UpSt(RCur.Items[i]) = UpSt(l.Items[2]) then begin
                  dExi := e;
                  i := TV.LVIndexOf(e);
                  if i = -1 then begin
                     MakeTask(RV, e, 'download', LocP);
                  end else begin
                     TV.LVItems[i, 3] := LocP;
                  end;
               end;
            end;
         end;
      end;
      if e <> '' then begin
         i := TV.LVIndexOf(e);
         if i > -1 then begin
            for n := 0 to 3 do a[n] := TV.LVItems[0, n];
            for n := 0 to 3 do TV.LVItems[0, n] := TV.LVItems[i, n];
            for n := 0 to 3 do TV.LVItems[i, n] := a[n];
         end;
      end;
      l.Free;
      if TV.Count = 0 then begin
         Save := True;
         Wait := True;
         LCur.SaveToFile(FNam + '.loc');
         RCur.SaveToFile(FNam + '.rem');
         exit;
      end;
   end;
   if Wait and (FC.oldStatus = ftpList) then begin
      LCur.SaveToFile(FNam + '.loc');
      RCur.SaveToFile(FNam + '.rem');
      Save := True;
   end;
   if (TV.Count = 0) then begin
      if (FC.fFileSize = FC.MovedSize) then begin
         l := NewStrList;
         l.SaveToFile(FNam + '.sav');
         l.Free;
      end;   
      Wait := True;
   end;
end;

procedure TForm6.FTPClose;
begin
   StS[0] := '  Disconnected';
   StS[1] := '';
   StS[2] := '';
   StS[3] := '';
   RV.Clear;
   TV.Clear;
   RCur.Clear;
   SetToolBar('100000000');
end;

procedure TForm6.KFFormCreate(Sender: PObj);
begin
   SetToolBar('100000000');

   FN := JustPathName(ParamStr(0)) + '\' + JustName(ParamStr(0)) + '.ini';

   LV.LVColAdd('Filename', taLeft, 140);
   LV.LvColAdd('FileSize', taRight, 70);
   LV.LvColAdd('Filetype', taLeft, 140);
   RV.LVColAdd('FileName', taLeft, 140);
   RV.LvColAdd('FileSize', taRight, 70);
   RV.LvColAdd('Filetype', taLeft, 140);
   TV.LvColAdd('Filename', taLeft, 140);
   TV.LvColAdd('Filesize', taRight, 70);
   TV.LvColAdd('Filestatus', taLeft, 140);
   TV.LvColAdd('FilePath', taLeft, 385);
   RV.LVColWidth[0] := 140;
   StS[0] := '  Disconnected';

   LSav       := NewStrList;
   RSav       := NewStrList;
   LCur       := NewStrList;
   RCur       := NewStrList;
end;

procedure TForm6.FTPGet;
var s: string;
begin
   if Form.ActiveControl = RV then begin
      s := RV.LVItems[RV.LVCurItem, 0];
      s := wordn(s, #13, 1);
      FC.SavePath := fLPath;
      FC.Get(s);
   end;
end;

procedure TForm6.FTPPut;
var s: string;
begin
   if Form.ActiveControl = LV then begin
      s := LV.LVItems[LV.LVCurItem, 0];
      FC.Put(fLPath + s);
   end;
end;

procedure TForm6.FTPDel;
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
                  try
                     DeleteFile2Recycle(LocP + s);
                  except
                  end;   
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

procedure TForm6.SetToolBar;
var i: integer;
begin
   SavB := s;
   if Form1.TC.CurIndex = Numb then
      for i := 1 to length(s) do Form1.TB.TBButtonEnabled[99 + i] := s[i] = '1';
end;

procedure TForm6.KFResize(Sender: PObj);
begin
   LV.Width := P1.ClientWidth div 2 - S1.Width div 2 - P1.Border * 2;
   TV.Width := P2.Width - P2.Border * 2;
end;

procedure TForm6.PLN1Menu(Sender: PMenu; Item: Integer);
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

procedure TForm6.PLN2Menu(Sender: PMenu; Item: Integer);
begin
   if Form.ActiveControl = LV then LV.LVItemState[-1] := [lvisBlend] else
   if Form.ActiveControl = RV then RV.LVItemState[-1] := [lvisBlend];
   { lvisFocus, lvisSelect, lvisBlend, lvisHighlight}
end;

procedure TForm6.PLN4Menu(Sender: PMenu; Item: Integer);
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

procedure TForm6.PTN5Menu(Sender: PMenu; Item: Integer);
begin
   TV.LVSelectAll;
end;

procedure TForm6.PTN6Menu(Sender: PMenu; Item: Integer);
begin
   TV.LVItemState[-1] := [lvisBlend];
end;

procedure TForm6.PTN8Menu(Sender: PMenu; Item: Integer);
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

procedure TForm6.Connect;
var
   FI: PIniFile;
begin
   wait   := False;
   save   := False;
   FI := OpenIniFile(Form1.FN);
   FI.Section  := Link;
   FC.HostAddr := FI.ValueString ('Site', '');
   FC.UserName := FI.ValueString ('User', '');
   FC.UserPass := FI.ValueString ('Pass', '');
   FC.HostPort := FI.ValueString ('Port', '');
   FC.Passive  := FI.ValueBoolean('Pasv', False);;
   FI.Free;
   if FC.ftpStatus = ftpNone then FC.Connect;
end;

procedure TForm6.TMTimer(Sender: PObj);
var s: string;
    i: integer;
    l: PStrList;
begin
   if (FC.ftpStatus = ftpReady) and (FC.LastCode <> 150) then begin
      if TV.Count > 0 then begin
         s := TV.LVItems[0, 2];
         l := NewStrList;
         l.Add(TV.LVItems[0, 0] + '*' + s);
         l.Add('0 0');
         if seek(LCur, TV.LVItems[0, 0], i) then l.Items[1] := LCur.Items[i];
         l.Add('0 0');
         if seek(RCur, TV.LVItems[0, 0], i) then l.Items[2] := RCur.Items[i];
         l.SaveToFile(FNam + '.sav');
         l.Free;
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
      if save then FC.Close;
      if wait then FC.List;
   end;
   if FC.ftpStatus = ftpNone then begin
      if Wait then exit;
      if Abor then exit;
      if (not Conn) or IsInet then Connect;
   end;
end;

procedure TForm6.PLN9Menu(Sender: PMenu; Item: Integer);
var LL: PControl;
     i: integer;
     s: string;
begin
   LL := Form.ActiveControl;
   for i := 0 to LL.Count - 1 do begin
      if lvisSelect in LL.LVItemState[i] then begin
         if LL = LV then begin
            s := fLPath + LV.LVItems[i, 0];
            try
               DeleteFile2Recycle(LocP + s);
            except
            end;   
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

procedure TForm6.FCFTPStatus(Sender: PObj);
var s: string;
begin
   s := '';
   if FC.ftpStatus = KOLftp.ftpReady then s := '  Ready' else
   if FC.ftpStatus = KOLftp.ftpGet   then s := '  Downloading' else
   if FC.ftpStatus = KOLftp.ftpPut   then s := '  Uploading' else
   if FC.ftpStatus = KOLftp.ftpNone  then s := '  Disconnected' else
   if FC.ftpStatus = KOLftp.ftpError then s := '  Error' else
   if FC.ftpStatus = KOLftp.ftpList  then s := '  Reading folder';
   if (s <> '') and
      (StS[0] <> s) then begin
       StS[0] := s;
   end;
end;

procedure TForm6.KFShow(Sender: PObj);
var s: string;
begin
   s := SavB;
   SetToolBar(s);
   Form1.Form.StatusText[0] := PChar(SS[0]);
   Form1.Form.StatusText[1] := PChar(SS[1]);
   Form1.Form.StatusText[2] := PChar(SS[2]);
   Form1.Form.StatusText[3] := PChar(SS[3]);
   Form.Width := Form.Width - 10;
   Form.Width := Form.Width + 10;
   KFReSize(@self);
   PostMessage(S2.Handle, WM_SIZE, 0, 0);
   PostMessage(S2.Handle, WM_MOVE, 0, 0);
end;

procedure TForm6.KFDestroy(Sender: PObj);
begin
   LSav.Free;
   LCur.Free;
   RSav.Free;
   RCur.Free;
end;

procedure TForm6.FCGetExist(Sender: PObj; Name: String; Size: Integer;
  var append, cancel: Boolean);
begin
   if dExi <> '' then
      if JustFileName(Name) = dExi then append := true;
end;

procedure TForm6.FCPutExist(Sender: PObj; Name: String; Size: Integer;
  var append, cancel: Boolean);
begin
   if uExi <> '' then
      if JustFileName(Name) = uExi then append := true;
end;

procedure TForm6.FCFTPLogger(Sender: PObj; Msg: String);
var s: string;
    i: integer;
begin
   if Msg = 'LIST' then DPos := 0;
   if (copy(Msg, 1, 3) = '250') or
      (copy(Msg, 1, 3) = '550') then begin
      s := TV.LVItems[0, 0];
      if (pos(s, Msg) > 0) or
         (pos('RMD', Msg) > 0) or
         (pos('DELE', Msg) > 0) or
         (pos('550', Msg) = 1) then begin
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

end.






















