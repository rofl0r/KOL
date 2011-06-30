{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PfrmDemo = ^TfrmDemo;
  TfrmDemo = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TfrmDemo = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    chkShow: TKOLCheckBox;
    edText: TKOLEditBox;
    Button3: TKOLButton;
    grSay: TKOLGroupBox;
    radSpeak: TKOLRadioBox;
    radThink: TKOLRadioBox;
    Label1: TKOLLabel;
    edAnim: TKOLEditBox;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button1: TKOLButton;
    procedure chkShowClick(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure Button1Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function InitAgent(TTSMode : PChar) : Boolean;stdcall;external 'agent.dll';
procedure FreeAgent;stdcall;external 'agent.dll';
procedure ShowAgent(Hide : Boolean);stdcall;external 'agent.dll';
procedure ChangeAgent;stdcall;external 'agent.dll';
procedure LoadAgent(Agent : PChar);stdcall;external 'agent.dll';
procedure MoveAgent(X,Y : Smallint);stdcall;external 'agent.dll';
procedure ResetAgent;stdcall;external 'agent.dll';
procedure PlayAgent(Animation : PChar);stdcall;external 'agent.dll';
procedure GestureAgent(X,Y :Smallint);stdcall;external 'agent.dll';
procedure StopAgent;stdcall;external 'agent.dll';
procedure SpeakAgent(Text : PChar);stdcall;external 'agent.dll';
procedure ThinkAgent(Text : PChar);stdcall;external 'agent.dll';
procedure TTSModeAgent(TTSMode : PChar);stdcall;external 'agent.dll';




var
  frmDemo {$IFDEF KOL_MCK} : PfrmDemo {$ELSE} : TfrmDemo {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewfrmDemo( var Result: PfrmDemo; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TfrmDemo.chkShowClick(Sender: PObj);
begin
ShowAgent(not chkShow.Checked);
end;

procedure TfrmDemo.Button3Click(Sender: PObj);
var
 p1,p2 : TPoint;
begin
with edText^ do begin
p1.x := Left + Width;
p1.y := Top - 50;
p2 := edText.Client2Screen(p1);
MoveAgent(SmallInt(p2.x) ,Smallint(p2.y));
p1.x := Left + (Width div 2);
p1.y := Top + (Height div 2);
p2 := edText.Client2Screen(p1);
GestureAgent(SmallInt(p2.x),SmallInt(p2.y));
end;
if radSpeak.Checked then SpeakAgent(PChar(edText.Text))
else
ThinkAgent(PChar(edText.Text));
end;

procedure TfrmDemo.KOLForm1FormCreate(Sender: PObj);
begin
if not InitAgent('{CA141FD0-AC7F-11D1-97A3-006008273002}') then MsgBox('Could not initialize Microsoft Agent 2.0',mb_iconhand);
end;

procedure TfrmDemo.KOLForm1Destroy(Sender: PObj);
begin
FreeAgent;
end;

procedure TfrmDemo.Button5Click(Sender: PObj);
begin
ChangeAgent;
end;

procedure TfrmDemo.Button4Click(Sender: PObj);
begin
PlayAgent(PChar(edAnim.Text));
end;

procedure TfrmDemo.Button1Click(Sender: PObj);
begin
StopAgent;
end;

end.



