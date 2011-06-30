{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLUnit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PKOLForm1 = ^TKOLForm1;
  TKOLForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TKOLForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Button1: TKOLButton;
    KOLApplet1: TKOLApplet;
    procedure Button1Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KOLForm1 {$IFDEF KOL_MCK} : PKOLForm1 {$ELSE} : TKOLForm1 {$ENDIF} ;

procedure CallKOLFormModal; export;

{$IFDEF KOL_MCK}
procedure NewKOLForm1( var Result: PKOLForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLUnit1_1.inc}
{$ENDIF}

procedure CallKOLFormModal;
begin
  NewKOLForm1( KOLForm1, Applet );
  KOLForm1.Form.ShowModal;
  KOLForm1.Form.Free;
  KOLForm1 := nil;
end;

procedure TKOLForm1.Button1Click(Sender: PObj);
begin
  Form.ModalResult := 1;
  Form.Close;
end;

end.


