unit mckKOLTable;

interface

uses
  Windows, Classes, Messages, Forms, SysUtils,
  mirror, mckCtrls, Graphics, KOLEdb, ADOdb,
  ADOConEd, mckListEdit, DB, KOL,
  ExptIntf, ToolIntf, EditIntf, // DsgnIntf
//////////////////////////////////////////////////
     {$IFDEF VER140}                            //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants                                   //
     {$ELSE}                                    //
     DsgnIntf                                   //
     {$ENDIF}                                   //
//////////////////////////////////////////////////
     {$IFNDEF VER90}{$IFNDEF VER100}, ToolsAPI{$ENDIF}{$ENDIF},
     TypInfo, Consts;

type

  PKOLDataSource =^TKOLDataSource;
  TKOLDataSource = class(TKOLObj)
  private
    fConnection: WideString;
    AQ: TADOQuery;
  protected
    function  AdditionalUnits: string; override;
    function  TypeName: string; override;
    function  CompareFirst( c, n: string): boolean; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function  GetConnection: WideString;
    procedure SetConnection(Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Connection: WideString read GetConnection write SetConnection;
  end;

  TKOLSession = class(TKOLObj)
  private
    fDataSource: TKOLDataSource;
  protected
    function  AdditionalUnits: string; override;
    function  TypeName: string; override;
    function  CompareFirst( c, n: string): boolean; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetDataSource(DS: TKOLDataSource);
  published
    property  DataSource: TKOLDataSource read fDataSource write SetDataSource;
  end;

  TKOLQuery = class(TKOLObj)
  private
    fSession: TKOLSession;
    fTableName: WideString;
    fText: string;
  protected
    function  AdditionalUnits: string; override;
    function  TypeName: string; override;
    function  CompareFirst( c, n: string): boolean; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetSession(SS: TKOLSession);
    procedure SetText   (Tt: string);
    function  GetTableName: WideString;
    procedure SetTableName(Value: WideString);
  published
    property   Session: TKOLSession read fSession write SetSession;
    property       SQL: string read fText write SetText;
    property TableName: WideString read GetTableName write SetTableName;
  end;

  TTableStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TTableNameProperty = class(TStringProperty)
  private
    FConnection: TADOConnection;
  public
    function AutoFill: Boolean; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetConnection(Opened: Boolean): TADOConnection;
    procedure GetValueList(List: TStrings);
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TKOLListData = class(TKOLListEdit)
  private
    fAutoOpen: boolean;
    fOnRowChanged: TOnEvent;
    fQuery: TKOLQuery;
    fColCount: integer;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetAutoOpen(Value: boolean);
    function  GetColCount: integer;
    procedure SetColCount(Value: integer);
    procedure SetQuery(Value: TKOLQuery);
    procedure SetOnRowChanged(Value: TOnEvent);
    procedure DoRequest(Full: boolean);
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateColumns; override;
  published
    property AutoOpen: boolean read fAutoOpen write SetAutoOpen;
    property ColCount read GetColCount write SetColCount;
    property Query: TKOLQuery read fQuery write SetQuery;
    property OnRowChanged: TOnEvent read fOnRowChanged write SetOnRowChanged;
  end;

  procedure Register;

implementation

uses Ustr;

{$R *.dcr}

function TTableStringProperty.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog];
end;

procedure TTableStringProperty.Edit;
begin
   if EditConnectionString((GetComponent(0) as TKOLDataSource).AQ) then begin
      Modified;
   end;
end;

constructor TKOLDataSource.Create;
begin
   inherited;
   AQ := TADOQuery.Create(self);
end;

function  TKOLDataSource.AdditionalUnits;
begin
   Result := ', OLETable, KOLEdb';
end;

function  TKOLDataSource.TypeName;
begin
   Result := 'TKOLDataSource';
end;

function  TKOLDataSource.CompareFirst;
begin
   Result := False;
   if c = '' then Result := True;
end;

procedure TKOLDataSource.SetupFirst;
var s: string;
    c: string;
    t: string;
begin
   SL.Add( Prefix + AName + ' := NewDataSource(');
   c := '''' + fConnection + ''');';
   repeat
      t := Prefix + copy(c, 1, 77 - length(Prefix));
      delete(c, 1, 77 - length(Prefix));
      if c <> '' then begin
         t := t + ''' +';
         c := '''' + c;
      end;
      SL.Add(t);
   until length(c) = 0;
end;

function  TKOLDataSource.GetConnection;
begin
   fConnection := AQ.ConnectionString;
   Result := fConnection;
end;

procedure TKOLDataSource.SetConnection;
begin
   fConnection := Value;
   AQ.ConnectionString := Value;
   Change;
end;

function  TKOLSession.AdditionalUnits;
begin
   Result := ', OLETable, KOLEdb';
end;

function  TKOLSession.TypeName;
begin
   Result := 'TKOLSession';
end;

function  TKOLSession.CompareFirst;
begin
   Result := False;
   if c = '' then Result := True;
   if c = 'TKOLDataSource' then Result := True;
end;

procedure TKOLSession.SetupFirst;
begin
   SL.Add( Prefix + AName + ' := NewSession( Result.' + fDataSource.Name + ' );' );
end;

procedure TKOLSession.SetDataSource;
begin
   fDataSource := DS;
   Change;
end;

function  TKOLQuery.AdditionalUnits;
begin
   Result := ', OLETable, KOLEdb';
end;

function  TKOLQuery.TypeName;
begin
   Result := 'TKOLQuery';
end;

function  TKOLQuery.CompareFirst;
begin
   Result := False;
   if c = '' then Result := True;
   if c = 'TKOLDataSource' then Result := True;
   if c = 'TKOLSession' then Result := True;
end;

procedure TKOLQuery.SetupFirst;
begin
   SL.Add( Prefix + AName + ' := NewQuery( Result.' + fSession.Name + ' );' );
   if fText <> '' then begin
      SL.Add( Prefix + AName + '.Text := ''' + fText + ''';');
   end else
   if fTableName <> '' then begin
      SL.Add( Prefix + AName + '.Text := ''Select * from ' + fTableName + ''';');
   end;
end;

procedure TKOLQuery.SetSession;
begin
   fSession := SS;
   Change;
end;

procedure TKOLQuery.SetText;
begin
   fText := Tt;
   Change;
end;

function TTableNameProperty.GetAttributes: TPropertyAttributes;
begin
   Result := [paValueList, paSortList, paMultiSelect];
end;

function TTableNameProperty.GetConnection(Opened: Boolean): TADOConnection;
var
  Component: TComponent;
  Connection: string;
begin
  Result := FConnection;
  Component := (GetComponent(0) as TKOLQuery).Session.DataSource;
  Connection := TypInfo.GetStrProp(Component,
    TypInfo.GetPropInfo(Component.ClassInfo, 'Connection'));
  if Connection = '' then Exit;
  FConnection := TADOConnection.Create(nil);
  FConnection.ConnectionString := Connection;
  FConnection.LoginPrompt := False;
  Result := FConnection;
  Result.Open;
end;

procedure TTableNameProperty.GetValueList(List: TStrings);
var
  Connection: TADOConnection;
begin
  Connection := GetConnection(True);
  if Assigned(Connection) then
  try
     Connection.GetTableNames(List);
  finally
    FConnection.Free;
    FConnection := nil;
  end;
end;

procedure TTableNameProperty.GetValues;
var l: TStringList;
    i: integer;
begin
   l := TStringList.Create;
   GetValueList(l);
   for i := 0 to l.Count - 1 do
      Proc(l[i]);
   l.Free;
end;

function TTableNameProperty.AutoFill: Boolean;
var
  Connection: TADOConnection;
begin
  Connection := GetConnection(False);
  Result := Assigned(Connection) and Connection.Connected;
end;

constructor TKOLListData.Create;
begin
   inherited;
   IsListData := True;
end;

destructor  TKOLListData.Destroy;
begin
   inherited;
end;

function  TKOLListData.AdditionalUnits;
begin
   Result := ', OLETable, KOLEdb';
end;

procedure TKOLListData.SetupFirst;
begin
   inherited;
   DoRequest(True);
   if fQuery <> nil then begin
      if not fQuery.fSession.fDataSource.AQ.Active then fAutoOpen := False;
      SL.Add( Prefix + AName + '.Query := Result.' + fQuery.Name + ';');
   end;
end;

procedure TKOLListData.SetupLast;
begin
   inherited;
   if fQuery <> nil then begin
      if fAutoOpen then
      SL.Add( Prefix + AName + '.Open;' );
   end;
end;

procedure TKOLListData.AssignEvents;
begin
   inherited;
  DoAssignEvents( SL, AName,
  [ 'OnRowChanged'],
  [ @OnRowChanged ]);
end;

procedure TKOLListData.SetAutoOpen;
begin
   fAutoOpen := Value;
   Change;
end;

function  TKOLListData.GetColCount;
begin
   Result := fColCount;
end;

procedure TKOLListData.SetColCount;
var i: integer;
    n: integer;
    a: TADOQuery;
    t: TListEditColumnsItem;
    e: boolean;
begin
   if Value > 0 then begin
      fColCount := Value;
   end;
   while Columns.Count > fColCount do begin
      Columns.Delete(Columns.Count - 1);
   end;
   DoRequest(True);
   a := nil;
   if fQuery <> nil then begin
      if fQuery.fSession <> nil then begin
         if fQuery.fSession.fDataSource <> nil then begin
            a := fQuery.fSession.fDataSource.AQ;
         end;
      end;
   end;
   if a <> nil then begin
      for i := 0 to a.FieldCount - 1 do begin
         e := True;
         for n := 0 to Columns.Count - 1 do begin
            t := Columns.Items[n];
            if t.FieldName = a.Fields[i].FieldName then begin
               e := False;
               break;
            end;
         end;
         if e and (Columns.Count < fColCount) then begin
            t := TListEditColumnsItem(Columns.Add);
            t.Caption := a.Fields[i].FieldName;
            t.FieldName := a.Fields[i].FieldName;
            case a.Fields[i].DataType of
 ftString,
 ftWideString: t.Alignment := taLeftJustify;
            else
               t.Alignment := taRightJustify;
            end;
            t.Width := Canvas.TextWidth(Replicate('Q', a.Fields[i].DisplayWidth));
         end;
      end;
      UpDateColumns;
   end;
end;

procedure TKOLListData.SetOnRowChanged;
begin
   fOnRowChanged := Value;
   Change;
end;

procedure TKOLListData.DoRequest;
begin
if fQuery <> nil then begin
   if fQuery.fText <> '' then begin
      fQuery.fSession.fDataSource.AQ.SQL.Clear;
{      fQuery.fSession.fDataSource.AQ.SQL.Add(fQuery.fText);}
      fQuery.fSession.fDataSource.AQ.SQL.Add('Select * from ' + fQuery.fTableName);
      try
         fQuery.fSession.fDataSource.AQ.Open;
      except
         on E: Exception do MsgOK(E.Message);
      end;
   end else
   if fQuery.fTableName <> '' then begin
      fQuery.fSession.fDataSource.AQ.SQL.Clear;
      fQuery.fSession.fDataSource.AQ.SQL.Add('Select * from ' + fQuery.fTableName);
      try
         fQuery.fSession.fDataSource.AQ.Open;
      except
         on E: Exception do MsgOK(E.Message);
      end;
   end;
end;
end;

procedure TKOLListData.Loaded;
var i: integer;
    n: integer;
    a: TADOQuery;
    t: TListEditColumnsItem;
    e: boolean;
begin
   inherited;
   DoRequest(True);
   a := nil;
   if fQuery <> nil then begin
      if fQuery.fSession <> nil then begin
         if fQuery.fSession.fDataSource <> nil then begin
            a := fQuery.fSession.fDataSource.AQ;
         end;
      end;
   end;
   if a <> nil then begin
      Columns.FieldNames.Clear;
      for i := 0 to a.FieldCount - 1 do begin
         Columns.FieldNames.Add(a.Fields[i].FieldName);
      end;
   end;
end;

procedure TKOLListData.UpdateColumns;
var s: string;
    i: integer;
    f: string;
begin
   s := '';
   for i := 0 to Columns.Count - 1 do begin
      if Columns.Items[i].FieldName <> '' then begin
         s := s + '[' + Columns.Items[i].FieldName + ']' + ',';
      end;
   end;
   s := copy(s, 1, length(s) - 1);
   if fQuery = nil then begin
      MsgOK('Query is not defined !');
      exit;
   end;
   i := pos('FROM', UpSt(fQuery.fText));
   if i > 0 then f := copy(fQuery.fText, i + 5, length(fQuery.fText) - i - 4)
            else f := fQuery.TableName;
   if trim(s) = '' then s := '*';
   if trim(f) = '' then f := fQuery.TableName;
   fQuery.fText := 'Select ' + s + ' from ' + f;
   Change;
end;

function  TKOLQuery.GetTableName;
begin
   Result := fTableName;
end;

procedure TKOLQuery.SetTableName;
begin
   fTableName := Value;
   Change;
end;

procedure TKOLListData.SetQuery;
begin
   fQuery := Value;
   Change;
end;

procedure Register;
begin
  RegisterComponents     ('KOLData', [TKOLDataSource, TKOLSession, TKOLQuery, TKOLListData]);
  RegisterPropertyEditor (TypeInfo(WideString), TKOLDataSource,    'Connection', TTableStringProperty);
  RegisterPropertyEditor (TypeInfo(WideString), TKOLQuery,         'TableName',  TTableNameProperty);
end;

end.

