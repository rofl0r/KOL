// 30-nov-2002
unit IdTunnelSlave;

interface

uses KOL, 
  SysUtils { , Classes } , SyncObjs,
  IdTunnelCommon, IdTCPServer, IdTCPClient,
  IdGlobal, IdStack, IdResourceStrings,
  IdThread, IdComponent, IdTCPConnection;

type
//  TSlaveThread = object(TObj);
//PSlaveThread=^TSlaveThread;

//  TIdTunnelSlave = object(TObj);
//PlaveThread=^SlaveThread; type  MyStupid3137=DWord;

  TTunnelEvent = procedure(Thread: PObj{TSlaveThread}) of object;

  TClientData = object
  (TObj)public
    Id: Integer;
    TimeOfConnection: TDateTime;
    DisconnectedOnRequest: Boolean;
    SelfDisconnected: Boolean;
    ClientAuthorised: Boolean;
    Locker: TCriticalSection;
    Port: Word;
    IpAddr: TIdInAddr;
     { constructor Create;
     } destructor Destroy; 
   virtual; end;
PClientData=^TClientData;
function NewClientData:PClientData;
type

  TSlaveThread = object(TIdThread)
  private
    FLock: TCriticalSection;
    FExecuted: Boolean;
    FConnection: TIdTCPClient;
  protected
    procedure SetExecuted(Value: Boolean);
    function GetExecuted: Boolean;
    procedure AfterRun; virtual;//override;
    procedure BeforeRun;  virtual;//override;
  public
//    SlaveParent: TIdTunnelSlave;
    Receiver: TReceiver;
    property Executed: Boolean read GetExecuted write SetExecuted;
    property Connection: TIdTCPClient read fConnection;
     { constructor Create(Slave: TIdTunnelSlave);  }// reintroduce;
    destructor Destroy; 
     virtual;
     //procedure Execute; override;
    procedure Run;  virtual;//override;
  end;
PSlaveThread=^TSlaveThread;
function NewSlaveThread(Slave: {TIdTunnelSlave}PObj):PSlaveThread;
type

  TIdTunnelSlave = object(TIdTCPServer)
  private
    fiMasterPort: Integer;
    fsMasterHost: string;
    SClient: TIdTCPClient;
//    fOnDisconnect: TIdServerThreadEvent;
//    fOnStatus: TIdStatusEvent;
//    fOnBeforeTunnelConnect: TSendTrnEventC;
//    fOnTransformRead: TTunnelEventC;
//    fOnInterpretMsg: TSendMsgEventC;
//    fOnTransformSend: TSendTrnEventC;
    fOnTunnelDisconnect: TTunnelEvent;

    Sender: TSender;
    OnlyOneThread: TCriticalSection;
    SendThroughTunnelLock: TCriticalSection;
    GetClientThreadLock: TCriticalSection;
    StatisticsLocker: TCriticalSection;
    ManualDisconnected: Boolean;
    StopTransmiting: Boolean;
    fbActive: Boolean;
    fbSocketize: Boolean;
    SlaveThread: TSlaveThread;
    fLogger: TLogger;
    flConnectedClients,
      fNumberOfConnectionsValue,
      fNumberOfPacketsValue,
      fCompressionRatioValue,
      fCompressedBytes,
      fBytesRead,
      fBytesWrite: Integer;

    SlaveThreadTerminated: Boolean;

    procedure SendMsg(var Header: TIdHeader; s: string);
    procedure ClientOperation(Operation: Integer; UserId: Integer; s: string);
    procedure DisconectAllUsers;
    function GetNumClients: Integer;
    procedure TerminateTunnelThread;
    function GetClientThread(UserID: Integer): TIdPeerThread;
//    procedure OnTunnelThreadTerminate(Sender: TObject);
  protected
    fbAcceptConnections: Boolean;
    procedure DoConnect(Thread: TIdPeerThread); virtual;//override;
    procedure DoDisconnect(Thread: TIdPeerThread); virtual;//override;
    function DoExecute(Thread: TIdPeerThread): boolean; virtual;//override;
    procedure DoBeforeTunnelConnect(var Header: TIdHeader; var CustomMsg:
      string); virtual;
    procedure DoTransformRead(Receiver: TReceiver); virtual;
    procedure DoInterpretMsg(var CustomMsg: string); virtual;
    procedure DoTransformSend(var Header: TIdHeader; var CustomMsg: string);
      virtual;
//    procedure DoStatus(Sender: PControl; const sMsg: string); virtual;
    procedure DoTunnelDisconnect(Thread: TSlaveThread); virtual;
    procedure LogEvent(Msg: string);
    procedure SetActive(pbValue: Boolean); virtual;//override;
  public
    procedure SetStatistics(Module: Integer; Value: Integer);
    procedure GetStatistics(Module: Integer; var Value: Integer);
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; property Active: Boolean read FbActive write SetActive;
    property Logger: TLogger read fLogger write fLogger;
    property NumClients: Integer read GetNumClients;
   { published } 
    property MasterHost: string read fsMasterHost write fsMasterHost;
    property MasterPort: Integer read fiMasterPort write fiMasterPort;
    property Socks4: Boolean read fbSocketize write fbSocketize default False;
    property OnDisconnect: TIdServerThreadEvent read FOnDisconnect write
      FOnDisconnect;
//    property OnBeforeTunnelConnect: TSendTrnEventC read fOnBeforeTunnelConnect
//    write fOnBeforeTunnelConnect;
//    property OnTransformRead: TTunnelEventC read fOnTransformRead
//    write fOnTransformRead;
//    property OnInterpretMsg: TSendMsgEventC read fOnInterpretMsg write
//      fOnInterpretMsg;
//    property OnTransformSend: TSendTrnEventC read fOnTransformSend write
//      fOnTransformSend;
    property OnStatus: TIdStatusEvent read FOnStatus write FOnStatus;
    property OnTunnelDisconnect: TTunnelEvent read FOnTunnelDisconnect write
      FOnTunnelDisconnect;
  end;
PIdTunnelSlave=^TIdTunnelSlave;
function NewIdTunnelSlave(AOwner: PControl):PIdTunnelSlave;

implementation

uses
  {IdException,}
  IdSocks;

//constructor TIdTunnelSlave.Create(AOwner: TComponent);
function NewIdTunnelSlave(AOwner: PControl):PIdTunnelSlave;
begin
New( Result, Create );
with Result^ do
begin
//  inherited;
  fbActive := False;
  flConnectedClients := 0;
  fNumberOfConnectionsValue := 0;
  fNumberOfPacketsValue := 0;
  fCompressionRatioValue := 0;
  fCompressedBytes := 0;
  fBytesRead := 0;
  fBytesWrite := 0;

  fbAcceptConnections := True;
  SlaveThreadTerminated := False;
  OnlyOneThread := TCriticalSection.Create;
  SendThroughTunnelLock := TCriticalSection.Create;
  GetClientThreadLock := TCriticalSection.Create;
  StatisticsLocker := TCriticalSection.Create;

//  Sender := TSender.Create;
//  SClient := TIdTCPClient.Create(nil);
//  SClient.OnStatus := self.OnStatus;

  ManualDisconnected := False;
  StopTransmiting := False;
 end;
end;

destructor TIdTunnelSlave.Destroy;
begin

  fbAcceptConnections := False;
  StopTransmiting := True;
  ManualDisconnected := True;

  Active := False;

  try
    if SClient.Connected then
    begin
      SClient.Disconnect;
    end;
  except
    ;
  end;

  if not SlaveThreadTerminated then
    TerminateTunnelThread;

  FreeAndNil(SClient);
  FreeAndNil(Sender);
  FreeAndNil(OnlyOneThread);
  FreeAndNil(SendThroughTunnelLock);
  FreeAndNil(GetClientThreadLock);
  FreeAndNil(StatisticsLocker);
//  Logger := nil;

  inherited Destroy;
end;

procedure TIdTunnelSlave.LogEvent(Msg: string);
begin
//  if Assigned(fLogger) then
//    fLogger.LogEvent(Msg);
end;

(*procedure TIdTunnelSlave.DoStatus(Sender: PControl {TComponent}; const sMsg: string);
begin
  if Assigned(OnStatus) then
    OnStatus(self, hsText, sMsg);
end;*)

procedure TIdTunnelSlave.SetActive(pbValue: Boolean);
var
  ErrorConnecting: Boolean;
begin
  if OnlyOneThread = nil then
  begin
    exit;
  end;

  OnlyOneThread.Enter;
  try

    if fbActive = pbValue then
    begin
      exit;
    end;

    if pbValue then
    begin
      ManualDisconnected := False;
      StopTransmiting := False;
      ErrorConnecting := False;
      SClient.Host := fsMasterHost;
      SClient.Port := fiMasterPort;
      try
        SClient.Connect;
      except
        fbActive := False;
//        raise
//          EIdEIdTunnelConnectToMasterFailed.Create(RSTunnelConnectToMasterFailed);
      end;
      if not ErrorConnecting then
      begin
//        SlaveThread := TSlaveThread.Create(self);
        SlaveThreadTerminated := False;
        SlaveThread.Start;
        try
          inherited SetActive(True);
          fbActive := True;
          fbAcceptConnections := True;
        except
          StopTransmiting := False;
          DisconectAllUsers;
          SClient.Disconnect;
          TerminateTunnelThread;
          fbActive := False;
        end;
      end;
    end
    else
    begin
      fbAcceptConnections := False;
      StopTransmiting := True;
      ManualDisconnected := True;
      inherited SetActive(False);

      DisconectAllUsers;
      SClient.Disconnect;
      TerminateTunnelThread;

      fbActive := pbValue;
    end;

  finally
    OnlyOneThread.Leave;
  end;

end;

function TIdTunnelSlave.GetNumClients: Integer;
var
  ClientsNo: Integer;
begin
  GetStatistics(NumberOfClientsType, ClientsNo);
  Result := ClientsNo;
end;

procedure TIdTunnelSlave.SetStatistics(Module: Integer; Value: Integer);
var
  packets: Real;
  ratio: Real;
begin
  StatisticsLocker.Enter;
  try
    case Module of
      NumberOfClientsType:
        begin
          if TIdStatisticsOperation(Value) = soIncrease then
          begin
            Inc(flConnectedClients);
            Inc(fNumberOfConnectionsValue);
          end
          else
          begin
            Dec(flConnectedClients);
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

procedure TIdTunnelSlave.GetStatistics(Module: Integer; var Value: Integer);
begin
  StatisticsLocker.Enter;
  try
    case Module of

      NumberOfClientsType:
        begin
          Value := flConnectedClients;
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

procedure TIdTunnelSlave.DoConnect(Thread: TIdPeerThread);
const
  MAXLINE = 255;
var
  SID: Integer;
  s: string;
  req: TIdSocksRequest;
  res: TIdSocksResponse;
  numread: Integer;
  Header: TIdHeader;
begin

  if not fbAcceptConnections then
  begin
    Thread.Connection.Disconnect;
//    raise EIdTunnelDontAllowConnections.Create(RSTunnelDontAllowConnections);
  end;

  SetStatistics(NumberOfClientsType, Integer(soIncrease));

//  Thread.Data := TClientData.Create;

  if fbSocketize then
  begin
    try
      Thread.Connection.ReadBuffer(req, 8);
    except
      try
        Thread.Connection.Disconnect;
      except
        ;
      end;
      Thread.Terminate;
      Exit;
    end;

    numread := 0;
    repeat
      begin
        s := Thread.Connection.ReadString(1);
        req.UserId[numread + 1] := s[1];
        Inc(numread);
      end
    until ((numread >= MAXLINE) or (s[1] = #0));
    SetLength(req.UserId, numread);

    s := GStack.TInAddrToString(req.IpAddr);

    res.Version := 0;
    res.OpCode := 90;
    res.Port := req.Port;
    res.IpAddr := req.IpAddr;
    SetString(s, PChar(@res), SizeOf(res));
    Thread.Connection.Write(s);
  end;

{  with TClientData(Thread.Data) do
  begin
    Id := Thread.Handle;
    SID := Id;
    TimeOfConnection := Now;
    DisconnectedOnRequest := False;
    if fbSocketize then
    begin
      Port := GStack.WSNToHs(req.Port);
      IpAddr := req.IpAddr;
    end
    else
    begin
      Port := self.DefaultPort;
      IpAddr.S_addr := 0;
    end;
    Header.Port := Port;
    Header.IpAddr := IpAddr;
  end;     }

  Header.MsgType := tmConnect;
  Header.UserId := SID;
  SendMsg(Header, RSTunnelConnectMsg);

end;

procedure TIdTunnelSlave.DoDisconnect(Thread: TIdPeerThread);
var
  Header: TIdHeader;
begin

  try
{    with TClientData(Thread.Data) do
    begin
      if DisconnectedOnRequest = False then
      begin
        Header.MsgType := tmDisconnect;
        Header.UserId := Id;
        SendMsg(Header, RSTunnelDisconnectMsg);
      end;
    end;  }

    SetStatistics(NumberOfClientsType, Integer(soDecrease));
  except
    ;
  end;

end;

function TIdTunnelSlave.DoExecute(Thread: TIdPeerThread): boolean;
var
  user: TClientData;
  s: string;
  Header: TIdHeader;
begin
  result := true;

  if Thread.Connection.Binding.Readable(IdTimeoutInfinite) then
  begin
    s := Thread.Connection.CurrentReadBuffer;
    try
//      user := TClientData(Thread.Data);
      Header.MsgType := tmData;
      Header.UserId := user.Id;
      SendMsg(Header, s);
    except
      Thread.Connection.Disconnect;
      raise;
    end;
  end;
end;

procedure TIdTunnelSlave.SendMsg(var Header: TIdHeader; s: string);
var
  tmpString: string;
begin

  SendThroughTunnelLock.Enter;
  try
    try

      if not StopTransmiting then
      begin
        if Length(s) > 0 then
        begin
          try
            tmpString := s;
            try
              DoTransformSend(Header, tmpString);
            except
              on E: Exception do
              begin
                raise;
              end;
            end;
            if Header.MsgType = 0 then
            begin
//              raise
//                EIdTunnelTransformErrorBeforeSend.Create(RSTunnelTransformErrorBS);
            end;

            try
//              Sender.PrepareMsg(Header, PChar(@tmpString[1]),
//                Length(tmpString));
            except
              raise;
            end;

            try
              SClient.Write(Sender.Msg);
            except
              StopTransmiting := True;
              raise;
            end;
          except
            ;
            raise;
          end;
        end
      end;

    except
      SClient.Disconnect;
    end;

  finally
    SendThroughTunnelLock.Leave;
  end;

end;

procedure TIdTunnelSlave.DoBeforeTunnelConnect(var Header: TIdHeader; var
  CustomMsg: string);
begin

//  if Assigned(fOnBeforeTunnelConnect) then
//    fOnBeforeTunnelConnect(Header, CustomMsg);

end;

procedure TIdTunnelSlave.DoTransformRead(Receiver: TReceiver);
begin

//  if Assigned(fOnTransformRead) then
//    fOnTransformRead(Receiver);

end;

procedure TIdTunnelSlave.DoInterpretMsg(var CustomMsg: string);
begin

//  if Assigned(fOnInterpretMsg) then
//    fOnInterpretMsg(CustomMsg);

end;

procedure TIdTunnelSlave.DoTransformSend(var Header: TIdHeader; var CustomMsg:
  string);
begin

//  if Assigned(fOnTransformSend) then
//    fOnTransformSend(Header, CustomMsg);

end;

procedure TIdTunnelSlave.DoTunnelDisconnect(Thread: TSlaveThread);
begin

  try
    StopTransmiting := True;
    if not ManualDisconnected then
    begin
      if Active then
      begin
        Active := False;
      end;
    end;
  except
    ;
  end;

//  if Assigned(OnTunnelDisconnect) then
//    OnTunnelDisconnect(Thread);

end;

{procedure TIdTunnelSlave.OnTunnelThreadTerminate(Sender: TObject);
begin
  SlaveThreadTerminated := True;
end;}

function TIdTunnelSlave.GetClientThread(UserID: Integer): TIdPeerThread;
var
  user: TClientData;
  Thread: TIdPeerThread;
  i: integer;
begin
{
  Result := nil;
  with Threads.LockList do
  try
    try
      for i := 0 to Count - 1 do
      begin
        try
          if Assigned(Items[i]) then
          begin
            Thread := TIdPeerThread(Items[i]);
            if Assigned(Thread.Data) then
            begin
              user := TClientData(Thread.Data);
              if user.Id = UserID then
              begin
                Result := Thread;
                break;
              end;
            end;
          end;
        except
          Result := nil;
        end;
      end;
    except
      Result := nil;
    end;
  finally
    Threads.UnlockList;
  end;
 }
end;

procedure TIdTunnelSlave.TerminateTunnelThread;
begin
{
  OnlyOneThread.Enter;
  try
    if Assigned(SlaveThread) then
    begin
      if not IsCurrentThread(SlaveThread) then
      begin
        SlaveThread.TerminateAndWaitFor;
        SlaveThread.Free;
        SlaveThread := nil;
      end
      else
      begin
        SlaveThread.FreeOnTerminate := True;
      end;
    end;
  finally
    OnlyOneThread.Leave;
  end;
 }
end;

procedure TIdTunnelSlave.ClientOperation(Operation: Integer; UserId: Integer; s:
  string);
var
  Thread: TIdPeerThread;
  user: TClientData;
begin

  {if not StopTransmiting then
  begin

    Thread := GetClientThread(UserID);
    if Assigned(Thread) then
    begin
      try
        case Operation of
          1:
            begin
              try
                if Thread.Connection.Connected then
                begin
                  try
                    Thread.Connection.Write(s);
                  except
                    ;
                  end;
                end;
              except
                try
                  Thread.Connection.Disconnect;
                except
                end;
              end;
            end;

          2:
            begin
              user := TClientData(Thread.Data);
              user.DisconnectedOnRequest := True;
              Thread.Connection.Disconnect;
            end;
        end;

      except
        ;
      end;
    end
    else
    begin
      ;
    end;

  end;
   }
end;

procedure TIdTunnelSlave.DisconectAllUsers;
begin
  TerminateAllThreads;
end;

function NewClientData:PClientData;
//constructor TClientData.Create;
begin
New( Result, Create );
with Result^ do
begin
  Locker := TCriticalSection.Create;
  SelfDisconnected := False;
end;
end;

destructor TClientData.Destroy;
begin
  Locker.Free;
  inherited;
end;

function NewSlaveThread(Slave: {TIdTunnelSlave}PObj):PSlaveThread;
//constructor TSlaveThread.Create(Slave: TIdTunnelSlave);
begin
New( Result, Create );
with Result^ do
begin
{  SlaveParent := Slave;
  FreeOnTerminate := False;
  FExecuted := False;
  FConnection := Slave.SClient;
  OnTerminate := Slave.OnTunnelThreadTerminate;
  FLock := TCriticalSection.Create;
  Receiver := TReceiver.Create;
  inherited Create(True);
  StopMode := smTerminate;}
end;
end;

destructor TSlaveThread.Destroy;
begin
  Connection.Disconnect;
  Receiver.Free;
  FLock.Destroy;
  inherited Destroy;
end;

procedure TSlaveThread.SetExecuted(Value: Boolean);
begin
  FLock.Enter;
  try
    FExecuted := Value;
  finally
    FLock.Leave;
  end;
end;

function TSlaveThread.GetExecuted: Boolean;
begin
  FLock.Enter;
  try
    Result := FExecuted;
  finally
    FLock.Leave;
  end;
end;

{procedure TSlaveThread.Execute;
begin
  inherited;
  Executed := True;
end;}

procedure TSlaveThread.Run;
var
  Header: TIdHeader;
  s: string;
  CustomMsg: string;
begin
{  try
    if Connection.Binding.Readable(IdTimeoutInfinite) then
    begin
      Receiver.Data := Connection.CurrentReadBuffer;

      SlaveParent.SetStatistics(NumberOfPacketsType, 0);

      while (Receiver.TypeDetected) and (not Terminated) do
      begin
        if Receiver.NewMessage then
        begin
          if Receiver.CRCFailed then
          begin
            raise EIdTunnelCRCFailed.Create(RSTunnelCRCFailed);
          end;

          try
            SlaveParent.DoTransformRead(Receiver);
          except
            raise EIdTunnelTransformError.Create(RSTunnelTransformError);
          end;

          case Receiver.Header.MsgType of
            0:
              begin
                SlaveParent.ManualDisconnected := False;
                raise
                  EIdTunnelMessageTypeRecognitionError.Create(RSTunnelMessageTypeError);
              end;

            1:
              begin
                try
                  SetString(s, Receiver.Msg, Receiver.MsgLen);
                  SlaveParent.ClientOperation(1, Receiver.Header.UserId, s);
                except
                  raise
                    EIdTunnelMessageHandlingFailed.Create(RSTunnelMessageHandlingError);
                end;
              end;

            2:
              begin
                try
                  SlaveParent.ClientOperation(2, Receiver.Header.UserId, '');
                except
                  raise
                    EIdTunnelMessageHandlingFailed.Create(RSTunnelMessageHandlingError);
                end;
              end;

            99:
              begin
                CustomMsg := '';
                SetString(CustomMsg, Receiver.Msg, Receiver.MsgLen);
                try
                  try
                    SlaveParent.DoInterpretMsg(CustomMsg);
                  except
                    raise
                      EIdTunnelInterpretationOfMessageFailed.Create(RSTunnelMessageInterpretError);
                  end;
                  if Length(CustomMsg) > 0 then
                  begin
                    Header.MsgType := 99;
                    Header.UserId := 0;
                    SlaveParent.SendMsg(Header, CustomMsg);
                  end;
                except
                  SlaveParent.ManualDisconnected := False;
                  raise
                    EIdTunnelCustomMessageInterpretationFailure.Create(RSTunnelMessageCustomInterpretError);
                end;

              end;

          end;

          Receiver.ShiftData;

        end
        else
          break;

      end;
    end;
  except
    on E: EIdSocketError do
    begin
      case E.LastError of
        10054: Connection.Disconnect;
      else
        begin
          Terminate;
        end;
      end;
    end;
    on EIdClosedSocket do ;
  else
    raise;
  end;
  if not Connection.Connected then
    Terminate;}
end;

procedure TSlaveThread.AfterRun;
begin
//  SlaveParent.DoTunnelDisconnect(self);
end;

procedure TSlaveThread.BeforeRun;
var
  Header: TIdHeader;
  tmpString: string;
begin
{  tmpString := '';
  try
    SlaveParent.DoBeforeTunnelConnect(Header, tmpString);
  except
    ;
  end;
  if Length(tmpString) > 0 then
  begin
    Header.MsgType := 99;
    Header.UserId := 0;
    SlaveParent.SendMsg(Header, tmpString);
  end;
 }
end;

end.
