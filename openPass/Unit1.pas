{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHAboutDialog, KOLMHXP {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckObjs, MCKMHAboutDialog,
  MCKMHXP, {$ENDIF};
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
    PassEd: TKOLEditBox;
    CopyRightL: TKOLLabel;
    Timer1: TKOLTimer;
    MainMenu1: TKOLMainMenu;
    MHAboutDialog1: TKOLMHAboutDialog;
    MHXP1: TKOLMHXP;
    procedure Timer1Timer(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1N2Menu(Sender: PMenu; Item: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Version:String;
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

procedure TForm1.Timer1Timer(Sender: PObj);
var
  CPos: TPoint;
  CWindow: HWND;
  Buf:array [0..255] of Char;
  WStyle:DWord;
  WL: LongInt;
  R:Trect;
begin

  GetCursorPos(CPos);
  CWindow:= WindowFromPoint(CPos);
  // Функция GetWindowText не дает текста из другого окна !!!
  // а сообщение WM_GETTEXT дает !!!
  SendMessage(CWindow,WM_GETTEXT,LongInt(SizeOf(Buf)),LongInt(@Buf));
  // Снеми пароль
  WL:= GetWindowLong(CWindow, GWL_STYLE);
  if ((LongInt(ES_PASSWORD)) and WL) <> 0 then
  begin
    SendMessage(CWindow,EM_SETPASSWORDCHAR,0,0);
    SendMessage(CWindow,WM_PAINT,GetDC(CWindow),0);
  end;

  // Если у тебя нет имяни, то может у родителя есть?!
  // ***
  //  if StrPas(Buf)='' then
  //  SendMessage(GetParentWindow(CWindow),WM_GETTEXT,LongInt(SizeOf(Buf)),LongInt(@Buf));
  if PassEd.Text<>String(Buf) then
    PassEd.Text:=String(Buf);

end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  // V1.1 15-nov-2001
  Version:='1.1';
  Form1.Form.Caption:=Form1.Form.Caption+Version;
end;

procedure TForm1.KOLForm1N2Menu(Sender: PMenu; Item: Integer);
begin
  MHAboutDialog1.Execute;
end;

end.





































