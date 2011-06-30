unit MapMem;

interface

uses
    KOL, Windows, Messages, Objects;

type
	TOpenMapWhen = (omManual, omOnCreate, omOnShow, omOnActivate, omOnPaint);

        PMapMem =^TMapMem;
        TKOLMapMem = PMapMem;
	TMapMem = object(TObj)
	private
		FMapHandle, FMutexHandle, FAppListHandle : integer;
		FMapName, FSynchMessage, FApplistMessage : string;
		FMapStrings, FAppListStrings : PStrList;
		FSize, FMessageID, FApplistMessageID : longint;
		FMapPointer, FAppListPointer : PChar;
		FOpenMapWhen : TOpenMapWhen;
		FLocked, FIsMapOpen, FExistsAlready : Boolean;
		FReading, FAppListReading, FAutoSynch, HasOpened : Boolean;
		FOnUpdate, FOnAppListChange, FOnOpenMap, FOnCloseMap : TOnEvent;
		FOnOpenFirst, FOnCloseLast : TOnEvent;
		FFormHandle: integer;
		FPNewWndHandler, FPOldWndHandler: Pointer;
		FMapsOpen : integer;
		function OpenMap0(Name0, Message0 : string; var Handle0 : integer;
			var Pointer0 : PChar; Size0 : longint; var MessageID0 : longint) : Boolean;
		function GetValues(Name : string) : string;
		procedure SetValues(Name : string; const Value : string);
		procedure CloseMap0(var Handle0 : integer; var Pointer0 : PChar);
		procedure WriteMap0(Pointer0 : PChar; Strings0 : PStrList; MessageID0, Size0 : longint);
		procedure WriteAppListMap;
		procedure ReadAppListMap;
		procedure SetMapName(Value : String);
		procedure SetMapStrings(Value : PStrList);
		procedure SetSize(Value : longint);
		procedure SetAutoSynch(Value : Boolean);
		procedure EnterCriticalSection;
		procedure LeaveCriticalSection;
		procedure MapStringsChange(Sender : TObject);
		procedure AppListStringsChange(Sender : TObject);
		procedure NewWndProc(var FMessage : TMessage);
		procedure Dummy(Value : string);
	public
		destructor Destroy; virtual;
		procedure OpenMap;
		procedure CloseMap;
		procedure ReadMap;
		procedure WriteMap;
		property ExistsAlready : Boolean read FExistsAlready;
		property IsMapOpen : Boolean read FIsMapOpen;
		property AppList : PStrList read FAppListStrings;
		property MapsOpen : integer read FMapsOpen;
		property Values[Name : string] : string read GetValues write SetValues; default;
		property MaxSize : longint read FSize write SetSize;
		property AutoSynchronize : Boolean read FAutoSynch write SetAutoSynch default True;
		property MapName : string read FMapName write SetMapName;
		property MapStrings : PStrList read FMapStrings write SetMapStrings stored False;
		property OnUpdate : TOnEvent read FOnUpdate write FOnUpdate;
		property OnAppListChange : TOnEvent read FOnAppListChange	write FOnAppListChange;
		property OnOpenMap : TOnEvent read FOnOpenMap write FOnOpenMap;
		property OnCloseMap : TOnEvent read FOnCloseMap write FOnCloseMap;
		property OnOpenFirst : TOnEvent read FOnOpenFirst write FOnOpenFirst;
		property OnCloseLast : TOnEvent read FOnCloseLast write FOnCloseLast;
		property OpenMapWhen : TOpenMapWhen read FOpenMapWhen write FOpenMapWhen default omOnShow;
	end;

const
	FAppListSize = 2000;

function NewMapMem(AOwner: PControl): PMapMem;

implementation

function NewMapMem(AOwner: PControl): PMapMem;
var
	t : integer;
	TempMapName : string;
begin
        if not AOwner.HandleAllocated then AOwner.CreateWindow;
	new(result, create);
	result.FAutoSynch := True;
	result.FOpenMapWhen := omOnShow;
	result.HasOpened := False;
	result.FSize := 4096;
	result.FLocked := False;
	result.FIsMapOpen := False;
	result.FExistsAlready := False;
	result.FReading := False;
	result.FAppListReading := False;
	result.FMapStrings := NewStrList;
	result.FAppListStrings := NewStrList;
	TempMapName := 'Map-Mem-';
	for t := 0 to 10 do TempMapName := TempMapName + Chr(Random(27) + 65);
	result.SetMapName(TempMapName);
	if AOwner <> nil then
	begin
           result.FFormHandle := AOwner.Handle;
	   result.FPOldWndHandler := Ptr(GetWindowLong(result.FFormHandle, GWL_WNDPROC));
	   result.FPNewWndHandler := MakeObjectInstance(result.NewWndProc);
	   if result.FPNewWndHandler = nil then begin
              MsgOK('MapMem: Out of resources');
              Halt(1);
           end;
	   SetWindowLong(result.FFormHandle, GWL_WNDPROC, Longint(result.FPNewWndHandler));
	end
	else begin
           MsgOK('MapMem: Owner must be defined');
        end;
end;

destructor TMapMem.Destroy;
begin
	CloseMap;
	SetWindowLong(FFormHandle, GWL_WNDPROC, Longint(FPOldWndHandler));
	if FPNewWndHandler <> nil then FreeObjectInstance(FPNewWndHandler);
	FAppListStrings.Free;
	FAppListStrings := nil;
	FMapStrings.Free;
	FMapStrings := nil;
	inherited destroy;
end;

procedure CreatelpSA(var SD: SECURITY_DESCRIPTOR; var SA: _SECURITY_ATTRIBUTES);
begin
   InitializeSecurityDescriptor(
      @SD,
      SECURITY_DESCRIPTOR_REVISION);
   SetSecurityDescriptorDacl(
      @SD,
      TRUE,
      nil,
      FALSE);
   SA.nLength := SizeOf(_SECURITY_ATTRIBUTES);
   SA.lpSecurityDescriptor := @SD;
   SA.bInheritHandle := False;
end;

function TMapMem.OpenMap0(Name0, Message0 : string; var Handle0 : integer;
var Pointer0 : PChar; Size0 : longint;
var MessageID0 : longint) : Boolean;
var TempMessage : array[0..255] of Char;
    lpSD:  SECURITY_DESCRIPTOR;
    lpSA: _SECURITY_ATTRIBUTES;

begin
        CreatelpSA(lpSD, lpSA);
	Handle0 := CreateFileMapping($FFFFFFFF, @lpSA, PAGE_READWRITE or SEC_COMMIT or SEC_NOCACHE,
		0, Size0, PChar(Name0));
	if (Handle0 = INVALID_HANDLE_VALUE) or (Handle0 = 0)
		then begin
                   MsgOK('MapMem: Unable to create file mapping!')
                end
	else
	begin
		if (Handle0 <> 0) and (GetLastError = ERROR_ALREADY_EXISTS)
			then FExistsAlready := True;
		Pointer0 := MapViewOfFile(Handle0, FILE_MAP_ALL_ACCESS, 0, 0, 0);
		if Pointer0 = nil then begin
                   MsgOK('MapMem: Unable to map view of buffer!')
                end
		else
		begin
			StrPCopy(TempMessage, Message0);
			MessageID0 := RegisterWindowMessage(TempMessage);
			if MessageID0 = 0 then begin
                           MsgOK('MapMem: Could not create message!')
                        end
			else Result := True;
		end
	end;
end;

procedure TMapMem.OpenMap;
var
    lpSD:  SECURITY_DESCRIPTOR;
    lpSA: _SECURITY_ATTRIBUTES;
begin
	if (FMapHandle = 0) and (FMapPointer = nil) then
	begin
		FExistsAlready := False;
		if OpenMap0(FMapName, FSynchMessage, FMapHandle, FMapPointer, FSize, FMessageID) then
		begin
                        CreatelpSA(lpSD, lpSA);
			FMutexHandle := Windows.CreateMutex(@lpSA, False, PChar(FMapName + '.Mtx'));
			if FMutexHandle = 0 then begin
                           MsgOK('MapMem: Unable to create Mutex!');
                        end;
			if OpenMap0(FMapName + '-AppList', FApplistMessage, FAppListHandle,
				FAppListPointer, FAppListSize, FApplistMessageID) then
			begin
				FIsMapOpen := True;
				HasOpened := True;
				if FExistsAlready then ReadAppListMap
				else if Assigned(FOnOpenFirst) then FOnOpenFirst(@Self);
				FAppListStrings.Add(Int2Str(FFormHandle));
                                WriteAppListMap;
				if FExistsAlready then ReadMap
				else WriteMap;
				if Assigned(FOnOpenMap) then FOnOpenMap(@Self);
			end;
		end;
	end;
end;

procedure TMapMem.CloseMap0(var Handle0 : integer; var Pointer0 : PChar);
begin
	if Pointer0 <> nil then
	begin
		UnMapViewOfFile(Pointer0);
		Pointer0 := nil;
	end;
	if Handle0 <> 0 then
	begin
		CloseHandle(Handle0);
		Handle0 := 0;
	end;
end;

procedure TMapMem.CloseMap;
begin
	if FIsMapOpen then
	begin
		if FMutexHandle <> 0 then
		begin
			FAppListStrings.Delete(FAppListStrings.IndexOf(Int2Str(FFormHandle)));
                        WriteAppListMap;
			if (FApplistStrings.Count = 0)
				and Assigned(FOnCloseLast) then FOnCloseLast(@Self);
			CloseHandle(FMutexHandle);
			FMutexHandle := 0;
		end;
		CloseMap0(FAppListHandle, FAppListPointer);
		CloseMap0(FMapHandle, FMapPointer);
		FIsMapOpen := False;
		if Assigned(FOnCloseMap)
			then FOnCloseMap(@Self);
	end;
end;

procedure TMapMem.SetMapName(Value : string);
begin
	if (FMapName <> Value) and (FMapHandle = 0) and (Length(Value) < 246) then
	begin
		FMapName := Value;
		FSynchMessage := FMapName + '-Synch-Now';
		FAppListMessage := FMapName + '-Handles';
	end;
end;

procedure TMapMem.SetMapStrings(Value : PStrList);
begin
	if Value.Text <> FMapStrings.Text then
	begin
		if Length(Value.Text) <= FSize then FMapStrings.Assign(Value)
		else begin
                   MsgOK('MapMem: Can''t write Strings. Strings are too large!');
                end
	end;
end;

procedure TMapMem.MapStringsChange(Sender : TObject);
begin
   if FReading and Assigned(FOnUpdate) then FOnUpdate(@Self)
   else if (not FReading) and FIsMapOpen and FAutoSynch then WriteMap;
end;

procedure TMapMem.AppListStringsChange(Sender : TObject);
begin
	FMapsOpen := FAppListStrings.Count;
	if (not FAppListReading) and FIsMapOpen then WriteAppListMap;
	if Assigned(FOnAppListChange)
		then FOnAppListChange(@Self);
end;

procedure TMapMem.SetSize(Value : longint);
var
	StringsPointer : string;
begin
   if (FSize <> Value) and (FMapHandle = 0) then
   begin
	StringsPointer := FMapStrings.Text;
	if (Value < Length(StringsPointer)) then FSize := Length(StringsPointer)
	else FSize := Value;
	if FSize < 32 then FSize := 32;
   end;
end;

procedure TMapMem.SetAutoSynch(Value : Boolean);
begin
	if FAutoSynch <> Value then
	begin
		FAutoSynch := Value;
		if FAutoSynch and FIsMapOpen then WriteMap;
	end;
end;

procedure TMapMem.ReadMap;
begin
   FReading := True;
   if (FMapPointer <> nil) then begin
      FMapStrings.Clear;
      FMapStrings.SetText(FMapPointer, false);
   end;
   FReading := False;
   if assigned(OnUpdate) then OnUpdate(@self);
end;

procedure TMapMem.ReadAppListMap;
begin
   FAppListReading := True;
   if (FApplistPointer <> nil) then begin
      FAppListStrings.SetText(FApplistPointer, false);
      AppListStringsChange(@self);
   end;
   FAppListReading := False;
end;

procedure TMapMem.WriteMap0(Pointer0 : PChar; Strings0 : PStrList; MessageID0, Size0 : longint);
var
	StringsPointer : string;
	HandleCounter : integer;
	SendToHandle : HWnd;
begin
	if Pointer0 <> nil then
	begin
		StringsPointer := Strings0.Text + #0;
		EnterCriticalSection;
		if Length(StringsPointer) <= Size0
		then System.Move(StringsPointer[1], Pointer0^, Length(StringsPointer))
		else begin
                   MsgOK('MapMem: Can''t write Strings. Strings are too large!');
                end;
		LeaveCriticalSection;
		for HandleCounter := 0 to FAppListStrings.Count - 1 do
		begin
			SendToHandle := Str2Int(FAppListStrings.Items[HandleCounter]);
			if SendToHandle <> FFormHandle then PostMessage(SendToHandle,
				MessageID0,	FFormHandle, 0);
		end;
	end;
end;

procedure TMapMem.WriteMap;
begin
	WriteMap0(FMapPointer, FMapStrings, FMessageID, FSize);
end;

procedure TMapMem.WriteAppListMap;
begin
	WriteMap0(FAppListPointer, FAppListStrings, FAppListMessageID, FAppListSize);
end;

procedure TMapMem.EnterCriticalSection;
begin
	if (FMutexHandle <> 0) and not FLocked then
	begin
		FLocked := (WaitForSingleObject(FMutexHandle, INFINITE) = WAIT_OBJECT_0);
	end;
end;

procedure TMapMem.LeaveCriticalSection;
begin
	if (FMutexHandle <> 0) and FLocked then
	begin
		ReleaseMutex(FMutexHandle);
		FLocked := False;
	end;
end;

function TMapMem.GetValues(Name : string) : string;
begin
{   Result := FMapStrings.Values[Name];}
end;

procedure TMapMem.SetValues(Name : string; const Value : string);
begin
{   if Value <> FMapStrings.Values[Name] then FMapStrings.Values[Name] := Value;}
end;

procedure TMapMem.NewWndProc(var FMessage : TMessage);
begin
   with FMessage do
   begin
	case Msg of
		WM_SHOWWINDOW: if (WParam <> 0) and (FOpenMapWhen = omOnShow)
			and (not HasOpened) then OpenMap;
		WM_ACTIVATE: if (WParam <> WA_INACTIVE) and (FOpenMapWhen = omOnActivate)
			and (not HasOpened) then OpenMap;
		WM_PAINT: if (FOpenMapWhen = omOnPaint) and (not HasOpened) then OpenMap;
	end;
	if FIsMapOpen then
	begin
		if Msg = FMessageID then ReadMap
		else if Msg = FAppListMessageID then ReadAppListMap;
	end;
	Result := CallWindowProc(FPOldWndHandler,	FFormHandle, Msg, wParam, lParam);
   end;
end;

procedure TMapMem.Dummy(Value : string);
begin
   //read only
end;

end.

