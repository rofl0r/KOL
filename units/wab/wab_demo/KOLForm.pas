{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF};
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
    LB: TKOLListBox;
    ME: TKOLListBox;
    procedure KFFormCreate(Sender: PObj);
    procedure LVChange(Sender: PObj);
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

uses KOLWAB;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}

var wab: PKOLWAB;

procedure TForm1.KFFormCreate(Sender: PObj);
var
   i: integer;
begin
   wab := NewKOLWAB;
   wab.setToDefaultAddressBook;
   wab.loadFile;
   for i := 0 to wab.Contacts.Count - 1 do begin
      LB.Add(wab.contacts.Items[i]);
   end;
   LVChange(@self);
end;

procedure TForm1.LVChange(Sender: PObj);
var i: integer;
begin
   wab.getPropertiesOf(LB.Items[LB.CurIndex]);
   ME.clear;
   for i := 0 to wab.properties.Count - 1 do begin
      ME.add(wab.properties.Items[i]);
   end;
end;

end.








