unit kolTCPSocket;

////////////////////////////////////////////////////////////////////
//
//               TTTTTTTTTT   CCCCCCCC   PPPPPPPPP
//               T  TTTT  T  CCCC  CCCC  PPPP  PPPP
//                  TTTT     CCCC        PPPP  PPPP
//                  TTTT     CCCC        PPPP  PPPP
//                  TTTT     CCCC        PPPPPPPPP
//                  TTTT     CCCC  CCCC  PPPP
//                  TTTT      CCCCCCCC   PPPP
//
//                S     O     C     K     E     T
//
//   TCPServer, TCPClient implementation for Key Objects Library
//
//   (c) 2002 by Vorobets Roman
//                     Roman.Vorobets@p25.f8.n454.z2.fidonet.org
//
////////////////////////////////////////////////////////////////////

interface

uses
  kol,windows,winsock,messages;

const
  WM_SOCKET=WM_USER+1;
  WM_SOCKETDESTROY=WM_USER+2;

type
  twndmethod=procedure(var message:tmessage) of object;

  PTCPBase=^TTCPBase;
  PTCPServer=^TTCPServer;
  PTCPClient=^TTCPClient;
  PTCPServerClient=^TTCPServerClient;

  TKOLTCPClient=PTCPClient;
  TKOLTCPServer=PTCPServer;

  TOnTCPClientEvent = procedure(Sender: PTCPClient) of object;
  TOnTCPStreamSend = TOnTCPClientEvent;
  TOnTCPStreamReceive = TOnTCPClientEvent;
  TOnTCPConnect = TOnTCPClientEvent;
  TOnTCPManualReceive = TOnTCPClientEvent;
  TOnTCPDisconnect = TOnTCPClientEvent;

  TOnTCPReceive = procedure(Sender: PTCPClient; var Buf: array of byte; const Count: Integer) of object;
  TOnTCPResolve = procedure(Sender: PTCPClient; const IP: String) of object;
  TOnTCPAccept = function(Sender: PTCPServer; const IP: String;
    const Port: SmallInt):boolean of object;
  TOnTCPClientConnect = procedure(Sender: PTCPServerClient) of object;
  TOnTCPError = procedure(Sender: PObj; const Error:integer) of object;

  TTCPBase=object(TObj)
  private
    FWnd:HWnd;
    FConnecting: Boolean;
    function GetWnd: HWnd;
    procedure Method(var message:tmessage);virtual;
    procedure DoClose;
  private
    FPort: SmallInt;
    FOnConnect: TOnTCPConnect;
    FOnDisconnect: TOnTCPDisconnect;
    FOnError: TOnTCPError;
    FHandle: TSocket;
    FConnected: Boolean;
    FSection: TRTLCriticalSection;
    property Wnd:HWnd read GetWnd;
    function GetPort: SmallInt;
    procedure SetPort(const Value: SmallInt);
    procedure SetOnConnect(const Value: TOnTCPConnect);
    procedure SetOnDisconnect(const Value: TOnTCPDisconnect);
    procedure SetOnError(const Value: TOnTCPError);
    procedure SetHandle(const Value: TSocket);
    function ErrorTest(const e: integer): boolean;
  protected
    procedure Creating;virtual;
    destructor Destroy;virtual;
  public
    property Connected:Boolean read FConnected;
    property Online:Boolean read FConnected;
    property Connecting:Boolean read FConnecting;
    property Handle:TSocket read FHandle write SetHandle;
    property Port:SmallInt read GetPort{FPort} write SetPort;
    property OnError:TOnTCPError read FOnError write SetOnError;
    property OnConnect:TOnTCPConnect read FOnConnect write SetOnConnect;
    property OnDisconnect:TOnTCPDisconnect read FOnDisconnect write SetOnDisconnect;
    procedure Lock;
    procedure Unlock;
    procedure Disconnect;virtual;
  end;

  TTCPServer=object(TTCPBase)
  private
    FConnections: PList;
    FOnAccept: TOnTCPAccept;
    FOnClientConnect: TOnTCPClientConnect;
    FOnClientDisconnect: TOnTCPDisconnect;
    FOnClientError: TOnTCPError;
    FOnClientReceive: TOnTCPReceive;
    FOnClientManualReceive: TOnTCPManualReceive;
    FOnClientStreamReceive: TOnTCPStreamReceive;
    FOnClientStreamSend: TOnTCPStreamSend;
    procedure SetOnAccept(const Value: TOnTCPAccept);
    procedure SetOnClientConnect(const Value: TOnTCPClientConnect);
    procedure SetOnClientDisconnect(const Value: TOnTCPDisconnect);
    procedure SetOnClientError(const Value: TOnTCPError);
    procedure SetOnClientReceive(const Value: TOnTCPReceive);
    function GetConnection(Index: Integer): PTCPServerClient;
    function GetCount: Integer;
    procedure Method(var message: tmessage); virtual;
    procedure SetOnClientManualReceive(const Value: TOnTCPManualReceive);
    procedure SetOnClientStreamReceive(const Value: TOnTCPStreamReceive);
    procedure SetOnClientStreamSend(const Value: TOnTCPStreamSend);
  protected
    procedure Creating;virtual;
    destructor Destroy;virtual;
  public
    property OnAccept:TOnTCPAccept read FOnAccept write SetOnAccept;
    property OnClientError:TOnTCPError read FOnClientError write SetOnClientError;
    property OnClientConnect:TOnTCPClientConnect read FOnClientConnect write SetOnClientConnect;
    property OnClientDisconnect:TOnTCPDisconnect read FOnClientDisconnect write SetOnClientDisconnect;
    property OnClientReceive:TOnTCPReceive read FOnClientReceive write SetOnClientReceive;
    property OnClientManualReceive:TOnTCPManualReceive read FOnClientManualReceive write SetOnClientManualReceive;
    property OnClientStreamSend:TOnTCPStreamSend read FOnClientStreamSend write SetOnClientStreamSend;
    property OnClientStreamReceive:TOnTCPStreamReceive read FOnClientStreamReceive write SetOnClientStreamReceive;
    property Count:Integer read GetCount;
    property Connection[Index: Integer]: PTCPServerClient read GetConnection;
    procedure Listen;
    procedure Disconnect;virtual;
  end;

  TTCPClient=object(TTCPBase)
  private
    FHost: String;
    FBuffer: array[0..4095] of byte;
    FOnResolve: TOnTCPResolve;
    FOnReceive: TOnTCPReceive;
    FOnStreamSend: TOnTCPStreamSend;
    FSendStream: PStream;
    FSendAutoFree: Boolean;
    FReceiveStream: PStream;
    FReceiveAutoFree: Boolean;
    FReceiveAutoFreeSize: Integer;
    FReceiveStartPos: Integer;
    FOnManualReceive: TOnTCPManualReceive;
    FOnStreamReceive: TOnTCPStreamReceive;
    FIndex: Integer;
    procedure SetHost(const Value: String);
    procedure SetOnResolve(const Value: TOnTCPResolve);
    procedure SetOnReceive(const Value: TOnTCPReceive);
    procedure SetOnStreamSend(const Value: TOnTCPStreamSend);
    procedure Method(var message:tmessage);virtual;
    function SendStreamPiece: Boolean;
    procedure SetOnManualReceive(const Value: TOnTCPManualReceive);
    procedure SetOnStreamReceive(const Value: TOnTCPStreamReceive);
    procedure SetIndex(const Value: Integer);virtual;
  protected
    destructor Destroy;virtual;
  public
    property OnReceive:TOnTCPReceive read FOnReceive write SetOnReceive;
    property OnManualReceive:TOnTCPManualReceive read FOnManualReceive write SetOnManualReceive;
    property OnResolve:TOnTCPResolve read FOnResolve write SetOnResolve;
    property OnStreamSend:TOnTCPStreamSend read FOnStreamSend write SetOnStreamSend;
    property OnStreamReceive:TOnTCPStreamReceive read FOnStreamReceive write SetOnStreamReceive;
    property Host:String read FHost write SetHost;
    property Index:Integer read FIndex write SetIndex;
    function StreamSending:Boolean;
    function StreamReceiving:Boolean;
    procedure Connect;virtual;
    function Send(var Buf; const Count: Integer): Integer;
    procedure SendString(S: String);
    function SendStream(Stream: PStream; const AutoFree: Boolean): Boolean;
    procedure SetReceiveStream(Stream: PStream; const AutoFree: Boolean=false;
      const AutoFreeSize: Integer=0);
    function ReceiveLength: Integer;
    function ReceiveBuf(var Buf; Count: Integer): Integer;
  end;

  TTCPServerClient=object(TTCPClient)
  private
    FIP: String;
    FServer: PTCPServer;
    procedure SetIndex(const Value: Integer);virtual;
  public
    property IP: String read FIP;
    procedure Connect;virtual;
    procedure Disconnect;virtual;
  end;

function NewTCPServer: PTCPServer;
function NewTCPClient: PTCPClient;
function Err2Str(const id: integer): string;
function TCPGetHostByName(name: pchar): string;

implementation

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

  wsadata:twsadata;

function NewTCPServerClient(Server: PTCPServer): PTCPServerClient;forward;

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

var
  utilclass:twndclass=(lpfnwndproc:@defwindowproc;lpszclassname:'TCPSocket');

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

procedure Startup;
begin
  if bool(wsastartup($101,wsadata)) then showmessage('WSAStartup error.');
end;

procedure Cleanup;
begin
  if bool(wsacleanup) then showmessage('WSACleanup error');
end;

{ TTCPBase }

procedure TTCPBase.Creating;
begin
  startup;
  initializecriticalsection(fsection);
  fhandle:=SOCKET_ERROR;
end;

destructor TTCPBase.Destroy;
begin
  if fwnd<>0 then deallocatehwnd(fwnd);
  doclose;
  disconnect;
  deletecriticalsection(fsection);
  cleanup;
end;

procedure TTCPBase.Disconnect;
begin
  if fhandle<>SOCKET_ERROR then
  begin
    doclose;
    if fconnected then
    begin
      fconnected:=false;
      if assigned(ondisconnect) then ondisconnect(@self);
    end;
    fconnecting:=false;
  end;
end;

procedure TTCPBase.DoClose;
begin
  if fhandle<>SOCKET_ERROR then
  begin
    errortest(closesocket(fhandle));
    fhandle:=SOCKET_ERROR;
  end;  
end;

function TTCPBase.ErrorTest(const e: integer): boolean;
var
  wsae:integer;
begin
  result:=(e=SOCKET_ERROR) or (e=INVALID_SOCKET);
  if result then
  begin
    wsae:=wsagetlasterror;
    if wsae<>WSAEWOULDBLOCK then
    begin
      if assigned(onerror) then onerror(@self,wsae) else
        showmessage('Socket error '+err2str(wsae)+' on socket '+int2str(fhandle));
    end else result:=false;   
  end;
end;

function TTCPBase.GetWnd: HWnd;
begin
  if fwnd=0 then fwnd:=allocatehwnd(method);
  result:=fwnd;
end;

procedure TTCPBase.Lock;
begin
  entercriticalsection(fsection);
end;

procedure TTCPBase.Method(var message: tmessage);
begin
  if message.msg<>WM_SOCKET then exit;
  if message.lparamhi>WSABASEERR then
  begin
    wsasetlasterror(message.lparamhi);
    errortest(SOCKET_ERROR);
    if fconnecting then doclose;
    fconnecting:=false;
  end;
  case message.lparamlo of
  FD_CLOSE:begin
      fconnected:=false;
      fconnecting:=false;
      if assigned(ondisconnect) then ondisconnect(@self);
      if fhandle<>SOCKET_ERROR then doclose;
    end;
  end;
end;

procedure TTCPBase.SetHandle(const Value: TSocket);
begin
  FHandle := Value;
end;

procedure TTCPBase.SetOnDisconnect(const Value: TOnTCPDisconnect);
begin
  FOnDisconnect := Value;
end;

procedure TTCPBase.SetOnError(const Value: TOnTCPError);
begin
  FOnError := Value;
end;

procedure TTCPBase.SetPort(const Value: SmallInt);
begin
  FPort := Value;
end;

function TTCPBase.GetPort: SmallInt;
var buf: sockaddr_in; bufSz: Integer;
begin
  if FConnected then
  begin
    bufSz := SizeOf(buf);
    ZeroMemory( @buf, bufSz );
    getsockname(fhandle, buf, bufSz);
    FPort := htons(buf.sin_port);
  end;
  Result := FPort;
end;

function NewTCPServer: PTCPServer;
begin
  new(result,create);
  result.creating;
end;

function NewTCPClient: PTCPClient;
begin
  new(result,create);
  result.creating;
end;

function NewTCPServerClient(Server: PTCPServer): PTCPServerClient;
begin
  new(result,create);
  result.creating;
  result.fserver:=server;
end;

procedure TTCPBase.Unlock;
begin
  leavecriticalsection(fsection);
end;

{ TTCPClient }

procedure TTCPClient.Connect;
var
  adr:tsockaddr;
begin
  disconnect;
  fhandle:=socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
  if not errortest(fhandle) then
  begin
    wsaasyncselect(fhandle,wnd,WM_SOCKET,FD_READ or FD_WRITE or FD_CONNECT or FD_CLOSE);
    with adr do
    begin
      sin_family:=AF_INET;
      sin_port:=htons(port);
      integer(sin_addr):=inet_addr(pchar(host));
//      if integer(sin_addr)=SOCKET_ERROR then
//      begin  {must be WSAAsyncGetHostByName}
//        ph:=winsock.gethostbyname(pchar(host));
//        if ph=nil then showmessage('gethostbyname() error');
//        move(ph.h_addr^^,sin_addr,ph.h_length);
//        if assigned(onresolve) then onresolve(@self,inet_ntoa(adr.sin_addr));
//      end;
    end;
    fconnecting:=not errortest(integer(adr.sin_addr)) and
      not errortest(winsock.connect(fhandle,adr,sizeof(adr)));
    if not fconnecting then doclose;
  end;
end;

destructor TTCPClient.Destroy;
begin
  if fsendautofree and (fsendstream<>nil) then fsendstream.free;
  fsendstream:=nil;
  inherited;
end;

function TTCPClient.StreamReceiving: Boolean;
begin
  result:=freceivestream<>nil;
end;

function TTCPClient.StreamSending: Boolean;
begin
  result:=bool(fsendstream);
end;

procedure TTCPClient.Method(var message: tmessage);
var
  sz:integer;
begin
  inherited;
  if (message.msg<>WM_SOCKET) then exit;
  if message.lparamhi>WSABASEERR then
  begin
    if message.lparamlo=FD_CLOSE then
    begin
      if streamsending then
      begin
        if fsendautofree then fsendstream.free;
        if assigned(onstreamsend) then onstreamsend(@self);
      end;
      if streamreceiving then
      begin
        if freceiveautofree then freceivestream.free;
        if assigned(onstreamreceive) then onstreamreceive(@self);
      end;
    end;
  end else
  case message.lparamlo of
  FD_CONNECT:begin
        fconnected:=true;
        fconnecting:=false;
        if assigned(onconnect) then onconnect(@self);
      end;
  FD_READ:if (freceivestream=nil) and assigned(onmanualreceive) then onmanualreceive(@self) else
      begin
        lock;
//        repeat
          ioctlsocket(fhandle,FIONREAD,sz);
          if sz>0 then
          begin
            if sz>sizeof(fbuffer) then sz:=sizeof(fbuffer);
            sz:=receivebuf(fbuffer,sz);
            errortest(sz);
            if freceivestream<>nil then
            begin
              freceivestream.write(fbuffer,sz);
              if assigned(onstreamreceive) then onstreamreceive(@self);
            end else if assigned(onreceive) then onreceive(@self,fbuffer,sz);
          end;
//        until (sz<=0) or //not fmaxsendstreamspeed or
//          ((freceivestream<>nil) and freceiveautofree and
//           (freceivestream.size>=freceiveautofreesize));
        unlock;
        if (freceivestream<>nil) and freceiveautofree and
           (integer(freceivestream.position)+freceivestartpos>=freceiveautofreesize) then
        begin
          freceivestream.free;
          freceivestream:=nil;
          if assigned(onstreamreceive) then onstreamreceive(@self);
        end;
      end;
  FD_WRITE:if streamsending then sendstreampiece;// else if assigned(onwrite) then onwrite(@self);
  end;
end;

function TTCPClient.ReceiveBuf(var Buf; Count: Integer): Integer;
begin
  result:=0;
  if not fconnected or (fhandle=SOCKET_ERROR) or (count<=0) then exit;
  lock;
  result:=recv(fhandle,buf,count,0);
  errortest(result);
  unlock;
end;

function TTCPClient.ReceiveLength: Integer;
begin
  ioctlsocket(fhandle,FIONREAD,result);
end;

function TTCPClient.Send(var Buf; const Count: Integer): Integer;
begin
  result:=winsock.send(fhandle,buf,count,0);
end;

function TTCPClient.SendStream(Stream: PStream; const AutoFree: Boolean): Boolean;
begin
  result:=false;
  if fsendstream=nil then
  begin
    fsendstream:=stream;
    fsendautofree:=autofree;
    result:=sendstreampiece;
  end;
end;

function TTCPClient.SendStreamPiece: Boolean;
var
  buf:array[0..4095] of byte;
  startpos,amountinbuf,amountsent:integer;
begin
  result:=false;
  if not fconnected or (fhandle=SOCKET_ERROR) or (fsendstream=nil) then exit;
  lock;
  repeat
    startpos:=fsendstream.position;
    amountinbuf:=fsendstream.read(buf,sizeof(buf));
    if amountinbuf>0 then
    begin
      amountsent:=send(buf,amountinbuf);
      if amountsent=SOCKET_ERROR then
      begin
        if errortest(SOCKET_ERROR) then
        begin
          fsendstream:=nil;
          break;
        end else
        begin
          fsendstream.position:=startpos;
          break;
        end;
      end else
      if amountinbuf>amountsent then fsendstream.position:=startpos+amountsent else
      if fsendstream.position=fsendstream.size then
      begin
        if fsendautofree then fsendstream.free;
        fsendstream:=nil;
        break;
      end;
    end else
    begin            
      fsendstream:=nil;
      break;
    end;
  until false;
  result:=true;
  unlock;
  if assigned(onstreamsend) then onstreamsend(@self);
end;

procedure TTCPClient.SendString(S: String);
begin
  send(s[1],length(s));
end;                    

procedure TTCPClient.SetHost(const Value: String);
begin
  FHost := Value;
end;

procedure TTCPClient.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

procedure TTCPBase.SetOnConnect(const Value: TOnTCPConnect);
begin
  FOnConnect := Value;
end;

procedure TTCPClient.SetOnManualReceive(const Value: TOnTCPManualReceive);
begin
  FOnManualReceive := Value;
end;

procedure TTCPClient.SetOnReceive(const Value: TOnTCPReceive);
begin
  FOnReceive := Value;
end;

procedure TTCPClient.SetOnResolve(const Value: TOnTCPResolve);
begin
  FOnResolve := Value;
end;

procedure TTCPClient.SetOnStreamReceive(const Value: TOnTCPStreamReceive);
begin
  FOnStreamReceive := Value;
end;

procedure TTCPClient.SetOnStreamSend(const Value: TOnTCPStreamSend);
begin
  FOnStreamSend := Value;
end;

procedure TTCPClient.SetReceiveStream(Stream: PStream; const AutoFree: Boolean=false;
  const AutoFreeSize: Integer=0);
begin
  if autofree and (autofreesize=0) then exit;
  if freceivestream<>nil then freceivestream.free;
  freceiveautofree:=autofree;
  freceiveautofreesize:=autofreesize;
  freceivestartpos:=stream.position;
  freceivestream:=stream;
end;

{ TTCPServer }

procedure TTCPServer.Creating;
begin
  inherited;
  fconnections:=newlist;
end;

destructor TTCPServer.Destroy;
var
  i:integer;
begin
  for i:=0 to pred(count) do connection[i].free;
  fconnections.free;
  fconnections:=nil;
  inherited;
end;

procedure TTCPServer.Disconnect;
begin
  if fconnections=nil then exit;
  lock;
  while count>0 do connection[0].disconnect;
  unlock;
  inherited;
end;

function TTCPServer.GetConnection(Index: Integer): PTCPServerClient;
begin
  result:=ptcpserverclient(fconnections.items[index]);
end;

function TTCPServer.GetCount: Integer;
begin
  result:=fconnections.count;
end;

procedure TTCPServer.Listen;
var
  adr:tsockaddr;
begin
  if fhandle<>SOCKET_ERROR then exit;
  fhandle:=socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
  if not errortest(fhandle) then
  begin
    with adr do
    begin
      sin_family:=AF_INET;
      sin_port:=htons(port);
      integer(sin_addr):=INADDR_ANY;
    end;
    if errortest(bind(fhandle,adr,sizeof(adr))) then doclose else
    begin
      wsaasyncselect(fhandle,wnd,WM_SOCKET,FD_ACCEPT or FD_CLOSE or FD_CONNECT);
      if errortest(winsock.listen(fhandle,64)) then
        doclose
      else
      begin
        FConnected := True;
        if assigned(onconnect) then onconnect(@self);
      end;
    end;
  end;
end;

procedure TTCPServer.Method(var message: tmessage);
var
  adr:tsockaddr;
  sz:integer;
  sock:TSocket;
  sclient:ptcpserverclient;
begin
  inherited;
  case message.msg of
  WM_SOCKET:
    if message.lparamhi<=WSABASEERR then
    case message.lparamlo of
    FD_ACCEPT:begin
        sz:=sizeof(adr);
        sock:=accept(fhandle,@adr,@sz);
        if not errortest(sock) then
        begin
          if not assigned(onaccept) or onaccept(@self,inet_ntoa(adr.sin_addr),htons(adr.sin_port)) then
          begin
            sclient:=newtcpserverclient(@self);
            with sclient^ do
            begin
              wsaasyncselect(sock,wnd,WM_SOCKET,FD_READ or FD_WRITE or FD_CLOSE);
              fhost:=inet_ntoa(adr.sin_addr);
              fport:=htons(adr.sin_port);
              fip:=fhost;
              fhandle:=sock;
              fconnected:=true;
              fconnecting:=false;
              findex:=fconnections.count;
              onerror:=onclienterror;
              ondisconnect:=onclientdisconnect;
              onreceive:=onclientreceive;
              onmanualreceive:=onclientmanualreceive;
              onstreamsend:=onclientstreamsend;
              onstreamreceive:=onclientstreamreceive;
            end;
            fconnections.add(sclient);
            if assigned(onclientconnect) then onclientconnect(sclient);
          end else closesocket(sock);
        end;  
      end;
    end;
  WM_SOCKETDESTROY:ptcpserverclient(message.wparam).free;
  end;
end;

procedure TTCPServer.SetOnAccept(const Value: TOnTCPAccept);
begin
  FOnAccept := Value;
end;

procedure TTCPServer.SetOnClientConnect(const Value: TOnTCPClientConnect);
begin
  FOnClientConnect := Value;
end;

procedure TTCPServer.SetOnClientDisconnect(const Value: TOnTCPDisconnect);
begin
  FOnClientDisconnect := Value;
end;

procedure TTCPServer.SetOnClientError(const Value: TOnTCPError);
begin
  FOnClientError := Value;
end;

procedure TTCPServer.SetOnClientManualReceive( const Value: TOnTCPManualReceive);
begin
  FOnClientManualReceive := Value;
end;

procedure TTCPServer.SetOnClientReceive(const Value: TOnTCPReceive);
begin
  FOnClientReceive := Value;
end;

function Err2Str(const id: integer): string;
begin
  case id of
  WSAEINTR:result:='WSAEINTR';
  WSAEBADF:result:='WSAEBADF';
  WSAEACCES:result:='WSAEACCES';
  WSAEFAULT:result:='WSAEFAULT';
  WSAEINVAL:result:='WSAEINVAL';
  WSAEMFILE:result:='WSAEMFILE';
  WSAEWOULDBLOCK:result:='WSAEWOULDBLOCK';
  WSAEINPROGRESS:result:='WSAEINPROGRESS';
  WSAEALREADY:result:='WSAEALREADY';
  WSAENOTSOCK:result:='WSAENOTSOCK';
  WSAEDESTADDRREQ:result:='WSAEDESTADDRREQ';
  WSAEMSGSIZE:result:='WSAEMSGSIZE';
  WSAEPROTOTYPE:result:='WSAEPROTOTYPE';
  WSAENOPROTOOPT:result:='WSAENOPROTOOPT';
  WSAEPROTONOSUPPORT:result:='WSAEPROTONOSUPPORT';
  WSAESOCKTNOSUPPORT:result:='WSAESOCKTNOSUPPORT';
  WSAEOPNOTSUPP:result:='WSAEOPNOTSUPP';
  WSAEPFNOSUPPORT:result:='WSAEPFNOSUPPORT';
  WSAEAFNOSUPPORT:result:='WSAEAFNOSUPPORT';
  WSAEADDRINUSE:result:='WSAEADDRINUSE';
  WSAEADDRNOTAVAIL:result:='WSAEADDRNOTAVAIL';
  WSAENETDOWN:result:='WSAENETDOWN';
  WSAENETUNREACH:result:='WSAENETUNREACH';
  WSAENETRESET:result:='WSAENETRESET';
  WSAECONNABORTED:result:='WSAECONNABORTED';
  WSAECONNRESET:result:='WSAECONNRESET';
  WSAENOBUFS:result:='WSAENOBUFS';
  WSAEISCONN:result:='WSAEISCONN';
  WSAENOTCONN:result:='WSAENOTCONN';
  WSAESHUTDOWN:result:='WSAESHUTDOWN';
  WSAETOOMANYREFS:result:='WSAETOOMANYREFS';
  WSAETIMEDOUT:result:='WSAETIMEDOUT';
  WSAECONNREFUSED:result:='WSAECONNREFUSED';
  WSAELOOP:result:='WSAELOOP';
  WSAENAMETOOLONG:result:='WSAENAMETOOLONG';
  WSAEHOSTDOWN:result:='WSAEHOSTDOWN';
  WSAEHOSTUNREACH:result:='WSAEHOSTUNREACH';
  WSAENOTEMPTY:result:='WSAENOTEMPTY';
  WSAEPROCLIM:result:='WSAEPROCLIM';
  WSAEUSERS:result:='WSAEUSERS';
  WSAEDQUOT:result:='WSAEDQUOT';
  WSAESTALE:result:='WSAESTALE';
  WSAEREMOTE:result:='WSAEREMOTE';
  WSASYSNOTREADY:result:='WSASYSNOTREADY';
  WSAVERNOTSUPPORTED:result:='WSAVERNOTSUPPORTED';
  WSANOTINITIALISED:result:='WSANOTINITIALISED';
  WSAHOST_NOT_FOUND:result:='WSAHOST_NOT_FOUND';
  WSATRY_AGAIN:result:='WSATRY_AGAIN';
  WSANO_RECOVERY:result:='WSANO_RECOVERY';
  WSANO_DATA:result:='WSANO_DATA';
  else result:='WSAEUNKNOWN';
  end;
end;

procedure TTCPServer.SetOnClientStreamReceive( const Value: TOnTCPStreamReceive);
begin
  FOnClientStreamReceive := Value;
end;

procedure TTCPServer.SetOnClientStreamSend(const Value: TOnTCPStreamSend);
begin
  FOnClientStreamSend := Value;
end;

{ TTCPServerClient }

procedure TTCPServerClient.Connect;
begin
  showmessage('Can''t connect ServerClient');
end;

procedure TTCPServerClient.Disconnect;
var
  i,j:integer;
  srv:ptcpserver;
begin
  if fserver<>nil then
  begin
    srv:=fserver;
    fserver:=nil;
    srv.lock;
    i:=srv.fconnections.indexof(@self);
    for j:=pred(srv.fconnections.count) downto succ(i) do dec(srv.connection[j].findex);
    srv.fconnections.delete(i);
    srv.unlock;
    postmessage(srv.wnd,WM_SOCKETDESTROY,integer(@self),0);
  end;
  inherited;
end;

function TCPGetHostByName(name: pchar): string;
var
  host:phostent;
  adr:in_addr;
begin
  host:=gethostbyname(name);
  move(host.h_addr^^,adr,host.h_length);
  result:=inet_ntoa(adr);
end;

procedure TTCPServerClient.SetIndex(const Value: Integer);
begin
  showmessage('Can''t set index of ServerClient');
end;

initialization
  instblocklist:=nil;
  instfreelist:=nil;

end.
