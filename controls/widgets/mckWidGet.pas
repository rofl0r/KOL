unit mckwidget;

interface

uses
  KOL,
  WidGet,
  mirror,
  mckObjs,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Menus,
  Forms;

type

  PWidGet = ^TKOLWidget;
  TonEvent = procedure(Sender: PWidGet) of object;

  TKOLWidget = class(TKOLObj)
  private
    OldWndProc: TFarProc;
    NewWndProc: TFarProc;
    FDown: Boolean;
    FEnabled: boolean;
    FFont: TFont;
    FImage: TBitmap;
    FGap: integer;
    FGlyph: char;
    FOffsetLeft: integer;
    FOffsetTop: integer;
    FOwnerForm: TForm;
    FPopupMenu: TKOLPopupMenu;
    FRightOffset: integer;
    FVisible: boolean;
    FOnClick: TOnEvent;
    FWidgetRect: TRect;
    OldFont: TFont;
    Pressed: boolean;
    DrawPressed: boolean;
    WidgetNumber: integer;
    RestoreTimer: TTimer;
    procedure NewWndMethod(var msg: TMessage);
    procedure RestoreHooks(Sender: TObject);
  protected
    procedure Click;
    procedure CalculateWidgetArea;
    procedure DrawWidget;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
    procedure SetDown(value: boolean);
    procedure SetEnabled(value: boolean);
    procedure SetFont(Value: TFont);
    procedure SetGap(Value: integer);
    procedure SetGlyph(Value: char);
    procedure SetImage(Value: TBitmap);
    procedure SetOffsetLeft(value: integer);
    procedure SetOffsetTop(value: integer);
    procedure SetVisible(value: boolean);
    function  AdditionalUnits: string; override;
    function  CompareFirst( C, N: string): boolean; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ForceRedraw;
    property WidgetRect: TRect read FWidgetRect;
  published
    property Down: Boolean read FDown write SetDown;
    property Enabled: boolean read FEnabled write SetEnabled default true;
    property Gap: integer read FGap write SetGap default 2;
    property Glyph: char read FGlyph write SetGlyph;
    property Image: TBitmap read FImage write SetImage;
    property Font: TFont read FFont write SetFont;
    property OffsetLeft: integer read FOffsetLeft write SetOffsetLeft;
    property OffsetTop: integer read FOffsetTop write SetOffsetTop;
    property PopupMenu: TKOLPopupMenu read FPopupmenu write FPopupMenu;
    property Visible: boolean read FVisible write SetVisible default true;
    property OnClick: TOnEvent read FOnClick write FOnClick;
  end;

  procedure Register;

implementation

{$R *.dcr}

uses
  SysUtils;

  procedure Register;
  begin
    RegisterComponents( 'KOLUtil', [ TKOLWidget ] );
  end;

{ TKOLWidGet }

constructor TKOLWidGet.Create(AOwner: TComponent);
var
  i: integer;
begin
  // ensure owner is a form
  if (AOwner = nil) or not (AOwner is TForm) then
    raise Exception.Create('A Widget must be owned by a form');
  // first Widget is zero, second is one, etc.
  WidgetNumber := 0;
  for i := 1 to (AOwner as TForm).ComponentCount do
    if (AOwner as TForm).Components[i - 1] is TKOLWidGet then
      inc(WidgetNumber);
  inherited Create(AOwner);
  FDown := false;
  FEnabled := true;
  FFont := TFont.Create;
  FFont.Name := 'Marlett';
  FFont.Color := clWindowText;
  FFont.Style := [];
  FGap := 1; // default spacing
  FGlyph := 'v'; // a double up/down arrow in Marlett
  FOwnerForm := AOwner as TForm;
  FVisible := true;
  OldFont := TFont.Create;
  FImage := TBitMap.Create;
  // subclass the owner to catch all its messages
  NewWndProc := MakeObjectInstance(NewWndMethod);
  OldWndProc := pointer(SetWindowLong((AOwner as TForm).Handle, gwl_WndProc, longint(NewWndProc)));
  CalculateWidgetArea;
  DrawWidget;
end;

destructor TKOLWidGet.Destroy;
begin
  if Assigned(NewWndProc) and Assigned(Owner) then
  begin
    SetWindowLong((Owner as TForm).Handle, gwl_WndProc, longint(OldWndProc));
    FreeObjectInstance(NewWndProc);
  end;
  FFont.Free;
  OldFont.Free;
  FImage.Free;
  inherited Destroy;
end;

function TKOLWidGet.AdditionalUnits;
begin
   Result := ', WidGet';
end;

function TKOLWidGet.CompareFirst;
begin
   Result := False;
   if C = 'Widget' then begin
      if N < Name then begin
         Result := True;
      end;   
   end;
end;

procedure TKOLWidGet.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var RName: string;
        S: string;
begin
  SL.Add( Prefix + AName + ' := NewWidGet( Result.Form );' );
  if Down then
  SL.Add( Prefix + AName + '.Down       := True;');
  if not Enabled then
  SL.Add( Prefix + AName + '.Enabled    := False;');
  if Gap <> 1 then
  SL.Add( Prefix + AName + '.Gap        := ' + Int2Str(Gap) + ';');
  if FFont.Name <> 'Marlett' then
  SL.Add( Prefix + AName + '.Font.FontName := ''' + FFont.Name + ''';');
  if Font.Color <> clWindowText then
  SL.Add( Prefix + AName + '.Font.Color := ' + Color2Str(Font.Color) + ';');
  if Font.Style <> [] then begin
    S := '';
    if fsBold in Font.Style then
      S := ' fsBold,';
    if fsItalic in Font.Style then
      S := S + ' fsItalic,';
    if fsStrikeout in Font.Style then
      S := S + ' fsStrikeOut,';
    if fsUnderline in Font.Style then
      S := S + ' fsUnderline,';
    if S <> '' then
      S := Trim( Copy( S, 1, Length( S ) - 1 ) );
    SL.Add( Prefix + AName + '.Font.FontStyle := [' + S + '];');
  end;
  if OffsetLeft <> 0 then
  SL.Add( Prefix + AName + '.OffsetLeft := ' + Int2Str(OffsetLeft) + ';');
  if OffsetTop <> 0 then
  SL.Add( Prefix + AName + '.OffsetTop  := ' + Int2Str(OffsetTop) + ';');
  if not Visible then
  SL.Add( Prefix + AName + '.Visible    := False;');
  if Assigned( Image ) and
     ( Image.Width <> 0 ) and ( Image.Height <> 0 ) then
  begin
    RName := ParentKOLForm.FormName + '_' + Name;
    Rpt( 'Prepare resource ' + RName + ' (' + UpperCase( Name + '_BITMAP' ) + ')' );
    GenerateBitmapResource( Image, UpperCase( Name + '_BITMAP' ), RName, fUpdated );
    SL.Add( Prefix + '{$R ' + RName + '.res}' );
    SL.Add( Prefix + AName + '.Image.LoadFromResourceName(hInstance, ''' + Name + '_BITMAP' + ''');');
  end;
  if Glyph <> #0 then
  SL.Add( Prefix + AName + '.Glyph      := ''' + Glyph + ''';');
end;

procedure TKOLWidGet.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  if PopupMenu <> nil then
  SL.Add( Prefix + AName + '.PopupMenu := Result.' + PopupMenu.Name + ';');
end;

procedure TKOLWidGet.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnClick' ], [ @OnClick ] );
end;

procedure TKOLWidGet.RestoreHooks(Sender: TObject);
begin
  RestoreTimer.Enabled := false;
  RestoreTimer.Free;
  OldWndProc := pointer(SetWindowLong((Owner as TForm).Handle, gwl_WndProc, longint(NewWndProc)));
  FOwnerForm := Owner as TForm;
  CalculateWidgetArea;
  DrawWidget;
end;

procedure TKOLWidGet.ForceRedraw;
begin
  PostMessage((Owner as TForm).Handle, wm_ncpaint, 0, 0);
end;

const
  wm_widgetupdate = wm_user + 1; // "widget draw thyself"

// This does all the work of handling the owner forms
// messages. What it doesn't handle it passes on down
// the chain of handlers.

procedure TKOLWidGet.NewWndMethod(var msg: TMessage);
var
  hRegion: HRGN;
  dc: HDC;
  br, wr: TRect;
  w: Integer;


  // pass the message on ...

  procedure DefHandler;
  begin
    msg.Result := CallWindowProc(OldWndProc, (Owner as TForm).Handle, msg.Msg, msg.wParam, msg.lParam);
  end;

  // is the 'message' location within the widget?

  function InArea(InClient: boolean): boolean;
  var
    p: TPoint;
  begin
    p.X := Msg.lParamLo;
    p.Y := smallint(Msg.lParamHi);
    if not InClient then
      windows.ScreenToClient((Owner as TForm).Handle, p);
    inc(p.X, 4);
    inc(p.Y, (8 + FWidgetRect.Bottom - FWidgetRect.Top));
    if ((Owner as TForm).Menu <> nil) and ((Owner as TForm).FormStyle <> fsMDIChild) then
      inc(p.Y, GetSystemMetrics(SM_CYMENU));
    Result := PtInRect(FWidgetRect, p);
  end;

begin
  case msg.Msg of
    wm_ncpaint, wm_ncactivate:
      begin
        GetWindowRect(FOwnerForm.Handle, wr);
        w := wr.Right - wr.Left;
        br := Rect(w - FRightOffset, FWidgetRect.Top, w - FRightOffset + (FWidgetRect.Right - FWidgetRect.Left), FWidgetRect.Bottom);
        FWidgetRect.Left := br.Left;
        FWidgetRect.Right := br.Right;
        DrawWidget;
        if Msg.Msg = wm_ncpaint then
        begin
          GetWindowRect(FOwnerForm.Handle, wr);
          hRegion := CreateRectRgnIndirect(wr);
          try
            dc := GetWindowDC(FOwnerForm.Handle);
            try
              if SelectClipRgn(dc, Msg.wParam) = ERROR then
                SelectClipRgn(dc, hRegion);
              OffsetClipRgn(dc, -wr.Left, -wr.Top);
              ExcludeClipRect(dc, br.Left, br.Top, br.Right, br.Bottom);
              OffsetClipRgn(dc, wr.Left, wr.Top);
              GetClipRgn(dc, hRegion);
            finally
              ReleaseDC(FOwnerForm.Handle, dc);
            end;
            Msg.Result := CallWindowProc(OldWndProc, FOwnerForm.Handle, Msg.Msg, hRegion, Msg.lParam)
          finally
            DeleteObject(hRegion);
          end;
          // post a message to yourself to redraw if parent is MDI window
          if TForm(Owner).FormStyle = fsMDIChild then
            PostMessage((Owner as TForm).Handle, wm_widgetupdate, 0, WidgetNumber);
        end
        else
        begin
          PostMessage((Owner as TForm).Handle, wm_widgetupdate, 0, WidgetNumber);
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
            SetCapture(TForm(Owner).Handle);
            DrawPressed := true;
            Pressed := true;
            DrawWidget;
          end;
          // we're done
          Msg.Result := 1;
        end
        else
          DefHandler;
      end;
    wm_mousemove:
      begin
        if Pressed then
          // the widget has been pressed
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
            PostMessage((Owner as TForm).Handle, cm_buttonpressed, 0, WidgetNumber);
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
        if not (csDestroying in ComponentState) then
        begin
          // the form is being destroyed but only to recreate it
          // we need to re hook everything in a short while
          RestoreTimer := TTimer.Create(Application);
          with RestoreTimer do
          begin
            OnTimer := RestoreHooks;
            Interval := 1;
            Enabled := true;
          end;
        end;
        DefHandler;
      end;
  else
    DefHandler;
  end;
end;

procedure TKOLWidGet.Click;
begin
{  if Enabled then begin
    if Assigned(FOnClick) then begin
       FOnClick(@Self);
    end;
    if Assigned(FPopupMenu) then begin
       FPopupmenu.Popup(FWidgetRect.Left + (Owner as TForm).Left, FWidgetRect.Bottom + (Owner as TForm).Top)
    end
  end}  
end;

// work out exactly where to put the widget

procedure TKOLWidGet.CalculateWidgetArea;
var
  xframe: integer;
  yFrame: integer;
  xsize: integer;
  ysize: integer;
  i: integer;
  Icons: TBorderIcons;
  Style: TFormBorderStyle;
  TotalGap: integer;
  wr: TRect;
begin
  if (Owner = nil) then
    exit;
  with (Owner as TForm) do
  begin
    // it will be different at design time
    if (csDesigning in ComponentState) then
    begin
      Icons := [biSystemMenu, biMinimize, biMaximize];
      Style := bsSizeable;
    end
    else
    begin
      Icons := BorderIcons;
      Style := BorderStyle;
    end;
    if Style in [bsSizeToolWin, bsToolWindow] then
    begin
      if Style = bsToolWindow then
        xframe := GetSystemMetrics(SM_CXFIXEDFRAME)
      else
        xframe := GetSystemMetrics(SM_CXSIZEFRAME);
      if biSystemMenu in Icons then
        inc(xframe, GetSystemMetrics(SM_CXSMSIZE));
      if Style = bsToolWindow then
        yframe := GetSystemMetrics(SM_CYFIXEDFRAME)
      else
        yframe := GetSystemMetrics(SM_CYSIZEFRAME);
      ysize := GetSystemMetrics(SM_CYSMSIZE);
      xsize := GetSystemMetrics(SM_CXSMSIZE);
    end
    else
    begin
      if Style in [bsSingle, bsSizeable, bsDialog] then
      begin
        if Style = bsSingle then
          xframe := GetSystemMetrics(SM_CYFIXEDFRAME)
        else
          xframe := GetSystemMetrics(SM_CXSIZEFRAME);
        if biSystemMenu in Icons then
        begin
          inc(xframe, GetSystemMetrics(SM_CXSIZE));
          if (Style <> bsDialog) and (Icons * [biMinimize, biMaximize] <> []) then
            inc(xframe, GetSystemMetrics(SM_CXSIZE) * 2)
          else
            if biHelp in Icons then
              inc(xframe, GetSystemMetrics(SM_CXSIZE));
        end;
        if Style in [bsSingle, bsDialog] then
          yframe := GetSystemMetrics(SM_CYFIXEDFRAME)
        else
          yframe := GetSystemMetrics(SM_CYSIZEFRAME);
        ysize := GetSystemMetrics(SM_CYSIZE);
        xsize := GetSystemMetrics(SM_CXSIZE);
      end;
    end;
    // calculate TotalGap from other widgets
    TotalGap := 2;
    if WidgetNumber > 0 then
    begin
      for i := 0 to FOwnerForm.ComponentCount - 1 do
      begin
        if (FOwnerForm.Components[i] is TKOLWidGet) and (((FOwnerForm.Components[i]) as TKOLWidGet).WidgetNumber < WidgetNumber) then
          Inc(TotalGap, ((FOwnerForm.Components[i]) as TKOLWidGet).Gap);
      end;
    end;
    inc(xframe, TotalGap + (WidgetNumber * (xsize - 2)));
    // finally we calculate the size and position of the widget
    GetWindowRect(FOwnerForm.Handle, wr);
    FRightOffset := xFrame + xSize - 4 + Gap;
    FWidgetRect := Bounds((wr.Right - wr.Left) - FRightOffset, yFrame + 2, xSize - 2, ySize - 4);
  end;
end;

procedure TKOLWidGet.DrawWidget;
var
  WidgetState: integer;
  R: TRect;
  RB: TRect;
begin
  if ((Owner as TForm) = nil) or not Visible then
    exit;
  with (Owner as TForm) do
  begin
    //Get the handle to the canvas
    Canvas.Handle := GetWindowDC(Handle);
    try
      // save the font
      OldFont.Assign(Canvas.Font);
      // use the widget's font
      Canvas.Font.Assign(FFont);
      try
        Canvas.Brush.Color := clBtnFace;
        SetBkMode(Canvas.Handle, windows.TRANSPARENT);
        WidgetState := DFCS_BUTTONPUSH;
        if not FEnabled then
        begin
          WidgetState := WidgetState or DFCS_INACTIVE;
          DrawPressed := false;
          Canvas.Font.Color := clGrayText;
        end;
        if DrawPressed or FDown then
          WidgetState := WidgetState or DFCS_PUSHED;
        // this is how windows draws its own frame buttons
        DrawFrameControl(Canvas.Handle, FWidgetRect, DFC_BUTTON, WidgetState);
        // define a smaller area to put the glyph in
        R := FWidgetRect;
        InflateRect(R, -2, -2);
        if DrawPressed or FDown then
          OffsetRect(R, 1, 1);
        OffsetRect(R, OffsetLeft, OffsetTop);
        if FImage.Empty then
        begin
          // choose a font size to fit
          Canvas.Font.Height := (R.Top - R.Bottom - 1);
          DrawText(Canvas.Handle, pchar(string(FGlyph)), 1, R, DT_CENTER or DT_VCENTER or DT_NOCLIP);
        end
        else
        begin
          RB := FImage.Canvas.ClipRect;
          Canvas.BrushCopy(R, FImage, RB, FImage.TransparentColor);
        end;
      finally
        Canvas.Font.Assign(OldFont);
      end;
    finally
      ReleaseDC(Handle, Canvas.Handle);
      Canvas.Handle := 0;
    end;
  end;
end;

procedure TKOLWidGet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (AComponent = fPopupMenu) and (Operation = opRemove) then
    fPopupMenu := nil;
end;

procedure TKOLWidGet.SetDown(Value: Boolean);
begin
  FDown := Value;
  DrawWidget;
  Change;
end;

procedure TKOLWidGet.SetEnabled(Value: boolean);
begin
  if FEnabled <> value then
  begin
    FEnabled := value;
    CalculateWidgetArea;
    DrawWidget;
    Change;
  end;
end;

procedure TKOLWidGet.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  CalculateWidgetArea;
  DrawWidget;
end;

procedure TKOLWidGet.SetGap(Value: integer);
var
  i: integer;
  OwnerRect: TRect;
  hRegion: HRGN;
begin
  FGap := Value;
  for i := 0 to (Owner as TForm).ComponentCount - 1 do
    if ((Owner as TForm).Components[i] is TKOLWidGet) then
      (((Owner as TForm).Components[i]) as TKOLWidGet).CalculateWidgetArea;
  // need to redraw entire caption area here, not only current widget
  GetWindowRect((Owner as TForm).Handle, OwnerRect);
  hRegion := CreateRectRgnIndirect(OwnerRect);
  try
    SendMessage((Owner as TForm).Handle, WM_NCPAINT, hRegion, 0);
  finally
    DeleteObject(hRegion);
  end;
  Change;
end;

procedure TKOLWidGet.SetGlyph(Value: char);
begin
  FGlyph := Value;
  CalculateWidgetArea;
  DrawWidget;
  Change;
end;

procedure TKOLWidGet.SetImage(Value: TBitmap);
begin
  FImage.Assign(Value);
  DrawWidget;
  Change;
end;

procedure TKOLWidGet.SetOffsetLeft(value: integer);
begin
  FOffsetLeft := value;
  CalculateWidgetArea;
  DrawWidget;
  Change;
end;

procedure TKOLWidGet.SetOffsetTop(value: integer);
begin
  FOffsetTop := value;
  CalculateWidgetArea;
  DrawWidget;
  Change;
end;

procedure TKOLWidGet.SetVisible(Value: boolean);
begin
  if FVisible <> value then
  begin
    FVisible := value;
    CalculateWidgetArea;
    DrawWidget;
    Change;
  end;
end;

end.

