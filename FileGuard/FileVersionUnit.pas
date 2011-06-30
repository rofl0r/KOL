unit FileVersionUnit;

interface

uses Windows, KOL;

type
  TFileVersionInfo = packed record
    FT: TFileTime;
    Sz: DWORD;
    ChkSum: DWORD;
  end;
  PFileVersionInfo = ^TFileVersionInfo;

implementation

end.
