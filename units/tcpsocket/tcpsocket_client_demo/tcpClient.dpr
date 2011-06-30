{ KOL MCK } // Do not remove this line!
program tcpClient;

uses
KOL,
  Client_main in 'Client_main.pas' {Form1},
  Client_conn in 'Client_conn.pas' {Form2};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I tcpClient_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;

{$ENDIF}

end.

