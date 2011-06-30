// 27-nov-2002
unit IdNetworkCalculator;

interface

uses KOL, 
  SysUtils { , Classes } , IdBaseComponent;

type
  TIpStruct = record
    case integer of
      0: (Byte4, Byte3, Byte2, Byte1: byte);
      1: (FullAddr: Longword);
  end;

  TNetworkClass = (ID_NET_CLASS_A, ID_NET_CLASS_B, ID_NET_CLASS_C,
    ID_NET_CLASS_D, ID_NET_CLASS_E);

const
  ID_NC_MASK_LENGTH = 32;
  ID_NETWORKCLASS = ID_NET_CLASS_A;

type
  TIpProperty = object(TObj)
  protected
    FReadOnly: boolean;
//    FOnChange: TNotifyEvent;
    FByteArray: array[0..31] of boolean;
    FDoubleWordValue: Longword;

    FAsString: string;
    FAsBinaryString: string;
    FByte3: Byte;
    FByte4: Byte;
    FByte2: Byte;
    FByte1: byte;
    procedure SetReadOnly(const Value: boolean);
//    procedure SetOnChange(const Value: TNotifyEvent);
    function GetByteArray(Index: cardinal): boolean;
    procedure SetAsBinaryString(const Value: string);
    procedure SetAsDoubleWord(const Value: Longword);
    procedure SetAsString(const Value: string);
    procedure SetByteArray(Index: cardinal; const Value: boolean);
    procedure SetByte4(const Value: Byte);
    procedure SetByte1(const Value: byte);
    procedure SetByte3(const Value: Byte);
    procedure SetByte2(const Value: Byte);
    //
    property ReadOnly: boolean read FReadOnly write SetReadOnly default false;
  public
    procedure SetAll(One, Two, Tree, Four: Byte); virtual;
    procedure Assign(Source: PObj);// override;
    //
    property ByteArray[Index: cardinal]: boolean read GetByteArray write
      SetByteArray;
   { published } 
    property Byte1: byte read FByte1 write SetByte1 stored false;
    property Byte2: Byte read FByte2 write SetByte2 stored false;
    property Byte3: Byte read FByte3 write SetByte3 stored false;
    property Byte4: Byte read FByte4 write SetByte4 stored false;
    property AsDoubleWord: Longword read FDoubleWordValue write SetAsDoubleWord
      stored false;
    property AsBinaryString: string read FAsBinaryString write SetAsBinaryString
      stored false;
    property AsString: string read FAsString write SetAsString;
//    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
  end;
PIpProperty=^TIpProperty;
type

  TIdNetworkCalculator = object(TIdBaseComponent)
  protected
    FListIP: PStrList;
    FNetworkMaskLength: cardinal;
    FNetworkMask: PIpProperty;
    FNetworkAddress: PIpProperty;
    FNetworkClass: TNetworkClass;
//    FOnChange: TNotifyEvent;
//    FOnGenIPList: TNotifyEvent;
//    procedure SetOnChange(const Value: TNotifyEvent);
//    procedure SetOnGenIPList(const Value: TNotifyEvent);
    function GetListIP: PStrList;
    procedure SetNetworkAddress(const Value: PIpProperty);
    procedure SetNetworkMask(const Value: PIpProperty);
    procedure SetNetworkMaskLength(const Value: cardinal);
    procedure OnNetMaskChange(Sender: TObject);
    procedure OnNetAddressChange(Sender: TObject);
  public
    function NumIP: integer;
    function StartIP: string;
    function EndIP: string;
    procedure FillIPList;
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
     virtual; //
    property ListIP: PStrList read GetListIP;
    property NetworkClass: TNetworkClass read FNetworkClass;
   { published } 
    function IsAddressInNetwork(Address: string): Boolean;
    property NetworkAddress: PIpProperty read FNetworkAddress write
      SetNetworkAddress;
    property NetworkMask: PIpProperty read FNetworkMask write SetNetworkMask;
    property NetworkMaskLength: cardinal read FNetworkMaskLength write
      SetNetworkMaskLength
    default ID_NC_MASK_LENGTH;
//    property OnGenIPList: TNotifyEvent read FOnGenIPList write SetOnGenIPList;
//    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
  end;
PIdNetworkCalculator=^TIdNetworkCalculator;
function NewIdNetworkCalculator(AOwner: PControl):PIdNetworkCalculator;
function NewIpProperty:PIpProperty;

implementation

uses
  IdGlobal, IdResourceStrings;

function NewIpProperty:PIpProperty;
begin
  New( Result, Create );
end;

function IP(Byte1, Byte2, Byte3, Byte4: byte): TIpStruct;
begin
  result.Byte1 := Byte1;
  result.Byte2 := Byte2;
  result.Byte3 := Byte3;
  result.Byte4 := Byte4;
end;

function StrToIP(const value: string): TIPStruct;
var
  strBuffers: array[0..3] of string;
  cardBuffers: array[0..3] of cardinal;
  StrWork: string;
begin
  StrWork := Value;
  strBuffers[0] := Fetch(StrWork, '.', true);
  strBuffers[1] := Fetch(StrWork, '.', true);
  strBuffers[2] := Fetch(StrWork, '.', true);
  strBuffers[3] := StrWork;
  try
    cardBuffers[0] := StrToInt(strBuffers[0]);
    cardBuffers[1] := StrToInt(strBuffers[1]);
    cardBuffers[2] := StrToInt(strBuffers[2]);
    cardBuffers[3] := StrToInt(strBuffers[3]);
  except
    on e: exception do
      raise exception.Create(Format(RSNETCALInvalidIPString, [Value]));
  end;
  if not (cardBuffers[0] in [0..255]) then
    raise exception.Create(Format(RSNETCALInvalidIPString, [Value]));
  if not (cardBuffers[1] in [0..255]) then
    raise exception.Create(Format(RSNETCALInvalidIPString, [Value]));
  if not (cardBuffers[2] in [0..255]) then
    raise exception.Create(Format(RSNETCALInvalidIPString, [Value]));
  if not (cardBuffers[3] in [0..255]) then
    raise exception.Create(Format(RSNETCALInvalidIPString, [Value]));
  result := IP(cardBuffers[0], cardBuffers[1], cardBuffers[2], cardBuffers[3]);
end;

//constructor TIdNetworkCalculator.Create(AOwner: TComponent);
function NewIdNetworkCalculator(AOwner: PControl):PIdNetworkCalculator;
begin
  New( Result, Create );
with Result^ do
//  inherited;
begin
  FNetworkMask := NewIpProperty;//TIpProperty.Create;
  FNetworkAddress := NewIpProperty;//TIpProperty.Create;

//  FNetworkMask.OnChange := OnNetMaskChange;
//  FNetworkAddress.OnChange := OnNetAddressChange;
  FListIP := NewStrList;//TStringList.Create;
  FNetworkClass := ID_NETWORKCLASS;
  NetworkMaskLength := ID_NC_MASK_LENGTH;
end;
end;

destructor TIdNetworkCalculator.Destroy;
begin
  FNetworkMask.Free;
  FNetworkAddress.Free;
  FListIP.Free;
  inherited;
end;

procedure TIdNetworkCalculator.FillIPList;
var
  i: Cardinal;
  BaseIP: TIpStruct;
begin
  if FListIP.Count = 0 then
  begin
   { if (csDesigning in ComponentState) and (NumIP > 1024) then
    begin
      FListIP.text := Format(RSNETCALConfirmLongIPList, [NumIP]);
    end
    else}
    begin
      BaseIP.FullAddr := NetworkAddress.AsDoubleWord and
        NetworkMask.AsDoubleWord;
//      FListIP.Capacity := NumIP;
//      FListIP.BeginUpdate;
      try
        for i := 1 to (NumIP - 1) do
        begin
          Inc(BaseIP.FullAddr);
//          FListIP.append(format('%d.%d.%d.%d', [BaseIP.Byte1, BaseIP.Byte2,
//            BaseIP.Byte3, BaseIP.Byte4]));
        end;
      finally
//        FListIP.EndUpdate;
      end;
    end;
  end;
end;

function TIdNetworkCalculator.GetListIP: PStrList;
begin
  FillIPList;
  result := FListIP;
end;

function TIdNetworkCalculator.IsAddressInNetwork(Address: string): Boolean;
var
  IPStruct: TIPStruct;
begin
  IPStruct := StrToIP(Address);
  result := (IPStruct.FullAddr and NetworkMask.FDoubleWordValue) =
    (NetworkAddress.FDoubleWordValue and NetworkMask.FDoubleWordValue);
end;

procedure TIdNetworkCalculator.OnNetAddressChange(Sender: TObject);
begin
  FListIP.Clear;
  if IndyPos('0', NetworkAddress.AsBinaryString) = 1 then
  begin
    fNetworkClass := ID_NET_CLASS_A;
  end;
  if IndyPos('10', NetworkAddress.AsBinaryString) = 1 then
  begin
    fNetworkClass := ID_NET_CLASS_B;
  end;
  if IndyPos('110', NetworkAddress.AsBinaryString) = 1 then
  begin
    fNetworkClass := ID_NET_CLASS_C;
  end;
  if IndyPos('1110', NetworkAddress.AsBinaryString) = 1 then
  begin
    fNetworkClass := ID_NET_CLASS_D;
  end;
  if IndyPos('1111', NetworkAddress.AsBinaryString) = 1 then
  begin
    fNetworkClass := ID_NET_CLASS_E;
  end;
//  if assigned(FOnChange) then
//    FOnChange(Self);
end;

procedure TIdNetworkCalculator.OnNetMaskChange(Sender: TObject);
var
  sBuffer: string;
  InitialMaskLength: Cardinal;
begin
  FListIP.Clear;
  InitialMaskLength := FNetworkMaskLength;
  sBuffer := FNetworkMask.AsBinaryString;
  while (length(sBuffer) > 0) and (sBuffer[1] = '1') do
  begin
    Delete(sBuffer, 1, 1);
  end;

  if IndyPos('1', sBuffer) > 0 then
  begin
    NetworkMaskLength := InitialMaskLength;
    raise exception.Create(RSNETCALCInvalidNetworkMask);
  end
  else
  begin
    NetworkMaskLength := 32 - Length(sBuffer);
  end;
//  if assigned(FOnChange) then
//    FOnChange(Self);
end;

procedure TIdNetworkCalculator.SetNetworkAddress(const Value: PIpProperty);
begin
  FNetworkAddress.Assign(Value);
end;

procedure TIdNetworkCalculator.SetNetworkMask(const Value: PIpProperty);
begin
  FNetworkMask.Assign(Value);
end;

procedure TIdNetworkCalculator.SetNetworkMaskLength(const Value: cardinal);
var
  LBuffer: Cardinal;
begin
  FNetworkMaskLength := Value;
  if Value > 0 then
  begin
    LBuffer := High(Cardinal) shl (32 - Value);
  end
  else
  begin
    LBuffer := 0;
  end;
  FNetworkMask.AsDoubleWord := LBuffer;
end;

{procedure TIdNetworkCalculator.SetOnGenIPList(const Value: TNotifyEvent);
begin
  FOnGenIPList := Value;
end;
}

{procedure TIdNetworkCalculator.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;
}
procedure TIpProperty.Assign(Source: PObj);
begin
//  if Source is TIpProperty then
    with PIpProperty(source)^{ as TIpProperty} do
    begin
      Self.SetAll(Byte1, Byte2, Byte3, Byte4);
    end;
//  if assigned(FOnChange) then
//    FOnChange(Self);
  inherited;
end;

function TIpProperty.GetByteArray(Index: cardinal): boolean;
begin
  result := FByteArray[index]
end;

procedure TIpProperty.SetAll(One, Two, Tree, Four: Byte);
var
  i: Integer;
  InitialIP, IpStruct: TIpStruct;
begin
  InitialIP := IP(FByte1, FByte2, FByte3, FByte4);
  FByte1 := One;
  FByte2 := Two;
  FByte3 := Tree;
  FByte4 := Four;
  IpStruct.Byte1 := Byte1;
  IpStruct.Byte2 := Byte2;
  IpStruct.Byte3 := Byte3;
  IpStruct.Byte4 := Byte4;
  FDoubleWordValue := IpStruct.FullAddr;
  SetLength(FAsBinaryString, 32);
  for i := 1 to 32 do
  begin
    FByteArray[i - 1] := ((FDoubleWordValue shl (i - 1)) shr 31) = 1;
    if FByteArray[i - 1] then
      FAsBinaryString[i] := '1'
    else
      FAsBinaryString[i] := '0';
  end;
  FAsString := Format('%d.%d.%d.%d', [FByte1, FByte2, FByte3, FByte4]);
  IpStruct := IP(FByte1, FByte2, FByte3, FByte4);
  if IpStruct.FullAddr <> InitialIP.FullAddr then
  begin
//    if assigned(FOnChange) then
//      FOnChange(self);
  end;
end;

procedure TIpProperty.SetAsBinaryString(const Value: string);
var
  IPStruct: TIPStruct;
  i: Integer;
begin
  if ReadOnly then
    exit;
  if Length(Value) <> 32 then
    raise Exception.Create(RSNETCALCInvalidValueLength)
  else
  begin
    if not AnsiSameText(Value, FAsBinaryString) then
    begin
      IPStruct.FullAddr := 0;
      for i := 1 to 32 do
      begin
        if Value[i] <> '0' then
          IPStruct.FullAddr := IPStruct.FullAddr + (1 shl (32 - i));
        SetAll(IPStruct.Byte1, IPStruct.Byte2, IPStruct.Byte3, IPStruct.Byte4);
      end;
    end;
  end;
end;

procedure TIpProperty.SetAsDoubleWord(const Value: Cardinal);
var
  IpStruct: TIpStruct;
begin
  if ReadOnly then
    exit;
  IpStruct.FullAddr := value;
  SetAll(IpStruct.Byte1, IpStruct.Byte2, IpStruct.Byte3, IpStruct.Byte4);
end;

procedure TIpProperty.SetAsString(const Value: string);
var
  IPStruct: TIPStruct;
begin
  if ReadOnly then
    exit;
  IPStruct := StrToIP(value);
  SetAll(IPStruct.Byte1, IPStruct.Byte2, IPStruct.Byte3, IPStruct.Byte4);
end;

procedure TIpProperty.SetByteArray(Index: cardinal; const Value: boolean);
var
  IPStruct: TIpStruct;
begin
  if ReadOnly then
    exit;
  if FByteArray[Index] <> value then
  begin
    FByteArray[Index] := Value;
    IPStruct.FullAddr := FDoubleWordValue;

    if Value then
      IPStruct.FullAddr := IPStruct.FullAddr + (1 shl index)
    else
      IPStruct.FullAddr := IPStruct.FullAddr - (1 shl index);
    SetAll(IPStruct.Byte1, IPStruct.Byte2, IPStruct.Byte3, IPStruct.Byte4);
  end;
end;

procedure TIpProperty.SetByte4(const Value: Byte);
begin
  if ReadOnly then
    exit;
  if FByte4 <> value then
  begin
    FByte4 := Value;
    SetAll(FByte1, FByte2, FByte3, FByte4);
  end;
end;

procedure TIpProperty.SetByte1(const Value: byte);
begin
  if FByte1 <> value then
  begin
    FByte1 := Value;
    SetAll(FByte1, FByte2, FByte3, FByte4);
  end;
end;

procedure TIpProperty.SetByte3(const Value: Byte);
begin
  if FByte3 <> value then
  begin
    FByte3 := Value;
    SetAll(FByte1, FByte2, FByte3, FByte4);
  end;
end;

procedure TIpProperty.SetByte2(const Value: Byte);
begin
  if ReadOnly then
    exit;
  if FByte2 <> value then
  begin
    FByte2 := Value;
    SetAll(FByte1, FByte2, FByte3, FByte4);
  end;
end;

{procedure TIpProperty.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;
}
procedure TIpProperty.SetReadOnly(const Value: boolean);
begin
  FReadOnly := Value;
end;

function TIdNetworkCalculator.EndIP: string;
var
  IP: TIpStruct;
begin
  IP.FullAddr := NetworkAddress.AsDoubleWord and NetworkMask.AsDoubleWord;
  Inc(IP.FullAddr, NumIP - 2);
  result := Format('%d.%d.%d.%d', [IP.Byte1, IP.Byte2, IP.Byte3, IP.Byte4]);
end;

function TIdNetworkCalculator.NumIP: integer;
begin
  NumIP := 1 shl (32 - NetworkMaskLength);
end;

function TIdNetworkCalculator.StartIP: string;
var
  IP: TIpStruct;
begin
  IP.FullAddr := NetworkAddress.AsDoubleWord and NetworkMask.AsDoubleWord;
  result := Format('%d.%d.%d.%d', [IP.Byte1, IP.Byte2, IP.Byte3, IP.Byte4]);
end;

end.
