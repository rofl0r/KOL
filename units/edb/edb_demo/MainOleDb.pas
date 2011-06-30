{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainOleDb;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF}, KOLEdb;
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
    Button1: TKOLButton;
    lvData: TKOLListView;
    Button2: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure Button2Click(Sender: PObj);
    function lvDataEndEditLVItem(Sender: PControl; Idx, Col: Integer;
      NewText: PChar): Boolean;
    procedure lvDataKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
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
{$I MainOleDb_1.inc}
{$ENDIF}

var DS: PDataSource;
    SS: PSession;
    QR: PQuery;

procedure TForm1.Button1Click(Sender: PObj);
var I, N: Integer;
begin
  if DS = nil then
  begin
    {!!!!!!!! This works for MS SQL remote server: }
    //DS := NewDataSource( 'PROVIDER=SQLOLEDB;DATA SOURCE=srv11;DATABASE=mydb;' +
    //                     'USER ID=vl;PASSWORD=;' );

    DS := NewDataSource( 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;' +
    'Data Source=C:\Borland\Common Files\Data\dbdemos.mdb;' +
    'Data Source=' + GetStartDir + 'Data\tst.mdb;' +
    'Mode=Share Deny None;' +
    'Extended Properties="";' +
    'Locale Identifier=1033;' +
    'Persist Security Info=False;' {+

    //'Jet OLEDB:System database=C:\SYSTEM.MDW;' +
    // -- line above does not lead to fault

    'Jet OLEDB:Registry Path="";' +
    'Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;' +
    'Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;' +
    'Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";' +
    'Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;' +
    'Jet OLEDB:Don''t Copy Locale on Compact=False;' +
    'Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False'}
    );
    SS := NewSession( DS );
    QR := NewQuery( SS );
    //QR.Mode := rmReadOnly; //-- worked, but not interesting
    QR.Text := 'select Nam, Lab, Birth from OTV';
    QR.Open;
    {QR.Last;
    MsgOK( 'Rows affected: ' + Int2Str( QR.RowCount ) + #13#10 +
           'Column0: ' + QR.ColNames[ 0 ] + ', Column1: ' + QR.ColNames[ 1 ] );}
  end;

  QR.First;
  N := 0;
  lvData.Clear;
  while not QR.EOF do
  begin
    I := lvData.LVItemAdd( QR.SFieldByName[ 'Nam' ] );
    lvData.LVItems[ I, 1 ] := Int2Str( Round( QR.RFieldByName[ 'Lab' ] ) );
    //lvData.LVItems[ I, 2 ] := DateTime2StrShort( QR.DFieldByName[ 'Birth' ] );
    lvData.LVItems[ I, 2 ] := QR.FieldByNameAsStr[ 'Birth' ];
    QR.Next;
    Inc( N );
  end;
  MsgOK( Int2Str( N ) );
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
{var D: TDateTime;
    ST: TSystemTime;}
begin
  lvData.LVColAdd( 'FIO', taLeft, lvData.Width div 2 - 20 );
  lvData.LVColAdd( 'Lab', taLeft, 50 );
  lvData.LVColAdd( 'Date', taLeft, 130 );

  {FillChar( ST, Sizeof( ST ), 0 );
  ST.wYear := 1899;
  ST.wMonth := 12;
  ST.wDay := 31;
  SystemTime2DateTime( ST, D );
  ShowMessage( Double2Str( D ) );}

  {if StrSatisfy( '123', '*3?' ) then
    ShowMessage( 'bug' );}
end;

procedure TForm1.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  DS.Free;
  DS := nil;
  SS := nil;
  QR := nil;
end;

procedure TForm1.Button2Click(Sender: PObj);
var I: Integer;
begin
  if DS = nil then Exit;
  //QR.First;
  for I := 0 to lvData.LVCount-1 do
  begin
    if lvData.LVItemData[ I ] <> 0 then
    begin
      QR.CurIndex := I;
      QR.SFieldByName[ 'Nam' ] := lvData.LVItems[I,0];
      QR.RFieldByName[ 'Lab' ] := Str2Double( lvData.LVItems[I,1] );
      QR.FieldByNameAsStr[ 'Birth' ] := lvData.LVItems[I,2];
      QR.Post;
      lvData.LVItemData[ I ] := 0;
    end;
    //QR.Next;
  end;
  Button2.Enabled := FALSE;
end;

function TForm1.lvDataEndEditLVItem(Sender: PControl; Idx, Col: Integer;
  NewText: PChar): Boolean;
begin
  lvData.LVItemData[ Idx ] := 1;
  Result := TRUE;
  Button2.Enabled := TRUE;
end;

procedure TForm1.lvDataKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
var I: Integer;
begin
  if (Key = VK_RETURN) or (KEY = VK_F2) then
  begin
    I := lvData.LVNextSelected( -1 );
    if I < 0 then I := 0;
    lvData.LVEditItemLabel( I );
  end;
end;

end.



