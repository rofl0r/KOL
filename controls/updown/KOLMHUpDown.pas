unit KOLMHUpDown;
{* TKOLMHUpDown object}
//  MHUpDown Компонент (MHUpDown Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 26-апр(apr)-2002
//  Дата коррекции (Last correction Date): 5-авг(aug)-2003
//  Версия (Version): 1.31
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexander Pravdin
//    Bogusіaw Brandys
//    dominiko-m
//  Новое в (New in):
//
//  V1.31
//  [!] Исправлено "отъедание" Buddy (Buddy "eating" FIX) <Great Thanks to dominiko-m> [MCK]
//
//  V1.3
//  [*] Поддержка KOLWrapper визуализации (KOLWrapper visualition support) [MCK]
//
//  V1.22
//  [!] Совместимость с Хинтами (ToolTips compatability) [KOL]
//
//  V1.21
//  [!] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.2
//  [!] Исправлена ошибка BuddySize (Fix BuddySize) [MCK]
//
//  V1.1
//  [!] Исправления Buddy (Fixed Buddy) <Great Thanks to Alexander Pravdin> [MCK]
//  [!] Исправлена ошибка Increment=0 (Increment=0 bug fixed) <Great Thanks to Alexander Pravdin> [MCK]
//  [-] Найдена ошибка BuddySize (Bug BuddySize found) [MCK]
//
//  V1.0
//  [+~] Событие OnChangingEx (OnChangingEx event) <Thanks to Bogusіaw Brandys> [KOLnMCK]
//  [+~] Свойство Increment (Increment property) <Thanks to Bogusіaw Brandys> [KOLnMCK]
//  [*] Теперь поддерживаются 32бит значения Position (32bit position support now) [KOLnMCK]
//
//  V0.9
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//  [+++] Очень много (Very much) [KOLnMCK]
//
//  V0.4
//  +Add Recreate
//  +Optimize Visible (may usefull for all KOL)
//  +Fix Double (KOL)
//  +Add HotTrack
//  +Add BuddyInteger
//  +Add ButtonAlign
//  +Add AutoBuddy
//  +Add Wrap Better
//  +Add Thousands Better
//  +Add ArrowKeys
//  +Add Orient Better
//  -Some Bug Buddy (Buddy Object Become smaller, and YourSelf can't be Buddy)
//  V0.21
//  +Add Updata Paint (for KOLnMCK 1.30)
//  +Add Improve Paint
//  V0.20
//  +Add Enabled
//  +Add EraseBgr
//  +Add Tag
//  V0.19
//  +Add HexBase
//  +Add OnMove
//  +Add OnFileDrop
//  +Add OnPaint
//  V0.18
//  +Add OnMouseMove
//  +Add OnMouseUp
//  +Add OnMouseDown
//  +Add OnMouseLeave
//  +Add OnMouseEnter
//  +Add OnResize
//  +Add OnHide
//  +Add OnShow
//  V0.17
//  +Add Buddy
//  +Add Default Values
//  V0.15
//  +Add Better Paint
//  V0.1
//  +Add OnScroll
//  +Add so-so Paint (MCK)
//  +Add Min/Max/Position/Wrap/Orientation/Thousands
//  +Add Cursor
//  +Add Visible
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Ошибки (Errors)
//  4. События (Events)
//  5. Справка (Help)

interface
uses
  KOL, Windows, Messages {, KOLMHToolTip};

const
  REFRESH_PERIOD: Cardinal = 1;
  {* Amount of elapsed time, in seconds, before the position
  change increment is used.}

type
  TUpDownAlignButton = (udLeft, udRight);
  {*}
  TUpDownOrientation = (udHorizontal, udVertical);
  {*}
  TUpDownDirection = (updNone, updUp, updDown);
  {*}
  TOnChangingEx = procedure(Sender: PObj; var Allow: Boolean; NewValue:
    SmallInt; Direction: TUpDownDirection) of object;
  {*}

type
  NM_UPDOWN = packed record
    hdr: TNMHDR;
    iPos: Integer;
    iDelta: Integer;
  end;
  TNMUpDown = NM_UPDOWN;
  PNMUpDown = ^TNMUpDown;

type
  UDACCEL = packed record
    nSec: UINT;
    nInc: UINT;
  end;
  TUDAccel = UDACCEL;
  PUDAccel = ^TUDAccel;

  PMHUpDown = ^TMHUpDown;
  TKOLMHUpDown = PMHUpDown;
  TMHUpDown = object(TControl)
    {*}
  private
    function GetHexBase: Boolean;
    procedure SetHexBase(const Value: Boolean);

    function GetBuddy: HWnd;
    procedure SetBuddy(const Value: HWnd);

    procedure SetMin(const Value: Integer);
    function GetMin: Integer;

    procedure SetMax(const Value: Integer);
    function GetMax: Integer;

    procedure SetPosition(const Value: Integer);
    function GetPosition: Integer;

    procedure SetIncrement(const Value: Integer);
    function GetIncrement: Integer;

    procedure SetOnChangingEx(const Value: TOnChangingEx);
    function GetOnChangingEx: TOnChangingEx;

    function GetOrientation: TUpDownOrientation;

    function GetArrowKeys: Boolean;

    function GetAlignButton: TUpDownAlignButton;

    function GetAutoBuddy: Boolean;

    function GetThousands: Boolean;

    function GetWrap: Boolean;

    function GetHotTrack: Boolean;

  public
    property Min: Integer read GetMin write SetMin;
    {* Specifies the minimum value of the Position property.}
    property Max: Integer read GetMax write SetMax;
    {* Specifies the maximum value of the Position property.}
    property Position: Integer read GetPosition write SetPosition;
    {* Current updown value}
    property Increment: Integer read GetIncrement write SetIncrement;
    {* Specifies the amount the Position value changes each time the up or down button is pressed.}
    property Buddy: HWnd read GetBuddy write SetBuddy;
    {* Companion control for updown}
    property Orientation: TUpDownOrientation read GetOrientation;
    {* Orientation of updown arrows}
    property ArrowKeys: Boolean read GetArrowKeys;
    {* The updown control receives input from the Up arrow and Down arrow keys.}
    property AlignButton: TUpDownAlignButton read GetAlignButton;
    {* The position of the up-down control can be relative to its companion (buddy) control.
    Updown button can be placed on right or left side of buddy control}
    property AutoBuddy: Boolean read GetAutoBuddy;
    {* Automatically arrange to last control in Z-Order}
    property Thousands: Boolean read GetThousands;
    {* Determines whether a thousands separator appears between every three digits of a decimal string.}
    property Wrap: Boolean read GetWrap;
    {* Use Wrap to specify whether the up-down control treats the range determined
     by the Max and Min properties as a continuous loop.}
    property HexBase: Boolean read GetHexBase write SetHexBase;
    {* Hexadecimal units}
    property HotTrack: Boolean read GetHotTrack;
    {*}
    property OnChangingEx: TOnChangingEx read GetOnChangingEx write
      SetOnChangingEx;
    {* Event fired when position is about to change.Could be used to disallow change
     of Position property.}
  end;

const
  UPDOWN_CLASS = 'msctls_updown32';

  UDN_FIRST = 0 - 721;

  UD_MAXVAL = $7FFF;
  UD_MINVAL = -UD_MAXVAL;

  UDS_WRAP = $0001;
  UDS_SETBUDDYINT = $0002;
  UDS_ALIGNRIGHT = $0004;
  UDS_ALIGNLEFT = $0008;
  UDS_AUTOBUDDY = $0010;
  UDS_ARROWKEYS = $0020;
  UDS_HORZ = $0040;
  UDS_NOTHOUSANDS = $0080;
  UDS_HOTTRACK = $0100;

  UDM_SETRANGE = WM_USER + 101;
  UDM_GETRANGE = WM_USER + 102;
  UDM_SETPOS = WM_USER + 103;
  UDM_GETPOS = WM_USER + 104;
  UDM_SETBUDDY = WM_USER + 105;
  UDM_GETBUDDY = WM_USER + 106;
  UDM_SETACCEL = WM_USER + 107;
  UDM_GETACCEL = WM_USER + 108;
  UDM_SETBASE = WM_USER + 109;
  UDM_GETBASE = WM_USER + 110;
  UDM_SETRANGE32 = WM_USER + 111;
  UDM_GETRANGE32 = WM_USER + 112;
  UDM_SETPOS32 = WM_USER + 113;
  UDM_GETPOS32 = WM_USER + 114;
  UDN_DELTAPOS = UDN_FIRST - 1;

  Thousands2Style: array[Boolean] of DWord = (UDS_NOTHOUSANDS, $0);
  Wrap2Style: array[Boolean] of DWord = ($0, UDS_WRAP);
  ArrowKeys2Style: array[Boolean] of DWord = ($0, UDS_ARROWKEYS);
  Orientation2Style: array[TUpDownOrientation] of DWord = (UDS_HORZ, $0);
  AlignButton2Style: array[TUpDownAlignButton] of DWord = (UDS_ALIGNLEFT,
    UDS_ALIGNRIGHT);
  AutoBuddy2Style: array[Boolean] of DWord = ($0, UDS_AUTOBUDDY);
  HotTrack2Style: array[Boolean] of DWord = ($0, UDS_HOTTRACK);
  Visible2Style: array[Boolean] of DWord = ($0, WS_VISIBLE);

function NewMHUpDown(AParent: PControl; Orientation: TUpDownOrientation; Wrap,
  Thousands, ArrowKeys, AutoBuddy, HotTrack, BuddyInteger: Boolean; AlignButton:
  TUpDownAlignButton): PControl;

implementation

type
  PUpDownData = ^TUpDownData;
  TUpDownData = packed record
    FOrientation: TUpDownOrientation;
    FArrowKeys: Boolean;
    FHotTrack: Boolean;
    FAutoBuddy: Boolean;
    FThousands: Boolean;
    FWrap: Boolean;
    FAlignButton: TUpDownAlignButton;
    FOnChangingEx: TOnChangingEx;
    FMin: Integer;
    FMax: Integer;
  end;

function WndProcUpDown(Sender: PControl; var Msg: TMsg; var Rslt: Integer):
  Boolean;
var
  UpDownNow: PMHUpDown;
  NMUpDown: PNMUpDown;
  Allow: Boolean;
  Direction: TUpDownDirection;
  NewValue: Integer;
  Data: PUpDownData;
begin
  Result := FALSE;
  Allow := True;
  if (Msg.message = WM_NOTIFY) and (Msg.lParam <> 0) then
  begin
    NMUpDown := PNMUpDown(Msg.lParam);
    UpDownNow := PMHUpDown(Sender);
    Data := UpDownNow.CustomData;
    if NMUpDown.hdr.code = UDN_DELTAPOS then
    begin
      if Assigned(UpDownNow) then
      begin
        if Assigned(Data^.FOnChangingEx) then
        begin
          if NMUpDown.iDelta = 0 then
            Direction := updNone
          else
          begin
            if NMUpDown.iDelta < 0 then
              Direction := updDown
            else
              Direction := updUp;
          end;
          NewValue := NMUpDown.iPos + NMUpDown.iDelta;
          if NewValue > Data^.FMax then
            NewValue := Data^.FMax;
          if NewValue < Data^.FMin then
            NewValue := Data^.FMin;
          Data^.FOnChangingEx(PObj(UpDownNow), Allow, NewValue, Direction);
          Result := true;
          if not Allow then
            Rslt := 1
          else
            Rslt := 0;
        end;
      end;
    end;
  end;
end;

function WndProcUpDownParent(Sender: PControl; var Msg: TMsg; var Rslt:
  Integer): Boolean;
var
  UpDownNow: PMHUpDown;
  Bar: TScrollerBar;
begin
  Result := False;

  if ((Msg.message = WM_HSCROLL) or (Msg.message = WM_VSCROLL)) and (Msg.lParam
    <> 0) then
  begin
    UpDownNow := Pointer(GetProp(Msg.lParam, ID_SELF));
    if UpDownNow <> nil then
    begin
      if Assigned(UpDownNow.OnScroll) then
      begin
        if Msg.message = WM_VSCROLL then
          Bar := sbVertical
        else
          Bar := sbHorizontal;
        UpDownNow.OnScroll(UpDownNow, Bar, LoWord(Msg.wParam),
          HiWord(Msg.wParam));
      end;
    end;
  end;
end;

function NewMHUpDown(AParent: PControl; Orientation: TUpDownOrientation; Wrap,
  Thousands, ArrowKeys, AutoBuddy, HotTrack, BuddyInteger: Boolean; AlignButton:
  TUpDownAlignButton): PControl;
var
  D: PUpDownData;
begin
  DoInitCommonControls(ICC_UPDOWN_CLASS);
  Result := PMHUpDown(_NewCommonControl(AParent, UPDOWN_CLASS, WS_CHILD or
    WS_VISIBLE or Thousands2Style[Thousands] or Wrap2Style[Wrap] or
    ArrowKeys2Style[ArrowKeys] or Orientation2Style[Orientation] or
    AlignButton2Style[AlignButton] or AutoBuddy2Style[AutoBuddy] or UDS_SETBUDDYINT
    or HotTrack2Style[HotTrack], False, nil));
  GetMem(D, Sizeof(D^));
  FillChar(D^, SizeOf(D^), 0);
  Result.CustomData := D;
  D.FMin := 0;
  D.FMax := 100;
  D.FOrientation := Orientation;
  D.FHotTrack := HotTrack;
  D.FWrap := Wrap;
  D.FThousands := Thousands;
  D.FArrowKeys := ArrowKeys;
  D.FAutoBuddy := AutoBuddy;
  D.FAlignButton := AlignButton;
  Result.AttachProc(WndProcUpDown);
  AParent.AttachProc(WndProcUpDownParent);
end;

{ Buddy }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetBuddy(const Value: HWnd);
begin
  Perform(UDM_SETBUDDY, Value, 0);
end;

function TMHUpDown.GetBuddy: HWnd;
begin
  Result := Perform(UDM_GETBUDDY, 0, 0);
end;

{ Min }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetMin(const Value: Integer);
var
  TMP: Integer;
begin
  Perform(UDM_GETRANGE32, 0, DWord(@TMP));
  Perform(UDM_SETRANGE32, Value, TMP);
  PUpDownData(CustomData)^.FMin := Value;
end;

function TMHUpDown.GetMin: Integer;
begin
  Perform(UDM_GETRANGE, DWord(@Result), 0);
end;

{ Max }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetMax(const Value: Integer);
var
  TMP: Integer;
begin
  Perform(UDM_GETRANGE, DWord(@TMP), 0);
  Perform(UDM_SETRANGE, TMP, Value);
  PUpDownData(CustomData)^.FMax := Value;
end;

function TMHUpDown.GetMax: Integer;
begin
  Perform(UDM_GETRANGE32, 0, DWord(@Result));
end;

{ Position }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetPosition(const Value: Integer);
begin
  Perform(UDM_SETPOS32, 0, Value);
end;

function TMHUpDown.GetPosition: Integer;
begin
  Result := Perform(UDM_GETPOS32, 0, 0);
end;

{ HexBase }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetHexBase(const Value: Boolean);
begin
  if Value then
    Perform(UDM_SETBASE, 16, 0)
  else
    Perform(UDM_SETBASE, 10, 0);
end;

function TMHUpDown.GetHexBase: Boolean;
begin
  if Perform(UDM_GETBASE, 0, 0) = 16 then
    Result := True
  else
    Result := False;
end;

{ Increment }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetIncrement(const Value: Integer);
var
  acc: TUDAccel;
begin
  acc.nSec := REFRESH_PERIOD;
  acc.nInc := Cardinal(Value);
  Perform(UDM_SETACCEL, 1, LongInt(@acc));
end;

function TMHUpDown.GetIncrement: Integer;
var
  tmp: LongInt;
  acc: TUDAccel;
begin
  Perform(UDM_GETACCEL, LongInt(@tmp), LongInt(@acc));
  Result := acc.nInc;
end;

{ Orientation }
//----------------------------------------------------------------------------//

function TMHUpDown.GetOrientation: TUpDownOrientation;
begin
  Result := PUpDownData(CustomData)^.FOrientation;
end;

{ ArrowKeys }
//----------------------------------------------------------------------------//

function TMHUpDown.GetArrowKeys: Boolean;
begin
  Result := PUpDownData(CustomData)^.FArrowKeys;
end;

{ AlignButton }
//----------------------------------------------------------------------------//

function TMHUpDown.GetAlignButton: TUpDownAlignButton;
begin
  Result := PUpDownData(CustomData)^.FAlignButton;
end;

{ AutoBuddy }
//----------------------------------------------------------------------------//

function TMHUpDown.GetAutoBuddy: Boolean;
begin
  Result := PUpDownData(CustomData)^.FAutoBuddy;
end;

{ Thousands }
//----------------------------------------------------------------------------//

function TMHUpDown.GetThousands: Boolean;
begin
  Result := PUpDownData(CustomData)^.FThousands;
end;

{ Wrap }
//----------------------------------------------------------------------------//

function TMHUpDown.GetWrap: Boolean;
begin
  Result := PUpDownData(CustomData)^.FWrap;
end;

{ HotTrack }
//----------------------------------------------------------------------------//

function TMHUpDown.GetHotTrack: Boolean;
begin
  Result := PUpDownData(CustomData)^.FHotTrack;
end;

{ OnChangingEx }
//----------------------------------------------------------------------------//

procedure TMHUpDown.SetOnChangingEx(const Value: TOnChangingEx);
begin
  PUpDownData(CustomData)^.FOnChangingEx := Value;
end;

function TMHUpDown.GetOnChangingEx: TOnChangingEx;
begin
  Result := PUpDownData(CustomData)^.FOnChangingEx;
end;

end.

