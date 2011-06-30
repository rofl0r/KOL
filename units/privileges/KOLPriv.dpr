{ KOL MCK } // Do not remove this line!
program KOLPriv;

uses
KOL,
  Unit1 in 'Unit1.pas' {SvForm};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I KOLPriv_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TSvForm, SvForm);
  Application.Run;

{$ENDIF}

end.

