{ KOL MCK } // Do not remove this line!
program KomponentScan;

{Faustinbo Lobo Fernández 2003 f.lobo@teleline.es}

uses
KOL,
  Unit1 in 'Unit1.pas' {frm_Scan};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I KomponentScan_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(Tfrm_Scan, frm_Scan);
  Application.Run;

{$ENDIF}

end.

