{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLDDE {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs, mckDDE {$ENDIF};
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
    KOLProject: TKOLProject;
    KOLForm: TKOLForm;
    L1: TKOLLabel;
    Timer1: TKOLTimer;
    test_topic: TKOLDDEServerConv;
    test_item: TKOLDDEServerItem;
    procedure Timer1Timer(Sender: PObj);
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
{$I KOLForm_1.inc}
{$ENDIF}

procedure TForm1.Timer1Timer(Sender: PObj);
begin
   L1.Caption := int2str(random(90) + 10) + ' -- ' + int2str(random(90) + 10) + ' -- ' + int2str(random(90) + 10);
   test_item.Text := L1.Caption;
end;

end.







