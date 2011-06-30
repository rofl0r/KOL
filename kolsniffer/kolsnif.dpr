program kolsnif;
//
// purpose: Packet sniffer demo for use with the open source WinPcap driver
//  author: © 2005, Thaddy de Koning
// Remarks: The WinPCap driver is free ware and available from
//          http://winpcap.polito.it/ under a BSD style license
//
//          This KOL demo and the KOL headerfile translations are not freeware
//          They are subject to the same license as Umar states in his header
//          comments
uses
  Kol,
  kolsnif1 in 'kolsnif1.pas';

begin
  NewForm1( Form1, nil);
  Run(Form1.form);
end.