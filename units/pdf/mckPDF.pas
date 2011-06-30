//////////////////////////////////////////////////
//						//
//						//
//		TKOLPDF v1.0			//
//						//
//	Author: Dimaxx (dimaxx@atnet.ru)	//
//						//
//						//
//////////////////////////////////////////////////
unit mckPDF;

interface

uses Classes, Kol, Mirror;

type
  TKOLPDF = class(TKOLCustomControl)
  private
  public
    constructor Create(Owner: TComponent); override;
  protected
    function AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
  published
    property Align;
    property Visible;
  end;

  procedure Register;

{$R mckPDF.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL', [TKOLPDF]);
end;

constructor TKOLPDF.Create;
begin
  inherited Create(Owner);
end;

function TKOLPDF.AdditionalUnits;
begin
   Result:=', KOLPDF';
end;

procedure TKOLPDF.SetupFirst;
begin
  SL.Add(Prefix+AName+' := NewKOLPDF(Result.Form); ');
end;

end.

