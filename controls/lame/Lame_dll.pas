unit Lame_dll;
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

uses Windows;

const
     BE_CONFIG_MP3  = 0;
     BE_CONFIG_LAME = 256;

type
    THBESTREAM = ULONG;
    PHBESTREAM = ^THBESTREAM;
    TBEERR     = ULONG;
    PSHORT      = ^SHORT;
    PBYTE       = ^Byte;
const

    BE_ERR_SUCCESSFUL                = $00000000;
    BE_ERR_INVALID_FORMAT	     = $00000001;
    BE_ERR_INVALID_FORMAT_PARAMETERS = $00000002;
    BE_ERR_NO_MORE_HANDLES	     = $00000003;
    BE_ERR_INVALID_HANDLE	     = $00000004;
    BE_ERR_BUFFER_TOO_SMALL	     = $00000005;

    BE_MAX_HOMEPAGE = 256;

    BE_MP3_MODE_STEREO      = 0;
    BE_MP3_MODE_JSTEREO     = 1;
    BE_MP3_MODE_DUALCHANNEL = 2;
    BE_MP3_MODE_MONO        = 3;

    MPEG1 = 1;
    MPEG2 = 0;



type

  MPEG_QUALITY = (NORMAL_QUALITY, LOW_QUALITY, HIGH_QUALITY, VOICE_QUALITY);

  PLHV1 = ^TLHV1;
  TLHV1 = packed record
    dwStructVersion : DWORD;
    dwStructSize    : DWORD;

    dwSampleRate    : DWORD;
    dwReSampleRate  : DWORD;
    nMode	    : INTEGER;
    dwBitrate       : DWORD;
    dwMaxBitrate    : DWORD;
    nQuality        : DWORD; {MPEG_QUALITY ;}
    dwMpegVersion   : DWORD;
    dwPsyModel      : DWORD;
    dwEmphasis      : DWORD;

    bPrivate	    : BOOL;
    bCRC	    : BOOL;
    bCopyright	    : BOOL;
    bOriginal       : BOOL;

    bWriteVBRHeader : BOOL;
    bEnableVBR	    : BOOL;
    nVBRQuality     : integer;

    btReserved      : array [1..255] of byte;
end;

  PLameMP3 = ^TLameMP3;
  TLameMP3 = packed record
    dwSampleRate : DWORD;  
    // 48000, 44100 and 32000 allowed
    byMode       : Byte;  
    // BE_MP3_MODE_STEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO
    wBitrate     : Word;   
    // 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256 and 320 allowed
    bPrivate,
    bCRC,
    bCopyright,
    bOriginal    : BOOLean;
  end;

  PAAC = ^TAAC;
  TAAC = packed record
    dwSampleRate : DWORD;
    byMode : Byte;
    wBitrate : Word;
    byEncodingMethod : Byte;
  end;


  PFormat = ^TFormat;
  TFormat = packed record
    case dwConfig : DWord of 
      BE_CONFIG_MP3 : (MP3 : TLameMP3);
      BE_CONFIG_LAME : (LHV1 : TLHV1);
  end;

  PBECONFIG = ^TBECONFIG;
  TBECONFIG = packed record
    Format : TFormat;
  end;

  PBEVersion = ^TBEVersion;
  TBEVersion = packed record
    // BladeEnc DLL Version number
    byDLLMajorVersion,
    byDLLMinorVersion,
    // BladeEnc Engine Version Number
    byMajorVersion,
    byMinorVersion,
    // DLL Release date
    byDay,
    byMonth : Byte;
    wYear : Word;    
    zHomepage : Array[0..BE_MAX_HOMEPAGE] of char;
  end;

  function beInitStream(var pbeConfig : TBEConfig; var dwSamples : DWORD; var dwBufferSize : DWORD; var phbeStream : THBESTREAM) : TBeErr; cdecl; external 'LAME_ENC.DLL';
  (*
    pbeConfig    = Type of mp3
    dwSamples    = Maximum number of samples to encode
    dwBufferSize = Maximum mp3 buffer size
    hbeStream    = BladeEnc-stream
  *)
  function beEncodeChunk(hbeStream : THBEStream; nSamples : DWORD; pSamples : PShort;  pOutput : PByte; var pdwOutput : DWORD) : TBeErr; cdecl; external 'LAME_ENC.DLL';
  (*
    hbeStream    =
    nSamples     = Number of samples to encode
    pSamples	 = Pointer to buffer with Samples to encode
    pOutput	 = Pointer to buffer to recieve encoded samples
    pdwOutput	 = number of samples encoded
  *)
  function beDeinitStream(hbeStream : THBEStream;  pOutput : PByte; var pdwOutput : DWORD) : TBeErr; cdecl; external 'LAME_ENC.DLL';
  (*
    hbeStream    =
    pOutput	 = Pointer to buffer holding encoded samples
    pdwOutput	 = Number of samples to write
  *)
  function beCloseStream(hbeStream : THBEStream) : TBeErr; cdecl; external 'LAME_ENC.DLL';
  procedure beVersion(var pbeVersion : TBEVersion); cdecl; external 'LAME_ENC.DLL';

implementation

end.
