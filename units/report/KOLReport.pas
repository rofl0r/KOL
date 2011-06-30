{ KOLReport v2.0 (C) 2002 by Vladimir Kladov.

  See Demo project attached for documentation. All other documentation planned
  to be added later.

  In version 2.0:
  [+] metafiles used, spooling size became less, printing quality increased.
  [+] with new version of KOLPrinters by Boguslaw Brandys, printer setup dialog provided.
}
unit KOLReport;

interface

//{$DEFINE use_MHPRINTER}
// (uncomment line above to use TKOLMHPrinter prior to TKOLPrinter)

uses Windows, Messages, KOL,
     {$IFDEF use_MHPRINTER} KOLMHPrinters
     {$ELSE} KOLPrinters, KOLPageSetupDialog
     {$ENDIF};

type
  {$IFDEF use_MHPRINTER} PPrinter = PMHPrinter; {$ENDIF}

  TPaperSize = ( psA4, psA5, psA6, psA3, psLetter, psCustom );
  {* Available paper sizes. }
  TBandLayout = ( blLeft, blCenter, blRight, blExpandRight );
  {* Available band layouts. }
  TMargins = TRect;

  TMF = HDC; // used as a handle to memory-based EnhMetafile.

  PReport = ^TReport;

  PPreviewObj = ^TPreviewObj;
  TPreviewObj = object( TObj )
  {* Preview form container object. }
  private
    procedure SetCurPage(const Value: Integer);
    procedure SetFitMode(const Value: Integer);
  public
    Form: PControl;
    {* Form. }
    TB: PControl;
    {* Toolbar. }
    SB: PControl;
    {* Scrollbar. }
    PB: PControl;
    {* PaintBox. }
    LB: PControl;
    PSD: PPageSetupDlg; {Brandys}
    Options: TPageSetupOptions;
    {* Label to show current page number and total pages count. }
    FFitMode: Integer;
    {* Fit mode: 0 - fit height, 1 - fit width, 2 - 1:1 }
    ViewMenu: PMenu;
    {* Drop down menu for toolbar button TBView. }
    FBuf: PBitmap;
    {* Buffer where current page stored (scaled). }
  protected
    FReport: PReport;
    {* Reference to parent Report object. }
    FCurPage: Integer;
    {* Current page index. }
    FBufPage: Integer;
    {* Buffered page index. }
    procedure TBClick( Sender: PObj );
    procedure TBDropDownViewMenu( Sender: PObj );
    procedure TBViewMenuClick( Sender: PMenu; Item: Integer );
    procedure AdjustButtons( Sender: PObj );
    procedure PaintPage( Sender: PControl; DC: HDC );
    procedure AdjustFitMode;
    procedure PrinterSetup;
    procedure ResizePreviewForm( Sender: PObj );
  public
    destructor Destroy; virtual;
    {* }
    property CurPage: Integer read FCurPage write SetCurPage;
    {* Current page index (starting from 0). }
    function PageCount: Integer;
    {* Total pages count. Could be 0, if a report is empty (nothing to show). }
    procedure PrintAllPages;
    {* Call this method to print all pages. }
    property FitMode: Integer read FFitMode write SetFitMode;
    {* Fit mode: 0 - fit height, 1 - fit width, 2 - 1:1. }
  end;

  TReport = object( TObj )
  {* Report object. It is used to create report and to print or preview it}
  private
    FDocName: String;
    FReplaceFontHeight0: Integer;
    FMargins: TMargins;
    function GetPages(Idx: Integer): TMF;
    function GetImages(Idx: Integer): HENHMETAFILE;
    procedure SetMargins(const Value: TMargins);
    function GetMarginsPixels( const Index: Integer ): TMargins;
  protected
    FPageTop: Boolean;
    FY: Integer;
    FOnNewPage: TOnEvent;
    FPrinter: PPrinter;
    FX: Integer;
    FPrinting: Boolean;
    FDCPages: PList;
    FHDPages: PList;
    FStage: Integer;
    FOnPrint: TOnEvent;
    FPreviewForm: PPreviewObj;
    FBottom: Integer;
    FPagePixelsSize: TSize;
    FPaperSize: TPaperSize;
    FCustomPaperSize: TSize;
    FPageWidth: Integer;
    FPageHeight: Integer;
    FDoubleBufferedPreview: Boolean;
    FCurBandHeight: Integer;
    FOnEndBand: TOnEvent;
    fNewPageHandling: Boolean;
    fNewBandHandling: Boolean;
    procedure SetPageTop(const Value: Boolean);
    procedure SetPrinter(const Value: PPrinter);
    function GetPageCount: Integer;
    function GetPreviewForm: PPreviewObj;
    procedure SetPreviewForm(const Value: PPreviewObj);
    function GetCurrentPage: TMF;
    function GetPrinter: PPrinter;
    function GetPagePixelsSize: TSize;
    function GetOrientation: TPrinterOrientation;
    procedure SetPaperSize(const Value: TPaperSize);
    procedure SetCustomPaperSize(const Value: TSize);
    function GetPageHeight: Integer;
    function GetPageWidth: Integer;
    procedure GetPageWidthHeight;
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
  protected
    function AddPage: TMF;
    function PaintBand( MF: TMF; Band: PControl; Xpos, Ypos: Integer ): Integer;
    function ScaleX( W: Integer ): Integer;
    function ScaleY( H: Integer ): Integer;
    procedure DoPrintPreview( Proc: TObjectMethod );
    procedure DoPrint;
    procedure DoPreview;
    procedure DoPreviewModal;
  public
    Destructor Destroy; virtual;
    procedure Clear;
    {* Call this method to make report empty. If the preview form is active
       for the report, it is closed too. }
    procedure ClearPages;
    {* Clears all pages. }
    property PreviewForm: PPreviewObj read GetPreviewForm write SetPreviewForm;
    {* Access to preview form object. }
    property DoubleBufferedPreview: Boolean read FDoubleBufferedPreview write FDoubleBufferedPreview;
    {* Set this value to TRUE, if you wish from PreviewForm to be shown
       DoubleBuffered. }
    property PagePixelsSize: TSize read GetPagePixelsSize;
    {* Size of a page in screen pixels. }
    property Orientation: TPrinterOrientation read GetOrientation;
    {* Orientation of a Printer. }
    property PaperSize: TPaperSize read FPaperSize write SetPaperSize;
    {* Paper size type (psA4, psA3, ... psCustom). }
    property CustomPaperSize: TSize read FCustomPaperSize write SetCustomPaperSize;
    {* Custom paper size in millimeters. }
    property PageWidth: Integer read GetPageWidth;
    {* Paper width in Printer canvas pixels. }
    property PageHeight: Integer read GetPageHeight;
    {* Paper height in Printer canvas pixels. }
    property CurrentPage: TMF read GetCurrentPage;
    {* Current page metafile DC. Valid only while drawing the page. }
    property Printer: PPrinter read GetPrinter write SetPrinter;
    {* Printer object. }
    property PageTop: Boolean read FPageTop write SetPageTop;
    {* True, if current position is on top of current page. (It is set to
       True just after calling OnNewPage event, i.e. *after* printing top
       page colontitles). }
    property X: Integer read FX write SetX;
    {* Current X position. }
    property Y: Integer read FY write SetY;
    {* Current Y position. }
  public
    procedure AddBand( Band: PControl );
    {* Call this method to add a band. Band could be any control, not only
       created with NewBand or NewReportLabel etc. Before adding a band,
       change its contant as you wish (change Caption, adjust Frames, Color,
       Font, etc.) }
    procedure AddBandEx( Band: PControl; BandLayout: TBandLayout );
    {* Call this method to add a band with special aligning option. }
    procedure AddFooter( Band: PControl );
    {* Adds a footer band to a current page. It is possible to add several
       footers, in such case the first is added to the bottom, and all the
       follows above it. }
    procedure AddFooterEx( Band: PControl; BandLayout: TBandLayout );
    {* Adds a footer with special aligning option. }
    procedure AddRight( Band: PControl );
    {* Adds a band or a cell just right, without shifting current Y position
       onto a height of a Band, like in AddBand or AddBandEx. Calling
       AddRight ands AddRightEx several times it is possible to construct
       desired band from prepared cells dynamically. If there are no place
       for a new band between X position and right margin of the page, new
       band is added from the starting of the next horizontal band
       automatically. }
    procedure AddRightEx( Band: PControl; BandLayout: TBandLayout );
    {* Adds a band or a cell just right, and with additional layout options. }
    procedure NewPage;
    {* Forces new page. If called twice, empty page will be printed. }
    property Bottom: Integer read FBottom;
    {* Bottom available position (in screen pixels). Valid while drawing
       onto current page. }
    property PageCount: Integer read GetPageCount;
    {* Total number of pages. }
    property Pages[ Idx: Integer ]: TMF read GetPages;
    {* Access to pages metafiles DC. Valid while drawing pages. }
    property Images[ Idx: Integer ]: HENHMETAFILE read GetImages;
    {* Access to page metafiles handles. If a handle for a certain page
       is accessed, its metafile DC become unavailable. }
    procedure Print;
    {* Call this method to print all the pages. }
    procedure PrintPages( FromPage, ToPage: Integer );
    {* Call this method to print given pages range. }
    procedure Preview;
    {* Call this method to show preview non-modal. Be sure, that the Report
       object is existing while preview is active. }
    procedure PreviewModal;
    {* Call this method to show preview form modal. }
    procedure Abort;
    {* Call this method to stop current printing. }
    property Printing: Boolean read FPrinting;
    {* True, if pages are currently printing. }
    property Stage: Integer read FStage;
    {* If OnPrint event is called, this value 1 or 2 shows a stage of
       printing. In the first call of OnPrint event, it has value 1, in the
       second its value is 2. }
    property OnPrint: TOnEvent read FOnPrint write FOnPrint;
    {* If this event is assigned, perform adding all bands in this event
       handler. Please remember, that OnPrint is called twice. Be sure, that
       all your initializations made correctly for both stages. Mainly, this
       method is used to provide printing some data which depends on total
       pages count (e.g. to print Page 1 From 10. You should store total
       pages count after stage 1, and use this information on stage 2).
       Also, this event allows to repeat printing after showing Printer setup
       dialog in case when some settings are changed (page size, layout,
       margins, etc.) }
    property OnNewPage: TOnEvent read FOnNewPage write FOnNewPage;
    {* This event is called when new page is started (by any reason). You can
       add here page header or footers, if you wish. }
    property OnEndBand: TOnEvent read FOnEndBand write FOnEndBand;
    {* This event can be useful when bands are created dynamically from cells
       calling AddRight or AddRightEx. }
    function HeightAvailable: Integer;
    {* Pixels available vertically on current page (in screen pixels). If
       this value is not sufficient to add a band, new page is started. It
       is possible to check this value manually to ensure that a certain
       number of bands could be fit, and to force new page if you wish from
       some data to be located always together, e.g. subdetail title +
       column header + at least 1 band of subdetail data. }
    property DocumentName: String read FDocName write FDocName;
    {* Assign a name of your document here. This value is shown in spooler
       queue and helps to identify your report among other printing documents. }
    property ReplaceFontHeight0: Integer read FReplaceFontHeight0 write FReplaceFontHeight0;
    {* Change this value, if default value 18 pixels is not satisfying you.
       While adding a band, all its fonts with FontHeight=0 are replaced by this
       value to provide correct scaling onto Printer device. }
    property Margins: TMargins read FMargins write SetMargins;
    {* Margins in 0.01 millimeters. }
    property MarginsPrinterPixels: TMargins index 1 read GetMarginsPixels;
    {* Margins in Printer's pixels. }
    property MarginsScreenPixels: TMargins index 2 read GetMarginsPixels;
    {* Margins in screen pixels. }
  end;

  TFrame = ( frLeft, frTop, frRight, frBottom );
  {* Frames for special band control. }
  TFrames = set of TFrame;
  {* }

  TPaddings = packed record
  {* Paddings. }
    LeftPadding, TopPadding, RightPadding, BottomPadding: Integer;
  end;

const
  AllFrames: TFrames = [ frLeft, frTop, frRight, frBottom ];
  {* Use this constant to tell that all the frames are turned on. }

function NewReport: PReport;
{* Call this function to create report object. }
procedure NewPreviewForm( var PreviewObj: PPreviewObj; AParent: PControl );
{* This function is called automatically when Preview or PreviewModal method
   is called for TReport object. }

function NewBand( AParent: PControl; Frames: TFrames ): PControl;
{* Call this function to create special band control. It is very similar to
   a panel, and can contain other controls as children. }
function NewReportLabel( AParent: PControl; const Caption: String; Frames: TFrames ): PControl;
{* Call this function to create band label. It can be used along or as a
   child of a band. }
function NewWordWrapReportLabel( AParent: PControl; const Caption: String; Frames: TFrames ): PControl;
{* Like NewReportLabel, but with WordWrap. }

procedure SetPaddings( BandCtl: PControl; LeftPadding, TopPadding, RightPadding, BottomPadding: Integer );
{* Use this function to change band paddings. }

type
  TKOLReport = PReport;
  TKOLBand = PControl;
  TKOLReportLabel = PControl;

implementation

const TBFrst = 0;
      TBPrev = 1;
      TBNext = 2;
      TBLast = 3;
      TBPrnt = 4;
      TBSetu = 5;
      TBView = 6;
      TBExit = 7;

function GetProviderPrinter: PPrinter;
begin
  Result := Printer;
end;

function NewReport: PReport;
begin
  new( Result, Create );
  Result.FDocName := 'Report 1';
  Result.FDCPages := NewList;
  Result.FHDPages := NewList;
  Result.FCustomPaperSize.cx := 210;
  Result.FCustomPaperSize.cy := 270;
  Result.FReplaceFontHeight0 := -12;
  Result.FMargins := MakeRect( 500, 500, 500, 500 );
end;

procedure NewPreviewForm( var PreviewObj: PPreviewObj; AParent: PControl );
var Pn: PControl;
begin
  new( PreviewObj, Create );
  PreviewObj.Form := NewForm( AParent, 'Preview' ).SetSize( 600, 600 )
     .SetPosition( (GetSystemMetrics( SM_CXSCREEN ) - 600) div 2,
                (GetSystemMetrics( SM_CYSCREEN ) - 600) div 2 );
  {Brandys}
  PreviewObj.Options := [psdMargins,psdSamplePage,psdPaperControl,psdPrinterControl,psdWarning,psdHundredthsOfMillimeters,psdUseMargins,psdUseMinMargins];
  PreviewObj.PSD := NewPageSetupDialog(PreviewObj.Form,PreviewObj.Options);
  PreviewObj.PSD.SetMinMargins(500,500,500,500);
  PreviewObj.Form.Border := 0;
  Pn := NewPanel( PreviewObj.Form, esNone ).SetSize( 0, 25 ).SetAlign( caTop );
  PreviewObj.TB := NewToolbar( Pn, caNone, [ tboNoDivider ],
     THandle(-1), [ '<<', '<', '>', '>>', ' Print', 'Setup', '^View', 'Close' ],
     [ -1, -1, -1, -1, 14, -2 ] ).SetAlign( caLeft ).SetSize( 440, 0 );
  PreviewObj.TB.OnClick := PreviewObj.TBClick;
  PreviewObj.TB.OnTBDropDown := PreviewObj.TBDropDownViewMenu;
  NewMenu( PreviewObj.Form, 0, [ '' ], nil );
  PreviewObj.ViewMenu := NewMenu( PreviewObj.Form, 0,
                      [ '-!Fit &Height', '-!Fit &Width', '-!&1:1' ],
                      PreviewObj.TBViewMenuClick );
  PreviewObj.LB := NewLabel( Pn, '' ).SetAlign( caClient );
  PreviewObj.LB.TextAlign := taRight;
  PreviewObj.LB.VerticalAlign := vaCenter;
  PreviewObj.Form.OnShow := PreviewObj.AdjustButtons;
  PreviewObj.SB := NewScrollBoxEx( PreviewObj.Form, esLowered ).SetAlign( caClient );
  PreviewObj.PB := NewPaintBox( PreviewObj.SB );
  PreviewObj.PB.OnPaint := PreviewObj.PaintPage;

  //PreviewObj.TB.TBButtonVisible[ TBSetu ] := FALSE;
  PreviewObj.Form.OnResize := PreviewObj.ResizePreviewForm;
end;

type
  PFramesData = ^TFramesData;
  TFramesData = packed Record
    Frames: TFrames;
    Paddings: TPaddings;
  end;

procedure PaintFrames( Self_, Sender: PControl; DC: HDC );
var Br: HBrush;
    R: TRect;
  procedure FillFrame( X1, Y1, X2, Y2: Integer );
  begin
    if X2 <= X1 then Exit;
    if Y2 <= Y1 then Exit;
    FillRect( DC, MakeRect( X1, Y1, X2, Y2 ), Br );
  end;
var Data: PFramesData;
    W, H, B: Integer;
    Fmt: DWORD;
    OldFont: HFont;
    OldBk: Integer;
begin
  Data := Self_.CustomData;
  Br := CreateSolidBrush( Color2RGB( Self_.Font.Color ) );
  W := Self_.ClientWidth;
  H := Self_.ClientHeight;
  B := Self_.Border;
  R := Self_.ClientRect;
  if frLeft in Data.Frames then
  begin
    FillFrame( 0, 0, B, H );
    Inc( R.Left, B );
  end;
  if frTop in Data.Frames then
  begin
    FillFrame( 0, 0, W, B );
    Inc( R.Top, B );
  end;
  if frRight in Data.Frames then
  begin
    FillFrame( W - B, 0, W, H );
    Dec( R.Right, B );
  end;
  if frBottom in Data.Frames then
  begin
    FillFrame( 0, H - B, W, H );
    Dec( R.Bottom, B );
  end;
  DeleteObject( Br );

  Br := CreateSolidBrush( Color2RGB( Self_.Color ) );
  FillRect( DC, R, Br );
  Inc( R.Left, Data.Paddings.LeftPadding );
  Inc( R.Top,  Data.Paddings.TopPadding );
  Dec( R.Right, Data.Paddings.RightPadding );
  Dec( R.Bottom, Data.Paddings.BottomPadding );
  DeleteObject( Br );

  case Self_.TextAlign of
  taCenter: Fmt := DT_CENTER;
  taRight: Fmt := DT_RIGHT;
  else Fmt := DT_LEFT;
  end;
  case Self_.VerticalAlign of
  vaTop: Fmt := Fmt or DT_TOP;
  vaCenter: Fmt := Fmt or DT_VCENTER;
  vaBottom: Fmt := Fmt or DT_BOTTOM;
  end;
  if Self_.WordWrap then
    Fmt := Fmt or DT_WORDBREAK
  else
    Fmt := Fmt or DT_SINGLELINE;
  OldFont := SelectObject( DC, Self_.Font.Handle );

  OldBk := SetBkMode( DC, TRANSPARENT );
  DrawText( DC, PChar( Self_.Caption ), Length( Self_.Caption ), R, Fmt );
  SetBkMode( DC, OldBk );
  SelectObject( DC, OldFont );

end;

function NewBand( AParent: PControl; Frames: TFrames ): PControl;
var Data: PFramesData;
begin
  Result := NewPanel( AParent, esNone );
  Result.Color := clWhite;
  Result.Border := 1;
  Data := AllocMem( Sizeof( TFramesData ) );
  Result.CustomData := Data;
  Data.Frames := Frames;
  Data.Paddings.LeftPadding := 4;
  Data.Paddings.RightPadding := 4;
  Result.OnPaint := TOnPaint( MakeMethod( Result, @ PaintFrames ) );
  Result.Width := 400;
  Result.Height := 40;
  Result.fCommandActions.aAutoSzX := 12;
end;

procedure InitBandLabel( L: PControl; Frames: TFrames );
var Data: PFramesData;
begin
  L.Color := clWhite;
  L.Border := 1;
  Data := AllocMem( Sizeof( TFramesData ) );
  L.CustomData := Data;
  Data.Frames := Frames;
  Data.Paddings.LeftPadding := 4;
  Data.Paddings.RightPadding := 4;
  L.OnPaint := TOnPaint( MakeMethod( L, @ PaintFrames ) );
  L.fCommandActions.aAutoSzX := 12;
end;

function NewReportLabel( AParent: PControl; const Caption: String; Frames: TFrames ): PControl;
begin
  Result := NewLabel( AParent, Caption ).AutoSize( TRUE );
  InitBandLabel( Result, Frames );
end;

function NewWordWrapReportLabel( AParent: PControl; const Caption: String; Frames: TFrames ): PControl;
begin
  Result := NewWordWrapLabel( AParent, Caption ).AutoSize( TRUE );
  InitBandLabel( Result, Frames );
end;

procedure SetPaddings( BandCtl: PControl; LeftPadding, TopPadding, RightPadding, BottomPadding: Integer );
var Data: PFramesData;
    WasHPadding: Integer;
begin
  Data := BandCtl.CustomData;
  WasHPadding := Data.Paddings.LeftPadding + Data.Paddings.RightPadding;
  Data.Paddings.LeftPadding   := LeftPadding;
  Data.Paddings.TopPadding    := TopPadding;
  Data.Paddings.RightPadding  := RightPadding;
  Data.Paddings.BottomPadding := BottomPadding;
  BandCtl.fCommandActions.aAutoSzX := BandCtl.fCommandActions.aAutoSzX -
    WasHPadding + LeftPadding + RightPadding;
  if BandCtl.IsAutoSize then
    BandCtl.AutoSize( TRUE );
end;

{ TReport }

procedure TReport.Abort;
begin
  Clear;
  if Assigned( FPrinter ) then
  begin
    if Printer.Printing then
      Printer.Abort;
  end;
end;

procedure TReport.AddBand(Band: PControl);
begin
  AddBandEx( Band, blLeft );
end;

procedure TReport.AddBandEx(Band: PControl; BandLayout: TBandLayout);
var MF: TMF;
    OldW: Integer;
begin
  if FCurBandHeight > 0 then
  begin
    if not fNewBandHandling then
      if Assigned( OnEndBand ) then
      begin
        fNewBandHandling := TRUE;
        OnEndBand( @ Self );
        fNewBandHandling := FALSE;
      end;
    FX := MarginsScreenPixels.Left;
    FY := FY + FCurBandHeight;
  end;
  if Band.Height > HeightAvailable then
    NewPage;
  MF := CurrentPage;
  case BandLayout of
  blLeft:  FY := FY + PaintBand( MF, Band, X, Y );
  blRight: FY := FY + PaintBand( MF, Band, PagePixelsSize.cx - Band.Width, Y );
  blCenter: FY := FY + PaintBand( MF, Band, (PagePixelsSize.cx - Band.Width) div 2, Y );
  blExpandRight: begin
                   OldW := Band.Width;
                   try
                     Band.Width := PagePixelsSize.cx - MarginsScreenPixels.Right - X;
                     FY := FY + PaintBand( MF, Band, X, Y );
                   finally
                     Band.Width := OldW;
                   end;
                 end;
  end;
  FPageTop := FALSE;
  FCurBandHeight := 0;
end;

procedure TReport.AddFooter(Band: PControl);
begin
  AddFooterEx( Band, blLeft );
end;

procedure TReport.AddFooterEx(Band: PControl; BandLayout: TBandLayout);
var MF: TMF;
    OldW: Integer;
begin
  if Band.Height > HeightAvailable then
    NewPage;
  MF := CurrentPage;
  case BandLayout of
  blLeft:  FBottom := FBottom - PaintBand( MF, Band, 0, FBottom - Band.Height );
  blRight: FBottom := FBottom - PaintBand( MF, Band,
                      PagePixelsSize.cx - Band.Width, FBottom - Band.Height );
  blCenter: FBottom := FBottom - PaintBand( MF, Band,
                      (PagePixelsSize.cx - Band.Width) div 2, FBottom - Band.Height );
  blExpandRight: begin
                   OldW := Band.Width;
                   try
                     Band.Width := PagePixelsSize.cx -
                                MarginsScreenPixels.Left - MarginsScreenPixels.Right;
                     FBottom := FBottom - PaintBand( MF, Band, 0, FBottom - Band.Height );
                   finally
                     Band.Width := OldW;
                   end;
                 end;
  end;
end;

function TReport.AddPage: TMF;
var MF: TMF;
    R: TRect;
    DC0: HDC;
begin
  DC0 := GetDC( 0 );
  R := MakeRect( 0, 0,
       MulDiv(PagePixelsSize.cx, GetDeviceCaps(DC0, HORZSIZE)*100, GetDeviceCaps(DC0, HORZRES)),
       MulDiv(PagePixelsSize.cy, GetDeviceCaps(DC0, VERTSIZE)*100, GetDeviceCaps(DC0, VERTRES)) );

  MF := CreateEnhMetaFile( DC0, nil, @ R, '' );
  ReleaseDC( 0, DC0 );

  FDCPages.Add( Pointer( MF ) );
  Result := MF;
  FPageTop := TRUE;
  FBottom := PagePixelsSize.cy - MarginsScreenPixels.Bottom;
  if not fNewPageHandling then
    if Assigned( OnNewPage ) then
    begin
      fNewPageHandling := TRUE;
      OnNewPage( @ Self );
      fNewPageHandling := FALSE;
    end;
end;

procedure TReport.AddRight(Band: PControl);
begin
  AddRightEx( Band, blLeft );
end;

procedure TReport.AddRightEx(Band: PControl; BandLayout: TBandLayout);
var MF: TMF;
    OldW: Integer;
begin
  if Band.Height > HeightAvailable then
    NewPage;
  MF := CurrentPage;
  if Band.Width > PagePixelsSize.cx - MarginsScreenPixels.Right - X then
  begin
    if not fNewBandHandling then
      if Assigned( OnEndBand ) then
      begin
        fNewBandHandling := TRUE;
        OnEndBand( @ Self );
        fNewBandHandling := FALSE;
      end;
    FX := MarginsScreenPixels.Left;
    FY := FY + FCurBandHeight;
    FCurBandHeight := 0;
  end;
  case BandLayout of
  blLeft:  PaintBand( MF, Band, X, Y );
  blRight: PaintBand( MF, Band, X + PagePixelsSize.cx - Band.Width, Y );
  blCenter: PaintBand( MF, Band, X + (PagePixelsSize.cx - X - Band.Width) div 2, Y );
  blExpandRight: begin
                   OldW := Band.Width;
                   try
                     Band.Width := PagePixelsSize.cx - MarginsScreenPixels.Right - X;
                     PaintBand( MF, Band, X, Y );
                   finally
                     Band.Width := OldW;
                   end;
                 end;
  end;
  FX := X + Band.Width;
  if FCurBandHeight < Band.Height then
    FCurBandHeight := Band.Height;
  FPageTop := FALSE;
end;

procedure TReport.Clear;
begin
  if FPreviewForm <> nil then
    FPreviewForm.Form.Free;
  ClearPages;
end;

destructor TReport.Destroy;
begin
  Clear;
  FDCPages.Free;
  FHDPages.Free;
  FDocName := '';
  inherited;
end;

procedure TReport.DoPreview;
begin
  if PageCount = 0 then Exit;
  PreviewForm.Form.DoubleBuffered := DoubleBufferedPreview;
  PreviewForm.FReport := @ Self;
  PreviewForm.Form.Caption := FDocName;
  PreviewForm.Form.Show;
end;

procedure TReport.DoPreviewModal;
begin
  if PageCount = 0 then Exit;
  PreviewForm.Form.DoubleBuffered := DoubleBufferedPreview;
  PreviewForm.FReport := @ Self;
  PreviewForm.Form.Caption := FDocName;
  PreviewForm.Form.ShowModal;
  FPreviewForm.Form.Free;
  FPreviewForm := nil;
end;

procedure TReport.DoPrint;
begin
  PrintPages( 0, PageCount-1 );
end;

procedure TReport.DoPrintPreview(Proc: TObjectMethod);
begin
  if Printing then Abort;
  if Assigned( FOnPrint ) then
  begin
    Clear;
    FStage := 1;
    FOnPrint( @ Self );
    if PageCount = 0 then Exit;
    Clear;
    FStage := 2;
    FOnPrint( @ Self );
  end;
  Proc;
end;

function TReport.GetCurrentPage: TMF;
begin
  if PageCount = 0 then
    Result := AddPage
  else
    Result := Pages[ PageCount-1 ];
end;

function TReport.GetOrientation: TPrinterOrientation;
begin
  Result := Printer.Orientation;
end;

function TReport.GetPageHeight: Integer;
begin
  GetPageWidthHeight;
  Result := FPageHeight;
end;

function TReport.GetPagePixelsSize: TSize;
var I: Integer;
    P: TPoint;
    DC0: HDC;
begin
  if (FPagePixelsSize.cx = 0) or (FPagePixelsSize.cy = 0) then
  begin
    case PaperSize of
    psA3: P := MakePoint( 297, 420 );
    psA4: P := MakePoint( 210, 297 );
    psA5: P := MakePoint( 148, 210 );
    psA6: P := MakePoint( 105, 148 );
    psLetter: P := MakePoint( 216, 280 );
    else      P := MakePoint( FCustomPaperSize.cx, FCustomPaperSize.cy );
    end;
    DC0 := GetDC( 0 );
    FPagePixelsSize.cx := Round( (P.x * 0.039370) * GetDeviceCaps( DC0, LOGPIXELSX ) );
    FPagePixelsSize.cy := Round( (P.y * 0.039370) * GetDeviceCaps( DC0, LOGPIXELSY ) );
    ReleaseDC( 0, DC0 );
  end;
  Result := FPagePixelsSize;
  if Orientation = poLandscape then
  begin
    I := Result.cx;
    Result.cx := Result.cy;
    Result.cy := I;
  end;
end;

function TReport.GetPageCount: Integer;
begin
  Result := FDCPages.Count;
end;

function TReport.GetPageWidth: Integer;
begin
  GetPageWidthHeight;
  Result := FPageWidth;
end;

procedure TReport.GetPageWidthHeight;
begin
  if (FPageWidth <> 0) and (FPageHeight <> 0) then Exit;
  if Printer.Printing then
  begin
    FPageWidth := Printer.PageWidth;
    FPageHeight := Printer.PageHeight;
  end
    else
  begin
    Printer.BeginDoc;
    TRY
      FPageWidth := Printer.PageWidth;
      FPageHeight := Printer.PageHeight;
    FINALLY
      Printer.Abort;
    END;
  end;
end;

function TReport.GetPreviewForm: PPreviewObj;
begin
  if FPreviewForm = nil then
  begin
    NewPreviewForm( FPreviewForm, Applet );
    FPreviewForm.FReport := @ Self;
  end;
  Result := FPreviewForm;
end;

function TReport.GetPrinter: PPrinter;
begin
  if FPrinter = nil then
    FPrinter := GetProviderPrinter;
  Result := FPrinter;
end;

function TReport.HeightAvailable: Integer;
begin
  Result := FBottom - FY;
end;

procedure TReport.NewPage;
begin
  FY := MarginsScreenPixels.Top;
  FX := MarginsScreenPixels.Left;
  AddPage;
end;

function TReport.PaintBand(MF: TMF; Band: PControl; Xpos, Ypos: Integer): Integer;

  procedure PaintBandWithChildren( Band: PControl; DC: HDC );
  var I: Integer;
      C: PControl;
      P0, P: TPoint;
      R0, R1, R2: TRect;
      Save: Integer;
      FontHeight0Replaced: Boolean;
  begin
    FontHeight0Replaced := FALSE;
    if (ReplaceFontHeight0 <> 0) and (Band.Font.FontHeight = 0) then
    begin
      FontHeight0Replaced := TRUE;
      Band.Font.FontHeight := ReplaceFontHeight0;
    end;
    Band.Perform( WM_PRINT, DC, PRF_NONCLIENT );
    GetClientRect( Band.Handle, R0 );
    P0 := MakePoint( 0, 0 );
    ClientToScreen( Band.Handle, P0 );
    GetWindowOrgEx( DC, P );
    GetWindowRect( Band.Handle, R1 );
    OffsetRect( R0, P0.x - R1.Left, P0.y - R1.Top );
    SetWindowOrgEx( DC, P.x - (P0.x - R1.Left), P.y - (P0.y - R1.Top), @ P );
    IntersectClipRect( DC, R0.Left, R0.Top, R0.Right, R0.Bottom );
    Band.Perform( WM_ERASEBKGND, DC, 0 );
    Band.Perform( WM_PAINT, DC, 0 );
    GetWindowRect( Band.Handle, R1 );
    for I := 0 to Band.ChildCount-1 do
    begin
      Save := SaveDC( DC );
      C := Band.Children[ I ];
      GetWindowRect( C.Handle, R2 );
      SetWindowOrgEx( DC, P.x - (R2.Left - R1.Left), P.y - (R2.Top - R1.Top), nil );
      IntersectClipRect( DC, 0, 0, R2.Right - R2.Left, R2.Bottom - R2.Top );
      PaintBandWithChildren( C, DC );
      RestoreDC( DC, Save );
    end;
    if FontHeight0Replaced then
      Band.Font.FontHeight := 0;
  end;

var OldParent: PControl;
    WasVisible: Boolean;
    WasBR: TRect;
    P: TPoint;
    Save: Integer;

begin
  OldParent := Band.Parent;
  OldParent.CreateWindow;
  WasVisible := Band.Visible;
  WasBR := Band.BoundsRect;
  try
    Band.Visible := FALSE;
    Band.Parent := Applet;
    Band.Top := Applet.Height;
    SetParent( Band.GetWindowHandle, Applet.Handle );
    Band.Visible := TRUE;

    Save := SaveDC( MF );
    GetWindowOrgEx( MF, P );
    SetWindowOrgEx( MF, P.x - Xpos, P.y - Ypos, nil );

    PaintBandWithChildren( Band, MF );

    SetWindowOrgEx( MF, P.x, P.y, nil );
    RestoreDC( MF, Save );

  finally
    Band.Visible := FALSE;
    Band.Parent := OldParent;
    SetParent( Band.Handle, OldParent.Handle );
    Band.BoundsRect := WasBR;
    Band.Visible := WasVisible;
  end;
  Result := Band.Height;
end;

procedure TReport.Preview;
begin
  DoPrintPreview( DoPreview );
end;

procedure TReport.PreviewModal;
begin
  DoPrintPreview( DoPreviewModal );
end;

procedure TReport.Print;
begin
  DoPrintPreview( DoPrint );
end;

function TReport.ScaleX(W: Integer): Integer;
begin
  Result := Round( W * Printer.PageWidth / PagePixelsSize.cx );
end;

function TReport.ScaleY(H: Integer): Integer;
begin
  Result := Round( H * Printer.PageHeight / PagePixelsSize.cy );
end;

procedure TReport.SetCustomPaperSize(const Value: TSize);
const PapSizes: array[ TPaperSize, 1..2] of Integer = ( ( 210, 297 ),
      ( 148, 210 ), ( 105, 148 ), ( 297, 420 ), (216, 280), ( 0, 0 ) );
var PSidx: TPaperSize;
begin
  FCustomPaperSize := Value;
  for PSidx := Low( TPaperSize ) to Pred( High( TPaperSize ) ) do
  begin
    if (PapSizes[ PSidx ][ 1 ] = Value.cx) and
       (PapSizes[ PSidx ][ 2 ] = Value.cy) then
    begin
      PaperSize := PSidx;
      exit;
    end;
  end;
  PaperSize := psCustom;
end;

procedure TReport.SetPageTop(const Value: Boolean);
begin
  FPageTop := Value;
end;

procedure TReport.SetPaperSize(const Value: TPaperSize);
begin
  if FPaperSize = Value then Exit;
  if FPrinting then Abort;
  FPaperSize := Value;
end;

procedure TReport.SetPreviewForm(const Value: PPreviewObj);
begin
  if FPreviewForm = Value then Exit;
  if FPreviewForm <> nil then
    FPreviewForm.Form.Free;
  FPreviewForm := Value;
end;

procedure TReport.SetPrinter(const Value: PPrinter);
begin
  if FPrinter = Value then Exit;
  if FPrinting then Abort;
  FPrinter := Value;
  FPageWidth := 0;
  FPageHeight := 0;
end;

procedure TReport.SetX(const Value: Integer);
begin
  if FX = Value then Exit;
  FX := Value;
end;

procedure TReport.SetY(const Value: Integer);
begin
  if FY = Value then Exit;
  FY := Value;
  FCurBandHeight := 0;
end;

function TReport.GetPages(Idx: Integer): TMF;
begin
  Result := TMF( FDCPages.Items[ Idx ] );
end;

function TReport.GetImages(Idx: Integer): HENHMETAFILE;
begin
  while FHDPages.Count <= Idx do
    FHDPages.Add( nil );
  if FHDPages.Items[ Idx ] = nil then
  begin
    FHDPages.Items[ Idx ] := Pointer( CloseEnhMetafile( Pages[ Idx ] ) );
    FDCPages.Items[ Idx ] := nil;
  end;
  Result := HENHMETAFILE( FHDPages.Items[ Idx ] );
end;

procedure TReport.PrintPages(FromPage, ToPage: Integer);
var I: Integer;
    MF: HENHMETAFILE;
    PrintingStarted: Boolean;
    N: Integer;
begin
  PrintingStarted := FALSE;
  TRY
    for I := FromPage to ToPage do
    begin
      MF := Images[ I ];
      if I = 0 then
      begin
        Printer.Title := FDocName;
        Printer.BeginDoc;
        PrintingStarted := TRUE;
      end;
        N := 1;
        while PageWidth > PagePixelsSize.cx * N do
          Inc( N );
      PlayEnhMetaFile( Printer.Canvas.Handle, MF,
                       MakeRect( 0, 0, PageWidth-1, PageHeight-1 ) );

      if I < ToPage then
        Printer.NewPage;
    end;
  FINALLY
    if PrintingStarted then
      Printer.EndDoc;
  END;
end;

procedure TReport.ClearPages;
var I: Integer;
begin
  for I := PageCount-1 downto 0 do
    DeleteEnhMetaFile( Images[ I ] );
  FDCPages.Clear;
  FHDPages.Clear;
  FY := MarginsScreenPixels.Top;
  FX := MarginsScreenPixels.Left;
  FPagePixelsSize.cx := 0; // force recalculation of Page size
end;

procedure TReport.SetMargins(const Value: TMargins);
begin
  if (fMargins.Left = Value.Left) and
     (fMargins.Top = Value.Top) and
     (fMargins.Right = Value.Right) and
     (fMargins.Bottom = Value.Bottom) then Exit;
  if FPrinting then Abort;
  FMargins := Value;
end;

function TReport.GetMarginsPixels( const Index: Integer ): TMargins;
var DC: HDC;
begin
  if Index = 1 then DC := Printer.Canvas.Handle
  else DC := GetDC( 0 );
  Result.Left := Round( Margins.Left / 1000 / 2.55 * GetDeviceCaps( DC, LOGPIXELSX ) );
  Result.Right := Round( Margins.Right / 1000 / 2.55 * GetDeviceCaps( DC, LOGPIXELSX ) );
  Result.Top := Round( Margins.Top / 1000 / 2.55 * GetDeviceCaps( DC, LOGPIXELSY ) );
  Result.Bottom := Round( Margins.Bottom / 1000 / 2.55 * GetDeviceCaps( DC, LOGPIXELSY ) );
  if Index <> 1 then
    ReleaseDC( 0, DC );
end;

{ TPreviewObj }

procedure TPreviewObj.AdjustButtons( Sender: PObj );
begin
  TB.TBButtonEnabled[ TBFrst ] := FCurPage > 0;
  TB.TBButtonEnabled[ TBPrev ] := FCurPage > 0;
  TB.TBButtonEnabled[ TBNext ] := FCurPage < PageCount - 1;
  TB.TBButtonEnabled[ TBLast ] := FCurPage < PageCount - 1;
  TB.TBButtonEnabled[ TBPrnt ] := PageCount > 0;
  {$IFDEF use_MHPRINTER}
  TB.TBButtonEnabled[ TBExit ] := TRUE;
  {$ENDIF}
  if PageCount = 0 then
    LB.Caption := ''
  else
    LB.Caption := 'Page ' + Int2Str( FCurPage + 1 ) + ' from ' + Int2Str( PageCount );
end;

procedure TPreviewObj.AdjustFitMode;
var K: Double;
begin
  if PageCount = 0 then Exit;
  case FFitMode of
  0: begin // fit Height
       PB.Height := SB.ClientHeight;
       K := FReport.PagePixelsSize.cx / FReport.PagePixelsSize.cy;
       PB.Width := Round( K * SB.ClientHeight );
       SetScrollPos( SB.Handle, SB_VERT, 0, TRUE );
     end;
  1: begin // fit Width
       PB.Width := SB.ClientWidth;
       K := FReport.PagePixelsSize.cy / FReport.PagePixelsSize.cx;
       PB.Height := Round( K * SB.ClientWidth );
     end;
  2: begin // 1:1
       PB.Width := FReport.PagePixelsSize.cx;
       PB.Height := FReport.PagePixelsSize.cy;
     end;
  end;
end;

destructor TPreviewObj.Destroy;
begin
  FBuf.Free;
  PSD.Free;{Brandys}
  inherited;
end;

function TPreviewObj.PageCount: Integer;
begin
  Result := FReport.FDCPages.Count;
end;

procedure TPreviewObj.PaintPage(Sender: PControl; DC: HDC);
var MF: HENHMETAFILE;
    Tmp: PBitmap;
    R: TRect;
begin
  if FCurPage >= PageCount then Exit;
  MF := FReport.Images[ FCurPage ];
  AdjustFitMode;
  {if (PB.Width = FReport.PagePixelsSize.cx) and
     (PB.Height = FReport.PagePixelsSize.cy) then
    PlayEnhMetaFile( DC, MF, MakeRect( 0, 0, PB.Width, PB.Height ) )
  else}
  begin
    if (FBufPage <> FCurPage) or (FBuf = nil) or
       (FBuf.Width <> PB.ClientWidth) or (FBuf.Height <> PB.ClientHeight) then
    begin
      FBuf.Free;
      FBufPage := FCurPage;
      FBuf := NewDIBBitmap( PB.ClientWidth, PB.ClientHeight, pf24bit );
      FBuf.Canvas.Brush.Color := clWhite;
      FBuf.Canvas.FillRect( MakeRect( 0, 0, FBuf.Width, FBuf.Height ) );
      SetStretchBltMode( FBuf.Canvas.Handle, HALFTONE );
      SetBrushOrgEx( FBuf.Canvas.Handle, 0, 0, nil );
      {R := MakeRect( FReport.MarginsScreenPixels.Left,
                     FReport.MarginsScreenPixels.Top,
                     FBuf.Width-1 - FReport.MarginsScreenPixels.Right,
                     FBuf.Height-1 - FReport.MarginsScreenPixels.Bottom );}
      R := MakeRect( 0, 0, FBuf.Width-1, FBuf.Height-1 );
      if FBuf.Width >= FReport.PagePixelsSize.cx then
        PlayEnhMetaFile( FBuf.Canvas.Handle, MF, R )
      else
      begin
        Tmp := NewDIBBitmap( FReport.PagePixelsSize.cx, FReport.PagePixelsSize.cy, pf24bit );
        Tmp.Canvas.Brush.Color := clWhite;
        Tmp.Canvas.FillRect( MakeRect( 0, 0, Tmp.Width, Tmp.Height ) );
        PlayEnhMetaFile( Tmp.Canvas.Handle, MF, MakeRect( 0, 0, Tmp.Width-1, Tmp.Height-1 ) );
        Inc( R.Right ); Inc( R.Bottom );
        Tmp.StretchDraw( FBuf.Canvas.Handle, R );
        Tmp.Free;
      end;
    end;
    FBuf.Draw( DC, 0, 0 );
  end;
end;

{$IFDEF use_MHPRINTER}
procedure TPreviewObj.PrinterSetup;
begin
  ShowMessage( 'Not implementer.' );
end;
{$ELSE}
procedure TPreviewObj.PrinterSetup;
var 
    Orientation: TPrinterOrientation;
    PgSz: TSize;
    M: TRect;
begin
  Orientation := Printer.Orientation;
  PgSz.cx := Printer.PageWidth;
  PgSz.cy := Printer.PageHeight;
  if not Assigned( FReport.OnPrint ) then
    Options := Options - [ psdOrientation ];
  if PSD = nil then
    PSD := NewPageSetupDialog( Form, Options );
  PSD.SetMargins( FReport.FMargins.Left, FReport.FMargins.Top,
                  FReport.FMargins.Right, FReport.FMargins.Bottom );
  if PSD.Execute then
  begin
    Printer.Assign(PSD.Info);//assign selected options to printer DC
    M := PSD.GetMargins;
    if Assigned( FReport.OnPrint ) then
    if (Printer.Orientation <> Orientation) or
       (Printer.PageWidth <> PgSz.cx) or
       (Printer.PageHeight <> PgSz.cy) or
       not CompareMem( @ M, @ FReport.FMargins, Sizeof( M ) ) then
    begin
      FReport.FMargins := M;
      FCurPage := 0;
      FReport.ClearPages;
      PgSz.cx := GetDeviceCaps( Printer.Canvas.Handle, HORZSIZE );
      PgSz.cy := GetDeviceCaps( Printer.Canvas.Handle, VERTSIZE );
      FReport.CustomPaperSize := PgSz;
      FReport.OnPrint( FReport );
    end;
    Printer.AssignMargins(M,mgMillimeters);
  end;
end;
{$ENDIF}

procedure TPreviewObj.PrintAllPages;
begin
  FReport.DoPrint;
end;

procedure TPreviewObj.ResizePreviewForm(Sender: PObj);
begin
  AdjustFitMode;
end;

procedure TPreviewObj.SetCurPage(const Value: Integer);
begin
  FCurPage := Value;
  AdjustButtons( @ Self );
end;

procedure TPreviewObj.SetFitMode(const Value: Integer);
begin
  if FFitMode = Value then Exit;
  FFitMode := Value;
  AdjustFitMode;
  PB.Invalidate;
end;

procedure TPreviewObj.TBClick(Sender: PObj);
begin
  case PControl(Sender).CurIndex of
  TBFrst: { <<  } FCurPage := 0;
  TBPrev: {  <  } if FCurPage > 0 then Dec( FCurPage );
  TBNext: {  >  } if FCurPage < PageCount - 1 then Inc( FCurPage );
  TBLast: { >>  } FCurPage := PageCount - 1;
  TBPrnt: {Print} PrintAllPages;
  TBSetu: {Setup} PrinterSetup;
  TBView: {View}  TBDropDownViewMenu( TB );
  TBExit: {Close} begin Form.Close; Exit; end;
  end;
  AdjustButtons( @ Self );
end;

procedure TPreviewObj.TBDropDownViewMenu(Sender: PObj);
var R: TRect;
begin
  R := TB.TBButtonRect[ TBView ];
  R.Top := R.Bottom;
  R.TopLeft := TB.Client2Screen( R.TopLeft );
  ViewMenu.RadioCheck( FitMode );
  ViewMenu.Popup( R.Left, R.Top );
end;

procedure TPreviewObj.TBViewMenuClick(Sender: PMenu; Item: Integer);
begin
  FitMode := Item;
end;

end.
