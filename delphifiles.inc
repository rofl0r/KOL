{
   This part of the unit modified by Tim Slusher and Vladimir Kladov.
}

{* Set of utility methods to work with files
   and reqistry.
   When programming KOL, which is Windows API-oriented, You should
   avoid alien (for Windows) embedded Pascal files handling, and
   use API-calls which implemented very well. This set of functions
   is intended to make this easier.
   Also TDirList object implementation present here and some registry
   access functions, which allow to make code more elegant.
}

{$UNDEF ASM_LOCAL}
{$IFDEF ASM_VERSION}
  {$DEFINE ASM_LOCAL}
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileCreate(const FileName: string; OpenFlags: DWord): THandle;
asm
        XOR      ECX, ECX
        PUSH     ECX
        MOV      ECX, EDX
        SHR      ECX, 16
        AND      CX, $1FFF
        JNZ      @@1
        MOV      CL, FILE_ATTRIBUTE_NORMAL
@@1:    PUSH     ECX
        MOV      CL, DH
        PUSH     ECX                  // CreationMode
        PUSH     0
        MOV      CL, DL
        PUSH     ECX                  // ShareMode
        MOV      DX, 0
        PUSH     EDX                  // AccessMode
        //CALL     System.@LStrToPChar // FileName must not be ''
        PUSH     EAX
        CALL     CreateFile
end;
{$ELSE ASM_VERSION} //Pascal
function FileCreate(const FileName: string; OpenFlags: DWord): THandle;
var Attr: DWORD;
begin
  Attr := (OpenFlags shr 16) and $1FFF;
  if Attr = 0 then Attr := FILE_ATTRIBUTE_NORMAL;
  Result := CreateFile( PChar(FileName), OpenFlags and $F0000000,
                        OpenFlags and $F, nil, (OpenFlags shr 8) and $F,
                        Attr, 0 );
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileClose(Handle: THandle): Boolean;
asm
        PUSH     EAX
        CALL     CloseHandle
        TEST     EAX, EAX
        SETNZ    AL
end;
{$ELSE ASM_VERSION} //Pascal
function FileClose(Handle: THandle): boolean;
begin
     Result := CloseHandle(Handle);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileExists( const FileName : String ) : Boolean;
const size_TWin32FindData = sizeof( TWin32FindData );
asm
        CALL     EAX2PChar
        PUSH     EAX
        CALL     GetFileAttributes
        INC      EAX
        JZ       @@exit
        DEC      EAX
        {$IFDEF PARANOIA}
        DB $24, FILE_ATTRIBUTE_DIRECTORY
        {$ELSE}
        AND      AL, FILE_ATTRIBUTE_DIRECTORY
        {$ENDIF}
        SETZ     AL
@@exit:
end;
{$ELSE ASM_VERSION} //Pascal
function FileExists( const FileName : String ) : Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(FileName));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code = 0);
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileSeek(Handle: THandle; MoveTo: integer; MoveMethod: TMoveMethod): DWord;
asm
        MOVZX    ECX, CL
        PUSH     ECX
        PUSH     0
        PUSH     EDX
        PUSH     EAX
        CALL     SetFilePointer
end;
{$ELSE ASM_VERSION} //Pascal
function FileSeek(Handle: THandle; MoveTo: integer; MoveMethod: TMoveMethod): DWord;
begin
  Result := SetFilePointer(Handle, MoveTo, nil, Ord( MoveMethod ) );
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileRead(Handle: THandle; var Buffer; Count: DWord): DWord;
asm
        PUSH     EBP
        PUSH     0
        MOV      EBP, ESP
        PUSH     0
        PUSH     EBP
        PUSH     ECX
        PUSH     EDX
        PUSH     EAX
        CALL     ReadFile
        TEST     EAX, EAX
        POP      EAX
        JNZ      @@exit
        XOR      EAX, EAX
@@exit:
        POP      EBP
end;
{$ELSE ASM_VERSION} //Pascal
function FileRead(Handle: THandle; var Buffer; Count: DWord): DWord;
begin
     if not ReadFile(Handle, Buffer, Count, Result, nil) then
       Result := 0;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function File2Str(Handle: THandle): String;
asm
        PUSH     EDX
        TEST     EAX, EAX
        JZ       @@exit // return ''

        PUSH     EBX
        MOV      EBX, EAX // EBX = Handle
        XOR      EDX, EDX
        XOR      ECX, ECX
        INC      ECX
        CALL     FileSeek
        PUSH     EAX // Pos
        PUSH     0
        PUSH     EBX
        CALL     GetFileSize
        POP      EDX
        SUB      EAX, EDX // EAX = Size - Pos
        JZ       @@exitEBX

        PUSH     EAX
        CALL     System.@GetMem
        XCHG     EAX, EBX
        MOV      EDX, EBX
        POP      ECX
        PUSH     ECX
        CALL     FileRead
        POP      ECX
        MOV      EDX, EBX
        POP      EBX
        POP      EAX
        PUSH     EDX
        {$IFDEF _D2}
        CALL     _LStrFromPCharLen
        {$ELSE}
        CALL     System.@LStrFromPCharLen
        {$ENDIF}
        JMP      @@freebuf

@@exitEBX:
        POP      EBX
@@exit:
        XCHG     EDX, EAX
        POP      EAX // @Result
        PUSH     EDX
        CALL     System.@LStrFromPChar
@@freebuf:
        POP      EAX
        TEST     EAX, EAX
        JZ       @@fin
        CALL     System.@FreeMem
@@fin:
end;
{$ELSE ASM_VERSION} //Pascal
function File2Str(Handle: THandle): String;
var Pos, Size: DWORD;
begin
  Result := '';
  if Handle = 0 then Exit;
  Pos := FileSeek( Handle, 0, spCurrent );
  Size := GetFileSize( Handle, nil );
  SetString( Result, nil, Size - Pos + 1 );
  FileRead( Handle, Result[ 1 ], Size - Pos );
  Result[ Size - Pos + 1 ] := #0;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileWrite(Handle: THandle; const Buffer; Count: DWord): DWord;
asm
        PUSH     EBP
        PUSH     EBP
        MOV      EBP, ESP
        PUSH     0
        PUSH     EBP
        PUSH     ECX
        PUSH     EDX
        PUSH     EAX
        CALL     WriteFile
        TEST     EAX, EAX
        POP      EAX
        JNZ      @@exit
        XOR      EAX, EAX
@@exit:
        POP      EBP
end;
{$ELSE ASM_VERSION} //Pascal
function FileWrite(Handle: THandle; const Buffer; Count: DWord): DWord;
begin
     if not WriteFile(Handle, Buffer, Count, Result, nil) then
       Result := 0;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
function FileEOF( Handle: THandle ) : Boolean;
asm
        PUSH     EAX

        PUSH     0
        PUSH     EAX
        CALL     GetFileSize

        XCHG     EAX, [ESP]

        MOV      CL, spCurrent
        XOR      EDX, EDX
        CALL     FileSeek

        POP      EDX
        CMP      EAX, EDX
        SETGE    AL
end;
{$ELSE ASM_VERSION} //Pascal
function FileEOF( Handle: THandle ) : Boolean;
var Siz, Pos : DWord;
begin
  Siz := GetFileSize( Handle, nil );
  Pos := FileSeek( Handle, 0, spCurrent );
  Result := Pos >= Siz;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_noVERSION}
function FileFullPath( const FileName: String ) : String;
const
  BkSlash: String = '\';
  szTShFileInfo = sizeof( TShFileInfo );
asm
        PUSH     EBX
        PUSH     ESI
        MOV      EBX, EDX
        PUSH     EAX

        XCHG     EAX, EDX
        CALL     System.@LStrClr

        POP      EDX
        PUSH     0
        MOV      EAX, ESP
        CALL     System.@LStrAsg
        MOV      ESI, ESP

@@loo:  CMP      dword ptr [ESI], 0
        JZ       @@fin

        MOV      EAX, ESI
        MOV      EDX, [BkSlash]
        PUSH     0
        MOV      ECX, ESP
        CALL     Parse

        CMP      dword ptr [EBX], 0
        JE       @@1
        MOV      EAX, EBX
        MOV      EDX, [BkSlash]
        CALL     System.@LStrCat
        JMP      @@2
@@1:
        POP      EAX
        PUSH     EAX
        CALL     System.@LStrLen
        CMP      EAX, 2
        JNE      @@2
        POP      EAX
        PUSH     EAX
        CMP      byte ptr [EAX+1], ':'
        JNE      @@2

        MOV      EAX, EBX
        POP      EDX
        PUSH     EDX
        CALL     System.@LStrAsg
        JMP      @@3
@@2:
        PUSH     0
        MOV      EAX, ESP
        MOV      EDX, [EBX]
        CALL     System.@LStrAsg
        MOV      EAX, ESP
        MOV      EDX, [ESP+4]
        CALL     System.@LStrCat
        POP      EAX
        PUSH     EAX
        SUB      ESP, szTShFileInfo
        MOV      EDX, ESP
        PUSH     SHGFI_DISPLAYNAME
        PUSH     szTShFileInfo
        PUSH     EDX
        PUSH     0
        PUSH     EAX
        CALL     ShGetFileInfo
        LEA      EDX, [ESP].TShFileInfo.szDisplayName
        CMP      byte ptr [EDX], 0
        JE       @@clr_stk
        LEA      EAX, [ESP+szTShFileInfo+4]
        CALL     System.@LStrFromPChar
@@clr_stk:
        ADD      ESP, szTShFileInfo
        CALL     RemoveStr
        POP      EDX
        PUSH     EDX
        MOV      EAX, EBX
        CALL     System.@LStrCat

@@3:    CALL     RemoveStr
        JMP      @@loo

@@fin:  CALL     RemoveStr
        POP      ESI
        POP      EBX
end;
{$ELSE ASM_VERSION} //Pascal
function FileFullPath( const FileName: String ) : String;
var SFI: TShFileInfo;
    Src, S: String;
begin
  Result := '';
  Src := FileName;
  while Src <> '' do
  begin
    S := Parse( Src, '\' );
    if Result <> '' then
      Result := Result + '\';
    if (Result = '') and (Length( S ) = 2) and (S[ 2 ] = ':') then
      Result := S
    else
    begin
      ShGetFileInfo( PChar( Result + S ), 0, SFI, Sizeof( SFI ),
                     SHGFI_DISPLAYNAME );
      if SFI.szDisplayName[ 0 ] <> #0 then
        S := SFI.szDisplayName;
      Result := Result + S;
    end;
  end;
  if ExtractFileExt( Result ) = '' then
  // case when flag 'Hide extensions for registered file types' is set on
  // in the Explorer:
    Result := Result + ExtractFileExt( FileName );
end;
{$ENDIF ASM_VERSION}

function FileShortPath( const FileName: String ): String;
var Buf: array[ 0..MAX_PATH ] of Char;
begin
  GetShortPathName( PChar( FileName ), Buf, Sizeof( Buf ) );
  Result := Buf;
end;

function FileIconSystemIdx( const Path: String ): Integer;
var SFI: TShFileInfo;
begin
  SFI.iIcon := 0; // Bartov
  ShGetFileInfo( PChar( Path ), 0, SFI, sizeof( SFI ),
                 //-- Babenko Alexey: -----------------//
                 // SHGFI_ICON or                     //
                 //----------------------------------//
                 SHGFI_SMALLICON or SHGFI_SYSICONINDEX );
  Result := SFI.iIcon;
end;

function FileIconSysIdxOffline( const Path: String ): Integer;
var SFI: TShFileInfo;
begin
  SFI.iIcon := 0; // Bartov
  ShGetFileInfo( PChar( Path ), FILE_ATTRIBUTE_NORMAL, SFI, sizeof( SFI ),
                 //-- Babenko Alexey: -----------------//
                 // SHGFI_ATTRIBUTES or SHGFI_ICON or //
                 //----------------------------------//
                 SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES );
  Result := SFI.iIcon;
end;

procedure LogFileOutput( const filepath, str: String );
var F: HFile;
begin
  F := FileCreate( filepath, ofOpenWrite or ofOpenAlways );
  if F = INVALID_HANDLE_VALUE then Exit;
  FileSeek( F, 0, spEnd );
  FileWrite( F, {$IFNDEF _D2} String {$ENDIF}
             ( str + #13#10 )[ 1 ], Length( str ) + 2 );
  FileClose( F );
end;

function StrSaveToFile( const Filename, Str: String ): Boolean;
var F: HFile;
begin
  Result := FALSE;
  F := FileCreate( Filename, ofOpenWrite or ofOpenAlways );
  if F = INVALID_HANDLE_VALUE then Exit;
  FileWrite( F, Str[ 1 ], Length( Str ) );
  FileClose( F );
  Result := TRUE;
end;

function StrLoadFromFile( const Filename: String ): String;
var F: HFile;
begin
  Result := '';
  F := FileCreate( Filename, ofOpenRead or ofOpenExisting or ofShareDenyWrite );
  if F = INVALID_HANDLE_VALUE then Exit;
  Result := File2Str( F );
  FileClose( F ); {??ee(zhog); Dark Knight}
end;

{$IFDEF ASM_VERSION}
function DirectoryExists(const Name: string): Boolean;
asm
        //CALL     System.@LStrToPChar // Name must not be ''
        PUSH     EAX
        CALL     GetFileAttributes
        INC      EAX
        JZ       @@exit
        DEC      EAX
        {$IFDEF PARANOIA}
        DB $24, FILE_ATTRIBUTE_DIRECTORY
        {$ELSE}
        AND      AL, FILE_ATTRIBUTE_DIRECTORY
        {$ENDIF}
        SETNZ    AL
@@exit:
end;
{$ELSE ASM_VERSION} //Pascal
function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ENDIF ASM_VERSION}

function CheckDirectoryContent( const Name: String; SubDirsOnly: Boolean; const Mask: String ): Boolean;
var FD: TWin32FindData;
    FH: THandle;
begin
  if not DirectoryExists( Name ) then
    Result := TRUE
  else
  begin
    FH := Windows.FindFirstFile( PChar( IncludeTrailingPathDelimiter( Name )
       + Mask ), FD );
    if FH = INVALID_HANDLE_VALUE then
      Result := TRUE
    else
    begin
      Result := TRUE;
      repeat
        if not StrIn( FD.cFileName, ['.','..'] ) then
        begin
          if SubDirsOnly and LongBool(FD.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)
             or not SubDirsOnly then
          begin
            Result := FALSE;
            break;
          end;
        end;
      until not Windows.FindNextFile( FH, FD );
      Windows.FindClose( FH );
    end;
  end;
end;

function DirectoryEmpty(const Name: String): Boolean;
begin
  Result := CheckDirectoryContent( Name, FALSE, '*.*' );
end;

{-}
function DirectorySize( const Path: String ): I64;
var DirList: PDirList;
    I: Integer;
begin
  Result := MakeInt64( 0, 0 );
  DirList := NewDirList( Path, '*.*', 0 );
  for I := 0 to DirList.Count-1 do
  begin
    if LongBool( DirList.Items[ I ].dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY ) then
      Result := Add64( Result, DirectorySize( DirList.Path + DirList.Names[ I ] ) )
    else
      Result := Add64( Result, MakeInt64( DirList.Items[ I ].nFileSizeLow,
             DirList.Items[ I ].nFileSizeHigh ) );
  end;
  DirList.Free;
end;
{+}

function DirectoryHasSubdirs( const Path: String ): Boolean;
begin
  Result := not CheckDirectoryContent( Path, TRUE, '*.*' );
end;

function  GetFileList(const dir: string): PStrList;
var
   Srch: TWin32FindData;
   flag: Integer;
   succ: boolean;
begin
   result := nil;
   flag := FindFirstFile(PChar(dir), Srch);
   succ := flag <> 0;
   while succ do begin
      if (not (Srch.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY > 0))then begin
         if Result = nil then begin
            Result := NewStrList;
         end;
         Result.Add(Srch.cFileName);
      end;
      succ := FindNextFile(Flag, Srch);
   end;
   FindClose(Flag);
end;

function ExcludeTrailingChar( const S: String; C: Char ): String;
begin
  Result := S;
  if Result <> '' then
  if Result[ Length( Result ) ] = C then
    Delete( Result, Length( Result ), 1 );
end;

function IncludeTrailingChar( const S: String; C: Char ): String;
begin
  Result := S;
  if (Result = '') or (Result[ Length( Result ) ] <> C) then
    Result := Result + C;
end;

//---------------------------------------------------------
// Following functions/procedures are created by Edward Aretino:
// IncludeTrailingPathDelimiter, ExcludeTrailingPathDelimiter,
// ForceDirectories, CreateDir, ChangeFileExt
//---------------------------------------------------------
function IncludeTrailingPathDelimiter(const S: string): string;
begin
   {if CopyTail(S, 1) <> '\' then
     Result := S + '\'
   else
     Result := S;}
   Result := IncludeTrailingChar( S, '\' );
end;

function ExcludeTrailingPathDelimiter(const S: string): string;
begin
   {Result := S;
   if Length(Result) = 0 then Exit;

   if (CopyTail(Result, 1) = '\') then
     DeleteTail(Result, 1);}
   Result := ExcludeTrailingChar( S, '\' );
end;

function ForceDirectories(Dir: string): Boolean;
begin
 Result := Length(Dir) > 0; {Centronix}
 If not Result then Exit;
 Dir := ExcludeTrailingPathDelimiter(Dir);
 If (Length(Dir) < 3) or DirectoryExists(Dir) or
   (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
 Result := ForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
end;

function CreateDir(const Dir: string): Boolean;
begin
   Result := Windows.CreateDirectory(PChar(Dir), nil);
end;

function ChangeFileExt(FileName: String; const Extension: string): string;
var
   FileExt: String;
begin
   FileExt := ExtractFileExt(FileName);
   DeleteTail(FileName, Length(FileExt));
   Result := FileName+ Extension;
end;

{$IFDEF ASM_VERSION}
{$IFNDEF _D2}
{$DEFINE ASM_LStrFromPCharLen}
{$ENDIF}
{$ENDIF ASM_VERSION}

{$IFDEF ASM_LStrFromPCharLen}
  {$DEFINE ASM_DIRDelimiters}
{$ENDIF}

{$IFDEF ASM_VERSION}
  {$DEFINE ASM_DIRDelimiters}
{$ENDIF ASM_VERSION}

{$IFDEF ASM_DIRDelimiters}
const
  DirDelimiters: PChar = ':\';
{$ENDIF}

{$IFDEF ASM_VERSION}
function ExtractFileName( const Path : String ) : String;
asm
        PUSH     EDX
        PUSH     EAX
        MOV      EDX, [DirDelimiters]
        CALL     __DelimiterLast
        POP      EDX
        CMP      byte ptr [EAX], 0
        JZ       @@1
        XCHG     EDX, EAX
        INC      EDX
@@1:    POP      EAX
        CALL     System.@LStrFromPChar
end;
{$ELSE ASM_VERSION} //Pascal
function ExtractFileName( const Path : String ) : String;
var P: PChar;
begin
  P := __DelimiterLast( PChar( Path ), ':\' );
  if P^ = #0 then
    Result := Path
  else
    Result := P + 1;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_LStrFromPCharLen} // LStrFromPCharLen - there are no in D2
function ExtractFilePath( const Path : String ) : String;
asm
        PUSH     EDX
        MOV      EDX, [DirDelimiters]
        CALL     EAX2PChar
        PUSH     EAX
        CALL     __DelimiterLast
        XCHG     EDX, EAX
        XOR      ECX, ECX
        POP      EAX
        CMP      byte ptr [EDX], CL
        JZ       @@ret_0
        SUB      EDX, EAX
        INC      EDX
        XCHG     EDX, EAX
        XCHG     ECX, EAX
@@ret_0:
        POP      EAX
        CALL     System.@LStrFromPCharLen
end;
{$ELSE} //Pascal
function ExtractFilePath( const Path : String ) : String;
//var I : Integer;
var P, P0: PChar;
begin
  P0 := PChar( Path );
  P := __DelimiterLast( P0, ':\' );
  if P^ = #0 then
    Result := ''
  else
    Result := Copy( Path, 1, P - P0 + 1 );
end;
{$ENDIF}

function ExtractFileNameWOext( const Path : String ) : String;
begin
  Result := ExtractFileName( Path );
  Result := Copy( Result, 1, Length( Result ) - Length( ExtractFileExt( Result ) ) );
end;

{$IFDEF ASM_VERSION}
const
  ExtDelimeters: PChar = '.';

function ExtractFileExt( const Path : String ) : String;
asm
        PUSH     EDX
        MOV      EDX, [ExtDelimeters]
        CALL     EAX2PChar
        CALL     __DelimiterLast
@@1:    XCHG     EDX, EAX
        POP      EAX
        CALL     System.@LStrFromPChar
end;
{$ELSE ASM_VERSION} //Pascal
function ExtractFileExt( const Path : String ) : String;
var P: PChar;
begin
  P := __DelimiterLast( PChar( Path ), '.' );
  Result := P;
end;
{$ENDIF ASM_VERSION}

function ReplaceFileExt( const Path, NewExt: String ): String;
begin
  Result := ExtractFilePath( Path ) +
            ExtractFileNameWOext( ExtractFileName( Path ) ) +
            NewExt;
end;

function ExtractShortPathName( const Path: String ): String;
var
  Buffer: array[0..MAX_PATH - 1] of Char;
begin
  SetString(Result, Buffer,
    GetShortPathName(PChar(Path), Buffer, SizeOf(Buffer)));
end;

function FilePathShortened( const Path: String; MaxLen: Integer ): String;
begin
  Result := FilePathShortenPixels( Path, 0, MaxLen );
end;

function PixelsLength( DC: HDC; const Text: String ): Integer;
var Sz: TSize;
begin
  if DC = 0 then
    Result := Length( Text )
  else
  begin
    Windows.GetTextExtentPoint32( DC, PChar( Text ), Length( Text ), Sz );
    Result := Sz.cx;
  end;
end;

function FilePathShortenPixels( const Path: String; DC: HDC; MaxPixels: Integer ): String;
var L0, L1: Integer;
    Prev: String;
begin
 Result := Path;
 L0 := PixelsLength( DC, Result );
 while L0 > MaxPixels do
 begin
   Prev := Result;
   L1 := pos( '\...\', Result );
   if L1 <= 0 then
     Result := ExcludeTrailingPathDelimiter( ExtractFilePath( Result ) )
   else
     Result := Copy( Result, 1, L1 - 1 );
   if Result <> '' then
     Result := IncludeTrailingPathDelimiter( ExtractFilePath( Result ) ) + '...\' + ExtractFileName( Path );
   if (Result = '') or (Result = Prev) then
   begin
     L1 := Length( ExtractFilePath( Result ) );
     while (PixelsLength( DC, Result ) > MaxPixels) and (L1 > 1) do
     begin
       Dec( L1 );
       Result := Copy( Result, 1, L1 ) + '...\' + ExtractFileName( Result );
     end;
     if PixelsLength( DC, Result ) > MaxPixels then
     begin
       L1 := MaxPixels + 1;
       while ((MaxPixels > 0) and (L1 > 1) or (MaxPixels = 0) and (L1 > 0)) and
             (PixelsLength( DC, Result ) > MaxPixels) do
       begin
         Dec( L1 );
         Result := Copy( ExtractFileName( Path ), 1, L1 ) + '...';
       end;
     end;
     break;
   end;
   L0 := PixelsLength( DC, Result );
 end;
end;

procedure CutFirstDirectory(var S: String);
var
  Root: Boolean;
  P: Integer;
begin
  if S = '\' then
    S := ''
  else
  begin
    if S[1] = '\' then
    begin
      Root := True;
      Delete(S, 1, 1);
    end
    else
      Root := False;
    if S[1] = '.' then
      Delete(S, 1, 4);
    P := pos('\',S);
    if P <> 0 then
    begin
      Delete(S, 1, P);
      S := '...\' + S;
    end
    else
      S := '';
    if Root then
      S := '\' + S;
  end;
end;

function MinimizeName( const Path: String; DC: HDC; MaxPixels: Integer ): String;
var
  Drive, Dir, Name: String;
begin
  Result := Path;
  Dir := ExtractFilePath(Result);
  Name := ExtractFileName(Result);

  if (Length(Dir) >= 2) and (Dir[2] = ':') then
  begin
    Drive := Copy(Dir, 1, 2);
    Delete(Dir, 1, 2);
  end
  else
    Drive := '';
  while ((Dir <> '') or (Drive <> '')) and (PixelsLength(DC, Result) > MaxPixels) do
  begin
    if Dir = '\...\' then
    begin
      Drive := '';
      Dir := '...\';
    end
    else if Dir = '' then
      Drive := ''
    else
      CutFirstDirectory(Dir);
    Result := Drive + Dir + Name;
  end;
end;

{$IFDEF ASM_VERSION}
function FileSize( const Path : String ) : Integer;
const size_TWin32FindData = sizeof( TWin32FindData );
asm
        ADD      ESP, - size_TWin32FindData
        PUSH     ESP
        //CALL     System.@LStrToPChar // Path must not be ''
        PUSH     EAX
        CALL     FindFirstFile
        INC      EAX
        JZ       @@exit
        DEC      EAX
        PUSH     EAX
        CALL     FindClose

        MOV      EAX, [ESP].TWin32FindData.nFileSizeLow
@@exit:
        ADD      ESP, size_TWin32FindData
end;
{$ELSE ASM_VERSION} //Pascal
function FileSize( const Path : String ) : Integer;
var FD : TWin32FindData;
    FH : THandle;
begin
  FH := FindFirstFile( PChar( Path ), FD );
  Result := 0;
  if FH = INVALID_HANDLE_VALUE then exit;
  Result := FD.nFileSizeLow;
  if ((FD.nFileSizeLow and $80000000) <> 0) or
     (FD.nFileSizeHigh <> 0) then Result := -1;
  FindClose( FH );
end;
{$ENDIF ASM_VERSION}

//*
function FileTimeCompare( const FT1, FT2 : TFileTime ) : Integer;
var ST1, ST2 : TSystemTime;
begin
  FileTimeToSystemTime( FT1, ST1 );
  FileTimeToSystemTime( FT2, ST2 );
  Result := CompareSystemTime( ST1, ST2 );
end;

function GetSystemDir: String;
var Buf: array[ 0..MAX_PATH ] of Char;
begin
  GetSystemDirectory( @ Buf[ 0 ], MAX_PATH + 1 );
  Result := IncludeTrailingPathDelimiter( PChar( @ Buf[ 0 ] ) );
end;

//*
function GetWindowsDir : string;
var Buf : array[ 0..MAX_PATH ] of Char;
begin
  GetWindowsDirectory( @Buf[ 0 ], MAX_PATH + 1 );
  Result := IncludeTrailingPathDelimiter( PChar( @ Buf[ 0 ] ) );
end;

function GetWorkDir : string;
var Buf: array[ 0..MAX_PATH ] of Char;
begin
  GetCurrentDirectory( MAX_PATH + 1, @ Buf[ 0 ] );
  Result := IncludeTrailingPathDelimiter( PChar( @ Buf[ 0 ] ) );
end;

//*
function GetTempDir : string;
var Buf : array[ 0..MAX_PATH ] of Char;
begin
  Windows.GetTempPath( MAX_PATH + 1, @Buf[ 0 ] );
  Result := IncludeTrailingPathDelimiter( PChar( @ Buf[ 0 ] ) );
end;

function CreateTempFile( const DirPath, Prefix: String ): String;
var Buf: array[ 0..MAX_PATH ] of Char;
begin
  GetTempFileName( PChar( DirPath ), PChar( Prefix ), 0, Buf );
  Result := Buf;
end;

function  GetFileListStr(FPath{e.g.'c:\tmp\'}, FMask{e.g.'*.*'}: string): string;
{* List of files in string, separating each path from others with semicolon (';').
   E.g.: 'c:\tmp\unit1.dcu;c:\tmp\unit1.~pa' (for use with DeleteFile2Recycle())}
var
   Srch: TWin32FindData;
   flag: Integer;
   succ: boolean;
   dir:string;
begin
   result := '';
   if (FPath<>'') and (FPath[length(FPath)]<>'\') then FPath:=FPath+'\';
   if (FMask<>'') and (FMask[1]='\') then FMask:=CopyEnd(FMask,2);
   dir:=FPath+FMask;
   flag := FindFirstFile(PChar(dir), Srch);
   succ := flag <> 0;
   while succ do begin
      if (not (Srch.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY > 0))then begin
         if Result<>''then Result:=Result+';';
         Result:=Result+FPath+Srch.cFileName;
      end;
      succ := FindNextFile(Flag, Srch);
   end;
   FindClose(Flag);
end;

function DeleteFiles( const DirPath: String ): Boolean;
var Files, Name: String;
begin
  Files := GetFileListStr( ExtractFilePath( DirPath ), ExtractFileName( DirPath ) );
  Result := TRUE;
  while Files <> '' do
  begin
    Name := Parse( Files, ';' );
    Result := Result and DeleteFile( PChar( Name ) );
  end;
end;

//*
function DeleteFile2Recycle( const Filename : String ) : Boolean;
var FOS : TSHFileOpStruct;
    Buf : PChar;
    L : Integer;
begin
  L := Length( Filename );
  GetMem( Buf, L + 2 );
  StrCopy( Buf, PChar( Filename ) );
  Buf[ L + 1 ] := #0;
  for L := L downto 0 do
    if Buf[ L ] = ';' then Buf[ L ] := #0;
  FillChar( FOS, Sizeof( FOS ), 0 );
  if Applet <> nil then
    FOS.Wnd := Applet.Handle;
  FOS.wFunc := FO_DELETE;
  FOS.pFrom := Buf;
  FOS.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  FOS.fAnyOperationsAborted := True;
  FOS.lpszProgressTitle := PChar( 'Delete ' + Filename + ' to Recycle bin' );
  Result := SHFileOperation( FOS ) = 0;
  if Result then
    Result := not FOS.fAnyOperationsAborted;
  FreeMem( Buf );
end;

function CopyMoveFiles( const FromList, ToList: String; Move: Boolean ): Boolean;
var FOS : TSHFileOpStruct;
    Buf : PChar;
    L : Integer;
begin
  L := Length( FromList );
  GetMem( Buf, L + 2 );
  StrCopy( Buf, PChar( FromList ) );
  Buf[ L + 1 ] := #0;
  for L := L downto 0 do
    if Buf[ L ] = ';' then Buf[ L ] := #0;
  FillChar( FOS, Sizeof( FOS ), 0 );
  if Applet <> nil then
    FOS.Wnd := Applet.Handle;
  if Move then
  begin
    FOS.wFunc := FO_MOVE;
    FOS.lpszProgressTitle := PChar( 'Move files' );
  end
    else
  begin
    FOS.wFunc := FO_COPY;
    FOS.lpszProgressTitle := PChar( 'Copy files' );
  end;
  FOS.pFrom := Buf;
  FOS.pTo := PChar( ToList + #0 );
  FOS.fFlags := FOF_ALLOWUNDO;
  FOS.fAnyOperationsAborted := True;
  Result := SHFileOperation( FOS ) = 0;
  if Result then
    Result := not FOS.fAnyOperationsAborted;
  FreeMem( Buf );
end;

{-}
function DiskFreeSpace( const Path: String ): I64;
type TGetDFSEx = function( Path: PChar; CallerFreeBytes, TotalBytes, FreeBytes: Pointer )
                 : Bool; stdcall;
var GetDFSEx: TGetDFSEx;
    Kern32: THandle;
    V: TOSVersionInfo;
    Ex: Boolean;
    SpC, BpS, NFC, TNC: DWORD;
    FBA, TNB: I64;
begin
  GetDFSEx := nil;
  V.dwOSVersionInfoSize := Sizeof( V );
  GetVersionEx( V );
  Ex := FALSE;
  if V.dwPlatformId = VER_PLATFORM_WIN32_NT then
  begin
    Ex := V.dwMajorVersion >= 4;
  end
    else
  if V.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
  begin
    Ex := V.dwMajorVersion > 4;
    if not Ex then
    if V.dwMajorVersion = 4 then
    begin
      Ex := V.dwMinorVersion > 0;
      if not Ex then
        Ex := LoWord( V.dwBuildNumber ) >= $1111;
    end;
  end;
  if Ex then
  begin
    Kern32 := GetModuleHandle( 'kernel32.dll' );
    GetDFSEx := GetProcAddress( Kern32, 'GetDiskFreeSpaceExA' );
  end;
  if Assigned( GetDFSEx ) then
    GetDFSEx( PChar( Path ), @ FBA, @ TNB, @Result )
  else
  begin
    GetDiskFreeSpace( PChar( Path ), SpC, BpS, NFC, TNC );
    Result := Mul64i( MakeInt64( SpC * BpS, 0 ), NFC );
  end;
end;
{+}

//*
function GetUniqueFilename( PathName: string ) : String;
var Path, Nam, Ext : String;
    I, J, K : Integer;
begin
  Result := PathName;
  Path := ExtractFilePath( PathName );
  if not DirectoryExists( Path ) then Exit;
  Nam := ExtractFileNameWOext( PathName );
  if Nam = '' then
  begin
    if Path[ Length( Path ) ] = '\' then
       Path := Copy( Path, 1, Length( Path ) - 1 );
    PathName := Path;
    Result := Path;
  end;
  Nam := ExtractFileNameWOext( PathName );
  Ext := ExtractFileExt( PathName );
  I := Length( Nam );
  for J := I downto 1 do
  if not (Nam[ J ] in [ '0'..'9' ]) then
  begin
    I := J;
    break;
  end;
  K := Str2Int( CopyEnd( Nam, I + 1 ) );
  while FileExists( Result ) do
  begin
    Inc( K );
    Result := Path + Copy( Nam, 1, I ) + Int2Str( K ) + Ext;
  end;
end;

{$IFDEF ASM_VERSION}
function GetStartDir : String;
asm
        PUSH     EBX
        MOV      EBX, EAX

        XOR      EAX, EAX
        MOV      AH, 2
        SUB      ESP, EAX
        MOV      EDX, ESP
        PUSH     EAX
        PUSH     EDX
        PUSH     0
        CALL     GetModuleFileName

        LEA      EDX, [ESP + EAX]
@@1:    DEC      EDX
        CMP      byte ptr [EDX], '\'
        JNZ      @@1

        INC      EDX
        MOV      byte ptr [EDX], 0

        MOV      EAX, EBX
        MOV      EDX, ESP
        CALL     System.@LStrFromPChar

        ADD      ESP, 200h
        POP      EBX
end;
{$ELSE ASM_VERSION} //Pascal
function GetStartDir : String;
var Buffer:array[0..260] of Char;
    I : Integer;
begin
  I := GetModuleFileName( 0, Buffer, Sizeof( Buffer ) );
  for I := I downto 0 do
    if Buffer[ I ] = '\' then
    begin
      Buffer[ I + 1 ] := #0;
      break;
    end;
  Result := Buffer;
end;
{$ENDIF ASM_VERSION}

//{$ENDIF LINUX/WIN32}