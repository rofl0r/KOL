unit KOLPrintDialogs;
{* Print and printer setup dialogs, implemented in KOL object.
|<br>
Ver 1.5
|<br>
[+] starting from this version previous settings selected by user are preserved
during subsequent calls to Execute
|<br>
[-] fixed bugs when returning options :pdSelection,pdCollate,pdPageNums . Now correctly
return these options when appriopriate controls were selected in dialog window.
|<br>
[+] added AlwaysReset property to allow reseting dialog settings to default values
|<br>
|<br>
Notes:
|<hr>
1. Use pdDeviceDepend to allow printer driver decide about collation and print selected
 number of pages. In this case PrintDialog do not return proper values for pdCollation
  and Copies ! (if You want manual control over pages printing and collate do not use
   pdDeviceDepend , check pdCollate and Copies and print each page separately; beside
   not all printer drivers allow collating and printing more then one page at once, for
   example  Apple LaserWriter even without pdDeviceDepend always return 1 for Copies.
   I'll investige the best way to set Copies to the value selected by user in dialog window and
   fix this problem in the next release of KOLPrintDialogs. Seems that also there is need to write
   some FAQ about printing issues. )
|<br>
2. Always assign Options such like : pdPrintToFile,pdPageNums, pdCollate, pdSelection before calling
 Execute function. These options are returned when appropriate controls were checked in dialog
 and are cleared when not, so You must assigned them each time.
 |<br>
 |<br>
Ver 1.4
  |<br>
Now the information about selected printer can be transferred to TKOLPrinter.
If DC is needed directly use new pdReturnDC option.}

interface

uses Windows, Messages, KOL, KOLPrintCommon;


const

  DN_DEFAULTPRN = $0001; {default printer }
  HELPMSGSTRING = 'commdlg_help';



//******************************************************************************
//   PrintDlg options
//******************************************************************************

  PD_ALLPAGES = $00000000;
  PD_SELECTION = $00000001;
  PD_PAGENUMS = $00000002;
  PD_NOSELECTION = $00000004;
  PD_NOPAGENUMS = $00000008;
  PD_COLLATE = $00000010;
  PD_PRINTTOFILE = $00000020;
  PD_PRINTSETUP = $00000040;
  PD_NOWARNING = $00000080;
  PD_RETURNDC = $00000100;
  PD_RETURNIC = $00000200;
  PD_RETURNDEFAULT = $00000400;
  PD_SHOWHELP = $00000800;
  PD_ENABLEPRINTHOOK = $00001000;
  PD_ENABLESETUPHOOK = $00002000;
  PD_ENABLEPRINTTEMPLATE = $00004000;
  PD_ENABLESETUPTEMPLATE = $00008000;
  PD_ENABLEPRINTTEMPLATEHANDLE = $00010000;
  PD_ENABLESETUPTEMPLATEHANDLE = $00020000;
  PD_USEDEVMODECOPIES = $00040000;
  PD_USEDEVMODECOPIESANDCOLLATE = $00040000;
  PD_DISABLEPRINTTOFILE = $00080000;
  PD_HIDEPRINTTOFILE = $00100000;
  PD_NONETWORKBUTTON = $00200000;


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

  PDevNames = ^tagDEVNAMES;
  tagDEVNAMES = packed record
  {*}
    wDriverOffset: Word;
    wDeviceOffset: Word;
    wOutputOffset: Word;
    wDefault: Word;
  end;








  { Structure for PrintDlg function }
  PtagPD = ^tagPD;
  tagPD  = packed record
  {*}
    lStructSize: DWORD;
    hWndOwner: HWND;
    hDevMode: HGLOBAL;
    hDevNames: HGLOBAL;
    hDC: HDC;
    Flags: DWORD;
    nFromPage: Word;
    nToPage: Word;
    nMinPage: Word;
    nMaxPage: Word;
    nCopies: Word;
    hInstance: HINST;
    lCustData: LPARAM;
    lpfnPrintHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpfnSetupHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpPrintTemplateName: PAnsiChar;
    lpSetupTemplateName: PAnsiChar;
    hPrintTemplate: HGLOBAL;
    hSetupTemplate: HGLOBAL;
  end;









function PrintDlg(var PrintDlg: tagPD): BOOL; stdcall;external 'comdlg32.dll' name 'PrintDlgA';

function CommDlgExtendedError():DWORD;stdcall; external 'comdlg32.dll'  name 'CommDlgExtendedError';















type

//////////////////////////////////////////////////////
//                                                  //
//  Print dialog and printer setup dialog.          //
//                                                  //
//////////////////////////////////////////////////////

TPrintDlgOption = (pdPrinterSetup,pdCollate,pdPrintToFile,pdPageNums,pdSelection,
pdWarning,pdDeviceDepend,pdHelp,pdReturnDC);
{* Options:
|<br>
|<ul>
|<li><b>pdPrinterSetup</b> : printer setup dialog </li>
|<li><b>pdCollate</b> : places checkmark in Collate check box.When Execute returns this flag
indicates that the user selected the Collate option but printer does not support it
|</li>
|<li><b>pdPrintToFile</b> : causes "Print to File" check box to be visible.When Execute returns this flag
indicates that this check box was selected and must be processed
|</li>
|<li><b>pdPageNums</b> : allow to select pages in dialog </li>
|<li><b>pdSelection</b> : set Selection field visible in dialog </li>
|<li><b>pdWarning</b> : when set, and there's no default printer in system, warning is generated (like in VCL  TPrintDialog) </li>
|<li><b>pdDeviceDepend</b> : disables fields : Copies,Collate if this functions aren't supported by printer driver </li>
|<li><b>pdHelp</b> : Help button is visible (owner receive HELPMSGSTRING registered message)</li>
|<li><b>pdReturnDC</b> : returns DC of selected printer </li>
|</ul>
}


TPrintDlgOptions = Set of TPrintDlgOption;
{*}

  PPrintDlg =^TPrintDlg;
  TKOLPrintDialog = PPrintDlg;
  TPrintDlg = object(TObj)
  {*}
  private
    { Private declarations }
    fDevNames : PDevNames;
    fAdvanced : WORD;
    ftagPD    : tagPD;
    fOptions  : TPrintDlgOptions;
    PrinterInfo : TPrinterInfo;
    fAlwaysReset : Boolean;
  protected
    function GetError : Integer;

    { Protected declarations }
  public
    { Public declarations }
    destructor Destroy; virtual;
    property Error : Integer read GetError;
    {* Extended error}
    property FromPage : WORD read ftagPD.nFromPage write ftagPD.nFromPage;
    {* Starting page }
    property ToPage   : WORD read ftagPD.nToPage write ftagPD.nToPage;
    {* Ending page}
    property MinPage  : WORD read ftagPD.nMinPage write ftagPD.nMinPage;
    {* Minimal page number which is allowed to select}
    property MaxPage  : WORD read ftagPD.nMaxPage write ftagPD.nMaxPage;
    {* Maximal page number which is allowed to select}
    property Copies   : WORD read ftagPD.nCopies write ftagPD.nCopies;
    {* Number of copies}
    property Options  : TPrintDlgOptions read fOptions write fOptions;
    {* Set of options}
    property AlwaysReset : Boolean read fAlwaysReset write fAlwaysReset;
    {* Currently PrintDialog by default  preserve last options selected by user, but
    if this property is TRUE - dialog is always reset to default printer and default options}
    property DC       : hDC read ftagPD.hDC;
    {* DC of selected printer}
    function Execute : Boolean;
    {* Main method}
    function Info : PPrinterInfo;
    {*}
    {These below are usefull in Advanced mode }
    property tagPD    : tagPD read ftagPD write ftagPD;
    {* For low-level access}
    property Advanced : WORD read fAdvanced write fAdvanced;
    {* 1 := You must assign properties to tagPD by yourself
    |<br>
       2 := Even more control...
       }
    procedure FillOptions(DlgOptions : TPrintDlgOptions);
    {* Fill options}
    procedure Prepare;
    {* Destroy of prevoius context (DEVMODE,DEVNAMES,DC) .Usefull when Advanced > 0}
  end;

function NewPrintDialog(AOwner : PControl; Options : TPrintDlgOptions) : PPrintDlg;
{* Global creating function}




implementation





///////////////////////////////////////////////////////////////
//                                                           //
//  Print dialog and printer setup dialog (implementation)   //
//                                                           //
///////////////////////////////////////////////////////////////




function NewPrintDialog(AOwner : PControl; Options : TPrintDlgOptions) : PPrintDlg;
begin
    New(Result,Create);
    FillChar(Result.ftagPD,sizeof(tagPD),0);
    Result.ftagPD.hWndOwner := AOwner.GetWindowHandle;
    Result.ftagPD.hInstance := hInstance;
    Result.fOptions := Options;
    Result.fAlwaysReset := false;
    Result.fAdvanced := 0;
end;







destructor TPrintDlg.Destroy;
begin
    Prepare;
    if (ftagPD.hDevMode <>0) then GlobalFree(ftagPD.hDevMode);
    if (ftagPD.hDevNames<>0) then GlobalFree(ftagPD.hDevNames);
    inherited;
end;

procedure TPrintDlg.Prepare;
begin
    if (ftagPD.hDevMode <> 0) and fAlwaysReset then
    begin
        GlobalFree(ftagPD.hDevMode);
        ftagPD.hDevMode :=0;
    end;
    if ftagPD.hDevNames <> 0 then
    begin
    GlobalUnlock(ftagPD.hDevNames);
    if fAlwaysReset then
      begin
        GlobalFree(ftagPD.hDevNames);
        ftagPD.hDevNames :=0;
      end;
    end;
    if ftagPD.hDC <> 0 then
    	begin
    	DeleteDC(ftagPD.hDC);
    	ftagPD.hDC :=0;
    	end;
end;


procedure TPrintDlg.FillOptions(DlgOptions : TPrintDlgOptions);
begin
  ftagPD.Flags := PD_ALLPAGES;
  { Return HDC if required}
  if pdReturnDC in DlgOptions then Inc(ftagPD.Flags,PD_RETURNDC);
  { Show printer setup dialog }
  if pdPrinterSetup in DlgOptions then Inc(ftagPD.Flags,PD_PRINTSETUP);
  { Process HELPMSGSTRING message. Note : AOwner control must register and
  process this message.}
  if pdHelp in DlgOptions then Inc(ftagPD.Flags, PD_SHOWHELP);
  { This flag indicates on return that printer driver does not support collation.
  You must eigther provide collation or set pdDeviceDepend (and user won't see
  collate checkbox if is not supported) }
  if pdCollate in DlgOptions then Inc(ftagPD.Flags,PD_COLLATE);
  { Disable some parts of PrintDlg window }
  if not (pdPrintToFile in DlgOptions) then Inc(ftagPD.Flags, PD_HIDEPRINTTOFILE);
  if not (pdPageNums in DlgOptions) then Inc(ftagPD.Flags, PD_NOPAGENUMS);
  if not (pdSelection in DlgOptions) then Inc(ftagPD.Flags, PD_NOSELECTION);
  { Disable warning if there is no default printer }
  if not (pdWarning in DlgOptions) then Inc(ftagPD.Flags, PD_NOWARNING);
  if pdDeviceDepend in DlgOptions then Inc(ftagPD.Flags,PD_USEDEVMODECOPIESANDCOLLATE);

end;

function TPrintDlg.GetError : Integer;
begin
    Result := CommDlgExtendedError();
end;

function TPrintDlg.Execute : Boolean;
var
ExitCode : Boolean;
begin
    case fAdvanced of
    0 : //Not in advanced mode
        begin
        Prepare;
        FillOptions(fOptions);
        end;
    1:Prepare; //Advanced mode . User must assign properties and/or hook procedures
    end;
    ftagPD.lStructSize := sizeof(tagPD);
    ExitCode := PrintDlg(ftagPD);
    fDevNames := PDevNames(GlobalLock(ftagPD.hDevNames));
    if (ftagPD.Flags and PD_PRINTTOFILE) <> 0 then fOptions := fOptions + [pdPrintToFile]
    else
    fOptions := fOptions - [pdPrintToFile];
    if (ftagPD.Flags and PD_COLLATE) <> 0 then fOptions := fOptions + [pdCollate]
    else
    fOptions := fOptions - [pdCollate];
    if (ftagPD.Flags and PD_SELECTION) <> 0 then fOptions := fOptions + [pdSelection]
    else
    fOptions := fOptions - [pdSelection];
    if (ftagPD.Flags and PD_PAGENUMS) <> 0 then fOptions := fOptions + [pdPageNums]
    else
    fOptions := fOptions - [pdPageNums];
    Result := ExitCode;
end;

function TPrintDlg.Info : PPrinterInfo;
begin
  try
   FillChar(PrinterInfo,sizeof(PrinterInfo),0);
    with PrinterInfo do
        begin
            ADriver  := PChar(fDevNames) + fDevNames^.wDriverOffset;
            ADevice  := PChar(fDevNames) + fDevNames^.wDeviceOffset;
            APort    := PChar(fDevNames) + fDevNames^.wOutputOffset;
            ADevMode := ftagPD.hDevMode ;
        end;
      finally //support situation when fDevNames=0 (user pressed Cancel)
    Result := @PrinterInfo;
  end;
end;




begin
end.
