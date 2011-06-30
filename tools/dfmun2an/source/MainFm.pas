{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainFm;

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
  PMainForm = ^TMainForm;
  TMainForm = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMainForm = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    OpenDirDialog1: TKOLOpenDirDialog;
    Label1: TKOLLabel;
    lDir: TKOLLabel;
    bOpenDir: TKOLButton;
    bGo: TKOLButton;
    ProgressBar1: TKOLProgressBar;
    procedure bOpenDirClick(Sender: PObj);
    procedure bGoClick(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
  private
    DirPath: string;
  public

  end;

var
  MainForm {$IFDEF KOL_MCK} : PMainForm {$ELSE} : TMainForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMainForm( var Result: PMainForm; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainFm_1.inc}
{$ENDIF}

{$R icons.res}

//======================================
//== ПЕРЕВОД СТРОКИ ИЗ UNICODE В ANSI ==
//======================================
function StrUnic2Ansi(Str: string): string;
var
  x: Integer;
  Num: string;
begin
  //== Удаляем из строки символы <'> - #39
  x := Pos(#39, Str);
  repeat
    Delete(Str, x, 1);
    x := Pos(#39, Str);
  until x = 0;

  for x := Pos('#', Str) to Length(Str) - 4 do
    if (Str[x + 1] in ['0'..'9']) and (Str[x + 2] in ['0'..'9']) and
       (Str[x + 3] in ['0'..'9']) and (Str[x + 4] in ['0'..'9']) then
    begin
      Num := Str[x + 1] + Str[x + 2] + Str[x + 3] + Str[x + 4];
      Delete(Str, x, 5);
      Insert(WideChar(Str2Int(Num)), Str, x);
    end;

  //== Переводим '#39' в <'>
  x := Pos('#39', Str);
  if x = 0 then
  begin
    Result := Str;
    Exit;
  end;

  repeat
    Delete(Str, x, 3);
    Insert(#39, Str, x); // '#39' -> <'>
    x := Pos('#39', Str);
  until x = 0;
  Result := Str;
end;

//=============================
//== ПОИСК UNICODE В СТРОКЕ  ==
//=============================
function isStrUnic(Str: string): Boolean;
var
  x: Integer;
begin
  Result := FALSE;
  if (Length(Str) < 5) or (Pos('#', Str) = 0) then
    Exit;

  if Pos('#39', Str) <> 0 then
  begin
    Result := TRUE;
    Exit;
  end;

  for x := Pos('#', Str) to Length(Str) - 4 do
    if (x + 4) <= Length(Str) then
      if (Str[x + 1] in ['0'..'9']) and (Str[x + 2] in ['0'..'9']) and
         (Str[x + 3] in ['0'..'9']) and (Str[x + 4] in ['0'..'9']) then
      begin
        Result := TRUE;
        Break;
      end;
end;

//===========================
//== РАЗМЕР ФАЙЛА В БАЙТАХ ==
//===========================
function DLFileSize(DL: PDirList; Idx: Integer): Integer;
var
  st: string;
begin
  st := Int64_2Str(MakeInt64(DL.Items[Idx].nFileSizeLow,
    DL.Items[Idx].nFileSizeHigh));
  Result := Str2Int(st);
end;

//====================
//== СОЗДАНИЕ ФОРМЫ ==
//====================
procedure TMainForm.KOLForm1FormCreate(Sender: PObj);
begin
  Form.StatusText[0] := '';
  Form.StatusText[1] := '';
  Form.StatusPanelRightX[0] := 180;
  DirPath := GetStartDir;
  OpenDirDialog1.InitialPath := DirPath;
end;

procedure TMainForm.KOLForm1Show(Sender: PObj);
begin
  lDir.Caption := MinimizeName(DirPath, lDir.Canvas.Handle, 256);
end;

//====================
//== ВЫБОР КАТАЛОГА ==
//====================
procedure TMainForm.bOpenDirClick(Sender: PObj);
begin
  if not OpenDirDialog1.Execute then
    Exit;
  if not DirectoryExists(OpenDirDialog1.Path) then
  begin
    MessageBox(0, PChar('Не могу открыть каталог' + #13 + #10 +
      OpenDirDialog1.Path), PChar(Form.Caption), MB_ICONSTOP);
    Exit;
  end;

  Form.StatusText[0] := '';
  Form.StatusText[1] := '';
  ProgressBar1.Progress := 0;
  DirPath := IncludeTrailingPathDelimiter(OpenDirDialog1.Path);
  lDir.Caption := MinimizeName(DirPath, lDir.Canvas.Handle, 256);
  OpenDirDialog1.InitialPath := DirPath;
end;

//===================================
//== ПЕРЕВОД DFM ИЗ UNICODE В ANSI ==
//===================================
procedure TMainForm.bGoClick(Sender: PObj);
const
  DFM = '*.dfm';
  UNIC = '.unic';
var
  DL: PDirList;
  Flag, UnFlag: Boolean; // Есть Unicode строка
  Idx, x: Integer;
  st : string;
  FR, FW: Text;
//=============================
procedure InitSBMsg(pc: PChar);
var
  Idx :Integer;
begin
  Form.StatusText[0] := pc;
  x := 0;
  ProgressBar1.Progress := 0;
  ProgressBar1.MaxProgress := 0;
  for Idx := 0 to DL.Count - 1 do
    ProgressBar1.MaxProgress := ProgressBar1.MaxProgress + DLFileSize(DL, Idx);
end;
//=============================

begin
  DL := NewDirListEx(DirPath, DFM, 0);
  DL.Sort([sdrByExt]);

  if (DL.Count = 0) then
  begin
    Form.StatusText[0] := 'В каталоге нет dfm-файлов.';
    DL.Free;
    Exit; // Выход, если dfm в каталоге нет.
  end;

  InitSBMsg('Идет поиск...');

  //== Анализ файлов ==//

  UnFlag := FALSE;
  for Idx := 0 to DL.Count - 1 do
  begin
    Flag := FALSE;
    Form.StatusText[1] := PChar(DL.Names[Idx]);
    AssignFile(FR, DirPath + DL.Names[Idx]);
    Reset(FR);
    while not Eof(FR) do
    begin
      ReadLn(FR, st);
      x := x + Length(st) + 2;
      ProgressBar1.Progress := ProgressBar1.Progress + x;
      Flag := isStrUnic(st);
      if Flag then
      begin
        CloseFile(FR);
        UnFlag := TRUE;
        ProgressBar1.Progress := // Размер файла минус считанные байты
          ProgressBar1.Progress + (DLFileSize(DL, Idx) - x);
        MoveFileEx(PChar(DirPath + DL.Names[Idx]),
          PChar(DirPath + DL.Names[Idx] + UNIC), MOVEFILE_REPLACE_EXISTING);
        break; // Выход из чтения файла
      end;
    end; // while

    if not Flag then
      CloseFile(FR);
  end; // for

  if not UnFlag then
  begin
    Form.StatusText[0] := 'Unicode в dfm-файлах отсутствует.';
    DL.Free;
    Exit;
  end;

  DL.ScanDirectory(DirPath, DFM + UNIC, 0);

  if DL.Count = 0 then
  begin
    Form.StatusText[0] := 'Не могу найти файлы *.dfm.unic...';
    Form.StatusText[1] := 'ВНИМАНИЕ.';
    DL.Free;
    Exit;
  end;

  InitSBMsg('Идет замена...');

  //== Замена Unicode в Ansi в *.dfm_unic-файлах ==//

  for Idx := 0 to DL.Count - 1 do
  begin
    Form.StatusText[1] := PChar(DL.Names[Idx]);
    st := DirPath + DL.Names[Idx];
    AssignFile(FR, st);
    Reset(FR); // Чтение
    SetLength(st, Length(st) - 5);
    AssignFile(FW, st);
    Rewrite(FW); // Запись

    while not Eof(FR) do
    begin
      ReadLn(FR, st);
      ProgressBar1.Progress := ProgressBar1.Progress + Length(st) + 2;
      if isStrUnic(st) then
      begin
        //== Находим первый символ переводимой строки
        x := Pos('=', st) + 1;
        while (st[x] = #32) or (st[x] = '(') do
          Inc(x);
        st := StrUnic2Ansi(st);

        //== Расставляем <'>
        Insert(#39, st, x);
        x := Pos(')', st);
        if x = 0 then
          st := st + #39
        else
          Insert(#39, st, x);
      end;
      WriteLn(FW, st);
    end; // while

    CloseFile(FR);
    CloseFile(FW);
  end;   // for
  DL.Free;
  Form.StatusText[0] := 'Готово.';
end;

end.

