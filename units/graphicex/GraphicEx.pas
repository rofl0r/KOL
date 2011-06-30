unit GraphicEx;

// (c) Copyright 1999, 2000  Dipl. Ing. Mike Lischke (public@lischke-online.de). All rights reserved.
//
// This package is freeware for non-commercial use only.
// Contact author for licenses (shareware@lischke-online.de) and see License.txt which comes with the package.
//
// GraphicEx -
//   This unit is an addendum to Graphics.pas, in order to enable your application
//   to import many common graphic files.
//
// See help file for a description of supported image types. Additionally, there is a resample routine
// (Stretch) based on code from Anders Melander (http://www.melander.dk/delphi/resampler/index.html)
// which has been optimized quite a lot to work faster and bug fixed.
//
// version - 9.9
//
// 03-SEP-2000 ml:
//   EPS with alpha channel, workaround for TIFs with wrong alpha channel indication,
//   workaround for bad packbits compressed (TIF) images
// 28-AUG-2000 ml:
//   small bugfixes
// 27-AUG-2000 ml:
//   changed all FreeMemory(P) calls back to ... if Assigned(P) then FreeMem(P); ...
// 24-AUG-2000 ml:
//   small bug in LZ77 decoder removed
// 18-AUG-2000 ml:
//   TIF deflate decoding scheme
// 15-AUG-2000 ml:
//   workaround for TIF images without compression, but prediction scheme set (which is not really used in this case)
// 12-AUG-2000 ml:
//   small changes 
//
// For older history please look into the help file.
//
// Note: The library provides usually only load support for the listed image formats but will perhaps be enhanced
//       in the future to save those types too. It can be compiled with Delphi 4 or newer versions.
//
//
// (c) Copyright 1999, 2000  Dipl. Ing. Mike Lischke (public@lischke-online.de). All rights reserved.
//
// This package is freeware for non-commercial use only!
// Contact author for licenses (shareware@lischke-online.de) and see License.txt which comes with the package.

interface

uses Windows, Kol, Err, GraphicCompression, GraphicColor, Errors;

type
  TCardinalArray = array of cardinal;
  TByteArray = array of byte;
  TFloatArray = array of single;

  TImageOptions = set of (
    ioTiled,       // image consists of tiles not strips (TIF)
    ioBigEndian,   // byte order in values >= words is reversed (TIF, RLA, SGI)
    ioMinIsWhite,  // minimum value in grayscale palette is white not black (TIF)
    ioReversed,    // bit order in bytes is reveresed (TIF)
    ioUseGamma     // gamma correction is used
  );

  // describes the compression used in the image file
  TCompressionType = (
    ctUnknown,     // compression type is unknown
    ctNone,        // no compression at all
    ctRLE,         // run length encoding
    ctPackedBits,  // Macintosh packed bits
    ctLZW,         // Lempel-Zif-Welch
    ctFax3,        // CCITT T.4 (1d), also known as fax group 3
    ctFaxRLE,      // modified Huffman (CCITT T.4 derivative)
    ctFax4,        // CCITT T.6, also known as fax group 4
    ctFaxRLEW,     // CCITT T.4 with word alignment
    ctLZ77,        // Huffman inflate/deflate
    ctJPEG,        // TIF JPEG compression (new version)
    ctOJPEG,       // TIF JPEG compression (old version)
    ctThunderscan, // TIF thunderscan compression
    ctNext,
    ctIT8CTPAD,
    ctIT8LW,
    ctIT8MP,
    ctIT8BL,
    ctPixarFilm,
    ctPixarLog,
    ctDCS,
    ctJBIG,
    ctPCDHuffmann  // PhotoCD Hufman compression
  );

  // properties of a particular image which are set while loading an image or when
  // they are explicitly requested via ReadImageProperties
  PImageProperties = ^TImageProperties;
  TImageProperties = record
    Version: cardinal;                 // TIF, PSP, GIF
    Options: TImageOptions;            // all images
    Width,                             // all images
    Height: cardinal;                  // all images
    ColorScheme: TColorScheme;         // all images
    BitsPerSample,                     // all Images
    SamplesPerPixel,                   // all images
    BitsPerPixel: byte;                // all images
    Compression: TCompressionType;     // all images
    FileGamma: single;                 // RLA, PNG
    XResolution,
    YResolution: single;               // given in dpi (TIF, PCX, PSP)
    Interlaced,                        // GIF, PNG
    HasAlpha: boolean;                 // TIF, PNG

    // informational data, used internally and/or by decoders
    // TIF
    FirstIFD,
    PlanarConfig,                      // most of this data is needed in the JPG decoder
    CurrentRow,
    TileWidth,
    TileLength,
    BytesPerLine: cardinal;
    RowsPerStrip: TCardinalArray;
    YCbCrSubSampling,
    JPEGTables: TByteArray;
    JPEGColorMode,
    JPEGTablesMode: Cardinal;
    CurrentStrip,
    StripCount,
    Predictor: integer;
    // PCD
    Overview: boolean;                 // true if image is an overview image
    Rotate: byte;                      // describes how the image is rotated (aka landscape vs. portrait image)
    ImageCount: word;                  // number of subimages if this is an overview image
    // GIF
    LocalColorTable: boolean;          // image uses an own color palette instead of the global one
    // RLA
    BottomUp: boolean;                 // images is bottom to top
    // PSD
    Channels: byte;                    // up to 24 channels per image
    // PNG
    FilterMode: byte;
  end;

  // This is the general base class for all image types implemented in GraphicEx.
  // It contains some generally used class/data.
  PGraphicExGraphic = ^TGraphicExGraphic;
  TGraphicExGraphic = class
  private
    FColorManager: PColorManager;
    FImageProperties: TImageProperties;
    FBasePosition: cardinal;  // stream start position
    FStream: PStream;         // used for local references of the stream the class is currently loading from
    FBitmap: PBitmap;
  public
    constructor Create;
    destructor Destroy;
    class function CanLoad(const Filename: string): boolean; overload; virtual;
    class function CanLoad(Stream: PStream): boolean; overload; virtual;
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; virtual;
    property Bitmap: PBitmap read FBitmap;
    property ColorManager: PColorManager read FColorManager;
    property ImageProperties: TImageProperties read FImageProperties write FImageProperties;
  end;

  TGraphicExGraphicClass = class of TGraphicExGraphic;

  // *.bw, *.rgb, *.rgba, *.sgi images
  TSGIGraphic = class(TGraphicExGraphic)
  private
    FRowStart,
    FRowSize: TCardinalArray;    // start and length of a line (if compressed)
    FDecoder: TDecoder;          // ...same applies here
    procedure ReadAndDecode(Red,Green,Blue,Alpha: pointer; Row,BPC: cardinal);
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
  end;

  // *.cel, *.pic images
  TAutodeskGraphic = class(TGraphicExGraphic)
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.tif, *.tiff images
  // one entry in a an IFD (image file directory)
  TIFDEntry = packed record
    Tag: word;
    DataType: word;
    DataLength: cardinal;
    Offset: cardinal;
  end;

  TTIFFPalette = array[0..787] of word;

  TTIFFGraphic = class(TGraphicExGraphic)
  private
    FIFD: array of TIFDEntry; // the tags of one image file directory
    FPalette: TTIFFPalette;
    FYCbCrPositioning: cardinal;
    FYCbCrCoefficients: TFloatArray;
    function FindTag(Tag: cardinal; var Index: cardinal): boolean;
    procedure GetValueList(Stream: PStream; Tag: cardinal; var Values: TByteArray); overload;
    procedure GetValueList(Stream: PStream; Tag: cardinal; var Values: TCardinalArray); overload;
    procedure GetValueList(Stream: PStream; Tag: cardinal; var Values: TFloatArray); overload;
    function GetValue(Stream: PStream; Tag: cardinal; Default: single = 0): single; overload;
    function GetValue(Tag: cardinal; Default: cardinal = 0): Cardinal; overload;
    function GetValue(Tag: cardinal; var Size: cardinal; Default: cardinal = 0): cardinal; overload;
    procedure SortIFD;
    procedure SwapIFD;
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  TEPSGraphic = class(TTIFFGraphic)
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.tga; *.vst; *.icb; *.vda; *.win images
  TTGAGraphic = class(TGraphicExGraphic)
   public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.pcx; *.pcc; *.scr images
  // Note: Due to the badly designed format a PCX/SCR file cannot be part in a larger stream because the position of the
  //       color palette as well as the decoding size can only be determined by the size of the image.
  //       Hence the image must be the only one in the stream or the last one.
  TPCXGraphic = class(TGraphicExGraphic)
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.pcd images
  // Note: By default the BASE resolution of a PCD image is loaded with LoadFromStream.
  TPCDGraphic = class(TGraphicExGraphic)
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.ppm, *.pgm, *.pbm images
  TPPMGraphic = class(TGraphicExGraphic)
  private
    FBuffer: array[0..4095] of Char;
    FIndex: integer;
    function CurrentChar: Char;
    function GetChar: Char;
    function GetNumber: cardinal;
    function ReadLine: string;
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.cut (+ *.pal) images
  // Note: Also this format should not be used in a stream unless it is the only image or the last one!
  TCUTGraphic = class(TGraphicExGraphic)
  private
    FPaletteFile: string;
  protected
    procedure LoadPalette;
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
    property PaletteFile: string read FPaletteFile write FPaletteFile;
  end;

  // *.gif images
  TGIFGraphic = class(TGraphicExGraphic)
  private
    function SkipExtensions: byte;
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.rla, *.rpf images
  // implementation based on code from Dipl. Ing. Ingo Neumann (ingo@upstart.de, ingo_n@dialup.nacamar.de)
  TRLAGraphic = class(TGraphicExGraphic)
  private
    procedure SwapHeader(var Header); // start position of the image header in the stream
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.psd, *.pdd images
  TPSDGraphic = class(TGraphicExGraphic)
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.psp images (file version 3 and 4)
  TPSPGraphic = class(TGraphicExGraphic)
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
  end;

  // *.png images
  TChunkType = array[0..3] of Char;

  // This header is followed by a variable number of data bytes, which are followed by the CRC for this data.
  // The actual size of this data is given by field length in the chunk header.
  // CRC is Cardinal (4 byte unsigned integer).
  TPNGChunkHeader = packed record
    Length: cardinal;  // size of data (entire chunk excluding itself, CRC and type)
    ChunkType: TChunkType;
  end;

  TPNGGraphic = class(TGraphicExGraphic)
  private
    FDecoder: TLZ77Decoder;
    FIDATSize: integer;        // remaining bytes in the current IDAT chunk
    FRawBuffer,                // buffer to load raw chunk data and to check CRC
    FCurrentSource: pointer;   // points into FRawBuffer for current position of decoding
    FHeader: TPNGChunkHeader;  // header of the current chunk
    FCurrentCRC: cardinal;     // running CRC for the current chunk
    FSourceBPP: integer;       // bits per pixel used in the file
//    FPalette: HPALETTE;        // used to hold the palette handle until we can set it finally after the pixel format
                               // has been set too (as this destroys the current palette)
    FTransparency: TByteArray; // If the image is indexed then this array might contain alpha values (depends on file)
                               // each entry corresponding to the same palette index as the index in this array.
                               // For grayscale and RGB images FTransparentColor contains the (only) transparent
                               // color.
    FTransparentColor: TColor; // transparent color for gray and RGB
    FBackgroundColor: TColor;  // index or color ref
    procedure ApplyFilter(Filter: byte; Line,PrevLine,Target: PByte; BPP,BytesPerRow: integer);
    function IsChunk(ChunkType: TChunkType): boolean;
    function LoadAndSwapHeader: cardinal;
    procedure LoadBackgroundColor(const Description);
    procedure LoadIDAT(const Description);
    procedure LoadTransparency(const Description);
    procedure ReadDataAndCheckCRC;
    procedure ReadRow(RowBuffer: pointer; BytesPerRow: integer);
    function SetupColorDepth(ColorType,BitDepth: integer): integer;
  public
    class function CanLoad(Stream: PStream): boolean; override;
    procedure LoadFromStream(Stream: PStream);
    function ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean; override;
    property BackgroundColor: TColor read FBackgroundColor;
    property Transparency: TByteArray read FTransparency;
  end;

  // ---------- file format management stuff
  TFormatType = (
    ftAnimation,   // format contains an animation (like GIF or AVI)
    ftLayered,     // format supports multiple layers (like PSP, PSD)
    ftMultiImage,  // format can contain more than one image (like TIF or GIF)
    ftRaster,      // format is contains raster data (this is mainly used)
    ftVector       // format contains vector data (like DXF or PSP file version 4)
  );
  TFormatTypes = set of TFormatType;
  TFilterSortType = (
    fstNone,        // do not sort entries, list them as they are registered
    fstBoth,        // sort entries first by description then by extension
    fstDescription, // sort entries by description only
    fstExtension    // sort entries by extension only
  );
  TFilterOption = (
    foCompact,          // use the compact form in filter strings instead listing each extension on a separate line
    foIncludeAll,       // include the 'All image files' filter string
    foIncludeExtension  // add the extension to the description
  );
  TFilterOptions = set of TFilterOption;

  // resampling support types
  TResamplingFilter = (sfBox, sfTriangle, sfHermite, sfBell, sfSpline, sfLanczos3, sfMitchell);

  // Resampling support routines
  procedure Stretch(NewWidth,NewHeight: cardinal; Filter: TResamplingFilter; Radius: single; Source,Target: PBitmap); overload;
  procedure Stretch(NewWidth,NewHeight: cardinal; Filter: TResamplingFilter; Radius: single; Source: PBitmap); overload;
  function MinMin(A,B: integer): integer;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses KolMath, MZLib;

const
  PNG = 'PNG';
  TIF = 'TIF/TIFF';

type
  // resampling support types
  TRGBInt = record
    R,G,B: integer;
  end;
  PRGBWord = ^TRGBWord;
  TRGBWord = record
    R,G,B: word;
  end;
  PRGBAWord = ^TRGBAWord;
  TRGBAWord = record
    R,G,B,A: word;
  end;
  PBGR = ^TBGR;
  TBGR = packed record
    B,G,R: byte;
  end;
  PBGRA = ^TBGRA;
  TBGRA = packed record
    B,G,R,A: byte;
  end;
  PRGB = ^TRGB;
  TRGB = packed record
    R,G,B: byte;
  end;
  PRGBA = ^TRGBA;
  TRGBA = packed record
    R,G,B,A: byte;
  end;
  PPixelArray = ^TPixelArray;
  TPixelArray = array[0..0] of TBGR;
  TFilterFunction = function(Value: single): single;

  // contributor for a Pixel
  PContributor = ^TContributor;
  TContributor = record
    Weight: integer; // Pixel Weight
    Pixel: integer; // Source Pixel
  end;
  TContributors = array of TContributor;

  // list of source pixels contributing to a destination pixel
  TContributorEntry = record
    N: integer;
    Contributors: TContributors;
  end;

  TContributorList = array of TContributorEntry;

const
  DefaultFilterRadius: array[TResamplingFilter] of single = (0.5,1,1,1.5,2,3,2);

threadvar // globally used cache for current image (speeds up resampling about 10%)
  CurrentLineR: array of integer;
  CurrentLineG: array of integer;
  CurrentLineB: array of integer;

function Rect(ALeft,ATop,ARight,ABottom: integer): TRect;
begin
  with Result do
  begin
    Left:=ALeft;
    Top:=ATop;
    Right:=ARight;
    Bottom:=ABottom;
  end;
end;

function MinMin(A,B: integer): integer;
begin
  if A<B then Result:=A else Result:=B;
end;

function MaxMax(A,B: integer): integer;
begin
  if A>B then Result:=A else Result:=B;
end;

function StrLIComp(const Str1,Str2: PChar; MaxLen: cardinal): integer; assembler;
asm
      PUSH  EDI
      PUSH  ESI
      PUSH  EBX
      MOV   EDI,EDX
      MOV   ESI,EAX
      MOV   EBX,ECX
      XOR   EAX,EAX
      OR    ECX,ECX
      JE    @@4
      REPNE SCASB
      SUB   EBX,ECX
      MOV   ECX,EBX
      MOV   EDI,EDX
      XOR   EDX,EDX
@@1:  REPE  CMPSB
      JE    @@4
      MOV   AL,[ESI-1]
      CMP   AL,'a'
      JB    @@2
      CMP   AL,'z'
      JA    @@2
      SUB   AL,20H
@@2:  MOV   DL,[EDI-1]
      CMP   DL,'a'
      JB    @@3
      CMP   DL,'z'
      JA    @@3
      SUB   DL,20H
@@3:  SUB   EAX,EDX
      JE    @@1
@@4:  POP   EBX
      POP   ESI
      POP   EDI
end;

//----------------------------------------------------------------------------------------------------------------------

procedure GraphicExError(Code: integer); overload;
var E: Exception;
begin
  E:=Exception.Create(e_Custom,ErrorMsg[Code]);
  E.ErrorCode:=Code;
  raise E;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure GraphicExError(Code: integer; Args: array of const); overload;
var E: Exception;
begin
  E:=Exception.CreateFmt(e_Custom,ErrorMsg[Code],Args);
  E.ErrorCode:=Code;
  raise E;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Upsample(Width,Height,ScaledWidth: cardinal; Pixels: PChar);
// Creates a new image that is a integral size greater than an existing one.
var X,Y: cardinal;
    P,Q,R: PChar;
begin
  for Y:=0 to Height-1 do
  begin
    P:=Pixels+(Height-1-Y)*ScaledWidth+(Width-1);
    Q:=Pixels+((Height-1-Y) shl 1)*ScaledWidth+((Width-1) shl 1);
    Q^:=P^;
    (Q+1)^:=P^;
    for X:=1 to Width-1 do
    begin
      Dec(P);
      Dec(Q,2);
      Q^:=P^;
      (Q+1)^:=Char((Word(P^)+Word((P+1)^)+1) shr 1);
    end;
  end;
  for Y:=0 to Height-2 do
  begin
    P:=Pixels+(Y shl 1)*ScaledWidth;
    Q:=P+ScaledWidth;
    R:=Q+ScaledWidth;
    for X:=0 to Width-2 do
    begin
      Q^:=Char((Word(P^)+Word(R^)+1) shr 1);
      (Q+1)^:=Char((Word(P^)+Word((P+2)^)+Word(R^)+Word((R+2)^)+2) shr 2);
      Inc(Q,2);
      Inc(P,2);
      Inc(R,2);
    end;
    Q^:=Char((Word(P^)+Word(R^)+1) shr 1);
    Inc(P);
    Inc(Q);
    Q^:=Char((Word(P^)+Word(R^)+1) shr 1);
  end;
  P:=Pixels+(2*Height-2)*ScaledWidth;
  Q:=Pixels+(2*Height-1)*ScaledWidth;
  Move(P^,Q^,2*Width);
end;

//----------------- filter functions for stretching --------------------------------------------------------------------

function HermiteFilter(Value: single): single;
// f(t) = 2|t|^3 - 3|t|^2 + 1, -1 <= t <= 1
begin
  if Value<0 then Value:=-Value;
  if Value<1 then Result:=(2*Value-3)*Sqr(Value)+1 else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function BoxFilter(Value: Single): Single;
// This filter is also known as 'nearest neighbour' Filter.
begin
  if (Value>-0.5) and (Value<=0.5) then Result:=1 else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function TriangleFilter(Value: single): single;
// aka 'linear' or 'bilinear' filter
begin
  if Value<0 then Value:=-Value;
  if Value<1 then Result:=1-Value else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function BellFilter(Value: single): single;
begin
  if Value<0 then Value:=-Value;
  if Value<0.5 then Result:=0.75-Sqr(Value) else
    if Value<1.5 then
    begin
      Value:=Value-1.5;
      Result:=0.5*Sqr(Value);
    end
    else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function SplineFilter(Value: single): single;
// B-spline filter
var Temp: single;
begin
  if Value<0 then Value:=-Value;
  if Value<1 then
  begin
    Temp:=Sqr(Value);
    Result:=0.5*Temp*Value-Temp+2/3;
  end
  else
    if Value<2 then
    begin
      Value:=2-Value;
      Result:=Sqr(Value)*Value/6;
    end
    else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function Lanczos3Filter(Value: single): single;
  //--------------- local function --------------------------------------------
  function SinC(Value: single): single;
  begin
    if Value<>0 then
    begin
      Value:=Value*PI;
      Result:=Sin(Value)/Value;
    end
    else Result:=1;
  end;
  //---------------------------------------------------------------------------
begin
  if Value<0 then Value:=-Value;
  if Value<3 then Result:=SinC(Value)*SinC(Value/3) else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function MitchellFilter(Value: single): single;
var Temp,B,C: single;
begin
  B:=1/3;
  C:=1/3;
  if Value<0 then Value:=-Value;
  Temp:=Sqr(Value);
  if Value<1 then
  begin
    Value:=(((12-9*B-6*C)*(Value*Temp))+((-18+12*B+6*C)*Temp)+(6-2*B));
    Result:=Value/6;
  end
  else
    if Value<2 then
    begin
      Value:=(((-B-6*C)*(Value*Temp))+((6*B+30*C)*Temp)+((-12*B-48*C)*Value)+(8*B+24*C));
      Result:=Value/6;
    end
    else Result:=0;
end;

//----------------------------------------------------------------------------------------------------------------------

const
  FilterList: array[TResamplingFilter] of TFilterFunction = (
    BoxFilter,TriangleFilter,HermiteFilter,BellFilter,
    SplineFilter,Lanczos3Filter,MitchellFilter);

//----------------------------------------------------------------------------------------------------------------------

procedure FillLineChache(N,Delta: integer; Line: pointer);
var I: integer;
    Run: PBGR;
begin
  Run:=Line;
  for I:=0 to N-1 do
  begin
    CurrentLineR[I]:=Run.R;
    CurrentLineG[I]:=Run.G;
    CurrentLineB[I]:=Run.B;
    Inc(PByte(Run),Delta);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function ApplyContributors(N: integer; Contributors: TContributors): TBGR;
var RGB: TRGBInt;
    J,Total,Weight: integer;
    Pixel: cardinal;
    Contr: ^TContributor;
begin
  RGB.R:=0;
  RGB.G:=0;
  RGB.B:=0;
  Total:=0;
  Contr:=@Contributors[0];
  for J:=0 to N-1 do
  begin
    Weight:=Contr.Weight;
    Inc(Total,Weight);
    Pixel:=Contr.Pixel;
    Inc(RGB.R,CurrentLineR[Pixel]*Weight);
    Inc(RGB.G,CurrentLineG[Pixel]*Weight);
    Inc(RGB.B,CurrentLineB[Pixel]*Weight);
    Inc(Contr);
  end;
  if Total=0 then
  begin
    Result.R:=ClampByte(RGB.R shr 8);
    Result.G:=ClampByte(RGB.G shr 8);
    Result.B:=ClampByte(RGB.B shr 8);
  end
  else
  begin
    Result.R:=ClampByte(RGB.R div Total);
    Result.G:=ClampByte(RGB.G div Total);
    Result.B:=ClampByte(RGB.B div Total);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure DoStretch(Filter: TFilterFunction; Radius: single; Source,Target: PBitmap);
// This is the actual scaling routine. Target must be allocated already with sufficient size. Source must
// contain valid data, Radius must not be 0 and Filter must not be nil.
var ScaleX,ScaleY: single;  // Zoom scale factors
    I,J,K,N: integer;       // Loop variables
    Center: single;         // Filter calculation variables
    Width: single;
    Weight: integer;        // Filter calculation variables
    Left,
    Right: integer;         // Filter calculation variables
    Work: PBitmap;
    ContributorList: TContributorList;
    SourceLine,DestLine: PPixelArray;
    DestPixel: PBGR;
    Delta,DestDelta: integer;
    SourceHeight,SourceWidth,TargetHeight,TargetWidth: integer;
begin
  // shortcut variables
  SourceHeight:=Source.Height;
  SourceWidth:=Source.Width;
  TargetHeight:=Target.Height;
  TargetWidth:=Target.Width;
  if (SourceHeight=0) or (SourceWidth=0) or (TargetHeight=0) or (TargetWidth=0) then Exit;
  // create intermediate image to hold horizontal zoom
  Work:=NewBitmap(0,0);
  try
    Work.PixelFormat:=pf24Bit;
    Work.Height:=SourceHeight;
    Work.Width:=TargetWidth;
    if SourceWidth=1 then ScaleX:=TargetWidth/SourceWidth else ScaleX:=(TargetWidth-1)/(SourceWidth-1);
    if (SourceHeight=1) or (TargetHeight=1) then ScaleY:=TargetHeight/SourceHeight else ScaleY:=(TargetHeight-1)/(SourceHeight-1);
    // pre-calculate filter contributions for a row
    SetLength(ContributorList,TargetWidth);
    // horizontal sub-sampling
    if ScaleX<1 then
    begin
      // scales from bigger to smaller Width
      Width:=Radius/ScaleX;
      for I:=0 to TargetWidth-1 do
      begin
        ContributorList[I].N:=0;
        SetLength(ContributorList[I].Contributors,Trunc(2*Width+1));
        Center:=I/ScaleX;
        Left:=Floor(Center-Width);
        Right:=Ceil(Center+Width);
        for J:=Left to Right do
        begin
          Weight:=Round(Filter((Center-J)*ScaleX)*ScaleX*256);
          if Weight<>0 then
          begin
            if J<0 then N:=-J else
              if J>=SourceWidth then N:=SourceWidth-J+SourceWidth-1 else N:=J;
            K:=ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel:=N;
            ContributorList[I].Contributors[K].Weight:=Weight;
          end;
        end;
      end;
    end
    else
    begin
      // horizontal super-sampling
      // scales from smaller to bigger Width
      for I:=0 to TargetWidth-1 do
      begin
        ContributorList[I].N:=0;
        SetLength(ContributorList[I].Contributors,Trunc(2*Radius+1));
        Center:=I/ScaleX;
        Left:=Floor(Center-Radius);
        Right:=Ceil(Center+Radius);
        for J:=Left to Right do
        begin
          Weight:=Round(Filter(Center-J)*256);
          if Weight<>0 then
          begin
            if J<0 then N:=-J else
             if J>=SourceWidth then N:=SourceWidth-J+SourceWidth-1 else N:=J;
            K:=ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel:=N;
            ContributorList[I].Contributors[K].Weight:=Weight;
          end;
        end;
      end;
    end;
    // now apply filter to sample horizontally from Src to Work
    SetLength(CurrentLineR,SourceWidth);
    SetLength(CurrentLineG,SourceWidth);
    SetLength(CurrentLineB,SourceWidth);
    for K:=0 to SourceHeight-1 do
    begin
      SourceLine:=Source.ScanLine[K];
      FillLineChache(SourceWidth,3,SourceLine);
      DestPixel:=Work.ScanLine[K];
      for I:=0 to TargetWidth-1 do
        with ContributorList[I] do
        begin
          DestPixel^:=ApplyContributors(N,ContributorList[I].Contributors);
          // move on to next column
          Inc(DestPixel);
        end;
    end;
    // free the memory allocated for horizontal filter weights, since we need the stucture again
    for I:=0 to TargetWidth-1 do ContributorList[I].Contributors:=nil;
    ContributorList:=nil;
    // pre-calculate filter contributions for a column
    SetLength(ContributorList,TargetHeight);
    // vertical sub-sampling
    if ScaleY<1 then
    begin
      // scales from bigger to smaller height
      Width:=Radius/ScaleY;
      for I:=0 to TargetHeight-1 do
      begin
        ContributorList[I].N:=0;
        SetLength(ContributorList[I].Contributors,Trunc(2*Width+1));
        Center:=I/ScaleY;
        Left:=Floor(Center-Width);
        Right:=Ceil(Center+Width);
        for J:=Left to Right do
        begin
          Weight:=Round(Filter((Center-J)*ScaleY)*ScaleY*256);
          if Weight<>0 then
          begin
            if J<0 then N:=-J else
              if J>=SourceHeight then N:=SourceHeight-J+SourceHeight-1 else N:=J;
            K:=ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel:=N;
            ContributorList[I].Contributors[K].Weight:=Weight;
          end;
        end;
      end
    end
    else
    begin
      // vertical super-sampling
      // scales from smaller to bigger height
      for I:=0 to TargetHeight-1 do
      begin
        ContributorList[I].N:=0;
        SetLength(ContributorList[I].Contributors,Trunc(2*Radius+1));
        Center:=I/ScaleY;
        Left:=Floor(Center-Radius);
        Right:=Ceil(Center+Radius);
        for J:=Left to Right do
        begin
          Weight:=Round(Filter(Center-J)*256);
          if Weight<>0 then
          begin
            if J<0 then N:=-J else
              if J>=SourceHeight then N:=SourceHeight-J+SourceHeight-1 else N:=J;
            K:=ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel:=N;
            ContributorList[I].Contributors[K].Weight:=Weight;
          end;
        end;
      end;
    end;
    // apply filter to sample vertically from Work to Target
    SetLength(CurrentLineR,SourceHeight);
    SetLength(CurrentLineG,SourceHeight);
    SetLength(CurrentLineB,SourceHeight);
    SourceLine:=Work.ScanLine[0];
    Delta:=Integer(Work.ScanLine[1])-Integer(SourceLine);
    DestLine:=Target.ScanLine[0];
    DestDelta:=Integer(Target.ScanLine[1])-Integer(DestLine);
    for K:=0 to TargetWidth-1 do
    begin
      DestPixel:=Pointer(DestLine);
      FillLineChache(SourceHeight,Delta,SourceLine);
      for I:=0 to TargetHeight-1 do
        with ContributorList[I] do
        begin
          DestPixel^:=ApplyContributors(N,ContributorList[I].Contributors);
          Inc(Integer(DestPixel),DestDelta);
        end;
      Inc(SourceLine);
      Inc(DestLine);
    end;
    // free the memory allocated for vertical filter weights
    for I:=0 to TargetHeight-1 do ContributorList[I].Contributors:=nil;
    // this one is done automatically on exit, but is here for completeness
    ContributorList:=nil;
  finally
    Work.Free;
    CurrentLineR:=nil;
    CurrentLineG:=nil;
    CurrentLineB:=nil;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Stretch(NewWidth,NewHeight: cardinal; Filter: TResamplingFilter; Radius: single; Source,Target: PBitmap);
// Scales the source bitmap to the given size (NewWidth, NewHeight) and stores the Result in Target.
// Filter describes the filter function to be applied and Radius the size of the filter area.
// Is Radius = 0 then the recommended filter area will be used (see DefaultFilterRadius).
begin
  if Radius=0 then Radius:=DefaultFilterRadius[Filter];
  Target.Handle:=0;
  Target.PixelFormat:=pf24Bit;
  Target.Width:=NewWidth;
  Target.Height:=NewHeight;
  Source.PixelFormat:=pf24Bit;
  DoStretch(FilterList[Filter],Radius,Source,Target);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Stretch(NewWidth,NewHeight: cardinal; Filter: TResamplingFilter; Radius: single; Source: PBitmap);
var Target: PBitmap;
begin
  if Radius=0 then Radius:=DefaultFilterRadius[Filter];
  Target:=NewBitmap(0,0);
  try
    Target.PixelFormat:=pf24Bit;
    Target.Width:=NewWidth;
    Target.Height:=NewHeight;
    Source.PixelFormat:=pf24Bit;
    DoStretch(FilterList[Filter],Radius,Source,Target);
    Source.Assign(Target);
  finally
    Target.Free;
  end;
end;

//----------------- support functions for image loading ----------------------------------------------------------------

procedure SwapShort(P: PWord; Count: cardinal);
// swaps high and low byte of 16 bit values
// EAX contains P, EDX contains Count
asm
@@Loop:
        MOV   CX,[EAX]
        XCHG  CH,CL
        MOV   [EAX],CX
        ADD   EAX,2
        DEC   EDX
        JNZ   @@Loop
end;

//----------------------------------------------------------------------------------------------------------------------

procedure SwapLong(P: PInteger; Count: cardinal); overload;
// swaps high and low bytes of 32 bit values
// EAX contains P, EDX contains Count
asm
@@Loop:
        MOV   ECX,[EAX]
        BSWAP ECX
        MOV   [EAX],ECX
        ADD   EAX,4
        DEC   EDX
        JNZ   @@Loop
end;

//----------------------------------------------------------------------------------------------------------------------

function SwapLong(Value: cardinal): cardinal; overload;
// swaps high and low bytes of the given 32 bit value
asm
        BSWAP EAX
end;

//----------------- various conversion routines ------------------------------------------------------------------------

procedure Depredict1(P: pointer; Count: cardinal);
// EAX contains P and EDX Count
asm
@@1:
        MOV   CL,[EAX]
        ADD   [EAX+1],CL
        INC   EAX
        DEC   EDX
        JNZ   @@1
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Depredict3(P: pointer; Count: cardinal);
// EAX contains P and EDX Count
asm
        MOV   ECX,EDX
        SHL   ECX,1
        ADD   ECX,EDX      // 3*Count
@@1:
        MOV   DL,[EAX]
        ADD   [EAX+3],DL
        INC   EAX
        DEC   ECX
        JNZ   @@1
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Depredict4(P: pointer; Count: cardinal);
// EAX contains P and EDX Count
asm
        SHL   EDX,2          // 4*Count
@@1:
        MOV   CL,[EAX]
        ADD   [EAX+4],CL
        INC   EAX
        DEC   EDX
        JNZ   @@1
end;

//----------------- TGraphicExGraphic ----------------------------------------------------------------------------------

constructor TGraphicExGraphic.Create;
begin
  inherited;
  FColorManager:=NewColorManager;
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TGraphicExGraphic.Destroy;
begin
  FColorManager.Free;
  if FBitmap<>nil then FBitmap.Free;
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

class function TGraphicExGraphic.CanLoad(const Filename: string): boolean;
var Stream: PStream;
begin
  Stream:=NewReadFileStream(Filename);
  try
    Result:=CanLoad(Stream);
  finally
    Stream.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

class function TGraphicExGraphic.CanLoad(Stream: PStream): boolean;
// Descentants have to override this method and return True if they consider the data in Stream
// as loadable by the particular class.
// Note: Make sure the stream position is the same on exit as it was on enter!
begin
  Result:=False;
end;

//----------------------------------------------------------------------------------------------------------------------

function TGraphicExGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
// Initializes the internal image properties structure.
// Descentants must override this method to fill in the actual values.
// Result is always False to show there is no image to load.
begin
  Finalize(FImageProperties);
  ZeroMemory(@FImageProperties,sizeof(FImageProperties));
  FImageProperties.FileGamma:=1;
  Result:=False;
end;

//----------------- TAutodeskGraphic -----------------------------------------------------------------------------------

type
  TAutodeskHeader = packed record
    Width,Height,XCoord,YCoord: word;
    Depth,Compression: byte;
    DataSize: cardinal;
    Reserved: array[0..15] of byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TAutodeskGraphic.CanLoad(Stream: PStream): boolean;
var FileID: word;
    Header: TAutodeskHeader;
    LastPosition: cardinal;
begin
  Result:=(Stream.Size-Stream.Position)>(sizeof(FileID)+sizeof(Header));
  if Result then
    begin
      LastPosition:=Stream.Position;
      Stream.Read(FileID,sizeof(FileID));
      Result:=FileID=$9119;
      if Result then
      begin
        // read image dimensions
        Stream.Read(Header,sizeof(Header));
        Result:=(Header.Depth=8) and (Header.Compression=0);
      end;
      Stream.Position:=LastPosition;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TAutodeskGraphic.LoadFromStream(Stream: PStream);
var FileID: word;
    FileHeader: TAutodeskHeader;
    LogPalette: TMaxLogPalette;
    I: integer;
begin
//  FBitmap.Handle:=0;
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
    begin
      // setup bitmap properties
      FBitmap:=NewBitmap(FileHeader.Width,FileHeader.Height);
      FBitmap.PixelFormat:=pf8Bit;
      Stream.Position:=FBasePosition;
      Stream.Read(FileID,2);
      // read image dimensions
      Stream.Read(FileHeader,sizeof(FileHeader));
      // read palette entries and create a palette
      ZeroMemory(@LogPalette,sizeof(LogPalette));
      LogPalette.palVersion:=$300;
      LogPalette.palNumEntries:=256;
      for I:=0 to 255 do
        begin
          Stream.Read(LogPalette.palPalEntry[I],3);
          FBitmap.DIBPalEntries[I]:=RGB(LogPalette.palPalEntry[I].peRed shl 2,LogPalette.palPalEntry[I].peGreen shl 2,LogPalette.palPalEntry[I].peBlue shl 2);
        end;
      // finally read image data
      for I:=0 to FBitmap.Height-1 do Stream.Read(FBitmap.ScanLine[I]^,FileHeader.Width);
    end
  else GraphicExError(1{gesInvalidImage},['Autodesk']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TAutodeskGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var FileID: word;
    Header: TAutodeskHeader;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(FileID,2);
    if FileID=$9119 then
    begin
      // read image dimensions
      Stream.Read(Header,sizeof(Header));
      ColorScheme:=csIndexed;
      Width:=Header.Width;
      Height:=Header.Height;
      BitsPerSample:=8;
      SamplesPerPixel:=1;
      BitsPerPixel:=8;
      Compression:=ctNone;
      Result:=True;
    end;
  end;
end;

//----------------- TSGIGraphic ----------------------------------------------------------------------------------------

const
  SGIMagic                 = 474;
  SGI_COMPRESSION_VERBATIM = 0;
  SGI_COMPRESSION_RLE      = 1;

type
  TSGIHeader = packed record
    Magic: smallint;         // IRIS image file magic number
    Storage,                 // Storage format
    BPC: byte;               // Number of bytes per pixel channel (1 or 2)
    Dimension: word;         // Number of dimensions
                             //   1 - one single scanline (and one channel) of length XSize
                             //   2 - two dimensional (one channel) of size XSize x YSize
                             //   3 - three dimensional (ZSize channels) of size XSize x YSize
    XSize,                   // width of image
    YSize,                   // height of image
    ZSize: word;             // number of channels/planes in image (3 for RGB, 4 for RGBA etc.)
    PixMin,                  // Minimum pixel value
    PixMax: cardinal;        // Maximum pixel value
    Dummy: cardinal;         // ignored
    ImageName: array[0..79] of Char;
    ColorMap: integer;       // Colormap ID
                             //  0 - default, almost all images are stored with this flag
                             //  1 - dithered, only one channel of data (pixels are packed), obsolete
                             //  2 - screen (palette) image, obsolete
                             //  3 - no image data, palette only, not displayable
    Dummy2: array[0..403] of byte; // ignored
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TSGIGraphic.CanLoad(Stream: PStream): boolean;
// returns True if the data in Stream represents a graphic which can be loaded by this class
var Header: TSGIHeader;
    LastPosition: cardinal;
begin
  Result:=(Stream.Size-Stream.Position)>sizeof(TSGIHeader);
  if Result then
    begin
      LastPosition:=Stream.Position;
      Stream.Read(Header,sizeof(Header));
      // one number as check is too unreliable, hence we take some more fields into the check
      Result:=(System.Swap(Header.Magic)=SGIMagic) and (Header.BPC in [1,2]) and (System.Swap(Header.Dimension) in [1..3]);
      Stream.Position:=LastPosition;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSGIGraphic.ReadAndDecode(Red,Green,Blue,Alpha: pointer; Row,BPC: cardinal);
var Count: cardinal;
    RawBuffer: pointer;
begin
  with FImageProperties do
    // compressed image?
    if Assigned(FDecoder) then
    begin
      if Assigned(Red) then
      begin
        FStream.Position:=FBasePosition+FRowStart[Row+0*Height];
        Count:=BPC*FRowSize[Row+0*Height];
        GetMem(RawBuffer,Count);
        try
          FStream.Read(RawBuffer^,Count);
          FDecoder.Decode(RawBuffer,Red,Count,Width);
        finally
          if Assigned(RawBuffer) then FreeMem(RawBuffer);
        end;
      end;
      if Assigned(Green) then
      begin
        FStream.Position:=FBasePosition+FRowStart[Row+1*Height];
        Count:=BPC*FRowSize[Row+1*Height];
        GetMem(RawBuffer,Count);
        try
          FStream.Read(RawBuffer^,Count);
          FDecoder.Decode(RawBuffer,Green,Count,Width);
        finally
          if Assigned(RawBuffer) then FreeMem(RawBuffer);
        end;
      end;
      if Assigned(Blue) then
      begin
        FStream.Position:=FBasePosition+FRowStart[Row+2*Height];
        Count:=BPC*FRowSize[Row+2*Height];
        GetMem(RawBuffer,Count);
        try
          FStream.Read(RawBuffer^,Count);
          FDecoder.Decode(RawBuffer,Blue,Count,Width);
        finally
          if Assigned(RawBuffer) then FreeMem(RawBuffer);
        end;
      end;
      if Assigned(Alpha) then
      begin
        FStream.Position:=FBasePosition+FRowStart[Row+3*Height];
        Count:=BPC*FRowSize[Row+3*Height];
        GetMem(RawBuffer,Count);
        try
          FStream.Read(RawBuffer^,Count);
          FDecoder.Decode(RawBuffer,Alpha,Count,Width);
        finally
          if Assigned(RawBuffer) then FreeMem(RawBuffer);
        end;
      end;
    end
    else
    begin
      if Assigned(Red) then
      begin
        FStream.Position:=FBasePosition+512+(Row*Width);
        FStream.Read(Red^,BPC*Width);
      end;
      if Assigned(Green) then
      begin
        FStream.Position:=FBasePosition+512+(Row*Width)+(Width*Height);
        FStream.Read(Green^,BPC*Width);
      end;
      if Assigned(Blue) then
      begin
        FStream.Position:=FBasePosition+512+(Row*Width)+(2*Width*Height);
        FStream.Read(Blue^,BPC*Width);
      end;
      if Assigned(Alpha) then
      begin
        FStream.Position:=FBasePosition+512+(Row*Width)+(3*Width*Height);
        FStream.Read(Alpha^,BPC*Width);
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSGIGraphic.LoadFromStream(Stream: PStream);
var Y,Count: cardinal;
    RedBuffer,GreenBuffer,BlueBuffer,AlphaBuffer: pointer;
    Header: TSGIHeader;
begin
  // free previous image
//  FBitmap.Handle:=0;
  // keep stream reference and start position for seek operations
  FStream:=Stream;
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition;
      // read header again, we need some additional information
      Stream.Read(Header,sizeof(Header));
      // SGI images are always stored in big endian style
      ColorManager.SourceOptions:=[coNeedByteSwap];
      with Header do ColorMap:=SwapLong(ColorMap);
      if Compression=ctRLE then
      begin
        Count:=Height*SamplesPerPixel;
        SetLength(FRowStart,Count);
        SetLength(FRowSize,Count);
        // read line starts and sizes from stream
        Stream.Read(FRowStart,Count*sizeof(Cardinal));
        SwapLong(@FRowStart[0],Count);
        Stream.Read(FRowSize,Count*sizeof(Cardinal));
        SwapLong(@FRowSize[0],Count);
        FDecoder:=TSGIRLEDecoder.Create(BitsPerSample);
      end
      else
      begin
        FDecoder:=nil;
      end;
      // set pixel format before size to avoid possibly large conversion operation
      ColorManager.SourceBitsPerSample:=BitsPerSample;
      ColorManager.TargetBitsPerSample:=8;
      ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
      ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
      ColorManager.SourceColorScheme:=ColorScheme;
      case ColorScheme of
        csRGBA: ColorManager.TargetColorScheme:=csBGRA;
        csRGB:  ColorManager.TargetColorScheme:=csBGR;
      else ColorManager.TargetColorScheme:=csIndexed;
      end;
      FBitmap:=NewBitmap(Width,Height);
      FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
      RedBuffer:=nil;
      GreenBuffer:=nil;
      BlueBuffer:=nil;
      AlphaBuffer:=nil;
      try
        Count:=(BitsPerPixel div 8)*Width;
        // read lines and put them into the bitmap
        case ColorScheme of
          csRGBA:
            begin
              GetMem(RedBuffer,Count);
              GetMem(GreenBuffer,Count);
              GetMem(BlueBuffer,Count);
              GetMem(AlphaBuffer,Count);
              for Y:=0 to Height-1 do
              begin
                ReadAndDecode(RedBuffer,GreenBuffer,BlueBuffer,AlphaBuffer,Y,Header.BPC);
                ColorManager.ConvertRow([RedBuffer,GreenBuffer,BlueBuffer,AlphaBuffer],FBitmap.ScanLine[Height-Y-1],Width,$FF);
              end;
            end;
          csRGB:
            begin
              GetMem(RedBuffer,Count);
              GetMem(GreenBuffer,Count);
              GetMem(BlueBuffer,Count);
              for Y:=0 to Height-1 do
              begin
                ReadAndDecode(RedBuffer,GreenBuffer,BlueBuffer,nil,Y,Header.BPC);
                ColorManager.ConvertRow([RedBuffer,GreenBuffer,BlueBuffer],FBitmap.ScanLine[Height-Y-1],Width,$FF);
              end;
            end;
        else
          // any other format is interpreted as being 256 gray scales
          ColorManager.CreateGrayscalePalette(FBitmap,False);
          for Y:=0 to Height-1 do
          begin
            ReadAndDecode(FBitmap.ScanLine[Height-Y-1],nil,nil,nil,Y,Header.BPC);
          end;
        end;
      finally
        if Assigned(RedBuffer) then FreeMem(RedBuffer);
        if Assigned(GreenBuffer) then FreeMem(GreenBuffer);
        if Assigned(BlueBuffer) then FreeMem(BlueBuffer);
        if Assigned(AlphaBuffer) then FreeMem(AlphaBuffer);
        FDecoder.Free;
      end;
    end;
  end
  else GraphicExError(1{gesInvalidImage},['SGI, BW or RGB(A)']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TSGIGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: TSGIHeader;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Header,sizeof(Header));
    if System.Swap(Header.Magic)=SGIMagic then
    begin
      Options:=[ioBigEndian];
      BitsPerSample:=Header.BPC*8;
      Width:=System.Swap(Header.XSize);
      Height:=System.Swap(Header.YSize);
      SamplesPerPixel:=System.Swap(Header.ZSize);
      case SamplesPerPixel of
        4: ColorScheme:=csRGBA;
        3: ColorScheme:=csRGB;
      else
        // all other is considered as being 8 bit gray scale
        ColorScheme:=csIndexed;
      end;
      BitsPerPixel:=BitsPerSample*SamplesPerPixel;
      if Header.Storage=SGI_COMPRESSION_RLE then Compression:=ctRLE else Compression:=ctNone;
      Result:=True;
    end;
  end;
end;

//----------------- TTIFFGraphic ---------------------------------------------------------------------------------------

const // TIFF tags
  TIFFTAG_SUBFILETYPE = 254;                     // subfile data descriptor
    FILETYPE_REDUCEDIMAGE = $1;                  // reduced resolution version
    FILETYPE_PAGE = $2;                          // one page of many
    FILETYPE_MASK = $4;                          // transparency mask
  TIFFTAG_OSUBFILETYPE = 255;                    // kind of data in subfile (obsolete by revision 5.0)
    OFILETYPE_IMAGE = 1;                         // full resolution image data
    OFILETYPE_REDUCEDIMAGE = 2;                  // reduced size image data
    OFILETYPE_PAGE = 3;                          // one page of many
  TIFFTAG_IMAGEWIDTH = 256;                      // image width in pixels
  TIFFTAG_IMAGELENGTH = 257;                     // image height in pixels
  TIFFTAG_BITSPERSAMPLE = 258;                   // bits per channel (sample)
  TIFFTAG_COMPRESSION = 259;                     // data compression technique
    COMPRESSION_NONE = 1;                        // dump mode
    COMPRESSION_CCITTRLE = 2;                    // CCITT modified Huffman RLE
    COMPRESSION_CCITTFAX3 = 3;                   // CCITT Group 3 fax encoding
    COMPRESSION_CCITTFAX4 = 4;                   // CCITT Group 4 fax encoding
    COMPRESSION_LZW = 5;                         // Lempel-Ziv & Welch
    COMPRESSION_OJPEG = 6;                       // 6.0 JPEG (old version)
    COMPRESSION_JPEG = 7;                        // JPEG DCT compression (new version)
    COMPRESSION_ADOBE_DEFLATE = 8;               // new id but same as COMPRESSION_DEFLATE
    COMPRESSION_NEXT = 32766;                    // next 2-bit RLE
    COMPRESSION_CCITTRLEW = 32771;               // modified Huffman with word alignment
    COMPRESSION_PACKBITS = 32773;                // Macintosh RLE
    COMPRESSION_THUNDERSCAN = 32809;             // ThunderScan RLE
    // codes 32895-32898 are reserved for ANSI IT8 TIFF/IT <dkelly@etsinc.com)
    COMPRESSION_IT8CTPAD = 32895;                // IT8 CT w/padding
    COMPRESSION_IT8LW = 32896;                   // IT8 Linework RLE
    COMPRESSION_IT8MP = 32897;                   // IT8 Monochrome picture
    COMPRESSION_IT8BL = 32898;                   // IT8 Binary line art
    // compression codes 32908-32911 are reserved for Pixar
    COMPRESSION_PIXARFILM = 32908;               // Pixar companded 10bit LZW
    COMPRESSION_PIXARLOG = 32909;                // Pixar companded 11bit ZIP
    COMPRESSION_DEFLATE = 32946;                 // Deflate compression (LZ77)
    // compression code 32947 is reserved for Oceana Matrix <dev@oceana.com>
    COMPRESSION_DCS = 32947;                     // Kodak DCS encoding
    COMPRESSION_JBIG = 34661;                    // ISO JBIG
  TIFFTAG_PHOTOMETRIC = 262;                     // photometric interpretation
    PHOTOMETRIC_MINISWHITE = 0;                  // min value is white
    PHOTOMETRIC_MINISBLACK = 1;                  // min value is black
    PHOTOMETRIC_RGB = 2;                         // RGB color model
    PHOTOMETRIC_PALETTE = 3;                     // color map indexed
    PHOTOMETRIC_MASK = 4;                        // holdout mask
    PHOTOMETRIC_SEPARATED = 5;                   // color separations
    PHOTOMETRIC_YCBCR = 6;                       // CCIR 601
    PHOTOMETRIC_CIELAB = 8;                      // 1976 CIE L*a*b*
  TIFFTAG_THRESHHOLDING = 263;                   // thresholding used on data (obsolete by revision 5.0)
    THRESHHOLD_BILEVEL = 1;                      // b&w art scan
    THRESHHOLD_HALFTONE = 2;                     // or dithered scan
    THRESHHOLD_ERRORDIFFUSE = 3;                 // usually floyd-steinberg
  TIFFTAG_CELLWIDTH = 264;                       // dithering matrix width (obsolete by revision 5.0)
  TIFFTAG_CELLLENGTH = 265;                      // dithering matrix height (obsolete by revision 5.0)
  TIFFTAG_FILLORDER = 266;                       // data order within a Byte
    FILLORDER_MSB2LSB = 1;                       // most significant -> least
    FILLORDER_LSB2MSB = 2;                       // least significant -> most
  TIFFTAG_DOCUMENTNAME = 269;                    // name of doc. image is from
  TIFFTAG_IMAGEDESCRIPTION = 270;                // info about image
  TIFFTAG_MAKE = 271;                            // scanner manufacturer name
  TIFFTAG_MODEL = 272;                           // scanner model name/number
  TIFFTAG_STRIPOFFSETS = 273;                    // Offsets to data strips
  TIFFTAG_ORIENTATION = 274;                     // image FOrientation (obsolete by revision 5.0)
    ORIENTATION_TOPLEFT = 1;                     // row 0 top, col 0 lhs
    ORIENTATION_TOPRIGHT = 2;                    // row 0 top, col 0 rhs
    ORIENTATION_BOTRIGHT = 3;                    // row 0 bottom, col 0 rhs
    ORIENTATION_BOTLEFT = 4;                     // row 0 bottom, col 0 lhs
    ORIENTATION_LEFTTOP = 5;                     // row 0 lhs, col 0 top
    ORIENTATION_RIGHTTOP = 6;                    // row 0 rhs, col 0 top
    ORIENTATION_RIGHTBOT = 7;                    // row 0 rhs, col 0 bottom
    ORIENTATION_LEFTBOT = 8;                     // row 0 lhs, col 0 bottom
  TIFFTAG_SAMPLESPERPIXEL = 277;                 // samples per pixel
  TIFFTAG_ROWSPERSTRIP = 278;                    // rows per strip of data
  TIFFTAG_STRIPBYTECOUNTS = 279;                 // bytes counts for strips
  TIFFTAG_MINSAMPLEVALUE = 280;                  // minimum sample value (obsolete by revision 5.0)
  TIFFTAG_MAXSAMPLEVALUE = 281;                  // maximum sample value (obsolete by revision 5.0)
  TIFFTAG_XRESOLUTION = 282;                     // pixels/resolution in x
  TIFFTAG_YRESOLUTION = 283;                     // pixels/resolution in y
  TIFFTAG_PLANARCONFIG = 284;                    // storage organization
    PLANARCONFIG_CONTIG = 1;                     // single image plane
    PLANARCONFIG_SEPARATE = 2;                   // separate planes of data
  TIFFTAG_PAGENAME = 285;                        // page name image is from
  TIFFTAG_XPOSITION = 286;                       // x page offset of image lhs
  TIFFTAG_YPOSITION = 287;                       // y page offset of image lhs
  TIFFTAG_FREEOFFSETS = 288;                     // byte offset to free block (obsolete by revision 5.0)
  TIFFTAG_FREEBYTECOUNTS = 289;                  // sizes of free blocks (obsolete by revision 5.0)
  TIFFTAG_GRAYRESPONSEUNIT = 290;                // gray scale curve accuracy
    GRAYRESPONSEUNIT_10S = 1;                    // tenths of a unit
    GRAYRESPONSEUNIT_100S = 2;                   // hundredths of a unit
    GRAYRESPONSEUNIT_1000S = 3;                  // thousandths of a unit
    GRAYRESPONSEUNIT_10000S = 4;                 // ten-thousandths of a unit
    GRAYRESPONSEUNIT_100000S = 5;                // hundred-thousandths
  TIFFTAG_GRAYRESPONSECURVE = 291;               // gray scale response curve
  TIFFTAG_GROUP3OPTIONS = 292;                   // 32 flag bits
    GROUP3OPT_2DENCODING = $1;                   // 2-dimensional coding
    GROUP3OPT_UNCOMPRESSED = $2;                 // data not compressed
    GROUP3OPT_FILLBITS = $4;                     // fill to byte boundary
  TIFFTAG_GROUP4OPTIONS = 293;                   // 32 flag bits
    GROUP4OPT_UNCOMPRESSED = $2;                 // data not compressed
  TIFFTAG_RESOLUTIONUNIT = 296;                  // units of resolutions
    RESUNIT_NONE = 1;                            // no meaningful units
    RESUNIT_INCH = 2;                            // english
    RESUNIT_CENTIMETER = 3;                      // metric
  TIFFTAG_PAGENUMBER = 297;                      // page numbers of multi-page
  TIFFTAG_COLORRESPONSEUNIT = 300;               // color curve accuracy
    COLORRESPONSEUNIT_10S = 1;                   // tenths of a unit
    COLORRESPONSEUNIT_100S = 2;                  // hundredths of a unit
    COLORRESPONSEUNIT_1000S = 3;                 // thousandths of a unit
    COLORRESPONSEUNIT_10000S = 4;                // ten-thousandths of a unit
    COLORRESPONSEUNIT_100000S = 5;               // hundred-thousandths
  TIFFTAG_TRANSFERFUNCTION = 301;                // colorimetry info
  TIFFTAG_SOFTWARE = 305;                        // name & release
  TIFFTAG_DATETIME = 306;                        // creation date and time
  TIFFTAG_ARTIST = 315;                          // creator of image
  TIFFTAG_HOSTCOMPUTER = 316;                    // machine where created
  TIFFTAG_PREDICTOR = 317;                       // prediction scheme w/ LZW
    PREDICTION_NONE = 1;                         // no prediction scheme used before coding
    PREDICTION_HORZ_DIFFERENCING = 2;            // horizontal differencing prediction scheme used
  TIFFTAG_WHITEPOINT = 318;                      // image white point
  TIFFTAG_PRIMARYCHROMATICITIES = 319;           // primary chromaticities
  TIFFTAG_COLORMAP = 320;                        // RGB map for pallette image
  TIFFTAG_HALFTONEHINTS = 321;                   // highlight+shadow info
  TIFFTAG_TILEWIDTH = 322;                       // rows/data tile
  TIFFTAG_TILELENGTH = 323;                      // cols/data tile
  TIFFTAG_TILEOFFSETS = 324;                     // offsets to data tiles
  TIFFTAG_TILEBYTECOUNTS = 325;                  // Byte counts for tiles
  TIFFTAG_BADFAXLINES = 326;                     // lines w/ wrong pixel count
  TIFFTAG_CLEANFAXDATA = 327;                    // regenerated line info
    CLEANFAXDATA_CLEAN = 0;                      // no errors detected
    CLEANFAXDATA_REGENERATED = 1;                // receiver regenerated lines
    CLEANFAXDATA_UNCLEAN = 2;                    // uncorrected errors exist
  TIFFTAG_CONSECUTIVEBADFAXLINES = 328;          // max consecutive bad lines
  TIFFTAG_SUBIFD = 330;                          // subimage descriptors
  TIFFTAG_INKSET = 332;                          // inks in separated image
    INKSET_CMYK = 1;                             // cyan-magenta-yellow-black
  TIFFTAG_INKNAMES = 333;                        // ascii names of inks
  TIFFTAG_DOTRANGE = 336;                        // 0% and 100% dot codes
  TIFFTAG_TARGETPRINTER = 337;                   // separation target
  TIFFTAG_EXTRASAMPLES = 338;                    // info about extra samples
    EXTRASAMPLE_UNSPECIFIED = 0;                 // unspecified data
    EXTRASAMPLE_ASSOCALPHA = 1;                  // associated alpha data
    EXTRASAMPLE_UNASSALPHA = 2;                  // unassociated alpha data
  TIFFTAG_SAMPLEFORMAT = 339;                    // data sample format
    SAMPLEFORMAT_UINT = 1;                       // unsigned integer data
    SAMPLEFORMAT_INT = 2;                        // signed integer data
    SAMPLEFORMAT_IEEEFP = 3;                     // IEEE floating point data
    SAMPLEFORMAT_VOID = 4;                       // untyped data
  TIFFTAG_SMINSAMPLEVALUE = 340;                 // variable MinSampleValue
  TIFFTAG_SMAXSAMPLEVALUE = 341;                 // variable MaxSampleValue
  TIFFTAG_JPEGTABLES = 347;                      // JPEG table stream

  // Tags 512-521 are obsoleted by Technical Note #2 which specifies a revised JPEG-in-TIFF scheme.

  TIFFTAG_JPEGPROC = 512;                        // JPEG processing algorithm
    JPEGPROC_BASELINE = 1;                       // baseline sequential
    JPEGPROC_LOSSLESS = 14;                      // Huffman coded lossless
  TIFFTAG_JPEGIFOFFSET = 513;                    // Pointer to SOI marker
  TIFFTAG_JPEGIFBYTECOUNT = 514;                 // JFIF stream length
  TIFFTAG_JPEGRESTARTINTERVAL = 515;             // restart interval length
  TIFFTAG_JPEGLOSSLESSPREDICTORS = 517;          // lossless proc predictor
  TIFFTAG_JPEGPOINTTRANSFORM = 518;              // lossless point transform
  TIFFTAG_JPEGQTABLES = 519;                     // Q matrice offsets
  TIFFTAG_JPEGDCTABLES = 520;                    // DCT table offsets
  TIFFTAG_JPEGACTABLES = 521;                    // AC coefficient offsets
  TIFFTAG_YCBCRCOEFFICIENTS = 529;               // RGB -> YCbCr transform
  TIFFTAG_YCBCRSUBSAMPLING = 530;                // YCbCr subsampling factors
  TIFFTAG_YCBCRPOSITIONING = 531;                // subsample positioning
    YCBCRPOSITION_CENTERED = 1;                  // as in PostScript Level 2
    YCBCRPOSITION_COSITED = 2;                   // as in CCIR 601-1
  TIFFTAG_REFERENCEBLACKWHITE = 532;             // colorimetry info
  // tags 32952-32956 are private tags registered to Island Graphics
  TIFFTAG_REFPTS = 32953;                        // image reference points
  TIFFTAG_REGIONTACKPOINT = 32954;               // region-xform tack point
  TIFFTAG_REGIONWARPCORNERS = 32955;             // warp quadrilateral
  TIFFTAG_REGIONAFFINE = 32956;                  // affine transformation mat
  // tags 32995-32999 are private tags registered to SGI
  TIFFTAG_MATTEING = 32995;                      // use ExtraSamples
  TIFFTAG_DATATYPE = 32996;                      // use SampleFormat
  TIFFTAG_IMAGEDEPTH = 32997;                    // z depth of image
  TIFFTAG_TILEDEPTH = 32998;                     // z depth/data tile

  // tags 33300-33309 are private tags registered to Pixar
  //
  // TIFFTAG_PIXAR_IMAGEFULLWIDTH and TIFFTAG_PIXAR_IMAGEFULLLENGTH
  // are set when an image has been cropped out of a larger image.
  // They reflect the size of the original uncropped image.
  // The TIFFTAG_XPOSITION and TIFFTAG_YPOSITION can be used
  // to determine the position of the smaller image in the larger one.

  TIFFTAG_PIXAR_IMAGEFULLWIDTH = 33300;          // full image size in x
  TIFFTAG_PIXAR_IMAGEFULLLENGTH = 33301;         // full image size in y
  // tag 33405 is a private tag registered to Eastman Kodak
  TIFFTAG_WRITERSERIALNUMBER = 33405;            // device serial number
  // tag 33432 is listed in the 6.0 spec w/ unknown ownership
  TIFFTAG_COPYRIGHT = 33432;                     // copyright string
  // 34016-34029 are reserved for ANSI IT8 TIFF/IT <dkelly@etsinc.com)
  TIFFTAG_IT8SITE = 34016;                       // site name
  TIFFTAG_IT8COLORSEQUENCE = 34017;              // color seq. [RGB,CMYK,etc]
  TIFFTAG_IT8HEADER = 34018;                     // DDES Header
  TIFFTAG_IT8RASTERPADDING = 34019;              // raster scanline padding
  TIFFTAG_IT8BITSPERRUNLENGTH = 34020;           // # of bits in short run
  TIFFTAG_IT8BITSPEREXTENDEDRUNLENGTH = 34021;   // # of bits in long run
  TIFFTAG_IT8COLORTABLE = 34022;                 // LW colortable
  TIFFTAG_IT8IMAGECOLORINDICATOR = 34023;        // BP/BL image color switch
  TIFFTAG_IT8BKGCOLORINDICATOR = 34024;          // BP/BL bg color switch
  TIFFTAG_IT8IMAGECOLORVALUE = 34025;            // BP/BL image color value
  TIFFTAG_IT8BKGCOLORVALUE = 34026;              // BP/BL bg color value
  TIFFTAG_IT8PIXELINTENSITYRANGE = 34027;        // MP pixel intensity value
  TIFFTAG_IT8TRANSPARENCYINDICATOR = 34028;      // HC transparency switch
  TIFFTAG_IT8COLORCHARACTERIZATION = 34029;      // color character. table
  // tags 34232-34236 are private tags registered to Texas Instruments
  TIFFTAG_FRAMECOUNT = 34232;                    // Sequence Frame Count
  // tag 34750 is a private tag registered to Pixel Magic
  TIFFTAG_JBIGOPTIONS = 34750;                   // JBIG options
  // tags 34908-34914 are private tags registered to SGI
  TIFFTAG_FAXRECVPARAMS = 34908;                 // encoded class 2 ses. parms
  TIFFTAG_FAXSUBADDRESS = 34909;                 // received SubAddr string
  TIFFTAG_FAXRECVTIME = 34910;                   // receive time (secs)
  // tag 65535 is an undefined tag used by Eastman Kodak
  TIFFTAG_DCSHUESHIFTVALUES = 65535;             // hue shift correction data

  // The following are 'pseudo tags' that can be used to control codec-specific functionality.
  // These tags are not written to file.  Note that these values start at $FFFF + 1 so that they'll
  // never collide with Aldus-assigned tags.

  TIFFTAG_FAXMODE = 65536;                       // Group 3/4 format control
    FAXMODE_CLASSIC = $0000;                     // default, include RTC
    FAXMODE_NORTC = $0001;                       // no RTC at end of data
    FAXMODE_NOEOL = $0002;                       // no EOL code at end of row
    FAXMODE_BYTEALIGN = $0004;                   // Byte align row
    FAXMODE_WORDALIGN = $0008;                   // Word align row
    FAXMODE_CLASSF = FAXMODE_NORTC;              // TIFF class F
  TIFFTAG_JPEGQUALITY = 65537;                   // compression quality level
  // Note: quality level is on the IJG 0-100 scale.  Default value is 75
  TIFFTAG_JPEGCOLORMODE = 65538;                 // Auto RGB<=>YCbCr convert?
    JPEGCOLORMODE_RAW = $0000;                   // no conversion (default)
    JPEGCOLORMODE_RGB = $0001;                   // do auto conversion
  TIFFTAG_JPEGTABLESMODE = 65539;                // What to put in JPEGTables
    JPEGTABLESMODE_QUANT = $0001;                // include quantization tbls
    JPEGTABLESMODE_HUFF = $0002;                 // include Huffman tbls
  // Note: default is JPEGTABLESMODE_QUANT or JPEGTABLESMODE_HUFF
  TIFFTAG_FAXFILLFUNC = 65540;                   // G3/G4 fill function
  TIFFTAG_PIXARLOGDATAFMT = 65549;               // PixarLogCodec I/O data sz
    PIXARLOGDATAFMT_8BIT = 0;                    // regular u_char samples
    PIXARLOGDATAFMT_8BITABGR = 1;                // ABGR-order u_chars
    PIXARLOGDATAFMT_11BITLOG = 2;                // 11-bit log-encoded (raw)
    PIXARLOGDATAFMT_12BITPICIO = 3;              // as per PICIO (1.0==2048)
    PIXARLOGDATAFMT_16BIT = 4;                   // signed short samples
    PIXARLOGDATAFMT_FLOAT = 5;                   // IEEE float samples
  // 65550-65556 are allocated to Oceana Matrix <dev@oceana.com>
  TIFFTAG_DCSIMAGERTYPE = 65550;                 // imager model & filter
    DCSIMAGERMODEL_M3 = 0;                       // M3 chip (1280 x 1024)
    DCSIMAGERMODEL_M5 = 1;                       // M5 chip (1536 x 1024)
    DCSIMAGERMODEL_M6 = 2;                       // M6 chip (3072 x 2048)
    DCSIMAGERFILTER_IR = 0;                      // infrared filter
    DCSIMAGERFILTER_MONO = 1;                    // monochrome filter
    DCSIMAGERFILTER_CFA = 2;                     // color filter array
    DCSIMAGERFILTER_OTHER = 3;                   // other filter
  TIFFTAG_DCSINTERPMODE = 65551;                 // interpolation mode
    DCSINTERPMODE_NORMAL = $0;                   // whole image, default
    DCSINTERPMODE_PREVIEW = $1;                  // preview of image (384x256)
  TIFFTAG_DCSBALANCEARRAY = 65552;               // color balance values
  TIFFTAG_DCSCORRECTMATRIX = 65553;              // color correction values
  TIFFTAG_DCSGAMMA = 65554;                      // gamma value
  TIFFTAG_DCSTOESHOULDERPTS = 65555;             // toe & shoulder points
  TIFFTAG_DCSCALIBRATIONFD = 65556;              // calibration file desc
  // Note: quality level is on the ZLIB 1-9 scale. Default value is -1
  TIFFTAG_ZIPQUALITY = 65557;                    // compression quality level
  TIFFTAG_PIXARLOGQUALITY = 65558;               // PixarLog uses same scale

  // TIFF data types
  TIFF_NOTYPE = 0;                               // placeholder
  TIFF_BYTE = 1;                                 // 8-bit unsigned integer
  TIFF_ASCII = 2;                                // 8-bit bytes w/ last byte null
  TIFF_SHORT = 3;                                // 16-bit unsigned integer
  TIFF_LONG = 4;                                 // 32-bit unsigned integer
  TIFF_RATIONAL = 5;                             // 64-bit unsigned fraction
  TIFF_SBYTE = 6;                                // 8-bit signed integer
  TIFF_UNDEFINED = 7;                            // 8-bit untyped data
  TIFF_SSHORT = 8;                               // 16-bit signed integer
  TIFF_SLONG = 9;                                // 32-bit signed integer
  TIFF_SRATIONAL = 10;                           // 64-bit signed fraction
  TIFF_FLOAT = 11;                               // 32-bit IEEE floating point
  TIFF_DOUBLE = 12;                              // 64-bit IEEE floating point

  TIFF_BIGENDIAN = $4D4D;
  TIFF_LITTLEENDIAN = $4949;

  TIFF_VERSION = 42;

type
  TTIFFHeader = packed record
    ByteOrder: word;
    Version: word;
    FirstIFD: cardinal;
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TTIFFGraphic.CanLoad(Stream: PStream): boolean;
var Header: TTIFFHeader;
    LastPosition: Cardinal;
begin
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      LastPosition:=Stream.Position;
      Stream.Read(Header,sizeof(Header));
      Result:=(Header.ByteOrder=TIFF_BIGENDIAN) or (Header.ByteOrder=TIFF_LITTLEENDIAN);
      if Result then
      begin
        if Header.ByteOrder=TIFF_BIGENDIAN then
        begin
          Header.Version:=System.Swap(Header.Version);
          Header.FirstIFD:=SwapLong(Header.FirstIFD);
        end;
        Result:=(Header.Version=TIFF_VERSION) and (Integer(Header.FirstIFD)<(Stream.Size-Integer(LastPosition)));
      end;
      Stream.Position:=LastPosition;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.FindTag(Tag: cardinal; var Index: cardinal): boolean;
// looks through the currently loaded IFD for the entry indicated by Tag;
// returns True and the index of the entry in Index if the entry is there
// otherwise the result is False and Index undefined
// Note: The IFD is sorted so we can use a binary search here.
var L,H,I,C: integer;
begin
  Result:=False;
  L:=0;
  H:=High(FIFD);
  while L<=H do
  begin
    I:=(L+H) shr 1;
    C:=Integer(FIFD[I].Tag)-Integer(Tag);
    if C<0 then L:=I+1 else
    begin
      H:=I-1;
      if C=0 then
      begin
        Result:=True;
        L:=I;
      end;
    end;
  end;
  Index:=L;
end;

//----------------------------------------------------------------------------------------------------------------------

const
  DataTypeToSize: array[TIFF_NOTYPE..TIFF_SLONG] of byte = (0,1,1,2,4,8,1,1,2,4);

procedure TTIFFGraphic.GetValueList(Stream: PStream; Tag: cardinal; var Values: TByteArray);
// returns the values of the IFD entry indicated by Tag
var Index,Value,Shift: cardinal;
    I: Integer;
begin
  if FindTag(Tag,Index) and (FIFD[Index].DataLength>0) then
  begin
    // prepare value list
    SetLength(Values,FIFD[Index].DataLength);
    // determine whether the data fits into 4 bytes
    Value:=DataTypeToSize[FIFD[Index].DataType]*FIFD[Index].DataLength;
    // data fits into one cardinal -> extract it
    if Value<=4 then
    begin
      Shift:=DataTypeToSize[FIFD[Index].DataType]*8;
      Value:=FIFD[Index].Offset;
      for I:=0 to FIFD[Index].DataLength-1 do
      begin
        case FIFD[Index].DataType of
          TIFF_BYTE:
            Values[I]:=Byte(Value);
          TIFF_SHORT,
          TIFF_SSHORT:
            // no byte swap needed here because values in the IFD are already swapped
            // (if necessary at all)
            Values[I]:=Word(Value);
          TIFF_LONG,
          TIFF_SLONG:
            Values[I]:=Value;
        end;
        Value:=Value shr Shift;
      end;
    end
    else
    begin
      // data of this tag does not fit into one 32 bits value
      Stream.Position:=FBasePosition+FIFD[Index].Offset;
      // bytes sized data can be read directly instead of looping through the array
      if FIFD[Index].DataType in [TIFF_BYTE,TIFF_ASCII,TIFF_SBYTE,TIFF_UNDEFINED] then Stream.Read(Values[0],Value) else
      begin
        for I:=0 to High(Values) do
        begin
          Stream.Read(Value,DataTypeToSize[FIFD[Index].DataType]);
          case FIFD[Index].DataType of
            TIFF_BYTE:
              Value:=Byte(Value);
            TIFF_SHORT,
            TIFF_SSHORT:
              begin
                if ioBigEndian in FImageProperties.Options then Value:=System.Swap(Word(Value)) else Value:=Word(Value);
              end;
            TIFF_LONG,
            TIFF_SLONG:
              if ioBigEndian in FImageProperties.Options then Value:=SwapLong(Value);
          end;
          Values[I]:=Value;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.GetValueList(Stream: PStream; Tag: cardinal; var Values: TCardinalArray);
// returns the values of the IFD entry indicated by Tag
var Index,Value,Shift: cardinal;
    I: integer;
begin
//  Values:=nil;
  if FindTag(Tag,Index) and (FIFD[Index].DataLength>0) then
  begin
    // prepare value list
    SetLength(Values,FIFD[Index].DataLength);
    // determine whether the data fits into 4 bytes
    Value:=DataTypeToSize[FIFD[Index].DataType]*FIFD[Index].DataLength;
    // data fits into one cardinal -> extract it
    if Value<=4 then
    begin
      Shift:=DataTypeToSize[FIFD[Index].DataType]*8;
      Value:=FIFD[Index].Offset;
      for I:=0 to FIFD[Index].DataLength-1 do
      begin
        case FIFD[Index].DataType of
          TIFF_BYTE,
          TIFF_ASCII,
          TIFF_SBYTE,
          TIFF_UNDEFINED: Values[I]:=Byte(Value);
          TIFF_SHORT,
          TIFF_SSHORT:
            // no byte swap needed here because values in the IFD are already swapped
            // (if necessary at all)
            Values[I]:=Word(Value);
          TIFF_LONG,
          TIFF_SLONG:
            Values[I]:=Value;
        end;
        Value:=Value shr Shift;
      end;
    end
    else
    begin
      // data of this tag does not fit into one 32 bits value
      Stream.Position:=FBasePosition+FIFD[Index].Offset;
      // even bytes sized data must be read by the loop as it is expanded to cardinals
      for I:=0 to High(Values) do
      begin
        Stream.Read(Value,DataTypeToSize[FIFD[Index].DataType]);
        case FIFD[Index].DataType of
          TIFF_BYTE:
            Value:=Byte(Value);
          TIFF_SHORT,
          TIFF_SSHORT:
            begin
              if ioBigEndian in FImageProperties.Options then Value:=System.Swap(Word(Value)) else Value:=Word(Value);
            end;
          TIFF_LONG,
          TIFF_SLONG:
            if ioBigEndian in FImageProperties.Options then Value:=SwapLong(Value);
        end;
        Values[I]:=Value;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.GetValueList(Stream: PStream; Tag: Cardinal; var Values: TFloatArray);
// returns the values of the IFD entry indicated by Tag
var Index,Shift,IntValue: cardinal;
    Value: single;
    I: integer;
    IntNominator,IntDenominator,FloatNominator,FloatDenominator: cardinal;
begin
//  Values:=nil;
  if FindTag(Tag,Index) and (FIFD[Index].DataLength>0) then
  begin
    // prepare value list
    SetLength(Values,FIFD[Index].DataLength);
    // determine whether the data fits into 4 bytes
    Value:=DataTypeToSize[FIFD[Index].DataType]*FIFD[Index].DataLength;
    // data fits into one cardinal -> extract it
    if Value<=4 then
    begin
      Shift:=DataTypeToSize[FIFD[Index].DataType]*8;
      IntValue:=FIFD[Index].Offset;
      for I:=0 to FIFD[Index].DataLength-1 do
      begin
        case FIFD[Index].DataType of
          TIFF_BYTE,
          TIFF_ASCII,
          TIFF_SBYTE,
          TIFF_UNDEFINED:
            Values[I]:=Byte(IntValue);
          TIFF_SHORT,
          TIFF_SSHORT:
            // no byte swap needed here because values in the IFD are already swapped
            // (if necessary at all)
            Values[I]:=Word(IntValue);
          TIFF_LONG,
          TIFF_SLONG:
            Values[I]:=IntValue;
        end;
        IntValue:=IntValue shr Shift;
      end;
    end
    else
    begin
      // data of this tag does not fit into one 32 bits value
      Stream.Position:=FBasePosition+FIFD[Index].Offset;
      // even bytes sized data must be read by the loop as it is expanded to Single
      for I:=0 to High(Values) do
      begin
        case FIFD[Index].DataType of
          TIFF_BYTE:
            begin
              Stream.Read(IntValue,DataTypeToSize[FIFD[Index].DataType]);
              Value:=Byte(IntValue);
            end;
          TIFF_SHORT,
          TIFF_SSHORT:
            begin
              Stream.Read(IntValue,DataTypeToSize[FIFD[Index].DataType]);
              if ioBigEndian in FImageProperties.Options then Value:=System.Swap(Word(IntValue)) else Value:=Word(IntValue);
            end;
          TIFF_LONG,
          TIFF_SLONG:
            begin
              Stream.Read(IntValue,DataTypeToSize[FIFD[Index].DataType]);
              if ioBigEndian in FImageProperties.Options then Value:=SwapLong(IntValue);
            end;
          TIFF_RATIONAL,
          TIFF_SRATIONAL:
            begin
              Stream.Read(FloatNominator,sizeof(FloatNominator));
              Stream.Read(FloatDenominator,sizeof(FloatDenominator));
              if ioBigEndian in FImageProperties.Options then
              begin
                FloatNominator:=SwapLong(Cardinal(FloatNominator));
                FloatDenominator:=SwapLong(Cardinal(FloatDenominator));
              end;
              Value:=FloatNominator/FloatDenominator;
            end;
          TIFF_FLOAT:
            begin
              Stream.Read(IntNominator,sizeof(IntNominator));
              Stream.Read(IntDenominator,sizeof(IntDenominator));
              if ioBigEndian in FImageProperties.Options then
              begin
                IntNominator:=SwapLong(IntNominator);
                IntDenominator:=SwapLong(IntDenominator);
              end;
              Value:=IntNominator/IntDenominator;
            end;
          end;
        Values[I]:=Value;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.GetValue(Stream: PStream; Tag: cardinal; Default: single = 0): single;
// returns the value of the IFD entry indicated by Tag or the default value if the entry is not there
var Index: cardinal;
    IntNominator,IntDenominator: cardinal;
    FloatNominator,FloatDenominator: cardinal;
begin
  Result:=Default;
  if FindTag(Tag,Index) then
  begin
    // if the data length is>1 then Offset is a real offset into the stream,
    // otherwise it is the value itself and must be shortend depending on the data type
    if FIFD[Index].DataLength=1 then
    begin
      case FIFD[Index].DataType of
        TIFF_BYTE:
          Result:=Byte(FIFD[Index].Offset);
        TIFF_SHORT,
        TIFF_SSHORT:
          Result:=Word(FIFD[Index].Offset);
        TIFF_LONG,
        TIFF_SLONG: // nothing to do
          Result:=FIFD[Index].Offset;
        TIFF_RATIONAL,
        TIFF_SRATIONAL:
          begin
            Stream.Position:=FBasePosition+FIFD[Index].Offset;
            Stream.Read(FloatNominator,sizeof(FloatNominator));
            Stream.Read(FloatDenominator,sizeof(FloatDenominator));
            if ioBigEndian in FImageProperties.Options then
            begin
              FloatNominator:=SwapLong(Cardinal(FloatNominator));
              FloatDenominator:=SwapLong(Cardinal(FloatDenominator));
            end;
            Result:=FloatNominator/FloatDenominator;
          end;
        TIFF_FLOAT:
          begin
            Stream.Position:=FBasePosition+FIFD[Index].Offset;
            Stream.Read(IntNominator,sizeof(IntNominator));
            Stream.Read(IntDenominator,sizeof(IntDenominator));
            if ioBigEndian in FImageProperties.Options then
            begin
              IntNominator:=SwapLong(IntNominator);
              IntDenominator:=SwapLong(IntDenominator);
            end;
            Result:=IntNominator/IntDenominator;
          end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.GetValue(Tag: cardinal; Default: cardinal=0): cardinal;
// returns the value of the IFD entry indicated by Tag or the default value if the entry is not there
var Index: cardinal;
begin
  if not FindTag(Tag, Index) then Result:=Default else
  begin
    Result:=FIFD[Index].Offset;
    // if the data length is>1 then Offset is a real offset into the stream,
    // otherwise it is the value itself and must be shortend depending on the data type
    if FIFD[Index].DataLength=1 then
    begin
      case FIFD[Index].DataType of
        TIFF_BYTE:
          Result:=Byte(Result);
        TIFF_SHORT,
        TIFF_SSHORT:
          Result:=Word(Result);
        TIFF_LONG,
        TIFF_SLONG: // nothing to do
          ;
      else
        Result:=Default;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.GetValue(Tag: cardinal; var Size: cardinal; Default: cardinal): cardinal;
// Returns the value of the IFD entry indicated by Tag or the default value if the entry is not there.
// If the tag exists then also the data size is returned.
var Index: cardinal;
begin
  if not FindTag(Tag,Index) then
  begin
    Result:=Default;
    Size:=0;
  end
  else
  begin
    Result:=FIFD[Index].Offset;
    Size:=FIFD[Index].DataLength;
    // if the data length is>1 then Offset is a real offset into the stream,
    // otherwise it is the value itself and must be shortend depending on the data type
    if FIFD[Index].DataLength=1 then
    begin
      case FIFD[Index].DataType of
        TIFF_BYTE:
          Result:=Byte(Result);
        TIFF_SHORT,
        TIFF_SSHORT:
          Result:=Word(Result);
        TIFF_LONG,
        TIFF_SLONG: // nothing to do
          ;
      else
        Result:=Default;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.SortIFD;
// Although all entries in the IFD should be sorted there are still files where this is not the case.
// Because the lookup for certain tags in the IFD uses binary search it must be made sure the IFD is
// sorted (what we do here).

  //--------------- local function --------------------------------------------
  procedure QuickSort(L, R: Integer);
  var I,J,M: integer;
      T: TIFDEntry;
  begin
    repeat
      I:=L;
      J:=R;
      M:=(L+R) shr 1;
      repeat
        while FIFD[I].Tag<FIFD[M].Tag do Inc(I);
        while FIFD[J].Tag>FIFD[M].Tag do Dec(J);
        if I<=J then
        begin
          T:=FIFD[I];
          FIFD[I]:=FIFD[J];
          FIFD[J]:=T;
          Inc(I);
          Dec(J);
        end;
      until I>J;
      if L<J then QuickSort(L,J);
      L:=I;
    until I>=R;
  end;
  //--------------- end local functions ---------------------------------------
begin
  QuickSort(0,High(FIFD));
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.SwapIFD;
// swap the member fields of all entries of the currently loaded IFD from big endian to little endian
var I: integer;
    Size: cardinal;
begin
  for I:=0 to High(FIFD) do
    with FIFD[I] do
    begin
      Tag:=System.Swap(Tag);
      DataType:=System.Swap(DataType);
      DataLength:=SwapLong(DataLength);
      // determine whether the data fits into 4 bytes
      Size:=DataTypeToSize[FIFD[I].DataType]*FIFD[I].DataLength;
      if Size>=4 then Offset:=SwapLong(Offset) else
        case DataType of
          TIFF_SHORT,TIFF_SSHORT: if DataLength>1 then Offset:=SwapLong(Offset) else Offset:=System.Swap(Word(Offset));
        end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.LoadFromStream(Stream: PStream);
var IFDCount: word;
    Buffer: pointer;
    Run: PChar;
    Pixels,EncodedData,DataPointerCopy: pointer;
    Offsets,ByteCounts: TCardinalArray;
    ColorMap: cardinal;
    StripSize: cardinal;
    Decoder: TDecoder;
    // dynamically assigned handler
    Deprediction: procedure(P: pointer; Count: cardinal);
begin
  Deprediction:=nil;
  Decoder:=nil;
  // we need to keep the current stream position because all position information
  // are relative to this one
  FBasePosition:=Stream.Position;
//  ZeroMemory(@FImageProperties,sizeof(FImageProperties));
//  FImageProperties.FileGamma:=1;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    try
      // tiled images aren't supported
      if ioTiled in Options then Exit;
      // read data of the first image file directory (IFD)
      Stream.Position:=FBasePosition+FirstIFD;
      Stream.Read(IFDCount,sizeof(IFDCount));
      if ioBigEndian in Options then IFDCount:=System.Swap(IFDCount);
      SetLength(FIFD,IFDCount);
      Stream.Read(FIFD[0],IFDCount*sizeof(TIFDEntry));
      if ioBigEndian in Options then SwapIFD;
      SortIFD;
      // --- read the data of the directory which are needed to actually load the image:
      // data organization
      GetValueList(Stream,TIFFTAG_STRIPOFFSETS,Offsets);
      GetValueList(Stream,TIFFTAG_STRIPBYTECOUNTS,ByteCounts);
      // retrive additional tile data if necessary
      if ioTiled in Options then
      begin
        GetValueList(Stream,TIFFTAG_TILEOFFSETS,Offsets);
        GetValueList(Stream,TIFFTAG_TILEBYTECOUNTS,ByteCounts);
      end;
      // determine pixelformat and setup color conversion
      if ioBigEndian in Options then ColorManager.SourceOptions:=[coNeedByteSwap] else ColorManager.SourceOptions:=[];
      ColorManager.SourceBitsPerSample:=BitsPerSample;
      if ColorManager.SourceBitsPerSample=16 then ColorManager.TargetBitsPerSample:=8 else ColorManager.TargetBitsPerSample:=ColorManager.SourceBitsPerSample;
      // the JPEG lib does internally a conversion to RGB
      if Compression in [ctOJPEG,ctJPEG] then ColorManager.SourceColorScheme:=csBGR else ColorManager.SourceColorScheme:=ColorScheme;
      case ColorManager.SourceColorScheme of
        csRGBA: ColorManager.TargetColorScheme:=csBGRA;
        csRGB: ColorManager.TargetColorScheme:=csBGR;
        csCMY,csCMYK,csCIELab,csYCbCr: ColorManager.TargetColorScheme:=csBGR;
        csIndexed:
          begin
            if HasAlpha then ColorManager.SourceColorScheme:=csGA; // fake indexed images with alpha (used in EPS)
                                                      // as being grayscale with alpha
            ColorManager.TargetColorScheme:=csIndexed;
          end;
      else
        ColorManager.TargetColorScheme:=ColorManager.SourceColorScheme;
      end;
      ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
      // now that the pixel format is set we can also set the (possibly large) image dimensions
      FBitmap:=NewBitmap(Width,Height);
      if ColorManager.SourceColorScheme=csCMYK then ColorManager.TargetSamplesPerPixel:=3 else ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
      if ColorManager.SourceColorScheme=csCIELab then ColorManager.SourceOptions:=ColorManager.SourceOptions+[coLabByteRange];
      if ColorManager.SourceColorScheme=csGA then FBitmap.PixelFormat:=pf8Bit else FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
      if (Width=0) or (Height=0) then GraphicExError(1{gesInvalidImage},[TIF]);
      if ColorManager.TargetColorScheme in [csIndexed,csG,csGA] then
      begin
        // load palette data and build palette
        if ColorManager.TargetColorScheme=csIndexed then
        begin
          ColorMap:=GetValue(TIFFTAG_COLORMAP,StripSize,0);
          if StripSize>0 then
          begin
            Stream.Position:=FBasePosition+ColorMap;
            // number of palette entries is also given by the color map tag
            // (3 components each (r,g,b) and two bytes per component)
            Stream.Read(FPalette[0],2*StripSize);
            ColorManager.CreateColorPalette(FBitmap,[@FPalette[0],@FPalette[StripSize div 3],@FPalette[2*StripSize div 3]],pfPlane16Triple,StripSize,False);
          end;
        end
        else ColorManager.CreateGrayScalePalette(FBitmap,ioMinIsWhite in Options);
      end
      else
        if ColorManager.SourceColorScheme=csYCbCr then ColorManager.SetYCbCrParameters(FYCbCrCoefficients,YCbCrSubSampling[0],YCbCrSubSampling[1]);
      // intermediate buffer for data
      BytesPerLine:=(BitsPerPixel*Width+7) div 8;
      // determine prediction scheme
      if Compression<>ctNone then
      begin
        // Prediction without compression makes no sense at all (as it is to improve
        // compression ratios). Appearently there are image which are uncompressed but still
        // have a prediction scheme set. Hence we must check for it.
        case Predictor of
          PREDICTION_HORZ_DIFFERENCING: // currently only one prediction scheme is defined
            case SamplesPerPixel of
              4: Deprediction:=Depredict4;
              3: Deprediction:=Depredict3;
            else Deprediction:=Depredict1;
            end;
        end;
      end;
      // create decompressor for the image
      case Compression of
        ctNone:       ;
        ctLZW:        Decoder:=TTIFFLZWDecoder.Create;
        ctPackedBits: Decoder:=TPackbitsRLEDecoder.Create;
        ctFaxRLE,
        ctFaxRLEW:    Decoder:=TCCITTMHDecoder.Create(GetValue(TIFFTAG_GROUP3OPTIONS),ioReversed in Options,Compression=ctFaxRLEW,Width);
        ctFax3:       Decoder:=TCCITTFax3Decoder.Create(GetValue(TIFFTAG_GROUP3OPTIONS),ioReversed in Options,False,Width);
        ctThunderscan: Decoder:=TThunderDecoder.Create(Width);
        ctLZ77:        Decoder:=TLZ77Decoder.Create(Z_PARTIAL_FLUSH,True);
      else
        {
        COMPRESSION_OJPEG,
        COMPRESSION_CCITTFAX4
        COMPRESSION_NEXT
        COMPRESSION_IT8CTPAD
        COMPRESSION_IT8LW
        COMPRESSION_IT8MP
        COMPRESSION_IT8BL
        COMPRESSION_PIXARFILM
        COMPRESSION_PIXARLOG
        COMPRESSION_DCS
        COMPRESSION_JBIG}
        GraphicExError(5{gesUnsupportedFeature},[ErrorMsg[11]{gesCompressionScheme},TIF]);
      end;
      if Assigned(Decoder) then Decoder.DecodeInit;
      // go for each strip in the image (which might contain more than one line)
      CurrentRow:=0;
      CurrentStrip:=0;
      StripCount:=Length(Offsets);
      while CurrentStrip<StripCount do
      begin
        Stream.Position:=FBasePosition+Offsets[CurrentStrip];
        if CurrentStrip<Length(RowsPerStrip) then StripSize:=BytesPerLine*RowsPerStrip[CurrentStrip] else StripSize:=BytesPerLine*RowsPerStrip[High(RowsPerStrip)];
        GetMem(Buffer,StripSize);
        Run:=Buffer;
        try
          // decompress strip if necessary
          if Assigned(Decoder) then
          begin
            GetMem(EncodedData,ByteCounts[CurrentStrip]);
            try
              DataPointerCopy:=EncodedData;
              Stream.Read(EncodedData^,ByteCounts[CurrentStrip]);
              // need pointer copies here because they could get modified
              // while decoding
              Decoder.Decode(DataPointerCopy,Pointer(Run),ByteCounts[CurrentStrip],StripSize);
            finally
              if Assigned(EncodedData) then FreeMem(EncodedData);
            end;
          end
          else
          begin
            Stream.Read(Buffer^,StripSize);
          end;
          Run:=Buffer;
          // go for each line (row) in the strip
          while (CurrentRow<Height) and ((Run-Buffer)<Integer(StripSize)) do
          begin
            Pixels:=FBitmap.ScanLine[CurrentRow];
            // depredict strip if necessary
            if Assigned(Deprediction) then Deprediction(Run,Width-1);
            // any color conversion comes last
            ColorManager.ConvertRow([Run],Pixels,Width,$FF);
            Inc(PChar(Run),BytesPerLine);
            Inc(CurrentRow);
          end;
        finally
          if Assigned(Buffer) then FreeMem(Buffer);
        end;
        Inc(CurrentStrip);
      end;
    finally
      if Assigned(Decoder) then Decoder.DecodeEnd;
      Decoder.Free;
    end;
  end
  else GraphicExError(1{gesInvalidImage},[TIF]);
end;

//----------------------------------------------------------------------------------------------------------------------

const
  PhotometricToColorScheme: array[PHOTOMETRIC_MINISWHITE..PHOTOMETRIC_CIELAB] of TColorScheme = (
    csG,csG,csRGBA,csIndexed,csUnknown,csCMYK,csYCbCr,csUnknown,csCIELab);

function TTIFFGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
// Reads all relevant TIF properties of the image of index ImageIndex (zero based).
// Returns True if the image ImageIndex could be read, otherwise False.
var IFDCount: word;
    ExtraSamples,LocalBitsPerSample: TCardinalArray;
    PhotometricInterpretation: byte;
    TIFCompression: word;
    Index,IFDOffset: cardinal;
    Header: TTIFFHeader;
begin
  // clear image properties
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    // rewind stream to header position
    Stream.Position:=FBasePosition;
    Stream.Read(Header,sizeof(Header));
    if Header.ByteOrder=TIFF_BIGENDIAN then
    begin
      Options:=Options+[ioBigEndian];
      Header.Version:=System.Swap(Header.Version);
      Header.FirstIFD:=SwapLong(Header.FirstIFD);
    end;
    Version:=Header.Version;
    FirstIFD:=Header.FirstIFD;
    if Version=TIFF_VERSION then
    begin
      IFDOffset:=Header.FirstIFD;
      // advance to next IFD until we have the desired one
      repeat
        Stream.Position:=FBasePosition+IFDOffset;
        // number of entries in this directory
        Stream.Read(IFDCount,sizeof(IFDCount));
        if Header.ByteOrder=TIFF_BIGENDIAN then IFDCount:=System.Swap(IFDCount);
        // if we already have the desired image then get out of here
        if ImageIndex=0 then Break;
        Dec(ImageIndex);
        // advance to offset for next IFD
        Stream.Seek(IFDCount*sizeof(TIFDEntry),spCurrent);
        Stream.Read(IFDOffset,sizeof(IFDOffset));
        // no further image available, but the required index is still not found
        if IFDOffset=0 then Exit;
      until False;
      SetLength(FIFD,IFDCount);
      Stream.Read(FIFD[0],IFDCount*sizeof(TIFDEntry));
      if Header.ByteOrder=TIFF_BIGENDIAN then SwapIFD;
      SortIFD;
      Width:=GetValue(TIFFTAG_IMAGEWIDTH);
      Height:=GetValue(TIFFTAG_IMAGELENGTH);
      if (Width=0) or (Height=0) then Exit;
      // data organization
      GetValueList(Stream,TIFFTAG_ROWSPERSTRIP,RowsPerStrip);
      // some images rely on the default size ($FFFFFFFF) if only one stripe is in the image,
      // make sure there's a valid value also in this case
      if (Length(RowsPerStrip)=0) or (RowsPerStrip[0]=$FFFFFFFF) then
      begin
        SetLength(RowsPerStrip,1);
        RowsPerStrip[0]:=Height;
      end;
      // number of color components per pixel (1 for b&w, 16 and 256 colors, 3 for RGB, 4 for CMYK etc.)
      SamplesPerPixel:=GetValue(TIFFTAG_SAMPLESPERPIXEL,1);
      // number of bits per color component
      GetValueList(Stream,TIFFTAG_BITSPERSAMPLE,LocalBitsPerSample);
      if Length(LocalBitsPerSample)=0 then BitsPerSample:=1 else BitsPerSample:=LocalBitsPerSample[0];
      // determine whether image is tiled and retrive tile data if necessary
      TileWidth:=GetValue(TIFFTAG_TILEWIDTH,0);
      TileLength:=GetValue(TIFFTAG_TILELENGTH,0);
      if (TileWidth>0) and (TileLength>0) then Include(Options,ioTiled);
      // photometric interpretation determines the color space
      PhotometricInterpretation:=GetValue(TIFFTAG_PHOTOMETRIC);
      // type of extra information for additional samples per pixel
      GetValueList(Stream,TIFFTAG_EXTRASAMPLES,ExtraSamples);
      // determine whether extra samples must be considered
      HasAlpha:=Length(ExtraSamples)>0;
      // if any of the extra sample contains an invalid value then consider
      // it as being not existant to avoid wrong interpretation for badly
      // written images
      if HasAlpha then
      begin
        for Index:=0 to High(ExtraSamples) do
          if ExtraSamples[Index]>EXTRASAMPLE_UNASSALPHA then
          begin
            HasAlpha:=False;
            Break;
          end;
      end;
      // currently all bits per sample values are equal
      BitsPerPixel:=BitsPerSample*SamplesPerPixel;
      // create decompressor for the image
      TIFCompression:=GetValue(TIFFTAG_COMPRESSION);
      case TIFCompression of
        COMPRESSION_NONE:        Compression:=ctNone;
        COMPRESSION_LZW:         Compression:=ctLZW;
        COMPRESSION_PACKBITS:    Compression:=ctPackedBits;
        COMPRESSION_CCITTRLE:    Compression:=ctFaxRLE;
        COMPRESSION_CCITTRLEW:   Compression:=ctFaxRLEW;
        COMPRESSION_CCITTFAX3:   Compression:=ctFax3;
        COMPRESSION_OJPEG:       Compression:=ctOJPEG;
        COMPRESSION_JPEG:        Compression:=ctJPEG;
        COMPRESSION_CCITTFAX4:   Compression:=ctFax4;
        COMPRESSION_NEXT:        Compression:=ctNext;
        COMPRESSION_THUNDERSCAN: Compression:=ctThunderscan;
        COMPRESSION_IT8CTPAD:    Compression:=ctIT8CTPAD;
        COMPRESSION_IT8LW:       Compression:=ctIT8LW;
        COMPRESSION_IT8MP:       Compression:=ctIT8MP;
        COMPRESSION_IT8BL:       Compression:=ctIT8BL;
        COMPRESSION_PIXARFILM:   Compression:=ctPixarFilm;
        COMPRESSION_PIXARLOG:    Compression:=ctPixarLog;   // also a LZ77 clone
        COMPRESSION_ADOBE_DEFLATE,
        COMPRESSION_DEFLATE:     Compression:=ctLZ77;
        COMPRESSION_DCS:         Compression:=ctDCS;
        COMPRESSION_JBIG:        Compression:=ctJBIG;
      else Compression:=ctUnknown;
      end;
      if PhotometricInterpretation in [PHOTOMETRIC_MINISWHITE..PHOTOMETRIC_CIELAB] then
      begin
        ColorScheme:=PhotometricToColorScheme[PhotometricInterpretation];
        if (PhotometricInterpretation=PHOTOMETRIC_RGB) and (SamplesPerPixel<4) then ColorScheme:=csRGB;
        if PhotometricInterpretation=PHOTOMETRIC_MINISWHITE then Include(Options,ioMinIsWhite);
        // extra work necessary for YCbCr
        if PhotometricInterpretation=PHOTOMETRIC_YCBCR then
        begin
          if FindTag(TIFFTAG_YCBCRSUBSAMPLING,Index) then GetValueList(Stream,TIFFTAG_YCBCRSUBSAMPLING,YCbCrSubSampling) else
            begin
              // initialize default values if nothing is given in the file
              SetLength(YCbCrSubSampling,2);
              YCbCrSubSampling[0]:=2;
              YCbCrSubSampling[1]:=2;
            end;
          if FindTag(TIFFTAG_YCBCRPOSITIONING,Index) then FYCbCrPositioning:=GetValue(TIFFTAG_YCBCRPOSITIONING) else FYCbCrPositioning:=YCBCRPOSITION_CENTERED;
          if FindTag(TIFFTAG_YCBCRCOEFFICIENTS,Index) then GetValueList(Stream,TIFFTAG_YCBCRCOEFFICIENTS,FYCbCrCoefficients) else
            begin
              // defaults are from CCIR recommendation 601-1
              SetLength(FYCbCrCoefficients,3);
              FYCbCrCoefficients[0]:=0.299;
              FYCbCrCoefficients[1]:=0.587;
              FYCbCrCoefficients[2]:=0.114;
            end;
        end;
      end
      else ColorScheme:=csUnknown;
      JPEGColorMode:=GetValue(TIFFTAG_JPEGCOLORMODE,JPEGCOLORMODE_RAW);
      JPEGTablesMode:=GetValue(TIFFTAG_JPEGTABLESMODE,JPEGTABLESMODE_QUANT or JPEGTABLESMODE_HUFF);
      PlanarConfig:=GetValue(TIFFTAG_PLANARCONFIG);
      // other image properties
      XResolution:=GetValue(Stream,TIFFTAG_XRESOLUTION);
      YResolution:=GetValue(Stream,TIFFTAG_YRESOLUTION);
      if GetValue(TIFFTAG_RESOLUTIONUNIT,RESUNIT_INCH)=RESUNIT_CENTIMETER then
      begin
        // Resolution is given in centimeters.
        // Although I personally prefer the metric system over the old english one :-)
        // I still convert to inches because it is an unwritten rule to give image resolutions in dpi.
        XResolution:=XResolution*2.54;
        YResolution:=YResolution*2.54;
      end;
      // determine prediction scheme
      Predictor:=GetValue(TIFFTAG_PREDICTOR);
      // determine fill order in bytes
      if GetValue(TIFFTAG_FILLORDER,FILLORDER_MSB2LSB)=FILLORDER_LSB2MSB then Include(Options,ioReversed);
      // finally show that we found and read an image
      Result:=True;
    end;
  end;
end;

//----------------- TEPSGraphic ----------------------------------------------------------------------------------------

// Note: This EPS implementation does only read embedded pixel graphics in TIF format (preview).
// Credits to:
//   Olaf Stieleke
//   Torsten Pohlmeyer
//   CPS Krohn GmbH
// for providing the base information about how to read the preview image.

type
  TEPSHeader = packed record
    Code: cardinal;   // alway $C6D3D0C5, if not there then this is not an EPS or it is not a binary EPS
    PSStart,          // Offset PostScript-Code
    PSLen,	          // length of PostScript-Code
    MetaPos,          // position of a WMF
    MetaLen,          // length of a WMF
    TiffPos,          // position of TIFF (preview images should be either WMF or TIF but not both)
    TiffLen: integer; // length of the TIFF
    Checksum: smallint;
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TEPSGraphic.CanLoad(Stream: PStream): boolean;
var Header: TEPSHeader;
    LastPosition: cardinal;
begin
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      LastPosition:=Stream.Position;
      Stream.Read(Header,sizeof(Header));
      Result:=(Header.Code=$C6D3D0C5) and (Header.TiffPos>Integer(LastPosition)+sizeof(Header)) and (Header.TiffLen>0);
      Stream.Position:=LastPosition;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TEPSGraphic.LoadFromStream(Stream: PStream);
var Header: TEPSHeader;
begin
  Stream.Read(Header,sizeof(Header));
  if Header.Code<>$C6D3D0C5 then GraphicExError(1{gesInvalidImage},['EPS']);
  Stream.Seek(Header.TiffPos-sizeof(Header),spCurrent);
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

function TEPSGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
end;

//----------------- TTGAGraphic --------------------------------------------------------------------------------------

//  FILE STRUCTURE FOR THE ORIGINAL TRUEVISION TGA FILE
//    FIELD 1: NUMBER OF CHARACTERS IN ID FIELD (1 BYTES)
//    FIELD 2: COLOR MAP TYPE (1 BYTES)
//    FIELD 3: IMAGE TYPE CODE (1 BYTES)
//      = 0  NO IMAGE DATA INCLUDED
//      = 1  UNCOMPRESSED, COLOR-MAPPED IMAGE
//      = 2  UNCOMPRESSED, TRUE-COLOR IMAGE
//      = 3  UNCOMPRESSED, BLACK AND WHITE IMAGE (black and white is actually grayscale)
//      = 9  RUN-LENGTH ENCODED COLOR-MAPPED IMAGE
//      = 10 RUN-LENGTH ENCODED TRUE-COLOR IMAGE
//      = 11 RUN-LENGTH ENCODED BLACK AND WHITE IMAGE
//    FIELD 4: COLOR MAP SPECIFICATION (5 BYTES)
//      4.1: COLOR MAP ORIGIN (2 BYTES)
//      4.2: COLOR MAP LENGTH (2 BYTES)
//      4.3: COLOR MAP ENTRY SIZE (1 BYTES)
//    FIELD 5:IMAGE SPECIFICATION (10 BYTES)
//      5.1: X-ORIGIN OF IMAGE (2 BYTES)
//      5.2: Y-ORIGIN OF IMAGE (2 BYTES)
//      5.3: WIDTH OF IMAGE (2 BYTES)
//      5.4: HEIGHT OF IMAGE (2 BYTES)
//      5.5: IMAGE PIXEL SIZE (1 BYTE)
//      5.6: IMAGE DESCRIPTOR BYTE (1 BYTE)
//        bit 0..3: attribute bits per pixel
//        bit 4..5: image orientation:
//          0: bottom left
//          1: bottom right
//          2: top left
//          3: top right
//        bit 6..7: interleaved flag
//          0: two way (even-odd) interleave (e.g. IBM Graphics Card Adapter), obsolete
//          1: four way interleave (e.g. AT&T 6300 High Resolution), obsolete
//    FIELD 6: IMAGE ID FIELD (LENGTH SPECIFIED BY FIELD 1)
//    FIELD 7: COLOR MAP DATA (BIT WIDTH SPECIFIED BY FIELD 4.3 AND
//             NUMBER OF COLOR MAP ENTRIES SPECIFIED IN FIELD 4.2)
//    FIELD 8: IMAGE DATA FIELD (WIDTH AND HEIGHT SPECIFIED IN FIELD 5.3 AND 5.4)

const
  TARGA_NO_COLORMAP = 0;
  TARGA_COLORMAP = 1;

  TARGA_EMPTY_IMAGE = 0;
  TARGA_INDEXED_IMAGE = 1;
  TARGA_TRUECOLOR_IMAGE = 2;
  TARGA_BW_IMAGE = 3;
  TARGA_INDEXED_RLE_IMAGE = 9;
  TARGA_TRUECOLOR_RLE_IMAGE = 10;
  TARGA_BW_RLE_IMAGE = 11;

type
  TTargaHeader = packed record
    IDLength,
    ColorMapType,
    ImageType: Byte;
    ColorMapOrigin,
    ColorMapSize: Word;
    ColorMapEntrySize: Byte;
    XOrigin,
    YOrigin,
    Width,
    Height: Word;
    PixelSize: Byte;
    ImageDescriptor: Byte;
  end;


//----------------------------------------------------------------------------------------------------------------------

class function TTGAGraphic.CanLoad(Stream: PStream): boolean;
var Header: TTargaHeader;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      Stream.Read(Header,sizeof(Header));
      // Targa images are hard to determine because there is no magic id or something like that.
      // Hence all we can do is to check if all values from the header are within correct limits.
      Result:=(Header.ImageType in [TARGA_EMPTY_IMAGE,TARGA_INDEXED_IMAGE,TARGA_TRUECOLOR_IMAGE,TARGA_BW_IMAGE,
                 TARGA_INDEXED_RLE_IMAGE,TARGA_TRUECOLOR_RLE_IMAGE,TARGA_BW_RLE_IMAGE]) and
                 (Header.ColorMapType in [TARGA_NO_COLORMAP,TARGA_COLORMAP]) and
                 (Header.ColorMapEntrySize in [15,16,24,32]) and
                 (Header.PixelSize in [8,15,16,24,32]);
    end;
    Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTGAGraphic.LoadFromStream(Stream: PStream);
var Run,RLEBuffer: PChar;
    I,LineSize: Integer;
    LineBuffer: Pointer;
    ReadLength: Integer;
    Color16: Word;
    Header: TTargaHeader;
    FlipV: Boolean;
    Decoder: TTargaRLEDecoder;
begin
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition;
      Stream.Read(Header,sizeof(Header));
      FlipV:=(Header.ImageDescriptor and $20)<>0;
      Header.ImageDescriptor:=Header.ImageDescriptor and $F;
      // skip image ID
      Stream.Seek(Header.IDLength,spCurrent);
      ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
      ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
      ColorManager.SourceColorScheme:=ColorScheme;
      ColorManager.SourceOptions:=[];
      ColorManager.TargetColorScheme:=csBGR;
      ColorManager.SourceBitsPerSample:=BitsPerSample;
      ColorManager.TargetBitsPerSample:=BitsPerSample;
      FBitmap:=NewBitmap(Header.Width,Header.Height);
      FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
      if (Header.ColorMapType=TARGA_COLORMAP) or (Header.ImageType in [TARGA_BW_IMAGE,TARGA_BW_RLE_IMAGE]) then
      begin
        if Header.ImageType in [TARGA_BW_IMAGE,TARGA_BW_RLE_IMAGE] then ColorManager.CreateGrayscalePalette(FBitmap,False) else
        begin
          LineSize:=(Header.ColorMapEntrySize div 8)*Header.ColorMapSize;
          GetMem(LineBuffer,LineSize);
          try
            Stream.Read(LineBuffer^,LineSize);
            case Header.ColorMapEntrySize of
              32: ColorManager.CreateColorPalette(FBitmap,[LineBuffer],pfInterlaced8Quad,Header.ColorMapSize,True);
              24: ColorManager.CreateColorPalette(FBitmap,[LineBuffer],pfInterlaced8Triple,Header.ColorMapSize,True);
            else
              begin
                // 15 and 16 bits per color map entry (handle both like 555 color format
                // but make 8 bit from 5 bit per color component)
                for I:=0 to Header.ColorMapSize-1 do
                  begin
                    Stream.Read(Color16,2);
                    FBitmap.DIBPalEntries[I]:=Windows.RGB((Color16 and $7C00) shr 7,(Color16 and $3E0) shr 2,(Color16 and $1F) shl 3);
                  end;
              end;
            end;
          finally
            if Assigned(LineBuffer) then FreeMem(LineBuffer);
          end;
        end;
      end;
      LineSize:=Width*(Header.PixelSize div 8);
      case Header.ImageType of
        TARGA_EMPTY_IMAGE: ; // nothing to do here
        TARGA_BW_IMAGE,
        TARGA_INDEXED_IMAGE,
        TARGA_TRUECOLOR_IMAGE:
          begin
            for I:=0 to FBitmap.Height-1 do
            begin
              if FlipV then LineBuffer:=FBitmap.ScanLine[I] else LineBuffer:=FBitmap.ScanLine[Header.Height-(I+1)];
              Stream.Read(LineBuffer^,LineSize);
            end;
          end;
        TARGA_BW_RLE_IMAGE,
        TARGA_INDEXED_RLE_IMAGE,
        TARGA_TRUECOLOR_RLE_IMAGE:
          begin
            RLEBuffer:=nil;
            Decoder:=TTargaRLEDecoder.Create(Header.PixelSize);
            try
              GetMem(RLEBuffer,2*LineSize);
              for I:=0 to FBitmap.Height-1 do
              begin
                if FlipV then LineBuffer:=FBitmap.ScanLine[I] else LineBuffer:=FBitmap.ScanLine[Header.Height-(I+1)];
                ReadLength:=Stream.Read(RLEBuffer^,2*LineSize);
                Run:=RLEBuffer;
                Decoder.Decode(Pointer(Run),LineBuffer,2*LineSize,FBitmap.Width);
                Stream.Position:=Stream.Position-ReadLength+(Run-RLEBuffer);
              end;
            finally
              if Assigned(RLEBuffer) then FreeMem(RLEBuffer);
              Decoder.Free;
            end;
          end;
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTGAGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: TTargaHeader;
begin
  inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Header,sizeof(Header));
    Header.ImageDescriptor:=Header.ImageDescriptor and $F;
    Width:=Header.Width;
    Height:=Header.Height;
    BitsPerSample:=8;
    case Header.PixelSize of
      8: begin
           if Header.ImageType in [TARGA_BW_IMAGE,TARGA_BW_RLE_IMAGE] then ColorScheme:=csG else ColorScheme:=csIndexed;
           SamplesPerPixel:=1;
         end;
      15,
      16: // actually, 16 bit are meant being 15 bit
          begin
            ColorScheme:=csRGB;
            BitsPerSample:=5;
            SamplesPerPixel:=3;
          end;
      24: begin
            ColorScheme:=csRGB;
            SamplesPerPixel:=3;
          end;
      32: begin
            ColorScheme:=csRGBA;
            SamplesPerPixel:=4;
          end;
    end;
    BitsPerPixel:=SamplesPerPixel*BitsPerSample;
    if Header.ImageType in [TARGA_BW_RLE_IMAGE,TARGA_INDEXED_RLE_IMAGE,TARGA_TRUECOLOR_RLE_IMAGE] then Compression:=ctRLE else Compression:=ctNone;
    Width:=Header.Width;
    Height:=Header.Height;
    Result:=True;
  end;
end;

//----------------- TPCXGraphic ----------------------------------------------------------------------------------------

type
  TPCXHeader = record
    FileID: Byte;                      // $0A for PCX files, $CD for SCR files
    Version: Byte;                     // 0: version 2.5; 2: 2.8 with palette; 3: 2.8 w/o palette; 5: version 3
    Encoding: Byte;                    // 0: uncompressed; 1: RLE encoded
    BitsPerPixel: Byte;
    XMin,
    YMin,
    XMax,
    YMax,                              // coordinates of the corners of the image
    HRes,                              // horizontal resolution in dpi
    VRes: Word;                        // vertical resolution in dpi
    ColorMap: array[0..15] of TRGB;    // color table
    Reserved,
    ColorPlanes: Byte;                 // color planes (at most 4)
    BytesPerLine,                      // number of bytes of one line of one plane
    PaletteType: Word;                 // 1: color or b&w; 2: gray scale
    Fill: array[0..57] of Byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TPCXGraphic.CanLoad(Stream: PStream): boolean;
var Header: TPCXHeader;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      Result:=(Header.FileID in [$0A,$0C]) and (Header.Version in [0,2,3,5]) and (Header.Encoding in [0,1]);
      Stream.Read(Header,sizeof(Header));
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCXGraphic.LoadFromStream(Stream: PStream);
var Header: TPCXHeader;

  //--------------- local functions -------------------------------------------
  procedure MakePalette;
  const
    Pal16: array[0..15] of TColor =
      (clBlack,clMaroon,clGreen,clOlive,clNavy,clPurple,clTeal,clDkGray,
       clLtGray,clRed,clLime,clYellow,clBlue,clFuchsia,clAqua,clWhite);
  var PCXPalette: array[0..255] of TRGB;
      I,OldPos: integer;
      Marker: byte;
  begin
    if (Header.Version<>3) or (FBitmap.PixelFormat=pf1Bit) then
    begin
      case FBitmap.PixelFormat of
        pf1Bit: ColorManager.CreateGrayScalePalette(FBitmap,False);
        pf4Bit:
          with Header do
            begin
              if PaletteType=2 then ColorManager.CreateGrayScalePalette(FBitmap,False) else ColorManager.CreateColorPalette(FBitmap,[@ColorMap],pfInterlaced8Triple,16,False);
            end;
        pf8Bit:
          begin
            OldPos:=Stream.Position;
            // 256 colors with 3 components plus one marker byte
            Stream.Position:=Stream.Size-769;
            Stream.Read(Marker,1);
            if Marker<>$0C then
            begin
              // palette ID is wrong, perhaps gray scale?
              if Header.PaletteType=2 then ColorManager.CreateGrayScalePalette(FBitmap,False) else ; // ignore palette
            end
            else
            begin
              Stream.Read(PCXPalette[0],768);
              ColorManager.CreateColorPalette(FBitmap,[@PCXPalette],pfInterlaced8Triple,256,True);
            end;
            Stream.Position:=OldPos;
          end;
      end;
    end
    else
    begin
      // version 2.8 without palette information, just use the system palette
      // 256 colors will not be correct with this assignment...
      for I:=0 to 15 do FBitmap.DIBPalEntries[I]:=Pal16[I];
    end;
  end;
  //--------------- end local functions ---------------------------------------

var PCXSize,Size: cardinal;
    RawBuffer,DecodeBuffer: pointer;
    Run,Plane1,Plane2,Plane3,Plane4: PByte;
    Value,Mask: byte;
    I,J: integer;
    Line: PByte;
    Increment: cardinal;
    NewPixelFormat: TPixelFormat;
begin
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
  begin
    Stream.Position:=FBasePosition;
    Stream.Read(Header,sizeof(Header));
    PCXSize:=Stream.Size-Stream.Position;
    with Header,FImageProperties do
    begin
      if not (FileID in [$0A,$CD]) then GraphicExError(1{gesInvalidImage},['PCX or SCR']);
      ColorManager.SourceColorScheme:=ColorScheme;
      ColorManager.SourceBitsPerSample:=BitsPerSample;
      ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
      if ColorScheme=csIndexed then ColorManager.TargetColorScheme:=csIndexed else ColorManager.TargetColorScheme:=csBGR;
      if BitsPerPixel=2 then ColorManager.TargetBitsPerSample:=4 else ColorManager.TargetBitsPerSample:=BitsPerSample;
      // Note: pixel depths of 2 and 4 bits may not be used with more than one plane
      //       otherwise the image will not show up correctly
      ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
      NewPixelFormat:=ColorManager.TargetPixelFormat;
      if NewPixelFormat=pfCustom then
      begin
        // there can be a special case comprising 4 planes each with 1 bit
        if (SamplesPerPixel=4) and (BitsPerPixel=4) then NewPixelFormat:=pf4Bit else GraphicExError(2{gesInvalidColorFormat},['PCX']);
      end;
      FBitmap:=NewBitmap(Width,Height);
      FBitmap.PixelFormat:=NewPixelFormat;
      // 256 colors palette is appended to the actual PCX data
      if FBitmap.PixelFormat=pf8Bit then Dec(PCXSize,769);
      if FBitmap.PixelFormat<>pf24Bit then MakePalette;
      // adjust alignment of line
      Increment:=SamplesPerPixel*Header.BytesPerLine;
      // allocate pixel data buffer and decode data if necessary
      if Compression=ctRLE then
      begin
        Size:=Increment*Height;
        GetMem(DecodeBuffer,Size);
        GetMem(RawBuffer,PCXSize);
        try
          Stream.Read(RawBuffer^,PCXSize);
          with TPCXRLEDecoder.Create do
          try
            Decode(RawBuffer,DecodeBuffer,PCXSize,Size);
          finally
            Free;
          end;
        finally
          if Assigned(RawBuffer) then FreeMem(RawBuffer);
        end;
      end
      else
      begin
        GetMem(DecodeBuffer,PCXSize);
        Stream.Read(DecodeBuffer^,PCXSize);
      end;
      try
        Run:=DecodeBuffer;
        if (SamplesPerPixel=4) and (BitsPerPixel=4) then
        begin
          // 4 planes with one bit
          for I:=0 to Height-1 do
          begin
            Plane1:=Run;
            PChar(Plane2):=PChar(Run)+Increment div 4;
            PChar(Plane3):=PChar(Run)+2*(Increment div 4);
            PChar(Plane4):=PChar(Run)+3*(Increment div 4);
            Line:=FBitmap.ScanLine[I];
            // number of bytes to write
            Size:=(FBitmap.Width*BitsPerPixel+7) div 8;
            Mask:=0;
            while Size>0 do
            begin
              Value:=0;
              for J:=0 to 1 do
              asm
                MOV AL,[Value]
                MOV EDX,[Plane4]             // take the 4 MSBs from the 4 runs and build a nibble
                SHL BYTE PTR [EDX],1         // read MSB and prepare next run at the same time
                RCL AL,1                     // MSB from previous shift is in CF -> move it to AL
                MOV EDX,[Plane3]             // now do the same with the other three runs
                SHL BYTE PTR [EDX],1
                RCL AL,1
                MOV EDX,[Plane2]
                SHL BYTE PTR [EDX],1
                RCL AL,1
                MOV EDX,[Plane1]
                SHL BYTE PTR [EDX],1
                RCL AL,1
                MOV [Value],AL
              end;
              Line^:=Value;
              Inc(Line);
              Dec(Size);
              // two runs above (to construct two nibbles -> one byte), now update marker
              // to know when to switch to next byte in the planes
              Mask:=(Mask+2) mod 8;
              if Mask=0 then
              begin
                Inc(Plane1);
                Inc(Plane2);
                Inc(Plane3);
                Inc(Plane4);
              end;
            end;
            Inc(Run,Increment);
          end;
        end
        else
          if FBitmap.PixelFormat=pf24Bit then
          begin
            // true color
            for I:=0 to FBitmap.Height-1 do
            begin
              Line:=FBitmap.ScanLine[I];
              Plane1:=Run;
              PChar(Plane2):=PChar(Run)+Increment div 3;
              PChar(Plane3):=PChar(Run)+2*(Increment div 3);
              ColorManager.ConvertRow([Plane1,Plane2,Plane3],Line,FBitmap.Width,$FF);
              Inc(Run,Increment);
            end
          end
          else
          begin
            // other indexed formats
            for I:=0 to FBitmap.Height-1 do
            begin
              Line:=FBitmap.ScanLine[I];
              ColorManager.ConvertRow([Run],Line,FBitmap.Width,$FF);
              Inc(Run,Increment);
            end;
          end;
      finally
        if Assigned(DecodeBuffer) then FreeMem(DecodeBuffer);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPCXGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: TPCXHeader;
begin
  Result:=inherited ReadImageProperties(Stream,0);
  Stream.Read(Header,sizeof(Header));
  with FImageProperties do
    begin
      if Header.FileID in [$0A,$CD] then
      begin
        Width:=Header.XMax-Header.XMin+1;
        Height:=Header.YMax-Header.YMin+1;
        SamplesPerPixel:=Header.ColorPlanes;
        BitsPerSample:=Header.BitsPerPixel;
        BitsPerPixel:=BitsPerSample*SamplesPerPixel;
        if BitsPerPixel<=8 then ColorScheme:=csIndexed else ColorScheme:=csRGB;
        if Header.Encoding=1 then Compression:=ctRLE else Compression:=ctNone;
        XResolution:=Header.HRes;
        YResolution:=Header.VRes;
        Result:=True;
      end;
    end;
end;

//----------------- TPCDGraphic ----------------------------------------------------------------------------------------

const
  PCD_BEGIN_BASE16 = 8192;
  PCD_BEGIN_BASE4 = 47104;
  PCD_BEGIN_BASE = 196608;
  PCD_BEGIN_ORIENTATION = 194635;
  PCD_BEGIN = 2048;

  PCD_MAGIC = 'PCD_IPI';

//----------------------------------------------------------------------------------------------------------------------

class function TPCDGraphic.CanLoad(Stream: PStream): boolean;
var Header: array[0..$802] of byte;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>3*$800;
  if Result then
    begin
      Stream.Read(Header,Length(Header));
      Result:=(StrLComp(@Header[0],'PCD_OPA',7)=0) or (StrLComp(@Header[$800],'PCD',3)=0);
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCDGraphic.LoadFromStream(Stream: PStream);
var C1,C2,YY: PChar;
    YCbCrData: array[0..2] of PChar;
    SourceDummy,DestDummy: pointer;
    Offset,I,X,Y,ImageIndex,Rows,Columns: cardinal;
    ScanLines: array of pointer;
    LineBuffer: pointer;
    Line,Run: PBGR;
    Decoder: TPCDDecoder;
begin
  FBasePosition:=Stream.Position;
  ImageIndex:=2;                   // third image is Base resolution
  if ReadImageProperties(Stream,ImageIndex) then
  begin
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition;
      Columns:=192 shl MinMin(ImageIndex,2);
      Rows:=128 shl MinMin(ImageIndex,2);
      // since row and columns might be swapped because of rotated images
      // we determine the final dimensions once more
      FBitmap:=NewBitmap(192 shl ImageIndex,128 shl ImageIndex);
      ZeroMemory(@YCbCrData,sizeof(YCbCrData));
      try
        GetMem(YCbCrData[0],FBitmap.Width*FBitmap.Height);
        GetMem(YCbCrData[1],FBitmap.Width*FBitmap.Height);
        GetMem(YCbCrData[2],FBitmap.Width*FBitmap.Height);
        // advance to image data
        Offset:=96;
        if Overview then Offset:=5 else
          if ImageIndex=1 then Offset:=23 else
            if ImageIndex=0 then Offset:=4;
        Stream.Seek(Offset*$800,spCurrent);
        // color conversion setup
        ColorManager.SourceColorScheme:=csPhotoYCC;
        ColorManager.SourceBitsPerSample:=8;
        ColorManager.SourceSamplesPerPixel:=3;
        ColorManager.TargetColorScheme:=csBGR;
        ColorManager.TargetBitsPerSample:=8;
        ColorManager.TargetSamplesPerPixel:=3;
        FBitmap.PixelFormat:=pf24Bit;
        // PhotoYCC format uses CCIR Recommendation 709 coefficients and is subsampled
        // by factor 2 vertically and horizontally
        ColorManager.SetYCbCrParameters([0.2125,0.7154,0.0721],2,2);
        if False then
        begin
          // if Overview then ... no info yet about overview image structure
        end
        else
        begin
          YY:=YCbCrData[0];
          C1:=YCbCrData[1];
          C2:=YCbCrData[2];
          I:=0;
          while I<Rows do
          begin
            Stream.Read(YY^,Columns);
            Inc(YY,Width);
            Stream.Read(YY^,Columns);
            Inc(YY,Width);
            Stream.Read(C1^,Columns shr 1);
            Inc(C1,Width);
            Stream.Read(C2^,Columns shr 1);
            Inc(C2,Width);
            Inc(I,2);
          end;
          // Y stands here for maximum number of upsample calls
          Y:=5;
          if ImageIndex>=3 then
          begin
            Inc(Y,3*(ImageIndex-3));
            Decoder:=TPCDDecoder.Create(Stream);
            SourceDummy:=@YCbCrData;
            DestDummy:=nil;
            try
              // recover luminance deltas for 1536 x 1024 image
              Upsample(768,512,Width,YCbCrData[0]);
              Upsample(384,256,Width,YCbCrData[1]);
              Upsample(384,256,Width,YCbCrData[2]);
              Stream.Seek(4*$800,spCurrent);
              Decoder.Decode(SourceDummy,DestDummy,Width,1024);
              if ImageIndex>=4 then
              begin
                // recover luminance deltas for 3072 x 2048 image
                Upsample(1536,1024,FBitmap.Width,YCbCrData[0]);
                Upsample(768,512,FBitmap.Width,YCbCrData[1]);
                Upsample(768,512,FBitmap.Width,YCbCrData[2]);
                Offset:=(Stream.Position-Integer(FBasePosition)) div $800+12;
                Stream.Seek(FBasePosition+Offset*$800,spBegin);
                Decoder.Decode(SourceDummy,DestDummy,Width,2048);
                if ImageIndex=5 then
                begin
                  // recover luminance deltas for 6144 x 4096 image (vaporware)
                  Upsample(3072,2048,FBitmap.Width,YCbCrData[1]);
                  Upsample(1536,1024,FBitmap.Width,YCbCrData[1]);
                  Upsample(1536,1024,FBitmap.Width,YCbCrData[2]);
                end;
              end;
            finally
              Decoder.Free;
            end;
          end;
          Upsample(FBitmap.Width shr 1,FBitmap.Height shr 1,FBitmap.Width,YCbCrData[1]);
          Upsample(FBitmap.Width shr 1,FBitmap.Height shr 1,FBitmap.Width,YCbCrData[2]);
          // transfer luminance and chrominance channels
          YY:=YCbCrData[0];
          C1:=YCbCrData[1];
          C2:=YCbCrData[2];
          // For the rotated mode where we need to turn the image by 90°. We can speed up loading
          // the image by factor 2 by using a local copy of the Scanline pointers.
          if Rotate in [1,3] then
          begin
            FBitmap.Width:=Height;
            FBitmap.Height:=Width;
            SetLength(ScanLines,FBitmap.Width);
            for Y:=0 to FBitmap.Width-1 do ScanLines[Y]:=FBitmap.ScanLine[Y];
            GetMem(LineBuffer,3*FBitmap.Width);
          end
          else
          begin
            ScanLines:=nil;
            FBitmap.Width:=Width;
            FBitmap.Height:=Height;
            LineBuffer:=nil;
          end;
          try
            case Rotate of
              1: // rotate -90°
                begin
                  for Y:=0 to FBitmap.Height-1 do
                  begin
                    ColorManager.ConvertRow([YY,C1,C2],LineBuffer,FBitmap.Width,$FF);
                    Inc(YY,FBitmap.Width);
                    Inc(C1,FBitmap.Width);
                    Inc(C2,FBitmap.Width);
                    Run:=LineBuffer;
                    for X:=0 to FBitmap.Width-1 do
                    begin
                      PChar(Line):=PChar(ScanLines[FBitmap.Width-X-1])+Y*3;
                      Line^:=Run^;
                      Inc(Run);
                    end;
                  end;
                end;
              3: // rotate 90°
                begin
                  for Y:=0 to Height-1 do
                  begin
                    ColorManager.ConvertRow([YY,C1,C2],LineBuffer,FBitmap.Width,$FF);
                    Inc(YY,FBitmap.Width);
                    Inc(C1,FBitmap.Width);
                    Inc(C2,FBitmap.Width);
                    Run:=LineBuffer;
                    for X:=0 to FBitmap.Width-1 do
                    begin
                      PChar(Line):=PChar(ScanLines[X])+(FBitmap.Height-Y-1)*3;
                      Line^:=Run^;
                      Inc(Run);
                    end;
                  end;
                end;
            else
              for Y:=0 to Height-1 do
              begin
                ColorManager.ConvertRow([YY,C1,C2],FBitmap.ScanLine[Y],FBitmap.Width,$FF);
                Inc(YY,FBitmap.Width);
                Inc(C1,FBitmap.Width);
                Inc(C2,FBitmap.Width);
              end;
            end;
          finally
            ScanLines:=nil;
            if Assigned(LineBuffer) then FreeMem(LineBuffer);
          end;
        end;
      finally
        if Assigned(YCbCrData[2]) then FreeMem(YCbCrData[2]);
        if Assigned(YCbCrData[1]) then FreeMem(YCbCrData[1]);
        if Assigned(YCbCrData[0]) then FreeMem(YCbCrData[0]);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPCDGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: array[0..$17FF] of byte;
    Temp: cardinal;
begin
  if ImageIndex>5 then ImageIndex:=5;
  Result:=inherited ReadImageProperties(Stream,ImageIndex) and ((Stream.Size-Integer(FBasePosition))>3*$800);
  with FImageProperties do
  begin
    Stream.Read(Header,Length(Header));
    try
      Overview:=StrLComp(@Header[0],'PCD_OPA',7)=0;
      // determine if image is a PhotoCD image
      if Overview or (StrLComp(@Header[$800],'PCD',3)=0) then
      begin
        Rotate:=Header[$0E02] and 3;
        // image sizes are fixed, depending on the given image index
        if Overview then ImageIndex:=0;
        Width:=192 shl ImageIndex;
        Height:=128 shl ImageIndex;
        if (Rotate=1) or (Rotate=3) then
        begin
          Temp:=Width;
          Width:=Height;
          Height:=Temp;
        end;
        ColorScheme:=csPhotoYCC;
        BitsPerSample:=8;
        SamplesPerPixel:=3;
        BitsPerPixel:=BitsPerSample*SamplesPerPixel;
        if ImageIndex>2 then Compression:=ctPCDHuffmann else Compression:=ctNone;
        ImageCount:=(Header[10] shl 8) or Header[11];
        Result:=True;
      end;
    finally
    end;
  end;
end;

//----------------- TPPMGraphic ----------------------------------------------------------------------------------------

class function TPPMGraphic.CanLoad(Stream: PStream): boolean;
var Buffer: array[0..9] of Char;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>10;
  if Result then
    begin
      Stream.Read(Buffer,sizeof(Buffer));
      Result:=(Buffer[0]='P') and (Buffer[1] in ['1'..'6']);
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.CurrentChar: Char;
begin
  if FIndex=sizeof(FBuffer) then Result:=#0 else Result:=FBuffer[FIndex];
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.GetChar: Char;
// buffered I/O
begin
  if FIndex=sizeof(FBuffer) then
  begin
    if FStream.Position=FStream.Size then GraphicExError(3{gesStreamReadError},['PPM']);
    FIndex:=0;
    FStream.Read(FBuffer,sizeof(FBuffer));
  end;
  Result:=FBuffer[FIndex];
  Inc(FIndex);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.GetNumber: Cardinal;
// reads the next number from the stream (and skips all characters which are not in 0..9)
var Ch: Char;
begin
  // skip all non-numbers
  repeat
    Ch:=GetChar;
    // skip comments
    if Ch='#' then
    begin
      ReadLine;
      Ch:=GetChar;
    end;
  until Ch in ['0'..'9'];
  // read the number characters and convert meanwhile
  Result:=0;
  repeat
    Result:=10*Result+Ord(Ch)-$30;
    Ch:=GetChar;
  until not (Ch in ['0'..'9']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.ReadLine: string;
// reads one text line from stream and skips comments
var Ch: Char;
    I: integer;
begin
  Result:='';
  repeat
    Ch:=GetChar;
    if Ch in [#13, #10] then Break else Result:=Result+Ch;
  until False;
  // eat #13#10 combination
  if (Ch=#13) and (CurrentChar=#10) then GetChar;
  // delete comments
  I:=Pos('#',Result);
  if I>0 then Delete(Result,I,MaxInt);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPPMGraphic.LoadFromStream(Stream: PStream);
var Buffer: string;
    Line24: PBGR;
    Line8: PByte;
    X,Y,W,H: integer;
    Pixel: byte;
begin
  FBasePosition:=Stream.Position;
  // copy reference for buffered access
  FStream:=Stream;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition;
      // set index pointer to end of buffer to cause reload
      FIndex:=sizeof(FBuffer);
      Buffer:=ReadLine;
      case Str2Int(Buffer[2]) of
        1: // PBM ASCII format (black & white)
          begin
            W:=GetNumber;
            H:=GetNumber;
            FBitmap:=NewBitmap(W,H);
            FBitmap.PixelFormat:=pf1Bit;
            ColorManager.TargetSamplesPerPixel:=1;
            ColorManager.TargetBitsPerSample:=1;
            ColorManager.CreateGrayScalePalette(FBitmap,True);
            // read image data
            for Y:=0 to FBitmap.Height-1 do
            begin
              Line8:=FBitmap.ScanLine[Y];
              Pixel:=0;
              for X:=1 to FBitmap.Width do
              begin
                Pixel:=(Pixel shl 1) or (GetNumber and 1);
                if (X mod 8)=0 then
                begin
                  Line8^:=Pixel;
                  Inc(Line8);
                  Pixel:=0;
                end;
              end;
              if (FBitmap.Width mod 8)<>0 then Line8^:=Pixel shl (8-(FBitmap.Width mod 8));
            end;
          end;
        2: // PGM ASCII form (gray scale)
          begin
            W:=GetNumber;
            H:=GetNumber;
            FBitmap:=NewBitmap(W,H);
            FBitmap.PixelFormat:=pf8Bit;
            // skip maximum color value
            GetNumber;
            ColorManager.TargetSamplesPerPixel:=1;
            ColorManager.TargetBitsPerSample:=8;
            ColorManager.CreateGrayScalePalette(FBitmap,False);
            // read image data
            for Y:=0 to FBitmap.Height-1 do
            begin
              Line8:=FBitmap.ScanLine[Y];
              for X:=0 to FBitmap.Width-1 do
              begin
                Line8^:=GetNumber;
                Inc(Line8);
              end;
            end;
          end;
        3: // PPM ASCII form (true color)
          begin
            W:=GetNumber;
            H:=GetNumber;
            FBitmap:=NewBitmap(W,H);
            FBitmap.PixelFormat:=pf24Bit;
            // skip maximum color value
            GetNumber;
            for Y:=0 to FBitmap.Height-1 do
            begin
              Line24:=FBitmap.ScanLine[Y];
              for X:=0 to FBitmap.Width-1 do
              begin
                Line24.R:=GetNumber;
                Line24.G:=GetNumber;
                Line24.B:=GetNumber;
                Inc(Line24);
              end;
            end;
          end;
        4: // PBM binary format (black & white)
          begin
            W:=GetNumber;
            H:=GetNumber;
            FBitmap:=NewBitmap(W,H);
            FBitmap.PixelFormat:=pf1Bit;
            ColorManager.TargetSamplesPerPixel:=1;
            ColorManager.TargetBitsPerSample:=1;
            ColorManager.CreateGrayScalePalette(FBitmap,True);
            // read image data
            for Y:=0 to FBitmap.Height-1 do
            begin
              Line8:=FBitmap.ScanLine[Y];
              for X:=0 to (FBitmap.Width div 8)-1 do
              begin
                Line8^:=Byte(GetChar);
                Inc(Line8);
              end;
              if (FBitmap.Width mod 8)<>0 then Line8^:=Byte(GetChar);
            end;
          end;
        5: // PGM binary form (gray scale)
          begin
            W:=GetNumber;
            H:=GetNumber;
            FBitmap:=NewBitmap(W,H);
            FBitmap.PixelFormat:=pf8Bit;
            // skip maximum color value
            GetNumber;
            ColorManager.TargetSamplesPerPixel:=1;
            ColorManager.TargetBitsPerSample:=8;
            ColorManager.CreateGrayScalePalette(FBitmap,False);
            // read image data
            for Y:=0 to FBitmap.Height-1 do
            begin
              Line8:=FBitmap.ScanLine[Y];
              for X:=0 to FBitmap.Width-1 do
              begin
                Line8^:=Byte(GetChar);
                Inc(Line8);
              end;
            end;
          end;
        6: // PPM binary form (true color)
          begin
            W:=GetNumber;
            H:=GetNumber;
            FBitmap:=NewBitmap(W,H);
            FBitmap.PixelFormat:=pf24Bit;
            // skip maximum color value
            GetNumber;
            // Pixel values are store linearly (but RGB instead BGR).
            // There's one allowed white space which will automatically be skipped by the first
            // GetChar call below
            // now read the pixels
            for Y:=0 to FBitmap.Height-1 do
            begin
              Line24:=FBitmap.ScanLine[Y];
              for X:=0 to FBitmap.Width-1 do
              begin
                Line24.R:=Byte(GetChar);
                Line24.G:=Byte(GetChar);
                Line24.B:=Byte(GetChar);
                Inc(Line24);
              end;
            end;
          end;
      end;
    end;
  end
  else GraphicExError(1{gesInvalidImage},['PBM, PGM or PPM']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Buffer: string;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    // set index pointer to end of buffer to cause reload
    FIndex:=sizeof(FBuffer);
    Buffer:=ReadLine;
    Compression:=ctNone;
    if Buffer[1]='P' then
    begin
      case Str2Int(Buffer[2]) of
        1: // PBM ASCII format (black & white)
          begin
            Width:=GetNumber;
            Height:=GetNumber;
            SamplesPerPixel:=1;
            BitsPerSample:=1;
            ColorScheme:=csIndexed;
            BitsPerPixel:=SamplesPerPixel*BitsPerSample;
          end;
        2: // PGM ASCII form (gray scale)
          begin
            Width:=GetNumber;
            Height:=GetNumber;
            // skip maximum color value
            GetNumber;
            SamplesPerPixel:=1;
            BitsPerSample:=8;
            ColorScheme:=csIndexed;
            BitsPerPixel:=SamplesPerPixel*BitsPerSample;
          end;
        3: // PPM ASCII form (true color)
          begin
            Width:=GetNumber;
            Height:=GetNumber;
            // skip maximum color value
            GetNumber;
            SamplesPerPixel:=3;
            BitsPerSample:=8;
            ColorScheme:=csRGB;
            BitsPerPixel:=SamplesPerPixel*BitsPerSample;
          end;
        4: // PBM binary format (black & white)
          begin
            Width:=GetNumber;
            Height:=GetNumber;
            SamplesPerPixel:=1;
            BitsPerSample:=1;
            ColorScheme:=csIndexed;
            BitsPerPixel:=SamplesPerPixel*BitsPerSample;
          end;
        5: // PGM binary form (gray scale)
          begin
            Width:=GetNumber;
            Height:=GetNumber;
            // skip maximum color value
            GetNumber;
            SamplesPerPixel:=1;
            BitsPerSample:=8;
            ColorScheme:=csIndexed;
            BitsPerPixel:=SamplesPerPixel*BitsPerSample;
          end;
        6: // PPM binary form (true color)
          begin
            Width:=GetNumber;
            Height:=GetNumber;
            // skip maximum color value
            GetNumber;
            SamplesPerPixel:=3;
            BitsPerSample:=8;
            ColorScheme:=csRGB;
            BitsPerPixel:=SamplesPerPixel*BitsPerSample;
          end;
      end;
      Result:=True;
    end;
  end;
end;

//----------------- TCUTGraphic ----------------------------------------------------------------------------------------

class function TCUTGraphic.CanLoad(Stream: PStream): boolean;
// Note: cut files cannot be determined from stream because the only information
//       is width and height of the image at stream/image start which is by no means
//       enough to identify a cut (or any other) image.
begin
  Result:=False;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TCUTGraphic.LoadFromStream(Stream: PStream);
var Buffer: PByte;
    Run,Line: pointer;
    Decoder: TCUTRLEDecoder;
    CUTSize: cardinal;
    Y: integer;
begin
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition+6;
      FBitmap:=NewBitmap(Width,Height);
      FBitmap.PixelFormat:=pf8Bit;
      LoadPalette;
      CutSize:=Stream.Size-Stream.Position;
      Decoder:=TCUTRLEDecoder.Create;
      Buffer:=nil;
      try
        GetMem(Buffer,CutSize);
        Stream.Read(Buffer^,CUTSize);
        Run:=Buffer;
        for Y:=0 to FBitmap.Height-1 do
        begin
          Line:=FBitmap.ScanLine[Y];
          Decoder.Decode(Run,Line,0,FBitmap.Width);
        end;
      finally
        Decoder.Free;
        if Assigned(Buffer) then FreeMem(Buffer);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TCUTGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Dummy: word;
begin
  inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Dummy,sizeof(Dummy));
    Width:=Dummy;
    Stream.Read(Dummy,sizeof(Dummy));
    Height:=Dummy;
    ColorScheme:=csIndexed;
    BitsPerSample:=8;
    SamplesPerPixel:=1;
    BitsPerPixel:=BitsPerSample*SamplesPerPixel;
    Compression:=ctRLE;
    Result:=True;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

type
  // the palette file header is actually more complex than the
  // image file's header, funny...
  PHaloPaletteHeader = ^THaloPaletteHeader;
  THaloPaletteHeader = packed record
    ID: array[0..1] of Char;  // should be 'AH'
    Version,Size: word;
    FileType,SubType: byte;
    BrdID,GrMode: word;
    MaxIndex,MaxRed,MaxGreen,MaxBlue: word; // colors = MaxIndex + 1
    Signature: array[0..7] of Char; // 'Dr. Halo'
    Filler: array[0..11] of byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TCUTGraphic.LoadPalette;
var Header: PHaloPaletteHeader;
    I: integer;
    Buffer: array[0..511] of byte;
    Run: PWord;
    R,G,B: byte;
    Temp: PStream;
begin
  if FileExists(FPaletteFile) then
  begin
    Temp:=NewReadFileStream(FPaletteFile);
    try
      // quite strange file organization here, we need always to load 512 bytes blocks
      // and skip occasionally some bytes
      Temp.Read(Buffer,sizeof(Buffer));
      Header:=@Buffer;
      Run:=@Buffer;
      Inc(PByte(Run),sizeof(Header^));
      for I:=0 to Header.MaxIndex do
      begin
        // load next 512 bytes buffer if necessary
        if (Integer(Run)-Integer(@Buffer))>506 then
        begin
          Temp.Read(Buffer,sizeof(Buffer));
          Run:=@Buffer;
        end;
        B:=Run^;
        Inc(Run);
        G:=Run^;
        Inc(Run);
        R:=Run^;
        Inc(Run);
        FBitmap.DIBPalEntries[I]:=Windows.RGB(R,G,B);
      end;
    finally
      Temp.Free;
    end;
  end
  else
    begin
      // no external palette so use gray scale
      for I:=0 to 255 do FBitmap.DIBPalEntries[I]:=Windows.RGB(I,I,I);
    end;
end;

//----------------- TGIFGraphic ----------------------------------------------------------------------------------------

const
  // logical screen descriptor packed field masks
  GIF_GLOBALCOLORTABLE = $80;
  GIF_COLORRESOLUTION = $70;
  GIF_GLOBALCOLORTABLESORTED = $08; 
  GIF_COLORTABLESIZE = $07;

  // image flags
  GIF_LOCALCOLORTABLE = $80;
  GIF_INTERLACED = $40;
  GIF_LOCALCOLORTABLESORTED= $20;

  // block identifiers
  GIF_PLAINTEXT = $01;
  GIF_GRAPHICCONTROLEXTENSION = $F9;
  GIF_COMMENTEXTENSION = $FE;
  GIF_APPLICATIONEXTENSION = $FF;
  GIF_IMAGEDESCRIPTOR = Ord(',');
  GIF_EXTENSIONINTRODUCER = Ord('!');
  GIF_TRAILER = Ord(';');
  
type
  TGIFHeader = packed record
    Signature: array[0..2] of Char; // magic ID 'GIF'
    Version: array[0..2] of Char;   // '87a' or '89a' 
  end;

  TLogicalScreenDescriptor = packed record
    ScreenWidth: Word;
    ScreenHeight: Word;
    PackedFields,
    BackgroundColorIndex, // index into global color table
    AspectRatio: Byte;    // actual ratio = (AspectRatio + 15) / 64
  end;

  TImageDescriptor = packed record
    //Separator: Byte; // leave that out since we always read one bye ahead
    Left: Word;		 // X position of image with respect to logical screen
    Top: Word;		 // Y position
    Width: Word;
    Height: Word;
    PackedFields: Byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TGIFGraphic.CanLoad(Stream: PStream): boolean;
var Header: TGIFHeader;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>(sizeof(TGIFHeader)+sizeof(TLogicalScreenDescriptor)+sizeof(TImageDescriptor));
  if Result then
    begin
      Stream.Read(Header,sizeof(Header));
      Result:=UpperCase(Header.Signature)='GIF';
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

function TGIFGraphic.SkipExtensions: byte;
// Skips all blocks until an image block has been found in the data stream.
// Result is the image block ID if an image block could be found.
var Increment: byte;
begin
  // iterate through the blocks until first image is found
  repeat
    FStream.Read(Result,1);
    if Result=GIF_EXTENSIONINTRODUCER then
      begin
        // skip any extension
        FStream.Read(Result,1);
        case Result of
          GIF_PLAINTEXT:
            begin
              // block size of text grid data
              FStream.Read(Increment,1);
              FStream.Seek(Increment,spCurrent);
              // skip variable lengthed text block
              repeat
                // block size
                FStream.Read(Increment,1);
                if Increment=0 then Break;
                FStream.Seek(Increment,spCurrent);
              until False;
            end;
          GIF_GRAPHICCONTROLEXTENSION:
            begin
              // block size
              FStream.Read(Increment,1);
              // skip block and its terminator
              FStream.Seek(Increment+1,spCurrent);
            end;
          GIF_COMMENTEXTENSION:
            repeat
              // block size
              FStream.Read(Increment,1);
              if Increment=0 then Break;
              FStream.Seek(Increment,spCurrent);
            until False;
          GIF_APPLICATIONEXTENSION:
            begin
              // application id and authentication code plus potential application data
              repeat
                FStream.Read(Increment,1);
                if Increment=0 then Break;
                FStream.Seek(Increment,spCurrent);
              until False;
            end;
        end;
      end;
  until (Result=GIF_IMAGEDESCRIPTOR) or (Result=GIF_TRAILER);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TGIFGraphic.LoadFromStream(Stream: PStream);
var Header: TGIFHeader;
    ScreenDescriptor: TLogicalScreenDescriptor;
    ImageDescriptor: TImageDescriptor;
    I,NE: cardinal;
    R,G,B,BlockID,InitCodeSize: byte;
    RawData,Run: PByte;
    TargetBuffer,TargetRun,Line: pointer;
    Pass,Increment,Marker: integer;
    Decoder: TDecoder;
begin
  FBasePosition:=Stream.Position;
  FStream:=Stream;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition;
      Stream.Read(Header,sizeof(Header));
      FBitmap:=NewBitmap(Width,Height);
      FBitmap.PixelFormat:=pf8Bit;
      // general information
      Stream.Read(ScreenDescriptor,sizeof(ScreenDescriptor));
      // read global color table if given
      if (ScreenDescriptor.PackedFields and GIF_GLOBALCOLORTABLE)<>0 then
      begin
        // the global color table immediately follows the screen descriptor
        NE:=2 shl (ScreenDescriptor.PackedFields and GIF_COLORTABLESIZE);
        for I:=0 to NE-1 do
        begin
          Stream.Read(B,1);
          Stream.Read(G,1);
          Stream.Read(R,1);
          FBitmap.DIBPalEntries[I]:=Windows.RGB(R,G,B);
        end;
      end;
      BlockID:=SkipExtensions;
      // image found?
      if BlockID=GIF_IMAGEDESCRIPTOR then
      begin
        Stream.Read(ImageDescriptor,sizeof(TImageDescriptor));
        // if there is a local color table then override the already set one
        if (ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE)<>0 then
        begin
          // the global color table immediately follows the image descriptor
          NE:=2 shl (ImageDescriptor.PackedFields and GIF_COLORTABLESIZE);
          for I:=0 to NE-1 do
          begin
            Stream.Read(B,1);
            Stream.Read(G,1);
            Stream.Read(R,1);
            FBitmap.DIBPalEntries[I]:=Windows.RGB(R,G,B);
          end;
        end;
        Stream.Read(InitCodeSize,1);
        // decompress data in one step
        // 1) count data
        Marker:=Stream.Position;
        Pass:=0;
        Increment:=0;
        repeat
          if Stream.Read(Increment,1)=0 then Break;
          Inc(Pass,Increment);
          Stream.Seek(Increment,spCurrent);
        until Increment=0;
        // 2) allocate enough memory
        GetMem(RawData,Pass);
        // add one extra line of extra memory for badly coded images
        GetMem(TargetBuffer,FBitmap.Width*(FBitmap.Height+1));
        try
          // 3) read and decode data
          Stream.Position:=Marker;
          Increment:=0;
          Run:=RawData;
          repeat
            if Stream.Read(Increment,1)=0 then Break;
            Stream.Read(Run^,Increment);
            Inc(Run,Increment);
          until Increment=0;
          Decoder:=TGIFLZWDecoder.Create(InitCodeSize);
          try
            Run:=RawData;
            Decoder.Decode(Pointer(Run),TargetBuffer,Pass,FBitmap.Width*FBitmap.Height);
          finally
            Decoder.Free;
          end;
          // finally transfer image data
          if (ImageDescriptor.PackedFields and GIF_INTERLACED)=0 then
          begin
            TargetRun:=TargetBuffer;
            for I:=0 to FBitmap.Height-1 do
            begin
              Line:=FBitmap.ScanLine[I];
              Move(TargetRun^,Line^,FBitmap.Width);
              Inc(PByte(TargetRun),FBitmap.Width);
            end;
          end
          else
          begin
            TargetRun:=TargetBuffer;
            // interlaced image, need to move in four passes
            for Pass:=0 to 3 do
            begin
              // determine start line and increment of the pass
              case Pass of
                0: begin
                     I:=0;
                     Increment:=8;
                   end;
                1: begin
                     I:=4;
                     Increment:=8;
                   end;
                2: begin
                     I:=2;
                     Increment:=4;
                   end;
              else
                I:=1;
                Increment:=2;
              end;
              while I<FBitmap.Height do
              begin
                Line:=FBitmap.ScanLine[I];
                Move(TargetRun^,Line^,FBitmap.Width);
                Inc(PByte(TargetRun),FBitmap.Width);
                Inc(I,Increment);
              end;
            end;
          end;
        finally
          if Assigned(TargetBuffer) then FreeMem(TargetBuffer);
          if Assigned(RawData) then FreeMem(RawData);
        end;
      end;
    end;
  end
  else GraphicExError(1{gesInvalidImage},['GIF']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TGIFGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): Boolean;
var Header: TGIFHeader;
    ScreenDescriptor: TLogicalScreenDescriptor;
    ImageDescriptor: TImageDescriptor;
    BlockID: integer;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Header,sizeof(Header));
    if UpperCase(Header.Signature)='GIF' then
    begin
      Version:=Str2Int(Copy(Header.Version,1,2));
      ColorScheme:=csIndexed;
      SamplesPerPixel:=1;
      // might be overwritten
      BitsPerSample:=8;
      Compression:=ctLZW;
      // general information
      Stream.Read(ScreenDescriptor,sizeof(ScreenDescriptor));
      // skip global color table if given
      if (ScreenDescriptor.PackedFields and GIF_GLOBALCOLORTABLE)<>0 then
      begin
        BitsPerSample:=(ScreenDescriptor.PackedFields and GIF_COLORTABLESIZE)+1;
        // the global color table immediately follows the screen descriptor
        Stream.Seek(3*(1 shl BitsPerSample),spCurrent);
      end;
      BlockID:=SkipExtensions;
      // image found?
      if BlockID=GIF_IMAGEDESCRIPTOR then
      begin
        Stream.Read(ImageDescriptor,sizeof(TImageDescriptor));
        Width:=ImageDescriptor.Width;
        if Width=0 then Width:=ScreenDescriptor.ScreenWidth;
        Height:=ImageDescriptor.Height;
        if Height=0 then Height:=ScreenDescriptor.ScreenHeight;
        // if there is a local color table then override the already set one
        LocalColorTable:=(ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE)<>0;
        if LocalColorTable then BitsPerSample:=(ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE)+1;
        Interlaced:=(ImageDescriptor.PackedFields and GIF_INTERLACED)<>0;
      end;
      BitsPerPixel:=SamplesPerPixel*BitsPerSample;
      Result:=True;
    end;
  end;
end;

//----------------- TRLAGraphic ----------------------------------------------------------------------------------------

// This implementation is based on code from Dipl. Ing. Ingo Neumann (ingo@upstart.de, ingo_n@dialup.nacamar.de).

type
  TRLAWindow = packed record
    Left,Right,Bottom,Top: smallint;
  end;

  TRLAHeader = packed record
    Window,                            // overall image size
    Active_window: TRLAWindow;         // size of non-zero portion of image (we use this as actual image size)
    Frame,                             // frame number if part of a sequence
    Storage_type,                      // type of image channels (0 - integer data, 1 - float data)
    Num_chan,                          // samples per pixel (usually 3: r, g, b)
    Num_matte,                         // number of matte channels (usually only 1)
    Num_aux,                           // number of auxiliary channels, usually 0
    Revision: smallint;                // always $FFFE
    Gamma: array[0..15] of Char;       // gamma single value used when writing the image
    Red_pri: array[0..23] of Char;     // used chromaticity for red channel (typical format: "%7.4f %7.4f")
    Green_pri: array[0..23] of Char;   // used chromaticity for green channel
    Blue_pri: array[0..23] of Char;    // used chromaticity for blue channel
    White_pt: array[0..23] of Char;    // used chromaticity for white point
    Job_num: integer;                  // rendering speciifc
    Name: array[0..127] of Char;       // original file name
    Desc: array[0..127] of Char;       // a file description
    ProgramName: array[0..63] of Char; // name of program which created the image
    Machine: array[0..31] of Char;     // name of computer on which the image was rendered
    User: array[0..31] of Char;        // user who ran the creation program of the image
    Date: array[0..19] of Char;        // creation data of image (ex: Sep 30 12:29 1993)
    Aspect: array[0..23] of Char;      // aspect format of the file (external resource)
    Aspect_ratio: array[0..7] of Char; // float number Width /Height
    Chan: array[0..31] of Char;        // color space (can be: rgb, xyz, sampled or raw)
    Field: smallint;                   // 0 - non-field rendered data, 1 - field rendered data
    Time: array[0..11] of Char;        // time needed to create the image (used when rendering)
    Filter: array[0..31] of Char;      // filter name to post-process image data
    Chan_bits,                         // bits per sample
    Matte_type,                        // type of matte channel (see aux_type)
    Matte_bits,                        // precision of a pixel's matte channel (1..32)
    Aux_type,                          // type of aux channel (0 - integer data; 4 - single (float) data
    Aux_bits: smallint;                // bits precision of the pixel's aux channel (1..32 bits)
    Aux: array[0..31] of Char;         // auxiliary channel as either range or depth
    Space: array[0..35] of Char;       // unused
    Next: integer;                     // offset for next header if multi-frame image
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TRLAGraphic.CanLoad(Stream: PStream): boolean;
var Header: TRLAHeader;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      Stream.Read(Header,sizeof(Header));
      Result:=(System.Swap(Word(Header.Revision))=$FFFE) and ((LowerCase(Header.Chan)='rgb') or (LowerCase(Header.Chan)='xyz'));
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TRLAGraphic.LoadFromStream(Stream: PStream);
var Offsets: TCardinalArray;
    RLELength: word;
    Line: pointer;
    Y: Integer;
    // RLE buffers
    RawBuffer,RedBuffer,GreenBuffer,BlueBuffer,AlphaBuffer: pointer;
    Decoder: TRLADecoder;
begin
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      // dimension of image, top might be larger than bottom denoting a bottom up image
      FBitmap:=NewBitmap(Width,Height);
      ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
      ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
      ColorManager.SourceBitsPerSample:=BitsPerSample;
      if BitsPerSample>8 then ColorManager.TargetBitsPerSample:=8 else ColorManager.TargetBitsPerSample:=BitsPerSample;
      ColorManager.SourceColorScheme:=ColorScheme;
      if ColorScheme=csRGBA then ColorManager.TargetColorScheme:=csBGRA else ColorManager.TargetColorScheme:=csBGR;
      FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
      if FileGamma<>1 then
      begin
        ColorManager.SetGamma(FileGamma);
        ColorManager.TargetOptions:=ColorManager.TargetOptions+[coApplyGamma];
        Include(Options,ioUseGamma);
      end;
      // each scanline is organized in RLE compressed strips whose location in the stream
      // is determined by the offsets table
      SetLength(Offsets,Height);
      Stream.Read(Offsets[0],Height*sizeof(Cardinal));
      SwapLong(@Offsets[0],Height);
      // setup intermediate storage
      Decoder:=TRLADecoder.Create;
      RawBuffer:=nil;
      RedBuffer:=nil;
      GreenBuffer:=nil;
      BlueBuffer:=nil;
      AlphaBuffer:=nil;
      try
        GetMem(RedBuffer,Width);
        GetMem(GreenBuffer,Width);
        GetMem(BlueBuffer,Width);
        GetMem(AlphaBuffer,Width);
        // no go for each scanline
        for Y:=0 to Height-1 do
        begin
          Stream.Position:=FBasePosition+Offsets[Y];
          if BottomUp then Line:=FBitmap.ScanLine[Integer(Height)-Y-1] else Line:=FBitmap.ScanLine[Y];
          // read channel data to decode
          // red
          Stream.Read(RLELength,sizeof(RLELength));
          RLELength:=System.Swap(RLELength);
          ReallocMem(RawBuffer,RLELength);
          Stream.Read(RawBuffer^,RLELength);
          Decoder.Decode(RawBuffer,RedBuffer,RLELength,Width);
          // green
          Stream.Read(RLELength,sizeof(RLELength));
          RLELength:=System.Swap(RLELength);
          ReallocMem(RawBuffer,RLELength);
          Stream.Read(RawBuffer^,RLELength);
          Decoder.Decode(RawBuffer,GreenBuffer,RLELength,Width);
          // blue
          Stream.Read(RLELength,sizeof(RLELength));
          RLELength:=System.Swap(RLELength);
          ReallocMem(RawBuffer,RLELength);
          Stream.Read(RawBuffer^,RLELength);
          Decoder.Decode(RawBuffer,BlueBuffer,RLELength,Width);
          if ColorManager.TargetColorScheme=csBGR then
            begin
              ColorManager.ConvertRow([RedBuffer,GreenBuffer,BlueBuffer],Line,Width,$FF);
            end
          else
          begin
            // alpha
            Stream.Read(RLELength,sizeof(RLELength));
            RLELength:=System.Swap(RLELength);
            ReallocMem(RawBuffer,RLELength);
            Stream.Read(RawBuffer^,RLELength);
            Decoder.Decode(RawBuffer,AlphaBuffer,RLELength,Width);
            ColorManager.ConvertRow([RedBuffer,GreenBuffer,BlueBuffer,AlphaBuffer],Line,Width,$FF);
          end;
        end;
      finally
        if Assigned(RawBuffer) then FreeMem(RawBuffer);
        if Assigned(RedBuffer) then FreeMem(RedBuffer);
        if Assigned(GreenBuffer) then FreeMem(GreenBuffer);
        if Assigned(BlueBuffer) then FreeMem(BlueBuffer);
        if Assigned(AlphaBuffer) then FreeMem(AlphaBuffer);
        Decoder.Free;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TRLAGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: TRLAHeader;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Header,sizeof(Header));
    // data is always given in big endian order, so swap data which needs this
    SwapHeader(Header);
    Options:=[ioBigEndian];
    SamplesPerPixel:=Header.num_chan;
    if Header.num_matte=1 then Inc(SamplesPerPixel);
    BitsPerSample:=Header.Chan_bits;
    BitsPerPixel:=SamplesPerPixel*BitsPerSample;
    if LowerCase(Header.Chan)='rgb' then
    begin
      if Header.num_matte>0 then ColorScheme:=csRGBA else ColorScheme:=csRGB;
    end
    else
      if LowerCase(Header.Chan)='xyz' then Exit;
    try
      FileGamma:=Str2Double(Header.Gamma);
    except
    end;
    Compression:=ctRLE;
    // dimension of image, top might be larger than bottom denoting a bottom up image
    Width:=Header.Active_window.Right-Header.Active_window.Left+1;
    Height:=Abs(Header.Active_window.Bottom-Header.Active_window.Top)+1;
    BottomUp:=(Header.Active_window.Bottom-Header.Active_window.Top)<0;
    Result:=True;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TRLAGraphic.SwapHeader(var Header);
// separate swap method to ease reading the main flow of the LoadFromStream method
begin
  with TRLAHeader(Header) do
  begin
    SwapShort(@Window,4);
    SwapShort(@Active_window,4);
    Frame:=System.Swap(Frame);
    Storage_type:=System.Swap(Storage_type);
    Num_chan:=System.Swap(Num_chan);
    Num_matte:=System.Swap(Num_matte);
    Num_aux:=System.Swap(Num_aux);
    Revision:=System.Swap(Revision);
    Job_num:=SwapLong(Job_num);
    Field:=System.Swap(Field);
    Chan_bits:=System.Swap(Chan_bits);
    Matte_type:=System.Swap(Matte_type);
    Matte_bits:=System.Swap(Matte_bits);
    Aux_type:=System.Swap(Aux_type);
    Aux_bits:=System.Swap(Aux_bits);
    Next:=SwapLong(Next);
  end;
end;

//----------------- TPSDGraphic ----------------------------------------------------------------------------------------

const
  // color modes
  PSD_BITMAP = 0;
  PSD_GRAYSCALE = 1;
  PSD_INDEXED = 2;
  PSD_RGB = 3;
  PSD_CMYK = 4;
  PSD_MULTICHANNEL = 7;
  PSD_DUOTONE = 8;
  PSD_LAB = 9;

  PSD_COMPRESSION_NONE = 0;
  PSD_COMPRESSION_RLE = 1; // RLE compression (same as TIFF packed bits)

type
  TPSDHeader = packed record
    Signature: array[0..3] of Char; // always '8BPS'
    Version: word;                  // always 1
    Reserved: array[0..5] of byte;  // reserved, always 0
    Channels: word;                 // 1..24, number of channels in the image (including alpha)
    Rows,
    Columns: cardinal;              // 1..30000, size of image
    Depth: word;                    // 1,8,16 bits per channel
    Mode: word;                     // color mode (see constants above)
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TPSDGraphic.CanLoad(Stream: PStream): boolean;
var Header: TPSDHeader;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      Stream.Read(Header,sizeof(Header));
      Result:=(UpperCase(Header.Signature)='8BPS') and (System.Swap(Header.Version)=1);
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPSDGraphic.LoadFromStream(Stream: PStream);
var Header: TPSDHeader;
    Count: cardinal;
    Decoder: TDecoder;
    RLELength: array[0..65535] of word;
    Y: integer;
    BPS: cardinal;        // bytes per sample either 1 or 2 for 8 bits per channel and 16 bits per channel respectively
    ChannelSize: integer; // size of one channel (taking BPS into account)
    Increment: integer;   // pointer increment from one line to next
    // RLE buffers
    Line,RawBuffer,       // all image data compressed
    Buffer: pointer;      // all image data uncompressed
    Run1,                 // running pointer in Buffer 1
    Run2,                 // etc.
    Run3,
    Run4: PByte;
    RawPalette: array[0..767] of byte;
begin
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      Stream.Position:=FBasePosition;
      Stream.Read(Header,sizeof(Header));
      // initialize color manager
      ColorManager.SourceOptions:=[coNeedByteSwap];
      ColorManager.SourceBitsPerSample:=BitsPerSample;
      if BitsPerSample=16 then ColorManager.TargetBitsPerSample:=8 else ColorManager.TargetBitsPerSample:=BitsPerSample;
      ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
      ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
      // color space
      ColorManager.SourceColorScheme:=ColorScheme;
      case ColorScheme of
        csG,csIndexed:   ColorManager.TargetColorScheme:=ColorScheme;
        csRGB:           ColorManager.TargetColorScheme:=csBGR;
        csRGBA:          ColorManager.TargetColorScheme:=csBGRA;
        csCMYK:        begin
                         ColorManager.TargetColorScheme:=csBGR;
                         ColorManager.TargetSamplesPerPixel:=3;
                       end;
        csCIELab:      begin
                         // PSD uses 0..255 for a and b so we need to convert them to -128..127
                         ColorManager.SourceOptions:=ColorManager.SourceOptions+[coLabByteRange,coLabChromaOffset];
                         ColorManager.TargetColorScheme:=csBGR;
                       end;
      end;
      FBitmap:=NewBitmap(Width,Height);
      FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
      // size of palette
      Stream.Read(Count,sizeof(Count));
      Count:=SwapLong(Count);
      // setup the palette if necessary, color data immediately follows header
      case ColorScheme of
        csG: ColorManager.CreateGrayscalePalette(FBitmap,ioMinIsWhite in Options);
        csIndexed:
          begin
            Stream.Read(RawPalette,Count);
            Count:=Count div 3;
            ColorManager.CreateColorPalette(FBitmap,[@RawPalette,@RawPalette[Count],@RawPalette[2*Count]],pfPlane8Triple,Count,False);
          end;
      end;
      // skip resource and layers section
      Stream.Read(Count,sizeof(Count));
      Count:=SwapLong(Count);
      Stream.Seek(Count,spCurrent);
      Stream.Read(Count,sizeof(Count));
      Count:=SwapLong(Count);
      // +2 in order to skip the following compression value
      Stream.Seek(Count+2,spCurrent);
      // now read out image data
      RawBuffer:=nil;
      if Compression=ctPackedBits then
      begin
        Decoder:=TPackbitsRLEDecoder.Create;
        Stream.Read(RLELength,2*Height*Channels);
        SwapShort(@RLELength[0],Height*Channels);
      end
      else Decoder:=nil;
      try
        case ColorScheme of
          csG,csIndexed:
            begin
              // very simple format here, we don't need the color conversion manager
              if Assigned(Decoder) then
              begin
                // determine whole compressed size
                Count:=0;
                for Y:=0 to Height-1 do Inc(Count,RLELength[Y]);
                GetMem(RawBuffer,Count);
                try
                  Stream.Read(RawBuffer^,Count);
                  Run1:=RawBuffer;
                  for Y:=0 to Height-1 do
                  begin
                    Count:=RLELength[Y];
                    Line:=FBitmap.ScanLine[Y];
                    Decoder.Decode(Pointer(Run1),Line,Count,Width);
                    Inc(Run1,Count);
                  end;
                finally
                  if Assigned(RawBuffer) then FreeMem(RawBuffer);
                end;
              end
              else // uncompressed data 
                for Y:=0 to Height-1 do
                begin
                  Stream.Read(FBitmap.ScanLine[Y]^,Width);
                end;
            end;
          csRGB,csRGBA,csCMYK,csCIELab:
            begin
              // Data is organized in planes. This means first all red rows, then
              // all green and finally all blue rows. 
              BPS:=BitsPerSample div 8;
              ChannelSize:=BPS*Width*Height;
              GetMem(Buffer,Channels*ChannelSize);
              try
                // first run: load image data and decompress it if necessary
                if Assigned(Decoder) then
                begin
                  // determine whole compressed size
                  Count:=0;
                  for Y:=0 to High(RLELength) do Inc(Count,RLELength[Y]);
                  Count:=Count*Cardinal(BPS);
                  GetMem(RawBuffer,Count);
                  try
                    Stream.Read(RawBuffer^,Count);
                    Decoder.Decode(RawBuffer,Buffer,Count,Channels*ChannelSize);
                  finally
                    if Assigned(RawBuffer) then FreeMem(RawBuffer);
                  end;
                end
                else Stream.Read(Buffer^,Channels*ChannelSize);
                Increment:=BPS*Width;
                // second run: put data into image (convert color space if necessary)
                case ColorScheme of
                  csRGB:
                    begin
                      Run1:=Buffer;
                      Run2:=Run1;
                      Inc(Run2,ChannelSize);
                      Run3:=Run2;
                      Inc(Run3,ChannelSize);
                      for Y:=0 to Height-1 do
                      begin
                        ColorManager.ConvertRow([Run1,Run2,Run3],FBitmap.ScanLine[Y],Width,$FF);
                        Inc(Run1,Increment);
                        Inc(Run2,Increment);
                        Inc(Run3,Increment);
                      end;
                    end;
                  csRGBA:
                    begin
                      Run1:=Buffer;
                      Run2:=Run1;
                      Inc(Run2,ChannelSize);
                      Run3:=Run2;
                      Inc(Run3,ChannelSize);
                      Run4:=Run3;
                      Inc(Run4,ChannelSize);
                      for Y:=0 to Height-1 do
                      begin
                        ColorManager.ConvertRow([Run1,Run2,Run3,Run4],FBitmap.ScanLine[Y],Width,$FF);
                        Inc(Run1,Increment);
                        Inc(Run2,Increment);
                        Inc(Run3,Increment);
                        Inc(Run4,Increment);
                      end;
                    end;
                  csCMYK:
                    begin
                      // Photoshop CMYK values are given with 0 for maximum values, but the
                      // (general) CMYK conversion works with 255 as maxium value. Hence we must reverse
                      // all entries in the buffer.
                      Run1:=Buffer;
                      for Y:=1 to 4*ChannelSize do
                      begin
                        Run1^:=255-Run1^;
                        Inc(Run1);
                      end;
                      Run1:=Buffer;
                      Run2:=Run1;
                      Inc(Run2,ChannelSize);
                      Run3:=Run2;
                      Inc(Run3,ChannelSize);
                      Run4:=Run3;
                      Inc(Run4,ChannelSize);
                      for Y:=0 to Height-1 do
                      begin
                        ColorManager.ConvertRow([Run1,Run2,Run3,Run4],FBitmap.ScanLine[Y],Width,$FF);
                        Inc(Run1,Increment);
                        Inc(Run2,Increment);
                        Inc(Run3,Increment);
                        Inc(Run4,Increment);
                      end;
                    end;
                  csCIELab:
                    begin
                      Run1:=Buffer;
                      Run2:=Run1;
                      Inc(Run2,ChannelSize);
                      Run3:=Run2;
                      Inc(Run3,ChannelSize);
                      for Y:=0 to Height-1 do
                      begin
                        ColorManager.ConvertRow([Run1,Run2,Run3],FBitmap.ScanLine[Y],Width,$FF);
                        Inc(Run1,Increment);
                        Inc(Run2,Increment);
                        Inc(Run3,Increment);
                      end;
                    end;
                end;
              finally
                if Assigned(Buffer) then FreeMem(Buffer);
              end;
            end;
        end;
      finally
        Decoder.Free;
      end;
    end;
  end
  else GraphicExError(1{gesInvalidImage},['PSD or PDD']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPSDGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: TPSDHeader;
    Dummy: word;
    Count: cardinal;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Header,sizeof(Header));
    if Header.Signature='8BPS' then
    begin
      with Header do
      begin
        // PSD files are big endian only
        Channels:=System.Swap(Channels);
        Rows:=SwapLong(Rows);
        Columns:=SwapLong(Columns);
        Depth:=System.Swap(Depth);
        Mode:=System.Swap(Mode);
      end;
      Options:=[ioBigEndian];
      // initialize color manager
      BitsPerSample:=Header.Depth;
      Channels:=Header.Channels;
      // 1..24 channels are supported in PSD files, we can only use 4.
      // The documentation states that main image data (rgb(a), cmyk etc.) is always
      // written as first channels in their component order.
      if Channels>4 then SamplesPerPixel:=4 else SamplesPerPixel:=Channels;
      BitsPerPixel:=SamplesPerPixel*BitsPerSample;
      // color space
      case Header.Mode of
        PSD_DUOTONE,   // duo tone should be handled as grayscale
        PSD_GRAYSCALE: ColorScheme:=csG;
        PSD_BITMAP:    // B&W
          begin
            ColorScheme:=csG;
            Include(Options,ioMinIsWhite);
          end;
        PSD_INDEXED:   // 8 bits only are assumed because 16 bit wouldn't make sense here
          ColorScheme:=csIndexed;
        PSD_MULTICHANNEL,
        PSD_RGB:
          if Header.Channels=3 then ColorScheme:=csRGB else ColorScheme:=csRGBA;
        PSD_CMYK:      ColorScheme:=csCMYK;
        PSD_LAB:       ColorScheme:=csCIELab;
      end;
      Width:=Header.Columns;
      Height:=Header.Rows;
      // size of palette
      Stream.Read(Count,sizeof(Count));
      Count:=SwapLong(Count);
      // skip palette (count is always given, might be 0 however, e.g. for RGB)
      Stream.Seek(Count,spCurrent);
      // skip resource and layers section
      Stream.Read(Count,sizeof(Count));
      Count:=SwapLong(Count);
      Stream.Seek(Count,spCurrent);
      Stream.Read(Count,sizeof(Count));
      Count:=SwapLong(Count);
      Stream.Seek(Count,spCurrent);
      Stream.Read(Dummy,sizeof(Dummy));
      if System.Swap(Dummy)=1 then Compression:=ctPackedBits else Compression:=ctNone;
      Result:=True;
    end;
  end;
end;

//----------------- TPSPGraphic ----------------------------------------------------------------------------------------

const
  // block identifiers
  PSP_IMAGE_BLOCK = 0;          // General Image Attributes Block (main)
  PSP_CREATOR_BLOCK = 1;        // Creator Data Block (main)
  PSP_COLOR_BLOCK = 2;          // Color Palette Block (main and sub)
  PSP_LAYER_START_BLOCK = 3;    // Layer Bank Block (main)
    PSP_LAYER_BLOCK = 4;          // Layer Block (sub)
    PSP_CHANNEL_BLOCK = 5;        // Channel Block (sub)
  PSP_SELECTION_BLOCK = 6;      // Selection Block (main)
  PSP_ALPHA_BANK_BLOCK = 7;     // Alpha Bank Block (main)
    PSP_ALPHA_CHANNEL_BLOCK = 8;  // Alpha Channel Block (sub)
  PSP_THUMBNAIL_BLOCK = 9;      // Thumbnail Block (main)
  PSP_EXTENDED_DATA_BLOCK = 10; // Extended Data Block (main)
  PSP_TUBE_BLOCK = 11;          // Picture Tube Data Block (main)
    PSP_ADJUSTMENT_EXTENSION_BLOCK = 12; // Adjustment Layer Extension Block (sub)
    PSP_VECTOR_EXTENSION_BLOCK = 13;     // Vector Layer Extension Block (sub)
    PSP_SHAPE_BLOCK = 14;                // Vector Shape Block (sub)
    PSP_PAINTSTYLE_BLOCK = 15;           // Paint Style Block (sub)
  PSP_COMPOSITE_IMAGE_BANK_BLOCK = 16; // Composite Image Bank (main)
    PSP_COMPOSITE_ATTRIBUTES_BLOCK = 17; // Composite Image Attributes (sub)
    PSP_JPEG_BLOCK = 18;                 // JPEG Image Block (sub)

  // bitmap types
	PSP_DIB_IMAGE = 0;            // Layer color bitmap
	PSP_DIB_TRANS_MASK = 1;       // Layer transparency mask bitmap
	PSP_DIB_USER_MASK = 2;        // Layer user mask bitmap
	PSP_DIB_SELECTION= 3;         // Selection mask bitmap
	PSP_DIB_ALPHA_MASK = 4;       // Alpha channel mask bitmap
	PSP_DIB_THUMBNAIL = 5;        // Thumbnail bitmap
  PSP_DIB_THUMBNAIL_TRANS_MASK = 6; // Thumbnail transparency mask
  PSP_DIB_ADJUSTMENT_LAYER = 7; // Adjustment layer bitmap
  PSP_DIB_COMPOSITE = 8;        // Composite image bitmap
  PSP_DIB_COMPOSITE_TRANS_MASK = 9; // Composite image transparency

  // composite image type
  PSP_IMAGE_COMPOSITE = 0;      // Composite Image
  PSP_IMAGE_THUMBNAIL = 1;      // Thumbnail Image

  // graphic contents flags
  PSP_GC_RASTERLAYERS = 1;      // At least one raster layer
  PSP_GC_VectorLayers = 2;      // At least one vector layer
  PSP_GC_ADJUSTMENTLAYERS = 4;  // At least one adjustment layer
  // Additional attributes
  PSP_GC_THUMBNAIL = $01000000;              // Has a thumbnail
  PSP_GC_THUMBNAILTRANSPARENCY = $02000000;  // Thumbnail transp.
  PSP_GC_COMPOSITE = $04000000;              // Has a composite image
  PSP_GC_COMPOSITETRANSPARENCY = $08000000;  // Composite transp.
  PSP_GC_FLATIMAGE = $10000000;              // Just a background
  PSP_GC_SELECTION = $20000000;              // Has a selection
  PSP_GC_FLOATINGSELECTIONLAYER = $40000000; // Has float. selection
  PSP_GC_ALPHACHANNELS = $80000000;          // Has alpha channel(s)

  // character style flags
  PSP_STYLE_ITALIC = 1;         // Italic property bit
  PSP_STYLE_STRUCK = 2;         // Strike-out property bit
  PSP_STYLE_UNDERLINED = 4;     // Underlined property bit

  // layer flags
	PSP_LAYER_VISIBLEFLAG = 1;    // Layer is visible
	PSP_LAYER_MASKPRESENCEFLAG = 2; // Layer has a mask

  // Shape property flags
  PSP_SHAPE_ANTIALIASED = 1;    // Shape is anti-aliased
  PSP_SHAPE_Selected = 2;       // Shape is selected
  PSP_SHAPE_Visible = 4;        // Shape is visible

  // Polyline node type flags
  PSP_NODE_UNCONSTRAINED = 0;   // Default node type
  PSP_NODE_SMOOTH = 1;          // Node is smooth
  PSP_NODE_SYMMETRIC = 2;       // Node is symmetric
  PSP_NODE_ALIGNED = 4;         // Node is aligned
  PSP_NODE_ACTIVE = 8;          // Node is active
  PSP_NODE_LOCKED = 16;         // Node is locked (PSP doc says 0x16 here, but this seems to be a typo)
  PSP_NODE_SELECTED = 32;       // Node is selected (PSP doc says 0x32 here)
  PSP_NODE_VISIBLE = 64;        // Node is visible (PSP doc says 0x64 here)
  PSP_NODE_CLOSED = 128;        // Node is closed (PSP doc says 0x128 here)

  // Blend modes
	LAYER_BLEND_NORMAL = 0;
  LAYER_BLEND_DARKEN = 1;
  LAYER_BLEND_LIGHTEN = 2;
  LAYER_BLEND_HUE = 3;
  LAYER_BLEND_SATURATION = 4;
  LAYER_BLEND_COLOR = 5;
  LAYER_BLEND_LUMINOSITY = 6;
  LAYER_BLEND_MULTIPLY = 7;
  LAYER_BLEND_SCREEN = 8;
  LAYER_BLEND_DISSOLVE = 9;
  LAYER_BLEND_OVERLAY = 10;
  LAYER_BLEND_HARD_LIGHT = 11;
  LAYER_BLEND_SOFT_LIGHT = 12;
  LAYER_BLEND_DIFFERENCE = 130;
  LAYER_BLEND_DODGE = 14;
  LAYER_BLEND_BURN = 15;
  LAYER_BLEND_EXCLUSION = 16;
  LAYER_BLEND_ADJUST = 255;

  // Adjustment layer types
  PSP_ADJUSTMENT_NONE = 0;      // Undefined adjustment layer type
  PSP_ADJUSTMENT_LEVEL = 1;     // Level adjustment
  PSP_ADJUSTMENT_CURVE = 2;     // Curve adjustment
  PSP_ADJUSTMENT_BRIGHTCONTRAST = 3; // Brightness-contrast adjustment
  PSP_ADJUSTMENT_COLORBAL = 4;  // Color balance adjustment
  PSP_ADJUSTMENT_HSL = 5;       // HSL adjustment
  PSP_ADJUSTMENT_CHANNELMIXER = 6; // Channel mixer adjustment
  PSP_ADJUSTMENT_INVERT = 7;    // Invert adjustment
  PSP_ADJUSTMENT_THRESHOLD = 8; // Threshold adjustment
  PSP_ADJUSTMENT_POSTER = 9;    // Posterize adjustment

  // Vector shape types
  PSP_VST_Unknown = 0;          // Undefined vector type
  PSP_VST_TEXT = 1;             // Shape represents lines of text
  PSP_VST_POLYLINE = 2;         // Shape represents a multiple segment line
  PSP_VST_ELLIPSE = 3;          // Shape represents an ellipse (or circle)
  PSP_VST_POLYGON = 4;          // Shape represents a closed polygon

  // Text element types
  PSP_TET_UNKNOWN = 0;          // Undefined text element type
  PSP_TET_CHAR = 1;             // A single character code
  PSP_TET_CHARSTYLE = 2;        // A character style change
  PSP_TET_LINESTYLE = 3;        // A line style change

  // Text alignment types
  PSP_TAT_LEFT = 0;             // Left text alignment
  PSP_TAT_CENTER = 1;           // Center text alignment
  PSP_TAT_RIGHT = 2;            // Right text alignment

  // Paint style types
  PSP_STYLE_NONE = 0;           // Undefined paint style
  PSP_STYLE_COLOR = 1;          // Paint using color (RGB or palette index)
  PSP_STYLE_GRADIENT = 2;       // Paint using gradient

  // Channel types
	PSP_CHANNEL_COMPOSITE = 0;    // Channel of single channel bitmap
	PSP_CHANNEL_RED = 1;          // Red channel of 24 bit bitmap
	PSP_CHANNEL_GREEN = 2;        // Green channel of 24 bit bitmap
	PSP_CHANNEL_BLUE = 3;         // Blue channel of 24 bit bitmap

  // Resolution metrics
  PSP_METRIC_UNDEFINED = 0;	    // Metric unknown
  PSP_METRIC_INCH = 1;          // Resolution is in inches
  PSP_METRIC_CM = 2;            // Resolution is in centimeters

  // Compression types
	PSP_COMP_NONE = 0;            // No compression
	PSP_COMP_RLE = 1;             // RLE compression
	PSP_COMP_LZ77 = 2;            // LZ77 compression
  PSP_COMP_JPEG = 3;            // JPEG compression (only used by thumbnail and composite image)

  // Picture tube placement mode
	PSP_TPM_Random = 0;           // Place tube images in random intervals
	PSPS_TPM_Constant = 1;        // Place tube images in constant intervals

  // Tube selection mode
	PSP_TSM_RANDOM =0;            // Randomly select the next image in tube to display
	PSP_TSM_INCREMENTAL = 1;     // Select each tube image in turn
	PSP_TSM_ANGULAR = 2;          // Select image based on cursor direction
	PSP_TSM_PRESSURE = 3;         // Select image based on pressure (from pressure-sensitive pad)
	PSP_TSM_VELOCITY = 4;         // Select image based on cursor speed

  // Extended data field types
  PSP_XDATA_TRNS_INDEX = 0;     // Transparency index field

  // Creator field types
	PSP_CRTR_FLD_TITLE = 0;       // Image document title field
	PSP_CRTR_FLD_CRT_DATE = 1;    // Creation date field
	PSP_CRTR_FLD_MOD_DATE = 2;    // Modification date field
	PSP_CRTR_FLD_ARTIST = 3;      // Artist name field
	PSP_CRTR_FLD_CPYRGHT = 4;     // Copyright holder name field
	PSP_CRTR_FLD_DESC = 5;        // Image document description field
	PSP_CRTR_FLD_APP_ID = 6;      // Creating app id field
	PSP_CRTR_FLD_APP_VER = 7;     // Creating app version field

  // Creator application identifier
	PSP_CREATOR_APP_UNKNOWN = 0;  // Creator application unknown
	PSP_CREATOR_APP_PAINT_SHOP_PRO = 1; // Creator is Paint Shop Pro

  // Layer types (file version 3)
  PSP_LAYER_NORMAL = 0;         // Normal layer
  PSP_LAYER_FLOATING_SELECTION = 1; // Floating selection layer

  // Layer types (file version 4)
  PSP_LAYER_UNDEFINED = 0;      // Undefined layer type
  PSP_LAYER_RASTER = 1;         // Standard raster layer
  PSP_LAYER_FLOATINGRASTERSELECTION = 2; // Floating selection (raster layer)
  PSP_LAYER_Vector = 3;         // Vector layer
  PSP_LAYER_ADJUSTMENT = 4;     // Adjustment layer

  MagicID = 'Paint Shop Pro Image File';

type
  // These block header structures are here for informational purposes only because the data of those
  // headers is read member by member to generalize code for the different file versions
  TPSPBlockHeader3 = packed record          // block header file version 3
    HeaderIdentifier: array[0..3] of Char;  // i.e. "~BK" followed by a zero byte
    BlockIdentifier: word;                  // one of the block identifiers
    InitialChunkLength,                     // length of the first sub chunk header or similar
    TotalBlockLength: cardinal;             // length of this block excluding this header
  end;

  TPSPBlockHeader4 = packed record          // block header file version 4
    HeaderIdentifier: array[0..3] of Char;  // i.e. "~BK" followed by a zero byte
    BlockIdentifier: word;                  // one of the block identifiers
    TotalBlockLength: cardinal;             // length of this block excluding this header
  end;

  TPSPColorPaletteInfoChunk = packed record
    EntryCount: cardinal;                   // number of entries in the palette
  end;

  TPSPColorPaletteChunk = array[0..255] of TRGBQuad; // might actually be shorter

  TPSPChannelInfoChunk = packed record
    CompressedSize,
    UncompressedSize: cardinal;
    BitmapType,                             // one of the bitmap types
    ChannelType: word;                      // one of the channel types
  end;

  // PSP defines a channel content chunk which is just a bunch of bytes (size is CompressedSize).
  // There is no sense to define this record type here.

  TPSPFileHeader = packed record
    Signature: array[0..31] of Char;        // the string "Paint Shop Pro Image File\n\x1a", padded with zeroes
    MajorVersion,
    MinorVersion: word;
  end;

  TPSPImageAttributes = packed record
    Width,Height: integer;
    Resolution: double;                     // Number of pixels per metric
    ResolutionMetric: byte;                 // Metric used for resolution (one of the metric constants)
    Compression,                            // compression type of image (not thumbnail, it has its own compression)
    BitDepth,                               // The bit depth of the color bitmap in each Layer of the image document
                                            // (must be 1, 4, 8 or 24).
    PlaneCount: word;                       // Number of planes in each layer of the image document (usually 1)
    ColorCount: cardinal;                   // number of colors in each layer (2^bit depth)
    GreyscaleFlag: boolean;                 // Indicates whether the color bitmap in each layer of image document is a
                                            // greyscale (False = not greyscale, True = greyscale).
    TotalImageSize: cardinal;               // Sum of the sizes of all layer color bitmaps.
    ActiveLayer: integer;                   // Identifies the layer that was active when the image document was saved.
    LayerCount: word;                       // Number of layers in the document.
    GraphicContents: cardinal;              // A series of flags that helps define the image's graphic contents.
  end;

  TPSPLayerInfoChunk = packed record
    //LayerName: array[0..255] of Char;     // Name of layer (in ASCII text). Has been replaced in version 4
                                            // by a Delphi like short string (length word and variable length string)
    LayerType: byte;                        // Type of layer.
    ImageRectangle,                         // Rectangle defining image border.
    SavedImageRectangle: TRect;             // Rectangle within image rectangle that contains "significant" data
                                            // (only the contents of this rectangle are saved to the file).
    LayerOpacity: byte;                     // Overall layer opacity.
    BlendingMode: byte;                     // Mode to use when blending layer.
    Visible: boolean;                       // TRUE if layer was visible at time of save, FALSE otherwise.
    TransparencyProtected: boolean;         // TRUE if transparency is protected.
    LinkGroupIdentifier: byte;              // Identifies group to which this layer belongs.
    MaskRectangle,                          // Rectangle defining user mask border.
    SavedMaskRectangle: TRect;              // Rectangle within mask rectangle that contains "significant" data
                                            // (only the contents of this rectangle are saved to the file).
    MaskLinked: boolean;                    // TRUE if mask linked to layer (i.e., mask moves relative to layer)
    MaskDisabled: boolean;                  // TRUE if mask is disabled, FALSE otherwise.
    InvertMask: boolean;                    // TRUE if mask should be inverted when the layer is merged, FALSE otherwise.
    BlendRangeCount: word;                  // Number of valid source-destination field pairs to follow (note, there are
                                            // currently always 5 such pairs, but they are not necessarily all valid).
    SourceBlendRange1,                      // First source blend range value.
    DestinationBlendRange1,                 // First destination blend range value.
    SourceBlendRange2,
    DestinationBlendRange2,
    SourceBlendRange3,
    DestinationBlendRange3,
    SourceBlendRange4,
    DestinationBlendRange4,
    SourceBlendRange5,
    DestinationBlendRange5: array[0..3] of byte;
    // these fields are obsolete since file version 4 because there's an own chunk for them
    // BitmapCount: Word;                      // Number of bitmaps to follow.
    // ChannelCount: Word;                     // Number of channels to follow.
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TPSPGraphic.CanLoad(Stream: PStream): boolean;
var Header: TPSPFileHeader;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>sizeof(Header);
  if Result then
    begin
      Stream.Read(Header,sizeof(Header));
      Result:=(StrLIComp(Header.Signature,MagicID,Length(MagicID))=0) and (Header.MajorVersion>=3);
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPSPGraphic.LoadFromStream(Stream: PStream);
var Header: TPSPFileHeader;
    Image: TPSPImageAttributes;
    // to use the code below for file 3 and 4 I read the parts of the block header
    // separately instead as a structure
    HeaderIdentifier: array[0..3] of Char;  // i.e. "~BK" followed by a zero byte
    BlockIdentifier: word;                  // one of the block identifiers
    InitialChunkLength,                     // length of the first sub chunk header or similar
    TotalBlockLength: cardinal;             // length of this block excluding this header
    LastPosition,ChunkSize: cardinal;
    LayerInfo: TPSPLayerInfoChunk;
    ChannelInfo: TPSPChannelInfoChunk;
    LayerName: string;
    NameLength: word;
    NextLayerPosition,
    NextMainBlock: integer;
    // file version 4 specific data
    BitmapCount,ChannelCount: word;
    // load and decoding of image data
    R,G,B,C: PByte;
    RedBuffer,GreenBuffer,BlueBuffer,CompBuffer: pointer;
    X,Y,Index,RowSize: integer; // size in bytes of one scanline
    // other data
    RawPalette: array[0..4*256-1] of byte;

  //--------------- local functions -------------------------------------------
  function ReadBlockHeader: boolean;
  // Fills in the block header variables according to the file version.
  // Returns True if a block header could be read otherwise False (stream end).
  begin
    Result:=Stream.Position<Stream.Size;
    if Result then
      begin
        Stream.Read(HeaderIdentifier,sizeof(HeaderIdentifier));
        Stream.Read(BlockIdentifier,sizeof(BlockIdentifier));
        if Header.MajorVersion=3 then Stream.Read(InitialChunkLength,sizeof(InitialChunkLength));
        Stream.Read(TotalBlockLength,sizeof(TotalBlockLength));
      end;
  end;
  //---------------------------------------------------------------------------
  procedure ReadAndDecompress(Target: pointer);
  // reads a stream of data from file stream and decompresses it into Target
  var RawBuffer,Source: pointer;
      Decoder: TDecoder;
  begin
    Decoder:=nil;
    GetMem(RawBuffer,ChannelInfo.CompressedSize);
    try
      Stream.Read(RawBuffer^,ChannelInfo.CompressedSize);
      // pointer might be advanced while decoding, so use a copy
      Source:=RawBuffer;
      case Image.Compression of
        PSP_COMP_RLE:
          begin
            Decoder:=TPSPRLEDecoder.Create;
            Decoder.Decode(Source,Target,ChannelInfo.CompressedSize,ChannelInfo.UncompressedSize);
          end;
        PSP_COMP_LZ77:
          begin
            Decoder:=TLZ77Decoder.Create(Z_FINISH,False);
            Decoder.DecodeInit;
            Decoder.Decode(Source,Target,ChannelInfo.CompressedSize,ChannelInfo.UncompressedSize);
          end;
        PSP_COMP_JPEG: ; // here just for completeness, used only in thumbnails and composite images
      end;
      Decoder.DecodeEnd;
    finally
      if Assigned(RawBuffer) then FreeMem(RawBuffer);
      Decoder.Free;
    end;
  end;
  //---------------------------------------------------------------------------
  procedure ReadChannelData;
  // Reads the actual data of one channel from the current stream position.
  // Decompression is done by the way.
  begin
    ReadBlockHeader;
    if Header.MajorVersion>3 then Stream.Read(ChunkSize,sizeof(ChunkSize));
    Stream.Read(ChannelInfo,sizeof(ChannelInfo));
    case ChannelInfo.ChannelType of
      PSP_CHANNEL_COMPOSITE: // single channel bitmap (indexed or transparency mask)
        begin
          GetMem(CompBuffer,ChannelInfo.UncompressedSize);
          if Image.Compression<>PSP_COMP_NONE then ReadAndDecompress(CompBuffer) else Stream.Read(CompBuffer^,ChannelInfo.CompressedSize);
        end;
      PSP_CHANNEL_RED:  // red channel of 24 bit bitmap
        begin
          GetMem(RedBuffer,ChannelInfo.UncompressedSize);
          if Image.Compression<>PSP_COMP_NONE then ReadAndDecompress(RedBuffer) else Stream.Read(RedBuffer^,ChannelInfo.CompressedSize);
        end;
      PSP_CHANNEL_GREEN:
        begin
          GetMem(GreenBuffer,ChannelInfo.UncompressedSize);
          if Image.Compression<>PSP_COMP_NONE then ReadAndDecompress(GreenBuffer) else Stream.Read(GreenBuffer^,ChannelInfo.CompressedSize);
        end;
      PSP_CHANNEL_BLUE:
        begin
          GetMem(BlueBuffer,ChannelInfo.UncompressedSize);
          if Image.Compression<>PSP_COMP_NONE then ReadAndDecompress(BlueBuffer) else Stream.Read(BlueBuffer^,ChannelInfo.CompressedSize);
        end;
    end;
  end;
  //--------------- end local functions ---------------------------------------

begin
  FBasePosition:=Stream.Position;
  if ReadImageProperties(Stream,0) then
  begin
    Stream.Position:=FBasePosition;
    RedBuffer:=nil;
    GreenBuffer:=nil;
    BlueBuffer:=nil;
    with FImageProperties do
    try
      // Note: To be robust with future PSP images any reader must be able to skip data
      //       which it doesn't know instead of relying on the size of known structures.
      //       Hence there's some extra work needed with the stream (mainly to keep the
      //       current position before a chunk is read and advancing the stream using the
      //       chunk size field).
      Stream.Read(Header,sizeof(Header));
      // read general image attribute block
      ReadBlockHeader;
      LastPosition:=Stream.Position;
      if Version>3 then Stream.Read(ChunkSize,sizeof(ChunkSize));
      Stream.Read(Image,sizeof(Image));
      Stream.Position:=LastPosition+TotalBlockLength;
      FBitmap:=NewBitmap(Width,Height);
      with Image do
      begin
        ColorManager.SourceOptions:=[];
        ColorManager.SourceBitsPerSample:=BitsPerSample;
        ColorManager.TargetBitsPerSample:=BitsPerSample;
        ColorManager.SourceSamplesPerPixel:=SamplesPerPixel;
        ColorManager.TargetSamplesPerPixel:=SamplesPerPixel;
        ColorManager.SourceColorScheme:=ColorScheme;
        if ColorScheme=csRGB then ColorManager.TargetColorScheme:=csBGR else ColorManager.TargetColorScheme:=ColorScheme;
        FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
      end;
      // set bitmap properties
      RowSize:=0; // make compiler quiet
      case BitsPerSample of
        1: RowSize:=(Image.Width+7) div 8;
        4: RowSize:=Image.Width div 2+1;
        8: RowSize:=Image.Width;
      else
        GraphicExError(2{gesInvalidColorFormat},['PSP']);
      end;
      // go through main blocks and read what is needed
      repeat
        if not ReadBlockHeader then Break;
        NextMainBlock:=Stream.Position+Integer(TotalBlockLength);
        // no more blocks?
        if HeaderIdentifier[0]<>'~' then Break;
        case BlockIdentifier of
          PSP_COMPOSITE_IMAGE_BANK_BLOCK:
            begin
              // composite image block, if present then it must appear before the layer start block
              // and represents a composition of several layers

              // do not need to read anything further
              //Break;
            end;
          PSP_LAYER_START_BLOCK:
            repeat
              if not ReadBlockHeader then Break;
              // calculate start of next (layer) block in case we need to skip this one
              NextLayerPosition:=Stream.Position+Integer(TotalBlockLength);
              // if all layers have been considered the break loop to continue with other blocks if necessary
              if BlockIdentifier<>PSP_LAYER_BLOCK then Break;
              // layer information chunk
              if Version>3 then
              begin
                LastPosition:=Stream.Position;
                Stream.Read(ChunkSize,sizeof(ChunkSize));
                Stream.Read(NameLength,sizeof(NameLength));
                SetLength(LayerName,NameLength);
                if NameLength>0 then Stream.Read(LayerName[1],NameLength);
                Stream.Read(LayerInfo,sizeof(LayerInfo));
                Stream.Position:=LastPosition+ChunkSize;
                // continue only with undefined or raster chunks
                if not (LayerInfo.LayerType in [PSP_LAYER_UNDEFINED,PSP_LAYER_RASTER]) then
                begin
                  Stream.Position:=NextLayerPosition;
                  Continue;
                end;
                // in file version 4 there's also an additional bitmap chunk which replaces
                // two fields formerly located in the LayerInfo chunk
                LastPosition:=Stream.Position;
                Stream.Read(ChunkSize,sizeof(ChunkSize));
              end
              else
              begin
                SetLength(LayerName,256);
                Stream.Read(LayerName[1],256);
                Stream.Read(LayerInfo,sizeof(LayerInfo));
                // continue only with normal (raster) chunks
                if LayerInfo.LayerType<>PSP_LAYER_NORMAL then
                begin
                  Stream.Position:=NextLayerPosition;
                  Continue;
                end;
              end;
              Stream.Read(BitmapCount,sizeof(BitmapCount));
              Stream.Read(ChannelCount,sizeof(ChannelCount));
              // But now we can reliably say whether we have an alpha channel or not.
              // This kind of information can only be read very late and causes us to
              // possibly reallocate the entire image (because it is copied by the VCL
              // when changing the pixel format).
              // I don't know another way (preferably before the size of the image is set).
              if ChannelCount>3 then
              begin
                ColorManager.TargetColorScheme:=csBGRA;
                FBitmap.PixelFormat:=pf32Bit;
              end;
              if Version>3 then Stream.Position:=LastPosition+ChunkSize;
              // allocate memory for all channels and read raw data
              for X:=0 to ChannelCount-1 do ReadChannelData;
              R:=RedBuffer;
              G:=GreenBuffer;
              B:=BlueBuffer;
              C:=CompBuffer;
              if ColorManager.TargetColorScheme in [csIndexed,csG] then
              begin
                for Y:=0 to Height-1 do
                begin
                  ColorManager.ConvertRow([C],FBitmap.ScanLine[Y],Width,$FF);
                  Inc(C,RowSize);
                end;
              end
              else
              begin
                for Y:=0 to Height-1 do
                begin
                  ColorManager.ConvertRow([R,G,B,C],FBitmap.ScanLine[Y],Width,$FF);
                  Inc(R,RowSize);
                  Inc(G,RowSize);
                  Inc(B,RowSize);
                  Inc(C,RowSize);
                end;
              end;
              // after the raster layer has been read there's no need to loop further
              Break;
            until False; // layer loop
          PSP_COLOR_BLOCK:  // color palette block (this is also present for gray scale and b&w images)
            begin
              if Version>3 then Stream.Read(ChunkSize,sizeof(ChunkSize));
              Stream.Read(Index,sizeof(Index));
              Stream.Read(RawPalette,Index*sizeof(TRGBQuad));
              ColorManager.CreateColorPalette(FBitmap,[@RawPalette],pfInterlaced8Quad,Index,True);
            end;
        end;
        // explicitly set stream position to next main block as we might have read a block only partially
        Stream.Position:=NextMainBlock;
      until False; // main block loop
    finally
      if Assigned(RedBuffer) then FreeMem(RedBuffer);
      if Assigned(GreenBuffer) then FreeMem(GreenBuffer);
      if Assigned(BlueBuffer) then FreeMem(BlueBuffer);
    end;
  end
  else GraphicExError(1{gesInvalidImage},['PSP']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPSPGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Header: TPSPFileHeader;
    Image: TPSPImageAttributes;
    // to use the code below for file 3 and 4 I read the parts of the block header
    // separately instead as a structure
    HeaderIdentifier: array[0..3] of Char;  // i.e. "~BK" followed by a zero byte
    BlockIdentifier: word;                  // one of the block identifiers
    InitialChunkLength,                     // length of the first sub chunk header or similar
    TotalBlockLength: cardinal;             // length of this block excluding this header
    LastPosition,ChunkSize: cardinal;

  //--------------- local functions -------------------------------------------
  function ReadBlockHeader: Boolean;
  // Fills in the block header variables according to the file version.
  // Returns True if a block header could be read otherwise False (stream end).
  begin
    Result:=Stream.Position<Stream.Size;
    if Result then
      begin
        Stream.Read(HeaderIdentifier,sizeof(HeaderIdentifier));
        Stream.Read(BlockIdentifier,sizeof(BlockIdentifier));
        if Header.MajorVersion=3 then Stream.Read(InitialChunkLength,sizeof(InitialChunkLength));
        Stream.Read(TotalBlockLength,sizeof(TotalBlockLength));
      end;
  end;
  //--------------- end local functions ---------------------------------------

begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  with FImageProperties do
  begin
    Stream.Read(Header, sizeof(Header));
    if (StrLIComp(Header.Signature,MagicID,Length(MagicID))=0) and (Header.MajorVersion>=3) then
    begin
      Version:=Header.MajorVersion;
      // read general image attribute block
      ReadBlockHeader;
      LastPosition:=Stream.Position;
      if Header.MajorVersion>3 then Stream.Read(ChunkSize,sizeof(ChunkSize));
      Stream.Read(Image,sizeof(Image));
      Stream.Position:=LastPosition+TotalBlockLength;
      if Image.BitDepth=24 then
      begin
        BitsPerSample:=8;
        SamplesPerPixel:=3;
        ColorScheme:=csRGB; // an alpha channel might exist, this is determined by the layer's channel count
      end
      else
      begin
        BitsPerSample:=Image.BitDepth;
        SamplesPerPixel:=1;
        if Image.GreyscaleFlag then ColorScheme:=csG else ColorScheme:=csIndexed;
      end;
      BitsPerPixel:=BitsPerSample*SamplesPerPixel;
      Width:=Image.Width;
      Height:=Image.Height;
      case Image.Compression of
        PSP_COMP_NONE: Compression:=ctNone;
        PSP_COMP_RLE:  Compression:=ctRLE;
        PSP_COMP_LZ77: Compression:=ctLZ77;
        PSP_COMP_JPEG: Compression:=ctJPEG;
      else
        Compression:=ctUnknown;
      end;
      XResolution:=Image.Resolution;
      if Image.ResolutionMetric=PSP_METRIC_CM then XResolution:=XResolution*2.54;
      YResolution:=XResolution;
      Result:=True;
    end;
  end;
end;

//----------------- TPNGGraphic ----------------------------------------------------------------------------------------

const
  PNGMagic: array[0..7] of Byte = (137,80,78,71,13,10,26,10);

  // recognized and handled chunk types
  IHDR = 'IHDR';
  IDAT = 'IDAT';
  IEND = 'IEND';
  PLTE = 'PLTE';
  gAMA = 'gAMA';
  tRNS = 'tRNS';
  bKGD = 'bKGD';

  CHUNKMASK = $20; // used to check bit 5 in chunk types

type
  // The following chunks structures are those which appear in the data field of the general chunk structure
  // given above.

  // chunk type: 'IHDR'
  PIHDRChunk = ^TIHDRChunk;
  TIHDRChunk = packed record
    Width,
    Height: cardinal;
    BitDepth,          // bits per sample (allowed are 1,2,4,8 and 16)
    ColorType,         // combination of:
                       //   1 - palette used
                       //   2 - colors used
                       //   4 - alpha channel used
                       // allowed values are:
                       //   0 - gray scale (allowed bit depths are: 1,2,4,8,16)
                       //   2 - RGB (8,16)
                       //   3 - palette (1,2,4,8)
                       //   4 - gray scale with alpha (8,16)
                       //   6 - RGB with alpha (8,16)
    Compression,       // 0 - LZ77, others are not yet defined
    Filter,            // filter mode 0 is the only one currently defined
    Interlaced: byte;  // 0 - not interlaced, 1 - Adam7 interlaced
  end;

//----------------------------------------------------------------------------------------------------------------------

class function TPNGGraphic.CanLoad(Stream: PStream): boolean;
var Magic: array[0..7] of byte;
    LastPosition: cardinal;
begin
  LastPosition:=Stream.Position;
  Result:=(Stream.Size-Stream.Position)>sizeof(Magic);
  if Result then
    begin
      Stream.Read(Magic,sizeof(Magic));
      Result:=CompareMem(@Magic,@PNGMagic,8);
    end;
  Stream.Position:=LastPosition;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPNGGraphic.IsChunk(ChunkType: TChunkType): boolean;
// determines, independant of the cruxial 5ths bits in each "letter", whether the
// current chunk type in the header is the same as the given chunk type
const
  Mask = not $20202020;
begin
  Result:=(Cardinal(FHeader.ChunkType) and Mask)=(Cardinal(ChunkType) and Mask);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPNGGraphic.LoadAndSwapHeader: cardinal;
// read next chunk header and swap fields to little endian,
// returns the intial CRC value for following checks
begin
  FStream.Read(FHeader,sizeof(FHeader));
  Result:=CRC32(0,@FHeader.ChunkType,4);
  FHeader.Length:=SwapLong(FHeader.Length);
end;

//----------------------------------------------------------------------------------------------------------------------

function PaethPredictor(A,B,C: byte): byte;
var P,PA,PB,PC: integer;
begin
  // a = left, b = above, c = upper left
  P:=A+B-C;            // initial estimate
  PA:=Abs(P-A);      // distances to a, b, c
  PB:=Abs(P-B);
  PC:=Abs(P-C);
  // return nearest of a, b, c, breaking ties in order a, b, c
  if (PA<=PB) and (PA<=PC) then Result:=A else
    if PB<=PC then Result:=B else Result:=C;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.ApplyFilter(Filter: byte; Line,PrevLine,Target: PByte; BPP,BytesPerRow: integer);
// Applies the filter given in Filter to all bytes in Line (eventually using PrevLine).
// Note: The filter type is assumed to be of filter mode 0, as this is the only one currently
//       defined in PNG.
//       In opposition to the PNG documentation different identifiers are used here.
//       Raw refers to the current, not yet decoded value. Decoded refers to the current, already
//       decoded value (this one is called "raw" in the docs) and Prior is the current value in the
//       previous line. For the Paeth prediction scheme a fourth pointer is used (PriorDecoded) to describe
//       the value in the previous line but less the BPP value (Prior[x - BPP]).
var I: integer;
    Raw,Decoded,Prior,PriorDecoded,TargetRun: PByte;
begin
  case Filter of
    0: Move(Line^,Target^,BytesPerRow);  // no filter, just copy data
    1: begin  // subtraction filter
         Raw:=Line;
         TargetRun:=Target;
         // Transfer BPP bytes without filtering. This mimics the effect of bytes left to the
         // scanline being zero.
         Move(Raw^,TargetRun^,BPP);
         // now do rest of the line
         Decoded:=TargetRun;
         Inc(Raw,BPP);
         Inc(TargetRun,BPP);
         Dec(BytesPerRow,BPP);
         while BytesPerRow>0 do
         begin
           TargetRun^:=Byte(Raw^+Decoded^);
           Inc(Raw);
           Inc(Decoded);
           Inc(TargetRun);
           Dec(BytesPerRow);
         end;
       end;
    2: begin  // Up filter
         Raw:=Line;
         Prior:=PrevLine;
         TargetRun:=Target;
         while BytesPerRow>0 do
         begin
           TargetRun^:=Byte(Raw^+Prior^);
           Inc(Raw);
           Inc(Prior);
           Inc(TargetRun);
           Dec(BytesPerRow);
         end;
       end;
    3: begin  // average filter
         // first handle BPP virtual pixels to the left
         Raw:=Line;
         Decoded:=Line;
         Prior:=PrevLine;
         TargetRun:=Target;
         for I:=0 to BPP-1 do
         begin
           TargetRun^:=Byte(Raw^+Floor(Prior^/2));
           Inc(Raw);
           Inc(Prior);
           Inc(TargetRun);
         end;
         Dec(BytesPerRow,BPP);
         // now do rest of line
         while BytesPerRow>0 do
         begin
           TargetRun^:=Byte(Raw^+Floor((Decoded^+Prior^)/2));
           Inc(Raw);
           Inc(Decoded);
           Inc(Prior);
           Inc(TargetRun);
           Dec(BytesPerRow);
         end;
       end;
    4: begin  // paeth prediction
         // again, start with first BPP pixel which would refer to non-existing pixels to the left
         Raw:=Line;
         Decoded:=Target;
         Prior:=PrevLine;
         PriorDecoded:=PrevLine;
         TargetRun:=Target;
         for I:=0 to BPP-1 do
         begin
           TargetRun^:=Byte(Raw^+PaethPredictor(0,Prior^,0));
           Inc(Raw);
           Inc(Prior);
           Inc(TargetRun);
         end;
         Dec(BytesPerRow,BPP);
         // finally do rest of line
         while BytesPerRow>0 do
         begin
           TargetRun^:=Byte(Raw^+PaethPredictor(Decoded^,Prior^,PriorDecoded^));
           Inc(Raw);
           Inc(Decoded);
           Inc(Prior);
           Inc(PriorDecoded);
           Inc(TargetRun);
           Dec(BytesPerRow);
         end;
       end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.LoadFromStream(Stream: PStream);
var Description: TIHDRChunk;
begin
  FBasePosition:=Stream.Position;
  FDecoder:=nil;
  FStream:=Stream;
  if ReadImageProperties(Stream,0) then
  begin
    with FImageProperties do
    begin
      if FBitmap=nil then FBitmap:=NewBitmap(Width,Height);
      Stream.Position:=FBasePosition+8; // skip magic
      FBackgroundColor:=clWhite;
      FTransparentColor:=clNone;
      // first chunk must be an IHDR chunk
      FCurrentCRC:=LoadAndSwapHeader;
      FRawBuffer:=nil;
      ColorManager.SourceOptions:=[coNeedByteSwap];
      try
        // read IHDR chunk
        ReadDataAndCheckCRC;
        Move(FRawBuffer^,Description,sizeof(Description));
        SwapLong(@Description,2);
        // currently only one compression type is supported by PNG (LZ77)
        if Compression=ctLZ77 then
        begin
          FDecoder:=TLZ77Decoder.Create(Z_PARTIAL_FLUSH,False);
          FDecoder.DecodeInit;
        end
        else
          GraphicExError(5{gesUnsupportedFeature},[ErrorMsg[11]{gesCompressionScheme},PNG]);
        // setup is done, now go for the chunks
        repeat
          FCurrentCRC:=LoadAndSwapHeader;
          if IsChunk(IDAT) then
          begin
            LoadIDAT(Description);
            // After reading the image data the next chunk header has already been loaded
            // so continue with code below instead trying to load a new chunk header.
          end
          else
            if IsChunk(PLTE) then
            begin
              // palette chunk
              if (FHeader.Length mod 3)<>0 then GraphicExError(9{gesInvalidPalette},[PNG]);
              ReadDataAndCheckCRC;
              // load palette only if the image is indexed colors
              if Description.ColorType=3 then
              begin
                // first setup pixel format before actually creating a palette
                FSourceBPP:=SetupColorDepth(Description.ColorType,Description.BitDepth);
                ColorManager.CreateColorPalette(FBitmap,[FRawBuffer],pfInterlaced8Triple,FHeader.Length div 3,True);
              end;
              Continue;
            end
            else
              if IsChunk(gAMA) then
              begin
                ReadDataAndCheckCRC;
                // the file gamme given here is a scaled cardinal (e.g. 0.45 is expressed as 45000)
                ColorManager.SetGamma(SwapLong(PCardinal(FRawBuffer)^)/100000);
                ColorManager.TargetOptions:=ColorManager.TargetOptions+[coApplyGamma];
                Include(Options,ioUseGamma);
                Continue;
              end
              else
                if IsChunk(bKGD) then
                begin
                  LoadBackgroundColor(Description);
                  Continue;
                end
                else
                  if IsChunk(tRNS) then
                  begin
                    LoadTransparency(Description);
                    Continue;
                  end;
          // Skip unknown or unsupported chunks (+4 because of always present CRC).
          // IEND will be skipped as well, but this chunk is empty, so the stream will correctly
          // end on the first byte after the IEND chunk.
          Stream.Seek(FHeader.Length+4,spCurrent);
          if IsChunk(IEND) then Break;
          // Note: According to the specs an unknown, but as critical marked chunk is a fatal error.
          if (Byte(FHeader.ChunkType[0]) and CHUNKMASK)=0 then GraphicExError(10{gesUnknownCriticalChunk});
        until False;
      finally
        if Assigned(FDecoder) then
        begin
          FDecoder.DecodeEnd;
          FDecoder.Free;
        end;
        if Assigned(FRawBuffer) then FreeMem(FRawBuffer);
      end;
    end;
  end
  else GraphicExError(1{gesInvalidImage},[PNG]);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPNGGraphic.ReadImageProperties(Stream: PStream; ImageIndex: cardinal): boolean;
var Magic: array[0..7] of byte;
    Description: TIHDRChunk;
begin
  Result:=inherited ReadImageProperties(Stream,ImageIndex);
  FStream:=Stream;
  with FImageProperties do
  begin
    Stream.Read(Magic,8);
    if CompareMem(@Magic,@PNGMagic,8) then
    begin
      // first chunk must be an IHDR chunk
      FCurrentCRC:=LoadAndSwapHeader;
      if IsChunk(IHDR) then
      begin
        Include(Options,ioBigEndian);
        // read IHDR chunk
        ReadDataAndCheckCRC;
        Move(FRawBuffer^,Description,sizeof(Description));
        SwapLong(@Description,2);
        if (Description.Width=0) or (Description.Height=0) then Exit;
        Width:=Description.Width;
        Height:=Description.Height;
        if Description.Compression=0 then Compression:=ctLZ77 else Compression:=ctUnknown;
        BitsPerSample:=Description.BitDepth;
        SamplesPerPixel:=1;
        case Description.ColorType of
          0: ColorScheme:=csG;
          2: begin
               ColorScheme:=csRGB;
               SamplesPerPixel:=3;
             end;
          3: ColorScheme:=csIndexed;
          4: ColorScheme:=csGA;
          6: begin
               ColorScheme:=csRGBA;
               SamplesPerPixel:=4;
             end;
        else ColorScheme:=csUnknown;
        end;
        BitsPerPixel:=SamplesPerPixel*BitsPerSample;
        FilterMode:=Description.Filter;
        Interlaced:=Description.Interlaced<>0;
        HasAlpha:=ColorScheme in [csGA,csRGBA,csBGRA];
        // find gamma
        repeat
          FCurrentCRC:=LoadAndSwapHeader;
          if IsChunk(gAMA) then
          begin
            ReadDataAndCheckCRC;
            // the file gamme given here is a scaled cardinal (e.g. 0.45 is expressed as 45000)
            FileGamma:=SwapLong(PCardinal(FRawBuffer)^)/100000;
            Break;
          end;
          Stream.Seek(FHeader.Length+4,spCurrent);
          if IsChunk(IEND) then Break;
        until False;
        Result:=True;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.LoadBackgroundColor(const Description);
// loads the data from the current chunk (must be a bKGD chunk) and fills the bitmpap with that color
var Run: PWord;
    R,G,B: byte;
begin
  ReadDataAndCheckCRC;
  with TIHDRChunk(Description) do
  begin
    case ColorType of
      0,4: // G(A)
        begin
          case BitDepth of
             2: FBackgroundColor:=MulDiv16(System.Swap(PWord(FRawBuffer)^),15,3);
            16: FBackgroundColor:=MulDiv16(System.Swap(PWord(FRawBuffer)^),255,65535);
          else // 1,4,8 bits gray scale
            FBackgroundColor:=Byte(System.Swap(PWord(FRawBuffer)^));
          end;
        end;
      2,6:  // RGB(A)
        begin
          Run:=FRawBuffer;
          if BitDepth=16 then
          begin
            R:=MulDiv16(System.Swap(Run^),255,65535);
            Inc(Run);
            G:=MulDiv16(System.Swap(Run^),255,65535);
            Inc(Run);
            B:=MulDiv16(System.Swap(Run^),255,65535);
          end
          else
          begin
            R:=Byte(System.Swap(Run^));
            Inc(Run);
            G:=Byte(System.Swap(Run^));
            Inc(Run);
            B:=Byte(System.Swap(Run^));
          end;
          FBackgroundColor:=Windows.RGB(R,G,B);
        end;
    else // indexed color scheme (3)
      FBackgroundColor:=PByte(FRawBuffer)^;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.LoadIDAT(const Description);
// loads image data from the current position of the stream
const
  // interlace start and offsets
  RowStart: array[0..6] of integer = (0,0,4,0,2,0,1);
  ColumnStart: array[0..6] of integer = (0,4,0,2,0,1,0);
  RowIncrement: array[0..6] of integer = (8,8,8,4,4,2,2);
  ColumnIncrement: array[0..6] of integer = (8,8,4,4,2,2,1);
  PassMask: array[0..6] of byte = ($80,$08,$88,$22,$AA,$55,$FF);
var Row: Integer;
    TargetBPP: integer;
    RowBuffer: array[Boolean] of PChar; // I use PChar here instead of simple pointer to ease pointer math below
    EvenRow: boolean; // distincts between the two rows we need to hold for filtering
    Pass,BytesPerRow,InterlaceRowBytes,InterlaceWidth: integer;
begin
  RowBuffer[False]:=nil;
  RowBuffer[True]:=nil;
  try
    // we can set the dimensions too without
    // initiating color conversions
    if FBitmap=nil then FBitmap:=NewBitmap(TIHDRChunk(Description).Width,TIHDRChunk(Description).Height);
    // adjust pixel format etc. if not yet done
    if FBitmap.PixelFormat=pfDevice then FSourceBPP:=SetupColorDepth(TIHDRChunk(Description).ColorType,TIHDRChunk(Description).BitDepth);
    if TIHDRChunk(Description).BitDepth=16 then TargetBPP:=FSourceBPP div 2 else TargetBPP:=FSourceBPP;
    // set background and transparency color, these values must be set after the
    // bitmap is actually valid (although, not filled)
    FBitmap.Canvas.Brush.Color:=FBackgroundColor;
    FBitmap.Canvas.FillRect(Rect(0,0,FBitmap.Width,FBitmap.Height));
    // determine maximum number of bytes per row and consider there's one filter byte at the start of each row
    BytesPerRow:=TargetBPP*((FBitmap.Width*TIHDRChunk(Description).BitDepth+7) div 8)+1;
    RowBuffer[True]:=AllocMem(BytesPerRow);
    RowBuffer[False]:=AllocMem(BytesPerRow);
    // there can be more than one IDAT chunk in the file but then they must directly
    // follow each other (handled in ReadRow)
    EvenRow:=True;
    // prepare interlaced images
    if TIHDRChunk(Description).Interlaced=1 then
    begin
      for Pass:=0 to 6 do
      begin
        // prepare next interlace run
        if FBitmap.Width<=ColumnStart[Pass] then Continue;
        InterlaceWidth:=(FBitmap.Width+ColumnIncrement[Pass]-1-ColumnStart[Pass]) div ColumnIncrement[Pass];
        InterlaceRowBytes:=TargetBPP*((InterlaceWidth*TIHDRChunk(Description).BitDepth+7) div 8)+1;
        Row:=RowStart[Pass];
        while Row<FBitmap.Height do
        begin
          ReadRow(RowBuffer[EvenRow],InterlaceRowBytes);
          ApplyFilter(Byte(RowBuffer[EvenRow]^),Pointer(RowBuffer[EvenRow]+1),
                      Pointer(RowBuffer[not EvenRow]+1),Pointer(RowBuffer[EvenRow]+1),
                      FSourceBPP,InterlaceRowBytes-1);
          ColorManager.ConvertRow([Pointer(RowBuffer[EvenRow]+1)],FBitmap.ScanLine[Row],FBitmap.Width,PassMask[Pass]);
          EvenRow:=not EvenRow;
          // continue with next row in interlaced order
          Inc(Row,RowIncrement[Pass]);
        end;
      end;
    end
    else
    begin
      for Row:=0 to FBitmap.Height-1 do
      begin
        ReadRow(RowBuffer[EvenRow],BytesPerRow);
        ApplyFilter(Byte(RowBuffer[EvenRow]^),Pointer(RowBuffer[EvenRow]+1),
                    Pointer(RowBuffer[not EvenRow]+1),Pointer(RowBuffer[EvenRow]+1),
                    FSourceBPP,BytesPerRow-1);
        ColorManager.ConvertRow([Pointer(RowBuffer[EvenRow]+1)],FBitmap.ScanLine[Row],FBitmap.Width,$FF);
        EvenRow:=not EvenRow;
      end;
    end;
    // in order to improve safe failness we read all remaining but not read IDAT chunks here
    while IsChunk(IDAT) do
    begin
      ReadDataAndCheckCRC;
      FCurrentCRC:=LoadAndSwapHeader;
    end;
  finally
    if Assigned(RowBuffer[True]) then FreeMem(RowBuffer[True]);
    if Assigned(RowBuffer[False]) then FreeMem(RowBuffer[False]);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.LoadTransparency(const Description);
// reads the data of the current transparency chunk
var Run: PWord;
    R,G,B: byte;
begin
  ReadDataAndCheckCRC;
  with TIHDRChunk(Description) do
  begin
    case ColorType of
      0: // gray
        begin
          case BitDepth of
             2: R:=MulDiv16(System.Swap(PWord(FRawBuffer)^),15,3);
            16: R:=MulDiv16(System.Swap(PWord(FRawBuffer)^),255,65535);
          else // 1,4,8 bits gray scale
            R:=Byte(System.Swap(PWord(FRawBuffer)^));
          end;
          FTransparentColor:=Windows.RGB(R,R,R);
        end;
      2:  // RGB
        begin
          Run:=FRawBuffer;
          if BitDepth=16 then
          begin
            R:=MulDiv16(System.Swap(Run^),255,65535);
            Inc(Run);
            G:=MulDiv16(System.Swap(Run^),255,65535);
            Inc(Run);
            B:=MulDiv16(System.Swap(Run^),255,65535);
          end
          else
          begin
            R:=Byte(System.Swap(Run^));
            Inc(Run);
            G:=Byte(System.Swap(Run^));
            Inc(Run);
            B:=Byte(System.Swap(Run^));
          end;
          FTransparentColor:=Windows.RGB(R,G,B);
        end;
      4,6:
        // formats with full alpha channel, they shouldn't have a transparent color
    else
      // Indexed color scheme (3), with at most 256 alpha values (for each palette entry).
      SetLength(FTransparency,255);
      // read the values (at most 256)...
      Move(FRawBuffer^,FTransparency[0],MaxMax(FHeader.Length,256));
      // ...and set default values (255, fully opaque) for non-supplied values
      if FHeader.Length<256 then FillChar(FTransparency[FHeader.Length],256-FHeader.Length,$FF);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.ReadDataAndCheckCRC;
// Allocates memory in FRawBuffer and reads the next Header.Length bytes from Stream.
// Furthermore, the CRC value following the data is read as well and compared with
// the CRC value which is calculated here.
var FileCRC: cardinal;
begin
  ReallocMem(FRawBuffer,FHeader.Length);
  FStream.Read(FRawBuffer^,FHeader.Length);
  FStream.Read(FileCRC,sizeof(FileCRC));
  FileCRC:=SwapLong(FileCRC);
  // The type field of a chunk is included in the CRC, this serves as initial value
  // for the calculation here and is determined in LoadAndSwapHeader.
  FCurrentCRC:=CRC32(FCurrentCRC,FRawBuffer,FHeader.Length);
  if FCurrentCRC<>FileCRC then GraphicExError(6{gesInvalidCRC},[PNG]);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPNGGraphic.ReadRow(RowBuffer: pointer; BytesPerRow: integer);
// reads and decodes one scanline
var LocalBuffer: pointer;
    PendingOutput: integer;
begin
  LocalBuffer:=RowBuffer;
  PendingOutput:=BytesPerRow;
  repeat
    // read pending chunk data if available input has dropped to zero
    if FDecoder.AvailableInput=0 then
    begin
      FIDATSize:=0;
      // read all following chunks until enough data is available or there is no further IDAT chunk
      while FIDATSize=0 do
      begin
        // finish if the current chunk is not an IDAT chunk
        if not IsChunk(IDAT) then Exit;
        ReadDataAndCheckCRC;
        FCurrentSource:=FRawBuffer;
        FIDATSize:=FHeader.Length;
        // prepare next chunk (plus CRC)
        FCurrentCRC:=LoadAndSwapHeader;
      end;
    end;
    // this decode call will advance Source and Target accordingly
    FDecoder.Decode(FCurrentSource,LocalBuffer,
                    FIDATSize-(Integer(FCurrentSource)-Integer(FRawBuffer)),
                    PendingOutput);
    if FDecoder.ZLibResult=Z_STREAM_END then
    begin
       if (FDecoder.AvailableOutput<>0) or (FDecoder.AvailableInput<>0) then GraphicExError(8{gesExtraCompressedData},[PNG]);
      Break;
    end;
    if FDecoder.ZLibResult<>Z_OK then GraphicExError(7{gesCompression},[PNG]);
    PendingOutput:=BytesPerRow-(Integer(LocalBuffer)-Integer(RowBuffer));
  until PendingOutput=0;
end;

//----------------------------------------------------------------------------------------------------------------------

function TPNGGraphic.SetupColorDepth(ColorType,BitDepth: integer): integer;
begin
  Result:=0;
  // determine color scheme and setup related stuff,
  // Note: The calculated BPP value is always at least 1 even for 1 bits per pixel etc. formats
  //       and used in filter calculation.
  case ColorType of
    0: // gray scale (allowed bit depths are: 1, 2, 4, 8, 16 bits)
      if BitDepth in [1,2,4,8,16] then
        begin
          ColorManager.SourceColorScheme:=csG;
          ColorManager.TargetColorScheme:=csG;
          ColorManager.SourceSamplesPerPixel:=1;
          ColorManager.TargetSamplesPerPixel:=1;
          ColorManager.SourceBitsPerSample:=BitDepth;
          // 2 bits values are converted to 4 bits values because DIBs don't know the former variant
          case BitDepth of
             2: ColorManager.TargetBitsPerSample:=4;
            16: ColorManager.TargetBitsPerSample:=8;
          else
            ColorManager.TargetBitsPerSample:=BitDepth;
          end;
          FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
          ColorManager.CreateGrayscalePalette(FBitmap,False);
          Result:=(BitDepth+7) div 8;
        end
      else GraphicExError(2{gesInvalidColorFormat},[PNG]);
    2: // RGB
      if BitDepth in [8,16] then
        begin
          ColorManager.SourceSamplesPerPixel:=3;
          ColorManager.TargetSamplesPerPixel:=3;
          ColorManager.SourceColorScheme:=csRGB;
          ColorManager.TargetColorScheme:=csBGR;
          ColorManager.SourceBitsPerSample:=BitDepth;
          ColorManager.TargetBitsPerSample:=8;
          FBitmap.PixelFormat:=pf24Bit;
          Result:=BitDepth*3 div 8;
        end
      else GraphicExError(2{gesInvalidColorFormat},[PNG]);
    3: // palette
      if BitDepth in [1,2,4,8] then
        begin
          ColorManager.SourceColorScheme:=csIndexed;
          ColorManager.TargetColorScheme:=csIndexed;
          ColorManager.SourceSamplesPerPixel:=1;
          ColorManager.TargetSamplesPerPixel:=1;
          ColorManager.SourceBitsPerSample:=BitDepth;
          // 2 bits values are converted to 4 bits values because DIBs don't know the former variant
          if BitDepth=2 then ColorManager.TargetBitsPerSample:=4 else ColorManager.TargetBitsPerSample:=BitDepth;
          FBitmap.PixelFormat:=ColorManager.TargetPixelFormat;
          Result:=1;
        end
      else GraphicExError(2{gesInvalidColorFormat},[PNG]);
    4: // gray scale with alpha,
       // For the moment this format is handled without alpha, but might later be converted
       // to RGBA with gray pixels or use a totally different approach.
      if BitDepth in [8,16] then
        begin
          ColorManager.SourceSamplesPerPixel:=1;
          ColorManager.TargetSamplesPerPixel:=1;
          ColorManager.SourceBitsPerSample:=BitDepth;
          ColorManager.TargetBitsPerSample:=8;
          ColorManager.SourceColorScheme:=csGA;
          ColorManager.TargetColorScheme:=csIndexed;
          FBitmap.PixelFormat:=pf8Bit;
          ColorManager.CreateGrayScalePalette(FBitmap,False);
          Result:=2*BitDepth div 8;
        end
      else GraphicExError(2{gesInvalidColorFormat},[PNG]);
    6: // RGB with alpha (8, 16)
      if BitDepth in [8,16] then
        begin
          ColorManager.SourceSamplesPerPixel:=4;
          ColorManager.TargetSamplesPerPixel:=4;
          ColorManager.SourceColorScheme:=csRGBA;
          ColorManager.TargetColorScheme:=csBGRA;
          ColorManager.SourceBitsPerSample:=BitDepth;
          ColorManager.TargetBitsPerSample:=8;
          FBitmap.PixelFormat:=pf32Bit;
          Result:=BitDepth*4 div 8;
        end
      else GraphicExError(2{gesInvalidColorFormat},[PNG]);
  else
    GraphicExError(2{gesInvalidColorFormat},[PNG]);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

end.

