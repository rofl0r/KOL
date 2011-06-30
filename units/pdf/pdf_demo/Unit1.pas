{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLPDF {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckPDF, mckObjs {$ENDIF};
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
    PDF1: TKOLPDF;
    MainMenu1: TKOLMainMenu;
    OpenDlg: TKOLOpenSaveDialog;
    procedure KOLForm1N2Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N4Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N13Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N6Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N8Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N9Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N10Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N11Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1N15Menu(Sender: PMenu; Item: Integer);
    procedure KOLForm1Resize(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  Yes: boolean = False;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1N2Menu(Sender: PMenu; Item: Integer);
begin
//  PDF1.SetSize(Form.ClientWidth,Form.ClientHeight);
  if OpenDlg.Execute then PDF1.LoadFile(OpenDlg.Filename);
end;

procedure TForm1.KOLForm1N4Menu(Sender: PMenu; Item: Integer);
begin
  PDF1.Print;
end;

procedure TForm1.KOLForm1N13Menu(Sender: PMenu; Item: Integer);
begin
  PDF1.PrintWithDialog;
end;

procedure TForm1.KOLForm1N6Menu(Sender: PMenu; Item: Integer);
begin
  Form.Close;
end;

procedure TForm1.KOLForm1N8Menu(Sender: PMenu; Item: Integer);
begin
  PDF1.GotoFirstPage;
end;

procedure TForm1.KOLForm1N9Menu(Sender: PMenu; Item: Integer);
begin
  PDF1.GotoLastPage;
end;

procedure TForm1.KOLForm1N10Menu(Sender: PMenu; Item: Integer);
begin
  PDF1.GotoNextPage;
end;

procedure TForm1.KOLForm1N11Menu(Sender: PMenu; Item: Integer);
begin
  PDF1.GotoPreviousPage;
end;

procedure TForm1.KOLForm1N15Menu(Sender: PMenu; Item: Integer);
begin
  MainMenu1.ItemChecked[8]:=not MainMenu1.ItemChecked[8];
  PDF1.SetShowToolbar(MainMenu1.ItemChecked[8]);
end;

procedure TForm1.KOLForm1Resize(Sender: PObj);
begin
  if Yes then PDF1.SetSize(Form.ClientWidth,Form.ClientHeight);
end;

procedure TForm1.KOLForm1Show(Sender: PObj);
begin
  Yes:=True;
end;

end.

