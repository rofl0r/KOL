unit KOLMHXPStyle;
//  MHXPStyle Компонент (MHXPStyle Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 20-июл(jul)-2003
//  Дата коррекции (Last correction Date): 10-июл(jul)-2003
//  Версия (Version): 0.7
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    MTsv DN
//  Новое в (New in):
//  V0.7
//  [+] Сделал (Made it) [KOLnMCK]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)
//  5. Меню
//  6. Ошибка + XP
//  7. Баги отрисовок
//  8. Шрифт кнопки

interface

uses Windows, Messages, KOL {, mckCtrls};

const
  CM_BASE = $B000;
  CM_FOCUSCHANGED = CM_BASE + 7;
  CM_PARENTCOLORCHANGED = CM_BASE + 9;
  CM_ENABLEDCHANGED = CM_BASE + 12;
  CM_COLORCHANGED = CM_BASE + 13;
  CM_CTL3DCHANGED = CM_BASE + 16;
  CM_PARENTCTL3DCHANGED = CM_BASE + 17;
  CM_TEXTCHANGED = CM_BASE + 18;
  CM_EXIT = CM_BASE + 27;

type
  TBiDiMode = (bdLeftToRight, bdRightToLeft, bdRightToLeftNoAlign, bdRightToLeftReadingOnly);
  TAlignment = (taLeftJustify, taRightJustify, taCenter);

  TBevelCut = (bvNone, bvLowered, bvRaised, bvSpace);
  TBevelEdge = (beLeft, beTop, beRight, beBottom);
  TBevelEdges = set of TBevelEdge;
  TBevelKind = (bkNone, bkTile, bkSoft, bkFlat);
  TBevelWidth = 1..MaxInt;

  // TMyEvent = procedure(Sender: PControl; Str: String; const Error: Boolean; var Retry: Boolean) of object;

  PMHXPControl = ^TMHXPControl;
  TKOLMHXPEditBox = PMHXPControl;
  TKOLMHXPButton = PMHXPControl;
  TKOLMHXPCheckBox = PMHXPControl;
  TKOLMHXPRadioBox = PMHXPControl;
  TKOLMHXPComboBox = PMHXPControl;
  TKOLMHXPRichEdit = PMHXPControl;
  TKOLMHXPMemo = PMHXPControl;
  TKOLMHXPPanel = PMHXPControl;
  TPaintProc = procedure(Sender: PMHXPControl);
  TMHXPControl = object(TControl)
  private
    procedure SetEvents;
    procedure Enter(Sender: PObj);
    procedure Leave(Sender: PObj);
    function GetBevelInner: TBevelCut;
    function GetBevelOuter: TBevelCut;
    procedure SetBevelInner(const Value: TBevelCut);
    procedure SetBevelOuter(const Value: TBevelCut);
    function GetBevelWidth: TBevelWidth;
    procedure SetBevelWidth(const Value: TBevelWidth);
    procedure SetBuilding(const Value: Boolean);
    function GetBuilding: Boolean;
    function GetMouseInControl: Boolean;
    procedure SetMouseInControl(const Value: Boolean);
    function GetLButtonBressed: Boolean;
    procedure SetLButtonBressed(const Value: Boolean);
    function GetBressed: Boolean;
    procedure SetBressed(const Value: Boolean);
    function GetIsKeyDown: Boolean;
    procedure SetIsKeyDown(const Value: Boolean);
    function GetAlignment: TAlignment;
    function GetBiDiMode: TBiDiMode;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetBiDiMode(const Value: TBiDiMode);
    function GetOldWndProc: Pointer;
    procedure SetOldWndProc(const Value: Pointer);
    //    procedure Paint;
    function GetPaintXPControl: TPaintProc;
    procedure SetPaintXPControl(const Value: TPaintProc);
    function GetOnMouseEnter: TOnEvent;
    function GetOnMouseLeave: TOnEvent;
    procedure SetOnMouseEnter(const Value: TOnEvent);
    procedure SetOnMouseLeave(const Value: TOnEvent);

    // function GetMyEvent: TMyEvent;
    // procedure SetMyEvent(const Value: TMyEvent);

    // procedure OnNewLVData(Sender: PControl; Idx, SubItem: Integer; var Txt: String;
    //			    var ImgIdx: Integer; var State: DWORD; var Store: Boolean);

  public
    property BevelInner: TBevelCut read GetBevelInner write SetBevelInner;
    property BevelOuter: TBevelCut read GetBevelOuter write SetBevelOuter;
    property BevelWidth: TBevelWidth read GetBevelWidth write SetBevelWidth;
    property Building: Boolean read GetBuilding write SetBuilding;
    property MouseInControl: Boolean read GetMouseInControl write SetMouseInControl;
    property LButtonBressed: Boolean read GetLButtonBressed write SetLButtonBressed;
    property Bressed: Boolean read GetBressed write SetBressed;
    property IsKeyDown: Boolean read GetIsKeyDown write SetIsKeyDown;
    // property MyEvent: TMyEvent read GetMyEvent write SetMyEvent;
    // property OnLVData: Boolean read FNotAvailable;
    property BiDiMode: TBiDiMode read GetBiDiMode write SetBiDiMode;
    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property OldWndProc: Pointer read GetOldWndProc write SetOldWndProc;
    property PaintXPControl: TPaintProc read GetPaintXPControl write SetPaintXPControl;
    property OnMouseEnter: TOnEvent read GetOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read GetOnMouseLeave write SetOnMouseLeave;
  end;

  //  TKOLDemo = PDemo;

function NewMHXPPanel(AParent: PControl; EdgeStyle: TEdgeStyle): PMHXPControl;
function NewMHXPRadioBox(AParent: PControl; const Caption: string): PMHXPControl;
function NewMHXPCheckBox(AParent: PControl; const Caption: string): PMHXPControl;
function NewDemo(Sender: PControl): PMHXPControl;

function NewMHXPSpeedButton(AParent: PControl; const Caption: String;
         Options: TBitBtnOptions; Layout: TGlyphLayout; GlyphBitmap: HBitmap;
         GlyphCount: Integer ): PMHXPControl;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function NewMHXPButton(AParent: PControl; const Caption: string): PMHXPControl;
function NewMHXPEditBox(AParent: PControl; const Options: TEditOptions): PMHXPControl;
function NewMHXPComboBox(AParent: PControl; const Options: TComboOptions): PMHXPControl;
function NewMHXPRichEdit(AParent: PControl; const Options: TEditOptions): PMHXPControl;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

implementation

var
  FUseSystemColors: boolean;
  FFColor, FFIconBackColor, FFSelectColor, FFSelectBorderColor,
    FFSelectFontColor, FCheckedAreaColor, FCheckedAreaSelectColor,
    FFCheckedColor, FFMenuBarColor, FFDisabledColor, FFSeparatorColor,
    FMenuBorderColor, FMenuShadowColor: TColor;
  Is16Bit: boolean;
  FUseDimColor: boolean;
  FDimParentColor, FDimParentColorSelect: integer;

  // uses CommCtrl, ShellApi;

  { ДАННЫЕ ДЛЯ НАШЕГО ОБЪЕКТА (СВОЙСТВА И ОБРАБОТЧИКИ) }
type

  PCompObj = ^TCompObj;
  TCompObj = object(TObj)
    FOnMouseEnter: TOnEvent;
    FOnMouseLeave: TOnEvent;
    FBevelInner: TBevelCut;
    FBevelOuter: TBevelCut;
    FBevelWidth: TBevelWidth;
    FBuilding: Boolean;
    FMouseInControl: Boolean;
    FLButtonBressed: Boolean;
    FBressed: Boolean;
    FIsKeyDown: Boolean;
    FBiDiMode: TBiDiMode;
    FAlignment: TAlignment;
    FOldWndProc: Pointer;
    FOwner: PMHXPControl;
    FPaintXPControl: TPaintProc;
    destructor Destroy; virtual;
  end;

  {-------------------------}
  { Destructor НАШИХ ДАННЫХ }
  {-------------------------}

destructor TCompObj.Destroy;
begin
  SetWindowLong(FOwner.Handle, GWL_WNDPROC, DWord(FOldWndProc));
  inherited;
end;
////////////////////////////////////////////////////////////////////////////////

function ColorToRGB(Color: TColor): Longint;
begin
  if Color < 0 then
    Result := GetSysColor(Color and $000000FF)
  else
    Result := Color;
end;

function GetShadeColor(ACanvas: PCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;

begin
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  r := (r - value);
  if r < 0 then
    r := 0;
  if r > 255 then
    r := 255;

  g := (g - value) + 2;
  if g < 0 then
    g := 0;
  if g > 255 then
    g := 255;

  b := (b - value);
  if b < 0 then
    b := 0;
  if b > 255 then
    b := 255;

  //Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
  Result := RGB(r, g, b);
end;

function NewColor(ACanvas: PCanvas; clr: TColor; Value: integer): TColor;
var
  r, g, b: integer;

begin
  if Value > 100 then
    Value := 100;
  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  r := r + Round((255 - r) * (value / 100));
  g := g + Round((255 - g) * (value / 100));
  b := b + Round((255 - b) * (value / 100));

  Result := Windows.GetNearestColor(ACanvas.Handle, RGB(r, g, b));
  //Result := RGB(r, g, b);

end;

procedure SetGlobalColor(Control: PMHXPControl);
var
  z: Integer;
begin
  if GetDeviceCaps(Control.Canvas.Handle, BITSPIXEL) < 16 then
    Is16Bit := false
  else
    Is16Bit := true;

  FDimParentColor := 16;
  FDimParentColorSelect := 40;

  FFColor := clBtnFace;
  FFIconBackColor := clBtnFace;

  if Is16Bit then
  begin
    if FUseDimColor then
    begin
      FFSelectColor := NewColor(Control.Canvas, clHighlight, 68);
      FCheckedAreaColor := NewColor(Control.Canvas, clHighlight, 80);
      FCheckedAreaSelectColor := NewColor(Control.Canvas, clHighlight, 50);
    end
    else
    begin
      FFSelectColor := clHighlight;
      FCheckedAreaColor := clHighlight;
      FCheckedAreaSelectColor := clHighlight;
    end;

    FMenuBorderColor := GetShadeColor(Control.Canvas, clBtnFace, 90);
    FMenuShadowColor := GetShadeColor(Control.Canvas, clBtnFace, 76);
  end
  else
  begin
    FFSelectColor := clHighlight;
    FCheckedAreaColor := clWhite;
    FCheckedAreaSelectColor := clSilver;
    FMenuBorderColor := clBtnShadow;
    FMenuShadowColor := clBtnShadow;
  end;

  FFSelectBorderColor := clHighlight;
  FFSelectFontColor := Control.Color;
  FFMenuBarColor := clBtnFace;
  FFDisabledColor := clInactiveCaption;
  FFCheckedColor := clHighlight;
  FFSeparatorColor := clBtnFace;

  if FUseSystemColors then
  begin
    if not Is16Bit then
    begin
      FFColor := clWhite;
      FFIconBackColor := clBtnFace;
      FFSelectColor := clWhite;
      FFSelectBorderColor := clHighlight;
      FFMenuBarColor := FFIconBackColor;
      FFDisabledColor := clBtnShadow;
      FFCheckedColor := clHighlight;
      FFSeparatorColor := clBtnShadow;
      FCheckedAreaColor := clWhite;
      FCheckedAreaSelectColor := clWhite;
    end
    else
    begin
      FFColor := NewColor(Control.Canvas, clBtnFace, 86);
      FFIconBackColor := NewColor(Control.Canvas, clBtnFace, 16);
      FFSelectColor := NewColor(Control.Canvas, clHighlight, 68);
      FFSelectBorderColor := clHighlight;
      FFMenuBarColor := clBtnFace;

      FFDisabledColor := NewColor(Control.Canvas, clBtnShadow, 10);
      FFSeparatorColor := NewColor(Control.Canvas, clBtnShadow, 25);
      FFCheckedColor := clHighlight;
      FCheckedAreaColor := NewColor(Control.Canvas, clHighlight, 80);
      FCheckedAreaSelectColor := NewColor(Control.Canvas, clHighlight, 50);
    end;
  end;
end;

procedure Frame3D(Canvas: PCanvas; var Rect: TRect; TopColor, BottomColor: TColor;
  Width: Integer);

  procedure DoRect;
  var
    TopRight, BottomLeft: TPoint;
  begin
    with Canvas^, Rect do
    begin
      TopRight.X := Right;
      TopRight.Y := Top;
      BottomLeft.X := Left;
      BottomLeft.Y := Bottom;
      Pen.Color := TopColor;
      PolyLine([BottomLeft, TopLeft, TopRight]);
      Pen.Color := BottomColor;
      Dec(BottomLeft.X);
      PolyLine([TopRight, BottomRight, BottomLeft]);
    end;
  end;

begin
  Canvas.Pen.PenWidth := 1;
  Dec(Rect.Bottom);
  Dec(Rect.Right);
  while Width > 0 do
  begin
    Dec(Width);
    DoRect;
    InflateRect(Rect, -1, -1);
  end;
  Inc(Rect.Bottom);
  Inc(Rect.Right);
end;

procedure PaintXPPanel(Sender: PMHXPControl);
var
  //  C: TControlCanvas;
  R: TRect;
  ShadowColor, LightColor: TColor;
begin
  //  C := TControlCanvas.Create;
  //  try
  //    C.Control := Control;
{      XPMenu.} SetGlobalColor(Sender);

  R := Sender.ClientRect;
  //    Sender.Canvas.FillRect(R);
  ShadowColor := GetShadeColor(Sender.Canvas, Sender.color, 60);
  LightColor := NewColor(Sender.Canvas, Sender.color, 60);
  if Sender.BevelOuter <> bvNone then
  begin
    if Sender.BevelOuter = bvLowered then
      Frame3D(Sender.Canvas, R, ShadowColor, LightColor, Sender.BevelWidth)
    else
      Frame3D(Sender.Canvas, R, LightColor, ShadowColor, Sender.BevelWidth);
  end;

  if Sender.BevelInner <> bvNone then
  begin
    InflateRect(R, -Sender.Border, -Sender.Border);

    if Sender.BevelInner = bvLowered then
      Frame3D(Sender.Canvas, R, ShadowColor, LightColor, Sender.BevelWidth)
    else
      Frame3D(Sender.Canvas, R, LightColor, ShadowColor, Sender.BevelWidth);
  end;
  //  finally
  //    C.Free;
  //  end;

end;

procedure DrawCheckMark(ACanvas: PCanvas; X, Y: integer);
begin
  Inc(X, 2);
  Dec(Y, 3);
  ACanvas.MoveTo(X, Y - 2);
  ACanvas.LineTo(X + 2, Y);
  ACanvas.LineTo(X + 7, Y - 5);

  ACanvas.MoveTo(X, Y - 3);
  ACanvas.LineTo(X + 2, Y - 1);
  ACanvas.LineTo(X + 7, Y - 6);

  ACanvas.MoveTo(X, Y - 4);
  ACanvas.LineTo(X + 2, Y - 2);
  ACanvas.LineTo(X + 7, Y - 7);
end;

//procedure TMHXPControl.Paint;
//begin
//end;

procedure PaintXPCheckBox(Sender: PMHXPControl);
var
  R: TRect;
  SelectColor, BorderColor: TColor;
  //  c1,c2:TColor;
  //  hdc1: HDC;
  //  PS1: TPaintStruct;
begin
  //   hdc1:= BeginPaint(Sender.Handle, ps1);
   //  C := TControlCanvas.Create;
   //  try
   //    C.Control := Control;
       {XPMenu.} SetGlobalColor(Sender);

  //  Sender.Canvas.Pen.Color:=clRed;
  //  Sender.Canvas.Brush.Color:=clGreen;
  //  Sender.Canvas.Brush.Color:=clBlue;
  //  Sender.Canvas.Rectangle(0,0,10,10);
  {  Sender.Canvas.MoveTo(0,0);
    Sender.Canvas.LineTo(100,100);}
  //  exit;

  if Sender.MouseInControl then
  begin
    SelectColor := FFSelectColor;
    BorderColor := FFSelectBorderColor;
  end
  else
  begin
    SelectColor := clWindow;
    BorderColor := clBtnShadow;
  end;

  { if Sender.Focused then
   begin
     SelectColor := FFSelectColor;
     BorderColor := FFSelectBorderColor;
   end;
   if (Sender.Bressed) or (Sender.LButtonBressed) then
     SelectColor := FCheckedAreaSelectColor;
   }
  if false then //TCheckBox(Control).State = cbGrayed then
    SelectColor := clSilver;
  R := Sender.ClientRect;
  InflateRect(R, 0, -3);
  R.Top := R.Top + ((R.Bottom - R.Top - GetSystemMetrics(SM_CXHTHUMB)) div 2);
  R.Bottom := R.Top + GetSystemMetrics(SM_CXHTHUMB);

  if ((Sender.BiDiMode = bdRightToLeft) and
    (Sender.Alignment = taRightJustify)) or
    ((Sender.BiDiMode = bdLeftToRight) and
    (Sender.Alignment = taLeftJustify)) then
    R.Left := R.Right - GetSystemMetrics(SM_CXHTHUMB) + 1
  else if ((Sender.BiDiMode = bdLeftToRight) and
    (Sender.Alignment = taRightJustify)) or
    ((Sender.BiDiMode = bdRightToLeft) and
    (Sender.Alignment = taLeftJustify)) then
    R.Right := R.Left + GetSystemMetrics(SM_CXHTHUMB) - 1;

  Sender.Canvas.Brush.Color := Sender.Color;
  Sender.Canvas.FillRect(R);
  InflateRect(R, -2, -2);
  Sender.Canvas.Brush.Color := SelectColor;
  Sender.Canvas.Pen.Color := BorderColor;
  Sender.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

  if Sender.Checked then //(Sender.Checked) then//or
    //(TCheckBox(Control).State = cbGrayed) then
  begin
    if Sender.Enabled then
    begin
      if (Sender.Bressed) or (Sender.LButtonBressed) then
        Sender.Canvas.Pen.color := clWindow
      else
      begin
        if false then //TCheckBox(Control).State = cbGrayed then
          Sender.Canvas.Pen.color := clGray
        else
          Sender.Canvas.Pen.color := clHighlight;
      end;
    end
    else
      Sender.Canvas.Pen.color := FFDisabledColor;

    DrawCheckMark(Sender.Canvas, R.Left, R.Bottom)
  end;

  //   EndPaint(Sender.Handle, ps1);
 //    {Invalidate}ValidateRect(Sender.Handle,0{,false});

 //  finally
 //    C.Free;
  // end;

end;

procedure DimBitmap(ABitmap: PBitmap; Value: integer);
var
  x, y: integer;
  LastColor1, LastColor2, Color: TColor;
begin
  if Value > 100 then Value := 100;
  LastColor1 := -1;
  LastColor2 := -1;

  for y := 0 to ABitmap.Height - 1 do
    for x := 0 to ABitmap.Width - 1 do
    begin
      Color := ABitmap.Canvas.Pixels[x, y];
      if Color = LastColor1 then
        ABitmap.Canvas.Pixels[x, y] := LastColor2
      else
      begin
        LastColor2 := NewColor(ABitmap.Canvas, Color, Value);
        ABitmap.Canvas.Pixels[x, y] := LastColor2;
        LastColor1 := Color;
      end;
    end;
end;

procedure DrawTheText(Sender: PMHXPControl; txt, ShortCuttext: string;
    ACanvas: PCanvas; TextRect: TRect;
    Selected, Enabled, Default, TopMenu, IsRightToLeft: boolean;
    var TxtFont: PGraphicTool; TextFormat: integer);
var
  DefColor: TColor;
  B: PBitmap;
  BRect: TRect;
begin
{  BRect:=Sender.ClientRect;
  ACanvas.DrawText('Demo',BRect,0);}
//  exit;

  DefColor := TxtFont.Color;

{  ACanvas.Font.FontName:='Arial';
  ACanvas.Font.FontHeight:=-12;

  Sender.Font.FontName:='Arial';
  Sender.Font.FontHeight:=-12;}
  ACanvas.Font.Assign (TxtFont);

  if Selected then
    DefColor := FFSelectFontColor;

  If not Enabled then
  begin
    DefColor := FFDisabledColor;

    if false then//(Sender is TToolButton) then
    begin
      TextRect.Top := TextRect.Top +
        ((TextRect.Bottom - TextRect.Top) - ACanvas.TextHeight('W')) div 2;
      B := NewBitmap(0,0);//TBitmap.Create;
      try
        B.Width := TextRect.Right - TextRect.Left;
        B.Height := TextRect.Bottom - TextRect.Top;
       { BRect := Rect(0,0,B.Width, B.Height);}


        B.Canvas.Brush.Color := ACanvas.Brush.Color;
        B.Canvas.FillRect (BRect);
  //      B.Canvas.Font := FFont; //felix added for resolving font problems in Win98
                                //27.08
        B.Canvas.Font.color := DefColor;

        ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
        DrawtextEx(B.Canvas.Handle,
          PChar(txt),
          Length(txt),
          BRect, TextFormat + DT_VCENTER, nil);
        ACanvas.CopyRect(TextRect, B.Canvas, BRect);
      finally
        B.Free;
      end;
      exit;
    end;

  end;

 { if (TopMenu and Selected) then
    if FUseSystemColors then
      DefColor := TopMenuFontColor(ACanvas, FFIconBackColor);}

  ACanvas.Font.color := DefColor;    // will not affect Buttons
//New
 {
  TextRect.Top := TextRect.Top +
    ((TextRect.Bottom - TextRect.Top) - ACanvas.TextHeight(txt)) div 2;
    }

  SetBkMode(ACanvas.Handle, TRANSPARENT);


  if Default and Enabled then
  begin

    Inc(TextRect.Left, 1);
    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 30);
    ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);
    Dec(TextRect.Left, 1);


    Inc(TextRect.Top, 2);
    Inc(TextRect.Left, 1);
    Inc(TextRect.Right, 1);


    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 30);
    ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);


    Dec(TextRect.Top, 1);
    Dec(TextRect.Left, 1);
    Dec(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 40);
    ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);


    Inc(TextRect.Left, 1);
    Inc(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
                              ACanvas.Pixels[TextRect.Left, TextRect.Top], 60);
    ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);

    Dec(TextRect.Left, 1);
    Dec(TextRect.Right, 1);
    Dec(TextRect.Top, 1);

    ACanvas.Font.color := DefColor;
  end;

  ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
  DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);


  txt := ShortCutText + ' ';

  if not Is16Bit then
    ACanvas.Font.color := DefColor
  else
    ACanvas.Font.color := GetShadeColor(ACanvas, DefColor, -40);



  if IsRightToLeft then
  begin
    Inc(TextRect.Left, 10);
    TextFormat := DT_LEFT
  end
  else
  begin
    Dec(TextRect.Right, 10);
    TextFormat := DT_RIGHT;
  end;


  ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
  DrawtextEx(ACanvas.Handle,
    PChar(txt),
    Length(txt),
    TextRect, TextFormat, nil);

end;

function GrayColor(ACanvas: PCanvas; Clr: TColor; Value: integer): TColor;
var
  r, g, b, avg: integer;

begin

  clr := ColorToRGB(clr);
  r := Clr and $000000FF;
  g := (Clr and $0000FF00) shr 8;
  b := (Clr and $00FF0000) shr 16;

  Avg := (r + g + b) div 3;
  Avg := Avg + Value;

  if Avg > 240 then Avg := 240;
  //if ACanvas <> nil then
  //  Result := Windows.GetNearestColor (ACanvas.Handle,RGB(Avg, avg, avg));
   Result := RGB(Avg, avg, avg);
end;

procedure GrayBitmap(ABitmap: PBitmap; Value: integer);
var
  x, y: integer;
  LastColor1, LastColor2, Color: TColor;
begin
  LastColor1 := 0;
  LastColor2 := 0;

  for y := 0 to ABitmap.Height do
    for x := 0 to ABitmap.Width do
    begin
      Color := ABitmap.Canvas.Pixels[x, y];
      if Color = LastColor1 then
        ABitmap.Canvas.Pixels[x, y] := LastColor2
      else
      begin
        LastColor2 := GrayColor(ABitmap.Canvas , Color, Value);
        ABitmap.Canvas.Pixels[x, y] := LastColor2;
        LastColor1 := Color;
      end;
    end;
end;

procedure DrawBitmapShadow(B: PBitmap; ACanvas: PCanvas; X, Y: integer;
  ShadowColor: TColor);
var
  BX, BY: integer;
  TransparentColor: TColor;
begin
  TransparentColor := B.Canvas.Pixels[0, B.Height - 1];
  for BY := 0 to B.Height - 1 do
    for BX := 0 to B.Width - 1 do
    begin
      if B.Canvas.Pixels[BX, BY] <> TransparentColor then
        ACanvas.Pixels[X + BX, Y + BY] := ShadowColor;
    end;
end;

procedure DrawIcon(Sender: PMHXPControl; ACanvas: PCanvas; B: PBitmap;
 IconRect: Trect; Hot, Selected, Enabled, Checked, FTopMenu,
 IsRightToLeft: boolean);
var
  DefColor: TColor;
  X, Y: integer;
begin

  if (B <> nil) and (B.Width > 0) then
  begin
    X := IconRect.Left;
    Y := IconRect.Top + 1;

   { if false then//(Sender is TMenuItem) then
    begin
      inc(Y, 2);
      if FIconWidth > B.Width then
        X := X + ((FIconWidth - B.Width) div 2) - 1
      else
      begin
        if IsRightToLeft then
          X := IconRect.Right - b.Width - 2
        else
          X := IconRect.Left + 2;
      end;
    end; }

    if FTopMenu then
    begin
      if IsRightToLeft then
        X := IconRect.Right - b.Width - 5
      else
        X := IconRect.Left + 1;
    end;


    if (Hot) and (not FTopMenu) and (Enabled) and (not Checked) then
      if not Selected then
      begin
        dec(X, 1);
        dec(Y, 1);
      end;

    if (not Hot) and (Enabled) and (not Checked) then
      if Is16Bit then
      ;
       // DimBitmap(B, FDimLevel{30});


    if not Enabled then
    begin
     // GrayBitmap(B, FGrayLevel );
      DimBitmap(B, 40);
    end;

    if (Hot) and (Enabled) and (not Checked) then
    begin
      if true then//(Is16Bit) and (not UseSystemColors) and (Sender is TToolButton) then
        DefColor := NewColor(ACanvas, {FSelectColor}clRed, 68)
      else
        DefColor := FFSelectColor;

      DefColor := GetShadeColor(ACanvas, DefColor, 50);
      DrawBitmapShadow(B, ACanvas, X + 2, Y + 2, DefColor);
    end;

   // B.Transparent := true;
//    ACanvas.Draw(X, Y, B);
  end;

end;

procedure PaintXPSpeedButton(Sender: PMHXPControl);
var
//  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor: TColor;
  Txt: string;
  TextRect, IconRect: TRect;
  TxtFont: PGraphicTool;
  B, BF: PBitmap;
  CWidth, CHeight, BWidth, BHeight, TWidth, THeight, Space,
  NumGlyphs, Offset: integer;
  TextFormat: integer;
  FDown, FFlat, FTransparent: boolean;
  FLayout: TGlyphLayout;
begin

{  C := TControlCanvas.Create;
  try
    C.Control := Control;
 }
    //XPMenu.SetGlobalColor(C);   //
    SetGlobalColor(Sender);
    FDown := Sender.Checked;//        false;//{TSpeedButton}(Sender).Down;
    FFlat := {TSpeedButton}(Sender).Flat;
    FTransparent := {TSpeedButton}(Sender).Transparent;
    NumGlyphs := 4;//{TSpeedButton}(Sender).GlyphCount;

    if (Sender.MouseInControl) then
    begin
      if Sender.Tag = 1000 then // UseParentColor
      begin
        SelectColor := NewColor(Sender.Canvas, {TControl}(Sender).Parent.Brush.Color, {xpMenu.}FDimParentColorSelect);
        if FFlat then
          SelectColor := {xpMenu.}FFSelectColor ;
      end
      else
      begin
        SelectColor := NewColor(Sender.Canvas, clBtnFace, {xpMenu.}FDimParentColorSelect);
        if FFlat then
          SelectColor := {xpMenu.}FFSelectColor ;
      end;
      BorderColor := NewColor(Sender.Canvas,{ XPMenu.}FFSelectBorderColor,60);
    end
    else
    begin
      if Sender.Tag = 1000 then
        SelectColor := NewColor(Sender.Canvas, (sender).Parent.Brush.Color,{ xpMenu.}FDimParentColor)
      else
        SelectColor := {XPMenu.}FFIconBackColor;
        if FFlat then
          SelectColor := (Sender).Parent.Brush.Color;

     {   if (Control.ClassName = 'TNavButton') and FFlat then
        begin
          SelectColor := TControl(Control).Parent.Brush.Color;
        end;}
      BorderColor := clBtnShadow;
    end;


    if FDown then
    begin
      SelectColor := FCheckedAreaColor;
      BorderColor := FFSelectBorderColor;
    end;

    if FDown and Sender.MouseInControl then
    begin
      SelectColor := FCheckedAreaSelectColor;
      BorderColor := FFSelectBorderColor;
    end;

    if not (Sender).Enabled then
      BorderColor := clBtnShadow;


    TextFormat := + DT_CENTER + DT_VCENTER;;
    R := sENDer.ClientRect;

    CWidth := (R.Right - R.Left);
    CHeight := (R.Bottom - R.Top);


    if (FDown or Sender.MouseInControl) and FTransparent then
    begin
      BF := NewBitmap(0,0);//TBitmap.Create;
     // try
        BF.Width := R.Right - R.Left;
        BF.Height := R.Bottom - R.Top;

        if FFlat then
        begin
          if GetDeviceCaps(Sender.Canvas.Handle, BITSPIXEL) > 16 then
            BF.Canvas.Brush.Color := NewColor(Sender.Canvas, FFSelectColor, 20)
          else
            BF.Canvas.Brush.Color := SelectColor;
        end
        else
        begin
          if GetDeviceCaps(Sender.Canvas.Handle, BITSPIXEL) > 16 then
            BF.Canvas.Brush.Color := NewColor(Sender.Canvas, SelectColor, 5)
          else
            BF.Canvas.Brush.Color := SelectColor;
        end;
        BF.Canvas.FillRect (R);
        BitBlt(Sender.Canvas.handle,
               R.Left,
               R.Top,
               R.Right - R.left,
               R.Bottom - R.top,
               BF.Canvas.Handle,
               0,
               0,
               SRCAND);
     // finally
        BF.Free;
     // end;
    end;




    Sender.Canvas.Brush.Color := SelectColor;
    if not FTransparent then
       Sender.Canvas.FillRect (R);

   { if Control.ClassName = 'TNavButton' then
    begin
      c.FillRect (R);
    end;
    }Sender.Canvas.Pen.Color := NewColor(Sender.Canvas, BorderColor, 30);

    if (FFlat) and (not FTransparent) and (not FDown) and (not Sender.MouseInControl) then
      Sender.Canvas.Pen.Color :=  Sender.Canvas.Brush.Color;

    if FTransparent  then
      Sender.Canvas.Brush.BrushStyle := bsClear;
//    else    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//      C.Brush.Style := bsSolid;
    if ((FTransparent) and (Sender.MouseInControl)) or
       ((FTransparent) and (FDown)) or
       ((not FTransparent )) or
       ((not FFlat))
     then
     begin
       Sender.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
     end;

    if (Sender).Enabled then
    begin
      if (FFlat) then
      begin
        if (Sender.LButtonBressed ) or (FDown) then
        begin
          Sender.Canvas.Pen.Color := BorderColor;
          Sender.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
          Sender.Canvas.Pen.Color :=  GetShadeColor(Sender.Canvas, BorderColor, 50);

          Sender.Canvas.MoveTo(R.Left , R.Bottom - 1);
          Sender.Canvas.LineTo(R.Left , R.Top );
          Sender.Canvas.LineTo(R.Right  , R.Top );
        end
        else
        if (Sender.MouseInControl) then
        begin
         Sender.Canvas.Pen.Color := FFSelectBorderColor;
         Sender.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
        end;
      end;
        {    // !!!!!!!!!!!!!!!!!!!!!!!!!!
        else
        begin
          C.Pen.Color :=  GetShadeColor(C, BorderColor, 50);
          C.MoveTo(R.Right - 1, R.Top );
          C.LineTo(R.Right - 1, R.Bottom - 1);
          C.LineTo(R.Left , R.Bottom - 1);
        end;
        }
      if (not FFlat) then
        if (Sender.MouseInControl ) or (FDown) then
        begin
          Sender.Canvas.Pen.Color :=  GetShadeColor(Sender.Canvas, BorderColor, 50);
          Sender.Canvas.MoveTo(R.Left , R.Bottom - 1);
          Sender.Canvas.LineTo(R.Left , R.Top );
          Sender.Canvas.LineTo(R.Right  , R.Top );
        end
        else
        begin
          Sender.Canvas.Pen.Color :=  GetShadeColor(Sender.Canvas, BorderColor, 50);
          Sender.Canvas.MoveTo(R.Right - 1, R.Top );
          Sender.Canvas.LineTo(R.Right - 1, R.Bottom - 1);
          Sender.Canvas.LineTo(R.Left , R.Bottom - 1);
        end;
    end;
    Txt := (Sender).Caption;

    TextRect := R;

    TxtFont := {TSpeedButton}(Sender).Font;
    Sender.Canvas.Font.Assign (TxtFont);

    TWidth := Sender.Canvas.TextWidth(Txt);
    //THeight := C.TextHeight(Txt);  // !!!!!!!!!!!!!!!!!!!!!!!!!
    TextRect.Left := (CWidth - TWidth) div 2;


   // if (Sender).IsRightToLeft then
   //   TextFormat := TextFormat + DT_RTLREADING;

//--- //"Holger Lembke" <holger@hlembke.de>

    if (Txt <> '') then
    begin
      FillChar(TextRect, sizeof(TextRect),0);
      DrawText(Sender.Canvas.Handle,
               PChar(Txt), Length(Txt),
               TextRect,
               DT_CALCRECT {+ control.DrawTextBiDiModeFlags(0)});
      TWidth := TextRect.Right;
      THeight := TextRect.Bottom;
    end
    else
    begin
      TWidth := 0;
      THeight := 0;
    end;

//---

    if false then//((Sender).Glyph <> nil) then
    begin
      B := NewBitmap(0,0);//TBitmap.Create;
     { BWidth := TSpeedButton(Control).Glyph.Width  div
                TSpeedButton(Control).NumGlyphs;

      BHeight :=  TSpeedButton(Control).Glyph.Height;

      B.Width := BWidth;
      B.Height := BHeight;
      if Length(TSpeedButton(Control).Caption) > 0 then
        Space := TSpeedButton(Control).Spacing
      else
        Space := 0;

      IconRect := Rect(R.Left , R.Top, R.Left+BWidth, R.Top + BHeight);


      // Suggested by : "Holger Lembke" <holger@hlembke.de>
      Offset := 1;
      if (not Control.Enabled) and (NumGlyphs > 1) then
        Offset := 2;
      if (FLButtonBressed) and (NumGlyphs > 2) then
        Offset := 3;
      if (FDown) and (NumGlyphs > 3) then
        Offset := 4;
           }

   {   B.Canvas.CopyRect (Rect(0, 0, BWidth, BHeight),
                         TSpeedButton(Control).Glyph.Canvas,
                         Rect((BWidth * Offset) - BWidth, 0, BWidth * Offset, BHeight));

    }
      FLayout :=Sender.fGlyphLayout; //TSpeedButton(Control).Layout;
{      if Control.IsRightToLeft then
      begin
        if FLayout = blGlyphLeft then
          FLayout := blGlyphRight
        else
          if FLayout = blGlyphRight then FLayout := blGlyphLeft;
      end; }
     // glyphLeft, glyphTop, glyphRight, glyphBottom, glyphOver
      case FLayout{Sender.fGlyphLayout} of
        glyphLeft:
        begin
          IconRect.Left := (CWidth - (BWidth + Space + TWidth)) div 2;
          IconRect.Right := IconRect.Left + BWidth;
          IconRect.Top  := ((CHeight - (BHeight)) div 2) - 1;
          IconRect.Bottom := IconRect.Top + BHeight;

          TextRect.Left := IconRect.Right + Space;
          TextRect.Right := TextRect.Left + TWidth;
          TextRect.Top := (CHeight - (THeight)) div 2;
          TextRect.Bottom := TextRect.Top + THeight;

        end;
        glyphRight:
        begin
          IconRect.Right := (CWidth + (BWidth + Space + TWidth)) div 2;
          IconRect.Left := IconRect.Right - BWidth;
          IconRect.Top  := (CHeight - (BHeight)) div 2;
          IconRect.Bottom := IconRect.Top + BHeight;

          TextRect.Right := IconRect.Left - Space;
          TextRect.Left := TextRect.Right - TWidth;
          TextRect.Top := (CHeight - (THeight)) div 2;
          TextRect.Bottom := TextRect.Top + THeight;

        end;
        GlyphTop:
        begin
          IconRect.Left := (CWidth - BWidth) div 2;
          IconRect.Right := IconRect.Left + BWidth;
          IconRect.Top  := (CHeight - (BHeight + Space + THeight)) div 2;
          IconRect.Bottom := IconRect.Top + BHeight;

          TextRect.Left := (CWidth - (TWidth)) div 2;
          TextRect.Right := TextRect.Left + TWidth;
          TextRect.Top := IconRect.Bottom + Space;
          TextRect.Bottom := TextRect.Top + THeight;

        end;
        GlyphBottom:
        begin
          IconRect.Left := (CWidth - BWidth) div 2;
          IconRect.Right := IconRect.Left + BWidth;
          IconRect.Bottom  := (CHeight + (BHeight + Space + THeight)) div 2;
          IconRect.Top := IconRect.Bottom - BHeight;

          TextRect.Left := (CWidth - (TWidth)) div 2;
          TextRect.Right := TextRect.Left + TWidth;
          TextRect.Bottom := IconRect.Top - Space;
          TextRect.Top := TextRect.Bottom - THeight;

        end;

      end;

    {  xpMenu.}DrawIcon(Sender, Sender.Canvas , B, IconRect,
        Sender.MouseinControl,
        Sender.Focused,
        (Sender).Enabled,
        FDown or Sender.LButtonBressed,
        false,
        {(Sender).IsRightToLeft}false);

      B.Free;
    end;

    DrawTheText(Sender,
                       Txt, '', Sender.Canvas,
                       TextRect, false,
                       (Sender).Enabled,
                       false,
                       false,
                       false,//(Sender).IsRightToLeft,
                       TxtFont,
                       TextFormat);
 { finally
    C.Free;
  end;
  }
end;

procedure PaintXPRadioBox(Sender: PMHXPControl);
var
  //  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor: TColor;
begin

  //  C := TControlCanvas.Create;
  //  try
  //    C.Control := Control;
  {    XPMenu.} SetGlobalColor(Sender);

  if Sender.MouseInControl then
  begin
    SelectColor := FFSelectColor;
    BorderColor := FFSelectBorderColor;
  end
  else
  begin
    SelectColor := clWindow;
    BorderColor := clBtnShadow;
  end;

  if Sender.Focused then
    SelectColor := FFSelectColor;

  R := Sender.ClientRect;
  InflateRect(R, 0, -4);

  R.Top := R.Top + ((R.Bottom - R.Top - GetSystemMetrics(SM_CXHTHUMB)) div 2);
  R.Bottom := R.Top + GetSystemMetrics(SM_CXHTHUMB) - 1;

  if ((Sender.BiDiMode = bdRightToLeft) and
    (Sender.Alignment = taRightJustify)) or
    ((Sender.BiDiMode = bdLeftToRight) and
    (Sender.Alignment = taLeftJustify)) then
    R.Left := R.Right - GetSystemMetrics(SM_CXHTHUMB) + 1
  else if ((Sender.BiDiMode = bdLeftToRight) and
    (Sender.Alignment = taRightJustify)) or
    ((Sender.BiDiMode = bdRightToLeft) and
    (Sender.Alignment = taLeftJustify)) then
    R.Right := R.Left + GetSystemMetrics(SM_CXHTHUMB) - 1;

  Sender.Canvas.Brush.Color := Sender.Color;
  Sender.Canvas.FillRect(R);

  InflateRect(R, -2, -2);
  Sender.Canvas.Brush.Color := SelectColor;
  Sender.Canvas.Pen.Color := BorderColor;

  Sender.Canvas.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
  if Sender.Checked then
  begin
    InflateRect(R, -2, -2);

    if Sender.Enabled then
      Sender.Canvas.Brush.Color := clHighlight
    else
      Sender.Canvas.Brush.Color := FFDisabledColor;

    Sender.Canvas.Pen.Color := Sender.Canvas.Brush.Color;
    Sender.Canvas.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
  end;
  // finally
 //    C.Free;
 //  end;

end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

(*procedure DrawTheText(Sender: PMHXPControl; txt, ShortCuttext: string;
  ACanvas: PCanvas; TextRect: TRect;
  Selected, Enabled, Default, TopMenu, IsRightToLeft: boolean;
  var TxtFont: PGraphicTool; TextFormat: integer);
var
  DefColor: TColor;
  //  B: TBitmap;
  //  BRect: TRect;
begin
  DefColor := TxtFont.Color;

  ACanvas.Font.Assign(TxtFont);

  if Selected then
    DefColor := FFSelectFontColor;

  if not Enabled then
  begin
    DefColor := FFDisabledColor;

    {    if (Sender is TToolButton) then
        begin
          TextRect.Top := TextRect.Top +
            ((TextRect.Bottom - TextRect.Top) - ACanvas.TextHeight('W')) div 2;
          B := TBitmap.Create;
          try
            B.Width := TextRect.Right - TextRect.Left;
            B.Height := TextRect.Bottom - TextRect.Top;
            BRect := Rect(0,0,B.Width, B.Height);

            B.Canvas.Brush.Color := ACanvas.Brush.Color;
            B.Canvas.FillRect (BRect);
      //      B.Canvas.Font := FFont; //felix added for resolving font problems in Win98
                                    //27.08
            B.Canvas.Font.color := DefColor;

            DrawtextEx(B.Canvas.Handle,
              PChar(txt),
              Length(txt),
              BRect, TextFormat + DT_VCENTER, nil);
            ACanvas.CopyRect(TextRect, B.Canvas, BRect);
          finally
            B.Free;
          end;
          exit;
        end;}
  end;

  {  if (TopMenu and Selected) then
      if FUseSystemColors then
        DefColor := TopMenuFontColor(ACanvas, FFIconBackColor);}

  //  ACanvas.Font.Color := DefColor;    // will not affect Buttons
  //New
   {
    TextRect.Top := TextRect.Top +
      ((TextRect.Bottom - TextRect.Top) - ACanvas.TextHeight(txt)) div 2;
      }

  SetBkMode(ACanvas.Handle, TRANSPARENT);

  if Default and Enabled then
  begin
    Inc(TextRect.Left, 1);
    ACanvas.Font.color := GetShadeColor(ACanvas,
      ACanvas.Pixels[TextRect.Left, TextRect.Top], 30);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);
    Dec(TextRect.Left, 1);

    Inc(TextRect.Top, 2);
    Inc(TextRect.Left, 1);
    Inc(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
      ACanvas.Pixels[TextRect.Left, TextRect.Top], 30);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);

    Dec(TextRect.Top, 1);
    Dec(TextRect.Left, 1);
    Dec(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
      ACanvas.Pixels[TextRect.Left, TextRect.Top], 40);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);

    Inc(TextRect.Left, 1);
    Inc(TextRect.Right, 1);

    ACanvas.Font.color := GetShadeColor(ACanvas,
      ACanvas.Pixels[TextRect.Left, TextRect.Top], 60);
    DrawtextEx(ACanvas.Handle,
      PChar(txt),
      Length(txt),
      TextRect, TextFormat, nil);

    Dec(TextRect.Left, 1);
    Dec(TextRect.Right, 1);
    Dec(TextRect.Top, 1);

    ACanvas.Font.color := DefColor;
  end;

  DrawtextEx(ACanvas.Handle,
    PChar(txt),
    Length(txt),
    TextRect, TextFormat, nil);

  txt := ShortCutText + ' ';

  if not Is16Bit then
    ACanvas.Font.color := DefColor
  else
    ACanvas.Font.color := GetShadeColor(ACanvas, DefColor, -40);

  if IsRightToLeft then
  begin
    Inc(TextRect.Left, 10);
    TextFormat := DT_LEFT
  end
  else
  begin
    Dec(TextRect.Right, 10);
    TextFormat := DT_RIGHT;
  end;

  DrawtextEx(ACanvas.Handle,
    PChar(txt),
    Length(txt),
    TextRect, TextFormat, nil);
end;           *)

procedure PaintXPButton(Sender: PMHXPControl);
var
  //  C: TControlCanvas;
  R: TRect;
  SelectColor, BorderColor: TColor;
  Txt: string;
  TextRect: TRect;
  TxtFont: PGraphicTool;
  CWidth, CHeight, TWidth, THeight: integer;
  TextFormat: integer;
begin
  SetGlobalColor(Sender);

  if Sender.MouseInControl then
  begin
    if Sender.Tag = 1000 then
      SelectColor := NewColor(Sender.Canvas, Sender.Parent.Brush.Color, FDimParentColorSelect)
    else
      SelectColor := NewColor(Sender.Canvas, clBtnFace, FDimParentColorSelect);
    BorderColor := NewColor(Sender.Canvas, FFSelectBorderColor, 60);
  end
  else
  begin
    if Sender.Tag = 1000 then
      SelectColor := NewColor(Sender.Canvas, Sender.Parent.Brush.Color, FDimParentColor)
    else
      SelectColor := FFIconBackColor;
    BorderColor := clBtnShadow;
  end;

  if (not Sender.MouseInControl) and (Sender.Focused) then
  begin
    BorderColor := NewColor(Sender.Canvas, FFSelectBorderColor, 60);
  end;

  TextFormat := DT_CENTER + DT_VCENTER;
  R := Sender.ClientRect;

  CWidth := (R.Right - R.Left);
  CHeight := (R.Bottom - R.Top);

  Sender.Brush.Color := Sender.Color;
  Sender.Canvas.FillRect(R);

  Sender.Brush.Color := SelectColor;

  Sender.Canvas.Pen.Color := NewColor(Sender.Canvas, BorderColor, 30);
  Sender.Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 4, 4);

  if Sender.Enabled then
    if (Sender.Bressed) or (Sender.LButtonBressed and Sender.MouseinControl) {or FBressed} then
    begin
      Sender.Canvas.Pen.Color := GetShadeColor(Sender.Canvas, BorderColor, 50);
      Sender.Canvas.MoveTo(R.Left, R.Bottom - 2);
      Sender.Canvas.LineTo(R.Left, R.Top + 1);
      Sender.Canvas.LineTo(R.Left + 1, R.Top);
      Sender.Canvas.LineTo(R.Right - 1, R.Top);
    end
    else
    begin
      Sender.Canvas.Pen.Color := GetShadeColor(Sender.Canvas, BorderColor, 50);
      Sender.Canvas.MoveTo(R.Right - 1, R.Top + 1);
      Sender.Canvas.LineTo(R.Right - 1, R.Bottom - 2);
      Sender.Canvas.LineTo(R.Right - 2, R.Bottom - 1);
      Sender.Canvas.LineTo(R.Left, R.Bottom - 1);
    end;

  Txt := Sender.Caption;

  TextRect := R;

  TxtFont := Sender.Font;

  Sender.Canvas.Font.Assign(TxtFont);

  if ((Sender.BiDiMode = bdRightToLeft) and
    (Sender.Alignment = taLeftJustify)) then
    TextFormat := TextFormat + DT_RTLREADING;

  if (Txt <> '') then
  begin
    FillChar(TextRect, SizeOf(TextRect), 0);
    DrawText(Sender.Canvas.Handle,
      PChar(Txt), Length(Txt),
      TextRect,
      DT_CALCRECT);

    TWidth := TextRect.Right;
    THeight := TextRect.Bottom;
  end
  else
  begin
    TWidth := 0;
    THeight := 0;
  end;

  //---
  TextRect.Left := (CWidth - (TWidth)) div 2;
  TextRect.Right := TextRect.Left + TWidth;
  TextRect.Top := (CHeight - (THeight)) div 2;
  TextRect.Bottom := TextRect.Top + THeight;

  DrawTheText(Sender, Txt, '', Sender.Canvas,
    TextRect, false,
    Sender.fEnabled,
    Sender.fDefaultBtn,
    false,
    (((Sender.BiDiMode = bdRightToLeft) and
    (Sender.Alignment = taLeftJustify))),
    TxtFont,
    TextFormat);

end;

procedure PaintXPEditBox(Sender: PMHXPControl);
var
  R: TRect;
  BorderColor: TColor;
begin
  SetGlobalColor(Sender);

  {    if Sender.Ctl3D <> false then
      begin
        Sender.Building := true;
        Sender.Ctl3D := false;
      end;
   }
  if (Sender.MouseinControl) or (Sender.Focused) then
  begin
    if Sender.Border = 2 then
      borderColor := NewColor(Sender.Canvas, FFSelectBorderColor, 60)
    else
      borderColor := NewColor(Sender.Canvas, FFSelectBorderColor, 80);
  end
  else
  begin
    if Sender.Border = 2 then
      borderColor := GetShadeColor(Sender.Canvas, Sender.Parent.Brush.Color, 60)
    else
      borderColor := Sender.Parent.Brush.Color;
  end;

  R := Sender.ClientRect;

  Sender.Canvas.Pen.Color := BorderColor;
  Sender.Canvas.Brush.BrushStyle := bsClear;
  Sender.Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
end;

procedure PaintXPComboBox(Sender: PMHXPControl);
var
  R: TRect;
  SelectColor, BorderColor, ArrowColor: TColor;
  X: integer;
begin
  SetGlobalColor(Sender);
  if Sender.Enabled then
    ArrowColor := clBlack
  else
    ArrowColor := clWhite;

  if (Sender.MouseinControl) then
  begin
    borderColor := FFSelectBorderColor;
    SelectColor := FFSelectColor;
  end
  else
  begin
    borderColor := Sender.Color;
    //     borderColor := clBlack;   // Установил сам
    if Sender.Tag = 1000 then
      SelectColor := NewColor(Sender.Canvas, Sender.Parent.Brush.Color, FDimParentColor)
    else
      selectColor := clBtnFace;
  end;

  if (not Sender.MouseinControl) and (Sender.Focused) then
  begin
    borderColor := NewColor(Sender.Canvas, { Sender.Parent.Brush.Color} FFSelectBorderColor, 60);
    SelectColor := FCheckedAreaColor;
  end;

  R := Sender.ClientRect;

  Sender.Canvas.Brush.Color := Sender.Parent.Brush.Color;
  Sender.Canvas.FrameRect(R);
  InflateRect(R, -1, -1);

  Sender.Canvas.Pen.Color := Sender.Canvas.Brush.Color;
  Sender.Canvas.MoveTo(R.Left, R.Top);
  Sender.Canvas.LineTo(R.Right, R.Top);

  InflateRect(R, 0, -1);

  if (Sender.MouseinControl) or (Sender.Focused) then
    InflateRect(R, 1, 1);

  Sender.Canvas.Brush.Color := Sender.Color;
  Sender.Canvas.FrameRect(R);

  Inc(R.Bottom, 1);
  Sender.Canvas.Brush.Color := BorderColor;
  Sender.Canvas.FrameRect(R);

  if Sender.DroppedDown then
  begin
    BorderColor := FFSelectBorderColor;
    ArrowColor := clWhite;
    SelectColor := FCheckedAreaSelectColor;
  end;

  if true then //{TKOLComboBox}coSimple in PControl(Sender).Options then//<> [coSimple] then
  begin
    InflateRect(R, -1, -1);

    if Sender.BiDiMode = bdRightToLeft then
      R.Right := R.Left + GetSystemMetrics(SM_CXHTHUMB) + 1
    else
      R.Left := R.Right - GetSystemMetrics(SM_CXHTHUMB) - 1;

    if (Sender.MouseinControl or Sender.Focused) then
    begin
      if Sender.BiDiMode = bdRightToLeft then
        Inc(R.Right, 2)
      else
        Dec(R.Left, 1);
    end;

    Sender.Canvas.Brush.Color := SelectColor;
    Sender.Canvas.FillRect(R);

    if Sender.BiDiMode = bdRightToLeft then
      R.Left := R.Right - 5
    else
      R.Right := R.Left + 5;

    Sender.Canvas.Brush.Color := Sender.Color;
    Sender.Canvas.FillRect(R);

    Sender.Canvas.Pen.Color := BorderColor;

    if Sender.BiDiMode = bdRightToLeft then
    begin
      Sender.Canvas.Moveto(R.Left, R.Top);
      Sender.Canvas.LineTo(R.Left, R.Bottom);
    end
    else
    begin
      Sender.Canvas.Moveto(R.Right, R.Top);
      Sender.Canvas.LineTo(R.Right, R.Bottom);
    end;

    Sender.Canvas.Pen.Color := arrowColor;

    R := Sender.ClientRect;

    if Sender.BiDiMode = bdRightToLeft then
      X := R.Left + 5
    else
      X := R.Right - 10;

    Sender.Canvas.Moveto(X + 0, R.Top + 10);
    Sender.Canvas.LineTo(X + 5, R.Top + 10);
    Sender.Canvas.Moveto(X + 1, R.Top + 11);
    Sender.Canvas.LineTo(X + 4, R.Top + 11);
    Sender.Canvas.Moveto(X + 2, R.Top + 12);
    Sender.Canvas.LineTo(X + 3, R.Top + 12);
  end;
end;

procedure PaintXPRichEdit(Sender: PMHXPControl);
var
  R: TRect;
  BorderColor: TColor;
begin
  SetGlobalColor(Sender);
  R := Sender.ClientRect; //BoundsRect;
  //InflateRect(R, 1, 1);
//    R.Left:=-1;
//    R.Top:=-1;
  if Sender.Border > 2 then
  begin
    Sender.Building := true;
    Sender.Border := 2;
  end;

  if (Sender.mouseinControl) or (Sender.Focused) then
    borderColor := NewColor(Sender.Canvas, FFSelectBorderColor, 60)
  else
    borderColor := Sender.Parent.Brush.Color;

  Frame3D(Sender.Canvas, R, borderColor, borderColor, 1);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure PaintControlXP(S: PControl);
begin
  //  PaintRadio(PMHXPControl(S));
  //  PaintPanel(PMHXPControl(S));
  //  PaintCheckBox(PMHXPControl(S));
end;

function WndProcXPControl(Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  XPControl: PMHXPControl;
begin
  Result := False;
  XPControl := PMHXPControl(Sender);

  case Msg.message of
    EM_GETMODIFY:
      begin
        XPControl.Building := true;
      end;

    CM_PARENTCOLORCHANGED:
      begin
        //        PCompObj(PMHXPControl(Ctl).CustomObj).FPaintXPControl();
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    WM_DESTROY:
      begin
        //        SetWindowLong(Ctl.Handle, GWL_WNDPROC, DWord(PMHXPControl(Ctl).OldWndProc));
                {       if not Form1.FBuilding then
                       begin
                         try
                          if Ctl <> nil then
                           begin
                             Form1.FBuilding := false;
                             Ctl.Free;
                           end;
                         except
                         end;
                       end;
                       Exit;}
      end;

    WM_PAINT:
      begin
        XPControl.Building := false;
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    {    WM_MOUSEHOVER:
          if XPControl.Enabled then
          begin
            XPControl.mouseInControl := true;
            if XPControl.Windowed then
            begin
              XPControl.Update;
              exit;
            end;
            XPControl.PaintXPControl(XPControl);
            //        PaintControlXP(XPControl);
          end;

        WM_MOUSELEAVE:
          if XPControl.Enabled then
          begin
            PMHXPControl(XPControl).mouseInControl := false;
            if XPControl.Windowed then
            begin
              XPControl.Update;
              exit;
            end;
            XPControl.PaintXPControl(XPControl);
            //        PaintControlXP(XPControl);
          end;
                }
    WM_LBUTTONDOWN:
      begin
        XPControl.LButtonBressed := true;
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    WM_LBUTTONUP:
      begin
        XPControl.LButtonBressed := false;
        if XPControl.Windowed then
        begin
          XPControl.Update;
          exit;
        end;
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    WM_KEYDOWN:
      if Msg.WParam = VK_SPACE then
      begin
        XPControl.Bressed := true;
        if not XPControl.IsKeyDown then
          XPControl.PaintXPControl(XPControl);
        //          PaintControlXP(XPControl);
        XPControl.IsKeyDown := true;
      end;

    WM_KEYUP:
      if Msg.WParam = VK_SPACE then
      begin
        XPControl.Bressed := false;
        XPControl.IsKeyDown := false;
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    WM_SETFOCUS:
      begin
        XPControl.mouseInControl := true;
        XPControl.PaintXPControl(XPControl);
        //    PaintControlXP(XPControl);
      end;

    WM_KILLFOCUS:
      begin
        XPControl.mouseInControl := false;
        XPControl.PaintXPControl(XPControl);
        //   PaintControlXP(XPControl);
      end;

    CM_FOCUSCHANGED:
      begin
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    CM_EXIT:
      begin
        {XPControl.mouseInControl := false;}
        XPControl.PaintXPControl(XPControl);
        //     PaintControlXP(XPControl);
      end;

    BM_SETCHECK:
      begin
        {   XPControl.mouseInControl := false;}
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    BM_GETCHECK:
      begin
        {  XPControl.mouseInControl := false;}
          //     PaintControlXP(Ctl);
      end;

    BM_SETSTATE:
      begin
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    CM_ENABLEDCHANGED:
      begin
        {        if (Msg.WParam = 0) then
                  XPControl.mouseInControl := false;}
        XPControl.PaintXPControl(XPControl);
        //        PaintControlXP(XPControl);
      end;

    CM_TEXTCHANGED:
      begin
        XPControl.PaintXPControl(XPControl);
        //    PaintControlXP(XPControl);
      end;

    CM_CTL3DCHANGED, CM_PARENTCTL3DCHANGED:
      begin
        XPControl.Building := true;
      end;

    WM_LBUTTONDBLCLK:
      begin
        XPControl.Perform(WM_LBUTTONDOWN, Msg.WParam, Longint(Msg.LParam));
      end;

    WM_WINDOWPOSCHANGED, CN_PARENTNOTIFY:
      begin
        XPControl.Building := true;
      end;
  end;
end;

function ThrowWndProc(Wnd: HWnd; Msg: Cardinal; wParam, lParam: Integer): Integer; stdcall;
var
  self_: PMHXPControl;
  Mgs_: TMsg;
  Res: Integer;
begin
  self_ := Pointer(GetProp(Wnd, ID_SELF));
  Result := CallWindowProc(self_.OldWndProc, Wnd, Msg, wParam, lParam);
  Mgs_.hwnd := Wnd;
  Mgs_.message := Msg;
  Mgs_.wParam := wParam;
  Mgs_.lParam := lParam;
  WndProcXPControl(self_, Mgs_, Res);
end;

function NewMHXPPanel(AParent: PControl; EdgeStyle: TEdgeStyle): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewPanel(AParent, EdgeStyle));
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPPanel;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

function NewMHXPCheckBox(AParent: PControl; const Caption: string): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewCheckBox(AParent, Caption));

  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPCheckBox;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

function NewMHXPRadioBox(AParent: PControl; const Caption: string): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewRadioBox(AParent, Caption));
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPRadioBox;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function NewMHXPButton(AParent: PControl; const Caption: string): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewButton(AParent, Caption));
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPButton;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

function NewMHXPEditBox(AParent: PControl; const Options: TEditOptions): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewEditBox(AParent, Options));
  Result.Ctl3D := false;
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPEditBox;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

function NewMHXPComboBox(AParent: PControl; const Options: TComboOptions): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewComboBox(AParent, Options));
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPComboBox;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

function NewMHXPRichEdit(AParent: PControl; const Options: TEditOptions): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewRichEdit(AParent, Options));
  Result.Ctl3D := false;
  Result.HasBorder := false;
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPRichEdit;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;

function NewMHXPSpeedButton(AParent: PControl; const Caption: String;
         Options: TBitBtnOptions; Layout: TGlyphLayout; GlyphBitmap: HBitmap;
         GlyphCount: Integer ): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);
  Result := PMHXPControl(NewBitBtn(AParent, Caption, Options,Layout, GlyphBitmap, GlyphCount ));
  Result.Ctl3D := false;
  Result.HasBorder := false;
  Result.CustomObj := D;
  Result.CreateWindow;
  PCompObj(Result.CustomObj).FOwner := Result;
  PCompObj(Result.CustomObj).FPaintXPControl := PaintXPSpeedButton;
  Result.Alignment := taRightJustify;
  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  Result.SetEvents;
end;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function NewDemo(Sender: PControl): PMHXPControl;
var
  D: PCompObj;
begin
  New(D, Create);

  Result := PMHXPControl(NewCheckBox(Sender, 'Demo'));

  Result.CustomObj := D;
  //D.fControl := Result;

  // Code

  { Установка обработчиков }
  //SetWindowLong(Result.Handle,GWL_WNDPROC,@MyNewProc);
  //Result.WndProc()

  Result.CreateWindow;

  PCompObj(Result.CustomObj).FOwner := Result;

  Result.OldWndProc := Pointer(GetWindowLong(Result.Handle, GWL_WNDPROC));
  SetWindowLong(Result.Handle, GWL_WNDPROC, DWord(@ThrowWndProc));
  //Result.AttachProc(WndProcCheckBoxXP);//WndProcComp);

  //D1:=Pointer(GetWindowLong(Result.Handle,GWL_WNDPROC));

  { Установка нового обработчика }
  // Result.SetOnLVData(Result.OnNewLVData);
end;
////////////////////////////////////////////////////////////////////////////////

{ TMHXPControl }

function TMHXPControl.GetAlignment: TAlignment;
begin
  Result := PCompObj(CustomObj).FAlignment;
end;

function TMHXPControl.GetBevelInner: TBevelCut;
begin
  Result := PCompObj(CustomObj).FBevelInner;
end;

function TMHXPControl.GetBevelOuter: TBevelCut;
begin
  Result := PCompObj(CustomObj).FBevelOuter;
end;

function TMHXPControl.GetBevelWidth: TBevelWidth;
begin
  Result := PCompObj(CustomObj).FBevelWidth;
end;

function TMHXPControl.GetBiDiMode: TBiDiMode;
begin
  Result := PCompObj(CustomObj).FBiDiMode;
end;

function TMHXPControl.GetBressed: Boolean;
begin
  Result := PCompObj(CustomObj).FBressed;
end;

function TMHXPControl.GetBuilding: Boolean;
begin
  Result := PCompObj(CustomObj).FBuilding;
end;

function TMHXPControl.GetIsKeyDown: Boolean;
begin
  Result := PCompObj(CustomObj).FIsKeyDown;
end;

function TMHXPControl.GetLButtonBressed: Boolean;
begin
  Result := PCompObj(CustomObj).FLButtonBressed;
end;

function TMHXPControl.GetMouseInControl: Boolean;
begin
  Result := PCompObj(CustomObj).FMouseInControl;
end;

function TMHXPControl.GetOldWndProc: Pointer;
begin
  Result := PCompObj(CustomObj).FOldWndProc;
end;

procedure TMHXPControl.SetAlignment(const Value: TAlignment);
begin
  PCompObj(CustomObj).FAlignment := Value;
end;

procedure TMHXPControl.SetBevelInner(const Value: TBevelCut);
begin
  PCompObj(CustomObj).FBevelInner := Value;
end;

procedure TMHXPControl.SetBevelOuter(const Value: TBevelCut);
begin
  PCompObj(CustomObj).FBevelOuter := Value;
end;

procedure TMHXPControl.SetBevelWidth(const Value: TBevelWidth);
begin
  PCompObj(CustomObj).FBevelWidth := Value;
end;

procedure TMHXPControl.SetBiDiMode(const Value: TBiDiMode);
begin
  PCompObj(CustomObj).FBiDiMode := Value;
end;

procedure TMHXPControl.SetBressed(const Value: Boolean);
begin
  PCompObj(CustomObj).FBressed := Value;
end;

procedure TMHXPControl.SetBuilding(const Value: Boolean);
begin
  PCompObj(CustomObj).FBuilding := Value;
end;

procedure TMHXPControl.SetIsKeyDown(const Value: Boolean);
begin
  PCompObj(CustomObj).FIsKeyDown := Value;
end;

procedure TMHXPControl.SetLButtonBressed(const Value: Boolean);
begin
  PCompObj(CustomObj).FLButtonBressed := Value;
end;

procedure TMHXPControl.SetMouseInControl(const Value: Boolean);
begin
  PCompObj(CustomObj).FMouseInControl := Value;
end;

procedure TMHXPControl.SetOldWndProc(const Value: Pointer);
begin
  PCompObj(CustomObj).FOldWndProc := Value;
end;

function TMHXPControl.GetPaintXPControl: TPaintProc;
begin
  Result := PCompObj(CustomObj).FPaintXPControl;
end;

procedure TMHXPControl.SetPaintXPControl(const Value: TPaintProc);
begin
  PCompObj(CustomObj).FPaintXPControl := Value;
end;

function TMHXPControl.GetOnMouseEnter: TOnEvent;
begin
  Result := PCompObj(CustomObj).FOnMouseEnter;
end;

function TMHXPControl.GetOnMouseLeave: TOnEvent;
begin
  Result := PCompObj(CustomObj).FOnMouseLeave;
end;

procedure TMHXPControl.SetOnMouseEnter(const Value: TOnEvent);
begin
  PCompObj(CustomObj).FOnMouseEnter := Value;
end;

procedure TMHXPControl.SetOnMouseLeave(const Value: TOnEvent);
begin
  PCompObj(CustomObj).FOnMouseLeave := Value;
end;

procedure TMHXPControl.Enter(Sender: PObj);
var
  XPControl: PMHXPControl;
begin
  XPControl := PMHXPControl(Sender);
  if XPControl.Enabled then
  begin
    XPControl.mouseInControl := true;
    if XPControl.Windowed then
    begin
      XPControl.Update;
      //   exit;
    end;
    XPControl.PaintXPControl(XPControl);
    //        PaintControlXP(XPControl);
  end;

  if Assigned(PCompObj(CustomObj).fOnMouseEnter) then
    PCompObj(CustomObj).fOnMouseEnter(Sender);
  //  Invalidate;
  //  XPControl.PaintXPControl(XPControl);
end;

procedure TMHXPControl.Leave(Sender: PObj);
var
  XPControl: PMHXPControl;
begin
  XPControl := PMHXPControl(Sender);
  if XPControl.Enabled then
  begin
    PMHXPControl(XPControl).mouseInControl := false;
    if XPControl.Windowed then
    begin
      XPControl.Update;
      //  exit;
    end;
    XPControl.PaintXPControl(XPControl);
    //        PaintControlXP(XPControl);
  end;
  if Assigned(PCompObj(CustomObj).fOnMouseLeave) then
    PCompObj(CustomObj).fOnMouseLeave(Sender);
  //  Invalidate;
  //  XPControl.PaintXPControl(XPControl);
end;

procedure TMHXPControl.SetEvents;
begin
  inherited OnMouseEnter {fOnMouseEnter} := Enter;
  inherited OnMouseLeave {fOnMouseLeave} := Leave;
end;

begin
  FUseSystemColors := True;
end.

