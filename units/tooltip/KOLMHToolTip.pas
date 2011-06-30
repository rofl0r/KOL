//{$DEFINE DEBUG}
{$IFDEF DEBUG}
{$DEFINE interface}
{$DEFINE implementation}
{$DEFINE initialization}
{$DEFINE finalization}
{$ENDIF}

{$IFDEF Frame}
unit KOLMHToolTip;

//  MHToolTip Библиотека (MHToolTip Library)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 8-янв(jan)-2003
//  Дата коррекции (Last correction Date): 7-июл(jul)-2003
//  Версия (Version): 1.1
//  EMail: Gandalf@kol.mastak.ru
//  Благодарности (Thanks):
//    BelchonokH
//  Новое в (New in):
//
//  V1.1
//  [!] исправленна ошибка Z-уровня (Fix Z-level bug) <Thanks to BelchonokH> [KOL]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Изменение стилей (Styles)
//  4. Отрисовка (Draw)
//  5. Подчистить (Clear Stuff)
//  6. События (Events)
//  7. Все API (All API's)

interface

uses Windows, KOL, Messages;

type
{$ENDIF Frame}
{$IFDEF interface}


  TFE = (eTextColor, eBkColor, eAPDelay, eRDelay, eIDelay);

  TFI = record
    FE: set of TFE;
    Colors: array[0..1] of TColor;
    Delays: array[0..3] of Integer;
  end;

  PMHToolTipManager = ^TMHToolTipManager;
  TKOLMHToolTipManager = PMHToolTipManager;

  PMHToolTip = ^TMHToolTip;
  TKOLMHToolTip = PMHToolTip;

{$ENDIF interface}

{$IFDEF pre_interface}
  PMHHint = ^TMHHint;
  TKOLMHHint = PMHHint;
{$ENDIF pre_interface}

{$IFDEF interface}

  TMHToolTipManager = object(TObj)
  protected
    destructor Destroy; virtual;
  public
    TTT: array of PMHToolTip;
    function AddTip: Integer;
    function FindNeed(FI: TFI): PMHToolTip;
    function CreateNeed(FI: TFI): PMHToolTip;
  end;

  TMHHint = object(TObj)
  private
    function GetManager:PMHToolTipManager;
    // Spec
    procedure ProcBegin(var TI: TToolInfo);
    procedure ProcEnd(var TI: TToolInfo);
    procedure ReConnect(FI: TFI);
    procedure MoveTool(T1: PMHToolTip);
    procedure CreateToolTip;
    function GetFI: TFI;

    // Group
    function GetDelay(const Index: Integer): Integer;
    procedure SetDelay(const Index: Integer; const Value: Integer);
    function GetColor(const Index: Integer): TColor;
    procedure SetColor(const Index: Integer; const Value: TColor);

    // Local
    procedure SetText(Value: string);
    function GetText: string;
  public
    ToolTip: PMHToolTip;
    HasTool: Boolean;
    Parent: PControl;
    destructor Destroy; virtual;
    procedure Pop;

    property AutoPopDelay: Integer index 2 read GetDelay write SetDelay;
    property InitialDelay: Integer index 3 read GetDelay write SetDelay;
    property ReshowDelay: Integer index 1 read GetDelay write SetDelay;

    property TextColor: TColor index 1 read GetColor write SetColor;
    property BkColor: TColor index 0 read GetColor write SetColor;
    property Text: string read GetText write SetText;
  end;

  TMHToolTip = object(TObj)

  private
    fHandle: THandle;
    Count: Integer;

    function GetDelay(const Index: Integer): Integer;
    procedure SetDelay(const Index: Integer; const Value: Integer);
    function GetColor(const Index: Integer): TColor;
    procedure SetColor(const Index: Integer; const Value: TColor);
    function GetMaxWidth: Integer;
    procedure SetMaxWidth(const Value: Integer);
    function GetMargin: TRect;
    procedure SetMargin(const Value: TRect);
    function GetActivate: Boolean;
    procedure SetActivate(const Value: Boolean);
//    function GetText: string;
//    procedure SetText(const Value: string);
//    function GetToolCount: Integer;
//    function GetTool(Index: Integer): TToolInfo;



  protected

  public
    destructor Destroy; virtual;
    procedure Pop;
    procedure Update;

//    function GetInfo: TToolInfo; // Hide in Info
//    procedure SetInfo(Value: TToolInfo);

//  handle:Thandle;
//    procedure SetC(C: PControl);
//    procedure SetI(C: PControl; S: string);
//    procedure Add(Value: TToolInfo);
//    procedure Delete(Value: TToolInfo);
//    function Connect(Value: PControl): Integer;


//    property OnCloseUp: TOnEvent read GetOnDropDown write SetOnDropDown;



    property AutoPopDelay: Integer index 2 read GetDelay write SetDelay;
    property InitialDelay: Integer index 3 read GetDelay write SetDelay;
    property ReshowDelay: Integer index 1 read GetDelay write SetDelay;

    property TextColor: TColor index 1 read GetColor write SetColor;
    property BkColor: TColor index 0 read GetColor write SetColor;

    property MaxWidth: Integer read GetMaxWidth write SetMaxWidth;

    property Margin: TRect read GetMargin write SetMargin;
    property Activate: Boolean read GetActivate write SetActivate;
    property Handle: THandle read fHandle;
//    property Text: string read GetText write SetText;
//    property ToolCount: Integer read GetToolCount;
//    property Tools[Index: Integer]: TToolInfo read GetTool;

  end;

const
  Dummy = 0;


function NewHint(A: PControl): PMHHint;
function NewManager: PMHToolTipManager;
function NewMHToolTip(AParent: PControl): PMHToolTip;

var
  Manager: PMHToolTipManager;

{$ENDIF interface}

{$IFDEF Frame}

implementation

{$ENDIF Frame}

{$IFDEF implementation}

const
  Dummy1 = 1;

  TTDT_AUTOMATIC = 0;
  TTDT_RESHOW = 1;
  TTDT_AUTOPOP = 2;
  TTDT_INITIAL = 3;

function WndProcMHDateTimePicker(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
//var
//  NMDC: PNMDateTimeChange;
//  MHDateTimePickerNow:PMHDateTimePicker;
//  Data: PDateTimePickerData;
begin
  Result := False;
(*  if Msg.message = WM_NOTIFY then
  begin
    NMDC := PNMDateTimeChange(Msg.lParam);
//    MHDateTimePickerNow:=PMHDateTimePicker(Sender);
//    Data:=MHDateTimePickerNow.CustomData;
//    with Data^ do
    begin
      case NMDC.nmhdr.code of

        TTN_POP:
          begin
            ShowMessage('Pop');
            Result := True;
    {      if NMDC.dwFlags=GDT_VALID then
          begin
            SystemTime2DateTime(NMDC.st,FDateTime);
            if Assigned(MHDateTimePickerNow.OnChange) then
              MHDateTimePickerNow.OnChange(Sender);
            FChecked:=True;
            Result:=True;
          end;
          if NMDC.dwFlags=GDT_NONE then
            FChecked:=False;  }
          end;

    {    DTN_CLOSEUP:
        begin
          if Assigned(FOnCloseUp) then
            FOnCloseUp(Sender);
        end;

        DTN_DROPDOWN:
        begin
          if Assigned(FOnDropDown) then
            FOnDropDown(Sender);
        end;

        DTN_USERSTRING:
        begin
          if Assigned(FOnUserString) then
            FOnUserString(Sender);
        end;

        DTN_FORMAT:
        begin
          if Assigned(FOnFormat) then
            FOnFormat(Sender);
        end;

        DTN_FORMATQUERY:
        begin
          if Assigned(FOnFormatQuery) then
            FOnFormatQuery(Sender);
        end;}

      end; //case
    end;
  end;*)
end;



function NewMHToolTip(AParent: PControl): PMHToolTip;
//var
//  Data: PDateTimePickerData;
//  T: TWndClassEx;
//  a: integer;
const
  CS_DROPSHADOW = $00020000;
begin
  DoInitCommonControls(ICC_BAR_CLASSES);
  New(Result, Create);

  Result.fHandle := CreateWindowEx({WS_EX_TOOLWINDOW}0, TOOLTIPS_CLASS, '', WS_POPUP{ or WS_BORDER}{0}, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, AParent.Handle, 0, HInstance, nil);

  SetWindowPos(Result.fHandle, HWND_TOPMOST,0, 0, 0, 0,
             SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);

//  SetClassLong(Result.handle,GCL_STYLE,CS_DROPSHADOW);

//  Result := PMHToolTip(_NewControl(AParent, TOOLTIPS_CLASS, 0, False, 0)); //PMHToolTip(_NewCommonControl(AParent,TOOLTIPS_CLASS, 0{TTS_ALWAYSTIP}{WS_CHILD or WS_VISIBLE},False,0));
//  Result.Style:=0;
//  Result.ExStyle:=0;
//  GetMem(Data,Sizeof(Data^));
//  FillChar(Data^,Sizeof(Data^),0);
//  a:=SetClassLong(Result.Handle,GCL_STYLE,CS_DROPSHADOW);
//  ShowMessage(Int2Str(a));
//  Result.CustomData:=Data;

{  T.cbSize:=SizeOf(T);
  GetClassInfoEx(hInstance,TOOLTIPS_CLASS,T);
  T.style:=T.style or CS_DROPSHADOW;
  T.hInstance:=hInstance;
  T.lpszClassName:='ZharovHint';
  a:=RegisterClassEx(T);
  ShowMessage(Int2Str(a)); }
//  Result.handle := CreateWindowEx(0, {'ZharovHint'} TOOLTIPS_CLASS, '', 0 {orCS_DROPSHADOW or WS_POPUP or WS_BORDER or CS_SAVEBITS or WS_CHILD or WS_CLIPSIBLINGS}, CW_USEDEFAULT, CW_USEDEFAULT,
//    CW_USEDEFAULT, CW_USEDEFAULT, AParent.Handle, 0, HInstance, nil);
//  Data.ttt:=CreateWindowEx (CS_IMEWS_EX_TOOLWINDOW or WS_EX_CONTROLPARENT{ or CS_SAVEBITS or WS_POPUP or WS_BORDER}{65536},{'ZharovHint'}TOOLTIPS_CLASS,'',{WS_CHILD or}{ WS_VISIBLE}{100663296}{WS_EX_TOOLWINDOW}CS_DROPSHADOW or WS_POPUP or WS_BORDER or CS_SAVEBITS or WS_CHILD or WS_CLIPSIBLINGS,CW_USEDEFAULT,CW_USEDEFAULT,
//                              CW_USEDEFAULT,CW_USEDEFAULT,AParent.Handle,0,HInstance,NIL);
//  SetClassLong(Data.ttt,GCL_STYLE,CS_DROPSHADOW);
//  SendMessage (Data.ttt,TTM_SETDELAYTIME,TTDT_INITIAL,5);
//  SendMessage (Data.ttt,TTM_SETDELAYTIME,TTDT_RESHOW,20);
//  SendMessage (Result.handle,TTM_SETDELAYTIME,TTDT_AUTOPOP,2000);
//  Result.CreateWindow;
//  Result.Parent := AParent;
//  Result.Perform(TTM_SETTIPTEXTCOLOR,clRed,0);
//  SendMessage (Result.handle,TTM_SETTIPTEXTCOLOR,clBlue,0);
//  SendMessage (Result.handle,TTM_SETTIPTEXTCOLOR,clRed,0);
//  Result.Color:=clRed;
//  Result.Font.Color:=clRed;
//  Data.FCalColors:=NewMonthCalColors(Result);
//  Data.FOnDropDown:=nil;
//    Result.AttachProc(WndProcMHDateTimePicker);
//  Result.AttachProc(WndProcMHDateTimePicker);
end;

{procedure TMHToolTip.SetC(C: PControl);
var
  TI: TToolInfo;
  R: Trect;
//  Data:PDateTimePickerData;
begin
  R := C.ClientRect;
 // Control:= C.Handle;
  with TI do
  begin
    cbSize := SizeOf(TI);
    uFlags := TTF_SUBCLASS; // or TTF_IDISHWND;
    hWnd := C.GetWindowHandle; //Control;
    uId := 0;
    rect.Left := R.Left;
    rect.Top := R.Top;
    rect.Right := R.Right;
    rect.Bottom := R.Bottom;
    hInst := 0;
    lpszText := Pchar('I am ' + C.Caption);
  end;
  PostMessage(handle, TTM_ADDTOOL, 0, DWORD(@TI));
//  Perform(TTM_ADDTOOL, 0, DWord(@TI));
end;      }

function TMHToolTip.GetDelay(const Index: Integer): Integer;
begin
  Result := SendMessage(fHandle, TTM_GETDELAYTIME, Index, 0);
end;


procedure TMHToolTip.SetDelay(const Index, Value: Integer);
begin
  SendMessage(handle, TTM_SETDELAYTIME, Index, MAKELONG(Value, 0));
end;


function TMHToolTip.GetColor(const Index: Integer): TColor;
begin
  Result := SendMessage(handle, TTM_GETTIPBKCOLOR + Index, 0, 0);
end;

procedure TMHToolTip.SetColor(const Index: Integer; const Value: TColor);
begin
  SendMessage(handle, TTM_SETTIPBKCOLOR + Index, Value, 0);
end;

function TMHToolTip.GetMaxWidth: Integer;
begin
  Result := SendMessage(fHandle, TTM_GETMAXTIPWIDTH, 0, 0);
end;

procedure TMHToolTip.SetMaxWidth(const Value: Integer);
begin
  SendMessage(fHandle, TTM_SETMAXTIPWIDTH, 0, Value);
end;

{procedure TMHToolTip.SetI(C: PControl; S: string);
var
  TI: TToolInfo;
  R: Trect;
//  Data:PDateTimePickerData;
begin
  R := C.ClientRect;
 // Control:= C.Handle;
  with TI do
  begin
    cbSize := SizeOf(TI);
    uFlags := TTF_SUBCLASS;
    hWnd := C.GetWindowHandle; //Control;
    uId := 0;
    rect.Left := R.Left;
    rect.Top := R.Top;
    rect.Right := R.Right;
    rect.Bottom := R.Bottom;
    hInst := 0;
    lpszText := PChar(S);
  end;
//   PostMessage (handle,TTM_ADDTOOL,0,DWORD (@TI));
//  Perform(TTM_SETTOOLINFO, 0, DWord(@TI));
end;    }

function TMHToolTip.GetMargin: TRect;
begin
  SendMessage(fHandle, TTM_GETMARGIN, 0, DWord(@Result));
end;

procedure TMHToolTip.SetMargin(const Value: TRect);
begin
  SendMessage(fHandle, TTM_SETMARGIN, 0, DWord(@Value));
end;

function TMHToolTip.GetActivate: Boolean;
begin
  // ??????
  Result := False;
end;

procedure TMHToolTip.SetActivate(const Value: Boolean);
begin
  SendMessage(fHandle, TTM_ACTIVATE, DWord(Value), 0);
end;

procedure TMHToolTip.Pop;
begin
  SendMessage(fHandle, TTM_POP, 0, 0);
end;

{function TMHToolTip.GetText: string;
begin

end;

procedure TMHToolTip.SetText(const Value: string);
var
  TI: TToolInfo;
begin
  TI := GetInfo;
  TI.lpszText := PChar(Value);
  SetInfo(TI);
end;       }

{function TMHToolTip.GetInfo: TToolInfo;
begin
  with Result do
  begin
    // ????
    FillChar(Result, SizeOf(Result), 0);
    cbSize := SizeOf(Result);
//    hWnd := Parent.GetWindowHandle;
    uId := 0;
  end;
//  Perform(TTM_GETTOOLINFO, 0, DWord(@Result));
end;

procedure TMHToolTip.SetInfo(Value: TToolInfo);
begin
//  Perform(TTM_SETTOOLINFO, 0, DWord(@Value));
end;}

{function TMHToolTip.GetToolCount: Integer;
begin
//  Result := Perform(TTM_GETTOOLCOUNT, 0, 0);
end;

function TMHToolTip.GetTool(Index: Integer): TToolInfo;
begin
  FillChar(Result, SizeOf(Result), 0); // ????
  Result.cbSize := SizeOf(Result);
//  Perform(TTM_ENUMTOOLS, Index, DWord(@Result));
end;     }

{procedure TMHToolTip.Add(Value: TToolInfo);
begin
//  Perform(TTM_ADDTOOL, 0, DWord(@Value));
end;}

{procedure TMHToolTip.Delete(Value: TToolInfo);
begin
//  Perform(TTM_DELTOOL, 0, DWord(@Value));
end;}

procedure TMHToolTip.Update;
begin
  inherited; // ???
  SendMessage(fHandle, TTM_UPDATE, 0, 0);
end;

function NewHint(A: PControl): PMHHint;
begin
  New(Result, Create);

  with Result^ do
  begin
    Parent := A;
    ToolTip := nil; // ???
    HasTool := False; // ???
  end;
end;

function NewManager: PMHToolTipManager;
begin
  New(Result, Create);
end;

{ TMHHint }

function TMHHint.GetDelay(const Index: Integer): Integer;
begin
//  CreateToolTip;
  if Assigned(ToolTip) then
    Result := ToolTip.GetDelay(Index);
end;

function TMHHint.GetFI: TFI;
begin
  /// !!! DANGER-WITH !!!
  with Result, ToolTip^ do
  begin
    FE := FE + [eTextColor];
    Colors[1] := TextColor;

    FE := FE + [eBkColor];
    Colors[0] := BkColor;

    FE := FE + [eAPDelay];
    Delays[TTDT_AUTOPOP] := AutoPopDelay;

    FE := FE + [eRDelay];
    Delays[TTDT_RESHOW] := ReshowDelay;

    FE := FE + [eIDelay];
    Delays[TTDT_INITIAL] := InitialDelay;
  end;
end;

procedure TMHHint.ReConnect(FI: TFI);
var
  TMP: PMHToolTip;
begin
  with GetManager^ do
  begin
    TMP := FindNeed(FI);
    if not Assigned(TMP) then
      TMP := CreateNeed(FI);
    if Assigned(ToolTip) and HasTool then
      MoveTool(TMP);
    ToolTip := TMP;
  end;
end;

procedure TMHHint.MoveTool(T1: PMHToolTip);
var
  TI: TToolInfo;
  TextL: array[0..255] of Char;
begin
  if T1 = ToolTip then
    Exit;
  with TI do
  begin
    cbSize := SizeOf(TI);
    hWnd := Parent.GetWindowHandle;
    uId := Parent.GetWindowHandle;
    lpszText := @TextL;
  end;

  SendMessage(ToolTip.handle, TTM_GETTOOLINFO, 0, DWord(@TI));
  SendMessage(ToolTip.handle, TTM_DELTOOL, 0, DWORD(@TI));
  ToolTip.Count := ToolTip.Count - 1;
  SendMessage(T1.handle, TTM_ADDTOOL, 0, DWORD(@TI));
  T1.Count := T1.Count - 1;

  HasTool := True;

end;

procedure TMHHint.SetColor(const Index: Integer; const Value: TColor);
var
  FI: TFI;
begin
  if Assigned(ToolTip) then
  begin
    if ToolTip.Count + Byte(not HasTool) = 1 then
    begin
      ToolTip.SetColor(Index, Value);
      Exit;
    end;
    FI := GetFI;
  end;

  case Index of
    0: FI.FE := FI.FE + [eBkColor];
    1: FI.FE := FI.FE + [eTextColor];
  end;
  FI.Colors[Index] := Value;

  ReConnect(FI);
end;

function TMHHint.GetColor(const Index: Integer): TColor;
begin
  if Assigned(ToolTip) then
    Result := ToolTip.GetColor(Index);
end;

procedure TMHHint.SetDelay(const Index, Value: Integer);
var
  FI: TFI;
begin
  if Assigned(ToolTip) then
  begin
    if ToolTip.Count + Byte(not HasTool) = 1 then
    begin
      ToolTip.SetDelay(Index, Value);
      Exit;
    end;
    FI := GetFI;
  end;

  case Index of
    TTDT_AUTOPOP: FI.FE := FI.FE + [eAPDelay]; // Spec
    TTDT_INITIAL: FI.FE := FI.FE + [eIDelay]; // Spec
    TTDT_RESHOW: FI.FE := FI.FE + [eRDelay]; // Spec
  end; //case

  FI.Delays[Index] := Value; //Spec

  ReConnect(FI);
end;

procedure TMHHint.SetText(Value: string);
var
  TI: TToolInfo;
begin
  FillChar(TI,Sizeof(TI),0);
  ProcBegin(TI);

  with TI do
  begin
    uFlags := TTF_SUBCLASS; // Spec
    rect := Parent.ClientRect; // Spec
    lpszText := PChar(Value); // Spec
  end;

  procEnd(TI);

  if HasTool then
  begin
    TI.lpszText := PChar(Value);
    SendMessage(ToolTip.handle, TTM_SETTOOLINFO, 0, DWord(@TI));
  end;

end;

(*
procedure TMHHint.SetText(Value: string);
var
  TI: TToolInfo;
  R: Trect;
  TextLine: array[0..255] of Char;
begin
  if not Assigned(ToolTip) then
  begin
    if Length(Manager.TTT) = 0 then
      Manager.AddTip;
    ToolTip := Manager.TTT[0];
  end;

  with TI do
  begin
    cbSize := SizeOf(TI);
    hWnd := Parent.GetWindowHandle;
    uId := Parent.GetWindowHandle;
    hInst := 0;
  end;

  if not HasTool {TTool = -1} then
  begin
    R := Parent.ClientRect;
 // Control:= C.Handle;
    with TI do
    begin
//      cbSize := SizeOf(TI);
      uFlags := TTF_SUBCLASS;
//      hWnd := Parent.GetWindowHandle; //Control;
//      uId := Parent.GetWindowHandle;
      rect.Left := R.Left;
      rect.Top := R.Top;
      rect.Right := R.Right;
      rect.Bottom := R.Bottom;
//      hInst := 0;
      lpszText := PChar(Value);
    end;
    SendMessage({Manager.TTT[TTip]} ToolTip.handle, TTM_ADDTOOL, 0, DWORD(@TI));
    HasTool := True;
//    TTool := 0;
    ToolTip {Manager.TTT[TTip]}.Count := ToolTip {Manager.TTT[TTip]}.Count + 1;

  end
  else
  begin

    with TI do
    begin
    // ????
//      FillChar(TI, SizeOf(TI), 0);
//      cbSize := SizeOf(TI);
//      hWnd := Parent.GetWindowHandle;
//      uId := Parent.GetWindowHandle;
      lpszText := @TextLine; //PChar(S);
    end;
    SendMessage(ToolTip {Manager.TTT[TTip]}.handle, TTM_GETTOOLINFO, 0, DWord(@TI));
    TI.lpszText := PChar(Value);
//  Perform(TTM_GETTOOLINFO, 0, DWord(@Result));
    SendMessage(ToolTip {Manager.TTT[TTip]}.handle, TTM_SETTOOLINFO, 0, DWord(@TI));
  end;
//  Manager.TTT[TTip].Tool[TTool].SSSetText(Value);
end;
*)

{ TMHToolTipManager }

{function TMHToolTipManager.AddColor(C: TColor): Integer;
begin
  SetLength(TTT, Length(TTT) + 1);
  TTT[Length(TTT) - 1] := NewMHToolTip(Applet);
  TTT[Length(TTT) - 1].SetColor(1, C);
  Result := Length(TTT) - 1;
end;         }

function TMHToolTipManager.AddTip: Integer;
begin
  SetLength(TTT, Length(TTT) + 1);
  TTT[Length(TTT) - 1] := NewMHToolTip(Applet);
  Result := Length(TTT) - 1;
end;

{function TMHToolTip.Connect(Value: PControl): Integer;
var
  TI: TToolInfo;
  R: Trect;
//  Data:PDateTimePickerData;
begin
  R := Value.ClientRect;
 // Control:= C.Handle;
  with TI do
  begin
    cbSize := SizeOf(TI);
    uFlags := TTF_SUBCLASS;
    hWnd := Value.GetWindowHandle; //Control;
    uId := Value.GetWindowHandle;
    rect.Left := R.Left;
    rect.Top := R.Top;
    rect.Right := R.Right;
    rect.Bottom := R.Bottom;
    hInst := 0;
    lpszText := PChar('Super');
  end;
  PostMessage(handle, TTM_ADDTOOL, 0, DWORD(@TI));
//  Perform(TTM_ADDTOOL, 0, DWord(@TI));
end;}

{function TMHToolTipManager.FindTip(N: Integer): Integer;
begin
  Result := -1;
end;}

function TMHToolTipManager.FindNeed(FI: TFI): PMHToolTip;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to length(TTT) - 1 do
  begin
    if ((eTextColor in FI.FE) and (not (FI.Colors[1] = TTT[i].TextColor))) or
      ((eBkColor in FI.FE) and (not (FI.Colors[0] = TTT[i].BkColor))) or
      ((eAPDelay in FI.FE) and (not (FI.Delays[TTDT_AUTOPOP] = TTT[i].AutoPopDelay))) or
      ((eIDelay in FI.FE) and (not (FI.Delays[TTDT_INITIAL] = TTT[i].InitialDelay))) or
      ((eRDelay in FI.FE) and (not (FI.Delays[TTDT_RESHOW] = TTT[i].ReshowDelay))) then
      Continue;
    Result := TTT[i];
    Break;
  end;
end;

function TMHToolTipManager.CreateNeed(FI: TFI): PMHToolTip;

begin
  Setlength(TTT, length(TTT) + 1);
  TTT[length(TTT) - 1] := NewMHToolTip(Applet);
  with TTT[length(TTT) - 1]^ do
  begin
    if (eTextColor in FI.FE) then
      TextColor := FI.Colors[1];
    if (eBkColor in FI.FE) then
      BkColor := FI.Colors[0];
    if (eAPDelay in FI.FE) then
      AutoPopDelay := FI.Delays[TTDT_AUTOPOP];
    if (eIDelay in FI.FE) then
      InitialDelay := FI.Delays[TTDT_INITIAL];
    if (eRDelay in FI.FE) then
      ReshowDelay := FI.Delays[TTDT_RESHOW];
  end;
  Result := TTT[length(TTT) - 1];
end;

procedure TMHHint.ProcBegin(var TI: TToolInfo);
begin
  CreateToolTip;

  with TI do
  begin
    cbSize := SizeOf(TI);
    hWnd := Parent.GetWindowHandle;
    uId := Parent.GetWindowHandle;
    hInst := 0;
  end;
end;

procedure TMHHint.ProcEnd(var TI: TToolInfo);
var
  TextLine: array[0..255] of Char;
begin
  if not HasTool then
  begin
    SendMessage(ToolTip.handle, TTM_ADDTOOL, 0, DWORD(@TI));
    HasTool := True;
    ToolTip.Count := ToolTip.Count + 1;
  end
  else
  begin
    with TI do
    begin
      lpszText := @TextLine;
    end;
    SendMessage(ToolTip.handle, TTM_GETTOOLINFO, 0, DWord(@TI));
  end;
end;

destructor TMHToolTipManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(TTT) - 1 do
    TTT[i].Free;
  SetLength(TTT, 0);
  inherited;
end;

procedure TMHHint.Pop;
begin
  if Assigned(ToolTip) and (HasTool) then
  begin // ^^^^^^^^^^^^ ???
//  CreateToolTip;
    ToolTip.Pop;
  end;
end;

destructor TMHHint.Destroy;
var
  TI: TToolInfo;
begin
  with TI do
  begin
    cbSize := SizeOf(TI);
    hWnd := Parent.GetWindowHandle;
    uId := Parent.GetWindowHandle;
  end;

  SendMessage(ToolTip.handle, TTM_DELTOOL, 0, DWORD(@TI));
  ToolTip.Count := ToolTip.Count - 1;
  Manager.Free;
  inherited;
end;

destructor TMHToolTip.Destroy;
begin
  inherited;
end;

procedure TMHHint.CreateToolTip;
begin
  if not Assigned(ToolTip) then
  begin
    if Length(GetManager.TTT) = 0 then
      GetManager.AddTip;
    ToolTip := GetManager.TTT[0];
  end;
end;

function TMHHint.GetText: string;
var
  TI: TToolInfo;
  TextL: array[0..255] of Char;
begin
  if Assigned(ToolTip) and (HasTool) then
  begin
    // !!!
    with TI do
    begin
    // ????
//      FillChar(TI, SizeOf(TI), 0);
      cbSize := SizeOf(TI);
      hWnd := Parent.GetWindowHandle;
      uId := Parent.GetWindowHandle;
      lpszText := @TextL;
    end;
    SendMessage(ToolTip.handle, TTM_GETTOOLINFO, 0, DWord(@TI));
    Result := TextL; //TI.lpszText;// := PChar(Value);
  end;
end;

function TMHHint.GetManager: PMHToolTipManager;
begin
  if Manager=nil then
    Manager:=NewManager;
  Result:=Manager;
end;

{$ENDIF implementation}

{$IFDEF Frame}

initialization
{$ENDIF Frame}
{$IFDEF initialization}

  Manager := NewManager;
{$ENDIF initialization}

{$IFDEF Frame}
finalization
{$ENDIF Frame}
{$IFDEF finalization}
//  Manager.Free;
{$ENDIF finalization}


{$IFDEF Frame}
end.
{$ENDIF Frame}

{$IFDEF function}
function GetHint: PMHHint;
{$ENDIF function}

{$IFDEF public}
  property Hint: PMHHint read GetHint;
  {$ENDIF public}

  {$IFDEF code}
    function TControl.GetHint: PMHHint;
    begin
      if fHint = nil then
        fHint := NewHint(@Self);
      Result := fHint;
    end;
  {$ENDIF code}

  {$IFDEF destroy}
    fHint.Free;
  {$ENDIF destroy}

  {$IFDEF var}
    fHint: PMHHint;
  {$ENDIF var}

