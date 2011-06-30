{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit2;

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
  PMain = ^TMain;
  TMain = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMain = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    Button1: TKOLButton;
    procedure Button1Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main {$IFDEF KOL_MCK} : PMain {$ELSE} : TMain {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMain( var Result: PMain; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit2_1.inc}
{$ENDIF}

procedure TMain.Button1Click(Sender: PObj);
begin
Form.Close; 
end;

end.
 
 


