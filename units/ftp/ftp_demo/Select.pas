{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Select;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls,  mckFormSave,  Graphics {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm2 = class; PForm2 = TForm2; {$ELSE OBJECTS} PForm2 = ^TForm2; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm2.inc}{$ELSE} TForm2 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm2 = class(TForm)
  {$ENDIF KOL_MCK}
    KF: TKOLForm;
    P1: TKOLPanel;
    CB: TKOLComboBox;
    XB: TKOLButton;
    EB: TKOLButton;
    NB: TKOLButton;
    DB: TKOLButton;
    P2: TKOLPanel;
    EE: TKOLEditBox;
    SE: TKOLEditBox;
    UE: TKOLEditBox;
    PE: TKOLEditBox;
    SL: TKOLLabelEffect;
    UL: TKOLLabelEffect;
    PL: TKOLLabelEffect;
    NL: TKOLLabelEffect;
    NE: TKOLEditBox;
    CO: TKOLButton;
    ME: TKOLCheckBox;
    ML: TKOLLabelEffect;
    FS: TKOLFormSave;
    procedure XBClick(Sender: PObj);
    procedure KFFormCreate(Sender: PObj);
    procedure KFHide(Sender: PObj);
    procedure WriteIni(w: boolean);
    procedure WriteFTP(w: boolean);
    procedure CBChange(Sender: PObj);
    procedure COClick(Sender: PObj);
    procedure EBClick(Sender: PObj);
    procedure KFShow(Sender: PObj);
    procedure NBClick(Sender: PObj);
    procedure EEChange(Sender: PObj);
    procedure DBClick(Sender: PObj);
    procedure KFClose(Sender: PObj; var Accept: Boolean);
  private
    { Private declarations }
    FI: PIniFile;
    CL: PStrList;
  public
    { Public declarations }
    Busy: boolean;
  end;

var
  Form2 {$IFDEF KOL_MCK} : PForm2 {$ELSE} : TForm2 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm2( var Result: PForm2; AParent: PControl );
{$ENDIF}

implementation

uses KOLForm, UWrd, KOLRoundWindow;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Select_1.inc}
{$ENDIF}

procedure TForm2.XBClick(Sender: PObj);
begin
   Form.Hide;
   Busy := False;
end;

procedure TForm2.KFFormCreate(Sender: PObj);
begin
   NewRoundForm(Form, 15);
   CL := NewStrList;
   WriteIni(False);
   WriteFTP(False);
end;

procedure TForm2.KFClose(Sender: PObj; var Accept: Boolean);
begin
   Accept := False;
   Form.Hide;
end;

procedure TForm2.KFHide(Sender: PObj);
begin
   if EE.Text <> '' then begin
      if CL.IndexOf(EE.Text) = -1 then begin
         CL.Add(EE.Text);
         CB.Add(EE.Text);
      end;
   end;
   WriteIni(True);
   WriteFTP(True);
end;

procedure TForm2.WriteIni;
var i: integer;
    n: integer;
    s: string;
    r: string;
begin
   FI := OpenIniFile(Form1.FN);
   if w then FI.Mode := ifmWrite;
   FI.Section := 'Form2';
   Form.Left  := FI.ValueInteger('Left', Form.Left);
   Form.Top   := FI.ValueInteger('Top',  Form.Top);
   EE.Text    := FI.ValueString('Name', EE.Text);
   FI.Section := 'Names';
   if not w then begin
      FI.SectionData(CL);
      for i := CL.Count - 1 downto 0 do begin
         if CL.Items[i] = '' then begin
            CL.Delete(i);
         end;
      end;
      s := '';
      for i := 0 to  CL.Count - 1 do begin
         r := wordn(CL.Items[i], '=', 1);
         if (pos(r, s) = 0) and (r <> '') then begin
            CB.Add(r);
         end;
         s := s + r;
      end;
      n := 0;
      for i := 0 to CB.Count - 1 do
         if CB.Items[i] = EE.Text then n := i;
      CB.CurIndex := n;
   end else begin
      if CL.Count > 0 then begin
         FI.SectionData(CL);
      end;   
   end;
   FI.Free;
end;

procedure TForm2.WriteFTP;
var en: string;
begin
   FI := OpenIniFile(Form1.FN);
   if w then FI.Mode := ifmWrite;
   if w then en := EE.Text else en := CB.Text;
   if en <> '' then begin
      FI.Section := en;
      if w then begin
         EE.Text    := FI.ValueString ('Name', EE.Text);
         SE.Text    := FI.ValueString ('Site', SE.Text);
         UE.Text    := FI.ValueString ('User', UE.Text);
         PE.Text    := FI.ValueString ('Pass', PE.Text);
         NE.Text    := FI.ValueString ('Port', NE.Text);
         ME.Checked := FI.ValueBoolean('Pasv', ME.Checked);
      end else begin
         EE.Text    := FI.ValueString ('Name', '');
         SE.Text    := FI.ValueString ('Site', '');
         UE.Text    := FI.ValueString ('User', '');
         PE.Text    := FI.ValueString ('Pass', '');
         NE.Text    := FI.ValueString ('Port', '');
         ME.Checked := FI.ValueBoolean('Pasv', False);
      end;
   end;
   FI.Free;
end;

procedure TForm2.CBChange(Sender: PObj);
begin
   WriteFTP(False);
end;

procedure TForm2.COClick(Sender: PObj);
begin
   Form1.FC.HostAddr := SE.Text;
   Form1.FC.UserName := UE.Text;
   Form1.FC.UserPass := PE.Text;
   Form1.FC.HostPort := NE.Text;
   Form1.FC.Passive  := ME.Checked;
   Form1.Form.StatusText[0] := '  Connecting';
   Form1.Form.StatusText[3] := PChar('  ' + EE.Text);
   Form1.FC.Connect;
   Form.Hide;
end;

procedure TForm2.EBClick(Sender: PObj);
begin
   EE.Enabled := True;
   SE.Enabled := True;
   UE.Enabled := True;
   PE.Enabled := True;
   NE.Enabled := True;
   ME.Enabled := True;
end;

procedure TForm2.KFShow(Sender: PObj);
begin
         Busy := True;
   EE.Enabled := False;
   SE.Enabled := False;
   UE.Enabled := False;
   PE.Enabled := False;
   NE.Enabled := False;
   ME.Enabled := False;
end;

procedure TForm2.NBClick(Sender: PObj);
begin
   EBClick(@self);
   CB.Text    := '';
   CB.Caption := '';
   EE.Text    := '';
   SE.Text    := '';
   UE.Text    := '';
   PE.Text    := '';
   NE.Text    := '21';
   ME.Checked := False;
   EE.Focused := True;
end;

procedure TForm2.EEChange(Sender: PObj);
begin
   if EE.Enabled then CB.CurIndex := -1;
   CB.Text := EE.Text;
end;

procedure TForm2.DBClick(Sender: PObj);
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
   WriteFTP(False);
end;

end.













