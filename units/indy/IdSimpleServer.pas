// 26-nov-2002
unit IdSimpleServer;

interface

uses KOL { , 
  Classes } ,
  IdTCPConnection, IdStackConsts;

const
  ID_SIMPLE_SERVER_BOUND_PORT = 0;

type
  TIdSimpleServer = object(TIdTCPConnection)
  protected
    FAbortedRequested: Boolean;
    FAcceptWait: Integer;
    FBoundIP: string;
    FBoundPort: Integer;
    FListenHandle: TIdStackSocketHandle;
    FListening: Boolean;
  public
    procedure Abort; virtual;
    procedure BeginListen; virtual;
    procedure Bind; virtual;
     { constructor Create(AOwner: TComponent); override;
     } function Listen: Boolean; virtual;
    procedure ResetConnection; virtual;//override;
    //
    property AcceptWait: integer read FAcceptWait write FAcceptWait;
    property ListenHandle: TIdStackSocketHandle read FListenHandle;
   { published } 
    property BoundIP: string read FBoundIP write FBoundIP;
    property BoundPort: Integer read FBoundPort write FBoundPort default
      ID_SIMPLE_SERVER_BOUND_PORT;
  end;
PIdSimpleServer=^TIdSimpleServer;
function NewIdSimpleServer(AOwner: PControl):PIdSimpleServer; 

implementation

uses
  IdStack;

procedure TIdSimpleServer.Abort;
begin
  FAbortedRequested := true;
end;

procedure TIdSimpleServer.BeginListen;
begin
  ResetConnection;
  if ListenHandle = Id_INVALID_SOCKET then
  begin
    Bind;
  end;
  Binding.Listen(1);
  FListening := True;
end;

procedure TIdSimpleServer.Bind;
begin
  with Binding do
  begin
    try
      AllocateSocket;
      FListenHandle := Handle;
//      IP := BoundIP;
//      Port := BoundPort;
      Bind;
    except
      FListenHandle := Id_INVALID_SOCKET;
      raise;
    end;
  end;
end;

//constructor TIdSimpleServer.Create(AOwner: TComponent);
function NewIdSimpleServer(AOwner: PControl):PIdSimpleServer;
begin
//  inherited;
New( Result, Create );
with Result^ do
begin
  FBoundPort := ID_SIMPLE_SERVER_BOUND_PORT;
  FListenHandle := Id_INVALID_SOCKET;
end;  
end;

function TIdSimpleServer.Listen: boolean;
begin
  result := false;
  if not FListening then
  begin
    BeginListen;
  end;
  with Binding do
  begin
    while (FAbortedRequested = false) and (result = false) do
    begin
      result := Readable(AcceptWait);
    end;
    if result then
    begin
      Accept(Handle);
    end;
    GStack.WSCloseSocket(ListenHandle);
    FListenHandle := Id_INVALID_SOCKET;
  end;
end;

procedure TIdSimpleServer.ResetConnection;
begin
  inherited;
  FAbortedRequested := False;
  FListening := False;
end;

end.
