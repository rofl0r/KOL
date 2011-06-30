{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLPageSetupDialog {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,
  mckPageSetup {$ENDIF};
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
    KOLProject1: TKOLProject;
    KOLApplet1: TKOLApplet;
    KOLForm1: TKOLForm;
    Panel1: TKOLPanel;
    Panel2: TKOLPanel;
    BitBtn1: TKOLBitBtn;
    RichEdit1: TKOLRichEdit;
    PageSetupDialog1: TKOLPageSetupDialog;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure BitBtn1Click(Sender: PObj);
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

uses KOLPrinters;
{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var
  s : String;
begin
  s := ExtractFilePath(ParamStr(0)) + 'demo.rtf';
  RichEdit1.RE_LoadFromFile(s,reRTF,false);
end;

procedure TForm1.BitBtn1Click(Sender: PObj);
begin
  PageSetupDialog1.SetMinMargins(500,500,500,500); //set min margins user can select
  PageSetupDialog1.SetMargins(1500,1500,1500,1500); //set initial margins in dialog
  {Becouse we will select psdHundrethsOfMillimeters each value must be multiply by 100}
if PageSetupDialog1.Execute then
    begin
      with Printer^ do
        begin
        Assign(PageSetupDialog1.Info);
        AssignMargins(PageSetupDialog1.GetMargins,mgMillimeters);//assign selected marins to printer
        Title := 'Printing RichEdit test with selected printer...';
        RE_Print(RichEdit1);
        end;
    end;
end;


end.



