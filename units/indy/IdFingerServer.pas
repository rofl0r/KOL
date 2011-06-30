// 26-nov-2002
unit IdFingerServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

type
  TIdFingerGetEvent = procedure(AThread: TIdPeerThread; const AUserName: string)
    of object;

  TIdFingerServer = object(TIdTCPServer)
  protected
    FOnCommandFinger: TIdFingerGetEvent;
    FOnCommandVerboseFinger: TIdFingerGetEvent;

    function DoExecute(AThread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 

    property OnCommandFinger: TIdFingerGetEvent read FOnCommandFinger
    write FOnCommandFinger;
    property OnCommandVerboseFinger: TIdFingerGetEvent
    read FOnCommandVerboseFinger write FOnCommandVerboseFinger;
    property DefaultPort default IdPORT_FINGER;
  end;
PIdFingerServer=^TIdFingerServer;
function NewIdFingerServer(AOwner: PControl):PIdFingerServer;

implementation

uses
  SysUtils;

//constructor TIdFingerServer.Create(AOwner: TComponent);
function NewIdFingerServer(AOwner: PControl):PIdFingerServer;
begin
//  inherited;
New( Result, Create );
with Result^ do
  DefaultPort := IdPORT_FINGER;
end;

function TIdFingerServer.DoExecute(AThread: TIdPeerThread): boolean;
var
  s: string;
begin
  result := true;
  s := TrimRight(AThread.Connection.Readln);
  if assigned(FOnCommandVerboseFinger) and
    (UpperCase(Copy(s, Length(s) - 1, 2)) = '/W') then
  begin
    s := Copy(s, 1, Length(s) - 2);
    OnCommandVerboseFinger(AThread, s);
  end
  else
  begin
    if assigned(OnCommandFinger) then
    begin
      OnCommandFinger(AThread, s);
    end;
  end;
  AThread.Connection.Disconnect;
end;

end.
