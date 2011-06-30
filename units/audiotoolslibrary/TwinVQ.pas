{ *************************************************************************** }
{                                                                             }
{ Audio Tools Library (Freeware)                                              }
{ Class TTwinVQ - for extracting information from TwinVQ file header          }
{                                                                             }
{ Copyright (c) 2001,2002 by Jurgen Faul                                      }
{ E-mail: jfaul@gmx.de                                                        }
{ http://jfaul.de/atl                                                         }
{                                                                             }
{ Version 1.1 (13 August 2002)                                                }
{   - Added property Album                                                    }
{   - Support for Twin VQ 2.0                                                 }
{                                                                             }
{ Version 1.0 (6 August 2001)                                                 }
{   - File info: channel mode, bit rate, sample rate, file size, duration     }
{   - Tag info: title, comment, author, copyright, compressed file name       }
{                                                                             }
{ Портировано в KOL - Матвеев Дмитрий                                         }
{                                                                             }
{ *************************************************************************** }

// - История -

// Дата: 19.11.2003 Версия: 1.01
// [+] - добавил возможность записи тегов.

// Версия: 1.00
   {Стартовая версия}

unit TwinVQ;

interface

uses Windows, KOL;

const
  { Used with ChannelModeID property }
  TWIN_CM_MONO = 1;                                     { Index for mono mode }
  TWIN_CM_STEREO = 2;                                 { Index for stereo mode }

  { Channel mode names }
  TWIN_MODE: array [0..2] of string = ('Unknown', 'Mono', 'Stereo');

  { Twin VQ header ID }
  TWIN_ID = 'TWIN';

  { Max. number of supported tag-chunks }
type
  TChunkType = (ctNAME, ctCOMT, ctAUTH, ctC , ctFILE, ctALBM);

const
  { Names of supported tag-chunks }
  TWIN_CHUNK: array [TChunkType] of string =
    ('NAME', 'COMT', 'AUTH', '(c) ', 'FILE', 'ALBM');

type
  { TwinVQ chunk header }
  ChunkHeader = record
    ID: array [1..4] of Char;                                      { Chunk ID }
    Size: Cardinal;                                              { Chunk size }
  end;

  { File header data - for internal use }
  HeaderInfo = packed record
    { Real structure of TwinVQ file header }
    ID: array [1..4] of Char;                                 { Always "TWIN" }
    Version: array [1..8] of Char;                               { Version ID }
    Size: Cardinal;                                             { Header size }
    Common: ChunkHeader;                                { Common chunk header }
    ChannelMode: Cardinal;               { Channel mode: 0 - mono, 1 - stereo }
    BitRate: Cardinal;                                       { Total bit rate }
    SampleRate: Cardinal;                                 { Sample rate (khz) }
    SecurityLevel: Cardinal;                                       { Always 0 }
    { Extended data }
    FileSize: Cardinal;                                   { File size (bytes) }
    Tag: array [TChunkType] of string;             { Tag information }
  end;

  { Class TTwinVQ }
  PTwinVQ = ^TTwinVQ;
  TTwinVQ = object(TObj)
    private
      { Private declarations }
      FValid: Boolean;
      FChannelModeID: Byte;
      FBitRate: Byte;
      FSampleRate: Word;
      FFileSize: Cardinal;
      FDuration: Double;
      FTitle: string;
      FComment: string;
      FAuthor: string;
      FCopyright: string;
      FOriginalFile: string;
      FAlbum: string;
      FExists: Boolean;
      procedure FResetData;
      function FGetChannelMode: string;
      function FIsCorrupted: Boolean;
      procedure InitFields;
      procedure SetTagItem(const ID, Data: string; var Header: HeaderInfo);
      procedure ReadTag(const FileName: string; var Header: HeaderInfo);
    public
      { Public declarations }
      function ReadFromFile(const FileName: string): Boolean;   { Load header }
      function SaveToFile(const FileName: string; Destination: string = ''): Boolean;   { Load header }
      property Valid: Boolean read FValid;             { True if header valid }
      property ChannelModeID: Byte read FChannelModeID;   { Channel mode code }
      property ChannelMode: string read FGetChannelMode;  { Channel mode name }
      property BitRate: Byte read FBitRate;                  { Total bit rate }
      property SampleRate: Word read FSampleRate;          { Sample rate (hz) }
      property FileSize: Cardinal read FFileSize;         { File size (bytes) }
      property Duration: Double read FDuration;          { Duration (seconds) }
      property Exists: Boolean read FExists write FExists; { True if file corrupted }
      property Title: string read FTitle write FTitle;                        { Title name }
      property Comment: string read FComment write FComment;                       { Comment }
      property Author: string read FAuthor write FAuthor;                     { Author name }
      property Copyright: string read FCopyright write FCopyright;                 { Copyright }
      property OriginalFile: string read FOriginalFile write FOriginalFile;  { Original file name }
      property Album: string read FAlbum write FAlbum;                       { Album title }
      property Corrupted: Boolean read FIsCorrupted; { True if file corrupted }
  end;

  function NewTwinVQ: PTwinVQ;

implementation

uses ATLLib;

function NewTwinVQ: PTwinVQ;
begin
    New(Result, Create);
    Result.InitFields;
end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadHeader(const FileName: string; var Header: HeaderInfo): Boolean;
var
  SourceFile: PStream;
  Transferred: Integer;
begin
  try
    Result := true;
    { Set read-access and open file }
    SourceFile:= NewReadFileStream(FileName);
    try
      { Read header and get file size }
      Transferred:= SourceFile.Read(Header, 40);
      Header.FileSize := SourceFile.Size;
    finally
      SourceFile.Free;
    end;
    { if transfer is not complete }
    if Transferred < 40 then Result := false;
  except
    { Error }
    Result := false;
  end;
end;

{ --------------------------------------------------------------------------- }

function GetChannelModeID(const Header: HeaderInfo): Byte;
begin
  { Get channel mode from header }
  case SwapOrder32(Header.ChannelMode) of
    0: Result := TWIN_CM_MONO;
    1: Result := TWIN_CM_STEREO
    else Result := 0;
  end;
end;

{ --------------------------------------------------------------------------- }

function GetBitRate(const Header: HeaderInfo): Byte;
begin
  { Get bit rate from header }
  Result := SwapOrder32(Header.BitRate);
end;

{ --------------------------------------------------------------------------- }

function GetSampleRate(const Header: HeaderInfo): Word;
begin
  { Get real sample rate from header }
  Result := SwapOrder32(Header.SampleRate);
  case Result of
    11: Result := 11025;
    22: Result := 22050;
    44: Result := 44100;
    else Result := Result * 1000;
  end;
end;

{ --------------------------------------------------------------------------- }

function GetDuration(const Header: HeaderInfo): Double;
begin
  { Get duration from header }
  Result := Abs((Header.FileSize - SwapOrder32(Header.Size) - 20)) / 125 /
    SwapOrder32(Header.BitRate);
end;

{ --------------------------------------------------------------------------- }

function HeaderEndReached(const Chunk: ChunkHeader): Boolean;
begin
  { Check for header end }
  Result := (Ord(Chunk.ID[1]) < 32) or
    (Ord(Chunk.ID[2]) < 32) or
    (Ord(Chunk.ID[3]) < 32) or
    (Ord(Chunk.ID[4]) < 32) or
    (Chunk.ID = 'DATA');
end;

{ --------------------------------------------------------------------------- }

procedure TTwinVQ.SetTagItem(const ID, Data: string; var Header: HeaderInfo);
var
  Iterator: TChunkType;
begin
  { Set tag item if supported tag-chunk found }
  for Iterator := Low(TChunkType) to High(TChunkType) do
    if TWIN_CHUNK[Iterator] = ID then begin FExists:= True; Header.Tag[Iterator] := Data; Exit; end;
end;

{ --------------------------------------------------------------------------- }

procedure TTwinVQ.ReadTag(const FileName: string; var Header: HeaderInfo);
var
  SourceFile: PStream;
  Chunk: ChunkHeader;
  Data: String;
begin
  try
    { Set read-access, open file }
    SourceFile:= NewReadFileStream(FileName);
    try
      SourceFile.Seek(16, spBegin);
      FExists:= False;
      repeat
      begin
        FillChar(Data, SizeOf(Data), 0);
        { Read chunk header }
        SourceFile.Read(Chunk, 8);
        { Read chunk data and set tag item if chunk header valid }
        if HeaderEndReached(Chunk) then break;
        SetLength(Data, SwapOrder32(Chunk.Size));
        SourceFile.Read(Data[1], SwapOrder32(Chunk.Size));
        SetTagItem(Chunk.ID, Data, Header);
      end;
      until SourceFile.Position>=SourceFile.Size;
    finally
      SourceFile.Free;
    end;
  except
  end;
end;

{ ********************** Private functions & procedures ********************* }

procedure TTwinVQ.FResetData;
begin
  FValid := false;
  FChannelModeID := 0;
  FBitRate := 0;
  FSampleRate := 0;
  FFileSize := 0;
  FDuration := 0;
  FTitle := '';
  FComment := '';
  FAuthor := '';
  FCopyright := '';
  FOriginalFile := '';
  FAlbum := '';
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.FGetChannelMode: string;
begin
  Result := TWIN_MODE[FChannelModeID];
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.FIsCorrupted: Boolean;
begin
  { Check for file corruption }
  Result := (FValid) and
    ((FChannelModeID = 0) or
    (FBitRate < 8) or (FBitRate > 192) or
    (FSampleRate < 8000) or (FSampleRate > 44100) or
    (FDuration < 0.1) or (FDuration > 10000));
end;

{ ********************** Public functions & procedures ********************** }

procedure TTwinVQ.InitFields;
begin
  FResetData;
end;

{ --------------------------------------------------------------------------- }

function TTwinVQ.ReadFromFile(const FileName: string): Boolean;
var
  Header: HeaderInfo;
begin
  { Reset data and load header from file to variable }
  FResetData;
  Result := ReadHeader(FileName, Header);
  { Process data if loaded and header valid }
  if (Result) and (Header.ID = TWIN_ID) then
  begin
    FValid := true;
    { Fill properties with header data }
    FChannelModeID := GetChannelModeID(Header);
    FBitRate := GetBitRate(Header);
    FSampleRate := GetSampleRate(Header);
    FFileSize := Header.FileSize;
    FDuration := GetDuration(Header);
    { Get tag information and fill properties }
    ReadTag(FileName, Header);
    FTitle := Trim(Header.Tag[ctNAME]);
    FComment := Trim(Header.Tag[ctCOMT]);
    FAuthor := Trim(Header.Tag[ctAUTH]);
    FCopyright := Trim(Header.Tag[ctC]);
    FOriginalFile := Trim(Header.Tag[ctFILE]);
    FAlbum := Trim(Header.Tag[ctALBM]);
  end;
end;

function TTwinVQ.SaveToFile(const FileName: string; Destination: string): Boolean;
var SourceFile, DestFile: PStream;
    Header: HeaderInfo;
    Sz: DWord;
function WriteTag(ChunkType: TChunkType; Value: String): DWord;
var Chunk: ChunkHeader;
begin
    Result:= 0;
    if Trim(Value) <> '' then begin
      Result:= Length(Value);
      Move(TWIN_CHUNK[ChunkType][1], Chunk.ID, 4);;
      Chunk.Size:= SwapOrder32(Result);
      DestFile.Write(Chunk, SizeOf(ChunkHeader));
      DestFile.Write(Value[1], Result);
      Result:= Result + SizeOf(ChunkHeader)
    end;
end;
begin
    try
      Result := true;
      if Destination='' then Destination:= FileName;

      DestFile:= NewFileStream('~', ofCreateAlways or ofOpenWrite or ofShareExclusive);
      SourceFile:= NewReadFileStream(FileName);
      try
        Stream2Stream(DestFile, SourceFile, 16);
        SourceFile.Seek(12, spBegin);
        SourceFile.Read(Header.Size, 4);
        SourceFile.Read(Header.Common, SizeOf(ChunkHeader));
        SourceFile.Seek(16, spBegin);
        Sz:= SwapOrder32(Header.Common.Size);
        Sz:= Sz + SizeOf(ChunkHeader);
        Stream2Stream(DestFile, SourceFile, Sz);

        if FExists then begin
          Sz:= Sz + WriteTag(ctNAME, FTitle);
          Sz:= Sz + WriteTag(ctCOMT, FComment);
          Sz:= Sz + WriteTag(ctAUTH, FAuthor);
          Sz:= Sz + WriteTag(ctC, FCopyright);
          Sz:= Sz + WriteTag(ctFILE, FOriginalFile);
          Sz:= Sz + WriteTag(ctALBM, FAlbum);
        end;

        SourceFile.Seek(16+SwapOrder32(Header.Size), spBegin);
        Stream2Stream(DestFile, SourceFile, SourceFile.Size - SourceFile.Position);

        Sz:= SwapOrder32(Sz);
        DestFile.Seek(12, spBegin);
        DestFile.Write(Sz, 4);
      finally
        SourceFile.Free;
        DestFile.Free;
      end;
      if Destination = FileName then DeleteFile(PChar(FileName));
      if MoveFile('~', PChar(Destination)) then
    except
       if FileExists('~') then DeleteFile('~');
       Result := false;
    end;
end;

end.
