{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, MapMem {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckMapMem {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
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
    KOLProject: TKOLProject;
    KOLForm: TKOLForm;
    ME: TKOLMemo;
    MM: TKOLMapMem;
    procedure MEChange(Sender: PObj);
    procedure MMUpdate(Sender: PObj);
    procedure KOLFormFormCreate(Sender: PObj);
    procedure MMAppListChange(Sender: PObj);
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
{$I KOLForm_1.inc}
{$ENDIF}

procedure TForm1.MEChange(Sender: PObj);
begin
   MM.MapStrings.Clear;
   MM.MapStrings.SetText(ME.Text, false);
   MM.WriteMap;
end;

procedure TForm1.MMUpdate(Sender: PObj);
var buf: string;
begin
   buf := MM.MapStrings.Text;
   ME.Text := buf;
end;

procedure TForm1.KOLFormFormCreate(Sender: PObj);
begin
   ME.Text := MM.MapStrings.Text;   
end;

procedure TForm1.MMAppListChange(Sender: PObj);
begin
   beep(500, 500);
   Form.Top  := Form.Top  + 20;
   Form.Left := Form.Left + 20;
end;

end.









