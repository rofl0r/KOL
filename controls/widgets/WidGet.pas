unit widget;

interface

uses
  KOL,
  objects,
  Windows,
  Messages;

const
    cm_buttonpressed = wm_user + 999;

type
  PWidget =^TWidget;
  TKOLWidGet = PWidGet;
  TNotifyEvent = procedure(sender: PWidget) of object;
  TWidget = object(TObj)
  private
    OldWndProc: TFarProc;
    NewWndProc: TFarProc;
    Owner: PControl;
    FDown: Boolean;
    FEnabled: boolean;
    FFont: PGraphicTool;
    FImage: KOL.PBitmap;
    FGap: integer;
    FGlyph: char;
    FHint: string;
    FShowHint: boolean;
    FOffsetLeft: integer;
    FOffsetTop: integer;
    FPopupMenu: PMenu;
    FRightOffset: integer;
    FVisible: boolean;
    FOnClick: TNotifyEvent;
    FWidgetRect: TRect;
    Pressed: boolean;
    DrawPressed: boolean;
    WidgetNumber: integer;
    procedure NewWndMethod(var msg: TMessage);
  protected
    procedure Click;
    procedure CalculateWidgetArea;
    procedure DrawWidget;
    procedure SetDown(value: boolean);
    procedure SetEnabled(value: boolean);
    procedure SetFont(Value: PGraphicTool);
    procedure SetGap(Value: integer);
    procedure SetGlyph(Value: char);
    procedure SetImage(Value: KOL.PBitmap);
    procedure SetOffsetLeft(value: integer);
    procedure SetOffsetTop(value: integer);
    procedure SetVisible(value: boolean);
  public
    destructor Destroy; virtual;
    procedure ForceRedraw;
    property WidgetRect: TRect read FWidgetRect;
    property Down: Boolean read FDown write SetDown;
    property Enabled: boolean read FEnabled write SetEnabled default true;
    property Font: PGraphicTool read FFont write SetFont;
    property Gap: integer read FGap write SetGap;
    property Glyph: char read FGlyph write SetGlyph;
    property Hint: string read FHint write FHint;
    property Image: KOL.PBitmap read FImage write SetImage;
    property OffsetLeft: integer read FOffsetLeft write SetOffsetLeft;
    property OffsetTop: integer read FOffsetTop write SetOffsetTop;
    property PopupMenu: PMenu read FPopupmenu write FPopupMenu;
    property ShowHint: boolean read FShowHint write FShowHint default false;
    property Visible: boolean read FVisible write SetVisible default true;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  function NewWidget(AOwner: PControl): PWidget;

implementation

{ TWidget }

var getlist: PTree;

function FindList(AOwner: PControl): PList;
var i: integer;
    t: PTree;
begin
   if getlist = nil then getlist := NewTree(nil, 'root');
   for i := 0 to getlist.Count - 1 do begin
      t := getlist.Items[i];
      if t.Name = int2str(longint(AOwner)) then begin
         result := t.Data;
         exit;
      end;
   end;
   t := NewTree(getlist, int2str(longint(AOwner)));
   t.Name := int2str(longint(AOwner));
   t.Data := NewList;
   getlist.Add(t);
   result := t.Data;
end;

procedure deletelist(AOwner: PControl; sender: PWidGet);
var i: integer;
    t: PTree;
    p: PList;
begin
   for i := 0 to getlist.Count - 1 do begin
      t := getlist.Items[i];
      if t.Name = int2str(longint(AOwner)) then begin
         p := t.Data;
         p.Delete(p.IndexOf(sender));
         if p.Count = 0 then begin
            p.Free;
            t.Free;
         end;
         exit;
      end;
   end;
end;

function NewWidget(AOwner: PControl): PWidget;
var
  getlist: PList;
begin
  if not AOwner.HandleAllocated then AOwner.CreateWindow;
  New(Result, create);
  getlist := FindList(AOwner);
  Result.WidgetNumber := getlist.Count;
  getlist.Add(Result);
  Result.Owner := AOwner;
  Result.FDown := false;
  Result.FEnabled := true;
  Result.fOffsetLeft := 0;
  Result.fOffsetTop := 0;
  Result.FFont := NewFont;
  Result.FFont.FontCharset := 1;
  Result.FFont.FontName := 'Marlett';
  Result.FFont.Color := clWindowText;
  Result.FGap := 1; // default spacing
  Result.FGlyph := 'v';
  Result.FVisible := true;
  Result.FImage := KOL.NewBitMap(0, 0);
  Result.NewWndProc := MakeObjectInstance(Result.NewWndMethod);
  Result.OldWndProc := pointer(SetWindowLong(AOwner.Handle, gwl_WndProc, longint(Result.NewWndProc)));
  Result.CalculateWidgetArea;
  Result.DrawWidget;
end;

destructor TWidget.Destroy;
begin
  DeleteList(OWner, @self);
  if Assigned(NewWndProc) and Assigned(Owner) then
  begin
    SetWindowLong(Owner.Handle, gwl_WndProc, longint(OldWndProc));
    FreeObjectInstance(NewWndProc);
  end;
  FFont.Free;
  FImage.Free;
  inherited Destroy;
end;

procedure TWidget.ForceRedraw;
begin
  PostMessage(Owner.Handle, wm_ncpaint, 0, 0);
end;

const
  wm_widgetupdate = wm_user + 1; // "widget draw thyself"

// This does all the work of handling the owner forms
// messages. What it doesn't handle it passes on down
// the chain of handlers.

function Rect(ALeft, ATop, ARight, ABottom: Integer): TRect;
begin
  with Result do
  begin
    Left := ALeft;
    Top := ATop;
    Right := ARight;
    Bottom := ABottom;
  end;
end;

procedure TWidget.NewWndMethod(var msg: TMessage);
var
  hRegion: HRGN;
  dc: HDC;
  br, wr: TRect;
  w: Integer;


  // pass the message on ...

  procedure DefHandler;
  begin
    msg.Result := CallWindowProc(OldWndProc, Owner.Handle, msg.Msg, msg.wParam, msg.lParam);
  end;

  // is the 'message' location within the widget?

  function InArea(InClient: boolean): boolean;
  var
    p: TPoint;
  begin
    p.X := Msg.lParamLo;
    p.Y := smallint(Msg.lParamHi);
    if not InClient then
      ScreenToClient(Owner.Handle, p);
    inc(p.X, 4);
    inc(p.Y, (8 + FWidgetRect.Bottom - FWidgetRect.Top));
    if (Owner.Menu <> 0) then begin
       if (GetMenuItemCount(Owner.Menu) > 0) then begin
          inc(p.Y, GetSystemMetrics(SM_CYMENU));
       end;
    end;
    Result := PtInRect(FWidgetRect, p);
  end;

begin
  case msg.Msg of
    wm_ncpaint, wm_ncactivate:
      begin
        GetWindowRect(Owner.Handle, wr);
        w := wr.Right - wr.Left;
        br := Rect(w - FRightOffset, FWidgetRect.Top, w - FRightOffset + (FWidgetRect.Right - FWidgetRect.Left), FWidgetRect.Bottom);
        FWidgetRect.Left := br.Left;
        FWidgetRect.Right := br.Right;
        DrawWidget;
        if Msg.Msg = wm_ncpaint then
        begin
          GetWindowRect(Owner.Handle, wr);
          hRegion := CreateRectRgnIndirect(wr);
          try
            dc := GetWindowDC(Owner.Handle);
            try
              if SelectClipRgn(dc, Msg.wParam) = ERROR then
                SelectClipRgn(dc, hRegion);
              OffsetClipRgn(dc, -wr.Left, -wr.Top);
              ExcludeClipRect(dc, br.Left, br.Top, br.Right, br.Bottom);
              OffsetClipRgn(dc, wr.Left, wr.Top);
              GetClipRgn(dc, hRegion);
            finally
              ReleaseDC(Owner.Handle, dc);
            end;
            Msg.Result := CallWindowProc(OldWndProc, Owner.Handle, Msg.Msg, hRegion, Msg.lParam)
          finally
            DeleteObject(hRegion);
          end;
          // post a message to yourself to redraw if parent is MDI window
{          if TForm(Owner).FormStyle = fsMDIChild then
            PostMessage((Owner as TForm).Handle, wm_widgetupdate, 0, WidgetNumber);}
        end
        else
        begin
          PostMessage(Owner.Handle, wm_widgetupdate, 0, WidgetNumber);
          DefHandler;
        end;
      end;
    wm_widgetupdate:
      begin
        if msg.lParam = WidgetNumber then
          DrawWidget
        else
          DefHandler;
      end;
    wm_nclbuttondown, wm_nclbuttondblclk:
      begin
        if InArea(false) and Visible then
          // going down on the widget
        begin
          if Enabled then
          begin
            SetCapture(Owner.Handle);
            DrawPressed := true;
            Pressed := true;
            DrawWidget;
          end;
          Msg.Result := 1;
        end
        else
          DefHandler;
      end;
    wm_mousemove:
      begin
        if Pressed then
        begin
          if not InArea(true) then
            // we're outside the widget
          begin
            // so show it 'unpressed'
            if DrawPressed then
            begin
              DrawPressed := false;
              DrawWidget;
            end;
          end
          else
            // we're inside the widget
          begin
            if not DrawPressed then
              // make it draw 'pressed' again
            begin
              DrawPressed := true;
              DrawWidget;
            end;
          end;
          msg.Result := 1;
        end
        else
          DefHandler;
      end;
    wm_lbuttonup, wm_lbuttondblclk:
      begin
        DrawPressed := false;
        if Pressed then
        begin
          if InArea(true) then
          begin
            PostMessage(Owner.Handle, cm_buttonpressed, 0, WidgetNumber);
          end;
          DrawWidget;
          msg.Result := 1;
        end
        else
          DefHandler;
        Pressed := false;
        ReleaseCapture;
      end;
    cm_buttonpressed:
      begin
        if msg.lParam = WidgetNumber then
          Click
        else
          DefHandler;
      end;
    wm_size, wm_windowposchanged, wm_settingchange, wm_stylechanged, wm_setfocus:
      begin
        // pass it along
        DefHandler;
        // and on the way back get the caption to redraw
        CalculateWidgetArea;
      end;
    wm_destroy:
      begin
        DefHandler;
      end;
  else
    DefHandler;
  end;
end;

procedure TWidget.Click;
begin
  if Enabled then begin
    if Assigned(FOnClick) then begin
       FOnClick(@Self);
    end;
    if Assigned(FPopupMenu) then begin
       FPopupmenu.Popup(FWidgetRect.Left + Owner.Left, FWidgetRect.Bottom + Owner.Top)
    end
  end
end;

// work out exactly where to put the widget

function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;
begin
  with Result do
  begin
    Left := ALeft;
    Top := ATop;
    Right := ALeft + AWidth;
    Bottom :=  ATop + AHeight;
  end;
end;

procedure TWidget.CalculateWidgetArea;
var
  xframe: integer;
  yFrame: integer;
  xsize: integer;
  ysize: integer;
  i: integer;
  TotalGap: integer;
  wr: TRect;
  getlist: PList;
begin
  if (Owner = nil) then
    exit;
  getlist := FindList(OWner);
  with Owner^ do
  begin
    // it will be different at design time
    if CanResize then begin
        xframe := GetSystemMetrics(SM_CXSIZEFRAME);
        yframe := GetSystemMetrics(SM_CYSIZEFRAME);
    end else begin
        xframe := GetSystemMetrics(SM_CXFIXEDFRAME);
        yframe := GetSystemMetrics(SM_CYFIXEDFRAME);
    end;
    inc(xframe, GetSystemMetrics(SM_CXSIZE));
    if Owner.Style and WS_MAXIMIZEBOX > 0 then inc(xframe, GetSystemMetrics(SM_CXSIZE));
    if Owner.Style and WS_MINIMIZEBOX > 0 then inc(xframe, GetSystemMetrics(SM_CXSIZE));
    ysize := GetSystemMetrics(SM_CYSIZE);
    xsize := GetSystemMetrics(SM_CXSIZE);
    // calculate TotalGap from other widgets
    TotalGap := -2;
    for i := 0 to WidgetNumber do begin
       Inc(TotalGap, PWidGet(getlist.Items[i]).Gap);
    end;
    inc(xframe, TotalGap + (WidgetNumber * (xsize - 2)));
    // finally we calculate the size and position of the widget
    GetWindowRect(Owner.Handle, wr);
    FRightOffset := xFrame + xSize;
    FWidgetRect := Bounds((wr.Right - wr.Left) - FRightOffset, yFrame + 2, xSize - 2, ySize - 4);
  end;
end;

procedure TWidget.DrawWidget;
var
  WidgetState: integer;
   R: TRect;
  DC: HDC;
begin
  if (Owner = nil) or not Visible then
    exit;
  with Owner^ do
  begin
    //Get the handle to the canvas
    DC := GetWindowDC(Handle);
    try
      try
{        Canvas.Brush.Color := clBtnFace;}
        SetBkMode(DC, windows.TRANSPARENT);
        WidgetState := DFCS_BUTTONPUSH;
        if not FEnabled then
        begin
          WidgetState := WidgetState or DFCS_INACTIVE;
          DrawPressed := false;
          FFont.Color := clGrayText;
        end;
        if DrawPressed or FDown then
          WidgetState := WidgetState or DFCS_PUSHED;
        // this is how windows draws its own frame buttons
        DrawFrameControl(DC, FWidgetRect, DFC_BUTTON, WidgetState);
        R := FWidgetRect;
        // define a smaller area to put the glyph in
        InflateRect(R, -2, -2);
        if DrawPressed or FDown then
          OffsetRect(R, 1, 1);
        OffsetRect(R, fOffsetLeft, fOffsetTop);
        if FImage.Empty then
        begin
          // choose a font size to fit
          FFont.FontHeight := (R.Bottom - R.Top - 1);
          SetTextColor(DC, FFont.Color);
          SelectObject(DC, FFont.Handle);
          TextOut(DC, R.Left, R.Top, @FGlyph, 1);
        end
        else
        begin
          fImage.StretchDrawTransparent(DC, R, fImage.Pixels[0, 0]);
        end;
      finally
      end;
    finally
      ReleaseDC(Handle, DC);
    end;
  end;
end;

procedure TWidget.SetDown(Value: Boolean);
begin
  FDown := Value;
  DrawWidget;
end;

procedure TWidget.SetEnabled(Value: boolean);
begin
  if FEnabled <> value then
  begin
    FEnabled := value;
{    CalculateWidgetArea;}
    DrawWidget;
  end;
end;

procedure TWidget.SetFont(Value: PGraphicTool);
begin
  FFont.Assign(Value);
{  CalculateWidgetArea;}
  DrawWidget;
end;

procedure TWidget.SetGap(Value: integer);
var
  i: integer;
  OwnerRect: TRect;
  hRegion: HRGN;
begin
  FGap := Value;
  for i := 0 to getlist.Count - 1 do
     PWidGet(getlist.Items[i]).CalculateWidgetArea;
  // need to redraw entire caption area here, not only current widget
  GetWindowRect(Owner.Handle, OwnerRect);
  hRegion := CreateRectRgnIndirect(OwnerRect);
  try
    SendMessage(Owner.Handle, WM_NCPAINT, hRegion, 0);
  finally
    DeleteObject(hRegion);
  end;
end;

procedure TWidget.SetGlyph(Value: char);
begin
  FGlyph := Value;
{  CalculateWidgetArea;}
  DrawWidget;
end;

procedure TWidget.SetImage(Value: KOL.PBitmap);
begin
  FImage.Assign(Value);
  DrawWidget;
end;

procedure TWidget.SetOffsetLeft(value: integer);
begin
  FOffsetLeft := value;
  CalculateWidgetArea;
  DrawWidget;
end;

procedure TWidget.SetOffsetTop(value: integer);
begin
  FOffsetTop := value;
  CalculateWidgetArea;
  DrawWidget;
end;

procedure TWidget.SetVisible(Value: boolean);
begin
  if FVisible <> value then
  begin
    FVisible := value;
{    CalculateWidgetArea;}
    DrawWidget;
  end;
end;

begin
   GetList := nil;
end.

