{ KOL MCK } // Do not remove this line!
program KOLFtpClient;

uses
KOL,
  KOLForm in 'KOLForm.pas' {Form1},
  Select in 'Select.pas' {Form2},
  Logger in 'Logger.pas' {Form3},
  AskBox in 'AskBox.pas' {Form4},
  DirBox in 'DirBox.pas' {Form5},
  TaskN in 'TaskN.pas' {Form6},
  TaskEd in 'TaskEd.pas' {Form7};

{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I KOLFtpClient_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.Run;

{$ENDIF}

end.

