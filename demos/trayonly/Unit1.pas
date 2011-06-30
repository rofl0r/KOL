{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
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
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    TrayIcon1: TKOLTrayIcon;
    KOLApplet1: TKOLApplet;
    PopupMenu1: TKOLPopupMenu;
    procedure PopupMenu1N1Menu(Sender: PMenu; Item: Integer);
    procedure TrayIcon1Mouse(Sender: TObject; Message: Word);
    procedure PopupMenu1N2Menu(Sender: PMenu; Item: Integer);
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

procedure TForm1.PopupMenu1N1Menu(Sender: PMenu; Item: Integer);
begin
  Form.Top := GetSystemMetrics( SM_CYSCREEN ) + 1;
  Form.Close;
end;

procedure TForm1.TrayIcon1Mouse(Sender: TObject; Message: Word);
var P: TPoint;
begin
  if Message = WM_RBUTTONUP then
  begin
    GetCursorPos( P );
    PopupMenu1.PopupEx( P.x, P.y );
  end;
end;

procedure TForm1.PopupMenu1N2Menu(Sender: PMenu; Item: Integer);
var T: Integer;
begin
  T := Form.Top;
  Form.Top := GetSystemMetrics( SM_CYSCREEN ) + 1;

  postmessage(form.handle, wm_syscommand, sc_minimize, 0);
  Applet.ProcessMessages;

  postmessage(form.handle, wm_syscommand, sc_restore, 0);
  Applet.ProcessMessages;

  Applet.Visible := FALSE;
  Form.Visible := FALSE;
  Form.Top := T;
end;

end.


