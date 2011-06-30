{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface
{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLLed, KOLCom {$IFNDEF KOL_MCK},     mirror, Classes,  Controls, mckCtrls, MCKCom, MCKLed {$ENDIF};
{$ELSE} {$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    btStart: TKOLButton;
    btStop: TKOLButton;
    cbCom1: TKOLComboBox;
    cbCom2: TKOLComboBox;
    cbDTR1: TKOLCheckBox;
    cbRTS1: TKOLCheckBox;
    cbDTR2: TKOLCheckBox;
    cbRTS2: TKOLCheckBox;
    cbDSR1: TKOLCheckBox;
    cbCTS1: TKOLCheckBox;
    cbDSR2: TKOLCheckBox;
    cbCTS2: TKOLCheckBox;
    RadioBox1: TKOLRadioBox;
    RadioBox2: TKOLRadioBox;
    RadioBox3: TKOLRadioBox;
    RadioBox4: TKOLRadioBox;
    RadioBox5: TKOLRadioBox;
    RadioBox6: TKOLRadioBox;
    Led1: TKOLLed;
    Led2: TKOLLed;
    Com1: TKOLCom;
    Com2: TKOLCom;
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    procedure btStartClick(Sender: PObj);
    procedure btStopClick(Sender: PObj);
    procedure Com1RxByte(Buff: array of Byte; Count: Cardinal);
    procedure Com2RxByte(Buff: array of Byte; Count: Cardinal);
    procedure Com1Modem(bDSR, bCTS, bRING, bRLSD: Boolean);
    procedure Com2Modem(bDSR, bCTS, bRING, bRLSD: Boolean);
    function KOLForm1Message(var Msg: tagMSG; var Rslt: Integer): Boolean;
    procedure cbCom1Change(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure cbDTR1Click(Sender: PObj);
    procedure cbRTS1Click(Sender: PObj);
    procedure cbRTS2Click(Sender: PObj);
    procedure cbDTR2Click(Sender: PObj);
    procedure RadioBox1Click(Sender: PObj);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  ArSend : array[0..127] of byte =
    ($55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66,
     $55,$AA,$33,$CC,$11,$EE,$99,$66,$55,$AA,$33,$CC,$11,$EE,$99,$66);
  Lens : integer = 128;
  MsgRec = WM_User + $55;
  MsgErr = WM_User + $56;

type
  Reciv = record
            ArReciv : array[0..255] of byte;
            KolByte : integer;
          end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  Rec1, Rec2 : Reciv;
  SendS : string;
  Loop1 : integer;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.btStartClick(Sender: PObj);
var
  i : integer;
begin
  if (Com1.Open(True) = 0) and (Com2.Open(True) = 0)
   then begin
     btStart.Enabled := False;
     btStop.Enabled := True;
     cbDTR1.Checked := Com1.DTR; cbRTS1.Checked := Com1.RTS;
     cbCTS1.Checked := Com1.CTS; cbDSR1.Checked := Com1.DSR;
     cbDTR2.Checked := Com2.DTR; cbRTS2.Checked := Com2.RTS;
     cbCTS2.Checked := Com2.CTS; cbDSR2.Checked := Com2.DSR;
     SetLength(SendS,Lens);
     for i := 1 to Lens do
      SendS[i] := Chr(ArSend[i-1]);
     Rec1.KolByte := 0;
     Rec2.KolByte := 0;
     PostMessage(Form.Handle,wm_User+$55,1,0);
   end
   else ShowMsg('Ошибка СОМ-порта',mb_Ok);
end;

procedure TForm1.btStopClick(Sender: PObj);
begin
  btStart.Enabled := True;
  btStop.Enabled := False;
  Com1.Close;
  Com2.Close;
end;

procedure TForm1.Com1RxByte(Buff: array of Byte; Count: Cardinal);
var
  i,j : integer;
  pr : boolean;
begin
  for i := 0 to Count-1 do begin
    Rec1.ArReciv[Rec1.KolByte] := Buff[i];
    inc(Rec1.KolByte);
    if Rec1.KolByte >= Lens then begin
      Rec1.KolByte := 0;
      pr := True;
      for j := 0 to Lens-1 do
       if Rec1.ArReciv[j] <> ArSend[j] then begin
         pr := False; break;
       end;
      if pr
       then PostMessage(Form.Handle,wm_User+$55,1,0)
       else PostMessage(Form.Handle,wm_User+$56,1,0);
    end;
  end;
end;

procedure TForm1.Com2RxByte(Buff: array of Byte; Count: Cardinal);
var
  i,j : integer;
  pr : boolean;
begin
  for i := 0 to Count-1 do begin
    Rec2.ArReciv[Rec2.KolByte] := Buff[i];
    inc(Rec2.KolByte);
    if Rec2.KolByte >= Lens then begin
      Rec2.KolByte := 0;
      pr := True;
      for j := 0 to Lens-1 do
       if Rec2.ArReciv[j] <> ArSend[j] then begin
         pr := False; break;
       end;
      if pr
       then PostMessage(Form.Handle,wm_User+$55,2,0)
       else PostMessage(Form.Handle,wm_User+$56,2,0);
    end;
  end;
end;

procedure TForm1.Com1Modem(bDSR, bCTS, bRING, bRLSD: Boolean);
begin
  cbDSR1.Checked := bDSR;
  cbCTS1.Checked := bCTS;
end;

procedure TForm1.Com2Modem(bDSR, bCTS, bRING, bRLSD: Boolean);
begin
  cbDSR2.Checked := bDSR;
  cbCTS2.Checked := bCTS;
end;

function TForm1.KOLForm1Message(var Msg: tagMSG;
  var Rslt: Integer): Boolean;
var
  S : string;
begin
  Result := False;
  case Msg.message of
    MsgRec,MsgErr :
      begin
        if btStart.Enabled then Exit;
        case Msg.message of
          MsgRec :
            if btStop.Enabled then begin
              if Msg.wParam = 1
               then begin
                 Com1.WriteStr(SendS,True);
                 Led1.Value := True;
               end
               else begin
                 Com2.WriteStr(SendS,True);
                 Led1.Value := False;
               end;
              Led2.Value := not Led1.Value;
            end;
          MsgErr :
            begin
              if Msg.wParam = 1
               then S := 'Ошибка приема-передачи 2-1.'
               else S := 'Ошибка приема-передачи 1-2.';
              ShowMsg(S,mb_Ok);;
            end;
        end;
        Result := True;
      end;
  end;
end;

procedure TForm1.cbCom1Change(Sender: PObj);
var
  S : string;
begin
  if Sender = cbCom1
   then cbCom2.CurIndex := (cbCom1.CurIndex + 1) mod cbCom1.Count
   else cbCom1.CurIndex := (cbCom2.CurIndex + 1) mod cbCom1.Count;
  S := cbCom1.Text;
  Com1.NumPort := Str2Int(S[4]);
  S := cbCom2.Text;
  Com2.NumPort := Str2Int(S[4]);
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var
  i : integer;
begin
  cbCom1.Clear;
  cbCom2.Clear;
  for i := 1 to 8 do begin
    Com1.NumPort := i;
    if Com1.Open(False) = 0 then begin
      cbCom1.Add('COM' + Int2Str(i));
      cbCom2.Add('COM' + Int2Str(i));
      Com1.Close;
    end;
  end;
  if cbCom1.Count < 2 then begin
    ShowMsg('Недостаточно доступных портов.',mb_Ok);
    btStart.Enabled := False;
  end;
  cbCom1.CurIndex := 0;
  cbCom2.CurIndex := 1;
  cbCom1Change(cbCom1);
end;

procedure TForm1.cbDTR1Click(Sender: PObj);
begin
  Com1.DTR := cbDTR1.Checked;
end;

procedure TForm1.cbRTS1Click(Sender: PObj);
begin
  Com1.RTS := cbRTS1.Checked;
end;

procedure TForm1.cbRTS2Click(Sender: PObj);
begin
  Com2.RTS := cbRTS2.Checked;
end;

procedure TForm1.cbDTR2Click(Sender: PObj);
begin
  Com2.DTR := cbDTR2.Checked;
end;

procedure TForm1.RadioBox1Click(Sender: PObj);
begin
  Com1.BaudRate := Str2Int(TKOLRadioBox(Sender).Caption);
  Com2.BaudRate := Str2Int(TKOLRadioBox(Sender).Caption);
end;

procedure TForm1.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  if btStop.Enabled then Accept := False;
end;

end.




















