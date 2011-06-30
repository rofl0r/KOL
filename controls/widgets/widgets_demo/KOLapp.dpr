{ KOL MCK } // Do not remove this line!
program KOLapp;

uses
KOL,
  KOLForm in 'KOLForm.pas' {Form1},
  KOLNext in 'KOLNext.pas' {Form2};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I KOLapp_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;

{$ENDIF}

end.

