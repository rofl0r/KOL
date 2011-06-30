unit DatePicker;
{*
DatePicker control from commctl32 (IE3+)
|<br>
Version 1.1
|<br>
Author : Boguslaw Brandys (brandysb@poczta.onet.pl)
|<br>
InitCommonControlsEx is  called  to init ICC_DATECLASSES .
|<br>
Note: OnChange,OnDropDown,OnCloseUp,OnMessage,OnPaint,OnEraseBkgnd is also available but in some circumstances they are called more than once.
It is often a bad idea to use in this events any message boxes.
|<br>
Example simple usage:
|<br>
!  var
!  dt : TDateTime;
!  begin
!  dt := Now;
!  T.DateTime := dt;
!  end;
|<br>
}



interface
uses Windows,KOL,Messages;

type

TColorOption  = (clBackground,clText,clTitleBk,clTitleText,clMonthBk,clTrailing);
{* Color options:
|<br>
|<b>clBackground</b>
- the background color (between months)
|<br>
|<b>clText</b>
- the dates
|<br>
|<b>clTitleBk</b>
- background of the title
|<br>
|<b>clTitleText</b>
- title text
|<br>
|<b>clMonthBk</b>
- background within the month cal
|<br>
|<b>clTrailing</b>
- the text color of header & trailing days
}
TPickerOption = (piShortDate,piUpDown,piCheckBox,piLongDate,piTime,piRightAlign);
{* Options:
|<br>
|<b>piShortDate
|</b>
- use system short date format for display
|<br>
|<b>piLongDate
|</b>
- use system long date format for display
|<br>
|<b>piUpDown
|</b>
- use UpDown control rather then dropdown
|<br>
|<b>piTime
|</b>
- allow to change time
|<br>
|<b>piRightAlign
|</b>
- right align dropped calendar (default is  left align)
|<br>
|<b>piCheckBox
|</b>
- display checkbox on right side
|<br>
}

TPickerOptions = Set of TPickerOption;
{* }


PPicker = ^TPicker;
TKOLDatePicker = PPicker;
TPicker = object(TObj)
{*}
private
 dt : TDateTime;
 fFormat : String;
 fCheck : Boolean;
 fControl : PControl;
 fHandle : THandle;
 fTag : Integer;//tag property
 fOnChange : TOnEvent;
 fOnDropdown : TOnEvent;
 fOnCloseUp : TOnEvent;
protected
function GetCursor : HCURSOR;
procedure SetCursor(const Value : HCURSOR);
function  GetDateTime : TDateTime;
procedure SetDateTime(const Value : TDateTime);
procedure SetFormat(const Value : String);
procedure SetColors(const ColorOption : TColorOption; const Value : TColor);
function GetColors(const ColorOption : TColorOption) : TColor;
procedure SetChecked(const Value : Boolean);
procedure SetFont(const Value : PGraphicTool);
function GetFont : PGraphicTool;
procedure SetMCFont(const Value : PGraphicTool);
procedure SetTabOrder(const Value : Integer);
function GetTabOrder : Integer;
procedure SetEnabled(const Value : Boolean);
function GetEnabled : Boolean;
procedure SetVisible(const Value : Boolean);
function GetVisible : Boolean;
procedure SetOnErase(const Value : TOnPaint);
function GetOnErase : TOnPaint;
procedure SetOnPaint(const Value : TOnPaint);
function GetOnPaint : TOnPaint;
procedure SetOnMessage(const Value : TOnMessage);
function GetOnMessage : TOnMessage;
public
{ Public declarations }
destructor Destroy; virtual;
function SetAlign(Value: TControlAlign): PPicker; overload;
{*}
function SetPosition(X, Y: integer): PPicker; overload;
{*}
function SetSize(X, Y: integer): PPicker; overload;
{*}
property  DateTime : TDateTime read GetDateTime write SetDateTime;
{* Property used to change date/time (displayed by control, not system date/time !)}
property Format : String read fFormat write SetFormat;
{* Used to change displayed date/time format}
property Color[const ColorOption : TColorOption]: TColor read GetColors write SetColors;
{* Allow to change colors of each part of monthcal}
property Checked : Boolean read fCheck write SetChecked;
{* Allow testing if is checked. Have meaning only if piCheckBox option is used when creating.}
property Font : PGraphicTool read GetFont write SetFont;
{* Change font of dropdown part of control.}
property MCFont : PGraphicTool write SetMCFont;
{* Assign font of monthcal part of control . Do not affect dropdown font.}
property Cursor : HCURSOR read GetCursor write SetCursor;
{*}
property Enabled : Boolean read GetEnabled write SetEnabled;
{*}
property Visible : Boolean read GetVisible write SetVisible;
{*}
property TabOrder : Integer read GetTabOrder write SetTabOrder;
{*}
property Tag : Integer read fTag write fTag;
{*}
property OnChange : TOnEvent read fOnChange write  fOnChange;
{*}
property OnDropDown : TOnEvent read fOnDropdown write  fOnDropdown;
{*}
property OnCloseUp : TOnEvent read fOnCloseUp write  fOnCloseUp;
{*}
property OnEraseBkgnd : TOnPaint read GetOnErase write SetOnErase;
{*}
property OnPaint : TOnPaint read GetOnPaint write SetOnPaint;
{*}
property OnMessage : TOnMessage read GetOnMessage write SetOnMessage;
{*}
end;





function NewDatePicker(AOwner : PControl;Options : TPickerOptions) : PPicker;
{* Global function to create TPicker control}



implementation



const
   ICC_DATE_CLASSES = $00000100;

   DTS_SHORTDATEFORMAT  = $0000;
   DTS_UPDOWN           = $0001;
   DTS_SHOWNONE         = $0002;
   DTS_LONGDATEFORMAT   = $0004;
   DTS_TIMEFORMAT       = $0009;
   DTS_RIGHTALIGN       = $0020;
   //Notification codes
   DTN_FIRST            = 0-760;
   DTN_DATETIMECHANGE   = DTN_FIRST + 1;
   DTN_DROPDOWN         = DTN_FIRST + 6;
   DTN_CLOSEUP          = DTN_FIRST + 7;


   //Messages
   DTM_FIRST            = $1000;
   DTM_GETSYSTEMTIME    = DTM_FIRST + 1;
   DTM_SETSYSTEMTIME    = DTM_FIRST + 2;
   DTM_SETFORMATA       = DTM_FIRST + 5;
   DTM_SETMCCOLOR       = DTM_FIRST + 6;
   DTM_GETMCCOLOR       = DTM_FIRST + 7;
   DTM_GETMONTHCAL      = DTM_FIRST + 8;
   DTM_SETMCFONT        = DTM_FIRST + 9;   

   GDT_VALID            = 0;
   GDT_NONE             = 1;

   //Color schemma
   MCSC_BACKGROUND   =  0;   // the background color (between months)
   MCSC_TEXT         =  1;   // the dates
   MCSC_TITLEBK      =  2;   // background of the title
   MCSC_TITLETEXT    =  3;
   MCSC_MONTHBK      =  4;   // background within the month cal
   MCSC_TRAILINGTEXT =  5;   // the text color of header & trailing days




type

INITCOMMONCONTROLEX = packed record
    dwSize: DWORD;             // size of this structure
    dwICC: DWORD;              // flags indicating which classes to be initialized
end;

  NMHDR = packed record
    hwndFrom: HWND;
    idFrom: UINT;
    code: Integer;
  end;
  TNMHdr = NMHDR;
  PNMHdr = ^TNMHdr;

  NMDATETIMECHANGE = packed record
    nmhdr: TNmHdr;
    dwFlags: DWORD;         // GDT_VALID or GDT_NONE
    st: TSystemTime;        // valid iff dwFlags = GDT_VALID
  end;

  PNMDateTimeChange = ^TNMDateTimeChange;
  TNMDateTimeChange = NMDATETIMECHANGE;


TInitCommonControlsEx = INITCOMMONCONTROLEX;


const  PickerFlags : array[TPickerOption] of Integer = (DTS_SHORTDATEFORMAT,DTS_UPDOWN,DTS_SHOWNONE,DTS_LONGDATEFORMAT,DTS_TIMEFORMAT,DTS_RIGHTALIGN);
const ColorFlags : array[TColorOption] of integer = (MCSC_BACKGROUND,MCSC_TEXT,
MCSC_TITLEBK,MCSC_TITLETEXT,MCSC_MONTHBK,MCSC_TRAILINGTEXT);






function InitCommonControlsEx(var ICC: TInitCommonControlsEx) : Bool;stdcall;external 'comctl32.dll';

function PickerWndProc(Sender : PControl;var Msg:TMsg;var Rslt:Integer):Boolean;
var
    NMDC: PNMDateTimeChange;
    PickerNow : PPicker;

begin
  Result := False;

if Msg.message = WM_NOTIFY then
    begin
    NMDC := PNMDateTimeChange( Msg.lParam );
    PickerNow := PPicker(Sender.Tag);
       case  NMDC.nmhdr.code of
            DTN_DATETIMECHANGE:
            begin
            if NMDC.dwFlags = GDT_VALID then
            begin
            SystemTime2DateTime(NMDC.st,PickerNow.dt);
            if Assigned(PickerNow.OnChange) then PickerNow.OnChange(Sender);
            PickerNow.fCheck := True;
            Result := True;
            end;
            if NMDC.dwFlags = GDT_NONE then PickerNow.fCheck := False;
            end;
            DTN_CLOSEUP:
            if Assigned(PickerNow.OnCloseUp) then PickerNow.OnCloseUp(Sender);
            DTN_DROPDOWN:
            if Assigned(PickerNow.OnDropDown) then PickerNow.OnDropDown(Sender);

        end;
    end;
end;



function NewDatePicker(AOwner : PControl;Options : TPickerOptions) : PPicker;
var
Flags : Integer;
icex : INITCOMMONCONTROLEX;
    begin
        New(Result,Create);
        AOwner.Add2AutoFree(Result);
        icex.dwSize := sizeof(INITCOMMONCONTROLEX);
        icex.dwICC := ICC_DATE_CLASSES;
        InitCommonControlsEx(icex);
        Flags := MakeFlags(@Options,PickerFlags);
        Result.fControl :=  _NewControl(AOwner,'SysDateTimePick32',
            WS_VISIBLE or  WS_CHILD or WS_TABSTOP or Flags,True,nil);
        InitCommonControlCommonNotify(Result.fControl);
        Result.fControl.ExStyle  := Result.fControl.ExStyle or WS_EX_CLIENTEDGE;
        if piCheckBox in Options then Result.fCheck := True
        else
        Result.fCheck := False;
        Result.fControl.Tabstop := True;
        Result.fControl.Width := 150;
        Result.fControl.Height := 22;
        Result.fHandle := Result.fControl.GetWindowHandle;
        Result.fControl.Tag := Longint(Result);
        Result.fControl.AttachProc(PickerWndProc);

end;

destructor TPicker.Destroy;
begin
  fFormat := '';
  fControl.Free;
  inherited;
end;

procedure TPicker.SetMCFont(const Value : PGraphicTool);
begin
    SendMessage(fHandle,DTM_SETMCFONT,WPARAM(Value.Handle),LPARAM(True));
end;

function TPicker.GetDateTime:TDateTime;
var
st : TSystemTime;
begin
SendMessage(fHandle,DTM_GETSYSTEMTIME,0,Longint(@st));
SystemTime2DateTime(st,dt);
Result := dt;
end;


procedure TPicker.SetDateTime(const Value : TDateTime);
var
st : TSystemTime;
begin
dt := Value;
DateTime2SystemTime(dt,st);
SendMessage(fHandle,DTM_SETSYSTEMTIME,GDT_VALID,Longint(@st));
end;

procedure TPicker.SetFormat(const Value: String);
begin
      if fFormat <> Value then
        begin
          fFormat := Value;
          SendMessage(fHandle, DTM_SETFORMATA, 0, Longint(PChar(Value)));
        end;
end;

procedure TPicker.SetColors(const ColorOption : TColorOption; const Value : TColor);
begin
  SendMessage(fHandle, DTM_SETMCCOLOR,ColorFlags[ColorOption], Value);
end;

function TPicker.GetColors(const ColorOption : TColorOption) : TColor;
begin
  Result := SendMessage(fHandle, DTM_GETMCCOLOR, ColorFlags[ColorOption], 0);
end;


procedure TPicker.SetChecked(const Value : Boolean);
var
st : TSystemTime;
begin
   fCheck := Value;
   if Value then SetDateTime(dt)
   else
    SendMessage(fHandle,DTM_SETSYSTEMTIME,GDT_NONE,Longint(@st));
end;





procedure TPicker.SetFont(const Value : PGraphicTool);
begin
    if (Value <> fControl.Font) then fControl.Font.Assign(Value);
end;


function TPicker.GetFont : PGraphicTool;
begin
    Result := PGraphicTool(fControl.Font);
end;



function TPicker.SetAlign(Value: TControlAlign): PPicker;
begin
  fControl.Align:=Value;
  Result:=@Self;
end;

function TPicker.SetPosition(X, Y: integer): PPicker;
begin
   fControl.Left := X;
   fControl.Top := Y;
   Result := @self;
end;

function TPicker.SetSize(X, Y: integer): PPicker;
begin
   fControl.Width  := X;
   fControl.Height := Y;
   Result := @self;
end;


procedure TPicker.SetCursor(const Value : HCURSOR);
begin
	fControl.Cursor := Value;
end;

function TPicker.GetCursor : HCURSOR;
begin
  Result := fControl.Cursor;
end;

procedure TPicker.SetTabOrder(const Value : Integer);
begin
  fControl.TabOrder := Value;
end;

function TPicker.GetTabOrder : Integer;
begin
  Result := fControl.TabOrder ;
end;

procedure TPicker.SetEnabled(const Value : Boolean);
begin
  fControl.Enabled := Value;
end;

function TPicker.GetEnabled : Boolean;
begin
  Result := fControl.Enabled;
end;

procedure TPicker.SetVisible(const Value : Boolean);
begin
  fControl.Visible := Value;
end;

function TPicker.GetVisible : Boolean;
begin
  Result := fControl.Visible;
end;


procedure TPicker.SetOnErase(const Value : TOnPaint);
begin
  fControl.OnEraseBkgnd := Value;
end;

function TPicker.GetOnErase : TOnPaint;
begin
  Result := fControl.OnEraseBkgnd;
end;

procedure TPicker.SetOnPaint(const Value : TOnPaint);
begin
  fControl.OnPaint := Value;
end;

function TPicker.GetOnPaint : TOnPaint;
begin
  Result := fControl.OnPaint;
end;

procedure TPicker.SetOnMessage(const Value : TOnMessage);
begin
  fControl.OnMessage := Value;
end;

function TPicker.GetOnMessage : TOnMessage;
begin
  Result := fControl.OnMessage;
end;


end.
