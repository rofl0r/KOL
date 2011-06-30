unit KOLSIZER;
//
// purpose: KOL control sizercontrol and design grid
//  author: © 2004, Thaddy de Koning
// Remarks: Tnx in part to Marco Cantu for the sizer idea in DDH3
//          copyrighted freeware.
//
interface

uses
  Windows, Messages, Kol;

const
  // Size and move commands for SysCommand
  SZ_LEFT = $F001;
  SZ_RIGHT = $F002;
  SZ_TOP = $F003;
  SZ_TOPLEFT = $F004;
  SZ_TOPRIGHT = $F005;
  SZ_BOTTOM = $F006;
  SZ_BOTTOMLEFT = $F007;
  SZ_BOTTOMRIGHT = $F008;
  SZ_MOVE = $F012;


type
  TPosInfo = record
    Rect:Trect;
    Pos:integer;
    Direction:integer;
  end;

  PSizerdata=^ TSizerdata;
  TSizerdata= object(Tobj)
    FControl:PControl;
    FPosInfo: array [0..7] of TPosInfo;
    Direction:longint;
    procedure Dopaint(sender:pControl;DC:HDC);
  end;



  PHack =^ THack;
  THack = object(Tcontrol)
  end;

  PDesigner=^TDesigner;
  TDesigner=object(TStrlistEx)
  private
    FOwner:pControl;
    FSpacing:Cardinal;
    FOldPaint:TOnPaint;
    FActive: boolean;
    FSizer:PControl;
    FOnControlChange: TonEvent;
    FOnDblClick:TOnEvent;
    FOnMouseDown:TOnMouse;
    FCurrent: pControl;
    FAction:integer;
    procedure setactive(const Value: boolean);
    function PrepareClassname(aControl: PControl): String;
    function UniqueName(aName: String): String;
    procedure SetCurrent(const Value: pControl);
    procedure InternalControlChange(sender:pObj);
    procedure Setspacing(Space:cardinal = 8);
 protected
    procedure init;virtual;
    procedure DoKeyUp( Sender: PControl; var Key: Longint; Shift: DWORD );
  public
    destructor destroy;virtual;
    procedure Connect(aName: String; aControl: pControl);
    procedure DisConnect(aControl: pControl);
    procedure Paintgrid(sender:pControl;DC:HDC);
    property Spacing:cardinal read FSpacing write setspacing;
    property Active:boolean read FActive write setactive;
    property Action:integer read FAction write Faction;
    property Current:pControl read FCurrent write SetCurrent;
    property OnControlChange:TOnEvent Read FOnControlchange write FOnControlChange;
    property OnDblClick:TonEvent read fOnDblClick write FOnDblClick;
    property OnMouseDown:TOnMouse read FOnMouseDown write FOnMouseDown;
  end;

function NewSizerControl(AControl: PControl;aDesigner:PDesigner):PControl;
function NewDesigner(aOwner:pControl):pDesigner;
var
  LocalDesigner:PDesigner;

implementation


function DesignHandlerProc(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var MouseData:TMouseEventData;
begin
  Result:=false;
  case msg.message of
  WM_LBUTTONDOWN:
    begin
    if Localdesigner.FOwner<> sender then LocalDesigner.current:=sender;
    Result:=true;
    {
    if assigned(Localdesigner.OnMousedown) then
    // Borrowed from KOL.pas
    // enables us to pass on KOL mouse events back to the designer
    // without having to connect to true KOL eventproperties.
    with MouseData do
    begin
      Shift := Msg.wParam;
      if GetKeyState(VK_MENU) < 0 then
        Shift := Shift or MK_ALT;
      X := LoWord(Msg.lParam);
      Y := HiWord(Msg.lParam);
      Button := mbNone;
      StopHandling := true;
      Rslt := 0; // needed ?
      LocalDesigner.OnMousedown(sender,Mousedata);
      Result:=true
    end;
     }
    end

  end;
end;

// TSizerControl methods
function WndProcSizer( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var
  Pt: TPoint;
  I: Integer;
  R:Trect;
  Data:PSizerdata;
begin
  Data:=PSizerdata(sender.CustomObj);
  Result:=True;
  with sender^, Data^ do
  begin
  case msg.message of
  WM_NCHITTEST:
      begin
        Pt := MakePoint(loword(Msg.lparam), hiword(Msg.lparam));
        Pt := Screen2Client (Pt);
        Rslt:=0;
        for I := 0 to  7 do
        if PtInRect (FPosInfo [I].rect, Pt) then
        begin
          // The value of rslt is passed on and makes
          // the system select the correct cursor
          // without us having to do anything more.
          Rslt := FPosInfo [I].pos;
          Direction:=FPosInfo[i].direction;
        end;
        if Rslt = 0 then
            Result:=False;
      end;
  WM_SIZE:
      begin
        R := BoundsRect;
        InflateRect (R, -2, -2);
        Fcontrol.BoundsRect := R;
        FPosInfo [0].rect := MakeRect (0, 0, 5, 5);
        FPosInfo [1].rect := MakeRect (Width div 2 - 3, 0,
          Width div 2 + 2, 5);
        FPosInfo [2].rect := MakeRect (Width - 5, 0, Width, 5);
        FPosInfo [3].rect := MakeRect (Width - 5, Height div 2 - 3,
         Width, Height div 2 + 2);
        FPosInfo [4].rect := MakeRect (Width - 5, Height - 5,
         Width, Height);
        FPosInfo [5].rect := MakeRect (Width div 2 - 3, Height - 5,
          Width div 2 + 2, Height);
        FPosInfo [6].rect := MakeRect (0, Height - 5, 5, Height);
        FPosInfo [7].rect := MakeRect (0, Height div 2 - 3,
         5, Height div 2 + 2);
      end;
  WM_NCLBUTTONDOWN:
        Perform (wm_SysCommand, Direction, 0);
  WM_LBUTTONDOWN:
        Perform (wm_SysCommand, sz_move, 0);
  WM_MOVE:
      begin
        R := BoundsRect;
        InflateRect (R, -2, -2);
        Fcontrol.Invalidate;
        Fcontrol.BoundsRect := R;
      end;
  else
    Result:=false;
  end;
  end;
end;

function NewSizerControl(AControl: PControl;aDesigner:PDesigner):PControl;
var
  R: TRect;
  Data:PSizerdata;
begin
  New(Data,Create);
  Result:=NewPaintBox(aControl);
  Result.ExStyle :=Result.ExStyle or ws_ex_transparent;
  Result.OnKeyUp:=aDesigner.DoKeyUp;
  if aDesigner.fowner<>aControl then
  With result^, Data^  do
  begin
    FControl := AControl;
    // set the size and position
    R := aControl.BoundsRect;
    InflateRect (R, 2, 2);
    BoundsRect := R;
    // set the parent
    Parent := aControl.Parent;
    // create the list of positions
    FPosInfo [0].pos := htTopLeft;
    FPosInfo [0].direction := sz_TopLeft;
    FPosInfo [1].pos := htTop;
    FPosInfo [1].direction := sz_Top;
    FPosInfo [2].pos := htTopRight;
    FPosInfo [2].direction := sz_TopRight;
    FPosInfo [3].pos := htRight;
    FPosInfo [3].direction := sz_Right;
    FPosInfo [4].pos := htBottomRight;
    FPosInfo [4].direction := sz_BottomRight;
    FPosInfo [5].pos := htBottom;
    FPosInfo [5].direction := sz_Bottom;
    FPosInfo [6].pos := htBottomLeft;
    FPosInfo [6].direction := sz_BottomLeft;
    FPosInfo [7].pos := htLeft;
    FPosInfo [7].direction := sz_Left;
    CustomObj:=Data;
    OnPaint:=DoPaint;
    AttachProc(WndProcSizer);
    Bringtofront;
    Focused:=true
  end;
end;

procedure TSizerData.DoPaint(sender:pControl;DC:HDC);
var
  I: Integer;
begin
  // I simply use the current pen and brush
   with pSizerdata(sender.Customobj)^ do
     for I := 0 to  7 do
      Rectangle(dc,FPosInfo [I].rect.Left, FPosInfo [I].rect.Top,
         FPosInfo [I].rect.Right, FPosInfo [I].rect.Bottom);
end;

procedure TDesigner.init;
begin
 inherited;
 Fspacing:=8;
end;

procedure TDesigner.Paintgrid(sender: pControl; DC: HDC);
var
  i, j: Integer;
begin
  i := 0;
  j := 0;
    sender.canvas.FillRect(sender.canvas.cliprect);
    if Assigned(FOldPaint) then FOldPaint(sender,DC);
    repeat
      repeat
        MoveToEx(Dc,i, j,nil);
        LineTo(Dc,i + 1,j);
        inc(i, Fspacing);
      until i > sender.ClientWidth;
      i := 0;
      inc(j, Fspacing);
    until j > sender.Clientheight;
end;

procedure TDesigner.Setspacing(Space: cardinal);
begin
  Fspacing:=Space;
  FOwner.invalidate;
end;

{ TDesigner }
function NewDesigner(aOwner:pControl):pDesigner;
begin
  if Assigned(LocalDesigner) then
  begin
    result:=LocalDesigner;
    MsgOk(' Exists' );
  end else
  begin
    New(Result,Create);
    with result^ do
    begin
      Fowner:=aOwner;
      Connect('',Fowner);
      FOldPaint:=Fowner.OnPaint;
      LocalDesigner:=Result;
      //Result.Current:=aOwner;
    end
  end
end;

destructor TDesigner.destroy;
begin
  setactive(false);
  FOwner.OnPaint:=FOldPaint;
  inherited;
end;

//Note: Make shure that whatever happens, all pointers are nil or valid!
//      Took a long time to debug spurious crashes.
//      So this is not excessively safe.
procedure TDesigner.setactive(const Value: boolean);
var
  i:integer;
begin
  FActive := Value;
  if FActive then
  begin
    FOwner.OnPaint:=Paintgrid;
    if count > 1 then
    begin
      if assigned(Fcurrent) then
        Fsizer:=NewSizerControl(Fcurrent,@self);
      for i:=0 to count -1 do
       if not Pcontrol(Objects[i]).IsprocAttached(DesignHandlerProc) then
         PControl(Objects[i]).AttachProc(DesignHandlerProc);
    end;
  end
  else
  begin
   if count > 0 then
    for i:=0 to count -1 do
      PControl(Objects[i]).DetachProc(DesignHandlerProc);
    if assigned(Fsizer) then
    begin
      Fsizer.free;
      Fsizer:=nil;
    end;
    Fcurrent:=nil;
    FOwner.OnPaint:=FOldPaint;
  end;
  Fowner.invalidate;
end;

procedure TDesigner.Connect(aName: String; aControl: pControl);
begin
  if (IndexofObj(aControl) = -1) then
  begin
    if aName = '' then
      aname := prepareClassname(aControl);
    AddObject(uniquename(aName), Cardinal(aControl));
    InternalControlChange(aControl);
    setcurrent(aControl);
  end;
end;

procedure TDesigner.DisConnect(aControl: pControl);
var
  Index: Integer;
begin
  Index := IndexOfObj(aControl);
  if index = -1 then
    exit;
  Delete(IndexOfObj(aControl));
  aControl:=nil;
  InternalControlChange(nil);
end;

procedure TDesigner.SetCurrent(const Value: pControl);
begin
  if assigned(Fsizer) then
  begin
    FSizer.free;
    Fsizer:=nil;
  end;
  if value <> nil then
  begin
    FCurrent := Value;
    if (FActive =true) and (Fcurrent<>nil) and (Fcurrent<>FOwner) then
      Fsizer:=Newsizercontrol(Value,@self);
    InternalControlChange(Value);
  end;
end;

procedure TDesigner.InternalControlChange(sender: pObj);
begin
  if FActive then
    if Assigned(OnControlChange)then
      FOnControlChange(sender);
end;

procedure TDesigner.DoKeyUp(Sender: PControl; var Key: Integer;
  Shift: DWORD);
var
 i:integer;
  procedure DeleteControl(Index:integer);
  var
    i: Integer;
    C:Pcontrol;
  begin
    C:=Pcontrol(Objects[index]);
    if C.ChildCount > 0 then
      for i := c.Childcount - 1 downto 0 do
        if c <> Fowner then Deletecontrol(i);
     if C<> FOwner then
     begin
       C.free;
       C:=nil;
       Delete(0);
     end;
  end;
begin
    if Key = VK_DELETE then
   begin
     i:=IndexOfObj(LocalDesigner.Current);
     if i<> -1 then
     begin
       Deletecontrol(i);
       internalControlchange(nil);
       postmessage(sender.Handle,WM_CLOSE,0,0);
     end;
   end;
end;





  // Converts  an object name to a Delphi compatible control name that
  // is unique for the designer, i.e 'Button' becomes 'Button1',
  // the next button becomes 'Button2', always unless the
  // control is already named by the user in which case the name is preserved
  // unless there are conficts. In that case the control is silently
  // renamed with a digit suffix without raising exceptions.
  // Deleted names are re-used.
  // It's not a beauty but it works.
  // (A severe case of programming 48 hours without sleep)

function TDesigner.UniqueName(aName: String): String;
var
  I, J: Integer;
  T: String;
begin
  // Strip obj_ prefix and all other prefix+underscores from
  // subclassname property: 'obj_BUTTON' becomes 'Button'
  T := Lowercase(aName);
  while T <> '' do aName := Parse(T, '_');
  //Propercase it.
  T := aName[1];
  T := UpperCase(T);
  aName[1] := T[1];
  Result := aName;
  // Add at least a 1 to the name if the last char
  // is not a digit.
  if not (aName[length(aName)] in ['0'..'9']) then
    Result := Format('%s%d', [aName, 1]);
  J := 1;
  repeat
    I := IndexOf(Result);
    if I > -1 then
    begin
      inc(J);
      Result := Format('%s%d', [aName, J]);
    end;
  until I = -1;
end;

// This is probably not complete yet.
function TDesigner.PrepareClassname(aControl: PControl): String;
begin
  Result := aControl.subclassname;
  with aControl^ do
    if subClassname = 'obj_STATIC' then
    begin
      // Only place where panel and label differ
      // consistently???
      if pHack(aControl).fSizeRedraw = True then
        Result := 'obj_LABEL'
      else
        Result := 'obj_PANEL'
    end
  else if subclassname = 'obj_BUTTON' then
  begin
    if Boolean(Style and BS_AUTOCHECKBOX) then
      Result := 'obj_CHECKBOX'
    else if Boolean(style and BS_RADIOBUTTON) then
      Result := 'obj_RADIOBOX'
    else if Boolean(style and BS_OWNERDRAW) then
      Result := 'obj_BITBTN'
    else if Boolean(style and BS_GROUPBOX) then
      Result := 'obj_GROUPBOX';
  end
  else if indexofstr(Uppercase(subclassname), 'RICHEDIT')>-1 then
    Result := 'obj_RICHEDIT';
end;


end.
