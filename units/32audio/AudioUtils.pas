{
********************************************************************
VSTUtils
Otiginally a unit to extend the VST SDK with some useful functions.
expanded with generic audioprocessing utilities by Thaddy de Koning

Based upon Frederic Vanmol's DVstUtils.pas, but with some
extensions by Tobybear and Thaddy.
You can easily use this instead
of the original DVstUtils.pas

I have also translated some of TobyBear's functions to assembler as well
as making this KOL compatible,

Note that most assembler functions would run more efficient if
written in external assembler. (Because of superfluous stack allocations,
result allocation and register pushing by the compiler)
I have incluede remarks to that extend where appropiate.

Thaddy
********************************************************************
}

unit AudioUtils;

interface


type
  PPERect = ^PERect;
  PERect = ^ERect;
  ERect = record 
    top, left, bottom, right: smallint;
  end;

  // Frederic's functions:

function FourCharToLong(C1, C2, C3, C4: char): longint;
  // Converts four chars to a longint in the format required
  // by Cubase VST for the identifier of the effect.

function FMod(d1, d2: double): double;
  // Gets the remainder after the floating point division of d1 and d2.


procedure dB2string(Value: single; Text: PChar);
  // Converts value to a null terminated string representation in decibels.

procedure dB2stringRound(Value: single; Text: PChar);
  // Converts value to a null terminated string representation in decibels
  // after having rounded it.

procedure float2string(const Value: single; Text: PChar);
  // Converts the floating point variable value to a null terminated string
  // representation.

procedure long2string(Value: longint; Text: PChar);
  // Converts the integer variable value to a null terminated string
  // representation.

procedure float2stringAsLong(Value: single; Text: PChar);
  // Converts the floating point variable value to a null terminated string
  // representation with nothing after the decimal point.

procedure Hz2string(samples, sampleRate: single; Text: PChar);
  // Converts samples in combination with sampleRate to Hz.

procedure ms2string(samples, sampleRate: single; Text: PChar);
  // Converts samples in combination with sampleRate to milliseconds.

function gapSmallValue(Value, MaxValue: double): double;
  // Converts value (between 0 and 1) to an unevenly spread representation
  // between 0 and maxValue. Unevenly spread means lower values take longer
  // to change while higher values change quicker.

function invGapSmallValue(Value, MaxValue: double): double;
  // This is the inverse operation of gapSmallValue. When you have altered
  // the value internally with gapSmallValue and Cubase requests this value,
  // use this function to return the representation between 0 and 1 from
  // a range of 0 to maxValue.

  // Tobybear's functions:
function GetDLLFilename: string;

function GetDLLDirectory: string;

function f_limit(v, l, u: single): single;
function dB_to_Amp(g: single): single;
function Amp_to_dB(v: single): single;
function linear_interpolation(f, a, b: single): single;
function cubic_interpolation(fr, inm1, inp, inp1, inp2: single): single;
function f_frac(x: single): single;
function f_int(x: single): single;
function f_trunc(f: single): integer;
function f_round(f: single): integer;
function f_exp(x: single): single;

const
  _pi = 3.1415926536;
function f_ln2(f: single): single;
function f_floorln2(f: single): longint;
function f_abs(f: single): single;
function f_neg(f: single): single;
function f_root(i: single; n: integer): single;
function f_power(i: single; n: integer): single;
function f_log2(val: single): single;
function f_arctan(fValue: single): single;
function f_sin(fAngle: single): single;
function f_cos(fAngle: single): single;
function f_sgn(f: single): longint;
function f_clip(x, l, h: single): single;
function f_cliplo(x, l: single): single;
function f_cliphi(x, h: single): single;

  // scale logarithmicly from 20 Hz to 20 kHz
function FreqLinearToLog(Value: single): single;
function FreqLogToLinear(Value: single): single;
function OnOff(fvalue: single): boolean;



  //Thaddy's functions

// This prevents the FPU from entering denormal mode on very small values
// This precision is not necessary for Audio and can slow down the processing
// by as much as 700% !! in some cases.(Both Intel and AMD processors suffer
// from this problem)
// You should always check your code for denormal numbers as it leads to
// hickups and potentially crashes in realtime audio processing
function undenormalize(fvalue: single): single;

// An alternative is to add a very small, but itself not a denormal, value
// before you enter a calculation that can cause a denormal value
// This cancels out in the audio, but is large enough to prevent the FPU
// going haywire. see below

// You should choose your strategy based on your application, though.
// Not any of the two methods is best:
// The function is more accurate but is slower,
// The addition is very fast but may propagate into the result.
// A third way is adding a small amount of white noise to the audio signal
// before processing.
// If you do that from a buffer, the speed is very good, but you may pollute
// the cache. If the processor cache is not important for your processing
// type, or irrelevant, i.e. much different tasks going on to process one single
// sample, this may be the best solution for pristine audioquality.

const
  kDenorm   = 1.0e-25;

  //Converts 16 bit integers to 32 bit floating point
procedure ConvertInt16toFloats(const Inbuffer: array of smallint;
  var Outbuffer: array of single; SampleCount: integer);

  //Converts 32 bitfloating point to 16 bit integers
procedure ConvertFloatsToInt16(const Inbuffer: array of single;
  var Outbuffer: array of smallint; SampleCount: integer);

  //Splits a 16 bit interleaved stereo file into two 32 bit floating point channels
procedure SplitChannels16ToFloatStereo(const Data: array of smallint; var ld: array of single;
  var RD: array of single; Samples: integer);

  //Splits an interleaved 32 bit stereo file into two 32 bit floating point channels
procedure SplitChannels32ToFloatStereo(const Data: array of single; var Ld: array of single;
  var Rd: array of single; Samples: integer);

  //Two distortions
function Distort(Value: single; Amount: single): single;
function Distort2(Value: single; Amount: single): single;

  // Tube-like Soft saturation
function saturate(Value, t: single): single;

  //BitCrusher, works on smallints
function KeepBitsFrom16(input: smallint; keepBits: integer): smallint;


implementation

uses kolmath, kol, windows;

//Value = input in [-1..1]
//y = output
function Distort(Value: single; Amount: single): single; register;
var
  k: single;
begin
  k := Undenormalize(2 * amount / (1 - amount));
  Result := (1 + k) * Value / (1 + Value * f_abs(Value))
end;

function Distort2(Value: single; Amount: single): single; register;
var
  z, s, b: single;
begin
  z := pi * amount;
  s := 1 / sin(z);
  b := 1 / amount;
  if Value > b then
    Result := 1
  else
    Result := sin(Value * z) * s;
end;

function saturate(Value, t: single): single; register;
begin
  //This can be looped from unknown source, so den. Value
  //Threshold T is under our control
  Value:=Undenormalize(Value);
  if f_abs(Value) < t then
    Result := Value
  else
  begin
    if (Value > 0) then
      Result := t + (1 - t) * tanh((Value - t) / (1 - t))
    else
      Result := -(t + (1 - t) * tanh((-Value - t) / (1 - t)));
  end;
end;

function KeepBitsFrom16(input: smallint; keepBits: integer): smallint;
begin
  Result := (input and (-1 shl (16 - keepBits)));
end;

procedure ConvertInt16toFloats(const Inbuffer: array of smallint;
  var Outbuffer: array of single; SampleCount: integer);
var
  i: integer;
begin
  for i := 0 to Samplecount - 1 do
    Outbuffer[i] := Inbuffer[i] * (1.0 / 32767.0);
end;

procedure ConvertFloatsToInt16(const Inbuffer: array of single;
  var Outbuffer: array of smallint; SampleCount: integer);
var
  i: integer;
begin
  for i := 0 to SampleCount - 1 do
    Outbuffer[i] := f_trunc(Inbuffer[i] * 32767);
end;

procedure SplitChannels16ToFloatStereo(const Data: array of smallint; var ld: array of single;
  var RD: array of single; Samples: integer);
var
  Tempdata: array of single;
  i, j: integer;
begin
  setlength(Tempdata, samples * 2);
  ConvertInt16ToFloats(Data, tempdata, samples);
  j := 0;
  for i := 0 to samples - 1 do
  begin
    ld[i] := Tempdata[j];
    inc(j);
    Rd[i] := Tempdata[j];
    inc(j);
  end;
  setlength(Tempdata, 0);
end;

procedure SplitChannels32ToFloatStereo(const Data: array of single; var Ld: array of single;
  var Rd: array of single; Samples: integer);
var
  i, j: integer;
begin
  j := 0;
  for i := 0 to (Samples div 2) - 1 do
  begin
    Ld[i] := Data[j];
    inc(j);
    Rd[i] := Data[j];
    inc(j);
  end;
end;


function FourCharToLong(C1, C2, C3, C4: char): longint;
begin
  Result := Ord(C4) + (Ord(C3) shl 8) + (Ord(C2) shl 16) + (Ord(C1) shl 24);
end;

function FMod(d1, d2: double): double;
var 
  i: integer;
begin
  if d2 = 0 then
    Result := High(longint)
  else
  begin
    Result := f_Trunc(d1 / d2);
    Result := d1 - (Result * d2);
  end;
end;

function DbtoFloat(Value: single): single;
begin
  if Value <= 0 then Value := 0.1;
  Result := 20 * Log10(Value);
end;

procedure dB2string(Value: single; Text: PChar);
begin
  if (Value <= 0) then StrCopy(Text, '   -oo  ')
  else 
    float2string(20 * log10(Value), Text);
end;

procedure dB2stringRound(Value: single; Text: PChar);
begin
  if (Value <= 0) then StrCopy(Text, '    -96 ')
  else 
    long2string(Round(20 * log10(Value)), Text);
end;

procedure float2string(const Value: single; Text: PChar);
begin
  if Value < 0 then
    StrCopy(Text, PChar(Format('%s', ['-' + Num2Bytes(f_abs(Value))])))
  else
    StrCopy(Text, PChar(Format('%s', [Num2Bytes(Value)])))
end;

procedure long2string(Value: longint; Text: PChar);
begin
  if (Value >= 100000000) then
  begin
    StrCopy(Text, ' Huge!  ');
    Exit;
  end;
  StrCopy(Text, PChar(Format('%7d', [Value])));
end;

procedure float2stringAsLong(Value: single; Text: PChar);
begin
  if (Value >= 100000000) then
  begin
    StrCopy(Text, ' Huge!  ');
    Exit;
  end;
  StrCopy(Text, PChar(Format('%7.0f', [Value])));
end;

procedure Hz2string(samples, sampleRate: single; Text: PChar);
begin
  if (samples = 0) then float2string(0, Text)
  else 
    float2string(sampleRate / samples, Text);
end;

procedure ms2string(samples, sampleRate: single; Text: PChar);
begin
  float2string(samples * 1000 / sampleRate, Text);
end;

function gapSmallValue(Value, MaxValue: double): double;
begin
  Result := Power(MaxValue, Value);
end;

function invGapSmallValue(Value, MaxValue: double): double;
begin
  Result := 0;
  if (Value <> 0) then Result := logN(MaxValue, Value);
end;

function GetDLLFilename: string;
var
  st: string;
begin
  setlength(st, 1500);
  getmodulefilename(hinstance, PChar(st), 1500);
  Result := extractfilename(trim(st));
end;

function GetDLLDirectory: string;
var
  st: string;
begin
  setlength(st, 1500);
  getmodulefilename(hinstance, PChar(st), 1500);
  Result := ExtractFilepath(trim(st));
end;

const 
  LN2R = 1.442695041;

  // Limit a value to be l<=v<=u
function f_limit(v, l, u: single): single;
begin
  if v < l then Result := l
  else if v > u then Result := u 
  else 
    Result := v;
end;

// Convert a value in dB's to a linear amplitude
function dB_to_Amp(g: single): single;
begin
  if (g>-90.0) then Result := power(10,g * 0.05)
  else 
    Result := 0;
end;

function Amp_to_dB(v: single): single;
begin
  Result := (20 * log10(v));
end;

function linear_interpolation(f, a, b: single): single;
begin
  Result := (1 - f) * a + f * b;
end;

function cubic_interpolation(fr, inm1, inp, inp1, inp2: single): single;
begin
  Result := inp + 0.5 * fr * (inp1 - inm1 + fr *
    (4 * inp1 + 2 * inm1 - 5 * inp - inp2 + fr * (3 * (inp - inp1) - inm1 + inp2)));
end;

const 
  half: double = 0.5;

function f_trunc(f: single): integer;
asm
  fld f
  fsub half
  fistp result
end;

function f_frac(x: single): single;
begin
  Result := x - f_trunc(x);
end;

function f_int(x: single): single;
begin
  Result := f_trunc(x);
end;

function f_round(f: single): integer;
begin
  Result := round(f);
end;

function f_exp(x: single): single;
begin
  Result := power(2,x * LN2R);
end;

function f_Sin(fAngle: single): single;
var
  fASqr, fres: single;
begin
  fASqr := fAngle * fAngle;
  fRes := 7.61e-03;
  fRes := fRes * fASqr;
  fRes := fRes - 1.6605e-01;
  fRes := fRes * fASqr;
  fRes := fRes + 1;
  fRes := fRes * fAngle;
  Result := fRes;
end;

function f_Cos(fAngle: single): single;
var
  fASqr, fRes: single;
begin
  fASqr := fAngle * fAngle;
  fRes := 3.705e-02;
  fRes := fRes * fASqr;
  fRes := fRes - 4.967e-01;
  fRes := fRes * fASqr;
  fRes := fRes + 1;
  fRes := fRes * fAngle;
  Result := fRes;
end;

function f_arctan(fValue: single): single;
var
  fVSqr, fRes: single;
begin
  fVSqr := fValue * fValue;
  fRes := 0.0208351;
  fRes := fRes * fVSqr;
  fRes := fRes - 0.085133;
  fRes := fRes * fVSqr;
  fRes := fRes + 0.180141;
  fRes := fRes * fVSqr;
  fRes := fRes - 0.3302995;
  fRes := fRes * fVSqr;
  fRes := fRes + 0.999866;
  fRes := fRes * fValue;
  Result := fRes;
end;

function f_ln2(f: single): single;
begin
  Result := (((longint((@f)^) and $7f800000) shr 23) - $7f) +
    (longint((@f)^) and $007fffff) / $800000;
end;


function f_floorLn2(f: single): longint; assembler;
asm
  mov eax,f
  and eax,$7F800000
  shr eax,23
  sub eax,$7f
end;

function f_abs(f: single): single; assembler;
asm
  mov eax,f
  and eax, $7FFFFFFF;
  mov @result,eax;
end;

function f_neg(f: single): single; assembler;
asm
  mov eax,f
  xor eax,$80000000
  mov @result,eax;
end;

function f_sgn(f: single): longint; assembler;
asm
  mov edx, f
  shr edx, 31
  add edx, edx
  xor eax, eax     //faster than mov eax,1
  inc eax          //
  sub eax, edx
end;

//here the compiler did a better job, TdK
function f_log2(val: single): single;
var
  log2, x: longint;
begin
  x := longint((@val)^);
  log2 := ((x shr 23) and 255) - 128;
  x := x and (not (255 shl 23));
  x := x + 127 shl 23;
  Result := single((@x)^) + log2;
end;

//Tiny bit faster
//If you rewrite this in external assembler you must push ecx!!
function f_power(i: single; n: integer): single; assembler;
asm
  sub i, $3f800000
  mov ecx,n
  dec ecx
  shl i, cl
  add i,$3F800000
  mov eax,i
  mov @result, eax;
end;

//Tiny bit faster, do not move to eax, because of sign
//If you rewrite this in external assembler you must push ecx!!

function f_root(i: single; n: integer): single; assembler;
asm
  sub i, $3F800000
  mov ecx, n
  dec ecx
  shr i, cl
  add i, $3f800000
  mov eax,i
  mov @result,eax
end;

//Change geberates more efficient code
//Can't improve on the compiler generated code, TdK
function f_cliplo(x, l: single): single;
begin
  x := X - l;
  Result := (x + f_abs(x)) * 0.5 + l;
end;

//Change geberates more efficient code
//Can't improve on the compiler generated code, TdK
function f_cliphi(x, h: single): single;
begin
  x := h - x;
  Result := h - (x + f_abs(x)) * 0.5;
end;

//idem
//Can't improve on the compiler generated code, TdK
function f_clip(x, l, h: single): single;
var
  x1, x2: single;
begin
  Result := (f_abs(x - l) + (l + h) - (f_abs(x - h))) * 0.5;
end;

// scale logarithmicly from 20 Hz to 20 kHz
function FreqLinearToLog(Value: single): single;
begin
  Result := (20.0 * power(2.0,Value * 9.965784284662088765571752446703612804412841796875));
end;

function FreqLogToLinear(Value: single): single;
begin
  Result := (ln(Value / 20) / ln(2)) / 9.965784284662088765571752446703612804412841796875;
end;

function OnOff(fvalue: single): boolean;
begin
  Result := fvalue > 0.5
end;

// Much faster than even a C style float to int cast and more secure
function undenormalize(fValue: single): single; assembler;
asm
  mov  eax, fvalue
  test eax, $7F800000
  jnz  @exit
  xor  eax, eax
@exit:
  mov  @result,eax
end;

end.

