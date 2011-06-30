{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLSocket {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls, mckObjs,  mckSocket, {$ENDIF}, Sockets, WinSock;{$ELSE}
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
    KOLProject: TKOLProject;
    KOLForm1: TKOLForm;
    KOLApplet1: TKOLApplet;
    Button1: TKOLButton;
    EditBox1: TKOLEditBox;
    Timer1: TKOLTimer;
    Button2: TKOLButton;
    ListView1: TKOLListView;
    Panel1: TKOLPanel;
    RichEdit1: TKOLRichEdit;
    ServerSocket: TKOLSocket;
    ClientSocket: TKOLSocket;
    Button3: TKOLButton;
    EditBox2: TKOLEditBox;
    Button4: TKOLButton;

    procedure ServerSocketAccept(SocketMessage: TWMSocket);
    procedure ServerSocketClose(SocketMessage: TWMSocket);
    procedure ServerSocketListen(SocketMessage: TWMSocket);
    procedure ServerSocketError(SocketMessage: TWMSocket);

    procedure AddSocket(fSocket: PClientSocket);
    procedure ServerSend(fString: string);
    procedure BroadCast(fString: string);
    procedure ServerConnect;
    procedure ServerDisconnect;
    procedure SockError(Err: String);
    procedure ServerCloseConnect;
    procedure SrvClosing;
    procedure FreeGarbage;

    procedure ClientConnect;
    procedure ClientDisconnect;

    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLTimer1Timer(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure EditBox1KeyUp(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure ClientSocketConnect(SocketMessage: TWMSocket);
    procedure ClientSocketRead(SocketMessage: TWMSocket);
    procedure Button3Click(Sender: PObj);
    procedure ClientSocketError(SocketMessage: TWMSocket);
    procedure ClientSocketClose(SocketMessage: TWMSocket);
    procedure Button4Click(Sender: PObj);

  private
    { Private declarations }
    ingarbage: boolean;
  public
//    m_ServerSocket: PAsyncSocket;
    m_GarbageList: PList;
    { Public declarations }
  end;
var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  constat: boolean = false;
  constatc: boolean = false;
  ClntSrv: Integer = 0;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}



procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
Form.StatusPanelRightX[0]:=75;
Form.StatusPanelRightX[1]:=Form.StatusPanelRightX[0]+90;
m_GarbageList:=NewList;
end;


// TODO: SERVER
//Connecting
procedure TForm1.ServerConnect;
begin
Form.StatusText[0]:=PChar('Connected ['+Int2Str(ListView1.Count)+']');
Form.StatusText[1]:='Server'; /////
Button1.Enabled:=True;
EditBox1.Enabled:=True;
EditBox1.Color:=clWindow;
ClntSrv:=1;
end;



procedure TForm1.ServerDisconnect;
begin
if ListView1.Count>0 then
   Form.StatusText[0]:=PChar('Connected ['+Int2Str(ListView1.Count)+']')
   else
   begin
   Form.StatusText[0]:=PChar('Disconnected');
   Form.StatusText[1]:=''; /////
   Button1.Enabled:=False;
   EditBox1.Enabled:=False;
   EditBox1.Color:=clBtnFace;
   ClntSrv:=0;
   end;
end;



procedure TForm1.ServerSocketAccept(SocketMessage: TWMSocket);
var
  tempSocket: PClientSocket;

begin
tempSocket:=NewClientSocket;
ServerSocket.DoAccept(PAsyncSocket(tempSocket));
AddSocket(tempSocket);
ServerConnect;
end;



procedure TForm1.ServerSocketClose(SocketMessage: TWMSocket);
begin
ServerDisconnect;
end;


// Removing this null procedure wil give you exept situation
procedure TForm1.ServerSocketListen(SocketMessage: TWMSocket);
begin
//
end;



procedure TForm1.ServerSocketError(SocketMessage: TWMSocket);
begin
SockError(ServerSocket.ErrToStr(SocketMessage.SocketError));
end;


// Post Socket Errr Message
procedure TForm1.SockError;
begin
Form.StatusText[2]:=PChar(Err);
end;



procedure TForm1.AddSocket;
var
  ipadd: String;

begin
ipadd:=fSocket.DoGetHostByAddr(PChar(fSocket.IPAddress));
if (ipadd = '') then ipadd:=fSocket.IPAddress;
ListView1.LVAdd(Int2Str(dword(fSocket)), 0, [], 0, 0, dword(fSocket));
end;



procedure TForm1.BroadCast;
begin
RichEdit1.Add(fString+#13#10);
end;



procedure TForm1.ServerSend;
var
  i: integer;
  t: PClientSocket;

begin
for i:=0 to ListView1.Count-1 do
   begin
   t:=PClientSocket(ListView1.LVItemData[i]);
   t.SendString(fString);
   end;
end;


// Close All Connected Clients 
procedure TForm1.ServerCloseConnect;
var
  i: integer;

begin
for i:=0 to ListView1.Count-1 do
   begin
   SrvClosing;
   end;
end;


//Sub program Closing all clients
procedure TForm1.SrvClosing;
var
  t: PClientSocket;

begin
t:=PClientSocket(ListView1.LVItemData[0]);
t.DoClose;
end;



procedure TForm1.FreeGarbage;
var
  t: PClientSocket;

begin
if ingarbage then exit;
ingarbage:=true;
while m_GarbageList.Count>0 do
   begin
   t:=m_GarbageList.Items[0];
   t.Free;
   m_GarbageList.Delete(0);
   end;
ingarbage:=false;
end;



procedure TForm1.KOLTimer1Timer(Sender: PObj);
begin
FreeGarbage;
end;



// TODO: CLIENT

procedure TForm1.ClientConnect;
begin
{ClientSocket.DoClose;
ClientSocket.IPAddress := '127.0.0.1';
ClientSocket.DoConnect;}
Form.StatusText[0]:='Connected';
Form.StatusText[1]:='Client';
Form.StatusText[2]:='';
Button1.Enabled:=True;
EditBox1.Enabled:=True;
EditBox1.Color:=clWindow;
Button3.Caption:='Discnnect';
constatc:=True;
ClntSrv:=2;
end;



procedure TForm1.ClientDisconnect;
begin
Form.StatusText[0]:='Disconnected';
Form.StatusText[1]:='';
Form.StatusText[2]:='';
Button1.Enabled:=False;
EditBox1.Enabled:=False;
EditBox1.Color:=clBtnFace;
Button3.Caption:='Connect';
constatc:=False;
ClntSrv:=0;
//if ClientSocket <> nil then ClientSocket.DoClose;
end;


procedure TForm1.ClientSocketConnect(SocketMessage: TWMSocket);
begin
ClientConnect;
end;


procedure TForm1.ClientSocketClose(SocketMessage: TWMSocket);
begin
ClientDisconnect;
end;


procedure TForm1.ClientSocketRead(SocketMessage: TWMSocket);
var
  c: char;
begin
//c:=''[1]; // might not have been initialized :)
RichEdit1.Add(ClientSocket.ReadLine(c)+#13+#10);
//Socket1.(RichEdit1.Add);
//ReceiveText);
end;




// END OF CLIENT-SERVER EVENT

// Client/Server - POST MESSAGE 1-Server; 2-Client;
procedure TForm1.Button1Click(Sender: PObj);
var
  s: string;
begin
//RichEdit1.Add(m_ServerSocket.LocalIP);
if Length(EditBox1.Text)>0 then
   begin
   if ClntSrv=1 then
      begin
      s:='Server: '+EditBox1.Text;
      EditBox1.Text:='';
      Form1.ServerSend(s);
      RichEdit1.Add(s+#13#10);
      end;
   if ClntSrv=2 then
      begin
      s:='Client: '+EditBox1.Text;
      EditBox1.Text:='';
      ClientSocket.SendString(s);
      RichEdit1.Add(s+#13#10);
      end;
   end;
end;



procedure TForm1.EditBox1KeyUp(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
if Key=VK_RETURN then Button1Click(nil);
end;


// Server LISTEN
procedure TForm1.Button2Click(Sender: PObj);
begin
Form.StatusText[2]:='';
if not constat then
   begin
//   Form.StatusText[2]:='';
   ServerSocket.DoListen;
   Button2.Caption:='Stop';
   Button3.Enabled:=False;
   ClntSrv:=1;
   constat:= not constat;
   end
   else
   begin
//   Form.StatusText[2]:='';
   ServerCloseConnect;
   ServerSocket.DoClose;
   Button2.Caption:='Listen';
   Button3.Enabled:=True;
   ClntSrv:=0;
   constat:= not constat;
   end;
end;


// Client Connect
procedure TForm1.Button3Click(Sender: PObj);
begin
if not constatc then
   begin
   ClientSocket.IPAddress:=EditBox2.Text;
   ClientSocket.DoConnect;
   Button3.Caption:='Disconnect';
   constatc:= not constatc;
   ClientDisconnect;
   end
   else
   begin
   ClientSocket.DoClose;
   Button3.Caption:='Connect';
   constatc:= not constatc;
   ClientDisconnect;
   end;
end;



procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
if ClntSrv=1 then
   begin
   ServerCloseConnect;
   FreeGarbage;
   ServerSocket.Free;
   m_GarbageList.Free;
   end;
if ClntSrv=2 then
   begin
   ClientSocket.DoClose;
   end;
end;


procedure TForm1.ClientSocketError(SocketMessage: TWMSocket);
begin
SockError(ClientSocket.ErrToStr(SocketMessage.SocketError));
end;


procedure TForm1.Button4Click(Sender: PObj);

var
  Name: TSockAddrIn;
  len: integer;
  str: String;
//  sock: TAsyncSocket;

begin
GetSockName(ClientSocket.m_Handle, Name, len);
str:=int2str(ord(Name.sin_addr.S_un_b.s_b1))+'.'+
      int2str(ord(Name.sin_addr.S_un_b.s_b2))+'.'+
      int2str(ord(Name.sin_addr.S_un_b.s_b3))+'.'+
      int2str(ord(Name.sin_addr.S_un_b.s_b4));

//str:=sock.LocalIP;
EditBox2.Text:=str;
end;

end.

