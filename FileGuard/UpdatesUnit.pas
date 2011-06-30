{
  MakeUpdates
  ApplyUpdates
  (C) by Vladimir Kladov, 2002-2004

  These functions allows to create (MakeUpdates) a command stream
  on base of two data streams: Stream1 and Stream2,
  which later can be used to restore (ApplyUpdates) Stream2 on base of
  the same source Stream1 and created by MakeUpdates command stream.

  This technique used in my UpdateMaker and Updater applications
  to provide patches to a set of (big) files which otherwise could
  require a lot of files to download to get new version. This is great
  for developers providing sources rather then compiled stuff.

  History:

  5-sep-2004
  first release of this unit: functions MakeUpdates and ApplyUpdates
  extracted from UpdateMaker / Updater sources, with some sumplifications
  in order to make possible to use streams rather then files, and to use
  these two functions separately from UpdateMaker and Updater utilities.

  7-Sep-2004
  version 2 of this unit, algorithm improved in comparison to current
  version of UpdateMaker program and errors fixed (though new verion of
  MakeUpdates creates command file still compatible with old version
  of ApplyUpdates been corrected). Now plan to re-use these functions in
  newer versions of Updater / UpdateMaker.

  8-Sep-2004
  version 3 of this unit. Some errors fixed. Parameter added: OnProgress.

}
unit UpdatesUnit;

interface

uses Windows, KOL;

//{$DEFINE WRITE_LEN_CC}

type
  TOnUpdatesProgress = procedure( Percents, TotalSize, CurrentPosition: Integer;
                                  var Cancel: Boolean ) of object;

function ApplyUpdates( OutStrm, SourceStream, CmdStrm: PStream;
         OnProgress: TOnUpdatesProgress ): Boolean;
function MakeUpdates( DestCommandStream, LastVersion, PrevVersion: PStream;
         OnProgress: TOnUpdatesProgress ): Boolean;

implementation

type
  TCommand = (cmdFWDandCOPY, cmdBCKandCOPY, cmdINSERT, cmdNone);
  TDwordArray = array[ 0..1000000 ] of DWORD;
  PDwordArray = ^TDwordArray;

function Compare4Bytes( A: PDwordArray; e1, e2: DWORD ): Integer;
{$IFDEF PAS_CODE}
var X, Y: DWORD;
begin
  X := A[ e1 ];
  Y := A[ e2 ];
  asm
    MOV EAX, [X]
    MOV EDX, [Y]
    MOV EAX, [EAX]
    MOV EDX, [EDX]
    BSWAP EAX
    BSWAP EDX
    SUB EAX, EDX
    MOV Result, EAX
  end;
end;
{$ELSE}
  asm
    MOV ECX, [EAX+ECX*4]
    MOV EAX, [EAX+EDX*4]
    MOV ECX, [ECX]
    MOV EAX, [EAX]
    BSWAP ECX
    BSWAP EAX
    SUB   EAX, ECX
  end;
{$ENDIF}

procedure SwapIndxes( A: PDwordArray; e1, e2: DWORD );
{$IFDEF PAS_CODE}
var X, Y: Integer;
begin
  X := A[ e1 ];
  Y := A[ e2 ];
  A[ e1 ] := Y;
  A[ e2 ] := X;
end;
{$ELSE}
  asm
    PUSH EBX
    MOV EBX, [EAX+ECX*4]
    XCHG EBX, [EAX+EDX*4]
    MOV [EAX+ECX*4], EBX
    POP EBX
  end;
{$ENDIF}


function MakePattern2(Data: PStream; Old, New: PChar; OldLen, NewLen: Integer;
  MaxSize: Integer; var Equal: Boolean; OnProgress: TOnUpdatesProgress): Boolean;
var HashTable1: PChar;
    SortTable1, AccTable1: PDwordArray;

  function BytesEqual( OldPos, NewPos: Integer ): Integer;
  var I: Integer;
  begin
    Result := Min( OldLen - OldPos, NewLen - NewPos );
    for I := 1 to Result do
    begin
      if Old[ OldPos ] <> New[ NewPos ] then
      begin
        Result := I - 1;
        Exit;
      end;
      Inc( OldPos );
      Inc( NewPos );
    end;
  end;

  // запись одного байта в выходной поток
  procedure WriteByte( B: Byte );
  begin
    Data.Write( B, 1 );
  end;

  // возвратит Flag, если выполнено условие Cond, иначе 0.
  function MakeFlag( Flag: Byte; Cond: Boolean ): Byte;
  begin
    if Cond then Result := Flag
            else Result := 0;
  end;

  // запись числа в формате с переменной длиной. Старший бит байта определяет
  // для читателя числа, читать ли следующий байт. 7 разрядов хранят очередные
  // 7 бит числа. Для хранения числа от 0 до 127 достаточно 1 байта, от 128 до
  // 16383 (14 бит единиц) - двух байт, и т.д.
  procedure WriteNum( N: DWORD );
  begin
    REPEAT
      WriteByte( N and $7F or MakeFlag( $80, N > 127 ) );
      N := N shr 7;
    UNTIL N = 0;
  end;

  // Предварительный подсчет числа в байтах
  function CalcNumLen( N: DWORD ): Integer;
  begin
    Result := 1;
    while N <> 0 do
    begin
      N := N shr 7;
      Inc( Result );
    end;
  end;

var PrevCmd: TCommand;

  // формирует команду с параметром "длина" переменной разрядности. См. описание
  // выше. Формат команды зависит от PrevCmd.
  procedure WriteCommand( Cmd: TCommand; Len: Integer );
  begin
    Dec( Len );
    CASE PrevCmd OF
    cmdNONE:
      CASE Cmd OF
      cmdFWDandCOPY:
        begin
          WriteByte( Len and $3F or $00 or MakeFlag( $40, Len > 63 ) );
          if Len > 63 then WriteNum( Len shr 6 );
        end;
      cmdINSERT:
        begin
          WriteByte( Len and $3F or $80 or MakeFlag( $40, Len > 63 ) );
          if Len > 63 then WriteNum( Len shr 6 );
        end;
      else
        begin
          ShowMessage( 'Error! BCKandCOPY at the beginning' );
          Halt;
        end;
      END;
    cmdINSERT:
      begin
        CASE Cmd OF
        cmdFWDandCOPY:
          begin
            WriteByte( Len and $3F or $00 or MakeFlag( $40, Len > 63 ) );
            if Len > 63 then WriteNum( Len shr 6 );
          end;
        cmdBCKandCOPY:
          begin
            WriteByte( Len and $3F or $80 or MakeFlag( $40, Len > 63 ) );
            if Len > 63 then WriteNum( Len shr 6 );
          end;
        else
          begin
            ShowMessage( 'Error! INSERT after INSERT' );
            Halt;
          end;
        END;
      end;
    cmdBCKandCOPY, cmdFWDandCOPY:
      begin
        CASE Cmd OF
        cmdINSERT:
          begin
            WriteByte( Len and $3F or $80 or MakeFlag( $40, Len > 63 ) );
            if Len > 63 then WriteNum( Len shr 6 );
          end;
        cmdFWDandCOPY:
          begin
            WriteByte( Len and $1F or $00 or MakeFlag( $20, Len > 31 ) );
            if Len > 31 then WriteNum( Len shr 5 );
          end;
        cmdBCKandCOPY:
          begin
            WriteByte( Len and $1F or $40 or MakeFlag( $20, Len > 31 ) );
            if Len > 31 then WriteNum( Len shr 5 );
          end;
        END;
      end;
    END;
    PrevCmd := Cmd;
  end;

var OldPos, NewPos: Integer;

  // Вычисляет предположительный размер команды BCKandCOPY или FWDandCOPY.
  function CalcCmdLen( OldIdx: Integer; LCopy: Integer ): Integer;
  var //Cmd: TCommand;
      Off: Integer;
  begin
    if OldIdx < OldPos then
    begin
      //Cmd := cmdBCKandCOPY;
      Off := OldPos-OldIdx-1-LCopy;
    end
      else
    begin
      //Cmd := cmdFWDandCOPY;
      Off := OldIdx - OldPos;
    end;
    Dec( LCopy );
    Result := 1 + CalcNumLen( Off );
    CASE PrevCmd OF
    cmdNONE, cmdINSERT:
       if LCopy > 63 then Inc( Result, CalcNumLen( LCopy shr 6 ) );
    cmdBCKandCOPY, cmdFWDandCOPY:
      if LCopy > 31 then Inc( Result, CalcNumLen( LCopy shr 5 ) );
    END;
  end;

  // Вычисляет предположительный размер команды BCKandCOPY или FWDandCOPY.
  function CalcCmdLen2( NewIdx: Integer; LCopy: Integer ): Integer;
  var //Cmd: TCommand;
      Off: Integer;
  begin
    if NewIdx < NewPos then
    begin
      //Cmd := cmdBCKandCOPY;
      Off := NewPos-NewIdx-1-LCopy;
    end
      else
    begin
      //Cmd := cmdFWDandCOPY;
      Off := NewIdx - NewPos;
    end;
    Dec( LCopy );
    Result := 1 + CalcNumLen( Off );
    CASE PrevCmd OF
    cmdNONE, cmdINSERT:
       if LCopy > 63 then Inc( Result, CalcNumLen( LCopy shr 6 ) );
    cmdBCKandCOPY, cmdFWDandCOPY:
      if LCopy > 31 then Inc( Result, CalcNumLen( LCopy shr 5 ) );
    END;
  end;

  // изображение прогресса просмотра новой версии файла.
  function ShowProgress_Cancel: Boolean;
  var Pr: Integer;
  begin
    Pr := NewPos * 100 div NewLen;
    Result := FALSE;
    if Assigned( OnProgress ) then
      OnProgress( Pr, NewPos, NewLen, Result );
  end;

  // поиск в старом файле последовательности байтов, по возможности большей длины,
  // совпадающей с байтами в новой версии файла в позиции NewIdx.
  // Если удается найти такую, возвращается позиция в старой версии файла
  // и LenFound = длина найденной посл-сти.
  function SearchSimilar( NewIdx: Integer; var LenFound: Integer ): Integer;
    function LexicographicCompare( X, Y: DWORD ): Integer;
    asm
      BSWAP EAX
      BSWAP EDX
      SUB   EAX, EDX
    end;
  var I, L: Integer;
      Hash: DWORD;
      Ptr: PDWORD;
      Pos, CmdLenFound, CmdLen: Integer;
  begin
    Result := -1;
    LenFound := 0;
    CmdLenFound := 0;
    Hash := PDWORD( @ New[ NewIdx ] )^ and $FFFFFF;
    I := AccTable1[ Hash and $FFFF ]; // индекс первого элемента в SortTable1,
                           // указывающего на последовательность в Old[],
                           // начинающуюся с байтов New[ NewIdx ], New[ NewIdx + 1 ]
    if I = 0 then
      Exit; // нет таких последовательностей из 2х байт в Old[]
    for I := I to OldLen-4 do
    begin
      Ptr := Pointer( SortTable1[ I ] );
      if (Ptr^ and $FFFFFF) <> Hash then
      begin
        if LexicographicCompare( Ptr^ and $FFFFFF, Hash ) > 0 then
        begin
          Exit; // всё, все такие последовательности из по крайней мере трех байт кончились
        end;
      end
        else
      begin
        Pos := Integer( Ptr ) - Integer( @ Old[ 0 ] );
        L := BytesEqual( Pos, NewIdx );
        if L < 3 then Exit;
        //Assert( L >= 3, 'что-то не то' );
        if L >= 3 then
        begin
          // предотвратим появление отрицательного смещения:
          if (Pos < OldPos) and (Pos + L >= OldPos - 1) then
            L := OldPos - 1 - Pos;
          if L >= 2 then
          begin
            CmdLen := CalcCmdLen( Pos, L );
            if L + CmdLen > LenFound + CmdLenFound then
            begin
              CmdLenFound := CmdLen;
              LenFound := L;
              Result := Pos;
            end;
          end;
        end;
      end;
    end;
  end;


var I, J, L: Integer;
    Found: Boolean;
    {$IFDEF WRITE_LEN_CC}
    CC: DWORD;
    {$ENDIF}
begin
  Result := FALSE;
  Equal := FALSE;

  if (OldLen = NewLen) and (OldLen <> 0) and (CompareMem( Old, New, OldLen )) then
  begin
    Equal := TRUE;
    Exit;
  end;

  HashTable1 := AllocMem( 1 shl 21 );

  GetMem( SortTable1, (OldLen-3) * Sizeof( DWORD ) );
  AccTable1 := AllocMem( 65536 * Sizeof( DWORD ) );
  TRY
    if (HashTable1 = nil) or
       (SortTable1 = nil) or (AccTable1 = nil) then
    begin
      //ShowMessage( 'No memory to process (' + OldFile + '->' + NewFile + ').' );
      Exit;
    end;
    // Инициализируем хэш-таблицы:
    for I := 0 to OldLen-3 do
    begin
      J := PDWORD( @ Old[ I ] )^ and $FFFFFF;
      Byte( HashTable1[ J shr 3 ] ) := Byte( HashTable1[ J shr 3 ] ) or (1 shl (J and 7));
    end;
    // Строим таблицу быстрого поиска последовательностей:
    for I := 0 to OldLen-4 do
      SortTable1[ I ] := DWORD( @ Old[ I ] );
    SortData( SortTable1, OldLen-3, @ Compare4Bytes, @ SwapIndxes );
    for I := 0 to OldLen-4 do
    begin
      J := SortTable1[ I ];
      J := PDWORD( J )^ and $FFFF;
      if (AccTable1[ J ] = 0) or (AccTable1[ J ] > DWORD( I )) then
        AccTable1[ J ] := I; // AccTable1[ I ] = индексу первого вхождения последовательности
                            // начинающейся с 2х байтов (J and $FF), (J shr 8)and $FF
    end;
    // Строим файл различий:
    OldPos := 0;
    NewPos := 0;

    {$IFDEF WRITE_LEN_CC}
    WriteNum( OldLen );
    // Посчитаем контрольную сумму:
    I := 0;
    CC := 0;
    while I < OldLen do
    begin
      CC := ((CC shl 1) or (CC shr 31)) xor PDWORD(@Old[ I ])^;
      Inc( I, 4 );
    end;
    Data.Write( CC, 4 );
    {$ENDIF}

    PrevCmd := cmdNone;
    while (NewPos < NewLen) do
    begin
      if ShowProgress_Cancel then Exit;
      L := BytesEqual( OldPos, NewPos );
      if L >= 2 then
      begin
        // совпадает участок достаточно хорошей длины, копируем его:
        WriteCommand( cmdFWDandCOPY, L );
        WriteByte( 0 ); // смещение = 0
        Inc( OldPos, L );
        Inc( NewPos, L );
      end
        else
      begin
        // иначе ищем следующий участок, который можно скопировать:
        Found := FALSE;
        for I := NewPos to NewLen-6 do
        begin
          //if (I and $1F) = 0 then
          begin
            if ShowProgress_Cancel then Exit;
          end;
          J := PDWORD( @ New[ I ] )^ and $FFFFFF;
          if ( Byte( HashTable1[ J shr 3 ] ) and (1 shl (J and 7))) = 0 then continue;
          J := SearchSimilar( I, L );
          if L > 0 then
          begin
            Found := TRUE;
            if I > NewPos then
            begin
              WriteCommand( cmdINSERT, I-NewPos );
              Data.Write( New[ NewPos ], I-NewPos );
            end;
            if J < OldPos then begin
              WriteCommand( cmdBCKandCOPY, L );
              WriteNum( OldPos-J-1-L );
            end else begin
              WriteCommand( cmdFWDandCOPY, L );
              WriteNum( J-OldPos );
            end;
            NewPos := I + L;
            OldPos := J + L;
            break;
          end;
        end;
        if not Found then
        begin
          for I := NewPos to NewLen-6 do
          begin
            //if (I and $1F) = 0 then
            begin
              if ShowProgress_Cancel then Exit;
            end;
            J := PDWORD( @ New[ I ] )^ and $FFFFFF;
            if ( Byte( HashTable1[ J shr 3 ] ) and (1 shl (J and 7))) = 0 then continue;
            J := SearchSimilar( I, L );
            if L > 0 then
            begin
              Found := TRUE;
              WriteCommand( cmdINSERT, I-NewPos );
              Data.Write( New[ NewPos ], I-NewPos );
              if J < OldPos then begin
                WriteCommand( cmdBCKandCOPY, L );
                WriteNum( OldPos-J-1-L );
              end else begin
                WriteCommand( cmdFWDandCOPY, L );
                WriteNum( J-OldPos );
              end;
              NewPos := I + L;
              OldPos := J + L;
              break;
            end;
          end;

          if not Found then
          begin
            // Вообще нет больше совпадений, остаток копируем вставкой.
            WriteCommand( cmdINSERT, NewLen-NewPos );
            Data.Write( New[ NewPos ], NewLen-NewPos );
            NewPos := NewLen;
          end;
        end;
      end;
    end;
    Result := TRUE;
  FINALLY
    FreeMem( HashTable1 );
    //FreeMem( HashTable2 );
    FreeMem( SortTable1 );
    FreeMem( AccTable1 );
    //FreeMem( SortTable2 );
    //FreeMem( AccTable2 );
  END;
end;


function ApplyUpdates( OutStrm, SourceStream, CmdStrm: PStream;
                       OnProgress: TOnUpdatesProgress ): Boolean;
var DataLen: DWORD;
    L: Integer;
    Pos0: DWORD;
    SrcPos: Integer;
    Src: PChar;

    function ShowProgress_Cancel: Boolean;
    var Pr: Integer;
    begin
      Pr := CmdStrm.Position * 100 div CmdStrm.Size;
      Result := FALSE;
      if Assigned( OnProgress ) then
        OnProgress( Pr, CmdStrm.Position, CmdStrm.Size, Result );
    end;

    function ReadNum( Shft: Integer = 0 ): Integer;
    var B: Byte;
    begin
      Result := 0;
      while CmdStrm.Position < CmdStrm.Size do
      begin
        CmdStrm.Read( B, 1 );
        Result := Result or ((B and $7F) shl Shft);
        Shft := Shft + 7;
        if (B and $80) = 0 then break;
      end;
    end;

var I: Integer;
    B: Byte;
    Cmd: TCommand;
    PrevCmd: TCommand;
begin
  Result := FALSE;
  // начинаем построение выходного файла
  SrcPos := 0;
  GetMem( Src, SourceStream.Size );
  TRY
    SourceStream.Position := 0;
    DataLen := CmdStrm.Size;
    SourceStream.Read( Src^, SourceStream.Size );
    PrevCmd := cmdNONE;
    Pos0 := CmdStrm.Position;
    while CmdStrm.Position < DWORD( Pos0 + DataLen ) do
    begin
      if ShowProgress_Cancel then Exit;
      // читаем команду:
      CmdStrm.Read( B, 1 );
      CASE PrevCmd OF
      cmdNONE:
        begin
          if (B and $80) = 0 then
            Cmd := cmdFWDandCOPY
          else
            Cmd := cmdINSERT;
          L := B and $3F;
          if (B and $40) <> 0 then
            L := L or ReadNum( 6 );
        end;
      cmdINSERT:
        begin
          if (B and $80) = 0 then
            Cmd := cmdFWDandCOPY
          else
            Cmd := cmdBCKandCOPY;
          L := B and $3F;
          if (B and $40) <> 0 then
            L := L or ReadNum( 6 );
        end;
      //cmdFWDandCOPY, cmdBCKandCOPY:
      else
        begin
          if (B and $80) = 0 then
          begin
            if (B and $40) = 0 then
              Cmd := cmdFWDandCOPY
            else
              Cmd := cmdBCKandCOPY;
            L := B and $1F;
            if (B and $20) <> 0 then
              L := L or ReadNum( 5 );
          end
            else
          begin
            Cmd := cmdINSERT;
            L := B and $3F;
            if (B and $40) <> 0 then
              L := L or ReadNum( 6 );
          end;
        end;
      END;
      {$IFDEF DEBUG}
      CASE PrevCmd OF
      cmdNONE: Exit;//Assert( Cmd in [cmdFWDandCOPY, cmdINSERT], '!' );
      cmdINSERT: Exit; //Assert( Cmd in [cmdFWDandCOPY, cmdBCKandCOPY], '!' );
      else ;
      END;
      {$ENDIF}
      PrevCmd := Cmd;
      Inc( L );
      {$IFDEF DEBUG}
      CASE Cmd OF
      cmdBCKandCOPY: Protocol.Add( 'BCKandCOPY ' + Int2Str( L ) );
      cmdFWDandCOPY: Protocol.Add( 'FWDandCOPY ' + Int2Str( L ) );
      cmdINSERT:     Protocol.Add( 'INSERT     ' + Int2Str( L ) );
      END;
      {$ENDIF}
      // выполняем команду:
      CASE Cmd OF
      cmdBCKandCOPY, // сместиться на N + L + 1 байт назад
      cmdFWDandCOPY: // или вперед и скопировать L байт из исходного файла:
        begin
          I := ReadNum( 0 );
          {$IFDEF DEBUG}
          Protocol.Add( 'OFFSET ' + Int2Str( I ) );
          {$ENDIF}
          if Cmd = cmdBCKandCOPY then SrcPos := SrcPos - 1 - I - L
                                 else SrcPos := SrcPos + I;
          {$IFDEF DEBUG}
          Protocol.Add( 'SRCPOS ' + Int2Str( SrcPos ) );
          if (SrcPos < 0) or (SrcPos >= InLen) then
          begin
            //MsgBox( 'out of bounds', MB_OK );
            Result := FALSE;
            Exit;
          end;
          {$ENDIF}
          OutStrm.Write( Src[ SrcPos ], L );
          {$IFDEF DEBUG}
          I := Min( 512, L );
          SetLength( S, I );
          Move( Src[ SrcPos + L - I ], S[ 1 ], I );
          Protocol.Add( 'LAST WRITTEN ARE: <' + S + '>' );
          {$ENDIF}
          Inc( SrcPos, L );
        end;
      cmdINSERT: // вставить L байтов прямо из командного файла:
        begin
          Stream2Stream( OutStrm, CmdStrm, L );
          {$IFDEF DEBUG}
          CmdStrm.Position := CmdStrm.Position - DWORD( L );
          SetLength( S, L );
          CmdStrm.Read( S[ 1 ], L );
          Protocol.Add( 'DATA: ' + Copy( S, 1, 100 ) );
          {$ENDIF}
        end;
      END;
    end;
  FINALLY
    FreeMem( Src );
  END;
  Result := TRUE;
end;

function MakeUpdates( DestCommandStream, LastVersion, PrevVersion: PStream;
                      OnProgress: TOnUpdatesProgress ): Boolean;
var Old, New: PChar;
    Eq: Boolean;
begin
  Result := FALSE;
  GetMem( Old, PrevVersion.Size );
  GetMem( New, LastVersion.Size );
  TRY
    if LastVersion.Size > 0 then
    begin
      LastVersion.Position := 0;
      LastVersion.Read( New^, LastVersion.Size );
    end;
    if PrevVersion.Size > 0 then
    begin
      PrevVersion.Position := 0;
      PrevVersion.Read( Old^, PrevVersion.Size );
    end;
    if not MakePattern2( DestCommandStream, Old, New, PrevVersion.Size,
         LastVersion.Size, max( PrevVersion.Size, LastVersion.Size ), Eq,
         OnProgress ) then Exit;
    if Eq then Exit;
    Result := TRUE;
  FINALLY
    if Old <> nil then FreeMem( Old );
    if New <> nil then FreeMem( New );
  END;
end;

end.
