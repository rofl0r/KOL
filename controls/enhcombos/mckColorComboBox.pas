unit mckColorComboBox;
{$R *.res}
interface

uses
  Windows, Messages, mirror, classes, Controls, Forms, kol, mckCtrls;

type

  TKOLColorComboBox = class(TKOLControl)
  private
    { Private declarations }
    fOnChange : TOnEvent;
    procedure SetOnChange(const Value : TOnEvent);
  protected
    function  AdditionalUnits: string;override;
    procedure AssignEvents(SL: TStringList; const AName: String);override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  published
    property OnChange : TOnEvent read fOnChange write SetOnChange;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLColorComboBox]);
end;

constructor TKOLColorComboBox.Create;
begin
   inherited;
   Width:=130;
   Height:=18;
 end;


function  TKOLColorComboBox.AdditionalUnits;
begin
   Result := ', KOLColorComboBox';
end;


procedure TKOLColorComboBox.SetupFirst;
begin
   inherited;
end;


procedure TKOLColorComboBox.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,[ 'OnChange' ],[ @OnChange ]);
end;


procedure TKOLColorComboBox.SetOnChange;
begin
    fOnChange := Value;
    Change;
end;


end.
