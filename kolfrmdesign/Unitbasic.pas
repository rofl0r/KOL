unit Unitbasic;
//********************************************************************
//  Created by KOL project Expert Version 2.01 on:14-1-2004 19:09:33
//********************************************************************
{
       Unit: UnitBasic
    purpose: Very basic formdesigner demo
     Author: Thaddy de Koning
  Copyright: 2004, Thaddy de Koning
    Remarks: Demo for version 1 beta 1.10 of designctrl.pas
             This version is not yet for release
             Only for beta testers.

    Shows how to connect/disconnect the designer:

    1) Make shure that Form <> Applet, i.e. create them both
       and do not assign Applet to form.
       This is important!
    2) Create your form and all controls you want.
       They can be nested.
    3) Create the designer object with the form you want it to control
       as parent.
    4) Call Designer.ConnectAll to connect all the controls to the
       Designer.
    5) Exclude any controls you do not want to be able to design with
       a call to Disconnect(aControl)
    5) Set the designer to active.

}


interface
uses
  Windows, Messages, Kol, KolSizer;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  private
  Form:pControl;
  Designer:pDesigner;
  Toggle,
  Button:pControl;
public
  procedure ToggleClick(sender:pObj);
  procedure ButtonClick(sender:pObj);
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
    Form:= NewForm(AParent,'Basic Kol Forms Designer Demo').SetSize(450,250).centeronparent;
    form.Add2AutoFree(Result);
    form.SimpleStatusText:='Size the button or move the button around, Toggle the designmode, Click button';
    Toggle:=NewButton(form,'Toggle designer').AutoSize(true);
    Toggle.OnClick:=Toggleclick;
    Button:=NewButton(form,'Button').centeronparent;
    Button.OnClick:=Buttonclick;
    designer:=Newdesigner(form);
    designer.Connect('Button',Button);
    designer.Active:=true;
  end;
end;


procedure TForm1.ButtonClick(sender: pObj);
begin
 with pControl(sender)^ do
 MsgOk(format('I''m now at: %d, %d'+
               #13#13'My width is: %d, my height is: %d',
               [Left,top, width, height]))
end;



procedure TForm1.ToggleClick(sender: pObj);
begin
 Designer.active:=not designer.active;
end;

end.
