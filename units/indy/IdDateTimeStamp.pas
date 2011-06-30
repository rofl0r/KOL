// 29-nov-2002
unit IdDateTimeStamp;

interface

uses KOL { , 
  Classes } ,
  IdBaseComponent,
  SysConst, SysUtils;

const

  IdMilliSecondsInSecond = 1000;
  IdSecondsInMinute = 60;
  IdMinutesInHour = 60;
  IdHoursInDay = 24;

  IdDaysInWeek = 7;
  IdDaysInYear = 365;
  IdDaysInLeapYear = 366;
  IdYearsInShortLeapYearCycle = 4;
  IdDaysInShortLeapYearCycle = IdDaysInLeapYear + (IdDaysInYear * 3);
  IdDaysInShortNonLeapYearCycle = IdDaysInYear * IdYearsInShortLeapYearCycle;
  IdDaysInFourYears = IdDaysInShortLeapYearCycle;
  IdYearsInCentury = 100;
  IdDaysInCentury = (25 * IdDaysInFourYears) - 1;
  IdDaysInLeapCentury = IdDaysInCentury + 1;
  IdYearsInLeapYearCycle = 400;
  IdDaysInLeapYearCycle = IdDaysInCentury * 4 + 1;

  IdMonthsInYear = 12;

  IdBeatsInDay = 1000;

  IdHoursInHalfDay = IdHoursInDay div 2;

  IdSecondsInHour = IdSecondsInMinute * IdMinutesInHour;
  IdSecondsInDay = IdSecondsInHour * IdHoursInDay;
  IdSecondsInHalfDay = IdSecondsInHour * IdHoursInHalfDay;
  IdSecondsInWeek = IdDaysInWeek * IdSecondsInDay;
  IdSecondsInYear = IdSecondsInDay * IdDaysInYear;
  IdSecondsInLeapYear = IdSecondsInDay * IdDaysInLeapYear;

  IdMillisecondsInMinute = IdSecondsInMinute * IdMillisecondsInSecond;
  IdMillisecondsInHour = IdSecondsInHour * IdMillisecondsInSecond;
  IdMillisecondsInDay = IdSecondsInDay * IdMillisecondsInSecond;
  IdMillisecondsInWeek = IdSecondsInWeek * IdMillisecondsInSecond;

  IdDaysInMonth: array[1..IdMonthsInYear] of byte =
  (
    31, 28, 31, 30, 31, 30,
    31, 31, 30, 31, 30, 31
    );

  IdMonthNames: array[0..IdMonthsInYear] of string =
  ('',
    SLongMonthNameJan, SLongMonthNameFeb, SLongMonthNameMar,
    SLongMonthNameApr, SLongMonthNameMay, SLongMonthNameJun,
    SLongMonthNameJul, SLongMonthNameAug, SLongMonthNameSep,
    SLongMonthNameOct, SLongMonthNameNov, SLongMonthNameDec);

  IdMonthShortNames: array[0..IdMonthsInYear] of string =
  ('',
    SShortMonthNameJan, SShortMonthNameFeb, SShortMonthNameMar,
    SShortMonthNameApr, SShortMonthNameMay, SShortMonthNameJun,
    SShortMonthNameJul, SShortMonthNameAug, SShortMonthNameSep,
    SShortMonthNameOct, SShortMonthNameNov, SShortMonthNameDec);

  IdDayNames: array[0..IdDaysInWeek] of string =
  ('', SLongDayNameSun, SLongDayNameMon, SLongDayNameTue,
    SLongDayNameWed, SLongDayNameThu, SLongDayNameFri,
    SLongDayNameSat);

  IdDayShortNames: array[0..IdDaysInWeek] of string =
  ('', SShortDayNameSun, SShortDayNameMon, SShortDayNameTue,
    SShortDayNameWed, SShortDayNameThu, SShortDayNameFri,
    SShortDayNameSat);

  // Area Time Zones
  TZ_NZDT = 13; // New Zealand Daylight Time
  TZ_IDLE = 12; // International Date Line East
  TZ_NZST = TZ_IDLE; // New Zealand Standard Time
  TZ_NZT = TZ_IDLE; // New Zealand Time
  TZ_EADT = 11; // Eastern Australian Daylight Time
  TZ_GST = 10; // Guam Standard Time / Russia Zone 9
  TZ_JST = 9; // Japan Standard Time / Russia Zone 8
  TZ_CCT = 8; // China Coast Time / Russia Zone 7
  TZ_WADT = TZ_CCT; // West Australian Daylight Time
  TZ_WAST = 7; // West Australian Standard Time / Russia Zone 6
  TZ_ZP6 = 6; // Chesapeake Bay / Russia Zone 5
  TZ_ZP5 = 5; // Chesapeake Bay / Russia Zone 4
  TZ_ZP4 = 4; // Russia Zone 3
  TZ_BT = 3; // Baghdad Time / Russia Zone 2
  TZ_EET = 2; // Eastern European Time / Russia Zone 1
  TZ_MEST = TZ_EET; // Middle European Summer Time
  TZ_MESZ = TZ_EET; // Middle European Summer Zone
  TZ_SST = TZ_EET; // Swedish Summer Time
  TZ_FST = TZ_EET; // French Summer Time
  TZ_CET = 1; // Central European Time
  TZ_FWT = TZ_CET; // French Winter Time
  TZ_MET = TZ_CET; // Middle European Time
  TZ_MEWT = TZ_CET; // Middle European Winter Time
  TZ_SWT = TZ_CET; // Swedish Winter Time
  TZ_GMT = 0; // Greenwich Meanttime
  TZ_UT = TZ_GMT; // Universla Time
  TZ_UTC = TZ_GMT; // Universal Time Co-ordinated
  TZ_WET = TZ_GMT; // Western European Time
  TZ_WAT = -1; // West Africa Time
  TZ_BST = TZ_WAT; // British Summer Time
  TZ_AT = -2; // Azores Time
  TZ_ADT = -3; // Atlantic Daylight Time
  TZ_AST = -4; // Atlantic Standard Time
  TZ_EDT = TZ_AST; // Eastern Daylight Time
  TZ_EST = -5; // Eastern Standard Time
  TZ_CDT = TZ_EST; // Central Daylight Time
  TZ_CST = -6; // Central Standard Time
  TZ_MDT = TZ_CST; // Mountain Daylight Time
  TZ_MST = -7; // Mountain Standard Time
  TZ_PDT = TZ_MST; // Pacific Daylight Time
  TZ_PST = -8; // Pacific Standard Time
  TZ_YDT = TZ_PST; // Yukon Daylight Time
  TZ_YST = -9; // Yukon Standard Time
  TZ_HDT = TZ_YST; // Hawaii Daylight Time
  TZ_AHST = -10; // Alaska-Hawaii Standard Time
  TZ_CAT = TZ_AHST; // Central Alaska Time
  TZ_HST = TZ_AHST; // Hawaii Standard Time
  TZ_EAST = TZ_AHST; // East Australian Standard Time
  TZ_NT = -11; // -None-
  TZ_IDLW = -12; // International Date Line West

  // Military Time Zones
  TZM_A = TZ_WAT;
  TZM_Alpha = TZM_A;
  TZM_B = TZ_AT;
  TZM_Bravo = TZM_B;
  TZM_C = TZ_ADT;
  TZM_Charlie = TZM_C;
  TZM_D = TZ_AST;
  TZM_Delta = TZM_D;
  TZM_E = TZ_EST;
  TZM_Echo = TZM_E;
  TZM_F = TZ_CST;
  TZM_Foxtrot = TZM_F;
  TZM_G = TZ_MST;
  TZM_Golf = TZM_G;
  TZM_H = TZ_PST;
  TZM_Hotel = TZM_H;
  TZM_J = TZ_YST;
  TZM_Juliet = TZM_J;
  TZM_K = TZ_AHST;
  TZM_Kilo = TZM_K;
  TZM_L = TZ_NT;
  TZM_Lima = TZM_L;
  TZM_M = TZ_IDLW;
  TZM_Mike = TZM_M;
  TZM_N = TZ_CET;
  TZM_November = TZM_N;
  TZM_O = TZ_EET;
  TZM_Oscar = TZM_O;
  TZM_P = TZ_BT;
  TZM_Papa = TZM_P;
  TZM_Q = TZ_ZP4;
  TZM_Quebec = TZM_Q;
  TZM_R = TZ_ZP5;
  TZM_Romeo = TZM_R;
  TZM_S = TZ_ZP6;
  TZM_Sierra = TZM_S;
  TZM_T = TZ_WAST;
  TZM_Tango = TZM_T;
  TZM_U = TZ_CCT;
  TZM_Uniform = TZM_U;
  TZM_V = TZ_JST;
  TZM_Victor = TZM_V;
  TZM_W = TZ_GST;
  TZM_Whiskey = TZM_W;
  TZM_X = TZ_NT;
  TZM_XRay = TZM_X;
  TZM_Y = TZ_IDLE;
  TZM_Yankee = TZM_Y;
  TZM_Z = TZ_GMT;
  TZM_Zulu = TZM_Z;

type

  TDays = (TDaySun, TDayMon, TDayTue, TDayWed, TDayThu, TDayFri, TDaySat);
  TMonths = (TMthJan, TMthFeb, TMthMar, TMthApr, TMthMay, TMthJun,
    TMthJul, TMthAug, TMthSep, TMthOct, TMthNov, TMthDec);

  TIdDateTimeStamp = object(TIdBaseComponent)
  protected
    FDay: Integer;
    FIsLeapYear: Boolean;
    FMillisecond: Integer;
    FRequestedTimeZone: Integer;
    FSecond: Integer;
    FTimeZone: Integer;
    FYear: Integer;

    procedure CheckLeapYear;
  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; procedure AddDays(ANumber: Cardinal);
    procedure AddHours(ANumber: Cardinal);
    procedure AddMilliseconds(ANumber: Cardinal);
    procedure AddMinutes(ANumber: Cardinal);
    procedure AddMonths(ANumber: Cardinal);
    procedure AddSeconds(ANumber: Cardinal);
    procedure AddTDateTime(ADateTime: TDateTime);
    procedure AddTIdDateTimeStamp(AIdDateTime: TIdDateTimeStamp);
    procedure AddTTimeStamp(ATimeStamp: TTimeStamp);
    procedure AddWeeks(ANumber: Cardinal);
    procedure AddYears(ANumber: Cardinal);

    function GetAsISO8601Calendar: string;
    function GetAsISO8601Ordinal: string;
    function GetAsISO8601Week: string;
    function GetAsRFC882: string;

    function GetAsTDateTime: TDateTime;
    function GetAsTTimeStamp: TTimeStamp;
    function GetAsTimeOFDay: string; // HH:MM:SS

    function GetBeatOFDay: Integer;
    function GetDaysInYear: Integer;
    function GetDayOfMonth: Integer;
    function GetDayOfWeek: Integer;
    function GetDayOfWeekName: string;
    function GetDayOfWeekShortName: string;
    function GetHourOf12Day: Integer;
    function GetHourOf24Day: Integer;
    function GetIsMorning: Boolean;
    function GetMinuteOFDay: Integer;
    function GetMinuteOfHour: Integer;
    function GetMonthOFYear: Integer;
    function GetMonthName: string;
    function GetMonthShortName: string;
    function GetSecondsInYear: Integer;
    function GetSecondOfMinute: Integer;
    function GetWeekOFYear: Integer;

    procedure SetFromTDateTime(ADateTime: TDateTime);
    procedure SetFromTTimeStamp(ATimeStamp: TTimeStamp);

    procedure SetDay(ANumber: Integer);
    procedure SetMillisecond(ANumber: Integer);
    procedure SetSecond(ANumber: Integer);
    procedure SetYear(ANumber: Integer);

    procedure SubtractDays(ANumber: Cardinal);
    procedure SubtractHours(ANumber: Cardinal);
    procedure SubtractMilliseconds(ANumber: Cardinal);
    procedure SubtractMinutes(ANumber: Cardinal);
    procedure SubtractMonths(ANumber: Cardinal);
    procedure SubtractSeconds(ANumber: Cardinal);
    procedure SubtractTDateTime(ADateTime: TDateTime);
    procedure SubtractTIdDateTimeStamp(AIdDateTime: TIdDateTimeStamp);
    procedure SubtractTTimeStamp(ATimeStamp: TTimeStamp);
    procedure SubtractWeeks(ANumber: Cardinal);
    procedure SubtractYears(ANumber: Cardinal);

    property AsISO8601Calendar: string read GetAsISO8601Calendar;
    property AsISO8601Ordinal: string read GetAsISO8601Ordinal;
    property AsISO8601Week: string read GetAsISO8601Week;
    property AsRFC822: string read GetAsRFC882;
    property AsTDateTime: TDateTime read GetAsTDateTime;
    property AsTTimeStamp: TTimeStamp read GetAsTTimeStamp;
    property AsTimeOFDay: string read GetAsTimeOFDay;
    property BeatOFDay: Integer read GetBeatOFDay;
    property Day: Integer read FDay write FDay;
    property DaysInYear: Integer read GetDaysInYear;
    property DayOfMonth: Integer read GetDayOfMonth;
    property DayOfWeek: Integer read GetDayOfWeek;
    property DayOfWeekName: string read GetDayOfWeekName;
    property DayOfWeekShortName: string read GetDayOfWeekShortName;
    property HourOf12Day: Integer read GetHourOf12Day;
    property HourOf24Day: Integer read GetHourOf24Day;
    property IsLeapYear: Boolean read FIsLeapYear;
    property IsMorning: Boolean read GetIsMorning;
    property Second: Integer read FSecond write FSecond;
    property SecondsInYear: Integer read GetSecondsInYear;
    property SecondOfMinute: Integer read GetSecondOfMinute;
    property MinuteOFDay: Integer read GetMinuteOFDay;
    property MinuteOfHour: Integer read GetMinuteOfHour;
    property MonthOFYear: Integer read GetMonthOFYear;
    property MonthName: string read GetMonthName;
    property MonthShortName: string read GetMonthShortName;
    property Millisecond: Integer read FMillisecond write FMillisecond;
    property TimeZone: Integer read FTimeZone write FTimeZone;
    property Year: Integer read FYear write SetYear;
    property WeekOFYear: Integer read GetWeekOFYear;
  end;
PIdDateTimeStamp=^TIdDateTimeStamp;
function NewIdDateTimeStamp(AOwner: PControl):PIdDateTimeStamp;


implementation

const
  MaxWeekAdd: Cardinal = $FFFFFFFF div IdDaysInWeek;
  MaxMinutesAdd: Cardinal = $FFFFFFFF div IdSecondsInMinute;

//constructor TIdDateTimeStamp.Create;
function NewIdDateTimeStamp(AOwner: PControl):PIdDateTimeStamp;
begin
New( Result, Create );
with Result^ do
begin
//  inherited Create(AOwner);
  FYear := 1;
  FDay := 1;
  FSecond := 1;
  FMillisecond := 1;
  FTimeZone := 0;
  FRequestedTimeZone := 0;
end;  
end;

destructor TIdDateTimeStamp.Destroy;
begin
  inherited;
end;

procedure TIdDateTimeStamp.AddDays;
var
  i: Integer;
begin
  if (ANumber > Cardinal(DaysInYear - FDay)) and (not (FDay = 1)) then
  begin
    ANumber := ANumber - Cardinal(DaysInYear - FDay);
    FDay := 1;
    AddYears(1);
  end
  else
  begin
    FDay := FDay + Integer(ANumber);
    Exit;
  end;

  if ANumber >= IdDaysInLeapYearCycle then
  begin
    i := ANumber div IdDaysInLeapYearCycle;
    AddYears(i * IdYearsInLeapYearCycle);
    ANumber := ANumber - Cardinal(i * IdDaysInLeapYearCycle);
  end;

  if ANumber >= IdDaysInLeapCentury then
  begin
    while ANumber >= IDDaysInLeapCentury do
    begin
      i := FYear div 100;

      if i mod 4 = 0 then
      begin
        AddYears(IdYearsInCentury);
        ANumber := ANumber - Cardinal(IdDaysInLeapCentury);
      end
      else
      begin
        AddYears(IdYearsInCentury);
        ANumber := ANumber - Cardinal(IdDaysInCentury);
      end;
    end;
  end;

  if ANumber >= IdDaysInShortLeapYearCycle then
  begin
    i := ANumber div IdDaysInShortLeapYearCycle;
    AddYears(i * IdYearsInShortLeapYearCycle);
    ANumber := ANumber - Cardinal(i * IdDaysInShortLeapYearCycle);
  end;

  i := GetDaysInYear;
  while Integer(ANumber) > i do
  begin
    AddYears(1);
    Dec(ANumber, i);
    i := GetDaysInYear;
  end;

  if FDay + Integer(ANumber) > i then
  begin
    AddYears(1);
    Dec(ANumber, i - FDay);
    FDay := ANumber;
  end
  else
  begin
    Inc(FDay, ANumber);
  end;
end;

procedure TIdDateTimeStamp.AddHours;
var
  i: Cardinal;
begin
  i := ANumber div IdHoursInDay;
  AddDays(i);
  Dec(ANumber, i * IdHoursInDay);
  AddSeconds(ANumber * IdSecondsInHour);
end;

procedure TIdDateTimeStamp.AddMilliseconds;
var
  i: Cardinal;
begin
  i := ANumber div IdMillisecondsInDay;
  if i > 0 then
  begin
    AddDays(i);
    Dec(ANumber, i * IdMillisecondsInDay);
  end;

  i := ANumber div IdMillisecondsInSecond;
  if i > 0 then
  begin
    AddSeconds(i);
    Dec(ANumber, i * IdMillisecondsInSecond);
  end;

  Inc(FMillisecond, ANumber);
  while FMillisecond > IdMillisecondsInSecond do
  begin
    AddSeconds(1);
    Dec(FMillisecond, IdMillisecondsInSecond);
  end;
end;

procedure TIdDateTimeStamp.AddMinutes;
begin
  while ANumber > MaxMinutesAdd do
  begin
    AddSeconds(MaxMinutesAdd);
    Dec(ANumber, MaxMinutesAdd);
  end;

  AddSeconds(ANumber * IdSecondsInMinute);
end;

procedure TIdDateTimeStamp.AddMonths;
var
  i: Integer;
begin
  i := ANumber div IdMonthsInYear;
  AddYears(i);
  Dec(ANumber, i * IdMonthsInYear);

  while ANumber > 0 do
  begin
    i := MonthOFYear;
    if i = 12 then
    begin
      i := 1;
    end;
    if (i = 2) and (IsLeapYear) then
    begin
      AddDays(IdDaysInMonth[i] + 1);
    end
    else
    begin
      AddDays(IdDaysInMonth[i]);
    end;

    Dec(ANumber);
  end;
end;

procedure TIdDateTimeStamp.AddSeconds;
var
  i: Cardinal;
begin
  i := ANumber div IdSecondsInDay;
  if i > 0 then
  begin
    AddDays(i);
    ANumber := ANumber - (i * IdSecondsInDay);
  end;

  Inc(FSecond, ANumber);
  while FSecond > IdSecondsInDay do
  begin
    AddDays(1);
    Dec(FSecond, IdSecondsInDay);
  end;
end;

procedure TIdDateTimeStamp.AddTDateTime;
begin
  AddTTimeStamp(DateTimeToTimeStamp(ADateTime));
end;

procedure TIdDateTimeStamp.AddTIdDateTimeStamp;
begin
  AddYears(AIdDateTime.Year);
  AddDays(AIdDateTime.Day);
  AddSeconds(AIdDateTime.Second);
  AddMilliseconds(AIdDateTime.Millisecond);
end;

procedure TIdDateTimeStamp.AddTTimeStamp;
var
  TId: TIdDateTimeStamp;
begin
{  TId := TIdDateTimeStamp.Create(Self);
  try
    TId.SetFromTTimeStamp(ATimeStamp);
    Self.AddTIdDateTimeStamp(TId);
  finally
    TId.Free;
  end;}
end;

procedure TIdDateTimeStamp.AddWeeks;
begin
  while ANumber > MaxWeekAdd do
  begin
    AddDays(MaxWeekAdd);
    Dec(ANumber, MaxWeekAdd);
  end;

  AddDays(ANumber * IdDaysInWeek);
end;

procedure TIdDateTimeStamp.AddYears;
begin
  if (FYear <= -1) and (Integer(ANumber) >= -FYear) then
  begin
    Inc(ANumber);
  end;
  Inc(FYear, ANumber);
  CheckLeapYear;
end;

procedure TIdDateTimeStamp.CheckLeapYear;
begin
  if FYear mod 4 = 0 then
  begin
    if FYear mod 100 = 0 then
    begin
      if FYear mod 400 = 0 then
      begin
        FIsLeapYear := True;
      end
      else
      begin
        FIsLeapYear := False;
      end;
    end
    else
    begin
      FIsLeapYear := True;
    end;
  end
  else
  begin
    FIsLeapYear := False;
  end;
end;

function TIdDateTimeStamp.GetAsISO8601Calendar;
begin
  result := IntToStr(FYear) + '-';
  result := result + IntToStr(MonthOFYear) + '-';
  result := result + IntToStr(DayOfMonth) + 'T';
  result := result + AsTimeOFDay;
end;

function TIdDateTimeStamp.GetAsISO8601Ordinal: string;
begin
  result := IntToStr(FYear) + '-';
  result := result + IntToStr(FDay) + 'T';
  result := result + AsTimeOFDay;
end;

function TIdDateTimeStamp.GetAsISO8601Week: string;
begin
  result := IntToStr(FYear) + '-W';
  result := result + IntToStr(WeekOFYear) + '-';
  result := result + IntToStr(DayOfWeek) + 'T';
  result := result + AsTimeOFDay;
end;

function TIdDateTimeStamp.GetAsRFC882;
begin
  result := IdDayShortNames[DayOfWeek] + ', ';
  result := result + IntToStr(DayOfMonth) + ' ';
  result := result + IdMonthShortNames[MonthOFYear] + ' ';
  result := result + IntToStr(Year) + ' ';
  result := result + AsTimeOFDay + ' ';
  if FTimeZone < -9 then
  begin
    result := result + IntToStr(FTimeZone) + '00';
  end
  else
    if FTimeZone > 9 then
  begin
    result := result + '+' + IntToStr(FTimeZone) + '00';
  end
  else
    if FTimeZone >= 0 then
  begin
    result := result + '+0' + IntToStr(FTimeZone) + '00';
  end
  else
  begin
    result := result + '-0' + IntToStr(0 - FTimeZone) + '00';
  end;

end;

function TIdDateTimeStamp.GetAsTDateTime;
begin
  result := TimeStampToDateTime(GetAsTTimeStamp);
end;

function TIdDateTimeStamp.GetAsTTimeStamp;
var
  NonLeap, Leap: Integer;
begin
  Leap := FYear div 400;
  NonLeap := (FYear div 100) - Leap;
  Leap := (FYear div 4) - NonLeap;
  result.Date := (Leap * IdDaysInLeapYear) + (NonLeap * IdDaysInYear) +
    Integer(FDay);
  result.Time := (FSecond * IdMillisecondsInSecond) + FMillisecond;
end;

function TIdDateTimeStamp.GetAsTimeOFDay;
var
  i: Integer;
begin
  i := HourOf24Day;
  if i < 10 then
  begin
    result := result + '0' + IntToStr(i) + ':';
  end
  else
  begin
    result := result + IntToStr(i) + ':';
  end;
  i := MinuteOfHour - 1;
  if i < 10 then
  begin
    result := result + '0' + IntToStr(i) + ':';
  end
  else
  begin
    result := result + IntToStr(i) + ':';
  end;
  i := SecondOfMinute - 1;
  if i < 10 then
  begin
    result := result + '0' + IntToStr(i) + ' ';
  end
  else
  begin
    result := result + IntToStr(i) + ' ';
  end;
end;

function TIdDateTimeStamp.GetBeatOFDay;
var
  i64: Int64;

begin
//  i64 := (FSecond) * IdBeatsInDay;
//  i64 := i64 div IdSecondsInDay;
//  result := Integer(i64);
end;

function TIdDateTimeStamp.GetDaysInYear;
begin
  if IsLeapYear then
  begin
    result := IdDaysInLeapYear;
  end
  else
  begin
    result := IdDaysInYear;
  end;
end;

function TIdDateTimeStamp.GetDayOfMonth;
var
  count, mnth, days: Integer;
begin
  mnth := MonthOFYear;
  if IsLeapYear and (mnth > 2) then
  begin
    days := 1;
  end
  else
  begin
    days := 0;
  end;
  for count := 1 to mnth - 1 do
  begin
    Inc(days, IdDaysInMonth[count]);
  end;
  days := Day - days;
  if days < 0 then
  begin
    result := 0;
  end
  else
  begin
    result := days;
  end;
end;

function TIdDateTimeStamp.GetDayOfWeek;
var
  a, y, m, d, mnth: Integer;
begin
  // Thanks to the "FAQ About Calendars" by Claus Tøndering for this algorithm
  // http://www.tondering.dk/claus/calendar.html
  mnth := MonthOFYear;
  a := (14 - mnth) div 12;
  y := Year - a;
  m := mnth + (12 * a) - 2;
  d := DayOfMonth + y + (y div 4) - (y div 100) + (y div 400) + ((31 * m) div
    12);
  d := d mod 7;
  result := d + 1;
end;

function TIdDateTimeStamp.GetDayOfWeekName;
begin
  result := IdDayNames[GetDayOfWeek];
end;

function TIdDateTimeStamp.GetDayOfWeekShortName;
begin
  result := IdDayShortNames[GetDayOfWeek];
end;

function TIdDateTimeStamp.GetHourOf12Day;
var
  hr: Integer;
begin
  hr := GetHourOf24Day;
  if hr > 12 then
  begin
    Dec(hr, 12);
  end;
  result := hr;
end;

function TIdDateTimeStamp.GetHourOf24Day;
begin
  result := (Second - 1) div IdSecondsInHour;
end;

function TIdDateTimeStamp.GetIsMorning;
begin
  if Second <= (IdSecondsInHalFDay + 1) then
  begin
    result := True;
  end
  else
  begin
    result := False;
  end;
end;

function TIdDateTimeStamp.GetMinuteOFDay;
begin
  result := Second div IdSecondsInMinute;
end;

function TIdDateTimeStamp.GetMinuteOfHour;
begin
  result := GetMinuteOFDay - (IdMinutesInHour * (GetHourOf24Day));
end;

function TIdDateTimeStamp.GetMonthOFYear;
var
  AddOne, Count: Byte;
  Today: Integer;
begin
  if IsLeapYear then
  begin
    AddOne := 1;
  end
  else
  begin
    AddOne := 0;
  end;
  Today := Day;
  Count := 1;
  result := 0;
  while Count <> 13 do
  begin
    if Count = 2 then
    begin
      if Today > IdDaysInMonth[Count] + AddOne then
      begin
        Dec(Today, IdDaysInMonth[Count] + AddOne);
      end
      else
      begin
        result := Count;
        break;
      end;
    end
    else
    begin
      if Today > IdDaysInMonth[Count] then
      begin
        Dec(Today, IdDaysInMonth[Count]);
      end
      else
      begin
        result := Count;
        break;
      end;
    end;
    Inc(Count);
  end;
end;

function TIdDateTimeStamp.GetMonthName;
begin
  result := IdMonthNames[MonthOFYear];
end;

function TIdDateTimeStamp.GetMonthShortName;
begin
  result := IdMonthShortNames[MonthOFYear];
end;

function TIdDateTimeStamp.GetSecondsInYear;
begin
  if IsLeapYear then
  begin
    result := IdSecondsInLeapYear;
  end
  else
  begin
    result := IdSecondsInYear;
  end;
end;

function TIdDateTimeStamp.GetSecondOfMinute;
begin
  result := FSecond - (GetMinuteOFDay * IdSecondsInMinute);
end;

function TIdDateTimeStamp.GetWeekOFYear;
var
  w: Integer;
  DT: TIdDateTimeStamp;
begin
{  DT := TIdDateTimeStamp.Create(Self);
  try
    DT.SetYear(Year);
    w := DT.DayOfWeek;
    w := w + Day - 2;
    w := w div 7;
    result := w + 1;
  finally
    DT.Free;
  end;}
end;

procedure TIdDateTimeStamp.SetFromTDateTime;
begin
  SetFromTTimeStamp(DateTimeToTimeStamp(ADateTime));
end;

procedure TIdDateTimeStamp.SetFromTTimeStamp;
begin
  SetYear(1);
  SetDay(1);
  SetSecond(0);
  SetMillisecond(ATimeStamp.Time);
  SetDay(ATimeStamp.Date);
end;

procedure TIdDateTimeStamp.SetDay;
begin
  FDay := 0;
  AddDays(ANumber);
end;

procedure TIdDateTimeStamp.SetMillisecond;
begin
  FMillisecond := 0;
  AddMilliseconds(ANumber);
end;

procedure TIdDateTimeStamp.SetSecond;
begin
  FSecond := 0;
  AddSeconds(ANumber);
end;

procedure TIdDateTimeStamp.SetYear;
begin
  if ANumber = 0 then
  begin
    exit;
  end;
  FYear := ANumber;
  CheckLeapYear;
end;

procedure TIdDateTimeStamp.SubtractDays;
var
  i: Integer;
begin
  if ANumber >= Cardinal(FDay - 1) then
  begin
    ANumber := ANumber - Cardinal(FDay - 1);
    FDay := 1;
  end
  else
  begin
    FDay := FDay - Integer(ANumber);
  end;

  if ANumber >= IdDaysInLeapYearCycle then
  begin
    i := ANumber div IdDaysInLeapYearCycle;
    SubtractYears(i * IdYearsInLeapYearCycle);
    ANumber := ANumber - Cardinal(i * IdDaysInLeapYearCycle);
  end;

  if ANumber >= IdDaysInLeapCentury then
  begin
    while ANumber >= IdDaysInLeapCentury do
    begin
      i := FYear div 100;

      if i mod 4 = 0 then
      begin
        SubtractYears(IdYearsInCentury);
        ANumber := ANumber - Cardinal(IdDaysInLeapCentury);
      end
      else
      begin
        SubtractYears(IdYearsInCentury);
        ANumber := ANumber - Cardinal(IdDaysInCentury);
      end;
    end;
  end;

  if ANumber >= IdDaysInShortLeapYearCycle then
  begin
    while ANumber >= IdDaysInShortLeapYearCycle do
    begin

      i := (FYear shr 2) shl 2;

      if SysUtils.IsLeapYear(i) then
      begin
        SubtractYears(IdYearsInShortLeapYearCycle);
        ANumber := ANumber - Cardinal(IdDaysInShortLeapYearCycle);
      end
      else
      begin
        SubtractYears(IdYearsInShortLeapYearCycle);
        ANumber := ANumber - Cardinal(IdDaysInShortNonLeapYearCycle);
      end;
    end;
  end;

  while ANumber > Cardinal(DaysInYear) do
  begin
    SubtractYears(1);
    Dec(ANumber, DaysInYear);
    if Self.IsLeapYear then
    begin
      AddDays(1);
    end;
  end;

  if ANumber >= Cardinal(FDay) then
  begin
    SubtractYears(1);
    ANumber := ANumber - Cardinal(FDay);
    Day := DaysInYear - Integer(ANumber);
  end
  else
  begin
    Dec(FDay, ANumber);
  end;

end;

procedure TIdDateTimeStamp.SubtractHours;
var
  i: Cardinal;
begin
  i := ANumber div IdHoursInDay;
  SubtractDays(i);
  Dec(ANumber, i * IdHoursInDay);

  SubtractSeconds(ANumber * IdSecondsInHour);
end;

procedure TIdDateTimeStamp.SubtractMilliseconds;
var
  i: Cardinal;
begin
  i := ANumber div IdMillisecondsInDay;
  SubtractDays(i);
  Dec(ANumber, i * IdMillisecondsInDay);

  i := ANumber div IdMillisecondsInSecond;
  SubtractSeconds(i);
  Dec(ANumber, i * IdMillisecondsInSecond);

  Dec(FMillisecond, ANumber);
  while FMillisecond <= 0 do
  begin
    SubtractSeconds(1);
    FMillisecond := IdMillisecondsInSecond - FMillisecond;
  end;
end;

procedure TIdDateTimeStamp.SubtractMinutes(ANumber: Cardinal);
begin
  while ANumber > MaxMinutesAdd do
  begin
    SubtractSeconds(MaxMinutesAdd * IdSecondsInMinute);
    Dec(ANumber, MaxMinutesAdd);
  end;
  SubtractSeconds(ANumber * IdSecondsInMinute);
end;

procedure TIdDateTimeStamp.SubtractMonths;
var
  i: Integer;
begin
  i := ANumber div IdMonthsInYear;
  SubtractYears(i);
  Dec(ANumber, i * IdMonthsInYear);

  while ANumber > 0 do
  begin
    i := MonthOFYear;
    if i = 1 then
    begin
      i := 13;
    end;
    if (i = 3) and (IsLeapYear) then
    begin
      SubtractDays(IdDaysInMonth[2] + 1);
    end
    else
    begin
      SubtractDays(IdDaysInMonth[i - 1]);
    end;
    Dec(ANumber);
  end;
end;

procedure TIdDateTimeStamp.SubtractSeconds(ANumber: Cardinal);
var
  i: Cardinal;
begin
  i := ANumber div IdSecondsInDay;
  SubtractDays(i);
  Dec(ANumber, i * IdSecondsInDay);

  Dec(FSecond, ANumber);
  if FSecond <= 0 then
  begin
    SubtractDays(1);
    FSecond := IdSecondsInDay + FSecond;
  end;
end;

procedure TIdDateTimeStamp.SubtractTDateTime;
begin
  SubtractTTimeStamp(DateTimeToTimeStamp(ADateTime));
end;

procedure TIdDateTimeStamp.SubtractTIdDateTimeStamp;
begin
  SubtractYears(AIdDateTime.Year);
  SubtractDays(AIdDateTime.Day);
  SubtractSeconds(AIdDateTime.Second);
  SubtractMilliseconds(AIdDateTime.Millisecond);
end;

procedure TIdDateTimeStamp.SubtractTTimeStamp;
var
  TId: TIdDateTimeStamp;
begin
{  TId := TIdDateTimeStamp.Create(Self);
  try
    TId.SetFromTTimeStamp(ATimeStamp);
    Self.SubtractTIdDateTimeStamp(TId);
  finally
    TId.Free;
  end;}
end;

procedure TIdDateTimeStamp.SubtractWeeks(ANumber: Cardinal);
begin
  while ANumber > MaxWeekAdd do
  begin
    SubtractDays(MaxWeekAdd * IdDaysInWeek);
    Dec(ANumber, MaxWeekAdd * IdDaysInWeek);
  end;
  SubtractDays(ANumber * IdDaysInWeek);
end;

procedure TIdDateTimeStamp.SubtractYears;
begin
  if (FYear > 0) and (ANumber >= Cardinal(FYear)) then
  begin
    Inc(ANumber);
  end;

  FYear := FYear - Integer(ANumber);
  CheckLeapYear;
end;

end.
