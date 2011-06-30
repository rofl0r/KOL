unit MultiDirsChange;

interface

uses Windows, KOL;

const
  MaxDirsChange = MAXIMUM_WAIT_OBJECTS;

type
  TOnDirectoryChange = procedure( Sender: PObj; const Path: String ) of object;

  PMultiDirsChange = ^TMultiDirsChange;
  TMultiDirsChange = object( TObj )
  protected
    FOnChange: TOnDirectoryChange;
    FThread: PThread;
    function GetPaths( Index: Integer ): String;
    procedure SetPaths( Index: Integer; const Value: String);
  protected
    FPaths: array[ 0..MaxDirsChange-1 ] of String;
    FHandles: array[ 0..MaxDirsChange-1 ] of THandle;
    FDelHandles: PList;
    FFilter: DWORD;
    FDeactivate: Boolean;
    procedure Init; virtual;
    function ExecuteThread( Sender: PThread ): Integer;
    procedure CloseQuied;
    procedure FolderChanged( Sender: PThread; P: Pointer );
  public
    property Paths[ Idx: Integer ]: String read GetPaths write SetPaths;
    destructor Destroy; virtual;
    function Active: Boolean;
    function PathsMonitored: Integer;
    procedure Clear;
  end;

function NewMultiDirChange( OnChange: TOnDirectoryChange; Filter: DWORD ): PMultiDirsChange;

type
  PAnyDirsChange = ^TAnyDirsChange;
  TAnyDirsChange = object( TObj )
  protected
    FDirs: PStrListEx;
    FNotifiers: PList;
    FOnChange: TOnDirectoryChange;
    FFilter: DWORD;
    function GetCount: Integer;
    function GetPaths(Idx: Integer): String;
    procedure FolderChanged( Sender: PObj; const Path: String );
    procedure Init; virtual;
  public
    destructor Destroy; virtual;
    property Paths[ Idx: Integer ]: String read GetPaths;
    property Count: Integer read GetCount;
    procedure Add( const Path: String );
    procedure Remove( const Path: String ); overload;
    procedure Remove( Idx: Integer ); overload;
    procedure Clear;
  end;

function NewAnyDirsChange( OnChange: TOnDirectoryChange; Filter: DWORD ): PAnyDirsChange;

implementation

function NewMultiDirChange( OnChange: TOnDirectoryChange; Filter: DWORD ): PMultiDirsChange;
begin
  new( Result, Create );
  Result.FOnChange := OnChange;
  if Filter = 0 then
    Filter := FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or
              FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or
              FILE_NOTIFY_CHANGE_LAST_WRITE;
  Result.FFilter := Filter;
end;

function NewAnyDirsChange( OnChange: TOnDirectoryChange; Filter: DWORD ): PAnyDirsChange;
begin
  new( Result, Create );
  Result.FOnChange := OnChange;
  if Filter = 0 then
    Filter := FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or
              FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or
              FILE_NOTIFY_CHANGE_LAST_WRITE;
  Result.FFilter := Filter;
end;

{ TMultiDirsChange }

function TMultiDirsChange.Active: Boolean;
begin
  Result := FThread <> nil;
end;

procedure TMultiDirsChange.Clear;
begin

end;

procedure TMultiDirsChange.CloseQuied;
begin
  while FDelHandles.Count > 0 do
  begin
    FindCloseChangeNotification( THandle( FDelHandles.Items[ 0 ] ) );
    FDelHandles.Delete( 0 );
  end;
end;

destructor TMultiDirsChange.Destroy;
begin
  FThread.Free;
  Clear;
  CloseQuied;
  FDelHandles.Free;
  inherited;
end;

function TMultiDirsChange.ExecuteThread( Sender: PThread ): Integer;
var WaitHandles: array[ 0..MaxDirsChange-1 ] of THandle;
    N, I: Integer;
    R: Integer;
begin
  Result := 0;
  while (PathsMonitored > 0) and (Applet <> nil) and not AppletTerminated do
  begin
    N := 0;
    for I := 0 to High( FPaths ) do
    begin
      if FHandles[ I ] <> 0 then
      begin
        WaitHandles[ N ] := FHandles[ I ];
        Inc( N );
      end;
    end;
    if N > 0 then
    begin
      R := WaitForMultipleObjects( N, @ WaitHandles[ 0 ], FALSE, 100 );
      if (R >= WAIT_OBJECT_0) and (R < WAIT_OBJECT_0 + N) then
      begin
        for I := 0 to High( FHandles ) do
          if FHandles[ I ] = WaitHandles[ R - WAIT_OBJECT_0 ] then
          begin
            if (Applet <> nil) and not AppletTerminated then
            begin
              if Assigned( FOnChange ) then
                Sender.SynchronizeEx( FolderChanged, @ I );
              FindNextChangeNotification( FHandles[ I ] );
            end
              else Exit;
            break;
          end;
      end;
    end
      else Sleep( 100 );
    CloseQuied;
  end;
end;

procedure TMultiDirsChange.FolderChanged(Sender: PThread; P: Pointer);
var I: Integer;
begin
  I := PInteger( P )^;
  if (I >= 0) and (I < MaxDirsChange) and Assigned( FOnChange ) then
    FOnChange( @ Self, FPaths[ I ] );
end;

function TMultiDirsChange.GetPaths( Index: Integer ): String;
begin
  Result := FPaths[ Index ];
end;

procedure TMultiDirsChange.Init;
begin
  FDelHandles := NewList;
end;

function TMultiDirsChange.PathsMonitored: Integer;
var I: Integer;
begin
  Result := 0;
  for I := 0 to High( FPaths ) do
    if FPaths[ I ] <> '' then Inc(Result);
end;

procedure TMultiDirsChange.SetPaths( Index: Integer; const Value: String);
begin
  FPaths[ Index ] := Value;
  if FHandles[ Index ] <> 0 then
    FDelHandles.Add( Pointer( FHandles[ Index ] ) );
  FHandles[ Index ] := 0;
  if Value <> '' then
  begin
    FHandles[ Index ] := FindFirstChangeNotification( PChar( FPaths[ Index ] ),
      FALSE, FFilter );
  end;
  if (FThread <> nil) and FThread.Terminated then
    Free_And_Nil( FThread );
  if (FThread = nil) and (PathsMonitored > 0) then
  begin
    FThread := NewThread;
    FThread.OnExecute := ExecuteThread;
    FThread.Resume;
  end;
end;

{ TAnyDirsChange }

procedure TAnyDirsChange.Add(const Path: String);
var I, J, E: Integer;
    D, D0: PMultiDirsChange;
begin
  D0 := nil;
  E := -1;
  for I := 0 to FNotifiers.Count-1 do
  begin
    D := FNotifiers.Items[ I ];
    for J := 0 to MaxDirsChange-1 do
      if AnsiEq( D.Paths[ J ], Path ) then
        Exit // не надо добавлять - уже есть такая
      else
      if (D0 = nil) and (D.Paths[ J ] = '') then
      begin
        D0 := D; E := J;
      end;
  end;
  if D0 = nil then
  begin
    E := 0;
    D0 := NewMultiDirChange( FolderChanged, FFilter );
    FNotifiers.Add( D0 );
  end;
  FDirs.AddObject( Path, DWORD( D0 ) );
  D0.Paths[ E ] := Path;
end;

function TAnyDirsChange.GetCount: Integer;
begin
  Result := FDirs.Count;
end;

function TAnyDirsChange.GetPaths(Idx: Integer): String;
begin
  Result := FDirs.Items[ Idx ];
end;

procedure TAnyDirsChange.Remove(const Path: String);
var I: Integer;
begin
  I := FDirs.IndexOf( Path );
  if I >= 0 then
    Remove( I );
end;

procedure TAnyDirsChange.Init;
begin
  FDirs := NewStrListEx;
  FNotifiers := NewList;
end;

procedure TAnyDirsChange.Remove(Idx: Integer);
var D: PMultiDirsChange;
    I: Integer;
begin
  D := Pointer( FDirs.Objects[ Idx ] );
  for I := 0 to MaxDirsChange-1 do
    if AnsiEq( D.Paths[ I ], FDirs.Items[ Idx ] ) then
    begin
      D.Paths[ I ] := '';
      break;
    end;
end;

destructor TAnyDirsChange.Destroy;
begin
  FDirs.Free;
  FNotifiers.ReleaseObjects;
  inherited;
end;

procedure TAnyDirsChange.FolderChanged(Sender: PObj; const Path: String);
var I: Integer;
    found: Boolean;
begin
  found := FALSE;
  for I := 0 to FDirs.Count-1 do
    if AnsiEq( FDirs.Items[ I ], Path ) then
    begin
      found := TRUE; break;
    end;
  if not found then Exit;
  if Assigned( FOnChange ) then
    FOnChange( @ Self, Path );
end;

procedure TAnyDirsChange.Clear;
var I: Integer;
    D: PMultiDirsChange;
begin
  for I := 0 to FNotifiers.Count-1 do
  begin
    D := FNotifiers.Items[ I ];
    D.Clear;
  end;
end;

end.
