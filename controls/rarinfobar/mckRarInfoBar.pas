unit mckRarInfoBar;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
     ComCtrls, ExtCtrls, Mirror;

const
  Boolean2Str: array [Boolean] of string = ('False','True');

type
  TRarInfoBar = class(TKOLControl)
  private
    { Private declarations }
    FPosition: integer;
    FMin,FMax: integer;
    FShowPerc: boolean;

    FLineColor,FTopColor,FSideColor1,FSideColor2,FEmptyColor1,FEmptyColor2,
    FEmptyFrameColor1,FEmptyFrameColor2,FBottomFrameColor,FBottomColor,
    FFilledFrameColor,FFilledColor,FFilledSideColor1,FFilledSideColor2: TColor;

    TopX,TopY,Size: integer;

    function  AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent,Prefix: string); override;
    procedure SetPos(P: integer);
    procedure SetMin(M: integer);
    procedure SetMax(M: integer);
    procedure SetShowPerc(V: boolean);

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
  protected
    { Protected declarations }
    procedure Paint;
    procedure WMPaint(var Msg: TMessage); message WM_PAINT;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure WMActiv(var Msg: TMessage); message WM_SHOWWINDOW;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  published
    { Published declarations }
    property Position: integer read FPosition write SetPos;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property ShowPercent: boolean read FShowPerc write SetShowPerc;

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

procedure Register;

implementation

{$R mckRarInfoBar.dcr}

procedure Register;
begin
  RegisterComponents('KOL', [TRarInfoBar]);
end;

constructor TRarInfoBar.Create;
begin
  inherited;
  Width:=70;
  Height:=180;
  FMin:=0;
  FMax:=100;
  FPosition:=0;
  FLineColor:=$FFE0E0;
  FTopColor:=$FF8080;
  FSideColor1:=$E06868;
  FSideColor2:=$FF8080;
  FEmptyFrameColor1:=$A06868;
  FEmptyFrameColor2:=$BF8080;
  FEmptyColor1:=$C06868;
  FEmptyColor2:=$DF8080;
  FBottomFrameColor:=$64408C;
  FBottomColor:=$7A408C;
  FFilledFrameColor:=$8060A0;
  FFilledSideColor1:=$823C96;
  FFilledSideColor2:=$8848C0;
  FFilledColor:=$A060A0;
  FShowPerc:=True;
  Font.FontStyle:=[fsBold];
  Font.Color:=clPurple;
end;

procedure TRarInfoBar.WMPaint;
begin
  inherited;
  Paint;
end;

procedure TRarInfoBar.WMSize;
begin
  inherited;
  Paint;
end;

procedure TRarInfoBar.WMActiv;
begin
  inherited;
  Paint;
end;

function TRarInfoBar.AdditionalUnits;
begin
  Result:=', KOLRarBar';
end;

procedure TRarInfoBar.SetupFirst;
begin
  inherited;
  SL.Add(Prefix+AName+'.Position := '+IntToStr(FPosition)+';');
  SL.Add(Prefix+AName+'.Min := '+IntToStr(FMin)+';');
  SL.Add(Prefix+AName+'.Max := '+IntToStr(FMax)+';');
  SL.Add(Prefix+AName+'.ShowPercent := '+Boolean2Str[FShowPerc]+';');
  SL.Add(Prefix+AName+'.LineColor := '+Color2Str(FLineColor)+';');
  SL.Add(Prefix+AName+'.TopColor := '+Color2Str(FTopColor)+';');
  SL.Add(Prefix+AName+'.SideColor1 := '+Color2Str(FSideColor1)+';');
  SL.Add(Prefix+AName+'.SideColor2 := '+Color2Str(FSideColor2)+';');
  SL.Add(Prefix+AName+'.EmptyFrameColor1 := '+Color2Str(FEmptyFrameColor1)+';');
  SL.Add(Prefix+AName+'.EmptyFrameColor2 := '+Color2Str(FEmptyFrameColor2)+';');
  SL.Add(Prefix+AName+'.EmptyColor1 := '+Color2Str(FEmptyColor1)+';');
  SL.Add(Prefix+AName+'.EmptyColor2 := '+Color2Str(FEmptyColor2)+';');
  SL.Add(Prefix+AName+'.BottomFrameColor := '+Color2Str(FBottomFrameColor)+';');
  SL.Add(Prefix+AName+'.BottomColor := '+Color2Str(FBottomColor)+';');
  SL.Add(Prefix+AName+'.FilledFrameColor := '+Color2Str(FFilledFrameColor)+';');
  SL.Add(Prefix+AName+'.FilledSideColor1 := '+Color2Str(FFilledSideColor1)+';');
  SL.Add(Prefix+AName+'.FilledSideColor2 := '+Color2Str(FFilledSideColor2)+';');
  SL.Add(Prefix+AName+'.FilledColor := '+Color2Str(FFilledColor)+';');
end;

procedure TRarInfoBar.SetPos;
begin
  if P>FMax then P:=FMax;
  FPosition:=P;
  Paint;
end;

procedure TRarInfoBar.SetMin;
begin
  if M>FMax then M:=FMax;
  FMin:=M;
  Paint;
end;

procedure TRarInfoBar.SetMax;
begin
  if M<FMin then M:=FMin;
  FMax:=M;
  Paint;
end;

procedure TRarInfoBar.SetLineColor;
begin
  FLineColor:=C;
  Paint;
end;

procedure TRarInfoBar.SetTopColor;
begin
  FTopColor:=C;
  Paint;
end;

procedure TRarInfoBar.SetSideColor1;
begin
  FSideColor1:=C;
  Paint;
end;

procedure TRarInfoBar.SetSideColor2;
begin
  FSideColor2:=C;
  Paint;
end;

procedure TRarInfoBar.SetEmptyColor1;
begin
  FEmptyColor1:=C;
  Paint;
end;

procedure TRarInfoBar.SetEmptyColor2;
begin
  FEmptyColor2:=C;
  Paint;
end;

procedure TRarInfoBar.SetEmptyFrameColor1;
begin
  FEmptyFrameColor1:=C;
  Paint;
end;

procedure TRarInfoBar.SetEmptyFrameColor2;
begin
  FEmptyFrameColor2:=C;
  Paint;
end;

procedure TRarInfoBar.SetBottomFrameColor;
begin
  FBottomFrameColor:=C;
  Paint;
end;

procedure TRarInfoBar.SetBottomColor;
begin
  FBottomColor:=C;
  Paint;
end;

procedure TRarInfoBar.SetFilledFrameColor;
begin
  FFilledFrameColor:=C;
  Paint;
end;

procedure TRarInfoBar.SetFilledColor;
begin
  FFilledColor:=C;
  Paint;
end;

procedure TRarInfoBar.SetFilledSideColor1;
begin
  FFilledSideColor1:=C;
  Paint;
end;

procedure TRarInfoBar.SetFilledSideColor2;
begin
  FFilledSideColor2:=C;
  Paint;
end;

procedure TRarInfoBar.SetShowPerc;
begin
  FShowPerc:=V;
  Paint;
end;

procedure TRarInfoBar.Paint;
  procedure DrawFrame(C: TCanvas);
  begin
    C.Pen.Color:=FLineColor;
    C.Pen.Width:=1;
    C.Pen.Style:=psSolid;
    C.Pen.Mode:=pmCopy;
    C.MoveTo(TopX,TopY+5);
    C.LineTo(C.PenPos.X+15,C.PenPos.Y-5);
    C.LineTo(C.PenPos.X+15,C.PenPos.Y+5);
    C.LineTo(C.PenPos.X-15,C.PenPos.Y+5);
    C.LineTo(C.PenPos.X-15,C.PenPos.Y-5);
    C.LineTo(C.PenPos.X,C.PenPos.Y+(Size-10));
    C.LineTo(C.PenPos.X+15,C.PenPos.Y+5);
    C.LineTo(C.PenPos.X,C.PenPos.Y-(Size-10));
    C.MoveTo(C.PenPos.X,C.PenPos.Y+(Size-10));
    C.LineTo(C.PenPos.X+15,C.PenPos.Y-5);
    C.LineTo(C.PenPos.X,C.PenPos.Y-(Size-10));
  end;

var Points: array[1..4] of TPoint;
    Prog,Perc: integer;
    R: real;
    S: string;
begin
  TopX:=0;
  TopY:=5;
  Size:=Height-TopY-5;
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
  Canvas.Brush.Color:=Color;
  Canvas.FillRect(Canvas.ClipRect);
  DrawFrame(Canvas);
  Canvas.Brush.Color:=FTopColor;
  Canvas.FloodFill(TopX+7,TopY+5,Canvas.Pixels[TopX+(15 div 2),TopY+5],fsSurface);
  Canvas.Brush.Color:=FSideColor1;
  Canvas.FloodFill(TopX+1,TopY+6,Canvas.Pixels[TopX+1,TopY+6],fsSurface);
  Canvas.Brush.Color:=FSideColor2;
  Canvas.FloodFill(TopX+29,TopY+6,Canvas.Pixels[TopX+29,TopY+6],fsSurface);
  if Prog>0 then
    begin
      Canvas.MoveTo(TopX,TopY+Size-5);
      Canvas.Pen.Color:=FBottomFrameColor;
      Canvas.LineTo(Canvas.PenPos.X+15,Canvas.PenPos.Y-5);
      Canvas.LineTo(Canvas.PenPos.X+15,Canvas.PenPos.Y+5);
      Canvas.Brush.Color:=FBottomColor;
      Canvas.FloodFill(TopX+7,TopY+Size-5,FSideColor1,fsSurface);
      Canvas.FloodFill(TopX+22,TopY+Size-5,FSideColor2,fsSurface);
      Canvas.Brush.Color:=FFilledColor;
      Canvas.Pen.Color:=FFilledFrameColor;
      Points[1]:=Point(TopX+15,TopY+Size-Prog);
      Points[2]:=Point(TopX,TopY+Size-Prog-5);
      Points[3]:=Point(TopX+15,TopY+Size-Prog-10);
      Points[4]:=Point(TopX+30,TopY+Size-Prog-5);
      Canvas.Polygon(Points);
      Canvas.Brush.Color:=FFilledSideColor1;
      Canvas.FloodFill(TopX+1,TopY+Size-5-(Prog div 2),FSideColor1,fsSurface);
      Canvas.Brush.Color:=FFilledSideColor2;
      Canvas.FloodFill(TopX+29,TopY+Size-5-(Prog div 2),FSideColor2,fsSurface);
      DrawFrame(Canvas);
    end
  else
    begin
      {EMPTY}
      Canvas.MoveTo(TopX,TopY+Size-5);
      Canvas.Pen.Color:=FEmptyFrameColor1;
      Canvas.LineTo(Canvas.PenPos.X+15,Canvas.PenPos.Y-5);
      Canvas.Pen.Color:=FEmptyFrameColor2;
      Canvas.LineTo(Canvas.PenPos.X+15,Canvas.PenPos.Y+5);
      DrawFrame(Canvas);
      Canvas.Brush.Color:=FEmptyColor1;
      Canvas.FloodFill(TopX+7,TopY+Size-5,FSideColor1,fsSurface);
      Canvas.Brush.Color:=FEmptyColor2;
      Canvas.FloodFill(TopX+22,TopY+Size-5,FSideColor2,fsSurface);
    end;
  if FShowPerc then
    begin
      Canvas.Font.Name:=Font.FontName;
      Canvas.Font.Height:=Font.FontHeight;
      Canvas.Font.Color:=Font.Color;
      Canvas.Font.Style:=Font.FontStyle;
      Canvas.Brush.Color:=Color;
      S:=IntToStr(Perc)+' %';
      Canvas.TextOut(TopX+33,TopY+Size-Prog-Canvas.TextHeight(S),S);
    end;
end;

end.

