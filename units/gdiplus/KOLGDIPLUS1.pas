unit KOLGDIPLUS1;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:18-3-2003 12:28:48
//********************************************************************


interface
uses
   Windows, Kol, kolgdipv2;

type


PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
    BackImage,
    GlobeImage,
    JigSawImage: pGPImage;
    Timer:pTimer;

public
  procedure PaintBox1Paint (Sender: pControl;DC:HDC);
  procedure changed(sender:pObj);
  procedure DoTimer(Sender: pObj);
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'KOL GDIPlus Library Demo').SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    form.OnPaint:=paintbox1paint;
    form.OnResize:=Changed;
    BackImage:=NewGPImage('Snowdon.jpg');
    add2autofree(Backimage);
    GlobeImage := NewGPImage('globe.gif');
    Add2Autofree(GlobeImage);
    JigSawImage := NewGPImage('jigsaw.png');
    Add2AutoFree(JigSawImage);
    if GlobeImage.CanAnimate then
      begin
        Timer:=NewTimer(GlobeImage.FrameDelay (0) * 5);
        Timer.OnTimer:=DoTimer;
        Timer.Enabled := True;
      end;
  end;
end;

procedure TForm1.DoTimer(Sender: pObj);
var
    r: TRect;
begin
    GlobeImage.TimeFrame := GlobeImage.TimeFrame + 1;
    r := MakeRect (347, 120, 347 + 50, 120 + 50);
    gdiplus.DrawImage (form1.GlobeImage, 347, 120, 50, 50);
    InvalidateRect (form.canvas.Handle, @r, False);
end;


procedure Tform1.changed(sender:pObj);
begin
//  form.invalidate;
//  Timer.Enabled:=true;
end;

procedure TForm1.PaintBox1Paint (Sender: pControl;DC:HDC);
var i:integer;

    procedure DrawJoint (X, Y: Integer; Join: TGPPenLineJoin);
    begin
        GDIPlus.Pen.LineJoin := Join;
        GDIPlus.DrawLines ([MakePoint (X, Y), MakePoint (X + 600, Y + 300), MakePoint (X+200, Y + sender.ClientHeight-10)]);
    end;

begin
    with GDIPlus^ do begin
        DeviceContext := DC;
        Clear (white);
        //Brush :=NewGPLinearGradientBrush(sender.clientrect,white,Black,LinearGradientModeForwardDiagonal);
        //Fillrectangle(sender.ClientRect);
        Drawimage(Backimage,0,0);
        Font := NewGPFont(200, 'Arial', [fsBold, fsItalic]);
        Brush := NewGPTextureBrush(JigSawImage);
        DrawString ('GDI+', sender.ClientRect);


        Pen := NewGPPen(Tomato);
        Pen.Width := 10;
        Pen.Brush:=NewGPSolidBrush(tomato);
        DrawLine (0, 0, sender.ClientWidth, sender.ClientHeight);


        Pen.Brush :=NewGPHatchBrush(HatchStyleLargeGrid, ColorFromAlphaColor (185, moccasin), ColorFromAlphaColor (185, SteelBlue));
        Pen.Width := 20;
        DrawEllipse (140, 140, sender.ClientWidth-140, sender.ClientHeight-200);
        Pen.Width := 16;
        Pen.Brush :=NewGPLinearGradientBrush(sender.clientrect,gold,coral);
        DrawJoint(100,10,LineJoinRound);

        Pen.Brush :=NewGPLinearGradientBrush(MakeRect(0,00,40,40),lemonchiffon,Black,LinearGradientModeForwardDiagonal);
        DrawEllipse (i*100+40, 200, 40, 40);
     end;
end;



end.