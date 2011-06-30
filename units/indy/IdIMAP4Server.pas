// 26-nov-2002
unit IdIMAP4Server;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

const
  IMAPCommands: array[1..25] of string =
  ({ Client Commands - Any State}
    'CAPABILITY',
    'NOOP',
    'LOGOUT',
   { Client Commands - Non Authenticated State}
    'AUTHENTICATE',
    'LOGIN',
   { Client Commands - Authenticated State}
    'SELECT',
    'EXAMINE',
    'CREATE',
    'DELETE',
    'RENAME',
    'SUBSCRIBE',
    'UNSUBSCRIBE',
    'LIST',
    'LSUB',
    'STATUS',
    'APPEND',
   { Client Commands - Selected State}
    'CHECK',
    'CLOSE',
    'EXPUNGE',
    'SEARCH',
    'FETCH',
    'STORE',
    'COPY',
    'UID',
   { Client Commands - Experimental/ Expansion}
    'X');

type
  TCommandEvent = procedure(Thread: TIdPeerThread; const Tag, CmdStr: string;
    var Handled: Boolean) of object;

  TIdIMAP4Server = object(TIdTCPServer)
  protected
    fOnCommandCAPABILITY: TCommandEvent;
    fONCommandNOOP: TCommandEvent;
    fONCommandLOGOUT: TCommandEvent;
    fONCommandAUTHENTICATE: TCommandEvent;
    fONCommandLOGIN: TCommandEvent;
    fONCommandSELECT: TCommandEvent;
    fONCommandEXAMINE: TCommandEvent;
    fONCommandCREATE: TCommandEvent;
    fONCommandDELETE: TCommandEvent;
    fONCommandRENAME: TCommandEvent;
    fONCommandSUBSCRIBE: TCommandEvent;
    fONCommandUNSUBSCRIBE: TCommandEvent;
    fONCommandLIST: TCommandEvent;
    fONCommandLSUB: TCommandEvent;
    fONCommandSTATUS: TCommandEvent;
    fONCommandAPPEND: TCommandEvent;
    fONCommandCHECK: TCommandEvent;
    fONCommandCLOSE: TCommandEvent;
    fONCommandEXPUNGE: TCommandEvent;
    fONCommandSEARCH: TCommandEvent;
    fONCommandFETCH: TCommandEvent;
    fONCommandSTORE: TCommandEvent;
    fONCommandCOPY: TCommandEvent;
    fONCommandUID: TCommandEvent;
    fONCommandX: TCommandEvent;
    fOnCommandError: TCommandEvent;
    procedure DoCommandCAPABILITY(Thread: TIdPeerThread; const Tag, CmdStr:
      string; var Handled: Boolean);
    procedure DoCommandNOOP(Thread: TIdPeerThread; const Tag, CmdStr: string; var
      Handled: Boolean);
    procedure DoCommandLOGOUT(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandAUTHENTICATE(Thread: TIdPeerThread; const Tag, CmdStr:
      string; var Handled: Boolean);
    procedure DoCommandLOGIN(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandSELECT(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandEXAMINE(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandCREATE(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandDELETE(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandRENAME(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandSUBSCRIBE(Thread: TIdPeerThread; const Tag, CmdStr:
      string; var Handled: Boolean);
    procedure DoCommandUNSUBSCRIBE(Thread: TIdPeerThread; const Tag, CmdStr:
      string; var Handled: Boolean);
    procedure DoCommandLIST(Thread: TIdPeerThread; const Tag, CmdStr: string; var
      Handled: Boolean);
    procedure DoCommandLSUB(Thread: TIdPeerThread; const Tag, CmdStr: string; var
      Handled: Boolean);
    procedure DoCommandSTATUS(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandAPPEND(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandCHECK(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandCLOSE(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandEXPUNGE(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandSEARCH(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandFETCH(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandSTORE(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    procedure DoCommandCOPY(Thread: TIdPeerThread; const Tag, CmdStr: string; var
      Handled: Boolean);
    procedure DoCommandUID(Thread: TIdPeerThread; const Tag, CmdStr: string; var
      Handled: Boolean);
    procedure DoCommandX(Thread: TIdPeerThread; const Tag, CmdStr: string; var
      Handled: Boolean);
    procedure DoCommandError(Thread: TIdPeerThread; const Tag, CmdStr: string;
      var Handled: Boolean);
    function DoExecute(Thread: TIdPeerThread): Boolean; override;
  public
//    constructor Create(AOwner: TComponent); override;
  published
    property ONCommandCAPABILITY: TCommandEvent read fOnCommandCAPABILITY write
      fOnCommandCAPABILITY;
    property ONCommandNOOP: TCommandEvent read fONCommandNOOP write
      fONCommandNOOP;
    property ONCommandLOGOUT: TCommandEvent read fONCommandLOGOUT write
      fONCommandLOGOUT;
    property ONCommandAUTHENTICATE: TCommandEvent read fONCommandAUTHENTICATE
      write fONCommandAUTHENTICATE;
    property ONCommandLOGIN: TCommandEvent read fONCommandLOGIN write
      fONCommandLOGIN;
    property ONCommandSELECT: TCommandEvent read fONCommandSELECT write
      fONCommandSELECT;
    property OnCommandEXAMINE: TCommandEvent read fOnCommandEXAMINE write
      fOnCommandEXAMINE;
    property ONCommandCREATE: TCommandEvent read fONCommandCREATE write
      fONCommandCREATE;
    property ONCommandDELETE: TCommandEvent read fONCommandDELETE write
      fONCommandDELETE;
    property OnCommandRENAME: TCommandEvent read fOnCommandRENAME write
      fOnCommandRENAME;
    property ONCommandSUBSCRIBE: TCommandEvent read fONCommandSUBSCRIBE write
      fONCommandSUBSCRIBE;
    property ONCommandUNSUBSCRIBE: TCommandEvent read fONCommandUNSUBSCRIBE write
      fONCommandUNSUBSCRIBE;
    property ONCommandLIST: TCommandEvent read fONCommandLIST write
      fONCommandLIST;
    property OnCommandLSUB: TCommandEvent read fOnCommandLSUB write
      fOnCommandLSUB;
    property ONCommandSTATUS: TCommandEvent read fONCommandSTATUS write
      fONCommandSTATUS;
    property OnCommandAPPEND: TCommandEvent read fOnCommandAPPEND write
      fOnCommandAPPEND;
    property ONCommandCHECK: TCommandEvent read fONCommandCHECK write
      fONCommandCHECK;
    property OnCommandCLOSE: TCommandEvent read fOnCommandCLOSE write
      fOnCommandCLOSE;
    property ONCommandEXPUNGE: TCommandEvent read fONCommandEXPUNGE write
      fONCommandEXPUNGE;
    property OnCommandSEARCH: TCommandEvent read fOnCommandSEARCH write
      fOnCommandSEARCH;
    property ONCommandFETCH: TCommandEvent read fONCommandFETCH write
      fONCommandFETCH;
    property OnCommandSTORE: TCommandEvent read fOnCommandSTORE write
      fOnCommandSTORE;
    property OnCommandCOPY: TCommandEvent read fOnCommandCOPY write
      fOnCommandCOPY;
    property ONCommandUID: TCommandEvent read fONCommandUID write fONCommandUID;
    property OnCommandX: TCommandEvent read fOnCommandX write fOnCommandX;
    property OnCommandError: TCommandEvent read fOnCommandError write
      fOnCommandError;
    property DefaultPort default IdPORT_IMAP4;
  end;

  PIdIMAP4Server=^TIdIMAP4Server;
//  constructor Create(AOwner: TComponent); override;
  function NewIdIMAP4Server(AOwner:PControl):PIdIMAP4Server;



implementation

uses KOL, 
  SysUtils;

const
  cCAPABILITY = 1;
  cNOOP = 2;
  cLOGOUT = 3;
  cAUTHENTICATE = 4;
  cLOGIN = 5;
  cSELECT = 6;
  cEXAMINE = 7;
  cCREATE = 8;
  cDELETE = 9;
  cRENAME = 10;
  cSUBSCRIBE = 11;
  cUNSUBSCRIBE = 12;
  cLIST = 13;
  cLSUB = 14;
  cSTATUS = 15;
  cAPPEND = 16;
  cCHECK = 17;
  cCLOSE = 18;
  cEXPUNGE = 19;
  cSEARCH = 20;
  cFETCH = 21;
  cSTORE = 22;
  cCOPY = 23;
  cUID = 24;
  cXCmd = 25;

 { constructor TIdIMAP4Server.Create(AOwner: TComponent);
 } 

function NewIdIMAP4Server(AOwner:PControl):PIdIMAP4Server;
 begin
//  inherited;
  New( Result, Create );
with Result^ do
  DefaultPort := IdPORT_IMAP4;
end;

function TIdIMAP4Server.DoExecute(Thread: TIdPeerThread): Boolean;
var
  RcvdStr,
    ArgStr,
    sTag,
    sCmd: string;
  cmdNum: Integer;
  Handled: Boolean;

  function GetFirstTokenDeleteFromArg(var s1: string;
    const sDelim: string): string;
  var
    nPos: Integer;
  begin
    nPos := IndyPos(sDelim, s1);
    if nPos = 0 then
    begin
      nPos := Length(s1) + 1;
    end;
    Result := Copy(s1, 1, nPos - 1);
    Delete(s1, 1, nPos);
    S1 := Trim(S1);
  end;

begin
  result := true;
  while Thread.Connection.Connected do
  begin
    Handled := False;
    RcvdStr := Thread.Connection.ReadLn;
    ArgStr := RcvdStr;
    sTag := UpperCase(GetFirstTokenDeleteFromArg(ArgStr, CHAR32));
    sCmd := UpperCase(GetFirstTokenDeleteFromArg(ArgStr, CHAR32));
    CmdNum := Succ(PosInStrArray(Uppercase(sCmd), IMAPCommands));
    case CmdNum of
      cCAPABILITY: DoCommandCAPABILITY(Thread, sTag, ArgStr, Handled);
      cNOOP: DoCommandNOOP(Thread, sTag, ArgStr, Handled);
      cLOGOUT: DoCommandLOGOUT(Thread, sTag, ArgStr, Handled);
      cAUTHENTICATE: DoCommandAUTHENTICATE(Thread, sTag, ArgStr, Handled);
      cLOGIN: DoCommandLOGIN(Thread, sTag, ArgStr, Handled);
      cSELECT: DoCommandSELECT(Thread, sTag, ArgStr, Handled);
      cEXAMINE: DoCommandEXAMINE(Thread, sTag, ArgStr, Handled);
      cCREATE: DoCommandCREATE(Thread, sTag, ArgStr, Handled);
      cDELETE: DoCommandDELETE(Thread, sTag, ArgStr, Handled);
      cRENAME: DoCommandRENAME(Thread, sTag, ArgStr, Handled);
      cSUBSCRIBE: DoCommandSUBSCRIBE(Thread, sTag, ArgStr, Handled);
      cUNSUBSCRIBE: DoCommandUNSUBSCRIBE(Thread, sTag, ArgStr, Handled);
      cLIST: DoCommandLIST(Thread, sTag, ArgStr, Handled);
      cLSUB: DoCommandLSUB(Thread, sTag, ArgStr, Handled);
      cSTATUS: DoCommandSTATUS(Thread, sTag, ArgStr, Handled);
      cAPPEND: DoCommandAPPEND(Thread, sTag, ArgStr, Handled);
      cCHECK: DoCommandCHECK(Thread, sTag, ArgStr, Handled);
      cCLOSE: DoCommandCLOSE(Thread, sTag, ArgStr, Handled);
      cEXPUNGE: DoCommandEXPUNGE(Thread, sTag, ArgStr, Handled);
      cSEARCH: DoCommandSEARCH(Thread, sTag, ArgStr, Handled);
      cFETCH: DoCommandFETCH(Thread, sTag, ArgStr, Handled);
      cSTORE: DoCommandSTORE(Thread, sTag, ArgStr, Handled);
      cCOPY: DoCommandCOPY(Thread, sTag, ArgStr, Handled);
      cUID: DoCommandUID(Thread, sTag, ArgStr, Handled);
    else
      begin
        if (Length(SCmd) > 0) and (UpCase(SCmd[1]) = 'X') then
        begin
          DoCommandX(Thread, sTag, ArgStr, Handled);
        end
        else
        begin
          DoCommandError(Thread, sTag, ArgStr, Handled);
        end;
      end;
    end;
  end;
end;

procedure TIdIMAP4Server.DoCommandCapability(Thread: TIdPeerThread; const Tag,
  CmdStr: string;
  var Handled: Boolean);
begin
  if Assigned(fOnCommandCAPABILITY) then
  begin
    OnCommandCAPABILITY(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandNOOP(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandNOOP) then
  begin
    OnCommandNOOP(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandLOGOUT(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandLOGOUT) then
  begin
    OnCommandLOGOUT(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandAUTHENTICATE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandAUTHENTICATE) then
  begin
    OnCommandAUTHENTICATE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandLOGIN(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandLOGIN) then
  begin
    OnCommandLOGIN(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandSELECT(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandSELECT) then
  begin
    OnCommandSELECT(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandEXAMINE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandEXAMINE) then
  begin
    OnCommandEXAMINE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandCREATE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandCREATE) then
  begin
    OnCommandCREATE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandDELETE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandDELETE) then
  begin
    OnCommandDELETE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandRENAME(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandRENAME) then
  begin
    OnCommandRENAME(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandSUBSCRIBE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandSUBSCRIBE) then
  begin
    OnCommandSUBSCRIBE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandUNSUBSCRIBE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandUNSUBSCRIBE) then
  begin
    OnCommandUNSUBSCRIBE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandLIST(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandLIST) then
  begin
    OnCommandLIST(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandLSUB(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandLSUB) then
  begin
    OnCommandLSUB(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandSTATUS(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandSTATUS) then
  begin
    OnCommandSTATUS(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandAPPEND(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandAPPEND) then
  begin
    OnCommandAPPEND(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandCHECK(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandCHECK) then
  begin
    OnCommandCHECK(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandCLOSE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandCLOSE) then
  begin
    OnCommandCLOSE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandEXPUNGE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandEXPUNGE) then
  begin
    OnCommandEXPUNGE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandSEARCH(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandSEARCH) then
  begin
    OnCommandSEARCH(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandFETCH(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandFETCH) then
  begin
    OnCommandFETCH(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandSTORE(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandSTORE) then
  begin
    OnCommandSTORE(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandCOPY(Thread: TIdPeerThread;
  const Tag, CmdStr: string; var Handled: Boolean);
begin
  if Assigned(fONCommandCOPY) then
  begin
    OnCommandCOPY(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandUID(Thread: TIdPeerThread; const Tag, CmdStr:
  string;
  var Handled: Boolean);
begin
  if Assigned(fONCommandUID) then
  begin
    OnCommandUID(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandX(Thread: TIdPeerThread; const Tag, CmdStr:
  string;
  var Handled: Boolean);
begin
  if Assigned(fONCommandX) then
  begin
    OnCommandX(Thread, Tag, CmdStr, Handled);
  end;
end;

procedure TIdIMAP4Server.DoCommandError(Thread: TIdPeerThread; const Tag,
  CmdStr: string;
  var Handled: Boolean);
begin
  if Assigned(fONCommandError) then
  begin
    OnCommandError(Thread, Tag, CmdStr, Handled);
  end;
end;

end.
