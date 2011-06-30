{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  Pfrm_Scan = ^Tfrm_Scan;
  Tfrm_Scan = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  Tfrm_Scan = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    Label3: TKOLLabel;
    Edit1: TKOLEditBox;
    Edit2: TKOLEditBox;
    Edit3: TKOLEditBox;
    Timer1: TKOLTimer;
    procedure Timer1Timer(Sender: PObj);
  private
    procedure ShowHwndAndClassName(CrPos: TPoint);
  public
    { Public declarations }
  end;

var
  frm_Scan {$IFDEF KOL_MCK} : Pfrm_Scan {$ELSE} : Tfrm_Scan {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure Newfrm_Scan( var Result: Pfrm_Scan; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure Tfrm_Scan.Timer1Timer(Sender: PObj);
var
  rPos: TPoint;
begin
  if boolean(GetCursorPos(rPos)) then ShowHwndAndClassName(rPos);
end;

procedure Tfrm_Scan.ShowHwndAndClassName(CrPos: TPoint);
var
  hWnd: THandle;
  hWndStr: String;
  aName,
  Text :  array [0..255] of char;
begin
  hWnd := WindowFromPoint(CrPos);
  Str(hWnd, hWndStr);
  Edit2.Text := hWndStr;

  if boolean(GetClassName(hWnd, aName, 256)) then
    Edit1.Text := string(aName)
  else
    Edit1.Text := 'ClassName :  not found';
  SendMessage(hWnd, WM_GETTEXT,SizeOf(Text), integer(@Text));
  Edit3.Text := Text;
end;

end.



