unit CdRip_dll;
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

type

    TCDAFile = record
        Marker1:        Array[0..3] of Char;
        BytesFollowing: LongInt;
        Marker2:        Array[0..3] of Char;
        Marker3:        Array[0..3] of Char;
        Fixed1:         LongInt;
        CDAVersion : Word;
        TrackNum : Word;
        CDSerial : DWord;
        HSGBeg : DWord;
        HSGLen : DWord;
        RedBeg : DWord;
        RedLen : DWord;
    end;

type
        PShort = ^SHORT;

        CDEX_ERR = LongInt;
const
	CDEX_OK			=$00000000;
	CDEX_ERROR		=$00000001;
	CDEX_FILEOPEN_ERROR	=$00000002;
	CDEX_JITTER_ERROR	=$00000003;
	CDEX_RIPPING_DONE	=$00000004;
	CDEX_RIPPING_INPROGRESS	=$00000005;

        CDROMDATAFLAG =$04;
        AUDIOTRKFLAG  =$10;

type
    PSenseKey = ^TSenseKey;
    TSenseKey = packed record
	SK    :BYTE;
	ASC   :BYTE;
	ASCQ  :BYTE;
    end;

    TDriveType = (GENERIC,
	TOSHIBA,
	TOSHIBANEW,
	IBM,
	NEC,
	DEC,
	IMS,
	KODAK,
	RICOH,
	HP,
	PHILIPS,
	PLASMON,
	GRUNDIGCDR100IPW,
	MITSUMICDR,
	PLEXTOR,
	SONY,
	YAMAHA,
	NRC,
	IMSCDD5,
	CUSTOMDRIVE
	);

    TReadMethod = (READMMC,
	READ10,
	READNEC,
	READSONY,
	READMMC2,
	READMMC3,
	READC1,
	READC2,
	READC3
	);

    TSetSpeed = (SPEEDNONE,
	SPEEDMMC,
	SPEEDSONY,
	SPEEDYAMAHA,
	SPEEDTOSHIBA,
	SPEEDPHILIPS,
	SPEEDNEC
	);

    TEndian = (BIGENDIAN,
	LITTLEENDIAN
	);

    TEnableMode = (ENABLENONE,
	ENABLESTD
	);

    PDriveTable = ^TDriveTable;
    TDriveTable = packed record
        DriveType  : LongInt{TDriveType};
	ReadMethod : LongInt{TReadMethod};
	SetSpeed   : LongInt{TSetSpeed};
	Endian     : LongInt{TEndian};
	EnableMode : LongInt{TEnableMode};
	nDensity   : LongInt;
	bAtapi     : BOOL;
    end;

    TOutputFormat = (STEREO44100,
	MONO44100,
	STEREO22050,
	MONO22050,
	STEREO11025,
	MONO11025
	);

    PCDROMParams = ^TCDROMParams;
    TCDROMParams = packed record
        lpszCDROMID             : array[0..255] of char;   // CD-ROM ID, must be unique to index settings in INI file
	nNumReadSectors         : LongInt;		   // Number of sector to read per burst
	nNumOverlapSectors	: LongInt;		   // Number of overlap sectors for jitter correction
	nNumCompareSectors	: LongInt;		   // Number of sector to compare for jitter correction
	nOffsetStart		: LongInt;		   // Fudge factor at start of ripping in sectors
	nOffsetEnd		: LongInt;		   // Fudge factor at the end of ripping in sectors
	nSpeed			: LongInt;		   // CD-ROM speed factor 0 .. 32 x
	nSpinUpTime		: LongInt;		   // CD-ROM spin up time in seconds
	bJitterCorrection	: LongBool;		 	   // Boolean indicates whether to use Jitter Correction
	bSwapLefRightChannel    : LongBool;		  	   // Swap left and right channel ?
	DriveTable		: TDriveTable;	 	   // Drive specific parameters

	btTargetID		: BYTE;		 	   // SCSI target ID
	btAdapterID		: BYTE;		 	   // SCSI Adapter ID
	btLunID		        : BYTE;		 	   // SCSI LUN ID

	bAspiPosting		: LongBool;		 	   // When set ASPI posting is used, otherwhiese ASPI polling is used
	nOutputFormat		: LongInt{TOutputFormat};     	   // Determines the sample rate and channels of the output format
	nAspiRetries            : Integer;
	nAspiTimeOut            : Integer;
    end;

    PTOCEntry = ^TTOCEntry;
    TTOCEntry = packed record
        dwStartSector  : LongInt {DWORD};		// Start sector of the track
	btFlag         : BYTE;		// Track flags (i.e. data or audio track)
	btTrackNumber  : BYTE;		// Track number
    end;


    // Call init before anything else
    function CR_Init : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Get the DLL version number
    function CR_GetCDRipVersion : LongInt; stdcall; external 'CDRip.dll';
    // Get the number of detected CD-ROM drives
    function CR_GetNumCDROM : LongInt; stdcall; external 'CDRip.dll';
    // Get the active CDROM drive index (0..GetNumCDROM()-1
    function CR_GetActiveCDROM : LongInt; stdcall; external 'CDRip.dll';
    // Set Active CDROM drive
    function CR_SetActiveCDROM(nActiveDrive : LongInt) : LongInt; stdcall; external 'CDRip.dll';
    // Select the DRIVETYPE of the active drive
    function CR_SelectCDROMType(cdType : TDriveType) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Get the Selected CDROM type
    function CR_GetCDROMType : TDriveType; stdcall; external 'CDRip.dll';
    // Get the CDROM parameters of the active drive
    function CR_GetCDROMParameters(var pParam : TCDROMParams) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Set the CDROM parameters of the active drive
    function CR_SetCDROMParameters(pParam : PCDROMParams) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Start ripping section, output is fetched to WriteBufferFunc
    // Data is extracted from dwStartSector to dwEndSector
    function CR_OpenRipper(plBufferSize : PLongInt; dwStartSector,dwEndSector : LongInt) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Close the ripper, has to be called when the ripping process is completed (i.e 100%)
    // Or it can be called to abort the current ripping section
    function CR_CloseRipper : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Indicates how far the ripping process is right now
    // Returns 100% when the ripping is completed
    function CR_GetPercentCompleted : LongInt; stdcall; external 'CDRip.dll';
    // Returns the peak value of the ripped section (0..2^15)
    function CR_GetPeakValue : LongInt; stdcall; external 'CDRip.dll';
    // Get number of Jitter Errors that have occured during the ripping
    // This function must be called before CloseRipper is called !
    function CR_GetNumberOfJitterErrors : LongInt; stdcall; external 'CDRip.dll';
    // Get the jitter position of the extracted track
    function CR_GetJitterPosition : LongInt; stdcall; external 'CDRip.dll';
    // Rip a chunk from the CD, pbtStream contains the ripped data, pNumBytes the
    // number of bytes that have been ripped and corrected for jitter (if enabled)
    function CR_RipChunk(pbtStream : Pointer; var pNumBytes : DWORD) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Load the CD-ROM settings from the file
    function CR_LoadSettings(strIniFname : PChar) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Save the settings to a INI file
    function CR_SaveSettings(strIniFname : PChar) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Normalize the stream (i.e. multiply by dScaleFactor)
    procedure CR_NormalizeChunk(pbsStream : PShort; nNumSamples : LongInt; dScaleFactor : DOUBLE); stdcall; external 'CDRip.dll';
    // Read the table of contents
    function CR_ReadToc : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Get the number of TOC entries, including the lead out
    function CR_GetNumTocEntries : LongInt; stdcall; external 'CDRip.dll';
    // Get the TOC entry
    function CR_GetTocEntry(nTocEntry : longint) : Int64; stdcall; external 'CDRip.dll';
    // Checks if the unit is ready (i.e. is the CD media present)
    function CR_IsUnitReady : BOOL; stdcall; external 'CDRip.dll';
    // Eject the CD, bEject=TRUE=> the CD will be ejected, bEject=FALSE=> the CD will be loaded
    function CR_EjectCD(bEject : BOOL) : BOOL; stdcall; external 'CDRip.dll';
    // Check if the CD is playing
    function CR_IsAudioPlaying : BOOL; stdcall; external 'CDRip.dll';
    // Play track
    function CR_PlayTrack(nTrack : integer) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Stop Play track
    function CR_StopPlayTrack : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Pause Play track
    function CR_PauseCD(bPause : BOOL) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Get debug information
    function CR_GetSenseKey : TSenseKey; stdcall; external 'CDRip.dll';
    // Get status of audio playing
    function CR_GetPlayPosition(var dwRelPos, dwAbsPos : DWORD) : CDEX_ERR; stdcall; external 'CDRip.dll';
    // Set the audio play position
    function CR_SetPlayPosition(dwAbsPos : DWORD) : CDEX_ERR; stdcall; external 'CDRip.dll';

    function CR_PlaySection(lStartSector, lEndSector : LongInt) : CDEX_ERR; stdcall; external 'CDRip.dll';

    procedure CR_GetLastJitterErrorPosition(var dwStartSector, dwEndSector : DWORD); stdcall; external 'CDRip.dll';

implementation

end.
