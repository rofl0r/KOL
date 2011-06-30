// 7-dec-2002
// 25-apr-2003
unit KOLClasses;

interface

uses KOL,Windows;

type
  TDuplicates = (dupIgnore, dupAccept, dupError);

  TThreadList = object(TObj)
  private
    FList: PList;//TList;
    FLock: TRTLCriticalSection;
    FDuplicates: TDuplicates;
  public
    procedure Init; virtual;
  //  constructor Create;
    destructor Destroy; virtual;//override;
    procedure Add(Item: Pointer);
    procedure Clear;
    function  LockList: PList;//TList;
    procedure Remove(Item: Pointer);
    procedure UnlockList;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
  end;

  PThreadList=^TThreadList;

  function NewThreadList({ACollection: PCollection}): PThreadList;

  type

  PCollection = ^TCollection;

  PCollectionItem = ^TCollectionItem;
  TCollectionItem = object(TObj)
  private
    FCollection: PCollection;
    FID: Integer;
//    FACollection:PCollection;
    function GetIndex: Integer;
    procedure SetCollection(Value: PCollection);
  protected
    FACollection:PCollection;
    procedure Changed(AllItems: Boolean);
    function GetOwner: PObj; // override;
    function GetDisplayName: string; virtual;
    procedure SetIndex(Value: Integer); virtual;
    procedure SetDisplayName(const Value: string); virtual;
  public
    { constructor Create(Collection: TCollection); virtual;
    } destructor Destroy;
      virtual;
    procedure Init; virtual;
    procedure Assign(Source: PCollectionItem);
    function GetNamePath: string; //override;
    property Collection: PCollection read FCollection write SetCollection;
    property ID: Integer read FID;
    property Index: Integer read GetIndex write SetIndex;
    property DisplayName: string read GetDisplayName write SetDisplayName;
  end;

  TCollection = object(TObj)
  private
    //    FItemClass: TCollectionItemClass;
    FItems: PList;
    FUpdateCount: Integer;
    FNextID: Integer;
    FPropName: string;
    function GetCount: Integer;
    function GetPropName: string;
    procedure InsertItem(Item: PCollectionItem);
    procedure RemoveItem(Item: PCollectionItem);
  protected
    property NextID: Integer read FNextID;
    { Design-time editor support }
    function GetAttrCount: Integer; // dynamic;
    function GetAttr(Index: Integer): string; // dynamic;
    function GetItemAttr(Index, ItemIndex: Integer): string; // dynamic;
    procedure Changed;
    function GetItem(Index: Integer): PCollectionItem;
    procedure SetItem(Index: Integer; Value: PCollectionItem);
    procedure SetItemName(Item: PCollectionItem); virtual;
    procedure Update(Item: PCollectionItem); virtual;
    property PropName: string read GetPropName write FPropName;
    property UpdateCount: Integer read FUpdateCount;
  public
    { constructor Create(ItemClass: TCollectionItemClass);
    } destructor Destroy;
      virtual;
    procedure Init; virtual;
    function Add: PCollectionItem;
    procedure Assign(Source: PObj); // override;
    procedure BeginUpdate; virtual;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure EndUpdate; virtual;
    function FindItemID(ID: Integer): PCollectionItem;
    function GetNamePath: string; // override;
    function Insert(Index: Integer): PCollectionItem;
    property Count: Integer read GetCount;
    //    property ItemClass: TCollectionItemClass read FItemClass;
    property Items[Index: Integer]: PCollectionItem read GetItem write SetItem;
  end;
  //Pllection=^ollection;

  { Collection class that maintains an "Owner" in order to obtain property
    path information at design-time }

  POwnedCollection = ^TOwnedCollection;
  TOwnedCollection = object(TCollection)
  private
    FOwner: PObj;
  protected
    function GetOwner: PObj; // override;
  public
    //    procedure Init; virtual;
        { constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
     }
  end;
  //Plection=^llection;
  //function Newlection(AOwner: TPersistent; ItemClass: TCollectionItemClass):Plection; type  MyStupid20258=DWord;
function NewOwnedCollection(AOwner: PObj {;
  ItemClass: TCollectionItemClass}): POwnedCollection;
function NewCollection(Collection: PCollection): PCollection;
function NewCollectionItem(ACollection: PCollection): PCollectionItem;

type

  PStringStreamData=^TStringStreamData;
  

  PStringStream=^TStringStream;
  TStringStream=object(TStream)
  private
//    FDataString: string;
//    FPosition: Integer;
      CData: PStringStreamData;
    function GetDataString:String;
  protected
    procedure SetSize(NewSize: Longint); //override;
  public
//    constructor Create(const AString: string);
    function Read(var Buffer; Count: Longint): Longint; //override;
    function ReadString(Count: Longint): string;
    function Seek(Offset: Longint; Origin: Word): Longint; //override;
    function Write(const Buffer; Count: Longint): Longint; //override;
    procedure WriteString(const AString: string);
    property DataString: string read GetDataString;
  end;

  TStringStreamData=packed record
    FDataString: string;
    FPosition: Integer;
  end;

  function NewStringStream(const AString: string):PStringStream;



implementation

function NewCollectionItem(ACollection: PCollection): PCollectionItem;
//constructor TCollectionItem.Create(Collection: PCollection);
begin
  New(Result, Create);
  with Result^ do
    FACollection:=ACollection;
  Result.Init;
  //  with Result^ do
  //    SetCollection(Collection);
end;

procedure TCollectionItem.Init;
begin
  SetCollection(FACollection);//Collection);
end;

destructor TCollectionItem.Destroy;
begin
  SetCollection(nil);
  inherited Destroy;
end;

procedure TCollectionItem.Changed(AllItems: Boolean);
var
  Item: PCollectionItem;
begin
  if (FCollection <> nil) and (FCollection.FUpdateCount = 0) then
  begin
    if AllItems then
      Item := nil
    else
      Item := @Self;
    FCollection.Update(Item);
  end;
end;

function TCollectionItem.GetIndex: Integer;
begin
  if FCollection <> nil then
    Result := FCollection.FItems.IndexOf(@Self)
  else
    Result := -1;
end;

function TCollectionItem.GetDisplayName: string;
begin
  //  Result := ClassName;
end;

function TCollectionItem.GetNamePath: string;
begin
  if FCollection <> nil then
    Result := Format('%s[%d]', [FCollection.GetNamePath, Index]);
  {  else
      Result := ClassName;}
end;

function TCollectionItem.GetOwner: PObj;
begin
  Result := FCollection;
end;

procedure TCollectionItem.SetCollection(Value: PCollection);
begin
  if FCollection <> Value then
  begin
    if FCollection <> nil then
      FCollection.RemoveItem(@Self);
    if Value <> nil then
      Value.InsertItem(@Self);
  end;
end;

procedure TCollectionItem.SetDisplayName(const Value: string);
begin
  Changed(False);
end;

procedure TCollectionItem.SetIndex(Value: Integer);
var
  CurIndex: Integer;
begin
  CurIndex := GetIndex;
  if (CurIndex >= 0) and (CurIndex <> Value) then
  begin
    FCollection.FItems.MoveItem(CurIndex, Value);
    Changed(True);
  end;
end;

{ TCollection }

function NewCollection(Collection: PCollection): PCollection;
//constructor TCollection.Create(ItemClass: TCollectionItemClass);
begin
  New(Result, Create);
  Result.Init;
  {  with Result^ do
    begin
      //  FItemClass := ItemClass;
      FItems := NewList; //TList.Create;
    end;   }
end;

procedure TCollection.Init;
begin
  //  FItemClass := ItemClass;
  FItems := NewList; //TList.Create;
end;

destructor TCollection.Destroy;
begin
  FUpdateCount := 1;
  if FItems <> nil then
    Clear;
  FItems.Free;
  inherited Destroy;
end;

function TCollection.Add: PCollectionItem;
begin
  Result := NewCollectionItem(@Self); //FItemClass.Create(Self);
end;

procedure TCollection.Assign(Source: PObj);
var
  I: Integer;
begin
  if TCollection.AncestorOfObject(Source) { is TCollection} then
  begin
    BeginUpdate;
    try
      Clear;
      for I := 0 to PCollection(Source).Count - 1 do
        Add.Assign(PCollection(Source).Items[I]);
    finally
      EndUpdate;
    end;
    Exit;
  end;
  //  inherited Assign(Source);
end;

procedure TCollection.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TCollection.Changed;
begin
  if FUpdateCount = 0 then
    Update(nil);
end;

procedure TCollection.Clear;
begin
  if FItems.Count > 0 then
  begin
    BeginUpdate;
    try
      while FItems.Count > 0 do
        PCollectionItem(FItems.Last).Free;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TCollection.EndUpdate;
begin
  Dec(FUpdateCount);
  Changed;
end;

function TCollection.FindItemID(ID: Integer): PCollectionItem;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
  begin
    Result := PCollectionItem(FItems.Items[I]);
    if Result.ID = ID then
      Exit;
  end;
  Result := nil;
end;

function TCollection.GetAttrCount: Integer;
begin
  Result := 0;
end;

function TCollection.GetAttr(Index: Integer): string;
begin
  Result := '';
end;

function TCollection.GetItemAttr(Index, ItemIndex: Integer): string;
begin
  Result := Items[ItemIndex].DisplayName;
end;

function TCollection.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TCollection.GetItem(Index: Integer): PCollectionItem;
begin
  Result := FItems.Items[Index];
end;

function TCollection.GetNamePath: string;
var
  S, P: string;
begin
  //  Result := ClassName;
//    if GetOwner = nil then Exit;
  //  S := GetOwner.GetNamePath;
  if S = '' then
    Exit;
  P := PropName;
  if P = '' then
    Exit;
  Result := S + '.' + P;
end;

function TCollection.GetPropName: string;
//var
//  I: Integer;
  //  Props: PPropList;
  //  TypeData: PTypeData;
//  Owner: PObj; //TPersistent;
begin
  Result := FPropName;
  {  Owner := GetOwner;
    if (Result <> '') or (Owner = nil) or (Owner.ClassInfo = nil) then Exit;
    TypeData := GetTypeData(Owner.ClassInfo);
    if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
    GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
    try
      GetPropInfos(Owner.ClassInfo, Props);
      for I := 0 to TypeData^.PropCount-1 do
      begin
        with Props^[I]^ do
          if (PropType^^.Kind = tkClass) and
            (GetOrdProp(Owner, Props^[I]) = Integer(Self)) then
            FPropName := Name;
      end;
    finally
      Freemem(Props);
    end;}
  Result := FPropName;
end;

function TCollection.Insert(Index: Integer): PCollectionItem;
begin
  Result := Add;
  Result.Index := Index;
end;

// Out param is more code efficient for interfaces than function result
{procedure GetDesigner(Obj: TPersistent; out Result: IDesignerNotify);
var
  Temp: TPersistent;
begin
  Result := nil;
  if Obj = nil then Exit;
  Temp := Obj.GetOwner;
  if Temp = nil then
  begin
    if (Obj is TComponent) and (csDesigning in TComponent(Obj).ComponentState) then
      TComponent(Obj).QueryInterface(IDesignerNotify, Result);
  end
  else
  begin
    if (Obj is TComponent) and
      not (csDesigning in TComponent(Obj).ComponentState) then Exit;
    GetDesigner(Temp, Result);
  end;
end;}

{function FindRootDesigner(Obj: TPersistent): IDesignerNotify;
begin
  GetDesigner(Obj, Result);
end;}

{procedure NotifyDesigner(Self, Item: TPersistent; Operation: TOperation);
var
  Designer: IDesignerNotify;
begin
  GetDesigner(Self, Designer);
  if Designer <> nil then
    Designer.Notification(Item, Operation);
end;}

procedure TCollection.InsertItem(Item: PCollectionItem);
begin
  //  if not (Item is FItemClass) then
  //    TList.Error(@SInvalidProperty, 0);
  FItems.Add(Item);
  Item.FCollection := @Self;
  Item.FID := FNextID;
  Inc(FNextID);
  SetItemName(Item);
  Changed;
  //  NotifyDesigner(Self, Item, opInsert);
end;

procedure TCollection.RemoveItem(Item: PCollectionItem);
begin
  //  NotifyDesigner(Self, Item, opRemove);
  FItems.Remove(Item);
  Item.FCollection := nil;
  Changed;
end;

procedure TCollection.SetItem(Index: Integer; Value: PCollectionItem);
begin
  PCollectionItem(FItems.Items[Index]).Assign(Value);
end;

procedure TCollection.SetItemName(Item: PCollectionItem);
begin
end;

procedure TCollection.Update(Item: PCollectionItem);
begin
end;

procedure TCollection.Delete(Index: Integer);
begin
  PCollectionItem(FItems.Items[Index]).Free;
end;

{ TOwnedCollection }

function NewOwnedCollection(AOwner: PObj {;
  ItemClass: TCollectionItemClass}): POwnedCollection;
{constructor TOwnedCollection.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);}
begin
  New(Result, Create);
  with Result^ do
    FOwner := AOwner;
  //  inherited Create(ItemClass);
end;

function TOwnedCollection.GetOwner: PObj;
begin
  Result := FOwner;
end;

procedure TCollectionItem.Assign(Source: PCollectionItem);
begin
  Collection := Source.Collection;
  FID := Source.FID; // ???
  Index := Source.Index;
  DisplayName := Source.DisplayName;
end;

{constructor TStringStream.Create(const AString: string);
begin
  inherited Create;
  FDataString := AString;
end;}

function TStringStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := Length(CData.FDataString) - CData.FPosition;
  if Result > Count then Result := Count;
  Move(PChar(@CData.FDataString[Data.FPosition + 1])^, Buffer, Result);
  Inc(CData.FPosition, Result);
end;

function TStringStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := Count;
  SetLength(CData.FDataString, (CData.FPosition + Result));
  Move(Buffer, PChar(@CData.FDataString[Data.FPosition + 1])^, Result);
  Inc(CData.FPosition, Result);
end;

function TStringStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
{  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := Length(FDataString) - Offset;
  end;}
  if CData.FPosition > Length(CData.FDataString) then
    CData.FPosition := Length(CData.FDataString)
  else if CData.FPosition < 0 then CData.FPosition := 0;
  Result := CData.FPosition;
end;

function TStringStream.ReadString(Count: Longint): string;
var
  Len: Integer;
begin
  with CData^ do
  begin
  Len := Length(FDataString) - FPosition;
  if Len > Count then Len := Count;
  SetString(Result, PChar(@FDataString[FPosition + 1]), Len);
  Inc(FPosition, Len);
  end;
end;

procedure TStringStream.WriteString(const AString: string);
begin
  Write(PChar(AString)^, Length(AString));
end;

procedure TStringStream.SetSize(NewSize: Longint);
begin
  with CData^ do
  begin
  SetLength(FDataString, NewSize);
  if FPosition > NewSize then FPosition := NewSize;
  end;
end;

function TStringStream.GetDataString:String;
begin
  Result:=CData.FDataString;
end;

function NewStringStream(const AString: string):PStringStream;
begin
//  New( Result, Create );
//  Move( StreamMethods, Result.fMethods, Sizeof( TStreamMethods ) );
//  Result.fPMethods := @Result.fMethods;
  Result:=PStringStream(NewMemoryStream);

  with Result^ do
  begin
//    inherited Create;
    GetMem(CData,Sizeof(CData^));
    FillChar(CData^,Sizeof(CData^),0);
    CData.FDataString := AString;
  end;
end;

{ TThreadList }

procedure TThreadList.Add(Item: Pointer);
begin
  LockList;
 // try
    if (Duplicates = dupAccept) or
       (FList.IndexOf(Item) = -1) then
      FList.Add(Item)
    else if Duplicates = dupError then
    begin
//      FList.Error(@SDuplicateItem, Integer(Item));
    end;
//  finally
    UnlockList;
//  end;
end;

procedure TThreadList.Clear;
begin
LockList;
  try
    FList.Clear;
  finally
    UnlockList;
  end;

end;

destructor TThreadList.Destroy;
begin
  LockList;    // Make sure nobody else is inside the list.
  try
    FList.Free;
    inherited Destroy;
  finally
    UnlockList;
    DeleteCriticalSection(FLock);
  end;
end;

procedure TThreadList.Init;
begin
  inherited;// Create;
  InitializeCriticalSection(FLock);
  FList := NewList;//TList.Create;
  FDuplicates := dupIgnore;
end;

function TThreadList.LockList: PList;//TList;
begin
  EnterCriticalSection(FLock);
  Result := FList;
end;

procedure TThreadList.Remove(Item: Pointer);
begin
  LockList;
  try
    FList.Remove(Item);
  finally
    UnlockList;
  end;
end;

procedure TThreadList.UnlockList;
begin
  LeaveCriticalSection(FLock);
end;

function NewThreadList({ACollection: PCollection}): PThreadList;
begin
  New( Result, Create );
  Result.Init;
{  inherited Create;
  InitializeCriticalSection(FLock);
  FList := TList.Create;
  FDuplicates := dupIgnore;}
end;

end.
