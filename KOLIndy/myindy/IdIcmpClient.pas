// 26-nov-2002
// 8-dec-2002
unit IdIcmpClient;

interface

uses KOL { ,
  Classes },
  IdGlobal,
  IdRawBase,
  IdRawClient,
  IdStack,
  IdStackConsts;

const
  DEF_PACKET_SIZE = 32;
  MAX_PACKET_SIZE = 1024;
  ICMP_MIN = 8;

const
  iDEFAULTPACKETSIZE = 128;
  iDEFAULTREPLYBUFSIZE = 1024;

const
  Id_TIDICMP_ReceiveTimeout = 5000;
type
  TReplyStatusTypes = (rsEcho, rsError, rsTimeOut, rsErrorUnreachable,
    rsErrorTTLExceeded);

  TReplyStatus = record
    BytesReceived: integer;
    FromIpAddress: string;
    MsgType: byte;
    SequenceId: word;
    MsRoundTripTime: longword;
    TimeToLive: byte;
    ReplyStatusType: TReplyStatusTypes;
  end;

  TCharBuf = array[1..MAX_PACKET_SIZE] of char;
  TICMPDataBuffer = array[1..iDEFAULTPACKETSIZE] of byte;

  TOnReplyEvent = procedure(ASender: PControl; const AReplyStatus:
    TReplyStatus) of object;

  TIdIcmpClient = object(TIdRawClient)
  protected
    bufReceive: TCharBuf;
    bufIcmp: TCharBuf;
    wSeqNo: word;
    iDataSize: integer;
    FReplyStatus: TReplyStatus;
    FOnReply: TOnReplyEvent;

    function CalcCheckSum: word;
    procedure DecodeResponse(BytesRead: integer; var AReplyStatus:
      TReplyStatus);
    procedure DoReply(const AReplyStatus: TReplyStatus);
    procedure GetEchoReply;
    procedure PrepareEchoRequest;
    procedure SendEchoRequest;
  public
    { constructor Create(AOwner: TComponent); override;
    }
    procedure Init; virtual;
    procedure Ping;
    function Receive(ATimeOut: Integer): TReplyStatus;

    property ReplyStatus: TReplyStatus read FReplyStatus;
    { published }
 //    property ReceiveTimeout default Id_TIDICMP_ReceiveTimeout;
 //    property Host;
 //    property Port;
 //    property Protocol default Id_IPPROTO_ICMP;
    property OnReply: TOnReplyEvent read FOnReply write FOnReply;
  end;
  PIdIcmpClient = ^TIdIcmpClient;
function NewIdIcmpClient(AOwner: PControl): PIdIcmpClient;

implementation

uses
  {  IdException
    ,} IdResourceStrings, IdRawHeaders;

//constructor TIdIcmpClient.Create(AOwner: TComponent);

function NewIdIcmpClient(AOwner: PControl): PIdIcmpClient;
begin
  //  inherited;
  New(Result, Create);
  Result.Init;
//  with Result^ do
//  begin
//    FProtocol := Id_IPPROTO_ICMP;
//    wSeqNo := 0;
//    FReceiveTimeOut := Id_TIDICMP_ReceiveTimeout;
//  end;
end;

procedure TIdIcmpClient.Init;
begin
  inherited;
  FProtocol := Id_IPPROTO_ICMP;
  wSeqNo := 0;
  FReceiveTimeOut := Id_TIDICMP_ReceiveTimeout;
end;

function TIdIcmpClient.CalcCheckSum: word;
type
  PWordArray = ^TWordArray;
  TWordArray = array[1..512] of word;
var
  pwa: PWordarray;
  dwChecksum: longword;
  i, icWords, iRemainder: integer;
begin
  icWords := iDataSize div 2;
  iRemainder := iDatasize mod 2;
  pwa := PWordArray(@bufIcmp);
  dwChecksum := 0;
  for i := 1 to icWords do
  begin
    dwChecksum := dwChecksum + pwa^[i];
  end;
  if (iRemainder <> 0) then
  begin
    dwChecksum := dwChecksum + byte(bufIcmp[iDataSize]);
  end;
  dwCheckSum := (dwCheckSum shr 16) + (dwCheckSum and $FFFF);
  dwCheckSum := dwCheckSum + (dwCheckSum shr 16);
  Result := word(not dwChecksum);
end;

procedure TIdIcmpClient.PrepareEchoRequest;
var
  pih: PIdIcmpHdr;
  i: integer;
begin
  iDataSize := DEF_PACKET_SIZE + sizeof(TIdIcmpHdr);
  FillChar(bufIcmp, sizeof(bufIcmp), 0);
  pih := PIdIcmpHdr(@bufIcmp);
  with pih^ do
  begin
    icmp_type := Id_ICMP_ECHO;
    icmp_code := 0;
    icmp_hun.echo.id := word(CurrentProcessId);
    icmp_hun.echo.seq := wSeqNo;
    icmp_dun.ts.otime := GetTickcount;
    i := Succ(sizeof(TIdIcmpHdr));
    while (i <= iDataSize) do
    begin
      bufIcmp[i] := 'E';
      Inc(i);
    end;
    icmp_sum := CalcCheckSum;
  end;
  Inc(wSeqNo);
end;

procedure TIdIcmpClient.SendEchoRequest;
begin
  Send(Host, Port, bufIcmp, iDataSize);
end;

procedure TIdIcmpClient.DecodeResponse(BytesRead: integer; var AReplyStatus:
  TReplyStatus);
var
  pip: PIdIPHdr;
  picmp: PIdICMPHdr;
  iIpHeaderLen: integer;
begin
  if BytesRead = 0 then
  begin

    AReplyStatus.BytesReceived := 0;
    AReplyStatus.FromIpAddress := '0.0.0.0';
    AReplyStatus.MsgType := 0;
    AReplyStatus.SequenceId := wSeqNo;
    AReplyStatus.TimeToLive := 0;
    AReplyStatus.ReplyStatusType := rsTimeOut;
  end
  else
  begin
    AReplyStatus.ReplyStatusType := rsError;
    pip := PIdIPHdr(@bufReceive);
    iIpHeaderLen := (pip^.ip_verlen and $0F) * 4;
    if (BytesRead < iIpHeaderLen + ICMP_MIN) then
    begin
      //      raise EIdIcmpException.Create(RSICMPNotEnoughtBytes);
    end;

    picmp := PIdICMPHdr(@bufReceive[iIpHeaderLen + 1]);
{$IFDEF LINUX}

{$ENDIF}
    case picmp^.icmp_type of
      Id_ICMP_ECHOREPLY, Id_ICMP_ECHO:
        AReplyStatus.ReplyStatusType := rsEcho;
      Id_ICMP_UNREACH:
        AReplyStatus.ReplyStatusType := rsErrorUnreachable;
      Id_ICMP_TIMXCEED:
        AReplyStatus.ReplyStatusType := rsErrorTTLExceeded;
    else
      //      raise EIdICMPException.Create(RSICMPNonEchoResponse);
    end;

    with AReplyStatus do
    begin
      BytesReceived := BytesRead;
      FromIpAddress := GStack.TInAddrToString(pip^.ip_src);
      MsgType := picmp^.icmp_type;
      SequenceId := picmp^.icmp_hun.echo.seq;
      MsRoundTripTime := GetTickCount - picmp^.icmp_dun.ts.otime;
      TimeToLive := pip^.ip_ttl;
    end;
  end;
  DoReply(AReplyStatus);
end;

procedure TIdIcmpClient.GetEchoReply;
begin
  FReplyStatus := Receive(FReceiveTimeout);
end;

procedure TIdIcmpClient.Ping;
begin
  PrepareEchoRequest;
  SendEchoRequest;
  GetEchoReply;
  Binding.CloseSocket;
end;

function TIdIcmpClient.Receive(ATimeOut: Integer): TReplyStatus;
var
  BytesRead: Integer;
  Size: Integer;
begin
  FillChar(bufReceive, sizeOf(bufReceive), 0);
  Size := sizeof(bufReceive);
  BytesRead := ReceiveBuffer(bufReceive, Size);
  GStack.CheckForSocketError(BytesRead);
  DecodeResponse(BytesRead, Result);
end;

procedure TIdIcmpClient.DoReply(const AReplyStatus: TReplyStatus);
begin
  if Assigned(FOnReply) then
  begin
    FOnReply(@Self, AReplyStatus);
  end;
end;

end.

