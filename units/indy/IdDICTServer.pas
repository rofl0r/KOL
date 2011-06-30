// 27-nov-2002
unit IdDICTServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

const
  KnownCommands: array[1..10] of string =
  (
    'AUTH',
    'CLIENT',
    'DEFINE',
    'HELP',
    'MATCH',
    'OPTION',
    'QUIT',
    'SASLAUTH',
    'SHOW',
    'STATUS'
    );

type
  TIdDICTGetEvent = procedure(Thread: TIdPeerThread) of object;
  TIdDICTOtherEvent = procedure(Thread: TIdPeerThread; Command, Parm: string) of
    object;
  TIdDICTDefineEvent = procedure(Thread: TIdPeerThread; Database, WordToFind:
    string) of object;
  TIdDICTMatchEvent = procedure(Thread: TIdPeerThread; Database, Strategy,
    WordToFind: string) of object;
  TIdDICTShowEvent = procedure(Thread: TIdPeerThread; Command: string) of
    object;
  TIdDICTAuthEvent = procedure(Thread: TIdPeerThread; Username, authstring:
    string) of object;

  TIdDICTServer = object(TIdTCPServer)
  protected
    fOnCommandHELP: TIdDICTGetEvent;
    fOnCommandDEFINE: TIdDICTDefineEvent;
    fOnCommandMATCH: TIdDICTMatchEvent;
    fOnCommandQUIT: TIdDICTGetEvent;
    fOnCommandSHOW: TIdDICTShowEvent;
    fOnCommandAUTH, fOnCommandSASLAuth: TIdDICTAuthEvent;
    fOnCommandOption: TIdDICTOtherEvent;
    fOnCommandSTAT: TIdDICTGetEvent;
    fOnCommandCLIENT: TIdDICTShowEvent;
    fOnCommandOther: TIdDICTOtherEvent;

    function DoExecute(Thread: TIdPeerThread): boolean; virtual;//override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property DefaultPort default IdPORT_DICT;

    property OnCommandHelp: TIdDICTGetEvent read fOnCommandHelp write
      fOnCommandHelp;
    property OnCommandDefine: TIdDICTDefineEvent read fOnCommandDefine write
      fOnCommandDefine;
    property OnCommandMatch: TIdDICTMatchEvent read fOnCommandMatch write
      fOnCommandMatch;
    property OnCommandQuit: TIdDICTGetEvent read fOnCommandQuit write
      fOnCommandQuit;
    property OnCommandShow: TIdDICTShowEvent read fOnCommandShow write
      fOnCommandShow;
    property OnCommandAuth: TIdDICTAuthEvent read fOnCommandAuth write
      fOnCommandAuth;
    property OnCommandSASLAuth: TIdDICTAuthEvent read fOnCommandSASLAuth write
      fOnCommandSASLAuth;
    property OnCommandOption: TIdDICTOtherEvent read fOnCommandOption write
      fOnCommandOption;
    property OnCommandStatus: TIdDICTGetEvent read fOnCommandStat write
      fOnCommandStat;
    property OnCommandClient: TIdDICTShowEvent read fOnCommandClient write
      fOnCommandClient;
    property OnCommandOther: TIdDICTOtherEvent read fOnCommandOther write
      fOnCommandOther;
  end;
PIdDICTServer=^TIdDICTServer;
function NewIdDICTServer(AOwner: PControl):PIdDICTServer;


implementation

uses
  IdResourceStrings,
  SysUtils;

//constructor TIdDICTServer.Create(AOwner: TComponent);
function NewIdDICTServer(AOwner: PControl):PIdDICTServer;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
//  DefaultPort := IdPORT_DICT;
end;
end;

function TIdDICTServer.DoExecute(Thread: TIdPeerThread): boolean;
var
  s, sCmd, sCmd2: string;

  procedure NotHandled;
  begin
    Thread.Connection.Writeln('500 ' + RSCMDNotRecognized);
  end;

begin
  result := true;
  s := Thread.Connection.ReadLn;
  sCmd := UpperCase(Fetch(s));
  case Succ(PosInStrArray(Uppercase(sCmd), KnownCommands)) of
    1: {auth}
      if assigned(OnCommandAuth) then
      begin
        sCmd2 := UpperCase(Fetch(s));
        OnCommandAuth(Thread, sCmd2, S);
      end
      else
        NotHandled;
    2: {client}
      if assigned(OnCommandClient) then
        OnCommandClient(Thread, S)
      else
        NotHandled;
    3: {define}
      if assigned(OnCommandHelp) then
      begin
        sCmd2 := UpperCase(Fetch(s));
        OnCommandHelp(Thread);
      end
      else
        NotHandled;
    4: {help}
      if assigned(OnCommandHelp) then
        OnCommandHelp(Thread)
      else
        NotHandled;
    5: {match}
      if assigned(OnCommandMatch) then
      begin
        sCmd := UpperCase(Fetch(s));
        sCmd2 := UpperCase(Fetch(s));
        OnCommandMatch(Thread, sCmd, sCmd2, S);
      end
      else
        NotHandled;
    6: {option}
      if assigned(OnCommandOption) then
        OnCommandOption(Thread, s, '')
      else
        NotHandled;
    7: {quit}
      if assigned(OnCommandQuit) then
        OnCommandQuit(Thread)
      else
        NotHandled;
    8: {saslauth}
      if assigned(OnCommandSASLAuth) then
      begin
        sCmd2 := UpperCase(Fetch(s));
        OnCommandSASLAuth(Thread, sCmd2, s);
      end
      else
        NotHandled;
    9: {show}
      if assigned(OnCommandShow) then
        OnCommandShow(Thread, s)
      else
        NotHandled;
    10: {status}
      if assigned(OnCommandStatus) then
        OnCommandStatus(Thread)
      else
        NotHandled;
  else
    begin
      if assigned(OnCommandOther) then
        OnCommandOther(Thread, sCmd, S);
    end;
  end;
end;

end.
