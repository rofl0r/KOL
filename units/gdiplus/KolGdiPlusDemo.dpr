program KolGdiPlusDemo;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:18-3-2003 12:28:48
//********************************************************************

uses
  Kol,
  KOLGDIPLUS1 in 'KOLGDIPLUS1.pas',
  ShellAPI in '..\Source\Rtl\Win\ShellAPI.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.