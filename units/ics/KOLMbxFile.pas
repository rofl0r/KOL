unit MbxFile;

interface

uses KOL, 
    SysUtils, WinTypes, WinProcs, Messages { , Classes } , Graphics, Controls,
    Forms, Dialogs, ExtCtrls;

const
    MbxFileVersion = 100;
    MSG_SIGNATURE  = $7F007F00;

type
    TMbxHeader = packed record
        Signature  : array [0..3] of char;
        Reserved1  : Word;
        Reserved2  : Word;
        MsgCount   : LongInt;
        Reserved3  : LongInt;    { A MsgCount copy ? }
        EndPointer : LongInt;
        Reserved4  : array [0..15] of LongInt;
    end;

    TMsgHeader = packed record
        Signature  : LongInt;    { $7F007F00 }
        MsgNum     : LongInt;
        MsgSize    : LongInt;
        Reserved1  : LongInt;
    end;

    TCustomMbxHandler = object(TObj)
    protected
        FFileHdr       : TMbxHeader;
        FFileName      : String;
        FFileStream    : TFileStream;
        FMsgHeader     : TMsgHeader;
        FMsgStream     : TMemoryStream;
        FMsgStreamSize : Integer;
        FCurPos        : LongInt;
        procedure InternalPrior;
        procedure ReadNextMessage;
        procedure SetActive(newValue : Boolean);
        function  GetActive   : Boolean;
        function  GetMsgCount : Integer;
        function  GetMsgNum   : Integer;
        function  GetEof      : Boolean;
        function  GetBof      : Boolean;
    public
         { constructor Create(AOwner: TComponent); override;
         } destructor  Destroy; 
         virtual; procedure   Open;
        procedure   Close;
        procedure   First;
        procedure   Next;
        procedure   Prior;
        procedure   Last;
        property FileName  : String        read FFileName write FFileName;
        property Active    : Boolean       read GetActive write SetActive;
        property MsgCount  : Integer       read GetMsgCount;
        property MsgNum    : Integer       read GetMsgNum;
        property MsgStream : TMemoryStream read FMsgStream;
        property Eof       : Boolean       read GetEof;
        property Bof       : Boolean       read GetBof;
    end;
PCustomMbxHandler=^TCustomMbxHandler;
function NewCustomMbxHandler(AOwner: TComponent):PCustomMbxHandler; type  MyStupid0=DWord; 

    TMbxHandler = object(TCustomMbxHandler)
     { published } 
        property FileName  : String        read FFileName write FFileName;
        property Active    : Boolean       read GetActive write SetActive;
    end;
PustomMbxHandler=^CustomMbxHandler; type  MyStupid3137=DWord; 

procedure Register;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('FPiette', [TMbxHandler]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TCustomMbxHandler.Create(AOwner : TComponent);
begin
    Inherited Create(AOwner);
    FMsgStreamSize := 4096;
    FMsgStream := TMemoryStream.Create;
    FMsgStream.SetSize(FMsgStreamSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TCustomMbxHandler.Destroy;
begin
    Close;
    FMsgStream.Free;
    FMsgStreamSize := 0;
    Inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.Open;
begin
    Close;
    FFileStream := TFileStream.Create(FFileName, fmOpenRead + fmShareDenyNone);
    FFileStream.Read(FFileHdr, SizeOf(FFileHdr));
    if FFileHdr.Signature <> 'JMF6' then begin
        Close;
        raise Exception.Create('Not an EMail file');
    end;

    if MsgCount <= 0 then
        Exit;
    ReadNextMessage;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.Close;
begin
    if Assigned(FFileStream) then begin
        FFileStream.Free;
        FFileStream := nil;
    end;;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.First;
begin
    if not Assigned(FFileStream) then
        raise Exception.Create('Message file not opened');
    if MsgCount <= 0 then
        Exit;
    FFileStream.Position := SizeOf(TMbxHeader);
    ReadNextMessage;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.Last;
begin
    if not Assigned(FFileStream) then
        raise Exception.Create('Message file not opened');
    if MsgCount <= 0 then
        Exit;
    FCurPos := FFileStream.Seek(0, soFromEnd);
    InternalPrior;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.Next;
begin
    if not Assigned(FFileStream) then
        raise Exception.Create('Message file not opened');

    if Eof then
        raise Exception.Create('No more message');

    ReadNextMessage;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.Prior;
begin
    if not Assigned(FFileStream) then
        raise Exception.Create('Message file not opened');

    if Bof then
        raise Exception.Create('No more message');
    InternalPrior;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.ReadNextMessage;
begin
    FCurPos := FFileStream.Position;
    FFileStream.Read(FMsgHeader, SizeOf(FMsgHeader));
    if FMsgHeader.Signature <> MSG_SIGNATURE then begin
        Close;
        raise Exception.Create('Invalid signature in message header');
    end;
    if FMsgStreamSize <= FMsgHeader.MsgSize then begin
        FMsgStreamSize := (((FMsgHeader.MsgSize + 1) div 4096) + 1) * 4096;
        FMsgStream.SetSize(FMsgStreamSize);
    end;
    FMsgStream.Seek(0, soFromBeginning);
    FFileStream.Read(FMsgStream.Memory^, FMsgHeader.MsgSize - 16);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.SetActive(newValue : Boolean);
begin
   if newValue = Assigned(FFileStream) then
       Exit;
   if newValue then
       Open
   else
       Close;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomMbxHandler.GetActive : Boolean;
begin
    Result := Assigned(FFileStream);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomMbxHandler.GetMsgCount : Integer;
begin
    if not Assigned(FFileStream) then
        raise Exception.Create('Message file not opened');
    Result := FFileHdr.MsgCount;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomMbxHandler.GetMsgNum : Integer;
begin
    if not Assigned(FFileStream) then
        raise Exception.Create('Message file not opened');
    Result := FMsgHeader.MsgNum;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomMbxHandler.GetEof : Boolean;
begin
    Result := (not Assigned(FFileStream)) or
              (MsgCount <= 0) or (MsgNum >= MsgCount);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomMbxHandler.GetBof : Boolean;
begin
    Result := (not Assigned(FFileStream)) or
              (MsgCount <= 0) or (MsgNum <= 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomMbxHandler.InternalPrior;
var
    NewPos : LongInt;
    Buf    : PChar;
    p      : PChar;
    More   : Boolean;
    Sign   : LongInt;
    Cnt    : Integer;
begin
    Buf := FMsgStream.Memory;

    Cnt    := 4096;
    NewPos := FCurPos - Cnt;
    More   := TRUE;
    while More do begin
        if NewPos < SizeOf(TMbxHeader) then begin
            Cnt    := Cnt - SizeOf(TMbxHeader) + NewPos;
            NewPos := SizeOf(TMbxHeader);
        end;
        FFileStream.Position := NewPos;
        FFileStream.Read(Buf^, Cnt);
        p := Buf + Cnt - 1;
        while (p > Buf) do begin
            while (p >= Buf) and (p^ <> #$7F) do
                Dec(p);
            if p^ = #$7F then begin
                FFileStream.Position := NewPos + p - Buf - 3;
                FFileStream.Read(Sign, SizeOf(Sign));
                if Sign = MSG_SIGNATURE then begin
                    NewPos := NewPos + p - Buf - 3;
                    More   := FALSE;
                    Break;
                end;
            end;
            Dec(p);
        end;

        if not More then
            Break;

        if NewPos <= SizeOf(TMbxHeader) then
            break;

        Cnt    := 4096;
        NewPos := NewPos - Cnt;
    end;
    FFileStream.Position := NewPos;
    ReadNextMessage;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

