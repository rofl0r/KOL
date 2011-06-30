{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit TaskEd;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls, mckObjs,  mckFormSave,
  Graphics {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm7 = class; PForm7 = TForm7; {$ELSE OBJECTS} PForm7 = ^TForm7; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm7.inc}{$ELSE} TForm7 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm7 = class(TForm)
  {$ENDIF KOL_MCK}
    KF: TKOLForm;
    CB: TKOLComboBox;
    BN: TKOLButton;
    BE: TKOLButton;
    BD: TKOLButton;
    BC: TKOLButton;
    P1: TKOLPanel;
    LP: TKOLLabelEffect;
    EP: TKOLEditBox;
    LS: TKOLLabelEffect;
    ES: TKOLComboBox;
    LU: TKOLLabelEffect;
    EU: TKOLEditBox;
    LM: TKOLLabelEffect;
    EM: TKOLEditBox;
    EE: TKOLEditBox;
    OD: TKOLOpenDirDialog;
    JU: TKOLCheckBox;
    UL: TKOLLabelEffect;
    DL: TKOLLabelEffect;
    JD: TKOLCheckBox;
    AL: TKOLLabelEffect;
    AB: TKOLCheckBox;
    EX: TKOLLabelEffect;
    EB: TKOLEditBox;
    WL: TKOLLabelEffect;
    WC: TKOLCheckBox;
    FS: TKOLFormSave;
    procedure FillCB  (CO: PControl; c: string);
    procedure WriteIni(w: boolean);
    procedure WriteTsk(w: boolean);
    procedure KFClose(Sender: PObj; var Accept: Boolean);
    procedure BCClick(Sender: PObj);
    procedure KFFormCreate(Sender: PObj);
    procedure KFHide(Sender: PObj);
    procedure CBChange(Sender: PObj);
    procedure BNClick(Sender: PObj);
    procedure BEClick(Sender: PObj);
    procedure EEChange(Sender: PObj);
    procedure BDClick(Sender: PObj);
    procedure KFShow(Sender: PObj);
    procedure LPMouseDblClk(Sender: PControl; var Mouse: TMouseEventData);
  private
    { Private declarations }
    FI: PIniFile;
    CL: PStrList;
  public
    { Public declarations }
    Busy: boolean;
  Change: boolean;  
  end;

var
  Form7 {$IFDEF KOL_MCK} : PForm7 {$ELSE} : TForm7 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm7( var Result: PForm7; AParent: PControl );
{$ENDIF}

implementation

uses KOLForm, UWrd, KOLRoundWindow;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I TaskEd_1.inc}
{$ENDIF}

procedure TForm7.FillCB;
var s,
    r: string;
    i: integer;
begin
   FI.Section := c;
   CL.Clear;
   FI.SectionData(CL);
   s := '';
   for i := 0 to CL.Count - 1 do begin
      r := wordn(CL.Items[i], '=', 1);
      if (pos(r, s) = 0) and (r <> '') then begin
         CO.Add(r);
      end;
      s := s + r;
   end;
end;

procedure TForm7.WriteIni;
var i: integer;
    n: integer;
begin
   FI := OpenIniFile(Form1.FN);
   if w then FI.Mode := ifmWrite;
   FI.Section := 'Form7';
   Form.Left  := FI.ValueInteger('Left', Form.Left);
   Form.Top   := FI.ValueInteger('Top',  Form.Top);
   EE.Text    := FI.ValueString ('Name', EE.Text);
   if not w then
      FillCB(ES, 'Names');
   FI.Section := 'Tasks';
   if not w then begin
      FillCB(CB, 'Tasks');
      n := 0;
      for i := 0 to CB.Count - 1 do
         if CB.Items[i] = EE.Text then n := i;
      CB.CurIndex := n;
   end else begin
      if not w or (w and (CL.Count > 0)) then
         FI.SectionData(CL);
   end;
   FI.Free;
end;

procedure TForm7.WriteTsk;
var en: string;
begin
   FI := OpenIniFile(Form1.FN);
   if w then FI.Mode := ifmWrite;
   if w then en := EE.Text else en := CB.Text;
   if en <> '' then begin
      FI.Section := en;
      if w then begin
         EE.Text    := FI.ValueString ('Name', EE.Text);
         ES.Text    := FI.ValueString ('Link', ES.Text);
         EU.Text    := FI.ValueString ('RemP', EU.Text);
         EP.Text    := FI.ValueString ('LocP', EP.Text);
         EM.Text    := FI.ValueString ('Mask', EM.Text);
         EB.Text    := Fi.ValueString ('Excl', EB.Text);
         JU.Checked := FI.ValueBoolean('Jupl', JU.Checked);
         JD.Checked := FI.ValueBoolean('Jdnl', JD.Checked);
         WC.Checked := FI.ValueBoolean('Wait', WC.Checked);
         AB.Checked := FI.ValueBoolean('Acti', AB.Checked);
      end else begin
         EE.Text    := FI.ValueString ('Name', '');
         ES.Text    := FI.ValueString ('Link', '');
         EU.Text    := FI.ValueString ('RemP', '');
         EP.Text    := FI.ValueString ('LocP', '');
         EM.Text    := FI.ValueString ('Mask', '');
         EB.Text    := FI.ValueString ('Excl', '');
         JU.Checked := FI.ValueBoolean('Jupl', True);
         JD.Checked := FI.ValueBoolean('Jdnl', True);
         WC.Checked := FI.ValueBoolean('Wait', True);
         AB.Checked := FI.ValueBoolean('Acti', True);
      end;
   end;
   FI.Free;
end;

procedure TForm7.KFClose(Sender: PObj; var Accept: Boolean);
begin
   Accept := False;
   Form.Hide;
end;

procedure TForm7.BCClick(Sender: PObj);
begin
   Form.Hide;
end;

procedure TForm7.KFFormCreate(Sender: PObj);
begin
   NewRoundForm(Form, 15);
   CL := NewStrList;
   WriteIni(False);
   WriteTsk(False);
   CB.CurIndex := 0;
end;

procedure TForm7.KFHide(Sender: PObj);
begin
   if EE.Text <> '' then begin
      if CL.IndexOf(EE.Text) = -1 then begin
         CL.Add(EE.Text);
         CB.Add(EE.Text);
      end;
   end;
   WriteIni(True);
   WriteTsk(True);
   Change := True;
   Busy   := False;
end;

procedure TForm7.CBChange(Sender: PObj);
begin
   WriteTsk(False);
end;

procedure TForm7.BNClick(Sender: PObj);
begin
   BEClick(@self);
   CB.Text    := '';
   CB.Caption := '';
   EE.Text    := '';
   ES.Text    := '';
   EU.Text    := '';
   EP.Text    := '';
   EM.Text    := '*.*';
   EB.Text    := '';
   EE.Focused := True;
end;

procedure TForm7.BEClick(Sender: PObj);
begin
   EE.Enabled := True;
   ES.Enabled := True;
   EU.Enabled := True;
   EP.Enabled := True;
   EM.Enabled := True;
   EB.Enabled := True;
   JU.Enabled := True;
   JD.Enabled := True;
   WC.Enabled := True;
   AB.Enabled := True;
end;

procedure TForm7.EEChange(Sender: PObj);
begin
   if EE.Enabled then CB.CurIndex := -1;
   CB.Text := EE.Text;
end;

procedure TForm7.BDClick(Sender: PObj);
var i: integer;
begin
   i := 0;
   while i < CB.Count do begin
      if CB.Items[i] = EE.Text then begin
         CB.Delete(i);
         dec(i);
      end;
      inc(i);
   end;
   i := CL.IndexOf(EE.Text);
   if i > -1 then CL.Delete(i);
   CB.CurIndex := 0;
   WriteTsk(False);
end;

procedure TForm7.KFShow(Sender: PObj);
var i: integer;
begin
   EE.Enabled := False;
   ES.Enabled := False;
   EU.Enabled := False;
   EP.Enabled := False;
   EM.Enabled := False;
   EB.Enabled := False;
   JU.Enabled := False;
   JD.Enabled := False;
   WC.Enabled := False;
   AB.Enabled := False;
         Busy := True;
       Change := True;
   if Form1.TC.CurIndex > 0 then begin
      for i := 0 to CB.Count - 1 do begin
         if Form1.TC.TC_Items[Form1.TC.CurIndex] = CB.Items[i] then begin
            EE.Text := CB.Items[i];
            CB.Text := CB.Items[i];
            CB.CurIndex := i;
            WriteTsk(False);
            break;
         end;
      end;
   end;
end;

procedure TForm7.LPMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
begin
   OD.InitialPath := EP.Text;
   if OD.Execute then begin
      EP.Text := OD.Path + '\';
   end;
end;

end.












