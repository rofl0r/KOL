unit delay;
{
       Unit: Delay
    purpose: All purpose Delay line for 32 bit float Audioprocessing in KOL
     Author: Thaddy de Koning
  Copyright: 2003, Thaddy de Koning
    Remarks: Loosely based on a C++ example found in the musicdsp.pdf file
             The delay has an arbitrary maximum value of one second
             i.e a full samplerate

    Bufferlength = Buffersize in Number of Samples
    Delay        = Delay time in Milliseconds
    Interpolate  = Switch between non-interpolating and interpolating delay
    Samplerate   = Samplerate in Hz
    FillBuffer   : Fills the Buffer with a specified value
    Process      : Processes a single 32 float sample

}

interface

uses kol, AudioUtils;

type
  PDelay = ^TDelay;

  Tdelay = object(Tobj)
  protected
    FInterPolate: boolean;
    FBufferlength: cardinal;
    FDelay: single;
    Fbuffer: array of single;
    offset,
    Fsamplerate: single;
    Readptr, readp2, WritePtr: integer;
    outPointer: single;
    alpha,
    alpha2,
    alpha3,
    omAlpha,
    coeff,
    lag,
    lastIn,
    ym1,
    y0,
    y1,
    y2: single;
    procedure SetBufferlength(const Value: cardinal);
    procedure SetDelay(const Value: single);
    procedure SetInterPolate(const Value: boolean);
    procedure SetSampleRate(const Value: single);
  public
    destructor Destroy; virtual;
    procedure FillBuffer(Value: single);
    property Bufferlength: cardinal read FBufferlength write SetBufferlength;
    function Process(input: single): single;
    property Delay: single read FDelay write SetDelay;
    property SampleRate: single read FSampleRate write SetSampleRate;
    property InterPolate: boolean read FInterPolate write SetInterPolate;
  end;

function NewDelay(Buflen: integer; Interpolate: boolean): PDelay;

implementation

{ Tdelay }
function NewDelay(Buflen: integer; Interpolate: boolean): PDelay;
begin
  New(Result, Create);
  with Result^ do
  begin
    Fsamplerate:=44100;
    setlength(FBuffer, Buflen);
    Fbufferlength := Buflen;
    Finterpolate := Interpolate;
    lastIn := 0;
    Readptr := 0;
    WritePtr := FBufferlength shr 1;
  end;
end;

destructor Tdelay.Destroy;
begin
  setlength(FBuffer, 0);
  inherited;
end;

procedure Tdelay.FillBuffer(Value: single);
var
  x: integer;
begin
  for x := 0 to FBufferlength - 1 do
    Fbuffer[x] := Value;
end;

function Tdelay.Process(input: single): single;
var
  Output: single;
  ym1p, y1p, y2p: integer;
begin
  output := 0;
  if FBufferlength > f_trunc(Samplerate) then
  begin
    Result := 0;
    exit;
  end;
  Fbuffer[WritePtr] := input;
  if (Finterpolate) then
  begin
    ym1p := Readptr - 1;
    if (ym1p < 0) then
      ym1p := ym1p + FBufferlength;
    y1p := Readptr + 1;
    if (y1p >= FBufferlength) then
      y1p := y1p - FBufferlength;
    y2p := Readptr + 2;
    if (y2p >= FBufferlength) then
      y2p := y2p - FBufferlength;
    ym1 := Fbuffer[ym1p];
    y0 := Fbuffer[Readptr];
    y1 := Fbuffer[y1p];
    y2 := Fbuffer[y2p];

    output := (alpha3 * (y0 - y1 + y2 - ym1) +
      alpha2 * (-2 * y0 + y1 - y2 + 2 * ym1) +
      alpha * (y1 - ym1) + y0);
  end
  else
    output := Fbuffer[Readptr];

  inc(WritePtr);
  if (WritePtr >= FBufferlength) then
    WritePtr := WritePtr - FBufferlength;
  inc(Readptr);
  if (Readptr >= FBufferlength) then
    Readptr := Readptr - FBufferlength;
  Result := output;
end;

procedure Tdelay.SetBufferlength(const Value: cardinal);
begin
  FBufferlength := Value;
end;

procedure Tdelay.SetDelay(const Value: single);
begin
  Fdelay := Value;
  offset := Value * Fsamplerate * 0.001;

  if (offset < 0.1) then
    offset := 0.1
  else if (offset >= FBufferlength) then
    offset := FBufferlength - 1;

  outPointer := WritePtr - offset;
  if (outPointer < 0) then
    outPointer := outpointer + FBufferlength;

  Readptr := f_trunc(outPointer);
  alpha := outPointer - Readptr;
  alpha2 := alpha * alpha;
  alpha3 := alpha2 * alpha;
end;

procedure Tdelay.SetInterPolate(const Value: boolean);
begin
  FInterPolate := Value;
end;

procedure Tdelay.SetSampleRate(const Value: single);
begin
  setdelay(1000 * offset / samplerate);
  Fsamplerate := samplerate;
end;

end.

