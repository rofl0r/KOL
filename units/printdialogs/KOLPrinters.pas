unit KOLPrinters;
{* Replaces VCL TPrinter functionality.
|<br>
Author : Bogus³aw Brandys, <brandysb@poczta.onet.pl>
|<br>
|<H3>Version 1.5 </H3>
|<br>
|<i>History :</i>
|<br>
|<b> 26-10-2002 </b> [-] corrected missing inherited in destructor (Thanks to Vladimir Kladov)
|<br>
|<b> 17-09-2002 </b> [+] Added property Assigned which should always be checked before first access
to TKOLPrinter. If is FALSE then there is no printer in system. (Warning: if You
assign incorrect info to Assign procedure this could lead Your application to
crash rather then return Assigned = FALSE)
|<br>
[+] Changed Write to WriteLn and improved.Now always print a line of text with
carrage return #10#13 even there is no one at the end of text.Also should not break
word on bottom-right corner of page and working good when text does not fit on page
(NextPage invoked)
|<br>
|<br>
|<b> 15-09-2002 </b> [-]  Fix access violation when there is no printer in system (caused
by DefPrinter function and Assign procedure).
|<br>
|<b><i>Example:</i></b>
! with Printer^ do
!  begin
!        Assign(nil); //default printer (actually not needed as default printer is assigned on start)
!        if not Assigned then begin
!        MsgBox('There is no default printer in system!',mb_iconexclamation);
!        Exit;
!        end;
!        Title := 'Printing test...';
!        Canvas.Font.Assign(Memo1.Font);
!        BeginDoc;
!         for i:=0 to Memo1.Count-1 do WriteLn(Memo1.Items[i]); //or just WriteLn(Memo1.Text);
!        EndDoc;
!  end;
|<br>
|</i>One more note:</i>
|<br> use psdWarning and pdWarning in PageSetup/Print dialogs to let
user know that there is no printer in system (or no default).
When these options are  not used PrintDialog appear empty but PageSetup dialog never
appears.
|<br>
Notes:
|<br>
When output is redirected to a file and You want to know his name , check Output property
but always after sucessful Execute and before EndDoc (becouse EndDoc clears Output property)
Margins are supported but experimental (if You have time and paper please examine
if it working and let me know ;-) - especially if units for margins are properly computed.
Beside let me know what is still missing...
|<br>
Still missing (I suppose):
|<br>
- printing text as continuation of current printed line (in the middle of the line)
(this was a nightmare for me , if You know how to do it contact me)
|<br>
- printing of selected pages only  (must compute pages count)
|<br>
- collate and printing more than one page when printer do not support multiple pages and collation
(well, should not be very difficult, maybe just check if this is supported and if no just print many times
 the same)
|<br>
- Printers property (list of printers in system),PrinterIndex and  Fonts property
|<br>
- print preview
|<br>
- more tests}

interface

uses Windows,Messages,KOL,KOLPrintCommon;

type
TPrinterState = (psNeedHandle,psHandle,psOtherHandle);
TPrinterOrientation = (poPortrait,poLandscape);
{* Paper orientation}
TMarginOption = (mgInches,mgMillimeters);
{* Margin option}

  PPrinter =^TPrinter;
  TKOLPrinter = PPrinter;
  TPrinter = object(TObj)
  {*}
  private
    { Private declarations }
    fDevice,fDriver,fPort : String;
    fDevMode     : THandle;
    fDeviceMode  : PDeviceMode;
    fCanvas      : PCanvas;         // KOL canvas
    fTitle       : String;
    fState       : TPrinterState;   // DC is allocated or need new DC becouse params were changed
    fAborted     : Boolean;
    fPrinting    : Boolean;
    fPageNumber  : Integer;
    fOutput      : String;
    PrinterInfo  : TPrinterInfo;
    fRec         : TRect;
    fMargins     : TRect;  //Margins (in pixels)
    fAssigned    : Boolean; //if TRUE ,there is a printer with correctly assigned information
  protected
  function GetHandle : HDC;
  procedure SetHandle(Value : HDC);
  function GetCanvas : PCanvas;
  function GetCopies : Integer;
  procedure SetCopies(const Value : Integer);
  function GetOrientation : TPrinterOrientation;
  procedure SetOrientation(const Value : TPrinterOrientation);
  function GetPageHeight : Integer;
  function GetPageWidth : Integer;
  function Scale : Integer;
  procedure Prepare;
  procedure DefPrinter;
  public
    { Public declarations }
    destructor Destroy; virtual;
    procedure Abort;
    {* Abort print process}
    procedure BeginDoc;
    {* Begin print process}
    procedure EndDoc;
    {* End print process end send it to print spooler}
    procedure NewPage;
    {* Request new page}
    procedure Assign(Source : PPrinterInfo);
    {* Assign information about selected printer for example from Print/Page dialogs}
    procedure AssignMargins(cMargins : TRect; Option : TMarginOption);
    {* Assign information about paper margins for example from TKOLPageSetupDialog
    (in thousands of inches scale)}
    procedure WriteLn(const Text : String);
    {* Print tekst with TKOLPrinter selected font.Note: can be invoked more than once, but currently
    only for text ended with #10#13 (other is not properly wraped around right page corner ;-(  )}
    procedure RE_Print(RichEdit : PControl);
    {* Print content of TKOLRichEdit (if Rich is not TKOLRichEdit nothing happens)
       with full formating of course :-)}
    property Assigned : Boolean read fAssigned;
    {* If TRUE, there is a default or assigned previoulsy printer (by Assign).Always check
    this property to avoid access violation when there is no printer in system}
    property Title  : String read fTitle write fTitle;
    {* Title of print process in print manager window}
    function Info : PPrinterInfo;
    {* Returns info of selected print}
    property Output : String read fOutput write fOutput;
    {* Let print to the file.Assign file path to this property.}
    property Handle : HDC read GetHandle write SetHandle;
    {*}
    property Canvas : PCanvas read GetCanvas;
    {*}
    property Copies : Integer read GetCopies write SetCopies;
    {* Number of copies}
    property Orientation : TPrinterOrientation read GetOrientation write SetOrientation;
    {* Page orientation}
    property Margins : TRect read fMargins write fMargins;
    {* Page margins (in pixels)}
    property PageHeight : Integer read GetPageHeight;
    {* Page height in logical pixels}
    property PageWidth : Integer read GetPageWidth;
    {* Page width in logical pixels}
    property PageNumber : Integer read fPageNumber;
    {* Currently printed page number}
    property Printing : Boolean read fPrinting;
    {* Indicate printing process}
    property Aborted : Boolean read fAborted;
    {* Indicate abort of printing process}

  end;


function Printer : PPrinter;
{* Returns pointer to global TKOLPrinter object}

function NewPrinter(PrinterInfo : PPrinterInfo) : PPrinter;
{* Global function for creating TKOLPrinter instance.Usually not needed, becouse
inluding KOLPrinters causes creating of global TKOLPrinter instance.}



implementation
uses RichEdit;

type

  PtagPD = ^tagPD;
  tagPD  = packed record
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

const
  PD_RETURNDC = $00000100;
  PD_RETURNDEFAULT = $00000400;



var
FPrinter : PPrinter = nil;

function PrintDlg(var PrintDlg: tagPD): BOOL; stdcall;external 'comdlg32.dll' name 'PrintDlgA';






function AbortProc(Handle : HDC; Error : Integer) : Bool ; stdcall;
begin
    Result := not fPrinter.Aborted;
end;

function NewPrinter(PrinterInfo : PPrinterInfo) : PPrinter;
begin
    New(Result,Create);
    Result.fTitle := '';
    Result.fOutput := '';
    Result.fAborted := False;
    Result.fPrinting := False;
    Result.fPageNumber := 0;
    Result.fCanvas := nil;
    Result.fMargins.Top := 10;
    Result.fMargins.Left := 10;
    Result.fMargins.Bottom := 10;
    Result.fMargins.Right := 10;
    FillChar(Result.fRec,sizeof(Result.fRec),0);
    if PrinterInfo = nil then Result.DefPrinter
    else
        Result.Assign(PrinterInfo);

end;


function Printer : PPrinter;
begin
    Result := FPrinter;
end;




destructor TPrinter.Destroy;
begin
    Prepare;
    fTitle := '';
    fDevice := '';
    fDriver := '';
    fPort  := '';
    fOutput := '';
    inherited; 
end;

procedure TPrinter.Prepare;
begin
    { Free previously used resources }
    if  (fState <> psOtherHandle) and (fCanvas <> nil) then
    begin
      fCanvas.Free;
      fCanvas := nil;
    end;
    if fDevMode <> 0 then
        begin
            GlobalUnlock(fDevMode);
            GlobalFree(fDevMode);
        end;
end;

function TPrinter.Scale : Integer;
var
DC : HDC;
ScreenH,PrinterH : Integer;
begin
  DC := GetDC(0);
  ScreenH := GetDeviceCaps(DC,LOGPIXELSY);
  PrinterH := GetDeviceCaps(fCanvas.Handle,LOGPIXELSY);
  ReleaseDC(0,DC);
  Result := PrinterH div ScreenH;
end;

procedure TPrinter.WriteLn(const Text : String);
var
OldFontSize,PageH,Size,Len : Integer;
pC : PChar;
Rect : TRect;
Metrics : TTextMetric;
NewText : String;

procedure ComputeRect;
{ Start from new line.Rect is the rest of page from current new line to the bottom. First probe
 how many characters do not fit on this rect.}
begin
       Len := 1;
       while Windows.DrawText(fCanvas.Handle,pC,Len,Rect,DT_CALCRECT + DT_WORDBREAK + DT_NOCLIP + DT_NOPREFIX + DT_EXPANDTABS) < PageH do
       begin
       Rect.Right := fRec.Right; //must be, becouse DrawText shorten right corner
       Len := Len + 100;
       if Len > Size then
          begin
          Len := Size;
          Break;
          end;
       end;

    { Next : Count backwards to find exact characters which fit on required page rect.}
    while Windows.DrawText(fCanvas.Handle,pC,Len,Rect,DT_CALCRECT + DT_WORDBREAK + DT_NOCLIP + DT_NOPREFIX + DT_EXPANDTABS) > PageH do
       Len := Len - 1;

    { Find position of last space or line end (#13#10) to not break word
     (if possible) on bottom-right corner of the page.Do it only for multipage text (Len<>Size)  }
   {
    if (Len <> Size) and (Len > 0) then begin
    Test := Len;
    while ((NewText[Test] <> #32) and (NewText[Test]<> #10)) and (Test > 0)  do Test := Test -1 ;
    if Test > 0 then Len := Test;
    end;
    }

    { Finally draw it!}
    Windows.DrawText(fCanvas.Handle,pC,Len,Rect,DT_WORDBREAK + DT_NOCLIP + DT_NOPREFIX + DT_EXPANDTABS);


end;


begin
if Length(Text) <=0 then Exit;
if Text[Length(Text)] <> #10 then NewText := Text + #13#10
else
NewText := Text;
pC := PChar(NewText);
Size := Length(NewText);
SetMapMode(fCanvas.Handle,MM_TEXT);
OldFontSize := fCanvas.Font.FontHeight;
fCanvas.Font.FontHeight := fCanvas.Font.FontHeight * Scale;
SelectObject(fCanvas.Handle,fCanvas.Font.Handle);
PageH := GetPageHeight -  fMargins.Bottom;
GetTextMetrics(fCanvas.Handle,Metrics);
while Size > 0 do
  begin
    Rect := fRec;
    ComputeRect;
    Inc(pC,Len + 1);
    Dec(Size,Len + 1);
    if (Size > 0) and (fRec.Left <= fMargins.Left) then  NewPage;
  end;
  if (Rect.Bottom > PageH) then  begin
    NewPage;
    Rect.Bottom := 0;
  end;
  fRec.Top := Rect.Bottom - Metrics.tmHeight;
  fRec.Left := fMargins.Left;
  fRec.Bottom := PageH;
  fCanvas.Font.FontHeight := OldFontSize;
  NewText := '';
end;


procedure TPrinter.DefPrinter;
var
ftagPD : tagPD;
DevNames : PDevNames;
begin
    fAssigned := false;
    fState := psHandle;
    Prepare;
    { Get DC of default printer }
    FillChar(ftagPD,sizeof(tagPD),0);
    ftagPD.Flags := PD_RETURNDC + PD_RETURNDEFAULT;
    ftagPD.lStructSize := sizeof(ftagPD);
    if not PrintDlg(ftagPD) then Exit;
    fAssigned := true;
    DevNames := PDevNames(GlobalLock(ftagPD.hDevNames));
    fDevMode := ftagPD.hDevMode;
    fDeviceMode  := PDevMode(GlobalLock(fDevMode));
    try
        fDriver  := String(PChar(DevNames) + DevNames^.wDriverOffset);
        fDevice  := String(PChar(DevNames) + DevNames^.wDeviceOffset);
        fPort    := String(PChar(DevNames) + DevNames^.wOutputOffset);
    finally
        GlobalUnlock(ftagPD.hDevNames);
        GlobalFree(ftagPD.hDevNames);
    end;
    fCanvas := NewCanvas(ftagPD.hDC);
end;

procedure TPrinter.Assign(Source : PPrinterInfo);
var
Size : Integer;
DevMode : PDevMode;
fhDC : HDC;
begin
    fAssigned := false;
    if Source = nil then DefPrinter
    else
        begin
        Prepare;
        fDriver  := String(Source^.ADriver);
        fDevice  := String(Source^.ADevice);
        fPort    := String(Source^.APort);
        DevMode := PDevMode(GlobalLock(Source^.ADevMode));
        try
            Size := sizeof(DevMode^);
            fDevMode := GlobalAlloc(GHND,Size);
            fDeviceMode := PDevMode(GlobalLock(fDevMode));
            CopyMemory(fDeviceMode,DevMode,Size);
            fhDC := CreateDC(PChar(fDriver),PChar(fDevice),PChar(fPort),fDeviceMode);
        finally
            GlobalUnlock(Source^.ADevMode);
        end;
        fCanvas := NewCanvas(fhDC);
        fAssigned := true;
        end;
end;


procedure TPrinter.AssignMargins(cMargins : TRect;Option : TMarginOption);
var
PH,PW : Integer;
begin
  PH := GetDeviceCaps(fCanvas.Handle,LOGPIXELSY);
  PW := GetDeviceCaps(fCanvas.Handle,LOGPIXELSX);
  case Option of
  mgInches:
    begin
      fMargins.Top := round((cMargins.Top / 1000)*PH);
      fMargins.Left := round((cMargins.Left / 1000)*PW);
      fMargins.Bottom := round((cMargins.Bottom / 1000)*PH);
      fMargins.Right := round((cMargins.Right / 1000)*PW);
    end;
  mgMillimeters:
    begin
      fMargins.Top := round((cMargins.Top / 2540) * PH);
      fMargins.Left := round((cMargins.Left / 2540)* PW);
      fMargins.Bottom := round((cMargins.Bottom / 2540) * PH);
      fMargins.Right := round((cMargins.Right / 2540) * PW);
    end;
  end;
end;

procedure TPrinter.Abort;
begin
    AbortDoc(fCanvas.Handle);
    fAborted := True;
    EndDoc;
end;


procedure TPrinter.BeginDoc;
var
doc : DOCINFOA;
begin
    fRec.Top := fMargins.Top;
    fRec.Left := fMargins.Left;
    fRec.Right := GetPageWidth - fMargins.Right ;
    fRec.Bottom := GetPageHeight - fMargins.Bottom;
    fAborted := False;
    fPageNumber :=1;
    fPrinting := True;
    FillChar(doc,sizeof(DOCINFOA),0);
    doc.lpszDocName := PChar(fTitle);
    if (fOutput <> '') then doc.lpszOutput := PChar(fOutput);
    doc.cbSize := sizeof(doc);
    SetAbortProc(fCanvas.Handle,AbortProc);
    StartDoc(fCanvas.Handle,doc);
    StartPage(fCanvas.Handle);
end;

procedure TPrinter.EndDoc;
begin
    EndPage(fCanvas.Handle);
    if not fAborted then Windows.EndDoc(fCanvas.Handle);
    fAborted := False;
    fPageNumber := 0;
    fOutPut := '';
    fPrinting := False;
end;




function TPrinter.GetHandle : HDC;
var
fhDC : HDC;
begin
    if (fState = psNeedHandle) and (fCanvas <> nil)   then
        begin
            fCanvas.Free;
            fhDC := CreateDC(PChar(fDriver),PChar(fDevice),PChar(fPort),fDeviceMode);
            fCanvas := NewCanvas(fhDC);
            fState := psHandle;
        end;
    Result := fCanvas.Handle;
end;

procedure TPrinter.SetHandle(Value : HDC);
begin
    if Value <> fCanvas.Handle then
        begin
            if fCanvas <> nil then fCanvas.Free;
            fCanvas := NewCanvas(Value);
            fState := psOtherHandle;
        end;
end;


function TPrinter.GetCanvas : PCanvas;
begin
    GetHandle;
    Result := fCanvas;
end;


function TPrinter.Info : PPrinterInfo;
begin
    with PrinterInfo do begin
        ADevice := PChar(fDevice);
        ADriver := PChar(fDriver);
        APort   := PChar(fPort);
        ADevMode := fDevMode;
        end;
    Result := @PrinterInfo;
end;

function TPrinter.GetCopies : Integer;
begin
        Result  := fDeviceMode^.dmCopies;
end;


procedure TPrinter.SetCopies(const Value : Integer);
begin
        fDeviceMode^.dmCopies := Value;
end;


function TPrinter.GetOrientation : TPrinterOrientation;
begin
    if fDeviceMode^.dmOrientation = DMORIENT_PORTRAIT then Result := poPortrait
    else
    Result := poLandscape;
end;

procedure TPrinter.SetOrientation(const Value : TPrinterOrientation);
const
Orientations : array [TPrinterOrientation] of Integer = (DMORIENT_PORTRAIT,DMORIENT_LANDSCAPE);
begin
    fDeviceMode^.dmOrientation := Orientations[Value];
end;

function TPrinter.GetPageHeight : Integer;
begin
    Result := GetDeviceCaps(fCanvas.Handle,VERTRES);
end;

function TPrinter.GetPageWidth : Integer;
begin
    Result := GetDeviceCaps(fCanvas.Handle,HORZRES);
end;

procedure TPrinter.NewPage;
begin
    fRec.Top := fMargins.Top;
    fRec.Left := fMargins.Left;
    fRec.Right := GetPageWidth - fMargins.Right;
    fRec.Bottom := GetPageHeight - fMargins.Bottom;
    EndPage(fCanvas.Handle);
    StartPage(fCanvas.Handle);
    SelectObject(fCanvas.Handle,fCanvas.Font.Handle);
    Inc(fPageNumber);
end;


procedure TPrinter.RE_Print(RichEdit : PControl);
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap: Integer;
  SaveRect: TRect;
  TextLenEx: TGetTextLengthEx;
begin
  if IndexOfStr(RichEdit.ClassName,'obj_RichEdit') = -1 then Exit;
  FillChar(Range, SizeOf(TFormatRange), 0);
  with Range do begin
    BeginDoc;
    hdc  := GetHandle;
    hdcTarget := hdc;
    LogX := GetDeviceCaps(Handle, LOGPIXELSX);
    LogY := GetDeviceCaps(Handle, LOGPIXELSY);
    rc.Top := fMargins.Top*1440 div LogY;
    rc.Left := fMargins.Left*1440 div LogX;
    rc.Right := (GetPageWidth - fMargins.Right) * 1440 div LogX ;
    rc.Bottom := (GetPageHeight - fMargins.Bottom) * 1440 div LogY;
    rcPage := rc;
    SaveRect := rc;
    LastChar := 0;
      with TextLenEx do begin
        flags := GTL_DEFAULT;
        codepage := CP_ACP;
      end;
      MaxLen := RichEdit.Perform(EM_GETTEXTLENGTHEX, WParam(@TextLenEx), 0);
    chrg.cpMax := -1;
    OldMap := SetMapMode(hdc, MM_TEXT);
    SendMessage(RichEdit.Handle, EM_FORMATRANGE, 0, 0);    { flush buffer }
    try
      repeat
        rc := SaveRect;
        chrg.cpMin := LastChar;
        LastChar := SendMessage(RichEdit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
        if (LastChar < MaxLen) and (LastChar <> -1) then NewPage;
      until (LastChar >= MaxLen) or (LastChar = -1);
      EndDoc;
    finally
      SendMessage(RichEdit.Handle, EM_FORMATRANGE, 0, 0);  { flush buffer }
      SetMapMode(hdc, OldMap);       { restore previous map mode }
    end;
  end;
end;


initialization
FPrinter := NewPrinter(nil);

finalization
FPrinter.Free;
FPrinter := nil;
end.


