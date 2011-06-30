{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF},KOLPing;
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
    Label1: TKOLLabel;
    HostEdit: TKOLEditBox;
    DisplayMemo: TKOLMemo;
    PingButton: TKOLButton;
    CancelButton: TKOLButton;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure PingButtonClick(Sender: PObj);
    procedure CancelButtonClick(Sender: PObj);
  private
    { Private declarations }
    procedure Ping1DnsLookupDone(Sender: PObj; Error: Word);
    procedure Ping1Display(Sender: PObj; Icmp: PObj; Msg: String);
    procedure Ping1EchoRequest(Sender: PObj; Icmp: PObj);
    procedure Ping1EchoReply(
    Sender : PObj;
    Icmp   : PObj;
    Status : Integer);
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  Ping1:PPing;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  Ping1:=NewPing(nil);
  Ping1.OnDnsLookupDone:=Ping1DnsLookupDone;
  Ping1.OnDisplay:=Ping1Display;
  Ping1.OnEchoRequest:=Ping1EchoRequest;
  Ping1.OnEchoReply:=Ping1EchoReply;
end;

procedure TForm1.PingButtonClick(Sender: PObj);
begin
  DisplayMemo.Clear;
    DisplayMemo.Add('Resolving host ''' + HostEdit.Text + ''''+#13+#10);
    PingButton.Enabled   := FALSE;
    CancelButton.Enabled := TRUE;
    Ping1.DnsLookup(HostEdit.Text);
end;

procedure TForm1.CancelButtonClick(Sender: PObj);
begin
  Ping1.CancelDnsLookup;
end;

procedure TForm1.Ping1DnsLookupDone(Sender: PObj; Error: Word);
begin
    CancelButton.Enabled := FALSE;
    PingButton.Enabled   := TRUE;

    if Error <> 0 then begin
        DisplayMemo.Add('Unknown Host ''' + HostEdit.Text + ''''+#13+#10);
        Exit;
    end;

    DisplayMemo.Add('Host ''' + HostEdit.Text + ''' is ' + Ping1.DnsResult+#13+#10);
    Ping1.Address := Ping1.DnsResult;
    Ping1.Ping;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TForm1.Ping1Display(Sender: PObj; Icmp: PObj; Msg: String);
begin
    DisplayMemo.Add(Msg+#13+#10);
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TForm1.Ping1EchoRequest(Sender: PObj; Icmp: PObj);
begin
    DisplayMemo.Add('Sending ' + Int2Str(Ping1.Size) + ' bytes to ' +
                          Ping1.HostName + ' (' + Ping1.HostIP + ')'+#13+#10);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TForm1.Ping1EchoReply(
    Sender : PObj;
    Icmp   : PObj;
    Status : Integer);
begin
    if Status <> 0 then
        { Success }
        DisplayMemo.Add('Received ' + Int2Str(Ping1.Reply.DataSize) +
                              ' bytes from ' + Ping1.HostIP +
                              ' in ' + Int2Str(Ping1.Reply.RTT) + ' msecs'+#13+#10)
    else
        { Failure }
        DisplayMemo.Add('Cannot ping host (' + Ping1.HostIP + ') : ' +
                              Ping1.ErrorString +
                              '. Status = ' + Int2Str(Ping1.Reply.Status)+#13+#10);
end;

end.


