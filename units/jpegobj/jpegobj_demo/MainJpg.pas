{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainJpg;

interface

//{$DEFINE BMPONLY}
//{$DEFINE TEST_JPGPROGRESS}

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF} {$IFNDEF BMPONLY}, JpegObj {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
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
    PaintBox1: TKOLPaintBox;
    ListBox1: TKOLListBox;
    Panel1: TKOLPanel;
    Label1: TKOLLabel;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure ListBox1SelChange(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure PaintBox1Paint(Sender: PControl; DC: HDC);
  private
    { Private declarations }
  public
    { Public declarations }
    JPG: {$IFDEF BMPONLY} PBitmap; {$ELSE} PJpeg; {$ENDIF}
    {$IFNDEF BMPONLY}
    procedure JpegProgress( Sender: PJpeg; const R: TRect; var Stop: Boolean );
    {$ENDIF}
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainJpg_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  {$IFDEF BMPONLY}
  ListBox1.AddDirList( GetStartDir + '*.bmp', FILE_ATTRIBUTE_NORMAL );
  {$ELSE}
  ListBox1.AddDirList( GetStartDir + '*.jp*', FILE_ATTRIBUTE_NORMAL );
  {$ENDIF}
end;

procedure TForm1.ListBox1SelChange(Sender: PObj);
var S: String;
begin
  S := ListBox1.Items[ ListBox1.CurIndex ];
  if FileExists( S ) then
  begin
    JPG.Free;
    {$IFDEF BMPONLY}
    JPG := NewBitmap(0,0);
    JPG.LoadFromFile( S );
    //JPG.PixelFormat := pf16bit;
    {$ELSE}
    JPG := NewJpeg;
      {$IFDEF TEST_JPGPROGRESS}
      JPG.OnProgress := JpegProgress;
      PaintBox1.Canvas.FillRect( PaintBox1.ClientRect );
      {$ENDIF}
    JPG.LoadFromFile( S );
    Label1.Caption := '';
    {$ENDIF}
    //if not JPG.Empty then
      PaintBox1.Invalidate;
  end;
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  JPG.Free;
end;

procedure TForm1.PaintBox1Paint(Sender: PControl; DC: HDC);
begin
  if (JPG <> nil) and not JPG.Empty then
  begin
    JPG.Draw( DC, 0, 0 );
    Sender.Canvas.FillRect( MakeRect( JPG.Width, 0, Sender.ClientWidth, Sender.ClientHeight ) );
    Sender.Canvas.FillRect( MakeRect( 0, JPG.Height, JPG.Width, Sender.ClientHeight ) );
    {$IFNDEF BMPONLY}
    if Label1.Caption = '' then
    if JPG.Corrupted then
      Label1.Caption := 'Corrupted';
    {$ENDIF}
  end
    else
    Sender.Canvas.FillRect( Sender.ClientRect );
end;

{$IFNDEF BMPONLY}
procedure TForm1.JpegProgress(Sender: PJpeg; const R: TRect;
  var Stop: Boolean);
begin
  if not JPG.Bitmap.Empty then
    JPG.Bitmap.DIBDrawRect( PaintBox1.Canvas.Handle, R.Left, R.Top, R );
  if JPG.Corrupted then
  if Label1.Caption = '' then
    Label1.Caption := 'Corrupted';
  //Sleep( 40 );
end;
{$ENDIF}

end.


