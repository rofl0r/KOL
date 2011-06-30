unit KOLjanFX;

{ original release 2-july-2000

  janFX is written by Jan Verhoeven
  most routines are written by myself,
  some are extracted from freeware sources on the internet

  to use this library add it to your library path
  with Tools - Environment Options - Library path

  in your application you just call the routines
  for clarity and convenience you might preceed them with janFX like:

  janFX.Button(Src,depth,weight);

  this library is the updated succesor of my TjanPaintFX component
  }

///////////////////////////////////////////////////////////////////////////////
//
//      Converted to KOL by Dimaxx (dimaxx@atnet.ru)
//
///////////////////////////////////////////////////////////////////////////////

interface

{$DEFINE USE_SCANLINE}

uses Windows, Kol, KolMath, Err;

type
  TRim = (trRimmed,trRound,trDoubleRound);

  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of byte;

  // Type of a filter for use with Stretch()

  TFilterProc = function(Value: single): single;
  TLightBrush = (lbBrightness,lbContrast,lbSaturation,lbFishEye,lbRotate,
                 lbTwist,lbRimple,lbHor,lbTop,lbBottom,lbDiamond,lbWaste,
                 lbRound,lbRound2,lbSplitRound,lbSplitWaste);
  // For scanline simplification
  TRGBArray = array[0..32767] of TRGBTriple;
  PRGBArray = ^TRGBArray;

  function ConvertColor(Value: integer): TColor;
  function Set255(Clr: integer): integer;
  function TrimInt(I,Min,Max: integer): integer;

  // Sample filters for use with Stretch()

  function SplineFilter(Value: single): single;
  function BellFilter(Value: single): single;
  function TriangleFilter(Value: single): single;
  function BoxFilter(Value: single): single;
  function HermiteFilter(Value: single): single;
  function Lanczos3Filter(Value: single): single;
  function MitchellFilter(Value: single): single;

const
  MaxPixelCount = 32768;

// -----------------------------------------------------------------------------
//
//			List of Filters
//
// -----------------------------------------------------------------------------

  ResampleFilters: array[0..6] of record
    Name: string;	  // Filter name
    Filter: TFilterProc;  // Filter implementation
    Width: single;	  // Suggested sampling width/radius
  end = (
    (Name: 'Box';	Filter: BoxFilter;	Width: 0.5),
    (Name: 'Triangle';	Filter: TriangleFilter;	Width: 1.0),
    (Name: 'Hermite';	Filter: HermiteFilter;	Width: 1.0),
    (Name: 'Bell';	Filter: BellFilter;	Width: 1.5),
    (Name: 'B-Spline';	Filter: SplineFilter;	Width: 2.0),
    (Name: 'Lanczos3';	Filter: Lanczos3Filter;	Width: 3.0),
    (Name: 'Mitchell';	Filter: MitchellFilter;	Width: 2.0));

  procedure AddColorNoise(var Clip: PBitmap; Amount: integer);
  procedure AddMonoNoise(var Clip: PBitmap; Amount: integer);
  procedure AntiAliasRect(var Clip: PBitmap; XOrigin,YOrigin,XFinal,YFinal: integer);
  procedure AntiAlias(var Clip: PBitmap);
  procedure Contrast(var Clip: PBitmap; Amount: integer);
  procedure FishEye(var Bmp,Dst: PBitmap; Amount: extended);
  procedure SplitBlur(var Clip: PBitmap; Amount: integer);
  procedure GaussianBlur(var Clip: PBitmap; Amount: integer);
  procedure GrayScale(var Clip: PBitmap);
  procedure Lightness(var Clip: PBitmap; Amount: integer);
  procedure Darkness(var Src: PBitmap; Amount: integer);
  procedure Marble(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble2(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble3(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble4(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble5(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble6(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble7(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Marble8(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
  procedure Saturation(var Clip: PBitmap; Amount: integer);
  procedure SmoothPoint(var Clip: PBitmap; XK,YK: integer);
  procedure SmoothResize(var Src,Dst: PBitmap);
  procedure SmoothRotate(var Src,Dst: PBitmap; CX,CY: integer; Angle: extended);
  procedure Spray(var Clip: PBitmap; Amount: integer);
  procedure Mosaic(var Clip: PBitmap; Size: integer);
  procedure Twist(var Bmp,Dst: PBitmap; Amount: integer);
  procedure Wave(var Clip: PBitmap; Amount,Inference,Style: integer);
  procedure MakeSeamlessClip(var Clip: PBitmap; Seam: integer);
  procedure SplitLight(var Clip: PBitmap; Amount: integer);
  procedure SqueezeHor(var Src,Dst: PBitmap; Amount: integer; Style: TLightBrush);
  procedure Tile(var Src,Dst: PBitmap; Amount: integer);
  procedure Strecth(var Src,Dst: PBitmap; Filter: TFilterProc; FWidth: single);
  procedure Grow(var Src1,Src2,Dst: PBitmap; Amount: extended; X,Y: integer);
  procedure SpotLight(var Src: PBitmap; Amount: integer; Spot: TRect);
  procedure FlipHorz(var Src: PBitmap);
  procedure FlipVert(var Src: PBitmap);
  procedure Trace(var Src: PBitmap; Intensity: integer);
  procedure ShadowUpLeft(var Src: PBitmap);
  procedure ShadowUpRight(var Src: PBitmap);
  procedure ShadowDownLeft(var Src: PBitmap);
  procedure ShadowDownRight(var Src: PBitmap);
  procedure SemiOpaque(var Src,Dst: PBitmap);
  procedure QuartoOpaque(var Src,Dst: PBitmap);
  procedure FoldRight(var Src1,Src2,Dst: PBitmap; Amount: extended);
  procedure KeepBlue(var Src: PBitmap; Factor: extended);
  procedure KeepGreen(var Src: PBitmap; Factor: extended);
  procedure KeepRed(var Src: PBitmap; Factor: extended);
  procedure ShakeVert(var Src,Dst: PBitmap; Factor: extended);
  procedure ShakeHorz(var Src,Dst: PBitmap; Factor: extended);
  procedure Plasma(var Src1,Src2,Dst: PBitmap; Scale,Turbulence: extended);
  procedure Emboss(var BMP: PBitmap);
  procedure FilterRed(var Src: PBitmap; Min,Max: byte);
  procedure FilterGreen(var Src: PBitmap; Min,Max: byte);
  procedure FilterBlue(var Src: PBitmap; Min,Max: byte);
  procedure FilterXRed(var Src: PBitmap; Min,Max: byte);
  procedure FilterXGreen(var Src: PBitmap; Min,Max: byte);
  procedure FilterXBlue(var Src: PBitmap; Min,Max: byte);
  procedure Invert(var Src: PBitmap);  procedure MirrorVert(var Src: PBitmap);
  procedure MirrorHorz(var Src: PBitmap);
  procedure Triangles(var Src: PBitmap; Amount: integer);
  procedure RippleTooth(var Src: PBitmap; Amount: integer);
  procedure RippleTriangle(var Src: PBitmap; Amount: integer);
  procedure RippleRandom(var Src: PBitmap; Amount: integer);
  procedure TexturizeOverlap(var Src: PBitmap; Amount: integer);
  procedure TexturizeTile(var Src: PBitmap; Amount: integer);
  procedure HeightMap(var Src: PBitmap; Amount: integer);
  procedure ExtractColor(var Src: PBitmap; Acolor: TColor);
  procedure ExcludeColor(var Src: PBitmap; Acolor: TColor);
  procedure Blend(var Src1,Src2,Dst: PBitmap; Amount: extended);
  procedure Solarize(var Src,Dst: PBitmap; Amount: integer);
  procedure Posterize(var Src,Dst: PBitmap; Amount: integer);
  procedure ConvolveE(Ray: array of integer; Z: word; var aBmp: PBitmap);
  procedure ConvolveI(Ray: array of integer; Z: word; var aBmp: PBitmap);
  procedure ConvolveM(Ray: array of integer; Z: word; var aBmp: PBitmap);
  procedure Seamless(var Src: PBitmap; Depth: byte);
  procedure Button(var Src: PBitmap; Depth: byte; Weight: integer);
  procedure ConvolveFilter(var Src: PBitmap; Filternr,Edgenr: integer);
  procedure ButtonOval(var Src: PBitmap; Depth: byte; Weight: integer; Rim: TRim);
  procedure MaskOval(var Src: PBitmap; AColor: TColor);

implementation

type
  TRGBTripleArray = array[0..pred(MaxPixelCount)] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;
  TFColor = record
    B,G,R: byte;
  end;

function Rect(ALeft,ATop,ARight,ABottom: integer): TRect;
begin
  with Result do
  begin
    Left:=ALeft;
    Top:=ATop;
    Right:=ARight;
    Bottom:=ABottom;
  end;
end;

// Bell filter
function BellFilter(Value: single): single;
begin
 if (Value<0.0) then Value:=-Value;
  if (Value<0.5) then Result:=0.75-Sqr(Value) else
     if (Value<1.5) then
       begin
         Value:=Value-1.5;
         Result:=0.5*Sqr(Value);
       end
     else Result:=0.0;
end;

// Box filter
// a.k.a. "Nearest Neighbour" filter
// anme: I have not been able to get acceptable
//       results with this filter for subsampling.

function BoxFilter(Value: single): single;
begin
  if (Value>-0.5) and (Value<=0.5) then Result:=1.0 else Result:=0.0;
end;

// Hermite filter
function HermiteFilter(Value: single): single;
begin
  // f(t) = 2|t|^3 - 3|t|^2 + 1, -1 <= t <= 1
  if Value<0.0 then Value:=-Value;
  if Value<1.0 then Result:=(2.0*Value-3.0)*Sqr(Value)+1.0 else Result:=0.0;
end;

// Lanczos3 filter
function Lanczos3Filter(Value: single): single;
  function SinC(Value: single): single;
  begin
    if Value<>0.0 then
      begin
        Value:=Value*Pi;
        Result:=Sin(Value)/Value;
      end
    else Result:=1.0;
  end;
begin
  if (Value<0.0) then Value:=-Value;
  if (Value<3.0) then Result:=SinC(Value)*SinC(Value/3.0) else Result:=0.0;
end;

function MitchellFilter(Value: single): single;
const
  B=(1.0/3.0);
  C=(1.0/3.0);
var TT: single;
begin
  if (Value<0.0) then Value:=-Value;
  TT:=Sqr(Value);
  if (Value<1.0) then
    begin
      Value:=(((12.0-9.0*B-6.0*C)*(Value*TT))+((-18.0+12.0*B+6.0*C)*TT)+(6.0-2*B));
      Result:=Value/6.0;
    end
  else if (Value<2.0) then
    begin
      Value:=(((-1.0*B-6.0*C)*(Value*TT))+((6.0*B+30.0*C)*TT)+((-12.0*B-48.0*C)*Value)+(8.0*B+24*C));
      Result:=Value/6.0;
    end
  else Result:=0.0;
end;

// B-spline filter
function SplineFilter(Value: single): single;
var TT: single;
begin
  if (Value<0.0) then Value:=-Value;
  if (Value<1.0) then
    begin
      TT:=Sqr(Value);
      Result:=0.5*TT*Value-TT+2.0/3.0;
    end
  else if (Value<2.0) then
    begin
      Value:=2.0-Value;
      Result:=1.0/6.0*Sqr(Value)*Value;
    end
  else Result:=0.0;
end;

// Triangle filter
// a.k.a. "Linear" or "Bilinear" filter
function TriangleFilter(Value: single): single;
begin
  if (Value<0.0) then Value:=-Value;
  if (Value<1.0) then Result:=1.0-Value else Result:=0.0;
end;

function Int2Byte(I: integer): byte;
begin
  if I>255 then Result:=255 else
    if I<0 then Result:=0 else Result:=I;
end;

procedure AddColorNoise(var Clip: PBitmap; Amount: integer);
var P0: PByteArray;
    X,Y,R,G,B: integer;
begin
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      for X:=0 to pred(Clip.Width) do
        begin
          R:=P0[X*3]+(Random(Amount)-(Amount shr 1));
          G:=P0[X*3+1]+(Random(Amount)-(Amount shr 1));
          B:=P0[X*3+2]+(Random(Amount)-(Amount shr 1));
          P0[X*3]:=Int2Byte(R);
          P0[X*3+1]:=Int2Byte(G);
          P0[X*3+2]:=Int2Byte(B);
        end;
    end;
end;

procedure AddMonoNoise(var Clip: PBitmap; Amount: integer);
var P0: PByteArray;
    X,Y,A,R,G,B: integer;
begin
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      for X:=0 to pred(Clip.Width) do
        begin
          A:=Random(Amount)-(Amount shr 1);
          R:=P0[X*3]+A;
          G:=P0[X*3+1]+A;
          B:=P0[X*3+2]+A;
          P0[X*3]:=Int2Byte(R);
          P0[X*3+1]:=Int2Byte(G);
          P0[X*3+2]:=Int2Byte(B);
        end;
    end;
end;

procedure AntiAliasRect(var Clip: PBitmap; XOrigin,YOrigin,XFinal,YFinal: integer);
var Memo,X,Y: integer; (* Composantes primaires des points environnants *)
    P0,P1,P2: PByteArray;
begin
   if XFinal<XOrigin then
     begin
       Memo:=XOrigin;
       XOrigin:=XFinal;
       XFinal:=Memo;
     end;  (* Inversion des valeurs   *)
   if YFinal<YOrigin then
     begin
       Memo:=YOrigin;
       YOrigin:=YFinal;
       YFinal:=Memo;
     end;  (* si diff‚rence n‚gative*)
   XOrigin:=Max(1,XOrigin);
   YOrigin:=Max(1,YOrigin);
   XFinal:=Min(Clip.Width-2,XFinal);
   YFinal:=Min(Clip.Height-2,YFinal);
   Clip.PixelFormat:=pf24bit;
   for Y:=YOrigin to YFinal do
     begin
       P0:=Clip.ScanLine[Y-1];
       P1:=Clip.ScanLine[Y];
       P2:=Clip.ScanLine[Y+1];
       for X:=XOrigin to XFinal do
         begin
           P1[X*3]:=(P0[X*3]+P2[X*3]+P1[(X-1)*3]+P1[(x+1)*3]) div 4;
           P1[X*3+1]:=(P0[X*3+1]+P2[X*3+1]+P1[(X-1)*3+1]+P1[(X+1)*3+1]) div 4;
           P1[X*3+2]:=(P0[X*3+2]+P2[X*3+2]+P1[(X-1)*3+2]+P1[(X+1)*3+2]) div 4;
         end;
     end;
end;

procedure AntiAlias(var Clip: PBitmap);
begin
  AntiAliasRect(Clip,0,0,Clip.Width,Clip.Height);
end;

procedure Contrast(var Clip: PBitmap; Amount: integer);
var P0: PByteArray;
    RG,GG,BG,R,G,B,X,Y: integer;
begin
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      for X:=0 to pred(Clip.Width) do
        begin
          R:=P0[X*3];
          G:=P0[X*3+1];
          B:=P0[X*3+2];
          RG:=(Abs(127-R)*Amount) div 255;
          GG:=(Abs(127-G)*Amount) div 255;
          BG:=(Abs(127-B)*Amount) div 255;
          if R>127 then R:=R+RG else R:=R-RG;
          if G>127 then G:=G+GG else G:=G-GG;
          if B>127 then B:=B+BG else B:=B-BG;
          P0[X*3]:=Int2Byte(R);
          P0[X*3+1]:=Int2Byte(G);
          P0[X*3+2]:=Int2Byte(B);
        end;
    end;
end;

procedure FishEye(var Bmp,Dst: PBitmap; Amount: extended);
var XMID,YMID: single;
    FX,FY: single;
    R1,R2: single;
    IFX,IFY: integer;
    DX,DY: single;
    RMAX: single;
    TY,TX: integer;
    Weight_X,Weight_Y: array [0..1] of single;
    Weight: single;
    New_Red,New_Green,New_Blue: integer;
    Total_Red,Total_Green,Total_Blue: single;
    IX,IY: integer;
    SLI,SLO: PByteArray;
begin
  XMID:=Bmp.Width/2;
  YMID:=Bmp.Height/2;
  RMAX:=Dst.Width*Amount;
  for TY:=0 to pred(Dst.Height) do
    begin
      for TX:=0 to pred(Dst.Width) do
        begin
          DX:=TX-XMID;
          DY:=TY-YMID;
          R1:=Sqrt(DX*DX+DY*DY);
          if R1=0 then
            begin
              FX:=XMID;
              FY:=YMID;
            end
          else
            begin
              R2:=RMAX/2*(1/(1-R1/RMAX)-1);
              FX:=DX*R2/R1+XMID;
              FY:=DY*R2/R1+YMID;
            end;
          IFY:=Trunc(FY);
          IFX:=Trunc(FX);
          // Calculate the weights
          if FY>=0 then
            begin
              Weight_Y[1]:=FY-IFY;
              Weight_Y[0]:=1-Weight_Y[1];
            end
          else
            begin
              Weight_Y[0]:=-(FY-IFY);
              Weight_Y[1]:=1-Weight_Y[0];
            end;
          if FX>=0 then
            begin
              Weight_X[1]:=FX-IFX;
              Weight_X[0]:=1-Weight_X[1];
            end
          else
            begin
             Weight_X[0]:=-(FX-IFX);
             Weight_X[1]:=1-Weight_X[0];
            end;
          if IFX<0 then IFX:=Bmp.Width-1-(-IFX mod Bmp.Width) else
            if IFX>Bmp.Width-1 then IFX:=IFX mod Bmp.Width;
          if IFY<0 then IFY:=Bmp.Height-1-(-IFY mod Bmp.Height) else
            if IFY>Bmp.Height-1 then IFY:=IFY mod Bmp.Height;
          Total_Red:=0.0;
          Total_Green:=0.0;
          Total_Blue:=0.0;
          for IX:=0 to 1 do
            begin
              for IY:=0 to 1 do
                begin
                  if IFY+IY<Bmp.Height then SLI:=Bmp.ScanLine[IFY+IY]
                    else SLI:=Bmp.ScanLine[Bmp.Height-IFY-IY];
                  if IFX+IX<Bmp.Width then
                    begin
                      New_Red:=SLI[(IFX+IX)*3];
                      New_Green:=SLI[(IFX+IX)*3+1];
                      New_Blue:=SLI[(IFX+IX)*3+2];
                    end
                  else
                    begin
                      New_Red:=SLI[(Bmp.Width-IFX-IX)*3];
                      New_Green:=SLI[(Bmp.Width-IFX-IX)*3+1];
                      New_Blue:=SLI[(Bmp.Width-IFX-IX)*3+2];
                    end;
                  Weight:=Weight_X[IX]*Weight_Y[IY];
                  Total_Red:=Total_Red+New_Red*Weight;
                  Total_Green:=Total_Green+New_Green*Weight;
                  Total_Blue:=Total_Blue+New_Blue*Weight;
                end;
            end;
          SLO:=Dst.ScanLine[TY];
          SLO[TX*3]:=Round(Total_Red);
          SLO[TX*3+1]:=Round(Total_Green);
          SLO[TX*3+2]:=Round(Total_Blue);
        end;
    end;
end;

procedure SplitBlur(var Clip: PBitmap; Amount: integer);
var P0,P1,P2: PByteArray;
    CX,X,Y: integer;
    Buf: array [0..3,0..2] of byte;
begin
  if Amount=0 then Exit;
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      if Y-Amount<0 then P1:=Clip.ScanLine[Y] else P1:=Clip.ScanLine[Y-Amount]; {Y-Amount>0}
      if Y+Amount<Clip.Height then P2:=Clip.ScanLine[Y+Amount] else P2:=Clip.ScanLine[Clip.Height-Y]; {Y+Amount>=Height}
      for X:=0 to pred(Clip.Width) do
        begin
          if X-Amount<0 then CX:=X else CX:=X-Amount; {X-Amount>0}
          Buf[0,0]:=P1[CX*3];
          Buf[0,1]:=P1[CX*3+1];
          Buf[0,2]:=P1[CX*3+2];
          Buf[1,0]:=P2[CX*3];
          Buf[1,1]:=P2[CX*3+1];
          Buf[1,2]:=P2[CX*3+2];
          if X+Amount<Clip.Width then CX:=X+Amount else CX:=Clip.Width-X; {X+Amount>=Width}
          Buf[2,0]:=P1[CX*3];
          Buf[2,1]:=P1[CX*3+1];
          Buf[2,2]:=P1[CX*3+2];
          Buf[3,0]:=P2[CX*3];
          Buf[3,1]:=P2[CX*3+1];
          Buf[3,2]:=P2[CX*3+2];
          P0[X*3]:=(Buf[0,0]+Buf[1,0]+Buf[2,0]+Buf[3,0]) shr 2;
          P0[X*3+1]:=(Buf[0,1]+Buf[1,1]+Buf[2,1]+Buf[3,1]) shr 2;
          P0[X*3+2]:=(Buf[0,2]+Buf[1,2]+Buf[2,2]+Buf[3,2]) shr 2;
        end;
    end;
end;

procedure GaussianBlur(var Clip: PBitmap; Amount: integer);
var I: integer;
begin
  for I:=Amount downto 0 do SplitBlur(Clip,3);
end;

procedure CopyMe(var ToBMP,FromBMP: PBitmap);
begin
  ToBMP.Assign(FromBMP);
end;

procedure GrayScale(var Clip: PBitmap);
var P0: PByteArray;
    Gray,X,Y: integer;
begin
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      for X:=0 to pred(Clip.Width) do
        begin
          Gray:=Round(P0[X*3]*0.3+P0[X*3+1]*0.59+P0[X*3+2]*0.11);
          P0[X*3]:=Gray;
          P0[X*3+1]:=Gray;
          P0[X*3+2]:=Gray;
        end;
  end;
end;

procedure Lightness(var Clip: PBitmap; Amount: integer);
var P0: PByteArray;
    R,G,B,X,Y: integer;
begin
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      for X:=0 to pred(Clip.Width) do
        begin
          R:=P0[X*3];
          G:=P0[X*3+1];
          B:=P0[X*3+2];
          P0[X*3]:=Int2Byte(R+((255-R)*Amount) div 255);
          P0[X*3+1]:=Int2Byte(G+((255-G)*Amount) div 255);
          P0[X*3+2]:=Int2Byte(B+((255-B)*Amount) div 255);
        end;
    end;
end;

procedure Darkness(var Src: PBitmap; Amount: integer);
var P0: PByteArray;
    R,G,B,X,Y: integer;
begin
  Src.PixelFormat:=pf24bit;
  for Y:=0 to pred(Src.Height) do
    begin
      P0:=Src.ScanLine[Y];
      for X:=0 to pred(Src.Width) do
        begin
          R:=P0[X*3];
          G:=P0[X*3+1];
          B:=P0[X*3+2];
          P0[X*3]:=Int2Byte(R-((R)*Amount) div 255);
          P0[X*3+1]:=Int2Byte(G-((G)*Amount) div 255);
          P0[X*3+2]:=Int2Byte(B-((B)*Amount) div 255);
        end;
    end;
end;

procedure Marble(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Width:=W;
  Dst.Height:=H;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      YY:=Scale*Cos((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[y];
      for X:=0 to pred(W) do
        begin
          XX:=-Scale*Sin((X mod Turbulence)/Scale);
          XM:=Abs(Round(X+XX+YY));
          YM:=Abs(Round(Y+YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Marble2(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      YY:=Scale*Cos((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[Y];
      for X:=0 to pred(W) do
        begin
          XX:=-Scale*Sin((X mod Turbulence)/Scale);
          XM:=Abs(Round(X+XX-YY));
          YM:=Abs(Round(Y+YY-XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Marble3(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      YY:=Scale*Cos((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[Y];
      for X:=0 to pred(W) do
        begin
          XX:=-Scale*Sin((X mod Turbulence)/Scale);
          XM:=Abs(Round(X-XX+YY));
          YM:=Abs(Round(Y-YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Marble4(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      YY:=Scale*Sin((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[Y];
      for X:=0 to pred(W) do
        begin
          XX:=-Scale*Cos((X mod Turbulence)/Scale);
          XM:=Abs(Round(X+XX+YY));
          YM:=Abs(Round(Y+YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
      end;
    end;
  end;

procedure Marble5(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=pred(H) downto 0 do
    begin
      YY:=Scale*Cos((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[Y];
      for X:=pred(W) downto 0 do
        begin
          XX:=-Scale*Sin((X mod Turbulence)/Scale);
          XM:=Abs(Round(X+XX+YY));
          YM:=Abs(Round(Y+YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Marble6(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      YY:=Scale*Cos((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[Y];
      for X:=0 to pred(W) do
        begin
          XX:=-Tan((X mod Turbulence)/Scale)/Scale;
          XM:=Abs(Round(X+XX+YY));
          YM:=Abs(Round(Y+YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Marble7(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      YY:=Scale*Sin((Y mod Turbulence)/Scale);
      P1:=Src.ScanLine[Y];
      for X:=0 to pred(W) do
        begin
          XX:=-Tan((X mod Turbulence)/Scale)/(Scale*Scale);
          XM:=Abs(Round(X+XX+YY));
          YM:=Abs(Round(Y+YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Marble8(var Src,Dst: PBitmap; Scale: extended; Turbulence: integer);
var X,XM,Y,YM,W,H: integer;
    XX,YY,AX: extended;
    P1,P2: PByteArray;
begin
  H:=Src.Height;
  W:=Src.Width;
  Dst.Assign(Src);
  for Y:=0 to pred(H) do
    begin
      AX:=(Y mod Turbulence)/Scale;
      YY:=Scale*Sin(AX)*Cos(1.5*AX);
      P1:=Src.ScanLine[Y];
      for X:=0 to pred(W) do
        begin
          AX:=(X mod Turbulence)/Scale;
          XX:=-Scale*Sin(2*AX)*Cos(AX);
          XM:=Abs(Round(X+XX+YY));
          YM:=Abs(Round(Y+YY+XX));
          if YM<H then
            begin
              P2:=Dst.ScanLine[YM];
              if XM<W then
                begin
                  P2[XM*3]:=P1[X*3];
                  P2[XM*3+1]:=P1[X*3+1];
                  P2[XM*3+2]:=P1[X*3+2];
                end;
            end;
        end;
    end;
end;

procedure Saturation(var Clip: PBitmap; Amount: integer);
var P0: PByteArray;
    Gray,R,G,B,X,Y: integer;
begin
  for Y:=0 to pred(Clip.Height) do
    begin
      P0:=Clip.ScanLine[Y];
      for X:=0 to pred(Clip.Width) do
        begin
          R:=P0[X*3];
          G:=P0[X*3+1];
          B:=P0[X*3+2];
          Gray:=(R+G+B) div 3;
          P0[X*3]:=Int2Byte(Gray+(((R-Gray)*Amount) div 255));
          P0[X*3+1]:=Int2Byte(Gray+(((G-Gray)*Amount) div 255));
          P0[X*3+2]:=Int2Byte(Gray+(((B-Gray)*Amount) div 255));
        end;
  end;
end;

procedure SmoothPoint(var Clip: PBitmap; XK,YK: integer);
var Bleu,Vert,Rouge,W,H: integer;
    Color: TFColor;
    AColor: TColor;
    BB,GG,RR: array[1..5] of integer;
begin
  W:=Clip.Width;
  H:=Clip.Height;
  if (XK>0) and (YK>0) and (XK<W-1) and (YK<H-1) then
    begin
      AColor:=Color2RGB(Clip.Pixels[XK,YK-1]);
      Color.R:=GetRValue(AColor);
      Color.G:=GetGValue(AColor);
      Color.B:=GetBValue(AColor);
      RR[1]:=Color.R;
      GG[1]:=Color.G;
      BB[1]:=Color.B;
      AColor:=Color2RGB(Clip.Pixels[XK+1,YK]);
      Color.R:=GetRValue(AColor);
      Color.G:=GetGValue(AColor);
      Color.B:=GetBValue(AColor);
      RR[2]:=Color.R;
      GG[2]:=Color.G;
      BB[2]:=Color.B;
      AColor:=Color2RGB(Clip.Pixels[XK,YK+1]);
      Color.R:=GetRValue(AColor);
      Color.G:=GetGValue(AColor);
      Color.B:=GetBValue(AColor);
      RR[3]:=Color.R;
      GG[3]:=Color.G;
      BB[3]:=Color.B;
      AColor:=Color2RGB(Clip.Pixels[XK-1,YK]);
      Color.R:=GetRValue(AColor);
      Color.G:=GetGValue(AColor);
      Color.B:=GetBValue(AColor);
      RR[4]:=Color.R;
      GG[4]:=Color.G;
      BB[4]:=Color.B;
      Bleu:=(BB[1]+(BB[2]+BB[3]+BB[4])) div 4;    (* Valeur moyenne *)
      Vert:=(GG[1]+(GG[2]+GG[3]+GG[4])) div 4;    (* en cours d'‚valuation        *)
      Rouge:=(RR[1]+(RR[2]+RR[3]+RR[4])) div 4;
      Color.R:=Rouge;
      Color.G:=Vert;
      Color.B:=Bleu;
      Clip.Pixels[XK,YK]:=RGB(Color.R,Color.G,Color.B);
    end;
end;

procedure SmoothResize(var Src,Dst: PBitmap);
var X,Y,XP,YP,YP2,XP2: integer;
    Read,Read2: PByteArray;
    T,T3,T13,Z,Z2,IZ2: integer;
    PC: PByteArray;
    W1,W2,W3,W4: integer;
    Col1R,Col1G,Col1B,Col2R,Col2G,Col2B: byte;
begin
  XP2:=((Src.Width-1) shl 15) div Dst.Width;
  YP2:=((Src.Height-1) shl 15) div Dst.Height;
  YP:=0;
  for Y:=0 to pred(Dst.Height) do
    begin
      XP:=0;
      Read:=Src.ScanLine[YP shr 15];
      if YP shr 16<Src.Height-1 then Read2:=Src.ScanLine[YP shr 15+1] else Read2:=Src.ScanLine[YP shr 15];
      PC:=Dst.ScanLine[Y];
      Z2:=YP and $7FFF;
      IZ2:=$8000-Z2;
      for X:=0 to pred(Dst.Width) do
        begin
          T:=XP shr 15;
          T3:=T*3;
          T13:=T3+3;
          Col1R:=Read[T3];
          Col1g:=Read[T3+1];
          Col1b:=Read[T3+2];
          Col2r:=Read2[T3];
          Col2g:=Read2[T3+1];
          Col2b:=Read2[T3+2];
          Z:=XP and $7FFF;
          W2:=(Z*IZ2) shr 15;
          W1:=IZ2-W2;
          W4:=(Z*Z2)shr 15;
          W3:=Z2-W4;
          PC[X*3+2]:=(Col1B*W1+Read[T13+2]*W2+Col2B*W3+Read2[T13+2]*W4) shr 15;
          pc[x*3+1]:=(Col1G*W1+Read[T13+1]*W2+Col2G*W3+Read2[T13+1]*W4) shr 15;
          // (t+1)*3  is now t13
          pc[x*3]:=(Col1R*W1+Read2[T13]*W2+Col2R*W3+Read2[T13]*W4) shr 15;
          Inc(XP,XP2);
        end;
      Inc(YP,YP2);
    end;
end;

procedure SmoothRotate(var Src,Dst: PBitmap; CX,CY: integer; Angle: extended);
var Top,Bottom,Left,Right,Eww,Nsw,FX,FY,WX,WY: extended;
    cAngle,sAngle: double;
    xDiff,yDiff,IFX,IFY,PX,PY,IX,IY,X,Y: integer;
    NW,NE,SW,SE: TFColor;
    P1,P2,P3: PByteArray;
begin
  Angle:=angle;
  Angle:=-Angle*Pi/180;
  sAngle:=Sin(Angle);
  cAngle:=Cos(Angle);
  xDiff:=(Dst.Width-Src.Width) div 2;
  yDiff:=(Dst.Height-Src.Height) div 2;
  for y:=0 to Dst.Height-1 do
  begin
    P3:=Dst.scanline[y];
    py:=2*(y-cy)+1;
    for x:=0 to Dst.Width-1 do
    begin
      px:=2*(x-cx)+1;
      fx:=(((px*cAngle-py*sAngle)-1)/ 2+cx)-xDiff;
      fy:=(((px*sAngle+py*cAngle)-1)/ 2+cy)-yDiff;
      ifx:=Round(fx);
      ify:=Round(fy);
      if(ifx>-1)and(ifx<Src.Width)and(ify>-1)and(ify<Src.Height)then
      begin
        eww:=fx-ifx;
        nsw:=fy-ify;
        iy:=TrimInt(ify+1,0,Src.Height-1);
        ix:=TrimInt(ifx+1,0,Src.Width-1);
        P1:=Src.scanline[ify];
        P2:=Src.scanline[iy];
        nw.r:=P1[ifx*3];
        nw.g:=P1[ifx*3+1];
        nw.b:=P1[ifx*3+2];
        ne.r:=P1[ix*3];
        ne.g:=P1[ix*3+1];
        ne.b:=P1[ix*3+2];
        sw.r:=P2[ifx*3];
        sw.g:=P2[ifx*3+1];
        sw.b:=P2[ifx*3+2];
        se.r:=P2[ix*3];
        se.g:=P2[ix*3+1];
        se.b:=P2[ix*3+2];
        Top:=nw.b+eww*(ne.b-nw.b);
        Bottom:=sw.b+eww*(se.b-sw.b);
        P3[x*3+2]:=Int2Byte(Round(Top+nsw*(Bottom-Top)));
        Top:=nw.g+eww*(ne.g-nw.g);
        Bottom:=sw.g+eww*(se.g-sw.g);
        P3[x*3+1]:=Int2Byte(Round(Top+nsw*(Bottom-Top)));
        Top:=nw.r+eww*(ne.r-nw.r);
        Bottom:=sw.r+eww*(se.r-sw.r);
        P3[x*3]:=Int2Byte(Round(Top+nsw*(Bottom-Top)));
      end;
    end;
  end;
end;

procedure Spray(var Clip: PBitmap; Amount: integer);
var i,j,x,y,w,h,Val: integer;
begin
  h:=clip.height;
  w:=clip.Width;
  for i:=0 to w-1 do
    for j:=0 to h-1 do
      begin
        Val:=Random(Amount);
        x:=i+Val-Random(Val*2);
        y:=j+Val-Random(Val*2);
        if (x>-1) and (x<w) and (y>-1) and (y<h) then clip.Pixels[i,j]:=clip.Pixels[x,y];
      end;
end;

procedure Mosaic(var Clip: PBitmap; Size: integer);
var x,y,i,j: integer;
    p1,p2: pbytearray;
    r,g,b: byte;
begin
  y:=0;
  repeat
    p1:=clip.scanline[y];
    x:=0;
    repeat
      j:=1;
      repeat
      p2:=clip.scanline[y];
      x:=0;
      repeat
        r:=p1[x*3];
        g:=p1[x*3+1];
        b:=p1[x*3+2];
        i:=1;
       repeat
       p2[x*3]:=r;
       p2[x*3+1]:=g;
       p2[x*3+2]:=b;
       inc(x);
       inc(i);
       until (x>=clip.width) or (i>size);
      until x>=clip.width;
      inc(j);
      inc(y);
      until (y>=clip.height) or (j>size);
    until (y>=clip.height) or (x>=clip.width);
  until y>=clip.height;
end;

function TrimInt(I,Min,Max: integer): integer;
begin
  if I>Max then Result:=Max else
    if I<Min then Result:=Min else Result:=I;
end;

procedure Twist(var Bmp,Dst: PBitmap; Amount: integer);
var
  fxmid, fymid : Single;
  txmid, tymid : Single;
  fx,fy : Single;
  tx2, ty2 : Single;
  r : Single;
  theta : Single;
  ifx, ify : integer;
  dx, dy : Single;
  OFFSET : Single;
  ty, tx             : Integer;
  weight_x, weight_y     : array[0..1] of Single;
  weight                 : Single;
  new_red, new_green     : Integer;
  new_blue               : Integer;
  total_red, total_green : Single;
  total_blue             : Single;
  ix, iy                 : Integer;
  sli, slo : PBytearray;

  function ArcTan2(xt,yt : Single): Single;
  begin
    if xt=0 then
      if yt>0 then Result:=Pi/2 else Result:=-(Pi/2)
    else
      begin
        Result:=ArcTan(yt/xt);
        if xt<0 then Result:=Pi+ArcTan(yt/xt);
      end;
  end;

begin
  OFFSET:=-(Pi/2);
  dx:=Bmp.Width - 1;
  dy:=Bmp.Height - 1;
  r:=Sqrt(dx * dx+dy * dy);
  tx2:=r;
  ty2:=r;
  txmid:=(Bmp.Width-1)/2;    //Adjust these to move center of rotation
  tymid:=(Bmp.Height-1)/2;   //Adjust these to move ......
  fxmid:=(Bmp.Width-1)/2;
  fymid:=(Bmp.Height-1)/2;
  if tx2 >= Bmp.Width then tx2:=Bmp.Width-1;
  if ty2 >= Bmp.Height then ty2:=Bmp.Height-1;

  for ty:=0 to Round(ty2) do begin
    for tx:=0 to Round(tx2) do begin
      dx:=tx - txmid;
      dy:=ty - tymid;
      r:=Sqrt(dx * dx+dy * dy);
      if r = 0 then begin
        fx:=0;
        fy:=0;
      end
      else begin
        theta:=ArcTan2(dx,dy) - r/Amount - OFFSET;
        fx:=r * Cos(theta);
        fy:=r * Sin(theta);
      end;
      fx:=fx+fxmid;
      fy:=fy+fymid;

      ify:=Trunc(fy);
      ifx:=Trunc(fx);
                // Calculate the weights.
      if fy >= 0  then begin
        weight_y[1]:=fy - ify;
        weight_y[0]:=1 - weight_y[1];
      end else begin
        weight_y[0]:=-(fy - ify);
        weight_y[1]:=1 - weight_y[0];
      end;
      if fx >= 0 then begin
        weight_x[1]:=fx - ifx;
        weight_x[0]:=1 - weight_x[1];
      end else begin
        weight_x[0]:=-(fx - ifx);
        Weight_x[1]:=1 - weight_x[0];
      end;

      if ifx < 0 then
        ifx:=Bmp.Width-1-(-ifx mod Bmp.Width)
      else if ifx > Bmp.Width-1  then
        ifx:=ifx mod Bmp.Width;
      if ify < 0 then
        ify:=Bmp.Height-1-(-ify mod Bmp.Height)
      else if ify > Bmp.Height-1 then
        ify:=ify mod Bmp.Height;

      total_red  :=0.0;
      total_green:=0.0;
      total_blue :=0.0;
      for ix:=0 to 1 do begin
        for iy:=0 to 1 do begin
          if ify+iy < Bmp.Height then
            sli:=Bmp.scanline[ify+iy]
          else
            sli:=Bmp.scanline[Bmp.Height - ify - iy];
          if ifx+ix < Bmp.Width then begin
            new_red:=sli[(ifx+ix)*3];
            new_green:=sli[(ifx+ix)*3+1];
            new_blue:=sli[(ifx+ix)*3+2];
          end
          else begin
            new_red:=sli[(Bmp.Width - ifx - ix)*3];
            new_green:=sli[(Bmp.Width - ifx - ix)*3+1];
            new_blue:=sli[(Bmp.Width - ifx - ix)*3+2];
          end;
          weight:=weight_x[ix] * weight_y[iy];
          total_red  :=total_red  +new_red   * weight;
          total_green:=total_green+new_green * weight;
          total_blue :=total_blue +new_blue  * weight;
        end;
      end;
      slo:=Dst.scanline[ty];
      slo[tx*3]:=Round(total_red);
      slo[tx*3+1]:=Round(total_green);
      slo[tx*3+2]:=Round(total_blue);
    end;
  end;
end;

procedure Wave(var Clip: PBitmap; Amount,Inference,Style: integer);
var
  x,y : integer;
  BitMap : PBitmap;
  P1,P2 : PByteArray;
  b:integer;
  fangle:real;
  wavex:integer;
begin
  BitMap:=NewBitmap(0,0);
  Bitmap.assign(clip);
  wavex:=style;
  fangle:=pi/2/Amount;
    for y:=BitMap.height-1-(2*Amount) downto Amount do begin
      P1:=BitMap.ScanLine[y];
      b:=0;
      for x:=0 to Bitmap.width-1 do begin
        P2:=clip.scanline[y+Amount+b];
        P2[x*3]:=P1[x*3];
        P2[x*3+1]:=P1[x*3+1];
        P2[x*3+2]:=P1[x*3+2];
        case wavex of
        0: b:=Amount*variant(sin(fangle*x));
        1: b:=Amount*variant(sin(fangle*x)*cos(fangle*x));
        2: b:=Amount*variant(sin(fangle*x)*sin(inference*fangle*x));
        end;
      end;
    end;
  BitMap.free;
end;

procedure MakeSeamlessClip(var Clip: PBitmap; Seam: integer);
var
  p0,p1,p2:pbytearray;
  h,w,i,j,sv,sh:integer;
  f0,f1,f2:real;
begin
h:=clip.height;
w:=clip.width;
sv:=h div seam;
sh:=w div seam;
p1:=clip.scanline[0];
p2:=clip.ScanLine [h-1];
for i:=0 to w-1 do begin
  p1[i*3]:=p2[i*3];
  p1[i*3+1]:=p2[i*3+1];
  p1[i*3+2]:=p2[i*3+2];
  end;
p0:=clip.scanline[0];
p2:=clip.scanline[sv];
for j:=1 to sv-1 do begin
  p1:=clip.scanline[j];
  for i:=0 to w-1 do begin
    f0:=(p2[i*3]-p0[i*3])/sv*j+p0[i*3];
    p1[i*3]:=  round (f0);
    f1:=(p2[i*3+1]-p0[i*3+1])/sv*j+p0[i*3+1];
    p1[i*3+1]:=round (f1);
    f2:=(p2[i*3+2]-p0[i*3+2])/sv*j+p0[i*3+2];
    p1[i*3+2]:=round (f2);
    end;
  end;
for j:=0 to h-1 do begin
  p1:=clip.scanline[j];
  p1[(w-1)*3]:=p1[0];
  p1[(w-1)*3+1]:=p1[1];
  p1[(w-1)*3+2]:=p1[2];
  for i:=1 to sh-1 do begin
    f0:=(p1[(w-sh)*3]-p1[(w-1)*3])/sh*i+p1[(w-1)*3];
    p1[(w-1-i)*3]:=round(f0);
    f1:=(p1[(w-sh)*3+1]-p1[(w-1)*3+1])/sh*i+p1[(w-1)*3+1];
    p1[(w-1-i)*3+1]:=round(f1);
    f2:=(p1[(w-sh)*3+2]-p1[(w-1)*3+2])/sh*i+p1[(w-1)*3+2];
    p1[(w-1-i)*3+2]:=round(f2);
    end;
  end;
end;

procedure SplitLight(var Clip: PBitmap; Amount: integer);
var x,y,i:integer;
    p1:pbytearray;

    function sinpixs(a:integer):integer;
    begin
    result:=variant(sin(a/255*pi/2)*255);
    end;
begin
for i:=1 to Amount do
  for y:=0 to clip.height-1 do begin
    p1:=clip.scanline[y];
    for x:=0 to clip.width-1 do begin
      p1[x*3]:=sinpixs(p1[x*3]);
      p1[x*3+1]:=sinpixs(p1[x*3+1]);
      p1[x*3+2]:=sinpixs(p1[x*3+2]);
      end;
    end;
end;

procedure SqueezeHor(var Src,Dst: PBitmap; Amount: integer; Style: TLightBrush);
var dx,x,y,c,cx:integer;
    R:trect;
    bm:PBitmap;
    p0,p1:pbytearray;
begin
if Amount>(Src.width div 2) then Amount:=Src.width div 2;
bm:=NewBitmap(Src.width,1);
bm.PixelFormat:=pf24bit;
cx:=Src.width div 2;
p0:=bm.scanline[0];
  for y:=0 to Src.height-1 do begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do begin
      c:=x*3;
      p0[c]:=p1[c];
      p0[c+1]:=p1[c+1];
      p0[c+2]:=p1[c+2];
      end;
    case style of
    lbhor:
      begin
      dx:=Amount;
      R:=rect(dx,y,Src.width-dx,y+1);
      end;
    lbtop:
      begin
      dx:=round((Src.height-1-y)/Src.height*Amount);
      R:=rect(dx,y,Src.width-dx,y+1);
      end;
    lbBottom:
      begin
      dx:=round(y/Src.height*Amount);
      R:=rect(dx,y,Src.width-dx,y+1);
      end;
    lbDiamond:
      begin
      dx:=abs(round(Amount*(cos(y/(Src.height-1)*pi))));
      R:=rect(dx,y,Src.width-dx,y+1);
      end;
    lbWaste:
      begin
      dx:=abs(round(Amount*(sin(y/(Src.height-1)*pi))));
      R:=rect(dx,y,Src.width-dx,y+1);
      end;
    lbRound:
      begin
      dx:=abs(round(Amount*(sin(y/(Src.height-1)*pi))));
      R:=rect(cx-dx,y,cx+dx,y+1);
      end;
    lbRound2:
      begin
      dx:=abs(round(Amount*(sin(y/(Src.height-1)*pi*2))));
      R:=rect(cx-dx,y,cx+dx,y+1);
      end;
    end;
    bm.StretchDraw(Dst.Canvas.Handle,R);
    end;
  bm.free;
end;

procedure Tile(var Src,Dst: PBitmap; Amount: integer);
var w,h,w2,h2,i,j:integer;
    bm:PBitmap;
begin
  w:=Src.width;
  h:=Src.height;
  Dst.width:=w;
  Dst.height:=h;
  Dst.Assign(Src);
  if (Amount<=0) or ((w div Amount)<5)or ((h div Amount)<5) then exit;
  h2:=h div Amount;
  w2:=w div Amount;
  bm:=NewBitmap(w2,h2);
  bm.PixelFormat:=pf24bit;
  smoothresize(Src,bm);
  for j:=0 to Amount-1 do
   for i:=0 to Amount-1 do
     bm.Draw(Dst.Canvas.Handle,i*w2,j*h2);
  bm.free;
end;

// -----------------------------------------------------------------------------
//
//			Interpolator
//
// -----------------------------------------------------------------------------
type
  // Contributor for a pixel
  TContributor = record
    pixel: integer;		// Source pixel
    weight: single;		// Pixel weight
  end;

  TContributorList = array[0..0] of TContributor;
  PContributorList = ^TContributorList;

  // List of source pixels contributing to a destination pixel
  TCList = record
    n: integer;
    p: PContributorList;
  end;

  TCListList = array[0..0] of TCList;
  PCListList = ^TCListList;

  TRGB = packed record
    r,g,b :single;
  end;

  // Physical bitmap pixel
  TColorRGB = packed record
    r,g,b : byte;
  end;
  PColorRGB = ^TColorRGB;

  // Physical bitmap scanline (row)
  TRGBList = packed array[0..0] of TColorRGB;
  PRGBList = ^TRGBList;

procedure Strecth(var Src,Dst: PBitmap; Filter: TFilterProc; FWidth: single);
var
  xscale, yscale	: single;		// Zoom scale factors
  i, j, k		: integer;		// Loop variables
  center		: single;		// Filter calculation variables
  width, fscale, weight	: single;		// Filter calculation variables
  left, right		: integer;		// Filter calculation variables
  n			: integer;		// Pixel number
  Work			: PBitmap;
  contrib		: PCListList;
  rgb			: TRGB;
  color			: TColorRGB;
{$IFDEF USE_SCANLINE}
  SourceLine		,
  DestLine		: PRGBList;
  SourcePixel		,
  DestPixel		: PColorRGB;
  Delta			,
  DestDelta		: integer;
{$ENDIF}
  SrcWidth		,
  SrcHeight		,
  DstWidth		,
  DstHeight		: integer;

  function Color2RGB(Color: TColor): TColorRGB;
  begin
    Result.r:=Color AND $000000FF;
    Result.g:=(Color AND $0000FF00) SHR 8;
    Result.b:=(Color AND $00FF0000) SHR 16;
  end;

  function RGB2Color(Color: TColorRGB): TColor;
  begin
    Result:=Color.r OR (Color.g SHL 8) OR (Color.b SHL 16);
  end;


begin
  DstWidth:=Dst.Width;
  DstHeight:=Dst.Height;
  SrcWidth:=Src.Width;
  SrcHeight:=Src.Height;
  if (SrcWidth<1) or (SrcHeight<1) then raise Exception.Create(e_Abort,'Source bitmap too small');
  try
    // Create intermediate image to hold horizontal zoom
    Work:=NewBitmap(DstWidth,SrcHeight);
    // xscale:=DstWidth / SrcWidth;
    // yscale:=DstHeight / SrcHeight;
    // Improvement suggested by David Ullrich:
    if SrcWidth=1 then xscale:=DstWidth/SrcWidth else xscale:=(DstWidth-1)/(SrcWidth-1);
    if SrcHeight=1 then yscale:=DstHeight/SrcHeight else yscale:=(DstHeight-1)/(SrcHeight-1);
    // This implementation only works on 24-bit images because it uses
    // PBitmap.Scanline
{$IFDEF USE_SCANLINE}
    Src.PixelFormat:=pf24bit;
    Dst.PixelFormat:=Src.PixelFormat;
    Work.PixelFormat:=Src.PixelFormat;
{$ENDIF}

    // --------------------------------------------
    // Pre-calculate filter contributions for a row
    // -----------------------------------------------
    GetMem(contrib, DstWidth* sizeof(TCList));
    // Horizontal sub-sampling
    // Scales from bigger to smaller width
    if (xscale < 1.0) then
    begin
      width:=fwidth / xscale;
      fscale:=1.0 / xscale;
      for i:=0 to DstWidth-1 do
      begin
        contrib^[i].n:=0;
        GetMem(contrib^[i].p, trunc(width * 2.0+1) * sizeof(TContributor));
        center:=i / xscale;
        // Original code:
        // left:=ceil(center - width);
        // right:=floor(center+width);
        left:=floor(center - width);
        right:=ceil(center+width);
        for j:=left to right do
        begin
          weight:=filter((center-j)/fscale)/fscale;
          if weight=0.0 then continue;
          if j<0 then n:=-j else
            if j>=SrcWidth then n:=SrcWidth-j+SrcWidth-1 else n:=j;
          k:=contrib^[i].n;
          contrib^[i].n:=contrib^[i].n+1;
          contrib^[i].p^[k].pixel:=n;
          contrib^[i].p^[k].weight:=weight;
        end;
      end;
    end else
    // Horizontal super-sampling
    // Scales from smaller to bigger width
    begin
      for i:=0 to DstWidth-1 do
      begin
        contrib^[i].n:=0;
        GetMem(contrib^[i].p,trunc(fwidth*2.0+1)*sizeof(TContributor));
        center:=i/xscale;
        // Original code:
        // left:=ceil(center - fwidth);
        // right:=floor(center+fwidth);
        left:=floor(center-fwidth);
        right:=ceil(center+fwidth);
        for j:=left to right do
        begin
          weight:=filter(center-j);
          if weight=0.0 then continue;
          if j<0 then n:=-j else
            if j>=SrcWidth then n:=SrcWidth-j+SrcWidth-1 else n:=j;
          k:=contrib^[i].n;
          contrib^[i].n:=contrib^[i].n+1;
          contrib^[i].p^[k].pixel:=n;
          contrib^[i].p^[k].weight:=weight;
        end;
      end;
    end;
    // ----------------------------------------------------
    // Apply filter to sample horizontally from Src to Work
    // ----------------------------------------------------
    for k:=0 to SrcHeight-1 do
    begin
{$IFDEF USE_SCANLINE}
      SourceLine:=Src.ScanLine[k];
      DestPixel:=Work.ScanLine[k];
{$ENDIF}
      for i:=0 to DstWidth-1 do
      begin
        rgb.r:=0.0;
        rgb.g:=0.0;
        rgb.b:=0.0;
        for j:=0 to contrib^[i].n-1 do
        begin
{$IFDEF USE_SCANLINE}
          color:=SourceLine^[contrib^[i].p^[j].pixel];
{$ELSE}
          color:=Color2RGB(Src.Canvas.Pixels[contrib^[i].p^[j].pixel,k]);
{$ENDIF}
          weight:=contrib^[i].p^[j].weight;
          if weight=0.0 then continue;
          rgb.r:=rgb.r+color.r*weight;
          rgb.g:=rgb.g+color.g*weight;
          rgb.b:=rgb.b+color.b*weight;
        end;
        if rgb.r>255.0 then color.r:=255 else
          if rgb.r<0.0 then color.r:=0 else color.r:=round(rgb.r);
        if rgb.g>255.0 then color.g:=255 else
          if rgb.g<0.0 then color.g:=0 else color.g:=round(rgb.g);
        if rgb.b>255.0 then color.b:=255 else
          if rgb.b<0.0 then color.b:=0 else color.b:=round(rgb.b);
{$IFDEF USE_SCANLINE}
        // Set new pixel value
        DestPixel^:=color;
        // Move on to next column
        inc(DestPixel);
{$ELSE}
        Work.Canvas.Pixels[i,k]:=RGB2Color(color);
{$ENDIF}
      end;
    end;
    // Free the memory allocated for horizontal filter weights
    for i:=0 to DstWidth-1 do FreeMem(contrib^[i].p);
    FreeMem(contrib);
    // -----------------------------------------------
    // Pre-calculate filter contributions for a column
    // -----------------------------------------------
    GetMem(contrib,DstHeight*sizeof(TCList));
    // Vertical sub-sampling
    // Scales from bigger to smaller height
    if yscale<1.0 then
    begin
      width:=fwidth/yscale;
      fscale:=1.0/yscale;
      for i:=0 to DstHeight-1 do
      begin
        contrib^[i].n:=0;
        GetMem(contrib^[i].p,trunc(width*2.0+1)*sizeof(TContributor));
        center:=i/yscale;
        // Original code:
        // left:=ceil(center-width);
        // right:=floor(center+width);
        left:=floor(center-width);
        right:=ceil(center+width);
        for j:=left to right do
        begin
          weight:=filter((center-j)/fscale)/fscale;
          if weight=0.0 then continue;
          if j<0 then n:=-j else
            if j>=SrcHeight then n:=SrcHeight-j+SrcHeight-1 else n:=j;
          k:=contrib^[i].n;
          contrib^[i].n:=contrib^[i].n+1;
          contrib^[i].p^[k].pixel:=n;
          contrib^[i].p^[k].weight:=weight;
        end;
      end
    end else
    // Vertical super-sampling
    // Scales from smaller to bigger height
    begin
      for i:=0 to DstHeight-1 do
      begin
        contrib^[i].n:=0;
        GetMem(contrib^[i].p,trunc(fwidth*2.0+1)*sizeof(TContributor));
        center:=i / yscale;
        // Original code:
        // left:=ceil(center-fwidth);
        // right:=floor(center+fwidth);
        left:=floor(center-fwidth);
        right:=ceil(center+fwidth);
        for j:=left to right do
        begin
          weight:=filter(center-j);
          if weight=0.0 then continue;
          if j<0 then n:=-j else
            if j>=SrcHeight then n:=SrcHeight-j+SrcHeight-1 else n:=j;
          k:=contrib^[i].n;
          contrib^[i].n:=contrib^[i].n+1;
          contrib^[i].p^[k].pixel:=n;
          contrib^[i].p^[k].weight:=weight;
        end;
      end;
    end;
    // --------------------------------------------------
    // Apply filter to sample vertically from Work to Dst
    // --------------------------------------------------
{$IFDEF USE_SCANLINE}
    SourceLine:=Work.ScanLine[0];
    Delta:=integer(Work.ScanLine[1])-integer(SourceLine);
    DestLine:=Dst.ScanLine[0];
    DestDelta:=integer(Dst.ScanLine[1])-integer(DestLine);
{$ENDIF}
    for k:=0 to DstWidth-1 do
    begin
{$IFDEF USE_SCANLINE}
      DestPixel:=pointer(DestLine);
{$ENDIF}
      for i:=0 to DstHeight-1 do
      begin
        rgb.r:=0;
        rgb.g:=0;
        rgb.b:=0;
        // weight:=0.0;
        for j:=0 to contrib^[i].n-1 do
        begin
{$IFDEF USE_SCANLINE}
          color:=PColorRGB(integer(SourceLine)+contrib^[i].p^[j].pixel*Delta)^;
{$ELSE}
          color:=Color2RGB(Work.Canvas.Pixels[k, contrib^[i].p^[j].pixel]);
{$ENDIF}
          weight:=contrib^[i].p^[j].weight;
          if (weight = 0.0) then
            continue;
          rgb.r:=rgb.r+color.r * weight;
          rgb.g:=rgb.g+color.g * weight;
          rgb.b:=rgb.b+color.b * weight;
        end;
        if rgb.r>255.0 then color.r:=255 else
          if rgb.r<0.0 then color.r:=0 else color.r:=round(rgb.r);
        if rgb.g>255.0 then color.g:=255 else
          if rgb.g<0.0 then color.g:=0 else color.g:=round(rgb.g);
        if rgb.b>255.0 then color.b:=255 else
          if rgb.b<0.0 then color.b:=0 else color.b:=round(rgb.b);
{$IFDEF USE_SCANLINE}
        DestPixel^:=color;
        inc(integer(DestPixel),DestDelta);
{$ELSE}
        Dst.Canvas.Pixels[k,i]:=RGB2Color(color);
{$ENDIF}
      end;
{$IFDEF USE_SCANLINE}
      Inc(SourceLine);
      Inc(DestLine);
{$ENDIF}
    end;
    // Free the memory allocated for vertical filter weights
    for i:=0 to DstHeight-1 do FreeMem(contrib^[i].p);
    FreeMem(contrib);
  finally
    Work.Free;
  end;
end;

procedure Grow(var Src1,Src2,Dst: PBitmap; Amount: extended; X,Y: integer);
var bm:PBitmap;
    h,w,hr,wr:integer;
begin
  w:=Src1.Width;
  h:=Src1.Height;
  Dst.Width:=w;
  Dst.Height:=h;
  Dst.assign(Src1);
  wr:=round(Amount*w);
  hr:=round(Amount*h);
  bm:=NewBitmap(wr,hr);
  Strecth(Src2,bm,resamplefilters[4].filter,resamplefilters[4].width);
  bm.Draw(Dst.Canvas.Handle,x,y);
  bm.free;
end;

procedure SpotLight(var Src: PBitmap; Amount: integer; Spot: TRect);
var bm:PBitmap;
    w,h:integer;
begin
  Darkness(Src,Amount);
  w:=Src.Width;
  h:=Src.Height;
  bm:=NewBitmap(w,h);
  bm.canvas.Brush.color:=clblack;
  bm.canvas.FillRect(rect(0,0,w,h));
  bm.canvas.brush.Color:=clwhite;
  bm.canvas.Ellipse(Spot.left,spot.top,spot.right,spot.bottom);
  bm.DrawTransparent(Src.Canvas.Handle,0,0,clWhite);
  bm.free;
end;

procedure FlipHorz(var Src: PBitmap);
var dest:PBitmap;
    w,h,x,y:integer;
    pd,ps:pbytearray;
begin
  w:=Src.width;
  h:=Src.height;
  dest:=NewBitmap(w,h);
  dest.pixelformat:=pf24bit;
  Src.pixelformat:=pf24bit;
  for y:=0 to h-1 do begin
   pd:=dest.scanline[y];
   ps:=Src.scanline[h-1-y];
   for x:=0 to w-1 do begin
     pd[x*3]:=ps[x*3];
     pd[x*3+1]:=ps[x*3+1];
     pd[x*3+2]:=ps[x*3+2];
     end;
   end;
  Src.assign(dest);
  dest.free;
end;

procedure FlipVert(var Src: PBitmap);
var
   dest:PBitmap;
   w,h,x,y:integer;
   pd,ps:pbytearray;
begin
  w:=Src.width;
  h:=Src.height;
  dest:=NewBitmap(w,h);
  dest.pixelformat:=pf24bit;
  Src.pixelformat:=pf24bit;
  for y:=0 to h-1 do begin
   pd:=dest.scanline[y];
   ps:=Src.scanline[y];
   for x:=0 to w-1 do begin
     pd[x*3]:=ps[(w-1-x)*3];
     pd[x*3+1]:=ps[(w-1-x)*3+1];
     pd[x*3+2]:=ps[(w-1-x)*3+2];
     end;
   end;
  Src.assign(dest);
  dest.free;
end;

procedure Trace(var Src: PBitmap; Intensity: integer);
var
  x,y,i: integer;
  P1,P2,P3,P4: PByteArray;
  tb,TraceB: byte;
  hasb: boolean;
  bitmap: PBitmap;
begin
  bitmap:=NewBitmap(0,0);
  bitmap.assign(Src);
  bitmap.PixelFormat:=pf8bit;
  Src.PixelFormat:=pf24bit;
  hasb:=false;
  TraceB:=$00;
  for i:=1 to Intensity do begin
    for y:=0 to BitMap.height -2 do begin
      P1:=BitMap.ScanLine[y];
      P2:=BitMap.scanline[y+1];
      P3:=Src.scanline[y];
      P4:=Src.scanline[y+1];
      x:=0;
      repeat
        if p1[x]<>p1[x+1] then begin
           if not hasb then begin
             tb:=p1[x+1];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p3[(x+1)*3]:=TraceB;
                 p3[(x+1)*3+1]:=TraceB;
                 p3[(x+1)*3+1]:=TraceB;
                 end;
             end;
           end;
        if p1[x]<>p2[x] then begin
           if not hasb then begin
             tb:=p2[x];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p4[x*3]:=TraceB;
                 p4[x*3+1]:=TraceB;
                 p4[x*3+2]:=TraceB;
                 end;
             end;
           end;
      inc(x);
      until x>=(BitMap.width-2);
    end;
// do the same in the opposite direction
// only when intensity>1
    if i>1 then
    for y:=BitMap.height-1 downto 1 do begin
      P1:=BitMap.ScanLine[y];
      P2:=BitMap.scanline[y-1];
      P3:=Src.scanline[y];
      P4:=Src.scanline [y-1];
      x:=Bitmap.width-1;
      repeat
        if p1[x]<>p1[x-1] then begin
           if not hasb then begin
             tb:=p1[x-1];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p3[(x-1)*3]:=TraceB;
                 p3[(x-1)*3+1]:=TraceB;
                 p3[(x-1)*3+2]:=TraceB;
                 end;
             end;
           end;
        if p1[x]<>p2[x] then begin
           if not hasb then begin
             tb:=p2[x];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p4[x*3]:=TraceB;
                 p4[x*3+1]:=TraceB;
                 p4[x*3+2]:=TraceB;
                 end;
             end;
           end;
      dec(x);
      until x<=1;
    end;
  end;
bitmap.free;
end;

procedure ShadowUpLeft(var Src: PBitmap);
var
  x,y: integer;
  BitMap: PBitmap;
  P1,P2: PByteArray;
begin
  BitMap:=NewBitmap(0,0);
  Bitmap.assign(Src);
  Bitmap.pixelformat:=pf24bit;
    for y:=0 to BitMap.height-5 do begin
      P1:=BitMap.ScanLine[y];
      P2:=BitMap.scanline[y+4];
      for x:=0 to Bitmap.width-5 do
        if P1[x*3]>P2[(x+4)*3] then begin
        P1[x*3]:=P2[(x+4)*3]+1;
        P1[x*3+1]:=P2[(x+4)*3+1]+1;
        P1[x*3+2]:=P2[(x+4)*3+2]+1;
        end;
    end;
  Src.Assign(bitmap);
  BitMap.free;
end;

procedure ShadowUpRight(var Src: PBitmap);
var
  x,y: integer;
  BitMap: PBitmap;
  P1,P2: PByteArray;
begin
  BitMap:=NewBitmap(0,0);
  Bitmap.assign(Src);
  Bitmap.pixelformat:=pf24bit;
    for y:=0 to bitmap.height-5 do begin
      P1:=BitMap.ScanLine[y];
      P2:=BitMap.scanline[y+4];
      for x:=Bitmap.width-1 downto 4 do
        if P1[x*3]>P2[(x-4)*3] then begin
        P1[x*3]:=P2[(x-4)*3]+1;
        P1[x*3+1]:=P2[(x-4)*3+1]+1;
        P1[x*3+2]:=P2[(x-4)*3+2]+1;
        end;
    end;
  Src.Assign(bitmap);
  BitMap.free;
end;

procedure ShadowDownLeft(var Src: PBitmap);
var
  x,y: integer;
  BitMap: PBitmap;
  P1,P2: PByteArray;
begin
  BitMap:=NewBitmap(0,0);
  Bitmap.assign(Src);
  Bitmap.pixelformat:=pf24bit;
    for y:=bitmap.height-1 downto 4 do begin
      P1:=BitMap.ScanLine[y];
      P2:=BitMap.scanline[y-4];
      for x:=0 to Bitmap.width-5 do
        if P1[x*3]>P2[(x+4)*3] then begin
        P1[x*3]:=P2[(x+4)*3]+1;
        P1[x*3+1]:=P2[(x+4)*3+1]+1;
        P1[x*3+2]:=P2[(x+4)*3+2]+1;
        end;
    end;
  Src.Assign(bitmap);
  BitMap.free;
end;

procedure ShadowDownRight(var Src: PBitmap);
var
  x,y: integer;
  BitMap: PBitmap;
  P1,P2: PByteArray;
begin
  BitMap:=NewBitmap(0,0);
  Bitmap.assign(Src);
  Bitmap.pixelformat:=pf24bit;
    for y:=bitmap.height-1 downto 4 do begin
      P1:=BitMap.ScanLine[y];
      P2:=BitMap.scanline[y-4];
      for x:=Bitmap.width-1 downto 4 do
        if P1[x*3]>P2[(x-4)*3] then begin
         P1[x*3]:=P2[(x-4)*3]+1;
         P1[x*3+1]:=P2[(x-4)*3+1]+1;
         P1[x*3+2]:=P2[(x-4)*3+2]+1;
        end;
    end;
  Src.Assign(bitmap);
  BitMap.free;
end;

procedure SemiOpaque(var Src,Dst: PBitmap);
var b:PBitmap;
    P:Pbytearray;
    x,y:integer;
begin
  b:=NewBitmap(0,0);
  b.assign(Src);
  for y:=0 to b.height-1 do
  begin
    p:=b.scanline[y];
    if (y mod 2)=0 then
    begin
      for x:=0 to b.width-1 do
        if (x mod 2)=0 then
        begin
          p[x*3]:=$FF;
          p[x*3+1]:=$FF;
          p[x*3+2]:=$FF;
          end;
        end
    else
    begin
      for x:=0 to b.width-1 do
        if ((x+1) mod 2)=0 then
        begin
          p[x*3]:=$FF;
          p[x*3+1]:=$FF;
          p[x*3+2]:=$FF;
        end;
    end;
  end;
  Dst.Assign(b);
  b.free;
end;

procedure QuartoOpaque(var Src,Dst: PBitmap);
var b:PBitmap;
    P:Pbytearray;
    x,y:integer;
begin
  b:=NewBitmap(0,0);
  b.assign(Src);
  for y:=0 to b.height-1 do begin
    p:=b.scanline[y];
    if (y mod 2)=0 then begin
    for x:=0 to b.width-1 do
      if (x mod 2)=0 then begin
        p[x*3]:=$FF;
        p[x*3+1]:=$FF;
        p[x*3+2]:=$FF;
        end;
      end
    else begin
    for x:=0 to b.width-1 do begin
        p[x*3]:=$FF;
        p[x*3+1]:=$FF;
        p[x*3+2]:=$FF;
        end;
      end;
     end;
  Dst.Assign(b);
  b.free;
end;

procedure FoldRight(var Src1,Src2,Dst: PBitmap; Amount: extended);
var
   w,h,x,y,xf,xf0:integer;
   ps1,ps2,pd:pbytearray;
begin
 Src1.PixelFormat:=pf24bit;
 Src2.PixelFormat:=pf24bit; 
 w:=Src1.width;
 h:=Src2.height;
 Dst.width:=w;
 Dst.height:=h;
 Dst.PixelFormat:=pf24bit;
 xf:=round(Amount*w);
 for y:=0 to h-1 do begin
  ps1:=Src1.ScanLine [y];
  ps2:=Src2.scanline[y];
  pd:=Dst.scanline[y];
  for x:=0 to xf do begin
    xf0:=xf+(xf-x);
    if xf0<w then begin
      pd[xf0*3]:=ps1[x*3];
      pd[xf0*3+1]:=ps1[x*3+1];
      pd[xf0*3+2]:=ps1[x*3+2];
      pd[x*3]:=ps2[x*3];
      pd[x*3+1]:=ps2[x*3+1];
      pd[x*3+2]:=ps2[x*3+2];
      end;
    end;
  if (2*xf)<w-1 then
   for x:=2*xf+1 to w-1 do begin
      pd[x*3]:=ps1[x*3];
      pd[x*3+1]:=ps1[x*3+1];
      pd[x*3+2]:=ps1[x*3+2];
    end;
  end;
end;

procedure KeepBlue(var Src: PBitmap; Factor: extended);
var x,y,w,h:integer;
    p0:pbytearray;
begin
  Src.PixelFormat:=pf24bit;
  w:=Src.width;
  h:=Src.height;
  for y:=0 to h-1 do begin
    p0:=Src.scanline[y];
   for x:=0 to w-1 do begin
    p0[x*3]:=round(factor*p0[x*3]);
    p0[x*3+1]:=0;
    p0[x*3+2]:=0;
    end;
   end;
end;

procedure KeepGreen(var Src: PBitmap; Factor: extended);
var x,y,w,h:integer;
    p0:pbytearray;
begin
  Src.PixelFormat:=pf24bit;
  w:=Src.width;
  h:=Src.height;
  for y:=0 to h-1 do begin
    p0:=Src.scanline[y];
   for x:=0 to w-1 do begin
    p0[x*3+1]:=round(factor*p0[x*3+1]);
    p0[x*3]:=0;
    p0[x*3+2]:=0;
    end;
   end;
end;

procedure KeepRed(var Src: PBitmap; Factor: extended);
var x,y,w,h:integer;
    p0:pbytearray;
begin
  Src.PixelFormat:=pf24bit;
  w:=Src.width;
  h:=Src.height;
  for y:=0 to h-1 do begin
    p0:=Src.scanline[y];
   for x:=0 to w-1 do begin
    p0[x*3+2]:=round(factor*p0[x*3+2]);
    p0[x*3+1]:=0;
    p0[x*3]:=0;
    end;
   end;
end;

procedure ShakeVert(var Src,Dst: PBitmap; Factor: extended);
var x,y,h,w,dx:integer;
    p:pbytearray;
begin
 Dst.assign(Src);
 Dst.pixelformat:=pf24bit;
 w:=Dst.Width;
 h:=Dst.height;
 dx:=round(factor*w);
 if dx=0 then exit;
 if dx>(w div 2) then exit;
 for y:=0 to h-1 do begin
   p:=Dst.scanline[y];
   if (y mod 2)=0 then
   for x:=dx to w-1 do begin
     p[(x-dx)*3]:=p[x*3];
     p[(x-dx)*3+1]:=p[x*3+1];
     p[(x-dx)*3+2]:=p[x*3+2];
     end
   else
   for x:=w-1 downto dx do begin
     p[x*3]:=p[(x-dx)*3];
     p[x*3+1]:=p[(x-dx)*3+1];
     p[x*3+2]:=p[(x-dx)*3+2];
     end;
   end;
end;

procedure ShakeHorz(var Src,Dst: PBitmap; Factor: extended);
var x,y,h,w,dy:integer;
    p,p2,p3:pbytearray;
begin
 Dst.assign(Src);
 Dst.pixelformat:=pf24bit;
 w:=Dst.Width;
 h:=Dst.height;
 dy:=round(factor*h);
 if dy=0 then exit;
 if dy>(h div 2) then exit;
 for y:=dy to h-1 do begin
   p:=Dst.scanline[y];
   p2:=Dst.scanline[y-dy];
   for x:=0 to w-1 do
     if (x mod 2)=0 then
     begin
     p2[x*3]:=p[x*3];
     p2[x*3+1]:=p[x*3+1];
     p2[x*3+2]:=p[x*3+2];
     end;
   end;
 for y:=h-1-dy downto 0 do begin
   p:=Dst.scanline[y];
   p3:=Dst.scanline[y+dy];
   for x:=0 to w-1 do
     if (x mod 2)<>0 then
     begin
     p3[x*3]:=p[x*3];
     p3[x*3+1]:=p[x*3+1];
     p3[x*3+2]:=p[x*3+2];
     end;
   end;
end;

procedure Plasma(var Src1,Src2,Dst: PBitmap; Scale,Turbulence: extended);
var
   cval,sval: array [0..255] of integer;
   i,x,y,w,h,xx,yy:integer;
   Asin,Acos:extended;
   ps1,ps2,pd:pbytearray;
begin
   w:=Src1.width;
   h:=Src1.height;
   if turbulence<10 then turbulence:=10;
   if scale<5 then scale:=5;
   for i:=0 to 255 do begin
     sincos(i/turbulence,Asin,Acos);
     sval[i]:=round(-scale*Asin);
     cval[i]:=round(scale*Acos);
     end;
   for y:=0 to h-1 do begin
      pd:=Dst.scanline[y];
      ps2:=Src2.scanline[y];
     for x:=0 to w-1 do begin
      xx:=x+sval[ps2[x*3]];
      yy:=y+cval[ps2[x*3]];
      if (xx>=0)and(xx<w)and (yy>=0)and(yy<h) then begin
        ps1:=Src1.scanline[yy];
        pd[x*3]:=ps1[xx*3];
        pd[x*3+1]:=ps1[xx*3+1];
        pd[x*3+2]:=ps1[xx*3+2];
        end;
      end;
     end;;
end;

procedure Emboss(var Bmp: PBitmap);
var x,y: Integer;
    p1,p2: Pbytearray;
begin
  for y:=0 to Bmp.Height-2 do
  begin
    p1:=bmp.scanline[y];
    p2:=bmp.scanline[y+1];
    for x:=0 to Bmp.Width-4 do
    begin
      p1[x*3]:=(p1[x*3]+(p2[(x+3)*3] xor $FF)) shr 1;
      p1[x*3+1]:=(p1[x*3+1]+(p2[(x+3)*3+1] xor $FF)) shr 1;
      p1[x*3+2]:=(p1[x*3+2]+(p2[(x+3)*3+2] xor $FF)) shr 1;
    end;
  end;

end;

procedure FilterRed(var Src: PBitmap; Min,Max: byte);
var c,x,y:integer;
    p1:pbytearray;
begin
  for y:=0 to Src.height-1 do
  begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do
    begin
      c:=x*3;
      if (p1[c+2]>Min) and (p1[c+2]<Max) then p1[c+2]:=$FF else p1[c+2]:=0;
      p1[c]:=0;
      p1[c+1]:=0;
      end;
    end;
end;

procedure FilterGreen(var Src: PBitmap; Min,Max: byte);
var c,x,y:integer;
    p1:pbytearray;
begin
  for y:=0 to Src.height-1 do begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do begin
      c:=x*3;
      if (p1[c+1]>Min) and (p1[c+1]<Max) then p1[c+1]:=$FF
        else p1[c+1]:=0;
      p1[c]:=0;
      p1[c+2]:=0;
      end;
    end;
end;

procedure FilterBlue(var Src: PBitmap; Min,Max: byte);
var c,x,y:integer;
    p1:pbytearray;
begin
  for y:=0 to Src.height-1 do begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do begin
      c:=x*3;
      if (p1[c]>Min) and (p1[c]<Max) then p1[c]:=$FF
        else p1[c]:=0;
      p1[c+1]:=0;
      p1[c+2]:=0;
      end;
    end;
end;

procedure FilterXRed(var Src: PBitmap; Min,Max: byte);
var c,x,y:integer;
    p1:pbytearray;
begin
  for y:=0 to Src.height-1 do begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do begin
      c:=x*3;
      if (p1[c+2]>Min) and (p1[c+2]<Max) then p1[c+2]:=$FF
        else p1[c+2]:=0;
      end;
    end;
end;

procedure FilterXGreen(var Src: PBitmap; Min,Max: byte);
var c,x,y:integer;
    p1:pbytearray;
begin
  for y:=0 to Src.height-1 do begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do begin
      c:=x*3;
      if (p1[c+1]>Min) and (p1[c+1]<Max) then p1[c+1]:=$FF
        else p1[c+1]:=0;
      end;
    end;
end;

procedure FilterXBlue(var Src: PBitmap; Min,Max: byte);
var c,x,y:integer;
    p1:pbytearray;
begin
  for y:=0 to Src.height-1 do begin
    p1:=Src.scanline[y];
    for x:=0 to Src.width-1 do begin
      c:=x*3;
      if (p1[c]>Min) and (p1[c]<Max) then p1[c]:=$FF
        else p1[c]:=0;
      end;
    end;
end;

//Just a small function to map the numbers to colors
function ConvertColor(Value: Integer): TColor;
begin
  case Value of
    0: Result:=clBlack;
    1: Result:=clNavy;
    2: Result:=clGreen;
    3: Result:=clAqua;
    4: Result:=clRed;
    5: Result:=clPurple;
    6: Result:=clMaroon;
    7: Result:=clSilver;
    8: Result:=clGray;
    9: Result:=clBlue;
   10: Result:=clLime;
   11: Result:=clOlive;
   12: Result:=clFuchsia;
   13: Result:=clTeal;
   14: Result:=clYellow;
   15: Result:=clWhite;
    else Result:=clWhite;
  end;
end;

procedure Invert(var Src: PBitmap);
begin
  InvertRect(Src.Canvas.Handle,Src.BoundsRect);
end;

procedure MirrorVert(var Src: PBitmap);
var w,h,x,y:integer;
    p:pbytearray;
begin
 w:=Src.width;
 h:=Src.height;
 Src.PixelFormat:=pf24bit;
 for y:=0 to h-1 do begin
  p:=Src.scanline[y];
  for x:=0 to w div 2 do begin
   p[(w-1-x)*3]:= p[x*3];
   p[(w-1-x)*3+1]:= p[x*3+1];
   p[(w-1-x)*3+2]:= p[x*3+2];
   end;
  end;
end;

procedure MirrorHorz(var Src: PBitmap);
var w,h,x,y:integer;
    p1,p2:pbytearray;
begin
w:=Src.width;
h:=Src.height;
Src.PixelFormat :=pf24bit;
 for y:=0 to h div 2 do begin
  p1:=Src.scanline[y];
  p2:=Src.scanline[h-1-y];
  for x:=0 to w-1  do begin
   p2[x*3]:= p1[x*3];
   p2[x*3+1]:= p1[x*3+1];
   p2[x*3+2]:= p1[x*3+2];
   end;
  end;
end;

// resample image as triangles
procedure Triangles(var Src: PBitmap; Amount: integer);
type
  TTriplet = record
    r,g,b:byte;
  end;
var w,h,x,y,tb,tm,te:integer;
    ps:pbytearray;
    T:ttriplet;
begin
 w:=Src.width;
 h:=Src.height;
 Src.PixelFormat:=pf24bit;
 if Amount<5 then Amount:=5;
 Amount:= (Amount div 2)*2+1;
 tm:=Amount div 2;
 for y:=0 to h-1 do begin
  ps:=Src.scanline[y];
  t.r:=ps[0];
  t.g:=ps[1];
  t.b:=ps[2];
  tb:=y mod (Amount-1);
  if tb>tm then tb:=2*tm-tb;
  if tb=0 then tb:=Amount;
  te:=tm+abs(tm-(y mod Amount));
  for x:=0 to w-1 do begin
    if (x mod tb)=0 then begin
     t.r :=ps[x*3];
     t.g:=ps[x*3+1];
     t.b:=ps[x*3+2];
     end;
    if ((x mod te)=1)and(tb<>0) then begin
     t.r :=ps[x*3];
     t.g:=ps[x*3+1];
     t.b:=ps[x*3+2];
     end;
    ps[x*3]:=t.r;
    ps[x*3+1]:=t.g;
    ps[x*3+2]:=t.b;
    end;
  end;
end;

procedure RippleTooth(var Src: PBitmap; Amount: integer);
var
  x,y : integer;
  P1,P2 : PByteArray;
  b:byte;
begin
  Src.PixelFormat:=pf24bit;
  Amount:=Min(Src.height div 2,Amount);
    for y:=Src.height -1-Amount downto 0 do begin
      P1:=Src.ScanLine[y];
      b:=0;
      for x:=0 to Src.width-1 do begin
        P2:=Src.scanline[y+b];
        P2[x*3]:=P1[x*3];
        P2[x*3+1]:=P1[x*3+1];
        P2[x*3+2]:=P1[x*3+2];
        inc(b);
        if b>Amount then b:=0;
        end;
    end;
end;

procedure RippleTriangle(var Src: PBitmap; Amount: integer);
var
  x,y : integer;
  P1,P2 : PByteArray;
  b:byte;
  doinc:boolean;
begin
  Amount:=Min(Src.height div 2,Amount);
    for y:=Src.height -1-Amount downto 0 do begin
      P1:=Src.ScanLine[y];
      b:=0;
      doinc:=true;
      for x:=0 to Src.width-1 do begin
        P2:=Src.scanline[y+b];
        P2[x*3]:=P1[x*3];
        P2[x*3+1]:=P1[x*3+1];
        P2[x*3+2]:=P1[x*3+2];
        if doinc then begin
          inc(b);
          if b>Amount then begin
             doinc:=false;
             b:=Amount-1;
             end;
          end
          else begin
           if b=0 then begin
             doinc:=true;
             b:=2;
             end;
           dec(b);
           end;
        end;
    end;
end;

procedure RippleRandom(var Src: PBitmap; Amount: integer);
var
  x,y : integer;
  P1,P2 : PByteArray;
  b:byte;
begin
  Amount:=Min(Src.height div 2,Amount);
  Src.PixelFormat :=pf24bit;
  randomize;
    for y:=Src.height -1-Amount downto 0 do begin
      P1:=Src.ScanLine[y];
      b:=0;
      for x:=0 to Src.width-1 do begin
        P2:=Src.scanline[y+b];
        P2[x*3]:=P1[x*3];
        P2[x*3+1]:=P1[x*3+1];
        P2[x*3+2]:=P1[x*3+2];
        b:=random(Amount);
        end;
    end;
end;

procedure TexturizeOverlap(var Src: PBitmap; Amount: integer);
var w,h,x,y,xo:integer;
    bm:PBitmap;
    arect:trect;
begin
Amount:=Min(Src.width div 2,Amount);
Amount:=Min(Src.height div 2,Amount);
xo:=round(Amount*2/3);
bm:=NewBitmap(Amount,Amount);
w:=Src.width;
h:=Src.height;
arect:=rect(0,0,Amount,Amount);
Src.StretchDraw(bm.Canvas.Handle,arect);
y:=0;
repeat
  x:=0;
  repeat
  bm.Draw(Src.Canvas.Handle,x,y);
  x:=x+xo;
  until x>=w;
  y:=y+xo;
until y>=h;
bm.free;
end;

procedure TexturizeTile(var Src: PBitmap; Amount: integer);
var w,h,x,y:integer;
    bm:PBitmap;
    arect:trect;
begin
Amount:=Min(Src.width div 2,Amount);
Amount:=Min(Src.height div 2,Amount);
bm:=NewBitmap(Amount,Amount);
w:=Src.width;
h:=Src.height;
arect:=rect(0,0,Amount,Amount);
Src.StretchDraw(bm.Canvas.Handle,arect);
y:=0;
repeat
  x:=0;
  repeat
  bm.Draw(Src.Canvas.Handle,x,y);
  x:=x+bm.width;
  until x>=w;
  y:=y+bm.height;
until y>=h;
bm.free;
end;

procedure HeightMap(var Src: PBitmap; Amount: integer);
var bm:PBitmap;
    w,h,x,y:integer;
    pb,ps:pbytearray;
    c:integer;
begin
 h:=Src.height;
 w:=Src.width;
 bm:=NewBitmap(w,h);
 bm.PixelFormat:=pf24bit;
 Src.PixelFormat:=pf24bit;
 Src.Draw(bm.Canvas.Handle,0,0);
 for y:=0 to h-1 do begin
   pb:=bm.ScanLine[y];
  for x:=0 to w-1 do begin
   c:=round((pb[x*3]+pb[x*3+1]+pb[x*3+2])/3/255*Amount);
   if (y-c)>=0 then begin
     ps:=Src.ScanLine[y-c];
     ps[x*3]:=pb[x*3];
     ps[x*3+1]:=pb[x*3+1];
     ps[x*3+2]:=pb[x*3+2];
     end;
   end;
  end;
bm.free;
end;

procedure ExtractColor(var Src: PBitmap; Acolor: TColor);
var w,h,x,y:integer;
    p:pbytearray;
    Ecolor:TColor;
    r,g,b:byte;
begin
 w:=Src.width;
 h:=Src.height;
 Ecolor:=color2rgb(Acolor);
 r:=getRValue(Ecolor);
 g:=getGValue(Ecolor);
 b:=getBValue(Ecolor);
 Src.PixelFormat:=pf24bit;
 for y:=0 to h-1 do begin
  p:=Src.ScanLine[y];
  for x:=0 to w-1 do begin
   if ((p[x*3]<>b) or (p[x*3+1]<>g) or (p[x*3+2]<>r)) then begin
    p[x*3]:=$00;
    p[x*3+1]:=$00;
    p[x*3+2]:=$00;
    end;
   end
  end;
end;

procedure ExcludeColor(var Src: PBitmap; Acolor: TColor);
var w,h,x,y:integer;
    p:pbytearray;
    Ecolor:TColor;
    r,g,b:byte;
begin
 w:=Src.width;
 h:=Src.height;
 Ecolor:=color2rgb(Acolor);
 r:=getRValue(Ecolor);
 g:=getGValue(Ecolor);
 b:=getBValue(Ecolor);
 Src.PixelFormat:=pf24bit;
 for y:=0 to h-1 do begin
  p:=Src.ScanLine[y];
  for x:=0 to w-1 do begin
   if ((p[x*3]=b) and (p[x*3+1]=g) and (p[x*3+2]=r)) then begin
    p[x*3]:=$00;
    p[x*3+1]:=$00;
    p[x*3+2]:=$00;
    end;
   end
  end;
end;

procedure Blend(var Src1,Src2,Dst: PBitmap; Amount: extended);
var w,h,x,y:integer;
    ps1,ps2,pd:pbytearray;
begin
w:=Src1.Width;
h:=Src1.Height;
Dst.Width:=w;
Dst.Height:=h;
Src1.PixelFormat:=pf24bit;
Src2.PixelFormat:=pf24bit;
Dst.PixelFormat:=pf24bit;
for y:=0 to h-1 do begin
 ps1:=Src1.ScanLine[y];
 ps2:=Src2.ScanLine[y];
 pd:=Dst.ScanLine[y];
 for x:=0 to w-1 do begin
  pd[x*3]:=round((1-Amount)*ps1[x*3]+Amount*ps2[x*3]);
  pd[x*3+1]:=round((1-Amount)*ps1[x*3+1]+Amount*ps2[x*3+1]);
  pd[x*3+2]:=round((1-Amount)*ps1[x*3+2]+Amount*ps2[x*3+2]);
  end;
 end;
end;

procedure Solarize(var Src,Dst: PBitmap; Amount: integer);
var w,h,x,y:integer;
    ps,pd:pbytearray;
    c:integer;
begin
  w:=Src.width;
  h:=Src.height;
  Src.PixelFormat:=pf24bit;
  Dst.PixelFormat:=pf24bit;
  for y:=0 to h-1 do begin
   ps:=Src.scanline[y];
   pd:=Dst.scanline[y];
   for x:=0 to w-1 do begin
    c:=(ps[x*3]+ps[x*3+1]+ps[x*3+2]) div 3;
    if c>Amount then begin
     pd[x*3]:= 255-ps[x*3];
     pd[x*3+1]:=255-ps[x*3+1];
     pd[x*3+2]:=255-ps[x*3+2];
     end
     else begin
     pd[x*3]:=ps[x*3];
     pd[x*3+1]:=ps[x*3+1];
     pd[x*3+2]:=ps[x*3+2];
     end;
    end;
   end;
end;

procedure Posterize(var Src,Dst: PBitmap; Amount: integer);
var w,h,x,y:integer;
    ps,pd:pbytearray;
begin
  w:=Src.width;
  h:=Src.height;
  Src.PixelFormat:=pf24bit;
  Dst.PixelFormat:=pf24bit;
  for y:=0 to h-1 do begin
   ps:=Src.scanline[y];
   pd:=Dst.scanline[y];
   for x:=0 to w-1 do begin
     pd[x*3]:= round(ps[x*3]/Amount)*Amount;
     pd[x*3+1]:=round(ps[x*3+1]/Amount)*Amount;
     pd[x*3+2]:=round(ps[x*3+2]/Amount)*Amount;
    end;
   end;
end;

{This just forces a value to be 0 - 255 for rgb purposes.  I used asm in an
 attempt at speed, but I don't think it helps much.}
function Set255(Clr: integer): integer;
asm
  MOV  EAX,Clr  // store value in EAX register (32-bit register)
  CMP  EAX,254  // compare it to 254
  JG   @SETHI   // if greater than 254 then go set to 255 (Max value)
  CMP  EAX,1    // if less than 255, compare to 1
  JL   @SETLO   // if less than 1 go set to 0 (Min value)
  RET           // otherwise it doesn't change, just exit
@SETHI:         // Set value to 255
  MOV  EAX,255  // Move 255 into the EAX register
  RET           // Exit (result value is the EAX register value)
@SETLO:         // Set value to 0
  MOV  EAX,0    // Move 0 into EAX register
end;            // Result is in EAX

{The Expand version of a 3 x 3 convolution.

 This approach is similar to the mirror version, except that it copies
 or duplicates the pixels from the edges to the same edge.  This is
 probably the best version if you're interested in quality, but don't need
 a tiled (seamless) image. }

procedure ConvolveE(Ray: array of integer; Z: word; var aBmp: PBitmap);
var
  O,T,C,B: pRGBArray;  // Scanlines
  x,y: integer;
  tBufr: PBitmap; // temp bitmap for 'enlarged' image
begin
  tBufr:=NewBitmap(aBmp.Width+2,aBmp.Height+2); // Add a box around the outside...
  tBufr.PixelFormat:=pf24bit;
  O:=tBufr.ScanLine[0];   // Copy top corner pixels
  T:=aBmp.ScanLine[0];
  O[0]:=T[0];  // Left
  O[tBufr.Width-1]:=T[aBmp.Width-1];  // Right
  // Copy top lines
  tBufr.Canvas.CopyRect(Rect(1,0,tBufr.Width-1,1),aBmp.Canvas,Rect(0,0,aBmp.Width,1));
  O:=tBufr.ScanLine[tBufr.Height-1]; // Copy bottom corner pixels
  T:=aBmp.ScanLine[aBmp.Height-1];
  O[0]:=T[0];
  O[tBufr.Width-1]:=T[aBmp.Width-1];
  // Copy bottoms
  tBufr.Canvas.CopyRect(RECT(1,tBufr.Height-1,tBufr.Width - 1,tBufr.Height),
         aBmp.Canvas,RECT(0,aBmp.Height-1,aBmp.Width,aBmp.Height));
  // Copy rights
  tBufr.Canvas.CopyRect(RECT(tBufr.Width-1,1,tBufr.Width,tBufr.Height-1),
         aBmp.Canvas,RECT(aBmp.Width-1,0,aBmp.Width,aBmp.Height));
  // Copy lefts
  tBufr.Canvas.CopyRect(RECT(0,1,1,tBufr.Height-1),
         aBmp.Canvas,RECT(0,0,1,aBmp.Height));
  // Now copy main rectangle
  tBufr.Canvas.CopyRect(RECT(1,1,tBufr.Width - 1,tBufr.Height - 1),
    aBmp.Canvas,RECT(0,0,aBmp.Width,aBmp.Height));
  // bmp now enlarged and copied, apply convolve
  for x:=0 to aBmp.Height - 1 do begin  // Walk scanlines
    O:=aBmp.ScanLine[x];      // New Target (Original)
    T:=tBufr.ScanLine[x];     //old x-1  (Top)
    C:=tBufr.ScanLine[x+1];   //old x    (Center)
    B:=tBufr.ScanLine[x+2];   //old x+1  (Bottom)
  // Now do the main piece
    for y:=1 to (tBufr.Width - 2) do begin  // Walk pixels
      O[y-1].rgbtRed:=Set255(
          ((T[y-1].rgbtRed*ray[0]) +
          (T[y].rgbtRed*ray[1])+(T[y+1].rgbtRed*ray[2]) +
          (C[y-1].rgbtRed*ray[3]) +
          (C[y].rgbtRed*ray[4])+(C[y+1].rgbtRed*ray[5])+
          (B[y-1].rgbtRed*ray[6]) +
          (B[y].rgbtRed*ray[7])+(B[y+1].rgbtRed*ray[8])) div z
          );
      O[y-1].rgbtBlue:=Set255(
          ((T[y-1].rgbtBlue*ray[0]) +
          (T[y].rgbtBlue*ray[1])+(T[y+1].rgbtBlue*ray[2]) +
          (C[y-1].rgbtBlue*ray[3]) +
          (C[y].rgbtBlue*ray[4])+(C[y+1].rgbtBlue*ray[5])+
          (B[y-1].rgbtBlue*ray[6]) +
          (B[y].rgbtBlue*ray[7])+(B[y+1].rgbtBlue*ray[8])) div z
          );
      O[y-1].rgbtGreen:=Set255(
          ((T[y-1].rgbtGreen*ray[0]) +
          (T[y].rgbtGreen*ray[1])+(T[y+1].rgbtGreen*ray[2]) +
          (C[y-1].rgbtGreen*ray[3]) +
          (C[y].rgbtGreen*ray[4])+(C[y+1].rgbtGreen*ray[5])+
          (B[y-1].rgbtGreen*ray[6]) +
          (B[y].rgbtGreen*ray[7])+(B[y+1].rgbtGreen*ray[8])) div z
          );
    end;
  end;
  tBufr.Free;
end;

{The Ignore (basic) version of a 3 x 3 convolution.

 The 3 x 3 convolve uses the eight surrounding pixels as part of the
 calculation.  But, for the pixels on the edges, there is nothing to use
 for the top row values.  In other words, the leftmost pixel in the 3rd
 row, or scanline, has no pixels on its left to use in the calculations.
 This version just ignores the outermost edge of the image, and doesn't
 alter those pixels at all.  Repeated applications of filters will
 eventually cause a pronounced 'border' effect, as those pixels never
 change but all others do. However, this version is simpler, and the
 logic is easier to follow.  It's the fastest of the three in this
 application, and works great if the 'borders' are not an issue. }

procedure ConvolveI(Ray: array of integer; Z: word; var aBmp: PBitmap);
var
  O,T,C,B: pRGBArray;  // Scanlines
  x,y: integer;
  tBufr: PBitmap; // temp bitmap
begin
  tBufr:=NewBitmap(0,0);
  CopyMe(tBufr,aBmp);
  for x:=1 to aBmp.Height-2 do begin  // Walk scanlines
    O:=aBmp.ScanLine[x];      // New Target (Original)
    T:=tBufr.ScanLine[x-1];     //old x-1  (Top)
    C:=tBufr.ScanLine[x];   //old x    (Center)
    B:=tBufr.ScanLine[x+1];   //old x+1  (Bottom)
  // Now do the main piece
    for y:=1 to (tBufr.Width-2) do begin  // Walk pixels
      O[y].rgbtRed:=Set255(
          ((T[y-1].rgbtRed*ray[0])+
          (T[y].rgbtRed*ray[1])+(T[y+1].rgbtRed*ray[2])+
          (C[y-1].rgbtRed*ray[3])+
          (C[y].rgbtRed*ray[4])+(C[y+1].rgbtRed*ray[5])+
          (B[y-1].rgbtRed*ray[6])+
          (B[y].rgbtRed*ray[7])+(B[y+1].rgbtRed*ray[8])) div z);
      O[y].rgbtBlue:=Set255(
          ((T[y-1].rgbtBlue*ray[0])+
          (T[y].rgbtBlue*ray[1])+(T[y+1].rgbtBlue*ray[2])+
          (C[y-1].rgbtBlue*ray[3])+
          (C[y].rgbtBlue*ray[4])+(C[y+1].rgbtBlue*ray[5])+
          (B[y-1].rgbtBlue*ray[6])+
          (B[y].rgbtBlue*ray[7])+(B[y+1].rgbtBlue*ray[8])) div z);
      O[y].rgbtGreen:=Set255(
          ((T[y-1].rgbtGreen*ray[0])+
          (T[y].rgbtGreen*ray[1])+(T[y+1].rgbtGreen*ray[2])+
          (C[y-1].rgbtGreen*ray[3])+
          (C[y].rgbtGreen*ray[4])+(C[y+1].rgbtGreen*ray[5])+
          (B[y-1].rgbtGreen*ray[6])+
          (B[y].rgbtGreen*ray[7])+(B[y+1].rgbtGreen*ray[8])) div z);
    end;
  end;
  tBufr.Free;
end;

{The mirror version of a 3 x 3 convolution.

 The 3 x 3 convolve uses the eight surrounding pixels as part of the
 calculation.  But, for the pixels on the edges, there is nothing to use
 for the top row values.  In other words, the leftmost pixel in the 3rd
 row, or scanline, has no pixels on its left to use in the calculations.
 I compensate for this by increasing the size of the bitmap by one pixel
 on top, left, bottom, and right.  The mirror version is used in an
 application that creates seamless tiles, so I copy the opposite sides to
 maintain the seamless integrity.  }
procedure ConvolveM(Ray: array of integer; Z: word; var aBmp: PBitmap);
var
  O,T,C,B: pRGBArray;  // Scanlines
  x,y: integer;
  tBufr: PBitmap; // temp bitmap for 'enlarged' image
begin
  tBufr:=NewBitmap(aBmp.Width+2,aBmp.Height+2);  // Add a box around the outside...
  tBufr.PixelFormat:=pf24bit;
  O:=tBufr.ScanLine[0];   // Copy top corner pixels
  T:=aBmp.ScanLine[0];
  O[0]:=T[0];  // Left
  O[tBufr.Width-1]:=T[aBmp.Width-1];  // Right
  // Copy bottom line to our top - trying to remain seamless...
  tBufr.Canvas.CopyRect(Rect(1,0,tBufr.Width-1,1),aBmp.Canvas,Rect(0,aBmp.Height-1,aBmp.Width,aBmp.Height-2));
  O:=tBufr.ScanLine[tBufr.Height-1]; // Copy bottom corner pixels
  T:=aBmp.ScanLine[aBmp.Height-1];
  O[0]:=T[0];
  O[tBufr.Width-1]:=T[aBmp.Width-1];
  // Copy top line to our bottom
  tBufr.Canvas.CopyRect(Rect(1,tBufr.Height-1,tBufr.Width-1,tBufr.Height),aBmp.Canvas,Rect(0,0,aBmp.Width,1));
  // Copy left to our right
  tBufr.Canvas.CopyRect(RECT(tBufr.Width-1,1,tBufr.Width,tBufr.Height-1),
         aBmp.Canvas,RECT(0,0,1,aBmp.Height));
  // Copy right to our left
  tBufr.Canvas.CopyRect(RECT(0,1,1,tBufr.Height-1),
         aBmp.Canvas,RECT(aBmp.Width - 1,0,aBmp.Width,aBmp.Height));
  // Now copy main rectangle
  tBufr.Canvas.CopyRect(RECT(1,1,tBufr.Width - 1,tBufr.Height - 1),
    aBmp.Canvas,RECT(0,0,aBmp.Width,aBmp.Height));
  // bmp now enlarged and copied, apply convolve
  for x:=0 to aBmp.Height-1 do begin  // Walk scanlines
    O:=aBmp.ScanLine[x];      // New Target (Original)
    T:=tBufr.ScanLine[x];     //old x-1  (Top)
    C:=tBufr.ScanLine[x+1];   //old x    (Center)
    B:=tBufr.ScanLine[x+2];   //old x+1  (Bottom)
  // Now do the main piece
    for y:=1 to (tBufr.Width-2) do begin  // Walk pixels
      O[y-1].rgbtRed:=Set255(
          ((T[y-1].rgbtRed*ray[0])+
          (T[y].rgbtRed*ray[1])+(T[y+1].rgbtRed*ray[2])+
          (C[y-1].rgbtRed*ray[3]) +
          (C[y].rgbtRed*ray[4])+(C[y+1].rgbtRed*ray[5])+
          (B[y-1].rgbtRed*ray[6]) +
          (B[y].rgbtRed*ray[7])+(B[y+1].rgbtRed*ray[8])) div z
          );
      O[y-1].rgbtBlue:=Set255(
          ((T[y-1].rgbtBlue*ray[0])+
          (T[y].rgbtBlue*ray[1])+(T[y+1].rgbtBlue*ray[2])+
          (C[y-1].rgbtBlue*ray[3]) +
          (C[y].rgbtBlue*ray[4])+(C[y+1].rgbtBlue*ray[5])+
          (B[y-1].rgbtBlue*ray[6]) +
          (B[y].rgbtBlue*ray[7])+(B[y+1].rgbtBlue*ray[8])) div z
          );
      O[y-1].rgbtGreen:=Set255(
          ((T[y-1].rgbtGreen*ray[0])+
          (T[y].rgbtGreen*ray[1])+(T[y+1].rgbtGreen*ray[2])+
          (C[y-1].rgbtGreen*ray[3]) +
          (C[y].rgbtGreen*ray[4])+(C[y+1].rgbtGreen*ray[5])+
          (B[y-1].rgbtGreen*ray[6]) +
          (B[y].rgbtGreen*ray[7])+(B[y+1].rgbtGreen*ray[8])) div z
          );
    end;
  end;
  tBufr.Free;
end;

procedure Seamless(var Src: PBitmap; Depth: byte);
var
  p1,p2:pbytearray;
  w,w3,h,x,x3,y:integer;
  am,Amount:extended;
begin
  w:=Src.width;
  h:=Src.height;
  Src.PixelFormat:=pf24bit;
  if depth=0 then exit;
  am:=1/depth;
  for y:=0 to depth do
  begin
    p1:=Src.ScanLine[y];
    p2:=Src.ScanLine[h-y-1];
    Amount:=1-y*am;
    for x:=y to w-1-y do
    begin
      x3:=x*3;
      p2[x3]:=round((1-Amount)*p2[x3]+Amount*p1[x3]);
      p2[x3+1]:=round((1-Amount)*p2[x3+1]+Amount*p1[x3+1]);
      p2[x3+2]:=round((1-Amount)*p2[x3+2]+Amount*p1[x3+2]);
    end;
    for x:=0 to y do
    begin
      Amount:=1-x*am;
      x3:=x*3;
      w3:=(w-1-x)*3;
      p1[w3]:=round((1-Amount)*p1[w3]+Amount*p1[x3]);
      p1[w3+1]:=round((1-Amount)*p1[w3+1]+Amount*p1[x3+1]);
      p1[w3+2]:=round((1-Amount)*p1[w3+2]+Amount*p1[x3+2]);
      p2[w3]:=round((1-Amount)*p2[w3]+Amount*p2[x3]);
      p2[w3+1]:=round((1-Amount)*p2[w3+1]+Amount*p2[x3+1]);
      p2[w3+2]:=round((1-Amount)*p2[w3+2]+Amount*p2[x3+2]);
    end;
  end;
  for y:=depth to h-1-depth do
  begin
    p1:=Src.ScanLine[y];
    for x:=0 to depth do
    begin
      x3:=x*3;
      w3:=(w-1-x)*3;
      Amount:=1-x*am;
      p1[w3]:=round((1-Amount)*p1[w3]+Amount*p1[x3]);
      p1[w3+1]:=round((1-Amount)*p1[w3+1]+Amount*p1[x3+1]);
      p1[w3+2]:=round((1-Amount)*p1[w3+2]+Amount*p1[x3+2]);
    end;
  end;
end;

procedure Button(var Src: PBitmap; Depth: byte; Weight: integer);
var
  p1,p2:pbytearray;
  w,w3,h,x,x3,y:integer;
  a,r,g,b: Integer;
begin
  a:=weight;
  w:=Src.width;
  h:=Src.height;
  Src.PixelFormat:=pf24bit;
  if depth=0 then exit;
  for y:=0 to depth do
  begin
    p1:=Src.ScanLine[y];
    p2:=Src.ScanLine[h-y-1];
    for x:=y to w-1-y do
    begin
      x3:=x*3;
// lighter
      r:=p1[x3];
      g:=p1[x3+1];
      b:=p1[x3+2];
      p1[x3]:=Int2Byte(r+((255-r)*a) div 255);
      p1[x3+1]:=Int2Byte(g+((255-g)*a) div 255);
      p1[x3+2]:=Int2Byte(b+((255-b)*a) div 255);
// darker
      r:=p2[x3];
      g:=p2[x3+1];
      b:=p2[x3+2];
      p2[x3]:=Int2Byte(r-((r)*a) div 255);
      p2[x3+1]:=Int2Byte(g-((g)*a) div 255);
      p2[x3+2]:=Int2Byte(b-((b)*a) div 255);
    end;
    for x:=0 to y do
    begin
      x3:=x*3;
      w3:=(w-1-x)*3;
// lighter left
      r:=p1[x3];
      g:=p1[x3+1];
      b:=p1[x3+2];
      p1[x3]:=Int2Byte(r+((255-r)*a) div 255);
      p1[x3+1]:=Int2Byte(g+((255-g)*a) div 255);
      p1[x3+2]:=Int2Byte(b+((255-b)*a) div 255);
// darker right
      r:=p1[w3];
      g:=p1[w3+1];
      b:=p1[w3+2];
      p1[w3]:=Int2Byte(r-((r)*a) div 255);
      p1[w3+1]:=Int2Byte(g-((g)*a) div 255);
      p1[w3+2]:=Int2Byte(b-((b)*a) div 255);
// lighter bottom left
      r:=p2[x3];
      g:=p2[x3+1];
      b:=p2[x3+2];
      p2[x3]:=Int2Byte(r+((255-r)*a) div 255);
      p2[x3+1]:=Int2Byte(g+((255-g)*a) div 255);
      p2[x3+2]:=Int2Byte(b+((255-b)*a) div 255);
// darker bottom right
      r:=p2[w3];
      g:=p2[w3+1];
      b:=p2[w3+2];
      p2[w3]:=Int2Byte(r-((r)*a) div 255);
      p2[w3+1]:=Int2Byte(g-((g)*a) div 255);
      p2[w3+2]:=Int2Byte(b-((b)*a) div 255);
    end;
  end;
  for y:=depth+1 to h-2-depth do
  begin
    p1:=Src.ScanLine[y];
    for x:=0 to depth do
    begin
      x3:=x*3;
      w3:=(w-1-x)*3;
// lighter left
      r:=p1[x3];
      g:=p1[x3+1];
      b:=p1[x3+2];
      p1[x3]:=Int2Byte(r+((255-r)*a) div 255);
      p1[x3+1]:=Int2Byte(g+((255-g)*a) div 255);
      p1[x3+2]:=Int2Byte(b+((255-b)*a) div 255);
// darker right
      r:=p1[w3];
      g:=p1[w3+1];
      b:=p1[w3+2];
      p1[w3]:=Int2Byte(r-((r)*a) div 255);
      p1[w3+1]:=Int2Byte(g-((g)*a) div 255);
      p1[w3+2]:=Int2Byte(b-((b)*a) div 255);
    end;
  end;
end;

procedure ConvolveFilter(var Src: PBitmap; Filternr,Edgenr: integer);
var
  z: integer;
  ray: array [0..8] of integer;
  OrigBMP: PBitmap;              // Bitmap for temporary use
begin
  z:=1;  // just to avoid compiler warnings!
  case filternr of
    0: begin // Laplace
      ray[0]:=-1; ray[1]:=-1; ray[2]:=-1;
      ray[3]:=-1; ray[4]:=8; ray[5]:=-1;
      ray[6]:=-1; ray[7]:=-1; ray[8]:=-1;
      z:=1;
      end;
    1: begin  // Hipass
      ray[0]:=-1; ray[1]:=-1; ray[2]:=-1;
      ray[3]:=-1; ray[4]:=9; ray[5]:=-1;
      ray[6]:=-1; ray[7]:=-1; ray[8]:=-1;
      z:=1;
      end;
    2: begin  // Find Edges (top down)
      ray[0]:=1; ray[1]:=1; ray[2]:=1;
      ray[3]:=1; ray[4]:=-2; ray[5]:=1;
      ray[6]:=-1; ray[7]:=-1; ray[8]:=-1;
      z:=1;
      end;
    3: begin  // Sharpen
      ray[0]:=-1; ray[1]:=-1; ray[2]:=-1;
      ray[3]:=-1; ray[4]:=16; ray[5]:=-1;
      ray[6]:=-1; ray[7]:=-1; ray[8]:=-1;
      z:=8;
      end;
    4 : begin  // Edge Enhance
      ray[0]:=0; ray[1]:=-1; ray[2]:=0;
      ray[3]:=-1; ray[4]:=5; ray[5]:=-1;
      ray[6]:=0; ray[7]:=-1; ray[8]:=0;
      z:=1;
      end;
    5: begin  // Color Emboss (Sorta)
      ray[0]:=1; ray[1]:=0; ray[2]:=1;
      ray[3]:=0; ray[4]:=0; ray[5]:=0;
      ray[6]:=1; ray[7]:=0; ray[8]:=-2;
      z:=1;
      end;
    6: begin  // Soften
      ray[0]:=2; ray[1]:=2; ray[2]:=2;
      ray[3]:=2; ray[4]:=0; ray[5]:=2;
      ray[6]:=2; ray[7]:=2; ray[8]:=2;
      z:=16;
      end;
    7 : begin  // Blur
      ray[0]:=3; ray[1]:=3; ray[2]:=3;
      ray[3]:=3; ray[4]:=8; ray[5]:=3;
      ray[6]:=3; ray[7]:=3; ray[8]:=3;
      z:=32;
      end;
    8: begin  // Soften less
      ray[0]:=0; ray[1]:=1; ray[2]:=0;
      ray[3]:=1; ray[4]:=2; ray[5]:=1;
      ray[6]:=0; ray[7]:=1; ray[8]:=0;
      z:=6;
      end;
    else exit;
  end;
  OrigBMP:=NewBitmap(0,0);  // Copy image to 24-bit bitmap
  CopyMe(OrigBMP,Src);
  case Edgenr of
    0: ConvolveM(ray,z,OrigBMP);
    1: ConvolveE(ray,z,OrigBMP);
    2: ConvolveI(ray,z,OrigBMP);
  end;
  Src.Assign(OrigBMP);  //  Assign filtered image to Image1
  OrigBMP.Free;
end;

procedure ButtonOval(var Src: PBitmap; Depth: byte; Weight: integer; Rim: TRim);
var
  p0,p1,p2,p3:pbytearray;
  w,w3,h,i,x,x3,y,w2,h2:integer;
  am,Amount:extended;
  fac,a,r,g,b,r2,g2,b2: Integer;
  contour:PBitmap;
  biclight,bicdark,bicnone:byte;
  act:boolean;
begin
  a:=weight;
  w:=Src.width;
  h:=Src.height;
  contour:=NewBitmap(w,h);
  contour.PixelFormat:=pf24bit;
  contour.Canvas.brush.color:=clwhite;
  contour.canvas.FillRect(Rect(0,0,w,h));
  begin
  contour.canvas.pen.PenWidth:=1;
  contour.canvas.pen.Penstyle:=pssolid;
    for i:=0 to depth-1 do begin
      if rim=trRimmed then begin
      //  (bottom-right)
        contour.canvas.pen.color:=rgb($00,$02,i);
        contour.canvas.Arc(i,i,w-i,h-i, // ellipse
        0,h, // start
        w,0); // end
      //  (top-left)
        contour.canvas.Pen.Color:=rgb($00,$01,i);
        contour.canvas.Arc(i,i,w-i,h-i, // ellipse
        w,0, // start
        0,h); // end
      end
      else if (rim=trRound) or (rim=trDoubleRound) then begin
      //  (bottom-right)
        contour.canvas.pen.color:=rgb($00,$01,depth-1-i);
        contour.canvas.Arc(i,i,w-i,h-i, // ellipse
        0,h, // start
        w,0); // end
      //  (top-left)
        contour.canvas.Pen.Color:=rgb($00,$02,depth-1-i);
        contour.canvas.Arc(i,i,w-i,h-i, // ellipse
        w,0, // start
        0,h); // end
      end;
    end;
    if rim=trDoubleRound then
      for i:=depth to depth-1+depth do begin
      //  (bottom-right)
        contour.canvas.pen.color:=rgb($00,$02,i);
        contour.canvas.Arc (i,i,w-i,h-i, // ellipse
        0,h, // start
        w,0); // end
      //  (top-left)
        contour.canvas.Pen.Color:=rgb($00,$01,i);
        contour.canvas.Arc(i,i,w-i,h-i, // ellipse
        w,0, // start
        0,h); // end
      end;
  end;
  Src.PixelFormat:=pf24bit;
  for y:=0 to h-1 do
  begin
    p1:=Src.ScanLine[y];
    p2:=contour.scanline[y];
    for x:=0 to w-1 do begin
      x3:=x*3;
      r:=p1[x3];
      g:=p1[x3+1];
      b:=p1[x3+2];
      r2:=p2[x3];
      g2:=p2[x3+1];
      b2:=p2[x3+2];
      fac:=trunc(r2/depth*a);
      if g2=$02 then begin // lighter
        p1[x3]:=Int2Byte(r+((255-r)*fac)div 255);
        p1[x3+1]:=Int2Byte(g+((255-g)*fac)div 255);
        p1[x3+2]:=Int2Byte(b+((255-b)*fac)div 255);
      end
      else if g2=$01 then begin // darker
        p1[x3]:=Int2Byte(r-((r)*fac)div 255);
        p1[x3+1]:=Int2Byte(g-((g)*fac)div 255);
        p1[x3+2]:=Int2Byte(b-((b)*fac)div 255);
      end;
    end;
  end;
  // anti alias
  for y:=1 to h-2 do begin
    p0:=Src.ScanLine[y-1];
    p1:=Src.scanline[y];
    p2:=Src.ScanLine[y+1];
    p3:=contour.scanline[y];
    for x:=1 to w-2 do begin
      g2:=p3[x*3+1];
      if g2<>$00 then begin
        p1[x*3]:=(p0[x*3]+p2[x*3]+p1[(x-1)*3]+p1[(x+1)*3]) div 4;
        p1[x3+1]:=(p0[x*3+1]+p2[x*3+1]+p1[(x-1)*3+1]+p1[(x+1)*3+1]) div 4;
        p1[x*3+2]:=(p0[x*3+2]+p2[x*3+2]+p1[(x-1)*3+2]+p1[(x+1)*3+2]) div 4;
      end;
    end;
  end;
  Contour.Free;
end;

procedure MaskOval(var Src: PBitmap; AColor: TColor);
var
  p1,p2: pbytearray;
  w,h,x,x3,y: integer;
  r,g,b,r2,g2,b2: Integer;
  mr,mg,mb: byte;
  contour: PBitmap;
begin
  AColor:=color2rgb(AColor);
  mr:=getRvalue(AColor);
  mg:=getGvalue(AColor);
  mb:=getBvalue(AColor);
  w:=Src.width;
  h:=Src.height;
  Contour:=NewBitmap(w,h);
  contour.PixelFormat:=pf24bit;
  contour.Canvas.brush.color:=clblack;
  contour.canvas.FillRect(Rect(0,0,w,h));
  contour.canvas.pen.color:=clred;
  contour.canvas.brush.color:=clred;
  contour.canvas.Ellipse(0,0,w,h);
  Src.PixelFormat:=pf24bit;
  for y:=0 to h-1 do
  begin
    p1:=Src.ScanLine[y];
    p2:=Contour.ScanLine[y];
    for x:=0 to w-1 do begin
      x3:=x*3;
      r:=p1[x3];
      g:=p1[x3+1];
      b:=p1[x3+2];
      r2:=p2[x3];
      g2:=p2[x3+1];
      b2:=p2[x3+2];
      if b2=$00 then begin // mask
        p1[x3]:=mb;
        p1[x3+1]:=mg;
        p1[x3+2]:=mr;
      end;
    end;
  end;
  Contour.Free;
end;

end.

