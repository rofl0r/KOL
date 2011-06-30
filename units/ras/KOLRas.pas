{$A+}

unit KOLRas;

interface

uses
  Windows, KOL, RAS;

type

  PRASObj =^TRASObj;
  TKOLRAS = PRASObj;
  TOnErrorEvent = procedure (Sender: PRASObj; Error: Integer) of object;
  TOnConnectingEvent = procedure (Sender: PRASObj; Msg: Integer; State: Integer; Error: Longint) of object;

  TRASObj = object(TObj)
  private
    FOnConnecting: TOnConnectingEvent;  // event for asynchronous dialing
    FOnError:      TOnErrorEvent;       // error event
    FRASHandle:    THRasConn;           // connection handle
    FRASName:      string;              // name of the RAS service
    fState:        TRASConnState;
    fError:        longint;
    fTimer:        PTimer;
    connecting:    boolean;
    function  GetConnected: Boolean;
    function  GetParams(Server: string; var DialParams: TRasDialParams): Boolean;
    function  GetPassword: string;
    procedure GetRASHandle;
    function  GetUsername: string;
    procedure SetRASName( Value: string );
    function  GetStatusString: string;
    function  GetErrorString: string;
    procedure OnTimer(Sender: PObj);
  public
    destructor  Destroy; virtual;                       // and destroy it
    procedure   Connect;                                // make a connection
    procedure   DisConnect(force: boolean);             // close the connection
    property    Connected: Boolean read GetConnected;   // is service connected?
    property    Status: TRASConnState read fState;      // current RAS state
    property    Error: longint read fError;             // last RAS error
    property    RASHandle: THRASConn read fRASHandle;
    property    StatusString: string read GetStatusString;
    property    ErrorString: string read GetErrorString;
    property    Password: string read GetPassword;      // get the password
    property    RASName: string read FRASName write SetRASName; // name of RAS service
    property    Username: string read GetUsername;      // username
    property    OnConnecting: TOnConnectingEvent read FOnConnecting write FOnConnecting; // asynch dialing event
    property    OnError: TOnErrorEvent read FOnError write FOnError;                     // error event
  end;

function  GetStatString(s: longint): string;
function  GetErrString(e: longint): string;
function  NewRASObj: PRASObj;
function  GetRASConnected(Handles: PList): PStrList;  // get all existing connections
function  GetRASNames: PStrList;                      // get all possible connections
function  IsRASConnected( const r: string ): Boolean; // test if a connection is available
procedure HangUp( const RASName: string );

implementation

var RASSave: PRASObj;
    CBkSave: TOnConnectingEvent;

procedure RASCallback(Msg: Integer; State: TRasConnState; Error: Longint); stdcall;
begin
  if assigned(RASSave) then begin
     RASSAve.fState := State;
     RASSave.fError := Error;
     if Assigned(CBkSave) then begin
        CBkSave( RASSave, Msg, State, Error );
     end;
     if (Assigned(RASSave.FOnError)) and (Error <> 0) then begin
       RASSave.FOnError( RASSave, Error );
     end;
     if State = $2000 then begin
        RASSave.fTimer.Enabled := True;
        RASSave.connecting := false;
     end;
  end;
end;

function NewRASObj;
begin
  New(Result, create);                       // create the component first
  Result.FRASHandle := 0;                    // internal RAS handle
  Result.FRASName := '';                     // no default RAS name
  Result.fTimer := NewTimer(1000);           // watchdog timer
  Result.fTimer.Enabled := True;
  Result.fTimer.Enabled := False;
  Result.fTimer.OnTimer := Result.OnTimer;
  RASSave := Nil;
  CBkSave := Nil;
end;

destructor TRASObj.Destroy;
begin
  DisConnect(True);
  RASSave := Nil;
  CBkSave := Nil;
  fTimer.Free;
  inherited Destroy;    // next destroy the object
end;

procedure TRASObj.Connect;
var DialParams: TRasDialParams;  // local dial parameters
begin
  if not Connected then begin                       // only if the service is not connected
    if GetParams( FRASName, DialParams ) then begin // get actual dial parameters
      connecting := true;    
      RASSave := @self;                              // save the object itself
      CbkSave := FOnConnecting;
      RasDial(nil, nil, DialParams, 0, @RASCallback, FRASHandle ); // call with a callback function
    end;
  end;
end;

procedure TRASObj.DisConnect;
var s: TRasConnStatus;
begin
  if Connected or force then begin     // only if a connection is available
    if FRASHandle<>0 then begin        // only if a vaild handle is available
      RasHangup( FRASHandle );         // hangup the RAS service
      s.dwSize := sizeof(s);
      repeat
         sleep(0);
      until RasGetConnectStatus( FRASHandle, s ) = ERROR_INVALID_HANDLE;
      FRASHandle := 0;
    end;
  end;
end;

function TRASObj.GetConnected: Boolean;
begin
  Result := IsRASConnected( FRASName );      // test if a service with this name is established
  if (Result) and (FRASHandle=0) then begin  // if no handle is available
    GetRASHandle;                            // try to read the handle
  end;
end;

function TRASObj.GetParams(Server: string; var DialParams: TRasDialParams): Boolean;
var DialPassword: LongBool;
    RASResult:    LongInt;
begin
  Result := true;                                     // result is first vaild
  FillChar( DialParams, SizeOf(TRasDialParams), 0);   // clear the result record
  DialParams.dwSize := Sizeof(TRasDialParams);        // set the result array size
  StrPCopy(DialParams.szEntryName, Server);           // set the ras service name
  DialPassword := true;                               // get the dial password
  RASResult := RasGetEntryDialParams(nil, DialParams, DialPassword); // read the ras parameters
  if (RASResult<>0) then begin                        // if the API call was not successful
    Result := false;                                  // result is not vaild
    if (Assigned(FOnError)) then begin                // if an error event is assigned
      FOnError( @self, RASResult );                    // call the error event
    end;
  end;
end;

function TRASObj.GetPassword: string;
var DialParams: TRasDialParams;                   // dial parameters for this service
begin
  if GetParams( FRASName, DialParams ) then begin // if read of dial parameters was successful
    Result := DialParams.szPassword;              // copy the password string
  end else begin                                  // if read was not successful
    Result := '';                                 // return an empty string
  end;
end;

procedure TRASObj.GetRASHandle;
const cMaxRas = 100;                           // maximum number of ras services
var BufferSize: LongInt;                       // used for size of result buffer
    RASBuffer:  array[1..cMaxRas] of TRasConn; // the API result buffer itself
    RASCount:   LongInt;                       // number of found ras services
    i:          Integer;                       // loop counter
begin
  FRASHandle := 0;                             // first no handle is available
  FillChar( RASBuffer, SizeOf(RASBuffer), 0 ); // clear the API Buffer
  RASBuffer[1].dwSize := SizeOf(TRasConn);     // set the API buffer size for a single record
  BufferSize := SizeOf(TRasConn) * cMaxRas;    // calc complete buffer size
  if RasEnumConnections(@RASBuffer[1], BufferSize, RASCount) = 0 then begin
    for i := 1 to RASCount do begin            // for all found ras services
      if RASBuffer[i].szEntryName = RASName then begin // if the actual name is available
        FRASHandle := RASBuffer[i].hrasconn;   // save the found ras handle
      end;
    end;
  end;
end;

function TRASObj.GetUsername: string;
var DialParams: TRasDialParams;                   // dial parameters for this service
begin
  if GetParams( FRASName, DialParams ) then begin // if read of dial parameters was successful
    Result := DialParams.szUserName;              // copy the user name string
  end else begin                                  // if read was not successful
    Result := '';                                 // return an empty string
  end;
end;

function TRASObj.GetStatusString;
begin
   result := GetStatString(fState);
end;

function GetStatString;
begin
   result := 'unexpected status: ' + int2str(s);
   case s of
    0: result := '';
    1: result := 'port is opened';
    2: result := 'call in progress';
    3: result := 'device is connected';
    4: result := 'all devices is connected';
    5: result := 'authentication';
    6: result := 'authnotify';
    7: result := 'authretry';
    8: result := 'authcallback';
    9: result := 'authchangepassword';
   10: result := 'authproject';
   11: result := 'linkspeed';
   12: result := 'authack';
   13: result := 'reauthenticate';
   14: result := 'authenticated';
   15: result := 'prepareforcallback';
   16: result := 'waitformodemreset';
   17: result := 'waitforcallback';
   18: result := 'projected';
   19: result := 'startauthentication';
   20: result := 'callbackcomplete';
   21: result := 'logonnetwork';
$1000: result := 'interactive';
$1001: result := 'retryauthentication';
$1002: result := 'callbacksetbycaller';
$1003: result := 'password is expired';
$2000: result := 'connected';
$2001: result := 'disconnected';
   end;
end;

function TRASObj.GetErrorString;
begin
   result := GetErrString(fError);
end;

function GetErrString(e: longint): string;
begin
   result := 'unexpected error: ' + int2str(e);
   case e of
   000: result := '';
   600: result := 'operation is pending';
   601: result := 'invalid port handle';
   608: result := 'device does not exist';
   615: result := 'port not found';
   619: result := 'connection is terminated';
   628: result := 'port was disconnected';
   629: result := 'disconnected by remote';
   630: result := 'hardware failure';
   631: result := 'user disconnect';
   633: result := 'port is in use';
   638: result := 'PPP no address assigned';
   651: result := 'device error';
   676: result := 'line is busy';
   678: result := 'no answer';
   680: result := 'no dialtone';
   691: result := 'authentication failure';
   718: result := 'PPP timeout';
   720: result := 'PPP no CP configured';
   721: result := 'PPP no responce';
   732: result := 'PPP is not converging';
   734: result := 'PPP LCP terminated';
   735: result := 'PPP adress rejected';
   738: result := 'no PPP address assigned';
   742: result := 'no remote encription';
   743: result := 'remote requires encription';
   752: result := 'script syntax error';
   777: result := 'no answer timeout'; 
   797: result := 'modem is not found';
   end;
end;

procedure TRASObj.SetRASName( Value: string );
var DialParams: TRasDialParams;                   // dial parameters for this service
begin
  if GetParams( Value, DialParams ) then begin
    FRASName := Value;
    GetRASHandle;        // try to read an existing handle
  end;
end;

function GetRASConnected;
const cMaxRas = 100;                           // maximum number of ras services
var BufferSize: LongInt;                       // used for size of result buffer
    RASBuffer:  array[1..cMaxRas] of TRasConn; // the API result buffer itself
    RASCount:   LongInt;                       // number of found ras services
    i:          Integer;                       // loop counter
begin
  FillChar( RASBuffer, SizeOf(RASBuffer), 0 ); // clear the API Buffer
  RASBuffer[1].dwSize := SizeOf(TRasConn);     // set the API buffer size for a single record
  BufferSize := SizeOf(TRasConn) * cMaxRas;    // calc complete buffer size
  Result := NewStrList;
  if RasEnumConnections(@RASBuffer[1], BufferSize, RASCount) = 0 then begin
    for i := 1 to RASCount do begin            // for all found ras services
      Result.Add( RASBuffer[i].szEntryName );   // copy the name of the ras service
      if Handles <> nil then Handles.Add(pointer(RASBuffer[i].hrasconn));
    end;
  end;
  if assigned(RASSave) then begin
     if RASSAve.FRASHandle <> 0 then begin
        if RASSave.connecting then begin
           i := Result.IndexOf(RASSave.FRASName);
           if i = -1 then begin
              i := Result.Add(RASSave.FRASName);
              if Handles <> nil then Handles.Add(pointer(RASSave.FRASHandle));
           end;
           if Handles <> nil then Handles.Items[i] := pointer(RASSave.FRASHandle);
        end;
     end;
  end;
end;

function GetRASNames;
const cMaxRas = 100;                            // maximum number of ras services
var BufferSize: LongInt;                        // used for size of result buffer
    RASBuffer:  array[1..cMaxRas] of TRasEntryName; // the API result buffer itself
    RASCount:   LongInt;                        // number of found ras services
    i:          Integer;                        // loop counter
begin
  Result := Nil;
  FillChar( RASBuffer, SizeOf(RASBuffer), 0 );  // clear the API Buffer
  RASBuffer[1].dwSize := SizeOf(TRasEntryname); // set the API buffer size for a single record
  BufferSize := SizeOf(TRasEntryName) * cMaxRas;// calc complete buffer size
  if RasEnumEntries(nil, nil, @RASBuffer[1], BufferSize, RASCount) = 0 then begin
    Result := NewStrList;
    for i := 1 to RASCount do begin             // for all found ras services
      Result.Add( RASBuffer[i].szEntryName );    // copy the name of the ras service
    end;
  end;
end;

function IsRASConnected( const r: string ): Boolean;
var n: PStrList;       // result object for connected services
    i: Integer;        // loop counter
    p: PList;
begin
  Result := false;                   // first the result is false
  p := NewList;
  n := GetRasConnected(p);           // create the object for connected services
  for i := 0 to n.Count - 1 do begin // for all connected services
    if r = n.Items[i] then begin     // if the ras name was found
       Result := true;               // the result is true now
       Break;                        // break the loop, one is found
    end;
  end;
  n.Free;                            // destroy the object for connected services
  p.Free;
end;

procedure HangUP;
var e: PStrList;
    h: PList;
    i: integer;
begin
    h := NewList;
    e := GetRASConnected(h);
    i := e.IndexOf(RASName);
    if i > -1 then begin
       RASHangUp(integer(h.Items[i]));
    end;
    e.Free;
    h.Free;
end;

procedure TRASObj.OnTimer;
begin
   if not connected then begin
      fTimer.Enabled := False;
      Disconnect(True);
      if assigned(fOnConnecting) then begin
         fState := $2001;
         fError :=  619;
         fOnConnecting(@self, 0, $2001, 619);
      end;
   end;
end;

end.
