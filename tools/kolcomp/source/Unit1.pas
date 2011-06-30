{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    TabControl1: TKOLTabControl;
    TabControl1_Tab0: TKOLPanel;
    TabControl1_Tab1: TKOLPanel;
    TabControl1_Tab2: TKOLPanel;
    mMCKCtl: TKOLMemo;
    bCrPat: TKOLButton;
    OpenDirDialog1: TKOLOpenDirDialog;
    bSelPath: TKOLButton;
    GroupBox1: TKOLGroupBox;
    Label1: TKOLLabel;
    eComp: TKOLEditBox;
    Label4: TKOLLabel;
    eData: TKOLEditBox;
    Label7: TKOLLabel;
    Label8: TKOLLabel;
    Label6: TKOLLabel;
    eWndProc: TKOLEditBox;
    Label3: TKOLLabel;
    GroupBox2: TKOLGroupBox;
    Label9: TKOLLabel;
    eSender: TKOLEditBox;
    Label2: TKOLLabel;
    ePalette: TKOLEditBox;
    Label5: TKOLLabel;
    Label10: TKOLLabel;
    TabControl1_Tab3: TKOLPanel;
    TabControl1_Tab4: TKOLPanel;
    mPD5: TKOLMemo;
    GroupBox3: TKOLGroupBox;
    Label11: TKOLLabel;
    eDiscr: TKOLEditBox;
    Label12: TKOLLabel;
    mPD6: TKOLMemo;
    mKOLCtl: TKOLMemo;
    TabControl1_Tab5: TKOLPanel;
    TabControl1_Tab6: TKOLPanel;
    TabControl1_Tab7: TKOLPanel;
    mInfo: TKOLMemo;
    mMCKObj: TKOLMemo;
    mKOLObj: TKOLMemo;
    GroupBox4: TKOLGroupBox;
    rbCtl: TKOLRadioBox;
    rbObj: TKOLRadioBox;
    Label13: TKOLLabel;
    Label14: TKOLLabel;
    Label15: TKOLLabel;
    Label17: TKOLLabel;
    GroupBox5: TKOLGroupBox;
    bSelBmp: TKOLButton;
    OpenDialog1: TKOLOpenSaveDialog;
    Panel1: TKOLPanel;
    PaintBox1: TKOLPaintBox;
    procedure bSelPathClick(Sender: PObj);
    procedure bCrPatClick(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure bSelBmpClick(Sender: PObj);
    procedure PaintBox1Paint(Sender: PControl; DC: HDC);
  private


  public
    bmp: PBitmap;
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

const
 cr = #13 + #10;
 er1 = 'Не могу создать файл: ';
 er2 = 'Не могу прочитать файл: ';
 er3 = 'Ошибка чтения';

{------------------------}
{ ЗАГРУЗКА ТЕКСТА В Memo }
{------------------------}
procedure MemoLoadFile(Ctl: PControl; FileName: String);
var
 TF: Text;
 s: String;
begin
AssignFile(TF, FileName);

{$I-}
Reset(TF);
{$I+}
if IOResult <> 0
 then begin
  MessageBox(Applet.Handle, PChar(er2 + cr + FileName), er3, MB_ICONSTOP);
  exit;
 end;

While not Eof(TF) do
 begin
  ReadLn(TF, s);
  if not Eof(TF) then s := s + cr;
  Ctl.Add(s);
 end;

CloseFile(TF);
end;

{-------------------------}
{ ОТКРЫТЬ ФАЙЛ ДЛЯ ЗАПИСИ }
{-------------------------}
function RewriteOpen(var TF: Text; const FileNm: String): Boolean;
begin
Result := TRUE;
AssignFile(TF, FileNm);

{$I-}
Rewrite(TF);
{$I+}
if IOResult <> 0
 then begin
  Result := FALSE;
  MessageBox(Applet.Handle, PChar(er1 + cr + FileNm), er3, MB_ICONSTOP);
 end;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
const
 ext = '.txt';
 path = 'Patterns\';
begin
MemoLoadFile(mKOLCtl, path + 'KOLControl' + ext);
MemoLoadFile(mMCKCtl, path + 'mckControl' + ext);
MemoLoadFile(mKOLObj, path + 'KOLObj' + ext);
MemoLoadFile(mMCKObj, path + 'mckObj' + ext);
MemoLoadFile(mPD5, path + 'PackageD5' + ext);
MemoLoadFile(mPD6, path + 'PackageD6' + ext);
MemoLoadFile(mInfo, path + 'Info' + ext);
end;

procedure TForm1.bSelPathClick(Sender: PObj);
begin
OpenDirDialog1.Execute;
end;

procedure TForm1.bSelBmpClick(Sender: PObj);
begin
if not OpenDialog1.Execute then exit;
PaintBox1.Visible := FALSE;
if bmp = nil then bmp := NewBitmap(0, 0);
bmp.LoadFromFile(OpenDialog1.Filename);
bmp.Width := 24;
bmp.Height := 24;
PaintBox1.Visible := TRUE;
end;

procedure TForm1.PaintBox1Paint(Sender: PControl; DC: HDC);
begin
if bmp <> nil then bmp.Draw(DC, 0, 0);
end;

procedure TForm1.bCrPatClick(Sender: PObj);

{ Замена строки }
procedure RepStr(var st1: String; st2, st3: String);
var x: Integer;
begin
while pos(st2, st1) <> 0 do
 begin
  x := pos(st2, st1);
  Delete(st1, x, 4);
  Insert(st3, st1, x);
 end;
end;

const
 ex1 = '.pas';
 ex2 = '.dpk';
var
 TF: Text;
 x: Integer;
 Ctl: PControl;
 Path, FileNm, st: String;
begin
if OpenDirDialog1.Path = ''
 then Path := GetStartDir
  else Path := IncludeTrailingPathDelimiter(OpenDirDialog1.Path);

{ Создание KOL файла }
FileNm := Path + 'KOL' + eComp.Text + ex1;
if RewriteOpen(TF, FileNm)
 then begin
  if rbCtl.Checked
   then Ctl := mKOLCtl   { Control }
    else Ctl := mKOLObj; { Obj }

  for x := 0 to Ctl.Count - 1 do
   begin
    st := Ctl.Items[x];
    RepStr(st, '_KC_', eComp.Text);
    RepStr(st, '_CD_', eData.Text);
    RepStr(st, '_WP_', eWndProc.Text);
    WriteLn(TF, st);
   end;

  CloseFile(TF);
 end;

{ Создание MCK файла }
FileNm := Path + 'mck' + eComp.Text + ex1;
if RewriteOpen(TF, FileNm)
 then begin
  if rbCtl.Checked
   then Ctl := mMCKCtl   { Control }
    else Ctl := mMCKObj; { Obj }

  for x := 0 to Ctl.Count - 1 do
   begin
    st := Ctl.Items[x];
    RepStr(st, '_KC_', eComp.Text);
    RepStr(st, '_PC_', eSender.Text);
    RepStr(st, '_PP_', ePalette.Text);
    WriteLn(TF, st);
   end;

  CloseFile(TF);
 end;

{ Создание PD5 файла }
FileNm := Path + eComp.Text + 'D5' + ex2;
if RewriteOpen(TF, FileNm)
 then begin
  for x := 0 to mPD5.Count - 1 do
  begin
   st := mPD5.Items[x];
   RepStr(st, '_KC_', eComp.Text);
   RepStr(st, '_PD_', eDiscr.Text);
   WriteLn(TF, st);
  end;

  CloseFile(TF);
 end;

{ Создание PD6 файла }
FileNm := Path + eComp.Text + 'D6' + ex2;
if RewriteOpen(TF, FileNm)
 then begin
  for x := 0 to mPD6.Count - 1 do
   begin
    st := mPD6.Items[x];
    RepStr(st, '_KC_', eComp.Text);
    RepStr(st, '_PD_', eDiscr.Text);
    WriteLn(TF, st);
   end;

  CloseFile(TF);
 end;

{ Создание файла ресурса }
if bmp <> nil
 then begin
  FileNm := Path + 'mck' + eComp.Text + '.rc';
  if RewriteOpen(TF, FileNm)
   then begin
    st := 'TKOL' + eComp.Text + ' BITMAP ' + '"' + OpenDialog1.Filename + '"';
    WriteLn(TF, st);
    CloseFile(TF);
    ExecuteWait('brcc32.exe', FileNm, '', SW_HIDE, INFINITE, nil);
    DeleteFile(PChar(FileNm));
    FileNm := Path + 'mck' + eComp.Text;
    CopyFile(PChar(FileNm + '.res'), PChar(FileNm + '.dcr'), FALSE);
   end;
 end;

MessageBox(Applet.Handle, 'Шаблон успешно создан.', 'Шаблон KOL компонента', MB_ICONINFORMATION);
end;

end.