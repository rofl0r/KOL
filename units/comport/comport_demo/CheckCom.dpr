{ KOL MCK } // Do not remove this line!
program CheckCom;
{$DEFINE KOL_MCK}
{ Демонстрация работы с СОМ-портом.
  Для работы необходимо соединить два СОМ-порта нуль-модемным кабелем
  т.е. Rx-Tx, Tx-Rx и соответственно модемные концы}

uses
KOL,
  Unit1 in 'Unit1.pas' {Form1};

//{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I CheckCom_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

{$ENDIF}

end.

