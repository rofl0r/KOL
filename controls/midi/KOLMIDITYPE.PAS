{

       Unit: KOLMidiType
    purpose: Midi Type definitions
     Author: KOL translation and > 64 sysex buffering: Thaddy de Koning
             Original Author: David Churcher
  Copyright: released to the public domain
    Remarks: Well known Great components.
             Do not confuse this with my project JEDI midi translation for KOL
}
{ $Header: /MidiComp/MIDITYPE.PAS 2     10/06/97 7:33 Davec $ }

{ Written by David Churcher <dchurcher@cix.compulink.co.uk>,
  released to the public domain. }


unit KOLMIDITYPE;

interface

uses Kol, windows,Messages, MMSystem, KolMidiDefs, KOlCircbuf;

type
	{-------------------------------------------------------------------}
	{ A MIDI input/output event }
  pMyMidiEvent =^TMyMidiEvent;
	TMyMidiEvent = object(Tobj)
	public
		MidiMessage: Byte;          { MIDI message status byte }
		Data1: Byte;            { MIDI message data 1 byte }
		Data2: Byte;            { MIDI message data 2 byte }
		Time: DWORD;          { Time in ms since midiInOpen }
		SysexLength: Word;  { Length of sysex data (0 if none) }
		Sysex: PChar;           { Pointer to sysex data buffer }
		destructor Destroy; virtual;//override;   { Frees sysex data buffer if nec. }
	end;

	//PMyMidiEvent = ^TMyMidiEvent;

	{-------------------------------------------------------------------}
	{ Encapsulates the MIDIHDR with its memory handle and sysex buffer }
	PMyMidiHdr = ^TMyMidiHdr;
	TMyMidiHdr = object(TObj)
	public
		hdrHandle: THandle;
		hdrPointer: PMIDIHDR;
		sysexHandle: THandle;
		sysexPointer: Pointer;
		//constructor Create(BufferSize: Word);
		destructor Destroy; virtual;
	end;

function NewMidiHeader(BufferSize:Word):pMyMidiHdr;
function NewMidiEvent:PMyMidiEvent;

implementation

{-------------------------------------------------------------------}
{ Free any sysex buffer associated with the event }
destructor TMyMidiEvent.Destroy;
begin
	if (Sysex <> Nil) then
		Freemem(Sysex, SysexLength);

	inherited Destroy;
end;

function NewMidiEvent:PMyMidiEvent;
begin
  New(Result,Create);
end;
{-------------------------------------------------------------------}
{ Allocate memory for the sysex header and buffer }
//constructor TMyMidiHdr.Create(BufferSize:Word);
function NewMidiHeader(BufferSize:Word):pMyMidiHdr;
begin
	//inherited Create;
  New(Result,Create);
  with Result^do
  begin
	if BufferSize > 0 then
		begin
		hdrPointer := GlobalSharedLockedAlloc(sizeof(TMIDIHDR), hdrHandle);
		sysexPointer := GlobalSharedLockedAlloc(BufferSize, sysexHandle);

		hdrPointer^.lpData := sysexPointer;
		hdrPointer^.dwBufferLength := BufferSize;
		end;
  end;
end;

{-------------------------------------------------------------------}
destructor TMyMidiHdr.Destroy;
begin
	GlobalSharedLockedFree( hdrHandle, hdrPointer );
	GlobalSharedLockedFree( sysexHandle, sysexPointer );
	inherited Destroy;
end;



end.
