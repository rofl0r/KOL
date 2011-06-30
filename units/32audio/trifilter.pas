unit trifilter;
{
       Unit: Trifilter
    purpose: Simple filter that outputs Low,Band and Highpass values
             at 6dB/Oct
     Author: Thaddy de Koning
  Copyright: 2003, Thaddy de Koning
    Remarks: Not very sophisticated but usefull in delayline filters etc.
    All values 0..1;

}

interface

uses kol, audioutils;


type
  PTriFilter = ^TTriFilter;
  TTriFilter = object(Tobj)
  protected
    Fsamplerate: single;
    FCutOff: single;
    FQfactor: single;
    FFilter,
    FHighpass,
    FBandPass,
    FLowPass: single;
    procedure SetCutOff(const Value: single);
    procedure SetQfactor(const Value: single);
    procedure Setsamplerate(const Value: single);
  public
    procedure Process(input: single);
    procedure setparam(Thecutoff, Theqfactor, Thesamplerate: single);
    property samplerate: single read Fsamplerate write Setsamplerate;
    property CutOff: single read FCutOff write SetCutOff;
    property Qfactor: single read FQfactor write SetQfactor;
    property Lowpass: single read FLowPass;
    property BandPass: single read FBandPass;
    property HighPass: single read FHighpass;
  end;

function NewTriFilter: PTriFilter;

implementation

{ TTriFilter }
function NewTriFilter: PTriFilter;
begin
  New(Result, Create);
  with Result^ do
  begin
    FSamplerate := 44100;
    FLowPass := 0;
    FHighpass := 0;
    FBandPass := 0;
    FFilter := 0;
    FQfactor := 0;
  end;
end;


procedure TTriFilter.Process(input: single);
var
  inp: single;
begin
  //Overkill
  inp := Undenormalize(input);
  FHighpass := Undenormalize(inp - FLowPass - FQfactor * FBandPass);
  FBandPass := Undenormalize(FBandPass + FFilter * FHighpass);
  FLowPass := Undenormalize(FLowPass + FFilter * FBandPass);
end;

procedure TTriFilter.SetCutOff(const Value: single);
begin
  FCutOff := Value;
end;

procedure TTriFilter.setparam(Thecutoff, Theqfactor, Thesamplerate: single);
begin
  FCutOff := Thecutoff;
  FQfactor := Theqfactor;
  FSampleRate := Thesamplerate;
  FFilter := 2.0 * f_sin(PI * FCutOff / FSampleRate);
end;

procedure TTriFilter.SetQfactor(const Value: single);
begin
  FQfactor := Value;
end;

procedure TTriFilter.Setsamplerate(const Value: single);
begin
  FSampleRate := Value;
  FLowPass := 0;
  FHighpass := 0;
  FBandPass := 0;
  setparam(FCutOff, FQfactor, FSampleRate);
end;

end.

