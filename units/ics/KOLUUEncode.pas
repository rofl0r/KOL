unit UUEncode;

interface

uses KOL, 
    SysUtils;

const
  UUEncodeVersion    = 100;
  CopyRight : String = ' UUEncodeVersion Unit (c) 1998 F. Piette V1.00 ';


procedure InitUUEncode(var hFile: File; sFile: string);
procedure DoUUEncode(var hFile: File; var sLine: string; var More: boolean);
procedure EndUUEncode(var hFile: File);

implementation

type
  TLookup = array [0..64] of Char;

const
  Base64Out: TLookup =
    (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
   );

{$I+}   // Activate I/O check (EInOutError exception generated)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure InitUUEncode(var hFile: File; sFile: string);
begin
    AssignFile(hFile, sFile);
    Reset(hFile, 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure DoUUEncode(var hFile: File; var sLine: string; var More: boolean);
var
    Count     : integer;
    DataIn    : array [0..2] of byte;
    DataOut   : array [0..80] of byte;
    ByteCount : integer;
    i         : integer;
begin
    Count := 0;
{$I-}
    while not Eof(hFile) do begin
{$I+}
        BlockRead(hFile, DataIn, 3, ByteCount);
        DataOut[Count]     := (DataIn[0] and $FC) shr 2;
        DataOut[Count + 1] := (DataIn[0] and $03) shl 4;
        if ByteCount > 1 then begin
            DataOut[Count + 1] := DataOut[Count + 1] +
                                  (DataIn[1] and $F0) shr 4;
            DataOut[Count + 2] := (DataIn[1] and $0F) shl 2;
            if ByteCount > 2 then begin
                DataOut[Count + 2] := DataOut[Count + 2] +
                                      (DataIn[2] and $C0) shr 6;
                DataOut[Count + 3] := (DataIn[2] and $3F);
            end
            else begin
                DataOut[Count + 3] := $40;
            end;
        end
        else begin
            DataOut[Count + 2] := $40;
            DataOut[Count + 3] := $40;
        end;

        for i := 0 to 3 do
            DataOut[Count + i] := Byte(Base64Out[DataOut[Count + i]]);

        Count := Count + 4;

        if Count > 59 then
            break;
    end;

    DataOut[Count] := $0;
    sLine := StrPas(@DataOut[0]);

{$I-}
    More := not Eof(hFile);
{$I+}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure EndUUEncode(var hFile: File);
begin
    CloseFile(hFile);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

