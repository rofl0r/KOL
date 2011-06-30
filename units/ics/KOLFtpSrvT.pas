unit FtpSrvT;

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$H+}       { Use long strings                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125} { C++ Builder V4.0                    }
    {$ObjExportAll On}
{$ENDIF}

const
    FtpSrvT_Unit       = 102;
    CopyRight : String = ' FtpSrvT  (c) 1999-2000 F. Piette V1.02 ';

function FileUtcStr(cFileName : String) : String;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
implementation
uses KOL, 
    WinTypes, WinProcs, SysUtils;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function PadIntZero(nWord  : Word;
                    nWidth : Byte): String;
var
    cResult : String;
begin
    cResult := IntToStr(nWord);
    while Length(cResult) < nWidth do
        cResult := '0' + cResult;

    Result := cResult;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TimeDateStr(dDateTime : TDateTime) : String;
var
    nYear, nMonth, nDay, nHours, nMinutes, nSeconds, nMilliSecs : Word;
begin
    DecodeDate(dDateTime, nYear, nMonth, nDay);
    DecodeTime(dDateTime, nHours, nMinutes, nSeconds, nMilliSecs);

    Result := PadIntZero(nYear,  4) +
              PadIntZero(nMonth, 2) +
              PadIntZero(nDay,   2) +
              PadIntZero(nHours,   2) +
              PadIntZero(nMinutes, 2) +
              PadIntZero(nSeconds, 2) + '.' +
              PadIntZero(nMilliSecs, 3);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetLocalBiasUTC : LongInt;
{$IFDEF VER80}
{ Delphi 1 doesn't support GetTimeZoneInformation }
begin
    Result := 0;
end;
{$ELSE}
var
    tzInfo : TTimeZoneInformation;
{$IFDEF VER93} {BCB1}
const
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
{$IFDEF VER110} {BCB3}
const
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
{$IFDEF VER90} {D2}
const
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
{$IFDEF VER100} {D3}
const
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
begin
    case GetTimeZoneInformation(tzInfo) of
    TIME_ZONE_ID_STANDARD: Result := tzInfo.Bias + tzInfo.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Result := tzInfo.Bias + tzInfo.DaylightBias;
    else
        Result := tzInfo.Bias;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function DateTimeToUTC(dtDT : TDateTime) : TDateTime;
begin
    Result := dtDT + GetLocalBiasUTC / (60.0 * 24.0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetFileAge(cFile : String) : Integer;
begin
    if cFile[Length(cFile)] in ['\', '/'] then
        cFile := cFile + '.';
    Result := FileAge(cFile);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function FileUtcStr(cFileName : String) : String;
begin
    Result := TimeDateStr(
                  DateTimeToUTC(
                      FileDateToDateTime(GetFileAge(cFileName))));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.

