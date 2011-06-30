// 27-nov-2002
unit IdTrivialFTPBase;

interface

uses
  IdGlobal,
  IdUDPBase, IdUDPClient;

type
  TIdTFTPMode = (tfNetAscii, tfOctet);

type
  WordStr = string[2];

function MakeAckPkt(const BlockNumber: Word): string;
function StrToWord(const Value: string): Word;
function WordToStr(const Value: Word): WordStr;

const
  TFTP_RRQ = 1;
  TFTP_WRQ = 2;
  TFTP_DATA = 3;
  TFTP_ACK = 4;
  TFTP_ERROR = 5;
  TFTP_OACK = 6;

const
  MaxWord = High(Word);
  hdrsize = 4;
  sBlockSize = 'blksize'#0;

const
  ErrUndefined = 0;
  ErrFileNotFound = 1;
  ErrAccessViolation = 2;
  ErrAllocationExceeded = 3;
  ErrIllegalOperation = 4;
  ErrUnknownTransferID = 5;
  ErrFileAlreadyExists = 6;
  ErrNoSuchUser = 7;
  ErrOptionNegotiationFailed = 8;

implementation

uses
  {IdException,}
  IdStack;

function StrToWord(const Value: string): Word;
begin
  Result := Word(pointer(@Value[1])^);
end;

function WordToStr(const Value: Word): WordStr;
begin
  SetLength(Result, SizeOf(Value));
  Move(Value, Result[1], SizeOf(Value));
end;

function MakeAckPkt(const BlockNumber: Word): string;
begin
  Result := WordToStr(GStack.WSHToNs(TFTP_ACK)) +
    WordToStr(GStack.WSHToNs(BlockNumber));
end;

end.
