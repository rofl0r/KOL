// 25-nov-2002
unit IdThreadMgrDefault;

interface

uses KOL, 
  IdThread, IdThreadMgr;

type
  TIdThreadMgrDefault = object(TIdThreadMgr)
  public
    function GetThread: PIdThread{TIdThread}; virtual;// abstract;// override;
    procedure ReleaseThread(AThread: PIdThread{TIdThread});virtual;// override;
  end;
PIdThreadMgrDefault=^TIdThreadMgrDefault;

function NewIdThreadMgrDefault(AOwner: PObj):PIdThreadMgrDefault;

implementation

uses
  IdGlobal;

function NewIdThreadMgrDefault(AOwner: PObj):PIdThreadMgrDefault;
begin
  New( Result, Create );
end;

function TIdThreadMgrDefault.GetThread: PIdThread{TIdThread};
begin
  result := CreateNewThread;
  Lock.Enter;
  try
//    ActiveThreads.Add(result);
  finally Lock.Leave;
  end;
end;

procedure TIdThreadMgrDefault.ReleaseThread(AThread: PIdThread{TIdThread});
begin
  if not IsCurrentThread(AThread) then
  begin
    AThread.TerminateAndWaitFor;
    AThread.Free;
  end
  else
  begin
//    AThread.FreeOnTerminate := True;
  end;
  Lock.Enter;
  try
//    ActiveThreads.Remove(AThread);
  finally Lock.Leave;
  end;
end;

end.
