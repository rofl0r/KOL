{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,
  mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    MainMenu1: TKOLMainMenu;
    ScrollBox1: TKOLScrollBox;
    Image: TKOLPaintBox;
    OpenDlg: TKOLOpenSaveDialog;
    procedure KOLForm1N6Menu(Sender: PMenu; Item: Integer);
    procedure ImagePaint(Sender: PControl; DC: HDC);
    procedure KOLForm1N2Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N4Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure MainMenu1N105Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N7Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N8Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N9Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N10Menu(Sender: PMenu; Item: Integer);
    procedure MainMenu1N106Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N12Menu(Sender: PMenu; Item: Integer);
    procedure MainMenu1N17Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N14Menu(Sender: PMenu; Item: Integer);
    procedure MainMenu1N20Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N21Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N22Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N24Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N31Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N33Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N35Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N36Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N37Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N38Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N39Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N40Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N42Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N45Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N46Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N49Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N57Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N62Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N61Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N63Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N64Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N66Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N69Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N72Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N73Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N75Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N80Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N83Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N85Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N87Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N90Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N91Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N92Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N93Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N95Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N97Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N98Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N99Menu(Sender: PMenu; Item: Integer);
    procedure MainMenu1N103Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N104Menu(Sender: PMenu; Item: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  BMP,Undo: PBitmap;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses KOLjanFX;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  BMP:=NewBitmap(0,0);
  Undo:=NewBitmap(0,0);
end;

procedure TForm1.KOLForm1N4Menu(Sender: PMenu; Item: Integer);
begin
  Form.Close;
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  BMP.Free;
  Undo.Free;
end;

procedure TForm1.KOLForm1N2Menu(Sender: PMenu; Item: Integer);
begin
  if OpenDlg.Execute then
    begin
      BMP.LoadFromFile(OpenDlg.Filename);
      MainMenu1.ItemEnabled[5]:=True;
      Image.Invalidate;
    end;
end;

procedure TForm1.ImagePaint(Sender: PControl; DC: HDC);
begin
  if (BMP<>nil) and (BMP.Width>0) and (BMP.Height>0) then
    begin
      Image.Width:=BMP.Width;
      Image.Height:=BMP.Height;
      BMP.Draw(DC,0,0);
    end
  else
    begin
      Sender.Canvas.Brush.Color:=clAppWorkSpace;
      Sender.Canvas.FillRect(Sender.Canvas.ClipRect);
    end;
end;

procedure TForm1.MainMenu1N105Menu(Sender: PMenu; Item: Integer);
begin
  BMP.Assign(Undo);
  Image.Invalidate;
  MainMenu1.ItemEnabled[4]:=False;
end;

procedure TForm1.KOLForm1N6Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  AddColorNoise(BMP,100);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N7Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  AddMonoNoise(BMP,100);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N8Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  AntiAlias(BMP);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N9Menu(Sender: PMenu; Item: Integer);
var B1,B2: PBitmap;
begin
  if OpenDlg.Execute then
    begin
      B1:=NewBitmap(0,0);
      B1.Assign(BMP);
      B2:=NewBitmap(0,0);
      B2.LoadFromFile(OpenDlg.Filename);
      Undo.Assign(BMP);
      MainMenu1.ItemEnabled[4]:=True;
      Blend(B1,B2,BMP,0.333);
      B1.Free;
      B2.Free;
      Image.Invalidate;
    end;
end;

procedure TForm1.KOLForm1N10Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Button(BMP,10,100);
  Image.Invalidate;
end;

procedure TForm1.MainMenu1N106Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    12: ButtonOval(BMP,10,100,trRimmed);
    13: ButtonOval(BMP,10,100,trRound);
    14: ButtonOval(BMP,10,100,trDoubleRound);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N12Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Contrast(BMP,100);
  Image.Invalidate;
end;

procedure TForm1.MainMenu1N17Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    17: ConvolveFilter(BMP,0,0);
    18: ConvolveFilter(BMP,1,1);
    19: ConvolveFilter(BMP,2,2);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N14Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Darkness(BMP,100);
  Image.Invalidate;
end;

procedure TForm1.MainMenu1N20Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Emboss(BMP);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N21Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  ExcludeColor(BMP,BMP.Pixels[10,10]);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N22Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  ExtractColor(BMP,clBlue);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N24Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    25: FilterRed(BMP,10,200);
    26: FilterGreen(BMP,10,200);
    27: FilterBlue(BMP,10,200);
    29: FilterXRed(BMP,10,200);
    30: FilterXGreen(BMP,10,200);
    31: FilterXBlue(BMP,10,200);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N31Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  FishEye(B,BMP,0.51);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N33Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    34: FlipVert(BMP);
    35: FlipHorz(BMP);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N35Menu(Sender: PMenu; Item: Integer);
var B1,B2: PBitmap;
begin
  if OpenDlg.Execute then
    begin
      B1:=NewBitmap(0,0);
      B1.Assign(BMP);
      B2:=NewBitmap(0,0);
      B2.LoadFromFile(OpenDlg.Filename);
      Undo.Assign(BMP);
      MainMenu1.ItemEnabled[4]:=True;
      FoldRight(B1,B2,BMP,0.33);
      B1.Free;
      B2.Free;
      Image.Invalidate;
    end;
end;

procedure TForm1.KOLForm1N36Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  GaussianBlur(BMP,1);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N37Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  GrayScale(BMP);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N38Menu(Sender: PMenu; Item: Integer);
var B1,B2: PBitmap;
begin
  if OpenDlg.Execute then
    begin
      B1:=NewBitmap(0,0);
      B1.Assign(BMP);
      B2:=NewBitmap(0,0);
      B2.LoadFromFile(OpenDlg.Filename);
      Undo.Assign(BMP);
      MainMenu1.ItemEnabled[4]:=True;
      Grow(B1,B2,BMP,0.33,10,10);
      B1.Free;
      B2.Free;
      Image.Invalidate;
    end;
end;

procedure TForm1.KOLForm1N39Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  HeightMap(BMP,33);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N40Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Invert(BMP);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N42Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    43: KeepRed(BMP,0.8);
    44: KeepGreen(BMP,0.8);
    45: KeepBlue(BMP,0.8);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N45Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Lightness(BMP,100);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N46Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  MakeSeamlessClip(BMP,5);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N49Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  case Item of
    49: Marble(B,BMP,3,3);
    50: Marble2(B,BMP,2,2);
    51: Marble3(B,BMP,3,3);
    52: Marble4(B,BMP,3,3);
    53: Marble5(B,BMP,3,3);
    54: Marble6(B,BMP,3,3);
    55: Marble7(B,BMP,4,4);
    56: Marble8(B,BMP,3,3);
  end;
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N57Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  MaskOval(BMP,clWhite);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N62Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    59: MirrorHorz(BMP);
    60: MirrorVert(BMP);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N61Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Mosaic(BMP,4);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N63Menu(Sender: PMenu; Item: Integer);
var B1,B2: PBitmap;
begin
  if OpenDlg.Execute then
    begin
      B1:=NewBitmap(0,0);
      B1.LoadFromFile(OpenDlg.Filename);
      B2:=NewBitmap(0,0);
      B2.Assign(BMP);
      Undo.Assign(BMP);
      MainMenu1.ItemEnabled[4]:=True;
      Plasma(B1,B2,BMP,10,22);
      B1.Free;
      B2.Free;
      Image.Invalidate;
    end;
end;

procedure TForm1.KOLForm1N64Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  Posterize(B,BMP,20);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N66Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  case Item of
    65: SemiOpaque(B,BMP);
    66: QuartoOpaque(B,BMP);
  end;
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N69Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    68: RippleTooth(BMP,33);
    69: RippleTriangle(BMP,33);
    70: RippleRandom(BMP,33);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N72Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Saturation(BMP,128);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N73Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Seamless(BMP,32);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N75Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  case Item of
    74: ShadowDownLeft(BMP);
    75: ShadowDownRight(BMP);
    76: ShadowUpLeft(BMP);
    77: ShadowUpRight(BMP);
  end;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N80Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  case Item of
    79: ShakeVert(B,BMP,0.1);
    80: ShakeHorz(B,BMP,0.1);
  end;
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N83Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  case Item of
    82: SmoothResize(B,BMP);
    83: SmoothRotate(B,BMP,0,0,33);
  end;
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N85Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  Solarize(B,BMP,100);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N87Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  case Item of
    86: SplitBlur(BMP,33);
    87: SplitLight(BMP,3);
  end;
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N90Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  SpotLight(BMP,-50,MakeRect(BMP.Width div 4,BMP.Height div 4,BMP.Width div 2,BMP.Height div 2));
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N91Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Spray(BMP,16);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N92Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  SqueezeHor(B,BMP,32,lbDiamond);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N93Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(BMP.Width*2,BMP.Height*2);
  Strecth(BMP,B,ResampleFilters[5].Filter,ResampleFilters[5].Width);
  BMP.Assign(B);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N95Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  case Item of
    93: TexturizeOverlap(BMP,64);
    94: TexturizeTile(BMP,64);
  end;
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N97Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  Tile(B,BMP,8);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N98Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Trace(BMP,8);
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N99Menu(Sender: PMenu; Item: Integer);
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  Triangles(BMP,32);
  Image.Invalidate;
end;

procedure TForm1.MainMenu1N103Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  Twist(B,BMP,33);
  B.Free;
  Image.Invalidate;
end;

procedure TForm1.KOLForm1N104Menu(Sender: PMenu; Item: Integer);
var B: PBitmap;
begin
  Undo.Assign(BMP);
  MainMenu1.ItemEnabled[4]:=True;
  B:=NewBitmap(0,0);
  B.Assign(BMP);
  Wave(BMP,32,16,0);
  B.Free;
  Image.Invalidate;
end;

end.

