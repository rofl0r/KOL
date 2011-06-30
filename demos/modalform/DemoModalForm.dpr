{ KOL MCK } // Do not remove this line!
program DemoModalForm;

uses
KOL,
  UnitA in 'UnitA.pas' {Form1},
  UnitB in 'UnitB.pas' {Form2}, windows;

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I DemoModalForm_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.

