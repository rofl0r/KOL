{ KOL MCK }// Do not remove this line!
program UCL_Streams_KOL;

uses
KOL,
  UCL_Streams_KOL_Form in 'UCL_Streams_KOL_Form.pas' {Form1};

{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I UCL_Streams_KOL_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.
