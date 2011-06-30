unit unit1;
//********************************************************************
//  Created by KOL project Expert Version 2.03 on:3-1-2005 10:13:42
//********************************************************************


interface
uses
  Windows, Messages, Kol, democtrl;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  lbl1,
  Lbl2,
  Tracker1,
  Tracker2:Pcontrol;
public
  procedure DoChange(sender:Pobj);
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
    Form:= NewForm(AParent,'Simple Tracker Demo').SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    // simplest
    Tracker1:=NewTracker(form,esRaised,clBtnShadow,clBtnHighlight);
    Tracker1.OnChange:=DoChange;
    lbl1:=Newlabel(form,'   ').PlaceRight.AutoSize(True);
    // use some options
    Tracker2:=NewTracker(form,esRaised,clRed,clYellow,200).PlaceDown;
    Tracker2.OnChange:=DoChange;
    Tracker2.color:=clBlack;
    Tracker2.width:=200;// forces WM_SIZE and thus repaint
    lbl2:=Newlabel(form,'   ').PlaceRight.AutoSize(True);
  end;
end;



{ TForm1 }

procedure TForm1.DoChange(sender: Pobj);
begin
  if sender = tracker1 then
    lbl1.caption:=Int2str(sender.tag)
  else
    lbl2.caption:=int2str(sender.tag);
end;

end.