{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
program TestKOLService;

uses
KOL,
  Windows,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I TestKOLService_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;

{$ENDIF}

end.

