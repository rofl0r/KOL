// 25-nov-2002
unit IdDayTimeServer;

interface

uses KOL { ,
  Classes } ,
  IdGlobal,
  IdTCPServer;

type
  TIdDayTimeServer = object(TIdTCPServer)
  protected
    FTimeZone: string;
    function DoExecute(AThread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property TimeZone: string read FTimeZone write FTimeZone;
    property DefaultPort default IdPORT_DAYTIME;
  end;
PIdDayTimeServer=^TIdDayTimeServer;
function NewIdDayTimeServer(AOwner: PControl):PIdDayTimeServer;

implementation

uses
  SysUtils;

function NewIdDayTimeServer(AOwner: PControl):PIdDayTimeServer;
  //constructor TIdDayTimeServer.Create(AOwner: TComponent);
begin
  New( Result, Create );
  with Result^ do
  begin
//  inherited;
  DefaultPort := IdPORT_DAYTIME;
  FTimeZone := 'EST';
  end;
end;

function TIdDayTimeServer.DoExecute(AThread: TIdPeerThread): boolean;
begin
  result := true;
  with AThread.Connection do
  begin
    Writeln(FormatDateTime('dddd, mmmm dd, yyyy hh:nn:ss', Now) + '-' +
      FTimeZone);
    Disconnect;
  end;
end;

end.
