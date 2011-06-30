{-----------------------------------------------------------------------------
 Unit Name: Not available
 Author:    Thaddy de Koning
 Purpose:   Named Pipe stream demo for kolIPCStreams.pas
 History:
-----------------------------------------------------------------------------}


program KolNamedPipeClient;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:17-2-2003 17:12:31
//********************************************************************

uses
  Kol,
  kol_namedpipeclient in 'kol_namedpipeclient.pas',
  kolIPCStreams in 'kolIPCStreams.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.