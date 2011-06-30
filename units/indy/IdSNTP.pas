// 27-nov-2002
unit IdSNTP;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdUDPClient;

const
  NTPMaxInt = 4294967297.0;

type
 // NTP Datagram format
  TNTPGram = packed record
    Head1: byte;
    Head2: byte;
    Head3: byte;
    Head4: byte;
    RootDelay: longint;
    RootDispersion: longint;
    RefID: longint;
    Ref1: longint;
    Ref2: longint;
    Org1: longint;
    Org2: longint;
    Rcv1: longint;
    Rcv2: longint;
    Xmit1: longint;
    Xmit2: longint;
  end;

  TLr = packed record
    L1: byte;
    L2: byte;
    L3: byte;
    L4: byte;
  end;

  TIdSNTP = object(TIdUDPClient)
  protected
    FDestinationTimestamp: TDateTime;
    FLocalClockOffset: TDateTime;
    FOriginateTimestamp: TDateTime;
    FReceiveTimestamp: TDateTime;
    FRoundTripDelay: TDateTime;
    FTransmitTimestamp: TDateTime;

    function Disregard(NTPMessage: TNTPGram): Boolean;
    function GetAdjustmentTime: TDateTime;
    function GetDateTime: TDateTime;
  public
     { constructor Create(AOwner: TComponent); override;
     } function SyncTime: Boolean;

    property AdjustmentTime: TDateTime read GetAdjustmentTime;
    property DateTime: TDateTime read GetDateTime;
    property RoundTripDelay: TDateTime read FRoundTripDelay;
    property Port default IdPORT_SNTP;
  end;
PIdSNTP=^TIdSNTP;
function NewIdSNTP(AOwner: PControl):PIdSNTP;

implementation

uses
  SysUtils;

function Flip(var Number: longint): longint;
var
  Number1,
    Number2: TLr;
begin
  Number1 := TLr(Number);
  Number2.L1 := Number1.L4;
  Number2.L2 := Number1.L3;
  Number2.L3 := Number1.L2;
  Number1.L4 := Number1.L1;
  Result := longint(Number2);
end;

procedure DateTimeToNTP(ADateTime: TDateTime; var Second, Fraction: longint);
var
  Value1,
    Value2: Double;
begin
  Value1 := ADateTime + TimeZoneBias - 2;
  Value1 := Value1 * 86400;
  Value2 := Value1;
  if Value2 > NTPMaxInt then
    Value2 := Value2 - NTPMaxInt;
  Second := Trunc(Value2);
  Value2 := ((Frac(Value1) * 1000) / 1000) * NTPMaxInt;
  if Value2 > NTPMaxInt then
    Value2 := Value2 - NTPMaxInt;
  Fraction := Trunc(Value2);
end;

function NTPToDateTime(Second, Fraction: longint): TDateTime;
var
  Value1,
    Value2: Double;
begin
  Value1 := Second;
  if Value1 < 0 then
  begin
    Value1 := NTPMaxInt + Value1 - 1;
  end;
  Value2 := Fraction;
  if Value2 < 0 then
  begin
    Value2 := NTPMaxInt + Value2 - 1;
  end;
  Value2 := Value2 / NTPMaxInt;
  Value2 := Trunc(Value2 * 1000) / 1000;
  Result := ((Value1 + Value2) / 86400);
  Result := Result - TimeZoneBias + 2;
end;

//constructor TIdSNTP.Create(AOwner: TComponent);
function NewIdSNTP(AOwner: PControl):PIdSNTP;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
//  Port := IdPORT_SNTP;
end;
end;

function TIdSNTP.Disregard(NTPMessage: TNTPGram): Boolean;
var
  Stratum, LeapIndicator: Integer;
begin
  LeapIndicator := (NTPMessage.Head1 and 192) shr 6;
  Stratum := NTPMessage.Head2;
  Result := (LeapIndicator = 3) or (Stratum > 15) or (Stratum = 0) or
    (((Int(FTransmitTimestamp)) = 0.0) and (Frac(FTransmitTimestamp) = 0.0));
end;

function TIdSNTP.GetAdjustmentTime: TDateTime;
begin
  Result := FLocalClockOffset;
end;

function TIdSNTP.GetDateTime: TDateTime;
var
  NTPDataGram: TNTPGram;
  ResultString: string;
begin
  FillChar(NTPDataGram, SizeOf(NTPDataGram), 0);
  NTPDataGram.Head1 := $1B;
  DateTimeToNTP(Now, NTPDataGram.Xmit1, NTPDataGram.Xmit2);
  NTPDataGram.Xmit1 := Flip(NTPDataGram.Xmit1);
  NTPDataGram.Xmit2 := Flip(NTPDataGram.Xmit2);
  SetLength(ResultString, SizeOf(NTPDataGram));
  Move(NTPDataGram, ResultString[1], SizeOf(NTPDataGram));
  BufferSize := SizeOf(NTPDataGram);
  Send(ResultString);
  ResultString := ReceiveString;
  if Length(ResultString) > 0 then
  begin
    FDestinationTimeStamp := Now;
    Result := NTPToDateTime(Flip(NTPDataGram.Xmit1), Flip(NTPDataGram.Xmit2));
    FOriginateTimeStamp := NTPToDateTime(Flip(NTPDataGram.Org1),
      Flip(NTPDataGram.Org2));
    FReceiveTimestamp := NTPToDateTime(Flip(NTPDataGram.Rcv1),
      Flip(NTPDataGram.Rcv2));
    FTransmitTimestamp := NTPToDateTime(Flip(NTPDataGram.Xmit1),
      Flip(NTPDataGram.Xmit2));
    FRoundTripDelay := (FDestinationTimestamp - FOriginateTimestamp) -
      (FReceiveTimestamp - FTransmitTimestamp);
    FLocalClockOffset := ((FReceiveTimestamp - FOriginateTimestamp) +
      (FTransmitTimestamp - FDestinationTimestamp)) / 2;
    if Disregard(NTPDataGram) then
    begin
      Result := 0.0;
    end;
  end
  else
  begin
    Result := 0.0;
  end;
end;

function TIdSNTP.SyncTime: Boolean;
begin
  Result := DateTime <> 0;
  if Result then
  begin
    result := SetLocalTime(FOriginateTimestamp + FLocalClockOffset +
      FRoundTripDelay);
  end;
end;

end.
