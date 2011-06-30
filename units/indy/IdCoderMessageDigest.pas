// 25-nov-2002
unit IdCoderMessageDigest;

interface

uses KOL { , 
  Classes } ,
  IdCoder;

type
  T64BitRecord = array[0..7] of byte;
  T128BitRecord = array[0..15] of byte;
  T4x4LongWordRecord = array[0..3] of LongWord;
  T4x4x4LongWordRecord = array[0..3] of T4x4LongWordRecord;
  T16x4LongWordRecord = array[0..15] of LongWord;

  T160BitRecord = array[0..19] of byte;
  T384BitRecord = array[0..47] of byte;

  { RSA-MD2
    Copyright:    R.L. Rivest, A. Shamir, and L. Adleman (RSA)
    Licensing:    "Free of licensing" from RFC 1115
                  "Free for non-commercial use" from RFC 1319
    RFCs:         1115, 1319
    Digest Size : 16 bytes / 128 bits
    Used In:      PEM III (RFC 1423), DASS (RFC 1507), Randomness Recs. (RFC
                  1750), PKCS #1 (RFC 2313), PKCS #7 (RFC 2315), OpenPGP
                  Format (RFC 2440), X.509 PKI Cert & CRL (RFC 2459), Secure
                  HTTP (RFC 2660)
  }
  TIdCoderMD2 = object(TIdCoder)
  protected
    FBuffer: T128BitRecord;
    FChecksum: T128BitRecord;
    FCount: Integer;
    FCheckSumScore: Byte;
    FState: T128BitRecord;
    FX: T384BitRecord;

    procedure Coder; override;
    procedure CompleteCoding; override;
  public
     { constructor Create(AOwner: TComponent); override;
     } procedure Reset; override;

    procedure FillSamples(AStringList: TStrings); virtual;
    procedure SetBufferSize(ASize: LongWord); override;
  end;
PIdCoderMD2=^TIdCoderMD2;
function NewIdCoderMD2(AOwner: PControl):PIdCoderMD2;
type

  { RSA-MD4
    Copyright:    R.L. Rivest, A. Shamir, and L. Adleman (RSA)
    Licensing:    Free - "public domain" - as of RFC 1186
    RFCs:         1186, 1320
    Digest Size : 16B / 128b
    Used In:      Kerberos v5 (RFC 1510), Randomness Recs. (RFC 1750), S/KEY
                  one-time password (RFC 1760), One-time password (RFC 1938,
                  2289), PKCS #1 (RFC 2313)
  }
  TIdCoderMD4 = object(TIdCoder)
  protected
    FBitsProcessed: LongWord;
    FBuffer: T4x4LongWordRecord;
    FCount: T64BitRecord;
    FDone: Boolean;

    procedure Coder; override;
    procedure CompleteCoding; override;
    function func_f(x, y, z: LongWord): LongWord; virtual;
    function func_g(x, y, z: LongWord): LongWord; virtual;
    function func_h(x, y, z: LongWord): LongWord; virtual;
  public
     { constructor Create(AOwner: TComponent); override;
     } procedure Reset; override;

    procedure FillSamples(AStringList: TStrings); virtual;
    procedure SetBufferSize(ASize: LongWord); override;
  end;
PidCoderMD4=^TIdCoderMD4;
function NewdCoderMD4(AOwner: PControl):PidCoderMD4;
type

  { RSA-MD5
    Copyright:    R.L. Rivest, A. Shamir, and L. Adleman (RSA)
    Licensing:    Free - "public domain" - as of RFC 1321
    RFCs:         1321
    Digest Size : 16B / 128b
    Used In:      SNMP (RFC 1352), PEM III (RFC 1423), SNMPv2 (RFC 1446,
                  1910), Kerberos v5 (RFC 1510), Randomness Recs. (RFC 1750),
                  SNTP (RFC 1361), IP Auth. Head. (RFC 1826, 1828), One-time
                  password (RFC 1938, 2289), Scalable Multicast Key
                  Distribution (RFC 1949), PGP Message Exchange Formats
                  (RFC 1991), IP Mobility Support (RFC 2002), RADIUS
                  (RFC 2058, 2138), Domain Name Security System (RFC 2065),
                  RIP-2 MD5 Auth. (RFC 2082), IMAP / POP AUTH (RFC 2095, 2195),
                  SLP (RFC 2165), OSPF v2 (RFC 2178, 2328, 2329, 2370), TLS v1
                  (RFC 2246), SNMPv3 (RFC 2264, 2274, 2570, 2574), S/MIME v2
                  (RFC 2311), PKCS #1 (RFC 2313), PKCS #7 (RFC 2315), IKE
                  (RFC 2409), OpenPGP Format (RFC 2440), One-time password
                  SASL (RFC 2444), X.509 PKI Cert & CRL (RFC 2459), RSA/MD5
                  KEYs & SIGs in DNS (RFC 2537), Cryptographic Message Syntax
                  (RFC 2630), S/MIME v3 (RFC 2633), Secure HTTP (RFC 2660),
                  Level Two Tunneling Protocol (RFC 2661)
  }
  TIdCoderMD5 = object(TIdCoderMD4)
  protected
    procedure Coder; override;
    function func_g(x, y, z: LongWord): LongWord; override;
    function func_i(x, y, z: LongWord): LongWord; virtual;
  public
     { constructor Create(AOwner: TComponent); override;
     } procedure FillSamples(AStringList: TStrings); override;
  end;
PidCoderMD5=^TidCoderMD5;
function NewCoderMD5(AOwner: PControl):PCoderMD5;
type

  { NIST-SHA1
    Copyright:    National Institute of Standards and Technology (NIST)
    Licensing:
    RFCs / Oth.:  FIPS 180
    Digest Size:
    Used In:      One-time password (RFC 1938, 2289), TLS v1 (RFC 2246),
                  SNMPv3 (RFC 2264, 2274, 2570, 2574), S/MIME v2 (RFC 2311),
                  IKE (RFC 2409), OpenPGP Format (RFC 2440), One-time
                  password SASL (RFC 2444), X.509 PKI Cert & CRL (RFC 2459),
                  Cryptographic Message Syntax (RFC 2630), Diffie-Hellman Key
                  Agreement (RFC 2631), S/MIME v3 (RFC 2633), Enhanced
                  Security Services for S/MIME (RFC 2634), Secure HTTP
                  (RFC 2660)
  }

  { RIPEMD
    Copyright:
    Licensing:
    RFCs / Oth.:
    Digest Size:
    Used In:      OpenPGP Format (RFC 2440)
  }

  { TIGER
    Copyright:
    Licensing:
    RFCs / Oth.:
    Digest Size:
    Used In:      OpenPGP Format (RFC 2440)
  }

  { HAVAL
    Copyright:
    Licensing:
    RFCs / Oth.:
    Digest Size:
    Used In:      OpenPGP Format (RFC 2440)
  }

implementation

uses
  IdGlobal,
  IdMIMETypes;

const
  MD2_PI_SUBST: array[0..255] of byte = (
    41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240,
    6, 19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217,
    188, 76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66,
    111, 24, 138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73,
    160, 251, 245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178,
    7, 63, 148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154,
    90, 144, 50, 39, 53, 62, 204, 231, 191, 247, 151, 3, 255, 25,
    48, 179, 72, 165, 181, 209, 215, 94, 146, 42, 172, 86, 170, 198,
    79, 184, 56, 210, 150, 164, 125, 182, 118, 252, 107, 226, 156, 116,
    4, 241, 69, 157, 112, 89, 100, 113, 135, 32, 134, 91, 207, 101,
    230, 45, 168, 2, 27, 96, 37, 173, 174, 176, 185, 246, 28, 70,
    97, 105, 52, 64, 126, 15, 85, 71, 163, 35, 221, 81, 175, 58,
    195, 92, 249, 206, 186, 197, 234, 38, 44, 83, 13, 110, 133, 40,
    132, 9, 211, 223, 205, 244, 65, 129, 77, 82, 106, 220, 55, 200,
    108, 193, 171, 250, 36, 225, 123, 8, 12, 189, 177, 74, 120, 136,
    149, 139, 227, 99, 232, 109, 233, 203, 213, 254, 59, 0, 29, 57,
    242, 239, 183, 14, 102, 88, 208, 228, 166, 119, 114, 248, 235, 117,
    75, 10, 49, 68, 80, 180, 143, 237, 31, 26, 219, 153, 141, 51,
    159, 17, 131, 20);


function NewIdCoderMD2(AOwner: PControl):PIdCoderMD2;
    //constructor TIdCoderMD2.Create;
var
  i: Integer;
begin
  New( Result, Create );
with Result^ do
begin
//  inherited Create(AOwner);
  InternSetBufferSize(16);
  FCount := 0;
  i := 0;
  FAddCRLF := False;
  repeat
    FState[i] := 0;
    FChecksum[i] := 0;
    Inc(i);
  until i = 16;
end;  
end;

procedure TIdCoderMD2.Reset;
var
  i: Integer;
begin
  FCount := 0;
  i := 0;
  repeat
    FState[i] := 0;
    FChecksum[i] := 0;
    Inc(i);
  until i = 16;
  FInCompletion := False;
end;

procedure TIdCoderMD2.SetBufferSize;
begin

end;

procedure TIdCoderMD2.Coder;
var
  i, j, k: Byte;
  t: Byte;
const
  NumRounds = 18;
begin
  for J := Low(FChecksum) to High(FChecksum) do
  begin
    FCheckSumScore := FChecksum[j] xor MD2_PI_SUBST[Byte(FCBuffer[J + 1])
      xor FCheckSumScore];
    FChecksum[j] := FCheckSumScore;
  end;

  i := 0;
  for J := 0 to 15 do
  begin
    FX[i + 16] := Byte(FCBuffer[i + 1]);
    FX[i + 32] := FX[i + 16] xor FX[i];
    Inc(i);
  end;

  T := 0;
  for J := 0 to NumRounds - 1 do
  begin
    for K := Low(FX) to High(FX) do
    begin
      T := FX[k] xor MD2_PI_SUBST[T];
      FX[k] := T;
    end;
    Inc(T, J);
  end;

  System.Move(FX[0], FState[0], 16);
  FCBufferedData := 0;
end;

procedure TIdCoderMD2.CompleteCoding;
var
  index, padLen: Integer;
  padding: T128BitRecord;
  s: string;
begin
  FInCompletion := True;

  index := FCBufferedData;
  padLen := 16 - index;

  padding := FBuffer;
  FillChar(padding[index], padLen, padLen);
  System.Move(padding[16 - padLen], FCBuffer[17 - padLen], padLen);

  Coder;

  System.Move(FChecksum[0], FCBuffer[1], FCBufferSize);
  Coder;

  SetLength(s, FCBufferSize);
  UniqueString(s);
  System.Move(FState[0], s[1], FCBufferSize);
  OutputString(s);
end;

procedure TIdCoderMD2.FillSamples(AStringList: TStrings);
begin
  with AStringList do
  begin
    Add(''); {Do not localize}
    Add('  8350E5A3E24C153DF2275C9F80692773'); {Do not localize}
    Add('a'); {Do not localize}
    Add('  32EC01EC4A6DAC72C0AB96FB34C0B5D1'); {Do not localize}
    Add('abc'); {Do not localize}
    Add('  DA853B0D3F88D99B30283A69E6DED6BB'); {Do not localize}
    Add('message digest'); {Do not localize}
    Add('  AB4F496BFB2A530B219FF33031FE06B0'); {Do not localize}
    Add('abcdefghijklmnopqrstuvwxyz'); {Do not localize}
    Add('  4E8DDFF3650292AB5A4108C3AA47940B'); {Do not localize}
    Add('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
      {Do not localize}
    Add('  DA33DEF2A42DF13975352846C30338CD'); {Do not localize}
    Add('12345678901234567890123456789012345678901234567890123456789012345678901234567890'); {Do not localize}
    Add('  D5976F79D83D3A0DC9806C3C66F3EFD8'); {Do not localize}
  end;
end;

const
  MD4_INIT_VALUES: T4x4LongWordRecord = (
    $67452301, $EFCDAB89, $98BADCFE, $10325476);

    function NewdCoderMD4(AOwner: PControl):PidCoderMD4;
    //constructor TIdCoderMD4.Create;
begin
//  inherited;
  New( Result, Create );
with Result^ do
begin
  InternSetBufferSize(64);
  FBuffer := MD4_INIT_VALUES;
  FillChar(FCount, 8, 0);
  FDone := False;
  FAddCRLF := False;
  FBitsProcessed := 0;
end;
end;

procedure TIdCoderMD4.Reset;
begin
  FBuffer := MD4_INIT_VALUES;
  FillChar(FCount, 8, 0);
  FDone := False;
  FInCompletion := False;
  FBitsProcessed := 0;
end;

procedure TIdCoderMD4.SetBufferSize;
begin

end;

procedure TIdCoderMD4.Coder;
var
  A, B, C, D, i: LongWord;
  buff: T4x4x4LongWordRecord;
begin
  A := FBuffer[0];
  B := FBuffer[1];
  C := FBuffer[2];
  D := FBuffer[3];

  System.Move(FCBuffer[1], buff[0], SizeOf(buff));

  for i := 0 to 3 do
  begin
    A := ROL((A + func_f(B, C, D) + buff[i, 0]), 3);
    D := ROL((D + func_f(A, B, C) + buff[i, 1]), 7);
    C := ROL((C + func_f(D, A, B) + buff[i, 2]), 11);
    B := ROL((B + func_f(C, D, A) + buff[i, 3]), 19);
  end;

  for i := 0 to 3 do
  begin
    A := ROL((A + func_g(B, C, D) + buff[0, i]) + $5A827999, 3);
    D := ROL((D + func_g(A, B, C) + buff[1, i]) + $5A827999, 5);
    C := ROL((C + func_g(D, A, B) + buff[2, i]) + $5A827999, 9);
    B := ROL((B + func_g(C, D, A) + buff[3, i]) + $5A827999, 13);
  end;

  A := ROL((A + func_h(B, C, D) + T16x4LongWordRecord(buff)[0]) + $6ED9EBA1, 3);
  D := ROL((D + func_h(A, B, C) + T16x4LongWordRecord(buff)[8]) + $6ED9EBA1, 9);
  C := ROL((C + func_h(D, A, B) + T16x4LongWordRecord(buff)[4]) + $6ED9EBA1,
    11);
  B := ROL((B + func_h(C, D, A) + T16x4LongWordRecord(buff)[12]) + $6ED9EBA1,
    15);
  A := ROL((A + func_h(B, C, D) + T16x4LongWordRecord(buff)[2]) + $6ED9EBA1, 3);
  D := ROL((D + func_h(A, B, C) + T16x4LongWordRecord(buff)[10]) + $6ED9EBA1,
    9);
  C := ROL((C + func_h(D, A, B) + T16x4LongWordRecord(buff)[6]) + $6ED9EBA1,
    11);
  B := ROL((B + func_h(C, D, A) + T16x4LongWordRecord(buff)[14]) + $6ED9EBA1,
    15);
  A := ROL((A + func_h(B, C, D) + T16x4LongWordRecord(buff)[1]) + $6ED9EBA1, 3);
  D := ROL((D + func_h(A, B, C) + T16x4LongWordRecord(buff)[9]) + $6ED9EBA1, 9);
  C := ROL((C + func_h(D, A, B) + T16x4LongWordRecord(buff)[5]) + $6ED9EBA1,
    11);
  B := ROL((B + func_h(C, D, A) + T16x4LongWordRecord(buff)[13]) + $6ED9EBA1,
    15);
  A := ROL((A + func_h(B, C, D) + T16x4LongWordRecord(buff)[3]) + $6ED9EBA1, 3);
  D := ROL((D + func_h(A, B, C) + T16x4LongWordRecord(buff)[11]) + $6ED9EBA1,
    9);
  C := ROL((C + func_h(D, A, B) + T16x4LongWordRecord(buff)[7]) + $6ED9EBA1,
    11);
  B := ROL((B + func_h(C, D, A) + T16x4LongWordRecord(buff)[15]) + $6ED9EBA1,
    15);

  Inc(FBuffer[0], A);
  Inc(FBuffer[1], B);
  Inc(FBuffer[2], C);
  Inc(FBuffer[3], D);

  FCBufferedData := 0;
end;

procedure TIdCoderMD4.CompleteCoding;
var
  bCount: LongWord;
  s: string;
begin
  FInCompletion := True;
  if FCBufferedData >= FCBufferSize then
  begin
    Coder;
  end;
  Inc(FCBufferedData);
  FCBuffer[FCBufferedData] := Chr($80);

  bCount := FCBufferSize - FCBufferedData;

  if bCount < 8 then
  begin
    FillChar(FCBuffer[FCBufferedData], bCount, 0);
    FCBufferedData := FCBufferSize;
    Coder;
    bCount := FCBufferSize;
  end;

  if bCount > FCBufferSize then
  begin
    FillChar(FCBuffer[FCBufferedData + 1], FCBufferSize - FCBufferedData, 0);
    Coder;
    Dec(bCount, FCBufferSize);
    FillChar(FCBuffer[1], FCBufferSize, 0);
    FCBufferedData := FCBufferSize;
    while bCount > FCBufferSize do
    begin
      Coder;
      Dec(bCount, FCBufferSize);
    end;
  end;

  FillChar(FCBuffer[FCBufferedData + 1], bCount - 8, 0);
  bCount := ByteCount.L shl 3;
  System.Move(bCount, FCBuffer[FCBufferSize - 7], 4);
  bCount := (ByteCount.H shl 3) or (ByteCount.L shr 29);
  System.Move(bCount, FCBuffer[FCBufferSize - 3], 4);
  FCBufferedData := FCBufferSize;
  Coder;
  SetLength(s, 16);
  UniqueString(s);
  System.Move(FBuffer[0], s[1], 16);
  OutputString(s);
end;

procedure TIdCoderMD4.FillSamples(AStringList: TStrings);
begin
  with AStringList do
  begin
    Add('');
    Add('  31D6CFE0D16AE931B73C59D7E0C089C0'); {Do not localize}
    Add('a'); {Do not localize}
    Add('  BDE52CB31DE33E46245E05FBDBD6FB24'); {Do not localize}
    Add('abc'); {Do not localize}
    Add('  A448017AAF21D8525FC10AE87AA6729D'); {Do not localize}
    Add('message digest'); {Do not localize}
    Add('  D9130A8164549FE818874806E1C7014B'); {Do not localize}
    Add('abcdefghijklmnopqrstuvwxyz'); {Do not localize}
    Add('  D79E1C308AA5BBCDEEA8ED63DF412DA9'); {Do not localize}
    Add('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
      {Do not localize}
    Add('  043F8582F241DB351CE627E153E7F0E4'); {Do not localize}
    Add('12345678901234567890123456789012345678901234567890123456789012345678901234567890'); {Do not localize}
    Add('  E33B4DDC9C38F2199C3E7B164FCC0536'); {Do not localize}
  end;
end;

function TIdCoderMD4.func_f(x, y, z: LongWord): LongWord;
begin
  result := (x and y) or ((not x) and z);
end;

function TIdCoderMD4.func_g(x, y, z: LongWord): LongWord;
begin
  result := (x and y) or (x and z) or (y and z);
end;

function TIdCoderMD4.func_h(x, y, z: LongWord): LongWord;
begin
  result := x xor y xor z;
end;

const
  MD5_SINE: array[1..64] of LongWord = (
   { Round 1. }
    $D76AA478, $E8C7B756, $242070DB, $C1BDCEEE, $F57C0FAF, $4787C62A,
    $A8304613, $FD469501, $698098D8, $8B44F7AF, $FFFF5BB1, $895CD7BE,
    $6B901122, $FD987193, $A679438E, $49B40821,
   { Round 2. }
    $F61E2562, $C040B340, $265E5A51, $E9B6C7AA, $D62F105D, $02441453,
    $D8A1E681, $E7D3FBC8, $21E1CDE6, $C33707D6, $F4D50D87, $455A14ED,
    $A9E3E905, $FCEFA3F8, $676F02D9, $8D2A4C8A,
   { Round 3. }
    $FFFA3942, $8771F681, $6D9D6122, $FDE5380C, $A4BEEA44, $4BDECFA9,
    $F6BB4B60, $BEBFBC70, $289B7EC6, $EAA127FA, $D4EF3085, $04881D05,
    $D9D4D039, $E6DB99E5, $1FA27CF8, $C4AC5665,
   { Round 4. }
    $F4292244, $432AFF97, $AB9423A7, $FC93A039, $655B59C3, $8F0CCC92,
    $FFEFF47D, $85845DD1, $6FA87E4F, $FE2CE6E0, $A3014314, $4E0811A1,
    $F7537E82, $BD3AF235, $2AD7D2BB, $EB86D391
    );

//constructor TIdCoderMD5.Create;
function NewdCoderMD5(AOwner: PControl):PidCoderMD5;
begin
//  inherited Create(AOwner);
  New( Result, Create );
with Result^ do
  InternSetBufferSize(64);
end;

procedure TIdCoderMD5.Coder;
var
  A, B, C, D: LongWord;
  buff: T16x4LongWordRecord;
begin
  A := FBuffer[0];
  B := FBuffer[1];
  C := FBuffer[2];
  D := FBuffer[3];

  System.Move(FCBuffer[1], buff[0], SizeOf(buff));

  A := B + ROL((A + func_f(B, C, D) + buff[0] + MD5_SINE[1]), 7);
  D := A + ROL((D + func_f(A, B, C) + buff[1] + MD5_SINE[2]), 12);
  C := D + ROL((C + func_f(D, A, B) + buff[2] + MD5_SINE[3]), 17);
  B := C + ROL((B + func_f(C, D, A) + buff[3] + MD5_SINE[4]), 22);
  A := B + ROL((A + func_f(B, C, D) + buff[4] + MD5_SINE[5]), 7);
  D := A + ROL((D + func_f(A, B, C) + buff[5] + MD5_SINE[6]), 12);
  C := D + ROL((C + func_f(D, A, B) + buff[6] + MD5_SINE[7]), 17);
  B := C + ROL((B + func_f(C, D, A) + buff[7] + MD5_SINE[8]), 22);
  A := B + ROL((A + func_f(B, C, D) + buff[8] + MD5_SINE[9]), 7);
  D := A + ROL((D + func_f(A, B, C) + buff[9] + MD5_SINE[10]), 12);
  C := D + ROL((C + func_f(D, A, B) + buff[10] + MD5_SINE[11]), 17);
  B := C + ROL((B + func_f(C, D, A) + buff[11] + MD5_SINE[12]), 22);
  A := B + ROL((A + func_f(B, C, D) + buff[12] + MD5_SINE[13]), 7);
  D := A + ROL((D + func_f(A, B, C) + buff[13] + MD5_SINE[14]), 12);
  C := D + ROL((C + func_f(D, A, B) + buff[14] + MD5_SINE[15]), 17);
  B := C + ROL((B + func_f(C, D, A) + buff[15] + MD5_SINE[16]), 22);

  A := B + ROL((A + func_g(B, C, D) + buff[1] + MD5_SINE[17]), 5);
  D := A + ROL((D + func_g(A, B, C) + buff[6] + MD5_SINE[18]), 9);
  C := D + ROL((C + func_g(D, A, B) + buff[11] + MD5_SINE[19]), 14);
  B := C + ROL((B + func_g(C, D, A) + buff[0] + MD5_SINE[20]), 20);
  A := B + ROL((A + func_g(B, C, D) + buff[5] + MD5_SINE[21]), 5);
  D := A + ROL((D + func_g(A, B, C) + buff[10] + MD5_SINE[22]), 9);
  C := D + ROL((C + func_g(D, A, B) + buff[15] + MD5_SINE[23]), 14);
  B := C + ROL((B + func_g(C, D, A) + buff[4] + MD5_SINE[24]), 20);
  A := B + ROL((A + func_g(B, C, D) + buff[9] + MD5_SINE[25]), 5);
  D := A + ROL((D + func_g(A, B, C) + buff[14] + MD5_SINE[26]), 9);
  C := D + ROL((C + func_g(D, A, B) + buff[3] + MD5_SINE[27]), 14);
  B := C + ROL((B + func_g(C, D, A) + buff[8] + MD5_SINE[28]), 20);
  A := B + ROL((A + func_g(B, C, D) + buff[13] + MD5_SINE[29]), 5);
  D := A + ROL((D + func_g(A, B, C) + buff[2] + MD5_SINE[30]), 9);
  C := D + ROL((C + func_g(D, A, B) + buff[7] + MD5_SINE[31]), 14);
  B := C + ROL((B + func_g(C, D, A) + buff[12] + MD5_SINE[32]), 20);

  A := B + ROL((A + func_h(B, C, D) + buff[5] + MD5_SINE[33]), 4);
  D := A + ROL((D + func_h(A, B, C) + buff[8] + MD5_SINE[34]), 11);
  C := D + ROL((C + func_h(D, A, B) + buff[11] + MD5_SINE[35]), 16);
  B := C + ROL((B + func_h(C, D, A) + buff[14] + MD5_SINE[36]), 23);
  A := B + ROL((A + func_h(B, C, D) + buff[1] + MD5_SINE[37]), 4);
  D := A + ROL((D + func_h(A, B, C) + buff[4] + MD5_SINE[38]), 11);
  C := D + ROL((C + func_h(D, A, B) + buff[7] + MD5_SINE[39]), 16);
  B := C + ROL((B + func_h(C, D, A) + buff[10] + MD5_SINE[40]), 23);
  A := B + ROL((A + func_h(B, C, D) + buff[13] + MD5_SINE[41]), 4);
  D := A + ROL((D + func_h(A, B, C) + buff[0] + MD5_SINE[42]), 11);
  C := D + ROL((C + func_h(D, A, B) + buff[3] + MD5_SINE[43]), 16);
  B := C + ROL((B + func_h(C, D, A) + buff[6] + MD5_SINE[44]), 23);
  A := B + ROL((A + func_h(B, C, D) + buff[9] + MD5_SINE[45]), 4);
  D := A + ROL((D + func_h(A, B, C) + buff[12] + MD5_SINE[46]), 11);
  C := D + ROL((C + func_h(D, A, B) + buff[15] + MD5_SINE[47]), 16);
  B := C + ROL((B + func_h(C, D, A) + buff[2] + MD5_SINE[48]), 23);

  A := B + ROL((A + func_i(B, C, D) + buff[0] + MD5_SINE[49]), 6);
  D := A + ROL((D + func_i(A, B, C) + buff[7] + MD5_SINE[50]), 10);
  C := D + ROL((C + func_i(D, A, B) + buff[14] + MD5_SINE[51]), 15);
  B := C + ROL((B + func_i(C, D, A) + buff[5] + MD5_SINE[52]), 21);
  A := B + ROL((A + func_i(B, C, D) + buff[12] + MD5_SINE[53]), 6);
  D := A + ROL((D + func_i(A, B, C) + buff[3] + MD5_SINE[54]), 10);
  C := D + ROL((C + func_i(D, A, B) + buff[10] + MD5_SINE[55]), 15);
  B := C + ROL((B + func_i(C, D, A) + buff[1] + MD5_SINE[56]), 21);
  A := B + ROL((A + func_i(B, C, D) + buff[8] + MD5_SINE[57]), 6);
  D := A + ROL((D + func_i(A, B, C) + buff[15] + MD5_SINE[58]), 10);
  C := D + ROL((C + func_i(D, A, B) + buff[6] + MD5_SINE[59]), 15);
  B := C + ROL((B + func_i(C, D, A) + buff[13] + MD5_SINE[60]), 21);
  A := B + ROL((A + func_i(B, C, D) + buff[4] + MD5_SINE[61]), 6);
  D := A + ROL((D + func_i(A, B, C) + buff[11] + MD5_SINE[62]), 10);
  C := D + ROL((C + func_i(D, A, B) + buff[2] + MD5_SINE[63]), 15);
  B := C + ROL((B + func_i(C, D, A) + buff[9] + MD5_SINE[64]), 21);

  Inc(FBuffer[0], A);
  Inc(FBuffer[1], B);
  Inc(FBuffer[2], C);
  Inc(FBuffer[3], D);
  FCBufferedData := 0;
end;

function TIdCoderMD5.func_g(x, y, z: LongWord): LongWord;
begin
  result := (x and z) or (y and (not z));
end;

function TIdCoderMD5.func_i(x, y, z: LongWord): LongWord;
begin
  result := y xor (x or (not z));
end;

procedure TIdCoderMD5.FillSamples(AStringList: TStrings);
begin
  with AStringList do
  begin
    Add('');
    Add('  d41d8cd98f00b204e9800998ecf8427e'); {Do not localize}
    Add('a'); {Do not localize}
    Add('  0cc175b9c0f1b6a831c399e269772661'); {Do not localize}
    Add('abc'); {Do not localize}
    Add('  900150983cd24fb0d6963f7d28e17f72'); {Do not localize}
    Add('message digest'); {Do not localize}
    Add('  f96b697d7cb7938d525a2f31aaf161d0'); {Do not localize}
    Add('abcdefghijklmnopqrstuvwxyz'); {Do not localize}
    Add('  c3fcd3d76192e4007dfb496cca67e13b'); {Do not localize}
    Add('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
      {Do not localize}
    Add('  d174ab98d277d9f5a5611c2c9f419d9f'); {Do not localize}
    Add('12345678901234567890123456789012345678901234567890123456789012345678901234567890'); {Do not localize}
    Add('  57edf4a22be3c955ac49da2e2107b67a'); {Do not localize}
  end;
end;

initialization
  RegisterCoderClass(TIdCoderMD2, CT_CREATION, CP_FALLBACK,
    '', MIMEEncRSAMD2);
  RegisterCoderClass(TIdCoderMD2, CT_REALISATION, CP_FALLBACK,
    '', MIMEEncRSAMD2);
  RegisterCoderClass(TIdCoderMD4, CT_CREATION, CP_FALLBACK,
    '', MIMEEncRSAMD4);
  RegisterCoderClass(TIdCoderMD4, CT_REALISATION, CP_FALLBACK,
    '', MIMEEncRSAMD4);
  RegisterCoderClass(TIdCoderMD5, CT_CREATION, CP_FALLBACK,
    '', MIMEEncRSAMD5);
  RegisterCoderClass(TIdCoderMD5, CT_REALISATION, CP_FALLBACK,
    '', MIMEEncRSAMD5);
end.
