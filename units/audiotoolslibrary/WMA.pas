{ *************************************************************************** }
{                                                                             }
{ Audio Tools Library (Freeware)                                              }
{ Class TWMAfile - for extracting information from WMA file header            }
{                                                                             }
{ Copyright (c) 2001,2002 by Jurgen Faul                                      }
{ E-mail: jfaul@gmx.de                                                        }
{ http://jfaul.de/atl                                                         }
{                                                                             }
{ Version 1.0 (29 April 2002)                                                 }
{   - Support for Windows Media Audio (versions 7, 8)                         }
{   - File info: file size, channel mode, sample rate, duration, bit rate     }
{   - WMA tag info: title, artist, album, track, year, genre, comment         }
{                                                                             }
{ Портировано в KOL - Матвеев дмитрий                                         }
{ Добавлениа возможность редактирования тегов                                 }
{                                                                             }
{ *************************************************************************** }

// - История -

// Дата: 14.11.2003 Версия: 1.01
// [+] - добавил возможность записи тегов.
// [!] - исправил ошибку при сохранении в файл, ранее ничего и не сохранялось. (Спасибо PA)

// Версия: 1.00
   {Стартовая версия}


unit WMA;

interface

uses Windows, KOL;

const
  { Channel modes }
  WMA_CM_UNKNOWN = 0;                                               { Unknown }
  WMA_CM_MONO = 1;                                                     { Mono }
  WMA_CM_STEREO = 2;                                                 { Stereo }

  { Channel mode names }
  WMA_MODE: array [0..2] of string = ('Unknown', 'Mono', 'Stereo');
  WMA_MAX_STRING_SIZE = 50*1024;

type
  TWMA_Buffer = array [1..WMA_MAX_STRING_SIZE * 2] of Byte;

  TObjectID = array [1..16] of Char;
  TWMAHeader = packed record
    ID: TObjectID;
    HeadSize: I64;
    CountObject: Longint;
    Skip_2: Word;
  end;

  PData = ^TData;
  TData = array[0..100*1024] of byte;
  TWMAObject = packed record
    ID: TObjectID;
    SizeObject: Longint;
    Data: PData;
  end;
  TWMAObjectList = array of TWMAObject;

  TWMA_IDs = (idWMA_FILE_PROPERTIES, idWMA_STREAM_PROPERTIES, idWMA_CONTENT_DESCRIPTION, idWMA_EXTENDED_CONTENT_DESCRIPTION);

  TWMA_FIELDs = (fWM_Genre, fWM_GenreID, fWM_AlbumTitle, fWM_MCDI, fWM_Track, fWM_TrackNumber,
                fWM_Year, fWM_Composer, fWM_Lyrics, fWMFSDKVersion, fWMFSDKNeeded);
  PTagVar = ^TTagVar;
  TTagVar = packed record
     StrValue: String;
     IntValue: Longint;
     ArrValue: TWMA_Buffer;
     ArrValueSize: DWord;
  end;

  PWMA = ^TWMA;
  TWMA = object(TObj)
  private
    FWMAHeader: TWMAHeader;
    FWMAObjectList: TWMAObjectList;
    FWMA_IDsIndex: array [TWMA_IDs] of Integer;
    FFileSize: DWord;
    FDataPosition: DWord;
    FTagNamesEx: PStrList;
    FArtist: String;
    FCopyRight: String;
    FTitle: String;
    FComment: String;
    FRating: String;
    FAlbum: String;
    FChannelsModeID: Word;
    FChannelsMode: String;
    FDuration: Double;
    FBitRate: LongInt;
    FSampleRate: LongInt;
    FTrack: Integer;
    FComposer: String;
    FLyrics: String;
    FYear: String;
    FGenre: String;
    FVersion: String;

    function ReadFile(const AFileName: String): Boolean;
    function GetTag(ANumTag: Integer): String;
    procedure SetTag(ANumTag: Integer; ATag: String);
    function GetTagEx(ATag: TWMA_FIELDs; const ADefault: PTagVar): PTagVar;
    procedure SetTagEx(ATag: TWMA_FIELDs; ATagValue: PTagVar);
    procedure ClearData;
    function GetTagNamesEx: PStrList;
    procedure InitFields;
  protected

  public
    destructor Destroy; virtual;

    function LoadFromFile(const AFileName: String): Boolean;
    function SaveToFile(const AFileName: String; ADestination: String = ''): Boolean;

    property Track: Integer read FTrack write FTrack;
    property Album: String read FAlbum write FAlbum;
    property Genre: String read FGenre write FGenre;
    property Year: String read FYear write FYear;
    property Composer: String read FComposer write FComposer;
    property Lyrics: String read FLyrics write FLyrics;


    property Title: String read FTitle write FTitle;
    property Artist: String read FArtist write FArtist;
    property CopyRight: String read FCopyRight write FCopyRight;
    property Comment: String read FComment write FComment;
    property Rating: String read FRating write FRating;

    property ChannelsModeID: Word read FChannelsModeID;
    property ChannelsMode: String read FChannelsMode;
    property SampleRate: LongInt read FSampleRate;
    property BitRate: LongInt read FBitRate;
    property Duration: Double read FDuration;
    property Version: String read FVersion;

    property TagNamesEx: PStrList read GetTagNamesEx;
  end;

  function NewWMA: PWMA;

implementation

uses ATLLib;

function NewWMA: PWMA;
begin
    New(Result, Create);
    Result.InitFields;
end;

const
  WMA_HEADER_ID =
    #48#38#178#117#142#102#207#17#166#217#0#170#0#98#206#108;

  WMA_IDs: array [TWMA_IDs] of TObjectID = (#161#220#171#140#71#169#207#17#142#228#0#192#12#32#83#101,
                                         #145#7#220#183#183#169#207#17#142#230#0#192#12#32#83#101,
                                         #51#38#178#117#142#102#207#17#166#217#0#170#0#98#206#108,
                                         #64#164#208#210#7#227#210#17#151#240#0#160#201#94#168#80);

const
  WMA_FIELD_NAME: array [TWMA_FIELDs] of String =
                        ('WM/Genre', 'WM/GenreID', 'WM/AlbumTitle', 'WM/MCDI', 'WM/Track',
                        'WM/TrackNumber', 'WM/Year', 'WM/Composer', 'WM/Lyrics',
                        'WMFSDKVersion', 'WMFSDKNeeded');


{ TWMA }

procedure ReMem(var AData: PData; ASize, ANewSize: Integer);
var Data: PData;
begin
    GetMem(Data, ANewSize);
    if AData<> nil then begin
      Move(AData^[0], Data^[0], Min(ASize, ANewSize));
      FreeMem(AData, ASize);
    end;
    AData:= Data;
end;

procedure TWMA.ClearData;
var i: Integer;
begin
    for i:= Low(FWMAObjectList) to High(FWMAObjectList) do FreeMem(FWMAObjectList[i].Data, FWMAObjectList[i].SizeObject);
    SetLength(FWMAObjectList, 0);
end;

procedure TWMA.InitFields;
begin
    FTagNamesEx:= NewStrList;
end;

destructor TWMA.Destroy;
begin
    ClearData;
    FTagNamesEx.Free;
    Setlength(FWMAObjectList, 0);

    FArtist:= ''; FCopyRight:= ''; FTitle:= ''; FComment:= ''; FRating:= ''; FAlbum:= '';
    FChannelsMode:= ''; FComposer:= ''; FLyrics:= ''; FYear:= ''; FGenre:= ''; FVersion:= '';
    inherited;
end;

function TWMA.GetTag(ANumTag: Integer): String;
var
  Position, i: Integer;
  FieldSize: array [1..5] of Word;
  StringSize: Integer;
  FieldData: TWMA_Buffer;
begin
  Move(FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[4], FieldSize, SizeOf(FieldSize));
  Position:= 4 + SizeOf(FieldSize);

  for i:= 1 to ANumTag-1 do Position:= Position + FieldSize[i];
  StringSize := Min(WMA_MAX_STRING_SIZE, FieldSize[ANumTag] div 2);
  Move(FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[Position], FieldData, StringSize * 2);
  Result:= WideCharLenToString(PWideChar(@FieldData), StringSize-1);
end;

function TWMA.GetTagEx(ATag: TWMA_FIELDs; const ADefault: PTagVar): PTagVar;
var StringSize, Position, i, j: Integer;
    FieldsCount, FieldSize, DataType: Word;
    FieldData: TWMA_Buffer;
    TagName, FieldName: String;
    R: LongInt;
begin
    Result:= ADefault;
    TagName:= WMA_FIELD_NAME[ATag];
    Position:= 4;
    Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldsCount, SizeOf(FieldsCount));
    Position:= Position + SizeOf(FieldsCount);
    for i:= 0 to FieldsCount-1 do begin
       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize, SizeOf(FieldSize));
       Position:= Position + SizeOf(FieldSize);
       StringSize := Min(WMA_MAX_STRING_SIZE, FieldSize div 2);

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldData, StringSize * 2);
       FieldName:= WideCharLenToString(PWideChar(@FieldData), StringSize-1);
       Position:= Position + FieldSize;

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], DataType, SizeOf(DataType));
       Position:= Position + SizeOf(DataType);

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize, SizeOf(FieldSize));
       Position:= Position + SizeOf(FieldSize);

       if FieldName = TagName then begin
         case DataType of
           0: begin
             StringSize := Min(WMA_MAX_STRING_SIZE, FieldSize div 2);
             Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldData, StringSize * 2);
             Result.StrValue:= WideCharLenToString(PWideChar(@FieldData), StringSize-1);
           end;
           1: begin
             Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldData, FieldSize);
//             Result:= VarArrayCreate([0, FieldSize-1], varByte);
             Result.ArrValueSize:= FieldSize;
             for j:= 1 to FieldSize do Result.ArrValue[j]:= FieldData[j];
           end;
           2:;
           3: begin
             Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], R, FieldSize);
             Result.IntValue:= R;
           end;
         end;
         Break;
       end;
       Position:= Position + FieldSize;
    end;
end;

function TWMA.GetTagNamesEx: PStrList;
var
  StringSize, Position, i: Integer;
  FieldsCount, FieldSize, DataType: Word;
  FieldData: TWMA_Buffer;
begin
    Result:= FTagNamesEx;
    Result.Clear;

    Position:= 4;
    Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldsCount, SizeOf(FieldsCount));
    Position:= Position + SizeOf(FieldsCount);
    for i:= 0 to FieldsCount-1 do begin
       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize, SizeOf(FieldSize));
       Position:= Position + SizeOf(FieldSize);
       StringSize := Min(WMA_MAX_STRING_SIZE, FieldSize div 2);

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldData, StringSize * 2);
       Result.Add(WideCharLenToString(PWideChar(@FieldData), StringSize-1));
       Position:= Position + FieldSize;

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], DataType, SizeOf(DataType));
       Position:= Position + SizeOf(DataType);

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize, SizeOf(FieldSize));
       Position:= Position + SizeOf(FieldSize);

       Position:= Position + FieldSize;
    end;
end;

function TWMA.LoadFromFile(const AFileName: String): Boolean;
var i: LongInt;
    TagVar: PTagVar;
begin
  Result := False;
  try
      if not ReadFile(AFileName) then Exit;

      Move(FWMAObjectList[FWMA_IDsIndex[idWMA_STREAM_PROPERTIES]].Data[60], FChannelsModeID, SizeOf(Word));
      FChannelsMode:= WMA_MODE[ChannelsModeID];
      Move(FWMAObjectList[FWMA_IDsIndex[idWMA_STREAM_PROPERTIES]].Data[60+SizeOf(Word)+SizeOf(LongInt)], FBitRate, SizeOf(LongInt));
      FBitRate:= FBitRate * 8 div 1000;
      Move(FWMAObjectList[FWMA_IDsIndex[idWMA_STREAM_PROPERTIES]].Data[60+SizeOf(Word)], FSampleRate, SizeOf(LongInt));
      Move(FWMAObjectList[FWMA_IDsIndex[idWMA_FILE_PROPERTIES]].Data[80], i, SizeOf(LongInt));
      FDuration:= FFileSize * 8 / i;

      FTitle:= GetTag(1);
      FArtist:= GetTag(2);
      FCopyRight:= GetTag(3);
      FComment:= GetTag(4);
      FRating:= GetTag(5);
      New(TagVar);
      TagVar.IntValue:= 0; FTrack:= GetTagEx(fWM_Track, TagVar).IntValue;
      TagVar.StrValue:= ''; FGenre:= GetTagEx(fWM_Genre, TagVar).StrValue;
      TagVar.StrValue:= ''; if FGenre = '' then FGenre:= GetTagEx(fWM_GenreID, TagVar).StrValue;
      TagVar.StrValue:= ''; FAlbum:= GetTagEx(fWM_AlbumTitle, TagVar).StrValue;
      TagVar.StrValue:= ''; FYear:= GetTagEx(fWM_Year, TagVar).StrValue;
      TagVar.StrValue:= ''; FComposer:= GetTagEx(fWM_Composer, TagVar).StrValue;
      TagVar.StrValue:= ''; FLyrics:= GetTagEx(fWM_Lyrics, TagVar).StrValue;
      TagVar.StrValue:= ''; FVersion:= GetTagEx(fWMFSDKVersion, TagVar).StrValue;
      Dispose(TagVar);
      Result := true;
  except
  end;
end;

function TWMA.ReadFile(const AFileName: String): Boolean;
var Source: PStream;
    i: LongInt;
    k: TWMA_IDs;
begin
  Result := False;
  try
    ClearData;
    Source:= NewReadFileStream(AFileName);
    try
      FFileSize:= Source.Size;
      { Check for existing header }
      Source.Read(FWMAHeader, SizeOf(TWMAHeader));
      if FWMAHeader.ID = WMA_HEADER_ID then
      begin
        { Read all objects in header and get needed data }
        SetLength(FWMAObjectList, FWMAHeader.CountObject);
        for i:= 0 to FWMAHeader.CountObject-1 do begin
          Source.Read(FWMAObjectList[i].ID, SizeOf(TObjectID));
          Source.Read(FWMAObjectList[i].SizeObject, SizeOf(FWMAObjectList[i].SizeObject));
          FWMAObjectList[i].SizeObject:= FWMAObjectList[i].SizeObject - SizeOf(TObjectID) - SizeOf(FWMAObjectList[i].SizeObject);

          ReMem(FWMAObjectList[i].Data, 0, FWMAObjectList[i].SizeObject);

          Source.Read(FWMAObjectList[i].Data[0], FWMAObjectList[i].SizeObject);
          for k:= Low(TWMA_IDs) to High(TWMA_IDs) do begin
             if FWMAObjectList[i].ID = WMA_IDs[k] then FWMA_IDsIndex[k]:= i;
          end;
        end;
        FDataPosition:= Source.Position;

        Result := true;
      end;
    finally
      Source.Free;
    end;
  except
  end;
end;

function TWMA.SaveToFile(const AFileName: String; ADestination: String = ''): Boolean;
var Destination, Source, Src: PStream;
    i, S: LongInt;
    TagVar: PTagVar;
begin
  Result := False;
  try
    if not ReadFile(AFileName) then Exit;
    if ADestination = '' then ADestination:= AFileName;

    SetTag(1, FTitle);
    SetTag(2, FArtist);
    SetTag(3, FCopyRight);
    SetTag(4, FComment);
    SetTag(5, FRating);

    New(TagVar);
    TagVar.StrValue:= FAlbum; SetTagEx(fWM_AlbumTitle, TagVar);
    TagVar.IntValue:= FTrack; SetTagEx(fWM_Track, TagVar);
    TagVar.StrValue:= FGenre; SetTagEx(fWM_Genre, TagVar);
    TagVar.StrValue:= FGenre; SetTagEx(fWM_GenreID, TagVar);
    TagVar.StrValue:= FYear; SetTagEx(fWM_Year, TagVar);
    TagVar.StrValue:= FComposer; SetTagEx(fWM_Composer, TagVar);
    TagVar.StrValue:= FLyrics; SetTagEx(fWM_Lyrics, TagVar);
    Dispose(TagVar);

    Source:= NewMemoryStream;
    try
      Src:= NewReadFileStream(AFileName);
      try
        if Src.Handle = INVALID_HANDLE_VALUE then Exit; 
        Src.Position:= 0;
        Stream2Stream(Source, Src, Src.Size);
      finally
        Src.Free;
      end;
      Source.Position:= 0;

      Destination:= NewFileStream(ADestination, ofCreateAlways or ofOpenWrite or ofShareExclusive);
      try
        if Destination.Handle = INVALID_HANDLE_VALUE then begin Destination.Free; Exit; end;
        Destination.Write(FWMAHeader, SizeOf(TWMAHeader));

        for i:= 0 to FWMAHeader.CountObject-1 do begin
          Destination.Write(FWMAObjectList[i].ID, SizeOf(TObjectID));
          S:= FWMAObjectList[i].SizeObject + SizeOf(TObjectID) + SizeOf(FWMAObjectList[i].SizeObject);
          Destination.Write(S, SizeOf(FWMAObjectList[i].SizeObject));
          Destination.Write(FWMAObjectList[i].Data[0], FWMAObjectList[i].SizeObject);
        end;
        FWMAHeader.HeadSize:= Int2Int64(Destination.Position);
        Source.Position:= FDataPosition;

        Stream2Stream(Destination, Source, Source.Size - FDataPosition);
        Destination.Position:= 0;
        Destination.Write(FWMAHeader, SizeOf(TWMAHeader));
        Result := true;
      finally
        Destination.Free;
      end;
    finally
      Source.Free;
    end;
  except
  end;
end;

procedure TWMA.SetTag(ANumTag: Integer; ATag: String);
var
  Position, i: Integer;
  FieldSize: array [1..5] of Word;
  NewSize, OldSize, OldFieldSize, NewFieldSize: Integer;
  S: String;
  FieldData: TWMA_Buffer;
begin
    Move(FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[4], FieldSize, SizeOf(FieldSize));
    S:= ATag;
    OldFieldSize:= FieldSize[ANumTag];
    NewFieldSize:= Min(WMA_MAX_STRING_SIZE, Length(S)*2 + 2);
    OldSize:= FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].SizeObject;
    NewSize:= OldSize + NewFieldSize - OldFieldSize;
    ReMem(FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data, OldSize, Max(NewSize, OldSize));

    Position:= 4 + SizeOf(FieldSize);
    for i:= 1 to ANumTag do Position:= Position + FieldSize[i];
    Move(FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[Position], FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[Position + NewFieldSize - OldFieldSize], OldSize - Position);
    Position:= Position - OldFieldSize;
    FieldSize[ANumTag]:= NewFieldSize;
    Move(FieldSize, FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[4], SizeOf(FieldSize));

    StringToWideChar(S, PWideChar(@FieldData), NewFieldSize - 1);
    FieldData[NewFieldSize-1]:= 0; FieldData[NewFieldSize]:= 0;
    Move(FieldData, FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data[Position], NewFieldSize);
    FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].SizeObject:= NewSize;

    ReMem(FWMAObjectList[FWMA_IDsIndex[idWMA_CONTENT_DESCRIPTION]].Data, Max(NewSize, OldSize), NewSize);
end;

procedure TWMA.SetTagEx(ATag: TWMA_FIELDs; ATagValue: PTagVar);
var FirstPos, OldSize, NewSize, Position, i, j: Integer;
    StringSize, FieldsCount, FieldSize, DataType: Word;
    FieldData: TWMA_Buffer;
    S, TagName, FieldName: String;
    R: LongInt;
begin
    TagName:= WMA_FIELD_NAME[ATag];
    Position:= 4;
    Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldsCount, SizeOf(FieldsCount));
    Position:= Position + SizeOf(FieldsCount);
    for i:= 0 to FieldsCount-1 do begin
       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize, SizeOf(FieldSize));
       Position:= Position + SizeOf(FieldSize);
       StringSize := Min(WMA_MAX_STRING_SIZE, FieldSize div 2);

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldData, StringSize * 2);
       FieldName:= WideCharLenToString(PWideChar(@FieldData), StringSize-1);
       Position:= Position + FieldSize;

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], DataType, SizeOf(DataType));
       Position:= Position + SizeOf(DataType);

       Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize, SizeOf(FieldSize));
       Position:= Position + SizeOf(FieldSize);
       FirstPos:= Position;

       if FieldName = TagName then begin
         case DataType of
           0: begin
             S:= ATagValue.StrValue; StringSize:= Length(S)*2+2;
             StringToWideChar(S, PWideChar(@FieldData), StringSize-2);
             FieldData[StringSize-1]:= 0; FieldData[StringSize]:= 0;

             OldSize:= FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].SizeObject;
             NewSize:= OldSize + StringSize - FieldSize;
             ReMem(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data, OldSize, Max(OldSize, NewSize));

             Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos+FieldSize], FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos+StringSize], OldSize - (FirstPos+FieldSize));
             Move(FieldData, FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos], StringSize);
             Move(StringSize, FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos-SizeOf(FieldSize)], SizeOf(FieldSize));
             FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].SizeObject:= NewSize;

             ReMem(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data, Max(OldSize, NewSize), NewSize);
           end;
           1: begin
             StringSize:= ATagValue.ArrValueSize;
             for j:= 1 to StringSize do FieldData[j]:= ATagValue.ArrValue[j];

             OldSize:= FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].SizeObject;
             NewSize:= OldSize + StringSize - FieldSize;
             ReMem(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data, OldSize, Max(OldSize, NewSize));

             Move(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos+FieldSize], FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos+StringSize], OldSize - (FirstPos+FieldSize));
             Move(FieldData, FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos], StringSize);
             Move(StringSize, FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[FirstPos-SizeOf(FieldSize)], SizeOf(FieldSize));
             FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].SizeObject:= NewSize;

             ReMem(FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data, Max(OldSize, NewSize), NewSize);
           end;
           2:;
           3: begin
             R:= ATagValue.IntValue;
             Move(R, FWMAObjectList[FWMA_IDsIndex[idWMA_EXTENDED_CONTENT_DESCRIPTION]].Data[Position], FieldSize);
           end;
         end;
         Break;
       end;
       Position:= Position + FieldSize;
    end;
end;

end.
