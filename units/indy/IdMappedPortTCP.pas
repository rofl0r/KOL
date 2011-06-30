// 27-nov-2002
// 27-apr-2003
unit IdMappedPortTCP;

interface

uses KOL { , 
  Classes } , IdTCPClient, IdTCPServer;

const
  ID_MAPPED_PORT_TCP_PORT = 0;
type
  TIdMappedPortTCPData = object(TObj)
  public
    OutboundClient: PIdTCPClient;//TIdTCPClient;
    ReadList: PList;//TList;

     { constructor Create;
     } destructor Destroy;
   virtual;
    end;
PIdMappedPortTCPData=^TIdMappedPortTCPData;

type

  TBeforeClientConnectEvent = procedure(ASender: {TComponent}PObj; AThread:
    PIdPeerThread;//TIdPeerThread;
    AClient: PIdTCPClient{TIdTCPClient}) of object;

  TIdMappedPortTCP = object(TIdTCPServer)
  protected
    FMappedPort: integer;
    FMappedHost: string;
    FOnBeforeClientConnect: TBeforeClientConnectEvent;

    procedure DoConnect(AThread: PIdPeerThread{TIdPeerThread}); virtual;//override;
    function DoExecute(AThread: PIdPeerThread{TIdPeerThread}): boolean; virtual;//override;
  public
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
   }  { published }
    property MappedHost: string read FMappedHost write FMappedHost;
    property MappedPort: integer read FMappedPort write FMappedPort default
      ID_MAPPED_PORT_TCP_PORT;
    property OnBeforeClientConnect: TBeforeClientConnectEvent read
      FOnBeforeClientConnect
    write FOnBeforeClientConnect;
  end;
PIdMappedPortTCP=^TIdMappedPortTCP;
function NewIdMappedPortTCP(AOwner: PControl):PIdMappedPortTCP;
function NewIdMappedPortTCPData:PIdMappedPortTCPData;

implementation

uses
  IdGlobal, IdStack,
  SysUtils;

  function NewIdMappedPortTCP(AOwner: PControl):PIdMappedPortTCP;
  //constructor TIdMappedPortTCP.Create(AOwner: TComponent);
begin
//  inherited;
  New( Result, Create );
  Result.Init;
//with Result^ do
//  FMappedPort := ID_MAPPED_PORT_TCP_PORT;
end;

procedure TIdMappedPortTCP.DoConnect(AThread: PIdPeerThread{TIdPeerThread});
begin
  inherited;
  AThread.Data := NewIdMappedPortTCPData;//TIdMappedPortTCPData.Create;
  with PIdMappedPortTCPData(AThread.Data)^ do
  begin
    OutboundClient := NewIdTCPClient(nil);//TIdTCPClient.Create(nil);
    with OutboundClient^ do
    begin
      Port := MappedPort;
      Host := MappedHost;
      if Assigned(FOnBeforeClientConnect) then
      begin
        FOnBeforeClientConnect(@Self, AThread, OutboundClient);
      end;
      Connect;
    end;
  end;
end;

function TIdMappedPortTCP.DoExecute(AThread: PIdPeerThread{TIdPeerThread}): boolean;
var
  LData: PIdMappedPortTCPData;//TIdMappedPortTCPData;
begin
  result := true;
  LData := PIdMappedPortTCPData(AThread.Data);
  try
    with LData.ReadList^ do
    begin
      Clear;
      Add(TObject(AThread.Connection.Binding.Handle));
      Add(TObject(LData.OutboundClient.Binding.Handle));
      if GStack.WSSelect(LData.ReadList, nil, nil, IdTimeoutInfinite) > 0 then
      begin
        if IndexOf(TObject(AThread.Connection.Binding.Handle)) > -1 then
        begin
          LData.OutboundClient.Write(AThread.Connection.CurrentReadBuffer);
        end;
        if IndexOf(TObject(LData.OutboundClient.Binding.Handle)) > -1 then
        begin
          AThread.Connection.Write(LData.OutboundClient.CurrentReadBuffer);
        end;
      end;
    end;
  finally
    if not LData.OutboundClient.Connected then
    begin
      AThread.Connection.Disconnect;
    end;
  end;
end;

//constructor TIdMappedPortTCPData.Create;
function NewIdMappedPortTCPData:PIdMappedPortTCPData;
begin
  New( Result, Create );
  with Result^ do
  ReadList := NewList;//TList.Create;
end;

destructor TIdMappedPortTCPData.Destroy;
begin
  FreeAndNil(ReadList);
  FreeAndNil(OutboundClient);
  inherited;
end;

procedure TIdMappedPortTCP.Init;
begin
  inherited;
  FMappedPort := ID_MAPPED_PORT_TCP_PORT;
end;

end.
