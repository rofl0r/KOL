{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes {$ENDIF}, KolOGL12;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  KolOGL12;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PMain = ^TMain;
  TMain = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMain = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    KOLProject1: TKOLProject;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Paint(Sender: PControl; DC: HDC);
    procedure KOLForm1Destroy(Sender: PObj);
  private
    hrc: HGLRC;
    fCanvas: PCanvas;
  public
  end;

var
  Main {$IFDEF KOL_MCK} : PMain {$ELSE} : TMain {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMain( var Result: PMain; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TMain.KOLForm1FormCreate(Sender: PObj);
var
  PixelFmt: Integer;
  pfd: TPixelFormatDescriptor;
begin
  Main.Form.Width:=400;
  Main.Form.Height:=300;

     InitOpenGL;

     Main.Form.Show;


     fCanvas:=NewCanvas(GetDC(Main.Form.Handle));

     FillChar(pfd, SizeOf(pfd), 0);

     with pfd do
     begin
          nSize     := sizeof(pfd);
          nVersion  := 1;
          dwFlags   := PFD_DRAW_TO_WINDOW or
                       PFD_SUPPORT_OPENGL or
                       PFD_DOUBLEBUFFER;
          iPixelType:= PFD_TYPE_RGBA;
          cColorBits:= 24;
          cDepthBits:= 32;
          iLayerType:= PFD_MAIN_PLANE;
     end;


     PixelFmt := ChoosePixelFormat(fCanvas.Handle, @pfd);
     SetPixelFormat(fCanvas.Handle, PixelFmt, @pfd);
     hrc := wglCreateContext(fCanvas.Handle);


     wglMakeCurrent(fCanvas.Handle, hrc);

     glClearColor(0.0, 0.0, 0.0, 1.0);

     glViewport(0, 0, 400, 300);
     glMatrixMode(GL_PROJECTION);
     glLoadIdentity();


     gluOrtho2D(-1, 1, -1, 1);
     glMatrixMode(GL_MODELVIEW);

end;

procedure TMain.KOLForm1Paint(Sender: PControl; DC: HDC);
begin
     glClear(GL_COLOR_BUFFER_BIT);

     glBegin(GL_TRIANGLES);
         glColor3f(1.0, 0.0, 0.0); glVertex2f(-0.5, -0.5);
	 glColor3f(0.0, 1.0, 0.0); glVertex2f(0.5, -0.5);
	 glColor3f(0.0, 0.0, 1.0); glVertex2f(0.0, 0.5);
     glEnd();
     glFinish();
     SwapBuffers(wglGetCurrentDC());
end;

procedure TMain.KOLForm1Destroy(Sender: PObj);
begin
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  ReleaseDC(fCanvas.Handle, fCanvas.Handle);
  fCanvas.Free;
end;

end.



