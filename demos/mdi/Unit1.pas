{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
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
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    MainMenu1: TKOLMainMenu;
    MDIClient1: TKOLMDIClient;
    procedure MainMenu1N5Menu(Sender: PMenu; Item: Integer);
    procedure MainMenu1N3Menu(Sender: PMenu; Item: Integer);
    procedure MainMenu1N4Menu(Sender: PMenu; Item: Integer);
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

uses
  Unit2;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.MainMenu1N5Menu(Sender: PMenu; Item: Integer);
var F2: PForm2;
begin
  NewForm2( F2, Form );
  F2.Form.CreateWindow;
end;

procedure TForm1.MainMenu1N3Menu(Sender: PMenu; Item: Integer);
begin
  MDIClient1.Perform( WM_MDITILE, MDITILE_VERTICAL, 0 );
end;

procedure TForm1.MainMenu1N4Menu(Sender: PMenu; Item: Integer);
begin
  MDIClient1.Perform( WM_MDICASCADE, 0, 0 );
end;

end.


