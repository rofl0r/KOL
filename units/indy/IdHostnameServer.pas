// 26-nov-2002
unit IdHostnameServer;

interface

uses KOL { , 
  Classes } ,
  IdTCPServer;

const
  KnownCommands: array[1..9] of string =
  (
    'HNAME',
    'HADDR',
    'ALL',
    'HELP',
    'VERSION',
    'ALL-OLD',
    'DOMAINS',
    'ALL-DOM',
    'ALL-INGWAY'
    );

type
  THostNameGetEvent = procedure(Thread: TIdPeerThread) of object;
  THostNameOneParmEvent = procedure(Thread: TIdPeerThread; Parm: string) of
    object;

  TIdHostNameServer = object(TIdTCPServer)
  protected
    FOnCommandHNAME: THostNameOneParmEvent;
    FOnCommandHADDR: THostNameOneParmEvent;
    FOnCommandALL: THostNameGetEvent;
    FOnCommandHELP: THostNameGetEvent;
    FOnCommandVERSION: THostNameGetEvent;
    FOnCommandALLOLD: THostNameGetEvent;
    FOnCommandDOMAINS: THostNameGetEvent;
    FOnCommandALLDOM: THostNameGetEvent;
    FOnCommandALLINGWAY: THostNameGetEvent;

    function DoExecute(Thread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property OnCommandHNAME: THostNameOneParmEvent read fOnCommandHNAME write
      fOnCommandHNAME;
    property OnCommandHADDR: THostNameOneParmEvent read fOnCommandHADDR write
      fOnCommandHADDR;
    property OnCommandALL: THostNameGetEvent read fOnCommandALL write
      fOnCommandALL;
    property OnCommandHELP: THostNameGetEvent read fOnCommandHELP write
      fOnCommandHELP;
    property OnCommandVERSION: THostNameGetEvent read fOnCommandVERSION write
      fOnCommandVERSION;
    property OnCommandALLOLD: THostNameGetEvent read fOnCommandALLOLD write
      fOnCommandALLOLD;
    property OnCommandDOMAINS: THostNameGetEvent read fOnCommandDOMAINS write
      fOnCommandDOMAINS;
    property OnCommandALLDOM: THostNameGetEvent read fOnCommandALLDOM write
      fOnCommandALLDOM;
    property OnCommandALLINGWAY: THostNameGetEvent read fOnCommandALLINGWAY write
      fOnCommandALLINGWAY;
  end;
PIdHostNameServer=^TIdHostNameServer;
function NewIdHostNameServer(AOwner: PControl):PIdHostNameServer;

implementation

uses
  IdGlobal,
  SysUtils;

//constructor TIdHostNameServer.Create(AOwner: TComponent);
function NewIdHostNameServer(AOwner: PControl):PIdHostNameServer;
begin
//  inherited Create(AOwner);
New( Result, Create );
with Result^ do
  DefaultPort := IdPORT_HOSTNAME;
end;

function TIdHostNameServer.DoExecute(Thread: TIdPeerThread): boolean;
var
  S, sCmd: string;

begin
  result := true;
  while Thread.Connection.Connected do
  begin
    S := Thread.Connection.ReadLn;
    sCmd := UpperCase(Fetch(s, CHAR32));
    case Succ(PosInStrArray(Uppercase(sCmd), KnownCommands)) of
      1: {hname}
        if assigned(OnCommandHNAME) then
          OnCommandHNAME(Thread, S);
      2: {haddr}
        if assigned(OnCommandHADDR) then
          OnCommandHADDR(Thread, S);
      3: {all}
        if assigned(OnCommandALL) then
          OnCommandALL(Thread);
      4: {help}
        if assigned(OnCommandHELP) then
          OnCommandHELP(Thread);
      5: {version}
        if assigned(OnCommandVERSION) then
          OnCommandVERSION(Thread);
      6: {all-old}
        if assigned(OnCommandALLOLD) then
          OnCommandALLOLD(Thread);
      7: {domains}
        if assigned(OnCommandDOMAINS) then
          OnCommandDOMAINS(Thread);
      8: {all-dom}
        if assigned(OnCommandALLDOM) then
          OnCommandALLDOM(Thread);
      9: {all-ingway}
        if assigned(OnCommandALLINGWAY) then
          OnCommandALLINGWAY(Thread);
    end; //while Thread.Connection.Connected do
  end; //while Thread.Connection.Connected do
  Thread.Connection.Disconnect;
end; {doExecute}

end.
