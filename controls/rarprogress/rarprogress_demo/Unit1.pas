{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLRarProgBar {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckTrackbar,  MCKMHTrackBar,  mckCProgBar,  mckRarProgBar,
  mckObjs {$ENDIF};
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
    RarProgressBar1: TRarProgressBar;
    Timer1: TKOLTimer;
    procedure Timer1Timer(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  I: integer = 0;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.Timer1Timer(Sender: PObj);
begin
  RarProgressbar1.Position1:=I;
  if I>9 then RarProgressbar1.Position2:=I-10;
  Inc(I);
  if I=100 then
    begin
      I:=0;
      RarProgressbar1.Position2:=I;
      RarProgressbar1.Position1:=I;
    end;
end;

procedure TForm1.KOLForm1Show(Sender: PObj);
begin
  Timer1.Enabled:=True;
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  Timer1.Enabled:=False;
end;

end.

