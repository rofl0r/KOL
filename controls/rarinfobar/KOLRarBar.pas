unit KOLRarBar;

interface

uses Windows, Messages, Kol, Objects;

type
  PRarBar = ^TRarBar;
  TRarInfoBar = PRarBar;
  TRarBar = object(TObj)
  private
    { Private declarations }
    FControl: PControl;
    FPosition: integer;
    FShowPerc: boolean;
    FFont: PGraphicTool;

    FLineColor,FTopColor,FSideColor1,FSideColor2,FEmptyColor1,FEmptyColor2,
    FEmptyFrameColor1,FEmptyFrameColor2,FBottomFrameColor,FBottomColor,
    FFilledFrameColor,FFilledColor,FFilledSideColor1,FFilledSideColor2: TColor;

    TopX,TopY,Size: integer;

    FMin,FMax: integer;
    OldWind,NewWind: integer;
    procedure SetPos(P: integer);
    procedure SetMin(M: integer);
    procedure SetMax(M: integer);
    procedure SetFont(F: PGraphicTool);

    procedure SetLineColor(C: TColor);
    procedure SetTopColor(C: TColor);
    procedure SetSideColor1(C: TColor);
    procedure SetSideColor2(C: TColor);
    procedure SetEmptyColor1(C: TColor);
    procedure SetEmptyColor2(C: TColor);
    procedure SetEmptyFrameColor1(C: TColor);
    procedure SetEmptyFrameColor2(C: TColor);
    procedure SetBottomFrameColor(C: TColor);
    procedure SetBottomColor(C: TColor);
    procedure SetFilledFrameColor(C: TColor);
    procedure SetFilledColor(C: TColor);
    procedure SetFilledSideColor1(C: TColor);
    procedure SetFilledSideColor2(C: TColor);
    procedure SetShowPerc(V: boolean);
  protected
    { Protected declarations }
    procedure NewWndProc(var Msg: TMessage);
    procedure Paint;
  public
    destructor Destroy; virtual;
    function SetPosition(X,Y: integer): PRarBar; overload;
    function SetSize(X,Y: integer): PRarBar; overload;
    function SetAlign(A: TControlAlign): PRarBar; overload;
    { Public declarations }
    property Position: integer read FPosition write SetPos;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property ShowPercent: boolean read FShowPerc write SetShowPerc;
    property Font: PGraphicTool read FFont write SetFont;

    property LineColor: TColor read FLineColor write SetLineColor;
    property TopColor: TColor read FTopColor write SetTopColor;
    property SideColor1: TColor read FSideColor1 write SetSideColor1;
    property SideColor2: TColor read FSideColor2 write SetSideColor2;
    property EmptyColor1: TColor read FEmptyColor1 write SetEmptyColor1;
    property EmptyColor2: TColor read FEmptyColor2 write SetEmptyColor2;
    property EmptyFrameColor1: TColor read FEmptyFrameColor1 write SetEmptyFrameColor1;
    property EmptyFrameColor2: TColor read FEmptyFrameColor2 write SetEmptyFrameColor2;
    property BottomFrameColor: TColor read FBottomFrameColor write SetBottomFrameColor;
    property BottomColor: TColor read FBottomColor write SetBottomColor;
    property FilledFrameColor: TColor read FFilledFrameColor write SetFilledFrameColor;
    property FilledColor: TColor read FFilledColor write SetFilledColor;
    property FilledSideColor1: TColor read FFilledSideColor1 write SetFilledSideColor1;
    property FilledSideColor2: TColor read FFilledSideColor2 write SetFilledSideColor2;
  end;

function NewTRarInfoBar(AOwner: PControl): PRarBar;

implementation

function NewTRarInfoBar;
var P: PRarBar;
    C: PControl;
begin
  C:=pointer(_NewControl(AOwner,'STATIC',WS_VISIBLE or WS_CHILD or SS_LEFTNOWORDWRAP or SS_NOPREFIX or SS_NOTIFY,False,nil));
  C.CreateWindow;
  New(P,Create);
  AOwner.Add2AutoFree(P);
  AOwner.Add2AutoFree(C);
  P.FControl:=C;
  P.FFont:=NewFont;
  P.FFont.Color:=clPurple;
  P.FFont.FontHeight:=-11;
  P.FFont.FontName:=C.Font.FontName;
  P.FFont.FontStyle:=[fsBold];
  P.FLineColor:=$FFE0E0;
  P.FTopColor:=$FF8080;
  P.FSideColor1:=$E06868;
  P.FSideColor2:=$FF8080;
  P.FEmptyFrameColor1:=$A06868;
  P.FEmptyFrameColor2:=$BF8080;
  P.FEmptyColor1:=$C06868;
  P.FEmptyColor2:=$DF8080;
  P.FBottomFrameColor:=$64408C;
  P.FBottomColor:=$7A408C;
  P.FFilledFrameColor:=$8060A0;
  P.FFilledSideColor1:=$823C96;
  P.FFilledSideColor2:=$8848C0;
  P.FFilledColor:=$A060A0;
  P.FShowPerc:=True;
  P.FMin:=0;
  P.FMax:=100;
  P.FPosition:=0;
  C.SetSize(70,180);
  Result:=P;
  P.OldWind:=GetWindowLong(C.Handle,GWL_WNDPROC);
  P.NewWind:=integer(MakeObjectInstance(P.NewWndProc));
  SetWindowLong(C.Handle,GWL_WNDPROC,P.NewWind);
end;

destructor TRarBar.Destroy;
begin
  SetWindowLong(FControl.Handle,GWL_WNDPROC,OldWind);
  FreeObjectInstance(Pointer(NewWind));
  inherited;
end;

function TRarBar.SetPosition(X,Y: integer): PRarBar;
begin
  FControl.Left:=X;
  FControl.Top:=Y;
  Result:=@Self;
end;

function TRarBar.SetSize(X,Y: integer): PRarBar;
begin
  FControl.Width:=X;
  FControl.Height:=Y;
  Result:=@Self;
end;

function TRarBar.SetAlign(A: TControlAlign): PRarBar;
begin
  FControl.Align:=A;
  Result:=@Self;
end;

procedure TRarBar.NewWndProc;
begin
  Msg.Result:=CallWindowProc(Pointer(OldWind),FControl.Handle,Msg.Msg,Msg.wParam,Msg.lParam);
  case Msg.Msg of
    WM_PAINT   : Paint;
    WM_SIZE    : Paint;
    WM_ACTIVATE: Paint;
  end;
end;

procedure TRarBar.SetFont(F: PGraphicTool);
begin
  FFont.Assign(F);
  Paint;
end;

procedure TRarBar.SetMin;
begin
  if M>FMax then M:=FMax;
  FMin:=M;
  Paint;
end;

procedure TRarBar.SetMax;
begin
  if M<FMin then M:=FMin;
  FMax:=M;
  Paint;
end;

procedure TRarBar.SetPos;
begin
  if P>FMax then P:=FMax;
  FPosition:=P;
  Paint;
end;

procedure TRarBar.SetLineColor;
begin
  FLineColor:=C;
  Paint;
end;

procedure TRarBar.SetTopColor;
begin
  FTopColor:=C;
  Paint;
end;

procedure TRarBar.SetSideColor1;
begin
  FSideColor1:=C;
  Paint;
end;

procedure TRarBar.SetSideColor2;
begin
  FSideColor2:=C;
  Paint;
end;

procedure TRarBar.SetEmptyColor1;
begin
  FEmptyColor1:=C;
  Paint;
end;

procedure TRarBar.SetEmptyColor2;
begin
  FEmptyColor2:=C;
  Paint;
end;

procedure TRarBar.SetEmptyFrameColor1;
begin
  FEmptyFrameColor1:=C;
  Paint;
end;

procedure TRarBar.SetEmptyFrameColor2;
begin
  FEmptyFrameColor2:=C;
  Paint;
end;

procedure TRarBar.SetBottomFrameColor;
begin
  FBottomFrameColor:=C;
  Paint;
end;

procedure TRarBar.SetBottomColor;
begin
  FBottomColor:=C;
  Paint;
end;

procedure TRarBar.SetFilledFrameColor;
begin
  FFilledFrameColor:=C;
  Paint;
end;

procedure TRarBar.SetFilledColor;
begin
  FFilledColor:=C;
  Paint;
end;

procedure TRarBar.SetFilledSideColor1;
begin
  FFilledSideColor1:=C;
  Paint;
end;

procedure TRarBar.SetFilledSideColor2;
begin
  FFilledSideColor2:=C;
  Paint;
end;

procedure TRarBar.SetShowPerc;
begin
  FShowPerc:=V;
  Paint;
end;

procedure TRarBar.Paint;
  procedure DrawFrame(C: PCanvas);
  var PP: TPoint;
  begin
    C.Pen.Color:=FLineColor;
    C.Pen.PenWidth:=1;
    C.Pen.PenStyle:=psSolid;
    C.Pen.PenMode:=pmCopy;

    C.MoveTo(TopX,TopY+5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X+15,PP.Y-5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X+15,PP.Y+5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X-15,PP.Y+5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X-15,PP.Y-5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X,PP.Y+(Size-10));
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X+15,PP.Y+5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X,PP.Y-(Size-10));
    GetCurrentPositionEx(C.Handle,@PP);

    C.MoveTo(PP.X,PP.Y+(Size-10));
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X+15,PP.Y-5);
    GetCurrentPositionEx(C.Handle,@PP);

    C.LineTo(PP.X,PP.Y-(Size-10));
  end;

var Points: array[1..4] of TPoint;
    Prog,Perc: integer;
    R: real;
    S: string;
    PP: TPoint;
begin
  TopX:=0;
  TopY:=5;
  Size:=FControl.Height-TopY-5;
  if (Size=0) or ((FMax-FMin)=0) then
    begin
      Perc:=0;
      Prog:=0;
    end
  else
    begin
      R:=(FPosition-FMin)/((FMax-FMin)/(Size-10));
      Prog:=Round(R);
      Perc:=Round(R/((Size-10)/100));
    end;
  if Prog<0 then Prog:=0 else
    if Prog>Size-10 then Prog:=Size-10;
  FControl.Canvas.Brush.Color:=FControl.Color;
  FControl.Canvas.FillRect(FControl.Canvas.ClipRect);
  DrawFrame(FControl.Canvas);
  FControl.Canvas.Brush.Color:=FTopColor;
  FControl.Canvas.FloodFill(TopX+7,TopY+5,FControl.Canvas.Pixels[TopX+(15 div 2),TopY+5],fsSurface);
  FControl.Canvas.Brush.Color:=FSideColor1;
  FControl.Canvas.FloodFill(TopX+1,TopY+6,FControl.Canvas.Pixels[TopX+1,TopY+6],fsSurface);
  FControl.Canvas.Brush.Color:=FSideColor2;
  FControl.Canvas.FloodFill(TopX+29,TopY+6,FControl.Canvas.Pixels[TopX+29,TopY+6],fsSurface);
  if Prog>0 then
    begin
      FControl.Canvas.MoveTo(TopX,TopY+Size-5);
      GetCurrentPositionEx(FControl.Canvas.Handle,@PP);

      FControl.Canvas.Pen.Color:=FBottomFrameColor;

      FControl.Canvas.LineTo(PP.X+15,PP.Y-5);
      GetCurrentPositionEx(FControl.Canvas.Handle,@PP);

      FControl.Canvas.LineTo(PP.X+15,PP.Y+5);
      GetCurrentPositionEx(FControl.Canvas.Handle,@PP);

      FControl.Canvas.Brush.Color:=FBottomColor;
      FControl.Canvas.FloodFill(TopX+7,TopY+Size-5,FSideColor1,fsSurface);
      FControl.Canvas.FloodFill(TopX+22,TopY+Size-5,FSideColor2,fsSurface);
      FControl.Canvas.Brush.Color:=FFilledColor;
      FControl.Canvas.Pen.Color:=FFilledFrameColor;
      Points[1]:=MakePoint(TopX+15,TopY+Size-Prog);
      Points[2]:=MakePoint(TopX,TopY+Size-Prog-5);
      Points[3]:=MakePoint(TopX+15,TopY+Size-Prog-10);
      Points[4]:=MakePoint(TopX+30,TopY+Size-Prog-5);
      FControl.Canvas.Polygon(Points);
      FControl.Canvas.Brush.Color:=FFilledSideColor1;
      FControl.Canvas.FloodFill(TopX+1,TopY+Size-5-(Prog div 2),FSideColor1,fsSurface);
      FControl.Canvas.Brush.Color:=FFilledSideColor2;
      FControl.Canvas.FloodFill(TopX+29,TopY+Size-5-(Prog div 2),FSideColor2,fsSurface);
      DrawFrame(FControl.Canvas);
    end
  else
    begin
      {EMPTY}
      FControl.Canvas.MoveTo(TopX,TopY+Size-5);
      GetCurrentPositionEx(FControl.Canvas.Handle,@PP);

      FControl.Canvas.Pen.Color:=FEmptyFrameColor1;

      FControl.Canvas.LineTo(PP.X+15,PP.Y-5);
      GetCurrentPositionEx(FControl.Canvas.Handle,@PP);

      FControl.Canvas.Pen.Color:=FEmptyFrameColor2;

      FControl.Canvas.LineTo(PP.X+15,PP.Y+5);
      GetCurrentPositionEx(FControl.Canvas.Handle,@PP);

      DrawFrame(FControl.Canvas);
      FControl.Canvas.Brush.Color:=FEmptyColor1;
      FControl.Canvas.FloodFill(TopX+7,TopY+Size-5,FSideColor1,fsSurface);
      FControl.Canvas.Brush.Color:=FEmptyColor2;
      FControl.Canvas.FloodFill(TopX+22,TopY+Size-5,FSideColor2,fsSurface);
    end;
  if FShowPerc then
    begin
      FControl.Canvas.Brush.Color:=FControl.Color;
      FControl.Canvas.Font.Assign(FFont);
      S:=Int2Str(Perc)+' %';
      FControl.Canvas.TextOut(TopX+33,TopY+Size-Prog-FControl.Canvas.TextHeight(S),S);
    end;
end;

end.

