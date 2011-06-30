{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, Graphics {$ENDIF},IdComponent, IdTCPConnection, IdTCPClient, IdEcho,
  IdBaseComponent,IdHTTP;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    btnConnect: TKOLButton;
    Button2: TKOLButton;
    btnDisconnect: TKOLButton;
    edtEchoServer: TKOLEditBox;
    edtSendText: TKOLEditBox;
    lablReceived: TKOLLabel;
    lablTime: TKOLLabel;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure btnConnectClick(Sender: PObj);
    procedure edtEchoServerChange(Sender: PObj);
    procedure btnDisconnectClick(Sender: PObj);
    procedure Button2Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  IdEcoTestConnection: PIdEcho;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

(*
procedure TformEchoTest.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdEcoTestConnection.Disconnect;
end;

procedure TformEchoTest.btnConnectClick(Sender: TObject);
begin
  try
  IdEcoTestConnection.Connect;
  {we only can echo after we connect to the server}
  edtSendText.Enabled := True;
  edtSendText.color := clWhite;
  btnConnect.Enabled := False;
  btnDisconnect.Enabled := True;
  except
  IdEcoTestConnection.Disconnect;
  end; //try..except
end;

procedure TformEchoTest.btnDisconnectClick(Sender: TObject);
begin
  IdEcoTestConnection.Disconnect;
  btnConnect.Enabled := True;
  edtSendText.Enabled := False;
  edtSendText.color := clSilver;
  btnDisconnect.Enabled := False;
end;

procedure TformEchoTest.edtEchoServerChange(Sender: TObject);
begin
  IdEcoTestConnection.Host := edtEchoServer.Text;
end;

procedure TformEchoTest.Button1Click(Sender: TObject);
begin
  {This echos the text to the server}
  lablReceived.Caption := IdEcoTestConnection.Echo ( edtSendText.Text );
  {This displays the round trip time}
  lablTime.Caption := IntToStr ( IdEcoTestConnection.EchoTime );
end;
*)

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  // 27-apr-2003
  IdEcoTestConnection:=NewIdEcho(nil);
end;

procedure TForm1.btnConnectClick(Sender: PObj);
begin
  try
  IdEcoTestConnection.Connect;
  {we only can echo after we connect to the server}
  edtSendText.Enabled := True;
  edtSendText.color := clWhite;
  btnConnect.Enabled := False;
  btnDisconnect.Enabled := True;
  except
  IdEcoTestConnection.Disconnect;
  end; //try..except
end;

procedure TForm1.edtEchoServerChange(Sender: PObj);
begin
  IdEcoTestConnection.Host := edtEchoServer.Text;
end;

procedure TForm1.btnDisconnectClick(Sender: PObj);
begin
  IdEcoTestConnection.Disconnect;
  btnConnect.Enabled := True;
  edtSendText.Enabled := False;
  edtSendText.color := clSilver;
  btnDisconnect.Enabled := False;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  {This echos the text to the server}
  lablReceived.Caption := IdEcoTestConnection.Echo ( edtSendText.Text );
  {This displays the round trip time}
  lablTime.Caption := Int2Str ( IdEcoTestConnection.EchoTime );
end;

end.



