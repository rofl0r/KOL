// Bandpass filter with bandwidth control
// FCutOff: cutoff frequency (0..1), 1 is Nyquist
// FBandWidth: bandwitdh 0..1
//
// taken from:
// "rbj formulae for audio EQ biquad filter coefficients"
// by Robert Bristow-Johnson  <robert@wavemechanics.com>
// (you can find this document on www.musicdsp.org)
// Written for KOL with the Help of TobyBears FilterExplorer
// by Thaddy de Koning
//
// This filter is calculated based on comparison with an equivalent
// hardware design and has identical capabilities (and sound)
// The filter yields 12Db/Oct with good phase characteristics.(second order IIR)

// This define uses approximation functions of sin and cos,
// defined in vstutils.
// This has a noticable effect on the sound!
{$DEFINE FAST_MATH}

unit rbjBPfilter2;

interface

uses kol;

type
  PrbjBPfilter2 = ^TrbjBPfilter2;
  TrbjBPfilter2 = object(TObj)
  protected
    a0, a1, a2: single;
    b1, b2: single;
    t0, t1, t2, t3: single;
    FCutOff, FBandWidth: single;
    xold1, xold2: single;
    yold1, yold2: single;
    y: single;
    Fsamplerate: single;
    procedure setBandwith(const Value: single);
    procedure setCutOff(const Value: single);
    procedure setsamplerate(const Value: single);
  public
    procedure init;
    function process(x: single): single;
    property CutOff: single read FcutOff write setCutOff;
    property BandWidth: single read FBandwidth write setBandwith;
    property SampleRate: single read Fsamplerate write setsamplerate;
  end;
function NewrbjBPfilter2: prbjFilter2;

implementation

uses kolmath, vstutils;

const 
  pi = 3.14159265358979323846264338;

function NewrbjBPfilter2: prbjFilter2;
begin
  New(Result, Create);
  with Result^ do
  begin
    samplerate := 44100;
    FCutOff := 0;
    FBandWidth := 0;
    t0 := 0;
    t1 := 0;
    t2 := 0;
    t3 := 0;
    init;
  end;
end;


procedure TrbjBPfilter2.init;
begin
  // initialize values
  xold1 := 0;
  xold2 := 0;
  yold1 := 0;
  yold2 := 0;
  y := 0;
end;

function TrbjBPfilter2.process(x: single): single;
begin
  // calculate temporary variables
  {$IFNDEF FAST_MATH}
  t0 := cos(pi * (0.9 * FCutOff + 0.05));
  t1 := sin(pi * (0.9 * FCutOff + 0.05)) / (2 * (FBandWidth + 0.001));
  t2 := 1 + t1;
  t3 := sin(pi * (0.9 * FCutOff + 0.05));
  {$ELSE}
  t0 := f_cos(pi * (0.9 * FCutOff + 0.05));
  t1 := f_sin(pi * (0.9 * FCutOff + 0.05)) / (2 * (FBandWidth + 0.001));
  t2 := 1 + t1;
  t3 := f_sin(pi * (0.9 * FCutOff + 0.05));
  {$ENDIF}
  // calculate coefficients
  a0 := t1 / (t2);
  a2 := -t1 / (t2);
  b1 := -2 * t0 / t2;
  b2 := ((1 - t1) / t2);
  // process input
  yold2 := yold1;
  yold1 := y;
  y :=
    a2 * xold2 +
    a1 * xold1 +
    a0 * x - b2 * yold2 - b1 * yold1;
  xold2 := xold1;
  xold1 := x;
  Result := y;
end;


procedure TrbjBPfilter2.setBandwith(const Value: single);
begin
  FBandwidth := Value;
end;

procedure TrbjBPfilter2.setCutOff(const Value: single);
begin
  FcutOff := Value;
end;

procedure TrbjBPfilter2.setsamplerate(const Value: single);
begin
  Fsamplerate := Value;
end;

end.

