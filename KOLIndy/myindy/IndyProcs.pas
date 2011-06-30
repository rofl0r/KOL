unit IndyProcs;

interface

uses windows,kol;

const
  SecsPerDay = 24 * 60 * 60;
  MSecsPerDay = SecsPerDay * 1000;

  FMSecsPerDay: Single = MSecsPerDay;
  IMSecsPerDay: Integer = MSecsPerDay;
  DateDelta = 693594;

type
 TFileName=String;
 TSysCharSet = set of Char;

 TTimeStamp = record
    Time: Integer;      { Number of milliseconds since midnight }
    Date: Integer;      { One plus number of days since 1/1/0001 }
  end;

 function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;
 procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);
 function MyWinVer : TWindowsVersions;
 function StrToIntDef(const S: string; const Default: Integer): Integer;
 function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
 function IsPathDelimiter(const S: string; Index: Integer): Boolean;
 function StrNew(const Str: PChar): PChar;
 function StrAlloc(Size: Cardinal): PChar;
 procedure StrDispose(Str: PChar);


implementation


procedure StrDispose(Str: PChar);
begin
  if Str <> nil then
  begin
    Dec(Str, SizeOf(Cardinal));
    FreeMem(Str, Cardinal(Pointer(Str)^));
  end;
end;

function StrAlloc(Size: Cardinal): PChar;
begin
  Inc(Size, SizeOf(Cardinal));
  GetMem(Result, Size);
  Cardinal(Pointer(Result)^) := Size;
  Inc(Result, SizeOf(Cardinal));
end;

function StrNew(const Str: PChar): PChar;
var
  Size: Cardinal;
  Dest:Pchar;
begin
  if Str = nil then Result := nil else
  begin
    Size := StrLen(Str) + 1;
    Dest:=StrAlloc(Size);
    //Result := StrMove(StrAlloc(Size), Str, Size);
    Move(Str^, Dest^, Size);
  end;
end;

function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;
asm
        MOV     ECX,EAX
        FLD     DateTime
        FMUL    FMSecsPerDay
        SUB     ESP,8
        FISTP   QWORD PTR [ESP]
        FWAIT
        POP     EAX
        POP     EDX
        OR      EDX,EDX
        JNS     @@1
        NEG     EDX
        NEG     EAX
        SBB     EDX,0
        DIV     IMSecsPerDay
        NEG     EAX
        JMP     @@2
@@1:    DIV     IMSecsPerDay
@@2:    ADD     EAX,DateDelta
        MOV     [ECX].TTimeStamp.Time,EDX
        MOV     [ECX].TTimeStamp.Date,EAX
end;

procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);
var
  MinCount, MSecCount: Word;
begin
  DivMod(DateTimeToTimeStamp(Time).Time, 60000, MinCount, MSecCount);
  DivMod(MinCount, 60, Hour, Min);
  DivMod(MSecCount, 1000, Sec, MSec);
end;


function StrToIntDef(const S: string; const Default: Integer): Integer;
Begin
 try
  result:=str2int(s);
 except
  Result:=Default;
 end;
end;
function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
begin
  Result := 0;
  if (Hour < 24) and (Min < 60) and (Sec < 60) and (MSec < 1000) then
  begin
    Result := (Hour * 3600000 + Min * 60000 + Sec * 1000 + MSec) / MSecsPerDay;
  end;
end;
function IsPathDelimiter(const S: string; Index: Integer): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = '\');
end;

end.
