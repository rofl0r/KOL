unit mckPrintDialogs;

interface

uses
  KOL,KOLPrintDialogs,Windows, Classes,Graphics,
   mirror,mckObjs ;

type

  TKOLPrintDialog = class(TKOLObj)
  private
    ftagPD    : tagPD;
    fOptions  : TPrintDlgOptions;
    fAlwaysReset : Boolean;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetOptions(const Value : TPrintDlgOptions);
    procedure SetFromPage(const Value : WORD);
    procedure SetToPage(const Value : WORD);
    procedure SetMinPage(const Value : WORD);
    procedure SetMaxPage(const Value : WORD);
    procedure SetCopies(const Value : WORD);
    procedure SetAlwaysReset(const Value : Boolean);
  public
    constructor Create( AOwner: TComponent ); override;
  published
  property FromPage : WORD read ftagPD.nFromPage write SetFromPage;
  property ToPage   : WORD read ftagPD.nToPage write SetToPage;
  property MinPage  : WORD read ftagPD.nMinPage write SetMinPage;
  property MaxPage  : WORD read ftagPD.nMaxPage write SetMaxPage;
  property Copies   : WORD read ftagPD.nCopies write SetCopies;
  property Options : TPrintDlgOptions read fOptions write SetOptions;
  property AlwaysReset : Boolean read fAlwaysReset write SetAlwaysReset;
  end;


  procedure Register;

implementation

{$R *.dcr}




constructor TKOLPrintDialog.Create( AOwner: TComponent );
begin
inherited Create(Aowner);
fAlwaysReset := false;
FromPage := 1;
ToPage   := 1;
MinPage  := 1;
MaxPage  := 1;
Copies   := 1;
end;

procedure TKOLPrintDialog.SetAlwaysReset(const Value : Boolean);
begin
  fAlwaysReset := Value;
  Change;
end;

procedure TKOLPrintDialog.SetOptions(const Value : TPrintDlgOptions);
begin
    fOptions := Value;
    Change;
end;

procedure TKOLPrintDialog.SetFromPage(const Value : WORD);
begin
    ftagPD.nFromPage := Value;
    Change;
end;

procedure TKOLPrintDialog.SetToPage(const Value : WORD);
begin
    ftagPD.nToPage := Value;
    Change;
end;

procedure TKOLPrintDialog.SetMinPage(const Value : WORD);
begin
    ftagPD.nMinPage := Value;
    Change;
end;

procedure TKOLPrintDialog.SetMaxPage(const Value : WORD);
begin
    ftagPD.nMaxPage := Value;
    Change;
end;

procedure TKOLPrintDialog.SetCopies(const Value : WORD);
begin
    ftagPD.nCopies := Value;
    Change;
end;




function TKOLPrintDialog.AdditionalUnits;
begin
   Result := ', KOLPrintDialogs';
end;


procedure TKOLPrintDialog.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
  var
  s : String;
  begin
    if (pdPrinterSetup in fOptions) then s := s + ',pdPrinterSetup';
    if (pdCollate in fOptions) then s := s + ',pdCollate';
    if (pdPrintToFile in fOptions) then s := s + ',pdPrintToFile';
    if (pdPageNums in fOptions) then s := s + ',pdPageNums';
    if (pdSelection in fOptions) then s := s + ',pdSelection';
    if (pdWarning in fOptions) then s := s + ',pdWarning';
    if (pdDeviceDepend in fOptions) then s := s + ',pdDeviceDepend';
    if (pdHelp in fOptions) then s := s + ',pdHelp';
    if (pdReturnDC in fOptions) then s:= s + ',pdReturnDC';
    if s <> '' then
    if s[1] = ',' then s[1] := Chr(32);
    SL.Add( Prefix + AName + ' := NewPrintDialog(' + AParent + ',[' + s + ']);');
    if fAlwaysReset then SL.Add(Prefix + AName + '.AlwaysReset := true;');
    SL.Add(Prefix + AName + '.FromPage :=' + Int2Str(Integer(ftagPD.nFromPage)) + ';');
    SL.Add(Prefix + AName + '.ToPage :=' + Int2Str(Integer(ftagPD.nToPage)) + ';');
    SL.Add(Prefix + AName + '.MinPage :=' + Int2Str(Integer(ftagPD.nMinPage)) + ';');
    SL.Add(Prefix + AName + '.MaxPage :=' + Int2Str(Integer(ftagPD.nMaxPage)) + ';');
    SL.Add(Prefix + AName + '.Copies :=' + Int2Str(Integer(ftagPD.nCopies)) + ';');
  end;




procedure Register;
begin
  RegisterComponents('KOL Dialogs', [TKOLPrintDialog]);
end;

end.

