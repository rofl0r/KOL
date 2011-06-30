{-----------------------------------------------------------------------------
 Unit Name: KOL_MailSlot
 Author:    Thaddy
 Purpose:
 History:
-----------------------------------------------------------------------------}


unit KOL_MailSlot;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 15:41:03
//********************************************************************


interface
uses
  Windows, Kol, KolIPCSTreams;



type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Timer:pTimer;
  Memo:pControl;
  Menu:pMenu;
private
  MS:pStream;
public
  procedure MenuClick(Sender:pMenu;Index:integer);
  procedure DoTimer(sender:pObj);
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
    Form:= NewForm(AParent,'KOL Mailslot Server').SetSize(400,200);
    Applet:=Form;
    Timer:=NewTimer(10);
    Timer.OnTimer:=DoTimer;
    Timer.enabled:=true;
    Memo:=NewEditBox(Form,[eoMultiline,eoReadOnly]).SetAlign(caClient);
    Memo.Color:=clWhite;
    Form.Add2AutoFree(Timer);
    Menu:=NewMenu(Form,0,['Start a new Client',''],MenuClick);
    Form.Add2AutoFree(Result);
    MS:=NewMailSlotReadstream;
    Form.Add2AutoFree(MS);
  end;
end;




procedure TForm1.DoTimer(sender: pObj);
var
  NextMsgSize, BytesRead: DWord;
  Msg: String;
begin
  if not GetMailslotInfo(
    Ms.Data.fHandle, nil, NextMsgSize, nil, nil) then
  begin
    Timer.Enabled := False;
    MsgOk(SysErrorMessage(getlasterror));
    Exit;
  end;
  //Check there is a message to read
  if NextMsgSize <> Mailslot_No_Message then
  begin
    //Allocate string size as required and set length
    SetLength(Msg, NextMsgSize);
    //Read the data into the string variable
    if MS.Read(Msg[1], NextMsgSize) = 0 then
    begin
      Timer.Enabled := False;
      MsgOk(SysErrorMessage(getlasterror));
      Exit;
    end;
    Memo.Text := Msg;
  end
end;


procedure CreatelpSA(var SD: SECURITY_DESCRIPTOR; var SA: _SECURITY_ATTRIBUTES);
begin
   InitializeSecurityDescriptor(
      @SD,
      SECURITY_DESCRIPTOR_REVISION);
   SetSecurityDescriptorDacl(
      @SD,
      TRUE,
      nil,
      FALSE);
   SA.nLength := SizeOf(_SECURITY_ATTRIBUTES);
   SA.lpSecurityDescriptor := @SD;
   SA.bInheritHandle := False;
end;


procedure TForm1.MenuClick(Sender: pMenu; Index: integer);
const
  ChildApp = 'KolMailslotClient.Exe';
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  SD:  SECURITY_DESCRIPTOR;
  SA: _SECURITY_ATTRIBUTES;

begin
  GetStartupInfo(SI);
  InitializeSecurityDescriptor(@SD,SECURITY_DESCRIPTOR_REVISION);
   SetSecurityDescriptorDacl(@SD,TRUE,nil,FALSE);
   SA.nLength := SizeOf(_SECURITY_ATTRIBUTES);
   SA.lpSecurityDescriptor := @SD;
   SA.bInheritHandle := False;
  if not CreateProcess(nil, ChildApp, @SA,
           nil, True, 0, nil, nil, SI, PI) then
    MsgOk('Unable to launch ' + ChildApp+#13#10#13#10+SysErrorMessage(getlasterror));
end;

end.