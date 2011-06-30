unit mckBAPDriveBox;

interface

uses
  Windows, Messages, Classes, Controls, mirror, mckCtrls, KOL, Graphics,
    KOLBAPDriveBox;

type
  TKOLBAPDriveBox = class(TKOLComboBox)
  private
    FNotAvailable: Boolean;
    FDrive: string;
    FLightIcon: Boolean;
    FSelBackColor: TColor;
    FSelTextColor: TColor;
    FOnChangeDrive: TOnChangeDrive;
    FOnChangeDriveLabel: TOnChangeDriveLabel;
    procedure SetDrive(Value: string);
    procedure SetLightIcon(const Value: Boolean);
    procedure SetSelBackColor(const Value: TColor);
    procedure SetSelTextColor(const Value: TColor);
    procedure SetOnChangeDrive(const Value: TOnChangeDrive);
    procedure SetOnChangeDriveLabel(const Value: TOnChangeDriveLabel);

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
    property Drive: string read FDrive write SetDrive;
    property LightIcon: Boolean read FLightIcon write SetLightIcon;
    property SelBackColor: TColor read FSelBackColor write SetSelBackColor;
    property SelTextColor: TColor read FSelTextColor write SetSelTextColor;
    property OnChangeDrive: TOnChangeDrive read FOnChangeDrive write SetOnChangeDrive;
    property OnChangeDriveLabel: TOnChangeDriveLabel read FOnChangeDriveLabel write SetOnChangeDriveLabel;

    //== Скрытие свойств в <Инспекторе Объектов>
    property Caption: Boolean read FNotAvailable;
    property CurIndex: Boolean read FNotAvailable;
    property Items: Boolean read FNotAvailable;
    property Options: Boolean read FNotAvailable;
    property OnChange: Boolean read FNotAvailable;
    property OnClick: Boolean read FNotAvailable;
    property OnDrawItem: Boolean read FNotAvailable;
    property OnMeasureItem: Boolean read FNotAvailable;
    property OnPaint: Boolean read FNotAvailable;
    property OnSelChange: Boolean read FNotAvailable;
  end;

procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL Dialogs', [TKOLBAPDriveBox]);
end;

(* Визуализация MCK *)

procedure TKOLBAPDriveBox.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl := PControl(NewBAPDriveBox(KOLParentCtrl, FLightIcon));
end;

procedure TKOLBAPDriveBox.SetParent(Value: TWinControl);
begin
  inherited;
  // Т.к. мы сами вырисовываем компонент, то необходимо вызвать RecreateWnd.
  if Assigned(Value) then
    RecreateWnd;
end;

(* Формирование объекта *)

function TKOLBAPDriveBox.AdditionalUnits;
begin
  Result := ', KOLBAPDriveBox';
end;

function TKOLBAPDriveBox.TypeName: string;
begin
  Result := 'BAPDriveBox';
end;

procedure TKOLBAPDriveBox.FirstCreate;
begin
  inherited CurIndex := -1;
end;

function TKOLBAPDriveBox.SetupParams;
begin
  Result := AParent;
end;

procedure TKOLBAPDriveBox.SetupConstruct;
const
  Boolean2Str: array [Boolean] of string = ('False', 'True');
var
  S: string;
begin
  inherited CurIndex := -1; // Подмена значения

  if FSelBackColor = clHighlight then
    if FSelTextColor = clHighlightText then
      S := ''
    else
      S := ', ' + Color2Str(FSelBackColor) + ', ' + Color2Str(FSelTextColor)
  else
    S := ', ' + Color2Str(FSelBackColor);

  SL.Add(Prefix + AName + ' := New' + TypeName + '(' + SetupParams(AName, AParent) +
   ', ' + Boolean2Str[FLightIcon] + S + ');');

  S := GenerateTransparentInits;
  if S <> '' then
    SL.Add(Prefix + AName + S + ';');
end;

procedure TKOLBAPDriveBox.SetupFirst;
begin
  inherited;
  if FDrive <> '*' then
    SL.Add(Prefix + AName + '.Drive := ' + StringConstant('Drive', FDrive) + ';');
end;

procedure TKOLBAPDriveBox.AssignEvents;
begin
  inherited;
  DoAssignEvents(SL, AName,
    ['OnChangeDrive', 'OnChangeDriveLabel'],
    [@OnChangeDrive, @OnChangeDriveLabel]);
end;

(* MCK *)

constructor TKOLBAPDriveBox.Create;
begin
  inherited;
  Width := 62;
  FDrive := '*';
  FSelBackColor := clHighlight;
  FSelTextColor := clHighlightText;
end;

(* Свойства *)

procedure TKOLBAPDriveBox.SetDrive;
begin
  if Value <> '' then
    if (LowerCase(Value)[1] in ['a'..'z', '*']) then
    begin
      FDrive := Value[1];
      Change;
      if Assigned(FKOLCtrl) then
        PBAPDriveBox(FKOLCtrl)^.Drive := FDrive;
    end else
      Value := '*';
end;

procedure TKOLBAPDriveBox.SetLightIcon;
begin
  FLightIcon := Value;
  Change;
end;

procedure TKOLBAPDriveBox.SetSelBackColor;
begin
  FSelBackColor := Value;
  Change;
end;

procedure TKOLBAPDriveBox.SetSelTextColor;
begin
  FSelTextColor := Value;
  Change;
end;

(* События *)

procedure TKOLBAPDriveBox.SetOnChangeDrive;
begin
  FOnChangeDrive := Value;
  Change;
end;

procedure TKOLBAPDriveBox.SetOnChangeDriveLabel;
begin
  FOnChangeDriveLabel := Value;
  Change;
end;

end.