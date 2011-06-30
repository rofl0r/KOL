unit KOLMHIPEdit;
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
  KOL, Windows{, ShellAPI,CommDlg},Messages;

type
  TTrackBarOrientation = (trHorizontal, trVertical);
  TTickMark = (tmBottomRight, tmTopLeft, tmBoth);
  TTickStyle = (tsNone, tsAuto, tsManual);

{  TField=class(TObj)
  private
    FUpRange:Byte;
    FDownRange:Byte;
    FValue:Byte;
//    procedure SetUpRange(const Value:Byte);
//    procedure SetDownRange(const Value:Byte);
//    procedure SetValue(const Value:Byte);
  published
//    property UpRange:Byte read FUpRange write SetUpRange;
//    property DownRange:Byte read FDownRange write SetDownRange;
//    property Value:Byte read FValue write SetValue;
  end;}

  RClearField=record
    UpRange:Byte;
    DownRange:Byte;
  end;

{  RField=record
    UpRange:Byte;
    DownRange:Byte;
    Value:Byte;
  end; }

  TFieldFocusRange=0..3;

  PField=^RField;
  RField=object(TObj)  // ???
  private
    Owner:PControl;
    FUpRange:Byte;
    FDownRange:Byte;
    Index:Integer;
    procedure SetUpRange(const AValue:Byte);
    procedure SetDownRange(const AValue:Byte);
    procedure SetValue(const AValue:Byte);
    function GetValue:Byte;
  public
    property UpRange:Byte read FUpRange write SetUpRange;
    property DownRange:Byte read FDownRange write SetDownRange;
    property Value:Byte read GetValue write SetValue;
  end;

   PMHIPEdit =^TMHIPEdit;
   TKOLMHIPEdit = PMHIPEdit;//PControl;
   TMHIPEdit = object(TControl)//TObj)
   private

     function GetBlank:Boolean;
     procedure SetBlank(const Value:Boolean);

     function GetField(Index:Integer):PField;
     procedure SetField(Index:Integer; const Value:PField);
    procedure SetFieldFocus(const Value: TFieldFocusRange);

     

{     function GetLeft:Integer;
     procedure SetLeft(const Value:Integer);
     function GetTop:Integer;
     procedure SetTop(const Value:Integer);
     function GetWidth:Integer;
     procedure SetWidth(const Value:Integer);
     function GetHeight:Integer;
     procedure SetHeight(const Value:Integer);}
   {  function GetCursor:HCursor;
     procedure SetCursor(const Value:HCursor);

     procedure SetVisible(const Value: Boolean );
     function GetVisible: Boolean;

     procedure SetOnScroll(const Value: TOnScroll);
     function GetOnScroll:TOnScroll;

     procedure SetOnKeyUp(const Value: TOnKey);
     function GetOnKeyUp:TOnKey;

     procedure SetOnKeyDown(const Value: TOnKey);
     function GetOnKeyDown:TOnKey;


     procedure SetOnMove(const Value: TOnEvent);
     function GetOnMove:TOnEvent;


     }
{     procedure SetOnEnter(const Value: TOnEvent);
     function GetOnEnter:TOnEvent;

     procedure SetOnLeave(const Value: TOnEvent);
     function GetOnLeave:TOnEvent;}
{
       procedure SetOnHide(const Value: TOnEvent);
       function GetOnHide:TOnEvent;

       procedure SetOnShow(const Value: TOnEvent);
       function GetOnShow:TOnEvent;}

      { procedure SetOnMouseMove(const Value:TOnMouse);
       function GetOnMouseMove:TOnMouse;

       procedure SetOnMouseUp(const Value:TOnMouse);
       function GetOnMouseUp:TOnMouse;

       procedure SetOnMouseDown(const Value:TOnMouse);
       function GetOnMouseDown:TOnMouse;

//       procedure SetOnMouseDblClk(const Value:TOnMouse);
//       function GetOnMouseDblClk:TOnMouse;

       procedure SetOnMouseWheel(const Value:TOnMouse);
       function GetOnMouseWheel:TOnMouse;

       procedure SetOnMouseEnter(const Value:TOnEvent);
       function GetOnMouseEnter:TOnEvent;

       procedure SetOnMouseLeave(const Value:TOnEvent);
       function GetOnMouseLeave:TOnEvent;

       procedure SetOnMessage(const Value:TOnMessage);
       function GetOnMessage:TOnMessage;

//       procedure SetOnClick(const Value: TOnEvent);
//       function GetOnClick:TOnEvent;

       procedure SetOnResize(const Value:TOnEvent);
       function GetOnResize:TOnEvent;

       procedure SetOnDropFiles(const Value:TOnDropFiles);
       function GetOnDropFiles:TOnDropFiles;

       procedure SetOnPaint(const Value:TOnPaint);
       function GetOnPaint:TOnPaint;

       procedure SetOnChar(const Value: TOnChar);
       function GetOnChar:TOnChar;}
  public
    destructor Destroy; virtual;
    procedure Recreate;

    property Blank:Boolean read GetBlank write SetBlank;

    property Fields[Index:Integer]:PField read GetField write SetField;

    property FieldFocus:TFieldFocusRange write SetFieldFocus;

{    property Cursor: HCursor read GetCursor write SetCursor;

    property Visible: Boolean read GetVisible write SetVisible;

    property OnScroll:TOnScroll read GetOnScroll write SetOnScroll;
    property OnKeyDown: TOnKey read GetOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TOnKey read GetOnKeyUp write SetOnKeyUp;
//    property OnShow: TOnEvent read GetOnShow write SetOnShow;
//    property OnHide: TOnEvent read GetOnHide write SetOnHide;
    property OnMove: TOnEvent read GetOnMove write SetOnMove;
    property OnMouseMove: TOnMouse read GetOnMouseMove write SetOnMouseMove;
//    property OnEnter: TOnEvent read GetOnEnter write SetOnEnter;
//    property OnLeave: TOnEvent read GetOnLeave write SetOnLeave;
    property OnMessage: TOnMessage read GetOnMessage write SetOnMessage;
//    property OnClick: TOnEvent read GetOnClick write SetOnClick;

    property OnMouseDown: TOnMouse read GetOnMouseDown write SetOnMouseDown;
    property OnMouseUp: TOnMouse read GetOnMouseUp write SetOnMouseUp;
//    property OnMouseDblClk: TOnMouse read GetOnMouseDblClk write SetOnMouseDblClk;
    property OnMouseWheel: TOnMouse read GetOnMouseWheel write SetOnMouseWheel;
    property OnMouseEnter: TOnEvent read GetOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read GetOnMouseLeave write SetOnMouseLeave;
    property OnResize: TOnEvent read GetOnResize write SetOnResize;
    property OnDropFiles: TOnDropFiles read GetOnDropFiles write SetOnDropFiles;
    property OnPaint: TOnPaint read GetOnPaint write SetOnPaint;
    property OnChar: TOnChar read GetOnChar write SetOnChar;}
  end;

  PIPEditData = ^TIPEditData;
  TIPEditData = packed record
    FFields:array [0..3] of PField;
  end;

const
  IPEDIT_CLASS = 'SysIPAddress32';

  IPM_CLEARADDRESS=(WM_USER+100); // no parameters // +++
  IPM_SETADDRESS=(WM_USER+101); // lparam = TCP/IP address //+++
  IPM_GETADDRESS=(WM_USER+102); // lresult = # of non black fields.  lparam = LPDWORD for TCP/IP address // +++
  IPM_SETRANGE=(WM_USER+103); // wparam = field, lparam = range // +++
  IPM_SETFOCUS=(WM_USER+104); // wparam = field
  IPM_ISBLANK=(WM_USER+105);  // +++



function NewMHIPEdit(AParent:PControl{; Left,Top,Width,Height:Integer}):PMHIPEdit;//PControl;


implementation


{function WndProcTrackBar( Control: PControl; var Msg: TMsg; var Rslt: Integer ) : Boolean;
var Bar: TScrollerBar;
begin
  Bar := sbHorizontal; //0
  if Msg.message = WM_VSCROLL then
    Bar := sbVertical
  else
  if Msg.message <> WM_HSCROLL then
  begin
    Result := FALSE;
    Exit;
  end;

  if Assigned( Control.OnScroll ) then
    Control.OnScroll( Control, Bar, LoWord( Msg.wParam ), HiWord( Msg.wParam ) );
  Result := FALSE;
end;
 }
{function WndProcMHFontDialog( Control: PControl; var Msg: TMsg; var Rslt: Integer ) : Boolean;
begin
  Result:=False;
  if Msg.message=HelpMessageIndex then
  begin
    if Assigned( MHFontDialogNow.FOnHelp ) then
      MHFontDialogNow.FOnHelp( @MHFontDialogNow);
    Rslt:=0;
    Result:=True;
  end;
end;

function NewMHFontDialog(Wnd: PControl):PMHFontDialog;
begin
  New(Result, Create);
  Result.FControl:=Wnd;
  Result.Font:=NewFont;
  Result.FInitFont :=NewFont;
  Wnd.AttachProc(WndProcMHFontDialog);
end;}

procedure RField.SetUpRange(const AValue:Byte);
begin
  if SendMessage(Owner.Handle,IPM_SETRANGE,Index,MakeWord(FDownRange,AValue))<>0 then
    FUpRange:=AValue;
end;

procedure RField.SetDownRange(const AValue:Byte);
begin
  if SendMessage(Owner.Handle,IPM_SETRANGE,Index,MakeWord(AValue,FUpRange))<>0 then
    FDownRange:=AValue;
end;

procedure RField.SetValue(const AValue:Byte);
var
  TMPDWord,Mask:DWord;
begin
  SendMessage(Owner.Handle,IPM_GETADDRESS,0,DWord(@TMPDWord));
  Mask:=not (255 shl (8*(3-Index)));
  TMPDWord:=(TMPDWord and Mask) or (AValue shl (8*(3-Index)));
  SendMessage(Owner.Handle,IPM_SETADDRESS,0,TMPDWord);
end;

function RField.GetValue:Byte;
var
  TMPDWord,Mask:DWord;
begin
  SendMessage(Owner.Handle,IPM_GETADDRESS,0,DWord(@TMPDWord));
  Mask:=255 shl (8*(3-Index));
  Result:=(TMPDWord and Mask) shr (8*(3-Index));
end;

function NewField(AOwner:PControl; AIndex:Integer):PField;
begin
  New(Result, Create);
  Result.Owner:=AOwner;
  Result.FUpRange:=255;
  Result.Index:=AIndex;
end;

function NewMHIPEdit(AParent:PControl{; Left,Top,Width,Height:Integer}):PMHIPEdit;//PControl;
var
//  P:PMHIPEdit;
  Data:PIPEditData;
//  OrientationFlag,TickMarksFlag,SliderVisibleFlag:DWord;
begin
//  New(P, create);
//  AParent.Add2AutoFree(P);
  Result:=PMHIPEdit(_NewCommonControl(AParent, IPEDIT_CLASS, WS_CHILD or WS_VISIBLE,False,0));
//  P.FMHIPEdit:=_NewCommonControl(AParent, IPEDIT_CLASS, WS_CHILD or WS_VISIBLE,False,0);

  GetMem(Data,Sizeof(Data^));
  FillChar(Data^,Sizeof(Data^),0);
  Result.CustomData:=Data;

//  P.FMHIPEdit.CreateWindow;
//  InitCommonControlCommonNotify(P.FMHIPEdit);
//  P.FMHIPEdit.Left:=Left;
//  P.FMHIPEdit.Top:=Top;
//  P.FMHIPEdit.Width:=Width;
//  P.FMHIPEdit.Height:=Height;
//  Result:=P;
end;

destructor TMHIPEdit.Destroy;
begin
   inherited;
end;

procedure TMHIPEdit.Recreate;
//var
//  TMPParent:PControl;
//  OrientationFlag,TickMarksFlag,SliderVisibleFlag:DWord;
//  TMPLeft,TMPTop,TMPWidth,TMPHeight:Integer;
 { TMPSelStart,TMPSelEnd:DWord;
  TMPMin,TMPMax,TMPPosition:DWord;
  TMPFrequency,TMPPageSize,TMPLineSize:DWord;
  TMPThumbLength:Integer;}
begin
 (* TMPParent:=FMHIPEdit.Parent;
  TMPLeft:=Left;
  TMPTop:=Top;
  TMPWidth:=Width;
  TMPHeight:=Height;
  {TMPThumbLength:=ThumbLength;
  TMPSelStart:=SelStart;
  TMPSelEnd:=SelEnd;
  TMPMin:=Min;
  TMPMax:=Max;
  TMPPosition:=Position;
  TMPFrequency:=Frequency;
  TMPPageSize:=PageSize;
  TMPLineSize:=LineSize;}
  FMHIPEdit.Free;
{  case Orientation of
    trHorizontal:OrientationFlag:=TBS_HORZ;
    trVertical:OrientationFlag:=TBS_VERT;
  end; //case
  case TickMarks of
    tmBottomRight:TickMarksFlag:=TBS_BOTTOM or TBS_RIGHT;
    tmTopLeft:TickMarksFlag:=TBS_TOP or TBS_LEFT;
    tmBoth:TickMarksFlag:=TBS_BOTH;
  end; //case
  if SliderVisible then
    SliderVisibleFlag:=0
  Else
    SliderVisibleFlag:=TBS_NOTHUMB;}
  FMHIPEdit:=_NewCommonControl(TMPParent, IPEDIT_CLASS, WS_CHILD or WS_VISIBLE,False,0);//Result;
  FMHIPEdit.CreateWindow;
  InitCommonControlCommonNotify(FMHIPEdit);
//  FMHTrackBar:=_NewCommonControl(TMPParent, TRACKBAR_CLASS, WS_CHILD or WS_VISIBLE or TBS_AUTOTICKS or TBS_ENABLESELRANGE or OrientationFlag or TickMarksFlag  or SliderVisibleFlag,False,0{ @ListViewActions });//Result;
//  FMHTrackBar.CreateWindow;
  Left:=TMPLeft;
  Top:=TMPTop;
  Width:=TMPWidth;
  Height:=TMPHeight;
{  Min:=TMPMin;
  Max:=TMPMax;
  Position:=TMPPosition;
  ThumbLength:=TMPThumbLength;
  SelStart:=TMPSelStart;
  SelEnd:=TMPSelEnd;
  Frequency:=TMPFrequency;
  PageSize:=TMPPageSize;
  LineSize:=TMPLineSize;}*)
end;


procedure TMHIPEdit.SetBlank(const Value:Boolean);
begin
  if Value then
    Perform(IPM_CLEARADDRESS,0,0);
end;

function TMHIPEdit.GetBlank:Boolean;
begin
  Result:=Boolean(Perform(IPM_ISBLANK,0,0));
end;


procedure TMHIPEdit.SetField({const} Index:Integer; const Value:PField);
//var
//  TMPDWord,Mask:DWord;
//  Data:PIPEditData;
begin
(*  Data:=CustomData;
//  if (Data.FFields[Index].UpRange<>Value.UpRange) or (Data.FFields[Index].DownRange<>Value.DownRange) then
    if Perform{SendMessage(FMHIPEdit.Handle,}(IPM_SETRANGE,Index,Value.UpRange+Value.DownRange*256)<>0 then
    begin
      Data.FFields[Index].UpRange:=Value.UpRange;
      Data.FFields[Index].DownRange:=Value.DownRange;
    end;
  Perform{SendMessage(FMHIPEdit.Handle,}(IPM_GETADDRESS,0,DWord(@TMPDWord));
  Mask:=not (255 shl (8*(3-Index)));
  TMPDWord:=(TMPDWord and Mask) or (Value.Value shl (8*(3-Index)));
  Perform{SendMessage(FMHIPEdit.Handle,}(IPM_SETADDRESS,0,TMPDWord);
  *)
end;

function TMHIPEdit.GetField({const} Index:Integer):PField;
var
//  TMPDWord,Mask:DWord;
  Data:PIPEditData;
begin
  Data:=CustomData;
  if Data.FFields[Index]=nil then
    Data.FFields[Index]:=NewField(@Self,Index);
  Result:=Data.FFields[Index];
end;


 {
function TMHTrackBar.GetHandle:HWnd;
begin
  Result:=FMHTrackBar.Handle;
end;

procedure TMHTrackBar.SetOnScroll(const Value: TOnScroll);
begin
  FMHTrackBar.Parent.OnScroll := Value;
//  FMHTrackBar.Parent.AttachProc(WndProcTrackBar);

//  FMHTrackBar.AttachProc(WndProcOnScroll);
end;

function TMHTrackBar.GetOnScroll:TOnScroll;
begin
  Result:=FMHTrackBar.Parent.OnScroll;
//  KOL.SetScrollEvent( @Self );
end;

procedure TMHTrackBar.SetOnKeyUp(const Value: TOnKey);
begin
  FMHTrackBar.OnKeyUp := Value;
end;

function TMHTrackBar.GetOnKeyUp:TOnKey;
begin
  Result:=FMHTrackBar.OnKeyUp;
end;

procedure TMHTrackBar.SetOnKeyDown(const Value: TOnKey);
begin
  FMHTrackBar.OnKeyDown := Value;
end;

function TMHTrackBar.GetOnKeyDown:TOnKey;
begin
  Result:=FMHTrackBar.OnKeyDown;
end;

procedure TMHTrackBar.SetOnMove(const Value: TOnEvent);
begin
  FMHTrackBar.Parent.OnMove:=Value;
end;

function TMHTrackBar.GetOnMove:TOnEvent;
begin
  Result:=FMHTrackBar.Parent.OnMove;
end;

 }
{procedure TMHTrackBar.SetOnEnter(const Value: TOnEvent);
begin
  FMHTrackBar.Parent.OnEnter:=Value;
end;

function TMHTrackBar.GetOnEnter:TOnEvent;
begin
  Result:=FMHTrackBar.Parent.OnEnter;
end;

procedure TMHTrackBar.SetOnLeave(const Value: TOnEvent);
begin
  FMHTrackBar.Parent.OnLeave:=Value;
end;

function TMHTrackBar.GetOnLeave:TOnEvent;
begin
  Result:=FMHTrackBar.Parent.OnLeave;
end;

 }
{
procedure TMHTrackBar.SetOnShow(const Value: TOnEvent);
begin
  FMHTrackBar.OnShow:=Value;
end;

function TMHTrackBar.GetOnShow:TOnEvent;
begin
  Result:=FMHTrackBar.OnShow;
end;

procedure TMHTrackBar.SetOnHide(const Value: TOnEvent);
begin
  FMHTrackBar.OnShow:=Value;
end;

function TMHTrackBar.GetOnHide:TOnEvent;
begin
  Result:=FMHTrackBar.OnShow;
end;
}

{procedure TMHTrackBar.SetOnMessage(const Value: TOnMessage);
begin
  FMHTrackBar.OnMessage:=Value;
end;

function TMHTrackBar.GetOnMessage:TOnMessage;
begin
  Result:=FMHTrackBar.OnMessage;
end;

procedure TMHTrackBar.SetOnMouseMove(const Value:TOnMouse);
begin
  FMHTrackBar.OnMouseMove:=Value;
end;

function TMHTrackBar.GetOnMouseMove:TOnMouse;
begin
  Result:=FMHTrackBar.OnMouseMove;
end;

procedure TMHTrackBar.SetOnMouseUp(const Value:TOnMouse);
begin
  FMHTrackBar.OnMouseUp:=Value;
end;

function TMHTrackBar.GetOnMouseUp:TOnMouse;
begin
  Result:=FMHTrackBar.OnMouseUp;
end;

procedure TMHTrackBar.SetOnMouseDown(const Value:TOnMouse);
begin
  FMHTrackBar.OnMouseDown:=Value;
end;

function TMHTrackBar.GetOnMouseDown:TOnMouse;
begin
  Result:=FMHTrackBar.OnMouseDown;
end;

procedure TMHTrackBar.SetOnMouseWheel(const Value:TOnMouse);
begin
  FMHTrackBar.OnMouseWheel:=Value;
end;

function TMHTrackBar.GetOnMouseWheel:TOnMouse;
begin
  Result:=FMHTrackBar.OnMouseWheel;
end;
 }
{procedure TMHTrackBar.SetOnMouseDblClk(const Value:TOnMouse);
begin
  FMHTrackBar.OnMouseDblClk:=Value;
end;

function TMHTrackBar.GetOnMouseDblClk:TOnMouse;
begin
  Result:=FMHTrackBar.OnMouseDblClk;
end;}

{procedure TMHTrackBar.SetOnMouseEnter(const Value:TOnEvent);
begin
  FMHTrackBar.OnMouseEnter:=Value;
end;

function TMHTrackBar.GetOnMouseEnter:TOnEvent;
begin
  Result:=FMHTrackBar.OnMouseEnter;
end;

procedure TMHTrackBar.SetOnMouseLeave(const Value:TOnEvent);
begin
  FMHTrackBar.OnMouseLeave:=Value;
end;

function TMHTrackBar.GetOnMouseLeave:TOnEvent;
begin
  Result:=FMHTrackBar.OnMouseLeave;
end;

procedure TMHTrackBar.SetOnResize(const Value:TOnEvent);
begin
  FMHTrackBar.OnResize:=Value;
end;

function TMHTrackBar.GetOnResize:TOnEvent;
begin
  Result:=FMHTrackBar.OnResize;
end;

procedure TMHTrackBar.SetOnDropFiles(const Value:TOnDropFiles);
begin
  FMHTrackBar.OnDropFiles:=Value;
end;

function TMHTrackBar.GetOnDropFiles:TOnDropFiles;
begin
  Result:=FMHTrackBar.OnDropFiles;
end;

function TMHTrackBar.GetOnPaint:TOnPaint;
begin
  Result:=FMHTrackBar.OnPaint;
end;

procedure TMHTrackBar.SetOnPaint(const Value:TOnPaint);
begin
  FMHTrackBar.OnPaint:=Value;
end;

function TMHTrackBar.GetOnChar:TOnChar;
begin
  Result:=FMHTrackBar.OnChar;
end;

procedure TMHTrackBar.SetOnChar(const Value:TOnChar);
begin
  FMHTrackBar.OnChar:=Value;
end;
 }
{
procedure TMHTrackBar.SetOnClick(const Value: TOnEvent);
begin
  FMHTrackBar.OnClick:=Value;
end;

function TMHTrackBar.GetOnClick:TOnEvent;
begin
  Result:=FMHTrackBar.OnClick;
end;
     }
{procedure TMHTrackBar.SetVisible(const Value: Boolean);
begin
  FMHTrackBar.Visible:=Value;
end;

function TMHTrackBar.GetVisible:Boolean;
begin
  Result:=FMHTrackBar.Visible;
end;
}


procedure TMHIPEdit.SetFieldFocus(const Value: TFieldFocusRange);
begin
  Perform(IPM_SETFOCUS,Value,0);
end;

end.

