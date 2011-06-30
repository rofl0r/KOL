(****************************************************************)
(*                             HintRA                           *)
(*                                                              *)
(*  Автор: Rabotahoff Alexandr (RA)                             *)
(* e-mail: Holden@bk.ru                                         *)
(* Версия: 1.4                                                  *)
(*   Дата: 10.12.2003                                           *)
(****************************************************************)

unit KOLHintRA;

interface

uses Windows, Messages, KOL;

type
 PHintRA = ^THintRA;
 THintRA = object(TObj)
  private
    fTI: TToolInfo;
    fDelay:Integer;
    fBeginUpdate:Boolean;
    //св-ва
    fHintHandle: HWND;
    fIsCreateHintHandle:Boolean;

    fHintText:String;//PStrList;
    fShowHint:Boolean;
    fKOLControl:PControl;

    fHideHintOnDelay:boolean;

    fMoveHint:Boolean;
    fColor,fBkColor:TColor;
    fDefaultColor,fDefaultBkColor:Boolean;

    //события
    fOnBeforeShowHint: TOnEvent;
    fOnAfterShowHint: TOnEvent;

    function GoMessage(var Msg: TMsg; var Rslt: Integer): Boolean;
    Procedure SetTI;
    procedure CreateHintHandle;
    procedure DestroyHintHandle;
    procedure SetToolTip;

    function GetHintText: String{PStrList};
    procedure SetHintText(const Value: String{PStrList});

    procedure SetShowHint(const Value:boolean);

    procedure SetKOLControl(const Value:PControl);

    procedure SetColor(const Value:TColor);
    procedure SetBkColor(const Value:TColor);

    function GetOnBeforeShowHint: TOnEvent;
    procedure SetOnBeforeShowHint(const Value: TOnEvent);

    function GetOnAfterShowHint: TOnEvent;
    procedure SetOnAfterShowHint(const Value: TOnEvent);

  public
    property HintText:String{PStrList} read GetHintText write SetHintText;
    property ShowHint:Boolean read fShowHint write SetShowHint;
    property KOLControl:PControl read fKOLControl write SetKOLControl;

    property MoveHint:boolean read fMoveHint write fMoveHint;
    property Color:TColor read fColor write SetColor;
    property BkColor:TColor read fBkColor write SetBkColor;
    property DefaultColor:boolean read fDefaultColor write fDefaultColor;
    property DefaultBkColor:boolean read fDefaultBkColor write fDefaultBkColor;

    property HintHandle:HWND read fHintHandle write fHintHandle;

    property HideHintOnDelay:boolean read fHideHintOnDelay write fHideHintOnDelay;

    //события
    property OnBeforeShowHint: TOnEvent read GetOnBeforeShowHint write SetOnBeforeShowHint;
    property OnAfterShowHint: TOnEvent read GetOnAfterShowHint write SetOnAfterShowHint;

    //методы
    function GetDelay: Integer;
    procedure SetDelay(const Value: Integer);

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure UpdateHint;
    Procedure ShowHintNow;
    destructor Destroy; virtual;
 end;

 TKOLHintRA = PHintRA;

function NewHintRA:PHintRA;

implementation

destructor THintRA.Destroy;
begin
//  fHintText.Free;
  DestroyHintHandle;
  inherited;
end;

function NewHintRA: PHintRA;
begin
  New(Result, Create);
  InitCommonControls;
  //BEGIN нач установки
  Result.fHintText:='';//NewStrList;
//  Result.fHintText.Clear;

  Result.fIsCreateHintHandle:=False;
  Result.fDelay:=Result.GetDelay;
  Result.fBeginUpdate:=False;

  Result.fShowHint:=True;//False;
  Result.fKOLControl:=nil;

  Result.fDefaultColor:=True;
  Result.fDefaultBkColor:=True;
  Result.fColor:=clBlack;
  Result.fBkColor:=clWhite;

  Result.fMoveHint:=False;
  Result.fHideHintOnDelay:=True;
  //END нач установки
end;

procedure THintRA.UpdateHint;
begin
  if (fKOLControl<>nil)and(not fBeginUpdate)
  then UpdateWindow(fHintHandle);
end;

procedure THintRA.DestroyHintHandle;
begin
  if fIsCreateHintHandle then DestroyWindow(fHintHandle);
  fIsCreateHintHandle:=False;
end;

procedure THintRA.CreateHintHandle;
begin
if not(fIsCreateHintHandle)
then begin
  fHintHandle:=CreateWindowEx(WS_EX_TOOLWINDOW{WS_POPUP}{0},
                               TOOLTIPS_CLASS,
                               nil,
                               TBSTYLE_TOOLTIPS,
                               CW_USEDEFAULT,
                               CW_USEDEFAULT,
                               CW_USEDEFAULT,
                               CW_USEDEFAULT,
                               fKOLControl.Handle,
                               0,
                               HInstance,
                               nil);
  fIsCreateHintHandle:=True;
  SendMessage(fHintHandle, TTM_SETDELAYTIME, 0, MakeLong(fDelay, 0));
  SetTI;
  UpDateHint;
end;
end;

function THintRA.GoMessage(var Msg: TMsg; var Rslt: Integer): Boolean;
begin
  Inherited;
  Result:=False;
if fKOLControl<>nil
then begin
  case Msg.message of
    WM_MOUSELEAVE:
    begin
      DestroyHintHandle;
    end;

    WM_MOUSEMOVE:
    begin
    CreateHintHandle;
    if (fShowHint)and(fIsCreateHintHandle)
    then begin
      if Assigned(fOnBeforeShowHint)
      then fOnBeforeShowHint(fKOLControl);

      if fHideHintOnDelay then SendMessage(fHintHandle, TTM_ACTIVATE,Integer(True),0)
      else SetToolTip;

      if fMoveHint then SendMessage(fHintHandle, TTM_UPDATE, 0, 0);

      if Assigned(fOnAfterShowHint)
      then fOnAfterShowHint(fKOLControl);
    end;//if
    end;//WM_MOUSEMOVE
  end;
end;//if
end;

procedure THintRA.SetToolTip;
begin
  SendMessage(fHintHandle, TTM_ADDTOOL,0,DWORD(@fTI));
  SendMessage(fHintHandle, TTM_SETMAXTIPWIDTH, 0, 99999);
  if not(fDefaultBkColor) then SendMessage(fHintHandle, TTM_SETTIPBKCOLOR, BkColor, 0);
  if not(fDefaultColor) then SendMessage(fHintHandle, TTM_SETTIPTEXTCOLOR, Color, 0);
end;

Procedure THintRA.SetTI;
var //HT:String;
    n:integer;
begin
if (fKOLControl<>nil)and(not fBeginUpdate)
then begin
  with fTI do
  begin
    cbSize:=sizeof(fTI);
    uFlags:=TTF_SUBCLASS;
    hWnd:=fKOLControl.Handle;
    uID:=0;
    Rect.Left:=fKOLControl.ClientRect.Left;
    Rect.Top:=fKOLControl.ClientRect.Top;
    Rect.Right:=fKOLControl.ClientRect.Right;
    Rect.Bottom:=fKOLControl.ClientRect.Bottom;
    hInst:=HInstance;

{    if fHintText.Count>=1 then HT:=fHintText.Items[0];
    for n:=1 to fHintText.Count-1 do
      HT:=HT+#13#10+fHintText.Items[n];}
    lpszText:=PChar(fHintText{HT});
  end;
  SetToolTip;
  if fMoveHint then SendMessage(fHintHandle, TTM_UPDATE, 0, 0);
end;//if
end;

Procedure THintRA.ShowHintNow;
begin
  if fKOLControl<>nil
  then begin
    SendMessage(fHintHandle, TTM_ACTIVATE, Integer(False),0);
    SendMessage(fHintHandle, TTM_ACTIVATE, Integer(True),0);
    UpDateHint;
  end;
end;

{HintText}
function THintRA.GetHintText: String{PStrList};
begin
  Result:=fHintText;
  SetTI;
  UpDateHint;
end;

procedure THintRA.SetHintText(const Value: String{PStrList});
begin
  fHintText:=value;
  SetTI;
  UpDateHint;
end;

{ShowHint}

procedure THintRA.SetShowHint(const Value:boolean);
begin
  fShowHint:=value;
  if not(fShowHint)
  then begin
    if fKOLControl<>nil then SendMessage(fHintHandle, TTM_ACTIVATE, Integer(False),0);
  end
  else UpDateHint;
end;

{KOLControl}

procedure THintRA.SetKOLControl(const Value:PControl);
begin
  fKOLControl:=Value;
  if fKOLControl<>nil
  then begin
    fKOLControl.OnMessage:=GoMessage;
  end;//if
end;

{Colors}
procedure THintRA.SetColor(const Value:TColor);
begin
  fDefaultColor:=False;
  fColor:=Value;
  if fKOLControl<>nil then SendMessage(fHintHandle, TTM_SETTIPTEXTCOLOR, Color, 0);
  UpDateHint;
end;

procedure THintRA.SetBkColor(const Value:TColor);
begin
  fDefaultBkColor:=False;
  fBkColor:=Value;
  if fKOLControl<>nil then SendMessage(fHintHandle, TTM_SETTIPBKCOLOR, BkColor, 0);
  UpDateHint;
end;

{Delay}
function THintRA.GetDelay: Integer;
begin
  if fKOLControl<>nil then Result:=SendMessage(fHintHandle, TTM_GETDELAYTIME, 0, 0)
  else Result:=-1;
end;

procedure THintRA.SetDelay(const Value: Integer);
begin
  fDelay:=value;
  if fKOLControl<>nil then SendMessage(fHintHandle, TTM_SETDELAYTIME, 0, MakeLong(fDelay, 0));
  UpDateHint;
end;

{Update}
procedure THintRA.BeginUpdate;
begin
  fBeginUpdate:=True;
end;

procedure THintRA.EndUpdate;
begin
  fBeginUpdate:=False;
  SetTI;
  UpDateHint;
end;

{Events}
function THintRA.GetOnBeforeShowHint:TOnEvent;
begin
  Result:=fOnBeforeShowHint;
end;

procedure THintRA.SetOnBeforeShowHint(const Value: TOnEvent);
begin
  fOnBeforeShowHint:=Value;
end;

function THintRA.GetOnAfterShowHint:TOnEvent;
begin
  Result:=fOnAfterShowHint;
end;

procedure THintRA.SetOnAfterShowHint(const Value: TOnEvent);
begin
  fOnAfterShowHint:=Value;
end;

end.
