{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls,Graphics {$ENDIF},IdIcmpClient,IdTrivialFTP,idTime,idTelnet,
  IdIPWatch,idsntp,IdSSLOpenSSL,MySyncObjs;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
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
    btnPing: TKOLButton;
    lstReplies: TKOLListBox;
    edtHost: TKOLEditBox;
    procedure btnPingClick(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ICMPReply(ASender:  PControl; const ReplyStatus:
  TReplyStatus);
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  ICMP:PIdIcmpClient;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.ICMPReply(ASender:  PControl; const ReplyStatus:
  TReplyStatus);
var
  sTime: string;
begin
  // TODO: check for error on ping reply (ReplyStatus.MsgType?)
  if (ReplyStatus.MsRoundTripTime = 0) then
    sTime := '<1'
  else
    sTime := '=';

  lstReplies. {Items.}
    Add(Format('%d bytes from %s: icmp_seq=%d ttl=%d time%s%d ms',
    [ReplyStatus.BytesReceived,
    ReplyStatus.FromIpAddress,
      ReplyStatus.SequenceId,
      ReplyStatus.TimeToLive,
      sTime,
      ReplyStatus.MsRoundTripTime]));
end;


procedure TForm1.btnPingClick(Sender: PObj);
var
  i: integer;
begin
  ICMP.OnReply := ICMPReply;
    ICMP.ReceiveTimeout := 1000;
    btnPing.Enabled := False;
  try
      ICMP.Host := edtHost.Text;
    for i := 1 to 4 do
    begin
      ICMP.Ping;
      Applet.ProcessMessages;
        //Application.ProcessMessages;
        Sleep(1000);
    end;
  finally btnPing.Enabled := True;
  end;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  ICMP:=NewIdIcmpClient(Form);
  ICMP.Port:=0;
  ICMP.ReceiveTimeout:=1000;
  ICMP.Protocol:=1;
end;

end.



