{ Fills a string with random data from an array of AnsiString words. }
procedure FillRandom(var s: AnsiString);
var
  p1, p2: ^Byte;
  l1, l2: Integer;
  w: AnsiString;
const
  Words: array[0..29] of AnsiString =
  ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine',
    'null', 'eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun',
    'zéro', 'un', 'duex', 'trois', 'quatre', 'cinq', 'six', 'sept', 'huit', 'neuf');
begin
  p1 := Pointer(s);
  l1 := Length(s);
  while l1 > 0 do
    begin
      w := Words[Random(High(Words) + 1)];
      p2 := Pointer(w);
      l2 := Length(w);
      while (l1 > 0) and (l2 > 0) do
        begin
          p1^ := p2^;
          Inc(p1); Inc(p2);
          Dec(l1); Dec(l2);
        end;
      if l1 > 0 then
        begin
          p1^ := $20;
          Inc(p1); Dec(l1);
        end;
    end;
end;
