unit KOLBAPTrayIcon;
{*
|&C=BAPTrayIcon
|Component: <C><br>
|Version: 1.05<br>
|Date: 10.06.2003<br>
|Author: <a href="mailto:delphikol@narod.ru?subject=<C> v1.05">Александр Бартов</a>
|&L=http://delphikol.narod.ru
|<br>Web-page: <a href="<L>/" target="_blank"><L></a>
|<hr width="100%">
|<b>Использование компонента.</b><br>KOL/MCK >= 1.76<br>
|Свойства, которые используются только в <b>MCK</b>, начинаются с <b>mck</b>XXX.
|<br><br><b>Свойства MCK:</b>
|&I=<i>%1</i>
|<br><I mckResFile> - подключает файл ресурса (*.res) к проекту. Если файл
|находится не в каталоге проекта, то он копируется в него. Если файл *.res уже
|подключен к проекту, то его указывать не надо.
|<br><I mckResIcon> - имя ресурса иконки.
|<br><br> Вы сами можете создать файл ресурса с иконками или воспользоваться
|встроенным редактором.
|<br> Чтобы вызвать редактор, сделайте двойной щелчок по компоненту или нажмите
|правую кнопку мыши и, в выпадающем меню, выберите "Icons Resource Editor".
|При компиляции файл ресурса (*.res) создается в каталоге проекта.
|&A=Applet (Form)
|&B=Balloon}

interface

uses Windows, Messages, KOL;

(* Tray notification definitions *)

const
  // User-defined message sent by the trayicon
  WM_TRAYNOTIFY = WM_USER + 1024;

  // Key select events (Space and Enter)
  NIN_SELECT    = WM_USER + 0;
  NINF_KEY      = 1;
  NIN_KEYSELECT = NIN_SELECT or NINF_KEY;

  // Events returned by balloon hint
  NIN_BALLOONSHOW      = WM_USER + 2;
  NIN_BALLOONHIDE      = WM_USER + 3;
  NIN_BALLOONTIMEOUT   = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;

  // Additional dwMessage constants for Shell_NotifyIcon
  NIM_SETFOCUS       = $00000003;
  NIM_SETVERSION     = $00000004;
  NOTIFYICON_VERSION = 3; // Used with the NIM_SETVERSION message

  // Additional uFlags constants for TNotifyIconDataEx
  NIF_MESSAGE = $00000001;
  NIF_ICON    = $00000002;
  NIF_TIP     = $00000004;
  NIF_STATE   = $00000008;
  NIF_INFO    = $00000010;
  NIF_GUID    = $00000020;

  // State of the icon.
  NIS_HIDDEN     = $00000001;
  NIS_SHAREDICON = $00000002;

  // Notify Icon Infotip flags
  NIIF_NONE      = $00000000;
  // icon flags are mutually exclusive and take only the lowest 2 bits
  NIIF_INFO      = $00000001;
  NIIF_WARNING   = $00000002;
  NIIF_ERROR     = $00000003;
  NIIF_ICON_MASK = $0000000F; // Reserved
  NIIF_NOSOUND   = $00000010; // WinXP

type
  TTimeoutOrVersion = packed record
    case Integer of        // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT);
      1: (uVersion: UINT); // Only used when sending a NIM_SETVERSION message
    end;

  TNotifyIconDataEx = packed record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar; // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    TimeoutOrVersion: TTimeoutOrVersion;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  {$IFDEF _WIN32_IE_600}
    guidItem: TGUID; // Reserved; define _WIN32_IE_600 if needed
  {$ENDIF}
  end;

(* BAPTrayIcon *)

type
  PBAPTrayIcon = ^TBAPTrayIcon;
  TBAPTrayIcon = object(TObj)
  {* Помещает иконку в трей.
  |<br>Поддерживает <B> ("воздушный шарик") в Windows Me, NT5.x и выше.<br><br>
  |&0== WM_USER +
  |<b><u>Messages use <A>:</u></b><br>WM_TRAYNOTIFY = <0> 1024;<br>
  |NIN_SELECT <0> 0;<br>
  |NIN_BALLOONSHOW <0> 2;<br>
  |NIN_BALLOONHIDE <0> 3;<br>
  |NIN_BALLOONTIMEOUT <0> 4;<br>
  |NIN_BALLOONUSERCLICK <0> 5;}
  private
    NIDE: TNotifyIconDataEx;
    FControl: PControl;
    FTimer: PTimer;
    FTimeout: Word;
    FMouseCoord: TPoint;
    FActive: Boolean;
    FBalloonText: string;
    FBalloonTitle: string;
    FHideBallOnTimer: Boolean;
    FIcon: HICON;
    FPopupMenu: HMENU;
    FToolTip: string;
    FOnBalloonShow: TOnEvent;
    FOnBalloonHide: TOnEvent;
    FOnBalloonClick: TOnEvent;
    FOnBalloonTimeOut: TOnEvent;
    FOnMouseDblClk: TOnMouse;
    FOnMouseDown: TOnMouse;
    FOnMouseMove: TOnMouse;
    FOnMouseUp: TOnMouse;
    procedure OnTimer(Value: PObj);
    procedure SetActive(const Value: Boolean);
    procedure SetHideBallOnTimer(const Value: Boolean);
    procedure SetIcon(const Value: HICON);
    procedure SetPopupMenu(const Value: HMENU);
    procedure SetToolTip(const Value: string);
    procedure SetOnBalloonShow(const Value: TOnEvent);
    procedure SetOnBalloonHide(const Value: TOnEvent);
    procedure SetOnBalloonClick(const Value: TOnEvent);
    procedure SetOnBalloonTimeOut(const Value: TOnEvent);
    procedure SetOnMouseDblClk(const Value: TOnMouse);
    procedure SetOnMouseDown(const Value: TOnMouse);
    procedure SetOnMouseMove(const Value: TOnMouse);
    procedure SetOnMouseUp(const Value: TOnMouse);

  public
    destructor Destroy; virtual;
    procedure HideBalloon;
    {* Скрыть <B>.}
    function LoadTrayIcon(const IconName: PChar): HICON;
    {* Загрузить иконку. (см. Icon)
    !<i>Аналогично:</i>
    !BAPTrayIcon.Icon := LoadIcon(hInstance, 'xxx');}
    procedure ShowBalloon(const IconType: Word; Timeout: Word);
    {* Показать <B>.
    |<br><br><I IconType:>
    |<br>NIIF_NONE - No icon.
    |<br>NIIF_INFO - An information icon.
    |<br>NIIF_WARNING - A warning icon.
    |<br>NIIF_ERROR - An error icon.
    |<br>NIIF_NOSOUND - Do not play the associated sound (Applies only to balloon ToolTips).
    |<br><br><I Timeout> - время (в секундах) через которое нужно скрыть <B>.}
    property Active: Boolean read FActive write SetActive;
    {* Показывать иконку в трее.}
    property BalloonText: string read FBalloonText write FBalloonText;
    {* Текст <B>'а.}
    property BalloonTitle: string read FBalloonTitle write FBalloonTitle;
    {* Заголовок <B>'а.}
    property HideBallOnTimer: Boolean read FHideBallOnTimer write SetHideBallOnTimer;
    {* Скрывать <B> по таймеру.}
    property Icon: HICON read FIcon write SetIcon;
    {* Иконка в трее. (см. LoadTrayIcon)}
    property PopupMenu: HMENU read FPopupMenu write SetPopupMenu;
    {* Связывает Popup menu с <C>,
    |Popup menu показывается при нажатии правой кнопки мыши на иконки.}
    property ToolTip: string read FToolTip write SetToolTip;
    {* Всплывающая подсказка.}
    property OnBalloonShow: TOnEvent read FOnBalloonShow write SetOnBalloonShow;
    {* |&0=Возникает при
    |<0> показе <B>'а.}
    property OnBalloonHide: TOnEvent read FOnBalloonHide write SetOnBalloonHide;
    {* <0> скрытии <B>'а.}
    property OnBalloonClick: TOnEvent read FOnBalloonClick write SetOnBalloonClick;
    {* |&1=кнопки мыши на
    |<0> нажатии левой <1> <B>'е.}
    property OnBalloonTimeOut: TOnEvent read FOnBalloonTimeOut write SetOnBalloonTimeOut;
    {* <0> нажатии правой <1> <B>'е и при его закрытии.}
    property OnMouseDblClk: TOnMouse read FOnMouseDblClk write SetOnMouseDblClk;
    {* |&0=Mouse.Shift = 0.
    |<0>}
    property OnMouseDown: TOnMouse read FOnMouseDown write SetOnMouseDown;
    {* <0>}
    property OnMouseMove: TOnMouse read FOnMouseMove write SetOnMouseMove;
    {* <0>}
    property OnMouseUp: TOnMouse read FOnMouseUp write SetOnMouseUp;
    {* <0>}
  end;

  TKOLBAPTrayIcon = PBAPTrayIcon;

function NewBAPTrayIcon(Sender: PControl): PBAPTrayIcon;
{* Создает новый <C>.
|<ul><I Sender> - <A>.</ul>}

implementation

uses ShellApi;

var
  FObjList: PList; // Список с указателями на PBAPTrayIcon'ы
  WM_TASKBARCREATED: DWORD; // Обновление(карх) Explorer'а

(* Обработчик WM_TASKBARCREATED *)

function WndProcTray(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Idx: Integer;
  TI: PBAPTrayIcon;
begin
  Result := False;

  if Msg.message = WM_TASKBARCREATED then
    for Idx := 0 to FObjList.Count - 1 do
    begin
      TI := FObjList.Items[Idx];
      if TI.FActive then
      begin
        TI.Active := False;
        TI.Active := True;
      end;
    end;
end;

(* Обработчик HideBallOnTimer *)

function WndProcHideBall(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Idx: Integer;
  TI: PBAPTrayIcon;
begin
  Result := False;

  if Msg.message = WM_TRAYNOTIFY then
  begin
    TI := Pointer(Msg.wParam);
    for Idx := 0 to FObjList.Count - 1 do
      if TI = FObjList.Items[Idx] then
      begin
        case Msg.lParam of
          NIN_BALLOONSHOW, NIN_BALLOONHIDE,
          NIN_BALLOONUSERCLICK, NIN_BALLOONTIMEOUT:
          begin
            if TI.FTimer <> nil then
              Free_And_Nil(TI.FTimer);
            if Msg.lParam = NIN_BALLOONSHOW then
            begin
              TI.FTimer := NewTimer(TI.FTimeout);
              TI.FTimer.OnTimer := TI.OnTimer;
              TI.FTimer.Enabled := True;
            end;
          end;
        end; // case
        Break;
      end; // for
  end;
end;

(* Обработчик OnBalloonXXX *)

function WndProcBalloon(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Idx: Integer;
  TI: PBAPTrayIcon;
begin
  Result := False;

  if Msg.message = WM_TRAYNOTIFY then
  begin
    TI := Pointer(Msg.wParam);
    for Idx := 0 to FObjList.Count - 1 do
      if TI = FObjList.Items[Idx] then
      begin
        case Msg.lParam of
          NIN_BALLOONSHOW:
            if Assigned(TI.FOnBalloonShow) then
              TI.FOnBalloonShow(Ctl);
          NIN_BALLOONHIDE:
            if Assigned(TI.FOnBalloonHide) then
              TI.FOnBalloonHide(Ctl);
          NIN_BALLOONUSERCLICK:
            if Assigned(TI.FOnBalloonClick) then
              TI.FOnBalloonClick(Ctl);
          NIN_BALLOONTIMEOUT:
            if Assigned(TI.FOnBalloonTimeOut) then
              TI.FOnBalloonTimeOut(Ctl);
        end; // case
        Break;
      end; // for
  end;
end;

(* Обработчик OnMouseXXX *)

function WndProcMouse(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Idx: Integer;
  TI: PBAPTrayIcon;
  Mouse: TMouseEventData;
begin
  Result := False;

  if Msg.message = WM_TRAYNOTIFY then
  begin
    TI := Pointer(Msg.wParam);
    for Idx := 0 to FObjList.Count - 1 do
      if TI = FObjList.Items[Idx] then
      begin
        FillChar(Mouse, SizeOf(Mouse), 0);
        Mouse.X := TI.FMouseCoord.x;
        Mouse.Y := TI.FMouseCoord.y;
        case Msg.lParam of

          //* OnMouseMove *//

          WM_MOUSEMOVE:
            begin
              GetCursorPos(TI.FMouseCoord); // Координаты мыши
              if Assigned(TI.FOnMouseMove) then
                TI.FOnMouseMove(Ctl, Mouse);
            end;

          //* OnMouseDown *//

          WM_LBUTTONDOWN, WM_MBUTTONDOWN, WM_RBUTTONDOWN:
            begin
              case Msg.lParam of
                WM_LBUTTONDOWN: Mouse.Button := mbLeft;
                WM_MBUTTONDOWN: Mouse.Button := mbMiddle;
                WM_RBUTTONDOWN:
                  begin
                    Mouse.Button := mbRight;
                    if TI.FPopupMenu > 0 then
                    begin
                      SetForegroundWindow(Ctl.Handle);
                      Ctl.ProcessMessages; // Win9x
                      TrackPopupMenu(TI.FPopupMenu, 0, Mouse.X, Mouse.Y, 0,
                        Ctl.Handle, nil);
                    end;
                  end;
              end;
              if Assigned(TI.FOnMouseDown) then
                TI.FOnMouseDown(Applet, Mouse);
            end;

          //* OnMouseUp *//

          WM_LBUTTONUP, WM_MBUTTONUP, WM_RBUTTONUP:
            begin
              case Msg.lParam of
                WM_LBUTTONUP: Mouse.Button := mbLeft;
                WM_MBUTTONUP: Mouse.Button := mbMiddle;
                WM_RBUTTONUP: Mouse.Button := mbRight;
              end;
              if Assigned(TI.FOnMouseUp) then
                TI.FOnMouseUp(Ctl, Mouse);
            end;

          //* OnMouseDblClk *//

          WM_LBUTTONDBLCLK, WM_MBUTTONDBLCLK, WM_RBUTTONDBLCLK:
            begin
              case Msg.lParam of
                WM_LBUTTONDBLCLK: Mouse.Button := mbLeft;
                WM_MBUTTONDBLCLK: Mouse.Button := mbMiddle;
                WM_RBUTTONDBLCLK: Mouse.Button := mbRight;
              end;
              if Assigned(TI.FOnMouseDblClk) then
                TI.FOnMouseDblClk(Ctl, Mouse);
            end;
        end; // case
        Break;
      end; // for
  end;
end;

(* Деструктор объекта *)

destructor TBAPTrayIcon.Destroy;
begin
  if FTimer <> nil then
    Free_And_Nil(FTimer);
  SetActive(False);
  if FIcon > 0 then
    DestroyIcon(FIcon);
  FToolTip := '';
  FBalloonText := '';
  FBalloonTitle := '';
  FObjList.Remove(@Self);
  if FObjList.Count = 0 then
  begin
    Free_And_Nil(FObjList);
    FControl.DetachProc(WndProcTray);
    FControl.DetachProc(WndProcHideBall);
    FControl.DetachProc(WndProcBalloon);
    FControl.DetachProc(WndProcMouse);
  end;
  inherited;
end;

(* Создание объекта *)

function NewBAPTrayIcon;
begin
  New(Result, Create);
  if FObjList = nil then
  begin
    FObjList := NewList;
    WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');
    Sender.AttachProc(WndProcTray); // Установка обработчика на PControl
  end;
  FObjList.Add(Result);
  Result.FControl := Sender;
end;

(* HideBalloon *)

procedure TBAPTrayIcon.HideBalloon;
begin
  NIDE.uFlags := NIF_INFO;
  Shell_NotifyIcon(NIM_MODIFY, @NIDE);
end;

procedure TBAPTrayIcon.OnTimer;
begin
  HideBalloon;
end;

(* LoadTrayIcon *)

function TBAPTrayIcon.LoadTrayIcon;
begin
  Result := LoadIcon(hInstance, IconName);
  if Result = 0 then
    Exit;
  if FIcon > 0 then
    DestroyIcon(FIcon);
  SetIcon(Result);
end;

(* ShowBalloon *)

procedure TBAPTrayIcon.ShowBalloon;
begin
  if Timeout < 1 then
    Timeout := 1;
  if Timeout > 30 then
    Timeout := 30;
  FTimeout := Timeout * 1000;

  with NIDE do
  begin
    uFlags := NIF_INFO;
    dwInfoFlags := IconType;
    TimeoutOrVersion.uTimeout := FTimeout;
    lstrcpy(szInfoTitle, PChar(FBalloonTitle)); // Заголовок Balloon`а
    lstrcpy(szInfo, PChar(FBalloonText)); // Текст Balloon`а
    Shell_NotifyIcon(NIM_MODIFY, @NIDE);
    szInfoTitle[0] := #0;
    szInfo[0] := #0;
  end;
end;

(* Active *)

procedure TBAPTrayIcon.SetActive;
begin
  FActive := Value;
  if FIcon <= 0 then
    Exit;
  if FControl.GetWindowHandle = 0 then
    Exit; // Выход, если окно не создано

  if not FActive then
  begin // Удалить иконку
    Shell_NotifyIcon(NIM_DELETE, @NIDE);
    Exit;
  end;

  FillChar(NIDE, SizeOf(NIDE), 0);
  with NIDE do
  begin // Добавить иконку
    cbSize := SizeOf(NIDE);
    uID := DWORD(@Self); // Номер иконки - иконки должны различаться по номерам
    hIcon := FIcon;      // Handle иконки
    hWnd := FControl.Handle; // Handle окна
    uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
    uCallbackMessage := WM_TRAYNOTIFY; // Обработчик
    lstrcpy(szTip, PChar(FToolTip));   // Надпись над иконкой
  end;
  Shell_NotifyIcon(NIM_ADD, @NIDE);
end;

(* HideBallOnTimer *)

procedure TBAPTrayIcon.SetHideBallOnTimer;
begin
  FHideBallOnTimer := Value;
  if Value then
    FControl.AttachProc(WndProcHideBall)
  else
    FControl.DetachProc(WndProcHideBall);
end;

(* Icon *)

procedure TBAPTrayIcon.SetIcon;
begin
  if Value <= 0 then
    Exit;
  FIcon := Value;
  if not FActive then
    Exit;
  NIDE.hIcon := FIcon;
  NIDE.uFlags := NIF_ICON or NIF_INFO;
  if not Shell_NotifyIcon(NIM_MODIFY, @NIDE) then
    SetActive(True);
end;

(* PopupMenu *)

procedure TBAPTrayIcon.SetPopupMenu;
begin
  if Value <= 0 then
    Exit;
  FPopupMenu := Value;
  FControl.AttachProc(WndProcMouse);
end;

(* ToolTip *)

procedure TBAPTrayIcon.SetToolTip;
begin
  FToolTip := Value;
  if not FActive then
    Exit;
  lstrcpy(NIDE.szTip, PChar(FToolTip));
  NIDE.uFlags := NIF_TIP;
  Shell_NotifyIcon(NIM_MODIFY, @NIDE);
end;

(* OnBalloonXXX *)

procedure TBAPTrayIcon.SetOnBalloonShow;
begin
  FOnBalloonShow := Value;
  FControl.AttachProc(WndProcBalloon);
end;

procedure TBAPTrayIcon.SetOnBalloonHide;
begin
  FOnBalloonHide := Value;
  FControl.AttachProc(WndProcBalloon);
end;

procedure TBAPTrayIcon.SetOnBalloonClick;
begin
  FOnBalloonClick := Value;
  FControl.AttachProc(WndProcBalloon);
end;

procedure TBAPTrayIcon.SetOnBalloonTimeOut;
begin
  FOnBalloonTimeOut := Value;
  FControl.AttachProc(WndProcBalloon);
end;

(* OnMouseXXX *)

procedure TBAPTrayIcon.SetOnMouseDblClk;
begin
  FOnMouseDblClk := Value;
  FControl.AttachProc(WndProcMouse);
end;

procedure TBAPTrayIcon.SetOnMouseDown;
begin
  FOnMouseDown := Value;
  FControl.AttachProc(WndProcMouse);
end;

procedure TBAPTrayIcon.SetOnMouseMove;
begin
  FOnMouseMove := Value;
  FControl.AttachProc(WndProcMouse);
end;

procedure TBAPTrayIcon.SetOnMouseUp;
begin
  FOnMouseUp := Value;
  FControl.AttachProc(WndProcMouse);
end;

end.