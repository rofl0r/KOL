unit MCKMHComPort;
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
  KOL, KOLMHComPort, mirror, Classes;

type
  TKOLMHComPort = class;

  TComFlowControl = class(TPersistent)
  private
    FComPort: TKOLMHComPort;
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
    procedure SetComPort(const AComPort:TKOLMHComPort);
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
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
    property ComPort: TKOLMHComPort read FComPort;
  published
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

  TComTimeouts = class(TPersistent)
  private
    FComPort: TKOLMHComPort;
    FReadInterval: Integer;
    FReadTotalM: Integer;
    FReadTotalC: Integer;
    FWriteTotalM: Integer;
    FWriteTotalC: Integer;
    procedure SetComPort(const AComPort: TKOLMHComPort);
    procedure SetReadInterval(const Value: Integer);
    procedure SetReadTotalM(const Value: Integer);
    procedure SetReadTotalC(const Value: Integer);
    procedure SetWriteTotalM(const Value: Integer);
    procedure SetWriteTotalC(const Value: Integer);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
    property ComPort: TKOLMHComPort read FComPort;
  published
    property ReadInterval: Integer read FReadInterval write SetReadInterval default -1;
    property ReadTotalMultiplier: Integer read FReadTotalM write SetReadTotalM default 0;
    property ReadTotalConstant: Integer read FReadTotalC write SetReadTotalC default 0;
    property WriteTotalMultiplier: Integer
      read FWriteTotalM write SetWriteTotalM default 100;
    property WriteTotalConstant: Integer
      read FWriteTotalC write SetWriteTotalC default 1000;
  end;

  TComParity = class(TPersistent)
  private
    FComPort: TKOLMHComPort;
    FBits: TParityBits;
    FCheck: Boolean;
    FReplace: Boolean;
    FReplaceChar: Char;
    procedure SetComPort(const AComPort: TKOLMHComPort);
    procedure SetBits(const Value: TParityBits);
    procedure SetCheck(const Value: Boolean);
    procedure SetReplace(const Value: Boolean);
    procedure SetReplaceChar(const Value: Char);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
    property ComPort: TKOLMHComPort read FComPort;
  published
    property Bits: TParityBits read FBits write SetBits;
    property Check: Boolean read FCheck write SetCheck default False;
    property Replace: Boolean read FReplace write SetReplace default False;
    property ReplaceChar: Char read FReplaceChar write SetReplaceChar default #0;
  end;

  TComBuffer = class(TPersistent)
  private
    FComPort: TKOLMHComPort;
    FInputSize: Integer;
    FOutputSize: Integer;
    procedure SetComPort(const AComPort: TKOLMHComPort);
    procedure SetInputSize(const Value: Integer);
    procedure SetOutputSize(const Value: Integer);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
    property ComPort: TKOLMHComPort read FComPort;
  published
    property InputSize: Integer read FInputSize write SetInputSize default 1024;
    property OutputSize: Integer read FOutputSize write SetOutputSize default 1024;
  end;

  TKOLMHComPort = class(TKOLObj)
  private
//    FWindow: THandle;
//    FUpdateCount: Integer;
    FBaudRate: TBaudRate;
    FCustomBaudRate: Integer;
    FPort: TPort;
    FStopBits: TStopBits;
    FDataBits: TDataBits;
    FDiscardNull: Boolean;
    FEventChar: Char;
    FEvents: TComEvents;
    FBuffer: TComBuffer;
    FParity: TComParity;
    FTimeouts: TComTimeouts;
    FFlowControl: TComFlowControl;
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
    procedure SetBaudRate(const Value: TBaudRate);
    procedure SetCustomBaudRate(const Value: Integer);
    procedure SetPort(const Value: TPort);
    procedure SetStopBits(const Value: TStopBits);
    procedure SetDataBits(const Value: TDataBits);
    procedure SetDiscardNull(const Value: Boolean);
    procedure SetEventChar(const Value: Char);
    procedure SetSyncMethod(const Value: TSyncMethod);
    procedure SetParity(const Value: TComParity);
    procedure SetTimeouts(const Value: TComTimeouts);
    procedure SetBuffer(const Value: TComBuffer);
    procedure SetFlowControl(const Value: TComFlowControl);
    procedure SetOnRxChar(const Value:TRxCharEvent);
  protected
    function  AdditionalUnits: string; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property CustomBaudRate: Integer read FCustomBaudRate write SetCustomBaudRate;
    property Port: TPort read FPort write SetPort;
    property Parity: TComParity read FParity write SetParity;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property DataBits: TDataBits read FDataBits write SetDataBits;
    property DiscardNull: Boolean read FDiscardNull write SetDiscardNull default False;
    property EventChar: Char read FEventChar write SetEventChar default #0;
    property Events: TComEvents read FEvents write FEvents;
    property Buffer: TComBuffer read FBuffer write SetBuffer;
    property FlowControl: TComFlowControl read FFlowControl write SetFlowControl;
    property Timeouts: TComTimeouts read FTimeouts write SetTimeouts;
    property SyncMethod: TSyncMethod read FSyncMethod write SetSyncMethod default smThreadSync;
    property OnAfterOpen: TOnEvent read FOnAfterOpen write FOnAfterOpen;
    property OnAfterClose: TOnEvent read FOnAfterClose write FOnAfterClose;
    property OnBeforeOpen: TOnEvent read FOnBeforeOpen write FOnBeforeOpen;
    property OnBeforeClose: TOnEvent read FOnBeforeClose write FOnBeforeClose;
    property OnRxChar: TRxCharEvent read FOnRxChar write SetOnRxChar;
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

  procedure Register;

implementation

constructor TComFlowControl.Create;
begin
  inherited Create;
  FXonChar := #17;
  FXoffChar := #19;
end;

// copy properties to other class
procedure TComFlowControl.AssignTo(Dest: TPersistent);
begin
  if Dest is TComFlowControl then
  begin
    with TComFlowControl(Dest) do
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
    inherited AssignTo(Dest);
end;

procedure TComFlowControl.SetComPort(const AComPort:TKOLMHComPort);
begin
  FComPort:=AComPort;
end;


// set input flow control for DTR (data-terminal-ready)
procedure TComFlowControl.SetControlDTR(const Value: TDTRFlowControl);
begin
  if Value <> FControlDTR then
  begin
    FControlDTR := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set input flow control for RTS (request-to-send)
procedure TComFlowControl.SetControlRTS(const Value: TRTSFlowControl);
begin
  if Value <> FControlRTS then
  begin
    FControlRTS := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set ouput flow control for CTS (clear-to-send)
procedure TComFlowControl.SetOutCTSFlow(const Value: Boolean);
begin
  if Value <> FOutCTSFlow then
  begin
    FOutCTSFlow := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set output flow control for DSR (data-set-ready)
procedure TComFlowControl.SetOutDSRFlow(const Value: Boolean);
begin
  if Value <> FOutDSRFlow then
  begin
    FOutDSRFlow := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set software input flow control
procedure TComFlowControl.SetXonXoffIn(const Value: Boolean);
begin
  if Value <> FXonXoffIn then
  begin
    FXonXoffIn := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set software ouput flow control
procedure TComFlowControl.SetXonXoffOut(const Value: Boolean);
begin
  if Value <> FXonXoffOut then
  begin
    FXonXoffOut := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set DSR sensitivity
procedure TComFlowControl.SetDSRSensitivity(const Value: Boolean);
begin
  if Value <> FDSRSensitivity then
  begin
    FDSRSensitivity := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set transfer continue when Xoff is sent
procedure TComFlowControl.SetTxContinueOnXoff(const Value: Boolean);
begin
  if Value <> FTxContinueOnXoff then
  begin
    FTxContinueOnXoff := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set Xon char
procedure TComFlowControl.SetXonChar(const Value: Char);
begin
  if Value <> FXonChar then
  begin
    FXonChar := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set Xoff char
procedure TComFlowControl.SetXoffChar(const Value: Char);
begin
  if Value <> FXoffChar then
  begin
    FXoffChar := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// get common flow control
function TComFlowControl.GetFlowControl: TFlowControl;
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
procedure TComFlowControl.SetFlowControl(const Value: TFlowControl);
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
//  if FComPort <> nil then
//    FComPort.ApplyDCB;
end;


constructor TComTimeouts.Create;
begin
  inherited Create;
  FReadInterval := -1;
  FWriteTotalM := 100;
  FWriteTotalC := 1000;
end;

// copy properties to other class
procedure TComTimeouts.AssignTo(Dest: TPersistent);
begin
  if Dest is TComTimeouts then
  begin
    with TComTimeouts(Dest) do
    begin
      FReadInterval := Self.ReadInterval;
      FReadTotalM   := Self.ReadTotalMultiplier;
      FReadTotalC   := Self.ReadTotalConstant;
      FWriteTotalM  := Self.WriteTotalMultiplier;
      FWriteTotalC  := Self.WriteTotalConstant;
    end
  end
  else
    inherited AssignTo(Dest);
end;

// select TCustomComPort to own this class
procedure TComTimeouts.SetComPort(const AComPort: TKOLMHComPort);
begin
  FComPort := AComPort;
end;

// set read interval
procedure TComTimeouts.SetReadInterval(const Value: Integer);
begin
  if Value <> FReadInterval then
  begin
    FReadInterval := Value;
    // if possible, apply the changes
//    if FComPort <> nil then
//      FComPort.ApplyTimeouts;
  end;
end;

// set read total constant
procedure TComTimeouts.SetReadTotalC(const Value: Integer);
begin
  if Value <> FReadTotalC then
  begin
    FReadTotalC := Value;
//    if FComPort <> nil then
//      FComPort.ApplyTimeouts;
  end;
end;

// set read total multiplier
procedure TComTimeouts.SetReadTotalM(const Value: Integer);
begin
  if Value <> FReadTotalM then
  begin
    FReadTotalM := Value;
//    if FComPort <> nil then
//      FComPort.ApplyTimeouts;
  end;
end;

// set write total constant
procedure TComTimeouts.SetWriteTotalC(const Value: Integer);
begin
  if Value <> FWriteTotalC then
  begin
    FWriteTotalC := Value;
//    if FComPort <> nil then
//      FComPort.ApplyTimeouts;
  end;
end;

// set write total multiplier
procedure TComTimeouts.SetWriteTotalM(const Value: Integer);
begin
  if Value <> FWriteTotalM then
  begin
    FWriteTotalM := Value;
//    if FComPort <> nil then
//      FComPort.ApplyTimeouts;
  end;
end;


constructor TComParity.Create;
begin
  inherited Create;
  FBits := prNone;
end;

// copy properties to other class
procedure TComParity.AssignTo(Dest: TPersistent);
begin
  if Dest is TComParity then
  begin
    with TComParity(Dest) do
    begin
      FBits        := Self.Bits;
      FCheck       := Self.Check;
      FReplace     := Self.Replace;
      FReplaceChar := Self.ReplaceChar;
    end
  end
  else
    inherited AssignTo(Dest);
end;

// select TCustomComPort to own this class
procedure TComParity.SetComPort(const AComPort: TKOLMHComPort);
begin
  FComPort := AComPort;
end;

// set parity bits
procedure TComParity.SetBits(const Value: TParityBits);
begin
  if Value <> FBits then
  begin
    FBits := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set check parity
procedure TComParity.SetCheck(const Value: Boolean);
begin
  if Value <> FCheck then
  begin
    FCheck := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set replace on parity error
procedure TComParity.SetReplace(const Value: Boolean);
begin
  if Value <> FReplace then
  begin
    FReplace := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

// set replace char
procedure TComParity.SetReplaceChar(const Value: Char);
begin
  if Value <> FReplaceChar then
  begin
    FReplaceChar := Value;
//    if FComPort <> nil then
//      FComPort.ApplyDCB;
  end;
end;

constructor TComBuffer.Create;
begin
  inherited Create;
  FInputSize := 1024;
  FOutputSize := 1024;
end;

// copy properties to other class
procedure TComBuffer.AssignTo(Dest: TPersistent);
begin
  if Dest is TComBuffer then
  begin
    with TComBuffer(Dest) do
    begin
      FOutputSize  := Self.OutputSize;
      FInputSize   := Self.InputSize;
    end
  end
  else
    inherited AssignTo(Dest);
end;

// select TCustomComPort to own this class
procedure TComBuffer.SetComPort(const AComPort: TKOLMHComPort);
begin
  FComPort := AComPort;
end;

// set input size
procedure TComBuffer.SetInputSize(const Value: Integer);
begin
  if Value <> FInputSize then
  begin
    FInputSize := Value;
    if (FInputSize mod 2) = 1 then
      Dec(FInputSize);
//    if FComPort <> nil then
//      FComPort.ApplyBuffer;
  end;
end;

// set ouput size
procedure TComBuffer.SetOutputSize(const Value: Integer);
begin
  if Value <> FOutputSize then
  begin
    FOutputSize := Value;
    if (FOutputSize mod 2) = 1 then
      Dec(FOutputSize);
//    if FComPort <> nil then
//      FComPort.ApplyBuffer;
  end;
end;


constructor TKOLMHComPort.Create(AOwner: TComponent);
begin
  inherited;
  FComponentStyle := FComponentStyle - [csInheritable];
//  FLinks := TList.Create;
  FBaudRate := br9600;
  FCustomBaudRate := 9600;
  FPort := 'COM1';
  FStopBits := sbOneStopBit;
  FDataBits := dbEight;
  FEvents := [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak,
             evCTS, evDSR, evError, evRLSD, evRx80Full];
//  FHandle := INVALID_HANDLE_VALUE;
  FStoredProps := [spBasic];
  FParity := TComParity.Create;
//  FParity.SetComPort(Self);
  FFlowControl := TComFlowControl.Create;
//  FFlowControl.SetComPort(Self);
  FTimeouts := TComTimeouts.Create;
//  FTimeouts.SetComPort(Self);
  FBuffer := TComBuffer.Create;
//  FBuffer.SetComPort(Self);
//  FInitFont:=TKOLFont.Create(Self);
end;

destructor TKOLMHComPort.Destroy;
begin
//  Close;
  FBuffer.Free;
  FFlowControl.Free;
  FTimeouts.Free;
  FParity.Free;
//  FLinks.Free;
  inherited;

//  FInitFont.Free;
end;

function TKOLMHComPort.AdditionalUnits;
begin
   Result := ', KOLMHComPort';
end;

procedure TKOLMHComPort.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const
  Boolean2Str:array [Boolean] of String=('False','True');
  BaudRate2Str:array [TBaudRate] of String=('brCustom', 'br110', 'br300', 'br600', 'br1200', 'br2400', 'br4800', 'br9600', 'br14400',
    'br19200', 'br38400', 'br56000', 'br57600', 'br115200', 'br128000', 'br256000');
  StopBits2Str:array [TStopBits] of String=('sbOneStopBit', 'sbOne5StopBits', 'sbTwoStopBits');
  DataBits2Str:array [TDataBits] of String=('dbFive', 'dbSix', 'dbSeven', 'dbEight');
  ParityBits2Str:array [TParityBits] of String=('prNone', 'prOdd', 'prEven', 'prMark', 'prSpace');
  ControlDTR2Str:array [TDTRFlowControl] of String=('dtrDisable', 'dtrEnable', 'dtrHandshake');
  ControlRTS2Str:array [TRTSFlowControl] of String=('rtsDisable', 'rtsEnable', 'rtsHandshake', 'rtsToggle');
  SyncMethod2Str:array [TSyncMethod] of String=('smThreadSync', 'smWindowSync', 'smNone');
  ComEvent2Str:array [TComEvent] of String=('evRxChar', 'evTxEmpty', 'evRxFlag', 'evRing', 'evBreak', 'evCTS', 'evDSR', 'evError', 'evRLSD', 'evRx80Full');
var
  tmpStr:String;  
begin
  SL.Add('');
  SL.Add(Prefix+AName+':=NewMHComPort('+AParent+');');
  SL.Add(Prefix+AName+'.BaudRate:='+BaudRate2Str[BaudRate]+';');
  SL.Add(Prefix+AName+'.Port:='''+Port+''';');
  SL.Add(Prefix+AName+'.DiscardNull:='+Boolean2Str[DiscardNull]+';');
  SL.Add(Prefix+AName+'.CustomBaudRate:='+Int2Str(CustomBaudRate)+';');
  SL.Add(Prefix+AName+'.StopBits:='+StopBits2Str[StopBits]+';');
  SL.Add(Prefix+AName+'.DataBits:='+DataBits2Str[DataBits]+';');
  SL.Add(Prefix+AName+'.EventChar:=#'+Int2Str(Ord(EventChar))+';');
  SL.Add(Prefix+AName+'.SyncMethod:='+SyncMethod2Str[SyncMethod]+';');
  tmpStr:='   ';
  if evRxChar in Events then
    tmpStr:=tmpStr+'evRxChar, ';
  if evTxEmpty in Events then
    tmpStr:=tmpStr+'evTxEmpty, ';
  if evRxFlag in Events then
    tmpStr:=tmpStr+'evRxFlag, ';
  if evRing in Events then
    tmpStr:=tmpStr+'evRing, ';
  if evBreak in Events then
    tmpStr:=tmpStr+'evBreak, ';
  if evCTS in Events then
    tmpStr:=tmpStr+'evCTS, ';
  if evDSR in Events then
    tmpStr:=tmpStr+'evDSR, ';
  if evError in Events then
    tmpStr:=tmpStr+'evError, ';
  if evRLSD in Events then
    tmpStr:=tmpStr+'evRLSD, ';
  if evRx80Full in Events then
    tmpStr:=tmpStr+'evRx80Full, ';
  tmpStr[Length(tmpStr)-1]:=' ';
  tmpStr:=Trim(tmpStr);
  SL.Add(Prefix+AName+'.Events:=[ '+tmpStr+' ];');
  // All Parity
  SL.Add(Prefix+AName+'.Parity.Bits:='+ParityBits2Str[Parity.Bits]+';');
  SL.Add(Prefix+AName+'.Parity.Check:='+Boolean2Str[Parity.Check]+';');
  SL.Add(Prefix+AName+'.Parity.Replace:='+Boolean2Str[Parity.Replace]+';');
  SL.Add(Prefix+AName+'.Parity.ReplaceChar:=#'+Int2Str(Ord(Parity.ReplaceChar))+';');
  // All Buffer
  SL.Add(Prefix+AName+'.Buffer.InputSize:='+Int2Str(Buffer.InputSize)+';');
  SL.Add(Prefix+AName+'.Buffer.OutputSize:='+Int2Str(Buffer.OutputSize)+';');
  // All Flow Control
  SL.Add(Prefix+AName+'.FlowControl.ControlDTR:='+ControlDTR2Str[FlowControl.ControlDTR]+';');
  SL.Add(Prefix+AName+'.FlowControl.ControlRTS:='+ControlRTS2Str[FlowControl.ControlRTS]+';');
  SL.Add(Prefix+AName+'.FlowControl.DSRSensitivity:='+Boolean2Str[FlowControl.DSRSensitivity]+';');
  SL.Add(Prefix+AName+'.FlowControl.OutCTSFlow:='+Boolean2Str[FlowControl.OutCTSFlow]+';');
  SL.Add(Prefix+AName+'.FlowControl.OutDSRFlow:='+Boolean2Str[FlowControl.OutDSRFlow]+';');
  SL.Add(Prefix+AName+'.FlowControl.TxContinueOnXoff:='+Boolean2Str[FlowControl.TxContinueOnXoff]+';');
  SL.Add(Prefix+AName+'.FlowControl.XoffChar:=#'+Int2Str(Ord(FlowControl.XoffChar))+';');
  SL.Add(Prefix+AName+'.FlowControl.XonChar:=#'+Int2Str(Ord(FlowControl.XonChar))+';');
  SL.Add(Prefix+AName+'.FlowControl.XonXoffIn:='+Boolean2Str[FlowControl.XonXoffIn]+';');
  SL.Add(Prefix+AName+'.FlowControl.XonXoffOut:='+Boolean2Str[FlowControl.XonXoffOut]+';');
  // All TimeOuts
  SL.Add(Prefix+AName+'.Timeouts.ReadInterval:='+Int2Str(Timeouts.ReadInterval)+';');
  SL.Add(Prefix+AName+'.Timeouts.ReadTotalConstant:='+Int2Str(Timeouts.ReadTotalConstant)+';');
  SL.Add(Prefix+AName+'.Timeouts.ReadTotalMultiplier:='+Int2Str(Timeouts.ReadTotalMultiplier)+';');
  SL.Add(Prefix+AName+'.Timeouts.WriteTotalConstant:='+Int2Str(Timeouts.WriteTotalConstant)+';');
  SL.Add(Prefix+AName+'.Timeouts.WriteTotalMultiplier:='+Int2Str(Timeouts.WriteTotalMultiplier)+';');
end;

procedure TKOLMHComPort.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnRxChar', 'OnRxBuf', 'OnAfterOpen' ,
  'OnAfterClose', 'OnBeforeOpen', 'OnBeforeClose', 'OnTxEmpty', 'OnBreak',
  'OnRing', 'OnCTSChange', 'OnDSRChange', 'OnRLSDChange', 'OnRxFlag',
  'OnError', 'OnRx80Full'], [ @OnRxChar,@OnRxBuf, @OnAfterOpen , @OnAfterClose,
  @OnBeforeOpen, @OnBeforeClose, @OnTxEmpty, @OnBreak, @OnRing, @OnCTSChange,
  @OnDSRChange, @OnRLSDChange, @OnRxFlag, @OnError, @OnRx80Full] );
end;

// set baud rate
procedure TKOLMHComPort.SetBaudRate(const Value: TBaudRate);
begin
  if Value <> FBaudRate then
  begin
    FBaudRate := Value;
    // if possible, apply settings
    Change;
//    ApplyDCB;
  end;
end;

// set custom baud rate
procedure TKOLMHComPort.SetCustomBaudRate(const Value: Integer);
begin
  if Value <> FCustomBaudRate then
  begin
    FCustomBaudRate := Value;
    Change;
//    ApplyDCB;
  end;
end;

// set data bits
procedure TKOLMHComPort.SetDataBits(const Value: TDataBits);
begin
  if Value <> FDataBits then
  begin
    FDataBits := Value;
    Change;
//    ApplyDCB;
  end;
end;

// set discard null charachters
procedure TKOLMHComPort.SetDiscardNull(const Value: Boolean);
begin
  if Value <> FDiscardNull then
  begin
    FDiscardNull := Value;
    Change;
//    ApplyDCB;
  end;
end;

// set event charachters
procedure TKOLMHComPort.SetEventChar(const Value: Char);
begin
  if Value <> FEventChar then
  begin
    FEventChar := Value;
    Change;
//    ApplyDCB;
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
procedure TKOLMHComPort.SetPort(const Value: TPort);
var
  Str: string;
begin
  Str := ComString(Value);
  if Str <> FPort then
  begin
    FPort := Str;
    Change;
{    if (FConnected) and (not ((csDesigning in ComponentState) or
      (csLoading in ComponentState))) then
    begin
      Close;
      Open;
    end;}
  end;
end;

// set stop bits
procedure TKOLMHComPort.SetStopBits(const Value: TStopBits);
begin
  if Value <> FStopBits then
  begin
    FStopBits := Value;
    Change;
//    ApplyDCB;
  end;
end;

// set event synchronization method
procedure TKOLMHComPort.SetSyncMethod(const Value: TSyncMethod);
begin
  if Value <> FSyncMethod then
  begin
{    if (FConnected) and (not ((csDesigning in ComponentState) or
      (csLoading in ComponentState)))
    then
      raise EComPort.CreateNoWinCode(CError_SyncMeth)
    else}
      FSyncMethod := Value;
      Change;
  end;
end;

// returns true if RxChar is triggered when data arrives input buffer
{function TKOLMHComPort.GetTriggersOnRxChar: Boolean;
var
  I: Integer;
  ComLink: TComLink;
begin
  Result := True;
  // examine links
  if FLinks.Count > 0 then
    for I := 0 to FLinks.Count - 1 do
    begin
      ComLink := TComLink(FLinks[I]);
      if Assigned(ComLink.OnRxBuf) then
        Result := False; // link found, do not call OnRxChar event, call OnRxBuf instead
    end;
end;
 }
// set flow control
procedure TKOLMHComPort.SetFlowControl(const Value: TComFlowControl);
begin
  FFlowControl.Assign(Value);
  Change;
//  ApplyDCB;
end;

// set parity
procedure TKOLMHComPort.SetParity(const Value: TComParity);
begin
  FParity.Assign(Value);
  Change;
//  ApplyDCB;
end;

// set timeouts
procedure TKOLMHComPort.SetTimeouts(const Value: TComTimeouts);
begin
  FTimeouts.Assign(Value);
  Change;
//  ApplyTimeouts;
end;

// set buffer
procedure TKOLMHComPort.SetBuffer(const Value: TComBuffer);
begin
  FBuffer.Assign(Value);
  Change;
//  ApplyBuffer;
end;

procedure TKOLMHComPort.SetOnRxChar(const Value:TRxCharEvent);
begin
  FOnRxChar:=Value;
  Change;
end;

procedure Register;
begin
  RegisterComponents('KOL', [TKOLMHComPort]);
end;

end.

