unit KOLPageSetupDialog;
{* Page setup dialog.
|<br>
Ver 1.5 (26-10-2002)
|<br>
[+] starting from this version previous settings selected by user are preserved
during subsequent calls to Execute
|<br>
[+] added AlwaysReset property to allow reseting dialog settings to default values
|<br>
|<br>
Notes:
|<hr>
1. PageSetup dialog preserve margins info but only when psdMargins is used with
coniunction to psdUseMargins (and psdUseMinMargins if You wish).In other cases all
 settings are preserved but not margins.
 |<br>
2. Setting are preserved only during existence of dialog (when dialog is destroyed
and recreated all settings are lost)
|<br>
|<br>
Ver 1.4
|<br>
Now the information about selected printer can be transferred to TKOLPrinter.
If DC is needed directly use new psdReturnDC option.
|<br>
Note :page setup dialog replace print dialog marked as obsolete by Microsoft.
|<br> Bad news is that this dialog do not return printer DC. In TKOLPageSetupDialog
DC is constructed from returned values, but margins should be processed by application.
(or assigned to TKOLPrinter ;-) 17-09-2002 B.Brandys)
|<br>
Note:
|<br>
- when custom page is selected ,DC is empty (bug?)
|<br>
- application must process margins (but it is simple as AssignMargins to TKOlPrinter ;-)

 }

interface

uses Windows, Messages, KOL, KOLPrintCommon;


const

  DN_DEFAULTPRN = $0001; {default printer }
  HELPMSGSTRING = 'commdlg_help';

//******************************************************************************
//  PageSetupDlg options
//******************************************************************************

   PSD_DEFAULTMINMARGINS             = $00000000;
   PSD_INWININIINTLMEASURE           = $00000000;
   PSD_MINMARGINS                    = $00000001;
   PSD_MARGINS                       = $00000002;
   PSD_INTHOUSANDTHSOFINCHES         = $00000004;
   PSD_INHUNDREDTHSOFMILLIMETERS     = $00000008;
   PSD_DISABLEMARGINS                = $00000010;
   PSD_DISABLEPRINTER                = $00000020;
   PSD_NOWARNING                     = $00000080;
   PSD_DISABLEORIENTATION            = $00000100;
   PSD_RETURNDEFAULT                 = $00000400;
   PSD_DISABLEPAPER                  = $00000200;
   PSD_SHOWHELP                      = $00000800;
   PSD_ENABLEPAGESETUPHOOK           = $00002000;
   PSD_ENABLEPAGESETUPTEMPLATE       = $00008000;
   PSD_ENABLEPAGESETUPTEMPLATEHANDLE = $00020000;
   PSD_ENABLEPAGEPAINTHOOK           = $00040000;
   PSD_DISABLEPAGEPAINTING           = $00080000;
   PSD_NONETWORKBUTTON               = $00200000;

//******************************************************************************
//  Error constants
//******************************************************************************


  CDERR_DIALOGFAILURE    = $FFFF;
  CDERR_GENERALCODES     = $0000;
  CDERR_STRUCTSIZE       = $0001;
  CDERR_INITIALIZATION   = $0002;
  CDERR_NOTEMPLATE       = $0003;
  CDERR_NOHINSTANCE      = $0004;
  CDERR_LOADSTRFAILURE   = $0005;
  CDERR_FINDRESFAILURE   = $0006;
  CDERR_LOADRESFAILURE   = $0007;
  CDERR_LOCKRESFAILURE   = $0008;
  CDERR_MEMALLOCFAILURE  = $0009;
  CDERR_MEMLOCKFAILURE   = $000A;
  CDERR_NOHOOK           = $000B;
  CDERR_REGISTERMSGFAIL  = $000C;
  PDERR_PRINTERCODES     = $1000;
  PDERR_SETUPFAILURE     = $1001;
  PDERR_PARSEFAILURE     = $1002;
  PDERR_RETDEFFAILURE    = $1003;
  PDERR_LOADDRVFAILURE   = $1004;
  PDERR_GETDEVMODEFAIL   = $1005;
  PDERR_INITFAILURE      = $1006;
  PDERR_NODEVICES        = $1007;
  PDERR_NODEFAULTPRN     = $1008;
  PDERR_DNDMMISMATCH     = $1009;
  PDERR_CREATEICFAILURE  = $100A;
  PDERR_PRINTERNOTFOUND  = $100B;
  PDERR_DEFAULTDIFFERENT = $100C;


type



  { Structure for PageSetupDlg function }
  PtagPSD = ^tagPSD;
  tagPSD  = packed record
  {* Structure for PageSetupDlg function }
    lStructSize: DWORD;
    hwndOwner: HWND;
    hDevMode: HGLOBAL;
    hDevNames: HGLOBAL;
    Flags: DWORD;
    ptPaperSize: TPoint;
    rtMinMargin: TRect;
    rtMargin: TRect;
    hInstance: HINST;
    lCustData: LPARAM;
    lpfnPageSetupHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpfnPagePaintHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpPageSetupTemplateName: PAnsiChar;
    hPageSetupTemplate: HGLOBAL;
  end;










function PageSetupDlg(var PgSetupDialog: tagPSD): BOOL; stdcall;external 'comdlg32.dll'  name 'PageSetupDlgA';

function CommDlgExtendedError():DWORD;stdcall; external 'comdlg32.dll'  name 'CommDlgExtendedError';
















//////////////////////////////////////////////////////
//                                                  //
//  Page setup dialog.                              //
//                                                  //
//////////////////////////////////////////////////////



type
TPageSetupOption = (psdMargins,psdOrientation,psdSamplePage,psdPaperControl,psdPrinterControl,
psdHundredthsOfMillimeters,psdThousandthsOfInches,psdUseMargins,psdUseMinMargins,psdWarning,psdHelp,psdReturnDC);
TPageSetupOptions = Set of TPageSetupOption;
{* Options:
|<br>
|<ul><li><b>psdMargins</b> : allow user to select margins </li>
|<li><b>psdOrientation</b> : allow user to select page orientation</li>
|<li><b>psdSamplePage</b> : draw contents of the sample page</li>
|<li><b>psdPaperControl</b> : allow paper size control </li>
|<li><b>psdPrinterControl</b> : allow user to select printer </li>
|<li><b>psdHundredthsOfMillimeters</b> : set scale to hundredths of millimeters for margins and paper size,on return indicate selected scale</li>
|<li><b>psdThousandthsOfInches</b> : set scale to thousandths of inches for margins and paper size,on return indicate selected scale</li>
|<li><b>psdUseMargins,psdUseMinMargins</b> : use suggested margins </li>
|<li><b>psdWarning</b> : generate warning when there is no default printer </li>
|<li><b>psdHelp</b> : add help button to dialog, application must process HELPMSGSTRING message</li>
|<li><b>psdReturnDC</b> : returns DC of selected printer if required </li>
|</ul>
 }

  PPageSetupDlg       = ^TPageSetupDlg;
  TKOLPageSetupDialog = PPageSetupDlg;
  TPageSetupDlg       = object(TObj)
  {*}
  private
    { Private declarations }
    fhDC       : HDC;
    fAdvanced  : WORD;
    ftagPSD    : tagPSD;
    fOptions   : TPageSetupOptions;
    fDevNames : PDevNames;
    PrinterInfo : TPrinterInfo;
    fAlwaysReset : Boolean;
  protected
    function GetError : Integer;
    {*}
    { Protected declarations }
  public
    { Public declarations }
    destructor Destroy; virtual;
    property Error     : Integer read GetError;
    {* Returns extended error (which is not the same as error returned from GetLastError)
    |<br>
    Note : if You want error descriptions each error is defined in this file source
    }
    function GetPaperSize :  TPoint;
    {*}
    procedure SetMinMargins(Left,Top,Right,Bottom: Integer);
    {*}
    function GetMinMargins : TRect;
    {*}
    procedure SetMargins(Left,Top,Right,Bottom : Integer);
    {*}
    function GetMargins : TRect;
    {*}
    property Options  : TPageSetupOptions read fOptions write fOptions;
    {* Set of dialog options}
    property AlwaysReset : Boolean read fAlwaysReset write fAlwaysReset;
    {* If is set to TRUE pagesetup dialog is always reset to default printer and options
     (default printer driver and A4 page format). By default this is set to FALSE which
     means that options selected by user are preserved}
    property DC       : hDC read fhDC;
    {*}
    function Execute : Boolean;
    {*}
    function Info : PPrinterInfo;
    {* Return info about selected printer.Can be used by TKOLPrinter}
    {These below are usefull in Advanced mode }
    property tagPSD    : tagPSD read ftagPSD write ftagPSD;
    {* For low-level access}
    property Advanced : WORD read fAdvanced write fAdvanced;
    {* 0 := default
     |<br>
     1 := You must assign properties to tagPSD.Flags by yourself
     |<br>
     2 := You can create DEVNAMES and DEVMODE structures and assign to object tagPSD
            (but also You must free previous tagPSD.hDevMode and tagPSD.hDevNames)
            }
    procedure FillOptions(DlgOptions : TPageSetupOptions);
    {* }
    procedure Prepare;
    {* Destroy of previous allocated DEVMODE , DEVNAMES and DC. Is always invoked on destroy and in Execute method (when Advanced :=0 of course).}
  end;

function NewPageSetupDialog(AOwner : PControl; Options : TPageSetupOptions) : PPageSetupDlg;
{* Global function for page setup dialog}

implementation




//////////////////////////////////////////////////////
//                                                  //
//  Page setup dialog (implementation)              //
//                                                  //
//////////////////////////////////////////////////////





function NewPageSetupDialog(AOwner : PControl; Options : TPageSetupOptions) : PPageSetupDlg;
begin
    New(Result,Create);
    FillChar(Result.ftagPSD,sizeof(tagPSD),0);
    Result.ftagPSD.hWndOwner := AOwner.GetWindowHandle;
    Result.ftagPSD.hInstance := hInstance;
    Result.fOptions := Options;
    Result.fAdvanced :=0;
    Result.fAlwaysReset := false;
    Result.fhDC := 0;
end;


destructor TPageSetupDlg.Destroy;
begin
    Prepare;
    if (ftagPSD.hDevMode<>0) then  GlobalFree(ftagPSD.hDevMode);
    if (ftagPSD.hDevNames<>0) then GlobalFree(ftagPSD.hDevNames);
    inherited;
end;

procedure TPageSetupDlg.Prepare;
begin
    if ftagPSD.hDevMode <> 0 then
    begin
    GlobalUnlock(ftagPSD.hDevMode);
    if fAlwaysReset then
      begin
        GlobalFree(ftagPSD.hDevMode);
        ftagPSD.hDevMode :=0;
      end;
    end;
    if ftagPSD.hDevNames <> 0 then
    begin
    GlobalUnlock(ftagPSD.hDevNames);
    if fAlwaysReset then
      begin
        GlobalFree(ftagPSD.hDevNames);
        ftagPSD.hDevNames :=0;
      end;
    end;
    if fhDC <> 0 then
    	begin
    	DeleteDC(fhDC);
    	fhDC :=0;
    	end;
end;


procedure TPageSetupDlg.FillOptions(DlgOptions : TPageSetupOptions);
begin
  ftagPSD.Flags := PSD_DEFAULTMINMARGINS;
  { Disable some parts of PageSetup window }
  if not (psdMargins in DlgOptions) then Inc(ftagPSD.Flags, PSD_DISABLEMARGINS);
  if not (psdOrientation in DlgOptions) then Inc(ftagPSD.Flags, PSD_DISABLEORIENTATION);
  if not (psdSamplePage in DlgOptions) then Inc(ftagPSD.Flags, PSD_DISABLEPAGEPAINTING);
  if not (psdPaperControl in DlgOptions) then Inc(ftagPSD.Flags,PSD_DISABLEPAPER);
  if not (psdPrinterControl in DlgOptions) then inc(ftagPSD.Flags,PSD_DISABLEPRINTER);
  { Process HELPMSGSTRING message. Note : AOwner control must register and
  process this message.}
  if psdHelp in DlgOptions then Inc(ftagPSD.Flags, PSD_SHOWHELP);
  { Disable warning if there is no default printer }
  if not (psdWarning in DlgOptions) then Inc(ftagPSD.Flags, PSD_NOWARNING);
  if psdHundredthsOfMillimeters in DlgOptions then Inc(ftagPSD.Flags,PSD_INHUNDREDTHSOFMILLIMETERS);
  if psdThousandthsOfInches in DlgOptions then Inc(ftagPSD.Flags,PSD_INTHOUSANDTHSOFINCHES);
  if psdUseMargins in Dlgoptions then Inc(ftagPSD.Flags,PSD_MARGINS);
  if psdUseMinMargins in DlgOptions then Inc(ftagPSD.Flags,PSD_MINMARGINS);

end;

function TPageSetupDlg.GetError : Integer;
begin
    Result := CommDlgExtendedError();
end;

function TPageSetupDlg.Execute : Boolean;
var
ExitCode : Boolean;
Device,Driver,Output : PChar;
fDevMode  : PDevMode;
begin
    case fAdvanced of
    0 : //Not in advanced mode
        begin
        Prepare;
        FillOptions(fOptions);
        end;
    1:Prepare; //Advanced mode . User must assign properties and/or hook procedures
    end;       //If Advanced > 1 then You are expert ! (better use pure API ;-))
    ftagPSD.lStructSize := sizeof(tagPSD);
    ExitCode := PageSetupDlg(ftagPSD);
    fDevNames := PDevNames(GlobalLock(ftagPSD.hDevNames));
    fDevMode  := PDevMode(GlobalLock(ftagPSD.hDevMode));
    if fDevNames <> nil then //support situation when user pressed cancel button
        begin
            Driver := PChar(fDevNames) + fDevNames^.wDriverOffset;
            Device := PChar(fDevNames) + fDevNames^.wDeviceOffset;
            Output := PChar(fDevNames) + fDevNames^.wOutputOffset;
        if psdReturnDC in fOptions then fhDC := CreateDC(Driver,Device,Output,fDevMode);
          end;
    Result   := ExitCode;
end;

function TPageSetupDlg.Info : PPrinterInfo;
begin
  try
    FillChar(PrinterInfo,sizeof(PrinterInfo),0);
    with PrinterInfo do
        begin
        ADriver := PChar(fDevNames) + fDevNames^.wDriverOffset;
        ADevice := PChar(fDevNames) + fDevNames^.wDeviceOffset;
        APort := PChar(fDevNames) + fDevNames^.wOutputOffset;
        ADevMode := ftagPSD.hDevMode;
        end;
      finally // support fDevNames=0 (user pressed Cancel)
    Result := @PrinterInfo;
  end;
end;




function TPageSetupDlg.GetPaperSize :  TPoint;
begin
    Result := ftagPSD.ptPaperSize;
end;

procedure TPageSetupDlg.SetMinMargins(Left,Top,Right,Bottom: Integer);
begin
     ftagPSD.rtMinMargin.Left := Left;
     ftagPSD.rtMinMargin.Top := Top;
     ftagPSD.rtMinMargin.Right := Right;
     ftagPSD.rtMinMargin.Bottom := Bottom;
end;

function TPageSetupDlg.GetMinMargins : TRect;
begin
    Result := ftagPSD.rtMinMargin;
end;

procedure TPageSetupDlg.SetMargins(Left,Top,Right,Bottom : Integer);
begin
     ftagPSD.rtMargin.Left := Left;
     ftagPSD.rtMargin.Top := Top;
     ftagPSD.rtMargin.Right := Right;
     ftagPSD.rtMargin.Bottom := Bottom;
end;

function TPageSetupDlg.GetMargins : TRect;
begin
    Result := ftagPSD.rtMargin;
end;



begin
end.
