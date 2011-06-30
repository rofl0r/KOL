{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLmdvXLGrid, KOLMHUpDown, KOLMHFontDialog {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,  mckUpDown, mckObjs,  MCKMHFontDialog,  MCKMHUpDown, MCKmdvXLGrid,  Graphics {$ENDIF};
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
    KOLProject: TKOLProject;
    Panel1: TKOLPanel;
    gbStyle: TKOLGroupBox;
    rbXL: TKOLRadioBox;
    rbStandard: TKOLRadioBox;
    gbOptions: TKOLGroupBox;
    cbxlgRangeSelect: TKOLCheckBox;
    cbxlgColsSelect: TKOLCheckBox;
    cbxlgRowsSelect: TKOLCheckBox;
    cbxlgColSizing: TKOLCheckBox;
    cbxlgRowSizing: TKOLCheckBox;
    cbxlgColMoving: TKOLCheckBox;
    cbxlgRowMoving: TKOLCheckBox;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    Editor_2: TKOLPanel;
    Button1: TKOLButton;
    Editor_1: TKOLEditBox;
    CheckBox1: TKOLCheckBox;
    ComboBox1: TKOLComboBox;
    btnMerge: TKOLButton;
    btnSplit: TKOLButton;
    gbLines: TKOLGroupBox;
    Label3: TKOLLabel;
    Label4: TKOLLabel;
    Label5: TKOLLabel;
    Label6: TKOLLabel;
    Button2: TKOLButton;
    ColorDialog: TKOLColorDialog;
    gbTitle: TKOLGroupBox;
    btnColor: TKOLButton;
    btnFont: TKOLButton;
    MHFontDialog: TKOLMHFontDialog;
    btnSelectColor: TKOLButton;
    btnSelectFont: TKOLButton;
    cbTitleColButton: TKOLCheckBox;
    cbTitleRowButton: TKOLCheckBox;
    KOLForm: TKOLForm;
    UpDownLeft: TKOLMHUpDown;
    EditBox1: TKOLEditBox;
    UpDownRight: TKOLMHUpDown;
    EditBox2: TKOLEditBox;
    UpDownTop: TKOLMHUpDown;
    EditBox3: TKOLEditBox;
    UpDownBottom: TKOLMHUpDown;
    EditBox4: TKOLEditBox;
    XLGrid: TKOLmdvXLGrid;
    Button3: TKOLButton;
    procedure KOLFormFormCreate(Sender: PObj);
    procedure rbStyleClick(Sender: PObj);
    procedure cbxlgOptionsClick(Sender: PObj);
    procedure XLGridFocusChange(Sender: PControl; ACol, ARow: Integer);
    procedure btnMergeClick(Sender: PObj);
    procedure btnSplitClick(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure btnColorClick(Sender: PObj);
    procedure btnFontClick(Sender: PObj);
    procedure btnSelectColorClick(Sender: PObj);
    procedure btnSelectFontClick(Sender: PObj);
    procedure cbTitleRowButtonClick(Sender: PObj);
    procedure cbTitleColButtonClick(Sender: PObj);
    procedure UpDownLeftChangingEx(Sender: PObj; var Allow: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDownRightChangingEx(Sender: PObj; var Allow: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDownTopChangingEx(Sender: PObj; var Allow: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDownBottomChangingEx(Sender: PObj; var Allow: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure XLGridSelectedChange(Sender: PControl; ARect: TRect);
    procedure XLGridBeginEdit(Sender: PControl; ACol, ARow: Integer;
      var AShowControl, ATextControl: PControl; var AIndents: TRect);
    procedure XLGridDrawCell(Sender: PControl; ACol, ARow: Integer;
      ACell: PmdvXLCell; ACanvas: PCanvas; ARect: TRect; ASelected,
      AFocused: Boolean; var Access: Boolean);
    procedure XLGridEndEdit(Sender: PControl; ACol, ARow: Integer;
      AShowControl, ATextControl: PControl; var AText: String;
      var Access: Boolean);
    procedure XLGridDrawTitle(Sender: PControl; ACol, ARow: Integer;
      ACell: PmdvXLCell; ACanvas: PCanvas; ARect: TRect; ASelected,
      AFocused: Boolean; var Access: Boolean);
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

uses Types;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Main_1.inc}
{$ENDIF}

procedure TMainForm.KOLFormFormCreate(Sender: PObj);
var i, j: Integer;
begin
    for i:= 0 to XLGrid.ColCount-1 do
      for j:= 0 to XLGrid.RowCount-1 do XLGrid.Cells[i, j].Text:= Int2Str(i) + 'X' + Int2Str(j);
    XLGrid.ColWidths[4]:= XLGrid.ColWidths[4] div 2;
    XLGrid.RowHeights[3]:= XLGrid.RowHeights[3] * 2;
end;

procedure TMainForm.rbStyleClick(Sender: PObj);
begin
    if rbXL.Checked then XLGrid.GridStyle:= gsXL else XLGrid.GridStyle:= gsStandard;
end;

procedure TMainForm.cbxlgOptionsClick(Sender: PObj);
begin
    if cbxlgRangeSelect.Checked then XLGrid.Options:= XLGrid.Options + [xlgRangeSelect] else XLGrid.Options:= XLGrid.Options - [xlgRangeSelect];
    if cbxlgColsSelect.Checked  then XLGrid.Options:= XLGrid.Options + [xlgColsSelect]  else XLGrid.Options:= XLGrid.Options - [xlgColsSelect];
    if cbxlgRowsSelect.Checked  then XLGrid.Options:= XLGrid.Options + [xlgRowsSelect]  else XLGrid.Options:= XLGrid.Options - [xlgRowsSelect];
    if cbxlgColSizing.Checked   then XLGrid.Options:= XLGrid.Options + [xlgColSizing]   else XLGrid.Options:= XLGrid.Options - [xlgColSizing];
    if cbxlgRowSizing.Checked   then XLGrid.Options:= XLGrid.Options + [xlgRowSizing]   else XLGrid.Options:= XLGrid.Options - [xlgRowSizing];
    if cbxlgColMoving.Checked   then XLGrid.Options:= XLGrid.Options + [xlgColMoving]   else XLGrid.Options:= XLGrid.Options - [xlgColMoving];
    if cbxlgRowMoving.Checked   then XLGrid.Options:= XLGrid.Options + [xlgRowMoving]   else XLGrid.Options:= XLGrid.Options - [xlgRowMoving];
end;

procedure TMainForm.XLGridFocusChange(Sender: PControl; ACol,
  ARow: Integer);
begin
    btnMerge.Enabled:= not XLGrid.HasMerge(XLGrid.Selected);
    btnSplit.Enabled:= XLGrid.IsMerge(XLGrid.Position);
end;

procedure TMainForm.btnMergeClick(Sender: PObj);
begin
    XLGrid.Merge(XLGrid.Selected);
    XLGridFocusChange(XLGrid, XLGrid.Position.X, XLGrid.Position.Y);
end;

procedure TMainForm.btnSplitClick(Sender: PObj);
begin
    XLGrid.Split(XLGrid.Position);
    XLGridFocusChange(XLGrid, XLGrid.Position.X, XLGrid.Position.Y);
end;

procedure TMainForm.Button2Click(Sender: PObj);
begin
    ColorDialog.Color:= XLGrid.LineColor;
    if ColorDialog.Execute then XLGrid.LineColor:= ColorDialog.Color;
end;

procedure TMainForm.btnColorClick(Sender: PObj);
begin
    ColorDialog.Color:= XLGrid.TitleColor;
    if ColorDialog.Execute then XLGrid.TitleColor:= ColorDialog.Color;
end;

procedure TMainForm.btnFontClick(Sender: PObj);
begin
    MHFontDialog.InitFont.Assign(XLGrid.TitleFont);
    if MHFontDialog.Execute then XLGrid.TitleFont.Assign(MHFontDialog.Font);
end;

procedure TMainForm.btnSelectColorClick(Sender: PObj);
begin
    ColorDialog.Color:= XLGrid.TitleSelectedColor;
    if ColorDialog.Execute then XLGrid.TitleSelectedColor:= ColorDialog.Color;
end;

procedure TMainForm.btnSelectFontClick(Sender: PObj);
begin
    ColorDialog.Color:= XLGrid.TitleSelectedFontColor;
    if ColorDialog.Execute then XLGrid.TitleSelectedFontColor:= ColorDialog.Color;
end;

procedure TMainForm.cbTitleRowButtonClick(Sender: PObj);
begin
    XLGrid.TitleRowButton:= cbTitleRowButton.Checked;
end;

procedure TMainForm.cbTitleColButtonClick(Sender: PObj);
begin
    XLGrid.TitleColButton:= cbTitleColButton.Checked;
end;

procedure TMainForm.UpDownLeftChangingEx(Sender: PObj; var Allow: Boolean;
  NewValue: Smallint; Direction: TUpDownDirection);
begin
    XLGrid.LineWidthLeft:= NewValue;
end;

procedure TMainForm.UpDownRightChangingEx(Sender: PObj; var Allow: Boolean;
  NewValue: Smallint; Direction: TUpDownDirection);
begin
    XLGrid.LineWidthRight:= NewValue;
end;

procedure TMainForm.UpDownTopChangingEx(Sender: PObj; var Allow: Boolean;
  NewValue: Smallint; Direction: TUpDownDirection);
begin
    XLGrid.LineWidthTop:= NewValue;
end;

procedure TMainForm.UpDownBottomChangingEx(Sender: PObj;
  var Allow: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
    XLGrid.LineWidthBottom:= NewValue;
end;

procedure TMainForm.XLGridSelectedChange(Sender: PControl; ARect: TRect);
begin
    btnMerge.Enabled:= not XLGrid.HasMerge(XLGrid.Selected) and((XLGrid.Selected.Left<>XLGrid.Selected.Right) or (XLGrid.Selected.Top<>XLGrid.Selected.Bottom));
    btnSplit.Enabled:= XLGrid.IsMerge(XLGrid.Position);
end;

procedure TMainForm.XLGridBeginEdit(Sender: PControl; ACol, ARow: Integer;
  var AShowControl, ATextControl: PControl; var AIndents: TRect);
begin
    case ACol of
      0: begin AShowControl:= Editor_1; AIndents:= MakeRect(1, 1, 0, 0); end;
      1: begin AShowControl:= Editor_2; AIndents:= MakeRect(1, 1, 0, 0); end;
      2: begin AShowControl:= CheckBox1; AIndents:= MakeRect(1, 1, 0, 0); end;
      3: begin AShowControl:= ComboBox1; AIndents:= MakeRect(1, 1, 0, 0); end;
    end;
end;

procedure TMainForm.XLGridDrawCell(Sender: PControl; ACol, ARow: Integer;
  ACell: PmdvXLCell; ACanvas: PCanvas; ARect: TRect; ASelected,
  AFocused: Boolean; var Access: Boolean);
begin
    Access:= (ACol = 4);
    if Access then begin
      if not AFocused then begin
        ACanvas.Brush.Color:= clYellow;
        ACanvas.Brush.BrushStyle:= bsSolid;
        ACanvas.FillRect(ARect);
        ACanvas.Pen.Color:= clRed;
        ACanvas.Pen.PenWidth:= 1;
        ACanvas.Pen.PenMode:= pmCopy;
        ACanvas.Brush.BrushStyle:= bsClear;
        ACanvas.Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
        ACanvas.Font.Color:= clNavy;
      end;
      ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
      DrawText(ACanvas.Handle, PChar('C='+Int2Str(ACol)+'  R='+Int2Str(ARow)), -1, ARect, DT_WORDBREAK or DT_CENTER);
    end;
end;

procedure TMainForm.XLGridEndEdit(Sender: PControl; ACol, ARow: Integer;
  AShowControl, ATextControl: PControl; var AText: String;
  var Access: Boolean);
begin
    Access:= True;
end;

procedure TMainForm.XLGridDrawTitle(Sender: PControl; ACol, ARow: Integer;
  ACell: PmdvXLCell; ACanvas: PCanvas; ARect: TRect; ASelected,
  AFocused: Boolean; var Access: Boolean);
begin
    if (ACol = -1) and (ARow = -1) then begin
      ACanvas.RequiredState( HandleValid or FontValid or BrushValid or ChangingCanvas );
      ACanvas.Font.Assign(XLGrid.TitleFont);
      DrawText(ACanvas.Handle, '@', -1, ARect, DT_SINGLELINE or DT_VCENTER or DT_CENTER);
    end;
end;

end.































