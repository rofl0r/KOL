{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLDDE {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckDDE {$ENDIF};
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
    ddeconv: TKOLDDEClientConv;
    ddeitem: TKOLDDEClientItem;
    procedure OnChange(Sender: PObj);
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

procedure TForm1.OnChange;
begin
   L1.Caption := ddeitem.text;
end;

end.







