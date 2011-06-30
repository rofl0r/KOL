// 26-nov-2002
unit IdPOP3;

interface

uses KOL { , 
  Classes } , IdGlobal,
  IdMessage, IdMessageClient,indyProcs;

type
  TIdPOP3 = object(TIdMessageClient)
  protected
    FPassword: string;
    FUserId: string;
  public
    function RetrieveRaw(const MsgNum: Integer; const Dest: PStrList): boolean;
    function CheckMessages: longint;
    procedure Connect; Virtual;
     { constructor Create(AOwner: TComponent); override;
     } function Delete(const MsgNum: Integer): Boolean;
    procedure Disconnect; Virtual;
    procedure KeepAlive;
    function Reset: Boolean;
    function Retrieve(const MsgNum: Integer; AMsg: TIdMessage): Boolean;
    function RetrieveHeader(const MsgNum: Integer; AMsg: TIdMessage): Boolean;
    function RetrieveMsgSize(const MsgNum: Integer): Integer;
    function RetrieveMailBoxSize: integer;
   { published } 
    property Password: string read FPassword write FPassword;
    property UserId: string read FUserId write FUserId;
  end;
PIdPOP3=^TIdPOP3;
function NewIdPOP3(AOwner: PControl):PIdPOP3;

implementation

uses
  IdTCPConnection;

function TIdPOP3.CheckMessages: longint;
var
  Value1, Value2: string;
begin
  Result := 0;
  SendCmd('STAT', wsOk); {Do not localize}
  Value1 := CmdResult;
  if Value1 <> '' then
  begin
    Value2 := Copy(Value1, 5, Length(Value1) - 5);
    Result := Str2Int(Copy(Value2, 1, IndyPos(' ', Value2) - 1));
  end;
end;

procedure TIdPOP3.Connect;
begin
  inherited
    Connect;
  try
    GetResponse([wsOk]);
    SendCmd('USER ' + UserId, wsOk); {Do not localize}
    SendCmd('PASS ' + Password, wsOk); {Do not localize}
  except
    Disconnect;
    raise;
  end;
end;

function NewIdPOP3(AOwner: PControl):PIdPOP3;
begin
  New( Result, Create );
  with Result^ do
  Port := IdPORT_POP3;
end;

function TIdPOP3.Delete(const MsgNum: Integer): Boolean;
begin
  SendCmd('DELE ' + Int2Str(MsgNum), wsOk); {Do not localize}
  Result := ResultNo = wsOk;
end;

procedure TIdPOP3.Disconnect;
begin
  try
    WriteLn('Quit'); {Do not localize}
  finally
    inherited;
  end;
end;

procedure TIdPOP3.KeepAlive;
begin
  SendCmd('NOOP', wsOk); {Do not localize}
end;

function TIdPOP3.Reset: Boolean;
begin
  SendCmd('RSET', wsOK); {Do not localize}
  Result := ResultNo = wsOK;
end;

function TIdPOP3.RetrieveRaw(const MsgNum: Integer; const Dest: PStrList):
  boolean;
begin
  result := SendCmd('RETR ' + Int2Str(MsgNum)) = wsOk; {Do not localize}
  if result then
  begin
    Capture(Dest);
    result := true;
  end;
end;

function TIdPOP3.Retrieve(const MsgNum: Integer;
  AMsg: TIdMessage): Boolean;
begin

  if SendCmd('RETR ' + Int2Str(MsgNum)) = wsOk then {Do not localize}
  begin
    ReceiveHeader(AMsg, '');
    ReceiveBody(AMsg);
  end;
  Result := ResultNo = wsOk;
end;

function TIdPOP3.RetrieveHeader(const MsgNum: Integer;
  AMsg: TIdMessage): Boolean;
var
  Dummy: string;
begin
  try
    SendCmd('TOP ' + Int2Str(MsgNum) + ' 0', wsOk); {Do not localize}

    ReceiveHeader(AMsg, '');
    Dummy := ReadLn;
    while Dummy = '' do
    begin
      Dummy := ReadLn;
    end;
    Result := Dummy = '.';
  except
    Result := False;
  end;
end;

function TIdPOP3.RetrieveMailBoxSize: integer;
var
  CurrentLine: string;
begin
  Result := 0;
  try
    SendCmd('LIST', wsOk); {Do not localize}
    CurrentLine := ReadLn;
    while (CurrentLine <> '.') and (CurrentLine <> '') do {Do not localize}
    begin
      CurrentLine := Copy(CurrentLine, IndyPos(' ', CurrentLine) + 1,
        Length(CurrentLine) - IndyPos(' ', CurrentLine) + 1);
      Result := Result + StrToIntDef(CurrentLine, 0);
      CurrentLine := ReadLn;
    end;
  except
    Result := -1;
  end;
end;

function TIdPOP3.RetrieveMsgSize(const MsgNum: Integer): Integer;
var
  ReturnResult: string;
begin
  try
    SendCmd('LIST ' + Int2Str(MsgNum), wsOk); {Do not localize}
    if CmdResult <> '' then
    begin
      ReturnResult := Copy(CmdResult, 5, Length(CmdResult) - 4);
      Result := StrToIntDef(Copy(ReturnResult, IndyPos(' ', ReturnResult) + 1,
        Length(ReturnResult) - IndyPos(' ', ReturnResult) + 1), -1);
    end
    else
      Result := -1;
  except
    Result := -1;
  end;
end;

end.
