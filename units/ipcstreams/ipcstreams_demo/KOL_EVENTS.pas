unit KOL_EVENTS;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 22:14:23
//********************************************************************


interface
uses
  Windows, Messages, Kol;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
public
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

function AppAllReadyRunning:Boolean;

implementation

function AppAllReadyRunning:Boolean;
begin
  //Don't bother if this fails
  CreateEvent(NIL,False,False,Pchar(ExtractFileName(ParamStr(0))));
  //Even if it didn't we should get the right result ;-)
  result := getlasterror = ERROR_ALREADY_EXISTS;
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'KOLForm').SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    MsgOk(Int2Str(Integer(AppAllReadyRunning)));
  end;
end;



end.