program MD5TEST;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:12-2-2003 15:17:50
//********************************************************************
//  "derived from the RSA Data Security, Inc. MD5 Message-Digest Algorithm"
// Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
// rights reserved.
// This example code is freeware with restrictions as stated by RSA,
// (c) Thaddy de Koning, 2003
// See implementation Unit MD5_UNIT and KolMD5
//*********************************************************************



uses
  HeapMM,
  Kol,
  MD5_Unit in '..\..\MD5_Unit.pas',
  kolmd5 in 'kolmd5.pas',
  ShellAPI in 'H:\Program Files\Borland\Delphi7\Source\Rtl\Win\ShellAPI.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.