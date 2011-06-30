unit KOLVMHSyncObjsKOL;

interface
uses Windows, kol;

type
  PCriticalSection = ^TCriticalSection;
  TCriticalSection = object(TObj)
  protected
    FSection: TRTLCriticalSection;
  public
    destructor Destroy; virtual;
    procedure Acquire; virtual;
    procedure Release; virtual;
    procedure Enter;
    procedure Leave;
  end;

  function NewCriticalSection : PCriticalSection;

implementation

{ TCriticalSection }

function NewCriticalSection : PCriticalSection;
begin
  New(Result, Create);
  InitializeCriticalSection(Result.FSection);
end;

destructor TCriticalSection.Destroy;
begin
  DeleteCriticalSection(FSection);
  inherited Destroy;
end;

procedure TCriticalSection.Acquire;
begin
  EnterCriticalSection(FSection);
end;

procedure TCriticalSection.Release;
begin
  LeaveCriticalSection(FSection);
end;

procedure TCriticalSection.Enter;
begin
  Acquire;
end;

procedure TCriticalSection.Leave;
begin
  Release;
end;

end.
 