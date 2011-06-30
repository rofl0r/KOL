{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLProgBar {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCProgBar,
  mckObjs, ExtCtrls, ColorProgressBar {$ENDIF};
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
    KP: TKOLProject;
    KF: TKOLForm;
    PB: TKOLColorProgressBar;
    TT: TKOLTimer;
    P2: TKOLColorProgressBar;
    procedure TTTimer(Sender: PObj);
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

procedure TForm1.TTTimer(Sender: PObj);
begin
   PB.Position := PB.Position + 1;
   if PB.Position = 100 then PB.Position := 0;
   P2.Position := PB.Position;
end;

end.











