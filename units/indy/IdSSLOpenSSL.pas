// 30-nov-2002
unit IdSSLOpenSSL;

interface

uses
  KOL
  {Classes,
  IdException},
  IdStackConsts,
  IdSSLIntercept,
  IdSocketHandle,
  IdSSLOpenSSLHeaders,
  IdGlobal,
  IdTCPServer,
  IdIntercept, SysUtils;

type
//  TIdX509 = class;

  TIdSSLVersion = (sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1);
  TIdSSLMode = (sslmUnassigned, sslmClient, sslmServer, sslmBoth);
  TIdSSLVerifyMode = (sslvrfPeer, sslvrfFailIfNoPeerCert, sslvrfClientOnce);
  TIdSSLVerifyModeSet = set of TIdSSLVerifyMode;
  TIdSSLErrorMode = (sslemClient, sslemServer);
  TIdSSLAction = (sslRead, sslWrite);

  TULong = packed record
    case Byte of
      0: (B1, B2, B3, B4: Byte);
      1: (W1, W2: Word);
      2: (L1: Longint);
      3: (C1: Cardinal);
  end;

  TEVP_MD = record
    Length: Integer;
    MD: array[0..OPENSSL_EVP_MAX_MD_SIZE - 1] of Char;
  end;

  TByteArray = record
    Length: Integer;
    Data: PChar;
  end;

  TCallbackEvent = procedure(Msg: string) of object;
  TPasswordEvent = procedure(var Password: string) of object;
  TVerifyPeerEvent = function(Certificate: PObj{PIdX509}{TIdX509}): Boolean of object;

  PIdSSLOptions=^TIdSSLOptions;
  TIdSSLOptions = object(TObj)
  protected
    fsRootCertFile, fsCertFile, fsKeyFile: TFileName;
    fMethod: TIdSSLVersion;
    fMode: TIdSSLMode;

    fVerifyDepth: Integer;
    fVerifyMode: TIdSSLVerifyModeSet;
    fVerifyFile, fVerifyDirs, fCipherList: string;
//  published
    property RootCertFile: TFileName read fsRootCertFile write fsRootCertFile;
    property CertFile: TFileName read fsCertFile write fsCertFile;
    property KeyFile: TFileName read fsKeyFile write fsKeyFile;
    property Method: TIdSSLVersion read fMethod write fMethod;
    property Mode: TIdSSLMode read fMode write fMode;
    property VerifyMode: TIdSSLVerifyModeSet read fVerifyMode write fVerifyMode;
    property VerifyDepth: Integer read fVerifyDepth write fVerifyDepth;
  end;

  function NewIdSSLOptions:PIdSSLOptions;

  type

  PIdSSLContext=^TIdSSLContext;
  TIdSSLContext = object(TObj)
  protected
    fMethod: TIdSSLVersion;
    fMode: TIdSSLMode;
    fsRootCertFile, fsCertFile, fsKeyFile: string;
    fVerifyDepth: Integer;
    fVerifyMode: TIdSSLVerifyModeSet;
    fContext: PSSL_CTX;
    fStatusInfoOn: Boolean;
    fVerifyOn: Boolean;
    procedure DestroyContext;
    function InternalGetMethod: PSSL_METHOD;
    procedure SetMode(const Value: TIdSSLMode);

    procedure SetVerifyMode(AMode: TIdSSLVerifyModeSet);
    function GetVerifyMode: TIdSSLVerifyModeSet;

    function LoadOpenSLLibrary: Boolean;
    procedure UnLoadOpenSLLibrary;
  public
    Parent: PObj;//TObject;
    constructor Create;
    destructor Destroy; virtual;//override;
    function LoadRootCert: Boolean;
    function LoadCert: Boolean;
    function LoadKey: Boolean;
    property StatusInfoOn: Boolean read fStatusInfoOn write fStatusInfoOn;
    property VerifyOn: Boolean read fVerifyOn write fVerifyOn;
//  published
    property Method: TIdSSLVersion read fMethod write fMethod;
    property Mode: TIdSSLMode read fMode write SetMode;
    property RootCertFile: string read fsRootCertFile write fsRootCertFile;
    property CertFile: string read fsCertFile write fsCertFile;
    property KeyFile: string read fsKeyFile write fsKeyFile;
    property VerifyMode: TIdSSLVerifyModeSet read GetVerifyMode write
      SetVerifyMode;
    property VerifyDepth: Integer read fVerifyDepth write fVerifyDepth;
  end;

  function NewIdSSLContext:PIdSSLContext;

  type

  PIdSSLSocket=^TIdSSLSocket;
  TIdSSLSocket = object(TObj)
  private
    fPeerCert: PObj;//TIdX509;

    fParent: TObject;
    function GetPeerCert: PObj;// TIdX509;
    function GetSSLError(retCode: Integer; DataLen: Integer; Mode:
      TIdSSLErrorMode; Action: TIdSSLAction): Integer;
  public
    fSSL: PSSL;

//    constructor Create(Parent: TObject);
    procedure Accept(const pHandle: TIdStackSocketHandle; fSSLContext:
      PIdSSLContext{TIdSSLContext});
    procedure Connect(const pHandle: TIdStackSocketHandle; fSSLContext:
      PIdSSLContext{TIdSSLContext});
    destructor Destroy; virtual;//override;
    function GetSessionID: TByteArray;
    function GetSessionIDAsString: string;
    procedure SetCipherList(CipherList: string);

    property PeerCert: PObj{TIdX509} read GetPeerCert;
  end;

  function NewIdSSLSocket(Parent: PObj):PIdSSLSocket;
  type

  PIdConnectionInterceptOpenSSL=^TIdConnectionInterceptOpenSSL;
  TIdConnectionInterceptOpenSSL = object(TIdSSLConnectionIntercept)
  private
    fSSLContext:PIdSSLContext;// TIdSSLContext;
    fxSSLOptions: PIdSSLOptions;//TIdSSLOptions;
    fSSLSocket:PIdSSLSocket;// TIdSSLSocket;
    fIsPeer: Boolean;

    fOnStatusInfo: TCallbackEvent;
    fOnGetPassword: TPasswordEvent;
    fOnVerifyPeer: TVerifyPeerEvent;
    fSSLLayerClosed: Boolean;
    function GetPeerCert: PObj;//TIdX509;
    procedure CreateSSLContext(axMode: TIdSSLMode);

  protected
    procedure DoStatusInfo(Msg: string); virtual;
    procedure DoGetPassword(var Password: string); virtual;
    function DoVerifyPeer(Certificate: PObj{TIdX509}): Boolean; virtual;
  public
    procedure Init; virtual;
//    constructor Create(AOwner: TComponent); override;
    destructor Destroy; virtual; //override;
    procedure Connect(ABinding: PIdSocketHandle{TIdSocketHandle});virtual;// override;
    procedure Disconnect; virtual;//override;
    function Recv(var ABuf; ALen: Integer): Integer; virtual;//override;
    function Send(var ABuf; ALen: Integer): Integer; virtual;//override;
    property PeerCert: PObj{TIdX509} read GetPeerCert;
//  published
    property SSLOptions: PIdSSLOptions{TIdSSLOptions} read fxSSLOptions write fxSSLOptions;
    property OnStatusInfo: TCallbackEvent read fOnStatusInfo write
      fOnStatusInfo;
    property OnGetPassword: TPasswordEvent read fOnGetPassword write
      fOnGetPassword;
    property OnVerifyPeer: TVerifyPeerEvent read fOnVerifyPeer write
      fOnVerifyPeer;
  end;

  function NewIdConnectionInterceptOpenSSL(AOwner: PControl):PIdConnectionInterceptOpenSSL;

  type

  PIdServerInterceptOpenSSL=^TIdServerInterceptOpenSSL;
  TIdServerInterceptOpenSSL = object(TIdSSLServerIntercept)
  private
    fSSLContext: PIdSSLContext;//TIdSSLContext;
    fxSSLOptions: PIdSSLOptions;//TIdSSLOptions;
    fIsInitialized: Boolean;
    fOnStatusInfo: TCallbackEvent;
    fOnGetPassword: TPasswordEvent;
    fOnVerifyPeer: TVerifyPeerEvent;
    procedure CreateSSLContext(axMode: TIdSSLMode);
  protected
    procedure DoStatusInfo(Msg: string); virtual;
    procedure DoGetPassword(var Password: string); virtual;
    function DoVerifyPeer(Certificate: PObj{TIdX509}): Boolean; virtual;
  public
    procedure Init; virtual;//override;
    procedure _Init; virtual;//override;
    function Accept(ABinding: PIdSocketHandle{TIdSocketHandle}):PIdConnectionIntercept;// TIdConnectionIntercept;
      virtual;//override;
//    constructor Create(AOwner: TComponent); override;
    destructor Destroy; virtual;//override;
//  published
    property SSLOptions:PIdSSLOptions{ TIdSSLOptions} read fxSSLOptions write fxSSLOptions;
    property OnStatusInfo: TCallbackEvent read fOnStatusInfo write
      fOnStatusInfo;
    property OnGetPassword: TPasswordEvent read fOnGetPassword write
      fOnGetPassword;
    property OnVerifyPeer: TVerifyPeerEvent read fOnVerifyPeer write
      fOnVerifyPeer;
  end;

  function NewIdServerInterceptOpenSSL(AOwner: PControl):PIdServerInterceptOpenSSL;

  type

  PIdX509Name=^TIdX509Name;
  TIdX509Name = object(TObj)
  private
    fX509Name: PX509_NAME;
    function CertInOneLine: string;
    function GetHash: TULong;
    function GetHashAsString: string;
  public
//    constructor Create(aX509Name: PX509_NAME);

    property Hash: TULong read GetHash;
    property HashAsString: string read GetHashAsString;
    property OneLine: string read CertInOneLine;
  end;

  function NewIdX509Name(aX509Name: PX509_NAME):PIdX509Name;

  type

  PIdX509=^TIdX509;
  TIdX509 = object(TObj)
  protected
    FX509: PX509;
    FSubject: PIdX509Name;//TIdX509Name;
    FIssuer: PIdX509Name;//TIdX509Name;
    function RSubject: PIdX509Name;//TIdX509Name;
    function RIssuer: PIdX509Name;//TIdX509Name;
    function RnotBefore: TDateTime;
    function RnotAfter: TDateTime;
    function RFingerprint: TEVP_MD;
    function RFingerprintAsString: string;
  public
//    constructor Create(aX509: PX509); virtual;
    destructor Destroy; virtual;// override;

    property Fingerprint: TEVP_MD read RFingerprint;
    property FingerprintAsString: string read RFingerprintAsString;
    property Subject:PIdX509Name{ TIdX509Name} read RSubject;
    property Issuer:PIdX509Name{ TIdX509Name} read RIssuer;
    property notBefore: TDateTime read RnotBefore;
    property notAfter: TDateTime read RnotAfter;
  end;

  function NewIdX509(aX509: PX509):PIdX509;

{type
  EIdOpenSSLError = class(EIdException);
  EIdOpenSSLLoadError = class(EIdOpenSSLError);
  EIdOSSLCouldNotLoadSSLLibrary = class(EIdOpenSSLLoadError);
  EIdOSSLModeNotSet = class(EIdOpenSSLError);
  EIdOSSLGetMethodError = class(EIdOpenSSLError);
  EIdOSSLCreatingContextError = class(EIdOpenSSLError);
  EIdOSSLLoadingRootCertError = class(EIdOpenSSLLoadError);
  EIdOSSLLoadingCertError = class(EIdOpenSSLLoadError);
  EIdOSSLLoadingKeyError = class(EIdOpenSSLLoadError);
  EIdOSSLSettingCipherError = class(EIdOpenSSLError);
  EIdOSSLDataBindingError = class(EIdOpenSSLError);
  EIdOSSLAcceptError = class(EIdOpenSSLError);
  EIdOSSLConnectError = class(EIdOpenSSLError);}

function LogicalAnd(A, B: Integer): Boolean;
procedure InfoCallback(sslSocket: PSSL; where: Integer; ret: Integer); cdecl;
function PasswordCallback(buf: PChar; size: Integer; rwflag: Integer; userdata:
  Pointer): Integer; cdecl;
function VerifyCallback(Ok: Integer; ctx: PX509_STORE_CTX): Integer; cdecl;

implementation

uses
  IdResourceStrings,
  Windows;

var
  DLLLoadCount: Integer = 0;

function LoadOpenSLLibrary: Boolean;
begin
  if not IdSSLOpenSSLHeaders.Load then
  begin
    Result := False;
    Exit;
  end;

  IdSslRandScreen;
  IdSslLoadErrorStrings;

  result := IdSslAddSslAlgorithms > 0;
end;

procedure UnLoadOpenSLLibrary;
begin
  IdSSLOpenSSLHeaders.Unload;
end;

//constructor TIdServerInterceptOpenSSL.Create(AOwner: TComponent);
function NewIdServerInterceptOpenSSL(AOwner: PControl):PIdServerInterceptOpenSSL;
begin
New( Result, Create );
Result.Init;
{with Result^ do
begin
//  inherited;
  fIsInitialized := False;
//  fxSSLOptions := TIdSSLOptions.Create;
end;  }
end;

procedure TIdServerInterceptOpenSSL.Init;
begin
//  with Result^ do
begin
  inherited;
  fIsInitialized := False;
  fxSSLOptions := NewIdSSLOptions;//TIdSSLOptions.Create;
end;
end;

destructor TIdServerInterceptOpenSSL.Destroy;
begin
  if fSSLContext <> nil then
  begin
    FreeAndNil(fSSLContext);
  end;
  fxSSLOptions.Destroy;
  inherited;
end;

procedure TIdServerInterceptOpenSSL._Init;
begin
  CreateSSLContext(sslmServer);
  fIsInitialized := True;
end;

function TIdServerInterceptOpenSSL.Accept(ABinding:PIdSocketHandle{ TIdSocketHandle}):
 PIdConnectionIntercept;// TIdConnectionIntercept;
var
  tmpIdCIOpenSSL: PIdConnectionInterceptOpenSSL;//TIdConnectionInterceptOpenSSL;
begin
  if not fIsInitialized then
  begin
    Init;
  end;
  tmpIdCIOpenSSL := NewIdConnectionInterceptOpenSSL(@Self);//TIdConnectionInterceptOpenSSL.Create(self);
  tmpIdCIOpenSSL.fIsPeer := True;
  tmpIdCIOpenSSL.fxSSLOptions := fxSSLOptions;
  tmpIdCIOpenSSL.fSSLSocket := NewIdSSLSocket(@Self);//TIdSSLSocket.Create(self);
  tmpIdCIOpenSSL.fSSLSocket.Accept(ABinding.Handle, fSSLContext);

  Result := tmpIdCIOpenSSL;
end;

procedure TIdServerInterceptOpenSSL.CreateSSLContext(axMode: TIdSSLMode);
begin
  fSSLContext := NewIdSSLContext;//TIdSSLContext.Create;
  with fSSLContext^ do
  begin
    Parent := @self;
    RootCertFile := SSLOptions.RootCertFile;
    CertFile := SSLOptions.CertFile;
    KeyFile := SSLOptions.KeyFile;
    if Assigned(fOnStatusInfo) then
    begin
      StatusInfoOn := True;
    end
    else
    begin
      StatusInfoOn := False;
    end;

    VerifyMode := SSLOptions.VerifyMode;
    if Assigned(fOnVerifyPeer) then
    begin
      VerifyOn := True;
    end
    else
    begin
      VerifyOn := False;
    end;

    Mode := axMode;
    Method := SSLOptions.Method;
  end;
end;

procedure TIdServerInterceptOpenSSL.DoStatusInfo(Msg: string);
begin
  if Assigned(fOnStatusInfo) then
    fOnStatusInfo(Msg);
end;

procedure TIdServerInterceptOpenSSL.DoGetPassword(var Password: string);
begin
  if Assigned(fOnGetPassword) then
    fOnGetPassword(Password);
end;

function TIdServerInterceptOpenSSL.DoVerifyPeer(Certificate: PObj{TIdX509}): Boolean;
begin
  Result := True;
  if Assigned(fOnVerifyPeer) then
    Result := fOnVerifyPeer(Certificate);
end;

//constructor TIdConnectionInterceptOpenSSL.Create(AOwner: TComponent);
function NewIdConnectionInterceptOpenSSL(AOwner: PControl):PIdConnectionInterceptOpenSSL;
begin
New( Result, Create );
Result.Init;
{with Result^ do
begin
//  inherited;
  fIsPeer := False;
//  fxSSLOptions := TIdSSLOptions.Create;
  fSSLLayerClosed := True;
end;    }
end;

procedure TIdConnectionInterceptOpenSSL.Init;
begin
  inherited;
//  with Result^ do
begin
//  inherited;
  fIsPeer := False;
  fxSSLOptions := NewIdSSLOptions;//TIdSSLOptions.Create;
  fSSLLayerClosed := True;
end;
end;

destructor TIdConnectionInterceptOpenSSL.Destroy;
begin
  FreeAndNil(fSSLSocket);
  if not fIsPeer then
  begin
    FreeAndNil(fSSLContext);
    fxSSLOptions.Destroy;
  end;
  inherited;
end;

procedure TIdConnectionInterceptOpenSSL.Connect(ABinding: PIdSocketHandle{TIdSocketHandle});
begin
  inherited;
  CreateSSLContext(sslmClient);

  fSSLSocket := NewIdSSLSocket(@Self);//TIdSSLSocket.Create(self);
  if fSSLSocket <> nil then
  begin
    fSSLSocket.Connect(ABinding.Handle, fSSLContext);
  end
  else
  begin
  end;
end;

procedure TIdConnectionInterceptOpenSSL.Disconnect;
begin
  FreeAndNil(fSSLSocket);
  if not fIsPeer then
  begin
    FreeAndNil(fSSLContext);
  end;
  inherited;
end;

function TIdConnectionInterceptOpenSSL.Recv(var ABuf; ALen: Integer): Integer;
begin
  Result := IdSslRead(fSSLSocket.fSSL, @ABuf, ALen);
  while (fSSLSocket.GetSSLError(Result, ALen, sslemClient, sslRead) =
    OPENSSL_SSL_ERROR_WANT_READ) do
  begin
    Result := IdSslRead(fSSLSocket.fSSL, @ABuf, ALen);
  end;
end;

function TIdConnectionInterceptOpenSSL.Send(var ABuf; ALen: Integer): Integer;
begin
  Result := IdSslWrite(fSSLSocket.fSSL, @ABuf, ALen);
  while (fSSLSocket.GetSSLError(Result, ALen, sslemClient, sslWrite) =
    OPENSSL_SSL_ERROR_WANT_WRITE) do
  begin
    Result := IdSslWrite(fSSLSocket.fSSL, @ABuf, ALen);
  end;
end;

function TIdSSLSocket.GetSSLError(retCode: Integer; DataLen: Integer; Mode:
  TIdSSLErrorMode; Action: TIdSSLAction): Integer;
begin
  Result := IdSslGetError(fSSL, retCode);
  case Result of
    OPENSSL_SSL_ERROR_NONE:
      Result := OPENSSL_SSL_ERROR_NONE;
    OPENSSL_SSL_ERROR_WANT_WRITE:
      Result := OPENSSL_SSL_ERROR_WANT_WRITE;
    OPENSSL_SSL_ERROR_WANT_READ:
      Result := OPENSSL_SSL_ERROR_WANT_READ;
    OPENSSL_SSL_ERROR_ZERO_RETURN:
      Result := OPENSSL_SSL_ERROR_NONE;
    OPENSSL_SSL_ERROR_SYSCALL:
      Result := OPENSSL_SSL_ERROR_NONE;
    OPENSSL_SSL_ERROR_SSL:
      Result := OPENSSL_SSL_ERROR_NONE;
  end;
end;

procedure TIdConnectionInterceptOpenSSL.CreateSSLContext(axMode: TIdSSLMode);
begin
  fSSLContext := NewIdSSLContext;//TIdSSLContext.Create;
  with fSSLContext^ do
  begin
    Parent := @self;
    RootCertFile := SSLOptions.RootCertFile;
    CertFile := SSLOptions.CertFile;
    KeyFile := SSLOptions.KeyFile;
    if Assigned(fOnStatusInfo) then
    begin
      StatusInfoOn := True;
    end
    else
    begin
      StatusInfoOn := False;
    end;
    if Assigned(fOnVerifyPeer) then
    begin
      VerifyOn := True;
    end
    else
    begin
      VerifyOn := False;
    end;
    Method := SSLOptions.Method;
    Mode := axMode;
  end;
end;

function TIdConnectionInterceptOpenSSL.GetPeerCert:PObj;// TIdX509;
begin
  if fSSLContext <> nil then
  begin
    Result := fSSLSocket.PeerCert;
  end
  else
  begin
    Result := nil;
  end;
end;

procedure TIdConnectionInterceptOpenSSL.DoStatusInfo(Msg: string);
begin
  if Assigned(fOnStatusInfo) then
    fOnStatusInfo(Msg);
end;

procedure TIdConnectionInterceptOpenSSL.DoGetPassword(var Password: string);
begin
  if Assigned(fOnGetPassword) then
    fOnGetPassword(Password);
end;

function TIdConnectionInterceptOpenSSL.DoVerifyPeer(Certificate: PObj{TIdX509}):
  Boolean;
begin
  Result := True;
  if Assigned(fOnVerifyPeer) then
    Result := fOnVerifyPeer(Certificate);
end;

function PasswordCallback(buf: PChar; size: Integer; rwflag: Integer; userdata:
  Pointer): Integer; cdecl;
var
  Password: string;
  IdSSLContext: PIdSSLContext;//TIdSSLContext;
begin
  Password := '';

  IdSSLContext := PIdSSLContext(userdata);//TIdSSLContext(userdata);

{  if (IdSSLContext.Parent is TIdServerInterceptOpenSSL) then
  begin
    (IdSSLContext.Parent as TIdServerInterceptOpenSSL).DoGetPassword(Password);
  end;
  if (IdSSLContext.Parent is TIdConnectionInterceptOpenSSL) then
  begin
    (IdSSLContext.Parent as
      TIdConnectionInterceptOpenSSL).DoGetPassword(Password);
  end;
 }
  Password := Copy(Password, 1, size);
  StrLCopy(buf, PChar(Password), size);
  Result := Length(Password);
end;

procedure InfoCallback(sslSocket: PSSL; where: Integer; ret: Integer); cdecl;
var
  IdSSLSocket: TIdSSLSocket;
  StatusStr: string;
begin
//  IdSSLSocket := TIdSSLSocket(IdSslGetAppData(sslSocket));

  StatusStr := Format(RSOSSLStatusString,
    [StrPas(IdSslStateStringLong(sslSocket))]);
{  if (IdSSLSocket.fParent is TIdServerInterceptOpenSSL) then
  begin
    (IdSSLSocket.fParent as TIdServerInterceptOpenSSL).DoStatusInfo(StatusStr);
  end;
  if (IdSSLSocket.fParent is TIdConnectionInterceptOpenSSL) then
  begin
    (IdSSLSocket.fParent as
      TIdConnectionInterceptOpenSSL).DoStatusInfo(StatusStr);
  end;
 }
end;

function AddMins(const DT: TDateTime; const Mins: Extended): TDateTime;
begin
  Result := DT + Mins / (60 * 24)
end;

function AddHrs(const DT: TDateTime; const Hrs: Extended): TDateTime;
begin
  Result := DT + Hrs / 24.0
end;

function GetLocalTZBias: LongInt;
var
  TZ: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TZ) of
    TIME_ZONE_ID_STANDARD: Result := TZ.Bias + TZ.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Result := TZ.Bias + TZ.DaylightBias;
  else
    Result := TZ.Bias;
  end;
end;

function GetLocalTime(const DT: TDateTime): TDateTime;
begin
  Result := DT - GetLocalTZBias / (24 * 60);
end;

constructor TIdSSLContext.Create;
begin
  inherited;

  if DLLLoadCount <= 0 then
  begin
    if not IdSSLOpenSSL.LoadOpenSLLibrary then
    begin
//      raise EIdOSSLCouldNotLoadSSLLibrary.Create(RSOSSLCouldNotLoadSSLLibrary);
    end;
  end;
  Inc(DLLLoadCount);

  fMode := sslmUnassigned;
end;

destructor TIdSSLContext.Destroy;
begin
  DestroyContext;
  inherited;
end;

procedure TIdSSLContext.DestroyContext;
begin
  if fContext <> nil then
  begin
    IdSslCtxFree(fContext);
    fContext := nil;
  end;
end;

function LogicalAnd(A, B: Integer): Boolean;
begin
  Result := (A and B) = B;
end;

function VerifyCallback(Ok: Integer; ctx: PX509_STORE_CTX): Integer; cdecl;
var
  hcert: PX509;
  Certificate: PIdX509;//TIdX509;
  hSSL: PSSL;
  IdSSLSocket: TIdSSLSocket;
  VerifiedOK: Boolean;
begin
  VerifiedOK := False;
  hcert := IdSslX509StoreCtxGetCurrentCert(ctx);
  hSSL := IdSslX509StoreCtxGetAppData(ctx);
  Certificate := NewIdX509(hcert);//TIdX509.Create(hcert);
{  if hSSL <> nil then
    IdSSLSocket := TIdSSLSocket(IdSslGetAppData(hSSL))
  else
    IdSSLSocket := nil;}
  IdSslX509StoreCtxGetError(ctx);
  IdSslX509StoreCtxGetErrorDepth(ctx);

{  if (IdSSLSocket.fParent is TIdServerInterceptOpenSSL) then
  begin
    VerifiedOK := (IdSSLSocket.fParent as
      TIdServerInterceptOpenSSL).DoVerifyPeer(Certificate);
  end;
  if (IdSSLSocket.fParent is TIdConnectionInterceptOpenSSL) then
  begin
    VerifiedOK := (IdSSLSocket.fParent as
      TIdConnectionInterceptOpenSSL).DoVerifyPeer(Certificate);
  end;  }

  Certificate.Destroy;
  if VerifiedOK and (Ok > 0) then
  begin
    Result := 0;
  end
  else
  begin
    Result := -1;
  end;
end;

function TranslateInternalVerifyToSLL(Mode: TIdSSLVerifyModeSet): Integer;
begin
  Result := OPENSSL_SSL_VERIFY_NONE;
  if sslvrfPeer in Mode then Result := Result or OPENSSL_SSL_VERIFY_PEER;
  if sslvrfFailIfNoPeerCert in Mode then
    Result := Result or OPENSSL_SSL_VERIFY_FAIL_IF_NO_PEER_CERT;
  if sslvrfClientOnce in Mode then
    Result := Result or OPENSSL_SSL_VERIFY_CLIENT_ONCE;
end;

procedure TIdSSLContext.SetVerifyMode(AMode: TIdSSLVerifyModeSet);
begin
  fVerifyMode := AMode;
  if fContext <> nil then
  begin
    IdSslCtxSetVerify(fContext, TranslateInternalVerifyToSLL(fVerifyMode),
      PFunction(@VerifyCallback));
  end;
end;

function TIdSSLContext.GetVerifyMode: TIdSSLVerifyModeSet;
begin
  Result := fVerifyMode;
end;

function TIdSSLContext.InternalGetMethod: PSSL_METHOD;
begin
  if fMode = sslmUnassigned then
  begin
//    raise EIdOSSLModeNotSet.create(RSOSSLModeNotSet);
  end;
  case fMethod of
    sslvSSLv2:
      case fMode of
        sslmServer: Result := IdSslMethodServerV2;
        sslmClient: Result := IdSslMethodClientV2;
        sslmBoth: Result := IdSslMethodV2;
      else
        Result := IdSslMethodV2;
      end;

    sslvSSLv23:
      case fMode of
        sslmServer: Result := IdSslMethodServerV23;
        sslmClient: Result := IdSslMethodClientV23;
        sslmBoth: Result := IdSslMethodV23;
      else
        Result := IdSslMethodV23;
      end;

    sslvSSLv3:
      case fMode of
        sslmServer: Result := IdSslMethodServerV3;
        sslmClient: Result := IdSslMethodClientV3;
        sslmBoth: Result := IdSslMethodV3;
      else
        Result := IdSslMethodV3;
      end;

    sslvTLSv1:
      case fMode of
        sslmServer: Result := IdSslMethodServerTLSV1;
        sslmClient: Result := IdSslMethodClientTLSV1;
        sslmBoth: Result := IdSslMethodTLSV1;
      else
        Result := IdSslMethodTLSV1;
      end;
  else
  ;
//    raise EIdOSSLGetMethodError.Create(RSSSLGetMethodError);
  end;
end;

function TIdSSLContext.LoadRootCert: Boolean;
var
  pStr: PChar;
  error: Integer;
begin
  pStr := StrNew(PChar(RootCertFile));
  error := IdSslCtxLoadVerifyLocations(
    fContext,
    pStr,
    nil);
  if error <= 0 then
  begin
    Result := False
  end
  else
  begin
    Result := True;
  end;

  StrDispose(pStr);
end;

function TIdSSLContext.LoadCert: Boolean;
var
  pStr: PChar;
  error: Integer;
begin
  pStr := StrNew(PChar(CertFile));
  error := IdSslCtxUseCertificateFile(
    fContext,
    pStr,
    OPENSSL_SSL_FILETYPE_PEM);
  if error <= 0 then
    Result := False
  else
    Result := True;

  StrDispose(pStr);
end;

function TIdSSLContext.LoadKey: Boolean;
var
  pStr: PChar;
  error: Integer;
begin
  Result := True;

  pStr := StrNew(PChar(fsKeyFile));
  error := IdSslCtxUsePrivateKeyFile(
    fContext,
    pStr,
    OPENSSL_SSL_FILETYPE_PEM);

  if error <= 0 then
  begin
    Result := False;
  end
  else
  begin
    error := IdSslCtxCheckPrivateKeyFile(fContext);
    if error <= 0 then
    begin
      Result := False;
    end;
  end;

  StrDispose(pStr);
end;

function TIdSSLContext.LoadOpenSLLibrary: Boolean;
begin
  if not IdSSLOpenSSLHeaders.Load then
  begin
    Result := False;
    Exit;
  end;

  IdSslRandScreen;
  IdSslLoadErrorStrings;

  result := IdSslAddSslAlgorithms > 0;
end;

procedure TIdSSLContext.SetMode(const Value: TIdSSLMode);
var
  Amethod: PSSL_METHOD;
  error: Integer;
begin
  if fMode = Value then
  begin
    exit;
  end;
  fMode := Value;

  DestroyContext;

  if fMode <> sslmUnassigned then
  begin
    Amethod := InternalGetMethod;

    fContext := IdSslCtxNew(Amethod);
    if fContext = nil then
    begin
//      raise EIdOSSLCreatingContextError.Create(RSSSLCreatingContextError);
    end;

    IdSslCtxSetDefaultPasswdCb(fContext, @PasswordCallback);
    IdSslCtxSetDefaultPasswdCbUserdata(fContext, @self);

    if RootCertFile <> '' then
    begin
      if not LoadRootCert then
      begin
//        raise EIdOSSLLoadingRootCertError.Create(RSSSLLoadingRootCertError);
      end;
    end;

    if CertFile <> '' then
    begin
      if not LoadCert then
      begin
//        raise EIdOSSLLoadingCertError.Create(RSSSLLoadingCertError);
      end;
    end;

    if KeyFile <> '' then
    begin
      if not LoadKey then
      begin
//        raise EIdOSSLLoadingKeyError.Create(RSSSLLoadingKeyError);
      end;
    end;

    if StatusInfoOn then
    begin
      IdSslCtxSetInfoCallback(fContext, PFunction(@InfoCallback));
    end;

    error := IdSslCtxSetCipherList(fContext, OPENSSL_SSL_DEFAULT_CIPHER_LIST);
    if error <= 0 then
    begin
//      raise EIdOSSLSettingCipherError.Create(RSSSLSettingChiperError);
    end;

    if VerifyOn then
    begin
//      SetVerifyMode(fVerifyMode);
    end;
  end;
end;

procedure TIdSSLContext.UnLoadOpenSLLibrary;
begin
  IdSSLOpenSSLHeaders.Unload;
end;

//constructor TIdSSLSocket.Create(Parent: TObject);
function NewIdSSLSocket(Parent: PObj):PIdSSLSocket;
begin
New( Result, Create );
with Result^ do
begin
//  fParent := Parent;
end;
end;

destructor TIdSSLSocket.Destroy;
begin
  if fSSL <> nil then
  begin
    IdSslSetShutdown(fSSL, OPENSSL_SSL_SENT_SHUTDOWN);
    IdSslShutdown(fSSL);
    IdSslFree(fSSL);
    fSSL := nil;
  end;
  inherited;
end;

procedure TIdSSLSocket.Accept(const pHandle: TIdStackSocketHandle; fSSLContext:
  PIdSSLContext{TIdSSLContext});
var
  err: Integer;
begin
  fSSL := IdSslNew(fSSLContext.fContext);
  if fSSL = nil then exit;

  if IdSslSetAppData(fSSL, @self) <= 0 then
  begin
//    raise EIdOSSLDataBindingError.Create(RSSSLDataBindingError);
    exit;
  end;

  IdSslSetFd(fSSL, pHandle);
  err := IdSslAccept(fSSL);
  if err <= 0 then
  begin
//    raise EIdOSSLAcceptError.Create(RSSSLAcceptError);
  end;
end;

procedure TIdSSLSocket.Connect(const pHandle: TIdStackSocketHandle; fSSLContext:
  PIdSSLContext{TIdSSLContext});
var
  error: Integer;
begin
  fSSL := IdSslNew(fSSLContext.fContext);
  if fSSL = nil then exit;

  if IdSslSetAppData(fSSL, @self) <= 0 then
  begin
//    raise EIdOSSLDataBindingError.Create(RSSSLDataBindingError);
    exit;
  end;

  IdSslSetFd(fSSL, pHandle);
  error := IdSslConnect(fSSL);
  if error <= 0 then
  begin
//    raise EIdOSSLConnectError.Create(RSSSLConnectError);
  end;
end;

function TIdSSLSocket.GetPeerCert: PObj;//TIdX509;
var
  X509: PX509;
begin
  if fPeerCert = nil then
  begin
    X509 := IdSslGetPeerCertificate(fSSL);
    if X509 <> nil then
    begin
      fPeerCert := NewIdX509(X509);//TIdX509.Create(X509);
    end;
  end;
  Result := fPeerCert;
end;

function TIdSSLSocket.GetSessionID: TByteArray;
var
  pSession: PSSL_SESSION;
  tmpArray: TByteArray;
begin
  Result.Length := 0;
  FillChar(tmpArray, SizeOf(TByteArray), 0);
  if fSSL <> nil then
  begin
    pSession := IdSslGetSession(fSSL);
    if pSession <> nil then
    begin
      IdSslSessionGetId(pSession, @tmpArray.Data, @tmpArray.Length);
      Result := tmpArray;
    end;
  end;
end;

function TIdSSLSocket.GetSessionIDAsString: string;
var
  Data: TByteArray;
  i: Integer;
begin
  Result := '';
  Data := GetSessionID;
  for i := 0 to Data.Length - 1 do
  begin
    Result := Result + Format('%.2x', [Byte(Data.Data[I])]); {do not localize}
  end;
end;

procedure TIdSSLSocket.SetCipherList(CipherList: string);
begin
end;

function TIdX509Name.CertInOneLine: string;
var
  AOneLine: array[0..2048] of Char;
begin
  /// ????????????????????????????????????
  if FX509Name = nil then
  begin
    Result := '';
  end
  else
  begin
    Result := StrPas(IdSslX509NameOneline(FX509Name, PChar(@AOneLine),
      sizeof(AOneLine)));
  end;
end;

function TIdX509Name.GetHash: TULong;
begin
  if FX509Name = nil then
  begin
    FillChar(Result, SizeOf(Result), 0)
  end
  else
  begin
    Result.C1 := IdSslX509NameHash(FX509Name);
  end;
end;

function TIdX509Name.GetHashAsString: string;
begin
  Result := Format('%.8x', [Hash.L1]); {do not localize}
end;

//constructor TIdX509Name.Create(aX509Name: PX509_NAME);
function NewIdX509Name(aX509Name: PX509_NAME):PIdX509Name;
begin
  New( Result, Create );
with Result^ do
begin
//  inherited Create;

  FX509Name := aX509Name;
end;
end;

//constructor TIdX509.Create(aX509: PX509);
function NewIdX509(aX509: PX509):PIdX509;
begin
New( Result, Create );
with Result^ do
begin
//  inherited Create;

  FX509 := aX509;
  FSubject := nil;
  FIssuer := nil;
end;
end;

destructor TIdX509.Destroy;
begin
  if Assigned(FSubject) then FSubject.Destroy;
  if Assigned(FIssuer) then FIssuer.Destroy;

  inherited Destroy;
end;

function TIdX509.RSubject:PIdX509Name;// TIdX509Name;
var
  x509_name: PX509_NAME;
begin
  if not Assigned(FSubject) then
  begin
    if FX509 <> nil then
      x509_name := IdSslX509GetSubjectName(FX509)
    else
      x509_name := nil;
    FSubject := NewIdX509Name(x509_name);//TIdX509Name.Create(x509_name);
  end;
  Result := FSubject;
end;

function TIdX509.RIssuer: PIdX509Name;//TIdX509Name;
var
  x509_name: PX509_NAME;
begin
  if not Assigned(FIssuer) then
  begin
    if FX509 <> nil then
      x509_name := IdSslX509GetIssuerName(FX509)
    else
      x509_name := nil;
    FIssuer := NewIdX509Name(x509_name);//TIdX509Name.Create(x509_name);
  end;
  Result := FIssuer;
end;

function TIdX509.RFingerprint: TEVP_MD;
begin
  IdSslX509Digest(FX509, IdSslEvpMd5, PChar(@Result.MD), @Result.Length);
end;

function TIdX509.RFingerprintAsString: string;
var
  I: Integer;
  EVP_MD: TEVP_MD;
begin
  Result := '';
  EVP_MD := Fingerprint;
  for I := 0 to EVP_MD.Length - 1 do
  begin
    if I <> 0 then Result := Result + ':';
    Result := Result + Format('%.2x', [Byte(EVP_MD.MD[I])]); {do not localize}
  end;
end;

function UTCTime2DateTime(UCTTime: PASN1_UTCTIME): TDateTime;
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  min: Word;
  sec: Word;
  tz_h: Integer;
  tz_m: Integer;
begin
  Result := 0;
  if IdSslUCTTimeDecode(UCTTime, PUShort(@year), PUShort(@month), PUShort(@day),
    PUShort(@hour)
    , PUShort(@min), PUShort(@sec), IdSSLOpenSSLHeaders.PInteger(@tz_h)
    , IdSSLOpenSSLHeaders.PInteger(@tz_m)) > 0 then
  begin
    Result := EncodeDate(year, month, day) + EncodeTime(hour, min, sec, 0);
    AddMins(Result, tz_m);
    AddHrs(Result, tz_h);
    Result := GetLocalTime(Result);
  end;
end;

function TIdX509.RnotBefore: TDateTime;
begin
  if FX509 = nil then
    Result := 0
  else
    Result := UTCTime2DateTime(IdSslX509GetNotBefore(FX509));
end;

function TIdX509.RnotAfter: TDateTime;
begin
  if FX509 = nil then
    Result := 0
  else
    Result := UTCTime2DateTime(IdSslX509GetNotAfter(FX509));
end;

function NewIdSSLOptions:PIdSSLOptions;
begin
  New( Result, Create );
end;

function NewIdSSLContext:PIdSSLContext;
begin
  New( Result, Create );
end;


initialization

finalization
  UnLoadOpenSLLibrary;
end.
