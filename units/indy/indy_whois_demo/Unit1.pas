{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF},IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdWhois;
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
    btLookup: TKOLButton;
    edDomain: TKOLEditBox;
    meResults: TKOLMemo;
    Label1: TKOLLabel;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure btLookupClickClick(Sender: PObj);
    procedure edDomainKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  IdWhoIs1:PIdWhoIs;

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
  IdWhoIs1:=NewIdWhoIs(nil);
end;

procedure TForm1.btLookupClickClick(Sender: PObj);
var
  ALine,
  AResult: string;
  iPos: Integer;

begin
  meResults.Clear;
  AResult := IdWhoIs1.WhoIs(edDomain.Text);
  while Length(AResult) > 0 do
  begin
    iPos := Pos(#10, AResult);
    if iPos = 1 then
    begin
      Delete(AResult, 1, 1);
    end
    else
    begin
      ALine := Copy(AResult, 1, iPos - 1);
      meResults.Add(ALine+#13#10);
      Delete(AResult, 1, Length(ALine));
    end;
  end;
end;

procedure TForm1.edDomainKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = 13 then
    btLookup.OnClick(@Self);
end;

end.


