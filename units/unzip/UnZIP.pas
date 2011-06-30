///////////////////////////////////////////////////////////////////////////////
//
//      Unzips deflated, imploded, shrunk and stored files
//
///////////////////////////////////////////////////////////////////////////////

unit UnZIP;
{  Original version (1.x): Christian Ghisler
   C code by info-zip group, translated to pascal by Christian Ghisler
   based on unz51g.zip;
   Special thanks go to Mark Adler, who wrote the main inflate and
   explode code, and did NOT copyright it!!!

   Original UnZIP unit by Prof. Abimbola Olowofoyeku (The African Chief)
   from chfzip25.zip package. http:www.bigfoot.com/~African_Chief/

   Translated and modified to KOL by Dimaxx (dimaxx@atnet.ru)
}

interface

uses Windows, Messages, Kol;

type
  PMainHeader = ^TMainHeader;
  TMainHeader = packed record
    Signature: cardinal;   {0x06054B50}
    ThisDisk,CentralStartDisk,EntriesThisDisk,EntriesCentralDdir: word;
    HeadSize,HeadStart: cardinal;
    CommentLen: word;
  end;
  PHeader = ^THeader;
  THeader = packed record
    Signature: cardinal;   { 0x02014B50 }
    OSVersion,             { Operating system version }
    OSMadeBy: byte;        { MSDOS (FAT): 0 }
    ExtractVer,BitFlag,ZipType: word;
    FileTimeDate,CRC32,CompressSize,UncompressSize: cardinal;
    FilenameLen,ExtraFieldLen,FileCommentLen,DiskNumberStart,InternalAttr: word;
    ExternalAttr: array[0..3] of byte;
    OffsetLocalHeader: cardinal;
  end;
  PLocalHeader = ^TLocalHeader;
  TLocalHeader = packed record
    Signature: cardinal;   { 0x04034B50 }
    ExtractVer,BitFlag,ZipType: word;
    FileTimeDate,CRC32: cardinal;
    CompressSize,UncompressSize: cardinal;
    FilenameLen,ExtraFieldLen: word;
  end;
  TBufType = array[0..MaxInt-16] of Char;
  TZipRec = record
    Buf: ^TBufType;            {please}         {buffer containing central dir}
    BufSize,                   {do not}         {size of buffer}
    LocalStart  : cardinal;    {change these!}  {start pos in buffer}
    Time        : integer;
    Size,
    CompressSize: cardinal;
    HeaderOffset: cardinal;
    Filename    : string;
    PackMethod  : word;
    Attr        : byte;
    DirFile     : file of byte;    { used internally: do not access directly! }
  end;

{ record for callback progress Reports, etc. }
  PReportRec = ^TReportRec;  {passed to callback functions}
  TReportRec = record
    Filename    : string;    {name of individual file}
    Time        : integer;   {date and time stamp of individual file}
    Size,                    {uncompressed and time stamp of individual file}
    CompressSize: cardinal;  {compressed and time stamp of individual file}
    Attr        : integer;   {file attribute of individual file}
    PackMethod  : word;      {compression method of individual file}
    Ratio       : byte;      {compression ratio of individual file}
    Status      : integer;   {callback status code to show where we are}
    IsADir      : boolean;   {is this file a directory?}
  end;

{ callback status codes }
const
  MaxBufSize       = 256*1024-16;

{ procedural types for callbacks }
type
  PUnzipReportProc = ^UnzipReportProc;
  UnzipReportProc  = procedure(Retcode: integer; Rec: PReportRec);

{ procedural type for "Report" callback: the callback function
  (if any) is called several times during the unzip process

  Error codes are sent to the callback in "Retcode". Other
  details are sent in the record pointed to by "Rec".
  * Note particularly Rec^.Status - this contains information about
  the current status or stage of the unzip process. It can have
  any of the following values;
  (archive status)
    unzip_starting   = starting with a new ZIP archive (rec^.filename)
    unzip_completed  = finished with the ZIP archive (rec^.filename)

  (file status)
    file_starting    = starting to unzip (extract) a file (from archive)
    file_unzipping   = continuing to unzip a file (from archive)
        (when this status value is reported, the actual number of
         bytes written to the file are reported in "Retcode"; this is
         valuable for updating any progress bar)

    file_completed   = finshed  unzip a file (from archive)
    file_Failure     = could not extract the file (from archive)
}

  PUnzipQuestionProc = ^UnzipQuestionProc;
  UnzipQuestionProc = function(Rec: PReportRec): boolean;

{ procedural type for "Question" callback:if a file already
  exists, the callback (if any) will be called to ask whether
  the file should be overwritten by the one in the ZIP file;

  the details of the file in the ZIP archive are supplied in the
  record pointed to by "Rec"

 in your callback function, you should;
   return TRUE  if you want the existing file to be overwritten
   return FALSE is you want the existing file to be skipped
}

{Error codes returned by the main unzip functions}
const
  Unzip_OK               = 0;
  Unzip_CRCErr           = -1;
  Unzip_WriteErr         = -2;
  Unzip_ReadErr          = -3;
  Unzip_ZipFileErr       = -4;
  Unzip_UserAbort        = -5;
  Unzip_NotSupported     = -6;
  Unzip_Encrypted        = -7;
  Unzip_InUse            = -8;
  Unzip_InternalError    = -9;    {Error in zip format}
  Unzip_NoMoreItems      = -10;
  Unzip_FileError        = -11;   {Error Accessing file}
  Unzip_NotZipFile       = -12;   {not a zip file}
  Unzip_HeaderTooLarge   = -13;   {can't handle such a big ZIP header}
  Unzip_ZipFileOpenError = -14;   {can't open zip file }
  Unzip_SeriousError     = -100;  {serious error}
  Unzip_MissingParameter = -500;  {missing parameter}

  File_Starting          = - 1000;  {beginning the unzip process; file}
  File_Unzipping         = - 1001;  {continuing the unzip process; file}
  File_Completed         = - 1002;  {completed the unzip process; file}
  File_Failure           = - 1003;  {failure in unzipping file}
  Unzip_Starting         = - 1004;  {starting with a new ZIP file}
  Unzip_Completed        = - 1005;  {completed this ZIP file}

function CalcRatio(NewSize,OrgSize: cardinal): cardinal;

function FileUnzip(SrcZipFile,TargetDir,FileSpecs: string; Report: UnzipReportProc; Question: UnzipQuestionProc): integer;
{ high level unzip
  usage: SrcZipFile          source zip file;
         TargetDir           target directory
         FileSpecs           "*.*", etc.
         Report              Report callback or nil;
         Question            Question callback (for confirmation of
                             whether to replace existing files) or nil;

  Count:=FileUnzip('test.zip','c:\temp','*.*',MyReportProc,nil);
}

function FileUnzipEx(SrcZipFile,TargetDir,FileSpecs: string): integer;
{ high level unzip with no callback parameters;
  passes ZipReport & ZipQuestion internally, so you can use SetZipReportProc
  and SetZipQuestionProc before calling this;

  Count:=FileUnzipEx('test.zip','c:\temp','*.*');
}

function ViewZip(SrcZipFile,FileSpecs: string; Report: UnzipReportProc): integer;
{ view contents of zip file
  usage: SrcZipFile          source zip file;
         FileSpecs           "*.*", etc.
         Report              callback procedure to process the
                             reported contents of ZIP file;

  ViewZip('test.zip','*.*',MyReportProc);
}

function SetUnZipReportProc(aProc: UnzipReportProc): pointer;
{ sets the internal unzip report procedure to aProc
  Returns: pointer to the original report procedure (return value should
           normally be ignored)

  SetUnZipReportProc(MyReportProc);
}

function SetUnZipQuestionProc(aProc: UnzipQuestionProc): pointer;
{ sets the internal unzip question procedure to aProc
  Returns: pointer to the original "question" procedure (return value should
           normally be ignored)

  SetUnZipQuestionProc(QueryFileExistProc);
}

function UnzipSize(SrcZipFile: string; var Compressed: cardinal): cardinal;
{ uncompressed and compressed zip size
  Usage: SrcZipFile          source zip file
         Compressed          the compressed size of the files in the archive
  Returns:                   the uncompressed size of the ZIP archive

  var Size,CSize: cardinal;
  begin
    Size:=UnzipSize('test.zip',CSize);
  end;
}

function GetHeaderOffset(FileName: string; PEndOffset: PInteger): integer;
{ return the offset to the PK signature; with normal zip files, this
  will be zero - but SFX archives will start elsewhere
  * if PEndOffset<>nil then the size of the physical file is returned in it

  StartOffset:=GetHeaderOffSet('test.zip',nil);
  OffSet:=GetHeaderOffSet('test.zip',@Size);
}

function UnzipFile(InName,OutName: string; Offset: cardinal; HFileAction: word; CM_Index: integer): integer;
{ usage: InName              name of zip file with full path
         OutName             desired name for out file
         Offset              header position of desired file in zipfile
         HFileAction         handle to dialog box showing advance of
                             decompression (optional)
         CM_Index            notification code sent in a WM_COMMAND message to
                             the dialog
                             to update percent-bar
 Return value                one of the above Unzip_xxx codes

 Example for handling the cm_index message in a progress dialog:

 UnzipFile(......,CM_ShowPercent);
 ...

 procedure TFileActionDialog.WMCommand(var Msg: TMessage);
 var PPercent: ^Word;
 begin
   TDialog.WMCommand(Msg);
   if Msg.WParam=CM_ShowPercent then
     begin
       PPercent:=pointer(LParam);
       if PPercent<>nil then
         begin
           if (PPercent^>=0) and (PPercent^<=100) then SetProgressBar(PPercent^);
           if UserPressedAbort then PPercent^:=$FFFF else PPercent^:=0;
         end;
     end;
 end;
}

function GetFirstInZip(ZipFilename: string; var ZPRec: TZipRec): integer;
{ Get first entry from ZIP file

  RC:=GetFirstInZip('test.zip',myZipRec);
}

function GetNextInZip(var ZPRec: TZipRec): integer;
{ Get next entry from ZIP file

  RC:=GetNextInZip(myZipRec);
}

function IsZip(Filename: string; PStartOffset: PInteger): boolean;
{ test for zip file
  parameters:
    [1] zip file name
    [2] pointer to integer to hold the offset to the PK signature
        (this will normally zero, except for SFX files); pass nil
        if you don't need the offset

   ItsAZipFile:=IsZip('test.zip',@Offset);
   ItsAZipFile:=IsZip('test2.zip',nil);
}

procedure CloseZipFile(var ZPRec: TZipRec); {Only free buffer, file only open in Getfirstinzip}
{ free ZIP buffers

  CloseZipFile(myZipRec);
}

implementation

var
  ZipReport  : UnzipReportProc;       {Global Status Report Callback}
  ZipQuestion: UnzipQuestionProc;     {Global "Question" Callback}
  ZipRec     : TReportRec;            {Global ZIP record for callbacks}

const
  {Error codes returned by huft_build}
  HuftComplete   = 0;      {Complete tree}
  HuftIncomplete = 1;      {Incomplete tree <- sufficient in some cases!}
  HuftError      = 2;      {bad tree constructed}
  HuftOutOfMem   = 3;      {not enough memory}

  MaxMax    = 31*1024;
  WSize     = $8000;       {Size of sliding dictionary}
  InBufSize = 4096;        {Size of input buffer (4kb) }
  LBits     : integer = 9;
  DBits     : integer = 6;
  B_Max     = 16;
  N_Max     = 288;
  BMAX      = 16;

type
  Push     = ^Ush;
  Ush      = word;
  PByte    = ^Byte;
  PUshList = ^UshList;
  Ushlist  = array[0..maxmax] of Ush;  {only pseudo-size!!}
  PWord    = ^Word;
  PIOBuf   = ^IOBuf;
  IOBuf    = array[0..pred(InBufSize)] of byte;

  PPHuft    = ^PHuft;
  PHuft     = ^Huft;
  PHuftList = ^HuftList;
  Huft      = record
    E,              {# of extra bits}
    B: byte;        {# of bits in code}
    V_n: Ush;
    V_t: PHuftList; {Linked List}
  end;
  HuftList = array[0..8190] of Huft;
  Li = record
    Lo,Hi: word;
  end;
  F_Array = array[0..255,0..63] of word;        { for followers[256][64] }
  PF_Array = ^F_Array;

var
  Slide: PChar;            {Sliding dictionary for unzipping}
  InBuf: IOBuf;            {input buffer}
  InPos,ReadPos: integer;  {position in input buffer, position read from file}
  DlgHandle: word;         {optional: handle of a cancel and "%-done"-dialog}
  DlgNotify: integer;      {notification code to tell dialog how far the decompression is}

  W: word;                 {Current Position in slide}
  B: integer;              {Bit Buffer}
  K: byte;                 {Bits in bit buffer}
  InFile,                  {handle to zipfile}
  OutFile: file of byte;   {handle to extracted file}
  Compsize,                {comressed size of file}
  ReachedSize,             {number of bytes read from zipfile}
  UncompSize: cardinal;    {uncompressed size of file}
  OldPercent: integer;     {last percent value shown}
  CRC32val: cardinal;      {crc calculated from data}
  HuftType: word;          {coding type=bit_flag from header}
  TotalAbort,              {User pressed abort button, set in showpercent!}
  ZipeOf: boolean;         {read over end of zip section for this file}
  InUse: boolean;          {is unit already in use -> don't call it again!!!}
  LastUsedTime: integer;   {Time of last usage in timer ticks for timeout!}

  Followers: PF_Array;
  SLen: array[0..255] of byte;
  Factor: integer;

const
  CRC32Table: array[0..255] of cardinal = (
    $00000000,$77073096,$ee0e612c,$990951ba,$076dc419,$706af48f,$e963a535,$9e6495a3,
    $0edb8832,$79dcb8a4,$e0d5e91e,$97d2d988,$09b64c2b,$7eb17cbd,$e7b82d07,$90bf1d91,
    $1db71064,$6ab020f2,$f3b97148,$84be41de,$1adad47d,$6ddde4eb,$f4d4b551,$83d385c7,
    $136c9856,$646ba8c0,$fd62f97a,$8a65c9ec,$14015c4f,$63066cd9,$fa0f3d63,$8d080df5,
    $3b6e20c8,$4c69105e,$d56041e4,$a2677172,$3c03e4d1,$4b04d447,$d20d85fd,$a50ab56b,
    $35b5a8fa,$42b2986c,$dbbbc9d6,$acbcf940,$32d86ce3,$45df5c75,$dcd60dcf,$abd13d59,
    $26d930ac,$51de003a,$c8d75180,$bfd06116,$21b4f4b5,$56b3c423,$cfba9599,$b8bda50f,
    $2802b89e,$5f058808,$c60cd9b2,$b10be924,$2f6f7c87,$58684c11,$c1611dab,$b6662d3d,
    $76dc4190,$01db7106,$98d220bc,$efd5102a,$71b18589,$06b6b51f,$9fbfe4a5,$e8b8d433,
    $7807c9a2,$0f00f934,$9609a88e,$e10e9818,$7f6a0dbb,$086d3d2d,$91646c97,$e6635c01,
    $6b6b51f4,$1c6c6162,$856530d8,$f262004e,$6c0695ed,$1b01a57b,$8208f4c1,$f50fc457,
    $65b0d9c6,$12b7e950,$8bbeb8ea,$fcb9887c,$62dd1ddf,$15da2d49,$8cd37cf3,$fbd44c65,
    $4db26158,$3ab551ce,$a3bc0074,$d4bb30e2,$4adfa541,$3dd895d7,$a4d1c46d,$d3d6f4fb,
    $4369e96a,$346ed9fc,$ad678846,$da60b8d0,$44042d73,$33031de5,$aa0a4c5f,$dd0d7cc9,
    $5005713c,$270241aa,$be0b1010,$c90c2086,$5768b525,$206f85b3,$b966d409,$ce61e49f,
    $5edef90e,$29d9c998,$b0d09822,$c7d7a8b4,$59b33d17,$2eb40d81,$b7bd5c3b,$c0ba6cad,
    $edb88320,$9abfb3b6,$03b6e20c,$74b1d29a,$ead54739,$9dd277af,$04db2615,$73dc1683,
    $e3630b12,$94643b84,$0d6d6a3e,$7a6a5aa8,$e40ecf0b,$9309ff9d,$0a00ae27,$7d079eb1,
    $f00f9344,$8708a3d2,$1e01f268,$6906c2fe,$f762575d,$806567cb,$196c3671,$6e6b06e7,
    $fed41b76,$89d32be0,$10da7a5a,$67dd4acc,$f9b9df6f,$8ebeeff9,$17b7be43,$60b08ed5,
    $d6d6a3e8,$a1d1937e,$38d8c2c4,$4fdff252,$d1bb67f1,$a6bc5767,$3fb506dd,$48b2364b,
    $d80d2bda,$af0a1b4c,$36034af6,$41047a60,$df60efc3,$a867df55,$316e8eef,$4669be79,
    $cb61b38c,$bc66831a,$256fd2a0,$5268e236,$cc0c7795,$bb0b4703,$220216b9,$5505262f,
    $c5ba3bbe,$b2bd0b28,$2bb45a92,$5cb36a04,$c2d7ffa7,$b5d0cf31,$2cd99e8b,$5bdeae1d,
    $9b64c2b0,$ec63f226,$756aa39c,$026d930a,$9c0906a9,$eb0e363f,$72076785,$05005713,
    $95bf4a82,$e2b87a14,$7bb12bae,$0cb61b38,$92d28e9b,$e5d5be0d,$7cdcefb7,$0bdbdf21,
    $86d3d2d4,$f1d4e242,$68ddb3f8,$1fda836e,$81be16cd,$f6b9265b,$6fb077e1,$18b74777,
    $88085ae6,$ff0f6a70,$66063bca,$11010b5c,$8f659eff,$f862ae69,$616bffd3,$166ccf45,
    $a00ae278,$d70dd2ee,$4e048354,$3903b3c2,$a7672661,$d06016f7,$4969474d,$3e6e77db,
    $aed16a4a,$d9d65adc,$40df0b66,$37d83bf0,$a9bcae53,$debb9ec5,$47b2cf7f,$30b5ffe9,
    $bdbdf21c,$cabac28a,$53b39330,$24b4a3a6,$bad03605,$cdd70693,$54de5729,$23d967bf,
    $b3667a2e,$c4614ab8,$5d681b02,$2a6f2b94,$b40bbe37,$c30c8ea1,$5a05df1b,$2d02ef8d);

   MaskBits: array[0..16] of word =
     ($0000,$0001,$0003,$0007,$000F,$001F,$003F,$007F,$00FF,
      $01FF,$03FF,$07FF,$0FFF,$1FFF,$3FFF,$7FFF,$FFFF);

  { Tables for unreduce }

  DLE = 144;
  L_Table: array[0..4] of integer = (0, $7F, $3F, $1F, $0F);
  D_Shift: array[0..4] of integer = (0, $07, $06, $05, $04);
  D_Mask: array[0..4] of integer = (0, $01, $03, $07, $0F);
  B_Table: array[0..255] of byte =
    (8,1,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
     6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,
     7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
     7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
     8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8);

{ Tables for deflate from PKZIP's appnote.txt. }

   Border: array[0..18] of byte =    { Order of the bit length code lengths }
     (16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15 );
   CpLens: array[0..30] of word =    { Copy lengths for literal codes 257..285 }
     (3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,
      35,43,51,59,67,83,99,115,131,163,195,227,258,0,0);
   { note: see note #13 above about the 258 in this list.}
   CpLext: array[0..30] of word =    { Extra bits for literal codes 257..285 }
     (0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,99,99); { 99==invalid }
   CpDist: array[0..29] of word =    { Copy offsets for distance codes 0..29 }
     (1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,
      2049,3073,4097,6145,8193,12289,16385,24577);
   CpDext: array[0..29] of word =    { Extra bits for distance codes }
     (0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13);

{ Tables for explode }

   CpLen2: array[0..63] of word = (
     2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
     28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
     51,52,53,54,55,56,57,58,59,60,61,62,63,64,65);

   CpLen3: array[0..63] of word = (
     3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,
     29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,
     52,53,54,55,56,57,58,59,60,61,62,63,64,65,66);

   Extra: array[0..63] of word = (
     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8);

   CpDist4: array[0..63] of word = (
     1,65,129,193,257,321,385,449,513,577,641,705,769,833,897,961,1025,1089,
     1153,1217,1281,1345,1409,1473,1537,1601,1665,1729,1793,1857,1921,1985,
     2049,2113,2177,2241,2305,2369,2433,2497,2561,2625,2689,2753,2817,2881,
     2945,3009,3073,3137,3201,3265,3329,3393,3457,3521,3585,3649,3713,3777,
     3841,3905,3969,4033);

   CpDist8: array[0..63] of word = (
     1,129,257,385,513,641,769,897,1025,1153,1281,1409,1537,1665,1793,1921,
     2049,2177,2305,2433,2561,2689,2817,2945,3073,3201,3329,3457,3585,3713,
     3841,3969,4097,4225,4353,4481,4609,4737,4865,4993,5121,5249,5377,5505,
     5633,5761,5889,6017,6145,6273,6401,6529,6657,6785,6913,7041,7169,7297,
     7425,7553,7681,7809,7937,8065);

procedure UpdateCRC32(var CRC: cardinal; var InBuf; InLen: cardinal);
var BytePtr: ^Byte;
    WCount: word;
    aCRC: cardinal;
begin
  aCRC:=CRC;
  BytePtr:=Addr(InBuf);
  for WCount:=1 to InLen do
    begin
      aCRC:=CRC32Table[Byte(aCRC xor cardinal(BytePtr^))] xor ((aCRC shr 8) and $00FFFFFF);
      Inc(BytePtr);
    end;
  CRC:=aCRC;
end;

procedure InitCRC32(var CRC: cardinal);
begin
  CRC:=$FFFFFFFF;
end;

function FinalCRC32(CRC: cardinal): cardinal;
begin
  Result:=not CRC;
end;

procedure UpdateCRC(var S: IOBuf; Len: cardinal);
begin
  UpdateCRC32(CRC32val,S,Len);
end;

procedure MessageLoop;
var Msg: TMsg;
begin
  LastUsedTime:=GetTickCount;
  while PeekMessage(Msg,0,0,0,PM_Remove) do
    if (DlgHandle=0) or not IsDialogMessage(DlgHandle,Msg) then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
end;

function GetSupportedMethods: integer;
begin
  Result:=1+(1 shl 1)+(1 shl 2)+(1 shl 3)+(1 shl 4)+(1 shl 5)+(1 shl 6)+(1 shl 8);
  {Stored, Reduced 2-5, Shrunk, Imploded and Deflated}
end;

function CalcRatio(NewSize,OrgSize: cardinal): cardinal;
begin
  { When the size is so large there is no difference in accuracy }
  if NewSize>(High(cardinal) div 100) then
    begin
      NewSize:=NewSize div 100;
      OrgSize:=OrgSize div 100;
    end;
  if OrgSize=0 then Result:=0 else Result:=100-((Newsize*100) div OrgSize);
end;

procedure ConvertPath(var P: string);
var I: integer;
begin
  for I:=1 to Length(P) do if P[I]='/' then P[I]:='\';
end;

function Matches(const FileSpec,StringToSearch: string): boolean;
var PStringToSearch,PFileSpec: PChar;
    B1: boolean;

function MatchPattern(Element,FileSpec: PChar): boolean;
function IsPatternWild(FileSpec: PChar): boolean;
begin
  Result:=StrScan(FileSpec,'*')<>nil;
  if not Result then Result:=StrScan(FileSpec,'?')<>nil;
end;

begin
  B1:=False;
  if StrComp(FileSpec,'*')=0 then B1:=True else
    if (Element^=Chr(0)) and (FileSpec^<>Chr(0)) then B1:=False else
      if Element^=Chr(0) then B1:=True else
        begin
          case FileSpec^ of
            '*': if MatchPattern(Element,@FileSpec[1]) then B1:=True else
                    B1:=MatchPattern(@Element[1],FileSpec);
            '?': B1:=MatchPattern(@Element[1],@FileSpec[1]);
          else
            if Element^=FileSpec^ then B1:=MatchPattern(@Element[1],@FileSpec[1])
              else B1:=False;
          end;  { case }
        end; { else begin }
  Result:=B1;
end; { MatchPattern }

begin{ Matches }
  Result:=True;
  if (FileSpec='*.*') or (FileSpec='') then Exit; {'' or '*.*' = all files match}
  GetMem(PStringToSearch,256);
  GetMem(PFileSpec,256);
  StrPCopy(PStringToSearch,StringToSearch);
  StrPCopy(PFileSpec,FileSpec);
  Result:=MatchPattern(PStringToSearch,PFileSpec);
  FreeMem(PFileSpec,256);
  FreeMem(PStringToSearch,256);
end;

{************************** fill inbuf from infile *********************}

procedure ReadBuf;
begin
  if ReachedSize>CompSize+2 then
    begin {+2: last code is smaller than requested!}
      ReadPos:=sizeof(InBuf); {Simulates reading -> no blocking}
      ZipEOF:=True;
    end
  else
    begin
      {$I-}
      BlockRead(InFile,InBuf,sizeof(InBuf),ReadPos);
      {$I+}
      if (IOResult<>0) or (ReadPos=0) then
        begin  {readpos=0: kein Fehler gemeldet!!!}
          ReadPos:=sizeof(InBuf); {Simulates reading -> CRC error}
          ZipEOF:=True;
        end;
      Inc(ReachedSize,ReadPos);
      Dec(ReadPos);    {Reason: index of inbuf starts at 0}
    end;
  InPos:=0;
end;

{**** read byte, only used by explode ****}

procedure ReadByte(var BT: byte);
begin
  if InPos>ReadPos then ReadBuf;
  BT:=InBuf[InPos];
  Inc(InPos);
end;

{*********** read at least n bits into the global variable b *************}

procedure NeedBits(N: byte);
var NB: integer;
begin
  while K<N do
    begin
      if InPos>ReadPos then ReadBuf;
      NB:=InBuf[InPos];
      Inc(InPos);
      B:=B or NB shl K;
      Inc(K,8);
    end;
end;

{***************** dump n bits no longer needed from global variable b *************}

procedure DumpBits(N: byte);
begin
  B:=B shr N;
  Dec(K,N);
end;

{********************* Flush w bytes directly from slide to file ******************}
function Flush(W: cardinal): boolean;
var N: integer;
begin
  {$I-}
  BlockWrite(OutFile,Slide[0],W,N);
  {$I+}
  Result:=(cardinal(N)=W) and (IOResult=0);  {True-> alles ok}
  UpdateCRC(IOBuf(pointer(@Slide[0])^),W);
  if (Result) and (@ZipReport<>nil) then {callback report for high level functions}
    begin
      with ZipRec do
        begin
          Status:=File_Unzipping;
          ZipReport(N,@ZipRec);  {report the actual bytes written}
        end;
  end; {report}
end;

{******************************* Break string into tokens ****************************}

var _Token: PChar;

function StrTok(Source: PChar; Token: Char): PChar;
var P: PChar;
begin
  if Source<>nil then _Token:=Source;
  if _Token=nil then
    begin
      Result:=nil;
      Exit;
    end;
  P:=StrScan(_Token,Token);
  Result:=_Token;
  if P<>nil then
    begin
      P^:=#0;
      Inc(P);
    end;
  _Token:=P;
end;

{*************** free huffman tables starting with table where t points to ************}

procedure HuftFree(T: PHuftList);
var P,Q: PHuftList;
    Z: integer;
begin
  P:=pointer(T);
  while P<>nil do
    begin
      Dec(integer(P),sizeof(Huft));
      Q:=P^[0].V_t;
      Z:=P^[0].V_n;   {Size in Bytes, required by TP ***}
      FreeMem(P,(Z+1)*sizeof(Huft));
      P:=Q;
    end;
end;

{*********** build huffman table from code lengths given by array b^ *******************}

function HuftBuild(B: PWord; N: word; S: word; D,E: PUshList; T: PPHuft; var M: integer): integer;
var A: word;                             {counter for codes of length k}
    C: array[0..succ(B_Max)] of word;    {bit length count table}
    F: word;                             {i repeats in table every f entries}
    G,                                   {max. code length}
    H: integer;                          {table level}
    I: word;                             {counter, current code}
    J: word;                             {counter}
    K: integer;                          {number of bits in current code}
    P: PWord;                            {pointer into c, b and v}
    Q: PHuftList;                        {points to current table}
    R: Huft;                             {table entry for structure assignment}
    U: array[0..B_Max] of PHuftList;     {table stack}
    V: array[0..N_Max] of word;          {values in order of bit length}
    W: integer;                          {bits before this table}
    X: array[0..succ(B_Max)] of word;    {bit offsets, then code stack}
    L: array[-1..succ(B_Max)] of word;  {l[h] bits in table of level h}
    XP: PWord;                           {pointer into x}
    Y: integer;                          {number of dummy codes added}
    Z: word;                             {number of entries in current table}
    TryAgain: boolean;                   {bool for loop}
    PT: PHuft;                           {for test against bad input}
    EL: word;                            {length of eob code=code 256}
begin
  if N>256 then EL:=PWord(integer(B)+256*sizeof(word))^ else EL:=BMAX;
  {generate counts for each bit length}
  FillChar(C,sizeof(C),#0);
  P:=B;
  I:=N;                      {p points to array of word}
  repeat
    if P^>B_Max then
      begin
        T^:=nil;
        M:=0;
        Result:=HuftError;
        Exit;
      end;
    Inc(C[P^]);
    Inc(integer(P),sizeof(word));   {point to next item}
    Dec(I);
  until I=0;
  if C[0]=N then
    begin
      T^:=nil;
      M:=0;
      Result:=HuftComplete;
      Exit;
    end;
  {find minimum and maximum length, bound m by those}
  J:=1;
  while (J<=B_Max) and (C[J]=0) do Inc(J);
  K:=J;
  if M<J then M:=J;
  I:=B_Max;
  while (I>0) and (C[I]=0) do Dec(I);
  G:=I;
  if M>I then M:=I;
  {adjust last length count to fill out codes, if needed}
  Y:=1 shl J;
  while J<I do
    begin
      Dec(Y,C[J]);
      if Y<0 then
        begin
          Result:=HuftError;
          Exit;
        end;
      Y:=Y shl 1;
    Inc(J);
  end;
  Dec(Y,C[I]);
  if Y<0 then
    begin
      Result:=HuftError;
      Exit;
    end;
  Inc(C[I],Y);
  {generate starting offsets into the value table for each length}
  X[1]:=0;
  J:=0;
  P:=PWord(@C); {@@}
  Inc(integer(P),sizeof(word));
  XP:=PWord(@X); {@@}
  Inc(integer(XP),2*sizeof(word));
  Dec(I);
  while I<>0 do
    begin
      Inc(J,P^);
      XP^:=J;
      Inc(integer(P),2);
      Inc(integer(XP),2);
      Dec(I);
    end;
  {make table of values in order of bit length}
  P:=B;
  I:=0;
  repeat
    J:=P^;
    Inc(integer(P),sizeof(word));
    if J<>0 then
      begin
        V[X[J]]:=I;
        Inc(X[J]);
      end;
    Inc(I);
  until I>=N;
  {generate huffman codes and for each, make the table entries}
  X[0]:=0;
  I:=0;
  P:=PWord(@V); {@@}
  H:=-1;
  L[-1]:=0;
  W:=0;
  U[0]:=nil;
  Q:=nil;
  Z:=0;
  {go through the bit lengths (k already is bits in shortest code)}
  for K:=K TO G do
    begin
      for A:=C[K] downto 1 do
        begin
          {here i is the huffman code of length k bits for value p^}
          while K>W+L[H] do
            begin
              Inc(W,L[H]); {Length of tables to this position}
              Inc(H);
              Z:=G-W;
              if Z>M then Z:=M;
              J:=K-W;
              F:=1 shl J;
              if F>succ(A) then
                begin
                  Dec(F,succ(A));
                  XP:=@C[K];
                  Inc(J);
                  TryAgain:=True;
                  while (J<Z) and TryAgain do
                    begin
                      F:=F shl 1;
                      Inc(integer(XP),sizeof(word));
                      if F<=XP^ then TryAgain:=False else
                        begin
                          Dec(F,XP^);
                          Inc(J);
                        end;
                    end;
                end;
              if (W+J>EL) and (W<EL) then J:=EL-W;       {Make eob code end at table}
              if W=0 then J:=M;  {*** Fix: main table always m bits!}
              Z:=1 shl J;
              L[H]:=J;
              {allocate and link new table}
              GetMem(Q,(Z+1)*sizeof(Huft));
              if Q=nil then
                begin
                  if H<>0 then HuftFree(pointer(U[0]));
                  Result:=HuftOutOfMem;
                  Exit;
                end;
              FillChar(Q^,(Z+1)*sizeof(Huft),#0);
              Q^[0].V_n:=Z;  {Size of table, needed in freemem ***}
              T^:=@Q^[1];     {first item starts at 1}
              T:=PPHuft(@Q^[0].V_t);  {@@}
              T^:=nil;
              Q:=PHuftList(@Q^[1]); {@@}  {pointer(longint(q)+sizeof(huft));} {???}
              U[H]:=Q;
              {connect to last table, if there is one}
              if H<>0 then
                begin
                  X[H]:=I;
                  R.B:=L[pred(H)];
                  R.E:=16+J;
                  R.V_t:=Q;
                  J:=(I and ((1 shl W)-1)) shr (W-L[pred(H)]);
                  {test against bad input!}
                  PT:=PHuft(integer(U[pred(H)])-sizeof(Huft));
                  if J>PT^.V_n then
                    begin
                      HuftFree(pointer(U[0]));
                      Result:=HuftError;
                      Exit;
                    end;
                  PT:=@U[pred(H)]^[J];
                  PT^:=R;
                end;
            end;
          {set up table entry in r}
          R.B:=word(K-W);
          R.V_t:=nil;   {Unused}   {***********}
          if integer(P)>=integer(@V[N]) then R.E:=99 else
            if P^<S then
              begin
                if P^<256 then R.E:=16 else R.E:=15;
                R.V_n:=P^;
                Inc(integer(P),sizeof(word));
              end
            else
              begin
                if (D=nil) or (E=nil) then
                  begin
                    HuftFree(pointer(U[0]));
                    Result:=HuftError;
                    Exit;
                  end;
          R.E:=word(E^[P^-S]);
          R.V_n:=D^[P^-S];
          Inc(integer(P),sizeof(word));
        end;
      {fill code like entries with r}
      F:=1 shl (K-W);
      J:=I shr W;
      while J<Z do
        begin
          Q^[J]:=R;
          Inc(J,F);
        end;
      {backwards increment the k-bit code i}
      J:=1 shl pred(K);
      while (I and J)<>0 do
        begin
          {i:=i^j;}
          I:=I xor J;
          J:=J shr 1;
        end;
      I:=I xor J;
      {backup over finished tables}
      while ((I and ((1 shl W)-1))<>X[H]) do
        begin
          Dec(H);
          Dec(W,L[H]); {Size of previous table!}
        end;
    end;
  end;
  if (Y<>0) and (G<>1) then Result:=HuftIncomplete else Result:=HuftComplete;
end;

(***************************************************************************)

procedure LoadFollowers;
var X,I: integer;
begin
  for X:=255 downto 0 do
    begin
      NeedBits(6);
      SLen[X]:=B and MaskBits[6];
      DumpBits(6);
      for I:=0 to pred(SLen[X]) do
        begin
          NeedBits(8);
          Followers^[X,I]:=B and MaskBits[8];
          DumpBits(8);
        end;
    end;
end;

function UnReduce(Method: word): integer; { expand probabilistically reduced data }
var LChar,NChar,ExState,V,Len: integer;
    S: integer;           { number of bytes left to decompress }
    W: word;              { position in output window slide[]  }
    U: word;              { true if slide[] unflushed          }
    E,N,D,D1: word;
    BitsNeeded,Follower: integer;
begin
  Result:=Unzip_OK;
  ZipEOF:=False;
  B:=0;
  K:=0;
  W:=0;
  InPos:=0;            {Input buffer position}
  ReadPos:=-1;         {Nothing read}
  LChar:=0;
  V:=0;
  Len:=0;
  S:=UncompSize;
  U:=1;
  ExState:=0;
  New(Followers);
  FillChar(Followers^,sizeof(Followers^),#0);
  Factor:=pred(Method);
  LoadFollowers;
  while (S>0) and not ZipEOF do
    begin
      if SLen[LChar]=0 then
        begin
          NeedBits(8);
          NChar:=B and MaskBits[8];
          DumpBits(8);
        end
      else
        begin
          NeedBits(1);
          NChar:=B and 1;
          DumpBits(1);
          if NChar<>0 then
            begin
              NeedBits(8);
              NChar:=B and MaskBits[8];
              DumpBits(8);
            end
          else
            begin
              BitsNeeded:=B_Table[SLen[LChar]];
              NeedBits(BitsNeeded);
              Follower:=B and MaskBits[BitsNeeded];
              DumpBits(BitsNeeded);
              NChar:=Followers^[LChar,Follower];
            end;
        end;
      { expand the resulting byte }
      case ExState of
        0: begin
             if NChar<>DLE then
               begin
                 Dec(S);
                 Slide[W]:=Char(NChar);
                 Inc(W);
                 if W=$4000 then
                   begin
                     Flush(W);
                     W:=0;
                     U:=0;
                   end;
               end
             else ExState:=1;
           end;
        1: begin
             if NChar<>0 then
               begin
                 V:=NChar;
                 Len:=V and L_Table[Factor];
                 if Len=L_Table[Factor] then ExState:=2 else ExState:=3;
               end
             else
               begin
                 Dec(S);
                 Slide[W]:=Char(DLE);
                 Inc(W);
                 if W=$4000 then
                   begin
                     Flush(W);
                     W:=0;
                     U:=0;
                   end;
                 ExState:=0;
               end;
           end;
        2: begin
             Inc(Len,NChar);
             ExState:=3;
           end;
        3: begin
             N:=Len+3;
             { w: Position in slide }
             { n: zu schreibende bytes }
             { d: von hier kopieren }
             { e: zu kopierende bytes }
             D:=W-((((V shr D_Shift[Factor]) and D_Mask[Factor]) shl 8)+NChar+1);
             Dec(S,N);
             repeat
               D:=D and $3FFF;
               if D>W then D1:=D else D1:=W;
               E:=$4000-D1;
               if E>N then E:=N;
               Dec(N,E);
               if (U<>0) and (W<=D) then
                 begin
                   FillChar(Slide[W],E,#0);
                   Inc(W,E);
                   Inc(D,E);
                 end
               else
                 if W-D<E then           { (assume unsigned comparison) }
                   repeat                { slow to avoid memcpy() overlap }
                     Slide[W]:=Slide[D];
                     Inc(W);
                     Inc(D);
                     Dec(E);
                   until E=0
                 else
                   begin
                     System.Move(Slide[D],Slide[W],E);
                     Inc(W,E);
                     Inc(D,E);
                   end;
                 if W=$4000 then
                   begin
                     Flush(W);
                     W:=0;
                     U:=0;
                   end;
             until N=0;
             ExState:=0;
           end;
      end;
    { store character for next iteration }
    LChar:=NChar;
  end;
  Flush(W);
  Dispose(Followers);
end;

(***************************************************************************)

function InflateCodes(TL,TD: PHuftList; BL,BD: integer): integer;
var N,D,E1,           {length and index for copy}
    ML,MD: word;      {masks for bl and bd bits}
    T: PHuft;         {pointer to table entry}
    E: byte;          {table entry flag/number of extra bits}
begin
  { inflate the coded data }
  ML:=MaskBits[BL];          {precompute masks for speed}
  MD:=MaskBits[BD];
  while not(TotalAbort or ZipEOF) do
    begin
      NeedBits(BL);
      T:=@TL^[B and ML];
      E:=T^.E;
      if E>16 then
        repeat       {then it's a literal}
          if E=99 then
            begin
              Result:=Unzip_ZipFileErr;
              Exit;
            end;
          DumpBits(T^.B);
          Dec(E,16);
          NeedBits(E);
          T:=@T^.V_t^[B and MaskBits[E]];
          E:=T^.E;
        until E<=16;
      DumpBits(T^.B);
      if E=16 then
        begin
          Slide[W]:=Char(T^.V_n);
          Inc(W);
          if W=WSize then
            begin
              if not Flush(W) then
                 begin
                   Result:=Unzip_WriteErr;
                   Exit;
                 end;
              W:=0;
            end;
        end
      else
        begin                {it's an EOB or a length}
          if E=15 then
            begin {Ende}   {exit if end of block}
              Result:=Unzip_OK;
              Exit;
            end;
          NeedBits(E);                 {get length of block to copy}
          N:=T^.V_n+(B and MaskBits[E]);
          DumpBits(E);
          NeedBits(BD);                {decode distance of block to copy}
          T:=@TD^[B and MD];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[B and MaskBits[E]];
              E:=T^.e;
            until E<=16;
          DumpBits(T^.B);
          NeedBits(E);
          D:=W-T^.V_n-B AND MaskBits[E];
          DumpBits(E);
          {do the copy}
          repeat
            D:=D and pred(WSize);
            if D>W then E1:=WSize-D else E1:=WSize-W;
            if E1>N then E1:=N;
            Dec(N,E1);
            if W-D>=E1 then
              begin
                System.Move(Slide[D],Slide[W],E1);
                Inc(W,E1);
                Inc(D,E1);
              end
            else
              repeat
                Slide[W]:=Slide[D];
                Inc(W);
                Inc(D);
                Dec(E1);
              until E1=0;
            if W=WSize then
              begin
                if not Flush(W) then
                  begin
                    Result:=Unzip_WriteErr;
                    Exit;
                  end;
                W:=0;
              end;
          until N=0;
        end;
    end;
  if TotalAbort then Result:=Unzip_UserAbort else Result:=Unzip_ReadErr;
end;

{**************************** "decompress" stored block **************************}

function InflateStored: integer;
var N: word;            {number of bytes in block}
begin
  {go to byte boundary}
  N:=K and 7;
  DumpBits(N);
  {get the length and its complement}
  NeedBits(16);
  N:=B and $FFFF;
  DumpBits(16);
  NeedBits(16);
  if (N<>(not B) and $FFFF) then
    begin
      Result:=Unzip_ZipFileErr;
      Exit;
    end;
  DumpBits(16);
  while (N>0) and not(TotalAbort or ZipEOF) do
    begin {read and output the compressed data}
      Dec(N);
      NeedBits(8);
      Slide[W]:=Char(B);
      Inc(W);
      if W=WSize then
        begin
          if not Flush(W) then
            begin
              Result:=Unzip_WriteErr;
              Exit;
            end;
          W:=0;
        end;
      DumpBits(8);
    end;
  if TotalAbort then Result:=Unzip_UserAbort else
    if ZipEOF then Result:= Unzip_ReadErr else Result:=Unzip_Ok;
end;

{**************************** decompress fixed block **************************}

function InflateFixed: integer;
var I: integer;               {temporary variable}
    TL,                       {literal/length code table}
    TD: PHuftList;            {distance code table}
    BL,BD: integer;           {lookup bits for tl/bd}
    L: array[0..287] of word; {length list for huft_build}
begin
  {set up literal table}
  for I:=0 to 143 do L[I]:=8;
  for I:=144 to 255 do L[I]:=9;
  for I:=256 to 279 do L[I]:=7;
  for I:=280 TO 287 do L[I]:=8; {make a complete, but wrong code set}
  BL:=7;
  I:=HuftBuild(PWord(@L),288,257,PushList(@CpLens),PushList(@CpLext),PPHuft(@TL),BL); {@@}
  if I<>HuftComplete then
    begin
      Result:=I;
      Exit;
    end;
  for I:=0 to 29 do L[I]:=5;    {make an incomplete code set}
  BD:=5;
  I:=HuftBuild(PWord(@L),30,0,PushList(@CpDist),PushList(@CpDext),PPHuft(@TD),BD);  {@@}
  if I>HuftIncomplete then
    begin
      HuftFree(TL);
      Result:=Unzip_ZipFileErr;
      Exit;
    end;
  Result:=InflateCodes(TL,TD,BL,BD);
  HuftFree(TL);
  HuftFree(TD);
end;

{**************************** decompress dynamic block **************************}

function InflateDynamic: integer;
var I: integer;                      {temporary variables}
    J,
    L,                               {last length}
    M,                               {mask for bit length table}
    N: word;                         {number of lengths to get}
    TL,                              {literal/length code table}
    TD: PHuftList;                   {distance code table}
    BL,BD: integer;                  {lookup bits for tl/bd}
    NB,NL,ND: word;                  {number of bit length/literal length/distance codes}
    LL: array[0..288+32-1] of word;  {literal/length and distance code lengths}
begin
  {read in table lengths}
  NeedBits(5);
  NL:=257+word(B) and $1F;
  DumpBits(5);
  NeedBits(5);
  ND:=1+word(B) and $1F;
  DumpBits(5);
  NeedBits(4);
  NB:=4+word(B) and $0F;
  DumpBits(4);
  if (NL>288) or (ND>32) then
    begin
      Result:=1;
      Exit;
    end;
  FillChar(LL,sizeof(LL),#0);
  {read in bit-length-code lengths}
  for J:=0 to pred(NB) do
    begin
      NeedBits(3);
      LL[Border[J]]:=B and 7;
      DumpBits(3);
    end;
  for J:=NB to 18 do LL[Border[J]]:=0;
  {build decoding table for trees--single level, 7 bit lookup}
  BL:=7;
  I:=HuftBuild(PWord(@LL),19,19,nil,nil,PPHuft(@TL),BL); {@@}
  if I<>HuftComplete then
    begin
      if I=HuftIncomplete then HuftFree(TL); {other errors: already freed}
      Result:=Unzip_ZipFileErr;
      Exit;
    end;
  {read in literal and distance code lengths}
  N:=NL+ND;
  M:=MaskBits[BL];
  I:=0;
  L:=0;
  while word(I)<N do
    begin
      NeedBits(BL);
      TD:=PHuftList(@TL^[B and M]); {@@}
      J:=PHuft(TD)^.B;
      DumpBits(J);
      J:=PHuft(TD)^.V_n;
      if J<16 then
        begin            {length of code in bits (0..15)}
          L:=J;                       {ave last length in l}
          LL[I]:=L;
          Inc(I)
        end
      else
        if J=16 then
          begin   {repeat last length 3 to 6 times}
            NeedBits(2);
            J:=3+B and 3;
            DumpBits(2);
            if I+J>N then
              begin
                Result:=1;
                Exit;
              end;
            while J>0 do
              begin
                LL[I]:=L;
                Dec(J);
                Inc(I);
              end;
          end
        else
          if J=17 then
            begin   {3 to 10 zero length codes}
              NeedBits(3);
              J:=3+B and 7;
              DumpBits(3);
              if I+J>N then
                begin
                  Result:=1;
                  Exit;
                end;
              while J>0 do
                begin
                  LL[I]:=0;
                  Inc(I);
                  Dec(J);
                end;
              L:=0;
            end
          else
            begin                {j == 18: 11 to 138 zero length codes}
              NeedBits(7);
              J:=11+B and $7F;
              DumpBits(7);
              if I+J>N then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              while J>0 do
                begin
                  LL[I]:=0;
                  Dec(J);
                  Inc(I);
                 end;
              L:=0;
            end;
    end;
  HuftFree(TL);        {free decoding table for trees}
  {build the decoding tables for literal/length and distance codes}
  BL:=LBits;
  I:=HuftBuild(PWord(@LL),NL,257,PushList(@CpLens),PushList(@CpLext),PPHuft(@TL),BL);
  if I<>HuftComplete then
    begin
      if I=HuftIncomplete then HuftFree(TL);
      Result:=Unzip_ZipFileErr;
      Exit;
    end;
  BD:=DBits;
  I:=HuftBuild(PWord(@LL[NL]),ND,0,PushList(@CpDist),PushList(@CpDext),PPHuft(@TD),BD);
  if I>HuftIncomplete then
    begin {pkzip bug workaround}
      if I=HuftIncomplete then HuftFree(TD);
      HuftFree(TL);
      Result:=Unzip_ZipFileErr;
      Exit;
    end;
  {decompress until an end-of-block code}
  Result:=InflateCodes(TL,TD,BL,BD);
  HuftFree(TL);
  HuftFree(TD);
end;

{**************************** decompress a block ******************************}

function InflateBlock(var E: integer): integer;
var T: word;           {block type}
begin
  NeedBits(1);
  E:=B and 1;
  DumpBits(1);
  NeedBits(2);
  T:=B and 3;
  DumpBits(2);
  case T of
    0: Result:=InflateStored;
    1: Result:=InflateFixed;
    2: Result:=InflateDynamic;
  else
    Result:=Unzip_ZipFileErr;  {bad block type}
  end;
end;

{**************************** decompress an inflated entry **************************}

function Inflate: integer;
var E,                  {last block flag}
    R: integer;         {result code}
begin
  InPos:=0;             {Input buffer position}
  ReadPos:=-1;          {nothing read}
  {initialize window, bit buffer}
  W:=0;
  K:=0;
  B:=0;
  {decompress until the last block}
  repeat
    R:=InflateBlock(E);
    if R<>0 then
      begin
        Result:=R;
        Exit;
      end;
  until E<>0;
  {flush out slide}
  if not Flush(W) then Result:=Unzip_WriteErr else Result:=Unzip_Ok;
end;
(***************************************************************************)
{.$I z_copyst.pas}  {Copy stored file}
{include for unzip.pas: Copy stored file}

{C code by info-zip group, translated to Pascal by Christian Ghisler}
{based on unz51g.zip}

{************************* copy stored file ************************************}
function CopyStored: integer;
var ReadIn,OutCnt: integer;
begin
  while (ReachedSize<CompSize) and not TotalAbort do
    begin
      ReadIn:=CompSize-ReachedSize;
      if ReadIn>WSize then ReadIn:=WSize;
      {$I-}
      BlockRead(InFile,Slide[0],ReadIn,integer(OutCnt));  {Use slide as buffer}
      {$I+}
      if (OutCnt<>ReadIn) or (IOResult<>0) then
        begin
          Result:=Unzip_ReadErr;
          Exit;
        end;
      if not Flush(word(OutCnt)) then
        begin  {Flushoutput takes care of CRC too}
          Result:=Unzip_WriteErr;
          Exit;
        end;
      Inc(ReachedSize,OutCnt);
    end;
  if not TotalAbort then Result:=Unzip_Ok else Result:=Unzip_UserAbort;
end;
(***************************************************************************)
{.$I z_explod.pas}  {Explode imploded file}
{include for unzip.pas: Explode imploded file}

{C code by info-zip group, translated to Pascal by Christian Ghisler}
{based on unz51g.zip}

{************************************* explode ********************************}

{*********************************** read in tree *****************************}
function GetTree(L: PWord; N: word): integer;
var I,K,J,B: word;
    ByteBuf: byte;
begin
  ReadByte(ByteBuf);
  I:=ByteBuf;
  Inc(I);
  K:=0;
  repeat
    ReadByte(ByteBuf);
    J:=ByteBuf;
    B:=(J and $0F)+1;
    J:=((J and $F0) shr 4)+1;
    if (K+J)>N then
      begin
        Result:=4;
        Exit;
      end;
    repeat
      L^:=B;
      Inc(integer(L),sizeof(word));
      Inc(K);
      Dec(J);
    until J=0;
    Dec(I);
  until I=0;
  if K<>N then Result:=4 else Result:=0;
end;

{******************exploding, method: 8k slide, 3 trees ***********************}

function ExplodeLit8(TB,TL,TD: PHuftList; BB,BL,BD: integer): integer;
var S: integer;
    E,N,D,MB,ML,MD,U,W: word;
    T: PHuft;
begin
  B:=0;
  K:=0;
  W:=0;
  U:=1;
  MB:=MaskBits[BB];
  ML:=MaskBits[BL];
  MD:=MaskBits[BD];
  S:=UncompSize;
  while (S>0) and not (TotalAbort or ZipEOF) do
    begin
      NeedBits(1);
      if (B and 1)<>0 then
        begin  {Litteral}
          DumpBits(1);
          Dec(S);
          NeedBits(BB);
          T:=@TB^[(not B) and MB];
          E:=T^.E;
          if E>16 then
            repeat
              if e=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          Slide[W]:=Char(T^.V_n);
          Inc(W);
          if W=WSize then
            begin
              if not Flush(W) then
                begin
                  Result:=Unzip_WriteErr;
                  Exit;
                end;
              W:=0;
              U:=0;
            end;
        end
      else
        begin
          DumpBits(1);
          NeedBits(7);
          D:=B and $7F;
          DumpBits(7);
          NeedBits(BD);
          T:=@TD^[(not B) and MD];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          D:=W-D-T^.V_n;
          NeedBits(BL);
          T:=@TL^[(not B) and ML];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          N:=T^.V_n;
          if E<>0 then
            begin
              NeedBits(8);
              Inc(N,Byte(B) and $FF);
              DumpBits(8);
            end;
          Dec(S,N);
          repeat
            D:=D and pred(WSize);
            if D>W then E:=WSize-D else E:=WSize-W;
            if E>N then E:=N;
            Dec(N,E);
            if (U<>0) and (W<=D) then
              begin
                FillChar(Slide[W],E,#0);
                Inc(W,E);
                Inc(D,E);
              end
            else
              if (W-D>=E) then
                begin
                  System.Move(Slide[D],Slide[W],E);
                  Inc(W,E);
                  Inc(D,E);
                end
              else
                repeat
                  Slide[W]:=Slide[D];
                  Inc(W);
                  Inc(D);
                  Dec(E);
                until E=0;
            if W=WSize then
              begin
                if not Flush(W) then
                  begin
                    Result:=Unzip_WriteErr;
                    Exit;
                  end;
                W:=0;
                U:=0;
              end;
          until N=0;
        end;
    end;
  if TotalAbort then Result:=Unzip_UserAbort else
    if not Flush(W) then Result:=Unzip_WriteErr else
      if ZipEOF then Result:=Unzip_ReadErr else Result:=Unzip_OK;
end;

{******************exploding, method: 4k slide, 3 trees ***********************}

function ExplodeLit4(TB,TL,TD: PHuftList; BB,BL,BD: integer): integer;
var S: integer;
    E,N,D,W,MB,ML,MD,U: word;
    T: PHuft;
begin
  B:=0;
  K:=0;
  W:=0;
  U:=1;
  MB:=MaskBits[BB];
  ML:=MaskBits[BL];
  MD:=MaskBits[BD];
  S:=UncompSize;
  while (S>0) and not (TotalAbort or ZipEOF) do
    begin
      NeedBits(1);
      if (B and 1)<>0 then
        begin  {Litteral}
          DumpBits(1);
          Dec(S);
          NeedBits(BB);
          T:=@TB^[(not B) and MB];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          Slide[W]:=Char(T^.V_n);
          Inc(W);
          if W=WSize then
            begin
              if not Flush(W) then
                begin
                  Result:=Unzip_WriteErr;
                  Exit;
                end;
              W:=0;
              U:=0;
            end;
        end
      else
        begin
          DumpBits(1);
          NeedBits(6);
          D:=B and $3F;
          DumpBits(6);
          NeedBits(BD);
          T:=@TD^[(not B) and MD];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          D:=W-D-T^.V_n;
          NeedBits(BL);
          T:=@TL^[(not B) and ML];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          N:=T^.V_n;
          if E<>0 then
            begin
              NeedBits(8);
              Inc(N,B and $FF);
              DumpBits(8);
            end;
          Dec(S,N);
          repeat
            D:=D and pred(WSize);
            if D>W then E:=WSize-D else E:=WSize-W;
            if E>N then E:=N;
            Dec(N,E);
            if (U<>0) and (W<=D) then
              begin
                FillChar(Slide[W],E,#0);
                Inc(W,E);
                Inc(D,E);
              end
            else
              if W-D>=E then
                begin
                  System.Move(Slide[D],Slide[W],E);
                  Inc(W,E);
                  Inc(D,E);
                end
              else
                repeat
                  Slide[W]:=Slide[D];
                  Inc(W);
                  Inc(D);
                  Dec(E);
                until E=0;
                if W=WSize then
                  begin
                    if not Flush(W) then
                      begin
                        Result:=Unzip_WriteErr;
                        Exit;
                      end;
                    W:=0;
                    U:=0;
                  end;
          until N=0;
        end;
    end;
  if TotalAbort then Result:=Unzip_UserAbort else
    if not Flush(W) then Result:=Unzip_WriteErr else
      if ZipeOf then Result:=Unzip_ReadErr else Result:=Unzip_OK;
end;

{******************exploding, method: 8k slide, 2 trees ***********************}

function ExplodeNoLit8(TL,TD: PHuftList; BL,BD: integer): integer;
var S: integer;
    E,N,D,W,ML,MD,U: word;
    T: PHuft;
begin
  B:=0;
  K:=0;
  W:=0;
  U:=1;
  ML:=MaskBits[BL];
  MD:=MaskBits[BD];
  S:=UncompSize;
  while (S>0) and not (TotalAbort or ZipEOF) do
    begin
      NeedBits(1);
      if (B and 1)<>0 then
        begin  {Litteral}
          DumpBits(1);
          Dec(S);
          NeedBits(8);
          Slide[W]:=Char(B);
          Inc(W);
          if W=WSize then
            begin
              if not Flush(W) then
                begin
                  Result:=Unzip_WriteErr;
                  Exit;
                end;
              W:=0;
              U:=0;
            end;
          DumpBits(8);
        end
      else
        begin
          DumpBits(1);
          NeedBits(7);
          D:=B and $7F;
          DumpBits(7);
          NeedBits(BD);
          T:=@TD^[(not B) and MD];
          E:=t^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          D:=W-D-T^.V_n;
          NeedBits(BL);
          T:=@TL^[(not B) and ML];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          N:=T^.V_n;
          if E<>0 then
            begin
              NeedBits(8);
              Inc(N,B and $FF);
              DumpBits(8);
            end;
          Dec(S,N);
          repeat
            D:=D and pred(WSize);
            if D>W then E:=WSize-D else E:=WSize-W;
            if E>N then E:=N;
            Dec(N,E);
            if (U<>0) and (W<=D) then
              begin
                FillChar(Slide[W],E,#0);
                Inc(W,E);
                Inc(D,E);
              end
            else
              if (W-D>=E) then
                begin
                  System.Move(Slide[D],Slide[W],E);
                  Inc(W,E);
                  Inc(D,E);
                end
              else
                repeat
                  Slide[W]:=Slide[D];
                  Inc(W);
                  Inc(D);
                  Dec(E);
                until E=0;
            if W=WSize then
              begin
                if not Flush(W) then
                  begin
                    Result:=Unzip_WriteErr;
                    Exit;
                  end;
                W:=0;
                U:=0;
              end;
          until N=0;
        end;
    end;
  if TotalAbort then Result:=Unzip_UserAbort else
    if not Flush(W) then Result:=Unzip_WriteErr else
      if ZipeOf then Result:=Unzip_ReadErr else Result:=Unzip_OK;
end;

{******************exploding, method: 4k slide, 2 trees ***********************}

function ExplodeNoLit4(TL,TD: PHuftList; BL,BD: integer): integer;
var S: integer;
    E,N,D,W,ML,MD,U: word;
    T: PHuft;
begin
  B:=0;
  K:=0;
  W:=0;
  U:=1;
  ML:=MaskBits[BL];
  MD:=MaskBits[BD];
  S:=UncompSize;
  while (S>0) and not (TotalAbort or ZipEOF) do
    begin
      NeedBits(1);
      if (B and 1)<>0 then
        begin  {Litteral}
          DumpBits(1);
          Dec(S);
          NeedBits(8);
          Slide[W]:=Char(B);
          inc(W);
          if w=WSIZE then
            begin
              if not Flush(W) then
                begin
                  Result:=Unzip_WriteErr;
                  Exit;
                end;
              W:=0;
              U:=0;
            end;
          DumpBits(8);
        end
      else
        begin
          DumpBits(1);
          NeedBits(6);
          D:=B and $3F;
          DumpBits(6);
          NeedBits(BD);
          T:=@TD^[(not B) and MD];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(E);
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          D:=W-D-T^.V_n;
          NeedBits(BL);
          T:=@TL^[(not B) and ML];
          E:=T^.E;
          if E>16 then
            repeat
              if E=99 then
                begin
                  Result:=Unzip_ZipFileErr;
                  Exit;
                end;
              DumpBits(T^.B);
              Dec(E,16);
              NeedBits(e );
              T:=@T^.V_t^[(not B) and MaskBits[E]];
              E:=T^.E;
            until E<=16;
          DumpBits(T^.B);
          N:=T^.V_n;
          if E<>0 then
            begin
              NeedBits(8);
              Inc(N,B and $FF);
              DumpBits(8);
            end;
          Dec(S,N);
          repeat
            D:=D and pred(WSize);
            if D>W then E:=WSize-D else E:=WSize-W;
            if E>N then E:=N;
            Dec(N,E);
            if (U<>0) and (W<=D) then
              begin
                FillChar(Slide[W],E,#0);
                Inc(W,E);
                Inc(D,E);
              end
            else
              if (W-D>=E) then
                begin
                  System.Move(Slide[D],Slide[W],E);
                  Inc(W,E);
                  Inc(D,E);
                end
              else
                repeat
                  Slide[W]:=Slide[D];
                  Inc(W);
                  Inc(D);
                  Dec(E);
                until E=0;
            if W=WSize then
              begin
                if not Flush(W) then
                  begin
                    Result:=Unzip_WriteErr;
                    Exit;
                  end;
                W:=0;
                U:=0;
              end;
          until N=0;
        end;
    end;
  if TotalAbort then Result:=Unzip_UserAbort else
    if not Flush(W) then Result:=Unzip_WriteErr else
      if ZipeOf then Result:=Unzip_ReadErr else Result:=Unzip_OK;
end;

{****************************** explode *********************************}

function Explode: integer;
var R: integer;
    TB,TL,TD: PHuftList;
    BB,BL,BD: integer;
    L: array[0..255] of word;
begin
  InPos:=0;
  ReadPos:=-1;  {nothing read in}
  BL:=7;
  if CompSize>200000 then BD:=8 else BD:=7;
  if HuftType and 4<>0 then
    begin
      BB:=9;
      R:=GetTree(@L[0],256);
      if R<>0 then
        begin
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      R:=HuftBuild(PWord(@L),256,256,nil,nil,PPHuft(@TB),BB);
      if R<>0 then
        begin
          if R=HuftIncomplete then HuftFree(TB);
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      R:=GetTree(@L[0],64);
      if R<>0 then
        begin
          HuftFree(TB);
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      R:=HuftBuild(PWord(@L),64,0,PushList(@CpLen3),PushList(@Extra),PPHuft(@TL),BL);
      if R<>0 then
        begin
          if R=HuftIncomplete then HuftFree(TL);
          HuftFree(TB);
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      R:=GetTree(@L[0],64);
      if R<>0 then
        begin
          HuftFree(TB);
          HuftFree(TL);
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      if HuftType and 2<>0 then
        begin {8k}
          R:=HuftBuild(PWord(@L),64,0,PushList(@CpDist8),PushList(@Extra),PPHuft(@TD),BD);
          if R<>0 then
            begin
              if R=HuftIncomplete then HuftFree(TD);
              HuftFree(TB);
              HuftFree(TL);
              Result:=Unzip_ZipFileErr;
              Exit;
            end;
          R:=ExplodeLit8(TB,TL,TD,BB,BL,BD);
        end
      else
        begin
          R:=HuftBuild(PWord(@L),64,0,PushList(@CpDist4),PushList(@Extra),PPHuft(@TD),BD);
          if R<>0 then
            begin
              if R=HuftIncomplete then HuftFree(TD);
              HuftFree(TB);
              HuftFree(TL);
              Result:=Unzip_ZipFileErr;
              Exit;
            end;
          R:=ExplodeLit4(TB,TL,TD,BB,BL,BD);
        end;
      HuftFree(TD);
      HuftFree(TL);
      HuftFree(TB);
    end
  else
    begin       {No literal tree}
      R:=GetTree(@L[0],64);
      if R<>0 then
        begin
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      R:=HuftBuild(PWord(@L),64,0,PushList(@CpLen2),PushList(@Extra),PPHuft(@TL),BL);
      if R<>0 then
        begin
          if R=HuftIncomplete then HuftFree(TL);
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      R:=GetTree(@L[0],64);
      if R<>0 then
        begin
          HuftFree(TL);
          Result:=Unzip_ZipFileErr;
          Exit;
        end;
      if HuftType and 2<>0 then
        begin {8k}
          R:=HuftBuild(PWord(@L),64,0,PushList(@CpDist8),PushList(@Extra),PPHuft(@TD),BD);
          if R<>0 then
            begin
              if R=HuftIncomplete then HuftFree(TD);
              HuftFree(TL);
              Result:=Unzip_ZipFileErr;
              Exit;
            end;
          R:=ExplodeNoLit8(TL,TD,BL,BD);
        end
      else
        begin
          R:=HuftBuild(PWord(@L),64,0,PushList(@CpDIst4),PushList(@Extra),PPHuft(@TD),BD);
          if R<>0 then
            begin
              if R=HuftIncomplete then HuftFree(TD);
              HuftFree(TL);
              Result:=Unzip_ZipFileErr;
              Exit;
            end;
          R:=ExplodeNoLit4(TL,TD,BL,BD);
        end;
      HuftFree(TD);
      huftFree(TL);
    end;
  Result:=R;
end;

{*************************** unshrink **********************************}

const
  MaxCode         = 8192;
  MaxStack        = 8192;
  InitialCodeSize = 9;
  FinalCodeSize   = 13;
  WriteMax        = WSize-3*(MaxCode-256)-MaxStack-2;  {Rest of slide=write buffer}
                                                       {=766 bytes}
type
  Prev = array[257..MaxCode] of integer;
  PPrev =^Prev;
  Cds = array[257..MaxCode] of Char;
  PCds = ^Cds;
  StackType = array[0..MaxStack] of Char;
  PStackType = ^StackType;
  WriteBufType = array[0..WriteMax] of Char;   {write buffer}
  PWriteBufType = ^WriteBufType;

var
  PreviousCode: PPrev;        {previous code trie}
  ActualCode: PCds;           {actual code trie}
  Stack: PStackType;          {Stack for output}
  WriteBuf: PWriteBufType;    {Write buffer}
  NextFree,                   {Next free code in trie}
  WritePtr: integer;          {Pointer to output buffer}

function UnShrinkFlush: boolean;
var N: integer;
begin
  {$I-}
  BlockWrite(OutFile,WriteBuf^[0],WritePtr,N);
  {$I+}
  Result:=(N=WritePtr) and (IOResult=0);  {True-> alles ok}
  UpdateCRC(IOBuf(pointer(@WriteBuf^[0])^),WritePtr);
  if (Result=True) and (@ZipReport<>nil) then {callback report for high level functions}
    begin
      with ZipRec do
        begin
          Status:=File_Unzipping;
          ZipReport(N,@ZipRec);    {report the actual bytes written}
        end;
    end; {report}
end;

function WriteChar(C: Char): boolean;
begin
  WriteBuf^[WritePtr]:=C;
  Inc(WritePtr);
  if WritePtr>WriteMax then
    begin
      Result:=UnShrinkFlush;
      WritePtr:=0;
    end
  else Result:=True;
end;

procedure ClearLeafNodes;
var PC,                     {previous code}
    I,                      {index}
    ActMaxCode: integer;    {max code to be searched for leaf nodes}
    Previous: PPrev;        {previous code trie}
begin
  Previous:=PreviousCode;
  ActMaxCode:=pred(NextFree);
  for I:=257 to ActMaxCode do Previous^[I]:=Previous^[I] or $8000;
  for i:=257 to ActMaxCode do
    begin
      PC:=Previous^[I] and not $8000;
      if PC>256 then Previous^[PC]:=Previous^[PC] and (not $8000);
    end;
  {Build new free list}
  PC:=-1;
  NextFree:=-1;
  for I:=257 to ActMaxCode do
    if Previous^[I] and $C000<>0 then
      begin {Either free before or marked now}
        if PC<>-1 then Previous^[PC]:=-I {Link last item to this item} else NextFree:=I;
        PC:=I;
      end;
  if PC<>-1 then Previous^[PC]:=-ActMaxCode-1;
end;

function UnShrink: integer;
var InCode: integer;            {code read in}
    LastInCode: integer;        {last code read in}
    LastOutCode: Char;          {last code emitted}
    CodeSize: byte;             {Actual code size}
    StackPtr,                   {Stackpointer}
    NewCode,                    {Save new code read}
    CodeMask,                   {mask for coding}
    I: integer;                 {Index}
    A1,A2,A3,BitsToRead: integer;
begin
  if CompSize=MaxInt then
    begin   {Compressed Size was not in header!}
      Result:=Unzip_NotSupported;
      Exit;
    end;
  InPos:=0;            {Input buffer position}
  ReadPos:=-1;         {nothing read}
  {initialize window, bit buffer}
  W:=0;
  K:=0;
  B:=0;
  {Initialize pointers for various buffers}
  A1:=sizeof(Prev);
  A2:=sizeof(Prev)+sizeof(Cds);
  A3:=sizeof(Prev)+sizeof(Cds)+sizeof(StackType);
  PreviousCode:=PPrev(@Slide[0]);
  ActualCode:=PCds(@Slide[A1]);
  Stack:=PStackType(@Slide[A2]);
  WriteBuf:=PWriteBufType(@Slide[A3]);
  FillChar(Slide^,WSize,#0);
  {initialize free codes list}
  for I:=257 to MaxCode do PreviousCode^[I]:=-succ(I);
  NextFree:=257;
  StackPtr:=MaxStack;
  WritePtr:=0;
  CodeSize:=InitialCodeSize;
  CodeMask:=MaskBits[CodeSize];
  NeedBits(CodeSize);
  InCode:=B and CodeMask;
  DumpBits(CodeSize);
  LastInCode:=InCode;
  LastOutCode:=Char(InCode);
  if not WriteChar(LastOutCode) then
    begin
      Result:=Unzip_WriteErr;
      Exit;
    end;
  BitsToRead:=8*CompSize-CodeSize;   {Bits to be read}
  while (not TotalAbort) and (BitsToRead>=CodeSize) do
    begin
      NeedBits(CodeSize);
      InCode:=B and CodeMask;
      DumpBits(CodeSize);
      Dec(BitsToRead,CodeSize);
      if InCode=256 then
        begin            {Special code}
          NeedBits(CodeSize);
          InCode:=B and CodeMask;
          DumpBits(CodeSize);
          Dec(BitsToRead,CodeSize);
          case InCode of
            1: begin
                 Inc(CodeSize);
                 if CodeSize>FinalCodeSize then
                   begin
                     Result:=Unzip_ZipFileErr;
                     Exit;
                   end;
                 CodeMask:=MaskBits[CodeSize];
               end;
            2: ClearLeafNodes;
          else
            begin
              Result:=Unzip_ZipFileErr;
              Exit;
            end;
          end;
        end
      else
        begin
          NewCode:=InCode;
          if InCode<256 then
            begin          {Simple char}
              LastOutCode:=Char(InCode);
              if not WriteChar(LastOutCode) then
                begin
                  Result:=Unzip_WriteErr;
                  Exit;
                end;
            end
          else
            begin
              if PreviousCode^[InCode]<0 then
                begin
                  Stack^[StackPtr]:=LastOutCode;
                  Dec(StackPtr);
                  InCode:=LastInCode;
                end;
              while InCode>256 do
                begin
                  Stack^[StackPtr]:=ActualCode^[InCode];
                  Dec(StackPtr);
                  InCode:=PreviousCode^[InCode];
                end;
              LastOutCode:=Char(InCode);
              if not WriteChar(LastOutCode) then
                begin
                  Result:=Unzip_WriteErr;
                  Exit;
                end;
              for I:=succ(StackPtr) to MaxStack do
                if not WriteChar(Stack^[I]) then
                  begin
                    Result:=Unzip_WriteErr;
                    Exit;
                  end;
              StackPtr:=MaxStack;
            end;
          InCode:=NextFree;
          if InCode<=MaxCode then
            begin
              NextFree:=-PreviousCode^[InCode];   {Next node in free list}
              PreviousCode^[InCode]:=LastInCode;
              ActualCode^[InCode]:=LastOutCode;
            end;
          LastInCode:=NewCode;
        end;
    end;
  if TotalAbort then Result:=Unzip_UserAbort else
    if UnShrinkFlush then Result:=Unzip_OK else Result:=Unzip_WriteErr;
end;

///////////////////////////////////////////////////////////////////////////////
//
//      General function
//
///////////////////////////////////////////////////////////////////////////////

function FileUnzip(SrcZipFile,TargetDir,FileSpecs: string; Report: UnzipReportProc; Question: UnzipQuestionProc): integer;
var R: TZipRec;
    RC: integer;
    Buf,Target: string;
    StartOffset,Count: integer;
    RSize,CSize: cardinal;
    B: boolean;
begin
  Count:=0;
  RSize:=0;
  CSize:=0;
  StartOffset:=0;
  Result:=Unzip_MissingParameter;
  if (SrcZipFile='') or (TargetDir='') then Exit;
  Target:=TargetDir;
  ConvertPath(Target);
  if (Length(Target)<>0) and (Target[Length(Target)]<>'\') then Target:=Target+'\';
  Result:=Unzip_NotZipFile;
  if not IsZip(SrcZipFile,@StartOffset) then Exit;
  FillChar(ZipRec,sizeof(ZipRec),#0);
  Result:=Unzip_InternalError;
  RC:=GetFirstInZip(SrcZipFile,R);
  if RC<>Unzip_OK then Exit;
  if @Report<>nil then
  with ZipRec do {start of ZIP file}
    begin
      IsADir:=False;
      Filename:=SrcZipFile;
      Size:=UnZipSize(SrcZipFile,CompressSize);
      Ratio:=CalcRatio(CompressSize,Size);
      Status:=Unzip_Starting;
      Report(Status,@ZipRec);
    end; {start of ZIP file}
  ZipReport:=Report;
  while RC=Unzip_OK do
    begin
      if (Matches(FileSpecs,R.FileName)) then
        begin
          Inc(RSize,R.Size);
          Inc(CSize,R.CompressSize);
          Inc(R.HeaderOffset,StartOffset);
          Buf:=Target+R.Filename;
          with ZipRec do
            begin { report start of file }
              IsADir:=Buf[Length(Buf)] in ['\','/'];
              Time:=R.Time;
              Size:=R.Size;
              CompressSize:=R.CompressSize;
              Filename:=Buf;
              PackMethod:=R.PackMethod;
              Attr:=R.Attr;
              Ratio:=CalcRatio(CompressSize,Size);
              Status:=File_Starting;
              if not IsADir then ZipReport(Status,@ZipRec);
            end;  { start of file }
          B:=FileExists(Buf); { sigsegv here !!! }
          if (@Question<>nil) and (B) and (Question(@ZipRec)=False) then
            begin
              RC:=Unzip_OK;              { we are okay }
              with ZipRec do
                begin
                  Status:=File_Unzipping;
                  PackMethod:=9;           { skipped }
                  ZipReport(Size,@ZipRec);  { report uncompressed size }
                end;
            end
          else
            begin
              if B then SetFileAttributes(@Buf,0);
              RC:=UnzipFile(SrcZipFile,Buf,R.HeaderOffset,0,27); {Escape interrupts}
              if RC=Unzip_OK { reset the file attributes } then SetFileAttributes(@Buf,ZipRec.Attr);
            end;
          if RC=Unzip_OK then
            begin
              Inc(Count);
              with ZipRec do
                begin   { report end of file }
                  Status:=File_Completed;
                  if not IsADir then ZipReport(Status,@ZipRec);
                end; { end of file }
            end
          else
            begin { some error }
              ZipRec.Status:=File_Failure; {error}
              case RC of
                Unzip_CRCErr,
                Unzip_WriteErr,
                Unzip_Encrypted,
                Unzip_NotSupported: ZipReport(RC,@ZipRec);

                Unzip_ZipFileOpenError,
                Unzip_ReadErr,Unzip_UserAbort,
                Unzip_FileError,Unzip_InternalError,
                Unzip_InUse,Unzip_ZipFileErr:
                  begin
                    ZipRec.Status:=RC{unzip_SeriousError};
                    Result:=RC{unzip_SeriousError};   {Serious error, force abort}
                    ZipReport(Unzip_SeriousError,@ZipRec);
                    CloseZipFile(R);
                    SetUnZipReportProc(nil);
                    SetUnZipQuestionProc(nil);
                    Exit;
                  end;
              end; {case rc}
              RC:=Unzip_OK; { to continue if we fail with one file }
            {Continue;}
            end; {else}
        end; { if Matches }
      RC:=GetNextInZip(R);
    end; {while }
  CloseZipFile(R);               {Free memory used for central directory info}
  with ZipRec do
    begin { report end of ZIP file }
      Time:=-1;
      Attr:=-1;
      PackMethod:=0;
      Size:=RSize;
      CompressSize:=CSize;
      Filename:=SrcZipFile;
      Ratio:=CalcRatio(CompressSize,Size);
      Status:=Unzip_Completed;
      ZipReport(Status,@ZipRec);
    end;
  SetUnZipReportProc(nil);
  SetUnZipQuestionProc(nil);
  Result:=Count;
end;

function FileUnzipEx(SrcZipFile,TargetDir,FileSpecs: string): integer;
begin
  Result:=FileUnzip(SrcZipFile,TargetDir,FileSpecs,ZipReport,ZipQuestion);
end;

function ViewZip(SrcZipFile,FileSpecs: string; Report: UnzipReportProc): integer;
var RC: integer;
    R: TZipRec;
    Count,L: integer;
    RSize,CSize: cardinal;
begin
  Count:=0;
  RSize:=0;
  CSize:=0;
  L:=0;
  Result:=Unzip_MissingParameter;
  if (SrcZipFile='') or (@Report=nil) then Exit;
  Result:=Unzip_NotZipFile;
  if not IsZip(SrcZipFile,@L) then Exit;
  FillChar(ZipRec,sizeof(ZipRec),#0);
  Result:=Unzip_InternalError;
  RC:=GetFirstInZip(SrcZipFile,R);
  if RC<>Unzip_OK then Exit;
  while RC=Unzip_OK do
    begin
      if Matches(FileSpecs,R.FileName) then
        begin
          Inc(RSize,R.Size);
          Inc(CSize,R.CompressSize);
          with ZipRec do
            begin
              Time:=R.Time;
              Size:=R.Size;
              CompressSize:=R.CompressSize;
              FileName:=R.Filename;
              PackMethod:=R.PackMethod;
              Attr:=R.Attr;
              Ratio:=CalcRatio(CompressSize,Size);
              Status:=File_Unzipping;
            end;
          Inc(Count);
          Report(RC,@ZipRec);
        end; {matches}
      RC:=GetNextInZip(R);
    end; {while }
  CloseZipFile(R);
  with ZipRec do
    begin
      Time:=-1;
      Attr:=-1;
      PackMethod:=0;
      Size:=RSize;
      CompressSize:=CSize;
      FileName:=SrcZipFile;
      Ratio:=CalcRatio(CompressSize,Size);
      Status:=Unzip_Completed;
    end;
  Report(Count,@ZipRec);
  Result:=Count;
end;

function SetUnZipReportProc(aProc: UnzipReportProc): pointer;
begin
  Result:=@ZipReport;    {save and return original}
  @ZipReport:=@aProc;
end;

function SetUnZipQuestionProc(aProc: UnzipQuestionProc): pointer;
begin
  Result:=@ZipQuestion;  {save and return original}
  @ZipQuestion:=@aProc;
end;

function UnzipSize(SrcZipFile: string; var Compressed: cardinal): cardinal;
var RC: integer;
    R: TZipRec;
    Count: cardinal;
    F: file of byte;
begin
  Compressed:=0;
  Result:=0;
  if SrcZipFile='' then Exit;
  AssignFile(F,SrcZipFile);
  {$i-}
  Reset(F);
  {$i+}
  if IOResult<>0 then Exit;
  Count:=System.FileSize(F);
  CloseFile(F);
  Result:=Count;
  Compressed:=Count;
  if not IsZip(SrcZipFile,nil) then Exit;
  Count:=0;
  Compressed:=0;
  RC:=GetFirstInZip(SrcZipFile,R);
  if RC<>Unzip_OK then Exit;
  while RC=Unzip_OK do
    begin
      Inc(Count,R.Size);
      Inc(Compressed,R.CompressSize);
      RC:=GetNextInZip(R);
    end; {while }
  CloseZipFile(R);
  Result:=Count;
end;

function GetHeaderOffset(Filename: string; PEndOffset: PInteger): integer;
type
  BufT = array[0..63] of Char;
var Buffer: ^BufT;
    F: file of byte;
    I,J,K,L: integer;
begin
  Result:=-1;
  if Assigned(PEndOffset) then PEndOffset^:=-1;
  if Length(FileName)=0 then Exit;
  AssignFile(F,Filename);
  {$I-}
  Reset(F);
  {$I+}
  if IOResult<>0 then Exit;
  {$I-}
  L:=System.FileSize(F);
  if IOResult<>0 then;
  if Assigned(PEndOffset) then PEndOffset^:=L;
  if L<5 then { can't be zip file }
    begin
      CloseFile(F);
      if IOResult<>0 then;
      {$I+}
      Exit;
    end
  else
    if L>=64 then L:=63;
  Dec(L,L div 4);
  GetMem(Buffer,L);
  BlockRead(F,Buffer^,L,I);
  if IOResult<>0 then;
  CloseFile(F);
  if IOResult<>0 then;
  {$I+}
  K:=-1;
  if (Buffer^[0]='P') and (Buffer^[1]='K') and (Buffer^[2]=#3) and (Buffer^[3]=#4) then
    begin
      K:=0;
      if Assigned(PEndOffset) then PEndOffset^:=0;
    end
  else
    begin
      for J:=0 to (I-5) do
        if (Buffer^[J]='P') and (Buffer^[J+1]='K') and (Buffer^[J+2]=#3) AND (Buffer^[J+3]=#4) then
          begin
            K:=J;
            Break;
          end;
    end;
  if K<0 then
    if Assigned(PEndOffset) then PEndOffset^:=-1;
  Result:=K;
  FreeMem(Buffer,L);
end;

function UnzipFile(InName,OutName: string; Offset: cardinal; HFileAction: word; CM_Index: integer): integer;
var Err: integer;
    Header: PLocalHeader;
    Buf,Tmp: string;
    TimeDate: integer;
    OriginalCRC: cardinal;    {crc from zip-header}
    ZipT,aResult: integer;
    IDir: boolean;
begin
  if InUse then
    begin
      {take care of crashed applications!}
      if (LastUsedTime<>0) and (Abs(integer(GetTickCount)-LastUsedTime)>30000) then
        begin {1/2 minute timeout!!!}
          {do not close files or free slide, they were already freed when application crashed!}
          InUse:=False;
          {memory for huffman trees is lost}
        end
      else
        begin
          Result:=Unzip_InUse;
          Exit;
        end;
    end;
  InUse:=True;
  GetMem(Slide,WSize);
  FillChar(Slide[0],WSize,#0);
  AssignFile(InFile,InName);
  {$I-}
  Reset(InFile);
  {$I+}
  if IOResult<>0 then
    begin
      FreeMem(Slide,WSize);
      Result:=Unzip_ZipFileOpenError;
      InUse:=False;
      Exit;
    end;
  {$I-}
  Seek(InFile,Offset);       {seek to header position}
  {$I+}
  if IOResult<>0 then
    begin
      FreeMem(Slide,WSize);
      CloseFile(InFile);
      Result:=Unzip_ReadErr;
      InUse:=False;
      Exit;
    end;
  Header:=PLocalHeader(@InBuf);
  {$I-}
  BlockRead(InFile,Header^,sizeof(Header^));  {read in local header}
  {$I+}
  if IOResult<>0 then
    begin
      FreeMem(Slide,WSize);
      CloseFile(InFile);
      Result:=Unzip_ZipFileErr;
      InUse:=False;
      Exit;
    end;
  if Header^.Signature<>$04034B50 then
    begin
      FreeMem(Slide,WSize);
      CloseFile(InFile);
      Result:=Unzip_ZipFileErr;
      InUse:=False;
      Exit;
    end;
  {calculate offset of data}
  Offset:=Offset+Header^.FilenameLen+Header^.ExtraFieldLen+sizeof(TLocalHeader);
  TimeDate:=Header^.FileTimeDate;
  if (HuftType and 8)=0 then
    begin  {Size and crc at the beginning}
      CompSize:=Header^.CompressSize;
      UncompSize:=Header^.UncompressSize;
      OriginalCRC:=Header^.CRC32;
    end
  else
    begin
      CompSize:=MaxInt;           {Don't get a sudden zipeof!}
      UncompSize:=MaxInt;
      OriginalCRC:=0
    end;
  ZipT:=Header^.ZipType;     {0=stored, 6=imploded, 8=deflated}
  if ((1 shl ZipT) and GetSupportedMethods=0) then
    begin  {Not Supported!!!}
      FreeMem(Slide,WSize);
      CloseFile(InFile);
      Result:=Unzip_NotSupported;
      InUse:=False;
      Exit;
    end;
  HuftType:=Header^.BitFlag;
  if (HuftType and 1)<>0 then
    begin {encrypted}
      FreeMem(Slide,WSize);
      CloseFile(InFile);
      Result:=Unzip_Encrypted;
      InUse:=False;
      Exit;
    end;
  ReachedSize:=0;
  Seek(InFile,Offset);
  AssignFile(OutFile,OutName);
  {$I-}
  Rewrite(OutFile);
  {$I+}
  Err:=IOResult;
  {create directories not yet in path}
  ConvertPath(OutName);
  IDir:=OutName[Length(OutName)]='/';
  if (Err<>0) or (IDir) then
    begin {path not found}
      ForceDirectories(ExtractFilePath(OutName));
      if IDir then
        begin
          FreeMem(Slide,WSize);
          Result:=Unzip_Ok;    {A directory -> ok}
          CloseFile(InFile);
          InUse:=False;
          Exit;
        end;
      {$I-}
      Rewrite(OutFile);
      {$I+}
      Err:=IOResult;
    end;
  if Err<>0 then
    begin
      { can't create the file }
      Tmp:=ExtractFilePath(OutName);
      if (Tmp<>'') and (not DirectoryExists(Tmp)) then
        begin
          if ForceDirectories(Tmp) then
            begin
              {$I-}
              Rewrite(OutFile);
              {$I+}
              Err:=IOResult;
            end;
        end;
      if Err<>0 then
        begin
          { we can't create file, or directory }
          FreeMem(Slide,WSize);
          Result:=Unzip_WriteErr;
          CloseFile(InFile);
          InUse:=False;
          Exit;
        end;
    end;
  TotalAbort:=False;
  ZipEOF:=False;
  DlgHandle:=HFileAction;
  DlgNotify:=CM_Index;
  MessageLoop;
  OldPercent:=0;
  InitCrc32(CRC32val);
  {Unzip correct type}
  case ZipT of
    0   : aResult:=Copystored;
    1   : aResult:=UnShrink;
    2..5: aResult:=UnReduce(ZipT);
    6   : aResult:=Explode;
    8   : aResult:=Inflate;
  else
    aResult:=Unzip_NotSupported;
  end;
  Result:=aResult;
  if (aResult=Unzip_OK) and ((HuftType and 8)<>0) then
    begin {CRC at the end}
      DumpBits(K and 7);
      NeedBits(16);
      DumpBits(16);
      NeedBits(16);
      OriginalCRC:=(B and $FFFF) shl 16;
      DumpBits(16);
    end;
  {$I-}
  CloseFile(InFile);
  if IOResult<>0 then;
  CloseFile(OutFile);
  if IOResult<>0 then;
  {$I+}
  CRC32val:=FinalCrc32(CRC32val);
  if aResult<>0 then
    begin
      {$I-}
      Erase(OutFile);
      {$i+}
      if IOResult<>0 then;
    end
  else
    if OriginalCRC<>CRC32val then
      begin
        Result:=Unzip_CRCErr;
        {$I-}
        Erase(OutFile);
        {$I+}
        if IOResult<>0 then;
      end
    else
      begin
        OldPercent:=100;       {100 percent}
        if DlgHandle<>0 then SendMessage(DlgHandle,WM_COMMAND,DlgNotify,integer(@OldPercent));
        Reset(OutFile);
//        SetFileTime(OutFile,TimeDate); {set zipped time and date of oufile}
        Close(OutFile);
        if IOResult<>0 then;
      end;
  FreeMem(Slide,WSize);
  InUse:=False;
end;

function FillOutRec(var ZPRec: TZipRec): integer;
var Incr,Offs,Err: integer;
    Header: PHeader;
    Old: Char;
begin
  with ZPRec do
    begin
      Header:=PHeader(@Buf^[LocalStart]);
      if BufSize>=MaxInt-16 then
        begin {Caution: header bigger than buffer!}
          if ((LocalStart+sizeof(THeader))>BufSize) or
              (LocalStart+Header^.FilenameLen+Header^.ExtraFieldLen+
               Header^.FileCommentLen+sizeof(THeader)>BufSize) then
            begin {Read over end of header}
              System.Move(Buf^[LocalStart],Buf^[0],BufSize-LocalStart); {Move end to beginning in buffer}
              {$I-}
              {Read in full central dir, up to maxbufsize Bytes}
              BlockRead(DirFile,Buf^[BufSize-LocalStart],LocalStart,Err);
              {$I+}
              if (IOResult<>0) or (Err+LocalStart<sizeof(THeader)) then
                begin
                  Result:=Unzip_NoMoreItems;
                  Exit;
                end;
              LocalStart:=0;
              Header:=PHeader(@Buf^[LocalStart]);
            end;
        end;
      if (LocalStart+4<=BufSize) and (Header^.Signature=$06054B50) then
        begin
          {Main header}
          Result:=Unzip_NoMoreItems;
          Exit;
        end;
      if (LocalStart+sizeof(Header)>BufSize) or (LocalStart+Header^.FilenameLen+
          Header^.ExtraFieldLen+Header^.FileCommentLen+sizeof(THeader)>BufSize) or
          (Header^.Signature<>$02014B50) then
        begin
          Result:=Unzip_NoMoreItems;
          Exit;
        end;
      Size:=Header^.UncompressSize;
      CompressSize:=Header^.CompressSize;
      if Header^.OSMadeBy=0 then Attr:=Header^.ExternalAttr[0] else Attr:=0;
      Time:=Header^.FileTimeDate;
      HeaderOffset:=Header^.OffsetLocalHeader; {Other header size}
      PackMethod:=Header^.ZipType;
      Offs:=LocalStart+Header^.FilenameLen+sizeof(Header^);
      Old:=Buf^[Offs];
      Buf^[Offs]:=#0;  {Repair signature of next block!}
      SetLength(Filename,Header^.FilenameLen);
      CopyMemory(PChar(Filename),PChar(@Buf^[LocalStart+sizeof(Header^)]),Header^.FilenameLen);
      Buf^[Offs]:=Old;
      ConvertPath(Filename);
      Incr:=Header^.FilenameLen+Header^.ExtraFieldLen+Header^.FileCommentLen+sizeof(Header^);
      if Incr<=0 then
        begin
          Result:=Unzip_InternalError;
          Exit;
        end;
      Inc(LocalStart,Incr);
      Result:=Unzip_OK;
    end;
end;

function GetFirstInZip(ZipFilename: string; var ZPRec: TZipRec): integer;
var BufStart,HeaderStart,Start: integer;
    Err,I: integer;
    MainH: TMainHeader;
begin
  with ZPRec do
    begin
      Buf:=nil;
      AssignFile(DirFile,ZipFilename);
      {$I-}
      Reset(DirFile);
      {$I+}
      if IOResult<>0 then
        begin
          Result:=Unzip_FileError;
          Exit;
        end;
      Size:=System.FileSize(DirFile);
      if Size=0 then
        begin
          Result:=Unzip_FileError;
          {$I-}
          CloseFile(DirFile);
          {$I+}
          Exit;
        end;
      BufSize:=4096;     {in 4k-blocks}
      if Size>BufSize then BufStart:=Size-BufSize else
        begin
          BufStart:=0;
          BufSize:=Size;
        end;
      GetMem(Buf,succ(BufSize));     {#0 at the end of filename}
      {Search from back of file to central directory start}
      Start:=-1;    {Nothing found}
      repeat
        {$I-}
        Seek(DirFile,BufStart);
        {$I+}
        if IOResult<>0 then
          begin
            Result:=Unzip_FileError;
            FreeMem(Buf,succ(BufSize));
            Buf:=nil;
            {$I-}
            CloseFile(DirFile);
            {$I+}
            Exit;
          end;
        {$I-}
        BlockRead(DirFile,Buf^,BufSize,Err);
        {$I+}
        if (IOResult<>0) or (Err<>BufSize) then
          begin
            Result:=Unzip_FileError;
            FreeMem(Buf,succ(BufSize));
            Buf:=nil;
            {$I-}
            CloseFile(DirFile);
            {$I+}
            Exit;
          end;
        if BufStart=0 then Start:=MaxInt;
        for I:=BufSize-22 downto 0 do
          begin {Search buffer backwards}
            if ((Buf^[I]='P') and (Buf^[I+1]='K') and (Buf^[I+2]=#5) and (Buf^[I+3]=#6)) then
              begin {Header found!!!}
                Start:=BufStart+I;
                Break;
              end;
          end;
        if Start=-1 then
          begin {Nothing found yet}
            Dec(BufStart,BufSize-22);       {Full header in buffer!}
            if BufStart<0 then BufStart:=0;
          end;
      until Start>=0;
      if Start=MaxInt then
        begin {Nothing found}
          Result:=Unzip_FileError;
          FreeMem(Buf,succ(BufSize));
          Buf:=nil;
          {$I-}
          CloseFile(DirFile);
          {$I+}
          Exit;
        end;
      System.Move(Buf^[Start-BufStart],MainH,sizeof(MainH));
      HeaderStart:=MainH.HeadStart;
      LocalStart:=0;
      FreeMem(Buf,succ(BufSize));
      if LocalStart+sizeof(THeader)>Start then
        begin
          Buf:=nil;
          Result:=Unzip_InternalError;
          {$I-}
          CloseFile(DirFile);
          {$I+}
          Exit;
        end;
      BufStart:=HeaderStart;
      Start:=Start-HeaderStart+4; {size for central dir,Including main header signature}
      if Start>=MaxBufSize then { Max buffer size, limit of around 1000 items (for 16-bit)}
        BufSize:=MaxBufSize else BufSize:=Start;
      GetMem(Buf,succ(BufSize));
      {$I-}
      Seek(DirFile,BufStart);
      {$I+}
      if IOResult<>0 then
        begin
          Result:=Unzip_FileError;
          FreeMem(Buf,succ(BufSize));
          Buf:=nil;
          {$I-}
          CloseFile(DirFile);
          {$I+}
          Exit;
        end;
      {$I-}
      BlockRead(DirFile,Buf^,BufSize,Err); {Read in full central dir, up to maxbufsize Bytes}
      {$I+}
      if IOResult<>0 then
        begin
          Result:=Unzip_FileError;
          FreeMem(Buf,succ(BufSize));
          Buf:=nil;
          {$I-}
          CloseFile(DirFile);
          {$I+}
          Exit;
        end;
      Err:=FillOutRec(ZPRec);
      if Err<>Unzip_OK then
        begin
          CloseZipFile(ZPRec);
          Result:=Err;
          Exit;
        end;
      Result:=Err;
    end;
end;

function GetNextInZip(var ZPRec: TZipRec): integer;
var Err: integer;
begin
  with ZPRec do
    begin
      if Buf<>nil then
        begin  {Main Header at the end}
          Err:=FilloutRec(ZPRec);
          if Err<>Unzip_OK then CloseZipFile(ZPRec);
          Result:=Err;
        end
      else Result:=Unzip_NoMoreItems;
    end;
end;

function IsZip(Filename: string; PStartOffset: PInteger): boolean;
var J,L,Err,Buf: integer;
    F: file of byte;
    OldCurDir: string;
begin
  Result:=False;
  if Assigned(PStartOffset) then PStartOffSet^:=-1;
  AssignFile(F,Filename);
  {$I-}
  Reset(F);
  BlockRead(F,Buf,sizeof(integer));
  {$I+}
  if IOResult=0 then
    begin
      {$I-}
      CloseFile(F);
      if IOResult<>0 then;
      {$I+}
      if Buf=$04034b50 then
        begin
          Result:=True;
          if Assigned(PStartOffset) then PStartOffset^:=0;
        end
      else
        begin
          J:=GetHeaderOffset(Filename,nil);
          Result:=J>0;
          if Assigned(PStartOffset) then PStartOffset^:=J;
        end;
      Exit;
    end;
  {$I-}
  CloseFile(F);
  {$I+}
  if IOResult<>0 then;
end;

procedure CloseZipFile(var ZPRec: TZipRec); {Only free buffer, file only open in Getfirstinzip}
begin
  with ZPRec do
    begin
      if Buf<>nil then
        begin
          {$I-}
          CloseFile(DirFile);
          if IOResult<>0 then;
          {$I+}
          FreeMem(Buf,succ(BufSize));     {#0 at the end of filename}
          Buf:=nil;
        end;
    end;
end;

initialization
   Slide:=nil;                { Unused }
   InUse:=False;              { Not yet in use! }
   LastUsedTime:=0;           { Not yet used }
   SetUnZipReportProc(nil);
   SetUnZipQuestionProc(nil);

end.

