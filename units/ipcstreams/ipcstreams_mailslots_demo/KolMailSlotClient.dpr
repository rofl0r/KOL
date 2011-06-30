{-----------------------------------------------------------------------------
 Unit Name: Not available
 Author:    Thaddy
 Purpose:   Mailslot demo for kolIPCstreams
 History:
-----------------------------------------------------------------------------}


program KolMailSlotClient;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 15:43:12
//********************************************************************

uses
  Kol,
  Kol_MailSlotClient in 'Kol_MailSlotClient.pas',
  kolIPCStreams in 'kolIPCStreams.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.