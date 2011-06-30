unit KOLBAPFileBrowser;
{*
|&C=BAPFileBrowser
|Component: <C><br>
|Version: 1.01<br>
|Date: 10.06.2003<br>
|Author: <a href="mailto:delphikol@narod.ru?subject=<C> v1.01">Александр Бартов</a>
|&L=http://delphikol.narod.ru
|<br>Web-page: <a href="<L>/" target="_blank"><L></a>
|<hr width="100%">
|<b>Использование компонента.</b><br>KOL/MCK >= 1.77<br>
|Свойства, которые используются только в <b>MCK</b>, начинаются с <b>mck</b>XXX.<br>
|<br><b><u>На заметку:</u></b><br>
|1. Для изменения текста и ширины колонок воспользуйтесь свойствами LVColText[Idx]
|и LVColWidth[Idx], где Idx номер колонки (см. ColSizeIdx  или ColDateIdx).<br>
|2. После изменения свойств FileFilter, FileSort, ShowOnlyFiles, ShowUpDir -
|вызовите метод <b>Refresh</b>.
|&I=<i>%1</i>}

interface

uses Windows, Messages, KOL;

type
  TFBColumns = set of (fbcSize, fbcDate);
  {*}

  TOnBeforeExecute = procedure(Sender: PControl; FileName: string; var RunFile: Boolean) of object;
  {* |&0=(Default = True)
  |<ul><I FileName> - имя файла,
  |<br><I RunFile> - запустить файл <0>.</ul>}

  TOnChangeDir = procedure(Sender: PControl; Path: string; const ReadErr: Boolean) of object;
  {* |<ul><I Path> - текущий каталог,
  |<br><I ReadErr> - True, если возникла ошибка при смене каталога.</ul>}

  TOnDirNotify = procedure(Sender: PControl; var Refresh: Boolean) of object;
  {* |<ul><I Refresh> - обновить каталог <0>.</ul>}

  TOnExecute = procedure(Sender: PControl; FileName: string; const Rslt: Integer) of object;
  {* |<ul><I FileName> - имя файла,
  |<br><I Rslt> - Если Rslt < 32 - ошибка (см. функцию ShellExecute).</ul>}

  TOnSelFile = procedure(Sender: PControl; FileName: string; const Dir: Boolean; Attr: PWin32FindData) of object;
  {* |<ul><I FileName> - имя файла,
  |<br><I Dir> - True, если каталог,
  |<br><I Attr> - атрибуты файла.</ul>}

  PBAPFileBrowser = ^TBAPFileBrowser;
  TBAPFileBrowser = object(TControl)
  {* ListView, отображающий файлы и подкаталоги заданного каталога.}
  private
    procedure DirChange( Sender: PDirChange; const Path: string);
    function GetColDateIdx: Integer;
    function GetColSizeIdx: Integer;
    function GetColumns: TFBColumns;
    function GetDirectory: string;
    function GetFileAttr(Idx: Integer): PWin32FindData;
    function GetFileFilter: string;
    function GetFileIcon(Idx: Integer): Integer;
    function GetFileSort: TSortDirRules;
    function GetShowOnlyFiles: Boolean;
    function GetShowUpDir: Boolean;
    function GetOnBeforeExecute: TOnBeforeExecute;
    function GetOnChangeDir: TOnChangeDir;
    function GetOnDirNotify: TOnDirNotify;
    function GetOnExecute: TOnExecute;
    function GetOnGetSelFiles: TOnSelFile;
    function GetOnSelFile: TOnSelFile;
    procedure SetColumns(const Value: TFBColumns);
    procedure SetDirectory(Value: string);
    procedure SetFileFilter(const Value: string);
    procedure SetFileSort(const Value: TSortDirRules);
    procedure SetShowOnlyFiles(const Value: Boolean);
    procedure SetShowUpDir(const Value: Boolean);
    procedure SetOnBeforeExecute(const Value: TOnBeforeExecute);
    procedure SetOnChangeDir(const Value: TOnChangeDir);
    procedure SetOnDirNotify(const Value: TOnDirNotify);
    procedure SetOnExecute(const Value: TOnExecute);
    procedure SetOnGetSelFiles(const Value: TOnSelFile);
    procedure SetOnSelFile(const Value: TOnSelFile);

    procedure NewOnLVData(Sender: PControl; Idx, SubItem: Integer; var Txt: string;
      var ImgIdx: Integer; var State: DWORD; var Store: Boolean);
      
    procedure NewOnLVStateChange(Sender: PControl; IdxFrom, IdxTo: Integer;
      OldState, NewState: DWORD);
  public
    procedure GetSelFiles(const NotSelect: Boolean);
    {* Запускает обработчик OnSelFile для каждого выделенного файла.
    |<br><I NotSelect> = True - снимать выделение с файла(ов) после обработки.}
    procedure LevelUp;
    {* Перейти на каталог выше.}
    procedure Refresh;
    {* Перечитать каталог.}
    procedure RootDir;
    {* Перейти в корневой каталог.}
    property ColDateIdx: Integer read GetColDateIdx;
    {* |&0=Возвращает индекс колонки %1 (равно -1, если колонки нет).
    |<0 "Date">}
    property ColSizeIdx: Integer read GetColSizeIdx;
    {* <0 "Size">}
    property Columns: TFBColumns read GetColumns write SetColumns;
    {* Столбцы "Size" и "Date".}
    property Directory: string read GetDirectory write SetDirectory;
    {* Устанавливает/Возвращает текущий каталог.
    |<br><I Directory> := <b>'x:'</b>, установится последний каталог,
    |где вы были до перехода на другой диск.}
    property FileAttr[Idx: Integer]: PWin32FindData read GetFileAttr;
    {* |&0=Возвращает
    |<0> атрибуты файла (<b>nil</b>, если "[..]").}
    property FileFilter: string read GetFileFilter write SetFileFilter;
    {* Фильтр файлов (Например: '*.pas;*.exe;').}
    property FileIcon[Idx: Integer]: Integer read GetFileIcon;
    {* <0> системный индекс иконки.} 
    property FileSort: TSortDirRules read GetFileSort write SetFileSort;
    {* Тип сортировки файлов.}
    property ShowOnlyFiles: Boolean read GetShowOnlyFiles write SetShowOnlyFiles;
    {* |&0=Показывать
    |<0> только файлы.}
    property ShowUpDir: Boolean read GetShowUpDir write SetShowUpDir;
    {* <0> "[..]".}
    property OnBeforeExecute: TOnBeforeExecute read GetOnBeforeExecute write SetOnBeforeExecute;
    {* Возникает перед событием OnExecute.}
    property OnChangeDir: TOnChangeDir read GetOnChangeDir write SetOnChangeDir;
    {* |&0=Возникает при
    |<0> смене каталога.}
    property OnDirNotify: TOnDirNotify read GetOnDirNotify write SetOnDirNotify;
    {* <0> добавлении, удалении или изменении атрибутов файла(ов).}
    property OnExecute: TOnExecute read GetOnExecute write SetOnExecute;
    {* <0> запуске файла.}
    property OnGetSelFiles: TOnSelFile read GetOnGetSelFiles write SetOnGetSelFiles;
    {* <0> вызове метода GetSelFiles.}
    property OnSelFile: TOnSelFile read GetOnSelFile write SetOnSelFile;
    {* <0> выборе файла.}

    //== Блокировка свойств
    property OnLVData: Boolean read FNotAvailable;
    {* |&0=Недоступно.
    |<0>}
    property OnPaint: Boolean read FNotAvailable;
    {* <0>}
  end;

  TKOLBAPFileBrowser = PBAPFileBrowser;

function NewBAPFileBrowser(Sender: PControl; Style: TListViewStyle;
  Columns: TFBColumns; FileFilter: string; FileSort: TSortDirRules;
  ShowOnlyFiles, ShowUpDir: Boolean): PBAPFileBrowser;
{* Создает новый <C>.
|&L=<a href="tbapfilebrowser.htm#%1">%1</a>
|<ul><I Sender> - Applet (Form), <I Style>, <L Columns>, <L FileFilter>,
|<L FileSort>, <L ShowOnlyFiles>, <L ShowUpDir>.</ul>}

implementation

uses CommCtrl, ShellApi;

(* Данные объекта *)

type
  PCtlObj = ^TCtlObj;
  TCtlObj = object(TObj)
    FControl: PControl;
    DL: PDirList;
    DC: PDirChange;
    IL16, IL32: PImageList;
    ParentDirName: string; // Родительский каталог
    PatentDir: Boolean;
    FIdx: Integer; // FIdx = 1 - присутствие "[..]"
    IcOF: Integer; // Индекс иконки "открытой папки"
    FPaths: array['a'..'z'] of string; // Запоминаем пути на дисках

    ColSizeIdx, ColDateIdx: Integer;
    Columns: TFBColumns;
    FileFilter: string;
    FileSort: TSortDirRules;
    ShowOnlyFiles: Boolean;
    ShowUpDir: Boolean;
    OnBeforeExecute: TOnBeforeExecute;
    OnChangeDir: TOnChangeDir;
    OnDirNotify: TOnDirNotify;
    OnExecute: TOnExecute;
    OnGetSelFiles: TOnSelFile;
    OnSelFile: TOnSelFile;
    destructor Destroy; virtual;
 end;

(* Деструктор данных *)

destructor TCtlObj.Destroy;
var
  ch: Char;
begin
  for ch := 'a' to 'z' do
    FPaths[ch] := #0;
  FileFilter := '';
  ParentDirName := '';
  Free_And_Nil(DL);
  Free_And_Nil(IL16);
  Free_And_Nil(IL32);
  inherited;
end;

(* Иконка файла *)

function FileIconSysIdx(const Path: string; const OpenIcon: Boolean): Integer;
var
 Flags: Integer;
 SFI: TSHFileInfo;
begin
  Flags := SHGFI_ICON or SHGFI_SMALLICON or SHGFI_SYSICONINDEX;
  if OpenIcon then
    Flags := Flags or SHGFI_OPENICON;
  SFI.iIcon := 0;
  SHGetFileInfo(PChar(Path), 0, SFI, SizeOf(SFI), Flags);
  if SFI.iIcon <> 0 then
    Result := SFI.iIcon
  else
    Result := FileIconSysIdxOffline(Path);
end;

(* Тип файла *)

function GetFileType(const Path: string): string;
var
  SFI: TSHFileInfo;
begin
  SHGetFileInfo(PChar(Path), 0, SFI, SizeOf(SFI), SHGFI_TYPENAME);
  Result := SFI.szTypeName;
end;

(* Получить родительский каталог *)

function GetParentDir(Ctl: PControl; st: string): string;
var
  Idx: Integer;
  D: PCtlObj;
begin
  D := Pointer(Ctl.CustomObj);
  D.PatentDir := True;
  D.ParentDirName := '';
  st := ExcludeTrailingPathDelimiter(st);

  for Idx := Length(st) downto 3 do // Точка входа
    if st[Idx] <> '\' then
      D.ParentDirName := st[Idx] + D.ParentDirName // Только имя
    else
      Break;
  SetLength(st, Idx);
  Result := st;
end;

(* Получить новый каталог *)

function GetNewPath(Ctl: PControl): string;
var
  D: PCtlObj;
begin
  D := Pointer(Ctl.CustomObj);
  D.PatentDir := False;
  Result := D.DL.Path;

  if (Ctl.LVCurItem - D.FIdx) < 0 then // "[..]"
    Result := GetParentDir(Ctl, Result)
  else
    Result := Result + Ctl.LVItems[Ctl.LVCurItem, 0];
end;

(* Читать каталог *)

procedure ReadDir(Ctl: PControl; Path: string);
var
  Refresh: Boolean;
  ch: Char;
  Idx, LVIdx: Integer;
  Attr: DWord;
  D: PCtlObj;
  st: string;
begin
  D := Pointer(Ctl.CustomObj);
  if not DirectoryExists(Path) then
  begin
    if Assigned(D.OnChangeDir) then
      D.OnChangeDir(Ctl, Path, True);
    Exit;
  end;

  LVIdx := 0;
  if D.DC <> nil then
    Free_And_Nil(D.DC);

  //== Получить последний каталог на дисках
  st := LowerCase(Path[1]);
  ch := st[1];

  if Path = D.DL.Path then
  begin
    Refresh := True;
    LVIdx := Ctl.LVCurItem;
  end else
  begin
    Refresh := False;
    if (Length(Path) = 2) and (D.FPaths[ch] <> '') then
      Path := D.FPaths[ch];
    Path := IncludeTrailingPathDelimiter(Path);
    D.FPaths[ch] := Path;
  end;

  if (Length(Path) > 3) and (D.ShowUpDir) and (not D.ShowOnlyFiles) then
    D.FIdx := 1
  else
    D.FIdx := 0;

  if D.ShowOnlyFiles then
    Attr := File_ATTRIBUTE_NORMAL and FILE_ATTRIBUTE_DIRECTORY
  else
    Attr := File_ATTRIBUTE_NORMAL or FILE_ATTRIBUTE_DIRECTORY;

  D.DL.ScanDirectoryEx(Path, D.FileFilter, attr);
  D.DL.Sort(D.FileSort);
  Ctl.LVCount := D.DL.Count + D.FIdx;
  D.IcOF := 0;

  //== Установка курсора на родительский каталог
  if D.PatentDir and (not Refresh) then
    for Idx := 0 to D.DL.Count - 1 do
      if D.ParentDirName = D.DL.Names[Idx] then
      begin
        LVIdx := Idx + D.FIdx;
        Break;
      end;

  if LVIdx > Ctl.LVCount - 1 then
    LVIdx := Ctl.LVCount - 1;
  Ctl.LVCurItem := LVIdx;
  if not Refresh then
    Ctl.LVMakeVisible(LVIdx + 3, False);
  Ctl.LVMakeVisible(LVIdx, False);

  if Applet <> nil then // MCK
    D.DC := NewDirChangeNotifier(Path, [fncFileName, fncDirName, fncAttributes],
      False, PBAPFileBrowser(Ctl).DirChange);
  if Assigned(D.OnChangeDir) then
    D.OnChangeDir(Ctl, Path, False);
end;

(* Событие NewOnLVData *)

procedure TBAPFileBrowser.NewOnLVData;
var
  D: PCtlObj;
  Index: Integer;
  ST: TSystemTime;
begin
  D := Pointer(CustomObj);
  if (SubItem = 1) and (D.ColDateIdx = 1) then
    SubItem := 2;
  Index := Idx - D.FIdx;

  case SubItem of
    0: //== Column 1
      begin
        if Index < 0 then // "[..]"
        begin
          Txt := '[..]';
          if D.IcOF = 0 then
            D.IcOF := FileIconSysIdx(D.DL.Path, True);
          ImgIdx := D.IcOF; // Индекс иконки
          Exit;
        end;

        Txt := D.DL.Names[Index]; // имя файла

        if D.DL.Items[Index].dwReserved1 <> 10 then
        begin
          D.DL.Items[Index].dwReserved1 := 10;
          D.DL.Items[Index].dwReserved0 :=
            FileIconSysIdx(D.DL.Path + D.DL.Names[Index], False);
        end;    
        ImgIdx := D.DL.Items[Index].dwReserved0; // Индекс иконки
      end;

    1: //== Column 2
      if Index < 0 then // "[..]"
        Txt := ''
      else if D.DL.IsDirectory[Index] then
        Txt := GetFileType(D.DL.Path + D.DL.Names[Index])
      else
        Txt := Num2Bytes(Int64_2Double(MakeInt64(D.DL.Items[Index].nFileSizeLow,
          D.DL.Items[Index].nFileSizeHigh)));

    2: //== Column 3
      if Index < 0 then // "[..]"
        Txt := ''
      else begin
        FileTimeToLocalFileTime(D.DL.Items[Index].ftLastWriteTime,
        D.DL.Items[Index].ftCreationTime);
        FileTimeToSystemTime(D.DL.Items[Index].ftCreationTime, ST);
        Txt := SystemDate2Str(ST, LOCALE_USER_DEFAULT, dfLongDate, 'dd.MM.yy') +
          SystemTime2Str(ST, LOCALE_USER_DEFAULT, [], ' HH:mm');
      end;
  end; // case

  Store := False;
end;

(* Событие NewOnLLVStateChange *)

procedure TBAPFileBrowser.NewOnLVStateChange;
var
  Idx: Integer;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  if LVCurItem < 0 then
    Exit;

  Idx := LVCurItem - D.FIdx;
  if Assigned(D.OnSelFile) then
    if Idx < 0 then
      D.OnSelFile(@Self, '[..]', True, nil)
    else
      D.OnSelFile(@Self, D.DL.Names[Idx], D.DL.IsDirectory[Idx], D.DL.Items[Idx]);
end;

(* Обработчик объекта *)

function WndProcFile(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  RunFile: Boolean;
  Idx, FRslt: Integer;
  D: PCtlObj;
  LV: PNMLISTVIEW;
begin
  Result := False;

  case Msg.message of
    WM_KEYDOWN:
      case Msg.wParam of
        220: // "\"
          if GetKeyState(VK_CONTROL) < 0 then
            PBAPFileBrowser(Ctl)^.RootDir;

        VK_RETURN:
          begin
            D := Pointer(Ctl.CustomObj);
            Idx := Ctl.LVCurItem - D.FIdx;
            RunFile := True;
            if Idx < 0 then
              RunFile := False
            else if D.DL.IsDirectory[Idx] then
              RunFile := False;

            if RunFile then
            begin
              if Assigned(D.OnBeforeExecute) then
                D.OnBeforeExecute(Ctl, D.DL.Names[Idx], RunFile);
              if RunFile then
              begin
                FRslt := ShellExecute(0, nil, PChar(D.DL.Path + D.DL.Names[Idx]),
                  nil, nil, SW_SHOW);
                if Assigned(D.OnExecute) then
                  D.OnExecute(@Ctl, D.DL.Names[Idx], FRslt);
              end;
            end else
              ReadDir(Ctl, GetNewPath(Ctl));
          end;

        VK_BACK: PBAPFileBrowser(Ctl)^.LevelUp;
      end;

    WM_NOTIFY:
    begin
      LV := Pointer(Msg.lParam);
      if LV.hdr.code = NM_DBLCLK then
        Ctl.Perform(WM_KEYDOWN, VK_RETURN, 0);
    end;
  end; // case
end;

(* Создание объекта *)

function NewBAPFileBrowser;
var
  D: PCtlObj;
begin
  New(D, Create);
  D.IL16 := NewImageList(nil);
  D.IL32 := NewImageList(nil);
  D.IL16.LoadSystemIcons(True);
  D.IL32.LoadSystemIcons(False);

  Result := PBAPFileBrowser(NewListView(Sender, Style,
    [lvoOwnerData, lvoRowSelect, lvoMultiSelect], D.IL16, D.IL32, nil));

  Result.CustomObj := D;
  D.FControl := Result;

  D.FileFilter := FileFilter;
  D.FileSort := FileSort;
  D.ShowOnlyFiles := ShowOnlyFiles;
  D.ShowUpDir := ShowUpDir;

  D.DL := NewDirListEx('', '', 0);
  Result.LVColInsert(0, '', taLeft, 0);
  Result.SetColumns(Columns);

  //== Установка обработчиков
  Result.SetOnLVStateChange(Result.NewOnLVStateChange);
  Result.SetOnLVData(Result.NewOnLVData);
  Result.AttachProc(WndProcFile);
end;

(* DirChange *)

procedure TBAPFileBrowser.DirChange;
var
  Flag: Boolean;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  Flag := True;
  if Assigned(D.OnDirNotify) then
    D.OnDirNotify(@Self, Flag);
  if Flag then
    ReadDir(@Self, D.DL.Path);
end;

(* GetSelFiles *)

procedure TBAPFileBrowser.GetSelFiles;
var
  Idx, x: Integer;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  Idx := LVNextSelected(-1); // Превый выделенный элемент
  x := Idx;

  while x >= 0 do // Следующие выделенные элементы
  begin
    if (LVItems[LVCurItem, x] <> '[..]') and
       (Assigned(D.OnGetSelFiles)) then
      D.OnGetSelFiles(@Self, D.DL.Names[x - D.FIdx],
        D.DL.IsDirectory[x - D.FIdx], D.DL.Items[x - D.FIdx]);

    if NotSelect then
      LVItemState[x] := [];
    x := LVNextSelected(x);
    if x > 0 then
      Idx := x;
  end;

  if NotSelect then
    LVCurItem := Idx;
end;

(* LevelUp *)

procedure TBAPFileBrowser.LevelUp;
begin
  with PCtlObj(CustomObj)^.DL^ do
    if Length(Path) > 3 then
      ReadDir(@Self, GetParentDir(@Self, Path));
end;

(* Refresh *)

procedure TBAPFileBrowser.Refresh;
begin
  ReadDir(@Self, PCtlObj(CustomObj)^.DL.Path);
end;

(* RootDir *)

procedure TBAPFileBrowser.RootDir;
var
  st: string;
begin
  st := PCtlObj(CustomObj)^.DL.Path;
  if Length(st) < 4 then
    Exit;
  SetLength(st, 3);
  ReadDir(@Self, st);
end;

(* ColDateIdx, ColSizeIdx *)

function TBAPFileBrowser.GetColDateIdx;
begin
  Result := PCtlObj(CustomObj)^.ColDateIdx;
end;

function TBAPFileBrowser.GetColSizeIdx;
begin
  Result := PCtlObj(CustomObj)^.ColSizeIdx;
end;

(* Columns *)

procedure TBAPFileBrowser.SetColumns;
var
  Idx: Integer;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  D.Columns := Value;
  Idx := 1;

  if fbcSize in D.Columns then
  begin
    if D.ColSizeIdx <= 0 then
      LVColInsert(1, '', taRight, 0);
    D.ColSizeIdx := 1;
    Idx := 2;
  end else
  begin
    LVColDelete(D.ColSizeIdx);
    D.ColSizeIdx := -1;
  end;

  if fbcDate in D.Columns then
  begin
    if D.ColDateIdx <= 0 then
      LVColInsert(Idx, '', taLeft, 0);
    D.ColDateIdx := Idx;
  end else
  begin
    LVColDelete(D.ColDateIdx);
    D.ColDateIdx := -1;
  end;
end;

function TBAPFileBrowser.GetColumns;
begin
  Result := PCtlObj(CustomObj)^.Columns;
end;

(* Directory *)

procedure TBAPFileBrowser.SetDirectory;
begin
  if Value = '*' then
    Value := UpperCase(GetStartDir);
  ReadDir(@Self, Value);
end;

function TBAPFileBrowser.GetDirectory;
begin
  Result := PCtlObj(CustomObj)^.DL.Path;
end;

(* FileAttr *)

function TBAPFileBrowser.GetFileAttr;
begin
  with PCtlObj(CustomObj)^ do
  begin
    Idx := LVCurItem - FIdx;
    if Idx < 0 then
      Result := nil
    else
      Result := DL.Items[Idx];
  end;
end;

(* FileFilter *)

procedure TBAPFileBrowser.SetFileFilter;
begin
  PCtlObj(CustomObj)^.FileFilter := Value;
end;

function TBAPFileBrowser.GetFileFilter;
begin
  Result := PCtlObj(CustomObj)^.FileFilter;
end;

(* FileIcon *)

function TBAPFileBrowser.GetFileIcon;
begin
  with PCtlObj(CustomObj)^ do
  begin
    Idx := LVCurItem - FIdx;
    if Idx < 0 then
      Result := IcOF
    else
      if DL.Items[Idx].dwReserved1 = 1 then
        Result := DL.Items[Idx].dwReserved0
      else
        Result := FileIconSysIdx(DL.Path + DL.Names[Idx], False);
  end;
end;

(* FileSort *)

procedure TBAPFileBrowser.SetFileSort;
begin
  PCtlObj(CustomObj)^.FileSort := Value;
end;

function TBAPFileBrowser.GetFileSort;
begin
  Result := PCtlObj(CustomObj)^.FileSort;
end;

(* ShowOnlyFiles *)

procedure TBAPFileBrowser.SetShowOnlyFiles;
begin
  PCtlObj(CustomObj)^.ShowOnlyFiles := Value;
end;

function TBAPFileBrowser.GetShowOnlyFiles;
begin
  Result := PCtlObj(CustomObj)^.ShowOnlyFiles;
end;

(* ShowUpDir *)

procedure TBAPFileBrowser.SetShowUpDir;
begin
  PCtlObj(CustomObj)^.ShowUpDir := Value;
end;

function TBAPFileBrowser.GetShowUpDir;
begin
  Result := PCtlObj(CustomObj)^.ShowUpDir;
end;

(* OnBeforeExecute *)

procedure TBAPFileBrowser.SetOnBeforeExecute;
begin
  PCtlObj(CustomObj)^.OnBeforeExecute := Value;
end;

function TBAPFileBrowser.GetOnBeforeExecute;
begin
  Result := PCtlObj(CustomObj)^.OnBeforeExecute;
end;

(* OnChangeDir *)

procedure TBAPFileBrowser.SetOnChangeDir;
begin
  PCtlObj(CustomObj)^.OnChangeDir := Value;
end;

function TBAPFileBrowser.GetOnChangeDir;
begin
  Result := PCtlObj(CustomObj)^.OnChangeDir;
end;

(* OnDirNotify *)

procedure TBAPFileBrowser.SetOnDirNotify;
begin
  PCtlObj(CustomObj)^.OnDirNotify := Value;
end;

function TBAPFileBrowser.GetOnDirNotify;
begin
  Result := PCtlObj(CustomObj)^.OnDirNotify;
end;

(* OnExecute *)

procedure TBAPFileBrowser.SetOnExecute;
begin
  PCtlObj(CustomObj)^.OnExecute := Value;
end;

function TBAPFileBrowser.GetOnExecute;
begin
  Result := PCtlObj(CustomObj)^.OnExecute;
end;

(* OnGetSelFiles *)

procedure TBAPFileBrowser.SetOnGetSelFiles;
begin
  PCtlObj(CustomObj)^.OnGetSelFiles := Value;
end;

function TBAPFileBrowser.GetOnGetSelFiles;
begin
  Result := PCtlObj(CustomObj)^.OnGetSelFiles;
end;

(* OnSelFile *)

procedure TBAPFileBrowser.SetOnSelFile;
begin
  PCtlObj(CustomObj)^.OnSelFile := Value;
end;

function TBAPFileBrowser.GetOnSelFile;
begin
  Result := PCtlObj(CustomObj)^.OnSelFile;
end;

end.