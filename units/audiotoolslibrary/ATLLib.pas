unit ATLLib;

interface

uses Windows, Kol;

//Äëÿ óñòğàíåíèÿ îøèáêè â asm âåğñèè KOL
function Trim( const S : string): string;
function FileSetAttr(const FileName: string; Attr: Integer): Integer;
function SwapOrder32(Value: DWord): DWord;

implementation

function FileSetAttr(const FileName: string; Attr: Integer): Integer;
begin
  Result := 0;
  if not SetFileAttributes(PChar(FileName), Attr) then
    Result := GetLastError;
end;

function TrimRight(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;

function TrimLeft(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  Result := Copy(S, I, Maxint);
end;

function Trim( const S : string): string;
begin
   Result := TrimLeft( TrimRight( S ) );
end;

function SwapOrder32(Value: DWord): DWord;
type Tab_3 = array[0..3]of Byte;
begin
    Tab_3(Result)[0]:= Tab_3(Value)[3];
    Tab_3(Result)[1]:= Tab_3(Value)[2];
    Tab_3(Result)[2]:= Tab_3(Value)[1];
    Tab_3(Result)[3]:= Tab_3(Value)[0];
end;

end.
