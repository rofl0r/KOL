{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface



{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, DatePicker {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckDatePicker {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
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
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    Button1: TKOLButton;
    Button2: TKOLButton;
    KOLForm1: TKOLForm;
    KOLApplet1: TKOLApplet;
    Button3: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    DatePicker1: TKOLDatePicker;
    procedure DatePicker1Change(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure DatePicker1CloseUp(Sender: PObj);
    procedure DatePicker1DropDown(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure DatePicker1EraseBkgnd(Sender: PControl; DC: HDC);
  private
    { Private declarations }
    Font   : PGraphicTool;
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

procedure TForm1.DatePicker1Change(Sender: PObj);
begin
Label1.Caption := DateTime2StrShort(DatePicker1.DateTime);
label2.Caption := 'OnChange';
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
Font := NewFont;
Font.FontName := 'Ariel CE';
Font.FontHeight := -10;
Font.FontStyle := [fsItalic];
DatePicker1.OnChange := DatePicker1Change;
DatePicker1.OnDropDown := DatePicker1DropDown;
DatePicker1.OnCloseUp := DatePicker1CloseUp;
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
if DatePicker1.Checked then Label2.Caption := 'Checked'
else
Label2.Caption := 'Not checked';

end;

procedure TForm1.Button2Click(Sender: PObj);
begin
with DatePicker1^ do begin
Color[clBackground] := clGreen;
Color[clTitleText] := clMaroon;
Color[clTitlebk] := clBlue;
Color[clText] := clRed;
Color[clMonthBk] := clYellow;
Color[clTrailing] := clWhite;
end;

end;

procedure TForm1.DatePicker1CloseUp(Sender: PObj);
begin
label2.Caption := 'OnCloseUp';
end;

procedure TForm1.DatePicker1DropDown(Sender: PObj);
begin
label2.Caption := 'OnDropDown';
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
DatePicker1.Format := '*** yyyy-MM-dd ***';
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
Font.Free;
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
DatePicker1.MCFont := Font;
end;

procedure TForm1.Button5Click(Sender: PObj);
begin
DatePicker1.Font.Assign(Font);
end;


procedure TForm1.DatePicker1EraseBkgnd(Sender: PControl; DC: HDC);
var
R : TRect;
begin
GetClientRect( Sender.Handle, R );
Sender.Canvas.Brush.Color := clAqua;;
Sender.Canvas.FillRect(R);
end;

end.






























































