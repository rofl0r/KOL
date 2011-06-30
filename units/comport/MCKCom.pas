unit MCKCom;
{ "Зеркало" для работы с СОМ-портом. Минимально необходимые свойства.
  Очень короткий код. Передача осуществляется независимо от состояния
  модемных концов, прием идет асинхронно без ожидания паузы в байтах.
  Проверялся на 98/ХР. Версия КОЛ/МСК - 1.56}
// автор - Пивко Василий. 2002 г.

interface

uses
  KOL, KOLCom, Mirror, Classes, Windows;

type
  TKOLCom = class(TKOLObj)
  private
    FNum : byte;
    FBaudRate : DWord;
    FParity : TCommParity;
    FStopBits : TCommStopBits;
    FCtrDTR, FCtrRTS,
    FDTR, FRTS : boolean;
    FEventMask : TCommEvents;
    FLenTxBuff, FLenRxBuff : word;
    FOnRxByte : TComRxByte;
    FOnTxEmpty : TComTxEmpty;
    FOnModem : TComModem;
    FOnErr_Break : TComErr_Break;
    procedure SetNum(Value : byte);
    procedure SetLenTxBuff(Value : word);
    procedure SetLenRxBuff(Value : word);
    procedure SetCtrDTR(Value : boolean);
    procedure SetCtrRTS(Value : boolean);
    procedure SetsDTR(Value : boolean);
    procedure SetsRTS(Value : boolean);
    procedure SetBaudRate(Value : DWord);
    procedure SetStopBits(Value : TCommStopBits);
    procedure SetParity(Value : TCommParity);
    procedure SetEventMask(Value : TCommEvents);
    procedure SetOnRxByte(Value : TComRxByte);
    procedure SetOnTxEmpty(Value : TComTxEmpty);
    procedure SetOnErr_Break(Value : TComErr_Break);
    procedure SetOnModem(Value : TComModem);
  protected
    fNotAvailable : TOnEvent;
    function  AdditionalUnits: string; override;
    procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy;  override;
  published
    property NumPort : byte read FNum write SetNum;
    property LenTxBuff : word read FLenTxBuff write SetLenTxBuff;
    property LenRxBuff : word read FLenRxBuff write SetLenRxBuff;
    property CtrDTR : boolean read FCtrDTR write SetCtrDTR;
    property CtrRTS : boolean read FCtrRTS write SetCtrRTS;
    property DTR : boolean read FDTR write SetsDTR default False;
    property RTS : boolean read FRTS write SetsRTS default False;
    property BaudRate : DWord read FBaudRate write SetBaudRate;
    property StopBits : TCommStopBits read FStopBits write SetStopBits;
    property Parity : TCommParity read FParity write SetParity;
    property EventMask : TCommEvents read FEventMask write SetEventMask;
    property OnDestroy : TOnEvent read fNotAvailable;
    property OnRxByte : TComRxByte read FOnRxByte write SetOnRxByte;
    property OnTxEmpty : TComTxEmpty read FOnTxEmpty write SetOnTxEmpty;
    property OnModem : TComModem read FOnModem write SetOnModem;
    property OnErr_Break : TComErr_Break read FOnErr_Break write SetOnErr_Break;
  end;

procedure Register;

implementation
{$R *.RES}

constructor TKOLCom.Create(AOwner : TComponent);
begin
  inherited;
  FNum := 1;
  FBaudRate := 9600;
  FStopBits := Two;
  FParity := None;
  FLenTxBuff := 256;
  FLenRxBuff := 256;
  FEventMask := [evRxChar,evTxEmpty];
end;

destructor TKOLCom.Destroy;
begin
  inherited;
end;

function TKOLCom.AdditionalUnits;
begin
   Result := ', KOLCom';
end;

procedure TKOLCom.SetupFirst(SL: TStringList;const AName, AParent, Prefix: String);
const
  BoolStr:array [Boolean] of String=('False','True');
  StopBitsStr:array [TCommStopBits] of String=('One','Two');
  ParityBitsStr:array [TCommParity] of String=('None','Odd','Even','Mark','Space');
  ComEventStr:array [TCommEvent] of String=('evRxChar','evTxEmpty','evCTS','evDSR',
                                            'evRLSD','evBreak','evErr','evRing');
var
  tmpStr:String;
begin
  SL.Add('');
  SL.Add(Prefix+AName+':=NewKOLCom('+AParent+');');
  SL.Add(Prefix+AName+'.NumPort:='+Int2Str(NumPort)+';');
  SL.Add(Prefix+AName+'.BaudRate:='+Int2Str(BaudRate)+';');
  SL.Add(Prefix+AName+'.StopBits:='+StopBitsStr[StopBits]+';');
  tmpStr:='  ';
  if evRxChar in FEventMask then tmpStr := tmpStr + 'evRxChar, ';
  if evTxEmpty in FEventMask then tmpStr := tmpStr + 'evTxEmpty, ';
  if evRing in FEventMask then tmpStr := tmpStr + 'evRing, ';
  if evBreak in FEventMask then tmpStr := tmpStr + 'evBreak, ';
  if evCTS in FEventMask then tmpStr := tmpStr + 'evCTS, ';
  if evDSR in FEventMask then tmpStr := tmpStr + 'evDSR, ';
  if evErr in FEventMask then tmpStr := tmpStr + 'evErr, ';
  if evRLSD in FEventMask then tmpStr := tmpStr + 'evRLSD, ';
  tmpStr[Length(tmpStr)-1] := ' ';
  tmpStr := Trim(tmpStr);
  SL.Add(Prefix+AName+'.EventMask:=['+tmpStr+'];');
  SL.Add(Prefix+AName+'.CtrDTR:='+BoolStr[CtrDTR]+';');
  SL.Add(Prefix+AName+'.CtrRTS:='+BoolStr[CtrRTS]+';');
  if CtrDTR then SL.Add(Prefix+AName+'.DTR:='+BoolStr[DTR]+';');
  if CtrRTS then SL.Add(Prefix+AName+'.RTS:='+BoolStr[RTS]+';');
  if @OnErr_Break <> nil then
      SL.Add( Prefix + AName + '.OnErr_Break := Result.' +
              ParentForm.MethodName( @OnErr_Break ) + ';' );
  if @OnModem <> nil then
      SL.Add( Prefix + AName + '.OnModem := Result.' +
              ParentForm.MethodName( @OnModem ) + ';' );
  if @OnRxByte <> nil then
      SL.Add( Prefix + AName + '.OnRxByte := Result.' +
              ParentForm.MethodName( @OnRxByte ) + ';' );
  if @OnTxEmpty <> nil then
      SL.Add( Prefix + AName + '.OnTxEmpty := Result.' +
              ParentForm.MethodName( @OnTxEmpty ) + ';' );
end;

procedure TKOLCom.SetOnRxByte(Value : TComRxByte);
begin
  FOnRxByte := Value;
  Change;
end;

procedure TKOLCom.SetOnTxEmpty(Value : TComTxEmpty);
begin
  FOnTxEmpty := Value;
  Change;
end;

procedure TKOLCom.SetOnErr_Break(Value : TComErr_Break);
begin
  FOnErr_Break := Value;
  Change;
end;

procedure TKOLCom.SetOnModem(Value : TComModem);
begin
  FOnModem := Value;
  Change;
end;

procedure TKOLCom.SetBaudRate(Value : DWord);
begin
  if (Value <> FBaudRate) and (Value >= 110) and (Value <= 115200) then begin
    FBaudRate := Value;
    Change;
  end;
end;

procedure TKOLCom.SetParity(Value : TCommParity);
begin
  if (Value <> FParity) then begin
    FParity := Value;
    Change;
  end;
end;

procedure TKOLCom.SetStopBits(Value : TCommStopBits);
begin
  if (Value <> FStopBits) then begin
    FStopBits := Value;
    Change;
  end;
end;

procedure TKOLCom.SetCtrDTR(Value : boolean);
begin
  if (Value <> FCtrDTR) then begin
    FCtrDTR := Value;
    Change;
  end;
end;

procedure TKOLCom.SetCtrRTS(Value : boolean);
begin
  if (Value <> FCtrRTS) then begin
    FCtrRTS := Value;
    Change;
  end;
end;

procedure TKOLCom.SetsDTR(Value : boolean);
begin
  if (Value <> FDTR) then begin
    FDTR := Value;
    Change;
  end;
end;

procedure TKOLCom.SetsRTS(Value : boolean);
begin
  if (Value <> FRTS) then begin
    FRTS := Value;
    Change;
  end;
end;

procedure TKOLCom.SetEventMask(Value : TCommEvents);
begin
  if (Value <> FEventMask) then begin
    FEventMask := Value + [evRxChar,evTxEmpty];
    Change;
  end;
end;

procedure TKOLCom.SetNum(Value : byte);
begin
  if Value < 1 then Value := 1;
  if Value > 32 then Value := 32;
  if Value <> FNum then begin
    FNum := Value;
    Change;
  end;
end;

procedure TKOLCom.SetLenTxBuff(Value : word);
begin
  if Value < 256 then Value := 256;
  if (Value <> FLenTxBuff) then begin
    FLenTxBuff := Value;
    Change;
  end;
end;

procedure TKOLCom.SetLenRxBuff(Value : word);
begin
  if Value < 256 then Value := 256;
  if (Value <> FLenRxBuff) then begin
    FLenRxBuff := Value;
    Change;
  end;
end;

procedure Register;
begin
  RegisterComponents('KOL_Additional', [TKOLCom]);
end;

end.
