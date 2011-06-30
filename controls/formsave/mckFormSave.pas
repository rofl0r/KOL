unit mckFormSave;

interface

uses
  Windows, Classes, Messages, Forms, SysUtils,
  mirror, mckCtrls, Graphics;

type

  TKOLFormSave = class(TKOLObj)
  private
    fRegistry: boolean;
    fFileName: string;
     fSection: string;
  protected
    constructor Create(AOwner: TComponent); override;
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetRegistry(Value: boolean);
    procedure SetFileName(Value: string);
    procedure SetSection(Value: string);
  public
  published
    property FileName: string read fFileName write SetFileName;
    property Registry: boolean read fRegistry write SetRegistry;
    property Section: string read fSection write SetSection;
  end;

  procedure Register;

implementation

{$R *.dcr}

constructor TKOLFormSave.Create;
begin
   inherited;
   Registry := True;
   FileName := '';
   fSection := AOwner.Name;
end;

function  TKOLFormSave.AdditionalUnits;
begin
   Result := ', FormSave';
end;

procedure TKOLFormSave.SetupFirst;
begin
  SL.Add( Prefix + AName + ' := NewFormSave(Result.Form);' );
  if fRegistry then
  SL.Add( Prefix + AName + '.Registry := True;');
  if fFileName <> '' then
  SL.Add( Prefix + AName + '.FileName := ''' + fFileName + ''';' );
  if fSection <> '' then
  SL.Add( Prefix + AName + '.Section  := ''' + fSection  + ''';' );
  SL.Add( Prefix + AName + '.SaveWindow(False);' );
end;

procedure TKOLFormSave.SetupLast;
begin
end;

procedure TKOLFormSave.AssignEvents;
begin
   inherited;
end;

procedure TKOLFormSave.SetRegistry;
begin
   fRegistry := Value;
   Change;
end;

procedure TKOLFormSave.SetFileName;
begin
   if Value <> '' then begin
      fFileName := Value;
      Change;
   end;
end;

procedure TKOLFormSave.SetSection;
begin
   if Value <> '' then begin
      fSection := Value;
   end;
end;

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLFormSave]);
end;

end.

