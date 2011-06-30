unit KOLMHPrinters;

//  MHPrinters Библиотека (MHPrinters Library)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 11-сен(sep)-2002
//  Дата коррекции (Last correction Date): 28-сен(sep)-2002
//  Версия (Version): 0.9
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//  Новое в (New in):
//  V0.9
//  [*] Улучшил узнавание версии ОС (OS Version recognition improved) [KOL]
//  [!] TPrinterCanvas связана с принтером (TPrinterCanvas linked to printer) [KOL]
//
//  V0.2
//  [+] Перевел на KOL (Translate into KOL) [KOL]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Создать TPrinterCanvas.UpdateFont (Make TPrinterCanvas.UpdateFont)
//  5. Обрабатка ошибок (Exception)

{$R-,T-,X+,H+}

interface

uses kol, Windows, WinSpool;

const
  SDeviceOnPort = '%s on %s';
{ File open modes }

  fmOpenRead       = $0000;
  fmOpenWrite      = $0001;
  fmOpenReadWrite  = $0002;
  fmShareCompat    = $0000;
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead  = $0030;
  fmShareDenyNone  = $0040;

{ File attribute constants }

  faReadOnly  = $00000001;
  faHidden    = $00000002;
  faSysFile   = $00000004;
  faVolumeID  = $00000008;
  faDirectory = $00000010;
  faArchive   = $00000020;
  faAnyFile   = $0000003F;

{ File mode magic numbers }

  fmClosed = $D7B0;
  fmInput  = $D7B1;
  fmOutput = $D7B2;
  fmInOut  = $D7B3;

{ Seconds and milliseconds per day }

//  SecsPerDay = 24 * 60 * 60;
//  MSecsPerDay = SecsPerDay * 1000;

{ Days between 1/1/0001 and 12/31/1899 }

//  DateDelta = 693594;

//var

{ Empty string and null string pointer. These constants are provided for
  backwards compatibility only.  }

//  EmptyStr: string = '';
//  NullStr: PString = @EmptyStr;

{ Win32 platform identifier.  This will be one of the following values:

    VER_PLATFORM_WIN32s
    VER_PLATFORM_WIN32_WINDOWS
    VER_PLATFORM_WIN32_NT

  See WINDOWS.PAS for the numerical values. }

//  Win32Platform: Integer = 0;

{ Win32 OS version information -

  see TOSVersionInfo.dwMajorVersion/dwMinorVersion/dwBuildNumber }

{  Win32MajorVersion: Integer = 0;
  Win32MinorVersion: Integer = 0;
  Win32BuildNumber: Integer = 0;}

{ Win32 OS extra version info string -

  see TOSVersionInfo.szCSDVersion }

//  Win32CSDVersion: string = '';

{ Currency and date/time formatting options

  The initial values of these variables are fetched from the system registry
  using the GetLocaleInfo function in the Win32 API. The description of each
  variable specifies the LOCALE_XXXX constant used to fetch the initial
  value.

  CurrencyString - Defines the currency symbol used in floating-point to
  decimal conversions. The initial value is fetched from LOCALE_SCURRENCY.

  CurrencyFormat - Defines the currency symbol placement and separation
  used in floating-point to decimal conversions. Possible values are:

    0 = '$1'
    1 = '1$'
    2 = '$ 1'
    3 = '1 $'

  The initial value is fetched from LOCALE_ICURRENCY.

  NegCurrFormat - Defines the currency format for used in floating-point to
  decimal conversions of negative numbers. Possible values are:

    0 = '($1)'      4 = '(1$)'      8 = '-1 $'      12 = '$ -1'
    1 = '-$1'       5 = '-1$'       9 = '-$ 1'      13 = '1- $'
    2 = '$-1'       6 = '1-$'      10 = '1 $-'      14 = '($ 1)'
    3 = '$1-'       7 = '1$-'      11 = '$ 1-'      15 = '(1 $)'

  The initial value is fetched from LOCALE_INEGCURR.

  ThousandSeparator - The character used to separate thousands in numbers
  with more than three digits to the left of the decimal separator. The
  initial value is fetched from LOCALE_STHOUSAND.

  DecimalSeparator - The character used to separate the integer part from
  the fractional part of a number. The initial value is fetched from
  LOCALE_SDECIMAL.

  CurrencyDecimals - The number of digits to the right of the decimal point
  in a currency amount. The initial value is fetched from LOCALE_ICURRDIGITS.

  DateSeparator - The character used to separate the year, month, and day
  parts of a date value. The initial value is fetched from LOCATE_SDATE.

  ShortDateFormat - The format string used to convert a date value to a
  short string suitable for editing. For a complete description of date and
  time format strings, refer to the documentation for the FormatDate
  function. The short date format should only use the date separator
  character and the  m, mm, d, dd, yy, and yyyy format specifiers. The
  initial value is fetched from LOCALE_SSHORTDATE.

  LongDateFormat - The format string used to convert a date value to a long
  string suitable for display but not for editing. For a complete description
  of date and time format strings, refer to the documentation for the
  FormatDate function. The initial value is fetched from LOCALE_SLONGDATE.

  TimeSeparator - The character used to separate the hour, minute, and
  second parts of a time value. The initial value is fetched from
  LOCALE_STIME.

  TimeAMString - The suffix string used for time values between 00:00 and
  11:59 in 12-hour clock format. The initial value is fetched from
  LOCALE_S1159.

  TimePMString - The suffix string used for time values between 12:00 and
  23:59 in 12-hour clock format. The initial value is fetched from
  LOCALE_S2359.

  ShortTimeFormat - The format string used to convert a time value to a
  short string with only hours and minutes. The default value is computed
  from LOCALE_ITIME and LOCALE_ITLZERO.

  LongTimeFormat - The format string used to convert a time value to a long
  string with hours, minutes, and seconds. The default value is computed
  from LOCALE_ITIME and LOCALE_ITLZERO.

  ShortMonthNames - Array of strings containing short month names. The mmm
  format specifier in a format string passed to FormatDate causes a short
  month name to be substituted. The default values are fecthed from the
  LOCALE_SABBREVMONTHNAME system locale entries.

  LongMonthNames - Array of strings containing long month names. The mmmm
  format specifier in a format string passed to FormatDate causes a long
  month name to be substituted. The default values are fecthed from the
  LOCALE_SMONTHNAME system locale entries.

  ShortDayNames - Array of strings containing short day names. The ddd
  format specifier in a format string passed to FormatDate causes a short
  day name to be substituted. The default values are fecthed from the
  LOCALE_SABBREVDAYNAME system locale entries.

  LongDayNames - Array of strings containing long day names. The dddd
  format specifier in a format string passed to FormatDate causes a long
  day name to be substituted. The default values are fecthed from the
  LOCALE_SDAYNAME system locale entries.

  ListSeparator - The character used to separate items in a list.  The
  initial value is fetched from LOCALE_SLIST.

  TwoDigitYearCenturyWindow - Determines what century is added to two
  digit years when converting string dates to numeric dates.  This value
  is subtracted from the current year before extracting the century.
  This can be used to extend the lifetime of existing applications that
  are inextricably tied to 2 digit year data entry.  The best solution
  to Year 2000 (Y2k) issues is not to accept 2 digit years at all - require
  4 digit years in data entry to eliminate century ambiguities.

  Examples:

  Current TwoDigitCenturyWindow  Century  StrToDate() of:
  Year    Value                  Pivot    '01/01/03' '01/01/68' '01/01/50'
  -------------------------------------------------------------------------
  1998    0                      1900     1903       1968       1950
  2002    0                      2000     2003       2068       2050
  1998    50 (default)           1948     2003       1968       1950
  2002    50 (default)           1952     2003       1968       2050
  2020    50 (default)           1970     2003       2068       2050
 }

type
  PTextBuf = ^TTextBuf;
  TTextBuf = array[0..127] of Char;
  TTextRec = packed record (* must match the size the compiler generates: 460 bytes *)
    Handle: Integer;
    Mode: Integer;
    BufSize: Cardinal;
    BufPos: Cardinal;
    BufEnd: Cardinal;
    BufPtr: PChar;
    OpenFunc: Pointer;
    InOutFunc: Pointer;
    FlushFunc: Pointer;
    CloseFunc: Pointer;
    UserData: array[1..32] of Byte;
    Name: array[0..259] of Char;
    Buffer: TTextBuf;
  end;

//  EPrinter = class(Exception);

  { TPrinter }

  { The printer object encapsulates the printer interface of Windows.  A print
    job is started whenever any redering is done either through a Text variable
    or the printers canvas.  This job will stay open until EndDoc is called or
    the Text variable is closed.  The title displayed in the Print Manager (and
    on network header pages) is determined by the Title property.

    EndDoc - Terminates the print job (and closes the currently open Text).
      The print job will being printing on the printer after a call to EndDoc.
    NewPage - Starts a new page and increments the PageNumber property.  The
      pen position of the Canvas is put back at (0, 0).
    Canvas - Represents the surface of the currently printing page.  Note that
      some printer do not support drawing pictures and the Draw, StretchDraw,
      and CopyRect methods might fail.
    Fonts - The list of fonts supported by the printer.  Note that TrueType
      fonts appear in this list even if the font is not supported natively on
      the printer since GDI can render them accurately for the printer.
    PageHeight - The height, in pixels, of the page.
    PageWidth - The width, in pixels, of the page.
    PageNumber - The current page number being printed.  This is incremented
      when ever the NewPage method is called.  (Note: This property can also be
      incremented when a Text variable is written, a CR is encounted on the
      last line of the page).
    PrinterIndex - Specifies which printer in the TPrinters list that is
      currently selected for printing.  Setting this property to -1 will cause
      the default printer to be selected.  If this value is changed EndDoc is
      called automatically.
    Printers - A list of the printers installed in Windows.
    Title - The title used by Windows in the Print Manager and for network
      title pages. }

  TStringItem=record
    Obj:PObj;
    Str:String;
  end;
  TStrings=array of TStringItem;
{  TStrings=packed record
    Objects:array of TObj;
    Strings:array of String;
  end;}
  TPrinterState = (psNoHandle, psHandleIC, psHandleDC);
  TPrinterOrientation = (poPortrait, poLandscape);
  TPrinterCapability = (pcCopies, pcOrientation, pcCollation);
  TPrinterCapabilities = set of TPrinterCapability;

  PMHPrinter = ^TMHPrinter;
  TMHPrinter = object(TObj)
  private
    FCanvas: PCanvas;
    FFonts: TStrings;//PStrList;//TStrings;
    FPageNumber: Integer;
    FPrinters:TStrings;// PStrList;//TStrings;
    FPrinterIndex: Integer;
    FTitle: string;
    FPrinting: Boolean;
    FAborted: Boolean;
    FCapabilities: TPrinterCapabilities;
    State: TPrinterState;
    DC: HDC;
    DevMode: PDeviceMode;
    DeviceMode: THandle;
    FPrinterHandle: THandle;
    procedure SetState(Value: TPrinterState);
    function GetCanvas: PCanvas;
    function GetNumCopies: Integer;
    function GetFonts: TStrings;//PStrList;//TStrings;
    function GetHandle: HDC;
    function GetOrientation: TPrinterOrientation;
    function GetPageHeight: Integer;
    function GetPageWidth: Integer;
    function GetPrinterIndex: Integer;
    procedure SetPrinterCapabilities(Value: Integer);
    procedure SetPrinterIndex(Value: Integer);
    function GetPrinters:TStrings;// PStrList;//TStrings;
    procedure SetNumCopies(Value: Integer);
    procedure SetOrientation(Value: TPrinterOrientation);
    procedure SetToDefaultPrinter;
    procedure CheckPrinting(Value: Boolean);
    procedure FreePrinters;
    procedure FreeFonts;
  public
//    constructor Create;
//    destructor Destroy; override;
    procedure Abort;
    procedure BeginDoc;
    procedure EndDoc;
    procedure NewPage;
    procedure GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
    procedure SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
    procedure Refresh;
    property Aborted: Boolean read FAborted;
    property Canvas: PCanvas read GetCanvas;
    property Capabilities: TPrinterCapabilities read FCapabilities;
    property Copies: Integer read GetNumCopies write SetNumCopies;
    property Fonts: TStrings read GetFonts;
    property Handle: HDC read GetHandle;
    property Orientation: TPrinterOrientation read GetOrientation write SetOrientation;
    property PageHeight: Integer read GetPageHeight;
    property PageWidth: Integer read GetPageWidth;
    property PageNumber: Integer read FPageNumber;
    property PrinterIndex: Integer read GetPrinterIndex write SetPrinterIndex;
    property Printing: Boolean read FPrinting;
    property Printers: TStrings read GetPrinters;
    property Title: string read FTitle write FTitle;
  end;

{ Printer function - Replaces the Printer global variable of previous versions,
  to improve smart linking (reduce exe size by 2.5k in projects that don't use
  the printer).  Code which assigned to the Printer global variable
  must call SetPrinter instead.  SetPrinter returns current printer object
  and makes the new printer object the current printer.  It is the caller's
  responsibility to free the old printer, if appropriate.  (This allows
  toggling between different printer objects without destroying configuration
  settings.) }

function Printer: PMHPrinter;
function SetPrinter(NewPrinter: PMHPrinter): PMHPrinter;

{ AssignPrn - Assigns a Text variable to the currently selected printer.  Any
  Write or Writeln's going to that file variable will be written on the
  printer using the Canvas property's font.  A new page is automatically
  started if a CR is encountered on (or a Writeln is written to) the last
  line on the page.  Closing the text file will imply a call to the
  Printer.EndDoc method. Note: only one Text variable can be open on the
  printer at a time.  Opening a second will cause an exception.}

procedure AssignPrn(var F: Text);

implementation

//uses Consts;

var
  FPrinter: PMHPrinter = nil;

function FetchStr(var Str: PChar): PChar;
var
  P: PChar;
begin
  Result := Str;
  if Str = nil then Exit;
  P := Str;
  while P^ = ' ' do Inc(P);
  Result := P;
  while (P^ <> #0) and (P^ <> ',') do Inc(P);
  if P^ = ',' then
  begin
    P^ := #0;
    Inc(P);
  end;
  Str := P;
end;

{procedure RaiseError(const Msg: string);
begin
  raise EPrinter.Create(Msg);
end;}

function AbortProc(Prn: HDC; Error: Integer): Bool; stdcall;
begin
  Applet.ProcessMessages; // ???
//  Application.ProcessMessages;
  Result := not FPrinter.Aborted;
end;

type
  PrnRec = record
    case Integer of
      1: (
        Cur: TPoint;
        Finish: TPoint;         { End of the printable area }
        Height: Integer);       { Height of the current line }
      2: (
        Tmp: array[1..32] of Char);
  end;

procedure NewPage(var Prn: PrnRec);
begin
  with Prn do
  begin
    Cur.X := 0;
    Cur.Y := 0;
    FPrinter.NewPage;
  end;
end;

{ Start a new line on the current page, if no more lines left start a new
  page. }
procedure NewLine(var Prn: PrnRec);

  function CharHeight: Word;
  var
    Metrics: TTextMetric;
  begin
    GetTextMetrics(FPrinter.Canvas.Handle, Metrics);
    Result := Metrics.tmHeight;
  end;

begin
  with Prn do
  begin
    Cur.X := 0;
    if Height = 0 then
      Inc(Cur.Y, CharHeight) else
      Inc(Cur.Y, Height);
    if Cur.Y > (Finish.Y - (Height * 2)) then NewPage(Prn);
    Height := 0;
  end;
end;

{ Print a string to the printer without regard to special characters.  These
  should handled by the caller. }
procedure PrnOutStr(var Prn: PrnRec; Text: PChar; Len: Integer);
var
  Extent: TSize;
  L: Integer;
begin
  with Prn, FPrinter.Canvas^ do
  begin
    while Len > 0 do
    begin
      L := Len;
      GetTextExtentPoint(Handle, Text, L, Extent);

      while (L > 0) and (Extent.cX + Cur.X > Finish.X) do
      begin
        L := CharPrev(Text, Text+L) - Text;
        GetTextExtentPoint(Handle, Text, L, Extent);
      end;

      if Extent.cY > Height then Height := Extent.cY + 2;
      Windows.TextOut(Handle, Cur.X, Cur.Y, Text, L);
      Dec(Len, L);
      Inc(Text, L);
      if Len > 0 then NewLine(Prn)
      else Inc(Cur.X, Extent.cX);
    end;
  end;
end;

{ Print a string to the printer handling special characters. }
procedure PrnString(var Prn: PrnRec; Text: PChar; Len: Integer);
var
  L: Integer;
  TabWidth: Word;

  procedure Flush;
  begin
    if L <> 0 then PrnOutStr(Prn, Text, L);
    Inc(Text, L + 1);
    Dec(Len, L + 1);
    L := 0;
  end;

  function AvgCharWidth: Word;
  var
    Metrics: TTextMetric;
  begin
    GetTextMetrics(FPrinter.Canvas.Handle, Metrics);
    Result := Metrics.tmAveCharWidth;
  end;

begin
  L := 0;
  with Prn do
  begin
    while L < Len do
    begin
      case Text[L] of
        #9:
          begin
            Flush;
            TabWidth := AvgCharWidth * 8;
            Inc(Cur.X, TabWidth - ((Cur.X + TabWidth + 1)
              mod TabWidth) + 1);
            if Cur.X > Finish.X then NewLine(Prn);
          end;
        #13: Flush;
        #10:
          begin
            Flush;
            NewLine(Prn);
          end;
        ^L:
          begin
            Flush;
            NewPage(Prn);
          end;
      else
        Inc(L);
      end;
    end;
  end;
  Flush;
end;

{ Called when a Read or Readln is applied to a printer file. Since reading is
  illegal this routine tells the I/O system that no characters where read, which
  generates a runtime error. }
function PrnInput(var F: TTextRec): Integer;
begin
  with F do
  begin
    BufPos := 0;
    BufEnd := 0;
  end;
  Result := 0;
end;

{ Called when a Write or Writeln is applied to a printer file. The calls
  PrnString to write the text in the buffer to the printer. }
function PrnOutput(var F: TTextRec): Integer;
begin
  with F do
  begin
    PrnString(PrnRec(UserData), PChar(BufPtr), BufPos);
    BufPos := 0;
    Result := 0;
  end;
end;

{ Will ignore certain requests by the I/O system such as flush while doing an
  input. }
function PrnIgnore(var F: TTextRec): Integer;
begin
  Result := 0;
end;

{ Deallocates the resources allocated to the printer file. }
function PrnClose(var F: TTextRec): Integer;
begin
  with PrnRec(F.UserData) do
  begin
    FPrinter.EndDoc;
    Result := 0;
  end;
end;

{ Called to open I/O on a printer file.  Sets up the TTextFile to point to
  printer I/O functions. }
function PrnOpen(var F: TTextRec): Integer;
const
  Blank: array[0..0] of Char = '';
begin
  with F, PrnRec(UserData) do
  begin
    if Mode = fmInput then
    begin
      InOutFunc := @PrnInput;
      FlushFunc := @PrnIgnore;
      CloseFunc := @PrnIgnore;
    end else
    begin
      Mode := fmOutput;
      InOutFunc := @PrnOutput;
      FlushFunc := @PrnOutput;
      CloseFunc := @PrnClose;
      FPrinter.BeginDoc;

      Cur.X := 0;
      Cur.Y := 0;
      Finish.X := FPrinter.PageWidth;
      Finish.Y := FPrinter.PageHeight;
      Height := 0;
    end;
    Result := 0;
  end;
end;

procedure AssignPrn(var F: Text);
begin
  with TTextRec(F), PrnRec(UserData) do
  begin
    Printer;
    FillChar(F, SizeOf(F), 0);
    Mode := fmClosed;
    BufSize := SizeOf(Buffer);
    BufPtr := @Buffer;
    OpenFunc := @PrnOpen;
  end;
end;

{ TPrinterDevice }

type
  PPrinterDevice=^TPrinterDevice;
  
  TPrinterDevice = object(TObj)
    Driver, Device, Port: String;
//    constructor Create(ADriver, ADevice, APort: PChar);
    function IsEqual(ADriver, ADevice, APort: PChar): Boolean;
  end;

function NewPrinterDevice(ADriver, ADevice, APort: PChar):PPrinterDevice;
begin
  New(Result, Create);
  Result.Driver := ADriver;
  Result.Device := ADevice;
  Result.Port := APort;
end;

{constructor TPrinterDevice.Create(ADriver, ADevice, APort: PChar);
begin
  inherited Create;
  Driver := ADriver;
  Device := ADevice;
  Port := APort;
end;}

function TPrinterDevice.IsEqual(ADriver, ADevice, APort: PChar): Boolean;
begin
  Result := (Device = ADevice) and ((Port = '') or (Port = APort));
end;

{ TPrinterCanvas }

type
  PPrinterCanvas=^TPrinterCanvas;
  TPrinterCanvas = object(TCanvas)
    Printer: PMHPrinter;
//    constructor Create(APrinter: PPrinter);
    procedure CreateHandle;// override;
    procedure Changing;// override;
    procedure UpdateFont;
  end;

{constructor TPrinterCanvas.Create(APrinter: TPrinter);
begin
  inherited Create;
  Printer := APrinter;
end;                  }

function NewPrinterCanvas(APrinter: PMHPrinter):PPrinterCanvas;
begin
  New(Result, Create);
  Result.Printer:=APrinter;
end;

procedure TPrinterCanvas.CreateHandle;
begin
  Printer.SetState(psHandleIC);
  UpdateFont;
  Handle:= Printer.DC;
end;

procedure TPrinterCanvas.Changing;
begin
  Printer.CheckPrinting(True);
//  inherited Changing;
  UpdateFont;
end;

procedure TPrinterCanvas.UpdateFont;
var
  FontSize: Integer;
begin
//  if GetDeviceCaps(Printer.DC, LOGPIXELSY) <> Font.PixelsPerInch then
  begin
//    FontSize := Font.FontSize;
//    Font.PixelsPerInch := GetDeviceCaps(Printer.DC, LOGPIXELSY);
//    Font.Size := FontSize;
  end;
end;

{ TPrinter }

{constructor TPrinter.Create;
begin
//  inherited Create;
  FPrinterIndex := -1;
end;}

function NewPrinter:PMHPrinter;
begin
  New(Result, Create);
  Result.FPrinterIndex:= -1;
end;

{destructor TPrinter.Destroy;
begin
  if Printing then EndDoc;
  SetState(psNoHandle);
  FreePrinters;
  FreeFonts;
  FCanvas.Free;
  if FPrinterHandle <> 0 then ClosePrinter(FPrinterHandle);
  if DeviceMode <> 0 then
  begin
    GlobalUnlock(DeviceMode);
    GlobalFree(DeviceMode);
    DeviceMode := 0;
  end;
  inherited Destroy;
end;}

procedure TMHPrinter.SetState(Value: TPrinterState);
type
  TCreateHandleFunc = function (DriverName, DeviceName, Output: PChar;
    InitData: PDeviceMode): HDC stdcall;
var
  CreateHandleFunc: TCreateHandleFunc;
begin
  if Value <> State then
  begin
    CreateHandleFunc := nil;
    case Value of
      psNoHandle:
        begin
          CheckPrinting(False);
          if Assigned(FCanvas) then
             FCanvas.Handle := 0;
          DeleteDC(DC);
          DC := 0;
        end;
      psHandleIC:
        if State <> psHandleDC then CreateHandleFunc := CreateIC
        else Exit;
      psHandleDC:
        begin
          if FCanvas <> nil then FCanvas.Handle := 0;
          if DC <> 0 then DeleteDC(DC);
          CreateHandleFunc := CreateDC;
        end;
    end;
    if Assigned(CreateHandleFunc) then
      with PPrinterDevice(Printers[PrinterIndex].Obj)^ do
//      with TPrinterDevice(Printers.Objects[PrinterIndex]) do
      begin
        DC := CreateHandleFunc(PChar(Driver), PChar(Device), PChar(Port), DevMode);
//        if DC = 0 then RaiseError(SInvalidPrinter);
        if FCanvas <> nil then FCanvas.Handle := DC;
      end;
    State := Value;
  end;
end;

procedure TMHPrinter.CheckPrinting(Value: Boolean);
begin
//  if Printing <> Value then
//    if Value then RaiseError(SNotPrinting)
//    else RaiseError(SPrinting);
end;

procedure TMHPrinter.Abort;
begin
  CheckPrinting(True);
  AbortDoc(Canvas.Handle);
  FAborted := True;
  EndDoc;
end;

procedure TMHPrinter.BeginDoc;
var
  DocInfo: TDocInfo;
begin
  CheckPrinting(False);
  SetState(psHandleDC);
//  Canvas.Refresh;
//  TPrinterCanvas(Canvas).UpdateFont;
  FPrinting := True;
  FAborted := False;
  FPageNumber := 1;
  FillChar(DocInfo, SizeOf(DocInfo), 0);
  with DocInfo do
  begin
    cbSize := SizeOf(DocInfo);
    lpszDocName := PChar(Title);
  end;
  SetAbortProc(DC, AbortProc);
  StartDoc(DC, DocInfo);
  StartPage(DC);
end;

procedure TMHPrinter.EndDoc;
begin
  CheckPrinting(True);
  EndPage(DC);
  if not Aborted then Windows.EndDoc(DC);
  FPrinting := False;
  FAborted := False;
  FPageNumber := 0;
end;

procedure TMHPrinter.NewPage;
begin
  CheckPrinting(True);
  EndPage(DC);
  StartPage(DC);
  Inc(FPageNumber);
//  Canvas.Refresh;
end;

procedure TMHPrinter.GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
begin
  with PPrinterDevice(Printers[PrinterIndex].Obj)^ do
//  with TPrinterDevice(Printers.Objects[PrinterIndex]) do
  begin
    StrCopy(ADevice, PChar(Device));
    StrCopy(ADriver, PChar(Driver));
    StrCopy(APort, PChar(Port));
  end;
  ADeviceMode := DeviceMode;
end;

procedure TMHPrinter.SetPrinterCapabilities(Value: Integer);
begin
  FCapabilities := [];
  if (Value and DM_ORIENTATION) <> 0 then
    Include(FCapabilities, pcOrientation);
  if (Value and DM_COPIES) <> 0 then
    Include(FCapabilities, pcCopies);
  if (Value and DM_COLLATE) <> 0 then
    Include(FCapabilities, pcCollation);
end;

procedure TMHPrinter.SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
var
  I, J: Integer;
  StubDevMode: TDeviceMode;
begin
  CheckPrinting(False);
  if ADeviceMode <> DeviceMode then
  begin  // free the devmode block we have, and take the one we're given
    if DeviceMode <> 0 then
    begin
      GlobalUnlock(DeviceMode);
      GlobalFree(DeviceMode);
    end;
    DeviceMode := ADeviceMode;
  end;
  if DeviceMode <> 0 then
  begin
    DevMode := GlobalLock(DeviceMode);
    SetPrinterCapabilities(DevMode.dmFields);
  end;
  FreeFonts;
  if FPrinterHandle <> 0 then
  begin
    ClosePrinter(FPrinterHandle);
    FPrinterHandle := 0;
  end;
  SetState(psNoHandle);
  J := -1;
//  with Printers do   // <- this rebuilds the FPrinters list
//    for I := 0 to Count - 1 do
    for I := 0 to Length(Printers) - 1 do
    begin
      with Printers[i] do
      begin
      if PPrinterDevice(Obj).IsEqual(ADriver, ADevice, APort) then
//      if TPrinterDevice(Objects[I]).IsEqual(ADriver, ADevice, APort) then
      begin
         PPrinterDevice(Obj).Port := APort;
//        TPrinterDevice(Objects[I]).Port := APort;
        J := I;
        Break;
      end;
      end;
    end;
  if J = -1 then
  begin
    J := Length(FPrinters);//FPrinters.Count;
    SetLength(FPrinters,Length(FPrinters)+1);
    FPrinters[Length(FPrinters)-1].Str:=Format(SDeviceOnPort, [ADevice, APort]);
    FPrinters[Length(FPrinters)-1].Obj:=NewPrinterDevice(ADriver, ADevice, APort);
//    FPrinters.AddObject(Format(SDeviceOnPort, [ADevice, APort]),
//      TPrinterDevice.Create(ADriver, ADevice, APort));
  end;
  FPrinterIndex := J;
  if OpenPrinter(ADevice, FPrinterHandle, nil) then
  begin
    if DeviceMode = 0 then  // alloc new device mode block if one was not passed in
    begin
      DeviceMode := GlobalAlloc(GHND,
        DocumentProperties(0, FPrinterHandle, ADevice, StubDevMode,
        StubDevMode, 0));
      if DeviceMode <> 0 then
      begin
        DevMode := GlobalLock(DeviceMode);
        if DocumentProperties(0, FPrinterHandle, ADevice, DevMode^,
          DevMode^, DM_OUT_BUFFER) < 0 then
        begin
          GlobalUnlock(DeviceMode);
          GlobalFree(DeviceMode);
          DeviceMode := 0;
        end
      end;
    end;
    if DeviceMode <> 0 then
      SetPrinterCapabilities(DevMode^.dmFields);
  end;
end;

function TMHPrinter.GetCanvas: PCanvas;
begin
  if FCanvas = nil then
  begin
    FCanvas :=NewPrinterCanvas(@Self);// TPrinterCanvas.Create(Self);
    PPrinterCanvas(FCanvas).CreateHandle;
  end;
  Result := FCanvas;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
//  TStrings(Data).Add(LogFont.lfFaceName);
  SetLength(TStrings(Data),Length(TStrings(Data))+1);
  TStrings(Data)[Length(TStrings(Data))].Str:=LogFont.lfFaceName;
  Result := 1;
end;

function TMHPrinter.GetFonts: TStrings;//PStrList;//Strings;
begin
  if FFonts = nil then
  try
    SetState(psHandleIC);
//    FFonts := TStringList.Create;
    EnumFonts(DC, nil, @EnumFontsProc, Pointer(FFonts));
  except
    SetLength(FFonts,0);
//    FreeAndNil(FFonts);
    raise;
  end;
  Result := FFonts;
end;

function TMHPrinter.GetHandle: HDC;
begin
  SetState(psHandleIC);
  Result := DC;
end;

function TMHPrinter.GetNumCopies: Integer;
begin
  GetPrinterIndex;
//  if DeviceMode = 0 then RaiseError(SInvalidPrinterOp);
  Result := DevMode^.dmCopies;
end;

procedure TMHPrinter.SetNumCopies(Value: Integer);
begin
  CheckPrinting(False);
  GetPrinterIndex;
//  if DeviceMode = 0 then RaiseError(SInvalidPrinterOp);
  SetState(psNoHandle);
  DevMode^.dmCopies := Value;
end;

function TMHPrinter.GetOrientation: TPrinterOrientation;
begin
  GetPrinterIndex;
//  if DeviceMode = 0 then RaiseError(SInvalidPrinterOp);
  if DevMode^.dmOrientation = DMORIENT_PORTRAIT then Result := poPortrait
  else Result := poLandscape;
end;

procedure TMHPrinter.SetOrientation(Value: TPrinterOrientation);
const
  Orientations: array [TPrinterOrientation] of Integer = (
    DMORIENT_PORTRAIT, DMORIENT_LANDSCAPE);
begin
  CheckPrinting(False);
  GetPrinterIndex;
//  if DeviceMode = 0 then RaiseError(SInvalidPrinterOp);
  SetState(psNoHandle);
  DevMode^.dmOrientation := Orientations[Value];
end;

function TMHPrinter.GetPageHeight: Integer;
begin
  SetState(psHandleIC);
  Result := GetDeviceCaps(DC, VertRes);
end;

function TMHPrinter.GetPageWidth: Integer;
begin
  SetState(psHandleIC);
  Result := GetDeviceCaps(DC, HorzRes);
end;

function TMHPrinter.GetPrinterIndex: Integer;
begin
  if FPrinterIndex = -1 then SetToDefaultPrinter;
  Result := FPrinterIndex;
end;

procedure TMHPrinter.SetPrinterIndex(Value: Integer);
begin
  CheckPrinting(False);
  if (Value = -1) or (PrinterIndex = -1) then SetToDefaultPrinter;
//  else
//  if (Value < 0) or (Value >= Printers.Count) then RaiseError(SPrinterIndexError);
  FPrinterIndex := Value;
  FreeFonts;
  SetState(psNoHandle);
end;

function TMHPrinter.GetPrinters: TStrings;//PStrList;//TStrings;
var
  LineCur, Port: PChar;
  Buffer, PrinterInfo: PChar;
  Flags, Count, NumInfo: DWORD;
  I: Integer;
  Level: Byte;
begin
  if FPrinters = nil then
  begin
//    FPrinters := TStringList.Create;
    Result := FPrinters;
    try
      if WinVer=wvNT then//Win32Platform = VER_PLATFORM_WIN32_NT then
      begin
        Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
        Level := 4;
      end
      else
      begin
        Flags := PRINTER_ENUM_LOCAL;
        Level := 5;
      end;
      Count := 0;
      EnumPrinters(Flags, nil, Level, nil, 0, Count, NumInfo);
      if Count = 0 then Exit;
      GetMem(Buffer, Count);
      try
        if not EnumPrinters(Flags, nil, Level, PByte(Buffer), Count, Count, NumInfo) then
          Exit;
        PrinterInfo := Buffer;
        for I := 0 to NumInfo - 1 do
        begin
          if Level = 4 then
            with PPrinterInfo4(PrinterInfo)^ do
            begin
              SetLength(FPrinters,Length(FPrinters)+1);
              FPrinters[Length(FPrinters)-1].Str:=pPrinterName;
              FPrinters[Length(FPrinters)-1].Obj:=NewPrinterDevice(nil, pPrinterName, nil);
//              FPrinters.AddObject(pPrinterName,
//                TPrinterDevice.Create(nil, pPrinterName, nil));
              Inc(PrinterInfo, sizeof(TPrinterInfo4));
            end
          else
            with PPrinterInfo5(PrinterInfo)^ do
            begin
              LineCur := pPortName;
              Port := FetchStr(LineCur);
              while Port^ <> #0 do
              begin
                SetLength(FPrinters,Length(FPrinters)+1);
              FPrinters[Length(FPrinters)-1].Str:=Format(SDeviceOnPort, [pPrinterName, Port]);
              FPrinters[Length(FPrinters)-1].Obj:=NewPrinterDevice(nil, pPrinterName, Port);
//                FPrinters.AddObject(Format(SDeviceOnPort, [pPrinterName, Port]),
//                  TPrinterDevice.Create(nil, pPrinterName, Port));
                Port := FetchStr(LineCur);
              end;
              Inc(PrinterInfo, sizeof(TPrinterInfo5));
            end;
        end;
      finally
        FreeMem(Buffer, Count);
      end;
    except
//      FPrinters.Free;
//      FPrinters := nil;
      SetLength(FPrinters,0);
      raise;
    end;
  end;
  Result := FPrinters;
end;

procedure TMHPrinter.SetToDefaultPrinter;
var
  I: Integer;
  ByteCnt, StructCnt: DWORD;
  DefaultPrinter: array[0..79] of Char;
  Cur, Device: PChar;
  PrinterInfo: PPrinterInfo5;
begin
  ByteCnt := 0;
  StructCnt := 0;
  if not EnumPrinters(PRINTER_ENUM_DEFAULT, nil, 5, nil, 0, ByteCnt,
    StructCnt) and (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
  begin
    // With no printers installed, Win95/98 fails above with "Invalid filename".
    // NT succeeds and returns a StructCnt of zero.
{    if GetLastError = ERROR_INVALID_NAME then
      RaiseError(SNoDefaultPrinter)
    else
      RaiseLastWin32Error;}
  end;
  PrinterInfo := AllocMem(ByteCnt);
  try
    EnumPrinters(PRINTER_ENUM_DEFAULT, nil, 5, PrinterInfo, ByteCnt, ByteCnt,
      StructCnt);
    if StructCnt > 0 then
      Device := PrinterInfo.pPrinterName
    else begin
      GetProfileString('windows', 'device', '', DefaultPrinter,
        SizeOf(DefaultPrinter) - 1);
      Cur := DefaultPrinter;
      Device := FetchStr(Cur);
    end;
//    with Printers^ do
      for I := 0 to Length(Printers)-1 do
//      for I := 0 to Count-1 do
      with Printers[I] do
      begin
        if PPrinterDevice(Obj).Device = Device then
//        if TPrinterDevice(Objects[I]).Device = Device then
        begin
                  with PPrinterDevice(Obj)^ do
//          with TPrinterDevice(Objects[I]) do
            SetPrinter(PChar(Device), PChar(Driver), PChar(Port), 0);
          Exit;
        end;
      end;
  finally
    FreeMem(PrinterInfo);
  end;
//  RaiseError(SNoDefaultPrinter);
end;

procedure TMHPrinter.FreePrinters;
var
  I: Integer;
begin
  if Length(FPrinters)>0 then//FPrinters <> nil then
  begin
    for I := 0 to Length(FPrinters)-1 do//FPrinters.Count - 1 do
      Fprinters[i].Obj.Free;
//      FPrinters.Objects[I].Free;
      SetLength(FPrinters,0);
//      FPrinters.Free;
//      FPrinters:=nil;
//    FreeAndNil(FPrinters);
  end;
end;

procedure TMHPrinter.FreeFonts;
begin
  SetLength(FFonts,0);
//  FFonts.Free;
//  FFonts:=nil;
//  FreeAndNil(FFonts);
end;

function Printer: PMHPrinter;
begin
  if FPrinter = nil then
    FPrinter :=NewPrinter;// TPrinter.Create;
  Result := FPrinter;
end;

function SetPrinter(NewPrinter: PMHPrinter): PMHPrinter;
begin
  Result := FPrinter;
  FPrinter := NewPrinter;
end;

procedure TMHPrinter.Refresh;
begin
  FreeFonts;
  FreePrinters;
end;

initialization

finalization
  FPrinter.Free;

end.
