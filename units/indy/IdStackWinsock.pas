// 20-nov-2002
unit IdStackWinsock;

interface

uses KOL { , 
  Classes } ,
  IdStack, IdStackConsts, IdWinsock,
  Windows;

type
  TIdStackVersionWinsock = object(TIdStackVersion)
  public
     { constructor create(InfoStruct: Pointer); override;
   } end;
PIdStackVersionWinsock=^TIdStackVersionWinsock;
function NewIdStackVersionWinsock(InfoStruct: Pointer):PIdStackVersionWinsock; type  MyStupid0=DWord;

  TIdStackWinsock = object(TIdStack)
  protected
    procedure PopulateLocalAddresses; virtual;{override;}
    function WSGetLocalAddress: string; virtual;{override;}
    function WSGetLocalAddresses: PStrList; virtual;{override;}
  public
    procedure Init; virtual;
     { constructor Create; override;
     } destructor Destroy;
     virtual;
     function TInAddrToString(var AInAddr): string; virtual; //override;
    procedure TranslateStringToTInAddr(AIP: string; var AInAddr); virtual; //override;
    //
    function WSAccept(ASocket: TIdStackSocketHandle; var VIP: string; var VPort:
      Integer)
      : TIdStackSocketHandle; virtual; //override;
    function WSBind(ASocket: TIdStackSocketHandle; const AFamily: Integer;
      const AIP: string; const APort: Integer): Integer; virtual;//override;
    function WSCloseSocket(ASocket: TIdStackSocketHandle): Integer; virtual;//override;
    function WSConnect(const ASocket: TIdStackSocketHandle; const AFamily:
      Integer;
      const AIP: string; const APort: Integer): Integer; virtual;//override;
    function WSGetHostByAddr(const AAddress: string): string; virtual;//override;
    function WSGetHostByName(const AHostName: string): string; virtual;//override;
    function WSGetHostName: string; virtual;//override;
    function WSGetServByName(const AServiceName: string): Integer; virtual;//override;
    function WSGetServByPort(const APortNumber: Integer): PStrList; virtual;//override;
    procedure WSGetPeerName(ASocket: TIdStackSocketHandle; var VFamily: Integer;
      var VIP: string; var VPort: Integer); virtual;//override;
    procedure WSGetSockName(ASocket: TIdStackSocketHandle; var VFamily: Integer;
      var VIP: string; var VPort: Integer); virtual;//override;
    function WSHToNs(AHostShort: Word): Word; virtual;//override;
    function WSListen(ASocket: TIdStackSocketHandle; ABackLog: Integer): Integer;
      virtual;//override;
    function WSNToHs(ANetShort: Word): Word; virtual;//override;
    function WSHToNL(AHostLong: LongWord): LongWord; virtual;//override;
    function WSNToHL(ANetLong: LongWord): LongWord; virtual;//override;
    function WSRecv(ASocket: TIdStackSocketHandle; var ABuffer; ABufferLength,
      AFlags: Integer)
      : integer; virtual;//override;
    function WSRecvFrom(const ASocket: TIdStackSocketHandle; var ABuffer;
      const ALength, AFlags: Integer; var VIP: string; var VPort: Integer):
        Integer; virtual;//override;
    function WSSelect(ARead, AWrite, AErrors: PList; ATimeout: Integer): Integer;
      virtual;//override;
    function WSSend(ASocket: TIdStackSocketHandle; var ABuffer;
      const ABufferLength, AFlags: Integer): Integer; virtual;//override;
    function WSSendTo(ASocket: TIdStackSocketHandle; var ABuffer;
      const ABufferLength, AFlags: Integer; const AIP: string; const APort:
        integer): Integer;
     virtual;// override;
    function WSSetSockOpt(ASocket: TIdStackSocketHandle; ALevel, AOptName:
      Integer; AOptVal: PChar;
      AOptLen: Integer): Integer; virtual;//override;
    function WSSocket(AFamily, AStruct, AProtocol: Integer):
      TIdStackSocketHandle;virtual;// override;
    function WSShutdown(ASocket: TIdStackSocketHandle; AHow: Integer): Integer;
      virtual;//override;
    function WSGetLastError: Integer; virtual;//override;
  end;
PIdStackWinsock=^TIdStackWinsock;
function NewIdStackWinsock:PIdStackWinsock;
type

  TLinger = record
    l_onoff: Word;
    l_linger: Word;
  end;

  TIdLinger = TLinger;

implementation

uses
  {IdException,}
  IdGlobal, IdResourceStrings,
  SysUtils;


function NewIdStackWinsock:PIdStackWinsock;
//constructor TIdStackWinsock.Create;
var
  sData: TWSAData;
begin
  New( Result, Create );
  Result.Init;
{  with Result^ do
  begin
//  inherited;
  LoadWinsock;
  if WSAStartup($101, sData) = SOCKET_ERROR then
  begin
//    raise EIdStackInitializationFailed.Create(RSWinsockInitializationError);
  end;
    FStackVersion := NewIdStackVersionWinsock(@Result);// TIdStackVersionWinsock.Create(@sData);
  end;
       }
end;

procedure TIdStackWinsock.Init;
var
  sData: TWSAData;
begin
  inherited;
//  with Result^ do
  begin
//  inherited;
  LoadWinsock;
  if WSAStartup($101, sData) = SOCKET_ERROR then
  begin
//    raise EIdStackInitializationFailed.Create(RSWinsockInitializationError);
  end;
    FStackVersion := NewIdStackVersionWinsock({@Result}@Self);// TIdStackVersionWinsock.Create(@sData);
  end;
end;

destructor TIdStackWinsock.Destroy;
begin
  WSACancelBlockingCall;
  WSACleanup;
  UnloadWinsock;
  FStackVersion.Free;
  inherited;
end;

function TIdStackWinsock.TInAddrToString(var AInAddr): string;
begin
  with TInAddr(AInAddr).S_un_b do
  begin
    result := IntToStr(Ord(s_b1)) + '.' + IntToStr(Ord(s_b2)) + '.' +
      IntToStr(Ord(s_b3)) + '.'
      + IntToStr(Ord(s_b4));
  end;
end;

function TIdStackWinsock.WSAccept(ASocket: TIdStackSocketHandle;
  var VIP: string; var VPort: Integer): TIdStackSocketHandle;
var
  i: Integer;
  Addr: TSockAddr;
begin
  i := SizeOf(addr);
  result := Accept(ASocket, @addr, @i);
  VIP := TInAddrToString(Addr.sin_addr);
  VPort := NToHs(Addr.sin_port);
end;

function TIdStackWinsock.WSBind(ASocket: TIdStackSocketHandle;
  const AFamily: Integer; const AIP: string;
  const APort: Integer): Integer;
var
  Addr: TSockAddrIn;
begin
  Addr.sin_family := AFamily;
  if length(AIP) = 0 then
  begin
    Addr.sin_addr.s_addr := INADDR_ANY;
  end
  else
  begin
    Addr.sin_addr := TInAddr(StringToTInAddr(AIP));
  end;
  Addr.sin_port := HToNS(APort);
  result := Bind(ASocket, addr, SizeOf(Addr));
end;

function TIdStackWinsock.WSCloseSocket(ASocket: TIdStackSocketHandle): Integer;
begin
  result := CloseSocket(ASocket);
end;

function TIdStackWinsock.WSConnect(const ASocket: TIdStackSocketHandle;
  const AFamily: Integer; const AIP: string;
  const APort: Integer): Integer;
var
  Addr: TSockAddrIn;
begin
  Addr.sin_family := AFamily;
  Addr.sin_addr := TInAddr(StringToTInAddr(AIP));
  Addr.sin_port := HToNS(APort);
  result := Connect(ASocket, Addr, SizeOf(Addr));
end;

function TIdStackWinsock.WSGetHostByName(const AHostName: string): string;
var
  pa: PChar;
  sa: TInAddr;
  Host: PHostEnt;
begin
  Host := GetHostByName(PChar(AHostName));
  if Host = nil then
  begin
    CheckForSocketError(SOCKET_ERROR);
  end
  else
  begin
    pa := Host^.h_addr_list^;
    sa.S_un_b.s_b1 := pa[0];
    sa.S_un_b.s_b2 := pa[1];
    sa.S_un_b.s_b3 := pa[2];
    sa.S_un_b.s_b4 := pa[3];
    result := TInAddrToString(sa);
  end;
end;

function TIdStackWinsock.WSGetHostByAddr(const AAddress: string): string;
var
  Host: PHostEnt;
  LAddr: Longint;
begin
  LAddr := inet_addr(PChar(AAddress));
  Host := GetHostByAddr(@LAddr, SizeOf(LAddr), AF_INET);
  if Host = nil then
  begin
    CheckForSocketError(SOCKET_ERROR);
  end
  else
  begin
    result := Host^.h_name;
  end;
end;

function TIdStackWinsock.WSGetHostName: string;
begin
  SetLength(result, 250);
  GetHostName(PChar(result), Length(result));
  Result := string(PChar(result));
end;

function TIdStackWinsock.WSListen(ASocket: TIdStackSocketHandle;
  ABackLog: Integer): Integer;
begin
  result := Listen(ASocket, ABacklog);
end;

function TIdStackWinsock.WSRecv(ASocket: TIdStackSocketHandle; var ABuffer;
  ABufferLength
  , AFlags: Integer): integer;
begin
  result := Recv(ASocket, ABuffer, ABufferLength, AFlags);
end;

function TIdStackWinsock.WSRecvFrom(const ASocket: TIdStackSocketHandle;
  var ABuffer; const ALength, AFlags: Integer; var VIP: string;
  var VPort: Integer): Integer;
var
  iSize: integer;
  Addr: TSockAddrIn;
begin
  iSize := SizeOf(Addr);
  result := RecvFrom(ASocket, ABuffer, ALength, AFlags, Addr, iSize);
  VIP := TInAddrToString(Addr.sin_addr);
  VPort := NToHs(Addr.sin_port);
end;

function TIdStackWinsock.WSSelect(ARead, AWrite, AErrors: PList; ATimeout:
  Integer): Integer;
var
  tmTo: TTimeVal;
  FDRead, FDWrite, FDError: TFDSet;

  procedure GetFDSet(AList: PList; var ASet: TFDSet);
  var
    i: Integer;
  begin
    if assigned(AList) then
    begin
      AList.Clear;
      AList.Capacity := ASet.fd_count;
      for i := 0 to ASet.fd_count - 1 do
      begin
        AList.Add(TObject(ASet.fd_array[i]));
      end;
    end;
  end;

  procedure SetFDSet(AList: PList; var ASet: TFDSet);
  var
    i: integer;
  begin
    if AList <> nil then
    begin
      if AList.Count > FD_SETSIZE then
      begin
{        raise EIdStackSetSizeExceeded.Create(RSSetSizeExceeded);}
      end;
      for i := 0 to AList.Count - 1 do
      begin
        ASet.fd_array[i] := TIdStackSocketHandle(AList.Items[i]);
      end;
      ASet.fd_count := AList.Count;
    end;
  end;

begin
  FillChar(FDRead, SizeOf(FDRead), 0);
  FillChar(FDWrite, SizeOf(FDWrite), 0);
  FillChar(FDError, SizeOf(FDError), 0);
  SetFDSet(ARead, FDRead);
  SetFDSet(AWrite, FDWrite);
  SetFDSet(AErrors, FDError);
  if ATimeout = IdTimeoutInfinite then
  begin
    Result := Select(0, @FDRead, @FDWrite, @FDError, nil);
  end
  else
  begin
    tmTo.tv_sec := ATimeout div 1000;
    tmTo.tv_usec := (ATimeout mod 1000) * 1000;
    Result := Select(0, @FDRead, @FDWrite, @FDError, @tmTO);
  end;
  GetFDSet(ARead, FDRead);
  GetFDSet(AWrite, FDWrite);
  GetFDSet(AErrors, FDError);
end;

function TIdStackWinsock.WSSend(ASocket: TIdStackSocketHandle;
  var ABuffer; const ABufferLength, AFlags: Integer): Integer;
begin
  result := Send(ASocket, ABuffer, ABufferLength, AFlags);
end;

function TIdStackWinsock.WSSendTo(ASocket: TIdStackSocketHandle;
  var ABuffer; const ABufferLength, AFlags: Integer; const AIP: string;
  const APort: integer): Integer;
var
  Addr: TSockAddrIn;
begin
  FillChar(Addr, SizeOf(Addr), 0);
  with Addr do
  begin
    sin_family := Id_PF_INET;
    sin_addr := TInAddr(StringToTInAddr(AIP));
    sin_port := HToNs(APort);
  end;
  result := SendTo(ASocket, ABuffer, ABufferLength, AFlags, Addr, SizeOf(Addr));
end;

function TIdStackWinsock.WSSetSockOpt(ASocket: TIdStackSocketHandle;
  ALevel, AOptName: Integer; AOptVal: PChar; AOptLen: Integer): Integer;
begin
  result := SetSockOpt(ASocket, ALevel, AOptName, AOptVal, AOptLen);
end;

function TIdStackWinsock.WSGetLocalAddresses: PStrList;
begin
  if FLocalAddresses = nil then
  begin
    FLocalAddresses := NewStrList;//PStrList//.Create;
  end;
  PopulateLocalAddresses;
  Result := FLocalAddresses;
end;

function TIdStackWinsock.WSGetLastError: Integer;
begin
  result := WSAGetLastError;
end;

function TIdStackWinsock.WSSocket(AFamily, AStruct, AProtocol: Integer):
  TIdStackSocketHandle;
begin
  result := Socket(AFamily, AStruct, AProtocol);
end;

function TIdStackWinsock.WSHToNs(AHostShort: Word): Word;
begin
  result := HToNs(AHostShort);
end;

function TIdStackWinsock.WSNToHs(ANetShort: Word): Word;
begin
  result := NToHs(ANetShort);
end;

function TIdStackWinsock.WSGetServByName(const AServiceName: string): Integer;
var
  ps: PServEnt;
begin
  ps := GetServByName(PChar(AServiceName), nil);
  if ps <> nil then
  begin
    Result := Ntohs(ps^.s_port);
  end
  else
  begin
    try
      Result := StrToInt(AServiceName);
    except
//      on EConvertError do
      ;
{        raise EIdInvalidServiceName.CreateFmt(RSInvalidServiceName,
        [AServiceName]);}
    end;
  end;
end;

function TIdStackWinsock.WSGetServByPort(
  const APortNumber: Integer): PStrList;
var
  ps: PServEnt;
  i: integer;
  p: array of PChar;
begin
  Result := NewStrList;//PStrList.Create;
  p := nil;
  try
    ps := GetServByPort(HToNs(APortNumber), nil);
    if ps <> nil then
    begin
      Result.Add(ps^.s_name);
      i := 0;
      p := pointer(ps^.s_aliases);
      while p[i] <> nil do
      begin
        Result.Add(PChar(p[i]));
        inc(i);
      end;
    end;
  except
    Result.Free;
  end;
end;

function TIdStackWinsock.WSHToNL(AHostLong: LongWord): LongWord;
begin
  Result := HToNL(AHostLong);
end;

function TIdStackWinsock.WSNToHL(ANetLong: LongWord): LongWord;
begin
  Result := NToHL(ANetLong);
end;

procedure TIdStackWinsock.PopulateLocalAddresses;
type
  TaPInAddr = array[0..250] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  i: integer;
  AHost: PHostEnt;
  PAdrPtr: PaPInAddr;
begin
  FLocalAddresses.Clear;
  AHost := GetHostByName(PChar(WSGetHostName));
  if AHost = nil then
  begin
    CheckForSocketError(SOCKET_ERROR);
  end
  else
  begin
    PAdrPtr := PAPInAddr(AHost^.h_addr_list);
    i := 0;
    while PAdrPtr^[i] <> nil do
    begin
      FLocalAddresses.Add(TInAddrToString(PAdrPtr^[I]^));
      Inc(I);
    end;
  end;
end;

function TIdStackWinsock.WSGetLocalAddress: string;
begin
  Result := LocalAddresses.Items[0];
end;

function NewIdStackVersionWinsock(InfoStruct: Pointer):PIdStackVersionWinsock;
//constructor TIdStackVersionWinsock.create(InfoStruct: Pointer);
var
  aData: PWSAData;

  procedure SetProp(var PropHolder: string; Value: PChar);
  begin
    if value <> nil then
      PropHolder := Value
    else
      PropHolder := '';
  end;
begin
  New( Result, Create );
  with Result^ do
  begin
  aData := InfoStruct;
  FMaxUdpDg := aData^.iMaxUdpDg;
  FMaxSockets := aData^.iMaxSockets;
  FVersion := aData^.wHighVersion;
  FLowVersion := aData^.wVersion;

  Setprop(FDescription, aData^.szDescription);
  Setprop(FSystemStatus, aData^.szSystemStatus);
  FName := RSWSockStack;
  end;
end;

function ServeFile(ASocket: TIdStackSocketHandle; AFileName: string): cardinal;
var
  LFileHandle: THandle;
begin
  result := 0;
  LFileHandle := CreateFile(PChar(AFileName), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING
    , FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  try
    if TransmitFile(ASocket, LFileHandle, 0, 0, nil, nil, 0) then
    begin
      result := getFileSize(LFileHandle, nil);
    end;
  finally CloseHandle(LFileHandle);
  end;
end;

procedure TIdStackWinsock.TranslateStringToTInAddr(AIP: string; var AInAddr);
begin
  with TInAddr(AInAddr).S_un_b do
  begin
    s_b1 := Chr(StrToInt(Fetch(AIP, '.')));
    s_b2 := Chr(StrToInt(Fetch(AIP, '.')));
    s_b3 := Chr(StrToInt(Fetch(AIP, '.')));
    s_b4 := Chr(StrToInt(Fetch(AIP, '.')));
  end;
end;

function TIdStackWinsock.WSShutdown(ASocket: TIdStackSocketHandle; AHow:
  Integer): Integer;
begin
  result := Shutdown(ASocket, AHow);
end;

procedure TIdStackWinsock.WSGetPeerName(ASocket: TIdStackSocketHandle;
  var VFamily: Integer; var VIP: string; var VPort: Integer);
var
  i: Integer;
  LAddr: TSockAddrIn;
begin
  i := SizeOf(LAddr);
  CheckForSocketError(GetPeerName(ASocket, LAddr, i));
  VFamily := LAddr.sin_family;
  VIP := TInAddrToString(LAddr.sin_addr);
  VPort := Ntohs(LAddr.sin_port);
end;

procedure TIdStackWinsock.WSGetSockName(ASocket: TIdStackSocketHandle;
  var VFamily: Integer; var VIP: string; var VPort: Integer);
var
  i: Integer;
  LAddr: TSockAddrIn;
begin
  i := SizeOf(LAddr);
  CheckForSocketError(GetSockName(ASocket, LAddr, i));
  VFamily := LAddr.sin_family;
  VIP := TInAddrToString(LAddr.sin_addr);
  VPort := Ntohs(LAddr.sin_port);
end;

initialization
  if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    GServeFileProc := ServeFile;
  end;
end.
