{ KOL MCK } // Do not remove this line!
program KOLTelnet;

uses
KOL,
  KOLSocket,
  KOLForm in 'KOLForm.pas' {Form1},
  Params in 'Params.pas' {Form2};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I KOLTelnet_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;

{$ENDIF}

end.

