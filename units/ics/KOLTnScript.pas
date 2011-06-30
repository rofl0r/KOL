unit TnScript;

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$H+}       { Use long strings                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125} { C++ Builder V4.0                    }
    {$ObjExportAll On}
{$ENDIF}

interface

{.DEFINE DUMP}

uses KOL, 
    Wintypes, WinProcs { , Classes } , SysUtils, TnEmulVT;

const
    TnScriptVersion    = 1.03;
    CopyRight : String = ' TTnScript (c) 1998-2002 F. Piette V1.03 ';

type
    TnScriptException = object(Exception);
PnScriptException=^TnScriptException; type  MyStupid0=DWord; 
    TEventHandler = procedure (Sender : TObject; ID : Integer) of object;
    TEventFlag    = (efIgnoreCase,         { Ignore case in comparaisons   }
                     efPersistent);        {Do not delete event when found }
    TEventFlags   = set of TEventFlag;
    TDisplayEvent = procedure (Sender : TObject; Msg : String) of object;
    TStringMatch  = procedure (Sender : TObject; ID : Integer) of object;

    TEventDescriptor = record
        ID      : Integer;
        Search  : String;
        ToSend  : String;
        Flags   : TEventFlags;
        Handler : TEventHandler;
    end;
    PEventDescriptor = ^TEventDescriptor;

    TTnScript = object(TTnEmulVT)
    protected
        FEventList        : TList;
        FInputBuffer      : PChar;
        FInputBufferSize  : Integer;
        FInputBufferCount : Integer;
        FInputBufferStart : Integer;
        FOnDisplay        : TDisplayEvent;
        FOnStringMatch    : TStringMatch;
        function  SearchEvent(ID : Integer) : Integer; virtual;
        procedure TriggerDataAvailable(Buffer : Pointer; Len: Integer); override;
        function  FindEventString(S : String; Flags : TEventFlags) : Integer; virtual;
        procedure ScanEvents; virtual;
        procedure ProcessInputData(Buffer: PChar; Len: Integer); virtual;
        procedure TriggerDisplay(Msg : String); virtual;
        procedure TriggerStringMatch(ID : Integer); virtual;
        procedure NextOne(var N : Integer); virtual;
        procedure SetInputBufferSize(newSize : Integer); virtual;
    public
         { constructor Create(AOwner : TComponent); override;
         } destructor  Destroy; 
         virtual; procedure AddEvent(ID      : Integer;
                           Search  : String;
                           ToSend  : String;
                           Flags   : TEventFlags;
                           Handler : TEventHandler); virtual;
        procedure RemoveEvent(ID : Integer); virtual;
        procedure RemoveAllEvents; virtual;
     { published } 
        property InputBufferSize : Integer         read  FInputBufferSize
                                                   write SetInputBufferSize;
        property OnDisplay : TDisplayEvent         read  FOnDisplay
                                                   write FOnDisplay;
        property OnStringMatch : TStringMatch      read  FOnStringMatch
                                                   write FOnStringMatch;

    end;
PTnScript=^TTnScript;
function NewTnScript(AOwner : TComponent):PTnScript; type  MyStupid3137=DWord; 

procedure Register;

implementation

{$IFDEF DUMP}
const
    CtrlCode : array [0..31] of String = ('NUL', 'SOH', 'STX', 'ETX',
                                          'EOT', 'ENQ', 'ACK', 'BEL',
                                          'BS',  'HT',  'LF',  'VT',
                                          'FF',  'CR',  'SO',  'SI',
                                          'DLE', 'DC1', 'DC2', 'DC3',
                                          'DC4', 'NAK', 'SYN', 'ETB',
                                          'CAN', 'EM',  'SUB', 'ESC',
                                          'FS',  'GS',  'RS',  'US');
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('FPiette', [TTnScript]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TTnScript.Create(AOwner : TComponent);
begin
    inherited Create(AOwner);
    FEventList := TList.Create;
    SetInputBufferSize(80);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TTnScript.Destroy;
begin
    if Assigned(FEventList) then begin
        FEventList.Free;
        FEventList := nil;
    end;
    if FInputBuffer <> nil then begin
        FreeMem(FInputBuffer, FInputBufferSize);
        FInputBuffer := nil;
    end;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Set the input buffer size. This will clear any data already in the buffer }
procedure TTnScript.SetInputBufferSize(newSize : Integer);
begin
    { Round the size to the nearest upper 16 bytes limit }
    newSize := ((newSize shr 4) + 1) shl 4;

    { If no change, do nothing }
    if FInputBufferSize = newSize then
        Exit;

    { If buffer already allocated, free it }
    if FInputBuffer <> nil then begin
        FreeMem(FInputBuffer, FInputBufferSize);
        FInputBuffer := nil;
    end;

    { Allocate a new buffer of the given size }
    FInputBufferSize := newSize;
    GetMem(FInputBuffer, FInputBufferSize);

    { Clear the markers }
    FInputBufferStart := 0;
    FInputBufferCount := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TTnScript.TriggerDisplay(Msg : String);
begin
    if Assigned(FOnDisplay) then
        FOnDisplay(Self, Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TTnScript.TriggerStringMatch(ID : Integer);
begin
    if Assigned(FOnStringMatch) then
        FOnStringMatch(Self, ID);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TTnScript.SearchEvent(ID : Integer) : Integer;
begin
    if Assigned(FEventList) then begin
        for Result := 0 to FEventList.Count - 1 do begin
            if PEventDescriptor(FEventList.Items[Result])^.ID = ID then
                Exit;
        end;
    end;
    Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Add an event (a string to search for) to the list                         }
procedure TTnScript.AddEvent(
    ID      : Integer;
    Search  : String;
    ToSend  : String;
    Flags   : TEventFlags;
    Handler : TEventHandler);
var
    NewEvent : PEventDescriptor;
begin
    if not Assigned(FEventList) then
        raise TnScriptException.Create('AddEvent: No Event List');

    if SearchEvent(ID) <> -1 then
        raise TnScriptException.Create('AddEvent: ID ' + IntToStr(ID) +
                                       ' already exist');
    if Length(Search) <= 0 then
        raise TnScriptException.Create('AddEvent: String to search empty');

    New(NewEvent);
    FEventList.Add(NewEvent);
    NewEvent^.ID      := ID;
    NewEvent^.ToSend  := ToSend;
    NewEvent^.Flags   := Flags;
    NewEvent^.Handler := Handler;
    if efIgnoreCase in Flags then
        NewEvent^.Search  := UpperCase(Search)
    else
        NewEvent^.Search  := Search;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Remove an event from the list, given his ID                               }
procedure TTnScript.RemoveEvent(ID : Integer);
var
    Item   : Integer;
    PEvent : PEventDescriptor;
begin
    if not Assigned(FEventList) then
        raise TnScriptException.Create('AddEvent: No Event List');

    Item := SearchEvent(ID);
    if Item < 0 then
        raise TnScriptException.Create('RemoveEvent: ID ' + IntToStr(ID) +
                                       ' does''nt exist');
    PEvent := FEventList.Items[Item];

    { Replace the ID to check later that we do not reuse the freed event }
    PEvent^.ID := -1;

    { Free the memory and remove the pointer from list }
    Dispose(PEvent);
    FEventList.Delete(Item);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TTnScript.RemoveAllEvents;
var
    PEvent : PEventDescriptor;
begin
    if not Assigned(FEventList) then
        raise TnScriptException.Create('AddEvent: No Event List');

    while FEventList.Count > 0 do begin
        PEvent := FEventList.Items[0];
        PEvent^.ID := -1;
        Dispose(PEvent);
        FEventList.Delete(0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF DUMP}
procedure WriteCh(Ch : Char);
begin
    if ord(Ch) < 32 then
        write('<', CtrlCode[Ord(Ch)], '>')
    else
        write(Ch);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure WriteBuf(Buffer : PChar; Len : Integer);
var
    I : Integer;
begin
    for I := 0 to Len - 1 do
        WriteCh(Buffer[I]);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Advance char index in the circular buffer                                 }
procedure TTnScript.NextOne(var N : Integer);
begin
    Inc(N);
    if N >= FInputBufferSize then
        N := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Search for a string in the circular buffer.                               }
{ Returns the number of chars between the buffer start and the end of the   }
{ event found, or -1 if not found.                                          }
function TTnScript.FindEventString(S : String; Flags : TEventFlags) : Integer;
var
    N, M, I, J, K : Integer;
    Ch            : Char;
begin
    Result := -1;
    I      := FInputBufferStart;
    N      := 0;
    while N < FInputBufferCount do begin
        if efIgnoreCase in Flags then
            Ch := UpperCase(FInputBuffer[I])[1]
        else
            Ch := FInputBuffer[I];

        if Ch = S[1] then begin
            { Same first letter, check up to end of S }
            J := I;
            K := 2;
            M := N;
            while TRUE do begin
                NextOne(J);

                Inc(M);
                if M >= FInputBufferCount then
                    break;

                if K >= Length(S) then begin
                    { Found ! }
                    Result := M + 1;
                    Exit;
                end;
                if efIgnoreCase in Flags then
                    Ch := UpperCase(FInputBuffer[J])[1]
                else
                    Ch := FInputBuffer[J];
                if Ch <> S[K] then
                    break;     { Compare failed }
                Inc(K);
            end;
        end;

        NextOne(I);
        Inc(N);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TTnScript.ScanEvents;
var
    Item    : Integer;
    PEvent  : PEventDescriptor;
    I       : Integer;
    ID      : Integer;
    Handler : TEventHandler;
begin
{$IFDEF DUMP}
    Write('ScanEvents Start=', FInputBufferStart,
                    ' Count=', FInputBufferCount,
                     ' ''');
    I := FInputBufferStart;
    for J := 1 to FInputBufferCount do begin
        WriteCh(FInputBuffer[I]);
        NextOne(I);
    end;
    WriteLn('''');
{$ENDIF}

    for Item := 0 to FEventList.Count - 1 do begin
        PEvent := PEventDescriptor(FEventList.Items[Item]);
        I := FindEventString(PEvent^.Search, PEvent^.Flags);
        if I <> -1 then begin
{$IFDEF DUMP}
            WriteLn('Found event ''', PEvent^.Search, '''');
{$ENDIF}
            TriggerDisplay('Event ''' + PEvent^.Search + '''');
            FInputBufferCount := FInputBufferCount - I;
            FInputBufferStart := FInputBufferStart + I;
            if FInputBufferStart >= FInputBufferSize then
                FInputBufferStart := FInputBufferStart - FInputBufferSize;
            ID      := PEvent^.ID;
            Handler := PEvent^.Handler;
            if Length(PEvent^.ToSend) > 0 then
                SendStr(PEvent^.ToSend);
            { Call the global event handler OnStringMatch }
            TriggerStringMatch(ID);
            { Call the specific event handler }
            if Assigned(Handler) then
                Handler(Self, ID);
            { It's possible that the event has been removed !  }
            { Make sure it is always there before using it     }
            try
                if PEvent^.ID = ID then begin
                    if not (efPersistent in PEvent^.FLags) then
                        RemoveEvent(ID);
                end;
            except
                { Ignore any exception }
            end;
            Exit;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TTnScript.ProcessInputData(Buffer: PChar; Len: Integer);
const
    Recurse : Integer = 0;
var
    I, J : Integer;
begin
    if not Assigned(FInputBuffer) then
        Exit;

    Inc(Recurse); { For debugging purpose }

    if Len > (FInputBufferSize div 2) then begin
        { Input buffer too small, process recursively two halfs }
        ProcessInputData(Buffer, Len div 2);
        ProcessInputData(Buffer + (Len div 2), Len - (Len div 2));
        Dec(Recurse);
        Exit;
    end;

{$IFDEF DUMP}
    WriteLn;
    Write(Calls, ' ', Recurse, ' ', FInputBufferStart, ' ',
          FInputBufferCount, ') Len=', Len, ' Buffer=''');
    WriteBuf(Buffer, Len);
    WriteLn('''');
{$ENDIF}

    { Where is the end of the circular buffer, that's the question ! }
    I := FInputBufferStart + FInputBufferCount;
    if I >= FInputBufferSize then
         I := I - FInputBufferSize;

    { Add data to the end of the circular buffer, overwriting any previously }
    { stored data (remember, we don't ever receive more than 1/2 buffer size }
    J := 0;
    while J < Len do begin
        FInputBuffer[I] := Buffer[J];
        Inc(J);
        NextOne(I);
        if FInputBufferCount = FInputBufferSize then
            NextOne(FInputBufferStart)
        else
            Inc(FInputBufferCount);
    end;
    { Scan for events }
    ScanEvents;

    Dec(Recurse); { For debugging purpose }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TTnScript.TriggerDataAvailable(Buffer : Pointer; Len: Integer);
begin
    if FEventList.Count > 0 then
        ProcessInputData(PChar(Buffer), Len);

    inherited TriggerDataAvailable(Buffer, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

