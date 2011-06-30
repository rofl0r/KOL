{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainPaintBitmap;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes {$ENDIF};
{$ELSE}
{$I uses.inc}
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
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure KOLForm1Paint(Sender: PControl; DC: HDC);
  private
    { Private declarations }
  public
    { Public declarations }
    B: PBitmap;
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$R 'BMP1.RES'}

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainPaintBitmap_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  B := NewBitmap( 0, 0 );
  B.LoadFromResourceName( hInstance, 'BMP1' );
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  B.Free;
end;

procedure TForm1.KOLForm1Paint(Sender: PControl; DC: HDC);
begin
  B.Draw( DC, 0, 0 );
end;

end.


