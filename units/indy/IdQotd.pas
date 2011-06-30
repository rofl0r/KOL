// 19-nov-2002
unit IdQotd;

interface

uses KOL { ,
  Classes } ,
  IdGlobal,
  IdTCPClient;

type
  PIdQOTD=^TIdQOTD;
  TIdQOTD = object(TIdTCPClient)
  protected
    function GetQuote: string;
  public
    property Quote: string read GetQuote;
    property Port default IdPORT_QOTD;
  end;

function NewIdQOTD(AOwner: PControl):PIdQOTD;

implementation

{uses
  SysUtils;}

function NewIdQOTD(AOwner: PControl):PIdQOTD;
begin
  New( Result, Create );
//  inherited;
  Port := IdPORT_QOTD;
end;

function TIdQOTD.GetQuote: string;
begin
  Result := ConnectAndGetAll;
end;

end.
