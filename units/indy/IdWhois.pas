// 22-nov-2002
unit IdWhois;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPClient;

type
  TIdWhois = object(TIdTCPClient)
  public
    procedure Init;virtual; 
     { constructor Create(AOwner: TComponent); override;
     } function WhoIs(const ADomain: string): string;
   { published } 
//    property Port default IdPORT_WHOIS;
  end;
PIdWhois=^TIdWhois;
function NewIdWhois(AOwner: PControl):PIdWhois;

implementation

uses
  IdTCPConnection;

//constructor TIdWHOIS.Create(AOwner: TComponent);
function NewIdWhois(AOwner: PControl):PIdWhois;
begin
  New( Result, Create );
  Result.Init;
//  inherited;
//  Host := 'whois.internic.net';
//  Port := IdPORT_WHOIS;
end;

procedure TIdWHOIS.Init;
begin
  inherited;
  Host := 'whois.internic.net';
  Port := IdPORT_WHOIS;
end;

function TIdWHOIS.WhoIs(const ADomain: string): string;
begin
  Connect;
  try
    WriteLn(ADomain);
    Result := AllData;
  finally Disconnect;
  end;
end;

end.
