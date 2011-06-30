{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

        KKKKK    KKKKK    OOOOOOOOO    LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLL
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL
        KKKKKKKKKK      OOOOO   OOOOO  LLLLL
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLLLLLLLLLL
        KKKKK    KKKKK    OOOOOOOOO    LLLLLLLLLLLLL

  Key Objects Library (C) 2000 by Kladov Vladimir.

  K.O.L. - is a set of objects to create small programs
  with Delphi, but without the VCL.  It is based on the
  idea of XCL, which also allows the creation of smaller
  programs then in the VCL (about 5 times smaller).
  However, this is not as small as the author (me) would
  like.  KOL allows the creation of applications about
  10 times smaller then those created with the VCL. But
  this does not mean that KOL is less power then the
  VCL - perhaps just the opposite...

  XCL and KOL are provided free with the source code.
  Idea is copyrighted (C) to me, Vladimir Kladov.
  The most of the code is also copyrighted (C) to me.
  Code provided by other  developers (even if later
  changed by me) is fully aknowledged.

  If You wish to take part in developing KOL, please
  do let me know.

  mailto: bonanzas@xcl.cjb.net
  Home: http://kol.nm.ru
        http://xcl.cjb.net
        http://xcl.nm.ru

 =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

unit KolGif;
{* This unit contains TGif  and TGifDecoder object definitions, implementing
   decoding and right painting of Graphic Interchange File format (gif-images).
   Encoding is not implemented here.
   |<br>&nbsp;&nbsp;&nbsp;
   This code is ported from XCL code ( XGifs.pas ) with some enchancements.
   |<br>&nbsp;&nbsp;&nbsp;
   Originally, this code was extracted from freeware RXLib Delphi VCL
   components library (rxgif.pas). VCL bloats and unneeded dependances
   from other parts of RXLib were removed, and important add
   was made: exact transparency mask, which helps to correctly
   decode and paint ANY gif independantly from current video
   settings.
   |<br>&nbsp;&nbsp;&nbsp;
       To get know about authors of RXLib, please visit
   |<a href="http://www.rxlib.com">their site</a>.
   |<br>&nbsp;&nbsp;&nbsp;
       Rxgif code, was originally based on source of freeware GBM
   program (C++) by
   |<a href="mailto:nyangau@interalpha.co.uk">
       Andy Key (nyangau@interalpha.co.uk)
   |</a>.
}

//{$DEFINE CHK_BITBLT}

interface

{$I KOLDEF.INC}

{$IFDEF _D6orHigher}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

uses windows, KOL {, ChkGdi};

type
  TGifVersion = ( gvUnknown, gv87a, gv89a );

  TGifBits = 1..8;

  TDisposeMethod = ( dmUndefined, dmLeave, dmRestoreBackground,
                     dmRestorePrevious );

  TGifColorItem = record
    Red:  Byte;
    Green:Byte;
    Blue: Byte;
  end;

  TGifColorTable = record
    ColorCount : Integer;
    Colors : packed array[ Byte ] of TGifColorItem;
  end;

  PGifFrame = ^TGifFrame;

  //PGifItem = ^TGifItem;
  TGifItem = packed record // object( TObj )
  //private
    FImageData : PStream; // memory stream
    FSize : TPoint;
    FPackedFields : Byte;
    FBitsPerPixel : Byte;
    FColorMap : TGifColorTable;
  {public
    destructor Destroy; virtual;}
  end;

  //PGifData = ^TGifData;
  TGifData = packed record // object( TObj )
  //private
    DComment : PStrList;
    DAspectRatio : Byte;
    DBitsPerPixel : Byte;
    DColorResBits : Byte;
    DColorMap : TGifColorTable;
  {public
    constructor Create;
    destructor Destroy; virtual;}
  end;

  PGifDecoder = ^TGifDecoder;
  TGifDecoder = object( TObj )
  {* This object can be used directly to load gif image from file or stream
     and to decode its frames. To provide correct drawing of animated gif
     images, use TGif object, which is much more power, and works correctly
     in the most cases. Therefore, TGifDecoder allows to decode single-frame
     images easy and can be used to pack bitmap resources delivered together
     with the application. }
  private
    FGifData : TGifData;
    FVersion : TGifVersion;
    FItems : PList; // of PGifFrame
    FFrameIndex : Integer;
    FGifWidth : Integer;
    FGifHeight : Integer;
    FBkColor : TColor;
    FBackIndex : Integer;
    FLooping : Boolean;
    FRepeatCount : Word;
    FNeedMask: Boolean;
    FTransparent : Boolean;
    FCorrupted: Boolean;
    FOnNeedMask: procedure( Sender: PObj; var BIH: TBitmapInfoHeader; Bits: Pointer );
    procedure NewImage;
    procedure ClearItems;
    function GetFrames(Idx: Integer): PGifFrame;
    function GetComment: PStrList;
    function GetBitmap: PBitmap;
    procedure SetNeedMask(const Value: Boolean);
    function GetMask: PBitmap;
  protected
    function GetWidth : Integer;
    function GetHeight: Integer;
    function GetFrameCount : Integer;
    function GetFrame : Integer;
    procedure SetFrame( Value : Integer );
  public
    destructor Destroy; virtual;
    {* Use Free method instead. }
    procedure Clear;
    {* Clears gif image. }
    property Count : Integer read GetFrameCount;
    {* Returns count of frames stored in the gif image. }
    property Frame : Integer read GetFrame write SetFrame;
    {* Index of current frame (between 0 and Count-1). }
    property Width : Integer read GetWidth;
    {* Width of entire gif image. }
    property Height : Integer read GetHeight;
    {* Height of entire gif image. }
    property BkColor : TColor read FBkColor write FBkColor;
    {* Background color. After loading gif, this property contains a value,
       which is used as a background (e.g. transparent) color of the entire
       set of frames. For non-transparent images, this value is set to
       clNone after loading the image. It is possible to change this value,
       but this will affect only the Draw method (if TGifDecoder object is
       used in TGif container). DrawTransp and DrawTransparent methods (of
       TGif, too) use BkColor only for non-transparent images, and in case when
       NeedMask is reset to False. }
    property Looping: Boolean read FLooping write FLooping;
    {* True, if loaded image is marked (by its authors) as "looping". }
    property RepeatCount : Word read FRepeatCount write FRepeatCount;
    {* Repeat count set by the author of gif image. }
    property NeedMask : Boolean read FNeedMask write SetNeedMask;
    {* This value is False by default for TGifDecoder instances used stanalone,
       but it is set to True, when TGif is using the owned TGifDecoder object.
       True requires a bit larger code to implement really truth transparency,
       which independs from display resolution and color depth, and works
       correctly even in case when background color of the first frame matches
       non-transparent colors of other ones. }
    property Transparent : Boolean read FTransparent;
    {* True, if loaded gif image is transparent. }
    property Version : TGifVersion read FVersion;
    {* Version of gif. }
    property Frames[ Idx : Integer ] : PGifFrame read GetFrames;
    {* Acess frames as an array of pointers to TGifFrame object instances,
       created while gif image is loading. }
    property Comment : PStrList read GetComment;
    {* Text comment, provided with gif image. }
    function LoadFromStream( Stream : PStream ) : Boolean;
    {* Call this method to load gif image from a stream and decode it. After
       loading, first frame is decoded and ready to be drawn immediately. All
       other frames are decoded when requested first time. Since this, a property
       Corrupted can be not set to True just after loading the image and decoding
       several first frames, and can become True later, when requested frame
       found corrupted while decoding it. }
    function LoadFromFile( const FileName : String ) : Boolean;
    {* Call this method to load gif image from the file and decode it. See
       also LoadFromStream - the most told there is true here too. }
    function LoadFromResourceName( Inst: HInst; RsrcName: PChar ): Boolean;
    {* Call this method to load GIF image from resource by its name.
       GIF image must be stored in RCDATA resource named using unique
       ANSI string. }
    function LoadFromResourceID(Instance: HInst; ResID: Integer): Boolean;
    {* Call this method to load GIF from resource (RCDATA) by ID. }
    property Bitmap : PBitmap read GetBitmap;
    {* Current frame bitmap. }
    property Mask: PBitmap read GetMask;
    {* Current frame truth mask. }
    procedure FreeResources;
    {* Call this method to free the most of GDI resources allocated while
       decoding the image. This forces using DIB bitmaps without handles
       (see TBitmap.Dormant), releases Canvas, Brush objects etc. }
    property Corrupted: Boolean read FCorrupted;
    {* True, if the image found corrupted while decoding. Note, that just after
       loading the image and after decoding several first frames, this property
       can be yet not set even for bad gifs. It becomes True for such gif images
       when a frame requested is corrupted. }
  end;

  TGifFrame = object( TObj )
  {* Object to manipulate with certain frame data of TGIF object. }
  private
    FOwner : PGifDecoder;
    FBitmap : PBitmap;
    FItem : TGifItem;
    FExtensions : PList;
    FTopLeft : TPoint;
    FInterlaced : Boolean;
    FCorrupted : Boolean;
    FTranspColor : TColor;
    FDelay : Word;
    FLocalColors : Boolean;
    FTransparent : Boolean;
    FTransIndex : Integer;
    FTransMask : PBitmap;
    FFrameIndex : Integer;
    FReallyTransparent : Boolean;
    FDisposalMethod: TDisposeMethod;
    procedure SetDelay(const Value: Word);
    function GetColorCount: Integer;
    function FindComment(ForceCreate: Boolean): PStrList;
    function GetComment: PStrList;
    procedure SetComment(const Value: PStrList);
    procedure SetDisposalMethod(const Value: TDisposeMethod);
    procedure SetTranspColor(const Value: TColor);
    procedure SetTopLeft(const Value: TPoint);
    function GetHeight: Integer;
    function GetWidth: Integer;
    function GetReallyTransparent: Boolean;
    function GetBitmap: PBitmap;
    procedure New_Bitmap;
  protected
    //constructor Create( AOwner : PGifDecoder );
    function LoadFromStream( Stream : PStream ) : Boolean;
  public
    destructor Destroy; virtual;
    {* Do not destroy frames manually. The owner of frames (TGifDecoder) is
       responsible for freeing its frames. }
    property Bitmap : PBitmap read GetBitmap;
    {* Frame bitmap. This can be only a small rectangle in bounds of
       entire GIF image. If You do not know how to combine frame
       bitmaps to produce GIF animation, use TGIF drawing methods
       to perform this task. }
    property Mask : PBitmap read FTransMask;
    {* Exact monochrome mask of transparency. Used in ZGIF drawing
       to produce correct showing of any GIF image independently
       from display resolution. }
    property Delay : Word read FDelay write SetDelay;
    {* Frame delay (delay of frame exposure). }
    property ColorCount : Integer read GetColorCount;
    {* Number of colors. }
    property Comment: PStrList read GetComment write SetComment;
    {* Comment to frame. }
    property DisposalMethod : TDisposeMethod read FDisposalMethod write SetDisposalMethod;
    {* Disposal method. This is the most hard part for recognition
       how to animate certain GIF image. It seems that it is implemented
       in TGIF well, at least, it was tested for about 200 different
       GIF clips, and no errors were found. }
    property Interlaced: Boolean read FInterlaced;
    {* True, if interlaced. }
    property Corrupted: Boolean read FCorrupted;
    {* True, if corrupted. }
    property TranspColor : TColor read FTranspColor write SetTranspColor;
    {* Transparent color. }
    property Origin: TPoint read FTopLeft write SetTopLeft;
    {* Offset of a frame from top left corner of GIF image. }
    property Width: Integer read GetWidth;
    {* Width of frame. }
    property Height: Integer read GetHeight;
    {* Height of frame. }
    property Transparent : Boolean read FTransparent;
    {* True, if frame is transparent. }
    property TransColorIndex : Integer read fTransIndex;
    {* Exact index of transparent color in frame's palette. }
    property ReallyTransparent : Boolean read GetReallyTransparent;
    {* True, if frame is "really" transparent (i.e. its transparent
       color is used in frame at least for one pixel). }
    procedure FreeResources;
    {* }
    procedure Draw( DC : HDC; X, Y : Integer );
    {* }
    procedure StretchDraw( DC : HDC; Rect : TRect );
    {* }
  end;

/////////////////////////////////////////////////////////////
  PGif = ^TGif;
  TGif = object( TObj )
  {* GIF decoding and painting object. This object represents almost full
     decoder, which yet not a control but already sufficiently "clever"
     to treat "frame" as a result of all previous frame commands. I.e.
     You do not need to combine frames by yourself to provide animation.
     Just change current frame index (usually increase) and call one of
     drawing methods to paint the desired frame. }
  private
    FGifImage : PGifDecoder;
    FCurFrame : PBitmap;
    FCurMask : PBitmap;
    FCurIndex : Integer;
    FPrevFrame : PBitmap;
    FPrevMask : PBitmap;
    procedure PrepareFrame;
    function GetBkColor: TColor;
    procedure SetBkColor(const Value: TColor);
    function GetFrames(Idx: Integer): PGifFrame;
    function GetTransparent: Boolean;
    function GetCorrupted: Boolean;
  protected
    FOnChanged: TOnEvent;
    function GetWidth : Integer;
    procedure SetWidth( Value : Integer );
    function GetHeight : Integer;
    procedure SetHeight( Value : Integer );
    function GetFrame : Integer;
    procedure SetFrame( Value : Integer );
    function GetFrameCount : Integer;
    function GetDelays( Idx : Integer ) : Integer;
    procedure SetDelays( Idx : Integer; Value : Integer );
    procedure Changed;
  public
    destructor Destroy; virtual;
    {* Destructor. }
    procedure Clear;
    {* Obvious. }
    property Width: Integer read GetWidth write SetWidth;
    {* Width of total GIF image. }
    property Height: Integer read GetHeight write SetHeight;
    {* Height of total GIF image. }
    procedure FreeResources;
    {* Call this method to free GDI resources, allocated for decoding gif image,
       and to drawing it. This does not destroy any image information or data
       already obtained from encoded frames. It is possible to call this method
       after drawing every other frame, but this can slow down drawing process
       a bit. }
    procedure Draw( DC : HDC; X, Y : Integer );
    {* Draws current frame. }
    procedure DrawTransp( DC: HDC; X, Y: Integer );
    {* Draws current frame transparently, using its native TranspColor as
       transparent color if any. If the frame is not transparent, it is
       drawing non-transparently. }
    procedure DrawTransparent( DC : HDC; X, Y : Integer; TranspColor : TColor );
    {* Draws current frame transparently. }
    procedure StretchDraw( DC : HDC; const Dest : TRect ); //override;
    {* Draws current frame with stretching. }
    procedure StretchDrawTransp( DC: HDC; const Dest: TRect );
    {* Draws current frame stretched and transparently using BkColor as a
       transparent color or using Mask if available. }
    procedure StretchDrawTransparent( DC : HDC; const Dest : TRect; TranspColor : TColor );
    {* Draws current frame with strethcing transparently. }
    property BkColor : TColor read GetBkColor write SetBkColor;
    {* Background color. }
    property Frames[ Idx : Integer ] : PGifFrame read GetFrames;
    {* Array of frame data. }
    property Transparent : Boolean read GetTransparent;
    {* True, if GIF is transparent (i.e. at least one of frames is transparent). }
    function LoadFromStream( Stream : PStream ) : Boolean;
    {* Loads GIF from a stream. }
    function LoadFromFile( const FileName : String ) : Boolean;
    {* Loads GIF from a file. }
    function LoadFromResourceName( Inst: HInst; RsrcName: PChar ): Boolean;
    {* Call this method to load GIF image from resource by its name.
       GIF image must be stored in RCDATA resource named using unique
       ANSI string. }
    function LoadFromResourceID(Instance: HInst; ResID: Integer): Boolean;
    {* Call this method to load GIF from resource (RCDATA) by ID. }
    property Count: Integer read GetFrameCount;
    {* Number of frames in a gif. }
    property Frame: Integer read GetFrame write SetFrame;
    {* Index of current frame. }
    property Delay[ Idx: Integer ]: Integer read GetDelays write SetDelays;
    {* Delay for every frame. }
    property Corrupted: Boolean read GetCorrupted;
    {* True if any of frames decoded is corrupted or could not be decoded. }
  end;

function NewGif: PGif;
{* Call this function to create fully featured gif decoding and painting object.
   This adds about 30K code to the executable. }
function NewGifNoMask: PGif;
{* Call this method to create gif decoding object, which does not support for
   truth mask (some animated and / or transparent images are drawn incorrectly,
   but code used is smaller a bit). Actually, this economies only about 1K of code. }
function NewGifDecoder: PGifDecoder;
{* Call this method to create simple gif reading object, which just decodes
   separate frames. If only this type of objects is used, smaller portion of
   code is included into final executeable. Actually, this economies about 5-6K
   of executable size. }

procedure DrawBitmapMaskMask( DC : HDC; X, Y : Integer; Bmp, Msk : PBitmap );
procedure DrawBitmapMask( DC : HDC; X, Y : Integer; Bmp, Msk : PBitmap );

type
  PGifShow = ^TGifShow;
  TGifShow = object( TControl )
  private
    function GetDummy: Boolean;
  protected
    function GetAnimate: Boolean;
    function GetGif: PGif;
    procedure SetAnimate(const Value: Boolean);
    function GetLoop: Boolean;
    function GetOnEndLoop: TOnEvent;
    procedure SetLoop(const Value: Boolean);
    procedure SetOnEndLoop(const Value: TOnEvent);
    function GetAutosize: Boolean;
    function GetStretch: Boolean;
    procedure SetAutosize(const Value: Boolean);
    procedure SetStretch(const Value: Boolean);
  protected
    procedure GifChanged( Sender: PObj );
    procedure NextFrame( Sender: PObj );
    procedure PaintFrame( Sender: PControl; DC: HDC );
  public
    {$WARNINGS OFF}
    property Autosize: Boolean read GetAutosize write SetAutosize;
    {$WARNINGS ON}
    property Stretch: Boolean read GetStretch write SetStretch;
    property Animate: Boolean read GetAnimate write SetAnimate;
    property Loop: Boolean read GetLoop write SetLoop;
    //property Dormant: Boolean read GetDormant write SetDormant;
    property Gif: PGif read GetGif;
    property OnEndLoop: TOnEvent read GetOnEndLoop write SetOnEndLoop;
    property OnPaint: Boolean read GetDummy;
    function LoadFromStream( Stream : PStream ) : Boolean;
    {* Call this method to load gif image from a stream and decode it. After
       loading, first frame is decoded and ready to be drawn immediately. All
       other frames are decoded when requested first time. Since this, a property
       Corrupted can be not set to True just after loading the image and decoding
       several first frames, and can become True later, when requested frame
       found corrupted while decoding it. }
    function LoadFromFile( const FileName : String ) : Boolean;
    {* Call this method to load gif image from the file and decode it. See
       also LoadFromStream - the most told there is true here too. }
    function LoadFromResourceName( Inst: HInst; RsrcName: PChar ): Boolean;
    {* Call this method to load GIF image from resource by its name.
       GIF image must be stored in RCDATA resource named using unique
       ANSI string. }
    function LoadFromResourceID(Instance: HInst; ResID: Integer): Boolean;
    {* Call this method to load GIF from resource (RCDATA) by ID. }
  end;

function NewGifShow( AParent: PControl ): PGifShow;

type TKOLGifShow = PGifShow;

implementation

const
      ROP_DstAndNotSrc = $00220326;

function NewGifFrame( AOwner: PGifDecoder ): PGifFrame; forward;

procedure DrawBitmapMaskMask( DC : HDC; X, Y : Integer; Bmp, Msk : PBitmap );
begin
  if Msk = nil then
     Bmp.Draw( DC, X, Y )
  else
  //if Bmp.HandleAllocated then
  begin
    BitBlt( DC, X, Y, Bmp.Width, Bmp.Height, Msk.Canvas.Handle,
            0, 0, SrcAnd );
    {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}
    BitBlt( DC, X, Y, Bmp.Width, Bmp.Height,
            Bmp.Canvas.Handle, 0, 0, SRCPAINT );
    {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}
  end;
end;

procedure DrawBitmapMask( DC : HDC; X, Y : Integer; Bmp, Msk : PBitmap );
var TmpBmp : PBitmap;
begin
  if Msk = nil then
     Bmp.Draw( DC, X, Y )
  else
  //if Bmp.HandleAllocated then
  begin
    TmpBmp := NewBitmap( 0, 0 );
    TmpBmp.Assign( Bmp );
    BitBlt( TmpBmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height,
            Msk.Canvas.Handle, 0, 0, ROP_DstAndNotSrc );
    {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}
    DrawBitmapMaskMask( DC, X, Y, TmpBmp, Msk );
    //TmpBmp.SaveToFile( GetStartDir + 'DrawBitmapMask.TmpBmp.bmp' );
    //Msk.SaveToFile( GetStartDir + 'DrawBitmapMask.Msk.bmp' );
    TmpBmp.Free;
  end;
end;

procedure StretchBitmapMaskMask( DC : HDC; Rect : TRect; Bmp, Msk : PBitmap );
var OldMode: Integer;
    OldOrgX: TPoint;
begin
  OldMode := SetStretchBltMode( DC, HALFTONE );
  SetBrushOrgEx( DC, 0, 0, @ OldOrgX );
  if Msk = nil then
     Bmp.StretchDraw( DC, Rect )
  else
  //if Bmp.HandleAllocated then
  begin
    StretchBlt( DC, Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
                Msk.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, SrcAnd );
    StretchBlt( DC, Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
                Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, SRCPAINT );
  end;
  SetBrushOrgEx( DC, OldOrgX.x, OldOrgX.y, nil );
  SetStretchBltMode( DC, OldMode );
end;

procedure StretchBitmapMask( DC : HDC; Rect : TRect; Bmp, Msk : PBitmap );
var TmpBmp : PBitmap;
    OldMode: Integer;
    OldOrgX: TPoint;
begin
  OldMode := SetStretchBltMode( DC, HALFTONE );
  SetBrushOrgEx( DC, 0, 0, @ OldOrgX );
  if Msk = nil then
     Bmp.StretchDraw( DC, Rect )
  else
  //if Bmp.HandleAllocated then
  begin
    //TmpBmp := NewDIBBitmap( 0, 0, Bmp.PixelFormat );
    TmpBmp := NewBitmap( 0, 0 );
    TmpBmp.Assign( Bmp );
    BitBlt( TmpBmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height,
            Msk.Canvas.Handle, 0, 0, ROP_DstAndNotSrc );
    {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}
    StretchBitmapMaskMask( DC, Rect, TmpBmp, Msk );
    TmpBmp.Free;
  end;
  SetBrushOrgEx( DC, OldOrgX.x, OldOrgX.y, nil );
  SetStretchBltMode( DC, OldMode );
end;

{function HugeOffset(HugePtr: Pointer; Amount: Longint): Pointer;
begin
  Result := PChar(HugePtr) + Amount;
end;}

function AllocMemo(Size: Longint): Pointer;
begin
  if Size > 0 then
    Result := GlobalAllocPtr(HeapAllocFlags or GMEM_ZEROINIT, Size)
  else Result := nil;
end;

procedure FreeMemo(var fpBlock: Pointer);
begin
  if fpBlock <> nil then begin
    GlobalFreePtr(fpBlock);
    fpBlock := nil;
  end;
end;

const
  GIFSignature = 'GIF';
  GIFVersionStr: array[TGIFVersion] of PChar = (#0#0#0, '87a', '89a');

const
  CODE_TABLE_SIZE = 4096;
  HASH_TABLE_SIZE = 17777;
  MAX_LOOP_COUNT  = 30000;

  CHR_EXT_INTRODUCER    = '!';
  CHR_IMAGE_SEPARATOR   = ',';
  CHR_TRAILER           = ';';  { indicates the end of the GIF Data stream }

{ Image descriptor bit masks }

  ID_LOCAL_COLOR_TABLE  = $80;  { set if a local color table follows }
  ID_INTERLACED         = $40;  { set if image is interlaced }
  ID_SORT               = $20;  { set if color table is sorted }
  ID_RESERVED           = $0C;  { reserved - must be set to $00 }
  ID_COLOR_TABLE_SIZE   = $07;  { Size of color table as above }

{ Logical screen descriptor packed field masks }

  LSD_GLOBAL_COLOR_TABLE = $80; { set if global color table follows L.S.D. }
  LSD_COLOR_RESOLUTION   = $70; { Color resolution - 3 bits }
  LSD_SORT               = $08; { set if global color table is sorted - 1 bit }
  LSD_COLOR_TABLE_SIZE   = $07; { Size of global color table - 3 bits }
                                { Actual Size = 2^value+1    - value is 3 bits }

{ Graphic control extension packed field masks }

  GCE_TRANSPARENT     = $01; { whether a transparency Index is given }
  GCE_USER_INPUT      = $02; { whether or not user input is expected }
  GCE_DISPOSAL_METHOD = $1C; { the way in which the graphic is to be treated after being displayed }
  GCE_RESERVED        = $E0; { reserved - must be set to $00 }

{ Application extension }

  AE_LOOPING          = $01; { looping Netscape extension }

  GIFColors: array[TGIFBits] of Word = (2, 4, 8, 16, 32, 64, 128, 256);

function ColorsToBits(ColorCount: Word): Byte;
var
  I: TGIFBits;
begin
  for I := Low(TGIFBits) to High(TGIFBits) do
    if ColorCount = GIFColors[I] then
    begin
      Result := I;
      Exit;
    end;
  Result := 0;
end;

{function ColorsToPixelFormat(Colors: Word): TPixelFormat;
begin
  //if Colors <= 2 then Result := pf1bit
  //else if Colors <= 16 then Result := pf4bit
  //else if Colors <= 256 then Result := pf8bit
  //else Result := pf24bit;
  //else
    Result := pf16bit;  //&&&
end;}

function ItemToRGB(const Item: TGIFColorItem): Longint;
begin
  with Item do
    Result := RGB(Red, Green, Blue);
end;

{ The following types and function declarations are used to call into
  functions of the GIF implementation of the GIF image
  compression/decompression standard. }

type
  TGIFHeader = packed record
    Signature: array[0..2] of Char; { contains 'GIF' }
    Version: array[0..2] of Char;   { '87a' or '89a' }
  end;

  TScreenDescriptor = packed record
    ScreenWidth: Word;            { logical screen width }
    ScreenHeight: Word;           { logical screen height }
    PackedFields: Byte;
    BackgroundColorIndex: Byte;   { Index to global color table }
    AspectRatio: Byte;            { actual ratio = (AspectRatio + 15) / 64 }
  end;

  TImageDescriptor = packed record
    ImageLeftPos: Word;   { column in pixels in respect to left of logical screen }
    ImageTopPos: Word;    { row in pixels in respect to top of logical screen }
    ImageWidth: Word;     { width of image in pixels }
    ImageHeight: Word;    { height of image in pixels }
    PackedFields: Byte;
  end;

{ GIF Extensions support }

type
  TExtensionType = (etGraphic, etPlainText, etApplication, etComment);

const
  ExtLabels: array[TExtensionType] of Byte = ($F9, $01, $FF, $FE);
  LoopExt: string[11] = 'NETSCAPE2.0';

type
  TGraphicControlExtension = packed record
    BlockSize: Byte; { should be 4 }
    PackedFields: Byte;
    DelayTime: Word; { in centiseconds }
    TransparentColorIndex: Byte;
    Terminator: Byte;
  end;

  TPlainTextExtension = packed record
    BlockSize: Byte; { should be 12 }
    Left, Top, Width, Height: Word;
    CellWidth, CellHeight: Byte;
    FGColorIndex, BGColorIndex: Byte;
  end;

  TAppExtension = packed record
    BlockSize: Byte; { should be 11 }
    AppId: array[1..8] of Byte;
    Authentication: array[1..3] of Byte;
  end;

  TExtensionRecord = packed record
    case ExtensionType: TExtensionType of
      etGraphic: (GCE: TGraphicControlExtension);
      etPlainText: (PTE: TPlainTextExtension);
      etApplication: (APPE: TAppExtension);
  end;

type
  PExtension = ^TExtension;
  TExtension = object( TObj )
  private
    FExtType: TExtensionType;
    FList: PStrList;
    FExtRec: TExtensionRecord;
  public
    function IsLoopExtension: Boolean;
    destructor Destroy; virtual;
  end;

destructor TExtension.Destroy;
begin
  FList.Free;
  inherited;
end;

function TExtension.IsLoopExtension: Boolean;
begin
  Result := (FExtType = etApplication) and CompareMem(@FExtRec.APPE.AppId,
    @LoopExt[1], FExtRec.APPE.BlockSize) and (FList.Count > 0) and
    (Length(FList.Items[0]) >= 3) and (Byte(FList.Items[0][1]) = AE_LOOPING);
end;

function FindExtension(Extensions: PList; ExtType: TExtensionType): PExtension;
var
  I: Integer;
begin
  if Extensions <> nil then
    for I := Extensions.Count - 1 downto 0 do begin
      Result := PExtension(Extensions.Items[I]);
      if (Result <> nil) and (Result.FExtType = ExtType) then Exit;
    end;
  Result := nil;
end;

procedure FreeExtensions(Extensions: PList);
begin
  if Extensions <> nil then
  begin
    while Extensions.Count > 0 do
    begin
      PObj(Extensions.Items[Extensions.Count - 1]).Free;
      Extensions.Delete(Extensions.Count - 1);
    end;
    Extensions.Free;
  end;
end;

{ GIF read procedures

  Procedures to read and write GIF files, GIF-decoding and encoding
  based on freeware C source code of GBM package by Andy Key
  (nyangau@interalpha.co.uk). The home page of GBM author is
  at http://www.interalpha.net/customer/nyangau/. }

type
  PIntCodeTable = ^TIntCodeTable;
  TIntCodeTable = array[0..CODE_TABLE_SIZE - 1] of Word;

  PReadContext = ^TReadContext;
  TReadContext = record
    Inx, Size: Longint;
    Buf: array[0..255 + 4] of Byte;
    CodeSize: Longint;
    ReadMask: Longint;
  end;

  TOutputContext = record
    W, H, X, Y: Longint;
    BitsPerPixel, Pass: Integer;
    Interlace: Boolean;
    LineIdent: Longint;
    Data, CurrLineData: Pointer;
  end;

  PImageDict = ^TImageDict;
  TImageDict = record
    Tail, Index: Word;
    Col: Byte;
  end;

  PDictTable = ^TDictTable;
  TDictTable = array[0..CODE_TABLE_SIZE - 1] of TImageDict;

  PRGBPalette = ^TRGBPalette;
  TRGBPalette = array [Byte] of TRGBQuad;

function InterlaceStep(Y, Height: Integer; var Pass: Integer): Integer;
begin
  Result := Y;
  case Pass of
    0, 1: Inc(Result, 8);
    2: Inc(Result, 4);
    3: Inc(Result, 2);
  end;
  if Result >= Height then begin
    if Pass = 0 then begin
      Pass := 1; Result := 4;
      if (Result < Height) then Exit;
    end;
    if Pass = 1 then begin
      Pass := 2; Result := 2;
      if (Result < Height) then Exit;
    end;
    if Pass = 2 then begin
      Pass := 3; Result := 1;
    end;
  end;
end;

procedure ReadImageStream(Stream : PStream;  Dest: PStream; var Desc: TImageDescriptor;
  var Interlaced, LocalColors, Corrupted: Boolean; var BitsPerPixel: Byte;
  var ColorTable: TGIFColorTable);
const BufSize = 1024;
var
  CodeSize, BlockSize: Byte;

  procedure ProvideDestSize( Size : DWord );
  begin
    if Dest.Size < Size then
       Dest.Size := Size;
  end;
begin
  Corrupted := False;
  Stream.Read(Desc, SizeOf(TImageDescriptor));
  Interlaced := (Desc.PackedFields and ID_INTERLACED) <> 0;
  if (Desc.PackedFields and ID_LOCAL_COLOR_TABLE) <> 0 then
  begin
    { Local colors table follows }
    BitsPerPixel := 1 + Desc.PackedFields and ID_COLOR_TABLE_SIZE;
    LocalColors := True;
    ColorTable.ColorCount := 1 shl BitsPerPixel;
    Stream.Read(ColorTable.Colors[0],
      ColorTable.ColorCount * SizeOf(TGIFColorItem));
  end
    else
  begin
    LocalColors := False;
    FillChar(ColorTable, SizeOf(ColorTable), 0);
  end;
  Stream.Read(CodeSize, 1);
  ProvideDestSize( BufSize );
  Dest.Write(CodeSize, 1);
  repeat
    Stream.Read(BlockSize, 1);
    if (Stream.Position + BlockSize) > Stream.Size then
    begin
      Corrupted := True;
      Exit; {!!?}
    end;
    ProvideDestSize( ((Dest.Size + 1 + BlockSize + BufSize - 1) div BufSize) * BufSize );
    Dest.Write(BlockSize, 1);
    if (Stream.Position + BlockSize) > Stream.Size then
    begin
      BlockSize := Stream.Size - Stream.Position;
      Corrupted := True;
    end;
    if BlockSize > 0 then
       Stream2Stream( Dest, Stream, BlockSize );
  until (BlockSize = 0) or (Stream.Position >= Stream.Size);
end;

procedure FillRGBPalette(const ColorTable: TGIFColorTable;
  var Colors: TRGBPalette);
var
  I: Byte;
begin
  FillChar(Colors, SizeOf(Colors), $80);
  for I := 0 to ColorTable.ColorCount - 1 do begin
    Colors[I].rgbRed := ColorTable.Colors[I].Red;
    Colors[I].rgbGreen := ColorTable.Colors[I].Green;
    Colors[I].rgbBlue := ColorTable.Colors[I].Blue;
    Colors[I].rgbReserved := 0;
  end;
end;

function ReadCode(Stream: PStream; var Context: TReadContext): Longint;
var
  RawCode: Longint;
  ByteIndex: Longint;
  Bytes: Byte;
  BytesToLose: Longint;
begin
  while (Context.Inx + Context.CodeSize > Context.Size) and
    (Stream.Position < Stream.Size) do
  begin
    { not enough bits in buffer - refill it }
    { Not very efficient, but infrequently called }
    BytesToLose := Context.Inx shr 3;
    { Note biggest Code Size is 12 bits. And this can at worst span 3 Bytes }
    Move(Context.Buf[Word(BytesToLose)], Context.Buf[0], 3);
    Context.Inx := Context.Inx and 7;
    Context.Size := Context.Size - (BytesToLose shl 3);
    Stream.Read(Bytes, 1);
    if Bytes > 0 then
      Stream.Read(Context.Buf[Word(Context.Size shr 3)], Bytes);
    Context.Size := Context.Size + (Bytes shl 3);
  end;
  ByteIndex := Context.Inx shr 3;
  RawCode := Context.Buf[Word(ByteIndex)] +
    (Word(Context.Buf[Word(ByteIndex + 1)]) shl 8);
  if Context.CodeSize > 8 then
    RawCode := RawCode + (Longint(Context.Buf[ByteIndex + 2]) shl 16);
  RawCode := RawCode shr (Context.Inx and 7);
  Context.Inx := Context.Inx + Byte(Context.CodeSize);
  Result := RawCode and Context.ReadMask;
end;

procedure Output(Value: Byte; var Context: TOutputContext);
var
  P: PByte;
begin
  if (Context.Y >= Context.H) then Exit;
  case Context.BitsPerPixel of
    1: begin
         //P := HugeOffset(Context.CurrLineData, Context.X shr 3);
         P := Pointer( Integer( Context.CurrLineData ) + Context.X shr 3 );
         if (Context.X and $07 <> 0) then
           P^ := P^ or Word(value shl (7 - (Word(Context.X and 7))))
         else P^ := Byte(value shl 7);
       end;
    4: begin
         //P := HugeOffset(Context.CurrLineData, Context.X shr 1);
         P := Pointer( Integer( Context.CurrLineData ) + Context.X shr 1 );
         if (Context.X and 1 <> 0) then P^ := P^ or Value
         else P^ := Byte(value shl 4);
       end;
    8: begin
         //P := HugeOffset(Context.CurrLineData, Context.X);
         P := Pointer( Integer( Context.CurrLineData ) + Context.X );
         P^ := Value;
       end;
  end;
  Inc(Context.X);
  if Context.X < Context.W then Exit;
  Context.X := 0;
  if Context.Interlace then
    Context.Y := InterlaceStep(Context.Y, Context.H, Context.Pass)
  else Inc(Context.Y);
  Context.CurrLineData := //HugeOffset(Context.Data,
    //(Context.H - 1 - Context.Y) * Context.LineIdent);
    Pointer( Integer( Context.Data ) + (Context.H - 1 - Context.Y) * Context.LineIdent );
end;


procedure ReadGIFData(Stream: PStream; const Header: TBitmapInfoHeader;
  Interlaced: Boolean; IntBitPerPixel: Byte; Data: Pointer;
  var Corrupted: Boolean);
var
  MinCodeSize: Byte;
  MaxCode, BitMask, InitCodeSize: Longint;
  ClearCode, EndingCode, FirstFreeCode, FreeCode: Word;
  I, OutCount, Code: Longint;
  CurCode, OldCode, InCode, FinalChar: Word;
  Prefix, Suffix, OutCode: PIntCodeTable;
  ReadCtxt: TReadContext;
  OutCtxt: TOutputContext;
  TableFull: Boolean;
begin
  Corrupted := False;
  OutCount := 0; OldCode := 0; FinalChar := 0;
  TableFull := False;
  Prefix := AllocMem(SizeOf(TIntCodeTable));
  //try
    Suffix := AllocMem(SizeOf(TIntCodeTable));
    //try
      OutCode := AllocMem(SizeOf(TIntCodeTable) + SizeOf(Word));
      //try
        //try
          Stream.Read(MinCodeSize, 1);
          if (MinCodeSize < 2) or (MinCodeSize > 9) then
          begin
            //GifError( 'Bad GIF Code Size' );
            Corrupted := True;
            Exit;
          end;
          { Initial read context }
          ReadCtxt.Inx := 0;
          ReadCtxt.Size := 0;
          ReadCtxt.CodeSize := MinCodeSize + 1;
          ReadCtxt.ReadMask := (1 shl ReadCtxt.CodeSize) - 1;
          { Initialise pixel-output context }
          OutCtxt.X := 0; OutCtxt.Y := 0;
          OutCtxt.Pass := 0;
          OutCtxt.W := Header.biWidth;
          OutCtxt.H := Header.biHeight;
          OutCtxt.BitsPerPixel := Header.biBitCount;
          OutCtxt.Interlace := Interlaced;
          OutCtxt.LineIdent := ((Header.biWidth * Header.biBitCount + 31)
            div 32) * 4;
          OutCtxt.Data := Data;
          //OutCtxt.CurrLineData := HugeOffset(Data, (Header.biHeight - 1) *
          //  OutCtxt.LineIdent);
          OutCtxt.CurrLineData := Pointer( Integer( Data ) + (Header.biHeight - 1) *
              OutCtxt.LineIdent );
          BitMask := (1 shl IntBitPerPixel) - 1;
          { 2 ^ MinCodeSize accounts for all colours in file }
          ClearCode := 1 shl MinCodeSize;
          EndingCode := ClearCode + 1;
          FreeCode := ClearCode + 2;
          FirstFreeCode := FreeCode;
          { 2^ (MinCodeSize + 1) includes clear and eoi Code and space too }
          InitCodeSize := ReadCtxt.CodeSize;
          MaxCode := 1 shl ReadCtxt.CodeSize;
          Code := ReadCode(Stream, ReadCtxt);
          while (Code <> EndingCode) and (Code <> $FFFF) and
            (OutCtxt.Y < OutCtxt.H) do
          begin
            if (Code = ClearCode) then begin
              ReadCtxt.CodeSize := InitCodeSize;
              MaxCode := 1 shl ReadCtxt.CodeSize;
              ReadCtxt.ReadMask := MaxCode - 1;
              FreeCode := FirstFreeCode;
              Code := ReadCode(Stream, ReadCtxt);
              CurCode := Code; OldCode := Code;
              if (Code = $FFFF) then Break;
              FinalChar := (CurCode and BitMask);
              Output(Byte(FinalChar), OutCtxt);
              TableFull := False;
            end
              else
            begin
              CurCode := Code;
              InCode := Code;
              if CurCode >= FreeCode then begin
                CurCode := OldCode;
                OutCode^[OutCount] := FinalChar;
                Inc(OutCount);
              end;
              while (CurCode > BitMask) do
              begin
                if (OutCount > CODE_TABLE_SIZE) then
                begin
                  //if LoadCorrupt then
                  //begin
                    CurCode := BitMask;
                    OutCount := 1;
                    Corrupted := True;
                    Break;
                  {end
                    else //GifError( 'GIF Decode Error' );
                  begin
                    Corrupted := True;
                    Break;
                  end;}
                end;
                OutCode^[OutCount] := Suffix^[CurCode];
                Inc(OutCount);
                CurCode := Prefix^[CurCode];
              end;
              if Corrupted then Break;
              FinalChar := CurCode and BitMask;
              OutCode^[OutCount] := FinalChar;
              Inc(OutCount);
              for I := OutCount - 1 downto 0 do
                Output(Byte(OutCode^[I]), OutCtxt);
              OutCount := 0;
              { Update dictionary }
              if not TableFull then begin
                Prefix^[FreeCode] := OldCode;
                Suffix^[FreeCode] := FinalChar;
                { Advance to next free slot }
                Inc(FreeCode);
                if (FreeCode >= MaxCode) then begin
                  if (ReadCtxt.CodeSize < 12) then begin
                    Inc(ReadCtxt.CodeSize);
                    MaxCode := MaxCode shl 1;
                    ReadCtxt.ReadMask := (1 shl ReadCtxt.CodeSize) - 1;
                  end
                  else TableFull := True;
                end;
              end;
              OldCode := InCode;
            end;
            Code := ReadCode(Stream, ReadCtxt);
          end; { while }
          if Code = $FFFF then //GifError('Read GIF Error');
          begin
             Corrupted := True;
             //Break;
          end;
        //finally
        //end;
      //finally
        FreeMem( OutCode {, SizeOf(TIntCodeTable) + SizeOf(Word)} );
      //end;
    //finally
      FreeMem(Suffix {, SizeOf(TIntCodeTable)} );
    //end;
  //finally
    FreeMem(Prefix {, SizeOf(TIntCodeTable)} );
  //end;
end;

{ TGifFrame }

function NewGifFrame(AOwner: PGifDecoder): PGifFrame;
begin
  new( Result, Create );
  Result.FOwner := AOwner;
  Result.FTransIndex := -1;
  Result.FItem.FImageData := NewMemoryStream;
  Result.FTranspColor := clNone;
end;

destructor TGifFrame.Destroy;
begin
  FBitmap.Free;
  FTransMask.Free;
  FItem.FImageData.Free;
  FreeExtensions( FExtensions );
  inherited;
end;

procedure TGifFrame.Draw(DC : HDC; X, Y: Integer);
begin
  GetBitmap; // create Mask if it is needed

  if Mask = nil then
    FBitmap.Draw( DC, X, Y )
  else
    DrawBitmapMask( DC, X, Y, FBitmap, FTransMask );
end;

function TGifFrame.FindComment(ForceCreate: Boolean): PStrList;
var
  Ext: PExtension;
begin
  Ext := FindExtension(FExtensions, etComment);
  if (Ext = nil) and ForceCreate then
  begin
    new( Ext, Create );
    Ext.FExtType := etComment;
    if FExtensions = nil then FExtensions := NewList;
    FExtensions.Add(Ext);
  end;
  if (Ext <> nil) then
  begin
    if (Ext.FList = nil) and ForceCreate then
      Ext.FList := NewStrList;
    Result := Ext.FList;
  end
  else Result := nil;
end;

procedure TGifFrame.FreeResources;
begin
  if FBitmap <> nil then
     FBitmap.Dormant;
  if FTransMask <> nil then
     FTransMask.Dormant;
end;

{procedure SnapStream2File( Strm: PStream; const Fname: String );
var PP: Integer;
    FS: PStream;
begin
  PP := Strm.Position;
  Strm.Position := 0;
  FS := NewWriteFileStream( Fname );
  Stream2Stream( FS, Strm, Strm.Size );
  FS.Free;
  Strm.Position := PP;
end;}

function FillMaskLine4( Mask, Scan : PByte; W : Integer; TransIdx : Integer )
         : Boolean;
assembler;
asm
   PUSH ESI
   PUSH EDI
   PUSH EBX
   MOV EDI, EAX
   MOV ESI, EDX
   MOV EDX, TransIdx
   MOV DH, 0
   INC ECX
   SHR ECX, 1
   JZ @@fin
   MOV BX, 8000h
   CLD
@@loop1:
   LODSB
   MOV AH, AL
   SHR AH, 4
   CMP AH, DL
   JNZ @@1
   OR BL, BH
   MOV DH, BL
@@1: ROR BH, 1
   AND AL, 0Fh
   CMP AL, DL
   JNZ @@2
   OR BL, BH
   MOV DH, BL
@@2: ROR BH, 1
   JNC @@e_loop
   MOV [EDI], BL
   INC EDI
   MOV BL, 0
@@e_loop:
   LOOP @@loop1
   CMP BH, 80h
   JZ @@fin
   MOV [EDI], BL

@@fin:
   XOR EAX, EAX
   MOV AL, DH
   POP EBX
   POP EDI
   POP ESI
end;

function FillMaskLine8( Mask, Scan : PByte; W : Integer; TransIdx : Integer )
         : Boolean;
assembler;
asm
   PUSH ESI
   PUSH EDI
   PUSH EBX
   MOV EDI, EAX
   MOV ESI, EDX
   MOV EDX, TransIdx
   MOV DH, 0
   JECXZ @@fin
   MOV BX, 8000h
   CLD
@@loop1:
   LODSB
   CMP AL, DL
   JNZ @@2
   OR BL, BH
   MOV DH, BL
@@2: ROR BH, 1
   JNC @@e_loop
   MOV [EDI], BL
   INC EDI
   MOV BL, 0
@@e_loop:
   LOOP @@loop1
   CMP BH, 80h
   JZ @@fin
   MOV [EDI], BL

@@fin:
   XOR EAX, EAX
   MOV AL, DH
   POP EBX
   POP EDI
   POP ESI
end;

function FillMaskLine0( Mask, Scan : PByte; W : Integer )
         : Boolean;
assembler;
asm
   PUSH ESI
   PUSH EDI
   MOV EDI, EAX
   MOV ESI, EDX
   MOV EDX, 0
   ADD ECX, 7
   SHR ECX, 3
   JZ @@fin
   CLD
@@loop1:
   LODSB
   NOT AL
   STOSB
   OR DL, AL
   LOOP @@loop1

@@fin:
   MOV EAX, EDX
   POP EDI
   POP ESI
end;

function FillMaskLine1( Mask, Scan : PByte; W : Integer )
         : Boolean;
assembler;
asm
   PUSH ESI
   PUSH EDI
   MOV EDI, EAX
   MOV ESI, EDX
   MOV EDX, 0
   ADD ECX, 7
   SHR ECX, 3
   JZ @@fin
   CLD
@@loop1:
   LODSB
   STOSB
   OR DL, AL
   LOOP @@loop1

@@fin:
   MOV EAX, EDX
   POP EDI
   POP ESI
end;

function FillMaskBitmap(Mask: PBitmap; Width, Height: Integer;
  Bits: PByte; BitsPerPixel, LineWidth, TransIndex: Integer): Boolean;
var Y : Integer;
    P, S : PByte;
begin
   Result := False;
   if TransIndex < 0 then Exit;
   P := Mask.ScanLine[ 0 ];
   if P = nil then Exit;
   if BitsPerPixel = 4 then
   for Y := Height - 1 downto 0 do
   begin
      P := Mask.ScanLine[ Y ];
      S := Bits;
      Result := FillMaskLine4( P, S, Width, TransIndex );
      Inc( Bits, LineWidth );
   end;
   if BitsPerPixel = 8 then
   for Y := Height - 1 downto 0 do
   begin
      P := Mask.ScanLine[ Y ];
      S := Bits;
      Result := FillMaskLine8( P, S, Width, TransIndex );
      Inc( Bits, LineWidth );
   end;
   if BitsPerPixel = 1 then
   for Y := Height - 1 downto 0 do
   begin
      P := Mask.ScanLine[ Y ];
      S := Bits;
      if Byte( TransIndex ) = 0 then
         Result := FillMaskLine0( P, S, Width )
      else
         Result := FillMaskLine1( P, S, Width );
      Inc( Bits, LineWidth );
   end;
end;

procedure ProvideTruthMask( Sender: PObj; var BIH: TBitmapInfoHeader; Bits: Pointer );
var Frame: PGifFrame;
begin
  Frame := PGifFrame( Sender );
  if Frame.FTransIndex >= 0 then
  begin
    Frame.FTransMask := NewBitmap( BIH.biWidth, BIH.biHeight );
    Frame.FTransMask.PixelFormat := pf1bit;

    Frame.FReallyTransparent :=
    FillMaskBitmap( Frame.FTransMask, BIH.biWidth, BIH.biHeight, Bits,
                    BIH.biBitCount,
                    ((BIH.biWidth * BIH.biBitCount + 31) div 32) * 4,
                    Frame.FTransIndex );
  end;
end;

function TGifFrame.GetBitmap: PBitmap;
var Mem : PStream;

  function ConvertBitsPerPixel: TPixelFormat;
  begin
    case FItem.FBitsPerPixel of
      1: Result := pf1bit;
      2..4: Result := pf4bit;
      5..8: Result := pf8bit;
      else Result := pfDevice;
    end;
  end;

  procedure SaveToBmpStream;
  var
    HeaderSize: Longword;
    Length: Longword;
    BIH: TBitmapInfoHeader;
    BFH: TBitmapFileHeader;
    Colors: TRGBPalette;
    Bits: Pointer;
    Corrupt: Boolean;
  begin
    with BIH do begin
      biSize := Sizeof(TBitmapInfoHeader);
      biWidth := FItem.FSize.X;
      biHeight := FItem.FSize.Y;
      biPlanes := 1;
      biBitCount := 0;
      case ConvertBitsPerPixel of
        pf1bit: biBitCount := 1;
        pf4bit: biBitCount := 4;
        else biBitCount := 8;
      end;
      biCompression := BI_RGB;
      biSizeImage := (((biWidth * biBitCount + 31) div 32) * 4) * biHeight;
      biXPelsPerMeter := 0;
      biYPelsPerMeter := 0;
      biClrUsed := 0;
      biClrImportant := 0;
    end;
    HeaderSize := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader) +
      SizeOf(TRGBQuad) * (1 shl BIH.biBitCount);
    Length := HeaderSize + BIH.biSizeImage;
    Mem.Size := 0;
    with BFH do begin
      bfType := $4D42; { 'BM' }
      bfSize := Length;
      bfOffBits := HeaderSize;
    end;
    Mem.Write(BFH, SizeOf(TBitmapFileHeader));
    Mem.Write(BIH, SizeOf(TBitmapInfoHeader));
    FillRGBPalette(FItem.FColorMap, Colors);
    Mem.Write(Colors, SizeOf(TRGBQuad) * (1 shl BIH.biBitCount));
    Bits := AllocMemo(BIH.biSizeImage);
    //try
    ZeroMemory(Bits, BIH.biSizeImage);
    FItem.FImageData.Seek( 0, spBegin );

    ReadGIFData(FItem.FImageData, BIH, FInterlaced,
      FItem.FBitsPerPixel, Bits, Corrupt);
    FTransMask.Free;
    FTransMask := nil;

    if Assigned( FOwner.FOnNeedMask ) then
      FOwner.FOnNeedMask( @Self, BIH, Bits );
    (*
    if FOwner.NeedMask then
    begin
       if FTransIndex >= 0 then
       begin
          FTransMask := NewBitmap( BIH.biWidth, BIH.biHeight );
          FTransMask.PixelFormat := pf1bit;

          FReallyTransparent :=
          FillMaskBitmap( FTransMask, BIH.biWidth, BIH.biHeight, Bits,
                          BIH.biBitCount,
                          ((BIH.biWidth * BIH.biBitCount + 31) div 32) * 4,
                          FTransIndex );
          {if not ReallyTransparent then
          begin
            FTransMask.Free;
            FTransMask := nil;
          end;}
       end;
    end;
    *)
    FCorrupted := FCorrupted or Corrupt;
    FOwner.FCorrupted := FOwner.FCorrupted or FCorrupted;
    Mem.Write(Bits^, BIH.biSizeImage);
    //finally
    FreeMemo(Bits);
    //end;
    Mem.Seek( 0, spBegin );
  end;

begin
  if FBitmap = nil then
  begin
    New_Bitmap;
    Mem := NewMemoryStream;
    SaveToBmpStream;

      //--SnapStream2File( Mem, GetStartDir + 'loaded_mem.bmp' );

    FBitmap.LoadFromStream( Mem );

      //--FBitmap.SaveToFile( GetStartDir + 'loaded.bmp' );

    {$IFDEF TOPF16BIT}
    FBitmap.PixelFormat := pf16bit; //&&& // ColorsToPixelFormat( 1 shl FItem.FBitsPerPixel );
    {$ELSE}
    FBitmap.PixelFormat := pf24bit;
    {$ENDIF}
    //FBitmap.FreeResources;
    Mem.Free;
  end;
  Result := FBitmap;
end;

function TGifFrame.GetColorCount: Integer;
begin
  Result := FItem.FColorMap.ColorCount;
  Assert( Result <> 0, 'Unknown color count in gif frame bitmap' );
  {if (Result = 0) and Assigned( FBitmap ) and (FBitmap.Palette <> 0) then
     GetObject( FBitmap.Palette, Sizeof( Integer ), @Result );}
end;

function TGifFrame.GetComment: PStrList;
begin
  Result := FindComment( True );
end;

function TGifFrame.GetHeight: Integer;
begin
  if Assigned(FBitmap) or Assigned(FItem.FImageData) then
    Result := Bitmap.Height
  else Result := 0;
end;

function TGifFrame.GetReallyTransparent: Boolean;
begin
   GetBitmap;
   Result := fReallyTransparent;
end;

function TGifFrame.GetWidth: Integer;
begin
  if Assigned(FBitmap) or Assigned(FItem.FImageData) then
    Result := Bitmap.Width
  else Result := 0;
end;

function TGifFrame.LoadFromStream(Stream: PStream): Boolean;
  function DoLoadStream : Boolean;
  var
    ImageDesc: TImageDescriptor;
    I, TransIndex: Integer;
  begin
    //Result := False;
    fTransIndex := -1;
    //
    FItem.FImageData.Free;
    FItem.FImageData := NewMemoryStream;
    //
    ReadImageStream(Stream, FItem.FImageData, ImageDesc, FInterlaced,
      FLocalColors, FCorrupted, FItem.FBitsPerPixel, FItem.FColorMap);
    FItem.FImageData.Position := 0;
    with ImageDesc do
    begin
      FTopLeft := MakePoint(ImageLeftPos, ImageTopPos);
      FItem.FSize := MakePoint(ImageWidth, ImageHeight);
      FItem.FPackedFields := PackedFields;
    end;
    if not FLocalColors then
       FItem.FColorMap := FOwner.FGifData.DColorMap;
    FDelay := 0;
    if FExtensions <> nil then
    begin
      for I := 0 to FExtensions.Count - 1 do
        with PExtension(FExtensions.Items[I])^ do
          if FExtType = etGraphic then
          begin
            if (FExtRec.GCE.PackedFields and GCE_TRANSPARENT) <> 0 then
            begin
              TransIndex := FExtRec.GCE.TransparentColorIndex;
              if FItem.FColorMap.ColorCount > TransIndex then
              begin
                fTransIndex := TransIndex;
                FTranspColor := ItemToRGB(FItem.FColorMap.Colors[TransIndex]);
                FTransparent := True;
              end;
            end
               else
               FTranspColor := clNone;
            FDelay := Max(FExtRec.GCE.DelayTime * 10, FDelay);
            FDisposalMethod := TDisposeMethod((FExtRec.GCE.PackedFields and
              GCE_DISPOSAL_METHOD) shr 2);
          end;
    end;
    Result := True;
  end;

begin
  Result := DoLoadStream;
  if not Result then
  begin
    FItem.FImageData.Free;
    FItem.FImageData := nil;
  end;
end;

procedure TGifFrame.New_Bitmap;
begin
  FBitmap.Free;
  FBitmap := NewBitmap( 0, 0 );
end;

procedure TGifFrame.SetComment(const Value: PStrList);
begin
  GetComment.Assign( Value );
end;

procedure TGifFrame.SetDelay(const Value: Word);
begin
  if FDelay = Value then Exit;
  //FOwner.Changing;
  FDelay := Value;
  if FDelay > 0 then
     FOwner.FVersion := gv89a;
  //FOwner.Changed;
end;

procedure TGifFrame.SetDisposalMethod(const Value: TDisposeMethod);
begin
  if FDisposalMethod = Value then Exit;
  //FOwner.Changing;
  FDisposalMethod := Value;
  if Value <> dmUndefined then
     FOwner.FVersion := gv89a;
  //FOwner.Changed;
end;

procedure TGifFrame.SetTopLeft(const Value: TPoint);
begin
  if (FTopLeft.X = Value.X) and (FTopLeft.Y = Value.Y) then Exit;
  //FOwner.Changing;
  FTopLeft := Value;
  FOwner.FGifWidth := Max(FOwner.FGifWidth,
      FItem.FSize.X + FTopLeft.X);
  FOwner.FGifHeight := Max(FOwner.FGifHeight,
      FItem.FSize.Y + FTopLeft.Y);
  //FOwner.Changed;
end;

procedure TGifFrame.SetTranspColor(const Value: TColor);
begin
  if FTranspColor = Value then Exit;
  //FOwner.Changing;
  if Value <> clNone then
     FOwner.FVersion := gv89a;
  FTranspColor := Value;
  //FOwner.Changed;
end;

procedure TGifFrame.StretchDraw(DC: HDC; Rect: TRect);
var OldMode: Integer;
    OldOrgX: TPoint;
begin
  GetBitmap; // need to create Mask if it is needed
  if Mask = nil then
  begin
    OldMode := SetStretchBltMode( DC, HALFTONE );
    SetBrushOrgEx( DC, 0, 0, @ OldOrgX );
    Bitmap.StretchDraw( DC, Rect );
    SetBrushOrgEx( DC, OldOrgX.x, OldOrgX.y, nil );
    SetStretchBltMode( DC, OldMode );
  end
  else
  begin
    StretchBitmapMask( DC, Rect, Bitmap, Mask );
  end;
end;

{ TGifDecoder }

procedure TGifDecoder.Clear;
begin
  FGifData.DComment.Free;
  FGifData.DComment := nil;
  ClearItems;
  FGifWidth := 0;
  FGifHeight := 0;
  FCorrupted := FALSE;
end;

procedure TGifDecoder.ClearItems;
var I: Integer;
begin
  if FItems <> nil then
  begin
    for I := 0 to FItems.Count-1 do
      PObj(FItems.Items[I]).Free;
    FItems.Clear;
  end;
end;

function NewGifDecoder: PGifDecoder;
begin
  new( Result, Create );
  Result.NewImage;
  Result.FTransparent := True;
  Result.FBkColor := clNone;
end;

destructor TGifDecoder.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TGifDecoder.FreeResources;
var I : Integer;
begin
  if FItems <> nil then
  for I := 0 to FItems.Count - 1 do
    PGifFrame( FItems.Items[ I ] ).FreeResources;
end;

function TGifDecoder.GetBitmap: PBitmap;
begin
  if (FItems.Count > 0) then begin
    if (FFrameIndex >= 0) and (FFrameIndex < FItems.Count) then
      Result := PGIFFrame(FItems.Items[FFrameIndex]).Bitmap
    else Result := PGIFFrame(FItems.Items[0]).Bitmap
  end
     else
     Result := nil;
end;

function TGifDecoder.GetComment: PStrList;
begin
  Result := FGifData.DComment;
end;

function TGifDecoder.GetFrame: Integer;
begin
  Result := FFrameIndex;
end;

function TGifDecoder.GetFrameCount: Integer;
begin
  Result := 0;
  if FItems <> nil then
     Result := FItems.Count;
end;

function TGifDecoder.GetFrames(Idx: Integer): PGifFrame;
begin
  Result := nil;
  if Idx >= 0 then
    Result := PGifFrame( FItems.Items[ Idx ] );
end;

function TGifDecoder.GetHeight: Integer;
begin
  Result := FGifHeight;
end;

function TGifDecoder.GetMask: PBitmap;
begin
  if (FItems.Count > 0) then begin
    if (FFrameIndex >= 0) and (FFrameIndex < FItems.Count) then
      Result := PGIFFrame(FItems.Items[FFrameIndex]).Mask
    else Result := PGIFFrame(FItems.Items[0]).Mask
  end
     else
     Result := nil;
end;

function TGifDecoder.GetWidth: Integer;
begin
  Result := FGifWidth;
end;

function TGifDecoder.LoadFromFile(const FileName: String): Boolean;
var Strm : PStream;
begin
  Strm := NewReadFileStream( FileName {, ofOpenRead or ofOpenExisting or ofShareDenyWrite} );
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TGifDecoder.LoadFromResourceID(Instance: HInst;
  ResID: Integer): Boolean;
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Resource2Stream( Strm, Instance, PChar( ResID ), RT_RCDATA );
  Strm.Position := 0;
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TGifDecoder.LoadFromResourceName(Inst: HInst;
  RsrcName: PChar): Boolean;
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Resource2Stream( Strm, Inst, PChar( RsrcName ), RT_RCDATA );
  Strm.Position := 0;
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TGifDecoder.LoadFromStream(Stream: PStream): Boolean;
var
  SeparatorChar: Char;
  NewItem: PGIFFrame;
  Extensions: PList;
  ScreenDesc: TScreenDescriptor;
  Data: PStream;

  function ReadSignature(Stream: PStream) : Boolean;
  var
    I: TGIFVersion;
    S: array[ 0..3 ] of Char;
  begin
    Result := False;
    FVersion := gvUnknown;
    S[ 3 ] := #0;
    Stream.Read(S[0], 3);
    //if CompareText(GIFSignature, S) <> 0 then
    if GIFSignature <> S then
       //GifError( 'Incorrect GIF Version' );
       Exit;
    Stream.Read(S[0], 3);
    for I := Low(TGIFVersion) to High(TGIFVersion) do
      //if CompareText(S, StrPas(GIFVersionStr[I])) = 0 then
      if CompareMem( @S[ 0 ], PChar( GifVersionStr[ I ] ), 4 ) then
      begin
        FVersion := I;
        Break;
      end;
    if FVersion = gvUnknown then
       //GifError('Unknown GIF Version');
       Exit;
    Result := True;
  end;

  procedure ReadScreenDescriptor(Stream: PStream);
  begin
    Stream.Read(ScreenDesc, SizeOf(ScreenDesc));
    FGifWidth := ScreenDesc.ScreenWidth;
    FGifHeight := ScreenDesc.ScreenHeight;
    FGifData.DAspectRatio := ScreenDesc.AspectRatio;
    FGifData.DBitsPerPixel := 1 + (ScreenDesc.PackedFields and
      LSD_COLOR_TABLE_SIZE);
    FGifData.DColorResBits := 1 + (ScreenDesc.PackedFields and
      LSD_COLOR_RESOLUTION) shr 4;
  end;

  procedure ReadGlobalColorMap(Stream: PStream);
  begin
    if (ScreenDesc.PackedFields and LSD_GLOBAL_COLOR_TABLE) <> 0 then
    begin
      FGifData.DColorMap.ColorCount := 1 shl FGifData.DBitsPerPixel;
      Stream.Read( FGifData.DColorMap.Colors[0],
                   FGifData.DColorMap.ColorCount * SizeOf(TGIFColorItem) );
      {if FGifData.DColorMap.ColorCount > ScreenDesc.BackgroundColorIndex then
      begin
        fBackIndex := ScreenDesc.BackgroundColorIndex;
        FBkColor := ItemToRGB( FGifData.DColorMap.Colors[ fBackIndex ] );
      end;}
      fBackIndex := ScreenDesc.BackgroundColorIndex;
      if fBackIndex >= FGifData.DColorMap.ColorCount then
        fBackIndex := 0;
      FBkColor := ItemToRGB( FGifData.DColorMap.Colors[fBackIndex] );
    end;
  end;

  function ReadDataBlock(Stream: PStream): PStrList;
  var
    BlockSize: Byte;
    S: string;
  begin
    Result := NewStrlist;
    //try
      repeat
        Stream.Read(BlockSize, SizeOf(Byte));
        if BlockSize <> 0 then begin
          SetLength(S, BlockSize);
          Stream.Read(S[1], BlockSize);
          Result.Add(S);
        end;
      until (BlockSize = 0) or (Stream.Position >= Stream.Size);
    //except
    {
      Result.Free;
      raise;
    }
    //end;
  end;

  function ReadExtension(Stream: PStream): PExtension;
  var
    ExtensionLabel: Byte;
  begin
    //Result := TExtension.Create;
    new( Result, Create );
    //try
      Stream.Read(ExtensionLabel, SizeOf(Byte));
      if ExtensionLabel = ExtLabels[etGraphic] then
      begin
        { graphic control extension }
        Result.FExtType := etGraphic;
        Stream.Read(Result.FExtRec.GCE, SizeOf(TGraphicControlExtension));
      end
         else
      if ExtensionLabel = ExtLabels[etComment] then
      begin
        { comment extension }
        Result.FExtType := etComment;
        Result.FList := ReadDataBlock(Stream);
      end
         else
      if ExtensionLabel = ExtLabels[etPlainText] then
      begin
        { plain text extension }
        Result.FExtType := etPlainText;
        Stream.Read(Result.FExtRec.PTE, SizeOf(TPlainTextExtension));
        Result.FList := ReadDataBlock(Stream);
      end
         else
      if ExtensionLabel = ExtLabels[etApplication] then
      begin
        { application extension }
        Result.FExtType := etApplication;
        Stream.Read(Result.FExtRec.APPE, SizeOf(TAppExtension));
        Result.FList := ReadDataBlock(Stream);
      end
         else
      begin
        //GifError('Unrecognized GIF Extention ' + IntToStr( ExtensionLabel ) );
        //...
        Result.Free;
        Result := nil;
      end;
    //except
    {
      Result.Free;
      raise;
    }
    //end;
  end;

  function ReadExtensionBlock(Stream: PStream; var SeparatorChar: Char): PList;
  var
    NewExt: PExtension;
  begin
    Result := nil;
    //try
      while SeparatorChar = CHR_EXT_INTRODUCER do
      begin
        NewExt := ReadExtension(Stream);
        if (NewExt.FExtType = etPlainText) then
        begin
          { plain text data blocks are not supported,
            clear all previous readed extensions }
          FreeExtensions(Result);
          Result := nil;
        end;
        if (NewExt.FExtType in [etPlainText, etApplication]) then
        begin
          { check for loop extension }
          if NewExt.IsLoopExtension then
          begin
            FLooping := True;
            FRepeatCount := Min( PWord( @NewExt.FList.Items[0][2] )^,
              //MakeWord(Byte(NewExt.FList.Items[0][2]),
              //Byte(NewExt.FList.Items[0][3])),
              MAX_LOOP_COUNT);
          end;
          { not supported yet, must be ignored }
          NewExt.Free;
        end
           else
        begin
          if Result = nil then
             Result := NewList;
          Result.Add(NewExt);
        end;
        if Stream.Size > Stream.Position then
          Stream.Read(SeparatorChar, SizeOf(Byte))
        else
          SeparatorChar := CHR_TRAILER;
      end;
      if (Result <> nil) and (Result.Count = 0) then
      begin
        Result.Free;
        Result := nil;
      end;
    //except
    {
      if Result <> nil then Result.Free;
      raise;
    }
    //end;
  end;

  function DoLoadStream : Boolean;
  var
    Size : Integer;
    I, OldPos: Integer;
    Ext: PExtension;
    Idx : Integer;
  begin
    Size := Stream.Size - Stream.Position;
    Result := False;
    //Changing;
    NewImage;
    Idx := 0;
    Data := NewMemoryStream;
    //try
      Data.Size := Size;
      Stream.Read(Data.Memory^, Size);
      if Size > 0 then
      begin
        Data.Seek( 0, spBegin );
        if not ReadSignature(Data) then Exit;
        ReadScreenDescriptor(Data);
        ReadGlobalColorMap(Data);
        Data.Read(SeparatorChar, SizeOf(Byte));
        OldPos := -1;
        while not (SeparatorChar in [CHR_TRAILER, #0]) and not
          (Data.Position >= Data.Size) and (DWORD(OldPos) <> Data.Position) do
        begin
          OldPos := Data.Position;
          Extensions := ReadExtensionBlock(Data, SeparatorChar);
          if SeparatorChar = CHR_IMAGE_SEPARATOR then
          begin
            //try
              NewItem := NewGIFFrame(@Self);
              NewItem.fFrameIndex := Idx;
              Inc( Idx );
              //try
                if FGifData.DColorMap.ColorCount > 0 then
                  NewItem.FItem.FBitsPerPixel :=
                    ColorsToBits(FGifData.DColorMap.ColorCount);
                NewItem.FExtensions := Extensions;
                Extensions := nil;
                if not NewItem.LoadFromStream(Data) then
                begin
                  NewItem.Free;
                  Exit;
                end;
                FItems.Add(NewItem);
              //except
              {
                NewItem.Free;
                raise;
              }
              //end;
              if not (Data.Position >= Data.Size) then
              begin
                Data.Read(SeparatorChar, SizeOf(Byte));
                while (SeparatorChar = #0) and (Data.Position < Data.Size) do
                  Data.Read(SeparatorChar, SizeOf(Byte));
              end
                 else
                 SeparatorChar := CHR_TRAILER;
              if not (SeparatorChar in [CHR_EXT_INTRODUCER,
                CHR_IMAGE_SEPARATOR, CHR_TRAILER]) then
              begin
                SeparatorChar := #0;
                {GifError(LoadStr(SGIFDecodeError));}
                //Corrupted := TRUE;
                //break;
              end;
            //except
            {
              FreeExtensions(Extensions);
              raise;
            }
            //end
          end
             else
          if (FGifData.DComment.Count = 0) and (Extensions <> nil) then
          begin
            //try
              { trailig extensions }
              for I := 0 to Extensions.Count - 1 do
              begin
                Ext := Extensions.Items[I];
                if (Ext <> nil) and (Ext.FExtType = etComment) then
                begin
                  if FGifData.DComment.Count > 0 then
                    FGifData.DComment.Add(#13#10#13#10);
                  FGifData.DComment.AddStrings(Ext.FList);
                end;
              end;
            //finally
              FreeExtensions(Extensions);
            //end;
          end
             else
          if not (SeparatorChar in [CHR_TRAILER, #0]) then
          begin
            //GifError('GIF Read Error');
            //...
            FreeExtensions(Extensions);
            FCorrupted := TRUE;
          end;
        end;
      end;
    //finally
      //Data.Free;
    //end;
    if Count > 0 then
    begin
      FFrameIndex := 0;
      //if ForceDecode then
      //try
        GetBitmap; { force bitmap creation }
        FTransparent := Frames[ 0 ].FTransparent;
      //except
      {
        Frames[0].Free;
        FItems.Delete(0);
        raise;
      }
      //end;
    end;
    //Changed;
    //if not Corrupted then
      Result := True;
  end;

begin
  Clear;
  Result := DoLoadStream;
  Data.Free;
  if not Result then Clear;
end;

procedure TGifDecoder.NewImage;
begin
  FGifData.DComment.Free;
  FGifData.DComment := NewStrList;

  if FItems = nil then FItems := NewList;
  ClearItems;
  FFrameIndex := -1;
  FBkColor := clNone;
  FRepeatCount := 1;
  FLooping := False;
  FVersion := gvUnknown;
end;

procedure TGifDecoder.SetFrame(Value: Integer);
begin
  //if FFrameIndex = Value then Exit;
  //Changing;
  FFrameIndex := Value;
  if FFrameIndex >= FItems.Count then
    FFrameIndex := 0;
  //Changed;
end;

procedure TGifDecoder.SetNeedMask(const Value: Boolean);
begin
  FNeedMask := Value;
  if Value then
    FOnNeedMask := ProvideTruthMask
  else
    FOnNeedMask := nil;
end;

{ TGif }

function NewGifNoMask: PGif;
begin
  new( Result, Create );
  Result.FGifImage := NewGifDecoder;
end;

function NewGif: PGif;
begin
  Result := NewGifNoMask;
  Result.FGifImage.NeedMask := TRUE;
end;

procedure TGif.Clear;
begin
  FGifImage.Clear;
  FCurIndex := -1;
  FCurFrame.Free;   FCurFrame := nil;
  FCurMask.Free;    FCurMask := nil;
  FPrevFrame.Free;  FPrevFrame := nil;
  FPrevMask.Free;   FPrevMask := nil;
  Changed;
end;

destructor TGif.Destroy;
begin
  //OnChanging := nil;
  //OnChanged := nil;
  Clear;
  FGifImage.Free;
  inherited;
end;

procedure TGif.Draw(DC: HDC; X, Y: Integer);
begin
  if Count = 0 then Exit;
  PrepareFrame;
  FCurFrame.Draw( DC, X, Y );
end;

procedure TGif.DrawTransp(DC: HDC; X, Y: Integer);
begin
  if Count = 0 then Exit;
  DrawTransparent( DC, X, Y, Frames[ Frame ].TranspColor );
end;

procedure TGif.DrawTransparent(DC: HDC; X, Y: Integer;
  TranspColor: TColor);
begin
  if Count = 0 then Exit;
  PrepareFrame;
  //-----------------------------------------------------------------------
  {if FCurMask <> nil then
    FCurMask.SaveToFile( GetStartDir + 'TGif.DrawTransparent.FCurMask.bmp' )
  else
    DeleteFile( PChar( GetStartDir + 'TGif.DrawTransparent.FCurMask.bmp' ) );
  if FCurFrame <> nil then
    FCurFrame.SaveToFile( GetStartDir + 'TGif.DrawTransparent.FCurFrame.bmp' )
  else
    DeleteFile( PChar( GetStartDir + 'TGif.DrawTransparent.FCurFrame.bmp' ) );}
  //-------------------------------------------------------------------------
  if FCurMask = nil then
    FCurFrame.Draw( DC, X, Y )
  else
    DrawBitmapMask( DC, X, Y, FCurFrame, FCurMask );
end;

procedure TGif.FreeResources;
begin
  FGifImage.FreeResources;
  if FCurFrame <> nil then
    FCurFrame.Dormant;
  if FCurMask <> nil then
    FCurMask.Dormant;
  if FPrevFrame <> nil then
    FPrevFrame.Dormant;
  if FPrevMask <> nil then
    FPrevMask.Dormant;
end;

function TGif.GetHeight: Integer;
begin
  Result := FGifImage.Height;
end;

function TGif.GetWidth: Integer;
begin
  Result := FGifImage.Width;
end;

procedure TGif.StretchDrawTransp(DC: HDC; const Dest: TRect);
begin
  if Count = 0 then Exit;
  StretchDrawTransparent( DC, Dest, BkColor );
end;

procedure TGif.StretchDraw(DC: HDC; const Dest: TRect);
var OldMode: Integer;
    OldOrgX: TPoint;
begin
  if Count = 0 then Exit;
  PrepareFrame;
  OldMode := SetStretchBltMode( DC, HALFTONE );
  SetBrushOrgEx( DC, 0, 0, @ OldOrgX );
  FCurFrame.StretchDraw( DC, Dest );
  SetBrushOrgEx( DC, OldOrgX.x, OldOrgX.y, nil );
  SetStretchBltMode( DC, OldMode );
end;

procedure TGif.StretchDrawTransparent(DC: HDC; const Dest: TRect;
  TranspColor: TColor);
begin
  if Count = 0 then Exit;
  PrepareFrame;
  if FCurMask = nil then
    FCurFrame.StretchDraw( DC, Dest )
  else
    StretchBitmapMask( DC, Dest, FCurFrame, FCurMask );
end;

procedure TGif.PrepareFrame;
var DM : TDisposeMethod;
    I : Integer;
  procedure DrawCurFrameMask;
  var F: PGifFrame;
  begin
    F := Frames[ FCurIndex ];
    F.GetBitmap;
    //if F.ReallyTransparent then
    if F.Mask <> nil then
    begin
      BitBlt( FCurMask.Canvas.Handle,
              F.Origin.x,
              F.Origin.y,
              F.Origin.X + F.Width,
              F.Origin.Y + F.Height,
              F.Mask.Canvas.Handle, 0, 0, SRCAND );
      {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}
    end
      else
    begin
      //^^^FCurMask.Canvas.Brush.Color := clBlack;
      FCurMask.BkColor := clBlack;
      FCurMask.Canvas.FillRect( MakeRect( F.Origin.x, F.Origin.y,
                                F.Origin.x + F.Width, F.Origin.y + F.Height ) );
    end;
  end;
  procedure Prepare0;
  var Frame0: PGifFrame;
  begin
     FCurIndex := 0;
     Frame0 := Frames[ 0 ];
     FCurFrame.PixelFormat := Frame0.Bitmap.PixelFormat;
     //^^^FCurFrame.Canvas.Brush.Color := BkColor;
     FCurFrame.BkColor := BkColor;
     FCurFrame.Canvas.FillRect( MakeRect( 0, 0, Width, Height ) );
     if FCurMask <> nil then
     begin
        //^^^FCurMask.Canvas.Brush.Color := clWhite;
        FCurMask.BkColor := clWhite;
        FCurMask.Canvas.FillRect( MakeRect( 0, 0, Width, Height ) );
     end;
     Frame0.Draw( FCurFrame.Canvas.Handle, Frame0.Origin.x, Frame0.Origin.y );

       //FCurFrame.SaveToFile( GetStartDir + '0_Frame.bmp' );

     if FCurMask <> nil then
     begin

        DrawCurFrameMask;

        //FCurMask.SaveToFile( GetStartDir + '0_Mask.bmp' );
     end;
  end;
var F: PGifFrame;
begin
  if Count = 0 then Exit;
  if FCurFrame = nil then
  begin
     FCurFrame := NewBitmap( Width, Height );
     {$IFDEF TOPF16BIT}
     FCurFrame.PixelFormat := pf16bit; //&&&
     {$ELSE}
     FCurFrame.PixelFormat := pf24bit;
     {$ENDIF}

     if Transparent then
     begin
       FCurMask := NewBitmap( Width, Height );
       FCurMask.PixelFormat := pf1bit;
     end;

     FCurIndex := -1;
  end;
  if FCurIndex >= 0 then
  if Frames[ FCurIndex ].ReallyTransparent then
  if FCurMask = nil then
  begin
     FCurMask := NewBitmap( Width, Height );
     FCurMask.PixelFormat := pf1bit;
     //^^^FCurMask.Canvas.Brush.Color := clWhite;
     FCurMask.BkColor := clBlack;  //---%%%---
     FCurMask.Canvas.FillRect( MakeRect( 0, 0, Width, Height ) );
  end;
  if (FCurIndex < 0) or (FCurIndex > Frame) then
     Prepare0;
  while FCurIndex < Frame do
  begin
    DM := Frames[ FCurIndex ].DisposalMethod;
    if DM = dmRestorePrevious then
      if FCurIndex = 0 then
        DM := dmRestoreBackground;
    if DM = dmUndefined then
       for I := FCurIndex - 1 downto 0 do
           if Frames[ I ].DisposalMethod <> DM then
           begin
             DM := Frames[ I ].DisposalMethod;
             break;
           end;
    if (DM = dmUndefined) and Frames[ FCurIndex + 1 ].Transparent then
       DM := dmLeave;
    case DM of
    dmRestoreBackground:
      begin

        //^^^FCurFrame.Canvas.Brush.Color := BkColor;
        FCurFrame.BkColor := BkColor;

        F := Frames[ FCurIndex ];
        FCurFrame.Canvas.FillRect( MakeRect( F.Origin.x, F.Origin.y, F.Origin.x + F.Width,
                                             F.Origin.y + F.Height ) );
        if FCurMask <> nil then
        begin
          //^^^FCurMask.Canvas.Brush.Color := clWhite;
          FCurMask.BkColor := clWhite;

          if FCurIndex < Count then
          begin
            Frames[ FCurIndex + 1 ].GetBitmap;
            if Frames[ FCurIndex + 1 ].Mask = nil then
              //^^^FCurMask.Canvas.Brush.Color := clBlack;
              FCurMask.BkColor := clBlack;
          end;
          FCurMask.Canvas.FillRect( MakeRect( F.Origin.x, F.Origin.y,
                                    F.Origin.x + F.Width, F.Origin.y + F.Height ) );
        end;

      end;
    dmRestorePrevious:
      begin
        FCurFrame.Assign( FPrevFrame );
        if FCurMask <> nil then
          FCurMask.Assign( FPrevMask );
        if FCurMask <> nil then
        if FCurMask.Empty then
        begin
          FCurMask.Free;
          FCurMask := nil;
        end;
      end;
    dmUndefined:
      begin
        F := Frames[ FCurIndex + 1 ];
        //^^^FCurFrame.Canvas.Brush.Color := BkColor;
        FCurFrame.BkColor := BkColor;
        FCurFrame.Canvas.FillRect( MakeRect( F.Origin.x, F.Origin.y,
                         F.Origin.x + F.Width, F.Origin.y + F.Height ) );
        if FCurMask <> nil then
        begin
          //^^^FCurMask.Canvas.Brush.Color := clBlack;
          FCurMask.BkColor := clBlack;
          FCurMask.Canvas.FillRect( MakeRect( F.Origin.x, F.Origin.y,
                                    F.Origin.x + F.Width, F.Origin.y + F.Height ) );
        end;
      end;
    end;
    Inc( FCurIndex );
    F := Frames[ FCurIndex ];
    if F.DisposalMethod = dmRestorePrevious then
    begin
      if FPrevFrame = nil then
         FPrevFrame := NewBitmap( 0, 0 );
      FPrevFrame.Assign( FCurFrame );
      if FCurMask <> nil then
      begin
        if FPrevMask = nil then
          FPrevMask := NewBitmap( 0, 0 );
        FPrevMask.Assign( FCurMask );
      end;
    end;
    F.Draw( FCurFrame.Canvas.Handle, F.Origin.x, F.Origin.y );

      //F.Bitmap.SaveToFile( GetStartDir + Int2Str( FCurIndex ) + 'img.bmp' );
      //FCurFrame.SaveToFile( GetStartDir + Int2Str( FCurIndex ) + '=fr.bmp' );

    if FCurMask <> nil then
    begin
       //if F.Mask <> nil then F.Mask.SaveToFile( GetStartDir + Int2Str( FCurIndex ) + 'Msk.bmp' );
       DrawCurFrameMask;
       //---------------------
       //FCurMask.SaveToFile( GetStartDir + Int2Str( FCurIndex ) + '=MS.bmp' );
       //---------------------
    end;
  end;
end;

function TGif.GetBkColor: TColor;
begin
  Result := FGifImage.BkColor;
end;

procedure TGif.SetBkColor(const Value: TColor);
begin
  FGifImage.BkColor := Value;
  Changed;
end;

function TGif.GetFrames(Idx: Integer): PGifFrame;
begin
  Result := FGifImage.Frames[ Idx ];
end;

function TGif.GetTransparent: Boolean;
begin
  Result := FGifImage.Transparent;
end;

function TGif.GetFrame: Integer;
begin
  Result := FGifImage.FFrameIndex;
end;

procedure TGif.SetFrame(Value: Integer);
begin
  if Value >= Count then
    Value := 0;
  FGifImage.Frame := Value;
end;

function TGif.LoadFromStream(Stream: PStream): Boolean;
begin
  Clear;
  Result := FGifImage.LoadFromStream( Stream );
  Changed;
end;

function TGif.LoadFromFile(const FileName: String): Boolean;
begin
  Clear;
  Result := FGifImage.LoadFromFile( FileName );
  Changed;
end;

function TGif.GetFrameCount: Integer;
begin
  Result := FGifImage.Count;
end;

function TGif.GetDelays(Idx: Integer): Integer;
begin
  Result := 0;
  if Idx < Count then
    Result := Frames[ Idx ].Delay;
end;

procedure TGif.SetDelays(Idx, Value: Integer);
begin
  Frames[ Idx ].Delay := Value;
  Changed;
end;

procedure TGif.SetWidth(Value: Integer);
begin
  // nothing!
end;

procedure TGif.SetHeight(Value: Integer);
begin
  // nothing !
end;

{
procedure TGif.SetForceBkTransparent(const Value: Boolean);
begin
  if FForceBkTransparent = Value then Exit;
  FForceBkTransparent := Value;
  FCurIndex := -1;
end;
}

function TGif.GetCorrupted: Boolean;
begin
  Result := FGifImage.Corrupted;
end;

procedure TGif.Changed;
begin
  if Assigned( FOnChanged ) then
    FOnChanged( @Self );
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+  TGifShow - a control to show (animated) GIF on a form.                    +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

type
  PGifShowData = ^TGifShowData;
  TGifShowData = object( TObj )
    gsdGifShow: PGifShow;
    gsdAutosize: Boolean;
    gsdStretch: Boolean;
    gsdAnimate: Boolean;
    gsdLoop: Boolean;
    //gsdTimer: PTimer;
    gsdTimerSet: Integer;
    gsdGif: PGif;
    gsdOnEndLoop: TOnEvent;
    destructor Destroy; virtual;
  end;

function NewGifShow( AParent: PControl ): PGifShow;
var D: PGifShowData;
begin
  Result := PGifShow( NewPaintBox( AParent ) );
  new( D, Create );
  D.gsdGifShow := Result;
  D.gsdAutosize := TRUE;
  D.gsdStretch := TRUE;
  D.gsdAnimate := TRUE;
  D.gsdLoop := TRUE;
  D.gsdGif := NewGif;
  D.gsdGif.FOnChanged := Result.GifChanged;
  Result.CustomObj := D;
  Result.SetOnPaint( Result.PaintFrame );
end;

function TGif.LoadFromResourceID(Instance: HInst; ResID: Integer): Boolean;
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Resource2Stream( Strm, Instance, PChar( ResID ), RT_RCDATA );
  Strm.Position := 0;
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function TGif.LoadFromResourceName(Inst: HInst; RsrcName: PChar): Boolean;
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Resource2Stream( Strm, Inst, PChar( RsrcName ), RT_RCDATA );
  Strm.Position := 0;
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

{ TGifShow }

function TGifShow.GetAnimate: Boolean;
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  Result := D.gsdAnimate;
end;

function TGifShow.GetAutosize: Boolean;
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  Result := D.gsdAutosize;
end;

function TGifShow.GetDummy: Boolean;
begin
  Result := FALSE;
end;

function TGifShow.GetGif: PGif;
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  Result := D.gsdGif;
end;

function TGifShow.GetLoop: Boolean;
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  Result := D.gsdLoop;
end;

function TGifShow.GetOnEndLoop: TOnEvent;
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  Result := D.gsdOnEndLoop;
end;

function TGifShow.GetStretch: Boolean;
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  Result := D.gsdStretch;
end;

procedure GoNextFrame( Wnd: HWnd; Msg: DWORD; GifShow: PGifShow; dwTime: DWORD );
stdcall;
begin
  GifShow.NextFrame( nil );
end;

procedure TGifShow.GifChanged(Sender: PObj);
var D: PGifShowData;
    NewDelay: Integer;
begin
  D := Pointer( CustomObj );
  if (D.gsdGif.Count > 1) and D.gsdAnimate then
  begin
    NewDelay := Max( 1, D.gsdGif.Frames[ 0 ].Delay );
    if D.gsdTimerSet = 0 then
    begin
      D.gsdTimerSet := NewDelay;
      SetTimer( GetWindowHandle, DWORD( @ Self ), D.gsdTimerSet, @ GoNextFrame );
    end;
  end
    else
      if D.gsdTimerSet <> 0 then
      begin
        KillTimer( Handle, DWORD( @ Self ) );
        D.gsdTimerSet := 0;
      end;
  if D.gsdAutosize then
    SetAutosize( TRUE );
  Invalidate;
end;

function TGifShow.LoadFromFile(const FileName: String): Boolean;
begin
  Result := Gif.LoadFromFile( FileName );
end;

function TGifShow.LoadFromResourceID(Instance: HInst;
  ResID: Integer): Boolean;
begin
  Result := Gif.LoadFromResourceID( Instance, ResID );
end;

function TGifShow.LoadFromResourceName(Inst: HInst;
  RsrcName: PChar): Boolean;
begin
  Result := Gif.LoadFromResourceName( Inst, RsrcName );
end;

function TGifShow.LoadFromStream(Stream: PStream): Boolean;
begin
  Result := Gif.LoadFromStream( Stream );
end;

procedure TGifShow.NextFrame(Sender: PObj);
var D: PGifShowData;
    NewDelay: Integer;
begin
  D := Pointer( CustomObj );
  if D.gsdGif.Frame >= D.gsdGif.Count-1 then
  begin
    if D.gsdLoop then
    begin
      D.gsdGif.Frame := 0;
      //D.gsdTimer.Interval := D.gsdGif.Frames[ 0 ].Delay;
    end
      else
    begin
      D.gsdAnimate := FALSE;
    end;
    if Assigned( D.gsdOnEndLoop ) then
      D.gsdOnEndLoop( @ Self );
  end
    else
    D.gsdGif.Frame := D.gsdGif.Frame + 1;
  Invalidate;
  NewDelay := Max( 1, D.gsdGif.Frames[ D.gsdGif.Frame ].Delay );
  if D.gsdTimerSet <> NewDelay then
  begin
    if D.gsdTimerSet <> 0 then
      KillTimer( Handle, DWORD( @Self ) );
    D.gsdTimerSet := NewDelay;
    SetTimer( Handle, DWORD( @ Self ), NewDelay, @ GoNextFrame );
  end;
end;

procedure TGifShow.PaintFrame(Sender: PControl; DC: HDC);
var D: PGifShowData;
    Br: HBrush;
begin
  D := Pointer( CustomObj );
  if (D.gsdGif.Width > 0) and (D.gsdGif.Height > 0) then
  begin
    if Stretch and ((D.gsdGif.Width <> Width) or (D.gsdGif.Height <> Height)) then
      if Transparent then
        D.gsdGif.StretchDrawTransp( DC, ClientRect )
      else
        D.gsdGif.StretchDraw( DC, ClientRect )
    else
      if Transparent then
        D.gsdGif.DrawTransp( DC, 0, 0 )
      else
        D.gsdGif.Draw( DC, 0, 0 );
  end
    else
  begin
    if not Transparent then
    begin
      Br := CreateSolidBrush( Color2RGB( Color ) );
      Windows.FillRect( DC, ClientRect, Br );
      DeleteObject( Br );
    end;
  end;
end;

procedure TGifShow.SetAnimate(const Value: Boolean);
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  D.gsdAnimate := Value;
  GifChanged( nil );
end;

procedure TGifShow.SetAutosize(const Value: Boolean);
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  D.gsdAutosize := Value;
  if Value and (D.gsdGif.Width > 0) and (D.gsdGif.Height > 0) then
  begin
    Width := D.gsdGif.Width;
    Height := D.gsdGif.Height;
  end;
end;

procedure TGifShow.SetLoop(const Value: Boolean);
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  if D.gsdLoop = Value then Exit;
  D.gsdLoop := Value;
  GifChanged( nil );
end;

procedure TGifShow.SetOnEndLoop(const Value: TOnEvent);
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  D.gsdOnEndLoop := Value;
end;

procedure TGifShow.SetStretch(const Value: Boolean);
var D: PGifShowData;
begin
  D := Pointer( CustomObj );
  D.gsdStretch := Value;
  Invalidate;
end;

{ TGifShowData }

destructor TGifShowData.Destroy;
begin
  //gsdTimer.Free;
  if gsdTimerSet <> 0 then
    KillTimer( gsdGifShow.Handle, DWORD( gsdGifShow ) );
  gsdGif.Free;
  inherited;
end;

end.
