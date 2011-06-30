unit mckMapMem;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
	StdCtrls, Dialogs, mirror, KOL;

type
	TOpenMapWhen = (omManual, omOnCreate, omOnShow, omOnActivate, omOnPaint);

        PKOLMapMem =^TKOLMapMem;
	TKOLMapMem = class(TKOLObj)
	private
		FMapName : string;
		FMapStrings : TStringList;
		FSize : DWord;
		FOpenMapWhen : TOpenMapWhen;
		FAutoSynch : Boolean;
		FOnUpdate, FOnAppListChange, FOnOpenMap, FOnCloseMap : TOnEvent;
		FOnOpenFirst, FOnCloseLast : TOnEvent;
		procedure SetMapName(Value : String);
		procedure SetMapStrings(Value : TStringList);
		procedure SetSize(Value : DWord);
		procedure SetAutoSynch(Value : Boolean);
		procedure SetOnUpdate(Value: TOnEvent);
		procedure SetOnAppListChange(Value: TOnEvent);
		procedure SetOnOpenMap(Value: TOnEvent);
		procedure SetOnCloseMap(Value: TOnEvent);
		procedure SetOnOpenFirst(Value: TOnEvent);
		procedure SetOnCloseLast(Value: TOnEvent);
                procedure SetOpenMapWhen(Value: TOpenMapWhen);
	protected
                function  AdditionalUnits: string; override;
                procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
                procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
                procedure AssignEvents( SL: TStringList; const AName: String ); override;
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		procedure Loaded; override;
	published
		property MaxSize : DWord read FSize write SetSize;
		property AutoSynchronize : Boolean read FAutoSynch write SetAutoSynch default True;
		property MapName : string read FMapName write SetMapName;
		property MapStrings : TStringList read FMapStrings write SetMapStrings;
		property OnUpdate : TOnEvent read FOnUpdate write SetOnUpdate;
		property OnAppListChange : TOnEvent read FOnAppListChange write SetOnAppListChange;
		property OnOpenMap : TOnEvent read FOnOpenMap write SetOnOpenMap;
		property OnCloseMap : TOnEvent read FOnCloseMap write SetOnCloseMap;
		property OnOpenFirst : TOnEvent read FOnOpenFirst write SetOnOpenFirst;
		property OnCloseLast : TOnEvent read FOnCloseLast write SetOnCloseLast;
		property OpenMapWhen : TOpenMapWhen read FOpenMapWhen write SetOpenMapWhen default omOnShow;
	end;

const
	FAppListSize = 2000;

procedure Register;

implementation

{$R *.dcr}

constructor TKOLMapMem.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FAutoSynch := True;
	FOpenMapWhen := omManual;
	FSize := 4096;
	FMapStrings := TStringList.Create;
        FMapName := 'KOL-Map-Mem';
end;

procedure TKOLMapMem.Loaded;
begin
	inherited Loaded;
end;

destructor TKOLMapMem.Destroy;
begin
	FMapStrings.Free;
	FMapStrings := nil;
	inherited destroy;
end;

procedure TKOLMapMem.SetMapName(Value : string);
begin
   if (FMapName <> Value) and (Length(Value) < 246) then
   begin
	FMapName := Value;
        Change;
   end;
end;

procedure TKOLMapMem.SetMapStrings(Value : TStringList);
begin
   if Value.Text <> FMapStrings.Text then
   begin
	if Length(Value.Text) <= FSize then FMapStrings.Assign(Value)
	else Raise Exception.Create('Can''t write Strings. Strings are too large!');
        Change;
   end;
end;

procedure TKOLMapMem.SetSize(Value : DWord);
var
	StringsPointer : PChar;
begin
   if (FSize <> Value) then
   begin
	StringsPointer := FMapStrings.GetText;
	if (Value < StrLen(StringsPointer) + 1) then FSize := StrLen(StringsPointer) + 1
	else FSize := Value;
	if FSize < 32 then FSize := 32;
	StrDispose(StringsPointer);
        Change;
   end;
end;

procedure TKOLMapMem.SetOnUpdate(Value: TOnEvent);
begin
   fOnUpdate := Value;
   Change;
end;

procedure TKOLMapMem.SetOnAppListChange(Value: TOnEvent);
begin
   fOnAppListChange := Value;
   Change;
end;

procedure TKOLMapMem.SetOnOpenMap(Value: TOnEvent);
begin
   fOnOpenMap := Value;
   Change;
end;

procedure TKOLMapMem.SetOnCloseMap(Value: TOnEvent);
begin
   fOnCloseMap := Value;
   Change;
end;

procedure TKOLMapMem.SetOnOpenFirst(Value: TOnEvent);
begin
   fOnOpenFirst := Value;
   Change;
end;

procedure TKOLMapMem.SetOnCloseLast(Value: TOnEvent);
begin
   fOnCloseLast := Value;
   Change;
end;

procedure TKOLMapMem.SetOpenMapWhen(Value: TOpenMapWhen);
begin
   fOpenMapWhen := Value;
   Change;
end;

procedure TKOLMapMem.SetAutoSynch(Value : Boolean);
begin
   if FAutoSynch <> Value then
   begin
	FAutoSynch := Value;
        Change;
   end;
end;

procedure TKOLMapMem.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var RName: string;
        i: integer;
begin
  SL.Add( Prefix + AName + ' := NewMapMem( Result.Form );' );
  SL.Add( Prefix + AName + '.MapName     := ''' + MapName + ''';');
  case OpenMapWhen of
  omOnActivate: RName := 'omOnActivate';
  omOnCreate: RName := 'omOnCreate';
  omOnPaint: RName := 'omOnPaint';
  omOnShow: RName := 'omOnShow';
  omManual: RName := 'omManual';
  end;
  SL.Add( Prefix + AName + '.OpenMapWhen := ' + RName + ';');
  if not FAutoSynch then
  SL.Add( Prefix + AName + '.AutoSynch   := False;');
  if FSize <> 4096 then
  SL.Add( Prefix + AName + '.Size        := ' + IntToStr(FSize) + ';');
  for i := 1 to MapStrings.Count do begin
     SL.Add( Prefix + AName + '.MapStrings.Add(''' + MapStrings[i - 1] + ''');');
  end;
  SL.Add( Prefix + AName + '.OpenMap;');
  Sl.Add( Prefix + 'if ' + AName + '.ExistsAlready then ' + AName + '.ReadMap');
  Sl.Add( Prefix + 'else ' + AName + '.WriteMap;');;
end;

procedure TKOLMapMem.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
   //
end;

function  TKOLMapMem.AdditionalUnits: string;
begin
   result := ', MapMem'
end;

procedure TKOLMapMem.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnAppListChange', 'OnCloseLast', 'OnCloseMap', 'OnOpenFirst', 'OnOpenMap', 'OnUpdate' ],
  [ @OnAppListChange , @OnCloseLast , @OnCloseMap , @OnOpenFirst , @OnOpenMap , @OnUpdate  ]);
end;

procedure Register;
begin
   RegisterComponents('KOLUtil', [TKOLMapMem]);
end;

end.

