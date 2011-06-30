unit KOLmdvToolTip;

// TKOLmdvToolTip - Компонент для быстрого создания хинтов.
//                  Достаточно положить на форму и далее аналогично VCL.
//                  Поддерживается пользовательская отрисовка.
// E-Mail: dominiko-m@yandex.ru
// Автор: Матвеев Дмитрий
// При разработке использовался ADToolTop by ADSoft (URL: http://ADSoft.boom.ru, E-Mail: ADSoft@inbox.ru)


// - История -

// Дата: 20.11.2003 Версия: 1.1
// [*] - изменено очень много. Получилось вроде неплохо. (Спасибо за помощь Дмитрию Алексейко aka Dimaxx)

// Дата: 7.10.2003 Версия: 1.00
   {Стартовая версия}

{
Планы: 1. Добавить пользовательскую отрисовку.
       2. Доделать asm версию.
}

{
  Описание ключевых свойств: См. интерфейсную часть.
}

interface
//{$DEFINE ASM_VERSION} // Comment this line to produce Pascal code.
{$I KOLDEF.INC}
{$IFDEF _D7orHigher}
  {$WARN UNSAFE_TYPE OFF} // Too many such warnings in Delphi7
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
//{$IFDEF INPACKAGE}
//  {$UNDEF ASM_VERSION}
//{$ENDIF}
{$A-} // align off, otherwise code is not good
{$Q-} // no overflow check: this option makes code wrong
{$R-} // no range checking: this option makes code wrong
{$T-} // not typed @-operator
//{$D+}

uses Windows, Messages, KOL;

const TTS_BALLOON = $40;
      TTM_SETTITLE = WM_USER + 32;
      TTM_GETTITLE = WM_USER + 35;

      TTF_PARSELINKS = $1000;

      TTDT_AUTOMATIC = 0;
      TTDT_RESHOW    = 1;
      TTDT_AUTOPOP   = 2;
      TTDT_INITIAL   = 3;

type
  tagNMTTCUSTOMDRAW = packed record
    nmcd: TNMCustomDraw;
    uDrawFlags: Word;
  end;
  PNMTTCUSTOMDRAW = ^TNMTTCUSTOMDRAW;
  TNMTTCUSTOMDRAW = tagNMTTCUSTOMDRAW;

  _TTGETTITLE = packed record
    dwSize: LongInt;
    uTitleBitmap: Word;
    cch: Word;
    pszTitle: PWCHAR;
  end;
  TttGetTitle = _TTGETTITLE;
  PttGetTitle = ^TttGetTitle;

  PmdvToolTip = ^TmdvToolTip;
  TKOLmdvToolTip = PmdvToolTip;

  TArrayOfPointers = array [0..0] of Pointer;
  PArrayOfPointers = ^TArrayOfPointers;
  TArrayOfPChars = array [0..0] of PChar;
  PArrayOfPChars = ^TArrayOfPChars;

  THintMode = (hmDefault, hmShowManual, hmTracking);
  {* Ключи режимов создания нинта:
     hmDefault - стандартный режим Windows. Значения текста подсказки автоматически берутся из свойства Hint компонента в Design time.
     hmShowManual - Показ\скрытие, позиционирование хинта осуществляется пользователем с помощью ShowHint и TrackHint. Значения текста подсказки автоматически берутся из свойства Hint компонента в Design time.
     hmTracking - Показ\скрытие, позиционирование хинта осуществляется пользователем с помощью ShowHint и TrackHint. Значения текста подсказки не назначаются. }
  TttIconType = (itNoIcon, itInfoIcon, itWarningIcon, itErrorIcon);
  {* Типы иконок в заголовке. }
  TmdvToolTip = object(TObj)
  private
    FHandle: hWnd;
    FParent: PControl;
    FCount: Integer;
    FFlag: Integer;
    FToolTipsCount: Integer;

    FControls: PArrayOfPointers;
    FHints: PArrayOfPChars;

    procedure Clear;
    procedure InitToolTip(AParent: PControl; AToolTipsCount: Integer; AHintMode: THintMode);
    procedure AddToolTip(AControlHandle: THandle; const Value: string);

    procedure SetToolTip(AControlHandle: THandle; const Value: string);
    function  GetToolTip(AControlHandle: THandle): String;
    function  GetColor(const Index: Integer): TColor;
    procedure SetColor(const Index: Integer; const Value: TColor);
    procedure SetDelay(const Index, Value: Integer);
    function  GetDelay(const Index: Integer): Integer;
    function  GetMaxWidth: Integer;
    procedure SetMaxWidth(const Value: Integer);
    function  GetMargin: TRect;
    procedure SetMargin(const Value: TRect);
    function GetStyle(const Index: Integer): Boolean;
    procedure SetStyle(const Index: Integer; const Value: Boolean);
    procedure SetToolTipRect(const Value: TRect);
    function GetToolTipRect: TRect;
  protected
  public
    destructor Destroy; virtual;
    procedure ShowHint(AControlHandle: THandle; AShow: Boolean);
    {* Показывает хинт. Хинт, созданный с ключами hmTracking и hmShowManual необходимо
       сначала позиционировать с помощью TrackHint.
       AControlHandle - хендл окна контрола (PControl.Handle).
       AShow - True - показать, False - скрыть }
    procedure TrackHint(X, Y: Integer);
    {* Позиционирует хинт, созданный с ключами hmTracking и hmShowManual.
       X, Y - абсолютные экранные кординаты. }
    function GetTitle(var AIcon: TttIconType): String;
    {* Возвращает заголовок(Result) и иконку хинта(AIcon, см. описание TttIconType).
       Требуется Comclt32.dll v6.0. Windows XP.
       !!!!!!!!! Текст получить так и не удалось. Кто знает - подскажите. ?????????}
    procedure SetTitle(const Value: String; const AIcon: TttIconType);
    {* Устанавливает заголовок (Result) и иконку хинта(AIcon, см. описание TttIconType).
       Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98 }
    property Handle: hWnd read FHandle write FHandle;
    {* Хендл окна хинта. }
    property ToolTip[AControlHandle: THandle]: String read GetToolTip write SetToolTip;
    {* Значение строки хинта. AControlHandle - хендл окна контрола (PControl.Handle). }

    property DelayAutomatic: Integer index TTDT_AUTOMATIC read GetDelay write SetDelay;   //TTM_GETDELAYTIME
    {* При присвоеннии значения DelayAutomatic автоматически вычисляет
       значения для DelayInit, DelayTime, DelayReshow. }
    property DelayInit: Integer index TTDT_INITIAL read GetDelay write SetDelay;
    {* Задержка появления хинта. }
    property DelayTime: Integer index TTDT_AUTOPOP read GetDelay write SetDelay;
    {* Время показа хинта. }
    property DelayReshow: Integer index TTDT_RESHOW read GetDelay write SetDelay;
    {* Время перепоказа хинта. }

    property Color: TColor index 0 read GetColor write SetColor;
    {* Цвет фона хинта. }
    property FontColor: TColor index 1 read GetColor write SetColor;
    {* Цвет текста хинта. }

    property MaxWidth: Integer read GetMaxWidth write SetMaxWidth;
    {* Максимальная ширина хинта.
       При значении <>-1 появляется возможность использовать #13#10
       для переноса строк }
    property Margin: TRect read GetMargin write SetMargin;
    {* Отступы при выводе текста. }

    property Balloon: Boolean index TTS_BALLOON read GetStyle write SetStyle;
    {* Стиль хинта в виде "шара".
       Требуется Comctl32.dll v5.8 Internet Explorer 5. Windows 2000, Windows 98 }
    property AlwaysTip: Boolean index TTS_ALWAYSTIP read GetStyle write SetStyle;
    {* Хинт показывается всегда, независимо от того, активно ли сейчас окно. }
    property ToolTipRect: TRect read GetToolTipRect write SetToolTipRect;
    {* Кординаты окна хинта }
  end;
  function NewmdvToolTip(AParent: PControl; AToolTipsCount: Integer; AHintMode: THintMode; AControls: array of PControl; AHints: array of String; ACount: Integer): TKOLmdvToolTip;
  {* Создает объект TKOLmdvToolTip.
     AParent: PControl - родитель(Форма);
     AToolTipsCount: Integer; - количество объектов TKOLmdvToolTip на форме.
     AHintMode: THintMode; - Режим работы (см. описание THintMode).
     AControls: array of PControl; - список контролов.
     AHints: array of String  - список хинтов контролов.
     ACount: Integer; - количество хинтов (размерность AControls и AHints)}


  function GetHintValidPos: TPoint;
  {* Возвращает "правильную" позицию хинта (пот указателем курсора). }
  procedure UpdateHintValidPos(AWidth, AHeight: Integer; var APoint: TPoint);
  {* Исправляет позицию хинта (APoint) с учетом его
     ширины и высоты (AWidth, AHeight) и размеров экрана. }

implementation

type TToolTipsList = array [0..10]of TKOLmdvToolTip;
     PToolTipsList = ^TToolTipsList;

var ToolTips: PToolTipsList = nil;
    ToolTipsCount: Integer = 0;

//Оконная процедура. Прикрепляется к форме для инициализации хинтов во время показа.
function WndProcShow(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var i, j, k: Integer;
begin
    Result := False;
    if Msg.message = WM_SHOWWINDOW then begin
      k:= 0;
      for i:= 0 to ToolTipsCount-1 do begin
         if ToolTips[i].FParent = Sender then begin
           Sender.DetachProc(WndProcShow);
           for j:= 0 to ToolTips[i].FCount-1 do
             ToolTips[i].AddToolTip(PControl(ToolTips[i].FControls[j]^).Handle, ToolTips[i].FHints[j]);
           ToolTips[i].Clear;
           inc(k); if ToolTips[i].FToolTipsCount = k then Exit;
         end;
      end;
    end;
end;

//Создает хинты для режима hmDefault. В этом режиме вычисление размеров и отрисовку хинта выполняет сама Windows.
function NewmdvToolTip(AParent: PControl; AToolTipsCount: Integer; AHintMode: THintMode; AControls: array of PControl; AHints: array of String; ACount: Integer): TKOLmdvToolTip;
var i: Integer;
begin
    New(Result, Create);
    Result.InitToolTip(AParent, AToolTipsCount, AHintMode);
    inc(ToolTipsCount); ReallocMem(ToolTips, SizeOf(TKOLmdvToolTip) * ToolTipsCount);
    ToolTips[ToolTipsCount-1]:= Result;

    if AHintMode <> hmTracking then begin
      Result.FCount:= ACount;
      ReallocMem(Result.FControls, SizeOf(Pointer) * Result.FCount);
      ReallocMem(Result.FHints, SizeOf(PChar) * Result.FCount);
      for i:= 0 to Result.FCount-1 do begin
        Result.FControls[i]:= AControls[i]; Result.FHints[i]:= PChar(AHints[i]);
      end;
      AParent.AttachProc(WndProcShow);
    end;
end;

function FindToolTip(AHandle: THandle): TKOLmdvToolTip;
var i: Integer;
begin
    Result:= nil;
    for i:= 0 to ToolTipsCount-1 do
      if ToolTips[i].FHandle = AHandle then begin
        Result:= ToolTips[i];
        Exit;
      end;
end;

//Заполняет структуру TToolInfo
{$IFDEF ASM_VERSION}
procedure FillToolInfo(var AToolInfo: TToolInfo; AWnd: hWnd; AFlags: Integer);
asm
{
        push     EAX
        push     EDX
        mov      EDX, Type(TToolInfo)
        mov      CL, 0
        call     System.@FillChar
        pop      EDX
        pop      EAX
}
        mov      [EAX].TToolInfo.cbSize, Type(TToolInfo)
        mov      [EAX].TToolInfo.hwnd, EDX
        mov      [EAX].TToolInfo.uFlags, ECX
        mov      [EAX].TToolInfo.uId, EDX
end;
{$ELSE ASM_VERSION} //Pascal
procedure FillToolInfo(var AToolInfo: TToolInfo; AWnd: hWnd; AFlags: Integer);
begin
    FillChar(AToolInfo, SizeOf(TToolInfo), 0);
    with AToolInfo do begin
      cbSize := SizeOf(TTOOLINFO);
      hwnd   := AWnd;
      uFlags := AFlags;
      uId    := AWnd;
    end;
end;
{$ENDIF ASM_VERSION}

{ TmdvToolTip }
{$IFDEF ASM_VERSION}
procedure TmdvToolTip.InitToolTip(AParent: PControl);
asm
        mov      [EAX].FCount, 0
        mov      [EAX].FControls, 0
        mov      [EAX].FHints, 0
        mov      [EAX].FParent, EDX
        push     EBX
        push     EAX
        call     InitCommonControls
        pop      EBX

        push     $00;
        push     [hInstance]
        push     $0
        push     [EDX].FHandle
        push     $00;
        push     $00;
        push     $00;
        push     $00;
        push     $00;
{$IFDEF _D7orHigher}
        xor      ECX, ECX
        mov      EDX, offset [TOOLTIPS_CLASS];
        xor      EAX, EAX
{$ELSE _D7orHigher}
        push     $00;
        push     offset [TOOLTIPS_CLASS];
        push     $00
{$ENDIF _D7orHigher}
        call     CreateWindowEx
        MOV      [EBX].fHandle, EAX
        pop      EBX
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.InitToolTip(AParent: PControl; AToolTipsCount: Integer; AHintMode: THintMode);
begin
    FParent := AParent;
    FCount:= 0;
    FFlag:= TTF_TRACK;
    if AHintMode = hmDefault then FFlag:= 0;
    FToolTipsCount:= AToolTipsCount;
    FControls:= nil;
    FHints:= nil;
    InitCommonControls;
    FHandle := CreateWindowEx(WS_EX_TOOLWINDOW or WS_EX_TOPMOST, TOOLTIPS_CLASS, nil, {TTS_ALWAYSTIP or }TTS_NOPREFIX or WS_POPUP {or TTS_BALLOON}, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, FParent.Handle, 0, hInstance, nil);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
type TFakeObj = object(TObj) end;
destructor TmdvToolTip.Destroy;
asm
        push     EBX
        push     EDI
        mov      EBX, EAX

        push     [EAX].FHandle
        call     DestroyWindow

        mov      EAX, EBX

        mov      ECX, ToolTipsCount
        jcxz     @@Exit

        mov      EDI, ToolTips
        cld
        repne    scasd

        dec      ToolTipsCount

        sal      ECX, 2
        mov      EDX, EDI
        mov      EAX, EDI
        sub      EAX, TYPE(Pointer)
        call     MoveMemory

        mov      EDX, ToolTipsCount
        sal      EDX, 2
        lea      EAX, ToolTips
        call     System.@ReallocMem

@@Exit:
        mov      EAX, EBX
        call     Clear

        xchg     EBX, EAX
        call     TFakeObj.Destroy

        pop      EDI
        pop      EBX
end;
{$ELSE ASM_VERSION} //Pascal
destructor TmdvToolTip.Destroy;
var i: Integer;
begin
    DestroyWindow(FHandle);
    for i:= 0 to ToolTipsCount-1 do
      if (ToolTips[i] = @Self)and(ToolTipsCount-i-1 > 0) then begin
        MoveMemory(@(ToolTips[i]), @(ToolTips[i+1]), (ToolTipsCount-i-1)*SizeOf(Pointer));
        Break;
      end;
    dec(ToolTipsCount);
    ReallocMem(ToolTips, SizeOf(TKOLmdvToolTip) * ToolTipsCount);
    Clear;
    inherited;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.Clear;
asm
        mov      [EAX].FCount, 0
        push     EAX
        lea      EAX, [EAX].FControls
        xor      EDX, EDX
        call     KOL.@ReallocMem
        pop      EAX
        lea      EAX, [EAX].FControls
        xor      EDX, EDX
        call     KOL.@ReallocMem
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.Clear;
begin
    FCount:= 0;
    ReallocMem(FControls, 0);
    ReallocMem(FHints, 0);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function TmdvToolTip.GetToolTip(AControlHandle: THandle): String;
var TI: TToolInfo;
asm
        push     EBX
        push     EDI

        push     ECX
        xchg     EBX, EAX

        mov      ECX, TTF_IDISHWND
        lea      EAX, TI
        push     EAX
        call     FillToolInfo;

        mov      EAX, 1024
        call     System.@GetMem;
        mov      TI.lpszText, EAX
        mov      EDI, EAX

        mov      EDX, 1024
        mov      CL, 0
        call     System.@FillChar

        push     0
        push     TTM_GETTEXT
        push     [EBX].FHandle
        call     SendMessage
//        mov       ECX, 0
        test     EAX, EAX
        jz       @@Res
//        mov      ECX, 80

@@Res:
        pop      EAX
        mov      EDX, EDI
        call     System.@LStrFromPChar//Len

        xchg     EDI, EAX
        mov      EDX, 1024
        call     System.@FreeMem

        pop      EDI
        pop      EBX
end;
{$ELSE ASM_VERSION} //Pascal
function TmdvToolTip.GetToolTip(AControlHandle: THandle): String;
var TI: TToolInfo;
begin
    Result:= ''; 
    FillToolInfo(TI, AControlHandle, TTF_IDISHWND);
    GetMem(TI.lpszText, 1024);
    if Boolean(SendMessage(FHandle, TTM_GETTOOLINFO, 0, LongInt(@TI))) then Result:= String(TI.lpszText);
    FreeMem(TI.lpszText, 1024);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.SetToolTip(AControlHandle: THandle; const Value: string);
var TI: TToolInfo;
    P:  PAnsiString;
asm
        push     EBX
        push     EDI
        push     ESI
        push     EDX

        xchg     EDI, ECX
        xchg     EBX, EAX

        mov      ECX, TTF_IDISHWND
        lea      EAX, TI
        mov      ESI, EAX
        call     FillToolInfo;

        test     EDI, EDI
        jnz      @@AddToolTip
        push     ESI
        push     0
        push     TTM_DELTOOL
        push     [EBX].FHandle
        call     SendMessage
        jmp      @@Exit

@@AddToolTip:
        mov      EAX, EBX
        pop      EDX
        push     EDX
        mov      P, 0
        lea      ECX, P
        call     GetToolTip
        cmp      DWORD PTR [P], 0
        jnz      @@SetToolTip
        mov      EAX, EBX
        pop      EDX
        push     EDX
        mov      ECX, EDI
        call     AddToolTip
        jmp      @@Exit

@@SetToolTip:
//        LStrToPChar
        mov      TI.lpszText, EDI
        push     ESI
        push     0
        push     TTM_UPDATETIPTEXT
        push     [EBX].FHandle
        call     SendMessage
@@Exit:
        pop      EDX
        pop      ESI
        pop      EDI
        pop      EBX
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.SetToolTip(AControlHandle: THandle; const Value: string);
var TI: TToolInfo;
begin
    FillToolInfo(TI, AControlHandle, TTF_IDISHWND);
    if Value = '' then begin
      SendMessage(FHandle, TTM_DELTOOL, 0, LongInt(@TI));
      Exit;
    end;
    if ToolTip[AControlHandle] = '' then begin
      AddToolTip(AControlHandle, Value);
      Exit;
    end;
    TI.lpszText := PChar(Value);
    SendMessage(FHandle, TTM_UPDATETIPTEXT, 0, LongInt(@TI));
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.AddToolTip(AControlHandle: THandle; const Value: string);
var TI: TToolInfo;
asm
        push      EBX
        xchg      EBX, EAX

        lea       EAX, TI
        push      EAX
        push      ECX
        mov       ECX, TTF_SUBCLASS or TTF_TRANSPARENT or TTF_IDISHWND
        call      FillToolInfo;

        mov       EAX, [hInstance]
        mov       TI.hinst, EAX
        pop       TI.lpszText


        push      0
        push      TTM_ADDTOOL
        push      [EBX].FHandle
        call      SendMessage

        pop       EBX
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.AddToolTip(AControlHandle: THandle; const Value: string);
var TI: TToolInfo;
begin                                                                                        
    FillToolInfo(TI, AControlHandle, TTF_PARSELINKS or TTF_SUBCLASS or TTF_TRANSPARENT or TTF_IDISHWND or TTF_ABSOLUTE or FFlag);
    with TI do begin
      hinst  := hInstance;
      lpszText := PChar(Value);
      SendMessage(FHandle, TTM_ADDTOOL, 0, LongInt(@TI));
    end;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function TmdvToolTip.GetColor(const Index: Integer): TColor;
asm
        push      0
        push      0
        add       EDX, TTM_GETTIPBKCOLOR
        push      EDX
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
function TmdvToolTip.GetColor(const Index: Integer): TColor;
begin
    Result := SendMessage(handle, TTM_GETTIPBKCOLOR + Index, 0, 0);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.SetColor(const Index: Integer; const Value: TColor);
asm
        push      0
        push      ECX
        add       EDX, TTM_SETTIPBKCOLOR
        push      EDX
        push      [EAX].FHandle
        mov       EAX, ECX
        call      Color2RGB
        mov       [ESP+8], EAX
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.SetColor(const Index: Integer; const Value: TColor);
begin
    SendMessage(FHandle, TTM_SETTIPBKCOLOR + Index, Color2RGB(Value), 0);
end;
{$ENDIF ASM_VERSION}


{$IFDEF ASM_VERSION}
function TmdvToolTip.GetDelay(const Index: Integer): Integer;
asm
        push      0
        push      DX
        push      TTM_GETDELAYTIME
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
function TmdvToolTip.GetDelay(const Index: Integer): Integer;
begin
    Result:= SendMessage(FHandle, TTM_GETDELAYTIME, Index, 0);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.SetDelay(const Index, Value: Integer);
asm
        push      ECX
        push      EDX
        push      TTM_SETDELAYTIME
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.SetDelay(const Index, Value: Integer);
begin
    SendMessage(FHandle, TTM_SETDELAYTIME, Index, Value)
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function TmdvToolTip.GetMaxWidth: Integer;
asm
        push      0
        push      0
        push      TTM_GETMAXTIPWIDTH
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
function TmdvToolTip.GetMaxWidth: Integer;
begin
    Result := SendMessage(fHandle, TTM_GETMAXTIPWIDTH, 0, 0);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.SetMaxWidth(const Value: Integer);
asm
        push      EDX
        push      0
        push      TTM_SETMAXTIPWIDTH
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.SetMaxWidth(const Value: Integer);
begin
    SendMessage(fHandle, TTM_SETMAXTIPWIDTH, 0, Value);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function TmdvToolTip.GetMargin: TRect;
asm
        push      EDX
        push      0
        push      TTM_GETMARGIN
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
function TmdvToolTip.GetMargin: TRect;
begin
    SendMessage(FHandle, TTM_GETMARGIN, 0, Integer(@Result));
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
procedure TmdvToolTip.SetMargin(const Value: TRect);
asm
        push      EDX
        push      0
        push      TTM_SETMARGIN
        push      [EAX].FHandle
        call      SendMessage
end;
{$ELSE ASM_VERSION} //Pascal
procedure TmdvToolTip.SetMargin(const Value: TRect);
begin
    SendMessage(FHandle, TTM_SETMARGIN, 0, Integer(@Value));
end;
{$ENDIF ASM_VERSION}

function TmdvToolTip.GetTitle(var AIcon: TttIconType): String;
var ttGetTitle: TttGetTitle;
begin
    ttGetTitle.dwSize:= SizeOf(TttGetTitle);
    ttGetTitle.cch:= 1024;
    GetMem(ttGetTitle.pszTitle, 1024);
    SendMessage(FHandle, TTM_GETTITLE, 0, Integer(@ttGetTitle));
    Result:= WideCharToString(ttGetTitle.pszTitle);
    AIcon:= TttIconType(ttGetTitle.uTitleBitmap);
    FreeMem(ttGetTitle.pszTitle, 1024);
end;

procedure TmdvToolTip.SetTitle(const Value: String; const AIcon: TttIconType);
begin
    SendMessage(FHandle, TTM_SETTITLE, Integer(AIcon), Integer(PChar(Value)));
end;

function TmdvToolTip.GetStyle(const Index: Integer): Boolean;
begin
    Result:= (GetWindowLong(FHandle, GWL_STYLE) and Index) = Index;
end;

procedure TmdvToolTip.SetStyle(const Index: Integer; const Value: Boolean);
var Style: Integer;
begin
    Style:= TTS_NOPREFIX or WS_POPUP or WS_BORDER;
    case Index of
      TTS_ALWAYSTIP: begin
        if Balloon then Style:= (Style or TTS_BALLOON) and not WS_BORDER;
        if Value then Style:= Style or TTS_ALWAYSTIP;
      end;
      TTS_BALLOON: begin
        if AlwaysTip then Style:= Style or TTS_ALWAYSTIP;
        if Value then Style:= (Style or TTS_BALLOON) and not WS_BORDER;
      end;
    end;
    SetWindowLong(FHandle, GWL_STYLE, Style);
end;

procedure TmdvToolTip.ShowHint(AControlHandle: THandle; AShow: Boolean);
var TI: TToolInfo;
begin
    FillToolInfo(TI, AControlHandle, TTF_IDISHWND);
    SendMessage(FHandle, TTM_TRACKACTIVATE, Integer(AShow), Integer(@TI));
end;

procedure TmdvToolTip.TrackHint(X, Y: Integer);
begin
    SendMessage(FHandle, TTM_TRACKPOSITION, 0, MakeLong(X, Y));
end;






function BytesPerScanline(PixelsPerScanline, BitsPerPixel, Alignment: Longint): Longint;
begin
  Dec(Alignment);
  Result := ((PixelsPerScanline * BitsPerPixel) + Alignment) and not Alignment;
  Result := Result div 8;
end;
procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP; var BI: TBitmapInfoHeader;
  Colors: Integer);
var
  DS: TDIBSection;
  Bytes: Integer;
begin
  DS.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DS), @DS);
  if Bytes = 0 then begin end//InvalidBitmap
  else if (Bytes >= (sizeof(DS.dsbm) + sizeof(DS.dsbmih))) and
    (DS.dsbmih.biSize >= DWORD(sizeof(DS.dsbmih))) then
    BI := DS.dsbmih
  else
  begin
    FillChar(BI, sizeof(BI), 0);
    with BI, DS.dsbm do
    begin
      biSize := SizeOf(BI);
      biWidth := bmWidth;
      biHeight := bmHeight;
    end;
  end;
  case Colors of
    2: BI.biBitCount := 1;
    3..16:
      begin
        BI.biBitCount := 4;
        BI.biClrUsed := Colors;
      end;
    17..256:
      begin
        BI.biBitCount := 8;
        BI.biClrUsed := Colors;
      end;
  else
    BI.biBitCount := DS.dsbm.bmBitsPixel * DS.dsbm.bmPlanes;
  end;
  BI.biPlanes := 1;
  if BI.biClrImportant > BI.biClrUsed then
    BI.biClrImportant := BI.biClrUsed;
  if BI.biSizeImage = 0 then
    BI.biSizeImage := BytesPerScanLine(BI.biWidth, BI.biBitCount, 32) * Abs(BI.biHeight);
end;
procedure InternalGetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: DWORD;
  var ImageSize: DWORD; Colors: Integer);
var
  BI: TBitmapInfoHeader;
begin
  InitializeBitmapInfoHeader(Bitmap, BI, Colors);
  if BI.biBitCount > 8 then
  begin
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    if (BI.biCompression and BI_BITFIELDS) <> 0 then
      Inc(InfoHeaderSize, 12);
  end
  else
    if BI.biClrUsed = 0 then
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) +
        SizeOf(TRGBQuad) * (1 shl BI.biBitCount)
    else
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) +
        SizeOf(TRGBQuad) * BI.biClrUsed;
  ImageSize := BI.biSizeImage;
end;
function InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
  var BitmapInfo; var Bits; Colors: Integer): Boolean;
var
  OldPal: HPALETTE;
  DC: HDC;
begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo), Colors);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  try
    if Palette <> 0 then
    begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;
    Result := GetDIBits(DC, Bitmap, 0, TBitmapInfoHeader(BitmapInfo).biHeight, @Bits,
      TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0;
  finally
    if OldPal <> 0 then SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  end;
end;
function GetDIB(Bitmap: HBITMAP; Palette: HPALETTE; var BitmapInfo; var Bits): Boolean;
begin
  Result := InternalGetDIB(Bitmap, Palette, BitmapInfo, Bits, 0);
end;
procedure GetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: DWORD;
  var ImageSize: DWORD);
begin
  InternalGetDIBSizes(Bitmap, InfoHeaderSize, ImageSize, 0);
end;
function GetCursorHeightMargin: Integer;
var
  IconInfo: TIconInfo;
  BitmapInfoSize, BitmapBitsSize, ImageSize: DWORD;
  Bitmap: PBitmapInfoHeader;
  Bits: Pointer;
  BytesPerScanline: Integer;
    function FindScanline(Source: Pointer; MaxLen: Cardinal;
      Value: Cardinal): Cardinal; assembler;
    asm
            PUSH    ECX
            MOV     ECX,EDX
            MOV     EDX,EDI
            MOV     EDI,EAX
            POP     EAX
            REPE    SCASB
            MOV     EAX,ECX
            MOV     EDI,EDX
    end;
begin
  { Default value is entire icon height }
  Result := GetSystemMetrics(SM_CYCURSOR);
  if GetIconInfo(GetCursor, IconInfo) then
  try
    GetDIBSizes(IconInfo.hbmMask, BitmapInfoSize, BitmapBitsSize);
    Bitmap := AllocMem(DWORD(BitmapInfoSize) + BitmapBitsSize);
    try
    Bits := Pointer(DWORD(Bitmap) + BitmapInfoSize);
    if GetDIB(IconInfo.hbmMask, 0, Bitmap^, Bits^) and
      (Bitmap^.biBitCount = 1) then
    begin
      { Point Bits to the end of this bottom-up bitmap }
      with Bitmap^ do
      begin
        BytesPerScanline := ((biWidth * biBitCount + 31) and not 31) div 8;
        ImageSize := biWidth * BytesPerScanline;
        Bits := Pointer(DWORD(Bits) + BitmapBitsSize - ImageSize);
        { Use the width to determine the height since another mask bitmap
          may immediately follow }
        Result := FindScanline(Bits, ImageSize, $FF);
        { In case the and mask is blank, look for an empty scanline in the
          xor mask. }
        if (Result = 0) and (biHeight >= 2 * biWidth) then
          Result := FindScanline(Pointer(DWORD(Bits) - ImageSize),
          ImageSize, $00);
        Result := Result div BytesPerScanline;
      end;
      Dec(Result, IconInfo.yHotSpot);
    end;
    finally
      FreeMem(Bitmap, BitmapInfoSize + BitmapBitsSize);
    end;
  finally
    if IconInfo.hbmColor <> 0 then DeleteObject(IconInfo.hbmColor);
    if IconInfo.hbmMask <> 0 then DeleteObject(IconInfo.hbmMask);
  end;
end;

function GetHintValidPos: TPoint;
begin
    GetCursorPos(Result); Inc(Result.Y, GetCursorHeightMargin);
end;

procedure UpdateHintValidPos(AWidth, AHeight: Integer; var APoint: TPoint);
const SM_XVIRTUALSCREEN = 76;
      SM_YVIRTUALSCREEN = 77;
      SM_CXVIRTUALSCREEN = 78;
      SM_CYVIRTUALSCREEN = 79;
var DesktopTop, DesktopLeft, DesktopHeight, DesktopWidth: Integer;
begin
    DesktopTop:= GetSystemMetrics(SM_YVIRTUALSCREEN); DesktopLeft:= GetSystemMetrics(SM_XVIRTUALSCREEN);
    DesktopHeight:= GetSystemMetrics(SM_CYVIRTUALSCREEN); DesktopWidth:= GetSystemMetrics(SM_CXVIRTUALSCREEN);
    if APoint.X + AWidth > DesktopWidth then APoint.X := DesktopWidth - AWidth;
    if APoint.X < DesktopLeft then APoint.X := DesktopLeft;
    if APoint.Y + AHeight > DesktopHeight then APoint.Y := DesktopHeight - AHeight;
    if APoint.Y < DesktopTop then APoint.Y := DesktopTop;
end;

procedure TmdvToolTip.SetToolTipRect(const Value: TRect);
begin
     SetWindowPos(FHandle, 0, Value.left, Value.top,
                 Value.Right-Value.Left, Value.Bottom-Value.Top,
                 SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE);
end;

function TmdvToolTip.GetToolTipRect: TRect;
begin
    GetWindowRect(FHandle, Result);
end;

end.
