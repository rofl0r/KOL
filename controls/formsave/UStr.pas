unit UStr;

interface
function  space   (           n:integer):string ;
function  replicate(ch:char;  n:integer):string ;{cформировать строку}
function  trim    (str:string          ):string ;
function  center  (str:string;n:integer):string ;
function  UpSt    (  s:string          ):string;
function  LoSt    (  s:string          ):string;
function  lpad    (  s:string;n:integer;c:char):string;
function  rpad    (  s:string;n:integer;c:char):string;
function  addbackslash(p : string) : string;{работа с именем path}
function  match   (sm : string; var st: string) : boolean;
function  lines   (p, l, s : longint) : string;
function  LoCase  (c : char) : char;
function  JustPathname(PathName : string) : string;
function  JustFileName(PathName : string) : string;
function  JustName    (PathName : string) : string;
function  CRC16       (s        : string) : system.word;

implementation

function  space;
var   i : integer;
tempstr : string;
     begin
        tempstr:='';
        for i:=1 to n do tempstr:=tempstr+' ';
        space:=tempstr;
     end;

function  replicate;
var   i : integer;
tempstr : string;
     begin
        tempstr:='';
        for i:=1 to n do tempstr:=tempstr+ch;
        replicate:=tempstr;
     end;

function  trim;
var i,j : integer;
begin
   trim := '';
   if length(str) > 1 then begin
      j := 1;
      while str[j] = ' ' do inc(j);
      i := length(str);
      while str[i] = ' ' do dec(i);
      trim := copy(str, j, i - j + 1);
   end;
end;
function  center;
var tempstr : string;
          j : integer;
     begin
        j := n - length(trim(str));
        if j > 0 then tempstr := space(j - j div 2) + trim(str) + space(j div 2)
                 else tempstr := trim(str);
        center := tempstr;
     end;

function UpSt;
var t : string;
    i : integer;
begin
   t := '';
   for i := 1 to length(s) do t := t + UpCase(s[i]);
   UpSt := t;
end;

function LoSt;
var t : string;
    i : integer;
begin
   t := '';
   for i := 1 to length(s) do t := t + LoCase(s[i]);
   LoSt := t;
end;

function lpad;
begin
   lpad := replicate(c, n - length(s)) + s;
end;

function rpad;
begin
   rpad := s + replicate(c, n - length(s));
end;

    function addbackslash;
    begin
       if length(p) > 0 then
       if p[length(p)] = '\' then addbackslash := p
                             else addbackslash := p + '\'
                        else addbackslash := p;
    end;

function match(sm : string; var st: string) : boolean;
var p : integer;
  _sm,
  _st : string;
begin
   match := false;
   if (length(sm) > 0) and (length(st) > 0) then begin
      _sm := UpSt(sm);
      _st := UpSt(st);
      while pos(_sm, _st) > 0 do begin
         match := true;
         p     := pos(_sm, _st);
        _st    := copy(_st, 1, p - 1) + copy(_st, p + length(_sm), 250);
         st    := copy( st, 1, p - 1) + copy( st, p + length( sm), 250);
      end;
   end;
end;

function lines;
var o : string;
    i : longint;
    n : longint;
begin
    if l > 0 then begin
       i := p * s div l;
       n := p * s * 2 div l;
       o := replicate('█', i);
       if n > i * 2 then o := o + '▌';
       lines := o + space(s - length(o));
    end else lines := '';
end;

function LoCase;
var t : char;
begin
   if (c >= 'A') and (c <= 'Z') then t := chr(ord(c) + 32)
                                else t := c;
   LoCase := t;
end;

  function JustPathname(PathName : string) : string;
    {-Return just the drive:directory portion of a pathname}
  var
    I : Word;
  begin
    I := Succ(Word(Length(PathName)));
    repeat
      Dec(I);
    until (PathName[I] in ['\',':',#0]) or (I = 0);

    if I = 0 then
      {Had no drive or directory name}
      JustPathname := ''
    else if I = 1 then
      {Either the root directory of default drive or invalid pathname}
      JustPathname := PathName[1]
    else if (PathName[I] = '\') then begin
      if PathName[Pred(I)] = ':' then
        {Root directory of a drive, leave trailing backslash}
        JustPathname := Copy(PathName, 1, I)
      else
        {Subdirectory, remove the trailing backslash}
        JustPathname := Copy(PathName, 1, Pred(I));
    end else
      {Either the default directory of a drive or invalid pathname}
      JustPathname := Copy(PathName, 1, I);
  end;

  function JustFilename(PathName : string) : string;
    {-Return just the filename of a pathname}
  var
    I : Word;
  begin
    I := Succ(Word(Length(PathName)));
    repeat
      Dec(I);
    until (I = 0) or (PathName[I] in ['\', ':', #0]);
    JustFilename := Copy(PathName, Succ(I), 64);
  end;

  function JustName(PathName : string) : string;
    {-Return just the name (no extension, no path) of a pathname}
  var
    DotPos : Byte;
  begin
    PathName := JustFileName(PathName);
    DotPos := Pos('.', PathName);
    if DotPos > 0 then
      PathName := Copy(PathName, 1, DotPos-1);
    JustName := PathName;
  end;


function CRC16(s : string) : system.word;  { By Kevin Cooney }
var
  crc : longint;
  t,r : byte;
begin
  crc := 0;
  for t := 1 to length(s) do
  begin
    crc := (crc xor (ord(s[t]) shl 8));
    for r := 1 to 8 do
      if (crc and $8000)>0 then
        crc := ((crc shl 1) xor $1021)
          else
            crc := (crc shl 1);
  end;
  CRC16 := (crc and $FFFF);
end;

end.
