program KolAnonymousServer;
{-----------------------------------------------------------------------------
 Program Name: KolAnonymousServer
 Author:    Thaddy de Koning
 Purpose:   Demo Anonymous Pipe streams from kolipcstreams.pas
 History:   February 17, 2003, Initial release
-----------------------------------------------------------------------------}
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 16:56:56
//********************************************************************

uses
  Kol,
  Kol_AnonymousServer in 'Kol_AnonymousServer.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.