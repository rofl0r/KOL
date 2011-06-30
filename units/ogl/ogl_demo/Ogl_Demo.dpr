{ KOL MCK } // Do not remove this line!
program Ogl_Demo;

uses
KOL,
  Unit1 in 'Unit1.pas' {Main};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I Ogl_Demo_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;

{$ENDIF}

end.
