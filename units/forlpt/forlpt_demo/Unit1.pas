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
    Button1: TKOLButton;
    GroupBox1: TKOLGroupBox;
    Label1: TKOLLabel;
    EditBox1: TKOLEditBox;
    EditBox2: TKOLEditBox;
    GroupBox2: TKOLGroupBox;
    Button3: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button6: TKOLButton;
    EditBox3: TKOLEditBox;
    EditBox4: TKOLEditBox;
    EditBox5: TKOLEditBox;
    EditBox6: TKOLEditBox;
    Timer1: TKOLTimer;
    GroupBox3: TKOLGroupBox;
    CheckBox1: TKOLCheckBox;
    CheckBox2: TKOLCheckBox;
    CheckBox3: TKOLCheckBox;
    CheckBox4: TKOLCheckBox;
    CheckBox5: TKOLCheckBox;
    CheckBox6: TKOLCheckBox;
    CheckBox7: TKOLCheckBox;
    CheckBox8: TKOLCheckBox;
    GroupBox4: TKOLGroupBox;
    Button2: TKOLButton;
    Label2: TKOLLabel;
    EditBox7: TKOLEditBox;
    procedure Button1Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure Button6Click(Sender: PObj);
    procedure Timer1Timer(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure CheckBox1Click(Sender: PObj);
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
uses ForSystemKOL, ForLPT;

{  Function BitFromLPT(Nom:byte):byte; external 'DllForLPT.dll';
  procedure HalfByteFromLPT(var Value:Byte;isLeftHalf:boolean); external 'DllForLPT.dll';
  Procedure BitToLPT(bit:byte;Nom:byte); external 'DllForLPT.dll';
  Procedure ByteToLPT(data:byte); external 'DllForLPT.dll';
  Procedure ClearLPT; external 'DllForLPT.dll'; }


{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.Button1Click(Sender: PObj);
begin
  ClearLPT;
  CheckBox1.checked:=false;
  CheckBox2.checked:=false;
  CheckBox3.checked:=false;
  CheckBox4.checked:=false;
  CheckBox5.checked:=false;
  CheckBox6.checked:=false;
  CheckBox7.checked:=false;
  CheckBox8.checked:=false;
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  EditBox3.Text:=Int2Str(BitFromLPT(1));
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  EditBox4.Text:=Int2Str(BitFromLPT(2));
end;

procedure TForm1.Button5Click(Sender: PObj);
begin
  EditBox5.Text:=Int2Str(BitFromLPT(3));
end;

procedure TForm1.Button6Click(Sender: PObj);
begin
  EditBox6.Text:=Int2Str(BitFromLPT(4));
end;

procedure TForm1.Timer1Timer(Sender: PObj);
var a:byte;
begin
  a:=0;//Œ¡Õ”À»“‹ ¬Õ¿◊¿À≈ Œ¡ﬂ«¿“≈À‹ÕŒ
  HalfByteFromLPT(a,False);
  EditBox2.Text:=ForSystemKOL.Ten2Two(a,4);
end;


procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  ClearLPT;
end;

procedure TForm1.CheckBox1Click(Sender: PObj);
var bit:byte;
begin
  if PControl(Sender).checked then bit:=1
  else bit:=0;
  BitToLPT(bit,PControl(Sender).tag);
end;

procedure TForm1.Button2Click(Sender: PObj);
var a:byte;
    s:string;
begin
  a:=Str2Int(EditBox7.Text);
  ByteToLPT(a);
  s:=ForSystemKOL.Ten2Two(a,8);
  CheckBox1.checked:=s[8]='1';
  CheckBox2.checked:=s[7]='1';
  CheckBox3.checked:=s[6]='1';
  CheckBox4.checked:=s[5]='1';
  CheckBox5.checked:=s[4]='1';
  CheckBox6.checked:=s[3]='1';
  CheckBox7.checked:=s[2]='1';
  CheckBox8.checked:=s[1]='1';
end;

end.


