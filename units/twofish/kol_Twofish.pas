{Kol modifications done by neuron, note that this only includes the twofish
 implementation, not the (loads) of other free encryption types.

 Great library :)

 neuron, neuron@hollowtube.mine.nu, problems with the modification can be sent
 to my email address.


 Example usage:
 var TFData:TTwofishData;
 const key=array[0..7] of char = 'qm3igmfk'
 // inblock and outblock can be pretty much anything
 // if you use it on strings, remember, string[0] is the length
 // so use twofishencrypt___(data,string[1],x,length(string));
 begin
 TwofishInit(tfdata,key,8,nil);
 twofishencryptcbc(tfdata,inblock,outblock,length(inblock));
 TwofishReset(tfdata);
 twofishdecryptcbc(tfdata,outblock,inblock,length(outblock));
 TwoFishBurn(tfdata);
 end;}
{******************************************************************************}
{** A binary compatible implementation of Twofish *****************************}
{******************************************************************************}
{** Written by David Barton (davebarton@bigfoot.com) **************************}
{** http://www.scramdisk.clara.net/ *******************************************}
{******************************************************************************}
unit kol_Twofish;

interface

{** DCPcrypt include file **}

{$Q-}              { over flow checking off }
{$R-}              { range checking off }

uses kol;

{** DCPCrypt **}
type
  PWord= ^Word;
  PDWord= ^our_DWord;
{$IFDEF VER120}
  our_DWord= longword;
{$ELSE}
  our_DWord= longint;
{$ENDIF}
  PDWordArray= ^TDWordArray;
  TDWordArray= array[0..1023] of our_DWord;
  PByteArray= ^TByteArray;
  TByteArray= array[0..4095] of byte;
{** DCPCrypt End**}

const
  BLU: array[0..3] of our_DWord= (0, 8, 16, 24);
  TWOFISH_BLOCKSIZE= 16;
  INPUTWHITEN= 0;
  OUTPUTWHITEN= (TWOFISH_BLOCKSIZE div 4);
  NUMROUNDS= 16;
  ROUNDSUBKEYS= (OUTPUTWHITEN + TWOFISH_BLOCKSIZE div 4);
  TOTALSUBKEYS= (ROUNDSUBKEYS + NUMROUNDS * 2);
  RS_GF_FDBK= $14d;
  SK_STEP= $02020202;
  SK_BUMP= $01010101;
  SK_ROTL= 9;
  P_00=           1;
  P_01=           0;
  P_02=           0;
  P_03=           (P_01 xor 1);
  P_04=           1;
  P_10=           0;
  P_11=           0;
  P_12=           1;
  P_13=           (P_11 xor 1);
  P_14=           0;
  P_20=           1;
  P_21=           1;
  P_22=           0;
  P_23=           (P_21 xor 1);
  P_24=           0;
  P_30=           0;
  P_31=           1;
  P_32=           1;
  P_33=           (P_31 xor 1);
  P_34=           1;
  MDS_GF_FDBK= $169;

type
  TTwofishData= record
    IV, LB: array[0..15] of byte;
    KeyLen: our_DWord;
    SubKeys: array[0..TOTALSUBKEYS-1] of our_DWord;
    sboxKeys: array[0..3] of our_DWord;
    sbox: array[0..3,0..255] of our_DWord;
  end;

procedure TwofishInit(var Data: TTwofishData; var Key; Size: longint; IVector: pointer);
procedure TwofishReset(var Data: TTwofishData);
procedure TwofishBurn(var Data:  TTwofishData);
procedure TwofishEncryptECB(var Data: TTwofishData; const InBlock; var OutBlock);
procedure TwofishDecryptECB(var Data: TTwofishData; const InBlock; var OutBlock);
procedure TwofishEncryptCBC(var Data: TTwofishData; const InData; var OutData; Size: longint);
procedure TwofishDecryptCBC(var Data: TTwofishData; const InData; var OutData; Size: longint);
procedure TwofishEncryptCFB(var Data: TTwofishData; const InData; var OutData; Size: longint);
procedure TwofishDecryptCFB(var Data: TTwofishData; const InData; var OutData; Size: longint);

{******************************************************************************}
{******************************************************************************}
implementation

{$I Twofish.Inc}

var
  MDS: array[0..3,0..255] of our_DWord;

{ ** DcpCrypt **}
function LRot32(X: our_DWord; c: longint): our_DWord; register; assembler;
asm
  mov ecx, edx
  rol eax, cl
end;

function RRot32(X: our_DWord; c: longint): our_DWord; register; assembler;
asm
  mov ecx, edx
  ror eax, cl
end;

procedure XorBlock(I1, I2, O1: PByteArray; Len: longint);
var
  i: longint;
begin
  for i:= 0 to Len-1 do
    O1^[i]:= I1^[i] xor I2^[i];
end;
{ ** DcpCrypt End**}






function LFSR1(x: our_DWord): our_DWord;
begin
  if (x and 1)<> 0 then
    Result:= (x shr 1) xor (MDS_GF_FDBK div 2)
  else
    Result:= (x shr 1);
end;
function LFSR2(x: our_DWord): our_DWord;
begin
  if (x and 2)<> 0 then
    if (x and 1)<> 0 then
      Result:= (x shr 2) xor (MDS_GF_FDBK div 2) xor (MDS_GF_FDBK div 4)
    else
      Result:= (x shr 2) xor (MDS_GF_FDBK div 2)
  else
    if (x and 1)<> 0 then
      Result:= (x shr 2) xor (MDS_GF_FDBK div 4)
    else
      Result:= (x shr 2);
end;
function Mul_X(x: our_DWord): our_DWord;
begin
  Result:= x xor LFSR2(x);
end;
function Mul_Y(x: our_DWord): our_DWord;
begin
  Result:= x xor LFSR1(x) xor LFSR2(x);
end;

function RS_MDS_Encode(lK0, lK1: our_dword): our_dword;
var
  lR, nI, nJ, lG2, lG3: our_dword;
  bB: byte;
begin
  lR:= 0;
  for nI:= 0 to 1 do
  begin
    if nI<> 0  then
      lR:= lR xor lK0
    else
      lR:= lR xor lK1;
    for nJ:= 0 to 3 do
    begin
      bB:= lR shr 24;
      if (bB and $80)<> 0 then
        lG2:= ((bB shl 1) xor RS_GF_FDBK) and $FF
      else
        lG2:= (bB shl 1) and $FF;
      if (bB and 1)<> 0 then
        lG3:= ((bB shr 1) and $7f) xor (RS_GF_FDBK shr 1) xor lG2
      else
        lG3:= ((bB shr 1) and $7f) xor lG2;
      lR:= (lR shl 8) xor (lG3 shl 24) xor (lG2 shl 16) xor (lG3 shl 8) xor bB;
    end;
  end;
  Result:= lR;
end;

function f32(x: our_dword; K32: PDWordArray; Len: our_dword): our_dword;
var
  t0, t1, t2, t3: our_dword;
begin
  t0:= x and $FF;
  t1:= (x shr 8) and $FF;
  t2:= (x shr 16) and $FF;
  t3:= x shr 24;
  if Len= 256 then
  begin
    t0:= p8x8[p_04,t0] xor ((K32^[3]) and $FF);
    t1:= p8x8[p_14,t1] xor ((K32^[3] shr  8) and $FF);
    t2:= p8x8[p_24,t2] xor ((K32^[3] shr 16) and $FF);
    t3:= p8x8[p_34,t3] xor ((K32^[3] shr 24));
  end;
  if Len>= 192 then
  begin
    t0:= p8x8[p_03,t0] xor ((K32^[2]) and $FF);
    t1:= p8x8[p_13,t1] xor ((K32^[2] shr  8) and $FF);
    t2:= p8x8[p_23,t2] xor ((K32^[2] shr 16) and $FF);
    t3:= p8x8[p_33,t3] xor ((K32^[2] shr 24));
  end;
  Result:= MDS[0,p8x8[p_01,p8x8[p_02,t0] xor ((K32^[1]) and $FF)] xor ((K32^[0]) and $FF)] xor
           MDS[1,p8x8[p_11,p8x8[p_12,t1] xor ((K32^[1] shr  8) and $FF)] xor ((K32^[0] shr  8) and $FF)] xor
           MDS[2,p8x8[p_21,p8x8[p_22,t2] xor ((K32^[1] shr 16) and $FF)] xor ((K32^[0] shr 16) and $FF)] xor
           MDS[3,p8x8[p_31,p8x8[p_32,t3] xor ((K32^[1] shr 24))] xor ((K32^[0] shr 24))];
end;

procedure TwofishEncryptECB;
var
  i: longint;
  t0, t1: our_dword;
  X: array[0..3] of our_dword;
begin
  with Data do begin
  X[0]:= PDWord(@InBlock)^ xor SubKeys[INPUTWHITEN];
  X[1]:= PDWord(longint(@InBlock)+4)^ xor SubKeys[INPUTWHITEN+1];
  X[2]:= PDWord(longint(@InBlock)+8)^ xor SubKeys[INPUTWHITEN+2];
  X[3]:= PDWord(longint(@InBlock)+12)^ xor SubKeys[INPUTWHITEN+3];
  i:= 0;
  while i<= NUMROUNDS-2 do
  begin
    t0:= sBox[0,2*(x[0] and $ff)] xor sBox[0,2*(((x[0]) shr 8) and $ff)+1]
      xor sBox[2,2*((x[0] shr 16) and $ff)] xor sBox[2,2*((x[0] shr 24) and $ff)+1];
    t1:= sBox[0,2*((x[1] shr 24) and $ff)] xor sBox[0,2*(x[1] and $ff)+1]
      xor sBox[2,2*((x[1] shr 8) and $ff)] xor sBox[2,2*((x[1] shr 16) and $ff)+1];
    x[3]:= LRot32(x[3],1);
    x[2]:= x[2] xor (t0 +   t1 + SubKeys[ROUNDSUBKEYS+2*i]);
    x[3]:= x[3] xor (t0 + 2*t1 + SubKeys[ROUNDSUBKEYS+2*i+1]);
    x[2]:= RRot32(x[2],1);

    t0:= sBox[0,2*(x[2] and $ff)] xor sBox[0,2*((x[2] shr 8) and $ff)+1]
      xor sBox[2,2*((x[2] shr 16) and $ff)] xor sBox[2,2*((x[2] shr 24) and $ff)+1];
    t1:= sBox[0,2*((x[3] shr 24) and $ff)] xor sBox[0,2*(x[3] and $ff)+1]
      xor sBox[2,2*((x[3] shr 8) and $ff)] xor sBox[2,2*((x[3] shr 16) and $ff)+1];
    x[1]:= LRot32(x[1],1);
    x[0]:= x[0] xor (t0 +   t1 + SubKeys[ROUNDSUBKEYS+2*(i+1)]);
    x[1]:= x[1] xor (t0 + 2*t1 + SubKeys[ROUNDSUBKEYS+2*(i+1)+1]);
    x[0]:= RRot32(x[0],1);
    Inc(i,2);
  end;
  PDWord(longint(@OutBlock)+ 0)^:= X[2] xor SubKeys[OUTPUTWHITEN];
  PDWord(longint(@OutBlock)+ 4)^:= X[3] xor SubKeys[OUTPUTWHITEN+1];
  PDWord(longint(@OutBlock)+ 8)^:= X[0] xor SubKeys[OUTPUTWHITEN+2];
  PDWord(longint(@OutBlock)+12)^:= X[1] xor SubKeys[OUTPUTWHITEN+3];
  end;
end;

procedure TwofishDecryptECB;
var
  i: longint;
  t0, t1: our_dword;
  X: array[0..3] of our_dword;
begin
  with Data do begin
  X[2]:= PDWord(@InBlock)^ xor SubKeys[OUTPUTWHITEN];
  X[3]:= PDWord(longint(@InBlock)+4)^ xor SubKeys[OUTPUTWHITEN+1];
  X[0]:= PDWord(longint(@InBlock)+8)^ xor SubKeys[OUTPUTWHITEN+2];
  X[1]:= PDWord(longint(@InBlock)+12)^ xor SubKeys[OUTPUTWHITEN+3];
  i:= NUMROUNDS-2;
  while i>= 0 do
  begin
    t0:= sBox[0,2*(x[2] and $ff)] xor sBox[0,2*((x[2] shr 8) and $ff)+1]
      xor sBox[2,2*((x[2] shr 16) and $ff)] xor sBox[2,2*((x[2] shr 24) and $ff)+1];
    t1:= sBox[0,2*((x[3] shr 24) and $ff)] xor sBox[0,2*(x[3] and $ff)+1]
      xor sBox[2,2*((x[3] shr 8) and $ff)] xor sBox[2,2*((x[3] shr 16) and $ff)+1];
    x[0]:= LRot32(x[0],1);
    x[0]:= x[0] xor (t0 +   t1 + Subkeys[ROUNDSUBKEYS+2*(i+1)]);
    x[1]:= x[1] xor (t0 + 2*t1 + Subkeys[ROUNDSUBKEYS+2*(i+1)+1]);
    x[1]:= RRot32(x[1],1);

    t0:= sBox[0,2*(x[0] and $ff)] xor sBox[0,2*((x[0] shr 8) and $ff)+1]
      xor sBox[2,2*((x[0] shr 16) and $ff)] xor sBox[2,2*((x[0] shr 24) and $ff)+1];
    t1:= sBox[0,2*((x[1] shr 24) and $ff)] xor sBox[0,2*(x[1] and $ff)+1]
      xor sBox[2,2*((x[1] shr 8) and $ff)] xor sBox[2,2*((x[1] shr 16) and $ff)+1];
    x[2]:= LRot32(x[2],1);
    x[2]:= x[2] xor (t0 +   t1 + Subkeys[ROUNDSUBKEYS+2*i]);
    x[3]:= x[3] xor (t0 + 2*t1 + Subkeys[ROUNDSUBKEYS+2*i+1]);
    x[3]:= RRot32(x[3],1);
    Dec(i,2);
  end;
  PDWord(longint(@OutBlock)+ 0)^:= X[0] xor SubKeys[INPUTWHITEN];
  PDWord(longint(@OutBlock)+ 4)^:= X[1] xor SubKeys[INPUTWHITEN+1];
  PDWord(longint(@OutBlock)+ 8)^:= X[2] xor SubKeys[INPUTWHITEN+2];
  PDWord(longint(@OutBlock)+12)^:= X[3] xor SubKeys[INPUTWHITEN+3];
  end;
end;

procedure TwofishInit;
  procedure Xor256(Dst, Src: PDWordArray; v: byte);
  var
    i: our_dword;
  begin
    for i:= 0 to 63 do
      Dst^[i]:= Src^[i] xor (v * $01010101);
  end;
var
  key32: array[0..7] of our_dword;
  k32e, k32o: array[0..3] of our_dword;
  k64Cnt, i, j, A, B, q, subkeyCnt: our_dword;
  L0, L1: array[0..255] of byte;
begin
  if (Size> 256) or (Size<= 0) or ((Size mod 8)<> 0) then
    Exit;
  with Data do begin

  FillChar(Key32,Sizeof(Key32),0);
  Move(Key,Key32,Size div 8);
  if Size<= 128 then           { pad the key to either 128bit, 192bit or 256bit}
    Size:= 128
  else if Size<= 192 then
    Size:= 192
  else
    Size:= 256;
  subkeyCnt:= ROUNDSUBKEYS + 2*NUMROUNDS;
  KeyLen:= Size;
  k64Cnt:= Size div 64;
  j:= k64Cnt-1;
  for i:= 0 to j do
  begin
    k32e[i]:= key32[2*i];
    k32o[i]:= key32[2*i+1];
    sboxKeys[j]:= RS_MDS_Encode(k32e[i],k32o[i]);
    Dec(j);
  end;
  q:= 0;
  for i:= 0 to ((subkeyCnt div 2)-1) do
  begin
    A:= f32(q,@k32e,Size);
    B:= f32(q+SK_BUMP,@k32o,Size);
    B:= LRot32(B,8);
    SubKeys[2*i]:= A+B;
    B:= A + 2*B;
    SubKeys[2*i+1]:= LRot32(B,SK_ROTL);
    Inc(q,SK_STEP);
  end;
  case Size of
    128: begin
           Xor256(@L0,@p8x8[p_02],(sboxKeys[1] and $FF));
           A:= (sboxKeys[0] and $FF);
           i:= 0;
           while i< 256 do
           begin
             sBox[0 and 2,2*i+(0 and 1)]:= MDS[0,p8x8[p_01,L0[i]] xor A];
             sBox[0 and 2,2*i+(0 and 1)+2]:= MDS[0,p8x8[p_01,L0[i+1]] xor A];
             Inc(i,2);
           end;
           Xor256(@L0,@p8x8[p_12],(sboxKeys[1] shr 8) and $FF);
           A:= (sboxKeys[0] shr 8) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[1 and 2,2*i+(1 and 1)]:= MDS[1,p8x8[p_11,L0[i]] xor A];
             sBox[1 and 2,2*i+(1 and 1)+2]:= MDS[1,p8x8[p_11,L0[i+1]] xor A];
             Inc(i,2);
           end;
           Xor256(@L0,@p8x8[p_22],(sboxKeys[1] shr 16) and $FF);
           A:= (sboxKeys[0] shr 16) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[2 and 2,2*i+(2 and 1)]:= MDS[2,p8x8[p_21,L0[i]] xor A];
             sBox[2 and 2,2*i+(2 and 1)+2]:= MDS[2,p8x8[p_21,L0[i+1]] xor A];
             Inc(i,2);
           end;
           Xor256(@L0,@p8x8[p_32],(sboxKeys[1] shr 24));
           A:= (sboxKeys[0] shr 24);
           i:= 0;
           while i< 256 do
           begin
             sBox[3 and 2,2*i+(3 and 1)]:= MDS[3,p8x8[p_31,L0[i]] xor A];
             sBox[3 and 2,2*i+(3 and 1)+2]:= MDS[3,p8x8[p_31,L0[i+1]] xor A];
             Inc(i,2);
           end;
         end;
    192: begin
           Xor256(@L0,@p8x8[p_03],sboxKeys[2] and $FF);
           A:= sboxKeys[0] and $FF;
           B:= sboxKeys[1] and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[0 and 2,2*i+(0 and 1)]:= MDS[0,p8x8[p_01,p8x8[p_02,L0[i]] xor B] xor A];
             sBox[0 and 2,2*i+(0 and 1)+2]:= MDS[0,p8x8[p_01,p8x8[p_02,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
           Xor256(@L0,@p8x8[p_13],(sboxKeys[2] shr 8) and $FF);
           A:= (sboxKeys[0] shr 8) and $FF;
           B:= (sboxKeys[1] shr 8) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[1 and 2,2*i+(1 and 1)]:= MDS[1,p8x8[p_11,p8x8[p_12,L0[i]] xor B] xor A];
             sBox[1 and 2,2*i+(1 and 1)+2]:= MDS[1,p8x8[p_11,p8x8[p_12,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
           Xor256(@L0,@p8x8[p_23],(sboxKeys[2] shr 16) and $FF);
           A:= (sboxKeys[0] shr 16) and $FF;
           B:= (sboxKeys[1] shr 16) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[2 and 2,2*i+(2 and 1)]:= MDS[2,p8x8[p_21,p8x8[p_22,L0[i]] xor B] xor A];
             sBox[2 and 2,2*i+(2 and 1)+2]:= MDS[2,p8x8[p_21,p8x8[p_22,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
           Xor256(@L0,@p8x8[p_33],(sboxKeys[2] shr 24));
           A:= (sboxKeys[0] shr 24);
           B:= (sboxKeys[1] shr 24);
           i:= 0;
           while i< 256 do
           begin
             sBox[3 and 2,2*i+(3 and 1)]:= MDS[3,p8x8[p_31,p8x8[p_32,L0[i]] xor B] xor A];
             sBox[3 and 2,2*i+(3 and 1)+2]:= MDS[3,p8x8[p_31,p8x8[p_32,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
         end;
    256: begin
           Xor256(@L1,@p8x8[p_04],(sboxKeys[3]) and $FF);
           i:= 0;
           while i< 256 do
           begin
             L0[i  ]:= p8x8[p_03,L1[i]];
             L0[i+1]:= p8x8[p_03,L1[i+1]];
             Inc(i,2);
           end;
           Xor256(@L0,@L0,(sboxKeys[2]) and $FF);
           A:= (sboxKeys[0]) and $FF;
           B:= (sboxKeys[1]) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[0 and 2,2*i+(0 and 1)]:= MDS[0,p8x8[p_01,p8x8[p_02,L0[i]] xor B] xor A];
             sBox[0 and 2,2*i+(0 and 1)+2]:= MDS[0,p8x8[p_01,p8x8[p_02,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
           Xor256(@L1,@p8x8[p_14],(sboxKeys[3] shr  8) and $FF);
           i:= 0;
           while i< 256 do
           begin
             L0[i  ]:= p8x8[p_13,L1[i]];
             L0[i+1]:= p8x8[p_13,L1[i+1]];
             Inc(i,2);
           end;
           Xor256(@L0,@L0,(sboxKeys[2] shr  8) and $FF);
           A:= (sboxKeys[0] shr  8) and $FF;
           B:= (sboxKeys[1] shr  8) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[1 and 2,2*i+(1 and 1)]:= MDS[1,p8x8[p_11,p8x8[p_12,L0[i]] xor B] xor A];
             sBox[1 and 2,2*i+(1 and 1)+2]:= MDS[1,p8x8[p_11,p8x8[p_12,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;

           Xor256(@L1,@p8x8[p_24],(sboxKeys[3] shr 16) and $FF);
           i:= 0;
           while i< 256 do
           begin
             L0[i  ]:= p8x8[p_23,L1[i]];
             L0[i+1]:= p8x8[p_23,L1[i+1]];
             Inc(i,2);
           end;
           Xor256(@L0,@L0,(sboxKeys[2] shr 16) and $FF);
           A:= (sboxKeys[0] shr 16) and $FF;
           B:= (sboxKeys[1] shr 16) and $FF;
           i:= 0;
           while i< 256 do
           begin
             sBox[2 and 2,2*i+(2 and 1)]:= MDS[2,p8x8[p_21,p8x8[p_22,L0[i]] xor B] xor A];
             sBox[2 and 2,2*i+(2 and 1)+2]:= MDS[2,p8x8[p_21,p8x8[p_22,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
           Xor256(@L1,@p8x8[p_34],(sboxKeys[3] shr 24));
           i:= 0;
           while i< 256 do
           begin
             L0[i  ]:= p8x8[p_33,L1[i]];
             L0[i+1]:= p8x8[p_33,L1[i+1]];
             Inc(i,2);
           end;
           Xor256(@L0,@L0,(sboxKeys[2] shr 24));
           A:= (sboxKeys[0] shr 24);
           B:= (sboxKeys[1] shr 24);
           i:= 0;
           while i< 256 do
           begin
             sBox[3 and 2,2*i+(3 and 1)]:= MDS[3,p8x8[p_31,p8x8[p_32,L0[i]] xor B] xor A];
             sBox[3 and 2,2*i+(3 and 1)+2]:= MDS[3,p8x8[p_31,p8x8[p_32,L0[i+1]] xor B] xor A];
             Inc(i,2);
           end;
         end;
  end;

  if IVector= nil then
  begin
    FillChar(IV,Sizeof(IV),$FF);
    TwofishEncryptECB(Data,IV,IV);
    Move(IV,LB,Sizeof(LB));
  end
  else
  begin
    Move(IVector^,IV,Sizeof(IV));
    Move(IV,LB,Sizeof(IV));
  end;
  end;
end;

procedure TwofishBurn;
begin
  with Data do begin
  FillChar(sBox,Sizeof(sBox),$FF);
  FillChar(sBoxKeys,Sizeof(sBoxKeys),$FF);
  FillChar(SubKeys,Sizeof(SubKeys),$FF);
  FillChar(IV,Sizeof(IV),$FF);
  FillChar(LB,Sizeof(LB),$FF);
end;
end;

procedure TwofishReset;
begin
  with Data do
  Move(IV,LB,Sizeof(LB));
end;

procedure TwofishEncryptCBC;
var
  TB: array[0..15] of byte;
  i: longint;
begin
with Data do begin
  for i:= 1 to (Size div 16) do
  begin
    XorBlock(pointer(longint(@InData)+((i-1)*16)),@LB,@TB,Sizeof(TB));
    TwofishEncryptECB(Data,TB,TB);
    Move(TB,pointer(longint(@OutData)+((i-1)*16))^,Sizeof(TB));
    Move(TB,LB,Sizeof(TB));
  end;
  if (Size mod 16)<> 0 then
  begin
    TwofishEncryptECB(Data,LB,TB);
    XorBlock(@TB,@pointer(longint(@InData)+Size-(Size mod 16))^,@pointer(longint(@OutData)+Size-(Size mod 16))^,Size mod 16);
  end;
  FillChar(TB,Sizeof(TB),$FF);
  end;
end;

procedure TwofishDecryptCBC;
var
  TB: array[0..15] of byte;
  i: longint;
begin
with Data do begin
  for i:= 1 to (Size div 16) do
  begin
    Move(pointer(longint(@InData)+((i-1)*16))^,TB,Sizeof(TB));
    TwofishDecryptECB(Data,pointer(longint(@InData)+((i-1)*16))^,pointer(longint(@OutData)+((i-1)*16))^);
    XorBlock(@LB,pointer(longint(@OutData)+((i-1)*16)),pointer(longint(@OutData)+((i-1)*16)),Sizeof(TB));
    Move(TB,LB,Sizeof(TB));
  end;
  if (Size mod 16)<> 0 then
  begin
    TwofishEncryptECB(Data,LB,TB);
    XorBlock(@TB,@pointer(longint(@InData)+Size-(Size mod 16))^,@pointer(longint(@OutData)+Size-(Size mod 16))^,Size mod 16);
  end;
  FillChar(TB,Sizeof(TB),$FF);
  end;
end;

procedure TwofishEncryptCFB;
var
  i: longint;
  TB: array[0..15] of byte;
begin
with Data do begin
  for i:= 0 to Size-1 do
  begin
    TwofishEncryptECB(Data,LB,TB);
    PByteArray(@OutData)^[i]:= PByteArray(@InData)^[i] xor TB[0];
    Move(LB[1],LB[0],15);
    LB[15]:= PByteArray(@OutData)^[i];
  end;
  end;
end;

procedure TwofishDecryptCFB;
var
  i: longint;
  TB: array[0..15] of byte;
  b: byte;
begin
with Data do begin
  for i:= 0 to Size-1 do
  begin
    b:= PByteArray(@InData)^[i];
    TwofishEncryptECB(Data,LB,TB);
    PByteArray(@OutData)^[i]:= PByteArray(@InData)^[i] xor TB[0];
    Move(LB[1],LB[0],15);
    LB[15]:= b;
  end;
  end;
end;

procedure PreCompMDS;
var
  m1, mx, my: array[0..1] of our_dword;
  nI: longint;
begin
  for nI:= 0 to 255 do
  begin
    m1[0]:= p8x8[0,nI];
    mx[0]:= Mul_X(m1[0]);
    my[0]:= Mul_Y(m1[0]);
    m1[1]:= p8x8[1,nI];
    mx[1]:= Mul_X(m1[1]);
    my[1]:= Mul_Y(m1[1]);
    mds[0,nI]:= (m1[P_00] shl 0) or
                (mx[p_00] shl 8) or
                (my[p_00] shl 16) or
                (my[p_00] shl 24);
    mds[1,nI]:= (my[p_10] shl 0) or
                (my[p_10] shl 8) or
                (mx[p_10] shl 16) or
                (m1[p_10] shl 24);
    mds[2,nI]:= (mx[p_20] shl 0) or
                (my[p_20] shl 8) or
                (m1[p_20] shl 16) or
                (my[p_20] shl 24);
    mds[3,nI]:= (mx[p_30] shl 0) or
                (m1[p_30] shl 8) or
                (my[p_30] shl 16) or
                (mx[p_30] shl 24);
  end;
end;

initialization
  PreCompMDS;

end.
