unit testdriver1;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:24-7-2003 18:50:02
//********************************************************************


interface
uses
  Windows, Messages, Kol, MMsystem;
const
  DRV_CUSTOM_MESSAGE = WM_USER + 11*11*11;
  // That would be:
  // My father's birthday October, 11
  // My mother's birthday September, 11 (true!)
  // My youngest sister's Birthday November,11

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Button1:pControl;
private
 Drv:HDRVR;
public
  procedure Button1Click(Sender: pObj);
  procedure FormShow(sender:pObj);
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(nil,'Installable driver test').SetSize(300,100).centeronparent.Tabulate;
    form.Color:=clred;
    Applet:=Form;
    Applet.Add2AutoFree(Form);
    Button1:=NewButton(form,'Open Driver').AutoSize(true).centeronparent;
    form.OnShow:=formshow;
  end;
end;


procedure TForm1.Button1Click(Sender: pObj);
begin
  Drv:=OpenDriver('d:\Testdriver.dll',nil,0);
  if Drv <> HDRVR(nil) then
  begin
    Showmessage(Pchar(format('handle: %d',[Drv])));
    if SendDriverMessage(Drv,DRV_QUERYCONFIGURE,0,0) > 0
    then
      begin
        SendDriverMessage(Drv,DRV_CONFIGURE,0,0);
        SendDriverMessage(Drv,DRV_CUSTOM_MESSAGE,0,0)
      end;
  end
  else
   Showmessage('error received from driver');
   CloseDriver(Drv,0,0);
end;

procedure TForm1.FormShow(sender: pObj);
begin
 Button1.Onclick:=Button1click;
end;

end.