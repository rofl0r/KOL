// 2-pole bandpass filter
// based on the theory found in
// 'An introduction to digital filter theory'
// by Julius O. Smith
// parameters:
// CutOff: cutoff frequency (0..1), where 1 is Nyquist
// Slope: slope width (0..1)
//
// Written for KOL with the Help of TobyBears FilterExplorer
// by Thaddy de Koning
// The filter yields 12Db/Oct with good phase characteristics.(second order IIR)

// This define uses approximation functions of sin and cos,
// defined in vstutils.
// This has a noticable effect on the sound!
{$DEFINE FAST_MATH}
unit 2PoleBandpass;

interface

uses kol;

type
  P2PoleBandPass = ^T2PoleBandpass;
  T2PoleBandpass = object(TObj)
  protected
    a0, a1, a2: single;
    b1, b2: single;
    t0, t1: single;
    FCutOff, FSlope: single;
    xold1, xold2: single;
    yold1, yold2: single;
    y: single;
    Fsamplerate: single;
    procedure SetCutOff(const Value: single);
    procedure SetSamplerate(const Value: single);
    procedure SetSlope(const Value: single);
  public
    procedure init;
    function process(x: single): single;
    property CutOff: single read FCutOff write SetCutOff;
    property Slope: single read FSlope write SetSlope;
    property Samplerate: single read FSamplerate write SetSamplerate;
  end;

function New2PoleBandpass: p2polebandpass;

implementation

uses kolmath,vstutils;

const 
  pi = 3.14159265358979323846264338;

function New2PoleBandpass: p2polebandpass;
begin
  New(Result, Create);
  with Result^ do
  begin
    Fsamplerate := 44100;
    FCutOff := 0;
    FSlope := 0;
    t0 := 0;
    t1 := 0;
    init;
  end;
end;

procedure T2PoleBandpass.init;
begin
  // initialize values
  xold1 := 0;
  xold2 := 0;
  yold1 := 0;
  yold2 := 0;
  y := 0;
end;

function T2PoleBandpass.process(x: single): single;
begin
  // calculate temporary variables
  t0 := FCutOff * pi;
  t1 := FSlope * 0.99;
  // calculate coefficients
  a0 := 1 - t1;
  a2 := -(1 - t1) * t1;
  {$IFNDEF FAST_MATH}
  b1 := -2 * t1 * cos(t0);
  {$ELSE}
  b1 := -2 * t1 * f_cos(t0);
  {$ENDIF}

  b2 := t1 * t1;
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



procedure T2PoleBandpass.SetCutOff(const Value: single);
begin
  FCutOff := Value;
end;

procedure T2PoleBandpass.SetSamplerate(const Value: single);
begin
  FSamplerate := Value;
end;

procedure T2PoleBandpass.SetSlope(const Value: single);
begin
  FSlope := Value;
end;

end.

