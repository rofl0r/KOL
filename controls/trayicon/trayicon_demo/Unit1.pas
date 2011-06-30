{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLBAPTrayIcon {$IFNDEF KOL_MCK}, mirror, Classes,  mckBAPTrayIcon, mckObjs,  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    bShowIcon: TKOLButton;
    bDelIcon: TKOLButton;
    bToolTip: TKOLButton;
    ebHint: TKOLEditBox;
    bShowBalloon: TKOLButton;
    bHideBalloon: TKOLButton;
    ebBTitle: TKOLEditBox;
    GroupBox1: TKOLGroupBox;
    RadioBox1: TKOLRadioBox;
    RadioBox2: TKOLRadioBox;
    RadioBox3: TKOLRadioBox;
    RadioBox4: TKOLRadioBox;
    Label1: TKOLLabel;
    PopupMenu1: TKOLPopupMenu;
    CheckBox1: TKOLCheckBox;
    cbHideMin: TKOLCheckBox;
    BAPTrayIcon1: TKOLBAPTrayIcon;
    cbHideClose: TKOLCheckBox;
    bIcon1: TKOLButton;
    bIcon2: TKOLButton;
    bIcon4: TKOLButton;
    cbNoSound: TKOLCheckBox;
    mBText: TKOLMemo;
    Label2: TKOLLabel;
    ebTimeout: TKOLEditBox;
    cbHideBall: TKOLCheckBox;
    procedure bShowIconClick(Sender: PObj);
    procedure bDelIconClick(Sender: PObj);
    procedure bToolTipClick(Sender: PObj);
    procedure bShowBalloonClick(Sender: PObj);
    procedure bHideBalloonClick(Sender: PObj);
    procedure PopupMenu1mExitMenu(Sender: PMenu; Item: Integer);
    procedure PopupMenu1mShowMenu(Sender: PMenu; Item: Integer);
    procedure PopupMenu1mHideMenu(Sender: PMenu; Item: Integer);
    procedure KOLForm1Hide(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    function KOLForm1Message(var Msg: tagMSG; var Rslt: Integer): Boolean;
    procedure BAPTrayIcon1MouseDown(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure bIcon1Click(Sender: PObj);
    procedure bIcon2Click(Sender: PObj);
    procedure bIcon4Click(Sender: PObj);
    procedure cbHideBallClick(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.bShowIconClick(Sender: PObj);
begin
  BAPTrayIcon1.Active := True;
end;

procedure TForm1.bDelIconClick(Sender: PObj);
begin
  BAPTrayIcon1.Active := False;
end;

procedure TForm1.bToolTipClick(Sender: PObj);
begin
  BAPTrayIcon1.ToolTip := ebHint.Text;
end;

procedure TForm1.bIcon1Click(Sender: PObj);
begin
  BAPTrayIcon1.LoadTrayIcon('ic2');
end;

procedure TForm1.bIcon2Click(Sender: PObj);
begin
  BAPTrayIcon1.LoadTrayIcon('ic3');
end;

procedure TForm1.bIcon4Click(Sender: PObj);
begin
  BAPTrayIcon1.LoadTrayIcon('ic1');
end;

procedure TForm1.bShowBalloonClick(Sender: PObj);
var
  x: Integer;
begin
  BAPTrayIcon1.BalloonText := mBText.Text;
  BAPTrayIcon1.BalloonTitle := ebBTitle.Text;
  x := 0;
  if RadioBox1.Checked then
    x := NIIF_NONE;    // 0
  if RadioBox2.Checked then
    x := NIIF_INFO;    // 1
  if RadioBox3.Checked then
    x := NIIF_WARNING; // 2
  if RadioBox4.Checked then
    x := NIIF_ERROR;   // 3
  if cbNoSound.Checked then
    x := x or NIIF_NOSOUND;
  BAPTrayIcon1.ShowBalloon(x, Str2Int(ebTimeout.Text));
end;

procedure TForm1.cbHideBallClick(Sender: PObj);
begin
  if cbHideBall.Checked then
    BAPTrayIcon1.HideBallOnTimer := True
  else
    BAPTrayIcon1.HideBallOnTimer := False;
end;

procedure TForm1.bHideBalloonClick(Sender: PObj);
begin
  BAPTrayIcon1.HideBalloon;
end;

procedure TForm1.PopupMenu1mExitMenu(Sender: PMenu; Item: Integer);
begin
  Applet.Close;
end;

procedure TForm1.PopupMenu1mShowMenu(Sender: PMenu; Item: Integer);
begin
  Applet.Visible := True;
end;

procedure TForm1.PopupMenu1mHideMenu(Sender: PMenu; Item: Integer);
begin
  Applet.Visible := False;
end;

procedure TForm1.KOLForm1Hide(Sender: PObj);
begin
  if cbHideMin.Checked then
    BAPTrayIcon1.Active := True;
end;

procedure TForm1.KOLForm1Show(Sender: PObj);
begin
  if CheckBox1.Checked then
    BAPTrayIcon1.Active := False;
end;

procedure TForm1.BAPTrayIcon1MouseDown(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  if (Mouse.Button = mbLeft) then
    Sender.Show;
end;

function TForm1.KOLForm1Message(var Msg: tagMSG;  var Rslt: Integer): Boolean;
begin
  Result := False;

  if Msg.message = WM_SYSCOMMAND then
  begin
    case Msg.wParam of
      SC_MINIMIZE: // ¡ÀŒ »–Œ¬ ¿ Ã»Õ»Ã»«¿÷»» Œ Õ¿ 
        if cbHideMin.Checked then
        begin
          Form.Hide;
          Result := True;
        end;

      SC_CLOSE: // ¡ÀŒ »–Œ¬ ¿ «¿ –€“»ﬂ Œ Õ¿
        if cbHideClose.Checked then
        begin
          Form.Hide;
          Result := True;
        end;
    end; // case
  end;
end;

end.