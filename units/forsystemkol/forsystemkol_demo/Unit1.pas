{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,
  mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
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
    GroupBox1: TKOLGroupBox;
    Label1: TKOLLabel;
    EditBoxN1: TKOLEditBox;
    Label2: TKOLLabel;
    EditBoxS1: TKOLEditBox;
    Button1: TKOLButton;
    Label3: TKOLLabel;
    EditBoxO1: TKOLEditBox;
    GroupBox2: TKOLGroupBox;
    Label4: TKOLLabel;
    EditBoxN2: TKOLEditBox;
    Label5: TKOLLabel;
    EditBoxS2: TKOLEditBox;
    Button2: TKOLButton;
    Label6: TKOLLabel;
    EditBoxO2: TKOLEditBox;
    GroupBox3: TKOLGroupBox;
    Label7: TKOLLabel;
    EditBoxN3: TKOLEditBox;
    Label8: TKOLLabel;
    EditBoxS3: TKOLEditBox;
    Button3: TKOLButton;
    Label9: TKOLLabel;
    EditBoxO3: TKOLEditBox;
    OpenDialog1: TKOLOpenSaveDialog;
    GroupBox4: TKOLGroupBox;
    Button4: TKOLButton;
    EditBox1: TKOLEditBox;
    Button5: TKOLButton;
    EditBox2: TKOLEditBox;
    Button6: TKOLButton;
    ListBox1: TKOLMemo;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure Button6Click(Sender: PObj);
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
uses ForSystemKOL;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}
{-Function Any2Ten(s:ShortString;sys:byte):LongInt;
-Function Ten2Any(a:LongInt;sys:byte):ShortString;
-Function Ten2Two(a:LongInt;CountDigits:byte):ShortString;
-Function GetDPNE(DPNEComplette:AnsiString;DPNEDif:ShortString):AnsiString;
-Function AddExt(FileName,Ext:AnsiString):AnsiString;

Function Bool2STR(bool:Boolean):AnsiString;
Function Str2Bool(s:AnsiString):Boolean;
}

procedure TForm1.Button1Click(Sender: PObj);
begin
  EditBoxO1.Text:=Int2Str(Any2Ten(EditBoxN1.Text,Str2Int(EditBoxS1.Text)));
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  EditBoxO2.Text:=Ten2Any(Str2Int(EditBoxN2.Text),Str2Int(EditBoxS2.Text));
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  EditBoxO3.Text:=Ten2Two(Str2Int(EditBoxN3.Text),Str2Int(EditBoxS3.Text));
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  if OpenDialog1.Execute then EditBox1.Text:=OpenDialog1.Filename;
end;

procedure TForm1.Button5Click(Sender: PObj);
begin
  EditBox1.Text:=AddExt(EditBox1.Text,EditBox2.Text);
end;

procedure TForm1.Button6Click(Sender: PObj);
var s:string;
begin
  ListBox1.Clear;
  s:='Disk';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Puth';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Disk_Puth';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Name';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Ext';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Puth_Name';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Disk_Puth_Name';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Name_Ext';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Puth_Name_Ext';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
  ListBox1.Add(#13#10);
  s:='Disk_Puth_Name_Ext';
  ListBox1.Add(s+'='+GetDPNE(EditBox1.Text,s));
end;

end.


