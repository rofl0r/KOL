******************************
KOL Audioprocessing compendium
******************************
This is a library for processing 32 bit Floating point audio
as used internally in most professional audio programs like Steinberg
Wavelab, Cubase and Logic.

Most routines and classes expect input in 32 bit floating point.
The library is written in such a way that it is samplerate independant.
It contains routines to convert 16 bit integer audio to 32 bit Floating point
and back.

It also contains routines to convert between dB and amplitude, Log scaling, etc.
If I have the time, I'll write a proper manual.

Expect to see examples soon:
Compressor, Delay, phaser, flanger, distortion, complex filtering

Most of the classes are strictly timedomain based.
All filters are Infinite Impulse Response filters {IIR}
You can use my KOL FFT classes to implement Finite Impulse Response(FIR) filters.


Thaddy
