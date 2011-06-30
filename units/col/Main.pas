{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHXP {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,  MCKMHXP, mckObjs,  mckFontComboBox {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PMainForm = ^TMainForm;
  TMainForm = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMainForm = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Button1: TKOLButton;
    KOLApplet1: TKOLApplet;
    Timer1: TKOLTimer;
    Panel2: TKOLPanel;
    Panel3: TKOLPanel;
    MHXP1: TKOLMHXP;
    procedure Button1Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Timer1Timer(Sender: PObj);
    procedure Panel2Click(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure Panel3Paint(Sender: PControl; DC: HDC);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
     TStiksKind = (skTop, skLeft, skRight, skBottom);
     TStiks = set of TStiksKind;

const
  Stiks:TStiks = [skTop, skLeft, skRight, skBottom];
  StickAt:Word = 6;


const
  InfoMax = 512000;
  InfoMin = -512000 div 2;

  InfoCount = 12*128;
  InfoPos:integer = 0;
  GridSize = 12;
var
  InfoState: array[0..InfoCount-1] of integer;


var
  MainForm {$IFDEF KOL_MCK} : PMainForm {$ELSE} : TMainForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMainForm( var Result: PMainForm; AParent: PControl );
{$ENDIF}

implementation

uses
  Options, COL;

{$R TestKol3.RES}


{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Main_1.inc}
{$ENDIF}

function WndPosChanging( Sender: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
const
  Docked: Boolean = FALSE;
var
  rWorkArea: TRect;
  WindowPos:PWindowPos;

  procedure ApplyRectArea(rArea: TRect);
  begin
    with WindowPos^ do begin
      if abs(WindowPos^.x - rArea.Left) <= StickAt then
        begin
          if skLeft in Stiks then
          begin
            x := rArea.Left;
            Docked := TRUE;
          end;
         end
      else
      if abs(x + cx - rArea.Right) <=  StickAt then
      begin
        if skRight in Stiks then
        begin
         x := rArea.Right - cx;
         Docked := TRUE;
        end;
      end;

      if abs(y-rArea.Top) <= StickAt then
      begin
        if skTop in Stiks then
        begin
            y := rArea.Top;
            Docked := TRUE;
        end;
      end;

      if abs(y + cy - rArea.Bottom) <= StickAt then
      begin
        if skBottom in Stiks then
        begin
          y := rArea.Bottom - cy;
          Docked := TRUE;
        end;
      end;
    end;
  end;

begin

  if Msg.message = WM_WINDOWPOSCHANGING then
  begin
    SystemParametersInfo (SPI_GETWORKAREA, 0, @rWorkArea, 0);


    WindowPos:=PWindowPos(Msg.lParam);

    ApplyRectArea(rWorkArea);

//    GetClientRect(0,rWorkArea);
//    ApplyRectArea(rWorkArea);

      if Docked then begin
        with rWorkArea do begin
        // no moving out of the screen
//        if x < Left then x := Left;
//        if x + cx > Right then x := Right - cx;
//        if y < Top then y := Top;
//        if y + cy > Bottom then y := Bottom - cy;
        end; {with rWorkArea}
      end; {if Docked}
  end;
  result:=false;
end;


procedure TMainForm.Button1Click(Sender: PObj);
begin
  if not Assigned( OptionsForm ) then
    NewOptionsForm( OptionsForm, Applet );
  OptionsForm.Form.Show;
end;

procedure TMainForm.KOLForm1FormCreate(Sender: PObj);
begin
  Form.AttachProc(WndPosChanging);
end;

procedure TMainForm.Timer1Timer(Sender: PObj);
begin
  if InfoPos <= 0 then
    InfoPos:=InfoCount;
  dec(InfoPos);
  InfoState[InfoPos]:=Random(InfoMax);
  Panel3.Invalidate;
  Panel2.Caption:=DateTime2StrShort(Now);
end;

procedure TMainForm.Panel2Click(Sender: PObj);
begin
  Panel2.Caption:=DateTime2StrShort(Now);
end;

procedure TMainForm.Button5Click(Sender: PObj);
begin
//  ListView1.Style:=ListView1.Style and (not WS_VSCROLL);
end;

procedure TMainForm.Panel3Paint(Sender: PControl; DC: HDC);
var
 Rect:TRect;
 i:integer;
 count,
 y0,y1,
 x,y,z:integer;
 NewBrush:HGDIOBJ;
 OldPen:HGDIOBJ;
 Canvas:PGDICanvas;
 GDIBitmap:PGDIBitmap;
 GDIBitmap2:PGDIBitmap;
 GDIBitmap3:PGDIBitmap;
 GDIIcon:PGDIIcon;
 GDIIcon2:PGDIIcon;
 GDIIcon3:PGDIIcon;
 Icon:PIcon;
 LF:TLogFont;
begin

 GDIBitmap:=NewGDIBitmap(10,10);
 GDIBitmap2:=NewGDIBitmap(10,10);
 GDIBitmap3:=NewGDIBitmap(10,10);

 Rect:=Sender.ClientRect;
 Canvas:=NewGDICanvas(DC);

{   Canvas.Pen.GeometricPen:=false;
   Canvas.Pen.PenStyle:=psSolid;
   Canvas.Brush.Color:=clLime;
   Canvas.Font.Color:=clLime;}

 Canvas.Brush.Color:=clGray;
 Canvas.Brush.BrushStyle:=bsCross;
 Canvas.Brush.BrushStyle:=bsSolid;

 Canvas.FillRect(Rect);

/////////////////////////////////////////////////
// Start Test Bitmap
/////////////////////////////////////////////////

 Rect.Left:=1;
 Rect.Top:=1;
 Rect.Right:=6;
 Rect.Bottom:=6;

 GDIBitmap.LoadFromResourceID( 0{hInstance}, OBM_CLOSE);
 GDIBitmap2.LoadFromResourceID( 0{hInstance}, OBM_COMBO);
 GDIBitmap3.LoadFromResourceID( 0{hInstance}, OBM_CHECKBOXES);

 // GDIBitmap.LoadFromResourceName( hInstance, 'TESTBITMAP');
// GDIBitmap3.LoadFromResourceName( hInstance, 'TESTBITMAP');
 GDIBitmap.LoadFromFileEx('test.bmp');

// GDIBitmap2.Assign(GDIBitmap);

 GDIBitmap2.Canvas.Brush.Color:=clWhite;
 GDIBitmap2.Canvas.FillRect(Rect);


 GDIBitmap.Draw(Canvas.Handle,10,100);
 GDIBitmap2.Draw(Canvas.Handle,10,150);
 GDIBitmap3.Draw(Canvas.Handle,10,200);


// GDIBitmap.DIBPixels[1,1]:=1;
// GDIBitmap.HandleType:=bmDDB;
// GDIBitmap.Check;
 GDIBitmap3.Assign(GDIBitmap);
 GDIBitmap.LoadFromResourceID( 0, OBM_ZOOMD);

 GDIBitmap3.Assign(GDIBitmap);
 GDIBitmap.Clear;
 GDIBitmap.LoadFromResourceID( 0, OBM_ZOOMD);


 GDIBitmap.Draw(Canvas.Handle,30,100);
 GDIBitmap2.Draw(Canvas.Handle,30,150);

 GDIBitmap3.Draw(Canvas.Handle,320,240);
 GDIBitmap2.Draw(Canvas.Handle,300,240);

 GDIBitmap2.Draw(GDIBitmap3.Canvas.Handle,9,5);
 GDIBitmap3.Draw(Canvas.Handle,300,200);


 GDIBitmap.Draw(Canvas.Handle,180,180);
 GDIBitmap.Width:=GDIBitmap.Width*2;
 GDIBitmap.Draw(Canvas.Handle,200,200);

 Rect.Left:=1;
 Rect.Top:=1;
 Rect.Right:=100;
 Rect.Bottom:=100;

// GDIBitmap2.StretchDrawMasked(dc,Rect,GDIBitmap.Handle);

   Canvas.MoveTo(1,1);
   Canvas.Pen.PenMode:=pmWhite;
   Canvas.LineTo(100,100);
   Canvas.Pen.PenMode:=pmBlack;
   Canvas.LineTo(200,0);

   Canvas.Pen.PenMode:=pmCopy;
   Canvas.MoveTo(10,1);

   Canvas.Pen.PenStyle:=psSolid;
   Canvas.LineTo(110,100);
   Canvas.Pen.PenStyle:=psDash;
   Canvas.LineTo(210,0);
   Canvas.Pen.PenStyle:=psDot;
   Canvas.LineTo(310,100);
   Canvas.Pen.PenStyle:=psDashDot;
   Canvas.LineTo(310,0);

   Canvas.Pen.PenStyle:=psDashDot;

 Canvas.Pen.PenStyle:=psSolid;
{ for i:= 1 to 16 do
 begin
   Canvas.Pen.PenBrushStyle:=bsSolid;
   Canvas.Brush.Color:=clBlack;
   Canvas.MoveTo(200,20*i+10);
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.PenWidth:=10;

   Canvas.Pen.GeometricPen:=false;
   Canvas.LineTo(250,20*i+10);
   Canvas.Pen.Color:=clYellow;
   Canvas.Pen.GeometricPen:=true;
   Canvas.Pen.PenMode:=TGDIPenmode(i);

   Canvas.LineTo(300,20*i+10);
   Canvas.Pen.PenBrushBitmap:=GDIBitmap.Handle;
   Canvas.Pen.PenEndCap:=pecSquare;
   Canvas.Pen.PenJoin:=pjBevel;
   Canvas.LineTo(350,20*i+10);
 end;{}

 for i:= 1 to 3 do
 begin
   Canvas.Pen.PenBrushStyle:=bsSolid;
   Canvas.Brush.Color:=clRed;
   Canvas.MoveTo(10,20*i+10);
   Canvas.Pen.Color:=clBlack;
   Canvas.Pen.PenWidth:=18;
   Canvas.Pen.GeometricPen:=false;
   Canvas.LineTo(100,20*i+10);
   Canvas.Pen.Color:=clYellow;
   Canvas.Pen.GeometricPen:=true;
   Canvas.Pen.PenMode:=TGDIPenmode(i);
   Canvas.LineTo(200,20*i+10);
//   Canvas.Pen.PenBrushBitmap:=GDIBitmap2.Handle;
   Canvas.Pen.PenEndCap:=pecSquare;
   Canvas.Pen.PenJoin:=pjBevel;
   Canvas.LineTo(300,20*i+10);
 end;


 Canvas.Font.FontQuality:=fqAntialiased;
 Canvas.Font.Color:=clNavy;
 Canvas.TextOut(5,5,'Test');
 Canvas.Pen.PenMode:=pmCopy;

 Canvas.Font.FontHeight:=-10;
 Canvas.Font.FontWeight:=FW_BOLD;
 Canvas.Font.FontName:='Webdings';

 Canvas.Brush.Color:=clBlue;
 Canvas.Brush.BrushStyle:=bsClear;

 Canvas.TextOut(45,25,'Test');
 Canvas.Font.Color:=clAqua;
 Canvas.TextOut(55,35,'Test');

 GDIIcon:=NewGDIIcon;
 GDIIcon2:=NewGDIIcon;
 GDIIcon3:=NewGDIIcon;
 GDIIcon.Size:=64;

// GDIIcon3.LoadFromResourceName( hinstance, 'TESTICON', 0 );
// GDIIcon3.Draw(Canvas.Handle,100,100);

 GDIIcon3.LoadFromResourceID( 0, OIC_WARNING, 0 );
 GDIIcon3.Draw(Canvas.Handle,120,120);

 GDIIcon3.LoadFromResourceID( 0, OIC_ERROR, 0 );
 GDIIcon3.Draw(Canvas.Handle,140,140);

 GDIIcon.LoadFromResourceID( 0, OIC_WINLOGO, 0 );
 GDIIcon.Draw(Canvas.Handle,280,200);

// GDIIcon2.LoadFromResourceID( 0, OIC_INFORMATION, 0 );
// GDIIcon2.Draw(Canvas.Handle,240,200);


 GDIIcon.Free;
 GDIIcon2.Free;
 GDIIcon3.Free;


 GDIBitmap3.Free;
 GDIBitmap2.Free;
 GDIBitmap.Free;
 Canvas.Free;
// Panel3.OnPaint:=nil;
end;

end.










