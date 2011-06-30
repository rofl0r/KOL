unit KOLBAPDriveBox;
{*
|&C=BAPDriveBox
|Component: <C><br>
|Version: 1.04<br>
|Date: 10.06.2003<br>
|Author: <a href="mailto:delphikol@narod.ru?subject=<C> v1.04">Александр Бартов</a>
|&L=http://delphikol.narod.ru
|<br>Web-page: <a href="<L>/" target="_blank"><L></a>
|<hr width="100%">
|<b>Использование компонента.</b><br>KOL/MCK >= 1.76<br><br>
|<C> <u>следит</u> за изменением в системе и меток дисков, кроме DRIVE_REMOVABLE.
|&A=Applet
|&I=<i>%1</i>}

interface

uses Windows, Messages, KOL;

type
  TOnChangeDrive = procedure(Sender: PControl; Drive: string;
    const ReadErr: Boolean; var Retry: Boolean) of object;
  {* |<ul><I Drive> - выбранный диск 'x:',
  |<br><I ReadErr> - True, если возникла ошибка при смене диска,
  |<br><I Retry> - установите True, если необходимо перечитать диск.</ul>}

  TOnChangeDriveLabel = procedure(Sender: PControl) of object;
  {*}

  PBAPDriveBox = ^TBAPDriveBox;
  TBAPDriveBox = object(TControl)
  {* ComboBox, отображающий логические диски.
  |<br><br><b><u>Messages use <A>:</u></b><br>WM_DEVICECHANGE.}
  private
    procedure OnTimer(Sender: PObj);
    function GetDrive: string;
    function GetDriveLabel: string;
    function GetItems(Idx: Integer): string;
    function GetLightIcon: Boolean;
    function GetSelBackColor: TColor;
    function GetSelTextColor: TColor;
    function GetOnChangeDrive: TOnChangeDrive;
    function GetOnChangeDriveLabel: TOnChangeDriveLabel;
    procedure SetDrive(const Value: string);
    procedure SetLightIcon(const Value: Boolean);
    procedure SetSelBackColor(const Value: TColor);
    procedure SetSelTextColor(const Value: TColor);
    procedure SetOnChangeDrive(const Value: TOnChangeDrive);
    procedure SetOnChangeDriveLabel(const Value: TOnChangeDriveLabel);

    function NewOnDrawItem(Sender: PObj; DC: HDC; const Rect: TRect;
      ItemIdx: Integer; DrawAction: TDrawAction; ItemState: TDrawState): Boolean;

  public
    procedure OpenList;
    {* |&0=список с дисками.
    |Открыть <0>}
    procedure UpdateList;
    {* Обновить <0>}
    property Drive: string read GetDrive write SetDrive;
    {* |&0=Возвращает
    |Устанавливает / <0> текущий диск.
    |<br>'*' - устанавливает диск GetStartDir[1].}
    property DriveLabel: string read GetDriveLabel;
    {* <0> метку текущего диска.}
    property Items[Idx: Integer]: string read GetItems;
    {* <0> строку элемента.}
    property LightIcon: Boolean read GetLightIcon write SetLightIcon;
    {* |&0=выбранного элемента.
    |Влияет на закраску иконки при выборе элемента:
    |<br><I True> - подсвечивать иконку цветом фона <0>
    |<br><I False> - фон иконки как у <0>}
    property SelBackColor: TColor read GetSelBackColor write SetSelBackColor;
    {* Цвет фона <0>}
    property SelTextColor: TColor read GetSelTextColor write SetSelTextColor;
    {* Цвет текста <0>}
    property OnChangeDrive: TOnChangeDrive read GetOnChangeDrive write SetOnChangeDrive;
    {* |&0=Возникает при
    |<0> выборе диска.}
    property OnChangeDriveLabel: TOnChangeDriveLabel read GetOnChangeDriveLabel write SetOnChangeDriveLabel;
    {* <0> смене метки выбранного диска.}

    //== Блокировка свойств
    property Options: Boolean read FNotAvailable;
    {* |&1=Недоступно.
    |<1>}
    property OnChange: Boolean read FNotAvailable;
    {* <1>}
    property OnClick: Boolean read FNotAvailable;
    {* <1>}
    property OnDrawItem: Boolean read FNotAvailable;
    {* <1>}
    property OnMeasureItem: Boolean read FNotAvailable;
    {* <1>}
    property OnPaint: Boolean read FNotAvailable;
    {* <1>}
    property OnSelChange: Boolean read FNotAvailable;
    {* <1>}
  end;

  TKOLBAPDriveBox = PBAPDriveBox;

function NewBAPDriveBox(Sender: PControl; LightIcon: Boolean;
  SelBackColor: TColor = clHighlight; SelTextColor: TColor = clHighlightText): PBAPDriveBox;
{* Создает новый <C>.
|&L=<a href="tbapdrivebox.htm#%1">%1</a>
|<ul><I Sender> - <A> (Form), <L LightIcon>, <L SelBackColor>, <L SelTextColor>.
|</ul>Параметры SelBackColor и SelTextColor можно не указывать.}

implementation

uses ShellApi, MMSystem;

{$I DBTUtils.inc}

const
  dspc = #32 + #32;

var
  FCtlList: PList; // Список с указателями на BAPDriveBox'ы

(* Данные объекта *)

type
  PCtlObj = ^TCtlObj;
  TCtlObj = object(TObj)
    FControl: PControl;
    IL: PImageList;
    FTimer: PTimer;
    VolList: PStrList;
    FUpdate: Boolean;
    FIndex: Integer;

    LightIcon: Boolean;
    SelBackColor: TColor;
    SelTextColor: TColor;
    OnChangeDrive: TOnChangeDrive;
    OnChangeDriveLabel: TOnChangeDriveLabel;
    destructor Destroy; virtual;
  end;

(* Обработчик WM_DEVICECHANGE *)

function WndProcDeviceChange(Ctl: PControl; var Msg: TMsg;
  var Rslt: Integer): Boolean;
var
  Drv: Char;
  Idx: Integer;
  D: PCtlObj;
  DB: PBAPDriveBox;
  pDevBroadcastHdr: PDEV_BROADCAST_HDR;
  pDevBroadcastVolume: PDEV_BROADCAST_VOLUME;
begin
  Result := False;

  if Msg.message = WM_DEVICECHANGE then
    for Idx := 0 to FCtlList.Count - 1 do
    begin
      DB := FCtlList.Items[Idx];
      D := Pointer(DB.CustomObj);

      // Address of a structure that contains event-specific data.
      // Its meaning depends on the given event.
      pDevBroadcastHdr := PDEV_BROADCAST_HDR(Msg.lParam);

      case Msg.wParam of
        DBT_DEVICEARRIVAL: //== Добавление устройства
          if pDevBroadcastHdr.dbch_devicetype = DBT_DEVTYP_VOLUME then
          begin
            Applet.ProcessMessages; // Win9x
            pDevBroadcastVolume := PDEV_BROADCAST_VOLUME(Msg.lParam);
            if (pDevBroadcastVolume.dbcv_flags and DBTF_MEDIA) = 1 then
              D.FControl.Perform(CB_SHOWDROPDOWN, 0, 0) // Вставили CD/DVD
            else
              DB.UpdateList;
          end;

        DBT_DEVICEREMOVECOMPLETE: //== Удаление устройства
          begin
            Applet.ProcessMessages; // Win9x
            pDevBroadcastVolume := PDEV_BROADCAST_VOLUME(Msg.lParam);
            if pDevBroadcastHdr.dbch_devicetype = DBT_DEVTYP_VOLUME then
              if (pDevBroadcastVolume.dbcv_flags and DBTF_MEDIA) = 1 then
              begin // Высунули CD/DVD
                D.FControl.Perform(CB_SHOWDROPDOWN, 0, 0);
                Drv := D.FControl.Items[D.FControl.CurIndex][3];
                if FirstDriveFromMask(pDevBroadcastVolume.dbcv_unitmask) = Drv then
                  DB.SetDrive(#99);
              end else
                DB.UpdateList;
          end;
      end; // case
    end; // for
end;

(* Деструктор данных *)

destructor TCtlObj.Destroy;
begin
  Free_And_Nil(FTimer);
  Free_And_Nil(IL);
  Free_And_Nil(VolList);
  FCtlList.Remove(FControl);
  if FCtlList.Count = 0 then
  begin
    Free_And_Nil(FCtlList);
    if Applet <> nil then // MCK
      Applet.DetachProc(WndProcDeviceChange);
  end;
  inherited;
end;

(* Not removable & not CD/DVD *)

function FixedDrive(const Drv: Char): Boolean;
begin
  case GetDriveType(PChar(Drv + ':\')) of
    DRIVE_REMOVABLE, DRIVE_CDROM: Result := False;
  else
    Result := True;
  end;
end;

(* Установка ширины DropList'а и получение меток дисков *)

procedure NewDroppedList(Ctl: PControl);
var
  WD, Idx: Integer;
  Vol: string;
  D: PCtlObj;
begin
  D := Pointer(Ctl.CustomObj);
  WD := 0;
  for Idx := 0 to Ctl.Count - 1 do
  begin
    D.VolList.Items[Idx] := dspc + GetLabelDisk(Ctl.Items[Idx][3], False);
    Vol := Ctl.Items[Idx] + D.VolList.Items[Idx];
    if WD < Ctl.Canvas.TextWidth(Vol) then
      WD := Ctl.Canvas.TextWidth(Vol);
  end;
  Inc(WD, 26);

  if Ctl.Count > 12 then
    Inc(WD, GetSystemMetrics(SM_CXVSCROLL));
  if fsItalic in Ctl.Font.FontStyle then
    if not Ctl.Font.IsFontTrueType then
      Inc(WD, 2);
  Ctl.Perform(CB_SETDROPPEDWIDTH, WD, 0);
end;

(* Обработчик объекта *)

function WndProcDrive(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Drv: Char;
  Cursor: HCURSOR;
  D: PCtlObj;
begin
  D := Pointer(Ctl.CustomObj);
  Result := False;

  case Msg.message of
    CM_COMMAND:
      case HIWORD(Msg.wParam) of
        CBN_DROPDOWN: // Открытие списка
          begin
            D.FIndex := D.FControl.CurIndex;
            NewDroppedList(Ctl);
          end;

        CBN_SELENDOK: // Выбран элемент
          begin
            D.FTimer.Enabled := False;
            Cursor := Applet.Cursor;
            Applet.CursorLoad(0, IDC_WAIT);
            Drv := Ctl.Items[Ctl.CurIndex][3];

            //== Закрытие CD/DVD
            if (GetDriveType(PChar(Drv + ':\')) = DRIVE_CDROM) and
               (not DriveReady(Drv)) then
            begin
              Ctl.Perform(CB_SHOWDROPDOWN, 0, 0);
              CloseCD(Drv);
              if DriveReady(Drv) then
                WaitLabelChange(Drv, D.VolList.Items[Ctl.CurIndex]);
            end;

            Applet.Cursor := Cursor;
            PBAPDriveBox(Ctl)^.SetDrive(Drv);
          end;
      end; // case HiWord

    WM_KEYDOWN: // Нажатие клавиш
      begin
        case Msg.wParam of
          $01..$20, $29..$40, $5B..$FE: Exit;
        end;

        if Ctl.DroppedDown then
          Exit;
        Ctl.Perform(CB_SHOWDROPDOWN, 1, 0);
        Result := True;
      end;
  end; // case Msg
end;

(* Событие NewOnDrawItem *)

function TBAPDriveBox.NewOnDrawItem;
var
  Ico: Integer;
  cbRect: TRect;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  Result := False;
  if D.FUpdate then
    Exit;

  if (odsSelected in ItemState) then
  begin // Selected item
    D.FControl.Canvas.Brush.Color := D.SelBackColor;
    SetTextColor(DC, Color2RGB(D.SelTextColor));
    SetBkMode(DC, D.FControl.Font.Color);
    if D.LightIcon then
    begin
      D.IL.DrawingStyle := [dsBlend25];
      D.IL.BlendColor := Color2RGB(D.SelBackColor);
    end else
      D.IL.DrawingStyle := [dsTransparent];
  end else
  begin // Normal item
    D.FControl.Canvas.Brush.Color := D.FControl.Color;
    D.IL.DrawingStyle := [];
    SetTextColor(DC, D.FControl.Font.Color);
  end;

  cbRect := Rect;
  if D.LightIcon then
    cbRect.Left := 20;
  FillRect(DC, cbRect, D.FControl.Canvas.Brush.Handle);
  cbRect.Left := 20;
  DrawText(DC, PChar(D.FControl.Items[ItemIdx] + D.VolList.Items[ItemIdx]),
    -1, cbRect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);

  //== Icon 16x16
  if (odsComboboxEdit in ItemState) then
  begin // Edit
    cbRect.Top := 4;
    cbRect.Bottom := 20;
    cbRect.Left := 3;
    cbRect.Right := 19;
  end else
  begin // DropList
    cbRect.Left := 2;
    cbRect.Right := 18;
  end;

  D.IL.BkColor := D.FControl.Color;
  Ico := DriveIconSysIdx(D.FControl.Items[ItemIdx][3] + ':\');
  D.IL.StretchDraw(Ico, DC, cbRect);
end;

(* Событие таймера *)

procedure TBAPDriveBox.OnTimer;
var
  Drv: Char;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  with D^, D.FControl^ do
  begin
    Drv := Items[CurIndex][3];
    if TrimLeft(VolList.Items[CurIndex]) <> GetLabelDisk(Drv, False) then
    begin
      VolList.Items[CurIndex] := dspc + GetLabelDisk(Drv, False);
      Invalidate;
      if Assigned(OnChangeDriveLabel) then
        OnChangeDriveLabel(@Self);
    end;
  end;
end;

(* Создание объекта *)

function NewBAPDriveBox;
var
  D: PCtlObj;
begin
  Result := PBAPDriveBox(NewCombobox(Sender, [coReadOnly, coOwnerDrawFixed]));

  if FCtlList = nil then
    FCtlList := NewList;
  FCtlList.Add(Result);

  New(D, Create);
  Result.CustomObj := D;
  D.FControl := Result;

  D.IL := NewImageList(nil);
  D.IL.LoadSystemIcons(True);
  D.VolList := NewStrList;
  D.LightIcon := LightIcon;
  D.SelTextColor := SelTextColor;
  D.SelBackColor := SelBackColor;
  D.FTimer := NewTimer(1000);
  D.FTimer.OnTimer := Result.OnTimer;

  Result.UpdateList;

  //== Установка обработчиков
  Result.SetOnDrawItem(Result.NewOnDrawItem);
  Result.AttachProc(WndProcDrive);
  if Applet <> nil then // MCK
    Applet.AttachProc(WndProcDeviceChange); // WM_DEVICECHANGE
end;

(* OpenList *)

procedure TBAPDriveBox.OpenList;
begin
  Perform(WM_LBUTTONDOWN, 0, 0);
  Perform(WM_LBUTTONUP, 0, 0);
end;

(* UpdateList *)

procedure TBAPDriveBox.UpdateList;
var
  Ch, Drv: Char;
  DrivesMask: Integer;
  D: PCtlObj;
begin
  D := Pointer(CustomObj);
  with D^, D.FControl^ do
  begin
    FTimer.Enabled := False;
    FUpdate := True;

    if Count > 0 then
    begin
      Drv := Items[CurIndex][3];
      VolList.Clear;
      Clear;
    end else
      Drv := '*'; // Диск по умолчанию

    DrivesMask := GetLogicalDrives;

    for Ch := 'a' to 'z' do
    begin
      if LongBool(DrivesMask and 1) then
      begin
        Add('[-' + Ch + '-]');
        VolList.Add('');
      end;
      DrivesMask := DrivesMask shr 1;
    end;
    SetDrive(Drv);
  end;
end;

(* Drive *)

procedure TBAPDriveBox.SetDrive;
var
  Retry, Err: Boolean;
  Drv: string;
  D: PCtlObj;
begin
  if Value = '' then
    Exit;
  D := Pointer(CustomObj);
  D.FTimer.Enabled := False;

  if Value = '*' then
    Drv := GetStartDir[1]
  else
    Drv := Value[1];
  Drv := UpperCase(Drv) + ':';

  repeat
    Err := False;
    Retry := False;
    if DriveReady(Drv[1]) then
      D.FControl.CurIndex := D.FControl.SearchFor(Drv[1], 0, True)
    else
      Err := True;
    if Assigned(D.OnChangeDrive) then
      D.OnChangeDrive(@Self, Drv, Err, Retry);
  until not Retry;

  with D^, D.FControl^ do
  begin
    if Err then
      if DriveReady(Items[FIndex][3]) then
      begin
        CurIndex := FIndex;
        Drv := Items[FIndex][3];
      end else
      begin // При возврате возникла ошибка
        Drv := #99 + ':';
        CurIndex := SearchFor(Drv[1], 0, True);
        if Assigned(D.OnChangeDrive) then
          D.OnChangeDrive(@Self, Drv, False, Retry);
      end
    else
      CurIndex := SearchFor(Drv[1], 0, True);

    VolList.Items[CurIndex] := dspc + GetLabelDisk(Drv[1], False);
    if FUpdate then
    begin
      FUpdate := False;
      Invalidate;
    end;
    if FixedDrive(Drv[1]) then
      FTimer.Enabled := True;
  end;
end;

function TBAPDriveBox.GetDrive;
begin
  with PCtlObj(CustomObj)^.FControl^ do
    Result := UpperCase(Items[CurIndex][3]) + ':';
end;

(* DriveLabel *)

function TBAPDriveBox.GetDriveLabel;
begin
  with PCtlObj(CustomObj)^.FControl^ do
    Result := GetLabelDisk(Items[CurIndex][3], True);
end;

(* Items *)

function TBAPDriveBox.GetItems;
begin
  with PCtlObj(CustomObj)^ do
    Result := FControl.Items[Idx] + VolList.Items[Idx];
end;

(* LightIcon *)

procedure TBAPDriveBox.SetLightIcon;
begin
  PCtlObj(CustomObj)^.LightIcon := Value;
end;

function TBAPDriveBox.GetLightIcon;
begin
  Result := PCtlObj(CustomObj)^.LightIcon;
end;

(* SelBackColor *)

procedure TBAPDriveBox.SetSelBackColor;
begin
  PCtlObj(CustomObj)^.SelBackColor := Value;
end;

function TBAPDriveBox.GetSelBackColor;
begin
  Result := PCtlObj(CustomObj)^.SelBackColor
end;

(* SelTextColor *)

procedure TBAPDriveBox.SetSelTextColor;
begin
  PCtlObj(CustomObj)^.SelTextColor := Value;
end;

function TBAPDriveBox.GetSelTextColor;
begin
  Result := PCtlObj(CustomObj)^.SelTextColor;
end;

(* OnChangeDrive *)

procedure TBAPDriveBox.SetOnChangeDrive;
begin
  PCtlObj(CustomObj)^.OnChangeDrive := Value;
end;

function TBAPDriveBox.GetOnChangeDrive;
begin
  Result := PCtlObj(CustomObj)^.OnChangeDrive;
end;

(* OnChangeDriveLabel *)

procedure TBAPDriveBox.SetOnChangeDriveLabel;
begin
  PCtlObj(CustomObj)^.OnChangeDriveLabel := Value;
end;

function TBAPDriveBox.GetOnChangeDriveLabel;
begin
  Result := PCtlObj(CustomObj)^.OnChangeDriveLabel;
end;

end.