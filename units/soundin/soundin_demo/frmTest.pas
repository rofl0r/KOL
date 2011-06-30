{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit frmTest;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLACMIn {$IFNDEF KOL_MCK}, mirror, Classes,  mckObjs, Controls, mckCtrls,  MCKSoundCtl,  mckTCPSocket,  mckACMIn,  {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror, mckObjs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Button1: TKOLButton;
    Button2: TKOLButton;
    UseTempFile: TKOLCheckBox;
    sounIn: TKOLACMIn;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    edtBuffSize: TKOLEditBox;
    Label3: TKOLLabel;
    Label4: TKOLLabel;
    Label5: TKOLLabel;
    Label6: TKOLLabel;
    Button3: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure sounInBufferFull(Sender: PObj; Data: Pointer; Size: Integer);
    procedure Button3Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;



{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation
uses
  err;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I frmTest_1.inc}
{$ENDIF}



procedure TForm1.Button1Click(Sender: PObj);
begin
  try
     sounIn.BufferSize:=Str2Int(edtBuffSize.Text);
     sounIn.UseTempFile:=UseTempFile.Checked;
     sounIn.Open;
  except
     on E: Exception do ShowMessage(E.Message);
  end
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
try
 sounIn.Close;
except
  on E: Exception do ShowMessage(E.Message);
end

end;

procedure TForm1.sounInBufferFull(Sender: PObj; Data: Pointer;
  Size: Integer);
begin
  Label1.Caption:=Int2Str(Str2Int(Label1.Caption)+Size);
  Label2.Caption:=Int2Str(Str2Int(Label2.Caption)+1);
end;


procedure TForm1.Button3Click(Sender: PObj);
begin
  sounIn.GetWaveFormat(form.Handle);
end;

end.




