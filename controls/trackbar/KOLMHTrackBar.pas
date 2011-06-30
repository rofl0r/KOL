unit KOLMHTrackBar;
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
  windows, messages, KOL;

type

  TTrackBarOrientation = (trHorizontal, trVertical);
  TTickMark = (tmBottomRight, tmTopLeft, tmBoth);
  TTickStyle = (tsNone, tsAuto, tsManual);
  TToolTipSide = (ttsBottomRight, ttsTopLeft);

  PMHTrackBar = ^TMHTrackBar;
  //   TOnScroll = procedure( Sender: PMHTrackbar; Code: Integer ) of object;

  TKOLMHTrackBar = PMHTrackBar;

  TMHTrackBar = object(TControl)
  private

    function GetVal(const Index: Integer): DWord;
    procedure SetVal(const Index: Integer; const Value: DWord);
    function GetHandle(const Index: Integer): HWnd;
    procedure SetHandle(const Index: Integer; const Value: HWnd);
    //     function GetOnScroll: TOnScroll;
    //     procedure SetOnScroll(const Value: TOnScroll);
    function GetSliderVisible: Boolean;
    //     procedure SetSliderVisible(const Value:Boolean);
    function GetTickMarks: TTickMark;
    //     procedure SetTickMarks(const Value:TTickMark);
    function GetFrequency: DWord;
    procedure SetFrequency(const Value: DWord);
    //     procedure SetOrientation(const Value:TTrackBarOrientation);
    function GetOrientation: TTrackBarOrientation;
    //     procedure SetUseToolTip(const Value:Boolean);
    function GetUseToolTip: Boolean;
    //     procedure SetTickStyle(const Value:TTickStyle);
    function GetTickStyle: TTickStyle;
    procedure SetToolTipOrientation(const Value: TToolTipSide);
    function GetToolTipOrientation: TToolTipSide;
    procedure SetUnicodeFormat(const Value: Boolean);
    function GetUnicodeFormat: Boolean;

  public
    //    procedure BeginUpdata;
    //    procedure EndUpdata;
    procedure ClearSel;
    procedure ClearTics;
    procedure SetSel(NewMin, NewMax: Word);
    procedure SetRange(NewMin, NewMax: Word);
    function GetChannelRect: TRect;
    function GetThumbRect: TRect;
    function GetNumTics: DWord;
    property Min: DWord index 0 read GetVal write SetVal;
    property Max: DWord index 1 read GetVal write SetVal;
    property Orientation: TTrackBarOrientation read GetOrientation; // write SetOrientation;
    property Position: DWord index 2 read GetVal write SetVal;
    property SelStart: DWord index 3 read GetVal write SetVal;
    property SelEnd: DWord index 4 read GetVal write SetVal;
    property PageSize: DWord index 5 read GetVal write SetVal;
    property LineSize: DWord index 6 read GetVal write SetVal;
    property ThumbLength: DWord index 7 read GetVal write SetVal;
    property ToolTipOrientation: TToolTipSide read GetToolTipOrientation write SetToolTipOrientation;
    property Frequency: DWord read GetFrequency write SetFrequency;
    property TickMarks: TTickMark read GetTickMarks; // write SetTickMarks;
    property SliderVisible: Boolean read GetSliderVisible; // write SetSliderVisible;
    property BuddyRightBottom: HWnd index 0 read GetHandle write SetHandle;
    property BuddyLeftTop: HWnd index 1 read GetHandle write SetHandle;
    property ToolTip: HWnd index 2 read GetHandle write SetHandle;
    //    property OnScroll:TOnScroll read GetOnScroll write SetOnScroll;
    property UseToolTip: Boolean read GetUseToolTip; // write SetUseToolTip;
    property UnicodeFormat: Boolean read GetUnicodeFormat write SetUnicodeFormat;
    property TickStyle: TTickStyle read GetTickStyle; // write SetTickStyle;
  end;

const
  // Done
  TRACKBAR_CLASS = 'msctls_trackbar32';

  // Done
  TBS_AUTOTICKS = $0001;
  TBS_VERT = $0002;
  TBS_HORZ = $0000;
  TBS_TOP = $0004;
  TBS_BOTTOM = $0000;
  TBS_LEFT = $0004;
  TBS_RIGHT = $0000;
  TBS_BOTH = $0008;
  TBS_NOTICKS = $0010;
  TBS_ENABLESELRANGE = $0020;
  TBS_FIXEDLENGTH = $0040;
  TBS_NOTHUMB = $0080;
  TBS_TOOLTIPS = $0100;

  TBM_GETPOS = WM_USER; // +
  TBM_GETRANGEMIN = WM_USER + 1; // +
  TBM_GETRANGEMAX = WM_USER + 2; // +
  TBM_GETTIC = WM_USER + 3;
  TBM_SETTIC = WM_USER + 4;
  TBM_SETPOS = WM_USER + 5; // +
  TBM_SETRANGE = WM_USER + 6; // +
  TBM_SETRANGEMIN = WM_USER + 7; // +
  TBM_SETRANGEMAX = WM_USER + 8; // +
  TBM_CLEARTICS = WM_USER + 9; // +
  TBM_SETSEL = WM_USER + 10; // +
  TBM_SETSELSTART = WM_USER + 11; // +
  TBM_SETSELEND = WM_USER + 12; // +
  TBM_GETPTICS = WM_USER + 14;
  TBM_GETTICPOS = WM_USER + 15;
  // Done
  TBM_GETNUMTICS = WM_USER + 16;
  TBM_GETSELSTART = WM_USER + 17;
  TBM_GETSELEND = WM_USER + 18;
  TBM_CLEARSEL = WM_USER + 19;
  TBM_SETTICFREQ = WM_USER + 20;
  TBM_SETPAGESIZE = WM_USER + 21;
  TBM_GETPAGESIZE = WM_USER + 22;
  TBM_SETLINESIZE = WM_USER + 23;
  TBM_GETLINESIZE = WM_USER + 24;
  TBM_GETTHUMBRECT = WM_USER + 25;
  TBM_GETCHANNELRECT = WM_USER + 26;
  TBM_SETTHUMBLENGTH = WM_USER + 27;
  TBM_GETTHUMBLENGTH = WM_USER + 28;
  TBM_SETTOOLTIPS = WM_USER + 29;
  TBM_GETTOOLTIPS = WM_USER + 30;
  TBM_SETTIPSIDE = WM_USER + 31;

  // Done
  TBTS_TOP = 0;
  TBTS_LEFT = 1;
  TBTS_BOTTOM = 2;
  TBTS_RIGHT = 3;

  // Done
  TBM_SETBUDDY = WM_USER + 32;
  TBM_GETBUDDY = WM_USER + 33;
  TBM_SETUNICODEFORMAT = CCM_SETUNICODEFORMAT;
  TBM_GETUNICODEFORMAT = CCM_GETUNICODEFORMAT;

  TB_LINEUP = 0;
  TB_LINEDOWN = 1;
  TB_PAGEUP = 2;
  TB_PAGEDOWN = 3;
  TB_THUMBPOSITION = 4;
  TB_THUMBTRACK = 5;
  TB_TOP = 6;
  TB_BOTTOM = 7;
  TB_ENDTRACK = 8;

  TBCD_TICS = $0001;
  TBCD_THUMB = $0002;
  TBCD_CHANNEL = $0003;

  SliderVisible2Style: array[Boolean] of DWord = (TBS_NOTHUMB, $0);
  Orientation2Style: array[TTrackBarOrientation] of DWord = (TBS_HORZ, TBS_VERT);
  TickMarks2Style: array[TTickMark] of DWord = (TBS_BOTTOM or TBS_RIGHT, TBS_TOP or TBS_LEFT, TBS_BOTH);
  UseToolTip2Style: array[Boolean] of DWord = ($0, TBS_TOOLTIPS);
  TickStyle2Style: array[TTickStyle] of DWord = (TBS_NOTICKS, TBS_AUTOTICKS, $0);
  ToolTipOrientation2Style: array[TToolTipSide] of DWord = (TBTS_BOTTOM or TBTS_RIGHT, TBTS_TOP or TBTS_LEFT);

function NewMHTrackBar(AParent: PControl; SliderVisible: Boolean; Orientation: TTrackBarOrientation; TickMarks: TTickMark; UseToolTip: Boolean; TickStyle: TTickStyle {; OnScroll: TOnScroll}): PMHTrackBar;

implementation

type
  PTrackbarData = ^TTrackbarData;
  TTrackbarData = packed record
    //    FBeginUpdata:Boolean;
    //    FOnScroll:TOnScroll;
    FOrientation: TTrackBarOrientation;
    FFrequency: DWord;
    FSliderVisible: Boolean;
    FUseToolTip: Boolean;
    FTickStyle: TTickStyle;
    FTickMarks: TTickMark;
    FToolTipOrientation: TToolTipSide;
  end;

function WndProcTrackbarParent(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Trackbar: PMHTrackbar;
  Bar: TScrollerBar;
begin
  Result := FALSE;
  if ((Msg.message = WM_HSCROLL) or (Msg.message = WM_VSCROLL)) and (Msg.lParam <> 0) then
  begin
    Trackbar := Pointer(GetProp(Msg.lParam, ID_SELF));
    if Trackbar <> nil then
    begin
      if Assigned(Trackbar.OnScroll) then
      begin
        if Msg.message = WM_VSCROLL then
          Bar := sbVertical
        else
          Bar := sbHorizontal;
        Trackbar.OnScroll(Trackbar, Bar, LoWord(Msg.wParam), HiWord(Msg.wParam));
      end;
    end;
  end;
end;

function NewMHTrackBar(AParent: PControl; SliderVisible: Boolean; Orientation: TTrackBarOrientation; TickMarks: TTickMark; UseToolTip: Boolean; TickStyle: TTickStyle {; OnScroll: TOnScroll}): PMHTrackBar;
var
  D: PTrackbarData;
begin
  DoInitCommonControls(ICC_BAR_CLASSES);
  Result := PMHTrackbar(_NewCommonControl(AParent, TRACKBAR_CLASS, WS_CHILD or WS_VISIBLE or TBS_FIXEDLENGTH or TickStyle2Style[TickStyle] or TBS_ENABLESELRANGE or Orientation2Style[Orientation] or UseToolTip2Style[UseToolTip] or TickMarks2Style[TickMarks] or SliderVisible2Style[SliderVisible], False, 0)); // not (trbNoBorder in Options), nil ) );
  GetMem(D, Sizeof(D^));
  Result.CustomData := D;
  //  D.FOnScroll:=OnScroll;
  D.FSliderVisible := SliderVisible;
  D.FUseToolTip := UseToolTip;
  D.FTickStyle := TickStyle;
  D.FOrientation := Orientation;
  //  D.FFrequency:=Frequency;
  D.FSliderVisible := SliderVisible;
  D.FUseToolTip := UseToolTip;
  D.FTickStyle := TickStyle;
  D.FTickMarks := TickMarks;
  //  D.FToolTipOrientation:=ToolTipOrientation;
  AParent.AttachProc(WndProcTrackbarParent);
end;

function TMHTrackbar.GetVal(const Index: Integer): DWord;
type
  RVal = packed record
    Com: DWord;
    Par1: Byte;
    Par2: Byte;
  end;
const
  Val: array[0..7] of RVal =
  (
    (Com: TBM_GETRANGEMIN; Par1: 0; Par2: 0),
    (Com: TBM_GETRANGEMAX; Par1: 0; Par2: 0),
    (Com: TBM_GETPOS; Par1: 0; Par2: 0),
    (Com: TBM_GETSELSTART; Par1: 0; Par2: 0),
    (Com: TBM_GETSELEND; Par1: 0; Par2: 0),
    (Com: TBM_GETPAGESIZE; Par1: 0; Par2: 0),
    (Com: TBM_GETLINESIZE; Par1: 0; Par2: 0),
    (Com: TBM_GETTHUMBLENGTH; Par1: 0; Par2: 0)
    );
begin
  with Val[Index] do
    Result := Perform(Com, Par1, Par2);
end;

procedure TMHTrackbar.SetVal(const Index: Integer; const Value: DWord);
type
  RVal = packed record
    Com: DWord;
    Use1: Byte;
    Use2: Byte;
    Par1: Byte;
    Par2: Byte;
  end;
const
  Val: array[0..7] of RVal =
  (
    (Com: TBM_SETRANGEMIN; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETRANGEMAX; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETPOS; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETSELSTART; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETSELEND; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETPAGESIZE; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETLINESIZE; Use1: 0; Use2: 1; Par1: 1; Par2: 0),
    (Com: TBM_SETTHUMBLENGTH; Use1: 1; Use2: 0; Par1: 0; Par2: 0)
    );
begin
  with Val[Index] do
    Perform(Com, Value * Use1 + Par1, Value * Use2 + Par2);
end;

function TMHTrackbar.GetHandle(const Index: Integer): HWnd;
const
  Mes: array[0..2] of DWord = (TBM_GETBUDDY, TBM_GETBUDDY, TBM_GETTOOLTIPS);
begin
  Result := Perform(Mes[Index], Index mod 2, 0);
end;

procedure TMHTrackbar.SetHandle(const Index: Integer; const Value: HWnd);
const
  Mes: array[0..2] of DWord = (TBM_SETBUDDY, TBM_SETBUDDY, TBM_SETTOOLTIPS);
begin
  Perform(Mes[Index], Index mod 2, Value);
end;

function TMHTrackBar.GetSliderVisible: Boolean;
var
  D: PTrackbarData;
begin
  D := CustomData;
  Result := D.FSliderVisible;
end;

{procedure TMHTrackBar.SetSliderVisible(const Value:Boolean);
var
  D:PTrackbarData;
begin
  D:=CustomData;
  D.FSliderVisible:=Value;
  Recreate;
end;}

function TMHTrackBar.GetFrequency: DWord;
var
  D: PTrackbarData;
begin
  D := CustomData;
  Result := D.FFrequency;
end;

procedure TMHTrackBar.SetFrequency(const Value: DWord);
var
  D: PTrackbarData;
begin
  D := CustomData;
  D.FFrequency := Value;
  Perform(TBM_SETTICFREQ, Value, 1);
end;

function TMHTrackBar.GetTickMarks: TTickMark;
begin
  Result := PTrackbarData(CustomData)^.FTickMarks;
end;

{procedure TMHTrackBar.SetTickMarks(const Value:TTickMark);
begin
  PTrackbarData(CustomData)^.FTickMarks:=Value;
  Recreate;
end;}

function TMHTrackBar.GetOrientation: TTrackBarOrientation;
begin
  Result := PTrackbarData(CustomData)^.FOrientation;
end;

{procedure TMHTrackBar.SetOrientation(const Value:TTrackBarOrientation);
begin
  PTrackbarData(CustomData)^.FOrientation:=Value;
  Recreate;
end;}

{function TMHTrackbar.GetOnScroll: TOnScroll;
var
  D:PTrackbarData;
begin
  D:=CustomData;
  Result:=D.FOnScroll;
end;            }

{procedure TMHTrackbar.SetOnScroll(const Value: TOnScroll);
var
  D:PTrackbarData;
begin
  D:=CustomData;
  D.FOnScroll:=Value;
end;         }

{procedure TMHTrackbar.BeginUpdata;
begin
  PTrackbarData(CustomData)^.FBeginUpdata:=True;
end;

procedure TMHTrackbar.EndUpdata;
begin
  PTrackbarData(CustomData)^.FBeginUpdata:=False;
end;
}

procedure TMHTrackbar.ClearSel;
begin
  Perform(TBM_CLEARSEL, 1, 0);
end;

procedure TMHTrackbar.ClearTics;
begin
  Perform(TBM_CLEARTICS, 1, 0);
end;

procedure TMHTrackbar.SetSel(NewMin, NewMax: Word);
begin
  Perform(TBM_SETSEL, 1, MakeLong(NewMin, NewMax));
end;

procedure TMHTrackbar.SetRange(NewMin, NewMax: Word);
begin
  Perform(TBM_SETRANGE, 1, MakeLong(NewMin, NewMax));
end;

function TMHTrackbar.GetChannelRect: TRect;
begin
  Perform(TBM_GETCHANNELRECT, 0, DWord(@Result));
end;

function TMHTrackbar.GetThumbRect: TRect;
begin
  Perform(TBM_GETTHUMBRECT, 0, DWord(@Result));
end;

function TMHTrackbar.GetNumTics: DWord;
begin
  Result := Perform(TBM_GETNUMTICS, 0, 0);
end;

{procedure TMHTrackbar.SetUseToolTip(const Value:Boolean);
begin  PTrackbarData(CustomData)^.FUseToolTip:=Value;
  ReCreate;
end;}

function TMHTrackbar.GetUseToolTip: Boolean;
begin
  Result := PTrackbarData(CustomData)^.FUseToolTip;
end;

{procedure TMHTrackbar.SetTickStyle(const Value:TTickStyle);
begin
  PTrackbarData(CustomData)^.FTickStyle:=Value;
  ReCreate;
end;}

function TMHTrackbar.GetTickStyle: TTickStyle;
begin
  Result := PTrackbarData(CustomData)^.FTickStyle;
end;

procedure TMHTrackbar.SetToolTipOrientation(const Value: TToolTipSide);
begin
  PTrackbarData(CustomData)^.FToolTipOrientation := Value;
  Perform(TBM_SETTIPSIDE, ToolTipOrientation2Style[Value], 0);
end;

function TMHTrackbar.GetToolTipOrientation: TToolTipSide;
begin
  Result := PTrackbarData(CustomData)^.FToolTipOrientation;
end;

procedure TMHTrackbar.SetUnicodeFormat(const Value: Boolean);
begin
  Perform(TBM_SETUNICODEFORMAT, DWord(Value), 0);
end;

function TMHTrackbar.GetUnicodeFormat: Boolean;
begin
  Result := Boolean(Perform(TBM_GETUNICODEFORMAT, 0, 0));
end;

end.

