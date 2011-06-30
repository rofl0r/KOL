unit KOLMHComPort;
//  MHComPort Компонент (MHComPort Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 4-май(may)-2002
//  Дата коррекции (Last correction Date): 15-фев(feb)-2003
//  Версия (Version): 1.12
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Dejan Crnila
//    Alexander Pravdin
//  Новое в (New in):
//  V1.12
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.11
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//
//  V1.1
//  [!] Сообщения (Events) [KOLnMCK]
//  [+] Привязка событий (Assign Events) [MCK]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. Ошибки (Errors)
//  5. Удалить RxOnBuf (Strip RxOnBuf)
//  6. Нормальная иконка (Icon Correct)

interface

uses
 KOL, Windows, Messages;

type

  TPort = string;
  TBaudRate = (brCustom, br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
    br19200, br38400, br56000, br57600, br115200, br128000, br256000);
  TStopBits = (sbOneStopBit, sbOne5StopBits, sbTwoStopBits);
  TDataBits = (dbFive, dbSix, dbSeven, dbEight);
  TParityBits = (prNone, prOdd, prEven, prMark, prSpace);
  TDTRFlowControl = (dtrDisable, dtrEnable, dtrHandshake);
  TRTSFlowControl = (rtsDisable, rtsEnable, rtsHandshake, rtsToggle);
  TFlowControl = (fcHardware, fcSoftware, fcNone, fcCustom);
  TComEvent = (evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR,
    evError, evRLSD, evRx80Full);
  TComEvents = set of TComEvent;
  TComSignal = (csCTS, csDSR, csRing, csRLSD);
  TComSignals = set of TComSignal;
  TComLedSignal = (lsCTS, lsDSR, lsRLSD, lsRing, lsRx, lsTx);
  TComError = (ceFrame, ceRxParity, ceOverrun, ceBreak, ceIO, ceMode, ceRxOver,
    ceTxFull);
  TComErrors = set of TComError;
  TSyncMethod = (smThreadSync, smWindowSync, smNone);
  TStoreType = (stRegistry, stIniFile);
  TStoredProp = (spBasic, spFlowControl, spBuffer, spTimeouts, spParity,
    spOthers);
  TStoredProps = set of TStoredProp;
  TRxCharEvent = procedure(Sender: PObj; Count: Integer) of object;
  TRxBufEvent = procedure(Sender: PObj; Buf:array of Byte;
    Count: Integer) of object;
  TRxStrEvent = procedure(Sender: PObj; Str: string) of object;
  TComErrorEvent = procedure(Sender: PObj; Errors: TComErrors) of object;
  TComSignalEvent = procedure(Sender: PObj; OnOff: Boolean) of object;

  // types for asynchronous calls
  TOperationKind = (okWrite, okRead);
  TAsync = record
    Overlapped: TOverlapped;
    Kind: TOperationKind;
  end;
  PAsync = ^TAsync;

  // TComPort component and asistant classes


  PMHComPort =^TMHComPort;
  TKOLMHComPort = PMHComPort;

  PMHComBuffer=^TMHComBuffer;
  TKOLMHComBuffer=PMHComBuffer;

  PMHComParity=^TMHComParity;
  TKOLMHComParity=PMHComParity;

  PMHComFlowControl=^TMHComFlowControl;
  TKOLMHComFlowControl=PMHComFlowControl;

  PMHComTimeouts=^TMHComTimeouts;
  TKOLMHComTimeouts=PMHComTimeouts;

  PMHComThread=^TMHComThread;
  TKOLMHComThread=PMHComThread;

  TMHComThread = object(TObj)
  private
    FComPort: PMHComPort;
    FStopEvent: THandle;
    FEvents: TComEvents;
    FThread:PThread;
  protected
    procedure DispatchComMsg;
    procedure DoEvents;
    procedure SendEvents;
    procedure Stop;
  public
    function Execute(Sender:PThread): integer; virtual;
    destructor Destroy; virtual;
  end;

  TMHComTimeouts = object(TObj)
  private
    FComPort: PMHComPort;
    FReadInterval: Integer;
    FReadTotalM: Integer;
    FReadTotalC: Integer;
    FWriteTotalM: Integer;
    FWriteTotalC: Integer;
    procedure SetComPort(const AComPort: PMHComPort);
    procedure SetReadInterval(const Value: Integer);
    procedure SetReadTotalM(const Value: Integer);
    procedure SetReadTotalC(const Value: Integer);
    procedure SetWriteTotalM(const Value: Integer);
    procedure SetWriteTotalC(const Value: Integer);
  protected
    procedure AssignTo(Dest: PObj);
  public
    property ComPort: PMHComPort read FComPort;
    property ReadInterval: Integer read FReadInterval write SetReadInterval default -1;
    property ReadTotalMultiplier: Integer read FReadTotalM write SetReadTotalM default 0;
    property ReadTotalConstant: Integer read FReadTotalC write SetReadTotalC default 0;
    property WriteTotalMultiplier: Integer
      read FWriteTotalM write SetWriteTotalM default 100;
    property WriteTotalConstant: Integer
      read FWriteTotalC write SetWriteTotalC default 1000;
  end;

  TMHComFlowControl = object(TObj)
  private
    FComPort: PMHComPort;
    FOutCTSFlow: Boolean;
    FOutDSRFlow: Boolean;
    FControlDTR: TDTRFlowControl;
    FControlRTS: TRTSFlowControl;
    FXonXoffOut: Boolean;
    FXonXoffIn:  Boolean;
    FDSRSensitivity: Boolean;
    FTxContinueOnXoff: Boolean;
    FXonChar: Char;
    FXoffChar: Char;
    procedure SetComPort(const AComPort: PMHComPort);
    procedure SetOutCTSFlow(const Value: Boolean);
    procedure SetOutDSRFlow(const Value: Boolean);
    procedure SetControlDTR(const Value: TDTRFlowControl);
    procedure SetControlRTS(const Value: TRTSFlowControl);
    procedure SetXonXoffOut(const Value: Boolean);
    procedure SetXonXoffIn(const Value: Boolean);
    procedure SetDSRSensitivity(const Value: Boolean);
    procedure SetTxContinueOnXoff(const Value: Boolean);
    procedure SetXonChar(const Value: Char);
    procedure SetXoffChar(const Value: Char);
    procedure SetFlowControl(const Value: TFlowControl);
    function GetFlowControl: TFlowControl;
  protected
    procedure AssignTo(Dest: PObj);
  public
    property ComPort: PMHComPort read FComPort;
    property FlowControl: TFlowControl read GetFlowControl write SetFlowControl stored False;
    property OutCTSFlow: Boolean read FOutCTSFlow write SetOutCTSFlow;
    property OutDSRFlow: Boolean read FOutDSRFlow write SetOutDSRFlow;
    property ControlDTR: TDTRFlowControl read FControlDTR write SetControlDTR;
    property ControlRTS: TRTSFlowControl read FControlRTS write SetControlRTS;
    property XonXoffOut: Boolean read FXonXoffOut write SetXonXoffOut;
    property XonXoffIn:  Boolean read FXonXoffIn write SetXonXoffIn;
    property DSRSensitivity: Boolean
      read FDSRSensitivity write SetDSRSensitivity default False;
    property TxContinueOnXoff: Boolean
      read FTxContinueOnXoff write SetTxContinueOnXoff default False;
    property XonChar: Char read FXonChar write SetXonChar default #17;
    property XoffChar: Char read FXoffChar write SetXoffChar default #19;
  end;

  TMHComParity = object(TObj)
  private
    FComPort: PMHComPort;
    FBits: TParityBits;
    FCheck: Boolean;
    FReplace: Boolean;
    FReplaceChar: Char;
    procedure SetComPort(const AComPort: PMHComPort);
    procedure SetBits(const Value: TParityBits);
    procedure SetCheck(const Value: Boolean);
    procedure SetReplace(const Value: Boolean);
    procedure SetReplaceChar(const Value: Char);
  protected
    procedure AssignTo(Dest: PObj);
  public
    property ComPort: PMHComPort read FComPort;
    property Bits: TParityBits read FBits write SetBits;
    property Check: Boolean read FCheck write SetCheck default False;
    property Replace: Boolean read FReplace write SetReplace default False;
    property ReplaceChar: Char read FReplaceChar write SetReplaceChar default #0;
  end;

  TMHComBuffer = object(TObj)
  private
    FComPort: PMHComPort;
    FInputSize: Integer;
    FOutputSize: Integer;
    procedure SetComPort(const AComPort: PMHComPort);
    procedure SetInputSize(const Value: Integer);
    procedure SetOutputSize(const Value: Integer);
  protected
    procedure AssignTo(Dest: PObj);// override;
  public
    property ComPort: PMHComPort read FComPort;
    property InputSize: Integer read FInputSize write SetInputSize default 1024;
    property OutputSize: Integer read FOutputSize write SetOutputSize default 1024;
  end;

  TMHComPort = object(TObj)
  private
    FEventThread: PMHComThread;
    FThreadCreated: Boolean;
    FHandle: THandle;
    FWindow: THandle;
    FUpdateCount: Integer;
    FConnected: Boolean;
    FBaudRate: TBaudRate;
    FCustomBaudRate: Integer;
    FPort: TPort;
    FStopBits: TStopBits;
    FDataBits: TDataBits;
    FDiscardNull: Boolean;
    FEventChar: Char;
    FEvents: TComEvents;
    FBuffer: PMHComBuffer;
    FParity: PMHComParity;
    FTimeouts: PMHComTimeouts;
    FFlowControl: PMHComFlowControl;
    FSyncMethod: TSyncMethod;
    FStoredProps: TStoredProps;
    FOnRxChar: TRxCharEvent;
    FOnRxBuf: TRxBufEvent;
    FOnTxEmpty: TOnEvent;
    FOnBreak: TOnEvent;
    FOnRing: TOnEvent;
    FOnCTSChange: TComSignalEvent;
    FOnDSRChange: TComSignalEvent;
    FOnRLSDChange: TComSignalEvent;
    FOnError: TComErrorEvent;
    FOnRxFlag: TOnEvent;
    FOnAfterOpen: TOnEvent;
    FOnAfterClose: TOnEvent;
    FOnBeforeOpen: TOnEvent;
    FOnBeforeClose: TOnEvent;
    FOnRx80Full: TOnEvent;
    function GetTriggersOnRxChar: Boolean;
    procedure SetConnected(const Value: Boolean);
    procedure SetBaudRate(const Value: TBaudRate);
    procedure SetCustomBaudRate(const Value: Integer);
    procedure SetPort(const Value: TPort);
    procedure SetStopBits(const Value: TStopBits);
    procedure SetDataBits(const Value: TDataBits);
    procedure SetDiscardNull(const Value: Boolean);
    procedure SetEventChar(const Value: Char);
    procedure SetSyncMethod(const Value: TSyncMethod);
    procedure SetParity(const Value: PMHComParity);
    procedure SetTimeouts(const Value: PMHComTimeouts);
    procedure SetBuffer(const Value: PMHComBuffer);
    procedure SetFlowControl(const Value: PMHComFlowControl);
    procedure CheckSignals(Open2: Boolean);
    procedure WindowMethod(var Message: TMessage);
    procedure CallAfterOpen;
    procedure CallAfterClose;
    procedure CallBeforeOpen;
    procedure CallBeforeClose;
    procedure CallRxChar;
    procedure CallTxEmpty;
    procedure CallBreak;
    procedure CallRing;
    procedure CallRxFlag;
    procedure CallCTSChange;
    procedure CallDSRChange;
    procedure CallError;
    procedure CallRLSDChange;
    procedure CallRx80Full;
  protected
    procedure Loaded;
    procedure DoAfterClose;
    procedure DoAfterOpen;
    procedure DoBeforeClose;
    procedure DoBeforeOpen;
    procedure DoRxChar(Count: Integer);
    procedure DoRxBuf(Buf:array of Byte; Count: Integer);
    procedure DoTxEmpty;
    procedure DoBreak;
    procedure DoRing;
    procedure DoRxFlag;
    procedure DoCTSChange(OnOff: Boolean);
    procedure DoDSRChange(OnOff: Boolean);
    procedure DoError(Errors: TComErrors);
    procedure DoRLSDChange(OnOff: Boolean);
    procedure DoRx80Full;
    procedure CreateHandle; virtual;
    procedure DestroyHandle; virtual;
    procedure ApplyDCB;
    procedure ApplyTimeouts;
    procedure ApplyBuffer;
    procedure SetupComPort; virtual;
  public
    destructor Destroy; virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Open;
    procedure Close;
    function InputCount: Integer;
    function OutputCount: Integer;
    function Signals: TComSignals;
    function StateFlags: TComStateFlags;
    procedure SetDTR(OnOff: Boolean);
    procedure SetRTS(OnOff: Boolean);
    procedure SetXonXoff(OnOff: Boolean);
    procedure SetBreak(OnOff: Boolean);
    procedure ClearBuffer(Input, Output: Boolean);
//    function LastErrors: TComErrors;
    function Write(const Buf; Count: Integer): Integer;
    function WriteStr(Str: string): Integer;
    function Read(var Buf; Count: Integer): Integer;
    function ReadStr(var Str: string; Count: Integer): Integer;
    function WriteAsync(const Buf; Count: Integer;
      var AsyncPtr: PAsync): Integer;
    function WriteStrAsync(Str: string; var AsyncPtr: PAsync): Integer;
    function ReadAsync(var Buf; Count: Integer;
      var AsyncPtr: PAsync): Integer;
    function ReadStrAsync(var Str: string; Count: Integer;
      var AsyncPtr: PAsync): Integer;
    function WaitForAsync(var AsyncPtr: PAsync): Integer;
    function IsAsyncCompleted(AsyncPtr: PAsync): Boolean;
    procedure WaitForEvent(var Events2: TComEvents; Timeout: Integer);
    procedure AbortAllAsync;
    procedure TransmitChar(Ch: Char);
//    procedure RegisterLink(AComLink: PMHComLink);
//    procedure UnRegisterLink(AComLink: PMHComLink);
    property Handle: THandle read FHandle;
    property TriggersOnRxChar: Boolean read GetTriggersOnRxChar;
    property StoredProps: TStoredProps read FStoredProps write FStoredProps;
    property Connected: Boolean read FConnected write SetConnected default False;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property CustomBaudRate: Integer
      read FCustomBaudRate write SetCustomBaudRate;
    property Port: TPort read FPort write SetPort;
    property Parity: PMHComParity read FParity write SetParity;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property DataBits: TDataBits read FDataBits write SetDataBits;
    property DiscardNull: Boolean read FDiscardNull write SetDiscardNull default False;
    property EventChar: Char read FEventChar write SetEventChar default #0;
    property Events: TComEvents read FEvents write FEvents;
    property Buffer: PMHComBuffer read FBuffer write SetBuffer;
    property FlowControl: PMHComFlowControl read FFlowControl write SetFlowControl;
    property Timeouts: PMHComTimeouts read FTimeouts write SetTimeouts;
    property SyncMethod: TSyncMethod read FSyncMethod write SetSyncMethod default smThreadSync;
    property OnAfterOpen: TOnEvent read FOnAfterOpen write FOnAfterOpen;
    property OnAfterClose: TOnEvent read FOnAfterClose write FOnAfterClose;
    property OnBeforeOpen: TOnEvent read FOnBeforeOpen write FOnBeforeOpen;
    property OnBeforeClose: TOnEvent read FOnBeforeClose write FOnBeforeClose;
    property OnRxChar: TRxCharEvent read FOnRxChar write FOnRxChar;
    property OnRxBuf: TRxBufEvent read FOnRxBuf write FOnRxBuf;
    property OnTxEmpty: TOnEvent read FOnTxEmpty write FOnTxEmpty;
    property OnBreak: TOnEvent read FOnBreak write FOnBreak;
    property OnRing: TOnEvent read FOnRing write FOnRing;
    property OnCTSChange: TComSignalEvent read FOnCTSChange write FOnCTSChange;
    property OnDSRChange: TComSignalEvent read FOnDSRChange write FOnDSRChange;
    property OnRLSDChange: TComSignalEvent read FOnRLSDChange write FOnRLSDChange;
    property OnRxFlag: TOnEvent read FOnRxFlag write FOnRxFlag;
    property OnError: TComErrorEvent read FOnError write FOnError;
    property OnRx80Full: TOnEvent read FOnRx80Full write FOnRx80Full;
  end;

const
  // error messages
  ComErrorMessages: array[1..21] of string =
    ('Unable to open com port',
     'WriteFile function failed',
     'ReadFile function failed',
     'Invalid Async parameter',
     'PurgeComm function failed',
     'Unable to get async status',
     'SetCommState function failed',
     'SetCommTimeouts failed',
     'SetupComm function failed',
     'ClearCommError function failed',
     'GetCommModemStatus function failed',
     'EscapeCommFunction function failed',
     'TransmitCommChar function failed',
     'Cannot set SyncMethod while connected',
     'EnumPorts function failed',
     'Failed to store settings',
     'Failed to load settings',
     'Link (un)registration failed',
     'Cannot change led state if ComPort is selected',
     'Cannot wait for event if event thread is created',
     'WaitForEvent method failed');

  // auxilary constants used not defined in windows.pas
  dcb_Binary           = $00000001;
  dcb_Parity           = $00000002;
  dcb_OutxCTSFlow      = $00000004;
  dcb_OutxDSRFlow      = $00000008;
  dcb_DTRControl       = $00000030;
  dcb_DSRSensivity     = $00000040;
  dcb_TxContinueOnXoff = $00000080;
  dcb_OutX             = $00000100;
  dcb_InX              = $00000200;
  dcb_ErrorChar        = $00000400;
  dcb_Null             = $00000800;
  dcb_RTSControl       = $00003000;
  dcb_AbortOnError     = $00004000;

  // com port window message
  CM_COMPORT           = WM_USER + 1;

function NewMHComThread(AComPort: PMHComPort):PMHComThread;
function NewMHComTimeouts:PMHComTimeouts;
function NewMHComFlowControl:PMHComFlowControl;
function NewMHComParity:PMHComParity;
function NewMHComBuffer:PMHComBuffer;
function NewMHComPort( Wnd: PControl):PMHComPort;

implementation

{function WndProcMHFontDialog( Control: PControl; var Msg: TMsg; var Rslt: Integer ) : Boolean;
begin
  Result:=False;
  if Msg.message=HelpMessageIndex then
  begin
    if Assigned( MHFontDialogNow.FOnHelp ) then
      MHFontDialogNow.FOnHelp( @MHFontDialogNow);
    Rslt:=0;
    Result:=True;
  end;
end;
 }

function EventsToInt(const Events: TComEvents): Integer;
begin
  Result := 0;
  if evRxChar in Events then
    Result := Result or EV_RXCHAR;
  if evRxFlag in Events then
    Result := Result or EV_RXFLAG;
  if evTxEmpty in Events then
    Result := Result or EV_TXEMPTY;
  if evRing in Events then
    Result := Result or EV_RING;
  if evCTS in Events then
    Result := Result or EV_CTS;
  if evDSR in Events then
    Result := Result or EV_DSR;
  if evRLSD in Events then
    Result := Result or EV_RLSD;
  if evError in Events then
    Result := Result or EV_ERR;
  if evBreak in Events then
    Result := Result or EV_BREAK;
  if evRx80Full in Events then
    Result := Result or EV_RX80FULL;
end;

function IntToEvents(Mask: Integer): TComEvents;
begin
  Result := [];
  if (EV_RXCHAR and Mask) <> 0 then
    Result := Result + [evRxChar];
  if (EV_TXEMPTY and Mask) <> 0 then
    Result := Result + [evTxEmpty];
  if (EV_BREAK and Mask) <> 0 then
    Result := Result + [evBreak];
  if (EV_RING and Mask) <> 0 then
    Result := Result + [evRing];
  if (EV_CTS and Mask) <> 0 then
    Result := Result + [evCTS];
  if (EV_DSR and Mask) <> 0 then
    Result := Result + [evDSR];
  if (EV_RXFLAG and Mask) <> 0 then
    Result := Result + [evRxFlag];
  if (EV_RLSD and Mask) <> 0 then
    Result := Result + [evRLSD];
  if (EV_ERR and Mask) <> 0 then
    Result := Result + [evError];
  if (EV_RX80FULL and Mask) <> 0 then
    Result := Result + [evRx80Full];
end;
 

procedure InitAsync(var AsyncPtr: PAsync);
begin
  New(AsyncPtr);
  with AsyncPtr^ do
  begin
    FillChar(Overlapped, SizeOf(TOverlapped), 0);
    Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  end;
end;

procedure DoneAsync(var AsyncPtr: PAsync);
begin
  with AsyncPtr^ do
    CloseHandle(Overlapped.hEvent);
  Dispose(AsyncPtr);
  AsyncPtr := nil;
end;

function NewMHComThread(AComPort: PMHComPort):PMHComThread;
begin
  New(Result, Create);
  Result.FStopEvent := CreateEvent(nil, True, False, nil);
  Result.FComPort := AComPort;
  Result.FThread:=NewThreadEx(Result.Execute);
  // select which events are monitored
  SetCommMask(Result.FComPort.Handle, EventsToInt(Result.FComPort.Events));
  // execute thread
//  Result.Resume;
end;


// destroy thread
destructor TMHComThread.Destroy;
begin
  Stop;
  FThread.Resume;
  FThread.WaitFor;
  FThread.Free;
  inherited;
end;

{function MHComThreadExecute(Sender:PMHComThread):Integer;
var
  EventHandles: array[0..1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans, Mask: DWORD;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  EventHandles[0] := PMHComThread(Sender).FStopEvent;
  EventHandles[1] := Overlapped.hEvent;
  repeat
    // wait for event to occur on serial port
    WaitCommEvent(PMHComThread(Sender).FComPort.Handle, Mask, @Overlapped);
    Signaled := WaitForMultipleObjects(2, @EventHandles, False, INFINITE);
    // if event occurs, dispatch it
    if (Signaled = WAIT_OBJECT_0 + 1)
      and GetOverlappedResult(PMHComThread(Sender).FComPort.Handle, Overlapped, BytesTrans, False)
    then
    begin
      PMHComThread(Sender).FEvents := IntToEvents(Mask);
      PMHComThread(Sender).DispatchComMsg;
    end;
  until Signaled <> (WAIT_OBJECT_0 + 1);
  // clear buffers
  SetCommMask(PMHComThread(Sender).FComPort.Handle, 0);
  PurgeComm(PMHComThread(Sender).FComPort.Handle, PURGE_TXCLEAR or PURGE_RXCLEAR);
  CloseHandle(Overlapped.hEvent);
  CloseHandle(PMHComThread(Sender).FStopEvent);
end;
 }
// thread action
function TMHComThread.Execute(Sender:PThread):Integer;
var
  EventHandles: array[0..1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans, Mask: DWORD;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  EventHandles[0] := FStopEvent;
  EventHandles[1] := Overlapped.hEvent;
  repeat
    // wait for event to occur on serial port
    WaitCommEvent(FComPort.Handle, Mask, @Overlapped);
    Signaled := WaitForMultipleObjects(2, @EventHandles, False, INFINITE);
    // if event occurs, dispatch it
    if (Signaled = WAIT_OBJECT_0 + 1)
      and GetOverlappedResult(FComPort.Handle, Overlapped, BytesTrans, False)
    then
    begin
      FEvents := IntToEvents(Mask);
      DispatchComMsg;
    end;
  until Signaled <> (WAIT_OBJECT_0 + 1);
  // clear buffers
  SetCommMask(FComPort.Handle, 0);
  PurgeComm(FComPort.Handle, PURGE_TXCLEAR or PURGE_RXCLEAR);
  CloseHandle(Overlapped.hEvent);
  CloseHandle(FStopEvent);
end;

// stop thread
procedure TMHComThread.Stop;
begin
  SetEvent(FStopEvent);
  Sleep(0);
end;

// dispatch events
procedure TMHComThread.DispatchComMsg;
begin

  case FComPort.SyncMethod of
    smThreadSync:{ Synchronize}(DoEvents); // call events in main thread
    smWindowSync: SendEvents; // call events in thread that opened the port
    smNone:       DoEvents; // call events inside monitoring thread
  end;

end;

// send events to TCustomComPort component using window message
procedure TMHComThread.SendEvents;
begin
  if evRxChar in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RXCHAR, 0);
  if evTxEmpty in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_TXEMPTY, 0);
  if evBreak in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_BREAK, 0);
  if evRing in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RING, 0);
  if evCTS in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_CTS, 0);
  if evDSR in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_DSR, 0);
  if evRxFlag in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RXFLAG, 0);
  if evRing in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RLSD, 0);
  if evError in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_ERR, 0);
  if evRx80Full in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RX80FULL, 0);
end;

// call events
procedure TMHComThread.DoEvents;
begin
  if evRxChar in FEvents then
    FComPort.CallRxChar;
  if evTxEmpty in FEvents then
    FComPort.CallTxEmpty;
  if evBreak in FEvents then
    FComPort.CallBreak;
  if evRing in FEvents then
    FComPort.CallRing;
  if evCTS in FEvents then
    FComPort.CallCTSChange;
  if evDSR in FEvents then
    FComPort.CallDSRChange;
  if evRxFlag in FEvents then
    FComPort.CallRxFlag;
  if evRLSD in FEvents then
    FComPort.CallRLSDChange;
  if evError in FEvents then
    FComPort.CallError;
  if evRx80Full in FEvents then
    FComPort.CallRx80Full;
end;


function NewMHComTimeouts:PMHComTimeouts;
begin
  New(Result, Create);
  Result.FReadInterval := -1;
  Result.FWriteTotalM := 100;
  Result.FWriteTotalC := 1000;
end;

// copy properties to other class
procedure TMHComTimeouts.AssignTo(Dest: PObj);
begin
  if TMHComTimeouts.AncestorOfObject(Dest) then
  begin
    with PMHComTimeouts(Dest)^ do
    begin
      FReadInterval := Self.ReadInterval;
      FReadTotalM   := Self.ReadTotalMultiplier;
      FReadTotalC   := Self.ReadTotalConstant;
      FWriteTotalM  := Self.WriteTotalMultiplier;
      FWriteTotalC  := Self.WriteTotalConstant;
    end
  end
  else
    inherited;
end;

// select TCustomComPort to own this class
procedure TMHComTimeouts.SetComPort(const AComPort: PMHComPort);
begin
  FComPort := AComPort;
end;

// set read interval
procedure TMHComTimeouts.SetReadInterval(const Value: Integer);
begin
  if Value <> FReadInterval then
  begin
    FReadInterval := Value;
    // if possible, apply the changes
    if FComPort <> nil then
      FComPort.ApplyTimeouts;
  end;
end;

// set read total constant
procedure TMHComTimeouts.SetReadTotalC(const Value: Integer);
begin
  if Value <> FReadTotalC then
  begin
    FReadTotalC := Value;
    if FComPort <> nil then
      FComPort.ApplyTimeouts;
  end;
end;

// set read total multiplier
procedure TMHComTimeouts.SetReadTotalM(const Value: Integer);
begin
  if Value <> FReadTotalM then
  begin
    FReadTotalM := Value;
    if FComPort <> nil then
      FComPort.ApplyTimeouts;
  end;
end;

// set write total constant
procedure TMHComTimeouts.SetWriteTotalC(const Value: Integer);
begin
  if Value <> FWriteTotalC then
  begin
    FWriteTotalC := Value;
    if FComPort <> nil then
      FComPort.ApplyTimeouts;
  end;
end;

// set write total multiplier
procedure TMHComTimeouts.SetWriteTotalM(const Value: Integer);
begin
  if Value <> FWriteTotalM then
  begin
    FWriteTotalM := Value;
    if FComPort <> nil then
      FComPort.ApplyTimeouts;
  end;
end;

 
function NewMHComFlowControl:PMHComFlowControl;
begin
  New(Result, Create);
  Result.FXonChar := #17;
  Result.FXoffChar := #19;
end;



// copy properties to other class
procedure TMHComFlowControl.AssignTo(Dest: PObj);
begin
  if TMHComFlowControl.AncestorOfObject(Dest) then
  begin
    with PMHComFlowControl(Dest)^ do
    begin
      FOutCTSFlow       := Self.OutCTSFlow;
      FOutDSRFlow       := Self.OutDSRFlow;
      FControlDTR       := Self.ControlDTR;
      FControlRTS       := Self.ControlRTS;
      FXonXoffOut       := Self.XonXoffOut;
      FXonXoffIn        := Self.XonXoffIn;
      FTxContinueOnXoff := Self.TxContinueOnXoff;
      FDSRSensitivity   := Self.DSRSensitivity;
      FXonChar          := Self.XonChar;
      FXoffChar         := Self.XoffChar;
    end
  end
  else
    inherited;
end;

// select TCustomComPort to own this class
procedure TMHComFlowControl.SetComPort(const AComPort: PMHComPort);
begin
  FComPort := AComPort;
end;

// set input flow control for DTR (data-terminal-ready)
procedure TMHComFlowControl.SetControlDTR(const Value: TDTRFlowControl);
begin
  if Value <> FControlDTR then
  begin
    FControlDTR := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set input flow control for RTS (request-to-send)
procedure TMHComFlowControl.SetControlRTS(const Value: TRTSFlowControl);
begin
  if Value <> FControlRTS then
  begin
    FControlRTS := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set ouput flow control for CTS (clear-to-send)
procedure TMHComFlowControl.SetOutCTSFlow(const Value: Boolean);
begin
  if Value <> FOutCTSFlow then
  begin
    FOutCTSFlow := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set output flow control for DSR (data-set-ready)
procedure TMHComFlowControl.SetOutDSRFlow(const Value: Boolean);
begin
  if Value <> FOutDSRFlow then
  begin
    FOutDSRFlow := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set software input flow control
procedure TMHComFlowControl.SetXonXoffIn(const Value: Boolean);
begin
  if Value <> FXonXoffIn then
  begin
    FXonXoffIn := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set software ouput flow control
procedure TMHComFlowControl.SetXonXoffOut(const Value: Boolean);
begin
  if Value <> FXonXoffOut then
  begin
    FXonXoffOut := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set DSR sensitivity
procedure TMHComFlowControl.SetDSRSensitivity(const Value: Boolean);
begin
  if Value <> FDSRSensitivity then
  begin
    FDSRSensitivity := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set transfer continue when Xoff is sent
procedure TMHComFlowControl.SetTxContinueOnXoff(const Value: Boolean);
begin
  if Value <> FTxContinueOnXoff then
  begin
    FTxContinueOnXoff := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set Xon char
procedure TMHComFlowControl.SetXonChar(const Value: Char);
begin
  if Value <> FXonChar then
  begin
    FXonChar := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set Xoff char
procedure TMHComFlowControl.SetXoffChar(const Value: Char);
begin
  if Value <> FXoffChar then
  begin
    FXoffChar := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// get common flow control
function TMHComFlowControl.GetFlowControl: TFlowControl;
begin
  if (FControlRTS = rtsHandshake) and (FOutCTSFlow)
    and (not FXonXoffIn) and (not FXonXoffOut)
  then
    Result := fcHardware
  else
    if (FControlRTS = rtsDisable) and (not FOutCTSFlow)
      and (FXonXoffIn) and (FXonXoffOut)
    then
      Result := fcSoftware
    else
      if (FControlRTS = rtsDisable) and (not FOutCTSFlow)
        and (not FXonXoffIn) and (not FXonXoffOut)
      then
        Result := fcNone
      else
        Result := fcCustom;
end;

// set common flow control
procedure TMHComFlowControl.SetFlowControl(const Value: TFlowControl);
begin
  if Value <> fcCustom then
  begin
    FControlRTS := rtsDisable;
    FOutCTSFlow := False;
    FXonXoffIn := False;
    FXonXoffOut := False;
    case Value of
      fcHardware:
      begin
        FControlRTS := rtsHandshake;
        FOutCTSFlow := True;
      end;
      fcSoftware:
      begin
        FXonXoffIn := True;
        FXonXoffOut := True;
      end;
    end;
  end;
  if FComPort <> nil then
    FComPort.ApplyDCB;
end;


function NewMHComParity:PMHComParity;
begin
  New(Result, Create);
  Result.FBits := prNone;
end;

// copy properties to other class
procedure TMHComParity.AssignTo(Dest:PObj);
begin
  if TMHComParity.AncestorOfObject(Dest) then
  begin
    with PMHComParity(Dest)^ do
    begin
      FBits        := Self.Bits;
      FCheck       := Self.Check;
      FReplace     := Self.Replace;
      FReplaceChar := Self.ReplaceChar;
    end
  end
  else
    inherited;
end;

// select TCustomComPort to own this class
procedure TMHComParity.SetComPort(const AComPort: PMHComPort);
begin
  FComPort := AComPort;
end;

// set parity bits
procedure TMHComParity.SetBits(const Value: TParityBits);
begin
  if Value <> FBits then
  begin
    FBits := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set check parity
procedure TMHComParity.SetCheck(const Value: Boolean);
begin
  if Value <> FCheck then
  begin
    FCheck := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set replace on parity error
procedure TMHComParity.SetReplace(const Value: Boolean);
begin
  if Value <> FReplace then
  begin
    FReplace := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;

// set replace char
procedure TMHComParity.SetReplaceChar(const Value: Char);
begin
  if Value <> FReplaceChar then
  begin
    FReplaceChar := Value;
    if FComPort <> nil then
      FComPort.ApplyDCB;
  end;
end;


function NewMHComBuffer:PMHComBuffer;
begin
  New(Result, Create);
  Result.FInputSize := 1024;
  Result.FOutputSize := 1024;
end;

// copy properties to other class
procedure TMHComBuffer.AssignTo(Dest: PObj);
begin
  if TMHComBuffer.AncestorOfObject(Dest) then
  begin
    with PMHComBuffer(Dest)^ do
    begin
      FOutputSize  := Self.OutputSize;
      FInputSize   := Self.InputSize;
    end
  end
  else
    inherited;
end;

// select TCustomComPort to own this class
procedure TMHComBuffer.SetComPort(const AComPort: PMHComPort);
begin
  FComPort := AComPort;
end;

// set input size
procedure TMHComBuffer.SetInputSize(const Value: Integer);
begin
  if Value <> FInputSize then
  begin
    FInputSize := Value;
    if (FInputSize mod 2) = 1 then
      Dec(FInputSize);
    if FComPort <> nil then
      FComPort.ApplyBuffer;
  end;
end;

// set ouput size
procedure TMHComBuffer.SetOutputSize(const Value: Integer);
begin
  if Value <> FOutputSize then
  begin
    FOutputSize := Value;
    if (FOutputSize mod 2) = 1 then
      Dec(FOutputSize);
    if FComPort <> nil then
      FComPort.ApplyBuffer;
  end;
end;

function NewMHComPort(Wnd: PControl):PMHComPort;
begin
  New(Result, Create);
//  Result.FLinks := TList.Create;
  Result.FBaudRate := br9600;
  Result.FCustomBaudRate := 9600;
  Result.FPort := 'COM1';
  Result.FStopBits := sbOneStopBit;
  Result.FDataBits := dbEight;
  Result.FEvents := [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full];
  Result.FHandle := INVALID_HANDLE_VALUE;
  Result.FStoredProps := [spBasic];
  Result.FParity := NewMHComParity;
  Result.FParity.SetComPort(Result);
  Result.FFlowControl := NewMHComFlowControl;
  Result.FFlowControl.SetComPort(Result);
  Result.FTimeouts := NewMHComTimeouts;
  Result.FTimeouts.SetComPort(Result);
  Result.FBuffer := NewMHComBuffer;
  Result.FBuffer.SetComPort(Result);
end;



// destroy component
destructor TMHComPort.Destroy;
begin
  Close;
  FBuffer.Free;
  FFlowControl.Free;
  FTimeouts.Free;
  FParity.Free;
//  FLinks.Free;
  inherited;
end;

// create handle to serial port
procedure TMHComPort.CreateHandle;
var
  pc:PChar;
begin
  pc:=PChar('\\.\'+FPort);
  FHandle := CreateFile(pc,//PChar('\\.\' + FPort),
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
    FILE_FLAG_OVERLAPPED,
    0);


//if FHandle = INVALID_HANDLE_VALUE then
//  ShowMessage('!!!');
{    raise EComPort.Create(CError_OpenFailed, GetLastError);
}
end;

// destroy serial port handle
procedure TMHComPort.DestroyHandle;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
end;

procedure TMHComPort.Loaded;
begin
//  inherited Loaded;
  // open port if Connected is True at design-time
  if (FConnected) then
  begin
    FConnected := False;


 try

      Open;

    except
//      on E:Exception do
//        Application.ShowException(E);
    end;

  end;
end;

// call events which have been dispatch using window message
procedure TMHComPort.WindowMethod(var Message: TMessage);
begin
  with Message do
    if Msg = CM_COMPORT then
    begin
      case wParam of
        EV_RXCHAR:   CallRxChar;
        EV_TXEMPTY:  CallTxEmpty;
        EV_BREAK:    CallBreak;
        EV_RING:     CallRing;
        EV_CTS:      CallCTSChange;
        EV_DSR:      CallDSRChange;
        EV_RXFLAG:   CallRxFlag;
        EV_RLSD:     CallRLSDChange;
        EV_ERR:      CallError;
        EV_RX80FULL: CallRx80Full;
      end
    end
    else
      Result := DefWindowProc(FWindow, Msg, wParam, lParam);
end;

// prevent from applying changes at runtime
procedure TMHComPort.BeginUpdate;
begin
  FUpdateCount := FUpdateCount + 1;
end;

// apply the changes made since BeginUpdate call
procedure TMHComPort.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    FUpdateCount := FUpdateCount - 1;
    if FUpdateCount = 0 then
      SetupComPort;
  end;
end;

// open port
procedure TMHComPort.Open;
begin
  // if already connected, do nothing
  if (not FConnected) then
  begin
    CallBeforeOpen;
    // open port
    CreateHandle;
    FConnected := True;
    try
      // initialize port
      SetupComPort;
    except
      // error occured during initialization, destroy handle
      DestroyHandle;
      FConnected := False;
      raise;
    end;
    // if at least one event is set, create special thread to monitor port
    if (FEvents = []) then
      FThreadCreated := False
    else
    begin
//      if (FSyncMethod = smWindowSync) then
//        FWindow := AllocateHWnd(WindowMethod);
      FEventThread := NewMHComThread(@Self);
//      FEventThread.OnExecute:=TOnThreadExecute(MHComThreadExecute(FEventThread));
      FEventThread.FThread.Resume;
      //TComThread.Create(Self);
      FThreadCreated := True;
    end;
    // port is succesfully opened, do any additional initialization
    CallAfterOpen;
  end;
end;

// close port
procedure TMHComPort.Close;
begin
  // if already closed, do nothing
  if (FConnected) then
  begin
    CallBeforeClose;
    // abort all pending operations
    AbortAllAsync;
    // stop monitoring for events
    if FThreadCreated then
    begin
      FEventThread.Free;
      FThreadCreated := False;
//      if FSyncMethod = smWindowSync then
//        DeallocateHWnd(FWindow);
    end;
    // close port
    DestroyHandle;
    FConnected := False;
    // port is closed, do any additional finalization
    CallAfterClose;
  end;
end;

// apply port properties
procedure TMHComPort.ApplyDCB;
const
  CParityBits: array[TParityBits] of Integer =
    (NOPARITY, ODDPARITY, EVENPARITY, MARKPARITY, SPACEPARITY);
  CStopBits: array[TStopBits] of Integer =
    (ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS);
  CBaudRate: array[TBaudRate] of Integer =
    (0, CBR_110, CBR_300, CBR_600, CBR_1200, CBR_2400, CBR_4800, CBR_9600,
     CBR_14400, CBR_19200, CBR_38400, CBR_56000, CBR_57600, CBR_115200,
     CBR_128000, CBR_256000);
  CDataBits: array[TDataBits] of Integer = (5, 6, 7, 8);
  CControlRTS: array[TRTSFlowControl] of Integer =
    (RTS_CONTROL_DISABLE shl 12,
     RTS_CONTROL_ENABLE shl 12,
     RTS_CONTROL_HANDSHAKE shl 12,
     RTS_CONTROL_TOGGLE shl 12);
  CControlDTR: array[TDTRFlowControl] of Integer =
    (DTR_CONTROL_DISABLE shl 4,
     DTR_CONTROL_ENABLE shl 4,
     DTR_CONTROL_HANDSHAKE shl 4);

var
  DCB: TDCB;

begin
  // if not connected or inside BeginUpdate/EndUpdate block, do nothing
  if (FConnected) and (FUpdateCount = 0) then
  begin
    DCB.DCBlength := SizeOf(TDCB);
    DCB.XonLim := FBuffer.InputSize div 4;
    DCB.XoffLim := DCB.XonLim;
    DCB.EvtChar := Char(FEventChar);

    DCB.Flags := dcb_Binary;
    if FDiscardNull then
      DCB.Flags := DCB.Flags or dcb_Null;

    with FFlowControl^ do
    begin
      DCB.XonChar := XonChar;
      DCB.XoffChar := XoffChar;
      if OutCTSFlow then
        DCB.Flags := DCB.Flags or dcb_OutxCTSFlow;
      if OutDSRFlow then
        DCB.Flags := DCB.Flags or dcb_OutxDSRFlow;
      DCB.Flags := DCB.Flags or CControlDTR[ControlDTR]
        or CControlRTS[ControlRTS];
      if XonXoffOut then
        DCB.Flags := DCB.Flags or dcb_OutX;
      if XonXoffIn then
        DCB.Flags := DCB.Flags or dcb_InX;
      if DSRSensitivity then
        DCB.Flags := DCB.Flags or dcb_DSRSensivity;
      if TxContinueOnXoff then
        DCB.Flags := DCB.Flags or dcb_TxContinueOnXoff;
    end;

    DCB.Parity := CParityBits[FParity.Bits];
    DCB.StopBits := CStopBits[FStopBits];
    if FBaudRate <> brCustom then
      DCB.BaudRate := CBaudRate[FBaudRate]
    else
      DCB.BaudRate := FCustomBaudRate;
    DCB.ByteSize := CDataBits[FDataBits];

    if FParity.Check then
    begin
      DCB.Flags := DCB.Flags or dcb_Parity;
      if FParity.Replace then
      begin
        DCB.Flags := DCB.Flags or dcb_ErrorChar;
        DCB.ErrorChar := Char(FParity.ReplaceChar);
      end;
    end;

    // apply settings

    SetCommState(FHandle, DCB);// then
//      ShowMessage('!@!!');
//      raise EComPort.Create(CError_SetStateFailed, GetLastError);

  end;
end;

// apply timeout properties
procedure TMHComPort.ApplyTimeouts;
var
  Timeouts2: TCommTimeouts;

  function GetTOValue(const Value: Integer): DWORD;
  begin
    if Value = -1 then
      Result := MAXDWORD
    else
      Result := Value;
  end;

begin
  // if not connected or inside BeginUpdate/EndUpdate block, do nothing
  if (FConnected) and (FUpdateCount = 0) then
  begin
    Timeouts2.ReadIntervalTimeout := GetTOValue(FTimeouts.ReadInterval);
    Timeouts2.ReadTotalTimeoutMultiplier := GetTOValue(FTimeouts.ReadTotalMultiplier);
    Timeouts2.ReadTotalTimeoutConstant := GetTOValue(FTimeouts.ReadTotalConstant);
    Timeouts2.WriteTotalTimeoutMultiplier := GetTOValue(FTimeouts.WriteTotalMultiplier);
    Timeouts2.WriteTotalTimeoutConstant := GetTOValue(FTimeouts.WriteTotalConstant);

    // apply settings

   { if not}
    SetCommTimeouts(FHandle, Timeouts2);
{     then
      raise EComPort.Create(CError_TimeoutsFailed, GetLastError);
 }
  end;
end;

// apply buffers
procedure TMHComPort.ApplyBuffer;
begin
  // if not connected or inside BeginUpdate/EndUpdate block, do nothing

  if (FConnected) and (FUpdateCount = 0) then
    //apply settings
 {   if not}
    SetupComm(FHandle, FBuffer.InputSize, FBuffer.OutputSize);
{     then
      raise EComPort.Create(CError_SetupComFailed, GetLastError);
 }
end;

// initialize port
procedure TMHComPort.SetupComPort;
begin
  ApplyBuffer;
  ApplyDCB;
  ApplyTimeouts;
end;

// get number of bytes in input buffer
function TMHComPort.InputCount: Integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin

{  if not}
  ClearCommError(FHandle, Errors, @ComStat);
{  then
    raise EComPort.Create(CError_ClearComFailed, GetLastError);
 }
  Result := ComStat.cbInQue;
end;

// get number of bytes in output buffer
function TMHComPort.OutputCount: Integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin

//  if not
  ClearCommError(FHandle, Errors, @ComStat);
  // then
//    raise EComPort.Create(CError_ClearComFailed, GetLastError);

  Result := ComStat.cbOutQue;
end;

// get signals which are in high state
function TMHComPort.Signals: TComSignals;
var
  Status: DWORD;
begin

//  if not
  GetCommModemStatus(FHandle, Status);
//  then
//    raise EComPort.Create(CError_ModemStatFailed, GetLastError);

  Result := [];

  if (MS_CTS_ON and Status) <> 0 then
    Result := Result + [csCTS];
  if (MS_DSR_ON and Status) <> 0 then
    Result := Result + [csDSR];
  if (MS_RING_ON and Status) <> 0 then
    Result := Result + [csRing];
  if (MS_RLSD_ON and Status) <> 0 then
    Result := Result + [csRLSD];
end;

// get port state flags
function TMHComPort.StateFlags: TComStateFlags;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  (*
  if not*)
  ClearCommError(FHandle, Errors, @ComStat);
(*  then
    raise EComPort.Create(CError_ClearComFailed, GetLastError);
   *) 
  Result := ComStat.Flags;
end;

// set hardware line break
procedure TMHComPort.SetBreak(OnOff: Boolean);
var
  Act: Integer;
begin
  if OnOff then
    Act := Windows.SETBREAK
  else
    Act := Windows.CLRBREAK;

  (*
  if not  *)
  EscapeCommFunction(FHandle, Act);
(*  then
    raise EComPort.Create(CError_EscapeComFailed, GetLastError);
   *)
end;

// set DTR signal
procedure TMHComPort.SetDTR(OnOff: Boolean);
var
  Act: DWORD;
begin
  if OnOff then
    Act := Windows.SETDTR
  else
    Act := Windows.CLRDTR;

  (*
  if not*)
  EscapeCommFunction(FHandle, Act)
(*   then
    raise EComPort.Create(CError_EscapeComFailed, GetLastError);
   *) 
end;

// set RTS signals
procedure TMHComPort.SetRTS(OnOff: Boolean);
var
  Act: DWORD;
begin
  if OnOff then
    Act := Windows.SETRTS
  else
    Act := Windows.CLRRTS;

  (*
  if not*)
  EscapeCommFunction(FHandle, Act);
  (* then
    raise EComPort.Create(CError_EscapeComFailed, GetLastError);
   *) 
end;

// set XonXoff state
procedure TMHComPort.SetXonXoff(OnOff: Boolean);
var
  Act: DWORD;
begin
  if OnOff then
    Act := Windows.SETXON
  else
    Act := Windows.SETXOFF;

  {
  if not }
  EscapeCommFunction(FHandle, Act);
  {then
    raise EComPort.Create(CError_EscapeComFailed, GetLastError);
   }
end;

// clear input and/or output buffer
procedure TMHComPort.ClearBuffer(Input, Output: Boolean);
var
  Flag: DWORD;
begin
  Flag := 0;
  if Input then
    Flag := PURGE_RXCLEAR;
  if Output then
    Flag := Flag or PURGE_TXCLEAR;

  {
  if not}
  PurgeComm(FHandle, Flag);
  {then
    raise EComPort.Create(CError_PurgeFailed, GetLastError);
   }
end;

// return last errors on port
{function TMHComPort.LastErrors: TComErrors;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  if not ClearCommError(FHandle, Errors, @ComStat) then
    raise EComPort.Create(CError_ClearComFailed, GetLastError);
  Result := [];

  if (CE_FRAME and Errors) <> 0 then
    Result := Result + [ceFrame];
  if ((CE_RXPARITY and Errors) <> 0) and FParity.Check then // get around a bug
    Result := Result + [ceRxParity];
  if (CE_OVERRUN and Errors) <> 0 then
    Result := Result + [ceOverrun];
  if (CE_RXOVER and Errors) <> 0 then
    Result := Result + [ceRxOver];
  if (CE_TXFULL and Errors) <> 0 then
    Result := Result + [ceTxFull];
  if (CE_BREAK and Errors) <> 0 then
    Result := Result + [ceBreak];
  if (CE_IOE and Errors) <> 0 then
    Result := Result + [ceIO];
  if (CE_MODE and Errors) <> 0 then
    Result := Result + [ceMode];
end;
 }
// perform asynchronous write operation
function TMHComPort.WriteAsync(const Buf; Count: Integer; var AsyncPtr: PAsync): Integer;
var
  Success: Boolean;
  BytesTrans: DWORD;
begin
  AsyncPtr^.Kind := okWrite;

  Success := WriteFile(FHandle, Buf, Count, BytesTrans, @AsyncPtr^.Overlapped)
    or (GetLastError = ERROR_IO_PENDING);

  (*
  if not Success then
    raise EComPort.Create(CError_WriteFailed, GetLastError);
   *)

//  SendSignals(lsTx, True);
  Result := BytesTrans;
end;

// perform synchronous write operation
function TMHComPort.Write(const Buf; Count: Integer): Integer;
var
  AsyncPtr: PAsync;
begin
  InitAsync(AsyncPtr);
  try
    WriteAsync(Buf, Count, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
  finally
    DoneAsync(AsyncPtr);
  end;
end;

// perform asynchronous write operation
function TMHComPort.WriteStrAsync(Str: string; var AsyncPtr: PAsync): Integer;
var
  Success: Boolean;
  BytesTrans: DWORD;
begin
  AsyncPtr^.Kind := okWrite;

  Success := WriteFile(FHandle, Str[1], Length(Str), BytesTrans, @AsyncPtr^.Overlapped)
    or (GetLastError = ERROR_IO_PENDING);

  (*
  if not Success then
    raise EComPort.Create(CError_WriteFailed, GetLastError);
   *)

//  SendSignals(lsTx, True);
  Result := BytesTrans;
end;

// perform synchronous write operation
function TMHComPort.WriteStr(Str: string): Integer;
var
  AsyncPtr: PAsync;
begin
  InitAsync(AsyncPtr);
  try
    WriteStrAsync(Str, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
  finally
    DoneAsync(AsyncPtr);
  end;
end;

// perform asynchronous read operation
function TMHComPort.ReadAsync(var Buf; Count: Integer; var AsyncPtr: PAsync): Integer;
var
  Success: Boolean;
  BytesTrans: DWORD;
begin
  AsyncPtr^.Kind := okRead;

  Success := ReadFile(FHandle, Buf, Count, BytesTrans, @AsyncPtr^.Overlapped)
    or (GetLastError = ERROR_IO_PENDING);

  (*
  if not Success then
    raise EComPort.Create(CError_ReadFailed, GetLastError);
  *)  

  Result := BytesTrans;
end;

// perform synchronous read operation
function TMHComPort.Read(var Buf; Count: Integer): Integer;
var
  AsyncPtr: PAsync;
begin
  InitAsync(AsyncPtr);
  try
    ReadAsync(Buf, Count, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
  finally
    DoneAsync(AsyncPtr);
  end;
end;

// perform asynchronous read operation
function TMHComPort.ReadStrAsync(var Str: string; Count: Integer; var AsyncPtr: PAsync): Integer;
var
  Success: Boolean;
  BytesTrans: DWORD;
begin
  AsyncPtr^.Kind := okRead;
  SetLength(Str, Count);

  Success := ReadFile(FHandle, Str[1], Count, BytesTrans, @AsyncPtr^.Overlapped)
    or (GetLastError = ERROR_IO_PENDING);

  (*
  if not Success then
    raise EComPort.Create(CError_ReadFailed, GetLastError);
   *) 

  Result := BytesTrans;
end;

// perform synchronous read operation
function TMHComPort.ReadStr(var Str: string; Count: Integer): Integer;
var
  AsyncPtr: PAsync;
begin
  InitAsync(AsyncPtr);
  try
    ReadStrAsync(Str, Count, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
    SetLength(Str, Result);
  finally
    DoneAsync(AsyncPtr);
  end;
end;

function ErrorCode(AsyncPtr: PAsync): Integer;
begin
  Result := 0;
 { case AsyncPtr^.Kind of
    okWrite: Result := CError_WriteFailed;
    okRead:  Result := CError_ReadFailed;
  end;}
end;

// wait for asynchronous operation to end
function TMHComPort.WaitForAsync(var AsyncPtr: PAsync): Integer;
var
  BytesTrans, Signaled: DWORD;
  Success: Boolean;
begin
  (*
  if AsyncPtr = nil then
    raise EComPort.CreateNoWinCode(CError_InvalidAsync);
   *) 

  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, INFINITE);
  Success := (Signaled = WAIT_OBJECT_0) and
      (GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, False));

//  if (AsyncPtr^.Kind = okRead) and (InputCount = 0) then
//    SendSignals(lsRx, False);

  (*
  if not Success then
    raise EComPort.Create(ErrorCode(AsyncPtr), GetLastError);
   *) 

  Result := BytesTrans;
end;

// abort all asynchronous operations
procedure TMHComPort.AbortAllAsync;
begin
  {
  if not}
   PurgeComm(FHandle, PURGE_TXABORT or PURGE_RXABORT);
   { then
    raise EComPort.Create(CError_PurgeFailed, GetLastError);
   }
end;

// detect whether asynchronous operation is completed
function TMHComPort.IsAsyncCompleted(AsyncPtr: PAsync): Boolean;
var
  BytesTrans: DWORD;
begin
  (*
  if AsyncPtr = nil then
    raise EComPort.CreateNoWinCode(CError_InvalidAsync);
  *)  

  Result := GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, False);
  (*
  if not Result then
    if GetLastError <> ERROR_IO_PENDING then
      raise EComPort.Create(CError_AsyncCheck, GetLastError);
   *)   
end;

// waits for event to occur on serial port
procedure TMHComPort.WaitForEvent(var Events2: TComEvents; Timeout: Integer);
var
  Overlapped: TOverlapped;
  Mask: DWORD;
  Success: Boolean;
  Signaled: Integer;
begin
  (*
  if FThreadCreated then
    raise EComPort.CreateNoWinCode(CError_ThreadCreated);
  *)  
  FillChar(Overlapped, SizeOf(TOverlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, False, nil);
  try
    SetCommMask(FHandle, EventsToInt(Events2));
    Success := WaitCommEvent(FHandle, Mask, @Overlapped);
    if (Success) or (GetLastError = ERROR_IO_PENDING) then
    begin
      Signaled := WaitForSingleObject(Overlapped.hEvent, Timeout);
      if Signaled = WAIT_TIMEOUT then
        SetCommMask(FHandle, 0);
      Success := (Signaled = WAIT_OBJECT_0) or (Signaled = WAIT_TIMEOUT);
    end;
    (*
    if not Success then
      raise EComPort.Create(CError_WaitFailed, GetLastError);
    *)  
    Events2 := IntToEvents(Mask);
  finally
    CloseHandle(Overlapped.hEvent);
  end;
end;

// transmit char ahead of any pending data in ouput buffer
procedure TMHComPort.TransmitChar(Ch: Char);
begin
{
  if not TransmitCommChar(FHandle, Ch) then
    raise EComPort.Create(CError_TransmitFailed, GetLastError);
    }
end;

// some conversion routines
function BoolToStr(const Value: Boolean): string;
begin
  if Value then
    Result := 'Yes'
  else
    Result := 'No';
end;

function StrToBool(const Value: string): Boolean;
begin
  if UpperCase(Value) = 'YES' then
    Result := True
  else
    Result := False;
end;

function DTRToStr(DTRFlowControl: TDTRFlowControl): string;
const
  DTRStrings: array[TDTRFlowControl] of string = ('Disable', 'Enable',
    'Handshake');
begin
  Result := DTRStrings[DTRFlowControl];
end;

function RTSToStr(RTSFlowControl: TRTSFlowControl): string;
const
  RTSStrings: array[TRTSFlowControl] of string = ('Disable', 'Enable',
    'Handshake', 'Toggle');
begin
  Result := RTSStrings[RTSFlowControl];
end;

function StrToRTS(Str: string): TRTSFlowControl;
var
  I: TRTSFlowControl;
begin
  I := Low(TRTSFlowControl);
  while (I <= High(TRTSFlowControl)) do
  begin
    if UpperCase(Str) = UpperCase(RTSToStr(I)) then
      Break;
    I := Succ(I);
  end;
  if I > High(TRTSFlowControl) then
    Result := rtsDisable
  else
    Result := I;
end;

function StrToDTR(Str: string): TDTRFlowControl;
var
  I: TDTRFlowControl;
begin
  I := Low(TDTRFlowControl);
  while (I <= High(TDTRFlowControl)) do
  begin
    if UpperCase(Str) = UpperCase(DTRToStr(I)) then
      Break;
    I := Succ(I);
  end;
  if I > High(TDTRFlowControl) then
    Result := dtrDisable
  else
    Result := I;
end;

function StrToChar(Str: string): Char;
var
  A: Integer;
begin
  if Length(Str) > 0 then
  begin
    if (Str[1] = '#') and (Length(Str) > 1) then
    begin
      try
        A := Str2Int(Copy(Str, 2, Length(Str) - 1));
      except
        A := 0;
      end;
      Result := Chr(Byte(A));
    end
    else
      Result := Str[1];
  end
  else
    Result := #0;
end;

function CharToStr(Ch: Char): string;
begin
  if Ch in [#33..#127] then
    Result := Ch
  else
    Result := '#' + Int2Str(Ord(Ch));
end;


// default actions on port events

procedure TMHComPort.DoBeforeClose;
begin
  if Assigned(FOnBeforeClose) then
    FOnBeforeClose(@Self);
end;

procedure TMHComPort.DoBeforeOpen;
begin
  if Assigned(FOnBeforeOpen) then
    FOnBeforeOpen(@Self);
end;

procedure TMHComPort.DoAfterOpen;
begin
  if Assigned(FOnAfterOpen) then
    FOnAfterOpen(@Self);
end;

procedure TMHComPort.DoAfterClose;
begin
  if Assigned(FOnAfterClose) then
    FOnAfterClose(@Self);
end;

procedure TMHComPort.DoRxChar(Count: Integer);
begin
  if Assigned(FOnRxChar) then
    FOnRxChar(PObj(@Self), Count);
end;

procedure TMHComPort.DoRxBuf(Buf:array of Byte; Count: Integer);
begin
  if Assigned(FOnRxBuf) then
    FOnRxBuf(PObj(@Self), Buf, Count);
end;

procedure TMHComPort.DoBreak;
begin
  if Assigned(FOnBreak) then
    FOnBreak(@Self);
end;

procedure TMHComPort.DoTxEmpty;
begin
  if Assigned(FOnTxEmpty)
    then FOnTxEmpty(@Self);
end;

procedure TMHComPort.DoRing;
begin
  if Assigned(FOnRing) then
    FOnRing(@Self);
end;

procedure TMHComPort.DoCTSChange(OnOff: Boolean);
begin
  if Assigned(FOnCTSChange) then
    FOnCTSChange(PObj(@Self), OnOff);
end;

procedure TMHComPort.DoDSRChange(OnOff: Boolean);
begin
  if Assigned(FOnDSRChange) then
    FOnDSRChange(PObj(@Self), OnOff);
end;

procedure TMHComPort.DoRLSDChange(OnOff: Boolean);
begin
  if Assigned(FOnRLSDChange) then
    FOnRLSDChange(PObj(@Self), OnOff);
end;

procedure TMHComPort.DoError(Errors: TComErrors);
begin
  if Assigned(FOnError) then
    FOnError(PObj(@Self), Errors);
end;

procedure TMHComPort.DoRxFlag;
begin
  if Assigned(FOnRxFlag) then
    FOnRxFlag(@Self);
end;

procedure TMHComPort.DoRx80Full;
begin
  if Assigned(FOnRx80Full) then
    FOnRx80Full(@Self);
end;

// set signals to false on close, and to proper value on open,
// because OnXChange events are not called automatically
procedure TMHComPort.CheckSignals(Open2: Boolean);
begin
  if Open2 then
  begin
    CallCTSChange;
    CallDSRChange;
    CallRLSDChange;
  end else
  begin
{    SendSignals(lsCTS, False);
    SendSignals(lsDSR, False);
    SendSignals(lsRLSD, False);}
    DoCTSChange(False);
    DoDSRChange(False);
    DoRLSDChange(False);
  end;
end;

// called in response to EV_X events, except CallXClose, CallXOpen

procedure TMHComPort.CallAfterClose;
begin
  DoAfterClose;
end;

procedure TMHComPort.CallAfterOpen;
begin
  DoAfterOpen;
  // check all com signals, since OnXChange events are not called on open
  CheckSignals(True);
end;

procedure TMHComPort.CallBeforeClose;
begin
  DoBeforeClose;
  // shutdown com signals manually
  CheckSignals(False);
end;

procedure TMHComPort.CallBeforeOpen;
begin
  DoBeforeClose;
end;

procedure TMHComPort.CallBreak;
begin
  DoBreak;
end;

procedure TMHComPort.CallCTSChange;
var
  OnOff: Boolean;
begin
  OnOff := csCTS in Signals;
  // check for linked components
//  SendSignals(lsCTS, OnOff);
  DoCTSChange(csCTS in Signals);
end;

procedure TMHComPort.CallDSRChange;
var
  OnOff: Boolean;
begin
  OnOff := csDSR in Signals;
  // check for linked components
//  SendSignals(lsDSR, OnOff);
  DoDSRChange(csDSR in Signals);
end;

procedure TMHComPort.CallRLSDChange;
var
  OnOff: Boolean;
begin
  OnOff := csRLSD in Signals;
  // check for linked components
//  SendSignals(lsRLSD, OnOff);
  DoRLSDChange(csRLSD in Signals);
end;

procedure TMHComPort.CallError;
begin
//  DoError(LastErrors);
end;

procedure TMHComPort.CallRing;
begin
  DoRing;
end;

procedure TMHComPort.CallRx80Full;
begin
  DoRx80Full;
end;

procedure TMHComPort.CallRxChar;
var
  Count: Integer;

  // check if any component is linked, to OnRxChar event
  procedure CheckLinks;
  var
    P: Pointer;
    ReadFromBuffer: Boolean;
  begin
    // examine links
    if (Count > 0){ and (FLinks.Count > 0)} then
    begin
      ReadFromBuffer := False;
      try

        begin

          begin
            // link to OnRxChar event found
            if not ReadFromBuffer then
            begin
              // TMHComPort must read from comport, so OnRxChar event is
              // not triggered
              GetMem(P, Count);
              ReadFromBuffer := True;
              Read(P^, Count);
              // instead, call OnRxBuf event
              DoRxBuf(Byte(P^), Count);
            end;


          end
        end;
      finally
        if ReadFromBuffer then
        begin
          FreeMem(P);
          // data is already out of buffer, prevent from OnRxChar event to occur
          Count := 0;
        end;
      end;
    end;
  end;

begin
  Count := InputCount;

  if Count > 0 then
    DoRxChar(Count);
end;

procedure TMHComPort.CallRxFlag;
begin
  DoRxFlag;
end;

procedure TMHComPort.CallTxEmpty;
begin
//  SendSignals(lsTx, False);
  DoTxEmpty;
end;

// send signals to linked components

// set connected property, same as Open/Close methods
procedure TMHComPort.SetConnected(const Value: Boolean);
begin
  if Value <> FConnected then
    if Value then
      Open
    else
      Close
  else
    FConnected := Value;
end;

// set baud rate
procedure TMHComPort.SetBaudRate(const Value: TBaudRate);
begin
  if Value <> FBaudRate then
  begin
    FBaudRate := Value;
    // if possible, apply settings
    ApplyDCB;
  end;
end;

// set custom baud rate
procedure TMHComPort.SetCustomBaudRate(const Value: Integer);
begin
  if Value <> FCustomBaudRate then
  begin
    FCustomBaudRate := Value;
    ApplyDCB;
  end;
end;

// set data bits
procedure TMHComPort.SetDataBits(const Value: TDataBits);
begin
  if Value <> FDataBits then
  begin
    FDataBits := Value;
    ApplyDCB;
  end;
end;

// set discard null charachters
procedure TMHComPort.SetDiscardNull(const Value: Boolean);
begin
  if Value <> FDiscardNull then
  begin
    FDiscardNull := Value;
    ApplyDCB;
  end;
end;

// set event charachters
procedure TMHComPort.SetEventChar(const Value: Char);
begin
  if Value <> FEventChar then
  begin
    FEventChar := Value;
    ApplyDCB;
  end;
end;

// translated numeric string to port string
function ComString(Str: string): TPort;
var
  Num: Integer;
begin
  if UpperCase(Copy(Str, 1, 3)) = 'COM' then
    Str := Copy(Str, 4, Length(Str) - 3);
  try
    Num := Str2Int(Str);
  except
    Num := 1;
  end;
  if (Num < 1) or (Num > 16) then
    Num := 1;
  Result := Format('COM%d', [Num]);
end;

// set port
procedure TMHComPort.SetPort(const Value: TPort);
var
  Str: string;
begin
  Str := ComString(Value);
  if Str <> FPort then
  begin
    FPort := Str;
    if (FConnected)  then
    begin
      Close;
      Open;
    end;
  end;
end;

// set stop bits
procedure TMHComPort.SetStopBits(const Value: TStopBits);
begin
  if Value <> FStopBits then
  begin
    FStopBits := Value;
    ApplyDCB;
  end;
end;

// set event synchronization method
procedure TMHComPort.SetSyncMethod(const Value: TSyncMethod);
begin
  if Value <> FSyncMethod then
  begin
    if (FConnected)
    then
//      raise EComPort.CreateNoWinCode(CError_SyncMeth)
    else
      FSyncMethod := Value;
  end;
end;

// returns true if RxChar is triggered when data arrives input buffer
function TMHComPort.GetTriggersOnRxChar: Boolean;
begin
  Result := True;
end;

// set flow control
procedure TMHComPort.SetFlowControl(const Value: PMHComFlowControl);
begin
  FFlowControl.AssignTo(Value);
  ApplyDCB;
end;

// set parity
procedure TMHComPort.SetParity(const Value: PMHComParity);
begin
  FParity.AssignTo(Value);
  ApplyDCB;
end;

// set timeouts
procedure TMHComPort.SetTimeouts(const Value: PMHComTimeouts);
begin
  FTimeouts.AssignTo(Value);
  ApplyTimeouts;
end;

// set buffer
procedure TMHComPort.SetBuffer(const Value: PMHComBuffer);
begin
  FBuffer.AssignTo(Value);
  ApplyBuffer;
end;

function BaudRateToStr(BaudRate: TBaudRate): string;
const
  BaudRateStrings: array[TBaudRate] of string = ('Custom', '110', '300', '600',
    '1200', '2400', '4800', '9600', '14400', '19200', '38400', '56000', '57600',
    '115200', '128000', '256000');
begin
  Result := BaudRateStrings[BaudRate];
end;

// string to baud rate
function StrToBaudRate(Str: string): TBaudRate;
var
  I: TBaudRate;
begin
  I := Low(TBaudRate);
  while (I <= High(TBaudRate)) do
  begin
    if UpperCase(Str) = UpperCase(BaudRateToStr(TBaudRate(I))) then
      Break;
    I := Succ(I);
  end;
  if I > High(TBaudRate) then
    Result := br9600
  else
    Result := I;
end;

function FlowControlToStr(FlowControl: TFlowControl): string;
const
  FlowControlStrings: array[TFlowControl] of string = ('Hardware',
    'Software', 'None', 'Custom');
begin
  Result := FlowControlStrings[FlowControl];
end;

function StopBitsToStr(StopBits: TStopBits): string;
const
  StopBitsStrings: array[TStopBits] of string = ('1', '1.5', '2');
begin
  Result := StopBitsStrings[StopBits];
end;

// string to stop bits
function StrToStopBits(Str: string): TStopBits;
var
  I: TStopBits;
begin
  I := Low(TStopBits);
  while (I <= High(TStopBits)) do
  begin
    if UpperCase(Str) = UpperCase(StopBitsToStr(TStopBits(I))) then
      Break;
    I := Succ(I);
  end;
  if I > High(TStopBits) then
    Result := sbOneStopBit
  else
    Result := I;
end;

function DataBitsToStr(DataBits: TDataBits): string;
const
  DataBitsStrings: array[TDataBits] of string = ('5', '6', '7', '8');
begin
  Result := DataBitsStrings[DataBits];
end;

// string to data bits
function StrToDataBits(Str: string): TDataBits;
var
  I: TDataBits;
begin
  I := Low(TDataBits);
  while (I <= High(TDataBits)) do
  begin
    if UpperCase(Str) = UpperCase(DataBitsToStr(I)) then
      Break;
    I := Succ(I);
  end;
  if I > High(TDataBits) then
    Result := dbEight
  else
    Result := I;
end;
function ParityToStr(Parity: TParityBits): string;
const
  ParityBitsStrings: array[TParityBits] of string = ('None', 'Odd', 'Even',
    'Mark', 'Space');
begin
  Result := ParityBitsStrings[Parity];
end;

// string to parity
function StrToParity(Str: string): TParityBits;
var
  I: TParityBits;
begin
  I := Low(TParityBits);
  while (I <= High(TParityBits)) do
  begin
    if UpperCase(Str) = UpperCase(ParityToStr(I)) then
      Break;
    I := Succ(I);
  end;
  if I > High(TParityBits) then
    Result := prNone
  else
    Result := I;
end;


// string to flow control
function StrToFlowControl(Str: string): TFlowControl;
var
  I: TFlowControl;
begin
  I := Low(TFlowControl);
  while (I <= High(TFlowControl)) do
  begin
    if UpperCase(Str) = UpperCase(FlowControlToStr(I)) then
      Break;
    I := Succ(I);
  end;
  if I > High(TFlowControl) then
    Result := fcCustom
  else
    Result := I;
end;

end.
