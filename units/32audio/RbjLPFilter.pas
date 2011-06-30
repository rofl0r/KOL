// Lowpass filter with resonance
// FCutOff: cutoff frequency (0..1), 1 is Nyquist
// FResonance: resonance 0..1
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
// The filter yields 12Db/Oct with good phase characteristics.(second order IIR}
// Driven hard it can selfoscillate

// This define uses approximation functions of sin and cos,
// defined in vstutils.
// This has a noticable effect on the sound!
{$DEFINE FAST_MATH}
unit RbjLPFilter;

interface

type

  PrbjLowPass = ^TRbjLowPass;
  TrbjLowpass = object(Tobj)
  protected
    Fsamplerate: single;
    a0, a1, a2: single;
    b1, b2: single;
    t0, t1, t2: single;
    FCutOff, FResonance: single;
    xold1, xold2: single;
    yold1, yold2: single;
    y: single;
    procedure setCutOff(const Value: single);
    procedure setResonance(const Value: single);
    procedure setsamplerate(const Value: single);
  public
    procedure init;
    function process(x: single): single;
    property samplerate: single read Fsamplerate write setsamplerate;
    property CutOff: single FCutOff write setCutOff;
    property Resonance: single FResonance write setResonance;
  end;

function NewRbjLowpass: pRbjLowPass;

implementation

uses KolMath, VstUtils;

const
  pi = 3.14159265358979323846264338;

function NewRbjLowpass: pRbjLowPass;
begin
  new(Result, Create);
  with Result^ do
  begin
    Fsamplerate := 44100;
    FCutOff := 0;
    FResonance := 0;
    t0 := 0;
    t1 := 0;
    t2 := 0;
    init;
  end;
end;

procedure TrbjLowpass.init;
begin
  xold1 := 0;
  xold2 := 0;
  yold1 := 0;
  yold2 := 0;
  y := 0;
end;

function TrbjLowpass.process(x: single): single;
begin
  // calculate temporary variables
  {$IFNDEF FAST_MATH}
  t0 := cos(pi * (0.99 * FCutOff + 0.01));
  t1 := sin(pi * (0.99 * FCutOff + 0.01)) / (2.3 * (FResonance + 0.001));
  {$ELSE}
  t0 := f_cos(pi * (0.99 * FCutOff + 0.01));
  t1 := f_sin(pi * (0.99 * FCutOff + 0.01)) / (2.3 * (FResonance + 0.001));
  {$ENDIF}
  t2 := 1 + t1;
  // calculate coefficients
  a0 := (1 - t0) / (2 * t2);
  a1 := (1 - t0) / t2;
  a2 := (1 - t0) / (2 * t2);
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



procedure TrbjLowpass.setCutOff(const Value: single);
begin
  FcutOff := Value;
end;

procedure TrbjLowpass.setResonance(const Value: single);
begin
  Fresonance := Value;
end;

procedure TrbjLowpass.setsamplerate(const Value: single);
begin
  Fsamplerate := Value;
end;

end.

