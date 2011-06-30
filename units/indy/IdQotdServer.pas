// 25-nov-2002
unit IdQotdServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

type
  TIdQOTDGetEvent = procedure(Thread: TIdPeerThread) of object;

  TIdQOTDServer = object(TIdTCPServer)
  protected
    FOnCommandQOTD: TIdQOTDGetEvent;
    function DoExecute(Thread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property OnCommandQOTD: TIdQOTDGetEvent read fOnCommandQOTD
    write fOnCommandQOTD;
    property DefaultPort default IdPORT_QOTD;
  end;
PIdQOTDServer=^TIdQOTDServer;
function NewIdQOTDServer(AOwner: PControl):PIdQOTDServer;

implementation

uses
  SysUtils;

function NewIdQOTDServer(AOwner: PControl):PIdQOTDServer;
  //constructor TIdQOTDServer.Create(AOwner: TComponent);
begin
//  inherited;
  New( Result, Create );
with Result^ do
  DefaultPort := IdPORT_QOTD;
end;

function TIdQOTDServer.DoExecute(Thread: TIdPeerThread): boolean;
begin
  result := true;
  if Thread.Connection.Connected then
  begin
    if assigned(OnCommandQOTD) then
    begin
      OnCommandQOTD(Thread);
    end;
  end;
  Thread.Connection.Disconnect;
end;

end.
