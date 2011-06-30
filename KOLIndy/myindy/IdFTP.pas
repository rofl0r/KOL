// 28-nov-2002
unit IdFTP;

interface

uses KOL { , 
  Classes }{ ,
  IdException},
  IdGlobal,
  IdSocketHandle, IdTCPConnection, IdTCPClient, IdThread,
  IdURI,indyProcs;

type
  TIdFTPTransferType = (ftBinary, ftASCII);

const
  Id_TIdFTP_TransferType = ftBinary;
  Id_TIdFTP_Passive = False;

type
  TIdFTP = object(TIdTCPClient)
  protected
    FUser: string;
    FPassive: boolean;
    FPassword: string;
    FSystemDesc: string;
    FTransferType: TIdFTPTransferType;
    FDataChannel: TIdTCPConnection;

    procedure InternalGet(const ACommand: string; ADest: TStream);
    procedure InternalPut(const ACommand: string; ASource: TStream);
    procedure SendPassive(var VIP: string; var VPort: integer);
    procedure SendPort(AHandle: TIdSocketHandle);
    procedure SendTransferType;
    procedure SetDataChannelWorkEvents;
    procedure SetTransferType(AValue: TIdFTPTransferType);
  public
    procedure Abort; virtual;
    procedure ChangeDir(const ADirName: string);
    procedure ChangeDirUp;
    procedure Connect{(AutoLogin: Boolean = true)}; virtual;// reintroduce;
     { constructor Create(AOwner: TComponent); override;
     } procedure Delete(const AFilename: string);
    procedure Get(const ASourceFile: string; ADest: TStream); overload;
    procedure Get(const ASourceFile, ADestFile: string; const ACanOverwrite:
      boolean = false);
      overload;
    procedure KillDataChannel; virtual;
    procedure List(ADest: PStrList; const ASpecifier: string = ''; const
      ADetails: boolean = true);
    procedure MakeDir(const ADirName: string);
    procedure Noop;
    procedure Put(const ASource: TStream; const ADestFile: string = '';
      const AAppend: boolean = false); overload;
    procedure Put(const ASourceFile: string; const ADestFile: string = '';
      const AAppend: boolean = false); overload;
    procedure Quit;
    procedure RemoveDir(const ADirName: string);
    procedure Rename(const ASourceFile, ADestFile: string);
    function RetrieveCurrentDir: string;
    procedure Site(const ACommand: string);
    function Size(const AFileName: string): Integer;

    property SystemDesc: string read FSystemDesc;
   { published } 
    property Passive: boolean read FPassive write FPassive default
      Id_TIdFTP_Passive;
    property Password: string read FPassword write FPassword;
    property TransferType: TIdFTPTransferType read FTransferType write
      SetTransferType default Id_TIdFTP_TransferType;
    property User: string read FUser write FUser;
    property Port default IDPORT_FTP;
  end;
PIdFTP=^TIdFTP;
function NewIdFTP(AOwner: PControl):PIdFTP;
{type  MyStupid0=DWord;
  EIdFTPFileAlreadyExists = object(EIdException);
PdFTP=^IdFTP; type  MyStupid3137=DWord;
 }
implementation

uses
  IdComponent,
  IdResourceStrings,
  IdStack, IdSimpleServer;

function CleanDirName(const APWDReply: string): string;
begin
  result := APWDReply;
  Delete(result, 1, Pos('"', result));
  result := Copy(result, 1, Pos('"', result) - 1);
end;

//constructor TIdFTP.Create(AOwner: TComponent);
function NewIdFTP(AOwner: PControl):PIdFTP;
begin
  New( Result, Create );
with Result^ do
//  inherited;
begin
//  Port := IDPORT_FTP;
  Passive := Id_TIdFTP_Passive;
  FTransferType := Id_TIdFTP_TransferType;
end;
end;

procedure TIdFTP.Connect({AutoLogin: Boolean = true});
begin
{  try
    inherited Connect;
    GetResponse([220]);
    if AutoLogin then
    begin
      if SendCmd('user ' + User, [230, 331]) = 331 then
      begin
        SendCmd('pass ' + Password, 230);
      end;
      SendTransferType;

      if SendCmd('syst', [200, 215, 500]) = 500 then
      begin
        FSystemDesc := RSFTPUnknownHost;
      end
      else
      begin
        FSystemDesc := Copy(CmdResult, 4, MaxInt);
      end;
    end;
  except
    Disconnect;
    raise;
  end;}
end;

procedure TIdFTP.SetTransferType(AValue: TIdFTPTransferType);
begin
{  if AValue <> FTransferType then
  begin
    if not Assigned(FDataChannel) then
    begin
      FTransferType := AValue;
      if Connected then
      begin
        SendTransferType;
      end;
    end
  end;}
end;

procedure TIdFTP.SendTransferType;
var
  s: string;
begin
  case TransferType of
    ftAscii: s := 'A';
    ftBinary: s := 'I';
  end;
  SendCmd('type ' + s, 200);
end;

procedure TIdFTP.Get(const ASourceFile: string; ADest: TStream);
begin
  InternalGet('retr ' + ASourceFile, ADest);
end;

procedure TIdFTP.Get(const ASourceFile, ADestFile: string; const ACanOverwrite:
  boolean = false);
//var
//  LDestStream: TFileStream;
begin
{  if FileExists(ADestFile) and (not ACanOverwrite) then
  begin
    raise EIdFTPFileAlreadyExists.Create(RSDestinationFileAlreadyExists);
  end;
  LDestStream := TFileStream.Create(ADestFile, fmCreate);
  try
    Get(ASourceFile, LDestStream);
  finally FreeAndNil(LDestStream);
  end;}
end;

procedure TIdFTP.List(ADest: PStrList; const ASpecifier: string = '';
  const ADetails: boolean = true);
//var
//  LDest: PStrListtream;
begin
{  LDest := PStrListtream.Create('');
  try
    if ADetails then
    begin
      InternalGet(trim('list ' + ASpecifier), LDest);
    end
    else
    begin
      InternalGet(trim('nlst ' + ASpecifier), LDest);
    end;
    ADest.Text := LDest.DataString;
  finally LDest.Free;
  end;}
end;

procedure TIdFTP.InternalGet(const ACommand: string; ADest: TStream);
var
  LIP: string;
  LPort: Integer;
begin
{  if FPassive then
  begin
    SendPassive(LIP, LPort);
    WriteLn(ACommand);
//    FDataChannel := TIdTCPClient.Create(nil);
    try
      with (FDataChannel as TIdTCPClient) do
      begin
        SocksInfo.Assign(Self.SocksInfo);
        SetDataChannelWorkEvents;
        Host := LIP;
        Port := LPort;
        Connect;
        try
          Self.GetResponse([125, 150]);
          ReadStream(ADest, -1, True);
        finally Disconnect;
        end;
      end;
    finally FreeAndNil(FDataChannel);
    end;
  end
  else
  begin
    FDataChannel := TIdSimpleServer.Create(nil);
    try
      with TIdSimpleServer(FDataChannel) do
      begin
        SetDataChannelWorkEvents;
        BoundIP := Self.Binding.IP;
        BeginListen;
        SendPort(Binding);
        Self.SendCmd(ACommand, [125, 150]);
        Listen;
        ReadStream(ADest, -1, True);
      end;
    finally FreeAndNil(FDataChannel);
    end;
  end;
  if GetResponse([225, 226, 250, 426]) = 426 then
  begin
    GetResponse([226]);
  end;}
end;

procedure TIdFTP.Quit;
begin
  if connected then
  begin
    WriteLn('Quit');
    Disconnect;
  end;
end;

procedure TIdFTP.KillDataChannel;
begin
{  if Assigned(FDataChannel) then
  begin
    FDataChannel.DisconnectSocket;
  end;}
end;

procedure TIdFTP.Abort;
begin
  if Connected then
  begin
    WriteLn('ABOR');
  end;
  KillDataChannel;
end;

procedure TIdFTP.SendPort(AHandle: TIdSocketHandle);
var s:String;
begin
  s:=AHandle.IP;
  While StrReplace(s, '.', ',') do;
  SendCmd('PORT ' + s
    + ',' + Int2Str(AHandle.Port div 256) + ',' + Int2Str(AHandle.Port mod
      256), [200]);
end;

procedure TIdFTP.InternalPut(const ACommand: string; ASource: TStream);
var
  LIP: string;
  LPort: Integer;
begin
{  if FPassive then
  begin
    SendPassive(LIP, LPort);
    WriteLn(ACommand);
    FDataChannel := TIdTCPClient.Create(nil);
    with TIdTCPClient(FDataChannel) do
    try
      SetDataChannelWorkEvents;
      Host := LIP;
      Port := LPort;
      SocksInfo.Assign(Self.SocksInfo);
      Connect;
      try
        Self.GetResponse([110, 125, 150]);
        try
          WriteStream(ASource, false);
        except
          on E: EIdSocketError do
          begin
            if E.LastError <> 10038 then
            begin
              raise;
            end;
          end;
        end;
      finally Disconnect;
      end;
    finally FreeAndNil(FDataChannel);
    end;
  end
  else
  begin
    FDataChannel := TIdSimpleServer.Create(nil);
    try
      with TIdSimpleServer(FDataChannel) do
      begin
        SetDataChannelWorkEvents;
        BoundIP := Self.Binding.IP;
        BeginListen;
        SendPort(Binding);
        Self.SendCmd(ACommand, [125, 150]);
        Listen;
        WriteStream(ASource);
      end;
    finally FreeAndNil(FDataChannel);
    end;
  end;
  if GetResponse([225, 226, 250, 426]) = 426 then
  begin
    GetResponse([226]);
  end;}
end;

procedure TIdFTP.SetDataChannelWorkEvents;
begin
//  FDataChannel.OnWork := OnWork;
//  FDataChannel.OnWorkBegin := OnWorkBegin;
//  FDataChannel.OnWorkEnd := OnWorkEnd;
end;

procedure TIdFTP.Put(const ASource: TStream; const ADestFile: string = '';
  const AAppend: boolean = false);
begin
  if length(ADestFile) = 0 then
  begin
    InternalPut('STOU ' + ADestFile, ASource);
  end
  else
    if AAppend then
  begin
    InternalPut('APPE ' + ADestFile, ASource);
  end
  else
  begin
    InternalPut('STOR ' + ADestFile, ASource);
  end;
end;

procedure TIdFTP.Put(const ASourceFile: string; const ADestFile: string = '';
  const AAppend: boolean = false);
//var
//  LSourceStream: TFileStream;
begin
{  LSourceStream := TFileStream.Create(ASourceFile, fmOpenRead or
    fmShareDenyNone);
  try
    Put(LSourceStream, ADestFile, AAppend);
  finally FreeAndNil(LSourceStream);
  end;}
end;

procedure TIdFTP.SendPassive(var VIP: string; var VPort: integer);
var
  i, bLeft, bRight: integer;
  s: string;
begin
  SendCmd('PASV', 227);
  s := Trim(CmdResult);
  bLeft := Pos('(', s);
  bRight := Pos(')', s);
  if (bLeft = 0) or (bRight = 0) then
  begin
    bLeft := RPos(#32, s);
    s := Copy(s, bLeft + 1, Length(s) - bLeft);
  end
  else
  begin
    s := Copy(s, bLeft + 1, bRight - bLeft - 1);
  end;
  VIP := '';
  for i := 1 to 4 do
  begin
    VIP := VIP + '.' + Fetch(s, ',');
  end;
  System.Delete(VIP, 1, 1);
  VPort := Str2Int(Fetch(s, ',')) * 256;
  VPort := VPort + Str2Int(Fetch(s, ','));
end;

procedure TIdFTP.Noop;
begin
  SendCmd('NOOP', 200);
end;

procedure TIdFTP.MakeDir(const ADirName: string);
begin
  SendCmd('MKD ' + ADirName, 257);
end;

function TIdFTP.RetrieveCurrentDir: string;
begin
  SendCmd('PWD', 257);
  Result := CleanDirName(CmdResult);
end;

procedure TIdFTP.RemoveDir(const ADirName: string);
begin
  SendCmd('RMD ' + ADirName, 250);
end;

procedure TIdFTP.Delete(const AFilename: string);
begin
  SendCmd('DELE ' + AFilename, 250);
end;

procedure TIdFTP.ChangeDir(const ADirName: string);
begin
  SendCmd('CWD ' + ADirName, 250);
end;

procedure TIdFTP.ChangeDirUp;
begin
  SendCmd('CDUP', 250);
end;

procedure TIdFTP.Site(const ACommand: string);
begin
  SendCmd('SITE ' + ACommand, 200);
end;

procedure TIdFTP.Rename(const ASourceFile, ADestFile: string);
begin
  SendCmd('RNFR ' + ASourceFile, 350);
  SendCmd('RNTO ' + ADestFile, 250);
end;

function TIdFTP.Size(const AFileName: string): Integer;
var
  SizeStr: string;
begin
  result := -1;
  if SendCmd('SIZE ' + AFileName) = 213 then
  begin
    SizeStr := Trim(CmdResultDetails.text);
    system.delete(SizeStr, 1, pos(' ', SizeStr));
    result := StrToIntDef(SizeStr, -1);
  end;
end;

end.
