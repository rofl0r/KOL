// 25-nov-2002
unit IdCoderText;

interface

uses KOL { , 
  Classes } ,
  IdCoder;

type
  TIdQuotedPrintableEncoder = object(TIdCoder)
  protected
    FQPOutputString: string;
    procedure QPOutput(const sOut: string); virtual;
    function ToQuotedPrintable(const b: Byte): string;
    procedure Coder; virtual;//override;
    procedure CompleteCoding; virtual;//override;

  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; procedure Reset; virtual;//override;
  end;
PIdQuotedPrintableEncoder=^TIdQuotedPrintableEncoder;
function NewIdQuotedPrintableEncoder(AOwner: PControl):PIdQuotedPrintableEncoder;
type

  TIdQuotedPrintableDecoder = object(TIdCoder)
  protected
    fQPTriple: string;
    fInTriple: Byte;
    procedure Coder; virtual;//override;
    procedure CompleteCoding; virtual;//override;
  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; procedure Reset; virtual;//override;
  end;
PIdQuotedPrintableDecoder=^TIdQuotedPrintableDecoder;
function NewIdQuotedPrintableDecoder(AOwner: PControl):PIdQuotedPrintableDecoder;

implementation

uses
  IdGlobal;

const
  QPLowBound = 32;
  QPMidBound = 61;
  QPHighBound = 126;
  QPEDBDIC = '!"#$@[\]^`{|}~';

  function NewIdQuotedPrintableEncoder(AOwner: PControl):PIdQuotedPrintableEncoder;
  //constructor TIdQuotedPrintableEncoder.Create;
begin
//  inherited Create(AOwner);
  New( Result, Create );
with Result^ do
begin
  fAddCRLF := False;
  FQPOutputString := '';
end;
end;

destructor TIdQuotedPrintableEncoder.Destroy;
begin
  inherited;
end;

procedure TIdQuotedPrintableEncoder.Reset;
begin
  FQPOutputString := '';
end;

procedure TIdQuotedPrintableEncoder.Coder;
var
  i: LongWord;
  b: Byte;
  s: string;
begin
  s := '';
  i := 1;
  while i <= FCBufferSize do
  begin
    b := Byte(FCBuffer[i]);
    if (b >= QPLowBound) and (b <= QPHighBound) then
    begin
      if b = QPMidBound then
      begin
        s := s + ToQuotedPrintable(QPMidBound);
      end
      else
        if IndyPos(Char(b), QPEDBDIC) > 0 then
      begin
        s := s + ToQuotedPrintable(b);
      end
      else
      begin
        s := s + Char(b);
      end;
    end
    else
    begin
      if b = Byte(CR) then
      begin
        if i < FCBufferSize then
        begin
          if FCBuffer[i + 1] = LF then
          begin
            s := s + EOL;
            Inc(i);
          end
          else
          begin
            s := s + ToQuotedPrintable(b);
          end;
        end
        else
        begin
          FCBufferedData := 1;
          FCBuffer[1] := Char(b);
          QPOutput(s);
          Exit;
        end;
      end
      else
      begin
        s := s + ToQuotedPrintable(b);
      end;
    end;
    Inc(i);
  end;
  QPOutput(s);
  FCBufferedData := 0;
end;

procedure TIdQuotedPrintableEncoder.QPOutput;
var
  s: string;
  i: LongWord;
begin
  FQPOutputString := FQPOutputString + sOut;
  i := IndyPos(EOL, FQPOutputString);
  while i > 0 do
  begin
    s := Copy(FQPOutputString, 1, i - 1);
    FQPOutputString := Copy(FQPOutputString, i + 2, length(FQPOutputString));
    i := length(s);
    if i > 0 then
    begin
      case s[i] of
        ' ', TAB:
          begin
            s := s + Copy(ToQuotedPrintable(Byte(s[i])), 2, 2);
            s[i] := '=';
          end;
      else
        s := s + CR + LF;
      end;
    end
    else
    begin
      s := CR + LF;
    end;
    OutputString(s);
    i := IndyPos(EOL, FQPOutputString);
  end;
  while length(FQPOutputString) > 75 do
  begin
    if FQPOutputString[73] = '=' then
    begin
      i := 72;
    end
    else
      if FQPOutputString[74] = '=' then
    begin
      i := 73;
    end
    else
      if FQPOutputString[75] = '=' then
    begin
      i := 74;
    end
    else
    begin
      i := 75;
    end;
    OutputString(Copy(FQPOutputString, 1, i) + '=');
    FQPOutputString := Copy(FQPOutputString, i + 1, length(FQPOutputString));
  end;
end;

procedure TIdQuotedPrintableEncoder.CompleteCoding;
var
  i, j: LongWord;
begin
  fInCompletion := True;
  i := FCBufferSize;
//  InternSetBufferSize(FCBufferedData);
  FCBufferedData := FCBufferSize;
  if FCBufferedData > 0 then
  begin
    Coder;
  end;
  if FCBufferedData > 0 then
  begin
    QPOutput(ToQuotedPrintable(13));
  end;
  j := Length(FQPOutputString);
  if j > 0 then
  begin
    case FQPOutputString[j] of
      ' ', TAB:
        begin
          FQPOutputString := FQPOutputString + Copy(ToQuotedPrintable(
            Byte(FQPOutputString[j])), 2, 2);
          FQPOutputString[j] := '=';
        end;
    end;
    while length(FQPOutputString) > 75 do
    begin
      if FQPOutputString[73] = '=' then
      begin
        i := 72;
      end
      else
        if FQPOutputString[74] = '=' then
      begin
        i := 73;
      end
      else
        if FQPOutputString[75] = '=' then
      begin
        i := 74;
      end
      else
      begin
        i := 75;
      end;
      OutputString(Copy(FQPOutputString, 1, i) + '=');
      FQPOutputString := Copy(FQPOutputString, i + 1, length(FQPOutputString));
    end;
    OutputString(FQPOutputString);
  end;
//  InternSetBufferSize(i);
  FCBufferedData := 0;
end;

function TIdQuotedPrintableEncoder.ToQuotedPrintable;
begin
  result := '=' + UpperCase(Int2Hex(b, 2));
end;

function NewIdQuotedPrintableDecoder(AOwner: PControl):PIdQuotedPrintableDecoder;
//constructor TIdQuotedPrintableDecoder.Create;
begin
//  inherited Create(AOwner);
  New( Result, Create );
with Result^ do
begin
  fQPTriple := '';
  SetLength(fQPTriple, 2);
  UniqueString(fQPTriple);
  fAddCRLF := False;
  fInTriple := 0;
end;
end;

destructor TIdQuotedPrintableDecoder.Destroy;
begin
  inherited;
end;

procedure TIdQuotedPrintableDecoder.Reset;
begin
  fAddCRLF := False;
  fInTriple := 0;
end;

procedure TIdQuotedPrintableDecoder.Coder;
var
  i: LongWord;
  s: string;
  c: Char;

  function IsHex(c: Char): Boolean;
  begin
    case c of
      '0'..'9', 'a'..'f', 'A'..'F':
        begin
          result := true;
        end;
    else
      result := False;
    end;
  end;

begin
  i := 1;
  s := '';
  while i <= FCBufferedData do
  begin
    c := FCBuffer[i];
    if fInTriple > 0 then
    begin
      fQPTriple[fInTriple] := c;
      Inc(fInTriple);

      if fInTriple >= 3 then
      begin
        if IsHex(fQPTriple[1]) and IsHex(fQPTriple[2]) then
        begin
          s := s + Chr(Str2Int('$' + fQPTriple));
        end
        else
          if (fQPTriple[1] = CR) and (fQPTriple[2] = LF) then
        begin
        end
        else
        begin
          s := s + '=' + fQPTriple;
        end;
        fInTriple := 0;
      end;
    end
    else
      if c = '=' then
    begin
      Inc(fInTriple);
    end
    else
    begin
      s := s + c;
    end;
    Inc(i);
  end;
  OutputString(s);
  FCBufferedData := 0;
end;

procedure TIdQuotedPrintableDecoder.CompleteCoding;
begin
  fInCompletion := True;
  Coder;
  if fInTriple > 0 then
  begin
    OutputString(Copy(fQPTriple, 1, fInTriple - 1));
    FCBufferedData := 0;
  end;
end;

initialization
{  RegisterCoderClass(TIdQuotedPrintableEncoder, CT_CREATION, CP_STANDARD,
    '', 'quoted-printable');
  RegisterCoderClass(TIdQuotedPrintableDecoder, CT_REALISATION, CP_STANDARD,
    '', 'quoted-printable');}
end.
