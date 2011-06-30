// 27-nov-2002
unit IdSMTP;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdMessage,
  IdEMailAddress,
  IdHeaderList,
  IdMessageClient;

type
  TAuthenticationType = (atNone, atLogin);

const
  ID_TIDSMTP_AUTH_TYPE = atNone;

type
  TIdSMTP = object(TIdMessageClient)
  protected
    FDidAuthenticate: Boolean;
    FAuthenticationType: TAuthenticationType;
    FMailAgent: string;
    FPassword: string;
    FUserId: string;

    procedure GetAuthTypes;
    function IsAuthProtocolAvailable(Auth: TAuthenticationType)
      : Boolean; virtual;
  public
    AuthSchemesSupported: PStrList;

    procedure Assign(Source: {TPersistent}PObj); virtual;//override;
    function Authenticate: Boolean; virtual;
    procedure Connect; virtual;//override;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy;
     virtual; procedure Disconnect; virtual;//override;
{    object (TObj)}procedure QuickSend(const AHost, ASubject, ATo,
      AFrom, AText: string);
    procedure Send(AMsg: PIdMessage); virtual;

//    property AuthSchemesSupported: TStringList read FAuthSchemesSupported;
   { published }
    property AuthenticationType: TAuthenticationType read FAuthenticationType
    write FAuthenticationType default ID_TIDSMTP_AUTH_TYPE;
    property MailAgent: string read FMailAgent write FMailAgent;
    property Password: string read FPassword write FPassword;
    property UserId: string read FUserId write FUserId;
    //property Port default IdPORT_SMTP;
  end;
PIdSMTP=^TIdSMTP;
function NewIdSMTP(AOwner: {TComponent}PControl):PIdSMTP;

implementation

uses
  IdCoder3To4,
  IdResourceStrings;

procedure TIdSMTP.Assign(Source: {TPersistent}Pobj);
begin
{  if Source is TIdSMTP then
  begin
    AuthenticationType := TIdSMTP(Source).AuthenticationType;
    Host := TIdSMTP(Source).Host;
    MailAgent := TIdSMTP(Source).MailAgent;
    Password := TIdSMTP(Source).Password;
    Port := TIdSMTP(Source).Port;
    UserId := TIdSMTP(Source).UserId;
  end
  else
    inherited;}
end;

function TIdSMTP.Authenticate: Boolean;

  function AuthLogin: Boolean;
  begin
    SendCmd('auth LOGIN', 334); {Do not localize}
    SendCmd(Base64Encode(UserId), 334);
    SendCmd(Base64Encode(Password), 235);
    Result := True;
  end;

begin
  Result := False;
  case FAUthenticationType of
    atLogin: Result := AuthLogin;
  end;
  FDidAuthenticate := True;
end;

procedure TIdSMTP.Connect;
begin
  inherited;
  try
    GetResponse([220]);
    AuthSchemesSupported.Clear;
    if SendCmd('ehlo ' + LocalName) = 250 then {Do not localize}
    begin
      GetAuthTypes;
    end
    else
    begin
      SendCmd('Helo ' + LocalName, 250); {Do not localize}
    end;
  except
    Disconnect;
    raise;
  end;
end;

//constructor TIdSMTP.Create(AOwner: TComponent);
function NewIdSMTP(AOwner: PControl):PIdSMTP;
begin
  New( Result, Create );
with Result^ do
begin
//  inherited;
  AuthSchemesSupported := NewStrList;
  Port := IdPORT_SMTP;
end;
end;

destructor TIdSMTP.Destroy;
begin
//  FreeAndNil(FAuthSchemesSupported);
  inherited;
end;

procedure TIdSMTP.Disconnect;
begin
  try
    if Connected then
    begin
      WriteLn('Quit'); {Do not localize}
    end;
  finally
    inherited;
    FDidAuthenticate := False;
  end;
end;

procedure TIdSMTP.GetAuthTypes;
var
  Iterator: Integer;
  Buffer: string;
  ListEntry: string;
begin
  Iterator := 1;
  while Iterator < FCmdResultDetails.Count do
  begin
//    Buffer := UpperCase(FCmdResultDetails[Iterator]);
    if (IndyPos('AUTH', Buffer) = 5) and ((Copy(Buffer, 9, 1) = ' ') or
      {Do not localize}
      (Copy(Buffer, 9, 1) = '=')) then {Do not localize}
    begin
      Buffer := Copy(Buffer, 10, Length(Buffer));
      while Buffer <> '' do
      begin
        while StrReplace(Buffer, '=', ' ') do; {Do not localize}
        ListEntry := Fetch(Buffer, ' '); {Do not localize}
//        if (FAuthSchemesSupported.IndexOf(ListEntry) = -1) then
//          FAuthSchemesSupported.Add(ListEntry);
      end;
    end;
    Inc(Iterator);
  end;
end;

function TIdSMTP.IsAuthProtocolAvailable(
  Auth: TAuthenticationType): Boolean;
begin
(*  case Auth of
    atLogin: Result := (FAuthSchemesSupported.IndexOf('LOGIN') <> -1);
      {Do not localize}
  else
    Result := False;
  end;*)
end;

{class} procedure TIdSMTP.QuickSend(const AHost, ASubject, ATo,
  AFrom, AText: string);
var
  SMTP: TIdSMTP;
  Msg: TIdMessage;
begin
(*  SMTP := TIdSMTP.Create(nil);
  try
    Msg := TIdMessage.Create(SMTP);
    with Msg do
    begin
      Subject := ASubject;
      Recipients.EMailAddresses := ATo;
      From.Text := AFrom;
      Body.Text := AText;
    end;
    with SMTP do
    begin
      Host := AHost;
      Connect;
      try
        ;
        Send(Msg);
      finally
        Disconnect;
      end;
    end;
  finally
    SMTP.Free;
  end;*)
end;

procedure TIdSMTP.Send(AMsg: PIdMessage);

  procedure WriteRecipient(const AEmailAddress: pIdEmailAddressItem);
  begin
    SendCmd('RCPT to:<' + AEMailAddress.Address + '>', 250); {Do not localize}
  end;

  procedure WriteRecipients(AList: pIdEmailAddressList);
  var
    i: integer;
  begin
    for i := 0 to AList.count - 1 do
    begin
      WriteRecipient(AList.Items[i]);
    end;
  end;

  function NeedToAuthenticate: Boolean;
  begin
    if FAuthenticationType <> atNone then
    begin
      Result := IsAuthProtocolAvailable(FAuthenticationType)
        and (FDidAuthenticate = False);
    end
    else
    begin
      Result := False;
    end;
  end;

begin
  SendCmd('Rset'); {Do not localize}
  if NeedToAuthenticate then
  begin
    Authenticate;
  end;
  SendCmd('Mail from:<' + AMsg.From.Address + '>', 250); {Do not localize}
  WriteRecipients(AMsg.Recipients);
  WriteRecipients(AMsg.CCList);
  WriteRecipients(AMsg.BccList);
  SendCmd('Data', 354); {Do not localize}
  AMsg.ExtraHeaders.Values['X-Mailer'] := MailAgent; {Do not localize}
  SendMsg(AMsg);
  SendCmd('.', 250); {Do not localize}
end;

end.
