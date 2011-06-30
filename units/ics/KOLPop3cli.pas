unit pop3cli;

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}

uses KOL, 
    WinTypes,
    WinProcs,
    SysUtils,
    Messages { , 
    Classes } ,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    Menus,
    WSocket,
    Wait,
    MD5;

const
    Pop3CliVersion = 116;

type
    TPop3Display  = procedure(Sender: TObject; Msg : String) of object;
    TPop3State    = (pop3Disconnected, pop3WaitingUser, pop3WaitingPass, pop3Transaction, pop3Update);
    TPop3Method   = function : boolean of object;
    TPop3Client = object(TObj)
    private
        FWSocket        : TWSocket;
        FHost           : String;
        FPort           : String;
        FUserName       : String;
        FPassWord       : String;
        FProtocolState  : TPop3State;
        FLastResponse   : String;
        FErrorMessage   : String;
        FTimeStamp      : String;
        FWait           : TWait;
        FTimeout        : Integer;
        FTimeOutFlag    : Boolean;
        FLineTooLong    : Boolean;
        FMsgCount       : Integer;
        FMsgSize        : Integer;
        FMsgNum         : Integer;
        FMsgUidl        : String;
        FMsgLines       : Integer;
        FTag            : LongInt;

        FOnDisplay      : TPop3Display;
        FOnMessageBegin : TNotifyEvent;
        FOnMessageEnd   : TNotifyEvent;
        FOnMessageLine  : TNotifyEvent;
        FOnListBegin    : TNotifyEvent;
        FOnListEnd      : TNotifyEvent;
        FOnListLine     : TNotifyEvent;
        FOnUidlBegin    : TNotifyEvent;
        FOnUidlEnd      : TNotifyEvent;
        FOnUidlLine     : TNotifyEvent;
    protected
        procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure   ClearErrorMessage;
        procedure   SetErrorMessage;
        procedure   Display(Msg : String);
        procedure   SetWait(Value : TWait);
        function    GetResponse : Boolean;
        procedure   SendCommand(Cmd : String);
        procedure   WaitTimeOut(Sender : TObject);
        procedure   SessionClosed(Sender : TObject; Error : WORD);
        procedure   LineTooLong(Sender : TObject);
        function    ExtractNumbers(var N1 : Integer; var N2 : Integer) : Boolean;
        function    ExtractUidl(var N1 : Integer; var N2 : String) : Boolean;
        procedure   ProcessUidl(Sender : TObject);
        procedure   ProcessList(Sender : TObject);
        function    GetMultiLine(aOnBegin : TNotifyEvent;
                                 aOnLine  : TNotifyEvent;
                                 aOnEnd   : TNotifyEvent;
                                 aProcess : TNotifyEvent) : Boolean;
        function    StartTransaction(OpCode, Params : String) : Boolean;
        function    PassRpop(OpCode : String) : Boolean;
    public
         { constructor Create(AOwner : TComponent); override;
         } destructor  Destroy; 
         virtual; function    Connect : Boolean;
        function    User    : Boolean;
        function    Pass    : Boolean;
        function    Quit    : Boolean;
        function    Stat    : Boolean;
        function    List    : Boolean;
        function    Retr    : Boolean;
        function    Dele    : Boolean;
        function    Noop    : Boolean;
        function    Last    : Boolean;
        function    Rset    : Boolean;
        function    Top     : Boolean;
        function    Rpop    : Boolean;
        function    Uidl    : Boolean;
        function    Apop    : Boolean;
        property    WSocket : TWSocket read FWSocket;
     { published } 
        property Host : String                 read  FHost
                                               write FHost;
        property Port : String                 read  FPort
                                               write FPort;
        property UserName : String             read  FUserName
                                               write FUserName;
        property PassWord : String             read  FPassWord
                                               write FPassWord;
        property Wait : TWait                  read  FWait
                                               write SetWait;
        property TimeOut : Integer             read  FTimeout
                                               write FTimeout;
        property ErrorMessage : String         read  FErrorMessage;
        property LastResponse : String         read  FLastResponse;
        property ProtocolState : TPop3State    read  FProtocolState;
        {:Updated by the Stat method with the number of
          messages in the maildrop }
        property MsgCount : Integer            read  FMsgCount;
        {:Updated by the Stat method with the total size
          in byte for the messages in the maildrop }
        property MsgSize : Integer             read  FMsgSize;
        {:This is the number of lines to display in the TOP command
          Set to zero if you wants the default value }
        property MsgLines : Integer            read  FMsgLines
                                               write FMsgLines;
        {:This is the message number which must be returned by the Retr
          method. It is also updated by the Last method }
        property MsgNum : Integer              read  FMsgNum
                                               write FMsgNum;
        property MsgUidl : String              read  FMsgUidl;
        property Tag : LongInt                 read  FTag
                                               write FTag;

        property OnDisplay : TPop3Display      read  FOnDisplay
                                               write FOnDisplay;
        property OnMessageBegin : TNotifyEvent read  FOnMessageBegin
                                               write FOnMessageBegin;
        property OnMessageEnd : TNotifyEvent   read  FOnMessageEnd
                                               write FOnMessageEnd;
        property OnMessageLine : TNotifyEvent  read  FOnMessageLine
                                               write FOnMessageLine;
        property OnListBegin : TNotifyEvent    read  FOnListBegin
                                               write FOnListBegin;
        property OnListEnd : TNotifyEvent      read  FOnListEnd
                                               write FOnListEnd;
        property OnListLine : TNotifyEvent     read  FOnListLine
                                               write FOnListLine;
        property OnUidlBegin : TNotifyEvent    read  FOnUidlBegin
                                               write FOnUidlBegin;
        property OnUidlEnd : TNotifyEvent      read  FOnUidlEnd
                                               write FOnUidlEnd;
        property OnUidlLine : TNotifyEvent     read  FOnUidlLine
                                               write FOnUidlLine;
    end;
PPop3Client=^TPop3Client;
function NewPop3Client(AOwner : TComponent):PPop3Client; type  MyStupid0=DWord; 

procedure Register;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
procedure SetLength(var S: string; NewLength: Integer);
begin
    S[0] := chr(NewLength);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RTrim(Str : String) : String;
var
    i : Integer;
begin
    i := Length(Str);
    while (i > 0) and (Str[i] = ' ') do
        i := i - 1;
    Result := Copy(Str, 1, i);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function LTrim(Str : String) : String;
var
    i : Integer;
begin
    if Str[1] <> ' ' then             { Petite optimisation: pas d'espace   }
        Result := Str
    else begin
        i := 1;
        while (i <= Length(Str)) and (Str[i] = ' ') do
            i := i + 1;
        Result := Copy(Str, i, Length(Str) - i + 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Trim(Str : String) : String;
begin
    Result := LTrim(Rtrim(Str));
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function stpblk(PValue : PChar) : PChar;
begin
    Result := PValue;
    while Result^ in [' ', #9, #10, #13] do
        Inc(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function atoi(PValue : PChar) : Integer;
begin
    Result := 0;
    PValue := stpblk(PValue);
    while PValue^ in ['0'..'9'] do begin
        Result := Result * 10 + ord(PValue^) - ord('0');
        Inc(PValue);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TPop3Client.Create(AOwner : TComponent);
begin
    inherited Create(AOwner);
    FWSocket                 := TWSocket.Create(nil);
    FWSocket.OnSessionClosed := SessionClosed;
    FWSocket.OnLineTooLong   := LineTooLong;
    FTimeout                 := 15;
    FProtocolState           := pop3Disconnected;
    FPort                    := 'pop3';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TPop3Client.Destroy;
begin
    if Assigned(FWSocket) then begin
        FWSocket.Destroy;
        FWSocket := nil;
    end;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Connect : Boolean;
var
    I, J : Integer;
begin
    Result     := FALSE;
    FTimeStamp := '';

    if FWait = nil then begin
        FErrorMessage := '-ERR No wait object';
        Display(FErrorMessage);
        Exit;
    end;

    FWait.OnTimeout := WaitTimeout;
    FTimeOutFlag    := FALSE;

    if FProtocolState > pop3Disconnected then begin
        { Already connected, it's ok }
        Result := TRUE;
        Exit;
    end;

    ClearErrorMessage;

    if Length(FHost) = 0 then begin
        FErrorMessage := '-ERR No host specified';
        Display(FErrorMessage);
        Exit;
    end;

    try
        FWSocket.Proto           := 'tcp';
        FWSocket.Port            := FPort;
        FWSocket.Addr            := FHost;
        FWSocket.OnDataAvailable := nil;

        FWSocket.Connect;
    except
        on E:ESocketException do begin
            FErrorMessage := '-ERR ' + E.Message;
            Exit;
        end;
    end;

    if not FWSocket.Wait(FTimeout, wsConnected) then begin
        FErrorMessage := '-ERR Can''t connect to host ''' + FHost + '''';
        Display(FErrorMessage);
        FWSocket.Close;
        Exit;
    end;
    Display('Connected with POP3 server');

    if not GetResponse then begin
        SetErrorMessage;
        FWSocket.Close;
        Exit;
    end;

    I := Pos('<', FLastResponse);
    J := Pos('>', Copy(FLastResponse, I, Length(FLastREsponse)));
    if (I > 0) and (J > 0) then
        FTimeStamp := Copy(FLastResponse, I, J);

    FProtocolState := pop3WaitingUser;
    Result         := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Quit : Boolean;
begin
    if FProtocolState = pop3Disconnected then begin
        { Not connected, it's ok }
        Result := TRUE;
        Exit;
    end;

    try
        SendCommand('QUIT');
        Result := GetResponse;
    except
        Result := FALSE;
    end;

    FProtocolState := pop3Disconnected;
    FWSocket.Close;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.User : Boolean;
begin
    Result := FALSE;
    if FProtocolState > pop3WaitingUser then begin
        FErrorMessage := '-ERR USER command invalid now';
        Display(FErrorMessage);
        Exit;
    end;

    if (FProtocolState = pop3Disconnected) and (not Connect) then
        Exit;

    SendCommand('USER ' + Trim(FUserName));
    if not GetResponse then
        Exit;
    Result         := TRUE;
    FProtocolState := pop3WaitingPass;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Apop : Boolean;
begin
    Result := FALSE;
    if FProtocolState > pop3WaitingUser then begin
        FErrorMessage := '-ERR APOP command invalid now';
        Display(FErrorMessage);
        Exit;
    end;

    if (FProtocolState = pop3Disconnected) and (not Connect) then
        Exit;

    if FTimeStamp = '' then begin
        FErrorMessage := '-ERR Server do not support APOP (no timestamp)';
        Display(FErrorMessage);
        Exit;
    end;

    SendCommand('APOP ' + Trim(FUserName)+ ' ' +
                StrMD5(FTimeStamp + FPassWord));
    if not GetResponse then
        Exit;
    Result         := TRUE;
    FProtocolState := pop3WaitingPass;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Pass : Boolean;
begin
    Result := PassRpop('PASS');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Rpop : Boolean;
begin
    Result := PassRpop('RPOP');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.PassRpop(OpCode : String) : Boolean;
begin
    Result := FALSE;
    if FProtocolState > pop3WaitingPass then begin
        FErrorMessage := '-ERR ' + OpCode + ' command invalid now';
        Display(FErrorMessage);
        Exit;
    end;

    if (FProtocolState < pop3WaitingPass) and (not User) then
        Exit;

    SendCommand(OpCode + ' ' + Trim(FPassWord));
    if not GetResponse then
        Exit;
    Result         := TRUE;
    FProtocolState := pop3Transaction;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Retr : Boolean;
begin
    Result := StartTransaction('RETR', IntToStr(FMsgNum));
    if not Result then
        Exit;
    Result := GetMultiLine(FOnMessageBegin, FOnMessageLine, FOnMessageEnd, nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Stat : Boolean;
begin
    FMsgCount := 0;
    FMsgSize  := 0;
    
    Result := StartTransaction('STAT', '');
    if not Result then
        Exit;

    Result := ExtractNumbers(FMsgCount, FMsgSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.ProcessUidl(Sender : TObject);
begin
    ExtractUidl(FMsgNum, FMsgUidl);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.ProcessList(Sender : TObject);
begin
    ExtractNumbers(FMsgNum, FMsgSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.List : Boolean;
begin
    if FMsgNum <= 0 then begin
        { Scan LIST command (all messages) }
        Result := StartTransaction('LIST', '');
        if not Result then
            Exit;
        Result := GetMultiLine(FOnListBegin, FOnListLine,
                               FOnListEnd,   ProcessList);
    end
    else begin
        { Single message LIST command }
        Result := StartTransaction('LIST', IntToStr(FMsgNum));
        if not Result then
            Exit;
        Result := ExtractNumbers(FMsgNum, FMsgSize);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Uidl : Boolean;
begin
    if FMsgNum <= 0 then begin
        { UIDL command (all messages) }
        Result := StartTransaction('UIDL', '');
        if not Result then
            Exit;
        Result := GetMultiLine(FOnUidlBegin, FOnUidlLine,
                               FOnUidlEnd,   ProcessUidl);
    end
    else begin
        { Single message UIDL command }
        Result := StartTransaction('UIDL', IntToStr(FMsgNum));
        if not Result then
            Exit;
        Result := ExtractUidl(FMsgNum, FMsgUidl);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Dele : Boolean;
begin
    Result := StartTransaction('DELE', IntToStr(FMsgNum));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Noop : Boolean;
begin
    Result := StartTransaction('NOOP', '');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Last : Boolean;
begin
    Result := StartTransaction('LAST', '');
    if Result then
        Result := ExtractNumbers(FMsgNum, FMsgSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Rset : Boolean;
begin
    Result := StartTransaction('RSET', '');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.Top : Boolean;
begin
    if FMsgLines < 0 then
        Result := FALSE
    else
        Result := StartTransaction('TOP' , IntToStr(FMsgNum) + ' ' +
                                           IntToStr(FMsgLines));
    if not Result then
        Exit;
    Result := GetMultiLine(FOnMessageBegin, FOnMessageLine, FOnMessageEnd, nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.StartTransaction(OpCode, Params : String) : Boolean;
begin
    Result  := FALSE;

    if (FProtocolState < pop3Transaction) and (not Pass) then
        Exit;

    if FProtocolState <> pop3Transaction then begin
        FErrorMessage := '-ERR ' + OpCode + ' command invalid now';
        Display(FErrorMessage);
        Exit;
    end;

    if Params <> '' then
        SendCommand(OpCode + ' ' + Params)
    else
        SendCommand(OpCode);

    Result := GetResponse;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.GetMultiLine(
    aOnBegin : TNotifyEvent;
    aOnLine  : TNotifyEvent;
    aOnEnd   : TNotifyEvent;
    aProcess : TNotifyEvent) : Boolean;
var
    bFlag : Boolean;
begin
    { Let the application know that the message is beginning }
    if Assigned(aOnBegin) then
        aOnBegin(Self);

    bFlag := FALSE;
    try
        while TRUE do begin
            { Read a message line }
            FLineTooLong := FALSE;
            if FWSocket.State = wsConnected then
                FWSocket.ReadLine(FTimeout, FLastResponse);

            { Check if we are still connected }
            if FWSocket.State <> wsConnected then begin
                FErrorMessage := '-ERR Disconneced unexpectedly';
                Display(FErrorMessage);
                break;
            end;

            { Check if we timed out }
            if FTimeOutFlag then begin
                FErrorMessage := '-ERR Receive Timeout';
                Display(FErrorMessage);
                break;
            end;

            { Check if end of message }
            if (not bFlag) and (FLastResponse = '.') then begin
                FLastResponse := '';
                break;
            end;

            { Check if message contains end-of-message mark }
            if (Length(FLastResponse) >= 2) and
               (FLastResponse[1] = '.') and (FLastResponse[2] = '.') then
                { Remove byte-stuff }
                FLastResponse := Copy(FLastResponse, 2, Length(FLastResponse));

            { Additional process }
            if Assigned(aProcess) then
                aProcess(Self);

            { Let the application process the message line }
            if Assigned(aOnLine) then
                aOnLine(Self);

            bFlag := FLineTooLong;

            { Let other application breaze }
            Application.ProcessMessages;
        end;
    finally
        { Let the application know that the message is finished }
        if Assigned(aOnEnd) then
            aOnEnd(Self);
    end;

    Result := not FTimeOutFlag;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.ExtractUidl(var N1 : Integer; var N2 : String) : Boolean;
var
    p : PChar;
begin
    Result := FALSE;
    N1     := 0;
    N2     := '';

{$IFDEF VER80}
    { Delphi 1 do not automatically nul terminate strings }
    FLastResponse := FLastResponse + #0;
{$ENDIF}

    { Search for first digit in response }
    p := @FLastResponse[1];
    while (p^ <> #0) and (not (p^ in ['0'..'9'])) do
        Inc(p);
    if p^ = #0 then { Invalid response, need a number }
        Exit;

    { Convert first number }
    N1 := atoi(p);

    { Search end of number }
    while (p^ <> #0) and (p^ in ['0'..'9']) do
        Inc(p);

    { Search Uidl }
    while (p^ = ' ') do
        Inc(p);

    { Copy UIDL }
    while (p^ <> #0) and (p^ in [#33..#126]) do begin
        N2 := N2 + p^;
        Inc(p);
    end;

    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.ExtractNumbers(var N1 : Integer; var N2 : Integer) : Boolean;
var
    p : PChar;
begin
    Result := FALSE;

{$IFDEF VER80}
    { Delphi 1 do not automatically nul terminate strings }
    FLastResponse := FLastResponse + #0;
{$ENDIF}

    { Search for first digit in response }
    p := @FLastResponse[1];
    while (p^ <> #0) and (not (p^ in ['0'..'9'])) do
        Inc(p);
    if p^ = #0 then begin
        { Invalid response, need a number }
        N1 := 0;
        N2 := 0;
        Exit;
    end;

    { Convert first number }
    N1 := atoi(p);

    { Search end of number }
    while (p^ <> #0) and (p^ in ['0'..'9']) do
        Inc(p);

    { Search next number }
    p := stpblk(p);

    if p^ = #0 then begin
        { Invalid response, need a number }
        N1 := 0;
        N2 := 0;
        Exit;
    end;

    N2     := atoi(p);
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.WaitTimeOut(Sender : TObject);
begin
    FTimeOutFlag := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.LineTooLong(Sender : TObject);
begin
    FLineTooLong := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.SessionClosed(Sender : TObject; Error : WORD);
begin
    if Assigned(FWait) then
        FWait.Stop;
    FProtocolState := pop3Disconnected;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.SendCommand(Cmd : String);
begin
    Display('> ' + Cmd);
    Application.ProcessMessages;
    FWSocket.SendStr(Cmd + #13 + #10);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TPop3Client.GetResponse : Boolean;
begin
    FWSocket.ReadLine(FTimeout, FLastResponse);
    Display('< ' + FLastResponse);
    Result := ((Length(FLastResponse) > 0) and (FLastResponse[1] = '+'));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.SetWait(Value : TWait);
begin
    FWait             := Value;
    FWSocket.WaitCtrl := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.Notification(AComponent: TComponent; Operation: TOperation);
begin
    inherited Notification(AComponent, Operation);
    if Operation = opRemove then begin
        if AComponent = FWait then
            FWait := nil
        else if AComponent = FWSocket then
            FWSocket := nil;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.Display(Msg : String);
begin
    if Assigned(FOnDisplay) then
        FOnDisplay(Self, Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.ClearErrorMessage;
begin
    FErrorMessage := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TPop3Client.SetErrorMessage;
begin
    if FErrorMessage = '' then
        FErrorMessage := FLastResponse;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('FPiette', [TPop3Client]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

