// 26-nov-2002
unit IdThreadMgr;

interface

uses KOL { , 
  Classes }{ ,
  IdException},
  IdBaseComponent,
  IdThread,
  SyncObjs;

type
  TIdThreadMgr = object(TIdBaseComponent)
  protected
    FActiveThreads: PList;//TList;
    FLock: TCriticalSection;
//    FThreadClass: TIdThreadClass;
  public
     { constructor Create(AOwner: TComponent); override;
     } function CreateNewThread: PIdThread{TIdThread}; virtual;
    destructor Destroy;
     virtual; function GetThread: PIdThread{TIdThread}; virtual; abstract;
    procedure ReleaseThread(AThread: PIdThread{TIdThread}); virtual; abstract;
    procedure TerminateThreads(Threads: PList{TList});
    property ActiveThreads: PList read FActiveThreads;//TList read FActiveThreads;
    property Lock: TCriticalSection read FLock;
//    property ThreadClass: TIdThreadClass read FThreadClass write FThreadClass;
  end;
PIdThreadMgr=^TIdThreadMgr;
function NewIdThreadMgr(AOwner: PControl):PIdThreadMgr;
{ type  MyStupid0=DWord;

  EIdThreadMgrError = object(EIdException);
PdThreadMgr=^IdThreadMgr; type  MyStupid3137=DWord;
  EIdThreadClassNotSpecified = object(EIdThreadMgrError);
PThreadMgr=^dThreadMgr; type  MyStupid86104=DWord;
}
implementation

uses
  IdGlobal,
  IdResourceStrings,
  IdTCPServer,
  SysUtils;

//constructor TIdThreadMgr.Create(AOwner: TComponent);
function NewIdThreadMgr(AOwner: PControl):PIdThreadMgr;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
  FActiveThreads := NewList;//TList.Create;
  FLock := TCriticalSection.Create;
end;  
end;

function TIdThreadMgr.CreateNewThread: PIdThread{TIdThread};
begin
//  if ThreadClass = nil then
  begin
//    raise EIdThreadClassNotSpecified.create(RSThreadClassNotSpecified);
  end;
//  result := TIdThreadClass(ThreadClass).Create;
end;

destructor TIdThreadMgr.Destroy;
begin
  FreeAndNil(FActiveThreads);
  FreeAndNil(FLock);
  inherited;
end;

procedure TIdThreadMgr.TerminateThreads(Threads: {TList}PList);
var
  Thread: PIdThread;//TIdThread;
  i: integer;
begin
  for i := Threads.Count - 1 downto 0 do
  begin
    Thread := Threads.Items[i];//TObject(Threads.Items[i]) as TIdThread;
    //if Thread is TIdPeerThread then
    begin
     { TIdPeerThread}PIdPeerThread(Thread).Connection.Disconnect;
    end;
    ReleaseThread(Thread);
    Threads.Delete(i);
  end;
end;

end.
