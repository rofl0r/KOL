// 26-nov-2002
unit IdSocks;

interface

uses KOL { , 
  Classes } ,
  IdStack;

type
  TIdSocksRequest = record
    Version: Byte;
    OpCode: Byte;
    Port: Word;
    IpAddr: TIdInAddr;
    UserId: string[255];
  end;

  TIdSocksResponse = record
    Version: Byte;
    OpCode: Byte;
    Port: Word;
    IpAddr: TIdInAddr;
  end;

  TSocksVersion = (svNoSocks, svSocks4, svSocks4A, svSocks5);
  TSocksAuthentication = (saNoAuthentication, saUsernamePassword);

const
  ID_SOCKS_AUTH = saNoAuthentication;
  ID_SOCKS_VER = svNoSocks;
  ID_SOCKS_PORT = 0;

type
  TSocksInfo = object(TObj)
  protected
    FAuthentication: TSocksAuthentication;
    FHost: string;
    FPassword: string;
    FPort: Integer;
    FUserID: string;
    FVersion: TSocksVersion;
  public
    procedure Init; virtual;
     { constructor Create;
     } procedure Assign(Source: PObj);// override;
   { published } 
    property Authentication: TSocksAuthentication read FAuthentication write
      FAuthentication default ID_SOCKS_AUTH;
    property Host: string read FHost write FHost;
    property Password: string read FPassword write FPassword;
    property Port: Integer read FPort write FPort default ID_SOCKS_PORT;
    property UserID: string read FUserID write FUserID;
    property Version: TSocksVersion read FVersion write FVersion{ default
      ID_SOCKS_VER};
  end;
PSocksInfo=^TSocksInfo;

function NewSocksInfo:PSocksInfo;

implementation

{ TSocksInfo }

procedure TSocksInfo.Assign(Source: PObj);
begin
//  if Source is TSocksInfo then
    with PSocksInfo(Source)^{ as TSocksInfo} do
    begin
      Self.Authentication := Authentication;
      Self.Host := Host;
      Self.Password := Password;
      Self.Port := Port;
      Self.UserID := UserID;
      Self.Version := Version;
    end;
//  else
//    inherited;
end;

//constructor TSocksInfo.Create;
//begin
//  inherited;
function NewSocksInfo:PSocksInfo;
begin
  New( Result, Create );
  Result.Init;
{  with Result^ do
  begin
  Authentication := ID_SOCKS_AUTH;
  Version := ID_SOCKS_VER;
  Port := ID_SOCKS_PORT;
  end;     }
end;

procedure TSocksInfo.Init;
begin
  inherited;
//    New( Result, Create );
//  with Result^ do
  begin
  Authentication := ID_SOCKS_AUTH;
  Version := ID_SOCKS_VER;
  Port := ID_SOCKS_PORT;
  end;
end;

end.
