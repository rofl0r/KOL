{==============================================================================|
| Project : Delphree - Synapse                                   | 002.003.000 |
|==============================================================================|
| Content: HTTP client                                                         |
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
| Portions created by Lukas Gebauer are Copyright (c) 1999,2000,2001.          |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History: see HISTORY.HTM from distribution package                           |
|          (Found at URL: http://www.ararat.cz/synapse/)                       |
|==============================================================================}

{$WEAKPACKAGEUNIT ON}

unit HTTPSend;

interface

uses
	KOL,
	blcksock, SynaUtil, SynaCode;

const
  cHttpProtocol = '80';

type
//    THttpProgress = procedure(Sender : PObj; Progress : Integer) of object;
	TTransferEncoding = (TE_UNKNOWN, TE_IDENTITY, TE_CHUNKED);

	PHTTPSend = ^THTTPSend;
	THTTPSend = object(TObj)
	private
		FSock: PTCPBlockSocket;
		FTransferEncoding: TTransferEncoding;
		FAliveHost: string;
		FAlivePort: string;
		FHeaders: PStrList;
		FDocument: PStream;//TMemoryStream;
		FMimeType: string;
		FProtocol: string;
		FKeepAlive: Boolean;
		FTimeout: Integer;
		FHTTPHost: string;
		FHTTPPort: string;
		FProxyHost: string;
		FProxyPort: string;
		FProxyUser: string;
		FProxyPass: string;
		FResultCode: Integer;
		FResultString: string;
//		procedure SetOnProgress(const Value : THttpProgress);
//        function GetOnProgress : THttpProgress;
		function ReadUnknown: Boolean;
		function ReadIdentity(Size: Integer): Boolean;
		function ReadChunked: Boolean;
	public
		destructor Destroy; virtual;
		procedure Clear;
		procedure DecodeStatus(const Value: string);
		function HTTPMethod(const Method, URL: string): Boolean;
		property Headers: PStrList read FHeaders Write FHeaders;
		property Document: PStream {TMemoryStream} read FDocument Write FDocument;
		property MimeType: string read FMimeType Write FMimeType;
		property Protocol: string read FProtocol Write FProtocol;
		property KeepAlive: Boolean read FKeepAlive Write FKeepAlive;
		property Timeout: Integer read FTimeout Write FTimeout;
		property HTTPHost: string read FHTTPHost;
		property HTTPPort: string read FHTTPPort;
		property ProxyHost: string read FProxyHost Write FProxyHost;
		property ProxyPort: string read FProxyPort Write FProxyPort;
		property ProxyUser: string read FProxyUser Write FProxyUser;
		property ProxyPass: string read FProxyPass Write FProxyPass;
		property ResultCode: Integer read FResultCode;
		property ResultString: string read FResultString;
		property Sock: PTCPBlockSocket read FSock;
//        property OnProgress : THttpProgress read GetOnProgress Write SetOnProgress;
	end;

function HttpGetText(const URL: string; const Response: PStrList): Boolean;
function HttpGetBinary(const URL: string; const Response: PStream): Boolean;
function HttpPostBinary(const URL: string; const Data: PStream): Boolean;
function HttpPostURL(const URL, URLData: string; const Data: PStream): Boolean;
function HttpPostFile(const URL, FieldName, FileName: string;
	const Data: PStream; const ResultData: PStrList): Boolean;



function NewHTTPSend : PHTTPSend;

implementation

const
	CRLF = #13#10;


destructor THTTPSend.Destroy;
begin
	FSock.Free;
	FDocument.Free;
	FHeaders.Free;
	inherited Destroy;
end;

function NewHTTPSend : PHTTPSend;
begin
	New(Result,Create);
    with Result^ do begin
	FHeaders := NewStrList;
	FDocument := NewMemoryStream;
	FSock := NewTCPBlockSocket;
	FSock.SizeRecvBuffer := 65536;
	FSock.SizeSendBuffer := 65536;
	FTimeout := 300000;
	FHTTPHost := cLocalhost;
	FHTTPPort := cHttpProtocol;
	FProxyHost := '';
	FProxyPort := '8080';
	FProxyUser := '';
	FProxyPass := '';
	FAliveHost := '';
	FAlivePort := '';
	FProtocol := '1.1';
	FKeepAlive := True;
	Clear;
    end;
end;


{
procedure THTTPSend.SetOnProgress(const Value : THttpProgress);
begin
end;

function THTTPSend.GetOnProgress : THttpProgress;
begin
 Result := @Self.FSock.
end;
}


procedure THTTPSend.Clear;
begin
	FDocument.Size := 0;
	FHeaders.Clear;
	FMimeType := 'text/html';
end;

procedure THTTPSend.DecodeStatus(const Value: string);
var
	s, su: string;
begin
	s := SeparateRight(Value, ' ');
	su := SeparateLeft(s, ' ');
	FResultCode := StrToIntDef(su, 0);
	FResultString := SeparateRight(s, ' ');
	if FResultString = s then
		FResultString := '';
end;

function THTTPSend.HTTPMethod(const Method, URL: string): Boolean;
var
	Sending, Receiving: Boolean;
	status100: Boolean;
	status100error: string;
	ToClose: Boolean;
	Size: Integer;
	Prot, User, Pass, Host, Port, Path, Para, URI: string;
	n: Integer;
	s, su: string;
begin
	{initial values}
	Result := False;
	FResultCode := 500;
	FResultString := '';

	URI := ParseURL(URL, Prot, User, Pass, Host, Port, Path, Para);
	Sending := Document.Size > 0;
	{Headers for Sending data}
	status100 := Sending and (FProtocol = '1.1');
	if status100 then
		FHeaders.Insert(0, 'Expect: 100-continue');
	if Sending then
	begin
		FHeaders.Insert(0, 'Content-Length: ' + Int2Str(FDocument.Size));
		if FMimeType <> '' then
			FHeaders.Insert(0, 'Content-Type: ' + FMimeType);
	end;
	{ setting KeepAlives }
	if not FKeepAlive then
		FHeaders.Insert(0, 'Connection: close');
	{ set target servers/proxy, authorisations, etc... }
	if User <> '' then
		FHeaders.Insert(0, 'Authorization: Basic ' + EncodeBase64(user + ':' + pass));
	if (FProxyHost <> '') and (FProxyUser <> '') then
		FHeaders.Insert(0, 'Proxy-Authorization: Basic ' +
			EncodeBase64(FProxyUser + ':' + FProxyPass));
	if Port<>'80' then
		 FHeaders.Insert(0, 'Host: ' + Host + ':' + Port)
	else
		 FHeaders.Insert(0, 'Host: ' + Host);
	if FProxyHost <> '' then
		URI := Prot + '://' + Host + ':' + Port + URI;
	if URI = '/*' then
		URI := '*';
	if FProtocol = '0.9' then
		FHeaders.Insert(0, UpperCase(Method) + ' ' + URI)
	else
		FHeaders.Insert(0, UpperCase(Method) + ' ' + URI + ' HTTP/' + FProtocol);
	if FProxyHost = '' then
	begin
		FHTTPHost := Host;
		FHTTPPort := Port;
	end
	else
	begin
		FHTTPHost := FProxyHost;
		FHTTPPort := FProxyPort;
	end;
	if FHeaders.Items[FHeaders.Count - 1] <> '' then
		FHeaders.Add('');

	{ connect }
	if (FAliveHost <> FHTTPHost) or (FAlivePort <> FHTTPPort) then
	begin
		FSock.CloseSocket;
		FSock.CreateSocket;
		FSock.Connect(FHTTPHost, FHTTPPort);
		if FSock.LastError <> 0 then
			Exit;
		FAliveHost := FHTTPHost;
		FAlivePort := FHTTPPort;
	end
	else
	begin
		if FSock.CanRead(0) then
		begin
			FSock.CloseSocket;
			FSock.CreateSocket;
			FSock.Connect(FHTTPHost, FHTTPPort);
			if FSock.LastError <> 0 then
				Exit;
		end;
	end;

	{ send Headers }
	FSock.SendString(Headers.Items[0] + CRLF);
	if FProtocol <> '0.9' then
		for n := 1 to FHeaders.Count - 1 do
			FSock.SendString(FHeaders.Items[n] + CRLF);
	if FSock.LastError <> 0 then
		Exit;

	{ reading Status }
	Status100Error := '';
	if status100 then
	begin
		repeat
			s := FSock.RecvString(FTimeout);
			if s <> '' then
				Break;
		until FSock.LastError <> 0;
		DecodeStatus(s);
		if (FResultCode >= 100) and (FResultCode < 200) then
			repeat
				s := FSock.recvstring(FTimeout);
				if s = '' then
					Break;
			until FSock.LastError <> 0
		else
		begin
			Sending := False;
			Status100Error := s;
		end;
	end;

	{ send document }
	if Sending then
	begin
		FSock.SendBuffer(FDocument.Memory, FDocument.Size);
		if FSock.LastError <> 0 then
			Exit;
	end;

	Clear;
	Size := -1;
	FTransferEncoding := TE_UNKNOWN;

	{ read status }
	if Status100Error = '' then
	begin
		repeat
			s := FSock.RecvString(FTimeout);
			if s <> '' then
				Break;
		until FSock.LastError <> 0;
		if Pos('HTTP/', UpperCase(s)) = 1 then
		begin
			FHeaders.Add(s);
			DecodeStatus(s);
		end
		else
		begin
			{ old HTTP 0.9 and some buggy servers not send result }
			s := s + CRLF;
			FDocument.Write(Pointer(s)^, Length(s));
			FResultCode := 0;
		end;
	end
	else
		FHeaders.Add(Status100Error);

	{ if need receive hedaers, receive and parse it }
	ToClose := FProtocol <> '1.1';
	if FHeaders.Count > 0 then
		repeat
			s := FSock.RecvString(FTimeout);
			FHeaders.Add(s);
			if s = '' then
				Break;
			su := UpperCase(s);
			if Pos('CONTENT-LENGTH:', su) = 1 then
			begin
				Size := StrToIntDef(SeparateRight(s, ' '), -1);
				if Size <> -1 then
					FTransferEncoding := TE_IDENTITY;
			end;
			if Pos('CONTENT-TYPE:', su) = 1 then
				FMimeType := SeparateRight(s, ' ');
			if Pos('TRANSFER-ENCODING:', su) = 1 then
			begin
				s := SeparateRight(su, ' ');
				if Pos('CHUNKED', s) > 0 then
					FTransferEncoding := TE_CHUNKED;
			end;
			if Pos('CONNECTION: CLOSE', su) = 1 then
				ToClose := True;
		until FSock.LastError <> 0;

	{if need receive response body, read it}
	Receiving := Method <> 'HEAD';
	Receiving := Receiving and (FResultCode <> 204);
	Receiving := Receiving and (FResultCode <> 304);
	if Receiving then
		case FTransferEncoding of
			TE_UNKNOWN:
				ReadUnknown;
			TE_IDENTITY:
				ReadIdentity(Size);
			TE_CHUNKED:
				ReadChunked;
		end;

	FDocument.Seek(0, spBegin);
	Result := True;
	if ToClose then
	begin
		FSock.CloseSocket;
		FAliveHost := '';
		FAlivePort := '';
	end;
end;

function THTTPSend.ReadUnknown: Boolean;
var
	s: string;
begin
	repeat
		s := FSock.RecvPacket(FTimeout);
		if FSock.LastError = 0 then
			FDocument.Write(Pointer(s)^, Length(s));
	until FSock.LastError <> 0;
	Result := True;
end;

function THTTPSend.ReadIdentity(Size: Integer): Boolean;
var
	mem: PStream;
begin
	mem := NewMemoryStream;
	try
		mem.Size := Size;
		FSock.RecvBufferEx(mem.Memory, Size, FTimeout);
		mem.Seek(0,spBegin);
		Result := FSock.LastError = 0;
//		FDocument.CopyFrom(mem, 0);
		Stream2Stream(FDocument,mem,mem.Size);
	finally
		mem.Free;
	end;
end;

function THTTPSend.ReadChunked: Boolean;
var
	s: string;
	Size: Integer;
begin
	repeat
		repeat
			s := FSock.RecvString(FTimeout);
		until s <> '';
		if FSock.LastError <> 0 then
			Break;
		s := SeparateLeft(s, ' ');
		Size := StrToIntDef('$' + s, 0);
		if Size = 0 then
			Break;
		ReadIdentity(Size);
	until False;
	Result := FSock.LastError = 0;
end;

{==============================================================================}

function HttpGetText(const URL: string; const Response: PStrList): Boolean;
var
	HTTP: PHTTPSend;
begin
	HTTP := NewHTTPSend;
	try
		Result := HTTP.HTTPMethod('GET', URL);
		Response.LoadFromStream(HTTP.Document,false);
	finally
		HTTP.Free;
	end;
end;

function HttpGetBinary(const URL: string; const Response: PStream): Boolean;
var
	HTTP: PHTTPSend;
begin
	HTTP := NewHTTPSend;
	try
		Result := HTTP.HTTPMethod('GET', URL);
		Response.Seek(0, spBegin);
		HTTP.Document.Seek(0,spBegin);
		Stream2Stream(Response,HTTP.Document,HTTP.Document.Size);
//		Response.CopyFrom(HTTP.Document, 0);
	finally
		HTTP.Free;
	end;
end;

function HttpPostBinary(const URL: string; const Data: PStream): Boolean;
var
	HTTP: PHTTPSend;
begin
	HTTP := NewHTTPSend;
	try
		Data.Seek(0,spBegin);
		Stream2Stream(HTTP.Document,Data,Data.Size);
//		HTTP.Document.CopyFrom(Data, 0);
		HTTP.MimeType := 'Application/octet-stream';
		Result := HTTP.HTTPMethod('POST', URL);
		Data.Seek(0, spBegin);
		HTTP.Document.Seek(0,spBegin);
		Stream2Stream(Data,HTTP.Document,HTTP.Document.Size);
//		Data.CopyFrom(HTTP.Document, 0);
	finally
		HTTP.Free;
	end;
end;

function HttpPostURL(const URL, URLData: string; const Data: PStream): Boolean;
var
	HTTP: PHTTPSend;
begin
	HTTP := NewHTTPSend;
	try
		HTTP.Document.Write(Pointer(URLData)^, Length(URLData));
		HTTP.MimeType := 'application/x-url-encoded';
		Result := HTTP.HTTPMethod('POST', URL);
		HTTP.Document.Seek(0,spBegin);
		Stream2Stream(Data,HTTP.Document,HTTP.Document.Size);
//		Data.CopyFrom(HTTP.Document, 0);
	finally
		HTTP.Free;
	end;
end;

function HttpPostFile(const URL, FieldName, FileName: string;
	const Data: PStream; const ResultData: PStrList): Boolean;
const
	CRLF = #$0D + #$0A;
var
	HTTP: PHTTPSend;
	Bound, s: string;
begin
	Bound := '--' + Int2Hex(Random(MaxInt), 8) + '_Synapse_boundary';
	HTTP := NewHTTPSend;
	try
		s := Bound + CRLF;
		s := s + 'content-disposition: form-data; name="' + FieldName + '";';
		s := s + ' filename="' + FileName +'"' + CRLF;
		s := s + 'Content-Type: Application/octet-string' + CRLF + CRLF;
		HTTP.Document.Write(Pointer(s)^, Length(s));
		Data.Seek(0,spBegin);
		Stream2Stream(HTTP.Document,Data,Data.Size);
//		HTTP.Document.CopyFrom(Data, 0);
		s := CRLF + Bound + '--' + CRLF;
		HTTP.Document.Write(Pointer(s)^, Length(s));
		HTTP.MimeType := 'multipart/form-data, boundary=' + Bound;
		Result := HTTP.HTTPMethod('POST', URL);
		ResultData.LoadFromStream(HTTP.Document,false);
	finally
		HTTP.Free;
	end;
end;

end.
