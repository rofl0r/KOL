// 22-nov-2002
// 25-apr-2003
unit IdEchoServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

type
  TIdECHOServer = object(TIdTCPServer)
  private
  protected
    function DoExecute(AThread: PIdPeerThread): boolean; virtual;//override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published }
//    DefaultPort:Integer;
    procedure Init; virtual;
//    property DefaultPort:Integer// default IdPORT_ECHO;
  end;
PIdECHOServer=^TIdECHOServer;
function NewIdECHOServer(AOwner: PControl):PIdECHOServer;

implementation

uses
  SysUtils;

//constructor TIdECHOServer.Create(AOwner: TComponent);
function NewIdECHOServer(AOwner: PControl):PIdECHOServer;
begin
  New( Result, Create );
  Result.Init;
//  inherited;
//  with Result^ do
  begin
 // DefaultPort := IdPORT_ECHO;
  end;
end;

function TIdECHOServer.DoExecute(AThread: PIdPeerThread): boolean;
begin
  result := true;
  with AThread.Connection^ do
  begin
    while Connected do
    begin
      Write(CurrentReadBuffer);
    end;
  end;
end;

procedure TIdECHOServer.Init;
begin
  inherited;
  DefaultPort := IdPORT_ECHO;
end;

end.
