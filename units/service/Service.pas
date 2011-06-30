unit Service;
{* This unit contains definitions of TService and TServiceCtl objects intended
   to create Windows NT services using Delphi + KOL. }

interface

uses
  Windows, KOL, WinSVC, Messages;

const
  SERVICE_CONTROL_STOP           = $00000001;
  SERVICE_CONTROL_PAUSE          = $00000002;
  SERVICE_CONTROL_CONTINUE       = $00000003;
  SERVICE_CONTROL_INTERROGATE    = $00000004;
  SERVICE_CONTROL_SHUTDOWN       = $00000005;

  SERVICE_NO_CHANGE              = $FFFFFFFF;

  // Service State -- for Enum Requests (Bit Mask)
  SERVICE_ACTIVE                 = $00000001;
  SERVICE_INACTIVE               = $00000002;
  SERVICE_STATE_ALL              = (SERVICE_ACTIVE   or
                                    SERVICE_INACTIVE);
  SERVICE_STOPPED                = $00000001;
  SERVICE_START_PENDING          = $00000002;
  SERVICE_STOP_PENDING           = $00000003;
  SERVICE_RUNNING                = $00000004;
  SERVICE_CONTINUE_PENDING       = $00000005;
  SERVICE_PAUSE_PENDING          = $00000006;
  SERVICE_PAUSED                 = $00000007;

  // Controls Accepted  (Bit Mask)
  SERVICE_ACCEPT_STOP            = $00000001;
  SERVICE_ACCEPT_PAUSE_CONTINUE  = $00000002;
  SERVICE_ACCEPT_SHUTDOWN        = $00000004;

//
// Service Control Manager object specific access types
//
  SC_MANAGER_CONNECT             = $0001;
  SC_MANAGER_CREATE_SERVICE      = $0002;
  SC_MANAGER_ENUMERATE_SERVICE   = $0004;
  SC_MANAGER_LOCK                = $0008;
  SC_MANAGER_QUERY_LOCK_STATUS   = $0010;
  SC_MANAGER_MODIFY_BOOT_CONFIG  = $0020;

  SC_MANAGER_ALL_ACCESS          = (STANDARD_RIGHTS_REQUIRED or
                                    SC_MANAGER_CONNECT or
                                    SC_MANAGER_CREATE_SERVICE or
                                    SC_MANAGER_ENUMERATE_SERVICE or
                                    SC_MANAGER_LOCK or
                                    SC_MANAGER_QUERY_LOCK_STATUS or
                                    SC_MANAGER_MODIFY_BOOT_CONFIG);

  // Service object specific access type
  SERVICE_QUERY_CONFIG           = $0001;
  SERVICE_CHANGE_CONFIG          = $0002;
  SERVICE_QUERY_STATUS           = $0004;
  SERVICE_ENUMERATE_DEPENDENTS   = $0008;
  SERVICE_START                  = $0010;
  SERVICE_STOP                   = $0020;
  SERVICE_PAUSE_CONTINUE         = $0040;
  SERVICE_INTERROGATE            = $0080;
  SERVICE_USER_DEFINED_CONTROL   = $0100;
  SERVICE_ALL_ACCESS             = (STANDARD_RIGHTS_REQUIRED or
                                    SERVICE_QUERY_CONFIG or
                                    SERVICE_CHANGE_CONFIG or
                                    SERVICE_QUERY_STATUS or
                                    SERVICE_ENUMERATE_DEPENDENTS or
                                    SERVICE_START or
                                    SERVICE_STOP or
                                    SERVICE_PAUSE_CONTINUE or
                                    SERVICE_INTERROGATE or
                                    SERVICE_USER_DEFINED_CONTROL);


  // Service Types (Bit Mask)
  SERVICE_KERNEL_DRIVER         = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER    = $00000002;
  SERVICE_ADAPTER               = $00000004;
  SERVICE_RECOGNIZER_DRIVER     = $00000008;

  SERVICE_DRIVER                = (SERVICE_KERNEL_DRIVER or
                                   SERVICE_FILE_SYSTEM_DRIVER or
                                   SERVICE_RECOGNIZER_DRIVER);

  SERVICE_WIN32_OWN_PROCESS     = $00000010;
  SERVICE_WIN32_SHARE_PROCESS   = $00000020;
  SERVICE_WIN32                 = (SERVICE_WIN32_OWN_PROCESS or
                                   SERVICE_WIN32_SHARE_PROCESS);

  SERVICE_INTERACTIVE_PROCESS   = $00000100;

  SERVICE_TYPE_ALL              = (SERVICE_WIN32 or
                                  SERVICE_ADAPTER or
                                  SERVICE_DRIVER or
                                  SERVICE_INTERACTIVE_PROCESS);

  // Start Type
  SERVICE_BOOT_START            = $00000000;
  SERVICE_SYSTEM_START          = $00000001;
  SERVICE_AUTO_START            = $00000002;
  SERVICE_DEMAND_START          = $00000003;
  SERVICE_DISABLED              = $00000004;

  // Error control type
  SERVICE_ERROR_IGNORE          = $00000000;
  SERVICE_ERROR_NORMAL          = $00000001;
  SERVICE_ERROR_SEVERE          = $00000002;
  SERVICE_ERROR_CRITICAL        = $00000003;

  CM_SERVICE_CONTROL_CODE       = WM_USER + 1000;

type

  TKOLService = Pointer;
  TKOLServiceEx = Pointer;

  TServiceStatus = WinSVC.TServiceStatus;

  PServiceCtl = ^TServiceCtl;
  TServiceCtl = object( TObj )
  {* TServiceCtl object is intended to create new service or to maintain existing
     service. To provide service itself, use TService object. }
  private
    FSCHandle: THandle;
    FHandle: THandle;
    //FTag: DWORD;
    FStatus: TServiceStatus;
    function GetStatus: TServiceStatus;
  protected
  public
    destructor Destroy; virtual;
    property SCHandle: THandle read FSCHandle;
    {* Handle of SC manager. }
    property Handle: THandle read FHandle;
    {* Handle of service opened or created. }
    property Status: TServiceStatus read GetStatus;
    {* Current status of the service. }
    function Stop: Boolean;
    {* }
    function Pause: Boolean;
    {* }
    function Resume: Boolean;
    {* }
    function Refresh: Boolean;
    {* }
    function Shutdown: Boolean;
    {* }
    function Delete: Boolean;
    {* Removes service from the system. }
    function Start( const Args: array of PChar ): Boolean;
    {* }
  end;

function NewServiceCtl( const TargetComputer, DatabaseName, Name, DisplayName, Path,
                     OrderGroup, Dependances, Username, Password: String;
         DesiredAccess, ServiceType, StartType, ErrorControl: DWORD ): PServiceCtl;
{* Creates new service and allows to control it and/or its configuration.
   Parameters:
   |<br>
   TargetComputer - set it to empty string if local computer is the target.
   |<br>
   DatabaseName - set it to empty string if the default database is supposed
                ( 'ServicesActive' ).
   |<br>
   Name - name of a service.
   |<br>
   DisplayName - display name of a service.
   |<br>
   Path - a path to binary (executable) of the service created.
   |<br>
   OrderGroup - an order group name (unnecessary)
   |<br>
   Dependances - string containing a list with names of services, which must
               start before (every name should be separated with #0, entire
               list should be separated with #0#0. Or, an empty string can be
               passed if there are no dependances).
   |<br>
   Username - login name. For service type SERVICE_WIN32_OWN_PROCESS, the
            account name in the form of "DomainName\Username"; If the account
            belongs to the built-in domain, ".\Username" can be specified;
            Services of type SERVICE_WIN32_SHARE_PROCESS are not allowed to
            specify an account other than LocalSystem. If '' is specified, the
            service will be logged on as the 'LocalSystem' account, in which
            case, the Password parameter must be empty too.
   |<br>
   Password - a password for login name. If the service type is
            SERVICE_KERNEL_DRIVER or SERVICE_FILE_SYSTEM_DRIVER,
            this parameter is ignored.
   |<br>
   DesiredAccess - a combination of following flags:
     SERVICE_ALL_ACCESS
     SERVICE_CHANGE_CONFIG
     SERVICE_ENUMERATE_DEPENDENTS
     SERVICE_INTERROGATE
     SERVICE_PAUSE_CONTINUE
     SERVICE_QUERY_CONFIG
     SERVICE_QUERY_STATUS
     SERVICE_START
     SERVICE_STOP
     SERVICE_USER_DEFINED_CONTROL
    |<br>
    ServiceType - a set of following flags:
      SERVICE_WIN32_OWN_PROCESS
      SERVICE_WIN32_SHARE_PROCESS
      SERVICE_KERNEL_DRIVER
      SERVICE_FILE_SYSTEM_DRIVER
      SERVICE_INTERACTIVE_PROCESS
    |<br>
    StartType - one of following values:
      SERVICE_BOOT_START
      SERVICE_SYSTEM_START
      SERVICE_AUTO_START
      SERVICE_DEMAND_START
      SERVICE_DISABLED
    |<br>
    ErrorControl - one of following:
      SERVICE_ERROR_IGNORE
      SERVICE_ERROR_NORMAL
      SERVICE_ERROR_SEVERE
      SERVICE_ERROR_CRITICAL
}

function OpenServiceCtl( const TargetComputer, DataBaseName, Name: String;
                      DesiredAccess: DWORD ): PServiceCtl;
{* Opens existing service to control it or its configuration from your
   application.
   |<br>Parameters:
   |<br>
   TargetComputer - set it to empty string if local computer is the target.
   |<br>
   DatabaseName - set it to empty string if the default database is supposed
                ( 'ServicesActive' ).
   |<br>
   Name - name of a service.
   |<br>
   DesiredAccess - a combination of following flags:
     SERVICE_ALL_ACCESS
     SERVICE_CHANGE_CONFIG
     SERVICE_ENUMERATE_DEPENDENTS
     SERVICE_INTERROGATE
     SERVICE_PAUSE_CONTINUE
     SERVICE_QUERY_CONFIG
     SERVICE_QUERY_STATUS
     SERVICE_START
     SERVICE_STOP
     SERVICE_USER_DEFINED_CONTROL
    |<br>
}

type
  PService = ^TService;

  TControlProc = procedure( Sender: PService; Code: DWORD ) of object;
  {* }
  TServiceProc = procedure( Sender: PService ) of object;
  {* }

  TService = object( TObj )
  {* TService is the object to represent service provided by the application
     itself. When service application is started, it should create necessary
     number of TService object instances and then call InstallServices
     function with a list of pointers to services created. }
  private
    fSName: String;
    fDName: String;
    fParam: String;
    fServiceType,
    fStartType: dword;
    fStatusHandle: THandle;
    fStatusRec: TServiceStatus;
    fJumper: Pointer;
    fOnStart: TServiceProc;
    fOnExecute: TServiceProc;
    fOnControl: TControlProc;
    fOnPause: TServiceProc;
    fOnResume: TServiceProc;
    fOnStop: TServiceProc;
    fOnInterrogate: TServiceProc;
    fOnShutdown: TServiceProc;
    fArgsList: PStrList;
    fData: DWORD;
    fControl: DWORD;
    function GetArgCount: Integer;
    function GetArgs(Idx: Integer): String;
    procedure SetStatus(const Value: TServiceStatus);
    procedure DoCtrlHandle( Code: DWORD ); virtual;
    function GetInstalled: boolean;
  protected
    procedure Execute; virtual;
    procedure CtrlHandle( Code: DWORD );
  public
    destructor Destroy; virtual;
    function ReportStatus( dwState, dwExitCode, dwWait:DWORD ):BOOL;
    {* Reports new status to the system. }
    procedure Install;
    {* Installs service in the database *}
    procedure Remove;
    {* Removes service from database *}
    procedure Start;
    {* Starts service *}
    procedure Stop;
    {* Stops service *}
    property ServiceName: String read fSName;
    {* Name of the service. Must be unique. }
    property DisplayName: String read fDName write fDName;
    {* Display name of the service *}
    property Param: String read fParam write fParam;
    {* Parameters for service *}
    property ServiceType: dword read fServiceType write fServiceType;
    {* Type of service *}
    property StartType: dword read fStartType write fStartType;
    {* Type of start of service *}
    property ArgCount: Integer read GetArgCount;
    {* Number of arguments passed to the service. }
    property Args[ Idx: Integer ]: String read GetArgs;
    {* Listof arguments passed. }
    property Status: TServiceStatus read FStatusRec write SetStatus;
    {* Current status. To report new status to the system, assign another
       value to this record, or use ReportStatus method (better). }
    property Accepted: DWORD read fControl write fControl;
    {* Set of control codes the service will accept }
    property Data: DWORD read FData write FData;
    {* Any data You wish to associate with the service object. }
    property Installed: boolean read GetInstalled;
    {* Whether service is installed in DataBase *}
    property OnStart: TServiceProc read fOnStart write fOnStart;
    {* Start event is executed befor main service thread *}
    property OnExecute: TServiceProc read fOnExecute write fOnExecute;
    {* Execute event. }
    property OnControl: TControlProc read fOnControl write fOnControl;
    {* Control handler event. *}
    property OnStop: TServiceProc read fOnStop write fOnStop;
    {* Stop service event. }
    property OnPause: TServiceProc read fOnPause write fOnPause;
    {* Pause service event. *}
    property OnResume: TServiceProc read fOnResume write fOnResume;
    {* Resume service event *}
    property OnInterrogate: TServiceProc read fOnInterrogate write fOnInterrogate;
    {* Interrogate service event. *}
    property OnShutdown: TServiceProc read fOnShutdown write fOnShutdown;
    {* Shutdown service event. *}
  end;

  PServiceEx =^TServiceEx;
  TServiceEx = object(TService)
    fSThread: PThread;
    fAThread: PThread;
    fMThread: PThread;
    fOnApplRun: TServiceProc;
    procedure DoCtrlHandle( Code: DWORD ); virtual;
    function ThreadExecute(Sender: PThread): Integer;
    function ApplicExecute(Sender: PThread): Integer;
    function MessagExecute(Sender: PThread): integer;
  protected
    procedure Execute; virtual;
  public
    destructor Destroy; virtual;
    property OnApplicationRun: TServiceProc read fOnApplRun write fOnApplRun;
    {* Execute application procedure *}
  end;

function NewService( const _SName: String;
                     const _DName: String) : PService;

{* Creates the service. *}

function NewServiceEx( const _SName: String;
                       const _DName: String) : PServiceEx;

{* Creates the serviceEX. *}

function GetServiceList(sn, sd: PStrList): boolean;

procedure run;
{* Call this function to pass a list of services provided by the application to
   the operating system. }

implementation

function Str2PChar( const S: String ): PChar;
begin
  Result := nil;
  if StrComp( PChar( S ), '' ) <> 0 then
    Result := PChar( S );
end;

{--- TServiceCtl ---}

function _NewServiceCtl( const TargetComputer, DatabaseName: String;
         Access: DWORD ): PServiceCtl;
begin
  new( Result, Create );
  Result.FSCHandle := OpenSCManager( Str2PChar( TargetComputer ), Str2PChar( DatabaseName ),
                    Access );
end;

function NewServiceCtl( const TargetComputer, DatabaseName, Name, DisplayName, Path,
                     OrderGroup, Dependances, Username, Password: String;
                     DesiredAccess, ServiceType, StartType, ErrorControl: DWORD ): PServiceCtl;
begin
  Result := _NewServiceCtl( TargetComputer, DatabaseName, SC_MANAGER_ALL_ACCESS );
  if Result.FSCHandle = 0 then Exit;
  Result.FHandle := CreateService( Result.FSCHandle, Str2PChar( Name ), Str2PChar( DisplayName ),
                 DesiredAccess, ServiceType, StartType, ErrorControl, PChar( Path ),
                 Str2PChar( OrderGroup ), nil, Str2PChar( Dependances ),
                 Str2PChar( Username ), Str2PChar( Password ) );
end;

function OpenServiceCtl( const TargetComputer, DataBaseName, Name: String;
                      DesiredAccess: DWORD ): PServiceCtl;
begin
  Result := _NewServiceCtl( TargetComputer, DataBaseName, SC_MANAGER_ALL_ACCESS );
  if Result.FSCHandle = 0 then Exit;
  Result.FHandle := WinSvc.OpenService( Result.FSCHandle, PChar( Name ), DesiredAccess );
end;

{ TServiceCtl }

function TServiceCtl.Delete: Boolean;
begin
  Result := FALSE;
  if FHandle <> 0 then
  begin
    if DeleteService( FHandle ) then
    begin
      Result := CloseServiceHandle( FHandle );
      FHandle := 0;
    end;
  end;
end;

destructor TServiceCtl.Destroy;
begin
  if FHandle <> 0 then
    CloseServiceHandle( FHandle );
  if FSCHandle <> 0 then
    CloseServiceHandle( FSCHandle );
  inherited;
end;

function TServiceCtl.GetStatus: TServiceStatus;
begin
  FillChar( FStatus, Sizeof( FStatus ), 0 );
  QueryServiceStatus( FHandle, FStatus );
  Result := FStatus;
end;

function TServiceCtl.Pause: Boolean;
begin
  Result := ControlService( FHandle, SERVICE_CONTROL_PAUSE, FStatus );
end;

function TServiceCtl.Refresh: Boolean;
begin
  Result := ControlService( FHandle, SERVICE_CONTROL_INTERROGATE, FStatus );
end;

function TServiceCtl.Resume: Boolean;
begin
  Result := ControlService( FHandle, SERVICE_CONTROL_CONTINUE, FStatus );
end;

function TServiceCtl.Shutdown: Boolean;
begin
  Result := ControlService( FHandle, SERVICE_CONTROL_SHUTDOWN, FStatus );
end;

function StartService(hService: SC_HANDLE; dwNumServiceArgs: DWORD;
  {var} lpServiceArgVectors: Pointer ): BOOL; stdcall;
external advapi32 name 'StartServiceA';

function TServiceCtl.Start(const Args: array of PChar): Boolean;
begin
  Result := StartService( FHandle, High( Args ) + 1, @Args[ 0 ] );
end;

function TServiceCtl.Stop: Boolean;
begin
  Result := ControlService( FHandle, SERVICE_CONTROL_STOP, FStatus );
end;

{--- TService ---}

var Services: PList;

function ServiceName2Idx( const Name: String ): Integer;
var I: Integer;
    Srv: PService;
begin
  assert( Services <> nil, 'Services are not created yet - nothing to search for.' );
  if Services <> nil then
  for I := 0 to services.Count - 1 do
  begin
    Srv := Services.Items[ I ];
    if Srv.fSName = Name then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure JumpToService;
asm
          POP     EAX
          MOV     EAX, [EAX]
          MOV     EDX, [ESP+4]
          CALL    TService.CtrlHandle
          RET     4
end;

type
  PPChar = ^PChar;

procedure ServiceProc( ArgCount: DWORD; Args: PPChar ); stdcall;
var I: Integer;
    Srv: PService;
begin
  I := ServiceName2Idx( Args^ );
  Srv := Services.Items[ I ];
  for I := 1 to ArgCount - 1 do
  begin
    Inc( Args );
    Srv.FArgsList.Add( Args^ );
  end;
  Srv.FStatusHandle := RegisterServiceCtrlHandler( PChar( Srv.fSName ), Srv.FJumper );
  if Srv.FStatusHandle = 0 then
  begin
    Srv.ReportStatus( SERVICE_STOPPED, GetLastError, 0 );
    Exit;
  end;
  Srv.ReportStatus( SERVICE_START_PENDING, 0, 0 );
  Srv.Execute;
{  Srv.ReportStatus( SERVICE_STOPPED, 0, 0 );}
end;

function CheckUniqueServiceName( const Name: String ): Boolean;
var I: Integer;
begin
  Result := TRUE;
  if Services = nil then Exit;
  I := ServiceName2Idx( Name );
  if I < 0 then Exit;
  Result := FALSE;
end;

function NewService( const _SName: String;
                     const _DName: String) : PService;
var JumperAddr: Pointer;
    AfterCallAddr: Pointer;
    Offset: Integer;
begin
  assert( CheckUniqueServiceName( _SName ),  PChar( 'Attempt to install a service ' +
          'with duplicated name: ' + _SName ) );
  new( Result, Create );
  Result.fSName := _SName;
  Result.fDName := _DName;
  if _DName = '' then Result.fDName := _SName;
  if Services = nil then Services := NewList;
  Services.Add( Result );
  Result.FArgsList := NewStrList;
  Result.fServiceType := SERVICE_WIN32_OWN_PROCESS or
                         SERVICE_INTERACTIVE_PROCESS;
  Result.fStartType   := SERVICE_AUTO_START;

  Result.FStatusRec.dwServiceType := Result.fServiceType;
  Result.FStatusRec.dwCurrentState := SERVICE_STOPPED;
  Result.FStatusRec.dwControlsAccepted := fControl;
  Result.FStatusRec.dwWin32ExitCode := NO_ERROR;

  Result.FJumper := VirtualAlloc( nil, 9, MEM_COMMIT, PAGE_EXECUTE_READWRITE );

  assert( Result.FJumper <> nil, PChar( 'Cannot allocate memory for service jump gate: ' +
                                        _SName ) );
  JumperAddr := @JumpToService;
  AfterCallAddr := Pointer( Integer( Result.FJumper ) + 5 );
  Offset :=  Integer( JumperAddr ) - Integer( AfterCallAddr );
  PByte   ( Pointer( Integer( Result.FJumper ) + 0 ) )^ := $E8; // call
  PInteger( Pointer( Integer( Result.FJumper ) + 1 ) )^ := Offset;
  PDWord  ( Pointer( Integer( Result.FJumper ) + 5 ) )^ := DWORD( Result );
end;

function NewServiceEx( const _SName: String;
                       const _DName: String) : PServiceEx;
var JumperAddr: Pointer;
    AfterCallAddr: Pointer;
    Offset: Integer;
begin
  assert( CheckUniqueServiceName( _SName ),  PChar( 'Attempt to install a service ' +
          'with duplicated name: ' + _SName ) );

  new( Result, Create );
  if Services = nil then Services := NewList;
  Services.Add( Result );

  Result.fSName := _SName;
  Result.fDName := _DName;
  if _DName = '' then Result.fDName := _SName;
  Result.FArgsList := NewStrList;
  Result.fSThread := NewThread;
  Result.fSThread.OnExecute := Result.ThreadExecute;
  Result.fAThread := NewThread;
  Result.fAThread.OnExecute := Result.ApplicExecute;
  Result.fMThread := NewThread;
  Result.fMThread.OnExecute := Result.MessagExecute;

  Result.fServiceType := SERVICE_WIN32_OWN_PROCESS or
                         SERVICE_INTERACTIVE_PROCESS;

  Result.fStartType   := SERVICE_AUTO_START;

  Result.FStatusRec.dwServiceType := Result.fServiceType;
  Result.FStatusRec.dwCurrentState := SERVICE_STOPPED;
  Result.FStatusRec.dwControlsAccepted := fControl;
  Result.FStatusRec.dwWin32ExitCode := NO_ERROR;

  Result.FJumper := VirtualAlloc( nil, 9, MEM_COMMIT, PAGE_EXECUTE_READWRITE );

  assert( Result.FJumper <> nil, PChar( 'Cannot allocate memory for service jump gate: ' +
                                        _SName ) );
  JumperAddr := @JumpToService;
  AfterCallAddr := Pointer( Integer( Result.FJumper ) + 5 );
  Offset :=  Integer( JumperAddr ) - Integer( AfterCallAddr );
  PByte   ( Pointer( Integer( Result.FJumper ) + 0 ) )^ := $E8; // call
  PInteger( Pointer( Integer( Result.FJumper ) + 1 ) )^ := Offset;
  PDWord  ( Pointer( Integer( Result.FJumper ) + 5 ) )^ := DWORD( Result );
end;

procedure run;
var STA,
    NTA: PServiceTableEntry;
    Srv: PService;
    I  : Integer;
begin
  GetMem( STA, (Services.Count + 1) * Sizeof( TServiceTableEntry ) );
  NTA := STA;
  for I := 0 to Services.Count - 1 do
  begin
    Srv := Services.Items[i];
    NTA.lpServiceName := PChar( Srv.ServiceName );
    NTA.lpServiceProc := @ServiceProc;
    Inc( NTA );
  end;
  NTA.lpServiceName := nil;
  NTA.lpServiceProc := nil;
  StartServiceCtrlDispatcher( STA^ );
  FreeMem( STA );
end;

{ TService }

procedure TService.DoCtrlHandle(Code: DWORD);
begin
   case Code of
SERVICE_CONTROL_STOP:
      begin
         ReportStatus( SERVICE_STOP_PENDING, NO_ERROR, 0 );
         if Assigned( fOnStop ) then fOnStop( @Self );
         ReportStatus( SERVICE_STOPPED, NO_ERROR, 0 );
      end;
SERVICE_CONTROL_PAUSE:
      begin
         ReportStatus( SERVICE_PAUSE_PENDING, NO_ERROR, 0 );
         if Assigned( fOnPause ) then fOnPause( @Self );
         ReportStatus( SERVICE_PAUSED, NO_ERROR, 0 )
      end;
SERVICE_CONTROL_CONTINUE:
      begin
         ReportStatus( SERVICE_CONTINUE_PENDING, NO_ERROR, 0 );
         if Assigned( fOnResume ) then fOnResume( @Self );
         ReportStatus( SERVICE_RUNNING, NO_ERROR, 0 );
      end;
SERVICE_CONTROL_SHUTDOWN:
      begin
         if Assigned( fOnShutdown ) then fOnShutdown( @Self );
      end;
SERVICE_CONTROL_INTERROGATE:
      begin
         SetServiceStatus( FStatusHandle, FStatusRec );
         if Assigned( fOnInterrogate ) then fOnInterrogate( @Self );
      end;
   end;
   if Assigned( fOnControl ) then fOnControl( @Self, Code );
end;

procedure TServiceEx.DoCtrlHandle(Code: DWORD);
begin
  while not
     PostThreadMessage(fMThread.ThreadID, CM_SERVICE_CONTROL_CODE, Code, 0) do begin
     sleep(500);
  end;
end;

function TService.GetInstalled;
var Ctl: PServiceCTL;
begin
   Ctl := OpenServiceCtl( '', '', fSName, SERVICE_QUERY_STATUS );
   result := Ctl.Handle <> 0;
   Ctl.Free;
end;

procedure TService.Install;
var
   schService:SC_HANDLE;
   schSCManager:SC_HANDLE;
   ServicePath:String;
begin
   if installed then exit;
   ServicePath := paramstr(0);
   if fParam <> '' then ServicePath := ServicePath + ' ' + fParam;
   schSCManager:=OpenSCManager(nil,
                               nil,
                               SC_MANAGER_ALL_ACCESS);
   if (schSCManager>0) then begin
      schService:=CreateService(schSCManager,
                                Str2PChar(fSName),
                                Str2PChar(fDName),
                                SERVICE_ALL_ACCESS,
                                fServiceType,
                                fStartType,
                                SERVICE_ERROR_NORMAL,
                                Str2PChar(ServicePath),
                                nil,
                                nil,
                                nil,
                                nil,
                                nil);
      if (schService>0) then begin
         CloseServiceHandle(schService);
      end;
   end;
end;

procedure TService.Remove;
var Ctl: PServiceCtl;
begin
  Ctl := OpenServiceCtl( '',
                         '',
                         fSName,
                         SERVICE_ALL_ACCESS );
  if Ctl.Handle = 0 then Exit;
  Ctl.Stop;
  Ctl.Delete;
  Ctl.Free;
end;

procedure TService.Start;
var Ctl: PServiceCtl;
begin
    Ctl := OpenServiceCtl( '',
                           '',
                           fSName,
                           SERVICE_ALL_ACCESS );
    Ctl.Start( [ ] );
    Ctl.Free;
end;

procedure TService.Stop;
var Ctl: PServiceCtl;
begin
    Ctl := OpenServiceCtl( '',
                           '',
                           fSName,
                           SERVICE_ALL_ACCESS );
    Ctl.Stop;
    Ctl.Free;
end;

destructor TService.Destroy;
var I: Integer;
begin
  I := ServiceName2Idx( fSName );
  assert( I >= 0,
          PChar( 'Cannot find service ' + fSName + 'to remove from the list.' ) );
  Services.Delete( I );
  fSName := '';
  FArgsList.Free;
  VirtualFree( FJumper, 0, MEM_RELEASE );
  inherited;
end;

destructor TServiceEx.Destroy;
var I: Integer;
begin
  I := ServiceName2Idx( fSName );
  assert( I >= 0,
          PChar( 'Cannot find service ' + fSName + 'to remove from the list.' ) );
  Services.Delete( I );
  fSName := '';
  FArgsList.Free;
  fSThread.Free;
  fAThread.Free;
  fMThread.Free;
  VirtualFree( FJumper, 0, MEM_RELEASE );
  inherited;
end;

procedure TService.Execute;
begin
  if Assigned( fOnStart ) then
    fOnStart( @Self );
  ReportStatus( SERVICE_RUNNING, 0, 0 );
  if Assigned( fOnExecute ) then
    fOnExecute( @Self );
end;

procedure TServiceEx.Execute;
begin
  fMThread.Resume;
  if Assigned( fOnStart ) then
    fOnStart( @Self );
  if Assigned( fOnExecute ) then
    fSThread.Resume;
  if Assigned( fOnApplRun ) then
    fAThread.Resume;
  ReportStatus( SERVICE_RUNNING, 0, 0 );
end;

function TServiceEx.ThreadExecute( Sender: PThread ): Integer;
begin
  if Assigned( fOnExecute ) then fOnExecute( @Self );
  Result := 0;
end;

function TServiceEx.ApplicExecute( Sender: PThread ): Integer;
begin
  if Assigned( fOnApplRun ) then fOnApplRun( @Self );
  Result := 0;
end;

function TServiceEx.MessagExecute;
var Msg: TMsg;
    Rslt: boolean;
begin
   PeekMessage(msg, 0, WM_USER, WM_USER, PM_NOREMOVE); { Create message queue }
   while True do begin
      Sleep(1);
      Rslt := PeekMessage(msg, 0, 0, 0, PM_REMOVE);
      if not Rslt then Continue;
      if msg.hwnd = 0 then { Thread message }
      begin
         if msg.message = CM_SERVICE_CONTROL_CODE then begin
            case msg.wParam of
            SERVICE_CONTROL_STOP:
              begin
                 ReportStatus( SERVICE_STOP_PENDING, NO_ERROR, 0 );
                 if Assigned( fOnStop ) then
                   fOnStop( @Self );
                 ReportStatus( SERVICE_STOPPED, NO_ERROR, 0 );
                 fSThread.Terminate;
                 fAThread.Terminate;
                 fMThread.Terminate;
              end;
            SERVICE_CONTROL_PAUSE:
              begin
                 ReportStatus( SERVICE_PAUSE_PENDING, NO_ERROR, 0 );
                 if Assigned( fOnPause ) then
                   fOnPause( @Self );
                 fSThread.Suspend;
                 ReportStatus( SERVICE_PAUSED, NO_ERROR, 0 )
              end;
            SERVICE_CONTROL_CONTINUE:
              begin
                 ReportStatus( SERVICE_CONTINUE_PENDING, NO_ERROR, 0 );
                 if Assigned( fOnResume ) then
                   fOnResume( @Self );
                 fSThread.Resume;
                 ReportStatus( SERVICE_RUNNING, NO_ERROR, 0 );
              end;
            SERVICE_CONTROL_SHUTDOWN:
              if Assigned( fOnShutdown ) then
                fOnShutdown( @Self );
            SERVICE_CONTROL_INTERROGATE:
              begin
                 SetServiceStatus( FStatusHandle, FStatusRec );
                 if Assigned( fOnInterrogate ) then
                   fOnInterrogate( @Self );
              end;
            end;
            if Assigned( fOnControl ) then
              fOnControl( @Self, msg.wParam );
         end else
            DispatchMessage(msg);
      end else
         DispatchMessage(msg);
   end;
end;

function TService.GetArgCount: Integer;
begin
  Result := FArgsList.Count;
end;

function TService.GetArgs(Idx: Integer): String;
begin
  Result := FArgsList.Items[ Idx ];
end;

function TService.ReportStatus(dwState, dwExitCode, dwWait: DWORD): BOOL;
begin
  if dwState = SERVICE_START_PENDING then
       FStatusRec.dwControlsAccepted := 0
   else
       FStatusRec.dwControlsAccepted := fControl;

  FStatusRec.dwCurrentState  := dwState;
  FStatusRec.dwWin32ExitCode := dwExitCode;
  FStatusRec.dwWaitHint := dwWait;

  if (dwState = SERVICE_RUNNING) or (dwState = SERVICE_STOPPED) then
      FStatusRec.dwCheckPoint := 0
  else
      inc( FStatusRec.dwCheckPoint );
  Result := SetServiceStatus( FStatusHandle, FStatusRec );
end;

procedure TService.SetStatus(const Value: TServiceStatus);
begin
  FStatusRec := Value;
  if FStatusHandle <> 0 then
    SetServiceStatus( FStatusHandle, FStatusRec );
end;

procedure TService.CtrlHandle(Code: DWORD);
begin
  DoCtrlHandle( Code );
end;

function GetServiceList;
type
    ss = array[0..0] of TENUMSERVICESTATUS;
var sc: SC_HANDLE;
    pt: pointer;
    nd,
    sq,
    rh: dword;
begin
   result := false;
   sc := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
   if sc <> 0 then begin
      getmem(pt, 1024 * sizeof(TENUMSERVICESTATUS));
      nd := 0;
      sq := 0;
      rh := 0;
      if EnumServicesStatus(sc,
                            SERVICE_WIN32,
                            SERVICE_ACTIVE or SERVICE_INACTIVE,
                            TENUMSERVICESTATUS(pt^),
                            1024 * sizeof(TENUMSERVICESTATUS),
                            nd,
                            sq,
                            rh) then begin
         result := true;
         for rh := 0 to sq - 1 do begin
            if sn <> nil then
               sn.Add(ss(pt^)[rh].lpServiceName);
            if sd <> nil then
               sd.Add(ss(pt^)[rh].lpDisplayName);
         end;
         freemem(pt, 1024 * sizeof(TENUMSERVICESTATUS));
      end;
   end;
end;

initialization

finalization

end.
