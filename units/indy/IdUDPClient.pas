// 19-nov-2002
unit IdUDPClient;

interface

uses KOL, 
  IdUDPBase;

type
  PIdUDPClient=^TIdUDPClient;
  TIdUDPClient = object(TIdUDPBase)
  protected
  public
    procedure Send(AData: string); overload;
    procedure SendBuffer(var ABuffer; const AByteCount: integer); overload;
   { published }
    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property ReceiveTimeout;
  end;

function NewIdUDPClient:PIdUDPClient;

implementation

function NewIdUDPClient:PIdUDPClient;
begin
  New( Result, Create );
end;

procedure TIdUDPClient.Send(AData: string);
begin
  Send(Host, Port, AData);
end;

procedure TIdUDPClient.SendBuffer(var ABuffer; const AByteCount: integer);
begin
  SendBuffer(Host, Port, ABuffer, AByteCount);
end;

end.
