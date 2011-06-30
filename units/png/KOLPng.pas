{Portable Network Graphics for Key Objects Library adaptation
 by Kladov Vladimir 29-Sep-2002 ( bonanzas@xcl.cjb.net, http://xcl.cjb.net )
 from source of TPngImage
 by Gustavo Huffenbacher Daud ( gubadaud@terra.com.br, pngdelphi.sourceforge.net ) }

unit KOLPng;
{* PNG - Portable Network Graphics format support for KOL. }

interface

{Triggers avaliable}

{.$DEFINE CheckCRC}               //Enables CRC checking
{.$DEFINE PartialTransparentDraw} //Draws partial transparent images

{$RANGECHECKS OFF} {$J+}

uses
 Windows, KOL, KOLZlib;

const
  {Avaliable PNG filters for mode 0}
  FILTER_NONE    = 0;
  FILTER_SUB     = 1;
  FILTER_UP      = 2;
  FILTER_AVERAGE = 3;
  FILTER_PAETH   = 4;

  {Avaliable color modes for PNG}
  COLOR_GRAYSCALE      = 0;
  COLOR_RGB            = 2;
  COLOR_PALETTE        = 3;
  COLOR_GRAYSCALEALPHA = 4;
  COLOR_RGBALPHA       = 6;


{Error types}
type
  TPngError = ( ErrOK, ErrInvalidCRC, ErrInvalidIHDR, ErrSizeExceeds, ErrUnknownCompression,
            ErrUnknownInterlace, ErrInvalidPalette, ErrMissingMultipleIDAT,
            ErrZLibError, ErrInvalidHeader, ErrUnexpectedEnd, ErrIHDRNotFirst,
            ErrUnknownCriticalChunk, ErrNoImageData );

type
  {Same as TBitmapInfo but with allocated space for}
  {palette entries}
  TMAXBITMAPINFO = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: packed array[0..255] of TRGBQuad;
  end;

  {Transparency mode for pngs}
  TPNGTransparencyMode = (ptmNone, ptmBit, ptmPartial);
  {Access to a rgb pixel}
  pRGBPixel = ^TRGBPixel;
  TRGBPixel = packed record
    B, G, R: Byte;
  end;

  {Pointer to an array of bytes type}
  TByteArray = Array[Word] of Byte;
  pByteArray = ^TByteArray;

  {Forward}
  PPngObject = ^TPngObject;
  //TPNGObject = object;
  pPointerArray = ^TPointerArray;
  TPointerArray = Array[Word] of Pointer;

  {Chunk name object}
  TChunkName = Array[0..3] of Char;

  {Forward declaration}
  PChunk = ^TChunk;
  PChunkIEND = PChunk;

  {Forward}
  PChunkIHDR = ^TChunkIHDR;

  {Interlace method}
  TInterlaceMethod = (imNone, imAdam7);
  {Compression level type}
  TCompressionLevel = 0..9;
  {Filters type}
  TFilter = (pfNone, pfSub, pfUp, pfAverage, pfPaeth);
  TFilters = set of TFilter;

  {Png implementation object}
  TPngObject = object( TObj )
  protected
    FError: TPngError;
    FErrorOnInvalidCRC: Boolean;
    {Gamma table values}
    GammaTable, InverseGamma: Array[Byte] of Byte;
    procedure InitializeGamma;
  protected
    {Filters to test to encode}
    fFilters: TFilters;
    {Compression level for ZLIB}
    fCompressionLevel: TCompressionLevel;
    {Maximum size for IDAT chunks}
    fMaxIdatSize: DWORD;
    {Returns if image is interlaced}
    fInterlaceMethod: TInterlaceMethod;
    {Chunks object}
    fChunkList: PList;
    {Clear all chunks in the list}
    procedure ClearChunks;
    {Returns if header is present}
    function HeaderPresent: Boolean;
    {Returns linesize and byte offset for pixels}
    procedure GetPixelInfo(var LineSize, Offset: DWORD);
    procedure SetMaxIdatSize(const Value: DWORD);
    function GetAlphaScanline(const LineIndex: Integer): pByteArray;
    function GetScanline(const LineIndex: Integer): Pointer;
    function GetTransparencyMode: TPNGTransparencyMode;
    function GetTransparentColor: TColor;
    procedure SetTransparentColor(const Value: TColor);
  protected
    {Returns image width and height}
    function GetWidth: Integer;
    function GetHeight: Integer;
    {Assigns from another TPNGObject}
    procedure AssignPNG(Source: PPNGObject);
    {Returns if the image is empty}
    function GetEmpty: Boolean;
    {Used with property Header}
    function GetHeader: PChunkIHDR;
    {Draws using partial transparency}
    procedure DrawPartialTrans(DC: HDC; Rect: TRect);
  public
    {Generates alpha information}
    procedure CreateAlpha;
    {Removes the image transparency}
    procedure RemoveTransparency;
    {Transparent color}
    property TransparentColor: TColor read GetTransparentColor write
      SetTransparentColor;
    {Add text chunk, TChunkTEXT}
    procedure AddtEXt(const Keyword, Text: String);
    {Saves to clipboard}
    function CopyToClipboard: Boolean;
    function PasteFromClipboard: Boolean;
    {Returns a scanline from png}
    property Scanline[const Index: Integer]: Pointer read GetScanline;
    property AlphaScanline[const Index: Integer]: pByteArray read GetAlphaScanline;
    {Returns pointer to the header}
    property Header: PChunkIHDR read GetHeader;
    {Returns the transparency mode used by this png}
    property TransparencyMode: TPNGTransparencyMode read GetTransparencyMode;
    {Assigns from a windows bitmap handle}
    procedure AssignHandle(Handle: HBitmap; Transparent: Boolean;
      TranColor: ColorRef);
    {Draws the image into a canvas}
    procedure Draw(DC: HDC; X, Y: Integer);
    procedure DrawTransparent( DC: HDC; X, Y: Integer; TranColor: TColor );
    procedure StretchDraw( DC: HDC; const Rect: TRect );
    procedure StretchDrawTransparent( DC: HDC; const Rect: TRect; TranColor: TColor );
    {Width and height properties}
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    {Returns if the image is interlaced}
    property InterlaceMethod: TInterlaceMethod read fInterlaceMethod
      write fInterlaceMethod;
    {Filters to test to encode}
    property Filters: TFilters read fFilters write fFilters;
    {Maximum size for IDAT chunks, default and minimum is 65536}
    property MaxIdatSize: DWORD read fMaxIdatSize write SetMaxIdatSize;
    {Property to return if the image is empty or not}
    property Empty: Boolean read GetEmpty;
    {Compression level}
    property CompressionLevel: TCompressionLevel read fCompressionLevel
      write fCompressionLevel;
    {Access to the chunk list}
    property Chunks: PList read fChunkList;
    {Object being created and destroyed}
    destructor Destroy; virtual;
    function LoadFromFile(const Filename: String): Boolean;
    procedure SaveToFile(const Filename: String);
    function LoadFromStream(Stream: PStream): Boolean;
    procedure SaveToStream(Stream: PStream);
    {Loading the image from resources}
    procedure LoadFromResourceName(Instance: HInst; const Name: String);
    procedure LoadFromResourceID(Instance: HInst; ResID: Integer);
    {}
    function ChunkByName( const Name: TChunkName ): Pointer;
    function CreateChunkByName( const Name: TChunkName ): Pointer;
    Property Error: TPngError read FError;
    Property ErrorOnInvalidCRC: Boolean read FErrorOnInvalidCRC write FErrorOnInvalidCRC;
  end;

  {Base chunk object}
  TChunk = object(TObj)
  protected
    {Contains data}
    fData: Pointer;
    fDataSize: DWORD;
    {Stores owner}
    fOwner: PPngObject;
    {Returns pointer to the TChunkIHDR}
    function GetHeader: PChunkIHDR;
    {Used with property index}
    function GetIndex: Integer;
  protected
    fName: String;
    {Should return chunk name}
  public
    {Returns index from list}
    property Index: Integer read GetIndex;
    {Returns pointer to the TChunkIHDR}
    property Header: PChunkIHDR read GetHeader;
    {Resize the data}
    procedure ResizeData(const NewSize: DWORD);
    {Returns data and size}
    property Data: Pointer read fData;
    property DataSize: DWORD read fDataSize;
    {Returns owner}
    property Owner: PPngObject read fOwner;
    {Being destroyed/created}
    constructor Create(AOwner: PPngObject);
    destructor Destroy; virtual;
    {Returns chunk class/name}
    property Name: String read fName;
    {Loads the chunk from a stream}
    function LoadFromStream(Stream: PStream; const ChunkName: TChunkName;
      Size: Integer): Boolean;
    {Saves the chunk to a stream}
    function SaveToStream(Stream: PStream): Boolean;
  end;

  {IHDR data}
  pIHDRData = ^TIHDRData;
  TIHDRData = packed record
    Width, Height: Integer;
    BitDepth,
    ColorType,
    CompressionMethod,
    FilterMethod,
    InterlaceMethod: Byte;
  end;

  {Information header chunk}
  TChunkIHDR = object(TChunk)
  protected
    {Current image}
    ImageHandle: HBitmap;
    ImageDC: HDC;

    {Output windows bitmap}
    HasPalette: Boolean;
    BitmapInfo: TMaxBitmapInfo;
    BytesPerRow: Integer;
    {Stores the image bytes}
    ImageData: pointer;
    ImageAlpha: Pointer;

    {Contains all the ihdr data}
    IHDRData: TIHDRData;
    {Resizes the image data to fill the color type, bit depth, }
    {width and height parameters}
    procedure PrepareImageData;
    {Release allocated ImageData memory}
    procedure FreeImageData;
  public
    {Properties}
    property Width: Integer read IHDRData.Width write IHDRData.Width;
    property Height: Integer read IHDRData.Height write IHDRData.Height;
    property BitDepth: Byte read IHDRData.BitDepth write IHDRData.BitDepth;
    property ColorType: Byte read IHDRData.ColorType write IHDRData.ColorType;
    property CompressionMethod: Byte read IHDRData.CompressionMethod
      write IHDRData.CompressionMethod;
    property FilterMethod: Byte read IHDRData.FilterMethod
      write IHDRData.FilterMethod;
    property InterlaceMethod: Byte read IHDRData.InterlaceMethod
      write IHDRData.InterlaceMethod;
    {Destructor/constructor}
    constructor Create(AOwner: PPngObject);
    destructor Destroy; virtual;
  end;

  {Gamma chunk}
  PChunkGAMA = ^TChunkGAMA;
  TChunkgAMA = object(TChunk)
  protected
    {Returns/sets the value for the gamma chunk}
    function GetValue: DWORD;
    procedure SetValue(const Value: DWORD);
  public
    {Returns/sets gamma value}
    property Gamma: DWORD read GetValue write SetValue;
    {Being created}
    constructor Create(AOwner: PPngObject);
  end;

  {ZLIB Decompression extra information}
  TZStreamRec2 = packed record
    {From ZLIB}
    ZLIB: TZStreamRec;
    {Additional info}
    Data: Pointer;
    fStream: PStream;
  end;

  {Palette chunk}
  PChunkPLTE = ^TChunkPLTE;
  TChunkPLTE = object(TChunk)
  protected
    {Number of items in the palette}
    fCount: Integer;
    {Contains the palette handle}
    function GetPaletteItem(Idx: Byte): TRGBQuad;
  public
    {Returns the color for each item in the palette}
    property Item[Index: Byte]: TRGBQuad read GetPaletteItem;
    {Returns the number of items in the palette}
    property Count: Integer read fCount;
  end;

  {Transparency information}
  PChunktRNS = ^TChunktRNS;
  TChunktRNS = object(TChunk)
  protected
    fBitTransparency: Boolean;
    function GetTransparentColor: ColorRef;
    {Returns the transparent color}
    procedure SetTransparentColor(const Value: ColorRef);
  public
    {Palette values for transparency}
    PaletteValues: Array[Byte] of Byte;
    {Returns if it uses bit transparency}
    property BitTransparency: Boolean read fBitTransparency;
    {Returns the transparent color}
    property TransparentColor: ColorRef read GetTransparentColor write
      SetTransparentColor;
  end;

  {Actual image information}
  PChunkIDAT = ^TChunkIDAT;
  TChunkIDAT = object(TChunk)
  protected
    {Holds another pointer to the TChunkIHDR}
    //Header: PChunkIHDR;
    {Stores temporary image width and height}
    ImageWidth, ImageHeight: Integer;
    {Size in bytes of each line and offset}
    Row_Bytes, Offset : DWORD;
    {Contains data for the lines}
    Encode_Buffer: Array[0..5] of pByteArray;
    Row_Buffer: Array[Boolean] of pByteArray;
    {Variable to invert the Row_Buffer used}
    RowUsed: Boolean;
    {Ending position for the current IDAT chunk}
    EndPos: Integer;
    {Filter the current line}
    procedure FilterRow;
    {Filter to encode and returns the best filter}
    function FilterToEncode: Byte;
    {Reads ZLIB compressed data}
    function IDATZlibRead(var ZLIBStream: TZStreamRec2; Buffer: Pointer;
      Count: Integer; var AEndPos: Integer; var crcfile: DWORD): Integer;
    {Compress and writes IDAT data}
    procedure IDATZlibWrite(var ZLIBStream: TZStreamRec2; Buffer: Pointer;
      const Length: DWORD);
    procedure FinishIDATZlib(var ZLIBStream: TZStreamRec2);
    {Prepares the palette}
    procedure PreparePalette;
  protected
    {Decode interlaced image}
    procedure DecodeInterlacedAdam7(Stream: PStream;
      var ZLIBStream: TZStreamRec2; const Size: Integer; var crcfile: DWORD);
    {Decode non interlaced imaged}
    procedure DecodeNonInterlaced(Stream: PStream;
      var ZLIBStream: TZStreamRec2; const Size: Integer;
      var crcfile: DWORD);
  protected
    {Encode non interlaced images}
    procedure EncodeNonInterlaced(Stream: PStream;
      var ZLIBStream: TZStreamRec2);
    {Encode interlaced images}
    procedure EncodeInterlacedAdam7(Stream: PStream;
      var ZLIBStream: TZStreamRec2);
  protected
    {Memory copy methods to decode}
    procedure CopyNonInterlacedRGB8(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedRGB16(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedPalette148(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedPalette2(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedGray2(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedGrayscale16(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedRGBAlpha8(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedRGBAlpha16(Src, Dest, Trans: pChar);
    procedure CopyNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: PChar);
    procedure CopyNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: PChar);
    procedure CopyInterlacedRGB8(const Pass: Byte; Src, Dest, Trans: pChar);
    procedure CopyInterlacedRGB16(const Pass: Byte; Src, Dest, Trans: pChar);
    procedure CopyInterlacedPalette148(const Pass: Byte; Src,Dest,Trans: pChar);
    procedure CopyInterlacedPalette2(const Pass: Byte; Src, Dest, Trans: pChar);
    procedure CopyInterlacedGray2(const Pass: Byte; Src, Dest,  Trans: pChar);
    procedure CopyInterlacedGrayscale16(const Pass: Byte;Src,Dest,Trans: pChar);
    procedure CopyInterlacedRGBAlpha8(const Pass: Byte; Src,Dest,Trans: pChar);
    procedure CopyInterlacedRGBAlpha16(const Pass: Byte; Src,Dest,Trans: pChar);
    procedure CopyInterlacedGrayscaleAlpha8(const Pass: Byte;
      Src, Dest, Trans: pChar);
    procedure CopyInterlacedGrayscaleAlpha16(const Pass: Byte;
      Src, Dest, Trans: pChar);
  protected
    {Memory copy methods to encode}
    procedure EncodeNonInterlacedRGB8(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedRGB16(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedGrayscale16(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedPalette148(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedRGBAlpha8(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedRGBAlpha16(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: pChar);
    procedure EncodeNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: pChar);
    procedure EncodeInterlacedRGB8(const Pass: Byte; Src, Dest, Trans: pChar);
    procedure EncodeInterlacedRGB16(const Pass: Byte; Src, Dest, Trans: pChar);
    procedure EncodeInterlacedPalette148(const Pass:Byte; Src,Dest,Trans:pChar);
    procedure EncodeInterlacedGrayscale16(const Pass:Byte;Src,Dest,Trans:pChar);
    procedure EncodeInterlacedRGBAlpha8(const Pass: Byte;Src,Dest,Trans: pChar);
    procedure EncodeInterlacedRGBAlpha16(const Pass:Byte; Src,Dest,Trans:pChar);
    procedure EncodeInterlacedGrayscaleAlpha8(const Pass: Byte; Src, Dest,
      Trans: pChar);
    procedure EncodeInterlacedGrayscaleAlpha16(const Pass: Byte; Src, Dest,
      Trans: pChar);
  end;

  {Image last modification chunk}
  PChunkTIME = ^TChunktIME;
  TChunktIME = object(TChunk)
  protected
    {Holds the variables}
    fYear: Word;
    fMonth, fDay, fHour, fMinute, fSecond: Byte;
  public
    {Returns/sets variables}
    property Year: Word read fYear write fYear;
    property Month: Byte read fMonth write fMonth;
    property Day: Byte read fDay write fDay;
    property Hour: Byte read fHour write fHour;
    property Minute: Byte read fMinute write fMinute;
    property Second: Byte read fSecond write fSecond;
  end;

  {Textual data}
  PChunkTEXT = ^TChunkTEXT;
  TChunktEXt = object(TChunk)
  protected
    fKeyword, fText: String;
  public
    destructor Destroy; virtual;
    {Keyword and text}
    property Keyword: String read fKeyword write fKeyword;
    property Text: String read fText write fText;
  end;

{Registers a new chunk class}
//procedure RegisterChunk(ChunkClass: TChunkClass);

{Calculates crc}
function update_crc(crc: DWORD; buf: pByteArray; len: Integer): DWORD;
{Invert bytes using assembly}
function ByteSwap(const a: integer): integer;

function NewPngObject: PPngObject;

implementation

var
  //ChunkClasses: TPngPointerList;
  {Table of CRCs of all 8-bit messages}
  crc_table: Array[0..255] of DWORD;
  {Flag: has the table been computed? Initially false}
  crc_table_computed: Boolean;

type
  TChunkType = ( ctCommon, ctIHDR, ctIEND, ctIDAT, ctPLTE,
             ctgAMA, ctTRNS, cttEXt, cttIME );
  TLoadProc = function( Chunk: Pointer; Strm: PStream; const ChunkName: TChunkName;
            Size: Integer): Boolean;
  TSaveProc = function( Chunk: Pointer; Strm: PStream ): Boolean;
  TLoadArray = array[ TChunkType ] of TLoadProc;
  TSaveArray = array[ TChunkType ] of TSaveProc;

function IHDR_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function IDAT_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function PLTE_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function gAMA_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function TRNS_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function tEXt_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function tIME_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function IHDR_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function IDAT_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function PLTE_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function TRNS_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function tEXt_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function tIME_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;

function ChunkTypeByName( const Name: String ): TChunkType;
const ChunkNames: array[ TChunkType ] of String = ( '', 'IHDR', 'IEND', 'IDAT',
      'PLTE', 'gAMA', 'TRNS', 'tEXt', 'tIME' );
var I: TChunkType;
begin
  for I := High( TChunkType ) downto Succ( Low( TChunkType ) ) do
    if Name = ChunkNames[ I ] then
    begin
      Result := I; Exit;
    end;
  Result := ctCommon;
end;

{Draw transparent image using transparent color}
procedure DrawTransparentBitmap(dc: HDC; srcBits: Pointer;
  var srcHeader: TBitmapInfoHeader;
  srcBitmapInfo: pBitmapInfo; Rect: TRect; cTransparentColor: COLORREF);
var
  cColor:   COLORREF;
  bmAndBack, bmAndObject, bmAndMem: HBITMAP;
  bmBackOld, bmObjectOld, bmMemOld: HBITMAP;
  hdcMem, hdcBack, hdcObject, hdcTemp: HDC;
  ptSize, orgSize: TPOINT;
  OldBitmap, DrawBitmap: HBITMAP;
begin
  hdcTemp := CreateCompatibleDC(dc);
  // Select the bitmap
  DrawBitmap := CreateDIBitmap(dc, srcHeader, CBM_INIT, srcBits, srcBitmapInfo^,
    DIB_RGB_COLORS);
  OldBitmap := SelectObject(hdcTemp, DrawBitmap);

  // Sizes
  OrgSize.x := abs(srcHeader.biWidth);
  OrgSize.y := abs(srcHeader.biHeight);
  ptSize.x := Rect.Right - Rect.Left;        // Get width of bitmap
  ptSize.y := Rect.Bottom - Rect.Top;        // Get height of bitmap

  // Create some DCs to hold temporary data.
  hdcBack  := CreateCompatibleDC(dc);
  hdcObject := CreateCompatibleDC(dc);
  hdcMem   := CreateCompatibleDC(dc);

  // Create a bitmap for each DC. DCs are required for a number of
  // GDI functions.

  // Monochrome DCs
  bmAndBack  := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

  bmAndMem   := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);

  // Each DC must select a bitmap object to store pixel data.
  bmBackOld  := SelectObject(hdcBack, bmAndBack);
  bmObjectOld := SelectObject(hdcObject, bmAndObject);
  bmMemOld   := SelectObject(hdcMem, bmAndMem);

  // Set the background color of the source DC to the color.
  // contained in the parts of the bitmap that should be transparent
  cColor := SetBkColor(hdcTemp, cTransparentColor);

  // Create the object mask for the bitmap by performing a BitBlt
  // from the source bitmap to a monochrome bitmap.
  StretchBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
    orgSize.x, orgSize.y, SRCCOPY);

  // Set the background color of the source DC back to the original
  // color.
  SetBkColor(hdcTemp, cColor);

  // Create the inverse of the object mask.
  BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
       NOTSRCCOPY);

  // Copy the background of the main DC to the destination.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc, Rect.Left, Rect.Top,
       SRCCOPY);

  // Mask out the places where the bitmap will be placed.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);

  // Mask out the transparent colored pixels on the bitmap.
//  BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);
  StretchBlt(hdcTemp, 0, 0, OrgSize.x, OrgSize.y, hdcBack, 0, 0,
    PtSize.x, PtSize.y, SRCAND);

  // XOR the bitmap with the background on the destination DC.
  StretchBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
    OrgSize.x, OrgSize.y, SRCPAINT);

  // Copy the destination to the screen.
  BitBlt(dc, Rect.Left, Rect.Top, ptSize.x, ptSize.y, hdcMem, 0, 0,
       SRCCOPY);

  // Delete the memory bitmaps.
  DeleteObject(SelectObject(hdcBack, bmBackOld));
  DeleteObject(SelectObject(hdcObject, bmObjectOld));
  DeleteObject(SelectObject(hdcMem, bmMemOld));
  DeleteObject(SelectObject(hdcTemp, OldBitmap));

  // Delete the memory DCs.
  DeleteDC(hdcMem);
  DeleteDC(hdcBack);
  DeleteDC(hdcObject);
  DeleteDC(hdcTemp);
end;

{Make the table for a fast CRC.}
procedure make_crc_table;
var
  c: DWORD;
  n, k: Integer;
begin

  {fill the crc table}
  for n := 0 to 255 do
  begin
    c := DWORD(n);
    for k := 0 to 7 do
    begin
      if Boolean(c and 1) then
        c := $edb88320 xor (c shr 1)
      else
        c := c shr 1;
    end;
    crc_table[n] := c;
  end;

  {The table has already being computated}
  crc_table_computed := true;
end;

{Update a running CRC with the bytes buf[0..len-1]--the CRC
 should be initialized to all 1's, and the transmitted value
 is the 1's complement of the final running CRC (see the
 crc() routine below)).}
function update_crc(crc: DWORD; buf: pByteArray; len: Integer): DWORD;
var
  c: DWORD;
  n: Integer;
begin
  c := crc;

  {Create the crc table in case it has not being computed yet}
  if not crc_table_computed then make_crc_table;

  {Update}
  for n := 0 to len - 1 do
    c := crc_table[(c XOR buf^[n]) and $FF] XOR (c shr 8);

  {Returns}
  Result := c;
end;

{Calculates the paeth predictor}
function PaethPredictor(a, b, c: Byte): Byte;
var
  pa, pb, pc: Integer;
begin
  { a = left, b = above, c = upper left }
  pa := abs(b - c);      { distances to a, b, c }
  pb := abs(a - c);
  pc := abs(a + b - c * 2);

  { return nearest of a, b, c, breaking ties in order a, b, c }
  if (pa <= pb) and (pa <= pc) then
    Result := a
  else
    if pb <= pc then
      Result := b
    else
      Result := c;
end;

{Invert bytes using assembly}
function ByteSwap(const a: integer): integer;
asm
  bswap eax
end;

{Calculates number of bytes for the number of pixels using the}
{color mode in the paramenter}
function BytesForPixels(const Pixels: Integer; const ColorType,
  BitDepth: Byte): Integer;
begin
  case ColorType of
    {Palette and grayscale contains a single value, for palette}
    {an value of size 2^bitdepth pointing to the palette index}
    {and grayscale the value from 0 to 2^bitdepth with color intesity}
    COLOR_GRAYSCALE, COLOR_PALETTE:
      Result := (Pixels * BitDepth + 7) div 8;
    {RGB contains 3 values R, G, B with size 2^bitdepth each}
    COLOR_RGB:
      Result := (Pixels * BitDepth * 3) div 8;
    {Contains one value followed by alpha value booth size 2^bitdepth}
    COLOR_GRAYSCALEALPHA:
      Result := (Pixels * BitDepth * 2) div 8;
    {Contains four values size 2^bitdepth, Red, Green, Blue and alpha}
    COLOR_RGBALPHA:
      Result := (Pixels * BitDepth * 4) div 8;
    else
      Result := 0;
  end {case ColorType}
end;

{TChunk implementation}

{Resizes the data}
procedure TChunk.ResizeData(const NewSize: DWORD);
begin
  fDataSize := NewSize;
  ReallocMem(fData, NewSize + 1);
end;

{Returns index from list}
function TChunk.GetIndex: Integer;
begin
  Result := Owner.Chunks.IndexOf( @Self );
end;

{Returns pointer to the TChunkIHDR}
function TChunk.GetHeader: PChunkIHDR;
begin
  Result := Owner.Chunks.Items[0];
end;

{Chunk being created}
constructor TChunk.Create(AOwner: PPngObject);
begin
  {Ancestor create}
  inherited Create;

  {Initialize data holder}
  GetMem(fData, 1);
  fDataSize := 0;
  {Record owner}
  fOwner := AOwner;
end;

{Chunk being destroyed}
destructor TChunk.Destroy;
begin
  fName := '';
  {Free data holder}
  FreeMem(fData); //, fDataSize + 1);
  {Let ancestor destroy}
  inherited Destroy;
end;

{Returns the chunk name}
{Saves the chunk to the stream}
function TChunk.SaveToStream(Stream: PStream): Boolean;
var
  ChunkSize, ChunkCRC: DWORD;
  NameBuf: TChunkName;
begin
  {First, write the size for the following data in the chunk}
  ChunkSize := ByteSwap(DataSize);
  Stream.Write(ChunkSize, 4);
  {The chunk name}
  Move( Name[ 1 ], NameBuf[ 0 ], 4 );
  Stream.Write( NameBuf[ 0 ], 4 );
  {If there is data for the chunk, write it}
  if DataSize > 0 then Stream.Write(Data^, DataSize);
  {Calculates and write CRC}
  ChunkCRC := update_crc($ffffffff, @NameBuf[0], 4);
  ChunkCRC := Byteswap(update_crc(ChunkCRC, Data, DataSize) xor $ffffffff);
  Stream.Write(ChunkCRC, 4);

  {Returns that everything went ok}
  Result := TRUE;
end;


{Loads the chunk from a stream}
function TChunk.LoadFromStream(Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
var
  CheckCRC: DWORD;
  RightCRC: DWORD;
begin
  {Copies data from source}
  ResizeData(Size);
  if Size > 0 then Stream.Read(fData^, Size);
  {Reads CRC}
  Stream.Read(CheckCRC, 4);
  CheckCrc := ByteSwap(CheckCRC);

  {Check if crc readed is valid}
    RightCRC := update_crc($ffffffff, @ChunkName[0], 4);
    RightCRC := update_crc(RightCRC, fData, Size) xor $ffffffff;
    Result := RightCRC = CheckCrc;

  {Handle CRC error}
  if not Result and Owner.FErrorOnInvalidCRC then
  begin
    {In case it coult not load chunk}
    Owner.FError := ErrInvalidCRC;
    exit;
  end
    else
    Result := TRUE;

end;

{TChunktIME implementation}

{Chunk being loaded from a stream}
function tIME_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
begin
  {Let ancestor load the data}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);
  if not Result or (Size <> 7) then exit; {Size must be 7}

  {Reads data}
  with PChunkTIME( Chunk )^ do
  begin
    fYear := pWord(Data)^;
    fMonth := pByte(Longint(Data) + 2)^;
    fDay := pByte(Longint(Data) + 3)^;
    fHour := pByte(Longint(Data) + 4)^;
    fMinute := pByte(Longint(Data) + 5)^;
    fSecond := pByte(Longint(Data) + 6)^;
  end;
end;

{Saving the chunk to a stream}
function tIME_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunkTIME( Chunk )^ do
  begin
    {Update data}
    ResizeData(7);  {Make sure the size is 7}
    pWord(Data)^ := Year;
    pByte(Longint(Data) + 2)^ := Month;
    pByte(Longint(Data) + 3)^ := Day;
    pByte(Longint(Data) + 4)^ := Hour;
    pByte(Longint(Data) + 5)^ := Minute;
    pByte(Longint(Data) + 6)^ := Second;

    {Let inherited save data}
    Result := SaveToStream(Stream);
  end;
end;

{TChunktEXt implementation}

{Loading the chunk from a stream}
function tEXt_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
begin
  {Load data from stream and validate}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);
  if not Result or (Size < 3) then exit;
  {Get text}
  with PChunkTEXT( Chunk )^ do
  begin
    fKeyword := PChar(Data);
    SetLength(fText, Size - Length(fKeyword) - 1);
    CopyMemory(@fText[1], Ptr(Longint(Data) + Length(fKeyword) + 1),
      Length(fText));
  end;
end;

{Saving the chunk to a stream}
function tEXt_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunkTEXT( Chunk )^ do
  begin
    {Size is length from keyword, plus a null character to divide}
    {plus the length of the text}
    ResizeData(Length(fKeyword) + 1 + Length(fText));
    Fillchar(Data^, DataSize, #0);
    {Copy data}
    if Keyword <> '' then
      CopyMemory(Data, @fKeyword[1], Length(Keyword));
    if Text <> '' then
      CopyMemory(Ptr(Longint(Data) + Length(Keyword) + 1), @fText[1],
        Length(Text));
    {Let ancestor calculate crc and save}
    Result := SaveToStream(Stream);
  end;
end;


{TChunkIHDR implementation}

{Chunk being created}
constructor TChunkIHDR.Create(AOwner: PPngObject);
begin
  {Call inherited}
  inherited Create(AOwner);
  {Prepare pointers}
  ImageHandle := 0;
  ImageDC := 0;
end;

{Chunk being destroyed}
destructor TChunkIHDR.Destroy;
begin
  {Free memory}
  FreeImageData();

  {Calls TChunk destroy}
  inherited Destroy;
end;

{Release allocated image data}
procedure TChunkIHDR.FreeImageData;
begin
  {Free old image data}
  if ImageHandle <> 0  then DeleteObject(ImageHandle);
  if ImageDC     <> 0  then DeleteDC(ImageDC);
  if ImageAlpha <> nil then FreeMem(ImageAlpha);
  ImageHandle := 0; ImageDC := 0; ImageAlpha := nil; ImageData := nil;
end;

{Chunk being loaded from a stream}
function IHDR_Load(Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
begin
  {Let TChunk load it}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);
  if not Result then Exit;

  with PChunkIHDR( Chunk )^ do
  begin
    {Now check values}
    {Note: It's recommended by png specification to make sure that the size}
    {must be 13 bytes to be valid, but some images with 14 bytes were found}
    {which could be loaded by internet explorer and other tools}
    if (fDataSize < SIZEOF(TIHdrData)) then
    begin
      {Ihdr must always have at least 13 bytes}
      Result := False;
      Owner.FError := ErrInvalidIHDR;
      exit;
    end;

    {Everything ok, reads IHDR}
    IHDRData := pIHDRData(fData)^;
    IHDRData.Width := ByteSwap(IHDRData.Width);
    IHDRData.Height := ByteSwap(IHDRData.Height);

    {The width and height must not be larger than 65535 pixels}
    if (IHDRData.Width > High(Word)) or (IHDRData.Height > High(Word)) then
    begin
      Result := False;
      Owner.FError := ErrSizeExceeds;
      exit;
    end {if IHDRData.Width > High(Word)};
    {Compression method must be 0 (inflate/deflate)}
    if (IHDRData.CompressionMethod <> 0) then
    begin
      Result := False;
      Owner.FError := ErrUnknownCompression;
      exit;
    end;
    {Interlace must be either 0 (none) or 7 (adam7)}
    if (IHDRData.InterlaceMethod <> 0) and (IHDRData.InterlaceMethod <> 1) then
    begin
      Result := False;
      Owner.FError := ErrUnknownInterlace;
      exit;
    end;

    {Updates owner properties}
    Owner.InterlaceMethod := TInterlaceMethod(IHDRData.InterlaceMethod);

    {Prepares data to hold image}
    PrepareImageData();
  end;
end;

{Saving the IHDR chunk to a stream}
function IHDR_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunkIHDR( Chunk )^ do
  begin
    {Ignore 2 bits images}
    if BitDepth = 2 then BitDepth := 4;

    {It needs to do is update the data with the IHDR data}
    {structure containing the write values}
    ResizeData(SizeOf(TIHDRData));
    pIHDRData(fData)^ := IHDRData;
    {..byteswap 4 byte types}
    pIHDRData(fData)^.Width := ByteSwap(pIHDRData(fData)^.Width);
    pIHDRData(fData)^.Height := ByteSwap(pIHDRData(fData)^.Height);
    {..update interlace method}
    pIHDRData(fData)^.InterlaceMethod := Byte(Owner.InterlaceMethod);
    {..and then let the ancestor SaveToStream do the hard work}
    Result := SaveToStream(Stream);
  end;
end;

{Resizes the image data to fill the color type, bit depth, }
{width and height parameters}
procedure TChunkIHDR.PrepareImageData();

  {Set the bitmap info}
  procedure SetInfo(const Bitdepth: Integer; const Palette: Boolean);
  begin

    {Copy if the bitmap contain palette entries}
    HasPalette := Palette;
    {Initialize the structure with zeros}
    fillchar(BitmapInfo, sizeof(BitmapInfo), #0);
    {Fill the strucutre}
    with BitmapInfo.bmiHeader do
    begin
      biSize := sizeof(TBitmapInfoHeader);
      biHeight := Height;
      biWidth := Width;
      biPlanes := 1;
      biBitCount := BitDepth;
      biCompression := BI_RGB;
    end {with BitmapInfo.bmiHeader}
  end;
begin
  {Prepare bitmap info header}
  Fillchar(BitmapInfo, sizeof(TMaxBitmapInfo), #0);
  {Release old image data}
  FreeImageData();

  {Obtain number of bits for each pixel}
  case ColorType of
    COLOR_GRAYSCALE, COLOR_PALETTE, COLOR_GRAYSCALEALPHA:
      case BitDepth of
        {These are supported by windows}
        1, 4, 8: SetInfo(BitDepth, TRUE);
        {2 bits for each pixel is not supported by windows bitmap}
        2      : SetInfo(4, TRUE);
        {Also 16 bits (2 bytes) for each pixel is not supported}
        {and should be transormed into a 8 bit grayscale}
        16     : SetInfo(8, TRUE);
      end;
    {Only 1 byte (8 bits) is supported}
    COLOR_RGB, COLOR_RGBALPHA:  SetInfo(24, FALSE);
  end {case ColorType};
  {Number of bytes for each scanline}
  BytesPerRow := (((BitmapInfo.bmiHeader.biBitCount * Width) + 31)
    and not 31) div 8;

  {Build array for alpha information, if necessary}
  if (ColorType = COLOR_RGBALPHA) or (ColorType = COLOR_GRAYSCALEALPHA) then
  begin
    GetMem(ImageAlpha, Integer(Width) * Integer(Height));
    ZeroMemory(ImageAlpha, Integer(Width) * Integer(Height));
  end;

  {Creates the image to hold the data, CreateDIBSection does a better}
  {work in allocating necessary memory}
  ImageDC := CreateCompatibleDC(0);
  ImageHandle := CreateDIBSection(ImageDC, pBitmapInfo(@BitmapInfo)^,
    DIB_RGB_COLORS, ImageData, 0, 0);

  {Build array and allocate bytes for each row}
  zeromemory(ImageData, BytesPerRow * Integer(Height));
end;

{TChunktRNS implementation}

{Sets the transpararent color}
procedure TChunktRNS.SetTransparentColor(const Value: ColorRef);
var
  i: Byte;
  LookColor: TRGBQuad;
begin
  {Clears the palette values}
  Fillchar(PaletteValues, SizeOf(PaletteValues), #0);
  {Sets that it uses bit transparency}
  fBitTransparency := True;


  {Depends on the color type}
  with Header^ do
    case ColorType of
      COLOR_GRAYSCALE:
      begin
        Self.ResizeData(BitDepth div 8);
        PaletteValues[0] := GetRValue(Value);
      end;
      COLOR_RGB:
      begin
        Self.ResizeData((BitDepth div 8) * 3);
        PaletteValues[0] := GetRValue(Value);
        PaletteValues[1*(BitDepth div 8)] := GetGValue(Value);
        PaletteValues[2*(BitDepth div 8)] := GetBValue(Value);
      end;
      COLOR_PALETTE:
      begin
        {Creates a RGBQuad to search for the color}
        LookColor.rgbRed := GetRValue(Value);
        LookColor.rgbGreen := GetGValue(Value);
        LookColor.rgbBlue := GetBValue(Value);
        {Look in the table for the entry}
        for i := 0 to 255 do
          if CompareMem(@BitmapInfo.bmiColors[i], @LookColor, 3) then
            Break;
        {Fill the transparency table}
        Fillchar(PaletteValues, i, 255);
        Self.ResizeData(i + 1)

      end
    end {case / with};

end;

{Returns the transparent color for the image}
function TChunktRNS.GetTransparentColor: ColorRef;
var
  PaletteChunk: PChunkPLTE;
  i: Integer;
begin
  Result := 0; {Default: Unknown transparent color}

  {Depends on the color type}
  with Header^ do
    case ColorType of
      COLOR_GRAYSCALE: Result := RGB(PaletteValues[0], PaletteValues[0],
        PaletteValues[0]);
      COLOR_RGB:
        if BitDepth = 8 then
          Result := RGB(PaletteValues[0], PaletteValues[1], PaletteValues[2])
        else
          Result := RGB(PaletteValues[0], PaletteValues[2], PaletteValues[4]);
      COLOR_PALETTE:
      begin
        {Obtains the palette chunk}
        PaletteChunk := Pointer( Owner.ChunkByName('PLTE') );

        {Looks for an entry with 0 transparency meaning that it is the}
        {full transparent entry}
        for i := 0 to Self.DataSize - 1 do
          if PaletteValues[i] = 0 then
            with PaletteChunk.GetPaletteItem(i) do
            begin
              Result := RGB(rgbRed, rgbGreen, rgbBlue);
              break
            end
      end {COLOR_PALETTE}
    end {case Header.ColorType};
end;

{Saving the chunk to a stream}
function tRNS_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunktRNS( Chunk )^ do
  begin
    {Copy palette into data buffer}
    if DataSize <= 256 then
      CopyMemory(fData, @PaletteValues[0], DataSize);

    Result := SaveToStream(Stream);
  end;
end;

{Loads the chunk from a stream}
function tRNS_Load(Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
var
  i, Differ255: Integer;
begin
  {Let inherited load}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);

  if not Result then Exit;

  with PChunktRNS( Chunk )^ do
  begin
    {Make sure size is correct}
    if Size > 256 then
    begin
      Result := FALSE;
      Owner.FError := ErrInvalidPalette;
      exit;
    end;

    {The unset items should have value 255}
    Fillchar(PaletteValues[0], 256, 255);
    {Copy the other values}
    CopyMemory(@PaletteValues[0], fData, Size);

    {Create the mask if needed}
    case Header.ColorType of
      {Mask for grayscale and RGB}
      COLOR_RGB, COLOR_GRAYSCALE: fBitTransparency := True;
      COLOR_PALETTE:
      begin
        Differ255 := 0; {Count the entries with a value different from 255}
        {Tests if it uses bit transparency}
        for i := 0 to Size - 1 do
          if PaletteValues[i] <> 255 then inc(Differ255);

        {If it has one value different from 255 it is a bit transparency}
        fBitTransparency := (Differ255 = 1);
      end {COLOR_PALETTE}
    end {case Header.ColorType};
  end;
end;

{ZLIB support}

const
  ZLIBAllocate = High(Word);

{Initializes ZLIB for decompression}
function ZLIBInitInflate(Stream: PStream): TZStreamRec2;
begin
  {Fill record}
  Fillchar(Result, SIZEOF(TZStreamRec2), #0);

  {Set internal record information}
  with Result do
  begin
    GetMem(Data, ZLIBAllocate);
    fStream := Stream;
  end;

  {Init decompression}
  InflateInit_(Result.zlib, zlib_version, SIZEOF(TZStreamRec));
end;

{Initializes ZLIB for compression}
function ZLIBInitDeflate(Stream: PStream;
  Level: TCompressionlevel; Size: DWORD): TZStreamRec2;
begin
  {Fill record}
  Fillchar(Result, SIZEOF(TZStreamRec2), #0);

  {Set internal record information}
  with Result, ZLIB do
  begin
    GetMem(Data, Size);
    fStream := Stream;
    next_out := Data;
    avail_out := Size;
  end;

  {Inits compression}
  deflateInit_(Result.zlib, Level, zlib_version, sizeof(TZStreamRec));
end;

{Terminates ZLIB for compression}
procedure ZLIBTerminateDeflate(var ZLIBStream: TZStreamRec2);
begin
  {Terminates decompression}
  DeflateEnd(ZLIBStream.zlib);
  {Free internal record}
  FreeMem(ZLIBStream.Data); //, ZLIBAllocate);
end;

{Terminates ZLIB for decompression}
procedure ZLIBTerminateInflate(var ZLIBStream: TZStreamRec2);
begin
  {Terminates decompression}
  InflateEnd(ZLIBStream.zlib);
  {Free internal record}
  FreeMem(ZLIBStream.Data); //, ZLIBAllocate);
end;

{Prepares the image palette}
procedure TChunkIDAT.PreparePalette;
var
  Entries: Word;
  j      : Integer;
begin
  {In case the image uses grayscale, build a grayscale palette}
  with Header^ do
    if (ColorType = COLOR_GRAYSCALE) or (ColorType = COLOR_GRAYSCALEALPHA) then
    begin
      {Calculate total number of palette entries}
      Entries := (1 shl Byte(BitmapInfo.bmiHeader.biBitCount));

      FOR j := 0 TO Entries - 1 DO
        with BitmapInfo.bmiColors[j] do
        begin

          {Calculate each palette entry}
          rgbRed := fOwner.GammaTable[MulDiv(j, 255, Entries - 1)];
          rgbGreen := rgbRed;
          rgbBlue := rgbRed;
        end {with BitmapInfo.bmiColors[j]}
    end {if ColorType = COLOR_GRAYSCALE..., with Header}
end;

{Reads from ZLIB}
function TChunkIDAT.IDATZlibRead(var ZLIBStream: TZStreamRec2;
  Buffer: Pointer; Count: Integer; var AEndPos: Integer;
  var crcfile: DWORD): Integer;
var
  ProcResult : Integer;
  IDATHeader : Array[0..3] of char;
  IDATCRC    : DWORD;
begin
  {Uses internal record pointed by ZLIBStream to gather information}
  with ZLIBStream, ZLIBStream.zlib do
  begin
    {Set the buffer the zlib will read into}
    next_out := Buffer;
    avail_out := Count;

    {Decode until it reach the Count variable}
    while avail_out > 0 do
    begin
      {In case it needs more data and it's in the end of a IDAT chunk,}
      {it means that there are more IDAT chunks}
      if (fStream.Position = DWORD( AEndPos )) and (avail_out > 0) and
        (avail_in = 0) then
      begin
        {End this chunk by reading and testing the crc value}
        fStream.Read(IDATCRC, 4);

        if Owner.FErrorOnInvalidCRC then
          if crcfile xor $ffffffff <> DWORD(ByteSwap(IDATCRC)) then
          begin
            Result := -1;
            Owner.FError := ErrInvalidCRC;
            exit;
          end;

        {Start reading the next chunk}
        fStream.Read(AEndPos, 4);        {Reads next chunk size}
        fStream.Read(IDATHeader[0], 4); {Next chunk header}
        {It must be a IDAT chunk since image data is required and PNG}
        {specification says that multiple IDAT chunks must be consecutive}
        if IDATHeader <> 'IDAT' then
        begin
          Owner.FError := ErrMissingMultipleIDAT;
          result := -1;
          exit;
        end;

        {Calculate chunk name part of the crc}
        crcfile := update_crc($ffffffff, @IDATHeader[0], 4);

        AEndPos := fStream.Position + DWORD( ByteSwap(EndPos) );
      end;


      {In case it needs compressed data to read from}
      if avail_in = 0 then
      begin
        {In case it's trying to read more than it is avaliable}
        if fStream.Position + DWORD( ZLIBAllocate ) > DWORD( AEndPos ) then
          avail_in := fStream.Read(Data^, DWORD( AEndPos ) - fStream.Position)
         else
          avail_in := fStream.Read(Data^, ZLIBAllocate);
        {Update crc}
        crcfile := update_crc(crcfile, Data, avail_in);

        {In case there is no more compressed data to read from}
        if avail_in = 0 then
        begin
          Result := Count - avail_out;
          Exit;
        end;

        {Set next buffer to read and record current position}
        next_in := Data;

      end {if avail_in = 0};

      ProcResult := inflate(zlib, 0);

      {In case the result was not sucessfull}
      if (ProcResult < 0) then
      begin
        Result := -1;
        Owner.FError := ErrZLibError;
        exit;
      end;

    end {while avail_out > 0};

  end {with};

  {If everything gone ok, it returns the count bytes}
  Result := Count;
end;

{TChunkIDAT implementation}

const
  {Adam 7 interlacing values}
  RowStart: array[0..6] of Integer = (0, 0, 4, 0, 2, 0, 1);
  ColumnStart: array[0..6] of Integer = (0, 4, 0, 2, 0, 1, 0);
  RowIncrement: array[0..6] of Integer = (8, 8, 8, 4, 4, 2, 2);
  ColumnIncrement: array[0..6] of Integer = (8, 8, 4, 4, 2, 2, 1);

{Copy interlaced images with 1 byte for R, G, B}
procedure TChunkIDAT.CopyInterlacedRGB8(const Pass: Byte; Src,Dest,Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col * 3);
  repeat
    {Copy this row}
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);

    {Move to next column}
    inc(Src, 3);
    inc(Dest, ColumnIncrement[Pass] * 3 - 3);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy interlaced images with 2 bytes for R, G, B}
procedure TChunkIDAT.CopyInterlacedRGB16(const Pass: Byte; Src,Dest,Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col * 3);
  repeat
    {Copy this row}
    Byte(Dest^) := Owner.GammaTable[pByte(Longint(Src) + 4)^]; inc(Dest);
    Byte(Dest^) := Owner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := Owner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);

    {Move to next column}
    inc(Src, 6);
    inc(Dest, ColumnIncrement[Pass] * 3 - 3);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy ímages with palette using bit depths 1, 4 or 8}
procedure TChunkIDAT.CopyInterlacedPalette148(const Pass: Byte; Src,
  Dest, Trans: pChar);
const
  BitTable: Array[1..8] of Integer = ($1, $3, 0, $F, 0, 0, 0, $FF);
  StartBit: Array[1..8] of Integer = (7 , 0 , 0, 4,  0, 0, 0, 0);
var
  CurBit, Col: Integer;
  Dest2: PChar;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  repeat
    {Copy data}
    CurBit := StartBit[Header.BitDepth];
    repeat
      {Adjust pointer to pixel byte bounds}
      Dest2 := pChar(Longint(Dest) + (Header.BitDepth * Col) div 8);
      {Copy data}
      Byte(Dest2^) := Byte(Dest2^) or
        ( ((Byte(Src^) shr CurBit) and BitTable[Header.BitDepth])
          shl (StartBit[Header.BitDepth] - (Col * Header.BitDepth mod 8)));

      {Move to next column}
      inc(Col, ColumnIncrement[Pass]);
      {Will read next bits}
      dec(CurBit, Header.BitDepth);
    until CurBit < 0;

    {Move to next byte in source}
    inc(Src);
  until Col >= ImageWidth;
end;

{Copy ímages with palette using bit depth 2}
procedure TChunkIDAT.CopyInterlacedPalette2(const Pass: Byte; Src,
  Dest, Trans: pChar);
var
  CurBit, Col: Integer;
  Dest2: PChar;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  repeat
    {Copy data}
    CurBit := 6;
    repeat
      {Adjust pointer to pixel byte bounds}
      Dest2 := pChar(Longint(Dest) + Col div 2);
      {Copy data}
      Byte(Dest2^) := Byte(Dest2^) or (((Byte(Src^) shr CurBit) and $3)
         shl (4 - (4 * Col) mod 8));
      {Move to next column}
      inc(Col, ColumnIncrement[Pass]);
      {Will read next bits}
      dec(CurBit, 2);
    until CurBit < 0;

    {Move to next byte in source}
    inc(Src);
  until Col >= ImageWidth;
end;

{Copy ímages with grayscale using bit depth 2}
procedure TChunkIDAT.CopyInterlacedGray2(const Pass: Byte; Src,
  Dest, Trans: pChar);
var
  CurBit, Col: Integer;
  Dest2: PChar;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  repeat
    {Copy data}
    CurBit := 6;
    repeat
      {Adjust pointer to pixel byte bounds}
      Dest2 := pChar(Longint(Dest) + Col div 2);
      {Copy data}
      Byte(Dest2^) := Byte(Dest2^) or ((((Byte(Src^) shr CurBit) shl 2) and $F)
         shl (4 - (Col*4) mod 8));
      {Move to next column}
      inc(Col, ColumnIncrement[Pass]);
      {Will read next bits}
      dec(CurBit, 2);
    until CurBit < 0;

    {Move to next byte in source}
    inc(Src);
  until Col >= ImageWidth;
end;

{Copy ímages with palette using 2 bytes for each pixel}
procedure TChunkIDAT.CopyInterlacedGrayscale16(const Pass: Byte; Src,
  Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col);
  repeat
    {Copy this row}
    Dest^ := Src^; inc(Dest);

    {Move to next column}
    inc(Src, 2);
    inc(Dest, ColumnIncrement[Pass] - 1);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Decodes interlaced RGB alpha with 1 byte for each sample}
procedure TChunkIDAT.CopyInterlacedRGBAlpha8(const Pass: Byte;
  Src, Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col * 3);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this row and alpha value}
    Trans^ := pChar(Longint(Src) + 3)^;
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);

    {Move to next column}
    inc(Src, 4);
    inc(Dest, ColumnIncrement[Pass] * 3 - 3);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Decodes interlaced RGB alpha with 2 bytes for each sample}
procedure TChunkIDAT.CopyInterlacedRGBAlpha16(const Pass: Byte;
  Src, Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col * 3);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this row and alpha value}
    Trans^ := pChar(Longint(Src) + 6)^;
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 4)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);

    {Move to next column}
    inc(Src, 8);
    inc(Dest, ColumnIncrement[Pass] * 3 - 3);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Decodes 8 bit grayscale image followed by an alpha sample}
procedure TChunkIDAT.CopyInterlacedGrayscaleAlpha8(const Pass: Byte;
  Src, Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column, pointers to the data and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this grayscale value and alpha}
    Dest^ := Src^;  inc(Src);
    Trans^ := Src^; inc(Src);

    {Move to next column}
    inc(Dest, ColumnIncrement[Pass]);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Decodes 16 bit grayscale image followed by an alpha sample}
procedure TChunkIDAT.CopyInterlacedGrayscaleAlpha16(const Pass: Byte;
  Src, Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column, pointers to the data and enter in loop}
  Col := ColumnStart[Pass];
  Dest := pChar(Longint(Dest) + Col);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this grayscale value and alpha, transforming 16 bits into 8}
    Dest^ := Src^;  inc(Src, 2);
    Trans^ := Src^; inc(Src, 2);

    {Move to next column}
    inc(Dest, ColumnIncrement[Pass]);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Decodes an interlaced image}
procedure TChunkIDAT.DecodeInterlacedAdam7(Stream: PStream;
  var ZLIBStream: TZStreamRec2; const Size: Integer; var crcfile: DWORD);
var
  CurrentPass: Byte;
  PixelsThisRow: Integer;
  CurrentRow: Integer;
  Trans, Dta: pChar;
  CopyProc: procedure(const Pass: Byte; Src, Dest, Trans: pChar) of object;
begin

  CopyProc := nil; {Initialize}
  {Determine method to copy the image data}
  case Header.ColorType of
    {R, G, B values for each pixel}
    COLOR_RGB:
      case Header.BitDepth of
        8:  CopyProc := CopyInterlacedRGB8;
       16:  CopyProc := CopyInterlacedRGB16;
      end {case Header.BitDepth};
    {Palette}
    COLOR_PALETTE, COLOR_GRAYSCALE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := CopyInterlacedPalette148;
        2      : if Header.ColorType = COLOR_PALETTE then
                   CopyProc := CopyInterlacedPalette2
                 else
                   CopyProc := CopyInterlacedGray2;
        16     : CopyProc := CopyInterlacedGrayscale16;
      end;
    {RGB followed by alpha}
    COLOR_RGBALPHA:
      case Header.BitDepth of
        8:  CopyProc := CopyInterlacedRGBAlpha8;
       16:  CopyProc := CopyInterlacedRGBAlpha16;
      end;
    {Grayscale followed by alpha}
    COLOR_GRAYSCALEALPHA:
      case Header.BitDepth of
        8:  CopyProc := CopyInterlacedGrayscaleAlpha8;
       16:  CopyProc := CopyInterlacedGrayscaleAlpha16;
      end;
  end {case Header.ColorType};

  {Adam7 method has 7 passes to make the final image}
  FOR CurrentPass := 0 TO 6 DO
  begin
    {Calculates the number of pixels and bytes for this pass row}
    PixelsThisRow := (ImageWidth - ColumnStart[CurrentPass] +
      ColumnIncrement[CurrentPass] - 1) div ColumnIncrement[CurrentPass];
    Row_Bytes := BytesForPixels(PixelsThisRow, Header.ColorType,
      Header.BitDepth);
    {Clear buffer for this pass}
    ZeroMemory(Row_Buffer[not RowUsed], Row_Bytes);

    {Get current row index}
    CurrentRow := RowStart[CurrentPass];
    {Get a pointer to the current row image data}
    Dta := Ptr(Longint(Header.ImageData) + Header.BytesPerRow *
      (ImageHeight - 1 - CurrentRow));
    Trans := Ptr(Longint(Header.ImageAlpha) + ImageWidth * CurrentRow);

    if Row_Bytes > 0 then {There must have bytes for this interlaced pass}
      while CurrentRow < ImageHeight do
      begin
        {Reads this line and filter}
        if IDATZlibRead(ZLIBStream, @Row_Buffer[RowUsed][0], Row_Bytes + 1,
          EndPos, CRCFile) = 0 then break;

        FilterRow;
        {Copy image data}
        CopyProc(CurrentPass, @Row_Buffer[RowUsed][1], Dta, Trans);

        {Use the other RowBuffer item}
        RowUsed := not RowUsed;

        {Move to the next row}
        inc(CurrentRow, RowIncrement[CurrentPass]);
        {Move pointer to the next line}
        dec(Dta, RowIncrement[CurrentPass] * Header.BytesPerRow);
        inc(Trans, RowIncrement[CurrentPass] * ImageWidth);
      end {while CurrentRow < ImageHeight};

  end {FOR CurrentPass};

end;

{Copy 8 bits RGB image}
procedure TChunkIDAT.CopyNonInterlacedRGB8(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    {Copy pixel values}
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);
    {Move to next pixel}
    inc(Src, 3);
  end {for I}
end;

{Copy 16 bits RGB image}
procedure TChunkIDAT.CopyNonInterlacedRGB16(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    //Since windows does not supports (perhaps it does ?) 2 bytes for
    //each R, G, B value, the method will read only 1 byte from it
    {Copy pixel values}
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src) + 4)^]; inc(Dest);
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);
    {Move to next pixel}
    inc(Src, 6);
  end {for I}
end;

{Copy types using palettes (1, 4 or 8 bits per pixel)}
procedure TChunkIDAT.CopyNonInterlacedPalette148(Src, Dest, Trans: pChar);
begin
  {It's simple as copying the data}
  CopyMemory(Dest, Src, Row_Bytes);
end;

{Copy grayscale types using 2 bits for each pixel}
procedure TChunkIDAT.CopyNonInterlacedGray2(Src, Dest, Trans: pChar);
var
  i: Integer;
begin
  {2 bits is not supported, this routine will converted into 4 bits}
  FOR i := 1 TO Row_Bytes do
  begin
    Byte(Dest^) := ((Byte(Src^) shr 2) and $F) or ((Byte(Src^)) and $F0); inc(Dest);
    Byte(Dest^) := ((Byte(Src^) shl 2) and $F) or ((Byte(Src^) shl 4) and $F0); inc(Dest);
    inc(Src);
  end {FOR i}
end;

{Copy types using palette with 2 bits for each pixel}
procedure TChunkIDAT.CopyNonInterlacedPalette2(Src, Dest, Trans: pChar);
var
  i: Integer;
begin
  {2 bits is not supported, this routine will converted into 4 bits}
  FOR i := 1 TO Row_Bytes do
  begin
    Byte(Dest^) := ((Byte(Src^) shr 4) and $3) or ((Byte(Src^) shr 2) and $30); inc(Dest);
    Byte(Dest^) := (Byte(Src^) and $3) or ((Byte(Src^) shl 2) and $30); inc(Dest);
    inc(Src);
  end {FOR i}
end;

{Copy grayscale images with 16 bits}
procedure TChunkIDAT.CopyNonInterlacedGrayscale16(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    {Windows does not supports 16 bits for each pixel in grayscale}
    {mode, so reduce to 8}
    Dest^ := Src^; inc(Dest);
    {Move to next pixel}
    inc(Src, 2);
  end {for I}
end;

{Copy 8 bits per sample RGB images followed by an alpha byte}
procedure TChunkIDAT.CopyNonInterlacedRGBAlpha8(Src, Dest, Trans: pChar);
var
  i: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    {Copy pixel values and transparency}
    Trans^ := pChar(Longint(Src) + 3)^;
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);
    {Move to next pixel}
    inc(Src, 4); inc(Trans);
  end {for I}
end;

{Copy 16 bits RGB image with alpha using 2 bytes for each sample}
procedure TChunkIDAT.CopyNonInterlacedRGBAlpha16(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    //Copy rgb and alpha values (transforming from 16 bits to 8 bits)
    {Copy pixel values}
    Trans^ := pChar(Longint(Src) + 6)^;
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 4)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^)  := fOwner.GammaTable[pByte(Longint(Src)    )^]; inc(Dest);
    {Move to next pixel}
    inc(Src, 8); inc(Trans);
  end {for I}
end;

{Copy 8 bits per sample grayscale followed by alpha}
procedure TChunkIDAT.CopyNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: PChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    {Copy alpha value and then gray value}
    Dest^  := Src^;  inc(Src);
    Trans^ := Src^;  inc(Src);
    inc(Dest); inc(Trans);
  end;
end;

{Copy 16 bits per sample grayscale followed by alpha}
procedure TChunkIDAT.CopyNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: PChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    {Copy alpha value and then gray value}
    Dest^  := Src^;  inc(Src, 2);
    Trans^ := Src^;  inc(Src, 2);
    inc(Dest); inc(Trans);
  end;
end;

{Decode non interlaced image}
procedure TChunkIDAT.DecodeNonInterlaced(Stream: PStream;
  var ZLIBStream: TZStreamRec2; const Size: Integer; var crcfile: DWORD);
var
  j: DWORD;
  Trans, Dta: pChar;
  CopyProc: procedure(Src, Dest, Trans: pChar) of object;
begin
  CopyProc := nil; {Initialize}
  {Determines the method to copy the image data}
  case Header.ColorType of
    {R, G, B values}
    COLOR_RGB:
      case Header.BitDepth of
        8: CopyProc := CopyNonInterlacedRGB8;
       16: CopyProc := CopyNonInterlacedRGB16;
      end;
    {Types using palettes}
    COLOR_PALETTE, COLOR_GRAYSCALE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := CopyNonInterlacedPalette148;
        2      : if Header.ColorType = COLOR_PALETTE then
                   CopyProc := CopyNonInterlacedPalette2
                 else
                   CopyProc := CopyNonInterlacedGray2;
        16     : CopyProc := CopyNonInterlacedGrayscale16;
      end;
    {R, G, B followed by alpha}
    COLOR_RGBALPHA:
      case Header.BitDepth of
        8  : CopyProc := CopyNonInterlacedRGBAlpha8;
       16  : CopyProc := CopyNonInterlacedRGBAlpha16;
      end;
    {Grayscale followed by alpha}
    COLOR_GRAYSCALEALPHA:
      case Header.BitDepth of
        8  : CopyProc := CopyNonInterlacedGrayscaleAlpha8;
       16  : CopyProc := CopyNonInterlacedGrayscaleAlpha16;
      end;
  end;

  {Get the image data pointer}
  Longint(Dta) := Longint(Header.ImageData) +
    Header.BytesPerRow * (ImageHeight - 1);
  Trans := Header.ImageAlpha;
  {Reads each line}
  FOR j := 0 to ImageHeight - 1 do
  begin
    {Read this line Row_Buffer[RowUsed][0] if the filter type for this line}
    if IDATZlibRead(ZLIBStream, @Row_Buffer[RowUsed][0], Row_Bytes + 1, EndPos,
      CRCFile) = 0 then break;

    {Filter the current row}
    FilterRow;
    {Copies non interlaced row to image}
    CopyProc(@Row_Buffer[RowUsed][1], Dta, Trans);

    {Invert line used}
    RowUsed := not RowUsed;
    dec(Dta, Header.BytesPerRow);
    inc(Trans, ImageWidth);
  end {for I};


end;

{Filter the current line}
procedure TChunkIDAT.FilterRow;
var
  pp: Byte;
  vv, left, above, aboveleft: Integer;
  Col: DWORD;
begin
  {Test the filter}
  case Row_Buffer[RowUsed]^[0] of
    {No filtering for this line}
    FILTER_NONE: begin end;
    {AND 255 serves only to never let the result be larger than one byte}
    {Sub filter}
    FILTER_SUB:
      FOR Col := Offset + 1 to Row_Bytes DO
        Row_Buffer[RowUsed][Col] := (Row_Buffer[RowUsed][Col] +
          Row_Buffer[RowUsed][Col - Offset]) and 255;
    {Up filter}
    FILTER_UP:
      FOR Col := 1 to Row_Bytes DO
        Row_Buffer[RowUsed][Col] := (Row_Buffer[RowUsed][Col] +
          Row_Buffer[not RowUsed][Col]) and 255;
    {Average filter}
    FILTER_AVERAGE:
      FOR Col := 1 to Row_Bytes DO
      begin
        {Obtains up and left pixels}
        above := Row_Buffer[not RowUsed][Col];
        if col - 1 < Offset then
          left := 0
        else
          Left := Row_Buffer[RowUsed][Col - Offset];

        {Calculates}
        Row_Buffer[RowUsed][Col] := (Row_Buffer[RowUsed][Col] +
          (left + above) div 2) and 255;
      end;
    {Paeth filter}
    FILTER_PAETH:
    begin
      {Initialize}
      left := 0;
      aboveleft := 0;
      {Test each byte}
      FOR Col := 1 to Row_Bytes DO
      begin
        {Obtains above pixel}
        above := Row_Buffer[not RowUsed][Col];
        {Obtains left and top-left pixels}
        if (col - 1 >= offset) Then
        begin
          left := row_buffer[RowUsed][col - offset];
          aboveleft := row_buffer[not RowUsed][col - offset];
        end;

        {Obtains current pixel and paeth predictor}
        vv := row_buffer[RowUsed][Col];
        pp := PaethPredictor(left, above, aboveleft);

        {Calculates}
        Row_Buffer[RowUsed][Col] := (pp + vv) and $FF;
      end {for};
    end;
      
  end {case};
end;

{Reads the image data from the stream}
function IDAT_Load(Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
var
  ZLIBStream: TZStreamRec2;
  CRCCheck,
  CRCFile: DWORD;
  Hdr: PChunkIHDR;
begin
  with PChunkIDAT( Chunk )^ do
  begin
    {Get pointer to the header chunk}
    Hdr := Owner.Header;
    {Build palette if necessary}
    if Hdr.HasPalette then PreparePalette();

    {Copy image width and height}
    ImageWidth := Hdr.Width;
    ImageHeight := Hdr.Height;

    {Initialize to calculate CRC}
    CRCFile := update_crc($ffffffff, @ChunkName[0], 4);

    Owner.GetPixelInfo(Row_Bytes, Offset); {Obtain line information}
    ZLIBStream := ZLIBInitInflate(Stream);  {Initializes decompression}

    {Calculate ending position for the current IDAT chunk}
    EndPos := Stream.Position + DWORD( Size );

    {Allocate memory}
    GetMem(Row_Buffer[false], Row_Bytes + 1);
    GetMem(Row_Buffer[true], Row_Bytes + 1);
    ZeroMemory(Row_Buffer[false], Row_bytes + 1);
    {Set the variable to alternate the Row_Buffer item to use}
    RowUsed := TRUE;

    {Call special methods for the different interlace methods}
    case Owner.InterlaceMethod of
      imNone:  DecodeNonInterlaced(stream, ZLIBStream, Size, crcfile);
      imAdam7: DecodeInterlacedAdam7(stream, ZLIBStream, size, crcfile);
    end;

    {Free memory}
    ZLIBTerminateInflate(ZLIBStream); {Terminates decompression}
    FreeMem(Row_Buffer[False]); //, Row_Bytes + 1);
    FreeMem(Row_Buffer[True]); //, Row_Bytes + 1);

    {Now checks CRC}
    Stream.Read(CRCCheck, 4);
    if Owner.FErrorOnInvalidCRC then
    begin
      CRCFile := CRCFile xor $ffffffff;
      CRCCheck := ByteSwap(CRCCheck);
      Result := CRCCheck = CRCFile;

      {Handle CRC error}
      if not Result then
      begin
        {In case it coult not load chunk}
        Owner.FError := ErrInvalidCRC;
        exit;
      end;
    end
      else
      Result := TRUE;
  end;
end;

const
  IDATHeader: TChunkName = ('I', 'D', 'A', 'T');
  BUFFER = 5;


{Saves the IDAT chunk to a stream}
function IDAT_Save(Chunk: Pointer; Stream: PStream): Boolean;
var
  ZLIBStream : TZStreamRec2;
  Hdr: PChunkIHDR;
begin
  with PChunkIDAT( Chunk )^ do
  begin
    {Get pointer to the header chunk}
    Hdr := Owner.Header;
    {Copy image width and height}
    ImageWidth := Hdr.Width;
    ImageHeight := Hdr.Height;
    Owner.GetPixelInfo(Row_Bytes, Offset); {Obtain line information}

    {Allocate memory}
    GetMem(Encode_Buffer[BUFFER], Row_Bytes);
    ZeroMemory(Encode_Buffer[BUFFER], Row_Bytes);
    {Allocate buffers for the filters selected}
    {Filter none will always be calculated to the other filters to work}
    GetMem(Encode_Buffer[FILTER_NONE], Row_Bytes);
    ZeroMemory(Encode_Buffer[FILTER_NONE], Row_Bytes);
    if pfSub in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_SUB], Row_Bytes);
    if pfUp in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_UP], Row_Bytes);
    if pfAverage in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_AVERAGE], Row_Bytes);
    if pfPaeth in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_PAETH], Row_Bytes);

    {Initialize ZLIB}
    ZLIBStream := ZLIBInitDeflate(Stream, Owner.fCompressionLevel,
      Owner.MaxIdatSize);
    {Write data depending on the interlace method}
    case Owner.InterlaceMethod of
      imNone: EncodeNonInterlaced(stream, ZLIBStream);
      imAdam7: EncodeInterlacedAdam7(stream, ZLIBStream);
    end;
    {Terminates ZLIB}
    ZLIBTerminateDeflate(ZLIBStream);

    {Release allocated memory}
    FreeMem(Encode_Buffer[BUFFER]); //, Row_Bytes);
    FreeMem(Encode_Buffer[FILTER_NONE]); //, Row_Bytes);
    if pfSub in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_SUB]); //, Row_Bytes);
    if pfUp in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_UP]); //, Row_Bytes);
    if pfAverage in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_AVERAGE]); //, Row_Bytes);
    if pfPaeth in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_PAETH]); //, Row_Bytes);

    {Everything went ok}
    Result := True;
  end;
end;

{Writes the IDAT using the settings}
procedure WriteIDAT(Stream: PStream; Data: Pointer; const Length: DWORD);
var
  ChunkLen, CRC: DWORD;
begin
  {Writes IDAT header}
  ChunkLen := ByteSwap(Length);
  Stream.Write(ChunkLen, 4);                      {Chunk length}
  Stream.Write(IDATHeader[0], 4);                 {Idat header}
  CRC := update_crc($ffffffff, @IDATHeader[0], 4); {Crc part for header}

  {Writes IDAT data and calculates CRC for data}
  Stream.Write(Data^, Length);
  CRC := Byteswap(update_crc(CRC, Data, Length) xor $ffffffff);
  {Writes final CRC}
  Stream.Write(CRC, 4);
end;

{Compress and writes IDAT chunk data}
procedure TChunkIDAT.IDATZlibWrite(var ZLIBStream: TZStreamRec2;
  Buffer: Pointer; const Length: DWORD);
begin
  with ZLIBStream, ZLIBStream.ZLIB do
  begin
    {Set data to be compressed}
    next_in := Buffer;
    avail_in := Length;

    {Compress all the data avaliable to compress}
    while avail_in > 0 do
    begin
      deflate(ZLIB, Z_NO_FLUSH);

      {The whole buffer was used, save data to stream and restore buffer}
      if avail_out = 0 then
      begin
        {Writes this IDAT chunk}
        WriteIDAT(fStream, Data, ZLIBAllocate);
        
        {Restore buffer}
        next_out := Data;
        avail_out := ZLIBAllocate;
      end {if avail_out = 0};

    end {while avail_in};

  end {with ZLIBStream, ZLIBStream.ZLIB}
end;

{Finishes compressing data to write IDAT chunk}
procedure TChunkIDAT.FinishIDATZlib(var ZLIBStream: TZStreamRec2);
begin
  with ZLIBStream, ZLIBStream.ZLIB do
  begin
    {Set data to be compressed}
    next_in := nil;
    avail_in := 0;

    while deflate(ZLIB,Z_FINISH) <> Z_STREAM_END do
    begin
      {Writes this IDAT chunk}
      WriteIDAT(fStream, Data, ZLIBAllocate - avail_out);
      {Re-update buffer}
      next_out := Data;
      avail_out := ZLIBAllocate;
    end;

    if avail_out < ZLIBAllocate then
      {Writes final IDAT}
      WriteIDAT(fStream, Data, ZLIBAllocate - avail_out);

  end {with ZLIBStream, ZLIBStream.ZLIB};
end;

{Copy memory to encode RGB image with 1 byte for each color sample}
procedure TChunkIDAT.EncodeNonInterlacedRGB8(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    {Copy pixel values}
    Byte(Dest^) := fOwner.InverseGamma[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := fOwner.InverseGamma[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^) := fOwner.InverseGamma[pByte(Longint(Src)    )^]; inc(Dest);
    {Move to next pixel}
    inc(Src, 3);
  end {for I}
end;

{Copy memory to encode RGB images with 16 bits for each color sample}
procedure TChunkIDAT.EncodeNonInterlacedRGB16(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    //Now we copy from 1 byte for each sample stored to a 2 bytes (or 1 word)
    //for sample
    {Copy pixel values}
    pWORD(Dest)^ := fOwner.InverseGamma[pByte(Longint(Src) + 2)^]; inc(Dest, 2);
    pWORD(Dest)^ := fOwner.InverseGamma[pByte(Longint(Src) + 1)^]; inc(Dest, 2);
    pWORD(Dest)^ := fOwner.InverseGamma[pByte(Longint(Src)    )^]; inc(Dest, 2);
    {Move to next pixel}
    inc(Src, 3);
  end {for I}

end;

{Copy memory to encode types using palettes (1, 4 or 8 bits per pixel)}
procedure TChunkIDAT.EncodeNonInterlacedPalette148(Src, Dest, Trans: pChar);
begin
  {It's simple as copying the data}
  CopyMemory(Dest, Src, Row_Bytes);
end;

{Copy memory to encode grayscale images with 2 bytes for each sample}
procedure TChunkIDAT.EncodeNonInterlacedGrayscale16(Src, Dest, Trans: pChar);
var
  I: Integer;
begin
  FOR I := 1 TO ImageWidth DO
  begin
    //Now we copy from 1 byte for each sample stored to a 2 bytes (or 1 word)
    //for sample
    pWORD(Dest)^ := pByte(Longint(Src))^; inc(Dest, 2);
    {Move to next pixel}
    inc(Src);
  end {for I}
end;

{Encode images using RGB followed by an alpha value using 1 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedRGBAlpha8(Src, Dest, Trans: pChar);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans pointer}
  FOR i := 1 TO ImageWidth do
  begin
    Byte(Dest^) := Owner.InverseGamma[PByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := Owner.InverseGamma[PByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^) := Owner.InverseGamma[PByte(Longint(Src)    )^]; inc(Dest);
    Dest^ := Trans^; inc(Dest);
    inc(Src, 3); inc(Trans);
  end {for i};
end;

{Encode images using RGB followed by an alpha value using 2 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedRGBAlpha16(Src, Dest, Trans: pChar);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans pointer}
  FOR i := 1 TO ImageWidth do
  begin
    pWord(Dest)^ := Owner.InverseGamma[PByte(Longint(Src) + 2)^]; inc(Dest, 2);
    pWord(Dest)^ := Owner.InverseGamma[PByte(Longint(Src) + 1)^]; inc(Dest, 2);
    pWord(Dest)^ := Owner.InverseGamma[PByte(Longint(Src)    )^]; inc(Dest, 2);
    pWord(Dest)^ := PByte(Longint(Trans)  )^; inc(Dest, 2);
    inc(Src, 3); inc(Trans);
  end {for i};
end;

{Encode grayscale images followed by an alpha value using 1 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedGrayscaleAlpha8(Src, Dest,Trans: pChar);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans pointer}
  FOR i := 1 TO ImageWidth do
  begin
    Dest^ := Src^; inc(Dest);
    Dest^ := Trans^; inc(Dest);
    inc(Src); inc(Trans);
  end {for i};
end;

{Encode grayscale images followed by an alpha value using 2 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedGrayscaleAlpha16(Src, Dest,Trans:pChar);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans pointer}
  FOR i := 1 TO ImageWidth do
  begin
    pWord(Dest)^ := pByte(Src)^;    inc(Dest, 2);
    pWord(Dest)^ := pByte(Trans)^;  inc(Dest, 2);
    inc(Src); inc(Trans);
  end {for i};
end;

{Encode non interlaced images}
procedure TChunkIDAT.EncodeNonInterlaced(Stream: PStream;
  var ZLIBStream: TZStreamRec2);
var
  {Current line}
  j: DWORD;
  {Pointers to image data}
  Dta, Trans: PChar;
  {Filter used for this line}
  Filter: Byte;
  {Method which will copy the data into the buffer}
  CopyProc: procedure(Src, Dst, Trans: Pchar) of object;
begin
  CopyProc := nil;  {Initialize to avoid warnings}
  {Defines the method to copy the data to the buffer depending on}
  {the image parameters}
  case Header.ColorType of
    {R, G, B values}
    COLOR_RGB:
      case Header.BitDepth of
        8: CopyProc := EncodeNonInterlacedRGB8;
       16: CopyProc := EncodeNonInterlacedRGB16;
      end;
    {Palette and grayscale values}
    COLOR_GRAYSCALE, COLOR_PALETTE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := EncodeNonInterlacedPalette148;
             16: CopyProc := EncodeNonInterlacedGrayscale16;
      end;
    {RGB with a following alpha value}
    COLOR_RGBALPHA:
      case Header.BitDepth of
          8: CopyProc := EncodeNonInterlacedRGBAlpha8;
         16: CopyProc := EncodeNonInterlacedRGBAlpha16;
      end;
    {Grayscale images followed by an alpha}
    COLOR_GRAYSCALEALPHA:
      case Header.BitDepth of
        8:  CopyProc := EncodeNonInterlacedGrayscaleAlpha8;
       16:  CopyProc := EncodeNonInterlacedGrayscaleAlpha16;
      end;
  end {case Header.ColorType};

  {Get the image data pointer}
  Longint(Dta) := Longint(Header.ImageData) +
    Header.BytesPerRow * (ImageHeight - 1);
  Trans := Header.ImageAlpha;

  {Writes each line}
  FOR j := 0 to ImageHeight - 1 do
  begin
    {Copy data into buffer}
    CopyProc(Dta, @Encode_Buffer[BUFFER][0], Trans);
    {Filter data}
    Filter := FilterToEncode;

    {Compress data}
    IDATZlibWrite(ZLIBStream, @Filter, 1);
    IDATZlibWrite(ZLIBStream, @Encode_Buffer[Filter][0], Row_Bytes);

    {Adjust pointers to the actual image data}
    dec(Dta, Header.BytesPerRow);
    inc(Trans, ImageWidth);
  end;

  {Compress and finishes copying the remaining data}
  FinishIDATZlib(ZLIBStream);
end;

{Copy memory to encode interlaced images using RGB value with 1 byte for}
{each color sample}
procedure TChunkIDAT.EncodeInterlacedRGB8(const Pass: Byte; Src, Dest,
  Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col * 3);
  repeat
    {Copy this row}
    Byte(Dest^) := fOwner.InverseGamma[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := fOwner.InverseGamma[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^) := fOwner.InverseGamma[pByte(Longint(Src)    )^]; inc(Dest);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass] * 3);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy memory to encode interlaced RGB images with 2 bytes each color sample}
procedure TChunkIDAT.EncodeInterlacedRGB16(const Pass: Byte; Src, Dest,
  Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col * 3);
  repeat
    {Copy this row}
    pWord(Dest)^ := Owner.InverseGamma[pByte(Longint(Src) + 2)^]; inc(Dest, 2);
    pWord(Dest)^ := Owner.InverseGamma[pByte(Longint(Src) + 1)^]; inc(Dest, 2);
    pWord(Dest)^ := Owner.InverseGamma[pByte(Longint(Src)    )^]; inc(Dest, 2);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass] * 3);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy memory to encode interlaced images using palettes using bit depths}
{1, 4, 8 (each pixel in the image)}
procedure TChunkIDAT.EncodeInterlacedPalette148(const Pass: Byte; Src, Dest,
  Trans: pChar);
const
  BitTable: Array[1..8] of Integer = ($1, $3, 0, $F, 0, 0, 0, $FF);
  StartBit: Array[1..8] of Integer = (7 , 0 , 0, 4,  0, 0, 0, 0);
var
  CurBit, Col: Integer;
  Src2: PChar;
begin
  {Clean the line}
  fillchar(Dest^, Row_Bytes, #0);
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  with Header.BitmapInfo.bmiHeader do
    repeat
      {Copy data}
      CurBit := StartBit[biBitCount];
      repeat
        {Adjust pointer to pixel byte bounds}
        Src2 := pChar(Longint(Src) + (biBitCount * Col) div 8);
        {Copy data}
        Byte(Dest^) := Byte(Dest^) or
          (((Byte(Src2^) shr (StartBit[Header.BitDepth] - (biBitCount * Col)
            mod 8))) and (BitTable[biBitCount])) shl CurBit;

        {Move to next column}
        inc(Col, ColumnIncrement[Pass]);
        {Will read next bits}
        dec(CurBit, biBitCount);
      until CurBit < 0;

      {Move to next byte in source}
      inc(Dest);
    until Col >= ImageWidth;
end;

{Copy to encode interlaced grayscale images using 16 bits for each sample}
procedure TChunkIDAT.EncodeInterlacedGrayscale16(const Pass: Byte; Src, Dest,
  Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col);
  repeat
    {Copy this row}
    pWord(Dest)^ := Byte(Src^); inc(Dest, 2);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode interlaced rgb images followed by an alpha value, all using}
{one byte for each sample}
procedure TChunkIDAT.EncodeInterlacedRGBAlpha8(const Pass: Byte; Src, Dest,
  Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col * 3);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this row}
    Byte(Dest^) := Owner.InverseGamma[pByte(Longint(Src) + 2)^]; inc(Dest);
    Byte(Dest^) := Owner.InverseGamma[pByte(Longint(Src) + 1)^]; inc(Dest);
    Byte(Dest^) := Owner.InverseGamma[pByte(Longint(Src)    )^]; inc(Dest);
    Dest^ := Trans^; inc(Dest);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass] * 3);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode interlaced rgb images followed by an alpha value, all using}
{two byte for each sample}
procedure TChunkIDAT.EncodeInterlacedRGBAlpha16(const Pass: Byte; Src, Dest,
  Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col * 3);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this row}
    pWord(Dest)^ := pByte(Longint(Src) + 2)^; inc(Dest, 2);
    pWord(Dest)^ := pByte(Longint(Src) + 1)^; inc(Dest, 2);
    pWord(Dest)^ := pByte(Longint(Src)    )^; inc(Dest, 2);
    pWord(Dest)^ := pByte(Trans)^; inc(Dest, 2);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass] * 3);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode grayscale interlaced images followed by an alpha value, all}
{using 1 byte for each sample}
procedure TChunkIDAT.EncodeInterlacedGrayscaleAlpha8(const Pass: Byte; Src,
  Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this row}
    Dest^ := Src^;   inc(Dest);
    Dest^ := Trans^; inc(Dest);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass]);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode grayscale interlaced images followed by an alpha value, all}
{using 2 bytes for each sample}
procedure TChunkIDAT.EncodeInterlacedGrayscaleAlpha16(const Pass: Byte; Src,
  Dest, Trans: pChar);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := pChar(Longint(Src) + Col);
  Trans := pChar(Longint(Trans) + Col);
  repeat
    {Copy this row}
    pWord(Dest)^ := pByte(Src)^; inc(Dest, 2);
    pWord(Dest)^ := pByte(Trans)^; inc(Dest, 2);

    {Move to next column}
    inc(Src, ColumnIncrement[Pass]);
    inc(Trans, ColumnIncrement[Pass]);
    inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Encode interlaced images}
procedure TChunkIDAT.EncodeInterlacedAdam7(Stream: PStream;
  var ZLIBStream: TZStreamRec2);
var
  CurrentPass, Filter: Byte;
  PixelsThisRow: Integer;
  CurrentRow : Integer;
  Trans, Dta: pChar;
  CopyProc: procedure(const Pass: Byte; Src, Dest, Trans: pChar) of object;
begin
  CopyProc := nil;  {Initialize to avoid warnings}
  {Defines the method to copy the data to the buffer depending on}
  {the image parameters}
  case Header.ColorType of
    {R, G, B values}
    COLOR_RGB:
      case Header.BitDepth of
        8: CopyProc := EncodeInterlacedRGB8;
       16: CopyProc := EncodeInterlacedRGB16;
      end;
    {Grayscale and palette}
    COLOR_PALETTE, COLOR_GRAYSCALE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := EncodeInterlacedPalette148;
             16: CopyProc := EncodeInterlacedGrayscale16;
      end;
    {RGB followed by alpha}
    COLOR_RGBALPHA:
      case Header.BitDepth of
          8: CopyProc := EncodeInterlacedRGBAlpha8;
         16: CopyProc := EncodeInterlacedRGBAlpha16;
      end;
    COLOR_GRAYSCALEALPHA:
    {Grayscale followed by alpha}
      case Header.BitDepth of
          8: CopyProc := EncodeInterlacedGrayscaleAlpha8;
         16: CopyProc := EncodeInterlacedGrayscaleAlpha16;
      end;
  end {case Header.ColorType};

  {Compress the image using the seven passes for ADAM 7}
  FOR CurrentPass := 0 TO 6 DO
  begin
    {Calculates the number of pixels and bytes for this pass row}
    PixelsThisRow := (ImageWidth - ColumnStart[CurrentPass] +
      ColumnIncrement[CurrentPass] - 1) div ColumnIncrement[CurrentPass];
    Row_Bytes := BytesForPixels(PixelsThisRow, Header.ColorType,
      Header.BitDepth);
    ZeroMemory(Encode_Buffer[FILTER_NONE], Row_Bytes);

    {Get current row index}
    CurrentRow := RowStart[CurrentPass];
    {Get a pointer to the current row image data}
    Dta := Ptr(Longint(Header.ImageData) + Header.BytesPerRow *
      (ImageHeight - 1 - CurrentRow));
    Trans := Ptr(Longint(Header.ImageAlpha) + ImageWidth * CurrentRow);

    {Process all the image rows}
    if Row_Bytes > 0 then
      while CurrentRow < ImageHeight do
      begin
        {Copy data into buffer}
        CopyProc(CurrentPass, Dta, @Encode_Buffer[BUFFER][0], Trans);
        {Filter data}
        Filter := FilterToEncode;

        {Compress data}
        IDATZlibWrite(ZLIBStream, @Filter, 1);
        IDATZlibWrite(ZLIBStream, @Encode_Buffer[Filter][0], Row_Bytes);

        {Move to the next row}
        inc(CurrentRow, RowIncrement[CurrentPass]);
        {Move pointer to the next line}
        dec(Dta, RowIncrement[CurrentPass] * Header.BytesPerRow);
        inc(Trans, RowIncrement[CurrentPass] * ImageWidth);
      end {while CurrentRow < ImageHeight}

  end {CurrentPass};

  {Compress and finishes copying the remaining data}
  FinishIDATZlib(ZLIBStream);
end;

{Filters the row to be encoded and returns the best filter}
function TChunkIDAT.FilterToEncode: Byte;
var
  Run, LongestRun, ii, jj: DWORD;
  Last, Above, LastAbove: Byte;
begin
  {Selecting more filters using the Filters property from TPngObject}
  {increases the chances to the file be much smaller, but decreases}
  {the performace}

  {This method will creates the same line data using the different}
  {filter methods and select the best}

  {Sub-filter}
  if pfSub in Owner.Filters then
    for ii := 0 to Row_Bytes - 1 do
    begin
      {There is no previous pixel when it's on the first pixel, so}
      {set last as zero when in the first}
      if (ii >= Offset) then
        last := Encode_Buffer[BUFFER]^[ii - Offset]
      else
        last := 0;
      Encode_Buffer[FILTER_SUB]^[ii] := Encode_Buffer[BUFFER]^[ii] - last;
    end;

  {Up filter}
  if pfUp in Owner.Filters then
    for ii := 0 to Row_Bytes - 1 do
      Encode_Buffer[FILTER_UP]^[ii] := Encode_Buffer[BUFFER]^[ii] -
        Encode_Buffer[FILTER_NONE]^[ii];

  {Average filter}
  if pfAverage in Owner.Filters then
    for ii := 0 to Row_Bytes - 1 do
    begin
      {Get the previous pixel, if the current pixel is the first, the}
      {previous is considered to be 0}
      if (ii >= Offset) then
        last := Encode_Buffer[BUFFER]^[ii - Offset]
      else
        last := 0;
      {Get the pixel above}
      above := Encode_Buffer[FILTER_NONE]^[ii];

      {Calculates formula to the average pixel}
      Encode_Buffer[FILTER_AVERAGE]^[ii] := Encode_Buffer[BUFFER]^[ii] -
        (above + last) div 2 ;
    end;

  {Paeth filter (the slower)}
  if pfPaeth in Owner.Filters then
  begin
    {Initialize}
    last := 0;
    lastabove := 0;
    for ii := 0 to Row_Bytes - 1 do
    begin
      {In case this pixel is not the first in the line obtains the}
      {previous one and the one above the previous}
      if (ii >= Offset) then
      begin
        last := Encode_Buffer[BUFFER]^[ii - Offset];
        lastabove := Encode_Buffer[FILTER_NONE]^[ii - Offset];
      end;
      {Obtains the pixel above}
      above := Encode_Buffer[FILTER_NONE]^[ii];
      {Calculate paeth filter for this byte}
      Encode_Buffer[FILTER_PAETH]^[ii] := Encode_Buffer[BUFFER]^[ii] -
        PaethPredictor(last, above, lastabove);
    end;
  end;

  {Now calculates the same line using no filter, which is necessary}
  {in order to have data to the filters when the next line comes}
  CopyMemory(@Encode_Buffer[FILTER_NONE]^[0],
    @Encode_Buffer[BUFFER]^[0], Row_Bytes);

  {If only filter none is selected in the filter list, we don't need}
  {to proceed and further}
  if (Owner.Filters = [pfNone]) or (Owner.Filters = []) then
  begin
    Result := FILTER_NONE;
    exit;
  end {if (Owner.Filters = [pfNone...};

  {Check which filter is the best by checking which has the larger}
  {sequence of the same byte, since they are best compressed}
  LongestRun := 0; Result := FILTER_NONE;
  for ii := FILTER_NONE TO FILTER_PAETH do
    {Check if this filter was selected}
    if TFilter(ii) in Owner.Filters then
    begin
      Run := 0;
      {Check if it's the only filter}
      if Owner.Filters = [TFilter(ii)] then
      begin
        Result := ii;
        exit;
      end;

      {Check using a sequence of four bytes}
      for jj := 2 to Row_Bytes - 1 do
        if (Encode_Buffer[ii]^[jj] = Encode_Buffer [ii]^[jj-1]) or
            (Encode_Buffer[ii]^[jj] = Encode_Buffer [ii]^[jj-2]) then
          inc(Run);  {Count the number of sequences}

      {Check if this one is the best so far}
      if (Run > LongestRun) then
      begin
        Result := ii;
        LongestRun := Run;
      end {if (Run > LongestRun)};

    end {if TFilter(ii) in Owner.Filters};
end;

{TChunkPLTE implementation}

{Returns an item in the palette}
function TChunkPLTE.GetPaletteItem(Idx: Byte): TRGBQuad;
begin
  {Test if item is valid, if not return 0}
  if Idx >= Count then
  begin
    Result.rgbBlue := 0;
    Result.rgbGreen := 0;
    Result.rgbRed := 0;
    Result.rgbReserved := 0;
  end
  else
    {Returns the item}
    Result := Header.BitmapInfo.bmiColors[Idx];
end;

{Loads the palette chunk from a stream}
function PLTE_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
type
  pPalEntry = ^PalEntry;
  PalEntry = record r, g, b: Byte end;
var
  j        : Integer;          {For the FOR}
  PalColor : pPalEntry;
begin
  {Let ancestor load data and check CRC}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);
  if not Result then exit;

  with PChunkPLTE( Chunk )^ do
  begin
    {This chunk must be divisible by 3 in order to be valid}
    if (Size mod 3 <> 0) or (Size div 3 > 256) then
    begin
      {Raise error}
      Result := FALSE;
      Owner.FError := ErrInvalidPalette;
      exit;
    end {if Size mod 3 <> 0};

    {Fill array with the palette entries}
    fCount := Size div 3;
    PalColor := Data;
    FOR j := 0 TO fCount - 1 DO
      with Header.BitmapInfo.bmiColors[j] do
      begin
        rgbRed  :=  Owner.GammaTable[PalColor.r];
        rgbGreen := Owner.GammaTable[PalColor.g];
        rgbBlue :=  Owner.GammaTable[PalColor.b];
        rgbReserved := 0;
        inc(PalColor); {Move to next palette entry}
      end;
  end;
end;

{Saves the PLTE chunk to a stream}
function PLTE_Save(Chunk: Pointer; Stream: PStream): Boolean;
var
  J: Integer;
  DataPtr: pByte;
begin
  with PChunkPLTE( Chunk )^ do
  begin
    {Adjust size to hold all the palette items}
    ResizeData(fCount * 3);
    {Copy pointer to data}
    DataPtr := fData;

    {Copy palette items}
    with Header^ do
      FOR j := 0 TO fCount - 1 DO
        with BitmapInfo.bmiColors[j] do
        begin
          DataPtr^ := Owner.InverseGamma[rgbRed]; inc(DataPtr);
          DataPtr^ := Owner.InverseGamma[rgbGreen]; inc(DataPtr);
          DataPtr^ := Owner.InverseGamma[rgbBlue]; inc(DataPtr);
        end {with BitmapInfo};

    {Let ancestor do the rest of the work}
    Result := SaveToStream(Stream);
  end;
end;

{TChunkgAMA implementation}

{Gamma chunk being created}
constructor TChunkgAMa.Create(AOwner: PPngObject);
begin
  {Call ancestor}
  inherited Create(AOwner);
  Gamma := 1;  {Initial value}
end;

{Returns gamma value}
function TChunkgAMA.GetValue: DWORD;
begin
  {Make sure that the size is four bytes}
  if DataSize <> 4 then
  begin
    {Adjust size and returns 1}
    ResizeData(4);
    Result := 1;
  end
  {If it's right, read the value}
  else Result := DWORD(ByteSwap(PDWORD(Data)^))
end;

function Power(Base, Exponent: Extended): Extended;
begin
  if Exponent = 0.0 then
    Result := 1.0               {Math rule}
  else if (Base = 0) or (Exponent = 0) then Result := 0
  else
    Result := Exp(Exponent * Ln(Base));
end;


{Loading the chunk from a stream}
function gAMA_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
var
  i: Integer;
  Value: DWORD;
begin
  {Call ancestor and test if it went ok}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);
  if not Result then exit;

  with PChunkGAMA( Chunk )^ do
  begin
    Value := Gamma;
    {Build gamma table and inverse table for saving}
    if Value <> 0 then
      with Owner^ do
        FOR i := 0 TO 255 DO
        begin
          GammaTable[I] := Round(Power((I / 255), 1 /
            (Value / 100000 * 2.2)) * 255);
          InverseGamma[Round(Power((I / 255), 1 /
            (Value / 100000 * 2.2)) * 255)] := I;
        end
  end;
end;

{Sets the gamma value}
procedure TChunkgAMA.SetValue(const Value: DWORD);
begin
  {Make sure that the size is four bytes}
  if DataSize <> 4 then ResizeData(4);
  {If it's right, set the value}
  PDWORD(Data)^ := ByteSwap(Value);
end;

{TPngObject implementation}

{Clear all the chunks in the list}
procedure TPngObject.ClearChunks;
var
  i: Integer;
begin
  {Initialize gamma}
  InitializeGamma();
  {Free all the objects and memory (0 chunks Bug fixed by Noel Sharpe)}
  for i := 0 TO Chunks.Count - 1 do
    PObj( Chunks.Items[i] ).Free;
  Chunks.Clear;
end;

{Portable Network Graphics object being created}
function NewPngObject: PPngObject;
begin
  {Let it be created}
  new( Result, Create );

  with Result^ do
  begin
    {Initial properties}
    fFilters := [pfSub];
    fCompressionLevel := 7;
    fInterlaceMethod := imNone;
    fMaxIdatSize := High(Word);
    {Create chunklist object}
    fChunkList := NewList;
  end;
end;

{Portable Network Graphics object being destroyed}
destructor TPngObject.Destroy;
begin
  {Free object list}
  ClearChunks;
  fChunkList.Free;

  {Call ancestor destroy}
  inherited Destroy;
end;

{Returns linesize and byte offset for pixels}
procedure TPngObject.GetPixelInfo(var LineSize, Offset: DWORD);
begin
  {There must be an Header chunk to calculate size}
  if HeaderPresent then
  begin
    {Calculate number of bytes for each line}
    LineSize := BytesForPixels(Header.Width, Header.ColorType, Header.BitDepth);

    {Calculates byte offset}
    Case Header.ColorType of
      {Grayscale}
      COLOR_GRAYSCALE:
        If Header.BitDepth = 16 Then
          Offset := 2
        Else
          Offset := 1 ;
      {It always smaller or equal one byte, so it occupes one byte}
      COLOR_PALETTE:
        offset := 1;
      {It might be 3 or 6 bytes}
      COLOR_RGB:
        offset := 3 * Header.BitDepth Div 8;
      {It might be 2 or 4 bytes}
      COLOR_GRAYSCALEALPHA:
        offset := 2 * Header.BitDepth Div 8;
      {4 or 8 bytes}
      COLOR_RGBALPHA:
        offset := 4 * Header.BitDepth Div 8;
      else
        Offset := 0;
      End ;

  end
  else
  begin
    {In case if there isn't any Header chunk}
    Offset := 0;
    LineSize := 0;
  end;

end;

{Returns image height}
function TPngObject.GetHeight: Integer;
begin
  {There must be a Header chunk to get the size, otherwise returns 0}
  if HeaderPresent then
    Result := Header.Height
  else Result := 0;
end;

{Returns image width}
function TPngObject.GetWidth: Integer;
begin
  {There must be a Header chunk to get the size, otherwise returns 0}
  if HeaderPresent then
    Result := Header.Width
  else Result := 0;
end;

{Returns if the image is empty}
function TPngObject.GetEmpty: Boolean;
begin
  Result := (Chunks.Count = 0);
end;

{Set the maximum size for IDAT chunk}
procedure TPngObject.SetMaxIdatSize(const Value: DWORD);
begin
  {Make sure the size is at least 65535}
  if Value < High(Word) then
    fMaxIdatSize := High(Word) else fMaxIdatSize := Value;
end;

{Creates a file stream reading from the filename in the parameter and load}
function TPngObject.LoadFromFile(const Filename: String): Boolean;
var FileStream: PStream;
begin
  FileStream := NewReadFileStream(Filename);
  Result := LoadFromStream(FileStream);
  FileStream.Free;
end;

{Saves the current png image to a file}
procedure TPngObject.SaveToFile(const Filename: String);
var FileStream: PStream;
begin
  FileStream := NewWriteFileStream(Filename);
  SaveToStream(FileStream);
  FileStream.Free;
end;

{Returns pointer to the chunk TChunkIHDR which should be the first}
function TPngObject.GetHeader: PChunkIHDR;
begin
  {If there is a TChunkIHDR returns it, otherwise returns nil}
  if (Chunks.Count > 0) {and (Chunks.Items[0] is TChunkIHDR)} then
    Result := Pointer( Chunks.Items[0] )
  else
  begin
    {No header, throw error message}
    Result := nil
  end
end;

{Draws using partial transparency}
procedure TPngObject.DrawPartialTrans(DC: HDC; Rect: TRect);
type
  {Access to pixels}
  TPixelLine = Array[Word] of TRGBQuad;
  pPixelLine = ^TPixelLine;
const
  {Structure used to create the bitmap}
  BitmapInfoHeader: TBitmapInfoHeader =
    (biSize: sizeof(TBitmapInfoHeader);
     biWidth: 100;
     biHeight: 100;
     biPlanes: 1;
     biBitCount: 32;
     biCompression: BI_RGB;
     biSizeImage: 0;
     biXPelsPerMeter: 0;
     biYPelsPerMeter: 0;
     biClrUsed: 0;
     biClrImportant: 0);
var
  {Buffer bitmap creation}
  BitmapInfo  : TBitmapInfo;
  BufferDC    : HDC;
  BufferBits  : Pointer;
  OldBitmap,
  BufferBitmap: HBitmap;

  {Transparency/palette chunks}
  TransparencyChunk: PChunktRNS;
  PaletteChunk: PChunkPLTE;
  TransValue, PaletteIndex: Byte;
  CurBit: Integer;
  Data: PByte;

  {Buffer bitmap modification}
  BytesPerRowDest,
  BytesPerRowSrc,
  BytesPerRowAlpha: Integer;
  ImageSource,
  AlphaSource     : pByteArray;
  ImageData       : pPixelLine;
  i, j            : Integer;
begin
  {Prepare to create the bitmap}
  Fillchar(BitmapInfo, sizeof(BitmapInfo), #0);
  BitmapInfoHeader.biWidth := Header.Width;
  BitmapInfoHeader.biHeight := -1 * Header.Height;
  BitmapInfo.bmiHeader := BitmapInfoHeader;

  {Create the bitmap which will receive the background, the applied}
  {alpha blending and then will be painted on the background}
  BufferDC := CreateCompatibleDC(0);
  {In case BufferDC could not be created}
  if (BufferDC = 0) then //RaiseError(EPNGOutMemory, EPNGOutMemoryText);
                         Exit;
  BufferBitmap := CreateDIBSection(BufferDC, BitmapInfo, DIB_RGB_COLORS,
    BufferBits, 0, 0);
  {In case buffer bitmap could not be created}
  if (BufferBitmap = 0) or (BufferBits = Nil) then
  begin
    if BufferBitmap <> 0 then DeleteObject(BufferBitmap);
    DeleteDC(BufferDC);
    //RaiseError(EPNGOutMemory, EPNGOutMemoryText);
    Exit;
  end;

  {Selects new bitmap and release old bitmap}
  OldBitmap := SelectObject(BufferDC, BufferBitmap);

  {Draws the background on the buffer image}
  StretchBlt(BufferDC, 0, 0, Header.Width, Header.height, DC, Rect.Left,
    Rect.Top, Header.Width, Header.Height, SRCCOPY);

  {Obtain number of bytes for each row}
  BytesPerRowAlpha := Header.Width;
  BytesPerRowDest := (((BitmapInfo.bmiHeader.biBitCount * Width) + 31)
    and not 31) div 8; {Number of bytes for each image row in destination}
  BytesPerRowSrc := (((Header.BitmapInfo.bmiHeader.biBitCount * Header.Width) +
    31) and not 31) div 8; {Number of bytes for each image row in source}

  {Obtains image pointers}
  ImageData := BufferBits;
  AlphaSource := Header.ImageAlpha;
  Longint(ImageSource) := Longint(Header.ImageData) +
    Header.BytesPerRow * Longint(Header.Height - 1);

  case Header.BitmapInfo.bmiHeader.biBitCount of
    {R, G, B images}
    24:
      FOR j := 1 TO Header.Height DO
      begin
        {Process all the pixels in this line}
        FOR i := 0 TO Header.Width - 1 DO
          with ImageData[i] do
          begin
            rgbRed := (255+ImageSource[2+i*3] * AlphaSource[i] + rgbRed * (255 -
              AlphaSource[i])) shr 8;
            rgbGreen := (255+ImageSource[1+i*3] * AlphaSource[i] + rgbGreen *
              (255 - AlphaSource[i])) shr 8;
            rgbBlue := (255+ImageSource[i*3] * AlphaSource[i] + rgbBlue *
             (255 - AlphaSource[i])) shr 8;
          end;

        {Move pointers}
        Longint(ImageData) := Longint(ImageData) + BytesPerRowDest;
        Longint(ImageSource) := Longint(ImageSource) - BytesPerRowSrc;
        Longint(AlphaSource) := Longint(AlphaSource) + BytesPerRowAlpha;
      end;
    {Palette images with 1 byte for each pixel}
    1,4,8: if Header.ColorType = COLOR_GRAYSCALEALPHA then
      FOR j := 1 TO Header.Height DO
      begin
        {Process all the pixels in this line}
        FOR i := 0 TO Header.Width - 1 DO
          with ImageData[i], Header.BitmapInfo do begin
            rgbRed := (255 + ImageSource[i] * AlphaSource[i] +
              rgbRed * (255 - AlphaSource[i])) shr 8;
            rgbGreen := (255 + ImageSource[i] * AlphaSource[i] +
              rgbGreen * (255 - AlphaSource[i])) shr 8;
            rgbBlue := (255 + ImageSource[i] * AlphaSource[i] +
              rgbBlue * (255 - AlphaSource[i])) shr 8;
          end;

        {Move pointers}
        Longint(ImageData) := Longint(ImageData) + BytesPerRowDest;
        Longint(ImageSource) := Longint(ImageSource) - BytesPerRowSrc;
        Longint(AlphaSource) := Longint(AlphaSource) + BytesPerRowAlpha;
      end
    else {Palette images}
    begin
      {Obtain pointer to the transparency chunk}
      TransparencyChunk := ChunkByName('tRNS');
      PaletteChunk := ChunkByName('PLTE');

      FOR j := 1 TO Header.Height DO
      begin
        {Process all the pixels in this line}
        i := 0; Data := @ImageSource[0];
        repeat
          CurBit := 0;

          repeat
            {Obtains the palette index}
            case Header.BitDepth of
              1: PaletteIndex := (Data^ shr (7-(I Mod 8))) and 1;
            2,4: PaletteIndex := (Data^ shr ((1-(I Mod 2))*4)) and $0F;
             else PaletteIndex := Data^;
            end;

            {Updates the image with the new pixel}
            with ImageData[i] do
            begin
              TransValue := TransparencyChunk.PaletteValues[PaletteIndex];
              rgbRed := (255 + PaletteChunk.Item[PaletteIndex].rgbRed *
                 TransValue + rgbRed * (255 - TransValue)) shr 8;
              rgbGreen := (255 + PaletteChunk.Item[PaletteIndex].rgbGreen *
                 TransValue + rgbGreen * (255 - TransValue)) shr 8;
              rgbBlue := (255 + PaletteChunk.Item[PaletteIndex].rgbBlue *
                 TransValue + rgbBlue * (255 - TransValue)) shr 8;
            end;

            {Move to next data}
            inc(i); inc(CurBit, Header.BitmapInfo.bmiHeader.biBitCount);
          until CurBit >= 8;
          {Move to next source data}
          inc(Data);
        until i >= Integer(Header.Width);

        {Move pointers}
        Longint(ImageData) := Longint(ImageData) + BytesPerRowDest;
        Longint(ImageSource) := Longint(ImageSource) - BytesPerRowSrc;
      end
    end {Palette images}
  end {case Header.BitmapInfo.bmiHeader.biBitCount};

  {Draws the new bitmap on the foreground}
  StretchBlt(DC, Rect.Left, Rect.Top, Header.Width, Header.Height, BufferDC,
    0, 0, Header.Width, Header.Height, SRCCOPY);

  {Free bitmap}
  SelectObject(BufferDC, OldBitmap);
  DeleteObject(BufferBitmap);
  DeleteDC(BufferDC);
end;

{Draws the image into a canvas}
procedure TPngObject.Draw(DC: HDC; X, Y: Integer);
var
  Hdr: PChunkIHDR;
begin
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;

  StretchDiBits(DC, X, Y, Hdr.Width, Hdr.Height, 0, 0,
    Hdr.Width, Hdr.Height, Hdr.ImageData,
    pBitmapInfo(@Hdr.BitmapInfo)^, DIB_RGB_COLORS, SRCCOPY);
end;

procedure TPngObject.DrawTransparent(DC: HDC; X, Y: Integer;
  TranColor: TColor);
var
  Hdr: PChunkIHDR;
begin
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;

  {Copy the data to the canvas}
  case Self.TransparencyMode of
    ptmPartial:
      DrawPartialTrans(DC, MakeRect( X, Y, X + Width, Y + Height ));
    else DrawTransparentBitmap(DC,
      Hdr.ImageData, Hdr.BitmapInfo.bmiHeader,
      pBitmapInfo(@Header.BitmapInfo), MakeRect( X, Y, X + Width, Y + Height ),
      Color2RGB(TranColor))
  end {case}
end;

procedure TPngObject.StretchDraw(DC: HDC; const Rect: TRect);
var
  Hdr: PChunkIHDR;
begin
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;
  StretchDiBits(DC, Rect.Left,
    Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top, 0, 0,
    Hdr.Width, Hdr.Height, Hdr.ImageData,
    pBitmapInfo(@Hdr.BitmapInfo)^, DIB_RGB_COLORS, SRCCOPY)
end;

procedure TPngObject.StretchDrawTransparent(DC: HDC; const Rect: TRect;
  TranColor: TColor);
var
  Hdr: PChunkIHDR;
begin
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;

  case Self.TransparencyMode of
    ptmPartial:
      DrawPartialTrans(DC, Rect);
    else // ptmBit:
      DrawTransparentBitmap(DC,
          Hdr.ImageData, Hdr.BitmapInfo.bmiHeader,
          pBitmapInfo(@Header.BitmapInfo), Rect,
          Color2RGB(TranColor));
  end;
end;

{Characters for the header}
const
  PngHeader: Array[0..7] of Char = (#137, #80, #78, #71, #13, #10, #26, #10);

{Loads the image from a stream of data}
function TPngObject.LoadFromStream(Stream: PStream): Boolean;
const
  ChunkLoadArray: TLoadArray = ( nil, IHDR_Load, nil, IDAT_Load,
                  PLTE_Load, gAMA_Load, TRNS_Load, tEXt_Load, tIME_Load );
var
  Hdr: Array[0..7] of Char;
  HasIDAT: Boolean;

  {Chunks reading}
  ChunkLength: DWORD;
  ChunkName  : TChunkName;

  Chunk: PChunk;
  CType: TChunkType;
begin
  FError := ErrOK;
  Result := FALSE;

  {Initialize before start loading chunks}
  ClearChunks();
  {Reads the header}
  Stream.Read(Hdr[0], 8);

  {Test if the header matches}
  if Hdr <> PngHeader then
  begin
    FError := ErrInvalidHeader;
    Exit;
  end;

  HasIDAT := FALSE;
  {Load chunks}
  repeat
    {Reads chunk length and invert since it is in network order}
    {also checks the Read method return, if it returns 0, it}
    {means that no bytes was readed, probably because it reached}
    {the end of the file}
    if Stream.Read(ChunkLength, 4) < 4 then
    begin
      {In case it found the end of the file here}
      FError := ErrUnexpectedEnd;
      Result := HeaderPresent and (ChunkByName( 'IDAT' ) <> nil);
      Exit;
    end;

    ChunkLength := ByteSwap(ChunkLength);
    {Reads chunk name}
    Stream.Read(Chunkname, 4);

    {Here we check if the first chunk is the Header which is necessary}
    {to the file in order to be a valid Portable Network Graphics image}
    if (Chunks.Count = 0) and (ChunkName <> 'IHDR') then
    begin
      FError := ErrIHDRNotFirst;
      exit;
    end;

    {Has a previous IDAT}
    if (HasIDAT and (ChunkName = 'IDAT')) or (ChunkName = 'cHRM') then
    begin
      Stream.Position := Stream.Position + ChunkLength + 4;
      Continue;
    end;
    {Tell it has an IDAT chunk}
    if ChunkName = 'IDAT' then HasIDAT := TRUE;

    {Creates object for this chunk}

    Chunk := CreateChunkByName( ChunkName );

    {Check if the chunk is unknown and this is critical}
      if Chunk = nil then
      begin
        FError := ErrUnknownCriticalChunk;
        Exit;
      end;

    {Loads it}
    CType := ChunkTypeByName( ChunkName );
    if Assigned( ChunkLoadArray[ CType ] ) then
    begin
      if not ChunkLoadArray[ CType ]( Chunk, Stream, ChunkName, ChunkLength ) then
        break;
    end
      else
    begin
      if not Chunk.LoadFromStream( Stream, ChunkName, ChunkLength ) then
        break;
    end;

  {Terminates when it reaches the IEND chunk}
  until (ChunkName = 'IEND');

  {Check if there is data}
  if not HasIDAT then
  begin
    FError := ErrNoImageData;
    Exit;
  end;

  Result := TRUE;
end;

{Saves to clipboard format (thanks to Antoine Pottern)}
function TPNGObject.CopyToClipboard: Boolean;
var Bitmap: PBitmap;
begin
  Bitmap := NewBitmap( Width, Height );
  TRY
    Draw( Bitmap.Canvas.Handle, 0, 0 );
    Result := Bitmap.CopyToClipboard;
  FINALLY
    Bitmap.Free;
  END;
end;

{Loads data from clipboard}
function TPngObject.PasteFromClipboard: Boolean;
var Bitmap: PBitmap;
begin
  Bitmap := NewBitmap( 0, 0 );
  TRY
    Result := Bitmap.PasteFromClipboard;
    if not Result then Exit;
    AssignHandle( Bitmap.Handle, FALSE, 0 );
  FINALLY
    Bitmap.Free;
  END;
end;

{Returns if the image is transparent}
{function TPngObject.GetTransparent: Boolean;
begin
  Result := (TransparencyMode <> ptmNone);
end;}

{Saving the PNG image to a stream of data}
procedure TPngObject.SaveToStream(Stream: PStream);
const
  ChunkSaveArray: TSaveArray = ( nil, IHDR_Save, nil, IDAT_Save,
                  PLTE_Save, nil, TRNS_Save, tEXt_Save, tIME_Save );
var
  j: Integer;
  CType: TChunkType;
begin
  {Reads the header}
  Stream.Write(PNGHeader[0], 8);
  {Write each chunk}
  FOR j := 0 TO Chunks.Count - 1 DO
  begin
    CType := ChunkTypeByName( PChunk( Chunks.Items[j] ).Name );
    if Assigned( ChunkSaveArray[ CType ] ) then
      ChunkSaveArray[ CType ]( Chunks.Items[j], Stream )
    else
      PChunk( Chunks.Items[j] ).SaveToStream(Stream);
  end;
end;

{Prepares the Header chunk}
procedure BuildHeader(Header: PChunkIHDR; Handle: HBitmap; Info: Windows.PBitmap;
  HasPalette: Boolean);
var
  DC: HDC;
begin
  {Set width and height}
  Header.Width := Info.bmWidth;
  Header.Height := abs(Info.bmHeight);
  {Set bit depth}
  if Info.bmBitsPixel >= 16 then
    Header.BitDepth := 8 else Header.BitDepth := Info.bmBitsPixel;
  {Set color type}
  if Info.bmBitsPixel >= 16 then
    Header.ColorType := COLOR_RGB else Header.ColorType := COLOR_PALETTE;
  {Set other info}
  Header.CompressionMethod := 0;  {deflate/inflate}
  Header.InterlaceMethod := 0;    {no interlace}

  {Prepares bitmap headers to hold data}
  Header.PrepareImageData();
  {Copy image data}
  DC := CreateCompatibleDC(0);
  GetDIBits(DC, Handle, 0, Header.Height, Header.ImageData,
    pBitmapInfo(@Header.BitmapInfo)^, DIB_RGB_COLORS);
  DeleteDC(DC);
end;

{Loads the image from a resource}
procedure TPngObject.LoadFromResourceName(Instance: HInst;
  const Name: String);
var MemStream: PStream;
begin
  {Creates an especial stream to load from the resource}
  MemStream := NewMemoryStream;
  Resource2Stream( MemStream, Instance, PChar( Name ), RT_RCDATA );
  {Loads the png image from the resource}
  try
    MemStream.Position := 0;
    LoadFromStream(MemStream);
  finally
    MemStream.Free;
  end;
end;

{Loads the png from a resource ID}
procedure TPngObject.LoadFromResourceID(Instance: HInst; ResID: Integer);
begin
  LoadFromResourceName(Instance, String(ResID));
end;

{Assigns from a bitmap object}
procedure TPngObject.AssignHandle(Handle: HBitmap; Transparent: Boolean;
  TranColor: ColorRef);
var
  BitmapInfo: Windows.TBitmap;
  HasPalette: Boolean;

  {Chunks}
  Head: PChunkIHDR;
  PLTE: PChunkPLTE;
  IDAT: PChunkIDAT;
  IEND: PChunkIEND;
  TRNS: PChunkTRNS;
begin
  {Obtain bitmap info}
  GetObject(Handle, SizeOf(BitmapInfo), @BitmapInfo);

  {Only bit depths 1, 4 and 8 needs a palette}
  HasPalette := (BitmapInfo.bmBitsPixel < 16);

  {Clear old chunks and prepare}
  ClearChunks();

  {Create the chunks}
  new( Head, Create( @ Self ) ); fChunkList.Add( Head );
  if HasPalette then
  begin
    new( PLTE, Create( @ Self ) );
    fChunkList.Add( PLTE );
  end
    else PLTE := nil;
  if Transparent then
  begin
    new( TRNS, Create( @ Self ) );
    fChunkList.Add( TRNS );
  end
    else TRNS := nil;
  new( IDAT, Create( @ Self ) ); fChunkList.Add( IDAT );
  new( IEND, Create( @ Self ) ); fChunkList.Add( IEND );

  {This method will fill the Header chunk with bitmap information}
  {and copy the image data}
  BuildHeader(Head, Handle, @BitmapInfo, HasPalette);

  {In case there is a image data, set the PLTE chunk fCount variable}
  {to the actual number of palette colors which is 2^(Bits for each pixel)}
  if HasPalette then PLTE.fCount := 1 shl BitmapInfo.bmBitsPixel;

  {In case it is a transparent bitmap, prepares it}
  if Transparent then TRNS.TransparentColor := TranColor;

end;

{Assigns from another PNG}
procedure TPngObject.AssignPNG(Source: PPNGObject);
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Source.SaveToStream( Strm );
  Strm.Position := 0;
  LoadFromStream( Strm );
  Strm.Free;
end;

{Returns a alpha data scanline}
function TPngObject.GetAlphaScanline(const LineIndex: Integer): pByteArray;
begin
  with Header^ do
    if (ColorType = COLOR_RGBALPHA) or (ColorType = COLOR_GRAYSCALEALPHA) then
      Integer(Result) := Integer(ImageAlpha) + (LineIndex * Longint(Width))
    else Result := nil;  {In case the image does not use alpha information}
end;

{Returns a png data scanline}
function TPngObject.GetScanline(const LineIndex: Integer): Pointer;
begin
  with Header^ do
    Integer(Result) := (Integer(ImageData) + ((Integer(Height) - 1) *
      BytesPerRow)) - (LineIndex * BytesPerRow);
end;

{Initialize gamma table}
procedure TPngObject.InitializeGamma;
var
  i: Integer;
begin
  {Build gamma table as if there was no gamma}
  FOR i := 0 to 255 do
  begin
    GammaTable[i] := i;
    InverseGamma[i] := i;
  end {for i}
end;

{Returns the transparency mode used by this png}
function TPngObject.GetTransparencyMode: TPNGTransparencyMode;
var
  TRNS: PChunkTRNS;
begin
  with Header^ do
  begin
    Result := ptmNone; {Default result}
    {Gets the TRNS chunk pointer}
    TRNS := ChunkByName('TRNS');

    {Test depending on the color type}
    case ColorType of
      {This modes are always partial}
      COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA: Result := ptmPartial;
      {This modes support bit transparency}
      COLOR_RGB, COLOR_GRAYSCALE: if TRNS <> nil then Result := ptmBit;
      {Supports booth translucid and bit}
      COLOR_PALETTE:
        {A TRNS chunk must be present, otherwise it won't support transparency}
        if TRNS <> nil then
          if TRNS.BitTransparency then
            Result := ptmBit else Result := ptmPartial
    end {case}

  end {with Header}
end;

{Add a text chunk}
procedure TPngObject.AddText(const Keyword, Text: String);
var
  TextChunk: PChunkTEXT;
begin
  new( TextChunk, Create( @ Self ) );
  fChunkList.Insert( fChunkList.Count-1, TextChunk );
  TextChunk.Keyword := Keyword;
  TextChunk.Text := Text;
end;

{Removes the image transparency}
procedure TPngObject.RemoveTransparency;
var TRNS: PChunkTRNS;
begin
  TRNS := ChunkByName('TRNS');
  if TRNS <> nil then
  begin
    Chunks.Remove(TRNS);
    TRNS.Free;
  end;
end;

{Generates alpha information}
procedure TPngObject.CreateAlpha;
var
  TRNS: PChunkTRNS;
begin
  {Generates depending on the color type}
  with Header^ do
    case ColorType of
      {Png allocates different memory space to hold alpha information}
      {for these types}
      COLOR_GRAYSCALE, COLOR_RGB:
      begin
        {Transform into the appropriate color type}
        if ColorType = COLOR_GRAYSCALE then
          ColorType := COLOR_GRAYSCALEALPHA
        else ColorType := COLOR_RGBALPHA;
        {Allocates memory to hold alpha information}
        GetMem(ImageAlpha, Integer(Width) * Integer(Height));
        FillChar(ImageAlpha^, Integer(Width) * Integer(Height), #255);
      end;
      {Palette uses the TChunktRNS to store alpha}
      COLOR_PALETTE:
      begin
        {Gets/creates TRNS chunk}
        TRNS := ChunkByName( 'TRNS' );
        if TRNS = nil then
          TRNS := CreateChunkByName( 'TRNS' );

        {Prepares the TRNS chunk}
        with TRNS^ do
        begin
          Fillchar(PaletteValues[0], 256, 255);
          fDataSize := 1 shl Header.BitDepth;
          fBitTransparency := False
        end {with Chunks.Add};
      end;
    end {case Header.ColorType}

end;

{Returns transparent color}
function TPngObject.GetTransparentColor: TColor;
var
  TRNS: PChunkTRNS;
begin
  TRNS := ChunkByName( 'TRNS' );
  {Reads the transparency chunk to get this info}
  if Assigned(TRNS) then Result := TRNS.TransparentColor
    else Result := 0
end;

procedure TPngObject.SetTransparentColor(const Value: TColor);
var
  TRNS: PChunkTRNS;
begin
  if HeaderPresent then
    {Tests the ColorType}
    case Header.ColorType of
    {Not allowed for this modes}
    COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA:
      {Self.RaiseError(
      EPNGCannotChangeTransparent, EPNGCannotChangeTransparentText)};
    {Allowed}
    COLOR_PALETTE, COLOR_RGB, COLOR_GRAYSCALE:
      begin
        TRNS := ChunkByName('TRNS');
        if not Assigned(TRNS) then
          TRNS := CreateChunkByName('TRNS');
        {Sets the transparency value from TRNS chunk}
        TRNS.TransparentColor := Value
      end {COLOR_PALETTE, COLOR_RGB, COLOR_GRAYSCALE)}
    end {case}
end;

{Returns if header is present}
function TPngObject.HeaderPresent: Boolean;
begin
  Result := (Chunks.Count > 0) and (PChunk(Chunks.Items[0]).Name = 'IHDR')
end;

function TPngObject.ChunkByName(const Name: TChunkName): Pointer;
var I: Integer;
    Chunk: PChunk;
begin
  for I := 0 to fChunkList.Count-1 do
  begin
    Chunk := fChunkList.Items[ I ];
    if Chunk.Name = Name then
    begin
      Result := Chunk;
      Exit;
    end;
  end;
  Result := nil;
end;

function TPngObject.CreateChunkByName(const Name: TChunkName): Pointer;
var
  IHDR: PChunkIHDR;
  IEND: PChunkIEND;
  IDAT: PChunkIDAT;
  PLTE: PChunkPLTE;
  GAMA: PChunkGAMA;
  TRNS: PChunkTRNS;
  TEXT: PChunkTEXT;
  TIME: PChunkTIME;
  Chnk: PChunk;
begin
  Result := nil;
  case ChunkTypeByName( Name ) of
  ctIHDR:  begin
             if HeaderPresent then Exit;
             new( IHDR, Create( @ Self ) );
             fChunkList.Insert( 0, IHDR );
             Result := IHDR;
           end;
  ctIEND:  begin
             if (fChunkList.Count > 0) and
                (PChunk( fChunkList.Items[ fChunkList.Count-1 ] ).Name = 'IEND') then
                Exit;
             new( IEND, Create( @ Self ) );
             fChunkList.Add( IEND );
             Result := IEND;
           end;
  ctIDAT:  begin
             if ChunkByName( 'IDAT' ) <> nil then Exit;
             new( IDAT, Create( @ Self ) );
             IHDR := ChunkByName( 'IHDR' );
             if IHDR <> nil then
               fChunkList.Insert( 1, IDAT )
             else
               fChunkList.Insert( 0, IDAT );
             Result := IDAT;
           end;
  ctPLTE:  begin
             if ChunkByName( 'PLTE' ) <> nil then Exit;
             new( PLTE, Create( @ Self ) );
             IDAT := ChunkByName( 'IDAT' );
             IHDR := ChunkByName( 'IHDR' );
             if IDAT <> nil then
               fChunkList.Insert( IDAT.Index + 1, PLTE )
             else if IHDR <> nil then
               fChunkList.Insert( 1, PLTE )
             else
               fChunkList.Insert( 0, PLTE );
             Result := PLTE;
           end;
  ctgAMA:  begin
             if ChunkByName( 'gAMA' ) <> nil then Exit;
             new( GAMA, Create( @ Self ) );
             PLTE := ChunkByName( 'PLTE' );
             IDAT := ChunkByName( 'IDAT' );
             IHDR := ChunkByName( 'IHDR' );
             if PLTE <> nil then
               fChunkList.Insert( PLTE.Index + 1, GAMA )
             else if IDAT <> nil then
               fChunkList.Insert( IDAT.Index + 1, GAMA )
             else if IHDR <> nil then
               fChunkList.Insert( 1, GAMA )
             else
               fChunkList.Insert( 0, GAMA );
             Result := GAMA;
           end;
  ctTRNS:  begin
             if ChunkByName( 'TRNS' ) <> nil then Exit;
             new( TRNS, Create( @ Self ) );
             GAMA := ChunkByName( 'gAMA' );
             PLTE := ChunkByName( 'PLTE' );
             IDAT := ChunkByName( 'IDAT' );
             IHDR := ChunkByName( 'IHDR' );
             if GAMA <> nil then
               fChunkList.Insert( GAMA.Index + 1, TRNS )
             else if PLTE <> nil then
               fChunkList.Insert( PLTE.Index + 1, TRNS )
             else if IDAT <> nil then
               fChunkList.Insert( IDAT.Index + 1, TRNS )
             else if IHDR <> nil then
               fChunkList.Insert( 1, TRNS )
             else
               fChunkList.Insert( 0, TRNS );
             Result := GAMA;
           end;
  cttEXt:  begin
             new( TEXT, Create( @ Self ) );
             IEND := ChunkByName( 'IEND' );
             if IEND <> nil then
               fChunkList.Insert( IEND.Index, TEXT )
             else
               fChunkList.Add( TEXT );
             Result := TEXT;
           end;
  cttIME:  begin
             new( TIME, Create( @ Self ) );
             IEND := ChunkByName( 'IEND' );
             if IEND <> nil then
               fChunkList.Insert( IEND.Index, TIME )
             else
               fChunkList.Add( TIME );
             Result := TIME;
           end;
  else
           begin
             new( Chnk, Create( @ Self ) );
             IEND := ChunkByName( 'IEND' );
             if IEND <> nil then
               fChunkList.Insert( IEND.Index, Chnk )
             else
               fChunkList.Add( Chnk );
             Result := Chnk;
           end;
  end;
  PChunk( Result ).fName := Name;
end;

{ TChunktEXt }

destructor TChunktEXt.Destroy;
begin
  fKeyword := '';
  fText := '';
  inherited;
end;

end.
