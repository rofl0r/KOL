unit KOLMHLameCoder;
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
  Windows, { Messages, SysUtils } { , Classes } { Graphics, Controls, Forms, Dialogs,}
  Lame_dll;

type

//  ELameError = object(Exception);
//PLameError=^ELameError; type  MyStupid0=DWord;

  TLameVersion = object(TObj)
  private
    FBeV: TBeVersion;
  public
     { constructor Create;
     } procedure Assign(Source: {TPersistent} PObj); // override;
   { published }
    property DLLMajorVersion: byte read FBEV.byDLLMajorVersion write FBEV.byDLLMajorVersion;
    property DLLMinorVersion: byte read FBEV.byDLLMinorVersion write FBEV.byDLLMinorVersion;
    property MajorVersion: byte read FBEV.byMajorVersion write FBEV.byMajorVersion;
    property MinorVersion: byte read FBEV.byMinorVersion write FBEV.byMinorVersion;
  end;
  PLameVersion = ^TLameVersion;

function NewLameVersion: PLameVersion;

type
  TLameMode = (STEREO, JSTEREO, DUALCHANNEL, MONO);

type
  TProgressEvent = procedure(Sender: PObj; PercentComplete: Word) of object;
  TProcessFileEvent = procedure(Sender: PObj; Num: Word; FileName: string) of object;

type
  TWaveHeader = record
    Marker1: array[0..3] of Char;
    BytesFollowing: LongInt;
    Marker2: array[0..3] of Char;
    Marker3: array[0..3] of Char;
    Fixed1: LongInt;
    FormatTag: Word;
    Channels: Word;
    SampleRate: LongInt;
    BytesPerSecond: LongInt;
    BytesPerSample: Word;
    BitsPerSample: Word;
    Marker4: array[0..3] of Char;
    DataBytes: LongInt;
  end;


type
  PMHLameCoder=^TMHLameCoder;
  TKOLMHLameCoder=PMHLameCoder;
  TMHLameCoder = object(TObj)
  private
    { Private declarations }
    FSampleRate: DWORD;
    FReSampleRate: DWORD;
    FMode: INTEGER;
    FBitrate: DWORD;
    FMaxBitrate: DWORD;
    FQuality: MPEG_QUALITY;
    FMpegVersion: DWORD;
    FPsyModel: DWORD;
    FEmphasis: DWORD;
    FPrivate: BOOL;
    FCRC: BOOL;
    FCopyright: BOOL;
    FOriginal: BOOL;
    FWriteVBRHeader: BOOL;
    FEnableVBR: BOOL;
    FVBRQuality: integer;
    FInputFiles: PStrList;
    FOutputFiles: PStrList;
    FLameVersion: PLameVersion; //TLameVersion;
    FDefaultExt: string;
    FFileName: string;
    FBeConfig: TBeConfig;
    FHBeStream: THBeStream;
    FNumSamples: DWORD;
    FBufSize: DWORD;
    FInputBuf: pointer;
    FOutputBuf: pointer;
    FMP3File: PStream; //TFileStream;
    FWAVFile: PStream; //TFileStream;
    FOnBeginProcess: TOnEvent; //TNotifyEvent;
    FOnBeginFile: TProcessFileEvent;
    FOnEndFile: TProcessFileEvent;
    FOnEndProcess: TOnEvent; //TNotifyEvent;
    FOnProgress: TProgressEvent;
    FCancelProcess: Boolean;
    FWave: TWaveHeader;
    procedure SetSampleRate(Value: DWORD);
    procedure SetBitrate(Value: DWORD);
    procedure SetEnableVBR(Value: BOOL);
    function GetLameVersion: PLameVersion; //TLameVersion;
    procedure SetInputFiles(Value: PStrList);
    procedure SetOutputFiles(Value: PStrList);
    procedure SetMode(Value: TLameMode);
    function GetMode: TLameMode;
  protected
    { Protected declarations }
  public
    { Public declarations }
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; virtual;
    procedure Assign(Source: PObj {TPersistent}); // override;
    procedure ProcessFiles;
    function PrepareCoder: TBEERR;
    function UnPrepareCoder(Buf: pointer; var dwWrite: DWORD): TBEERR;
    procedure CloseCoder;
    procedure CancelProcess;
    function EncodeBuffer(InBuf: pointer; OutBuf: pointer; var OutP: DWORD): TBEERR;
    property NumSamples: DWORD read FNumSamples default 0;
    property BufSize: DWORD read FBufSize default 0;
   { published }
    { Published declarations }
    property SampleRate: DWORD read FSampleRate write SetSampleRate default 44100;
    property Bitrate: DWORD read FBitrate write SetBitrate default 128;
    property MaxBitrate: DWORD read FMaxBitrate write FMaxBitrate default 320;
    property Quality: MPEG_QUALITY read FQuality write FQuality default NORMAL_QUALITY;
    property Private: BOOL read FPrivate write FPrivate default false;
    property CRC: BOOL read FCRC write FCRC default true;
    property Mode: TLameMode read GetMode write SetMode default STEREO;
    property Copyright: BOOL read FCopyright write FCopyright default false;
    property Original: BOOL read FOriginal write FOriginal default false;
    property WriteVBRHeader: BOOL read FWriteVBRHeader write FWriteVBRHeader default false;
    property EnableVBR: BOOL read FEnableVBR write SetEnableVBR default false;
    property VBRQuality: integer read FVBRQuality write FVBRQuality default 4;
    property InputFiles: PStrList read FInputFiles write SetInputFiles;
    property OutputFiles: PStrList read FOutputFiles write SetOutputFiles;
    property LameVersion: PLameVersion {TLameVersion} read GetLameVersion;
    property DefaultExt: string read FDefaultExt write FDefaultExt;
    property Mp3FileName: string read FFileName write FFileName;
    property OnBeginProcess: TOnEvent {TNotifyEvent} read FOnBeginProcess write FOnBeginProcess;
    property OnBeginFile: TProcessFileEvent read FOnBeginFile write FOnBeginFile;
    property OnEndFile: TProcessFileEvent read FOnEndFile write FOnEndFile;
    property OnEndProcess: TOnEvent {TNotifyEvent} read FOnEndProcess write FOnEndProcess;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
  end;
function NewMHLameCoder(AOwner: PControl {TComponent}): PMHLameCoder; type MyStupid86104 = DWord;

type
  TLameStream = object(TObj) //TFileStream)
  private
    FLameCoder: PMHLameCoder;
    FOutBuf: pointer;
    FInSide: PStream;
  protected
    procedure SetLameCoder(Value: PMHLameCoder);
  public
      { constructor Create(const FileName: string; Mode: Word);
      }
    function Write(const Buffer; Count: Longint): Longint; // override;
    function Read(var Buffer; Count: Longint): Longint; // override;
    destructor Destroy;
      virtual;

    property LameCoder: PMHLameCoder read FLameCoder write SetLameCoder;

  end;
  PLameStream = ^TLameStream;
function NewLameStream(const FileName: string; Mode: Word): PLameStream; type MyStupid20258 = DWord;

//procedure Register;
{$R LameCoder.res}
implementation

var Err: TBeErr;
  FileLength,
    Done,
    dwWrite,
    toRead,
    isRead,
    toWrite,
    IsWritten: DWORD;
  FWAVFileName,
    FMp3FileName: string;
  PrcntComplete: Word;


//constructor TLameVersion.Create;

function NewLameVersion: PLameVersion;
begin
  New(Result, Create);
  with Result^ do
  begin
//     inherited Create;
    beVersion(FBEV);
  end;
end;

procedure TLameVersion.Assign(Source: PObj {TPersistent});
begin
//     if Source is TLameVersion then
  begin
    FBEV.byDLLMajorVersion := PLameVersion(Source).FBEV.byDLLMajorVersion;
    FBEV.byDLLMinorVersion := PLameVersion(Source).FBEV.byDLLMinorVersion;
    FBEV.byMajorVersion := PLameVersion(Source).FBEV.byMajorVersion;
    FBEV.byMinorVersion := PLameVersion(Source).FBEV.byMinorVersion;
    exit;
  end;
//     inherited Assign(Source);
end;

function NewMHLameCoder(AOwner: PControl {TComponent}): PMHLameCoder;
//constructor TLameCoder.Create (AOwner : TComponent);
begin
  New(Result, Create);
  with Result^ do
  begin
//     inherited Create(AOwner);
    FSampleRate := 44100;
    FBitRate := 128;
    FMaxBitRate := 320;
    FQuality := NORMAL_QUALITY;
    FCRC := true;
    FVBRQuality := 4;
    FInputFiles := NewStrList; //TStringList.Create;
    FOutputFiles := NewStrList; //TStringList.Create;
    FLameVersion := NewLameVersion; //TLameVersion.Create;
    FDefaultExt := '.mp3';
  end;
end;

destructor TMHLameCoder.Destroy;
begin
  FInputFiles.Free;
  FOutputFiles.Free;
  FLameVersion.Free;
  inherited Destroy;
end;

procedure TMHLameCoder.Assign(Source: PObj { TPersistent});
begin
//     if Source is TLameCoder then
  begin
    FSampleRate := PMHLameCoder(Source).FSampleRate;
    FReSampleRate := PMHLameCoder(Source).FReSampleRate;
    FMode := PMHLameCoder(Source).FMode;
    FBitrate := PMHLameCoder(Source).FBitrate;
    FMaxBitrate := PMHLameCoder(Source).FMaxBitrate;
    FQuality := PMHLameCoder(Source).FQuality;
    FMpegVersion := PMHLameCoder(Source).FMpegVersion;
    FPsyModel := PMHLameCoder(Source).FPsyModel;
    FEmphasis := PMHLameCoder(Source).FEmphasis;
    FPrivate := PMHLameCoder(Source).FPrivate;
    FCRC := PMHLameCoder(Source).FCRC;
    FCopyright := PMHLameCoder(Source).FCopyright;
    FOriginal := PMHLameCoder(Source).FOriginal;
    FWriteVBRHeader := PMHLameCoder(Source).FWriteVBRHeader;
    FEnableVBR := PMHLameCoder(Source).FEnableVBR;
    FVBRQuality := PMHLameCoder(Source).FVBRQuality;
    Exit;
  end;
//      inherited Assign(Source);
end;

procedure TMHLameCoder.SetSampleRate(Value: DWORD);
begin
  FSampleRate := Value;
end;

procedure TMHLameCoder.SetBitrate(Value: DWORD);
begin
  FBitrate := Value;
end;

procedure TMHLameCoder.SetEnableVBR(Value: BOOL);
begin
  FEnableVBR := Value;
  FWriteVBRHeader := Value;
end;

function TMHLameCoder.GetLameVersion: PLameVersion; //TLameVersion;
begin
  Result := FLameVersion;
end;

procedure TMHLameCoder.SetInputFiles(Value: PStrList);
var i: integer;
begin
  with FInputFiles^ do
  begin
    Assign(Value);
    FOutputFiles.Clear;
    for i := 0 to Count - 1 do
      FOutputFiles.Add(ChangeFileExt(Items {Strings} [i], FDefaultExt));
  end;
end;

procedure TMHLameCoder.SetOutputFiles(Value: PStrList);
begin
  FOutputFiles.Assign(Value);
end;

procedure TMHLameCoder.SetMode(Value: TLameMode);
begin
  case Value of
    STEREO: FMode := BE_MP3_MODE_STEREO;
    JSTEREO: FMode := BE_MP3_MODE_JSTEREO;
    DUALCHANNEL: FMode := BE_MP3_MODE_DUALCHANNEL;
    MONO: FMode := BE_MP3_MODE_MONO;
  end;
end;

function TMHLameCoder.GetMode: TLameMode;
begin
  case FMode of
    BE_MP3_MODE_STEREO: Result := STEREO;
    BE_MP3_MODE_JSTEREO: Result := JSTEREO;
    BE_MP3_MODE_DUALCHANNEL: Result := DUALCHANNEL;
    BE_MP3_MODE_MONO: Result := MONO;
  end;
end;

function TMHLameCoder.PrepareCoder: TBEERR;
begin

  FBeConfig.Format.dwConfig := BE_CONFIG_LAME;
  with FBeConfig.Format.LHV1 do begin
    dwStructVersion := 1;
    dwStructSize := SizeOf(FBeConfig);
    dwSampleRate := FSampleRate;
    dwReSampleRate := 0;
    nMode := FMode;
    dwBitrate := FBitrate;
    dwMaxBitrate := FMaxBitrate;
    nQuality := DWORD(FQuality);
    dwMpegVersion := MPEG1;
    dwPsyModel := 0;
    dwEmphasis := 0;
    bPrivate := FPrivate;
    bCRC := FCRC;
    bCopyright := FCopyright;
    bOriginal := FOriginal;
    bWriteVBRHeader := FWriteVBRHeader;
    bEnableVBR := FEnableVBR;
    nVBRQuality := FVBRQuality;
  end;
  Err := BeInitStream(FBeConfig, FNumSamples, FBufSize, FHBeStream);
  if Err <> BE_ERR_SUCCESSFUL then begin
    Result := Err;
    Exit;
  end;

  GetMem(FOutputBuf, FBufSize);
  Result := Err;
end;

function TMHLameCoder.UnprepareCoder(Buf: pointer; var dwWrite: DWORD): TBEERR;
begin
  Result := beDeinitStream(FHBeStream, Buf, dwWrite);
end;

procedure TMHLameCoder.CloseCoder;
begin
  FreeMem(FOutputBuf);
  beCloseStream(FHBeStream);
end;

procedure TMHLameCoder.ProcessFiles;

  procedure CleanUp;
  begin
    FreeMem(FInputBuf);
    FWAVFile.Free;
    FMp3File.Free;
  end;

var
  FNum: integer;
  InputBufSize: Word;
begin
  FCancelProcess := false;
  if Assigned(FOnBeginProcess) then FOnBeginProcess(@Self);

  for FNum := 0 to FInputFiles.Count - 1 do begin
    PrepareCoder;

    if Assigned(FOnBeginFile) then FOnBeginFile(@Self, FNum, FInputFiles.Items[FNum]);

    FWAVFileName := FInputFiles.Items[FNum];
    FMp3FileName := FOutputFiles.Items[FNum];

    FWAVFile := NewFileStream(FWAVFileName, ofOpenRead);
//     TFileStream.Create(FWAVFileName,fmOpenRead);
    FMp3File := NewFileStream(FMp3FileName, ofCreateNew or ofShareDenyNone or ofOpenWrite); //TFileStream.Create(FMp3FileName,fmCreate or fmShareDenyNone);

    FWAVFile.Read(FWave, SizeOf(TWaveHeader));


    if FWave.Marker2 = 'WAVE' then begin
      InputBufSize := FNumSamples * FWave.BytesPerSample;
      FileLength := FWAVFile.Size - SizeOf(TWaveHeader);
    end
    else begin
      if FMode = BE_MP3_MODE_MONO then InputBufSize := FNumSamples else
        InputBufSize := FNumSamples * 2;
      FileLength := FWAVFile.Size;
      FWAVFile.Seek(0, spBegin {soFromBeginning});
    end;

    GetMem(FInputBuf, InputBufSize);


    Done := 0;

    while Done <> FileLength do begin
      if (Done + (InputBufSize) < FileLength) then
        toRead := InputBufSize
      else
        toRead := FileLength - Done;

      isRead := FWAVFile.Read(FInputBuf^, toRead);
      if isRead <> toRead then begin
        Cleanup;
        CloseCoder;
//        raise ELameError.Create('Read Error');
        Exit;
      end;

      Err := beEncodeChunk(FHBeStream, (toRead div 2), FInputBuf, FOutputBuf, toWrite);
      if Err <> BE_ERR_SUCCESSFUL then begin
        CleanUp;
        CloseCoder;
//        raise ELameError.Create('beEncodeChunk failed '+IntToStr(Err));
        Exit;
      end;

      IsWritten := FMp3File.Write(FOutputBuf^, toWrite);
      if toWrite <> IsWritten then begin
        Cleanup;
        CloseCoder;
//        raise ELameError.Create('Write Error');
        Exit;
      end;

      Done := Done + toRead;
      PrcntComplete := Trunc((Done / FileLength) * 100);
      if Assigned(FOnProgress) then FOnProgress(@Self, PrcntComplete);
      Applet.ProcessMessages;
//     Application.ProcessMessages;

      if FCancelProcess then begin
        Cleanup;
        CloseCoder;
        Exit;
      end;
    end; {while}

    UnprepareCoder(FOutputBuf, dwWrite);

    IsWritten := FMp3File.Write(FOutputBuf^, dwWrite);

    if dwWrite <> IsWritten then begin
      CleanUp;
      CloseCoder;
//      raise ELameError.Create('Write error');
      Exit;
    end;

    CleanUp;
    CloseCoder;
    if Assigned(FOnEndFile) then FOnEndFile(@Self, FNum, FOutputFiles.Items[FNum]);
  end; {for}

  if Assigned(FOnEndProcess) then FOnEndProcess(@Self);

end;

procedure TMHLameCoder.CancelProcess;
begin
  FCancelProcess := true;
end;

function TMHLameCoder.EncodeBuffer(InBuf: pointer; OutBuf: pointer; var OutP: DWORD): TBEERR;
begin
  Result := beEncodeChunk(FHBeStream, FNumSamples, InBuf, OutBuf, OutP);
end;

function NewLameStream(const FileName: string; Mode: Word): PLameStream;
//constructor TLameStream.Create(const FileName: string; Mode: Word);
begin
  New(Result, Create);
  with Result^ do
  begin
    FLameCoder := NewMHLameCoder(Applet); //TMHLameCoder.Create(Application);
//     inherited Create(FileName,fmCreate or fmShareDenyNone);
    FInSide := NewFileStream(FileName, ofCreateNew or ofShareDenyNone or ofOpenWrite);
    FLameCoder.PrepareCoder;
    GetMem(FOutBuf, FLameCoder.BufSize);
  end;
end;

destructor TLameStream.Destroy;
var FCount: DWORD;
begin
  FLameCoder.UnprepareCoder(FOutBuf, FCount);
{     inherited} FInSide.Write(FOutBuf^, FCount);
  FLameCoder.CloseCoder;
  FLameCoder.Free;
  FreeMem(FOutBuf);
  inherited Destroy;
end;

function TLameStream.Write(const Buffer; Count: Longint): Longint;
var FCount: DWORD;
begin
  if FLameCoder.EncodeBuffer(pointer(Buffer), FOutBuf, FCount) = BE_ERR_SUCCESSFUL then
    Result := { inherited } FInSide.Write(FOutBuf^, FCount)
  else
    Result := 0;
end;

function TLameStream.Read(var Buffer; Count: Longint): Longint;
begin
  ; //     raise EStreamError.Create('Read from stream not supported');
end;

procedure TLameStream.SeTLameCoder(Value: PMHLameCoder);
begin
  FLameCoder.CloseCoder;
  FLameCoder.Assign(Value);
  FLameCoder.PrepareCoder;
end;

{procedure Register;
begin
  RegisterComponents('Lame', [TMHLameCoder]);
end;}

end.

