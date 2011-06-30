*************
KOL MIDI PACK
*************

******
Intro:
******

Almost anyone who has done any Delphi Midi programming
has used or is at least aware of the great and very stable
David Churcher Midi components.
This is my KOL translation of the core distribution packadge,
including an example MIDI monitor.

****************
Main components:
****************

MidiIN:  Midi input
MidiOut: MidiOutput

All other units are auxiliaries and definitions.

********
Remarks:
********
I've added additional but yet almost untested code to support sysex
dumps over 64K.
You can NOT use these components at the same time with my other KolMidi
component that is based on the JEDI JCL code.
There is no MCK (I hardly use it) support as yet,
but that should be easy to add.

***********
Known bugs:
***********
You have the option to compile either with or without KOL's err.pas unit.
WITHOUT err.pas the code is not stable if for example an USB midi devive is
swithced off. So for any production code. please use the err unit and
remove the dot in the {.$USE_ERR} Define in MidiIn.pas and MidiOut.pas.
This should prove to be as stable as the original components.

*****************
Acknowledgements:
*****************
Thanks to David Churcher for these great components!

July 4,2003, Thaddy de Koning
thaddy@thaddy.com
