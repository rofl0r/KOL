unit KOLMHMonthCalendar;
//  MHMonthCalendar Компонент (MHMonthCalendar Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 20-май(may)-2003
//  Дата коррекции (Last correction Date): 25-мар(mar)-2003
//  Версия (Version): 0.92
//  EMail: Gandalf@kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//  Новое в (New in):
//  V0.92
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V0.91
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  V0.9
//  [+++] Очень много (Very much) [KOLnMCK]
//  [N] KOLnMCK>=1.42
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Изменение стилей (Styles)
//  4. Отрисовка (Draw)
//  5. Подчистить (Clear Stuff)
//  6. События (Events)
//  7. Все API (All API's)

interface

uses Windows,KOL,Messages,CommCtrl;

{ ====== MONTHCAL CONTROL ========= }

const
  MONTHCAL_CLASS          = 'SysMonthCal32';

const
  // Message constants
  MCM_FIRST             = $1000;
  MCM_GETCURSEL         = MCM_FIRST + 1;
  MCM_SETCURSEL         = MCM_FIRST + 2;
  MCM_GETMAXSELCOUNT    = MCM_FIRST + 3; //+
  MCM_SETMAXSELCOUNT    = MCM_FIRST + 4; //+
  MCM_GETSELRANGE       = MCM_FIRST + 5;
  MCM_SETSELRANGE       = MCM_FIRST + 6;
  MCM_GETMONTHRANGE     = MCM_FIRST + 7;
  MCM_SETDAYSTATE       = MCM_FIRST + 8;
  MCM_GETMINREQRECT     = MCM_FIRST + 9;
  MCM_SETCOLOR          = MCM_FIRST + 10; //+
  MCM_GETCOLOR          = MCM_FIRST + 11; //+
  MCM_SETTODAY          = MCM_FIRST + 12;
  MCM_GETTODAY          = MCM_FIRST + 13;
  MCM_HITTEST           = MCM_FIRST + 14;
  MCM_SETFIRSTDAYOFWEEK = MCM_FIRST + 15; //+
  MCM_GETFIRSTDAYOFWEEK = MCM_FIRST + 16; //+
  MCM_GETRANGE          = MCM_FIRST + 17; // +
  MCM_SETRANGE          = MCM_FIRST + 18; // +
  MCM_GETMONTHDELTA     = MCM_FIRST + 19; //+
  MCM_SETMONTHDELTA     = MCM_FIRST + 20; //+
  MCM_GETMAXTODAYWIDTH  = MCM_FIRST + 21;
  MCM_SETUNICODEFORMAT  = CCM_SETUNICODEFORMAT;
  MCM_GETUNICODEFORMAT  = CCM_GETUNICODEFORMAT;

  // Hit test flags
  MCHT_TITLE            = $00010000;
  MCHT_CALENDAR         = $00020000;
  MCHT_TODAYLINK        = $00030000;
  MCHT_NEXT             = $01000000;  // these indicate that hitting
  MCHT_PREV             = $02000000;  // here will go to the next/prev month
  MCHT_NOWHERE          = $00000000;
  MCHT_TITLEBK          = MCHT_TITLE;
  MCHT_TITLEMONTH       = MCHT_TITLE or $0001;
  MCHT_TITLEYEAR        = MCHT_TITLE or $0002;
  MCHT_TITLEBTNNEXT     = MCHT_TITLE or MCHT_NEXT or $0003;
  MCHT_TITLEBTNPREV     = MCHT_TITLE or MCHT_PREV or $0003;
  MCHT_CALENDARBK       = MCHT_CALENDAR;
  MCHT_CALENDARDATE     = MCHT_CALENDAR or $0001;
  MCHT_CALENDARDATENEXT = MCHT_CALENDARDATE or MCHT_NEXT;
  MCHT_CALENDARDATEPREV = MCHT_CALENDARDATE or MCHT_PREV;
  MCHT_CALENDARDAY      = MCHT_CALENDAR or $0002;
  MCHT_CALENDARWEEKNUM  = MCHT_CALENDAR or $0003;

  // Color codes
  MCSC_BACKGROUND       = 0;   // the background color (between months)
  MCSC_TEXT             = 1;   // the dates
  MCSC_TITLEBK          = 2;   // background of the title
  MCSC_TITLETEXT        = 3;
  MCSC_MONTHBK          = 4;   // background within the month cal
  MCSC_TRAILINGTEXT     = 5;   // the text color of header & trailing days

  // Notification codes
  MCN_SELCHANGE         = MCN_FIRST + 1;
  MCN_GETDAYSTATE       = MCN_FIRST + 3;
  MCN_SELECT            = MCN_FIRST + 4;

  // Style flags
  MCS_DAYSTATE          = $0001;
  MCS_MULTISELECT       = $0002; // +
  MCS_WEEKNUMBERS       = $0004; // +
  MCS_NOTODAY_PRE_IE4   = $0008; // +
  MCS_NOTODAYCIRCLE     = $0008; // +
  MCS_NOTODAY           = $0010; // +

  GMR_VISIBLE           = 0;       // visible portion of display
  GMR_DAYSTATE          = 1;       // above plus the grayed out parts of
                                   // partially displayed months
  ExStyles:array [0..4] of DWord=(MCS_NOTODAY,MCS_NOTODAYCIRCLE, MCS_WEEKNUMBERS,MCS_MULTISELECT,MCS_DAYSTATE  );

type
  // bit-packed array of "bold" info for a month
  // if a bit is on, that day is drawn bold
  MONTHDAYSTATE = DWORD;
  PMonthDayState = ^TMonthDayState;
  TMonthDayState = MONTHDAYSTATE;

  MCHITTESTINFO = packed record
    cbSize: UINT;
    pt: TPoint;
    uHit: UINT;      // out param
    st: TSystemTime;
  end;
  PMCHitTestInfo = ^TMCHitTestInfo;
  TMCHitTestInfo = MCHITTESTINFO;

  // MCN_SELCHANGE is sent whenever the currently displayed date changes
  // via month change, year change, keyboard navigation, prev/next button
  tagNMSELCHANGE = packed record
    nmhdr: TNmHdr;  // this must be first, so we don't break WM_NOTIFY
    stSelStart: TSystemTime;
    stSelEnd: TSystemTime;
  end;
  PNMSelChange = ^TNMSelChange;
  TNMSelChange = tagNMSELCHANGE;

  TCalDayOfWeek = (dowMonday, dowTuesday, dowWednesday, dowThursday,
    dowFriday, dowSaturday, dowSunday, dowLocaleDefault);

  // MCN_GETDAYSTATE is sent for MCS_DAYSTATE controls whenever new daystate
  // information is needed (month or year scroll) to draw bolding information.
  // The app must fill in cDayState months worth of information starting from
  // stStart date. The app may fill in the array at prgDayState or change
  // prgDayState to point to a different array out of which the information
  // will be copied. (similar to tooltips)
  tagNMDAYSTATE = packed record
    nmhdr: TNmHdr;  // this must be first, so we don't break WM_NOTIFY
    stStart: TSystemTime;
    cDayState: Integer;
    prgDayState: PMonthDayState; // points to cDayState TMONTHDAYSTATEs
  end;
  PNMDayState = ^TNMDayState;
  TNMDayState = tagNMDAYSTATE;

  // MCN_SELECT is sent whenever a selection has occured (via mouse or keyboard)
  NMSELECT = tagNMSELCHANGE;
  PNMSelect = ^TNMSelect;
  TNMSelect = NMSELECT;

//   returns FALSE if MCS_MULTISELECT
//   returns TRUE and sets *pst to the currently selected date otherwise
//function MonthCal_GetCurSel(hmc: HWND; var pst: TSystemTime): BOOL;

//   returns FALSE if MCS_MULTISELECT
//   returns TURE and sets the currently selected date to *pst otherwise
//function MonthCal_SetCurSel(hmc: HWND; const pst: TSystemTime): BOOL;

//   returns the maximum number of selectable days allowed
//function MonthCal_GetMaxSelCount(hmc: HWND): DWORD;

//   sets the max number days that can be selected iff MCS_MULTISELECT
//function MonthCal_SetMaxSelCount(hmc: HWND; n: UINT): BOOL;

//   sets rgst[0] to the first day of the selection range
//   sets rgst[1] to the last day of the selection range
//function MonthCal_GetSelRange(hmc: HWND; rgst: PSystemTime): BOOL;

//   selects the range of days from rgst[0] to rgst[1]
//function MonthCal_SetSelRange(hmc: HWND; rgst: PSystemTime): BOOL;

//   if rgst specified, sets rgst[0] to the starting date and
//      and rgst[1] to the ending date of the the selectable (non-grayed)
//      days if GMR_VISIBLE or all the displayed days (including grayed)
//      if GMR_DAYSTATE.
//   returns the number of months spanned by the above range.
//function MonthCal_GetMonthRange(hmc: HWND; gmr: DWORD; rgst: PSystemTime): DWORD;

//   cbds is the count of DAYSTATE items in rgds and it must be equal
//   to the value returned from MonthCal_GetMonthRange(hmc, GMR_DAYSTATE, NULL)
//   This sets the DAYSTATE bits for each month (grayed and non-grayed
//   days) displayed in the calendar. The first bit in a month's DAYSTATE
//   corresponts to bolding day 1, the second bit affects day 2, etc.
//function MonthCal_SetDayState(hmc: HWND; cbds: Integer; const rgds: TNMDayState): BOOL;

//   sets prc the minimal size needed to display one month
//function MonthCal_GetMinReqRect(hmc: HWND; var prc: TRect): BOOL;

// set what day is "today"   send NULL to revert back to real date
//function MonthCal_SetToday(hmc: HWND; const pst: TSystemTime): BOOL;

// get what day is "today"
// returns BOOL for success/failure
//function MonthCal_GetToday(hmc: HWND; var pst: TSystemTime): BOOL;

// determine what pinfo->pt is over
//function MonthCal_HitTest(hmc: HWND; var info: TMCHitTestInfo): DWORD;

// set colors to draw control with -- see MCSC_ bits below
//function MonthCal_SetColor(hmc: HWND; iColor: Integer; clr: TColorRef): TColorRef;

//function MonthCal_GetColor(hmc: HWND; iColor: Integer): TColorRef;

// set first day of week to iDay:
// 0 for Monday, 1 for Tuesday, ..., 6 for Sunday
// -1 for means use locale info
//function MonthCal_SetFirstDayOfWeek(hmc: HWND; iDay: Integer): Integer;

// DWORD result...  low word has the day.  high word is bool if this is app set
// or not (FALSE == using locale info)
//function MonthCal_GetFirstDayOfWeek(hmc: HWND): Integer;

//   modifies rgst[0] to be the minimum ALLOWABLE systemtime (or 0 if no minimum)
//   modifies rgst[1] to be the maximum ALLOWABLE systemtime (or 0 if no maximum)
//   returns GDTR_MIN|GDTR_MAX if there is a minimum|maximum limit
//function MonthCal_GetRange(hmc: HWND; rgst: PSystemTime): DWORD;

//   if GDTR_MIN, sets the minimum ALLOWABLE systemtime to rgst[0], otherwise removes minimum
//   if GDTR_MAX, sets the maximum ALLOWABLE systemtime to rgst[1], otherwise removes maximum
//   returns TRUE on success, FALSE on error (such as invalid parameters)
//function Monthcal_SetRange(hmc: HWND; gdtr: DWORD; rgst: PSystemTime): BOOL;

//   returns the number of months one click on a next/prev button moves by
//function MonthCal_GetMonthDelta(hmc: HWND): Integer;

//   sets the month delta to n. n = 0 reverts to moving by a page of months
//   returns the previous value of n.
//function MonthCal_SetMonthDelta(hmc: HWND; n: Integer): Integer;

//   sets *psz to the maximum width/height of the "Today" string displayed
//   at the bottom of the calendar (as long as MCS_NOTODAY is not specified)
//function MonthCal_GetMaxTodayWidth(hmc: HWND): DWORD;

//function MonthCal_SetUnicodeFormat(hwnd: HWND; fUnicode: BOOL): BOOL;

//function MonthCal_GetUnicodeFormat(hwnd: HWND): BOOL;


type

TDateFormat=(dfShort, dfLong);
TDateMode=(dmComboBox, dmUpDown);
TDateTimeKind=(dtkDate, dtkTime);
TCalAlignment=(dtaLeft, dtaRight);

PMHMonthCalendar = ^TMHMonthCalendar;
TKOLMHMonthCalendar = PMHMonthCalendar;


 PMonthCalColors = ^TMonthCalColors;
 TKOLMonthCalColors = PMonthCalColors;

  TMonthCalColors = object(TObj)
  private
    Owner: PMHMonthCalendar;
    function GetColor(Index: Integer):TColor;
    procedure SetColor(Index: Integer; Value: TColor);
  public
    procedure Assign(Source: PObj);
    property BackColor: TColor index 0 read GetColor write SetColor;
    property TextColor: TColor index 1 read GetColor write SetColor;
    property TitleBackColor: TColor index 2 read GetColor write SetColor;
    property TitleTextColor: TColor index 3 read GetColor write SetColor;
    property MonthBackColor: TColor index 4 read GetColor write SetColor;
    property TrailingTextColor: TColor index 5 read GetColor write SetColor;
  end;

TMHMonthCalendar = object(TControl)

private
{  FCalColors: TMonthCalColors;
    FDateTime: TDateTime;
    FEndDate: TDate;
    FFirstDayOfWeek: TCalDayOfWeek;
    FMaxDate: TDate;
    FMaxSelectRange: Integer;
    FMinDate: TDate;
    FMonthDelta: Integer;
    FMultiSelect: Boolean;
    FShowToday: Boolean;
    FShowTodayCircle: Boolean;
    FWeekNumbers: Boolean;
    FOnGetMonthInfo: TOnGetMonthInfoEvent;   }

  function GetFormat:String;
  procedure SetFormat(const Value:String);

  function GetChecked:Boolean;
  procedure SetChecked(const Value : Boolean);

  function GetDateTime:TDateTime;
  procedure SetDateTime(const Value:TDateTime);

  function GetCalendar:HWnd;

  function GetCalColors:PMonthCalColors;
  procedure SetCalColors(const Value:PMonthCalColors);

  function GetOnDropDown:TOnEvent;
  procedure SetOnDropDown(const Value:TOnEvent);

  function GetOnCloseUp:TOnEvent;
  procedure SetOnCloseUp(const Value:TOnEvent);

  function GetOnUserString:TOnEvent;
  procedure SetOnUserString(const Value:TOnEvent);

//  function GetOnKeyDown:TOnEvent;
//  procedure SetOnKeyDown(const Value:TOnEvent);

  function GetOnFormat:TOnEvent;
  procedure SetOnFormat(const Value:TOnEvent);

  function GetOnFormatQuery:TOnEvent;
  procedure SetOnFormatQuery(const Value:TOnEvent);

  function GetCalendarFont:PGraphicTool;
  procedure SetCalendarFont(const Value:PGraphicTool);

//  function GetMinMaxDateTime(const Index:Integer):TDateTime;
//  procedure SetMinMaxDateTime(const Index:Integer; const Value:TDateTime);

{  function GetDateMode:TDateMode;
  procedure SetDateMode(const Value:TDateMode);}

  function GetCalAlignment:TCalAlignment;
  procedure SetCalAlignment(const Value:TCalAlignment);

  function GetKind:TDateTimeKind;
  procedure SetKind(const Value:TDateTimeKind);

  function GetDateFormat:TDateFormat;
  procedure SetDateFormat(const Value:TDateFormat);

  function GetParseInput:Boolean;
  procedure SetParseInput(const Value:Boolean);

  procedure SetExStyle(const Index:Integer; const Value:Boolean);
  function GetExStyle(const Index:Integer):Boolean;
    function GetMonthDelta: Integer;
    procedure SetMonthDelta(const Value: Integer);
    function GetFirstDayOfWeek: TCalDayOfWeek;
    procedure SetFirstDayOfWeek(const Value: TCalDayOfWeek);
    function GetMinMaxDateTime(const Index:Integer):TDateTime;
  procedure SetMinMaxDateTime(const Index:Integer; const Value:TDateTime);
    function GetMaxSelectRange: Integer;
    procedure SetMaxSelectRange(const Value: Integer);

protected

public
//  property DateMode: TDateMode read GetDateMode write SetDateMode;
  property DateFormat: TDateFormat read GetDateFormat write SetDateFormat;
  property Kind:TDateTimeKind read GetKind write SetKind;
{  property ShowCheckbox:Boolean read FShowCheckbox write SetShowCheckbox;
  }property CalAlignment:TCalAlignment read GetCalAlignment write SetCalAlignment;
  property ParseInput:Boolean read GetParseInput write SetParseInput;


  property Format:String read GetFormat write SetFormat;
  property Checked:Boolean read GetChecked write SetChecked;
  property DateTime:TDateTime read GetDateTime write SetDateTime;  property Calendar:HWnd read GetCalendar;
  property CalColors:PMonthCalColors read GetCalColors write SetCalColors;
  property OnCloseUp:TOnEvent read GetOnDropDown write SetOnDropDown;
  property OnDropDown:TOnEvent read GetOnCloseUp write SetOnCloseUp;
  property OnUserString:TOnEvent read GetOnUserString write SetOnUserString;
//  property OnKeyDown:TOnEvent read GetOnKeyDown write SetOnKeyDown;
  property OnFormat:TOnEvent read GetOnFormat write SetOnFormat;
  property OnFormatQuery:TOnEvent read GetOnFormatQuery write SetOnFormatQuery;
  property CalendarFont:PGraphicTool read GetCalendarFont write SetCalendarFont;
//  property MinDateTime:TDateTime index 0 read GetMinMaxDateTime write SetMinMaxDateTime;
//  property MaxDateTime:TDateTime index 1 read GetMinMaxDateTime write SetMinMaxDateTime;

  property ShowToday: Boolean index 0 read GetExStyle write SetExStyle;//GetShowToday write SetShowToday;
  property ShowTodayCircle    : Boolean index 1 read GetExStyle write SetExStyle;//GetShowTodayCircle write SetShowTodayCircle;
  property WeekNumbers: Boolean index 2 read GetExStyle write SetExStyle;//GetWeekNumbers write SetWeekNumbers;
  property MultiSelect    : Boolean index 3 read GetExStyle; // FIX
  // MCS_DAYSTATE // FIX


//  property Date: TDate read GetDate write SetDate;
//  property DateTime: TDateTime read GetDateTime write SetDateTime;
//  property EndDate: TDate read GetEndDate write SetEndDate;
  property FirstDayOfWeek: TCalDayOfWeek read GetFirstDayOfWeek write SetFirstDayOfWeek
    default dowLocaleDefault;
  property MaxDateTime: TDateTime index 1 read GetMinMaxDateTime write SetMinMaxDateTime;
  property MaxSelectRange: Integer read GetMaxSelectRange write SetMaxSelectRange;
  property MinDateTime: TDateTime index 0 read GetMinMaxDateTime write SetMinMaxDateTime;
  property MonthDelta: Integer read GetMonthDelta write SetMonthDelta ;

//    property AutoSize;
//    property BorderWidth;
{    property CalColors;
    property Constraints;
    property MultiSelect;  // must be before date stuff
    property Date;
    property EndDate;
    property FirstDayOfWeek;
    property MaxDate;
    property MaxSelectRange;
    property MinDate;   }
{    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetMonthInfo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;   }



end;

const
//  MONTHCAL_CLASS     = 'SysMonthCal32';

  // Message constants
  DTM_FIRST         = $1000;
  DTM_GETSYSTEMTIME = DTM_FIRST + 1; // +
  DTM_SETSYSTEMTIME = DTM_FIRST + 2; // +
  DTM_GETRANGE      = DTM_FIRST + 3;
  DTM_SETRANGE      = DTM_FIRST + 4;
  DTM_SETFORMATA    = DTM_FIRST + 5;
  DTM_SETMCCOLOR    = DTM_FIRST + 6;
  DTM_GETMCCOLOR    = DTM_FIRST + 7;
  DTM_GETMONTHCAL   = DTM_FIRST + 8;
  DTM_SETMCFONT     = DTM_FIRST + 9;
  DTM_GETMCFONT     = DTM_FIRST + 10;
  DTM_SETFORMATW    = DTM_FIRST + 50;
  DTM_SETFORMAT     = DTM_SETFORMATA;

  // Style Flags
  // Done
  DTS_UPDOWN          = $0001;  // use UPDOWN instead of MONTHCAL
  DTS_SHOWNONE        = $0002;  // allow a NONE selection
  DTS_SHORTDATEFORMAT = $0000;  // use the short date format
  DTS_LONGDATEFORMAT  = $0004;  // use the long date format
  DTS_TIMEFORMAT      = $0009;  // use the time format
  DTS_APPCANPARSE     = $0010;  // allow user entered strings
  DTS_RIGHTALIGN      = $0020;  // right-align popup instead of left-align it

  // Notification codes
  DTN_FIRST            = 0-760;
  DTN_DATETIMECHANGE = DTN_FIRST + 1;  // the systemtime has changed
  DTN_USERSTRINGA    = DTN_FIRST + 2;  // the user has entered a string
  DTN_USERSTRINGW    = DTN_FIRST + 15;
  DTN_WMKEYDOWNA     = DTN_FIRST + 3;  // modify keydown on app format field (X)
  DTN_WMKEYDOWNW     = DTN_FIRST + 16;
  DTN_FORMATA        = DTN_FIRST + 4;  // query display for app format field (X)
  DTN_FORMATW        = DTN_FIRST + 17;
  DTN_FORMATQUERYA   = DTN_FIRST + 5;  // query formatting info for app format field (X)
  DTN_FORMATQUERYW   = DTN_FIRST + 18;
  DTN_DROPDOWN       = DTN_FIRST + 6;  // MonthCal has dropped down
  DTN_CLOSEUP        = DTN_FIRST + 7;  // MonthCal is popping up
  DTN_USERSTRING     = DTN_USERSTRINGA;
  DTN_WMKEYDOWN      = DTN_WMKEYDOWNA;
  DTN_FORMAT         = DTN_FORMATA;
  DTN_FORMATQUERY    = DTN_FORMATQUERYA;

  // Ranges
  // Done
  GDTR_MIN = $0001;
  GDTR_MAX = $0002;

  // Return Values
  GDT_ERROR = -1;
  GDT_VALID = 0;
  GDT_NONE  = 1;

//  ICC_DATE_CLASSES = $00000100;



function NewMHMonthCalendar(AParent : PControl; DateMode:TDateMode; DateFormat:TDateFormat; Kind:TDateTimeKind; ShowCheckbox,ParseInput:Boolean; CalAlignment:TCalAlignment):PMHMonthCalendar;//;Options : TMHMonthCalendarOptions) : PMHMonthCalendar;



implementation


type


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


type
  PMonthCalendarData = ^TMonthCalendarData;
  TMonthCalendarData = packed record
    FDateTime:TDateTime;
    FChecked:Boolean;
    FCalColors:PMonthCalColors;
    FOnCloseUp:TOnEvent;
    FOnDropDown:TOnEvent;
    FOnUserString:TOnEvent;
//    FOnKeyDown:TOnEvent;
    FOnFormat:TOnEvent;
    FOnFormatQuery:TOnEvent;
    FFormat:String;
  end;


const
  DateMode2Style:array [TDateMode] of DWord=($0,DTS_UPDOWN);
  DateFormat2Style:array [TDateFormat] of DWord=(DTS_SHORTDATEFORMAT,DTS_LONGDATEFORMAT);
  DateTimeKind2Style:array [TDateTimeKind] of DWord=($0,DTS_TIMEFORMAT);
  ShowCheckBox2Style:array [Boolean] of DWord=($0,DTS_SHOWNONE);
  ParseInput2Style:array [Boolean] of DWord=($0,DTS_APPCANPARSE);
  CalAlignment2Style:array [TCalAlignment] of DWord=($0,DTS_RIGHTALIGN);

function NewMonthCalColors(AOwner : PControl):PMonthCalColors;
begin
  New(Result,Create);
  AOwner.Add2AutoFree(Result);
  Result.Owner:=PMHMonthCalendar(AOwner);
end;

procedure TMonthCalColors.Assign(Source: PObj);
begin
 BackColor:=PMonthCalColors(Source).BackColor;
 TextColor:=PMonthCalColors(Source).TextColor;
 TitleBackColor:=PMonthCalColors(Source).TitleBackColor;
 TitleTextColor:=PMonthCalColors(Source).TitleTextColor;
 MonthBackColor:=PMonthCalColors(Source).MonthBackColor;
 TrailingTextColor:=PMonthCalColors(Source).TrailingTextColor;
end;

procedure TMonthCalColors.SetColor(Index: Integer; Value: TColor);
begin
  SendMessage(Owner.Handle,DTM_SETMCCOLOR,Index,Value);
end;

function TMonthCalColors.GetColor(Index: Integer):TColor;
begin
  Result:=SendMessage(Owner.Handle,DTM_GETMCCOLOR,Index,0);
end;


function WndProcMHMonthCalendar(Sender : PControl; var Msg:TMsg; var Rslt:Integer):Boolean;
var
  NMDC:PNMDateTimeChange;
  MHMonthCalendarNow:PMHMonthCalendar;
  Data: PMonthCalendarData;
begin
  Result := False;
  if Msg.message=WM_NOTIFY then
  begin
    NMDC:=PNMDateTimeChange(Msg.lParam);
    MHMonthCalendarNow:=PMHMonthCalendar(Sender);
    Data:=MHMonthCalendarNow.CustomData;
    with Data^ do
    begin
      case NMDC.nmhdr.code of

        DTN_DATETIMECHANGE:
        begin
          if NMDC.dwFlags=GDT_VALID then
          begin
            SystemTime2DateTime(NMDC.st,FDateTime);
            if Assigned(MHMonthCalendarNow.OnChange) then
              MHMonthCalendarNow.OnChange(Sender);
            FChecked:=True;
            Result:=True;
          end;
          if NMDC.dwFlags=GDT_NONE then
            FChecked:=False;
        end;

        DTN_CLOSEUP:
        begin
          if Assigned(FOnCloseUp) then
            FOnCloseUp(Sender);
        end;

        DTN_DROPDOWN:
        begin
          if Assigned(FOnDropDown) then
            FOnDropDown(Sender);
        end;

        DTN_USERSTRING:
        begin
          if Assigned(FOnUserString) then
            FOnUserString(Sender);
        end;

        DTN_FORMAT:
        begin
          if Assigned(FOnFormat) then
            FOnFormat(Sender);
        end;

        DTN_FORMATQUERY:
        begin
          if Assigned(FOnFormatQuery) then
            FOnFormatQuery(Sender);
        end;

      end; //case
    end;
  end;
end;



function NewMHMonthCalendar(AParent : PControl; DateMode:TDateMode; DateFormat:TDateFormat; Kind:TDateTimeKind; ShowCheckbox,ParseInput:Boolean; CalAlignment:TCalAlignment):PMHMonthCalendar;
var
  Data:PMonthCalendarData;
begin
  DoInitCommonControls( ICC_DATE_CLASSES );
  Result := PMHMonthCalendar(_NewCommonControl(AParent,MONTHCAL_CLASS, WS_CHILD or WS_VISIBLE or DateMode2Style[DateMode] or DateFormat2Style[DateFormat] or DateTimeKind2Style[Kind] or ShowCheckbox2Style[ShowCheckbox] or ParseInput2Style[ParseInput] or CalAlignment2Style[CalAlignment],False,0));
  GetMem(Data,Sizeof(Data^));
  FillChar(Data^,Sizeof(Data^),0);
  Result.CustomData:=Data;
  Data.FCalColors:=NewMonthCalColors(Result);
//  Data.FOnDropDown:=nil;
  Result.AttachProc(WndProcMHMonthCalendar);
end;

function TMHMonthCalendar.GetCalendarFont:PGraphicTool;
var
  tmp:HDC;
  tmp2:THandle;
  nf:PGraphicTool;
begin
//  tmp:=GetDC(Handle);
  Result:=NewFont;
//  nf:=NewFont;
//  tmp2:=Perform(DTM_GETMCFONT,0,0);
  Result.AssignHandle(Perform(DTM_GETMCFONT,0,0));{Perform(DTM_GETMCFONT,0,0));}
//  nf.AssignHandle(tmp2);
//  ShowMessage(nf.FontName);
//  Result:=PGraphicTool(GetCurrentObject(tmp,{Perform(DTM_GETMCFONT,0,0)}));
//  ReleaseDC(tmp,Handle);
end;

procedure TMHMonthCalendar.SetCalendarFont(const Value:PGraphicTool);
begin
  Perform(DTM_SETMCFONT,Value.Handle,0);
end;

function TMHMonthCalendar.GetFormat:String;
begin
  Result:=PMonthCalendarData(CustomData)^.FFormat;
end;

procedure TMHMonthCalendar.SetFormat(const Value:String);
begin
  PMonthCalendarData(CustomData)^.FFormat:=Value;
  Perform(DTM_SETFORMAT,0,DWord(PChar(Value)));
end;

function TMHMonthCalendar.GetChecked:Boolean;
begin
  Result:=PMonthCalendarData(CustomData)^.FChecked;
end;

procedure TMHMonthCalendar.SetChecked(const Value : Boolean);
var
  TMP:TSystemTime;
begin
  PMonthCalendarData(CustomData)^.FChecked:=Value;
  if Value then
    DateTime:=PMonthCalendarData(CustomData)^.FDateTime
  else
    Perform(DTM_SETSYSTEMTIME,GDT_NONE,DWord(@TMP));
end;

function TMHMonthCalendar.GetDateTime:TDateTime;
var
  TMP:TSystemTime;
begin
  Perform(DTM_GETSYSTEMTIME,0,Longint(@TMP));
  if SystemTime2DateTime(TMP,Result) then
    PMonthCalendarData(CustomData)^.FDateTime:=Result;
end;


procedure TMHMonthCalendar.SetDateTime(const Value:TDateTime);
var
  TMP:TSystemTime;
begin
  if DateTime2SystemTime(Value,TMP) then
    PMonthCalendarData(CustomData)^.FDateTime:=Value;
  Perform(DTM_SETSYSTEMTIME,GDT_VALID,Longint(@TMP));
end;

function TMHMonthCalendar.GetCalendar:HWnd;
begin
  Result:=Perform(DTM_GETMONTHCAL,0,0);
end;

function TMHMonthCalendar.GetCalColors:PMonthCalColors;
begin
  Result:=PMonthCalendarData(CustomData)^.FCalColors;
end;

procedure TMHMonthCalendar.SetCalColors(const Value:PMonthCalColors);
begin
  PMonthCalendarData(CustomData)^.FCalColors.Assign(PObj(Value));
end;

function TMHMonthCalendar.GetOnDropDown:TOnEvent;
begin
  Result:=PMonthCalendarData(CustomData)^.FOnDropDown;
end;

procedure TMHMonthCalendar.SetOnDropDown(const Value:TOnEvent);
begin
  PMonthCalendarData(CustomData)^.FOnDropDown:=Value;
end;

function TMHMonthCalendar.GetOnCloseUp:TOnEvent;
begin
  Result:=PMonthCalendarData(CustomData)^.FOnCloseUp;
end;

procedure TMHMonthCalendar.SetOnCloseUp(const Value:TOnEvent);
begin
  PMonthCalendarData(CustomData)^.FOnCloseUp:=Value;
end;

{function TMHMonthCalendar.GetMinDateTime:TDateTime;
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  SystemTime2DateTime(TMP[0],Result);
end;}


{procedure TMHMonthCalendar.SetMinDateTime(const Value:TDateTime);
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  DateTime2SystemTime(Value,TMP[0]);
  Perform(DTM_SETRANGE,GDTR_MIN or GDTR_MAX,Longint(@TMP));
end;}

{procedure TMHMonthCalendar.SetMaxDateTime(const Value:TDateTime);
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  DateTime2SystemTime(Value,TMP[1]);
  Perform(DTM_SETRANGE,GDTR_MIN or GDTR_MAX,Longint(@TMP));
end;}

function TMHMonthCalendar.GetOnUserString:TOnEvent;
begin
  Result:=PMonthCalendarData(CustomData)^.FOnUserString;
end;

procedure TMHMonthCalendar.SetOnUserString(const Value:TOnEvent);
begin
  PMonthCalendarData(CustomData)^.FOnUserString:=Value;
end;

{function TMHMonthCalendar.GetOnKeyDown:TOnEvent;
begin
  Result:=PMonthCalendarData(CustomData)^.FOnKeyDown;
end;

procedure TMHMonthCalendar.SetOnKeyDown(const Value:TOnEvent);
begin
  PMonthCalendarData(CustomData)^.FOnKeyDown:=Value;
end;
 }
function TMHMonthCalendar.GetOnFormat:TOnEvent;
begin
  Result:=PMonthCalendarData(CustomData)^.FOnFormat;
end;

procedure TMHMonthCalendar.SetOnFormat(const Value:TOnEvent);
begin
  PMonthCalendarData(CustomData)^.FOnFormat:=Value;
end;

function TMHMonthCalendar.GetOnFormatQuery:TOnEvent;
begin
  Result:=PMonthCalendarData(CustomData)^.FOnFormatQuery;
end;

procedure TMHMonthCalendar.SetOnFormatQuery(const Value:TOnEvent);
begin
  PMonthCalendarData(CustomData)^.FOnFormatQuery:=Value;
end;

{function TMHMonthCalendar.GetDateMode:TDateMode;
begin
  Result:=TDateMode((Style and DateMode2Style[High(TDateMode)])<>0);
//  PMonthCalendarData(CustomData)^.FOnFormatQuery:=Value;
end;

procedure TMHMonthCalendar.SetDateMode(const Value:TDateMode);
begin
  Style:=Style or DWord(DateMode2Style[Value]) and DWord((not DWord(DateMode2Style[Pred(Value)])));
//  PMonthCalendarData(CustomData)^.FOnFormatQuery:=Value;
end;}

function TMHMonthCalendar.GetCalAlignment:TCalAlignment;
begin
  if Style and CalAlignment2Style[dtaRight]<>0 then
    Result:=dtaRight
  else
    Result:=dtaLeft;
end;

procedure TMHMonthCalendar.SetCalAlignment(const Value:TCalAlignment);
begin
  if Value=dtaLeft then
    Style:=Style and DWord((not DWord(CalAlignment2Style[dtaRight])))
  else
    Style:=Style or DWord(CalAlignment2Style[dtaRight])
end;

function TMHMonthCalendar.GetKind:TDateTimeKind;
begin
  if Style and DateTimeKind2Style[dtkTime]<>0 then
    Result:=dtkTime
  else
    Result:=dtkDate;
end;

procedure TMHMonthCalendar.SetKind(const Value:TDateTimeKind);
begin
  if Value=dtkDate then
    Style:=Style and DWord((not DWord(DateTimeKind2Style[dtkTime])))
  else
    Style:=Style or DWord(DateTimeKind2Style[dtkTime])
end;

function TMHMonthCalendar.GetDateFormat:TDateFormat;
begin
  if Style and DateFormat2Style[dfLong]<>0 then
    Result:=dfLong
  else
    Result:=dfShort;
end;

procedure TMHMonthCalendar.SetDateFormat(const Value:TDateFormat);
begin
  if Value=dfShort then
    Style:=Style and DWord((not DWord(DateFormat2Style[dfLong])))
  else
    Style:=Style or DWord(DateFormat2Style[dfLong])
end;

function TMHMonthCalendar.GetParseInput:Boolean;
begin
  if Style and ParseInput2Style[True]<>0 then
    Result:=True
  else
    Result:=False;
end;

procedure TMHMonthCalendar.SetParseInput(const Value:Boolean);
begin
  if not Value then
    Style:=Style and DWord((not DWord(ParseInput2Style[True])))
  else
    Style:=Style or DWord(ParseInput2Style[True])
end;

function TMHMonthCalendar.GetExStyle(const Index: Integer): Boolean;
begin
  Result:=((ExStyle and ExStyles[Index])<>0);
end;

procedure TMHMonthCalendar.SetExStyle(const Index: Integer;
  const Value: Boolean);
begin
    if Value then
      ExStyle:=ExStyle or ExStyles[Index]
    else
      ExStyle:=ExStyle and not ExStyles[Index];
end;

function TMHMonthCalendar.GetMonthDelta: Integer;
begin
  Result:=Perform(MCM_GETMONTHDELTA,0,0);
end;

procedure TMHMonthCalendar.SetMonthDelta(const Value: Integer);
begin
  Perform(MCM_SETMONTHDELTA,Value,0);
end;

function TMHMonthCalendar.GetFirstDayOfWeek: TCalDayOfWeek;
begin
  Result:=TCalDayOfWeek(Perform(MCM_GETFIRSTDAYOFWEEK,0,0));
end;

procedure TMHMonthCalendar.SetFirstDayOfWeek(const Value: TCalDayOfWeek);
begin
  Perform(MCM_SETFIRSTDAYOFWEEK,0,DWORD(Value));
end;

function TMHMonthCalendar.GetMinMaxDateTime(const Index:Integer): TDateTime;
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(MCM_GETRANGE,0,Longint(@TMP));
  SystemTime2DateTime(TMP[Index],Result);
end;

procedure TMHMonthCalendar.SetMinMaxDateTime(const Index:Integer; const Value: TDateTime);
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(MCM_GETRANGE,0,Longint(@TMP));
  DateTime2SystemTime(Value,TMP[Index]);
  Perform(MCM_SETRANGE,GDTR_MIN or GDTR_MAX,Longint(@TMP));
end;

function TMHMonthCalendar.GetMaxSelectRange: Integer;
begin
  Result:=Perform(MCM_GETMAXSELCOUNT,0,0);
end;

procedure TMHMonthCalendar.SetMaxSelectRange(const Value: Integer);
begin
  Perform(MCM_SETMAXSELCOUNT,Value,0);
end;

end.




