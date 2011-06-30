//30-nov-2002
unit IdTunnelMaster;

interface
uses KOL { , 
  Classes } ,
  IdTCPServer, IdTCPClient, IdTunnelCommon,
  SyncObjs;

type
//  TIdTunnelMaster = object(TObj);
//PIdTunnelMaster=^TIdTunnelMaster; type  MyStupid0=DWord;

  MClientThread = object(TThread)
  public
    MasterParent: PObj;//TIdTunnelMaster;
    UserId: Integer;
    MasterThread: TIdPeerThread;
    OutboundClient: TIdTCPClient;
    DisconnectedOnRequest: Boolean;
    Locker: TCriticalSection;
    SelfDisconnected: Boolean;
//    procedure Execute; virtual;

//    override;
     { constructor Create(master: TIdTunnelMaster);
     } destructor Destroy; 
   virtual; end;
PMClientThread=^MClientThread;
function NewMClientThread(master: PObj{TIdTunnelMaster}):PMClientThread;
 type

  TSlaveData = object(TObj)
  public
    Receiver: TReceiver;
    Sender: TSender;
    Locker: TCriticalSection;
    SelfDisconnected: Boolean;
    UserData: TObject;
  end;
PSlaveData=^TSlaveData;
function NewSlaveData:PSlaveData;
 type

  TSendMsgEvent = procedure(Thread: TIdPeerThread; var CustomMsg: string) of
    object;
  TSendTrnEvent = procedure(Thread: TIdPeerThread; var Header: TIdHeader; var
    CustomMsg: string) of object;
  TSendTrnEventC = procedure(var Header: TIdHeader; var CustomMsg: string) of
    object;
  TTunnelEventC = procedure(Receiver: TReceiver) of object;
  TSendMsgEventC = procedure(var CustomMsg: string) of object;

  TIdTunnelMaster = object(TIdTCPServer)
  private
    fiMappedPort: Integer;
    fsMappedHost: string;
//    Clients: TThreadList;
{    fOnConnect,
      fOnDisconnect,
      fOnTransformRead: TIdServerThreadEvent;}
    fOnTransformSend: TSendTrnEvent;
    fOnInterpretMsg: TSendMsgEvent;
    OnlyOneThread: TCriticalSection;

    StatisticsLocker: TCriticalSection;
    fbActive: Boolean;
    fbLockDestinationHost: Boolean;
    fbLockDestinationPort: Boolean;
    fLogger: TLogger;

    flConnectedSlaves,
      flConnectedServices,
      fNumberOfConnectionsValue,
      fNumberOfPacketsValue,
      fCompressionRatioValue,
      fCompressedBytes,
      fBytesRead,
      fBytesWrite: Integer;
    procedure ClientOperation(Operation: Integer; UserId: Integer; s: string);
    procedure SendMsg(MasterThread: TIdPeerThread; var Header: TIdHeader; s:
      string);
    procedure DisconectAllUsers;
    procedure DisconnectAllSubThreads(TunnelThread: TIdPeerThread);
    function GetNumSlaves: Integer;
    function GetNumServices: Integer;
    function GetClientThread(UserID: Integer): MClientThread;
  protected
    procedure SetActive(pbValue: Boolean); virtual;//override;
    procedure DoConnect(Thread: TIdPeerThread); virtual;//override;
    procedure DoDisconnect(Thread: TIdPeerThread);virtual;// override;
    function DoExecute(Thread: TIdPeerThread): boolean; virtual;//override;
    procedure DoTransformRead(Thread: TIdPeerThread); virtual;
    procedure DoTransformSend(Thread: TIdPeerThread; var Header: TIdHeader; var
      CustomMsg: string);
      virtual;
    procedure DoInterpretMsg(Thread: TIdPeerThread; var CustomMsg: string);
      virtual;
    procedure LogEvent(Msg: string);
//  published
    property MappedHost: string read fsMappedHost write fsMappedHost;
    property MappedPort: Integer read fiMappedPort write fiMappedPort;
    property LockDestinationHost: Boolean read fbLockDestinationHost write
      fbLockDestinationHost
    default False;
    property LockDestinationPort: Boolean read fbLockDestinationPort write
      fbLockDestinationPort
    default False;
    property OnConnect: TIdServerThreadEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TIdServerThreadEvent read FOnDisconnect write
      FOnDisconnect;
//    property OnTransformRead: TIdServerThreadEvent read fOnTransformRead write
//      fOnTransformRead;
    property OnTransformSend: TSendTrnEvent read fOnTransformSend write
      fOnTransformSend;
    property OnInterpretMsg: TSendMsgEvent read fOnInterpretMsg write
      fOnInterpretMsg;
  public
    property Active: Boolean read FbActive write SetActive default True;
    property Logger: TLogger read fLogger write fLogger;
    property NumSlaves: Integer read GetNumSlaves;
    property NumServices: Integer read GetNumServices;
    procedure SetStatistics(Module: Integer; Value: Integer);
    procedure GetStatistics(Module: Integer; var Value: Integer);
//    constructor Create(AOwner: TComponent); override;
    destructor Destroy; virtual;//override;
  end;

  PIdTunnelMaster=^TIdTunnelMaster;

function NewIdTunnelMaster(AOwner: PControl):PIdTunnelMaster;

implementation
uses {KOL,  IdException,}
  IdGlobal, IdStack, IdResourceStrings, SysUtils;

 { constructor TIdTunnelMaster.Create(AOwner: TComponent);
 } 
function NewIdTunnelMaster (AOwner: PControl):PIdTunnelMaster;
begin
New( Result, Create );
with Result^ do
begin
{  Clients := TThreadList.Create;
  inherited Create(AOwner);
  fbActive := False;
  flConnectedSlaves := 0;
  flConnectedServices := 0;

  fNumberOfConnectionsValue := 0;
  fNumberOfPacketsValue := 0;
  fCompressionRatioValue := 0;
  fCompressedBytes := 0;
  fBytesRead := 0;
  fBytesWrite := 0;

  OnlyOneThread := TCriticalSection.Create;
  StatisticsLocker := TCriticalSection.Create;}
  end;
end;

destructor TIdTunnelMaster.Destroy;
// virtual;
 begin
//  Logger := nil;
  Active := False;
  DisconectAllUsers;
  inherited Destroy;

//  Clients.Destroy;
  OnlyOneThread.Free;
  StatisticsLocker.Free;
end;

procedure TIdTunnelMaster.SetActive(pbValue: Boolean);
begin

  if fbActive = pbValue then
    exit;

  if pbValue then
  begin
    inherited SetActive(True);
  end
  else
  begin
    inherited SetActive(False);
    DisconectAllUsers;
  end;

  fbActive := pbValue;

end;

procedure TIdTunnelMaster.LogEvent(Msg: string);
begin
//  if Assigned(fLogger) then
//    fLogger.LogEvent(Msg);
end;

function TIdTunnelMaster.GetNumSlaves: Integer;
var
  ClientsNo: Integer;
begin
  GetStatistics(NumberOfSlavesType, ClientsNo);
  Result := ClientsNo;
end;

function TIdTunnelMaster.GetNumServices: Integer;
var
  ClientsNo: Integer;
begin
  GetStatistics(NumberOfServicesType, ClientsNo);
  Result := ClientsNo;
end;

procedure TIdTunnelMaster.GetStatistics(Module: Integer; var Value: Integer);
begin
  StatisticsLocker.Enter;
  try
    case Module of
      NumberOfSlavesType:
        begin
          Value := flConnectedSlaves;
        end;

      NumberOfServicesType:
        begin
          Value := flConnectedServices;
        end;

      NumberOfConnectionsType:
        begin
          Value := fNumberOfConnectionsValue;
        end;

      NumberOfPacketsType:
        begin
          Value := fNumberOfPacketsValue;
        end;

      CompressionRatioType:
        begin
          if fCompressedBytes > 0 then
          begin
            Value := Trunc((fBytesRead * 1.0) / (fCompressedBytes * 1.0) * 100.0)
          end
          else
          begin
            Value := 0;
          end;
        end;

      CompressedBytesType:
        begin
          Value := fCompressedBytes;
        end;

      BytesReadType:
        begin
          Value := fBytesRead;
        end;

      BytesWriteType:
        begin
          Value := fBytesWrite;
        end;
    end;
  finally
    StatisticsLocker.Leave;
  end;
end;

procedure TIdTunnelMaster.SetStatistics(Module: Integer; Value: Integer);
var
  packets: Real;
  ratio: Real;
begin
  StatisticsLocker.Enter;
  try
    case Module of
      NumberOfSlavesType:
        begin
          if TIdStatisticsOperation(Value) = soIncrease then
          begin
            Inc(flConnectedSlaves);
          end
          else
          begin
            Dec(flConnectedSlaves);
          end;
        end;

      NumberOfServicesType:
        begin
          if TIdStatisticsOperation(Value) = soIncrease then
          begin
            Inc(flConnectedServices);
            Inc(fNumberOfConnectionsValue);
          end
          else
          begin
            Dec(flConnectedServices);
          end;
        end;

      NumberOfConnectionsType:
        begin
          Inc(fNumberOfConnectionsValue);
        end;

      NumberOfPacketsType:
        begin
          Inc(fNumberOfPacketsValue);
        end;

      CompressionRatioType:
        begin
          ratio := fCompressionRatioValue;
          packets := fNumberOfPacketsValue;
          ratio := (ratio / 100.0 * (packets - 1.0) + Value / 100.0) / packets;
          fCompressionRatioValue := Trunc(ratio * 100);
        end;

      CompressedBytesType:
        begin
          fCompressedBytes := fCompressedBytes + Value;
        end;

      BytesReadType:
        begin
          fBytesRead := fBytesRead + Value;
        end;

      BytesWriteType:
        begin
          fBytesWrite := fBytesWrite + Value;
        end;
    end;
  finally
    StatisticsLocker.Leave;
  end;
end;

procedure TIdTunnelMaster.DoConnect(Thread: TIdPeerThread);
begin

//  Thread.Data := TSlaveData.Create;
{  with TSlaveData(Thread.Data) do
  begin
    Receiver := TReceiver.Create;
    Sender := TSender.Create;
    SelfDisconnected := False;
    Locker := TCriticalSection.Create;
  end;
  if Assigned(OnConnect) then
  begin
    OnConnect(Thread);
  end;
  SetStatistics(NumberOfSlavesType, Integer(soIncrease));
 }
end;

procedure TIdTunnelMaster.DoDisconnect(Thread: TIdPeerThread);
begin

  SetStatistics(NumberOfSlavesType, Integer(soDecrease));
  DisconnectAllSubThreads(Thread);
  if Thread.Connection.Connected then
    Thread.Connection.Disconnect;

  if Assigned(OnDisconnect) then
  begin
    OnDisconnect(Thread);
  end;

{  with TSlaveData(Thread.Data) do
  begin
    Receiver.Free;
    Sender.Free;
    Locker.Free;
    TSlaveData(Thread.Data).Free;
  end;}
  Thread.Data := nil;

end;

function TIdTunnelMaster.DoExecute(Thread: TIdPeerThread): boolean;
var
  user: TSlaveData;
  clientThread: MClientThread;
  s: string;
  ErrorConnecting: Boolean;
  sIP: string;
  CustomMsg: string;
  Header: TIdHeader;
begin
  result := true;

//  user := TSlaveData(Thread.Data);
{  if Thread.Connection.Binding.Readable(IdTimeoutInfinite) then
  begin
    user.receiver.Data := Thread.Connection.CurrentReadBuffer;

    SetStatistics(NumberOfPacketsType, 0);

    while user.receiver.TypeDetected do
    begin
      if not (user.receiver.Header.MsgType in [tmData, tmDisconnect, tmConnect,
        tmCustom]) then
      begin
        Thread.Connection.Disconnect;
        break;
      end;

      if user.receiver.NewMessage then
      begin
        if user.Receiver.CRCFailed then
        begin
          Thread.Connection.Disconnect;
          break;
        end;

        try
          DoTransformRead(Thread);
        except
          Thread.Connection.Disconnect;
          Break;
        end;

        case user.Receiver.Header.MsgType of
          tmError:
            begin
              try
                Thread.Connection.Disconnect;
                break;
              except
                ;
              end;
            end;

          tmData:
            begin
              try
                SetString(s, user.Receiver.Msg, user.Receiver.MsgLen);
                ClientOperation(tmData, user.Receiver.Header.UserId, s);
              except
                ;
              end;
            end;

          tmDisconnect:
            begin
              try
                ClientOperation(tmDisconnect, user.Receiver.Header.UserId, '');
              except
                ;
              end;
            end;

          tmConnect:
            begin
              try
                clientThread := MClientThread.Create(self);
                try
                  ErrorConnecting := False;
                  with clientThread do
                  begin
                    UserId := user.Receiver.Header.UserId;
                    MasterThread := Thread;
                    OutboundClient := TIdTCPClient.Create(nil);
                    sIP := GStack.TInAddrToString(user.Receiver.Header.IpAddr);
                    if fbLockDestinationHost then
                    begin
                      OutboundClient.Host := fsMappedHost;
                      if fbLockDestinationPort then
                        OutboundClient.Port := fiMappedPort
                      else
                        OutboundClient.Port := user.Receiver.Header.Port;
                    end
                    else
                    begin
                      if sIP = '0.0.0.0' then
                      begin
                        OutboundClient.Host := fsMappedHost;
                        OutboundClient.Port := user.Receiver.Header.Port;
                      end
                      else
                      begin
                        OutboundClient.Host := sIP;
                        OutboundClient.Port := user.Receiver.Header.Port;
                      end;
                    end;
                    OutboundClient.Connect;
                  end;
                except
                  ErrorConnecting := True;
                end;
                if ErrorConnecting then
                begin
                  clientThread.Destroy;
                end
                else
                begin
                  clientThread.Resume;
                end;
              except
                ;
              end;

            end;

          tmCustom:
            begin
              CustomMsg := '';
              DoInterpretMsg(Thread, CustomMsg);
              if Length(CustomMsg) > 0 then
              begin
                Header.MsgType := tmCustom;
                Header.UserId := 0;
                SendMsg(Thread, Header, CustomMsg);
              end;
            end;

        end;

        user.Receiver.ShiftData;

      end
      else
        break;

    end;
  end;}
end;

procedure TIdTunnelMaster.DoTransformRead(Thread: TIdPeerThread);
begin

//  if Assigned(fOnTransformRead) then
//    fOnTransformRead(Thread);

end;

procedure TIdTunnelMaster.DoTransformSend(Thread: TIdPeerThread; var Header:
  TIdHeader; var CustomMsg: string);
begin

  if Assigned(fOnTransformSend) then
    fOnTransformSend(Thread, Header, CustomMsg);

end;

procedure TIdTunnelMaster.DoInterpretMsg(Thread: TIdPeerThread; var CustomMsg:
  string);
begin

  if Assigned(fOnInterpretMsg) then
    fOnInterpretMsg(Thread, CustomMsg);

end;

procedure TIdTunnelMaster.DisconnectAllSubThreads(TunnelThread: TIdPeerThread);
var
  Thread: MClientThread;
  i: integer;
  listTemp: TList;
begin

{  OnlyOneThread.Enter;
  listTemp := Clients.LockList;
  try
    for i := 0 to listTemp.count - 1 do
    begin
      if Assigned(listTemp[i]) then
      begin
        Thread := MClientThread(listTemp[i]);
        if Thread.MasterThread = TunnelThread then
        begin
          Thread.DisconnectedOnRequest := True;
          Thread.OutboundClient.Disconnect;
        end;
      end;
    end;
  finally
    Clients.UnlockList;
    OnlyOneThread.Leave;
  end;
 }
end;

procedure TIdTunnelMaster.SendMsg(MasterThread: TIdPeerThread; var Header:
  TIdHeader; s: string);
var
  user: TSlaveData;
  tmpString: string;
begin

{  if Assigned(MasterThread.Data) then
  begin

    TSlaveData(MasterThread.Data).Locker.Enter;
    try
      user := TSlaveData(MasterThread.Data);
      try
        tmpString := s;
        try
          DoTransformSend(MasterThread, Header, tmpString);
        except
          on E: Exception do
          begin
            raise
              EIdTunnelTransformErrorBeforeSend.Create(RSTunnelTransformErrorBS);
          end;
        end;
        if Header.MsgType = tmError then
        begin // error ocured in transformation
          raise
            EIdTunnelTransformErrorBeforeSend.Create(RSTunnelTransformErrorBS);
        end;

        user.Sender.PrepareMsg(Header, PChar(@tmpString[1]), Length(tmpString));
        MasterThread.Connection.Write(user.Sender.Msg);
      except
        raise;
      end;
    finally
      TSlaveData(MasterThread.Data).Locker.Leave;
    end;

  end;}
end;

function TIdTunnelMaster.GetClientThread(UserID: Integer): MClientThread;
var
  Thread: MClientThread;
  i: integer;
begin

//  Result := nil;
{  with Clients.LockList do
  try
    for i := 0 to Count - 1 do
    begin
      try
        if Assigned(Items[i]) then
        begin
          Thread := MClientThread(Items[i]);
          if Thread.UserId = UserID then
          begin
            Result := Thread;
            break;
          end;
        end;
      except
        Result := nil;
      end;
    end;
  finally
    Clients.UnlockList;
  end;
 }
end;

procedure TIdTunnelMaster.DisconectAllUsers;
begin
  TerminateAllThreads;
end;

procedure TIdTunnelMaster.ClientOperation(Operation: Integer; UserId: Integer;
  s: string);
var
  Thread: MClientThread;
begin

  Thread := GetClientThread(UserID);
{  if Assigned(Thread) then
  begin
    Thread.Locker.Enter;
    try
      if not Thread.SelfDisconnected then
      begin
        case Operation of
          tmData:
            begin
              try
                Thread.OutboundClient.CheckForDisconnect;
                if Thread.OutboundClient.Connected then
                  Thread.OutboundClient.Write(s);
              except
                try
                  Thread.OutboundClient.Disconnect;
                except
                  ;
                end;
              end;
            end;

          tmDisconnect:
            begin
              Thread.DisconnectedOnRequest := True;
              try
                Thread.OutboundClient.Disconnect;
              except
                ;
              end;
            end;

        end;

      end;
    finally
      Thread.Locker.Leave;
    end;
  end;
 }
end;

 { constructor MClientThread.Create(master: TIdTunnelMaster);
 }
function NewClientThread (master: TIdTunnelMaster):PMClientThread;
begin
New( Result, Create );
with Result^ do
begin
//  MasterParent := master;
//  FreeOnTerminate := True;
  DisconnectedOnRequest := False;
  SelfDisconnected := False;
  Locker := TCriticalSection.Create;
//  MasterParent.Clients.Add(self);
  master.SetStatistics(NumberOfServicesType, Integer(soIncrease));

//  inherited Create(True);
end;
end;

destructor MClientThread.Destroy;
// virtual;
  var
  Header: TIdHeader;
begin
//  MasterParent.SetStatistics(NumberOfServicesType, Integer(soDecrease));

//  MasterParent.Clients.Remove(self);
  try
    if not DisconnectedOnRequest then
    begin
      try
        Header.MsgType := tmDisconnect;
        Header.UserId := UserId;
//        MasterParent.SendMsg(MasterThread, Header, RSTunnelDisconnectMsg);
      except
        ;
      end;
    end;

    if OutboundClient.Connected then
      OutboundClient.Disconnect;

  except
    ;
  end;

//  MasterThread := nil;

  try
    OutboundClient.Free;
  except
    ;
  end;

  Locker.Free;

  Terminate;

  inherited Destroy;
end;

{procedure MClientThread.Execute;
var
  s: string;
  Header: TIdHeader;
begin
  try
    while not Terminated do
    begin

      if OutboundClient.Connected then
      begin
        if OutboundClient.Binding.Readable(IdTimeoutInfinite) then
        begin
          s := OutboundClient.CurrentReadBuffer;
          try
            Header.MsgType := tmData;
            Header.UserId := UserId;
            MasterParent.SendMsg(MasterThread, Header, s);
          except
            Terminate;
            break;
          end;
        end;
      end
      else
      begin
        Terminate;
        break;
      end;

    end;
  except
    ;
  end;

  Locker.Enter;
  try
    SelfDisconnected := True;
  finally
    Locker.Leave;
  end;

end;}

function NewMClientThread(master: PObj{TIdTunnelMaster}):PMClientThread;
begin
New( Result, Create );
end;

function NewSlaveData:PSlaveData;
begin
New( Result, Create );
end;

end.
