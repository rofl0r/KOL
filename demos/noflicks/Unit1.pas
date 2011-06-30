{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF}, err;
{$ELSE}
{$I uses.inc}
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
    Button1: TKOLButton;
    Button2: TKOLButton;
    Panel1: TKOLPanel;
    KOLApplet1: TKOLApplet;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    function CoverFormMessage(var Msg: tagMSG; var Rslt: Integer): Boolean;
  private
    { Private declarations }
    FCover: PControl;
    procedure CreateCover;
    procedure DoTests;
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

procedure TForm1.Button1Click(Sender: PObj);
begin
  DoTests;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  CreateCover;
  DoTests;
end;

function TForm1.CoverFormMessage(var Msg: tagMSG;
  var Rslt: Integer): Boolean;
begin
  Result := FALSE;
  if Msg.message = WM_PAINT then
  begin
    Rslt := 0;
    Result := TRUE;
  end
    else
  if Msg.message = WM_ERASEBKGND then
  begin
    Rslt := 1;
    Result := TRUE;
  end;
end;

procedure TForm1.CreateCover;
begin
  FCover := NewForm( Applet, '' );
  FCover.BoundsRect := Form.BoundsRect;
  FCover.OnMessage := CoverFormMessage;
  FCover.HasBorder := FALSE;
  ShowWindow( FCover.GetWindowHandle, SW_SHOWNOACTIVATE );
end;

procedure TForm1.DoTests;
var I: Integer;
    W: HWnd;
begin
  W := GetFocusedChild( Form.Handle );
  Button1.Enabled := FALSE;
  Button2.Enabled := FALSE;
  for I := 1 to 20 do
  begin
    Sleep( 10 );
    if Length( Form.Caption ) > 20 then
      Form.Caption := ''
    else
      Form.Caption := Form.Caption + '*';
    if Length( Panel1.Caption ) > 20 then
      Panel1.Caption := ''
    else
      Panel1.Caption := Panel1.Caption + '*';
  end;
  Button1.Enabled := TRUE;
  Button2.Enabled := TRUE;
  if W <> 0 then
    SetFocus( W );
  FCover.Free;
  FCover := nil;
end;

end.


