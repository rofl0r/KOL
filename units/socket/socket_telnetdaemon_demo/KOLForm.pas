{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLSocket {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls, mckObjs, mckSocket {$ENDIF}, Sockets;
{$ELSE}
{$I uses.inc} mirror,
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
    Applet: TKOLApplet;
    RE1: TKOLRichEdit;
    RE2: TKOLRichEdit;
    LV: TKOLListView;
    TelnetD: TKOLProject;
    KOLForm: TKOLForm;
    Idle: TKOLTimer;
    m_ServerSocket: TKOLSocket;

    procedure OnListen(SocketMessage: TWMSocket);
    procedure OnAccept(SocketMessage: TWMSocket);
    procedure OnError(SocketMessage: TWMSocket);
    procedure OnClose(SocketMessagE: TWMSocket);
    procedure KOLFormFormCreate(Sender: PObj);
    procedure AddSocket(fSocket: PClientSocket);
    function  LoginUser(var n, p: string; var iwr, ord: THandle; var pi: process_information): boolean;
    procedure BroadCast(fString: string);
    procedure FreeGarbage;
    procedure IdleTimer(Sender: PObj);
    procedure KOLFormDestroy(Sender: PObj);
    procedure KOLFormShow(Sender: PObj);

  private
    { Private declarations }
    ingarbage: boolean;
  public
    m_GarbageList: PList;
    { Public declarations }
  end;
var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}

procedure TForm1.OnAccept(SocketMessage: TWMSocket);
var
  tempSocket: PClientSocket;
begin
  tempSocket := NewClientSocket;
  m_ServerSocket.DoAccept(tempSocket.socket);
  AddSocket(tempSocket);
  RE1.Add('(SYS) ACCEPT ON SERVERSOCKET ' +
    Int2Str(SocketMessage.SocketNumber) + #13#10);
end;

procedure TForm1.OnListen(SocketMessage: TWMSocket);
begin
  RE1.Add('(SYS) LISTEN ON SERVERSOCKET ' +
    Int2Str(SocketMessage.SocketNumber) + #13#10);
end;

procedure TForm1.OnError(SocketMessage: TWMSocket);
begin
  RE1.Add('(ERR) ON SERVERSOCKET ' +
    Int2Str(SocketMessage.SocketNumber) + ' ' + m_ServerSocket.ErrToStr(SocketMessage.SocketError) + #13#10);
end;

procedure TForm1.OnClose(SocketMessage: TWMSocket);
begin
  RE1.Add('(SYS) CLOSE ON SERVERSOCKET ' +
    Int2Str(SocketMessage.SocketNumber) + #13#10);
end;

procedure TForm1.KOLFormFormCreate(Sender: PObj);
begin
   LV.LVColAdd('Connections', taLeft, LV.Width - 4);
   m_GarbageList := NewList;
   m_ServerSocket.DoListen;
end;

procedure TForm1.KOLFormDestroy(Sender: PObj);
var i: integer;
    t: PClientSocket;
begin
   Idle.Enabled := False;
   FreeGarbage;
   for i := 0 to LV.Count - 1 do begin
      t := PClientSocket(LV.LVItemData[i]);
      t.socket.DoClose;
   end;
   FreeGarbage;
   m_ServerSocket.DoClose;
   m_GarbageList.Free;
end;

procedure TForm1.AddSocket;
var
      l,
      p,
  ipadd: string;
begin
  ipadd := fSocket.socket.DoGetHostByAddr(PChar(fSocket.socket.IPAddress));
  if (ipadd = '') then ipadd := fSocket.socket.IPAddress;
  LV.LVAdd('Socket:  ' + Int2Str(fSocket.socket.SocketHandle) + ' from ' + ipadd, 0, [], 0, 0, dword(fSocket));
  fSocket.socket.SendString(#13#10'Telnet Daemon v 0.0 is greeting you.'#13#10#13#10);
  fSocket.logged := False;
  fSocket.socket.SendString('login: ');
  l := fSocket.socket.ReadLine(#13, 30);
  if l <> '' then begin
     fSocket.socket.SendString('password: ');
     p := fSocket.socket.ReadLine(#13, 30);
     if p <> '' then begin
        fSocket.socket.SendString(#13#10'loggin on ..');
        if LoginUser(l, p, fSocket.wrpipe, fSocket.rdpipe, fSocket.procin) then begin
           fSocket.socket.SendString(#13#10'logged on ..'#13#10#13#10);
           fSocket.logged := True;
           fSocket.readth.Resume;
           fSocket.waitth.Resume;
           exit;
        end;
        fSocket.socket.SendString(#13#10#13#10'login error'#13#10);
     end;
  end;
  fSocket.socket.DoClose;
end;

function  TForm1.LoginUser;
var
  User: THandle;
    si: startupinfo;
    sa: security_attributes;
    st: string;
    ii: integer;
   ird,
   owr: THandle;
    cs: array[0..255] of char;
begin
   result := False;
   st := '';
   for ii := 1 to length(n) do
      if n[ii] > #13 then st := st + n[ii];
   n := st;
   st := '';
   for ii := 1 to length(p) do
      if p[ii] > #13 then st := st + p[ii];
   p := st;
   if LogonUser(
             Pchar(n),
             nil,
             PChar(p),
             LOGON32_LOGON_INTERACTIVE,
             LOGON32_PROVIDER_DEFAULT,
             User) then begin
      GetEnvironmentVariable('COMSPEC', @cs, 256);
      fillchar(sa, sizeof(sa), #0);
      sa.nLength := sizeof(sa);
      sa.bInheritHandle := True;
      createpipe(ird, iwr, @sa, 0);
      createpipe(ord, owr, @sa, 0);
      sethandleinformation(iwr, HANDLE_FLAG_INHERIT, 0);
      sethandleinformation(ord, HANDLE_FLAG_INHERIT, 0);
      fillchar(si, sizeof(si), #0);
      si.cb := sizeof(si);
      si.lpDesktop := PChar('winsta0\default');
      si.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      si.wShowWindow := SW_HIDE;
      si.hStdInput  := ird;
      si.hStdOutput := owr;
      fillchar(pi, sizeof(pi), #0);
      if CreateProcessAsUser(
             User,
             @cs,
             '/Q',
             nil,
             nil,
             True,
             CREATE_NEW_CONSOLE,
             nil,
             nil,
             si,
             pi) then begin
         result := True;
         closehandle(ird);
         closehandle(owr);

      end;
   end;
end;

procedure TForm1.BroadCast;
var i: integer;
    t: PClientSocket;
begin
   RE2.Add(fString);
   for i := 0 to LV.Count - 1 do begin
      t := PClientSocket(LV.LVItemData[i]);
      t.socket.SendString(fString);
   end;
end;

procedure TForm1.FreeGarbage;
var t: PClientSocket;
begin
   if ingarbage then exit;
   ingarbage := true;
   while m_GarbageList.Count > 0 do begin
      t := m_GarbageList.Items[0];
      t.Free;
      m_GarbageList.Delete(0);
   end;
   ingarbage := false;
end;

procedure TForm1.IdleTimer(Sender: PObj);
begin
   FreeGarbage;
end;

procedure TForm1.KOLFormShow(Sender: PObj);
begin
   { to make listview columns visible }
   Form.Height := Form.Height + 10;
   Form.Height := Form.Height - 10;
end;

end.








