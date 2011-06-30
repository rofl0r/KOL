unit MCKMHTrackBar;
//  MHTrackBar Компонент (MHTrackBar Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 7-дек(dec)-2002
//  Дата коррекции (Last correction Date): 16-авг(aug)-2003
//  Версия (Version): 0.996
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//    helpercode
//  Новое в (New in):
//  V0.996
//  [!] Исправил Buddy (Fix Buddy) <Thanks to helpercode> [MCK]
//
//  V0.995
//  [*] Поддержка KOLWrapper визуализации (KOLWrapper visualition support) [MCK]
//
//  V0.991
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V0.99
//  [+++] Очень много (Very much) [KOLnMCK]
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  V0.9
//  +Add Good Recreate
//  +Add Some Opti-z
//  V0.85
//  +Add OnChar
//  +Add OnMove
//  +Add OnMouseMove
//  +Add OnMouseUp
//  +Add OnMouseDown
//  +Add OnMouseWheel
//  +Add OnMouseEnter
//  +Add OnMouseLeave
//  +Add OnResize
//  +Add OnPaint
//  +Add OnDropFiles
//  V0.81
//  +Add OnKeyUp
//  +Add OnKeyDown
//  +Add OnMessage
//  V0.8
//  +Buddyes (MCK)
//  +Cursor
//  +Greater OnScroll
//  -Some Troubles with Buddyes on Design (long move)
//  -Some Troubles with Buddyes position then Hor TrackBar
//  V0.7
//  +OnScroll Event (But None-Good)
//  +Sel Bug Fix
//  +Default Win Values On  Create (Lite Code)
//  -Color Trouble
//  -Cursor Trouble
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Хороший Buddy (Pretty Buddy)
//  5. Hints (Hints)

interface

uses
  Windows, Controls, Classes, mirror, KOL, Graphics, MCKCtrls, KOLMHTrackBar;

type

  TKOLMHTrackBar = class(TKOLControl)
  private
    FMin: Integer; // View
    FMax: Integer; // View
    FOrientation: TTrackBarOrientation; // View
    FPosition: Integer; // View
    FFrequency: DWord; // View
    FPageSize: DWord;
    FTickMarks: TTickMark; // View
    FTickStyle: TTickStyle; // View
    FLineSize: DWord;
    FThumbLength: UINT; // View
    FSelStart: DWord; // View
    FSelEnd: DWord; // View
    FSliderVisible: Boolean; // View
    FBuddyLeftTop: TKOLControl; // View
    FBuddyRightBottom: TKOLControl; // View
    FUseToolTip: Boolean;
    FToolTip: TKOLControl;
    FToolTipOrientation: TToolTipSide;
    // Фиктивное свойство
    FNotAvailable: Boolean;
    procedure SetMin(const Value: Integer);
    procedure SetMax(const Value: Integer);
    procedure SetOrientation(const Value: TTrackBarOrientation);
    procedure SetPosition(const Value: Integer);
    procedure SetSelStart(const Value: DWord);
    procedure SetSelEnd(const Value: DWord);
    procedure SetPageSize(const Value: DWord);
    procedure SetLineSize(const Value: DWord);
    procedure SetThumbLength(const Value: UINT);
    procedure SetFrequency(const Value: DWord);
    procedure SetTickMarks(const Value: TTickMark);
    procedure SetSliderVisible(const Value: Boolean);
    procedure SetBuddyLeftTop(const Value: TKOLControl);
    procedure SetBuddyRightBottom(const Value: TKOLControl);
    //    procedure SetOnScroll(const Value: KOLMHTrackBar.TOnScroll);
    procedure SetUseToolTip(const Value: Boolean);
    procedure SetTickStyle(const Value: TTickStyle); // View
    procedure SetToolTip(const Value: TKOLControl);
    procedure SetToolTipOrientation(const Value: TToolTipSide);
  protected
    function AdditionalUnits: string; override;
    //    procedure AssignEvents(SL: TStringList; const AName: String); override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: string); override;
    function SetupParams(const AName, AParent: string): string; override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: string); override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: string); override;
    procedure CreateKOLControl(Recreating: Boolean); override;
    procedure KOLControlRecreated; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property UseToolTip: Boolean read FUseToolTip write SetUseToolTip;
    property ToolTip: TKOLControl read FToolTip write SetToolTip;
    property ToolTipOrientation: TToolTipSide read FToolTipOrientation write SetToolTipOrientation;
    property Min: Integer read FMin write SetMin;
    property Max: Integer read FMax write SetMax;
    property Orientation: TTrackBarOrientation read FOrientation write SetOrientation;
    property Position: Integer read FPosition write SetPosition;
    property SelStart: DWord read FSelStart write SetSelStart;
    property SelEnd: DWord read FSelEnd write SetSelEnd;
    property LineSize: DWord read FLineSize write SetLineSize;
    property PageSize: DWord read FPageSize write SetPageSize;
    property ThumbLength: DWord read FThumbLength write SetThumbLength;
    property Frequency: DWord read FFrequency write SetFrequency;
    property TickStyle: TTickStyle read FTickStyle write SetTickStyle;
    property TickMarks: TTickMark read FTickMarks write SetTickMarks;
    property SliderVisible: Boolean read FSliderVisible write SetSliderVisible;
    property BuddyLeftTop: TKOLControl read FBuddyLeftTop write SetBuddyLeftTop;
    property BuddyRightBottom: TKOLControl read FBuddyRightBottom write SetBuddyRightBottom;
    property OnScroll; //: KOLMHTrackBar.TOnScroll read FOnScroll write SetOnScroll;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    // Hide свойства
    // Т.е. они есть у TKOLControl, а у потомка не должны быть.
    // поэтому делаем их read-only и Object Inspector их не покажет
    property Caption: Boolean read FNotAvailable;
    property Font: Boolean read FNotAvailable;
    property OnClick: Boolean read FNotAvailable;
    property OnMouseDblClk: Boolean read FNotAvailable;
  end;

procedure Register;

implementation

function Orientation2Str(Orient: TTrackBarOrientation): string;
begin
  case Orient of
    trHorizontal: Result := 'trHorizontal';
    trVertical: Result := 'trVertical';
  end; //case
end;

function TickMark2Str(TickMarks: TTickMark): string;
begin
  case TickMarks of
    tmBottomRight: Result := 'tmBottomRight';
    tmTopLeft: Result := 'tmTopLeft';
    tmBoth: Result := 'tmBoth';
  end; //case
end;

constructor TKOLMHTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  // VCL Default Values
  FFrequency := 1;
  Height := 45;
  FLineSize := 1;
  FMax := 10;
  FMin := 0;
  FOrientation := trHorizontal;
  FPageSize := 2;
  FSelEnd := 0;
  FSliderVisible := True;
  FThumbLength := 20;
  FTickMarks := tmBottomRight;
  FTickStyle := tsAuto;
  Width := 150;
end;

function TKOLMHTrackBar.AdditionalUnits;
begin
  Result := ', KOLMHTrackBar';
end;

{procedure TKOLMHTrackBar.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnScroll'], [ @OnScroll] );
end;}

procedure TKOLMHTrackBar.SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: string);
var
  S: string;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := PMHTrackbar( New' + TypeName + '( '
    + SetupParams(AName, AParent) + ' )' + S + ');');
end;

procedure TKOLMHTrackBar.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: string);
const
  Boolean2Str: array[Boolean] of string = ('False', 'True');
  ToolTipOrientation2Str: array[TToolTipSide] of string = ('ttsBottomRight', 'ttsTopLeft');
begin
  inherited;
  if Min <> 0 then
    SL.Add(Prefix + AName + '.Min:=' + Int2Str(Min) + ';');
  if Max <> 100 then
    SL.Add(Prefix + AName + '.Max:=' + Int2Str(Max) + ';');
  if ThumbLength <> 22 then
    SL.Add(Prefix + AName + '.ThumbLength:=' + Int2Str(ThumbLength) + ';');
  if PageSize <> 20 then
    SL.Add(Prefix + AName + '.PageSize:=' + Int2Str(PageSize) + ';');
  if LineSize <> 1 then
    SL.Add(Prefix + AName + '.LineSize:=' + Int2Str(LineSize) + ';');
  if Frequency <> 0 then
    SL.Add(Prefix + AName + '.Frequency:=' + Int2Str(Frequency) + ';');
  if ToolTipOrientation <> ttsTopLeft then
    SL.Add(Prefix + AName + '.ToolTipOrientation:=' + ToolTipOrientation2Str[ToolTipOrientation] + ';');
  if Position <> 0 then
    SL.Add(Prefix + AName + '.Position:=' + Int2Str(Position) + ';');
  if (SelEnd <> 0) and (SelEnd >= SelStart) then
  begin
    SL.Add(Prefix + AName + '.SelStart:=' + Int2Str(SelStart) + ';');
    SL.Add(Prefix + AName + '.SelEnd:=' + Int2Str(SelEnd) + ';');
  end;
end;

function TKOLMHTrackBar.SetupParams(const AName, AParent: string): string;
const
  Boolean2Str: array[Boolean] of string = ('False', 'True');
  TickStyle2Str: array[TTickStyle] of string = ('tsNone', 'tsAuto', 'tsManual');
begin

  Result := AParent + ', ' + Boolean2Str[SliderVisible] + ', ' + Orientation2Str(FOrientation) + ', ' + TickMark2Str(TickMarks) + ', ' + Boolean2Str[UseToolTip] + ', ' + TickStyle2Str[TickStyle]; //+', ';
  {  if TMethod( OnScroll ).Code <> nil then
      Result := Result + 'Result.' + ParentForm.MethodName( TMethod( OnScroll ).Code )
    else
      Result := Result + 'nil';}
end;

procedure TKOLMHTrackBar.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: string);
begin
  inherited;
  if FBuddyLeftTop <> nil then
    SL.Add(Prefix + AName + '.BuddyLeftTop:=Result.' + FBuddyLeftTop.Name + '.GetWindowHandle;');
  if FBuddyRightBottom <> nil then
    SL.Add(Prefix + AName + '.BuddyRightBottom:=Result.' + FBuddyRightBottom.Name + '.GetWindowHandle;');
  if FToolTip <> nil then
    SL.Add(Prefix + AName + '.ToolTip:=Result.' + FToolTip.Name + '.GetWindowHandle;');
end;

procedure TKOLMHTrackBar.SetMin(const Value: Integer);
begin
  FMin := Value;
  PMHTrackBar(FKOLCtrl).Min := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetMax(const Value: Integer);
begin
  FMax := Value;
  PMHTrackBar(FKOLCtrl).Max := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetOrientation(const Value: TTrackBarOrientation);
begin
  FOrientation := Value;
  RecreateWnd;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetPosition(const Value: Integer);
begin
  FPosition := Value;
  PMHTrackBar(FKOLCtrl).Position := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetSelStart(const Value: DWord);
begin
  FSelStart := Value;
  PMHTrackBar(FKOLCtrl).SelStart := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetSelEnd(const Value: DWord);
begin
  FSelEnd := Value;
  PMHTrackBar(FKOLCtrl).SelEnd := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetPageSize(const Value: DWord);
begin
  FPageSize := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetLineSize(const Value: DWord);
begin
  FLineSize := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetThumbLength(const Value: UINT);
begin
  FThumbLength := Value;
  PMHTrackBar(FKOLCtrl).ThumbLength := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetBuddyLeftTop(const Value: TKOLControl);
begin
  if Value <> nil then
  begin
    if (FBuddyLeftTop <> Value) and not (csLoading in ComponentState) then
      PMHTrackBar(FKOLCtrl).BuddyLeftTop := Value.Handle;
  end
  else
  begin
    PMHTrackBar(FKOLCtrl).BuddyLeftTop := 0;
  end;
  FBuddyLeftTop := Value;
  Change;
end;

procedure TKOLMHTrackBar.SetBuddyRightBottom(const Value: TKOLControl);
begin
  if Value <> nil then
  begin
    if (FBuddyRightBottom <> Value) and not (csLoading in ComponentState) then
      PMHTrackBar(FKOLCtrl).BuddyRightBottom := Value.Handle;
  end
  else
  begin
    PMHTrackBar(FKOLCtrl).BuddyRightBottom := 0;
  end;
  FBuddyRightBottom := Value;
  Change;
end;

procedure TKOLMHTrackBar.SetFrequency(const Value: DWord);
begin
  FFrequency := Value;
  PMHTrackBar(FKOLCtrl).Frequency := Value;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetTickMarks(const Value: TTickMark);
begin
  FTickMarks := Value;
  RecreateWnd;
  Change;
  Invalidate;
end;

procedure TKOLMHTrackBar.SetSliderVisible(const Value: Boolean);
begin
  FSliderVisible := Value;
  RecreateWnd;
  Change;
  Invalidate;
end;

{procedure TKOLMHTrackBar.SetOnScroll(const Value: TOnScroll);
begin
  FOnScroll := Value;
  Change;
end;}
{
procedure TKOLMHTrackBar.SetOnMouseMove(const Value: TOnMouse);
begin
  FOnMouseMove:=Value;
  Change;
end;
    }

procedure TKOLMHTrackBar.SetUseToolTip(const Value: Boolean);
begin
  FUseToolTip := Value;
  Change;
end;

procedure TKOLMHTrackBar.SetToolTip(const Value: TKOLControl);
begin
  FToolTip := Value;
  Change;
end;

procedure TKOLMHTrackBar.SetToolTipOrientation(const Value: TToolTipSide);
begin
  FToolTipOrientation := Value;
  Change;
end;

procedure TKOLMHTrackBar.SetTickStyle(const Value: TTickStyle);
begin
  FTickStyle := Value;
  RecreateWnd;
  Change;
end;

procedure TKOLMHTrackBar.CreateKOLControl(Recreating: Boolean);
begin
  FKOLCtrl := PControl(NewMHTrackBar(KOLParentCtrl, SliderVisible, Orientation, TickMarks, UseToolTip, TickStyle));
end;

procedure TKOLMHTrackBar.KOLControlRecreated;
begin
  inherited;
  PMHTrackBar(FKOLCtrl).Min := Min;
  PMHTrackBar(FKOLCtrl).Max := Max;
  // PMHTrackBar(FKOLCtrl).Orientation:=Orientation;
  PMHTrackBar(FKOLCtrl).Position := Position;
  PMHTrackBar(FKOLCtrl).Frequency := Frequency;
  // PMHTrackBar(FKOLCtrl).PageSize:=PageSize;
  // PMHTrackBar(FKOLCtrl).TickMarks:=TickMark;
  // PMHTrackBar(FKOLCtrl).TickStyle:=TickStyle;
  // PMHTrackBar(FKOLCtrl).LineSize:=LineSize;
  PMHTrackBar(FKOLCtrl).ThumbLength := ThumbLength;
  PMHTrackBar(FKOLCtrl).SelStart := SelStart;
  PMHTrackBar(FKOLCtrl).SelEnd := SelEnd;
  //  // PMHTrackBar(FKOLCtrl).SliderVisible:=SliderVisible;
  if Assigned(BuddyLeftTop) then
    PMHTrackBar(FKOLCtrl).BuddyLeftTop := BuddyLeftTop.Handle
  else
    PMHTrackBar(FKOLCtrl).BuddyLeftTop := 0;
  if Assigned(BuddyRightBottom) then
    PMHTrackBar(FKOLCtrl).BuddyRightBottom := BuddyRightBottom.Handle
  else
    PMHTrackBar(FKOLCtrl).BuddyRightBottom := 0;
  {  // PMHTrackBar(FKOLCtrl).UseToolTip:Boolean;
    // PMHTrackBar(FKOLCtrl).ToolTip:TKOLControl;
    // PMHTrackBar(FKOLCtrl).ToolTipOrientation:TToolTipSide;}
end;

procedure Register;
begin
  RegisterComponents('KOL WIN32', [TKOLMHTrackBar]);
end;

end.

