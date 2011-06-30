unit FtpSrvC;

interface

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

uses KOL, 
    WinTypes, WinProcs, Messages { , Classes } , SysUtils, Winsock, WSocket;

const
    FtpCtrlSocketVersion = 109;
    CopyRight : String   = ' TFtpCtrlSocket  (c) 1998-2001 F. Piette V1.09 ';
    DefaultRcvSize       = 2048;

type
    EFtpCtrlSocketException = object(Exception);
PFtpCtrlSocketException=^EFtpCtrlSocketException; type  MyStupid0=DWord; 
    TFtpCtrlState = (ftpcInvalid, ftpcWaitingUserCode, ftpcWaitingPassword,
                     ftpcReady, ftpcWaitingAnswer);

    { TFtpCmdType is now defined as a byte and enumerated items as constants, }
    { so that new values can be added by sub-components who add new commands  }
    TFtpCmdType   = Byte;

const
    ftpcPORT      = 0;
    ftpcSTOR      = 1;
    ftpcRETR      = 2;
    ftpcCWD       = 3;
    ftpcXPWD      = 4;
    ftpcPWD       = 5;
    ftpcUSER      = 6;
    ftpcPASS      = 7;
    ftpcLIST      = 8;
    ftpcRMD       = 9;
    ftpcTYPE      = 10;
    ftpcSYST      = 11;
    ftpcQUIT      = 12;
    ftpcDELE      = 13;
    ftpcRNFR      = 14;
    ftpcMKD       = 15;
    ftpcRNTO      = 16;
    ftpcNOOP      = 17;
    ftpcNLST      = 18;
    ftpcABOR      = 19;
    ftpcCDUP      = 20;
    ftpcSIZE      = 21;
    ftpcREST      = 22;
    ftpcAPPE      = 23;
    ftpcSTRU      = 24;   {jsp - Added APPE and STRU types }
    ftpcMDTM      = 25;   {bkc - Added MDTM type           }
    ftpcSTOU      = 26;   {ep  - Added STOU type           }
    ftpcFEAT      = 27;   {SSV - Added FEAT type           }

type
    TFtpOption    = (ftpcUNC);
    TFtpOptions   = set of TFtpOption;
    TDisplayEvent = procedure (Sender : TObject; Msg : String) of object;
    TCommandEvent = procedure (Sender : TObject; CmdBuf : PChar; CmdLen : Integer) of object;

    TFtpCtrlSocket = object(TCustomWSocket)
    protected
        FDataSocket        : TWSocket;
        FRcvBuf            : PChar;
        FRcvCnt            : Integer;
        FRcvSize           : Integer;
        FBusy              : Boolean;
        FConnectedSince    : TDateTime;
        FLastCommand       : TDateTime;
        FCommandCount      : LongInt;
        FBanner            : String;
        FUserName          : String;
        FPassWord          : String;
        FCloseRequest      : Boolean;
        FHomeDir           : String;
        FDirectory         : String;
        FFtpState          : TFtpCtrlState;
        FAbortingTransfer  : Boolean;
        FUserData          : LongInt;        { Reserved for component user }
        FPeerAddr          : String;
        FID                : LongInt;
        FOnDisplay         : TDisplayEvent;
        FOnCommand         : TCommandEvent;
        procedure TriggerSessionConnected(Error : Word); override;
        function  TriggerDataAvailable(Error : Word) : boolean; override;
        procedure TriggerCommand(CmdBuf : PChar; CmdLen : Integer); virtual;
        procedure SetRcvSize(newValue : Integer);
    public
        BinaryMode        : Boolean;
        DataAddr          : String;
        DataPort          : String;
        FileName          : String;
        FilePath          : String;
        DataSessionActive : Boolean;
        DataStream        : TStream;
        HasOpenedFile     : Boolean;
        TransferError     : String;
        ByteCount         : LongInt;
        DataSent          : Boolean;
        CurCmdType        : TFtpCmdType;
        RestartPos        : LongInt;
        FromFileName      : String;
        ToFileName        : String;
        PassiveMode       : Boolean;
        PassiveStart      : Boolean;
        PassiveConnected  : Boolean;
        Options           : TFtpOptions;
         { constructor Create(AOwner: TComponent); override;
         } destructor  Destroy; 
         virtual; procedure   Dup(newHSocket : TSocket); override;
        procedure   StartConnection; virtual;
        procedure   SendAnswer(Answer : String);
        procedure   SetDirectory(newValue : String);
        procedure   SetAbortingTransfer(newValue : Boolean);
        function    GetPeerAddr: string; override;
        property    DataSocket     : TWSocket    read FDataSocket;
        property    ConnectedSince : TDateTime   read FConnectedSince;
        property    LastCommand    : TDateTime   read FLastCommand;
        property    CommandCount   : LongInt     read FCommandCount;
        property    RcvBuf         : PChar       read FRcvBuf;
        property    RcvdCount;
        property    CloseRequest   : Boolean     read  FCloseRequest
                                                 write FCloseRequest;
        property Directory : String              read  FDirectory
                                                 write SetDirectory;
        property HomeDir : String                read  FHomeDir
                                                 write FHomeDir;
        property AbortingTransfer : Boolean      read  FAbortingTransfer
                                                 write SetAbortingTransfer;
        property ID               : LongInt      read  FID
                                                 write FID;
     { published } 
        property FtpState : TFtpCtrlState  read  FFtpState
                                           write FFtpState;
        property Banner : String           read  FBanner
                                           write FBanner;
        property RcvSize : integer         read  FRcvSize
                                           write SetRcvSize;
        property Busy : Boolean            read  FBusy
                                           write FBusy;
        property UserName : String         read  FUserName
                                           write FUserName;
        property PassWord : String         read  FPassWord
                                           write FPassWord;
        property UserData  : LongInt       read  FUserData
                                           write FUserData;
        property OnDisplay : TDisplayEvent read  FOnDisplay
                                           write FOnDisplay;
        property OnCommand : TCommandEvent read  FOnCommand
                                           write FOnCommand;
        property OnSessionClosed;
        property OnDataSent;
        property HSocket;
        property AllSent;
        property State;
{$IFDEF VER80}
        property TrumpetCompability;
{$ENDIF}
    end;
PFtpCtrlSocket=^TFtpCtrlSocket;
function NewFtpCtrlSocket(AOwner: TComponent):PFtpCtrlSocket; type  MyStupid3137=DWord; 

function  IsUNC(S : String) : Boolean;
procedure PatchIE5(var S : String);
{$IFDEF VER80}
function ExtractFileDir(const FileName: String): String;
function ExtractFileDrive(const FileName: String): String;
{$ENDIF}

implementation

const
    DefaultBanner = '220-ICS FTP Server ready';


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
procedure SetLength(var S: string; NewLength: Integer);
begin
    S[0] := chr(NewLength);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ ExtractFileDir extracts the drive and directory parts of the given        }
{ filename. The resulting string is a directory name suitable for passing   }
{ to SetCurrentDir, CreateDir, etc. The resulting string is empty if        }
{ FileName contains no drive and directory parts.                           }
function ExtractFileDir(const FileName: String): String;
var
    I: Integer;
begin
    I := Length(FileName);
    while (I > 0) and (not (FileName[I] in ['\', ':'])) do
        Dec(I);
    if (I > 1) and (FileName[I] = '\') and
       (not (FileName[I - 1] in ['\', ':'])) then
        Dec(I);
    Result := Copy(FileName, 1, I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ ExtractFileDrive extracts the drive part of the given filename.  For        }
{ filenames with drive letters, the resulting string is '<drive>:'.           }
{ For filenames with a UNC path, the resulting string is in the form          }
{ '\\<servername>\<sharename>'.  If the given path contains neither           }
{ style of filename, the result is an empty string.                           }
function ExtractFileDrive(const FileName: String): String;
var
    I : Integer;
begin
    if Length(FileName) <= 1 then
        Result := ''
    else begin
        if FileName[2] = ':' then
            Result := Copy(FileName, 1, 2)
        else if (FileName[2] = '\') and (FileName[1] = '\') then begin
            { UNC file name }
            I := 3;
            while (I <= Length(FileName)) and (FileName[I] <> '\') do
                Inc(I);
            Inc(I);
            while (I <= Length(FileName)) and (FileName[I] <> '\') do
                Inc(I);
            Result := Copy(FileName, 1, I - 1);
        end
        else
            Result := '';
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TFtpCtrlSocket.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FDataSocket      := TWSocket.Create(Self);
    FDataSocket.Name := 'DataWSocket';
    FBanner          := DefaultBanner;
    FFtpState        := ftpcInvalid;
    FHomeDir         := 'C:\TEMP\';
    FDirectory       := FHomeDir;
    SetRcvSize(DefaultRcvSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TFtpCtrlSocket.Destroy;
begin
    FRcvCnt := 0;      { Clear received data }
    SetRcvSize(0);     { Free the buffer     }
    if Assigned(FDataSocket) then begin
        FDataSocket.Destroy;
        FDataSocket := nil;
    end;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.SetRcvSize(newValue : Integer);
begin
    if FRcvCnt <> 0 then
        raise EFtpCtrlSocketException.Create('Data in buffer, can''t change size');

    if FRcvSize < 0 then
        FRcvSize := 0;

    if FRcvSize = newValue then
        Exit; { No change, nothing to do }

    { Free previously allocated buffer }
    if FRcvBuf <> nil then begin
        FreeMem(FRcvBuf, FRcvSize);
        FRcvBuf := nil;
    end;

    { Allocate new buffer }
    FRcvSize := newValue;

    { If size is nul, then do not allocated the buffer }
    if newValue > 0 then
        GetMem(FRcvBuf, FRcvSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.StartConnection;
begin
    FConnectedSince := Now;
    FLastCommand    := 0;
    FCommandCount   := 0;
    FFtpState       := ftpcWaitingUserCode;
    SendStr(FBanner + #13#10);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TFtpCtrlSocket.GetPeerAddr: String;
begin
    Result := FPeerAddr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.Dup(newHSocket : TSocket);
begin
    inherited Dup(newHSocket);
    FPeerAddr := inherited GetPeerAddr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.TriggerSessionConnected(Error : Word);
begin
    FPeerAddr := inherited GetPeerAddr;
    inherited TriggerSessionConnected(Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.TriggerCommand(CmdBuf : PChar; CmdLen : Integer);
begin
    if Assigned(FOnCommand) then
        FOnCommand(Self, CmdBuf, CmdLen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TFtpCtrlSocket.TriggerDataAvailable(Error : Word) : Boolean;
var
    Len  : Integer;
    I    : Integer;
begin
    Result := TRUE;                                { We read data }

    Len := Receive(@FRcvBuf[FRcvCnt], FRcvSize - FRcvCnt - 1);
    if Len <= 0 then
        Exit;

    FRcvCnt := FRcvCnt + Len;
    FRcvBuf[FRcvCnt] := #0;

    while TRUE do begin
        I := 0;
        while (I < FRcvCnt) and (FRcvBuf[I] <> #10) do
            Inc(I);
        if I >= FRcvCnt then begin
            { Check line overflow. }
            if FRcvCnt >= (FRcvSize - 1) then begin
                StrPCopy(FRcvBuf, 'OVER' + #13#10);
                FRcvCnt := StrLen(FRcvBuf);
                I       := FRcvCnt - 1;
            end
            else
                Exit;
        end;
        FRcvBuf[I]   := #0;
        FLastCommand := Now;
        Inc(FCommandCount);
        if (I > 1) and (FRcvBuf[I - 1] = #13) then begin
            FRcvBuf[I - 1] := #0;
            TriggerCommand(FRcvBuf, I - 1);
            FRcvBuf[I - 1] := #13;
        end
        else
            TriggerCommand(FRcvBuf, I);

        FRcvBuf[I] := #10;
        if I >= (FRcvCnt - 1) then begin
            FRcvCnt    := 0;
            FRcvBuf[0] := #0;
            break;
        end;
        Move(FRcvBuf[I + 1], FRcvBuf^, FRcvCnt - I);
        FRcvCnt := FRcvCnt - I - 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.SendAnswer(Answer : String);
begin
    SendStr(Answer + #13#10);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUNC(S : String) : Boolean;
begin
    Result := (Length(S) >= 2) and (S[2] = '\') and (S[1] = '\');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure PatchIE5(var S : String);
begin
    { \c:\Temp\ -> c:\Temp\ IE5 like this invalid syntax !}
    if (Length(S) >= 3) and (S[3] = ':') and (S[1] = '\') then
        Delete(S, 1, 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.SetDirectory(newValue : String);
var
    newDrive : String;
    newPath  : String;
    I        : Integer;
begin
    if FDirectory = newValue then
        Exit;

    PatchIE5(newValue);
    newDrive := ExtractFileDrive(newValue);
    if IsUNC(newDrive) then begin
        if not (ftpcUNC in Options) then
            raise Exception.Create('Cannot accept UNC path');
        FDirectory := newValue;
        { Always terminate with a backslash }
        if (Length(FDirectory) > 0) and (FDirectory[Length(FDirectory)] <> '\') then
            FDirectory := FDirectory + '\';
        Exit;
    end;

    if Length(newDrive) = 0 then begin
        newDrive := ExtractFileDrive(FDirectory);
        newPath  := newValue;
    end
    else
        newPath := Copy(newValue, 3, Length(newValue));

    if Pos(':', newPath) <> 0 then
        raise Exception.Create('Invalid directory name syntax');

    if newPath = '..' then begin
        if IsUNC(FDirectory) then begin
            I := Length(FDirectory) - 1;
            while (I > 0) and (FDirectory[I] <> '\') do
                Dec(I);
            if I > Length(newDrive) then
                SetLength(FDirectory, I);
            Exit;
        end
        else begin
            newPath := Copy(FDirectory, 3, Length(FDirectory));
            I := Length(newPath) - 1;
            while (I > 0) and (newPath[I] <> '\') do
                Dec(I);
            SetLength(newPath, I);
        end;
    end;

    if (Length(newPath) > 0) and (newPath[1] <> '\') then begin
        { Relative path }
        if IsUNC(FDirectory) then begin
            FDirectory := FDirectory + newPath;
            { Always terminate with a backslash }
            if (Length(FDirectory) > 0) and (FDirectory[Length(FDirectory)] <> '\') then
                FDirectory := FDirectory + '\';
            Exit;
        end
        else begin
            if UpperCase(newDrive[1]) <> UpperCase(FDirectory[1]) then
                raise Exception.Create('Cannot accept path not relative to current directory');
            if Pos('.\', newPath) <> 0 then
                raise Exception.Create('Cannot accept relative path using dot notation');
            if newPath = '.' then
                newPath := Copy(FDirectory, 3, Length(FDirectory))
            else
                newPath := Copy(FDirectory, 3, Length(FDirectory)) + newPath;
        end;
    end
    else begin
        if Pos('.\', newPath) <> 0 then
            raise Exception.Create('Cannot accept relative path using dot notation');
    end;

    if Length(newPath) = 0 then begin
        if UpperCase(newDrive[1]) <> UpperCase(FDirectory[1]) then
            newPath := '\'
        else
            newPath := Copy(FDirectory, 3, Length(FDirectory));
    end;

    { Always terminate with a backslash }
    if (Length(newPath) > 0) and (newPath[Length(newPath)] <> '\') then
        newPath := newPath + '\';

    FDirectory := newDrive + newPath;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFtpCtrlSocket.SetAbortingTransfer(newValue : Boolean);
begin
    FAbortingTransfer := newValue;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.


