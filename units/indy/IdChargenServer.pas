// 26-nov-2002
unit IdChargenServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

type
  TIdChargenServer = object(TIdTCPServer)
  protected
    function DoExecute(AThread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property DefaultPort default IdPORT_CHARGEN;
  end;
PIdChargenServer=^TIdChargenServer;
function NewIdChargenServer(AOwner: PControl):PIdChargenServer;

implementation

{ TIdChargenServer }

//constructor TIdChargenServer.Create(AOwner: TComponent);
function NewIdChargenServer(AOwner: PControl):PIdChargenServer;
begin
//  inherited;
  New( Result, Create );
with Result^ do
  DefaultPort := IdPORT_CHARGEN;
end;

function TIdChargenServer.DoExecute(AThread: TIdPeerThread): boolean;
var
  Counter, Width, Base: integer;
begin
  Base := 0;
  result := true;
  Counter := 1;
  Width := 1;
  with AThread.Connection do
  begin
    while Connected do
    begin
      Write(Chr(Counter + 31));
      Inc(Counter);
      Inc(Width);
      if Width = 72 then
      begin
        Writeln('');
        Width := 1;
        Inc(Base);
        if Base = 95 then
        begin
          Base := 1;
        end;
        Counter := Base;
      end;
      if Counter = 95 then
      begin
        Counter := 1;
      end;
    end;
  end;
end;

end.
