unit KOLPrintCommon;
{*}

interface

uses Windows;

type
  PDevNames = ^tagDEVNAMES;
  tagDEVNAMES = packed record
    wDriverOffset: Word;
    wDeviceOffset: Word;
    wOutputOffset: Word;
    wDefault: Word;
  end;

  PPrinterInfo = ^TPrinterInfo;
  TPrinterInfo = packed record
  {* Used for transferring information between Print/Page dialogs and TKOLPrinter.This way TKOLPrinter and Print/Page dialogs could be used separately}
      ADevice  : PChar;
      ADriver  : PChar;
      APort    : PChar;
      ADevMode : THandle;
    end;


implementation

end.
 