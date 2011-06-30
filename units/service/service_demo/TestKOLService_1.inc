{ TestKOLService_1.inc
  This file is for you. Place here any code to run it
  just following Applet creation (if it present) but
  before creating other forms. E.g., You can place here
  <IF> statement, which prevents running of application
  in some cases. TIP: always use Applet for such checks
  and make it invisible until final decision if to run
  application or not. }

{
  for icounter := 1 to paramcount do begin
     if UpperCase(paramstr(icounter)) = '/INSTALL' then begin
        Service1.Install;
        Service2.Install;
        halt(0);
     end;
     if UpperCase(paramstr(icounter)) = '/REMOVE' then begin
        Service1.Stop;
        Service2.Stop;
        Service1.Remove;
        Service2.Remove;
        halt(0);
     end;
     if UpperCase(paramstr(icounter)) = '/STOP' then begin
        Service1.Stop;
        Service2.Stop;
        halt(0);
     end;
  end;
  Service.Run;
  for icounter := 1 to paramcount do begin
     if UpperCase(paramstr(icounter)) = '/START' then begin
        Service1.Start;
        Service2.Start;
        halt(0);
     end;
  end;
}
