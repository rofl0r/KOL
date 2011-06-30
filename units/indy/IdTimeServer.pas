// 25-nov-2002
unit IdTimeServer;

interface

uses KOL { , 
  Classes } ,
  IdTCPServer;

type
  TIdTimeServer = object(TIdTCPServer)
  protected
    FBaseDate: TDateTime;

    function DoExecute(AThread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property BaseDate: TDateTime read FBaseDate write FBaseDate;
  end;
PIdTimeServer=^TIdTimeServer;
function NewIdTimeServer(AOwner: PControl):PIdTimeServer;

implementation

uses
  IdGlobal,
  IdStack, SysUtils;

constructor TIdTimeServer.Create(AOwner: PControl);
begin
  New( Result, Create );
  with Result^ do
  begin
//  inherited;
  DefaultPort := IdPORT_TIME;
  FBaseDate := 2;
  end;
end;

function TIdTimeServer.DoExecute(AThread: TIdPeerThread): boolean;
begin
  result := true;
  with AThread.Connection do
  begin
    WriteCardinal(Trunc(extended(Now + IdGlobal.TimeZoneBias - Int(FBaseDate)) *
      24 * 60 * 60));
    Disconnect;
  end;
end;

end.
