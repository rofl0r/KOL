{ KOL MCK } // Do not remove this line!
program TLB2KOL;

uses
KOL,
  MainTLB2KOL in 'MainTLB2KOL.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I TLB2KOL_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.
