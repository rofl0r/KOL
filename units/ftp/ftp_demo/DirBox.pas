{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit DirBox;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls, Graphics {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mckCtrls, mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm5 = class; PForm5 = TForm5; {$ELSE OBJECTS} PForm5 = ^TForm5; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm5.inc}{$ELSE} TForm5 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm5 = class(TForm)
  {$ENDIF KOL_MCK}
    KF: TKOLForm;
    P1: TKOLPanel;
    P2: TKOLPanel;
    EB: TKOLEditBox;
    B1: TKOLButton;
    B2: TKOLButton;
    LE: TKOLLabelEffect;
    procedure B1Click(Sender: PObj);
    procedure B2Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5 {$IFDEF KOL_MCK} : PForm5 {$ELSE} : TForm5 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm5( var Result: PForm5; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I DirBox_1.inc}
{$ENDIF}

procedure TForm5.B1Click(Sender: PObj);
begin
   Form.ModalResult := 1;
   Form.Hide;
end;

procedure TForm5.B2Click(Sender: PObj);
begin
   Form.ModalResult := 1;
   EB.Text := '';
   Form.Hide;
end;

end.











