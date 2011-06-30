{ KOL MCK } // Do not remove this line!
program FileGuard;
{|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
   File Guard - (C) by Vladimir Kladov, 2004
   ƒанна€ программа предназначена дл€ автоматического сохранени€ всех
   версий файлов из указанного множества (директорий, типов) в указанном
   хранилище (расшаренна€ директори€ в сети, указанна€ директори€ на другом
   дике, в будущем - на CD-ROM или в Ѕƒ или в базе MS Source Safe или CVS
   или на ftp сервере).
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||}

uses
KOL,
  MainUnit in 'MainUnit.pas' {fmMainGuard},
  EditFilterUnit in 'EditFilterUnit.pas' {fmEditFilter},
  MultiDirsChange in 'MultiDirsChange.pas',
  StorageUnit in 'StorageUnit.pas',
  UpdatesUnit in 'UpdatesUnit.pas',
  HistoryUnit in 'HistoryUnit.pas' {fmHistory},
  FileVersionUnit in 'FileVersionUnit.pas',
  RestoreUnit in 'RestoreUnit.pas' {fmRestore};

{$R *.res}

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I FileGuard_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TfmMainGuard, fmMainGuard);
  Application.Run;

{$ENDIF}

end.

