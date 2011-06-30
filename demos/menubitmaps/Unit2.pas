{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit2;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckObjs {$ENDIF};
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
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    function MainMenu1MeasureItem(Sender: PObj; Idx: Integer): Integer;
    function MainMenu1DrawItem(Sender: PObj; DC: HDC; const Rect: TRect;
      ItemIdx: Integer; DrawAction: TDrawAction;
      ItemState: TDrawState): Boolean;
  private
    { Private declarations }
    S12Bmp: PBitmap;
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

const KindHeight = 29;
{$R i24bit.res}

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit2_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  S12Bmp := NewBitmap( 0, 0 );
  S12Bmp.LoadFromResourceName( hInstance, 'S12' );
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  S12Bmp.Free;
end;

function TForm1.MainMenu1MeasureItem(Sender: PObj; Idx: Integer): Integer;
begin
  Result := 0;
  if Idx = miKind then
    Result := (KindHeight + 6) or ((KindHeight * 2) shl 16);
end;

function TForm1.MainMenu1DrawItem(Sender: PObj; DC: HDC; const Rect: TRect;
  ItemIdx: Integer; DrawAction: TDrawAction;
  ItemState: TDrawState): Boolean;
begin
  Result := FALSE;
  if ItemIdx = miKind then
  begin
    S12Bmp.DrawTransparent( DC, 0, 0, clWhite );
    TextOut( DC, KindHeight + 6, 6, 'Hello!', 6 );
    Result := TRUE;
  end;
end;

end.


