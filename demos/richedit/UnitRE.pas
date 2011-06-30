{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit UnitRE;

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
    RichEdit1: TKOLRichEdit;
    Panel1: TKOLPanel;
    Test1: TKOLButton;
    Button1: TKOLButton;
    procedure Test1Click(Sender: PObj);
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
{$I UnitRE_1.inc}
{$ENDIF}

// Test1: Add 10 lines of 10 colors
procedure TForm1.Test1Click(Sender: PObj);
const Colors: array[ 0..9 ] of TColor = ( clBlack, clNavy, clBlue, clAqua,
  clLime, clGreen, clOlive, clYellow, clRed, clMaroon );
var I, N: Integer;
begin
  N := RichEdit1.Pos2Item( RichEdit1.TextSize );
  for I := 1 to 10 do
  begin
    RichEdit1.SelStart := RichEdit1.TextSize;
    RichEdit1.ReplaceSelection( 'Test' + Int2Str( N+I ) + #13#10, FALSE );
  end;
  for I := 0 to 9 do
  begin
    RichEdit1.SelStart := RichEdit1.Item2Pos( N+I );
    RichEdit1.SelLength := RichEdit1.Item2Pos( N+I + 1 ) - RichEdit1.SelStart;
    RichEdit1.RE_FmtFontColor := Colors[ I ];
  end;
  RichEdit1.SelStart := 0;
end;

procedure TForm1.Button1Click(Sender: PObj);
const Colors: array[ 0..9 ] of TColor = ( clWhite, clNavy, clBlue, clAqua,
  clLime, clGreen, clOlive, clYellow, clRed, clMaroon );
var I, N: Integer;
begin
  N := RichEdit1.Pos2Item( RichEdit1.TextSize );
  for I := 1 to 10 do
  begin
    RichEdit1.SelStart := RichEdit1.TextSize;
    RichEdit1.ReplaceSelection( 'Test' + Int2Str( N+I ) + #13#10, FALSE );
  end;
  for I := 0 to 9 do
  begin
    RichEdit1.SelStart := RichEdit1.Item2Pos( N+I );
    RichEdit1.SelLength := RichEdit1.Item2Pos( N+I + 1 ) - RichEdit1.SelStart;
    RichEdit1.RE_FmtBackColor := Colors[ I ];
  end;
  RichEdit1.SelStart := 0;
end;

end.


