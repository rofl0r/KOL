unit Oscillator;
{
       Unit: Oscillator
    purpose: Low Frequency Oscillator for modulation effects
     Author: Thaddy de Koning
  Copyright:  2003, Thaddy de Koning
    Remarks: Simple two wave form.
             The triangle wave is unsuited for Audible FOutput since
             it is not bandlimited (Nyquisr theorum!~)
    rate      : 0..maxint in (parts of) cycles
    samplerate: In Hz
    LfoType   : Either Sin or Triangle, expand if you wish
    Phase     : The phase ;-)

}

interface

uses Kol, AudioUtils;

const
  LFO_Sine = 0;
  LFO_Triangle = 1;

type
  PLfo = ^TLfo;
  Tlfo = object(Tobj)
  protected
    FLfoType: integer;
    FRate: single;
    FPhase: single;
    Ftype: integer;
    FOutput: single;
    Fsamplerate: single;
    FInc: single;
    FDirection: integer;
    c,
    s,
    ci,
    si,
    nc,
    ns: single;
    procedure SetLfoType(const Value: integer);
    procedure SetPhase(const Value: single);
    procedure SetRate(const Value: single);
    procedure SetSamplerate(const Value: single);
  public
    function Process: single;
    property Samplerate: single read FSamplerate write SetSamplerate;
    property Rate: single read FRate write SetRate;
    property LfoType: integer read FLfoType write SetLfoType;
    property Phase: single read FPhase write SetPhase;

  end;

function NewLfo: Plfo;


implementation

{ Tlfo }

function NewLfo: Plfo;
begin
  New(Result, Create);
  with Result^ do
  begin
    Ftype := 0;
    FOutput := 0;
    FInc := 0;
    FDirection := 1;
    c := 1;
    s := 0;
  end;
end;

function Tlfo.Process: single;
begin
  if (Ftype = 1) then    // triangle wave
  begin
    if (FDirection = 1) then
      FOutput := FOutput + FInc
    else
      FOutput := FOutput - FInc;

    if (FOutput >= 1) then
    begin
      FDirection := -1;
      FOutput := 1;
    end
    else if (FOutput <= 0) then
    begin
      FDirection := 1;
      FOutput := 0;
    end;
  end
  else if (Ftype = 0) then  // sine wave
  begin
    nc := c * ci - s * si;
    ns := c * si + s * ci;
    c := nc;
    s := ns;
    FOutput := (s + 1) / 2;
  end;
  Result := FOutput;
end;

procedure Tlfo.SetLfoType(const Value: integer);
begin
  FType := Value;
end;

procedure Tlfo.SetPhase(const Value: single);
begin
  FPhase := Value;
  if (Fphase >= 0) and (Fphase <= 1) then
  begin
    FOutput := Fphase;
    s := Fphase;
  end;
end;

procedure Tlfo.SetRate(const Value: single);
begin
  Frate := Value;
  if (Ftype = 0) then
    FInc := 2.0 * PI * Frate / Fsamplerate
  else
    FInc := 2 * Frate / Fsamplerate;
  ci := f_cos(FInc);
  si := f_sin(FInc);
end;

procedure Tlfo.SetSamplerate(const Value: single);
begin
  FSamplerate := Value;
end;

end.

