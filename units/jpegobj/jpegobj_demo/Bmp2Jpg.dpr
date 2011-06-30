{ KOL MCK } // Do not remove this line!
program Bmp2Jpg;

uses
KOL,
  MainBmp2Jpg in 'MainBmp2Jpg.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I Bmp2Jpg_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.
