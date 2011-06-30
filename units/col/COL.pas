unit COL;

{$A-} // align off, otherwise code is not good
{$Q-} // no overflow check: this option makes code wrong
{$R-} // no range checking: this option makes code wrong
{$T-} // not typed @-operator

interface
uses Windows,Kol,err;

type
{----------------------------------------------------------------------

     TGDIToolObject - object to implement GDI-tools (brush, pen, font)

-----------------------------------------------------------------------}

  PGDIBitmap = ^TGDIBitmap;

  PGDICanvas =^TGDICanvas;

  PImageResource = ^TImageResource;
  PGTResource = ^TGTResource;


   TGDIPenMode = (pmBlack       = R2_BLACK,
                  pmNotMerge    = R2_NotMergePen,
                  pmMaskNotPen  = R2_MaskNotPen,
                  pmNotCopy     = R2_NotCopyPen,
                  pmMaskPenNot  = R2_MaskPenNot,
                  pmNot         = R2_Not,
                  pmXor         = R2_XorPen,
                  pmNotMask     = R2_NotMaskPen,
                  pmMask        = R2_MaskPen,
                  pmNotXor      = R2_NotXorPen,
                  pmNop         = R2_Nop,
                  pmMergePenNot = R2_MergePenNot,
                  pmCopy        = R2_CopyPen,
                  pmMergeNotPen = R2_MergeNotPen,
                  pmMerge       = R2_MergePen,
                  pmWhite       = R2_White);

   {* Available pen styles.
   Sequence of styles differing from Delphi TPenMode but :)
   For more info see Delphi or Win32 help files.
   }




  TGDIFontQuality = (fqDefault	      = DEFAULT_QUALITY,
                     fqDraft	      = DRAFT_QUALITY,
                     fqProf           = PROOF_QUALITY,
                     fqNonAntialiased = NONANTIALIASED_QUALITY,
                     fqAntialiased    = ANTIALIASED_QUALITY);

  TFontCharset = byte;

  TGDILogFont = packed record
    lfHeight: Longint;
    lfWidth: Longint;
    lfEscapement: Longint;
    lfOrientation: Longint;
    lfWeight: Longint;
    lfItalic: Byte;
    lfUnderline: Byte;
    lfStrikeOut: Byte;
    lfCharSet: TFontCharset;
    lfOutPrecision: Byte;
    lfClipPrecision: Byte;
    lfQuality: TGDIFontQuality;
    lfPitchAndFamily: TFontPitch;
    lfFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
  end;


  TDeleteResProc = procedure(GDIRes: PImageResource);

  PGTResData = ^TGTResData;
  TGTResData = record
    DataSize: Word; //Resourse may be < 65k
    Handle: THandle;
  end;


  TGDIFontDataName = string[LF_FACESIZE - 1];
   {* Font charset is represented by number from 0 to 255. }

  TGDIFontData = packed record
    LogFont:TGDILogFont;
  end;


  TGDILogBrush = packed record
    lbStyle: UINT;
    lbColor: COLORREF;
    lbHatch: HBitmap;
  end;

  TGDIPattern = TGDILogBrush;

  TGDIPenData = packed record
    LogPen: TLogPen;
    fPattern:TGDIPattern;
    fPenMode: TGDIPenMode;
    fGeometricPen: Boolean;
  end;

  TGDIBrushData = record
    LogBrush: TGDILogBrush;
  end;

  TGTResUserData = record
    case Integer of
      1: (Font: TGDIFontData);
      2: (Pen: TGDIPenData);
      3: (Brush: TGDIBrushData);
  end;

  TGTResource = record
    Next: PGTResource;
    RefCount: Integer;
    HashCode: Word;
    Data: TGTResData;
    case Integer of
      1: (Font: TGDIFontData);
      2: (Pen: TGDIPenData);
      3: (Brush: TGDIBrushData);
  end;









  PGDIResData = ^TGDIResData;
  TGDIResData = record
    DataSize: Word; //Resourse may be < 65k
    fResType: UINT;
    fCanvasAttached : integer;
    DeleteResProc:TDeleteResProc;
    Handle: THandle;
  end;


  TResoursceIconData = record
    FHandle: HIcon;
    FSize : Integer;
    FShareIcon: Boolean; // Not Need
  end;

  TGDIBitmapData = record
    BmpHandle: THandle;
    fBmp: Windows.TBitmap;
    fHandleType: TBitmapHandleType;
    fDIBHeader: PBitmapInfo;
    fDIBSize: Integer;
    fDIBAutoFree: Boolean;
    fNewPixelFormat: TPixelFormat;

    fScanLineSize: Integer;

    fCanvas: PGDICanvas;
    fApplyBkColor2Canvas: procedure( Sender: PGDIBitmap );
    fFillWithBkColor: procedure( BmpObj: PGDIBitmap; DC: HDC; oldW, oldH: Integer );
  end;


  TImageResData = record
    case Integer of
      0: (CustomData: pointer);
      1: (Bitmap: TGDIBitmapData);
      2: (Icon: TResoursceIconData);
  end;

  TImageResource = record
    Next: PImageResource;
    RefCount: Integer;
    HashCode: Word;
    Data: TGDIResData;
    case Integer of
      0: (CustomData: pointer);
      1: (Bitmap: TGDIBitmapData);
      2: (Icon: TResoursceIconData);
  end;



  PGDIObject = ^TGDIObject;
  PGDIToolObject = ^TGDIToolObject;

  TOnGdiObjectChange = procedure ( Sender: PGDIToolObject) of object;

  TGDIToolObject = object( TObj)
  {* Incapsulates all GDI objects: Pen, Brush and Font. }
  protected
    fOnChange: TOnGDIobjectChange;
    fMakeHandleProc: function( Self_: PGDIToolObject ): Integer;
    FResource:PGTResource;
    FGTResData:TGTResData;
    FResData:TGTResUserData;
    function GetHandleAllocated: Boolean;
    procedure ChangedNoRebuildHandle;
    procedure Changed;
    property HandleAllocated: Boolean read GetHandleAllocated;
    procedure SetData(const Data);
  private

    fType: TGraphicToolType;
    fColor: TColor;

    procedure SetColor( Value: TColor );
    procedure SetBrushBitmap(const Value: HBitmap);

    procedure SetFontCharset(const Value: TFontCharset);
    procedure SetFontHeight(const Value: Integer);
    procedure SetFontWidth(const Value: Integer);

    function GetFontName: string;
    procedure SetFontName(const Value: string);

    procedure SetFontOrientation(Value: Integer);
    procedure SetFontPitch(const Value: TFontPitch);
    procedure SetFontWeight(const Value: Integer);
    function GetFontStyle: TFontStyle;
    procedure SetFontStyle(const Value: TFontStyle);
    procedure SetFontQuality(const Value: TGDIFontQuality);


    procedure SetPenMode(const Value: TGDIPenMode);
    procedure SetPenWidth(const Value: Integer);
    procedure SetGeometricPen(const Value: Boolean);

    function GetPenStyle:TPenStyle;
    procedure SetPenStyle(const Value: TPenStyle);
    function GetPenEndCap:TPenEndCap;
    procedure SetPenEndCap(const Value: TPenEndCap);
    function GetPenJoin:TPenJoin;
    procedure SetPenJoin(const Value: TPenJoin);



    procedure SetBrushStyle(const Value: TBrushStyle);
    procedure SetPenBrushStyle(const Value: TBrushStyle);

    procedure SetPenBrushBitmap(const Value: HBitmap);

    procedure SetLogFont(const Value: TLogFont);
    function GetLogFont:TLogFont;

  protected

    function GetHandle: Integer;

  public

    destructor Destroy;virtual;
    {* }
    property Handle: Integer read GetHandle;
    {* Every time, when accessed, real GDI object is created (if it is
       not yet created). So, to prevent creating of the handle, use
       HandleAllocated instead of comparing Handle with value 0. }
    property OnChange: TOnGDIObjectChange read fOnChange write fOnChange;
    {* Called, when object is changed. }
    property Color: TColor read fColor write SetColor;
    {* Color is the most common property for all Pen, Brush and
       Font objects, so it is placed in its common for all of them. }
    function Assign( Value: PGDIToolObject ): PGDIToolObject;
    {* Assigns properties of the same (only) type graphic object,
       excluding Handle. If assigning is really leading to change
       object, procedure Changed is called. }
    procedure AssignHandle( NewHandle: Integer );
    {* Assigns value to Handle property. }

    property BrushBitmap: HBitmap {read fBrushBitmap} write SetBrushBitmap;
    {* Brush bitmap. For more info about using brush bitmap,
       see Delphi or Win32 help files. }
    property BrushStyle: TBrushStyle {read fBrushStyle }write SetBrushStyle;
    {* Brush style. }

    property LogFont: TLogFont read GetLogFont write SetLogFont;

    property FontHeight: Integer read FResData.Font.LogFont.lfHeight write SetFontHeight;
//    property FontHeight: Integer index 0 read GetLong write SetLong;
    {* Font height. Value 0 (default) seys to use system default value,
       negative values are to represent font height in "points", positive
       - in pixels. In XCL usually positive values (if not 0) are used to
       make appearance independent from different local settings. }
    property FontWidth: Integer read FResData.Font.LogFont.lfWidth write SetFontWidth;
    {* Font width in logical units. If FontWidth = 0, then as it is said
       in Win32.hlp, "the aspect ratio of the device is matched against the
       digitization aspect ratio of the available fonts to find the closest match,
       determined by the absolute value of the difference." }
    property FontWeight: Integer read FResData.Font.LogFont.lfWeight write SetFontWeight;
    {* Additional font weight for bold fonts (must be 0..1000). When set to
       value <> 0, fsBold is added to FontStyle. And otherwise, when set to 0,
       fsBold is removed from FontStyle. Value 700 corresponds to Bold,
       400 to Normal. }
    property FontPitch: TFontPitch read FResData.Font.LogFont.lfPitchAndFamily write SetFontPitch;
    {* Font pitch. Change it very rare. }
    property FontStyle: TFontStyle read GetFontStyle write SetFontStyle;
    {* Very useful property to control text appearance. }
    property FontCharset: TFontCharset read FResData.Font.LogFont.lfCharSet write SetFontCharset;
    {* Do not change it if You do not know what You do. }
    property FontOrientation: Integer read FResData.Font.LogFont.lfOrientation write SetFontOrientation;
    {* It is possible to rotate text in XCL just by changing this
       property of a font (tenths of degree, i.e. value 900 represents
       90 degree - text written from bottom to top). }
    property FontName: string read GetFontName write SetFontName;
    {* Font face name. }
    property FontQuality: TGDIFontQuality read FResData.Font.LogFont.lfQuality write SetFontQuality;
    {* Font Quality. }
    function IsFontTrueType: Boolean;
    {* Returns True, if font is True Type. Requires of creating of a Handle,
       if it is not yet created. }

    property PenWidth: Integer read FResData.Pen.LogPen.lopnWidth.x write SetPenWidth;
    {* Default width is 0. }
    property PenStyle: TPenStyle read GetPenStyle write SetPenStyle;
    {* Pen style. }
    property PenMode: TGDIPenMode read FResData.Pen.fPenMode write SetPenMode;
    {* Pen mode. }

    property GeometricPen: Boolean read FResData.Pen.FGeometricPen write SetGeometricPen;
    {* True if Pen is geometric. Note, that under Win95/98 only pen styles
       psSolid, psNull, psInsideFrame are supported by OS. }

    property PenBrushStyle: TBrushStyle {read fPenBrushStyle }write SetPenBrushStyle;
    {* Brush style for hatched geometric pen. }

//    FResData.Pen.BrushLogBrush.lbHatch
    property PenBrushBitmap: HBitmap read FResData.Pen.fPattern.lbHatch write SetPenBrushBitmap;
    {* Brush bitmap for geometric pen (if assigned Pen is functioning as
       its style = BS_PATTERN, regadless of PenBrushStyle value). }

    property PenEndCap: TPenEndCap read GetPenEndCap write SetPenEndCap;
    {* Pen end cap mode - for GeometricPen only. }
    property PenJoin: TPenJoin read GetPenJoin write SetPenJoin;
    {* Pen join mode - for GeometricPen only. }
  end;


{----------------------------------------------------------------------

                TGDICanvas - high-level drawing helper object

-----------------------------------------------------------------------}


  TOnGDIGetHandle = function( Canvas: PGDICanvas ): HDC of object;
  TOnGDITextArea = procedure( Sender: PGDICanvas; var Size : TSize; var P0 : TPoint );


  TGDICanvas = object( TObj )
  {* Very similar to VCL's TGDICanvas object. But with some changes, specific
     for KOL: no necessity of always using of canvases in all applications.
     And even graphic tools objects are not created with canvas, but only
     if really accessed in program. (Actually, even if paint box used,
     only programmer decides, if to implement painting using Canvas or
     to call low level API drawing functions working directly with DC).
     Therefore it has ability to be extended with rotated text support,
     geometric pen support - just by changing correspondent properties
     of certain graphic tool objects (Font.FontOrientation, Pen.GeometricPen).}
  private
    fOwnerControl: Pointer; //PControl;
    fHandle : HDC;
    fPenPos : TPoint;
    fBrush, fFont, fPen : PGDIToolObject; // order is important for ASM version
    FSelfDC: HDC;
    fState : Byte;
    fCopyMode : TCopyMode;
    fOnChange: TOnEvent;
    fOnGetHandle: TOnGetHandle;

    procedure SetHandle( Value : HDC );
    //function GetPenPos : TPoint;
    procedure SetPenPos( const Value : TPoint );

    procedure CreatePen;
    procedure CreateBrush;
    procedure CreateFont;
    procedure ObjectChanged( Sender : PGDIToolObject );
    procedure Changing;
    function GetBrush: PGDIToolObject;
    function GetFont: PGDIToolObject;
    function GetPen: PGDIToolObject;
    function GetHandle: HDC;
    procedure AssignChangeEvents;
  protected
    destructor Destroy; virtual;
    {* Destroys Canvas object. First, handle, if it is allocated,
       is deallocated by assigning to value 0.  }
    property OnGetHandle: TOnGetHandle read fOnGetHandle write fOnGetHandle;
  public
    procedure DeselectHandles;


    property Handle : HDC read GetHandle write SetHandle;
    {* GDI device context object handle. Never created by
       Canvas itself (to use Canvas with memory bitmaps,
       always create DC by yourself and assign it to the
       Handle property of Canvas object, or use property
       Canvas of a bitmap). }
    property PenPos : TPoint read fPenPos write SetPenPos;
    {* Position of a pen. }
    property Pen : PGDIToolObject read GetPen;
    {* Pen of Canvas object. Do not change its Pen.OnChange event value. }
    property Brush : PGDIToolObject read GetBrush;
    {* Brush of Canvas object. Do not change its Brush.OnChange event value. }
    property Font : PGDIToolObject read GetFont;
    {* Font of Canvas object. Do not change its Font.OnChange event value. }
    procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); stdcall;
    {* Draws arc. For more info, see Delphi TGDICanvas help. }
    procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); stdcall;
    {* Draws chord. For more info, see Delphi TGDICanvas help. }
    procedure DrawFocusRect(const Rect: TRect);
    {* Draws rectangle to represent focused visual object.
       For more info, see Delphi TGDICanvas help. }
    procedure Ellipse(X1, Y1, X2, Y2: Integer);
    {* Draws an ellipse. For more info, see Delphi TGDICanvas help. }
    procedure FillRect(const Rect: TRect);
    {* Fills rectangle. For more info, see Delphi TGDICanvas help. }
    procedure FillRgn( const Rgn : HRgn );
    {* Fills region. For more info, see Delphi TGDICanvas help. }
    procedure FloodFill(X, Y: Integer; Color: TColor; FillStyle: TFillStyle);
    {* Fills a figure with givien color, floodfilling its surface.
       For more info, see Delphi TGDICanvas help. }
    procedure FrameRect(const Rect: TRect);
    {* Draws a rectangle. For more info, see Delphi TGDICanvas help. }
    procedure MoveTo( X, Y : Integer );
    {* Moves current PenPos to a new position.
       For more info, see Delphi TGDICanvas help. }
    procedure LineTo( X, Y : Integer );
    {* Draws a line from current PenPos up to new position.
       For more info, see Delphi TGDICanvas help. }
    procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); stdcall;
    {* Draws a pie. For more info, see Delphi TGDICanvas help. }
    procedure Polygon(const Points: array of TPoint);
    {* Draws a polygon. For more info, see Delphi TGDICanvas help. }
    procedure Polyline(const Points: array of TPoint);
    {* Draws a bound for polygon. For more info, see Delphi TGDICanvas help. }
    procedure Rectangle(X1, Y1, X2, Y2: Integer);
    {* Draws a rectangle using current Pen and/or Brush.
       For more info, see Delphi TGDICanvas help. }
    procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);
    {* Draws a rounded rectangle. For more info, see Delphi TGDICanvas help. }
    procedure TextOut(X, Y: Integer; const Text: String); stdcall;
    {* Draws a text. For more info, see Delphi TGDICanvas help. }
    procedure TextRect(const Rect: TRect; X, Y: Integer; const Text: string);
    {* Draws a text, clipping output into given rectangle.
       For more info, see Delphi TGDICanvas help. }
    function TextExtent(const Text: string): TSize;
    {* Calculates size of a Text, using current Font settings.
       Does not need in Handle for Canvas object (if it is not
       yet allocated, temporary device context is created and used. }
    procedure TextArea( const Text : String; var Sz : TSize; var P0 : TPoint );
    {* Calculates size and starting point to output Text,
       taking into considaration all Font attributes, including
       Orientation (only if GlobalGraphics_UseFontOrient flag
       is set to True, i.e. if rotated fonts are used).
       Like for TextExtent, does not need in Handle (and if this
       last is not yet allocated/assigned, temporary device context
       is created and used). }
    function TextWidth(const Text: string): Integer;
    {* Calculates text width (using TextArea). }
    function TextHeight(const Text: string): Integer;
    {* Calculates text height (using TextArea). }
    property ModeCopy : TCopyMode read fCopyMode write fCopyMode;
    {* Current copy mode. Is used in CopyRect method. }
    procedure CopyRect( const DstRect : TRect; SrcCanvas : PGDICanvas; const SrcRect : TRect );
    {* Copyes a rectangle from source to destination, using StretchBlt. }
    property OnChange: TOnEvent read fOnChange write fOnChange;
    {* }
    function Assign( SrcCanvas : PGDICanvas ) : Boolean;
    {* }
    function RequiredState( ReqState : DWORD ): Integer; stdcall;// public now
    {* It is possible to call this method before using Handle property
       to pass it into API calls - to provide valid combinations of
       pen, brush and font, selected into device context. This method
       can not provide valid Handle - You always must create it by
       yourself and assign to XCanvas.Handle property manually.
       To optimize assembler version, returns Handle value. }
  end;








  TGDIObject = object( TObj )
  private
    function GetHandleAllocated: Boolean;
    {* Returns True, if handle is allocated (i.e., if real GDI
       objet is created. }
  protected
    fOnChange: TOnGDIobjectChange;
    fMakeHandleProc: function( Self_: PGDIObject ): Integer;
    FImageResource:PImageResource;
    FGDIResData:TGDIResData;
    procedure ChangedNoRebuildHandle;
    procedure Changed;
    property HandleAllocated: Boolean read GetHandleAllocated;
    {* Returns True, if Handle already allocated. }
  end;


  PGDIIcon = ^TGDIIcon;
{----------------------------------------------------------------------

                          TGDIIcon - icon image

-----------------------------------------------------------------------}

  TGDIIcon = object( TGDIObject )
  {* Object type to incapsulate icon or cursor image. }
  private
    fResData:TResoursceIconData;
    procedure SetSize(const Value: Integer);
    procedure SetHandle(const Value: HIcon);
    function GetHotSpot: TPoint;
    function GetEmpty: Boolean;
  protected
    procedure SetData(const Data);

    destructor Destroy; virtual;
  public
    property Size : Integer read fResData.FSize write SetSize;
    {* Icon dimension (width and/or height, which are equal to each other always). }
    property Handle : HIcon read fResData.FHandle write SetHandle;
    {* Windows icon object handle. }
    procedure Clear;
    {* Clears icon, freeing image and allocated GDI resource (Handle). }
    property Empty: Boolean read GetEmpty;
    {* Returns True if icon is Empty. }
    property ShareIcon : Boolean read fResData.FShareIcon write fResData.FShareIcon;
    {* True, if icon object is shared and can not be deleted when TGDIIcon object
       is destroyed (set this flag is to True, if an icon is obtained from another
       TGDIIcon object, for example). }
    property HotSpot : TPoint read GetHotSpot;
    {* Hot spot point - for cursors. }
    procedure Draw( DC : HDC; X, Y : Integer );
    {* Draws icon onto given device context. Icon always is drawn transparently
       using its transparency mask (stored internally in icon object). }
    procedure StretchDraw( DC : HDC; Dest : TRect );
    {* Draws icon onto given device context with stretching it to fit destination
       rectangle. See also Draw. }
    procedure LoadFromStream( Strm : PStream );
    {* Loads icon from stream. If stream contains several icons (of
       different dimentions), icon with the most appropriate size is loading. }
    procedure LoadFromFile( const FileName : String );
    {* Load icon from file. If file contains several icons (of
       different dimentions), icon with the most appropriate size is loading. }
    procedure LoadFromResourceID( Inst: Integer; ResID: Integer; DesiredSize: Integer );
    {* Loads icon from resource. To load system default icon, pass 0 as Inst and
       one of followin values as ResID:
       |<pre>
       IDI_APPLICATION  Default application icon.
       IDI_ASTERISK     Asterisk (used in informative messages).
       IDI_EXCLAMATION  Exclamation point (used in warning messages).
       IDI_HAND         Hand-shaped icon (used in serious warning messages).
       IDI_QUESTION     Question mark (used in prompting messages).
       IDI_WINLOGO      Windows logo.
       |</pre> It is also possible to load icon from resources of another module,
       if pass instance handle of loaded module as Inst parameter. }
    procedure LoadFromResourceName( Inst: Integer; ResName: PChar; DesiredSize: Integer );
    {* Loads icon from resource. To load own application resource, pass
       hInstance as Inst parameter. It is possible to load resource from
       another module, if pass its instance handle as Inst. }
    procedure SaveToStream( Strm : PStream );
    {* Saves single icon to stream. To save icons with several different
       dimensions, use global procedure SaveIcons2Stream. }
    procedure SaveToFile( const FileName : String );
    {* Saves single icon to file. To save icons with several different
       dimensions, use global procedure SaveIcons2File. }
    function Convert2Bitmap( TranColor: TColor ): HBitmap;
    {* Converts icon to bitmap, returning Windows GDI bitmap resource as
       a result. It is possible later to assign returned bitmap handle to
       Handle property of TBitmap object to use features of TGDIBitmap.
       Pass TranColor to replace transparent area of icon with given color. }
  end;






{----------------------------------------------------------------------

                      TBitmap - bitmap image

-----------------------------------------------------------------------}



  TGDIBitmap = object( TGDIObject )
  {* Bitmap incapsulation object. }
  private
    FResData: TGDIBitmapData;
    fBkColor: TColor;

    fTransMaskBmp: PGDIBitmap;
    fTransColor: TColor;

    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    function GetEmpty: Boolean;
    function GetHandle: HBitmap;
    procedure SetHandle(const Value: HBitmap);
    procedure SetPixelFormat(Value: TPixelFormat);
    procedure FormatChanged;
    function GetCanvas: PGDICanvas;
    procedure CanvasChanged( Sender: PObj );
    function GetScanLineSize: Integer;
    function GetScanLine(Y: Integer): Pointer;
    procedure ClearData;
    procedure ClearTransImage;
    procedure SetBkColor(const Value: TColor);
    procedure SetHandleType(const Value: TBitmapHandleType);
    function GetPixelFormat: TPixelFormat;
    function GetPixels(X, Y: Integer): TColor;
    procedure SetPixels(X, Y: Integer; const Value: TColor);
  protected
    procedure SetData(const Data);
    destructor Destroy; virtual;
  public
    procedure Check;

    property Width: Integer read FResData.fBmp.bmWidth write SetWidth;
    {* Width of bitmap. To make code smaller, avoid changing Width or Height
       after bitmap is created (using NewBitmap) or after it is loaded from
       file, stream of resource. }
    property Height: Integer read FResData.fBmp.bmHeight write SetHeight;
    {* Height of bitmap. To make code smaller, avoid changing Width or Height
       after bitmap is created (using NewBitmap) or after it is loaded from
       file, stream of resource. }
    property Empty: Boolean read GetEmpty;
    {* Returns True if Width or Height is 0. }
    procedure Clear;
    {* Makes bitmap empty, setting its Width and Height to 0. }
    procedure LoadFromFile( const Filename: String );
    {* Loads bitmap from file (LoadFromStream used). }
    function LoadFromFileEx( const Filename: String ): Boolean;
    {* Loads bitmap from a file. If necessary, bitmap is RLE-decoded. Code given
       by Vyacheslav A. Gavrik. }
    procedure SaveToFile( const Filename: String );
    {* Stores bitmap to file (SaveToStream used). }
    procedure LoadFromStream( Strm: PStream );
    {* Loads bitmap from stream. Follow loading, bitmap has DIB format (without
       handle allocated). It is possible to draw DIB bitmap without creating
       handle for it, which can economy GDI resources. }
    function LoadFromStreamEx( Strm: PStream ): Boolean;
    {* Loads bitmap from a stream. Difference is that RLE decoding supported.
       Code given by Vyacheslav A. Gavrik. }
    procedure SaveToStream( Strm: PStream );
    {* Saves bitmap to stream. If bitmap is not DIB, it is converted to DIB
       before saving. }
    procedure LoadFromResourceID( Inst: DWORD; ResID: Integer );
    {* Loads bitmap from resource using integer ID of resource. To load by name,
       use LoadFromResurceName. To load resource of application itself, pass
       hInstance as first parameter. This method also can be used to load system
       predefined bitmaps, if 0 is passed as Inst parameter:
       |<pre>
       OBM_BTNCORNERS	OBM_REDUCE
       OBM_BTSIZE       OBM_REDUCED
       OBM_CHECK        OBM_RESTORE
       OBM_CHECKBOXES   OBM_RESTORED
       OBM_CLOSE        OBM_RGARROW
       OBM_COMBO        OBM_RGARROWD
       OBM_DNARROW      OBM_RGARROWI
       OBM_DNARROWD     OBM_SIZE
       OBM_DNARROWI     OBM_UPARROW
       OBM_LFARROW      OBM_UPARROWD
       OBM_LFARROWD     OBM_UPARROWI
       OBM_LFARROWI     OBM_ZOOM
       OBM_MNARROW      OBM_ZOOMD
       |</pre>        }
    procedure LoadFromResourceName( Inst: DWORD; ResName: PChar );
    {* Loads bitmap from resurce (using passed name of bitmap resource. }
    function Assign( SrcBmp: PGDIBitmap ): Boolean;
    {* Assigns bitmap from another. Returns False if not success.
       Note: remember, that Canvas is not assigned - only bitmap image
       is copied. And for DIB, handle is not allocating due this process. }
    property Handle: HBitmap read GetHandle write SetHandle;
    {* Handle of bitmap. Created whenever property accessed. To check if handle
       is allocated (without allocating it), use HandleAllocated property. }
    procedure Dormant;
    {* Releases handle from bitmap and destroys it. But image is not destroyed
       and its data are preserved in DIB format. Please note, that in KOL, DIB
       bitmaps can be drawn onto given device context without allocating of
       handle. So, it is very useful to call Dormant preparing it using
       Canvas drawing operations - to economy GDI resources. }
    property HandleType: TBitmapHandleType read FResData.fHandleType write SetHandleType;
    {* bmDIB, if DIB part of image data is filled and stored internally in
       TBitmap object. DIB image therefore can have Handle allocated, which
       require resources. Use HandleAllocated funtion to determine if handle
       is allocated and Dormant method to remove it, if You want to economy
       GDI resources. (Actually Handle needed for DIB bitmap only in case
       when Canvas is used to draw on bitmap surface). Please note also, that
       before saving bitmap to file or stream, it is converted to DIB. }
    property PixelFormat: TPixelFormat read GetPixelFormat write SetPixelFormat;
    {* Current pixel format. If format of bitmap is unknown, or bitmap is DDB,
       value is pfDevice. Setting PixelFormat to any other format converts
       bitmap to DIB, back to pfDevice converts bitmap to DDB again. Avoid
       such conversations for large bitmaps or for numerous bitmaps in your
       application to keep good performance. }
    procedure Draw( DC: HDC; X, Y: Integer );
    {* Draws bitmap to given device context. If bitmap is DIB, it is always
       drawing using SetDIBitsToDevice API call, which does not require bitmap
       handle (so, it is very sensible to call Dormant method to free correspondent
       GDI resources). }
    procedure StretchDraw( DC: HDC; const Rect: TRect );
    {* Draws bitmap onto DC, stretching it to fit given rectangle Rect. }
    procedure DrawTransparent( DC: HDC; X, Y: Integer; TranspColor: TColor );
    {* Draws bitmap onto DC transparently, using TranspColor as transparent. }
    procedure StretchDrawTransparent( DC: HDC; const Rect: TRect; TranspColor: TColor );
    {* Draws bitmap onto given rectangle of destination DC (with stretching it
       to fit Rect) - transparently, using TranspColor as transparent. }
    procedure DrawMasked( DC: HDC; X, Y: Integer; Mask: HBitmap );
    {* Draws bitmap to destination DC transparently by mask. It is possible
       to pass as a mask handle of another TBitmap, previously converted to
       monochrome mask using Convert2Mask method. }
    procedure StretchDrawMasked( DC: HDC; const Rect: TRect; Mask: HBitmap );
    {* Like DrawMasked, but with stretching image onto given rectangle. }
    procedure Convert2Mask( TranspColor: TColor );
    {* Converts bitmap to monochrome (mask) bitmap with TranspColor replaced
       to clBlack and all other ones to clWhite. Such mask bitmap can be used
       to draw original bitmap transparently, with given TranspColor as
       transparent. (To preserve original bitmap, create new instance of
       TBitmap and assign original bitmap to it). See also DrawTransparent and
       StretchDrawTransparent methods. }
    property Canvas: PGDICanvas read GetCanvas;
    {* Canvas can be used to draw onto bitmap. Whenever it is accessed, handle
       is allocated for bitmap, if it is not yet (to make it possible
       to select bitmap to display compatible device context). }
    property BkColor: TColor read fBkColor write SetBkColor;
    {* Used to fill background for Bitmap, when its width or height is increased.
       Although this value always synchronized with Canvas.Brush.Color, use it
       instead if You do not use Canvas for drawing on bitmap surface. }
    property Pixels[ X, Y: Integer ]: TColor read GetPixels write SetPixels;
    {* Allows to obtain or change certain pixels of a bitmap. This method is
       both for DIB and DDB bitmaps, and leads to allocate handle anyway. For
       DIB bitmaps, it is possible to use property DIBPixels[ ] instead,
       which is much faster and does not require in Handle. }
    property ScanLineSize: Integer read GetScanLineSize;
    {* Returns size of scan line in bytes. Use it to measure size of a single
       ScanLine. To calculate increment value from first byte of ScanLine to
       first byte of next ScanLine, use difference
       !  Integer(ScanLine[1]-ScanLine[2])
       (this is because bitmap can be oriented from bottom to top, so
       step can be negative). }
    property DIBBits: Pointer read FResData.fBmp.bmBits;
    {* This property is mainly for internal use. }
    property DIBSize: Integer read FResData.fDIBSize;
    {* Size of DIBBits array. }
    property DIBHeader: PBitmapInfo read FResData.fDIBHeader;
    {* This property is mainly for internal use. }
    procedure FlipVertical;
    {* Flips bitmap vertically }
    procedure FlipHorizontal;
    {* Flips bitmap horizontally }
    procedure CopyRect( const DstRect : TRect; SrcBmp : PGDIBitmap; const SrcRect : TRect );
    {* It is possible to use Canvas.CopyRect for such purpose, but if You
       do not want use TCanvas, it is possible to copy rectangle from one
       bitmap to another using this function. }
    function CopyToClipboard: Boolean;
    {* Copies bitmap to clipboard. }
    function PasteFromClipboard: Boolean;
    {* Takes CF_DIB format bitmap from clipboard and assigns it to the
       TBitmap object. }
  end;






var
    GlobalCanvas_OnTextArea : TOnGDITextArea;
    {* Global event to extend Canvas with possible add-ons, applied
       when rotated fonts are used only (to take into consideration
       Font.Orientation property in TextArea method). }

function NewGDIFont: PGDIToolObject;
{* Creates and returns font graphic tool object. }
function NewGDIBrush: PGDIToolObject;
{* Creates and returns new brush object. }
function NewGDIPen: PGDIToolObject;
{* Creates and returns new pen object. }

function NewGDICanvas( DC: HDC ): PGDICanvas;
{* Use to construct Canvas on base of memory DC. }

function NewGDIIcon: PGDIIcon;


function NewGDIBitmap( W, H: Integer ): PGDIBitmap;
{* Creates bitmap object of given size. If it is possible, do not change its
   size (Width and Heigth) later - this can economy code a bit. See TGDIBitmap. }

function NewGDIDIBBitmap( W, H: Integer; PixelFormat: TPixelFormat ): PGDIBitmap;
{* Creates DIB bitmap object of given size and pixel format. If it is possible,
   do not change its size (Width and Heigth) later - this can economy code a bit.
   See TGDIBitmap. }






implementation

type

  PGDIResourceManager = ^TGDIResourceManager;
  TGDIResourceManager = object
  protected
    GTResList: PGTResource;
    ImageResList: PImageResource;
    constructor Create;
    procedure Free;

    function AllocGraphicToolResource(const ResData): PGTResource;
    procedure FreeGraphicToolResource(Resource: PGTResource);
    procedure ChangeGraphicToolResource(GDIObject: PGDIToolObject; const ResData);


    function AllocImageResource(const ResData): PImageResource;
    procedure FreeImageResource(Resource: PImageResource);
    procedure ChangeImageResource(GDIObject: PGDIObject; const ResData);

    procedure AssignResource(GDIObject: PGDIObject; AResource: PImageResource);

  end;

var
  ResourceManager:PGDIResourceManager;

var    // New TFont instances are intialized with the values in this structure:
  DefFontData: TGDIFontData = (
    LogFont: (
      lfHeight: 0;
      lfWidth: 0;
      lfEscapement: 0;
      lfOrientation: 0;
      lfWeight: 0;
      lfItalic: 0;
      lfUnderline: 0;
      lfStrikeOut: 0;
      lfCharSet: DEFAULT_CHARSET;
      lfOutPrecision: OUT_DEFAULT_PRECIS;
      lfClipPrecision: CLIP_DEFAULT_PRECIS;
      lfQuality: fqDefault;
      lfPitchAndFamily: fpDefault;
      lfFaceName: 'MS Sans Serif'));

  DefBrushData: TGDIBrushData = (
    LogBrush: (
      lbStyle: BS_SOLID;
      lbColor: clWhite;
      lbHatch: 0));

  DefPenData: TGDIPenData = (
    LogPen: (
      lopnStyle: PS_SOLID;
      lopnWidth: (
        x: 1;
        y: 0);
      lopnColor: clBlack;);
    fPattern:(
      lbStyle: BS_SOLID;
      lbColor: clBlack;
      lbHatch: 0);
//    fPatternBitmap: 0;
    fPenMode: pmCopy;
    fGeometricPen: False;
      );

  DefIconData : TResoursceIconData = (
    FHandle: 0;
    FSize : 32;
    FShareIcon: true);

  DefBitmapData: TGDIBitmapData = (
    BmpHandle: 0;
    fBmp:(
      bmWidth : 0;
      bmHeight: 0;
      bmBits:nil);
    fHandleType: bmDDB;

    fDIBHeader: nil;
    fDIBSize: 0;
    fDIBAutoFree: False;
    fNewPixelFormat: pfDevice;

    fScanLineSize: 0);



const
    WorkWinVer: TWindowsVersion = TWindowsVersion(-1);


function isWinGoodWin:boolean;
begin
  if WorkWinVer = TWindowsVersion(-1) then
    WorkWinVer:=WinVer;
  result:=WorkWinVer >= wvNT;
end;


///////////////////////////////////////////////////////////////////////
//
//
//                             Resourse manager
//
//
///////////////////////////////////////////////////////////////////////


function GetHashCode(const Buffer; Count: Integer): Word; assembler;
asm
        MOV     ECX,EDX
        MOV     EDX,EAX
        XOR     EAX,EAX
@@1:    ROL     AX,5
        XOR     AL,[EDX]
        INC     EDX
        DEC     ECX
        JNE     @@1
end;

constructor TGDIResourceManager.Create;
begin
  inherited;
end;

procedure TGDIResourceManager.Free;assembler;
begin
  if (GTResList <> nil) or
     (GTResList <> nil) then
  ShowMessage('Error');
  inherited;
end;
{asm
        TEST    EAX,EAX
        JE      @@exit
        XOR       EDX, EDX
        CALL      System.@FreeMem
@@exit:
end;}

type
  _PGTResData = ^_TGTResData;
  _TGTResData = record
    HeaderData: TGTResUserData;
    UserData: array [0..0] of byte;
  end;

  _PGDIResData = ^_TGDIResData;
  _TGDIResData = record
    HeaderData: TGDIResData;
    UserData: array [0..0] of byte;
  end;

  
function TGDIResourceManager.AllocGraphicToolResource(const ResData): PGTResource;
const
  ResInfoSize = SizeOf(TGTResource) - SizeOf(TGTResUserData);
var
  ResHash: Word;
  ResSize: Word;
begin
  ResSize:=TGTResData(ResData).DataSize;
  ResHash := GetHashCode(_TGTResData(ResData).UserData, ResSize);
  Result := GTResList;
    while (Result <> nil) and (
      not ((Result^.HashCode = ResHash) and
           (Result^.Data.DataSize = ResSize)) or
      not CompareMem(@Result^.Font, @_TGTResData(ResData).UserData, ResSize)) do
      Result := Result^.Next;
    if Result = nil then
    begin
      GetMem(Result, ResSize + ResInfoSize);
      ResSize:=ResSize+SizeOf(TGTResData);
      with Result^ do
      begin
        Next := GTResList;
        RefCount := 0;
//        Data.Handle := TGTResData(ResData).Handle;
        HashCode := ResHash;
        Move(ResData, Data, ResSize);
//        Data.fCanvasAttached := 0;//??
      end;
      GTResList := Result;
    end;
    Inc(Result^.RefCount);
end;

procedure TGDIResourceManager.FreeGraphicToolResource(Resource: PGTResource);
var
  P: PGTResource;
  DeleteIt: Boolean;
begin
  if Resource <> nil then
    with Resource^ do
    begin
        Dec(RefCount);
        DeleteIt := RefCount = 0;
        if DeleteIt then
        begin
          if Resource = GTResList then
            GTResList := Resource^.Next
          else
          begin
            P := GTResList;
            while P^.Next <> Resource do P := P^.Next;
            P^.Next := Resource^.Next;
          end;
        end;
      if DeleteIt then
      begin  // this is outside the critsect to minimize lock time
         if Resource^.Data.Handle <> 0 then
           DeleteObject(Resource^.Data.Handle);
         FreeMem(Resource);
      end;
    end;
end;

procedure TGDIResourceManager.ChangeGraphicToolResource(GDIObject: PGDIToolObject;
    const ResData);
var
  P: PGTResource;
begin
    P := GDIObject^.FResource;

    begin
      GDIObject^.FResource := AllocGraphicToolResource(ResData);
      if GDIObject^.FResource <> P then
        GDIObject^.ChangedNoRebuildHandle;
      FreeGraphicToolResource(PGTResource(P));
    end;
end;

procedure TGDIResourceManager.AssignResource(GDIObject: PGDIObject; AResource: PImageResource);
var
  P: PImageResource;
begin
{    P := GDIObject^.FResource;
    if P <> AResource then
    begin
      Inc(AResource^.RefCount);
      GDIObject^.FResource := AResource;
      GDIObject^.ChangedNoRebuildHandle;
      FreeResource(P);
    end;}
end;


function TGDIResourceManager.AllocImageResource(const ResData): PImageResource;
const
  ResInfoSize = SizeOf(TImageResource) - SizeOf(TImageResData);
var
  ResHash: Word;
  ResSize: Word;
begin
  ResSize:=TGDIResData(ResData).DataSize;
  ResHash := GetHashCode(_TGDIResData(ResData).UserData, ResSize);
  Result := ImageResList;
    while (Result <> nil) and (
      not ((Result^.HashCode = ResHash) and
           (TGDIResData(Result^.Data).DataSize = ResSize)) or
      not CompareMem(@Result^.CustomData, @_TGDIResData(ResData).UserData, ResSize)) do
      Result := Result^.Next;
    if Result = nil then
    begin
      GetMem(Result, ResSize + ResInfoSize);
      ResSize:=ResSize+SizeOf(TGDIResData);
      with Result^ do
      begin
        Next := ImageResList;
        RefCount := 0;
//        Data.Handle := TGDIResData(ResData).Handle;
        HashCode := ResHash;
        Move(ResData, Data, ResSize);
//        Data.fCanvasAttached := 0;//??
      end;
      ImageResList := Result;
    end;
    Inc(Result^.RefCount);
end;

procedure TGDIResourceManager.FreeImageResource(Resource: PImageResource);
var
  P: PImageResource;
  DeleteIt: Boolean;
begin
  if Resource <> nil then
    with Resource^ do
    begin
        Dec(RefCount);
        DeleteIt := RefCount = 0;
        if DeleteIt then
        begin
          if Resource = ImageResList then
            ImageResList := Resource^.Next
          else
          begin
            P := ImageResList;
            while P^.Next <> Resource do P := P^.Next;
            P^.Next := Resource^.Next;
          end;
        end;
      if DeleteIt then
      begin  // this is outside the critsect to minimize lock time
         if Assigned(Resource.Data.DeleteResProc) then
           Resource.Data.DeleteResProc(Resource);
         FreeMem(Resource);
      end;
    end;
end;

procedure TGDIResourceManager.ChangeImageResource(GDIObject: PGDIObject;
    const ResData);
var
  P: PImageResource;

  function ReAllocResource(const ResData): PImageResource;
  var
    ResHash: Word;
    ResSize: Word;
  begin
    ResSize:=TGDIResData(ResData).DataSize;
    ResHash := GetHashCode(_TGDIResData(ResData).UserData, ResSize);
    Result := ImageResList;
      while (Result <> nil) and (
        not ((Result^.HashCode = ResHash) and
             (TGDIResData(Result^.Data).DataSize = ResSize)) or
        not CompareMem(@Result^.CustomData, @_TGDIResData(ResData).UserData, ResSize)) do
        Result := Result^.Next;

      if Result = nil then
      begin
        if Assigned(P.Data.DeleteResProc) then
          P.Data.DeleteResProc(P);
        Result:=P;
        ResSize:=ResSize+SizeOf(TGDIResData);
        with Result^ do
        begin
//          Data.Handle := TGDIResData(ResData).Handle;
          HashCode := ResHash;
          Move(ResData, Data, ResSize);
        end;
      end else
      begin
        if Result <> P then
        begin
          FreeImageResource(P);
          Inc(Result^.RefCount);
        end;
      end;
  end;
begin
    P := GDIObject^.FImageResource;

{    if P.RefCount = 1 then
    begin
      GDIObject^.FResource:=ReAllocResource(ResData);
    end
    else
}    begin
      GDIObject^.FImageResource := AllocImageResource(ResData);
      if GDIObject^.FImageResource <> P then
        GDIObject^.ChangedNoRebuildHandle;
      FreeImageResource(P);
    end;
end;

///////////////////////////////////////////////////////////////////////
//
//
//                             GDI Object
//
//
///////////////////////////////////////////////////////////////////////


procedure TGDIObject.Changed;
begin
  FGDIResData.Handle:=0; // Need to Rebuild Handle
  ChangedNoRebuildHandle;
end;

procedure TGDIObject.ChangedNoRebuildHandle;
begin
   if Assigned( fOnChange ) then
      fOnChange( @Self );
end;

function TGDIObject.GetHandleAllocated: Boolean;
begin
  Result := (FImageResource <> nil) and (FImageResource^.Data.Handle <> 0);
end;

///////////////////////////////////////////////////////////////////////
//
//
//                             GDI Tool Object
//
//
///////////////////////////////////////////////////////////////////////

procedure DeleteGDIBrushObjectResourse(GDIRes: PImageResource);
begin
  if GDIRes^.Data.Handle <> 0 then
    DeleteObject(GDIRes^.Data.Handle);
//  if GDIRes^.Brush.BrushPatternBitmap <> 0 then
//    DeleteObject( GDIRes^.Brush.BrushPatternBitmap );
end;


procedure DeleteGDIObjectResourse(GDIRes: PImageResource);
begin
  if GDIRes^.Data.Handle <> 0 then
    DeleteObject(GDIRes^.Data.Handle);
end;


type
  PWndControl = ^TWndControl;
  TWndControl = object(TControl)
  end;

  PWndGraphicTool = ^TWndGraphicTool;
  TWndGraphicTool = object( TGraphicTool )
  end;


function MakeBrushHandle( Self_: PGDIToolObject ): Integer;
var
  LogBrush: TLogBrush;
  TempColor:TColorRef;
begin
  with Self_^.FResource^ do
  begin
    if Data.Handle = 0 then
    begin
        if Data.Handle = 0 then
        begin
          Data.Handle := CreateBrushIndirect(TLogBrush(Brush.LogBrush));
        end;
    end;
    Result := Data.Handle;
  end;
end;

function MakeFontHandle( Self_: PGDIToolObject ): Integer;
begin
    if Self_.FResource^.Data.Handle = 0 then
    begin
       PGTResource(Self_^.FResource)^.Data.Handle :=
         CreateFontIndirect(TLogFont(PGTResource(Self_^.FResource)^.Font.LogFont));
       {$IFDEF DEBUG_GDIOBJECTS}
       Inc( FontCount );
       {$ENDIF}
    end;
    Result := PGTResource(Self_^.FResource)^.Data.Handle;
end;

function MakePenHandle( Self_: PGDIToolObject ): Integer;
var
  LogPen: TLogPen;
begin
  if Self_^.FResource^.Data.Handle = 0 then
  begin
    with LogPen do
    begin
      PGTResource(Self_^.FResource)^.Data.Handle := CreatePenIndirect( PGTResource(Self_^.FResource)^.Pen.LogPen);
      {$IFDEF DEBUG_GDIOBJECTS}
      Inc( PenCount );
      {$ENDIF}
    end;
    Result := PGTResource(Self_^.FResource)^.Data.Handle;
  end;
end;

function MakeGeometricPenHandle( Self_: PGDIToolObject ): Integer;
const
  PenStyles: array[ TPenStyle ] of Word =
    (PS_SOLID, PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT, PS_NULL,
     PS_INSIDEFRAME);
begin
  if Self_.FResource^.Data.Handle = 0 then
  begin
    PGTResource(Self_.FResource)^.Data.Handle := ExtCreatePen( PS_GEOMETRIC or PGTResource(Self_.FResource)^.Pen.LogPen.lopnStyle,
        PGTResource(Self_.FResource)^.Pen.LogPen.lopnWidth.X, TLogBrush(PGTResource(Self_.FResource)^.Pen.fPattern), 0, nil );
  end;
  {$IFDEF DEBUG_GDIOBJECTS}
  Inc( PenCount );
  {$ENDIF}
  Result := PGTResource(Self_.FResource)^.Data.Handle;
end;


function _NewGraphicTool: PGDIToolObject;
begin
  New( Result, Create );
end;

function NewGDIFont: PGDIToolObject;
begin
  Result := _NewGraphicTool;
  with Result^ do
  begin
    fType := gttFont;
    fMakeHandleProc := MakeFontHandle;

    fColor := DefFontColor;
    FGTResData.Handle:=0;
    FGTResData.DataSize:=SizeOf(TGDIFontData);
    FResource := ResourceManager.AllocGraphicToolResource(FGTResData);

  end;
end;

function NewGDIBrush: PGDIToolObject;
begin
  Result := _NewGraphicTool;
  with Result^ do
  begin
    fType := gttBrush;
    fMakeHandleProc := MakeBrushHandle;

    fColor := clWhite;
    Result^.FResData.Brush:=DefBrushData;
    Result^.FGTResData.Handle:=0;
    Result^.FGTResData.DataSize:=SizeOf(TGDIBrushData);
    Result^.FResource := ResourceManager.AllocGraphicToolResource(FGTResData);

  end;
end;

function NewGDIPen: PGDIToolObject;
begin
  Result := _NewGraphicTool;
  with Result^ do
  begin
    fType := gttPen;
    fMakeHandleProc := MakePenHandle;

    fColor := clBlack;
    Result^.FResData.Pen:=DefPenData;
    Result^.FGTResData.Handle:=0;
    Result^.FGTResData.DataSize:=SizeOf(TGDIPenData);

    Result^.FResource := ResourceManager.AllocGraphicToolResource(FGTResData);

  end;
end;


{ TGDIObject }



function TGDIToolObject.Assign(Value: PGDIToolObject): PGDIToolObject;
var _Self: PGDIToolObject;
begin
  FGTResData:=Value.FGTResData;
  FResData:=Value.FResData;
  SetData(FGTResData);
{
  Result := nil;
  if Value = nil then
  begin
    if @Self <> nil then
       DoDestroy;
    Exit;
  end;
  _Self := @Self;
  if _Self = nil then
  begin
        New(_Self,Create);
  end;
  if _Self.Handle <> 0 then
  begin
     if Value.Handle = _Self.Handle then Exit;
  end;

//// Assign
  ResourceManager.AssignResource(_Self, Value.FResource);
  _Self.fColor:=Value.fColor;


//?        if PixelsPerInch <> TFont(Source).PixelsPerInch then
//?          Size := TFont(Source).Size;
//  _Self.Assign(Value);

  Result := _Self;
}
end;

procedure TGDIToolObject.AssignHandle(NewHandle: Integer);
begin
  Assert(false,'NOT FOUND');
//  Changed;
//  Handle := NewHandle;
end;

destructor TGDIToolObject.Destroy;
begin
  ResourceManager.FreeGraphicToolResource(FResource);
  inherited;
end;


{function TGDIToolObject.ReleaseHandle: Integer;
begin
  ChangedNoRebuildHandle;
  Result := fHandle;
  fHandle := 0;
end;}

procedure TGDIToolObject.Changed;
begin
  FGTResData.Handle:=0; // Need to Rebuild Handle
  ChangedNoRebuildHandle;
end;

procedure TGDIToolObject.ChangedNoRebuildHandle;
begin
   if Assigned( fOnChange ) then
      fOnChange( @Self );
end;

function TGDIToolObject.GetHandleAllocated: Boolean;
begin
  Result := (FResource <> nil) and (PGTResource(FResource)^.Data.Handle <> 0);
end;

procedure TGDIToolObject.SetData(const Data);
begin
    ResourceManager.ChangeGraphicToolResource(@Self, Data);
end;

procedure TGDIToolObject.SetColor(Value: TColor);
begin
  if fColor = Value then Exit;

  fColor := Value;

  case fType  of
  gttFont: begin
             ChangedNoRebuildHandle;
             exit;
           end;
  gttBrush: begin
              FResData.Brush.LogBrush.lbColor := Color2RGB(fColor);
              if FResData.Brush.LogBrush.lbStyle = BS_HOLLOW then
                FResData.Brush.LogBrush.lbStyle := BS_SOLID;
            end;
  gttPen: begin
              FResData.Pen.LogPen.lopnColor := Color2RGB(fColor);
              FResData.Pen.fPattern.lbColor := Color2RGB(fColor);
            end;
  end;
  Changed;
end;

function TGDIToolObject.IsFontTrueType: Boolean;
var OldFont: HFont;
    DC: HDC;
begin
  Result := False;
  if GetHandle = 0 then Exit;
  DC := GetDC( 0 );
  OldFont := SelectObject( DC, PGTResource(FResource)^.Data.Handle );
  if GetFontData( DC, 0, 0, nil, 0 ) <> GDI_ERROR then
     Result := True;
  SelectObject( DC, OldFont );
  ReleaseDC( 0, DC );
end;

procedure TGDIToolObject.SetBrushBitmap(const Value: HBitmap);
begin
  if (FResData.Brush.LogBrush.lbHatch = Value) and
      (FResData.Brush.LogBrush.lbStyle = BS_PATTERN) then Exit;
  FResData.Brush.LogBrush.lbStyle := BS_PATTERN;
  FResData.Brush.LogBrush.lbHatch := Value;
  Changed;
end;

procedure TGDIToolObject.SetBrushStyle(const Value: TBrushStyle);
var
 NewlbStyle:UINT;
 NewlbHatch:UINT;
begin
  NewlbHatch:=0;
  case Value of
     bsSolid: NewlbStyle := BS_SOLID;
     bsClear: NewlbStyle := BS_NULL;
  else
      begin
        NewlbStyle := BS_HATCHED;
        NewlbHatch := Ord(Value) - Ord(bsHorizontal);
      end;
  end;

  if (NewlbStyle = FResData.Brush.LogBrush.lbStyle) and
     (NewlbHatch = FResData.Brush.LogBrush.lbHatch) then exit;

  FResData.Brush.LogBrush.lbStyle:=NewlbStyle;
  FResData.Brush.LogBrush.lbHatch:=NewlbHatch;

  Changed;
end;


procedure TGDIToolObject.SetFontCharset(const Value: TFontCharset);
begin
  if FResData.Font.LogFont.lfCharSet = Value then Exit;
  FResData.Font.LogFont.lfCharSet := Value;
  Changed;
end;

procedure TGDIToolObject.SetFontHeight(const Value: Integer);
begin
  if FResData.Font.LogFont.lfHeight = Value then Exit;
  FResData.Font.LogFont.lfHeight := Value;
  Changed;
end;

procedure TGDIToolObject.SetFontWidth(const Value: Integer);
begin
  if FResData.Font.LogFont.lfWidth = Value then Exit;
  FResData.Font.LogFont.lfWidth := Value;
  Changed;
end;

function TGDIToolObject.GetFontName: string;
begin
  result:=FResData.Font.LogFont.lfFaceName;
end;

procedure TGDIToolObject.SetFontName(const Value: string);
begin
  if Value = 'Default' then  // do not localize
    StrCopy( FResData.Font.LogFont.lfFaceName, DefFontData.LogFont.lfFaceName )
  else
    StrCopy( FResData.Font.LogFont.lfFaceName, PChar(Value) );
  Changed;
end;


procedure TextAreaEx( Sender: PGDICanvas; var Sz : TSize; var Pt : TPoint );
var Orient : Integer;
    Pts : array[ 1..4 ] of TPoint;
    MinX, MinY, I : Integer;
    A : Double;
begin
   if not Sender.Font.IsFontTrueType then Exit;
   Orient := PGTResource(Sender.Font.FResource)^.Font.LogFont.lfOrientation;
   Pt.x := 0; Pt.y := 0;
   if Orient = 0 then
      Exit;
   A := Orient / 1800.0 * PI;
   Pts[ 1 ] := Pt;
   Pts[ 2 ].x := Round( Sz.cx * cos( A ) );
   Pts[ 2 ].y := - Round( Sz.cx * sin( A ) );
   Pts[ 4 ].x := - Round( Sz.cy * cos( A + PI / 2 ) );
   Pts[ 4 ].y := Round( Sz.cy * sin( A + PI / 2 ) );
   Pts[ 3 ].x := Pts[ 2 ].x + Pts[ 4 ].x;
   Pts[ 3 ].y := Pts[ 2 ].y + Pts[ 4 ].y;
   MinX := 0; MinY := 0;
   for I := 2 to 4 do
   begin
      if Pts[ I ].x < MinX then
         MinX := Pts[ I ].x;
      if Pts[ I ].y < MinY then
         MinY := Pts[ I ].y;
   end;
   Sz.cx := 0;
   Sz.cy := 0;
   for I := 1 to 4 do
   begin
      Pts[ I ].x := Pts[ I ].x - MinX;
      Pts[ I ].y := Pts[ I ].y - MinY;
      if Pts[ I ].x > Sz.cx then
         Sz.cx := Pts[ I ].x;
      if Pts[ I ].y > Sz.cy then
         Sz.cy := Pts[ I ].y;
   end;
   Pt := Pts[ 1 ];
end;

procedure TGDIToolObject.SetFontOrientation(Value: Integer);
begin
  Value := Value mod 3600; // -3599..+3599
  if FResData.Font.LogFont.lfOrientation = Value then Exit;
  FResData.Font.LogFont.lfOrientation := Value;
  FResData.Font.LogFont.lfOrientation := Value;
  GlobalGraphics_UseFontOrient := True;
  GlobalCanvas_OnTextArea := TextAreaEx;
  Changed;
end;

procedure TGDIToolObject.SetFontPitch(const Value: TFontPitch);
begin
  if FResData.Font.LogFont.lfPitchAndFamily = Value then Exit;
  FResData.Font.LogFont.lfPitchAndFamily := Value;
  Changed;
end;

procedure TGDIToolObject.SetFontQuality(const Value: TGDIFontQuality);
begin
  if FResData.Font.LogFont.lfQuality = Value then Exit;
  FResData.Font.LogFont.lfQuality := Value;
  Changed;
end;


function TGDIToolObject.GetFontStyle: TFontStyle;
begin
  result:=[];
  if FResData.Font.LogFont.lfItalic <> 0 then
    result:=[fsItalic];
  if FResData.Font.LogFont.lfUnderline <> 0 then
    result:=[fsUnderline];
  if FResData.Font.LogFont.lfStrikeOut <> 0 then
    result:=[fsStrikeOut];
  if FResData.Font.LogFont.lfWeight <> FW_NORMAL then
    result:=[fsBold];
end;

procedure TGDIToolObject.SetFontStyle(const Value: TFontStyle);
begin
  if not( fsBold in Value) then
    FResData.Font.LogFont.lfWeight := FW_DONTCARE;
///? Need Thinks...

  FResData.Font.LogFont.lfItalic := Byte( fsItalic in Value );
  FResData.Font.LogFont.lfUnderline := Byte( fsUnderline in Value );
  FResData.Font.LogFont.lfStrikeOut := Byte( fsStrikeOut in Value );
  Changed;
end;

procedure TGDIToolObject.SetPenMode(const Value: TGDIPenMode);
begin
  if FResData.Pen.fPenMode = Value then Exit;
  FResData.Pen.fPenMode := Value;
  Changed;
end;

function TGDIToolObject.GetPenStyle:TPenStyle;
begin
  result:=TPenStyle(FResData.Pen.LogPen.lopnStyle and PS_STYLE_MASK);
end;

procedure TGDIToolObject.SetPenStyle(const Value: TPenStyle);
var
  NewlopnStyle:UINT;
  OldlopnStyle:UINT;
begin
  NewlopnStyle:=(ord(Value)) and PS_STYLE_MASK;
  OldlopnStyle:=(FResData.Pen.LogPen.lopnStyle and PS_STYLE_MASK);
  if OldlopnStyle = NewlopnStyle then exit;
  FResData.Pen.LogPen.lopnStyle:=FResData.Pen.LogPen.lopnStyle and (not PS_STYLE_MASK) or NewlopnStyle;
  Changed;
end;

procedure TGDIToolObject.SetPenWidth(const Value: Integer);
begin
  if FResData.Pen.LogPen.lopnWidth.X = Value then exit;
  FResData.Pen.LogPen.lopnWidth.X := Value;
  FResData.Pen.LogPen.lopnWidth.Y := 0;
  Changed;
end;

function TGDIToolObject.GetHandle: Integer;
begin
  Result := FGTResData.Handle;
  if (FGTResData.Handle = 0) or (FGTResData.Handle <> PGTResource(FResource)^.Data.Handle) then
  begin
    SetData(FGTResData);
  end;
  if Result = 0 then
  begin
     fMakeHandleProc( @Self );
     FGTResData.Handle:=PGTResource(FResource)^.Data.Handle;
     Result := PGTResource(FResource)^.Data.Handle;
  end;
end;

//+
procedure TGDIToolObject.SetGeometricPen(const Value: Boolean);
begin
  if fResData.Pen.fGeometricPen = Value then Exit;
  fResData.Pen.fGeometricPen := Value;
  if Value then
    fMakeHandleProc := MakeGeometricPenHandle
  else
    fMakeHandleProc := MakePenHandle;
  Changed;
end;


function TGDIToolObject.GetPenEndCap:TPenEndCap;
begin
  result:=TPenEndCap((FResData.Pen.LogPen.lopnStyle and PS_ENDCAP_MASK) shr 8);
end;

procedure TGDIToolObject.SetPenEndCap(const Value: TPenEndCap);
var
  NewlopnStyle:UINT;
  OldlopnStyle:UINT;
begin
  NewlopnStyle:=(integer(Value) shl 8) and PS_ENDCAP_MASK;
  OldlopnStyle:=(FResData.Pen.LogPen.lopnStyle and PS_ENDCAP_MASK);
  if OldlopnStyle = NewlopnStyle then exit;
  if isWinGoodWin then
  begin
     FResData.Pen.LogPen.lopnStyle:=FResData.Pen.LogPen.lopnStyle and (not PS_ENDCAP_MASK) or NewlopnStyle;
     Changed;
  end;
end;

function TGDIToolObject.GetPenJoin:TPenJoin;
begin
  result:=TPenJoin((FResData.Pen.LogPen.lopnStyle and PS_JOIN_MASK) shr 12);
end;

procedure TGDIToolObject.SetPenJoin(const Value: TPenJoin);
var
  NewlopnStyle:UINT;
  OldlopnStyle:UINT;
begin
  NewlopnStyle:=(integer(Value) shl 12) and PS_JOIN_MASK;
  OldlopnStyle:=(FResData.Pen.LogPen.lopnStyle and PS_JOIN_MASK);
  if OldlopnStyle = NewlopnStyle then exit;
  if isWinGoodWin then
  begin
    FResData.Pen.LogPen.lopnStyle:=FResData.Pen.LogPen.lopnStyle and (not PS_JOIN_MASK) or NewlopnStyle;
    Changed;
  end;
end;

procedure TGDIToolObject.SetPenBrushStyle(const Value: TBrushStyle);
var
 NewlbStyle:UINT;
 NewlbHatch:UINT;
begin
  NewlbHatch:=0;
  case Value of
     bsSolid: NewlbStyle := BS_SOLID;
     bsClear: NewlbStyle := BS_NULL;
  else
      begin
        if isWinGoodWin then
        begin
          NewlbStyle := BS_HATCHED;
          NewlbHatch := Ord(Value) - Ord(bsHorizontal);
        end else
          NewlbStyle := BS_SOLID;
      end;
  end;

  if (NewlbStyle = FResData.Pen.fPattern.lbStyle) and
     (NewlbHatch = FResData.Pen.fPattern.lbHatch) then exit;

  FResData.Pen.fPattern.lbStyle:=NewlbStyle;
  FResData.Pen.fPattern.lbHatch:=NewlbHatch;

  Changed;
end;

procedure TGDIToolObject.SetPenBrushBitmap(const Value: HBitmap);
var
 NewlbStyle:UINT;
 NewlbHatch:UINT;
begin
  NewlbHatch:=Value;
  NewlbStyle:=BS_PATTERN;

  if (NewlbStyle = FResData.Pen.fPattern.lbStyle) and
     (NewlbHatch = FResData.Pen.fPattern.lbHatch) then exit;

  if not isWinGoodWin then
  begin
//    Exit;//
    NewlbHatch:=0;
    NewlbStyle:=BS_SOLID;
  end;

  FResData.Pen.fPattern.lbStyle:=NewlbStyle;
  FResData.Pen.fPattern.lbHatch:=NewlbHatch;

  Changed;
end;

procedure TGDIToolObject.SetLogFont(const Value: TLogFont);
begin
  FResData.Font.LogFont:=TGDILogFont(Value);
  SetData(FResData);
end;

function TGDIToolObject.GetLogFont:TLogFont;
begin
  result:=TLogFont(FResData.Font.LogFont);
end;

procedure TGDIToolObject.SetFontWeight(const Value: Integer);
begin
  if FResData.Font.LogFont.lfWeight = Value then Exit;
  FResData.Font.LogFont.lfWeight := Value;
//  FResData.Font.Handle:=0;
  Changed;
end;









































///////////////////////////////////////////////////////////////////////
//
//
//                          G D I C a n v a s
//
//
///////////////////////////////////////////////////////////////////////









type
  TGDIStock = Packed Record
    StockPen: HPEN;
    StockBrush: HBRUSH;
    StockFont: HFONT;
  end;

var
  Stock: TGDIStock;


function NewGDICanvas( DC: HDC ): PGDICanvas;
begin
  New( Result, Create );
  Result^.ModeCopy := cmSrcCopy;
  if DC <> 0 then
  begin
    Result^.SetHandle( DC );
  end;
end;




destructor TGDICanvas.Destroy;
begin
  Handle := 0;
  fPen.Free;
  fBrush.Free;
  fFont.Free;
  inherited;
end;


function TGDICanvas.Assign(SrcCanvas: PGDICanvas): Boolean;
begin
  fFont := fFont.Assign( SrcCanvas.fFont );
  fBrush := fBrush.Assign( SrcCanvas.fBrush );
  fPen := fPen.Assign( SrcCanvas.fPen );
  AssignChangeEvents;
  Result := (fFont <> nil) or (fBrush <> nil) or (fPen <> nil);
  if (SrcCanvas.PenPos.x <> PenPos.x) or (SrcCanvas.PenPos.y <> PenPos.y) then
  begin
     Result := True;
     PenPos := SrcCanvas.PenPos;
  end;
  if SrcCanvas.ModeCopy <> ModeCopy then
  begin
     Result := True;
     ModeCopy := SrcCanvas.ModeCopy;
  end;
end;

procedure TGDICanvas.CreateBrush;
begin
//    UnrealizeObject( fBrush.Handle );
  // if GdiObject parameter of UnrealizeObject is brush handle,
  // this call does nothing (from Win32.hlp)

  if assigned( fBrush ) then
  begin
    SelectObject( fHandle, fBrush.Handle );
    AssignChangeEvents;
    if fBrush.FResData.Brush.LogBrush.lbStyle = BS_Solid then
    begin
      SetBkColor( fHandle, fBrush.FResData.Brush.LogBrush.lbColor);
      SetBkMode( fHandle, OPAQUE );
    end
       else
    begin
      { Win95 doesn't draw brush hatches if bkcolor = brush color }
      { Since bkmode is transparent, nothing should use bkcolor anyway }
      SetBkColor( fHandle, $00FFFFFF and (not fBrush.FResData.Brush.LogBrush.lbColor));
      SetBkMode( fHandle, TRANSPARENT );
    end;
  end
     else
  if Assigned( fOwnerControl ) then
  begin
    SetBkColor( GetHandle, Color2RGB( PControl( fOwnerControl ).Color ) );
    SetBkMode( fHandle, OPAQUE );
  end;
end;

procedure TGDICanvas.CreateFont;
begin
  if assigned( fFont ) then
  begin
    SelectObject( GetHandle, fFont.Handle );
    SetTextColor( fHandle, Color2RGB( fFont.fColor ) );
    AssignChangeEvents;
  end
     else
  if Assigned( fOwnerControl ) then
  begin
    SetTextColor( fHandle, Color2RGB( PControl( fOwnerControl ).ProgressColor{fTextColor} ) );
  end;
end;

procedure TGDICanvas.CreatePen;
begin
  if assigned( fPen ) then
  begin
    SelectObject( GetHandle, fPen.Handle );
    if SetROP2( fHandle, (ord(PGTResource(fPen.FResource)^.Pen.fPenMode))) = 0 then
      Sleep(200);//
    AssignChangeEvents;
  end;
end;

procedure TGDICanvas.DeselectHandles;
begin
   if (fHandle <> 0) and
      LongBool(fState and (PenValid or BrushValid or FontValid)) then
   with Stock do
   begin
     if StockPen = 0 then
     begin
       StockPen := GetStockObject(BLACK_PEN);
       StockBrush := GetStockObject(HOLLOW_BRUSH);
       StockFont := GetStockObject(SYSTEM_FONT);
     end;
     SelectObject(fHandle, StockBrush);
     SelectObject( fHandle, StockPen );
     SelectObject(fHandle, StockFont);

     fState := fState and not( PenValid or BrushValid or FontValid );
   end;

end;

function TGDICanvas.RequiredState(ReqState: DWORD): Integer; stdcall;
var
  NeededState: Byte;
begin
  if Boolean(ReqState and ChangingCanvas) then
     Changing;
  ReqState := ReqState and 15;
  NeededState := Byte( ReqState ) and not fState;
  Result := 0;
    if Boolean(ReqState and HandleValid) then
    begin
      if GetHandle = 0 then Exit;
      // Important!
    end;
  if NeededState <> 0 then
  begin
    if Boolean( NeededState and FontValid ) then
       CreateFont;
    if Boolean( NeededState and PenValid ) then
    begin
      CreatePen;
      if assigned( fPen ) then
      if (PGTResource(fPen.FResource)^.Pen.LogPen.lopnStyle and $F) in [PS_DASH..PS_DASHDOTDOT] then
        NeededState := NeededState or BrushValid;
    end;
    if Boolean( NeededState and BrushValid ) then
       CreateBrush;
    fState := fState or NeededState;
  end;
  Result := fHandle;
end;

procedure TGDICanvas.SetHandle(Value: HDC);
begin
  if fHandle = Value then Exit;
  if fHandle <> 0 then
  begin
    DeselectHandles;
{      if not( assigned(fOwnerControl) and
              (PWndControl(fOwnerControl).fPaintDC = fHandle) ) then
      //////////////////// SLAG
      if   TMethod(fOnGetHandle).Code = @TWndControl.Dc2Canvas then
           ReleaseDC(PControl(fOwnerControl).Handle, fHandle )
      else
           DeleteDC( fHandle );
      ////////////////////
}

    if fSelfDC <> 0 then
    begin
       DeleteDC( fSelfDC );
       fSelfDC:=0;
    end;
    fHandle := 0;
    fState := fState and not HandleValid;
  end;
  if Value <> 0 then
  begin
    fState := fState or HandleValid;
    fHandle := Value;
    SetPenPos( fPenPos );
  end;
end;

procedure TGDICanvas.SetPenPos(const Value: TPoint);
begin
  fPenPos := Value;
  MoveTo( Value.x, Value.y );
end;

procedure TGDICanvas.Changing;
begin
  if Assigned( fOnChange ) then
     fOnChange( @Self );
end;

procedure TGDICanvas.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); stdcall;
begin
  RequiredState( HandleValid or PenValid or ChangingCanvas );
  Windows.Arc(FHandle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

procedure TGDICanvas.Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); stdcall;
begin
  RequiredState( HandleValid or PenValid or BrushValid or ChangingCanvas );
  Windows.Chord(FHandle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

procedure TGDICanvas.CopyRect(const DstRect: TRect; SrcCanvas: PGDICanvas;
  const SrcRect: TRect);
begin
  RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
  SrcCanvas.RequiredState( HandleValid or BrushValid );
  StretchBlt( fHandle, DstRect.Left, DstRect.Top, DstRect.Right - DstRect.Left,
    DstRect.Bottom - DstRect.Top, SrcCanvas.Handle, SrcRect.Left, SrcRect.Top,
    SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top, ModeCopy);
end;

procedure TGDICanvas.DrawFocusRect(const Rect: TRect);
begin
  RequiredState( HandleValid or BrushValid or FontValid or ChangingCanvas );
  Windows.DrawFocusRect(FHandle, Rect);
end;

procedure TGDICanvas.Ellipse(X1, Y1, X2, Y2: Integer);
begin
  RequiredState( HandleValid or PenValid or BrushValid or ChangingCanvas );
  Windows.Ellipse(FHandle, X1, Y1, X2, Y2);
end;

procedure TGDICanvas.FillRect(const Rect: TRect);
var Br: HBrush;
begin
  //Changing;
  RequiredState( HandleValid or BrushValid or ChangingCanvas );
  if assigned( fBrush ) then
  begin
    //DeselectHandles;
    Windows.FillRect(fHandle, Rect, fBrush.FGTResData.Handle);
  end
    else
  if assigned( fOwnerControl ) then
  begin
    Br := CreateSolidBrush( Color2RGB(PWndControl(fOwnerControl).fColor) );
    Windows.FillRect(fHandle, Rect, Br );
    DeleteObject( Br );
  end
  else
    Windows.FillRect(fHandle, Rect, HBrush(COLOR_WINDOW + 1) );
end;

procedure TGDICanvas.FillRgn(const Rgn: HRgn);
var Br : HBrush;
begin
  RequiredState( HandleValid or BrushValid or ChangingCanvas );
  if assigned( fBrush ) then
    Windows.FillRgn(FHandle, Rgn, fBrush.Handle )
    else
  if assigned( fOwnerControl ) then
  begin
    Br := CreateSolidBrush( Color2RGB(PWndControl(fOwnerControl).fColor) );
    Windows.FillRgn( fHandle, Rgn, Br );
    DeleteObject( Br );
  end
     else
  begin
    Br := CreateSolidBrush( DWORD(clWindow) );
    Windows.FillRgn( fHandle, Rgn, Br );
    DeleteObject( Br );
  end;
end;

procedure TGDICanvas.FloodFill(X, Y: Integer; Color: TColor;
  FillStyle: TFillStyle);
const
  FillStyles: array[TFillStyle] of Word =
    (FLOODFILLSURFACE, FLOODFILLBORDER);
begin
  RequiredState( HandleValid or BrushValid or ChangingCanvas );
  Windows.ExtFloodFill(FHandle, X, Y, Color, FillStyles[FillStyle]);
end;

procedure TGDICanvas.FrameRect(const Rect: TRect);
var SolidBr : HBrush;
begin
  RequiredState( HandleValid or ChangingCanvas );
  if assigned( fBrush ) then
    SolidBr := CreateSolidBrush( fBrush.FResData.Brush.LogBrush.lbColor)
  else
  if assigned( fOwnerControl ) then
    SolidBr := CreateSolidBrush( PWndControl(fOwnerControl).fColor )
  else
    SolidBr := CreateSolidBrush( clWhite );
  Windows.FrameRect(FHandle, Rect, SolidBr);
  DeleteObject( SolidBr );
end;

procedure TGDICanvas.LineTo(X, Y: Integer);
begin
  RequiredState( HandleValid or PenValid or BrushValid or ChangingCanvas );
  Windows.LineTo( fHandle, X, Y );
end;

procedure TGDICanvas.MoveTo(X, Y: Integer);
begin
  RequiredState( HandleValid );
  Windows.MoveToEx( fHandle, X, Y, nil );
end;

procedure TGDICanvas.ObjectChanged(Sender: PGDIToolObject);
begin
  DeselectHandles;
  //if Assigned( GlobalCanvas_OnObjectChanged ) then
  //   GlobalCanvas_OnObjectChanged( Sender );
end;

procedure TGDICanvas.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); stdcall;
begin
  RequiredState( HandleValid or PenValid or BrushValid or ChangingCanvas );
  Windows.Pie( fHandle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

procedure TGDICanvas.Polygon(const Points: array of TPoint);
type
  PPoints = ^TPoints;
  TPoints = array[0..0] of TPoint;
begin
  RequiredState( HandleValid or PenValid or BrushValid or ChangingCanvas );
  Windows.Polygon( fHandle, PPoints(@Points)^, High(Points) + 1);
end;

procedure TGDICanvas.Polyline(const Points: array of TPoint);
type
  PPoints = ^TPoints;
  TPoints = array[0..0] of TPoint;
begin
  RequiredState( HandleValid or PenValid or BrushValid or ChangingCanvas );
  Windows.Polyline( fHandle, PPoints(@Points)^, High(Points) + 1);
end;

procedure TGDICanvas.Rectangle(X1, Y1, X2, Y2: Integer);
begin
  RequiredState( HandleValid or BrushValid or PenValid or ChangingCanvas );
  Windows.Rectangle( fHandle, X1, Y1, X2, Y2);
end;

procedure TGDICanvas.RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);
begin
  RequiredState( HandleValid or BrushValid or PenValid or ChangingCanvas );
  Windows.RoundRect( fHandle, X1, Y1, X2, Y2, X3, Y3);
end;

procedure TGDICanvas.TextArea(const Text: String; var Sz: TSize;
  var P0: TPoint);
begin
  Sz := TextExtent( Text );
  P0.x := 0; P0.y := 0;
  if Assigned( GlobalCanvas_OnTextArea ) then
     GlobalCanvas_OnTextArea( @Self, Sz, P0 );
end;

function TGDICanvas.TextExtent(const Text: string): TSize;
var DC : HDC;
    ClearHandle : Boolean;
begin
  //Result.cX := 0;
  //Result.cY := 0;
  ClearHandle := False;
  RequiredState( HandleValid or FontValid );
  DC := fHandle;
  if DC = 0 then
  begin
     DC := CreateCompatibleDC( 0 );
     ClearHandle := True;
     SetHandle( DC );
  end;
  RequiredState( HandleValid or FontValid );
  Windows.GetTextExtentPoint32( fHandle, PChar(Text), Length(Text), Result);
  if ClearHandle then
    SetHandle( 0 );
    { DC must be freed here automatically (never leaks):
      if Canvas created on base of existing DC, no memDC created,
      if Canvas has fHandle:HDC = 0, it is not fIsPaintDC always. }
end;

function TGDICanvas.TextHeight(const Text: string): Integer;
begin
  Result := TextExtent(Text).cY;
end;

procedure TGDICanvas.TextOut(X, Y: Integer; const Text: String); stdcall;
begin
//  try
  RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
  Windows.TextOut(FHandle, X, Y, PChar(Text), Length(Text));
  MoveTo(X + TextWidth(Text), Y);
//  finally
//  end;
end;

procedure TGDICanvas.TextRect(const Rect: TRect; X, Y: Integer; const Text: string);
var
  Options: Integer;
begin
  //Changing;
  RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
  Options := ETO_CLIPPED;
  if assigned( fBrush ) and (fBrush.FResData.Brush.LogBrush.lbStyle <> BS_HOLLOW)
  or not assigned( fBrush ) then Inc(Options, ETO_OPAQUE);
  Windows.ExtTextOut( fHandle, X, Y, Options,
                      @Rect, PChar(Text),
                      Length(Text), nil);
end;

function TGDICanvas.TextWidth(const Text: string): Integer;
begin
  Result := TextExtent(Text).cX;
end;

function TGDICanvas.GetBrush: PGDIToolObject;
begin
  if not assigned( fBrush ) then
  begin
    fBrush := NewGDIBrush;

    if assigned( fOwnerControl ) then
    begin
      fBrush.Color := PWndControl(fOwnerControl).fColor;
//+      if assigned( PWndControl(fOwnerControl).fBrush ) then
//+         fBrush.AssignGT( PWndControl(fOwnerControl).fBrush );
      // both statements above needed
    end;
    AssignChangeEvents;
  end;
  Result := fBrush;
end;

function TGDICanvas.GetFont: PGDIToolObject;
begin
  if not assigned( fFont ) then
  begin
    fFont := NewGDIFont;
    if assigned( fOwnerControl ) then
    begin
      fFont.Color := PWndControl(fOwnerControl).fTextColor;
//      if assigned( PWndControl(fOwnerControl).fFont ) then
//        fFont.AssignGT( PWndControl(fOwnerControl).fFont );
    end;
    AssignChangeEvents;
  end;
  Result := fFont;
end;

function TGDICanvas.GetPen: PGDIToolObject;
begin
  if not assigned( fPen ) then
  begin
    fPen := NewGdiPen;
    AssignChangeEvents;
  end;
  Result := fPen;
end;

function TGDICanvas.GetHandle: HDC;
begin
  if assigned( fOnGetHandle ) then
  begin
    Result := fOnGetHandle( @Self );
    //fHandle := Result;
    SetHandle( Result );
  end
  else
    Result := fHandle;
end;

procedure TGDICanvas.AssignChangeEvents;
begin
  if assigned( fFont ) then
     fFont.fOnChange := ObjectChanged;
  if assigned( fBrush ) then
     fBrush.fOnChange := ObjectChanged;
  if assigned( fPen ) then
     fPen.fOnChange := ObjectChanged;
end;



///////////////////////////////////////////////////////////////////////
//
//
//                             I  C  O  N
//
//
///////////////////////////////////////////////////////////////////////


procedure DeleteIconResourse(GDIRes: PImageResource);
begin
  if GDIRes^.Data.Handle <> 0 then
    DestroyIcon(GDIRes.Data.Handle);
end;

{-- icon --}

function NewGDIIcon: PGDIIcon;
begin
  New( Result, Create );
  with Result^ do
  begin
    FResData:=DefIconData;
    FGDIResData.fResType:=IMAGE_ICON;
    FGDIResData.Handle:=0;
    FGDIResData.DataSize:=SizeOf(TResoursceIconData);
    FGDIResData.DeleteResProc:=DeleteIconResourse;
    FImageResource := ResourceManager.AllocImageResource(FGDIResData);

  end;

end;

{ TGDIIcon }

{$IFDEF ASM_VERSION}
procedure asmIconEmpty( Icon: PIcon );
asm
        CMP      [EAX].TGDIIcon.fHandle, 0
end;
{$ENDIF}

procedure TGDIIcon.Clear;
begin
  FGDIResData.Handle:=0;
  FResData:=DefIconData;
  SetData(FGDIResData);
end;

function TGDIIcon.Convert2Bitmap(TranColor: TColor): HBitmap;
var DC0, DC2: HDC;
    Save: THandle;
    Br: HBrush;
begin
  Result := 0;
  if Empty then Exit;
  DC0 := GetDC( 0 );
  DC2 := CreateCompatibleDC( DC0 );
  Result := CreateCompatibleBitmap( DC0, fResData.fSize, fResData.fSize );
  Save := SelectObject( DC2, Result );
  Br := CreateSolidBrush( Color2RGB( TranColor ) );
  Windows.FillRect( DC2, MakeRect( 0, 0, fResData.fSize, fResData.fSize ), Br );
  DeleteObject( Br );
  Draw( DC2, 0, 0 );
  SelectObject( DC2, Save );
  DeleteDC( DC2 );
  ReleaseDC( 0, DC0 );
end;

procedure TGDIIcon.SetData(const Data);
begin
    ResourceManager.ChangeImageResource(@Self, Data);
end;

destructor TGDIIcon.Destroy;
begin
  ResourceManager.FreeImageResource(FImageResource);
  inherited;
end;

procedure TGDIIcon.Draw(DC: HDC; X, Y: Integer);
begin
  if Empty then Exit;
  DrawIconEx( DC, X, Y, fResData.fHandle, fResData.fSize, fResData.fSize, 0, 0, DI_NORMAL );
end;

procedure TGDIIcon.StretchDraw(DC: HDC; Dest: TRect);
begin
  if Empty then Exit;
  DrawIconEx( DC, Dest.Left, Dest.Top, fResData.FHandle, Dest.Right - Dest.Left,
              Dest.Bottom - Dest.Top, 0, 0, DI_NORMAL );
end;

function TGDIIcon.GetEmpty: Boolean;
begin
  Result := fResData.fHandle = 0;
end;

//*
function TGDIIcon.GetHotSpot: TPoint;
var II : TIconInfo;
begin
  Result := MakePoint( 0, 0 );
  if fResData.FHandle = 0 then Exit;
  GetIconInfo( fResData.FHandle, II );
  Result.x := II.xHotspot;
  Result.y := II.yHotspot;
  if II.hbmMask <> 0 then
    DeleteObject( II.hbmMask );
  if II.hbmColor <> 0 then
    DeleteObject( II.hbmColor );
end;

//*
procedure TGDIIcon.LoadFromFile(const FileName: String);
var Strm : PStream;
begin
  Strm := NewReadFileStream( Filename );
  LoadFromStream( Strm );
  Strm.Free;
end;

type
  TIconHeader = packed record
    idReserved: Word; (* Always set to 0 *)
    idType: Word;     (* Always set to 1 *)
    idCount: Word;    (* Number of icon images *)
    (* immediately followed by idCount TIconDirEntries *)
  end;

  TIconDirEntry = packed record
    bWidth: Byte;          (* Width *)
    bHeight: Byte;         (* Height *)
    bColorCount: Byte;     (* Nr. of colors used, see below *)
    bReserved: Byte;       (* not used, 0 *)
    wPlanes: Word;         (* not used, 0 *)
    wBitCount: Word;       (* not used, 0 *)
    dwBytesInRes: Longint; (* total number of bytes in images *)
    dwImageOffset: Longint;(* location of image from the beginning of file *)
  end;

//*
procedure TGDIIcon.LoadFromStream(Strm: PStream);
var DesiredSize : Integer;
    Pos : DWord;
    Mem : PStream;
    ImgBmp, MskBmp : PGDIBitmap;
  function ReadIcon : Boolean;
  var IH : TIconHeader;
      IDI, FoundIDI : TIconDirEntry;
      I, SumSz, FoundSz, D : Integer;
      II : TIconInfo;
      BIH : TBitmapInfoheader;
  begin
     Result := False;
     if Strm.Read( IH, Sizeof( IH ) ) <> Sizeof( IH ) then Exit;
     if (IH.idReserved <> 0) or (IH.idType <> 1) or (IH.idCount < 1) then Exit;
     SumSz := Sizeof( IH );
     FoundSz := 1000;
     for I := 1 to IH.idCount do
     begin
        if Strm.Read( IDI, Sizeof( IDI ) ) <> Sizeof( IDI ) then Exit;
        if (IDI.bWidth <> IDI.bHeight) or (IDI.bWidth = 0) {or
           (IDI.bReserved <> 0) or (IDI.wPlanes <> 0) or (IDI.wBitCount <> 0)} then
           Exit;
        Inc( SumSz, IDI.dwBytesInRes + Sizeof( IDI ) );
        D := IDI.bWidth - DesiredSize;
        if D < 0 then D := -D;
        if D < FoundSz then
        begin
           FoundSz := D;
           FoundIDI := IDI;
        end;
     end;
     if FoundSz = 1000 then Exit;
     Strm.Seek( Integer( Pos ) + FoundIDI.dwImageOffset, spBegin );
     fResData.fSize := FoundIDI.bWidth;

     if Strm.Read( BIH, Sizeof( BIH ) ) <> Sizeof( BIH ) then Exit;
     if (BIH.biWidth <> fResData.fSize) or
        (BIH.biHeight <> fResData.fSize * 2) and
        (BIH.biHeight <> fResData.fSize) then Exit;
     BIH.biHeight := fResData.fSize;

     Mem := NewMemoryStream;
     Mem.Write( BIH, Sizeof( BIH ) );
     if (FoundIDI.bColorCount >= 2) or (FoundIDI.bReserved = 1) then
     begin
       I := 0;
       if BIH.biBitCount <= 8 then
          I := (1 shl BIH.biBitCount) * Sizeof( TRGBQuad );
       if I > 0 then
          if Stream2Stream( Mem, Strm, I ) <> DWORD(I) then Exit;
       I := ((BIH.biBitCount * fResData.fSize + 31) div 32) * 4 * fResData.fSize;
       if Stream2Stream( Mem, Strm, I ) <> DWORD(I) then Exit;
       ImgBmp := NewGDIBitmap( fResData.fSize, fResData.fSize );
       Mem.Seek( 0, spBegin );
       ImgBmp.LoadFromStream( Mem );
       if ImgBmp.Empty then Exit;
     end;

     BIH.biBitCount := 1;
     Mem.Seek( 0, spBegin );
     Mem.Write( BIH, Sizeof( BIH ) );
     I := 0;
     Mem.Write( I, Sizeof( I ) );
     I := $FFFFFF;
     Mem.Write( I, Sizeof( I ) );
     I := ((fResData.fSize + 31) div 32) * 4 * fResData.fSize;
     if Stream2Stream( Mem, Strm, I ) <> DWORD(I) then Exit;

     MskBmp := NewGDIBitmap( fResData.fSize, fResData.fSize );
     Mem.Seek( 0, spBegin );
     MskBmp.LoadFromStream( Mem );
     if MskBmp.Empty then Exit;

     II.fIcon := True;
     II.xHotspot := 0;
     II.yHotspot := 0;
     II.hbmMask := MskBmp.Handle;
     II.hbmColor := 0;
     if ImgBmp <> nil then
        II.hbmColor := ImgBmp.Handle;
     fResData.fHandle := CreateIconIndirect( II );
     //fShareIcon := False;
     Strm.Seek( Integer( Pos ) + SumSz, spBegin );
     Result := fResData.fHandle <> 0;
  end;
begin
  DesiredSize := fResData.fSize;
  if DesiredSize = 0 then
     DesiredSize := GetSystemMetrics( SM_CXICON );
  Clear;
  Pos := Strm.Position;

  Mem := nil;
  ImgBmp := nil;
  MskBmp := nil;

  if not ReadIcon then
  begin
     Clear;
     Strm.Seek( Pos, spBegin );
  end;

  Mem.Free;
  ImgBmp.Free;
  MskBmp.Free;
end;

{$IFDEF ASM_VERSION}
procedure TGDIIcon.SaveToFile(const FileName: String);
asm     //cmd    //opd
        PUSH     EAX
        MOV      EAX, ESP
        MOV      ECX, EDX
        XOR      EDX, EDX
        CALL     SaveIcons2File
        POP      EAX
end;
{$ELSE} //Pascal
procedure TGDIIcon.SaveToFile(const FileName: String);
begin
  SaveIcons2File( [ @Self ], FileName );
end;
{$ENDIF}

{$IFDEF ASM_VERSION}
procedure TGDIIcon.SaveToStream(Strm: PStream);
asm     //cmd    //opd
        PUSH     EAX
        MOV      EAX, ESP
        MOV      ECX, EDX
        XOR      EDX, EDX
        CALL     SaveIcons2Stream
        POP      EAX
end;
{$ELSE} //Pascal
procedure TGDIIcon.SaveToStream(Strm: PStream);
begin
  SaveIcons2Stream( [ @Self ], Strm );
end;
{$ENDIF}

procedure TGDIIcon.SetHandle(const Value: HIcon);
var II : TIconInfo;
    BIH : TBitmapInfoHeader;
begin
  fResData.FHandle:=Value;
  SetData(FGDIResData);
  FImageResource^.Data.Handle :=Value;
end;

//*
procedure TGDIIcon.SetSize(const Value: Integer);
begin
  if fResData.FSize = Value then Exit;
  fResData.FSize := Value;
  SetData(FGDIResData);
end;

const PossibleColorBits : array[1..7] of Byte = ( 1, 4, 8, 16, 24, 32, 0 );
{$IFDEF ASM_VERSION}
function ColorBits( ColorsCount : Integer ) : Integer;
asm     //cmd    //opd
        PUSH     EBX
        MOV      EDX, offset[PossibleColorBits]
@@loop: MOVZX    ECX, byte ptr [EDX]
        JECXZ    @@e_loop
        INC      EDX
        XOR      EBX, EBX
        INC      EBX
        SHL      EBX, CL
        CMP      EBX, EAX
        JL       @@loop
@@e_loop:
        XCHG     EAX, ECX
        POP      EBX 
end;
{$ELSE} //Pascal
function ColorBits( ColorsCount : Integer ) : Integer;
var I : Integer;
begin
   for I := 1 to 6 do
   begin
      Result := PossibleColorBits[ I ];
      if (1 shl Result) >= ColorsCount then break;
   end;
end;
{$ENDIF}



procedure TGDIIcon.LoadFromResourceID(Inst, ResID, DesiredSize: Integer);
begin
  LoadFromResourceName( Inst, MAKEINTRESOURCE( ResID ), DesiredSize );
end;

procedure TGDIIcon.LoadFromResourceName(Inst: Integer; ResName: PChar; DesiredSize: Integer);
begin
  Handle := LoadImage( Inst, ResName, IMAGE_ICON, DesiredSize, DesiredSize,
                       LR_SHARED);
end;




////////////////////////////////////////////////////////////////////////
//
//
//                         t  B  I  T  M  A  P
//
//
///////////////////////////////////////////////////////////////////////


procedure DoDetachBitmapFromCanvas(GDIRes: PImageResource);
begin
  if GDIRes.Data.fCanvasAttached = 0 then Exit;
  SelectObject( GDIRes.Bitmap.fCanvas.fHandle, GDIRes.Data.fCanvasAttached );
  GDIRes.Data.fCanvasAttached := 0;
end;

procedure DeleteBitmapObject(GDIRes: PImageResource);
begin
  if GDIRes.Bitmap.fCanvas <> nil then
  begin
    DoDetachBitmapFromCanvas(GDIRes);
    GDIRes.Bitmap.fCanvas.Free;
  end;

  if GDIRes^.Data.Handle <> 0 then
    DeleteObject(GDIRes.Data.Handle);

  if not GDIRes.Bitmap.fDIBAutoFree then
  begin
    if GDIRes.Bitmap.fBmp.bmBits <> nil then
      begin
        FreeMem( GDIRes.Bitmap.fBmp.bmBits );
      end;
  end;
  if GDIRes.Bitmap.fDIBHeader <> nil then
  begin
    FreeMem( GDIRes.Bitmap.fDIBHeader );
  end;
end;

{-- bitmap --}

{$IFDEF ASM_VERSION}
function PrepareBitmapHeader( W, H, BitsPerPixel: Integer ): PBitmapInfo;
const szIH = sizeof(TBitmapInfoHeader);
      szHd = szIH + 256 * Sizeof(TRGBQuad);
asm
        PUSH     EDI

          PUSH     ECX  // BitsPerPixel
        PUSH     EDX    // H
        PUSH     EAX    // W

        MOV      EAX, szHd
        CALL     AllocMem

        MOV      EDI, EAX
        XCHG     ECX, EAX

        XOR      EAX, EAX
        MOV      AL, szIH
        STOSD           // biSize = Sizeof( TBitmapInfoHeader )
        POP      EAX    // ^ W
        STOSD           // -> biWidth
        POP      EAX    // ^ H
        STOSD           // -> biHeight
        XOR      EAX, EAX
        INC      EAX
        STOSW           // 1 -> biPlanes
          POP      EAX  // ^ BitsPerPixel
        STOSW           // -> biBitCount

        XCHG     EAX, ECX // EAX = Result
        POP      EDI
end;
{$ELSE} //Pascal
function PrepareBitmapHeader( W, H, BitsPerPixel: Integer ): PBitmapInfo;
begin
  Assert( W > 0, 'Width must be >0' );
  Assert( H > 0, 'Height must be >0' );

  Result := AllocMem( 256*Sizeof(TRGBQuad)+Sizeof(TBitmapInfoHeader) );
  Assert( Result <> nil, 'No memory' );

  Result.bmiHeader.biSize := Sizeof( TBitmapInfoHeader );
  Result.bmiHeader.biWidth := W;
  Result.bmiHeader.biHeight := H; // may be, -H ?
  Result.bmiHeader.biPlanes := 1;
  Result.bmiHeader.biBitCount := BitsPerPixel;
  //Result.bmiHeader.biCompression := BI_RGB; // BI_RGB = 0
end;
{$ENDIF}

const
  BitsPerPixel_By_PixelFormat: array[ TPixelFormat ] of Byte =
                               ( 0, 1, 4, 8, 16, 16, 24, 32, 0 );

{$IFDEF ASM_VERSION}
function Bits2PixelFormat( BitsPerPixel: Integer ): TPixelFormat;
asm
        PUSH     ESI
        MOV      ESI, offset[ BitsPerPixel_By_PixelFormat + 1 ]
        XOR      ECX, ECX
        XCHG     EDX, EAX
@@loo:  INC      ECX
        LODSB
        CMP      AL, DL
        JZ       @@exit
        TEST     AL, AL
        JNZ      @@loo
@@exit: XCHG     EAX, ECX
        POP      ESI
end;
{$ELSE} //Pascal
function Bits2PixelFormat( BitsPerPixel: Integer ): TPixelFormat;
var I: TPixelFormat;
begin
  for I := Low(I) to High(I) do
    if BitsPerPixel = BitsPerPixel_By_PixelFormat[ I ] then
    begin
      Result := I;
      Exit;
    end;
  Result := pfDevice;
end;
{$ENDIF}

{procedure DummyDetachCanvas( Sender: PGDIBitmap );
begin
end;

procedure DetachBitmapFromCanvas( Sender: PGDIBitmap );
begin
  if Sender.FResource.Data.fCanvasAttached = 0 then Exit;
  SelectObject( Sender.FResData.fCanvas.fHandle, Sender.FResource.Data.fCanvasAttached );
  Sender.FResource.Data.fCanvasAttached := 0;
end;
...REMOVE IT
}


function MakeGDIBitmapHandle( Self_: PGDIObject ): Integer;
var
  DC:HDC;
begin
  if Self_^.FImageResource^.Data.Handle = 0 then
  begin
    if (Self_^.FImageResource^.Bitmap.fBmp.bmWidth <> 0) and (Self_^.FImageResource^.Bitmap.fBmp.bmHeight <> 0) then
      begin
        DC := GetDC( 0 );
        Self_^.FImageResource^.Data.Handle := CreateCompatibleBitmap( DC, Self_^.FImageResource^.Bitmap.fBmp.bmWidth, Self_^.FImageResource^.Bitmap.fBmp.bmHeight );
        Assert( Self_^.FImageResource^.Data.Handle <> 0, 'Can not create bitmap handle' );
        ReleaseDC(0, DC );
      end;
    Result := Self_^.FImageResource^.Data.Handle;
  end;
end;

//+
function MakeGDIDIBBitmapHandle( Self_: PGDIObject ): Integer;
var OldBits: Pointer;
    DC0: HDC;
begin
  if Self_^.FImageResource^.Data.Handle = 0 then
  begin
    if (PGdiBitmap(Self_)^.FResData.fBmp.bmWidth <> 0) and (PGdiBitmap(Self_)^.FResData.fBmp.bmHeight <> 0) then
      begin
        if PGdiBitmap(Self_)^.FResData.fBmp.bmBits <> nil then
        begin
          OldBits := Self_^.FImageResource^.Bitmap.fBmp.bmBits;
          DC0 := GetDC( 0 );

          PGdiBitmap(Self_)^.FResData.fBmp.bmBits := nil;
          Self_^.FGDIResData.Handle := CreateDIBSection( DC0, PGdiBitmap(Self_)^.FResData.fDIBHeader^, DIB_RGB_COLORS,
                    PGdiBitmap(Self_)^.FResData.fBmp.bmBits, 0, 0 );
          ASSERT( Self_^.FGDIResData.Handle <> 0, 'Can not create DIB section' );
          ReleaseDC( 0, DC0 );
          Move( OldBits^, PGdiBitmap(Self_)^.FResData.fBmp.bmBits^, PGdiBitmap(Self_)^.FResData.fDIBSize );

          OldBits := Self_^.FImageResource^.Bitmap.fDIBHeader;
          GetMem( PGdiBitmap(Self_)^.FResData.fDIBHeader, 256*sizeof(TRGBQuad) + sizeof(TBitmapInfoHeader) );
          Move( OldBits^, PGdiBitmap(Self_)^.FResData.fDIBHeader^, 256*sizeof(TRGBQuad) + sizeof(TBitmapInfoHeader));

          PGDIBitmap(Self_).FResData.fDIBAutoFree := TRUE;
          PGdiBitmap(Self_)^.SetData(Self_^.FGDIResData);

        end;
      end;
  end;
end;

//+
function NewGDIBitmap( W, H: Integer ): PGDIBitmap;
var DC: HDC;
begin
  New( Result, Create );

  with Result^ do
  begin
    fMakeHandleProc := MakeGDIBitmapHandle;

    Result^.FResData:=DefBitmapData;
//    Result^.fDetachCanvas := DetachBitmapFromCanvas{DummyDetachCanvas};
    Result^.FResData.fBmp.bmWidth := W;
    Result^.FResData.fBmp.bmHeight := H;

//    FGDIResData.Handle:=0; already
    FGDIResData.fResType:=IMAGE_BITMAP;
    FGDIResData.DataSize:=SizeOf(TGDIBitmapData);
    FGDIResData.DeleteResProc:=DeleteBitmapObject;
    FImageResource := ResourceManager.AllocImageResource(FGDIResData);
//    if FResource.Data.Handle = 0 then
//      MakeGDIBitmapHandle(Result);
  end;
end;

const InitColors: array[ 0..17 ] of DWORD = ( $F800, $7E0, $1F, 0, $800000, $8000,
      $808000, $80, $800080, $8080, $808080, $C0C0C0, $FF0000, $FF00, $FFFF00, $FF,
      $FF00FF, $FFFF );
{$IFDEF ASM_VERSION}
procedure PreparePF16bit( DIBHeader: PBitmapInfo );
const szBIH = sizeof(TBitmapInfoHeader);
asm
        MOV      byte ptr [EAX].TBitmapInfoHeader.biCompression, BI_BITFIELDS
        ADD      EAX, szBIH
        XCHG     EDX, EAX
        MOV      EAX, offset[InitColors]
        XOR      ECX, ECX
        MOV      CL, 19*4
        CALL     System.Move
end;
{$ELSE} //Pascal
procedure PreparePF16bit( DIBHeader: PBitmapInfo );
begin
        DIBHeader.bmiHeader.biCompression := BI_BITFIELDS;
        Move( InitColors[ 0 ], DIBHeader.bmiColors[ 0 ], 19*Sizeof(TRGBQUAD) );
end;
{$ENDIF}

//+
function NewGDIDIBBitmap( W, H: Integer; PixelFormat: TPixelFormat ): PGDIBitmap;
const BitsPerPixel: array[ TPixelFormat ] of Byte = ( 0, 1, 4, 8, 16, 16, 24, 32, 0 );
var
  BitsPixel: Integer;
begin
  New( Result, Create );
  with Result^ do
  begin
    Result^.fMakeHandleProc := MakeGDIDIBBitmapHandle;

    Result^.FResData:=DefBitmapData;
    Result^.FResData.fBmp.bmWidth := W;
    Result^.FResData.fBmp.bmHeight := H;

    Result^.FGDIResData.fResType:=IMAGE_BITMAP;
    Result^.FGDIResData.DataSize:=SizeOf(TGDIBitmapData);
    Result^.FGDIResData.DeleteResProc:=DeleteBitmapObject;

    if (W <> 0) and (H <> 0) then
      begin
        BitsPixel := BitsPerPixel[ PixelFormat ];
        if BitsPixel = 0 then
          begin
            Result.FResData.fNewPixelFormat := DefaultPixelFormat;
            BitsPixel := BitsPerPixel[DefaultPixelFormat];
          end
        else
          Result.FResData.fNewPixelFormat := PixelFormat;
        ASSERT( Result.FResData.fNewPixelFormat in [ pf1bit..pf32bit ], 'Strange pixel format' );
        Result.FResData.fDIBHeader := PrepareBitmapHeader( W, H, BitsPixel );
        if PixelFormat = pf16bit then
          begin
            PreparePF16bit( Result.FResData.fDIBHeader );
          end;

        Result.FResData.fDIBSize := Result.ScanLineSize * H;
        Result.FResData.fBmp.bmBits := AllocMem( Result.FResData.fDIBSize );
        ASSERT( Result.FResData.fBmp.bmBits <> nil, 'No memory' );
      end;

    Result^.FImageResource := ResourceManager.AllocImageResource(FGDIResData);
  end;

end;

{ TBitmap }

//+
procedure TGDIBitmap.ClearData;
var
  W, H: Integer;
begin
  FGDIResData.Handle:=0;
  FGDIResData.fCanvasAttached:=0;
  W := FResData.fBmp.bmWidth;
  H := FResData.fBmp.bmHeight;
  FResData := DefBitmapData;
  FResData.fBmp.bmWidth := W;
  FResData.fBmp.bmHeight := H;
end;

//+
procedure TGDIBitmap.Clear;
begin
  ClearData;
  FResData.fBmp.bmWidth := 0;
  FResData.fBmp.bmHeight := 0;
  FResData.fDIBAutoFree := FALSE;
  SetData(FGDIResData);
end;

procedure TGDIBitmap.SetData(const Data);
begin
    ResourceManager.ChangeImageResource(@Self, Data);
end;

destructor TGDIBitmap.Destroy;
begin
  ResourceManager.FreeImageResource(FImageResource);
  inherited;
end;

procedure TGDIBitmap.Check;
var
    B: TDIBSection;
begin
    FillChar(B, sizeof( B ),#0);
    if GetObject( GetHandle, sizeof( B ), @B ) <> 0 then
    Self.FResData.fBmp.bmBits:=FResData.fBmp.bmBits;

end;


//+
procedure TGDIBitmap.Draw(DC: HDC; X, Y: Integer);
var
    DCfrom, DC0: HDC;
    oldBmp: HBitmap;
    oldHeight: Integer;
    B: tagBitmap;
label
    TRYAgain;
begin
TRYAgain:
  if Empty then Exit;
  if {FGDIResData.}GetHandle <> 0 then
  begin
    DoDetachBitmapFromCanvas(FImageResource);
//    fDetachCanvas( @Self );
    oldHeight := FResData.fBmp.bmHeight;
    if GetObject( FGDIResData.Handle, sizeof( B ), @B ) <> 0 then
       oldHeight := B.bmHeight;
    ASSERT( oldHeight > 0, 'oldHeight must be > 0' );

    DC0 := GetDC( 0 );
    DCfrom := CreateCompatibleDC( DC0 );
    ReleaseDC( 0, DC0 );

    oldBmp := SelectObject( DCfrom, FGDIResData.Handle );
    ASSERT( oldBmp <> 0, 'Can not select bitmap to DC' );

    BitBlt( DC, X, Y, FResData.fBmp.bmWidth, oldHeight, DCfrom, 0, 0, SRCCOPY );
    {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}

    SelectObject( DCfrom, oldBmp );
    DeleteDC( DCfrom );
  end
  else
  if FResData.fBmp.bmBits <> nil then
  begin
    oldHeight := Abs(FResData.fDIBHeader.bmiHeader.biHeight);
    ASSERT( oldHeight > 0, 'oldHeight must be > 0' );
    ASSERT( FResData.fbmp.bmWidth > 0, 'Width must be > 0' );
    if StretchDIBits( DC, X, Y, FResData.fBmp.bmWidth, oldHeight, 0, 0, FResData.fbmp.bmHeight, oldHeight,
                   FResData.fBmp.bmBits, FResData.fDIBHeader^, DIB_RGB_COLORS, SRCCOPY ) = 0 then
    begin
      if GetHandle <> 0 then
        goto TRYAgain;
    end;
  end;
end;

//+
procedure TGDIBitmap.StretchDraw(DC: HDC; const Rect: TRect);
var DCfrom: HDC;
    oldBmp: HBitmap;
begin
  if Empty then Exit;
  if FGDIResData.Handle <> 0 then
  begin
    DoDetachBitmapFromCanvas(FImageResource);
//    fDetachCanvas( @Self );
    DCfrom := CreateCompatibleDC( 0 );
    oldBmp := SelectObject( DCfrom, FGDIResData.Handle );
    ASSERT( oldBmp <> 0, 'Can not select bitmap to DC' );
    StretchBlt( DC, Rect.Left, Rect.Top, Rect.Right - Rect.Left,
                Rect.Bottom - Rect.Top, DCfrom, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight,
                SRCCOPY );
    SelectObject( DCfrom, oldBmp );
    DeleteDC( DCfrom );
  end
     else
  if FResData.fBmp.bmBits <> nil then
  begin
    StretchDIBits( DC, Rect.Left, Rect.Top, Rect.Right - Rect.Left,
                Rect.Bottom - Rect.Top, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight,
                FResData.fBmp.bmBits, FResData.fDIBHeader^, DIB_RGB_COLORS, SRCCOPY );
  end;
end;

procedure TGDIBitmap.DrawMasked(DC: HDC; X, Y: Integer; Mask: HBitmap);
begin
  StretchDrawMasked( DC, MakeRect( X, Y, X + FResData.fBmp.bmWidth, Y + FResData.fBmp.bmHeight ), Mask );
end;

procedure TGDIBitmap.DrawTransparent(DC: HDC; X, Y: Integer; TranspColor: TColor);
begin
  if TranspColor = clNone then
    Draw( DC, X, Y )
  else
    StretchDrawTransparent( DC, MakeRect( X, Y, X + FResData.fBmp.bmWidth, Y + FResData.fBmp.bmHeight ),
                            TranspColor );
end;


procedure TGDIBitmap.StretchDrawTransparent(DC: HDC; const Rect: TRect; TranspColor: TColor);
begin
  if TranspColor = clNone then
     StretchDraw( DC, Rect )
  else
  begin
    if GetHandle = 0 then Exit;
    TranspColor := Color2RGB( TranspColor );
    if (fTransMaskBmp = nil) or (fTransColor <> TranspColor) then
    begin
      if fTransMaskBmp = nil then
        fTransMaskBmp := NewGDIBitmap( 0, 0 {fWidth, fHeight} );
      fTransColor := TranspColor;
      // Create here mask bitmap:
      fTransMaskBmp.Assign( @Self );
      fTransMaskBmp.Convert2Mask( TranspColor );
    end;
    StretchDrawMasked( DC, Rect, fTransMaskBmp.Handle );
  end;
end;

const
  ROP_DstCopy = $00AA0029;

procedure TGDIBitmap.StretchDrawMasked(DC: HDC; const Rect: TRect; Mask: HBitmap);
var
  DCfrom, MemDC, MaskDC: HDC;
  MemBmp: HBITMAP;
  Save4From, Save4Mem, Save4Mask: THandle;
  crText, crBack: TColorRef;
begin
  if GetHandle = 0 then Exit;
  DoDetachBitmapFromCanvas(FImageResource);
//  fDetachCanvas( @Self );

  DCfrom := CreateCompatibleDC( 0 );
  Save4From := SelectObject( DCfrom, FGDIResData.Handle );
  ASSERT( Save4From <> 0, 'Can not select source bitmap to DC' );
  MaskDC := CreateCompatibleDC( 0 );
  Save4Mask := SelectObject( MaskDC, Mask );
  ASSERT( Save4Mask <> 0, 'Can not select mask bitmap to DC' );
  MemDC := CreateCompatibleDC( 0 );
    //try
      MemBmp := CreateCompatibleBitmap( DCfrom, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight );
      Save4Mem := SelectObject( MemDC, MemBmp );
      ASSERT( Save4Mem <> 0, 'Can not select memory bitmap to DC' );
      //SavePal := SelectPalette(DCfrom, SystemPalette16, False);
      //SelectPalette(DCfrom, SavePal, False);
      //if SavePal <> 0 then
      //  SavePal := SelectPalette(MemDC, SavePal, True)
      //else
      //  SavePal := SelectPalette(MemDC, SystemPalette16, True);
      //RealizePalette(MemDC);

      StretchBlt( MemDC, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, MaskDC, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, SrcCopy);
      StretchBlt( MemDC, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, DCfrom, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, SrcErase);
      crText := SetTextColor(DC, $0);
      crBack := Windows.SetBkColor(DC, $FFFFFF);
      StretchBlt( DC, Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
                  MaskDC, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, SrcAnd);
      StretchBlt( DC, Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
                  MemDC, 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, SrcInvert);
      Windows.SetBkColor( DC, crBack);
      SetTextColor( DC, crText);

      if Save4Mem <> 0 then
         SelectObject( MemDC, Save4Mem );
      DeleteObject(MemBmp);
    //finally
      //if SavePal <> 0 then SelectPalette(MemDC, SavePal, False);
      DeleteDC(MemDC);
      SelectObject( DCfrom, Save4From );
      DeleteDC( DCfrom );
      SelectObject( MaskDC, Save4Mask );
      DeleteDC( MaskDC );
    //end;
end;

procedure ApplyBitmapBkColor2Canvas( Sender: PGDIBitmap );
begin
  if Sender.FResData.fCanvas = nil then Exit;
  Sender.FResData.fCanvas.Brush.Color := Sender.BkColor;
end;

//+
function TGDIBitmap.GetCanvas: PGDICanvas;
var DC: HDC;
  OldObject: THandle;
  OldObject2: THandle;
  DC0:THandle;
  NewCanvas:PGDICanvas;
begin
  Result := nil;
  if Empty then Exit;
  if GetHandle = 0 then exit;
  if FResData.fCanvas = nil then
  begin
    DC0 := GetDC(0);

    DC := CreateCompatibleDC( DC0 );

    if FGDIResData.Handle <> 0 then
    begin
      OldObject:=CreateCompatibleBitmap( DC0, FImageResource^.Bitmap.fBmp.bmWidth, FImageResource^.Bitmap.fBmp.bmHeight);
      OldObject2:=SelectObject( DC, OldObject );
      Draw(DC,0,0);
      OldObject:=SelectObject( DC, OldObject2 );
    end;

    ReleaseDC(0,DC0);

    FResData.fCanvas := NewGDICanvas( DC );
    FResData.fCanvas.fSelfDC := DC;
    FResData.fCanvas.Brush.Color := fBkColor;
    FResData.fCanvas.OnChange := CanvasChanged;

    FGDIResData.Handle:=OldObject;
    FResData.BmpHandle:=FGDIResData.Handle;
    FResData.fApplyBkColor2Canvas := ApplyBitmapBkColor2Canvas;

    SetData(FGDIResData);
  end;
  if FImageResource^.Data.fCanvasAttached = 0 then
  begin
    FImageResource^.Data.fCanvasAttached := SelectObject( FResData.fCanvas.Handle, GetHandle );
    ASSERT( FImageResource^.Data.fCanvasAttached <> 0, 'Can not select bitmap to DC of Canvas' );
  end;
  Result := FResData.fCanvas;
end;

//+
function TGDIBitmap.GetEmpty: Boolean;
begin
  Result := (FResData.fBmp.bmWidth = 0) or (FResData.fBmp.bmHeight = 0);
  ASSERT( (FResData.fBmp.bmWidth >= 0) and (FResData.fBmp.bmHeight >= 0), 'Bitmap dimensions can be negative' );
end;

//+
function TGDIBitmap.GetHandle: HBitmap;
var OldBits: Pointer;
    DC0: HDC;
    OldBMP:THandle;
begin
///////////////////////////
  Result := 0;           //
  if Empty then Exit;    //
///////////////////////////
  Result := FGDIResData.Handle;
  if (FGDIResData.Handle = 0) or (FGDIResData.Handle <> FImageResource^.Data.Handle) then
  begin
    SetData(FGDIResData);
  end;
  if Result = 0 then
  begin
     fMakeHandleProc( @Self );
     FGDIResData.Handle:=FImageResource^.Data.Handle;
     Result := FImageResource^.Data.Handle;
  end;
end;

//+
procedure TGDIBitmap.LoadFromFile(const Filename: String);
var Strm: PStream;
begin
  Strm := NewReadFileStream( Filename );
  LoadFromStream( Strm );
  Strm.Free;
end;

//+
procedure TGDIBitmap.LoadFromResourceID(Inst: DWORD; ResID: Integer);
begin
  LoadFromResourceName( Inst, MAKEINTRESOURCE( ResID ) );
end;


procedure TGDIBitmap.LoadFromResourceName(Inst: DWORD; ResName: PChar);
type
  _PBMPGDIResData = ^_TBMPGDIResData;
  _TBMPGDIResData = record
    FGDIResData: TGDIResData;
    FResData: TGDIBitmapData;
  end;

var ResHandle: HBitmap;
    Flg: DWORD;
    DibSection:TDibSection;
    RD:_PBMPGDIResData;
begin
    Flg := 0;
    if FResData.fHandleType = bmDIB then
      Flg := LR_CREATEDIBSECTION;
    ResHandle := LoadImage( Inst, ResName, IMAGE_BITMAP, 0, 0,
             LR_DEFAULTSIZE or Flg );
    if ResHandle = 0 then
    begin
      Clear;
      Exit;
    end;
  Handle := ResHandle;
end;

//+
procedure TGDIBitmap.LoadFromStream(Strm: PStream);
var Pos : Integer;
    BFH : TBitmapFileHeader;

    function ReadBitmap : Boolean;
    var Off, Size, Size1, ColorCount: Integer;
    begin
      FResData.fHandleType := bmDIB;
      fMakeHandleProc := MakeGDIDIBBitmapHandle;

      Result := False;
      if Strm.Read( BFH, Sizeof( BFH ) ) <> Sizeof( BFH ) then Exit;
      Off := 0; Size := 0;
      if BFH.bfType <> $4D42 then
         Strm.Seek( Pos, spBegin )
      else
      begin
         Off := BFH.bfOffBits;
         Size := BFH.bfSize; // don't matter, just <> 0 is good
         //Size := Min( BFH.bfSize, Strm.Size - Strm.Position );
      end;
      GetMem( FResData.fDIBHeader, 256*sizeof(TRGBQuad) + sizeof(TBitmapInfoHeader) );
      if Strm.Read( FResData.fDIBHeader^, Sizeof(TBitmapInfoHeader) ) <> Sizeof(TBitmapInfoHeader) then
         Exit;

      FResData.fNewPixelFormat := Bits2PixelFormat( FResData.fDIBHeader.bmiHeader.biBitCount
                         * FResData.fDIBHeader.bmiHeader.biPlanes );
      if (FResData.fNewPixelFormat = pf15bit) and (FResData.fDIBHeader.bmiHeader.biCompression <> BI_RGB) then
      begin
        ASSERT( FResData.fDIBHeader.bmiHeader.biCompression = BI_BITFIELDS, 'Unsupported bitmap format' );
        FResData.fNewPixelFormat := pf16bit;
      end;
      FResData.fBmp.bmWidth := FResData.fDIBHeader.bmiHeader.biWidth;
      ASSERT( FResData.fBmp.bmWidth > 0, 'Bitmap width must be > 0' );
      FResData.fBmp.bmHeight := Abs(FResData.fDIBHeader.bmiHeader.biHeight);
      ASSERT( FResData.fBmp.bmHeight > 0, 'Bitmap height must be > 0' );

      FResData.fDIBSize := ScanLineSize * FResData.fBmp.bmHeight;
      FResData.fBmp.bmBits := AllocMem( FResData.fDIBSize );
      ASSERT( FResData.fBmp.bmBits <> nil, 'No memory' );

      ColorCount := 0;
      if FResData.fDIBHeader.bmiHeader.biBitCount <= 8 then
        ColorCount := (1 shl FResData.fDIBHeader.bmiHeader.biBitCount) * Sizeof( TRGBQuad )
      else if FResData.fNewPixelFormat = pf16bit then
        ColorCount := 12;

      if Off > 0 then
      begin
         Off := Off - Sizeof( TBitmapFileHeader ) - Sizeof( TBitmapInfoHeader );
         if Off <> ColorCount then
            ColorCount := Off;
      end;
      if ColorCount <> 0 then
         if Strm.Read( FResData.fDIBheader.bmiColors[ 0 ], ColorCount )
            <> DWORD( ColorCount ) then Exit;
      if Size = 0 then
         Size := FResData.fDIBSize //ScanLineSize * fHeight
      else
         Size := Min( {Size - Sizeof( TBitmapFileHeader ) - Sizeof( TBitmapInfoHeader )
              - ColorCount} FResData.fDIBSize, Strm.Size - Strm.Position );

      Size1 := Min( Size, FResData.fDIBSize );
      if Strm.Read( FResData.fBmp.bmBits^, Size1 ) <> DWORD( Size1 ) then Exit;
      if Size > Size1 then
        Strm.Seek( Size - Size1, spCurrent );

      Result := True;
    end;
begin
  Pos := Strm.Position;
  if not ReadBitmap then
  begin
     Strm.Seek( Pos, spBegin );
     Clear;
     exit;
  end;
  FGDIResData.Handle:=0;
  SetData(FGDIResData);
end;

////////////////// bitmap RLE-decoding and loading - by Vyacheslav A. Gavrik

type
  PByteArray    =^TByteArray;
  TByteArray    = array[Word]of Byte;

procedure DecodeRLE4(Bmp:PGDIBitmap; Data:Pointer); // by Vyacheslav A. Gavrik
  procedure OddMove(Src,Dst:PByte;Size:Integer);
  begin
    if Size=0 then Exit;
    repeat
      Dst^:=(Dst^ and $F0)or(Src^ shr 4);
      Inc(Dst);
      Dst^:=(Dst^ and $0F)or(Src^ shl 4);
      Inc(Src);
      Dec(Size);
    until Size=0;
  end;
  procedure OddFill(Mem:PByte;Size,Value:Integer);
  begin
    Value:=(Value shr 4)or(Value shl 4);
    Mem^:=(Mem^ and $F0)or(Value and $0F);
    Inc(Mem);
    if Size>1 then FillChar(Mem^,Size,Value);
    Mem^:=(Mem^ and $0F)or(Value and $F0);
  end;
var
  pb: PByte;
  x,y,z,i: Integer;
begin
  pb:=Data; x:=0; y:=0;
  if Bmp.FResData.fScanLineSize = 0 then
     Bmp.ScanLineSize;
  while y<Bmp.Height do
  begin
    if pb^=0 then
    begin
      Inc(pb);
      z:=pb^;
      case pb^ of
        0: begin
             Inc(y);
             x:=0;
           end;
        1: Break;
        2: begin
             Inc(pb); Inc(x,pb^);
             Inc(pb); Inc(y,pb^);
           end;
        else
        begin
          Inc(pb);
          i:=(z+1)shr 1;
          if(z and 2)=2 then Inc(i);
          if((x and 1)=1)and(x+i<Bmp.Width)then
            OddMove(pb,@PByteArray(Integer( Bmp.FResData.fBmp.bmBits ) + Bmp.FResData.fScanLineSize * y)[x shr 1],i)
          else
            Move(pb^,PByteArray(Integer( Bmp.FResData.fBmp.bmBits ) + Bmp.FResData.fScanLineSize * y)[x shr 1],i);
          Inc(pb,i-1);
          Inc(x,z);
        end;
      end;
    end else
    begin
      z:=pb^;
      Inc(pb);
      if((x and 1)=1)and(x+z<Bmp.Width)then
        OddFill(@PByteArray(Integer( Bmp.FResData.fBmp.bmBits ) + Bmp.FResData.fScanLineSize * y)[x shr 1],z shr 1,pb^)
      else
        FillChar(PByteArray(Integer( Bmp.FResData.fBmp.bmBits ) + Bmp.FResData.fScanLineSize * y)[x shr 1],z shr 1,pb^);
      Inc(x,z);
    end;
    Inc(pb);
  end;
end;

procedure DecodeRLE8(Bmp:PGDIBitmap;Data:Pointer); // by Vyacheslav A. Gavrik
var
  pb: PByte;
  x,y,z,i: Integer;
begin
  pb:=Data; y:=0; x:=0;
  if Bmp.FResData.fScanLineSize = 0 then
     Bmp.ScanLineSize;

  while y<Bmp.Height do
  begin
    if pb^=0 then
    begin
      Inc(pb);
      case pb^ of
        0: begin
             Inc(y);
             x:=0;
           end;
        1: Break;
        2: begin
             Inc(pb); Inc(x,pb^);
             Inc(pb); Inc(y,pb^);
           end;
        else
        begin
          i:=pb^;
          z:=(i+1)and(not 1);
          Inc(pb);
          Move(pb^,PByteArray(Integer( Bmp.FResData.fBmp.bmBits ) + Bmp.FResData.fScanLineSize * y)[x],z);
          Inc(pb,z-1);
          Inc(x,i);
        end;
      end;
    end else
    begin
      i:=pb^; Inc(pb);
      FillChar(PByteArray(Integer( Bmp.FResData.fBmp.bmBits ) + Bmp.FResData.fScanLineSize * y)[x],i,pb^);
      Inc(x,i);
    end;
    Inc(pb);
  end;
end;

function TGDIBitmap.LoadFromFileEx(const Filename: String): Boolean; // by Vyacheslav A. Gavrik
var Strm: PStream;
begin
  Strm := NewReadFileStream( Filename );
  Result := LoadFromStreamEx(Strm);
  Strm.Free;
end;

function TGDIBitmap.LoadFromStreamEx(Strm: PStream): Boolean; // by Vyacheslav A. Gavrik
var Pos : Integer;
    BFH : TBitmapFileHeader;
    Buffer: Pointer;

    function ReadBitmap : Boolean;
    var Off, Size, ColorCount: Integer;
    begin
      FResData.fHandleType := bmDIB;
      Result := False;
      if Strm.Read( BFH, Sizeof( BFH ) ) <> Sizeof( BFH ) then Exit;
      Off := 0; Size := 0;
      if BFH.bfType <> $4D42 then
         Strm.Seek( Pos, spBegin )
      else
      begin
         Off := BFH.bfOffBits;
         Size := Strm.Size;
      end;
      GetMem( FResData.fDIBHeader, 256*sizeof(TRGBQuad) + sizeof(TBitmapInfoHeader) );
      if Strm.Read( FResData.fDIBHeader^, Sizeof(TBitmapInfoHeader) ) <> Sizeof(TBitmapInfoHeader) then
         Exit;

      FResData.fNewPixelFormat := Bits2PixelFormat( FResData.fDIBHeader.bmiHeader.biBitCount
                         * FResData.fDIBHeader.bmiHeader.biPlanes );

      FResData.fBmp.bmWidth := FResData.fDIBHeader.bmiHeader.biWidth;
      ASSERT( FResData.fBmp.bmWidth > 0, 'Bitmap width must be > 0' );
      FResData.fBmp.bmHeight := Abs(FResData.fDIBHeader.bmiHeader.biHeight);
      ASSERT( FResData.fBmp.bmHeight > 0, 'Bitmap height must be > 0' );

      FResData.fDIBSize := ScanLineSize * FResData.fBmp.bmHeight;
      GetMem( FResData.fBmp.bmBits, FResData.fDIBSize );
      ASSERT( FResData.fBmp.bmBits <> nil, 'No memory' );
      ASSERT( FResData.fDIBHeader.bmiHeader.biCompression in [BI_RLE8,BI_RLE4,BI_RGB,BI_RLE8,BI_BITFIELDS],
              'Unknown compression algorithm');

      ColorCount := 0;
      if FResData.fDIBHeader.bmiHeader.biBitCount <= 8 then
        ColorCount := (1 shl FResData.fDIBHeader.bmiHeader.biBitCount) * Sizeof( TRGBQuad )
      else if FResData.fNewPixelFormat = pf16bit then
        ColorCount := 12;

      if Off > 0 then
      begin
         Off := Off - SizeOf( TBitmapFileHeader ) - Sizeof( TBitmapInfoHeader );
         if Off <> ColorCount then
            ColorCount := Off;
      end;
      if ColorCount <> 0 then
         if Strm.Read( FResData.fDIBheader.bmiColors[ 0 ], ColorCount )
            <> DWORD( ColorCount ) then Exit;

      if(FResData.fDIBHeader.bmiHeader.biCompression = BI_RLE8)
         or (FResData.fDIBHeader.bmiHeader.biCompression=BI_RLE4) then
            Size := BFH.bfSize - BFH.bfOffBits
         else
           if Integer( Strm.Size - BFH.bfOffBits) - Pos > Integer(Size) then
             Size := FResData.fDIBSize
           else
             Size := Strm.Size - BFH.bfOffBits - DWORD( Pos );

      if (FResData.fDIBHeader.bmiHeader.biCompression = BI_RGB) or
         (FResData.fDIBHeader.bmiHeader.biCompression = BI_BITFIELDS) then
      begin
        if Strm.Read( FResData.fBmp.bmBits^, Size ) <> DWORD( Size ) then
          Exit;
      end
        else
      begin
        GetMem(Buffer,Size);
        if Strm.Read(Buffer^,Size) <> DWORD( Size ) then Exit;

        if FResData.fDIBHeader.bmiHeader.biCompression=BI_RLE8 then
           DecodeRLE8(@Self,Buffer)
        else
           DecodeRLE4(@Self,Buffer);

        FResData.fDIBHeader.bmiHeader.biCompression := BI_RGB;
        FreeMem(Buffer);
      end;

      Result := True;
    end;
begin
  Pos := Strm.Position;
  result := ReadBitmap;
  if not result then
  begin
     Strm.Seek( Pos, spBegin );
     Clear;
     exit;
  end;
  FGDIResData.Handle:=0;
  SetData(FGDIResData);
end;

///////////////////////////


{$IFDEF ASM_VERSION}
procedure TGDIBitmap.SaveToFile(const Filename: String);
asm
        PUSH     EAX
        PUSH     EDX
        CALL     GetEmpty
        POP      EAX
        JZ       @@exit
        CALL     NewWriteFileStream
        XCHG     EDX, EAX
        POP      EAX
        PUSH     EDX
        CALL     SaveToStream
        POP      EAX
        CALL     TObj.Free
        PUSH     EAX
@@exit: POP      EAX
end;
{$ELSE} //Pascal
procedure TGDIBitmap.SaveToFile(const Filename: String);
var Strm: PStream;
begin
  if Empty then Exit;
  Strm := NewWritefileStream( Filename );
  SaveToStream( Strm );
  Strm.Free;
end;
{$ENDIF}

{$IFDEF ASM_VERSION}
procedure TGDIBitmap.SaveToStream(Strm: PStream);
type  tBFH = TBitmapFileHeader;
      tBIH = TBitmapInfoHeader;
const szBIH = Sizeof( tBIH );
      szBFH = Sizeof( tBFH );
asm
        PUSH     EBX
        PUSH     ESI
        MOV      EBX, EAX
        MOV      ESI, EDX
        CALL     GetEmpty
        JZ       @@exit
        MOV      EAX, ESI
        CALL     TStream.GetPosition
        PUSH     EAX

        MOV      EAX, EBX
        XOR      EDX, EDX // EDX = bmDIB
        CALL     SetHandleType
        XOR      EAX, EAX
        MOV      EDX, [EBX].fDIBHeader
        MOVZX    ECX, [EDX].TBitmapInfoHeader.biBitCount
        CMP      CL, 8
        JG       @@1
        MOV      AL, 4
        SHL      EAX, CL
@@1:
          PUSH     EAX                        // ColorsSize
        LEA      ECX, [EAX + szBFH + szBIH]
        CMP      [EDX].TBitmapInfoHeader.biCompression, 0
        JZ       @@10
        ADD      ECX, 74
@@10:
        PUSH     ECX                        // BFH.bfOffBits
        PUSH     0
        ADD      ECX, [EBX].fDIBSize
        PUSH     ECX
        MOV      CX, $4D42
        PUSH     CX
        XOR      ECX, ECX
        MOV      EDX, ESP
        MOV      CL, szBFH
          PUSH     ECX
        MOV      EAX, ESI
        CALL     TStream.Write
          POP      ECX
        ADD      ESP, szBFH
        XOR      EAX, ECX
          POP      ECX  // ColorsSize
        JNZ      @@ewrite

        MOV      EDX, [EBX].fDIBHeader
        CMP      [EDX].TBitmapInfoHeader.biCompression, 0
        JZ       @@11
        ADD      ECX, 74
@@11:

        ADD      ECX, szBIH
        PUSH     ECX
        MOV      EAX, ESI
        CALL     TStream.Write
        POP      ECX
        XOR      EAX, ECX
        JNZ      @@ewrite

        MOV      ECX, [EBX].fDIBSize
        MOV      EDX, [EBX].fDIBBits
        MOV      EAX, ESI
        PUSH     ECX
        CALL     TStream.Write
        POP      ECX
        XOR      EAX, ECX

@@ewrite:
        POP      EDX
        JZ       @@exit
        XCHG     EAX, ESI
        XOR      ECX, ECX
        CALL     TStream.Seek
@@exit:
        POP      ESI
        POP      EBX
end;
{$ELSE} //Pascal
procedure TGDIBitmap.SaveToStream(Strm: PStream);
var BFH : TBitmapFileHeader;
    Pos : Integer;
   function WriteBitmap : Boolean;
   var ColorsSize, BitsSize, Size : Integer;
   begin
      Result := False;
      if Empty then Exit;
      HandleType := bmDIB; // convert to DIB if DDB
      FillChar( BFH, Sizeof( BFH ), 0 );
      ColorsSize := 0;
      with FResData.fDIBHeader.bmiHeader do
           if biBitCount <= 8 then
              ColorsSize := (1 shl biBitCount) * Sizeof( TRGBQuad )
           {else
           if biCompression <> 0 then
              ColorsSize := 12};
      BFH.bfOffBits := Sizeof( BFH ) + Sizeof( TBitmapInfoHeader ) + ColorsSize;
      BitsSize := FResData.fDIBSize; //ScanLineSize * fHeight;
      BFH.bfSize := BFH.bfOffBits + DWord( BitsSize );
      BFH.bfType := $4D42; // 'BM';
      if FResData.fDIBHeader.bmiHeader.biCompression <> 0 then
      begin
         ColorsSize := 12 + 16*sizeof(TRGBQuad);
         Inc( BFH.bfOffBits, ColorsSize );
      end;
      if Strm.Write( BFH, Sizeof( BFH ) ) <> Sizeof( BFH ) then Exit;
      Size := Sizeof( TBitmapInfoHeader ) + ColorsSize;
      if Strm.Write( FResData.fDIBHeader^, Size ) <> DWORD(Size) then Exit;
      if Strm.Write( FResData.fBmp.bmBits^, BitsSize ) <> DWord( BitsSize ) then Exit;
      Result := True;
   end;
begin
  Pos := Strm.Position;
  if not WriteBitmap then
     Strm.Seek( Pos, spBegin );
end;
{$ENDIF}

procedure TGDIBitmap.SetHandle(const Value: HBitmap);
var
  B: tagBitmap;
  DIBSection:TDIBSection;
begin
  if Value <> 0 then
  begin
    FillChar(DIBSection,SizeOf(DIBSection),#0);
    if GetObject( Value, Sizeof( DIBSection ), @DIBSection ) <> 0 then
    begin
      ClearData;
      FGDIResData.Handle := Value;
      FResData.BmpHandle := Value; // for difference bitmap whithout Bits pointer

      FResData.fBmp:=DIBSection.dsBm;

      if DIBSection.dsBm.bmBits<> nil then
      begin
        FResData.fDIBAutoFree:=true;
        FResData.fHandleType := bmDIB;
        FResData.fDIBHeader := AllocMem( 256*Sizeof(TRGBQuad)+Sizeof(TBitmapInfoHeader) );
        Assert( FResData.fDIBHeader <> nil, 'No memory' );
        FResData.fDIBHeader.bmiHeader:=DibSection.dsBmih;
      end;

      SetData(FGDIResData);
      exit;
    end;
  end;
  Clear;
end;

procedure TGDIBitmap.SetWidth(const Value: Integer);
begin
  if FResData.fBmp.bmWidth = Value then Exit;

//  FGDIResData.fResType

  Handle:=CopyImage(GetHandle,FGDIResData.fResType, Value, FResData.fBmp.bmHeight,LR_DEFAULTSIZE or LR_COPYRETURNORG);
//  Assert(false,'NOT Verified');
//  FResData.fBmp.bmWidth := Value;
//  ResizeBitmap(X,Y);
//  FormatChanged;
end;

procedure TGDIBitmap.SetHeight(const Value: Integer);
begin
  if FResData.fBmp.bmHeight = Value then Exit;

  Handle:=CopyImage(GetHandle,FGDIResData.fResType, FResData.fBmp.bmWidth, Value, 0);

{  Assert(false,'NOT Verified');

    HandleType := bmDDB;
    // Not too good, but provides correct changing of height
    // preserving previous image

  FResData.fBmp.bmHeight := Value;
  FormatChanged;}
end;

procedure TGDIBitmap.SetPixelFormat(Value: TPixelFormat);
begin
  if PixelFormat = Value then Exit;
  if Empty then Exit;
  if Value = pfDevice then
    HandleType := bmDDB
  else
  begin
    FResData.fNewPixelFormat := Value;
    //if Value = pf16bit then Value := pf15bit;
    HandleType := bmDIB;
    if Value <> Bits2PixelFormat( FResData.fDIBHeader.bmiHeader.biBitCount ) then
      FormatChanged;
  end;
end;

function CalcScanLineSize( Header: PBitmapInfoHeader ): Integer;
begin
  //Result := ((Header.biBitCount * Header.biWidth + 31)
  //          shr 5) * 4;
  Result := ((Header.biBitCount * Header.biWidth + 31) shr 3) and $FFFFFFFC;
end;

procedure FillBmpWithBkColor( Bmp: PGDIBitmap; DC2: HDC; oldWidth, oldHeight: Integer );
var oldBmp: HBitmap;
    R: TRect;
    Br: HBrush;
begin
  with Bmp^ do
  if Color2RGB( fBkColor ) <> 0 then
  if (oldWidth < FResData.fBmp.bmWidth) or (oldHeight < FResData.fBmp.bmHeight) then
    if GetHandle <> 0 then
    begin
      oldBmp := SelectObject( DC2, FGDIResData.Handle );
      ASSERT( oldBmp <> 0, 'Can not select bitmap to DC' );
      Br := CreateSolidBrush( Color2RGB( fBkColor ) );
      R := MakeRect( oldWidth, oldHeight, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight );
      if oldWidth = FResData.fBmp.bmWidth then
         R.Left := 0;
      if oldHeight = FResData.fBmp.bmHeight then
         R.Top := 0;
      Windows.FillRect( DC2, R, Br );
      DeleteObject( Br );
      SelectObject( DC2, oldBmp );
    end;
end;

const BitCounts: array[ TPixelFormat ] of Byte = ( 0, 1, 4, 8, 16, 16, 24, 32, 0 );
procedure TGDIBitmap.FormatChanged;
// This method is used whenever Width, Height, PixelFormat or HandleType
// properties are changed.
// Old image will be drawn here to a new one (excluding cases when
// old width or height was 0, and / or new width or height is 0).
// To avoid inserting this code into executable, try not to change
// properties Width / Height of bitmat after it is created using
// NewBitmap( W, H ) function or after it is loaded from file, stream
// or resource.

var B: ^tagBitmap;
    //BSz: Integer;

var oldBmp, NewHandle: HBitmap;
    DC0, DC2: HDC;
    NewHeader: PBitmapInfo;
    NewBits: Pointer;
    oldHeight, oldWidth, sizeBits, bitsPixel: Integer;
    Br: HBrush;
    N: Integer;
    NewDIBAutoFree: Boolean;
begin
  if Empty then Exit;
  NewDIBAutoFree := FALSE;
  DoDetachBitmapFromCanvas(FImageResource);
//  fDetachCanvas( @Self );
  FResData.fScanLineSize := 0;

    oldWidth := FResData.fBmp.bmWidth;
    oldHeight := FResData.fBmp.bmHeight;
    if FResData.fBmp.bmBits <> nil then
    begin
      oldWidth := FResData.fDIBHeader.bmiHeader.biWidth;
      oldHeight := Abs(FResData.fDIBHeader.bmiHeader.biHeight);
    end
      else
    if FGDIResData.Handle <> 0 then
    begin
        GetMem( B, SizeOf(tagBITMAP) );
        if GetObject( FGDIResData.Handle, SizeOf(tagBITMAP), B ) <> 0 then
        begin
          oldWidth := B.bmWidth;
          oldHeight := B.bmHeight;
          //fDIBBits := B.bmBits;
        end;
        FreeMem( B );
    end;

  DC2 := CreateCompatibleDC( 0 );

  if FResData.fHandleType = bmDDB then
  begin
    // New HandleType is bmDDB: old bitmap can be copied using Draw method
    DC0 := GetDC( 0 );
    NewHandle := CreateCompatibleBitmap( DC0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight );
    ASSERT( NewHandle <> 0, 'Can not create DDB' );
    ReleaseDC( 0, DC0 );

    oldBmp := SelectObject( DC2, NewHandle );
    ASSERT( oldBmp <> 0, 'Can not select bitmap to DC' );

    Br := CreateSolidBrush( Color2RGB( fBkColor ) );
    Windows.FillRect( DC2, MakeRect( 0, 0, FResData.fBmp.bmWidth, FResData.fBmp.bmHeight ), Br );
    DeleteObject( Br );

    if FResData.fBmp.bmBits <> nil then
    begin
      SelectObject( DC2, oldBmp );
      SetDIBits( DC2, NewHandle, 0, FResData.fBmp.bmHeight, FResData.fBmp.bmBits, FResData.fDIBHeader^, DIB_RGB_COLORS );
    end
       else
    begin
      Draw( DC2, 0, 0 );
      SelectObject( DC2, oldBmp );
    end;

    FResData.fBmp.bmBits := nil;
    FResData.fDIBHeader := nil;
    FResData.fScanLineSize := 0;
//    fDetachCanvas := DetachBitmapFromCanvas{DummyDetachCanvas};
//  FGDIResData.Handle:=0;
//    ClearData; // Image is cleared but fWidth and fHeight are preserved
    FGDIResData.Handle := NewHandle;
    FResData.BmpHandle := NewHandle; // for difference bitmap whithout Bits pointer
    SetData(FGDIResData);
  end
     else
  begin
    // New format is DIB. GetDIBits applied to transform old data to new one.
    bitsPixel := BitCounts[ FResData.fNewPixelFormat ];
    if bitsPixel = 0 then
    begin
      bitsPixel := BitCounts[DefaultPixelFormat];
    end;

    NewHandle := 0;
    NewHeader := PrepareBitmapHeader( FResData.fBmp.bmWidth, FResData.fBmp.bmHeight, bitsPixel );
    if FResData.fNewPixelFormat = pf16bit then
      PreparePF16bit( NewHeader );

    sizeBits := CalcScanLineSize( @NewHeader.bmiHeader ) * FResData.fBmp.bmHeight;

      GetMem( NewBits, sizeBits );
      ASSERT( NewBits <> nil, 'No memory' );

      N :=
      GetDIBits( DC2, GetHandle, 0, Min( FResData.fBmp.bmHeight, oldHeight ),
                 NewBits, NewHeader^, DIB_RGB_COLORS );
      //Assert( N = Min( fHeight, oldHeight ), 'Can not get all DIB bits' );
      if N <> Min( FResData.fBmp.bmHeight, oldHeight ) then
      begin
        FreeMem( NewBits );
        NewBits := nil;
        NewHandle := CreateDIBSection( DC2, NewHeader^, DIB_RGB_COLORS, NewBits, 0, 0 );
        NewDIBAutoFree := TRUE;
        ASSERT( NewHandle <> 0, 'Can not create DIB secion for pf16bit bitmap' );
        oldBmp := SelectObject( DC2, NewHandle );
        ASSERT( oldBmp <> 0, 'Can not select pf16bit to DC' );
        Draw( DC2, 0, 0 );
        SelectObject( DC2, oldBmp );
      end;

    ClearData;

    FResData.fDIBSize := sizeBits;
    FResData.fBmp.bmBits := NewBits;
    FResData.fDIBHeader := NewHeader;
    FResData.fDIBAutoFree := NewDIBAutoFree;
    FGDIResData.Handle := NewHandle;
    SetData(FGDIResData);
  end;

  if Assigned( FResData.fFillWithBkColor ) then
     FResData.fFillWithBkColor( @Self, DC2, oldWidth, oldHeight );

  DeleteDC( DC2 );
end;

function TGDIBitmap.GetScanLine(Y: Integer): Pointer;
begin
  ASSERT( (Y >= 0) and (Y < FResData.fbmp.bmHeight), 'ScanLine index out of bounds' );
  ASSERT( FResData.fbmp.bmBits <> nil, 'No bits available' );
  Result := nil;
  if FResData.fDIBHeader = nil then Exit;

  if FResData.fDIBHeader.bmiHeader.biHeight > 0 then
     Y := FResData.fbmp.bmHeight - 1 - Y;
  if FResData.fScanLineSize = 0 then
     ScanLineSize;

  Result := Pointer( Integer( FResData.fbmp.bmBits ) + FResData.fScanLineSize * Y );
end;

function TGDIBitmap.GetScanLineSize: Integer;
begin
  Result := 0;
  if FResData.fDIBHeader = nil then Exit;
  FResData.FScanLineSize := CalcScanLineSize( @FResData.fDIBHeader.bmiHeader );
  Result := FResData.FScanLineSize;
end;

procedure TGDIBitmap.CanvasChanged( Sender : PObj );
begin
  fBkColor := PGDICanvas( Sender ).Brush.Color;
  ClearTransImage;
end;

procedure TGDIBitmap.Dormant;
begin
  if FResData.fCanvas <> nil then
  begin
    FResData.fCanvas := nil;
    SetData(FGDIResData);
  end;
end;

procedure TGDIBitmap.SetBkColor(const Value: TColor);
begin
  if fBkColor = Value then Exit;
  fBkColor := Value;
  FResData.fFillWithBkColor := FillBmpWithBkColor;
  if Assigned( FResData.fApplyBkColor2Canvas ) then
    FResData.fApplyBkColor2Canvas( @Self );
end;

function TGDIBitmap.Assign(SrcBmp: PGDIBitmap): Boolean;
begin
  ClearTransImage;
  FGDIResData:=SrcBmp.FGDIResData;
  FResData:=SrcBmp.FResData;
  SetData(FGDIResData);
end;

procedure TGDIBitmap.SetHandleType(const Value: TBitmapHandleType);
begin
  if FResData.fHandleType = Value then Exit;
  FResData.fHandleType := Value;
  FormatChanged;
end;

function TGDIBitmap.GetPixelFormat: TPixelFormat;
begin
  if (HandleType = bmDDB) or (FResData.fBmp.bmBits = nil) then
    Result := pfDevice
  else
  begin
    Result := Bits2PixelFormat( FResData.fDIBHeader.bmiHeader.biBitCount );
    if (Result = pf15bit) and (FResData.fDIBHeader.bmiHeader.biCompression <> 0) then
    begin
      Assert( FResData.fDIBHeader.bmiHeader.biCompression = BI_BITFIELDS, 'Unsupported bitmap format' );
      Result := pf16bit;
    end;
  end;
end;

procedure TGDIBitmap.ClearTransImage;
begin
  fTransColor := clNone;
  fTransMaskBmp.Free;
  fTransMaskBmp := nil;
//  SetData(FGDIResData);
end;

procedure TGDIBitmap.Convert2Mask(TranspColor: TColor);
var MonoHandle: HBitmap;
    SaveMono, SaveFrom: THandle;
    MonoDC, {DC0,} DCfrom: HDC;
    SaveBkColor: TColorRef;
begin
  Assert(false,'NOT Verified');
  if GetHandle = 0 then Exit;
(*  fDetachCanvas( @Self );
  ///DC0 := GetDC( 0 );
  MonoHandle := CreateBitmap( FResData.fWidth, FResData.fHeight, 1, 1, nil );
  ASSERT( MonoHandle <> 0, 'Can not create monochrome bitmap' );
  MonoDC := CreateCompatibleDC( 0 );
  SaveMono := SelectObject( MonoDC, MonoHandle );
  ASSERT( SaveMono <> 0, 'Can not select bitmap to DC' );
  DCfrom := CreateCompatibleDC( 0 );
  SaveFrom := SelectObject( DCfrom, FResData.fHandle );
  ASSERT( SaveFrom <> 0, 'Can not select source bitmap to DC' );
  TranspColor := Color2RGB( TranspColor );
  SaveBkColor := Windows.SetBkColor( DCfrom, TranspColor );
  BitBlt( MonoDC, 0, 0, FResData.fWidth, FResData.fHeight, DCfrom, 0, 0, SRCCOPY );
  {$IFDEF CHK_BITBLT} Chk_BitBlt; {$ENDIF}
  Windows.SetBkColor( DCfrom, SaveBkColor );
  SelectObject( DCfrom, SaveFrom );
  DeleteDC( DCfrom );
  SelectObject( MonoDC, SaveMono );
  DeleteDC( MonoDC );
  ///ReleaseDC( 0, DC0 );
  ClearData;
  FResData.fHandle := MonoHandle;
  FResData.fHandleType := bmDDB;
  *)
end;




function TGDIBitmap.GetPixels(X, Y: Integer): TColor;
var DC: HDC;
    Save: THandle;
begin
  Assert(false,'NOT Verified');
  Result := clNone;
  //if GetHandle = 0 then Exit;
  if Empty then Exit;
  DoDetachBitmapFromCanvas(FImageResource);
//  fDetachCanvas( @Self );
  DC := CreateCompatibleDC( 0 );
  Save := SelectObject( DC, GetHandle );
  ASSERT( Save <> 0, 'Can not select bitmap to DC' );
  Result := Windows.GetPixel( DC, X, Y );
  SelectObject( DC, Save );
  DeleteDC( DC );
end;

procedure TGDIBitmap.SetPixels(X, Y: Integer; const Value: TColor);
var DC: HDC;
    Save: THandle;
begin
  Assert(false,'NOT Verified');
  //if GetHandle = 0 then Exit;
  if Empty then Exit;
  DoDetachBitmapFromCanvas(FImageResource);
//  fDetachCanvas( @Self );
  DC := CreateCompatibleDC( 0 );
  Save := SelectObject( DC, GetHandle );
  ASSERT( Save <> 0, 'Can not select bitmap to DC' );
  Windows.SetPixel( DC, X, Y, Color2RGB( Value ) );
  SelectObject( DC, Save );
  DeleteDC( DC );
end;


procedure TGDIBitmap.FlipVertical;
var DC: HDC;
    Save: THandle;
    TmpScan: PByte;
    Y: Integer;
begin
  Assert(false,'NOT Verified');
{  if FResData.fHandle <> 0 then
  begin
    fDetachCanvas( @Self );
    DC := CreateCompatibleDC( 0 );
    Save := SelectObject( DC, FResData.fHandle );
    StretchBlt( DC, 0, FResData.fHeight - 1, FResData.fWidth, -FResData.fHeight, DC, 0, 0, FResData.fWidth, FResData.fHeight, SRCCOPY );
    SelectObject( DC, Save );
    DeleteDC( DC );
  end
     else
  if fDIBBits <> nil then
  begin
    GetMem( TmpScan, ScanLineSize );
    for Y := 0 to FResData.fHeight div 2 do
    begin
      Move( ScanLine[ Y ]^, TmpScan^, fScanLineSize );
      Move( ScanLine[ FResData.fHeight - Y - 1 ]^, ScanLine[ Y ]^, fScanLineSize );
      Move( TmpScan^, ScanLine[ FResData.fHeight - Y - 1 ]^, fScanLineSize );
    end;
  end;}
end;

procedure TGDIBitmap.FlipHorizontal;
var DC: HDC;
    Save: THandle;
begin
  Assert(false,'NOT Verified');
{  if GetHandle <> 0 then
  begin
    fDetachCanvas( @Self );
    DC := CreateCompatibleDC( 0 );
    Save := SelectObject( DC, FResData.fHandle );
    StretchBlt( DC, FResData.fWidth - 1, 0, -FResData.fWidth, FResData.fHeight, DC, 0, 0, FResData.fWidth, FResData.fHeight, SRCCOPY );
    SelectObject( DC, Save );
    DeleteDC( DC );
  end;}
end;

procedure TGDIBitmap.CopyRect(const DstRect: TRect; SrcBmp: PGDIBitmap;
  const SrcRect: TRect);
var DCsrc, DCdst: HDC;
    SaveSrc, SaveDst: THandle;
begin
  Assert(false,'NOT Verified');
  if (GetHandle = 0) or (SrcBmp.GetHandle = 0) then Exit;
{  fDetachCanvas( @Self );
  fDetachCanvas( SrcBmp );
  DCsrc := CreateCompatibleDC( 0 );
  SaveSrc := SelectObject( DCsrc, SrcBmp.FResData.fHandle );
  DCdst := DCsrc;
  SaveDst := 0;
  if SrcBmp <> @Self then
  begin
    DCdst := CreateCompatibleDC( 0 );
    SaveDst := SelectObject( DCdst, FResData.fHandle );
  end;
  StretchBlt( DCdst, DstRect.Left, DstRect.Top, DstRect.Right - DstRect.Left,
              DstRect.Bottom - DstRect.Top, DCsrc, SrcRect.Left, SrcRect.Top,
              SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top,
              SRCCOPY );
  if SrcBmp <> @Self then
  begin
    SelectObject( DCdst, SaveDst );
    DeleteDC( DCdst );
  end;
  SelectObject( DCsrc, SaveSrc );
  DeleteDC( DCsrc );}
end;


function TGDIBitmap.CopyToClipboard: Boolean;
var DibMem: PChar;
    HdrSize: Integer;
    Gbl: HGlobal;
begin
  Assert(false,'NOT Verified');
  Result := FALSE;
  if Applet = nil then Exit;
  if not OpenClipboard( Applet.GetWindowHandle ) then
    Exit;
  if EmptyClipboard then
  begin
    HandleType := bmDIB;
    HdrSize := sizeof( TBitmapInfoHeader );
    if FResData.fDIBHeader.bmiHeader.biBitCount <= 8 then
       Inc( HdrSize,
       (1 shl FResData.fDIBHeader.bmiHeader.biBitCount) * Sizeof( TRGBQuad ) );
    Gbl := GlobalAlloc( GMEM_MOVEABLE, HdrSize + FResData.fDIBSize );
    DibMem := GlobalLock( Gbl );
    if DibMem <> nil then
    begin
      Move( FResData.fDIBHeader^, DibMem^, HdrSize );
      Move( FResData.fBmp.bmBits^, Pointer( Integer( DibMem ) + HdrSize )^, FResData.fDIBSize );
      if not GlobalUnlock( Gbl ) and (GetLastError = NO_ERROR) then
      begin
        Result := SetClipboardData( CF_DIB, Gbl ) <> 0;
      end;
    end;
  end;
  CloseClipboard;
end;

function TGDIBitmap.PasteFromClipboard: Boolean;
var Gbl: HGlobal;
    DIBPtr: PChar;
    Size, HdrSize: Integer;
    Mem: PChar;
begin
  Assert(false,'NOT Verified');
  Result := FALSE;
  if Applet = nil then Exit;
  if not OpenClipboard( Applet.GetWindowHandle ) then Exit;
  if IsClipboardFormatAvailable( CF_DIB ) then
  begin
    Gbl := GetClipboardData( CF_DIB );
    if Gbl <> 0 then
    begin
      Size := GlobalSize( Gbl );
      Mem := GlobalLock( Gbl );
      if (Size > 0) and (Mem <> nil) then
      begin
        GetMem( DIBPtr, Size );
        Move( Mem^, DIBPtr^, Size );
        GlobalUnlock( Gbl );
        // read DIB data here:
        Clear;

        HdrSize := Sizeof( TBitmapInfoHeader );
        FResData.fDIBHeader := Pointer( DIBPtr );
        if FResData.fDIBHeader.bmiHeader.biBitCount <= 8 then
          Inc( HdrSize, (1 shl FResData.fDIBHeader.bmiHeader.biBitCount) * Sizeof( TRGBQuad ) );

        GetMem( FResData.fDIBHeader, Sizeof( TBitmapInfoHeader ) + 256 * sizeof( TRGBQuad ) );
        Move( DIBPtr^, FResData.fDIBHeader^, HdrSize );

        FResData.fDIBSize := Size - HdrSize;
        GetMem( FResData.fBmp.bmBits, FResData.fDIBSize );
        Move( Pointer( Integer( DIBPtr ) + HdrSize )^, FResData.fBmp.bmBits^, FResData.fDIBSize );

        FResData.fBmp.bmWidth := FResData.fDIBHeader.bmiHeader.biWidth;
        FResData.fBmp.bmHeight := FResData.fDIBHeader.bmiHeader.biHeight;

        FreeMem( DIBPtr );
        Result := TRUE;
      end;
    end;
  end;
  CloseClipboard;
end;


initialization

  New(ResourceManager,Create);
finalization
  ResourceManager.Free;


end.
