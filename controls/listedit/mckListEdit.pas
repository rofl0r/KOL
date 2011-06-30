unit mckListEdit;

interface

uses
  Windows, Classes, Messages, Forms, SysUtils,
  mckCtrls, Graphics;

type

  TListEditColumns = class;

  TKOLListEdit = class(TKOLListView)
  private
    fColumns: TListEditColumns;
    fColCount: integer;
    fListData: boolean;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function GetCaption: string;
    function GetStyle: TKOLListViewStyle;
    function GetOptions: TKOLListViewOptions;
    procedure SetOptions(v: TKOLListViewOptions);
    function GetColumns: TListEditColumns; virtual;
    procedure SetColumns(v: TListEditColumns);
    function  GetColCount: integer;
    procedure SetColCount(v: integer);
  public
    constructor Create(Owner: TComponent); override;
    property IsListData: boolean read fListData write fListData;
    procedure UpdateColumns; virtual;
  published
    property Caption: string Read GetCaption;
    property Style: TKOLListViewStyle Read GetStyle;
    property Options: TKOLListViewOptions read GetOptions write SetOptions;
    property Columns: TListEditColumns read fColumns write SetColumns;
    property ColCount: integer read GetColCount write SetColCount;
  end;

  TListEditColumnsItem = class(TCollectionItem)
  private
    fCaption: string;
    fAlign: TAlignment;
    fWidth: integer;
    fFieldName: string;
  protected
    procedure SetAlignment(a: TAlignment);
    procedure SetCaption(c: string);
    procedure SetWidth(w: integer);
  published
    property Alignment: TAlignment read fAlign write fAlign;
    property Caption: string read fCaption write fCaption;
    property Width: integer read fWidth write fWidth;
    property FieldName: string read fFieldName write fFieldName;
  end;

  TListEditColumns = class(TCollection)
  private
    FOwner: TKOLListEdit;
    function GetItem(Index: Integer): TListEditColumnsItem;
    procedure SetItem(Index: Integer; Value: TListEditColumnsItem);
  protected
    function GetOwner: TPersistent; override;
  public
    FieldNames: TStringList;
    constructor Create(AOwner: TKOLListEdit);
    destructor Destroy; override;
    function Owner: TKOLListEdit;
    property Items[Index: Integer]: TListEditColumnsItem read GetItem write SetItem; default;
  end;

  procedure Register;

implementation

{$R *.dcr}

constructor TKOLListEdit.Create;
begin
   inherited;
   inherited Style   := lvsDetail;
   inherited Options := [lvoRowSelect];
   Font.FontCharset  := 204;
   fColumns := TListEditColumns.Create(self);
end;

procedure TKOLListEdit.UpdateColumns;
begin
   Change;
end;

function  TKOLListEdit.AdditionalUnits;
begin
   Result := ', ListEdit';
end;

procedure TKOLListEdit.SetupFirst;
var i: integer;
    s: string;
begin
  inherited;
  for i := 0 to fColumns.Count - 1 do begin
     case fColumns.Items[i].Alignment of
    taLeftJustify:   s := 'taLeft';
    taCenter:        s := 'taCenter';
    taRightJustify:  s := 'taRight';
     end;
     SL.Add( Prefix + AName + '.LVColAdd(''' + fColumns.Items[i].Caption + ''',' + s + ' , ' + intTostr(fColumns.Items[i].Width) + ');' );
  end;
end;

procedure TKOLListEdit.SetupLast;
begin
   inherited AssignEvents(SL, AName);
end;

procedure TKOLListEdit.AssignEvents;
begin
   inherited;
end;

function TKOLListEdit.GetCaption;
begin
   Result := inherited Caption;
end;

function TKOLListEdit.GetStyle;
begin
   Result := lvsDetail;
end;

function TKOLListEdit.GetOptions;
begin
   Result := inherited Options;
end;

procedure TKOLListEdit.SetOptions;
begin
   inherited Options := v + [lvoRowSelect];
end;

function  TKOLListEdit.GetColumns;
begin
   Result := fColumns;
end;

procedure TKOLListEdit.SetColumns;
begin
   fColumns.Assign(v);
   Change;
end;

function  TKOLListEdit.GetColCount;
begin
   Result := fColumns.Count;
end;

procedure TKOLListEdit.SetColCount;
begin
   fColCount := v;
   if fColCount < 0 then fColCount := 0;
   while fColCount > fColumns.Count do fColumns.Add;
   while fColCount < fColumns.Count do fColumns[fColumns.Count - 1].Free;
   Change;
end;

procedure TListEditColumnsItem.SetAlignment;
begin
   fAlign := A;
   TListEditColumns(GetOwner).FOwner.Change;
end;

procedure TListEditColumnsItem.SetCaption;
begin
   fCaption := C;
end;

procedure TListEditColumnsItem.SetWidth;
begin
   fWidth := W;
end;

constructor TListEditColumns.Create;
begin
   inherited create(TListEditColumnsItem);
   fOwner := AOwner;
   FieldNames := TStringList.Create;
end;

destructor TListEditColumns.Destroy;
begin
   FieldNames.Free;
   inherited;
end;

function  TListEditColumns.GetItem;
begin
  result := TListEditColumnsItem(inherited GetItem(Index));
end;

procedure TListEditColumns.SetItem;
begin
  inherited SetItem(Index, Value);
  FOwner.Change;
end;

function  TListEditColumns.GetOwner;
begin
  result := FOwner;
end;

function  TListEditColumns.Owner;
begin
  result := FOwner;
end;

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLListEdit]);
end;

end.

