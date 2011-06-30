unit MCKMHIPEdit;
//  MHIPEdit Компонент (MHIPEdit Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 17-апр(apr)-2002
//  Дата коррекции (Last correction Date): 15-фев(feb)-2003
//  Версия (Version): 0.5
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//  Новое в (New in):
//  V0.5
//  [+++] Много чего, теперь реально полезен (Very much, realy usefull now) [KOLnMCK]
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V0.12
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)

interface

uses
    Windows, Controls, Classes,KOLMHIPEdit,mirror,KOL,Graphics;

type

  TField=class(TPersistent)
  private
    FUpRange:Byte;
    FDownRange:Byte;
    FValue:Byte;
    procedure SetUpRange(const Value:Byte);
    procedure SetDownRange(const Value:Byte);
    procedure SetValue(const Value:Byte);
  published
    property UpRange:Byte read FUpRange write SetUpRange;
    property DownRange:Byte read FDownRange write SetDownRange;
    property Value:Byte read FValue write SetValue;
  end;

  TKOLMHIPEdit = class(TKOLControl)
  private
    FFields:array [0..3] of TField;
    function GetField(const Index:Integer):TField;
    procedure SetField(const Index:Integer; const Value:TField);


  {
    // Фиктивное свойство
    FNotAvailable:Boolean;
    procedure SetMin(const Value:Integer);
    procedure SetMax(const Value:Integer);
    procedure SetOrientation(const Value:TTrackBarOrientation);
    procedure SetPosition(const Value:Integer);
    procedure SetSelStart(const Value:DWord);
    procedure SetSelEnd(const Value:DWord);
    procedure SetPageSize(const Value:DWord);
    procedure SetLineSize(const Value:DWord);
    procedure SetThumbLength(const Value:UINT);
    procedure SetFrequency(const Value:DWord);
    procedure SetTickMarks(const Value:TTickMark);
    procedure SetSliderVisible(const Value:Boolean);
    procedure SetBuddyLeftTop(const Value:TKOLControl);
    procedure SetBuddyRightBottom(const Value:TKOLControl);
//    procedure SetBuddy(const Value:Boolean);
//    procedure SetOnMouseMove(const Value: TOnMouse);}
  protected
    function  AdditionalUnits: string; override;
    procedure SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String); override;
//    procedure AssignEvents(SL: TStringList; const AName: String); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast(SL: TStringList; const AName,  AParent, Prefix: String); override;
    function SetupParams(const AName,AParent : String) : String; override;
    procedure Paint; override;

  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Field1: TField index 0 read GetField write SetField;
    property Field2: TField index 1 read GetField write SetField;
    property Field3: TField index 2 read GetField write SetField;
    property Field4: TField index 3 read GetField write SetField;
{

    property OnScroll;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
//    property OnEnter;
//    property OnLeave;
//    property OnScroll:TOnScroll read FOnScroll write SetOnScroll;
//    property OnMouseMove;: TOnMouse read FOnMouseMove write SetOnMouseMove;
    // Hide свойства
    // Т.е. они есть у TKOLControl, а у потомка не должны быть.
    // поэтому делаем их read-only и Object Inspector их не покажет
    property Caption:Boolean read FNotAvailable;
    property Color:Boolean read FNotAvailable;
    property Font:Boolean read FNotAvailable;

    property OnHide:Boolean read FNotAvailable;
    property OnShow:Boolean read FNotAvailable;
    property OnClick:Boolean read FNotAvailable;
    property OnMouseDblClk:Boolean read FNotAvailable;
 //   property Cursor_:Boolean read FNotAvailable;}
  end;

  procedure Register;

implementation

function Boolean2Str(B:Boolean):String;
begin
  if B then
    Result:='True'
  Else
    Result:='False';  
end;

function Orientation2Str(Orient:TTrackBarOrientation):String;
begin
  case Orient of
    trHorizontal: Result:='trHorizontal';
    trVertical: Result:='trVertical';
  end; //case
end;

function TickMark2Str(TickMarks:TTickMark):String;
begin
  case TickMarks of
    tmBottomRight:Result:='tmBottomRight';
    tmTopLeft:Result:='tmTopLeft';
    tmBoth:Result:='tmBoth';
  end; //case
end;

procedure TField.SetUpRange(const Value:Byte);
begin
  FUpRange:=Value;
end;

procedure TField.SetDownRange(const Value:Byte);
begin
  FDownRange:=Value;
end;

procedure TField.SetValue(const Value:Byte);
begin
  FValue:=Value;
end;

constructor TKOLMHIPEdit.Create(AOwner: TComponent);
var
  i:Integer;
begin
  inherited;
  For i:=0 to 3 do
    FFields[i]:=TField.Create;
  // VCL Default Values
{  FFrequency:=1;
  Height:=45;
  FLineSize:=1;
  FMax:=10;
  FMin:=0;
  FOrientation:=trHorizontal;
  FPageSize:=2;
  FSelEnd:=0;
  FSliderVisible:=True;
  FThumbLength:=20;
  FTickMarks:=tmBottomRight;
  FTickStyle:=tsAuto;
  Width:=150;}
end;

destructor TKOLMHIPEdit.Destroy;
var
  i:Integer;
begin
  For i:=0 to 3 do
    FFields[i].Free;
  inherited;
end;

procedure TKOLMHIPEdit.Paint;
var
  R:TRect;
  dsel:Integer;
  dv:Integer;
  mv:Real;
begin

{  R:=Rect(9,5,Width-9,5+3*ThumbLength div 4);
  DrawEdge(Canvas.Handle,R,EDGE_SUNKEN,BF_RECT);
  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color:=clWhite;
  R:=Rect(9+2,5+2,Width-9-2,5-2+3*ThumbLength div 4);
  Canvas.FillRect(R);
  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color:=clNavy;
  dsel:=SelEnd-SelStart;
  dv:=Max-Min;
  mv:=(Width-18-4-4)/dv;
  R:=Rect(9+2+2+Trunc(SelStart*mv),5+2+1,9+2+2+Trunc(SelEnd*mv),5-2-1+3*ThumbLength div 4);
  Canvas.FillRect(R);
 }
 inherited;
end;

procedure TKOLMHIPEdit.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := PMHIPEdit( New' + TypeName + '( '
          + SetupParams( AName, AParent ) + ' )' + S + ');' );
end;

{procedure TKOLMHDateTimePicker.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var
  TMPSD:TSystemTime;
  TMPDT:TDateTime;
  TMPStr:String;
begin
  inherited;
  if Format<>'' then
    SL.Add( Prefix + AName + '.Format:='''+Format+''';');
  if not Checked then
    SL.Add( Prefix + AName + '.Checked:='+Boolean2Str[Checked]+';');
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


end;  }

function TKOLMHIPEdit.SetupParams(const AName,AParent : String) : String;
{const
  DateMode2Str:array [TDateMode] of String=('dmComboBox','dmUpDown');
  DateFormat2Str:array [TDateFormat] of String=('dfShort','dfLong');
  DateTimeKind2Str:array [TDateTimeKind] of String=('dtkDate','dtkTime');
  CalAlignment2Str:array [TCalAlignment] of String=('dtaLeft','dtaRight');}
begin
  Result := AParent;// +', '+DateMode2Str[DateMode]+', '+DateFormat2Str[DateFormat]+', '+DateTimeKind2Str[Kind]+', '+Boolean2Str[ShowCheckbox]+', '+Boolean2Str[ParseInput]+', '+CalAlignment2Str[CalAlignment];
end;

(*procedure TKOLMHIPEdit.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
 // DoAssignEvents( SL, AName,['OnDropDown','OnCloseUp','OnUserString'{,'OnKeyDown'},'OnFormat','OnFormatQuery'],[@OnDropDown,@OnCloseUp,@OnUserString{,@OnKeyDown},@OnFormat,@OnFormatQuery]);
end;*)

function TKOLMHIPEdit.AdditionalUnits;
begin
   Result := ', KOLMHIPEdit';
end;

{procedure TKOLMHTrackBar.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnScroll'], [ @OnScroll] );
end;}

procedure TKOLMHIPEdit.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var
  i:Byte;
begin
  SL.Add('');
  inherited;
  SL.Add( Prefix + AName + '.CreateWindow;'); // Force Create
  for i:=0 to 3 do
  begin
//    if (FFields[i].UpRange<>255) then
      SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].UpRange:='+Int2Str(FFields[i].UpRange)+';');
//    if (FFields[i].DownRange<>0) then
      SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].DownRange:='+Int2Str(FFields[i].DownRange)+';');
    SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].Value:='+Int2Str(FFields[i].Value)+';');
  end;
//  if  (Field1.UpRange<>255) then
//    SL.Add( Prefix + AName + '.CalColors.TitleTextColor:='+Color2Str(CalColors.TitleTextColor)+';');
//  SL.Add('');
//  SL.Add(Prefix+AName+':=NewMHIPEdit('+AParent+');');
//  SL.Add(Prefix+AName+':=NewMHIPEdit('+AParent+','+Int2Str(Left)+', '+Int2Str(Top)+', '+Int2Str(Width)+', '+Int2Str(Height)+');');
 { For i:=0 to 3 do
  begin
    SL.Add(Prefix+AName+'.Field'+Int2Str(i+1)+'.UpRange:='+Int2Str(FFields[i].UpRange)+';');
    SL.Add(Prefix+AName+'.Field'+Int2Str(i+1)+'.DownRange:='+Int2Str(FFields[i].DownRange)+';');
    SL.Add(Prefix+AName+'.Field'+Int2Str(i+1)+'.Value:='+Int2Str(FFields[i].Value)+';');
  end;}
{  if FMin<>0 then
    SL.Add(Prefix+AName+'.Min:='+Int2Str(FMin)+';');
  if FMax<>100 then
    SL.Add(Prefix+AName+'.Max:='+Int2Str(FMax)+';');
  if FThumbLength<>22 then
    SL.Add(Prefix+AName+'.ThumbLength:='+Int2Str(FThumbLength)+';');
  if (FSelStart<>0) and (FSelEnd<>0) and (FSelEnd>=FSelStart) then
  begin
    SL.Add(Prefix+AName+'.SelStart:='+Int2Str(FSelStart)+';');
    SL.Add(Prefix+AName+'.SelEnd:='+Int2Str(FSelEnd)+';');
  end;
  if FPageSize<>20 then
    SL.Add(Prefix+AName+'.PageSize:='+Int2Str(FPageSize)+';');
  if FLineSize<>1 then
    SL.Add(Prefix+AName+'.LineSize:='+Int2Str(FLineSize)+';');
  if FFrequency<>0 then
    SL.Add(Prefix+AName+'.Frequency:='+Int2Str(FFrequency)+';');
  SL.Add(Prefix+AName+'.Frequency:='+Int2Str(FFrequency)+';');

  if not Visible then
    SL.Add( Prefix + AName + '.Visible := False;' );
  if not IsCursorDefault then
    if Copy( Cursor_, 1, 4 ) = 'IDC_' then
      SL.Add( Prefix + AName + '.Cursor := LoadCursor( 0, ' + Cursor_ + ' );' )
    else
      SL.Add( Prefix + AName + '.Cursor := LoadCursor( hInstance, ''' + Trim( Cursor_ ) + ''' );' );}
//  SL.Add(Prefix+AName+'.Cursor_:='+Cursor_+';');
//  AssignEvents( SL, AName );
end;

procedure TKOLMHIPEdit.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
var
  i:Integer;  
begin
  inherited;
  i:=0;

{  for i:=0 to 3 do
  begin
//    if (FFields[i].UpRange<>255) then
      SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].UpRange:='+Int2Str(FFields[i].UpRange)+';');
//    if (FFields[i].DownRange<>0) then
      SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].DownRange:='+Int2Str(FFields[i].DownRange)+';');
    SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].Value:='+Int2Str(FFields[i].Value)+';');
  end;   }
//  for i:=0 to 3 do
  begin
 //   if (FFields[i].UpRange<>255) then
//      SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].UpRange:='+Int2Str(FFields[i].UpRange)+';');
//    if (FFields[i].DownRange<>0) then
//      SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].DownRange:='+Int2Str(FFields[i].DownRange)+';');
//    SL.Add( Prefix + AName + '.Fields['+Int2Str(i)+'].Value:='+Int2Str(FFields[i].Value)+';');
  end;
//  if FBuddyLeftTop<>nil then
//    SL.Add(Prefix+AName+'.BuddyLeftTop:='+Int2Str(FBuddyLeftTop.Handle)+';');
//  if FBuddyRightBottom<>nil then
//  SL.Add(Prefix+AName+'.BuddyRightBottom:='+Int2Str(FBuddyRightBottom.Handle)+';');
end;

{procedure TKOLMHTrackBar.SetMin(const Value:Integer);
begin
  FMin:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetMax(const Value:Integer);
begin
  FMax:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetOrientation(const Value:TTrackBarOrientation);
begin
  FOrientation:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetPosition(const Value:Integer);
begin
  FPosition:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetSelStart(const Value:DWord);
begin
  FSelStart:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetSelEnd(const Value:DWord);
begin
  FSelEnd:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetPageSize(const Value:DWord);
begin
  FPageSize:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetLineSize(const Value:DWord);
begin
  FLineSize:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetThumbLength(const Value:UINT);
begin
  FThumbLength:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetBuddyLeftTop(const Value:TKOLControl);
begin
  FBuddyLeftTop:=Value;
  Change;
end;

procedure TKOLMHTrackBar.SetBuddyRightBottom(const Value:TKOLControl);
begin
  FBuddyRightBottom:=Value;
  Change;
end;

procedure TKOLMHTrackBar.SetFrequency(const Value:DWord);
begin
  FFrequency:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetTickMarks(const Value:TTickMark);
begin
  FTickMarks:=Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetSliderVisible(const Value:Boolean);
begin
  FSliderVisible:=Value;
  Change;
  Invalidate;
end;}
{
procedure TKOLMHTrackBar.SetOnMouseMove(const Value: TOnMouse);
begin
  FOnMouseMove:=Value;
  Change;
end;
 }

function TKOLMHIPEdit.GetField(const Index:Integer):TField;
begin
  Result:=FFields[Index];
end;

procedure TKOLMHIPEdit.SetField(const Index:Integer; const Value:TField);
begin
  FFields[Index]:=Value;
  Change;
end;


procedure Register;
begin
  RegisterComponents('KOL WIN32', [TKOLMHIPEdit]);
end;

end.

