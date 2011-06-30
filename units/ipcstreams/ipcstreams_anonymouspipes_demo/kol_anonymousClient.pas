{-----------------------------------------------------------------------------
 Unit Name: kol_anonymousClient
 Author:    Thaddy de Koning
 Purpose:
 History:
-----------------------------------------------------------------------------}


unit kol_anonymousClient;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 16:43:47
//********************************************************************


interface
uses
  Windows, Messages, Kol, KolIPCStreams;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Edit,
  Button:pControl;
private
  PipeWrite:pStream;
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
    Form:= NewForm(AParent,'KOL Anonymous Pipe Client');
    Applet:=Form;
    Form.Add2AutoFree(Result);
    Edit:=NewEditBox(Form,[]);
    Edit.Width:=300;
    Edit.Color:=clWhite;
    Button:=NewButton(Form,'&Send').PlaceRight.ResizeParent;;
    Button.OnClick:=BtnClick;
    PipeWrite := NewAnonymousPipeWriteStream;
    Form.Add2AutoFree(PipeWrite);
  end;
end;

procedure Tform1.BtnClick(sender:pObj);
var
  Msg: String;
begin
  Msg := Edit.Text+#00#00;
  PipeWrite.Write( Msg[1], Length(Msg))
end;




end.