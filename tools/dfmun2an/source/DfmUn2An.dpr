{ KOL MCK } // Do not remove this line!
program DfmUn2An;

uses
KOL,
  MainFm in 'MainFm.pas' {MainForm};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I DfmUn2An_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

{$ENDIF}

end.

