{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLCPLApplet {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCPLApplet, mckCPLProject {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PKOLCPLApplet;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLCPLProject1: TKOLCPLProject;
    KOLCPLApplet1: TKOLCPLApplet;
    procedure KOLCPLApplet1Execute(Number, Data: Integer);
    procedure KOLCPLApplet1Start(Number: Integer;
      var NewCPLInfo: tagNEWCPLINFOA);
    procedure KOLCPLApplet1Init(var Initiate: Boolean);
    procedure KOLCPLApplet1Stop(Number, Data: Integer);
    procedure KOLCPLApplet1Select(Number, Data: Integer);
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

uses Unit2;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}
function CPlApplet(hWndCpl: HWnd; Msg: Word; lParam: longint; var NewCPLInfo: TNewCPLInfo): longint;stdcall;
begin
 Result := KOLCPLApplet.Run(hWndCpl,Msg,lParam,NewCPLInfo);
end;

exports
   CPlApplet;

procedure TForm1.KOLCPLApplet1Execute(Number, Data: Integer);
begin
if Number = 0 then Main.Form.ShowModal
else
 MsgBox('Applet no 1 contains no forms!',mb_iconinformation);
end;

procedure TForm1.KOLCPLApplet1Start(Number: Integer;
  var NewCPLInfo: tagNEWCPLINFOA);
begin
if  Number = 0 then NewMain(Main,Applet);
end;

procedure TForm1.KOLCPLApplet1Init(var Initiate: Boolean);
begin
//if MsgBox('OnInit proceed?',mb_ok or mb_yesno)= idno then Initiate := False;
{This way You could cause applet not to execute}
end;

procedure TForm1.KOLCPLApplet1Stop(Number, Data: Integer);
begin
//if Number = 0 then MsgBox('OnStop',mb_ok);
end;


procedure TForm1.KOLCPLApplet1Select(Number, Data: Integer);
begin
Beep(200,200);
Beep(300,300);
Beep(400,400);
//Msgbox('OnSelect seems not working at all, why?',mb_ok);
end;

initialization
NewForm1(Form1,nil);
finalization
Form1.Free;

end.


