{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,
  mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Label1: TKOLLabel;
    Edit1: TKOLEditBox;
    Button1: TKOLButton;
    Label2: TKOLLabel;
    Edit2: TKOLEditBox;
    Button2: TKOLButton;
    Label3: TKOLLabel;
    Label4: TKOLLabel;
    Label5: TKOLLabel;
    Label6: TKOLLabel;
    OpenDlg: TKOLOpenSaveDialog;
    Radio1: TKOLRadioBox;
    Radio2: TKOLRadioBox;
    Radio3: TKOLRadioBox;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
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

uses KOLAES;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.Button1Click(Sender: PObj);
begin
  if OpenDlg.Execute then Edit1.Text:=OpenDlg.Filename;
end;

procedure TForm1.Button2Click(Sender: PObj);
var Source,Dest: PStream;
    SrcFile,DestFile: string;
    Start,Stop: cardinal;
    Key128: TAESKey128;
    Key192: TAESKey192;
    Key256: TAESKey256;
    Size: integer;
begin
  // Encryption
  Source:=NewReadFileStream(Edit1.Text);
  try
    DestFile:=ChangeFileExt(Edit1.Text,'.enc');
    Dest:=NewWriteFileStream(DestFile);
    try
      Size:=Source.Size;
      Dest.Write(Size,sizeof(Size));
      FillChar(Key128,sizeof(Key128),0);
      FillChar(Key192,sizeof(Key192),0);
      FillChar(Key256,sizeof(Key256),0);
      Move(PChar(Edit2.Text)^,Key128,Min(sizeof(Key128),Length(Edit2.Text)));
      Move(PChar(Edit2.Text)^,Key192,Min(sizeof(Key192),Length(Edit2.Text)));
      Move(PChar(Edit2.Text)^,Key192,Min(sizeof(Key256),Length(Edit2.Text)));
      Start:=GetTickCount;
      if Radio1.Checked then EncryptAES128StreamECB(Source,0,Key128,Dest);
      if Radio2.Checked then EncryptAES192StreamECB(Source,0,Key192,Dest);
      if Radio3.Checked then EncryptAES256StreamECB(Source,0,Key256,Dest);
      Stop:=GetTickCount;
      Label4.Caption:=Int2Str(Stop-Start)+' ms';
    finally
      Dest.Free;
    end;
  finally
    Source.Free;
  end;
  // Decryption
  Source:=NewReadFileStream(DestFile);
  try
    Source.Read(Size,sizeof(Size));
    SrcFile:=ChangeFileExt(Edit1.Text,'.dec');
    Dest:=NewWriteFileStream(SrcFile);
    try
      Start:=GetTickCount;
      if Radio1.Checked then DecryptAES128StreamECB(Source,Source.Size,Key128,Dest);
      if Radio2.Checked then DecryptAES192StreamECB(Source,Source.Size,Key192,Dest);
      if Radio3.Checked then DecryptAES256StreamECB(Source,Source.Size,Key256,Dest);
      Dest.Position:=Size;
      SetSizeFileStream(Dest,Size);
      Stop:=GetTickCount;
      Label6.Caption:=Int2Str(Stop-Start)+' ms';
    finally
      Dest.Free;
    end;
  finally
    Source.Free;
  end;
end;

end.

