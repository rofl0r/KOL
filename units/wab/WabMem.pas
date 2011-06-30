unit WabMem;

interface

uses
  Windows, KOLActiveX, WabApi;

{$I WAB.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

(*$HPPEMIT '#include <wabmem.h>'*)

type
  PMapiAllocateBuffer = ^TMapiAllocateBuffer;
  MAPIALLOCATEBUFFER = function (cbSize: ULONG; var lppBuffer: Pointer): SCODE; stdcall;
  {$EXTERNALSYM MAPIALLOCATEBUFFER}
  TMapiAllocateBuffer = MAPIALLOCATEBUFFER;

  PMapiAllocateMore = ^TMapiAllocateMore;
  MAPIALLOCATEMORE = function (cbSize: ULONG; lpObject: Pointer;
    var lppBuffer: Pointer): SCODE; stdcall;
  {$EXTERNALSYM MAPIALLOCATEMORE}
  TMapiAllocateMore = MAPIALLOCATEMORE;

  PMapiFreeBuffer = ^TMapiFreeBuffer;
  MAPIFREEBUFFER = function (lpBuffer: Pointer): SCODE; stdcall;
  {$EXTERNALSYM MAPIFREEBUFFER}
  TMapiFreeBuffer = MAPIFREEBUFFER;

  PWabAllocateBuffer = ^TWabAllocateBuffer;
  WABALLOCATEBUFFER = function (lpWABObject: IWabObject; cbSize: ULONG;
    var lppBuffer: Pointer): SCODE; stdcall;
  {$EXTERNALSYM WABALLOCATEBUFFER}
  TWabAllocateBuffer = WABALLOCATEBUFFER;

  PWabAllocateMore = ^TWabAllocateMore;
  WABALLOCATEMORE = function (lpWABObject: IWabObject; cbSize: ULONG;
    lpObject: Pointer; var lppBuffer: Pointer): SCODE; stdcall;
  {$EXTERNALSYM WABALLOCATEMORE}
  TWabAllocateMore = WABALLOCATEMORE;

  PWabFreeBuffer = ^TWabFreeBuffer;
  WABFREEBUFFER = function (lpWABObject: IWabObject; lppBuffer: Pointer): SCODE; stdcall;
  {$EXTERNALSYM WABFREEBUFFER}
  TWabFreeBuffer = WABFREEBUFFER;

implementation

end.
