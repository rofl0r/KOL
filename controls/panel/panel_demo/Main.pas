{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHUpDown, KOLmdvPanel {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,  MSKmdvXLGrid,  mckUpDown, mckObjs,  MCKMHFontDialog,  MCKMHUpDown,  MCKmdvPanel,  ExtCtrls,
  MSKmdvPanel {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TMainForm = class; PMainForm = TMainForm; {$ELSE OBJECTS} PMainForm = ^TMainForm; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TMainForm.inc}{$ELSE} TMainForm = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMainForm = class(TForm)
  {$ENDIF KOL_MCK}
    BevelOuter: TKOLGroupBox;
    obvNone: TKOLRadioBox;
    obvLowered: TKOLRadioBox;
    obvSpace: TKOLRadioBox;
    obvRaised: TKOLRadioBox;
    GroupBox1: TKOLGroupBox;
    ibvNone: TKOLRadioBox;
    ibvLowered: TKOLRadioBox;
    ibvSpace: TKOLRadioBox;
    ibvRaised: TKOLRadioBox;
    Label1: TKOLLabel;
    eBevelWidth: TKOLEditBox;
    Label2: TKOLLabel;
    eBorderWidth: TKOLEditBox;
    BorderStyle: TKOLGroupBox;
    rbsNone: TKOLRadioBox;
    rbsSingle: TKOLRadioBox;
    MHUpDown1: TKOLMHUpDown;
    MHUpDown2: TKOLMHUpDown;
    mdvPanel: TKOLmdvPanel;
    KOLForm: TKOLForm;
    KOLProject: TKOLProject;
    procedure rbsNoneClick(Sender: PObj);
    procedure obvNoneClick(Sender: PObj);
    procedure ibvNoneClick(Sender: PObj);
    procedure eBorderWidthChange(Sender: PObj);
    procedure eBevelWidthChange(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm {$IFDEF KOL_MCK} : PMainForm {$ELSE} : TMainForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMainForm( var Result: PMainForm; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Main_1.inc}
{$ENDIF}

procedure TMainForm.rbsNoneClick(Sender: PObj);
begin
    mdvPanel.BorderStyle:= TBorderStyle(Sender.Tag);
end;

procedure TMainForm.obvNoneClick(Sender: PObj);
begin
    mdvPanel.BevelOuter:= TBevelCut(Sender.Tag);
end;

procedure TMainForm.ibvNoneClick(Sender: PObj);
begin
    mdvPanel.BevelInner:= TBevelCut(Sender.Tag);
end;

procedure TMainForm.eBorderWidthChange(Sender: PObj);
begin
    mdvPanel.BorderWidth:= Str2Int(eBorderWidth.Text);
end;

procedure TMainForm.eBevelWidthChange(Sender: PObj);
begin
    mdvPanel.BevelWidth:= Str2Int(eBevelWidth.Text);
end;

end.






































































