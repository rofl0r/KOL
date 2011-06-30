{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}

Unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLBAPFileBrowser, KOLBAPDriveBox {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckBAPFileBrowser, mckCtrls, Graphics,
  mckBAPDriveBox {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TMainForm = class; PMainForm = TMainForm; {$ELSE OBJECTS} PMainForm = ^TMainForm; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TMainForm.inc}{$ELSE} TMainForm = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMainForm = class(TForm)
  {$ENDIF KOL_MCK}
    BAPFileBrowser: TKOLBAPFileBrowser;
    GroupBox1: TKOLGroupBox;
    TagExistsLabel: TKOLLabel;
    TitleLabel: TKOLLabel;
    ArtisTKolLabel: TKOLLabel;
    AlbumLabel: TKOLLabel;
    TrackLabel: TKOLLabel;
    YearLabel: TKOLLabel;
    GenreLabel: TKOLLabel;
    CommenTKolLabel: TKOLLabel;
    ComposerLabel: TKOLLabel;
    CopyrighTKolLabel: TKOLLabel;
    EncoderLabel: TKOLLabel;
    LanguageLabel: TKOLLabel;
    LinkLabel: TKOLLabel;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    Label3: TKOLLabel;
    Label4: TKOLLabel;
    Label5: TKOLLabel;
    Label6: TKOLLabel;
    Label7: TKOLLabel;
    Label8: TKOLLabel;
    Label9: TKOLLabel;

    TitleEdit: TKOLEditBox;
    ArtisEdit: TKOLEditBox;
    AlbumEdit: TKOLEditBox;
    TrackEdit: TKOLEditBox;
    YearEdit: TKOLEditBox;
    GenreEdit: TKOLEditBox;
    CommenEdit: TKOLEditBox;
    ComposerEdit: TKOLEditBox;
    EncoderEdit: TKOLEditBox;
    CopyrighEdit: TKOLEditBox;
    LanguageEdit: TKOLEditBox;
    LinkEdit: TKOLEditBox;
    GroupBox2: TKOLGroupBox;
    TitleEdit2: TKOLEditBox;
    ArtisEdit2: TKOLEditBox;
    AlbumEdit2: TKOLEditBox;
    TrackEdit2: TKOLEditBox;
    YearEdit2: TKOLEditBox;
    CommenEdit2: TKOLEditBox;
    GenreComboBox2: TKOLComboBox;
    TagVersionLabel: TKOLLabel;
    TagVersionValue2: TKOLEditBox;
    TagVersionValue: TKOLEditBox;
    TagExists: TKOLCheckBox;
    TagExists2: TKOLCheckBox;
    mFormatInfo: TKOLMemo;
    KOLProject: TKOLProject;
    KOLForm: TKOLForm;
    btnSave: TKOLButton;
    BAPDriveBox1: TKOLBAPDriveBox;
    Label10: TKOLLabel;
    procedure BAPFileBrowserSelFile(Sender: PControl; FileName: String;
      const Dir: Boolean; Attr: PWin32FindDataA);
    procedure KOLFormFormCreate(Sender: PObj);
    procedure btnSaveClick(Sender: PObj);
    procedure BAPDriveBox1ChangeDrive(Sender: PControl; Drive: String;
      const ReadErr: Boolean; var Retry: Boolean);
  private
    FFileName, FTagType: String;
    procedure LoadFile(const FileName: String;
                       var Track_1, Track_2, Genre_1: Integer;
                       var Exists_1, Exists_2: Boolean;
                       var FormatInfo, TagType, VersionID_1, VersionID_2,
                           Title_1, Artist_1, Album_1, Year_1, Comment_1,
                           Title_2, Artist_2, Album_2, Year_2, Genre_2, Comment_2, Composer_2, Encoder_2, Copyright_2, Language_2, Link_2: String);
    procedure SaveFile(const FileName: String;
                       Track_1, Track_2, Genre_1: Integer;
                       Exists_1, Exists_2: Boolean;
                       TagType, Title_1, Artist_1, Album_1, Year_1, Comment_1,
                       Version_2, Title_2, Artist_2, Album_2, Year_2, Genre_2, Comment_2, Composer_2, Encoder_2, Copyright_2, Language_2, Link_2: String);
    procedure Clear;
  public
    { Public declarations }
  end;

var
  MainForm {$IFDEF KOL_MCK} : PMainForm {$ELSE} : TMainForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMainForm( var Result: PMainForm; AParent: PControl );
{$ENDIF}

implementation

uses MPEGaudio, ID3v1, ID3v2, WMA, WAV, FLAC, CDAtrack, Monkey, APE, TwinVQ, AAC, MPEGplus, OggVorbis;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Main_1.inc}
{$ENDIF}

procedure TMainForm.LoadFile(const FileName: String;
                   var Track_1, Track_2, Genre_1: Integer;
                   var Exists_1, Exists_2: Boolean;
                   var FormatInfo, TagType, VersionID_1, VersionID_2,
                       Title_1, Artist_1, Album_1, Year_1, Comment_1,
                       Title_2, Artist_2, Album_2, Year_2, Genre_2, Comment_2, Composer_2, Encoder_2, Copyright_2, Language_2, Link_2: String);
procedure ReadID3v1(ID3v1: PID3v1);
begin
    Exists_1:= ID3v1.Exists;
    if Exists_1 then begin
      VersionID_1:= Int2Str(ID3v1.VersionID);
      Title_1:= ID3v1.Title;
      Artist_1:= ID3v1.Artist;
      Album_1:= ID3v1.Album;
      Track_1:= ID3v1.Track;
      Year_1:= ID3v1.Year;
      if ID3v1.GenreID < MAX_MUSIC_GENRES then Genre_1:= ID3v1.GenreID;
      Comment_1:= ID3v1.Comment;
    end;
end;
procedure ReadID3v2(ID3v2: PID3v2);
begin
    Exists_2:= ID3v2.Exists;
    if Exists_2 then begin
      VersionID_2:= Int2Str(ID3v2.VersionID);
      Title_2:= ID3v2.Title;
      Artist_2:= ID3v2.Artist;
      Album_2:= ID3v2.Album;
      Track_2:= ID3v2.Track;
      Year_2:= ID3v2.Year;
      Genre_2:= ID3v2.Genre;
      Comment_2:= ID3v2.Comment;
      Composer_2:= ID3v2.Composer;
      Encoder_2:= ID3v2.Encoder;
      Copyright_2:= ID3v2.Copyright;
      Language_2:= ID3v2.Language;
      Link_2:= ID3v2.Link;
    end;
end;
procedure ReadAPE(APE: PAPE);
begin
    VersionID_2:= Int2Str(APE.Version);
    Exists_2:= APE.Exists;
    if Exists_2 then begin
      Title_2:= APE.Title;
      Artist_2:= APE.Artist;
      Album_2:= APE.Album;
      Track_2:= APE.Track;
      Year_2:= APE.Year;
      Genre_2:= APE.Genre;
      Comment_2:= APE.Comment;
      Copyright_2:= APE.Copyright;
    end;
end;

var MPEGaudio: PMPEGaudio;
    WMA: PWMA;
    WAV: PWAV;
    FLAC: PFLAC;
    CDAtrack: PCDAtrack;
    Monkey: PMonkey;
    TwinVQ: PTwinVQ;
    AAC: PAAC;
    MPEGplus: PMPEGplus;
    OggVorbis: POggVorbis;
begin
    MPEGaudio:= NewMPEGaudio;
    WMA:= NewWMA;
    WAV:= NewWAV;
    FLAC:= NewFLAC;
    CDAtrack:= NewCDAtrack;
    Monkey:= NewMonkey;
    TwinVQ:= NewTwinVQ;
    AAC:= NewAAC;
    MPEGplus:= NewMPEGplus;
    OggVorbis:= NewOggVorbis;
    TagType:= '';
    try
      FormatInfo:= '';
      Title_1:= ''; Artist_1:= ''; Album_1:= ''; Track_1:= -1; Year_1:= ''; Genre_1:= 12; Comment_1:= '';
      Title_2:= ''; Artist_2:= ''; Album_2:= ''; Track_2:= 0; Year_2:= ''; Genre_2:= ''; Comment_2:= '';
      Exists_1:= False; Exists_2:= False;

      if OggVorbis.ReadFromFile(FileName) and OggVorbis.Valid then begin
        TagType:= 'OggVorbis';
        FormatInfo:= OggVorbis.Vendor+#13#10;
        FormatInfo:= FormatInfo + Int2Str(OggVorbis.SampleRate) + ' hz; '+Int2Str(OggVorbis.BitRate) + ' kbit/s; ' + OggVorbis.ChannelMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+Int2Str(Round(OggVorbis.Duration)) + ' c';

        Exists_2:= True;
        Title_2:= OggVorbis.Title;
        Artist_2:= OggVorbis.Artist;
        Album_2:= OggVorbis.Album;
        Track_2:= OggVorbis.Track;
        Year_2:= OggVorbis.Date;
        Genre_2:= OggVorbis.Genre;
        Comment_2:= OggVorbis.Comment;
        Exit;
      end;

      if MPEGplus.ReadFromFile(FileName) and MPEGplus.Valid then begin
        TagType:= 'MPEGplus';
        FormatInfo:= MPEGplus.Profile+' ' +Int2Str(MPEGplus.BitRate) + ' kbit/s; '+MPEGplus.ChannelMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+Int2Str(Round(MPEGplus.Duration)) + ' c';

        ReadID3v1(MPEGplus.ID3v1);
        ReadID3v2(MPEGplus.ID3v2);
        ReadAPE(MPEGplus.APEtag);
        Exit;
      end;

      if AAC.ReadFromFile(FileName) and AAC.Valid then begin
        TagType:= 'AAC';
        FormatInfo:= 'MPEG Version ' + AAC.MPEGVersion + ' Header ' + AAC.HeaderType + ' Profile '  + AAC.Profile+#13#10;
        FormatInfo:= FormatInfo + Int2Str(AAC.SampleRate) + ' hz; '+ AAC.BitRateType + ' ' +Int2Str(AAC.BitRate) + ' bit/s; Channels: '+Int2Str(AAC.Channels)+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+Int2Str(Round(AAC.Duration)) + ' c';
        ReadID3v1(AAC.ID3v1);
        ReadID3v2(AAC.ID3v2);
        Exit;
      end;

      if TwinVQ.ReadFromFile(FileName) and TwinVQ.Valid then begin
        TagType:= 'TwinVQ';
        FormatInfo:= Int2Str(TwinVQ.SampleRate) + ' hz; '+ Int2Str(TwinVQ.BitRate) + ' kbit/s; ' + TwinVQ.ChannelMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+ Double2Str(TwinVQ.Duration) + ' с.'+#13#10;
        FormatInfo:= FormatInfo + 'FileLength: '+ Int2Str(TwinVQ.FileSize) + ' bytes'+#13#10;
        Exists_2:= TwinVQ.Exists;
        Title_2:= TwinVQ.Title;
        Artist_2:= TwinVQ.Author;
        Album_2:= TwinVQ.Album;
        Comment_2:= TwinVQ.Comment;
        Copyright_2:= TwinVQ.Copyright;
        Composer_2:= TwinVQ.OriginalFile;
        Exit;
      end;

      if Monkey.ReadFromFile(FileName) and Monkey.Valid then begin
        TagType:= 'Monkey';
        FormatInfo:= Monkey.Header.ID+' '+Monkey.Version +'; '+ Int2Str(Monkey.Bits) + ' bit; ' + Monkey.ChannelMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+ Double2Str(Monkey.Duration) + ' с.'+#13#10;
        FormatInfo:= FormatInfo + 'FileLength: '+ Int2Str(Monkey.FileLength) + ' bytes'+#13#10;
        FormatInfo:= FormatInfo + 'Compression: '+ Double2Str(Monkey.Ratio) + ' %; '+Monkey.Compression +#13#10;
        FormatInfo:= FormatInfo + 'Samples: '+ Int2Str(Monkey.Samples) + '; Peak: '+ Double2Str(Monkey.Peak) +#13#10;
        ReadAPE(Monkey.APEtag);
        Exit;
      end;

      if CDAtrack.ReadFromFile(FileName) and CDAtrack.Valid then begin
        TagType:= 'CDAtrack';
        Title_2:= CDAtrack.Title;
        Artist_2:= CDAtrack.Artist;
        Album_2:= CDAtrack.Album;
        FormatInfo:= 'Track: '+ UInt2Str(CDAtrack.Track) + #13#10;
        FormatInfo:= FormatInfo+'Продолжительность: '+ Double2Str(CDAtrack.Duration) + ' с.'+#13#10;
        FormatInfo:= FormatInfo+'Position: '+ Double2Str(CDAtrack.Position) + ' с.'+#13#10;
        Exit;
      end;

      if WAV.ReadFromFile(FileName) and WAV.Valid then begin
        TagType:= 'WAV';
        FormatInfo:= WAV.Format+'; '+Int2Str(WAV.SampleRate) + ' hz; BitsPerSample: '+Int2Str(WAV.BitsPerSample) + ' bit; ' + WAV.ChannelMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+ Double2Str(WAV.Duration) + ' с.'+#13#10;
        FormatInfo:= FormatInfo + 'BytesPerSecond: '+Int2Str(WAV.BytesPerSecond) + ' bytes'+#13#10;
        FormatInfo:= FormatInfo + 'BlockAlign: '+Int2Str(WAV.BlockAlign) + ' bytes; HeaderSize: '+Int2Str(WAV.HeaderSize) + ' bytes; FileSize: '+Int2Str(WAV.FileSize) + ' bytes'+#13#10;
        Exit;
      end;

      if FLAC.ReadFromFile(FileName) and FLAC.Valid then begin
        TagType:= 'FLAC';
        FormatInfo:= Int2Str(FLAC.SampleRate) + ' hz; BitsPerSample: '+ Int2Str(FLAC.BitsPerSample) + ' bit; Channels: ' + Int2Str(FLAC.Channels)+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+ Double2Str(FLAC.Duration) + ' с.'+#13#10;
        FormatInfo:= FormatInfo + 'FileLength: '+ Int2Str(FLAC.FileLength) + ' bytes'+#13#10;
        FormatInfo:= FormatInfo + 'Compression: '+ Double2Str(FLAC.Ratio) + ' %'+#13#10;
        FormatInfo:= FormatInfo + 'TotalSamples: '+ Int2Str(FLAC.Samples) + ' '+#13#10;
        Title_2:= ''; Artist_2:= ''; Album_2:= ''; Track_2:= 0; Year_2:= ''; Genre_2:= ''; Comment_2:= '';
        VersionID_2:= FLAC.Vendor;
        Exists_2:= FLAC.Exists;
        if Exists_2 then begin
          Title_2:= FLAC.Title;
          Artist_2:= FLAC.Artist;
          Album_2:= FLAC.Album;
          Track_2:= Str2Int(FLAC.Track);
          Year_2:= FLAC.Year;
          Genre_2:= FLAC.Genre;
          Comment_2:= FLAC.Comment;
          Copyright_2:= FLAC.Copyright;
        end;
        Exit;
      end;

      if MPEGaudio.ReadFromFile(FileName) and MPEGaudio.Valid then begin
        TagType:= 'MP3';
        FormatInfo:= 'MPEG Version ' + MPEGaudio.Version + ' Layer ' + MPEGaudio.Layer+#13#10;
        FormatInfo:= FormatInfo + Int2Str(MPEGaudio.SampleRate) + ' hz; ';
        if MPEGaudio.VBR.Found then FormatInfo:= FormatInfo + 'VBR ' + Int2Str(MPEGaudio.BitRate) + ' kbit/s; '
        else FormatInfo:= FormatInfo + 'CBR ' + Int2Str(MPEGaudio.BitRate) + ' kbit/s; ';
        FormatInfo:= FormatInfo + MPEGaudio.ChannelMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+Int2Str(Round(MPEGaudio.Duration)) + ' c';
        ReadID3v1(MPEGaudio.ID3v1);
        ReadID3v2(MPEGaudio.ID3v2);
        Exit;
      end;

      if WMA.LoadFromFile(FileName) then begin
        TagType:= 'WMA';

        FormatInfo:= 'WMFSDKVersion :'+WMA.Version+#13#10;
        FormatInfo:= FormatInfo + Int2Str(WMA.SampleRate) + ' hz; ' + Int2Str(WMA.BitRate) + ' kbit/s; ' + WMA.ChannelsMode+#13#10;
        FormatInfo:= FormatInfo + 'Продолжительность: '+Int2Str(Round(WMA.Duration)) + ' c';

        Exists_2:= True;
        if Exists_2 then begin
          Title_2:= WMA.Title;
          Artist_2:= WMA.Artist;
          Album_2:= WMA.Album;
          Track_2:= WMA.Track;
          Year_2:= WMA.Year;
          Genre_2:= WMA.Genre;
          Comment_2:= WMA.Comment;
          Composer_2:= WMA.Composer;
          Copyright_2:= WMA.Copyright;
        end;
        Exit;
      end;

    finally
      MPEGaudio.Free; WMA.Free; WAV.Free; FLAC.Free; CDAtrack.Free; Monkey.Free; TwinVQ.Free; AAC.Free; MPEGplus.Free; OggVorbis.Free;
    end;
end;

procedure TMainForm.BAPFileBrowserSelFile(Sender: PControl; FileName: String; const Dir: Boolean; Attr: PWin32FindDataA);
var Track_1, Track_2, Genre_1: Integer;
var Exists_1, Exists_2: Boolean;
var FormatInfo, VersionID_1, VersionID_2,
    Title_1, Artist_1, Album_1, Year_1, Comment_1,
    Title_2, Artist_2, Album_2, Year_2, Genre_2, Comment_2, Composer_2, Encoder_2, Copyright_2, Language_2, Link_2: String;
begin
     Clear; FFileName:= ''; FTagType:= '';
     if Dir then Exit;

     FFileName:= BAPFileBrowser.Directory+FileName;
     LoadFile(FFileName,
              Track_1, Track_2, Genre_1,
              Exists_1, Exists_2,
              FormatInfo, FTagType, VersionID_1, VersionID_2,
              Title_1, Artist_1, Album_1, Year_1, Comment_1,
              Title_2, Artist_2, Album_2, Year_2, Genre_2, Comment_2, Composer_2, Encoder_2, Copyright_2, Language_2, Link_2);

    mFormatInfo.Text:= FormatInfo;
    TagExists.Checked:= Exists_2; TagExists2.Checked:= Exists_1;

    TagVersionValue.Text:= VersionID_2;
    if Exists_2 then begin
      TitleEdit.Text:= Title_2;
      ArtisEdit.Text:= Artist_2;
      AlbumEdit.Text:= Album_2;
      TrackEdit.Text:= Int2Str(Track_2);
      YearEdit.Text:= Year_2;
      GenreEdit.Text:= Genre_2;
      CommenEdit.Text:= Comment_2;
      ComposerEdit.Text:= Composer_2;
      EncoderEdit.Text:= Encoder_2;
      CopyrighEdit.Text:= Copyright_2;
      LanguageEdit.Text:= Language_2;
      LinkEdit.Text:= Link_2;
    end;
    TagExists.Checked:= Exists_2; TagExists2.Checked:= Exists_1;
    if Exists_1 then begin
      TitleEdit2.Text:= Title_1;
      ArtisEdit2.Text:= Artist_1;
      AlbumEdit2.Text:= Album_1;
      TrackEdit2.Text:= Int2Str(Track_1);
      YearEdit2.Text:= Year_1;
      CommenEdit2.Text:= Comment_1;
      GenreComboBox2.CurIndex:= Genre_1+1;
      TagVersionValue2.Text:= VersionID_1;
    end;
end;

procedure TMainForm.Clear;
begin
    TitleEdit.Text:= '';
    ArtisEdit.Text:= '';
    AlbumEdit.Text:= '';
    TrackEdit.Text:= '';
    YearEdit.Text:= '';
    GenreEdit.Text:= '';
    CommenEdit.Text:= '';
    ComposerEdit.Text:= '';
    EncoderEdit.Text:= '';
    CopyrighEdit.Text:= '';
    LanguageEdit.Text:= '';
    LinkEdit.Text:= '';
    TitleEdit2.Text:= '';
    ArtisEdit2.Text:= '';
    AlbumEdit2.Text:= '';
    TrackEdit2.Text:= '';
    YearEdit2.Text:= '';
    CommenEdit2.Text:= '';
    GenreComboBox2.Text:= '';
    mFormatInfo.Text:= '';
    TagVersionValue2.Text:= '';
    TagVersionValue.Text:= '';
    TagExists.Checked:= False;
    TagExists2.Checked:= False;
end;

procedure TMainForm.KOLFormFormCreate(Sender: PObj);
var i: Integer;
begin
    GenreComboBox2.Add('');
    for i:= 0 to MAX_MUSIC_GENRES-1 do GenreComboBox2.Add(MusicGenre[i]);
end;

procedure TMainForm.SaveFile(const FileName: String; Track_1, Track_2,
  Genre_1: Integer; Exists_1, Exists_2: Boolean; TagType, Title_1,
  Artist_1, Album_1, Year_1, Comment_1, Version_2, Title_2, Artist_2, Album_2, Year_2,
  Genre_2, Comment_2, Composer_2, Encoder_2, Copyright_2, Language_2,
  Link_2: String);
procedure SaveID3v1(ID3v1: PID3v1);
begin
    if not Exists_1 then begin
      ID3v1.RemoveFromFile(FileName);
    end
    else begin
      ID3v1.Title:=        Title_1;
      ID3v1.Artist:=       Artist_1;
      ID3v1.Album:=        Album_1;
      ID3v1.Track:=        Track_1;
      ID3v1.Year:=         Year_1;
      if Genre_1 < 0 then Genre_1:= DEFAULT_GENRE;
      ID3v1.GenreID:=      Genre_1;
      ID3v1.Comment:=      Comment_1;
      ID3v1.SaveToFile(FileName);
    end;
end;
procedure SaveID3v2(ID3v2: PID3v2);
begin
    if not Exists_2 then begin
      ID3v2.RemoveFromFile(FileName);
    end
    else begin
      ID3v2.Title:=        Title_2;
      ID3v2.Artist:=       Artist_2;
      ID3v2.Album:=        Album_2;
      ID3v2.Track:=        Track_2;
      ID3v2.Year:=         Year_2;
      ID3v2.Genre:=        Genre_2;
      ID3v2.Comment:=      Comment_2;
      ID3v2.Composer:=     Composer_2;
      ID3v2.Encoder:=      Encoder_2;
      ID3v2.Copyright:=    Copyright_2;
      ID3v2.Language:=     Language_2;
      ID3v2.Link:=         Link_2;
      ID3v2.SaveToFile(FileName);
    end;
end;

procedure SaveAPE(APEtag: PAPE);
begin
    if not Exists_2 then begin
      APEtag.RemoveFromFile(FileName);
    end
    else begin
      APEtag.Title:=        Title_2;
      APEtag.Artist:=       Artist_2;
      APEtag.Album:=        Album_2;
      APEtag.Track:=        Track_2;
      APEtag.Year:=         Year_2;
      APEtag.Genre:=        Genre_2;
      APEtag.Comment:=      Comment_2;
      APEtag.Copyright:=    Copyright_2;
      APEtag.SaveToFile(FileName);
    end;
end;

var ID3v1: PID3v1;
    ID3v2: PID3v2;
    WMA: PWMA;
    FLAC: PFLAC;
    Monkey: PMonkey;
    TwinVQ: PTwinVQ;
    MPEGplus: PMPEGplus;
    OggVorbis: POggVorbis;
begin
    ID3v1:= NewID3v1;
    ID3v2:= NewID3v2;
    WMA:= NewWMA;
    FLAC:= NewFLAC;
    Monkey:= NewMonkey;
    TwinVQ:= NewTwinVQ;
    MPEGplus:= NewMPEGplus;
    OggVorbis:= NewOggVorbis;
    try

      if (TagType = 'OggVorbis') then begin
        if not Exists_2 then OggVorbis.ClearTag(FileName)
        else begin
          OggVorbis.Title:= Title_2;
          OggVorbis.Artist:= Artist_2;
          OggVorbis.Album:= Album_2;
          OggVorbis.Track:= Track_2;
          OggVorbis.Date:= Year_2;
          OggVorbis.Genre:= Genre_2;
          OggVorbis.Comment:= Comment_2;
          OggVorbis.SaveTag(FileName);
        end;
      end;

      if (TagType = 'MPEGplus') then begin
        ID3v1.RemoveFromFile(FileName);
        ID3v2.RemoveFromFile(FileName);
        SaveAPE(MPEGplus.APEtag);
      end;

      if (TagType = 'TwinVQ') then begin
          TwinVQ.Exists := Exists_2;
          TwinVQ.Title:=        Title_2;
          TwinVQ.Author:=       Artist_2;
          TwinVQ.Album:=        Album_2;
          TwinVQ.Comment:=      Comment_2;
          TwinVQ.Copyright:=    Copyright_2;
          TwinVQ.OriginalFile:= Composer_2;
          TwinVQ.SaveToFile(FileName);
      end;

      if (TagType = 'Monkey') then begin
        ID3v1.RemoveFromFile(FileName);
        ID3v2.RemoveFromFile(FileName);
        SaveAPE(Monkey.APEtag);
      end;

      if (TagType = 'AAC') then begin
        SaveID3v1(ID3v1);
        SaveID3v2(ID3v2);
      end;

      if (TagType = 'MP3') then begin
        SaveID3v1(ID3v1);
        SaveID3v2(ID3v2);
      end;

      if (TagType = 'WMA') then begin
        WMA.Title:=            Title_2;
        WMA.Artist:=           Artist_2;
        WMA.Album:=            Album_2;
        WMA.Track:=            Track_2;
        WMA.Year:=             Year_2;
        WMA.Genre:=            Genre_2;
        WMA.Comment:=          Comment_2;
        WMA.Composer:=         Composer_2;
        WMA.Copyright:=        Copyright_2;
        WMA.SaveToFile(FileName);
      end;

      if (TagType = 'FLAC') then begin

          FLAC.Vendor:=       Version_2;
          FLAC.Exists:=       Exists_2;
          FLAC.Title:=        Title_2;
          FLAC.Artist:=       Artist_2;
          FLAC.Album:=        Album_2;
          if Track_2 <> 0 then FLAC.Track:= Int2Str(Track_2);
          FLAC.Year:=         Year_2;
          FLAC.Genre:=        Genre_2;
          FLAC.Comment:=      Comment_2;
          FLAC.Copyright:=    Copyright_2;
          FLAC.SaveToFile(FileName);
      end;
    finally
      ID3v1.Free; ID3v2.Free; WMA.Free; FLAC.Free; Monkey.Free; TwinVQ.Free; MPEGplus.Free; OggVorbis.Free;
    end;
end;

procedure TMainForm.btnSaveClick(Sender: PObj);
begin
    if (FFileName = '') or (FTagType = '') then Exit;
    SaveFile(FFileName, Str2Int(TrackEdit2.Text), Str2Int(TrackEdit.Text),
              GenreComboBox2.CurIndex-1, TagExists2.Checked, TagExists.Checked,
              FTagType,
              TitleEdit2.Text, ArtisEdit2.Text, AlbumEdit2.Text, YearEdit2.Text, CommenEdit2.Text,
              TagVersionValue.Text, TitleEdit.Text, ArtisEdit.Text, AlbumEdit.Text, YearEdit.Text,
              GenreEdit.Text, CommenEdit.Text, ComposerEdit.Text, EncoderEdit.Text,
              CopyrighEdit.Text, LanguageEdit.Text, LinkEdit.Text);

end;

procedure TMainForm.BAPDriveBox1ChangeDrive(Sender: PControl;
  Drive: String; const ReadErr: Boolean; var Retry: Boolean);
begin
    BAPFileBrowser.Directory:= Drive;
end;

end.






