unit TdkKOLMIDI;

//  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at http://www.mozilla.org/MPL/
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF   ANY KIND, either express or implied.
//  See the License for the specific language governing rights and limitations under the License.



// Unit:      TdkKolMidiOut
// Purpose:   KOL midi implementation
// Author:    Thaddy de Koning, (C) 2003
// Version:   1.00
// Delphi:    Tested with D4 CS, D6 personal, D7 personal
//            Tested with Hercules Game Theater, via AC97 and TASCAM 428
//            all at the same time!
// Remarks:   Due to the fact that this is a rework of JCL code,
//            This code is subject to the Mozilla Public Licence.
//            For information see the origibal JCL code, included.
//            Original JCL Author is Robert Rossmair.(Thanks!!!)
//
//            The code is in part a rewrite, eliminating the interfaces
//            and merging all relevant code into one unit.
//            Since KOL is for now a WIN32 platform library only library.
//            Due to KOL, you can create very small Midi applications,
//            only a few K.
//            The included example code is about 44 K, mostly because
//            it includes a simple way to draw a Keyboard.
//
//            Please send any remarks to thaddy@thaddy.com
//
//Usage:      Just define a variable of type pKolMidiOut
//            The object is autocreated and Autofree'd!!
//            since you must reference Midioutputs once.
//            See the example, its very simple.
//            The object always becomes a singleton for
//            a given Device ID.
interface
uses Windows,KOL,Err,MMsystem;

//--------------------------------------------------------------------------------------------------
// KOLMidi
//--------------------------------------------------------------------------------------------------

resourcestring
  RsOctaveC      = 'C';
  RsOctaveCSharp = 'C#';
  RsOctaveD      = 'D';
  RsOctaveDSharp = 'D#';
  RsOctaveE      = 'E';
  RsOctaveF      = 'F';
  RsOctaveFSharp = 'F#';
  RsOctaveG      = 'G';
  RsOctaveGSharp = 'G#';
  RsOctaveA      = 'A';
  RsOctaveASharp = 'A#';
  RsOctaveB      = 'B';

  RsMidiInUnknownError    = 'Unknown MIDI-In error No. %d';
  RsMidiOutUnknownError   = 'Unknown MIDI-Out error No. %d';
  RsInvalidMidiChannelNum = 'Invalid MIDI channel number (%d)';


// manifest constants for MIDI message protocol
const
  // MIDI Status Bytes for Channel Voice Messages
  MIDIMsgNoteOff             = $80;
  MIDIMsgNoteOn              = $90;
  MIDIMsgPolyKeyPressure     = $A0;
  MIDIMsgControlChange       = $B0;
  MIDIMsgProgramChange       = $C0;
  MIDIMsgChannelKeyPressure  = $D0;
  MIDIMsgAftertouch = MIDIMsgChannelKeyPressure; // Synonym
  MIDIMsgPitchWheelChange    = $E0;
  // MIDI Status Bytes for System Common Messages
  MIDIMsgSysEx               = $F0;
  MIDIMsgMTCQtrFrame         = $F1; // MIDI Time Code Qtr. Frame
  MIDIMsgSongPositionPtr     = $F2;
  MIDIMsgSongSelect          = $F3;
  MIDIMsgTuneRequest         = $F6;
  MIDIMsgEOX                 = $F7; // marks end of system exclusive message

  // MIDI Status Bytes for System Real-Time Messages
  MIDIMsgTimingClock         = $F8;
  MIDIMsgStartSequence       = $FA;
  MIDIMsgContinueSequence    = $FB;
  MIDIMsgStopSequence        = $FC;
  MIDIMsgActiveSensing       = $FE;
  MIDIMsgSystemReset         = $FF;

  // MIDICC...: MIDI Control Change Messages

  // Continuous Controllers MSB
  MIDICCBankSelect         = $00;
  MIDICCModulationWheel    = $01;
  MIDICCBreathControl      = $02;
  MIDICCFootController     = $04;
  MIDICCPortamentoTime     = $05;
  MIDICCDataEntry          = $06;
  MIDICCChannelVolume      = $07;
  MIDICCMainVolume = MIDICCChannelVolume;
  MIDICCBalance            = $08;
  MIDICCPan                = $0A;
  MIDICCExpression         = $0B;
  MIDICCEffectControl      = $0C;
  MIDICCEffectControl2     = $0D;
  MIDICCGeneralPurpose1    = $10;
  MIDICCGeneralPurpose2    = $11;
  MIDICCGeneralPurpose3    = $12;
  MIDICCGeneralPurpose4    = $13;
  // Continuous Controllers LSB
  MIDICCBankSelectLSB      = $20;
  MIDICCModulationWheelLSB = $21;
  MIDICCBreathControlLSB   = $22;
  MIDICCFootControllerLSB  = $24;
  MIDICCPortamentoTimeLSB  = $25;
  MIDICCDataEntryLSB       = $26;
  MIDICCChannelVolumeLSB   = $27;
  MIDICCMainVolumeLSB = MIDICCChannelVolumeLSB;
  MIDICCBalanceLSB         = $28;
  MIDICCPanLSB             = $2A;
  MIDICCExpressionLSB      = $2B;
  MIDICCEffectControlLSB   = $2C;
  MIDICCEffectControl2LSB  = $2D;
  MIDICCGeneralPurpose1LSB = $30;
  MIDICCGeneralPurpose2LSB = $31;
  MIDICCGeneralPurpose3LSB = $32;
  MIDICCGeneralPurpose4LSB = $33;
  // Switches
  MIDICCSustain            = $40;
  MIDICCPortamento         = $41;
  MIDICCSustenuto          = $42;
  MIDICCSoftPedal          = $43;
  MIDICCLegato             = $44;
  MIDICCHold2              = $45;

  MIDICCSound1             = $46; // (Sound Variation)
  MIDICCSound2             = $47; // (Timbre/Harmonic Intens.)
  MIDICCSound3             = $48; // (Release Time)
  MIDICCSound4             = $49; // (Attack Time)
  MIDICCSound5             = $4A; // (Brightness)
  MIDICCSound6             = $4B; // (Decay Time)
  MIDICCSound7             = $4C; // (Vibrato Rate)
  MIDICCSound8             = $4D; // (Vibrato Depth)
  MIDICCSound9             = $4E; // (Vibrato Delay)
  MIDICCSound10            = $4F; //

  MIDICCGeneralPurpose5    = $50;
  MIDICCGeneralPurpose6    = $51;
  MIDICCGeneralPurpose7    = $52;
  MIDICCGeneralPurpose8    = $53;
  MIDICCPortamentoControl  = $54;

  MIDICCReverbSendLevel    = $5B;
  MIDICCEffects2Depth      = $5C;
  MIDICCTremoloDepth = MIDICCEffects2Depth;
  MIDICCChorusSendLevel    = $5D;
  MIDICCEffects4Depth      = $5E;
  MIDICCCelesteDepth = MIDICCEffects4Depth;
  MIDICCEffects5Depth      = $5F;
  MIDICCPhaserDepth = MIDICCEffects5Depth;

  MIDICCDataEntryInc       = $60;
  MIDICCDataEntryDec       = $61;
  MIDICCNonRegParamNumLSB  = $62;
  MIDICCNonRegParamNumMSB  = $63;
  MIDICCRegParamNumLSB     = $64;
  MIDICCRegParamNumMSB     = $65;

//  Registered Parameter Numbers [CC# 65H,64H]
// ------------------------------------------------------------
//  CC#65 (MSB) | CC#64 (LSB) | Function
//  Hex|Dec|    |  Hex|Dec|   |
//  - - - - - - | - - - - - - |- - - - - - - - - - - - - - - -
//   00 = 0     |  00 = 0     | Pitch Bend Sensitivity
//   00 = 0     |  01 = 1     | Channel Fine Tuning
//   00 = 0     |  02 = 2     | Channel Coarse Tuning
//   00 = 0     |  03 = 3     | Tuning Program Change
//   00 = 0     |  04 = 4     | Tuning Bank Select

  // Channel Mode Messages (Control Change >= $78)
  MIDICCAllSoundOff        = $78;
  MIDICCResetAllControllers = $79;
  MIDICCLocalControl       = $7A;
  MIDICCAllNotesOff        = $7B;

  MIDICCOmniModeOff        = $7C;
  MIDICCOmniModeOn         = $7D;
  MIDICCMonoModeOn         = $7E;
  MIDICCPolyModeOn         = $7F;

type
  TStereoChannel = (scLeft, scRight);

  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);

  end;

  pByteArray=^TByteArray;
  TByteArray=array[0..32767] of byte;

  TMIDIChannel          = 1..16;
  TMIDIDataByte         = 0..$7F;           //  7 bits
  TMIDIDataWord         = 0..$3FFF;         // 14 bits
  TMIDIStatusByte       = $80..$FF;
  TMIDIVelocity         = TMIDIDataByte;
  TMIDIKey              = TMIDIDataByte;
  TMIDINote             = TMIDIKey;

const
  // Helper definitions
  MIDIDataMask          = $7F;
  MIDIDataWordMask      = $3FFF;
  MIDIChannelMsgMask    = $F0;
  MIDIInvalidStatus     = TMIDIStatusByte(0);
  BitsPerMIDIDataByte   = 7;
  BitsPerMIDIDataWord   = BitsPerMIDIDataByte * 2;
  MIDIPitchWheelCenter  = 1 shl (BitsPerMIDIDataWord - 1);

type
  TMIDINotes = set of TMIDINote;

  TSingleNoteTuningData = packed record
  case Integer of
    0:
      (Key: TMIDINote; Frequency: array[0..2] of TMIDIDataByte);
    1:
      (DWord: LongWord);
  end;

  EKOLMIDIError = class (Exception);

  // MIDI Out device class
  pKOLMidiOut =^TKOLMidiOut;
  TKOLMIDIOut = Object(Tobj)
  private
  //TMidiOut
    FHandle: HMIDIOUT;
    FDeviceID: Cardinal;
    FDeviceCaps: TMidiOutCaps;
    FVolume: DWord;
  //
    FMIDIStatus: TMIDIStatusByte;
    FRunningStatusEnabled: Boolean;
    FActiveNotes: array[TMIDIChannel] of TMIDINotes;
  //TMidiOut
    function GetChannelVolume(Channel: TStereoChannel): Word;
    procedure SetChannelVolume(Channel: TStereoChannel; const Value: Word);
    function GetVolume: Word;
    procedure SetVolume(const Value: Word);
    procedure SetLRVolume(const LeftValue, RightValue: Word);

  protected
    function GetActiveNotes(Channel: TMIDIChannel): TMIDINotes;
    function GetName: string; virtual;
    function GetMIDIStatus: TMIDIStatusByte;
    function IsRunningStatus(StatusByte: TMIDIStatusByte): Boolean;
    function GetRunningStatusEnabled: Boolean;
    procedure SetRunningStatusEnabled(const Value: Boolean);
    procedure SendChannelMessage(Msg: TMIDIStatusByte; Channel: TMIDIChannel;
      Data1, Data2: TMIDIDataByte);
    procedure DoSendMessage(const Data: array of Byte); virtual;
    procedure SendMessage(const Data: array of Byte);
  public
    procedure LongMessage(const Data: array of Byte);
    destructor Destroy; virtual;

    // Channel Voice Messages
    procedure SendNoteOff(Channel: TMIDIChannel; Key: TMIDINote; Velocity: TMIDIDataByte = $40);
    procedure SendNoteOn(Channel: TMIDIChannel; Key: TMIDINote; Velocity: TMIDIDataByte);
    procedure SendPolyphonicKeyPressure(Channel: TMIDIChannel; Key: TMIDINote; Value: TMIDIDataByte);
    procedure SendControlChange(Channel: TMIDIChannel; ControllerNum, Value: TMIDIDataByte);
    procedure SendControlChangeHR(Channel: TMIDIChannel; ControllerNum: TMIDIDataByte; Value: TMIDIDataWord);
    procedure SendSwitchChange(Channel: TMIDIChannel; ControllerNum: TMIDIDataByte; Value: Boolean);
    procedure SendProgramChange(Channel: TMIDIChannel; ProgramNum: TMIDIDataByte);
    procedure SendChannelPressure(Channel: TMIDIChannel; Value: TMIDIDataByte);
    procedure SendPitchWheelChange(Channel: TMIDIChannel; Value: TMIDIDataWord);
    procedure SendPitchWheelPos(Channel: TMIDIChannel; Value: Single);
    // Control Change Messages
    procedure SelectProgram(Channel: TMIDIChannel; BankNum: TMIDIDataWord; ProgramNum: TMIDIDataByte);
    procedure SendModulationWheelChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendBreathControlChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendFootControllerChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendPortamentoTimeChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendDataEntry(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendChannelVolumeChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendBalanceChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendPanChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    procedure SendExpressionChange(Channel: TMIDIChannel; Value: TMidiDataByte);
    // ...high Resolution
    procedure SendModulationWheelChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendBreathControlChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendFootControllerChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendPortamentoTimeChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendDataEntryHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendChannelVolumeChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendBalanceChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendPanChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    procedure SendExpressionChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
    // Control Change Messages: Switches
    procedure SwitchSustain(Channel: TMIDIChannel; Value: Boolean);
    procedure SwitchPortamento(Channel: TMIDIChannel; Value: Boolean);
    procedure SwitchSostenuto(Channel: TMIDIChannel; Value: Boolean);
    procedure SwitchSoftPedal(Channel: TMIDIChannel; Value: Boolean);
    procedure SwitchLegato(Channel: TMIDIChannel; Value: Boolean);
    procedure SwitchHold2(Channel: TMIDIChannel; Value: Boolean);
    // Channel Mode Messages
    procedure SwitchAllSoundOff(Channel: TMIDIChannel);
    procedure ResetAllControllers(Channel: TMIDIChannel);
    procedure SwitchLocalControl(Channel: TMIDIChannel; Value: Boolean);
    procedure SwitchAllNotesOff(Channel: TMIDIChannel);
    procedure SwitchOmniModeOff(Channel: TMIDIChannel);
    procedure SwitchOmniModeOn(Channel: TMIDIChannel);
    procedure SwitchMonoModeOn(Channel: TMIDIChannel; ChannelCount: Integer);
    procedure SwitchPolyModeOn(Channel: TMIDIChannel);
    //
    procedure SendSingleNoteTuningChange(const TargetDeviceID, TuningProgramNum: TMidiDataByte;
      const TuningData: array of TSingleNoteTuningData);
    function NoteIsOn(Channel: TMIDIChannel; Key: TMIDINote): Boolean;
    procedure SwitchActiveNotesOff(Channel: TMIDIChannel); overload;
    procedure SwitchActiveNotesOff; overload;
    property ActiveNotes[Channel: TMIDIChannel]: TMIDINotes read GetActiveNotes;
    property Name: string read GetName;
    property RunningStatusEnabled: Boolean read GetRunningStatusEnabled write SetRunningStatusEnabled;
    //TmidiOut
    property DeviceID: Cardinal read FDeviceID;
    property ChannelVolume[Channel: TStereoChannel]: Word read GetChannelVolume write SetChannelVolume;
    property Volume: Word read GetVolume write SetVolume;
  end;

procedure MidiOutCheck(Code: MMResult);
function MIDIOut(DeviceID: Cardinal = 0): pKOLMIDIOut;
procedure GetMidiOutputs(const List: pStrListEx);
function MIDISingleNoteTuningData(Key: TMIDINote; Frequency: Single): TSingleNoteTuningData;
function MIDINoteToStr(Note: TMIDINote): string;
function NewMidiOut(ADeviceID:Cardinal):pKOLMidiOut;

implementation


var
  MidiMapperDeviceID: Cardinal = MIDI_MAPPER;


var
  FMidiOutputs: pStrListEx = nil;

function MidiOutputs: pStrListEx;
var
  I: Integer;
  Caps: TMidiOutCaps;
begin
  if FMidiOutputs = nil then
  begin
    FMidiOutputs := NewSTrlistEx;
    for I := 0 to midiOutGetNumDevs - 1 do
    begin
      if (midiOutGetDevCaps(I, @Caps, SizeOf(Caps)) = MMSYSERR_NOERROR) then
        FMidiOutputs.Add(Caps.szPName);
    end;
  end;
  Result := FMidiOutputs;
end;


procedure GetMidiOutputs(const List: pStrListEx);
begin
  List.Assign(MidiOutputs);
end;


function MidiOut(DeviceID: Cardinal): pKOLMidiOut;
var
  Device: pKOLMidiOut;
begin
  if DeviceID = MIDI_MAPPER then
    DeviceID := MidiMapperDeviceID;
  Device := nil;
  if DeviceID <> MIDI_MAPPER then
    Device := pKOLMidiOut(MidiOutputs.Objects[DeviceID]);
  // make instance a singleton for a given device ID
  if not Assigned(Device) then
  begin
    Device := NewMidiOut(DeviceID);
    if DeviceID = MIDI_MAPPER then
      MidiMapperDeviceID := Device.DeviceID;
    // cannot use DeviceID argument as index here, since it might be MIDI_MAPPER
    MidiOutputs.Objects[Device.DeviceID] := Cardinal(Device);
  end;
  Result := Device;
end;

function NewMidiOut(ADeviceId:Cardinal):pKOLMidiOut;
begin
  New(Result,Create);
  Applet.Add2AutoFree(Result);
  Result.FVolume := $FFFFFFFF; // max. volume, in case Get/SetChannelVolume not supported
  MidiOutCheck(midiOutGetDevCaps(ADeviceID, @Result.FDeviceCaps, SizeOf(Result.FDeviceCaps)));
  MidiOutCheck(midiOutOpen(@Result.FHandle, ADeviceID, 0, 0, 0));
  MidiOutCheck(midiOutGetID(Result.FHandle, @Result.FDeviceID));
end;


function MIDISingleNoteTuningData(
  Key: TMIDINote;
  Frequency: Single): TSingleNoteTuningData;
var
  F: Cardinal;
begin
  Result.Key := Key;
  F := Trunc(Frequency * (1 shl BitsPerMIDIDataWord));
  Result.Frequency[0] := (F shr BitsPerMIDIDataWord) and MIDIDataMask;
  Result.Frequency[1] := (F shr BitsPerMIDIDataByte) and MIDIDataMask;
  Result.Frequency[2] := F and MIDIDataMask;
end;


procedure CheckMIDIChannelNum(Channel: TMIDIChannel);
begin
  if (Channel < Low(TMIDIChannel)) or (Channel > High(TMIDIChannel)) then
    raise EKOLMIDIError.CreateFmt(e_Custom,RsInvalidMidiChannelNum, [Channel]);
end;


function MIDINoteToStr(Note: TMIDINote): string;
const
  HalftonesPerOctave = 12;
begin
  case Note mod HalftonesPerOctave of
     0: Result := RsOctaveC;
     1: Result := RsOctaveCSharp;
     2: Result := RsOctaveD;
     3: Result := RsOctaveDSharp;
     4: Result := RsOctaveE;
     5: Result := RsOctaveF;
     6: Result := RsOctaveFSharp;
     7: Result := RsOctaveG;
     8: Result := RsOctaveGSharp;
     9: Result := RsOctaveA;
    10: Result := RsOctaveASharp;
    11: Result := RsOctaveB;
  end;
  Result := Format('%s%d', [Result, Note div HalftonesPerOctave -2]);
end;


procedure StrResetLength(var S: AnsiString);
begin
  SetLength(S, StrLen(PChar(S)));
end;

function GetMidiInErrorMessage(const ErrorCode: MMRESULT): string;
begin
  SetLength(Result, MAXERRORLENGTH-1);
  if midiInGetErrorText(ErrorCode, @Result[1], MAXERRORLENGTH) = MMSYSERR_NOERROR then
    StrResetLength(Result)
  else
    Result := Format(RsMidiInUnknownError, [ErrorCode]);
end;


function GetMidiOutErrorMessage(const ErrorCode: MMRESULT): string;
begin
  SetLength(Result, MAXERRORLENGTH-1);
  if midiOutGetErrorText(ErrorCode, @Result[1], MAXERRORLENGTH) = MMSYSERR_NOERROR then
    StrResetLength(Result)
  else
    Result := Format(RsMidiOutUnknownError, [ErrorCode]);
end;


procedure MidiInCheck(Code: MMResult);
begin
  if Code <> MMSYSERR_NOERROR then
    raise EKOLMidiError.Create(e_custom,GetMidiInErrorMessage(Code));
end;


procedure MidiOutCheck(Code: MMResult);
begin
  if Code <> MMSYSERR_NOERROR then
    raise EKOLMidiError.Create(e_Custom,GetMidiOutErrorMessage(Code));
end;


function TKOLMidiOut.GetName: string;
begin
  Result := FDeviceCaps.szPName;
end;


destructor TKOLMIDIOut.Destroy;
begin
  SwitchActiveNotesOff;
  midiOutClose(FHandle);
  MidiOutputs.Objects[FDeviceID] := Cardinal(nil);
  inherited;
end;



function TKOLMIDIOut.GetActiveNotes(Channel: TMIDIChannel): TMIDINotes;
begin
  CheckMIDIChannelNum(Channel);
  Result := FActiveNotes[Channel];
end;


procedure TKOLMIDIOut.SendChannelMessage(Msg: TMIDIStatusByte;
  Channel: TMIDIChannel; Data1, Data2: TMIDIDataByte);
begin
  SendMessage([Msg or (Channel - Low(Channel)), Data1, Data2]);
end;


function TKOLMIDIOut.GetRunningStatusEnabled: Boolean;
begin
  Result := FRunningStatusEnabled;
end;


function TKOLMIDIOut.NoteIsOn(Channel: TMIDIChannel; Key: TMIDINote): Boolean;
begin
  Result := Key in FActiveNotes[Channel];
end;


procedure TKOLMIDIOut.SendNoteOff(Channel: TMIDIChannel; Key: TMIDINote; Velocity: TMIDIDataByte);
begin
  SendChannelMessage(MIDIMsgNoteOff, Channel, Key, Velocity);
  Exclude(FActiveNotes[Channel], Key);
end;


procedure TKOLMIDIOut.SendNoteOn(Channel: TMIDIChannel; Key: TMIDINote; Velocity: TMIDIDataByte);
begin
  SendChannelMessage(MIDIMsgNoteOn, Channel, Key, Velocity);
  Include(FActiveNotes[Channel], Key);
end;


procedure TKOLMIDIOut.SendPolyphonicKeyPressure(Channel: TMIDIChannel;
  Key: TMIDINote; Value: TMIDIDataByte);
begin
  SendChannelMessage(MIDIMsgPolyKeyPressure, Channel, Key, Value);
end;

procedure TKOLMIDIOut.SendControlChange(Channel: TMIDIChannel; ControllerNum, Value: TMIDIDataByte);
begin
  SendChannelMessage(MIDIMsgControlChange, Channel, ControllerNum, Value);
end;

procedure TKOLMIDIOut.SendControlChangeHR(Channel: TMIDIChannel; ControllerNum: TMIDIDataByte;
  Value: TMIDIDataWord);
begin
  SendControlChange(Channel, ControllerNum, Value shr BitsPerMIDIDataByte and MIDIDataMask);
  if ControllerNum <= $13 then
    SendControlChange(Channel, ControllerNum or $20, Value and MIDIDataMask);
end;

procedure TKOLMIDIOut.SendSwitchChange(Channel: TMIDIChannel; ControllerNum: TMIDIDataByte; Value: Boolean);
const
  DataByte: array [Boolean] of Byte = ($00, $7F);
begin
  SendChannelMessage(MIDIMsgControlChange, Channel, ControllerNum, DataByte[Value]);
end;


procedure TKOLMIDIOut.SendProgramChange(Channel: TMIDIChannel; ProgramNum: TMIDIDataByte);
begin
  SendChannelMessage(MIDIMsgProgramChange, Channel, ProgramNum, 0);
end;


procedure TKOLMIDIOut.SendChannelPressure(Channel: TMIDIChannel;
  Value: TMIDIDataByte);
begin
  SendChannelMessage(MIDIMsgChannelKeyPressure, Channel, Value, 0);
end;


procedure TKOLMIDIOut.SendPitchWheelChange(Channel: TMIDIChannel; Value: TMIDIDataWord);
begin
  SendChannelMessage(MIDIMsgPitchWheelChange, Channel, Value and MidiDataMask, Value shr BitsPerMIDIDataByte);
end;


procedure TKOLMIDIOut.SendPitchWheelPos(Channel: TMIDIChannel; Value: Single);
var
  Temp: TMIDIDataWord;
begin
  if Value < 0 then
    Temp := Round(Value * (1 shl 13))
  else
    Temp := Round(Value * (1 shl 13 - 1));
  SendPitchWheelChange(Channel, Temp);
end;

procedure TKOLMIDIOut.SwitchAllSoundOff(Channel: TMIDIChannel);
begin
  SendControlChange(Channel, MIDICCAllSoundOff, 0);
end;

procedure TKOLMIDIOut.SwitchLocalControl(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCLocalControl, Value);
end;


procedure TKOLMIDIOut.ResetAllControllers(Channel: TMIDIChannel);
begin
  SendControlChange(Channel, MIDICCResetAllControllers, 0);
end;


procedure TKOLMIDIOut.SwitchAllNotesOff(Channel: TMIDIChannel);
begin
  CheckMIDIChannelNum(Channel);
  SendControlChange(Channel, MIDICCAllNotesOff, 0);
  FActiveNotes[Channel] := [];
end;


procedure TKOLMIDIOut.SetRunningStatusEnabled(const Value: Boolean);
begin
  FMIDIStatus := MIDIInvalidStatus;
  FRunningStatusEnabled := Value;
end;


procedure TKOLMIDIOut.SendSingleNoteTuningChange(const TargetDeviceID, TuningProgramNum: TMidiDataByte;
  const TuningData: array of TSingleNoteTuningData);
var
  Count: Integer;
  Buf: PByteArray;
  BufSize: Integer;
begin
  Count := High(TuningData) - Low(TuningData) + 1;
  BufSize := 8 + Count * SizeOf(TSingleNoteTuningData);
  GetMem(Buf, BufSize);
  try
    Buf[0] := MIDIMsgSysEx;      // Universal Real Time SysEx header, first byte
    Buf[1] := $7F;               // second byte
    Buf[2] := TargetDeviceID;    // ID of target device (?)
    Buf[3] := 8;                 // sub-ID#1 (MIDI Tuning)
    Buf[4] := 2;                 // sub-ID#2 (note change)
    Buf[5] := TuningProgramNum;  // tuning program number (0 – 127)
    Buf[6] := Count;
    Move(TuningData, Buf[7], Count * SizeOf(TSingleNoteTuningData));
    Buf[BufSize - 1] := MIDIMsgEOX;
    SendMessage(Slice(Buf^, BufSize));
  finally
    FreeMem(Buf);
  end;
end;


procedure TKOLMIDIOut.SwitchActiveNotesOff(Channel: TMIDIChannel);
var
  Note: TMIDINote;
begin
  CheckMIDIChannelNum(Channel);
  if FActiveNotes[Channel] <> [] then
    for Note := Low(Note) to High(Note) do
      if Note in FActiveNotes[Channel] then
        SendNoteOff(Channel, Note, $7F);
end;


procedure TKOLMIDIOut.SwitchActiveNotesOff;
var
  Channel: TMIDIChannel;
begin
  for Channel := Low(Channel) to High(Channel) do
    SwitchActiveNotesOff(Channel);
end;


procedure TKOLMIDIOut.SelectProgram(Channel: TMIDIChannel;
  BankNum: TMIDIDataWord; ProgramNum: TMIDIDataByte);
begin
  SendControlChangeHR(Channel, MIDICCBankSelect, BankNum);
  SendProgramChange(Channel, ProgramNum);
end;


procedure TKOLMIDIOut.SendMessage(const Data: array of Byte);
begin
  if IsRunningStatus(Data[0]) then
    DoSendMessage(Slice(Data, 1))
  else
    DoSendMessage(Data);
end;


function TKOLMIDIOut.GetMIDIStatus: TMIDIStatusByte;
begin
  Result := FMIDIStatus;
end;


function TKOLMIDIOut.IsRunningStatus(StatusByte: TMIDIStatusByte): Boolean;
begin
  Result := (StatusByte = FMIDIStatus)
    and ((StatusByte and $F0) <> $F0)       // is channel message
    and RunningStatusEnabled;
end;


procedure TKOLMIDIOut.SendBalanceChange(Channel: TMIDIChannel; Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCBalance, Value);
end;


procedure TKOLMIDIOut.SendBalanceChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCBalance, Value);
end;


procedure TKOLMIDIOut.SendBreathControlChange(Channel: TMIDIChannel; Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCBreathControl, Value);
end;


procedure TKOLMIDIOut.SendBreathControlChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCBreathControl, Value);
end;

procedure TKOLMIDIOut.SendDataEntry(Channel: TMIDIChannel; Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCDataEntry, Value);
end;


procedure TKOLMIDIOut.SendDataEntryHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCDataEntry, Value);
end;


procedure TKOLMIDIOut.SendExpressionChange(Channel: TMIDIChannel; Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCExpression, Value);
end;


procedure TKOLMIDIOut.SendExpressionChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCExpression, Value);
end;


procedure TKOLMIDIOut.SendFootControllerChange(Channel: TMIDIChannel; Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCFootController, Value);
end;


procedure TKOLMIDIOut.SendFootControllerChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCFootController, Value);
end;


procedure TKOLMIDIOut.SwitchHold2(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCHold2, Value);
end;


procedure TKOLMIDIOut.SwitchLegato(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCLegato, Value);
end;


procedure TKOLMIDIOut.SendChannelVolumeChange(Channel: TMIDIChannel;
  Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCChannelVolume, Value);
end;


procedure TKOLMIDIOut.SendChannelVolumeChangeHR(Channel: TMIDIChannel;
  Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCChannelVolume, Value);
end;


procedure TKOLMIDIOut.SendModulationWheelChange(Channel: TMIDIChannel;
  Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCModulationWheel, Value);
end;


procedure TKOLMIDIOut.SendModulationWheelChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCModulationWheel, Value);
end;


procedure TKOLMIDIOut.SendPanChange(Channel: TMIDIChannel; Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCPan, Value);
end;


procedure TKOLMIDIOut.SendPanChangeHR(Channel: TMIDIChannel; Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCPan, Value);
end;


procedure TKOLMIDIOut.SwitchPortamento(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCPortamento, Value);
end;


procedure TKOLMIDIOut.SendPortamentoTimeChange(Channel: TMIDIChannel;
  Value: TMidiDataByte);
begin
  SendControlChange(Channel, MIDICCPortamentoTime, Value);
end;


procedure TKOLMIDIOut.SendPortamentoTimeChangeHR(Channel: TMIDIChannel;
  Value: TMidiDataWord);
begin
  SendControlChangeHR(Channel, MIDICCPortamentoTime, Value);
end;


procedure TKOLMIDIOut.SwitchSoftPedal(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCSoftPedal, Value);
end;


procedure TKOLMIDIOut.SwitchSustain(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCSustain, Value);
end;


procedure TKOLMIDIOut.SwitchSostenuto(Channel: TMIDIChannel; Value: Boolean);
begin
  SendSwitchChange(Channel, MIDICCSustenuto, Value);
end;


procedure TKOLMIDIOut.SwitchOmniModeOff(Channel: TMIDIChannel);
begin
  SendControlChange(Channel, MIDICCOmniModeOff, 0);
  FActiveNotes[Channel] := []; // implicite All Notes Off
end;


procedure TKOLMIDIOut.SwitchOmniModeOn(Channel: TMIDIChannel);
begin
  SendControlChange(Channel, MIDICCOmniModeOn, 0);
  FActiveNotes[Channel] := []; // implicite All Notes Off
end;


procedure TKOLMIDIOut.SwitchMonoModeOn(Channel: TMIDIChannel; ChannelCount: Integer);
begin
  SendControlChange(Channel, MIDICCMonoModeOn, ChannelCount);
  FActiveNotes[Channel] := []; // implicite All Notes Off
end;


procedure TKOLMIDIOut.SwitchPolyModeOn(Channel: TMIDIChannel);
begin
  SendControlChange(Channel, MIDICCPolyModeOn, 0);
  FActiveNotes[Channel] := []; // implicite All Notes Off
end;


procedure TKOLMidiOut.LongMessage(const Data: array of Byte);
var
  Hdr: TMidiHdr;
begin
  FillChar(Hdr, SizeOf(Hdr), 0);
  Hdr.dwBufferLength := High(Data)-Low(Data)+1;;
  Hdr.dwBytesRecorded := Hdr.dwBufferLength;
  Hdr.lpData := @Data;
  Hdr.dwFlags := 0;
  MidiOutCheck(midiOutPrepareHeader(FHandle, @Hdr, SizeOf(Hdr)));
  MidiOutCheck(midiOutLongMsg(FHandle, @Hdr, SizeOf(Hdr)));
  repeat until (Hdr.dwFlags and MHDR_DONE) <> 0;
end;


procedure TKOLMidiOut.DoSendMessage(const Data: array of Byte);
var
  I: Integer;
  Msg: packed record
  case Integer of
    0:
      (Bytes: array[0..2] of Byte);
    1:
      (DWord: LongWord);
  end;
begin
  if High(Data) < 3 then
  begin
    for I := 0 to High(Data) do
      Msg.Bytes[I] := Data[I];
    MidiOutCheck(midiOutShortMsg(FHandle, Msg.DWord));
  end
  else LongMessage(Data);
end;


function TKOLMidiOut.GetChannelVolume(Channel: TStereoChannel): Word;
begin
  midiOutGetVolume(FHandle, @FVolume);
  Result := FVolume;
end;


procedure TKOLMidiOut.SetChannelVolume(Channel: TStereoChannel; const Value: Word);
begin
  if Channel = scLeft then
    SetLRVolume(Value, ChannelVolume[scRight])
  else
    SetLRVolume(ChannelVolume[scLeft], Value);
end;


function TKOLMidiOut.GetVolume: Word;
begin
  Result := GetChannelVolume(scLeft);
end;


procedure TKOLMidiOut.SetVolume(const Value: Word);
begin
  SetLRVolume(Value, Value);
end;


procedure TKOLMidiOut.SetLRVolume(const LeftValue, RightValue: Word);
var
  Value: DWord;
begin
  with LongRec(Value) do
  begin
    Lo := LeftValue;
    Hi := RightValue;
  end;
  if Value <> FVolume then
  begin
    if (MIDICAPS_VOLUME and FDeviceCaps.dwSupport) <> 0 then
      MidiOutCheck(midiOutSetVolume(FHandle, Value));
    FVolume := Value;
  end;
end;

initialization
finalization
  FMidiOutputs.Free;
end.
end.
