unit KOLWSockBuf;

interface

uses KOL;//,
//  SysUtils;

const
  WSockBufVersion = 201;

type
  TBuffer = object(TObj)
    Buf      : Pointer;
    FBufSize : Integer;
    WrCount  : Integer;
    RdCount  : Integer;
  public
     { constructor Create(nSize : Integer); virtual;
     } destructor  Destroy; 
     virtual; function    Write(Data : Pointer; Len : Integer) : Integer;
    function    Read(Data : Pointer; Len : Integer) : Integer;
    function    Peek(var Len : Integer) : Pointer;
    function    Remove(Len : Integer) : Integer;
    procedure   SetBufSize(newSize : Integer);
    property    BufSize : Integer read FBufSize write SetBufSize;
  end;
PBuffer=^TBuffer;
function NewBuffer(nSize : Integer):PBuffer;
//type  MyStupid0=DWord;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//constructor TBuffer.Create(nSize : Integer);
function NewBuffer(nSize : Integer):PBuffer;
begin
New( Result, Create );
with Result^ do
begin
//    inherited Create;
    WrCount  := 0;
    RdCount  := 0;
    BufSize := nSize;
end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TBuffer.Destroy;
begin
    if Assigned(Buf) then
        FreeMem(Buf, FBufSize);

    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TBuffer.SetBufSize(newSize : Integer);
var
    newBuf : Pointer;
begin
    if newSize <= 0 then
        newSize := 1514;

    if newSize = FBufSize then
        Exit;

    if WrCount = RdCount then begin
        { Buffer is empty }
        if Assigned(Buf) then
            FreeMem(Buf, FBufSize);
        FBufSize := newSize;
        GetMem(Buf, FBufSize);
    end
    else begin
        { Buffer contains data }
        GetMem(newBuf, newSize);
        Move(Buf^, newBuf^, WrCount);
        if Assigned(Buf) then
            FreeMem(Buf, FBufSize);
        FBufSize := newSize;
        Buf      := newBuf;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Write(Data : Pointer; Len : Integer) : Integer;
var
    Remaining : Integer;
    Copied    : Integer;
begin
    Remaining := FBufSize - WrCount;
    if Remaining <= 0 then
        Result := 0
    else begin
        if Len <= Remaining then
            Copied := Len
        else
            Copied := Remaining;
        Move(Data^, (PChar(Buf) + WrCount)^, Copied);
        WrCount := WrCount + Copied;
        Result  := Copied;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Read(Data : Pointer; Len : Integer) : Integer;
var
    Remaining : Integer;
    Copied    : Integer;
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then
        Result := 0
    else begin
        if Len <= Remaining then
            Copied := Len
        else
            Copied := Remaining;
        Move((PChar(Buf) + RdCount)^, Data^, Copied);
        RdCount := RdCount + Copied;

        if RdCount = WrCount then begin
            RdCount := 0;
            WrCount := 0;
        end;

        Result := Copied;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Peek(var Len : Integer) : Pointer;
var
    Remaining : Integer;
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then begin
        Len    := 0;
        Result := nil;
    end
    else begin
        Len    := Remaining;
        Result := Pointer(PChar(Buf) + RdCount);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TBuffer.Remove(Len : Integer) : Integer;
var
    Remaining : Integer;
    Removed   : Integer;
begin
    Remaining := WrCount - RdCount;
    if Remaining <= 0 then
        Result := 0
    else begin
        if Len < Remaining then
            Removed := Len
        else
            Removed := Remaining;
        RdCount := RdCount + Removed;

        if RdCount = WrCount then begin
            RdCount := 0;
            WrCount := 0;
        end;

        Result := Removed;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

