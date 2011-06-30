{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit AskBox;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls, Graphics {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm4 = class; PForm4 = TForm4; {$ELSE OBJECTS} PForm4 = ^TForm4; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm4.inc}{$ELSE} TForm4 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm4 = class(TForm)
  {$ENDIF KOL_MCK}
    KF: TKOLForm;
    B1: TKOLButton;
    B2: TKOLButton;
    B3: TKOLButton;
    LE: TKOLEditBox;
    procedure KFResize(Sender: PObj);
    procedure B1Click(Sender: PObj);
    procedure B2Click(Sender: PObj);
    procedure B3Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    append,
    cancel: boolean;
  end;

var
  Form4 {$IFDEF KOL_MCK} : PForm4 {$ELSE} : TForm4 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm4( var Result: PForm4; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I AskBox_1.inc}
{$ENDIF}

procedure TForm4.KFResize(Sender: PObj);
var m: integer;
    n: integer;
begin
   if LE = Nil then exit;
   n           := Form.Width - Form.ClientWidth;
   LE.Left     := 15;
   LE.Top      := 15;
   m := Form.Canvas.TextWidth(LE.Caption);
   LE.Width    := m + 10;
   Form.Width  := LE.Width + 30 + n;
   Form.Height := 45 + LE.Height + B1.Height + n;
   m := Form.ClientWidth div 2;
   B1.Left := m - 200;
   if B1.Left < LE.Left then B1.Left := LE.Left;
   B1.Top  := 30 + LE.Height;
   B2.Left :=  m - 50;
   B2.Top  := 30 + LE.Height;
   B3.Left := m + 100;
   if B3.Left + 100 > LE.Left + LE.Width then B3.Left := LE.Left + LE.Width - 100;
   B3.Top  := 30 + LE.Height;
end;

procedure TForm4.B1Click(Sender: PObj);
begin
   append := false;
   cancel := false;
   Form.ModalResult := 1;
   Form.Hide;
end;
 
procedure TForm4.B2Click(Sender: PObj);
begin
   append := true;
   cancel := false;
   Form.ModalResult := 1;
   Form.Hide;
end;

procedure TForm4.B3Click(Sender: PObj);
begin
   append := false;
   cancel := true;
   Form.ModalResult := 1;
   Form.Hide;
end;

end.






