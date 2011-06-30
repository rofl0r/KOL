{ *********************************************************************** }
{                                                                         }
{ Delphi Runtime Library  (for KOL)                                       }
{                                                                         }
{ Copyright (c) 1997-2001 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

{*******************************************************}
{       Windows socket components                       }
{*******************************************************}

{*******************************************************}
{       Адаптировал для библиотеки KOL MCK  (v.1.71)    }
{          Сапронов Алексей Владимирович  (Savva)       }
{          http://null.wallst.ru                        }
{          e-mail: savva@nm.ru                          }
{*******************************************************}

{*******************************************************}
{      Новости:                                         }
{  13.04.2003.                                          }
{  после изменения файла err.pas (у меня была старая    }
{  версия) пришлось пересобирать. Спасибо LEAn (Minsk)  }
{                                                       }
{*******************************************************}

unit KOLScktComp;

interface

uses Windows, Messages, kol, err,{Objects,}WinSock,KOLSyncObjs;

const
  CM_SOCKETMESSAGE = WM_USER + $0001;
  CM_DEFERFREE = WM_USER + $0002;
  CM_LOOKUPCOMPLETE = WM_USER + $0003;

type
  twndmethod=procedure(var message:tmessage) of object;
  ESocketError = class(Exception);

  TCMSocketMessage = record
    Msg: Cardinal;
    Socket: TSocket;
    SelectEvent: Word;
    SelectError: Word;
    Result: Longint;
  end;

  TCMLookupComplete = record
    Msg: Cardinal;
    LookupHandle: THandle;
    AsyncBufLen: Word;
    AsyncError: Word;
    Result: Longint;
  end;

  PCustomWinSocket = ^TCustomWinSocket;
//  TCustomSocket = class;
  PServerAcceptThread    = ^TServerAcceptThread;
  PServerClientThread    = ^TServerClientThread;
  PServerWinSocket       = ^TServerWinSocket;
  PServerClientWinSocket = ^TServerClientWinSocket;
  PClientWinSocket = ^TClientWinSocket;


  TServerType = (stNonBlocking, stThreadBlocking);
  TClientType = (ctNonBlocking, ctBlocking);
  TAsyncStyle = (asRead, asWrite, asOOB, asAccept, asConnect, asClose);
  TAsyncStyles = set of TAsyncStyle;
  TSocketEvent = (seLookup, seConnecting, seConnect, seDisconnect, seListen,
    seAccept, seWrite, seRead);
  TLookupState = (lsIdle, lsLookupAddress, lsLookupService);
  TErrorEvent = (eeGeneral, eeSend, eeReceive, eeConnect, eeDisconnect, eeAccept, eeLookup);

  TSocketEventEvent = procedure (Sender: PObj; Socket: PCustomWinSocket;
    SocketEvent: TSocketEvent) of object;
  TSocketErrorEvent = procedure (Sender: PObj; Socket: PCustomWinSocket;
    ErrorEvent: TErrorEvent; var ErrorCode: Integer) of object;
  TGetSocketEvent = procedure (Sender: PObj; Socket: TSocket;
    var ClientSocket: PServerClientWinSocket) of object;
  TGetThreadEvent = procedure (Sender: PObj; ClientSocket: PServerClientWinSocket;
    var SocketThread: PServerClientThread) of object;
  TSocketNotifyEvent = procedure (Sender: PObj; Socket: PCustomWinSocket) of object;

  TCustomWinSocket = object
  private
    FSocket: TSocket;
    FConnected: Boolean;
    FSendStream: PStream;
    FDropAfterSend: Boolean;
    FHandle: HWnd;
    FAddr: TSockAddrIn;
    FAsyncStyles: TASyncStyles;
    FLookupState: TLookupState;
    FLookupHandle: THandle;
    FOnSocketEvent: TSocketEventEvent;
    FOnErrorEvent: TSocketErrorEvent;
    FSocketLock: PCriticalSection;
    FGetHostData: Pointer;
    FData: Pointer;
    // Used during non-blocking host and service lookups
    FService: string;
    FPort: Word;
    FClient: Boolean;
    FQueueSize: Integer;
    function SendStreamPiece: Boolean;
    procedure WndProc(var Message: TMessage);
    procedure CMLookupComplete(var Message: TCMLookupComplete);
    procedure CMSocketMessage(var Message: TCMSocketMessage); 
    procedure CMDeferFree(var Message);
    procedure DeferFree;
    procedure DoSetAsyncStyles;
    function GetHandle: HWnd;
    function GetLocalHost: string;
    function GetLocalAddress: string;
    function GetLocalPort: Integer;
    function GetRemoteHost: string;
    function GetRemoteAddress: string;
    function GetRemotePort: Integer;
    function GetRemoteAddr: TSockAddrIn;
  protected
    procedure AsyncInitSocket(const Name, Address, Service: string; Port: Word;
      QueueSize: Integer; Client: Boolean);
    procedure DoOpen;
    procedure DoListen(QueueSize: Integer);
    function InitSocket(const Name, Address, Service: string; Port: Word;
      Client: Boolean): TSockAddrIn;
    procedure Event(Socket: PCustomWinSocket; SocketEvent: TSocketEvent);// dynamic;
    procedure Error(Socket: PCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer); //dynamic;
    procedure SetAsyncStyles(Value: TASyncStyles);
  public
    constructor Create(ASocket: TSocket);
    destructor Destroy; //override;
    procedure Close;
    procedure DefaultHandler(var Message); //override;
    procedure Lock;
    procedure Unlock;
    procedure Listen(const Name, Address, Service: string; Port: Word;
      QueueSize: Integer; Block: Boolean = True);
    procedure Open(const Name, Address, Service: string; Port: Word; Block: Boolean = True);
    procedure Accept(Socket: TSocket); virtual;
    procedure Connect(Socket: TSocket); virtual;
    procedure Disconnect(Socket: TSocket); virtual;
    procedure Read(Socket: TSocket); virtual;
    procedure Write(Socket: TSocket); virtual;
    function LookupName(const name: string): TInAddr;
    function LookupService(const service: string): Integer;

    function ReceiveLength: Integer;
    function ReceiveBuf(var Buf; Count: Integer): Integer;
    function ReceiveText: string;
    function SendBuf(var Buf; Count: Integer): Integer;
    function SendStream(AStream: PStream): Boolean;
    function SendStreamThenDrop(AStream: PStream): Boolean;
    function SendText(const S: string): Integer;

    property LocalHost: string read GetLocalHost;
    property LocalAddress: string read GetLocalAddress;
    property LocalPort: Integer read GetLocalPort;

    property RemoteHost: string read GetRemoteHost;
    property RemoteAddress: string read GetRemoteAddress;
    property RemotePort: Integer read GetRemotePort;
    property RemoteAddr: TSockAddrIn read GetRemoteAddr;

    property Connected: Boolean read FConnected;
    property Addr: TSockAddrIn read FAddr;
    property ASyncStyles: TAsyncStyles read FAsyncStyles write SetAsyncStyles;
    property Handle: HWnd read GetHandle;
    property SocketHandle: TSocket read FSocket;
    property LookupState: TLookupState read FLookupState;

    property OnSocketEvent: TSocketEventEvent read FOnSocketEvent write FOnSocketEvent;
    property OnErrorEvent: TSocketErrorEvent read FOnErrorEvent write FOnErrorEvent;

    property Data: Pointer read FData write FData;
  end;

  TClientWinSocket = object(TCustomWinSocket)
  private
    FClientType: TClientType;
  protected
    procedure SetClientType(Value: TClientType);
  public
    procedure Connect(Socket: TSocket); virtual;
    property ClientType: TClientType read FClientType write SetClientType;
  end;

  TServerClientWinSocket = object(TCustomWinSocket)
  private
    FServerWinSocket: PServerWinSocket;
  public
    constructor Create(Socket: TSocket; ServerWinSocket_: PServerWinSocket);
    destructor Destroy; virtual;

    property ServerWinSocket: PServerWinSocket read FServerWinSocket;
  end;
 
  TThreadNotifyEvent = procedure (Sender: PObj;
    Thread: PServerClientThread) of object;

  TServerWinSocket = object(TCustomWinSocket)
  private
    FServerType: TServerType;
    FThreadCacheSize: Integer;
    FConnections: PList;
    FActiveThreads: PList;
    FListLock: PCriticalSection;

    FServerAcceptThread: PServerAcceptThread;
    FOnGetSocket: TGetSocketEvent;
    FOnGetThread: TGetThreadEvent;
    FOnThreadStart: TThreadNotifyEvent;
    FOnThreadEnd: TThreadNotifyEvent;
    FOnClientConnect: TSocketNotifyEvent;
    FOnClientDisconnect: TSocketNotifyEvent;
    FOnClientRead: TSocketNotifyEvent;
    FOnClientWrite: TSocketNotifyEvent;
    FOnClientError: TSocketErrorEvent;
    procedure AddClient(AClient: PServerClientWinSocket);
    procedure RemoveClient(AClient: PServerClientWinSocket);
    procedure AddThread(AThread: PServerClientThread);
    procedure RemoveThread(AThread: PServerClientThread);
    procedure ClientEvent(Sender: PObj; Socket: PCustomWinSocket;
      SocketEvent: TSocketEvent);
    procedure ClientError(Sender: PObj; Socket: PCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    function GetActiveConnections: Integer;
    function GetActiveThreads: Integer;
    function GetConnections(Index: Integer): PCustomWinSocket;
    function GetIdleThreads: Integer;
  protected
    function DoCreateThread(ClientSocket: PServerClientWinSocket): PServerClientThread; virtual;
    procedure Listen(var Name, Address, Service: string; Port: Word;
      QueueSize: Integer);
    procedure SetServerType(Value: TServerType);
    procedure SetThreadCacheSize(Value: Integer);
    procedure ThreadEnd(AThread: PServerClientThread); //dynamic;
    procedure ThreadStart(AThread: PServerClientThread);// dynamic;
    function GetClientSocket(Socket: TSocket): PServerClientWinSocket; //dynamic;
    function GetServerThread(ClientSocket: PServerClientWinSocket): PServerClientThread; //dynamic;
    procedure ClientRead(Socket: PCustomWinSocket); //dynamic;
    procedure ClientWrite(Socket: PCustomWinSOcket); //dynamic;
    procedure ClientConnect(Socket: PCustomWinSOcket); //dynamic;
    procedure ClientDisconnect(Socket: PCustomWinSOcket); //dynamic;
    procedure ClientErrorEvent(Socket: PCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer); //dynamic;
  public
    constructor Create(ASocket: TSocket);
    destructor Destroy; //override;
    procedure Accept(Socket: TSocket); virtual;//override;
    procedure Disconnect(Socket: TSocket); virtual;//override;
    function GetClientThread(ClientSocket: PServerClientWinSocket): PServerClientThread;
    property ActiveConnections: Integer read GetActiveConnections;
    property ActiveThreads: Integer read GetActiveThreads;
    property Connections[Index: Integer]: PCustomWinSocket read GetConnections;
    property IdleThreads: Integer read GetIdleThreads;
    property ServerType: TServerType read FServerType write SetServerType;
    property ThreadCacheSize: Integer read FThreadCacheSize write SetThreadCacheSize;
    property OnGetSocket: TGetSocketEvent read FOnGetSocket write FOnGetSocket;
    property OnGetThread: TGetThreadEvent read FOnGetThread write FOnGetThread;
    property OnThreadStart: TThreadNotifyEvent read FOnThreadStart write FOnThreadStart;
    property OnThreadEnd: TThreadNotifyEvent read FOnThreadEnd write FOnThreadEnd;
    property OnClientConnect: TSocketNotifyEvent read FOnClientConnect write FOnClientConnect;
    property OnClientDisconnect: TSocketNotifyEvent read FOnClientDisconnect write FOnClientDisconnect;
    property OnClientRead: TSocketNotifyEvent read FOnClientRead write FOnClientRead;
    property OnClientWrite: TSocketNotifyEvent read FOnClientWrite write FOnClientWrite;
    property OnClientError: TSocketErrorEvent read FOnClientError write FOnClientError;
  end;

  TServerAcceptThread = object //(TThread)
  private
    FAcceptThread: PThread;
    FAcceptServerSocket: PServerWinSocket;
  public
    constructor Create(CreateSuspended: Boolean; ASocket: PServerWinSocket);
    //procedure Execute; virtual;//override;
    function Execute(Sender: PThread): integer;//; virtual;
    procedure Terminate;



    property ServerSocket: PServerWinSocket read FAcceptServerSocket;
  end;

  TServerClientThread = object//(TThread)
  private
    FClientSocket: PServerClientWinSocket;
    FServerClientThread  :PThread;
    FServerSocket: PServerWinSocket;
    FException: Exception;
    FEvent: PSimpleEvent;
    FKeepInCache: Boolean;
    FData: Pointer;

    function GetThreadPriority: Integer;
    procedure SetThreadPriority(Value: Integer);
    procedure HandleEvent(Sender: PObj; Socket: PCustomWinSocket;
      SocketEvent: TSocketEvent);
    procedure HandleError(Sender: PObj; Socket: PCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DoHandleException;
    procedure DoRead;
    procedure DoWrite;
    function GetTerminated:boolean;
  protected
    procedure DoTerminate; //override;
    function Execute(Sender: PThread): integer;// virtual;
    procedure ClientExecute; virtual;
    procedure Event(SocketEvent: TSocketEvent); virtual;
    procedure Error(ErrorEvent: TErrorEvent; var ErrorCode: Integer); virtual;
    procedure HandleException; virtual;
    procedure ReActivate(ASocket: PServerClientWinSocket);
    function StartConnect: Boolean;
    function EndConnect: Boolean;
  public
    constructor Create(CreateSuspended: Boolean; ASocket: PServerClientWinSocket);
    destructor Destroy; virtual;//override;

    procedure Terminate;
    property Terminated : boolean read GetTerminated;
    property ThreadPriority: Integer read GetThreadPriority write SetThreadPriority;

    property ClientSocket: PServerClientWinSocket read FClientSocket;
    property ServerSocket: PServerWinSocket read FServerSocket;
    property KeepInCache: Boolean read FKeepInCache write FKeepInCache;
    property Data: Pointer read FData write FData;

  end;


  TAbstractSocket = object (TObj)
  private
    FActive: Boolean;
    FPort: Integer;
    FAddress: string;
    FHost: string;
    FService: string;
    procedure DoEvent(Sender: PObj; Socket: PCustomWinSocket;
      SocketEvent: TSocketEvent);
    procedure DoError(Sender: PObj; Socket: PCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  public
    procedure Event(Socket: PCustomWinSocket; SocketEvent: TSocketEvent);
      virtual; abstract;
    procedure Error(Socket: PCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer); virtual; abstract;
    procedure DoActivate(Value: Boolean); virtual; abstract;
    procedure InitSocket(Socket: PCustomWinSocket);
    procedure Loaded; //override;
    procedure SetActive(Value: Boolean);
    procedure SetAddress(Value: string);
    procedure SetHost(Value: string);
    procedure SetPort(Value: Integer);
    procedure SetService(Value: string);
    property Active: Boolean read FActive write SetActive;
    property Address: string read FAddress write SetAddress;
    property Host: string read FHost write SetHost;
    property Port: Integer read FPort write SetPort;
    property Service: string read FService write SetService;
    procedure Open;
    procedure Close;
  end;
  PCustomSocket = ^TCustomSocket;
  TCustomSocket = object(TAbstractSocket)
  private
    FOnLookup: TSocketNotifyEvent;
    FOnConnect: TSocketNotifyEvent;
    FOnConnecting: TSocketNotifyEvent;
    FOnDisconnect: TSocketNotifyEvent;
    FOnListen: TSocketNotifyEvent;
    FOnAccept: TSocketNotifyEvent;
    FOnRead: TSocketNotifyEvent;
    FOnWrite: TSocketNotifyEvent;
    FOnError: TSocketErrorEvent;
  public
    procedure Event(Socket: PCustomWinSocket; SocketEvent: TSocketEvent); virtual;
    procedure Error(Socket: PCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer); virtual;
    property OnLookup: TSocketNotifyEvent read FOnLookup write FOnLookup;
    property OnConnecting: TSocketNotifyEvent read FOnConnecting write FOnConnecting;
    property OnConnect: TSocketNotifyEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TSocketNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnListen: TSocketNotifyEvent read FOnListen write FOnListen;
    property OnAccept: TSocketNotifyEvent read FOnAccept write FOnAccept;
    property OnRead: TSocketNotifyEvent read FOnRead write FOnRead;
    property OnWrite: TSocketNotifyEvent read FOnWrite write FOnWrite;
    property OnError: TSocketErrorEvent read FOnError write FOnError;
  end;

  PWinSocketStream = ^TWinSocketStream;
  TWinSocketStream = object(TStream)
  private
    FSocket: PCustomWinSocket;
    FTimeout: Longint;
    FEvent: PSimpleEvent;
  public
    constructor Create(ASocket: PCustomWinSocket; TimeOut_: Longint);
    destructor Destroy; virtual;
    function WaitForData(Timeout_: Longint): Boolean;
    function Read(var Buffer; Count: Longint): Longint; 
    function Write(const Buffer; Count: Longint): Longint; 
    function Seek(Offset: Longint; Origin: Word): Longint; 
    property TimeOut: Longint read FTimeout write FTimeout;
  end;
 
  PClientSocket = ^TClientSocket;
  TClientSocket = object(TCustomSocket)
  private
    FClientSocket: PClientWinSocket;
  protected
    procedure DoActivate(Value: Boolean); virtual;
    function GetClientType: TClientType;
    procedure SetClientType(Value: TClientType);
  public
    constructor Create{(AOwner: TComponent)}; 
    destructor Destroy; virtual;
    property Socket: PClientWinSocket read FClientSocket;
//    property Active;
//    property Address;
    property ClientType: TClientType read GetClientType write SetClientType;
//    property Host;
//    property Port;
//    property Service;
//    property OnLookup;
//    property OnConnecting;
//    property OnConnect;
//    property OnDisconnect;
//    property OnRead;
//    property OnWrite;
//    property OnError;
  end;
  TKOLClientSocket = PClientSocket;


  PCustomServerSocket  = ^TCustomServerSocket;
  TCustomServerSocket = object(TCustomSocket)
  protected
    FServerSocket: PServerWinSocket;
    procedure DoActivate(Value: Boolean); virtual;//override;
    function GetServerType: TServerType;
    function GetGetThreadEvent: TGetThreadEvent;
    function GetGetSocketEvent: TGetSocketEvent;
    function GetThreadCacheSize: Integer;
    function GetOnThreadStart: TThreadNotifyEvent;
    function GetOnThreadEnd: TThreadNotifyEvent;
    function GetOnClientEvent(Index: Integer): TSocketNotifyEvent;
    function GetOnClientError: TSocketErrorEvent;
    procedure SetServerType(Value: TServerType);
    procedure SetGetThreadEvent(Value: TGetThreadEvent);
    procedure SetGetSocketEvent(Value: TGetSocketEvent);
    procedure SetThreadCacheSize(Value: Integer);
    procedure SetOnThreadStart(Value: TThreadNotifyEvent);
    procedure SetOnThreadEnd(Value: TThreadNotifyEvent);
    procedure SetOnClientEvent(Index: Integer; Value: TSocketNotifyEvent);
    procedure SetOnClientError(Value: TSocketErrorEvent);
  public
    property ServerType: TServerType read GetServerType write SetServerType;
    property ThreadCacheSize: Integer read GetThreadCacheSize
      write SetThreadCacheSize;
    property OnGetThread: TGetThreadEvent read GetGetThreadEvent
      write SetGetThreadEvent;
    property OnGetSocket: TGetSocketEvent read GetGetSocketEvent
      write SetGetSocketEvent;
    property OnThreadStart: TThreadNotifyEvent read GetOnThreadStart
      write SetOnThreadStart;
    property OnThreadEnd: TThreadNotifyEvent read GetOnThreadEnd
      write SetOnThreadEnd;
    property OnClientConnect: TSocketNotifyEvent index 2 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientDisconnect: TSocketNotifyEvent index 3 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientRead: TSocketNotifyEvent index 0 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientWrite: TSocketNotifyEvent index 1 read GetOnClientEvent
      write SetOnClientEvent;
    property OnClientError: TSocketErrorEvent read GetOnClientError write SetOnClientError;

    destructor Destroy; virtual;
  end;
  PServerSocket = ^TServerSocket;
  TServerSocket = object(TCustomServerSocket)
  public
    constructor Create{(AOwner: TObj)};
    destructor Destroy;  virtual;
    property Socket: PServerWinSocket read FServerSocket;
{  published
    property Active;
    property Port;
    property Service;
    property ServerType;
    property ThreadCacheSize default 10;
    property OnListen;
    property OnAccept;
    property OnGetThread;
    property OnGetSocket;
    property OnThreadStart;
    property OnThreadEnd;
    property OnClientConnect;
    property OnClientDisconnect;
    property OnClientRead;
    property OnClientWrite;
    property OnClientError;
}  end;
  TKOLServerSocket = PServerSocket;




  TSocketErrorProc = procedure (ErrorCode: Integer);


function NewServerSocket{(AOwner: TObj)}: TKOLServerSocket;

function SetErrorProc(ErrorProc: TSocketErrorProc): TSocketErrorProc;


function NewCustomWinSocket(ASocket: TSocket): PCustomWinSocket;
function NewServerClientThread(CreateSuspended: Boolean; ASocket: PServerClientWinSocket):PServerClientThread;
function NewServerAcceptThread(CreateSuspended: Boolean; ASocket: PServerWinSocket):PServerAcceptThread;
function NewServerClientWinSocket(Socket: TSocket; Server_Socket: PServerWinSocket):PServerClientWinSocket;
function NewCustomServerSocket: PCustomServerSocket;

function NewClientWinSocket:PClientWinSocket;
function NewClientSocket{(AOwner: TObj)}: PClientSocket;

function NewServerWinSocket(ASocket: TSocket) : PServerWinSocket;

function NewWinSocketStream(ASocket: PCustomWinSocket; TimeOut: Longint) : PWinSocketStream;

//function NewServerClientWinSocket = ^TServerClientWinSocket;

implementation

uses Consts;

threadvar
  SocketErrorProc: TSocketErrorProc;


type
  pobjectinstance=^tobjectinstance;
  tobjectinstance=packed record
    code:byte;
    offset:integer;
    case integer of
    0:(next:pobjectinstance);
    1:(method:twndmethod);
  end;

  pinstanceblock=^tinstanceblock;
  tinstanceblock=packed record
    next:pinstanceblock;
    code:array[1..2] of byte;
    wndprocptr:pointer;
    instances: array[0..$ff] of tobjectinstance;
  end;

var
  instblocklist:pinstanceblock;
  instfreelist:pobjectinstance;
  
var
  WSAData: TWSAData;
  utilclass:twndclass=(lpfnwndproc:@defwindowproc;lpszclassname:'TCPSocket');


function stdwndproc(window:hwnd;message:dword;wparam:WPARAM;
  lparam:LPARAM):LRESULT;stdcall;assembler;
asm
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    LParam
        PUSH    WParam
        PUSH    Message
        MOV     EDX,ESP
        MOV     EAX,[ECX].Longint[4]
        CALL    [ECX].Pointer
        ADD     ESP,12
        POP     EAX
end;

function calcjmpoffset(src,dest:pointer):longint;
begin
  result:=longint(dest)-(longint(src)+5);
end;

function MakeObjectInstance(Method: TWndMethod): Pointer;
const
  blockcode:array[1..2] of byte=($59,$E9);
  pagesize=4096;
var
  block:pinstanceblock;
  instance:pobjectinstance;
begin
  if instfreelist=nil then
  begin
    block:=virtualalloc(nil,PageSize, MEM_COMMIT,PAGE_EXECUTE_READWRITE);
    block^.next:=instblocklist;
    move(blockcode,block^.code,sizeof(blockcode));
    block^.wndprocptr:=pointer(calcjmpoffset(@block^.code[2],@stdwndproc));
    instance:=@block^.instances;
    repeat
      instance^.code:=$E8;
      instance^.offset:=calcjmpoffset(instance,@block^.code);
      instance^.next:=instfreelist;
      instfreelist:=instance;
      inc(longint(instance),sizeof(tobjectinstance));
    until longint(instance)-longint(block)>=sizeof(tinstanceblock);
    instblocklist:=block;
  end;
  result:=instfreelist;
  instance:=instfreelist;
  instfreelist:=instance^.next;
  instance^.method:=method;
end;

procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
  if objectinstance<>nil then
  begin
    pobjectinstance(objectinstance)^.next:=instfreelist;
    instfreelist:=objectinstance;
  end;
end;


function AllocateHWnd(Method: TWndMethod): HWND;
var
  tempclass:twndclass;
  classregistered:boolean;
begin
  utilclass.hinstance:=hinstance;
  classregistered:=getclassinfo(hinstance,utilclass.lpszclassname,tempclass);
  if not classregistered or (tempclass.lpfnwndproc<>@defwindowproc) then
  begin
    if classregistered then unregisterclass(utilclass.lpszclassname,hinstance);
    registerclass(utilclass);
  end;
  result:=createwindowex(WS_EX_TOOLWINDOW,utilclass.lpszclassname,nil,
    WS_POPUP,0,0,0,0,0,0,hinstance,nil);
  if assigned(method) then setwindowlong(result,GWL_WNDPROC,longint(makeobjectinstance(method)));
end;

procedure DeallocateHWnd(Wnd: HWND);
var
  instance:pointer;
begin
  instance:=pointer(getwindowlong(wnd,GWL_WNDPROC));
  destroywindow(wnd);
  if instance<>@defwindowproc then freeobjectinstance(instance);
end;


function SetErrorProc(ErrorProc: TSocketErrorProc): TSocketErrorProc;
begin
  Result := SocketErrorProc;
  SocketErrorProc := ErrorProc;
end;

function CheckSocketResult(ResultCode: Integer; const Op: string): Integer;
begin
  if ResultCode <> 0 then
  begin
    Result := WSAGetLastError;
    if Result <> WSAEWOULDBLOCK then
      if Assigned(SocketErrorProc) then
        SocketErrorProc(Result)
      else raise ESocketError.CreateResFmt(e_Custom,Integer(@sWindowsSocketError),
        [SysErrorMessage(Result), Result, Op]);
  end else Result := 0;
end;

procedure Startup;
var
  ErrorCode: Integer;
begin
  ErrorCode := WSAStartup($0101, WSAData);
  if ErrorCode <> 0 then
    raise ESocketError.CreateResFmt(e_Custom,Integer(@sWindowsSocketError),
      [SysErrorMessage(ErrorCode), ErrorCode, 'WSAStartup']);
end;

procedure Cleanup;
var
  ErrorCode: Integer;
begin
  ErrorCode := WSACleanup;
  if ErrorCode <> 0 then
    raise ESocketError.CreateResFmt(e_Custom,Integer(@sWindowsSocketError),
      [SysErrorMessage(ErrorCode), ErrorCode, 'WSACleanup']);
end;

{ TCustomWinSocket }
function NewCustomWinSocket(ASocket: TSocket): PCustomWinSocket;
begin
  new(result,create(ASocket));
//  result.create;

end;


constructor TCustomWinSocket.Create(ASocket: TSocket);
begin
//  inherited Create;
  Startup;
  FSocketLock := NewCriticalSection;
  FASyncStyles := [asRead, asWrite, asConnect, asClose];
  FSocket := ASocket;
  FAddr.sin_family := PF_INET;
  FAddr.sin_addr.s_addr := INADDR_ANY;
  FAddr.sin_port := 0;
  FConnected := FSocket <> INVALID_SOCKET;
end;

destructor TCustomWinSocket.Destroy;
begin
  FOnSocketEvent := nil;  { disable events }
  if FConnected and (FSocket <> INVALID_SOCKET) then
    Disconnect(FSocket);
  if FHandle <> 0 then DeallocateHWnd(FHandle);
  FSocketLock.Free;
//  DeleteCriticalSection(FSocketLock);

  Cleanup;
  FreeMem(FGetHostData);
  FGetHostData := nil;
//  inherited Destroy;
end;

procedure TCustomWinSocket.Accept(Socket: TSocket);
begin
end;

procedure TCustomWinSocket.AsyncInitSocket(const Name, Address,
  Service: string; Port: Word; QueueSize: Integer; Client: Boolean);
var
  ErrorCode: Integer;
begin
  try
    case FLookupState of
      lsIdle:
        begin
          if not Client then
          begin
            FLookupState := lsLookupAddress;
            FAddr.sin_addr.S_addr := INADDR_ANY;
          end else if Name <> '' then
          begin
            if FGetHostData = nil then
              FGetHostData := AllocMem(MAXGETHOSTSTRUCT);
            FLookupHandle := WSAAsyncGetHostByName(Handle, CM_LOOKUPCOMPLETE,
              PChar(Name), FGetHostData, MAXGETHOSTSTRUCT);
            CheckSocketResult(Ord(FLookupHandle = 0), 'WSAASyncGetHostByName');
            FService := Service;
            FPort := Port;
            FQueueSize := QueueSize;
            FClient := Client;
            FLookupState := lsLookupAddress;
            Exit;
          end else if Address <> '' then
          begin
            FLookupState := lsLookupAddress;
            FAddr.sin_addr.S_addr := inet_addr(PChar(Address));
          end else
          begin
            ErrorCode := 1110;
            Error(@Self, eeLookup, ErrorCode);
            Disconnect(FSocket);
            if ErrorCode <> 0 then
              raise ESocketError.Create(e_Custom,sNoAddress);
            Exit;
          end;
        end;
      lsLookupAddress:
        begin
          if Service <> '' then
          begin
            if FGetHostData = nil then
              FGetHostData := AllocMem(MAXGETHOSTSTRUCT);
            FLookupHandle := WSAASyncGetServByName(Handle, CM_LOOKUPCOMPLETE,
              PChar(Service), 'tcp' , FGetHostData, MAXGETHOSTSTRUCT);
            CheckSocketResult(Ord(FLookupHandle = 0), 'WSAASyncGetServByName');
            FLookupState := lsLookupService;
            Exit;
          end else
          begin
            FLookupState := lsLookupService;
            FAddr.sin_port := htons(Port);
          end;
        end;
      lsLookupService:
        begin
          FLookupState := lsIdle;
          if Client then
            DoOpen
          else DoListen(QueueSize);
        end;
    end;
    if FLookupState <> lsIdle then
      ASyncInitSocket(Name, Address, Service, Port, QueueSize, Client);
  except
    Disconnect(FSocket);
    raise;
  end;
end;

procedure TCustomWinSocket.Close;
begin
  Disconnect(FSocket);
end;

procedure TCustomWinSocket.Connect(Socket: TSocket);
begin
end;

procedure TCustomWinSocket.Lock;
begin
  FSocketLock.Enter;
end;

procedure TCustomWinSocket.Unlock;
begin
  FSocketLock.Leave;
end;

procedure TCustomWinSocket.CMSocketMessage(var Message: TCMSocketMessage);

  function CheckError: Boolean;
  var
    ErrorEvent: TErrorEvent;
    ErrorCode: Integer;
  begin
    if Message.SelectError <> 0 then
    begin
      Result := False;
      ErrorCode := Message.SelectError;
      case Message.SelectEvent of
        FD_CONNECT: ErrorEvent := eeConnect;
        FD_CLOSE: ErrorEvent := eeDisconnect;
        FD_READ: ErrorEvent := eeReceive;
        FD_WRITE: ErrorEvent := eeSend;
        FD_ACCEPT: ErrorEvent := eeAccept;
      else
        ErrorEvent := eeGeneral;
      end;
      Error(@Self, ErrorEvent, ErrorCode);
      if ErrorCode <> 0 then
        raise ESocketError.CreateResFmt(e_Custom,Integer(@sASyncSocketError), [ErrorCode]);
    end else Result := True;
  end;

begin
  with Message do
    if CheckError then
      case SelectEvent of
        FD_CONNECT: Connect(Socket);
        FD_CLOSE: Disconnect(Socket);
        FD_READ: Read(Socket);
        FD_WRITE: Write(Socket);
        FD_ACCEPT: Accept(Socket);
      end;
end;

procedure TCustomWinSocket.CMDeferFree(var Message);
begin
//  Free;
//  Free_And_Nil(Self);
end;

procedure TCustomWinSocket.DeferFree;
begin
  if FHandle <> 0 then PostMessage(FHandle, CM_DEFERFREE, 0, 0);
end;

procedure TCustomWinSocket.DoSetAsyncStyles;
var
  Msg: Integer;
  Wnd: HWnd;
  Blocking: Longint;
begin
  Msg := 0;
  Wnd := 0;
  if FAsyncStyles <> [] then
  begin
    Msg := CM_SOCKETMESSAGE;
    Wnd := Handle;
  end;
  WSAAsyncSelect(FSocket, Wnd, Msg, Longint(Byte(FAsyncStyles)));
  if FASyncStyles = [] then
  begin
    Blocking := 0;
    ioctlsocket(FSocket, FIONBIO, Blocking);
  end;
end;

procedure TCustomWinSocket.DoListen(QueueSize: Integer);
begin
  CheckSocketResult(bind(FSocket, FAddr, SizeOf(FAddr)), 'bind');
  DoSetASyncStyles;
  if QueueSize > SOMAXCONN then QueueSize := SOMAXCONN;
  Event(@Self, seListen);
  CheckSocketResult(Winsock.listen(FSocket, QueueSize), 'listen');
  FLookupState := lsIdle;
  FConnected := True;
end;

procedure TCustomWinSocket.DoOpen;
begin
  DoSetASyncStyles;
  Event(@Self, seConnecting);
  CheckSocketResult(WinSock.connect(FSocket, FAddr, SizeOf(FAddr)), 'connect');
  FLookupState := lsIdle;
  if not (asConnect in FAsyncStyles) then
  begin
    FConnected := FSocket <> INVALID_SOCKET;
    Event(@Self, seConnect);
  end;
end;

function TCustomWinSocket.GetHandle: HWnd;
begin
  if FHandle = 0 then
    FHandle := AllocateHwnd(WndProc);
  Result := FHandle;
end;

function TCustomWinSocket.GetLocalAddress: string;
var
  SockAddrIn: TSockAddrIn;
  Size: Integer;
begin
  Lock;
  try
    Result := '';
    if FSocket = INVALID_SOCKET then Exit;
    Size := SizeOf(SockAddrIn);
    if getsockname(FSocket, SockAddrIn, Size) = 0 then
      Result := inet_ntoa(SockAddrIn.sin_addr);
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.GetLocalHost: string;
var
  LocalName: array[0..255] of Char;
begin
  Lock;
  try
    Result := '';
    if FSocket = INVALID_SOCKET then Exit;
    if gethostname(LocalName, SizeOf(LocalName)) = 0 then
      Result := LocalName;
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.GetLocalPort: Integer;
var
  SockAddrIn: TSockAddrIn;
  Size: Integer;
begin
  Lock;
  try
    Result := -1;
    if FSocket = INVALID_SOCKET then Exit;
    Size := SizeOf(SockAddrIn);
    if getsockname(FSocket, SockAddrIn, Size) = 0 then
      Result := ntohs(SockAddrIn.sin_port);
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.GetRemoteHost: string;
var
  SockAddrIn: TSockAddrIn;
  Size: Integer;
  HostEnt: PHostEnt;
begin
  Lock;
  try
    Result := '';
    if not FConnected then Exit;
    Size := SizeOf(SockAddrIn);
    CheckSocketResult(getpeername(FSocket, SockAddrIn, Size), 'getpeername');
    HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.s_addr, 4, PF_INET);
    if HostEnt <> nil then Result := HostEnt.h_name;
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.GetRemoteAddress: string;
var
  SockAddrIn: TSockAddrIn;
  Size: Integer;
begin
  Lock;
  try
    Result := '';
    if not FConnected then Exit;
    Size := SizeOf(SockAddrIn);
    CheckSocketResult(getpeername(FSocket, SockAddrIn, Size), 'getpeername');
    Result := inet_ntoa(SockAddrIn.sin_addr);
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.GetRemotePort: Integer;
var
  SockAddrIn: TSockAddrIn;
  Size: Integer;
begin
  Lock;
  try
    Result := 0;
    if not FConnected then Exit;
    Size := SizeOf(SockAddrIn);
    CheckSocketResult(getpeername(FSocket, SockAddrIn, Size), 'getpeername');
    Result := ntohs(SockAddrIn.sin_port);
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.GetRemoteAddr: TSockAddrIn;
var
  Size: Integer;
begin
  Lock;
  try
    FillChar(Result, SizeOf(Result), 0);
    if not FConnected then Exit;
    Size := SizeOf(Result);
    if getpeername(FSocket, Result, Size) <> 0 then
      FillChar(Result, SizeOf(Result), 0);
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.LookupName(const Name: string): TInAddr;
var
  HostEnt: PHostEnt;
  InAddr: TInAddr;
begin
  HostEnt := gethostbyname(PChar(Name));
  FillChar(InAddr, SizeOf(InAddr), 0);
  if HostEnt <> nil then
  begin
    with InAddr, HostEnt^ do
    begin
      S_un_b.s_b1 := h_addr^[0];
      S_un_b.s_b2 := h_addr^[1];
      S_un_b.s_b3 := h_addr^[2];
      S_un_b.s_b4 := h_addr^[3];
    end;
  end;
  Result := InAddr;
end;

function TCustomWinSocket.LookupService(const Service: string): Integer;
var
  ServEnt: PServEnt;
begin
  ServEnt := getservbyname(PChar(Service), 'tcp');
  if ServEnt <> nil then
    Result := ntohs(ServEnt.s_port)
  else Result := 0;
end;

function TCustomWinSocket.InitSocket(const Name, Address, Service: string; Port: Word;
  Client: Boolean): TSockAddrIn;
begin
  Result.sin_family := PF_INET;
  if Name <> '' then
    Result.sin_addr := LookupName(name)
  else if Address <> '' then
    Result.sin_addr.s_addr := inet_addr(PChar(Address))
  else if not Client then
    Result.sin_addr.s_addr := INADDR_ANY
  else raise ESocketError.Create(e_Custom,sNoAddress);
  if Service <> '' then
    Result.sin_port := htons(LookupService(Service))
  else
    Result.sin_port := htons(Port);
end;

procedure TCustomWinSocket.Listen(const Name, Address, Service: string; Port: Word;
  QueueSize: Integer; Block: Boolean);
begin
  if FConnected then raise ESocketError.Create(e_Custom,sCannotListenOnOpen);
  FSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  if FSocket = INVALID_SOCKET then raise ESocketError.Create(e_Custom,sCannotCreateSocket);
  try
    Event(@Self, seLookUp);
    if Block then
    begin
      FAddr := InitSocket(Name, Address, Service, Port, False);
      DoListen(QueueSize);
    end else
      AsyncInitSocket(Name, Address, Service, Port, QueueSize, False);
  except
    Disconnect(FSocket);
    raise;
  end;
end;

procedure TCustomWinSocket.Open(const Name, Address, Service: string; Port: Word; Block: Boolean);
begin
  if FConnected then raise ESocketError.Create(e_Custom,sSocketAlreadyOpen);
  FSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  if FSocket = INVALID_SOCKET then raise ESocketError.Create(e_Custom,sCannotCreateSocket);
  try
    Event(@Self, seLookUp);
    if Block then
    begin
      FAddr := InitSocket(Name, Address, Service, Port, True);
      DoOpen;
    end else
      AsyncInitSocket(Name, Address, Service, Port, 0, True);
  except
    Disconnect(FSocket);
    raise;
  end;
end;

procedure TCustomWinSocket.Disconnect(Socket: TSocket);
begin
  Lock;
  try
    if FLookupHandle <> 0 then
      CheckSocketResult(WSACancelASyncRequest(FLookupHandle), 'WSACancelASyncRequest');
    FLookupHandle := 0;
    if (Socket = INVALID_SOCKET) or (Socket <> FSocket) then exit;
    Event(@Self, seDisconnect);
    CheckSocketResult(closesocket(FSocket), 'closesocket');
    FSocket := INVALID_SOCKET;
    FAddr.sin_family := PF_INET;
    FAddr.sin_addr.s_addr := INADDR_ANY;
    FAddr.sin_port := 0;
    FConnected := False;
    Free_And_Nil(FSendStream);
  finally
    Unlock;
  end;
end;

procedure TCustomWinSocket.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    if FHandle <> 0 then
      Result := CallWindowProc(@DefWindowProc, FHandle, Msg, wParam, lParam);
end;

procedure TCustomWinSocket.Event(Socket: PCustomWinSocket; SocketEvent: TSocketEvent);
begin
  if Assigned(FOnSocketEvent) then FOnSocketEvent(@Self, Socket, SocketEvent);
end;

procedure TCustomWinSocket.Error(Socket: PCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if Assigned(FOnErrorEvent) then FOnErrorEvent(@Self, Socket, ErrorEvent, ErrorCode);
end;

function TCustomWinSocket.SendText(const s: string): Integer;
begin
  Result := SendBuf(Pointer(S)^, Length(S));
end;

function TCustomWinSocket.SendStreamPiece: Boolean;
var
  Buffer: array[0..4095] of Byte;
  StartPos: Integer;
  AmountInBuf: Integer;
  AmountSent: Integer;
  ErrorCode: Integer;

  procedure DropStream;
  begin
    if FDropAfterSend then Disconnect(FSocket);
    FDropAfterSend := False;
    FSendStream.Free;
    FSendStream := nil;
  end;

begin
  Lock;
  try
    Result := False;
    if FSendStream <> nil then
    begin
      if (FSocket = INVALID_SOCKET) or (not FConnected) then exit;
      while True do
      begin
        StartPos := FSendStream.Position;
        AmountInBuf := FSendStream.Read(Buffer, SizeOf(Buffer));
        if AmountInBuf > 0 then
        begin
          AmountSent := send(FSocket, Buffer, AmountInBuf, 0);
          if AmountSent = SOCKET_ERROR then
          begin
            ErrorCode := WSAGetLastError;
            if ErrorCode <> WSAEWOULDBLOCK then
            begin
              Error(@Self, eeSend, ErrorCode);
              Disconnect(FSocket);
              DropStream;
              if FAsyncStyles <> [] then Abort;
              Break;
            end else
            begin
              FSendStream.Position := StartPos;
              Break;
            end;
          end else if AmountInBuf > AmountSent then
            FSendStream.Position := StartPos + AmountSent
          else if FSendStream.Position = FSendStream.Size then
          begin
            DropStream;
            Break;
          end;
        end else
        begin
          DropStream;
          Break;
        end;
      end;
      Result := True;
    end;
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.SendStream(AStream: PStream): Boolean;
begin
  Result := False;
  if FSendStream = nil then
  begin
    FSendStream := AStream;
    Result := SendStreamPiece;
  end;
end;

function TCustomWinSocket.SendStreamThenDrop(AStream: PStream): Boolean;
begin
  FDropAfterSend := True;
  Result := SendStream(AStream);
  if not Result then FDropAfterSend := False;
end;

function TCustomWinSocket.SendBuf(var Buf; Count: Integer): Integer;
var
  ErrorCode: Integer;
begin
  Lock;
  try
    Result := 0;
    if not FConnected then Exit;
    Result := send(FSocket, Buf, Count, 0);
    if Result = SOCKET_ERROR then
    begin
      ErrorCode := WSAGetLastError;
      if (ErrorCode <> WSAEWOULDBLOCK) then
      begin
        Error(@Self, eeSend, ErrorCode);
        Disconnect(FSocket);
        if ErrorCode <> 0 then
          raise ESocketError.CreateResFmt(e_Custom,Integer(@sWindowsSocketError),
            [SysErrorMessage(ErrorCode), ErrorCode, 'send']);
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TCustomWinSocket.SetAsyncStyles(Value: TASyncStyles);
begin
  if Value <> FASyncStyles then
  begin
    FASyncStyles := Value;
    if FSocket <> INVALID_SOCKET then
      DoSetAsyncStyles;
  end;
end;

procedure TCustomWinSocket.Read(Socket: TSocket);
begin
  if (FSocket = INVALID_SOCKET) or (Socket <> FSocket) then Exit;
  Event(@Self, seRead);
end;

function TCustomWinSocket.ReceiveBuf(var Buf; Count: Integer): Integer;
var
  ErrorCode: Integer;
begin
  Lock;
  try
    Result := 0;
    if (Count = -1) and FConnected then
      ioctlsocket(FSocket, FIONREAD, Longint(Result))
    else begin
      if not FConnected then Exit;
      Result := recv(FSocket, Buf, Count, 0);
      if Result = SOCKET_ERROR then
      begin
        ErrorCode := WSAGetLastError;
        if ErrorCode <> WSAEWOULDBLOCK then
        begin
          Error(@Self, eeReceive, ErrorCode);
          Disconnect(FSocket);
          if ErrorCode <> 0 then
            raise ESocketError.CreateResFmt(e_Custom,Integer(@sWindowsSocketError),
              [SysErrorMessage(ErrorCode), ErrorCode, 'recv']);
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TCustomWinSocket.ReceiveLength: Integer;
begin
  Result := ReceiveBuf(Pointer(nil)^, -1);
end;

function TCustomWinSocket.ReceiveText: string;
begin
  SetLength(Result, ReceiveBuf(Pointer(nil)^, -1));
  SetLength(Result, ReceiveBuf(Pointer(Result)^, Length(Result)));
end;

procedure TCustomWinSocket.WndProc(var Message: TMessage);
begin
  try
  case Message.Msg of
    CM_LOOKUPCOMPLETE: CMLookupComplete(TCMLookupComplete(Message));
    CM_SOCKETMESSAGE : CMSocketMessage(TCMSocketMessage(Message));
    CM_DEFERFREE     : CMDeferFree(Message);
  end;
//    Dispatch(Message);

//
  except
    //if Assigned(ApplicationHandleException) then
     // ApplicationHandleException(Self);
  end;
end;

procedure TCustomWinSocket.Write(Socket: TSocket);
begin
  if (FSocket = INVALID_SOCKET) or (Socket <> FSocket) then Exit;
  if not SendStreamPiece then Event(@Self, seWrite);
end;

procedure TCustomWinSocket.CMLookupComplete(var Message: TCMLookupComplete);
var
  ErrorCode: Integer;
begin
  if Message.LookupHandle = FLookupHandle then
  begin
    FLookupHandle := 0;
    if Message.AsyncError <> 0 then
    begin
      ErrorCode := Message.AsyncError;
      Error(@Self, eeLookup, ErrorCode);
      Disconnect(FSocket);
      if ErrorCode <> 0 then
        raise ESocketError.CreateResFmt(e_Custom,Integer(@sWindowsSocketError),
          [SysErrorMessage(Message.AsyncError), Message.ASyncError, 'ASync Lookup']);
      Exit;
    end;
    if FLookupState = lsLookupAddress then
    begin
      FAddr.sin_addr.S_addr := Integer(Pointer(PHostEnt(FGetHostData).h_addr^)^);
      ASyncInitSocket('', '', FService, FPort, FQueueSize, FClient);
    end else if FLookupState = lsLookupService then
    begin
      FAddr.sin_port := PServEnt(FGetHostData).s_port;
      FPort := 0;
      FService := '';
      ASyncInitSocket('', '', '', 0, FQueueSize, FClient);
    end;
  end;
end;

{ TClientWinSocket }

function NewClientWinSocket:PClientWinSocket;
begin
  New(Result,create(INVALID_SOCKET));
end;
procedure TClientWinSocket.Connect(Socket: TSocket);
begin
  FConnected := True;
  Event(@Self, seConnect);
end;

procedure TClientWinSocket.SetClientType(Value: TClientType);
begin
  if Value <> FClientType then
    if not FConnected then
    begin
      FClientType := Value;
      if FClientType = ctBlocking then
        ASyncStyles := []
      else ASyncStyles := [asRead, asWrite, asConnect, asClose];
    end else raise ESocketError.Create(e_Custom,sCantChangeWhileActive);
end;
 
{ TServerClientWinsocket }

function NewServerClientWinSocket(Socket: TSocket; Server_Socket: PServerWinSocket):PServerClientWinSocket;
begin
  new(result,Create(Socket,Server_Socket));
end;
constructor TServerClientWinSocket.Create(Socket: TSocket; ServerWinSocket_: PServerWinSocket);
begin
  FServerWinSocket := ServerWinSocket_;
  if Assigned(FServerWinSocket) then
  begin
    FServerWinSocket.AddClient(@Self);
    if FServerWinSocket.AsyncStyles <> [] then
    begin
      OnSocketEvent := FServerWinSocket.ClientEvent;
      OnErrorEvent := FServerWinSocket.ClientError;
    end;
  end;
  inherited Create(Socket);
  if FServerWinSocket.ASyncStyles <> [] then DoSetAsyncStyles;
  if FConnected then Event(@Self, seConnect);
end;

destructor TServerClientWinSocket.Destroy;
begin
  if Assigned(FServerWinSocket) then
    FServerWinSocket.RemoveClient(@Self);
  inherited Destroy;
end;
  
{ TServerWinSocket }
function NewServerWinSocket(ASocket: TSocket) : PServerWinSocket;
begin
  new(result,Create(ASocket));
end;
constructor TServerWinSocket.Create(ASocket: TSocket);
begin
  FConnections := NewList;
  FActiveThreads := NewList;
  FListLock:=NewCriticalSection;
  inherited Create(ASocket);
  FAsyncStyles := [asAccept];
end;

destructor TServerWinSocket.Destroy;
begin
//  inherited Destroy;
  FConnections.Free;
  FActiveThreads.Free;
  FListLock.Free;
end;

procedure TServerWinSocket.AddClient(AClient: PServerClientWinSocket);
begin
  FListLock.Enter;

  try
    if FConnections.IndexOf(AClient) < 0 then
      FConnections.Add(AClient);
  finally
    FListLock.Leave;
  end;
end;

procedure TServerWinSocket.RemoveClient(AClient: PServerClientWinSocket);
begin
  FListLock.Enter;
  try
    FConnections.Remove(AClient);
  finally
    FListLock.Leave;
  end;
end;

procedure TServerWinSocket.AddThread(AThread: PServerClientThread);
begin

  FListLock.Enter;
  try
    if FActiveThreads.IndexOf(AThread) < 0 then
    begin
      FActiveThreads.Add(AThread);
      if FActiveThreads.Count <= FThreadCacheSize then
        AThread.KeepInCache := True;
    end;
  finally
    FListLock.Leave;
  end;
end;

procedure TServerWinSocket.RemoveThread(AThread: PServerClientThread);
begin
  FListLock.Enter;
  try
    FActiveThreads.Remove(AThread);
  finally
    FListLock.Leave;
  end;
end;

procedure TServerWinSocket.ClientEvent(Sender: PObj; Socket: PCustomWinSocket;
  SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seAccept,
    seLookup,
    seConnecting,
    seListen:
      begin end;
    seConnect: ClientConnect(Socket);
    seDisconnect: ClientDisconnect(Socket);
    seRead: ClientRead(Socket);
    seWrite: ClientWrite(Socket);
  end;
end;

procedure TServerWinSocket.ClientError(Sender: PObj; Socket: PCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ClientErrorEvent(Socket, ErrorEvent, ErrorCode);
end;

function TServerWinSocket.GetActiveConnections: Integer;
begin
  Result := FConnections.Count;
end;

function TServerWinSocket.GetConnections(Index: Integer): PCustomWinSocket;
begin
  Result := FConnections.Items[Index];
end;

function TServerWinSocket.GetActiveThreads: Integer;
var
  I: Integer;
begin
  FListLock.Enter;
  try
    Result := 0;
    for I := 0 to FActiveThreads.Count - 1 do
      if PServerClientThread(FActiveThreads.Items[I]).ClientSocket <> nil then
        Inc(Result);
  finally
    FListLock.Leave;
  end;
end;

function TServerWinSocket.GetIdleThreads: Integer;
var
  I: Integer;
begin
  FListLock.Enter;
  try
    Result := 0;
    for I := 0 to FActiveThreads.Count - 1 do
      if PServerClientThread(FActiveThreads.Items[I]).ClientSocket = nil then
        Inc(Result);
  finally
    FListLock.Leave;
  end;
end;

procedure TServerWinSocket.Accept(Socket: TSocket);
var
  ClientSocket: PServerClientWinSocket;
  ClientWinSocket: TSocket;
  Addr_: TSockAddrIn;
  Len: Integer;
  OldOpenType, NewOpenType: Integer;
begin
  Len := SizeOf(OldOpenType);
  if getsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, PChar(@OldOpenType),
    Len) = 0 then
  try
    if FServerType = stThreadBlocking then
    begin
      NewOpenType := SO_SYNCHRONOUS_NONALERT;
      setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, PChar(@NewOpenType), Len);
    end;
    Len := SizeOf(Addr_);
    ClientWinSocket := WinSock.accept(Socket, @Addr_, @Len);
    if ClientWinSocket <> INVALID_SOCKET then
    begin
      ClientSocket := GetClientSocket(ClientWinSocket);
      if Assigned(FOnSocketEvent) then
        FOnSocketEvent(@Self, ClientSocket, seAccept);
      if FServerType = stThreadBlocking then
      begin
        ClientSocket.ASyncStyles := [];
        GetServerThread(ClientSocket);
      end;
    end;
  finally
    Len := SizeOf(OldOpenType);
    setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, PChar(@OldOpenType), Len);
  end;
end;

procedure TServerWinSocket.Disconnect(Socket: TSocket);
var
  SaveCacheSize: Integer;
begin
  Lock;
  try
    SaveCacheSize := ThreadCacheSize;
    try
      ThreadCacheSize := 0;
      while FActiveThreads.Count > 0 do
        with PServerClientThread(FActiveThreads.Last)^ do
        begin
          FServerClientThread.AutoFree:=false;

          FServerClientThread.Terminate;
          FEvent.SetEvent;
          if (ClientSocket <> nil) and ClientSocket.Connected then
            ClientSocket.Close;
          FServerClientThread.WaitFor;  
          FServerClientThread.Free;
        end;
      while FConnections.Count > 0 do
         FConnections.Delete(FConnections.Count-1);
      if FServerAcceptThread <> nil then
        FServerAcceptThread.Terminate;
      inherited Disconnect(Socket);
      Free_And_Nil(FServerAcceptThread);
      FServerAcceptThread := nil;
    finally
      ThreadCacheSize := SaveCacheSize;
    end;
  finally
    Unlock;
  end;
end;

function TServerWinSocket.DoCreateThread(ClientSocket: PServerClientWinSocket): PServerClientThread;
begin

  Result := NewServerClientThread(False, ClientSocket);
//  TServerClientThread.Create(False, ClientSocket);
end;

procedure TServerWinSocket.Listen(var Name, Address, Service: string; Port: Word;
  QueueSize: Integer);
begin
  inherited Listen(Name, Address, Service, Port, QueueSize, ServerType = stThreadBlocking);
  if FConnected and (ServerType = stThreadBlocking) then
    FServerAcceptThread := newServerAcceptThread(False, @Self);
end;

procedure TServerWinSocket.SetServerType(Value: TServerType);
begin
  if Value <> FServerType then
    if not FConnected then
    begin
      FServerType := Value;
      if FServerType = stThreadBlocking then
        ASyncStyles := []
      else ASyncStyles := [asAccept];
    end else raise ESocketError.Create(e_Custom,sCantChangeWhileActive);
end;

procedure TServerWinSocket.SetThreadCacheSize(Value: Integer);
var
  Start, I: Integer;
begin
  if Value <> FThreadCacheSize then
  begin
    if Value < FThreadCacheSize then
      Start := Value
    else Start := FThreadCacheSize;
    FThreadCacheSize := Value;
    FListLock.Enter;
    try
      for I := 0 to FActiveThreads.Count - 1 do
        with PServerClientThread(FActiveThreads.Items[I])^ do
          KeepInCache := I < Start;
    finally
      FListLock.Leave;
    end;
  end;
end;

function TServerWinSocket.GetClientSocket(Socket: TSocket): PServerClientWinSocket;
begin
  Result := nil;
  if Assigned(FOnGetSocket) then FOnGetSocket(@Self, Socket, Result);
  if Result = nil then
    Result := NewServerClientWinSocket(Socket, @Self);
end;

procedure TServerWinSocket.ThreadEnd(AThread: PServerClientThread);
begin
  if Assigned(FOnThreadEnd) then FOnThreadEnd(@Self, AThread);
end;

procedure TServerWinSocket.ThreadStart(AThread: PServerClientThread);
begin
  if Assigned(FOnThreadStart) then FOnThreadStart(@Self, AThread);
end;

function TServerWinSocket.GetServerThread(ClientSocket: PServerClientWinSocket): PServerClientThread;
var
  I: Integer;
begin
  Result := nil;
  FListLock.Enter;
  try
    for I := 0 to FActiveThreads.Count - 1 do
      if PServerClientThread(FActiveThreads.Items[I]).ClientSocket = nil then
      begin
        Result := FActiveThreads.Items[I];
        Result.ReActivate(ClientSocket);
        Break;
      end;
  finally
    FListLock.Leave;
  end;
  if Result = nil then
  begin
    if Assigned(FOnGetThread) then FOnGetThread(@Self, ClientSocket, Result);
    if Result = nil then Result := DoCreateThread(ClientSocket);
  end;
end;

function TServerWinSocket.GetClientThread(ClientSocket: PServerClientWinSocket): PServerClientThread;
var
  I: Integer;
begin
  Result := nil;
  FListLock.Enter;
  try
    for I := 0 to FActiveThreads.Count - 1 do
      if PServerClientThread(FActiveThreads.Items[I]).ClientSocket = ClientSocket then
      begin
        Result := FActiveThreads.Items[I];
        Break;
      end;
  finally
    FListLock.Leave;
  end;
end;

procedure TServerWinSocket.ClientConnect(Socket: PCustomWinSocket);
begin
  if Assigned(FOnClientConnect) then FOnClientConnect(@Self, Socket);
end;

procedure TServerWinSocket.ClientDisconnect(Socket: PCustomWinSocket);
begin
  if Assigned(FOnClientDisconnect) then FOnClientDisconnect(@Self, Socket);
  if ServerType = stNonBlocking then Socket.DeferFree;
end;

procedure TServerWinSocket.ClientRead(Socket: PCustomWinSocket);
begin
  if Assigned(FOnClientRead) then FOnClientRead(@Self, Socket);
end;

procedure TServerWinSocket.ClientWrite(Socket: PCustomWinSocket);
begin
  if Assigned(FOnClientWrite) then FOnClientWrite(@Self, Socket);
end;

procedure TServerWinSocket.ClientErrorEvent(Socket: PCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if Assigned(FOnClientError) then FOnClientError(@Self, Socket, ErrorEvent, ErrorCode);
end;

{TServerAcceptThread }
function NewServerAcceptThread(CreateSuspended: Boolean;
                         ASocket: PServerWinSocket):PServerAcceptThread;
begin
  result:=PServerAcceptThread(NewThread);
//  new(result,Create(CreateSuspended,ASocket));
  result.Create(CreateSuspended,ASocket)
//;
 // if result^.Suspended then
   //  ShowMessage('vdfsb');
end;
constructor TServerAcceptThread.Create(CreateSuspended: Boolean;
  ASocket: PServerWinSocket);
begin
  FAcceptServerSocket := ASocket;
  FAcceptThread:=NewThread;
  FAcceptThread.OnExecute:=Execute;

  if not CreateSuspended then
     FAcceptThread.Resume;
end;

procedure TServerAcceptThread.Terminate;
begin
  FAcceptThread.Terminate;
end;

function TServerAcceptThread.Execute(Sender: PThread):integer;
begin
  while not Sender.Terminated do
    FAcceptServerSocket^.Accept(FAcceptServerSocket^.SocketHandle);
  result:=0;  
end;
 
{ TServerClientThread }
function NewServerClientThread(CreateSuspended: Boolean; ASocket: PServerClientWinSocket):PServerClientThread;
begin
  New(result,Create(CreateSuspended,ASocket));
end;
constructor TServerClientThread.Create(CreateSuspended: Boolean;
  ASocket: PServerClientWinSocket);
begin
  FServerClientThread:=NewThread;
  FServerClientThread.AutoFree:=true;
  FServerClientThread.OnExecute:=Execute;
  FEvent := NewSimpleEvent;
  //inherited
  //ThreadCreate;
//  CreateSuspended
//  True);
  FServerClientThread.ThreadPriority := THREAD_PRIORITY_ABOVE_NORMAL;
  ReActivate(ASocket);
  if not CreateSuspended then FServerClientThread.Resume;
end;

destructor TServerClientThread.Destroy;
begin
  Free_And_Nil(FClientSocket);
  FEvent.Free;
  FServerClientThread.Free;
end;

procedure TServerClientThread.Terminate;
begin
  FServerClientThread.Terminate;
end;

function TServerClientThread.GetThreadPriority: Integer;
begin
  Result:= FServerClientThread.ThreadPriority;
end;
procedure TServerClientThread.SetThreadPriority(Value: Integer);
begin
  FServerClientThread.ThreadPriority:=Value;
end;

function TServerClientThread.GetTerminated:boolean;
begin
  Result:=FServerClientThread.Terminated;
end;

procedure TServerClientThread.ReActivate(ASocket: PServerClientWinSocket);
begin
  FClientSocket := ASocket;
  if Assigned(FClientSocket) then
  begin
    FServerSocket := FClientSocket.ServerWinSocket;
    FServerSocket.AddThread(@Self);
    FClientSocket.OnSocketEvent := HandleEvent;
    FClientSocket.OnErrorEvent := HandleError;
    FEvent.SetEvent;
  end;
end;

procedure TServerClientThread.DoHandleException;
begin
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  if FException is Exception then
  begin
    //if Assigned(ApplicationShowException) then
      //ApplicationShowException(FException);
  end else
    err.ShowException(FException, nil);
end;

procedure TServerClientThread.DoRead;
begin
  ClientSocket.ServerWinSocket.Event(ClientSocket, seRead);
end;

procedure TServerClientThread.DoTerminate;
begin

  FServerClientThread.Terminate;
  if Assigned(FServerSocket) then
    FServerSocket.RemoveThread(@Self);
end;

procedure TServerClientThread.DoWrite;
begin
  FServerSocket.Event(ClientSocket, seWrite);
end;

procedure TServerClientThread.HandleEvent(Sender: PObj; Socket: PCustomWinSocket;
  SocketEvent: TSocketEvent);
begin
  Event(SocketEvent);
end;

procedure TServerClientThread.HandleError(Sender: PObj; Socket: PCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Error(ErrorEvent, ErrorCode);
end;

procedure TServerClientThread.Event(SocketEvent: TSocketEvent);
begin
  FServerSocket.ClientEvent(@Self, ClientSocket, SocketEvent);
end;

procedure TServerClientThread.Error(ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  FServerSocket.ClientError(@Self, ClientSocket, ErrorEvent, ErrorCode);
end;

procedure TServerClientThread.HandleException;
begin
  FException := Exception(ExceptObject);
  try
    if not (FException.Code = err.e_Abort) then
       FServerClientThread.Synchronize(DoHandleException);
  finally
    FException := nil;
  end;
end;

function TServerClientThread.Execute(Sender: PThread):integer;
begin
  FServerSocket.ThreadStart(@Self);
  try
    try
      while True do
      begin
        if StartConnect then ClientExecute;
        if EndConnect then Break;
      end;
    except
      HandleException;
      KeepInCache := False;
    end;
  finally
    FServerSocket.ThreadEnd(@Self);
    Free_And_Nil(Self);
  end;
  result:=0;
end;

procedure TServerClientThread.ClientExecute;
var
  FDSet: TFDSet;
  TimeVal: TTimeVal;
begin
  while not FServerClientThread.Terminated and ClientSocket.Connected do
  begin
    FD_ZERO(FDSet);
    FD_SET(ClientSocket.SocketHandle, FDSet);
    TimeVal.tv_sec := 0;
    TimeVal.tv_usec := 500;
    if (select(0, @FDSet, nil, nil, @TimeVal) > 0) and not FServerClientThread.Terminated then
      if ClientSocket.ReceiveBuf(FDSet, -1) = 0 then Break
      else FServerClientThread.Synchronize(DoRead);
    if (select(0, nil, @FDSet, nil, @TimeVal) > 0) and not FServerClientThread.Terminated then
      FServerClientThread.Synchronize(DoWrite);
  end;
end;

function TServerClientThread.StartConnect: Boolean;
begin
  if FEvent.WaitFor(INFINITE) = wrSignaled then
    FEvent.ResetEvent;
  Result := not FServerClientThread.Terminated;
end;

function TServerClientThread.EndConnect: Boolean;
begin
  Free_And_Nil(FClientSocket);//.Free;
  FClientSocket := nil;
  Result := FServerClientThread.Terminated or not KeepInCache;
end;
  
{ TAbstractSocket }

procedure TAbstractSocket.DoEvent(Sender: PObj; Socket: PCustomWinSocket;
  SocketEvent: TSocketEvent);
begin
  Event(Socket, SocketEvent);
end;

procedure TAbstractSocket.DoError(Sender: PObj; Socket: PCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Error(Socket, ErrorEvent, ErrorCode);
end;

procedure TAbstractSocket.SetActive(Value: Boolean);
begin
  if Value <> FActive then
  begin
    //if (csDesigning in ComponentState) or (csLoading in ComponentState) then
      FActive := Value;
    //if not (csLoading in ComponentState) then
      DoActivate(Value);
  end;
end;

procedure TAbstractSocket.InitSocket(Socket: PCustomWinSocket);
begin
  Socket.OnSocketEvent := DoEvent;
  Socket.OnErrorEvent := DoError;
end;

procedure TAbstractSocket.Loaded;
begin
//  inherited Loaded;
  DoActivate(FActive);
end;

procedure TAbstractSocket.SetAddress(Value: string);
begin
  if AnsiCompareText(Value, FAddress) <> 0 then
  begin
    if {not (csLoading in ComponentState) and} FActive then
      raise ESocketError.Create(e_Custom,sCantChangeWhileActive);
    FAddress := Value;
  end;
end;

procedure TAbstractSocket.SetHost(Value: string);
begin
  if AnsiCompareText(Value, FHost) <> 0 then
  begin
    if {not (csLoading in ComponentState) and }FActive then
      raise ESocketError.Create(e_Custom,sCantChangeWhileActive);
    FHost := Value;
  end;
end;

procedure TAbstractSocket.SetPort(Value: Integer);
begin
  if FPort <> Value then
  begin
    if {not (csLoading in ComponentState) and }FActive then
      raise ESocketError.Create(e_Custom,sCantChangeWhileActive);
    FPort := Value;
  end;
end;

procedure TAbstractSocket.SetService(Value: string);
begin
  if AnsiCompareText(Value, FService) <> 0 then
  begin
    if {not (csLoading in ComponentState) and} FActive then
      raise ESocketError.Create(e_Custom,sCantChangeWhileActive);
    FService := Value;
  end;
end;

procedure TAbstractSocket.Open;
begin
  Active := True;
end;

procedure TAbstractSocket.Close;
begin
  Active := False;
end;
 
{ TCustomSocket }

procedure TCustomSocket.Event(Socket: PCustomWinSocket; SocketEvent: TSocketEvent);
begin
  case SocketEvent of
    seLookup: if Assigned(FOnLookup) then FOnLookup(@Self, Socket);
    seConnecting: if Assigned(FOnConnecting) then FOnConnecting(@Self, Socket);
    seConnect:
      begin
        FActive := True;
        if Assigned(FOnConnect) then FOnConnect(@Self, Socket);
      end;
    seListen:
      begin
        FActive := True;
        if Assigned(FOnListen) then FOnListen(@Self, Socket);
      end;
    seDisconnect:
      begin
        FActive := False;
        if Assigned(FOnDisconnect) then FOnDisconnect(@Self, Socket);
      end;
    seAccept: if Assigned(FOnAccept) then FOnAccept(@Self, Socket);
    seRead: if Assigned(FOnRead) then FOnRead(@Self, Socket);
    seWrite: if Assigned(FOnWrite) then FOnWrite(@Self, Socket);
  end;
end;

procedure TCustomSocket.Error(Socket: PCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if Assigned(FOnError) then FOnError(@Self, Socket, ErrorEvent, ErrorCode);
end;
 
{ TWinSocketStream }
function NewWinSocketStream(ASocket: PCustomWinSocket; TimeOut: Longint) : PWinSocketStream;
begin
  new(result,create(ASocket,TimeOut));
end;
constructor TWinSocketStream.Create(ASocket: PCustomWinSocket; TimeOut_: Longint);
begin
  if ASocket.ASyncStyles <> [] then
    raise ESocketError.Create(e_Custom,sSocketMustBeBlocking);
  FSocket := ASocket;
  FTimeOut := TimeOut_;
  FEvent := NewSimpleEvent;
  inherited Create;
end;

destructor TWinSocketStream.Destroy;
begin
  FEvent.Free;
  inherited Destroy;
end;

function TWinSocketStream.WaitForData(Timeout_: Longint): Boolean;
var
  FDSet: TFDSet;
  TimeVal: TTimeVal;
begin
  TimeVal.tv_sec := Timeout_ div 1000;
  TimeVal.tv_usec := (Timeout_ mod 1000) * 1000;
  FD_ZERO(FDSet);
  FD_SET(FSocket.SocketHandle, FDSet);
  Result := select(0, @FDSet, nil, nil, @TimeVal) > 0;
end;

function TWinSocketStream.Read(var Buffer; Count: Longint): Longint;
var
  Overlapped: TOverlapped;
  ErrorCode: Integer;
begin
  FSocket.Lock;
  try
    FillChar(OVerlapped, SizeOf(Overlapped), 0);
    Overlapped.hEvent := FEvent.Handle;
    if not ReadFile(FSocket.SocketHandle, Buffer, Count, DWORD(Result),
      @Overlapped) and (GetLastError <> ERROR_IO_PENDING) then
    begin
      ErrorCode := GetLastError;
      raise ESocketError.CreateResFmt(e_Custom,Integer(@sSocketIOError), [sSocketRead, ErrorCode,
        SysErrorMessage(ErrorCode)]);
    end;
    if FEvent.WaitFor(FTimeOut) <> wrSignaled then
      Result := 0
    else
    begin
      GetOverlappedResult(FSocket.SocketHandle, Overlapped, DWORD(Result), False);
      FEvent.ResetEvent;
    end;
  finally
    FSocket.Unlock;
  end;
end;

function TWinSocketStream.Write(const Buffer; Count: Longint): Longint;
var
  Overlapped: TOverlapped;
  ErrorCode: Integer;
begin
  FSocket.Lock;
  try
    FillChar(OVerlapped, SizeOf(Overlapped), 0);
    Overlapped.hEvent := FEvent.Handle;
    if not WriteFile(FSocket.SocketHandle, Buffer, Count, DWORD(Result),
      @Overlapped) and (GetLastError <> ERROR_IO_PENDING) then
    begin
      ErrorCode := GetLastError;
      raise ESocketError.CreateResFmt(e_Custom,Integer(@sSocketIOError), [sSocketWrite, ErrorCode,
        SysErrorMessage(ErrorCode)]);
    end;
    if FEvent.WaitFor(FTimeOut) <> wrSignaled then
      Result := 0
    else GetOverlappedResult(FSocket.SocketHandle, Overlapped, DWORD(Result), False);
  finally
    FSocket.Unlock;
  end;
end;

function TWinSocketStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := 0;
end;
 
{ TClientSocket }

function NewClientSocket{(AOwner: TObj)}: PClientSocket;
begin
  new(result,create);
end;
constructor TClientSocket.Create{(AOwner: TComponent)};
begin
  inherited Create;//(AOwner);

  FClientSocket := NewClientWinSocket;
  InitSocket(FClientSocket);
end;

destructor TClientSocket.Destroy;
begin
  FClientSocket.Destroy;
  inherited Destroy;
end;

procedure TClientSocket.DoActivate(Value: Boolean);
begin
  if (Value <> FClientSocket.Connected) {and not (csDesigning in ComponentState) }then
  begin
    if FClientSocket.Connected then
      FClientSocket.Disconnect(FClientSocket.FSocket)
    else FClientSocket.Open(FHost, FAddress, FService, FPort, ClientType = ctBlocking);
  end;
end;

function TClientSocket.GetClientType: TClientType;
begin
  Result := FClientSocket.ClientType;
end;

procedure TClientSocket.SetClientType(Value: TClientType);
begin
  FClientSocket.ClientType := Value;
end;

{ TCustomServerSocket }

function NewCustomServerSocket: PCustomServerSocket;
begin
  new(result);//,create);
  result.Active:=false;
  result.FServerSocket:=NewServerWinSocket(INVALID_SOCKET);
  result.servertype:=stnonblocking;
end;
destructor TCustomServerSocket.Destroy;
begin
//  Free_And_Nil(FServerSocket);
  FServerSocket.Destroy;
  inherited Destroy;
end;

procedure TCustomServerSocket.DoActivate(Value: Boolean);
begin
  if (Value <> FServerSocket.Connected) {and not (csDesigning in ComponentState) }then
  begin
    if FServerSocket.Connected then
      FServerSocket.Disconnect(FServerSocket.SocketHandle)
    else FServerSocket.Listen(FHost, FAddress, FService, FPort, SOMAXCONN);
  end;
end;

function TCustomServerSocket.GetServerType: TServerType;
begin
  Result := FServerSocket.ServerType;
end;

procedure TCustomServerSocket.SetServerType(Value: TServerType);
begin
  FServerSocket.ServerType := Value;
end;

function TCustomServerSocket.GetGetThreadEvent: TGetThreadEvent;
begin
  Result := FServerSocket.OnGetThread;
end;

procedure TCustomServerSocket.SetGetThreadEvent(Value: TGetThreadEvent);
begin
  FServerSocket.OnGetThread := Value;
end;

function TCustomServerSocket.GetGetSocketEvent: TGetSocketEvent;
begin
  Result := FServerSocket.OnGetSocket;
end;

procedure TCustomServerSocket.SetGetSocketEvent(Value: TGetSocketEvent);
begin
  FServerSocket.OnGetSocket := Value;
end;

function TCustomServerSocket.GetThreadCacheSize: Integer;
begin
  Result := FServerSocket.ThreadCacheSize;
end;

procedure TCustomServerSocket.SetThreadCacheSize(Value: Integer);
begin
  FServerSocket.ThreadCacheSize := Value;
end;

function TCustomServerSocket.GetOnThreadStart: TThreadNotifyEvent;
begin
  Result := FServerSocket.OnThreadStart;
end;

function TCustomServerSocket.GetOnThreadEnd: TThreadNotifyEvent;
begin
  Result := FServerSocket.OnThreadEnd;
end;

procedure TCustomServerSocket.SetOnThreadStart(Value: TThreadNotifyEvent);
begin
  FServerSocket.OnThreadStart := Value;
end;

procedure TCustomServerSocket.SetOnThreadEnd(Value: TThreadNotifyEvent);
begin
  FServerSocket.OnThreadEnd := Value;
end;

function TCustomServerSocket.GetOnClientEvent(Index: Integer): TSocketNotifyEvent;
begin
  case Index of
    0: Result := FServerSocket.OnClientRead;
    1: Result := FServerSocket.OnClientWrite;
    2: Result := FServerSocket.OnClientConnect;
    3: Result := FServerSocket.OnClientDisconnect;
  end;
end;

procedure TCustomServerSocket.SetOnClientEvent(Index: Integer;
  Value: TSocketNotifyEvent);
begin
  case Index of
    0: FServerSocket.OnClientRead := Value;
    1: FServerSocket.OnClientWrite := Value;
    2: FServerSocket.OnClientConnect := Value;
    3: FServerSocket.OnClientDisconnect := Value;
  end;
end;

function TCustomServerSocket.GetOnClientError: TSocketErrorEvent;
begin
  Result := FServerSocket.OnClientError;
end;

procedure TCustomServerSocket.SetOnClientError(Value: TSocketErrorEvent);
begin
  FServerSocket.OnClientError := Value;
end;
 
{ TServerSocket }

function NewServerSocket{(AOwner: TObj)}: PServerSocket;
begin
  new(Result,create{(AOwner)});
end;

constructor TServerSocket.Create{(AOwner: TObj)};
begin
  inherited Create;//(AOwner);
  FServerSocket := NewServerWinSocket(INVALID_SOCKET);

//  FServerSocket := TServerWinSocket.Create(INVALID_SOCKET);
  InitSocket(FServerSocket);
  FServerSocket.ThreadCacheSize := 10;

end;
destructor TServerSocket.Destroy;
begin
 inherited Destroy;
end;



end.
