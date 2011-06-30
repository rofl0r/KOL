{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainBmp2Jpg;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF}, JpegObj;
{$ELSE}
{$I uses.inc} mirror, 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    ListBox1: TKOLListBox;
    PaintBox1: TKOLPaintBox;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure PaintBox1Paint(Sender: PControl; DC: HDC);
    procedure ListBox1SelChange(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure PaintBox1MouseDblClk(Sender: PControl;
      var Mouse: TMouseEventData);
  private
    { Private declarations }
  public
    { Public declarations }
    Bmp: PBitmap;
    FileName: String;
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainBmp2Jpg_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  ListBox1.AddDirList( GetStartDir + '*.bmp', FILE_ATTRIBUTE_NORMAL );
end;

procedure TForm1.PaintBox1Paint(Sender: PControl; DC: HDC);
begin
  if (Bmp <> nil) and not Bmp.Empty then
  begin
    Bmp.Draw( DC, 0, 0 );
    Sender.Canvas.FillRect( MakeRect( Bmp.Width, 0, Sender.ClientWidth, Sender.ClientHeight ) );
    Sender.Canvas.FillRect( MakeRect( 0, Bmp.Height, Bmp.Width, Sender.ClientHeight ) );
  end
    else
    Sender.Canvas.FillRect( Sender.ClientRect );
end;

procedure TForm1.ListBox1SelChange(Sender: PObj);
var S: String;
begin
  if ListBox1.CurIndex < 0 then Exit;
  S := GetStartDir + ListBox1.Items[ ListBox1.CurIndex ];
  if FileExists( S ) then
  begin
    FileName := '';
    if Bmp = nil then
      Bmp := NewBitmap( 0, 0 );
    Bmp.LoadFromFile( S );
    if not Bmp.Empty then
      FileName := S;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  Bmp.Free;
  FileName := '';
end;

procedure TForm1.PaintBox1MouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var Jpg: PJpeg;
begin
  if (Bmp <> nil) and not Bmp.Empty then
  begin
    Jpg := NewJpeg;
    Jpg.Bitmap := Bmp;
    Jpg.SaveToFile( FileName + '.jpg' );
    Jpg.Free;
  end;
end;

end.


