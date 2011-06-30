// 29-nov-2002
unit IdNNTP;

interface

uses KOL { , 
  Classes } ,
  {IdException,}
  IdGlobal,
  IdTCPConnection,
  IdMessage,
  IdMessageClient;

type
  TModeType = (mtStream, mtIHAVE, mtReader);

  TConnectionResult = (crCanPost, crNoPost, crAuthRequired, crTempUnavailable);
  TModeSetResult = (mrCanStream, mrNoStream, mrCanIHAVE, mrNoIHAVE, mrCanPost,
    mrNoPost);

  TEventStreaming = procedure(const AMesgID: string; var AAccepted: Boolean) of
    object;
  TNewsTransportEvent = procedure(AMsg: PStrList) of object;
  TEventNewsgroupList = procedure(const ANewsgroup: string; const ALow, AHigh:
    Cardinal;
    const AType: string; var ACanContinue: Boolean) of object;

  TEventNewNewsList = procedure(const AMsgID: string; var ACanContinue: Boolean)
    of object;

  TIdNNTP = object(TIdMessageClient)
  protected
    FlMsgHigh,
      FlMsgLow,
      FlMsgNo: Cardinal;
    FsMsgID: string;
    FlMsgCount: Cardinal;
    FNewsAgent: string;
    FOnNewsgroupList,
      FOnNewGroupsList: TEventNewsgroupList;
    FOnNewNewsList: TEventNewNewsList;
    fOnSendCheck: TNewsTransportEvent;
    fOnSendTakethis: TNewsTransportEvent;
    fModeType: TModeType;
    fConectionResult: TConnectionResult;
    fModeResult: TModeSetResult;
    fOnSendIHAVE: TNewsTransportEvent;
    FbSetMode: Boolean;
    fPassword: string;
    fUserId: string;

    function ConvertDateTimeDist(ADate: TDateTime; AGMT: boolean;
      const ADistributions: string): string;
    procedure SetModeType(const AValue: TModeType);
    procedure setConnectionResult(const AValue: TConnectionResult);
    procedure SetModeResult(const AValue: TModeSetResult);
    function Get(const ACmd: string; const AMsgNo: Cardinal; const AMsgID:
      string;
      AMsg: TIDMessage): Boolean;
    function SetArticle(const ACmd: string; const AMsgNo: Cardinal; const
      AMsgID: string): Boolean;
    procedure ProcessGroupList(const ACmd: string; const AResponse: integer;
      const AListEvent: TEventNewsgroupList);
  public
//    constructor Create(AOwner: TComponent); override;
    procedure Connect; virtual;//override;
    procedure Disconnect; virtual;//override;
    function GetArticle(const AMsgNo: Cardinal; const AMsgID: string; AMsg:
      TIdMessage): Boolean;
    function GetBody(const AMsgNo: Cardinal; const AMsgID: string; AMsg:
      TIdMessage): Boolean;
    function GetHeader(const AMsgNo: Cardinal; const AMsgID: string; AMsg:
      TIdMessage): Boolean;
    procedure GetNewsgroupList; overload;
    procedure GetNewsgroupList(AList: PStrList); overload;
    procedure GetNewGroupsList(const ADate: TDateTime; const AGMT: boolean;
      const ADistributions: string); overload;
    procedure GetNewGroupsList(const ADate: TDateTime; const AGMT: boolean;
      const ADistributions: string; AList: PStrList); overload;
    procedure GetNewNewsList(const ANewsgroups: string;
      const ADate: TDateTime; const AGMT: boolean; ADistributions: string);
        overload;
    procedure GetNewNewsList(const ANewsgroups: string; const ADate: TDateTime;
      const AGMT: boolean; ADistributions: string; AList: PStrList); overload;
    procedure GetOverviewFMT(var AResponse: PStrList);
    function Next: Boolean;
    function Previous: Boolean;
    function SelectArticle(const AMsgNo: Cardinal): Boolean;
    procedure SelectGroup(const AGroup: string);
    procedure Send(AMsg: TidMessage);
    procedure SendIHAVE(AMsg: PStrList);
    procedure SendCheck(AMsgID: PStrList; var AResponses: PStrList);
    function SendCmd(const AOut: string; const AResponse: array of SmallInt):
      SmallInt;virtual;// override;
    function SendTakeThis(AMsg: PStrList): string;
    procedure SendXHDR(const AHeader: string; const AParam: string; var
      AResponse: PStrList);
    procedure SendXOVER(const AParm: string; var AResponse: PStrList);

    property MsgID: string read fsMsgID;
    property MsgNo: Cardinal read FlMsgNo;
    property MsgHigh: Cardinal read FlMsgHigh;
    property MsgLow: Cardinal read FlMsgLow;
    property GreetingResult: TConnectionResult read fConectionResult write
      setConnectionResult;
    property ModeResult: TModeSetResult read fModeResult write SetModeResult;
    property MsgCount: Cardinal read flMsgCount write flMsgCount;
//  published
    property NewsAgent: string read FNewsAgent write FNewsAgent;
    property Mode: TModeType read fModeType write SetModeType default mtReader;
    property Password: string read fPassword write fPassword;
    property UserId: string read fUserId write fUserId;
    property SetMode: Boolean read FbSetMode write FbSetMode default True;

    property OnSendCheck: TNewsTransportEvent read fOnSendCheck
    write fOnSendCheck;
    property OnSendIHAVE: TNewsTransportEvent read fOnSendIHAVE
    write fOnSendIHAVE;
    property OnSendTakeThis: TNewsTransportEvent read fOnSendTakethis
    write fOnSendTakethis;
    property OnNewsgroupList: TEventNewsgroupList read FOnNewsgroupList
    write FOnNewsgroupList;
    property OnNewGroupsList: TEventNewsGroupList read FOnNewGroupsList
    write FOnNewGroupsList;
    property OnNewNewsList: TEventNewNewsList read FOnNewNewsList
    write FOnNewNewsList;
    property Port default IdPORT_NNTP;
  end;

PIdNNTP=^TIdNNTP;
function NewIdNNTP(AOwner: PControl):PIdNNTP;

{type
  EIdNNTPException = object(EIdException);
PIdNNTPException=^EIdNNTPException; type  MyStupid0=DWord;
  EIdNNTPNoOnNewGroupsList = object(EIdNNTPException);
PdNNTPException=^IdNNTPException; type  MyStupid3137=DWord;
  EIdNNTPNoOnNewNewsList = object(EIdNNTPException);
PNNTPException=^dNNTPException; type  MyStupid86104=DWord;
  EIdNNTPNoOnNewsgroupList = object(EIdNNTPException);
PNTPException=^NNTPException; type  MyStupid20258=DWord;
  EIdNNTPStringListNotInitialized = object(EIdNNTPException);
PTPException=^NTPException; type  MyStupid27292=DWord;

  EIdNNTPConnectionRefused = object(EIdProtocolReplyError);
PPException=^TPException; type  MyStupid67165=DWord;}

procedure ParseXOVER(Aline: string; var AArticleIndex: Cardinal;
  var ASubject,
  AFrom: string;
  var ADate: TDateTime;
  var AMsgId,
  AReferences: string;
  var AByteCount,
  ALineCount: Cardinal;
  var AExtraData: string);

procedure ParseNewsGroup(ALine: string; var ANewsGroup: string;
  var AHi, ALo: Cardinal;
  var AStatus: string);

implementation

uses {KOL,}
  IdComponent,
  IdResourceStrings,
  SysUtils;

procedure ParseXOVER(Aline: string; var AArticleIndex: Cardinal;
  var ASubject,
  AFrom: string;
  var ADate: TDateTime;
  var AMsgId,
  AReferences: string;
  var AByteCount,
  ALineCount: Cardinal;
  var AExtraData: string);

begin
  ALine := StringReplace(ALine, #9#8#9, #9, [rfReplaceAll]);
  AArticleIndex := StrToCard(Fetch(ALine, #9));
  ASubject := Fetch(ALine, #9);
  AFrom := Fetch(ALine, #9);
  ADate := StrInternetToDateTime(Fetch(Aline, #9));
  AMsgId := Fetch(Aline, #9);
  AReferences := Fetch(ALine, #9);
  AByteCount := StrToCard(Fetch(ALine, #9));
  ALineCount := StrToCard(Fetch(ALine, #9));
  AExtraData := ALine;
end;

procedure ParseNewsGroup(ALine: string; var ANewsGroup: string;
  var AHi, ALo: Cardinal;
  var AStatus: string);
begin
  ANewsgroup := Fetch(ALine, ' ');
  AHi := StrToCard(Fetch(Aline, ' '));
  ALo := StrToCard(Fetch(ALine, ' '));
  AStatus := ALine;
end;

 { constructor TIdNNTP.Create(AOwner: TComponent);
 } 
function NewIdNNTP (AOwner: PControl):PIdNNTP;
begin
New( Result, Create );
with Result^ do
begin
//  inherited Create(AOwner);

  Mode := mtReader;
//  Port := IdPORT_NNTP;
  SetMode := True;
end;  
end;

function TIdNNTP.SendCmd(const AOut: string; const AResponse: array of
  SmallInt): SmallInt;
begin
  Result := inherited SendCmd(AOut, []);
  if (Result = 480) or (Result = 450) then
  begin
    inherited SendCmd('AuthInfo User ' + UserID, [381]);
    inherited SendCmd('AuthInfo Pass ' + Password, [281]);
    Result := inherited SendCmd(AOut, AResponse);
  end
  else
  begin
    Result := CheckResponse(Result, AResponse);
  end;
end;

procedure TIdNNTP.Connect;
begin
  inherited;
  try
    GetResponse([]);
    case ResultNo of
      200: GreetingResult := crCanPost;
      201: GreetingResult := crNoPost;
      400: GreetingResult := crTempUnavailable;
//      502: raise EIdNNTPConnectionRefused.CreateError(502,
//        RSNNTPConnectionRefused);
    end;
    case mode of
      mtStream:
        begin
//          SendCmd('mode stream');
          if ResultNo <> 203 then
            ModeResult := mrNoStream
          else
            ModeResult := mrCanStream;
        end;
      mtReader:
        begin
//          SendCmd('mode reader');
          if ResultNo <> 200 then
            ModeResult := mrNoPost
          else
            ModeResult := mrCanPost;
        end;
    end;
  except
    Disconnect;
    raise;
  end;
end;

procedure TIdNNTP.Disconnect;
begin
  try
    if Connected then
      WriteLn('Quit');
  finally
    inherited;
  end;
end;

procedure TIdNNTP.GetOverviewFMT(var AResponse: PStrList);
begin
//  SendCmd('list overview.fmt', 215);
//  Capture(AResponse);
end;

procedure TIdNNTP.SendXOVER(const AParm: string; var AResponse: PStrList);
begin
//  SendCmd('xover ' + AParm, 224);
//  Capture(AResponse);
end;

procedure TIdNNTP.SendXHDR(const AHeader: string; const AParam: string; var
  AResponse: PStrList);
begin
//  SendCmd('XHDR ' + AHeader + ' ' + AParam, 221);
//  Capture(AResponse);
end;

procedure TIdNNTP.SelectGroup(const AGroup: string);
var
  s: string;
begin
  SendCmd('Group ' + AGroup, [211]);
  s := Copy(CmdResult, 5, Maxint);
  FlMsgCount := StrToCard(Fetch(s));
  FlMsgLow := StrToCard(Fetch(s));
  FlMsgHigh := StrToCard(Fetch(s));
end;

function TIdNNTP.Get(const ACmd: string; const AMsgNo: Cardinal; const AMsgID:
  string;
  AMsg: TidMessage): Boolean;
begin
  Result := SetArticle(ACmd, AMsgNo, AMsgID);
  if Result then
  begin
    AMsg.Clear;
    if AnsiSameText(ACmd, 'HEAD') then
    begin
      if ResultNo in [220, 221] then
      begin
        ReceiveHeader(AMsg, '.');
      end;
    end
    else
    begin
      if ResultNo in [220, 221] then
      begin
        ReceiveHeader(AMsg, '');
      end;
      if ResultNo in [220, 222] then
        ReceiveBody(AMsg);
    end;
  end;
end;

procedure TIdNNTP.SendIHAVE(AMsg: PStrList);
var
  i: Integer;
//  MsgID: string;
  Temp: string;
begin
{  if not Assigned(FOnSendIHAVE) then
  begin
    for i := 0 to AMsg.Count - 1 do
      if IndyPos('Message-ID', AMsg.Strings[i]) > 0 then
      begin
        MsgID := AMsg.Strings[i];
        Temp := Fetch(MsgID, ':');
        Break;
      end;
    SendCmd('IHAVE ' + MsgID, 335);
    for i := 0 to AMsg.Count - 1 do
      WriteLn(AMsg[i]);
    WriteLn('.');
    Temp := Readln;
  end;}
end;

procedure TIdNNTP.SendCheck(AMsgID: PStrList;
  var AResponses: PStrList);
var
  i: Integer;
begin
  if not Assigned(FOnSendCheck) then
  begin
//    for i := 0 to AMsgID.Count - 1 do
//      Writeln('CHECK ' + AMsgID.Strings[i]);
    for i := 0 to AMsgID.Count - 1 do
    begin
{      if assigned(AResponses) then
        AResponses.Add(ReadLn)
      else
        raise
          EIdNNTPStringListNotInitialized.Create(RSNNTPStringListNotInitialized);}
    end;
  end;
end;

function TIdNNTP.SendTakeThis(AMsg: PStrList): string;
var
  i: Integer;
//  MsgID: string;
  Temp: string;
begin
{  if not Assigned(FOnSendTakeThis) then
  begin
    if (Setmode) and (ModeResult = mrNoStream) then
    begin
      Mode := mtIHAVE;
      SendIHAVE(AMsg);
      Exit;
    end;
    for i := 0 to AMsg.Count - 1 do
      if IndyPos('Message-ID', AMsg.Strings[i]) > 0 then
      begin
        MsgID := AMsg.Strings[i];
        Temp := Fetch(MsgID, ':');
        Break;
      end;
    try
      Writeln('TAKETHIS ' + MsgID);
      for i := 0 to AMsg.Count - 1 do
        WriteLn(AMsg[i]);
      WriteLn('.');
    finally
      Result := Readln;
    end;
  end;}
end;

procedure TIdNNTP.Send(AMsg: TidMessage);
begin
{  SendCmd('Post', 340);
  //Header
  with AMsg.ExtraHeaders do
  begin
    Values['Lines'] := IntToStr(AMsg.Body.Count);
    Values['X-Newsreader'] := NewsAgent;
  end;
  SendMsg(AMsg);
  inherited;
  SendCmd('.', 240);}
end;

procedure TIdNNTP.ProcessGroupList(const ACmd: string; const AResponse: integer;
  const AListEvent: TEventNewsgroupList);
var
  s1, sNewsgroup: string;
  lLo, lHi: Cardinal;
  sStatus: string;
  CanContinue: Boolean;
begin
{  BeginWork(wmRead, 0);
  try
    SendCmd(ACmd, AResponse);
    s1 := ReadLn;
    CanContinue := True;
    while (s1 <> '.') and CanContinue do
    begin
      ParseNewsGroup(s1, sNewsgroup, lHi, lLo, sStatus);
      AListEvent(sNewsgroup, lLo, lHi, sStatus, CanContinue);
      s1 := ReadLn;
    end;
  finally
    EndWork(wmRead);
  end;}
end;

procedure TIdNNTP.GetNewsgroupList;
begin
{  if not Assigned(FOnNewsgroupList) then
    raise EIdNNTPNoOnNewsgroupList.Create(RSNNTPNoOnNewsgroupList);

  ProcessGroupList('List', 215, FOnNewsgroupList);}
end;

procedure TIdNNTP.GetNewGroupsList(const ADate: TDateTime; const AGMT: boolean;
  const ADistributions: string);
begin
  if not Assigned(FOnNewGroupsList) then
  begin
//    raise EIdNNTPNoOnNewGroupsList.Create(RSNNTPNoOnNewGroupsList);
  end;
  ProcessGroupList('Newgroups ' + ConvertDateTimeDist(ADate, AGMT,
    ADistributions), 231
    , FOnNewGroupsList);
end;

procedure TIdNNTP.GetNewNewsList(const ANewsgroups: string;
  const ADate: TDateTime; const AGMT: boolean; ADistributions: string);
var
  s1: string;
  CanContinue: Boolean;
begin
//  if not Assigned(FOnNewNewsList) then
//    raise EIdNNTPNoOnNewNewsList.Create(RSNNTPNoOnNewNewsList);

  BeginWork(wmRead, 0);
  try
//    SendCmd('Newnews ' + ANewsgroups + ' ' + ConvertDateTimeDist(ADate, AGMT,
//      ADistributions), 230);
    s1 := ReadLn;
    CanContinue := True;
    while (s1 <> '.') and CanContinue do
    begin
      FOnNewNewsList(s1, CanContinue);
      s1 := ReadLn;
    end;
  finally
    EndWork(wmRead);
  end;
end;

function TIdNNTP.GetArticle(const AMsgNo: Cardinal; const AMsgID: string;
  AMsg: TidMessage): Boolean;
begin
  Result := Get('Article', AMsgNo, AMsgID, AMsg);
end;

function TIdNNTP.GetBody(const AMsgNo: Cardinal; const AMsgID: string;
  AMsg: TidMessage): Boolean;
begin
  Result := Get('Body', AMsgNo, AMsgID, AMsg);
end;

function TIdNNTP.GetHeader(const AMsgNo: Cardinal; const AMsgID: string;
  AMsg: TidMessage): Boolean;
begin
  Result := Get('Head', AMsgNo, AMsgID, AMsg);
end;

function TIdNNTP.Next: Boolean;
begin
  Result := SetArticle('Next', 0, '');
end;

function TIdNNTP.Previous: Boolean;
begin
  Result := SetArticle('Last', 0, '');
end;

function TIdNNTP.SelectArticle(const AMsgNo: Cardinal): Boolean;
begin
  Result := SetArticle('Stat', AMsgNo, '');
end;

function TIdNNTP.SetArticle(const ACmd: string; const AMsgNo: Cardinal;
  const AMsgID: string): Boolean;
var
  s: string;
begin
{  if AMsgNo >= 1 then
    SendCmd(ACmd + ' ' + IntToStr(AMsgNo))
  else
    if AMsgID <> '' then
    SendCmd(ACmd + ' <' + AMsgID + '>')
  else
    SendCmd(ACmd);

  if ResultNo in [220, 221, 222, 223] then
  begin
    if AMsgID = '' then
    begin
      s := CmdResult;
      Fetch(s, ' ');
      flMsgNo := StrToCard(Fetch(s, ' '));
      fsMsgID := s;
    end;
    Result := True;
  end
  else
    if (ResultNo = 421) or (ResultNo = 422)
    or (ResultNo = 423) or (ResultNo = 430) then
  begin
    Result := False;
  end
  else
  begin
    raise EidResponseError.Create(CmdResult);
  end;}
end;

procedure TIdNNTP.SetModeType(const AValue: TModeType);
begin
  fModeType := AValue;
end;

procedure TIdNNTP.setConnectionResult(const AValue: TConnectionResult);
begin
  fConectionResult := AValue;
end;

procedure TIdNNTP.SetModeResult(const AValue: TModeSetResult);
begin
  fModeResult := AValue;
end;

procedure TIdNNTP.GetNewsgroupList(AList: PStrList);
begin
//  SendCmd('List', 215);
//  Capture(AList);
end;

procedure TIdNNTP.GetNewGroupsList(const ADate: TDateTime; const AGMT: boolean;
  const ADistributions: string; AList: PStrList);
begin
//  SendCmd('Newgroups ' + ConvertDateTimeDist(ADate, AGMT, ADistributions), 231);
//  Capture(AList);
end;

procedure TIdNNTP.GetNewNewsList(const ANewsgroups: string; const ADate:
  TDateTime;
  const AGMT: boolean; ADistributions: string; AList: PStrList);
begin
//  SendCmd('Newnews ' + ANewsgroups + ' ' + ConvertDateTimeDist(ADate, AGMT,
//    ADistributions), 230);
//  Capture(AList);
end;

function TIdNNTP.ConvertDateTimeDist(ADate: TDateTime; AGMT: boolean;
  const ADistributions: string): string;
begin
  Result := FormatDateTime('yymmdd hhnnss', ADate);
  if AGMT then
  begin
    Result := Result + ' GMT';
  end;
  if Length(ADistributions) > 0 then
  begin
    Result := ' <' + ADistributions + '>';
  end;
end;

end.
