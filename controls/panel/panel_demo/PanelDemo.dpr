{ KOL MCK } // Do not remove this line!
program PanelDemo;

uses
KOL,
  Main in 'Main.pas' {MainForm};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I PanelDemo_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

{$ENDIF}

end.

