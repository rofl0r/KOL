{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Logger;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,  mckFormSave {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm3 = class; PForm3 = TForm3; {$ELSE OBJECTS} PForm3 = ^TForm3; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm3.inc}{$ELSE} TForm3 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm3 = class(TForm)
  {$ENDIF KOL_MCK}
    KF: TKOLForm;
    LM: TKOLMemo;
    FormSave1: TKOLFormSave;
    procedure KFClose(Sender: PObj; var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3 {$IFDEF KOL_MCK} : PForm3 {$ELSE} : TForm3 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm3( var Result: PForm3; AParent: PControl );
{$ENDIF}

implementation

uses KOLForm;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Logger_1.inc}
{$ENDIF}

procedure TForm3.KFClose(Sender: PObj; var Accept: Boolean);
begin
   Accept := False;
   Form.Hide;
end;

end.
































































