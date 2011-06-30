{ *************************************************************************** }
{                                                                             }
{ Audio Tools Library (Freeware)                                              }
{ Class TFLACfile - for manipulating with FLAC file information               }
{                                                                             }
{ Uses:                                                                       }
{   - Class TID3v1                                                            }
{   - Class TID3v2                                                            }
{                                                                             }
{ Copyright (c) 2001,2002 by Jurgen Faul                                      }
{ E-mail: jfaul@gmx.de                                                        }
{ http://jfaul.de/atl                                                         }
{                                                                             }
{ Version 1.0 (13 August 2002)                                                }
{   - Info: channels, sample rate, bits/sample, file size, duration, ratio    }
{   - Class TID3v1: reading & writing support for ID3v1 tags                  }
{   - Class TID3v2: reading & writing support for ID3v2 tags                  }
{                                                                             }
{ Портировано в KOL - Матвеев дмитрий                                         }
{                                                                             }
{ *************************************************************************** }

// - История -

// Дата: 18.11.2003 Версия: 1.01
// [*] - добавил поддержку FLAC-тегов. Для старых версий файлов можно
//       использовать ID3v1 и ID3v2.

// Версия: 1.00
   {Стартовая версия}

unit FLAC;

interface

uses Windows, KOL, ID3v1, ID3v2;

type
  { Class TFLACfile }
  TFields = (fTITLE, fVERSION, fALBUM, fARTIST, fTRACKNUMBER, fORGANIZATION, fDESCRIPTION,
             fDATE, fGENRE, fLOCATION, fCOPYRIGHT, fISRC, fPERFORMER, fLICENSE, fCONTACT, fComment);

  TFieldNames = array [TFields] of String;

  PFLAC = ^TFLAC;
  TFLAC = object(TObj)
    private
      { Private declarations }
      Vld: Boolean;
      FChannels: Byte;
      FSampleRate: Integer;
      FBitsPerSample: Byte;
      FFileLength: Integer;
      FSamples: Integer;
      FVendor: String;
      FFieldValues: TFieldNames;
      FExists: Boolean;
      FID3v1: PID3v1;
      FID3v2: PID3v2;

      procedure InitTag(TagStr: String);
      procedure FResetData;
      function GetValid: Boolean;
      function GetDuration: Double;
      function GetRatio: Double;
      procedure ReadFlacTag(Seek: Integer; FileStream: PStream);
      procedure ReadFlacHeader(Seek: Integer; FileStream: PStream);
      procedure InitFields;
    public
      { Public declarations }
      destructor Destroy; virtual;                          { Destroy object }
      function ReadFromFile(const FileName: string): Boolean;   { Load header }
      function SaveToFile(const FileName: string; Destination: string = ''): Boolean;   { Load header }
      function GetField(const Index: TFields): string;
      procedure SetField(const Index: TFields; const Value: string);

      property ID3v1: PID3v1 read FID3v1;                    { ID3v1 tag data }
      property ID3v2: PID3v2 read FID3v2;                    { ID3v2 tag data }

      property Channels: Byte read FChannels;            { Number of channels }
      property SampleRate: Integer read FSampleRate;       { Sample rate (hz) }
      property BitsPerSample: Byte read FBitsPerSample;     { Bits per sample }
      property FileLength: Integer read FFileLength;    { File length (bytes) }
      property Samples: Integer read FSamples;            { Number of samples }
      property Valid: Boolean read GetValid;           { True if header valid }
      property Duration: Double read GetDuration;       { Duration (seconds) }
      property Ratio: Double read GetRatio;          { Compression ratio (%) }

      property Exists: Boolean read FExists write FExists;              { True if tag found }
      property Vendor: String read FVendor write FVendor;
      property Title: string index fTITLE read GetField write SetField;        { Song title }
      property Artist: string index fARTIST read GetField write SetField;    { Artist name }
      property Album: string index fALBUM read GetField write SetField;       { Album title }
      property Track: string index fTRACKNUMBER read GetField write SetField;        { Track number }
      property Year: string index fDATE read GetField write SetField;         { Release year }
      property Genre: string index fGENRE  read GetField write SetField;        { Genre name }
      property Comment: string index fCOMMENT read GetField write SetField;     { Comment }
      property Copyright: string index fCOPYRIGHT read GetField write SetField;   { (c) }
  end;

  function NewFLAC: PFLAC;

implementation

uses ATLLib;

const FieldNames: TFieldNames = ('TITLE', 'VERSION', 'ALBUM', 'ARTIST', 'TRACKNUMBER',
                   'ORGANIZATION', 'DESCRIPTION', 'DATE', 'GENRE', 'LOCATION', 'COPYRIGHT', 'ISRC',
                   'PERFORMER','LICENSE', 'CONTACT', 'COMMENT');

function NewFLAC: PFLAC;
begin
    New(Result, Create);
    Result.InitFields;
end;

{ ********************** Private functions & procedures ********************* }

procedure TFLAC.FResetData;
var i: TFields;
begin
  FID3v1.ResetData;
  FID3v2.ResetData;
  FVendor:= '';
  for i:= Low(TFields) to high(TFields) do FFieldValues[i]:= '';
  FExists:= False;
  { Reset data }
  FChannels := 0;
  FSampleRate := 0;
  FBitsPerSample := 0;
  FFileLength := 0;
  FSamples := 0;
end;

{ --------------------------------------------------------------------------- }

function TFLAC.GetValid: Boolean;
begin
  { Check for right FLAC file data }
  Result := Vld and
    (FChannels > 0) and
    (FSampleRate > 0) and
    (FBitsPerSample > 0) and
    (FSamples > 0);
end;

{ --------------------------------------------------------------------------- }

function TFLAC.GetDuration: Double;
begin
  { Get song duration }
  if GetValid then
    Result := FSamples / FSampleRate
  else
    Result := 0;
end;

{ --------------------------------------------------------------------------- }

function TFLAC.GetRatio: Double;
begin
  { Get compression ratio }
  if GetValid then
    Result := FFileLength / (FSamples * FChannels * FBitsPerSample / 8) * 100
  else
    Result := 0;
end;

{ ********************** Public functions & procedures ********************** }

procedure TFLAC.InitFields;
begin
  FID3v1 := NewID3v1;
  FID3v2 := NewID3v2;
  FResetData;
end;

{ --------------------------------------------------------------------------- }

destructor TFLAC.Destroy;
begin
  { Destroy object }
  FID3v1.Free;
  FID3v2.Free;
  inherited;
end;

{ --------------------------------------------------------------------------- }

function TFLAC.ReadFromFile(const FileName: string): Boolean;
var SourceFile: PStream;
begin
  { Reset and load header data from file to array }
  FResetData;
  try
    Result := true;
    { Set read-access and open file }
    FID3v1.ReadFromFile(FileName);
    FID3v2.ReadFromFile(FileName);
    SourceFile:= NewReadFileStream(FileName);
    try
      { Read header data }
      FFileLength := SourceFile.Size;
      ReadFlacHeader(FID3v2.Size, SourceFile);
      ReadFlacTag(FID3v2.Size, SourceFile);
    finally
      SourceFile.Free;
    end;
  except
    { Error }
    Result := false;
  end;
end;

procedure TFLAC.ReadFlacHeader(Seek: Integer; FileStream: PStream);
var Hdr: array [1..26] of Byte;
begin
    FillChar(Hdr, SizeOf(Hdr), 0);
    FileStream.Seek(Seek, spBegin);
    FileStream.Read(Hdr, SizeOf(Hdr));
    Vld:= Hdr[1] + Hdr[2] + Hdr[3] + Hdr[4] = 342;
    { Process data if loaded and header valid }
    if Vld then begin
      FChannels := Hdr[21] shr 1 and $7 + 1;
      FSampleRate := Hdr[19] shl 12 + Hdr[20] shl 4 + Hdr[21] shr 4;
      FBitsPerSample := Hdr[21] and 1 shl 4 + Hdr[22] shr 4 + 1;
      FSamples := Hdr[23] shl 24 + Hdr[24] shl 16 + Hdr[25] shl 8 + Hdr[26];
    end;
end;

type TAB = array [0..0] of Byte;
     Tab_3 = array[0..3]of Byte;
procedure TFLAC.ReadFlacTag(Seek: Integer; FileStream: PStream);
var ab: Tab_3;
    Buff: Pointer;
    P, i, L: DWord;
    S: UTF8String;
begin
    FileStream.Seek(Seek+42, spBegin);
    while FileStream.Position+4<FileStream.Size do begin
      FileStream.Read(ab[3], 1);
      FileStream.Read(ab[2], 1);
      FileStream.Read(ab[1], 1);
      FileStream.Read(ab[0], 1);
      i:= DWord(ab);
      i:= i and $00FFFFFF;
      if ab[3] and $FE = 4 then begin
        GetMem(Buff, i);
        FileStream.Read(Buff^, i);
        L:= DWord(TAB(Buff^)[0]);
        SetLength(S, L); P:= 4;
        Move(TAB(Buff^)[P], S[1], L); P:= P+L;
        FVendor:= UTF8Decode(S);
        L:= DWord(TAB(Buff^)[P]); P:= P+4;
        FExists:= L>0;
        for i:= 1 to L do begin
          L:= DWord(TAB(Buff^)[P]); P:= P+4;
          S:= ''; SetLength(S, L);
          Move(TAB(Buff^)[P], S[1], L); P:= P+L;
          InitTag(UTF8Decode(S));
        end;
        FreeMem(Buff);
      end;
      if (ab[3] and 1 = 0) then Break;
    end;
end;

function TFLAC.SaveToFile(const FileName: string; Destination: string): Boolean;
var SourceFile, DestFile: PStream;
    ab: Tab_3;
    P, i, L: DWord;
    S: UTF8String;
    f: TFields;
    W: WideString;
begin
    try
      Result := true;
      if Destination='' then Destination:= FileName;
      DestFile:= NewFileStream('~', ofCreateAlways or ofOpenWrite or ofShareExclusive);
      SourceFile:= NewReadFileStream(FileName);
      try
        FID3v2.ReadFromFile(FileName);
        Stream2Stream(DestFile, SourceFile, 42+FID3v2.Size);
        while SourceFile.Position+4<SourceFile.Size do begin
          SourceFile.Read(ab[3], 1);
          SourceFile.Read(ab[2], 1);
          SourceFile.Read(ab[1], 1);
          SourceFile.Read(ab[0], 1);
          i:= DWord(ab);
          i:= i and $00FFFFFF;
          if ab[3] and $FE <> 4 then Stream2Stream(DestFile, SourceFile, i)
          else begin
             SourceFile.Seek(i, spCurrent);
             L:= 4 + Length(FVendor) + 4;
             P:= 0;
             if FExists then
               for f:= Low(TFields) to high(TFields) do
                 if Trim(FFieldValues[f])<>'' then begin
                   W:= FieldNames[f]+'='+FFieldValues[f];
                   S:= UTF8Encode(W);
                   L:= L + 4 + length(S);
                   Inc(P);
                 end;
             FExists:= P>0;
             Tab_3(L)[3]:= ab[3];
             DestFile.Write(Tab_3(L)[3], 1);
             DestFile.Write(Tab_3(L)[2], 1);
             DestFile.Write(Tab_3(L)[1], 1);
             DestFile.Write(Tab_3(L)[0], 1);

             W:= FVendor;
             S:= UTF8Encode(W);
             I:= length(S);
             DestFile.Write(I, 4); DestFile.Write(FVendor[1], I);
             DestFile.Write(P, 4);
             if FExists then
               for f:= Low(TFields) to high(TFields) do
                 if Trim(FFieldValues[f])<>'' then begin
                   W:= FieldNames[f]+'='+FFieldValues[f];
                   S:= UTF8Encode(W);
                   I:= length(S);
                   DestFile.Write(I, 4); DestFile.Write(S[1], I);
                 end;
          end;
          if (ab[3] and 1 = 0) then Break;
        end;
        Stream2Stream(DestFile, SourceFile, SourceFile.Size - SourceFile.Position);

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

procedure TFLAC.InitTag(TagStr: String);
var i: TFields;
    N: String;
begin
    N:= Parse(TagStr, '=');
    for i:= Low(TFields) to high(TFields) do
       if FieldNames[i] = AnsiUpperCase(N) then begin
         FFieldValues[i]:= TagStr;
         Exit;
       end;
end;

function TFLAC.GetField(const Index: TFields): string;
begin
    Result:= FFieldValues[index];
end;

procedure TFLAC.SetField(const Index: TFields; const Value: string);
begin
    FFieldValues[index]:= Value;
end;

end.
