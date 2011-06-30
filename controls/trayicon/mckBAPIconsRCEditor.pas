unit mckBAPIconsRCEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ImgList, Menus;

type
  TIconsREForm = class(TForm)
    BmpIL: TImageList;
    mMain: TMainMenu;
    mFile: TMenuItem;
    mOpen: TMenuItem;
    mSep1: TMenuItem;
    mSave: TMenuItem;
    mSaveAs: TMenuItem;
    mSep2: TMenuItem;
    mCreateRES: TMenuItem;
    mSep3: TMenuItem;
    mExit: TMenuItem;
    pmListView: TPopupMenu;
    pmAddIcon: TMenuItem;
    pmDelIcon: TMenuItem;
    pmSep1: TMenuItem;
    pmDelLinks: TMenuItem;
    pmSep2: TMenuItem;
    pmClearList: TMenuItem;
    pmSep3: TMenuItem;
    pmOpen: TMenuItem;
    pmSave: TMenuItem;
    pmSaveAs: TMenuItem;
    mClose: TMenuItem;
    pmClose: TMenuItem;
    pmSep4: TMenuItem;
    pmCreateRES: TMenuItem;
    ListView1: TListView;
    ImageList1: TImageList;
    OpenDialogICO: TOpenDialog;
    OpenDialogRC: TOpenDialog;
    SaveDialogRC: TSaveDialog;
    bCreateRes: TButton;
    bUp: TButton;
    bDown: TButton;
    bExit: TButton;
    GroupBox1: TGroupBox;
    bAddIcon: TButton;
    bDelIcon: TButton;
    GroupBox2: TGroupBox;
    bDelLinks: TButton;
    bClearList: TButton;
    procedure bAddIconClick(Sender: TObject);
    procedure bDelIconClick(Sender: TObject);
    procedure bClearListClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bDelLinksClick(Sender: TObject);
    procedure mOpenClick(Sender: TObject);
    procedure mSaveAsClick(Sender: TObject);
    procedure mSaveClick(Sender: TObject);
    procedure mCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bUpClick(Sender: TObject);
    procedure bDownClick(Sender: TObject);
    procedure mCreateRESClick(Sender: TObject);
    procedure mExitClick(Sender: TObject);

  private
    ListModify: Boolean;
    RCFileName: string;
    function IsListModify: Integer;
    procedure ShowMesErr(Text, FileName: string);
    procedure SetBtnEnabled;
    procedure LVAddRow(Col1, Col2: string);
    procedure ReplaceLVRow(BtnUp: Boolean);
    procedure SetIconsIdx;

  public
    RESPath: string;
  end;

var
  IconsREForm: TIconsREForm;

implementation

{$R *.DFM}

const
  cICON = #32 + 'ICON' + #32;

(* Запуск и ожидание окончания процесса *)

function ExecuteWait(const AppPath, CmdLine, DfltDirectory: string;
  Show: DWORD; TimeOut: DWORD; ProcID: PDWORD): Boolean;
var
  Flags: DWORD;
  Startup: TStartupInfo;
  ProcInf: TProcessInformation;
  DfltDir: PChar;
  App: string;
begin
  Result := False;
  Flags := CREATE_NEW_CONSOLE;
  if Show = SW_HIDE then
    Flags := Flags or CREATE_NO_WINDOW;
  FillChar(Startup, SizeOf(Startup), 0);
  Startup.cb := SizeOf(Startup);
  Startup.wShowWindow := Show;
  Startup.dwFlags := STARTF_USESHOWWINDOW;
  if ProcID <> nil then
    ProcID^ := 0;
  DfltDir := nil;
  if DfltDirectory <> '' then
    DfltDir := PChar(DfltDirectory);
  if ProcID <> nil then
    ProcID^ := 0;
  App := AppPath;
  if (pos(#32, App ) > 0) and (pos('"', App) <= 0) then
    App := '"' + App + '"';
  if CreateProcess(nil, PChar(App + #32 + CmdLine), nil, nil, False, Flags,
       nil, DfltDir, Startup, ProcInf) then
  begin
    if WaitForSingleObject(ProcInf.hProcess, TimeOut) = WAIT_OBJECT_0 then
    begin
      CloseHandle(ProcInf.hProcess);
      Result := True;
    end else if ProcID <> nil then
      ProcID^ := ProcInf.hProcess;
    CloseHandle(ProcInf.hThread);
  end;
end;

(* Проверка изменения списка *)

function TIconsREForm.IsListModify;
var
  st: string;
begin
  if ListModify then
  begin
    if RCFileName = '' then
      st := 'file'
    else
      st := '"' + ExtractFileName(RCFileName) + '"';
    Result := MessageBox(Handle, PChar('Save changes to ' + st + '?'),
      'Confirm', MB_ICONQUESTION or MB_YESNOCANCEL)
  end else
    Result := -1;
end;

procedure TIconsREForm.ShowMesErr;
begin
  MessageBox(Handle, PChar('Can not ' + Text + ' file "' +
    ExtractFileName(FileName) + '".'), 'Error', MB_ICONSTOP);
end;

(* Добавить строку в ListView *)

procedure TIconsREForm.LVAddRow;
var
  Idx: Integer;
  Icon: TIcon;
begin
  Icon := TIcon.Create;
  if FileExists(Col2) then
  begin
    Icon.LoadFromFile(Col2);
    Idx := ImageList1.AddIcon(Icon);
  end else
    Idx := -1;
  Icon.Free;

  with ListView1 do
  begin
    Items.Add; // Добавить строку
    Items[Items.Count - 1].Caption := Col1; // Добавить значение в 1'ый столбец
    Items[Items.Count - 1].SubItems.Add(Col2); // Добавить -//- во 2'ой столбец
    Items[Items.Count - 1].ImageIndex := Idx;  // Добавить иконку
  end;
end;

(* Перемещение элемента по списку *)

procedure TIconsREForm.ReplaceLVRow;
var
 Idx, ImgIdx: Integer;
 st1, st2: string;
begin
  with ListView1 do
  begin
    if Selected = nil then
      Exit;
    if BtnUp then
      if Selected.Index = 0 then
        Exit
      else // UP
        Idx := -1
    else if Selected.Index = Items.Count - 1 then
      Exit
    else   // DOWN
      Idx := 1;

    // Запоминаем текущие значения
    st1 := Selected.Caption;
    st2 := Selected.SubItems[0];
    ImgIdx := Selected.ImageIndex;

    // Меняем строки местами
    Selected.Caption := Items[Selected.Index + Idx].Caption;
    Selected.SubItems[0] := Items[Selected.Index + Idx].SubItems[0];
    Selected.ImageIndex :=  Items[Selected.Index + Idx].ImageIndex;

    Items[Selected.Index + Idx].Caption := st1;
    Items[Selected.Index + Idx].SubItems[0] := st2;
    Items[Selected.Index + Idx].ImageIndex := ImgIdx;

    // Делаем новый элемент выделенным и передаем ему фокус, а старый нет
    if BtnUp then
    begin // UP
      Items[Selected.Index - 1].Focused := True;
      Items[Selected.Index - 1].Selected := True;
      Items[Selected.Index + 1].Focused := False;
      Items[Selected.Index + 1].Selected := False;
    end else
    begin // DOWN
      Items[Selected.Index + 1].Focused := True;
      Items[Selected.Index + 1].Selected := True;
      Items[Selected.Index].Focused := False;
      Items[Selected.Index].Selected := False;
    end;
  end;
  ListModify := True;
end;

(* Установить индексы иконок *)

procedure TIconsREForm.SetIconsIdx;
var
  Idx, ic: Integer;
  Icon: TIcon;
begin
  Icon := TIcon.Create;
  with ListView1 do
  begin
    for Idx := 0 to Items.Count - 1 do
    begin
      if FileExists(Items[Idx].SubItems[0]) then
      begin
        Icon.LoadFromFile(Items[Idx].SubItems[0]);
        ic := ImageList1.AddIcon(Icon);
      end else
        ic := -1;
      Items[Idx].ImageIndex := ic;
    end;
  end;
  Icon.Free;
end;

(* Доступность кнопок *)

procedure TIconsREForm.SetBtnEnabled;
var
  Flag: Boolean;
  x: Integer;
begin
  Flag := False;
  if ListView1.Items.Count > 0 then
    Flag := True;
  bDelIcon.Enabled := Flag;
  bDelLinks.Enabled := Flag;
  bClearList.Enabled := Flag;
  bCreateRes.Enabled := Flag;
  bUp.Enabled := Flag;
  bDown.Enabled := Flag;
  if ListModify then
  begin
    mCreateRES.Enabled := Flag;
    pmCreateRES.Enabled := Flag;
    for x := 1 to 5 do
      pmListView.Items[x].Enabled := Flag;
  end else
  begin
    for x := 2 to 6 do
      mFile.Items[x].Enabled := Flag;
    for x := 1 to 5 do
      pmListView.Items[x].Enabled := Flag;
    for x := 8 to 12 do
      pmListView.Items[x].Enabled := Flag;
  end;
end;

(* Очистить список *)

procedure TIconsREForm.bClearListClick(Sender: TObject);
begin
  ListView1.Items.Clear;
  ImageList1.Clear;
  ListModify := True;
  SetBtnEnabled;
end;

(* Закрыть файл *)

procedure TIconsREForm.mCloseClick(Sender: TObject);
begin
  case IsListModify of
    IDYES: mSaveClick(Self);
    IDCANCEl: Exit;
  end;
  ListView1.Items.Clear;
  ImageList1.Clear;
  RCFileName := '';
  ListModify := False;
  SetBtnEnabled;
end;

(* Удалить иконку из списка *)

procedure TIconsREForm.bDelIconClick(Sender: TObject);
var
  NeedUpd: Boolean;
  x: Integer;
  LVItem: TListItem;
begin
  NeedUpd := False;

  with ListView1 do
  begin
    if Selected <> nil then
    begin
      Items.BeginUpdate;

      for x := 1 to SelCount do
      begin // Создаем список с выбранными элементами
        LVItem := GetNextItem(nil, sdAll, [isSelected]);
        if (Items[LVItem.Index].ImageIndex > -1) and
           (LVItem.Index < Items.Count - 1) then
          NeedUpd := True;
        if LVItem.Index = Items.Count - 1 then
          ImageList1.Delete(ImageList1.Count - 1); // Последний элемент
        Items[LVItem.Index].Delete; // LVItem.Index = -1
      end;

      if NeedUpd then
        SetIconsIdx;
      ListModify := True;
      Items.EndUpdate;
      if Items.Count = 0 then
        SetBtnEnabled;
    end;
  end;
end;

(* Удалить плохие ссылки *)

procedure TIconsREForm.bDelLinksClick(Sender: TObject);
var
  Idx: Integer;
begin
  with ListView1 do
  begin
    Items.BeginUpdate;
    for Idx := Items.Count - 1 downto 0 do
      if Items[Idx].ImageIndex < 0 then
      begin
        Items[Idx].Delete;
        ListModify := True;
      end;
    Items.EndUpdate;
  end;
  SetBtnEnabled;
end;

(* Добавить иконку в список *)

procedure TIconsREForm.bAddIconClick(Sender: TObject);
var
  Idx, x: Integer;
  st: string;
begin
  if not OpenDialogICO.Execute then
    Exit;

  for Idx := 0 to OpenDialogICO.Files.Count - 1 do
  begin // Создаем имя ресурса
    st := ExtractFileName(OpenDialogICO.Files.Strings[Idx]);
    x := Pos('.', st);
    if x > 0 then
      SetLength(st, x - 1);
    LVAddRow(st, OpenDialogICO.Files.Strings[Idx]);
  end;

  ListModify := True;
  SetBtnEnabled;
end;

(* Открыть файл *)

procedure TIconsREForm.mOpenClick(Sender: TObject);
var
  x, y: integer;
  TF: TextFile;
  st1, st2: string;
begin
  case IsListModify of
    IDYES: mSaveClick(Self); // Список изменен
    IDCANCEl: Exit;
  end;

  if not OpenDialogRC.Execute then
    Exit;

  ListView1.Items.BeginUpdate;
  try
    AssignFile(TF, OpenDialogRC.FileName);
    Reset(TF);
    bClearListClick(Sender); // Очистить список

    while not Eof(TF) do
    begin
      ReadLn(TF, st1);
      st1 := Trim(st1);
      y := Pos(cICON, UpperCase(st1));
      if y = 0 then
        Continue; // Если нет " ICON ", то читаем следующую строку

      x := Pos(';', st1);
      if (x > 0) and (x < y) then
        Continue; // Комментарий

      x := Pos(#32, st1);
      st2 := Copy(st1, 1, x - 1); // Копируем до SPACE'а
      x := Pos('"', st1);
      if x = 0 then
        Continue; // Если нет '"', то читаем следующую строку
      Delete(st1, 1, x);

      y := Pos('"', st1);
      if y = 0 then
        Continue; // Если нет '"', то читаем следующую строку
      SetLength(st1, y - 1);

      if (st1 <> '') and (st1[2] <> ':') then
        st1 := ExtractFilePath(OpenDialogRC.FileName) + st1;
      LVAddRow(st2, st1);
    end;

    ListModify := False;
    RCFileName := OpenDialogRC.FileName;
    if ListView1.Items.Count > 0 then // Устанавливем 1'ый элемет выделенным
    begin
      ListView1.Items[0].Selected := True;
      ListView1.SetFocus;
    end;
  except
    ShowMesErr('open', OpenDialogRC.FileName);
  end;
  CloseFile(TF);
  ListView1.Items.EndUpdate;
  SetBtnEnabled;
end;

(* Сохранить файл *)

procedure TIconsREForm.mSaveClick(Sender: TObject);
var
  x: Integer;
  TF: TextFile;
  Path, st: string;
begin
  if RCFileName = '' then
  begin // Не указано имя файла
    mSaveAsClick(Sender);
    Exit;
  end;

  try
    AssignFile(TF, RCFileName);
    Rewrite(TF);
    Path := ExtractFilePath(RCFileName);
    for x := 0 to ListView1.Items.Count - 1 do
    begin
      // Если каталог файла иконки совпадает с каталогом файла ресурса, то
      // записываем ТОЛЬКО ИМЯ файла иконки.
      st := ListView1.Items[x].SubItems[0];
      if ExtractFilePath(st) = Path then
        st := ExtractFileName(st);
      WriteLn(TF, ListView1.Items[x].Caption + cICON + '"' + st + '"');
    end;
    Flush(TF);
    ListModify := False;
  except
    ShowMesErr('save', RCFileName);
  end;
  CloseFile(TF);
end;

(* Сохранить файл как... *)

procedure TIconsREForm.mSaveAsClick(Sender: TObject);
begin
  if not SaveDialogRC.Execute then
    Exit;
  RCFileName := SaveDialogRC.FileName;
  mSaveClick(Self);
end;

(* Создать RES файл *)

procedure TIconsREForm.mCreateRESClick(Sender: TObject);
var
  x: Integer;
  st: string;
begin
  if RCFileName = '' then
  begin
    mSaveAsClick(Self);
    if RCFileName = '' then
      Exit;
  end;

  case IsListModify of
    IDYES: mSaveClick(Self);
    IDCANCEl: Exit;
  end;

  if ListModify then
    Exit;
    
  ExecuteWait('brcc32.exe', RCFileName, '', SW_HIDE, INFINITE, nil);

  st := ExtractFileName(RCFileName);
  x := Pos('.', st);
  if x <> 0 then
    SetLength(st, x);
  st := st + 'res';
  if FileExists(st) then
  begin
    MoveFileEx(PChar(st), PChar(RESPath + st), MOVEFILE_REPLACE_EXISTING);
    MessageBox(0, PChar('The file "' + ExtractFileName(st) +
      '" is created.'), 'RES file', MB_ICONINFORMATION);
  end else
    ShowMesErr('create', st);
end;

(* Закрытие формы *)

procedure TIconsREForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  case IsListModify of
    IDYES:
      begin
        mSaveClick(Self);
        if RCFileName = '' then
          CanClose := False;
      end;
    IDCANCEl: CanClose := False;
  end;
end;

procedure TIconsREForm.mExitClick(Sender: TObject);
begin
  Close;
end;

(* Двойной щелчок мыши / Редактирование строки *)

procedure TIconsREForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ListView1.Selected.EditCaption;
end;

(* Нажатие на клавишу *)

procedure TIconsREForm.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2, VK_SPACE: ListView1DblClick(Self);
    VK_DELETE: bDelIconClick(Self);
  end;
  ListModify := True;
end;

(* Перемещение иконки по списку *)

procedure TIconsREForm.bUpClick(Sender: TObject);
begin
  ReplaceLVRow(True);
end;

procedure TIconsREForm.bDownClick(Sender: TObject);
begin
  ReplaceLVRow(False);
end;

end.