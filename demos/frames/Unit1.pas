{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror, mckCtrls;
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
    Panel1: TKOLPanel;
    Button1: TKOLButton;
    Button2: TKOLButton;
    Panel2: TKOLPanel;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    Frame: PObj;
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses Unit2;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.Button1Click(Sender: PObj);
begin
  NewForm2( PForm2( Frame ), Panel2 );
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  if Frame <> nil then
    PForm2( Frame ).Form.Free;
end;

end.


