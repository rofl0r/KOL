unit kolthreadsync;

interface

uses Kol,windows;

type
{ Thread synchronization }

{ TMultiReadExclusiveWriteSynchronizer minimizes thread serialization to gain
  read access to a resource shared among threads while still providing complete
  exclusivity to callers needing write access to the shared resource.
  (multithread shared reads, single thread exclusive write)
  Reading is allowed while owning a write lock.
  Read locks can be promoted to write locks.}

  TActiveThreadRecord = record
    ThreadID: Integer;
    RecursionCount: Integer;
  end;

  TActiveThreadArray = array of TActiveThreadRecord;

  PMrEw=^TmultireadExclusiveWriteSynchronizer;

  TMultiReadExclusiveWriteSynchronizer = object(Tobj)
  private
    FLock: TRTLCriticalSection;
    FReadExit: THandle;
    FCount: Integer;
    FSaveReadCount: Integer;
    FActiveThreads: TActiveThreadArray;
    FWriteRequestorID: Integer;
    FReallocFlag: Integer;
    FWriting: Boolean;
    function WriterIsOnlyReader: Boolean;
  public
    destructor Destroy; virtual;
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
  end;

function NewMrEw:PMrEw;

implementation
{ TMultiReadExclusiveWriteSynchronizer }

//constructor TMultiReadExclusiveWriteSynchronizer.Create;
function NewMrEw:PMrEw;
begin
  New(Result, Create);
  with Result^do
  begin
    InitializeCriticalSection(FLock);
    FReadExit := CreateEvent(nil, True, True, nil);  // manual reset, start signaled
    SetLength(FActiveThreads, 4);
  end;
end;

destructor TMultiReadExclusiveWriteSynchronizer.Destroy;
begin
  BeginWrite;
  inherited Destroy;
  CloseHandle(FReadExit);
  DeleteCriticalSection(FLock);
end;

function TMultiReadExclusiveWriteSynchronizer.WriterIsOnlyReader: Boolean;
var
  I, Len: Integer;
begin
  Result := False;
  if FWriteRequestorID = 0 then Exit;
  // We know a writer is waiting for entry with the FLock locked,
  // so FActiveThreads is stable - no BeginRead could be resizing it now
  I := 0;
  Len := High(FActiveThreads);
  while (I < Len) and
    ((FActiveThreads[I].ThreadID = 0) or (FActiveThreads[I].ThreadID = FWriteRequestorID)) do
    Inc(I);
  Result := I >= Len;
end;

procedure TMultiReadExclusiveWriteSynchronizer.BeginWrite;
begin
  EnterCriticalSection(FLock);  // Block new read or write ops from starting
  if not FWriting then
  begin
    FWriteRequestorID := GetCurrentThreadID;   // Indicate that writer is waiting for entry
    if not WriterIsOnlyReader then              // See if any other thread is reading
      WaitForSingleObject(FReadExit, INFINITE); // Wait for current readers to finish
    FSaveReadCount := FCount;  // record prior read recursions for this thread
    FCount := 0;
    FWriteRequestorID := 0;
    FWriting := True;
  end;
  Inc(FCount);  // allow read recursions during write without signalling FReadExit event
end;

procedure TMultiReadExclusiveWriteSynchronizer.EndWrite;
begin
  Dec(FCount);
  if FCount = 0 then
  begin
    FCount := FSaveReadCount;  // restore read recursion count
    FSaveReadCount := 0;
    FWriting := False;
  end;
  LeaveCriticalSection(FLock);
end;

procedure TMultiReadExclusiveWriteSynchronizer.BeginRead;
var
  I: Integer;
  ThreadID: Integer;
  ZeroSlot: Integer;
begin
  EnterCriticalSection(FLock);
  try
    if not FWriting then
    begin
      // This will call ResetEvent more than necessary on win95, but still work
      if InterlockedIncrement(FCount) = 1 then
        ResetEvent(FReadExit); // Make writer wait until all readers are finished.
      I := 0;  // scan for empty slot in activethreads list
      ThreadID := GetCurrentThreadID;
      ZeroSlot := -1;
      while (I < High(FActiveThreads)) and (FActiveThreads[I].ThreadID <> ThreadID) do
      begin
        if (FActiveThreads[I].ThreadID = 0) and (ZeroSlot < 0) then ZeroSlot := I;
        Inc(I);
      end;
      if I >= High(FActiveThreads) then  // didn't find our threadid slot
      begin
        if ZeroSlot < 0 then  // no slots available.  Grow array to make room
        begin   // spin loop.  wait for EndRead to put zero back into FReallocFlag
          while InterlockedExchange(FReallocFlag, ThreadID) <> 0 do  Sleep(0);
          try
            SetLength(FActiveThreads, High(FActiveThreads) + 3);
          finally
            FReallocFlag := 0;
          end;
        end
        else  // use an empty slot
          I := ZeroSlot;
        // no concurrency issue here.  We're the only thread interested in this record.
        FActiveThreads[I].ThreadID := ThreadID;
        FActiveThreads[I].RecursionCount := 1;
      end
      else  // found our threadid slot.
        Inc(FActiveThreads[I].RecursionCount); // thread safe = unique to threadid
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TMultiReadExclusiveWriteSynchronizer.EndRead;
var
  I, ThreadID, Len: Integer;
begin
  if not FWriting then
  begin
    // Remove our threadid from the list of active threads
    I := 0;
    ThreadID := GetCurrentThreadID;
    // wait for BeginRead to finish any pending realloc of FActiveThreads
    while InterlockedExchange(FReallocFlag, ThreadID) <> 0 do  Sleep(0);
    try
      Len := High(FActiveThreads);
      while (I < Len) and (FActiveThreads[I].ThreadID <> ThreadID) do Inc(I);
      assert(I < Len);
      // no concurrency issues here.  We're the only thread interested in this record.
      Dec(FActiveThreads[I].RecursionCount); // threadsafe = unique to threadid
      if FActiveThreads[I].RecursionCount = 0 then
        FActiveThreads[I].ThreadID := 0; // must do this last!
    finally
      FReallocFlag := 0;
    end;
    if (InterlockedDecrement(FCount) = 0) or WriterIsOnlyReader then
      SetEvent(FReadExit);     // release next writer
  end;
end;

end.