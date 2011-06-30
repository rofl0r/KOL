{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit UnitB;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm2 = ^TForm2;
  TForm2 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm2 = class(TForm)
  {$ENDIF KOL_MCK}
    Button1: TKOLButton;
    KOLForm1: TKOLForm;
    Button2: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2 {$IFDEF KOL_MCK} : PForm2 {$ELSE} : TForm2 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm2( var Result: PForm2; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I UnitB_1.inc}
{$ENDIF}

procedure TForm2.Button1Click(Sender: PObj);
begin
  Form.ModalResult := 1;
end;

procedure TForm2.Button2Click(Sender: PObj);
begin
  Form.ModalResult := 2;
end;

end.


