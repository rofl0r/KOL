{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF},KOLWSocket,WinSock;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
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
    DisconnectButton: TKOLButton;
    InfoLabel: TKOLLabel;
    procedure KOLForm1Show(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure DisconnectButtonClick(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SrvSocketSessionAvailable(Sender: PObj; Error: Word);
    procedure CliSocketSessionClosed(Sender: PObj; Error: Word);
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
    SrvSocket: PWSocket;
    CliSocket: PWSocket;
    FirstTime:Boolean=true;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.SrvSocketSessionAvailable(Sender: PObj; Error: Word);
var
    NewHSocket : TSocket;
    PeerName   : TSockAddrIn;
    Peer       : String;
begin
    { We need to accept the client connection }
    NewHSocket := SrvSocket.Accept;

    { And then associate this connection with our client socket }
    CliSocket.Dup(NewHSocket);

    { Wants to know who is connected to display on screen }
    CliSocket.GetPeerName(PeerName, Sizeof(PeerName));

    { User likes to see internet address in dot notation }
    Peer := Int2Str(ord(PeerName.sin_addr.S_un_b.s_b1)) + '.' +
            Int2Str(ord(PeerName.sin_addr.S_un_b.s_b2)) + '.' +
            Int2Str(ord(PeerName.sin_addr.S_un_b.s_b3)) + '.' +
            Int2Str(ord(PeerName.sin_addr.S_un_b.s_b4));
    InfoLabel.Caption := 'Remote ' + Peer + ' connected';

    { Send a welcome message to the client }
    CliSocket.SendStr('Hello' + #13 + #10);

    { Enable the server user to disconect the client }
    DisconnectButton.Enabled := TRUE;
end;

procedure TForm1.CliSocketSessionClosed(Sender: PObj; Error: Word);
begin
    DisconnectButton.Enabled := FALSE;
    InfoLabel.Caption := 'Waiting for client';{ Inform the user             }
end;

procedure TForm1.KOLForm1Show(Sender: PObj);

begin
    if FirstTime then
    begin
        FirstTime         := FALSE;            { Do it only once !          }
        SrvSocket.Addr    := '0.0.0.0';        { Use any interface          }
        SrvSocket.Listen;                      { Start listening for client }
        InfoLabel.Caption := 'Waiting for client';
    end;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  SrvSocket:=NewWSocket(nil);
  SrvSocket.Port:='telnet';
  CliSocket:=NewWSocket(nil);
  CliSocket.Port:='telnet';

  SrvSocket.OnSessionAvailable:=SrvSocketSessionAvailable;
 CliSocket.OnSessionClosed:=CliSocketSessionClosed;
end;

procedure TForm1.DisconnectButtonClick(Sender: PObj);
begin
    CliSocket.ShutDown(2);                    { Shut the communication down }
    CliSocket.Close;                          { Close the communication     }
end;


end.


