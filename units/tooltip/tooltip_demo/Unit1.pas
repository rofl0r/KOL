{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}

unit Unit1; 

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHUpDown {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckObjs,
  MCKMHUpDown {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
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
    EditBox1: TKOLEditBox;
    Panel1: TKOLPanel;
    Label1: TKOLLabel;
    CheckBox1: TKOLCheckBox;
    MHUpDown1: TKOLMHUpDown;
    Toolbar1: TKOLToolbar;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Button1Click(Sender: PObj);
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

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  // NOTE:
  //   Don't forget rebuild & recompile all, after define set

  // Simple ToolTip demo, show you HOW-TO:
  //   Set Hint Text
  //   Set Text Color
  //   Set BackGround Color

  // Feature:
  //   Color propertes set "as last" if you don't change it manualy
  
  Form.Width:=400;
  Form.Height:=285;
  
  Button1.Hint.Text:='Hint, KOL integration!';
  Button1.Hint.TextColor:=clRed;
  Button1.Hint.BkColor:=clWhite;

  EditBox1.Hint.Text:='Ha-Ha-Ha!';
  EditBox1.Hint.TextColor:=clBlue;
  EditBox1.Hint.BkColor:=clRed;

  Panel1.Hint.Text:='Panel!';
  Panel1.Hint.TextColor:=clGreen;
  Panel1.Hint.BkColor:=clNavy;

  Label1.Hint.Text:='I''am Label!';
  Label1.Hint.TextColor:=clYellow;
  Label1.Hint.BkColor:=clRed;

  CheckBox1.Hint.Text:='Chech ME!';
  CheckBox1.Hint.TextColor:=clBlue;
  CheckBox1.Hint.BkColor:=clYellow;

  MHUpDown1.Hint.Text:='Crazy, I''m Here!';

  ToolBar1.Hint.Text:='sdfsdf';
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
  ShowMessage('Bad!');
end;

end.






