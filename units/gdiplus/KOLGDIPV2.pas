{-----------------------------------------------------------------------------
 Unit Name: KOLGDIPV2
 Author:    Thaddy de Koning (somewhat), based on work by Dave Jewell for
            PCPRO April, May 2002 and Delphi Magazine 80 and 81
            Adapted for kol by Thaddy de Koning
 Purpose:   Highlevel objects library for KOL to work with GDIPLUS.DLL
            (Native to XP but available for ilder platforms at microsoft)
 History:   March 17, 2003: version 1.00
            March 22, 2003: version 2.00 added imagehanding
-----------------------------------------------------------------------------}


unit KOLGDIPV2;

interface

uses Windows ,KOL{$IFDEF USE_ERR},ERR{$ENDIF};
type
Terror=type cardinal;
const
    AliceBlue            = $FFF0F8FF;
    AntiqueWhite         = $FFFAEBD7;
    Aqua                 = $FF00FFFF;
    Aquamarine           = $FF7FFFD4;
    Azure                = $FFF0FFFF;
    Beige                = $FFF5F5DC;
    Bisque               = $FFFFE4C4;
    Black                = $FF000000;
    BlanchedAlmond       = $FFFFEBCD;
    Blue                 = $FF0000FF;
    BlueViolet           = $FF8A2BE2;
    Brown                = $FFA52A2A;
    BurlyWood            = $FFDEB887;
    CadetBlue            = $FF5F9EA0;
    Chartreuse           = $FF7FFF00;
    Chocolate            = $FFD2691E;
    Coral                = $FFFF7F50;
    CornflowerBlue       = $FF6495ED;
    Cornsilk             = $FFFFF8DC;
    Crimson              = $FFDC143C;
    Cyan                 = $FF00FFFF;
    DarkBlue             = $FF00008B;
    DarkCyan             = $FF008B8B;
    DarkGoldenrod        = $FFB8860B;
    DarkGray             = $FFA9A9A9;
    DarkGreen            = $FF006400;
    DarkKhaki            = $FFBDB76B;
    DarkMagenta          = $FF8B008B;
    DarkOliveGreen       = $FF556B2F;
    DarkOrange           = $FFFF8C00;
    DarkOrchid           = $FF9932CC;
    DarkRed              = $FF8B0000;
    DarkSalmon           = $FFE9967A;
    DarkSeaGreen         = $FF8FBC8B;
    DarkSlateBlue        = $FF483D8B;
    DarkSlateGray        = $FF2F4F4F;
    DarkTurquoise        = $FF00CED1;
    DarkViolet           = $FF9400D3;
    DeepPink             = $FFFF1493;
    DeepSkyBlue          = $FF00BFFF;
    DimGray              = $FF696969;
    DodgerBlue           = $FF1E90FF;
    Firebrick            = $FFB22222;
    FloralWhite          = $FFFFFAF0;
    ForestGreen          = $FF228B22;
    Fuchsia              = $FFFF00FF;
    Gainsboro            = $FFDCDCDC;
    GhostWhite           = $FFF8F8FF;
    Gold                 = $FFFFD700;
    Goldenrod            = $FFDAA520;
    Gray                 = $FF808080;
    Green                = $FF008000;
    GreenYellow          = $FFADFF2F;
    Honeydew             = $FFF0FFF0;
    HotPink              = $FFFF69B4;
    IndianRed            = $FFCD5C5C;
    Indigo               = $FF4B0082;
    Ivory                = $FFFFFFF0;
    Khaki                = $FFF0E68C;
    Lavender             = $FFE6E6FA;
    LavenderBlush        = $FFFFF0F5;
    LawnGreen            = $FF7CFC00;
    LemonChiffon         = $FFFFFACD;
    LightBlue            = $FFADD8E6;
    LightCoral           = $FFF08080;
    LightCyan            = $FFE0FFFF;
    LightGoldenrodYellow = $FFFAFAD2;
    LightGray            = $FFD3D3D3;
    LightGreen           = $FF90EE90;
    LightPink            = $FFFFB6C1;
    LightSalmon          = $FFFFA07A;
    LightSeaGreen        = $FF20B2AA;
    LightSkyBlue         = $FF87CEFA;
    LightSlateGray       = $FF778899;
    LightSteelBlue       = $FFB0C4DE;
    LightYellow          = $FFFFFFE0;
    Lime                 = $FF00FF00;
    LimeGreen            = $FF32CD32;
    Linen                = $FFFAF0E6;
    Magenta              = $FFFF00FF;
    Maroon               = $FF800000;
    MediumAquamarine     = $FF66CDAA;
    MediumBlue           = $FF0000CD;
    MediumOrchid         = $FFBA55D3;
    MediumPurple         = $FF9370DB;
    MediumSeaGreen       = $FF3CB371;
    MediumSlateBlue      = $FF7B68EE;
    MediumSpringGreen    = $FF00FA9A;
    MediumTurquoise      = $FF48D1CC;
    MediumVioletRed      = $FFC71585;
    MidnightBlue         = $FF191970;
    MintCream            = $FFF5FFFA;
    MistyRose            = $FFFFE4E1;
    Moccasin             = $FFFFE4B5;
    NavajoWhite          = $FFFFDEAD;
    Navy                 = $FF000080;
    OldLace              = $FFFDF5E6;
    Olive                = $FF808000;
    OliveDrab            = $FF6B8E23;
    Orange               = $FFFFA500;
    OrangeRed            = $FFFF4500;
    Orchid               = $FFDA70D6;
    PaleGoldenrod        = $FFEEE8AA;
    PaleGreen            = $FF98FB98;
    PaleTurquoise        = $FFAFEEEE;
    PaleVioletRed        = $FFDB7093;
    PapayaWhip           = $FFFFEFD5;
    PeachPuff            = $FFFFDAB9;
    Peru                 = $FFCD853F;
    Pink                 = $FFFFC0CB;
    Plum                 = $FFDDA0DD;
    PowderBlue           = $FFB0E0E6;
    Purple               = $FF800080;
    Red                  = $FFFF0000;
    RosyBrown            = $FFBC8F8F;
    RoyalBlue            = $FF4169E1;
    SaddleBrown          = $FF8B4513;
    Salmon               = $FFFA8072;
    SandyBrown           = $FFF4A460;
    SeaGreen             = $FF2E8B57;
    SeaShell             = $FFFFF5EE;
    Sienna               = $FFA0522D;
    Silver               = $FFC0C0C0;
    SkyBlue              = $FF87CEEB;
    SlateBlue            = $FF6A5ACD;
    SlateGray            = $FF708090;
    Snow                 = $FFFFFAFA;
    SpringGreen          = $FF00FF7F;
    SteelBlue            = $FF4682B4;
    Tan                  = $FFD2B48C;
    Teal                 = $FF008080;
    Thistle              = $FFD8BFD8;
    Tomato               = $FFFF6347;
    Transparent          = $00FFFFFF;
    Turquoise            = $FF40E0D0;
    Violet               = $FFEE82EE;
    Wheat                = $FFF5DEB3;
    White                = $FFFFFFFF;
    WhiteSmoke           = $FFF5F5F5;
    Yellow               = $FFFFFF00;
    YellowGreen          = $FF9ACD32;

    BlueShift            = 0;
    GreenShift           = 8;
    RedShift             = 16;
    AlphaShift           = 24;
    AlphaMask            = $ff000000;
    ColorMask	         = $00ffffff;

type
{$IFDEF USE_ERR}
    EGDIPlus = class (Exception);
{$ENDIF}

    TRectF = record
        X: Single;
        Y: Single;
        Width: Single;
        Height: Single;
    end;

    TGPPenType      = ( PenTypeSolidColor, PenTypeHatchFill, PenTypeTextureFill, PenTypePathGradient, PenTypeLinearGradient );
    TGPPenDashStyle = ( DashStyleSolid, DashStyleDash, DashStyleDot, DashStyleDashDot, DashStyleDashDotDot, DashStyleCustom );
    TGPPenLineJoin  = ( LineJoinMiter, LineJoinBevel, LineJoinRound, LineJoinMiterClipped );

    pGPBrush = ^TGPBrush;
    pGPImage = ^TGPImage;

    pGPPen=^TGPPen;
    TGPPen = object(TObj)
    private
        fHandle: Integer;
        function GetColor: Cardinal;
        procedure SetColor (Value: Cardinal);
        function GetWidth: Integer;
        procedure SetWidth (Value: Integer);
        function GetDashStyle: TGPPenDashStyle;
        procedure SetDashStyle (Value: TGPPenDashStyle);
        function GetDashOffset: Integer;
        procedure SetDashOffset (Value: Integer);
        function GetLineJoin: TGPPenLineJoin;
        procedure SetLineJoin (Value: TGPPenLineJoin);
        function GetMiterLimit: Integer;
        procedure SetMiterLimit (Value: Integer);
        procedure SetBrush (Value: pGPBrush);
    public
//        constructor Create (Color: Cardinal; Width: Integer = 1);
        destructor Destroy; virtual;
        function GetType: TGPPenType;
        procedure SetDashPattern (A: array of Single);
        procedure SetCompoundArray (A: array of Single);
        property Handle: Integer read fHandle;
        property Color: Cardinal read GetColor write SetColor;
        property Width: Integer read GetWidth write SetWidth;
        property DashStyle: TGPPenDashStyle read GetDashStyle write SetDashStyle;
        property DashOffset: Integer read GetDashOffset write SetDashOffset;
        property LineJoin: TGPPenLineJoin read GetLineJoin write SetLineJoin;
        property MiterLimit: Integer read GetMiterLimit write SetMiterLimit;
        property Brush: pGPBrush write SetBrush;
    end;

    TGPBrushType = ( BrushTypeSolidColor, BrushTypeHatchFill, BrushTypeTextureFill, BrushTypePathGradient, BrushTypeLinearGradient );

    TGPBrush = object(TObj)
    protected
        fHandle: Integer;
    public
        destructor Destroy; virtual;
        function GetType: TGPBrushType;
        property Handle: Integer read fHandle;
    end;

    pGPSolidBrush=^TGPSolidBrush;
    TGPSolidBrush = object(TGPBrush)
    private
        function GetColor: Cardinal;
        procedure SetColor (Value: Cardinal);
    public
//        constructor Create (Color: Cardinal);
        property Color: Cardinal read GetColor write SetColor;
    end;

    TGPHatchBrushStyle = ( HatchStyleHorizontal, HatchStyleVertical, HatchStyleForwardDiagonal,
                         HatchStyleBackwardDiagonal, HatchStyleCross, HatchStyleLargeGrid = 4,
                         HatchStyleDiagonalCross,HatchStyle05Percent, HatchStyle10Percent,
                         HatchStyle20Percent, HatchStyle25Percent, HatchStyle30Percent,
                         HatchStyle40Percent, HatchStyle50Percent, HatchStyle60Percent,
                         HatchStyle70Percent, HatchStyle75Percent, HatchStyle80Percent,
                         HatchStyle90Percent, HatchStyleLightDownwardDiagonal,
                         HatchStyleLightUpwardDiagonal, HatchStyleDarkDownwardDiagonal,
                         HatchStyleDarkUpwardDiagonal, HatchStyleWideDownwardDiagonal,
                         HatchStyleWideUpwardDiagonal, HatchStyleLightVertical,
                         HatchStyleLightHorizontal, HatchStyleNarrowVertical,
                         HatchStyleNarrowHorizontal, HatchStyleDarkVertical,
                         HatchStyleDarkHorizontal, HatchStyleDashedDownwardDiagonal,
                         HatchStyleDashedUpwardDiagonal, HatchStyleDashedHorizontal,
                         HatchStyleDashedVertical, HatchStyleSmallConfetti, HatchStyleLargeConfetti,
                         HatchStyleZigZag, HatchStyleWave, HatchStyleDiagonalBrick,
                         HatchStyleHorizontalBrick, HatchStyleWeave, HatchStylePlaid, HatchStyleDivot,
                         HatchStyleDottedGrid, HatchStyleDottedDiamond, HatchStyleShingle,
                         HatchStyleTrellis, HatchStyleSphere, HatchStyleSmallGrid,
                         HatchStyleSmallCheckerBoard, HatchStyleLargeCheckerBoard,
                         HatchStyleOutlinedDiamond, HatchStyleSolidDiamond );

    pGPHatchBrush=^TGPHatchBrush;
    TGPHatchBrush = object(TGPBrush)
    private
        function GetHatchStyle: TGPHatchBrushStyle;
        function GetForeColor: Cardinal;
        function GetBackColor: Cardinal;
    public
//        constructor Create (Style: TGPHatchBrushStyle; ForeColor: Cardinal = White; BackColor: Cardinal = Black);
        property HatchStyle: TGPHatchBrushStyle read GetHatchStyle;
        property ForeColor: Cardinal read GetForeColor;
        property BackColor: Cardinal read GetBackColor;
    end;

    TGPLinearGradientBrushMode = ( LinearGradientModeHorizontal,
                                   LinearGradientModeVertical,
                                   LinearGradientModeForwardDiagonal,
                                   LinearGradientModeBackwardDiagonal );

    TGPBrushWrapMode = ( WrapModeTile, WrapModeTileFlipX, WrapModeTileFlipY,
                         WrapModeTileFlipXY, WrapModeClamp );

    pGPLinearGradientBrush=^TGPLinearGradientBrush;
    TGPLinearGradientBrush = object(TGPBrush)
    public
//        constructor Create (const ARect: TRect; Color1, Color2: Cardinal; Mode: TGPLinearGradientBrushMode = LinearGradientModeHorizontal);
    end;

    pGPTextureBrush=^TGPTextureBrush;

    TGPTextureBrush = object (TGPBrush)
    public
//        constructor Create (Image: pGPImage; WrapMode: TGPBrushWrapMode = WrapModeTile);
    end;

    TGPImageFlipMode = ( RotateNoneFlipNone, Rotate90FlipNone, Rotate180FlipNone,
                         Rotate270FlipNone, RotateNoneFlipX, Rotate90FlipX,
                         Rotate180FlipX, Rotate270FlipX );

    TGPColorRemapCategory = ( ColorAdjustTypeDefault, ColorAdjustTypeBitmap,
                              ColorAdjustTypeBrush, ColorAdjustTypePen,
                              ColorAdjustTypeText, ColorAdjustTypeCount,
                              ColorAdjustTypeAny );


    pGPImageAttributes=^TGPImageAttributes;
    TGPImageAttributes = object (TObj)
    private
        fHandle: Integer;
    public
//        constructor Create;
        destructor Destroy; virtual;
        procedure SetColorRemapTable (const A: array of Cardinal; Category: TGPColorRemapCategory = ColorAdjustTypeDefault);
        procedure SetColorKey (const A: array of Cardinal; Category: TGPColorRemapCategory = ColorAdjustTypeDefault);
    end;

    TGPImageType   = ( ImageUnknown, ImageBitmap, ImageMetaFile );

    TGPImageFormat = ( ImageUndefined, ImageMemoryBMP, ImageBMP, ImageEMF, ImageWMF,
                       ImageJPEG, ImagePNG, ImageGIF, ImageTIFF, ImageEXIF, ImagePhotoCD,
                       ImageFlashPIX, ImageIcon );

    TGPImage = object(TObj)
    private
        fHandle: Integer;
        fFrameCount: array [0..2] of Integer;
        fCurrentFrame: array [0..2] of Integer;
        function GetWidth: Integer;
        function GetHeight: Integer;
        function GetImageType: TGPImageType;
        function GetImageFormat: TGPImageFormat;
        procedure ReadImageInfo;
        procedure SetFrame (Index: Integer; Value: Integer);
        function GetProperty (PropID, PropType: Integer): Pointer;
    public
//        constructor Create (const FileName: String; UseECM: Boolean = False);
        destructor Destroy; virtual;
        procedure Flip (FlipMode: TGPImageFlipMode);
        function CanAnimate: Boolean;
        function FrameDelay (FrameNum: Integer): Integer;
        property Width: Integer read GetWidth;
        property Height: Integer read GetHeight;
        property ImageType: TGPImageType read GetImageType;
        property ImageFormat: TGPImageFormat read GetImageFormat;
        property NumTimeFrames: Integer index 0 read fFrameCount[0];
        property NumResolutionFrames: Integer index 1 read fFrameCount[1];
        property NumPageFrames: Integer index 2 read fFrameCount[2];
        property TimeFrame: Integer index 0 read fCurrentFrame[0] write SetFrame;
        property ResolutionFrame: Integer index 1 read fCurrentFrame[1] write SetFrame;
        property PageFrame: Integer index 2 read fCurrentFrame[2] write SetFrame;
    end;

    pGPFont=^TGPFont;
    TGPFont = object(TObj)
    private
        fHandle: Integer;
        procedure InternalCreate (Font: hFont);
    public
//        constructor Create (Font: HFont); overload;
//        constructor Create (Size: Integer; const FontName: String; Style: TFontStyles); overload;
        destructor Destroy; virtual;
    end;

    TGPStringFormatBitFlags = ( SFDirectionRightToLeft, SFDirectionVertical,
                                SFNoFitBlackBox, SFUnused1, SFUnused2, SFDisplayFormatControl,
                                SFUnused3, SFUnused4, SFUnused5, SFUnused6, SFNoFontFallback,
                                SFMeasureTrailingSpaces, SFNoWrap, SFLineLimit, SFNoClip );

    TGPStringFormatAlignment = ( SFAlignmentNear, SFAlignmentCenter, SFAlignmentFar );

    TGPStringFormatFlags = set of TGPStringFormatBitFlags;

    TGPStringFormatTrimming = ( SFTrimmingNone, SFTrimmingCharacter, SFTrimmingWord,
                                SFTrimmingEllipsisCharacter, SFTrimmingEllipsisWord,
                                SFTrimmingEllipsisPath );

    pGPStringFormat=^TGPSTringFormat;
    TGPStringFormat = object(TObj)
    private
        fHandle: Integer;
        function GetFormatFlags: TGPStringFormatFlags;
        procedure SetFormatFlags (Value: TGPStringFormatFlags);
        function GetAlignment: TGPStringFormatAlignment;
        procedure SetAlignment (Value: TGPStringFormatAlignment);
        function GetLineAlignment: TGPStringFormatAlignment;
        procedure SetLineAlignment (Value: TGPStringFormatAlignment);
        function GetTrimming: TGPStringFormatTrimming;
        procedure SetTrimming (Value: TGPStringFormatTrimming);
    public
//        constructor Create (Flags: TGPStringFormatFlags = []);
        destructor Destroy; virtual;
        property FormatFlags: TGPStringFormatFlags read GetFormatFlags write SetFormatFlags;
        property Alignment: TGPStringFormatAlignment read GetAlignment write SetAlignment;
        property LineAlignment: TGPStringFormatAlignment read GetLineAlignment write SetLineAlignment;
        property Trimming: TGPStringFormatTrimming read GetTrimming write SetTrimming;
    end;

    pGDIPlus= ^TGDIPlus;
    TGDIPlus = object(TObj)
    private
        fInitToken: DWord;                      // token for init/shutdown
        fGraphics: Integer;                     // GDI+ graphics "context"
        fBrush: pGPBrush;                       // current brush object
        fPen: pGPPen;                           // current pen object
        fFont: pGPFont;                         // current font object
//        constructor Create;
        procedure SetHDC (Value: HDC);
        procedure SetBrush (Value: pGPBrush);
        procedure SetPen (Value: pGPPen);
        procedure SetFont (Value: pGPFont);
    public
        destructor Destroy; virtual;
        procedure Clear (Color: Cardinal);
        procedure FillRectangle (X, Y, Width, Height: Integer); overload;
        procedure FillRectangle (const Rect: TRect); overload;
        procedure FillRectangles (A: array of TRect);
        procedure FillEllipse (X, Y, Width, Height: Integer); overload;
        procedure FillEllipse (const Rect: TRect); overload;
        procedure FillEllipses (A: array of TRect);
        procedure DrawLine (X1, Y1, X2, Y2: Integer);
        procedure DrawLines (A: array of TPoint);
        procedure DrawRectangle (X, Y, Width, Height: Integer); overload;
        procedure DrawRectangle (const Rect: TRect); overload;
        procedure DrawRectangles (A: array of TRect);
        procedure DrawEllipse (X, Y, Width, Height: Integer); overload;
        procedure DrawEllipse (const Rect: TRect); overload;
        procedure DrawEllipses (A: array of TRect);
        procedure DrawCurve (A: array of TPoint; Tension: Single = 1.0);
        procedure DrawImage (Image: pGPImage; X, Y: Integer); overload;
        procedure DrawImage (Image: pGPImage; X, Y, Width, Height: Integer); overload;
        procedure DrawImage (Image: pGPImage; const Rect: TRect); overload;
        procedure DrawImage (Image: pGPImage; A: array of TPoint); overload;
        procedure DrawImage (Image: pGPImage; const SrcRect, DestRect: TRect; Attr: pGPImageAttributes = Nil); overload;
        procedure DrawString (const Str: String; X, Y: Integer; Format: pGPStringFormat = Nil); overload;
        procedure DrawString (const Str: String; const Layout: TRect; Format: pGPStringFormat = Nil); overload;
        property DeviceContext: HDC write SetHDC;
        property Brush: pGPBrush read fBrush write SetBrush;
        property Pen: pGPPen read fPen write SetPen;
        property Font: pGPFont read fFont write SetFont;
    end;

var
    GDIPlus: pGDIPlus;

{$EXTERNALSYM IsEqualGUID}
function IsEqualGUID(const guid1, guid2: TGUID): Boolean; stdcall;

function ColorFromAlphaColor (Alpha: Byte; Color: Cardinal): Cardinal;
function TRectToRectF (const Src: TRect; var Dest: TRectF): Pointer;
function TRectToGRect (const Src: TRect; var Dst: TRect): Pointer;

function NewGPPen(Color:Cardinal;Width:Integer=1):pGpPen;
function newGPHatchBrush(Style: TGPHatchBrushStyle; ForeColor: Cardinal = White; BackColor: Cardinal = Black):pGpHatchBrush;
function NewGPSolidBrush(Color:Cardinal):pGPSolidBrush;
function NewGPLinearGradientBrush(const ARect: TRect; Color1, Color2: Cardinal; Mode: TGPLinearGradientBrushMode = LinearGradientModeHorizontal):pGPLinearGradientBrush;
function NewGPTextureBrush(Image:pGPImage;wrapmode:TGPBrushWrapMode =wrapmodetile):pGPTextureBrush;
function NewGPImageAttributes:pGPImageattributes;
function NewGPImage(const filename:string;UseECM:Boolean=false):pGPImage;//overload;
function NewGPFont(Font: HFont):pGPFont;overload;
function NewGPFont(Size: Integer; const FontName: String; Style: TFontStyle):pGPFont;overload;
function NewGPStringFormat(Flags: TGPStringFormatFlags=[]):pGPStringFormat;

function NewGDIPlus:pGDIPlus;

const
  ole32    = 'ole32.dll';


implementation

{$EXTERNALSYM IsEqualGUID}
function IsEqualGUID;                   external ole32 name 'IsEqualGUID';

const
    GdiPlusLib = 'GdiPlus.dll';

    FrameDimensionTime       : TGUID = '{6aedbd6d-3fb5-418a-83a6-7f45229dc872}';
    FrameDimensionResolution : TGUID = '{84236f7b-3bd3-428f-8dab-4ea1439ca315}';
    FrameDimensionPage       : TGUID = '{7462dc86-6180-4c7e-8e3f-ee7333a7a483}';

type
{    TRectF = record
        X: Single;
        Y: Single;
        Width: Single;
        Height: Single;
    end;
}
    PropTagType = ( ptUnused1, ptByte, ptAscii, ptShort, ptLong, ptRational,
                    ptUnused2, ptUndefined, ptUnused3, ptSLong, ptSRational );

    PPropertyItem = ^PropertyItem;
    PropertyItem = packed record
        ID: Integer;
        Len: Integer;
        Typ: Word;
        Unused: Word;
        Value: Pointer;
    end;

// Property tags for TGPImage

const
    PropertyTagFrameDelay       = $5100;

function  GdiplusStartup (var Token: DWord; const Input, Output: Pointer): Integer; stdcall; external GdiPlusLib;
procedure GdiplusShutdown (Token: DWord); stdcall; external GdiPlusLib;
function  GdipDeleteGraphics (Graphics: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipCreateFromHDC (hdc: HDC; var Graphics: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipGraphicsClear (Graphics: Integer; Color: Cardinal): Integer; stdcall; external GdiPlusLib;
function  GdipFillRectangleI (Graphics: Integer; Brush: Integer; x, y, width, height: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipFillEllipseI (Graphics: Integer; Brush: Integer; x, y, width, height: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawLineI (Graphics, Pen, X1, Y1, X2, Y2: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawLinesI (Graphics, Pen: Integer; Points: Pointer; Count: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawRectangleI (Graphics, Pen, X, Y, Width, Height: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawEllipseI (Graphics, Pen, X, Y, Width, Height: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawCurve2I (Graphics, Pen: Integer; Points: Pointer; Count: Integer; Tension: Single): Integer; stdcall; external GdiPlusLib;
function  GdipDrawImageI (Graphics, Image, X, Y: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawImageRectI (Graphics, Image, X, Y, Width, Height: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawImagePointsI (Graphics, Image: Integer; Points: Pointer; Count: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawImageRectRectI (Graphics, Image, DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight, SrcUnit, Attribute: Integer; CallBack: Pointer; CallBackData: Integer): Integer; stdcall; external GdiPlusLib;
function  GdipDrawString (Graphics: Integer; const Str: PWideChar; Length, Font: Integer; Layout: Pointer; StringFormat, Brush: Integer): Integer; stdcall; external GdiPlusLib;

// Brushes

function GdipDeleteBrush (brush: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetBrushType (brush: Integer; var BrushType: TGPBrushType): Integer; stdcall; external GdiPlusLib;
function GdipCreateSolidFill (color: Cardinal; var brush: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetSolidFillColor (brush: Integer; var color: Cardinal): Integer; stdcall; external GdiPlusLib;
function GdipSetSolidFillColor (brush: Integer; color: Cardinal): Integer; stdcall; external GdiPlusLib;
function GdipCreateHatchBrush (style: Integer; ForeCol, BackCol: Cardinal; var brush: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetHatchStyle (brush: Integer; var style: TGPHatchBrushStyle): Integer; stdcall; external GdiPlusLib;
function GdipGetHatchForegroundColor (brush: Integer; var ForeCol: Cardinal): Integer; stdcall; external GdiPlusLib;
function GdipGetHatchBackgroundColor (brush: Integer; var BackCol: Cardinal): Integer; stdcall; external GdiPlusLib;
function GdipCreateLineBrushFromRectI (Rect: Pointer; Color1, Color2: Cardinal; Mode: Integer; WrapMode: Integer; var LineGradient: Integer): Integer; stdcall; external GdiPlusLib;
function GdipCreateTexture (Image, WrapMode: Integer; var Brudh: Integer): Integer; stdcall; external GdiPlusLib;

// Pens

function GdipCreatePen1 (Color: Cardinal; Width: Single; Unitt: Integer; var pen: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPenFillType (Pen: Integer; var PenType: TGPPenType): Integer; stdcall; external GdiPlusLib;
function GdipDeletePen (Pen: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPenColor (Pen: Integer; var Color: Cardinal): Integer; stdcall; external GdiPlusLib;
function GdipSetPenColor (Pen: Integer; Color: Cardinal): Integer; stdcall; external GdiPlusLib;
function GdipSetPenWidth (Pen: Integer; Width: Single): Integer; stdcall; external GdiPlusLib;
function GdipGetPenWidth (Pen: Integer; var Width: Single): Integer; stdcall; external GdiPlusLib;
function GdipGetPenDashStyle (Pen: Integer; var dashStyle: Integer): Integer; stdcall; external GdiPlusLib;
function GdipSetPenDashStyle (Pen: Integer; dashStyle: Integer): Integer; stdcall; external GdiPlusLib;
function GdipSetPenDashArray (Pen: Integer; DashArray: Pointer; Count: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPenDashOffset (Pen: Integer; var offset: Single): Integer; stdcall; external GdiPlusLib;
function GdipSetPenDashOffset (Pen: Integer; offset: Single): Integer; stdcall; external GdiPlusLib;
function GdipSetPenCompoundArray (Pen: Integer; CompArray: Pointer; Count: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPenLineJoin (Pen: Integer; var LineJoin: Integer): Integer; stdcall; external GdiPlusLib;
function GdipSetPenLineJoin (Pen, LineJoin: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPenMiterLimit (Pen: Integer; var MiterLimit: Single): Integer; stdcall; external GdiPlusLib;
function GdipSetPenMiterLimit (Pen: Integer; MiterLimit: Single): Integer; stdcall; external GdiPlusLib;
function GdipSetPenBrushFill (Pen, Brush: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPenBrushFill (Pen: Integer; var Brush: Integer): Integer; stdcall; external GdiPlusLib;

// Image attributes

function GdipCreateImageAttributes (var Attribute: Integer): Integer; stdcall; external GdiPlusLib;
function GdipDisposeImageAttributes (Attribute: Integer): Integer; stdcall; external GdiPlusLib;
function GdipSetImageAttributesRemapTable (Attribute, Category: Integer; Enabled: Bool; Entries: Integer; Map: Pointer): Integer; stdcall; external GdiPlusLib;
function GdipSetImageAttributesColorKeys (Attribute, Category: Integer; Enabled: Bool; colorLow, colorHigh: Cardinal): Integer; stdcall; external GdiPlusLib;

// Images

function GdipDisposeImage (Image: Integer): Integer; stdcall; external GdiPlusLib;
function GdipImageForceValidation (Image: Integer): Integer; stdcall; external GdiPlusLib;
function GdipLoadImageFromFile (const FileName: PWideChar; var Image: Integer): Integer; stdcall; external GdiPlusLib;
function GdipLoadImageFromFileICM (const FileName: PWideChar; var Image: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetImageWidth (Image: Integer; var Width: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetImageHeight (Image: Integer; var Height: Integer): Integer; stdcall; external GdiPlusLib;
function GdipImageRotateFlip (Image, FlipType: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetImageType (Image: Integer; var Typ: TGPImageType): Integer; stdcall; external GdiPlusLib;
function GdipGetImageRawFormat (Image: Integer; var RawFormat: TGUID): Integer; stdcall; external GdiPlusLib;
function GdipImageGetFrameDimensionsCount (Image: Integer; var Count: Integer): Integer; stdcall; external GdiPlusLib;
function GdipImageGetFrameDimensionsList (Image: Integer; DimensionsList: Pointer; Count: Integer): Integer; stdcall; external GdiPlusLib;
function GdipImageGetFrameCount (Image: Integer; const ID: TGUID; var Count: Integer): Integer; stdcall; external GdiPlusLib;
function GdipImageSelectActiveFrame (Image: Integer; const ID: TGUID; FrameIndex: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPropertyItemSize (Image, PropID: Integer; var Size: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetPropertyItem (Image, PropId, PropSize: Integer; Buffer: Pointer): Integer; stdcall; external GdiPlusLib;

// Fonts

function GdipCreateFontFromDC (dc: HDC; var Font: Integer): Integer; stdcall; external GdiPlusLib;
function GdipDeleteFont (Font: Integer): Integer; stdcall; external GdiPlusLib;
function GdipCreateFontFromLogfontA (dc: HDC; const LogFont: LOGFONT; var Font: Integer): Integer; stdcall; external GdiPlusLib;

// String formats

function GdipCreateStringFormat (Flags: Integer; Language: LANGID; var Format: Integer): Integer; stdcall; external GdiPlusLib;
function GdipDeleteStringFormat (Format: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetStringFormatFlags (Format: Integer; var Flags: Integer): Integer; stdcall; external GdiPlusLib;
function GdipSetStringFormatFlags (Format, Flags: Integer): Integer; stdcall; external GdiPlusLib;
function GdipSetStringFormatAlign (Format, Align: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetStringFormatAlign (Format: Integer; var Align: TGPStringFormatAlignment): Integer; stdcall; external GdiPlusLib;
function GdipSetStringFormatLineAlign (Format, Align: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetStringFormatLineAlign (Format: Integer; var Align: TGPStringFormatAlignment): Integer; stdcall; external GdiPlusLib;
function GdipSetStringFormatTrimming (Format, Trimming: Integer): Integer; stdcall; external GdiPlusLib;
function GdipGetStringFormatTrimming (Format: Integer; var Trimming: TGPStringFormatTrimming): Integer; stdcall; external GdiPlusLib;

// Utility routines

function ColorFromAlphaColor (Alpha: Byte; Color: Cardinal): Cardinal;
begin
    Result := (Alpha shl 24) or (Color and $ffffff);
end;

// Convert from LTRB to LTWH format

function TRectToGRect (const Src: TRect; var Dst: TRect): Pointer;
begin
    Dst.Left   := Src.Left;
    Dst.Top    := Src.Top;
    Dst.Right  := Src.Right - Src.Left;
    Dst.Bottom := Src.Bottom - Src.Top;
    Result     := @Dst;
end;

function TRectToRectF (const Src: TRect; var Dest: TRectF): Pointer;
begin
    Dest.X      := Src.Left;
    Dest.Y      := Src.Top;
    Dest.Width  := Src.Right - Src.Left;
    Dest.Height := Src.Bottom - Src.Top;
    Result      := @Dest;
end;

// TGPPen


function NewGPPen(Color:Cardinal;Width:Integer):pGpPen;
begin
    New(Result,create);
    //Inherited Create;
    GdipCreatePen1 (Color, width, 0, Result.fHandle);
end;


destructor TGPPen.Destroy;
begin
    GdipDeletePen (fHandle);
    Inherited Destroy;
end;

function TGPPen.GetType: TGPPenType;
begin
    GdipGetPenFillType (fHandle, Result);
end;

function TGPPen.GetColor: Cardinal;
begin
    // Ignored if pen type is not solid colour
    if GetType = PenTypeSolidColor then GdipGetPenColor (fHandle, Result) else Result := 0;
end;

procedure TGPPen.SetColor (Value: Cardinal);
begin
    // Ignored if pen type is not solid colour
    if GetType = PenTypeSolidColor then GdipSetPenColor (fHandle, Value);
end;

function TGPPen.GetWidth: Integer;
var
    W: Single;
begin
    GdipGetPenWidth (fHandle, W);
    Result := Round (W);
end;

procedure TGPPen.SetWidth (Value: Integer);
begin
    GdipSetPenWidth (fHandle, Value);
end;

function TGPPen.GetDashStyle: TGPPenDashStyle;
var
    ds: Integer;
begin
    GdipGetPenDashStyle (fHandle, ds);
    Result := TGPPenDashStyle (ds);
end;

procedure TGPPen.SetDashStyle (Value: TGPPenDashStyle);
begin
    GdipSetPenDashStyle (fHandle, Ord (Value));
end;

procedure TGPPen.SetDashPattern (A: array of Single);
begin
    GdipSetPenDashArray (fHandle, Addr(A), High(A) + 1);
end;

function TGPPen.GetDashOffset: Integer;
var
    Offset: Single;
begin
    GdipGetPenDashOffset (fHandle, Offset);
    Result := Round (Offset);
end;

procedure TGPPen.SetDashOffset (Value: Integer);
begin
    GdipSetPenDashOffset (fHandle, Value);
end;

procedure TGPPen.SetCompoundArray (A: array of Single);
begin
    if High(A) > 0 then GdipSetPenCompoundArray (fHandle, Addr (A), High(A) + 1)
    // Turn off compound mode....
    else SetCompoundArray ([0.0, 1.0]);
end;

procedure TGPPen.SetLineJoin (Value: TGPPenLineJoin);
begin
    GdipSetPenLineJoin (fHandle, Ord (Value));
end;

function TGPPen.GetLineJoin: TGPPenLineJoin;
var
    Join: Integer;
begin
    GdipGetPenLineJoin (fHandle, Join);
    Result := TGPPenLineJoin (Join);
end;

function TGPPen.GetMiterLimit: Integer;
var
    Limit: Single;
begin
    GdipGetPenMiterLimit (fHandle, Limit);
    Result := Round (Limit);
end;

procedure TGPPen.SetMiterLimit (Value: Integer);
begin
    GdipSetPenMiterLimit (fHandle, Value);
end;

procedure TGPPen.SetBrush (Value: pGPBrush);
begin
    if Value <> Nil then GdipSetPenBrushFill (fHandle, Value.fHandle);
end;

// TGDIPlusBrush

destructor TGPBrush.Destroy;
begin
    GdipDeleteBrush (fHandle);
    Inherited Destroy;
end;

function TGPBrush.GetType: TGPBrushType;
begin
    GdipGetBrushType (fHandle, Result);
end;

// TGPSolidBrush

function NewGPSolidBrush(Color:Cardinal):pGPSolidBrush;
begin
    New(Result,Create);
    GdipCreateSolidFill (Color, Result.fHandle);
end;

function TGPSolidBrush.GetColor: Cardinal;
begin
    GdipGetSolidFillColor (fHandle, Result);
end;

procedure TGPSolidBrush.SetColor (Value: Cardinal);
begin
    GdipSetSolidFillColor (fHandle, Value);
end;

// TGPHatchBrush

function newGPHatchBrush(Style: TGPHatchBrushStyle; ForeColor: Cardinal = White; BackColor: Cardinal = Black):pGpHatchBrush;
begin
    New(Result,Create);
    GdipCreateHatchBrush (Integer (Style), ForeColor, BackColor, Result.fHandle);
end;

function TGPHatchBrush.GetHatchStyle: TGPHatchBrushStyle;
begin
    GdipGetHatchStyle (fHandle, Result);
end;

function TGPHatchBrush.GetForeColor: Cardinal;
begin
    GdipGetHatchForegroundColor (fHandle, Result);
end;

function TGPHatchBrush.GetBackColor: Cardinal;
begin
    GdipGetHatchBackgroundColor (fHandle, Result);
end;

// TGPLinearGradientBrush

function NewGPLinearGradientBrush(const ARect: TRect; Color1, Color2: Cardinal; Mode: TGPLinearGradientBrushMode = LinearGradientModeHorizontal):pGPLinearGradientBrush;
var
    GRect: TRect;
begin
    New(Result,Create);
    GdipCreateLineBrushFromRectI (TRectToGRect (ARect, GRect), Color1, Color2, Ord (Mode), Ord (WrapModeTile), Result.fHandle);
end;


// TGPTextureBrush

function NewGPTextureBrush(Image:pGPImage;wrapmode:TGPBrushWrapMode):pGPTextureBrush;
begin
 New(Result,Create);
 GdipCreateTexture (Image.fHandle, Ord (WrapMode), Result.fHandle);
end;


// TGPImageAttributes

function NewGPImageAttributes:pGPImageattributes;
begin
    New(Result,Create);
    GdipCreateImageAttributes (Result.fHandle);
end;

destructor TGPImageAttributes.Destroy;
begin
    GdipDisposeImageAttributes (fHandle);
    Inherited Destroy;
end;

procedure TGPImageAttributes.SetColorRemapTable (const A: array of Cardinal; Category: TGPColorRemapCategory);
var
    NumEntries: Integer;
begin
    // Make sure user has specified an even number of colour values
    NumEntries := High (A) + 1;
    if NumEntries = 0 then GdipSetImageAttributesRemapTable (fHandle, Ord (Category), False, 0, Nil)
    else if not Odd (NumEntries) then GdipSetImageAttributesRemapTable (fHandle, Ord (Category), True, NumEntries, Addr (A))
    //else
    {$IFDEF USE_ERR}
    else raise EGDIPlus.CreateCustom(Cardinal(e_Custom),'Invalid colour map table.');
    {$ENDIF}

end;

procedure TGPImageAttributes.SetColorKey (const A: array of Cardinal; Category: TGPColorRemapCategory);
begin
    // User can supply exactly zero or two colours.
    if High (A) = -1 then GdipSetImageAttributesColorKeys (fHandle, Ord (Category), False, 0,0)
    else if High (A) = 1 then GdipSetImageAttributesColorKeys (fHandle, Ord (Category), True, A[0], A[1])
    {$IFDEF USE_ERR}
    else raise EGDIPlus.CreateCustom(cardinal(e_Custom),'Invalid colour key.');
    {$ENDIF}
end;

// TGPImage
//

function NewGPImage(const FileName: String; UseECM: Boolean):pGPImage;
var
    err: Integer;
    Buffer: array [0..511] of WideChar;
begin
    New(Result, Create);
    if not FileExists (FileName) then
    {$IFDEF USE_ERR}
       raise EGDIPlus.Create (e_Custom, Format ('Image file %s not found.', [FileName]));
    {$ELSE}
    Begin
      result:=nil;
      Exit;
    end;
    {$ENDIF}
    if UseECM then err := GdipLoadImageFromFileICM (StringToWideChar (FileName, Buffer, sizeof (Buffer)), Result.fHandle)
    else err := GdipLoadImageFromFile (StringToWideChar (FileName, Buffer, sizeof (Buffer)), Result.fHandle);
    {$IFDEF USE_ERR}
    if err <> 0 then raise EGDIPlus.CreateCustom(Cardinal(e_Custom),Format ('Can''t load image file %s.', [FileName])) else
    {$ENDIF}
    Result.ReadImageInfo;
end;

destructor TGPImage.Destroy;
begin
    GdipDisposeImage (fHandle);
    Inherited Destroy;
end;

procedure TGPImage.SetFrame (Index: Integer; Value: Integer);
var
    dim: TGUID;
begin
    if (Value < 0) or (Value >= fFrameCount [Index]) then Value := 0;
    case Index of
        0:  dim := FrameDimensionTime;
        1:  dim := FrameDimensionResolution;
        2:  dim := FrameDimensionPage;
    end;

    fCurrentFrame [Index] := Value;
    GdipImageSelectActiveFrame (fHandle, dim, Value);
end;

procedure TGPImage.ReadImageInfo;
var
    pDim, pDimensions: ^TGUID;
    DimensionsCount: Integer;
begin
    GdipImageGetFrameDimensionsCount (fHandle, DimensionsCount);
    pDimensions := AllocMem (DimensionsCount * sizeof (TGUID));
    try
        GdipImageGetFrameDimensionsList (fHandle, pDimensions, DimensionsCount);
        pDim := pDimensions;
        while DimensionsCount > 0 do begin
            if IsEqualGUID (pDim^, FrameDimensionTime) then begin
                GdipImageGetFrameCount (fHandle, pDim^, fFrameCount[0]);
            end;

            if IsEqualGUID (pDim^, FrameDimensionResolution) then begin
                GdipImageGetFrameCount (fHandle, pDim^, fFrameCount[1]);
            end;

            if IsEqualGUID (pDim^, FrameDimensionPage) then begin
                GdipImageGetFrameCount (fHandle, pDim^, fFrameCount[2]);
            end;

            Inc (pDim);
            Dec (DimensionsCount);
        end;
    finally
        FreeMem (pDimensions);
    end;
end;

function TGPImage.GetWidth: Integer;
begin
    Result := -1;
    if fHandle <> 0 then GdipGetImageWidth (fHandle, Result);
end;

function TGPImage.GetHeight: Integer;
begin
    Result := -1;
    if fHandle <> 0 then GdipGetImageHeight (fHandle, Result);
end;

procedure TGPImage.Flip (FlipMode: TGPImageFlipMode);
begin
    if fHandle <> 0 then GdipImageRotateFlip (fHandle, Ord (FlipMode));
end;

function TGPImage.GetImageType: TGPImageType;
begin
    Result := ImageUnknown;
    if fHandle <> 0 then GdipGetImageType (fHandle, Result);
end;

function TGPImage.GetImageFormat: TGPImageFormat;
var
    rf: TGUID;
    Num: Integer;
begin
    Result := ImageUndefined;
    if fHandle <> 0 then begin
        GdipGetImageRawFormat (fHandle, rf);
        // This is evil code -- but I like it...... :-)
        Num := rf.D1 - $b96b3ca9;
        if (Num >= Ord (Low (TGPImageFormat))) and (Num <= Ord (High (TGPImageFormat))) then
            Result := TGPImageFormat (Num);
    end;
end;

function TGPImage.CanAnimate: Boolean;
begin
    Result := fFrameCount[0] > 1;
end;

function TGPImage.GetProperty (PropID, PropType: Integer): Pointer;
var
    size: Integer;
    Buffer: PPropertyItem;
begin
    Result := Nil;
    if GdipGetPropertyItemSize (fHandle, PropID, size) = 0 then begin
        Buffer := AllocMem (size);
        if (GdipGetPropertyItem (fHandle, PropID, size, Buffer) <> 0) or (Buffer^.ID <> PropID) or (Buffer^.Typ <> PropType) then begin
            FreeMem (Buffer);
            Buffer := Nil;
        end;

        Result := Buffer;
    end;
end;

function TGPImage.FrameDelay (FrameNum: Integer): Integer;
type
    II = array [0..0] of Integer;
var
    Prop: PPropertyItem;
    PP: ^II;
begin
    Result := -1;
    if CanAnimate and (FrameNum < fFrameCount[0]) then begin
        Prop := GetProperty (PropertyTagFrameDelay, Ord (ptLong));
        if Prop <> Nil then try
            PP := Prop.Value;
            Result := PP [FrameNum];
        finally
            FreeMem (Prop);
        end;
    end;
end;

// TGPFont

function NewGPFont(Font: HFont):pGPFont;
begin
    New(Result,Create);
    Result.InternalCreate (Font);
end;

function NewGPFont(Size: Integer; const FontName: String; Style: TFontStyle):pGPFont;
var
    Font: pGraphictool;
begin
    New(Result,Create);
    with Result^do
    begin
    Font := NewFont;//.Create;
    try
        Font.FontHeight := Size;
        Font.FontName := FontName;
        Font.FontStyle := Style;
        Font.FontQuality:=fqAntiAliased;
        InternalCreate (Font.Handle);
    finally
        Font.Free;
    end;
    end;
end;

procedure TGPFont.InternalCreate (Font: hFont);
var
    dc: hDC;
    lf: LogFont;
begin
    dc := GetDC (0);
    if Font = 0 then GdipCreateFontFromDC (dc, fHandle) else begin
        GetObject (Font, sizeof (lf), @lf);
        GdipCreateFontFromLogFontA (dc, lf, fHandle);
    end;

    ReleaseDC (0, dc);
end;

destructor TGPFont.Destroy;
begin
    GdipDeleteFont (fHandle);
    Inherited Destroy;
end;

// TGPStringFormat

function NewGPStringFormat(Flags: TGPStringFormatFlags):pGPStringFormat;
var
    Trix: Integer absolute Flags;
begin
    New(Result, Create);
    GdipCreateStringFormat (Trix, LANG_NEUTRAL, result.fHandle);
end;

destructor TGPStringFormat.Destroy;
begin
    GdipDeleteStringFormat (fHandle);
    Inherited Destroy;
end;

function TGPStringFormat.GetFormatFlags: TGPStringFormatFlags;
var
    Trix: Integer absolute Result;
begin
    GdipGetStringFormatFlags (fHandle, Trix);
end;

procedure TGPStringFormat.SetFormatFlags (Value: TGPStringFormatFlags);
var
    Trix: Integer absolute Value;
begin
    GdipSetStringFormatFlags (fHandle, Trix);
end;

function TGPStringFormat.GetAlignment: TGPStringFormatAlignment;
begin
    GdipGetStringFormatAlign (fHandle, Result);
end;

procedure TGPStringFormat.SetAlignment (Value: TGPStringFormatAlignment);
begin
    GdipSetStringFormatAlign (fHandle, Ord (Value));
end;

function TGPStringFormat.GetLineAlignment: TGPStringFormatAlignment;
begin
    GdipGetStringFormatLineAlign (fHandle, Result);
end;

procedure TGPStringFormat.SetLineAlignment (Value: TGPStringFormatAlignment);
begin
    GdipSetStringFormatLineAlign (fHandle, Ord (Value));
end;

function TGPStringFormat.GetTrimming: TGPStringFormatTrimming;
begin
    GdipGetStringFormatTrimming (fHandle, Result);
end;

procedure TGPStringFormat.SetTrimming (Value: TGPStringFormatTrimming);
begin
    GdipSetStringFormatTrimming (fHandle, Ord (Value));
end;

// TGDIPlus

function NewGDIPlus:pGDIPlus;
type
    TGDIStartup = packed record
        Version: Integer;                       // Must be one
        DebugEventCallback: Pointer;            // Only for debug builds
        SuppressBackgroundThread: Bool;         // True if replacing GDI+ background processing
        SuppressExternalCodecs: Bool;           // True if only using internal codecs
    end;

var
    Err: Integer;
    Startup: TGDIStartup;

begin
    New(Result, Create);
    FillChar (Startup, sizeof (Startup), 0);  Startup.Version := 1;
    Err := GdiPlusStartup (Result.fInitToken, @Startup, nil);
    if Err <> 0 then {$IFDEF USE_ERR}
    raise EGDIPlus.Create (e_Custom,Format ('GDI+ Init failed [%d]', [Err]));
    {$ELSE}
    result:=Nil;
    {$ENDIF}
end;

destructor TGDIPlus.Destroy;
begin
    if fGraphics <> 0 then GdipDeleteGraphics  (fGraphics);
    if fBrush <> Nil then fBrush.Free;
    if fPen <> Nil then fPen.Free;
    if fFont <> Nil then fFont.Free;
    GdiplusShutdown (fInitToken);
    Inherited Destroy;
end;

procedure TGDIPlus.SetHDC (Value: HDC);
begin
    if fGraphics <> 0 then GdipDeleteGraphics  (fGraphics);
    fGraphics := 0;
    GdipCreateFromHDC (Value, fGraphics);
end;

procedure TGDIPlus.Clear (Color: Cardinal);
begin
     GdipGraphicsClear (fGraphics, Color);
end;

procedure TGDIPlus.SetBrush (Value: pGPBrush);
begin
    // Special case - Nil means don't delete the old brush
    if fBrush <> Value then begin
        if Value <> Nil then fBrush.Free;
        fBrush := Value;
    end;
end;

procedure TGDIPlus.SetPen (Value: pGPPen);
begin
    // Special case - Nil means don't delete the old pen
    if fPen <> Value then begin
        if Value <> Nil then fPen.Free;
        fPen := Value;
    end;
end;

procedure TGDIPlus.SetFont (Value: pGPFont);
begin
    // Special case - Nil means don't delete the old font
    if fFont <> Value then begin
        if Value <> Nil then fFont.Free;
        fFont := Value;
    end;
end;

procedure TGDIPlus.FillRectangle (X, Y, Width, Height: Integer);
begin
     if (fBrush <> Nil) and (fGraphics <> 0) then
         GdipFillRectangleI (fGraphics, fBrush.Handle, X, Y, Width, Height);
end;

procedure TGDIPlus.FillRectangle (const Rect: TRect);
begin
    FillRectangle (Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
end;

procedure TGDIPlus.FillRectangles (A: array of TRect);
var
    Idx: Integer;
begin
    for Idx := Low (A) to High (A) do FillRectangle (A [Idx]);
end;

procedure TGDIPlus.FillEllipse (X, Y, Width, Height: Integer);
begin
     if (fBrush <> Nil) and (fGraphics <> 0) then
         GdipFillEllipseI (fGraphics, fBrush.Handle, X, Y, Width, Height);
end;

procedure TGDIPlus.FillEllipse (const Rect: TRect);
begin
     FillEllipse (Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
end;

procedure TGDIPlus.FillEllipses (A: array of TRect);
var
    Idx: Integer;
begin
    for Idx := Low (A) to High (A) do FillEllipse (A [Idx]);
end;

procedure TGDIPlus.DrawLine (X1, Y1, X2, Y2: Integer);
begin
    if (fPen <> Nil) and (fGraphics <> 0) then
        GdipDrawLineI (fGraphics, fPen.Handle, X1, Y1, X2, Y2);
end;

procedure TGDIPlus.DrawLines (A: array of TPoint);
begin
    if (fPen <> Nil) and (fGraphics <> 0) then
        GdipDrawLinesI (fGraphics, fPen.Handle, Addr(A), High(A) + 1);
end;

procedure TGDIPlus.DrawRectangle (X, Y, Width, Height: Integer);
begin
    if (fPen <> Nil) and (fGraphics <> 0) then
        GdipDrawRectangleI (fGraphics, fPen.Handle, X, Y, Width, Height);
end;

procedure TGDIPlus.DrawRectangle (const Rect: TRect);
begin
    DrawRectangle (Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
end;

procedure TGDIPlus.DrawRectangles (A: array of TRect);
var
    Idx: Integer;
begin
    for Idx := Low (A) to High (A) do DrawRectangle (A[Idx]);
end;

procedure TGDIPlus.DrawEllipse (X, Y, Width, Height: Integer);
begin
    if (fPen <> Nil) and (fGraphics <> 0) then
        GdipDrawEllipseI (fGraphics, fPen.Handle, X, Y, Width, Height);
end;

procedure TGDIPlus.DrawEllipse (const Rect: TRect);
begin
    DrawEllipse (Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
end;

procedure TGDIPlus.DrawEllipses (A: array of TRect);
var
    Idx: Integer;
begin
    for Idx := Low (A) to High (A) do DrawEllipse (A [Idx]);
end;

procedure TGDIPlus.DrawCurve (A: array of TPoint; Tension: Single);
begin
    if (fPen <> Nil) and (fGraphics <> 0) then
        GdipDrawCurve2I (fGraphics, fPen.Handle, Addr (A), High(A) + 1, Tension);
end;

procedure TGDIPlus.DrawImage (Image: pGPImage; X, Y: Integer);
begin
    if (fGraphics <> 0) and (Image <> Nil) and (Image.fHandle <> 0) then GdipDrawImageI (fGraphics, Image.fHandle, X, Y);
end;

procedure TGDIPlus.DrawImage (Image: pGPImage; X, Y, Width, Height: Integer);
begin
    if (fGraphics <> 0) and (Image <> Nil) and (Image.fHandle <> 0) then
        GdipDrawImageRectI (fGraphics, Image.fHandle, X, Y, Width, Height);
end;

procedure TGDIPlus.DrawImage (Image: pGPImage; const Rect: TRect);
begin
    DrawImage (Image, Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
end;

procedure TGDIPlus.DrawImage (Image: pGPImage; A: array of TPoint);
begin
    if (fGraphics <> 0) and (Image <> Nil) and (High (A) in [2, 3]) then
        GdipDrawImagePointsI (fGraphics, Image.fHandle, Addr (A), High(A) + 1);
end;

procedure TGDIPlus.DrawImage (Image: pGPImage; const SrcRect, DestRect: TRect; Attr: pGPImageAttributes);
var
    Attribs: Integer;
begin
    if (fGraphics <> 0) and (Image <> Nil) then begin
        if Attr <> Nil then Attribs := Attr.fHandle else Attribs := 0;
        GdipDrawImageRectRectI (fGraphics, Image.fHandle, DestRect.Left, DestRect.Top, DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top,
                                SrcRect.Left, SrcRect.Top, SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top,
                                2, Attribs, Nil, 0);
    end;
end;

procedure TGDIPlus.DrawString (const Str: String; X, Y: Integer; Format: pGPStringFormat);
var
    rLayout: TRectF;
    Buffer: PWideChar;
    hFormat: Integer;
begin
    Buffer := Nil;  // Just to shut the dumb compiler up...
    if (fGraphics <> 0) and (fFont <> Nil) and (fBrush <> Nil) then try
        Buffer := AllocMem ((Length (Str) + 1) * sizeof (WideChar));
        rLayout.X := X;  rLayout.Y := Y;  rLayout.Width := 0;  rLayout.Height := 0;
        if Format = Nil then hFormat := 0 else hFormat := Format.fHandle;
        GdipDrawString (fGraphics, StringToWideChar (Str, Buffer, Length (Str) + 1), Length (Str), fFont.fHandle, @rLayout, hFormat, fBrush.fHandle);
    finally
        FreeMem (Buffer);
    end;
end;

procedure TGDIPlus.DrawString (const Str: String; const Layout: TRect; Format: pGPStringFormat);
var
    rLayout: TRectF;
    Buffer: PWideChar;
    hFormat: Integer;
begin
    Buffer := Nil;  // Just to shut the dumb compiler up...
    if (fGraphics <> 0) and (fFont <> Nil) and (fBrush <> Nil) then try
        Buffer := AllocMem ((Length (Str) + 1) * sizeof (WideChar));
        if Format = Nil then hFormat := 0 else hFormat := Format.fHandle;
        GdipDrawString (fGraphics, StringToWideChar (Str, Buffer, Length (Str) + 1), Length (Str), fFont.fHandle, TRectToRectF (Layout, rLayout), hFormat, fBrush.fHandle);
    finally
        FreeMem (Buffer);
    end;
end;

initialization
    GDIPlus := NewGDIPlus;
finalization
    GDIPlus.Free;
end.
