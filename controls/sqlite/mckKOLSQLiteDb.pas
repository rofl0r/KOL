unit mckKOLSQLiteDb;

interface

uses
  Windows, Classes, Messages, Forms, SysUtils,
  mirror, mckCtrls,KOL,KOLSQLiteDb;

type


  TKOLSLDataSource = class(TKOLObj)
  private
    fCreate : Boolean;
    fBusyTimeout : Integer;
    fDatabase : String;
		fOnBusy : TOnBusy;
	protected
		procedure SetCreate(const Value : Boolean);
		procedure SetBusyTimeout(const Value : Integer);
		procedure SetOnBusy(const Value : TOnBusy);
		procedure SetDatabase(const Value : String);
		function  CompareFirst(c, n: string): Boolean; override;
		function  AdditionalUnits: string; override;
		procedure AssignEvents( SL: TStringList; const AName: String ); override;
		procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
	public
		constructor Create(AOwner: TComponent); override;
		function TypeName: String; override;
	published
		property Database : String read fDatabase write SetDatabase;
		property CreateDatabase : Boolean read fCreate write SetCreate default false;
		property BusyTimeout : Integer read fBusyTimeout write SetBusyTimeout;
		property OnBusy : TOnBusy read fOnBusy write SetOnBusy;
	end;


	TKOLSLSession = class(TKOLObj)
	private
	Warn : Boolean;
	fDataSource : TKOLSLDataSource;
	fIfConflict : TConflict;
	protected
		procedure SetIfConflict(const Value : TConflict);
		procedure SetDataSource(const Value: TKOLSLDataSource);
		function  CompareFirst(c, n: string): Boolean; override;
		function  AdditionalUnits: string; override;
		procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
		procedure Notification(AComponent: TComponent;Operation: TOperation); override;
	public
		constructor Create(AOwner: TComponent); override;
		function TypeName: String; override;
	published
		property  DataSource: TKOLSLDataSource read fDataSource write SetDataSource;
		property  IfConflict : TConflict read fIfConflict write SetIfConflict;
	end;



	TKOLSLQuery = class(TKOLObj)
	private
		Warn : Boolean;
		fSession: TKOLSLSession;
		fOnData : TOnQueryData;
		fOnComplete : TOnEvent;
		fSQL : TStrings;
	protected
		procedure SetSession(const Value: TKOLSLSession);
		procedure SetOnComplete(const Value : TOnEvent);
		procedure SetOnData(const Value : TOnQueryData);
		procedure SetSQL(const Value : TStrings);
		function  CompareFirst(c, n: string): Boolean; override;
		function  AdditionalUnits: string; override;
		procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
		procedure AssignEvents( SL: TStringList; const AName: String ); override;
		procedure Notification(AComponent: TComponent;Operation: TOperation); override;
	public
		constructor Create(AOwner: TComponent); override;
		function TypeName: String; override;
		destructor Destroy;override;
	published
		property  Session: TKOLSLSession read fSession write SetSession;
		property  SQL : TStrings read fSQL write SetSQL;
		property  OnComplete : TOnEvent read fOnComplete write SetOnComplete;
		property  OnData : TOnQueryData read fOnData write SetOnData;
	end;


	procedure Register;

implementation

{$R *.dcr}

constructor TKOLSLDataSource.Create;
begin
	 inherited;
	 fDatabase := '';
	 fBusyTimeout := 0;
	 fCreate := false;
end;


function TKOLSLDataSource.TypeName;
begin
	Result := 'SLDataSource';
end;

function  TKOLSLDataSource.CompareFirst;
begin
	Result := false;
	if c='' then Result := true;
end;


function  TKOLSLDataSource.AdditionalUnits;
begin
	 Result := ', KOLSQLiteDb';
end;

procedure TKOLSLDataSource.SetupFirst;
begin
	 if fCreate = true then
	 SL.Add( Prefix + AName + ' := NewSLDataSource(''' + fDatabase + ''', True);' )
	 else
	 SL.Add( Prefix + AName + ' := NewSLDataSource(''' + fDatabase + ''', False);' );
	 if fBusyTimeout <> 0 then SL.Add( Prefix + AName + '.BusyTimeout := ' + Int2Str(fBusyTimeout) + ';');
end;


procedure TKOLSLDataSource.AssignEvents;
begin
  inherited;
	DoAssignEvents( SL, AName,[ 'OnBusy'],[ @OnBusy ]);
end;

procedure TKOLSLDataSource.SetBusyTimeout;
begin
  if Value <> fBusyTimeout then begin
    fBusyTimeout := Value;
    Change;
  end;
end;

procedure TKOLSLDataSource.SetCreate;
begin
  if Value <> fCreate then begin
    fCreate := Value;
		Change;
  end;
end;

procedure TKOLSLDataSource.SetOnBusy;
begin
	if @Value <> @fOnBusy then begin
    fOnBusy := Value;
		Change;
  end;
end;

procedure TKOLSLDataSource.SetDatabase;
begin
  if Value <> fDatabase then begin
    fDatabase := Value;
    Change;
  end;
end;

constructor TKOLSLSession.Create;
begin
	 inherited;
	 NeedFree := false;
	 fIfConflict := cfAbort;
end;


function  TKOLSLSession.TypeName;
begin
	Result := 'SLSession';
end;

function  TKOLSLSession.CompareFirst;
begin
	Result := false;
	if c = '' then Result := true;
	if c = 'SLDataSource' then Result := true;
end;


function  TKOLSLSession.AdditionalUnits;
begin
	 Result := ', KOLSQLiteDb';
end;

procedure TKOLSLSession.SetupFirst;
const
IfConflict2Str:array [TConflict] of String= ('cfRollback','cfAbort','cfFail','cfIgnore','cfReplace');
begin
	 if Assigned(fDataSource) then
		 SL.Add( Prefix + AName + ' := NewSLSession(' + String2PascalStrExpr(Self.Name) +  ',Result.' + fDataSource.Name + ');' )
	 else
		 begin
			SL.Add( Prefix + AName + ' := NewSLSession(' + String2PascalStrExpr(Self.Name) +  ',nil);' );
			if not Warn then begin
				MessageBox(0,PChar(Self.Name + ' has no parent TSLDataSource!. This surely leads application to crash!'),'Warning!',mb_iconexclamation);
				Warn := true;
			end;
		 end;
	 if fIfConflict <> cfAbort then  SL.Add( Prefix + AName + '.IfConflict := ' + IfConflict2Str[fIfConflict] + ';');
end;



procedure TKOLSLSession.SetDataSource;
begin
	if Value <> fDataSource then begin
		if Assigned(fDataSource) then fDataSource.RemoveFreeNotification(Self);
		fDataSource := Value;
		Change;
		if Assigned(fDataSource) then fDataSource.FreeNotification(Self);
	end;
end;



procedure TKOLSLSession.SetIfConflict;
begin
	if Value <> fIfConflict then begin
		fIfConflict := Value;
		Change;
	end;
end;


procedure TKOLSLSession.Notification;
begin
	if (Operation = opRemove) and (AComponent = DataSource) then fDataSource := nil;
end;

constructor TKOLSLQuery.Create;
begin
	inherited;
	NeedFree := false;
	fSQL := TStringList.Create;
end;


function  TKOLSLQuery.TypeName;
begin
	Result := 'SLQuery';
end;

function  TKOLSLQuery.CompareFirst;
begin
	Result := false;
	if c = '' then Result := true;
	if c = 'SLDataSource' then Result := true;
	if c = 'SLSession' then Result := true;
end;

function  TKOLSLQuery.AdditionalUnits;
begin
	 Result := ', KOLSQLiteDb';
end;



procedure TKOLSLQuery.AssignEvents;
begin
	inherited;
  DoAssignEvents( SL, AName,[ 'OnData','OnComplete'],[ @OnData,@OnComplete ]);
end;

procedure TKOLSLQuery.SetupFirst;
var
 i : Integer;
begin
	 if Assigned(fSession) then SL.Add( Prefix + AName + ' := NewSLQuery( Result.' + fSession.Name + ' );' )
   else
    begin
      SL.Add( Prefix + AName + ' := NewSLQuery(nil);' );
      if not Warn then begin
				MessageBox(0,PChar(Self.Name + ' has no parent TSLSession!. This surely leads application to crash!'),'Warning!',mb_iconexclamation);
        Warn := true;
      end;
    end;
    for i:=0 to fSQL.Count-1 do begin
      SL.Add( Prefix + AName + '.SQL.Add(' + String2PascalStrExpr(fSQL.Strings[i]) + ');');
    end;
end;



procedure TKOLSLQuery.SetSession;
begin
  if Value <> fSession then begin
    if Assigned(fSession) then fSession.RemoveFreeNotification(Self);
    fSession := Value;
		Change;
    if Assigned(fSession) then fSession.FreeNotification(Self);
  end;
end;

procedure TKOLSLQuery.SetOnComplete(const Value : TOnEvent);
begin
  if @Value <> @fOnComplete then begin
    fOnComplete := Value;
    Change;
  end;
end;

procedure TKOLSLQuery.SetOnData(const Value : TOnQueryData);
begin
  if @Value <> @fOnData then begin
    fOnData := Value;
    Change;
  end;
end;



procedure TKOLSLQuery.Notification;
begin
	if (Operation = opRemove) and (AComponent = Session) then fSession := nil;
end;

procedure TKOLSLQuery.SetSQL;
begin
	fSQL.Assign(Value);
	Change;
end;


destructor TKOLSLQuery.Destroy;
begin
  fSQL.Free;
  inherited;
end;





procedure Register;
begin
  RegisterComponents     ('KOLSQLiteData', [TKOLSLDataSource,TKOLSLSession,TKOLSLQuery]);
end;

end.

