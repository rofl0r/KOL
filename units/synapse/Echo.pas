unit echo;

interface

uses
	KOL, blcksock, winsock;

type
	PTCPEchoDaemon = ^TTCPEchoDaemon;
	TTCPEchoDaemon = object(TThread)
	private
		Sock : PTCPBlockSocket;
	public
		function Execute : Integer;
	end;

	PTCPEchoThrd = ^TTCPEchoThrd;
	TTCPEchoThrd = object(TThread)
	private
		Sock : PTCPBlockSocket;
	public
		function Execute : Integer;
	end;

 function NewEchoDaemon : PTCPEchoDaemon;

 function NewEchoThrd(hSock : TSocket) : PTCPEchoThrd;

implementation

{ TEchoDaemon }

function NewEchoDaemon : PTCPEchoDaemon;
begin
	New(Result,Create);
	Result.Sock := NewTCPBlockSocket('');
	Result.Add2AutoFree(Result.Sock);
	Result.AutoFree := true;
//	Result.PriorityClass := NORMAL_PRIORITY_CLASS;
//	Result.ThreadPriority := THREAD_PRIORITY_NORMAL;
	if Result.Suspended then Result.Resume;
end;


function TTCPEchoDaemon.Execute : Integer;
var
	ClientSock : TSocket;
begin
	Result := 0;
	with Sock^ do
		begin
			CreateSocket;
			SetLinger(true,10);
			Bind('0.0.0.0','echo');
			Listen;
			repeat
				if Terminated then Break;
				if CanRead(1000) then
					begin
						ClientSock := Accept;
						if LastError = 0 then NewEchoThrd(ClientSock);
					end;
			until False;
		end;
end;

{ TEchoThrd }

function NewEchoThrd(hSock : TSocket) : PTCPEchoThrd;
begin
	New(Result,Create);
	Result.Sock := NewTCPBlockSocket('');
	Result.Add2AutoFree(Result.Sock);
	Result.AutoFree := true;
	Sock.Socket := hSock;
//	Result.PriorityClass := NORMAL_PRIORITY_CLASS;
//	Result.ThreadPriority := THREAD_PRIORITY_NORMAL;
	if Result.Suspended then Result.Resume;
end;


function TTCPEchoThrd.Execute : Integer;
var
	b:byte;
begin
	Result := 0;
	with Sock^ do
		begin
			repeat
				if Terminated then Break;
				b := Recvbyte(60000);
				if LastError<>0 then Break;
				Sendbyte(b);
				if LastError<>0 then Break;
			until false;
		end;
end;

end.
