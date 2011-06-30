{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHXP, KOLmdvToolTip {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Graphics, Controls,  MCKmdvToolTip,  mckObjs,  MCKMHXP{$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
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
    KOLProject: TKOLProject;
    Button1: TKOLButton;
    Memo1: TKOLMemo;
    KOLForm: TKOLForm;
    Button7: TKOLButton;
    KOLApplet: TKOLApplet;
    GroupBox1: TKOLGroupBox;
    Label1: TKOLLabel;
    edDelayAutomatic: TKOLEditBox;
    Label2: TKOLLabel;
    edDelayInit: TKOLEditBox;
    Label3: TKOLLabel;
    edDelayTime: TKOLEditBox;
    Label4: TKOLLabel;
    edDelayReshow: TKOLEditBox;
    ColorDialog: TKOLColorDialog;
    pnlColor: TKOLPanel;
    lblFontColor: TKOLLabel;
    cbBalloon: TKOLCheckBox;
    cbAlwaysTip: TKOLCheckBox;
    GroupBox2: TKOLGroupBox;
    Label5: TKOLLabel;
    edLeft: TKOLEditBox;
    Label6: TKOLLabel;
    edRight: TKOLEditBox;
    Label7: TKOLLabel;
    edTop: TKOLEditBox;
    Label8: TKOLLabel;
    edBottom: TKOLEditBox;
    edMaxWidth: TKOLEditBox;
    Label9: TKOLLabel;
    GroupBox3: TKOLGroupBox;
    Label10: TKOLLabel;
    edTitleText: TKOLEditBox;
    Label11: TKOLLabel;
    cbTitleIcon: TKOLComboBox;
    MHXP1: TKOLMHXP;
    Label12: TKOLLabel;
    GroupBox4: TKOLGroupBox;
    TrackingTreeView: TKOLTreeView;
    mdvToolTip: TKOLmdvToolTip;
    mdvToolTipTrack: TKOLmdvToolTip;
    TrackingPanel: TKOLPanel;
    procedure Button1Click(Sender: PObj);
    procedure Button7Click(Sender: PObj);
    procedure KOLFormFormCreate(Sender: PObj);
    procedure edDelayAutomaticChange(Sender: PObj);
    procedure edDelayInitChange(Sender: PObj);
    procedure edDelayTimeChange(Sender: PObj);
    procedure edDelayReshowChange(Sender: PObj);
    procedure lblFontColorClick(Sender: PObj);
    procedure pnlColorClick(Sender: PObj);
    procedure cbBalloonClick(Sender: PObj);
    procedure cbAlwaysTipClick(Sender: PObj);
    procedure edMarginChange(Sender: PObj);
    procedure edMaxWidthChange(Sender: PObj);
    procedure edTitleTextChange(Sender: PObj);
    procedure TrackingPanelMouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure TrackingListBoxMouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure MouseLeave(Sender: PObj);
    procedure TrackingPanelMouseEnter(Sender: PObj);
    procedure TrackingTreeViewMouseEnter(Sender: PObj);
  private
    procedure InitDelay;
    procedure SetHintPos;
  public
     MainForm_1, MainForm_2: PMainForm;
     TV_I: Cardinal;
  end;
var
  MainForm {$IFDEF KOL_MCK} : PMainForm {$ELSE} : TMainForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMainForm( var Result: PMainForm; AParent: PControl );
{$ENDIF}

implementation

uses Types;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Main_1.inc}
{$ENDIF}

procedure TMainForm.Button1Click(Sender: PObj);
begin
    mdvToolTip.ToolTip[Form.ActiveControl.Handle]:= Memo1.Text;
end;

procedure TMainForm.Button7Click(Sender: PObj);
begin
    mdvToolTip.ToolTip[Form.ActiveControl.Handle]:= mdvToolTip.ToolTip[Form.ActiveControl.Handle] + #13#10 + Memo1.Text;
end;

procedure TMainForm.KOLFormFormCreate(Sender: PObj);
begin
    edDelayAutomatic.Text:= Int2Str(mdvToolTip.DelayAutomatic);
    InitDelay;
    lblFontColor.Font.Color:= mdvToolTip.FontColor;
    pnlColor.Color:= mdvToolTip.Color;
    cbBalloon.Checked:= mdvToolTip.Balloon;
    cbAlwaysTip.Checked:= mdvToolTip.AlwaysTip;

    edLeft.Text:= Int2Str(mdvToolTip.Margin.Left);
    edRight.Text:= Int2Str(mdvToolTip.Margin.Right);
    edTop.Text:= Int2Str(mdvToolTip.Margin.Top);
    edBottom.Text:= Int2Str(mdvToolTip.Margin.Bottom);
    edMaxWidth.Text:= Int2Str(mdvToolTip.MaxWidth);
    TrackingTreeView.TVInsert(0, 0, 'Item 1');
    TrackingTreeView.TVInsert(0, 0, 'Item 2');
    TrackingTreeView.TVInsert(0, 0, 'Item 3');
    TrackingTreeView.TVInsert(0, 0, 'Item 4');
    TrackingTreeView.TVInsert(0, 0, 'Item 5');
    TrackingTreeView.TVInsert(0, 0, 'Item 6');
    TrackingTreeView.TVInsert(0, 0, 'Item 7');
    TrackingTreeView.TVInsert(0, 0, 'Item 8');
    TrackingTreeView.TVInsert(0, 0, 'Item 9');
end;

procedure TMainForm.edDelayAutomaticChange(Sender: PObj);
begin
    mdvToolTip.DelayAutomatic:= Str2Int(edDelayAutomatic.Text);
    InitDelay;
end;

procedure TMainForm.edDelayInitChange(Sender: PObj);
begin
    mdvToolTip.DelayInit:= Str2Int(edDelayInit.Text);
end;

procedure TMainForm.edDelayTimeChange(Sender: PObj);
begin
    mdvToolTip.DelayTime:= Str2Int(edDelayTime.Text);
end;

procedure TMainForm.edDelayReshowChange(Sender: PObj);
begin
    mdvToolTip.DelayReshow:= Str2Int(edDelayReshow.Text);
end;

procedure TMainForm.InitDelay;
begin
    edDelayInit.Text:= Int2Str(mdvToolTip.DelayInit);
    edDelayTime.Text:= Int2Str(mdvToolTip.DelayTime);
    edDelayReshow.Text:= Int2Str(mdvToolTip.DelayReshow);
end;

procedure TMainForm.lblFontColorClick(Sender: PObj);
begin
   if ColorDialog.Execute then begin
     lblFontColor.Font.Color:= ColorDialog.Color;
     mdvToolTip.FontColor:= ColorDialog.Color;
   end;
end;

procedure TMainForm.pnlColorClick(Sender: PObj);
begin
   if ColorDialog.Execute then begin
     pnlColor.Color:= ColorDialog.Color;
     mdvToolTip.Color:= ColorDialog.Color;
   end;
end;

procedure TMainForm.cbBalloonClick(Sender: PObj);
begin
    mdvToolTip.Balloon:= cbBalloon.Checked;
end;

procedure TMainForm.cbAlwaysTipClick(Sender: PObj);
begin
    mdvToolTip.AlwaysTip:= cbAlwaysTip.Checked;
end;

procedure TMainForm.edMarginChange(Sender: PObj);
begin
    mdvToolTip.Margin:= MakeRect(Str2Int(edLeft.Text), Str2Int(edTop.Text), Str2Int(edRight.Text), Str2Int(edBottom.Text));
end;

procedure TMainForm.edMaxWidthChange(Sender: PObj);
begin
    mdvToolTip.MaxWidth:= Str2Int(edMaxWidth.Text);
end;

procedure TMainForm.edTitleTextChange(Sender: PObj);
begin
    mdvToolTip.SetTitle(edTitleText.Text, TttIconType(cbTitleIcon.CurIndex));
end;

procedure TMainForm.SetHintPos;
var P: TPoint;
    R: TRect;
begin
    P:= GetHintValidPos;
    R:= mdvToolTipTrack.ToolTipRect;
    UpdateHintValidPos(R.Right-R.Left, R.Bottom-R.Top, P);
    mdvToolTipTrack.TrackHint(P.X, P.Y);
end;

procedure TMainForm.TrackingPanelMouseMove(Sender: PControl; var Mouse: TMouseEventData);
begin
    mdvToolTipTrack.ToolTip[Sender.Handle]:= 'Position: ' + Int2Str(Mouse.X)+' X '+Int2Str(Mouse.Y);
    SetHintPos;
end;

procedure TMainForm.TrackingPanelMouseEnter(Sender: PObj);
begin
    SetCapture(PControl(Sender).Handle);
    mdvToolTipTrack.ToolTip[PControl(Sender).Handle]:= 'Position: ';
    SetHintPos;
    mdvToolTipTrack.ShowHint(PControl(Sender).Handle, True);
end;

procedure TMainForm.TrackingListBoxMouseMove(Sender: PControl; var Mouse: TMouseEventData);
var P: TPoint;
    R: TRect;
    S: String;
    I: Cardinal;
begin
    I:= TrackingTreeView.TVItemAtPos(Mouse.X, Mouse.Y, I);
    if I = 0 then mdvToolTipTrack.ShowHint(Sender.Handle, False)
    else
      if TV_I <> I then begin
        mdvToolTipTrack.ToolTip[Sender.Handle]:= 'Handle of Item #'+Int2Str(I)+':   "'+ TrackingTreeView.TVItemText[I]+'"';
        GetCursorPos(P);
        R:= TrackingTreeView.TVItemRect[I, True]; R.Left:= R.Right;
        R.TopLeft:= TrackingTreeView.Client2Screen(R.TopLeft);
        mdvToolTipTrack.ShowHint(Sender.Handle, True);
        mdvToolTipTrack.TrackHint(R.Left, R.Top);
{        R.Right:= TrackingTreeView.Width;
        R.BottomRight:= TrackingTreeView.Client2Screen(R.BottomRight);
        mdvToolTipTrack.ToolTipRect:= R;
}
      end;
    TV_I:= I;
end;

procedure TMainForm.MouseLeave(Sender: PObj);
begin
    TV_I:= 0;
    mdvToolTipTrack.ShowHint(PControl(Sender).Handle, False);
    ReleaseCapture;    
end;

procedure TMainForm.TrackingTreeViewMouseEnter(Sender: PObj);
begin
    SetCapture(PControl(Sender).Handle);
end;

end.





















