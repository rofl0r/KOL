{==============================================================================|
| Project : Delphree - Synapse                                   | 004.000.000 |
|==============================================================================|
| Content: Library base                                                        |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.1 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is Synapse Delphi Library.                                 |
|==============================================================================|
| The Initial Developer of the Original Code is Lukas Gebauer (Czech Republic).|
| Portions created by Lukas Gebauer are Copyright (c)1999,2000,2001.           |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History: see HISTORY.HTM from distribution package                           |
|          (Found at URL: http://www.ararat.cz/synapse/)                       |
|==============================================================================}

{$WEAKPACKAGEUNIT ON}

unit blcksock;

interface

uses
  KOL, err,
{$IFDEF LINUX}
  Libc, kernelioctl,
{$ELSE}
	Windows, WinSock,
{$ENDIF}
  synsock, SynaUtil;

const
  cLocalhost = 'localhost';

type
  THookSocketReason = (
		HR_ResolvingBegin,
    HR_ResolvingEnd,
    HR_SocketCreate,
		HR_SocketClose,
		HR_Bind,
		HR_Connect,
		HR_CanRead,
		HR_CanWrite,
		HR_Listen,
		HR_Accept,
		HR_ReadCount,
		HR_WriteCount
		);

	TIPHeader = record
	VerLen: Byte;
	TOS: Byte;
	TotalLen: Word;
	Identifer: Word;
	FragOffsets: Word;
	TTL: Byte;
	Protocol: Byte;
	CheckSum: Word;
	SourceIp: DWORD;
	DestIp: DWORD;
	Options: DWORD;
end;



	THookSocketStatus = procedure(Sender: PObj; Reason: THookSocketReason;
		const Value: string) of object;

type
	PBlockSocket = ^TBlockSocket;
	TBlockSocket = object(TObj)
	private
		FOnStatus: THookSocketStatus;
		FWsaData: TWSADATA;
		FLocalSin: TSockAddrIn;
		FRemoteSin: TSockAddrIn;
		FLastError: Integer;
		FBuffer: string;
		FRaiseExcept: Boolean;
		function GetSizeRecvBuffer: Integer;
		procedure SetSizeRecvBuffer(Size: Integer);
		function GetSizeSendBuffer: Integer;
		procedure SetSizeSendBuffer(Size: Integer);
	protected
		FSocket: TSocket;
		FProtocol: Integer;
		procedure SetSin(var Sin: TSockAddrIn; IP, Port: string);
		function GetSinIP(Sin: TSockAddrIn): string;
		function GetSinPort(Sin: TSockAddrIn): Integer;
		procedure DoStatus(Reason: THookSocketReason; const Value: string);
	  constructor Create;		
	public
		destructor Destroy;virtual;
		procedure CreateSocket;
		procedure CloseSocket;
		procedure Bind(IP, Port: string);
		procedure Connect(IP, Port: string);
		function SendBuffer(Buffer: Pointer; Length: Integer): Integer;
		procedure SendByte(Data: Byte);
		procedure SendString(const Data: string);
		function RecvBuffer(Buffer: Pointer; Length: Integer): Integer;
		function RecvBufferEx(Buffer: Pointer; Length: Integer;
			Timeout: Integer): Integer;
		function RecvByte(Timeout: Integer): Byte;
		function RecvString(Timeout: Integer): string;
		function RecvPacket(Timeout: Integer): string;
		function PeekBuffer(Buffer: Pointer; Length: Integer): Integer;
		function PeekByte(Timeout: Integer): Byte;
		function WaitingData: Integer;
		procedure SetLinger(Enable: Boolean; Linger: Integer);
		procedure GetSins;
		function SockCheck(SockResult: Integer): Integer;
		procedure ExceptCheck;
		function LocalName: string;
		procedure ResolveNameToIP(Name: string; IPList: PStrList);
		function ResolveName(Name: string): string;
		function ResolvePort(Port: string): Word;
		procedure SetRemoteSin(IP, Port: string);
		function GetLocalSinIP: string;
		function GetRemoteSinIP: string;
		function GetLocalSinPort: Integer;
		function GetRemoteSinPort: Integer;
		function CanRead(Timeout: Integer): Boolean;
		function CanWrite(Timeout: Integer): Boolean;
		function SendBufferTo(Buffer: Pointer; Length: Integer): Integer;
		function RecvBufferFrom(Buffer: Pointer; Length: Integer): Integer;
		function GroupCanRead(const SocketList: PList; Timeout: Integer;
			const CanReadList: PList): Boolean;

																																//See 'winsock2.txt' file in distribute package!
		function SetTimeout(Timeout: Integer): Boolean;
		function SetSendTimeout(Timeout: Integer): Boolean;
		function SetRecvTimeout(Timeout: Integer): Boolean;

		property LocalSin: TSockAddrIn read FLocalSin;
		property RemoteSin: TSockAddrIn read FRemoteSin;

		function GetErrorDesc(ErrorCode: Integer): string;
		property Socket: TSocket read FSocket write FSocket;
		property LastError: Integer read FLastError;
		property Protocol: Integer read FProtocol;
		property LineBuffer: string read FBuffer write FBuffer;
		property RaiseExcept: Boolean read FRaiseExcept write FRaiseExcept;
		property SizeRecvBuffer: Integer read GetSizeRecvBuffer write SetSizeRecvBuffer;
		property SizeSendBuffer: Integer read GetSizeSendBuffer write SetSizeSendBuffer;
		property WSAData: TWSADATA read FWsaData;
		property OnStatus: THookSocketStatus read FOnStatus write FOnStatus;
	end;



type
	PSocksBlockSocket = ^TSocksBlockSocket;
	TSocksBlockSocket = object(TBlockSocket)
	protected
		FSocksIP: string;
		FSocksPort: string;
    FSocksTimeout: integer;
    FSocksUsername: string;
		FSocksPassword: string;
		FUsingSocks: Boolean;
		FSocksResolver: Boolean;
		FSocksLastError: integer;
		FSocksResponseIP: string;
    FSocksResponsePort: string;
		FSocksLocalIP: string;
    FSocksLocalPort: string;
		FSocksRemoteIP: string;
		FSocksRemotePort: string;
		function SocksCode(IP, Port: string): string;
		function SocksDecode(Value: string): integer;
		constructor Create;
	public
    destructor Destroy;virtual;
	function SocksOpen: Boolean;
    function SocksRequest(Cmd: Byte; const IP, Port: string): Boolean;
    function SocksResponse: Boolean;

		property SocksIP: string read FSocksIP write FSocksIP;
    property SocksPort: string read FSocksPort write FSocksPort;
    property SocksUsername: string read FSocksUsername write FSocksUsername;
    property SocksPassword: string read FSocksPassword write FSocksPassword;
		property UsingSocks: Boolean read FUsingSocks;
		property SocksResolver: Boolean read FSocksResolver write FSocksResolver;
		property SocksLastError: integer read FSocksLastError;
	end;








type
	PTCPBlockSocket = ^TTCPBlockSocket;
	TTCPBlockSocket = object(TSocksBlockSocket)
	public
		procedure Listen;
		function Accept: TSocket;
		procedure CreateSocket;
		procedure CloseSocket;
		procedure Connect(IP, Port: string);
		function GetLocalSinIP: string;
		function GetRemoteSinIP: string;
		function GetLocalSinPort: Integer;
		function GetRemoteSinPort: Integer;
	end;

type
	PUDPBlockSocket = ^TUDPBlockSocket;
	TUDPBlockSocket = object(TSocksBlockSocket)
	protected
		FSocksControlSock: PTCPBlockSocket;
		function UdpAssociation: Boolean;
	public
		destructor Destroy;virtual;
		procedure CreateSocket; 
		function EnableBroadcast(Value: Boolean): Boolean;
		procedure Connect(IP, Port: string);
		function SendBuffer(Buffer: Pointer; Length: Integer): Integer;
		function RecvBuffer(Buffer: Pointer; Length: Integer): Integer;
		function SendBufferTo(Buffer: Pointer; Length: Integer): Integer;
		function RecvBufferFrom(Buffer: Pointer; Length: Integer): Integer;
	end;



type
																//See 'winsock2.txt' file in distribute package!
	PICMPBlockSocket = ^TICMPBlockSocket;
	TICMPBlockSocket = object(TBlockSocket)
	public
		procedure CreateSocket;
	end;



type
																//See 'winsock2.txt' file in distribute package!
	PRAWBlockSocket = ^TRAWBlockSocket;
	TRAWBlockSocket = object(TBlockSocket)
	public
		procedure CreateSocket;
	end;




function NewBlockSocket: PBlockSocket;
function NewSocksBlockSocket: PSocksBlockSocket;
function NewTCPBlockSocket: PTCPBlockSocket;
function NewUDPBlockSocket: PUDPBlockSocket;
function NewICMPBlockSocket: PICMPBlockSocket;
function NewRAWBlockSocket: PRAWBlockSocket;



implementation

{========================== TBlockSocket =================================}


constructor TBlockSocket.Create;
var
	e: Exception;
begin
	OutputDebugString('TBlockSocket.Create');
	FRaiseExcept := False;
	FSocket := INVALID_SOCKET;
	FProtocol := IPPROTO_IP;
	FBuffer := '';
	if not InitSocketInterface('') then
		begin
			e := Exception.Create(e_Custom, 'Error loading Winsock DLL!');
			e.ErrorCode := 0;
			raise e;
		end;
	SockCheck(synsock.WSAStartup($101, FWsaData));
	ExceptCheck;
end;


function NewBlockSocket: PBlockSocket;
begin
	New(Result,Create);
end;


destructor TBlockSocket.Destroy;
begin
    FBuffer := '';
	CloseSocket;
	synsock.WSACleanup;
	synsock.DestroySocketInterface;
	inherited Destroy;
end;

procedure TBlockSocket.SetSin(var Sin: TSockAddrIn; IP, Port: string);
var
	ProtoEnt: PProtoEnt;
	ServEnt: PServEnt;
	HostEnt: PHostEnt;
begin
	DoStatus(HR_ResolvingBegin, IP + ':' + Port);
	FillChar(Sin, Sizeof(Sin), 0);
	Sin.sin_family := AF_INET;
	ProtoEnt := synsock.GetProtoByNumber(FProtocol);
	ServEnt := nil;
	if ProtoEnt <> nil then
		ServEnt := synsock.GetServByName(PChar(Port), ProtoEnt^.p_name);
	if ServEnt = nil then
		Sin.sin_port := synsock.htons(StrToIntDef(Port, 0))
	else
		Sin.sin_port := ServEnt^.s_port;
	if IP = '255.255.255.255' then
		Sin.sin_addr.s_addr := u_long(INADDR_BROADCAST)
	else
	begin
		Sin.sin_addr.s_addr := synsock.inet_addr(PChar(IP));
		if SIn.sin_addr.s_addr = u_long(INADDR_NONE) then
		begin
			HostEnt := synsock.GetHostByName(PChar(IP));
			if HostEnt <> nil then
				SIn.sin_addr.S_addr := Longint(PLongint(HostEnt^.h_addr_list^)^);
		end;
	end;
	DoStatus(HR_ResolvingEnd, IP + ':' + Port);
end;

function TBlockSocket.GetSinIP(Sin: TSockAddrIn): string;
var
	p: PChar;
begin
	p := synsock.inet_ntoa(Sin.sin_addr);
	if p = nil then
		Result := ''
	else
		Result := p;
end;

function TBlockSocket.GetSinPort(Sin: TSockAddrIn): Integer;
begin
	Result := synsock.ntohs(Sin.sin_port);
end;

procedure TBlockSocket.CreateSocket;
begin
	OutputDebugString('TBlockSocket.CreateSocket');
	FBuffer := '';
	if FSocket = INVALID_SOCKET then
		FLastError := synsock.WSAGetLastError
	else
		FLastError := 0;
	ExceptCheck;
	DoStatus(HR_SocketCreate, '');
end;

procedure TBlockSocket.CloseSocket;
begin
	synsock.CloseSocket(FSocket);
	DoStatus(HR_SocketClose, '');
end;

procedure TBlockSocket.Bind(IP, Port: string);
var
	Sin: TSockAddrIn;
	Len: Integer;
begin
	SetSin(Sin, IP, Port);
	SockCheck(synsock.Bind(FSocket, Sin, SizeOf(Sin)));
	Len := SizeOf(FLocalSin);
	synsock.GetSockName(FSocket, FLocalSin, Len);
	FBuffer := '';
	ExceptCheck;
	DoStatus(HR_Bind, IP + ':' + Port);
end;

procedure TBlockSocket.Connect(IP, Port: string);
var
	Sin: TSockAddrIn;
begin
	OutputDebugString('TBlockSocket.Connect');
	SetSin(Sin, IP, Port);
	SockCheck(synsock.Connect(FSocket, Sin, SizeOf(Sin)));
	GetSins;
	FBuffer := '';
	ExceptCheck;
	DoStatus(HR_Connect, IP + ':' + Port);
end;

procedure TBlockSocket.GetSins;
var
	Len: Integer;
begin
  Len := SizeOf(FLocalSin);
	synsock.GetSockName(FSocket, FLocalSin, Len);
	Len := SizeOf(FRemoteSin);
  synsock.GetPeerName(FSocket, FremoteSin, Len);
end;

function TBlockSocket.SendBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
	OutputDebugString('TBlockSocket.SendBuffer');
	Result := synsock.Send(FSocket, Buffer^, Length, 0);
	SockCheck(Result);
	ExceptCheck;
	DoStatus(HR_WriteCount, Int2Str(Result));
end;

procedure TBlockSocket.SendByte(Data: Byte);
begin
	SendBuffer(@Data, 1);
end;

procedure TBlockSocket.SendString(const Data: string);
begin
	SendBuffer(PChar(Data), Length(Data));
end;

function TBlockSocket.RecvBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
	Result := synsock.Recv(FSocket, Buffer^, Length, 0);
	if Result = 0 then
		FLastError := WSAECONNRESET
	else
		SockCheck(Result);
	ExceptCheck;
	DoStatus(HR_ReadCount, Int2Str(Result));
end;

function TBlockSocket.RecvBufferEx(Buffer: Pointer; Length: Integer;
	Timeout: Integer): Integer;
var
	s, ss, st: string;
	x, l, lss: Integer;
	fb, fs: Integer;
	max: Integer;
begin
	FLastError := 0;
	x := System.Length(FBuffer);
	if Length <= x then
	begin
		fb := Length;
		fs := 0;
	end
	else
	begin
		fb := x;
		fs := Length - x;
	end;
	ss := '';
	if fb > 0 then
	begin
		s := Copy(FBuffer, 1, fb);
		Delete(FBuffer, 1, fb);
	end;
	if fs > 0 then
	begin
		Max := GetSizeRecvBuffer;
		ss := '';
		while System.Length(ss) < fs do
    begin
      if CanRead(Timeout) then
      begin
				l := WaitingData;
        if l > max then
          l := max;
        if (system.Length(ss) + l) > fs then
          l := fs - system.Length(ss);
        SetLength(st, l);
        x := synsock.Recv(FSocket, Pointer(st)^, l, 0);
        if x = 0 then
          FLastError := WSAECONNRESET
        else
					SockCheck(x);
        if FLastError <> 0 then
          Break;
				DoStatus(HR_ReadCount, Int2Str(x));
        lss := system.Length(ss);
				SetLength(ss, lss + x);
				Move(Pointer(st)^, Pointer(@ss[lss + 1])^, x);
																{It is 3x faster then ss:=ss+copy(st,1,x);}
        Sleep(0);
      end
      else
        FLastError := WSAETIMEDOUT;
      if FLastError <> 0 then
        Break;
    end;
    fs := system.Length(ss);
  end;
  Result := fb + fs;
  s := s + ss;
  Move(Pointer(s)^, Buffer^, Result);
	ExceptCheck;
end;

function TBlockSocket.RecvPacket(Timeout: Integer): string;
var
  x: integer;
  s: string;
begin
	Result := '';
  FLastError := 0;
  x := -1;
  if FBuffer <> '' then
  begin
    Result := FBuffer;
    FBuffer := '';
	end
  else
    if CanRead(Timeout) then
    begin
			x := WaitingData;
      if x > 0 then
      begin
				SetLength(s, x);
        x := RecvBuffer(Pointer(s), x);
        Result := Copy(s, 1, x);
			end;
    end
    else
			FLastError := WSAETIMEDOUT;
	ExceptCheck;
	if x = 0 then
    FLastError := WSAECONNRESET;
end;


function TBlockSocket.RecvByte(Timeout: Integer): Byte;
var
	y: Integer;
  Data: Byte;
begin
  Data := 0;
  Result := 0;
  if CanRead(Timeout) then
	begin
    y := synsock.Recv(FSocket, Data, 1, 0);
		if y = 0 then
			FLastError := WSAECONNRESET
    else
      SockCheck(y);
		Result := Data;
		DoStatus(HR_ReadCount, '1');
  end
  else
    FLastError := WSAETIMEDOUT;
  ExceptCheck;
end;

function TBlockSocket.RecvString(Timeout: Integer): string;
const
  MaxBuf = 1024;
var
  x: Integer;
  s: string;
  c: Char;
	r: Integer;
begin
  s := '';
	FLastError := 0;
  c := #0;
  repeat
		if FBuffer = '' then
		begin
      x := WaitingData;
			if x = 0 then
        x := 1;
			if x > MaxBuf then
        x := MaxBuf;
      if x = 1 then
      begin
        c := Char(RecvByte(Timeout));
        if FLastError <> 0 then
          Break;
        FBuffer := c;
      end
      else
			begin
        SetLength(FBuffer, x);
        r := synsock.Recv(FSocket, Pointer(FBuffer)^, x, 0);
				SockCheck(r);
        if r = 0 then
					FLastError := WSAECONNRESET;
				if FLastError <> 0 then
					Break;
        DoStatus(HR_ReadCount, Int2Str(r));
        if r < x then
          SetLength(FBuffer, r);
      end;
    end;
    x := Pos(#10, FBuffer);
    if x < 1 then x := Length(FBuffer);
    s := s + Copy(FBuffer, 1, x - 1);
    c := FBuffer[x];
    Delete(FBuffer, 1, x);
    s := s + c;
  until c = #10;

	if FLastError = 0 then
  begin
{$IFDEF LINUX}
		s := AdjustLineBreaks(s, tlbsCRLF);
{$ELSE}
    NormalizeUnixText(s);// := AdjustLineBreaks(s);
{$ENDIF}
		x := Pos(#13 + #10, s);
    if x > 0 then
      s := Copy(s, 1, x - 1);
    Result := s;
  end
  else
    Result := '';
	ExceptCheck;
end;

function TBlockSocket.PeekBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
  Result := synsock.Recv(FSocket, Buffer^, Length, MSG_PEEK);
  SockCheck(Result);
	ExceptCheck;
end;

function TBlockSocket.PeekByte(Timeout: Integer): Byte;
var
  y: Integer;
	Data: Byte;
begin
	Data := 0;
  Result := 0;
  if CanRead(Timeout) then
  begin
    y := synsock.Recv(FSocket, Data, 1, MSG_PEEK);
    if y = 0 then
      FLastError := WSAECONNRESET;
    SockCheck(y);
    Result := Data;
  end
	else
    FLastError := WSAETIMEDOUT;
  ExceptCheck;
end;

function TBlockSocket.SockCheck(SockResult: Integer): Integer;
begin
  if SockResult = SOCKET_ERROR then
    Result := synsock.WSAGetLastError
	else
		Result := 0;
  FLastError := Result;
end;

procedure TBlockSocket.ExceptCheck;
var
  e: Exception;
  s, er: string;
begin
  if FRaiseExcept and (LastError <> 0) then
	begin
    s := GetErrorDesc(LastError);
    er := Format('TCP/IP Socket error %d: %s', [LastError, s]);
    e := Exception.Create(e_Custom, er);
		e.ErrorCode := LastError;
    raise e;
  end;
end;

function TBlockSocket.WaitingData: Integer;
var
	x: Integer;
begin
  synsock.IoctlSocket(FSocket, FIONREAD, u_long(x));
  Result := x;
end;

procedure TBlockSocket.SetLinger(Enable: Boolean; Linger: Integer);
var
  li: TLinger;
begin
  li.l_onoff := Ord(Enable);
  li.l_linger := Linger div 1000;
  SockCheck(synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_LINGER, @li, SizeOf(li)));
  ExceptCheck;
end;

function TBlockSocket.LocalName: string;
var
  buf: array[0..255] of Char;
	BufPtr: PChar;
	RemoteHost: PHostEnt;
begin
  BufPtr := buf;
	Result := '';
  synsock.GetHostName(BufPtr, SizeOf(buf));
  if BufPtr[0] <> #0 then
  begin
                                                                // try get Fully Qualified Domain Name
    RemoteHost := synsock.GetHostByName(BufPtr);
    if RemoteHost <> nil then
      Result := PChar(RemoteHost^.h_name);
  end;
  if Result = '' then
    Result := '127.0.0.1';
end;

procedure TBlockSocket.ResolveNameToIP(Name: string; IPList: PStrList);
type
	TaPInAddr = array[0..250] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
	RemoteHost: PHostEnt;
	IP: u_long;
  PAdrPtr: PaPInAddr;
  i: Integer;
  s: string;
  InAddr: TInAddr;
begin
  IPList.Clear;
	IP := synsock.inet_addr(PChar(Name));
  if IP = u_long(INADDR_NONE) then
  begin
    RemoteHost := synsock.GetHostByName(PChar(Name));
    if RemoteHost <> nil then
    begin
      PAdrPtr := PAPInAddr(RemoteHost^.h_addr_list);
			i := 0;
      while PAdrPtr^[i] <> nil do
      begin
				InAddr := PAdrPtr^[i]^;
        with InAddr.S_un_b do
          s := Format('%d.%d.%d.%d',
						[Ord(s_b1), Ord(s_b2), Ord(s_b3), Ord(s_b4)]);
				IPList.Add(s);
				Inc(i);
      end;
    end;
    if IPList.Count = 0 then
      IPList.Add('0.0.0.0');
  end
  else
    IPList.Add(Name);
end;

function TBlockSocket.ResolveName(Name: string): string;
var
  l: PStrList;
begin
  l := NewStrList;
	try
		ResolveNameToIP(Name, l);
    Result := l.Items[0];
  finally
		l.Free;
	end;
end;

function TBlockSocket.ResolvePort(Port: string): Word;
var
  ProtoEnt: PProtoEnt;
  ServEnt: PServEnt;
begin
  ProtoEnt := synsock.GetProtoByNumber(FProtocol);
  ServEnt := nil;
	if ProtoEnt <> nil then
		ServEnt := synsock.GetServByName(PChar(Port), ProtoEnt^.p_name);
  if ServEnt = nil then
    Result := synsock.htons(StrToIntDef(Port, 0))
	else
    Result := ServEnt^.s_port;
end;

procedure TBlockSocket.SetRemoteSin(IP, Port: string);
begin
	SetSin(FRemoteSin, IP, Port);
end;

function TBlockSocket.GetLocalSinIP: string;
begin
	Result := GetSinIP(FLocalSin);
end;

function TBlockSocket.GetRemoteSinIP: string;
begin
  Result := GetSinIP(FRemoteSin);
end;

function TBlockSocket.GetLocalSinPort: Integer;
begin
	Result := GetSinPort(FLocalSin);
end;

function TBlockSocket.GetRemoteSinPort: Integer;
begin
	Result := GetSinPort(FRemoteSin);
end;

function TBlockSocket.CanRead(Timeout: Integer): Boolean;
var
  FDSet: TFDSet;
  TimeVal: PTimeVal;
	TimeV: TTimeVal;
  x: Integer;
begin
  TimeV.tv_usec := (Timeout mod 1000) * 1000;
  TimeV.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
	if Timeout = -1 then
    TimeVal := nil;
	FD_ZERO(FDSet);
	FD_SET(FSocket, FDSet);
  x := synsock.Select(FSocket + 1, @FDSet, nil, nil, TimeVal);
  SockCheck(x);
	if FLastError <> 0 then
    x := 0;
  Result := x > 0;
	ExceptCheck;
	if Result then
    DoStatus(HR_CanRead, '');
end;

function TBlockSocket.CanWrite(Timeout: Integer): Boolean;
var
  FDSet: TFDSet;
	TimeVal: PTimeVal;
  TimeV: TTimeVal;
  x: Integer;
begin
	TimeV.tv_usec := (Timeout mod 1000) * 1000;
  TimeV.tv_sec := Timeout div 1000;
  TimeVal := @TimeV;
	if Timeout = -1 then
    TimeVal := nil;
  FD_ZERO(FDSet);
	FD_SET(FSocket, FDSet);
  x := synsock.Select(FSocket + 1, nil, @FDSet, nil, TimeVal);
  SockCheck(x);
	if FLastError <> 0 then
		x := 0;
	Result := x > 0;
  ExceptCheck;
  if Result then
    DoStatus(HR_CanWrite, '');
end;

function TBlockSocket.SendBufferTo(Buffer: Pointer; Length: Integer): Integer;
var
  Len: Integer;
begin
	OutputDebugString('TBlockSocket.SendBufferTo');
	Len := SizeOf(FRemoteSin);
	Result := synsock.SendTo(FSocket, Buffer^, Length, 0, FRemoteSin, Len);
	SockCheck(Result);
	ExceptCheck;
end;

function TBlockSocket.RecvBufferFrom(Buffer: Pointer; Length: Integer): Integer;
var
	Len: Integer;
begin
	Len := SizeOf(FRemoteSin);
	Result := synsock.RecvFrom(FSocket, Buffer^, Length, 0, FRemoteSin, Len);
	SockCheck(Result);
	ExceptCheck;
end;

function TBlockSocket.GetSizeRecvBuffer: Integer;
var
	l: Integer;
begin
	l := SizeOf(Result);
	SockCheck(synsock.GetSockOpt(FSocket, SOL_SOCKET, SO_RCVBUF, @Result, l));
	if FLastError <> 0 then
		Result := 1024;
	ExceptCheck;
end;

procedure TBlockSocket.SetSizeRecvBuffer(Size: Integer);
begin
	SockCheck(synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_RCVBUF, @Size, SizeOf(Size)));
	ExceptCheck;
end;

function TBlockSocket.GetSizeSendBuffer: Integer;
var
	l: Integer;
begin
	l := SizeOf(Result);
	SockCheck(synsock.GetSockOpt(FSocket, SOL_SOCKET, SO_SNDBUF, @Result, l));
	if FLastError <> 0 then
		Result := 1024;
	ExceptCheck;
end;

procedure TBlockSocket.SetSizeSendBuffer(Size: Integer);
begin
	SockCheck(synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_SNDBUF, @Size, SizeOf(Size)));
	ExceptCheck;
end;

//See 'winsock2.txt' file in distribute package!

function TBlockSocket.SetTimeout(Timeout: Integer): Boolean;
begin
	Result := SetSendTimeout(Timeout) and SetRecvTimeout(Timeout);
end;

//See 'winsock2.txt' file in distribute package!

function TBlockSocket.SetSendTimeout(Timeout: Integer): Boolean;
begin
	Result := synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_SNDTIMEO,
		@Timeout, SizeOf(Timeout)) <> SOCKET_ERROR;
end;

//See 'winsock2.txt' file in distribute package!

function TBlockSocket.SetRecvTimeout(Timeout: Integer): Boolean;
begin
	Result := synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_RCVTIMEO,
		@Timeout, SizeOf(Timeout)) <> SOCKET_ERROR;
end;

function TBlockSocket.GroupCanRead(const SocketList: PList; Timeout: Integer;
	const CanReadList: PList): boolean;
var
	FDSet: TFDSet;
	TimeVal: PTimeVal;
	TimeV: TTimeVal;
	x, n: Integer;
	Max: Integer;
begin
	TimeV.tv_usec := (Timeout mod 1000) * 1000;
	TimeV.tv_sec := Timeout div 1000;
	TimeVal := @TimeV;
	if Timeout = -1 then
		TimeVal := nil;
	FD_ZERO(FDSet);
	Max := 0;
	for n := 0 to SocketList.Count - 1 do
		if TBlockSocket.AncestorOfObject(SocketList.Items[n]) then
		begin
			if PBlockSocket(SocketList.Items[n]).Socket > Max then
				Max := PBlockSocket(SocketList.Items[n]).Socket;
			FD_SET(PBlockSocket(SocketList.Items[n]).Socket, FDSet);
		end;
	x := synsock.Select(Max + 1, @FDSet, nil, nil, TimeVal);
	SockCheck(x);
	ExceptCheck;
	if FLastError <> 0 then
		x := 0;
	Result := x > 0;
	CanReadList.Clear;
	if Result then
		for n := 0 to SocketList.Count - 1 do
			if TBlockSocket.AncestorOfObject(SocketList.Items[n]) then
				if FD_ISSET(PBlockSocket(SocketList.Items[n]).Socket, FDSet) then
					CanReadList.Add(PBlockSocket(SocketList.Items[n]));
end;

procedure TBlockSocket.DoStatus(Reason: THookSocketReason; const Value: string);
begin
	if assigned(OnStatus) then
		OnStatus(PObj(@Self), Reason, Value);
end;

function TBlockSocket.GetErrorDesc(ErrorCode: Integer): string;
begin
	case ErrorCode of
		0:
			Result := 'OK';
		WSAEINTR: {10004}
			Result := 'Interrupted system call';
		WSAEBADF: {10009}
			Result := 'Bad file number';
		WSAEACCES: {10013}
			Result := 'Permission denied';
		WSAEFAULT: {10014}
			Result := 'Bad address';
		WSAEINVAL: {10022}
			Result := 'Invalid argument';
		WSAEMFILE: {10024}
			Result := 'Too many open files';
		WSAEWOULDBLOCK: {10035}
			Result := 'Operation would block';
		WSAEINPROGRESS: {10036}
			Result := 'Operation now in progress';
    WSAEALREADY: {10037}
      Result := 'Operation already in progress';
    WSAENOTSOCK: {10038}
			Result := 'Socket operation on nonsocket';
    WSAEDESTADDRREQ: {10039}
      Result := 'Destination address required';
    WSAEMSGSIZE: {10040}
      Result := 'Message too long';
    WSAEPROTOTYPE: {10041}
      Result := 'Protocol wrong type for Socket';
		WSAENOPROTOOPT: {10042}
      Result := 'Protocol not available';
		WSAEPROTONOSUPPORT: {10043}
			Result := 'Protocol not supported';
    WSAESOCKTNOSUPPORT: {10044}
      Result := 'Socket not supported';
		WSAEOPNOTSUPP: {10045}
      Result := 'Operation not supported on Socket';
		WSAEPFNOSUPPORT: {10046}
			Result := 'Protocol family not supported';
		WSAEAFNOSUPPORT: {10047}
      Result := 'Address family not supported';
    WSAEADDRINUSE: {10048}
      Result := 'Address already in use';
    WSAEADDRNOTAVAIL: {10049}
      Result := 'Can''t assign requested address';
    WSAENETDOWN: {10050}
      Result := 'Network is down';
    WSAENETUNREACH: {10051}
      Result := 'Network is unreachable';
		WSAENETRESET: {10052}
			Result := 'Network dropped connection on reset';
    WSAECONNABORTED: {10053}
			Result := 'Software caused connection abort';
		WSAECONNRESET: {10054}
      Result := 'Connection reset by peer';
    WSAENOBUFS: {10055}
			Result := 'No Buffer space available';
    WSAEISCONN: {10056}
			Result := 'Socket is already connected';
		WSAENOTCONN: {10057}
			Result := 'Socket is not connected';
    WSAESHUTDOWN: {10058}
      Result := 'Can''t send after Socket shutdown';
    WSAETOOMANYREFS: {10059}
      Result := 'Too many references:can''t splice';
    WSAETIMEDOUT: {10060}
      Result := 'Connection timed out';
		WSAECONNREFUSED: {10061}
      Result := 'Connection refused';
    WSAELOOP: {10062}
      Result := 'Too many levels of symbolic links';
		WSAENAMETOOLONG: {10063}
      Result := 'File name is too long';
    WSAEHOSTDOWN: {10064}
			Result := 'Host is down';
    WSAEHOSTUNREACH: {10065}
      Result := 'No route to host';
		WSAENOTEMPTY: {10066}
      Result := 'Directory is not empty';
		WSAEPROCLIM: {10067}
			Result := 'Too many processes';
		WSAEUSERS: {10068}
			Result := 'Too many users';
    WSAEDQUOT: {10069}
      Result := 'Disk quota exceeded';
		WSAESTALE: {10070}
      Result := 'Stale NFS file handle';
    WSAEREMOTE: {10071}
      Result := 'Too many levels of remote in path';
    WSASYSNOTREADY: {10091}
      Result := 'Network subsystem is unusable';
    WSAVERNOTSUPPORTED: {10092}
			Result := 'Winsock DLL cannot support this application';
    WSANOTINITIALISED: {10093}
      Result := 'Winsock not initialized';
		WSAEDISCON: {10101}
      Result := 'WSAEDISCON-10101';
		WSAHOST_NOT_FOUND: {11001}
			Result := 'Host not found';
    WSATRY_AGAIN: {11002}
			Result := 'Non authoritative - host not found';
		WSANO_RECOVERY: {11003}
			Result := 'Non recoverable error';
		WSANO_DATA: {11004}
			Result := 'Valid name, no data record of requested type'
	else
		Result := 'Not a Winsock error (' + Int2Str(ErrorCode) + ')';
	end;
end;


{========================== TSocksBlockSocket =================================}

constructor TSocksBlockSocket.Create;
begin
	OutputDebugString('TSocksBlockSocket.Create');
	FSocksIP := '';
	FSocksPort := '1080';
	FSocksTimeout := 300000;
	FSocksUsername := '';
	FSocksPassword := '';
	FUsingSocks := False;
	FSocksResolver := True;
	FSocksLastError := 0;
	FSocksResponseIP := '';
	FSocksResponsePort := '';
	FSocksLocalIP := '';
	FSocksLocalPort := '';
	FSocksRemoteIP := '';
	FSocksRemotePort := '';
	inherited Create;
end;

destructor TSocksBlockSocket.Destroy;
begin
	FSocksIP := '';
	FSocksPort := '';
	FSocksUsername := '';
	FSocksPassword := '';
	FSocksResponseIP := '';
	FSocksResponsePort := '';
	FSocksLocalIP := '';
	FSocksLocalPort := '';
	FSocksRemoteIP := '';
	FSocksRemotePort := '';
    inherited;
end;

function NewSocksBlockSocket: PSocksBlockSocket;
begin
	New(Result,Create);
end;

function TSocksBlockSocket.SocksOpen: boolean;
var
	Buf: string;
	n: integer;
begin
	Result := False;
	FUsingSocks := False;
	if FSocksUsername = '' then
		Buf := #5 + #1 + #0
	else
		Buf := #5 + #2 + #2 + #0;
	SendString(Buf);
	Buf := RecvPacket(FSocksTimeout);
	FBuffer := Copy(Buf, 3, Length(buf) - 2);
	if Length(Buf) < 2 then
		Exit;
  if Buf[1] <> #5 then
		Exit;
  n := Ord(Buf[2]);
  case n of
		0: //not need authorisation
      ;
    2:
			begin
        Buf := #1 + char(Length(FSocksUsername)) + FSocksUsername
					+ char(Length(FSocksPassword)) + FSocksPassword;
        SendString(Buf);
        Buf := RecvPacket(FSocksTimeout);
				FBuffer := Copy(Buf, 3, Length(buf) - 2);
				if Length(Buf) < 2 then
          Exit;
        if Buf[2] <> #0 then
					Exit;
      end;
  else
		Exit;
	end;
  FUsingSocks := True;
  Result := True;
end;

function TSocksBlockSocket.SocksRequest(Cmd: Byte;
  const IP, Port: string): Boolean;
var
	Buf: string;
begin
//  Result := False;
  Buf := #5 + char(Cmd) + #0 + SocksCode(IP, Port);
  SendString(Buf);
	Result := FLastError = 0;
end;

function TSocksBlockSocket.SocksResponse: Boolean;
var
  Buf: string;
	x: integer;
begin
	Result := False;
  FSocksResponseIP := '';
  FSocksResponsePort := '';
  Buf := RecvPacket(FSocksTimeout);
  if FLastError <> 0 then
		Exit;
  if Length(Buf) < 5 then
    Exit;
	if Buf[1] <> #5 then
    Exit;
  FSocksLastError := Ord(Buf[2]);
  if FSocksLastError <> 0 then
    Exit;
	x := SocksDecode(Buf);
	FBuffer := Copy(Buf, x, Length(buf) - x + 1);
  Result := True;
end;

function TSocksBlockSocket.SocksCode(IP, Port: string): string;
begin
  if IsIP(IP) then
		Result := #1 + IPToID(IP)
  else
    if FSocksResolver then
			Result := #3 + char(Length(IP)) + IP
    else
			Result := #1 + IPToID(ResolveName(IP));
  Result := Result + CodeInt(synsock.htons(ResolvePort(Port)));
end;

function TSocksBlockSocket.SocksDecode(Value: string): integer;
var
	Atyp: Byte;
  y, n: integer;
	w: Word;
begin
  FSocksResponsePort := '0';
  Atyp := Ord(Value[4]);
	Result := 5;
  case Atyp of
    1:
      begin
				if Length(Value) < 10 then
					Exit;
        FSocksResponseIP := Format('%d.%d.%d.%d',
					[Ord(Value[5]), Ord(Value[6]), Ord(Value[7]), Ord(Value[8])]);
        Result := 9;
			end;
    3:
      begin
				y := Ord(Value[5]);
        if Length(Value) < (5 + y + 2) then
          Exit;
        for n := 6 to 6 + y do
          FSocksResponseIP := FSocksResponseIP + Value[n];
				Result := 5 + y + 1;
			end;
  else
		Exit;
	end;
	w := DecodeInt(Value, Result);
	FSocksResponsePort := Int2Str(w);
	Result := Result + 2;
end;



{======================= TUDPBlockSocket =====================================}

function NewUDPBlockSocket : PUDPBlockSocket;
begin
	New(Result,Create);
end;

destructor TUDPBlockSocket.Destroy;
begin
	if Assigned(FSocksControlSock) then
		FSocksControlSock.Free;
	inherited Destroy;
end;

procedure TUDPBlockSocket.CreateSocket;
begin
	OutputDebugString('TUDPBlockSocket.CreateSocket');
	FSocket := synsock.Socket(PF_INET, Integer(SOCK_DGRAM), IPPROTO_UDP);
	FProtocol := IPPROTO_UDP;
	inherited CreateSocket;
end;

function TUDPBlockSocket.EnableBroadcast(Value: Boolean): Boolean;
var
	Opt: Integer;
	Res: Integer;
begin
	opt := Ord(Value);
	Res := synsock.SetSockOpt(FSocket, SOL_SOCKET, SO_BROADCAST, @Opt, SizeOf(opt));
	SockCheck(Res);
	Result := res = 0;
	ExceptCheck;
end;

procedure TUDPBlockSocket.Connect(IP, Port: string);
begin
	OutputDebugString('TUDPBlockSocket.Connect');
	SetRemoteSin(IP, Port);
	FBuffer := '';
	DoStatus(HR_Connect, IP + ':' + Port);
end;

function TUDPBlockSocket.RecvBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
	Result := RecvBufferFrom(Buffer, Length);
end;

function TUDPBlockSocket.SendBuffer(Buffer: Pointer; Length: Integer): Integer;
begin
	OutputDebugString('TUDPBlockSocket.SendBuffer');
	Result := SendBufferTo(Buffer, Length);
end;

function TUDPBlockSocket.UdpAssociation: Boolean;
var
	b: Boolean;
begin
	Result := True;
	FUsingSocks := False;
	if FSocksIP <> '' then
	begin
		Result := False;
		if not Assigned(FSocksControlSock) then
			FSocksControlSock := NewTCPBlockSocket;
		FSocksControlSock.CloseSocket;
		FSocksControlSock.CreateSocket;
		FSocksControlSock.Connect(FSocksIP, FSocksPort);
		if FSocksControlSock.LastError <> 0 then
			Exit;
								// if not assigned local port, assign it!
		if GetLocalSinPort = 0 then
			Bind(GetLocalSinIP, '0');
		GetSins;
								//open control TCP connection to SOCKS
		b := FSocksControlSock.SocksOpen;
		if b then
			b := FSocksControlSock.SocksRequest(3, GetLocalSinIP,
				Int2Str(GetLocalSinPort));
		if b then
			b := FSocksControlSock.SocksResponse;
		if not b and (FLastError = 0) then
			FLastError := WSANO_RECOVERY;
		FUsingSocks := FSocksControlSock.UsingSocks;
		FSocksRemoteIP := FSocksControlSock.FSocksResponseIP;
		FSocksRemotePort := FSocksControlSock.FSocksResponsePort;
		Result := True;
	end;
end;

function TUDPBlockSocket.SendBufferTo(Buffer: Pointer; Length: Integer): Integer;
var
	SIp: string;
	SPort: integer;
	Buf: string;
begin
	OutputDebugString('TUDPBlockSocket.SendBufferTo');
	UdpAssociation;
	if FUsingSocks then
	begin
		Sip := GetRemoteSinIp;
		SPort := GetRemoteSinPort;
		SetRemoteSin(FSocksRemoteIP, FSocksRemotePort);
		SetLength(Buf, Length);
		Move(Buffer^, PChar(Buf)^, Length);
		Buf := #0 + #0 + #0 + SocksCode(Sip, Int2Str(SPort)) + Buf;
		Result := inherited SendBufferTo(PChar(Buf), System.Length(buf));
		SetRemoteSin(Sip, Int2Str(SPort));
	end
	else
	begin
		Result := inherited SendBufferTo(Buffer, Length);
		GetSins;
	end;
end;

function TUDPBlockSocket.RecvBufferFrom(Buffer: Pointer; Length: Integer): Integer;
var
	Buf: string;
	x: integer;
begin
	Result := inherited RecvBufferFrom(Buffer, Length);
	if FUsingSocks then
	begin
		SetLength(Buf, Result);
		Move(Buffer^, PChar(Buf)^, Result);
		x := SocksDecode(Buf);
		Result := Result - x + 1;
		Buf := Copy(Buf, x, Result);
		Move(PChar(Buf)^, Buffer^, Result);
		SetRemoteSin(FSocksResponseIP, FSocksResponsePort);
	end;
end;


{====================== TTCPBlockSocket =======================================}

function NewTCPBlockSocket : PTCPBlockSocket;
begin
	New(Result,Create);
end;


procedure TTCPBlockSocket.CreateSocket;
begin
	OutputDebugString('TTCPBlockSocket.CreateSocket');
	FSocket := synsock.Socket(PF_INET, Integer(SOCK_STREAM), IPPROTO_TCP);
	FProtocol := IPPROTO_TCP;
	inherited CreateSocket;
end;

procedure TTCPBlockSocket.CloseSocket;
begin
	OutputDebugString('TTCPBlockSocket.CloseSocket');
	synsock.Shutdown(FSocket, 1);
	inherited CloseSocket;
end;

procedure TTCPBlockSocket.Listen;
var
	b: Boolean;
	Sip, SPort: string;
begin
	if FSocksIP = '' then
	begin
		SockCheck(synsock.Listen(FSocket, SOMAXCONN));
		GetSins;
	end
	else
	begin
		Sip := GetLocalSinIP;
		if Sip = '0.0.0.0' then
			Sip := LocalName;
		SPort := Int2Str(GetLocalSinPort);
		Connect(FSocksIP, FSocksPort);
		b := SocksOpen;
		if b then
			b := SocksRequest(2, Sip, SPort);
		if b then
			b := SocksResponse;
		if not b and (FLastError = 0) then
			FLastError := WSANO_RECOVERY;
		FSocksLocalIP := FSocksResponseIP;
		if FSocksLocalIP = '0.0.0.0' then
			FSocksLocalIP := FSocksIP;
		FSocksLocalPort := FSocksResponsePort;
		FSocksRemoteIP := '';
		FSocksRemotePort := '';
	end;
	ExceptCheck;
	DoStatus(HR_Listen, '');
end;

function TTCPBlockSocket.Accept: TSocket;
var
	Len: Integer;
begin
	if FUsingSocks then
	begin
		if not SocksResponse and (FLastError = 0) then
			FLastError := WSANO_RECOVERY;
		FSocksRemoteIP := FSocksResponseIP;
		FSocksRemotePort := FSocksResponsePort;
		Result := FSocket;
	end
	else
	begin
		Len := SizeOf(FRemoteSin);
		Result := synsock.Accept(FSocket, @FRemoteSin, @Len);
		SockCheck(Result);
	end;
	ExceptCheck;
	DoStatus(HR_Accept, '');
end;

procedure TTCPBlockSocket.Connect(IP, Port: string);
var
	b: Boolean;
begin
	OutputDebugString('TTCPBlockSocket.Connect');
	if FSocksIP = '' then
		inherited Connect(IP, Port)
	else
	begin
		inherited Connect(FSocksIP, FSocksPort);
		b := SocksOpen;
		if b then
			b := SocksRequest(1, IP, Port);
    if b then
			b := SocksResponse;
    if not b and (FLastError = 0) then
      FLastError := WSANO_RECOVERY;
		FSocksLocalIP := FSocksResponseIP;
		FSocksLocalPort := FSocksResponsePort;
		FSocksRemoteIP := IP;
    FSocksRemotePort := Port;
    ExceptCheck;
    DoStatus(HR_Connect, IP + ':' + Port);
  end;
end;

function TTCPBlockSocket.GetLocalSinIP: string;
begin
  if FUsingSocks then
		Result := FSocksLocalIP
  else
    Result := inherited GetLocalSinIP;
end;

function TTCPBlockSocket.GetRemoteSinIP: string;
begin
  if FUsingSocks then
		Result := FSocksRemoteIP
	else
    Result := inherited GetRemoteSinIP;
end;

function TTCPBlockSocket.GetLocalSinPort: Integer;
begin
  if FUsingSocks then
		Result := StrToIntDef(FSocksLocalPort, 0)
	else
    Result := inherited GetLocalSinPort;
end;

function TTCPBlockSocket.GetRemoteSinPort: Integer;
begin
	if FUsingSocks then
		Result := StrToIntDef(FSocksRemotePort, 0)
	else
		Result := inherited GetRemoteSinPort;
end;

{======================= TICMPBlockSocket =====================================}

//See 'winsock2.txt' file in distribute package!

function NewICMPBlockSocket : PICMPBlockSocket;
begin
	New(Result,Create);
end;


procedure TICMPBlockSocket.CreateSocket;
begin
	OutputDebugString('TICMPBlockSocket.CreateSocket');
	FSocket := synsock.Socket(PF_INET, Integer(SOCK_RAW), IPPROTO_ICMP);
	FProtocol := IPPROTO_ICMP;
	inherited;
end;

{======================= TRAWBlockSocket ======================================}

//See 'winsock2.txt' file in distribute package!


function NewRAWBlockSocket : PRAWBlockSocket;
begin
	New(Result,Create);
end;

procedure TRAWBlockSocket.CreateSocket;
begin
	OutputDebugString('TRAWBlockSocket.CreateSocket');
	FSocket := synsock.Socket(PF_INET, Integer(SOCK_RAW), IPPROTO_RAW);
	FProtocol := IPPROTO_RAW;
	inherited CreateSocket;
end;

end.
