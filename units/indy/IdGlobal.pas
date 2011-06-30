// 19-nov-2002
unit IdGlobal;

interface

{$I IdCompilerDefines.inc}

uses KOL { ,
  Classes } {,
  IdException},
  SysUtils;

const
  IdTimeoutDefault = -1;
  IdTimeoutInfinite = -2;

  wsOk = 1;
  wsErr = 0;

  IdPORT_ECHO = 7;
  IdPORT_DISCARD = 9;
  IdPORT_SYSTAT = 11;
  IdPORT_DAYTIME = 13;
  IdPORT_NETSTAT = 15;
  IdPORT_QOTD = 17;
  IdPORT_CHARGEN = 19; {UDP Server!}
  IdPORT_FTP = 21;
  IdPORT_TELNET = 23;
  IdPORT_SMTP = 25;
  IdPORT_TIME = 37;
  IdPORT_WHOIS = 43;
  IdPORT_DOMAIN = 53;
  IdPORT_TFTP = 69;
  IdPORT_GOPHER = 70;
  IdPORT_FINGER = 79;
  IdPORT_HTTP = 80;
  IdPORT_HOSTNAME = 101;
  IdPORT_POP2 = 109;
  IdPORT_POP3 = 110;
  IdPORT_AUTH = 113;
  IdPORT_NNTP = 119;
  IdPORT_SNTP = 123;
  IdPORT_IMAP4 = 143;
  IdPORT_SSL = 443;
  IdPORT_LPD = 515;
  IdPORT_DICT = 2628;
  IdPORT_IRC = 6667;

  gsIdProductName = 'Indy'; { do not localize }
  gsIdVersion = '8.0.25'; { do not localize }
  //
  CHAR0 = #0;
  BACKSPACE = #8;
  LF = #10;
  CR = #13;
  EOL = CR + LF;
  TAB = #9;
  CHAR32 = #32;
{$IFDEF Linux}
  GPathSep = '/'; { do not localize }
{$ELSE}
  GPathSep = '\'; { do not localize }
{$ENDIF}

type
{$IFDEF LINUX}
  TThreadPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest,
    pTimeCritical);
{$ENDIF}

//  TStringEvent = procedure(ASender: TComponent; const AString: string);

  TPosProc = function(const Substr, S: string): Integer;

  TIdMimeTable = object(TObj)
  private
    FAutofill:Boolean;
    procedure Init; virtual;
  protected
    FMIMEList: PStrList;//TStringList;
    FFileExt: PStrList;
  public
    procedure BuildCache; virtual;
    function GetFileMIMEType(const fileName: string): string;
    function getDefaultFileExt(const MIMEType: string): string;
     { constructor Create(Autofill: boolean = true); virtual;
     } destructor Destroy;
   virtual; end;
PIdMimeTable=^TIdMimeTable;
function NewIdMimeTable(Autofill: boolean = true):PIdMimeTable;
 type

  TCharSet = (csGB2312, csBig5, csIso2022jp, csEucKR, csIso88591);

{$IFDEF LINUX}
  TIdPID = Integer;
{$ELSE}
  TIdPID = LongWord;
{$ENDIF}

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
TThreadPriority=Integer;

  //This is called whenever there is a failure to retreive the time zone information
{
EIdFailedToRetreiveTimeZoneInfo = object(EIdException);
PIdFailedToRetreiveTimeZoneInfo=^EIdFailedToRetreiveTimeZoneInfo; type  MyStupid3137=DWord;
}
  //This usually is a property editor exception
{
  EIdCorruptServicesFile = object(EIdException);
PdFailedToRetreiveTimeZoneInfo=^IdFailedToRetreiveTimeZoneInfo; type  MyStupid86104=DWord;
}

{$IFNDEF VCL5ORABOVE}
function AnsiSameText(const S1, S2: string): Boolean;
function IncludeTrailingBackSlash(const APath: string): string;
procedure FreeAndNil(var Obj);
{$ENDIF}

procedure CommaSeperatedToStringList(AList: PStrList; const Value: string);
function CopyFileTo(const Source, Destination: string): Boolean;
function CurrentProcessId: TIdPID;
function DateTimeToGmtOffSetStr(ADateTime: TDateTime; SubGMT: Boolean): string;
function DateTimeToInternetStr(const Value: TDateTime): string;
procedure DebugOutput(const AText: string);
function Fetch(var AInput: string; const ADelim: string = ' '; const ADelete: { do not localize }
  Boolean = true)
  : string;
function FileSizeByName(sFilename: string): cardinal;
function GetMIMETypeFromFile(AFile: TFileName): string;
function GetSystemLocale: TCharSet;
function GetTickCount: Cardinal;
function GmtOffsetStrToDateTime(S: string): TDateTime;
function IntToBin(Value: cardinal): string;
function IdPorts: PList;
function IsCurrentThread(AThread: PThread{TThread}): boolean;
function IsNumeric(c: char): Boolean;
function InMainThread: boolean;
function Max(AValueOne, AValueTwo: Integer): Integer;
function MakeTempFilename: string;
function Min(AValueOne, AValueTwo: Integer): Integer;
function OffsetFromUTC: TDateTime;
procedure ParseURI(URI: string; var Protocol, Host, path, Document, Port,
  Bookmark: string);
function PosInStrArray(SearchStr: string; Contents: array of string;
  const CaseSensitive: Boolean = True): Integer;
function RightStr(st: string; Len: Integer): string;
function ROL(val: LongWord; shift: Byte): LongWord;
function ROR(val: LongWord; shift: Byte): LongWord;
function RPos(const ASub, AIn: string; AStart: Integer = -1): Integer;
function SetLocalTime(Value: TDateTime): boolean;
procedure SetThreadPriority(AThread: PThread{TThread}; const APriority: TThreadPriority);
procedure Sleep(ATime: cardinal);
function StrToCard(AVal: string): Cardinal;
function StrInternetToDateTime(Value: string): TDateTime;
function StrToDay(const ADay: string): Byte;
function StrToMonth(const AMonth: string): Byte;
function TimeZoneBias: Double;
function UpCaseFirst(S: string): string;
function GMTToLocalDateTime(S: string): TDateTime;
function URLDecode(psSrc: string): string;
function URLEncode(const psSrc: string): string;

var
  IndyPos: TPosProc = nil;
{$IFDEF LINUX}
  GOffsetFromUTC: TDateTime = 0;
  GSystemLocale: TCharSet = csIso88591;
  GTimeZoneBias: Double = 0;
{$ENDIF}

implementation

uses
{$IFDEF LINUX}
  Libc,
  IdStack,
{$ELSE}
//  Registry,
  Windows,
{$ENDIF}
  IdResourceStrings,
  IdURI;

const
  WhiteSpace = [#0..#12, #14..' ']; {do not localize}

var
  FIdPorts: PList;
{$IFNDEF LINUX}
  ATempPath: string;
{$ENDIF}

function RawStrInternetToDateTime(var Value: string): TDateTime;
var
  i: Integer;
  Dt, Mo, Yr, Ho, Min, Sec: Word;
  sTime: string;
begin
  Result := 0.0;
  Value := Trim(Value);
  if length(Value) = 0 then
  begin
    Exit;
  end;

  try
    if StrToDay(Copy(Value, 1, 3)) > 0 then
    begin
      Fetch(Value);
    end;
    Dt := StrToIntDef(Fetch(Value), 1);
    Value := TrimLeft(Value);
    Mo := StrToMonth(Fetch(Value));
    Value := TrimLeft(Value);
    Yr := StrToIntDef(Fetch(Value), 1900);
    if Yr < 80 then
    begin
      Inc(Yr, 2000);
    end
    else
      if Yr < 100 then
    begin
      Inc(Yr, 1900);
    end;

    Result := EncodeDate(Yr, Mo, Dt);
    Value := TrimLeft(Value);
    i := IndyPos(':', Value); {do not localize}
    if i > 0 then
    begin
      sTime := fetch(Value, ' '); {do not localize}
      Ho := StrToIntDef(Fetch(sTime, ':'), 0); {do not localize}
      Min := StrToIntDef(Fetch(sTime, ':'), 0); {do not localize}
      Sec := StrToIntDef(Fetch(sTime), 0);
      Result := Result + EncodeTime(Ho, Min, Sec, 0);
    end;
    Value := TrimLeft(Value);
  except
    Result := 0.0;
  end;
end;

{$IFNDEF VCL5ORABOVE}

function AnsiSameText(const S1, S2: string): Boolean;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1)
    , Length(S1), PChar(S2), Length(S2)) = 2;
end;

function IncludeTrailingBackSlash(const APath: string): string;
begin
  Result := APath;
  if not IsPathDelimiter(Result, Length(Result)) then
  begin
    Result := Result + '\'; {do not localize}
  end;
end;

procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;
  P.Free;
end;
{$ENDIF}

{$IFNDEF LINUX}
{$IFNDEF VCL5ORABOVE}

{function CreateTRegistry: TRegistry;
begin
  Result := TRegistry.Create;
end;}
{$ELSE}

{function CreateTRegistry: TRegistry;
begin
  Result := TRegistry.Create(KEY_READ);
end;}
{$ENDIF}
{$ENDIF}

function Max(AValueOne, AValueTwo: Integer): Integer;
begin
  if AValueOne < AValueTwo then
  begin
    Result := AValueTwo
  end
  else
  begin
    Result := AValueOne;
  end;
end;

function Min(AValueOne, AValueTwo: Integer): Integer;
begin
  if AValueOne > AValueTwo then
  begin
    Result := AValueTwo
  end
  else
  begin
    Result := AValueOne;
  end;
end;

{This should never be localized}

function DateTimeToInternetStr(const Value: TDateTime): string;
const
  wdays: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'); { do not localize }
  monthnames: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', { do not localize }
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}
var
  wDay,
    wMonth,
    wYear: Word;
begin
  DecodeDate(Value, wYear, wMonth, wDay);
  Result := Format('%s, %d %s %d %s %s', {do not localize}
    [wdays[DayOfWeek(Value)], wDay, monthnames[wMonth],
    wYear, FormatDateTime('hh:nn:ss', Value), {do not localize}
      DateTimeToGmtOffSetStr(OffsetFromUTC, False)]);
end;

function StrInternetToDateTime(Value: string): TDateTime;
begin
  Result := RawStrInternetToDateTime(Value);
end;

procedure CommaSeperatedToStringList(AList: PStrList; const Value: string);
var
  iStart,
    iEnd,
    iQuote,
    iPos,
    iLength: integer;
  sTemp: string;
begin
  iQuote := 0;
  iPos := 1;
  iLength := Length(Value);
  AList.Clear;
  while (iPos <= iLength) do
  begin
    iStart := iPos;
    iEnd := iStart;
    while (iPos <= iLength) do
    begin
      if Value[iPos] = '"' then {do not localize}
      begin
        inc(iQuote);
      end;
      if Value[iPos] = ',' then {do not localize}
      begin
        if iQuote <> 1 then
        begin
          break;
        end;
      end;
      inc(iEnd);
      inc(iPos);
    end;
    sTemp := Trim(Copy(Value, iStart, iEnd - iStart));
    if Length(sTemp) > 0 then
    begin
      AList.Add(sTemp);
    end;
    iPos := iEnd + 1;
    iQuote := 0;
  end;
end;

{$IFDEF LINUX}

function CopyFileTo(const Source, Destination: string): Boolean;
var
  SourceStream: PStream;
begin
  result := false;
  if not FileExists(Destination) then
  begin
    SourceStream := PStream.Create(Source, fmOpenRead);
    try
      with PStream.Create(Destination, fmCreate) do
      try
        CopyFrom(SourceStream, 0);
      finally free;
      end;
    finally SourceStream.free;
    end;
    result := true;
  end;
end;
{$ELSE}

function CopyFileTo(const Source, Destination: string): Boolean;
begin
  Result := CopyFile(PChar(Source), PChar(Destination), true);
end;
{$ENDIF}

{$IFNDEF LINUX}

function TempPath: string;
var
  i: integer;
begin
  SetLength(Result, MAX_PATH);
  i := GetTempPath(Length(Result), PChar(Result));
  SetLength(Result, i);
  IncludeTrailingBackSlash(Result);
end;
{$ENDIF}

function MakeTempFilename: string;
begin
{$IFDEF LINUX}
  Result := tempnam(nil, 'Indy'); {do not localize}
{$ELSE}
  SetLength(Result, MAX_PATH + 1);
  GetTempFileName(PChar(ATempPath), 'Indy', 0, PChar(result)); {do not localize}
  Result := PChar(Result);
{$ENDIF}
end;

function RPos(const ASub, AIn: string; AStart: Integer = -1): Integer;
var
  i: Integer;
  LStartPos: Integer;
  LTokenLen: Integer;
begin
  result := 0;
  LTokenLen := Length(ASub);
  if AStart = -1 then
  begin
    AStart := Length(AIn);
  end;
  if AStart < (Length(AIn) - LTokenLen + 1) then
  begin
    LStartPos := AStart;
  end
  else
  begin
    LStartPos := (Length(AIn) - LTokenLen + 1);
  end;
  for i := LStartPos downto 1 do
  begin
    if AnsiSameText(Copy(AIn, i, LTokenLen), ASub) then
    begin
      result := i;
      break;
    end;
  end;
end;

function GetSystemLocale: TCharSet;
begin
{$IFDEF LINUX}
  Result := GSystemLocale;
{$ELSE}
  case SysLocale.PriLangID of
    LANG_CHINESE:
      if SysLocale.SubLangID = SUBLANG_CHINESE_SIMPLIFIED then
        Result := csGB2312
      else
        Result := csBig5;
    LANG_JAPANESE: Result := csIso2022jp;
    LANG_KOREAN: Result := csEucKR;
  else
    Result := csIso88591;
  end;
{$ENDIF}
end;

function FileSizeByName(sFilename: string): cardinal;
var
  sFile: PStream;
begin
  sFile := NewFileStream(sFilename, fmOpenRead or fmShareDenyNone);
  try
    result := sFile.Size;
  finally
    sFile.free;
  end;
end;

function RightStr(st: string; Len: Integer): string;
begin
  if (Len > Length(st)) or (Len < 0) then
  begin
    Result := st;
  end
  else
  begin
    Result := Copy(St, Length(st) - Len, Len);
  end;
end;

{$IFDEF LINUX}

function OffsetFromUTC: TDateTime;
begin
  Result := GOffsetFromUTC;
end;
{$ELSE}

function OffsetFromUTC: TDateTime;
var
  iBias: Integer;
  tmez: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(tmez) of
    TIME_ZONE_ID_INVALID:
{      raise EIdFailedToRetreiveTimeZoneInfo.Create(RSFailedTimeZoneInfo)};
    TIME_ZONE_ID_UNKNOWN:
      iBias := tmez.Bias;
    TIME_ZONE_ID_DAYLIGHT:
      iBias := tmez.Bias + tmez.DaylightBias;
    TIME_ZONE_ID_STANDARD:
      iBias := tmez.Bias + tmez.StandardBias;
  else
{    raise EIdFailedToRetreiveTimeZoneInfo.Create(RSFailedTimeZoneInfo)};
  end;
  Result := EncodeTime(Abs(iBias) div 60, Abs(iBias) mod 60, 0, 0);
  if iBias > 0 then
  begin
    Result := 0 - Result;
  end;
end;
{$ENDIF}

function StrToCard(AVal: string): Cardinal;
begin
  Result := StrToInt64Def(Trim(AVal), 0);
end;

{$IFDEF LINUX}

function TimeZoneBias: Double;
begin
  Result := GTimeZoneBias;
end;
{$ELSE}

function TimeZoneBias: Double;
var
  ATimeZone: TTimeZoneInformation;
begin
  if (GetTimeZoneInformation(ATimeZone) = TIME_ZONE_ID_DAYLIGHT) then
  begin
    result := ATimeZone.Bias + ATimeZone.DaylightBias;
  end
  else
  begin
    result := ATimeZone.Bias + ATimeZone.StandardBias;
  end;
  Result := Result / 1440;
end;
{$ENDIF}

function GetTickCount: Cardinal;
begin
{$IFDEF LINUX}
  Result := clock div (CLOCKS_PER_SEC div 1000);
{$ELSE}
  Result := Windows.GetTickCount;
{$ENDIF}
end;

{$IFDEF LINUX}

function SetLocalTime(Value: TDateTime): boolean;
begin
  result := False;
end;
{$ELSE}

function SetLocalTime(Value: TDateTime): boolean;
var
  SysTimeVar: TSystemTime;
begin
  DateTimeToSystemTime(Value, SysTimeVar);
  Result := Windows.SetLocalTime(SysTimeVar);
end;
{$ENDIF}

function IdPorts: PList;
var
  sLocation, s: string;
  idx, i, iPrev, iPosSlash: integer;
  sl: PStrList;
begin
  if FIdPorts = nil then
  begin
    FIdPorts :=  NewList;
{$IFDEF LINUX}
    sLocation := '/etc/'; {do not localize}
{$ELSE}
    SetLength(sLocation, MAX_PATH);
    SetLength(sLocation, GetWindowsDirectory(pchar(sLocation), MAX_PATH));
    sLocation := IncludeTrailingBackslash(sLocation);
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      sLocation := sLocation + 'system32\drivers\etc\'; {do not localize}
    end;
{$ENDIF}
    sl := NewStrList;
    try
      sl.LoadFromFile(sLocation + 'services'); {do not localize}
      iPrev := 0;
      for idx := 0 to sl.Count - 1 do
      begin
        s := sl.Items[idx];
        iPosSlash := IndyPos('/', s); {do not localize}
        if (iPosSlash > 0) and (not (IndyPos('#', s) in [1..iPosSlash])) then { do not localize }
          {do not localize}
        begin
          i := iPosSlash;
          repeat
            dec(i);
            if i = 0 then
            begin
{              raise EIdCorruptServicesFile.CreateFmt(RSCorruptServicesFile,
                [sLocation + 'services']);} {do not localize}
            end;
          until s[i] in WhiteSpace;
          i := StrToInt(Copy(s, i + 1, iPosSlash - i - 1));
          if i <> iPrev then
          begin
            FIdPorts.Add(TObject(i));
          end;
          iPrev := i;
        end;
      end;
    finally
      sl.Free;
    end;
  end;
  Result := FIdPorts;
end;

function Fetch(var AInput: string; const ADelim: string = ' '; const ADelete: { do not localize }
  Boolean = true)
  : string;
var
  iPos: Integer;
begin
  if ADelim = #0 then
  begin
    iPos := Pos(ADelim, AInput);
  end
  else
  begin
    iPos := IndyPos(ADelim, AInput);
  end;
  if iPos = 0 then
  begin
    Result := AInput;
    if ADelete then
    begin
      AInput := ''; { do not localize }
    end;
  end
  else
  begin
    result := Copy(AInput, 1, iPos - 1);
    if ADelete then
    begin
      Delete(AInput, 1, iPos + Length(ADelim) - 1);
    end;
  end;
end;

function PosInStrArray(SearchStr: string; Contents: array of string; const
  CaseSensitive: Boolean = True): Integer;
begin
  for Result := Low(Contents) to High(Contents) do
  begin
    if CaseSensitive then
    begin
      if SearchStr = Contents[Result] then
      begin
        Exit;
      end;
    end
    else
    begin
      if ANSISameText(SearchStr, Contents[Result]) then
      begin
        Exit;
      end;
    end;
  end;
  Result := -1;
end;

function IsCurrentThread(AThread: PThread{TThread}): boolean;
begin
  result := AThread.ThreadID = GetCurrentThreadID;
end;

function IsNumeric(c: char): Boolean;
begin
  Result := Pos(c, '0123456789') > 0; {do not localize}
end;

function StrToDay(const ADay: string): Byte;
begin
  Result := Succ(PosInStrArray(Uppercase(ADay),
    ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'])); {do not localize}
end;

function StrToMonth(const AMonth: string): Byte;
begin
  Result := Succ(PosInStrArray(Uppercase(AMonth),
    ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV',
      'DEC'])); {do not localize}
end;

function UpCaseFirst(S: string): string;
begin
  Result := LowerCase(S);
  if Result <> '' then { do not localize }
  begin
    Result[1] := UpCase(Result[1]);
  end;
end;

function DateTimeToGmtOffSetStr(ADateTime: TDateTime; SubGMT: Boolean): string;
var
  AHour, AMin, ASec, AMSec: Word;
begin
  if (ADateTime = 0.0) and SubGMT then
  begin
    Result := 'GMT'; {do not localize}
    Exit;
  end;
  DecodeTime(ADateTime, AHour, AMin, ASec, AMSec);
  Result := Format(' %0.2d%0.2d', [AHour, AMin]); {do not localize}
  if ADateTime < 0.0 then
  begin
    Result[1] := '-'; {do not localize}
  end
  else
  begin
    Result[1] := '+'; {do not localize}
  end;
end;

function GetMIMETypeFromFile(AFile: TFileName): string;
var
  MIMEMap: PIdMIMETable;
begin
  MIMEMap := NewIdMimeTable(True);//TIdMimeTable.Create(true);
  try
    result := MIMEMap.GetFileMIMEType(AFile);
  finally
    MIMEMap.Free;
  end;
end;

procedure ParseURI(URI: string; var Protocol, Host, path, Document, Port,
  Bookmark: string);
var
  TMP:PIdURI;
begin
  TMP:=NewIdURI;
  TMP.ParseURI(URI, Protocol, Host, path, Document, Port, Bookmark);
//  TIdURI.ParseURI(URI, Protocol, Host, path, Document, Port, Bookmark);
  TMP.Free;
end;

function GmtOffsetStrToDateTime(S: string): TDateTime;
begin
  Result := 0.0;
  S := Copy(Trim(s), 1, 5);
  if Length(S) > 0 then
  begin
    if s[1] in ['-', '+'] then {do not localize}
    begin
      try
        Result := EncodeTime(StrToInt(Copy(s, 2, 2)), StrToInt(Copy(s, 4, 2)),
          0, 0);
        if s[1] = '-' then {do not localize}
        begin
          Result := -Result;
        end;
      except
        Result := 0.0;
      end;
    end;
  end;
end;

function GMTToLocalDateTime(S: string): TDateTime;
var
  DateTimeOffset: TDateTime;
begin
  Result := RawStrInternetToDateTime(S);
  if Length(S) < 5 then
  begin
    DateTimeOffset := 0.0
  end
  else
  begin
    DateTimeOffset := GmtOffsetStrToDateTime(S);
  end;
  if DateTimeOffset < 0.0 then
  begin
    Result := Result + System.Abs(DateTimeOffset);
  end
  else
  begin
    Result := Result - DateTimeOffset;
  end;
  Result := Result + OffSetFromUTC;
end;

procedure Sleep(ATime: cardinal);
begin
{$IFDEF LINUX}
  GStack.WSSelect(nil, nil, nil, ATime)
{$ELSE}
  Windows.Sleep(ATime);
{$ENDIF}
end;

function IntToBin(Value: cardinal): string;
var
  i: Integer;
begin
  SetLength(result, 32);
  for i := 1 to 32 do
  begin
    if ((Value shl (i - 1)) shr 31) = 0 then
      result[i] := '0' {do not localize}
    else
      result[i] := '1'; {do not localize}
  end;
end;

function CurrentProcessId: TIdPID;
begin
{$IFDEF LINUX}
  Result := getpid;
{$ELSE}
  Result := GetCurrentProcessID;
{$ENDIF}
end;

function ROL(val: LongWord; shift: Byte): LongWord; assembler;
asm
  mov  eax, val;
  mov  cl, shift;
  rol  eax, cl;
end;

function ROR(val: LongWord; shift: Byte): LongWord; assembler;
asm
  mov  eax, val;
  mov  cl, shift;
  ror  eax, cl;
end;

procedure DebugOutput(const AText: string);
begin
{$IFDEF LINUX}
  __write(stderr, AText, Length(AText));
  __write(stderr, EOL, Length(EOL));
{$ELSE}
  OutputDebugString(PChar(AText));
{$ENDIF}
end;

function InMainThread: boolean;
begin
  result := GetCurrentThreadID = MainThreadID;
end;

{$IFDEF Linux}

procedure TIdMimeTable.BuildCache;
begin
end;
{$ELSE}

procedure TIdMimeTable.BuildCache;
var
//  reg: TRegistry;
  KeyList: PStrList;
  i: Integer;
begin
//  Reg := CreateTRegistry;
  try
    KeyList := NewStrList;//PStrList.create;
    try
//      Reg.RootKey := HKEY_CLASSES_ROOT;
//      Reg.OpenKeyReadOnly('\'); {do not localize}
{      Reg.GetKeyNames(KeyList);}
//      reg.Closekey;
      for i := 0 to KeyList.Count - 1 do
      begin
        if Copy(KeyList.Items[i], 1, 1) = '.' then {do not localize}
        begin
//          reg.OpenKeyReadOnly(KeyList.Items[i]);
//          if Reg.ValueExists('Content Type') then {do not localize}
          begin
//            FFileExt.Values[KeyList.Items[i]] := Reg.ReadString('Content Type'); { do not localize }
              {do not localize}
          end;
//          reg.CloseKey;
        end;
      end;
//      Reg.OpenKeyreadOnly('\MIME\Database\Content Type'); {do not localize}

      KeyList.Clear;

{      Reg.GetKeyNames(KeyList);}
//      reg.Closekey;
      for i := 0 to KeyList.Count - 1 do
      begin
//        Reg.OpenKeyreadOnly('\MIME\Database\Content Type\' + KeyList.Items[i]); { do not localize }
          {do not localzie}
//        FMIMEList.Values[reg.ReadString('Extension')] := KeyList.Items[i]; { do not localize }
          {do not localize}
//        Reg.CloseKey;
      end;
    finally
      KeyList.Free;
    end;
  finally
//    reg.free;
  end;
end;
{$ENDIF}

 { constructor TIdMimeTable.Create(Autofill: boolean);
 } 
function NewIdMimeTable (Autofill: boolean):PIdMimeTable;
begin
  New( Result, Create );
  with Result^ do
    FAutofill:=Autofill;
  Result.Init;
{  with Result^ do
  begin
    FFileExt := NewStrList;//PStrList.Create;
    FMIMEList := NewStrList;//PStrList.Create;
    if Autofill then
      BuildCache;
  end;}
end;

procedure TIdMimeTable.Init;
begin
  FFileExt := NewStrList;//PStrList.Create;
  FMIMEList := NewStrList;//PStrList.Create;
  if FAutofill then
    BuildCache;
end;

destructor TIdMimeTable.Destroy;
{ virtual;} begin
  FreeAndNil(FMIMEList);
  FreeAndNil(FFileExt);
  inherited;
end;

function TIdMimeTable.getDefaultFileExt(const MIMEType: string): string;
begin
  result := FMIMEList.Values[MIMEType];
  if Length(result) = 0 then
  begin
    BuildCache;
    result := FMIMEList.Values[MIMEType];
    ;
  end;
end;

function TIdMimeTable.GetFileMIMEType(const fileName: string): string;
begin
  result := FFileExt.Values[ExtractFileExt(FileName)];
  if Length(result) = 0 then
  begin
    BuildCache;
    result := FMIMEList.Values[ExtractFileExt(FileName)];
    if Length(result) = 0 then
    begin
      result := 'application/octet-stream'; {do not localize}
    end;
  end;
end;

procedure SetThreadPriority(AThread: PThread{TThread}; const APriority: TThreadPriority);
begin
{$IFDEF LINUX}
{$ELSE}
  AThread.ThreadPriority{Priority} := APriority;
{$ENDIF}
end;

function URLDecode(psSrc: string): string;
var
  i: Integer;
  ESC: string[2];
  CharCode: integer;
begin
  Result := ''; { do not localize }
  psSrc := StringReplace(psSrc, '+', ' ', [rfReplaceAll]); {do not localize}
  i := 1;
  while i <= Length(psSrc) do
  begin
    if psSrc[i] <> '%' then { do not localize }
    begin {do not localize}
      Result := Result + psSrc[i]
    end
    else
    begin
      Inc(i);
      ESC := Copy(psSrc, i, 2);
      Inc(i, 1);
      try
        CharCode := StrToInt('$' + ESC); {do not localize}
        if (CharCode > 0) and (CharCode < 256) then
          Result := Result + Char(CharCode);
      except
      end;
    end;
    Inc(i);
  end;
end;

function URLEncode(const psSrc: string): string;
const
  UnsafeChars = ' *#%<>'; {do not localize}
var
  i: Integer;
begin
  Result := ''; { do not localize }
  for i := 1 to Length(psSrc) do
  begin
    if (IndyPos(psSrc[i], UnsafeChars) > 0) or (psSrc[i] >= #$80) then
    begin
      Result := Result + '%' + IntToHex(Ord(psSrc[i]), 2); {do not localize}
    end
    else
    begin
      Result := Result + psSrc[i];
    end;
  end;
end;

function SBPos(const Substr, S: string): Integer;
begin
  Result := Pos(Substr, S);
end;

initialization
{$IFDEF LINUX}
{$ELSE}
  ATempPath := TempPath;
{$ENDIF}
  if LeadBytes = [] then
  begin
    IndyPos := SBPos;
  end
  else
  begin
    IndyPos := AnsiPos;
  end;
finalization
  FIdPorts.Free;
end.
