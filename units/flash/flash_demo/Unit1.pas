{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLFlash {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckFlash, Graphics, mckCtrls, mckObjs {$ENDIF};
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
    Flash1: TKOLFlash;
    Button1: TKOLButton;
    Button2: TKOLButton;
    Button3: TKOLButton;
    OpenDlg: TKOLOpenSaveDialog;
    Button4: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Button4Click(Sender: PObj);
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
  Flash1.SetSize(Form.ClientWidth,200);
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
  if OpenDlg.Execute then
    begin
      Flash1.LoadMovie(0,OpenDlg.Filename);
      Button3.Enabled:=True;
      Button4.Enabled:=True;
    end;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  Flash1.Play;
  Button2.Enabled:=False;
  Button3.Enabled:=True;
  Button4.Enabled:=True;
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  Flash1.Stop;
  Button2.Enabled:=True;
  Button3.Enabled:=False;
  Button4.Enabled:=True;
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  Flash1.Stop;
  Flash1.FrameNum:=0;
  Button2.Enabled:=True;
  Button3.Enabled:=False;
  Button4.Enabled:=False;
end;

end.

