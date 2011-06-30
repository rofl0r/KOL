{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLRAS, FormSave, KOLMHXP {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckRAS,  mckObjs,  mckwidget, mckFormSave,  MCKMHXP {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
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
    KP: TKOLProject;
    KF: TKOLForm;
    Tool: TKOLToolbar;
    RAS: TKOLRAS;
    TI: TKOLTrayIcon;
    PM: TKOLPopupMenu;
    LB: TKOLLabel;
    PP: TKOLPopupMenu;
    List: TKOLListView;
    TM: TKOLTimer;
    FS: TKOLFormSave;
    XP: TKOLMHXP;
    procedure Dial;
    procedure HangUp;
    procedure ToolClick(Sender: PObj);
    procedure KFFormCreate(Sender: PObj);
    procedure ConnectingEvent(Sender: PRasObj; Msg, State: Integer; Error: Longint);
    procedure ListMouseDblClk(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure RASError(Sender: PRASObj; Error: Integer);
    procedure L1Destroy(Sender: PObj);
    procedure KFClose(Sender: PObj; var Accept: Boolean);
    procedure L1MouseDown(Sender: PControl; var Mouse: TMouseEventData);
    function KFMessage(var Msg: tagMSG; var Rslt: Integer): Boolean;
    procedure TIMouse(Sender: TObject; Message: Word);
    procedure PMMenuItem(Sender: PMenu; Item: Integer);
    procedure PPN7Menu(Sender: PMenu; Item: Integer);
    procedure ListLVStateChange(Sender: PControl; IdxFrom, IdxTo: Integer;
      OldState, NewState: Cardinal);
    procedure TMTimer(Sender: PObj);
    procedure PPPopup(Sender: PObj);
    procedure PPN8Menu(Sender: PMenu; Item: Integer);
    function _Redial(n: string): boolean;
  private
    { Private declarations }
    redial : boolean;
    hanging: boolean;
    running: boolean;
    reading: boolean;
  public
    { Public declarations }
  end;
var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses Ras, UStr, KOLRoundWindow;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}

procedure TForm1.Dial;
begin
   RAS.RASName := List.LVItems[List.LVCurItem, 0];
   RAS.Connect;
   redial := true;
end;

function  TForm1._Redial;
var i: integer;
begin
   result := false;
   i := List.LVIndexOf(n);
   if i > -1 then begin
      result := List.LVItemStateImgIdx[i] = 2;
   end;
end;

procedure TForm1.HangUp;
var swap: boolean;
begin
   swap := false;
   hanging := True;
   if RAS.Connected then begin
      swap := true;
   end;
   RAS.DisConnect(true);
   redial := false;
   if swap then begin
      Tool.TBButtonEnabled[100] := True;
      Tool.TBButtonEnabled[101] := False;
   end;
end;

procedure TForm1.ToolClick(Sender: PObj);
begin
   If PControl(Sender).CurItem = 100 then begin
      Dial;
   end else
   if PControl(Sender).CurItem = 101 then begin
      HangUp;
   end else
   If PControl(Sender).CurItem = 102 then begin
      PostMessage(Form.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
   end else
   if PControl(Sender).CurItem = 103 then begin
      Form.Close;
   end;
end;

procedure TForm1.KFFormCreate(Sender: PObj);
var p: PStrList;
    i: integer;
    n: integer;
begin
   NewRoundForm(Form);
   if Form.Visible then TI.Active := False;
   p := GetRASNames;
   List.LVColAdd('redial/RAS entry', taLeft,  (Form.ClientWidth - GetSystemMetrics(SM_CXVSCROLL)) div 2 - 4);
   List.LVColAdd('Status',    taRight, (Form.ClientWidth - GetSystemMetrics(SM_CXVSCROLL)) div 2 - 4);
   reading := True;
   for i := 0 to p.Count - 1 do begin
      List.LVAdd(p.Items[i], 0, [], 0, 0, 0);
   end;
   for i := 0 to List.LVCount - 1 do begin
      n := str2int(FS.ReadString(List.LVItems[i, 0]));
      List.LVItemStateImgIdx[i] := n;
   end;
   reading := False;
   p.Free;
   Tool.TBButtonEnabled[100] := False;
   Tool.TBButtonEnabled[101] := False;
   running := true;
   for I := 0 to Tool.Count-1 do
      Tool.TBButtonWidth[i] := (Form.ClientWidth - 7) div Tool.Count;
{   Applet.Caption := 'Simple dialer';}
end;

procedure TForm1.ConnectingEvent;
var s: string;
    e: string;
begin
   if running then begin
      s := Ras.StatusString;
      e := Ras.ErrorString;
      if e <> '' then begin
         LB.Color := clSilver;
         LB.Font.Color := clRed;
         LB.Text := e;
      end else begin
         LB.Color := clGray;
         LB.Font.Color := clWhite;
         LB.Text := s;
      end;
      Applet.Caption := '  ' + LB.Text;
      Tool.TBButtonEnabled[100] := State = 0;
      if Error <> 0 then begin
         Tool.TBButtonEnabled[100] := True;
         if Error = 608 then Redial := False;
         if Error = 615 then Redial := False;
         if Error = 633 then Redial := False;
         if Error = 797 then Redial := False;
      end;
      Tool.TBButtonEnabled[101] := not Tool.TBButtonEnabled[100];
      PM.ItemEnabled[0] := Tool.TBButtonEnabled[100];
      PM.ItemEnabled[1] := Tool.TBButtonEnabled[101];
   end;
   Sleep(600);
   if state = $2000 then begin
      PostMessage(Form.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
      Tool.TBButtonText[101] := 'Hangup';
      PM.ItemText[1] := 'Hangup';
   end;
   if state = $2001 then begin
      PostMessage(Form.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
      Tool.TBButtonText[101] := 'Cancel';
      PM.ItemText[1] := 'Cancel';
      if not hanging then begin
         Redial := _Redial(RAS.RASName);
         if redial then RAS.Connect;
      end;
   end;
   hanging := False;
end;

procedure TForm1.ListMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
begin
   if redial = False then Dial;
end;

procedure TForm1.RASError(Sender: PRASObj; Error: Integer);
begin
   RAS.DisConnect(true);
   if error > 0 then beep(300, 200);
   if redial then begin
      RAS.RASName := List.LVItems[List.LVCurItem, 0];
      RAS.Connect;
   end;
end;

procedure TForm1.L1Destroy(Sender: PObj);
begin
   running := False;
end;

procedure TForm1.KFClose(Sender: PObj; var Accept: Boolean);
begin
   TM.Enabled := False;
   redial := false;
   running := false;
   RAS.DisConnect(True);
end;

procedure TForm1.L1MouseDown(Sender: PControl; var Mouse: TMouseEventData);
begin
  releasecapture;
  SendMessage(Form.Handle,wm_syscommand,$F012,0);
end;

function TForm1.KFMessage(var Msg: tagMSG; var Rslt: Integer): Boolean;
begin
   Result := False;
   if (Msg.message = WM_SYSCOMMAND) and
      (Msg.wParam = SC_MINIMIZE) then begin
      TI.Active := True;
      Applet.Visible := False;
      Form.Visible := False;
      Result := True;
      PM.ItemText[0] := 'Dial to ' + List.LVItems[List.LVCurItem, 0];
      PM.ItemEnabled[0] := Tool.TBButtonEnabled[100];
      if PM.ItemText[0] = 'Dial to ' then begin
         PM.ItemText[0] := 'Dial';
         PM.ItemEnabled[0] := False;
      end;
   end else
   if (Msg.message = WM_SYSCOMMAND) and
      (Msg.wParam = SC_RESTORE) then begin
      TI.Active := False;
      Applet.Visible := True;
      Form.Visible := True;
   end;
end;

procedure TForm1.TIMouse(Sender: TObject; Message: Word);
var P: TPoint;
begin
   if message = 512 then exit;
   if message = 513 then begin
      PostMessage(Form.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
   end;
   if message = 516 then begin
      GetCursorPos(P);
      PM.PopupEx(P.X,P.Y);
   end;
end;

procedure TForm1.PMMenuItem(Sender: PMenu; Item: Integer);
begin
   case Item of
  0:Dial;
  1:HangUp;
  3:PostMessage(Form.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
  5:Form.Close;
   end;
end;

procedure TForm1.PPN7Menu(Sender: PMenu; Item: Integer);
var h: integer;
begin
   if List.LVCount = 0 then exit;
   h := 0;
   if RasEditPhonebookEntry(h, nil,
      PChar(List.LVItems[List.LVCurItem, 0])) <> 0 then
      ShowMessage('RasEditPhonebookEntry failed.');
end;

procedure TForm1.ListLVStateChange(Sender: PControl; IdxFrom,
  IdxTo: Integer; OldState, NewState: Cardinal);
  var i: integer;
begin
   If List.CurIndex > -1 then begin
      if redial = False then Tool.TBButtonEnabled[100] := List.LVItems[List.LVCurItem, 1] <> 'connected';
   end;
   if not reading then begin
      for i := 0 to List.Count - 1 do begin
         FS.SaveString(List.LVItems[i, 0], int2str(List.LVItemStateImgIdx[i]));
      end;
   end;   
end;

procedure TForm1.TMTimer(Sender: PObj);
var i: integer;
    n: integer;
    h: PList;
    e: PStrList;
    r: TRASConnStatus;
    s: string;
begin
   h := NewList;
   e := GetRasConnected(h);
   for i := 0 to List.LVCount - 1 do begin
      n := e.IndexOf(List.LVItems[i, 0]);
      if n > -1 then begin
         r.dwSize := SizeOf(r);
         RASGetConnectStatus(integer(h.Items[n]), r);
         case r.RASConnState of
0:
         List.LVItems[i, 1] := 'connecting';
RASCS_Connected:
         List.LVItems[i, 1] := 'connected';
RASCS_Disconnected:
         List.LVItems[i, 1] := 'failed(' + int2str(r.dwError) + ')';
         else
            s := r.szDeviceName;
            if length(s) > 3 then begin
               s := JustFileName(s);
               if List.LVItems[i, 1] <> s then begin
                  List.LVItems[i, 1] := s;
               end;   
               if FileExists(s) then begin
                  LB.Text := 'using ' + s;
               end;
            end else begin
               List.LVItems[i, 1] := 'connecting';
            end;
         end;
      end else
         List.LVItems[i, 1] := '';
   end;
   h.Free;
   e.Free;
end;

procedure TForm1.PPPopup(Sender: PObj);
begin
   PP.ItemVisible[1] := (List.LVItems[List.LVCurItem, 1] <> '') or
                        (List.LVItems[List.LVCurItem, 0]  = RAS.RASName);
end;

procedure TForm1.PPN8Menu(Sender: PMenu; Item: Integer);
begin
   if List.LVItems[List.LVCurItem, 0] = RAS.RASName then begin
      HangUp;
   end else begin
      KOLRas.Hangup(List.LVItems[List.LVCurItem, 0]);
   end;
end;

end.




















