KOLGIF.PAS v3.3a.160 -- Copyright (C) by Vladimir Kladov

This unit contains TGif and TGifDecoder object definitions, 
implementing decoding and right painting of Graphic Interchange 
File format (gif-images). Encoding is not implemented here.

  This code is ported from XCL code ( XGifs.pas ) with some 
enchancements. ( XCL is created by Vladimir Kladov earlier,
and now this project is stopped and replaced by KOL, see below ).

  Originally, this code was extracted from freeware RXLib Delphi VCL
components library (rxgif.pas). VCL bloats and unneeded dependances
from other parts of RXLib were removed, and important add was made: 
exact transparency mask, which helps to correctly decode and paint 
ANY gif independantly from current display settings.

  To get know about authors of RXLib, please visit their site 
http://www.rxlib.com

  Rxgif code, was originally based on source of freeware GBM program 
(C++) by Andy Key (nyangau@interalpha.co.uk)

-----------------------------------------------------------------
KOL (Key Objects Library) is available at the address:
  http://bonanzas.rinet.ru

KOL is intended to create small but powerful 32-bit Windows GUI 
applications using Delphi (versions 2, 3, 4, 5 of Delphi are
supported). There are no components derived from TObject in KOL.
KOL contains only poor Pascal Objects. There are no a big tree of 
visual controls - all controls are represented by TControl object
type, which can become a label, a button, ..., listview, tabcontrol,
etc. - depending on what You want from it.

The smallest GUI application, created with KOL, is about 13,5K bytes
of executable. The average size of exe is approximately 40-60K.

KOL is free of charge, and provided with sources.

Using MCK (Mirror Classes Kit), You can create KOL-based applications
visually. There are some additional archives are provided to allow
creating DB-aware applications on base of KOL (KOLEDB, STRDB, TDKDBBASE),
several additional packages to minimize your application size,
work with exceptions, etc.
-----------------------------------------------------------------------

This archive contains an add-on, which allows You to use GIF images in
your application (e.g. store it in reseources) or load such images from
disk to decode it and paint. Animated, transparent gif's are supported
well. Special efforts are made to provide smaller code grouth, when only
single frame, non-transparent gifs are needed.

INSTALLATION.

- Unpack KolGif.pas to the same folder, where You have KOL installed.
  Nothing else.
- Open and Install the package as usual (if you wish to add TKOLGifShow
  to the Component Palette - but only if you have MCK installed).

  See also instruction, provided with demo project.

_______________________________________________________________________
mailto: bonanzas@online.sinor.ru
http://bonanzas.rinet.ru