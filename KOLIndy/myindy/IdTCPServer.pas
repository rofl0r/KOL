// 27-nov-2002
unit IdTCPServer;

interface

uses KOL ,KOLClasses{ ,
  Classes } ,
  IdComponent{, IdException}, IdSocketHandle, IdTCPConnection, IdThread,
    IdThreadMgr, IdThreadMgrDefault,
  IdIntercept;

type
  TOperation = (opInsert, opRemove);

{  TIdTCPServer = object(TObj)
  end;

PIdTCPServer=^TIdTCPServer;
type}

  TIdListenerThread = object(TIdThread)
  protected
    FAcceptWait: Integer;
    FBindingList: PList;//TList;
    FServer,FAServer: PObj;//TIdTCPServer;
  public
    procedure Init; virtual;
    procedure AfterRun; virtual;// override;
     { constructor Create(axServer: TIdTCPServer);  }// reintroduce;
    destructor Destroy;
     virtual; procedure Run; virtual;// override;

    property AcceptWait: integer read FAcceptWait write FAcceptWait;
    property Server: {TIdTCPServer}PObj read FServer;
  end;
PIdListenerThread=^TIdListenerThread;
//function NewIdListenerThread(axServer: PIdTCPServer):PIdListenerThread;
//type

  TIdTCPServerConnection = object(TIdTCPConnection)
  protected
    function GetServer: PObj;//TIdTCPServer;
  public
   { published }
   procedure Init; virtual;
    property Server: {TIdTCPServer}PObj read GetServer;
  end;

PIdTCPServerConnection=^TIdTCPServerConnection;
function NewIdTCPServerConnection(AOwner: PObj):PIdTCPServerConnection;
 type

  TIdPeerThread = object(TIdThread)
  protected
    FConnection: PIdTCPServerConnection;//TIdTCPServerConnection;

    procedure AfterRun; virtual;// override;
    procedure BeforeRun; virtual;// override;
  public
    procedure Run; virtual;//override;
    property Connection: PIdTCPServerConnection{TIdTCPServerConnection} read FConnection;
  end;
PIdPeerThread=^TIdPeerThread; type

  TIdServerThreadEvent = procedure(AThread: PIdPeerThread{TIdPeerThread}) of object;

  TIdTCPServer = object(TIdComponent)
  protected
    FAcceptWait: integer;
    FActive, FImplicitThreadMgrCreated: Boolean;
    FThreadMgr: PIdThreadMgr;//TIdThreadMgr;
    FBindings: PIdSocketHandles;//TIdSocketHandles;
    FListenerThread: PIdListenerThread;//TIdListenerThread;
    FTerminateWaitTime: Integer;
//    FThreadClass: TIdThreadClass;
    FThreads: PThreadList;//TThreadList;
    FOnExecute, FOnConnect, FOnDisconnect: TIdServerThreadEvent;

    FIntercept: PIdServerIntercept;//TIdServerIntercept;
    procedure DoConnect(axThread: PIdPeerThread{TIdPeerThread}); virtual;
    procedure DoDisconnect(axThread: PIdPeerThread{TIdPeerThread}); virtual;
    function DoExecute(AThread:PIdPeerThread {TIdPeerThread}): boolean; virtual;
    function GetDefaultPort: integer;
    procedure Notification(AComponent: PObj{TComponent}; Operation: TOperation); virtual;//     override;
    procedure SetAcceptWait(AValue: integer);
    procedure SetActive(AValue: Boolean); virtual;
    procedure SetBindings(const abValue: PIdSocketHandles{TIdSocketHandles});
    procedure SetDefaultPort(const AValue: integer);
    procedure SetIntercept(const Value: PIdServerIntercept{TIdServerIntercept});
    procedure SetThreadMgr(const Value: PIdThreadMgr{TIdThreadMgr});
    procedure TerminateAllThreads;
  public
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
     virtual; procedure Loaded; virtual;//override;
    property AcceptWait: integer read FAcceptWait write SetAcceptWait;
    property ImplicitThreadMgrCreated: Boolean read FImplicitThreadMgrCreated;
//    property ThreadClass: TIdThreadClass read FThreadClass write FThreadClass;
    property Threads: PThreadList{TThreadList} read FThreads;
   { published }
    property Active: boolean read FActive write SetActive default False;
    property Bindings: PIdSocketHandles{TIdSocketHandles }read FBindings write SetBindings;
    property DefaultPort: integer read GetDefaultPort write SetDefaultPort;
    property Intercept: PIdServerIntercept{TIdServerIntercept} read FIntercept write SetIntercept;
    property OnConnect: TIdServerThreadEvent read FOnConnect write FOnConnect;
    property OnExecute: TIdServerThreadEvent read FOnExecute write FOnExecute;
    property OnDisconnect: TIdServerThreadEvent read FOnDisconnect write
      FOnDisconnect;
    property TerminateWaitTime: Integer read FTerminateWaitTime write
      FTerminateWaitTime
    default 5000;
    property ThreadMgr: PIdThreadMgr{TIdThreadMgr} read FThreadMgr write SetThreadMgr;
  end;

  PIdTCPServer=^TIdTCPServer;

function NewIdListenerThread(axServer: PIdTCPServer):PIdListenerThread;
function NewIdTCPServer(AOwner: PControl):PIdTCPServer;
{ type  MyStupid27292=DWord;
  EIdTCPServerError = object(EIdException);
PdTCPServer=^IdTCPServer; type  MyStupid67165=DWord;
  EIdAcceptWaitCannotBeModifiedWhileServerIsActive = object(EIdTCPServerError);
PTCPServer=^dTCPServer; type  MyStupid31869=DWord;
  EIdNoExecuteSpecified = object(EIdTCPServerError);
PCPServer=^TCPServer; type  MyStupid16179=DWord;
 }
implementation

uses
  IdGlobal, IdResourceStrings, IdStack, IdStackConsts;

//constructor TIdTCPServer.Create(AOwner: TComponent);
function NewIdTCPServer(AOwner: PControl):PIdTCPServer;
begin
//  inherited;
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
  FAcceptWait := 1000;
  FTerminateWaitTime := 5000;
//  FThreads := TThreadList.Create;
//  FBindings := TIdSocketHandles.Create(Self);
//  FThreadClass := TIdPeerThread;
end;}
end;

destructor TIdTCPServer.Destroy;
begin
  Active := False;
  TerminateAllThreads;
  FreeAndNil(FBindings);
  FreeAndNil(FThreads);
  inherited;
end;

procedure TIdTCPServer.DoConnect(axThread: PIdPeerThread{TIdPeerThread});
begin
  if assigned(OnConnect) then
  begin
    OnConnect(axThread);
  end;
end;

procedure TIdTCPServer.DoDisconnect(axThread: PIdPeerThread{TIdPeerThread});
begin
  if assigned(OnDisconnect) then
  begin
    OnDisconnect(axThread);
  end;
end;

function TIdTCPServer.DoExecute(AThread: PIdPeerThread{TIdPeerThread}): boolean;
begin
  result := assigned(OnExecute);
  if result then
  begin
    OnExecute(AThread);
  end;
end;

function TIdTCPServer.GetDefaultPort: integer;
begin
  result := FBindings.DefaultPort;
end;

procedure TIdTCPServer.Init;
begin
  inherited;
//  with Result^ do
begin
  FAcceptWait := 1000;
  FTerminateWaitTime := 5000;
  FThreads := NewThreadList();//TThreadList.Create;
  FBindings := NewIdSocketHandles(@Self);//TIdSocketHandles.Create(Self);
//  FThreadClass := TIdPeerThread;
end;
end;

procedure TIdTCPServer.Loaded;
begin
  inherited;
  if Active then
  begin
    FActive := False;
    Active := True;
  end;
end;

procedure TIdTCPServer.Notification(AComponent: PObj{TComponent}; Operation:
  TOperation);
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if (AComponent = FThreadMgr) then
    begin
      FThreadMgr := nil;
    end
    else
      if (AComponent = FIntercept) then
    begin
      FIntercept := nil;
    end;
  end;
end;

procedure TIdTCPServer.SetAcceptWait(AValue: integer);
begin
  if Active then
  begin
//    raise
//      EIdAcceptWaitCannotBeModifiedWhileServerIsActive.Create(RSAcceptWaitCannotBeModifiedWhileServerIsActive);
  end;
  FAcceptWait := AValue;
end;

procedure TIdTCPServer.SetActive(AValue: Boolean);
var
  i: Integer;
begin
{  if (not (csDesigning in ComponentState)) and (FActive <> AValue)
    and (not (csLoading in ComponentState)) then}
  begin
    if AValue then
    begin
      if Bindings.Count = 0 then
      begin
        Bindings.Add;
      end;

      for i := 0 to Bindings.Count - 1 do
      begin
        with Bindings.Items[i]^ do
        begin
          AllocateSocket;
          SetSockOpt(Id_SOL_SOCKET, Id_SO_REUSEADDR, PChar(@Id_SO_True),
            SizeOf(Id_SO_True));
          Bind;
          Listen;
        end;
      end;

      FImplicitThreadMgrCreated := not assigned(ThreadMgr);
      if ImplicitThreadMgrCreated then
      begin
        ThreadMgr := NewIdThreadMgrDefault(@Self);//TIdThreadMgrDefault.Create(Self);
      end;
//      ThreadMgr.ThreadClass := ThreadClass;
      FListenerThread := NewIdListenerThread(@Self);//TIdListenerThread.Create(Self);
      FListenerThread.AcceptWait := AcceptWait;
      FListenerThread.Start;
    end
    else
    begin
      FListenerThread.Stop;
      for i := 0 to Bindings.Count - 1 do
      begin
        Bindings.Items[i].CloseSocket(False);
      end;
      TerminateAllThreads;
      if ImplicitThreadMgrCreated then
      begin
        FreeAndNil(FThreadMgr);
      end;
      FImplicitThreadMgrCreated := false;

      FListenerThread.WaitFor;
      FListenerThread.Free;
    end;
  end;
  FActive := AValue;
end;

procedure TIdTCPServer.SetBindings(const abValue: PIdSocketHandles{TIdSocketHandles});
begin
  FBindings.Assign(abValue);
end;

procedure TIdTCPServer.SetDefaultPort(const AValue: integer);
begin
  FBindings.DefaultPort := AValue;
end;

procedure TIdTCPServer.SetIntercept(const Value: PIdServerIntercept{TIdServerIntercept});
begin
  FIntercept := Value;
  if assigned(FIntercept) then
  begin
//    FIntercept.FreeNotification(@Self);
  end;
end;

procedure TIdTCPServer.SetThreadMgr(const Value: PIdThreadMgr{TIdThreadMgr});
begin
  FThreadMgr := Value;
  if Value <> nil then
  begin
//    Value.FreeNotification(@self);
  end;
end;

procedure TIdTCPServer.TerminateAllThreads;
var
  i: integer;
  list: PList;//TList;
  Thread: PIdPeerThread;//TIdPeerThread;
const
  LSleepTime: integer = 250;
begin
  list := Threads.LockList;
  try
    for i := 0 to list.Count - 1 do
    begin
      Thread := PIdPeerThread{TIdPeerThread}(list.items[i]);
      Thread.Connection.DisconnectSocket;
    end;
  finally{ Threads.UnlockList};
  end;
  for i := 1 to (TerminateWaitTime div LSleepTime) do
  begin
    Sleep(LSleepTime);
    list := Threads.LockList;
    try
      if list.Count = 0 then
      begin
        break;
      end;
    finally {Threads.UnlockList};
    end;
  end;
end;

procedure TIdListenerThread.AfterRun;
var
  i: Integer;
begin
  inherited;
  for i := PIdTCPServer(Server).Bindings.Count - 1 downto 0 do
  begin
    PIdTCPServer(Server).Bindings.Items[i].CloseSocket;
  end;
end;

//constructor TIdListenerThread.Create(axServer: TIdTCPServer);
function NewIdListenerThread(axServer: PIdTCPServer):PIdListenerThread;
begin
//  inherited Create;
New( Result, Create );
Result.FAServer:=axServer;
Result.Init;
{with Result^ do
begin
  FBindingList := NewList();//TList.Create;
  FServer := axServer;
end;   }
end;

destructor TIdListenerThread.Destroy;
begin
  FBindinglist.Free;
  inherited;
end;

procedure TIdListenerThread.Init;
begin
  inherited;
//with Result^ do
//begin
  FBindingList := NewList();//TList.Create;
  FServer := FAServer;//axServer;
//end;
end;

procedure TIdListenerThread.Run;
var
  Peer: PIdTCPServerConnection;//TIdTCPServerConnection;
  Thread: PIdPeerThread;//TIdPeerThread;
  i: Integer;
begin
  FBindingList.Clear;
  for i := 0 to PIdTCPServer(Server).Bindings.Count - 1 do
  begin
    FBindingList.Add({TObject}PObj(PIdTCPServer(Server).Bindings.Items[i].Handle));
  end;
  if GStack.WSSelect(FBindingList, nil, nil, AcceptWait) > 0 then
  begin
    if not Terminated then
    begin
      for i := 0 to FBindingList.Count - 1 do
      begin
        Peer := NewIdTCPServerConnection(@Self);//TIdTCPServerConnection.Create(Server);
        with Peer^ do
        begin
          Binding.Accept(TIdStackSocketHandle(FBindingList.Items[i]));
          if Assigned(PIdTCPServer(Server).Intercept) then
          begin
            try
              Peer.Intercept := PIdTCPServer(Server).Intercept.Accept(Binding);
              Peer.InterceptEnabled := True;
            except
              FreeAndNil(Peer);
            end;
          end;
        end;
        if Peer <> nil then
        begin
          Thread :=PIdPeerThread(PIdTCPServer(Server).ThreadMgr.GetThread);// TIdPeerThread(Server.ThreadMgr.GetThread);
          Thread.FConnection := Peer;
          PIdTCPServer(Server).Threads.Add(Thread);
          Thread.Start;
        end;
      end;
    end;
  end;
end;

function TIdTCPServerConnection.GetServer: PObj;//TIdTCPServer;
begin
  result := PIdTCPServer(FOwner);// as TIdTCPServer;
end;

procedure TIdPeerThread.AfterRun;
begin
  with PIdTCPServer(Connection.Server)^ do
  begin
    DoDisconnect(@Self);
    ThreadMgr.ReleaseThread(@Self);
    Threads.Remove(@Self);
  end;
  FreeAndNil(FConnection);
end;

procedure TIdPeerThread.BeforeRun;
begin
  PIdTCPServer(Connection.Server).DoConnect(@Self);
end;

procedure TIdPeerThread.Run;
begin
 // try
    if not PIdTCPServer(Connection.Server).DoExecute(@Self) then
    begin
//      raise EIdNoExecuteSpecified.Create(RSNoExecuteSpecified);
    end;
  {except
    on E: EIdSocketError do
    begin
      case E.LastError of
        Id_WSAECONNABORTED,
          Id_WSAECONNRESET:
          Connection.Disconnect;
      end;
    end;
    on EIdClosedSocket do ;
  else
    raise;
  end;  }
  if not Connection.Connected then
  begin
    Stop;
  end;
end;

function NewIdTCPServerConnection(AOwner: PObj):PIdTCPServerConnection;
begin
  New( Result, Create );
  Result.Init;
end;

procedure TIdTCPServerConnection.Init;
begin
  inherited;
end;

end.
