// 28-nov-2002
unit IdNNTPServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

const
  KnownCommands: array[1..26] of string =
  ('ARTICLE',
    'BODY',
    'HEAD',
    'STAT',
    'GROUP',
    'LIST',
    'HELP',
    'IHAVE',
    'LAST',
    'NEWGROUPS',
    'NEWNEWS',
    'NEXT',
    'POST',
    'QUIT',
    'SLAVE',
    'AUTHINFO',
    'XOVER',
    'XHDR',
    'DATE', {returns "111 YYYYMMDDHHNNSS"}
    'LISTGROUP', {returns all the article numbers for specified group}
    'MODE', {for the MODE command}
    'TAKETHIS', {streaming nntp}
    'CHECK', {streaming nntp need this to go with takethis}
    'XTHREAD', {Useful mainly for the TRN newsreader }
    'XGTITLE', {legacy support}
    'XPAT' {Header Pattern matching}
    );

type
  TGetEvent = procedure(AThread: TIdPeerThread) of object;
  TOtherEvent = procedure(AThread: TIdPeerThread; ACommand: string; AParm:
    string; var AHandled: Boolean) of object;
  TDoByIDEvent = procedure(AThread: TIdPeerThread; AActualID: string) of object;
  TDoByNoEvent = procedure(AThread: TIdPeerThread; AActualNumber: Cardinal) of
    object;
  TGroupEvent = procedure(AThread: TIdPeerThread; AGroup: string) of object;
  TNewsEvent = procedure(AThread: TIdPeerThread; AParm: string) of object;
  TDataEvent = procedure(AThread: TIdPeerThread; AData: TObject) of object;

  TIdNNTPServer = object(TIdTCPServer)
  protected
    fOnCommandAuthInfo: TOtherEvent;
    fOnCommandArticleID: TDoByIDEvent;
    fOnCommandArticleNO: TDoByNoEvent;
    fOnCommandBodyID: TDoByIDEvent;
    fOnCommandBodyNO: TDoByNoEvent;
    fOnCommandHeadID: TDoByIDEvent;
    fOnCommandHeadNO: TDoByNoEvent;
    fOnCommandStatID: TDoByIDEvent;
    fOnCommandStatNO: TDoByNoEvent;
    fOnCommandGroup: TGroupEvent;
    fOnCommandList: TNewsEvent;
    fOnCommandHelp: TGetEvent;
    fOnCommandIHave: TDoByIDEvent;
    fOnCommandLast: TGetEvent;
    fOnCommandMode: TNewsEvent;
    fOnCommandNewGroups: TNewsEvent;
    fOnCommandNewNews: TNewsEvent;
    fOnCommandNext: TGetEvent;
    fOnCommandPost: TGetEvent;
    fOnCommandQuit: TGetEvent;
    fOnCommandSlave: TGetEvent;

    fOnCommandXOver: TNewsEvent;
    fOnCommandXHDR: TNewsEvent;
    fOnCommandDate: TGetEvent;
    fOnCommandListgroup: TNewsEvent;
    fOnCommandTakeThis: TDoByIDEvent;
    fOnCommandCheck: TDoByIDEvent;
    fOnCommandXThread: TNewsEvent;
    fOnCommandXGTitle: TNewsEvent;
    fOnCommandXPat: TNewsEvent;

    fOnCommandOther: TOtherEvent;
    //
    function DoExecute(AThread: TIdPeerThread): boolean; virtual;// override;
  public
//    constructor Create(AOwner: TComponent); override;
//  published
    property OnCommandAuthInfo: TOtherEvent read fOnCommandAuthInfo write
      fOnCommandAuthInfo;
    property OnCommandArticleID: TDoByIDEvent read fOnCommandArticleID write
      fOnCommandArticleID;
    property OnCommandArticleNo: TDoByNoEvent read fOnCommandArticleNo write
      fOnCommandArticleNo;
    property OnCommandBodyID: TDoByIDEvent read fOnCommandBodyID write
      fOnCommandBodyID;
    property OnCommandBodyNo: TDoByNoEvent read fOnCommandBodyNo write
      fOnCommandBodyNo;
    property OnCommandCheck: TDoByIDEvent read fOnCommandCheck write
      fOnCommandCheck;
    property OnCommandHeadID: TDoByIDEvent read fOnCommandHeadID write
      fOnCommandHeadID;
    property OnCommandHeadNo: TDoByNoEvent read fOnCommandHeadNo write
      fOnCommandHeadNo;
    property OnCommandStatID: TDoByIDEvent read fOnCommandStatID write
      fOnCommandStatID;
    property OnCommandStatNo: TDoByNoEvent read fOnCommandStatNo write
      fOnCommandStatNo;
    property OnCommandGroup: TGroupEvent read fOnCommandGroup write
      fOnCommandGroup;
    property OnCommandList: TNewsEvent read fOnCommandList write fOnCommandList;
    property OnCommandHelp: TGetEvent read fOnCommandHelp write fOnCommandHelp;
    property OnCommandIHave: TDoByIDEvent read fOnCommandIHave write
      fOnCommandIHave;
    property OnCommandLast: TGetEvent read fOnCommandLast write fOnCommandLast;
    property OnCommandMode: TNewsEvent read fOnCommandMode write fOnCommandMode;
    property OnCommandNewGroups: TNewsEvent read fOnCommandNewGroups write
      fOnCommandNewGroups;
    property OnCommandNewNews: TNewsEvent read fOnCommandNewNews write
      fOnCommandNewNews;
    property OnCommandNext: TGetEvent read fOnCommandNext write fOnCommandNext;
    property OnCommandPost: TGetEvent read fOnCommandPost write fOnCommandPost;
    property OnCommandQuit: TGetEvent read fOnCommandQuit write fOnCommandQuit;
    property OnCommandSlave: TGetEvent read fOnCommandSlave write
      fOnCommandSlave;
    property OnCommandTakeThis: TDoByIDEvent read fOnCommandTakeThis write
      fOnCommandTakeThis;
    property OnCommandXOver: TNewsEvent read fOnCommandXOver write
      fOnCommandXOver;
    property OnCommandXHDR: TNewsEvent read fOnCommandXHDR write fOnCommandXHDR;
    property OnCommandDate: TGetEvent read fOnCommandDate write fOnCommandDate;
    property OnCommandListgroup: TNewsEvent read fOnCommandListGroup write
      fOnCommandListGroup;
    property OnCommandXThread: TNewsEvent read fOnCommandXThread write
      fOnCommandXThread;
    property OnCommandXGTitle: TNewsEvent read fOnCommandXGTitle write
      fOnCommandXGTitle;
    property OnCommandXPat: TNewsEvent read fOnCommandXPat write fOnCommandXPat;
    property OnCommandOther: TOtherEvent read fOnCommandOther write
      fOnCommandOther;
    property DefaultPort default IdPORT_NNTP;
  end;

PIdNNTPServer=^TIdNNTPServer;
function NewIdNNTPServer(AOwner: PControl):PIdNNTPServer;

implementation

uses {KOL,}
  IdTCPConnection,
  IdResourceStrings,
  SysUtils;

 { constructor TIdNNTPServer.Create(AOwner: TComponent);
 } 
function NewIdNNTPServer (AOwner: PControl):PIdNNTPServer;
begin
  New( Result, Create );
with Result^ do
begin
//  inherited Create(AOwner);
//  DefaultPort := IdPORT_NNTP;
end;
end;

function TIdNNTPServer.DoExecute(AThread: TIdPeerThread): boolean;
var
  i: integer;
  s, sCmd: string;
  WasHandled: Boolean;

  procedure NotHandled(CMD: string);
  begin
    AThread.Connection.Writeln('500 ' + Format(RSNNTPServerNotRecognized,
      [CMD]));
  end;

  function isNumericString(Str: string): Boolean;
  begin
    if Length(str) = 0 then
      Result := False
    else
      Result := IsNumeric(Str[1]);
  end;

begin
  result := true;

  with AThread.Connection do
  begin
    while Connected do
    begin
      try
        s := ReadLn;
      except
        exit;
      end;

      sCmd := Fetch(s, ' ');
      i := Succ(PosInStrArray(UpperCase(sCmd), KnownCommands));
      case i of
        1: {article}
          if isNumericString(s) then
          begin
            if Assigned(OnCommandArticleNo) then
              OnCommandArticleNo(AThread, StrToCard(S))
            else
              NotHandled(sCmd);
          end
          else
          begin
            if Assigned(OnCommandArticleID) then
              OnCommandArticleID(AThread, S)
            else
              NotHandled(sCmd);
          end;
        2: {body}
          if isNumericString(s) then
          begin
            if assigned(OnCommandBodyNo) then
              OnCommandBodyNo(AThread, StrToCard(S))
            else
              NotHandled(sCmd);
          end
          else
          begin
            if assigned(OnCommandBodyID) then
              OnCommandBodyID(AThread, S)
            else
              NotHandled(sCmd);
          end;
        3: {head}
          if isNumericString(s) then
          begin
            if assigned(OnCommandHeadNo) then
              OnCommandHeadNo(AThread, StrToCard(S))
            else
              NotHandled(sCmd);
          end
          else
          begin
            if assigned(OnCommandHeadID) then
              OnCommandHeadID(AThread, S)
            else
              NotHandled(sCmd);
          end;
        4: {stat}
          if isNumericString(s) then
          begin
            if assigned(OnCommandStatNo) then
              OnCommandStatNo(AThread, StrToCard(S))
            else
              NotHandled(sCmd);
          end
          else
          begin
            if assigned(OnCommandStatID) then
              OnCommandStatID(AThread, S)
            else
              NotHandled(sCmd);
          end;
        5: {group}
          if assigned(OnCommandGroup) then
            OnCommandGroup(AThread, S)
          else
            NotHandled(sCmd);
        6: {list}
          if assigned(OnCommandList) then
            OnCommandList(AThread, S)
          else
            NotHandled(sCmd);
        7: {help}
          if assigned(OnCommandHelp) then
            OnCommandHelp(AThread)
          else
            NotHandled(sCmd);
        8: {ihave}
          if assigned(OnCommandIHave) then
            OnCommandIHave(AThread, S)
          else
            NotHandled(sCmd);
        9: {last}
          if assigned(OnCommandLast) then
            OnCommandLast(AThread)
          else
            NotHandled(sCmd);
        10: {newgroups}
          if assigned(OnCommandNewGroups) then
            OnCommandNewGroups(AThread, S)
          else
            NotHandled(sCmd);
        11: {newsgroups}
          if assigned(OnCommandNewNews) then
            OnCommandNewNews(AThread, S)
          else
            NotHandled(sCmd);
        12: {next}
          if assigned(OnCommandNext) then
            OnCommandNext(AThread)
          else
            NotHandled(sCmd);
        13: {post}
          if assigned(OnCommandPost) then
            OnCommandPost(AThread)
          else
            NotHandled(sCmd);
        14: {quit}
          begin
            if assigned(OnCommandQuit) then
              OnCommandQuit(AThread)
            else
              AThread.Connection.WriteLn('205 ' + RSNNTPServerGoodBye);
            AThread.Connection.Disconnect;
          end;
        15: {slave}
          if assigned(OnCommandSlave) then
            OnCommandSlave(AThread)
          else
            NotHandled(sCmd);
        16: {authinfo}
          if assigned(OnCommandAuthInfo) then
          begin
            sCmd := UpperCase(Fetch(s, ' '));
            WasHandled := False;
            OnCommandAuthInfo(AThread, SCmd, S, WasHandled);
            if not WasHandled then NotHandled(sCmd);
          end
          else
            NotHandled(sCmd);
        17: {xover}
          if assigned(OnCommandXOver) then
            OnCommandXOver(AThread, S)
          else
            NotHandled(sCmd);
        18: {xhdr}
          if assigned(OnCommandXHDR) then
            OnCommandXHDR(AThread, S)
          else
            NotHandled(sCmd);
        19: {date}
          if assigned(OnCommandDate) then
            OnCommandDate(AThread)
          else
            NotHandled(sCmd);
        20: {listgroup}
          if assigned(OnCommandListGroup) then
            OnCommandListGroup(AThread, S)
          else
            NotHandled(sCmd);
        21: {mode}
          if assigned(OnCommandMode) then
            OnCommandMode(AThread, S)
          else
            NotHandled(sCmd);
        22: {takethis}
          if assigned(OnCommandTakeThis) then
            OnCommandTakeThis(AThread, S)
          else
            NotHandled(sCmd);
        23: {check}
          if assigned(OnCommandCheck) then
            OnCommandCheck(AThread, S)
          else
            NotHandled(sCmd);
        24: {XThread}
          if assigned(OnCommandXThread) then
            OnCommandXThread(AThread, S)
          else
            NotHandled(sCmd);
        25: {XGTitle}
          if assigned(OnCommandXGTitle) then
            OnCommandXGTitle(AThread, S)
          else
            NotHandled(sCmd);
      else
        begin
          if assigned(OnCommandOther) then
          begin
            WasHandled := False;
            OnCommandOther(AThread, sCmd, S, WasHandled);
            if not WasHandled then NotHandled(sCmd);
          end
          else
            NotHandled(sCmd);
        end;
      end;
    end;
  end;
end;

end.
