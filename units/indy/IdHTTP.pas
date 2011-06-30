// 28-nov-2002
unit IdHTTP;

interface

uses KOL { ,
  Classes } ,KOLClasses,
  IdGlobal,
  IdHeaderList,
  IdSSLIntercept,
  IdTCPClient;

type
  TIdHTTPMethod = (hmHead, hmGet, hmPost);
  TIdHTTPProtocolVersion = (pv1_0, pv1_1);

  TIdHTTPOnRedirectEvent = procedure(Sender: PObj{TObject}; var dest: string; var
    NumRedirect: Integer; var Handled: boolean) of object;
const
  Id_TIdHTTP_ProtocolVersion = pv1_1;
  Id_TIdHTTP_RedirectMax = 15;
  Id_TIdHTTP_HandleRedirects = False;
type
  TIdHeaderInfo = object(TObj)
  protected
    FAccept: string;
    FAcceptCharSet: string;
    FAcceptEncoding: string;
    FAcceptLanguage: string;
    FComponent: PObj;//TComponent;
    FConnection: string;
    FContentEncoding: string;
    FContentLanguage: string;
    FContentLength: Integer;
    FContentRangeEnd: Cardinal;
    FContentRangeStart: Cardinal;
    FContentType: string;
    FContentVersion: string;
    FDate: TDateTime;
    FExpires: TDateTime;
    FExtraHeaders: PIdHeaderList;//TIdHeaderList;
    FFrom: string;
    FLastModified: TDateTime;
    FLocation: string;
    FPassword: string;
    FProxyAuthenticate: string;
    FProxyPassword: string;
    FProxyPort: Integer;
    FProxyServer: string;
    FProxyUsername: string;
    FReferer: string;
    FServer: string;
    FUserAgent: string;
    FUserName: string;
    FWWWAuthenticate: string;

    procedure AssignTo(Destination: PObj);// override;
    procedure GetHeaders(Headers:PIdHeaderList{ TIdHeaderList});
    procedure SetHeaders(var Headers: PIdHeaderList{TIdHeaderList});
    procedure SetExtraHeaders(const Value:PIdHeaderList{ TIdHeaderList});
  public
    procedure Init; virtual;
    procedure Clear;
     { constructor Create(Component: TComponent); virtual;
     } destructor Destroy; 
   virtual;  { published } 
    property Accept: string read FAccept write FAccept;
    property AcceptCharSet: string read FAcceptCharSet write FAcceptCharSet;
    property AcceptEncoding: string read FAcceptEncoding write FAcceptEncoding;
    property AcceptLanguage: string read FAcceptLanguage write FAcceptLanguage;
    property Connection: string read FConnection write FConnection;
    property ContentEncoding: string read FContentEncoding write
      FContentEncoding;
    property ContentLanguage: string read FContentLanguage write
      FContentLanguage;
    property ContentLength: Integer read FContentLength write FContentLength;
    property ContentRangeEnd: Cardinal read FContentRangeEnd write
      FContentRangeEnd;
    property ContentRangeStart: Cardinal read FContentRangeStart write
      FContentRangeStart;
    property ContentType: string read FContentType write FContentType;
    property ContentVersion: string read FContentVersion write FContentVersion;
    property Date: TDateTime read FDate write FDate;
    property Expires: TDateTime read FExpires write FExpires;
    property ExtraHeaders: PIdHeaderList{TIdHeaderList} read FExtraHeaders write
      SetExtraHeaders;
    property From: string read FFrom write FFrom;
    property LastModified: TDateTime read FLastModified write FLastModified;
    property Location: string read FLocation write FLocation;
    property Password: string read FPassword write FPassword;
    property ProxyAuthenticate: string read FProxyAuthenticate write
      FProxyAuthenticate;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyServer: string read FProxyServer write FProxyServer;
    property ProxyUsername: string read FProxyUsername write FProxyUsername;
    property Referer: string read FReferer write FReferer;
    property Server: string read FServer write FServer;
    property UserAgent: string read FUserAgent write FUserAgent;
    property Username: string read FUsername write FUsername;
    property WWWAuthenticate: string read FWWWAuthenticate write
      FWWWAuthenticate;
  end;
PIdHeaderInfo=^TIdHeaderInfo;
function NewIdHeaderInfo(Component: PObj):PIdHeaderInfo;
type

  TIdHTTP = object(TIdTCPClient)
  protected
    FInternalHeaders: PIdHeaderList;//TIdHeaderList;
    FProtocolVersion: TIdHTTPProtocolVersion;
    FRedirectCount: Integer;
    FRedirectMax: Integer;
    FRequest: PIdHeaderInfo;//TIdHeaderInfo;
    FResponse: PIdHeaderInfo;//TIdHeaderInfo;
    FResponseCode: Integer;
    FResponseText: string;
    FHandleRedirects: Boolean;
    FTunnelProxyHost: string;
    FTunnelProxyPort: Integer;
    FTunnelProxyProtocol: string;

    FOnRedirect: TIdHTTPOnRedirectEvent;
    function DoOnRedirect(var Location: string; RedirectCount: integer): boolean;
      virtual;
    procedure RetrieveHeaders;
    procedure DoProxyConnectMethod(ASender: PObj{TObject});
  public
    HostHeader: string;
    ProtoHeader: string;
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy;
     virtual; procedure DoRequest(const AMethod: TIdHTTPMethod; AURL: string;
      const ASource:PObj{ TObject}; const AResponseContent: PStream{TStream}); virtual;
    procedure Get(AURL: string; const AResponseContent: PStream{TStream}); overload;
    function Get(AURL: string): string; overload;
    procedure Head(URL: string);
    procedure Post(URL: string; const Source: PStrList;{TStrings;} const AResponseContent:
      PStream{TStream});
      overload;

    procedure Post(URL: string; const Source, AResponseContent: PStream{TStream});
      overload;

    property ResponseCode: Integer read FResponseCode;
    property ResponseText: string read FResponseText;
    property Response: PIdHeaderInfo{TIdHeaderInfo} read FResponse;
   { published }
    property HandleRedirects: Boolean read FHandleRedirects
    write FHandleRedirects default Id_TIdHTTP_HandleRedirects;
    property ProtocolVersion: TIdHTTPProtocolVersion read FProtocolVersion write
      FProtocolVersion default Id_TIdHTTP_ProtocolVersion;
    property RedirectMaximum: Integer read FRedirectMax write FRedirectMax
      default Id_TIdHTTP_RedirectMax;
    property Request: PIdHeaderInfo{TIdHeaderInfo} read FRequest write FRequest;
    property OnRedirect: TIdHTTPOnRedirectEvent read FOnRedirect write
      FOnRedirect;
//    property Port default IdPORT_HTTP;
  end;
PIdHTTP=^TIdHTTP;
function NewIdHTTP(AOwner: PControl):PIdHTTP;


implementation

uses
  IdCoder3To4,
  IdComponent,
  IdTCPConnection,
  {IdException,}
  IdResourceStrings,
  SysUtils;

const
  DefaultUserAgent = 'Mozilla/3.0 (compatible; Indy Library)'; {do not localize}
  ProtocolVersionString: array[TIdHTTPProtocolVersion] of string = ('1.0',
    '1.1');

procedure TIdHeaderInfo.AssignTo(Destination: PObj);
begin
  if TIdHeaderInfo.AncestorOfObject(Destination) then// is TIdHeaderInfo then
  begin
    with PIdHeaderInfo(Destination)^ do// as TIdHeaderInfo do
    begin
      FAccept := Self.FAccept;
      FAcceptCharSet := Self.FAcceptCharset;
      FAcceptEncoding := Self.FAcceptEncoding;
      FAcceptLanguage := Self.FAcceptLanguage;
      FContentEncoding := Self.FContentEncoding;
      FContentLanguage := Self.FContentLanguage;
      FContentLength := Self.FContentLength;
      FContentRangeEnd := Self.FContentRangeEnd;
      FContentRangeStart := Self.FContentRangeStart;
      FContentType := Self.FContentType;
      FContentVersion := Self.FContentVersion;
      FDate := Self.FDate;
      FExpires := Self.FExpires;
      FExtraHeaders.Assign(Self.FExtraHeaders);
      FFrom := Self.FFrom;
      FLastModified := Self.FLastModified;
      FLocation := Self.FLocation;
      FPassword := Self.FPassword;
      FProxyPassword := Self.FProxyPassword;
      FProxyPort := Self.FProxyPort;
      FProxyServer := Self.FProxyServer;
      FProxyUsername := Self.FProxyUsername;
      FReferer := Self.FReferer;
      FServer := Self.FServer;
      FUserAgent := Self.FUserAgent;
      FUsername := Self.FUsername;
      FWWWAuthenticate := Self.FWWWAuthenticate;
      FProxyAuthenticate := Self.FProxyAuthenticate;
    end;
  end;
//  else
//    inherited AssignTo(Destination);
end;

procedure TIdHeaderInfo.Clear;
begin
  FAccept := 'text/html, */*'; {do not localize}
  FAcceptCharSet := '';
  FLocation := '';
  FServer := '';
  FConnection := '';
  FContentVersion := '';
  FWWWAuthenticate := '';
  FContentEncoding := '';
  FContentLanguage := '';
  FContentType := '';
  FContentLength := 0;
  FContentRangeStart := 0;
  FContentRangeEnd := 0;
  FDate := 0;
  FLastModified := 0;
  FUserAgent := DefaultUserAgent;
  FExpires := 0;
  FProxyServer := '';
  FProxyUsername := '';
  FProxyPassword := '';
  FProxyPort := 0;
  FProxyAuthenticate := '';
  FExtraHeaders.Clear;
end;

//constructor TIdHeaderInfo.Create(Component: TComponent);
function NewIdHeaderInfo(Component: PObj):PIdHeaderInfo;
begin
//  inherited Create;
New( Result, Create );
//Result.FComponent:=Component;
Result.Init;
{with Result^ do
begin
//  FComponent := Component;
//  FExtraHeaders := TIdHeaderList.Create;
  Clear;
end;}
end;

procedure TIdHeaderInfo.Init;
begin
  inherited;
//  with Result^ do
begin
//  FComponent := Component;
  FExtraHeaders := NewIdHeaderList;//TIdHeaderList.Create;
  Clear;
end;
end;

procedure TIdHeaderInfo.GetHeaders(Headers: PIdHeaderList{TIdHeaderList});
var
  i: Integer;
  RangeDecode: string;
begin
  ExtraHeaders.Clear;
  with Headers^ do
  begin
    FLocation := Values['Location']; {do not localize}
    Values['Location'] := ''; {do not localize}
    FServer := Values['Server']; {do not localize}
    Values['Server'] := ''; {do not localize}
    FConnection := Values['Connection']; {do not localize}
    Values['Connection'] := ''; {do not localize}
    FContentVersion := Values['Content-Version']; {do not localize}
    Values['Content-Version'] := ''; {do not localize}
    FWWWAuthenticate := Values['WWWAuthenticate']; {do not localize}
    Values['WWWAuthenticate'] := ''; {do not localize}
    FContentEncoding := Values['Content-Encoding']; {do not localize}
    Values['Content-Encoding'] := ''; {do not localize}
    FContentLanguage := Values['Content-Language']; {do not localize}
    Values['Content-Language'] := ''; {do not localize}
    FContentType := Values['Content-Type']; {do not localize}
    Values['Content-Type'] := ''; {do not localize}
    FContentLength := StrToIntDef(Values['Content-Length'], 0); {do not localize}
    Values['Content-Length'] := ''; {do not localize}
    RangeDecode := Values['Content-Range']; {do not localize}
    Values['Content-Range'] := ''; {do not localize}
    if RangeDecode <> '' then
    begin
      Fetch(RangeDecode);
      FContentRangeStart := StrToInt(Fetch(RangeDecode, '-'));
      FContentRangeEnd := StrToInt(Fetch(RangeDecode, '/'));
    end;
    FDate := idGlobal.GMTToLocalDateTime(Values['Date']); {do not localize}
    Values['Date'] := ''; {do not localize}
    FLastModified := GMTToLocalDateTime(Values['Last-Modified']);
      {do not localize}
    Values['Last-Modified'] := ''; {do not localize}
    FExpires := GMTToLocalDateTime(Values['Expires']); {do not localize}
    Values['Expires'] := ''; {do not localize}
    FProxyAuthenticate := Values['Proxy-Authenticate']; {do not localize}
    Values['Proxy-Authenticate'] := ''; {do not localize}
    for i := 0 to Headers.Count - 1 do
      FExtraHeaders.Add(Headers.{Strings[i]}Items[i]);
  end;
end;

procedure TIdHeaderInfo.SetHeaders(var Headers: PIdHeaderList{TIdHeaderList});
begin
  Headers.Clear;
  with Headers^ do
  begin
    if FAccept <> '' then
      Add('Accept: ' + FAccept); {do not localize}
    if FAcceptCharset <> '' then
      Add('Accept-Charset: ' + FAcceptCharSet); {do not localize}
    if FAcceptEncoding <> '' then
      Add('Accept-Encoding: ' + FAcceptEncoding); {do not localize}
    if FAcceptLanguage <> '' then
      Add('Accept-Language: ' + FAcceptLanguage); {do not localize}
    if FFrom <> '' then
      Add('From: ' + FFrom); {do not localize}
    if FReferer <> '' then
      Add('Referer: ' + FReferer); {do not localize}
    if FUserAgent <> '' then
      Add('User-Agent: ' + FUserAgent); {do not localize}
    if FConnection <> '' then
      Add('Connection: ' + FConnection); {do not localize}
    if FContentVersion <> '' then
      Add('Content-Version: ' + FContentVersion); {do not localize}
    if FContentEncoding <> '' then
      Add('Content-Encoding: ' + FContentEncoding); {do not localize}
    if FContentLanguage <> '' then
      Add('Content-Language: ' + FContentLanguage); {do not localize}
    if FContentType <> '' then
      Add('Content-Type: ' + FContentType); {do not localize}
    if FContentLength <> 0 then
      Add('Content-Length: ' + IntToStr(FContentLength)); {do not localize}
    if (FContentRangeStart <> 0) or (FContentRangeEnd <> 0) then
    begin
      if FContentRangeEnd <> 0 then
        Add('Range: bytes=' + IntToStr(FContentRangeStart) + '-' +
          IntToStr(FContentRangeEnd))
      else
        Add('Range: bytes=' + IntToStr(FContentRangeStart) + '-');
    end;
    if FUsername <> '' then
    begin
      Add('Authorization: Basic ' + Base64Encode(FUsername + ':' + FPassword));
        {do not localize}
    end;
    if (Length(FProxyServer) > 0) and (Length(FProxyUsername) > 0) then
    begin
      Add('Proxy-Authorization: Basic ' + Base64Encode(FProxyUsername + ':' +
        {do not localize}
        FProxyPassword));
    end;
    AddStrings(FExtraHeaders);
  end;
end;

procedure TIdHeaderInfo.SetExtraHeaders(const Value: PIdHeaderList{TIdHeaderList});
begin
  FExtraHeaders.Assign(Value);
end;

destructor TIdHeaderInfo.Destroy;
begin
  FExtraHeaders.Free;
  inherited Destroy;
end;

//constructor TIdHTTP.Create;
function NewIdHTTP(AOwner: PControl):PIdHTTP;
begin
//  inherited;
New( Result, Create );
Result.Init;
(*with Result^ do
begin
{  Port := IdPORT_HTTP;
  FRedirectMax := Id_TIdHTTP_RedirectMax;
  FHandleRedirects := Id_TIdHTTP_HandleRedirects;
  FRequest := TIdHeaderInfo.Create(self);
  FResponse := TIdHeaderInfo.Create(Self);
  FInternalHeaders := TIdHeaderList.Create;
  FProtocolVersion := Id_TIdHTTP_ProtocolVersion;}
end;      *)
end;

procedure TIdHTTP.Init;
begin
  inherited;
//  with Result^ do
begin
  Port := IdPORT_HTTP;
  FRedirectMax := Id_TIdHTTP_RedirectMax;
  FHandleRedirects := Id_TIdHTTP_HandleRedirects;
  FRequest := NewIdHeaderInfo(@Self);//TIdHeaderInfo.Create(self);
  FResponse := NewIdHeaderInfo(@Self);//TIdHeaderInfo.Create(Self);
  FInternalHeaders := NewIdHeaderList;//TIdHeaderList.Create;
  FProtocolVersion := Id_TIdHTTP_ProtocolVersion;
end;
end;

destructor TIdHTTP.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  FInternalHeaders.Free;
  inherited Destroy;
end;

procedure TIdHTTP.Get(AURL: string; const AResponseContent: PStream{TStream});
begin
  DoRequest(hmGet, AURL, nil, @AResponseContent);
end;

procedure TIdHTTP.Head(URL: string);
begin
  DoRequest(hmHead, URL, nil, nil);
end;

procedure TIdHTTP.Post(URL: string; const Source: PStrList{TStrings}; const
  AResponseContent: PStream{TStream});
var
  OldProtocol: TIdHTTPProtocolVersion;
begin
  if Connected then
    Disconnect;
  OldProtocol := FProtocolVersion;
  FProtocolVersion := pv1_0;
  DoRequest(hmPost, URL, Source, AResponseContent);
  FProtocolVersion := OldProtocol;
end;

procedure TIdHTTP.RetrieveHeaders;
var
  s: string;
begin
  FInternalHeaders.Clear;
  s := ReadLn;
  while Length(s) > 0 do
  begin
    FInternalHeaders.Add(s);
    s := ReadLn;
  end;
  FResponse.GetHeaders(FInternalHeaders);
end;

function TIdHTTP.DoOnRedirect(var Location: string; RedirectCount: integer):
  boolean;
begin
  result := HandleRedirects;
  if assigned(FOnRedirect) then
  begin
    FOnRedirect(@self, Location, RedirectCount, result);
  end;
end;

procedure TIdHTTP.DoRequest(const AMethod: TIdHTTPMethod; AURL: string;
  const ASource: PObj{TObject}; const AResponseContent: PStream{TStream});
var
  LLocation,
    LDoc,
    LHost,
    LPath,
    LProto,
    LPort,
    LBookmark: string;
  ResponseDigit: Integer;
  i: Integer;
  CloseConnection: boolean;

  function SetHostAndPort(AProto, AHost: string; APort: Integer): Boolean;
  begin
    if Length(Request.ProxyServer) > 0 then
    begin
      Host := Request.ProxyServer;
      Port := Request.ProxyPort;
      if Length(AHost) > 0 then HostHeader := AHost;
      if Length(AProto) > 0 then ProtoHeader := AProto;

      FTunnelProxyHost := AHost;
      if APort = -1 then
      begin
        FTunnelProxyPort := 443
      end
      else
      begin
        FTunnelProxyPort := APort;
      end;

      FTunnelProxyProtocol := ProtocolVersionString[ProtocolVersion];
      if assigned(Intercept) then
      begin

        if (Intercept.Tag=0) then
        begin
          Intercept.OnConnect := DoProxyConnectMethod;
        end
        else
        begin
          Intercept.OnConnect := nil;
        end;

{        if TIdConnectionIntercept.AncestorOfObject(Intercept) then//(Intercept is TIdSSLConnectionIntercept) then
        begin
          Intercept.OnConnect := DoProxyConnectMethod;
        end
        else
        begin
          Intercept.OnConnect := nil;
        end;}
      end;
      Result := True;
    end
    else
    begin
      Result := False;
      if AnsiSameText(AProto, 'HTTPS') then
      begin
{        if not (Intercept is TIdSSLConnectionIntercept) then
        begin
          raise EIdInterceptPropInvalid.Create(RSInterceptPropInvalid);
        end;}
        if (Length(AHost) > 0) then
        begin
          if ((not AnsiSameText(Host, AHost)) or (Port <> APort)) and (Connected)
            then
            Disconnect;
          Host := AHost;
          HostHeader := AHost;
          if Length(AProto) > 0 then ProtoHeader := AProto;
        end
        else
          HostHeader := Host;
        if APort = -1 then
          Port := 443
        else
          Port := APort;
        InterceptEnabled := True;
      end
      else
      begin
        if (Length(AHost) > 0) then
        begin
          if ((not AnsiSameText(Host, AHost)) or (Port <> APort)) and (Connected)
            then
            Disconnect;
          Host := AHost;
          HostHeader := AHost;
          if Length(AProto) > 0 then ProtoHeader := AProto;
        end
        else
          HostHeader := Host;
        if APort = -1 then
          Port := 80
        else
          Port := APort;
      end;
    end;
  end;

  procedure ReadResult;
  var
    Size: Integer;

    function ChunkSize: integer;
    var
      j: Integer;
      s: string;
    begin
      s := ReadLn;
      j := AnsiPos(' ', s);
      if j > 0 then
      begin
        s := Copy(s, 1, j - 1);
      end;
      Result := StrToIntDef('$' + s, 0);
    end;

  begin
    if AResponseContent <> nil then
    begin
      if Response.ContentLength <> 0 then
      begin
        ReadStream(AResponseContent, Response.ContentLength);
      end
      else
      begin
        if AnsiPos('chunked', Response.ExtraHeaders.Values['Transfer-Encoding'])
          > 0 then {do not localize}
        begin
          DoStatus(hsText, [RSHTTPChunkStarted]);
          Size := ChunkSize;
          while Size > 0 do
          begin
            ReadStream(AResponseContent, Size);
            ReadLn;
            Size := ChunkSize;
          end;
          ReadLn;
        end
        else
        begin
          ReadStream(AResponseContent, -1, True);
        end;
      end;
    end;
  end;

begin
  inc(FRedirectCount);

  ParseURI(AURL, LProto, LHost, LPath, LDoc, LPort, LBookmark);
  AURL := LPath + LDoc;

  if SetHostAndPort(LProto, LHost, StrToIntDef(LPort, -1)) then
  begin
    if Length(LHost) > 0 then
      AURL := LHost + AURL
    else
      AURL := HostHeader + AURL;

    if Length(LProto) > 0 then
      AURL := LProto + '://' + AURL
    else
      AURL := ProtoHeader + '://' + AURL;
  end;

  CheckForDisconnect(False);
  if not Connected then
  begin
    Connect;
  end;

  FInternalHeaders.Clear;
  if AMethod = hmPost then
  begin
    if ASource.Tag=0 then
    begin
      Request.ContentLength := Length({TStrings}PStrList(ASource).Text);
    end
    else
    if ASource.Tag=1000 then
    begin
      Request.ContentLength := PStream(ASource).Size;
    end
    else
    begin
//      raise EIdObjectTypeNotSupported.Create(RSObjectTypeNotSupported);
    end;
//    if  TStrList.AncestorOfObject( ASource ) then

//    if ASource is TStrings then
//    begin
//      Request.ContentLength := Length({TStrings}PStrList(ASource).Text);
//    end
{    else
      if ASource is TStream then
    begin
      Request.ContentLength := TStream(ASource).Size;
    end
    else
    begin
      raise EIdObjectTypeNotSupported.Create(RSObjectTypeNotSupported);
    end;}
  end
  else
    Request.ContentLength := 0;

  Request.SetHeaders(FInternalHeaders);
  case AMethod of
    hmHead: WriteLn('HEAD ' + AURL + ' HTTP/' +
      ProtocolVersionString[ProtocolVersion]); {do not localize}
    hmGet: WriteLn('GET ' + AURL + ' HTTP/' +
      ProtocolVersionString[ProtocolVersion]); {do not localize}
    hmPost: WriteLn('POST ' + AURL + ' HTTP/' +
      ProtocolVersionString[ProtocolVersion]); {do not localize}
  end;
  WriteLn('Host: ' + HostHeader); {do not localize}

  for i := 0 to FInternalHeaders.Count - 1 do
    WriteLn(FInternalHeaders.{Strings}Items[i]);
  WriteLn('');

  if (AMethod = hmPost) then
  begin
    if ASource.Tag=0 then
    begin
      WriteStrings(PStrList(ASource));
    end
    else
    if ASource.Tag=1000 then
    begin
      WriteStream(PStream(ASource), True, false);
    end
    else
    begin
//      raise EIdObjectTypeNotSupported.Create(RSObjectTypeNotSupported);
    end;
{    if ASource is TStrings then
    begin
      WriteStrings(TStrings(ASource));
    end
    else
      if ASource is TStream then
    begin
      WriteStream(TStream(ASource), True, false);
    end
    else
    begin
      raise EIdObjectTypeNotSupported.Create(RSObjectTypeNotSupported);
    end}
  end;
  FResponseText := ReadLn;
  CloseConnection := AnsiSameText(Copy(FResponseText, 6, 3), '1.0');
  Fetch(FResponseText);
  FResponseCode := StrToInt(Fetch(FResponseText, ' ', False));
  ResponseDigit := ResponseCode div 100;
  RetrieveHeaders;
  if ((ResponseDigit = 3) and (ResponseCode <> 304)) or
    (Length(Response.Location) > 0) then
  begin
    ReadResult;

    LLocation := Response.Location;

    if (FHandleRedirects) and (FRedirectCount < FRedirectMax) then
    begin
      if assigned(AResponseContent) then
      begin
        AResponseContent.Position := 0;
      end;

      if DoOnRedirect(LLocation, FRedirectCount) then
      begin
        if (FProtocolVersion = pv1_0) or (CloseConnection) then
        begin
          Disconnect;
        end;

        DoRequest(AMethod, LLocation, ASource, AResponseContent);
      end;
    end
    else
    begin
      if not DoOnRedirect(LLocation, FRedirectCount) then
      begin
      //       If not Handled
//        raise EIdProtocolReplyError.CreateError(ResponseCode, ResponseText)
      end
      else
        Response.Location := LLocation;
    end;
  end
  else
  begin
    ReadResult;
    if ResponseDigit <> 2 then
    begin
      if InterceptEnabled then
      begin
        Disconnect;
      end;

//      raise EIdProtocolReplyError.CreateError(ResponseCode, ResponseText);
    end;
  end;
  if (FProtocolVersion = pv1_0) or (CloseConnection) then
  begin
    Disconnect;
  end
  else
  begin
    if AnsiSameText(Trim(Response.Connection), 'CLOSE') and (Connected) then
    begin {do not localize}
      Disconnect;
    end
    else
    begin
      CheckForGracefulDisconnect(False);
    end;
  end;
  FRedirectCount := 0;
end;

procedure TIdHTTP.Post(URL: string; const Source, AResponseContent: PStream{TStream});
var
  OldProtocol: TIdHTTPProtocolVersion;
begin
  if Connected then
    Disconnect;
  OldProtocol := FProtocolVersion;
  FProtocolVersion := pv1_0;
  DoRequest(hmPost, URL, Source, AResponseContent);
  FProtocolVersion := OldProtocol;
end;

function TIdHTTP.Get(AURL: string): string;
var
  Stream: PStringStream;//PStream;//TStringStream;
begin
  /// @!@!!!!!!!!!!!!!!!!
  Stream := NewStringStream('');//  NewMemoryStream;//TStringStream.Create('');
  try
    Get(AURL, Stream);
    result := Stream.DataString;
  finally Stream.Free;
  end;
end;

procedure TIdHTTP.DoProxyConnectMethod(ASender: PObj{TObject});
var
  sPort: string;
begin
  InterceptEnabled := False;
  sPort := IntToStr(FTunnelProxyPort);
  WriteLn('CONNECT ' + FTunnelProxyHost + ':' + sPort + ' HTTP/' +
    FTunnelProxyProtocol);
  WriteLn;
  ReadLn;
  ReadLn;
  ReadLn;
  InterceptEnabled := True;
end;

end.

