{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLHintRA {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,
  mckHintRA, mckCtrls {$ENDIF};
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
    HintRA1: TKOLHintRA;
    Button2: TKOLButton;
    HintRA2: TKOLHintRA;
    Button3: TKOLButton;
    HintRA3: TKOLHintRA;
    Button4: TKOLButton;
    HintRA4: TKOLHintRA;
    Label1: TKOLLabel;
    EditBox1: TKOLEditBox;
    HintRA5: TKOLHintRA;
    Button6: TKOLButton;
    HintRA6: TKOLHintRA;
    Button7: TKOLButton;
    Button8: TKOLButton;
    HintRA7: TKOLHintRA;
    HintRA8: TKOLHintRA;
    HintRA9: TKOLHintRA;
    Panel1: TKOLPanel;
    Button5: TKOLButton;
    HintRA10: TKOLHintRA;
    procedure Button6Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure HintRA5BeforeShowHint(Sender: PObj);
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

procedure TForm1.Button6Click(Sender: PObj);
begin
  HintRA6.SetDelay(HintRA6.GetDelay div 2);
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  HintRA7.KOLControl:=Form;//установка Hint'a формы
  HintRA9.SetDelay(30);
end;

procedure TForm1.HintRA5BeforeShowHint(Sender: PObj);
begin
HintRA5.BeginUpdate;
  HintRA5.HintText:='Вы задали:'+#13#10+EditBox1.Text;
HintRA5.EndUpdate;
end;




end.



