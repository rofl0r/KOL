program Decompress;
{$APPTYPE CONSOLE}
uses Windows, KolZLib, Kol;

const
  STRM_ERROR = DWord (-1);

// Cutted from Classes.TStream.CopyFrom with some small modifications...
function StreamCopy (Dest, Source: PStream; Count: DWord): DWord;
const
  MAXBUFSIZE = $80000;
var
  BufSize: DWord;
  Readed: DWord;
  Buffer: PChar;
  Need: DWord;
begin
  If Count=0 then begin
    Source.Position:=0;
    Count:=Source.Size;
  end;
  Result:=0;
  If Count>MAXBUFSIZE then BufSize:=MAXBUFSIZE else BufSize:=Count;
  GetMem(Buffer, BufSize);
  try // => try .. finally works for 'Exit' command even without Kol_Err.pas !
    repeat
      If Count>BufSize then Need:=BufSize else Need:=Count;
      Readed:=Source.Read (Buffer^, Need);
      If Readed=STRM_ERROR then Exit;
      If Dest.Write (Buffer^, Readed)=STRM_ERROR then Exit;
      Dec(Count, Readed);
      Inc (Result, Readed);
    until (Count=0) or (Readed=0) or (Readed=STRM_ERROR);
  finally
    // Exit brings us here...
    FreeMem(Buffer, BufSize);
  end;
end;

var
  Source: PStream;
  Dest: PStream;
  Zipper: PStream;
  Error: Boolean;
  Size: DWord;
begin
  If ParamCount<2 then begin
    WriteLn ('Usage: decompress.exe ZLibedFile OutFile');
    WriteLn ('Press Enter to exit');
    ReadLn;
    Exit;
  end;
  Error:=False;
  Source:=NewReadFileStream (ParamStr(1));
  try
    If Source.Size=STRM_ERROR then Exit;
    Dest:=NewWriteFileStream (ParamStr(2));
    try
      If Dest.Size=STRM_ERROR then Exit;
      If Source.Read (Size, 4)<>4 then Exit;
      If not NewZLibDStream (Zipper, Source, nil) then Exit;
      Error:= not (StreamCopy (Dest, Zipper, Size)=Size);
      Zipper.Free;
    finally
      Dest.Free;
      If Error then DeleteFile (PChar (ParamStr (2)));
    end;
  finally
    Source.Free;
  end;
end.

