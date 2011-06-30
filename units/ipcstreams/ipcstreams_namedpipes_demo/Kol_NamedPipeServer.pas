{-----------------------------------------------------------------------------
 Unit Name: Kol_NamedPipeServer
 Author:    Thaddy
 Purpose:   Demo Named pipe streams kolIPCStreams.pas
 History:
-----------------------------------------------------------------------------}


unit Kol_NamedPipeServer;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:17-2-2003 17:20:40
//********************************************************************


interface
uses
  Windows, Messages, Kol,KolIPCStreams;

type


PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Memo,
  Button:pControl;
  NPS:pStream;
  Thread:pThread;
  Fstring:string;
public
  function  ThreadExecute( Sender: PThread ): Integer;
  procedure UpdateMemo;
  procedure WriteString(const S: String);
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
    Form:= NewForm(AParent,'KOL Named Pipe Server').SetSize(600,400).Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    Memo:=NewEditBox(Form,[eoMultiline]);
    Memo.Width:=300;
    Button:=NewButton(Form,'Read').PlaceRight.ResizeParent;
    Button.OnClick:=BtnClick;
    NPS:=NewNamedPipeReadStream('KolNamedPipeClient.Exe',True);//Default pipename used;
  end;
end;


procedure Tform1.BtnClick(sender:pobj);
begin
  Thread:=NewThreadAutoFree(ThreadExecute);
end;

function Tform1.ThreadExecute(sender:pThread):integer;
var
 TempStr:STring;
 Count:Dword;
begin
  SetLength(TempStr,1024);
  Count:=NPS.Read(TempStr[1],Length(TempStr));
  SetLength(TempStr,Count);
  Writestring(TempStr);
end;

procedure Tform1.UpdateMemo;
begin
  Memo.Text:=FString;
end;

procedure Tform1.WriteString(const S:string);
begin
  FString := S;
  Thread.Synchronize(UpdateMemo);
end;

end.