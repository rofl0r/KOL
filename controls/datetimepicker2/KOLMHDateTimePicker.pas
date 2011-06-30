unit KOLMHDateTimePicker;
//  MHDateTimePicker Компонент (MHDateTimePicker Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 1-авг(aug)-2002
//  Дата коррекции (Last correction Date): 25-окт(oct)-2003
//  Версия (Version): 0.93
//  EMail: Gandalf@kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin,
//    Yury Sidorov
//  Новое в (New in):
//  V0.93
//  [+] Визуализация в MCK (Visualization in MCK) [MCK]
//  [*] Фикс в чтении свойства Checked (Checked property reading fixed) [KOL]
//  [*] Теперь OnChange вызывается при программном изменение Checked и DateTime
//      (Now OnChange event is called when Checked and DateTime was changed programmatically) [KOL]
//  [N] KOLnMCK>=1.67
//
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
//  4. Подчистить (Clear Stuff)
//  5. События (Events)
//  6. Все API (All API's)

interface

uses Windows,KOL,Messages;

type

TDateFormat=(dfShort, dfLong);
TDateMode=(dmComboBox, dmUpDown);
TDateTimeKind=(dtkDate, dtkTime);
TCalAlignment=(dtaLeft, dtaRight);

PMHDateTimePicker = ^TMHDateTimePicker;
TKOLMHDateTimePicker = PMHDateTimePicker;


 PMonthCalColors = ^TMonthCalColors;
 TKOLMonthCalColors = PMonthCalColors;

  TMonthCalColors = object(TObj)
  private
    Owner: PMHDateTimePicker;
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

TMHDateTimePicker = object(TControl)

private
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

  function GetMinMaxDateTime(const Index:Integer):TDateTime;
  procedure SetMinMaxDateTime(const Index:Integer; const Value:TDateTime);

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

protected
  procedure DoOnChange;

public
//  property DateMode: TDateMode read GetDateMode write SetDateMode;
  property DateFormat: TDateFormat read GetDateFormat write SetDateFormat;
  property Kind:TDateTimeKind read GetKind write SetKind;
{  property ShowCheckbox:Boolean read FShowCheckbox write SetShowCheckbox;
  }property CalAlignment:TCalAlignment read GetCalAlignment write SetCalAlignment;
  property ParseInput:Boolean read GetParseInput write SetParseInput;


  property Format:String read GetFormat write SetFormat;
  property Checked:Boolean read GetChecked write SetChecked;
  property DateTime:TDateTime read GetDateTime write SetDateTime;
  property Calendar:HWnd read GetCalendar;
  property CalColors:PMonthCalColors read GetCalColors write SetCalColors;
  property OnCloseUp:TOnEvent read GetOnDropDown write SetOnDropDown;
  property OnDropDown:TOnEvent read GetOnCloseUp write SetOnCloseUp;
  property OnUserString:TOnEvent read GetOnUserString write SetOnUserString;
//  property OnKeyDown:TOnEvent read GetOnKeyDown write SetOnKeyDown;
  property OnFormat:TOnEvent read GetOnFormat write SetOnFormat;
  property OnFormatQuery:TOnEvent read GetOnFormatQuery write SetOnFormatQuery;
  property CalendarFont:PGraphicTool read GetCalendarFont write SetCalendarFont;
  property MinDateTime:TDateTime index 0 read GetMinMaxDateTime write SetMinMaxDateTime;
  property MaxDateTime:TDateTime index 1 read GetMinMaxDateTime write SetMinMaxDateTime;


end;

const
  DATETIMEPICK_CLASS = 'SysDateTimePick32';

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



function NewMHDateTimePicker(AParent : PControl; DateMode:TDateMode; DateFormat:TDateFormat; Kind:TDateTimeKind; ShowCheckbox,ParseInput:Boolean; CalAlignment:TCalAlignment):PMHDateTimePicker;//;Options : TMHDateTimePickerOptions) : PMHDateTimePicker;



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
  PDateTimePickerData = ^TDateTimePickerData;
  TDateTimePickerData = packed record
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
  Result.Owner:=PMHDateTimePicker(AOwner);
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


function WndProcMHDateTimePicker(Sender : PControl; var Msg:TMsg; var Rslt:Integer):Boolean;
var
  NMDC:PNMDateTimeChange;
  MHDateTimePickerNow:PMHDateTimePicker;
  Data: PDateTimePickerData;
begin
  Result := False;
  if Msg.message=WM_NOTIFY then
  begin
    NMDC:=PNMDateTimeChange(Msg.lParam);
    MHDateTimePickerNow:=PMHDateTimePicker(Sender);
    Data:=MHDateTimePickerNow.CustomData;
    with Data^ do
    begin
      case NMDC.nmhdr.code of

        DTN_DATETIMECHANGE:
        begin
          if NMDC.dwFlags=GDT_VALID then
          begin
            SystemTime2DateTime(NMDC.st,FDateTime);
            FChecked:=True;
            Result:=True;
          end;
          if NMDC.dwFlags=GDT_NONE then
            FChecked:=False;
          MHDateTimePickerNow.DoOnChange;
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



function NewMHDateTimePicker(AParent : PControl; DateMode:TDateMode; DateFormat:TDateFormat; Kind:TDateTimeKind; ShowCheckbox,ParseInput:Boolean; CalAlignment:TCalAlignment):PMHDateTimePicker;
var
  Data:PDateTimePickerData;
begin
  DoInitCommonControls( ICC_DATE_CLASSES );
  Result := PMHDateTimePicker(_NewCommonControl(AParent, DATETIMEPICK_CLASS, WS_TABSTOP or WS_CHILD or WS_VISIBLE or DateMode2Style[DateMode] or DateFormat2Style[DateFormat] or DateTimeKind2Style[Kind] or ShowCheckbox2Style[ShowCheckbox] or ParseInput2Style[ParseInput] or CalAlignment2Style[CalAlignment],False,nil));
  GetMem(Data,Sizeof(Data^));
  FillChar(Data^,Sizeof(Data^),0);
  Result.CustomData:=Data;
  Data.FCalColors:=NewMonthCalColors(Result);
//  Data.FOnDropDown:=nil;
  Result.AttachProc(WndProcMHDateTimePicker);
end;

function TMHDateTimePicker.GetCalendarFont:PGraphicTool;
{
var
  tmp:HDC;
  tmp2:THandle;
  nf:PGraphicTool;
}  
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

procedure TMHDateTimePicker.SetCalendarFont(const Value:PGraphicTool);
begin
  Perform(DTM_SETMCFONT,Value.Handle,0);
end;

function TMHDateTimePicker.GetFormat:String;
begin
  Result:=PDateTimePickerData(CustomData)^.FFormat;
end;

procedure TMHDateTimePicker.SetFormat(const Value:String);
begin
  PDateTimePickerData(CustomData)^.FFormat:=Value;
  Perform(DTM_SETFORMAT,0,DWord(PChar(Value)));
end;

function TMHDateTimePicker.GetChecked:Boolean;
var
  TMP:TSystemTime;
begin
  PDateTimePickerData(CustomData)^.FChecked:=Perform(DTM_GETSYSTEMTIME,0,Longint(@TMP)) = GDT_VALID;
  Result:=PDateTimePickerData(CustomData)^.FChecked;
end;

procedure TMHDateTimePicker.SetChecked(const Value : Boolean);
var
  TMP:TSystemTime;
begin
  PDateTimePickerData(CustomData)^.FChecked:=Value;
  if Value then
    DateTime:=PDateTimePickerData(CustomData)^.FDateTime
  else
    Perform(DTM_SETSYSTEMTIME,GDT_NONE,DWord(@TMP));
  DoOnChange;
end;

function TMHDateTimePicker.GetDateTime:TDateTime;
var
  TMP:TSystemTime;
begin
  if Perform(DTM_GETSYSTEMTIME,0,Longint(@TMP)) = GDT_VALID then
  begin
    if SystemTime2DateTime(TMP, Result) then
      PDateTimePickerData(CustomData)^.FDateTime:=Result;
  end   
  else
    Result := 0;
end;


procedure TMHDateTimePicker.SetDateTime(const Value:TDateTime);
var
  TMP:TSystemTime;
begin
  if DateTime2SystemTime(Value,TMP) then
    PDateTimePickerData(CustomData)^.FDateTime:=Value;
  Perform(DTM_SETSYSTEMTIME,GDT_VALID,Longint(@TMP));
  DoOnChange;
end;

function TMHDateTimePicker.GetCalendar:HWnd;
begin
  Result:=Perform(DTM_GETMONTHCAL,0,0);
end;

function TMHDateTimePicker.GetCalColors:PMonthCalColors;
begin
  Result:=PDateTimePickerData(CustomData)^.FCalColors;
end;

procedure TMHDateTimePicker.SetCalColors(const Value:PMonthCalColors);
begin
  PDateTimePickerData(CustomData)^.FCalColors.Assign(PObj(Value));
end;

function TMHDateTimePicker.GetOnDropDown:TOnEvent;
begin
  Result:=PDateTimePickerData(CustomData)^.FOnDropDown;
end;
procedure TMHDateTimePicker.SetOnDropDown(const Value:TOnEvent);
begin
  PDateTimePickerData(CustomData)^.FOnDropDown:=Value;
end;

function TMHDateTimePicker.GetOnCloseUp:TOnEvent;
begin
  Result:=PDateTimePickerData(CustomData)^.FOnCloseUp;
end;

procedure TMHDateTimePicker.SetOnCloseUp(const Value:TOnEvent);
begin
  PDateTimePickerData(CustomData)^.FOnCloseUp:=Value;
end;

{function TMHDateTimePicker.GetMinDateTime:TDateTime;
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  SystemTime2DateTime(TMP[0],Result);
end;}


{procedure TMHDateTimePicker.SetMinDateTime(const Value:TDateTime);
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  DateTime2SystemTime(Value,TMP[0]);
  Perform(DTM_SETRANGE,GDTR_MIN or GDTR_MAX,Longint(@TMP));
end;}

function TMHDateTimePicker.GetMinMaxDateTime(const Index:Integer):TDateTime;
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  SystemTime2DateTime(TMP[Index],Result);
end;


{procedure TMHDateTimePicker.SetMaxDateTime(const Value:TDateTime);
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  DateTime2SystemTime(Value,TMP[1]);
  Perform(DTM_SETRANGE,GDTR_MIN or GDTR_MAX,Longint(@TMP));
end;}

procedure TMHDateTimePicker.SetMinMaxDateTime(const Index:Integer; const Value:TDateTime);
var
  TMP:array [0..1] of TSystemTime;
begin
  Perform(DTM_GETRANGE,0,Longint(@TMP));
  DateTime2SystemTime(Value,TMP[Index]);
  Perform(DTM_SETRANGE,GDTR_MIN or GDTR_MAX,Longint(@TMP));
end;

function TMHDateTimePicker.GetOnUserString:TOnEvent;
begin
  Result:=PDateTimePickerData(CustomData)^.FOnUserString;
end;

procedure TMHDateTimePicker.SetOnUserString(const Value:TOnEvent);
begin
  PDateTimePickerData(CustomData)^.FOnUserString:=Value;
end;

{function TMHDateTimePicker.GetOnKeyDown:TOnEvent;
begin
  Result:=PDateTimePickerData(CustomData)^.FOnKeyDown;
end;

procedure TMHDateTimePicker.SetOnKeyDown(const Value:TOnEvent);
begin
  PDateTimePickerData(CustomData)^.FOnKeyDown:=Value;
end;
 }
function TMHDateTimePicker.GetOnFormat:TOnEvent;
begin
  Result:=PDateTimePickerData(CustomData)^.FOnFormat;
end;

procedure TMHDateTimePicker.SetOnFormat(const Value:TOnEvent);
begin
  PDateTimePickerData(CustomData)^.FOnFormat:=Value;
end;

function TMHDateTimePicker.GetOnFormatQuery:TOnEvent;
begin
  Result:=PDateTimePickerData(CustomData)^.FOnFormatQuery;
end;

procedure TMHDateTimePicker.SetOnFormatQuery(const Value:TOnEvent);
begin
  PDateTimePickerData(CustomData)^.FOnFormatQuery:=Value;
end;

{function TMHDateTimePicker.GetDateMode:TDateMode;
begin
  Result:=TDateMode((Style and DateMode2Style[High(TDateMode)])<>0);
//  PDateTimePickerData(CustomData)^.FOnFormatQuery:=Value;
end;

procedure TMHDateTimePicker.SetDateMode(const Value:TDateMode);
begin
  Style:=Style or DWord(DateMode2Style[Value]) and DWord((not DWord(DateMode2Style[Pred(Value)])));
//  PDateTimePickerData(CustomData)^.FOnFormatQuery:=Value;
end;}

function TMHDateTimePicker.GetCalAlignment:TCalAlignment;
begin
  if Style and CalAlignment2Style[dtaRight]<>0 then
    Result:=dtaRight
  else
    Result:=dtaLeft;
end;

procedure TMHDateTimePicker.SetCalAlignment(const Value:TCalAlignment);
begin
  if Value=dtaLeft then
    Style:=Style and DWord((not DWord(CalAlignment2Style[dtaRight])))
  else
    Style:=Style or DWord(CalAlignment2Style[dtaRight])
end;

function TMHDateTimePicker.GetKind:TDateTimeKind;
begin
  if Style and DateTimeKind2Style[dtkTime]<>0 then
    Result:=dtkTime
  else
    Result:=dtkDate;
end;

procedure TMHDateTimePicker.SetKind(const Value:TDateTimeKind);
begin
  if Value=dtkDate then
    Style:=Style and DWord((not DWord(DateTimeKind2Style[dtkTime])))
  else
    Style:=Style or DWord(DateTimeKind2Style[dtkTime])
end;

function TMHDateTimePicker.GetDateFormat:TDateFormat;
begin
  if Style and DateFormat2Style[dfLong]<>0 then
    Result:=dfLong
  else
    Result:=dfShort;
end;

procedure TMHDateTimePicker.SetDateFormat(const Value:TDateFormat);
begin
  if Value=dfShort then
    Style:=Style and DWord((not DWord(DateFormat2Style[dfLong])))
  else
    Style:=Style or DWord(DateFormat2Style[dfLong])
end;

function TMHDateTimePicker.GetParseInput:Boolean;
begin
  if Style and ParseInput2Style[True]<>0 then
    Result:=True
  else
    Result:=False;
end;

procedure TMHDateTimePicker.SetParseInput(const Value:Boolean);
begin
  if not Value then
    Style:=Style and DWord((not DWord(ParseInput2Style[True])))
  else
    Style:=Style or DWord(ParseInput2Style[True])
end;

procedure TMHDateTimePicker.DoOnChange;
begin
  if Assigned(OnChange) then
    OnChange(@Self);
end;

end.
