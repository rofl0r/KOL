// 27-nov-2002
unit IdTunnelCommon;

{*
  Indy Tunnel components module
  Copyright (C) 1999, 2000, 2001 Gregor Ibic (gregor.ibic@intelicom.si)
  Intelicom d.o.o., www.intelicom.si
  This component is published under same license like Indy package.

  This package is a TCP Tunnel implementation written
  by Gregor Ibic (gregor.ibic@intelicom.si).

  This notice may not be removed or altered from any source
  distribution.

 // MAJOR CHANGES
 05-January-20001
 GI: Major code  reorganization and polishing
 31-May-2000
 GI TunnelHeaders eliminated. Some other code jugling.
 29-May-2000
 GI Components split in several files to be more compliant
                 with Indy coding standards.
                 It consists of:
                 - IdTunnelHeaders
                 - IdTunnelCommon
                 - IdTunnelMaster
                 - IdTunnelSlave
 24-May-2000
 GI: Turbo translation mode finished (01:24). It works!
                 Will draw icons in the morning.
 23-May-2000
 GI: Turbo translation mode to Indy standard started by
                 Gregor Ibic (hehe) (now is 23:15)

*}

interface

uses KOL, 
  SysUtils { , Classes } , SyncObjs{,
  IdException},
  IdStack,
  IdCoder, IdResourceStrings,
  IdTCPServer;

const
  BUFFERLEN = $4000;

  // Statistics constants
  NumberOfConnectionsType = 1;
  NumberOfPacketsType = 2;
  CompressionRatioType = 3;
  CompressedBytesType = 4;
  BytesReadType = 5;
  BytesWriteType = 6;
  NumberOfClientsType = 7;
  NumberOfSlavesType = 8;
  NumberOfServicesType = 9;

  // Message types
  tmError = 0;
  tmData = 1;
  tmDisconnect = 2;
  tmConnect = 3;
  tmCustom = 99;

type
  TIdStatisticsOperation = (soIncrease,
    soDecrease
    );

  TIdHeader = record
    CRC16: Word;
    MsgType: Word;
    MsgLen: Word;
    UserId: Word;
    Port: Word;
    IpAddr: TIdInAddr;
  end;

  TIdCoderCRC16 = object(TIdCoder)
  private
    FSum: Word;
    FCheckSumSize: Integer;
    FName: string;
    function GetString: string;
    function GetTheByte(Index: Integer): Byte; virtual;
  protected
    function GetByte(Index: Integer): Byte;
    procedure SetCheckSum(Value: Word);
  public
     { constructor Create(AOwner: TComponent); override;
     } procedure Reset; virtual;//override;
//    procedure Process(const Data; Size: Integer);
    property Sum: Word read FSum;
    property Name: string read FName;
    property Size: Integer read FCheckSumSize;
    property Bytes[Index: Integer]: Byte read GetTheByte;
    property AsString: string read GetString;
    function CalcCRC16(var Buffer; Length: LongInt): Word;
  end;
PIdCoderCRC16=^TIdCoderCRC16;
function NewIdCoderCRC16(AOwner: PControl):PIdCoderCRC16;
type

  TReceiver = object(TObj)
  private
    fiPrenosLen: LongInt;
    fiMsgLen: LongInt;
    fsData: string;
    fbNewMessage: Boolean;
    fCRCFailed: Boolean;
    Locker: TCriticalSection;
    CRCCalculator: TIdCoderCRC16;
    function FNewMessage: Boolean;
    procedure SetData(const Value: string);
  public
    pBuffer: PChar;
    HeaderLen: Integer;
    Header: TIdHeader;
    MsgLen: Word;
    TypeDetected: Boolean;
    Msg: PChar;
    property Data: string read fsData write SetData;
    property NewMessage: Boolean read FNewMessage;
    property CRCFailed: Boolean read fCRCFailed;
    procedure ShiftData;
     { constructor Create;
     } destructor Destroy; 
   virtual; end;
PReceiver=^TReceiver;
function NewReceiver:PReceiver;

type

  TSender = object(TObj)
  public
    Header: TIdHeader;
    DataLen: Word;
    HeaderLen: Integer;
    pMsg: PChar;
    Locker: TCriticalSection;
    CRCCalculator: TIdCoderCRC16;
  public
    Msg: string;
//    procedure PrepareMsg(var Header: TIdHeader;
//      buffer: PChar; buflen: Integer);
     { constructor Create;
     } destructor Destroy; 
   virtual; end;
PSender=^TSender;
function NewSender:PSender;

 type  

  TLogger = object(TObj)
  private
    OnlyOneThread: TCriticalSection;
    fLogFile: TextFile;
    fbActive: Boolean;
  public
    property Active: Boolean read fbActive default False;
    procedure LogEvent(Msg: string);
     { constructor Create(LogFileName: string);
     } destructor Destroy; 
   virtual; end;
PLogger=^TLogger;
function NewLogger(LogFileName: string):PLogger;

//  TSendMsgEvent = procedure(Thread: TIdPeerThread; var CustomMsg: string) of
//    object;
//  TSendTrnEvent = procedure(Thread: TIdPeerThread; var Header: TIdHeader; var
//    CustomMsg: string) of object;
//  TSendTrnEventC = procedure(var Header: TIdHeader; var CustomMsg: string) of
//    object;
//  TTunnelEventC = procedure(Receiver: TReceiver) of object;
//  TSendMsgEventC = procedure(var CustomMsg: string) of object;

{  EIdTunnelException = class(EIdException);
  EIdTunnelTransformErrorBeforeSend = class(EIdTunnelException);
  EIdTunnelTransformError = class(EIdTunnelException);
  EIdTunnelConnectToMasterFailed = class(EIdTunnelException);
  EIdTunnelDontAllowConnections = class(EIdTunnelException);
  EIdTunnelCRCFailed = class(EIdTunnelException);
  EIdTunnelMessageTypeRecognitionError = class(EIdTunnelException);
  EIdTunnelMessageHandlingFailed = class(EIdTunnelException);
  EIdTunnelInterpretationOfMessageFailed = class(EIdTunnelException);
  EIdTunnelCustomMessageInterpretationFailure = class(EIdTunnelException);
  EIdEIdTunnelConnectToMasterFailed = class(EIdTunnelException);}

implementation

///////////////////////////////////////////////////////////////////////////////
//
// CRC 16 Class
//
///////////////////////////////////////////////////////////////////////////////
const

  CRC16Table: array[Byte] of Word = (
    $0000, $C0C1, $C181, $0140, $C301, $03C0, $0280, $C241, $C601, $06C0, $0780,
    $C741, $0500, $C5C1, $C481, $0440, $CC01, $0CC0, $0D80, $CD41, $0F00, $CFC1,
    $CE81, $0E40, $0A00, $CAC1, $CB81, $0B40, $C901, $09C0, $0880, $C841, $D801,
    $18C0, $1980, $D941, $1B00, $DBC1, $DA81, $1A40, $1E00, $DEC1, $DF81, $1F40,
    $DD01, $1DC0, $1C80, $DC41, $1400, $D4C1, $D581, $1540, $D701, $17C0, $1680,
    $D641, $D201, $12C0, $1380, $D341, $1100, $D1C1, $D081, $1040, $F001, $30C0,
    $3180, $F141, $3300, $F3C1, $F281, $3240, $3600, $F6C1, $F781, $3740, $F501,
    $35C0, $3480, $F441, $3C00, $FCC1, $FD81, $3D40, $FF01, $3FC0, $3E80, $FE41,
    $FA01, $3AC0, $3B80, $FB41, $3900, $F9C1, $F881, $3840, $2800, $E8C1, $E981,
    $2940, $EB01, $2BC0, $2A80, $EA41, $EE01, $2EC0, $2F80, $EF41, $2D00, $EDC1,
    $EC81, $2C40, $E401, $24C0, $2580, $E541, $2700, $E7C1, $E681, $2640, $2200,
    $E2C1, $E381, $2340, $E101, $21C0, $2080, $E041, $A001, $60C0, $6180, $A141,
    $6300, $A3C1, $A281, $6240, $6600, $A6C1, $A781, $6740, $A501, $65C0, $6480,
    $A441, $6C00, $ACC1, $AD81, $6D40, $AF01, $6FC0, $6E80, $AE41, $AA01, $6AC0,
    $6B80, $AB41, $6900, $A9C1, $A881, $6840, $7800, $B8C1, $B981, $7940, $BB01,
    $7BC0, $7A80, $BA41, $BE01, $7EC0, $7F80, $BF41, $7D00, $BDC1, $BC81, $7C40,
    $B401, $74C0, $7580, $B541, $7700, $B7C1, $B681, $7640, $7200, $B2C1, $B381,
    $7340, $B101, $71C0, $7080, $B041, $5000, $90C1, $9181, $5140, $9301, $53C0,
    $5280, $9241, $9601, $56C0, $5780, $9741, $5500, $95C1, $9481, $5440, $9C01,
    $5CC0, $5D80, $9D41, $5F00, $9FC1, $9E81, $5E40, $5A00, $9AC1, $9B81, $5B40,
    $9901, $59C0, $5880, $9841, $8801, $48C0, $4980, $8941, $4B00, $8BC1, $8A81,
    $4A40, $4E00, $8EC1, $8F81, $4F40, $8D01, $4DC0, $4C80, $8C41, $4400, $84C1,
    $8581, $4540, $8701, $47C0, $4680, $8641, $8201, $42C0, $4380, $8341, $4100,
    $81C1, $8081, $4040
    );

 { constructor TIdCoderCRC16.Create;
 } 
function NewIdCoderCRC16(AOwner: PControl):PIdCoderCRC16;
begin
//  inherited Create(AOwner);
  New( Result, Create );
end;

function TIdCoderCRC16.CalcCRC16(var Buffer; Length: LongInt): Word;
begin
  Reset;
//  Process(Buffer, Length);

  Result := Sum;
end;

{procedure TIdCoderCRC16.Process(const Data; Size: Integer);
var
  S: Word;
  i: Integer;
  P: PChar;
begin
  S := Sum;

  P := @Data;
  for i := 1 to Size do
    S := CRC16Table[(Ord(P[i - 1]) xor S) and 255] xor (S shr 8);
  SetCheckSum(S);
end;}

procedure TIdCoderCRC16.Reset;
begin
  SetCheckSum(0);
end;

procedure TIdCoderCRC16.SetCheckSum(Value: Word);
begin
  FSum := Value;
end;

function TIdCoderCRC16.GetString: string;
const
  HexDigits: array[0..15] of Char = '0123456789abcdef';
var
  i: Integer;
  B: Byte;
begin
  Result := '';

  for i := 1 to Size do
  begin
    B := Bytes[i - 1];
    Result := Result + HexDigits[B shr 4] + HexDigits[B and 15];
  end;
end;

function TIdCoderCRC16.GetTheByte(Index: Integer): Byte;
begin
{  if (Index < 0) or (Index >= FCheckSumSize) then
    raise ERangeError.CreateFmt(RSTunnelGetByteRange, [ClassName, 0, Size - 1])
  else
    Result := GetByte(Index);}
end;

function TIdCoderCRC16.GetByte(Index: Integer): Byte;
begin
  case Index of
    0: Result := (FSum shr 8);
    1: Result := FSum and 255;
  else
    Result := 0;
  end;
end;

 { constructor TSender.Create;
 } 
function NewSender:PSender;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
  Locker := TCriticalSection.Create;
//  CRCCalculator := TIdCoderCRC16.Create(nil);
  HeaderLen := SizeOf(TIdHeader);
  GetMem(pMsg, BUFFERLEN);
end;  
end;

destructor TSender.Destroy;
 begin
  FreeMem(pMsg, BUFFERLEN);
  Locker.Free;
  CRCCalculator.Free;
  inherited;
end;

{procedure TSender.PrepareMsg(var Header: TIdHeader;
  buffer: PChar; buflen: Integer);
begin
  Locker.Enter;
  try
    Header.CRC16 := CRCCalculator.CalcCRC16(buffer^, buflen);
    Header.MsgLen := Headerlen + bufLen;
    Move(Header, pMsg^, Headerlen);
    Move(buffer^, (pMsg + Headerlen)^, bufLen);
    SetLength(Msg, Header.MsgLen);
    SetString(Msg, pMsg, Header.MsgLen);
  finally
    Locker.Leave;
  end;
end;}

 { constructor TReceiver.Create;
 }
function NewReceiver:PReceiver;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
  Locker := TCriticalSection.Create;
//  CRCCalculator := TIdCoderCRC16.Create(nil);
  fiPrenosLen := 0;
  fsData := '';
  fiMsgLen := 0;
  HeaderLen := SizeOf(TIdHeader);
  GetMem(pBuffer, BUFFERLEN);
  GetMem(Msg, BUFFERLEN);
end;  
end;

destructor TReceiver.Destroy;
// virtual;
begin
  FreeMem(pBuffer, BUFFERLEN);
  FreeMem(Msg, BUFFERLEN);
  Locker.Free;
  CRCCalculator.Free;
  inherited;
end;

function TReceiver.FNewMessage: Boolean;
begin
  Result := fbNewMessage;
end;

procedure TReceiver.SetData(const Value: string);
var
  CRC16: Word;
begin
  Locker.Enter;
  try
    try
      fsData := Value;
      fiMsgLen := Length(fsData);
      if fiMsgLen > 0 then
      begin
        Move(fsData[1], (pBuffer + fiPrenosLen)^, fiMsgLen);
        fiPrenosLen := fiPrenosLen + fiMsgLen;
        if (fiPrenosLen >= HeaderLen) then
        begin
          Move(pBuffer^, Header, HeaderLen);
          TypeDetected := True;
          if Header.MsgLen <= fiPrenosLen then
          begin
            MsgLen := Header.MsgLen - HeaderLen;
            Move((pBuffer + HeaderLen)^, Msg^, MsgLen);
            CRC16 := CRCCalculator.CalcCRC16(Msg^, MsgLen);
            if CRC16 <> Header.CRC16 then
            begin
              fCRCFailed := True;
            end
            else
            begin
              fCRCFailed := False;
            end;
            fbNewMessage := True;
          end
          else
          begin
            fbNewMessage := False;
          end;
        end
        else
        begin
          TypeDetected := False;
        end;
      end
      else
      begin
        fbNewMessage := False;
        TypeDetected := False;
      end;
    except
      raise;
    end;

  finally
    Locker.Leave;
  end;
end;

procedure TReceiver.ShiftData;
var
  CRC16: Word;
begin
  Locker.Enter;
  try
    fiPrenosLen := fiPrenosLen - Header.MsgLen;
    if fiPrenosLen > 0 then
    begin
      Move((pBuffer + Header.MsgLen)^, pBuffer^, fiPrenosLen);
    end;

    if (fiPrenosLen >= HeaderLen) then
    begin
      Move(pBuffer^, Header, HeaderLen);
      TypeDetected := True;
      if Header.MsgLen <= fiPrenosLen then
      begin
        MsgLen := Header.MsgLen - HeaderLen;
        Move((pBuffer + HeaderLen)^, Msg^, MsgLen);
        CRC16 := CRCCalculator.CalcCRC16(Msg^, MsgLen);
        if CRC16 <> Header.CRC16 then
        begin
          fCRCFailed := True;
        end
        else
        begin
          fCRCFailed := False;
        end;
        fbNewMessage := True;
      end
      else
      begin
        fbNewMessage := False;
      end;
    end
    else
    begin
      TypeDetected := False;
    end;
  finally
    Locker.Leave;
  end;
end;

 { constructor TLogger.Create(LogFileName: string);
 } 
function NewLogger (LogFileName: string):PLogger;
begin
New( Result, Create );
with Result^ do
begin
  fbActive := False;
  OnlyOneThread := TCriticalSection.Create;
  try
    AssignFile(fLogFile, LogFileName);
    Rewrite(fLogFile);
    fbActive := True;
  except
    fbActive := False;
  end;
end;
end;

destructor TLogger.Destroy;
// virtual;
 begin
  if fbActive then
    CloseFile(fLogFile);
  OnlyOneThread.Free;
  inherited;
end;

procedure TLogger.LogEvent(Msg: string);
begin
  OnlyOneThread.Enter;
  try
    WriteLn(fLogFile, Msg);
    Flush(fLogFile);
  finally
    OnlyOneThread.Leave;
  end;
end;

end.
