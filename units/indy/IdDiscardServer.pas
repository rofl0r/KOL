// 22-nov-2002
unit IdDiscardServer;

interface

uses KOL { , 
  Classes } ,
  IdTCPServer;

type
  TIdDISCARDServer = object(TIdTCPServer)
  protected
    function DoExecute(Thread: PIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
  end;
PIdDISCARDServer=^TIdDISCARDServer;
function NewIdDISCARDServer(AOwner: PControl):PIdDISCARDServer;

implementation

uses
  IdGlobal,
  SysUtils;

//constructor TIdDISCARDServer.Create(AOwner: TComponent);
function NewIdDISCARDServer(AOwner: PControl):PIdDISCARDServer;
begin
  New( Result, Create );
//  inherited;
  with Result^ do
    DefaultPort := IdPORT_DISCARD;
end;

function TIdDISCARDServer.DoExecute(Thread: PIdPeerThread): boolean;
begin
  result := true;
  with Thread.Connection do
  begin
    while Connected do
    begin
      RemoveXBytesFromBuffer(CurrentReadBufferSize);
    end;
  end;
end;

end.
