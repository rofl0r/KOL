{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Client_conn;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
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
    Conn: TKOLForm;
    Button1: TKOLButton;
    Button2: TKOLButton;
    EditBox1: TKOLEditBox;
    Label1: TKOLLabel;
    EditBox2: TKOLEditBox;
    Label2: TKOLLabel;
    procedure ConnClose(Sender: PObj; var Accept: Boolean);
    procedure ConnFormCreate(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
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

uses Client_main, KOLTCPSocket;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Client_conn_1.inc}
{$ENDIF}

procedure TForm2.ConnClose(Sender: PObj; var Accept: Boolean);
begin
  accept:=false;
  form.modalresult:=ID_CANCEL;
  form.hide;
end;

procedure TForm2.ConnFormCreate(Sender: PObj);
begin
  form.style:=form.style and not WS_THICKFRAME;
  button1.style:=button1.style or BS_DEFPUSHBUTTON;
end;

procedure TForm2.Button1Click(Sender: PObj);
begin
  with form1.Client^ do
  begin
    host:=editbox2.Text;
    port:=str2int(editbox1.Text);
    connect;
  end;
  form.modalresult:=ID_OK;
  form.hide;
end;

procedure TForm2.Button2Click(Sender: PObj);
begin
  form.modalresult:=ID_CANCEL;
  form.hide;
end;

end.


