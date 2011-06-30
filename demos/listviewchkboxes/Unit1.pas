{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls, mckObjs {$ENDIF};
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
    ListView1: TKOLListView;
    ImageList1: TKOLImageList;
    Panel1: TKOLPanel;
    Button1: TKOLButton;
    Timer1: TKOLTimer;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure ListView1MouseDown(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure ListView1KeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure Timer1Timer(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  range=10;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

  {$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

//uses ... other user defined uses;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}




procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var
  i: Integer;

begin
ListView1.LVColAdd('Colum1', taLeft, (ListView1.Width - 4){ div });
//ListView1.LVColAdd('Colum2', taLeft, (ListView1.Width - 4) div 2);

for i:=0 to range do
   //ListView1.LVAdd('111', 0, [], 0, 0, 0);
   ListView1.LVItemAdd('Item: '+Int2Str(i));
end;



procedure CheckIcon(LV: PControl; Item: Integer);
begin
if LV.LVItemImageIndex[Item]<>1 then
   LV.LVItemImageIndex[Item]:=1
   else
   LV.LVItemImageIndex[Item]:=0;
end;



procedure TForm1.ListView1MouseDown(Sender: PControl;
  var Mouse: TMouseEventData);
type
  TLVHitTestInfo = packed record
    pt: TPoint;
    flags: DWORD;
    iItem: Integer;
    iSubItem: Integer;
    end;
var
  HTI: TLVHittestinfo;

begin
HTI.pt.x:=Mouse.X;
HTI.pt.y:=Mouse.y;
ListView1.Perform(LVM_HITTEST, 0, Integer(@ HTI));
if LongBool(HTI.flags and LVHT_ONITEMICON) then
   CheckIcon(ListView1, HTI.iItem);
end;



procedure TForm1.ListView1KeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
if Key=VK_SPACE then
   if ListView1.CurIndex>=0 then
      CheckIcon(ListView1, ListView1.CurIndex);
end;



procedure TForm1.Button1Click(Sender: PObj);
begin
if Timer1.Enabled then
   begin
   Timer1.Enabled:=False;
   Button1.Caption:='Demonstrate';
   end
   else
   begin
   Timer1.Enabled:=True;
   Button1.Caption:='Stop';
   ListView1.Focused:=True;
   end;
end;



procedure TForm1.Timer1Timer(Sender: PObj);
var
  r, m: Integer;

begin
//randomize;
r:=random(range+1);
m:=random(range+1);
if (r>ListView1.Count) or (r>ListView1.Count) then Exit;
if ListView1.LVItemImageIndex[r]=0 then
   ListView1.LVItemImageIndex[r]:=1
   else
   ListView1.LVItemImageIndex[r]:=0;

ListView1.LVSetItem(m, 0, ListView1.LVItems[m, 0], 0 , [lvisSelect], 0, 0, ListView1.LVItemData[m]);
end;

end.


