// 26-nov-2002
unit IdIrcServer;

interface

uses KOL { , 
  Classes } ,
  IdTCPServer;

const
  KnownCommands: array[1..40] of string =
  (
    'ADMIN',
    'AWAY',
    'CONNECT',
    'ERROR',
    'INFO',
    'INVITE',
    'ISON',
    'JOIN',
    'KICK',
    'KILL',
    'LINKS',
    'LIST',
    'MODE',
    'NAMES',
    'NICK',
    'NOTICE',
    'OPER',
    'PART',
    'PASS',
    'PING',
    'PONG',
    'PRIVMSG',
    'QUIT',
    'REHASH',
    'RESTART',
    'SERVER',
    'SQUIT',
    'STATS',
    'SUMMON',
    'TIME',
    'TOPIC',
    'TRACE',
    'USER',
    'USERHOST',
    'USERS',
    'VERSION',
    'WALLOPS',
    'WHO',
    'WHOIS',
    'WHOWAS'
    );

type
  TIdIrcGetEvent = procedure(Thread: TIdPeerThread) of object;
  TIdIrcOtherEvent = procedure(Thread: TIdPeerThread; Command, Parm: string) of
    object;
  TIdIrcOneParmEvent = procedure(Thread: TIdPeerThread; Parm: string) of object;
  TIdIrcTwoParmEvent = procedure(Thread: TIdPeerThread; Parm1, Parm2: string) of
    object;
  TIdIrcThreeParmEvent = procedure(Thread: TIdPeerThread; Parm1, Parm2, Parm3:
    string) of object;
  TIdIrcFiveParmEvent = procedure(Thread: TIdPeerThread; Parm1, Parm2, Parm3,
    Parm4, Parm5: string) of object;
  TIdIrcUserEvent = procedure(Thread: TIdPeerThread; UserName, HostName,
    ServerName, RealName: string) of object;
  TIdIrcServerEvent = procedure(Thread: TIdPeerThread; ServerName, Hopcount,
    Info: string) of object;

  TIdIRCServer = object(TIdTCPServer)
  protected
    fOnCommandOther: TIdIrcOtherEvent;
    fOnCommandPass: TIdIrcOneParmEvent;
    fOnCommandNick: TIdIrcTwoParmEvent;
    fOnCommandUser: TIdIrcUserEvent;
    fOnCommandServer: TIdIrcServerEvent;
    fOnCommandOper: TIdIrcTwoParmEvent;
    fOnCommandQuit: TIdIrcOneParmEvent;
    fOnCommandSQuit: TIdIrcTwoParmEvent;
    fOnCommandJoin: TIdIrcTwoParmEvent;
    fOnCommandPart: TIdIrcOneParmEvent;
    fOnCommandMode: TIdIrcFiveParmEvent;
    fOnCommandTopic: TIdIrcTwoParmEvent;
    fOnCommandNames: TIdIrcOneParmEvent;
    fOnCommandList: TIdIrcTwoParmEvent;
    fOnCommandInvite: TIdIrcTwoParmEvent;
    fOnCommandKick: TIdIrcThreeParmEvent;
    fOnCommandVersion: TIdIrcOneParmEvent;
    fOnCommandStats: TIdIrcTwoParmEvent;
    fOnCommandLinks: TIdIrcTwoParmEvent;
    fOnCommandTime: TIdIrcOneParmEvent;
    fOnCommandConnect: TIdIrcThreeParmEvent;
    fOnCommandTrace: TIdIrcOneParmEvent;
    fOnCommandAdmin: TIdIrcOneParmEvent;
    fOnCommandInfo: TIdIrcOneParmEvent;
    fOnCommandPrivMsg: TIdIrcTwoParmEvent;
    fOnCommandNotice: TIdIrcTwoParmEvent;
    fOnCommandWho: TIdIrcTwoParmEvent;
    fOnCommandWhoIs: TIdIrcTwoParmEvent;
    fOnCommandWhoWas: TIdIrcThreeParmEvent;
    fOnCommandKill: TIdIrcTwoParmEvent;
    fOnCommandPing: TIdIrcTwoParmEvent;
    fOnCommandPong: TIdIrcTwoParmEvent;
    fOnCommandError: TIdIrcOneParmEvent;
    fOnCommandAway: TIdIrcOneParmEvent;
    fOnCommandRehash: TIdIrcGetEvent;
    fOnCommandRestart: TIdIrcGetEvent;
    fOnCommandSummon: TIdIrcTwoParmEvent;
    fOnCommandUsers: TIdIrcOneParmEvent;
    fOnCommandWallops: TIdIrcOneParmEvent;
    fOnCommandUserHost: TIdIrcOneParmEvent;
    fOnCommandIsOn: TIdIrcOneParmEvent;

    function DoExecute(Thread: TIdPeerThread): boolean; override;
  public
     { constructor Create(AOwner: TComponent); override;
   }  { published } 
    property OnCommandPass: TIdIrcOneParmEvent read fOnCommandPass write
      fOnCommandPass;
    property OnCommandNick: TIdIrcTwoParmEvent read fOnCommandNick write
      fOnCommandNick;
    property OnCommandUser: TIdIrcUserEvent read fOnCommandUser write
      fOnCommandUser;
    property OnCommandServer: TIdIrcServerEvent read fOnCommandServer write
      fOnCommandServer;
    property OnCommandOper: TIdIrcTwoParmEvent read fOnCommandOper write
      fOnCommandOper;
    property OnCommandQuit: TIdIrcOneParmEvent read fOnCommandQuit write
      fOnCommandQuit;
    property OnCommandSQuit: TIdIrcTwoParmEvent read fOnCommandSQuit write
      fOnCommandSQuit;
    property OnCommandJoin: TIdIrcTwoParmEvent read fOnCommandJoin write
      fOnCommandJoin;
    property OnCommandPart: TIdIrcOneParmEvent read fOnCommandPart write
      fOnCommandPart;
    property OnCommandMode: TIdIrcFiveParmEvent read fOnCommandMode write
      fOnCommandMode;
    property OnCommandTopic: TIdIrcTwoParmEvent read fOnCommandTopic write
      fOnCommandTopic;
    property OnCommandNames: TIdIrcOneParmEvent read fOnCommandNames write
      fOnCommandNames;
    property OnCommandList: TIdIrcTwoParmEvent read fOnCommandList write
      fOnCommandList;
    property OnCommandInvite: TIdIrcTwoParmEvent read fOnCommandInvite write
      fOnCommandInvite;
    property OnCommandKick: TIdIrcThreeParmEvent read fOnCommandKick write
      fOnCommandKick;
    property OnCommandVersion: TIdIrcOneParmEvent read fOnCommandVersion write
      fOnCommandVersion;
    property OnCommandStats: TIdIrcTwoParmEvent read fOnCommandStats write
      fOnCommandStats;
    property OnCommandLinks: TIdIrcTwoParmEvent read fOnCommandLinks write
      fOnCommandLinks;
    property OnCommandTime: TIdIrcOneParmEvent read fOnCommandTime write
      fOnCommandTime;
    property OnCommandConnect: TIdIrcThreeParmEvent read fOnCommandConnect write
      fOnCommandConnect;
    property OnCommandTrace: TIdIrcOneParmEvent read fOnCommandTrace write
      fOnCommandTrace;
    property OnCommandAdmin: TIdIrcOneParmEvent read fOnCommandAdmin write
      fOnCommandAdmin;
    property OnCommandInfo: TIdIrcOneParmEvent read fOnCommandInfo write
      fOnCommandInfo;
    property OnCommandPrivMsg: TIdIrcTwoParmEvent read fOnCommandPrivMsg write
      fOnCommandPrivMsg;
    property OnCommandNotice: TIdIrcTwoParmEvent read fOnCommandNotice write
      fOnCommandNotice;
    property OnCommandWho: TIdIrcTwoParmEvent read fOnCommandWho write
      fOnCommandWho;
    property OnCommandWhoIs: TIdIrcTwoParmEvent read fOnCommandWhoIs write
      fOnCommandWhoIs;
    property OnCommandWhoWas: TIdIrcThreeParmEvent read fOnCommandWhoWas write
      fOnCommandWhoWas;
    property OnCommandKill: TIdIrcTwoParmEvent read fOnCommandKill write
      fOnCommandKill;
    property OnCommandPing: TIdIrcTwoParmEvent read fOnCommandPing write
      fOnCommandPing;
    property OnCommandPong: TIdIrcTwoParmEvent read fOnCommandPong write
      fOnCommandPong;
    property OnCommandError: TIdIrcOneParmEvent read fOnCommandError write
      fOnCommandError;
    property OnCommandAway: TIdIrcOneParmEvent read fOnCommandAway write
      fOnCommandAway;
    property OnCommandRehash: TIdIrcGetEvent read fOnCommandRehash write
      fOnCommandRehash;
    property OnCommandRestart: TIdIrcGetEvent read fOnCommandRestart write
      fOnCommandRestart;
    property OnCommandSummon: TIdIrcTwoParmEvent read fOnCommandSummon write
      fOnCommandSummon;
    property OnCommandUsers: TIdIrcOneParmEvent read fOnCommandUsers write
      fOnCommandUsers;
    property OnCommandWallops: TIdIrcOneParmEvent read fOnCommandWallops write
      fOnCommandWallops;
    property OnCommandUserHost: TIdIrcOneParmEvent read fOnCommandUserHost write
      fOnCommandUserHost;
    property OnCommandIsOn: TIdIrcOneParmEvent read fOnCommandIsOn write
      fOnCommandIsOn;
    property OnCommandOther: TIdIrcOtherEvent read fOnCommandOther write
      fOnCommandOther;
  end;
PIdIRCServer=^TIdIRCServer;
function NewIdIRCServer(AOwner: PControl):PIdIRCServer;

implementation

uses
  IdGlobal, IdResourceStrings,
  SysUtils;

//constructor TIdIRCServer.Create(AOwner: TComponent);
function NewIdIRCServer(AOwner: PControl):PIdIRCServer;
begin
//  inherited;
New( Result, Create );
with Result^ do
  DefaultPort := IdPORT_IRC;
end;

function TIdIRCServer.DoExecute(Thread: TIdPeerThread): boolean;
var
  s, sCmd, sCmd2, sCmd3, sCmd4: string;

  procedure NotHandled;
  begin
    Thread.Connection.Writeln('421 ' + RSCMDNotRecognized);
  end;

begin
  result := true;
  while Thread.Connection.Connected do
  begin
    s := Thread.Connection.ReadLn;
    sCmd := Fetch(s, ' ');
    case Succ(PosInStrArray(Uppercase(sCmd), KnownCommands)) of
      1: {ADMIN}
        if assigned(OnCommandAdmin) then
        begin
          OnCommandAdmin(Thread, S);
        end
        else
          NotHandled;
      2: {AWAY}
        if assigned(OnCommandAway) then
        begin
          OnCommandAway(Thread, S);
        end
        else
          NotHandled;
      3: {CONNECT}
        if assigned(OnCommandConnect) then
        begin
          sCmd2 := Fetch(s, ' ');
          sCmd3 := Fetch(s, ' ');
          OnCommandConnect(Thread, sCmd2, sCmd3, S);
        end
        else
          NotHandled;
      4: {ERROR}
        if assigned(OnCommandError) then
        begin
          OnCommandError(Thread, S);
        end
        else
          NotHandled;
      5: {INFO}
        if assigned(OnCommandInfo) then
        begin
          OnCommandInfo(Thread, S);
        end
        else
          NotHandled;
      6: {INVITE}
        if assigned(OnCommandInvite) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandInvite(Thread, sCmd2, S);
        end
        else
          NotHandled;
      7: {ISON}
        if assigned(OnCommandIsOn) then
        begin
          OnCommandIsOn(Thread, S);
        end
        else
          NotHandled;
      8: {JOIN}
        if assigned(OnCommandJoin) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandJoin(Thread, sCmd2, S);
        end
        else
          NotHandled;
      9: {KICK}
        if assigned(OnCommandKick) then
        begin
          sCmd2 := Fetch(s, ' ');
          sCmd3 := Fetch(s, ' ');
          OnCommandKick(Thread, sCmd2, sCmd3, S);
        end
        else
          NotHandled;
      10: {KILL}
        if assigned(OnCommandKill) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandKill(Thread, sCmd2, S);
        end
        else
          NotHandled;
      11: {LINKS}
        if assigned(OnCommandLinks) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandLinks(Thread, sCmd2, S);
        end
        else
          NotHandled;
      12: {LIST}
        if assigned(OnCommandList) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandList(Thread, sCmd2, S);
        end
        else
          NotHandled;
      13: {MODE}
        if assigned(OnCommandMode) then
        begin
          sCmd := Fetch(s, ' ');
          sCmd2 := Fetch(s, ' ');
          sCmd3 := Fetch(s, ' ');
          sCmd4 := Fetch(s, ' ');
          OnCommandMode(Thread, sCmd, sCmd2, sCmd3, sCmd4, S);
        end
        else
          NotHandled;
      14: {NAMES}
        if assigned(OnCommandNames) then
        begin
          OnCommandNames(Thread, S);
        end
        else
          NotHandled;
      15: {NICK}
        if assigned(OnCommandNick) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandNick(Thread, sCmd2, S);
        end
        else
          NotHandled;
      16: {NOTICE}
        if assigned(OnCommandNotice) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandNotice(Thread, sCmd2, S);
        end
        else
          NotHandled;
      17: {OPER}
        if assigned(OnCommandOper) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandOper(Thread, sCmd2, S);
        end
        else
          NotHandled;
      18: {PART}
        if assigned(OnCommandPart) then
        begin
          OnCommandPart(Thread, S);
        end
        else
          NotHandled;
      19: {PASS}
        if assigned(OnCommandPass) then
        begin
          OnCommandPass(Thread, S);
        end
        else
          NotHandled;
      20: {PING}
        if assigned(OnCommandPing) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandPing(Thread, sCmd2, S);
        end
        else
          NotHandled;
      21: {PONG}
        if assigned(OnCommandPong) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandPong(Thread, sCmd2, S);
        end
        else
          NotHandled;
      22: {PRIVMSG}
        if assigned(OnCommandPrivMsg) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandPrivMsg(Thread, sCmd2, S);
        end
        else
          NotHandled;
      23: {QUIT}
        if assigned(OnCommandQuit) then
        begin
          OnCommandQuit(Thread, s);
        end
        else
          NotHandled;
      24: {REHASH}
        if assigned(OnCommandRehash) then
        begin
          OnCommandRehash(Thread);
        end
        else
          NotHandled;
      25: {RESTART}
        if assigned(OnCommandRestart) then
        begin
          OnCommandRestart(Thread);
        end
        else
          NotHandled;
      26: {SERVER}
        if assigned(OnCommandServer) then
        begin
          sCmd := Fetch(s, ' ');
          sCmd2 := Fetch(s, ' ');
          OnCommandServer(Thread, sCmd, sCmd2, S);
        end
        else
          NotHandled;
      27: {SQUIT}
        if assigned(OnCommandSQuit) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandSQuit(Thread, sCmd2, S);
        end
        else
          NotHandled;
      28: {STAT}
        if assigned(OnCommandStats) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandStats(Thread, sCmd2, S);
        end
        else
          NotHandled;
      29: {SUMMON}
        if assigned(OnCommandSummon) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandSummon(Thread, sCmd2, S);
        end
        else
          NotHandled;
      30: {TIME}
        if assigned(OnCommandTime) then
        begin
          OnCommandTime(Thread, S);
        end
        else
          NotHandled;
      31: {TOPIC}
        if assigned(OnCommandTopic) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandTopic(Thread, sCmd2, S);
        end
        else
          NotHandled;
      32: {TRACE}
        if assigned(OnCommandTrace) then
        begin
          OnCommandTrace(Thread, S);
        end
        else
          NotHandled;
      33: {USER}
        if assigned(OnCommandUser) then
        begin
          sCmd := Fetch(s, ' ');
          sCmd2 := Fetch(s, ' ');
          sCmd3 := Fetch(s, ' ');
          OnCommandUser(Thread, sCmd, sCmd2, sCmd3, S);
        end
        else
          NotHandled;
      34: {USERHOST}
        if assigned(OnCommandUserHost) then
        begin
          OnCommandUserHost(Thread, S);
        end
        else
          NotHandled;
      35: {USERS}
        if assigned(OnCommandUsers) then
        begin
          OnCommandUsers(Thread, S);
        end
        else
          NotHandled;
      36: {VERSION}
        if assigned(OnCommandVersion) then
        begin
          OnCommandVersion(Thread, S);
        end
        else
          NotHandled;
      37: {WALLOPS}
        if assigned(OnCommandWallops) then
        begin
          OnCommandWallops(Thread, S);
        end
        else
          NotHandled;
      38: {WHO}
        if assigned(OnCommandWho) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandWho(Thread, sCmd2, S);
        end
        else
          NotHandled;
      39: {WHOIS}
        if assigned(OnCommandWhoIs) then
        begin
          sCmd2 := Fetch(s, ' ');
          OnCommandWhoIs(Thread, sCmd2, S);
        end
        else
          NotHandled;
      40: {WHOWAS}
        if assigned(OnCommandWhoWas) then
        begin
          sCmd2 := Fetch(s, ' ');
          sCmd3 := Fetch(s, ' ');
          OnCommandWhoWas(Thread, sCmd2, sCmd3, S);
        end
        else
          NotHandled;
    else
      begin
        if assigned(OnCommandOther) then
          OnCommandOther(Thread, sCmd, S);
      end;
    end;
  end;
end;

end.
