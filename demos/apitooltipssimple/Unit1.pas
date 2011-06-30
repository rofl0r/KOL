////////////////////////////////////////////////////////////////////////
// An example that demonstrate how to create a standard ToolTip control
// and add tools to it.
// Based on "Using ToolTip Controls" in Win32 Programmer's Reference.
////////////////////////////////////////////////////////////////////////
// A. Kubaszek  <a_kubaszek@poczta.onet.pl>
{$Define TTFontChng}
{ $Define TTTimeChng}

{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls,  MCKMHXP {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Button1: TKOLButton;
    EditBox1: TKOLEditBox;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
  private
    fTThwnd :HWND; // handle to the ToolTip control
{$IfDef TTFontChng}
    fTTFont :PGraphicTool;
{$EndIf}
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
  uses ToolTip1;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

{$IfDef TTTimeChng}
const TTDT_AUTOMATIC=0; TTDT_RESHOW=1; TTDT_AUTOPOP=2; TTDT_INITIAL=3;
{$EndIf}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
//Once
  fTThwnd := CreateTooltipWindow (Applet.Handle, HInstance);
{$IfDef TTTimeChng}
  SendMessage (fTThwnd,TTM_SETDELAYTIME,TTDT_INITIAL,100);
  SendMessage (fTThwnd,TTM_SETDELAYTIME,TTDT_RESHOW, 100 div 5);
  SendMessage (fTThwnd,TTM_SETDELAYTIME,TTDT_AUTOPOP,100 * 10);
{$EndIf}
{$IfDef TTFontChng}
  SendMessage (fTThwnd, TTM_SETTIPTEXTCOLOR, clNavy, 0);
  fTTFont:=NewFont; Form.Add2AutoFree(fTTFont);
  fTTFont.FontHeight:=22; fTTFont.FontName:='Arial';
  SendMessage (fTThwnd, WM_SETFONT, fTTFont.Handle, 0);
{$EndIf}

// For each Tool:
  TooltipAddTool(fTThwnd, Button1.GetWindowHandle, 'Something about Button1');
  TooltipAddTool(fTThwnd, EditBox1.GetWindowHandle, 'This is EditBox1');
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  DestroyTooltipWindow(fTThwnd)
end;

end.




