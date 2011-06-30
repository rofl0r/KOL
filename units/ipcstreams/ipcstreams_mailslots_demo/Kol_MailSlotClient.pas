{-----------------------------------------------------------------------------
 Unit Name: Kol_MailSlotClient
 Author:    Thaddy de Koning
 Purpose:   Mailslot demo
 History:
-----------------------------------------------------------------------------}


unit Kol_MailSlotClient;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 15:43:12
//********************************************************************


interface
uses
  Windows, Messages, Kol, KolIPCStreams;


type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Memo:pControl;
private
  MS:pStream;
  AnS:pStream;
public
  procedure MemoChange(sender:pObj);
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
    Form:= NewForm(AParent,'KOL Mailslot Client [Writer]').SetSize(400,200).centeronparent.Tabulate;
    Applet:=Form;
    Memo:=NewEditBox(Form,[eoMultiline]).SetAlign(caClient);
    Memo.Color:=clWhite;
    Memo.OnChange:=MemoChange;
    Form.Add2AutoFree(Result);
    MS:=NewMailSLotWriteStream(MailSlotWriteName);
    Ans:=NewAnonymousPipeWriteStream;
    Form.Add2AutoFree(MS);
    Form.Add2AutoFree(AnS);
  end;
end;


procedure TForm1.MemoChange(sender: pObj);
var
  Msg: String;
begin
  Msg := Memo.Text;
  if Ms.Write(Msg[1],Length(Msg))=0 then MsgOk(SysErrorMessage(getlasterror));
end;

end.