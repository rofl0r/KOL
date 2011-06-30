{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit EditFilterUnit;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,
  mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TfmEditFilter = class; PfmEditFilter = TfmEditFilter; {$ELSE OBJECTS} PfmEditFilter = ^TfmEditFilter; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TfmEditFilter.inc}{$ELSE} TfmEditFilter = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TfmEditFilter = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    eDir: TKOLEditBox;
    bBrowse: TKOLButton;
    eFilter: TKOLComboBox;
    dSelDir: TKOLOpenDirDialog;
    eAction: TKOLComboBox;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    Label3: TKOLLabel;
    eTime: TKOLEditBox;
    Label4: TKOLLabel;
    Panel1: TKOLPanel;
    Toolbar1: TKOLToolbar;
    bAdd: TKOLButton;
    bClose: TKOLButton;
    cSubdirectories: TKOLCheckBox;
    isSubdirs: TKOLImageShow;
    isAction: TKOLImageShow;
    procedure Toolbar1TB1Click(Sender: PControl; BtnID: Integer);
    procedure bCloseClick(Sender: PObj);
    procedure Toolbar1TB2Click(Sender: PControl; BtnID: Integer);
    procedure eTimeChar(Sender: PControl; var Key: Char; Shift: Cardinal);
    procedure bBrowseClick(Sender: PObj);
    procedure eDirChange(Sender: PObj);
    procedure bAddClick(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    procedure eActionChange(Sender: PObj);
    procedure cSubdirectoriesClick(Sender: PObj);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure KOLForm1Destroy(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    Operation: Integer;
  end;

var
  fmEditFilter {$IFDEF KOL_MCK} : PfmEditFilter {$ELSE} : TfmEditFilter {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewfmEditFilter( var Result: PfmEditFilter; AParent: PControl );
{$ENDIF}

implementation

uses MainUnit;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I EditFilterUnit_1.inc}
{$ENDIF}

procedure TfmEditFilter.bCloseClick(Sender: PObj);
begin
  Form.ModalResult := 1;
  Form.Hide;
end;

procedure TfmEditFilter.Toolbar1TB1Click(Sender: PControl; BtnID: Integer);
begin
  eTime.Text := Int2Str( Max( 0, Str2Int( eTime.Text ) - 1 ) );
end;

procedure TfmEditFilter.Toolbar1TB2Click(Sender: PControl; BtnID: Integer);
begin
  eTime.Text := Int2Str( Min( 10000, Str2Int( eTime.Text ) + 1 ) );
end;

procedure TfmEditFilter.eTimeChar(Sender: PControl; var Key: Char;
  Shift: Cardinal);
begin
  CASE Key OF
  '0'..'9',#8: ;
  else begin
         MessageBeep( DWORD( -1 ) );
         Key := #0;
       end;
  END;
end;

procedure TfmEditFilter.bBrowseClick(Sender: PObj);
begin
  if dSelDir.Execute then
  begin
    dSelDir.InitialPath := dSelDir.Path;
    eDir.Text := dSelDir.Path;
  end;
end;

procedure TfmEditFilter.eDirChange(Sender: PObj);
begin
  if DirectoryExists( eDir.Text ) then
  begin
    bAdd.Enabled := Trim( eFilter.Text ) <> '';
  end
    else
  begin
    bAdd.Enabled := FALSE;
  end;
end;

procedure TfmEditFilter.bAddClick(Sender: PObj);
var SubdirsFlag: Integer;
begin
  if cSubdirectories.Checked then SubdirsFlag := 4
                             else SubdirsFlag := 0;
  if Operation < 0 then
  begin
    fmMainGuard.MonitorList.AddObject( eDir.Text, eAction.CurIndex or SubdirsFlag );
    fmMainGuard.FiltersList.AddObject( eFilter.Text, Str2Int( eTime.Text ) );
    fmMainGuard.lv1.LVCount := fmMainGuard.MonitorList.Count;
  end
    else
  begin
    fmMainGuard.MonitorList.Items[ Operation ] := eDir.Text;
    fmMainGuard.MonitorList.Objects[ Operation ] := eAction.CurIndex or SubdirsFlag;
    fmMainGuard.FiltersList.Items[ Operation ] := eFilter.Text;
    fmMainGuard.FiltersList.Objects[ Operation ] := Str2Int( eTime.Text );
    fmMainGuard.lv1.Invalidate;
  end;
  if Operation >= 0 then
  begin
    Form.ModalResult := 1;
    Form.Hide;
  end;
  fmMainGuard.EnableCommands;
  fmMainGuard.PrepareTree;
  fmMainGuard.SaveSettings;
  fmMainGuard.ShowStatus;
  fmMainGuard.StorageTreeChanged := TRUE;
end;

var FirstShow: Boolean = TRUE;
procedure TfmEditFilter.KOLForm1Show(Sender: PObj);
var DR: TRect;
begin
  if FirstShow then
  begin
    FirstShow := FALSE;
    DR := GetDesktopRect;
    Form.Top := Min( DR.Bottom - Form.Height, fmMainGuard.Form.Top + fmMainGuard.Form.Height );
  end;
  CASE Operation OF
 -1: begin
       bAdd.Caption := 'Add';
       bClose.Caption := 'Close';
     end;
   else
     begin
       bAdd.Caption := 'OK';
       bClose.Caption := 'Cancel';
     end;
  END;
end;

procedure TfmEditFilter.eActionChange(Sender: PObj);
begin
  isAction.CurIndex := eAction.CurIndex;
end;

procedure TfmEditFilter.cSubdirectoriesClick(Sender: PObj);
begin
  isSubdirs.Visible := cSubdirectories.Checked;
end;

procedure TfmEditFilter.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  Accept := FALSE;
  Form.Hide;
  Applet.Show;
  if Applet.WindowState = wsMinimized then
    AppletRestore;
  fmMainGuard.Form.Show;
end;

procedure TfmEditFilter.KOLForm1Destroy(Sender: PObj);
begin
  fmEditFilter := nil;
  FirstShow := TRUE;
end;

end.



