{-----------------------------------------------------------------------------
 Unit Name: Kol_AnonymousServer
 Author:    Thaddy de Koning
 Purpose:   Demo Anonymous Pipe streams from kolipcstreams.pas
 History:   February 17, 2003, Initial release
-----------------------------------------------------------------------------}


unit Kol_AnonymousServer;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 16:56:56
//********************************************************************


interface
uses
  Windows, Messages, Kol, KolIPCStreams;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Button,
  Memo:pControl;
  NPS:pStream;
private
  Thread:pThread;
  Fstring:string;
public
  function ThreadExecute(sender:pThread):integer;
  procedure BtnClick(sender:pObj);
  procedure UpdateMemo;
  procedure WriteString(const S:string);
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
    Form:= NewForm(AParent,'KOLForm').SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    NPS:=NewAnonymousPipeReadStream('KolAnonimousClient.exe',true);
    Form.Add2AutoFree(NPS);
    Memo:=NewEditBox(Form,[eoMultiline]);
    Memo.Width:=300;
    Button:=NewButton(Form,'Read').placeright.resizeparent;
    Button.OnClick:=btnClick;
  end;
end;

procedure Tform1.BtnClick(sender:pObj);
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