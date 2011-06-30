{-----------------------------------------------------------------------------
 Unit Name: kol_namedpipeclient
 Author:    Thaddy de Koning
 Purpose:   Demo Named pipe stream
 History:
-----------------------------------------------------------------------------}


unit kol_namedpipeclient;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:17-2-2003 17:12:31
//********************************************************************


interface
uses
  Windows, Messages, Kol, kolipcstreams;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  memo,
  Button:pControl;
  NPS:pStream;
public
  procedure BtnClick(sender:pObj);
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
    Form:= NewForm(AParent,'KOL Named pipe Client').SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    Memo:=NewEditBox(Form,[]);
    Memo.width:=300;
    Button:=NewButton(Form,'Write').PlaceRight.Resizeparent;
    Button.Onclick:=BtnClick;
    NPS:=NewNamedPipeWriteStream;//Use default name
  end;
end;


procedure Tform1.BtnClick(sender:pObj);
begin
  NPS.WriteStr(Memo.Text);
end;

end.