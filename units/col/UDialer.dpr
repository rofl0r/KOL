{ KOL MCK } // Do not remove this line!
program UDialer;

uses
KOL,
  Main in 'Main.pas' {MainForm},
  Options in 'Options.pas' {OptionsForm},
  COL in '..\..\DCU\COL.pas';

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I UDialer_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.Run;

{$ENDIF}

end.

