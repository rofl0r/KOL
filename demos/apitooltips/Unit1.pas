{***********************************
*** This demo shows how  you can ***
*** use Win32Api to set ToolTips ***
*** for some Pcontrols           ***
************************************
*** ApiToolTips by Igor Popoff   ***
************************************}


{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF};
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
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Panel1: TKOLPanel;
    BB: TKOLBitBtn;
    ComboBox1: TKOLComboBox;
    EditBox1: TKOLEditBox;
    CheckBox1: TKOLCheckBox;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure BB2MouseMove(Sender: PControl; var Mouse: TMouseEventData);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  HintWnd,Main,Control,StaticText1,hFont: HWND;
  TI : TToolInfo;
  J: integer;


{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}



procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  Main:= Form1.Form.GetWindowHandle;
  HintWnd:=CreateWindowEx (0,TOOLTIPS_CLASS,'',0,CW_USEDEFAULT,CW_USEDEFAULT,
                              CW_USEDEFAULT,CW_USEDEFAULT,Main,0,HInstance,NIL);
 { You can also include next four values into Kol.pas file(As own you risc)
  if you want to change some parameters
  manually. To get more information use 
   Tooltip Control Reference in Win32 Programmer's Reference
  TTDT_AUTOMATIC          = 0;
  TTDT_RESHOW             = 1;
  TTDT_AUTOPOP            = 2;
  TTDT_INITIAL            = 3;}

  //SendMessage (HintWnd,TTM_SETDELAYTIME,TTDT_INITIAL,20);
  //SendMessage (HintWnd,TTM_SETDELAYTIME,TTDT_RESHOW,2000);
  //SendMessage (HintWnd,TTM_SETDELAYTIME,TTDT_AUTOPOP,2000);
end;

procedure TForm1.BB2MouseMove(Sender: PControl;
  var Mouse: TMouseEventData);
var  R: Trect;
begin
R:= Sender.ClientRect;
Control:= Sender.GetWindowHandle;
   with TI do
     begin
      cbSize:=SizeOf (TI);
      uFlags:=TTF_SUBCLASS;
      hWnd:=Control;
      uId:=0;
      rect.Left:= R.Left;
      rect.Top:= R.Top;
      rect.Right:= R.Right;
      rect.Bottom:= R.Bottom;
      hInst:=0;
      lpszText:=Pchar('I am ' + Sender.Caption);
     end;
 SendMessage (HintWnd,TTM_ADDTOOL,0,DWORD (@TI));
end;

end.


