{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, ListEdit {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckCtrls, mckListEdit,
  mckObjs {$ENDIF};
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
    KP: TKOLProject;
    KF: TKOLForm;
    LE: TKOLListEdit;
    procedure KOLFormFormCreate(Sender: PObj);
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

procedure TForm1.KOLFormFormCreate(Sender: PObj);
var x,
    y: integer;
begin
   for x := 0 to 5 do begin
      LE.LVAdd('S0' + Int2Str(x), 0, [], 0, 0, 0);
   end;
   for x := 0 to 5 do begin
      for y := 0 to 5 do begin
         LE.LVItems[y, x] := 'S' + int2str(y) + int2str(x);
      end;
   end;
end;

end.
















