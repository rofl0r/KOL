unit mckCPLApplet;

interface

uses mirror,mckobjs, KOLCPLApplet,Classes, Controls,Graphics,Windows, Messages,Forms, SysUtils;

type

  TAppletCollectionItem = class(TCollectionItem)
  private
    fName,fHelpFile,fTip : String;
    fIcon : TIcon;
    fData,fHelpContext : Integer;
    procedure SetIcon(const Value : TIcon);
    procedure SetName(const Value : String);
    procedure SetHelpFile(const Value : String);
    procedure SetTip(const Value : String);
    procedure SetData(const Value : Integer);
    procedure SetHelpContext(const Value : Integer);
  protected
    function GetDisplayName : String; override;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TCollection); override;
    destructor Destroy; override;
  published
    property Name : String read fName write SetName;
    property Tip : String read fTip write SetTip;
    property Data : Integer read fData write SetData;
    property HelpFile : String read fHelpFile write SetHelpFile;
    property HelpContext : Integer read fHelpContext write SetHelpContext;
    property Icon : TIcon read FIcon write SetIcon;
  end;

 TAppletCollection = class(TCollection)
  private
    FOwner : TComponent;
  protected
    function GetOwner : TPersistent; override;
    function GetItem(Index: Integer): TAppletCollectionItem;
    procedure SetItem(Index: Integer; Value:
      TAppletCollectionItem);
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner : TComponent);

    function Add : TAppletCollectionItem;
    function Insert(Index: Integer): TAppletCollectionItem;

    property Items[Index: Integer]: TAppletCollectionItem
      read GetItem
      write SetItem;
  end;




  TKOLCPLApplet = class( TKOLDataModule )
  private
    fMCKForm: String;
    fNotAvailable: boolean;
    fOnStart: TCPLStart;
    fOnInit : TCPLInit;
    fOnStop,fOnExecute,fOnSelect: TCPLSel;
    fOnParams : TCPLParams;
    fOnExit : TCPLExit;
    fAppletCollection : TAppletCollection;
    procedure SetAppletCollection(const Value : TAppletCollection);
    procedure SetOnStop(const Value: TCPLSel);
    procedure SetOnSelect(const Value: TCPLSel);
    procedure SetOnExecute(const Value: TCPLSel);
    procedure SetOnStart(const Value: TCPLStart);
    procedure SetOnInit(const Value : TCPLInit);
    procedure SetOnParams(const Value : TCPLParams);
    procedure SetOnExit(const Value : TCPLExit);
  protected
    procedure GenerateCreateForm( SL: TStringList ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function AdditionalUnits: String; override;
    function FormTypeName: String; override;
    procedure AfterGeneratePAS( SL: TStringList ); override;
    procedure GenerateRun( SL: TStringList; const AName: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure ChangeIt;
  published
    property Applets : TAppletCollection read fAppletCollection write SetAppletCollection;
    property OnStart: TCPLStart read fOnStart write SetOnStart;
    property OnExecute: TCPLSel read fOnExecute write SetOnExecute;
    property OnSelect: TCPLSel read fOnSelect write SetOnSelect;
    property OnStop: TCPLSel read fOnStop write SetOnStop;
    property OnInit: TCPLInit read fOnInit write SetOnInit;
    property OnParams: TCPLParams read fOnParams write SetOnParams;
    property OnExit: TCPLExit read fOnExit write SetOnExit;


    property Caption: Boolean read fNotAvailable;
    property EraseBkgnd: Boolean read fNotAvailable;
    property OnDestroy: Boolean read fNotAvailable;
    property OnDropFiles: Boolean read fNotAvailable;
    property OnMove: Boolean read fNotAvailable;
    property OnCreate : Boolean read fNotAvailable;
  end;

procedure Register;

implementation


var
 CPLAppletVar : TKOLCPLApplet;

{$R CPLApplet.dcr}

procedure Register;
begin
  RegisterComponents( 'KOLUtils', [ TKOLCPLApplet ] );
end;

{ TAppletCollectionItem }

constructor TAppletCollectionItem.Create(AOwner : TCollection);
begin
    inherited;
    FIcon := TIcon.Create;
end;

destructor TAppletCollectionItem.Destroy;
begin
    FIcon.Free;
    inherited;
end;

procedure TAppletCollectionItem.Assign(Source: TPersistent);
begin
  if Source is TAppletCollectionItem then
    Name := TAppletCollectionItem(Source).Name
  else
    inherited; //raises an exception
end;

function TAppletCollectionItem.GetDisplayName: String;
begin
  Result := Format('Applet no.  %d',[Index]);
end;


procedure TAppletCollectionItem.SetIcon(const Value : TIcon);
var
 RsName,RsFile : String;
 fUpdated : Boolean;
begin
if Value <> FIcon then begin
 FIcon.Assign(Value);
 RsName := UpperCase( 'cplApplet' + '_' + IntToStr(Index) );
 RsFile := 'cplApplet' + '_' + IntToStr(Index);
 GenerateIconResource(FIcon, RsName, RsFile, fUpdated );
 if fUpdated then CPLAppletVar.ChangeIt;
 end;
end;

procedure TAppletCollectionItem.SetName(const Value : String);
begin
    fName := Value;
    CPLAppletVar.ChangeIt;
end;

procedure TAppletCollectionItem.SetHelpFile(const Value : String);
begin
    fHelpFile := Value;
    CPLAppletVar.ChangeIt;
end;

procedure TAppletCollectionItem.SetTip(const Value : String);
begin
    fTip := Value;
    CPLAppletVar.ChangeIt;
end;

procedure TAppletCollectionItem.SetData(const Value : Integer);
begin
    fData := Value;
    CPLAppletVar.ChangeIt;
end;

procedure TAppletCollectionItem.SetHelpContext(const Value : Integer);
begin
    fHelpContext := Value;
    CPLAppletVar.ChangeIt;
end;


{ TAppletCollection }

constructor TAppletCollection.Create(AOwner: TComponent);
begin
  inherited Create(TAppletCollectionItem);
  FOwner := AOwner;
end;


function TAppletCollection.Add: TAppletCollectionItem;
begin
  Result := TAppletCollectionItem(inherited Add);
end;


function TAppletCollection.GetItem(Index: Integer): TAppletCollectionItem;
begin
  Result := TAppletCollectionItem(inherited GetItem(Index));
end;

function TAppletCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TAppletCollection.Insert(Index: Integer): TAppletCollectionItem;
begin
  Result := TAppletCollectionItem(inherited Insert(Index));
end;

procedure TAppletCollection.SetItem(Index: Integer; Value: TAppletCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TAppletCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;



{ TKOLApplet }

constructor TKOLCPLApplet.Create( AOwner: TComponent );
begin
    inherited;
    CPLAppletVar := Self;
    fAppletCollection := TAppletCollection.Create(Self);
end;

destructor TKOLCPLApplet.Destroy;
begin
    fAppletCollection.Free;
    CPLAppletVar := nil;
    inherited;
end;


procedure TKOLCPLApplet.SetAppletCollection(const Value: TAppletCollection);
begin
  fAppletCollection.Assign(Value);
end;

function TKOLCPLApplet.AdditionalUnits: String;
begin
  Result := ', KOLCPLApplet';
  if fMCKForm <> '' then Result := Result + ', ' + fMCKForm;
end;

procedure TKOLCPLApplet.AssignEvents(SL: TStringList; const AName: String);
begin
//
 end;

function TKOLCPLApplet.FormTypeName: String;
begin
  Result := 'PKOLCPLApplet';
end;

procedure TKOLCPLApplet.GenerateCreateForm(SL: TStringList);
begin
  SL.Add( '  Result.Form := NewCPLApplet;');
  SL.Add( '  Result.Add2AutoFree(Result.Form);');
end;

procedure TKOLCPLApplet.AfterGeneratePAS(SL: TStringList);
var i,j: integer;
begin
   i := 0;
   j := 0;
   while i < SL.count do begin
      if pos('Form:', SL[i]) > 0 then begin
         SL[i] := '    Form: PKOLCPLApplet;';
      end;
      j := pos('implementation', SL[i]) ;
      if j  > 0 then break;
      inc(i);
      end;

      if j = 0 then Exit;
      j := i;
      while i < SL.count do begin
      if (pos('function CPlApplet(',SL[i]) > 0) then Exit;
      inc(i);
      end;
         SL.Insert(j +  7, 'function CPlApplet(hWndCpl: HWnd; Msg: Word; lParam: longint; var NewCPLInfo: TNewCPLInfo): longint;stdcall;');
         SL.Insert(j +  8, 'begin');
         SL.Insert(j +  9, ' Result := KOLCPLApplet.Run(hWndCpl,Msg,lParam,NewCPLInfo);');
         SL.Insert(j +  10, 'end;');
         SL.Insert(j +  11,'');
         SL.Insert(j +  12,'exports');
         SL.Insert(j +  13,'   CPlApplet;');
         SL.Insert(j +  14,' ');
         SL.Insert(j +  15,'initialization');
         SL.Insert(j +  16,'New' + (Owner as TForm).Name + '(' +
         (Owner as TForm).Name + ',nil);');
         SL.Insert(j +  17,'finalization');
         SL.Insert(j +  18,(Owner as TForm).Name + '.Free;');
end;

procedure TKOLCPLApplet.ChangeIt;
begin
    Change(Self);
end;

procedure TKOLCPLApplet.GenerateRun(SL: TStringList; const AName: String);
begin
  //
end;


procedure TKOLCPLApplet.SetOnStop(const Value: TCPLSel);
begin
    fOnStop := Value;
    Change( Self );
end;

procedure TKOLCPLApplet.SetOnStart(const Value: TCPLStart);
begin
    fOnStart := Value;
    Change( Self );
end;

procedure TKOLCPLApplet.SetOnSelect(const Value: TCPLSel);
begin
    fOnSelect := Value;
    Change( Self );
end;

procedure TKOLCPLApplet.SetOnExecute(const Value: TCPLSel);
begin
    fOnExecute := Value;
    Change( Self );
end;


procedure TKOLCPLApplet.SetOnInit(const Value : TCPLInit);
begin
    fOnInit := Value;
    Change( Self );
end;

procedure TKOLCPLApplet.SetOnParams(const Value : TCPLParams);
begin
    fOnParams := Value;
    Change( Self );
end;

procedure TKOLCPLApplet.SetOnExit(const Value : TCPLExit);
begin
    fOnExit := Value;
    Change( Self );
end;





procedure TKOLCPLApplet.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var
    i : Integer;
    NameItem : String;
begin
  for i := 0 to fAppletCollection.Count-1 do begin
      with fAppletCollection.Items[i] do begin
           NameItem := IntToStr(i);
           if not Icon.Empty then begin
           SL.Add('{$R cplApplet_' + NameItem + '.res}');
           SL.Add( 'Result.Form.AddIcon(' + String2Pascal('cplApplet_' + NameItem) + ',' +
           String2Pascal(Name) + ',' + String2Pascal(Tip) + ',' + String2Pascal(HelpFile) + ',' + IntToStr(Data) + ',' + IntToStr(HelpContext) + ');');
           end;
      end;
  end;
end;

procedure TKOLCPLApplet.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  if @OnStart <> nil then
     SL.Add( '  Result.Form.OnStart := Result.' + (Owner as TForm).MethodName( @onStart ) + ';');
  if @OnExecute <> nil then
     SL.Add( '  Result.Form.OnExecute := Result.' + (Owner as TForm).MethodName( @onExecute ) + ';');
  if @OnSelect <> nil then
     SL.Add( '  Result.Form.OnSelect := Result.' + (Owner as TForm).MethodName( @onSelect ) + ';');
  if @OnStop <> nil then
     SL.Add( '  Result.Form.OnStop    := Result.' + (Owner as TForm).MethodName( @onStop    ) + ';');
  if @OnInit <> nil then
     SL.Add( '  Result.Form.OnInit    := Result.' + (Owner as TForm).MethodName( @onInit    ) + ';');
  if @OnParams <> nil then
     SL.Add( '  Result.Form.OnParams    := Result.' + (Owner as TForm).MethodName( @onParams    ) + ';');
  if @OnExit <> nil then
     SL.Add( '  Result.Form.OnExit    := Result.' + (Owner as TForm).MethodName( @onExit    ) + ';');
end;



end.

