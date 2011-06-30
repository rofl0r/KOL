unit Sockets;

interface

uses KOL, KOLSocket, Windows;

type

  // TClientSocket - the socket that will be attached to an accept request.
  PClientSocket =^TClientSocket;
  TClientSocket = object( TObj )
  protected
    destructor Destroy; virtual;
  public
    LVData: dword;
    logged: boolean;
    rdpipe,
    wrpipe: THandle;
    procin: process_information;
    readth: PThread;
    waitth: PThread;
    socket: PAsyncSocket;
    procedure _OnRead (SocketMessage: TWMSocket);
    procedure _OnError(SocketMessage: TWMSocket);
    procedure _OnClose(SocketMessage: TWMSocket);
    function   ReadOut(Sender: PThread): integer;
    function   WaitCmd(Sender: PThread): integer;
  end;

  function NewClientSocket: PClientSocket;

implementation

uses KOLForm;

function NewClientSocket;
begin
   New(Result, Create);
   Result.LVData  := dword(Result);
   Result.readth  := NewThread;
   Result.readth.onExecute := Result.ReadOut;
   Result.waitth  := NewThread;
   Result.waitth.OnExecute := Result.WaitCmd;
   Result.socket  := NewAsyncSocket;
   Result.socket.OnRead  := Result._OnRead;
   Result.socket.OnError := Result._OnError;
   Result.socket.OnClose := Result._OnClose;
end;

destructor TClientSocket.Destroy;
begin
   readth.Free;
   socket.Free;
   inherited;
end;

procedure TClientSocket._OnRead;
var
  len: LongInt;
  buf: array[0..2047] of char;
  str: string;
  wrc: dword;
  iii: integer;
begin
  if logged then begin
     len := SocketMessage.SocketDataSize;
     if (len < 2048) then begin
       ZeroMemory(@buf, 2048);
       socket.ReadData(@Buf, len);
       str := '(ID:  ' + Int2Str(socket.SocketHandle) + ')  ' + Buf;
       for iii := 0 to len do if buf[iii] = #13 then buf[iii] := #10;
       writefile(wrpipe, buf, len, wrc, nil);
     end;
  end;
end;

procedure TClientSocket._OnError;
begin
  if SocketMessage.SocketNumber > 0 then begin
     Form1.RE1.Add('(ERR) ON CLIENTSOCKET ' +
       Int2Str(SocketMessage.SocketNumber) + ' ' + socket.ErrToStr(SocketMessage.SocketError) + #13#10);
     socket.DoClose;
  end;
end;

procedure TClientSocket._OnClose;
var i: integer;
    s: string;
begin
  Form1.RE1.Add('(SYS) CLOSE ON CLIENTSOCKET ' +
    Int2Str(SocketMessage.SocketNumber) + #13#10);
  s := #13#10'(ID:  ' + Int2Str(SocketMessage.SocketNumber) + ')  SIGNED OFF'#13#10;
  Form1.BroadCast(s);
  for i := 0 to Form1.LV.Count - 1 do begin
     if Form1.LV.LVItemData[i] = LVData then begin
        Form1.LV.LVDelete(i);
        break;
     end;
  end;
  Form1.m_GarbageList.Add(pointer(LVData));
  terminateprocess(procin.hProcess, 1);
end;

function TClientSocket.ReadOut;
var buf: array[0..1023] of char;
     rd: dword;
     st: string;
begin
    result := 0;
    while (socket.m_Handle <> INVALID_SOCKET) and (readfile(rdpipe, buf, sizeof(buf), rd, nil)) do begin
       buf[rd] := #0;
       Form1.RE2.Add(buf);
       st := buf;
       socket.SendString(st);
    end;
end;

function TClientSocket.WaitCmd;
begin
   result := 0;
   WaitForSingleObject(procin.hProcess, INFINITE);
   closehandle(procin.hProcess);
   socket.DoClose;
end;

end.
