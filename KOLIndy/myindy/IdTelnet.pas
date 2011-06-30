// 30-nov-2002
unit IdTelnet;

interface

uses KOL { , 
  Classes }{ ,
  IdException}, IdTCPClient, IdThread, IdStack;

const
  { These are the telnet command constansts from RFC 854 }
  TNC_EOR = #239; // End of Record RFC 885
  TNC_SE = #240; // End of subnegotiation parameters.
  TNC_NOP = #241; // No operation.
  TNC_DATA_MARK = #242; // The data stream portion of a Synch.
                                    // This should always be accompanied
                                    // by a TCP Urgent notification.
  TNC_BREAK = #243; // NVT character BRK.
  TNC_IP = #244; // The function IP.
  TNC_AO = #245; // The function ABORT OUTPUT.
  TNC_AYT = #246; // The function ARE YOU THERE.
  TNC_EC = #247; // The function ERASE CHARACTER.
  TNC_EL = #248; // The function ERASE LINE.
  TNC_GA = #249; // The GO AHEAD signal.
  TNC_SB = #250; // Indicates that what follows is
                                    // subnegotiation of the indicated
                                    // option.
  TNC_WILL = #251; // Indicates the desire to begin
                                    // performing, or confirmation that
                                    // you are now performing, the
                                    // indicated option.
  TNC_WONT = #252; // Indicates the refusal to perform,
                                    // or continue performing, the
                                    // indicated option.
  TNC_DO = #253; // Indicates the request that the
                                    // other party perform, or
                                    // confirmation that you are expecting
                                    // the other party to perform, the
                                    // indicated option.
  TNC_DONT = #254; // Indicates the demand that the
                                    // other party stop performing,
                                    // or confirmation that you are no
                                    // longer expecting the other party
                                    // to perform, the indicated option.
  TNC_IAC = #255; // Data Byte 255.

  { Telnet options from RFC 1010 }
  TNO_BINARY = #0; // Binary Transmission
  TNO_ECHO = #1; // Echo
  TNO_RECONNECT = #2; // Reconnection
  TNO_SGA = #3; // Suppress Go Ahead
  TNO_AMSN = #4; // Approx Message Size Negotiation
  TNO_STATUS = #5; // Status
  TNO_TIMING_MARK = #6; // Timing Mark
  TNO_RCTE = #7; // Remote Controlled Trans and Echo
  TNO_OLW = #8; // Output Line Width
  TNO_OPS = #9; // Output Page Size
  TNO_OCRD = #10; // Output Carriage-Return Disposition
  TNO_OHTS = #11; // Output Horizontal Tab Stops
  TNO_OHTD = #12; // Output Horizontal Tab Disposition
  TNO_OFD = #13; // Output Formfeed Disposition
  TNO_OVT = #14; // Output Vertical Tabstops
  TNO_OVTD = #15; // Output Vertical Tab Disposition
  TNO_OLD = #16; // Output Linefeed Disposition
  TNO_EA = #17; // Extended ASCII
  TNO_LOGOUT = #18; // Logout
  TNO_BYTE_MACRO = #19; // Byte Macro
  TNO_DET = #20; // Data Entry Terminal
  TNO_SUPDUP = #21; // SUPDUP
  TNO_SUPDUP_OUTPUT = #22; // SUPDUP Output
  TNO_SL = #23; // Send Location
  TNO_TERMTYPE = #24; // Terminal Type
  TNO_EOR = #25; // End of Record
  TNO_TACACS_ID = #26; // TACACS User Identification
  TNO_OM = #27; // Output Marking
  TNO_TLN = #28; // Terminal Location Number
  TNO_3270REGIME = #29; // 3270 regime
  TNO_X3PAD = #30; // X.3 PAD
  TNO_NAWS = #31; // Window size
  TNO_TERM_SPEED = #32; // Terminal speed
  TNO_RFLOW = #33; // Remote flow control
  TNO_LINEMODE = #34; // Linemode option
  TNO_XDISPLOC = #35; // X Display Location
  TNO_AUTH = #37; // Authenticate
  TNO_ENCRYPT = #38; // Encryption option

  TNO_EOL = #255; // Extended-Options-List

  // Sub options
  TNOS_TERM_IS = #0;
  TNOS_TERMTYPE_SEND = #1; // Sub option
  TNOS_REPLY = #2;
  TNOS_NAME = #3;
type
//  TIdTelnet = object(TObj)
//  end;
//  PIdTelnet=^TIdTelnet;

  TTnDataAvail = procedure(Buffer: string) of object;

  TTnState = (tnsDATA, tnsIAC, tnsIAC_SB, tnsIAC_WILL, tnsIAC_DO, tnsIAC_WONT,
    tnsIAC_DONT, tnsIAC_SBIAC, tnsIAC_SBDATA, tnsSBDATA_IAC);

  TTelnetCommand = (tncNoLocalEcho, tncLocalEcho, tncEcho);
  TClientEvent = procedure of object;
//  TOnTelnetCommand = procedure(Sender: TComponent; Status: TTelnetCommand) of
//    object;

  TIdTelnetReadThread = object(TIdThread)
  protected
    FClient: PObj;//TIdTelnet;
    FRecvData: string;

    procedure Run; virtual;//override;
  public
     { constructor Create(AClient: TIdTelnet);  }// reintroduce;
  end;
PIdTelnetReadThread=^TIdTelnetReadThread;
function NewIdTelnetReadThread(AClient: {TIdTelnet}PObj):PIdTelnetReadThread;
type

  TIdTelnet = object(TIdTCPClient)
  protected
    fState: TTnState;
    fReply: Char;
    fSentDoDont: string;
    fSentWillWont: string;
    fReceivedDoDont: string;
    fReceivedWillWont: string;
    fTerminal: string;
    FOnDataAvailable: TTnDataAvail;
    fIamTelnet: Boolean;
    FOnDisconnect: TClientEvent;
    FOnConnect: TClientEvent;
//    FOnTelnetCommand: TOnTelnetCommand;

    procedure DoOnDataAvailable;
//    procedure SetOnTelnetCommand(const Value: TOnTelnetCommand);
    property State: TTnState read fState write fState;
    property Reply: Char read fReply write fReply;
    property SentDoDont: string read fSentDoDont write fSentDoDont;
    property SentWillWont: string read fSentWillWont write fSentWillWont;
    property ReceivedDoDont: string read fReceivedDoDont write fReceivedDoDont;
    property ReceivedWillWont: string read fReceivedWillWont write
      fReceivedWillWont;
    property IamTelnet: Boolean read fIamTelnet write fIamTelnet;
    function Negotiate(const Buf: string): string;
    procedure Handle_SB(CurrentSb: Byte; sbData: string; sbCount: Integer);
    procedure SendNegotiationResp(var Resp: string);
    procedure DoTelnetCommand(Status: TTelnetCommand);
  public
    TelnetThread: TIdTelnetReadThread;

     { constructor Create(AOwner: TComponent); override;
     } procedure Connect; virtual;// override;
    procedure Disconnect; virtual;//override;
    procedure SendCh(Ch: Char);
   { published } 
//    property OnTelnetCommand: TOnTelnetCommand read FOnTelnetCommand write
//      SetOnTelnetCommand;
    property OnDataAvailable: TTnDataAvail read FOnDataAvailable write
      FOnDataAvailable;
    property Terminal: string read fTerminal write fTerminal;
    property OnConnect: TClientEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TClientEvent read FOnDisconnect write FOnDisconnect;
  end;
PIdTelnet=^TIdTelnet;
function NewIdTelnet(AOwner: PControl):PIdTelnet;
{ type  MyStupid86104=DWord;
  EIdTelnetError = object(EIdException);
PTelnetReadThread=^dTelnetReadThread; type  MyStupid20258=DWord;
  EIdTelnetClientConnectError = object(EIdTelnetError);
PelnetReadThread=^TelnetReadThread; type  MyStupid27292=DWord;
  EIdTelnetServerOnDataAvailableIsNil = object(EIdTelnetError);
PlnetReadThread=^elnetReadThread; type  MyStupid67165=DWord;
 }
implementation

uses
  IdGlobal, IdResourceStrings;

function NewIdTelnetReadThread(AClient: {TIdTelnet}PObj):PIdTelnetReadThread;
//constructor TIdTelnetReadThread.Create(AClient: TIdTelnet);
begin
New( Result, Create );
with Result^ do
begin
//  inherited Create(False);
  FClient := AClient;
//  FreeOnTerminate := True;
end;
end;

procedure TIdTelnet.SendCh(Ch: Char);
begin
  if Ch <> #13 then
    Write(Ch)
  else
    if (Ch = #13) and (IamTelnet = true) then
    Write(Ch)
  else
    Writeln('');
end;

procedure TIdTelnetReadThread.Run;
begin
//  FRecvData := FClient.Negotiate(FClient.CurrentReadBuffer);
//  Synchronize(FClient.DoOnDataAvailable);
//  FClient.CheckForDisconnect;
end;

//constructor TIdTelnet.Create(AOwner: TComponent);
function NewIdTelnet(AOwner: PControl):PIdTelnet;
begin
  New( Result, Create );
with Result^ do
begin
//  inherited Create(AOwner);
  Port := 23;
  State := tnsData;
  SentDoDont := #0;
  SentWillWont := #0;
  ReceivedDoDont := #0;
  ReceivedWillWont := #0;
  Terminal := 'dumb';
  IamTelnet := False;
end;
end;

procedure TIdTelnet.Disconnect;
begin
{  if TelnetThread <> nil then
  begin
    TelnetThread.Terminate;
  end;
  IAmTelnet := False;
  inherited;
  if Assigned(FOnDisconnect) then
  begin
    OnDisconnect;
  end;}
end;

procedure TIdTelnet.DoOnDataAvailable;
begin
  if assigned(FOnDataAvailable) then
  begin
    OnDataAvailable(TelnetThread.FRecvData);
  end
  else
  begin
//    raise
//      EIdTelnetServerOnDataAvailableIsNil.Create(RSTELNETSRVOnDataAvailableIsNil);
  end;
end;

procedure TIdTelnet.Connect;
begin
//  try
    if Assigned(FOnConnect) then
      OnConnect;
    inherited Connect;
//    if Connected then
//      TelnetThread := TIdTelnetReadThread.Create(Self);
//  except on E: EIdSocketError do
//      raise EIdTelnetClientConnectError.Create(RSTELNETCLIConnectError);
        // translate
//  end;
end;

procedure TIdTelnet.SendNegotiationResp(var Resp: string);
begin
  Write(Resp);
  Resp := '';
end;

procedure TIdTelnet.Handle_SB(CurrentSB: Byte; sbData: string; sbCount:
  Integer);
var
  Resp: string;
begin
  if (sbcount > 0) and (sbdata = TNOS_TERMTYPE_SEND) then
  begin
    if Terminal = '' then
      Terminal := 'dumb';
    Resp := TNC_IAC + TNC_SB + TNO_TERMTYPE + TNOS_TERM_IS + Terminal + TNC_IAC
      + TNC_SE;
    SendNegotiationResp(Resp);
  end;
end;

function TIdTelnet.Negotiate(const Buf: string): string;
var
  LCount: Integer;
  bOffset: Integer;
  nOffset: Integer;
  B: Char;
  nBuf: string;
  sbBuf: string;
  sbCount: Integer;
  CurrentSb: Integer;
  SendBuf: string;
begin
  bOffset := 1;
  nOffset := 0;
  sbCount := 1;
  CurrentSB := 1;
  nbuf := '';
  LCount := Length(Buf);
  while bOffset < LCount + 1 do
  begin
    b := Buf[bOffset];
    case State of
      tnsData:
        if b = TNC_IAC then
        begin
          IamTelnet := True;
          State := tnsIAC;
        end
        else
          nbuf := nbuf + b;

      tnsIAC:
        case b of
          TNC_IAC:
            begin
              State := tnsData;
              inc(nOffset);
              nbuf[nOffset] := TNC_IAC;
            end;
          TNC_WILL:
            State := tnsIAC_WILL;
          TNC_WONT:
            State := tnsIAC_WONT;
          TNC_DONT:
            State := tnsIAC_DONT;
          TNC_DO:
            State := tnsIAC_DO;
          TNC_EOR:
            State := tnsDATA;
          TNC_SB:
            begin
              State := tnsIAC_SB;
              sbCount := 0;
            end;
        else
          State := tnsData;
        end;
      tnsIAC_WILL:
        begin
          case b of
            TNO_ECHO:
              begin
                Reply := TNC_DO;
                DoTelnetCommand(tncNoLocalEcho);
              end;
            TNO_EOR:
              Reply := TNC_DO;
          else
            Reply := TNC_DONT;
          end;

          begin
            SendBuf := TNC_IAC + Reply + b;
            SendNegotiationResp(SendBuf);
            SentDoDont := Reply;
            ReceivedWillWont := TNC_WILL;
          end;
          State := tnsData;
        end;

      tnsIAC_WONT:
        begin
          case b of
            TNO_ECHO:
              begin
                DoTelnetCommand(tncLocalEcho);
                Reply := TNC_DONT;
              end;
            TNO_EOR:
              Reply := TNC_DONT;
          else
            Reply := TNC_DONT;
          end;

          begin
            SendBuf := TNC_IAC + Reply + b;
            SendNegotiationResp(SendBuf);
            SentDoDont := Reply;
            ReceivedWillWont := TNC_WILL;
          end;
          State := tnsData;

        end;
      tnsIAC_DO:
        begin
          case b of
            TNO_ECHO:
              begin
                DoTelnetCommand(tncLocalEcho);
                Reply := TNC_WILL;
              end;
            TNO_TERMTYPE:
              Reply := TNC_WILL;
            TNO_AUTH:
              begin
                Reply := TNC_WONT;
              end;
          else
            Reply := TNC_WONT;
          end;
          begin
            SendBuf := TNC_IAC + Reply + b;
            SendNegotiationResp(SendBuf);
            SentWillWont := Reply;
            ReceivedDoDont := TNC_DO;
          end;
          State := tnsData;
        end;
      tnsIAC_DONT:
        begin
          case b of
            TNO_ECHO:
              begin
                DoTelnetCommand(tncEcho);
                Reply := TNC_WONT;
              end;
            TNO_NAWS:
              Reply := TNC_WONT;
            TNO_AUTH:
              Reply := TNC_WONT
          else
            Reply := TNC_WONT;
          end;

          begin
            SendBuf := TNC_IAC + reply + b;
            SendNegotiationResp(SendBuf);
          end;
          State := tnsData;
        end;

      tnsIAC_SB:
        begin
          if b = TNC_IAC then
            State := tnsIAC_SBIAC
          else
          begin
            CurrentSb := Ord(b);
            sbCount := 0;
            State := tnsIAC_SBDATA;
          end;
        end;
      tnsIAC_SBDATA:
        begin
          if b = TNC_IAC then
            State := tnsSBDATA_IAC
          else
          begin
            inc(sbCount);
            sbBuf := b;
          end;
        end;
      tnsSBDATA_IAC:
        case b of
          TNC_IAC:
            begin
              State := tnsIAC_SBDATA;
              inc(sbCount);
              sbBuf[sbCount] := TNC_IAC;
            end;
          TNC_SE:
            begin
              handle_sb(CurrentSB, sbBuf, sbCount);
              CurrentSB := 0;
              State := tnsData;
            end;
          TNC_SB:
            begin
              handle_sb(CurrentSB, sbBuf, sbCount);
              CurrentSB := 0;
              State := tnsIAC_SB;
            end
        else
          State := tnsDATA;
        end;
    else
      State := tnsData;
    end;
    inc(boffset);
  end;
  Result := nBuf;
end;

//procedure TIdTelnet.SetOnTelnetCommand(const Value: TOnTelnetCommand);
//begin
//  FOnTelnetCommand := Value;
//end;

procedure TIdTelnet.DoTelnetCommand(Status: TTelnetCommand);
begin
//  if assigned(FOnTelnetCommand) then
//    FOnTelnetCommand(Self, Status);
end;

end.
