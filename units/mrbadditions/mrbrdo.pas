unit MrBrdo;

interface
uses Windows, KOL;

type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);

  function IsIP(s: String): Boolean;
  function IsInt(Str: String): Boolean;
  function Str2IntDef(Value: String; Default: Integer): Integer;
  function GetToken(Text: String; Divider: String; Num: Integer; ToEnd: Boolean = False): String;
  function PosEx(Needle: Char; Haystack: String; Num: Integer): Integer;
  function URLDecode(str: String): String;
  function UrlEncode(const DecodedStr: String; Pluses: Boolean): String;
  function Hex2Bin(Text, Buffer: PChar; BufSize: Integer): Integer; assembler;
  function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;

implementation

function IsIP(s: String): Boolean;
var i: Integer;
begin
  Result:=True;
  for i:=1 to Length(s) do begin
    if not (s[i] in ['0'..'9','.']) then begin
      Result:=False; break;
    end;
  end;
end;

function PosEx(Needle: Char; Haystack: String; Num: Integer): Integer;
var i,p: Integer;
begin
  p:=0;
  Result:=-1;
  for i:=1 to Length(Haystack) do begin
    if Haystack[i] = Needle then
      Inc(p);
    if p = Num then begin;
      Result:=i;
      break;
    end;
  end;
end;

function IsInt(Str: String): Boolean;
var i: Integer;
begin
  Result := True;
  for i:=1 to Length(Str) do
    if not(Str[i] in ['0'..'9']) then
      Result := False;
end;

{ More efficient Str2Int function }
function Str2IntDef(Value: String; Default: Integer): Integer;
begin
  if (IsInt(Value)) then
    Result:=Str2Int(Value)
  else
    Result:=Default;
end;

{ get the n-th part of the text seperated by divider }
function GetToken(Text: String; Divider: String; Num: Integer; ToEnd: Boolean = False): String;
var i: Integer;
begin
  Num:=Num-1;
  if (Num = 0) then begin
    Result:=Copy(Text,1,Pos(Divider,Text)-1);
  end else begin
    for i:=0 to Num - 1 do
      Delete(Text,1,Pos(Divider,Text));
    if (Pos(Divider,Text)<>0)and(not(ToEnd)) then
      Delete(Text,Pos(Divider,Text),Length(Text)-Pos(Divider,Text)+1);
    Result:=Text;
  end;
end;

{ by Borland }
// Also needed for URLDecode.
function Hex2Bin(Text, Buffer: PChar; BufSize: Integer): Integer; assembler;
begin
  Result:=0; { just to stop the compiler nagging }
  asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,EDX
        MOV     EDX,0
        JMP     @@1
@@0:    DB       0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1
        DB      -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1
        DB      -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        DB      -1,10,11,12,13,14,15
@@1:    LODSW
        CMP     AL,'0'
        JB      @@2
        CMP     AL,'f'
        JA      @@2
        MOV     DL,AL
        MOV     AL,@@0.Byte[EDX-'0']
        CMP     AL,-1
        JE      @@2
        SHL     AL,4
        CMP     AH,'0'
        JB      @@2
        CMP     AH,'f'
        JA      @@2
        MOV     DL,AH
        MOV     AH,@@0.Byte[EDX-'0']
        CMP     AH,-1
        JE      @@2
        OR      AL,AH
        STOSB
        DEC     ECX
        JNE     @@1
@@2:    MOV     EAX,EDI
        SUB     EAX,EBX
        POP     EBX
        POP     EDI
        POP     ESI
  end;
end;

{ written by me! (mrbrdo) }
function URLDecode(str: String): String;
var char_at: Integer; buf: PChar;
begin
  char_at:=1;
  GetMem(buf,5);
  ZeroMemory(buf, 5);
  Result:='';
  while char_at <= Length(str) do begin
    if (str[char_at] = '%')and
    (char_at + 2 <= Length(str)) then begin
      Hex2Bin(PChar(Copy(str,char_at + 1, 2)),buf,5);
      Result:=Result + buf;
      ZeroMemory(buf, 5);
      Inc(char_at, 2);
    end else
      Result:=Result + str[char_at];
    Inc(char_at);
  end;
end;

{ not by me, just translated }
function UrlEncode(const DecodedStr: String; Pluses: Boolean): String;
var
  I: Integer;
begin
  Result := '';
  if Length(DecodedStr) > 0 then
    for I := 1 to Length(DecodedStr) do
    begin
      if not (DecodedStr[I] in ['0'..'9', 'a'..'z',
                                       'A'..'Z', ' ']) then
        Result := Result + '%' + Int2Hex(Ord(DecodedStr[I]), 2)
      else if not (DecodedStr[I] = ' ') then
        Result := Result + DecodedStr[I]
      else
        begin
          if not Pluses then
            Result := Result + '%20'
          else
            Result := Result + '+';
        end;
    end;
end;

function StringReplace(const S, OldPattern, NewPattern: string;
  Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

end.