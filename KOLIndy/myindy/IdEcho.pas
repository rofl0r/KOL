// 25-nov-2002
unit IdEcho;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPClient;

type
  TIdEcho = object(TIdTCPClient)
  protected
    FEchoTime: Cardinal;
  public
     { constructor Create(AOwner: TComponent); override;
     } function Echo(AText: string): string;
    property EchoTime: Cardinal read FEchoTime;
   { published } 
//    property Port default IdPORT_ECHO;
  end;
PIdEcho=^TIdEcho;
function NewIdEcho(AOwner: PControl):PIdEcho;

implementation

uses
  IdComponent,
  IdTCPConnection;

  function NewIdEcho(AOwner: PControl):PIdEcho;
  //constructor TIdEcho.Create(AOwner: TComponent);
begin
//  inherited;
  New( Result, Create );
with Result^ do
  Port := IdPORT_ECHO;
end;

function TIdEcho.Echo(AText: string): string;
var
  StartTime: Cardinal;
begin
  BeginWork(wmWrite, Length(AText) + 2);
  try
    StartTime := IdGlobal.GetTickCount;
    Write(AText);
  finally
    EndWork(wmWrite);
  end;
  BeginWork(wmRead);
  try
    Result := CurrentReadBuffer;
    if IdGlobal.GetTickCount >= StartTime then
      FEchoTime := IdGlobal.GetTickCount - StartTime
    else
      FEchoTime := High(Cardinal) - StartTime;
  finally
    EndWork(wmRead);
  end;
end;

end.
