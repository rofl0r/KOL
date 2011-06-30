unit MCKMHDateTimePicker;
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

{$I KOLDEF.INC}

uses
  Windows, Controls, Classes, SysUtils, mirror, KOL, Graphics, MCKCtrls, KOLMHDateTimePicker,
  {$IFDEF _D6orHigher}
    // Delphi 6 Support
    DesignIntf, DesignEditors, DesignConst, Variants
  {$ELSE}
    DsgnIntf
  {$ENDIF};

type

  TKOLMHDateTimePicker = class;

  TMonthCalColors = class(TPersistent)
  private
    Owner: TKOLMHDateTimePicker;
    FBackColor: TColor;
    FTextColor: TColor;
    FTitleBackColor: TColor;
    FTitleTextColor: TColor;
    FMonthBackColor: TColor;
    FTrailingTextColor: TColor;
    procedure SetColor(Index: Integer; Value: TColor);
  public
    constructor Create(AOwner: TKOLMHDateTimePicker);
  published
    property BackColor: TColor index 0 read FBackColor write SetColor default clWindow;
    property TextColor: TColor index 1 read FTextColor write SetColor default clWindowText;
    property TitleBackColor: TColor index 2 read FTitleBackColor write SetColor default clActiveCaption;
    property TitleTextColor: TColor index 3 read FTitleTextColor write SetColor default clWhite;
    property MonthBackColor: TColor index 4 read FMonthBackColor write SetColor default clWhite;
    property TrailingTextColor: TColor index 5 read FTrailingTextColor
      write SetColor default clInactiveCaptionText;
  end;

{  TCalDayOfWeek = (dowMonday, dowTuesday, dowWednesday, dowThursday,
    dowFriday, dowSaturday, dowSunday, dowLocaleDefault);

  TOnGetMonthInfoEvent = procedure(Sender: TObject; Month: LongWord;
    var MonthBoldInfo: LongWord) of object;

  EDateTimeError = class(ECommonCalendarError);
  }
{!!!
  TDateTimeKind = (dtkDate, dtkTime);
  TDateMode = (dmComboBox, dmUpDown);
  TDateFormat = (dfShort, dfLong);
  TCalAlignment = (dtaLeft, dtaRight);
}
 { TDTParseInputEvent = procedure(Sender: TObject; const UserString: string;
    var DateAndTime: TDateTime; var AllowChange: Boolean) of object;

  TDateTimeColors = TMonthCalColors;  // for backward compatibility
 }
  TKOLMHDateTimePicker=class(TKOLControl)
  private
    FDateMode:TDateMode;
    FDateFormat:TDateFormat;

    FCalColors: TMonthCalColors;
    FCalAlignment: TCalAlignment;
{    FChanging: Boolean;  }
    FChecked: Boolean;
{    FDroppedDown: Boolean;}
    FKind: TDateTimeKind;
{    FLastChange: TSystemTime;}
    FParseInput: Boolean;
    FShowCheckbox: Boolean;
    FFormat:String;
{    FOnUserInput: TDTParseInputEvent;}
    FOnCloseUp:TOnEvent;
    FOnDropDown:TOnEvent;

    FOnUserString:TOnEvent;
//    FOnKeyDown:TOnEvent;
    FOnFormat:TOnEvent;
    FOnFormatQuery:TOnEvent;

{    FCalExceptionClass: ExceptClass;}
    FDateTime: TDateTime;
{    FEndDate: TDate;
    FFirstDayOfWeek: TCalDayOfWeek;}
    FMaxDateTime: TDateTime;
{    FMaxSelectRange: Integer;}
    FMinDateTime: TDateTime;
//    FDefaultDateTime:Boolean; // MCK Only
{    FMonthDelta: Integer;
    FMultiSelect: Boolean;
    FShowToday: Boolean;
    FShowTodayCircle: Boolean;
    FWeekNumbers: Boolean;
    FOnGetMonthInfo: TOnGetMonthInfoEvent;

 }

  // Фиктивное свойство
  FNotAvailable:Boolean;
  procedure SetDateMode(const Value:TDateMode);
  procedure SetDateFormat(const Value:TDateFormat);
  procedure SetKind(const Value:TDateTimeKind);
  procedure SetShowCheckbox(const Value:Boolean);
  procedure SetCalAlignment(const Value:TCalAlignment);
  procedure SetParseInput(const Value:Boolean);
  procedure SetFormat(const Value:String);
  procedure SetChecked(const Value:Boolean);
  procedure SetDateTime(const Value:TDateTime);
  procedure SetOnDropDown(const Value:TOnEvent);
  procedure SetOnCloseUp(const Value:TOnEvent);
  procedure SetMinDateTime(const Value:TDateTime);
  procedure SetMaxDateTime(const Value:TDateTime);
//  procedure SetDefaultDateTime(const Value:Boolean);
//  function DoStoreMinDate:Boolean;
//  function DoStoreMaxDate:Boolean;
  procedure SetOnUserString(const Value:TOnEvent);
//  procedure SetOnKeyDown(const Value:TOnEvent);
  procedure SetOnFormat(const Value:TOnEvent);
  procedure SetOnFormatQuery(const Value:TOnEvent);
  protected
    procedure AssignEvents(SL: TStringList; const AName: String);override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );override;
    function SetupParams(const AName,AParent : String) : String;override;
    function  AdditionalUnits: string; override;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property DateMode: TDateMode read FDateMode write SetDateMode;
    property DateFormat: TDateFormat read FDateFormat write SetDateFormat;
    property Kind:TDateTimeKind read FKind write SetKind;
    property ShowCheckbox:Boolean read FShowCheckbox write SetShowCheckbox;
    property CalAlignment:TCalAlignment read FCalAlignment write SetCalAlignment;
    property ParseInput:Boolean read FParseInput write SetParseInput;
    property Format:String read FFormat write SetFormat;
    property Checked:Boolean read FChecked write SetChecked;
    property DateTime:TDateTime read FDateTime write SetDateTime;
    property CalColors:TMonthCalColors read FCalColors write FCalColors;

    property MinDateTime:TDateTime read FMinDateTime write SetMinDateTime;
    property MaxDateTime:TDateTime read FMaxDateTime write SetMaxDateTime;
//    property defaultDateTime:Boolean read FDefaultDateTime write SetDefaultDateTime;
    property OnChange;
    property OnCloseUp:TOnEvent read FOnDropDown write SetOnDropDown;
    property OnDropDown:TOnEvent read FOnCloseUp write SetOnCloseUp;
    property OnUserString:TOnEvent read FOnUserString write SetOnUserString;
    property OnKeyDown;
    property OnChar;
    property OnKeyUp;
    property OnFormat:TOnEvent read FOnFormat write SetOnFormat;
    property OnFormatQuery:TOnEvent read FOnFormatQuery write SetOnFormatQuery;

    // Hide свойства
    // Т.е. они есть у TKOLControl, а у потомка не должны быть.
    // поэтому делаем их read-only и Object Inspector их не покажет
    property Caption:Boolean read FNotAvailable;
    property OnClick : Boolean read FNotAvailable;
    property OnMouseDblClick: Boolean read FNotAvailable;
    property TabStop;

  end;

  procedure Register;

implementation

const
  Boolean2Str:array [Boolean] of String=('False','True');

constructor TMonthCalColors.Create(AOwner: TKOLMHDateTimePicker);
begin
  Owner := AOwner;
  FBackColor := clWindow;
  FTextColor := clWindowText;
  FTitleBackColor := clActiveCaption;
  FTitleTextColor := clWhite;
  FMonthBackColor := clWhite;
  FTrailingTextColor := clInactiveCaptionText;
end;

procedure TMonthCalColors.SetColor(Index: Integer; Value: TColor);
begin
  case Index of
    0: FBackColor := Value;
    1: FTextColor := Value;
    2: FTitleBackColor := Value;
    3: FTitleTextColor := Value;
    4: FMonthBackColor := Value;
    5: FTrailingTextColor := Value;
  end;
  Owner.Change;
end;


constructor TKOLMHDateTimePicker.Create( AOwner: TComponent );
begin
inherited;
FCalColors:=TMonthCalColors.Create(Self);
Width := 150;
Height := 22;

//fPickerOptions := [piLongDate];
end;

{procedure TKOLMHDateTimePicker.SetOptions;
begin
   fPickerOptions := Value;
   Change;
end;

procedure TKOLMHDateTimePicker.SetFormat;
begin
  if Value <> fFormat then
    begin
      fFormat := Value;
      Change;
    end;
end;
 }

function TKOLMHDateTimePicker.AdditionalUnits;
begin
   Result := ', KOLMHDateTimePicker';
end;

procedure TKOLMHDateTimePicker.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := PMHDateTimePicker( New' + TypeName + '( '
          + SetupParams( AName, AParent ) + ' )' + S + ');' );
end;

procedure TKOLMHDateTimePicker.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var
  TMPSD:TSystemTime;
  TMPDT:TDateTime;
  TMPStr:String;
begin
  inherited;
  if Format<>'' then
    SL.Add( Prefix + AName + '.Format:='''+Format+''';');
  if CalColors.BackColor<>clWindow then
    SL.Add( Prefix + AName + '.CalColors.BackColor:='+Color2Str(CalColors.BackColor)+';');
  if CalColors.TextColor<>clWindowText then
    SL.Add( Prefix + AName + '.CalColors.TextColor:='+Color2Str(CalColors.TextColor)+';');
  if CalColors.TitleBackColor<>clActiveCaption then
    SL.Add( Prefix + AName + '.CalColors.TitleBackColor:='+Color2Str(CalColors.TitleBackColor)+';');
  if CalColors.TitleTextColor<>clWhite then
    SL.Add( Prefix + AName + '.CalColors.TitleTextColor:='+Color2Str(CalColors.TitleTextColor)+';');
  if CalColors.MonthBackColor<>clWhite then
    SL.Add( Prefix + AName + '.CalColors.MonthBackColor:='+Color2Str(CalColors.MonthBackColor)+';');
  if CalColors.TrailingTextColor<>clInactiveCaptionText then
    SL.Add( Prefix + AName + '.CalColors.TrailingTextColor:='+Color2Str(CalColors.TrailingTextColor)+';');

  if DateTime<>0.0 then
  begin
    SysUtils.DateTimeToSystemTime(DateTime,TMPSD);
    KOL.SystemTime2DateTime(TMPSD,TMPDT);
    TMPStr:=FloatToStr(TMPDT);
    StrReplace(TMPStr,',','.');
    SL.Add( Prefix + AName + '.DateTime:='+TMPStr+';');
  end;

  if MinDateTime<>0.0 then
  begin
    SysUtils.DateTimeToSystemTime(MinDateTime,TMPSD);
    KOL.SystemTime2DateTime(TMPSD,TMPDT);
    TMPStr:=FloatToStr(TMPDT);
    StrReplace(TMPStr,',','.');
    SL.Add( Prefix + AName + '.MinDateTime:='+TMPStr+';');
  end;

  if MaxDateTime<>0.0 then
  begin
    SysUtils.DateTimeToSystemTime(MaxDateTime,TMPSD);
    KOL.SystemTime2DateTime(TMPSD,TMPDT);
    TMPStr:=FloatToStr(TMPDT);
    StrReplace(TMPStr,',','.');
    SL.Add( Prefix + AName + '.MaxDateTime:='+TMPStr+';');
  end;

  if not Checked then
    SL.Add( Prefix + AName + '.Checked:='+Boolean2Str[Checked]+';');
end;

function TKOLMHDateTimePicker.SetupParams(const AName,AParent : String) : String;
const
  DateMode2Str:array [TDateMode] of String=('dmComboBox','dmUpDown');
  DateFormat2Str:array [TDateFormat] of String=('dfShort','dfLong');
  DateTimeKind2Str:array [TDateTimeKind] of String=('dtkDate','dtkTime');
  CalAlignment2Str:array [TCalAlignment] of String=('dtaLeft','dtaRight');
begin
  Result := AParent +', '+DateMode2Str[DateMode]+', '+DateFormat2Str[DateFormat]+', '+DateTimeKind2Str[Kind]+', '+Boolean2Str[ShowCheckbox]+', '+Boolean2Str[ParseInput]+', '+CalAlignment2Str[CalAlignment];
end;

procedure TKOLMHDateTimePicker.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,['OnDropDown','OnCloseUp','OnUserString'{,'OnKeyDown'},'OnFormat','OnFormatQuery'],[@OnDropDown,@OnCloseUp,@OnUserString{,@OnKeyDown},@OnFormat,@OnFormatQuery]);
end;

procedure TKOLMHDateTimePicker.SetDateMode(const Value:TDateMode);
begin
  FDateMode:=Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLMHDateTimePicker.SetDateFormat(const Value:TDateFormat);
begin
  FDateFormat:=Value;
  if Assigned(FKOLCtrl) then
    PMHDateTimePicker(FKOLCtrl).DateFormat:=FDateFormat;
  Change;
end;

procedure TKOLMHDateTimePicker.SetKind(const Value:TDateTimeKind);
begin
  FKind:=Value;
  if Assigned(FKOLCtrl) then
    PMHDateTimePicker(FKOLCtrl).Kind:=FKind;
  Change;
end;

procedure TKOLMHDateTimePicker.SetShowCheckbox(const Value:Boolean);
begin
  FShowCheckbox:=Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLMHDateTimePicker.SetCalAlignment(const Value:TCalAlignment);
begin
  FCalAlignment:=Value;
  Change;
end;

procedure TKOLMHDateTimePicker.SetParseInput(const Value:Boolean);
begin
  FParseInput:=Value;
  Change;
end;

procedure TKOLMHDateTimePicker.SetFormat(const Value:String);
begin
  FFormat:=Value;
  if Assigned(FKOLCtrl) then
    PMHDateTimePicker(FKOLCtrl).Format:=FFormat;
  Change;
end;

procedure TKOLMHDateTimePicker.SetChecked(const Value:Boolean);
begin
  FChecked:=Value;
  if Assigned(FKOLCtrl) then begin
    SetDateTime(FDateTime);
    PMHDateTimePicker(FKOLCtrl).Checked:=FChecked;
  end;
  Change;
end;

procedure TKOLMHDateTimePicker.SetDateTime(const Value:TDateTime);
begin
  FDateTime:=Value;
  if Assigned(FKOLCtrl) then begin
    if FDateTime <> 0 then
      PMHDateTimePicker(FKOLCtrl).DateTime:=FDateTime + VCLDate0
    else
      PMHDateTimePicker(FKOLCtrl).DateTime:=kol.Now;
    PMHDateTimePicker(FKOLCtrl).Checked:=FChecked;
  end;
  Change;
end;

procedure TKOLMHDateTimePicker.SetOnDropDown(const Value:TOnEvent);
begin
  FOnDropDown:=Value;
  Change;
end;

procedure TKOLMHDateTimePicker.SetOnCloseUp(const Value:TOnEvent);
begin
  FOnCloseUp:=Value;
  Change;
end;

procedure TKOLMHDateTimePicker.SetMinDateTime(const Value:TDateTime);
begin
  FMinDateTime:=Value;
  if Assigned(FKOLCtrl) then
    PMHDateTimePicker(FKOLCtrl).MinDateTime:=FMinDateTime;
  Change;
end;

procedure TKOLMHDateTimePicker.SetMaxDateTime(const Value:TDateTime);
begin
  FMaxDateTime:=Value;
  if Assigned(FKOLCtrl) then
    PMHDateTimePicker(FKOLCtrl).MaxDateTime:=FMaxDateTime;
  Change;
end;

procedure TKOLMHDateTimePicker.SetOnUserString(const Value:TOnEvent);
begin
  FOnUserString:=Value;
  Change;
end;

{procedure TKOLMHDateTimePicker.SetOnKeyDown(const Value:TOnEvent);
begin
  FOnKeyDown:=Value;
  Change;
end;}

procedure TKOLMHDateTimePicker.SetOnFormat(const Value:TOnEvent);
begin
  FOnFormat:=Value;
  Change;
end;

procedure TKOLMHDateTimePicker.SetOnFormatQuery(const Value:TOnEvent);
begin
  FOnFormatQuery:=Value;
  Change;
end;

procedure TKOLMHDateTimePicker.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl:=NewMHDateTimePicker(KOLParentCtrl, FDateMode, FDateFormat, FKind, FShowCheckbox, FParseInput, FCalAlignment);
end;

procedure TKOLMHDateTimePicker.KOLControlRecreated;
begin
  inherited;
  with PMHDateTimePicker(FKOLCtrl)^ do begin
    Checked:=FChecked;
    DateTime:=FDateTime;
    MinDateTime:=FMinDateTime;
    MaxDateTime:=FMaxDateTime;
    Format:=FFormat;
  end;
end;

function TKOLMHDateTimePicker.NoDrawFrame: Boolean;
begin
  Result:=True;
end;

{procedure TKOLMHDateTimePicker.SetDefaultDateTime(const Value:Boolean);
begin
  FDefaultDateTime:=Value;
  Change;
end;}

{function TKOLMHDateTimePicker.DoStoreMinDate: Boolean;
begin
  Result := FMinDateTime <> 0.0;
end;

function TKOLMHDateTimePicker.DoStoreMaxDate: Boolean;
begin
  Result := FMaxDateTime <> 0.0;
end;}

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TDateTime),TKOLMHDateTimePicker,'DateTime',TDateTimeProperty);
  RegisterPropertyEditor(TypeInfo(TDateTime),TKOLMHDateTimePicker,'MinDateTime',TDateTimeProperty);
  RegisterPropertyEditor(TypeInfo(TDateTime),TKOLMHDateTimePicker,'MaxDateTime',TDateTimeProperty);
  RegisterComponents('KOL Win32', [TKOLMHDateTimePicker]);
end;

end.

