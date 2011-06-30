unit mckFontComboBox;
{$R *.res}
interface

uses
  Windows, Messages, mirror, classes, Controls, Forms, kol, mckCtrls;

type

  TKOLFontComboBox = class(TKOLControl)
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
  RegisterComponents('KOLUtil', [TKOLFontComboBox]);
end;

constructor TKOLFontComboBox.Create;
begin
   inherited;
   Width:=230;
   Height:=18;
 end;


function  TKOLFontComboBox.AdditionalUnits;
begin
   Result := ', KOLFontComboBox';
end;


procedure TKOLFontComboBox.SetupFirst;
begin
   inherited;
end;


procedure TKOLFontComboBox.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,[ 'OnChange' ],[ @OnChange ]);
end;


procedure TKOLFontComboBox.SetOnChange;
begin
    fOnChange := Value;
    Change;
end;


end.
