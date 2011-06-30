{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Options;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  POptionsForm = ^TOptionsForm;
  TOptionsForm = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TOptionsForm = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm2: TKOLForm;
    CheckBox1: TKOLCheckBox;
    procedure KOLForm2Close(Sender: PObj; var Accept: Boolean);
    procedure KOLForm2Destroy(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsForm {$IFDEF KOL_MCK} : POptionsForm {$ELSE} : TOptionsForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewOptionsForm( var Result: POptionsForm; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Options_1.inc}
{$ENDIF}

procedure TOptionsForm.KOLForm2Close(Sender: PObj; var Accept: Boolean);
begin
  if CheckBox1.Checked then
  begin
    Accept := FALSE;
    Form.Hide;
  end;
end;

procedure TOptionsForm.KOLForm2Destroy(Sender: PObj);
begin
  OptionsForm := nil;
end;

end.
 
 













