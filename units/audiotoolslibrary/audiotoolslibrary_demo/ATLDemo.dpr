{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}

//********************************************************************
//  Created by KOL project Expert Version 3.00 on: 13.11.3902 15:54:08
//********************************************************************

program ATLDemo;

uses
KOL,
  Main in 'Main.pas' {MainForm};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I ATLDemo_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

{$ENDIF}

end.

