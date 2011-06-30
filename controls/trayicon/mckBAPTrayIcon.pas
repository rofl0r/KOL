unit mckBAPTrayIcon;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, KOL, mirror, mckCtrls, Classes, Controls, Graphics,
    KOLBAPTrayIcon, mckBAPIconsRCEditor, Forms, Dialogs,
  {$IFDEF _D6orHigher}
    DesignIntf, DesignEditors, DesignConst, Variants;
  {$ELSE}
    DsgnIntf;
  {$ENDIF}

type
  TKOLBAPTrayIcon = class(TKOLObj)
  private
    FmckResFile: string;
    FmckResIcon: string;
    FActive: Boolean;
    FHideBallOnTimer: Boolean;
    FPopupMenu: TKOLPopupMenu;
    FToolTip: string;
    FOnBalloonShow: TOnEvent;
    FOnBalloonHide: TOnEvent;
    FOnBalloonClick: TOnEvent;
    FOnBalloonTimeOut: TOnEvent;
    FOnMouseDblClk: TOnMouse;
    FOnMouseDown: TOnMouse;
    FOnMouseMove: TOnMouse;
    FOnMouseUp: TOnMouse;
    procedure SetmckResFile(const Value: string);
    procedure SetmckResIcon(const Value: string);
    procedure SetActive(const Value: Boolean);
    procedure SetHideBallOnTimer(const Value: Boolean);
    procedure SetPopupMenu(const Value: TKOLPopupMenu);
    procedure SetToolTip(const Value: string);
    procedure SetOnBalloonShow(const Value: TOnEvent);
    procedure SetOnBalloonHide(const Value: TOnEvent);
    procedure SetOnBalloonClick(const Value: TOnEvent);
    procedure SetOnBalloonTimeOut(const Value: TOnEvent);
    procedure SetOnMouseDblClk(const Value: TOnMouse);
    procedure SetOnMouseDown(const Value: TOnMouse);
    procedure SetOnMouseMove(const Value: TOnMouse);
    procedure SetOnMouseUp(const Value: TOnMouse);

  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: string); override;
    procedure AssignEvents(SL: TStringList; const AName: string); override;

  public
    constructor Create(Owner: TComponent); override;

  published
    property mckResFile: string read FmckResFile write SetmckResFile;
    property mckResIcon: string read FmckResIcon write SetmckResIcon;
    property Active: Boolean read FActive write SetActive;
    property HideBallOnTimer: Boolean read FHideBallOnTimer write SetHideBallOnTimer;
    property PopupMenu: TKOLPopupMenu read FPopupMenu write SetPopupMenu;
    property ToolTip: string read FToolTip write SetToolTip;
    property OnBalloonShow: TOnEvent read FOnBalloonShow write SetOnBalloonShow;
    property OnBalloonHide: TOnEvent read FOnBalloonHide write SetOnBalloonHide;
    property OnBalloonClick: TOnEvent read FOnBalloonClick write SetOnBalloonClick;
    property OnBalloonTimeOut: TOnEvent read FOnBalloonTimeOut write SetOnBalloonTimeOut;
    property OnMouseDblClk: TOnMouse read FOnMouseDblClk write SetOnMouseDblClk;
    property OnMouseDown: TOnMouse read FOnMouseDown write SetOnMouseDown;
    property OnMouseMove: TOnMouse read FOnMouseMove write SetOnMouseMove;
    property OnMouseUp: TOnMouse read FOnMouseUp write SetOnMouseUp;
    property Localizy;
  end;

  (* ComponentEditor *)

  TBAPTrayIconEditor = class(TComponentEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
  end;

  (* StringProperty *)

  TBAPTrayIconProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;


procedure Register;

{$R *.dcr}

implementation

const
  cBAPTI = 'BAPTrayIcon v1.05';
var
  FPath: string;

procedure Register;
begin
  RegisterComponents('KOL System', [TKOLBAPTrayIcon]);
  RegisterComponentEditor(TKOLBAPTrayIcon, TBAPTrayIconEditor);
  RegisterPropertyEditor(TypeInfo(string), TKOLBAPTrayIcon, 'mckResFile',
    TBAPTrayIconProperty);
end;

(* ComponentEditor *)

function TBAPTrayIconEditor.GetVerbCount;
begin
  Result := 2; // Количество элементов в меню
end;

function TBAPTrayIconEditor.GetVerb;
begin
  case Index of
    0: Result := 'Resource file creation';
    1: Result := '&About ...';
  end;
end;

procedure TBAPTrayIconEditor.ExecuteVerb;
begin
  case Index of
    0: Edit;
    1: MessageBox(0, cBAPTI, PChar(Component.Name), MB_ICONINFORMATION);
  end;
end;

procedure TBAPTrayIconEditor.Edit;
begin
  IconsREForm := TIconsREForm.Create(nil);
  IconsREForm.RESPath := FPath;
  IconsREForm.ShowModal;
  IconsREForm.Free;
end;

(* StringProperty *)

function TBAPTrayIconProperty.GetAttributes;
begin
  Result := [paDialog];
end;

function TBAPTrayIconProperty.GetValue;
begin
  Result := GetStrValue;
end;

procedure TBAPTrayIconProperty.SetValue;
begin
  SetStrValue(Trim(Value));
end;

procedure TBAPTrayIconProperty.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  with OpenDialog do
  begin
    InitialDir := FPath;
    Filter := '*.res|*.res';
    Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
    if Execute then
    begin
      if LowerCase(ExtractFilePath(FileName)) <> LowerCase(FPath) then
        CopyFile(PChar(FileName), PChar(FPath + ExtractFileName(FileName)),
          False);
      SetStrValue(ExtractFileName(FileName));
    end;
    Free;
  end;
end;

(* Формирование объекта *)

function TKOLBAPTrayIcon.AdditionalUnits;
begin
  Result := ', KOLBAPTrayIcon';
end;

procedure TKOLBAPTrayIcon.SetupFirst;
begin
  if FmckResFile <> '' then
    SL.Add('{$R ' + FmckResFile + '}');

  SL.Add(Prefix + AName + ' := NewBAPTrayIcon(Applet);');

  if FHideBallOnTimer then
    SL.Add(Prefix + AName + '.HideBallOnTimer := True;');
  if Assigned(FPopupMenu) then
    SL.Add(Prefix + AName + '.PopupMenu := Result.' + FPopupMenu.Name + '.Handle;');
  if FToolTip <> '' then
    SL.Add(Prefix + AName + '.ToolTip := ' + StringConstant('Tooltip', FTooltip) + ';');
  if FmckResIcon <> '' then
    SL.Add(Prefix + AName + '.LoadTrayIcon(' + PCharStringConstant(Self, 'mckResIcon', FmckResIcon) + ');');
  if FActive then
    SL.Add(Prefix + AName + '.Active := True;');

  GenerateTag(SL, AName, Prefix);
end;

procedure TKOLBAPTrayIcon.AssignEvents;
begin
  inherited;
  DoAssignEvents(SL, AName,
    ['OnBalloonShow', 'OnBalloonHide', 'OnBalloonTimeOut', 'OnBalloonClick'],
    [@OnBalloonShow,  @OnBalloonHide,  @OnBalloonTimeOut,  @OnBalloonClick]);

  DoAssignEvents(SL, AName,
    ['OnMouseDblClk', 'OnMouseDown', 'OnMouseMove',  'OnMouseUp'],
    [@OnMouseDblClk, @OnMouseDown, @OnMouseMove, @OnMouseUp]);
end;

(* MCK *)

constructor TKOLBAPTrayIcon.Create;
begin
  inherited;
  GetDir(0, FPath);
  FPath := FPath + '\';
end;

(* Свойства только для MCK *)

procedure TKOLBAPTrayIcon.SetmckResFile;
var
  Idx: Integer;
begin
  if Value = '' then
  begin
    FmckResFile := '';
    Change;
    Exit;
  end;

  //== Проверка на совпадение ресурсов
  for Idx := 0 to Owner.ComponentCount - 1 do
    if (Owner.Components[Idx] is TKOLBAPTrayIcon) then
      if Value = (Owner.Components[Idx] as TKOLBAPTrayIcon).mckResFile then
      begin
        MessageBox(0, PChar('The "' + Value + '" is already used in "' +
          Owner.Components[Idx].Name + '"'), cBAPTI, MB_ICONSTOP);
        Exit;
      end;

  FmckResFile := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetmckResIcon;
begin
  FmckResIcon := Trim(Value);
  Change;
end;

(* Свойства *)

procedure TKOLBAPTrayIcon.SetActive;
begin
  FActive := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetHideBallOnTimer;
begin
  FHideBallOnTimer := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetPopupMenu;
begin
  FPopupMenu := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetToolTip;
begin
  FToolTip := Value;
  Change;
end;

(* События *)

procedure TKOLBAPTrayIcon.SetOnBalloonShow;
begin
  FOnBalloonShow := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnBalloonHide;
begin
  FOnBalloonHide := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnBalloonClick;
begin
  FOnBalloonClick := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnBalloonTimeOut;
begin
  FOnBalloonTimeOut := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnMouseDblClk;
begin
  FOnMouseDblClk := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnMouseDown;
begin
  FOnMouseDown := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnMouseMove;
begin
  FOnMouseMove := Value;
  Change;
end;

procedure TKOLBAPTrayIcon.SetOnMouseUp;
begin
  FOnMouseUp := Value;
  Change;
end;

end.