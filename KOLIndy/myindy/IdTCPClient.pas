// 27-nov-2002
unit IdTCPClient;

interface

uses
  KOL,{Classes,
  IdException,} IdGlobal, IdSocks, IdTCPConnection;

type
  TProceduralEvent = procedure of object;

  PIdTCPClient=^TIdTCPClient;
  TIdTCPClient = object(TIdTCPConnection)
  protected
    FBoundIP: string;
    FHost: string;
    FOnConnected: TOnEvent;//TNotifyEvent;
    FPort: Integer;
    FSocksInfo: PSocksInfo{TSocksInfo};
    FUseNagle: boolean;
    //
    procedure DoOnConnected; virtual;
    procedure SetSocksInfo(ASocks: PSocksInfo{TSocksInfo});
  public
    procedure Init; virtual;
    procedure Connect; virtual;
    function ConnectAndGetAll: string; virtual;
//    constructor Create(AOwner: TComponent); override;
    destructor Destroy; virtual;// override;
//  published
    property BoundIP: string read FBoundIP write FBoundIP;
    property Host: string read FHost write FHost;
    property OnConnected: TOnEvent{TNotifyEvent} read FOnConnected write FOnConnected;
    property Port: integer read FPort write FPort;
    property UseNagle: boolean read FUseNagle write FUseNagle default True;
    property SocksInfo: PSocksInfo{TSocksInfo} read FSocksInfo write SetSocksInfo;
  end;

{  EIdSocksError = class(EIdException);
  EIdSocksRequestFailed = class(EIdSocksError);
  EIdSocksRequestServerFailed = class(EIdSocksError);
  EIdSocksRequestIdentFailed = class(EIdSocksError);
  EIdSocksUnknownError = class(EIdSocksError);
  EIdSocksServerRespondError = class(EIdSocksError);
  EIdSocksAuthMethodError = class(EIdSocksError);
  EIdSocksAuthError = class(EIdSocksError);
  EIdSocksServerGeneralError = class(EIdSocksError);
  EIdSocksServerPermissionError = class(EIdSocksError);
  EIdSocksServerNetUnreachableError = class(EIdSocksError);
  EIdSocksServerHostUnreachableError = class(EIdSocksError);
  EIdSocksServerConnectionRefusedError = class(EIdSocksError);
  EIdSocksServerTTLExpiredError = class(EIdSocksError);
  EIdSocksServerCommandError = class(EIdSocksError);
  EIdSocksServerAddressError = class(EIdSocksError);}

  function NewIdTCPClient(AOwner:PControl):PIdTCPClient;

implementation

uses
  IdComponent, IdStack, IdResourceStrings, IdStackConsts;

{ TIdTCPClient }

procedure TIdTCPClient.Connect;
var
  req: TIdSocksRequest;
  res: TIdSocksResponse;
  len, pos: Integer;
  tempBuffer: array[0..255] of Byte;
  ReqestedAuthMethod,
    ServerAuthMethod: Byte;
  tempPort: Word;
begin
  if Binding.HandleAllocated then
  begin
//    raise EIdAlreadyConnected.Create(RSAlreadyConnected);
  end;

  ResetConnection;
  Binding.AllocateSocket;
  try
    Binding.IP := FBoundIP;
    Binding.Bind;
    case SocksInfo.Version of
      svSocks4, svSocks4A, svSocks5:
        begin
          if not GStack.IsIP(SocksInfo.Host) then
          begin
            DoStatus(hsResolving, [SocksInfo.Host]);
          end;
          Binding.SetPeer(GStack.ResolveHost(SocksInfo.Host), SocksInfo.Port);
        end
    else
      begin
        if not GStack.IsIP(Host) then
        begin
          DoStatus(hsResolving, [Host]);
        end;
        Binding.SetPeer(GStack.ResolveHost(Host), Port);
      end;
    end;
    if not UseNagle then
    begin
      Binding.SetSockOpt(Id_IPPROTO_TCP, Id_TCP_NODELAY, PChar(@Id_SO_True),
        SizeOf(Id_SO_True));
    end;
    DoStatus(hsConnecting, [Binding.PeerIP]);
    GStack.CheckForSocketError(Binding.Connect);
  except
   { on E: Exception do
    begin
      try
        Disconnect;
      except
      end;
      raise;
    end;}
  end;
  if InterceptEnabled then
  begin
    Intercept.Connect(Binding);
  end;
  case SocksInfo.Version of
    svSocks4, svSocks4A:
      begin
        req.Version := 4;
        req.OpCode := 1;
        req.Port := GStack.WSHToNs(Port);
        if SocksInfo.Version = svSocks4A then
        begin
          req.IpAddr := GStack.StringToTInAddr('0.0.0.1');
        end
        else
        begin
          req.IpAddr := GStack.StringToTInAddr(GStack.ResolveHost(Host));
        end;
        req.UserId := SocksInfo.UserID;
        len := Length(req.UserId);
        req.UserId[len + 1] := #0;
        if SocksInfo.Version = svSocks4A then
        begin
          Move(Host[1], req.UserId[len + 2], Length(Host));
          len := len + 1 + Length(Host);
          req.UserId[len + 1] := #0;
        end;
        len := 8 + len + 1;
        WriteBuffer(req, len);
        try
          ReadBuffer(res, 8);
        except
{          on E: Exception do
          begin
            raise;
          end;}
        end;
        case res.OpCode of
          90: ;
//          91: raise EIdSocksRequestFailed.Create(RSSocksRequestFailed);
{          92: raise
            EIdSocksRequestServerFailed.Create(RSSocksRequestServerFailed);
          93: raise
            EIdSocksRequestIdentFailed.Create(RSSocksRequestIdentFailed);}
        else
//          raise EIdSocksUnknownError.Create(RSSocksUnknownError);
        end;
      end;
    svSocks5:
      begin
        if SocksInfo.Authentication = saNoAuthentication then
        begin
          tempBuffer[2] := $0
        end
        else
        begin
          tempBuffer[2] := $2;
        end;

        ReqestedAuthMethod := tempBuffer[2];
        tempBuffer[0] := $5;
        tempBuffer[1] := $1;

        len := 2 + tempBuffer[1];
        WriteBuffer(tempBuffer, len);

        try
          ReadBuffer(tempBuffer, 2);
        except
{          on E: Exception do
          begin
//            raise EIdSocksServerRespondError.Create(RSSocksServerRespondError);
          end;}
        end;

        ServerAuthMethod := tempBuffer[1];
        if (ServerAuthMethod <> ReqestedAuthMethod) or (ServerAuthMethod = $FF)
          then
        begin
//          raise EIdSocksAuthMethodError.Create(RSSocksAuthMethodError);
        end;

        if SocksInfo.Authentication = saUsernamePassword then
        begin
          tempBuffer[0] := 1;
          tempBuffer[1] := Length(SocksInfo.UserID);
          pos := 2;
          if Length(SocksInfo.UserID) > 0 then
          begin
            Move(SocksInfo.UserID[1], tempBuffer[pos],
              Length(SocksInfo.UserID));
          end;
          pos := pos + Length(SocksInfo.UserID);
          tempBuffer[pos] := Length(SocksInfo.Password);
          pos := pos + 1;
          if Length(SocksInfo.Password) > 0 then
          begin
            Move(SocksInfo.Password[1], tempBuffer[pos],
              Length(SocksInfo.Password));
          end;
          pos := pos + Length(SocksInfo.Password);

          WriteBuffer(tempBuffer, pos);
          try
            ReadBuffer(tempBuffer, 2);
          except
{            on E: Exception do
            begin
              raise
//                EIdSocksServerRespondError.Create(RSSocksServerRespondError);
            end;}
          end;

          if tempBuffer[1] <> $0 then
          begin
//            raise EIdSocksAuthError.Create(RSSocksAuthError);
          end;
        end;

        tempBuffer[0] := $5;
        tempBuffer[1] := $1;
        tempBuffer[2] := $0;
        tempBuffer[3] := $3;

        tempBuffer[4] := Length(Host);
        pos := 5;
        if Length(Host) > 0 then
          Move(Host[1], tempBuffer[pos], Length(Host));
        pos := pos + Length(Host);
        tempPort := GStack.WSHToNs(Port);
        Move(tempPort, tempBuffer[pos], SizeOf(tempPort));
        pos := pos + 2;

        WriteBuffer(tempBuffer, pos);
        try
          ReadBuffer(tempBuffer, 5);
        except
{          on E: Exception do
          begin
//            raise EIdSocksServerRespondError.Create(RSSocksServerRespondError);
          end;}
        end;

        case tempBuffer[1] of
          0: ;
{          1: raise EIdSocksServerGeneralError.Create(RSSocksServerGeneralError);
          2: raise
            EIdSocksServerPermissionError.Create(RSSocksServerPermissionError);
          3: raise
            EIdSocksServerNetUnreachableError.Create(RSSocksServerNetUnreachableError);
          4: raise
            EIdSocksServerHostUnreachableError.Create(RSSocksServerHostUnreachableError);
          5: raise
            EIdSocksServerConnectionRefusedError.Create(RSSocksServerConnectionRefusedError);
          6: raise
            EIdSocksServerTTLExpiredError.Create(RSSocksServerTTLExpiredError);
          7: raise EIdSocksServerCommandError.Create(RSSocksServerCommandError);
          8: raise EIdSocksServerAddressError.Create(RSSocksServerAddressError);}
        else
//          raise EIdSocksUnknownError.Create(RSSocksUnknownError);
        end;

        case tempBuffer[3] of
          1: len := 4 + 2;
          3: len := tempBuffer[4] + 2;
          4: len := 16 + 2;
        end;

        try
          ReadBuffer(tempBuffer[5], len - 1);
        except
{          on E: Exception do
          begin
//            raise EIdSocksServerRespondError.Create(RSSocksServerRespondError);
          end;}
        end;
      end;
  end;
  DoStatus(hsConnected, [Binding.PeerIP]);
  DoOnConnected;
end;

function TIdTCPClient.ConnectAndGetAll: string;
begin
  Connect;
  try
    result := AllData;
  finally Disconnect;
  end;
end;

function NewIdTCPClient(AOwner:PControl):PIdTCPClient;
//constructor TIdTCPClient.Create(AOwner: TComponent);
begin
//  inherited;
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
//  FSocksInfo := TSocksInfo.Create;
  FUseNagle := True;
end; }
end;

procedure TIdTCPClient.Init;
begin
    inherited;
//  New( Result, Create );
//with Result^ do
begin
  FSocksInfo := NewSocksInfo;//TSocksInfo.Create;
  FUseNagle := True;
end;
end;

destructor TIdTCPClient.Destroy;
begin
  FreeAndNil(FSocksInfo);
  inherited;
end;

procedure TIdTCPClient.DoOnConnected;
begin
  if assigned(OnConnected) then
  begin
    OnConnected(@Self);
  end;
end;

procedure TIdTCPClient.SetSocksInfo(ASocks: PSocksInfo{TSocksInfo});
begin
  FSocksInfo.Assign(ASocks);
end;

end.
