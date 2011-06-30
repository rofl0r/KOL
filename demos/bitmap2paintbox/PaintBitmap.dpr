{ KOL MCK } // Do not remove this line!
program PaintBitmap;

uses
KOL,
  MainPaintBitmap in 'MainPaintBitmap.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I PaintBitmap_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.
