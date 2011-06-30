unit KOLMHCDRIP;
//  MHLame Компонент (MHLame Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 15-фев(feb)-2003
//  Дата коррекции (Last correction Date): 15-фев(feb)-2003
//  Версия (Version): 1.0
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Alexei O. Sabline
//  Новое в (New in):
//  V1.0
//  [+] Создан
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Исключения (Exceptions)

interface

uses KOL,
  Windows, CDRip_dll, KOLMHLameCoder;

//type ECDRIPError = object(Exception);
//PCDRIPError=^ECDRIPError; type  MyStupid0=DWord;

type TCDROMName = array[0..255] of char;

type
  PTrack = ^TTrack;
  TTrack = object(TObj)
  protected
    TrackNum: Integer;
    BegTrack: LongInt;
    EndTrack: LongInt;
  private
    function GetDurationTime: string;
  public
    Duration: LongInt;
    Size: LongInt;
    Mode: string[5];
    property DurationTime: string read GetDurationTime;
  end;

function NewTrack: PTrack;

type
  TProgressEvent = procedure(Sender: PObj; PercentComplete: Word) of object;
  TProcessTrackEvent = procedure(Sender: PObj; TrackNum: Word) of object;

type
  PDriveTableClass = ^TDriveTableClass;
  TDriveTableClass = object(TObj)
  private
    FDTable: TDriveTable;
    function GetDriveType: TDriveType;
    procedure SetDriveType(Value: TDriveType);
    function GetReadMethod: TReadMethod;
    procedure SetReadMethod(Value: TReadMethod);
    function GetSetSpeed: TSetSpeed;
    procedure SetSetSpeed(Value: TSetSpeed);
    function GetEnableMode: TEnableMode;
    procedure SetEnableMode(Value: TEnableMode);
    function GetEndian: TEndian;
    procedure SetEndian(Value: TEndian);
   { published }
    property DriveType: TDriveType read GetDriveType write SetDriveType;
    property ReadMethod: TReadMethod read GetReadMethod write SetReadMethod;
    property SetSpeed: TSetSpeed read GetSetSpeed write SetSetSpeed;
    property Endian: TEndian read GetEndian write SetEndian;
    property EnableMode: TEnableMode read GetEnableMode write SetEnableMode;
    property Density: LongInt read FDTable.nDensity write FDTable.nDensity;
    property Atapi: BOOL read FDTable.bAtapi write FDTable.bAtapi;
  end;
type MyStupid86104 = DWord;
function NewDriveTableClass: PDriveTableClass;

type
  PMHCDRIP = ^TMHCDRIP;
  TKOLMHCDRIP = PMHCDRIP;

  TMHCDRIP = object(TObj)
  private
    { Private declarations }
    FCDRomNum: LongInt;
    FDriveTable: PDriveTableClass; //TDriveTableClass;
    FOutputFormat: TOutputFormat;
    FCDRomName: TCDROMName;
    FLameCoder: PMHLameCoder; //TLameCoder;
    FTocNum: LongInt;
    FTracks: PStrListEx; //TStrings;
    FJitters: PStrListEx; //TStrings;
    FJittersNum: LongInt;
    FJitter: boolean;
    FEncode: boolean;
    FWriteWAV: boolean;
    FCancelRip: boolean;
    FSpeed: integer;
    FOnBeginTrack: TProcessTrackEvent;
    FOnEndTrack: TProcessTrackEvent;
    FOnProgress: TProgressEvent;
    FVersion: string;
    FParams: TCDROMParams;
    procedure SetActiveCD(Value: LongInt);
    procedure SetOutputFormat(Value: TOutputFormat);
    procedure SetLameCoder(Value: PMHLameCoder);
    procedure SetLameFormat;
    procedure SetJitterCorrection(Value: boolean);
  protected
    { Protected declarations }
    procedure RipSectors(BegSector, EndSector: LongInt; FileName: string);
  public
    { Public declarations }
      { constructor Create(AOwner: TComponent); override;
      } destructor Destroy;
      virtual; function IsCDROMReady: boolean;
    function SetNewCDROMParams: boolean;
    procedure RipTrack(ATrackNum: LongInt; FileName: string);
    procedure RipTrackTime(ATrackNum, BegTime, LengthTime: LongInt; FileName: string);
    procedure CancelRip;
    function TrackDuration(Index: integer): LongInt;
    function TrackSize(Index: integer): LongInt;
    function GetTrack(Index: integer): PTrack;
    property CDRomName: TCDRomName read FCDRomName write FCDRomName;
    property TrackNum: LongInt read FTOCNum;
    property Tracks: PStrListEx {TStrings} read FTracks;
    property Jitters: PStrListEx read FJitters;
    property JittersNum: LongInt read FJittersNum;
   { published }
    { Published declarations }
    property Coder: PMHLameCoder {TLameCoder} read FLameCoder write SetLameCoder;
    property CDRomNum: LongInt read FCDRomNum write SetActiveCD;
    property DriveTable: PDriveTableClass read FDriveTable write FDriveTable;
    property OutputFormat: TOutputFormat read FOutputFormat write SetOutputFormat default STEREO44100;
    property Encode: boolean read FEncode write FEncode default false;
    property WriteWAV: boolean read FWriteWAV write FWriteWAV default false;
    property JitterCorrect: boolean read FJitter write SetJitterCorrection default true;
    property OnBeginTrack: TProcessTrackEvent read FOnBeginTrack write FOnBeginTrack;
    property OnEndTrack: TProcessTrackEvent read FOnEndTrack write FOnEndTrack;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property Version: string read FVersion write FVersion;
    property Speed: integer read FSpeed write FSpeed;
  end;
function NewMHCDRIP(AOwner: {TComponent} PControl): PMHCDRIP;
//type  MyStupid20258=DWord;

//procedure Register;
{$R CDRip.res}
implementation

//var

function TTrack.GetDurationTime: string;
var
  m, s, ms,
    tmp: longint;
begin
  tmp := duration;
  ms := tmp mod 1000;
  tmp := tmp div 1000;
  s := tmp mod 60;
  tmp := tmp div 60;
  m := tmp mod 60;
  tmp := (tmp div 60) mod 24;
//  GetDurationTime:=TimeToStr(EncodeTime(tmp,m,s,ms));
end;

function TDriveTableClass.GetDriveType: TDriveType;
begin
  Result := TDriveType(FDTable.DriveType);
end;

procedure TDriveTableClass.SetDriveType(Value: TDriveType);
begin
  FDTable.DriveType := LongInt(Value);
end;

function TDriveTableClass.GetReadMethod: TReadMethod;
begin
  Result := TReadMethod(FDTable.ReadMethod);
end;

procedure TDriveTableClass.SetReadMethod(Value: TReadMethod);
begin
  FDTable.ReadMethod := LongInt(Value);
end;

function TDriveTableClass.GetSetSpeed: TSetSpeed;
begin
  Result := TSetSpeed(FDTable.SetSpeed);
end;

procedure TDriveTableClass.SetSetSpeed(Value: TSetSpeed);
begin
  FDTable.SetSpeed := LongInt(Value);
end;

function TDriveTableClass.GetEnableMode: TEnableMode;
begin
  Result := TEnableMode(FDTable.EnableMode);
end;

procedure TDriveTableClass.SetEnableMode(Value: TEnableMode);
begin
  FDTable.EnableMode := LongInt(Value);
end;

function TDriveTableClass.GetEndian: TEndian;
begin
  Result := TEndian(FDTable.Endian);
end;

procedure TDriveTableClass.SetEndian(Value: TEndian);
begin
  FDTable.Endian := LongInt(Value);
end;

function LeadingZero2(w: Word): string;
var s: string;
begin
  Str(w: 0, s);
  LeadingZero2 := Copy('00', 1, 2 - Length(s)) + s;
end;

function NewMHCDRIP(AOwner: {TComponent} PControl): PMHCDRIP;
//constructor TMHCDRIP.Create(AOwner: TComponent);
var i: LongInt;
  S: string;
  Toc1, Toc2: TTocEntry;
  L1, L2: Integer; //Int64;
  TT: PTrack;
begin
  New(Result, Create);
//     inherited Create(AOwner);
  with Result^ do
  begin
    try
      FTracks := NewStrListEx; //TStringList.Create;
      FJitters := NewStrListEx; //TStringList.Create;
      L1 := CR_GeTCDRIPVersion;
      FVersion := Int2Str(L1);
      if CR_Init <> CDEX_ERROR then
      begin
        if CR_GetCDROMParameters(FParams) <> CDEX_ERROR then
        begin
          FCDRomName := TCDROMName(FParams.lpszCDROMID);
          FCDRomNum := CR_GetActiveCDROM;
          FDriveTable := NewDriveTableClass; //TDriveTableClass.Create;
          FDriveTable.FDTable := FParams.DriveTable;
          FOutputFormat := TOutputFormat(FParams.nOutputFormat);
          FSpeed := FParams.nSpeed;
          FJitter := true;
          FParams.bJitterCorrection := LongBool(FJitter);
        end;
        if CR_ReadTOC <> CDEX_ERROR then
          FTOCNum := CR_GetNumTocEntries;
        for i := 0 to FTOCNum - 1 do
        begin
          S := 'Track' + LeadingZero2(i + 1);
          L1 := CR_GetTOCEntry(i);
          L2 := CR_GetTOCEntry(i + 1);
          Move(L1, Toc1, 6);
          Move(L2, Toc2, 6);
          TT := NewTrack; //TTrack.Create;
          FTracks.AddObject(S, DWord(PObj(TT)));
          PTrack(FTracks.Objects[i]).TrackNum := i + 1;
          PTrack(FTracks.Objects[i]).BegTrack := Toc1.dwStartSector;
          PTrack(FTracks.Objects[i]).EndTrack := Toc2.dwStartSector - 1;
          if Toc1.btFlag = AUDIOTRKFLAG then
            PTrack(FTracks.Objects[i]).Mode := 'Audio'
          else
            PTrack(FTracks.Objects[i]).Mode := 'Data';
        end;
      end;
      FJittersNum := 0;
    except
      ;
//        raise ECDRIPError.Create('Initialization failure');
    end;
  end;
end;


destructor TMHCDRIP.Destroy;
begin
  FTracks.Free;
  FJitters.Free;
  FDriveTable.Free;
  FLameCoder := nil;
  inherited Destroy;
end;

function TMHCDRIP.TrackDuration(Index: integer): LongInt;
begin
  if (Index > -1) and (Index < FTracks.Count) then
    TrackDuration := PTrack(FTracks.Objects[Index]).Duration
  else
    TrackDuration := -1;
end;

function TMHCDRIP.TrackSize(Index: integer): LongInt;
begin
  if (Index > -1) and (Index < FTracks.Count) then
    TrackSize := PTrack(FTracks.Objects[Index]).Size
  else
    TrackSize := -1;
end;

function TMHCDRIP.GetTrack(Index: integer): PTrack;
begin
  if (Index > -1) and (Index < FTracks.Count) then
    GetTrack := PTrack(FTracks.Objects[Index])
  else
    GetTrack := nil;
end;

procedure TMHCDRIP.SetActiveCD(Value: LongInt);
var i: Integer;
  S: string;
  L1, L2: Integer; //Int64;
  Toc1, Toc2: TTocEntry;
begin
  if FCDRomNum <> Value then
  try
    if CR_SetActiveCDROM(Value) <> CDEX_ERROR then
      if CR_GetCDROMParameters(FParams) <> CDEX_ERROR then
      begin
        FCDRomName := TCDROMName(FParams.lpszCDROMID);
        FDriveTable.FDTable := FParams.DriveTable;
        FOutputFormat := TOutputFormat(FParams.nOutputFormat);
        FSpeed := FParams.nSpeed;
        FCDRomNum := Value;
      end;
    if CR_ReadTOC <> CDEX_ERROR then
    begin
      FTOCNum := CR_GetNumTocEntries;
      for i := 0 to FTOCNum - 1 do
      begin
        S := 'Track' + LeadingZero2(i + 1);
        L1 := CR_GetTOCEntry(i);
        L2 := CR_GetTOCEntry(i + 1);
        Move(L1, Toc1, 6);
        Move(L2, Toc2, 6);
        FTracks.AddObject(S, {TTrack.Create} DWord(NewTrack));
        PTrack(FTracks.Objects[i]).TrackNum := i + 1;
        PTrack(FTracks.Objects[i]).BegTrack := Toc1.dwStartSector;
        PTrack(FTracks.Objects[i]).EndTrack := Toc2.dwStartSector - 1;
        if Toc1.btFlag = AUDIOTRKFLAG then
          PTrack(FTracks.Objects[i]).Mode := 'Audio'
        else
          PTrack(FTracks.Objects[i]).Mode := 'Data';

      end;
    end;
  except
    ;
//        raise ECDRIPError.Create('Initialization failure');
  end;
end;


procedure TMHCDRIP.SetJitterCorrection(Value: boolean);
begin
  if FJitter <> Value then
  begin
    FJitter := Value;
    FParams.bJitterCorrection := LongBool(Value);
  end;
end;

procedure TMHCDRIP.SetLameFormat;
begin
  if FLameCoder <> nil then
    case FOutputFormat of
      STEREO44100:
        begin
          FLameCoder.Mode := STEREO;
          FLameCoder.SampleRate := 44100;
        end;
      MONO44100:
        begin
          FLameCoder.Mode := MONO;
          FLameCoder.SampleRate := 44100;
        end;
      STEREO22050:
        begin
          FLameCoder.Mode := STEREO;
          FLameCoder.SampleRate := 22050;
        end;
      MONO22050:
        begin
          FLameCoder.Mode := MONO;
          FLameCoder.SampleRate := 22050;
        end;
      STEREO11025:
        begin
          FLameCoder.Mode := STEREO;
          FLameCoder.SampleRate := 11025;
        end;
      MONO11025:
        begin
          FLameCoder.Mode := MONO;
          FLameCoder.SampleRate := 11025;
        end;
    end;
end;

procedure TMHCDRIP.SetOutputFormat(Value: TOutputFormat);
begin
  if FOutputFormat <> Value then
    FParams.nOutputFormat := LongInt(Value);
  FOutputFormat := Value;
  SetLameFormat;
end;

function TMHCDRIP.IsCDROMReady: boolean;
begin
  Result := CR_IsUnitReady;
end;

function TMHCDRIP.SetNewCDROMParams: boolean;
begin
  try
    if CR_SetCDROMParameters(@FParams) <> CDEX_ERROR
      then Result := true else Result := false;
  except
    ;
//        raise ECDRIPError.Create('Error setting parameters');
    Result := false;
  end;
end;

procedure TMHCDRIP.SetLameCoder(Value: PMHLameCoder);
begin
  FLameCoder := Value;
  SetLameFormat;
end;

procedure TMHCDRIP.RipTrack(ATrackNum: LongInt; FileName: string);
var
  Track: PTrack;
begin
  if Assigned(FOnBeginTrack) then FOnBeginTrack(@Self, TrackNum);
  Track := PTrack(FTracks.Objects[TrackNum - 1]);
  RipSectors(Track.BegTrack, Track.EndTrack, FileName);
  if Assigned(FOnEndTrack) then FOnEndTrack(@Self, TrackNum);
end;

procedure TMHCDRIP.RipTrackTime(ATrackNum, BegTime, LengthTime: LongInt; FileName: string);
{BegTime, LengthTime - time in milliseconds }
var
  Track: PTrack;
  Duration, BegSector, EndSector: LongInt;
begin
  Track := PTrack(FTracks.Objects[TrackNum - 1]);
  Duration := Trunc((EndSector - BegSector) / 0.075);
  if (BegTime + LengthTime > Duration) then
    ;
//        raise ECDRIPError.Create('Invalid length');

  BegSector := Track.BegTrack + Trunc(BegTime * 0.075);
  EndSector := BegSector + Trunc(Duration * 0.075);
  if Assigned(FOnBeginTrack) then FOnBeginTrack(@Self, TrackNum);
  RipSectors(BegSector, EndSector, FileName);
  if Assigned(FOnEndTrack) then FOnEndTrack(@Self, TrackNum);
end;

procedure TMHCDRIP.RipSectors(BegSector, EndSector: LongInt; FileName: string);
var
  Buffer, CBuffer, LameInBuffer, LameOutBuffer: pointer;
  BufSize, LameInBufSize: LongInt;
  CDStream: PStream; //TFileStream;
  WaveHeader: TWaveHeader;
  Duration: Real;
  Ch, SR: integer;
  Data: LongInt;
  ERR: CDEX_ERR;
  BytesRipped, BytesEncoded: LongWord;
  StartJitter, EndJitter: LongWord;
  PrComplete: Integer;
  i: integer;
  NumBufs: integer;
  BytesToWrite, BytesWritten: LongWord;

begin
  if not SetNewCDROMParams then
  begin
    ;
//        raise ECDRIPError.Create('Invalid CD-ROM parameters');
    Exit;
  end;

  FCancelRip := false;


  if CR_OpenRipper(@BufSize, BegSector, EndSector) <> CDEX_ERROR then
  begin
    if FEncode then
    begin
      FileName := ChangeFileExt(FileName, '.mp3');
      GetMem(Buffer, BufSize + FLameCoder.NumSamples * 2);
    end else
      GetMem(Buffer, BufSize);

    CDStream := NewFileStream(FileName, ofCreateNew {fmCreate} or ofOpenWrite); //TFileStream.Create(FileName,fmCreate);

    case FOutputFormat of
      STEREO44100:
        begin
          Ch := 2;
          SR := 44100;
        end;
      MONO44100:
        begin
          Ch := 1;
          SR := 44100;
        end;
      STEREO22050:
        begin
          Ch := 2;
          SR := 22050;
        end;
      MONO22050:
        begin
          Ch := 1;
          SR := 22050;
        end;
      STEREO11025:
        begin
          Ch := 2;
          SR := 11025;
        end;
      MONO11025:
        begin
          Ch := 1;
          SR := 11025;
        end;
    end;

    if FWriteWAV and (not FEncode) then
    begin
      Duration := (EndSector - BegSector) / 75;

      Data := Round((Ch * SR * 2 * Duration));

      with WaveHeader do
      begin
        Marker1 := 'RIFF';
        BytesFollowing := Data + 36;
        Marker2 := 'WAVE';
        Marker3 := 'fmt ';
        Fixed1 := 16;
        FormatTag := 1;
        Channels := Ch;
        SampleRate := SR;
        BytesPerSecond := Ch * SR * 2;
        BytesPerSample := Ch * 2;
        BitsPerSample := 16;
        Marker4 := 'data';
        DataBytes := Data;
      end;
      CDStream.Write(WaveHeader, SizeOf(WaveHeader));
    end;

    if FEncode and (FLameCoder <> nil) then
    begin
      FLameCoder.PrepareCoder;
      GetMem(LameOutBuffer, FLameCoder.BufSize);
      LameInBufSize := FLameCoder.NumSamples * Ch;
      GetMem(LameInBuffer, LameInBufSize);
    end;

    BytesToWrite := 0;
    try
      repeat

        if FCancelRip then
        begin
          if FEncode and (FLameCoder <> nil) then
            CDStream.Write(LameOutBuffer^, BytesEncoded);
          Break;
        end;

        ERR := CR_RipChunk(PChar(Buffer) + BytesToWrite, BytesRipped);

        if ERR <> CDEX_ERROR then
        begin
{Onfly encoding }
          if FEncode and (FLameCoder <> nil) then
          begin
            BytesRipped := BytesRipped + BytesToWrite;
            NumBufs := BytesRipped div LameInBufSize;
            CBuffer := Buffer;

            for i := 1 to NumBufs do
            begin
              BytesToWrite := LameInBufSize;
              Move(CBuffer^, LameInBuffer^, BytesToWrite);
              PChar(CBuffer) := PChar(CBuffer) + BytesToWrite;
              FLameCoder.EncodeBuffer(LameInBuffer, LameOutBuffer, BytesEncoded);
              BytesWritten := CDStream.Write(LameOutBuffer^, BytesEncoded);
              if BytesWritten <> BytesEncoded then
                ;
//                           raise ECDRIPError.Create('Write error');

            end;

            BytesToWrite := BytesRipped - NumBufs * LameInBufSize;
            if BytesToWrite > 0 then

              Move(CBuffer^, Buffer^, BytesToWrite);

          end;

{No encoding}
          if not FEncode then
          begin
            BytesWritten := CDStream.Write(Buffer^, BytesRipped);
            if BytesWritten <> BytesRipped then
              ;
//                       raise ECDRIPError.Create('Write error');
          end;

        end;

        if ERR = CDEX_JITTER_ERROR then
        begin
          CR_GetLastJitterErrorPosition(StartJitter, EndJitter);
          FJitters.Add(Int2Str(StartJitter) + ' ' + Int2Str(EndJitter));
        end;

        PrComplete := CR_GetPercentCompleted;
        if Assigned(FOnProgress) then FOnProgress(@Self, PrComplete);
        Applet.ProcessMessages;
//             Application.ProcessMessages;

      until ERR = CDEX_RIPPING_DONE;

    finally

      if FEncode and (FLameCoder <> nil) then
      begin
        FLameCoder.UnPrepareCoder(LameOutBuffer, BytesEncoded);
        BytesWritten := CDStream.Write(LameOutBuffer^, BytesEncoded);
        if BytesWritten <> BytesEncoded then
          ;
//              raise ECDRIPError.Create('Write error');
        FLameCoder.CloseCoder;
      end;

      FJittersNum := CR_GetNumberOfJitterErrors;
      CR_CloseRipper;
      FreeMem(Buffer);
      CDStream.Free;
    end;
    if FJitters.Count <> 0 then FJitters.SaveToFile(ChangeFileExt(FileName, 'jitt'));
  end;
end;

procedure TMHCDRIP.CancelRip;
begin
  FCancelRip := true;
end;

function NewDriveTableClass: PDriveTableClass;
begin
  New(Result, Create);
end;

function NewTrack: PTrack;
begin
  New(Result, Create);
end;


end.

