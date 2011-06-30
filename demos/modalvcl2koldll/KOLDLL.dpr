{ KOL MCK } // Do not remove this line!
library KOLDLL;

uses
KOL,
  KOLUnit1 in 'KOLUnit1.pas' {KOLForm1};

exports
  CallKOLFormModal name 'CallKOLFormModal';

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I KOLDLL_0.inc} {$ELSE}

  Application.Initialize;
  Application.Run;

{$ENDIF}

end.

