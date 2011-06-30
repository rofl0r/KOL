{--- Хранилище файлов --- - это директория (желательно на другом винчестере) или
  расшаренная сетевая папка следующей структуры:
  - для каждой исходной машины создается своя директория с именем компьютера;
  - история для файлов, сохраняется в файле с именем NNNNNNNN+имя-файла.ext;

  При сохранении всей истории файла в файле хранилища с именем
  NNNNNNNN+имя-файла.ext формат следующий:
  - дата последней модификации на момент сохранения (TFileTime, 8 байт);
  - размер файла не сжатый, 4 байта;
  - контрольная сумма, 4 байта;
  - тип записи: бит0: 0 - сам файл, 1 - данные для изменения
                бит1: 0 - без сжатия, 1 - используется сжатие (UPX)
  - длина блока = Lc: 4 байта (если сжат, то следкющие 4 байта сюда входят)
  - если блок сжат, то длина несжатого содержимого блока Ln: 4 байта
  - блок: Lc-4 байт если не сжато, иначе Ln
}
unit StorageUnit;

interface

uses Windows, KOL, FileVersionUnit;

type
  TEnumSectionsProc = procedure( FileStream: PStream; const FI: TFileVersionInfo;
    SectionType: Byte; SectionLen: DWORD; var Continue: Boolean ) of object;

  PStorage = ^TStorage;
  TStorage = object( TObj )
  private
    FPath: String;
    FOK: Boolean;
    procedure SetPath(const Value: String);
  protected
    FMachineName: String;
    procedure Init; virtual;
  public
    destructor Destroy; virtual;
    property Path: String read FPath write SetPath;
    property OK: Boolean read FOK;
  public
    DirsIndex: PStrListEx;
    function DirPrefix( const DirPath: String ): String; // 8 цифр по имени директории
  public
    function CheckFile( const SrcFilePath: String; var ChkSum: DWORD ): Boolean;
    // файл изменился с последнего сохранения? Если контрольная сумма была
    // посчитана, то она возвращается <> 0
    procedure UpdateFile( const SrcFilePath: String; ChkSum: DWORD; Action: Integer );
    // обновить файл в базе
    function SaveFileHistory( const SrcFilePath: String ): Boolean;
    // просмотр секций архива одного файла
  public
    FoundLastFullVersionPos: DWORD;
    LastInfo: TFileVersionInfo;
    LastVersion: PStream;
    UnpackError: Boolean;
    UnpackingFile: String;
    procedure EnumSections( FileStream: PStream; EnumProc: TEnumSectionsProc );
    // поиск последней полной секции, с которой можно начать восстановление
    // последней сохраненной секции
    procedure LookForLastFullVersion( FileStream: PStream; const FI: TFileVersionInfo;
      SecType: Byte; SecLen: DWORD; var Cont: Boolean );
    // поиск и восстановление самой последней сохраненной версии файла
    procedure LookRestoreLastVersion( FileStream: PStream; const FI: TFileVersionInfo;
      SecType: Byte; SecLen: DWORD; var Cont: Boolean );
    // поиск информации о последней сохраненной версии: дата, контрольная сумма и размер
    procedure LookForLastVersionInfo( FileStream: PStream; const FI: TFileVersionInfo;
      SecType: Byte; SecLen: DWORD; var Cont: Boolean );
    procedure ProgressHandler( Percents, CurrentPosition, TotalSize: Integer;
              var Cancel: Boolean );
  public
    CacheVersionInfo: PStrListEx;
    procedure ClearCacheVersionInfo;
    procedure PutCachedVersionInfo( const SrcFilePath: String; var FI: TFileVersionInfo );
    function GetCachedVersionInfo( const SrcFilePath: String; var FI: TFileVersionInfo ): Boolean;
    procedure DelCachedVersionInfo( const SrcFilePath: String );
    procedure UpdCachedVersionInfo( const SrcFilePath: String; const ft: TFileTime );
  end;

var
  Storage: PStorage;

implementation

uses MainUnit, DIUCLStreams, UpdatesUnit;

function CalcFileCheckSum( const FS: PStream; var ChkSum: DWORD ): Boolean;
         overload;
var BufSize: Integer;
    L: DWORD;
    Buf, B: PByte;
begin
  Result := FALSE;
  BufSize := Min( FS.Size, 65536 * 16 );
  GetMem( Buf, BufSize );
  ChkSum := 0;
  TRY
    while FS.Position < FS.Size do
    begin
      L := Min( BufSize, FS.Size - FS.Position );
      if FS.Read( Buf^, L ) <> L then Exit;
      B := Buf;
      while L > 0 do
      begin
        ChkSum := (ChkSum shl 1) xor B^;
        Inc( B );
        Dec( L );
      end;
    end;
    Result := TRUE;
  FINALLY
    FreeMem( Buf );
  END;
end;

function CalcFileCheckSum( const FilePath: String; var ChkSum: DWORD ): Boolean;
         overload;
var FS: PStream;
begin
  Result := FALSE;
  FS := NewReadFileStream( FilePath );
  TRY
    if FS.Handle = INVALID_HANDLE_VALUE then Exit;
    Result := CalcFileCheckSum( FS, ChkSum );
  FINALLY
    FS.Free;
  END;
end;

{ TStorage }

function TStorage.CheckFile(const SrcFilePath: String; var ChkSum: DWORD): Boolean;
var P: String;
    FN: String;
    DL: PDirList;
    I, J: Integer;
    FI: TFileVersionInfo;
    FS: PStream;
begin
  ChkSum := 0;
  Result := FALSE;
  P := DirPrefix( ExtractFilePath( SrcFilePath ) );
  FN := ExtractFileName( SrcFilePath );
  if P = '' then Exit;
  if not FileExists( FPath + P + '+' + FN ) then Exit;

  if not GetCachedVersionInfo( SrcFilePath, FI ) then
  begin

    Log( '-Checking: ' + SrcFilePath );
    FS := NewReadFileStream( FPath + P + '+' + FN );
    TRY
      FillChar( LastInfo, Sizeof( LastInfo ), 0 );
      EnumSections( FS, LookForLastVersionInfo );
      FI := LastInfo;
      PutCachedVersionInfo( SrcFilePath, FI );
    FINALLY
      FS.Free;
    END;

  end;

  //DL := NewDirList( ExtractFilePath( SrcFilePath ), FN, FILE_ATTRIBUTE_NORMAL );
  DL := NewDirList( '', '', 0 );
  DL.OnItem := fmMainGuard.AcceptDirItem;
  DL.ScanDirectory( ExtractFilePath( SrcFilePath ), FN, FILE_ATTRIBUTE_NORMAL );
  TRY
    J := -1;
    for I := 0 to DL.Count-1 do
    begin
      if not DL.IsDirectory[ I ] then
      if AnsiEq( DL.Names[ I ], FN ) then
      begin
        J := I; break;
      end;
    end;
    if (J < 0) or (DL.Items[ J ].nFileSizeHigh <> 0) then
    begin
      //--- вообще-то это ошибка какая-то или файл уже успели убрать с исходного
      // диска (или например переименовать). Или файл слишком велик.
      // Больше на него не смотреть и не сохранять
      Result := TRUE; Exit;
    end;
    if FI.Sz <> DL.Items[ J ].nFileSizeLow then
      Exit; // длина не совпала
    if CompareFileTime( DL.Items[ J ].ftLastWriteTime, FI.FT ) <> 0 then
      Exit; // время последнего изменения не совпало
    {if not CalcFileCheckSum( SrcFilePath, ChkSum ) then
    begin //--- тоже ошибка, или файл устранился
      Result := TRUE; Exit;
    end;
    if ChkSum <> FI.ChkSum then
      Exit; // контрольная сумма не совпала}
    Result := TRUE; // все совпало - считаем, что файл не изменился!
  FINALLY
    DL.Free;
    Log( '-Checked(' + Int2Str( Integer( Result ) ) + '): ' + SrcFilePath );
  END;
end;

procedure TStorage.ClearCacheVersionInfo;
var I: Integer;
begin
  for I := CacheVersionInfo.Count-1 downto 0 do
    FreeMem( Pointer( CacheVersionInfo.Objects[ I ] ) );
  CacheVersionInfo.Clear;
end;

procedure TStorage.DelCachedVersionInfo(const SrcFilePath: String);
var I: Integer;
    S: String;
begin
  S := AnsiUpperCase( IncludeTrailingPathDelimiter( SrcFilePath ) );
  I := CacheVersionInfo.IndexOf( S );
  if I >= 0 then
  begin
    FreeMem( Pointer( CacheVersionInfo.Objects[ I ] ) );
    CacheVersionInfo.Delete( I );
  end;
end;

destructor TStorage.Destroy;
begin
  FPath := '';
  UnpackingFile := '';
  DirsIndex.Free;
  ClearCacheVersionInfo;
  CacheVersionInfo.Free;
  inherited;
end;

function TStorage.DirPrefix(const DirPath: String): String;
var I, MaxN: Integer;
    //SL: PStrList;
begin
  Result := '';
  MaxN := 1;
  for I := 0 to DirsIndex.Count-1 do
  begin
    MaxN := max( MaxN, DirsIndex.Objects[ I ] ) + 1;
    if AnsiEq( DirsIndex.Items[ I ], DirPath ) then
    begin
      Result := Format( '%.08d', [ DirsIndex.Objects[ I ] ] );
      Exit;
    end;
  end;
  Log( '-Index ' + Format( '%.08d', [ MaxN ] ) + ' allocated for ' + DirPath );
  DirsIndex.AddObject( DirPath, MaxN );
end;

procedure TStorage.EnumSections(FileStream: PStream;
  EnumProc: TEnumSectionsProc);
var P, P1: DWORD;
    FI: TFileVersionInfo;
    SecType: Byte;
    L: DWORD;
    Cont: Boolean;
begin
  P := FileStream.Position;
  TRY
    if FileStream.Position = 0 then
      FileStream.ReadStrZ;
    while FileStream.Position < FileStream.Size do
    begin
      if FileStream.Read( FI, Sizeof( FI ) ) < Sizeof( FI ) then Exit;
      if FileStream.Read( SecType, 1 ) < 1 then Exit;
      if FileStream.Read( L, 4 ) < 4 then Exit;
      if FileStream.Position + L > FileStream.Size then Exit;
      if Assigned( EnumProc ) then
      begin
        Cont := TRUE;
        P1 := FileStream.Position;
        EnumProc( FileStream, FI, SecType, L, Cont );
        FileStream.Position := P1;
        if not Cont then
        begin
          P := FileStream.Position + L;
          Exit;
        end;
      end;
      FileStream.Position := FileStream.Position + L;
      P := FileStream.Position;
    end;
  FINALLY
    FileStream.Position := P;
  END;
end;

function TStorage.GetCachedVersionInfo(const SrcFilePath: String;
  var FI: TFileVersionInfo): Boolean;
var I: Integer;
    S: String;
begin
  S := AnsiUpperCase( IncludeTrailingPathDelimiter( SrcFilePath ) );
  I := CacheVersionInfo.IndexOf( S );
  if I >= 0 then
  begin
    Result := TRUE;
    FI := PFileVersionInfo( Pointer( CacheVersionInfo.Objects[ I ] ) )^;
  end
    else
    Result := FALSE;
end;

procedure TStorage.Init;
var Buf: array[ 0..MAX_COMPUTERNAME_LENGTH ] of Char;
    Sz: DWORD;
begin
  Sz := MAX_COMPUTERNAME_LENGTH;
  GetComputerName( @ Buf[ 0 ], Sz );
  Buf[ Sz ] := #0;
  FMachineName := Buf;
  DirsIndex := NewStrListEx;
  CacheVersionInfo := NewStrListEx;
end;

procedure TStorage.LookForLastFullVersion(FileStream: PStream;
  const FI: TFileVersionInfo; SecType: Byte; SecLen: DWORD; var Cont: Boolean);
begin
  if SecType and 1 = 0 then
    FoundLastFullVersionPos := FileStream.Position;
end;

procedure TStorage.LookForLastVersionInfo(FileStream: PStream;
  const FI: TFileVersionInfo; SecType: Byte; SecLen: DWORD;
  var Cont: Boolean);
begin
  LastInfo := FI;
end;

procedure TStorage.LookRestoreLastVersion(FileStream: PStream;
  const FI: TFileVersionInfo; SecType: Byte; SecLen: DWORD; var Cont: Boolean);
var L: DWORD;
    US: PStream;
    OldVersion, CmdStream: PStream;
begin
  if SecType and 1 = 0 then
  begin // полная версия здесь
    LastVersion.Position := 0;
    if SecType and 2 = 0 then
      Stream2Stream( LastVersion, FileStream, SecLen )
    else
    begin // сжатая полная версия
      FileStream.Read( L, 4 );
      US := DIUCLStreams.NewUclDStream( $80000, FileStream, fmMainGuard.UCLOnProgress );
      TRY
        Stream2Stream( LastVersion, US, L );
      FINALLY
        US.Free;
      END;
    end;
  end
    else
  begin // обновление от предыдущей версии здесь
    OldVersion := NewMemoryStream;
    CmdStream := NewMemoryStream;
    TRY
      if SecType and 2 = 0 then
        Stream2Stream( CmdStream, FileStream, SecLen )
      else
      begin // командный поток сжат
        FileStream.Read( L, 4 );
        US := DIUCLStreams.NewUclDStream( $80000, FileStream, fmMainGuard.UCLOnProgress );
        TRY
          Stream2Stream( CmdStream, FileStream, L );
        FINALLY
          US.Free;
        END;
      end;
      // теперь распаковка новой версии
      if CmdStream.Size > 0 then
      begin
        LastVersion.Position := 0;
        Stream2Stream( OldVersion, LastVersion, LastVersion.Size );
        OldVersion.Position := 0;
        LastVersion.Position := 0;
        CmdStream.Position := 0;
        if not DoApplyUpdates( LastVersion, OldVersion, CmdStream ) then
        begin
          Log( 'Error unpacking ' + UnpackingFile );
          UnpackError := TRUE;
          OldVersion.Position := 0;
          LastVersion.Position := 0;
          Stream2Stream( LastVersion, OldVersion, OldVersion.Size );
          LastVersion.Size := LastVersion.Position;
          LastVersion.Position := 0;
          Cont := FALSE;
        end;
      end
        else
        LastVersion.Position := LastVersion.Size;
    FINALLY
      OldVersion.Free;
      CmdStream.Free;
    END;
  end;
  LastVersion.Size := LastVersion.Position;
  LastVersion.Position := 0;
end;

procedure TStorage.ProgressHandler(Percents, CurrentPosition,
  TotalSize: Integer; var Cancel: Boolean);
begin
  Applet.ProcessMessages;
end;

procedure TStorage.PutCachedVersionInfo(const SrcFilePath: String;
  var FI: TFileVersionInfo);
var I: Integer;
    FIData: PFileVersionInfo;
    S: String;
begin
  S := AnsiUpperCase( IncludeTrailingPathDelimiter( SrcFilePath ) );
  I := CacheVersionInfo.IndexOf( S );
  if I < 0 then
  begin
    GetMem( FIData, Sizeof( FI ) );
    FIData^ := FI;
    CacheVersionInfo.AddObject( S, DWORD( FIData ) );
  end;
end;

function TStorage.SaveFileHistory(const SrcFilePath: String): Boolean;
var FS, DS, NS, TS: PStream;
    FI: TFileVersionInfo;
    LS, CS, US: PStream;
    WriteFullVersion, AddFullVersion: Boolean;
    FN, P: String;
    I: Integer;
    L: DWORD;
begin
  Result := FALSE;
  UnpackingFile := SrcFilePath;
  FN := ExtractFileName( SrcFilePath );

  TS := NewReadFileStream( SrcFilePath );
  TRY
    if TS.Handle = INVALID_HANDLE_VALUE then Exit;
    GetFileTime( TS.Handle, nil, nil, @FI.FT );
    FS := NewMemoryStream;
    Stream2Stream( FS, TS, TS.Size );
  FINALLY
    TS.Free;
  END;
  FS.Position := 0;

  DS := nil;
  LS := NewMemoryStream;
  CS := NewMemoryStream;
  TS := NewMemoryStream;
  TRY
    FI.Sz := FS.Size;
    CalcFileCheckSum( FS, FI.ChkSum );
    P := DirPrefix( ExtractFilePath( SrcFilePath ) );
    DS := NewReadWriteFileStream( FPath + P + '+' + FN );
    if DS.Handle = INVALID_HANDLE_VALUE then Exit;
    FoundLastFullVersionPos := 0;
    EnumSections( DS, LookForLastFullVersion );
    WriteFullVersion := TRUE;
    AddFullVersion := FALSE;
    if FoundLastFullVersionPos > 0 then
    begin
      DS.Position := FoundLastFullVersionPos - 5 - Sizeof( FI );
      LastVersion := LS;
      UnpackError := FALSE;
      EnumSections( DS, LookRestoreLastVersion );
      if UnpackError then
        WriteFullVersion := TRUE
      else
      if DS.Position - FoundLastFullVersionPos < FS.Size * 3 then
      begin
        MakeUpdates( CS, FS, LS, ProgressHandler );
        WriteFullVersion := CS.Size + 1 >= FS.Size;
        if not WriteFullVersion then
        begin
          NS := NewMemoryStream;
          TRY
            CS.Position := 0;
            if not DoApplyUpdates( NS, LS, CS ) then AddFullVersion := TRUE
            else if NS.Size <> FS.Size then AddFullVersion := TRUE
            else
            begin
              FS.Position := 0;
              Stream2Stream( TS, FS, FS.Size );
              if not CompareMem( TS.Memory, NS.Memory, NS.Size ) then
                AddFullVersion := TRUE;
            end;
          FINALLY
            NS.Free;
            TS.Size := 0;
          END;
        end;
      end;
      if not UnpackError and (DS.Position = DS.Size) and (CS.Size = 0) then
      begin
        //Result := TRUE; // не надо ничего записывать - файл не изменился
        Storage.UpdCachedVersionInfo( SrcFilePath, FI.FT );
        Exit;
      end;
    end;
    //--------------------------------------------------------------------------
    // Подготавливаем запись новой версии
    if DS.Position = 0 then
      DS.WriteStrZ( ExtractFilePath( SrcFilePath ) );
    if WriteFullVersion then
    begin
      CS.Position := 0;
      FS.Position := 0;
      Stream2Stream( CS, FS, FS.Size );
    end;
    I := 0;
    if CS.Size > 0 then
    begin
      I := 2;
      US := DIUCLStreams.NewUclCStream( 10, $80000, TS, fmMainGuard.UCLOnProgress );
      TRY
        CS.Position := 0;
        Stream2Stream( US, CS, CS.Size );
      FINALLY
        US.Free;
      END;
    end;
    if (TS.Size >= CS.Size - 4) or (TS.Size = 0) then
    begin // не использовать сжатие
      I := 0;
    end;
    if not WriteFullVersion then Inc( I );
    DS.Write( FI, Sizeof( FI ) );
    DS.Write( I, 1 );
    if I and 2 = 0 then // запись без сжатия
    begin
      L := CS.Size;
      DS.Write( L, 4 );
      CS.Position := 0;
      Stream2Stream( DS, CS, L );
    end
      else
    begin // запись со сжатием
      L := 4 + TS.Size;
      DS.Write( L, 4 );
      L := CS.Size;
      DS.Write( L, 4 );
      TS.Position := 0;
      Stream2Stream( DS, TS, TS.Size );
    end;
    if AddFullVersion and not WriteFullVersion then
    begin
      Log( 'Error checking, full version added: ' + SrcFilePath );
      DS.Write( FI, Sizeof( FI ) );
      I := 2;
      TS.Size := 0;
      US := DIUCLStreams.NewUclCStream( 10, $80000, TS, fmMainGuard.UCLOnProgress );
      TRY
        FS.Position := 0;
        Stream2Stream( US, FS, FS.Size );
      FINALLY
        US.Free;
      END;
      if (TS.Size >= FS.Size) or (TS.Size = 0) then
        I := 0;
      DS.Write( I, 1 );
      if I and 2 = 0 then
      begin
        L := FS.Size;
        DS.Write( L, 4 );
        CS.Position := 0;
        Stream2Stream( DS, FS, L );
      end
        else
      begin
        L := 4 + TS.Size;
        DS.Write( L, 4 );
        L := FS.Size;
        DS.Write( L, 4 );
        TS.Position := 0;
        Stream2Stream( DS, TS, TS.Size );
      end;
    end;
    DelCachedVersionInfo( SrcFilePath );
    Result := TRUE;
  FINALLY
    FS.Free;
    DS.Free;
    LS.Free;
    CS.Free;
    TS.Free;
  END;
end;

procedure TStorage.SetPath(const Value: String);
var F: HFile;
    Buf: array[ 0..1023 ] of Char;
    DL: PDirList;
    I, Prefix: Integer;
    SL: PStrList;
    S: String;
    FS: PStream;
begin
  Log( '-Storage path: ' + Value );
  FPath := IncludeTrailingPathDelimiter( Value );
  FOK := FALSE;
  if not DirectoryExists( FPath ) then Exit;

  if not DirectoryExists( FPath + FMachineName + '\' ) then
  begin
    MkDir( FPath + FMachineName + '\' );
    if not DirectoryExists( FPath + FMachineName + '\' ) then Exit;
  end;
  FPath := FPath + FMachineName + '\';

  F := FileCreate( FPath + 'FileGuard.dir', ofOpenWrite or ofOpenAlways );
  if F = INVALID_HANDLE_VALUE then Exit;
  TRY
    if FileWrite( F, Buf, 1024 ) <> 1024 then Exit;
  FINALLY
    FileClose( F );
  END;
  //--- построение индекса сохраненных директорий
  DirsIndex.Clear;
  //DL := NewDirList( FPath, '*.*', FILE_ATTRIBUTE_NORMAL );
  DL := NewDirList( '', '', 0 );
  DL.OnItem := fmMainGuard.AcceptDirItem;
  DL.ScanDirectory( FPath, '*.*', FILE_ATTRIBUTE_NORMAL );
  SL := NewStrList;
  TRY
    for I := 0 to DL.Count-1 do
      if not DL.IsDirectory[ I ] then
      begin
        Prefix := Str2Int( DL.Names[ I ] );
        if Prefix <> 0 then
        begin
          if DirsIndex.IndexOfObj( Pointer( Prefix ) ) < 0 then
          begin
            FS := NewReadFileStream( DL.Path + DL.Names[ I ] );
            TRY
              S := FS.ReadStrZ;
              DirsIndex.AddObject( S, Prefix );
            FINALLY
              FS.Free;
            END;
          end;
        end;
      end;
  FINALLY
    DL.Free;
    SL.Free;
  END;
  FOK := TRUE;
  Log( '-Storage index built OK' );
end;

procedure TStorage.UpdateFile(const SrcFilePath: String; ChkSum: DWORD;
  Action: Integer);
var P: String;
    FN: String;
    Renamed_Delete: Boolean;
    Saved_History: Boolean;
begin
  Log( '-Updating: ' + SrcFilePath );
  P := DirPrefix( ExtractFilePath( SrcFilePath ) );
  FN := ExtractFileName( SrcFilePath );
  if ChkSum = 0 then
    CalcFileCheckSum( SrcFilePath, ChkSum );
  if Action = 0 then
       // сохранение всей истории
       Saved_History := SaveFileHistory( SrcFilePath )
  else
  begin
    Renamed_Delete := FALSE;
    if FileExists( FPath + P + '+' + FN ) then
    begin
      if FileExists( FPath + P + '+' + FN + '.old' ) then
      begin
        if not DeleteFile( PChar( FPath + P + '+' + FN + '.old' ) ) then
          Log( '*** Can not delete: ' + FPath + P + '+' + FN + '.old' );
      end;
      Renamed_Delete :=
      MoveFile( PChar( FPath + P + '+' + FN ), PChar( FPath + P + '+' + FN + '.old' ) );
      if not Renamed_Delete then
        Log( '*** Can not rename ' + FPath + P + '+' + FN + ' to ' +
          FPath + P + '+' + FN + '.old' );
    end;
    Saved_History := SaveFileHistory( SrcFilePath );
    if Saved_History then
    begin
      if Renamed_Delete then
      begin
        if not DeleteFile( PChar( FPath + P + '+' + FN + '.old' ) ) then
           Log( '*** Can not delete: ' + FPath + P + '+' + FN + '.old' );
      end;
    end
      else
    begin
      if Renamed_Delete then
      begin
        if not MoveFile( PChar( FPath + P + '+' + FN + '.old' ),
                  PChar( FPath + P + '+' + FN ) ) then
          Log( '*** Can not rename ' + FPath + P + '+' + FN + '.old' +
            ' to ' + FPath + P + '+' + FN );
      end;
    end;
  end;
  if Saved_History then
  begin
    Log( 'Saved: ' + SrcFilePath );
    fmMainGuard.StorageTreeChanged := TRUE;
  end;
end;

procedure TStorage.UpdCachedVersionInfo(const SrcFilePath: String;
  const ft: TFileTime);
var I: Integer;
    S: String;
    FIData: PFileVersionInfo;
begin
  S := AnsiUpperCase( IncludeTrailingPathDelimiter( SrcFilePath ) );
  I := CacheVersionInfo.IndexOf( S );
  if I >= 0 then
  begin
    FIData := Pointer( CacheVersionInfo.Objects[ I ] );
    FIData.FT := ft;
  end;
end;

end.
