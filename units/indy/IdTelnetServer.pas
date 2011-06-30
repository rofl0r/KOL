// 27-nov-2002
unit IdTelnetServer;

interface

uses KOL { , 
  Classes }{ ,
  IdException},
  IdGlobal, IdTCPServer;

const
  GLoginAttempts = 3;

type
  TTelnetData = object(TObj)
  public
    Username, Password: string;
    HUserToken: cardinal;
  end;
PTelnetData=^TTelnetData;
function NewTelnetData:PTelnetData;

type

  TIdTelnetNegotiateEvent = procedure(AThread: TIdPeerThread) of object;
  TAuthenticationEvent = procedure(AThread: TIdPeerThread;
    const AUsername, APassword: string; var AAuthenticated: Boolean) of object;

  TIdTelnetServer = object(TIdTCPServer)
  protected
    FLoginAttempts: Integer;
    FOnAuthentication: TAuthenticationEvent;
    FLoginMessage: string;
    FOnNegotiate: TIdTelnetNegotiateEvent;
  public
//    constructor Create(AOwner: TComponent); override;
    function DoAuthenticate(AThread: TIdPeerThread; const AUsername, APassword:
      string)
      : boolean; virtual;
    procedure DoNegotiate(AThread: TIdPeerThread); virtual;
    procedure DoConnect(AThread: TIdPeerThread); override;
  published
    property DefaultPort default IdPORT_TELNET;
    property LoginAttempts: Integer read FLoginAttempts write FLoginAttempts
      default GLoginAttempts;
    property LoginMessage: string read FLoginMessage write FLoginMessage;
    property OnAuthentication: TAuthenticationEvent read FOnAuthentication write
      FOnAuthentication;
    property OnNegotiate: TIdTelnetNegotiateEvent read FOnNegotiate write
      FOnNegotiate;
  end;

  PIdTelnetServer=^TIdTelnetServer;
  function NewIdTelnetServer(AOwner: PControl):PIdTelnetServer;

{  EIdTelnetServerException = class(EIdException);
  EIdNoOnAuthentication = class(EIdTelnetServerException);

  EIdLoginException = class(EIdTelnetServerException);
  EIdMaxLoginAttempt = class(EIdLoginException);}

implementation

uses KOL, 
  SysUtils, IdResourceStrings;

 { constructor TIdTelnetServer.Create(AOwner: TComponent);
 }

function NewTelnetData:PTelnetData;
begin
  New( Result, Create );
end;

function NewIdTelnetServer (AOwner: PControl):PIdTelnetServer;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
  LoginAttempts := GLoginAttempts;
  LoginMessage := RSTELNETSRVWelcomeString;
  DefaultPort := IdPORT_TELNET;
end;  
end;

function TIdTelnetServer.DoAuthenticate;
begin
  if not assigned(OnAuthentication) then
  begin
    raise EIdNoOnAuthentication.Create(RSTELNETSRVNoAuthHandler);
  end;
  result := False;
  OnAuthentication(AThread, AUsername, APassword, result);
end;

procedure TIdTelnetServer.DoConnect(AThread: TIdPeerThread);
var
  Data: TTelnetData;
  i: integer;
begin
  try
    inherited;
    if AThread.Data = nil then
    begin
      AThread.Data := TTelnetData.Create;
    end;
    Data := AThread.Data as TTelnetData;
    DoNegotiate(AThread);
    if length(LoginMessage) > 0 then
    begin
      AThread.Connection.WriteLn(LoginMessage);
      AThread.Connection.WriteLn('');
    end;
    if assigned(OnAuthentication) then
    begin
      for i := 1 to LoginAttempts do
      begin
        AThread.Connection.Write(RSTELNETSRVUsernamePrompt);
        Data.Username := AThread.Connection.InputLn;
        AThread.Connection.Write(RSTELNETSRVPasswordPrompt);
        Data.Password := AThread.Connection.InputLn('*');
        AThread.Connection.WriteLn;
        if DoAuthenticate(AThread, Data.Username, Data.Password) then
        begin
          Break;
        end
        else
        begin
          AThread.Connection.WriteLn(RSTELNETSRVInvalidLogin); // translate
          if i = FLoginAttempts then
          begin
            raise EIdMaxLoginAttempt.Create(RSTELNETSRVMaxloginAttempt);
              // translate
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      AThread.Connection.WriteLn(E.Message);
      AThread.Connection.Disconnect;
    end;
  end;
end;

procedure TIdTelnetServer.DoNegotiate(AThread: TIdPeerThread);
begin
  if assigned(FOnNegotiate) then
  begin
    FOnNegotiate(AThread);
  end;
end;

end.
