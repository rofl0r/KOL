{

       Unit: KOLMidiDefs
    purpose: Midi Record Definitions
     Author: KOL translation and > 64 sysex buffering: Thaddy de Koning
             Original Author: David Churcher
  Copyright: released to the public domain
    Remarks: Well known Great components.
             Do not confuse this with my project JEDI midi translation for KOL
}
{ $Header: /MidiComp/MIDIDEFS.PAS 2     10/06/97 7:33 Davec $ }

{ Written by David Churcher <dchurcher@cix.compulink.co.uk>,
  released to the public domain. }


{ Common definitions used by DELPHMID.DPR and the MIDI components.
  This must be a separate unit to prevent large chunks of the VCL being
  linked into the DLL. }
unit KOLMIDIDEFS;

interface

uses KOL, windows, MMsystem, KOLCircbuf;

type

	{-------------------------------------------------------------------}
	{ This is the information about the control that must be accessed by
	  the MIDI input callback function in the DLL at interrupt time }
	PMidiCtlInfo = ^TMidiCtlInfo;
	TMidiCtlInfo = record
		hMem: THandle; 				{ Memory handle for this record }
		PBuffer: PCircularBuffer;	{ Pointer to the MIDI input data buffer }
		hWindow: HWnd;					{ Control's window handle }
		SysexOnly: Boolean;			{ Only process System Exclusive input }
	end;

	{ Information for the output timer callback function, also required at
	  interrupt time. }
	PMidiOutTimerInfo = ^TMidiOutTimerInfo;
	TMidiOutTimerInfo = record
		hMem: THandle;				{ Memory handle for this record }
		PBuffer: PCircularBuffer;	{ Pointer to MIDI output data buffer }
		hWindow: HWnd;				{ Control's window handle }
		TimeToNextEvent: DWORD;	{ Delay to next event after timer set }
		MIDIHandle: HMidiOut;		{ MIDI handle to send output to 
									(copy of component's FMidiHandle property) }
		PeriodMin: Word;			{ Multimedia timer minimum period supported }
		PeriodMax: Word;			{ Multimedia timer maximum period supported }
		TimerId: Word;				{ Multimedia timer ID of current event }
	end;

implementation


end.
