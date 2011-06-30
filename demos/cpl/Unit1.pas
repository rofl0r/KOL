{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;



interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls, mckObjs,  mckListEdit {$ENDIF};
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
    KOLProject1: TKOLProject;
    KOLApplet1: TKOLApplet;
    KOLForm1: TKOLForm;
    BitBtn1: TKOLBitBtn;
    procedure BitBtn1Click(Sender: PObj);
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
{$I Unit1_1.inc}
{$ENDIF}


procedure TMain.BitBtn1Click(Sender: PObj);
begin
   PostQuitMessage( 0 );
end;




end.












