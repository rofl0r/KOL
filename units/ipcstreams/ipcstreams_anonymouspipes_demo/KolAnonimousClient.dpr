{-----------------------------------------------------------------------------
 program Name: KolAnoymousClient
 Author:   Thaddy de Koning
 Purpose:  Demo Anonymous Client from kolIpcStreams.pas
 History:  February 17,2003, Initial Release
-----------------------------------------------------------------------------}


program KolAnonimousClient;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 16:43:47
//********************************************************************

uses
  Kol,
  kol_anonymousClient in 'kol_anonymousClient.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.