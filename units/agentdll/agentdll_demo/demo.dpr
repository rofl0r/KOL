{ KOL MCK } // Do not remove this line!
program demo;

uses
KOL,
HeapMM,
  Unit1 in 'Unit1.pas' {frmDemo};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I demo_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.Run;

{$ENDIF}

end.

