{-----------------------------------------------------------------------------
 Unit Name: Not available
 Author:    Thaddy
 Purpose:   Demo Named pipe readstream
 History:
-----------------------------------------------------------------------------}


program KolNamedPipeServer;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:17-2-2003 17:20:40
//********************************************************************

uses
  Kol,
  Kol_NamedPipeServer in 'Kol_NamedPipeServer.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.