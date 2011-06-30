unit Sockets;

interface

uses KOLSocket, Windows;

type

  // TClientSocket - the socket that will be attached to an accept request.
  PClientSocket =^TClientSocket;
  TClientSocket = object(TAsyncSocket)
  public
    LVData: dword;
    procedure _OnRead(SocketMessage: TWMSocket);
    procedure _OnError(SocketMessage: TWMSocket);
    procedure _OnClose(SocketMessage: TWMSocket);
  end;

  function NewClientSocket: PClientSocket;

implementation
uses KOLForm, Kol;



function NewClientSocket;
begin
Result := PClientSocket(NewAsyncSocket);
Result.LVData := dword(Result);
Result.OnRead := Result._OnRead;
Result.OnError := Result._OnError;
Result.OnClose := Result._OnClose;
end;



procedure TClientSocket._OnRead;
var
  len: LongInt;
  buf: array[0..2047] of char;
  str: string;

begin
len:=SocketMessage.SocketDataSize;
if (len<2048) then
   begin
   ZeroMemory(@buf, 2048);
   ReadData(@Buf, len);
   str:=Buf;
   Form1.BroadCast(str);
   end;
end;



procedure TClientSocket._OnError;
begin
if SocketMessage.SocketNumber>0 then
   begin
   Form1.SockError(ErrToStr(SocketMessage.SocketError));
   DoClose;
   end;
end;



procedure TClientSocket._OnClose;
var
  i: integer;

begin
for i:=0 to Form1.ListView1.Count-1 do
   begin
   if Form1.ListView1.LVItemData[i]=LVData then
      begin
      Form1.ListView1.LVDelete(i);
      break;
      end;
   end;

Form1.m_GarbageList.Add(pointer(LVData));
Form1.ServerDisconnect;
end;

end.
