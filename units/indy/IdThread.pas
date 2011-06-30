// 22-nov-2002
unit IdThread;

interface

uses KOL { , 
  Classes } , SysUtils;

type
  TIdThreadStopMode = (smTerminate, smSuspend);
  TIdExceptionEvent = procedure(Sender: TObject; E: Exception) of object;

  TIdThread = object(TThread)
  protected
    FDatas: PObj;//TObject;
    FStopMode: TIdThreadStopMode;
    FStopped: Boolean;
    FTerminatingException: string;
    FOnException: TIdExceptionEvent;
    function GetStopped: Boolean;

    function DoExecute(Sender:PThread): integer; virtual;
    procedure Run; virtual; abstract;
    procedure AfterRun; virtual;
    procedure BeforeRun; virtual;
  public
    procedure Init; virtual;
     { constructor Create(ACreateSuspended: Boolean = True); virtual;
     } destructor Destroy; 
     virtual; procedure Start;
    procedure Stop;
    procedure Synchronize(Method: TThreadMethod);
    procedure TerminateAndWaitFor; virtual;
    property TerminatingException: string read FTerminatingException;

    property Datas: PObj{TObject} read FDatas write FDatas;
    property StopMode: TIdThreadStopMode read FStopMode write FStopMode;
    property Stopped: Boolean read GetStopped;
    property OnException: TIdExceptionEvent read FOnException write
      FOnException;

//    property Terminated;
  end;
PIdThread=^TIdThread;
function NewIdThread(ACreateSuspended: Boolean = True):PIdThread;// type  MyStupid0=DWord;

//  TIdThreadClass = object (TObj)of TIdThread;

implementation

uses
  IdGlobal;

procedure TIdThread.TerminateAndWaitFor;
begin
  Terminate;
  FStopped := True;
  WaitFor;
end;
//PdThread=^IdThread; type  MyStupid3137=DWord;

procedure TIdThread.AfterRun;
begin
end;

procedure TIdThread.BeforeRun;
begin
end;

//procedure TIdThread.Execute;
function TIdThread.DoExecute(Sender:PThread): integer;
begin
  try
    while not Terminated do
    try
      if Stopped then
      begin
        Suspend;// := True;
        if Terminated then
        begin
          Break;
        end;
      end;
      BeforeRun;
      while not Stopped do
      begin
        Run;
      end;
    finally
      AfterRun;
    end;
  except
    on E: exception do
    begin
      FTerminatingException := E.Message;
            if Assigned(FOnException) then
        FOnException(@self, E);
      Terminate;
    end;
  end;
end;

procedure TIdThread.Synchronize(Method: TThreadMethod);
begin
  inherited Synchronize(Method);
end;

//constructor TIdThread.Create(ACreateSuspended: Boolean);
function NewIdThread(ACreateSuspended: Boolean):PIdThread;
begin
  New( Result, Create );
  Result.Init;
//  inherited;
  with Result^ do
  begin
  FStopped := ACreateSuspended;
//  FOnExecute:=DoExecute;
  end;

end;

procedure TIdThread.Init;
begin
  inherited;
//    with Result^ do
  begin
//  FStopped := ACreateSuspended;
  FOnExecute:=DoExecute;
  end;
end;

destructor TIdThread.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

procedure TIdThread.Start;
begin
  if Stopped then
  begin
    FStopped := False;
    Resume;
//    Suspended := False;
  end;
end;

procedure TIdThread.Stop;
begin
  if not Stopped then
  begin
    case FStopMode of
      smTerminate: Terminate;
      smSuspend: ;
    end;
    FStopped := True;
  end;
end;

function TIdThread.GetStopped: Boolean;
begin
  Result := Terminated or FStopped;
end;

end.
