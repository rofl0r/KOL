{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLBAPDriveBox, KOLBAPFileBrowser {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,
  mckBAPFileBrowser, mckBAPDriveBox {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
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
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    mMain: TKOLMainMenu;
    BAPDriveBox1: TKOLBAPDriveBox;
    BAPFileBrowser1: TKOLBAPFileBrowser;
    ListBox1: TKOLListBox;
    cbSelect: TKOLCheckBox;
    bAddList: TKOLButton;
    bClearList: TKOLButton;
    lPath: TKOLLabel;
    bLevelUp: TKOLButton;
    bRoot: TKOLButton;
    Label2: TKOLLabel;
    Label3: TKOLLabel;
    lSelFile: TKOLLabel;
    Label5: TKOLLabel;
    lSelDir: TKOLLabel;
    ebFilter: TKOLEditBox;
    bRefresh: TKOLButton;
    cbShowPath: TKOLCheckBox;
    cbAddPath: TKOLCheckBox;
    procedure bRefreshClick(Sender: PObj);
    procedure bClearListClick(Sender: PObj);
    procedure bAddListClick(Sender: PObj);
    procedure bLevelUpClick(Sender: PObj);
    procedure bRootClick(Sender: PObj);
    procedure ebFilterChar(Sender: PControl; var Key: Char;
      Shift: Cardinal);
    procedure BAPDriveBox1ChangeDrive(Sender: PControl; Drive: String;
      const ReadErr: Boolean; var Retry: Boolean);
    procedure BAPFileBrowser1ChangeDir(Sender: PControl; Path: String;
      const ReadErr: Boolean);
    procedure BAPFileBrowser1SelFile(Sender: PControl; FileName: String;
      const Dir: Boolean; Attr: PWin32FindDataA);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure BAPFileBrowser1GetSelFiles(Sender: PControl;
      FileName: String; const Dir: Boolean; Attr: PWin32FindDataA);
    procedure KOLForm1N2Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N8Menu(Sender: PMenu; Item: Integer);
    procedure mMainN11Menu(Sender: PMenu; Item: Integer);
    procedure mMainN14Menu(Sender: PMenu; Item: Integer);
  private
    ColSW, ColDW: Integer; // Ширина колонок
    ColST, ColDT: string; // Текст коконок
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

procedure TForm1.bRefreshClick(Sender: PObj);
begin
  BAPFileBrowser1.Refresh;
end;

procedure TForm1.bClearListClick(Sender: PObj);
begin
  ListBox1.Clear;
end;

procedure TForm1.bAddListClick(Sender: PObj);
begin
  BAPFileBrowser1.GetSelFiles(cbSelect.Checked);
end;

procedure TForm1.bLevelUpClick(Sender: PObj);
begin
  BAPFileBrowser1.LevelUp;
end;

procedure TForm1.bRootClick(Sender: PObj);
begin
  BAPFileBrowser1.RootDir;
end;

(* Установка фильтра *)

procedure TForm1.ebFilterChar(Sender: PControl; var Key: Char;
  Shift: Cardinal);
begin
  if Key = #13 then
  begin
    Key := #0;
    BAPFileBrowser1.FileFilter := ebFilter.Text;
    BAPFileBrowser1.Refresh;
  end;
end;

(* Выбор диска *)

procedure TForm1.BAPDriveBox1ChangeDrive(Sender: PControl; Drive: String;
  const ReadErr: Boolean; var Retry: Boolean);
begin
  if ReadErr then
    if MessageBox(0, PChar('Не могу прочитать диск ' + Drive + #13 + #10 +
        'Повторить чтение?'), 'Ошибка чтения',
        MB_RETRYCANCEL + MB_ICONSTOP) = IDRETRY then
      Retry := True;

  if not ReadErr then
    BAPFileBrowser1.Directory := Drive;
end;

(* Смена каталога *)

procedure TForm1.BAPFileBrowser1ChangeDir(Sender: PControl; Path: String;
  const ReadErr: Boolean);
begin
  if not ReadErr then
    lPath.Caption := Path;
end;

(* Выделенный файл *)

procedure TForm1.BAPFileBrowser1SelFile(Sender: PControl; FileName: String;
  const Dir: Boolean; Attr: PWin32FindDataA);
begin
  lSelDir.Caption := '';
  lSelFile.Caption := '';

  if Dir then
    if cbShowPath.Checked then
      if Attr = nil then // FileName = '[..]'
        lSelDir.Caption := BAPFileBrowser1.Directory
      else
        lSelDir.Caption := BAPFileBrowser1.Directory + FileName
    else
      lSelDir.Caption := FileName
  else
    if cbShowPath.Checked then
      lSelFile.Caption := BAPFileBrowser1.Directory + FileName
    else
      lSelFile.Caption := FileName;
end;

(* Создание формы *)

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  mMain.Items[10].Checked := False;
  lPath.Caption := BAPFileBrowser1.Directory;
end;

(* Получение выделенных файлов *)

procedure TForm1.BAPFileBrowser1GetSelFiles(Sender: PControl;
  FileName: String; const Dir: Boolean; Attr: PWin32FindDataA);
begin
  if cbAddPath.Checked then
    FileName := BAPFileBrowser1.Directory + FileName;
  ListBox1.Add(FileName);
end;

(* Стиль *)

procedure TForm1.KOLForm1N2Menu(Sender: PMenu; Item: Integer);
begin
  case Item of
    1: BAPFileBrowser1.LVStyle := lvsDetail;
    2: BAPFileBrowser1.LVStyle := lvsDetailNoHeader;
    3: BAPFileBrowser1.LVStyle := lvsIcon;
    4: BAPFileBrowser1.LVStyle := lvsList;
    5: BAPFileBrowser1.LVStyle := lvsSmallIcon;
  end;
end;

(* Столбцы *)

procedure TForm1.KOLForm1N8Menu(Sender: PMenu; Item: Integer);
var
  Cols: TFBColumns;
begin
  Cols := BAPFileBrowser1.Columns;
  if BAPFileBrowser1.ColSizeIdx > -1 then
  begin
    ColSW := BAPFileBrowser1.LVColWidth[BAPFileBrowser1.ColSizeIdx];
    ColST := BAPFileBrowser1.LVColText[BAPFileBrowser1.ColSizeIdx];
  end;

  if BAPFileBrowser1.ColDateIdx > -1 then
  begin
    ColDW := BAPFileBrowser1.LVColWidth[BAPFileBrowser1.ColDateIdx];
    ColDT := BAPFileBrowser1.LVColText[BAPFileBrowser1.ColDateIdx];
  end;

  case Item of
    7: if mMain.Items[7].Checked then
         Include(Cols, fbcSize)
       else
         Exclude(Cols, fbcSize);

    8: if mMain.Items[8].Checked then
         Include(Cols, fbcDate)
       else
         Exclude(Cols, fbcDate);
  end;
  BAPFileBrowser1.Columns := Cols;

  if BAPFileBrowser1.ColSizeIdx > -1 then
  begin
    BAPFileBrowser1.LVColWidth[BAPFileBrowser1.ColSizeIdx] := ColSW;
    BAPFileBrowser1.LVColText[BAPFileBrowser1.ColSizeIdx] := ColST;
  end;

  if BAPFileBrowser1.ColDateIdx > -1 then
  begin
    BAPFileBrowser1.LVColWidth[BAPFileBrowser1.ColDateIdx] := ColDW;
    BAPFileBrowser1.LVColText[BAPFileBrowser1.ColDateIdx] := ColDT;
  end;
end;

(* Свойства *)

procedure TForm1.mMainN11Menu(Sender: PMenu; Item: Integer);
begin
  case Item of
    10: BAPFileBrowser1.ShowOnlyFiles := mMain.Items[10].Checked;
    11: BAPFileBrowser1.ShowUpDir := mMain.Items[11].Checked;
  end;
  BAPFileBrowser1.Refresh;
end;

(* Сортировка файлов *)

procedure TForm1.mMainN14Menu(Sender: PMenu; Item: Integer);
begin
  case Item of
    13: BAPFileBrowser1.FileSort := sdrByName;
    14: BAPFileBrowser1.FileSort := sdrByExt;
    15: BAPFileBrowser1.FileSort := sdrByDateCreate;
    16: BAPFileBrowser1.FileSort := sdrBySize;
  end;
  BAPFileBrowser1.Refresh;
end;

end.

