// 29-nov-2002
unit IdDNSResolver;

interface

uses KOL { , 
  Classes } ,KOLClasses,
  IdResourceStrings,
  SysUtils,
  IdGlobal,
  IdUDPClient;

const
  IdDNSResolver_ReceiveTimeout = 4000;

const
  //fBitCode Bits and Masks
  cQRBit = $8000; //QR when 0 = Question when 1 Response
  cQRMask = $EFFF;
  cOpCodeBits = $7800; //Operation Code See Constansts Defined Below
  cOpCodeMask = $87FF;
  cAABit = $0400; //Valid in Responses Authoritative Answer if set (1)
  cAAMask = $FBFF;
  cTCBit = $0200; //Truncation Bit if Set Messages was truncated for length
  cTCMask = $FDFF;
  cRDBit = $0100; //If set(1) Recursive Search is Resquested by Query
  cRDMask = $FEFF;
  cRABit = $0080; //If set(1) Server supports Recursive Search (Available)
  cRAMask = $FF7F;
  cRCodeBits = $000F; //Response Code. See Constansts Defined Below
  cRCodeMask = $FFF0;

   //Question Operation Code Values
  cResQuery = 0;
  cResIQuery = 1;
  cResStatus = 2;
  cOPCodeStrs: array[cResQuery..cResStatus] of string[7] =
  ('Query',
    'IQuery',
    'Status');

  // QType Identifes the type of Question
  cA = 1; // a Host Address
  cNS = 2; // An Authoritative name server
  cMD = 3; // A mail destination obsolete use MX (OBSOLETE)
  cMF = 4; // A mail forwarder obsolete use MX   (OBSOLETE)
  cName = 5; // The canonical name for an alias
  cSOA = 6; // Marks the start of a zone of authority
  cMB = 7; // A mail box domain name (Experimental)
  cMG = 8; // A mail group member (Experimental)
  cMR = 9; // A mail Rename Domain Name (Experimental)
  cNULL = 10; // RR (Experimental)
  cWKS = 11; // A well known service description
  cPTR = 12; // A Domain Name Pointer;
  cHINFO = 13; // Host Information;
  cMINFO = 14; // Mailbox or Mail List Information;
  cMX = 15; // Mail Exchange
  cTXT = 16; // Text String;
  cAXFR = 252; // A Request for the Transfer of an entire zone;
  cMAILB = 253; // A request for mailbox related records (MB MG OR MR}
  cMAILA = 254; // A request for mail agent RRs (Obsolete see MX)
  cStar = 255; // A Request for all Records

  //QClass
  cIN = 1; //The Internet
  cCS = 2; // the CSNet Obsolete
  cCH = 3; // The Chaos Claee
  cHS = 4; // Hesiod [Dyer 87]

  //CStar any Class is same as QType for all records;
  cQClassStr: array[cIN..CHs] of string[3] =
  ('IN', 'CS', 'CH', 'HS');

  //Sever Response codes (RCode)
  cRCodeNoError = 0;
  cRCodeFormatErr = 1;
  cRCodeServerErr = 2;
  cRCodeNameErr = 3;
  cRCodeNotImplemented = 4;
  cRCodeRefused = 5;

  cRCodeStrs: array[cRCodeNoError..cRCodeRefused] of string =
  (RSCodeNoError,
    RSCodeQueryFormat,
    RSCodeQueryServer,
    RSCodeQueryName,
    RSCodeQueryNotImplemented,
    RSCodeQueryQueryRefused);

type
  TWKSBits = array[0..7] of byte;

  TRequestedRecord = cA..cStar;

  TRequestedRecords = set of TRequestedRecord;

  TIdDNSHeader = object(TObj)
  protected
    FAnCount: Word;
    FArCount: Word;
    FBitCode: Word;
    FId: Word;
    FQdCount: Word;
    FNsCount: Word;
    function GetAA: Boolean;
    function GetOpCode: Word;
    function GetQr: Boolean;
    function GetRA: Boolean;
    function GetRCode: Word;
    function GetRD: Boolean;
    function GetTC: Boolean;
    procedure InitializefId;
    procedure SetAA(AuthAnswer: Boolean);
//    procedure SetOpCode(OpCode: Word);
    procedure SetQr(IsResponse: Boolean);
    procedure SetRA(RecursionAvailable: Boolean);
//    procedure SetRCode(RCode: Word);
    procedure SetRD(RecursionDesired: Boolean);
    procedure SetTC(IsTruncated: Boolean);
  public
     { constructor Create;
     } procedure InitVars; virtual;
    //
    property AA: boolean read GetAA write SetAA;
    property ANCount: Word read FAnCount write FAnCount;
    property ARCount: Word read FArCount write FArCount;
    property ID: Word read FId write FId;
    property NSCount: Word read FNsCount write FNsCount;
//    property Opcode: Word read GetOpCode write SetOpCode;
    property QDCount: Word read FQdCount write FQdCount;
    property Qr: Boolean read GetQr write SetQr;
    property RA: Boolean read GetRA write SetRA;
//    property RCode: Word read GetRCode write SetRCode;
    property RD: Boolean read GetRD write SetRD;
    property TC: Boolean read GetTC write SetTC;
  end;
PIdDNSHeader=^TIdDNSHeader;
function NewIdDNSHeader:PIdDNSHeader;

type

  TQuestionItem = object(TCollectionItem)
  public
    QClass: Word;
    QName: string;
    QType: Word;
  end;
PQuestionItem=^TQuestionItem;
function NewQuestionItem:PQuestionItem;

type  

  TIdDNSQuestionList = object(TCollection)
  protected
    function GetItem(Index: Integer): TQuestionItem;
    procedure SetItem(Index: Integer; const Value: TQuestionItem);
  public
     { constructor Create;  }// reintroduce;
    function Add: TQuestionItem;
    property Items[Index: Integer]: TQuestionItem read GetItem write SetItem;
      default;
  end;
PIdDNSQuestionList=^TIdDNSQuestionList;
function NewIdDNSQuestionList:PIdDNSQuestionList;

type

  THInfo = record
    CPUStr: ShortString;
    OsStr: ShortString;
  end;

  TMInfo = record
    EMailBox: ShortString;
    RMailBox: ShortString;
  end;

  TMX = record
    Exchange: ShortString;
    Preference: Word;
  end;

  TSOA = record
    Expire: Cardinal;
    Minimum: Cardinal;
    MName: ShortString;
    Refresh: Cardinal;
    Retry: Cardinal;
    RName: ShortString;
    Serial: Cardinal;
  end;

  TWKS = record
    Address: Cardinal;
    Bits: TWKSBits;
    Protocol: byte;
  end;

  TRdata = record
    DomainName: string;
    HInfo: THInfo;
    MInfo: TMInfo;
    MX: TMx;
    SOA: TSOA;
    A: Cardinal;
    WKS: TWks;
    Data: string;
    HostAddrStr: string;
  end;

  TIdDNSResourceItem = object(TCollectionITem)
  public
    AType: Word;
    AClass: Word;
      Name: string;
    RData: TRData;
    RDLength: Word;
    TTL: Cardinal;
    StarData: string;
  end;
PIdDNSResourceItem=^TIdDNSResourceItem;
function NewIdDNSResourceItem:PIdDNSResourceItem;

type

  TIdDNSResourceList = object(TCollection)
  protected
    function GetItem(Index: Integer): TIdDNSResourceItem;
    procedure SetItem(Index: Integer; const Value: TIdDNSResourceItem);
  public
    function Add: TIdDNSResourceItem;
     { constructor Create;  }// reintroduce;
    property Items[Index: Integer]: TIdDNSResourceItem read GetItem write
      SetItem; default;
   { published } 
    function GetDNSMxExchangeNameEx(Idx: Integer): string;
    function GetDNSRDataDomainName(Idx: Integer): string;
  end;
PIdDNSResourceList=^TIdDNSResourceList;
function NewIdDNSResourceList:PIdDNSResourceList;

 type 

  TMXRecord = object(TIdDNSResourceItem)
  protected
    FPreference: Word;
    FExchange: string;
  public
    property Preference: Word read FPreference;
    property Exchange: string read FExchange;
  end;
PMXRecord=^TMXRecord;
function NewMXRecord:PMXRecord;

type

  TARecord = object(TIdDNSResourceItem)
  protected
    FDomainName: string;
  public
    property DomainName: string read FDomainName;
  end;
PARecord=^TARecord;
function NewARecord:PARecord;

type

  TNameRecord = object(TIdDNSResourceItem)
  protected
    FDomainName: string;
  public
    property DomainName: string read FDomainName;
  end;
PNameRecord=^TNameRecord;
function NewNameRecord:PNameRecord;

 type  
  TPTRRecord = object(TIdDNSResourceItem)
  protected
    FDomainName: string;
  public
    property DomainName: string read FDomainName;
  end;
PPTRRecord=^TPTRRecord;
function NewPTRRecord:PPTRRecord;
type 

  THInfoRecord = object(TIdDNSResourceItem)
  protected
    FCPUStr: string;
    FOsStr: string;
  public
    property CPUStr: string read FCPUStr;
    property OsStr: string read FOsStr;
  end;
PHInfoRecord=^THInfoRecord;
function NewHInfoRecord:PHInfoRecord;
type  

  TMInfoRecord = object(TIdDNSResourceItem)
  protected
    FEMmailBox: string;
    FRMailBox: string;
  public
    property EMmailBox: string read FEMmailBox;
    property RMailBox: string read FRMailBox;
  end;
PMInfoRecord=^TMInfoRecord;
function NewMInfoRecord:PMInfoRecord;
type 

  TMRecord = object(TIdDNSResourceItem)
  protected
    FEMailBox: string;
    FRMailBox: string;
  public
    property EMailBox: string read FEMailBox;
    property RMailBox: string read FRMailBox;
  end;
PMRecord=^TMRecord;
function NewMRecord:PMRecord; 
type 

  TSOARecord = object(TIdDNSResourceItem)
  protected
    FExpire: Cardinal;
    FMinimum: Cardinal;
    FMName: string;
    FRefresh: Cardinal;
    FRetry: Cardinal;
    FRName: string;
    FSerial: Cardinal;
  public
    property Expire: Cardinal read FExpire;
    property Minimum: Cardinal read FMinimum;
    property MName: string read FMName;
    property Refresh: Cardinal read FRefresh;
    property Retry: Cardinal read FRetry;
    property RName: string read FRName;
    property Serial: Cardinal read FSerial;
  end;
PSOARecord=^TSOARecord;
function NewSOARecord:PSOARecord;

type

  TWKSRecord = object(TIdDNSResourceItem)
  protected
    FAddress: Cardinal;
    FBits: TWKSBits;
    FProtocol: byte;

    function GetBits(AIndex: Integer): Byte;
  public
    property Address: Cardinal read FAddress;
    property Bits[AIndex: Integer]: Byte read GetBits;
    property Protocol: byte read FProtocol;
  end;
PWKSRecord=^TWKSRecord;
function NewTWKSRecord:PWKSRecord;
type

  TIdDNSResolver = object(TIdUDPClient)
  protected
    FDNSAnList: TIdDNSResourceList;
    FDNSArList: TIdDNSResourceList;
    FDNSHeader: TIdDNSHeader;
    FDNSQdList: TIdDNSQuestionList;
    FDNSNsList: TIdDNSResourceList;
    FQPacket: string;
    FRPacket: string;
    FQPackSize: Integer;
    FRequestedRecords: TRequestedRecords;
    FRPackSize: Integer;

    FAnswers: TIdDNSResourceList;

    function CreateLabelStr(QName: string): string;
    procedure CreateQueryPacket;
    procedure DecodeReplyPacket;
  public
    procedure ClearVars; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
     virtual; procedure ResolveDNS;
    procedure ResolveDomain(const ADomain: string);

    property Answers: TIdDNSResourceList read FAnswers;
    property DNSAnList: TIdDNSResourceList read FDnsAnList write FDnsAnList;
    property DNSARList: TIdDNSResourceList read FDnsArList write FDnsArList;
    property DNSHeader: TIdDNSHeader read FDNSHeader write FDNSHeader;
    property DNSQDList: TIdDNSQuestionList read FDnsQdList write FDnsQdList;
    property DNSNSList: TIdDNSResourceList read FDnsNsList write FDnsNsList;
    property Port default IdPORT_DOMAIN;
    property QPacket: string read FQPacket write FQpacket;
    property RequestedRecords: TRequestedRecords read FRequestedRecords write
      FRequestedRecords;
    property RPacket: string read FRPacket write FRPacket;
//    property ReceiveTimeout default IdDNSResolver_ReceiveTimeout;
  end;
PIdDNSResolver=^TIdDNSResolver;
function NewIdDNSResolver(AOwner: PControl):PIdDNSResolver;
type 

  HiLoBytes = record
    HiByte: Byte;
    LoByte: Byte;
  end;

  WordRec = record
    case byte of
      1: (TheBytes: HiLoBytes);
      2: (AWord: Word);
  end;

  HiLoWords = record
    HiWord,
      LowWord: Word;
  end;

  CardinalRec = record
    case Byte of
      1: (aCardinal: Cardinal);
      2: (Words: HILoWords);
  end;

function GetQTypeStr(aQType: Integer): string;
function GetQClassStr(QClass: Integer): string;

implementation

{uses
  IdException;}

function TwoCharToWord(AChar1, AChar2: Char): Word;
begin
  Result := Word((Ord(AChar1) shl 8) and $FF00) or Word(Ord(AChar2) and $00FF);
end;

function FourCharToCardinal(AChar1, AChar2, AChar3, AChar4: Char): Cardinal;
var
  ARes: CardinalRec;
begin
  ares.Words.HiWord := TwoCharToWord(AChar1, AChar2);
  aRes.Words.LowWord := TwoCharToWord(AChar3, AChar4);
  Result := ARes.aCardinal;
end;

function WordToTwoCharStr(AWord: Word): string;
begin
  Result := Chr(Hi(AWord)) + Chr(Lo(AWord));
end;

function GetRCodeStr(RCode: Integer): string;
begin
  if Rcode in [cRCodeNoError..cRCodeRefused] then
  begin
    Result := cRCodeStrs[Rcode];
  end
  else
  begin
    Result := RSCodeQueryUnknownError;
  end;
end;

function GetQTypeStr(aQType: Integer): string;
begin
  case AQType of
    cA: Result := 'A'; // a Host Address
    cNS: Result := 'NS'; // An Authoritative name server
    cMD: Result := 'MD'; // A mail destination obsolete use MX (OBSOLETE)
    cMF: Result := 'MF'; // A mail forwarder obsolete use MX   (OBSOLETE)
    cName: Result := 'NAME'; // The canonical name for an alias
    cSOA: Result := 'SOA'; // Marks the start of a zone of authority
    cMB: Result := 'MB'; // A mail box domain name (Experimental)
    cMG: Result := 'MG'; // A mail group member (Experimental)
    cMR: Result := 'MR'; // A mail Rename Domain Name (Experimental)
    cNULL: Result := 'NULL'; // RR (Experimental)
    cWKS: Result := 'WKS'; // A well known service description
    cPTR: Result := 'PTR'; // A Domain Name Pointer;
    cHINFO: Result := 'HINFO'; // Host Information;
    cMINFO: Result := 'MINFO'; // Mailbox or Mail List Information;
    cMX: Result := 'MX'; // Mail Exchange
    cTXT: Result := 'TXT'; // Text String;
    cAXFR: Result := 'AXFR'; // A Request for the Transfer of an entire zone;
    cMAILB: Result := 'MAILB';
      // A request for mailbox related records (MB MG OR MR}
    cMAILA: Result := 'MAILA'; // A request for mail agent RRs (Obsolete see MX)
    cStar: Result := '*'; // A Request for all Records
  else
    Result := IntToSTr(aQType);
  end;
end;

function GetQClassStr(QClass: Integer): string;
begin
  if QClass in [cIN..CHs] then
  begin
    Result := cQClassStr[QClass];
  end
  else
  begin
    if QClass = 15 then
    begin
      Result := 'MX';
    end
    else
    begin
      Result := IntToStr(QClass);
    end;
  end;
end;

function GetErrorStr(Code, Id: Integer): string;
begin
  case code of
    1: Result := Format(RSQueryInvalidQueryCount, [Id]);
    2: Result := Format(RSQueryInvalidPacketSize, [InttoSTr(Id)]);
    3: Result := Format(RSQueryLessThanFour, [Id]);
    4: Result := Format(RSQueryInvalidHeaderID, [Id]);
    5: Result := Format(RSQueryLessThanTwelve, [Id]);
    6: Result := Format(RSQueryPackReceivedTooSmall, [Id]);
  end;
end;

//constructor TIdDNSHeader.Create;
function NewIdDNSHeader:PIdDNSHeader;
begin
//  inherited Create;
  New( Result, Create );
with Result^ do
  InitialIzeFid;
end;

procedure TIdDNSHeader.InitializefId;
begin
  Randomize;
  fId := Random(10000);
end;

procedure TIdDNSHeader.InitVars;
begin
  fBitCode := 0;
    { Holds Qr,OPCode AA TC RD RA RCode and Reserved Bits           }
  fQdCount := 0;
    { Number of Question Entries in Question Section                }
  fAnCount := 0;
    { Number of Resource Records in Answer Section                  }
  fNsCount := 0;
    { Number of Name Server Resource Recs in  Authority Rec Section }
  fArCount := 0;
    { Number of Resource Records in Additional records Section      }
end;

function TIdDNSHeader.GetQR: Boolean;
begin
  Result := (fBitCode and cQRBit) = cQRBit;
end;

procedure TIdDNSHeader.SetQr(IsResponse: Boolean);
begin
  if IsResponse then
  begin
    fBitCode := fBitCode or cQRBit;
  end
  else
  begin
    fBitCode := fBitCode and cQRMask
  end;
end;

function TIdDNSHeader.GetOpCode: Word;
begin
  Result := ((fBitCode and cOpCodeBits) shr 11) and $000F;
end;

{procedure TIdDNSHeader.SetOpCode(OpCode: Word);
begin
  fBitCode := ((OpCode shl 11) and cOpCodeBits) or
    (fBitCode and cOpCodeMask);
end;}

function TIdDNSHeader.GetAA: Boolean;
begin
  Result := (fBitCode and cAABit) = cAABit;
end;

procedure TIdDNSHeader.SetAA(AuthAnswer: Boolean);
begin
  if AuthAnswer then
  begin
    fBitCode := fBitCode or cAABit;
  end
  else
  begin
    fBitCode := fBitCode and cAAMask;
  end;
end;

function TIdDNSHeader.GetTC: Boolean;
begin
  Result := (fBitCode and cTCBit) = cTCBit;
end;

procedure TIdDNSHeader.SetTC(IsTruncated: Boolean);
begin
  if IsTruncated then
  begin
    fBitCode := fBitCode or cTCBit;
  end
  else
  begin
    fBitCode := fBitCode and cTCMask;
  end;
end;

function TIdDNSHeader.GetRD: Boolean;
begin
  Result := (fBitCode and cRDBit) = cRDBit;
end;

procedure TIdDNSHeader.SetRD(RecursionDesired: Boolean);
begin
  if RecursionDesired then
  begin
    fBitCode := fBitCode or cRDBit;
  end
  else
  begin
    fBitCode := fBitCode and cRDMask;
  end;
end;

function TIdDNSHeader.GetRA: Boolean;
begin
  Result := (fBitCode and cRABit) = cRABit;
end;

procedure TIdDNSHeader.SetRA(RecursionAvailable: Boolean);
begin
  if RecursionAvailable then
  begin
    fBitCode := fBitCode or cRABit;
  end
  else
  begin
    fBitCode := fBitCode and cRAMask;
  end;
end;

function TIdDNSHeader.GetRCode: Word;
begin
  Result := (fBitCode and cRCodeBits);
end;

{procedure TIdDNSHeader.SetRCode(RCode: Word);
begin
  fBitCode := (RCode and cRCodeBits) or (fBitCode and cRCodeMask);
end;}

function TIdDNSQuestionList.Add: TQuestionItem;
begin
//  Result := TQuestionItem(inherited Add);
end;

//constructor TIdDNSQuestionList.Create;
function NewIdDNSQuestionList:PIdDNSQuestionList;
begin
  New( Result, Create );
//  inherited Create(TQuestionItem);
end;

function TIdDNSQuestionList.GetItem(Index: Integer): TQuestionItem;
begin
//  Result := TQuestionItem(inherited Items[Index]);
end;

procedure TIdDNSQuestionList.SetItem(Index: Integer;
  const Value: TQuestionItem);
begin
//  inherited SetItem(Index, Value);
end;

//constructor TIdDNSResourceList.Create;
function NewIdDNSResourceList:PIdDNSResourceList;
begin
  New( Result, Create );
//  inherited Create(TIdDNSResourceItem);
end;

function TIdDNSResourceList.GetDNSRDataDomainName(Idx: Integer): string;
begin
  if (Idx < Count) and (Idx >= 0) then
  begin
    Result := TIdDNSResourceItem(Items[Idx]).RData.DomainName;
  end
  else
    Result := '';
end;

function TIdDNSResourceList.GetDnsMxExchangeNameEx(Idx: Integer): string;
begin
  if (Idx < Count) and (Idx >= 0) then
  begin
    Result :=
      IntToStr(TIdDNSResourceItem(Items[Idx]).RData.MX.Preference);
    while Length(Result) < 5 do
    begin
      Result := ' ' + Result;
    end;
    Result :=
      Result + ' ' + TIdDNSResourceItem(Items[Idx]).RData.MX.Exchange;
  end
  else
  begin
    Result := '';
  end;
end;

function TIdDNSResourceList.Add: TIdDNSResourceItem;
begin
//  Result := TIdDNSResourceItem(inherited Add);
end;

function TIdDNSResourceList.GetItem(Index: Integer): TIdDNSResourceItem;
begin
//  Result := TIdDNSResourceItem(inherited Items[Index]);
end;

procedure TIdDNSResourceList.SetItem(Index: Integer;
  const Value: TIdDNSResourceItem);
begin
//  inherited SetItem(Index, Value);
end;

//constructor TIdDNSResolver.Create(aOwner: tComponent);
function NewIdDNSResolver(AOwner: PControl):PIdDNSResolver;
begin
New( Result, Create );
with Result^ do
begin
//  inherited Create(aOwner);
{  Port := IdPORT_DOMAIN;
  ReceiveTimeout := IdDNSResolver_ReceiveTimeout;
  fDNSHeader := TIdDNSHeader.Create;
  fDnsQdList := TIdDNSQuestionList.Create;
  fDnsAnList := TIdDNSResourceList.Create;
  fDnsNsList := TIdDNSResourceList.Create;
  fDnsArList := TIdDNSResourceList.Create;
  FAnswers := TIdDNSREsourceList.Create;}
end;
end;

destructor TIdDNSResolver.Destroy;
begin
  fDNSHeader.Free;
  fDnsQdList.Free;
  fDnsAnList.Free;
  fDnsNsList.Free;
  fDnsArList.Free;
  FAnswers.Free;
  inherited Destroy;
end;

procedure TIdDNSResolver.ResolveDNS;
begin
  try
    CreateQueryPacket;
    Send(QPacket);
    fRPacket := ReceiveString;
  finally DecodeReplyPacket;
  end;
end;

procedure TIdDNSResolver.ClearVars;
begin
  fDNSHeader.InitVars;
  fDnsQdList.Clear;
  fDnsAnList.Clear;
  fDnsNsList.Clear;
  fDnsArList.Clear;
end;

function TIdDNSResolver.CreateLabelStr(QName: string): string;
const
  aPeriod = '.';
var
  aLabel: string;
  ResultArray: array[0..512] of Char;
  NumBytes,
    aPos,
    RaIdx: Integer;

begin
  Result := '';
  FillChar(ResultArray, SizeOf(ResultArray), 0);
  aPos := Pos(aPeriod, QName);
  RaIdx := 0;
  while (aPos <> 0) and ((RaIdx + aPos) < SizeOf(ResultArray)) do
  begin
    aLabel := Copy(QName, 1, aPos - 1);
    NumBytes := Succ(Length(Alabel));
    Move(aLabel, ResultArray[RaIdx], NumBytes);
    Inc(RaIdx, NumBytes);
    Delete(QName, 1, aPos);
    aPos := Pos(aPeriod, QName);
  end;
  Result := string(ResultArray);
end;

procedure TIdDNSResolver.CreateQueryPacket;
var
  QueryIdx: Integer;
  DnsQuestion: TQuestionItem;

  procedure DoDomainName(ADNS: string);
  var
    BufStr: string;
    aPos: Integer;
  begin
    while Length(aDns) > 0 do
    begin
      aPos := Pos('.', aDns);
      if aPos = 0 then
      begin
        aPos := Length(aDns) + 1;
      end;
      BufStr := Copy(aDns, 1, aPos - 1);
      Delete(aDns, 1, aPos);
      QPacket := QPacket + Chr(Length(BufStr)) + BufStr;
    end;
  end;

  procedure DoHostAddress(aDNS: string);
  var
    BufStr,
      BufStr2: string;
    aPos: Integer;
  begin
    while Length(aDns) > 0 do
    begin
      aPos := Pos('.', aDns);
      if aPos = 0 then
      begin
        aPos := Length(aDns) + 1;
      end;
      BufStr := Copy(aDns, 1, aPos - 1);
      Delete(aDns, 1, aPos);
      BufStr2 := Chr(Length(BufStr)) + BufStr + BufStr2;
    end;
    QPacket :=
      QPacket + BufStr2 + Chr(07) + 'in-addr' + Chr(04) + 'arpa';
  end;

begin
{  DNSHeader.fId := Random(62000);
  DNSHeader.fQdCount := fDnsQdList.Count;
  if DNSHeader.fQdCount < 1 then
  begin
    raise EIdDnsResolverError.Create(GetErrorStr(1, 1));
  end;
  QPacket := WordToTwoCharStr(DNSHeader.fId);
  QPacket := QPacket + WordToTwoCharStr(DNSHeader.fBitCode);
  QPacket := QPacket + WordToTwoCharStr(DNSHeader.fQdCount);
  QPacket := QPacket + Chr(0) + Chr(0)
    + Chr(0) + Chr(0)
    + Chr(0) + Chr(0);
  for QueryIdx := 0 to fDnsQdList.Count - 1 do
  begin
    DNsQuestion := fDnsQdList.Items[QueryIdx];
    case DNSQuestion.Qtype of
      cA: DoDomainName(DNsQuestion.QName);
      cNS: DoDomainName(DNsQuestion.QName);
      cMD: raise EIdDnsResolverError.Create(RSDNSMDISObsolete);
      cMF: raise EIdDnsResolverError.Create(RSDNSMFIsObsolete);
      cName: DoDomainName(DNsQuestion.QName);
      cSOA: DoDomainName(DNsQuestion.Qname);
      cMB: DoDomainName(DNsQuestion.QName);
      cMG: DoDomainName(DNsQuestion.QName);
      cMR: DoDomainName(DNsQuestion.QName);
      cNULL: DoDomainName(DNsQuestion.QName);
      cWKS: DoDomainName(DNsQuestion.QName);
      cPTR: DoHostAddress(DNsQuestion.QName);
      cHINFO: DoDomainName(DNsQuestion.QName);
      cMINFO: DoDomainName(DNsQuestion.QName);
      cMX: DoDomainName(DNsQuestion.QName);
      cTXT: DoDomainName(DNsQuestion.QName);
      cAXFR: DoDomainName(DNsQuestion.QName);
      cMAILB: DoDomainName(DNsQuestion.QName);
      cMailA: raise EIdDnsResolverError.Create(RSDNSMailAObsolete);
      cSTar: DoDomainName(DNsQuestion.QName);
    end;
    fQPacket := fQPacket + Chr(0);
    fQPacket := fQPacket + WordToTwoCharStr(DNsQuestion.QType);
    fQPacket := fQPacket + WordToTwoCharStr(DNsQuestion.QClass);
  end;
  FQPackSize := Length(fQPacket);}
end;

procedure TIdDNSResolver.DecodeReplyPacket;
var
  CharCount: Integer;
  Idx: Integer;
  ReplyId: Word;

  function LabelsToDomainName(const SrcStr: string; var Idx: Integer): string;
  var
    LabelStr: string;
    Len: Integer;
    SavedIdx: Integer;
    AChar: Char;
  begin
    Result := '';
    SavedIdx := 0;
    repeat
      Len := Byte(SrcStr[Idx]);
      if Len > 63 then
      begin
        if SavedIdx = 0 then
        begin
          SavedIdx := Succ(Idx);
        end;
        aChar := Char(Len and $3F);
        Idx := TwoCharToWord(aChar, SrcStr[Idx + 1]) + 1;
      end;
      if Idx > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 2));
      end;
      SetLength(LabelStr, Byte(SrcStr[Idx]));
      Move(SrcStr[Idx + 1], LabelStr[1], Length(LabelStr));
      Inc(Idx, Length(LabelStr) + 1);
      if (Idx - 1) > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 3));
      end;
      Result := Result + LabelStr + '.';
    until (SrcStr[Idx] = Char(0)) or (Idx >= Length(SrcStr));
    if Result[Length(Result)] = '.' then
    begin
      Delete(Result, Length(Result), 1);
    end;
    if SavedIdx > 0 then
    begin
      Idx := SavedIdx;
    end;
    Inc(Idx);
  end;

  function ParseQuestions(StrIdx: Integer): Integer;
  var
    DNSQuestion: TQuestionItem;
    Idx: Integer;
  begin
    for Idx := 1 to fDNSHeader.fQdCount do
    begin
      DnsQuestion := fDnsQdList.Add;
      DnsQuestion.QName := LabelsToDomainName(RPacket, StrIdx);
      if StrIdx > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 4));
      end;
      DnsQuestion.Qtype := TwoCharToWord(RPacket[StrIdx], RPacket[StrIdx + 1]);
      Inc(StrIdx, 2);
      if StrIdx > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 5));
      end;
      DnsQuestion.QClass := TwoCharToWord(RPacket[StrIdx], RPacket[StrIdx + 1]);
      if StrIdx + 1 > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 6));
      end;
      Inc(StrIdx, 2);
    end;
    Result := StrIdx;
  end;

  function ParseResource(NumItems, StrIdx: Integer; DnsList: TIdDNSResourceList)
      : Integer;
  var
    RDataStartIdx: Integer;
    DnsResponse: TIdDNSResourceItem;
    Idx: Integer;

    procedure ProcessRData(sIdx: Integer);

      procedure DoHostAddress;
      var
        Idx: Integer;

      begin
        if sIdx + 3 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 7));
        end;
        for Idx := sIdx to sIdx + 3 do
        begin
          DnsResponse.RData.HostAddrStr := DNSResponse.RData.HostAddrStr +
            IntToStr(Ord(RPacket[Idx])) + '.';
        end;
        Delete(DNSResponse.RData.HostAddrStr,
          Length(DNSResponse.RData.HostAddrStr), 1);
      end;

      procedure DoDomainNameRData;
      begin
        DnsResponse.RData.DomainName := LabelsToDomainName(RPacket, sIdx);
        if (sIdx - 1) > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 8));
        end;
      end;

      procedure DoSOARdata;
      begin
        DNSResponse.RData.SOA.MName := LabelsToDomainName(RPacket, sIdx);
        if sIdx > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 9));
        end;
        DNSResponse.RData.SOA.RName := LabelsToDomainName(RPacket, sIdx);
        if sIdx + 4 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 10));
        end;
        DNSResponse.RData.SOA.Serial := FourCharToCardinal(RPacket[sIdx],
          RPacket[sIdx + 1], RPacket[sIdx + 2], RPacket[sIdx + 3]);
        Inc(sIdx, 4);
        if sIdx + 4 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 11));
        end;
        DNSResponse.RData.SOA.Refresh := FourCharToCardinal(RPacket[sIdx],
          RPacket[sIdx + 1], RPacket[sIdx + 2], RPacket[sIdx + 3]);
        Inc(sIdx, 4);
        if sIdx + 4 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 12));
        end;
        DNSResponse.RData.SOA.ReTry := FourCharToCardinal(RPacket[sIdx],
          RPacket[sIdx + 1], RPacket[sIdx + 2], RPacket[sIdx + 3]);
        Inc(sIdx, 4);
        if sIdx + 4 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 13));
        end;
        DNSResponse.RData.SOA.Expire := FourCharToCardinal(RPacket[sIdx],
          RPacket[sIdx + 1], RPacket[sIdx + 2], RPacket[sIdx + 3]);
        Inc(sIdx, 4);
        if sIdx + 3 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 14));
        end;
        DNSResponse.RData.SOA.Minimum := FourCharToCardinal(RPacket[sIdx],
          RPacket[sIdx + 1], RPacket[sIdx + 2], RPacket[sIdx + 3]);
        Inc(sIdx, 4);
      end;

      procedure DoWKSRdata;
      begin
        if sIdx + 4 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 15));
        end;
        DNSResponse.RData.WKS.Address :=
          FourCharToCardinal(RPacket[sIdx], RPacket[sIdx + 1], RPacket[sIdx +
            2], RPacket[sIdx + 3]);
        Inc(sIdx, 4);
        DNSResponse.RData.WKS.Protocol := Byte(RPacket[sIdx]);
        Inc(sIdx);
        if sIdx + 7 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 16));
        end;
        Move(RPacket[sIdx], DNSResponse.RData.WKS.Bits, 8);
      end;

      procedure DoHInfoRdata;
      begin
        if sIdx + Ord(RPacket[sIdx]) + 1 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 17));
        end;
        Move(RPacket[sIdx], DNSResponse.RData.Hinfo.CpuStr,
          Ord(RPacket[sIdx]) + 1);
        sIdx := sIdx + Length(DNSResponse.RData.Hinfo.CpuStr) + 2;
        if sIdx + Ord(RPacket[sIdx]) + 1 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 18));
        end;
        Move(RPacket[sIdx], DNSResponse.RData.Hinfo.OSStr,
          Ord(RPacket[sIdx]) + 1);
      end;

      procedure DoMInfoRdata;
      begin
        DNSResponse.RData.Minfo.RMailBox :=
          LabelsToDomainName(RPacket, sIdx);
        if sIdx > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 19));
        end;
        DNSResponse.RData.MinFo.EMailBox :=
          LabelsToDomainName(RPacket, sIdx);
        if sIdx > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 20));
        end;
      end;

      procedure DoMXRData;
      begin
        if sIdx + 2 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 21));
        end;
        DNSResponse.RData.MX.Preference :=
          TwoCharToWord(RPacket[sIdx], RPacket[sIdx + 1]);
        Inc(sIdx, 2);
        if sIdx + 2 > fRPackSize then
        begin
//          raise EIdDnsResolverError.Create(GetErrorStr(2, 22));
        end;
        DNSResponse.RData.Mx.Exchange := LabelsToDomainName(RPacket, sIdx);
      end;

      procedure DoMailBRdata;
      begin
//        raise EIdDnsResolverError.Create(RSDNSMailBNotImplemented);
      end;

    begin
      case DnsResponse.AType of
        cA: DoHostAddress;
        cNS: DoDomainNameRData;
//        cMD: raise EIdDnsResolverError.Create(RSDNSMDISObsolete);
//        cMF: raise EIdDnsResolverError.Create(RSDNSMFIsObsolete);
        cName: DoDomainNameRData;
        cSOA: DoSOARdata;
        cMB: DoDomainNameRData;
        cMG: DoDomainNameRData;
        cMR: DoDomainNameRData;
        cNULL:
          DnsResponse.StarData :=
            Copy(RPacket, RDataStartIdx, DnsResponse.RdLength);
        cWKS: DoWKSRdata;
        cPTR: DoDomainNameRData;
        cHINFO: DoHInfoRdata;
        cMINFO: DoMInfoRdata;
        cMX: DoMXRData;
        cTXT:
          DnsResponse.StarData :=
            Copy(RPacket, RDataStartIdx, DnsResponse.RdLength);
        cAXFR:
          DnsResponse.StarData :=
            Copy(RPacket, RDataStartIdx, DnsResponse.RdLength);
        cMAILB: DoMailBRData;
//        cMailA: raise EIdDnsResolverError.Create(RSDNSMFIsObsolete);
        cStar:
          DnsResponse.StarData :=
            Copy(RPacket, RDataStartIdx, DnsResponse.RdLength);
      else

      end;
    end;

  begin
    Result := 0;
    for Idx := 1 to NumItems do
    begin
      DnsResponse := DnsList.Add;
      DnsResponse.Name := LabelsToDomainName(RPacket, StrIdx);
      if StrIdx + 10 > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 23));
      end;
      DnsResponse.aType :=
        TwoCharToWord(RPacket[StrIdx], RPacket[StrIdx + 1]);
      Inc(StrIdx, 2);
      DnsResponse.aClass :=
        TwoCharToWord(RPacket[StrIdx], RPacket[StrIdx + 1]);
      Inc(StrIdx, 2);
      DnsResponse.TTL :=
        FourCharToCardinal(RPacket[StrIdx], RPacket[StrIdx + 1],
        RPacket[StrIdx + 2], RPacket[StrIdx + 3]);
      Inc(StrIdx, 4);
      DnsResponse.RdLength :=
        TwoCharToWord(RPacket[StrIdx], RPacket[StrIdx + 1]);
      Inc(StrIdx, 2);
      if ((StrIdx + DnsResponse.RdLength) - 1) > fRPackSize then
      begin
//        raise EIdDnsResolverError.Create(GetErrorStr(2, 23));
      end;
      RDataStartIdx := StrIdx;
      ProcessRdata(StrIdx);
      Inc(StrIdx, DnsResponse.RdLength);

      Result := StrIdx;
      if StrIdx >= Length(RPacket) then
      begin
        Exit;
      end;
    end;
    if Result = 0 then
    begin
      Result := StrIdx;
    end;
  end;

begin
  ClearVars;
  fRPackSize := Length(RPacket);
  if fRPackSize < 4 then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(3, 28));
  end;
  CharCount := 1;
  ReplyId := TwoCharToWord(RPacket[1], RPacket[2]);
  if ReplyId <> fDNSHeader.fid then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(4, fDNSHeader.Fid));
  end;
  Inc(CharCount, 4);
  fDNSHeader.fBitCode := TwoCharToWord(RPacket[3], RPacket[4]);
//  if FDNSHeader.RCode <> 0 then
  begin
//    raise EIdDnsResolverError.Create(GetRCodeStr(FDNSHeader.RCode));
  end;
  if fRPackSize < 12 then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(5, 29));
  end;
  fDNSHeader.fQdCount := TwoCharToWord(RPacket[5], RPacket[6]);
  fDNSHeader.fAnCount := TwoCharToWord(RPacket[7], RPacket[8]);
  fDNSHeader.fNsCount := TwoCharToWord(RPacket[9], RPacket[10]);
  fDNSHeader.fArCount := TwoCharToWord(RPacket[11], RPacket[12]);
  if (fRPackSize < FQPackSize) then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(5, 30));
  end;
  for Idx := 1 to fDNSHeader.fQdCount do
  begin
    CharCount := ParseQuestions(13);
  end;
  if (Charcount >= fRPackSize) and ((fDNSHeader.fAnCount > 0) or
    (fDNSHeader.fNsCount > 0) or
    (fDNSHeader.fArCount > 0)) then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(6, 31));
  end;
  if fDNSHeader.fAnCount > 0 then
  begin
    CharCount := ParseResource(fDNSHeader.fAnCount, CharCount, fDnsAnList);
  end;
  if (Charcount >= fRPackSize) and ((fDNSHeader.fNsCount > 0) or
    (fDNSHeader.fArCount > 0)) then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(6, 32));
  end;
  if fDNSHeader.fNsCount > 0 then
  begin
    CharCount := ParseResource(fDNSHeader.fNsCount, CharCount, fDnsNsList);
  end;
  if (Charcount >= fRPackSize) and (fDNSHeader.fArCount > 0) then
  begin
//    raise EIdDnsResolverError.Create(GetErrorStr(6, 33));
  end;
  if fDNSHeader.fArCount > 0 then
  begin
    CharCount := ParseResource(fDNSHeader.fArCount, CharCount, fDnsArList);
  end;
  fRPackSize := CharCount;
end;

procedure TIdDNSResolver.ResolveDomain(const ADomain: string);
var
  i: Integer;
  Rec: TRequestedRecord;
  LRData: TRData;
begin
  ClearVars;
//  DNSHeader.ID := DNSHeader.Id + 1;
  DNSHeader.Qr := False;
//  DNSHeader.Opcode := cResQuery;
  DNSHeader.RD := True;
  for Rec := Low(TRequestedRecord) to High(TRequestedRecord) do
  begin
    if Rec in FRequestedRecords then
    begin
//      DNSHeader.QdCount := DNSHEader.QdCount + 1;
      with DNSQDList.Add do
      begin
        QName := ADomain;
        QType := Rec;
        QClass := cIN;
      end;
    end;
  end;

  ResolveDNS;

{  for i := 0 to DNSAnList.Count - 1 do
  begin
    LRData := DNSAnList.Items[i].RData;
    case DNSAnList.Items[i].AType of
      cA:
        with TARecord.Create(Answers) do
        begin
          FDomainName := LRData.DomainName;
        end;
      cMX:
        with TMXRecord.Create(Answers) do
        begin
          FExchange := LRData.MX.Exchange;
          FPreference := LRData.MX.Preference;
        end;
      cNAME:
        with TNameRecord.Create(Answers) do
        begin
          FDomainName := LRData.DomainName;
        end;
      cSOA:
        with TSOARecord.Create(Answers) do
        begin
          FExpire := LRData.SOA.Expire;
          FMinimum := LRData.SOA.Minimum;
          FMName := LRData.SOA.MName;
          FRefresh := LRData.SOA.Refresh;
          FRetry := LRData.SOA.Retry;
          FRName := LRData.SOA.RName;
          FSerial := LRData.SOA.Serial;
        end;
      cWKS:
        with TWKSRecord.Create(Answers) do
        begin
          FAddress := LRData.WKS.Address;
          FBits := LRData.WKS.Bits;
          FProtocol := LRData.WKS.Protocol;
        end;
      cPTR:
        with TPTRRecord.Create(Answers) do
        begin
          FDomainName := LRData.HostAddrStr;
        end;
      cHINFO:
        with THInfoRecord.Create(Answers) do
        begin
          FCPUStr := LRData.HInfo.CPUStr;
          FOsStr := LRData.HInfo.OsStr;
        end;
      cMINFO:
        with TMInfoRecord.Create(Answers) do
        begin
          FEMmailBox := LRData.MInfo.EMailBox;
          FRMailBox := LRData.MInfo.RMailBox;
        end;
    end;
  end;}
end;

function TWKSRecord.GetBits(AIndex: Integer): Byte;
begin
  Result := FBits[Index];
end;

function NewQuestionItem:PQuestionItem;
begin
  New( Result, Create );
end;

function NewIdDNSResourceItem:PIdDNSResourceItem;
begin
  New( Result, Create );
end;

function NewMXRecord:PMXRecord;
begin
  New( Result, Create );
end;

function NewARecord:PARecord;
begin
  New( Result, Create );
end;

function NewNameRecord:PNameRecord;
begin
  New( Result, Create );
end;

function NewPTRRecord:PPTRRecord;
begin
  New( Result, Create );
end;

function NewHInfoRecord:PHInfoRecord;
begin
  New( Result, Create );
end;

function NewMInfoRecord:PMInfoRecord;
begin
  New( Result, Create );
end;

function NewMRecord:PMRecord;
begin
  New( Result, Create );
end;

function NewSOARecord:PSOARecord;
begin
  New( Result, Create );
end;

function NewTWKSRecord:PWKSRecord;
begin
  New( Result, Create );
end;

end.
