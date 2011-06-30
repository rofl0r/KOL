{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLmdvGliphLabel {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,  MSKmdvXLGrid,  mckUpDown, mckObjs,  MCKMHFontDialog,  MCKMHUpDown,  MSKmdvPanel,  ExtCtrls,  mckmdvGliphLabel {$ENDIF};
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
    KOLForm: TKOLForm;
    KOLProject: TKOLProject;
    Timer: TKOLTimer;
    EditBox: TKOLEditBox;
    TextAlign: TKOLGroupBox;
    otaLeft: TKOLRadioBox;
    otaRight: TKOLRadioBox;
    otaCenter: TKOLRadioBox;
    VerticalAlign: TKOLGroupBox;
    ovaTop: TKOLRadioBox;
    ovaCenter: TKOLRadioBox;
    ovaBottom: TKOLRadioBox;
    mdvGliphLabel_Date: TKOLmdvGliphLabel;
    mdvGliphLabel_Time: TKOLmdvGliphLabel;
    mdvGliphLabel: TKOLmdvGliphLabel;
    cbTransparent: TKOLCheckBox;
    cbTransparentLabel: TKOLCheckBox;
    procedure TimerTimer(Sender: PObj);
    procedure KOLFormFormCreate(Sender: PObj);
    procedure EditBoxChange(Sender: PObj);
    procedure otaClick(Sender: PObj);
    procedure ovaClick(Sender: PObj);
    procedure cbTransparentClick(Sender: PObj);
    procedure cbTransparentLabelClick(Sender: PObj);
  private
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

procedure TMainForm.TimerTimer(Sender: PObj);
begin
    mdvGliphLabel_Time.Caption:= Time2StrFmt('HH:mm:ss', Now);
    mdvGliphLabel_Date.Caption:= Date2StrFmt('dd-MM-yyyy', Date);
end;

procedure TMainForm.KOLFormFormCreate(Sender: PObj);
begin
    mdvGliphLabel_Date.GlyphBitmap:= LoadBmp( hInstance, 'MDVGLIPHLABEL_TIME_BITMAP', Form );
    mdvGliphLabel.GlyphBitmap:= LoadBmp( hInstance, 'MDVGLIPHLABEL_TIME_BITMAP', Form );
    TimerTimer(nil)
end;

procedure TMainForm.EditBoxChange(Sender: PObj);
begin
    mdvGliphLabel.Caption:= EditBox.Text;
end;

procedure TMainForm.otaClick(Sender: PObj);
begin
    if otaLeft.Checked then mdvGliphLabel.TextAlign:= taLeft;
    if otaCenter.Checked then mdvGliphLabel.TextAlign:= taCenter;
    if otaRight.Checked then mdvGliphLabel.TextAlign:= taRight;
end;

procedure TMainForm.ovaClick(Sender: PObj);
begin
    if ovaTop.Checked then mdvGliphLabel.VerticalAlign:= vaTop;
    if ovaCenter.Checked then mdvGliphLabel.VerticalAlign:= vaCenter;
    if ovaBottom.Checked then mdvGliphLabel.VerticalAlign:= vaBottom;
    mdvGliphLabel.Invalidate;
end;

procedure TMainForm.cbTransparentClick(Sender: PObj);
begin
    mdvGliphLabel.Transparent:= cbTransparent.Checked;
end;

procedure TMainForm.cbTransparentLabelClick(Sender: PObj);
begin
    mdvGliphLabel.TransparentLabel:= cbTransparentLabel.Checked;
end;

end.











































































































































































