{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
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
    BitBtn1: TKOLBitBtn;
    Button1: TKOLButton;
    procedure KOLForm1FormCreate(Sender: PObj);
    function BitBtn1WWMessage(var Msg: tagMSG; var Rslt: Integer): Boolean;
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

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var L: PControl;
begin
  BitBtn1.Border := 6;
  L := NewWordWrapLabel( BitBtn1, BitBtn1.Caption ).SetAlign( caClient );
  BitBtn1.Caption := '';
  L.OnMessage := BitBtn1WWMessage;
end;

function TForm1.BitBtn1WWMessage(var Msg: tagMSG;
  var Rslt: Integer): Boolean;
begin
  Result := FALSE;
  if (Msg.message >= WM_MOUSEFIRST) and (Msg.message <= WM_MOUSELAST) then
  begin
    Rslt := BitBtn1.Perform( Msg.message, Msg.wParam, Msg.lParam );
    Result := TRUE;
  end;
end;

end.


