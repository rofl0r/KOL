unit MckScktComp;

interface

uses
    KOL, KOLScktComp,Windows, Messages,Classes,  mirror, mckCtrls, MCKObjs ;

{$HINTS OFF}
type

  TKOLClientSocket = class(TKOLObj)
  private
    FActive:boolean;
    FClientSocket :PClientWinSocket;
    FPort: Integer;
    FAddress: string;
    FHost: string;
    FService: string;
    FClientType : TClientType;

    FOnLookup: TSocketNotifyEvent;
    FOnConnecting: TSocketNotifyEvent;
    FOnConnect: TSocketNotifyEvent;
    FOnDisconnect: TSocketNotifyEvent;
    FOnRead: TSocketNotifyEvent;
    FOnWrite: TSocketNotifyEvent;
    FOnError: TSocketErrorEvent;

  protected
     function TypeName: String; override;
     function AdditionalUnits: String; override;
     procedure AssignEvents(SL: TStringList; const AName: String); override;
     procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String);  override;
     procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;

     procedure SetActive(Value: Boolean);
     procedure SetAddress(Value: string);
     procedure SetHost(Value: string);
     procedure SetPort(Value: Integer);
     procedure SetService(Value: string);
     procedure SetClientType(Value: TClientType);

     procedure SetOnLookup(Value: TSocketNotifyEvent);
     procedure SetOnConnecting(Value: TSocketNotifyEvent);
     procedure SetOnConnect(Value: TSocketNotifyEvent);
     procedure SetOnDisconnect(Value: TSocketNotifyEvent);
     procedure SetOnRead(Value: TSocketNotifyEvent);
     procedure SetOnWrite(Value: TSocketNotifyEvent);
     procedure SetOnError(Value: TSocketErrorEvent);

  public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
    property Socket: PClientWinSocket read FClientSocket;
  published
    property Active : boolean read FActive write SetActive;
    property Address: string read FAddress write SetAddress;
    property Host: string read FHost write SetHost;
    property Port: Integer read FPort write SetPort;
    property Service: string read FService write SetService;
    property ClientType: TClientType read FClientType write SetClientType;

    property OnLookup: TSocketNotifyEvent read FOnLookup write SetOnLookup;
    property OnConnecting: TSocketNotifyEvent read FOnConnecting write SetOnConnecting;
    property OnConnect: TSocketNotifyEvent read FOnConnect write SetOnConnect;
    property OnDisconnect: TSocketNotifyEvent read FOnDisconnect write SetOnDisconnect;
    property OnRead: TSocketNotifyEvent read FOnRead write SetOnRead;
    property OnWrite: TSocketNotifyEvent read FOnWrite write SetOnWrite;
    property OnError: TSocketErrorEvent read FOnError write SetOnError;
  end;

  TKOLServerSocket = class(TKOLObj)

    private
     FActive:boolean;
     FPort : integer;
     FService : string;
     FServerType : TServerType;
     FThreadCacheSize : integer;

     FOnListen: TSocketNotifyEvent;
     FOnAccept: TSocketNotifyEvent;
     FOnGetSocket: TGetSocketEvent;
     FOnGetThread: TGetThreadEvent;
     FOnThreadStart: TThreadNotifyEvent;
     FOnThreadEnd: TThreadNotifyEvent;
     FOnClientConnect: TSocketNotifyEvent;
     FOnClientDisconnect: TSocketNotifyEvent;
     FOnClientRead: TSocketNotifyEvent;
     FOnClientWrite: TSocketNotifyEvent;
     FOnClientError: TSocketErrorEvent;

    protected
     function TypeName: String; override;
     function AdditionalUnits: String; override;
     procedure AssignEvents(SL: TStringList; const AName: String); override;
     procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String);  override;
     procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;


     procedure  SetActive(Value : boolean);
     procedure  SetPort(Value : integer);
     procedure  SetService(Value : string);
     procedure  SetServerType(Value : TServerType);
     procedure  SetThreadCacheSize(Value : integer);


     procedure SetOnListen(Value : TSocketNotifyEvent);
     procedure SetOnAccept(Value : TSocketNotifyEvent);
     procedure SetOnGetSocket(Value : TGetSocketEvent);
     procedure SetOnGetThread(Value : TGetThreadEvent);
     procedure SetOnThreadStart(Value : TThreadNotifyEvent);
     procedure SetOnThreadEnd(Value : TThreadNotifyEvent);
     procedure SetOnClientConnect(Value : TSocketNotifyEvent);
     procedure SetOnClientDisconnect(Value : TSocketNotifyEvent);
     procedure SetOnClientRead(Value : TSocketNotifyEvent);
     procedure SetOnClientWrite(Value : TSocketNotifyEvent);
     procedure SetOnClientError(Value : TSocketErrorEvent);

    public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
    published
     property Active:boolean  read FActive write SetActive;
     property Port : integer read FPort write SetPort;
     property Service : string read FService write SetService;
     property ServerType : TServerType read FServerType write SetServerType;
     property ThreadCacheSize : integer read FThreadCacheSize write SetThreadCacheSize  default 10;

     property OnListen: TSocketNotifyEvent           read   FOnListen            write  SetOnListen;
     property OnAccept: TSocketNotifyEvent           read   FOnAccept            write  SetOnAccept;
     property OnGetSocket: TGetSocketEvent           read   FOnGetSocket         write  SetOnGetSocket;
     property OnGetThread: TGetThreadEvent           read   FOnGetThread         write  SetOnGetThread;
     property OnThreadStart: TThreadNotifyEvent      read   FOnThreadStart       write  SetOnThreadStart;
     property OnThreadEnd: TThreadNotifyEvent        read   FOnThreadEnd         write  SetOnThreadEnd;
     property OnClientConnect: TSocketNotifyEvent    read   FOnClientConnect     write  SetOnClientConnect;
     property OnClientDisconnect: TSocketNotifyEvent read   FOnClientDisconnect  write  SetOnClientDisconnect;
     property OnClientRead: TSocketNotifyEvent       read   FOnClientRead        write  SetOnClientRead;
     property OnClientWrite: TSocketNotifyEvent      read   FOnClientWrite       write  SetOnClientWrite;
     property OnClientError: TSocketErrorEvent       read   FOnClientError       write  SetOnClientError;
  end;


procedure Register;
{$R *.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOL Sockets', [TKOLServerSocket,TKOLClientSocket]);
end;
{*****************************************************************}
{                  TKOLClientSocket                               }
{*****************************************************************}

{ ƒŒ¡¿¬À≈Õ»≈ ÃŒƒ”Àﬂ }
function TKOLClientSocket.AdditionalUnits;
begin
  Result := ', KOLScktComp';
end;

function TKOLClientSocket.TypeName: String;
begin
  Result := 'TKOLServerSocket';
end;
{--------------------------}
{ –≈√»—“–¿÷»ﬂ Œ¡–¿¡Œ“◊» Œ¬ }
{--------------------------}
procedure TKOLClientSocket.AssignEvents;
begin
inherited;
 DoAssignEvents(SL, AName, ['OnLookup'], [@OnLookup]);
 DoAssignEvents(SL, AName, ['OnConnecting'], [@OnConnecting]);
 DoAssignEvents(SL, AName, ['OnConnect'], [@OnConnect]);
 DoAssignEvents(SL, AName, ['OnDisconnect'], [@OnDisconnect]);
 DoAssignEvents(SL, AName, ['OnRead'], [@OnRead]);
 DoAssignEvents(SL, AName, ['OnWrite'], [@OnWrite]);
 DoAssignEvents(SL, AName, ['OnError'], [@OnError]);
end;
{--------------------------}
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
{--------------------------}
procedure TKOLClientSocket.SetupFirst;
begin
 SL.Add(Prefix + AName + ' := NewClientSocket;');
end;
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
procedure TKOLClientSocket.SetupLast;
const BoolToStr: array [Boolean] of String = ('FALSE', 'TRUE');
ClientTypeToStr: array [TClientType] of String = ('ctNonBlocking', 'ctBlocking');

begin
 SL.Add(Prefix + AName + '.Active:='+ BoolToStr[Active]+';');
 SL.Add(Prefix + AName + '.Address:='''+ Address+''';');
 SL.Add(Prefix + AName + '.Host:='''+ Host+''';');
 SL.Add(Prefix + AName + '.Port:='+ Int2Str(Port)+';');
 SL.Add(Prefix + AName + '.Service:='''+ Service+''';');
 SL.Add(Prefix + AName + '.ClientType:='+ ClientTypeToStr[ClientType]+';');
end;

constructor TKOLClientSocket.Create;
begin
 inherited;   
end;
destructor TKOLClientSocket.Destroy;
begin
 inherited;
end;

procedure  TKOLClientSocket.SetActive(Value :boolean);
begin
  FActive := Value;
  Change;
end;
procedure  TKOLClientSocket.SetAddress(Value: string);
begin
  FAddress := Value;
  Change;
end;
procedure  TKOLClientSocket.SetHost(Value: string);
begin
  FHost := Value;
  Change;
end;
procedure  TKOLClientSocket.SetPort(Value: Integer);
begin
  FPort := Value;
  Change;
end;
procedure  TKOLClientSocket.SetService(Value: string);
begin
  FService := Value;
  Change;
end;
procedure  TKOLClientSocket.SetClientType(Value: TClientType);
begin
  FClientType := Value;
  Change;
end;

procedure  TKOLClientSocket.SetOnLookup(Value: TSocketNotifyEvent);
begin
  FOnLookup := Value;
  Change;
end;
procedure  TKOLClientSocket.SetOnConnecting(Value: TSocketNotifyEvent);
begin
  FOnConnecting := Value;
  Change;
end;
procedure  TKOLClientSocket.SetOnConnect(Value: TSocketNotifyEvent);
begin
  FOnConnect := Value;
  Change;
end;
procedure  TKOLClientSocket.SetOnDisconnect(Value: TSocketNotifyEvent);
begin
  FOnDisconnect := Value;
  Change;
end;
procedure  TKOLClientSocket.SetOnRead(Value: TSocketNotifyEvent);
begin
  FOnRead := Value;
  Change;
end;
procedure  TKOLClientSocket.SetOnWrite(Value: TSocketNotifyEvent);
begin
  FOnWrite := Value;
  Change;
end;
procedure  TKOLClientSocket.SetOnError(Value: TSocketErrorEvent);
begin
  FOnError := Value;
  Change;
end;


{*****************************************************************}
{                  TKOLServerSocket                               }
{*****************************************************************}
{ ƒŒ¡¿¬À≈Õ»≈ ÃŒƒ”Àﬂ }
function TKOLServerSocket.AdditionalUnits;
begin
  Result := ', KOLScktComp';
end;

function TKOLServerSocket.TypeName: String;
begin
  Result := 'TKOLServerSocket';
end;
{--------------------------}
{ –≈√»—“–¿÷»ﬂ Œ¡–¿¡Œ“◊» Œ¬ }
{--------------------------}
procedure TKOLServerSocket.AssignEvents;
begin
inherited;
 DoAssignEvents(SL, AName, ['OnListen'], [@OnListen]);
 DoAssignEvents(SL, AName, ['OnAccept'], [@OnAccept]);
 DoAssignEvents(SL, AName, ['OnGetSocket'], [@OnGetSocket]);
 DoAssignEvents(SL, AName, ['OnGetThread'], [@OnGetThread]);
 DoAssignEvents(SL, AName, ['OnThreadStart'], [@OnThreadStart]);
 DoAssignEvents(SL, AName, ['OnThreadEnd'], [@OnThreadEnd]);
 DoAssignEvents(SL, AName, ['OnClientConnect'], [@OnClientConnect]);
 DoAssignEvents(SL, AName, ['OnClientDisconnect'], [@OnClientDisconnect]);
 DoAssignEvents(SL, AName, ['OnClientRead'], [@OnClientRead]);
 DoAssignEvents(SL, AName, ['OnClientWrite'], [@OnClientWrite]);
 DoAssignEvents(SL, AName, ['OnClientError'], [@OnClientError]);
end;
{--------------------------}
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
{--------------------------}
procedure TKOLServerSocket.SetupFirst;
begin
 SL.Add(Prefix + AName + ' := NewServerSocket;');
end;
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
procedure TKOLServerSocket.SetupLast;
const BoolToStr: array [Boolean] of String = ('FALSE', 'TRUE');
ServerTypeToStr: array [TServerType] of String = ('stNonBlocking','stThreadBlocking');
begin
 SL.Add(Prefix + AName + '.Active:='+ BoolToStr[Active]+';');
 SL.Add(Prefix + AName + '.Port:='+ Int2Str(Port)+';');
 SL.Add(Prefix + AName + '.Service:='''+ Service+''';');
 SL.Add(Prefix + AName + '.ServerType:='+ ServerTypeToStr[ServerType]+';');
 SL.Add(Prefix + AName + '.ThreadCacheSize:='+ Int2Str(ThreadCacheSize)+';');
end;

constructor TKOLServerSocket.Create;
begin
 inherited;   
end;
destructor TKOLServerSocket.Destroy;
begin
 inherited;
end;

procedure  TKOLServerSocket.SetActive(Value :boolean);
begin
  FActive := Value;
  Change;
end;
procedure  TKOLServerSocket.SetPort(Value : integer);
begin
  FPort := Value;
  Change;
end;
procedure  TKOLServerSocket.SetService(Value : string);
begin
  FService := Value;
  Change;
end;
procedure  TKOLServerSocket.SetServerType(Value : TServerType);
begin
  FServerType := Value;
  Change;
end;
procedure  TKOLServerSocket.SetThreadCacheSize(Value : integer);
begin
  FThreadCacheSize := Value;
  Change;
end;

procedure TKOLServerSocket.SetOnListen(Value : TSocketNotifyEvent);
begin
  FOnListen := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnAccept(Value : TSocketNotifyEvent);
begin
  FOnAccept := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnClientConnect;
begin
  fOnClientConnect := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnGetSocket(Value : TGetSocketEvent);
begin
  FOnGetSocket := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnGetThread(Value : TGetThreadEvent);
begin
  FOnGetThread := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnThreadStart(Value : TThreadNotifyEvent);
begin
  FOnThreadStart := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnThreadEnd(Value : TThreadNotifyEvent);
begin
  FOnThreadEnd := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnClientDisconnect(Value : TSocketNotifyEvent);
begin
  FOnClientDisconnect := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnClientRead(Value : TSocketNotifyEvent);
begin
  FOnClientRead := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnClientWrite(Value : TSocketNotifyEvent);
begin
  FOnClientWrite := Value;
  Change;
end;
procedure TKOLServerSocket.SetOnClientError(Value : TSocketErrorEvent);
begin
  FOnClientError := Value;
  Change;
end;
{$HINTS ON}




end.
