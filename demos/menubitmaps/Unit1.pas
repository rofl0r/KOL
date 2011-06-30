{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckObjs, Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
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
    MainMenu1: TKOLMainMenu;
    Button1: TKOLButton;
    procedure Button1Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

var CurH: Integer = 29;

procedure TForm1.Button1Click(Sender: PObj);
var Bmp: HBitmap;
    TmpBmp, OldBmp: PBitmap;
    H: Integer;
begin
  Bmp := MainMenu1.ItemBitmap[ 1 ];
  if Bmp <> 0 then
  begin
    H := GetSystemMetrics( SM_CYMENUCHECK );
    if H = CurH then Exit;
    TmpBmp := NewDIBBitmap( H, H, pf24bit );
    OldBmp := NewBitmap( CurH, CurH );
    OldBmp.Handle := Bmp;
    SetStretchBltMode( TmpBmp.Canvas.Handle, HALFTONE );
    SetBrushOrgEx( TmpBmp.Canvas.Handle, 0, 0, nil );
    StretchBlt( TmpBmp.Canvas.Handle, 0, 0, H, H, OldBmp.Canvas.Handle, 0, 0,
                CurH, CurH, SRCCOPY );
    //TmpBmp.SaveToFile( 'c:\test.bmp' );
    OldBmp.ReleaseHandle;
    Bmp := TmpBmp.Handle;
    TmpBmp.ReleaseHandle;
    OldBmp.Free;
    TmpBmp.Free;
    CurH := H;
    MainMenu1.ItemBitmap[ 1 ] := Bmp;
  end;

end;

end.


