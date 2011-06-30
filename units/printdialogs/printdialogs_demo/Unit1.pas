{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLPageSetupDialog, KOLPrintDialogs {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls,  mckPrintDialogs,  mckPageSetup {$ENDIF};
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
    Button1: TKOLButton;
    Button2: TKOLButton;
    CheckBox1: TKOLCheckBox;
    Memo1: TKOLMemo;
    Button3: TKOLButton;
    PageSetupDialog1: TKOLPageSetupDialog;
    PrintDialog1: TKOLPrintDialog;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
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
uses KOLPrinters;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}



procedure TForm1.Button1Click(Sender: PObj);
var
Error : Integer;
begin

if PageSetupDialog1.Execute then
    begin
      with Printer^ do
        begin
        Assign(PageSetupDialog1.Info);
        AssignMargins(PageSetupDialog1.GetMargins,mgMillimeters);//assign selected marins to printer
        Canvas.Font.Assign(Memo1.Font);
        Title := 'Printing test with selected printer...';
        if CheckBox1.Checked then  Output := 'c:\printer.prn';
        BeginDoc;
        WriteLn(Memo1.Text);
        WriteLn(#10#13);
        WriteLn(' This is the end ' + #10#13);
        EndDoc;
        if CheckBox1.Checked then  ShowMessage('Text printed to file : c:\printer.prn');
        end;
    end
    else
        begin
          Error := PageSetupDialog1.Error;
          if Error <> 0 then MsgBox('PageSetup dialog Error:' + Int2Str(Error),mb_iconhand);
        end;
end;



procedure TForm1.Button2Click(Sender: PObj);
var
  i : Integer;
begin
with Printer^ do
  begin
        Assign(nil);
        if not Assigned then begin
        MsgBox('There is no default printer in system!',mb_iconexclamation);
        Exit;
        end;
        Title := 'Printing test 0...';
        Canvas.Font.Assign(Memo1.Font);
        if CheckBox1.Checked then  Output := 'c:\printer.prn';
        BeginDoc;
          for i:=0 to Memo1.Count-1 do  WriteLn(Memo1.Items[i]);
//        WriteLn(Memo1.Text);
        EndDoc;
        if CheckBox1.Checked then  ShowMessage('Text printed to file : c:\printer.prn');
  end;
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
PrintDialog1.Options := PrintDialog1.Options + [pdPrintToFile,pdSelection,pdCollate,pdPageNums];
if PrintDialog1.Execute then
    begin
      with Printer^ do
        begin
        Assign(PrintDialog1.Info);
        Canvas.Font.Assign(Memo1.Font);
        Title := 'Printing test with selected printer...';
        if CheckBox1.Checked  then  Printer.Output := 'c:\printer.prn';
        BeginDoc;
        WriteLn(Memo1.Text);
        WriteLn(#10#13);
        WriteLn(' This is the end ' + #10#13);
        EndDoc;        
        if pdPrintToFile in PrintDialog1.Options  then  ShowMessage('Print to file! (You know the name of this file)');
        if pdSelection in PrintDialog1.Options then MsgOk('Print selection only');
        if pdCollate in PrintDialog1.Options then MsgOK('Collate');
        MsgOK('Selected copies:' + Int2Str(PrintDialog1.Copies));
        if pdPageNums in PrintDialog1.Options then MsgOK(Format('Print selected pages only: from %d to %d',[PrintDialog1.FromPage,PrintDialog1.ToPage]));
         end;
    end;

end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  PageSetupDialog1.SetMinMargins(500,500,500,500); //set min margins user can select
  PageSetupDialog1.SetMargins(1500,1500,1500,1500); //set initial margins in dialog
  {Becouse we will select psdHundrethsOfMillimeters each value must be multiply by 100}

end;

end.






















