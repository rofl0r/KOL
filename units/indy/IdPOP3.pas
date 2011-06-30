// 26-nov-2002
unit IdPOP3;

interface

uses KOL { , 
  Classes } , IdGlobal,
  IdMessage, IdMessageClient;

type
  TIdPOP3 = object(TIdMessageClient)
  protected
    FPassword: string;
    FUserId: string;
  public
    function RetrieveRaw(const MsgNum: Integer; const Dest: TStrings): boolean;
    function CheckMessages: longint;
    procedure Connect; override;
     { constructor Create(AOwner: TComponent); override;
     } function Delete(const MsgNum: Integer): Boolean;
    procedure Disconnect; override;
    procedure KeepAlive;
    function Reset: Boolean;
    function Retrieve(const MsgNum: Integer; AMsg: TIdMessage): Boolean;
    function RetrieveHeader(const MsgNum: Integer; AMsg: TIdMessage): Boolean;
    function RetrieveMsgSize(const MsgNum: Integer): Integer;
    function RetrieveMailBoxSize: integer;
   { published } 
    property Password: string read FPassword write FPassword;
    property UserId: string read FUserId write FUserId;
    property Port default IdPORT_POP3;
  end;
PIdPOP3=^TIdPOP3;
function NewIdPOP3(AOwner: PControl):PIdPOP3;

implementation

uses
  IdTCPConnection,
  SysUtils;

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
    Result := StrToInt(Copy(Value2, 1, IndyPos(' ', Value2) - 1));
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
//constructor TIdPOP3.Create(AOwner: TComponent);
begin
//  inherited Create(AOwner);
  New( Result, Create );
  with Result^ do
  Port := IdPORT_POP3;
end;

function TIdPOP3.Delete(const MsgNum: Integer): Boolean;
begin
  SendCmd('DELE ' + IntToStr(MsgNum), wsOk); {Do not localize}
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

function TIdPOP3.RetrieveRaw(const MsgNum: Integer; const Dest: TStrings):
  boolean;
begin
  result := SendCmd('RETR ' + IntToStr(MsgNum)) = wsOk; {Do not localize}
  if result then
  begin
    Capture(Dest);
    result := true;
  end;
end;

function TIdPOP3.Retrieve(const MsgNum: Integer;
  AMsg: TIdMessage): Boolean;
begin

  if SendCmd('RETR ' + IntToStr(MsgNum)) = wsOk then {Do not localize}
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
    SendCmd('TOP ' + IntToStr(MsgNum) + ' 0', wsOk); {Do not localize}

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
    SendCmd('LIST ' + IntToStr(MsgNum), wsOk); {Do not localize}
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
