{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckObjs, Controls, mckCtrls {$ENDIF}, err;
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
    Button3: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button6: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure MenuItemHandler(Sender: PMenu; Item: Integer);
    procedure Button5Click(Sender: PObj);
    procedure Button6Click(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
  private
    { Private declarations }
    FMainMenu: PMenu;
    FSubMenu: PMenu;
    PopupMenu: PMenu;
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
  if FMainMenu = nil then
    FMainMenu := NewMenu( Form, 100, [ 'AAA', 'BBB' ], MenuItemHandler );
end;

var Id1: Integer = 0;
procedure TForm1.Button2Click(Sender: PObj);
begin
  if FMainMenu = nil then Exit;
  Inc( Id1 );
  FMainMenu.AddItem( PChar( 'CCC-' + Int2Str( Id1 ) ), MenuItemHandler, [ ] );
end;

var Idx: Integer = 0;
procedure TForm1.Button3Click(Sender: PObj);
begin
  if FMainMenu = nil then Exit;
  if FSubMenu = nil then
  begin
    FSubMenu := {NewMenu( Form, 200, [ '' ], nil );
    FMainMenu.ItemSubmenu[ 0 ] := FSubMenu.Handle;}
                FMainMenu.Items[ 0 ];
    if FSubMenu = nil then Exit;
  end;
  Inc( Idx );
  FSubMenu.AddItem( PChar( 'AAA-' + Int2Str( Idx ) ), MenuItemHandler, [ ] );
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  if FMainMenu = nil then Exit;
  if FSubMenu = nil then Exit;
  if FSubMenu = PopupMenu then
    PopupMenu := nil;
  FSubMenu.Free;
  FSubMenu := nil;
  //FMainMenu.ItemSubmenu[ 0 ] := 0;
end;

procedure TForm1.MenuItemHandler(Sender: PMenu; Item: Integer);
begin
  ShowMessage( Int2Str( Item ) );
end;

procedure TForm1.Button5Click(Sender: PObj);
begin
  if FMainMenu = nil then Exit;
  if PopupMenu = nil then
  begin
    PopupMenu := NewMenu( nil, 0, [ '111', '('
        , '111xxx', '111yyy', '111zzz', ')', '222', '(', '222xxx'
        , '222yyy', ')', '333', '(', '333xxx', ')', '' ], MenuItemHandler );
    PopupMenu.Caption := 'SubMenu';
  end;
  FMainMenu.InsertSubMenu( PopupMenu, -1 );
end;

procedure TForm1.Button6Click(Sender: PObj);
begin
  if FMainMenu = nil then Exit;
  if PopupMenu = nil then Exit;
  FMainMenu.RemoveSubMenu( FMainMenu.IndexOf( PopupMenu ) );
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  PopupMenu.Free;
end;

end.


