{ KOL MCK } // Do not remove this line!
program TestKolGif;

uses
KOL,
 //HeapMM,
 { recommend to uncomment it to use HeapMM memory manager together
   with proofing tools (such as MemProof), because those can detect
   API failures when Delphi memory manager used. }
  MainGif in 'MainGif.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I TestKolGif_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.

