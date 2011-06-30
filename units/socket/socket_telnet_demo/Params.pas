{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Params;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
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
    KF: TKOLForm;
    EditBox1: TKOLEditBox;
    EditBox2: TKOLEditBox;
    Button1: TKOLButton;
    Button3: TKOLButton;
    Label1: TKOLLabelEffect;
    Label2: TKOLLabelEffect;
    procedure Button1Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
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
uses KOLForm;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Params_1.inc}
{$ENDIF}

procedure TForm2.Button1Click(Sender: PObj);
begin
   Form1.Connect;
   Form.Hide;
end;

procedure TForm2.Button3Click(Sender: PObj);
begin
   Form.Hide;
end;

end.





