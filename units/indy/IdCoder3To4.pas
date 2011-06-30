// 27-nov-2002
unit IdCoder3To4;

interface

uses KOL { , 
  Classes } ,
  IdCoder{,
  IdException};

const
  // Coding Table Length (CTL) values
  CTL3To4 = 64;
  HalfCodeTable = CTL3To4 div 2;
  Base64CodeTable: string =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  UUCodeTable: string =
    '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
  XXCodeTable: string =
    '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  UUTable = 'TABLE'; {do not localize}
  UUBegin = 'BEGIN '; {do not localize}
  UUEnd = 'END'; {do not localize}
  minPriv = 600;
  maxPriv = 799;

  // fState values for TIdUUDecoder
  UUStarted = 0;
  UUTableBegun = 1;
  UUTableOneLine = 2;
  UUTableBeenRead = 3;
  UUDataStarted = 4;
  UUBEGINFound = 5;
  UUPrivilegeFound = 6;
  UUInitialLength = 8;
  UULastCharFound = 9;
  UUENDFound = 10;

  // These are to be removed once debugging is done...
  UUErrTableNotAtEnd = UUTable = ' not at end of line'; {do not localize}
  UUErrIncompletePrivilege = 'Not enough chars for three-digit Privilege';
    {do not localize}
  UUErrIncompletePrivilege2 = 'Too many chars for three-digit Privilege';
    {do not localize}
  UUErrorPivilageNotNumeric = 'Privilege chars not numeric'; {do not localize}
  UUErrorNoBEGINAfterTABLE = 'No BEGIN statement followed a TABLE';
    {do not localize}
  UUErrorDataEndWithoutEND = ' Data ended without an END statment';
    {do not localize}

type
  TIdCardinalBytes = record
    case integer of
      0: (
        Byte1: Byte;
        Byte2: Byte;
        Byte3: Byte;
        Byte4: Byte; );
      1: (Whole: Cardinal);
  end;

  TIdASCIICoder = object(TIdCoder)
  protected
    FCodingTable: string;
    FCodeTableLength: Integer;
    //
    function GetTableIndex(const AChar: Char): Integer;
    procedure SetCodingTable(NewTable: string); virtual;
  public
    procedure Init; virtual;
    property CodingTable: string read FCodingTable write SetCodingTable;
     { constructor Create(AOwner: TComponent); override;
   } end;
PIdASCIICoder=^TIdASCIICoder;
function NewIdASCIICoder(AOwner: PControl):PIdASCIICoder;
type

  TId3To4Coder = object(TIdASCIICoder)
  protected
    procedure Code3To4(In1, In2, In3: Byte; var Out1, Out2, Out3, Out4: Byte);
    procedure Code4To3(const AIn1, AIn2, AIn3, AIn4: Byte; var AOut1, AOut2,
      AOut3: Byte);

    function CodeLine3To4: string;
    function CompleteLine3To4: string;

    function CodeLine4To3: string;
  public
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
   virtual; end;
PId3To4Coder=^TId3To4Coder;
function NewId3To4Coder(AOwner: PControl):PId3To4Coder;
 type

//  PIdBase64Encoder = ^TIdBase64Encoder;
  TIdBase64Encoder = object(TId3To4Coder)
  protected
    procedure Coder; virtual;//override;
    procedure CompleteCoding; virtual;//override;
  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
   virtual;
   procedure Init; virtual;
    end;
PIdBase64Encoder=^TIdBase64Encoder;
function NewIdBase64Encoder(AOwner: PControl):PIdBase64Encoder;
type

//  PIdBase64Decoder = ^TIdBase64Decoder;
  TIdBase64Decoder = object(TId3To4Coder)
  protected
    procedure Coder; virtual;//override;
    procedure CompleteCoding; virtual;//override;
  public
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
   virtual; end;
PIdBase64Decoder=^TIdBase64Decoder;
function NewIdBase64Decoder(AOwner: PControl):PIdBase64Decoder;
type

//  PIdUUEncoder = ^TIdUUEncoder;
  TIdUUEncoder = object(TId3To4Coder)
  protected
    FTableNeeded: Boolean;
    FIsFirstRound: Boolean;

    FPrivilege: Integer;

    procedure Coder;virtual;// override;
    procedure CompleteCoding; virtual;//override;

    procedure OutputHeader; virtual;
  public
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; procedure SetCodingTable(NewTable: string);virtual;// override;
    procedure SetPrivilege(Priv: Integer);

    property Privilege: Integer read FPrivilege write SetPrivilege;
    property TableNeeded: Boolean read FTableNeeded write FTableNeeded;
  end;
PIdUUEncoder=^TIdUUEncoder;
function NewIdUUEncoder(AOwner: PControl):PIdUUEncoder;
type

//  PIdUUDecoder = ^TIdUUDecoder;
  TIdUUDecoder = object(TId3To4Coder)
  protected
    FError, FCompleted: Boolean;
    FErrList: PStrList;//TStringList;
    FState: Integer;
    FRealBufferSize: Integer;
    FIsFirstRound: Boolean;

    FPrivilege: Integer;

    procedure Coder; virtual;//override;
    procedure CompleteCoding; virtual;//override;
    procedure CheckForHeader(DataSize: Integer); virtual;
  public
    procedure Init; virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; procedure SetCodingTable(NewTable: string); virtual;//override;
    procedure SetPrivilege(Priv: Integer);

    property Privilege: Integer read FPrivilege write SetPrivilege;
  end;
PIdUUDecoder=^TIdUUDecoder;
function NewIdUUDecoder(AOwner: PControl):PIdUUDecoder;
type

//  PIdXXEncoder = ^TIdXXEncoder;
  TIdXXEncoder = object(TIdUUEncoder)
  public
    procedure Init;   virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
   virtual; end;
PIdXXEncoder=^TIdXXEncoder;
function NewIdXXEncoder(AOwner: PControl):PIdXXEncoder;
type

//  PIdXXDecoder = ^TIdXXDecoder;
  TIdXXDecoder = object(TIdUUDecoder)
  public
    procedure Init;  virtual;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
   virtual; end;
PIdXXDecoder=^TIdXXDecoder;
function NewIdXXDecoder(AOwner: PControl):PIdXXDecoder;
{ type  MyStupid16179=DWord;
  EIdTableNotFound = object(EIdException);
PdXXDecoder=^IdXXDecoder; type  MyStupid37223=DWord;}

function Base64Encode(const s: string): string;

implementation

uses
  IdGlobal, IdMIMETypes, IdResourceStrings,
  SysUtils;

function FetchEOL(var s: string): string;
var
  iCR, iLF: Integer;
begin
  iCR := IndyPos(CR, s);
  iLF := IndyPos(LF, s);
  if (iCR = 0) then
  begin
    if iLF = 0 then
    begin
      result := s;
      s := '';
    end
    else
    begin
      result := Fetch(s, LF);
    end;
  end
  else
    if (iCR = iLF - 1) then
  begin
    result := Fetch(s, CR + LF);
  end
  else
    if (iCR < iLF) or (iLF = 0) then
  begin
         // CR on it's own
    result := Fetch(s, CR);
  end
  else
  begin
         // iLF < iCR
    result := Fetch(s, LF);
  end;
end;

//constructor TIdASCIICoder.Create;
function NewIdASCIICoder(AOwner: PControl):PIdASCIICoder;
begin
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
//  inherited Create(AOwner);
  if FCodeTableLength > 0 then
  begin
    SetLength(FCodingTable, FCodeTableLength);
    UniqueString(FCodingTable);
  end;
  fTakesFileName := True;
end;}
end;

procedure TIdASCIICoder.Init;
begin
//  with Result^ do
begin
  inherited;// Create(AOwner);
  if FCodeTableLength > 0 then
  begin
    SetLength(FCodingTable, FCodeTableLength);
    UniqueString(FCodingTable);
  end;
  fTakesFileName := True;
end;
end;

function TIdASCIICoder.GetTableIndex(const AChar: Char): Integer;
begin
  Result := IndyPos(AChar, FCodingTable) - 1;
  if Result = -1 then
  begin
//    raise EIdTableNotFound.Create(RSCoderNoTableEntryNotFound);
  end;
end;

procedure TIdASCIICoder.SetCodingTable;
begin
  FCodingTable := NewTable;
end;

//constructor TId3To4Coder.Create;
function NewId3To4Coder(AOwner: PControl):PId3To4Coder;
begin
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
  FCodeTableLength := CTL3To4;
//  inherited Create(AOwner);
end;    }
end;

procedure TId3To4Coder.Init;
begin
//  with Result^ do
begin
  FCodeTableLength := CTL3To4;
  inherited;
//  inherited Create(AOwner);
end;
end;

destructor TId3To4Coder.Destroy;
begin
  inherited;
end;

procedure TId3To4Coder.Code3To4;
begin
  Out1 := Ord(FCodingTable[((In1 shr 2) and 63) + 1]);
  Out2 := Ord(FCodingTable[(((In1 shl 4) or
      (In2 shr 4)) and 63) + 1]);
  Out3 := Ord(FCodingTable[(((In2 shl 2) or
      (In3 shr 6)) and 63) + 1]);
  Out4 := Ord(FCodingTable[(Ord(In3) and 63) + 1]);
end;

procedure TId3To4Coder.Code4To3(const AIn1, AIn2, AIn3, AIn4: Byte; var AOut1,
  AOut2, AOut3: Byte);
var
  LCardinal: TIdCardinalBytes;
begin
  LCardinal.Whole := (GetTableIndex(Chr(AIn1)) shl 18) or
    (GetTableIndex(Chr(AIn2)) shl 12)
    or (GetTableIndex(Chr(AIn3)) shl 6) or GetTableIndex(Chr(AIn4));
  AOut1 := LCardinal.Byte3;
  AOut2 := LCardinal.Byte2;
  AOut3 := LCardinal.Byte1;
end;

function TId3To4Coder.CodeLine3To4;
var
  i, j: LongWord;
begin
  i := FCBufferSize * 4;
  j := i div 3 * 3;
  if i <> j then
  begin
    Inc(j, 4);
  end;
  j := j div 3;
  SetLength(result, j);
  UniqueString(result);

  i := 1;
  j := 1;
  while i <= FCBufferedData do
  begin
    Code3To4(Ord(FCBuffer[i]), Ord(FCBuffer[i + 1]), Ord(FCBuffer[i + 2]),
      Byte(result[j]), Byte(result[j + 1]), Byte(result[j + 2]),
      Byte(result[j + 3]));
    Inc(i, 3);
    Inc(j, 4);
  end;

  FCBufferedData := 0;
end;

function TId3To4Coder.CompleteLine3To4;
var
  i, j, k: LongWord;
begin

  k := FCBufferedData div 3;
  j := k * 4;
  k := k * 3;

  if FCBufferedData <> k then
  begin
    Inc(j, 4);
  end;
  SetLength(result, j);
  UniqueString(result);

  i := 1;
  j := 1;
  while i <= k do
  begin
    Code3To4(Ord(FCBuffer[i]), Ord(FCBuffer[i + 1]), Ord(FCBuffer[i + 2]),
      Byte(result[j]), Byte(result[j + 1]), Byte(result[j + 2]),
      Byte(result[j + 3]));
    Inc(i, 3);
    Inc(j, 4);
  end;

  k := FCBufferedData - k;
  if k > 0 then
  begin
    case k of
      1:
        begin
          Code3To4(Ord(FCBuffer[i]), 0, 0,
            Byte(result[j]), Byte(result[j + 1]), Byte(result[j + 2]),
            Byte(result[j + 3]));
        end;
      2:
        begin
          Code3To4(Ord(FCBuffer[i]), Ord(FCBuffer[i + 1]), 0,
            Byte(result[j]), Byte(result[j + 1]), Byte(result[j + 2]),
            Byte(result[j + 3]));
        end;
      3:
        begin
          Code3To4(Ord(FCBuffer[i]), Ord(FCBuffer[i + 1]), Ord(FCBuffer[i + 2]),
            Byte(result[j]), Byte(result[j + 1]), Byte(result[j + 2]),
            Byte(result[j + 3]));
        end;
    end;
  end;
  FCBufferedData := 0;
end;

function TId3To4Coder.CodeLine4To3;
var
  i: LongWord;
  s: string;
  y1, y2, y3: Byte;
begin
  i := 1;
  s := '';
  while i < FCBufferedData do
  begin
    Code4To3(Ord(FCBuffer[i]), Ord(FCBuffer[i + 1]), Ord(FCBuffer[i + 2]),
      Ord(FCBuffer[i + 3]), y1
      , y2, y3);
    s := s + Chr(y1) + Chr(y2) + Chr(y3);
    Inc(i, 4);
  end;
  result := s;
end;

function NewIdBase64Encoder(AOwner: PControl):PIdBase64Encoder;
//constructor TIdBase64Encoder.Create;
begin
  New( Result, Create );
  Result.Init;
{with Result^ do
//  inherited Create(AOwner);
  FCodingTable := Base64CodeTable;}
end;

procedure TIdBase64Encoder.Init;
begin
//  with Result^ do
inherited;//  inherited Create(AOwner);
  FCodingTable := Base64CodeTable;

end;

destructor TIdBase64Encoder.Destroy;
begin
  inherited;
end;

procedure TIdBase64Encoder.Coder;
var
  s: string;
begin
  IncByteCount(FCBufferedData);
  s := CodeLine3To4;
  OutputString(s);
end;

procedure TIdBase64Encoder.CompleteCoding;
var
  s: string;
  i: LongWord;
begin
  fInCompletion := True;

  if FCBufferedData = 0 then Exit;
  IncByteCount(FCBufferedData);

  i := FCBufferedData div 3 * 3;
  i := FCBufferedData - i;

  s := CompleteLine3To4;

  case i of
    1:
      begin
        s[Length(s) - 1] := '=';
        s[Length(s)] := '=';
      end;
    2:
      begin
        s[Length(s)] := '=';
      end;

  end;

  OutputString(s);
end;

function Base64Encode(const s: string): string;
var
  Coder: PIdBase64Encoder;//TIdBase64Encoder;
    {I do this as a workaround for a bug}
  Res: string;
begin
  Result := '';
  Coder := NewIdBase64Encoder(nil);//TIdBase64Encoder.Create(nil);
  try
    Coder.AddCRLF := False;
    Coder.UseEvent := False;
    Coder.Reset;
    Coder.CodeString(s);
    Res := Coder.CompletedInput;
    Result := Copy(Res, 3, Length(Res));
  finally
    FreeAndNil(Coder);
  end;
end;

//constructor TIdBase64Decoder.Create;
function NewIdBase64Decoder(AOwner: PControl):PIdBase64Decoder;
begin
New( Result, Create );
Result.Init;
{with Result^ do
//  inherited Create(AOwner);
  FCodingTable := Base64CodeTable;}
end;

procedure TIdBase64Decoder.Init;
begin
//  with Result^ do
inherited;//  inherited Create(AOwner);
  FCodingTable := Base64CodeTable;
end;

destructor TIdBase64Decoder.Destroy;
begin
  inherited;
end;

procedure TIdBase64Decoder.Coder;
var
  s, s1, sOut: string;
  bCount: LongWord;
  exWhile: Boolean;
begin
  if FCBufferedData = 0 then Exit;

  exWhile := False;

  bCount := FCBufferedData;
  s1 := Copy(FCBuffer, 1, FCBufferedData);
  sOut := '';
  while not exWhile do
  begin
    s := FetchEOL(s1);
    if Length(s) = 0 then
    begin
      s := FetchEOL(s1);
    end;
    FCBufferedData := length(s);
    System.Move(s[1], FCBuffer[1], FCBufferedData);
    sOut := sOut + CodeLine4To3;
    if IndyPos(CR, s1) = 0 then
    begin
      exWhile := True;
    end;
  end;
  FCBufferedData := length(s1);
  IncByteCount(bCount - FCBufferedData);
  if FCBufferedData > 0 then
  begin
    System.Move(s1[1], FCBuffer[1], FCBufferedData);
  end;
  OutputString(sOut);
end;

procedure TIdBase64Decoder.CompleteCoding;
var
  s, s1, sOut: string;
  k: Integer;
  in1, in2, in3, in4: Byte;
  y1, y2, y3: Byte;
begin
  fInCompletion := True;

  if FCBufferedData = 0 then Exit;

  IncByteCount(FCBufferedData);

  s1 := Copy(FCBuffer, 1, FCBufferedData);
  while IndyPos(CR, s1) > 0 do
  begin
    sOut := FetchEOL(s1);
    s1 := sOut + s1;
  end;
  while IndyPos(LF, s1) > 0 do
  begin
    sOut := FetchEOL(s1);
    s1 := sOut + s1;
  end;
  FCBufferedData := Length(s1);

  sOut := '';
  while length(s1) > 4 do
  begin
    s := Copy(s1, 1, 4);
    s1 := Copy(s1, 5, length(s1));

    Code4To3(Byte(s[1]), Byte(s[2]), Byte(s[3]), Byte(s[4]), y1, y2, y3);
    sOut := sOut + Chr(y1) + Chr(y2) + Chr(y3);
  end;

  while (Length(s1) > 0) and (s1[length(s1)] = '=') do
  begin
    s1 := Copy(s1, 1, length(s1) - 1);
  end;

  k := Length(s1);

  if k > 0 then
  begin
    in3 := Byte(FCodingTable[1]);
    in4 := Byte(FCodingTable[1]);
    in1 := Byte(s1[1]);
    in2 := Byte(s1[2]);

    case k of
      1:
        begin
          Code4To3(in1, in2, in3, in4, y1, y2, y3);
          sOut := sOut + Chr(y1);
        end;
      2:
        begin
          in2 := Byte(s1[2]);
          Code4To3(in1, in2, in3, in4, y1, y2, y3);

          In2 := GetTableIndex(Chr(In2));
          if In2 and 15 = 0 then
          begin
            sOut := sOut + Chr(y1);
          end
          else
          begin
            sOut := sOut + Chr(y1) + Chr(y2);
          end;
        end;
      3:
        begin
          in2 := Byte(s1[2]);
          In3 := Byte(s1[3]);
          Code4To3(in1, in2, in3, in4, y1, y2, y3);

          In3 := GetTableIndex(Chr(In3));

          if In3 <= FCodeTableLength shr 2 then
          begin
            sOut := sOut + Chr(y1) + Chr(y2);
          end
          else
          begin
            sOut := sOut + Chr(y1) + Chr(y2) + Chr(In3 shl 6);
          end;
        end;
      4:
        begin
          in2 := Byte(s1[2]);
          In3 := Byte(s1[3]);
          In4 := Byte(s1[4]);
          Code4To3(In1, In2, In3, In4, y1, y2, y3);
          sOut := sOut + Chr(y1) + Chr(y2) + Chr(y3);
        end;
    end;
  end;

  OutputString(sOut);
  FCBufferedData := 0;
end;

function NewIdUUEncoder(AOwner: PControl):PIdUUEncoder;
//constructor TIdUUEncoder.Create;
begin
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
//  inherited Create(AOwner);
  FCodingTable := UUCodeTable;
  FPrivilege := 644;
  FIsFirstRound := True;
  FTableNeeded := False;
  FAddCRLF := True;
//  InternSetBufferSize(61);
end; }
end;

procedure TIdUUEncoder.Init;
begin
//  with Result^ do
begin
inherited;//  inherited Create(AOwner);
  FCodingTable := UUCodeTable;
  FPrivilege := 644;
  FIsFirstRound := True;
  FTableNeeded := False;
  FAddCRLF := True;
  InternSetBufferSize(61);
end;
end;

destructor TIdUUEncoder.Destroy;
begin
  inherited;
end;

procedure TIdUUEncoder.OutputHeader;
var
  s: string;
begin
  if TableNeeded then
  begin
    OutputString(UUTable);
    s := Copy(FCodingTable, 1, FCodeTableLength div 2);
    OutputString(s);
    s := Copy(FCodingTable, FCodeTableLength div 2 + 1,
      FCodeTableLength shl 2);
    OutputString(s);
  end;

  s := UUBegin + IntToStr(FPrivilege) + ' ' + FFileName;
  OutputString(s);

  FIsFirstRound := False;
end;

procedure TIdUUEncoder.SetCodingTable;
begin
  if Length(NewTable) >= FCodeTableLength then
  begin
    FCodingTable := Copy(NewTable, 1, FCodeTableLength);
  end
  else
  begin
    FCodingTable := NewTable + Copy(FCodingTable,
      FCodeTableLength + 1, FCodeTableLength - Length(NewTable));
  end;
end;

procedure TIdUUEncoder.SetPrivilege(Priv: Integer);
begin
  if (Priv >= minPriv) and (Priv <= maxPriv) then
  begin
    FPrivilege := Priv;
  end;
end;

procedure TIdUUEncoder.Coder;
var
  s: string;
begin
  if FIsFirstRound then
  begin
    OutputHeader;
  end;
  IncByteCount(FCBufferedData);
  s := FCodingTable[FCBufferSize + 1] + CodeLine3To4;
  OutputString(s);
end;

procedure TIdUUEncoder.CompleteCoding;
var
  s, s1: string;
begin
  fInCompletion := True;
  if FIsFirstRound then
  begin
    OutputHeader;
  end;

  if FCBufferedData = 0 then
  begin
    OutputString(FCodingTable[1]);
    OutputString(UUEnd);
    Exit;
  end;

  IncByteCount(FCBufferedData);

  s := FCodingTable[FCBufferedData + 1] + CompleteLine3To4;
  s1 := string(s + CR + LF);
  OutputString(s1);
  s1 := string(FCodingTable[1] + CR + LF);
  OutputString(s1);
  s1 := string(UUEnd + CR + LF);
  OutputString(s1);
end;

//constructor TIdUUDecoder.Create;
function NewIdUUDecoder(AOwner: PControl):PIdUUDecoder;
begin
  New( Result, Create );
  Result.Init;
{with Result^ do
begin
//  inherited Create(AOwner);
  FCodingTable := UUCodeTable;
  FPrivilege := 644;
  FIsFirstRound := True;
//  FErrList := TStringList.Create;
  FError := False;
  fInCompletion := False;
  FCompleted := false;
  FState := UUStarted;
  FRealBufferSize := FCBufferSize;
//  InternSetBufferSize(UUInitialLength);
  end;}
end;

procedure TIdUUDecoder.Init;
begin
//  with Result^ do
begin
inherited;//  inherited Create(AOwner);
  FCodingTable := UUCodeTable;
  FPrivilege := 644;
  FIsFirstRound := True;
  FErrList := NewStrList;//TStringList.Create;
  FError := False;
  fInCompletion := False;
  FCompleted := false;
  FState := UUStarted;
  FRealBufferSize := FCBufferSize;
  InternSetBufferSize(UUInitialLength);
  end;
end;

destructor TIdUUDecoder.Destroy;
begin
  inherited;
end;

procedure TIdUUDecoder.SetCodingTable;
begin
  if Length(NewTable) >= FCodeTableLength then
  begin
    FCodingTable := Copy(NewTable, 1, FCodeTableLength);
  end
  else
  begin
    FCodingTable := NewTable + Copy(FCodingTable,
      FCodeTableLength + 1, FCodeTableLength - Length(NewTable));
  end;
end;

procedure TIdUUDecoder.SetPrivilege(Priv: Integer);
begin
  if (Priv >= minPriv) and (Priv <= maxPriv) then
  begin
    FPrivilege := Priv;
  end;
end;

procedure TIdUUDecoder.CheckForHeader;
var
  i: LongWord;
  t, b: Integer;
  s, s1: string;
  err: Boolean;
begin
  if DataSize = 0 then Exit;

  s := Copy(FCBuffer, 1, DataSize);

  case FState of
    UUStarted:
      begin

        i := IndyPos(UUTable, UpperCase(s));
        if i > 0 then
        begin

          s := Copy(s, i + SizeOf(UUTable), length(s));
          s1 := FetchEOL(s);

          IncByteCount(i + SizeOf(UUTable) + LongWord(Length(s1)));

          FState := UUTableBegun;
          OutputNotification(CN_UU_TABLE_FOUND, '');
          InternSetBufferSize((FCodeTableLength div 2 + 2));

          if Length(s) > 0 then
          begin
            CodeString(s);
          end;
        end
        else
        begin
          i := IndyPos(UUBegin, UpperCase(s));
          if i > 0 then
          begin
            s := Copy(s, i + SizeOf(UUBegin) + 1, Length(s));

            IncByteCount(i + SizeOf(UUTable) + 1);
            i := Length(s);

            s := TrimLeft(s);

            IncByteCount(i - LongWord(length(s)));

            FState := UUBEGINFound;
            OutputNotification(CN_UU_BEGIN_FOUND, '');

            InternSetBufferSize(3);

            FCBufferedData := Length(s);
            if FCBufferedData > 0 then
            begin
              System.Move(s[1], FCBuffer[1], FCBufferedData);
            end;
          end
          else
          begin
            if fInCompletion then
            begin
              IncByteCount(FCBufferedData);
              FCBufferedData := 0;
            end
            else
            begin
              i := Length(s);
              s := Copy(s, 3, length(s));
              t := IndyPos('T', UpperCase(s));
              b := IndyPos('B', UpperCase(s));
              if t < b then
              begin
                if t = 0 then
                begin
                  if b = 0 then
                  begin
                    s := '';
                  end
                  else
                  begin
                    s := Copy(s, b, length(s));
                  end;
                end
                else
                begin
                  s := Copy(s, t, length(s));
                end;
              end
              else
              begin
                if b = 0 then
                begin
                  if t = 0 then
                  begin
                    FCBufferedData := 0;
                  end
                  else
                  begin
                    s := Copy(s, t, length(s));
                  end;
                end
                else
                begin
                  s := Copy(s, b, length(s));
                end;
              end;
              if s <> '' then
              begin
                FCBufferedData := Length(s);
                IncByteCount(i - FCBufferedData);
                System.Move(s[1], FCBuffer[1], FCBufferedData);
              end
              else
              begin
                IncByteCount(FCBufferedData);
                FCBufferedData := 0;
              end;
            end;
          end;
        end;
      end;

    UUTableBegun:
      begin
        SetCodingTable(Copy(s, 1, FCodeTableLength div 2));
        s := Copy(s, FCodeTableLength div 2 + 1, length(s));
        s1 := FetchEOL(s);
        IncByteCount(length(s1));
        FState := UUTableOneLine;
        FCBufferedData := 0;
        if Length(s) > 0 then
        begin
          CodeString(s);
        end;
      end;

    UUTableOneLine:
      begin
        SetCodingTable(Copy(FCodingTable, 1, FCodeTableLength div 2) +
          Copy(s, 1, FCodeTableLength div 2));
        FState := UUTableBeenRead;
        s := Copy(s, FCodeTableLength div 2 + 1, Length(s));
        s1 := FetchEOL(s);
        IncByteCount(length(s1));
        InternSetBufferSize(UUInitialLength);
        if Length(s) > 0 then
        begin
          CodeString(s);
        end;
      end;

    UUTableBeenRead:
      begin
        i := IndyPos(UUBEGIN, UpperCase(s));
        if i > 0 then
        begin
          i := i + 1 + SizeOf(UUBEGIN);
          s := Copy(s, i, length(s));
          IncByteCount(i);

          FState := UUBEGINFound;
          OutputNotification(CN_UU_BEGIN_FOUND, '');

          InternSetBufferSize(3);
          i := Length(s);
          s := TrimLeft(s);
          IncByteCount(i - LongWord(Length(s)));
          if Length(s) > 0 then
          begin
            CodeString(s);
          end;
        end
        else
        begin
          FState := UUStarted;
          OutputNotification(CN_UU_TABLE_BEGIN_ABORT, '');
          FError := True;
          FErrList.Add(UUErrorNoBEGINAfterTable);
        end;
      end;

    UUBEGINFound:
      begin
        if length(s) = 3 then
        begin
          err := False;
          for i := 1 to 3 do
          begin
            if not IsNumeric(s[1]) then
            begin
              err := True;
            end;
          end;

          if err then
          begin
            FError := True;
            FErrList.Add(UUErrorPivilageNotNumeric);
            OutputNotification(CN_UU_PRIVILEGE_ERROR, '');
          end
          else
          begin
            FPrivilege := StrToInt(s);
            OutputNotification(CN_UU_PRIVILEGE_FOUND, IntToStr(FPrivilege));
          end;

        end
        else
          if length(s) < 3 then
        begin
          FError := True;
          FErrList.Add(UUErrIncompletePrivilege);
          OutputNotification(CN_UU_PRIVILEGE_ERROR, '');

        end
        else
        begin
          FError := True;
          FErrList.Add(UUErrIncompletePrivilege2);
          OutputNotification(CN_UU_PRIVILEGE_ERROR, '');
        end;
        FState := UUPrivilegeFound;
        IncByteCount(3);
        InternSetBufferSize($FF);
      end;

    UUPrivilegeFound:
      begin
        i := Length(s);
        s := TrimLeft(s);
        IncByteCount(i - LongWord(length(s)));

        s1 := FetchEOL(s);
        FFileName := s1;
        OutputNotification(CN_UU_NEW_FILENAME, FFileName);

        FIsFirstRound := False;
        InternSetBufferSize(FRealBufferSize);

        FCBufferedData := 0;
        if Length(s) > 0 then
        begin
          CodeString(s);
        end;
      end;
  end;
end;

procedure TIdUUDecoder.Coder;
var
  s, s1: string;
  outlen, inlen: Integer;
begin
  if FCompleted then Exit;

  if FIsFirstRound then
  begin
    CheckForHeader(FCBufferSize);
  end
  else
  begin
    s1 := Copy(FCBuffer, 1, FCBufferSize);

    s := FetchEOL(s1);
    if Length(s) = 0 then
    begin
      s := FetchEOL(s1);
    end;
    IncByteCount(length(s));

    if FState = UULastCharFound then
    begin

      if Copy(s, 1, Length(UUEnd)) = UUEnd then
      begin
        OutputNotification(CN_UU_END_FOUND, '');
      end
      else
      begin
      end;

      Reset;

    end
    else
      if s[1] = FCodingTable[1] then
    begin
      FState := UULastCharFound;
      OutputNotification(CN_UU_LAST_CHAR_FOUND, '');

    end
    else
    begin
      outlen := GetTableIndex(s[1]);
      if Outlen = 0 then
      begin
        FCompleted := True;
      end;
      inLen := outLen div 3 * 4;

      System.Move(s[2], FCBuffer[1], inLen);
      IncByteCount(FCBufferedData - LongWord(inLen));
      FCBufferedData := inLen;
      s := CodeLine4To3;

      OutputString(Copy(s, 1, outLen));

      FCBufferedData := Length(s1);
      if FCBufferedData > 0 then
      begin
        System.Move(s1[1], FCBuffer[1], FCBufferedData);
      end;
    end;
  end;
end;

procedure TIdUUDecoder.CompleteCoding;
var
  s, s1, s2: string;
  i, j, step, outlen: Integer;
begin
  if FCompleted then Exit;
  IncByteCount(FCBufferedData);

  fInCompletion := True;
  if FIsFirstRound then
  begin
    CheckForHeader(FCBufferedData);
    if (FCBufferedData > 0) and FIsFirstRound then
    begin
      CompleteCoding;
    end;
  end;

  if not FIsFirstRound then
  begin
    if FCBufferedData = 0 then Exit;

    s1 := Copy(FCBuffer, 1, FCBufferedData);
    while s1[1] <> FCodingTable[1] do
    begin
      OutLen := GetTableIndex(s1[1]);
      SetLength(s2, OutLen + 4);

      s := FetchEOL(s1);
      s := Copy(s, 2, length(s));
      j := 1;
      i := 1;
      while i <= length(s) do
      begin
        Code4To3(Ord(s[i]), Ord(s[i + 1]), Ord(s[i + 2]),
          Ord(s[i + 3]), Byte(s2[j]), Byte(s2[j + 1]),
          Byte(s2[j + 2]));
        Inc(j, 3);
        Inc(i, 4);
      end;

      step := Length(s) - i;

      if step >= 1 then
      begin
        case step of
          1:
            begin
              Code4To3(Ord(s[i]), 0, 0, 0,
                Byte(s2[j]), Byte(s2[j + 1]), Byte(s2[j + 2]));
            end;
          2:
            begin
              Code4To3(Ord(s[i]), Ord(s[i + 1]), 0, 0,
                Byte(s2[j]), Byte(s2[j + 1]), Byte(s2[j + 2]));
            end;
          3:
            begin
              Code4To3(Ord(s[i]), Ord(s[i + 1]), Ord(s[i + 2]), 0,
                Byte(s2[j]), Byte(s2[j + 1]), Byte(s2[j + 2]));
            end;
          4:
            begin
              Code4To3(Ord(s[i]), Ord(s[i + 1]), Ord(s[i + 2]), Ord(s[i + 3]),
                Byte(s2[j]), Byte(s2[j + 1]), Byte(s2[j + 2]));
            end;
        end;

      end;
      if length(s1) = 0 then
      begin
        FErrList.Add(UUErrorDataEndWithoutEND);
        break;
      end;
      OutputString(Copy(s2, 1, outLen));
    end;
    FCBufferedData := 0;
  end;
end;

//constructor TIdXXEncoder.Create;
function NewIdXXEncoder(AOwner: PControl):PIdXXEncoder;
begin
New( Result, Create );
Result.Init;
{with Result^ do
//  inherited Create(AOwner);
  FCodingTable := XXCodeTable;}
end;

procedure TIdXXEncoder.Init;
begin
//  with Result^ do
inherited; //  inherited Create(AOwner);
  FCodingTable := XXCodeTable;
end;

destructor TIdXXEncoder.Destroy;
begin
  inherited;
end;

//constructor TIdXXDecoder.Create;
function NewIdXXDecoder(AOwner: PControl):PIdXXDecoder;
begin
New( Result, Create );
Result.Init;
{with Result^ do
//  inherited Create(AOwner);

  FCodingTable := XXCodeTable;}
end;

procedure TIdXXDecoder.Init;
begin
//  with Result^ do
inherited;//  inherited Create(AOwner);

  FCodingTable := XXCodeTable;
end;

destructor TIdXXDecoder.Destroy;
begin
  inherited;
end;

initialization
//  RegisterCoderClass(nil{TIdBase64Encoder}, CT_CREATION, CP_STANDARD,
//    '', MIMEEncBase64);
{  RegisterCoderClass(TIdBase64Decoder, CT_REALISATION, CP_STANDARD,
    '', MIMEEncBase64);
  RegisterCoderClass(TIdUUEncoder, CT_CREATION, CP_STANDARD,
    '', MIMEEncUUEncode);
  RegisterCoderClass(TIdUUDecoder, CT_REALISATION, CP_STANDARD,
    '', MIMEEncUUEncode);
  RegisterCoderClass(TIdXXEncoder, CT_CREATION, CP_STANDARD,
    '', MIMEEncXXEncode);
  RegisterCoderClass(TIdXXDecoder, CT_REALISATION, CP_STANDARD,
    '', MIMEEncXXEncode);}
end.
