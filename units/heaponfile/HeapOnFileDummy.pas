unit HeapOnFileDummy;
{* Contains THeapOnFile object. (C) by Vladimir Kladov, 2001. }

interface

uses Windows, KOL;

type
  PHeapOnFile = ^THeapOnFile;
  THeapOnFile = object( TObj )
  {* This is dummy mirror of real THeapOnFile object. }
  private
    FRecordSize: Integer;
    //FAllocMap: PBits;
    //FLoadsMap: PBits;
    //FFile: PStream;
    //fLoaded: PList;
    //fUnloadQueue: PList;
    FMaxUnloadQueueSize: Integer;
    //procedure UnloadFirst;
    procedure SetMaxUnloadQueueSize(const Value: Integer);
  protected
  public
    destructor Destroy; virtual;
    property RecordSize: Integer read FRecordSize;
    {* Size of record. File is contained of fixed length records, and record size
       can not be changed after creating heap on file object. }
    function Get: Integer;
    {* Allocates a record and returns its index. To load the record into memory,
       and to allocate a memory for it, use then Lock method. }
    function Lock( N: Integer ): Pointer;
    {* Locks allocated record in memory. The record can be locked several times.
       It is more efficiently to lock the same record again to use LockAgain method.
       When record is unlocked (using UnLock method), it is added to a queue for
       further unloading to a file and removing from memory. }
    procedure LockAgain( P: Pointer );
    {* See Lock method. LockAgain can be applied only to locked already record. }
    function UnLock( P: Pointer ): Integer;
    {* Decreases unlock counter for a record, and when it becomes 0, the record is
       added to unload queue, for further unloading from memory to a file. If a
       record is therefore locked again while it is yet in unload queue, it is
       locked faster, because it is yet in memory. }
    procedure Release( N: Integer );
    {* Unlocks and releases a record. Therefore, if a record is locked several
       times, it can not be released immediately. Actually such record will be
       released only after the last UnLock call, when lock count become 0 for a
       record.}
    property MaxUnloadQueueSize: Integer read FMaxUnloadQueueSize write SetMaxUnloadQueueSize;
    {* Determnies how much records are stored in unload queue awaiting for unloading.
       When this value is sufficiently great, this can imrove application performance
       for case when a big group of records is requested repeatedly. }
  end;

function NewHeapOnFile( const FilePath: String; RecordSize: Integer ): PHeapOnFile;

implementation

type
  PData = ^TData;
  TData = packed Record
    Idx: Integer;
    Lck: Integer;
  end;

function NewHeapOnFile( const FilePath: String; RecordSize: Integer ): PHeapOnFile;
begin
  new( Result, Create );
  Result.FRecordSize := RecordSize;
  //Result.FAllocMap := NewBits;
  //Result.FLoadsMap := NewBits;
  //Result.fLoaded := NewList;
  //Result.fUnloadQueue := NewList;
  //Result.FFile := NewReadWriteFileStream( FilePath );
end;

{ THeapOnFile }

destructor THeapOnFile.Destroy;
{var P: PData;
    I: Integer;}
begin
  {for I := fLoaded.Count-1 downto 0 do
  begin
    P := fLoaded.Items[ I ];
    FreeMem( P );
  end;
  fLoaded.Free;
  fUnloadQueue.Free;
  FAllocMap.Free;
  FLoadsMap.Free;
  FFile.Free;}
  inherited;
end;

function THeapOnFile.Get: Integer;
var P: Pointer;
begin
  {Result := FAllocMap.IndexOf( FALSE );
  if Result = -1 then
    Result := FAllocMap.Count;
  FAllocMap.Bits[ Result ] := TRUE;}
  GetMem( P, FRecordSize );
  Result := Integer( P );
end;

function THeapOnFile.Lock(N: Integer): Pointer;
begin
  Result := Pointer( N );
end;
{
var P: PData;
    Mem: Pointer;
    I: Integer;
begin
  if not FAllocMap.Bits[ N ] then
    FAllocMap.Bits[ N ] := TRUE;
  if FLoadsMap.Bits[ N ] then
  begin //* Already loaded - search it!
    P := nil;
    for I := 0 to fLoaded.Count-1 do
    begin
      P := fLoaded.Items[ I ];
      if P.Idx = N then break;
    end;
    Assert( P <> nil, 'HeapOnFile: Lock error - record not found.' );
    if P.Lck = 0 then
    begin
      //* exclude here record P, ready to unload, from unload queue:
      I := fUnloadQueue.IndexOf( P );
      Assert( I >= 0,
      'HeapOnFile: Lock error - can not exclude record from unload queue.' );
      fUnloadQueue.Delete( I );
    end;
    if P.Lck >= 0 then
      Inc( P.Lck )
    else
      Dec( P.Lck );
  end
    else
  begin
    GetMem( P, Sizeof( TData ) + FRecordSize );
    P.Idx := N;
    P.Lck := 1;
    fLoaded.Add( P );
    FLoadsMap.Bits[ N ] := TRUE;
    FFile.Position := N * FRecordSize;
    if FFile.Position < FFile.Size then
    begin
      Mem := Pointer( Integer( P ) + Sizeof( P^ ) );
      FFile.Read( Mem^, FRecordSize );
    end;
  end;
  Result := Pointer( Integer( P ) + Sizeof( P^ ) );
end;
}

procedure THeapOnFile.LockAgain(P: Pointer);
begin
  //Result := P;
end;
{var D: PData;
begin
  D := Pointer( Integer( P ) - Sizeof( TData ) );
  if D.Lck >= 0 then
    Inc( D.Lck )
  else
    Dec( D.Lck );
end;}

procedure THeapOnFile.Release(N: Integer);
var P: Pointer;
begin
  P := Pointer( N );
  FreeMem( P );
end;
{
var P: PData;
    I, J: Integer;
begin
  if FLoadsMap.Bits[ N ] then
  begin
    P := nil;
    J := -1;
    for I := 0 to fLoaded.Count-1 do
    begin
      P := fLoaded.Items[ I ];
      J := I;
      if P.Idx = N then
        break;
    end;
    Assert( P <> nil, 'HeapOnFile: Release error - can not find loaded record.' );
    if (P.Lck <= 1) and (P.Lck >= -1) then
    begin
      //* Can be released immediately
      if P.Lck = 0 then
        fUnloadQueue.Remove( P );
      fLoaded.Delete( J );
      FreeMem( P );
      FAllocMap.Bits[ N ] := FALSE;
      FLoadsMap.Bits[ N ] := FALSE;
    end
      else
    begin
      if P.Lck > 1 then
        P.Lck := -P.Lck;
      Unlock( P );
    end;
  end;
end;
}

procedure THeapOnFile.SetMaxUnloadQueueSize(const Value: Integer);
begin
  {if Value >= 0 then
    FMaxUnloadQueueSize := Value;
  UnloadFirst;}
end;

{procedure THeapOnFile.UnloadFirst;
var P: PData;
    Mem: Pointer;
begin
  while fUnloadQueue.Count > FMaxUnloadQueueSize do
  begin
    P := fUnloadQueue.Items[ 0 ];
    fUnloadQueue.Delete( 0 );

    FFile.Position := P.Idx * FRecordSize;
    Mem := Pointer( Integer( P ) + Sizeof( P^ ) );
    FFile.Write( Mem^, FRecordSize );
    FreeMem( P );
  end;
end;}

function THeapOnFile.UnLock(P: Pointer): Integer;
begin
  Result := Integer( P );
end;
{var D: PData;
begin
  D := Pointer( Integer( P ) - Sizeof( TData ) );
  if D.Lck > 0 then
    Dec( D.Lck )
  else
  begin
    Inc( D.Lck );
    if D.Lck = 0 then
    begin
      //* This record was released, but could not released actually
      // because of locking it several times. And now it can be released
      // finally.
    end;
    FAllocMap.Bits[ D.Idx ] := FALSE;
    FLoadsMap.Bits[ D.Idx ] := FALSE;
    FreeMem( D );
    Result := -1;
    Exit;
  end;
  Result := D.Idx;
  if D.Lck = 0 then
  begin
    fUnloadQueue.Add( D );
    UnloadFirst;
  end;
end;}

end.
