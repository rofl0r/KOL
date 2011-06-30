{ KOL MCK } // Do not remove this line!
program ClientServer;

uses
KOL,
  KOLForm in 'KOLForm.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I ClientServer_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.



