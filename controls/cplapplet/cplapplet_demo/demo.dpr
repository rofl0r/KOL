{ KOL MCK } // Do not remove this line!
library demo;
{$E cpl}
uses
KOL,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Main};
//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment
{$IFNDEF KOL_MCK}
Application.Initialize;
Application.CreateForm(TForm1, Form1);
Application.Run;
{$ENDIF}
end.

