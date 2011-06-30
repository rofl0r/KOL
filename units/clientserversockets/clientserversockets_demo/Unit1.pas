{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLScktComp {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,
  MckScktComp {$ENDIF};
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
    sckt: TKOLServerSocket;
    Memo1: TKOLMemo;
    Button1: TKOLButton;
    clnt: TKOLClientSocket;
    EditBox1: TKOLEditBox;
    Button2: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure EditBox1Char(Sender: PControl; var Key: Char;
      Shift: Cardinal);
    procedure Button2Click(Sender: PObj);
    procedure scktClientConnect(Sender: PObj; Socket: PCustomWinSocket);
    procedure scktAccept(Sender: PObj; Socket: PCustomWinSocket);
    procedure scktClientDisconnect(Sender: PObj; Socket: PCustomWinSocket);
    procedure scktClientError(Sender: PObj; Socket: PCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure scktGetThread(Sender: PObj;
      ClientSocket: PServerClientWinSocket;
      var SocketThread: PServerClientThread);
    procedure scktClientWrite(Sender: PObj; Socket: PCustomWinSocket);
    procedure clntConnect(Sender: PObj; Socket: PCustomWinSocket);
    procedure clntRead(Sender: PObj; Socket: PCustomWinSocket);
  private
    { Private declarations }
//    clnt : PClientSocket;
  public
    { Public declarations }

  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses ServerThread,err;


{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}


procedure TForm1.Button1Click(Sender: PObj);
begin
  try
     case Sender.Tag of
       0: begin
           sckt.Port:=5000;
           sckt.ServerType:=stThreadBlocking;
           sckt.active:=true;
           Sender.Tag:=1;
           TKOLButton(Sender).Caption:='Stop Server'
       end;
       1: begin
           sckt.active:=false;
           Sender.Tag:=0;
           TKOLButton(Sender).Caption:='Start Server'
       end;
     end;
  except on e:Exception do
     ShowMessage(e.Message);
  end;

end;
procedure TForm1.Button2Click(Sender: PObj);
begin
  try
     case Sender.Tag of
       0: begin
           clnt.Port:=5000;
           clnt.Host:='127.0.0.1';
           clnt.Active:=true;
           Sender.Tag:=1;
           TKOLButton(Sender).Caption:='Stop Client'
       end;
       1: begin
           clnt.Active:=false;
           Sender.Tag:=0;
           TKOLButton(Sender).Caption:='Start Client'
       end;
     end;
  except on e:Exception do
     ShowMessage(e.Message);
  end;
end;
procedure TForm1.EditBox1Char(Sender: PControl; var Key: Char;
  Shift: Cardinal);
var
  sz : DWORD;
  s : string;
begin
  if key=#13 then begin
     s:=EditBox1.Text;
     sz:=length(s);
     clnt.Socket.SendBuf(sz,sizeof(sz));
     clnt.Socket.SendText(s);
  end;
end;
procedure TForm1.scktClientConnect(Sender: PObj; Socket: PCustomWinSocket);
begin
  Memo1.add('Server>> Client Connected '+socket.RemoteAddress+#13#10);

end;

procedure TForm1.scktAccept(Sender: PObj; Socket: PCustomWinSocket);
begin
  Memo1.add('Server>> Client Accepted '+socket.RemoteAddress+#13#10);
end;

procedure TForm1.scktClientDisconnect(Sender: PObj;
  Socket: PCustomWinSocket);
begin
  Memo1.add('Server>> Client Disconnected '+socket.RemoteAddress+#13#10);
end;

procedure TForm1.scktClientError(Sender: PObj; Socket: PCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin

  Memo1.add('Server>> Client Error '+socket.RemoteAddress+Int2Str(ErrorCode)+' '+#13#10);
end;

procedure TForm1.scktGetThread(Sender: PObj;
  ClientSocket: PServerClientWinSocket;
  var SocketThread: PServerClientThread);
begin
SocketThread :=  NewServerThread( FALSE, ClientSocket );
SocketThread.ThreadPriority:=THREAD_PRIORITY_NORMAL;
end;

procedure TForm1.scktClientWrite(Sender: PObj; Socket: PCustomWinSocket);
begin
  Memo1.add('Server>> '+Socket.ReceiveText+#13#10);
end;
procedure TForm1.clntConnect(Sender: PObj; Socket: PCustomWinSocket);
begin
  Memo1.add('Client>> Connected '+socket.RemoteAddress+#13#10);
end;
Procedure TForm1.clntRead(Sender: PObj; Socket: PCustomWinSocket);
begin
  Memo1.add('Client Read>> '+Socket.ReceiveText+#13#10);
end;

end.











