unit mckBAPFileBrowser;

interface

uses
  Windows, Messages, Controls, Classes, mirror, mckCtrls, KOL, Graphics,
    KOLBAPFileBrowser;

type
  TKOLBAPFileBrowser = class(TKOLControl)
  private
    FNotAvailable: Boolean;
    FmckTextDate: string;
    FmckTextName: string;
    FmckTextSize: string;
    FmckWidthDate: Integer;
    FmckWidthName: Integer;
    FmckWidthSize: Integer;
    FColumns: TFBColumns;
    FDirectory: string;
    FFileFilter: string;
    FFileSort: TSortDirRules;
    FLVStyle: TListViewStyle;
    FLVTextBkColor: TColor;
    FpopupMenu: TKOLPopupMenu;
    FShowUpDir: Boolean;
    FShowOnlyFiles: Boolean;
    FOnBeforeExecute: TOnBeforeExecute;
    FOnChangeDir: TOnChangeDir;
    FOnDirNotify: TOnDirNotify;
    FOnExecute: TOnExecute;
    FOnGetSelFiles: TOnSelFile;
    FOnSelFile: TOnSelFile;
    procedure SetmckTextDate(const Value: string);
    procedure SetmckTextName(const Value: string);
    procedure SetmckTextSize(const Value: string);
    procedure SetmckWidthDate(const Value: Integer);
    procedure SetmckWidthName(const Value: Integer);
    procedure SetmckWidthSize(const Value: Integer);
    procedure SetColumns(const Value: TFBColumns);
    procedure SetDirectory(const Value: string);
    procedure SetFileFilter(Value: string);
    procedure SetFileSort(const Value: TSortDirRules);
    procedure SetLVStyle(const Value: TListViewStyle);
    procedure SetLVTextBkColor(const Value: TColor);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetShowOnlyFiles(const Value: Boolean);
    procedure SetShowUpDir(const Value: Boolean);
    procedure SetOnBeforeExecute(const Value: TOnBeforeExecute);
    procedure SetOnChangeDir(const Value: TOnChangeDir);
    procedure SetOnDirNotify(const Value: TOnDirNotify);
    procedure SetOnExecute(const Value: TOnExecute);
    procedure SetOnGetSelFiles(const Value: TOnSelFile);
    procedure SetOnSelFile(const Value: TOnSelFile);

  protected
    function AdditionalUnits: string; override;
    function TypeName: string; override;
    procedure FirstCreate; override;
    function SetupParams(const AName, AParent: string): string; override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: string); override;
    procedure AssignEvents(SL: TStringList; const AName: string); override;
    procedure CreateKOLControl(Recreating: Boolean); override; // Визуализация

  public
    constructor Create(Owner: TComponent); override;
    procedure SetParent(Value: TWinControl); override; // Визуализация

  published
    property mckTextDate: string read FmckTextDate write SetmckTextDate;
    property mckTextName: string read FmckTextName write SetmckTextName;
    property mckTextSize: string read FmckTextSize write SetmckTextSize;
    property mckWidthDate: Integer read FmckWidthDate write SetmckWidthDate;
    property mckWidthName: Integer read FmckWidthName write SetmckWidthName;
    property mckWidthSize: Integer read FmckWidthSize write SetmckWidthSize;
    property Columns: TFBColumns read FColumns write SetColumns;
    property Directory: string read FDirectory write SetDirectory;
    property FileFilter: string read FFileFilter write SetFileFilter;
    property FileSort: TSortDirRules read FFileSort write SetFileSort;
    property LVStyle: TListViewStyle read FLVStyle write SetLVStyle;
    property LVTextBkColor: TColor read FLVTextBkColor write SetLVTextBkColor;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property ShowOnlyFiles: Boolean read FShowOnlyFiles write SetShowOnlyFiles;
    property ShowUpDir: boolean read FShowUpDir write SetShowUpDir;
    property OnBeforeExecute: TOnBeforeExecute read FOnBeforeExecute write SetOnBeforeExecute;
    property OnChangeDir: TOnChangeDir read FOnChangeDir write SetOnChangeDir;
    property OnDirNotify: TOnDirNotify read FOnDirNotify write SetOnDirNotify;
    property OnExecute: TOnExecute read FOnExecute write SetOnExecute;
    property OnGetSelFiles: TOnSelFile read FOnGetSelFiles write SetOnGetSelFiles;
    property OnSelFile: TOnSelFile read FOnSelFile write SetOnSelFile;
    property Brush;
    property HasBorder;
    property TabStop;
    property Transparent;
    property OnChar;
    property OnEnter;
    property OnKeyDown;
    property OnKeyUp;
    property OnLeave;

    //== Скрытие свойств в <Инспекторе Объектов>
    property Caption: Boolean read FNotAvailable;
    property OnPaint: Boolean read FNotAvailable;
  end;

procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL Dialogs', [TKOLBAPFileBrowser]);
end;

(* Визуализация MCK *)

procedure TKOLBAPFileBrowser.CreateKOLControl(Recreating: boolean);
var
 st: string;
begin
  FKOLCtrl := PControl(NewBAPFileBrowser(KOLParentCtrl, FLVStyle, FColumns,
    FFileFilter, FFileSort, FShowOnlyFiles, FShowUpDir));

  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
    begin
      LVColWidth[0] := FmckWidthName;
      LVColWidth[1] := FmckWidthSize;
      LVColWidth[2] := FmckWidthDate;
      LVColText[0] := FmckTextName;
      LVColText[1] := FmckTextSize;
      LVColText[2] := FmckTextDate;
      GetDir(0, st);
      Directory := st;
    end;
end;

procedure TKOLBAPFileBrowser.SetParent(Value: TWinControl);
begin
  inherited;
  // Т.к. мы сами вырисовываем компонент, то необходимо вызвать RecreateWnd.
  if Assigned(Value) then
    RecreateWnd;
end;

(* Формирование объекта *)

function TKOLBAPFileBrowser.AdditionalUnits;
begin
  Result := ', KOLBAPFileBrowser';
end;

function TKOLBAPFileBrowser.TypeName;
begin
  Result := 'BAPFileBrowser';
end;

procedure TKOLBAPFileBrowser.FirstCreate;
begin
  inherited;
  TabStop := True;
  ParentColor := False;
  Brush.Color := Color;
end;

function TKOLBAPFileBrowser.SetupParams;
begin
  Result := AParent;
end;

procedure TKOLBAPFileBrowser.SetupConstruct;
const
  spc = ', ';
  Boolean2Str: array [Boolean] of string = ('False', 'True');

  ST: array [TListViewStyle] of string =
    ('lvsIcon', 'lvsSmallIcon', 'lvsList', 'lvsDetail', 'lvsDetailNoHeader');

  SS: array [TSortDirRules] of string =
    ('sdrNone', 'sdrFoldersFirst', 'sdrCaseSensitive',
    'sdrByName', 'sdrByExt', 'sdrBySize', 'sdrBySizeDescending',
    'sdrByDateCreate', 'sdrByDateChanged', 'sdrByDateAccessed');
var
  S: string;
begin
  S := '';
  if fbcSize in FColumns then
    S := 'fbcSize';

  if fbcDate in FColumns then
  begin
    if S <> '' then
      S := S + spc;
    S := S + 'fbcDate';
  end;

  SL.Add(Prefix + AName + ' := New' + TypeName + '(' + SetupParams(AName, AParent) +
    spc + ST[FLVStyle] + ', [' + S + '], ' + #39 + FileFilter + #39 + spc + SS[FFileSort] +
    spc + Boolean2Str[FShowOnlyFiles] + spc + Boolean2Str[FShowUpDir] + ');');

  S := GenerateTransparentInits;
  if S <> '' then
    SL.Add(Prefix + AName + S + ';');
end;

procedure TKOLBAPFileBrowser.SetupFirst;
var
  Idx: Integer;
begin
  inherited;

  if (Font.Color <> clWindowText) and (Font.Color <> clDefault) and
     (Font.Color <> clNone) then
     SL.Add(Prefix + AName + '.LVTextColor := ' + Color2Str(Font.Color) + ';');

  if (FLVTextBkColor <> clWindow) and (FLVTextBkColor <> clDefault) and
     (FLVTextBkColor <> clNone) then
    SL.Add(Prefix + AName + '.LVTextBkColor := ' + Color2Str(FLVTextBkColor) + ';');

  if Assigned(FpopupMenu) then
    SL.Add(Prefix + AName + '.SetAutoPopupMenu(Result.' + FpopupMenu.Name + ');');

  if FmckTextName <> '' then
    SL.Add(Prefix + AName + '.LVColText[0] := ''' + FmckTextName + ''';');
  SL.Add(Prefix + AName + '.LVColWidth[0] := ' + Int2Str(FmckWidthName) + ';');

  Idx := 1;
  if fbcSize in FColumns then
  begin
    Idx := 2;
    if FmckTextSize <> '' then
      SL.Add(Prefix + AName + '.LVColText[1] := ''' + FmckTextSize + ''';');
    SL.Add(Prefix + AName + '.LVColWidth[1] := ' + Int2Str(FmckWidthSize) + ';');
  end;

  if fbcDate in FColumns then
  begin
    if FmckTextSize <> '' then
      SL.Add(Prefix + AName + '.LVColText[' + Int2Str(Idx) + '] := ''' + FmckTextDate + ''';');
    SL.Add(Prefix + AName + '.LVColWidth[' + Int2Str(Idx) + '] := ' + Int2Str(FmckWidthDate) + ';');
  end;

  SL.Add(Prefix + AName + '.Directory := ''' + FDirectory + ''';');
end;

procedure TKOLBAPFileBrowser.AssignEvents;
begin
inherited;
  DoAssignEvents(SL, AName,
    ['OnBeforeExecute', 'OnChangeDir', 'OnDirNotify',
     'OnExecute', 'OnGetSelFiles', 'OnSelFile'],
    [@OnBeforeExecute, @OnChangeDir, @OnDirNotify,
     @OnExecute, @OnGetSelFiles, @OnSelFile]);
end;

(* MCK *)

constructor TKOLBAPFileBrowser.Create;
begin
  inherited;
  Width := 410;
  Height := 250;
  FmckTextDate := 'Date';
  FmckTextName := 'Name';
  FmckTextSize := 'Size';
  FmckWidthDate := 84;
  FmckWidthName := 202;
  FmckWidthSize := 102;
  FColumns := [fbcSize, fbcDate];
  FDirectory := '*';
  FFileFilter := '*.*';
  FFileSort := sdrByExt;
  FLVStyle := lvsDetail;
  FLVTextBkColor := clWindow;
  FShowOnlyFiles := False;
  FShowUpDir := True;
end;

(* Свойства только для MCK *)

procedure TKOLBAPFileBrowser.SetmckWidthDate;
begin
  FmckWidthDate := Value;
  Change;
  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
      LVColWidth[ColDateIdx] := FmckWidthDate;
end;

procedure TKOLBAPFileBrowser.SetmckWidthName;
begin
  FmckWidthName := Value;
  Change;
  if Assigned(FKOLCtrl) then
    PBAPFileBrowser(FKOLCtrl)^.LVColWidth[0] := FmckWidthName;
end;

procedure TKOLBAPFileBrowser.SetmckWidthSize;
begin
  FmckWidthSize := Value;
  Change;
  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
      LVColWidth[ColSizeIdx] := FmckWidthSize;
end;

procedure TKOLBAPFileBrowser.SetmckTextDate;
begin
  FmckTextDate := Value;
  Change;
  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
      LVColText[ColDateIdx] := FmckTextDate;
end;

procedure TKOLBAPFileBrowser.SetmckTextName;
begin
  FmckTextName := Value;
  Change;
  if Assigned(FKOLCtrl) then
    PBAPFileBrowser(FKOLCtrl)^.LVColText[0] := FmckTextName;
end;

procedure TKOLBAPFileBrowser.SetmckTextSize;
begin
  FmckTextSize := Value;
  Change;
  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
      LVColText[ColSizeIdx] := FmckTextSize;
end;

(* Свойства *)

procedure TKOLBAPFileBrowser.SetColumns;
begin
  FColumns := Value;
  Change;
  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
    begin
      Columns := Value;
      if fbcSize in FColumns then
      begin
        LVColText[ColSizeIdx] := FmckTextSize;
        LVColWidth[ColSizeIdx] := FmckWidthSize;
      end;

      if fbcDate in FColumns then
      begin
        LVColText[ColDateIdx] := FmckTextDate;
        LVColWidth[ColDateIdx] := FmckWidthDate;
      end;
    end;
end;

procedure TKOLBAPFileBrowser.SetDirectory;
var
  st: string;
begin
  if (Value <> '') and (Value[2] = ':') or (Value = '*') then
  begin
    if (Value[Length(Value)] <> '\') and (Value <> '*') then
    begin
      FDirectory := Value + '\';
      st := FDirectory;
    end else
    begin
      FDirectory := Value;
      GetDir(0, st);
    end;

    Change;
    if Assigned(FKOLCtrl) then
      PBAPFileBrowser(FKOLCtrl)^.Directory := st;
  end;
end;

procedure TKOLBAPFileBrowser.SetFileFilter;
begin
  if Value <> '' then
  begin
    FFileFilter := Value;
    Change;
    if Assigned(FKOLCtrl) then
      PBAPFileBrowser(FKOLCtrl)^.FileFilter := FFileFilter;
  end else
    Value := '*.*';
end;

procedure TKOLBAPFileBrowser.SetFileSort;
begin
  FFileSort := Value;
  Change;
  if Assigned(FKOLCtrl) then
    PBAPFileBrowser(FKOLCtrl)^.FileSort := FFileSort;
end;

procedure TKOLBAPFileBrowser.SetLVStyle;
begin
  FLVStyle := Value;
  Change;
  if Assigned(FKOLCtrl) then
    PBAPFileBrowser(FKOLCtrl)^.LVStyle := FLVStyle;
end;

procedure TKOLBAPFileBrowser.SetLVTextBkColor(const Value: TColor);
begin
  FLVTextBkColor := Value;
  Change;
  if Assigned(FKOLCtrl) then
    with PBAPFileBrowser(FKOLCtrl)^ do
    begin
      LVTextBkColor := Value;
      Invalidate;
    end;
end;

procedure TKOLBAPFileBrowser.SetpopupMenu;
begin
  FpopupMenu := Value;
  Change;
end;

procedure TKOLBAPFileBrowser.SetShowOnlyFiles;
begin
  FShowOnlyFiles := Value;
  Change;
  if Assigned(FKOLCtrl) then
    PBAPFileBrowser(FKOLCtrl)^.ShowOnlyFiles := FShowOnlyFiles;
end;

procedure TKOLBAPFileBrowser.SetShowUpDir;
begin
  FShowUpDir := Value;
  Change;
  if Assigned(FKOLCtrl) then
    PBAPFileBrowser(FKOLCtrl)^.ShowUpDir := FShowUpDir;
end;

(* События *)

procedure TKOLBAPFileBrowser.SetOnBeforeExecute;
begin
  FOnBeforeExecute := Value;
  Change;
end;

procedure TKOLBAPFileBrowser.SetOnChangeDir;
begin
  FOnChangeDir := Value;
  Change;
end;

procedure TKOLBAPFileBrowser.SetOnDirNotify;
begin
  FOnDirNotify := Value;
  Change;
end;

procedure TKOLBAPFileBrowser.SetOnExecute;
begin
  FOnExecute := Value;
  Change;
end;

procedure TKOLBAPFileBrowser.SetOnGetSelFiles;
begin
  FOnGetSelFiles := Value;
  Change;
end;

procedure TKOLBAPFileBrowser.SetOnSelFile;
begin
  FOnSelFile := Value;
  Change;
end;

end.