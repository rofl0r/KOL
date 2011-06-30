{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLFontComboBox, KOLColorComboBox {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, mckColorComboBox, mckFontComboBox, Controls {$ENDIF}, err;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
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
    KOLApplet1: TKOLApplet;
    KOLForm1: TKOLForm;
    KOLProject1: TKOLProject;
    Panel1: TKOLPanel;
    RichEdit1: TKOLRichEdit;
    FontComboBox1: TKOLFontComboBox;
    ColorComboBox1: TKOLColorComboBox;
    procedure FontComboBox1Change(Sender: PObj);
    procedure ColorComboBox1Change(Sender: PObj);
    procedure RichEdit1SelChange(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
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

procedure TForm1.FontComboBox1Change(Sender: PObj);
begin
  RichEdit1.RE_FmtFontName := PFontCombo(Sender).FontName;
  RichEdit1.Focused := TRUE;
end;

procedure TForm1.ColorComboBox1Change(Sender: PObj);
begin
  RichEdit1.RE_FmtFontColor  := PColorCombo(Sender).ColorSelected;
  RichEdit1.Focused := TRUE;
end;

procedure TForm1.RichEdit1SelChange(Sender: PObj);
var
x : TColor;
begin
FontComboBox1.FontName := RichEdit1.RE_FmtFontName;
if RichEdit1.RE_FmtFontColorValid then
        begin
        x := RichEdit1.RE_FmtFontColor;
        ColorComboBox1.ColorSelected := x;
        end;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var
s : String;
begin
s := ExtractFilePath(ParamStr(0)) + 'readme.rtf';
RichEdit1.RE_FmtAutoColor := False;
RichEdit1.RE_LoadFromFile(s,reRTF,False);
end;

end.











