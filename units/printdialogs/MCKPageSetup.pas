unit mckPageSetup;

interface

uses
  KOL,KOLPageSetupDialog,Windows, Classes,Graphics,
   mirror,mckObjs ;

type

  TKOLPageSetupDialog = class(TKOLObj)
  private
    fOptions   : TPageSetupOptions;
    fAlwaysReset : Boolean;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetOptions(const Value : TPageSetupOptions);
    procedure SetAlwaysReset(const Value : Boolean);
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy;override;
  published
  property Options : TPageSetupOptions read fOptions write SetOptions;
  property AlwaysReset : Boolean read fAlwaysReset write SetAlwaysReset;
  end;



  procedure Register;

implementation

{$R *.dcr}



constructor TKOLPageSetupDialog.Create( AOwner: TComponent );
begin
inherited Create(Aowner);
fAlwaysReset := false;
fOptions := [psdMargins,psdOrientation,psdSamplePage,psdPaperControl,psdPrinterControl];
end;

destructor TKOLPageSetupDialog.Destroy;
begin
inherited Destroy;
end;




procedure TKOLPageSetupDialog.SetAlwaysReset(const Value: Boolean);
begin
  fAlwaysReset := Value;
  Change;
end;


procedure TKOLPageSetupDialog.SetOptions(const Value : TPageSetupOptions);
begin
    fOptions := Value;
    Change;
end;

function TKOLPageSetupDialog.AdditionalUnits;
begin
   Result := ', KOLPageSetupDialog';
end;


procedure TKOLPageSetupDialog.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
  var
  s : String;
  begin
    if (psdMargins in fOptions) then s := s + ',psdMargins';
    if (psdOrientation in fOptions) then s := s + ',psdOrientation';
    if (psdSamplePage in fOptions) then s := s + ',psdSamplePage';
    if (psdPaperControl in fOptions) then s := s + ',psdPaperControl';
    if (psdPrinterControl in fOptions) then s := s + ',psdPrinterControl';
    if (psdHundredthsOfMillimeters in fOptions) then s := s + ',psdHundredthsOfMillimeters';
    if (psdThousandthsOfInches in fOptions) then s := s + ',psdThousandthsOfInches';
    if (psdUseMargins in fOptions) then s := s + ',psdUseMargins';
    if (psdUseMinMargins in fOptions) then s := s + ',psdUseMinMargins';
    if (psdWarning in fOptions) then s := s + ',psdWarning';
    if (psdHelp in fOptions) then s := s + ',psdHelp';
    if (psdReturnDC in fOptions) then s:= s + ',psdReturnDC';
    if s <> '' then
    if s[1] = ',' then s[1] := Chr(32);
    SL.Add(Prefix + AName + ' := NewPageSetupDialog(' + AParent + ',[' + s + ']);');
    if fAlwaysReset then SL.Add(Prefix + AName + '.AlwaysReset := True;');
  end;




procedure Register;
begin
  RegisterComponents('KOL Dialogs', [TKOLPageSetupDialog]);
end;

end.

