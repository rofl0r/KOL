{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit RestoreUnit;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,  mckCtrls, mckDatePicker {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TfmRestore = class; PfmRestore = TfmRestore; {$ELSE OBJECTS} PfmRestore = ^TfmRestore; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TfmRestore.inc}{$ELSE} TfmRestore = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TfmRestore = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    Panel1: TKOLPanel;
    lFilesCount: TKOLLabel;
    Label1: TKOLLabel;
    eDate: TKOLDateTimePicker;
    eTime: TKOLDateTimePicker;
    Button1: TKOLButton;
    Button2: TKOLButton;
    cSubdirsRecursively: TKOLCheckBox;
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    OnRestore: TOnEvent;
  end;

var
  fmRestore {$IFDEF KOL_MCK} : PfmRestore {$ELSE} : TfmRestore {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewfmRestore( var Result: PfmRestore; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I RestoreUnit_1.inc}
{$ENDIF}

procedure TfmRestore.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  Accept := FALSE;
  Form.Hide;
end;

procedure TfmRestore.Button1Click(Sender: PObj);
begin
  Form.ModalResult := 1;
  Form.Hide;
  if Assigned( OnRestore ) then
    OnRestore( @ Self );
end;

procedure TfmRestore.Button2Click(Sender: PObj);
begin
  Form.ModalResult := -1;
  Form.Hide;
end;

end.





