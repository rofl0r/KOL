{ KOL MCK } // Do not remove this line!
program DemoSplash;

uses
KOL,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {fmSplash};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I DemoSplash_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.

