{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHTrackBar, KOLmdvDialogEx {$IFNDEF KOL_MCK}, mirror, Classes,  MCKmdvDialogEx, Controls, mckCtrls, mckObjs,  MCKMHTrackBar,  MSKmdvPanel, Graphics
{$ENDIF}, CommDlg;
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
    DialogEx: TKOLmdvDialogEx;
    PanelPictPreview: TKOLPanel;
    PaintBox: TKOLPaintBox;
    cbStretch: TKOLCheckBox;
    PanelTextPreview: TKOLPanel;
    Memo: TKOLMemo;
    TabControl1: TKOLTabControl;
    TabControl1_Tab0: TKOLPanel;
    ColorTab: TKOLPanel;
    btnSimpleOpenDialog: TKOLButton;
    btnSimpleSaveDialog: TKOLButton;
    btnPictureOpenDialog: TKOLButton;
    btnTextSaveDialog: TKOLButton;
    mFiles: TKOLMemo;
    fdOptions: TKOLGroupBox;
    ofNoValidate: TKOLCheckBox;
    ofShowHelp: TKOLCheckBox;
    ofNoChangeDir: TKOLCheckBox;
    ofHideReadOnly: TKOLCheckBox;
    ofOverwritePrompt: TKOLCheckBox;
    ofReadOnly: TKOLCheckBox;
    ofAllowMultiSelect: TKOLCheckBox;
    ofExtensionDifferent: TKOLCheckBox;
    ofPathMustExist: TKOLCheckBox;
    ofNoReadOnlyReturn: TKOLCheckBox;
    ofNoTestFileCreate: TKOLCheckBox;
    ofNoNetworkButton: TKOLCheckBox;
    ofNoLongNames: TKOLCheckBox;
    ofOldStyleDialog: TKOLCheckBox;
    ofNoDereferenceLinks: TKOLCheckBox;
    ofEnableIncludeNotify: TKOLCheckBox;
    ofEnableSizing: TKOLCheckBox;
    ofDontAddToRecent: TKOLCheckBox;
    ofFileMustExist: TKOLCheckBox;
    ofCreatePrompt: TKOLCheckBox;
    ofShareAware: TKOLCheckBox;
    ofForceShowHidden: TKOLCheckBox;
    ofExNoPlacesBar: TKOLCheckBox;
    edfdFilter: TKOLEditBox;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    edfdFilterIndex: TKOLEditBox;
    edfdInitialDir: TKOLEditBox;
    Label3: TKOLLabel;
    Label4: TKOLLabel;
    Label5: TKOLLabel;
    edfdTitle: TKOLEditBox;
    edfdDefaultExt: TKOLEditBox;
    pnlCMYK: TKOLPanel;
    Label6: TKOLLabel;
    tbCyan: TKOLMHTrackBar;
    lblCyan: TKOLLabel;
    Label7: TKOLLabel;
    tbMagenta: TKOLMHTrackBar;
    Label8: TKOLLabel;
    Label9: TKOLLabel;
    tbBlack: TKOLMHTrackBar;
    tbYellow: TKOLMHTrackBar;
    pnlCustomColors: TKOLPanel;
    Panel2: TKOLPanel;
    Panel3: TKOLPanel;
    Panel4: TKOLPanel;
    Panel5: TKOLPanel;
    Panel6: TKOLPanel;
    Panel7: TKOLPanel;
    Panel8: TKOLPanel;
    Panel9: TKOLPanel;
    Panel10: TKOLPanel;
    Panel11: TKOLPanel;
    Panel12: TKOLPanel;
    Panel13: TKOLPanel;
    Panel14: TKOLPanel;
    Panel15: TKOLPanel;
    Panel16: TKOLPanel;
    Panel17: TKOLPanel;
    Label10: TKOLLabel;
    ColorPanel: TKOLPanel;
    GroupBox1: TKOLGroupBox;
    cdAnyColor: TKOLCheckBox;
    cdSolidColor: TKOLCheckBox;
    cdShowHelp: TKOLCheckBox;
    cdPreventFullOpen: TKOLCheckBox;
    cdFullOpen: TKOLCheckBox;
    edColorTitle: TKOLEditBox;
    Label11: TKOLLabel;
    btnSimpleColorDialog: TKOLButton;
    btnCMYKColorDialog: TKOLButton;
    KOLForm: TKOLForm;
    procedure btnSimpleOpenDialogClick(Sender: PObj);
    procedure btnSimpleSaveDialogClick(Sender: PObj);
    procedure ofOptionsClick(Sender: PObj);
    procedure edfdChange(Sender: PObj);
    procedure btnPictureOpenDialogClick(Sender: PObj);
    procedure KOLFormFormCreate(Sender: PObj);
    procedure PaintBoxPaint(Sender: PControl; DC: HDC);
    procedure cbStretchClick(Sender: PObj);
    procedure btnTextSaveDialogClick(Sender: PObj);
    procedure DialogExfdOnSelectionChange(Sender: PObj;
      ADialogTypeEx: TDialogTypeEx);
    procedure DialogExcdOnChangeColor(Sender: PObj; AColor: Integer);
    procedure DialogExcdOnChangeCustomColors(Sender: PObj;
      ACustomColors: TCustomColors);
    procedure tbScroll(Sender: PControl; Bar: TScrollerBar; ScrollCmd,
      ThumbPos: Cardinal);
    procedure btnSimpleColorDialogClick(Sender: PObj);
    procedure cdClick(Sender: PObj);
    procedure btnCMYKColorDialogClick(Sender: PObj);
  private
    Bmp: PBitmap;
    Chng: Boolean;
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

procedure TMainForm.KOLFormFormCreate(Sender: PObj);
begin
    Bmp:= NewBitmap(0, 0);
    Chng:= False;
end;

procedure TMainForm.btnSimpleOpenDialogClick(Sender: PObj);
begin
    ofOptionsClick(nil); edfdChange(nil);
    DialogEx.ExecuteFileDialog(False);
    mFiles.Text:= DialogEx.fdFileNames;
end;

procedure TMainForm.btnSimpleSaveDialogClick(Sender: PObj);
begin
    ofOptionsClick(nil); edfdChange(nil);
    DialogEx.ExecuteFileDialog(True);
    mFiles.Text:= DialogEx.fdFileNames;
end;

procedure TMainForm.btnPictureOpenDialogClick(Sender: PObj);
begin
    ofOptionsClick(nil); edfdChange(nil);
    DialogEx.fdFilterIndex:= 2;
    DialogEx.fdOptions:= DialogEx.fdOptions - [KOLmdvDialogEx.ofAllowMultiSelect];
    DialogEx.ExecuteFileDialog(False, PanelPictPreview, edfdTitle.Text);
    mFiles.Text:= DialogEx.fdFileNames;
end;

procedure TMainForm.btnTextSaveDialogClick(Sender: PObj);
begin
    ofOptionsClick(nil); edfdChange(nil);
    DialogEx.fdFilterIndex:= 3;
    DialogEx.fdOptions:= DialogEx.fdOptions - [KOLmdvDialogEx.ofAllowMultiSelect];
    DialogEx.ExecuteFileDialog(True, PanelTextPreview, edfdTitle.Text);
    mFiles.Text:= DialogEx.fdFileNames;
end;

procedure TMainForm.ofOptionsClick(Sender: PObj);
begin
    DialogEx.fdOptions:= []; DialogEx.fdOptionsEx:= [];
    if ofReadOnly.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofReadOnly];
    if ofOverwritePrompt.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofOverwritePrompt];
    if ofHideReadOnly.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofHideReadOnly];
    if ofNoChangeDir.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoChangeDir];
    if ofShowHelp.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofShowHelp];
    if ofNoValidate.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoValidate];
    if ofAllowMultiSelect.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofAllowMultiSelect];
    if ofExtensionDifferent.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofExtensionDifferent];
    if ofPathMustExist.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofPathMustExist];
    if ofFileMustExist.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofFileMustExist];
    if ofCreatePrompt.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofCreatePrompt];
    if ofShareAware.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofShareAware];
    if ofNoReadOnlyReturn.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoReadOnlyReturn];
    if ofNoTestFileCreate.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoTestFileCreate];
    if ofNoNetworkButton.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoNetworkButton];
    if ofNoLongNames.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoLongNames];
    if ofOldStyleDialog.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofOldStyleDialog];
    if ofNoDereferenceLinks.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofNoDereferenceLinks];
    if ofEnableIncludeNotify.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofEnableIncludeNotify];
    if ofEnableSizing.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofEnableSizing];
    if ofDontAddToRecent.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofDontAddToRecent];
    if ofForceShowHidden.Checked then DialogEx.fdOptions:= DialogEx.fdOptions + [KOLmdvDialogEx.ofForceShowHidden];
    if ofExNoPlacesBar.Checked then DialogEx.fdOptionsEx:= DialogEx.fdOptionsEx + [KOLmdvDialogEx.ofExNoPlacesBar];
end;

procedure TMainForm.edfdChange(Sender: PObj);
begin
    DialogEx.fdFilter:= edfdFilter.Text;
    DialogEx.fdFilterIndex:= Str2Int(edfdFilterIndex.Text);
    DialogEx.fdInitialDir:= edfdInitialDir.Text;
    DialogEx.fdDefaultExt:= edfdDefaultExt.Text;
end;

procedure TMainForm.PaintBoxPaint(Sender: PControl; DC: HDC);
begin
    FillRect(DC, PaintBox.ClientRect, PaintBox.canvas.brush.Handle);
    if cbStretch.Checked then Bmp.StretchDraw(DC, PaintBox.ClientRect)
    else Bmp.Draw(DC, 0, 0);
end;

procedure TMainForm.cbStretchClick(Sender: PObj);
begin
    PaintBox.Invalidate;
    SetFocus(0);
end;

procedure TMainForm.DialogExfdOnSelectionChange(Sender: PObj;
  ADialogTypeEx: TDialogTypeEx);
var SList: PStrList;
begin
    mFiles.Text:= DialogEx.fdFileName;
    if DialogEx.fdFilterIndex = 2 then begin
      Bmp.LoadFromFile(DialogEx.fdFileName);
      PaintBox.Invalidate;
    end;
    if DialogEx.fdFilterIndex = 3 then begin
      SList:= NewStrList;
      SList.LoadFromFile(DialogEx.fdFileName);
      Memo.Text:= SList.Text;
      SList.Free;
    end;
end;

procedure RGBTOCMYK(R, G, B : byte; var C, M, Y, K : byte);
begin
  C := 255 - R; M := 255 - G; Y := 255 - B;
  if C < M then K := C else K := M;
  if Y < K then K := Y;
  if k > 0 then begin
    c := c - k; m := m - k; y := y - k;
  end;
end;
procedure CMYKTORGB(C, M, Y, K: byte; var R, G, B : byte);
begin
   if (Integer(C) + Integer(K)) < 255 then R := 255 - (C + K) else R := 0;
   if (Integer(M) + Integer(K)) < 255 then G := 255 - (M + K) else G := 0;
   if (Integer(Y) + Integer(K)) < 255 then B := 255 - (Y + K) else B := 0;
end;

procedure TMainForm.DialogExcdOnChangeColor(Sender: PObj; AColor: Integer);
var C, M, Y, K: byte;
begin
    ColorPanel.Color:= AColor;
    if Chng then Exit;
    Chng:= True;
    RGBTOCMYK(GetRValue(AColor), GetGValue(AColor), GetBValue(AColor), C, M, Y, K);
    tbCyan.Position:= C; tbMagenta.Position:= M; tbYellow.Position:= Y; tbBlack.Position:= K;
    Chng:= False;
end;

procedure TMainForm.DialogExcdOnChangeCustomColors(Sender: PObj;
  ACustomColors: TCustomColors);
var i: Integer;
begin
    for i:= 0 to pnlCustomColors.ChildCount-1 do pnlCustomColors.Children[i].Color:= ACustomColors[pnlCustomColors.Children[i].Tag];
end;

procedure TMainForm.tbScroll(Sender: PControl; Bar: TScrollerBar;
  ScrollCmd, ThumbPos: Cardinal);
var R, G, B : byte;
begin
    if Chng then Exit;
    Chng:= True;
    CMYKTORGB(tbCyan.Position, tbMagenta.Position, tbYellow.Position, tbBlack.Position, R, G, B);
    DialogEx.SetColor(RGB(R, G, B));
    Chng:= False;
    SetFocus(0);
end;

procedure TMainForm.btnSimpleColorDialogClick(Sender: PObj);
begin
    cdClick(nil);
    DialogEx.cdColor:= ColorPanel.Color;
    DialogEx.ExecuteColorDialog;
    ColorPanel.Color:= DialogEx.cdColor;
end;

procedure TMainForm.btnCMYKColorDialogClick(Sender: PObj);
begin
    cdClick(nil);
    DialogEx.cdColor:= ColorPanel.Color;
    DialogEx.ExecuteColorDialog(pnlCMYK, edColorTitle.Text);
    ColorPanel.Color:= DialogEx.cdColor;
end;

procedure TMainForm.cdClick(Sender: PObj);
begin
    DialogEx.cdOptions:= [];
    if cdFullOpen.Checked then DialogEx.cdOptions:= DialogEx.cdOptions + [KOLmdvDialogEx.cdFullOpen];
    if cdPreventFullOpen.Checked then DialogEx.cdOptions:= DialogEx.cdOptions + [KOLmdvDialogEx.cdPreventFullOpen];
    if cdShowHelp.Checked then DialogEx.cdOptions:= DialogEx.cdOptions + [KOLmdvDialogEx.cdShowHelp];
    if cdSolidColor.Checked then DialogEx.cdOptions:= DialogEx.cdOptions + [KOLmdvDialogEx.cdSolidColor];
    if cdAnyColor.Checked then DialogEx.cdOptions:= DialogEx.cdOptions + [KOLmdvDialogEx.cdAnyColor];
end;

end.













