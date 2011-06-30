// 19-nov-2002
unit IdStack;

interface

uses KOL { , 
  Classes } {,
  IdException},
  IdStackConsts, IdGlobal;

type
  TIdServeFile = function(ASocket: TIdStackSocketHandle; AFileName: string):
    cardinal;

  TIdStackVersion = object
  (TObj)
  protected
    FMaxUdpDg: Cardinal;
    FMaxSockets: Cardinal;
    FVersion: Word;
    FLowVersion: Word;
    FDescription: string;
    FVendorInfo: string;
    FSystemStatus: string;
    FName: string;
     { constructor Create(InfoStruct: Pointer); virtual;  }{ abstract;}
   { published }
    property Name: string read FName;
    property Version: Word read FVersion;
    property LowVersion: Word read FLowVersion;
    property Description: string read FDescription;
    property SystemStatus: string read FSystemStatus;
    property MaxSockets: Cardinal read FMaxSockets;
    property MaxUdpDg: Cardinal read FMaxUdpDg;
    property VendorInfo: string read FVendorInfo;
  end;
PIdStackVersion=^TIdStackVersion;
function NewIdStackVersion(InfoStruct: Pointer):PIdStackVersion;
type

  TIdSunB = packed record
    s_b1, s_b2, s_b3, s_b4: byte;
  end;

  TIdSunW = packed record
    s_w1, s_w2: word;
  end;

  PIdInAddr = ^TIdInAddr;
  TIdInAddr = record
    case integer of
      0: (S_un_b: TIdSunB);
      1: (S_un_w: TIdSunW);
      2: (S_addr: longword);
  end;

  PIdStack=^TIdStack;
  TIdStack = object
  (TObj)protected
    FStackVersion: PIdStackVersion;
    FLocalAddress: string;
    FLocalAddresses: PStrList;
    procedure PopulateLocalAddresses; virtual; abstract;
    function WSGetLocalAddress: string; virtual; abstract;
    function WSGetLocalAddresses: PStrList; virtual; abstract;
  public
    function CheckForSocketError(const AResult: integer = Id_SOCKET_ERROR):
      boolean; overload;
    function CheckForSocketError(const AResult: integer; const AIgnore: array of
      integer)
      : boolean; overload;
     { constructor Create;  }{ reintroduce; virtual;}
    destructor Destroy;
     virtual;{ object (TObj)function CreateStack: TIdStack;}
    class function CreateStack:PIdStack;
    function CreateSocketHandle(const ASocketType: Integer;
      const AProtocol: Integer = Id_IPPROTO_IP): TIdStackSocketHandle;
    function IsIP(AIP: string): boolean;
    procedure RaiseSocketError(const AErr: integer);
    function ResolveHost(const AHost: string): string;
    function WSAccept(ASocket: TIdStackSocketHandle; var VIP: string; var VPort:
      Integer)
      : TIdStackSocketHandle; virtual; abstract;
    function WSBind(ASocket: TIdStackSocketHandle; const AFamily: Integer;
      const AIP: string; const APort: Integer): Integer; virtual; abstract;
    function WSCloseSocket(ASocket: TIdStackSocketHandle): Integer; virtual;
      abstract;
    function WSConnect(const ASocket: TIdStackSocketHandle; const AFamily:
      Integer;
      const AIP: string; const APort: Integer): Integer; virtual; abstract;
    function WSGetHostByName(const AHostName: string): string; virtual;
      abstract;
    function WSGetHostName: string; virtual; abstract;
    function WSGetHostByAddr(const AAddress: string): string; virtual; abstract;
    function WSGetServByName(const AServiceName: string): Integer; virtual;
      abstract;
    function WSGetServByPort(const APortNumber: Integer): PStrList; virtual;
      abstract;
    function WSHToNs(AHostShort: Word): Word; virtual; abstract;
    function WSListen(ASocket: TIdStackSocketHandle; ABackLog: Integer): Integer;
      virtual; abstract;
    function WSNToHs(ANetShort: Word): Word; virtual; abstract;
    function WSHToNL(AHostLong: LongWord): LongWord; virtual; abstract;
    function WSNToHL(ANetLong: LongWord): LongWord; virtual; abstract;
    function WSRecv(ASocket: TIdStackSocketHandle; var ABuffer; ABufferLength,
      AFlags: Integer)
      : Integer; virtual; abstract;
    function WSRecvFrom(const ASocket: TIdStackSocketHandle; var ABuffer;
      const ALength, AFlags: Integer; var VIP: string; var VPort: Integer):
        Integer; virtual;
      abstract;
    function WSSelect(ARead, AWrite, AErrors: PList; ATimeout: Integer): Integer;
      virtual; abstract;
    function WSSend(ASocket: TIdStackSocketHandle; var ABuffer;
      const ABufferLength, AFlags: Integer): Integer; virtual; abstract;
    function WSSendTo(ASocket: TIdStackSocketHandle; var ABuffer;
      const ABufferLength, AFlags: Integer; const AIP: string; const APort:
        integer): Integer;
      virtual; abstract;
    function WSSetSockOpt(ASocket: TIdStackSocketHandle; ALevel, AOptName:
      Integer; AOptVal: PChar;
      AOptLen: Integer): Integer; virtual; abstract;
    function WSSocket(AFamily, AStruct, AProtocol: Integer):
      TIdStackSocketHandle; virtual; abstract;
    function WSShutdown(ASocket: TIdStackSocketHandle; AHow: Integer): Integer;
      virtual; abstract;
    function WSTranslateSocketErrorMsg(const AErr: integer): string; virtual;
    function WSGetLastError: Integer; virtual; abstract;
    procedure WSGetPeerName(ASocket: TIdStackSocketHandle; var AFamily: Integer;
      var AIP: string; var APort: Integer); virtual; abstract;
    procedure WSGetSockName(ASocket: TIdStackSocketHandle; var AFamily: Integer;
      var AIP: string; var APort: Integer); virtual; abstract;
    function StringToTInAddr(AIP: string): TIdInAddr;
    function TInAddrToString(var AInAddr): string; virtual; abstract;
    procedure TranslateStringToTInAddr(AIP: string; var AInAddr); virtual;
      abstract;

    property LocalAddress: string read WSGetLocalAddress;
    property LocalAddresses: PStrList read WSGetLocalAddresses;

    property StackVersion: PIdStackVersion read FStackVersion;
  end;
function NewIdStack:PIdStack;

{  EIdStackError = object(EIdException);
PdStack=^IdStack; type  MyStupid86104=DWord;
  EIdStackInitializationFailed = object(EIdStackError);
PStack=^dStack; type  MyStupid20258=DWord;
  EIdStackSetSizeExceeded = object(EIdStackError);
Ptack=^Stack; type  MyStupid27292=DWord;}

var
  GStack: PIdStack = nil;
  GServeFileProc: TIdServeFile = nil;

implementation

uses
{$IFDEF LINUX}
  IdStackLinux,
{$ELSE}
  IdStackWinsock,
{$ENDIF}
  IdResourceStrings,
  SysUtils;

function NewIdStackVersion(InfoStruct: Pointer):PIdStackVersion;
begin
  New( Result, Create );
end;

function TIdStack.CheckForSocketError(const AResult: integer): boolean;
begin
  result := CheckForSocketError(AResult, []);
end;

function TIdStack.CheckForSocketError(const AResult: integer;
  const AIgnore: array of integer): boolean;
var
  i, nErr: integer;
begin
  Result := false;
  if AResult = Id_SOCKET_ERROR then
  begin
    nErr := WSGetLastError;
    for i := Low(AIgnore) to High(AIgnore) do
    begin
      if nErr = AIgnore[i] then
      begin
        Result := True;
        exit;
      end;
    end;
    RaiseSocketError(nErr);
  end;
end;

function TIdStack.CreateSocketHandle(const ASocketType: Integer;
  const AProtocol: Integer = Id_IPPROTO_IP): TIdStackSocketHandle;
begin
  result := WSSocket(Id_PF_INET, ASocketType, AProtocol);
  if result = Id_INVALID_SOCKET then
  begin
//    raise EIdInvalidSocket.Create(RSCannotAllocateSocket);
  end;
end;

procedure TIdStack.RaiseSocketError(const AErr: integer);
begin
  (*
    RRRRR    EEEEEE   AAAA   DDDDD         MM     MM  EEEEEE    !!  !!  !!
    RR  RR   EE      AA  AA  DD  DD        MMMM MMMM  EE        !!  !!  !!
    RRRRR    EEEE    AAAAAA  DD   DD       MM MMM MM  EEEE      !!  !!  !!
    RR  RR   EE      AA  AA  DD  DD        MM     MM  EE
    RR   RR  EEEEEE  AA  AA  DDDDD         MM     MM  EEEEEE    ..  ..  ..

    Please read the note in the next comment.

  *)
//  raise EIdSocketError.CreateError(AErr, WSTranslateSocketErrorMsg(AErr));
  (*
    It is normal to receive a 10038 exception (10038, NOT others!) here when
    *shutting down* (NOT at other times!) servers (NOT clients!).

    If you receive a 10038 exception here please see the FAQ at:
    http://www.nevrona.com/Indy/FAQ.html

    If you get a 10038 exception here, and HAVE NOT read the FAQ and ask about this in the public
    forums
    you will be publicly flogged, tarred and feathered and your name added to every chain
    letter in existence today.

    If you insist upon requesting help via our email boxes on the 10038 error that is already
    answered in the FAQ and you are simply too slothful to search for your answer and ask your
    question in the public forums you may be publicly flogged, tarred and feathered and your name
    may be added to every chain letter / EMail in existence today."

    Otherwise, if you DID read the FAQ and have further questions, please feel free to ask using
    one of the methods (Carefullly note that these methods do not list email) listed on the Tech
    Support link at http://www.nevrona.com/Indy/

    RRRRR    EEEEEE   AAAA   DDDDD         MM     MM  EEEEEE    !!  !!  !!
    RR  RR   EE      AA  AA  DD  DD        MMMM MMMM  EE        !!  !!  !!
    RRRRR    EEEE    AAAAAA  DD   DD       MM MMM MM  EEEE      !!  !!  !!
    RR  RR   EE      AA  AA  DD  DD        MM     MM  EE
    RR   RR  EEEEEE  AA  AA  DDDDD         MM     MM  EEEEEE    ..  ..  ..
  *)
end;

function NewIdStack:PIdStack;
begin
  New( Result, Create );
end;
{
constructor TIdStack.Create;
begin
end;}


class function TIdStack.CreateStack: PIdStack;//TIdStack;
begin
{$IFDEF LINUX}
  result := NewIdStackLinux;//TIdStackLinux.Create;
{$ELSE}
  result := NewIdStackWinsock;//TIdStackWinsock.Create;
{$ENDIF}
end;


function TIdStack.ResolveHost(const AHost: string): string;
begin
  if AnsiSameText(AHost, 'LOCALHOST') then
  begin
    result := '127.0.0.1';
  end
  else
    if IsIP(AHost) then
  begin
    result := AHost;
  end
  else
  begin
    result := WSGetHostByName(AHost);
  end;
end;

function TIdStack.WSTranslateSocketErrorMsg(const AErr: integer): string;
begin
  Result := '';
  case AErr of
    Id_WSAEINTR: Result := RSStackEINTR;
    Id_WSAEBADF: Result := RSStackEBADF;
    Id_WSAEACCES: Result := RSStackEACCES;
    Id_WSAEFAULT: Result := RSStackEFAULT;
    Id_WSAEINVAL: Result := RSStackEINVAL;
    Id_WSAEMFILE: Result := RSStackEMFILE;

    Id_WSAEWOULDBLOCK: Result := RSStackEWOULDBLOCK;
    Id_WSAEINPROGRESS: Result := RSStackEINPROGRESS;
    Id_WSAEALREADY: Result := RSStackEALREADY;
    Id_WSAENOTSOCK: Result := RSStackENOTSOCK;
    Id_WSAEDESTADDRREQ: Result := RSStackEDESTADDRREQ;
    Id_WSAEMSGSIZE: Result := RSStackEMSGSIZE;
    Id_WSAEPROTOTYPE: Result := RSStackEPROTOTYPE;
    Id_WSAENOPROTOOPT: Result := RSStackENOPROTOOPT;
    Id_WSAEPROTONOSUPPORT: Result := RSStackEPROTONOSUPPORT;
    Id_WSAESOCKTNOSUPPORT: Result := RSStackESOCKTNOSUPPORT;
    Id_WSAEOPNOTSUPP: Result := RSStackEOPNOTSUPP;
    Id_WSAEPFNOSUPPORT: Result := RSStackEPFNOSUPPORT;
    Id_WSAEAFNOSUPPORT: Result := RSStackEAFNOSUPPORT;
    Id_WSAEADDRINUSE: Result := RSStackEADDRINUSE;
    Id_WSAEADDRNOTAVAIL: Result := RSStackEADDRNOTAVAIL;
    Id_WSAENETDOWN: Result := RSStackENETDOWN;
    Id_WSAENETUNREACH: Result := RSStackENETUNREACH;
    Id_WSAENETRESET: Result := RSStackENETRESET;
    Id_WSAECONNABORTED: Result := RSStackECONNABORTED;
    Id_WSAECONNRESET: Result := RSStackECONNRESET;
    Id_WSAENOBUFS: Result := RSStackENOBUFS;
    Id_WSAEISCONN: Result := RSStackEISCONN;
    Id_WSAENOTCONN: Result := RSStackENOTCONN;
    Id_WSAESHUTDOWN: Result := RSStackESHUTDOWN;
    Id_WSAETOOMANYREFS: Result := RSStackETOOMANYREFS;
    Id_WSAETIMEDOUT: Result := RSStackETIMEDOUT;
    Id_WSAECONNREFUSED: Result := RSStackECONNREFUSED;
    Id_WSAELOOP: Result := RSStackELOOP;
    Id_WSAENAMETOOLONG: Result := RSStackENAMETOOLONG;
    Id_WSAEHOSTDOWN: Result := RSStackEHOSTDOWN;
    Id_WSAEHOSTUNREACH: Result := RSStackEHOSTUNREACH;
    Id_WSAENOTEMPTY: Result := RSStackENOTEMPTY;
  end;
  Result := Format(RSStackError, [AErr, Result]);
end;

function TIdStack.IsIP(AIP: string): boolean;
var
  s1, s2, s3, s4: string;

  function ByteIsOk(const AByte: string): boolean;
  begin
    result := (StrToIntDef(AByte, -1) > -1) and (StrToIntDef(AByte, 256) < 256);
  end;

begin
  s1 := Fetch(AIP, '.');
  s2 := Fetch(AIP, '.');
  s3 := Fetch(AIP, '.');
  s4 := AIP;
  result := ByteIsOk(s1) and ByteIsOk(s2) and ByteIsOk(s3) and ByteIsOk(s4);
end;

destructor TIdStack.Destroy;
begin
  FLocalAddresses.Free;
  inherited;
end;

function TIdStack.StringToTInAddr(AIP: string): TIdInAddr;
begin
  TranslateStringToTInAddr(AIP, result);
end;

end.
